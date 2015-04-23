#include <stdlib.h>
#include <string.h>

#include "HelpInstance.h"
#include "Viewer.h"
#include "log.h"

//--------------------------------------------------------------------------------
// Viewer handling
//--------------------------------------------------------------------------------


// Start the viewer if it's not already running
//--------------------------------------------------------------------------------
void EnsureViewerRunning( TPHelpInstance pHelpInstance )
{
  HWND FocusFrame;
  if ( ! pHelpInstance -> FViewerStarted )
  {
    // get focus frame
    FocusFrame = GetTopLevelWindow( WinQueryFocus( HWND_DESKTOP ) );
    // associate viewer with that.
    if ( ViewHelpFile( pHelpInstance -> FHelpFileNames,
                       pHelpInstance -> FHelpWindowTitle,
                       pHelpInstance -> FHandle,
                       FocusFrame,
                       pHelpInstance -> Fhab ) )
    {
      pHelpInstance -> FViewerStarted = TRUE;
    }
  }
}


// Send a message to the viewer. If it hasn't
// started yet, then queue the message.
//--------------------------------------------------------------------------------
void PostViewerMessage( TPHelpInstance pHelpInstance,
                        ULONG msg,
                        MPARAM mp1,
                        MPARAM mp2 )
{
  TQueuedViewerMessage ViewerMessage;
  BOOL ok;

  LogEvent( "PostViewerMessage: %d", msg );

  if ( ! pHelpInstance -> FViewerStarted )
  {
    // Presumably an error
    LogEvent( "  Viewer not started, discarding" );
    return;
  }

  if ( pHelpInstance -> FViewerWindow == NULLHANDLE )
  {
    // viewer isn't ready yet, so queue the message
    LogEvent( "  Queueing message" );

    if ( pHelpInstance -> FViewerStartupMessagesCount >= MAX_VIEWER_STARTUP_MESSAGES )
    {
      LogEvent( "    Out of queue space!" );
      return;
    }

    ViewerMessage.msg = msg;
    ViewerMessage.mp1 = mp1;
    ViewerMessage.mp2 = mp2;

    pHelpInstance -> FViewerStartupMessages[
      pHelpInstance -> FViewerStartupMessagesCount ] = ViewerMessage;
    pHelpInstance -> FViewerStartupMessagesCount ++;
    return;
  }

  ok = WinPostMsg( pHelpInstance -> FViewerWindow,
                   msg,
                   mp1,
                   mp2 );
  if ( ok )
    LogEvent( "  Posted OK" );
  else
    LogEvent( "  WinPostMsg failed" );
}


// Post messages to the viewer that have been
// queued up waiting for it to complete startup
//--------------------------------------------------------------------------------
void PostQueuedViewerMessages( TPHelpInstance pHelpInstance )
{
  int i;
  TQueuedViewerMessage ViewerMessage;

  for ( i = 0; i < pHelpInstance -> FViewerStartupMessagesCount; i ++ )
  {
    ViewerMessage = pHelpInstance -> FViewerStartupMessages[ i ];

    LogEvent( "  Posting queued message" );
    WinSendMsg( pHelpInstance -> FViewerWindow,
                ViewerMessage.msg,
                ViewerMessage.mp1,
                ViewerMessage.mp2 );

  }

  pHelpInstance -> FViewerStartupMessagesCount = 0;
}


void CloseViewer( TPHelpInstance pHelpInstance )
{
  LogEvent( "    Close viewer" );
  if ( pHelpInstance -> FViewerStarted )
  {
    LogEvent( "      Viewer started, closing" );
    PostViewerMessage( pHelpInstance, WM_CLOSE, 0, 0 );
  }
}


//--------------------------------------------------------------------------------
// Window Association
//--------------------------------------------------------------------------------

