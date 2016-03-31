#ifndef __CHMTYPES_H__
#define __CHMTYPES_H__ 1

#include "chm_htmlhelp.h"

#define snMSCompressed (1 << 0)
#define snUnCompressed (1 << 1)
typedef unsigned int SectionNames;

#define DIR_BLOCK_SIZE 0x1000

enum SYSTEM_CODE {
	Contents_file_CODE = 0,
	Index_file_CODE = 1,
	Default_topic_CODE = 2,
	Title_CODE = 3,
	Language_DBCS_FTS_KLinks_ALinks_FILETIME_CODE = 4,
	Default_Window_CODE = 5,
	Compiled_file_CODE = 6,
	Binary_Index_CODE = 7,
	ABBREVIATIONS_N_EXPLANATIONS_CODE = 8,
	COMPILED_BY_CODE = 9,
	time_t_STAMP_CODE = 10,
	Binary_TOC_CODE = 11,
	NUM_INFORMATION_TYPES_CODE = 12,
	IDXHDR_FILE_CODE = 13,
	Custom_tabs_CODE = 14,
	INFORMATION_TYPE_CHECKSUM_CODE = 15,
	Default_Font_CODE = 16
};

typedef struct _DirectoryChunk {
	unsigned int HeaderSize;
	unsigned int QuickRefEntries;
	unsigned int CurrentPos;
	unsigned int ItemCount;
	int ClearCount;
	uint8_t Buffer[DIR_BLOCK_SIZE];
	int ChunkLevelCount;
	struct _DirectoryChunk *ParentChunk;
} DirectoryChunk;

DirectoryChunk *DirectoryChunk_Create(unsigned int HeaderSize);
void DirectoryChunk_Destroy(DirectoryChunk *dir);
gboolean DirectoryChunk_CanHold(DirectoryChunk *dir, unsigned int Size);
unsigned int DirectoryChunk_FreeSpace(const DirectoryChunk *dir);
void PMGIDirectoryChunk_WriteHeader(DirectoryChunk *dir, const PMGIIndexChunk *header);
void PMGLDirectoryChunk_WriteHeader(DirectoryChunk *dir, const PMGLListChunk *header);
gboolean DirectoryChunk_WriteEntry(DirectoryChunk *dir, unsigned int Size, const void *data) G_GNUC_WARN_UNUSED_RESULT;
gboolean DirectoryChunk_WriteChunkToStream(DirectoryChunk *dir, ChmStream *Stream) G_GNUC_WARN_UNUSED_RESULT;
void DirectoryChunk_Clear(DirectoryChunk *dir);

gboolean PMGIDirectoryChunk_WriteChunkToStream(DirectoryChunk *dir, ChmStream *Stream, int *AIndex, gboolean Final /* = FALSE */) G_GNUC_WARN_UNUSED_RESULT;

typedef struct _FileEntryRec {
	union {
		char *s;
		const char *c;
	} path;
	chm_off_t DecompressedOffset;
	chm_off_t DecompressedSize;
	gboolean Compressed;	 /* True means it goes in section1 (snMSCompressed) means section0 (snUnCompressed) */
	gboolean searchable;
} FileEntryRec;

typedef struct _FileEntryList {
	GSList *items;	/* of FileEntryRec * */
} FileEntryList;

FileEntryRec *FileEntryList_GetFileEntry(FileEntryList *list, int Index);
void FileEntryList_AddEntry(FileEntryList *list, const FileEntryRec *FileEntry, gboolean CheckPathIsAdded /* = TRUE */);
void FileEntryList_Delete(FileEntryList *list, int Index);
void FileEntryList_Sort(FileEntryList *list);
FileEntryList *FileEntryList_Create(void);
void FileEntryList_Destroy(FileEntryList *list);

typedef unsigned int ValidWindowFields;		/* HHWIN_PARAM_* */

typedef union {
	/*
	 * Valid when string was read from chm file.
	 * The string data is contained in the #STRINGS file object
	 * and must not be freed.
	 */
	const char *c;
	/*
	 * Valid when string was read from project file.
	 * The string data is allocated and must be freed.
	 */
	char *s;
	/*
	 * Valid when string hast just been written to the
	 * #STRINGS file object (when generating chm)
	 */
	uint32_t o;
} strptr;

#define defvalidflags ( \
	HHWIN_PARAM_NAME | \
	HHWIN_PARAM_PROPERTIES | \
	HHWIN_PARAM_STYLES | \
	HHWIN_PARAM_NAV_WIDTH | \
	HHWIN_PARAM_TB_FLAGS | \
	HHWIN_PARAM_TABPOS)

