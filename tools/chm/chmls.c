#include "chmtools.h"
#include "chmreader.h"
#include "xgetopt.h"

char const gl_program_name[] = "chmls";

typedef struct _ListObject {
	uint32_t section;
	uint32_t count;
	gboolean donotpage;
	gboolean nameonly;
	FILE *out;
} ListObject;

typedef enum _CmdEnum {
	cmdnone,
	cmdlist,
	cmdextract,
	cmdextractall,
	cmdunblock,
	cmdextractalias,
	cmdextracttoc,
	cmdextractindex,
	cmdprintidxhdr,
	cmdprintsystem,
	cmdprintwindows,
	cmdprinttopics
} CmdEnum;

static const char *const CmdNames[] = {
	NULL,
	"list",
	"extract",
	"extractall",
	"unblock",
	"extractalias",
	"extracttoc",
	"extractindex",
	"printidxhdr",
	"printsystem",
	"printwindows",
	"printtopics"
};

enum {
	OPTION_HELP = 'h',
	OPTION_NO_PAGE = 'p',
	OPTION_NAME_ONLY = 'n',
	OPTION_VERSION = 'V',
	OPTION_VERBOSE = 'v',
};

static struct option const long_options[] = {
	{ "help", no_argument, NULL, OPTION_HELP },
	{ "no-page", no_argument, NULL, OPTION_NO_PAGE },
	{ "name-only", no_argument, NULL, OPTION_NAME_ONLY },
	{ "verbose", no_argument, NULL, OPTION_VERBOSE },
	
	{ NULL, no_argument, NULL, 0 }
};

int verbose = 0;
static gboolean donotpage = FALSE;
static gboolean nameonly = FALSE;


