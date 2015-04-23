// Standard library
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

// Local
#include "utility.h"
#include "Viewer.h"
#include "log.h"
#include "messages.h"
#include "HelpTables.h"
#include "SharedMemory.h"
#include "HelpInstance.h"

#if __WATCOMC__>=1200

      /*** HK_HELP Help modes **********************************************/
      #define HLPM_FRAME              (-1)
      #define HLPM_WINDOW             (-2)
      #define HLPM_MENU               (-3)

#endif

//--------------------------------------------------------------------------------
// Constants
//--------------------------------------------------------------------------------

char*   HelpMgrVersion = "V1.9.1"; // $SS_REQUIRE_NEW_VERSION$
#define BldLevelVersion   "1.9.1"

// Embedded BLDLevel compatible version
#define Vendor "Aaron Lawrence"
#define Description "NewView"

char* EmbeddedVersion = "@#" Vendor ":" BldLevelVersion "#@" Description;

//--------------------------------------------------------------------------------

#define MAX_HELP_INSTANCES 100
#define SHARED_MEM_SIZE 16000
#define SHARED_MEM_RESERVE_SIZE 256
#define SHARED_MEM_NAME "NEWVIEW"

char* szNewHelpManagerClass = "NewHelpMgr";

//--------------------------------------------------------------------------------
// Types
//--------------------------------------------------------------------------------

typedef struct
{
  char Title[ 32 ];
  char Version[ 32 ];
} TNewHelpMgrSharedStruct;

//--------------------------------------------------------------------------------
// Global variables
//--------------------------------------------------------------------------------

TPHelpInstance g_pHelpInstances[ MAX_HELP_INSTANCES ] = { NULL };
int g_HelpInstanceCount = 0;

//

MRESULT APIENTRY HelpManagerWndProc( HWND hwnd,
                                     ULONG msg,
                                     MPARAM mp1,
                                     MPARAM mp2 );

BOOL APIENTRY HelpHook( HAB hab,
                        ULONG ulMode,
                        ULONG ulControlID,
                        ULONG ulChildControlID,
                        PRECTL prcPosition );


// Find if there is a help instance associated with
// this window
//--------------------------------------------------------------------------------
TPHelpInstance GetAssociatedHelpInstance( HWND hwnd )
{
  int i;
  TPHelpInstance pHelpInstance;

  LogEvent( "  GetAssociatedHelpInstance" );

  for ( i = 0; i < MAX_HELP_INSTANCES; i ++ )
  {
    pHelpInstance = g_pHelpInstances[ i ];
    if ( pHelpInstance != NULL )
    {
      LogEvent( "    Instance %d: %8x", i, pHelpInstance );
      if ( IsWindowAssociated( pHelpInstance,
                               hwnd ) )
      {
        LogEvent( "      Found associated window" );
        return pHelpInstance;
      }
    }
  }

  return NULL;
}

// Find if there is a help instance associated with
// this window or any of it's parents or owners
//--------------------------------------------------------------------------------
TPHelpInstance GetHelpInstanceForWindowChain( HWND hwndApp )
{
  HWND parentOrOwner;
  HWND hDesktopWindow;
  HWND hwnd;
  HWND hClientWnd;
  TPHelpInstance pHelpInstance;
  LONG SearchType;

  LogEvent( "QueryHelpInstance" );

  hDesktopWindow = WinQueryDesktopWindow( WinQueryAnchorBlock( hwndApp ),
                                          NULLHANDLE );

  SearchType = QW_PARENT;
  hwnd = hwndApp;
  while( TRUE )
  {
    LogEvent( "  hwnd: %8x", hwnd );
    pHelpInstance = GetAssociatedHelpInstance( hwnd );
    if ( pHelpInstance )
    {
      LogEvent( "  Found help instance: %8x", pHelpInstance );
      return pHelpInstance;
    }

    LogEvent( "    Check if frame" );
    if ( IsStandardWindowClass( hwnd, WC_FRAME ) )
    {
      LogEvent( "      This is a frame window" );
      hClientWnd = WinWindowFromID( hwnd, FID_CLIENT );
      if ( hClientWnd != NULLHANDLE )
      {
        LogEvent( "      Got client window: %8x", hClientWnd );
        pHelpInstance = GetAssociatedHelpInstance( hClientWnd );
        if ( pHelpInstance )
        {
          LogEvent( "        Found help instance: %8x", pHelpInstance );
          return pHelpInstance;
        }
      }
      else
      {
        LogEvent( "      No client window found" );
      }
    }

    LogEvent( "  No help instance" );

    parentOrOwner = WinQueryWindow( hwnd, SearchType );
    if (    parentOrOwner == hDesktopWindow
         || parentOrOwner == NULLHANDLE )
    {
      // swap to other search
      if ( SearchType == QW_PARENT )
      {
        LogEvent( "  Search by owner" );
        SearchType = QW_OWNER;
      }
      else
      {
        LogEvent( "  Search by parent" );
        SearchType = QW_PARENT;
      }

      parentOrOwner = WinQueryWindow( hwnd, SearchType );
      if (    parentOrOwner == hDesktopWindow
           || parentOrOwner == NULLHANDLE )
        // the other relation is also the desktop, so stop.
      {
        break;
      }
    }
    hwnd = parentOrOwner;
  }

  LogEvent( "  No help instance found" );
  return NULL;
}

