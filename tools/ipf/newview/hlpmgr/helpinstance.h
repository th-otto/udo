#ifndef HELPINSTANCE_H
#define HELPINSTANCE_H

#include "Utility.h"
#include "HelpTables.h"
#include "SharedMemory.h"

#define MAX_VIEWER_STARTUP_MESSAGES 100

#define QWL_HELPINSTANCEPTR 0

// offset into window data
#define QWL_HELPINSTANCEMAGICNUMBER 4
#define HELPINSTANCEMAGICNUMBER 0x7af3b2ea

typedef struct
{
  ULONG msg;
  MPARAM mp1;
  MPARAM mp2;
} TQueuedViewerMessage;

// Main help instance structure
typedef struct
{
  HWND FHandle; // help window - receives messages from app
 
  HAB Fhab; // application anchor block

  HWND* FApplicationWindows;
  int FNumApplicationWindows; // current number of windows in use.
  int FMaxApplicationWindows; // current size of array

  HWND FActiveWindow;

  char* FHelpFileNames;
  char* FHelpWindowTitle;

  BOOL FViewerStarted;
  HWND FViewerWindow;

  TQueuedViewerMessage FViewerStartupMessages[ MAX_VIEWER_STARTUP_MESSAGES ];
  int FViewerStartupMessagesCount;

  // main help table: an array of entries,
  // one for each main app window. Each entry
  // specifies a help subtable and an "extended help" panel
  PHELPTABLE pHelpTable; 
  BOOL HelpTableFromResource;
    
  TSubAllocatedSharedMemory SharedMemory;

} THelpInstance;
typedef THelpInstance* TPHelpInstance;

//--------------------------------------------------------------------------------

// Start the viewer if it's not already running
void EnsureViewerRunning( TPHelpInstance pHelpInstance );

// Send a message to the viewer. If it hasn't
// started yet, then queue the message.
void PostViewerMessage( TPHelpInstance pHelpInstance,
                        ULONG msg,
                        MPARAM mp1,
                        MPARAM mp2 );

// Post messages to the viewer that have been
// queued up waiting for it to complete startup
void PostQueuedViewerMessages( TPHelpInstance pHelpInstance );

void CloseViewer( TPHelpInstance pHelpInstance );

//--------------------------------------------------------------------------------

// Add the given window to the list of associated 
// windows for this help instance
void AssociateWindow( TPHelpInstance pHelpInstance,
                      HWND hwnd );

void RemoveAssociatedWindow( TPHelpInstance pHelpInstance,
                             HWND hwnd );

// Returns true if the given window is associated with
// the given help instance
BOOL IsWindowAssociated( TPHelpInstance pHelpInstance,
                         HWND hwnd );

//--------------------------------------------------------------------------------

// return the HelpInstance with the given handle
TPHelpInstance GetHelpInstance( HWND hwnd );

void ReleaseHelpTable( TPHelpInstance pHelpInstance );

TPHelpInstance MakeNewHelpInstance();

#endif
