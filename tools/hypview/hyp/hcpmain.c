#include "hypdefs.h"
#include "hypdebug.h"
#include "xgetopt.h"
#include "hcp_opts.h"
#include "picture.h"
#include "hcp.h"
#ifdef HAVE_SETLOCALE
#include <locale.h>
#endif
#include "hv_vers.h"

char const gl_program_name[] = "hcp";
char const gl_program_version[] = HYP_VERSION;

/*****************************************************************************/
/* ------------------------------------------------------------------------- */
/*****************************************************************************/

static void print_version(FILE *out)
{
	char *url = g_strdup_printf(_("%s is Open Source (see %s for further information)."), gl_program_name, HYP_URL);
	char *compiler = hyp_compiler_version();
	char *msg = g_strdup_printf("%s %s\n"
		"%s\n"
		"Using %s\n"
		"%s\n",
		gl_program_name, gl_program_version,
		HYP_COPYRIGHT,
		printnull(compiler),
		printnull(url));
	
	fflush(stdout);
	fflush(stderr);
	hyp_utf8_fprintf(out, "%s", printnull(msg));
	g_free(msg);
	g_free(compiler);
	g_free(url);
}

/* ------------------------------------------------------------------------- */

#if 0
static void print_short_version(FILE *out)
{
	char *msg = g_strdup_printf("%s %s\n"
		"%s\n\n",
		gl_program_name, gl_program_version,
		HYP_COPYRIGHT);
	
	fflush(stdout);
	fflush(stderr);
	hyp_utf8_fprintf(out, "%s", printnull(msg));
	g_free(msg);
}
#endif

/* ------------------------------------------------------------------------- */

static void print_usage(FILE *out)
{
	print_version(out);
	hyp_utf8_fprintf(out, "\n");
	hyp_utf8_fprintf(out, _("usage: %s [+-options] file1 [+-options] file2 ...\n"), gl_program_name);
	hyp_utf8_fprintf(out, _("or:    %s -v [-oFILE] hypertext-file node1 node2 ...\n"), gl_program_name);
	hyp_utf8_fprintf(out, "\n");
	hyp_utf8_fprintf(out, _("options:\n"));
	hyp_utf8_fprintf(out, _("  +-a, --[no-]autoref           auto references +on/-off\n"));
	hyp_utf8_fprintf(out, _("  -b, --blocksize [SIZE]        set max. node size to SIZE kB\n"));
	hyp_utf8_fprintf(out, _("  +-c, --[no-]compression       turn compression +on/-off\n"));
	hyp_utf8_fprintf(out, _("  -d, --ref-distance [WIDTH]    minimal reference distance\n"));
	hyp_utf8_fprintf(out, _("  -e, --errorfile [FILE]        set error filename\n"));
	hyp_utf8_fprintf(out, _("  +-f, --[no-]alias-in-index    turn automatic adding of alias to index on/off\n"));
	hyp_utf8_fprintf(out, _("  +-g, --[no-]alabel-in-index   turn automatic adding of alabel to index on/off\n"));
	hyp_utf8_fprintf(out, _("  +-i, --[no-]index             turn index-table generation +on/-off\n"));
	hyp_utf8_fprintf(out, _("  -j, --index-width [WIDTH]     minimal index-column width\n"));
	hyp_utf8_fprintf(out, _("  -k, --compat-flags [VAL]      set compatibility flags\n"));
	hyp_utf8_fprintf(out, _("  -l, --list {FLAGS}            list contents of hypertext file\n"));
	hyp_utf8_fprintf(out, _("  +-m, --[no-]images            don't read images (test mode)\n"));
	hyp_utf8_fprintf(out, _("  +-n, --[no-]nodes-in-index    don't add nodes to index table\n"));
	hyp_utf8_fprintf(out, _("  -o, --output [FILE]           set output file name\n"));
	hyp_utf8_fprintf(out, _("  -p, --pic-format [VAL]        image type for recompiling\n"));
	hyp_utf8_fprintf(out, _("  -q[qq], --quiet               set quiet mode\n"));
	hyp_utf8_fprintf(out, _("  -r, --recompile               recompile a hypertext file\n"));
	hyp_utf8_fprintf(out, _("  +-s, --[no-]split             -don't split long lines\n"));
	hyp_utf8_fprintf(out, _("  -t, --tabwidth [VAL]          set tabulator width\n"));
	hyp_utf8_fprintf(out, _("  -u, --uses [FILE]             add a '@uses' file\n"));
	hyp_utf8_fprintf(out, _("  -v, --view                    view listed nodes as ASCII\n"));
	hyp_utf8_fprintf(out, _("  -w, --wait {VAL}              wait for keypress for exiting\n"));
	hyp_utf8_fprintf(out, _("  +-x, --[no]-title-in-index    use +title instead of name for index\n"));
	hyp_utf8_fprintf(out, _("  +-y, --caseinsensitive-first  first char is case insensitive\n"));
	hyp_utf8_fprintf(out, _("  -z[z], --references           write reference file\n"));
	hyp_utf8_fprintf(out, _("                                zz also updates default-reference-file\n"));
	hyp_utf8_fprintf(out, _("  -h, --help                    print help and exit\n"));
	hyp_utf8_fprintf(out, _("  -V, --version                 print version and exit\n"));
}