//--------------------------------------------------------------------------------
// 32 bit entry points
//--------------------------------------------------------------------------------

HWND APIENTRY NHM32CreateHelpInstance( HAB hab,
                                       PHELPINIT phinitHMInitStructure )
{
  BOOL FoundUnusedSlot;
  ULONG HelpTable;
  USHORT idHelpTable;
  APIRET rc;
  int i;
  TPHelpInstance pHelpInstance;
  TNewHelpMgrSharedStruct* pSharedStruct;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "NHM32CreateHelpInstance" );
  LogEvent( "  Help Manager Version: %s", HelpMgrVersion );
  LogEvent( "  Filename(s): %s", phinitHMInitStructure -> pszHelpLibraryName );
  LogEvent( "  Title: %s",       phinitHMInitStructure -> pszHelpWindowTitle );

  pHelpInstance = MakeNewHelpInstance();

  // find blank slot in help instance array
  FoundUnusedSlot = FALSE;
  for ( i = 0; i < MAX_HELP_INSTANCES; i ++ )
  {
    if ( g_pHelpInstances[ i ] == NULL )
    {
      g_pHelpInstances[ i ] = pHelpInstance;
      FoundUnusedSlot = TRUE;
      break;
    }
  }
  if ( ! FoundUnusedSlot )
  {
    LogEvent( "Too many help instances, out of slots" );
    return NULLHANDLE;
  }

  g_HelpInstanceCount ++;

  pHelpInstance -> Fhab = hab;

  // Register help window class.
  if ( ! WinRegisterClass( hab,                   // anchor block
                           szNewHelpManagerClass, // class name
                           HelpManagerWndProc,    // window proceedure
                           0,                     // no special style
                           8 ) )                  // space for instance ptr and magic number
  {
    rc = WinGetLastError( hab );
    LogEvent( "WinRegisterClass failed, error=%d", rc );
    return NULLHANDLE;
  }

  LogEvent( "Registered Window Class OK" );

  // Create help window as an object window (child of HWND_OBJECT)
  pHelpInstance -> FHandle =
    WinCreateWindow( HWND_OBJECT,           // parent: object window
                     szNewHelpManagerClass, // window class
                     "New Help Manager",    // window title - irrelevant
                     0,                     // style: none (note: invisible)
                     0, 0, 10, 10,          // left/bottom/width/height - irrelevant
                     HWND_OBJECT,           // owner: object window
                     HWND_BOTTOM,           // zorder - irrelevant
                     1,                     // id - irrelevant
                     NULL,                  // control data - none
                     NULL );                // presentation parameters - none

  if ( pHelpInstance -> FHandle == NULLHANDLE )
  {
    rc = WinGetLastError( hab );
    LogEvent( "WinCreateWindow failed, error=%d", rc );
    return NULLHANDLE;
  }
  LogEvent( "Created Help Window OK" );

  // store instance pointer and magic number for checking later.
  // Could just have used class name!
  WinSetWindowULong( pHelpInstance -> FHandle,
                     QWL_HELPINSTANCEMAGICNUMBER,
                     HELPINSTANCEMAGICNUMBER );
  WinSetWindowULong( pHelpInstance -> FHandle,
                     QWL_HELPINSTANCEPTR,
                     (ULONG) pHelpInstance );

  LogEvent( "Stored magic number and instance ptr OK" );

  // Copy filename(s), if given
  StoreString( & pHelpInstance -> FHelpFileNames,
               phinitHMInitStructure -> pszHelpLibraryName );

  // Copy help window title, if given
  StoreString( & pHelpInstance -> FHelpWindowTitle,
               phinitHMInitStructure -> pszHelpWindowTitle );

  LogEvent( "Setting hook" );

  // set hook for catching F1 keypresses & help buttons
  if ( ! WinSetHook( hab,              // Anchor block
                     HMQ_CURRENT,      // Message queue: this app's queue
                     HK_HELP,          // Hook type: help
                     (PFN) & HelpHook, // Help hook function
                     0 ) )             // Module containing hook function
  {
    rc = WinGetLastError( hab );
    LogEvent( "WinSetHook failed, error=%d", rc );
    return NULLHANDLE;
  }

  // load help table if specified
  HelpTable = (ULONG) phinitHMInitStructure -> phtHelpTable;
  LogEvent( "HelpTable: %8x", HelpTable );

  pHelpInstance -> HelpTableFromResource = FALSE;

  if ( HelpTable != 0 )
  {
    if ( ( HelpTable & 0xffff0000 ) == 0xffff0000 )
    {
      // resource ID specified
      idHelpTable = HelpTable; // truncate to USHORT
      LogEvent( "  Loading from resource" );
      LoadHelpTableFromResource( &( pHelpInstance -> pHelpTable ),
                                 phinitHMInitStructure -> hmodHelpTableModule,
                                 idHelpTable );
      pHelpInstance -> HelpTableFromResource = TRUE;
    }
    else
    {
      // memory help table
      LogEvent( "  Loading from memory" );
      pHelpInstance -> pHelpTable = (PHELPTABLE) HelpTable;
    }
  }
  else
  {
    pHelpInstance -> pHelpTable = NULL;
  }

  pHelpInstance -> FViewerStarted = FALSE;
  pHelpInstance -> FViewerWindow = NULLHANDLE;
  pHelpInstance -> FViewerStartupMessagesCount = 0;

  LogEvent( "  Allocating shared memory: %s", SHARED_MEM_NAME );
  rc = GetSubAllocatedSharedMemory( SHARED_MEM_NAME,
                                    SHARED_MEM_SIZE,
                                    SHARED_MEM_RESERVE_SIZE,
                                    & pHelpInstance -> SharedMemory );
  if ( rc != 0 )
  {
    LogEvent( "Could not allocate shared mem, rc = %d", rc );
    return NULLHANDLE;
  }
  pSharedStruct =
    (TNewHelpMgrSharedStruct*) pHelpInstance -> SharedMemory.FMem.FPointer;

  strcpy( pSharedStruct -> Title, "NewView Help Manager" );
  strcpy( pSharedStruct -> Version, HelpMgrVersion );

  phinitHMInitStructure -> ulReturnCode = 0;

  LogEvent( "Success!" );
  LogEvent( "  Instance: %8x", (ULONG) pHelpInstance );
  LogEvent( "  Handle: %8x", pHelpInstance -> FHandle );

  return pHelpInstance -> FHandle;
}

