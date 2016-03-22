#include "chmtools.h"
#include "chmreader.h"
#include "chmsearchreader.h"
#include "xgetopt.h"
#include "chmxml.h"

char const gl_program_name[] = "chmls";
char const gl_program_version[] = "1.0";

int verbose = 0;

typedef enum _CmdEnum {
	cmdlist,
	cmdextract,
	cmdextractall,
	cmdextractalias,
	cmdextracttoc,
	cmdextractindex,
	cmdprintidxhdr,
	cmdprintsystem,
	cmdprintwindows,
	cmdprinttopics,
	cmdprintproject,
	cmdprintsearchindex,
	cmdlookup
} CmdEnum;

static const char *const CmdNames[] = {
	"list",
	"extract",
	"extractall",
	"extractalias",
	"extracttoc",
	"extractindex",
	"printidxhdr",
	"printsystem",
	"printwindows",
	"printtopics",
	"project",
	"printsearchindex",
	"lookup"
};

enum {
	OPTION_HELP = 'h',
	OPTION_NO_PAGE = 'p',
	OPTION_NAME_ONLY = 'n',
	OPTION_OUTPUT = 'o',
	OPTION_VERSION = 'V',
	OPTION_VERBOSE = 'v',
	OPTION_NULLS = '0',
	
	OPTION_LIST = 256,
	OPTION_EXTRACT,
	OPTION_EXTRACTALL,
	OPTION_EXTRACTALIAS,
	OPTION_EXTRACTTOC,
	OPTION_EXTRACTINDEX,
	OPTION_PRINTIDXHDR,
	OPTION_PRINTSYSTEM,
	OPTION_PRINTWINDOWS,
	OPTION_PRINTTOPICS,
	OPTION_PRINTPROJECT,
	OPTION_PRINTSEARCHINDEX,
	OPTION_LOOKUP,
	OPTION_INTERNALS,
	OPTION_NO_INTERNALS,
	OPTION_FORCEXML,
	OPTION_SECTION,
	OPTION_HELPID,
};

static struct option const long_options[] = {
	{ "list", no_argument, NULL, OPTION_LIST },
	{ "extract", no_argument, NULL, OPTION_EXTRACT },
	{ "extractall", no_argument, NULL, OPTION_EXTRACTALL },
	{ "alias", no_argument, NULL, OPTION_EXTRACTALIAS },
	{ "toc", no_argument, NULL, OPTION_EXTRACTTOC },
	{ "index", no_argument, NULL, OPTION_EXTRACTINDEX },
	{ "idxhdr", no_argument, NULL, OPTION_PRINTIDXHDR },
	{ "system", no_argument, NULL, OPTION_PRINTSYSTEM },
	{ "windows", no_argument, NULL, OPTION_PRINTWINDOWS },
	{ "topics", no_argument, NULL, OPTION_PRINTTOPICS },
	{ "project", no_argument, NULL, OPTION_PRINTPROJECT },
	{ "searchindex", no_argument, NULL, OPTION_PRINTSEARCHINDEX },
	{ "lookup", no_argument, NULL, OPTION_LOOKUP },
	{ "name-only", no_argument, NULL, OPTION_NAME_ONLY },
	{ "no-page", no_argument, NULL, OPTION_NO_PAGE },
	{ "verbose", no_argument, NULL, OPTION_VERBOSE },
	{ "internals", no_argument, NULL, OPTION_INTERNALS },
	{ "no-internals", no_argument, NULL, OPTION_NO_INTERNALS },
	{ "null", no_argument, NULL, OPTION_NULLS },
	{ "forcexml", no_argument, NULL, OPTION_FORCEXML },
	{ "output", required_argument, NULL, OPTION_OUTPUT },
	{ "section", required_argument, NULL, OPTION_SECTION },
	{ "helpid", required_argument, NULL, OPTION_HELPID },
	
	{ "help", no_argument, NULL, OPTION_HELP },
	{ "version", no_argument, NULL, OPTION_VERSION },

	{ NULL, no_argument, NULL, 0 }
};

typedef struct _ListObject {
	uint32_t section;
	uint32_t count;
	uint32_t listed;
	gboolean nameonly;
	gboolean printnulls;
	gboolean include_internals;
	gboolean flat;
	FILE *out;
} ListObject;

static ListObject listObject;

typedef struct _ExtractObject {
	const char *basedir;
	ITSFReader *r;
	gboolean include_internals;
	int errors;
} ExtractObject;

static ExtractObject extractObject;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static FILE *open_stdout(const char *filename)
{
	FILE *fp;
	
	if (empty(filename) || strcmp(filename, "-") == 0)
		return stdout;
	if ((fp = fopen(filename, "w")) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
	}
	return fp;
}

