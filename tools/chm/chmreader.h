#ifndef __CHMREADER_H__
#define __CHMREADER_H__

#include "chmsitemap.h"
#include "chmfiftimain.h"

typedef uint64_t *LZXResetTableArr;

typedef int32_t HelpContext;

typedef struct _ContextItem {
	HelpContext context;
	char *url;
} ContextItem;

typedef GSList ContextList; /* of ContextItem */

void ContextList_AddContext(ContextList **list, HelpContext Context, char *Url);
const char *ContextList_GetURL(ContextList *list, HelpContext Context);
void ContextList_Destroy(ContextList *list);

typedef void (*FileEntryForEach)(void *obj, const char *Name, chm_off_t Offset, chm_off_t UncompressedSize, uint32_t Section);

/* ErrorCodes */
typedef enum _chm_error {
	CHM_ERR_NO_ERR = 0,
	CHM_ERR_STREAM_NOT_ASSIGNED = 1,
	CHM_ERR_NOT_SUPPORTED_VERSION = 2,
	CHM_ERR_NOT_VALID_FILE = 3
} chm_error;

typedef struct _ITSFReader {
/* protected: */
	CHMStream *Stream;
	gboolean FreeStreamOnDestroy;
	ITSFHeader ITSFheader;
	ITSFHeaderSuffix HeaderSuffix;
	ITSPHeader DirectoryHeader;
	chm_off_t DirectoryHeaderPos;
	chm_off_t DirectoryHeaderLength;
	chm_off_t DirectoryEntriesStartPos;
	PMGListChunkEntry CachedEntry; /* contains the last entry found by ObjectExists */
	uint32_t DirectoryEntriesCount;
/* public: */
	chm_error ChmLastError;
} ITSFReader;

typedef GSList StringList; /* of const char * */
typedef GSList WStringList; /* of chm_wchar_t * */

ITSFReader *ITSFReader_Create(CHMStream *AStream, gboolean FreeStreamOnDestroy);
void ITSFReader_Destroy(ITSFReader *reader);
void ITSFReader_Destroy(ITSFReader *reader);
gboolean ITSFReader_ReadHeader(ITSFReader *reader) G_GNUC_WARN_UNUSED_RESULT;
WStringList *ITSFReader_GetSections(ITSFReader *reader);
gboolean ITSFReader_IsValidFile(ITSFReader *reader);
gboolean ITSFReader_GetCompleteFileList(ITSFReader *reader, void *obj, FileEntryForEach ForEach, gboolean AIncludeInternalFiles /* = TRUE */);
gboolean ITSFReader_ObjectExists(ITSFReader *reader, const char *Name);
CHMMemoryStream *ITSFReader_GetObject(ITSFReader *reader, const char *Name); /* YOU must Free the stream */
chm_error ITSFReader_GetError(ITSFReader *reader);

typedef struct _ChmReader {
/* protected: */
	ContextList *contextList;
	CHMMemoryStream *TOPICSStream;
	CHMMemoryStream *URLSTRStream;
	CHMMemoryStream *URLTBLStream;
	CHMMemoryStream *StringsStream;
	GSList *WindowsList; /* of CHMWindow * */
	ChmSystem *system;
/* private: */
	ITSFReader *itsf;
	ChmSearchReader *SearchReader;
} ChmReader;

ChmReader *ChmReader_Create(CHMStream *AStream, gboolean FreeStreamOnDestroy);
void ChmReader_Destroy(ChmReader *reader);

const char *ChmReader_ReadURLSTR(ChmReader *reader, uint32_t APosition);
gboolean ChmReader_CheckCommonStreams(ChmReader *reader);
const char *ChmReader_LookupTopicByID(ChmReader *reader, uint32_t ATopicID, const char *const *ATitle); /* returns a url */
ChmSiteMap *ChmReader_GetTOCSitemap(ChmReader *reader, gboolean ForceXML /* = FALSE */);
ChmSiteMap *ChmReader_GetIndexSitemap(ChmReader *reader, gboolean ForceXML /* = FALSE */);
ContextList *ChmReader_GetContextList(ChmReader *reader);
const char *ChmReader_GetContextUrl(ChmReader *reader, HelpContext Context);
CHMMemoryStream *ChmReader_GetObject(ChmReader *reader, const char *Name); /* YOU must Free the stream */
chm_error ChmReader_GetError(ChmReader *reader);
GSList *ChmReader_GetWindows(ChmReader *reader);
const ChmSystem *ChmReader_GetSystem(ChmReader *reader);
ChmIdxhdr *ChmReader_GetIdxhdr(ChmReader *reader);

typedef struct _ChmFileList ChmFileList;
typedef void (*ChmFileOpenEvent)(ChmFileList *list, int Index);

struct _ChmFileList {
/* protected: */
	ChmReader *LastChm;
	StringList *UnNotifiedFiles;
	ChmFileOpenEvent OnOpenNewFile;
};

ChmFileList *ChmFileList_Create(const char *PrimaryFileName);
void ChmFileList_Destroy(ChmFileList *list);
CHMMemoryStream *ChmFileList_GetObject(ChmFileList *list, const char *Name);
gboolean ChmFileList_IsAnOpenFile(ChmFileList *list, const char *AFileName);
gboolean ChmFileList_ObjectExists(ChmFileList *list, const char *Name, ChmReader **fChm);

const char *ChmErrorToStr(chm_error Error);

#endif /* __CHMREADER_H__ */