void DestroyHelpInstance( TPHelpInstance pHelpInstance )
{
  int i;

  LogEvent( "  Closing viewer" );
  CloseViewer( pHelpInstance );

  LogEvent( "  Destroying help window" );
  WinDestroyWindow( pHelpInstance -> FHandle );

  LogEvent( "  Freeing help tables" );
  ReleaseHelpTable( pHelpInstance );

  LogEvent( "  Releasing shared memory" );
  ReleaseSubAllocatedSharedMemory( & pHelpInstance -> SharedMemory );

  // remove from list
  for ( i = 0; i < MAX_HELP_INSTANCES; i ++ )
    if ( g_pHelpInstances[ i ] == pHelpInstance )
      g_pHelpInstances[ i ] = NULL;
  g_HelpInstanceCount --;

  free( pHelpInstance );

  LogEvent( "  Done" );
}

BOOL APIENTRY NHM32DestroyHelpInstance( HWND hwndHelpInstance )
{
  TPHelpInstance pHelpInstance;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "NHM32DestroyHelpInstance" );

  LogEvent( "  Help Instance Handle: %8x", hwndHelpInstance );

  pHelpInstance = GetHelpInstance( hwndHelpInstance );

  if ( pHelpInstance == NULL )
  {
    LogEvent( "  Not a valid help manager window" );
    return FALSE;
  }
  LogEvent( "  Help Instance: %8x", (ULONG) pHelpInstance );

  DestroyHelpInstance( pHelpInstance );

  return TRUE;
}

HWND APIENTRY NHM32QueryHelpInstance( HWND hwndApp )
{
  TPHelpInstance pHelpInstance;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "NHM32QueryHelpInstance" );

  pHelpInstance = GetHelpInstanceForWindowChain( hwndApp );

  if ( pHelpInstance )
    return pHelpInstance -> FHandle;

  return NULLHANDLE;
}

BOOL APIENTRY NHM32AssociateHelpInstance( HWND hwndHelpInstance,
                                          HWND hwndApp )
{
  int i;
  TPHelpInstance pHelpInstance;
  char buffer[ 32 ];

  LogEvent( "--------------------------------------------------" );
  LogEvent( "NHM32AssociateHelpInstance" );

  LogEvent( "  Help Instance Handle: %8x", hwndHelpInstance );
  LogEvent( "  Window: %8x", hwndApp );

  // Notify the window (Only required by SmartSuite?)
  WinSendMsg( hwndApp,
              WM_SETHELPINFO,
              (MPARAM) hwndHelpInstance,
              0 );
  // Note this call seems to fail on some apps, so ignore result

  if ( hwndHelpInstance == NULLHANDLE )
  {
    // clearing association with this window.
    LogEvent( "  Help Instance NULLHANDLE, clearing" );

    for ( i = 0; i < MAX_HELP_INSTANCES; i ++ )
    {
      pHelpInstance = g_pHelpInstances[ i ];
      if ( pHelpInstance != NULL )
      {
        RemoveAssociatedWindow( pHelpInstance,
                                hwndApp );
      }
    }

    return TRUE;
  }

  if ( WinQueryWindowText( hwndApp, sizeof( buffer ), buffer ) )
    LogEvent( "  Window Title: %s", buffer );
  else
    LogEvent( "  Window Title: Blank/invalid" );

  pHelpInstance = GetHelpInstance( hwndHelpInstance );
  if ( pHelpInstance == NULL )
  {
    LogEvent( "  Not a valid help manager window" );
    return FALSE;
  }

  LogEvent( "  Help Instance: %8x", (ULONG) pHelpInstance );

  LogEvent( "  OK" );
  AssociateWindow( pHelpInstance, hwndApp );

  return TRUE;
}

BOOL APIENTRY NHM32LoadHelpTable( HWND hwndHelpInstance,
                                  ULONG idHelpTable,
                                  HMODULE Module )
{
  TPHelpInstance pHelpInstance;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "NHM32LoadHelpTable" );

  pHelpInstance = GetHelpInstance( hwndHelpInstance );
  if ( pHelpInstance == NULL )
  {
    LogEvent( "  Not a valid help manager window" );
    return FALSE;
  }

  ReleaseHelpTable( pHelpInstance );

  LoadHelpTableFromResource( &( pHelpInstance -> pHelpTable ),
                             Module,
                             idHelpTable );

  return TRUE;
}

