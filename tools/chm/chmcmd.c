#include "chmtools.h"
#include "xgetopt.h"
#include "chmxml.h"
#include "chmproject.h"

char const gl_program_name[] = "chmc";
char const gl_program_version[] = "1.0";

int verbose = 0;

enum {
	OPTION_HELP = 'h',
	OPTION_OUTPUT = 'o',
	OPTION_VERSION = 'V',
	OPTION_VERBOSE = 'v',
};

static struct option const long_options[] = {
	{ "output", required_argument, NULL, OPTION_OUTPUT },
	{ "verbose", no_argument, NULL, OPTION_VERBOSE },

	{ "help", no_argument, NULL, OPTION_HELP },
	{ "version", no_argument, NULL, OPTION_VERSION },

	{ NULL, no_argument, NULL, 0 }
};

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
}

/*** ---------------------------------------------------------------------- ***/

int main(int argc, const char **argv)
{
	int c;
	int exit_code = EXIT_SUCCESS;
	struct _getopt_data *d;
	ChmProject *project;
	
	getopt_init_r(gl_program_name, &d);
	while ((c = getopt_long_only_r(argc, argv, "hnpV?", long_options, NULL, d)) != EOF)
	{
		switch (c)
		{
		
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
	
	project = ChmProject_Create();
	
	ChmProject_LoadFromHhp(project, "/home/sebilla/src/udo/tools/chm/tests/ss.hhp");
	ChmProject_SaveToXml(project, "-");
	
	ChmProject_Destroy(project);
	
	xml_exit();
	x_free_resources();
	
	return exit_code;
}
