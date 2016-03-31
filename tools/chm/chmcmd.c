#include "chmtools.h"
#include "xgetopt.h"
#include "chmxml.h"
#include "chmproject.h"
#include <libxml/parser.h>

char const gl_program_name[] = "chmc";
char const gl_program_version[] = "1.0";

int verbose = 0;

enum {
	OPTION_HELP = 'h',
	OPTION_VERSION = 'V',
	OPTION_VERBOSE = 'v',
	
	OPTION_HTML_SCAN = 256,
	OPTION_NO_HTML_SCAN,
	OPTION_GENERATE_XML
};

static struct option const long_options[] = {
	{ "verbose", no_argument, NULL, OPTION_VERBOSE },
	{ "html-scan", no_argument, NULL, OPTION_HTML_SCAN },
	{ "no-html-scan", no_argument, NULL, OPTION_NO_HTML_SCAN },
	{ "generate-xml", no_argument, NULL, OPTION_GENERATE_XML },
	
	{ "help", no_argument, NULL, OPTION_HELP },
	{ "version", no_argument, NULL, OPTION_VERSION },

	{ NULL, no_argument, NULL, 0 }
};

static int html_scan = -1;
static gboolean generate_xml = FALSE;
static FILE *error_log;
static int errors;
static int warnings;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void onerror(ChmProject *project, ChmProjectErrorKind errorkind, const char *msg, ...)
{
	va_list args;
	
	if ((errorkind == chmhint && verbose >= 1) ||
		(errorkind == chmnote && verbose >= 1) ||
		(errorkind == chmerror) ||
		(errorkind == chmwarning))
	{
		const char *prefix;
		
		va_start(args, msg);
		if (error_log == NULL && project->error_log_file != NULL)
		{
			char *name = g_build_filename(project->basepath, project->error_log_file, NULL);
			error_log = fopen(name, "w");
			if (error_log == NULL)
			{
				fprintf(stderr, "%s: %s\n", name, strerror(errno));
				error_log = (FILE *)-1;
				errors++;
			}
			g_free(name);
		}
		switch (errorkind)
		{
			default:
			case chmerror: prefix = _("error: "); errors++; break;
			case chmwarning: prefix = _("warning: "); warnings++; break;
			case chmnote: prefix = _("note: "); break;
			case chmhint: prefix = _("hint: "); break;
		}
		fputs(prefix, stderr);
		vfprintf(stderr, msg, args);
		fputc('\n', stderr);
		va_end(args);
		if (error_log && error_log != (FILE *)-1 && error_log != stderr)
		{
			va_start(args, msg);
			fputs(prefix, error_log);
			vfprintf(error_log, msg, args);
			fputc('\n', error_log);
			va_end(args);
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

static gboolean processfile(const char *name)
{
	gboolean ishhp;
	ChmProject *project;
	gboolean ok;
	ChmStream *out;
	char *filename;
	
	{
		const char *p = strrchr(name, '.');
		ishhp = p == NULL || g_ascii_strcasecmp(p, ".hhp") == 0;
	}
	
	project = ChmProject_Create();
	project->onerror = onerror;
	
	if (ishhp)
	{
		ok = ChmProject_LoadFromHhp(project, name);
	} else
	{
		ok = ChmProject_LoadFromXml(project, name);
	}
	if (html_scan >= 0)
		project->ScanHtmlContents = html_scan;
	
	if (ok)
	{
		filename = g_build_filename(project->basepath, project->out_filename, NULL);
		
		out = ChmStream_Open(filename, FALSE);
		if (out == NULL)
		{
			project->onerror(project, chmerror, "%s: %s", filename, strerror(errno));
		} else
		{
			ChmProject_WriteChm(project, out);
			if (project->ScanHtmlContents)
				ChmProject_ShowUndefinedAnchors(project);
			ChmStream_Close(out);
			if (ishhp && generate_xml)
			{
				project->onerror(project, chmhint, _("Generating XML %s"), project->xml_filename);
				ChmProject_SaveToXml(project, project->xml_filename);
			}
		}
	}
			
	ChmProject_Destroy(project);
	
	if (error_log)
	{
		if (error_log != (FILE *)-1 && error_log != stderr)
			fclose(error_log);
		error_log = NULL;
	}
	
	return errors == 0;
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
	fprintf(out, _("Usage: %s [options] <filename>\n"), gl_program_name);
	fprintf(out, "\n");
	fprintf(out, _("The following options are available :\n"));
	fprintf(out, _(" --html-scan          : scan html for missing files or alinks\n"));
	fprintf(out, _(" --no-html-scan       : don't scan html for missing files or alinks\n"));
	fprintf(out, _(" -v, --verbose        : increase  verbosity level\n"));
	fprintf(out, _(" --generate-xml       : (if .hhp file), also generate a xml project from .hhp\n"));
	fprintf(out, _(" -h, --help           : print this text\n"));
	fprintf(out, _(" -V, --version        : print version and exit\n"));
}

/*** ---------------------------------------------------------------------- ***/

int main(int argc, const char **argv)
{
	int c;
	int exit_code = EXIT_SUCCESS;
	struct _getopt_data *d;
	
	getopt_init_r(gl_program_name, &d);
	while ((c = getopt_long_only_r(argc, argv, "hV?", long_options, NULL, d)) != EOF)
	{
		switch (c)
		{
		case OPTION_VERBOSE:
			verbose++;
			break;
		case OPTION_HTML_SCAN:
			html_scan = TRUE;
			break;
		case OPTION_NO_HTML_SCAN:
			html_scan = FALSE;
			break;
		case OPTION_GENERATE_XML:
			generate_xml = TRUE;
			break;
		
		case OPTION_HELP:
			usage(stdout);
			return EXIT_SUCCESS;
		case OPTION_VERSION:
			print_version(stdout);
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
	
	c = getopt_ind_r(d);
	argv += c;
	argc -= c;
	getopt_finish_r(&d);
	
	xml_init();

	LIBXML_TEST_VERSION;
	
	if (argc == 1)
	{
		if (processfile(argv[0]) == FALSE)
			exit_code = EXIT_FAILURE;
	} else
	{
		fprintf(stderr, _("%s: Wrong number of parameters\n"), gl_program_name);
		fprintf(stderr, _("try '%s --help' for more information.\n"), gl_program_name);
		exit_code = EXIT_FAILURE;
	}
	
	xmlCleanupParser();
	xml_exit();
	x_free_resources();
	
	return exit_code;
}
