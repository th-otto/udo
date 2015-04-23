#ifndef MESSAGES_H
#define MESSAGES_H

#define WM_NEWHELPMGR            (WM_USER + 300)

#define NHM_VIEWER_READY         (WM_NEWHELPMGR + 0)
  // Param1: Viewer window handle

#define NHM_HELP_CONTENTS        (WM_NEWHELPMGR + 1)

#define NHM_HELP_INDEX           (WM_NEWHELPMGR + 2)

#define NHM_TOPIC_BY_RESOURCE_ID (WM_NEWHELPMGR + 3)
  // Param1: resource id

#define NHM_TEST                 (WM_NEWHELPMGR + 4) 
  // Param1: ptr to text

#define NHM_FORGET_VIEWER        (WM_NEWHELPMGR + 5)

#define NHM_TOPIC_BY_PANEL_NAME  (WM_NEWHELPMGR + 6)
  // Param1: pointer to name in shared memory

#define NHM_SEARCH               (WM_NEWHELPMGR + 7)
  // Param1: pointer to text in shared memory

#define NHM_GLOBAL_SEARCH        (WM_NEWHELPMGR + 8)
  // Param1: pointer to text in shared memory 

#define NHM_SHOW_USAGE           (WM_NEWHELPMGR + 9)

#define NHM_SET_FILES            (WM_NEWHELPMGR + 10)
  // Param1: pointer to filename(s) in shared memory

#define NHM_SET_TITLE            (WM_NEWHELPMGR + 11)
  // Param1: pointer to title in shared memory

#endif