/*
 * contents of a single entry in /#WINDOWS file object
 */
typedef struct _ChmWindow {
	/* 0000 */ uint32_t version;			/* size of entry */
	/* 0004 */ gboolean unicode_strings;
	/* 0008 */ strptr window_name;			/*	8 Arg 0, name of window; offset into #STRINGS */
	/* 000C */ ValidWindowFields flags;		/* HHWIN_PARAM_*
				                               bitset that keeps track of which fields are filled.
											   of certain fields. Needs to be inserted into #windows stream
											 */
	/* 0010 */ unsigned int win_properties;	/* arg 10, HHWIN_PROP_* navigation pane style */
	/* 0014 */ strptr caption;				/* Arg 1, windoww title */
	/* 0018 */ unsigned int styleflags;		/* Arg 14, Window styles WS_* */
	/* 001C */ unsigned int xtdstyleflags;	/* Arg 15, Extended Window styles WS_EX_* */
	/* 0020 */ struct {						/* Arg 13, rect */
		int left, top, right, bottom;
	} pos;
	/* 0030 */ int show_state;				/* Arg 16, window show state (e.g., SW_SHOW) */
	/* 0034 */ uint32_t hwndhelp;			/* OUT: window handle */
	/* 0038 */ uint32_t hwndcaller;			/* OUT: who called this window */
	/* 003c */ uint32_t p_info_types;		/* HH_INFO_TYPE paINFO_TYPES IN: Pointer to an array of Information Types */
	/* 0040 */ uint32_t hwndtoolbar;		/* OUT: toolbar window in tri-pane window */
	/* 0044 */ uint32_t hwndnavigation;		/* OUT: navigation window in tri-pane window */
	/* 0048 */ uint32_t hwndhtml;			/* OUT: window displaying HTML in tri-pane window */
	/* 004c */ int navpanewidth;			/* Arg 11, width of nav pane */
	/* 0050 */ struct {						/* OUT: Specifies the coordinates of the Topic pane */
		int left, top, right, bottom;
	} topic;
	/* 0060 */ strptr toc_file;				/* Arg 2, toc file; offset into #STRINGS */
	/* 0064 */ strptr index_file;			/* Arg 3, index file; offset into #STRINGS */
	/* 0068 */ strptr default_file;			/* Arg 4, default file; offset into #STRINGS */
	/* 006c */ strptr home_button_file;		/* Arg 5, home button file; offset into #STRINGS */
	/* 0070 */ unsigned int buttons;		/* Arg 12, HHWIN_BUTTON_* */
	/* 0074 */ int not_expanded;			/* Arg 17, */
	/* 0078 */ int navtype;					/* Arg 18, HHWIN_NAVTYPE_* */
	/* 007c */ int tabpos;					/* Arg 19, HHWIN_NAVTAB_TOP, HHWIN_NAVTAB_LEFT, or HHWIN_NAVTAB_BOTTOM */
	/* 0080 */ int wm_notify_id;			/* Arg 20, ID to use for WM_NOTIFY messages */
	/* 0084 */ uint8_t taborder[20];		/* byte tabOrder[HH_MAX_TABS + 1] */
	/* 0098 */ int history;					/* IN/OUT: number of history items to keep (default is 30) */
	/* 009c */ strptr jump1_text;			/* Arg 7, Text for HHWIN_BUTTON_JUMP1; offset into #STRINGS */
	/* 00a0 */ strptr jump2_text;			/* Arg 9, Text for HHWIN_BUTTON_JUMP2; offset into #STRINGS */
	/* 00a4 */ strptr jump1_url;			/* Arg 6, URL for HHWIN_BUTTON_JUMP1 */
	/* 00a8 */ strptr jump2_url;			/* Arg 8, URL for HHWIN_BUTTON_JUMP2 */
	/* 00ac */ struct {						/* Minimum size for window (ignored in version 1) */
		int left, top, right, bottom;
	} minsize;
	/* not from file: */
	gboolean strings_alloced;
} ChmWindow;
#define CHM_WIN_MINSIZE 0xbc
#define CHM_WIN_V3SIZE 0xc4

ChmWindow *ChmWindow_Create(void);
void ChmWindow_Destroy(ChmWindow *win);
void ChmWindow_Clear(ChmWindow *win);

/*
 * contents of /#IDXHDR file object
 */
