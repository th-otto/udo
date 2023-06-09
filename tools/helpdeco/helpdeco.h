/*
helpdeco -- utility program to dissect Windows help files
Copyright (C) 1997 Manfred Winterhoff
Copyright (C) 2001 Ben Collver

This file is part of helpdeco; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place, Suite 330, Boston, MA, 02111-1307, USA or visit:
http://www.gnu.org
*/

/* HELPDECO.H - declares functions stored external in HELPDEC1.C */
#ifndef HELPDECO_H
#define HELPDECO_H
#include <time.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#include <unistd.h>
#include "compat.h"

#ifdef __TURBOC__
typedef struct { char a,b,c; } align;
#if sizeof(align)!=3
#error Compile bytealigned !
#endif
#else
#pragma pack(1)
#endif

/*
 * size of stored values in file,
 * may not necessary be == sizeof(short)/sizeof(long)
 */
#define SIZEOF_SHORT 2
#define SIZEOF_LONG  4


typedef int BOOL;
#undef FALSE
#undef TRUE
#define FALSE 0
#define TRUE 1

typedef struct               /* structure at beginning of help file */
{
    int32_t Magic;              /* 0x00035F3F */
    int32_t DirectoryStart;     /* offset of FILEHEADER of internal direcory */
    int32_t FreeChainStart;     /* offset of FILEHEADER or -1L */
    int32_t EntireFileSize;     /* size of entire help file in bytes */
} HELPHEADER;
#define SIZEOF_HELPHEADER 16

typedef struct FILEHEADER    /* structure at FileOffset of each internal file */
{
    int32_t ReservedSpace;      /* reserved space in help file incl. FILEHEADER */
    int32_t UsedSpace;          /* used space in help file excl. FILEHEADER */
    unsigned char FileFlags; /* normally 4 */
} FILEHEADER;
#define SIZEOF_FILEHEADER 9

typedef struct BTREEHEADER   /* structure after FILEHEADER of each Btree */
{
    uint16_t Magic;    /* 0x293B */
    uint16_t Flags;    /* bit 0x0002 always 1, bit 0x0400 1 if direcory */
    uint16_t PageSize; /* 0x0400=1k if directory, 0x0800=2k else */
    unsigned char Structure[16]; /* string describing structure of data */
    int16_t MustBeZero;        /* 0 */
    int16_t PageSplits;        /* number of page splits Btree has suffered */
    int16_t RootPage;          /* page number of Btree root page */
    int16_t MustBeNegOne;      /* 0xFFFF */
    int16_t TotalPages;        /* number of Btree pages */
    int16_t NLevels;           /* number of levels of Btree */
    int32_t TotalBtreeEntries;  /* number of entries in Btree */
} BTREEHEADER;
#define SIZEOF_BTREEHEADER 38

typedef struct BTREEINDEXHEADER /* structure at beginning of every index-page */
{
    uint16_t Unknown;  /* sorry, no ID to identify an index-page */
    int16_t NEntries;          /* number of entries in this index-page */
    int16_t PreviousPage;      /* page number of previous page */
} BTREEINDEXHEADER;
#define SIZEOF_BTREEINDEXHEADER 6

typedef struct BTREENODEHEADER /* structure at beginning of every leaf-page */
{
    uint16_t Unknown;  /* Sorry, no ID to identify a leaf-page */
    int16_t NEntries;          /* number of entires in this leaf-page */
    int16_t PreviousPage;      /* page number of preceeding leaf-page or -1 */
    int16_t NextPage;          /* page number of next leaf-page or -1 */
} BTREENODEHEADER;
#define SIZEOF_BTREENODEHEADER 8

typedef struct SYSTEMHEADER  /* structure at beginning of |SYSTEM file */
{
    uint16_t Magic;    /* 0x036C */
    uint16_t Minor;    /* help file format version number */
    uint16_t Major;    /* 1 */
    time_t GenDate;          /* date/time the help file was generated or 0 */
    uint16_t Flags;    /* tells you how the help file is compressed */
} SYSTEMHEADER;
#define SIZEOF_SYSTEMHEADER 12