BOOL APIENTRY NHM32CreateHelpTable( HWND hwndHelpInstance,
                                    PHELPTABLE phtHelpTable )
{
  TPHelpInstance pHelpInstance;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "NHM32CreateHelpTable" );

  LogEvent( "  Help Instance Handle: %8x", hwndHelpInstance );
  LogEvent( "  Help Table: %8x", phtHelpTable );

  pHelpInstance = GetHelpInstance( hwndHelpInstance );
  if ( pHelpInstance == NULL )
  {
    LogEvent( "  Not a valid help manager window" );
    return FALSE;
  }
  LogEvent( "  Help Instance: %8x", pHelpInstance );

  LogEvent( "  Freeing existing table" );
  ReleaseHelpTable( pHelpInstance );

  LogEvent( "  Loading table from memory" );
  pHelpInstance -> pHelpTable = phtHelpTable;

  return TRUE;
}

//--------------------------------------------------------------------------------
// 16 bit entry points
//--------------------------------------------------------------------------------

// Portions contributed by Aaron Reed at IBM

// typedef void _Far16 * HWND16;
typedef HWND HWND16;
typedef USHORT BOOL16;
typedef char _Far16 * PSZ16;
typedef USHORT HMODULE16;

// by default 32-bit code is double word aligned in their structures.  Gotta
// make this word (2 bytes) aligned for this structure to work.  Thus the
// pragma pack
#pragma pack(2)

typedef struct _HELPTABLE16
{
    USHORT        idAppWindow;
    PHELPSUBTABLE phstHelpSubTable;
    USHORT        idExtPanel;

} HELPTABLE16, _Far16 *PHELPTABLE16;

typedef struct _HELPINIT16
{
    USHORT       cb;
    ULONG        ulReturnCode;
    PSZ16        pszTutorialName;
    ULONG        phtHelpTable;
    HMODULE16    hmodHelpTableModule;
    HMODULE16    hmodAccelActionBarModule;
    USHORT       idAccelTable;
    USHORT       idActionBar;
    PSZ16        pszHelpWindowTitle;
    USHORT       usShowPanelId;
    PSZ16        pszHelpLibraryName;

} HELPINIT16, _Far16 *PHELPINIT16;

#pragma pack()

HWND16 APIENTRY16 NHM16CreateHelpInstance( HAB hab,
                                           PHELPINIT16 phinitHMInitStructure )
{
  HELPINIT    helpinit;
  HWND        hInstance;
  ULONG       HelpTable;

  LogEvent( "NHM16CreateHelpInstance" );

  if ( !phinitHMInitStructure )
  {
    // no init structure
    LogEvent( "  Null init structure pointer, fail" );
    return NULLHANDLE;
  }

  LogEvent( "  Copying structure to 32 bit" );

  // Copy 16 bit structure to 32 bit
  memset( &helpinit, 0, sizeof( helpinit ) );

  helpinit.pszTutorialName = (PSZ) phinitHMInitStructure -> pszTutorialName;

  HelpTable = (ULONG) phinitHMInitStructure -> phtHelpTable;
  LogEvent( "    Help Table: %8x", HelpTable );
  if ( HelpTable )
  {
    if ( ( HelpTable & 0xffff0000 ) == 0xffff0000 )
    {
      // an ID, so copy literally.
      LogEvent( "    Copying as ID" );
      helpinit.phtHelpTable = (PHELPTABLE) HelpTable;
    }
    else
    {
      // It's a pointer, so convert 16->32
      LogEvent( "    Converting pointer" );
      helpinit.phtHelpTable =
        (PHELPTABLE) (PHELPTABLE16) HelpTable;
    }
  }

  helpinit.hmodHelpTableModule =
    (HMODULE) phinitHMInitStructure -> hmodHelpTableModule;
  helpinit.pszHelpWindowTitle =
    (PSZ) phinitHMInitStructure -> pszHelpWindowTitle;
  helpinit.pszHelpLibraryName =
    (PSZ) phinitHMInitStructure -> pszHelpLibraryName;

  LogEvent( "  Conversions done, calling 32 bit" );

  hInstance = NHM32CreateHelpInstance( hab, &helpinit );

  LogEvent( "  32 bit returned, copying result code" );

  // copy return code back
  phinitHMInitStructure -> ulReturnCode = helpinit.ulReturnCode;

  LogEvent( "  rc: %u", phinitHMInitStructure -> ulReturnCode );
  LogEvent( "  Done" );

  return (HWND16) hInstance;
}

BOOL16 APIENTRY16 NHM16DestroyHelpInstance( HWND16 hwndHelpInstance )
{
  LogEvent( "NHM16DestroyHelpInstance" );
  return NHM32DestroyHelpInstance( (HWND) hwndHelpInstance );
}

HWND16 APIENTRY16 NHM16QueryHelpInstance( HWND16 hwndApp )
{
  LogEvent( "NHM16QueryHelpInstance" );
  return (HWND16) NHM32QueryHelpInstance( (HWND) hwndApp );
}

