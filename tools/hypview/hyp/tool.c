#include "hypdefs.h"
#include "hypdebug.h"



hyp_nodenr find_nr_by_title(HYP_DOCUMENT *hyp, const char *title)
{
	hyp_nodenr i;
	int res;
	
	for (i = 0; i < hyp->num_index; i++)
	{
		if (HYP_NODE_IS_TEXT(hyp->indextable[i]->type))
		{
			char *name = hyp_conv_to_utf8(hyp->comp_charset, hyp->indextable[i]->name, STR0TERM);
			res = g_utf8_strcasecmp(name, title);
			g_free(name);
			if (res == 0)
				return i;
		}
	}
	return HYP_NOINDEX;
}

/* ------------------------------------------------------------------------- */

gboolean hyp_node_find_windowtitle(HYP_NODE *nodeptr)
{
	const unsigned char *src;
	const unsigned char *end;

	src = nodeptr->start;
	end = nodeptr->end;

	while (src < end && *src == HYP_ESC)
	{
		if (src[1] == HYP_ESC_WINDOWTITLE)
		{
			nodeptr->window_title = src + 2;
			return TRUE;
		}
		src = hyp_skip_esc(src);
	}
	return FALSE;
}

/* ------------------------------------------------------------------------- */

/*
 * bad design. why does not every esc sequence just contain a length byte?
 */
const unsigned char *hyp_skip_esc(const unsigned char *pos)
{
	if (*pos != HYP_ESC)				/* no more escapes */
		return pos;

	pos++;								/* skip ESC marker */
	switch (*pos)						/* what code? */
	{
	case HYP_ESC_ESC:					/* ESC character */
		pos++;
		break;
	case HYP_ESC_PIC:					/* image */
		pos += 8;
		break;
	case HYP_ESC_LINE:					/* other gfx */
	case HYP_ESC_BOX:
	case HYP_ESC_RBOX:
		pos += 7;
		break;
	case HYP_ESC_LINK_LINE:				/* link */
	case HYP_ESC_ALINK_LINE:
		pos += 2;
		/* fall through */
	case HYP_ESC_LINK:
	case HYP_ESC_ALINK:
		pos += (pos[3] - HYP_STRLEN_OFFSET + 1) + 3;
		break;
	case HYP_ESC_EXTERNAL_REFS:			/* up to 12 xref entries */
	case HYP_ESC_CASE_DATA:				/* data blocks */
		pos += pos[1] - 1;				/* skip data */
		break;
	case HYP_ESC_WINDOWTITLE:
		pos += ustrlen(pos) + 1;		/* @title, skip data */
		break;
	case HYP_ESC_OBJTABLE:				/* @tree */
		pos += 9;						/* skip data */
		break;
	case HYP_ESC_CASE_TEXTATTR:			/* @{UBISGO} attribute */
		pos++;
		break;
	default:
		HYP_DBG(("unknown Tag: %u,", *pos));
		break;
	}
	return pos;
}

/* ------------------------------------------------------------------------- */

int __my_assert(const char *expr, const char *file, int line)
{
	fflush(stdout);
	fprintf(stderr, "\nassertion failed: file %s, line %d:\n%s\n", file, line, expr);
	fflush(stderr);
	abort();
	return 1;
}
