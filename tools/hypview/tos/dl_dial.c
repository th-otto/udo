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
#include "hypview.h"


#define setmsg(a,d,e,f,g,h) \
	msg[0] = a; \
	msg[1] = gl_apid; \
	msg[2] = 0; \
	msg[3] = d; \
	msg[4] = e; \
	msg[5] = f; \
	msg[6] = g; \
	msg[7] = h

static GRECT const small = { 0, 0, 0, 0 };

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static DIALOG_DATA *find_dialog_by_obj(OBJECT *tree)
{
	DIALOG_DATA *ptr = (DIALOG_DATA *) all_list;

	while (ptr)
	{
		if (ptr->type == WIN_DIALOG && ptr->obj == tree)
		{
			return ptr;
		}
		ptr = ptr->next;
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

#if 0
static DIALOG_DATA *find_dialog_by_whandle(short handle)
{
	DIALOG_DATA *ptr = (DIALOG_DATA *) all_list;

	while (ptr)
	{
		if ((ptr->type == WIN_DIALOG) && (ptr->whandle == handle) && (ptr->status & WIS_OPEN))
		{
			return ptr;
		}
		ptr = ptr->next;
	}
	return NULL;
}
#endif

/*** ---------------------------------------------------------------------- ***/

DIALOG *OpenDialog(HNDL_OBJ proc, OBJECT *tree, const char *title, short x, short y, void *data)
{
	DIALOG_DATA *ptr;

	ptr = find_dialog_by_obj(tree);

	if (ptr)
	{
		_WORD msg[8];
		
		if (ptr->status & WIS_OPEN)
		{
			SendTopped(ptr->whandle);
		}
		if (ptr->status & WIS_ICONIFY)
		{
			setmsg(WM_UNICONIFY, ptr->whandle, 0, 0, 0, 0);
			wind_get_grect(msg[3], WF_UNICONIFY, (GRECT *) & msg[4]);
			appl_write(gl_apid, 16, msg);
		}
		if ((ptr->status & WIS_ALLICONIFY) && !(ptr->status & WIS_OPEN))
		{
			GRECT small;
			short i, copy = FALSE;

			wind_get_grect(iconified_list[0]->whandle, WF_CURRXYWH, &small);

			graf_growbox_grect(&small, &ptr->last);
			wind_open_grect(ptr->whandle, &ptr->last);
			ptr->status &= ~WIS_ALLICONIFY;
			ptr->status |= WIS_OPEN;
			for (i = 0; i < iconified_count; i++)
			{
				if (copy)
					iconified_list[i - 1] = iconified_list[i];
				if ((DIALOG_DATA *) iconified_list[i] == ptr)
					copy = TRUE;
			}
			iconified_count--;
		}
		if (!(ptr->status & WIS_OPEN) && !(ptr->status & (WIS_ICONIFY | WIS_ALLICONIFY)))
		{
			short whandle;
			GRECT big;
			
			if ((ptr->last.g_x == -1) && (ptr->last.g_y == -1))
			{
				form_center_grect(ptr->obj, &big);
			} else
			{
				big.g_x = ptr->last.g_x;
				big.g_y = ptr->last.g_y;
				big.g_w = ptr->obj->ob_width;
				big.g_h = ptr->obj->ob_height;
			}

			ptr->title = title;

			graf_growbox_grect(&small, &big);
			whandle = wdlg_open(ptr->dial, ptr->title, CLOSER | MOVER | SMALLER, ptr->last.g_x, ptr->last.g_y, 0, NULL);
			if (whandle)
			{
				ptr->whandle = whandle;
				ptr->status |= WIS_OPEN;
			}
		}
	} else
	{
		short whandle;

		ptr = g_new0(DIALOG_DATA, 1);
		if (ptr == NULL)
		{
			form_alert(1, rs_string(DI_MEMORY_ERROR));
			return (NULL);
		}
		ptr->data = data;
		ptr->obj = tree;
		
		ptr->dial = wdlg_create(proc, tree, ptr, 0, ptr, WDLG_BKGD);
		if (ptr->dial != NULL)
		{
			short kind = CLOSER | MOVER | NAME | SMALLER;
			GRECT big;

			if (!has_iconify())
				kind &= ~SMALLER;

			form_center_grect(tree, &big);

			if ((x != -1) || (y != -1))
			{
				GRECT screen, wout;

				wind_get_grect(0, WF_WORKXYWH, &screen);

				big.g_x = x;
				big.g_y = y;
				wind_calc_grect(WC_BORDER, kind, &big, &wout);

				wout.g_x = max(wout.g_x, screen.g_x);
				wout.g_x = min(wout.g_x, (screen.g_x + screen.g_w) - wout.g_w);

				wout.g_y = max(wout.g_y, screen.g_y);
				wout.g_y = min(wout.g_y, (screen.g_y + screen.g_h) - wout.g_h);

				wind_calc_grect(WC_WORK, kind, &wout, &big);
			}

			graf_growbox_grect(&small, &big);
			whandle = wdlg_open(ptr->dial, title, kind, big.g_x, big.g_y, 0, NULL);
			if (whandle)
			{
				ptr->type = WIN_DIALOG;
				ptr->whandle = whandle;
				ptr->obj = tree;
				ptr->title = title;
				ptr->status = WIS_OPEN;
				ptr->owner = gl_apid;
				add_item((CHAIN_DATA *) ptr);
			} else
			{
				wdlg_delete(ptr->dial);
				ptr->dial = NULL;
			}
		}
		if (ptr->dial == NULL)
		{
			g_free(ptr);
			return NULL;
		}
	}
	return ptr->dial;
}

/*** ---------------------------------------------------------------------- ***/

void SendCloseDialog(DIALOG *dial)
{
	SendClose(wdlg_get_handle(dial));
}

/*** ---------------------------------------------------------------------- ***/

void CloseDialog(DIALOG_DATA *ptr)
{
	GRECT big;
	OBJECT *tree;

	if (ptr->status & WIS_ICONIFY)
	{
		EVNT event;

		memset(&event, 0, sizeof(event));
		event.mwhich = MU_MESAG;
		event.msg[0] = WM_UNICONIFY;
		event.msg[1] = gl_apid;
		event.msg[2] = 0;
		event.msg[3] = ptr->whandle;
		wind_get_grect(ptr->whandle, WF_UNICONIFY, (GRECT *) & event.msg[4]);
		DoEventDispatch(&event);
	}
	if (ptr->status & WIS_ALLICONIFY)
	{
		GRECT sm;
		short i;
		short copy = FALSE;

		wind_get_grect(iconified_list[0]->whandle, WF_CURRXYWH, &sm);

		graf_growbox_grect(&sm, &ptr->last);
		wind_open_grect(ptr->whandle, &ptr->last);
		ptr->status &= ~WIS_ALLICONIFY;
		ptr->status |= WIS_OPEN;
		for (i = 0; i < iconified_count; i++)
		{
			if (copy)
				iconified_list[i - 1] = iconified_list[i];
			if (((DIALOG_DATA *) iconified_list[i]) == ptr)
				copy = TRUE;
		}
		iconified_count--;
	}
	if (ptr->status & WIS_OPEN)
	{
		if (ptr->whandle > 0)
		{
			wdlg_get_tree(ptr->dial, &tree, &big);
			wdlg_close(ptr->dial, &ptr->last.g_x, &ptr->last.g_y);
			graf_shrinkbox_grect(&small, &big);
		}
		ptr->status &= ~WIS_OPEN;
		ptr->whandle = -1;
	}
	if (modal_items >= 0)
		modal_items--;
}

/*** ---------------------------------------------------------------------- ***/

void CloseAllDialogs(void)
{
	DIALOG_DATA *ptr = (DIALOG_DATA *) all_list;

	while (ptr)
	{
		if (ptr->type == WIN_DIALOG)
			CloseDialog(ptr);
		ptr = ptr->next;
	}
}

/*** ---------------------------------------------------------------------- ***/

void RemoveDialog(DIALOG_DATA *ptr)
{
	if (ptr == NULL || ptr->dial == NULL)
		return;
	
	CloseDialog(ptr);
	wdlg_delete(ptr->dial);
	remove_item((CHAIN_DATA *) ptr);
	g_free(ptr);
}

/*** ---------------------------------------------------------------------- ***/

static void dialog_iconify(DIALOG *dialog, GRECT *r)
{
	DIALOG_DATA *ptr;
	GRECT big;

	ptr = (DIALOG_DATA *)wdlg_get_udata(dialog);
	if (ptr->status & WIS_ICONIFY)
		return;

	wind_get_grect(ptr->whandle, WF_CURRXYWH, &big);
	dialog_set_iconify(ptr->dial, r);
	wind_get_grect(ptr->whandle, WF_CURRXYWH, r);
	graf_shrinkbox_grect(r, &big);
	ptr->status |= WIS_ICONIFY;
	CycleItems();
}

/*** ---------------------------------------------------------------------- ***/

static void dialog_uniconify(DIALOG *dialog, GRECT *r)
{
	DIALOG_DATA *ptr;
	GRECT small;

	ptr = (DIALOG_DATA *)wdlg_get_udata(dialog);
	if (!(ptr->status & WIS_ICONIFY))
		return;

	wind_get_grect(ptr->whandle, WF_CURRXYWH, &small);

	if ((CHAIN_DATA *) ptr == iconified_list[0])
	{
		CHAIN_DATA *ptr2;

		while (--iconified_count > 0)
		{
			ptr2 = iconified_list[iconified_count];
			graf_growbox_grect(&small, &ptr2->last);
			wind_open_grect(ptr2->whandle, &ptr2->last);
			ptr2->status &= ~WIS_ALLICONIFY;
			ptr2->status |= WIS_OPEN;
		};
		iconified_list[0] = NULL;
		iconified_count = 0;
		ptr->status &= ~WIS_ALLICONIFY;
	}

	graf_growbox_grect(&small, r);
	wind_set_top(ptr->whandle);
	wdlg_set_uniconify(ptr->dial, r, ptr->title, ptr->obj);
	ptr->status &= ~WIS_ICONIFY;
}

/*** ---------------------------------------------------------------------- ***/

void SpecialMessageEvents(DIALOG *dialog, EVNT *event)
{
	switch (event->msg[0])
	{
	case WM_ALLICONIFY:
		AllIconify(event->msg[3], (GRECT *) & event->msg[4]);
		break;
	case WM_ICONIFY:
		dialog_iconify(dialog, (GRECT *) & event->msg[4]);
		break;
	case WM_UNICONIFY:
		dialog_uniconify(dialog, (GRECT *) & event->msg[4]);
		break;
	}
}

/*** ---------------------------------------------------------------------- ***/

void DialogEvents(DIALOG_DATA *ptr, EVNT *event)
{
	if ((event->msg[0] == WM_REDRAW) && (ptr->status & WIS_ICONIFY))
		wind_get_grect(event->msg[3], WF_WORKXYWH, (GRECT *) & iconified_tree->ob_x);

	if (wdlg_evnt(ptr->dial, event) == 0)
		RemoveDialog(ptr);
}