BOOL16 APIENTRY16 NHM16AssociateHelpInstance( HWND16 hwndHelpInstance,
                                              HWND16 hwndApp )
{
  LogEvent( "NHM16AssociateHelpInstance" );
  return NHM32AssociateHelpInstance( (HWND) hwndHelpInstance,
                                     (HWND) hwndApp );
}

BOOL16 APIENTRY16 NHM16LoadHelpTable( HWND16 hwndHelpInstance,
                                      USHORT idHelpTable,
                                      HMODULE16 Module )
{
  LogEvent( "NHM16QueryHelpInstance" );
  return NHM32LoadHelpTable( (HWND) hwndHelpInstance,
                             idHelpTable,
                             (HMODULE) Module );
}

BOOL16 APIENTRY16 NHM16CreateHelpTable( HWND16 hwndHelpInstance,
                                        PHELPTABLE phtHelpTable )
{
  LogEvent( "NHM16QueryHelpInstance" );

  LogEvent( "  Not supported. Fail" );

  // this is tricky because we would have to copy the 16 bit
  // table (pointers) to a 32 bit variant...
  return FALSE;

  //  return NHM32CreateHelpTable( hwndHelpInstance,
  //                               phtHelpTable );
}

//--------------------------------------------------------------------------------

// Get the application window currently set for the help instance
// either the set active window, or the first associated window if no active window
HWND GetAppWindow( TPHelpInstance pHelpInstance )
{
  HWND result;

  result = pHelpInstance -> FActiveWindow;
  if ( result != NULLHANDLE )
    return result;

  if ( pHelpInstance -> FNumApplicationWindows == 0 )
    return NULLHANDLE;

  return pHelpInstance -> FApplicationWindows[ 0 ];
}

BOOL FindHelpTopic( TPHelpInstance pHelpInstance,
                    USHORT WindowID,
                    USHORT ControlID,
                    USHORT ChildControlID,
                    USHORT* pHelpPanelID,
                    ULONG Mode ) // mode only used for passing to app window
{
  USHORT ExtendedHelpPanelID;
  PHELPSUBTABLE2 pHelpSubTable;
  HWND hAppWindow;

  hAppWindow = GetAppWindow( pHelpInstance );

  if ( ! FindIDInHelpTable( WindowID,
                            pHelpInstance -> pHelpTable,
                            & ExtendedHelpPanelID,
                            & pHelpSubTable ) )
  {
    LogEvent( "  No match found in help table" );

    if ( hAppWindow != NULLHANDLE )
    {
      LogEvent( "  Informing application: HM_HELPSUBITEM_NOT_FOUND" );
      // tell the app we didn't find the subitem in the help table
      WinSendMsg( hAppWindow,
                  HM_HELPSUBITEM_NOT_FOUND,
                  (MPARAM) Mode,
                  MPFROM2SHORT( ControlID, ChildControlID  ) );
    }

    return FALSE;
  }

  LogEvent( "  Help Subtable found for Window" );

  if ( pHelpSubTable == NULL )
  {
    LogEvent( "  No help subtable" );
    LogEvent( "  Use extended help panel %hu",
              ExtendedHelpPanelID );
    *pHelpPanelID = ExtendedHelpPanelID;
    return TRUE;
  }

  if ( ChildControlID != (USHORT) -1 )
  {
    // Child control -1 means not applicable (e.g. top level menu)
    if ( FindIDInHelpSubTable( ChildControlID,
                               pHelpSubTable,
                               pHelpPanelID ) )
    {
      LogEvent( "  Found Child Control ID, Panel: %hu",
                *pHelpPanelID );
      return TRUE;
    }
    LogEvent( "  Subtopic not found" );
  }
  else
  {
    LogEvent( "  Child Control -1: not applicable" );
  }

  // Child not found/not applicable, look for main control ID

  if ( FindIDInHelpSubTable( ControlID,
                             pHelpSubTable,
                             pHelpPanelID ) )
  {
    LogEvent( "  Found Control ID, Panel: %hu",
              *pHelpPanelID );
    return TRUE;
  }

  LogEvent( "  Control ID not found" );

  // Control not found, we can only show help for the
  // Window as a whole. First, see if the subtable
  // has an entry for the window
  if ( FindIDInHelpSubTable( WindowID,
                             pHelpSubTable,
                             pHelpPanelID ) )
  {
    LogEvent( "  Found Window ID in subtable, Panel: %hu",
              *pHelpPanelID );
    return TRUE;
  }

  // No, just use extended help panel
  LogEvent( "  Window ID not found in subtable" );
  LogEvent( "  Use extended help panel %hu",
            ExtendedHelpPanelID );
  *pHelpPanelID = ExtendedHelpPanelID;

  return TRUE;
}