/* ------------------------------------------------------------------------- */

#define CMDLINE_VERSION 1

#include "outcomm.h"
#include "outasc.h"
#include "outstg.h"
#include "outhtml.h"
#include "outxml.h"
#include "outdump.h"

/*****************************************************************************/
/* ------------------------------------------------------------------------- */
/*****************************************************************************/

static void warn_if_empty(HYP_DOCUMENT *hyp, hcp_opts *opts)
{
	if (hyp->first_text_page == HYP_NOINDEX)
		hyp_utf8_fprintf(opts->errorfile, _("%s%s does not have any text pages\n"), _("warning: "), hyp->file);
	if (hyp->comp_vers > HCP_COMPILER_VERSION)
		hyp_utf8_fprintf(opts->errorfile, _("%s%s created by compiler version %u\n"), _("warning: "), hyp->file, hyp->comp_vers);
}

/* ------------------------------------------------------------------------- */

static gboolean recompile(const char *filename, hcp_opts *opts, recompile_func func, int argc, const char **argv, const char *defext)
{
	gboolean retval;
	HYP_DOCUMENT *hyp;
	char *dir;
	char *output_filename = NULL;
	hyp_filetype type = HYP_FT_NONE;
	int handle;
	hcp_opts hyp_opts;
	
	if ((opts->errorfile == NULL || opts->errorfile == stderr) && opts->error_filename != NULL)
	{
		opts->errorfile = hyp_utf8_fopen(opts->error_filename, "w");
		if (opts->errorfile == NULL)
		{
			hyp_utf8_fprintf(stderr, "%s: %s\n", opts->error_filename, hyp_utf8_strerror(errno));
			return FALSE;
		}
	}

	handle = hyp_utf8_open(filename, O_RDONLY | O_BINARY, HYP_DEFAULT_FILEMODE);

	if (handle < 0)
	{
		hyp_utf8_fprintf(opts->errorfile, "%s: %s: %s\n", gl_program_name, filename, hyp_utf8_strerror(errno));
		return FALSE;
	}

	hyp = hyp_load(filename, handle, &type);
	if (hyp == NULL)
	{
		hyp_utf8_close(handle);
		hyp_utf8_fprintf(opts->errorfile, _("%s: %s: not a HYP file\n"), gl_program_name, filename);
		return FALSE;
	}
	warn_if_empty(hyp, opts);
	
	if ((hyp->st_guide_flags & STG_ENCRYPTED) && !is_MASTER)
	{
		hyp_unref(hyp);
		hyp_utf8_close(handle);
		hyp_utf8_fprintf(opts->errorfile, _("%s: fatal: protected hypertext: %s\n"), gl_program_name, filename);
		return FALSE;
	}
	if ((opts->outfile == NULL || opts->outfile == stdout) && opts->output_filename != NULL)
	{
		if (strcmp(opts->output_filename, HCP_OUTPUT_WILDCARD) == 0)
		{
			output_filename = replace_ext(filename, NULL, defext);
		} else
		{
			output_filename = g_strdup(opts->output_filename);
		}
		opts->outfile = hyp_utf8_fopen(output_filename, "wb");
		if (opts->outfile == NULL)
		{
			hyp_unref(hyp);
			hyp_utf8_close(handle);
			hyp_utf8_fprintf(opts->errorfile, "%s: %s: %s\n", gl_program_name, output_filename, hyp_utf8_strerror(errno));
			g_free(output_filename);
			return FALSE;
		}
		dir = hyp_path_get_dirname(output_filename);
	} else
	{
		dir = NULL;
	}
	if (empty(dir))
	{
		g_free(dir);
		dir = g_strdup(".");
	}
	if (opts->long_filenames < 0)
		opts->long_filenames = check_long_filenames(dir);
	opts->output_dir = dir;
	if (opts->long_filenames)
	{
		g_free(opts->image_name_prefix);
		opts->image_name_prefix = replace_ext(hyp_basename(filename), NULL, "_img_");
	}
	
	if (opts->verbose >= 0 && opts->outfile != stdout)
	{
		hyp_utf8_fprintf(stdout, _("recompiling %s to %s\n"), filename, output_filename);
	}
	
	hcp_opts_copy(&hyp_opts, opts);
	g_free(hyp_opts.output_filename);
	hyp_opts.output_filename = output_filename;
	if (hyp->hcp_options != NULL)
	{
		hcp_opts_parse_string(&hyp_opts, hyp->hcp_options, OPTS_FROM_SOURCE);
	}
	retval = func(hyp, &hyp_opts, argc, argv);
	hyp_opts.outfile = NULL;
	hyp_opts.errorfile = NULL;
	hcp_opts_free(&hyp_opts);
	hyp_unref(hyp);
	hyp_utf8_close(handle);
	if (output_filename)
	{
		hyp_utf8_fclose(opts->outfile);
		opts->outfile = NULL;
	}
	g_freep(&opts->output_dir);
	
	return retval;
}

