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

static DIALOG *Hypfind_Dialog;
static short HypfindID = -1;
static gboolean can_search_again;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void hypfind_search_allref(WINDOW_DATA *win, OBJECT *tree)
{
	char *name;

	name = hyp_conv_to_utf8(hyp_get_current_charset(), tree[HYPFIND_STRING].ob_spec.tedinfo->te_ptext, STR0TERM);
	if (!empty(name))
		search_allref(win, name, FALSE);
	g_free(name);
}

/*** ---------------------------------------------------------------------- ***/

static void av_hypfind_finish(_WORD ret)
{
	if (ret < 0)
	{
		FileExecError(gl_profile.general.hypfind_path);
	} else
	{
		HypfindFinish(-1, ret);
	}
}

/*** ---------------------------------------------------------------------- ***/

static void hypfind_run_hypfind(OBJECT *tree, DOCUMENT *doc, gboolean all_hyp)
{
	const char *argv[8];
	char *filename;
	int argc = 0;
	
	filename = path_subst(gl_profile.general.hypfind_path);
	if (!empty(filename))
	{
		char *name;
#if 0
		const char *tosrun = getenv("TOSRUN");
		
		if (tosrun)
			argv[argc++] = tosrun;
#endif
		argv[argc++] = filename;
		argv[argc++] = "-p";
		
		name = tree[HYPFIND_STRING].ob_spec.tedinfo->te_ptext;
		if (!empty(name))
		{
			int name_argc = argc;
			
			argv[argc++] = name;
			if (gl_profile.viewer.find_casesensitive)
				argv[argc++] = "-I";
			if (gl_profile.viewer.find_word)
				argv[argc++] = "-w";
			if (!all_hyp)
			{
				argv[argc++] = doc->path;
			}
			argv[argc] = NULL;
			if (_AESnumapps != 1)
			{
				int ret;
				
				name = hyp_conv_to_utf8(hyp_get_current_charset(), name, STR0TERM);
				argv[name_argc] = name;
				ret = hyp_utf8_spawnvp(P_WAIT, argc, argv);
				g_free(name);
				av_hypfind_finish(ret);
			} else if (!_app)
			{
				/*
				 * running as accessory on SingleTOS;
				 * This will only work if the main application
				 * is really the AV-Server
				 */
				char *cmd = av_cmdline(argv, 1, FALSE);
				if (SendAV_STARTPROG(filename, cmd, av_hypfind_finish) < 0)
					av_hypfind_finish(-1);
				g_free(cmd);
			} else
			{
				/*
				 * running as application on SingleTOS
				 */
				int ret;
				GRECT desk;
				
				name = hyp_conv_to_utf8(hyp_get_current_charset(), name, STR0TERM);
				argv[name_argc] = name;
				ret = hyp_utf8_spawnvp(P_WAIT, argc, argv);
				g_free(name);
				wind_get_grect(0, WF_CURRXYWH, &desk);
				form_dial_grect(FMD_FINISH, &desk, &desk);
				av_hypfind_finish(ret);
			}
		}
	}
	g_free(filename);
}

/*** ---------------------------------------------------------------------- ***/

static void hypfind_page(WINDOW_DATA *win, OBJECT *tree)
{
	DOCUMENT *doc = win->data;
	char *name = hyp_conv_to_utf8(hyp_get_current_charset(), tree[HYPFIND_STRING].ob_spec.tedinfo->te_ptext, STR0TERM);
	/*
	 * FIXME: ST-Guide search for all pages here where the string is part of the name
	 */
	if (!empty(name))
		OpenFileInWindow(win, doc->path, name, HYP_NOINDEX, FALSE, FALSE, FALSE);
	g_free(name);
}

/*** ---------------------------------------------------------------------- ***/

static void hypfind_text(WINDOW_DATA *win, OBJECT *tree)
{
	DOCUMENT *doc = win->data;
	long line = hv_win_topline(win);
	char *search = hyp_conv_to_utf8(hyp_get_current_charset(), tree[HYPFIND_STRING].ob_spec.tedinfo->te_ptext, STR0TERM);
	
	if (!empty(search))
	{
		doc->autolocator_dir = 1;
		if (!empty(search))
		{
			graf_mouse(BUSY_BEE, NULL);
			line = doc->autolocProc(win, line, search, gl_profile.viewer.find_casesensitive, gl_profile.viewer.find_word);
			graf_mouse(ARROW, NULL);
		}
		if (line >= 0)
		{
			if (line != win->docsize.y / win->y_raster)
			{
				can_search_again = TRUE;
				win->docsize.y = line * win->y_raster;
				SendRedraw(win);
				SetWindowSlider(win);
			}
		} else
		{
			Cconout(7);
		}
	}
	g_free(search);
}

/*** ---------------------------------------------------------------------- ***/

