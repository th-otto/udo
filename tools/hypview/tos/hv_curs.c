#include "hv_defs.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static char *pagename(HYP_DOCUMENT *hyp, hyp_nodenr node)
{
	INDEX_ENTRY *entry;
	size_t namelen;

	entry = hyp->indextable[node];
	namelen = entry->length - SIZEOF_INDEX_ENTRY;
	return hyp_conv_charset(hyp->comp_charset, hyp_get_current_charset(), entry->name, namelen, NULL);
}

/*** ---------------------------------------------------------------------- ***/

static char *invalid_page(hyp_nodenr page)
{
	return g_strdup_printf(_("<invalid destination page %u>"), page);
}

/*** ---------------------------------------------------------------------- ***/

void HypGetCursorPosition(DOCUMENT *doc, int x, int y, TEXT_POS *pos)
{
	WINDOW_DATA *win = doc->window;
	HYP_NODE *node;
	LINEPTR *line_ptr;
	short line = 0;
	long i;
	long sy;
	short curr_txt_effect = 0;
	short x_pos = win->x_raster;
	short width = 0;
	_WORD ext[8];
	const unsigned char *src;
	const unsigned char *end;
	const unsigned char *textstart;
	HYP_DOCUMENT *hyp;
	char *temp;
	
	if (doc->type != HYP_FT_HYP)
	{
		return;
	}

	hyp = doc->data;
	node = doc->displayed_node;

	sy = -(win->docsize.y * win->y_raster);
	line_ptr = node->line_ptr;

	while (line < node->lines)
	{
		long y2;

		y2 = sy + line_ptr->y + line_ptr->h;
		if ((sy + line_ptr->y) >= y || (y2 > y))
		{
			sy += line_ptr->y;
			break;
		}
		sy = y2;
		line_ptr++;
		line++;
	}

	if (line >= node->lines)
		return;

	src = line_ptr->txt;

	if (x < win->x_raster || !src)
	{
		pos->line = line;
		pos->y = sy + (win->docsize.y * win->y_raster);
		pos->offset = 0;
		pos->x = 0;
		return;
	}

	/* reset text effects */
	vst_effects(vdi_handle, 0);
	textstart = src;
	end = line_ptr[1].txt;
	temp = g_strdup("");
	
	while (src < end && *src)
	{
		if (*src == HYP_ESC)					/* ESC-sequence ?? */
		{
			/* unwritten data? */
			if (src > textstart)
			{
				_UWORD len = (_UWORD)(src - textstart);
				char *s = hyp_conv_charset(hyp->comp_os, hyp_get_current_charset(), textstart, len, NULL);
				char *newt;
				
				/* output remaining data */
				vqt_extent(vdi_handle, s, ext);
				newt = g_strconcat(temp, s, NULL);
				g_free(temp);
				temp = newt;
				g_free(s);
				width = (ext[2] + ext[4]) >> 1;
				if (x_pos + width >= x)
					goto go_back;

				x_pos += width;
			}
			src++;

			switch (*src)
			{
			case HYP_ESC_ESC:					/* ESC */
				textstart = src;
				src++;
				break;
			case HYP_ESC_LINK:
			case HYP_ESC_LINK_LINE:
			case HYP_ESC_ALINK:
			case HYP_ESC_ALINK_LINE:
				{
					hyp_nodenr dest_page;	/* index of target page */
					char *str;
					char *newt;
					_UWORD len;
					
					if (*src == HYP_ESC_LINK_LINE || *src == HYP_ESC_ALINK_LINE)		/* skip line number */
						src += 2;

					dest_page = DEC_255(&src[1]);
					src += 3;

					/* calculate width of link text honoring text effects */
					vst_color(vdi_handle, gl_profile.viewer.link_color);
					vst_effects(vdi_handle, gl_profile.viewer.link_effect | curr_txt_effect);

					/* get link text */
					if (*src <= HYP_STRLEN_OFFSET)		/* Kein Text angegeben */
					{
						if (hypnode_valid(hyp, dest_page))
						{
							str = pagename(hyp, dest_page);
						} else
						{
							str = invalid_page(dest_page);
						}
						src++;
					} else
					{
						len = *src - HYP_STRLEN_OFFSET;

						src++;
						str = hyp_conv_charset(hyp->comp_charset, hyp_get_current_charset(), src, len, NULL);
						src += len;
					}

					newt = g_strconcat(temp, str, NULL);
					g_free(temp);
					temp = newt;
					vqt_extent(vdi_handle, str, ext);
					g_free(str);
					width = (ext[2] + ext[4]) >> 1;
					if (x_pos + width >= x)
						goto go_back;

					x_pos += width;

					vst_color(vdi_handle, gl_profile.viewer.text_color);
					vst_effects(vdi_handle, curr_txt_effect);
					textstart = src;
				}
				break;
			
			case HYP_ESC_CASE_TEXTATTR:
				curr_txt_effect = *src - HYP_ESC_TEXTATTR_FIRST;
				vst_effects(vdi_handle, curr_txt_effect);
				src++;
				textstart = src;
				break;
			
			default:
				src = hyp_skip_esc(src - 1);
				textstart = src;
				break;
			}
		} else
		{
			src++;
		}
	}

	if (src > textstart)
	{
		_UWORD len = (_UWORD)(src - textstart);
		char *s = hyp_conv_charset(hyp->comp_os, hyp_get_current_charset(), textstart, len, NULL);
		char *newt;
		
		vqt_extent(vdi_handle, s, ext);
		newt = g_strconcat(temp, s, NULL);
		g_free(temp);
		temp = newt;
		g_free(s);
		width = (ext[2] + ext[4]) >> 1;
		if (x_pos + width >= x)
			goto go_back;
		x_pos += width;
	}
	width = 0;

  go_back:
	i = strlen(temp);
	if (*temp && x_pos + width > x)
	{
		char *dst = temp;
		while (*dst)
			dst++;
		dst--;

		while (dst >= temp)
		{
			i--;
			*dst = 0;
			vqt_extent(vdi_handle, (const char *)temp, ext);
			if (x_pos + ext[2] < x)
			{
				if (x - (x_pos + ext[2]) > (x_pos + width) - x)
				{
					i++;
					break;
				}
				width = (ext[2] + ext[4]) >> 1;
				break;
			}
			width = (ext[2] + ext[4]) >> 1;
			dst--;
		}

		if (dst >= temp)
			pos->x = x_pos + width;
		else
			pos->x = x_pos;
	} else
	{
		pos->x = x_pos + width;
	}
	
	if (i == 0)
		pos->x = 0;
	pos->offset = i;
	pos->line = line;
	pos->y = sy + (win->docsize.y * win->y_raster);
	g_free(temp);
}
