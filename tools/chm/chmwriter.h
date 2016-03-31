#ifndef __CHMWRITER_H__
#define __CHMWRITER_H__ 1

#include "htmlindexer.h"

typedef struct _StringIndex StringIndex;

struct _StringIndex {
	char *TheString;
	int32_t StrId;
};

typedef struct _UrlStrIndex UrlStrIndex;
struct _UrlStrIndex {
	char *UrlStr;
	int32_t UrlStrId;
};

StringIndex *StringIndex_Create(void);
void StringIndex_Destroy(StringIndex *str);
UrlStrIndex *UrlStrIndex_Create(void);
void UrlStrIndex_Destroy(UrlStrIndex *str);


/*  DataName :  A FileName or whatever so that the getter can find and open the file to add */
/*  PathInChm:  This is the absolute path in the archive. i.e. /home/user/helpstuff/ */
/*			  becomes '/' and /home/user/helpstuff/subfolder/ > /subfolder/ */
/*  FileName :  /home/user/helpstuff/index.html > index.html */
/*  Stream   :  the file opened with DataName should be written to this stream */
typedef gboolean (*GetDataFunc)(void *obj, const char *dataname, ChmMemoryStream **stream);

typedef struct _ITSFWriter ITSFWriter;

struct _ITSFWriter {
	GetDataFunc OnGetFileData;
	void (*OnLastFile)(void *obj, void *sender);
	void *user_data;
	gboolean ForceExit;
	/* Contains a complete list of files in the chm including */
	/* uncompressed files and special internal files of the chm */
	FileEntryList *InternalFiles;
	uint32_t FrameSize;
	ChmStream *CurrentStream; /* used to buffer the files that are to be compressed */
	int CurrentIndex;
	ChmMemoryStream *Section0;
	ChmStream *Section1; /* Compressed Stream */
	chm_off_t Section1Size;
	ChmMemoryStream *Section1ResetTable; /* has a list of frame positions NOT window positions */
	ChmStream *DirectoryListings;
	ChmStream *OutStream;
	GSList *FilesToCompress;
	int FilesToCompressCount;
	gboolean DestroyStream;
	ChmStream *PostStream;
	uint32_t WindowSize;
	chm_off_t ReadCompressedSize; /* Current Size of Uncompressed data that went in Section1 (compressed) */
	gboolean PostStreamActive;
	/* Linear order of file */
	ITSFHeader ITSFheader;
	ITSFHeaderEntry HeaderSection0Table;	/* points to HeaderSection0 */
	ITSFHeaderEntry HeaderSection1Table;	/* points to HeaderSection1 */
	ITSFHeaderSuffix HeaderSuffix;			/* contains the offset of CONTENTSection0 from zero */
	ITSPHeaderPrefix HeaderSection0;
	ITSPHeader HeaderSection1; /* DirectoryListings header */
	char *ReadmeMessage;
	int cores;
	void (*WriteInternalFilesBefore)(ITSFWriter *itsf);
	void (*WriteInternalFilesAfter)(ITSFWriter *itsf);
	void (*WriteFinalCompressedFiles)(ITSFWriter *itsf);
	void (*FileAdded)(ITSFWriter *itsf, ChmStream *stream, const FileEntryRec *entry);
};

ITSFWriter *ITSFWriter_Create(ChmStream *OutStream, gboolean FreeStreamOnDestroy);
void ITSFWriter_Destroy(ITSFWriter *itsf);
void ITSFWriter_Execute(ITSFWriter *itsf);
gboolean ITSFWriter_AddStreamToArchive(ITSFWriter *itsf, const char *path, ChmStream *stream, gboolean compress, gboolean searchable);
gboolean ITSFWriter_PostAddStreamToArchive(ITSFWriter *itsf, const char *path, ChmStream *stream, gboolean compress, gboolean searchable);


typedef struct _ChmWriter ChmWriter;
struct _ChmWriter {
	ITSFWriter itsf;
	gboolean HasBinaryTOC;
	gboolean HasBinaryIndex;
	int codepage;
	LCID locale_id;
	gboolean dbcs;
	gboolean FullTextSearch;
	gboolean FullTextSearchAvailable;
	gboolean SearchTitlesOnly;
	ChmMemoryStream *StringsStream; /* the #STRINGS file */
	ChmMemoryStream* TopicsStream;  /* the #TOPICS file */
	ChmMemoryStream *URLTBLStream;  /* the #URLTBL file. has offsets of strings in URLSTR */
	ChmMemoryStream *URLSTRStream;  /* the #URLSTR file */
	ChmMemoryStream *FiftiMainStream;
	ChmMemoryStream *ContextStream; /* the #IVB file */
	ChmMemoryStream *IDXHdrStream; /* the #IDXHDR and chunk 13 in #SYSTEM */
	gboolean HasTOC;
	gboolean HasIndex;
	IndexedWordList *IndexedFiles;
	AVLTree *AvlStrings;			/* dedupe strings */
	AVLTree *AVLTopicdedupe;		/* Topic deduping, if we load it both from hhp and TOC */
	AVLTree *AvlURLStr;				/* dedupe urltbl + binindex must resolve URL to topicid */
	const GSList *windows;
	char *title;
	char *default_window;
	char *toc_filename;
	char *index_filename;
	char *default_font;
	char *default_page;
	const GSList *mergefiles;
	const ChmSiteMap *TocSitemap;
	gboolean HasKLinks;
	gboolean HasALinks;
	int NrTopics;
};

typedef int32_t HelpContext;

ChmWriter *ChmWriter_Create(ChmStream *OutStream, gboolean FreeStreamOnDestroy);
void ChmWriter_Destroy(ChmWriter *chm);
void ChmWriter_AppendTOC(ChmWriter *chm, ChmStream *stream);
void ChmWriter_AppendBinaryTOCFromSiteMap(ChmWriter *chm, ChmSiteMap *sitemap);
void ChmWriter_AppendBinaryIndexFromSiteMap(ChmWriter *chm, ChmSiteMap *sitemap, gboolean chw);
void ChmWriter_AppendBinaryTOCStream(ChmWriter *chm, ChmStream *stream);
void ChmWriter_AppendBinaryIndexStream(ChmWriter *chm, ChmStream *IndexStream, ChmStream *DataStream, ChmStream *MapStream, ChmStream *Propertystream, gboolean chw);
void ChmWriter_AppendIndex(ChmWriter *chm, ChmStream *stream);
void ChmWriter_AppendSearchDB(ChmWriter *chm, const char *name, ChmStream *stream);
void ChmWriter_AddContext(ChmWriter *chm, HelpContext context, const char *topic);
void ChmWriter_AddDummyALink(ChmWriter *chm);
void ChmWriter_SetWindows(ChmWriter *chm, const GSList *windows);
void ChmWriter_SetMergefiles(ChmWriter *chm, const GSList *mergefiles);
void ChmWriter_Execute(ChmWriter *chm);

#endif /* __CHMWRITER_H__ */