typedef struct               /* internal structure */
{
    FILE *File;
    int32_t SavePos;
    int32_t Remaining;
    uint16_t RecordType; /* type of data in record */
    uint16_t DataSize;   /* size of data */
    unsigned char Data[10];
} SYSTEMRECORD;

typedef struct SECWINDOW     /* structure of data following RecordType 6 */
{
    uint16_t Flags;    /* flags (see below) */
    char Type[10];           /* type of window */
    char Name[9];            /* window name */
    char Caption[51];        /* caption for window */
    int16_t X;                 /* x coordinate of window (0..1000) */
    int16_t Y;                 /* y coordinate of window (0..1000) */
    int16_t Width;             /* width of window (0..1000) */
    int16_t Height;            /* height of window (0..1000) */
    int16_t Maximize;          /* maximize flag and window styles */
    unsigned char Rgb[3];    /* color of scrollable region */
    unsigned char Unknown1;
    unsigned char RgbNsr[3]; /* color of non-scrollable region */
    unsigned char Unknown2;
} SECWINDOW;
#define SIZEOF_SECWINDOW 90

typedef struct
{
    uint16_t Flags;    /* flags (see below) */
    char Type[10];           /* type of window */
    char Name[9];            /* window name */
    char Caption[51];        /* caption for window */
    unsigned char MoreFlags;
    int16_t X;                 /* x coordinate of window (0..1000) */
    int16_t Y;                 /* y coordinate of window (0..1000) */
    int16_t Width;             /* width of window (0..1000) */
    int16_t Height;            /* height of window (0..1000) */
    int16_t Maximize;          /* maximize flag and window styles */
    unsigned char TopRgb[3];
    unsigned char Unknown0;
    unsigned char Unknown[25];
    unsigned char Rgb[3];    /* color of scrollable region */
    unsigned char Unknown1;
    unsigned char RgbNsr[3]; /* color of non-scrollable region */
    unsigned char Unknown2;
    int16_t X2;
    int16_t Y2;
    int16_t Width2;
    int16_t Height2;
    int16_t X3;
    int16_t Y3;
} MVBWINDOW;
#define SIZEOF_MVBWINDOW 132

typedef struct               /* structure of data following RecordType 14 */
{
    char btreename[10];
    char mapname[10];
    char dataname[10];
    char title[80];
} KEYINDEX;

#define WSYSFLAG_TYPE           0x0001  /* Type is valid */
#define WSYSFLAG_NAME           0x0002  /* Name is valid */
#define WSYSFLAG_CAPTION        0x0004  /* Caption is valid */
#define WSYSFLAG_X              0x0008  /* X is valid */
#define WSYSFLAG_Y              0x0010  /* Y is valid */
#define WSYSFLAG_WIDTH          0x0020  /* Width is valid */
#define WSYSFLAG_HEIGHT         0x0040  /* Height is valid */
#define WSYSFLAG_MAXIMIZE       0x0080  /* Maximize is valid */
#define WSYSFLAG_RGB            0x0100  /* Rgb is valid */
#define WSYSFLAG_RGBNSR         0x0200  /* RgbNsr is valid */
#define WSYSFLAG_TOP            0x0400  /* On top was set in HPJ file */
#define WSYSFLAG_AUTOSIZEHEIGHT 0x0800  /* Auto-Size Height */

typedef struct PHRINDEXHDR   /* structure of beginning of |PhrIndex file */
{
    int32_t always4A01;              /* sometimes 0x0001 */
    int32_t entries;                 /* number of phrases */
    int32_t compressedsize;          /* size of PhrIndex file */
    int32_t phrimagesize;            /* size of decompressed PhrImage file */
    int32_t phrimagecompressedsize;  /* size of PhrImage file */
    int32_t always0;
    uint16_t bits:4;
    uint16_t unknown:12;
    uint16_t always4A00;    /* sometimes 0x4A01, 0x4A02 */
} PHRINDEXHDR;
#define SIZEOF_PHRINDEXHDR 28


