#ifndef __CHMPROJECT_H__
#define __CHMPROJECT_H__ 1

#include "avltree.h"
#include "chmsitemap.h"
#include "chmwriter.h"

typedef enum {
	chmerror,
	chmwarning,
	chmhint,
	chmnote
} ChmProjectErrorKind;

typedef struct _ChmProject ChmProject;

typedef void (*ChmProgressCB) (ChmProject *project, const char *CurrentFile);
typedef void (*ChmErrorCB)(ChmProject *project, ChmProjectErrorKind errorkind, const char *msg, ...) __attribute__((format(printf, 3, 4)));

struct _ChmProject {
	char *hhp_filename;
	char *xml_filename;
	gboolean AutoFollowLinks;
	gboolean auto_index;				/* default: false */
	int auto_toc;
	gboolean compatibility;				/* true=1.0, false=1.1 (default) */
	char *default_font;
	char *default_page;
	GSList *htmlfiles;					/* of char *; html files */
	GSList *otherfiles;					/* of char *; Other files found in a scan files (.css, img etc) */
	GSList *alias;						/* of ContextNode * */
	char *index_filename;
	gboolean MakeBinaryTOC;				/* default: false */
	gboolean MakeBinaryIndex;			/* default: true */
	gboolean full_text_search;			/* default: false */
	gboolean display_compile_progress;
	gboolean display_compile_notes;
	gboolean enhanced_decompilation;
	gboolean flat;						/* default: true */
	LCID locale_id;
	ChmProgressCB OnProgress;
	ChmErrorCB onerror;
	/* though stored in the project file, it is only there for the program that uses the unit */
	/* since we actually write to a stream */
	char *out_filename;
	char *toc_filename;
	char *title;
	GSList *windows;					/* of ChmWindow * */
	GSList *mergefiles;					/* of char * */
	char *default_window;
	gboolean ScanHtmlContents;
	GSList *allowed_extensions;			/* of char * */
	AVLTree *TotalFileList;
	GSList *anchorlist;					/* of char */
	char *basepath;						/* location of the .hhp file. Needed to resolve relative paths */
	char *ReadmeMessage;				/* readme message */
	ChmSiteMap *toc;
	ChmSiteMap *index;
	ChmMemoryStream *tocstream;
	ChmMemoryStream *indexstream;
	char *custom_tab;
	char *sample_staging_path;
	char *sample_list_file;
	char *citation;
	char *copyright;
	int compress;
	gboolean create_chi_file;
	gboolean dbcs;
	char *error_log_file;
	char *fts_stop_list_filename;
	int cores;
};

ChmProject *ChmProject_Create(void);
void ChmProject_Destroy(ChmProject *project);
gboolean ChmProject_LoadFromXml(ChmProject *project, const char *filename);
gboolean ChmProject_LoadFromHhp(ChmProject *project, const char *filename);
gboolean ChmProject_SaveToXml(ChmProject *project, const char *filename);
gboolean ChmProject_SaveToHhp(ChmProject *project, const char *filename);
gboolean ChmProject_WriteChm(ChmProject *project, ChmStream *out);
void ChmProject_ShowUndefinedAnchors(ChmProject *project);
const char *ChmProject_ProjectDir(ChmProject *project);
void ChmProject_AddFileWithContext(ChmProject *project, const char *filename, int contextid, const char *contextname);

#endif /* __CHMPROJECT_H__ */