//--------------------------------------------------------------------------------
// Help Hook function
//
// installed during WinCreateHelpInstance
//
// This function is called by the standard OS/2 windows on
// WM_HELP messages.
//
// Notes:
//   The parameters are ULONG but passed from USHORTs
//   if the originating program was 16 bit (AFAIK).
//   So I just cast them to USHORTs
//--------------------------------------------------------------------------------
BOOL APIENTRY HelpHook( HAB hab,
                        ULONG ulMode,
                        ULONG ulControlID,
                        ULONG ulChildControlID,
                        PRECTL prcPosition )
{
  USHORT WindowID;
  USHORT PanelID;
  HWND hFocusFrame;
  HWND hFocusWindow;
  TPHelpInstance pHelpInstance;
  USHORT ControlID;
  USHORT ChildControlID;
  USHORT Mode;

  ControlID = (USHORT) ulControlID;
  ChildControlID = (USHORT) ulChildControlID;
  Mode = (USHORT) ulMode;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "HelpHook" );

  hFocusWindow = WinQueryFocus( HWND_DESKTOP );
  hFocusFrame = GetTopLevelWindow( hFocusWindow );

  LogEvent( "  Focus Window: %8x", hFocusWindow );
  LogEvent( "  Focus Frame: %8x", hFocusFrame );

  WindowID = WinQueryWindowUShort( hFocusFrame, QWS_ID );

  LogEvent( "  Focus Frame ID: %d", WindowID );

  pHelpInstance = GetHelpInstanceForWindowChain( hFocusWindow );

  if ( pHelpInstance == NULL )
  {
    LogEvent( "  No matching help instance found" );
    LogEvent( "  Picking first one" );
    if ( g_HelpInstanceCount == 0 )
    {
      LogEvent( "    No instances present" );
      return TRUE;
    }
    pHelpInstance = g_pHelpInstances[ 0 ];
  }

  switch( Mode )
  {
    case HLPM_MENU:
      LogEvent( "  Menu Mode" );
      LogEvent( "  Frame: %x", hFocusFrame );
      break;

    case HLPM_FRAME:
      LogEvent( "  Frame Mode" );
      WindowID = ControlID;
      break;

    case HLPM_WINDOW:
      LogEvent( "  Window Mode" );

      if ( pHelpInstance -> FActiveWindow != NULLHANDLE )
      {
        // override if active window set.
        WindowID = WinQueryWindowUShort( pHelpInstance -> FActiveWindow,
                                         QWS_ID );
        LogEvent( "    Active window set; overriding, Window ID: %d", WindowID );
      }
      break;

    default:
      LogEvent( "  Unknown Mode %8hx", Mode );
  }
  LogEvent( "  Control ID:    %hu", (USHORT) ControlID );
  LogEvent( "  Child Control ID: %hu", (USHORT) ChildControlID );

  if ( pHelpInstance -> pHelpTable == NULL )
  {
    LogEvent( "  No Help Table loaded for instance" );
    return TRUE;
  }

  if ( ! FindHelpTopic( pHelpInstance,
                        WindowID,
                        ControlID,
                        ChildControlID,
                        & PanelID,
                        ulMode ) )

  {
    return TRUE;
  }

  LogEvent( "Displaying panel: %hu", PanelID );

  EnsureViewerRunning( pHelpInstance );
  PostViewerMessage( pHelpInstance,
                     NHM_TOPIC_BY_RESOURCE_ID,
                     (MPARAM) PanelID,
                     0 );

  return FALSE; // next hook in chain not required
}

//--------------------------------------------------------------------------------
// Help Window procedure
//--------------------------------------------------------------------------------