// Add the given window to the list of associated
// windows for this help instance
//--------------------------------------------------------------------------------
void AssociateWindow( TPHelpInstance pHelpInstance,
                      HWND hwnd )
{
  LogEvent( "AssociateWindow: %8x with instance %8x",
            hwnd,
            pHelpInstance );

  if ( IsWindowAssociated( pHelpInstance, hwnd ) )
  {
    LogEvent( "Already associated" );
    return;
  }

  if ( pHelpInstance -> FNumApplicationWindows == 0 )
  {
    LogEvent( "  First window being associated" );

    // this is the first window to be associated
/*
    if ( pHelpInstance -> FActiveWindow == NULLHANDLE )
    {
      // an "active" window has not yet been set. Use this one
      LogEvent( "    Setting active window" );
      pHelpInstance -> FActiveWindow = hwnd;
    }
*/
  }

  // see if it will fit.
  if (    pHelpInstance -> FNumApplicationWindows
       >= pHelpInstance -> FMaxApplicationWindows )
  {
    // need more space.
    if ( pHelpInstance -> FMaxApplicationWindows == 0 )
      // first time
      pHelpInstance -> FMaxApplicationWindows = 4;
    else
      // double space
      pHelpInstance -> FMaxApplicationWindows *= 2;

    LogEvent( "AssociateWIndow: allocating list space to %d",
              pHelpInstance -> FMaxApplicationWindows );

    // reallocate memory.
    pHelpInstance -> FApplicationWindows
      = (HWND*) realloc( pHelpInstance -> FApplicationWindows,
                         pHelpInstance -> FMaxApplicationWindows
                         * sizeof( HWND ) );
  }

  pHelpInstance ->
    FApplicationWindows[ pHelpInstance -> FNumApplicationWindows ]
      = hwnd;

  pHelpInstance -> FNumApplicationWindows ++;

  LogEvent( "AssociateWindow: Now have %d windows associated",
            pHelpInstance -> FNumApplicationWindows );
}


// Removes the given window from the list of associated
// windows for this help instance (if present)
//--------------------------------------------------------------------------------
void RemoveAssociatedWindow( TPHelpInstance pHelpInstance,
                             HWND hwnd )
{
  int i;
  int j;

  i = 0;
  while ( i < pHelpInstance -> FNumApplicationWindows )
  {
    if ( pHelpInstance -> FApplicationWindows[ i ] == hwnd )
    {
      // found one, copy remaining elements down by one
      j = i;
      while( j < pHelpInstance -> FNumApplicationWindows - 1 )
      {
        pHelpInstance -> FApplicationWindows[ j ]
          = pHelpInstance -> FApplicationWindows[ j + 1 ];
        j ++;
      }
      pHelpInstance -> FNumApplicationWindows --;
    }
    else
    {
      // not a match - next please
      i ++;
    }
  }
}


// Returns true if the given window is associated with
// the given help instance
//--------------------------------------------------------------------------------
BOOL IsWindowAssociated( TPHelpInstance pHelpInstance,
                         HWND hwnd )
{
  int i;

  for ( i = 0; i < pHelpInstance -> FNumApplicationWindows; i ++ )
  {
    if ( pHelpInstance -> FApplicationWindows[ i ] == hwnd )
      // found
      return TRUE;
  }
  // not found
  return FALSE;
}


//--------------------------------------------------------------------------------
// Help instance
//--------------------------------------------------------------------------------


// return the HelpInstance with the given handle
//--------------------------------------------------------------------------------
TPHelpInstance GetHelpInstance( HWND hwnd )
{
  ULONG ulInstance;
  ULONG ulMagicNumber;

  ulMagicNumber = WinQueryWindowULong( hwnd, QWL_HELPINSTANCEMAGICNUMBER );

  if ( ulMagicNumber != HELPINSTANCEMAGICNUMBER )
    return NULL;

  ulInstance = WinQueryWindowULong( hwnd, QWL_HELPINSTANCEPTR );

  return (TPHelpInstance) ulInstance;
}


//--------------------------------------------------------------------------------
void ReleaseHelpTable( TPHelpInstance pHelpInstance )
{
  if ( pHelpInstance -> pHelpTable )
    // no table loaded
    return;

  if ( pHelpInstance -> HelpTableFromResource )
    // free copy of resource
    FreeHelpTable( & ( pHelpInstance -> pHelpTable ) );
}


//--------------------------------------------------------------------------------
TPHelpInstance MakeNewHelpInstance()
{
  TPHelpInstance pHelpInstance;

  pHelpInstance = (TPHelpInstance) malloc( sizeof( THelpInstance ) );
  memset( pHelpInstance, 0, sizeof( THelpInstance ) );

  // window list will be allocated on first association
  pHelpInstance -> FNumApplicationWindows = 0;
  pHelpInstance -> FMaxApplicationWindows = 0;
  pHelpInstance -> FApplicationWindows = NULL;

  pHelpInstance -> FActiveWindow = NULLHANDLE;

  return pHelpInstance;
}

