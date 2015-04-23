#ifndef GLOBALFILELIST_H
#define GLOBALFILELIST_H

#include "SharedMemory.h"

typedef struct
{
  void* Next;
  HWND Window;
  char FilePath[ 256 ];
} TOpenFileEntry;

typedef TOpenFileEntry* TPOpenFileEntry;

typedef struct
{
  TSubAllocatedSharedMemory FMem;
  HMTX FMutex;
} TGlobalFilelist;


TGlobalFilelist* OpenGlobalFilelist();

void CloseGlobalFilelist( TGlobalFilelist* pList );

HWND FindFileInGlobalFilelist( TGlobalFilelist* pList, char* FilePath );

#endif

