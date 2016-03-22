#include "chmtools.h"
#include "chmtypes.h"
#include "htmlutil.h"
#include "chmxml.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

int PageBookInfoRecordSize(PTOCEntryPageBookInfo ARecord)
{
	if (TOC_ENTRY_HAS_CHILDREN & ARecord->Props)
		return 28;
	return 20;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void DirectoryChunk_put_le16(DirectoryChunk *dir, unsigned int pos, uint16_t value)
{
	dir->Buffer[pos + 0] = (uint8_t)value;
	dir->Buffer[pos + 1] = (uint8_t)(value >> 8);
}

/*** ---------------------------------------------------------------------- ***/

gboolean DirectoryChunk_CanHold(DirectoryChunk *dir, unsigned int ASize)
{
	return dir->CurrentPos < DIR_BLOCK_SIZE - ASize - (sizeof(uint16_t) * (dir->QuickRefEntries + 2));
}

/*** ---------------------------------------------------------------------- ***/

unsigned int DirectoryChunk_FreeSpace(DirectoryChunk *dir)
{
	return DIR_BLOCK_SIZE - dir->CurrentPos;
}

/*** ---------------------------------------------------------------------- ***/

void DirectoryChunk_WriteHeader(DirectoryChunk *dir, void *AHeader)
{
	memcpy(dir->Buffer, AHeader, dir->HeaderSize);
}

/*** ---------------------------------------------------------------------- ***/

gboolean DirectoryChunk_WriteEntry(DirectoryChunk *dir, unsigned int Size, void *Data)
{
	unsigned int ReversePos;
	uint16_t Value;
	
	if (!DirectoryChunk_CanHold(dir, Size))
	{
		fprintf(stderr, "Trying to write past the end of the buffer\n");
		return FALSE;
	}
	memcpy(&dir->Buffer[dir->CurrentPos], Data, Size);
	dir->CurrentPos += Size;
	++dir->ItemCount;

	/* now put a quickref entry if needed */
	if ((dir->ItemCount % 5) == 0)
	{
		++dir->QuickRefEntries;
		ReversePos = DIR_BLOCK_SIZE - sizeof(uint16_t) - (sizeof(uint16_t) * dir->QuickRefEntries);
		Value = (uint16_t)(dir->CurrentPos - Size - dir->HeaderSize);
		DirectoryChunk_put_le16(dir, ReversePos, Value);
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean DirectoryChunk_WriteChunkToStream(DirectoryChunk *dir, ChmStream *Stream)
{
	unsigned int ReversePos;
	uint16_t TmpItemCount;
	
	ReversePos = DIR_BLOCK_SIZE - sizeof(uint16_t);
	TmpItemCount = (uint16_t)dir->ItemCount;
	DirectoryChunk_put_le16(dir, ReversePos, TmpItemCount);

	if (!ChmStream_Write(Stream, dir->Buffer, DIR_BLOCK_SIZE))
		return FALSE;
	CHM_DEBUG_LOG(2, "Writing %c%c%c%c ChunkToStream\n", dir->Buffer[0], dir->Buffer[1], dir->Buffer[2], dir->Buffer[3]);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

void DirectoryChunk_Clear(DirectoryChunk *dir)
{
	memset(dir->Buffer, 0, DIR_BLOCK_SIZE);
	dir->ItemCount = 0;
	dir->CurrentPos = dir->HeaderSize;
	dir->QuickRefEntries = 0;
	++dir->ClearCount;
}

/*** ---------------------------------------------------------------------- ***/

DirectoryChunk *DirectoryChunk_Create(unsigned int AHeaderSize)
{
	DirectoryChunk *dir;
	
	dir = g_new0(DirectoryChunk, 1);
	if (dir == NULL)
		return NULL;
	dir->HeaderSize = AHeaderSize;
	dir->CurrentPos = dir->HeaderSize;
	return dir;
}

/*** ---------------------------------------------------------------------- ***/

void DirectoryChunk_Destroy(DirectoryChunk *dir)
{
	if (dir)
	{
		g_free(dir);
	}
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

FileEntryRec *FileEntryList_GetFileEntry(FileEntryList *list, int Index)
{
	GSList *l;
	
	for (l = list->items; l; l = l->next)
	{
		if (Index == 0)
			return (FileEntryRec *)l->data;
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

static int path_indexof(GSList *list, const char *path)
{
	GSList *l;
	int index;
	
	for (l = list, index = 0; l != NULL; l = l->next, index++)
		if (strcmp((const char *)l->data, path) == 0)
			return index;
	return -1;
}

/*** ---------------------------------------------------------------------- ***/

void FileEntryList_AddEntry(FileEntryList *list, FileEntryRec *AFileEntry, gboolean CheckPathIsAdded /* = TRUE */)
{
	FileEntryRec *TmpEntry;
	char *path;
	
	TmpEntry = g_new(FileEntryRec, 1);
	if (CheckPathIsAdded && path_indexof(list->Paths, AFileEntry->Path) < 0)
	{
		/* all paths are included in the list of files in section 0 with a size and offset of 0 */
		path = g_strdup(AFileEntry->Path);
		list->Paths = g_slist_append(list->Paths, path);
		TmpEntry->Path = path;
		TmpEntry->Name = NULL;
		TmpEntry->DecompressedOffset = 0;
		TmpEntry->DecompressedSize = 0;
		TmpEntry->Compressed = FALSE;
		list->items = g_slist_append(list->items, TmpEntry);
		TmpEntry = g_new(FileEntryRec, 1);
	}
	*TmpEntry = *AFileEntry;
	list->items = g_slist_append(list->items, TmpEntry);
}

/*** ---------------------------------------------------------------------- ***/

static void FileEntryRec_free(void *_rec)
{
	FileEntryRec *rec = (FileEntryRec *)_rec;
	g_free(rec);
}

void FileEntryList_Delete(FileEntryList *list, int Index)
{
	FileEntryRec *rec = FileEntryList_GetFileEntry(list, Index);
	if (rec == NULL)
		return;
	list->items = g_slist_remove(list->items, rec);
	FileEntryRec_free(rec);
}

/*** ---------------------------------------------------------------------- ***/

static int FileEntrySortFunc(const void * _item1, const void * _item2)
{
	const FileEntryRec *item1 = *((const FileEntryRec *const *)_item1);
	const FileEntryRec *item2 = *((const FileEntryRec *const *)_item2);
	char *str1 = g_strconcat(item1->Path, item1->Name, NULL);
	char *str2 = g_strconcat(item2->Path, item2->Name, NULL);
	int result = ChmCompareText(str1, str2);
	g_free(str2);
	g_free(str1);
	return result;
}

void FileEntryList_Sort(FileEntryList *list)
{
	size_t i, count;
	GSList *l;
	void **sorted;
	
	count = 0;
	for (l = list->items; l != NULL; l = l->next)
		count++;
	if (count <= 1)
		return;
	sorted = g_new(void *, count);
	count = 0;
	for (l = list->items; l != NULL; l = l->next)
		sorted[count++] = l->data;
	qsort(sorted, count, sizeof(void *), FileEntrySortFunc);
	g_slist_free(list->items);
	list->items = NULL;
	for (i = count; i > 0; )
	{
		i--;
		list->items = g_slist_prepend(list->items, sorted[i]);
	}
	g_free(sorted);
}

/*** ---------------------------------------------------------------------- ***/

FileEntryList *FileEntryList_Create(void)
{
	FileEntryList *list;
	
	list = g_new(FileEntryList, 1);
	if (list == NULL)
		return NULL;
	list->Paths = NULL;
	list->items = NULL;
	return list;
}

/*** ---------------------------------------------------------------------- ***/

void FileEntryList_Destroy(FileEntryList *list)
{
	if (list)
	{
		g_slist_free_full(list->items, FileEntryRec_free);
		g_slist_free_full(list->Paths, g_free);
		g_free(list);
	}
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean G_GNUC_WARN_UNUSED_RESULT FinishBlock(DirectoryChunk *dir, ChmStream *Stream, int *AIndex, gboolean Final)
{
	PMGIIndexChunk Header;
	
	++(*AIndex);
	Header.sig = PMGIsig;
	Header.UnusedSpace = DirectoryChunk_FreeSpace(dir->ParentChunk);
	DirectoryChunk_WriteHeader(dir->ParentChunk, &Header);
	if (PMGIDirectoryChunk_WriteChunkToStream(dir->ParentChunk, Stream, AIndex, Final) == FALSE)
		return FALSE;
	DirectoryChunk_Clear(dir->ParentChunk);
	return TRUE;
}

gboolean PMGIDirectoryChunk_WriteChunkToStream(DirectoryChunk *dir, ChmStream *Stream, int *AIndex, gboolean Final)
{
	uint8_t NewBuffer[DIR_BLOCK_SIZE];
	int EntryLength;
	int WriteSize;
	chm_off_t OldPos, NewPos, NewStart;

	if (dir->ItemCount < 1)
	{
		CHM_DEBUG_LOG(0, "WHAT ARE YOU DOING!!\n");
		--(*AIndex);
		return FALSE;
	}
	
	OldPos = ChmStream_Tell(Stream);
	if (DirectoryChunk_WriteChunkToStream(dir, Stream) == FALSE)
		return FALSE;
	NewPos = ChmStream_Tell(Stream);
	++dir->ChunkLevelCount;

	if (Final && dir->ChunkLevelCount < 2)
	{
		DirectoryChunk_Destroy(dir->ParentChunk);
		dir->ParentChunk = NULL;
		return TRUE;
	}
	if (dir->ParentChunk == NULL)
		dir->ParentChunk = DirectoryChunk_Create(dir->HeaderSize);

	NewStart = OldPos + dir->HeaderSize;
	if (ChmStream_Seek(Stream, NewStart) == FALSE)
		return FALSE;
	EntryLength = GetCompressedInteger(Stream);
	WriteSize = (ChmStream_Tell(Stream) - NewStart) + EntryLength;
	assert(WriteSize < DIR_BLOCK_SIZE);
	memcpy(NewBuffer, &dir->Buffer[dir->HeaderSize], WriteSize);
	WriteSize += PutCompressedInteger(&NewBuffer[WriteSize], *AIndex);

	if (ChmStream_Seek(Stream, NewPos) == FALSE)
		return FALSE;
	
	if (!DirectoryChunk_CanHold(dir->ParentChunk, WriteSize))
	{
		if (FinishBlock(dir, Stream, AIndex, Final) == FALSE)
			return FALSE;
	}

	if (DirectoryChunk_WriteEntry(dir->ParentChunk, WriteSize, NewBuffer) == FALSE)
		return FALSE;
	if (Final)
	{
		if (FinishBlock(dir, Stream, AIndex, Final) == FALSE)
			return FALSE;
	}
	
	return FALSE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void ChmWindow_Clear(ChmWindow *win)
{
	if (win->strings_alloced)
	{
		g_free(win->window_name.s);
		g_free(win->caption.s);
		g_free(win->toc_file.s);
		g_free(win->index_file.s);
		g_free(win->default_file.s);
		g_free(win->home_button_file.s);
		g_free(win->jump1_url.s);
		g_free(win->jump1_text.s);
		g_free(win->jump2_url.s);
		g_free(win->jump2_text.s);
	}
	win->window_name.s = NULL;
	win->caption.s = NULL;
	win->toc_file.s = NULL;
	win->index_file.s = NULL;
	win->default_file.s = NULL;
	win->home_button_file.s = NULL;
	win->jump1_url.s = NULL;
	win->jump1_text.s = NULL;
	win->jump2_url.s = NULL;
	win->jump2_text.s = NULL;
	win->strings_alloced = FALSE;
}

/*** ---------------------------------------------------------------------- ***/

ChmWindow *ChmWindow_Create(void)
{
	ChmWindow *win;
	
	win = g_new0(ChmWindow, 1);
	if (win == NULL)
		return NULL;
	win->flags = defvalidflags;
	win->win_properties = HHWIN_DEF_BUTTONS;
	return win;
}

/*** ---------------------------------------------------------------------- ***/

void ChmWindow_Destroy(ChmWindow *win)
{
	if (win == NULL)
		return;
	ChmWindow_Clear(win);
	g_free(win);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

ChmIdxhdr *ChmIdxhdr_Create(void)
{
	return g_new0(ChmIdxhdr, 1);
}

/*** ---------------------------------------------------------------------- ***/

void ChmIdxhdr_Destroy(ChmIdxhdr *idx)
{
	if (idx == NULL)
		return;
	/*
	 * all the strings are from string file object and must not be freed
	 */
	g_free(idx);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ChmSystem_freestrings(ChmSystem *sys)
{
	g_free(sys->toc_file.s);
	g_free(sys->index_file.s);
	g_free(sys->default_page.s);
	g_free(sys->caption.s);
	g_free(sys->default_window.s);
	g_free(sys->chm_filename.s);
	g_free(sys->chm_compiler_version.s);
	/*
	 * font, abbrev & explanation are from strings file object and must not be freed
	 */
	sys->toc_file.s = NULL;
	sys->index_file.s = NULL;
	sys->default_page.s = NULL;
	sys->caption.s = NULL;
	sys->default_window.s = NULL;
	sys->chm_filename.s = NULL;
	sys->abbrev.s = NULL;
	sys->abbrev_explanation.s = NULL;
	sys->chm_compiler_version.s = NULL;
}

/*** ---------------------------------------------------------------------- ***/

ChmSystem *ChmSystem_Create(void)
{
	ChmSystem *sys;
	
	sys = g_new0(ChmSystem, 1);
	if (sys == NULL)
		return NULL;
	return sys;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSystem_Destroy(ChmSystem *sys)
{
	if (sys == NULL)
		return;
	ChmSystem_freestrings(sys);
	ChmIdxhdr_Destroy(sys->idxhdr);
	g_free(sys);
}
