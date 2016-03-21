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

static char *getnext(const char *s, size_t *i, size_t len)
{
	char *result;
	size_t ind;
	
	ind = *i;
	if (ind >= len)
		return NULL;
	if (s[ind] == '"')
	{
		++ind;
		while (ind < len && s[ind] != '"')
			++ind;
		result = g_strndup(s + *i + 1, ind - *i - 1);
		++ind; /* skip " */
	} else
	{
		while (ind < len && s[ind] != ',' && s[ind] != '=')
			++ind;
		result = g_strndup(s + *i, ind - *i);
	}
	*i =ind + 1; /* skip , */
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static int getnextint(const char *txt, size_t *ind, size_t len, ValidWindowFields *flags, ValidWindowFields x)
{
	char *s;
	int result;
	
	s = getnext(txt, ind, len);
	/* set a flag if the field was empty (,,) */
	if (empty(s))
	{
		result = 0;
	} else
	{
		*flags |= x;
		result = (int)strtoul(s, NULL, 0);
	}
	g_free(s);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static void CHMWindow_freestrings(CHMWindow *win)
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

void CHMWindow_loadfromini(CHMWindow *win, const char *txt)
{
	size_t ind;
	size_t len;
	int k;
	int arr[4];
	gboolean bArr;
	char *s2;
	
	if (empty(txt))
		return;
	CHMWindow_freestrings(win);
	win->strings_alloced = TRUE;
	ind = 0;
	len = strlen(txt);
	win->flags = 0;
	win->window_name.s = getnext(txt, &ind, len);
	win->caption.s = getnext(txt, &ind, len);
	win->toc_file.s = getnext(txt, &ind, len);
	win->index_file.s = getnext(txt, &ind, len);
	win->default_file.s = getnext(txt, &ind, len);
	win->home_button_file.s = getnext(txt, &ind, len);
	win->jump1_url.s = getnext(txt, &ind, len);
	win->jump1_text.s = getnext(txt, &ind, len);
	win->jump2_url.s = getnext(txt, &ind, len);
	win->jump2_text.s = getnext(txt, &ind, len);
	win->win_properties = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_PROPERTIES);
	win->navpanewidth = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_NAV_WIDTH);
	win->buttons = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_TB_FLAGS);

	/* initialize arr[] */
	arr[0] = 0;
	arr[1] = 0;
	arr[2] = 0;
	arr[3] = 0;
	k = 0;
	bArr = FALSE;
	/* "[" int,int,int,int "]", |,	*/
	s2 = getnext(txt, &ind, len);
	if (!empty(s2))
	{
		char *j;
		
		/* check if first chart is "[" */
		if (s2[1] == '[')
		{
			memmove(s2, s2 + 1, strlen(s2 + 1) + 1);
			bArr = TRUE;
		}
		/* looking for a max 4 int followed by a closing "]" */
		do {
			if (k > 0)
			{
				g_free(s2);
				s2 = getnext(txt, &ind, len);
			}
			
			j = strchr(s2, ']');
			if (j)
				*j = '\0';
			chomp(&s2);
			if (!empty(s2))
			{
				win->flags |= HHWIN_PARAM_RECT;
				arr[k] = (int)strtoul(s2, NULL, 0);
			}
			++k;
		} while (bArr && j == NULL && ind < len && k < 4);
		g_free(s2);
	}
	 
	win->pos.left = arr[0];
	win->pos.top = arr[1];
	win->pos.right = arr[2];
	win->pos.bottom = arr[3];
	win->styleflags = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_STYLES);
	win->xtdstyleflags = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_EXSTYLES);
	win->show_state = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_SHOWSTATE);
	win->not_expanded = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_EXPANSION);
	win->navtype = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_CUR_TAB);
	win->tabpos = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_TABPOS);
	win->wm_notify_id = getnextint(txt, &ind, len, &win->flags, HHWIN_PARAM_NOTIFY_ID);
}

/*** ---------------------------------------------------------------------- ***/

