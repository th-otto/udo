#include <string.h>
#include <stdlib.h>

#define INCL_DOSERRORS
#define INCL_DOSSEMAPHORES
#define INCL_DOSPROCESS
#include <os2.h>

#include "GlobalFilelist.h"

// size of shared mem used for storing global filelist
#define GLOBAL_FILELIST_SIZE 64000

TGlobalFilelist* OpenGlobalFilelist()
{
  APIRET rc;
  TGlobalFilelist* pList;

  pList = (TGlobalFilelist*) malloc( sizeof( TGlobalFilelist ) );
  if ( pList == NULL ) 
    return NULL;

  rc = GetSubAllocatedSharedMemory( "NEWVIEW_GLOBAL_FILELIST",
                                    GLOBAL_FILELIST_SIZE,
                                    4, // space for head pointer
                                    & pList->FMem ); 
  if ( rc != 0 )
  {
    free( pList );
    return NULL;
  }

  rc = OpenOrCreateMutex( "NEWVIEW_FILELIST",
                          & pList->FMutex );
  if ( rc != 0 )
  {
    ReleaseSubAllocatedSharedMemory( & pList->FMem );
    free( pList );
    return NULL;
  }

  return pList;
}                                     

void CloseGlobalFilelist( TGlobalFilelist* pList )
{
  ReleaseSubAllocatedSharedMemory( & pList->FMem );
  DosCloseMutexSem( pList->FMutex );

  free( pList );
}

TPOpenFileEntry GetHead( TGlobalFilelist* pList )
{
  return (TPOpenFileEntry) pList->FMem.FMem.FPointer;
}

/*
procedure TGlobalFilelist.SetHead( pEntry: TPOpenFileEntry );
begin
  TPOpenFileEntry( FMem.Data ^ ) := pEntry;
end;

procedure TGlobalFilelist.AddFile( const FilePath: string;
                                   Window: HWND );
var
  pEntry: TPOpenFileEntry;
begin
  FMutex.Get;

  try
    FMem.Allocate( pEntry,
                   sizeof( TPOpenFileEntry )
                   + sizeof( HWND )
                   + 1  // string length byte
                   + Length( FilePath ) );
  except
    begin
      // didn't fit: discard
      FMutex.Release;
      exit;
    end;
  end;

  // store handle, filename
  pEntry ^. Window := Window;
  pEntry ^. FilePath := FilePath;
  
  // link into list at head
  pEntry ^. Next := GetHead;
  SetHead( pEntry );

  FMutex.Release;
end;
*/

TPOpenFileEntry FindEntry( TGlobalFilelist* pList,
                           char* FilePath )
{
  TPOpenFileEntry Result;

  Result = GetHead( pList );
  
  while ( Result != NULL ) 
  {
    if ( stricmp( Result->FilePath, FilePath ) ) 
    {
      // found
      return Result;
    }
    Result = Result->Next;
  }
  // not found
  return NULL;
}

HWND FindFileInGlobalFilelist( TGlobalFilelist* pList,
                               char* FilePath )
{
  TPOpenFileEntry pEntry;

  DosRequestMutexSem( pList->FMutex, SEM_INDEFINITE_WAIT );
  
  pEntry = FindEntry( pList, FilePath );
 
  DosReleaseMutexSem( pList->FMutex );

  if ( pEntry != NULL )
    return pEntry -> Window;
  else
    return NULLHANDLE;
}

/*
// Remove specified file from list
procedure TGlobalFilelist.RemoveFile( Window: HWND;
                                      const FilePath: string );
var
  pEntry: TPOpenFileEntry;
  pPrevious: TPOpenFileEntry;
begin
  FMutex.Get;

  pEntry := GetHead;
  pPrevious := nil;
  while ( pEntry <> nil ) do
  begin
    if ( pEntry ^. Window = Window ) then
    begin
      if ( StringsSame( pEntry ^. FilePath, FilePath ) ) then
      begin
        // found
        // remove node from list
        if pPrevious = nil then
          // head node has changed
          SetHead( pEntry ^.Next )
        else
          // point previous node to next node
          pPrevious ^.Next := pEntry ^.Next;

        FMem.Free( pEntry );

        // done
        FMutex.Release;
        exit;
      end;
    end;
    pPrevious := pEntry;
    pEntry := pEntry ^. Next;
  end;

  // not found! Bad programmer event
  FMutex.Release;

  raise Exception.Create( 'GlobalFilelist: File cannot be removed, since not added: ' + FilePath );
end;

procedure TGlobalFilelist.RemoveWindowFiles( Window: HWND );
var
  pEntry: TPOpenFileEntry;
  pPrevious: TPOpenFileEntry;
begin
  FMutex.Get;

  pEntry := GetHead;
  pPrevious := nil;
  while ( pEntry <> nil ) do
  begin
    if ( pEntry ^. Window = Window ) then
    begin
      // found
      // remove node from list
      if pPrevious = nil then
        // head node has changed
        SetHead( pEntry ^.Next )
      else
        // point previous node to next node
        pPrevious ^.Next := pEntry ^.Next;

      FMem.Free( pEntry );
      // continue looking - there could be more for this window
    end;
    pPrevious := pEntry;
    pEntry := pEntry ^. Next;
  end;
  FMutex.Release;
end;
*/