typedef struct _ChmIdxhdr {
	/* 0000 */ CHMSignature sig;
	/* 0004 */ uint32_t timestamp;
	/* 0008 */ uint32_t unknown1;
	/* 000c */ uint32_t num_topics;
	/* 0010 */ uint32_t unknown2;
	/* 0014 */ strptr imagelist;
	/* 0018 */ uint32_t unknown3;
	/* 001c */ uint32_t imagetype_is_folder;
	/* 0020 */ uint32_t background;
	/* 0024 */ uint32_t foreground;
	/* 0028 */ strptr font;
	/* 002c */ uint32_t window_styles;
	/* 0030 */ uint32_t exwindow_styles;
	/* 0034 */ uint32_t unknown4;
	/* 0038 */ strptr framename;
	/* 003c */ strptr windowname;
	/* 0040 */ uint32_t num_information_types;
	/* 0044 */ uint32_t unknown5;
	/* 0048 */ uint32_t num_merge_files;
	/* 004c */ uint32_t unknown6;
#define CHM_IDXHDR_MAXFILES 1004
	/* 0050 */ strptr merge_files[CHM_IDXHDR_MAXFILES];
	/* 1000 */
} ChmIdxhdr;
#define CHM_IDXHDR_MINSIZE 0x0050

ChmIdxhdr *ChmIdxhdr_Create(void);
void ChmIdxhdr_Destroy(ChmIdxhdr *idx);

/*
 * contents of /#SYSTEM file object
 */
typedef struct _ChmSystem {
	uint32_t version; /* header */
	
	/*  0 */ strptr toc_file;
	/*  1 */ strptr index_file;
	/*  2 */ strptr default_page;
	/*  3 */ strptr caption;
	/*  4 */ struct {
		LCID locale_id;				/* determines encoding of most strings */
		uint32_t dbcs;
		uint32_t fulltextsearch;
		uint32_t klinks;
		uint32_t alinks;
		uint64_t timestamp;
		uint32_t collection;
		uint32_t unknown1;
	};
	/*  5 */ strptr default_window;
	/*  6 */ strptr chm_filename;
	/*  7 */ uint32_t binary_index_dword;
	/*  8 */ struct {
		uint32_t unknown2;
		strptr abbrev;				/* from #STRINGS */
		uint32_t unknown3;
		strptr abbrev_explanation;	/* from #STRINGS */
	};
	/*  9 */ strptr chm_compiler_version;
	/* 10 */ uint32_t local_timestamp;
	/* 11 */ uint32_t binary_toc_dword;
	/* 12 */ uint32_t num_information_types;
	/* 13 */ ChmIdxhdr *idxhdr;
	/* 14 */ struct {
		uint32_t custom_tabs;
		/* followed by 2 strings per window */
	};
	/* 15 */ uint32_t info_type_checksum;
	/* 16 */ strptr default_font;
} ChmSystem;

ChmSystem *ChmSystem_Create(void);
void ChmSystem_Destroy(ChmSystem *sys);

typedef struct _TOCIdxHeader {
	uint32_t EntryInfoOffset; /* 4096 */
	uint32_t EntriesOffset;
	uint32_t EntriesCount;
	uint32_t TopicsOffset;
	unsigned char EmptyBytes[4080];
} TOCIdxHeader;

#define TOC_ENTRY_HAS_NEW 	 	2
#define TOC_ENTRY_HAS_CHILDREN	4
#define TOC_ENTRY_HAS_LOCAL		8

typedef struct _TOCEntryPageBookInfo {
	uint16_t Unknown1;		/* = 0 */
	uint16_t EntryIndex;	/* multiple entry info's can have this value but the TTocEntry it points to points back to the first item with this number. Wierd. */
	uint32_t Props;			/* BitField. See TOC_ENTRY_* */
	uint32_t TopicsIndexOrStringsOffset; /* if TOC_ENTRY_HAS_LOCAL is in props it's the Topics Index */
										 /* else it's the Offset In Strings of the Item Text */
	uint32_t ParentPageBookInfoOffset;
	uint32_t NextPageBookOffset;	/* same level of tree only */

	/* Only if TOC_ENTRY_HAS_CHILDREN is set are these written */
	uint32_t FirstChildOffset;
	uint32_t Unknown3; /* = 0 */
} TOCEntryPageBookInfo;

typedef struct _TocEntry {
	uint32_t PageBookInfoOffset;
	uint32_t IncrementedInt;	/* first is $29A */
	uint32_t TopicsOffset;
	uint32_t TopicsIndex;	 	/* Index of Entry in #TOPICS file */
} TocEntry;

typedef struct _TopicEntryp {
	uint32_t TocOffset;
	uint32_t StringsOffset;
	uint32_t URLTableOffset;
	uint16_t InContents;	/* 2 = in contents 6 = not in contents */
	uint16_t Unknown;		/* 0,2,4,8,10,12,16,32 */
} TopicEntry;