void CHMWindow_savetoxml(CHMWindow *win, ChmStream *stream)
{
	char *s;
	FILE *out;
	
	assert(ChmStream_Type(stream) == chm_stream_file);
	out = ChmStream_Fileptr(stream);
	fprintf(out, "    <window");
	s = xml_quote(win->window_name.c);
	fprintf(out, " name=%s", s);
	g_free(s);
	if (win->caption.c)
	{
		s = xml_quote(win->caption.c);
		fprintf(out, " caption=%s", s);
		g_free(s);
	}
	if (win->toc_file.c)
	{
		s = xml_quote(win->toc_file.c);
		fprintf(out, " toc_file=%s", s);
		g_free(s);
	}
	if (win->index_file.c)
	{
		s = xml_quote(win->index_file.c);
		fprintf(out, " index_file=%s", s);
		g_free(s);
	}
	if (win->default_file.c)
	{
		s = xml_quote(win->default_file.c);
		fprintf(out, " default_file=%s", s);
		g_free(s);
	}
	if (win->home_button_file.c)
	{
		s = xml_quote(win->home_button_file.c);
		fprintf(out, " home_button_file=%s", s);
		g_free(s);
	}
	if (win->jump1_url.c)
	{
		s = xml_quote(win->jump1_url.c);
		fprintf(out, " jump1_url=%s", s);
		g_free(s);
	}
	if (win->jump1_text.c)
	{
		s = xml_quote(win->jump1_text.c);
		fprintf(out, " jump1_text=%s", s);
		g_free(s);
	}
	if (win->jump2_url.c)
	{
		s = xml_quote(win->jump2_url.c);
		fprintf(out, " jump2_url=%s", s);
		g_free(s);
	}
	if (win->jump2_text.c)
	{
		s = xml_quote(win->jump2_text.c);
		fprintf(out, " jump2_text=%s", s);
		g_free(s);
	}
	if (win->flags & HHWIN_PARAM_PROPERTIES)
		fprintf(out, " win_properties=0x%x", win->win_properties);
	if (win->flags & HHWIN_PARAM_NAV_WIDTH)
		fprintf(out, " navpanewidth=%d", win->navpanewidth);
	if (win->flags & HHWIN_PARAM_TB_FLAGS)
		fprintf(out, " buttons=0x%x", win->buttons);
	if (win->flags & HHWIN_PARAM_RECT)
	{
		fprintf(out, " left=%d", win->pos.left);
		fprintf(out, " top=%d", win->pos.top);
		fprintf(out, " right=%d", win->pos.right);
		fprintf(out, " bottom=%d", win->pos.bottom);
	}
	if (win->flags & HHWIN_PARAM_STYLES)
		fprintf(out, " styleflags=0x%x", win->styleflags);
	if (win->flags & HHWIN_PARAM_EXSTYLES)
		fprintf(out, " xtdstyleflags=0x%x", win->xtdstyleflags);
	if (win->flags & HHWIN_PARAM_SHOWSTATE)
		fprintf(out, " show_state=%d", win->show_state);
	if (win->flags & HHWIN_PARAM_EXPANSION)
		fprintf(out, " not_expanded=%d", win->not_expanded);
	if (win->flags & HHWIN_PARAM_CUR_TAB)
		fprintf(out, " navtype=%d", win->navtype);
	if (win->flags & HHWIN_PARAM_TABPOS)
		fprintf(out, " tabpos=%d", win->tabpos);
	if (win->flags & HHWIN_PARAM_NOTIFY_ID)
		fprintf(out, " wm_notify_id=%d", win->wm_notify_id);
	fprintf(out, "/>\n");
}

/*** ---------------------------------------------------------------------- ***/

static int xml_getintval(const char *tag, size_t taglen, const char *attrib, ValidWindowFields *flags, ValidWindowFields x)
{
	char *s = GetVal(tag, taglen, attrib);
	int result = 0;
	if (s)
	{
		result = (int)strtoul(s, NULL, 0);
		*flags |= x;
	}
	g_free(s);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

void CHMWindow_loadfromxml(CHMWindow *win, const char *tag)
{
	size_t taglen = strlen(tag);
	
	CHMWindow_freestrings(win);
	win->flags = 0;
	win->strings_alloced = TRUE;
	win->window_name.s = GetVal(tag, taglen, "name");
	win->caption.s = GetVal(tag, taglen, "caption");
	win->toc_file.s = GetVal(tag, taglen, "toc_file");
	win->index_file.s = GetVal(tag, taglen, "index_file");
	win->default_file.s = GetVal(tag, taglen, "default_file");
	win->home_button_file.s = GetVal(tag, taglen, "home_button_file");
	win->jump1_url.s = GetVal(tag, taglen, "jump1_url");
	win->jump1_text.s = GetVal(tag, taglen, "jump1_text");
	win->jump2_url.s = GetVal(tag, taglen, "jump2_url");
	win->jump2_text.s = GetVal(tag, taglen, "jump2_text");
	win->win_properties = xml_getintval(tag, taglen, "win_properties", &win->flags, HHWIN_PARAM_PROPERTIES);
	win->navpanewidth = xml_getintval(tag, taglen, "navpanewidth", &win->flags, HHWIN_PARAM_NAV_WIDTH);
	win->buttons = xml_getintval(tag, taglen, "buttons", &win->flags, HHWIN_PARAM_TB_FLAGS);
	win->pos.left = xml_getintval(tag, taglen, "left", &win->flags, HHWIN_PARAM_RECT);
	win->pos.top = xml_getintval(tag, taglen, "top", &win->flags, HHWIN_PARAM_RECT);
	win->pos.right = xml_getintval(tag, taglen, "right", &win->flags, HHWIN_PARAM_RECT);
	win->pos.bottom = xml_getintval(tag, taglen, "bottom", &win->flags, HHWIN_PARAM_RECT);
	win->styleflags = xml_getintval(tag, taglen, "styleflags", &win->flags, HHWIN_PARAM_STYLES);
	win->xtdstyleflags = xml_getintval(tag, taglen, "xtdstyleflags", &win->flags, HHWIN_PARAM_EXSTYLES);
	win->show_state = xml_getintval(tag, taglen, "show_state", &win->flags, HHWIN_PARAM_SHOWSTATE);
	win->not_expanded = xml_getintval(tag, taglen, "not_expanded", &win->flags, HHWIN_PARAM_EXPANSION);
	win->navtype = xml_getintval(tag, taglen, "navtype", &win->flags, HHWIN_PARAM_CUR_TAB);
	win->tabpos = xml_getintval(tag, taglen, "tabpos", &win->flags, HHWIN_PARAM_TABPOS);
	win->wm_notify_id = xml_getintval(tag, taglen, "wm_notify_id", &win->flags, HHWIN_PARAM_NOTIFY_ID);
}

/*** ---------------------------------------------------------------------- ***/

CHMWindow *CHMWindow_Create(const char *s)
{
	CHMWindow *win;
	
	win = g_new0(CHMWindow, 1);
	if (win == NULL)
		return NULL;
	win->flags = defvalidflags;
	win->win_properties = HHWIN_DEF_BUTTONS;
	CHMWindow_loadfromini(win, s);
	return win;
}

/*** ---------------------------------------------------------------------- ***/

void CHMWindow_Destroy(CHMWindow *win)
{
	if (win == NULL)
		return;
	CHMWindow_freestrings(win);
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
