#ifndef __CHMBASE_H__
#define __CHMBASE_H__ 1

#include "langid.h"

#if ! (defined _GUID_DEFINED || defined GUID_DEFINED) /* also defined in winnt.h */
#define GUID_DEFINED
typedef struct _GUID
{
    uint32_t Data1;
    uint16_t Data2;
    uint16_t Data3;
    uint8_t Data4[8];
} GUID, *REFGUID, *LPGUID;
#endif

#undef DEFINE_GUID
#define DEFINE_GUID(n,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) GUID const n = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

typedef struct {
	char sig[4];
} CHMSignature;

typedef struct _ITSFHeader {
	/* 0000 */ CHMSignature ITSFsig;
	/* 0004 */ uint32_t Version;
	/* 0008 */ uint32_t HeaderLength;
	/* 000C */ uint32_t Unknown_1;
	/* 0010 */ uint32_t TimeStamp;	/* bigendian; only lowPart of a FILETIME and hence rather useless */
	/* 0014 */ uint32_t LanguageID;	/* from the creating system, not from project file */
	/* 0018 */ GUID guid1;
	/* 0028 */ GUID guid2;
	/* 0038 */ 
} ITSFHeader;

typedef struct _ITSFHeaderEntry {
	uint64_t PosFromZero;
	uint64_t Length;
} ITSFHeaderEntry;

/* Version 3 has this uint64_t. 2 does not */
typedef struct _ITSFHeaderSuffix {
	uint64_t Offset;	/* offset within file of content section 0 */
} ITSFHeaderSuffix;

typedef struct _ITSPHeaderPrefix {
	uint32_t Unknown1;	/* = $01FE */
	uint32_t Unknown2;	/* = 0 */
	uint64_t FileSize;
	uint32_t Unknown3;	/* = 0 */
	uint32_t Unknown4;	/* = 0 */
} ITSPHeaderPrefix;

typedef struct _ITSPHeader {
	/* 0000 */ CHMSignature ITSPsig;		/* = 'ITSP' */
	/* 0004 */ uint32_t Version;			/* =1 */
	/* 0008 */ uint32_t DirHeaderLength; 	/* Length of the directory header */
	/* 000C */ uint32_t Unknown1;			/* =$0a */
	/* 0010 */ uint32_t ChunkSize;			/* $1000 */
	/* 0014 */ uint32_t Density;			/* usually = 2 */
	/* 0018 */ uint32_t IndexTreeDepth;	/* 1 if there is no index 2 if there is one level of PMGI chunks */
	/* 001c */ int32_t IndexOfRootChunk;	/* -1 if no root chunk */
	/* 0020 */ uint32_t FirstPMGLChunkIndex;
	/* 0024 */ uint32_t LastPMGLChunkIndex;
	/* 0028 */ int32_t Unknown2;			/* = -1 */
	/* 002c */ uint32_t DirectoryChunkCount;
	/* 0030 */ uint32_t LanguageID;
	/* 0034 */ GUID guid;
	/* 0044 */ uint32_t LengthAgain;		/* ??? $54 */
	/* 0048 */ uint32_t Unknown3;			/* = -1 */
	/* 004c */ uint32_t Unknown4;			/* = -1 */
	/* 0050 */ uint32_t Unknown5;			/* = -1 */
	/* 0054 */ 
} ITSPHeader;

typedef enum { ctPMGL, ctPMGI, ctAOLL, ctAOLI, ctUnknown } DirChunkType;

typedef struct _PMGLListChunk {
	CHMSignature sig;			/* 'PMGL' */
	uint32_t UnusedSpace;		/* !!! this value can also represent the size of quickref area in the end of the chunk */
	uint32_t Unknown1;			/* always 0 */
	int32_t PreviousChunkIndex;	/* chunk number of the prev listing chunk when reading dir in sequence */
								/* (-1 if this is the first listing chunk) */
	int32_t NextChunkIndex;		/* chunk number of the next listing chunk (-1 if this is the last chunk */
} PMGLListChunk;

typedef struct _PMGLListChunkEntry {
	uint32_t NameLength;
	char *Name;					/* utf-8 */
	uint32_t ContentSection;
	uint64_t ContentOffset;
	uint64_t DecompressedLength;
} PMGLListChunkEntry;

typedef struct _PMGIIndexChunk {
	CHMSignature sig;			/* 'PMGI' */
	uint32_t UnusedSpace;		/* has a quickref area */
} PMGIIndexChunk;

typedef struct _PMGIIndexChunkEntry {
	uint32_t NameLength;
	char *Name;					/* utf-8 */
	uint32_t ListingChunk;
} PMGIIndexChunkEntry;

typedef struct _AOLLListChunk {
	CHMSignature sig;			/* 'AOLL' */
	uint32_t QuickRefSize;
	uint64_t ChunkIndex;		/* must be correct in the order written */
	int64_t PreviousChunkIndex;	/* chunk number of the prev listing chunk when reading dir in sequence */
								/* (-1 if this is the first listing chunk) */
	int64_t NextChunkIndex;		/* chunk number of the next listing chunk (-1 if this is the last chunk */
	int64_t FirstEntryIndex;
	uint32_t unknown0;
	uint32_t unknown1;
} AOLLListChunk;