/*****************************************************************************/
/* ------------------------------------------------------------------------- */
/*****************************************************************************/

static gboolean list_entries(const char *filename, hcp_opts *opts)
{
	HYP_DOCUMENT *hyp;
	char *str;
	hyp_nodenr node;
	INDEX_ENTRY *entry;
	unsigned long compressed_size, size;
	size_t namelen;
	hyp_filetype type = HYP_FT_NONE;
	int handle;
	
	static char const list_format[] = "%-20s %9lu  %6lu %6lu   %s";
	static char const long_list_format[] = "%5u %5u %5u %5u %-20s %9lu  %6lu %6lu   %3u %s";
	
	handle = hyp_utf8_open(filename, O_RDONLY | O_BINARY, HYP_DEFAULT_FILEMODE);

	if (handle < 0)
	{
		hyp_utf8_fprintf(opts->errorfile, "%s: %s: %s\n", gl_program_name, filename, hyp_utf8_strerror(errno));
		return FALSE;
	}

	hyp = hyp_load(filename, handle, &type);

	if (hyp == NULL)
	{
		REF_FILE *ref = ref_load(filename, handle, FALSE);
		gboolean ret;
		
		if (ref != NULL)
		{
			hyp_utf8_close(handle);
			ret = ref_list(ref, opts->outfile, opts->list_flags != 0);
			ref_close(ref);
			return ret;
		}
	}
	
	if (hyp == NULL)
	{
		hyp_utf8_close(handle);
		hyp_utf8_fprintf(opts->errorfile, _("%s: %s: not a HYP file\n"), gl_program_name, filename);
		return FALSE;
	}
	
	warn_if_empty(hyp, opts);
	
	dump_globals(hyp, opts->outfile);
	
	if (opts->list_flags != 0)
	{
		hyp_utf8_fprintf(opts->outfile, "\n");
		if (opts->do_list > 1)
		{
			hyp_utf8_fprintf(opts->outfile, _("    #   toc  next  prev type                    offset  packed   size   len name\n"));
			hyp_utf8_fprintf(opts->outfile, _("--------------------------------------------------------------------------------\n"));
			for (node = 0; node < hyp->num_index; node++)
			{
				entry = hyp->indextable[node];
				compressed_size = GetCompressedSize(hyp, node);
				size = GetDataSize(hyp, node);
				namelen = entry->length - SIZEOF_INDEX_ENTRY;
				switch ((hyp_indextype) entry->type)
				{
				case HYP_NODE_INTERNAL:
					if (opts->list_flags & LIST_NODES)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("internal node"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_POPUP:
					if (opts->list_flags & LIST_PNODES)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("pop-up node"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_EXTERNAL_REF:
					if (opts->list_flags & LIST_XREFS)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("external node"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_IMAGE:
					if (opts->list_flags & LIST_PICS)
					{
						unsigned char *data;
						unsigned char hyp_pic_raw[SIZEOF_HYP_PICTURE];
						HYP_IMAGE image;
						
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("image"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						data = hyp_loaddata(hyp, node);
						if (data != NULL)
						{
							if (GetEntryBytes(hyp, node, data, hyp_pic_raw, SIZEOF_HYP_PICTURE))
							{
								char *colors;
								memset(&image, 0, sizeof(image));
								image.number = node;
								image.data_size = GetDataSize(hyp, node);
								hyp_pic_get_header(&image, hyp_pic_raw, opts->errorfile);
								colors = pic_colornameformat(image.pic.fd_nplanes);
								hyp_utf8_fprintf(opts->outfile, _(" (%ux%u%s mask=$%02x on-off=$%02x%s)"),
									image.pic.fd_w, image.pic.fd_h, colors,
									image.plane_pic, image.plane_on_off,
									image.incomplete ? _(" (incomplete)") : "");
								g_free(colors);
							} else
							{
								hyp_utf8_fprintf(opts->outfile, _(" (decode error)"));
							}
							g_free(data);
						} else
						{
							hyp_utf8_fprintf(opts->outfile, _(" (no data)"));
						}
						g_free(str);
					}
					break;
				case HYP_NODE_SYSTEM_ARGUMENT:
					if (opts->list_flags & LIST_SYSTEM)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("system node"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_REXX_SCRIPT:
					if (opts->list_flags & LIST_RXS)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("REXX script"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_REXX_COMMAND:
					if (opts->list_flags & LIST_RX)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("REXX command"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_QUIT:
					if (opts->list_flags & LIST_QUIT)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("quit node"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_CLOSE:
					if (opts->list_flags & LIST_CLOSE)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("close node"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_EOF:
					if (opts->list_flags & LIST_EOF)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							_("EOF entry"),
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
					}
					break;
				default:
					if (opts->list_flags & LIST_UNKNOWN)
					{
						char *type = g_strdup_printf(_("unknown type %u"), entry->type);
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, long_list_format,
							node, entry->toc_index, entry->next, entry->previous,
							type,
							entry->seek_offset, compressed_size, size, entry->length, printnull(str));
						g_free(str);
						g_free(type);
					}
					break;
				}
				fputs("\n", opts->outfile);
			}
		} else
		{
			hyp_utf8_fprintf(opts->outfile, _("type                    offset  packed   size   name\n"));
			hyp_utf8_fprintf(opts->outfile, _("----------------------------------------------------\n"));
			for (node = 0; node < hyp->num_index; node++)
			{
				entry = hyp->indextable[node];
				compressed_size = GetCompressedSize(hyp, node);
				size = GetDataSize(hyp, node);
				namelen = entry->length - SIZEOF_INDEX_ENTRY;
				switch ((hyp_indextype) entry->type)
				{
				case HYP_NODE_INTERNAL:
					if (opts->list_flags & LIST_NODES)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("internal node"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_POPUP:
					if (opts->list_flags & LIST_PNODES)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("pop-up node"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_EXTERNAL_REF:
					if (opts->list_flags & LIST_XREFS)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("external node"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_IMAGE:
					if (opts->list_flags & LIST_PICS)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("image"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_SYSTEM_ARGUMENT:
					if (opts->list_flags & LIST_SYSTEM)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("system node"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_REXX_SCRIPT:
					if (opts->list_flags & LIST_RXS)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("REXX script"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_REXX_COMMAND:
					if (opts->list_flags & LIST_RX)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("REXX command"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_QUIT:
					if (opts->list_flags & LIST_QUIT)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("quit node"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_CLOSE:
					if (opts->list_flags & LIST_CLOSE)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("close node"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				case HYP_NODE_EOF:
					if (opts->list_flags & LIST_EOF)
					{
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							_("EOF entry"),
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
					}
					break;
				default:
					if (opts->list_flags & LIST_UNKNOWN)
					{
						char *type = g_strdup_printf(_("unknown type %u"), entry->type);
						str = hyp_conv_to_utf8(hyp->comp_charset, entry->name, namelen);
						hyp_utf8_fprintf(opts->outfile, list_format,
							type,
							entry->seek_offset, compressed_size, size, printnull(str));
						g_free(str);
						g_free(type);
					}
					break;
				}
				fputs("\n", opts->outfile);
			}
		}
	}
	
	hyp_utf8_close(handle);
	hyp_unref(hyp);
	return TRUE;
}

/*****************************************************************************/
/* ------------------------------------------------------------------------- */
/*****************************************************************************/

#include "hypmain.h"

int main(int argc, const char **argv)
{
	int c;
	int retval = EXIT_SUCCESS;
	hcp_opts _opts;
	hcp_opts *opts = &_opts;
	int wait_key;
	
	HypProfile_Load(TRUE);
	
	hcp_opts_init(opts);
	opts->tabwidth = gl_profile.viewer.ascii_tab_size;
	if (!hcp_opts_parse_string(opts, gl_profile.hcp.options, OPTS_FROM_CONFIG))
		retval = EXIT_FAILURE;
	if (hcp_opts_parse(opts, argc, argv, OPTS_FROM_COMMANDLINE) == FALSE)
		retval = EXIT_FAILURE;
	opts->all_links = !opts->autoreferences;
	
	if (retval != EXIT_SUCCESS)
	{
	} else if (opts->do_version)
	{
		print_version(stdout);
	} else if (opts->do_help)
	{
		print_usage(stdout);
	} else
	{
		int num_args;
		int num_opts = (opts->do_list > 0) + (opts->recompile_format != HYP_FT_NONE) + (opts->do_compile > 0);
		
		c = opts->optind;
		num_args = argc - c;

		if (retval == EXIT_SUCCESS)
		{
			if (num_opts == 0 && num_args > 0)
			{
				opts->do_compile = TRUE;
			} else if (num_opts == 0 && num_args <= 0)
			{
				/* maybe empty commandline from old Desktop */
#if defined(__TOS__) || defined(__atarist__)
				if (empty(argv[0]))
				{
					if (opts->wait_key == 0)
						opts->wait_key = 1;
				} else
				{
					if (opts->wait_key == 1)
						opts->wait_key = 0;
				}
#endif
				retval = EXIT_FAILURE;
				print_usage(stderr);
			} else if (num_opts > 1)
			{
				hcp_usage_error(_("only one of -lrv may be specified"));
				retval = EXIT_FAILURE;
			}
		}
		
		if (retval == EXIT_SUCCESS && num_args <= 0)
		{
			hcp_usage_error(_("no files specified"));
			retval = EXIT_FAILURE;
		}
		
		if (retval == EXIT_SUCCESS)
		{
			if (opts->do_list)
			{
				/*
				 * maybe TODO: handle -o~ here
				 */
				if (opts->output_charset == HYP_CHARSET_NONE)
					opts->output_charset = hyp_get_current_charset();
				while (c < argc)
				{
					const char *filename = argv[c++];
					if (num_args > 1)
						hyp_utf8_fprintf(opts->outfile, _("File: %s\n"), filename);
					if (!list_entries(filename, opts))
						retval = EXIT_FAILURE;
					else if (c < argc)
						hyp_utf8_fprintf(opts->outfile, "\n\n");
				}
			} else if (opts->recompile_format == HYP_FT_ASCII)
			{
				const char *filename = argv[c++];

				if (opts->output_charset == HYP_CHARSET_NONE)
					opts->output_charset = hyp_get_current_charset();
				/*
				 * args beyond filename are node names to display
				 */
				if (recompile(filename, opts, recompile_ascii, argc - c, &argv[c], HYP_EXT_TXT) == FALSE)
				{
					retval = EXIT_FAILURE;
				}
			} else if (opts->recompile_format == HYP_FT_STG)
			{
				if (opts->output_charset == HYP_CHARSET_NONE)
					opts->output_charset = hyp_get_current_charset();
				while (c < argc)
				{
					const char *filename = argv[c++];
					GString *out;
					force_crlf = (opts->output_filename == NULL || opts->output_charset != HYP_CHARSET_ATARI) ? FALSE : TRUE;
					out = g_string_new(NULL);
					if (num_args > 1)
					{
						hyp_utf8_sprintf_charset(out, opts->output_charset, _("@remark File: %s\n"), filename);
						write_strout(out, opts->outfile);
						g_string_truncate(out, 0);
					}
					if (recompile(filename, opts, recompile_stg, 0, NULL, HYP_EXT_STG) == FALSE)
					{
						retval = EXIT_FAILURE;
						break;
					}
					if (c < argc)
					{
						g_string_append(out, "\n\n");
						write_strout(out, opts->outfile);
						g_string_truncate(out, 0);
					}
					g_string_free(out, TRUE);
				}
			} else if (opts->recompile_format == HYP_FT_HTML || opts->recompile_format == HYP_FT_HTML_XML)
			{
				if (opts->output_charset == HYP_CHARSET_NONE)
					opts->output_charset = hyp_get_current_charset();
				while (c < argc)
				{
					const char *filename = argv[c++];
					GString *out;
					force_crlf = (opts->output_filename == NULL || opts->output_charset != HYP_CHARSET_ATARI) ? FALSE : TRUE;
					out = g_string_new(NULL);
					if (num_args > 1)
					{
						hyp_utf8_sprintf_charset(out, opts->output_charset, _("<!-- File: %s -->\n"), filename);
						write_strout(out, opts->outfile);
						g_string_truncate(out, 0);
					}
					/* if ((opts->outfile == NULL || opts->outfile == stdout) && opts->output_filename == NULL)
						opts->output_filename = replace_ext(filename, NULL, HYP_EXT_HTML); */
					if (recompile(filename, opts, recompile_html, 0, NULL, HYP_EXT_HTML) == FALSE)
					{
						retval = EXIT_FAILURE;
						break;
					}
					if (c < argc)
					{
						g_string_append(out, "\n\n");
						write_strout(out, opts->outfile);
						g_string_truncate(out, 0);
					}
					g_string_free(out, TRUE);
				}
			} else if (opts->recompile_format == HYP_FT_XML)
			{
				/* force utf-8 output for xml */
				opts->output_charset = HYP_CHARSET_UTF8;
				while (c < argc)
				{
					const char *filename = argv[c++];
					GString *out;
					force_crlf = (opts->output_filename == NULL || opts->output_charset != HYP_CHARSET_ATARI) ? FALSE : TRUE;
					out = g_string_new(NULL);
					if (num_args > 1)
					{
						hyp_utf8_sprintf_charset(out, opts->output_charset, _("<!-- File: %s -->\n"), filename);
						write_strout(out, opts->outfile);
						g_string_truncate(out, 0);
					}
					if (recompile(filename, opts, recompile_xml, 0, NULL, HYP_EXT_XML) == FALSE)
					{
						retval = EXIT_FAILURE;
						break;
					}
					if (c < argc)
					{
						g_string_append(out, "\n\n");
						write_strout(out, opts->outfile);
						g_string_truncate(out, 0);
					}
					g_string_free(out, TRUE);
				}
			} else if (opts->recompile_format == HYP_FT_BINARY)
			{
				const char *filename = argv[c++];
				
				if (opts->output_charset == HYP_CHARSET_NONE)
					opts->output_charset = hyp_get_current_charset();
				/*
				 * args beyond filename are node names to display
				 */
				if (recompile(filename, opts, recompile_dump, argc - c, &argv[c], HYP_EXT_TXT) == FALSE)
				{
					retval = EXIT_FAILURE;
				}
			} else if (opts->do_compile)
			{
				if (opts->output_filename && num_args > 1)
				{
					hcp_usage_error(_("cannot compile multiple input files to single output"));
				} else
				{
					while (c < argc)
					{
						const char *filename = argv[c++];
						if (!hcp_compile(filename, opts))
						{
							retval = EXIT_FAILURE;
							break;
						}
					}
				}
			} else
			{
				retval = EXIT_FAILURE;
				unreachable();
			}
		}
	}
	
	wait_key = opts->wait_key;
	hcp_opts_free(opts);
	
	if (wait_key == 2 ||
		(wait_key == 1 && retval != EXIT_SUCCESS))
	{
		fflush(stderr);
#if defined(__TOS__) || defined(__atarist__)
		hyp_utf8_printf(_("<press any key>"));
		fflush(stdout);
		Cnecin();
#else
		hyp_utf8_printf(_("<press RETURN>"));
		fflush(stdout);
		getchar();
#endif
	}
	
	HypProfile_Delete();
	x_free_resources();

	return retval;
}
