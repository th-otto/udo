#ifndef UTILITY_H
#define UTILITY_H

// Platform
#define INCL_WINBASE
#define INCL_TYPES
#define INCL_WINHOOKS
#define INCL_WINERRORS
#define INCL_WINHELP
#define INCL_WINWINDOWMGR
#define INCL_WINFRAMEMGR
#define INCL_WININPUT
#define INCL_WINSTDBOOK
#define INCL_WINDIALOGS
#define INCL_DDF
#define INCL_DOSMISC
#define INCL_DOSMODULEMGR
#define INCL_DOSPROCESS
#include <os2.h>

// Gets system boot drive as a letter
char GetBootDrive();

// Gets current process filename
void GetApplicationFilename( char* Buffer, ULONG BufferLength );

// Returns the top level parent of given window
HWND GetTopLevelWindow( HWND hwnd );

// Returns true if the given window has the
// given standard class (e.g. WC_FRAME)
BOOL IsStandardWindowClass( HWND hwnd, PSZ ClassID );

// make a memory copy of the given source string into
// dest. Accepts NULLs for either parameter.
void StoreString( char** dest,
                  char* source );

#endif