/*** ---------------------------------------------------------------------- ***/

static void close_stdout(FILE *fp)
{
	fflush(fp);
	if (fp != stdout)
		fclose(fp);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ListObject_OnFileEntry(void *obj, const ChmFileInfo *info)
{
	ListObject *list = (ListObject *)obj;
	
	++list->count;
	if (!list->include_internals && info->type != chm_name_external)
		return;
	if (list->section != (uint32_t)-1 && info->section != list->section)
		return;
	if (list->out)
	{
		if (list->listed == 0)
		{
			if (!list->nameonly)
				fprintf(list->out, _("<Section>   <Offset> <UnCompSize> "));
			if (!list->nameonly)
				fprintf(list->out, _("<Name>\n"));
		}
		if (!list->nameonly)
		{
			fprintf(list->out, _("%9u %10" PRIu64 " %12" PRIu64 " "), info->section, info->offset, info->uncompressedsize);
		}
		fputs(info->name, list->out);
		fputc(list->nameonly && list->printnulls ? 0 : '\n', list->out);
	}
	if (*info->name == '/' && strchr(info->name + 1, '/') != NULL)
		list->flat = FALSE;
	++list->listed;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ListChm(const char *filename, const char *outfilename)
{
	ChmStream *Stream;
	ITSFReader *itsf;
	gboolean result = FALSE;
	chm_error err;
	FILE *out;
	
	if ((Stream = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	
	itsf = ITSFReader_Create(Stream, TRUE);
	if ((err = ITSFReader_GetError(itsf)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((out = open_stdout(outfilename)) != NULL)
	{
		result = TRUE;

		listObject.out = out;
		
		ITSFReader_GetCompleteFileList(itsf, &listObject, ListObject_OnFileEntry);
	
		if (!listObject.nameonly)
		{
			if (listObject.listed == listObject.count)
				fprintf(out, _("Total Files in chm: %u\n"), listObject.count);
			else
				fprintf(out, _("Total Files in chm: %u (%u listed)\n"), listObject.count, listObject.listed);
		}
		
		close_stdout(out);
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

static gboolean ExtractFile(const char *filename, const char *readfrom, const char *outfilename)
{
	ChmStream *stream;
	gboolean result = FALSE;
	chm_error err;
	ChmMemoryStream *m = NULL;
	ITSFReader *itsf;
	ChmStream *os = NULL;
	const char *saveto = outfilename ? outfilename : chm_basename(readfrom);
	
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

static gboolean extractalias(const char *filename, const char *outfilename, const char *symbolname)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
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
	if (outfilename)
		prefixfn = g_strdup(outfilename);
	else
		prefixfn = changefileext(filename, NULL);
	
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((list = ChmReader_GetContextList(r)) == NULL)
	{
		fprintf(stderr, _("%s: %s: This CHM doesn't contain a %s internal file.\n"), gl_program_name, filename, "#IVB");
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

#define NT_TICKSPERSEC        ((uint64_t)10000000UL)
#define NT_SECSPERDAY         86400UL
#define NT_SECS_1601_TO_1970  ((369 * 365 + 89) * (uint64_t)NT_SECSPERDAY)
#define NT_TICKS_1601_TO_1970 (NT_SECS_1601_TO_1970 * NT_TICKSPERSEC)

static const char *make_time_t_string(uint32_t timestamp)
{
	time_t t = timestamp;
	char *s = ctime(&t);
	char *p = strchr(s, '\n');
	if (p) *p = '\0';
	return s;
}

static const char *make_filetime_string(uint64_t timestamp)
{
	time_t t = (timestamp - NT_TICKS_1601_TO_1970) / NT_TICKSPERSEC;
	char *s = ctime(&t);
	char *p = strchr(s, '\n');
	if (p) *p = '\0';
	return s;
}

static gboolean printproject(const char *filename, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	FILE *out;
	char *outname;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	if (outfilename)
		outname = g_strdup(outfilename);
	else
		outname = changefileext(filename, ".hhp");

	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((out = open_stdout(outname)) != NULL)
	{
		const ChmSystem *sys = ChmReader_GetSystem(r);
		char *o;
		const GSList *windows, *l;
		char *indexname;
		char *tocname;
		char *fts_stop_list_filename;
		const ContextList *contextlist;
		ChmIdxhdr *idx;
		gboolean print_defaults = TRUE;
		gboolean stp_success = FALSE; /* TODO */
		LCID compiler_lcid = 0;
		LCID os_lcid = ChmReader_GetLCID(r);
		
		if (sys && !empty(sys->chm_compiler_version.c))
			fprintf(out, ";Compiled by: %s\n", sys->chm_compiler_version.c);
		{
			ChmMemoryStream *BSSC;
			if ((BSSC = ChmReader_GetObject(r, "/#BSSC")) != NULL)
			{
				fprintf(out, ";Prepared using: RoboHelp version %.*s\n", (int)ChmStream_Size(BSSC), ChmStream_Memptr(BSSC));
				ChmStream_Close(BSSC);
			}
		}
		if (os_lcid)
		{
			const char *lcid_string = get_lcid_string(os_lcid);
			fprintf(out, ";Compilation operating system language: 0x%x %s\n", os_lcid, fixnull(lcid_string));
		}
		if (compiler_lcid)
		{
			const char *lcid_string = get_lcid_string(compiler_lcid);
			fprintf(out, ";Compiler language id: 0x%x %s\n", compiler_lcid, fixnull(lcid_string));
		}
		if (sys && sys->local_timestamp)
		{
			fprintf(out, ";Compilation date: %s (%u seconds after 0:00 Jan 1 1970)\n", make_time_t_string(sys->local_timestamp), sys->local_timestamp);
		}
		if (sys && sys->timestamp)
		{
			fprintf(out, ";Compilation date: %s (%" PRIu64 "00 nano-seconds after 0:00 Jan 1 1600)\n", make_filetime_string(sys->timestamp), sys->timestamp);
		}
				
		fprintf(out, "[OPTIONS]\n");
		if (sys && sys->caption.c)
			fprintf(out, "Title=%s\n", sys->caption.c);
		
		if (sys->version <= 2 || print_defaults)
			fprintf(out, "Compatibility=%s\n", sys && sys->version >= 3 ? "1.1 or later" : "1.0");
		
		o = sys && sys->chm_filename.c ? g_strconcat(sys->chm_filename.c, ".chm", NULL) : g_strdup(chm_basename(filename));
		fprintf(out, "Compiled file=%s\n", o);
		g_free(o);
		
		/* not really a setting that can be obtained from file */
		o = sys && sys->chm_filename.c ? g_strconcat(sys->chm_filename.c, ".log", NULL) : changefileext(chm_basename(filename), ".log");
		fprintf(out, "Error log=%s\n", o);
		g_free(o);

		/* not really a setting that can be obtained from file */
		fprintf(out, "Display compile progress=No\n");
		fprintf(out, "Display compile notes=No\n");
		
		if (sys != NULL && sys->toc_file.c != NULL)
		{
			tocname = g_strdup(sys->toc_file.c);
		} else if (sys != NULL && sys->chm_filename.c)
		{
			tocname = g_strconcat(sys->chm_filename.c, ".hhc", NULL);
		} else
		{
			tocname = changefileext(chm_basename(filename), ".hhc");
		}
		if (ChmReader_ObjectExists(r, "/#TOCIDX") ||
			ChmReader_ObjectExists(r, tocname))
		{
			fprintf(out, "Contents file=%s\n", tocname);
		}
		
		{
			gboolean binary_toc = (sys && sys->binary_toc_dword != 0) || ChmReader_ObjectExists(r, "/#TOCIDX");
			if (binary_toc || print_defaults)
				fprintf(out, "Binary TOC=%s\n", binary_toc ? "Yes" : "No");
		}
		
		if (sys != NULL && sys->index_file.c != NULL)
		{
			indexname = g_strdup(sys->index_file.c);
		} else if (sys != NULL && sys->chm_filename.c)
		{
			indexname = g_strconcat(sys->chm_filename.c, ".hhk", NULL);
		} else
		{
			indexname = changefileext(chm_basename(filename), ".hhk");
		}
		if (ChmReader_ObjectExists(r, "/$WWKeywordLinks/BTree") ||
			ChmReader_ObjectExists(r, indexname))
		{
			fprintf(out, "Index file=%s\n", indexname);
		}
		
		{
			gboolean binary_index = (sys && sys->binary_index_dword != 0) || ChmReader_ObjectExists(r, "/$WWKeywordLinks/BTree");
			if (!binary_index || print_defaults)
				fprintf(out, "Binary Index=%s\n", binary_index ? "Yes" : "No");
		}
		
		if (sys && sys->default_page.c)
			fprintf(out, "Default topic=%s\n", sys->default_page.c);

		if (sys && sys->default_window.c)
			fprintf(out, "Default Window=%s\n", sys->default_window.c);

		if (sys && sys->default_font.c)
			fprintf(out, "Default Font=%s\n", sys->default_font.c);

		{
			LCID lcid = 0;
			ChmSiteMap *sitemap;
			
			if (sys && sys->locale_id != 0)
				lcid = sys->locale_id;
			if (lcid == 0 && (sitemap = ChmReader_GetIndexSitemap(r, FALSE)) != NULL)
			{
				lcid = sitemap->lcid;
				ChmSiteMap_Destroy(sitemap);
			}
#if 0
			if (lcid == 0 && (sitemap = ChmReader_GetAssocSitemap(r, FALSE)) != NULL)
			{
				lcid = sitemap->lcid;
				ChmSiteMap_Destroy(sitemap);
			}
#endif
			/* FIXME: check the LCIDs in $OBJINST */
			if (lcid != 0)
			{
				const char *language_string = get_lcid_string(lcid);
				fprintf(out, "Language=0x%x %s\n", lcid, fixnull(language_string));
			}
		}
		
		{
			gboolean fts = (sys && sys->fulltextsearch) || ChmReader_ObjectExists(r, "/$FIftiMain");
			if (fts || print_defaults)
				fprintf(out, "Full-text search=%s\n", fts ? "Yes" : "No");
		}
			
		if (sys && (sys->klinks || print_defaults))
			fprintf(out, "Auto Index=%s\n", sys->klinks ? "Yes" : "No");
		
		{
			gboolean create_chi_file =
				ChmReader_ObjectExists(r, "/#SYSTEM") &&
				ChmReader_ObjectExists(r, "/$OBJINST") &&
				ChmReader_ObjectExists(r, "/$FIftiMain") &&
				!ChmReader_ObjectExists(r, "/$WWAssociativeLinks") &&
				!ChmReader_ObjectExists(r, "/$WWKeywordLinks") &&
				!ChmReader_ObjectExists(r, "/#IDXHDR") &&
				!ChmReader_ObjectExists(r, "/#TOCIDX") &&
				!ChmReader_ObjectExists(r, "/#URLSTR") &&
				!ChmReader_ObjectExists(r, "/#WINDOWS") &&
				!ChmReader_ObjectExists(r, "/#ITBITS") &&
				!ChmReader_ObjectExists(r, "/#STRINGS") &&
				!ChmReader_ObjectExists(r, "/#TOPICS") &&
				!ChmReader_ObjectExists(r, "/#URLTBL");
			if (create_chi_file || print_defaults)
				fprintf(out, "Create CHI file=%s\n", create_chi_file ? "Yes" : "No");
		}
		
		{
			gboolean dbcs = sys && sys->dbcs;
			if (dbcs || print_defaults)
				fprintf(out, "DBCS=%s\n", dbcs ? "Yes" : "No");
		}
		
		/* TODO: Auto TOC=9 */
		/* TODO: Enhanced decompilation=Yes/No */
		/* TODO: Custom Tabs=... */
		
		fts_stop_list_filename = changefileext(chm_basename(filename), ".stp");
		if (stp_success /* || print_defaults */)
			fprintf(out, "Full text search stop list file=%s\n", fts_stop_list_filename);
		
		/* get the setting of "Flat" by looking at the filenames */
		listObject.section = (uint32_t)-1;
		listObject.count = 0;
		listObject.listed = 0;
		listObject.nameonly = TRUE;
		listObject.printnulls = FALSE;
		listObject.include_internals = FALSE;
		listObject.flat = TRUE;
		listObject.out = NULL;
		ChmReader_GetCompleteFileList(r, &listObject, ListObject_OnFileEntry);
		if (!listObject.flat || print_defaults)
			fprintf(out, "Flat=%s\n", listObject.flat ? "Yes" : "No");
		fprintf(out, "\n");
		
		fprintf(out, "[WINDOWS]\n");
		windows = ChmReader_GetWindows(r);
		for (l = windows; l; l = l->next)
		{
			const ChmWindow *win = (const ChmWindow *)l->data;
			
			fprintf(out, "%s=%s,\"%s\",\"%s\",\"%s\",\"%s\",",
				fixnull(win->window_name.c),
				fixnull(win->caption.c),
				fixnull(win->toc_file.c),
				fixnull(win->index_file.c),
				fixnull(win->default_file.c),
				fixnull(win->home_button_file.c)
				);
			if (!empty(win->jump1_url.c))
				fprintf(out, "\"%s\"", win->jump1_url.c);
			fprintf(out, ",");
			if (!empty(win->jump1_text.c))
				fprintf(out, "\"%s\"", win->jump1_text.c);
			fprintf(out, ",");
			if (!empty(win->jump2_url.c))
				fprintf(out, "\"%s\"", win->jump2_url.c);
			fprintf(out, ",");
			if (!empty(win->jump2_text.c))
				fprintf(out, "\"%s\"", win->jump2_text.c);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_PROPERTIES)
				fprintf(out, "0x%x", win->win_properties);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_NAV_WIDTH)
				fprintf(out, "%d", win->navpanewidth);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_TB_FLAGS)
				fprintf(out, "0x%x", win->buttons);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_RECT)
				fprintf(out, "[%d,%d,%d,%d]", win->pos.left, win->pos.top, win->pos.right, win->pos.bottom);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_STYLES)
				fprintf(out, "0x%x", win->styleflags);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_EXSTYLES)
				fprintf(out, "0x%x", win->xtdstyleflags);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_SHOWSTATE)
				fprintf(out, "%d", win->show_state);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_EXPANSION)
				fprintf(out, "%d", win->not_expanded);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_CUR_TAB)
				fprintf(out, "%d", win->navtype);
			fprintf(out, ",");
			if (win->flags & HHWIN_PARAM_TABPOS)
				fprintf(out, "%d", win->tabpos);
			fprintf(out, ",");
			if ((win->flags & HHWIN_PARAM_NOTIFY_ID) || win->wm_notify_id)
				fprintf(out, "%d", win->wm_notify_id);
			fprintf(out, "\n");
		}
		fprintf(out, "\n");
		
		if ((contextlist = ChmReader_GetContextList(r)) != NULL)
		{
			char *fname;
			
			fprintf(out, "[ALIAS]\n");
			if (sys != NULL && sys->chm_filename.c)
			{
				fname = g_strconcat(sys->chm_filename.c, ".ali", NULL);
			} else
			{
				fname = changefileext(chm_basename(filename), ".ali");
			}
			fprintf(out, "#include \"%s\"\n", fname);
			fprintf(out, "\n");
			g_free(fname);
			
			fprintf(out, "[MAP]\n");
			if (sys != NULL && sys->chm_filename.c)
			{
				fname = g_strconcat(sys->chm_filename.c, ".hhm", NULL);
			} else
			{
				fname = changefileext(chm_basename(filename), ".hhm");
			}
			fprintf(out, "#include \"%s\"\n", fname);
			fprintf(out, "\n");
			g_free(fname);
		}

		if ((idx = ChmReader_GetIdxhdr(r)) != NULL && idx->num_merge_files != 0)
		{
			unsigned int i;
			
			fprintf(out, "[MERGE FILES]\n");
			for (i = 0; i < idx->num_merge_files; i++)
				fprintf(out, "%s\n", fixnull(idx->merge_files[i].c));
			fprintf(out, "\n");
		}
		ChmIdxhdr_Destroy(idx);
		
		/* TODO: [TEXT POPUPS] */
		/* TODO: [INFOTYPES] */
		/* TODO: [SUBSETS] */
		
		g_free(fts_stop_list_filename);
		g_free(tocname);
		g_free(indexname);
		close_stdout(out);
		result = TRUE;
	}
		
	g_free(outname);
	ChmReader_Destroy(r);
	return result;
}


/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean extracttocindex(const char *filename, const char *outfilename, SiteMapType sttype, gboolean forcexml)
{
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
	if (outfilename)
		extractfn = g_strdup(outfilename);
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
			const ChmSystem *sys = ChmReader_GetSystem(r);
			
			if (sttype == stTOC)
			{
				if (sys && sys->toc_file.c)
				{
					internal = sys->toc_file.c;
				} else
				{
					freeme = changefileext(chm_basename(filename), ".hhc");
					internal = freeme;
				}
			} else
			{
				if (sys && sys->index_file.c)
				{
					internal = sys->index_file.c;
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
	for (i = 0; i < idx->num_merge_files; i++)
		fprintf(out, _("     %3u                       : %s\n"), i, printnull(idx->merge_files[i].c));
	fprintf(out, _("  Unknown 6                    : %d\n"), idx->unknown6);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printidxhdr(const char *filename, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmIdxhdr *idx = NULL;
	FILE *out;
	
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
	} else if ((out = open_stdout(outfilename)) != NULL)
	{
		result = TRUE;
		fprintf(out, "--- #IDXHDR ---\n");
		print_idxhdr(out, idx);
		close_stdout(out);
	}

	ChmIdxhdr_Destroy(idx);
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

typedef struct _DumpObject {
	ChmSearchReader *search;
	FILE *out;
} DumpObject;

static void print_words(FILE *out, const char *word, gboolean title, const ChmWLCTopicArray hits)
{
	unsigned int i, j;
	
	if (hits == NULL)
		return;
	fprintf(out, "%s:%s\n", word, title ? _(" (in title)") : _(" (in text)"));
	for (i = 0; hits[i].LocationCodes != NULL; i++)
	{
		fprintf(out, "  %s (%u): ", printnull(hits[i].topic), hits[i].TopicIndex);
		for (j = 0; j < hits[i].NumLocationCodes; j++)
			fprintf(out, "%s%u", j == 0 ? "" : ", ", hits[i].LocationCodes[j]);
		fprintf(out, "\n");
	}
}

static void printsearchindex_cb(void *obj, const char *word, gboolean title, const ChmWLCTopicArray hits)
{
	DumpObject *dump = (DumpObject *)obj;
	print_words(dump->out, word, title, hits);
}

static gboolean printsearchindex(const char *filename, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmSearchReader *search = NULL;
	FILE *out;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((search = ChmSearchReader_Create(r)) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file.\n"), "#FIftiMain");
	} else if ((out = open_stdout(outfilename)) != NULL)
	{
		DumpObject dump;
		
		result = TRUE;
		dump.search = search;
		dump.out = out;
		fprintf(out, "--- #FIftiMain ---\n");
		ChmSearchReader_DumpData(search, printsearchindex_cb, &dump);
		close_stdout(out);
	}

	ChmSearchReader_Destroy(search);
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean lookupword(const char *filename, const char *word, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmSearchReader *search = NULL;
	FILE *out;
	
	if ((fs = ChmStream_Open(filename, TRUE)) == NULL)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, strerror(errno));
		return FALSE;
	}
	r = ChmReader_Create(fs, TRUE);
	if ((err = ChmReader_GetError(r)) != CHM_ERR_NO_ERR)
	{
		fprintf(stderr, "%s: %s: %s\n", gl_program_name, filename, ChmErrorToStr(err));
	} else if ((search = ChmSearchReader_Create(r)) == NULL)
	{
		fprintf(stderr, _("This CHM doesn't contain a %s internal file.\n"), "#FIftiMain");
	} else if ((out = open_stdout(outfilename)) != NULL)
	{
		ChmWLCTopicArray TitleHits;
		ChmWLCTopicArray WordHits;
		
		result = ChmSearchReader_LookupWord(search, word, &TitleHits, &WordHits, FALSE);
		if (TitleHits == NULL && WordHits == NULL)
			fprintf(stderr, "%s: %s: %s\n", gl_program_name, word, _("not found"));
		print_words(out, word, TRUE, TitleHits);
		print_words(out, word, FALSE, WordHits);
		ChmSearchReader_FreeTopics(TitleHits);
		ChmSearchReader_FreeTopics(WordHits);
		close_stdout(out);
	}

	ChmSearchReader_Destroy(search);
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printsystem(const char *filename, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const ChmSystem *sys;
	FILE *out;
	
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
	} else if ((out = open_stdout(outfilename)) != NULL)
	{
		result = TRUE;
		fprintf(out, "--- #SYSTEM---\n");
		fprintf(out, _("Version                        : %u\n"), sys->version);
		fprintf(out, _("Contents file from [options]   : %s\n"), printnull(sys->toc_file.c));
		fprintf(out, _("Index file from [options]      : %s\n"), printnull(sys->index_file.c));
		fprintf(out, _("Default topic from [options]   : %s\n"), printnull(sys->default_page.c));
		fprintf(out, _("Title from [options]           : %s\n"), printnull(sys->caption.c));
		fprintf(out, _("LCID from HHP file             : $%04x %s\n"), sys->locale_id, get_lcid_string(sys->locale_id) ? get_lcid_string(sys->locale_id): _("unknown"));
		fprintf(out, _("One if DBCS in use             : %d\n"), sys->dbcs);
		fprintf(out, _("One if fulltext search is on   : %d\n"), sys->fulltextsearch);
		fprintf(out, _("Non zero if there are KLinks   : %d\n"), sys->klinks);
		fprintf(out, _("Non zero if there are ALinks   : %d\n"), sys->alinks);
		fprintf(out, _("Timestamp                      : $%016" PRIx64 " (%s)\n"), sys->timestamp, make_filetime_string(sys->timestamp));
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
		fprintf(out, _("Local timestamp                : $%08" PRIx32 " (%s)\n"), sys->local_timestamp, make_time_t_string(sys->local_timestamp));
		fprintf(out, _("DWord when Binary TOC is on    : $%x\n"), sys->binary_toc_dword);
		fprintf(out, _("Number of Information types    : %d\n"), sys->num_information_types);
		if (sys->idxhdr)
		{
			fprintf(out, _("IDXHDR:\n"));
			print_idxhdr(out, sys->idxhdr);
		}
		fprintf(out, _("Custom Tabs                    : $%x\n"), sys->custom_tabs);
		fprintf(out, _("Information type checksum      : $%x\n"), sys->info_type_checksum);
		fprintf(out, _("Preferred font                 : %s\n"), printnull(sys->default_font.c));
		
		close_stdout(out);
	}

	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printwindows(const char *filename, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	const GSList *windows;
	FILE *out;
	
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
	} else if ((out = open_stdout(outfilename)) != NULL)
	{
		const GSList *l;
		const ChmWindow *win;
		
		result = TRUE;
		fprintf(out, "--- #WINDOWS---\n");
		fprintf(out, _("Entries in #Windows                              : %u\n"), g_slist_length(windows));
		for (l = windows; l; l = l->next)
		{
			win = (const ChmWindow *)l->data;
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
		
		close_stdout(out);
	}
	
	ChmReader_Destroy(r);
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean printtopics(const char *filename, const char *outfilename)
{
	ChmFileStream *fs;
	ChmReader *r;
	gboolean result = FALSE;
	chm_error err;
	ChmMemoryStream *m = NULL;
	uint32_t i, entries;
	uint32_t cnt;
	FILE *out;
	
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
	} else if ((out = open_stdout(outfilename)) != NULL)
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
				const char *s = ChmReader_ReadStringsEntry(r, cnt, FALSE);
				fprintf(out, "$%08x: %s\n", cnt, printnull(s));
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
		
		close_stdout(out);
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
	fprintf(out, _("Usage: chmls [switches] [command specific parameters]\n"));
	fprintf(out, "\n");
	fprintf(out, _("Switches :\n"));
	fprintf(out, _(" -n, --name-only            only show \"name\" column in list output\n"));
	fprintf(out, _(" -v, --verbose              increase verbosity\n"));
	fprintf(out, _(" -0, --null                 use null characters to separate filenames\n"));
	fprintf(out, _("     --forcexml             read text version of file objects\n"));
	fprintf(out, _("     --section <number>     specify section to list\n"));
	fprintf(out, _(" -o, --output <filename>    set output filename\n"));
	fprintf(out, _(" -h, --help                 this screen\n"));
	fprintf(out, "\n");
	fprintf(out, _("Where command is one of the following or if omitted, equal to LIST.\n"));
	fprintf(out, _(" --list         <filename>\n"));
	fprintf(out, _("                Shows contents of the archive's directory\n"));
	fprintf(out, _(" --extract      <chm filename> <filename to extract>\n"));
	fprintf(out, _("                Extracts file <filename to get> from archive <filename>,\n"));
	fprintf(out, _("                and, if specified, saves it to [saveasname]\n"));
	fprintf(out, _(" --extractall   <chm filename> [directory]\n"));
	fprintf(out, _("                Extracts all files from archive <filename> to directory\n"));
	fprintf(out, _("                <directory>\n"));
	fprintf(out, _(" --alias        <chmfilename> [basefilename] [symbolprefix]\n"));
	fprintf(out, _("                Extracts context info from file <chmfilename>\n"));
	fprintf(out, _("                to a <basefilename>.h and <basefilename>.ali,\n"));
	fprintf(out, _("                using symbols <symbolprefix>contextnr\n"));
	fprintf(out, _(" --toc          <chmfilename>\n"));
	fprintf(out, _("                Extracts the toc (mainly to check binary TOC)\n"));
	fprintf(out, _(" --index        <chmfilename>\n"));
	fprintf(out, _("                Extracts the index (mainly to check binary index)\n"));
	fprintf(out, _(" --idxhdr       <chmfilename>\n"));
	fprintf(out, _("                prints #IDXHDR in readable format\n"));
	fprintf(out, _(" --system       <chmfilename>\n"));
	fprintf(out, _("                prints #SYSTEM in readable format\n"));
	fprintf(out, _(" --windows      <chmfilename>\n"));
	fprintf(out, _("                prints #WINDOWS in readable format\n"));
	fprintf(out, _(" --searchindex  <chmfilename>\n"));
	fprintf(out, _("                prints the complete keyword search index\n"));
	fprintf(out, _(" --lookup       <chmfilename> <word>\n"));
	fprintf(out, _("                looks up <word> in the keyword search index\n"));
}

/*** ---------------------------------------------------------------------- ***/

static void WrongNrParam(CmdEnum cmd, int number)
{
	FILE *out = stderr;
	
	fprintf(out, _("%s: Wrong number of parameters for %s: %d\n"), gl_program_name, CmdNames[cmd], number);
	fprintf(out, _("try '%s --help' for more information.\n"), gl_program_name);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean nameonly = FALSE;
static gboolean include_internals = TRUE;
static gboolean printnulls = FALSE;
static gboolean forcexml = FALSE;
static const char *outfilename;
static const char *symbolname = "helpid";
static uint32_t section = (uint32_t)-1;

int main(int argc, const char **argv)
{
	int c;
	int exit_code = EXIT_SUCCESS;
	CmdEnum cmd = cmdlist;
	char *end;
	struct _getopt_data *d;
	
	getopt_init_r(gl_program_name, &d);
	while ((c = getopt_long_only_r(argc, argv, "hnpV?", long_options, NULL, d)) != EOF)
	{
		switch (c)
		{
		case OPTION_LIST:
			cmd = cmdlist;
			break;
		case OPTION_EXTRACT:
			cmd = cmdextract;
			break;
		case OPTION_EXTRACTALL:
			cmd = cmdextractall;
			break;
		case OPTION_EXTRACTALIAS:
			cmd = cmdextractalias;
			break;
		case OPTION_EXTRACTTOC:
			cmd = cmdextracttoc;
			break;
		case OPTION_EXTRACTINDEX:
			cmd = cmdextractindex;
			break;
		case OPTION_PRINTIDXHDR:
			cmd = cmdprintidxhdr;
			break;
		case OPTION_PRINTSYSTEM:
			cmd = cmdprintsystem;
			break;
		case OPTION_PRINTWINDOWS:
			cmd = cmdprintwindows;
			break;
		case OPTION_PRINTTOPICS:
			cmd = cmdprinttopics;
			break;
		case OPTION_PRINTPROJECT:
			cmd = cmdprintproject;
			break;
		case OPTION_PRINTSEARCHINDEX:
			cmd = cmdprintsearchindex;
			break;
		case OPTION_LOOKUP:
			cmd = cmdlookup;
			break;
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
		case OPTION_OUTPUT:
			outfilename = getopt_arg_r(d);
			break;
		case OPTION_VERSION:
			print_version(stdout);
			return EXIT_SUCCESS;
		case OPTION_HELP:
			usage(stdout);
			return EXIT_SUCCESS;
		
		case OPTION_SECTION:
			section = strtoul(argv[1], &end, 0);
			if (*end)
			{
				fprintf(stderr, _("Invalid value for section : %s\n"), argv[1]);
				exit_code = EXIT_FAILURE;
			}
			break;
		case OPTION_HELPID:
			symbolname = getopt_arg_r(d);
			break;
		
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
	
	listObject.section = section;
	listObject.count = 0;
	listObject.listed = 0;
	listObject.nameonly = nameonly;
	listObject.printnulls = printnulls;
	listObject.include_internals = include_internals;
	listObject.flat = TRUE;
		
	extractObject.include_internals = include_internals;
	
	xml_init();
	
	c = getopt_ind_r(d);
	argv += c;
	argc -= c;
	
	switch (cmd)
	{
	case cmdlist:
		switch (argc)
		{
		case 1:
			break;
		default:
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
			break;
		}
		if (exit_code == EXIT_SUCCESS && ListChm(argv[0], outfilename) == FALSE)
			exit_code = EXIT_FAILURE;
		break;

	case cmdextract:
		switch (argc)
		{
		case 2:
			if (ExtractFile(argv[0], argv[1], outfilename) == FALSE)
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
		if (argc == 1)
		{
			if (extractalias(argv[0], outfilename, symbolname) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdextracttoc:
		if (argc == 1)
		{
			if (extracttocindex(argv[0], outfilename, stTOC, forcexml) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
			
	case cmdextractindex:
		if (argc == 1)
		{
			if (extracttocindex(argv[0], outfilename, stIndex, forcexml) == FALSE)
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
			if (printidxhdr(argv[0], outfilename) == FALSE)
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
			if (printsystem(argv[0], outfilename) == FALSE)
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
			if (printwindows(argv[0], outfilename) == FALSE)
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
			if (printtopics(argv[0], outfilename) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;

	case cmdprintproject:
		if (argc == 1)
		{
			if (printproject(argv[0], outfilename) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;

	case cmdprintsearchindex:
		if (argc == 1)
		{
			if (printsearchindex(argv[0], outfilename) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;

	case cmdlookup:
		if (argc == 2)
		{
			if (lookupword(argv[0], argv[1], outfilename) == FALSE)
				exit_code = EXIT_FAILURE;
		} else
		{
			WrongNrParam(cmd, argc);
			exit_code = EXIT_FAILURE;
		}
		break;
	}
	
	getopt_finish_r(&d);
	xml_exit();
	
	return exit_code;
}