typedef struct _AOLIIIndexChunk {
	CHMSignature sig;			/* 'AOLI' */
	uint32_t QuickRefSize;		/* Length of quickref area at end of directory chunk */
	uint64_t ChunkIndex;		/* Directory chunk number */
} AOLIIndexChunk;


typedef struct _ITOLITLSHeader {
   CHMSignature sig[2];         /* 'ITLO'/'ITLS' */
   uint32_t Version;            /* = 1 */
   uint32_t HeaderSectionTableOffset;
   uint32_t HeaderSectionEntryCount;
   uint32_t PostHeaderTableSize;
   GUID guid;                   /* {0A9007C1-4076-11D3-8789-0000F8105754} */
} ITOLITLSHeader;


typedef struct _ChunkDirInfo {
	int64_t TopAOLIChunkIndex; /* -1 if none */
	int64_t FirstAOLLChunkIndex;
	int64_t LastAOLLChunkIndex;
	int64_t Unknown0;          /* 0 */
	uint32_t ChunkSize;        /* = $2000 if list $200 if Index */
	uint32_t QuickRefDensity;  /* = 2 */
	uint32_t unknown1;         /* = 0 */
	uint32_t DirDepth;         /* 1 there is no index, 2 if there is one level of AOLI 3 if two index levels etc */
	uint64_t unknown2;         /* 0 */
	int64_t DirEntryCount;     /* Number Of Directory Entries */
} ChunkDirInfo;

typedef struct _CAOLRec {
	CHMSignature sig;          /* 'CAOL' */
	uint32_t version;          /* 2 */
	uint32_t CAOLSize;         /* includes ITSF section = $50 */
	char CompilerID[2];        /* = "HH" */
	uint16_t unknown;          /* 0 */
	uint32_t unknown1;         /* $43ED or 0 */
	uint32_t DirChunkSize;     /* $2000 */
	uint32_t DirIndexChunkSize;/* $200 */
	uint32_t Unknown2;		   /* $100000 */
	uint32_t Unknown3;         /* $20000 */
	uint32_t Unknown4;
	uint32_t Unknown5;
	uint32_t Unknown6;         /* = 0 */
	ITSFHeader itsfheader;
} CAOLRec;

typedef struct _ITOLITLSPostHeader {
	uint32_t version;         /* 2 */
	uint32_t CAOLOffset;      /* usually $98 (is from start of PostHeader) */
	ChunkDirInfo ListChunkInfo;
	ChunkDirInfo IndexChunkInfo;
	uint32_t unknown3;        /* = $100000 */
	uint32_t Unknown4;        /* =  $20000 */
	uint64_t Unknown5;        /* 0 */
} ITOLITLSPostHeader;

typedef struct _IFCMRec {
	CHMSignature sig;         /* = 'IFCM' */
	uint32_t version;         /* = 1 */
	uint32_t ChunkSize;       /* = $2000 */
	uint32_t unknown;         /* = $100000 */
	uint32_t unknown1;        /* = -1 */
	uint32_t unknown2;        /* = -1 */
	uint32_t ChunkCount;
	uint32_t unknown3;        /* = 0 */
} IFCMRec;

typedef struct _LZXv3ControlData {
	CHMSignature sig;		  /* 'LZXC' */
	uint32_t version;
	uint32_t ResetInterval;
	uint32_t WindowSize;
	uint32_t CacheSize;
	uint32_t Unknown1;
	uint32_t Unknown2;        /* 0 */
} LZXv3ControlData;

typedef struct _LZXv3ResetTable {
	uint32_t version;
	uint32_t EntryCount;
	uint32_t EntrySize;
	uint32_t EntryStart;
	uint64_t UnCompressedSize;
	uint64_t CompressedSize;
	uint64_t BlockSize;       /* $8000 */
} LZXv3ResetTable;



extern GUID const ITSFHeaderGUID;
extern CHMSignature const ITSFFileSig;

extern GUID const ITSPHeaderGUID;
extern CHMSignature const ITSPHeaderSig;

extern CHMSignature const PMGIsig;

extern GUID const ITOLITLSGuid;

/*
 * this function will advance the stream to the end of the compressed integer
 * and return the value
 */
uint32_t GetCompressedInteger(ChmStream *Stream);

/*
 * returns the number of bytes written to the stream
 */
uint32_t WriteCompressedInteger(ChmStream *Stream, uint32_t ANumber);
uint32_t PutCompressedInteger(void *Buffer, uint32_t ANumber);

/*
 * stupid needed function
 */
int ChmCompareText(const char *S1, const char *S2);

const char *chm_basename(const char *name);

const char *print_guid(const GUID *guid);

const char *get_lcid_string(LCID lcid);

#endif /* __CHMBASE_H__ */
