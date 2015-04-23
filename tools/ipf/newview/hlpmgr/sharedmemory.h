#ifndef SHAREDMEMORY_H
#define SHAREDMEMORY_H


// Encapsulates a basic shared memory block. After creating,
// the Data pointer can be used to read or write the data
// in the memory.

typedef struct
{
  void* FPointer;
  BOOL FFirst; // true if this object created the shared mem block
} TSharedMemory;

APIRET GetSharedMemory( char* Name,
                        ULONG Size,
                        TSharedMemory* pSharedMemory );

void ReleaseSharedMemory( TSharedMemory* pSharedMemory );

// Encapsulates a shared memory block which can be suballocated
// into smaller areas.
// Allocate and Free are used to allocate these areas.
// A space can be reserved for using as a normal shared mem block.
// Otherwise the Data property should not be used.

typedef struct
{
  TSharedMemory FMem;
  void* FAllocationArea;
} TSubAllocatedSharedMemory;

APIRET GetSubAllocatedSharedMemory( char* Name,
                                    ULONG Size,
                                    ULONG ReserveSize, // size to reserve at start of memory
                                    TSubAllocatedSharedMemory* pSharedMemory );


// suballocate space of the given size
APIRET SubAllocate( TSubAllocatedSharedMemory* pSharedMemory,
                    ULONG Size,
                    void** p );


// free the given space.
void SubDeAllocate( TSubAllocatedSharedMemory* pSharedMemory,
                    void** p );


void ReleaseSubAllocatedSharedMemory( TSubAllocatedSharedMemory* pSharedMemory );


APIRET OpenOrCreateMutex( PSZ pszName, PHMTX phmtx );


#endif

