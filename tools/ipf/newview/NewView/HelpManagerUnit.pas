Unit HelpManagerUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

// Definitions affecting the interface with the new helpmgr.dll

Interface

uses
  PmWin;

const
  SharedMemSize = 16000; // space for messages: 16kB
  SharedMemReserveSize = 256;
  SharedMemName = 'NEWVIEW';
  SHARED_STRUCT_TITLE_SIZE = 32;
  SHARED_STRUCT_VERSION_SIZE = 32;
type
  TNewHelpMgrSharedStruct = record
    Title: array[ 0..SHARED_STRUCT_TITLE_SIZE - 1 ] of char;
    Version: array[ 0..SHARED_STRUCT_VERSION_SIZE - 1 ] of char;
  end;
  TPNewHelpMgrSharedStruct = ^TNewHelpMgrSharedStruct;

var
  // extract from shared memory once connected
  HelpManagerVersion: string;

const
  // External messages between helpmgr.dll and NewView
  WM_NEWHELPMGR            = WM_USER + 300;

  // sent by newview when startup is complete
  NHM_VIEWER_READY         = WM_NEWHELPMGR + 0;
    // Param1: viewer window handle

  NHM_HELP_CONTENTS        = WM_NEWHELPMGR + 1;

  NHM_HELP_INDEX           = WM_NEWHELPMGR + 2;

  NHM_TOPIC_BY_RESOURCE_ID = WM_NEWHELPMGR + 3;
    // Param1: resource id

  NHM_TEST                 = WM_NEWHELPMGR + 4;
    // Param1: ptr to text

  NHM_FORGET_VIEWER        = WM_NEWHELPMGR + 5;

  NHM_TOPIC_BY_PANEL_NAME  = WM_NEWHELPMGR + 6;
    // Param1: pointer to name in shared memory 

  NHM_SEARCH               = WM_NEWHELPMGR + 7;
    // Param1: pointer to text in shared memory 

  NHM_GLOBAL_SEARCH        = WM_NEWHELPMGR + 8;
    // Param1: pointer to text in shared memory

  NHM_SHOW_USAGE           = WM_NEWHELPMGR + 9;

  NHM_SET_FILES            = WM_NEWHELPMGR + 10;
    // Param1: pointer to filename(s) in shared memory

  NHM_SET_TITLE            = WM_NEWHELPMGR + 11;
    // Param1: pointer to title in shared memory

Implementation

Initialization
End.