MRESULT APIENTRY HelpManagerWndProc( HWND hwnd,
                                     ULONG msg,
                                     MPARAM mp1,
                                     MPARAM mp2 )
{
  USHORT PanelID;
  char buffer[ 256 ];

  PHELPSUBTABLE2 pHelpSubTable;
  USHORT idExtendedHelpPanel;
  USHORT WindowID;
  HWND hFrameWindow;
  HWND hActiveWindow;
  TPHelpInstance pHelpInstance;
  APIRET rc;
  char* PanelName;
  char* pMessageMem;
  HWND hAppWindow;

  if (    msg == WM_CREATE
       || msg == WM_DESTROY
       || msg == WM_ADJUSTWINDOWPOS )
    // ignore window management messages
    return 0;

  if (    msg >= WM_USER
       && msg != NHM_VIEWER_READY
       && msg != NHM_FORGET_VIEWER )
    // ignore these - somebody sends em, I dunno why
    return 0;

  LogEvent( "--------------------------------------------------" );
  LogEvent( "HelpManagerWndProc" );
  LogEvent( "  Window: %8x", hwnd );

  pHelpInstance = GetHelpInstance( hwnd );
  if ( pHelpInstance == NULL )
  {
    LogEvent( "  Not a valid help manager window" );
    LogEvent( "  Picking first help instance" );
    if ( g_HelpInstanceCount == 0 )
    {
      LogEvent( "    No instances present" );
      return 0;
    }
    pHelpInstance = g_pHelpInstances[ 0 ];
  }

  hAppWindow = GetAppWindow( pHelpInstance );

  LogEvent( "  HelpInstance: %8x", (ULONG) pHelpInstance );
  LogEvent( "  Message:      %8x", msg );
  LogEvent( "  App Window:   %8x", (ULONG) hAppWindow );

  switch( msg )
  {
    case HM_HELP_CONTENTS:
      LogEvent( "HM_HELP_CONTENTS" );
      EnsureViewerRunning( pHelpInstance );
      PostViewerMessage( pHelpInstance,
                         NHM_HELP_CONTENTS,
                         0,
                         0 );
      break;

    case HM_HELP_INDEX:
      LogEvent( "HM_HELP_INDEX" );
      EnsureViewerRunning( pHelpInstance );
      PostViewerMessage( pHelpInstance,
                         NHM_HELP_INDEX,
                         0,
                         0 );
      break;

    case HM_DISPLAY_HELP:
      LogEvent( "  HM_DISPLAY_HELP" );
      switch( (ULONG) mp2 )
      {
        case HM_RESOURCEID:
          // is it a pointer or a ushort? Seems it can be either!
          if ( (ULONG) mp1 & 0xffff0000 )
            PanelID = * ( (PUSHORT) mp1 );
          else
            PanelID = (USHORT) mp1;

          LogEvent( "  Resource ID: %hu", PanelID );
          // Note: 0 indicates Help for "Using Help"
          if ( PanelID == 0 )
          {
            LogEvent( "    ID is 0: Help on Help/Using Help" );
            ViewHelpOnHelp( pHelpInstance -> Fhab );
          }
          else
          {
            EnsureViewerRunning( pHelpInstance );
            PostViewerMessage( pHelpInstance,
                               NHM_TOPIC_BY_RESOURCE_ID,
                               (MPARAM) PanelID,
                               0 );
          }
          break;

        case HM_PANELNAME:
          PanelName = (char*) mp1;
          LogEvent( "  Panel Name: %s", PanelName );
          EnsureViewerRunning( pHelpInstance );
          rc = SubAllocate( & pHelpInstance -> SharedMemory,
                            strlen( PanelName ) + 1,
                            & pMessageMem );
          strcpy( pMessageMem, PanelName );
          PostViewerMessage( pHelpInstance,
                             NHM_TOPIC_BY_PANEL_NAME,
                             (MPARAM) pMessageMem,
                             0 );

          break;
      }

      break;

    case HM_GENERAL_HELP:  // == HM_EXT_HELP
      LogEvent( "HM_GENERAL_HELP (== HM_EXT_HELP)" );
      EnsureViewerRunning( pHelpInstance );

      // find active window
      hFrameWindow = GetTopLevelWindow( WinQueryFocus( HWND_DESKTOP ) );

      // get ID
      WindowID = WinQueryWindowUShort( hFrameWindow, QWS_ID );

      LogEvent( "  Window ID: %hu", WindowID );

      if ( ! FindIDInHelpTable( WindowID,
                                pHelpInstance -> pHelpTable,
                                & idExtendedHelpPanel,
                                & pHelpSubTable ) )
      {
        LogEvent( "  No helptable entry found" );
        return 0;
      }
      PostViewerMessage( pHelpInstance,
                         NHM_TOPIC_BY_RESOURCE_ID,
                         (MPARAM) idExtendedHelpPanel,
                         0 );
      break;

    case HM_KEYS_HELP:
      LogEvent( "HM_KEYS_HELP" );
      if ( hAppWindow == NULLHANDLE )
      {
        LogEvent( "  No app windows; can't ask for keys help topic" );
        return 0;
      }
      PanelID =
        (USHORT) WinSendMsg( hAppWindow,
                             HM_QUERY_KEYS_HELP,
                             0,
                             0 );
      LogEvent( "  Keys help topic: %d", PanelID );
      if ( PanelID != 0 )
      {
        EnsureViewerRunning( pHelpInstance );
        PostViewerMessage( pHelpInstance,
                           NHM_TOPIC_BY_RESOURCE_ID,
                           (MPARAM) PanelID,
                           0 );
      }

      break;

    case HM_DISMISS_WINDOW:
      LogEvent( "HM_DISMISS_WINDOW" );
      CloseViewer( pHelpInstance );
      break;

    case HM_SET_ACTIVE_WINDOW:
      LogEvent( "HM_SET_ACTIVE_WINDOW" );
      hActiveWindow = (HWND) mp1;
      LogEvent( "  New active window: %8x", (ULONG) hActiveWindow );
      WinQueryWindowText( hActiveWindow, sizeof( buffer ), buffer );
      LogEvent( "  Window Title: %s", buffer );

      pHelpInstance -> FActiveWindow = hActiveWindow;
      LogEvent( "  OK" );
      break;

    case HM_SET_HELP_LIBRARY_NAME:
      LogEvent( "HM_SET_HELP_LIBRARY_NAME" );
      LogEvent( "  Filename(s): %s", (char*) mp1 );
      StoreString( & pHelpInstance -> FHelpFileNames,
                   (char*) mp1 );
      if ( pHelpInstance -> FViewerStarted )
      {
        rc = SubAllocate( & pHelpInstance -> SharedMemory,
                          strlen( mp1 ) + 1,
                          & pMessageMem );
        pMessageMem[ 0 ] = 0; // init string, since ModifyFilenames appends.
        ModifyFilenames( mp1, pMessageMem );
        PostViewerMessage( pHelpInstance,
                           NHM_SET_FILES,
                           pMessageMem,
                           0 );
      }
      break;

    case HM_SET_HELP_WINDOW_TITLE:
      LogEvent( "HM_SET_HELP_WINDOW_TITLE" );
      LogEvent( "  Title: %s", (char*) mp1 );
      StoreString( & pHelpInstance -> FHelpWindowTitle,
                   (char*) mp1 );
      if ( pHelpInstance -> FViewerStarted )
      {
        rc = SubAllocate( & pHelpInstance -> SharedMemory,
                          strlen( mp1 ) + 1,
                          & pMessageMem );
        strcpy( pMessageMem, mp1 ),
        PostViewerMessage( pHelpInstance,
                           NHM_SET_TITLE,
                           pMessageMem,
                           0 );
      }
      break;

    case HM_LOAD_HELP_TABLE:
      LogEvent( "HM_LOAD_HELP_TABLE" );
      NHM32LoadHelpTable( pHelpInstance -> FHandle,
                          SHORT1FROMMP( mp1 ),
                          (HMODULE) mp2 );
      break;

    case HM_CREATE_HELP_TABLE:
      LogEvent( "HM_CREATE_HELP_TABLE" );
      NHM32CreateHelpTable( pHelpInstance -> FHandle,
                            (PHELPTABLE) mp1 );
      break;

    case NHM_VIEWER_READY:
      // viewer notifying us it has started up OK
      LogEvent( "Viewer ready" );
      // save viewer window handle
      pHelpInstance -> FViewerWindow = (HWND) mp1;
      PostQueuedViewerMessages( pHelpInstance );
      break;

    case NHM_FORGET_VIEWER:
      // viewer notifying us it is now doing something else
      // ie loaded another file.
      LogEvent( "Forget viewer" );
      pHelpInstance -> FViewerStarted = FALSE;
      pHelpInstance -> FViewerWindow = NULLHANDLE;
      break;

/*
// This is worse han useless because View.exe
   is just the stub and will always exit immediately.
    case WM_APPTERMINATENOTIFY:
      // viewer has stopped
      LogEvent( "Viewer has stopped" );
      pHelpInstance -> FViewerStarted = FALSE;
      pHelpInstance -> FViewerWindow = NULLHANDLE;
      LogEvent( "  Exit Code: %d",
                mp2 );
      break;
*/

    // not supported
    case HM_SET_SHOW_PANEL_ID: // original debugging aid, redundant
      LogEvent( "  Ignoring unsupported: HM_SET_SHOW_PANEL_ID" );
      break;

    case HM_REPLACE_USING_HELP:
      LogEvent( "  Ignoring unsupported: HM_REPLACE_USING_HELP" );
      break;

    case HM_SET_OBJCOM_WINDOW:
      LogEvent( "  Ignoring unsupported: HM_SET_OBJCOM_WINDOW" );
      break;

    case HM_UPDATE_OBJCOM_WINDOW_CHAIN:
      LogEvent( "  Ignoring unsupported: HM_UPDATE_OBJCOM_WINDOW_CHAIN" );
      break;

    case HM_QUERY_DDF_DATA:
      LogEvent( "  Ignoring unsupported: HM_QUERY_DDF_DATA" );
      break;

    case HM_INVALIDATE_DDF_DATA:
      LogEvent( "  Ignoring unsupported: HM_INVALIDATE_DDF_DATA" );
      break;

    case HM_QUERY:
      LogEvent( "  HM_QUERY" );
      LogEvent( "    SelectionID: %d", SHORT1FROMMP( mp1 )  );
      LogEvent( "    MessageID: %d", SHORT2FROMMP( mp1 )  );
      LogEvent( "    Param: %08X", mp2 );
      if ( SHORT2FROMMP( mp1 ) == 1 )
      {
        // this is the only one we can sort of do, maybe
        return (MRESULT) hwnd;
      }
      else
      {
        LogEvent( "    This MessageID not supported" );
      }
      break;

    case HM_SET_COVERPAGE_SIZE: // ignore, user controls window size buddy
      LogEvent( "  Ignoring unsupported: HM_SET_COVERPAGE_SIZE" );
      break;

    default:
      LogEvent( "  Unrecognised Message: %x", msg );
  }

  return 0;
}