typedef struct FONTHEADER    /* structure of beginning of |FONT file */
{
    uint16_t NumFacenames;       /* number of face names */
    uint16_t NumDescriptors;     /* number of font descriptors */
    uint16_t FacenamesOffset;    /* offset of face name array */
    uint16_t DescriptorsOffset;  /* offset of descriptors array */
    uint16_t NumFormats;         /* only if FacenamesOffset >= 12 */
    uint16_t FormatsOffset;      /* offset of formats array */
    uint16_t NumCharmaps;        /* only if FacenamesOffset >= 16 */
    uint16_t CharmapsOffset;     /* offset of charmapnames array */
} FONTHEADER;
#define SIZEOF_FONTHEADER 16


typedef struct FONTDESCRIPTOR /* internal font descriptor */
{
    unsigned char Bold;
    unsigned char Italic;
    unsigned char Underline;
    unsigned char StrikeOut;
    unsigned char DoubleUnderline;
    unsigned char SmallCaps;
    unsigned char HalfPoints;
    unsigned char FontFamily;
    uint16_t FontName;
    unsigned char textcolor;
    unsigned char backcolor;
    uint16_t style;
    int16_t expndtw;
    signed char up;
} FONTDESCRIPTOR;

typedef struct                /* non-Multimedia font descriptor */
{
    unsigned char Attributes; /* Font Attributes See values below */
    unsigned char HalfPoints; /* PointSize * 2 */
    unsigned char FontFamily; /* Font Family. See values below */
    uint16_t FontName;  /* Number of font in Font List */
    unsigned char FGRGB[3];   /* RGB values of foreground */
    unsigned char BGRGB[3];   /* unused background RGB Values */
} OLDFONT;
#define SIZEOF_OLDFONT 11

typedef struct NEWFONT        /* structure located at DescriptorsOffset */
{
    unsigned char unknown1;
    int16_t FontName;
    unsigned char FGRGB[3];
    unsigned char BGRGB[3];
    unsigned char unknown5;
    unsigned char unknown6;
    unsigned char unknown7;
    unsigned char unknown8;
    unsigned char unknown9;
    int32_t Height;
    unsigned char mostlyzero[12];
    int16_t Weight;
    unsigned char unknown10;
    unsigned char unknown11;
    unsigned char Italic;
    unsigned char Underline;
    unsigned char StrikeOut;
    unsigned char DoubleUnderline;
    unsigned char SmallCaps;
    unsigned char unknown17;
    unsigned char unknown18;
    unsigned char PitchAndFamily;
} NEWFONT;
#define SIZEOF_NEWFONT 42


typedef struct
{
    uint16_t StyleNum;
    uint16_t BasedOn;
    NEWFONT font;
    char unknown[35];
    char StyleName[65];
} NEWSTYLE;
#define SIZEOF_NEWSTYLE (104 + SIZEOF_NEWFONT)

typedef struct MVBFONT        /* structure located at DescriptorsOffset */
{
    int16_t FontName;
    int16_t expndtw;
    uint16_t style;
    unsigned char FGRGB[3];
    unsigned char BGRGB[3];
    int32_t Height;
    unsigned char mostlyzero[12];
    int16_t Weight;
    unsigned char unknown10;
    unsigned char unknown11;
    unsigned char Italic;
    unsigned char Underline;
    unsigned char StrikeOut;
    unsigned char DoubleUnderline;
    unsigned char SmallCaps;
    unsigned char unknown17;
    unsigned char unknown18;
    unsigned char PitchAndFamily;
    unsigned char unknown20;
    signed char up;
} MVBFONT;
#define SIZEOF_MVBFONT 42


typedef struct
{
    uint16_t StyleNum;
    uint16_t BasedOn;
    MVBFONT font;
    char unknown[35];
    char StyleName[65];
} MVBSTYLE;
#define SIZEOF_MVBSTYLE (104 + SIZEOF_MVBFONT)


typedef struct
{
    uint16_t Magic;     /* 0x5555 */
    uint16_t Size;
    uint16_t Unknown1;
    uint16_t Unknown2;
    uint16_t Entries;
    uint16_t Ligatures;
    uint16_t LigLen;
    uint16_t Unknown[13];
} CHARMAPHEADER;
#define SIZEOF_CHARMAPHEADER 40

