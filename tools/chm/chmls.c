#include "chmtools.h"
#include "chmreader.h"
#include "xgetopt.h"
#include "chmxml.h"

char const gl_program_name[] = "chmls";
char const gl_program_version[] = "1.0";

typedef enum _CmdEnum {
	cmdnone,
	cmdlist,
	cmdextract,
	cmdextractall,
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
	OPTION_NULLS = '0',
	
	OPTION_INTERNALS = 256,
	OPTION_NO_INTERNALS,
	OPTION_FORCEXML,
};

static struct option const long_options[] = {
	{ "help", no_argument, NULL, OPTION_HELP },
	{ "name-only", no_argument, NULL, OPTION_NAME_ONLY },
	{ "no-page", no_argument, NULL, OPTION_NO_PAGE },
	{ "verbose", no_argument, NULL, OPTION_VERBOSE },
	{ "internals", no_argument, NULL, OPTION_INTERNALS },
	{ "no-internals", no_argument, NULL, OPTION_NO_INTERNALS },
	{ "null", no_argument, NULL, OPTION_NULLS },
	{ "forcexml", no_argument, NULL, OPTION_FORCEXML },
	
	{ NULL, no_argument, NULL, 0 }
};

int verbose = 0;
static gboolean nameonly = FALSE;
static gboolean include_internals = TRUE;
static gboolean printnulls = FALSE;
static gboolean forcexml = FALSE;


/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

typedef struct _ListObject {
	uint32_t section;
	uint32_t count;
	uint32_t listed;
	gboolean nameonly;
	gboolean printnulls;
	gboolean include_internals;
	FILE *out;
} ListObject;

