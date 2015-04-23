#include <stdlib.h>
#include <string.h>

#include "Utility.h"
#include "log.h"

char GetBootDrive()
{
  ULONG buffer;
  DosQuerySysInfo( QSV_BOOT_DRIVE,
                   QSV_BOOT_DRIVE,
                   & buffer,
                   sizeof( buffer ) );
  return 'A' + buffer - 1;
}

void GetApplicationFilename( char* Buffer, ULONG BufferLength )
{
  PTIB pThreadInfo;
  PPIB pProcessInfo;

  DosGetInfoBlocks( & pThreadInfo,
                    & pProcessInfo );
  DosQueryModuleName( pProcessInfo -> pib_hmte,
                      BufferLength,
                      Buffer );
}

// Returns the top level parent of given window
//--------------------------------------------------------------------------------
HWND GetTopLevelWindow( HWND hwnd )
{
  HWND parent;
  HWND hDesktopWindow;
  HAB hab;

  hab = WinQueryAnchorBlock( hwnd );
  hDesktopWindow = WinQueryDesktopWindow( hab, NULLHANDLE );

  while( TRUE )
  {
    parent = WinQueryWindow( hwnd, QW_PARENT );
    if (    parent == hDesktopWindow
         || parent == NULLHANDLE )
      // this is a frame (top level) window
      break;
    hwnd = parent;
  }

  return hwnd;
}

// Returns true if the given window has the
// given standard class (e.g. WC_FRAME)
//--------------------------------------------------------------------------------
BOOL IsStandardWindowClass( HWND hwnd, PSZ ClassID )
{
  char szClassName[ 256 ];
  USHORT usClass;

  LogEvent( "IsStandardWindowClass" );

  if ( WinQueryClassName( hwnd,
                          sizeof( szClassName ),
                          szClassName ) == 0 )
    // not a valid window
    return FALSE;

  LogEvent( "  Valid window" );

  if ( szClassName[ 0 ] != '#' )
    // not a standard class
    return FALSE;

  LogEvent( "  Is standard class" );

  // Predefined class
  usClass = atoi( szClassName + 1 );

  LogEvent( "  usClass: %hu", usClass );
  LogEvent( "  Match class: %hu", (USHORT) ClassID );

  return usClass == (USHORT) ClassID;
}

void StoreString( char** dest, char* source )
{
  if ( *dest != NULL )
  {
    free( *dest );
    *dest = NULL;
  }

  if ( source == NULL )
    return;

  *dest = (char*) malloc( strlen( source ) + 1 );
  strcpy( *dest, source );
}