/* Font Attributes */
#define FONT_NORM 0x00 /* Normal */
#define FONT_BOLD 0x01 /* Bold */
#define FONT_ITAL 0x02 /* Italics */
#define FONT_UNDR 0x04 /* Underline */
#define FONT_STRK 0x08 /* Strike Through */
#define FONT_DBUN 0x10 /* Dbl Underline */
#define FONT_SMCP 0x20 /* Small Caps */
/* Font Families */
#define FAM_MODERN 0x01
#define FAM_ROMAN  0x02
#define FAM_SWISS  0x03
#define FAM_TECH   0x03
#define FAM_NIL    0x03
#define FAM_SCRIPT 0x04
#define FAM_DECOR  0x05

typedef struct KWMAPREC       /* structure of |xWMAP leaf-page entries */
{
    int32_t FirstRec;            /* index number of first keyword on leaf page */
    uint16_t PageNum;   /* page number that keywords are associated with */
} KWMAPREC;
#define SIZEOF_KWMAPREC 6

/* TOPICPOS/DecompressSize = block number, TOPICPOS%DecompressSize = offset into decompression buffer (including sizeof(TOPICBLOCKHEADER)) */
typedef int32_t TOPICPOS;

/* TOPICOFFSET/0x8000 = block number, TOPICOFFSET/0x8000 = number of characters and hotspots counting from first TOPICLINK of this block */
typedef int32_t TOPICOFFSET;

typedef struct                /* structure every TopicBlockSize in |TOPIC */
{
    TOPICPOS LastTopicLink;   /* points to last TOPICLINK in previous block */
    TOPICPOS FirstTopicLink;  /* points to first TOPICLINK in this block */
    TOPICPOS LastTopicHeader; /* points to TOPICLINK of last TOPICHEADER */
} TOPICBLOCKHEADER;
#define SIZEOF_TOPICBLOCKHEADER 12


typedef struct                /* structure pointed to by FirstTopicLink */
{
    int32_t BlockSize;           /* size of this link + LinkData1 + LinkData2 */
    int32_t DataLen2;            /* length of decompressed LinkData2 */
    TOPICPOS PrevBlock;
    /*
     * Windows 3.0 (HC30): number of bytes the TOPICLINK of the previous
     * block is located before this TOPICLINK, that is the block size of
     * the previous TOPICLINK plus eventually skipped TOPICBLOCKHEADER.
     * Windows 3.1 (HC31): TOPICPOS of previous TOPICLINK
     */
    TOPICPOS NextBlock;
    /*
     * Windows 3.0 (HC30): number of bytes the TOPICLINK of the next block
     * is located behind this block, including skipped TOPICBLOCKHEADER.
     * Windows 3.1 (HC31): TOPICPOS of next TOPICLINK
     */
    int32_t DataLen1;            /* includes size of TOPICLINK */
    unsigned char RecordType; /* See below */
} TOPICLINK;
#define SIZEOF_TOPICLINK 21

/* Known RecordTypes for TOPICLINK */
#define TL_DISPLAY30 0x01     /* version 3.0 displayable information */
#define TL_TOPICHDR  0x02     /* topic header information */
#define TL_DISPLAY   0x20     /* version 3.1 displayable information */
#define TL_TABLE     0x23     /* version 3.1 table */

typedef struct                /* structure of LinkData1 of RecordType 2 */
{
    int32_t BlockSize;        /* size of topic, including internal topic links */
    TOPICOFFSET BrowseBck; /* topic offset for prev topic in browse sequence */
    TOPICOFFSET BrowseFor; /* topic offset for next topic in browse sequence */
    int32_t TopicNum;         /* topic Number */
    TOPICPOS NonScroll;    /* start of non-scrolling region (topic offset) or -1 */
    TOPICPOS Scroll;       /* start of scrolling region (topic offset) */
    TOPICPOS NextTopic;    /* start of next type 2 record */
} TOPICHEADER;
#define SIZEOF_TOPICHEADER 28