static void ListObject_OnFileEntry(void *obj, const ChmFileInfo *info)
{
	ListObject *list = (ListObject *)obj;
	
	++list->count;
	if (!list->include_internals && info->type != chm_name_external)
		return;
	if (list->section != (uint32_t)-1 && info->section != list->section)
		return;
	if (list->listed == 0)
	{
		if (!list->nameonly)
			fprintf(list->out, _("<Section>   <Offset> <UnCompSize> "));
		if (!list->nameonly)
			fprintf(list->out, _("<Name>\n"));
	}
	++list->listed;
	if (!list->nameonly)
	{
		fprintf(list->out, _("%9u %10" PRIu64 " %12" PRIu64 " "), info->section, info->offset, info->uncompressedsize);
	}
	fputs(info->name, list->out);
	fputc(list->nameonly && list->printnulls ? 0 : '\n', list->out);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ListChm(FILE *out, const char *filename, uint32_t section)
{
	ListObject listObject;
	ChmStream *Stream;
	ITSFReader *itsf;
	gboolean result = FALSE;
	chm_error err;
	
	if ((Stream = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	
	listObject.section = section;
	listObject.count = 0;
	listObject.listed = 0;
	listObject.nameonly = nameonly;
	listObject.printnulls = printnulls;
	listObject.include_internals = include_internals;
	listObject.out = out;
	
	itsf = ITSFReader_Create(Stream, TRUE);
	if ((err = ITSFReader_GetError(itsf)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else
	{
		result = TRUE;
		ITSFReader_GetCompleteFileList(itsf, &listObject, ListObject_OnFileEntry);
	
		if (!listObject.nameonly)
		{
			if (listObject.listed == listObject.count)
				fprintf(out, _("Total Files in chm: %u\n"), listObject.count);
			else
				fprintf(out, _("Total Files in chm: %u (%u listed)\n"), listObject.count, listObject.listed);
		}
	}
	ITSFReader_Destroy(itsf);

	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean savetofile(ChmStream *from, FILE *out)
{
	chm_off_t size;
	size_t count, written;
#define COPY_BUFSIZE 4096
	char buf[COPY_BUFSIZE];
	
	size = ChmStream_Size(from);
	while (size)
	{
		count = size > COPY_BUFSIZE ? COPY_BUFSIZE : size;
		if (ChmStream_Read(from, buf, count) == FALSE)
		{
			return FALSE;
		}
		written = fwrite(buf, 1, count, out);
		if (written != count)
		{
			return FALSE;
		}
		size -= count;
	}
	return TRUE;
}

static gboolean ExtractFile(const char *filename, const char *readfrom, const char *saveto)
{
	ChmStream *stream;
	gboolean result = FALSE;
	chm_error err;
	ChmMemoryStream *m = NULL;
	ITSFReader *itsf;
	ChmStream *os = NULL;
	
	if ((stream = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	itsf = ITSFReader_Create(stream, TRUE);
	if ((err = ITSFReader_GetError(itsf)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((m = ITSFReader_GetObject(itsf, readfrom)) == NULL)
	{
		fprintf(stderr, _("Can't find file %s in %s\n"), readfrom, filename);
	} else if ((os = ChmStream_Open(saveto, FALSE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, saveto, strerror(errno));
	} else
	{
		FILE *out = ChmStream_Fileptr(os);
		printf(_("Extracting ms-its:/%s::%s to %s\n"), filename, readfrom, saveto);
		result = savetofile(m, out);
		if (result == FALSE)
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, saveto, strerror(errno));
		ChmStream_Close(os);
	}
	
	ChmStream_Close(m);
	ITSFReader_Destroy(itsf);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

typedef struct _ExtractObject {
	const char *basedir;
	ITSFReader *r;
	gboolean include_internals;
	int errors;
} ExtractObject;

static char *craftpath(const char *path, const char *filename)
{
	size_t lenpath, lenfn;
	gboolean pathends, filenameends;
	char *result;
	
	lenpath = strlen(path);
	lenfn = strlen(filename);
	if (lenpath == 0)
	{
		result = g_strdup(filename);
	} else
	{
		pathends = FALSE;
		filenameends = FALSE;
		
		if (lenpath > 0 && (path[lenpath -1] == '/' || path[lenpath -1] == '\\'))
			pathends = TRUE;
	
		if (lenfn > 0 && (filename[0] == '/' || filename[0] == '\\'))
			filenameends = TRUE;
		
		if (pathends && filenameends)
			result = g_strconcat(path, filename + 1, NULL);
		else if (pathends || filenameends)
			result = g_strconcat(path, filename, NULL);
		else
			result = g_strconcat(path, "/", filename, NULL);
	}
	convslash(result);
	
	return result;
}


static gboolean mkleadingdirectories(const char *filename)
{
	char *trie = g_strdup(filename);
	char *p;
	int result;
	
	/*
	 * cut off filename first
	 */
	p = strrchr(trie, G_DIR_SEPARATOR);
	if (p == NULL)
	{
		g_free(trie);
		return TRUE;
	}
	*p = '\0';
	result = g_mkdir_with_parents(trie, 0755);
	g_free(trie);
	return result == 0;
}


static void ExtractObject_OnFileEntry(void *obj, const ChmFileInfo *info)
{
	ExtractObject *list = (ExtractObject *)obj;
	ChmMemoryStream *mem;
	
	if (info->namelen > 0 && info->name[info->namelen - 1] == '/')
	{
		fprintf(stderr, _("Skipping directory %s\n"), info->name);
		return;
	}
	if (info->uncompressedsize == 0)
	{
		fprintf(stderr, _("Skipping empty file %s\n"), info->name);
		return;
	}
	if (!list->include_internals && info->type != chm_name_external)
	{
		fprintf(stderr, _("Skipping internal file %s\n"), info->name);
		return;
	}
	mem = ITSFReader_GetObject(list->r, info->name);
	if (mem != NULL)
	{
		FILE *out;
		char *saveto;

		saveto = craftpath(list->basedir, info->name);
		mkleadingdirectories(saveto);
		
		if ((out = fopen(saveto, "wb")) == NULL)
		{
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, saveto, strerror(errno));
			list->errors++;
		} else
		{
			if (savetofile(mem, out) == FALSE)
			{
				fprintf(stderr, "%s: %s: %s\n", gl_program_name, saveto, strerror(errno));
				list->errors++;
			}
			fclose(out);
		}		
		ChmStream_Close(mem);
		g_free(saveto);
	} else
	{
		fprintf(stderr, _("Can't extract %s\n"), info->name);
		list->errors++;
	}
}

static gboolean ExtractFileAll(const char *filename, const char *dirto)
{
	ChmStream *stream;
	gboolean result = FALSE;
	chm_error err;
	ITSFReader *itsf;
	struct stat st;
	ExtractObject extractObject;
	
	if ((stream = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}

	if (stat(dirto, &st) != 0)
	{
		if (mkdir(dirto, 0755) != 0)
		{
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, dirto, strerror(errno));
			ChmStream_Close(stream);
			return FALSE;
		}
	}
	
	itsf = ITSFReader_Create(stream, TRUE);
	
	extractObject.basedir = dirto;
	extractObject.r = itsf;
	extractObject.include_internals = include_internals;
	extractObject.errors = 0;
	
	if ((err = ITSFReader_GetError(itsf)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else
	{
		ITSFReader_GetCompleteFileList(itsf, &extractObject, ExtractObject_OnFileEntry);
		result = extractObject.errors == 0;
	}
	
	ITSFReader_Destroy(itsf);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean extractalias(int argc, const char **argv)
{
	const char *symbolname = "helpid";
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const char *filename = argv[0];
	char *prefixfn;
	const ContextList *list;
	const ContextList *l;
	FILE *out;
	char *outname;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	if (argc > 1)
		prefixfn = g_strdup(argv[1]);
	else
		prefixfn = changefileext(filename, NULL);
	if (argc > 2)
		symbolname = argv[2];
	
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((list = ChmReader_GetContextList(r)) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file.\n"), "#IVB");
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
	const char *filename = argv[0];
	char *extractfn;
	ChmReader *r;
	ChmFileStream *fs;
	gboolean result = FALSE;
	chm_error err;
	ChmSiteMap *sitemap;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	if (argc > 1)
		extractfn = g_strdup(argv[1]);
	else
		extractfn = changefileext(filename, sttype == stTOC ? ".hhc" : ".hhk");
	
	r = ChmReader_Create(fs, TRUE);
	
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((sitemap = sttype == stTOC ? ChmReader_GetTOCSitemap(r, forcexml) : ChmReader_GetIndexSitemap(r, forcexml)) == NULL)
	{
		const char *internal;
		char *freeme = NULL;
		
		if (forcexml)
		{
			if (sttype == stTOC)
			{
				if (r->system && r->system->toc_file.c)
				{
					internal = r->system->toc_file.c;
				} else
				{
					freeme = changefileext(chm_basename(filename), ".hhc");
					internal = freeme;
				}
			} else
			{
				if (r->system && r->system->index_file.c)
				{
					internal = r->system->index_file.c;
				} else
				{
					freeme = changefileext(chm_basename(filename), ".hhk");
					internal = freeme;
				}
			}
		} else
		{
			internal = sttype == stTOC ? "#TOCIDX" : "$WWKeywordLinks";
		}
		fprintf(stderr, _("This CHM doesn't contain a %s internal file.\n"), internal);
		g_free(freeme);
	} else
	{
		if (ChmSiteMap_SaveToFile(sitemap, extractfn) == FALSE)
		{
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, extractfn, strerror(errno));
		} else
		{
			result = TRUE;
			if (strcmp(extractfn, "-") != 0)
				printf(_("extracted %s to %s\n"), sttype == stTOC ? "TOC" : "Index", extractfn);
		}
		ChmSiteMap_Destroy(sitemap);
	}

	g_free(extractfn);
	ChmReader_Destroy(r);
	return result;
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
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmIdxhdr *idx = NULL;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((idx = ChmReader_GetIdxhdr(r)) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file.\n"), "#IDXHDR");
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
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const ChmSystem *sys;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((sys = ChmReader_GetSystem(r)) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file. Odd.\n"), "#SYSTEM");
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
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const GSList *windows;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((windows = ChmReader_GetWindows(r)) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file. Odd.\n"), "#WINDOWS");
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

static gboolean printtopics(FILE *out, const char *filename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmMemoryStream *m = NULL;
	uint32_t i, entries;
	uint32_t cnt;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((m = ChmReader_GetObject(r, "/#TOPICS")) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file.\n"), "#TOPICS");
	} else
	{
		result = TRUE;
		entries = ChmStream_Size(m) / 16;
		for (i = 0; i < entries; i++)
		{
			fprintf(out, _("#TOPICS entry : %u\n"), i);
			cnt = chmstream_read_le32(m);
			fprintf(out, _(" TOCIDX index : %d\n"), cnt);
			fprintf(out, _(" Tag name     : "));
			cnt = chmstream_read_le32(m);
			if (cnt == 0xffffffff)
			{
				fprintf(out, "%d\n", cnt);
			} else
			{
				char *s = ChmReader_ReadStringsEntry(r, cnt);
				fprintf(out, "$%08x: %s\n", cnt, printnull(s));
				g_free(s);
			}
			fprintf(out, _(" Tag value    : "));
			cnt = chmstream_read_le32(m);
			if (cnt == 0xffffffff)
			{
				fprintf(out, "%d\n", cnt);
			} else
			{
				const char *s = ChmReader_ReadURLSTR(r, cnt);
				fprintf(out, "$%08x: %s\n", cnt, printnull(s));
			}
			cnt = chmstream_read_le16(m);
			fprintf(out, _(" contents val : %d (%s)\n"), cnt,
				cnt == 2 ? _("not in contents") :
				cnt == 6 ? _("in contents") :
				"unknown");
			cnt = chmstream_read_le16(m);
			fprintf(out, _(" unknown val  : %d (0,2,4,8,10,12,16,32)\n"), cnt);
		}
	}
	
	ChmStream_Close(m);
	ChmReader_Destroy(r);
	return result;
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
	fprintf(out, _(" -n, --name-only : only show \"name\" column in list output\n"));
	fprintf(out, _(" -v, --verbose   : increase verbosity\n"));
	fprintf(out, _(" -0, --null      : use null characters to separate filenames\n"));
	fprintf(out, _("     --forcexml  : read text version of file objects\n"));
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
		case OPTION_NAME_ONLY:
			nameonly = TRUE;
			break;
		case OPTION_NO_PAGE:
			/* ignored for compatibilty */
			break;
		case OPTION_VERBOSE:
			verbose++;
			break;
		case OPTION_INTERNALS:
			include_internals = TRUE;
			break;
		case OPTION_NO_INTERNALS:
			include_internals = FALSE;
			break;
		case OPTION_NULLS:
			printnulls = TRUE;
			break;
		case OPTION_FORCEXML:
			forcexml = TRUE;
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
	
	xml_init();
	
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
			if (printtopics(out, argv[0]) == FALSE)
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
	xml_exit();
	
	return exit_code;
}
