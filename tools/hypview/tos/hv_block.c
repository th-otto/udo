/*
 * HypView - (c)      - 2006 Philipp Donze
 *               2006 -      Philipp Donze & Odd Skancke
 *
 * A replacement hypertext viewer
 *
 * This file is part of HypView.
 *
 * HypView is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * HypView is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with HypView; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include "hv_defs.h"
#include "hypdebug.h"
#include "hypview.h"

#define remarker_can_utf8 (0 && win)

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

_WORD StartRemarker(WINDOW_DATA *win, remarker_mode mode, gboolean quiet)
{
	_WORD id = -1;
	
	if (mode == remarker_check)
		return appl_locate(gl_profile.remarker.path, NULL, FALSE);
	if (empty(gl_profile.remarker.path))
	{
		if (!quiet)
			form_alert(1, rs_string(HV_ERR_NO_REMARKER));
	} else
	{
		/* for startup; was "-t", but that causes remarker to use a small font */
		id = appl_locate(gl_profile.remarker.path, mode == remarker_startup ? "" : "", mode != remarker_update);
		if (id >= 0 && (mode == remarker_update || mode == remarker_top) && win)
		{
			const char *argv[4];
			int argc = 0;
			DOCUMENT *doc = win->data;
			char *cmd;
			char *nodename = NULL;
			
			if (id == 0 && !_app && appl_locate(gl_profile.remarker.path, NULL, FALSE) < 0)
			{
				/* it's about to be started by the AV-server */
				return -1;
			}
			if (mode == remarker_top)
				argv[argc++] = "-r";
			argv[argc++] = doc->path;
			if (doc->type == HYP_FT_HYP)
			{
				HYP_DOCUMENT *hyp = (HYP_DOCUMENT *)doc->data;
				if (remarker_can_utf8)
					nodename = hyp_conv_to_utf8(hyp->comp_charset, hyp->indextable[win->displayed_node->number]->name, STR0TERM);
				else
					nodename = hyp_conv_charset(hyp->comp_charset, HYP_CHARSET_ATARI, hyp->indextable[win->displayed_node->number]->name, STR0TERM, NULL);
				argv[argc++] = nodename;
			}
			argv[argc] = NULL;
			cmd = av_cmdline(argv, 0, TRUE);
			SendVA_START(id, cmd, FUNK_NULL);
			g_free(cmd);
			g_free(nodename);
		}
		if (id < 0 && !quiet)
		{
			FileExecError(gl_profile.remarker.path);
		}
	}
	return id;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void BlockOperation(WINDOW_DATA *win, short num)
{
	DOCUMENT *doc = win->data;

	switch (num)
	{
	case CO_SAVE:
		SelectFileSave(win);
		break;
	case CO_BACK:
		GoBack(win);
		break;
	case CO_COPY:
		BlockCopy(win);
		break;
	case CO_PASTE:
		if (doc->buttons.searchbox)
			AutoLocatorPaste(win);
		else
			BlockPaste(win, gl_profile.viewer.clipbrd_new_window);
		break;
	case CO_SELECT_ALL:
		SelectAll(win);
		break;
	case CO_SEARCH:
		Hypfind(win, FALSE);
		break;
	case CO_SEARCH_AGAIN:
		Hypfind(win, TRUE);
		break;
	case CO_DELETE_STACK:
		RemoveAllHistoryEntries(win);
		ToolbarUpdate(win, TRUE);
		break;
	case CO_SWITCH_FONT:
		SwitchFont(win);
		break;
	case CO_SELECT_FONT:
		SelectFont(win);
		break;
	case CO_REMARKER:
		if (StartRemarker(win, remarker_top, FALSE) >= 0)
			ToolbarUpdate(win, TRUE);
		break;
	case CO_PRINT:
		break;
	}
}

/*** ---------------------------------------------------------------------- ***/

void BlockSelectAll(WINDOW_DATA *win, BLOCK *b)
{
	b->start.line = 0;
	b->start.y = 0;
	b->start.offset = 0;
	b->start.x = 0;
	b->end.line = win->docsize.h / win->y_raster;
	b->end.y = win->docsize.h;
	b->end.offset = 0;
	b->end.x = 0;
	b->valid = TRUE;
}

/*** ---------------------------------------------------------------------- ***/

void BlockCopy(WINDOW_DATA *win)
{
	char *scrap_file;
	BLOCK b = win->selection;

	if (!b.valid)
		BlockSelectAll(win, &b);

	/* copy to clipboard */
	graf_mouse(BUSY_BEE, NULL);
	if ((scrap_file = GetScrapPath(TRUE)) == NULL)
	{
		HYP_DBG(("No clipboard defined"));
	} else
	{
		_WORD msg[8] = { SC_CHANGED, 0, 0, 2, 0x2e54 /*'.T' */ , 0x5854 /*'XT' */ , 0, 0 };
		BlockAsciiSave(win, scrap_file);
		msg[1] = gl_apid;
		Protokoll_Broadcast(msg, FALSE);
		g_free(scrap_file);
	}
	graf_mouse(ARROW, NULL);
}

/*** ---------------------------------------------------------------------- ***/

void BlockPaste(WINDOW_DATA *win, gboolean new_window)
{
	char *scrap_file;

	/* "Paste"-action loads SCRAP.TXT from clipboard */
	if ((scrap_file = GetScrapPath(FALSE)) == NULL)
	{
		HYP_DBG(("No clipboard defined"));
	} else
	{
		int ret;

		ret = open(scrap_file, O_RDONLY);
		if (ret >= 0)
		{
			close(ret);
			if (new_window)
				win = NULL;
			OpenFileInWindow(win, scrap_file, NULL, HYP_NOINDEX, FALSE, new_window, FALSE);
		}
		g_free(scrap_file);
	}
}

/*** ---------------------------------------------------------------------- ***/

void BlockAsciiSave(WINDOW_DATA *win, const char *path)
{
	DOCUMENT *doc = win->data;
	int handle;

	if (doc->blockProc == NULL)
	{
		Cconout(7);						/* Bing!!!! */
		return;
	}

	/* path is from fileselector here and already in local encoding */
	handle = open(path, O_WRONLY | O_TRUNC | O_CREAT, HYP_DEFAULT_FILEMODE);
	if (handle < 0)
	{
		FileErrorErrno(path);
	} else
	{
		BLOCK b = win->selection;

		if (!b.valid)					/* no block selected? */
			BlockSelectAll(win, &b);

		doc->blockProc(win, BLK_ASCIISAVE, &b, &handle);
		close(handle);
	}
}

/*** ---------------------------------------------------------------------- ***/

char *GetScrapPath(gboolean clear)
{
	char *ptr;
	char scrap_path[DL_PATHMAX];

	if (!scrp_read(scrap_path))
		return NULL;

	if (clear)							/* empty clipboard? */
	{
		if (!__magix || !scrp_clear())				/* scrp_clear() available? */
		{
			DIR *dir;
			struct dirent *entry;
			
			/* open directory and remove all "SCRAP.*" files */
			dir = opendir(scrap_path);
			if (dir != NULL)
			{
				while ((entry = readdir(dir)) != NULL)
				{
					if (strncasecmp(entry->d_name, "SCRAP.", 6) == 0)
					{
						ptr = g_build_filename(scrap_path, entry->d_name, NULL);
						Fdelete(ptr);
						g_free(ptr);
					}
				}
				closedir(dir);
			}
		}
	}

	return g_build_filename(scrap_path, "SCRAP.TXT", NULL);
}