typedef struct                /* structure of LinkData1 of RecordType 2 */
{
    int32_t BlockSize;
    int16_t PrevTopicNum;
    int16_t unused1;
    int16_t NextTopicNum;
    int16_t unused2;
} TOPICHEADER30;
#define SIZEOF_TOPICHEADER30 12

typedef struct                /* structure of |CTXOMAP file entries */
{
    uint32_t MapID;
    int32_t TopicOffset;
} CTXOMAPREC;
#define SIZEOF_CTXOMAPREC 8

typedef struct                /* structure of |CONTEXT leaf-page entry */
{
    uint32_t HashValue;       /* Hash value of context id */
    TOPICOFFSET TopicOffset;  /* Topic offset */
} CONTEXTREC;
#define SIZEOF_CONTEXTREC 8

typedef struct                /* structure of *.GRP file header */
{
    uint32_t Magic;      /* 0x000A3333 */
    uint32_t BitmapSize;
    uint32_t LastTopic;
    uint32_t FirstTopic;
    uint32_t TopicsUsed;
    uint32_t TopicCount;
    uint32_t GroupType;
    uint32_t Unknown1;
    uint32_t Unknown2;
    uint32_t Unknown3;
} GROUPHEADER;
#define SIZEOF_GROUPHEADER 40

typedef struct                /* internal use */
{
    GROUPHEADER GroupHeader;
    char *Name;
    unsigned char *Bitmap;
} GROUP;

typedef struct                /* structure of STOPn.STP header */
{
    uint32_t Magic;      /* 0x00082222 */
    uint16_t BytesUsed;
    uint16_t Unused[17];
} STOPHEADER;
#define SIZEOF_STOPHEADER 40


typedef struct                /* structure of |VIOLA leaf-page entry */
{
    TOPICOFFSET TopicOffset;  /* topic offset */
    int32_t WindowNumber;        /* number of window assigned to topic */
} VIOLAREC;
#define SIZEOF_VIOLAREC 8

typedef struct                /* structure of |CATALOG header */
{
   uint16_t magic;      /* 0x1111 */
   uint16_t always8;
   uint16_t always4;
   int32_t entries;
   unsigned char zero[30];
} CATALOGHEADER;
#define SIZEOF_CATALOGHEADER 40

/* structure of Windows Bitmap BMP file */
typedef struct
{
	uint16_t bfType;
	uint32_t bfSize;
	uint16_t bfReserved1;
	uint16_t bfReserved2;
	uint32_t bfOffBits;
} BITMAPFILEHEADER;
#define SIZEOF_BITMAPFILEHEADER 14

/* structure of Windows Bitmap header */
typedef struct
{
	uint32_t biSize;
	int32_t biWidth;
	int32_t biHeight;
	uint16_t biPlanes;
	uint16_t biBitCount;
	uint32_t biCompression;
	uint32_t biSizeImage;
	int32_t biXPelsPerMeter;
	int32_t biYPelsPerMeter;
	uint32_t biClrUsed;
	uint32_t biClrImportant;
} BITMAPINFOHEADER;
#define SIZEOF_BITMAPINFOHEADER 40

/* Windows rectangle */
typedef struct tagRECT
{
	int16_t left;
	int16_t top;
	int16_t right;
	int16_t bottom;
} RECT;

/* Windows Aldus placeable metafile header */
typedef struct
{
	uint32_t dwKey;
	uint16_t hMF;
	RECT rcBBox;
	uint16_t wInch;
	uint32_t dwReserved;
	uint16_t wChecksum;
} APMFILEHEADER;
#define SIZEOF_APMFILEHEADER 22

typedef struct                /* structure of hotspot info */
{
    unsigned char id0,id1,id2;
    uint16_t x,y,w,h;
    uint32_t hash;
} HOTSPOT;
#define SIZEOF_HOTSPOT 15

typedef struct                /* structure used as buf of GetFirstPage */
{
    int32_t FirstLeaf;
    uint16_t PageSize;
    int16_t NextPage;
} BUFFER;

typedef struct                /* internal use. 16 bit: max. 3640 */
{
    int32_t StartTopic;
    int32_t NextTopic;
    int32_t PrevTopic;
    int16_t BrowseNum;
    int16_t Start;
    int16_t Count;
} BROWSE;