/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ListObject_OnFileEntry(void *obj, const char *Name, chm_off_t Offset, chm_off_t UncompressedSize, uint32_t ASection)
{
	ListObject *list = (ListObject *)obj;
	
	++list->count;
	if (list->section != (uint32_t)-1 && ASection != list->section)
		return;
	if (list->count == 1)
	{
		if (!list->nameonly)
			fprintf(list->out, _("<Section>   <Offset> <UnCompSize> "));
		fprintf(list->out, _("<Name>\n"));
	}
	if (!list->nameonly)
	{
		fprintf(list->out, _("%9u %10" PRIu64 " %12" PRIu64 " "), ASection, Offset, UncompressedSize);
	}
	fprintf(list->out, "%s\n", Name);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ListChm(FILE *out, const char *filename, uint32_t section)
{
	ListObject JunkObject;
	FILE *fp;
	CHMStream *Stream;
	ITSFReader *ITS;
	gboolean result = TRUE;
	chm_error err;
	
	if ((fp = fopen(filename, "rb")) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	Stream = CHMStream_CreateForFile(fp);
	
	JunkObject.section = section;
	JunkObject.count = 0;
	JunkObject.donotpage = donotpage;
	JunkObject.nameonly = nameonly;
	JunkObject.out = out;
	
	ITS = ITSFReader_Create(Stream, TRUE);
	if ((err = ITSFReader_GetError(ITS)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
		result = FALSE;
	} else
	{
		ITSFReader_GetCompleteFileList(ITS, &JunkObject, ListObject_OnFileEntry, TRUE);
	
		fprintf(out, _("Total Files in chm: %u\n"), JunkObject.count);
	}
	ITSFReader_Destroy(ITS);

	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean ExtractFile(const char *chm, const char *readfrom, const char *saveto)
{
	UNUSED(chm);
	UNUSED(readfrom);
	UNUSED(saveto);
	return FALSE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean ExtractFileAll(const char *chm, const char *dirto2)
{
	UNUSED(chm);
	UNUSED(dirto2);
	return FALSE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean unblockchms(int argc, const char **argv)
{
	UNUSED(argc);
	UNUSED(argv);
	return FALSE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static char *changefileext(const char *filename, const char *ext)
{
	const char *p;
	char *changed;
	char *tmp;
	
	p = strrchr(filename, '.');
	if (p == NULL)
		return g_strconcat(filename, ext, NULL);
	tmp = g_strndup(filename, p - filename);
	changed = g_strconcat(tmp, ext, NULL);
	g_free(tmp);
	return changed;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean extractalias(int argc, const char **argv)
{
	const char *symbolname = "helpid";
	FILE *fp;
	CHMFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const char *filename = argv[0];
	char *prefixfn;
	ContextList *list;
	ContextList *l;
	FILE *out;
	char *outname;
	
	if ((fp = fopen(filename, "rb")) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	if (argc > 1)
		prefixfn = g_strdup(argv[1]);
	else
		prefixfn = changefileext(filename, NULL);
	if (argc > 2)
		symbolname = argv[1];
	
	fs = CHMStream_CreateForFile(fp);
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((list = ChmReader_GetContextList(r)) == NULL)
	{
		fprintf(stderr, "This CHM doesn''t contain a #IVB internal file.\n");
	} else
	{
		outname = g_strconcat(prefixfn, ".ali", NULL);
		out = fopen(outname, "w");
		if (out == NULL)
		{
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, outname, strerror(errno));
		} else
		{
			fprintf(out, "; alias-file of %s, extracted by %s\n", chm_basename(filename), gl_program_name);
			fprintf(out, "\n");
			for (l = list; l; l = l->next)
			{
				const ContextItem *item = (const ContextItem *)l->data;
				fprintf(out, "%s%u = %s\n", symbolname, item->context, fixnull(item->url));
			}
			fclose(out);
			fprintf(stderr, _("created %s\n"), outname);
		}
		g_free(outname);

		outname = g_strconcat(prefixfn, ".hhm", NULL);
		out = fopen(outname, "w");
		if (out == NULL)
		{
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, outname, strerror(errno));
		} else
		{
			fprintf(out, "/* mapping of %s, extracted by %s */\n", chm_basename(filename), gl_program_name);
			fprintf(out, "\n");
			for (l = list; l; l = l->next)
			{
				const ContextItem *item = (const ContextItem *)l->data;
				fprintf(out, "#define %s%u %u\n", symbolname, item->context, item->context);
			}
			fclose(out);
			fprintf(stderr, _("created %s\n"), outname);
		}
		g_free(outname);
	}
	
	g_free(prefixfn);
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean extracttocindex(int argc, const char **argv, SiteMapType sttype)
{
	UNUSED(argc);
	UNUSED(argv);
	UNUSED(sttype);
	return FALSE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void print_idxhdr(FILE *out, ChmIdxhdr *idx)
{
	unsigned int i;
	
	fprintf(out, _("  Identifier tag               : %c%c%c%c\n"), idx->sig.sig[0], idx->sig.sig[1], idx->sig.sig[2], idx->sig.sig[3]);
	fprintf(out, _("  Unknown timestamp/checksum   : $%x\n"), idx->timestamp);
	fprintf(out, _("  Always 1                     : %d\n"), idx->unknown1);
	fprintf(out, _("  Number of topic nodes        : %u\n"), idx->num_topics);
	fprintf(out, _("  Unknown 2                    : %d\n"), idx->unknown2);
	fprintf(out, _("  ImageList                    : %s\n"), printnull(idx->imagelist.c));
	fprintf(out, _("  Unknown 3                    : %d\n"), idx->unknown3);
	fprintf(out, _("  Imagetype param text/site    : %d\n"), idx->imagetype_is_folder);
	fprintf(out, _("  Background value             : $%x\n"), idx->background);
	fprintf(out, _("  Foreground value             : $%x\n"), idx->foreground);
	fprintf(out, _("  Font                         : %s\n"), printnull(idx->font.c));
	fprintf(out, _("  Window styles                : $%x\n"), idx->window_styles);
	fprintf(out, _("  ExWindow styles              : $%x\n"), idx->exwindow_styles);
	fprintf(out, _("  Unknown 4                    : %d\n"), idx->unknown4);
	fprintf(out, _("  Framename                    : %s\n"), printnull(idx->framename.c));
	fprintf(out, _("  Windowname                   : %s\n"), printnull(idx->windowname.c));
	fprintf(out, _("  Number of Information Types  : %d\n"), idx->num_information_types);
	fprintf(out, _("  Unknown 5                    : %d\n"), idx->unknown5);
	fprintf(out, _("  Number of [MERGE FILES]      : %u\n"), idx->num_merge_files);
	fprintf(out, _("  Unknown 6                    : %d\n"), idx->unknown6);
	for (i = 0; i < idx->num_merge_files; i++)
		fprintf(out, _("     %u                        : %s\n"), i, printnull(idx->merge_files[i].c));
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printidxhdr(FILE *out, const char *filename)
{
	FILE *fp;
	CHMFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmIdxhdr *idx = NULL;
	
	if ((fp = fopen(filename, "rb")) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	fs = CHMStream_CreateForFile(fp);
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((idx = ChmReader_GetIdxhdr(r)) == NULL)
	{
		fprintf(stderr, "This CHM doesn''t contain a #IDXHDR internal file.\n");
	} else
	{
		result = TRUE;
		fprintf(out, "--- #IDXHDR ---\n");
		print_idxhdr(out, idx);
	}

	ChmIdxhdr_Destroy(idx);
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

#define NT_TICKSPERSEC        ((uint64_t)10000000UL)
#define NT_SECSPERDAY         86400UL
#define NT_SECS_1601_TO_1970  ((369 * 365 + 89) * (uint64_t)NT_SECSPERDAY)
#define NT_TICKS_1601_TO_1970 (NT_SECS_1601_TO_1970 * NT_TICKSPERSEC)

static gboolean printsystem(FILE *out, const char *filename)
{
	FILE *fp;
	CHMFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const ChmSystem *sys;
	
	if ((fp = fopen(filename, "rb")) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	fs = CHMStream_CreateForFile(fp);
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((sys = ChmReader_GetSystem(r)) == NULL)
	{
		fprintf(stderr, "This CHM doesn''t contain a #SYSTEM internal file. Odd.\n");
	} else
	{
		result = TRUE;
		fprintf(out, "--- #SYSTEM---\n");
		fprintf(out, _("Version                        : %u\n"), sys->version);
		fprintf(out, _("Contents file from [options]   : %s\n"), printnull(sys->toc_file.c));
		fprintf(out, _("Index file from [options]      : %s\n"), printnull(sys->index_file.c));
		fprintf(out, _("Default topic from [options]   : %s\n"), printnull(sys->default_page.c));
		fprintf(out, _("Title from [options]           : %s\n"), printnull(sys->caption.c));
		fprintf(out, _("LCID from HHP file             : $%04x\n"), sys->locale_id);
		fprintf(out, _("One if DBCS in use             : %d\n"), sys->dbcs);
		fprintf(out, _("One if fulltext search is on   : %d\n"), sys->fulltextsearch);
		fprintf(out, _("Non zero if there are KLinks   : %d\n"), sys->klinks);
		fprintf(out, _("Non zero if there are ALinks   : %d\n"), sys->alinks);
		{
			time_t t = (sys->timestamp - NT_TICKS_1601_TO_1970) / NT_TICKSPERSEC;
			char *s = ctime(&t);
			char *p = strchr(s, '\n');
			if (p) *p = '\0';
			fprintf(out, _("Timestamp                      : $%016" PRIx64 " (%s)\n"), sys->timestamp, s);
		}
		fprintf(out, _("Collection                     : %d\n"), sys->collection);
		fprintf(out, _("Unknown1                       : %d\n"), sys->unknown1);
		fprintf(out, _("Default Window from [options]  : %s\n"), printnull(sys->default_window.c));
		fprintf(out, _("Compiled file from [options]   : %s\n"), printnull(sys->chm_filename.c));
		fprintf(out, _("DWord when Binary Index is on  : $%x\n"), sys->binary_index_dword);
		fprintf(out, _("Unknown2                       : $%x\n"), sys->unknown2);
		fprintf(out, _("Abbreviation                   : %s\n"), printnull(sys->abbrev.c));
		fprintf(out, _("Unknown3                       : %d\n"), sys->unknown3);
		fprintf(out, _("Abbreviation explanation       : %s\n"), printnull(sys->abbrev_explanation.c));
		fprintf(out, _("CHM compiler version           : %s\n"), printnull(sys->chm_compiler_version.c));
		{
			time_t t = sys->local_timestamp;
			char *s = ctime(&t);
			char *p = strchr(s, '\n');
			if (p) *p = '\0';
			fprintf(out, _("Local timestamp                : $%08" PRIx32 " (%s)\n"), sys->local_timestamp, s);
		}
		fprintf(out, _("DWord when Binary TOC is on    : $%x\n"), sys->binary_toc_dword);
		fprintf(out, _("Number of Information types    : %d\n"), sys->num_information_types);
		if (sys->idxhdr)
		{
			fprintf(out, _("IDXHDR:\n"));
			print_idxhdr(out, sys->idxhdr);
		}
		fprintf(out, _("MS Office related constants    : $%x\n"), sys->msoffice_windows);
		fprintf(out, _("Information type checksum      : $%x\n"), sys->info_type_checksum);
		fprintf(out, _("Preferred font                 : %s\n"), printnull(sys->preferred_font.c));
	}

	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printwindows(FILE *out, const char *filename)
{
	FILE *fp;
	CHMFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	GSList *windows;
	
	if ((fp = fopen(filename, "rb")) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	fs = CHMStream_CreateForFile(fp);
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((windows = ChmReader_GetWindows(r)) == NULL)
	{
		fprintf(stderr, "This CHM doesn''t contain a #WINDOWS internal file. Odd.\n");
	} else
	{
		const GSList *l;
		const CHMWindow *win;
		
		result = TRUE;
		fprintf(out, "--- #WINDOWS---\n");
		fprintf(out, _("Entries in #Windows                              : %u\n"), g_slist_length(windows));
		for (l = windows; l; l = l->next)
		{
			win = (const CHMWindow *)l->data;
			fprintf(out, _("Structure size                                   : %u %s\n"), win->version,
				win->version == CHM_WIN_MINSIZE ? "Compatibility 1.0" :
				win->version == CHM_WIN_V3SIZE ? "Compatibility 1.1 or later" :
				"unknown");
			fprintf(out, _("UniCodeStrings                                   : %d\n"), win->unicode_strings);
			fprintf(out, _("Window Name                                      : %s\n"), printnull(win->window_name.c));
			fprintf(out, _("Valid window parameters                          : $%x\n"), win->flags);
#define yesno(x) win->flags & HHWIN_PARAM_##x ? _("yes") : _("no")
			fprintf(out, _("  Window properties                              : %s\n"), yesno(PROPERTIES));
			fprintf(out, _("  Window style flags                             : %s\n"), yesno(STYLES));
			fprintf(out, _("  Window extended style flags                    : %s\n"), yesno(EXSTYLES));
			fprintf(out, _("  Initial window position                        : %s\n"), yesno(RECT));
			fprintf(out, _("  Navigation pane width                          : %s\n"), yesno(NAV_WIDTH));
			fprintf(out, _("  Window show state                              : %s\n"), yesno(SHOWSTATE));
			fprintf(out, _("  Info types                                     : %s\n"), yesno(INFOTYPES));
			fprintf(out, _("  Toolbar Buttons                                : %s\n"), yesno(TB_FLAGS));
			fprintf(out, _("  Navigation Pane initially closed state         : %s\n"), yesno(EXPANSION));
			fprintf(out, _("  Tab position                                   : %s\n"), yesno(TABPOS));
			fprintf(out, _("  Tab order                                      : %s\n"), yesno(TABORDER));
			fprintf(out, _("  History count                                  : %s\n"), yesno(HISTORY_COUNT));
			fprintf(out, _("  Default Pane                                   : %s\n"), yesno(CUR_TAB));
			fprintf(out, _("  WM_NOTIFY id                                   : %s\n"), yesno(NOTIFY_ID));
#undef yesno
			fprintf(out, _("Window properties                                : $%x\n"), win->win_properties);
#define yesno(x) win->win_properties & HHWIN_PROP_##x ? _("yes") : _("no")
			fprintf(out, _("  Auto hide/show pane windows                    : %s\n"), yesno(TAB_AUTOHIDESHOW));
			fprintf(out, _("  Top-most window                                : %s\n"), yesno(ONTOP));
			fprintf(out, _("  No title bar                                   : %s\n"), yesno(NOTITLEBAR));
			fprintf(out, _("  No default window styles                       : %s\n"), yesno(NODEF_STYLES));
			fprintf(out, _("  No default extended window styles              : %s\n"), yesno(NODEF_EXSTYLES));
			fprintf(out, _("  Use a tri-pane window                          : %s\n"), yesno(TRI_PANE));
			fprintf(out, _("  No text on toolbar buttons                     : %s\n"), yesno(NOTB_TEXT));
			fprintf(out, _("  post WM_QUIT message when window closes        : %s\n"), yesno(POST_QUIT));
			fprintf(out, _("  Automatically sync contents and index          : %s\n"), yesno(AUTO_SYNC));
			fprintf(out, _("  Send tracking notification messages            : %s\n"), yesno(TRACKING));
			fprintf(out, _("  Include search tab in navigation pane          : %s\n"), yesno(TAB_SEARCH));
			fprintf(out, _("  Include history tab in navigation pane         : %s\n"), yesno(TAB_HISTORY));
			fprintf(out, _("  Include favorites tab in navigation pane       : %s\n"), yesno(TAB_FAVORITES));
			fprintf(out, _("  Put current HTML title in title bar            : %s\n"), yesno(CHANGE_TITLE));
			fprintf(out, _("  Only display the navigation window             : %s\n"), yesno(NAV_ONLY_WIN));
			fprintf(out, _("  Don't display a toolbar                        : %s\n"), yesno(NO_TOOLBAR));
			fprintf(out, _("  Menu                                           : %s\n"), yesno(MENU));
			fprintf(out, _("  Advanced FTS UI                                : %s\n"), yesno(TAB_ADVSEARCH));
			fprintf(out, _("  User controls window size/position             : %s\n"), yesno(USER_POS));
			fprintf(out, _("  Use custom tab #1                              : %s\n"), yesno(TAB_CUSTOM1));
			fprintf(out, _("  Use custom tab #2                              : %s\n"), yesno(TAB_CUSTOM2));
			fprintf(out, _("  Use custom tab #3                              : %s\n"), yesno(TAB_CUSTOM3));
			fprintf(out, _("  Use custom tab #4                              : %s\n"), yesno(TAB_CUSTOM4));
			fprintf(out, _("  Use custom tab #5                              : %s\n"), yesno(TAB_CUSTOM5));
			fprintf(out, _("  Use custom tab #6                              : %s\n"), yesno(TAB_CUSTOM6));
			fprintf(out, _("  Use custom tab #7                              : %s\n"), yesno(TAB_CUSTOM7));
			fprintf(out, _("  Use custom tab #8                              : %s\n"), yesno(TAB_CUSTOM8));
			fprintf(out, _("  Use custom tab #9                              : %s\n"), yesno(TAB_CUSTOM9));
			fprintf(out, _("  The window type has a margin                   : %s\n"), yesno(TB_MARGIN));
#undef yesno
			fprintf(out, _("Title Bar Text                                   : %s\n"), printnull(win->caption.c));
			fprintf(out, _("Window style flags                               : $%x\n"), win->styleflags);
			fprintf(out, _("Window extended style flags                      : $%x\n"), win->xtdstyleflags);
			fprintf(out, _("Initial window position                          : %d, %d, %d, %d\n"), win->pos.left, win->pos.top, win->pos.right, win->pos.bottom);
			fprintf(out, _("Window show state                                : %d\n"), win->show_state);
			fprintf(out, _("hwndHelp                                         : $%x\n"), win->hwndhelp);
			fprintf(out, _("hwndCaller                                       : $%x\n"), win->hwndcaller);
			fprintf(out, _("Info types                                       : $%x\n"), win->p_info_types);
			fprintf(out, _("hwndToolBar                                      : $%x\n"), win->hwndtoolbar);
			fprintf(out, _("hwndHTML                                         : $%x\n"), win->hwndhtml);
			fprintf(out, _("Width of navigation pane                         : $%x\n"), win->navpanewidth);
			fprintf(out, _("Topic pane position                              : %d, %d, %d, %d\n"), win->topic.left, win->topic.top, win->topic.right, win->topic.bottom);
			fprintf(out, _("TOC filename                                     : %s\n"), printnull(win->toc_file.c));
			fprintf(out, _("Index filename                                   : %s\n"), printnull(win->index_file.c));
			fprintf(out, _("Default filename                                 : %s\n"), printnull(win->default_file.c));
			fprintf(out, _("Home filename                                    : %s\n"), printnull(win->home_button_file.c));
			fprintf(out, _("Toolbar buttons                                  : $%x\n"), win->buttons);
#define yesno(x) win->buttons & HHWIN_BUTTON_##x ? _("yes") : _("no")
			fprintf(out, _("  Expand                                         : %s\n"), yesno(EXPAND));
			fprintf(out, _("  Back                                           : %s\n"), yesno(BACK));
			fprintf(out, _("  Forward                                        : %s\n"), yesno(FORWARD));
			fprintf(out, _("  Stop                                           : %s\n"), yesno(STOP));
			fprintf(out, _("  Refresh                                        : %s\n"), yesno(REFRESH));
			fprintf(out, _("  Home                                           : %s\n"), yesno(HOME));
			fprintf(out, _("  Browse forward                                 : %s\n"), yesno(BROWSE_FWD));
			fprintf(out, _("  Browse backward                                : %s\n"), yesno(BROWSE_BCK));
			fprintf(out, _("  Notes                                          : %s\n"), yesno(NOTES));
			fprintf(out, _("  Contents                                       : %s\n"), yesno(CONTENTS));
			fprintf(out, _("  Sync                                           : %s\n"), yesno(SYNC));
			fprintf(out, _("  Options                                        : %s\n"), yesno(OPTIONS));
			fprintf(out, _("  Print                                          : %s\n"), yesno(PRINT));
			fprintf(out, _("  Index                                          : %s\n"), yesno(INDEX));
			fprintf(out, _("  Search                                         : %s\n"), yesno(SEARCH));
			fprintf(out, _("  History                                        : %s\n"), yesno(HISTORY));
			fprintf(out, _("  Favorites                                      : %s\n"), yesno(FAVORITES));
			fprintf(out, _("  Jump 1                                         : %s\n"), yesno(JUMP1));
			fprintf(out, _("  Jump 2                                         : %s\n"), yesno(JUMP2));
			fprintf(out, _("  Zoom                                           : %s\n"), yesno(ZOOM));
			fprintf(out, _("  TOC Next                                       : %s\n"), yesno(TOC_NEXT));
			fprintf(out, _("  TOC Prev                                       : %s\n"), yesno(TOC_PREV));
#undef yesno
			fprintf(out, _("Not expanded                                     : %d\n"), win->not_expanded);
			fprintf(out, _("Navigation type                                  : %d (%s)\n"), win->navtype,
				win->navtype == HHWIN_NAVTYPE_TOC ? "HHWIN_NAVTYPE_TOC" :
				win->navtype == HHWIN_NAVTYPE_INDEX ? "HHWIN_NAVTYPE_INDEX" :
				win->navtype == HHWIN_NAVTYPE_SEARCH ? "HHWIN_NAVTYPE_SEARCH" :
				win->navtype == HHWIN_NAVTYPE_FAVORITES ? "HHWIN_NAVTYPE_FAVORITES" :
				win->navtype == HHWIN_NAVTYPE_HISTORY ? "HHWIN_NAVTYPE_HISTORY" :
				win->navtype == HHWIN_NAVTYPE_AUTHOR ? "HHWIN_NAVTYPE_AUTHOR" :
				"???");
			fprintf(out, _("Navigation pane positon                          : %d (%s)\n"), win->tabpos,
				win->tabpos == HHWIN_NAVTAB_TOP ? "HHWIN_NAVTAB_TOP" :
				win->tabpos == HHWIN_NAVTAB_LEFT ? "HHWIN_NAVTAB_LEFT" :
				win->tabpos == HHWIN_NAVTAB_BOTTOM ? "HHWIN_NAVTAB_BOTTOM" :
				"???");
			fprintf(out, _("Notification id                                  : %d\n"), win->wm_notify_id);
			fprintf(out, _("Tab order                                        : %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n"),
				win->taborder[0], win->taborder[1], win->taborder[2], win->taborder[3], win->taborder[4],
				win->taborder[5], win->taborder[6], win->taborder[7], win->taborder[8], win->taborder[9],
				win->taborder[10], win->taborder[11], win->taborder[12], win->taborder[13], win->taborder[14],
				win->taborder[15], win->taborder[16], win->taborder[17], win->taborder[18], win->taborder[19]);
			fprintf(out, _("History entries                                  : %d\n"), win->history);
			fprintf(out, _("Jump button 1 text                               : %s\n"), printnull(win->jump1_text.c));
			fprintf(out, _("Jump button 2 text                               : %s\n"), printnull(win->jump2_text.c));
			fprintf(out, _("Jump button 1 URL                                : %s\n"), printnull(win->jump1_url.c));
			fprintf(out, _("Jump button 2 URL                                : %s\n"), printnull(win->jump2_url.c));
			fprintf(out, _("Minimum window size                              : %d, %d, %d, %d\n"), win->minsize.left, win->minsize.top, win->minsize.right, win->minsize.bottom);
		}
	}
	
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printtopics(const char *chm)
{
	UNUSED(chm);
	return FALSE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void print_version(FILE *out)
{
	fprintf(out, _("%s, a CHM utility. (c) 2010 Free Pascal core.\n"), gl_program_name);
	fprintf(out, "\n");
}

/*** ---------------------------------------------------------------------- ***/

static void usage(FILE *out)
{
	print_version(out);
	fprintf(out, _("Usage: chmls [switches] [command] [command specific parameters]\n"));
	fprintf(out, "\n");
	fprintf(out, _("Switches :\n"));
	fprintf(out, _(" -h, --help      : this screen\n"));
	fprintf(out, _(" -p, --no-page   : do not page list output\n"));
	fprintf(out, _(" -n, --name-only : only show \"name\" column in list output\n"));
	fprintf(out, "\n");
	fprintf(out, _("Where command is one of the following or if omitted, equal to LIST.\n"));
	fprintf(out, _(" list           <filename> [section number]\n"));
	fprintf(out, _("                Shows contents of the archive's directory\n"));
	fprintf(out, _(" extract        <chm filename> <filename to extract> [saveasname]\n"));
	fprintf(out, _("                Extracts file <filename to get> from archive <filename>,\n"));
	fprintf(out, _("                and, if specified, saves it to [saveasname]\n"));
	fprintf(out, _(" extractall     <chm filename> [directory]\n"));
	fprintf(out, _("                Extracts all files from archive <filename> to directory\n"));
	fprintf(out, _("                <directory>\n"));
	fprintf(out, _(" unblockchm     <filespec1> [filespec2] ...\n"));
	fprintf(out, _("                Mass unblocks (XPsp2+) the relevant CHMs. Multiple files\n"));
	fprintf(out, _("                and wildcards allowed\n"));
	fprintf(out, _(" extractalias   <chmfilename> [basefilename] [symbolprefix]\n"));
	fprintf(out, _("                Extracts context info from file <chmfilename>\n"));
	fprintf(out, _("                to a <basefilename>.h and <basefilename>.ali,\n"));
	fprintf(out, _("                using symbols <symbolprefix>contextnr\n"));
	fprintf(out, _(" extracttoc     <chmfilename> [filename]\n"));
	fprintf(out, _("                Extracts the toc (mainly to check binary TOC)\n"));
	fprintf(out, _(" extractindex   <chmfilename> [filename]\n"));
	fprintf(out, _("                Extracts the index (mainly to check binary index)\n"));
	fprintf(out, _(" printidxhdr    <chmfilename>\n"));
	fprintf(out, _("                prints #IDXHDR in readable format\n"));
	fprintf(out, _(" printsystem    <chmfilename>\n"));
	fprintf(out, _("                prints #SYSTEM in readable format\n"));
	fprintf(out, _(" printwindows   <chmfilename>\n"));
	fprintf(out, _("                prints #WINDOWS in readable format\n"));
	fprintf(out, _(" printtopics    <chmfilename>\n"));
	fprintf(out, _("                prints #TOPICS in readable format\n"));
}

/*** ---------------------------------------------------------------------- ***/

static void WrongNrParam(CmdEnum cmd, int number)
{
	FILE *out = stderr;
	
	fprintf(out, _("%s: Wrong number of parameters for %s: %d\n"), gl_program_name, CmdNames[cmd], number);
	fprintf(out, _("try '%s --help' for more information.\n"), gl_program_name);
}

/*** ---------------------------------------------------------------------- ***/

#if 0
static void test(void)
{
	CHMWindow *win;
	CHMStream *stream;
	
	stream = CHMStream_CreateForFile(stdout);
	win = CHMWindow_Create("main=\"title\",\"hcp.hhc\",\"hcp.hhk\",\"default.html\",\"home.html\",\"jump1.html\",\"jump1 text\",\"jump2.html\",\"jump2 text\",0x63520,11,0x00304e,13,14,15,16,17,18,19,20");
	win->flags = ~0;
	CHMWindow_savetoxml(win, stream);
	stream->close(stream);
	exit(0);
}
#endif

/*** ---------------------------------------------------------------------- ***/

int main(int argc, const char **argv)
{
	int c;
	int exit_code = EXIT_SUCCESS;
	int i;
	CmdEnum cmd;
	char *end;
	uint32_t section = (uint32_t)-1;
	struct _getopt_data *d;
	FILE *out;
	
	out = stdout;
	
	getopt_init_r(gl_program_name, &d);
	while ((c = getopt_long_only_r(argc, argv, "hnpV?", long_options, NULL, d)) != EOF)
	{
		switch (c)
		{
		case OPTION_NO_PAGE:
			donotpage = TRUE;
			break;
		case OPTION_NAME_ONLY:
			nameonly = TRUE;
			break;
		case OPTION_VERBOSE:
			verbose++;
			break;
		case OPTION_VERSION:
			print_version(stdout);
			return EXIT_SUCCESS;
		case OPTION_HELP:
			usage(stdout);
			return EXIT_SUCCESS;
		case '?':
			if (getopt_opt_r(d) == '?')
			{
				usage(stdout);
				return EXIT_SUCCESS;
			}
			return EXIT_FAILURE;
		case 0:
			/* option which just sets a var */
			break;
		default:
			/* error message already issued */
			return EXIT_FAILURE;
		}
	}
	
	if (optind == argc)
	{
		usage(stderr);
		return EXIT_FAILURE;
	}
	
	cmd = cmdnone;
	c = getopt_ind_r(d);
	for (i = 1; i < (int)(sizeof(CmdNames) / sizeof(CmdNames[0])); i++)
	{
		if (strcasecmp(CmdNames[i], argv[c]) == 0)
		{
			cmd = (CmdEnum) i;
			++c;
			break;
		}
	}
	if (cmd == cmdnone)
		cmd = cmdlist;
	argv += c;
	argc -= c;
	
	switch (cmd)
	{
	case cmdlist:
		switch (argc)
		{
		case 1:
			break;
		case 2:
			section = strtoul(argv[1], &end, 0);
			if (*end)
			{
				fprintf(stderr, _("Invalid value for section : %s\n"), argv[1]);
				exit_code = EXIT_FAILURE;
			}
			break;
		default:
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
			break;
		}
		if (exit_code == EXIT_SUCCESS && ListChm(out, argv[0], section) == FALSE)
			exit_code = EXIT_FAILURE;
		break;

	case cmdextract:
		switch (argc)
		{
		case 2:
			if (ExtractFile(argv[0], argv[1], chm_basename(argv[1])) == FALSE)
				exit_code = EXIT_FAILURE;
			break;
		case 3:
			if (ExtractFile(argv[0], argv[1], argv[2]) == FALSE)
				exit_code = EXIT_FAILURE;
			break;
		default:
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
			break;
		}
		break;

	case cmdextractall:
		switch (argc)
		{
		case 1:
			if (ExtractFileAll(argv[0], ".") == FALSE)
				exit_code = EXIT_FAILURE;
			break;
		case 2:
			if (ExtractFileAll(argv[0], argv[1]) == FALSE)
				exit_code = EXIT_FAILURE;
			break;
		default:
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
			break;
		}
		break;
	
	case cmdunblock:
		if (argc > 0)
		{
			if (unblockchms(argc, argv) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdextractalias:
		if (argc > 0)
		{
			if (extractalias(argc, argv) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdextracttoc:
		if (argc > 0)
		{
			if (extracttocindex(argc, argv, stTOC) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdextractindex:
		if (argc > 0)
		{
			if (extracttocindex(argc, argv, stIndex) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdprintidxhdr:
		if (argc == 1)
		{
			if (printidxhdr(out, argv[0]) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdprintsystem:
		if (argc == 1)
		{
			if (printsystem(out, argv[0]) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdprintwindows:
		if (argc == 1)
		{
			if (printwindows(out, argv[0]) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdprinttopics:
		if (argc == 1)
		{
			if (printtopics(argv[0]) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdnone:
		assert(0);
	
	}
	
	getopt_finish_r(&d);
	
	return exit_code;
}
