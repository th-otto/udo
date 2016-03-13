enum {
    HHWIN_NAVTAB_TOP,
    HHWIN_NAVTAB_LEFT,
    HHWIN_NAVTAB_BOTTOM,
};

enum {
    HH_TAB_CONTENTS,
    HH_TAB_INDEX,
    HH_TAB_SEARCH,
    HH_TAB_FAVORITES,
    HH_TAB_HISTORY,
    HH_TAB_AUTHOR,

    HH_TAB_CUSTOM_FIRST = 11,
    HH_TAB_CUSTOM_LAST = 19,
    HH_MAX_TABS = HH_TAB_CUSTOM_LAST
};


enum {
    HHWIN_NAVTYPE_TOC,
    HHWIN_NAVTYPE_INDEX,
    HHWIN_NAVTYPE_SEARCH,
    HHWIN_NAVTYPE_FAVORITES,
    HHWIN_NAVTYPE_HISTORY,   /* not implemented */
    HHWIN_NAVTYPE_AUTHOR,
    HHWIN_NAVTYPE_CUSTOM_FIRST = 11
};

#define HHWIN_PROP_TAB_AUTOHIDESHOW (1l << 0)    /* Automatically hide/show tri-pane window */
#define HHWIN_PROP_ONTOP            (1l << 1)    /* Top-most window */
#define HHWIN_PROP_NOTITLEBAR       (1l << 2)    /* no title bar */
#define HHWIN_PROP_NODEF_STYLES     (1l << 3)    /* no default window styles (only HH_WINTYPE.dwStyles) */
#define HHWIN_PROP_NODEF_EXSTYLES   (1l << 4)    /* no default extended window styles (only HH_WINTYPE.dwExStyles) */
#define HHWIN_PROP_TRI_PANE         (1l << 5)    /* use a tri-pane window */
#define HHWIN_PROP_NOTB_TEXT        (1l << 6)    /* no text on toolbar buttons */
#define HHWIN_PROP_POST_QUIT        (1l << 7)    /* post WM_QUIT message when window closes */
#define HHWIN_PROP_AUTO_SYNC        (1l << 8)    /* automatically sync contents and index */
#define HHWIN_PROP_TRACKING         (1l << 9)    /* send tracking notification messages */
#define HHWIN_PROP_TAB_SEARCH       (1l << 10)   /* include search tab in navigation pane */
#define HHWIN_PROP_TAB_HISTORY      (1l << 11)   /* include history tab in navigation pane */
#define HHWIN_PROP_TAB_FAVORITES    (1l << 12)   /* include favorites tab in navigation pane */
#define HHWIN_PROP_CHANGE_TITLE     (1l << 13)   /* Put current HTML title in title bar */
#define HHWIN_PROP_NAV_ONLY_WIN     (1l << 14)   /* Only display the navigation window */
#define HHWIN_PROP_NO_TOOLBAR       (1l << 15)   /* Don't display a toolbar */
#define HHWIN_PROP_MENU             (1l << 16)   /* Menu */
#define HHWIN_PROP_TAB_ADVSEARCH    (1l << 17)   /* Advanced FTS UI. */
#define HHWIN_PROP_USER_POS         (1l << 18)   /* After initial creation, user controls window size/position */
#define HHWIN_PROP_TAB_CUSTOM1      (1l << 19)   /* Use custom tab #1 */
#define HHWIN_PROP_TAB_CUSTOM2      (1l << 20)   /* Use custom tab #2 */
#define HHWIN_PROP_TAB_CUSTOM3      (1l << 21)   /* Use custom tab #3 */
#define HHWIN_PROP_TAB_CUSTOM4      (1l << 22)   /* Use custom tab #4 */
#define HHWIN_PROP_TAB_CUSTOM5      (1l << 23)   /* Use custom tab #5 */
#define HHWIN_PROP_TAB_CUSTOM6      (1l << 24)   /* Use custom tab #6 */
#define HHWIN_PROP_TAB_CUSTOM7      (1l << 25)   /* Use custom tab #7 */
#define HHWIN_PROP_TAB_CUSTOM8      (1l << 26)   /* Use custom tab #8 */
#define HHWIN_PROP_TAB_CUSTOM9      (1l << 27)   /* Use custom tab #9 */
#define HHWIN_PROP_TB_MARGIN        (1l << 28)   /* the window type has a margin */