void CloseAllInstances( void )
{
  int i;
  TPHelpInstance pHelpInstance;

  LogEvent( "CloseAllInstances" );
  for ( i = 0; i < MAX_HELP_INSTANCES; i ++ )
  {
    pHelpInstance = g_pHelpInstances[ i ];
    if ( pHelpInstance != NULL )
    {
      LogEvent( "    %8x (handle: %8x) active, destroying",
                pHelpInstance,
                pHelpInstance -> FHandle );
      DestroyHelpInstance( pHelpInstance );
    }
  }
}

// int
void p_dll_terminate( void )
{
  char ApplicationFilename[ 257 ];

//  stoplog();

  LogEvent( "--------------------------------------------------" );

  GetApplicationFilename( ApplicationFilename,
                          sizeof( ApplicationFilename ) );

  LogEvent( "p_dll_terminate: %s",
            ApplicationFilename );

  CloseAllInstances();
//  return 1;
}


int __dll_initialize( void )
{
  char ApplicationFilename[ 257 ];

  LogEvent( "--------------------------------------------------" );

  GetApplicationFilename( ApplicationFilename,
                          sizeof( ApplicationFilename ) );

  LogEvent( "__dll_initialize: %s",
            ApplicationFilename );

  atexit( p_dll_terminate );
  return 1;
}

// Blank LibMain - required to get Watcom initialise
// runtime library properly.
// Tested - still required on Watcom 11.0c, OW 1.0, 1.1, 1.2rc3
// NOTE! This function DOES NOT get called
unsigned LibMain( unsigned hmod, unsigned termination )
{
  return 1;
}
