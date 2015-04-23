/* Original View help instance thing */

typedef void* PIOINFO;
typedef void* PMNODE;
typedef void* PPAGE;
typedef void* PHISTORYINFO;
typedef void* PLIBRARYINFO;
typedef void* PINXDATA;
typedef void* PINDEX;
typedef void* PTOCDATA;
typedef USHORT COUNTU;
typedef void* PTOCITEM;
typedef void* PBMINFO;
typedef void* PEXTLNKDATA;
typedef USHORT INX;
typedef void* PFONTDATA;
typedef void* PUSERINFO;
typedef USHORT CP;

typedef void* PHELPTABLEX;

   /* define instance data */
typedef struct instance
{
   PIOINFO      IOInfo;                    /* active database */
   PIOINFO      IOInfoRoot;                /* list of database */
   ULONG        LastError;
   USHORT       BmOrHm;                    /* TRUE BM else HM */
   HWND         hwndInstance;              /* instance object window hwnd*/
   HWND         BmHelpInstance;            /* handle to BM help inst */
   PMNODE       MemRoot;
   PMNODE       TOCMemRoot;
   PMNODE       IndexMemRoot;
   USHORT       StatusFlag;
   USHORT       WindowStatus;
   HWND         CoverPageFhWnd;
   HWND         CoverPageChWnd;
   HWND         TOCFhWnd;
   HWND         TOCChWnd;
   HWND         IndexFhWnd;
   HWND         IndexChWnd;
   HWND         SearchFhWnd;
   HWND         HistoryFhWnd;
   HWND         LibraryFhWnd;
   PPAGE        PageRoot;                  /* active viewport ptr */
   PPAGE        PageLinkRoot;              /* root of viewport list */
   PPAGE        ParentPage;                /* Parent page of current page */
   PHISTORYINFO HistoryInfo;
   PLIBRARYINFO LibraryInfo;
   PCH          SearchStr;
   USHORT       SearchFlag;                /* if set search page before display */
   ULONG        FirstWord;                 /* previous page first word index */
   USHORT       TotNumIndexEntries;
   PINDEX      *IndexRoot;                 /* pointer to the root of indexes array */
   PCH          PageTitle;
   PTOCDATA     TOCData;                   /* pointer to the TOC control data struct */
                                           /* @CGA */
   COUNTU       TotNumTOCEntries;          /* total number of mult toc entry */
   PTOCITEM    *TOCRoot;                   /* pointer to the first item in TOC array */
   PINXDATA     IndexData;                 /* pointer to the INX control data struct */
   PINDEX      *SearchIndexRoot;           /* pointer to the root of search index array */
   BYTE         TOCUseCount;               /* use count for toc */
   BYTE         IndexUseCount;             /* use count for Index */
   USHORT       IndexMode;                 /* flag for ICmd or main Index mode */
   PBMINFO      BMInfo;                    /* pointer to the bookmark info structure */
   PFNWP        FrameProcAdr;              /* frame proc adr */
   USHORT       LineHeight;                /* fix scroll line height */
   USHORT       StdCharWidth;              /* default font width */
   USHORT       StdCharDescender;          /* default max descender */
   USHORT       CharHeight;                /* local font height */
   USHORT       CharWidth;                 /* local font width */
   USHORT       CharDescender;             /* loacal max descender */
   USHORT       PMIconWidth;               /* + & - Icon width */
   HBITMAP      HPBitmap;                  /* handle of + bitmap */
   HBITMAP      HMBitmap;                  /* handle of - Bitmap */
   USHORT       ScrX;                      /* screen height */
   USHORT       ScrY;                      /* screen width */
   USHORT       NextWindowID;              /* id for next toc window */
   USHORT       CxBorder;                  /* thicknes of cx border */
   USHORT       CyBorder;                  /* thicknes of cy border */
   CP           GCPData;
   INX          ActiveTOCIndex;            /* TOC index for active page */
   HACCEL       ChildSyshAccel;            /* common sys menu for all child wnd*/
   HBITMAP      ChildSysHBitmap;           /* common sys menu bitmap handle */
   HAB          hAB;                       /* apps hab if help manager */
   HMODULE      hwndModule;                /* help dll module */
   PCH          HelpWindowTitle;           /* Help window title */
   PHELPTABLEX  RootHelpTable;             /* Main help table */
   USHORT       HelpTableID;               /* Help table ID */
   USHORT       ShowPanelID;               /* Show panel id flag */
   USHORT       HelpHelpID;                /* Help on help panel ID */
   HWND         hwndAssociated;            /* this instance is associated */
   HWND         hwndActiveWindow;          /* active window handle */
   HWND         hwndRelativeWindow;        /* Relative window handle */
   HMODULE      hmodAccelActionBarModule;
   ULONG        idAccelTable;              /* @WRN */
   ULONG        idActionBar;               /* @WRN */
   PCH          GTutorial;                 /* globle tutorial name */
   PCH          LTutorial;                 /* local tutorial name */
   ULONG        HorzPelsPerPointSize;
   ULONG        VertPelsPerPointSize;
   HMODULE      hACVPModule;               /* globle AC viewport DLL handle */
   HWND         ACVPComhWnd;               /* AC viewport communication hwnd */
   PEXTLNKDATA  pExtLnkData;               /* TOC new style passing info */
   HWND         BMBasehWnd;                /* book manager base window handle */
   HWND         BMBookhWnd;                /* book manager book handle */
   USHORT       Entry16;
   PRECTL       pCoverPageRect;            /* pointer to coverpage init window rect */
   USHORT       usMode;
   PVOID        pUserData;                 /* user data info */
   PFONTDATA    pPrtFontData;              /* FontData use in printing mode */
   PUSERINFO    pUserInfoRoot;             /* userinfo list root */
   HWND         hwndPrintDlg;              /* Print Dialog Window Handle */
   HWND         hwndEntry;                 /* Window from which help was requested */
                                           /* ie, which HELPTABLE entry was used */
   BOOL         resourceFlag;              /* Help table flag in resource file */
   BOOL         DLLError;
   USHORT       fIsDocBidi;                /* Bidi flag showing doc. lang. */
} INSTANCE, *PINSTANCE;