typedef struct                /* internal use. 16 bit: max. 8191 */
{
    int32_t StartTopic;
    int16_t BrowseNum;
    int16_t Start;
} START;

typedef struct                /* internal use. 16 bit: max. 6553 */
{
    char *name;
    uint32_t hash;
    BOOL derived;
} HASHREC;

typedef struct                /* internal use to store keyword definitions */
{
    BOOL KeyIndex;
    char Footnote;
    char *Keyword;
    int32_t TopicOffset;
} KEYWORDREC;

typedef struct placerec       /* internal use to store external references */
{
   struct placerec *next;
   char topicname[1];
} PLACEREC;

enum rectype { TOPIC, CONTEXT };
typedef struct checkrec       /* internal use to store external references */
{
    struct checkrec *next;
    enum rectype type;
    uint32_t hash;
    char *id;
    PLACEREC *here;
} CHECKREC;

typedef struct fileref        /* internal use to store external references */
{
    struct fileref *next;
    CHECKREC *check;
    char filename[1];
} FILEREF;

typedef struct                /* internal use */
{
    TOPICOFFSET TopicOffset;
    TOPICOFFSET OtherTopicOffset;
} ALTERNATIVE;

typedef struct mfile          /* a class would be more appropriate */
{
    FILE *f;
    char *base;
    char *ptr;
    char *end;
    int (*get)(struct mfile *);
    int (*put)(struct mfile *,char);
    size_t (*read)(struct mfile *,void *,int32_t);
    int32_t (*tell)(struct mfile *);
    void (*seek)(struct mfile *,int32_t);
} MFILE;

