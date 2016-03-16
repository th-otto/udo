#ifndef __CHMBASE_H__
#define __CHMBASE_H__ 1

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

typedef struct _PMGListChunk {
	CHMSignature PMGLsig;
	uint32_t UnusedSpace;		/* !!! this value can also represent the size of quickref area in the end of the chunk */
	uint32_t Unknown1;			/* always 0 */
	int32_t PreviousChunkIndex;	/* chunk number of the prev listing chunk when reading dir in sequence */
								/* (-1 if this is the first listing chunk) */
	int32_t NextChunkIndex;		/* chunk number of the next listing chunk (-1 if this is the last chunk */
} PMGListChunk;

typedef struct _PMGListChunkEntry {
	uint32_t NameLength;
	char *Name;					/* utf-8 */
	uint32_t ContentSection;
	uint64_t ContentOffset;
	uint64_t DecompressedLength;
} PMGListChunkEntry;

typedef struct _PMGIIndexChunk {
	CHMSignature PMGIsig;
	uint32_t UnusedSpace;		/* has a quickref area */
} PMGIIndexChunk;

typedef struct _PMGIIndexChunkEntry {
	uint32_t NameLength;
	char *Name;					/* utf-8 */
	uint32_t ListingChunk;
} PMGIIndexChunkEntry;

extern GUID const ITSFHeaderGUID;
extern CHMSignature const ITSFFileSig;

extern GUID const ITSPHeaderGUID;
extern CHMSignature const ITSPHeaderSig;

extern CHMSignature const PMGIsig;

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


#endif /* __CHMBASE_H__ */
