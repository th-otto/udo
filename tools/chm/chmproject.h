#ifndef __CHMPROJECT_H__
#define __CHMPROJECT_H__ 1

#include "avltree.h"
#include "chmsitemap.h"

typedef enum {
	chmerror,
	chmwarning,
	chmhint,
	chmnote
} ChmProjectErrorKind;

typedef struct _ChmProject ChmProject;

typedef void (*ChmProgressCB) (ChmProject *project, const char *CurrentFile);
typedef void (*ChmErrorCB)(ChmProject *project, ChmProjectErrorKind errorkind, const char *msg, int detaillevel);

typedef struct _StringIndex StringIndex;

struct _ChmProject {
	char *hhp_filename;
	gboolean AutoFollowLinks;
	gboolean auto_index;				/* default: false */
	int auto_toc;
	gboolean compatibility;				/* true=1.0, false=1.1 (default) */
	char *default_font;
	char *default_page;
	GSList *files;						/* of char *; html files */
	GSList *otherfiles;					/* of char *; Other files found in a scan files (.css, img etc) */
	GSList *alias;						/* of ContextNode * */
	char **alias_contents;
	char **map_contents;
	char *index_filename;
	gboolean MakeBinaryTOC;				/* default: false */
	gboolean MakeBinaryIndex;			/* default: true */
	gboolean full_text_search;			/* default: false */
	gboolean display_compile_progress;
	gboolean display_compile_notes;
	gboolean enhanced_decompilation;
	gboolean flat;						/* default: true */
	LCID language_id;
	ChmProgressCB OnProgress;
	ChmErrorCB OnError;
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
	StringIndex *SpareString;
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
	char *fts_stop_list_file_name;
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
void ChmProject_LoadSitemaps(ChmProject *project);
void ChmProject_AddFileWithContext(ChmProject *project, const char *filename, int contextid, const char *contextname);
void ChmProject_Error(ChmProject *project, ChmProjectErrorKind errorkind, const char *msg, int detaillevel);

#endif /* __CHMPROJECT_H__ */