#define HHWIN_PARAM_NAME            (1l << 0)    /* valid pszType */
#define HHWIN_PARAM_PROPERTIES      (1l << 1)    /* valid fsWinProperties */
#define HHWIN_PARAM_STYLES          (1l << 2)    /* valid dwStyles */
#define HHWIN_PARAM_EXSTYLES        (1l << 3)    /* valid dwExStyles */
#define HHWIN_PARAM_RECT            (1l << 4)    /* valid rcWindowPos */
#define HHWIN_PARAM_NAV_WIDTH       (1l << 5)    /* valid iNavWidth */
#define HHWIN_PARAM_SHOWSTATE       (1l << 6)    /* valid nShowState */
#define HHWIN_PARAM_INFOTYPES       (1l << 7)    /* valid apInfoTypes */
#define HHWIN_PARAM_TB_FLAGS        (1l << 8)    /* valid fsToolBarFlags */
#define HHWIN_PARAM_EXPANSION       (1l << 9)    /* valid fNotExpanded */
#define HHWIN_PARAM_TABPOS          (1l << 10)   /* valid tabpos */
#define HHWIN_PARAM_TABORDER        (1l << 11)   /* valid taborder */
#define HHWIN_PARAM_HISTORY_COUNT   (1l << 12)   /* valid cHistory */
#define HHWIN_PARAM_CUR_TAB         (1l << 13)   /* valid curNavType */
#define HHWIN_PARAM_NOTIFY_ID       (1l << 14)   /* valid idNotify */

#define HHWIN_BUTTON_EXPAND         (1l << 1)    /* Expand/contract button */
#define HHWIN_BUTTON_BACK           (1l << 2)    /* Back button */
#define HHWIN_BUTTON_FORWARD        (1l << 3)    /* Forward button */
#define HHWIN_BUTTON_STOP           (1l << 4)    /* Stop button */
#define HHWIN_BUTTON_REFRESH        (1l << 5)    /* Refresh button */
#define HHWIN_BUTTON_HOME           (1l << 6)    /* Home button */
#define HHWIN_BUTTON_BROWSE_FWD     (1l << 7)    /* not implemented */
#define HHWIN_BUTTON_BROWSE_BCK     (1l << 8)    /* not implemented */
#define HHWIN_BUTTON_NOTES          (1l << 9)    /* not implemented */
#define HHWIN_BUTTON_CONTENTS       (1l << 10)   /* not implemented */
#define HHWIN_BUTTON_SYNC           (1l << 11)   /* Sync button */
#define HHWIN_BUTTON_OPTIONS        (1l << 12)   /* Options button */
#define HHWIN_BUTTON_PRINT          (1l << 13)   /* Print button */
#define HHWIN_BUTTON_INDEX          (1l << 14)   /* not implemented */
#define HHWIN_BUTTON_SEARCH         (1l << 15)   /* not implemented */
#define HHWIN_BUTTON_HISTORY        (1l << 16)   /* not implemented */
#define HHWIN_BUTTON_FAVORITES      (1l << 17)   /* not implemented */
#define HHWIN_BUTTON_JUMP1          (1l << 18)
#define HHWIN_BUTTON_JUMP2          (1l << 19)
#define HHWIN_BUTTON_ZOOM           (1l << 20)
#define HHWIN_BUTTON_TOC_NEXT       (1l << 21)
#define HHWIN_BUTTON_TOC_PREV       (1l << 22)

#define HHWIN_DEF_BUTTONS           \
            (HHWIN_BUTTON_EXPAND |  \
             HHWIN_BUTTON_BACK |    \
             HHWIN_BUTTON_OPTIONS | \
             HHWIN_BUTTON_PRINT)


