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
const char *ContextList_GetURL(const ContextList *list, HelpContext Context);
void ContextList_Destroy(ContextList *list);

typedef enum {
	/*
	 * object name is not internal.
	 */
	chm_name_external,
	/*
	 * object name is empty (never allowed)
	 */
	chm_name_empty,
	/*
	 * object name is related to ITSF storage, i.e.
	 * ::DataSpace/NameList
	 */
	chm_name_storage,
	/*
	 * object name is internal name,
	 * ie /#SYSTEM
	 */
	chm_name_internal
} chm_nametype;

typedef struct _ChmFileInfo {
	const char *name;
	size_t namelen;
	chm_nametype type;
	chm_off_t offset;
	chm_off_t uncompressedsize;
	uint32_t section;
} ChmFileInfo;

typedef void (*FileEntryForEach)(void *obj, const ChmFileInfo *info);

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
gboolean ITSFReader_GetCompleteFileList(ITSFReader *reader, void *obj, FileEntryForEach ForEach);
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

chm_nametype chm_get_nametype(const char *name, size_t len);

const char *ChmReader_ReadURLSTR(ChmReader *reader, uint32_t APosition);
char *ChmReader_ReadStringsEntry(ChmReader *reader, uint32_t position);
/* returns a url */
const char *ChmReader_LookupTopicByID(ChmReader *reader, uint32_t ATopicID, char **ATitle);
ChmSiteMap *ChmReader_GetTOCSitemap(ChmReader *reader, gboolean ForceXML /* = FALSE */);
ChmSiteMap *ChmReader_GetIndexSitemap(ChmReader *reader, gboolean ForceXML /* = FALSE */);
const ContextList *ChmReader_GetContextList(ChmReader *reader);
const char *ChmReader_GetContextUrl(ChmReader *reader, HelpContext Context);
CHMMemoryStream *ChmReader_GetObject(ChmReader *reader, const char *Name); /* YOU must Free the stream */
chm_error ChmReader_GetError(ChmReader *reader);
const GSList *ChmReader_GetWindows(ChmReader *reader);
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
