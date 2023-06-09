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
#include "dragdrop.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

#if USE_DRAGDROP

G_STATIC_ASSERT(sizeof(DD_FNAME) == 20);

/*
 * handles the whole drag&drop protocoll
 */
void DragDrop(_WORD msg[8])
{
	unsigned long format[MAX_DDFORMAT], sformat;
	char pipe[sizeof(DD_FNAME)];
	char name[DD_NAMEMAX];
	char *data = NULL;
	long size;
	void *ret;
	void *old_sig;
	short pipe_handle, i;
	CHAIN_DATA *chain_ptr;
	DIALOG_DATA *dialog = NULL;
	WINDOW_DATA *window = NULL;
	OBJECT *tree;
	GRECT rect;
	short obj = 0;

	strcpy(pipe, DD_FNAME);
	pipe[17] = *(char *) &msg[7];
	pipe[18] = *((char *) &msg[7] + 1);
	pipe_handle = ddopen(pipe, format, &old_sig);

	chain_ptr = find_ptr_by_whandle(msg[3]);

	if (!chain_ptr)
	{
		ddreply(pipe_handle, DD_NAK);
		ddclose(pipe_handle, old_sig);
		return;
	}

	if ((modal_items >= 0) && (modal_stack[modal_items] != chain_ptr->whandle))
	{
		ddreply(pipe_handle, DD_NAK);
		ddclose(pipe_handle, old_sig);
		return;
	}

	switch (chain_ptr->type)
	{
	case WIN_DIALOG:
		dialog = (DIALOG_DATA *) chain_ptr;
		break;
	case WIN_WINDOW:
		window = (WINDOW_DATA *) chain_ptr;
		break;
	}

	if (dialog)
	{
		wdlg_get_tree(dialog->dial, &tree, &rect);
		obj = objc_find(tree, ROOT, MAX_DEPTH, msg[4], msg[5]);
		if (obj < 0)
		{
			ddreply(pipe_handle, DD_NAK);
			ddclose(pipe_handle, old_sig);
			return;
		}
		DD_DialogGetFormat(tree, obj, format);
	} else if (window)
	{
		if (!window->proc(window, WIND_DRAGDROPFORMAT, format))
		{
			ddreply(pipe_handle, DD_NAK);
			ddclose(pipe_handle, old_sig);
			return;
		}
	} else
	{
		ddreply(pipe_handle, DD_NAK);
		ddclose(pipe_handle, old_sig);
		return;
	}

	for (i = 0; i < MAX_DDFORMAT; i++)	/* try all possible formats */
	{
		ddrtry(pipe_handle, name, &sformat, &size);

		if (sformat != format[i])
			ddreply(pipe_handle, DD_EXT);
		else
		{
			ret = g_new(char, size + 1);
			if (ret != 0)
			{
				data = (char *) ret;
				ddreply(pipe_handle, DD_OK);
				Fread(pipe_handle, size, data);
				data[size] = 0;
			} else
			{
				ddreply(pipe_handle, DD_NAK);
			}
			break;
		}
	}
	ddclose(pipe_handle, old_sig);

	if (data != NULL)
	{
		if (dialog)
			DD_Object(dialog->dial, &rect, tree, obj, data, format[i]);
		else if (window)
			window->proc(window, WIND_DRAGDROP, data);

		g_free(data);
	} else
	{
		form_alert(1, rs_string(DI_MEMORY_ERROR));
	}
}
#endif
