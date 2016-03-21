#ifndef __CHMREADER_H__
#define __CHMREADER_H__

#include "chmsitemap.h"

typedef struct _ChmReader ChmReader;

typedef uint64_t *LZXResetTableArr;

typedef int32_t HelpContext;

typedef struct _ContextItem {
	HelpContext context;
	const char *url;
} ContextItem;

typedef GSList ContextList; /* of ContextItem */

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

typedef struct _ITSFReader ITSFReader;
typedef GSList StringList; /* of const char * */
typedef GSList WStringList; /* of chm_wchar_t * */

ITSFReader *ITSFReader_Create(ChmStream *AStream, gboolean FreeStreamOnDestroy);
void ITSFReader_Destroy(ITSFReader *reader);
void ITSFReader_Destroy(ITSFReader *reader);
gboolean ITSFReader_ReadHeader(ITSFReader *reader) G_GNUC_WARN_UNUSED_RESULT;
WStringList *ITSFReader_GetSections(ITSFReader *reader);
gboolean ITSFReader_IsValidFile(ITSFReader *reader);
gboolean ITSFReader_GetCompleteFileList(ITSFReader *reader, void *obj, FileEntryForEach ForEach);
gboolean ITSFReader_ObjectExists(ITSFReader *reader, const char *Name);
ChmMemoryStream *ITSFReader_GetObject(ITSFReader *reader, const char *Name); /* YOU must Free the stream */
LCID ITSFReader_GetLCID(ITSFReader *reader);
chm_error ITSFReader_GetError(ITSFReader *reader);
void ITSFReader_SetError(ITSFReader *reader, chm_error err);

ChmReader *ChmReader_Create(ChmStream *AStream, gboolean FreeStreamOnDestroy);
void ChmReader_Destroy(ChmReader *reader);

chm_nametype chm_get_nametype(const char *name, size_t len);

const char *ChmReader_ReadURLSTR(ChmReader *reader, uint32_t APosition);
const char *ChmReader_ReadStringsEntry(ChmReader *reader, uint32_t position, gboolean convslash);
/* returns a url */
const char *ChmReader_LookupTopicByID(ChmReader *reader, uint32_t ATopicID, const char **ATitle);
ChmSiteMap *ChmReader_GetTOCSitemap(ChmReader *reader, gboolean ForceXML /* = FALSE */);
ChmSiteMap *ChmReader_GetIndexSitemap(ChmReader *reader, gboolean ForceXML /* = FALSE */);
const ContextList *ChmReader_GetContextList(ChmReader *reader);
const char *ChmReader_GetContextUrl(ChmReader *reader, HelpContext Context);
ChmMemoryStream *ChmReader_GetObject(ChmReader *reader, const char *Name); /* YOU must Free the stream */
chm_error ChmReader_GetError(ChmReader *reader);
void ChmReader_SetError(ChmReader *reader, chm_error err);
const GSList *ChmReader_GetWindows(ChmReader *reader);
const ChmSystem *ChmReader_GetSystem(ChmReader *reader);
ChmIdxhdr *ChmReader_GetIdxhdr(ChmReader *reader);
gboolean ChmReader_ObjectExists(ChmReader *reader, const char *name);
gboolean ChmReader_GetCompleteFileList(ChmReader *reader, void *obj, FileEntryForEach ForEach);
LCID ChmReader_GetLCID(ChmReader *reader);

const char *ChmErrorToStr(chm_error Error);

#endif /* __CHMREADER_H__ */