static _WORD __CDECL HypfindHandle(struct HNDL_OBJ_args args)
{
	OBJECT *tree;
	DIALOG_DATA *dial;
	WINDOW_DATA *win;
	DOCUMENT *doc;
	GRECT r;
	
	dial = (DIALOG_DATA *)wdlg_get_udata(args.dialog);
	win = (WINDOW_DATA *)dial->data;
	doc = win->data;
	wdlg_get_tree(args.dialog, &tree, &r);

	if (args.obj > 0)
		tree[args.obj].ob_state &= ~OS_SELECTED;

	can_search_again = FALSE;
	gl_profile.viewer.find_casesensitive = (tree[HYPFIND_CASE].ob_state & OS_SELECTED) != 0;
	gl_profile.viewer.find_word = (tree[HYPFIND_WORD].ob_state & OS_SELECTED) != 0;
	
	switch (args.obj)
	{
	case HNDL_CLSD:
		return 0;
	case HNDL_MESG:
		SpecialMessageEvents(args.dialog, args.events);
		break;
	case HYPFIND_TEXT:
		hypfind_text(win, tree);
		return 0;
	case HYPFIND_PAGES:
		hypfind_page(win, tree);
		return 0;
	case HYPFIND_ABORT:
		return 0;
	case HYPFIND_REF:
		hypfind_search_allref(win, tree);
		return 0;
	case HYPFIND_ALL_PAGE:
		hypfind_run_hypfind(tree, doc, FALSE);
		return 0;
	case HYPFIND_ALL_HYP:
		hypfind_run_hypfind(tree, doc, TRUE);
		return 0;
	}

	return 1;
}

/*** ---------------------------------------------------------------------- ***/

void Hypfind(WINDOW_DATA *win, gboolean again)
{
	DOCUMENT *doc = win->data;
	OBJECT *tree = rs_tree(HYPFIND);
	
	if (HypfindID != -1)
		return;

	if (again && can_search_again)
	{
		hypfind_text(win, tree);
		return;
	}

#if 0
	if (_AESnumapps == 1 && _app)
	{
		tree[HYPFIND_ALL_PAGE].ob_state |= OS_DISABLED;
		tree[HYPFIND_ALL_HYP].ob_state |= OS_DISABLED;
	}
#endif
	if (gl_profile.viewer.find_casesensitive)
		tree[HYPFIND_CASE].ob_state |= OS_SELECTED;
	else
		tree[HYPFIND_CASE].ob_state &= ~OS_SELECTED;
	if (gl_profile.viewer.find_word)
		tree[HYPFIND_WORD].ob_state |= OS_SELECTED;
	else
		tree[HYPFIND_WORD].ob_state &= ~OS_SELECTED;
	
	if (has_window_dialogs())
	{
		Hypfind_Dialog = OpenDialog(HypfindHandle, tree, rs_string(WDLG_SEARCH_PATTERN), -1, -1, win);
	} else
	{
		short obj;
		GRECT big, little;

		little.g_x = little.g_y = little.g_w = little.g_h = 0;
		form_center_grect(tree, &big);
		form_dial_grect(FMD_START, &little, &big);
		objc_draw_grect(tree, ROOT, MAX_DEPTH, &big);
		obj = form_do(tree, HYPFIND_STRING);
		if (obj > 0)
			tree[obj].ob_state &= ~OS_SELECTED;
		form_dial_grect(FMD_FINISH, &little, &big);

		can_search_again = FALSE;
		gl_profile.viewer.find_casesensitive = (tree[HYPFIND_CASE].ob_state & OS_SELECTED) != 0;
		gl_profile.viewer.find_word = (tree[HYPFIND_WORD].ob_state & OS_SELECTED) != 0;
		switch (obj)
		{
		case HYPFIND_ABORT:
			break;
		case HYPFIND_REF:
			hypfind_search_allref(win, tree);
			break;
		case HYPFIND_TEXT:
			hypfind_text(win, tree);
			break;
		case HYPFIND_PAGES:
			hypfind_page(win, tree);
			break;
		case HYPFIND_ALL_PAGE:
			hypfind_run_hypfind(tree, doc, FALSE);
			break;
		case HYPFIND_ALL_HYP:
			hypfind_run_hypfind(tree, doc, TRUE);
			break;
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

void HypfindFinish(short AppID, short ret)
{
	if (AppID == HypfindID)
	{
		HypfindID = -1;
		/* FIXME: at least XaAES seems to always send 223 as return code */
		if (ret != 0)
		{
			char *str = g_strdup_printf(rs_string(HV_ERR_HYPFIND), ret);
			form_alert(1, str);
			g_free(str);
		} else
		{
			OpenFileInWindow(NULL, HYP_FILENAME_HYPFIND, NULL, HYP_NOINDEX, FALSE, TRUE, FALSE);
		}
	}
}