void error(const char *format, ...) __attribute__((format(printf, 1, 2)));
void fatal(const char *format, ...) __attribute__((format(printf, 1, 2)));
size_t my_strlcpy(char *dest, const void *src, size_t len); /* limited string copy */
void *my_malloc(int32_t bytes); /* save malloc function */
void *my_realloc(void *ptr,int32_t bytes); /* save realloc function */
char *my_strdup(const char *ptr); /* save strdup function */
size_t my_fread(void *ptr,int32_t bytes,FILE *f); /* save fread function */
size_t my_gets(char *ptr,size_t size,FILE *f);  /* read nul terminated string from regular file */
void my_fclose(FILE *f); /* checks if disk is full */
FILE *my_fopen(const char *filename,const char *mode); /* save fopen function */
uint16_t my_getw(FILE *f); /* get 16 bit quantity */
uint32_t getdw(FILE *f); /* get long */
void my_putw(uint16_t w, FILE *f); /* write 16 bit quantity */
void putdw(uint32_t x,FILE *f); /* write long to file */
void putcdw(uint32_t x,FILE *f); /* write compressed long to file */
void putcw(unsigned int x,FILE *f); /* write compressed word to file */
int MemoryPut(MFILE *f,char c); /* put char to memory mapped file */
int FilePut(MFILE *f,char c); /* put char to regular file */
int MemoryGet(MFILE *f); /* get char from memory mapped file */
int FileGet(MFILE *f); /* get char from regular file */
size_t MemoryRead(MFILE *f,void *ptr,int32_t bytes); /* read function for memory mapped file */
size_t FileRead(MFILE *f,void *ptr,int32_t bytes); /* read function for regular file */
int32_t MemoryTell(MFILE *f); /* tell for memory mapped file */
int32_t FileTell(MFILE *f); /* tell for regular file */
void MemorySeek(MFILE *f,int32_t offset); /* seek in memory mapped file */
void FileSeek(MFILE *f,int32_t offset); /* seek in regular file */
MFILE *CreateMap(const char *ptr, size_t size); /* assign a memory mapped file */
MFILE *CreateVirtual(FILE *f);  /* assign a real file */
void CloseMap(MFILE *f); /* close a MFILE */
int GetWord(MFILE *f); /* read 16 bit value from memory mapped file or regular file */
uint16_t GetCWord(MFILE *f); /* get compressed word from memory mapped file or regular file */
uint32_t GetCDWord(MFILE *f); /* get compressed long from memory mapped file or regular file */
uint32_t GetDWord(MFILE *f); /* get long from memory mapped file or regular file */
size_t StringRead(char *ptr,size_t size,MFILE *f); /* read nul terminated string from memory mapped or regular file */
int32_t copy(FILE *f,int32_t bytes,FILE *out);
int32_t CopyBytes(MFILE *f,int32_t bytes,FILE *out);
int32_t decompress(int method,MFILE *f,int32_t bytes,MFILE *fTarget);
int32_t DecompressIntoBuffer(int method,FILE *HelpFile,int32_t bytes,char *ptr,int32_t size);
int32_t DecompressIntoFile(int method,MFILE *f,int32_t bytes,FILE *fTarget);
void HexDump(FILE *f,int32_t FileLength,int32_t offset);
void HexDumpMemory(const unsigned char *bypMem,unsigned int FileLength);
const char *PrintString(const char *str,unsigned int len);
BOOL GetBit(FILE *f);
void putrtf(FILE *rtf,const char *str);
int16_t scanint(const char **ptr); /* scan a compressed short */
uint16_t scanword(const char **ptr); /* scan a compressed unsigned short */
int32_t scanlong(const char **ptr);  /* scan a compressed long */
BOOL SearchFile(FILE *HelpFile,const char *FileName,int32_t *FileLength);
int16_t GetFirstPage(FILE *HelpFile,BUFFER *buf,int32_t *TotalEntries);
int16_t GetNextPage(FILE *HelpFile,BUFFER *buf); /* walk Btree */
SYSTEMRECORD *GetNextSystemRecord(SYSTEMRECORD *SysRec);
SYSTEMRECORD *GetFirstSystemRecord(FILE *HelpFile);
void ListFiles(FILE *HelpFile); /* display internal directory */
void ListBaggage(FILE *HelpFile,FILE *hpj,BOOL before31); /* writes out [BAGGAGE] section */
void PrintWindow(FILE *hpj, const SECWINDOW *SWin);
void PrintMVBWindow(FILE *hpj, const MVBWINDOW *SWin);
void ToMapDump(FILE *HelpFile,int32_t FileLength);
void GroupDump(FILE *HelpFile);
void KWMapDump(FILE *HelpFile);
void KWDataDump(FILE *HelpFile,int32_t FileLength);
void CatalogDump(FILE *HelpFile);
void CTXOMAPDump(FILE *HelpFile);
void LinkDump(FILE *HelpFile);
void AnnotationDump(FILE *HelpFile,int32_t FileLength,const char *name);


void read_systemheader(FILE *f, SYSTEMHEADER *hdr);
void read_ctxomaprec(FILE *f, CTXOMAPREC *hdr);
void read_btreeheader(FILE *f, BTREEHEADER *hdr);
void read_btreenode(FILE *f, BTREENODEHEADER *hdr);
void read_btreeindex(FILE *f, BTREENODEHEADER *hdr);
void read_contextrec(FILE *f, CONTEXTREC *hdr);
void read_stopheader(FILE *f, STOPHEADER *hdr);
void read_groupheader(FILE *f, GROUPHEADER *hdr);
void read_phrindexhdr(FILE *f, PHRINDEXHDR *hdr);
void read_topicblockheader(FILE *f, TOPICBLOCKHEADER *hdr);
void read_violarec(FILE *f, VIOLAREC *hdr);
void read_hotspot(MFILE *f, HOTSPOT *hotspot);
void read_fontheader(FILE *f, FONTHEADER *hdr);
void read_charmapheader(FILE *f, CHARMAPHEADER *hdr);
void read_mvbfont(FILE *f, MVBFONT *hdr);
void read_mvbstyle(FILE *f, MVBSTYLE *hdr);
void read_newfont(FILE *f, NEWFONT *hdr);
void read_newstyle(FILE *f, NEWSTYLE *hdr);
void read_oldfont(FILE *f, OLDFONT *hdr);


extern BOOL overwrite; /* ugly: declared in HELPDECO.C */

#endif