/*
 * contents of $WWKeywordLinks/Btree (index sitemap)
 *         and $WWAssociativeLinks/Btree (Alinks)
 */
typedef struct _BtreeHeader {
	/* 0000 */ char ident[2];				/* $3B $29 */
	/* 0002 */ uint16_t flags;				/* bit $2 is always 1, bit $0400 1 if dir? (always on) */
	/* 0004 */ uint16_t blocksize;			/* size of blocks (2048) */
	/* 0006 */ char dataformat[16];			/* "X44" always the same, see specs. */
	/* 0016 */ uint32_t unknown0;			/* always 0 */
	/* 001a */ uint32_t lastlistblock;		/* index of last listing block in the file */
	/* 001e */ uint32_t indexrootblock;		/* Index of the root block in the file. */
	/* 0022 */ uint32_t unknown1;			/* always -1 */
	/* 0026 */ uint32_t nrblock;			/* Number of blocks */
	/* 002a */ uint16_t treedepth;			/* The depth of the tree of blocks (1 if no index blocks, 2 one level of index blocks, ...) */
	/* 002c */ uint32_t nrkeywords;			/* number of keywords in the file. */
	/* 0030 */ uint32_t codepage;			/* Windows code page identifier (usually 1252 - Windows 3.1 US (ANSI)) */
	/* 0034 */ LCID lcid;					/* LCID from the HHP file. */
	/* 0038 */ uint32_t ischm;				/* 0 if this a BTREE and is part of a CHW file, 1 if it is a BTree and is part of a CHI or CHM file */
	/* 003c */ uint32_t unknown2;			/* Unknown. Almost always 10031. Also 66631 (accessib.chm, ieeula.chm, iesupp.chm, iexplore.chm, msoe.chm, mstask.chm, ratings.chm, wab.chm). */
	/* 0040 */ uint32_t unknown3;			/* unknown 0 */
	/* 0044 */ uint32_t unknown4;			/* unknown 0 */
	/* 0048 */ uint32_t unknown5;			/* unknown 0 */
	/* 004c */ 
} BtreeHeader;
#define SIZEOF_BTREEHEADER 0x4c

typedef struct _BtreeBlockHeader {
	uint16_t Length;			/* Length of free space at the end of the block. */
	uint16_t NumberOfEntries;	/* Number of entries in the block. */
	uint32_t IndexOfPrevBlock;	/* Index of the previous block. -1 if this is the first listing block. */
	uint32_t IndexOfNextBlock;	/* Index of the next block. -1 if this is the last listing block. */
} BtreeBlockHeader;
#define SIZEOF_BTREEBLOCKHEADER 0x000c

typedef struct _BtreeBlockEntry {
	uint16_t isseealso;		/* 2 if this keyword is a See Also keyword, 0 if it is not. */
	uint16_t entrydepth;	/* Depth of this entry into the tree. */
	uint32_t charindex;		/* Character index of the last keyword in the ", " separated list. */
	uint32_t unknown0;		/* 0 (unknown) */
	uint32_t nrpairs;		/* Number of Name, Local pairs */
} BtreeBlockEntry;
#define SIZEOF_BTREEBLOCKENTRY 0x0010

typedef struct _BtreeIndexBlockHeader {
	uint16_t length;			/* Length of free space at the end of the block. */
	uint16_t NumberOfEntries;	/* Number of entries in the block. */
	uint32_t IndexOfChildBlock;	/* Index of Child Block */
} BtreeIndexBlockHeader;
#define SIZEOF_BTREEINDEXBLOCKHEADER 0x0008

typedef struct _BtreeIndexBlockEntry {
	uint16_t isseealso;		/* 2 if this keyword is a See Also keyword, 0 if it is not. */
	uint16_t entrydepth;	/* Depth of this entry into the tree. */
	uint32_t charindex;		/* Character index of the last keyword in the ", " separated list. */
	uint32_t unknown0;		/* 0 (unknown) */
	uint32_t NrPairs;		/* Number of Name, Local pairs */
} BtreeIndexBlockEntry;
#define SIZEOF_BTREEINDEXBLOCKENTRY 0x0010

#define NT_TICKSPERSEC        ((uint64_t)10000000UL)
#define NT_SECSPERDAY         86400UL
#define NT_SECS_1601_TO_1970  ((369 * 365 + 89) * (uint64_t)NT_SECSPERDAY)
#define NT_TICKS_1601_TO_1970 (NT_SECS_1601_TO_1970 * NT_TICKSPERSEC)

#endif
