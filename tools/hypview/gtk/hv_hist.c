#include "hv_gtk.h"
#include "hypdebug.h"


/* pointer to history data */
HISTORY *history = NULL;

void AddHistoryEntry(WINDOW_DATA *win)
{
	HISTORY *new_entry;
	DOCUMENT *doc = win->data;

	new_entry = g_new0(HISTORY, 1);

	if (new_entry == NULL)
	{
		HYP_DBG(("ERROR: out of memory => can't add new history entry"));
		return;
	}
	new_entry->win = win;
	new_entry->doc = doc;
	new_entry->node = doc->getNodeProc(doc);
	new_entry->line = 0; /* YYY win->docsize.y */
	new_entry->next = history;
	new_entry->title = g_strdup_printf(" %s", win->title);

	/* put new entry at top */
	history = new_entry;
}


gboolean RemoveHistoryEntry(DOCUMENT **doc, hyp_nodenr *node, long *line)
{
	WINDOW_DATA *win = (*doc)->window;
	HISTORY *entry = history;

	if (entry == NULL)
		return FALSE;

	if (entry->win == win)
	{
		history = entry->next;
	} else
	{
		HISTORY *prev = entry;

		entry = entry->next;
		while (entry)
		{
			if (entry->win == win)
			{
				prev->next = entry->next;
				break;
			}
			prev = entry;
			entry = entry->next;
		}
	}

	if (!entry)
		return FALSE;

	*node = entry->node;
	*line = entry->line;
	*doc = entry->doc;

	g_free(entry->title);
	g_free(entry);
	return TRUE;
}


/*
 * remove all entries connected to <win>
 */
void RemoveAllHistoryEntries(WINDOW_DATA *win)
{
	HISTORY *entry = history;
	HISTORY *previous;

	while (entry)
	{
		if (entry->win != win)
			break;
		history = history->next;
		g_free(entry->title);
		g_free(entry);
		entry = history;
	}

	/* no more entries? => done */
	if (!entry)
		return;

	previous = entry;
	entry = previous->next;
	while (entry)
	{
		if (entry->win == win)
		{
			previous->next = entry->next;
			g_free(entry->title);
			g_free(entry);
		} else
		{
			previous = entry;
		}
		
		entry = previous->next;
	}
}


short CountWindowHistoryEntries(WINDOW_DATA *win)
{
	HISTORY *entry = history;
	short num = 0;

	while (entry)
	{
		if (entry->win == win)
			num++;
		entry = entry->next;
	}
	return num;
}


short CountDocumentHistoryEntries(DOCUMENT *doc)
{
	HISTORY *entry = history;
	short num = 0;

	while (entry)
	{
		if (entry->doc == doc)
			num++;
		entry = entry->next;
	}
	return num;
}


void DeleteLastHistory(HISTORY *entry)
{
	HISTORY *previous;

	previous = entry;
	entry = previous->next;
	while (entry != NULL)
	{
		previous->next = entry->next;
		g_free(entry->title);
		g_free(entry);
		entry = previous->next;
	}
}


HISTORY *GetLastHistory(void)
{
	HISTORY *last = NULL;
	HISTORY *entry = history;
	HISTORY *new_entry;

	while (entry)
	{
		new_entry = g_new0(HISTORY, 1);
		if (new_entry == NULL)
		{
			HYP_DBG(("ERROR: out of memory => can't add new (last)history entry"));
			return last;
		}
		new_entry->doc = entry->doc;
		new_entry->node = entry->node;
		new_entry->line = entry->line;
		new_entry->next = last;
		new_entry->title = g_strdup(entry->title);
		last = new_entry;

		entry = entry->next;
	}
	return last;
}


void SetLastHistory(WINDOW_DATA *the_win, HISTORY *last)
{
	HISTORY *entry = last;
	HISTORY *new_entry;

	while (entry)
	{
		new_entry = g_new0(HISTORY, 1);
		if (new_entry == NULL)
		{
			HYP_DBG(("ERROR: out of memory => can't add new history entry"));
			return;
		}
		new_entry->win = the_win;
		new_entry->doc = entry->doc;
		new_entry->node = entry->node;
		new_entry->line = entry->line;
		new_entry->next = history;
		new_entry->title = g_strdup(entry->title);
		/* put new entry at top */
		history = new_entry;

		entry = entry->next;
	}
}
