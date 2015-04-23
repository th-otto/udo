#include <stdio.h>
#include <string.h>

#define INCL_DOSERRORS
#define INCL_DOSSEMAPHORES
#define INCL_DOSPROCESS
#include <os2.h>

#include "SharedMemory.h"
#include "Log.h"

APIRET GetSharedMemory( char* Name,
                        ULONG Size,
                        TSharedMemory* pSharedMemory )
{
  APIRET rc;
  char FullName[ 260 ];

  pSharedMemory -> FFirst = TRUE;

  strcpy( FullName, "\\SHAREMEM\\" );
  strcat( FullName, Name );

  LogEvent( "Full shared mem name: %s", FullName );
  rc = DosAllocSharedMem( & pSharedMemory -> FPointer,
                          FullName,
                          Size,
                          PAG_READ | PAG_WRITE | PAG_COMMIT );

  if ( rc != 0 )
  {
    LogEvent( "  Unable to create shared mem: %d", rc );
    if ( rc == ERROR_ALREADY_EXISTS )
    {
      LogEvent( "  - Already exists, open" );
      // memory already exists, just get it
      pSharedMemory -> FFirst = FALSE;
      rc = DosGetNamedSharedMem( & pSharedMemory -> FPointer,
                                 FullName,
                                 PAG_READ | PAG_WRITE );
      LogEvent( "    rc = %d", rc );
    }
  }

  return rc;
}

APIRET OpenOrCreateMutex( PSZ pszName,
                          PHMTX phmtx )
{
  int Tries;
  APIRET rc;

  Tries = 0;
  while( TRUE )
  {
    rc = DosOpenMutexSem( pszName,
                          phmtx );

    if ( rc != ERROR_SEM_NOT_FOUND )
      // ok, or some error
      break;

    rc = DosCreateMutexSem( pszName,
                            phmtx,
                            0,
                            FALSE );
    if ( rc != ERROR_DUPLICATE_NAME )
      // ok, or some error
      break;

    Tries ++;
    if ( Tries > 100 )
      // prevent an infinite loop in the extreme case
      break;

    // try again
    DosSleep( 1 );
  }

  return rc;
}

void ReleaseSharedMemory( TSharedMemory* pSharedMemory )
{
  DosFreeMem( pSharedMemory -> FPointer ); // will free the shared mem once nobody has a ref.
  pSharedMemory -> FPointer = NULL;
}

APIRET GetSubAllocatedSharedMemory( char* Name,
                                    ULONG Size,
                                    ULONG ReserveSize, // size to reserve at start of memory
                                    TSubAllocatedSharedMemory* pSharedMemory )
{
  APIRET rc;
  ULONG ActualSize;
  ULONG ActualReserveSize;
  ULONG Flags;
  HMTX StartupSemaphore;
  char SemaphoreName[ 260 ];

  LogEvent( "GetSubAllocatedSharedMemory" );

  ActualSize = Size;
  if ( ActualSize < 256 )
    ActualSize = 256; // make sure the suballoc info will fit.

  // Ensure that only one process inits the suballocation

  strcpy( SemaphoreName, "\\SEM32\\" );
  strcat( SemaphoreName, Name );

  LogEvent( "  semaphore name: %s", SemaphoreName );

  rc = OpenOrCreateMutex( SemaphoreName,
                          & StartupSemaphore );
  if ( rc != 0 )
  {
    DosReleaseMutexSem( StartupSemaphore ); // why release here??
    DosCloseMutexSem( StartupSemaphore );
    LogEvent( "  Semaphore failure: %d", rc );
    return rc;
  }

  LogEvent( "  Semaphore opened OK" );

  DosRequestMutexSem( StartupSemaphore, SEM_INDEFINITE_WAIT );

  rc = GetSharedMemory( Name,
                        ActualSize,
                        & ( pSharedMemory -> FMem ) );

  if ( rc != 0 )
  {
    LogEvent( "  GetSharedMemory failed: %d", rc );
    DosReleaseMutexSem( StartupSemaphore );
    DosCloseMutexSem( StartupSemaphore );
    return rc;
  }
  LogEvent( "  GetSharedMemory success" );

  // round reserve size up to nearest 8 bytes
  ActualReserveSize = ( ( ReserveSize + 7 ) / 8 ) * 8;

  if ( ActualReserveSize >= ActualSize )
  {
    LogEvent( "Assertion failure: reserve size larger than total shared mem size!" );
    DosReleaseMutexSem( StartupSemaphore );
    DosCloseMutexSem( StartupSemaphore );
    return ERROR_INVALID_PARAMETER;
  }

  pSharedMemory -> FAllocationArea =
    (PBYTE) pSharedMemory -> FMem.FPointer
    + ActualReserveSize;

  Flags = DOSSUB_SERIALIZE;
  if ( pSharedMemory -> FMem.FFirst )
  {
    // Initialise reserved area to zero
    memset( pSharedMemory -> FMem.FPointer, 0, ActualReserveSize );
    Flags = Flags | DOSSUB_INIT;
    // otherwise just attach
  }

  // set up suballocation, with serialisation for multi-process access
  rc = DosSubSetMem( pSharedMemory -> FAllocationArea,
                     Flags,
                     ActualSize - ActualReserveSize );

  if ( rc == 0 )
    LogEvent( "  Suballocation initialised OK" );
  else
    LogEvent( "  Error initialising Suballocation: ", rc );

  DosReleaseMutexSem( StartupSemaphore );
  DosCloseMutexSem( StartupSemaphore );

  return rc;
}

// suballocate space of the given size
APIRET SubAllocate( TSubAllocatedSharedMemory* pSharedMemory,
                    ULONG Size,
                    void** p )
{
  APIRET rc;
  PULONG pSize;

  rc = DosSubAllocMem( pSharedMemory -> FAllocationArea,
                       p,
                       Size + sizeof( ULONG ) );
  if ( rc != 0 )
    return rc;

  // Store size at start of block
  pSize = (PULONG) *p;
  *pSize = Size;

  *p = (PBYTE) (*p) + sizeof( ULONG );

  return rc;
}

// free the given space.
void SubDeallocate( TSubAllocatedSharedMemory* pSharedMemory,
                    void** p )
{
  APIRET rc;
  PULONG pSize;
  ULONG Size;

  // retrieve size from start of block
  *p = (PBYTE) (*p) - sizeof( ULONG );
  pSize = (PULONG) *p;
  Size = *pSize;

  rc = DosSubFreeMem( pSharedMemory -> FAllocationArea,
                      p,
                      Size );

  *p = NULL;
}

void ReleaseSubAllocatedSharedMemory( TSubAllocatedSharedMemory* pSharedMemory )
{
  //  DosSubUnsetMem( pSharedMemory -> FAllocationArea );
  // to do this requires manual reference counting
  // it's easy just to not worry and the suballoc stuff
  // will be freed when the shared memory is freed
  pSharedMemory -> FAllocationArea = NULL;
  ReleaseSharedMemory( & pSharedMemory -> FMem );
}

