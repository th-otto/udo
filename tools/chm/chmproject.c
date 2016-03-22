#include "chmtools.h"
#include "chmproject.h"
#include "chmxml.h"

#define CREATOR "CHM"

typedef struct _ChmContextNode {
	int fileindex;			/* index into the project->files list */
	int number;
	gboolean number_valid;
	char *contextname;		/* title or alias name */
} ChmContextNode;

static char const sec_options[] = "OPTIONS";
static char const xml_options[] = "param";

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static ChmContextNode *ChmContextNode_Create(int fileindex, const char *contextname)
{
	ChmContextNode *node;
	
	node = g_new(ChmContextNode, 1);
	if (node == NULL)
		return NULL;
	node->fileindex = fileindex;
	node->contextname = g_strdup(contextname);
	node->number = 0;
	node->number_valid = FALSE;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static void ChmContextNode_Destroy(ChmContextNode *node)
{
	if (node == NULL)
		return;
	g_free(node->contextname);
	g_free(node);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int compare_file(const void *s1, const void *s2)
{
	return ChmCompareText((const char *)s1, (const char *)s2);
}

/*** ---------------------------------------------------------------------- ***/

static int add_unique(GSList **list, char *key)
{
	GSList *l;
	const char *name;
	int fileindex;
	
	if (empty(key))
		return -1;
	convexternalslash(key);
	for (l = *list, fileindex = 0; l; l = l->next)
	{
		name = (const char *)l->data;
		if (strcasecmp(name, key) == 0)
			return fileindex;
		++fileindex;
	}
	*list = g_slist_append(*list, g_strdup(key));
	return fileindex;
}

/*** ---------------------------------------------------------------------- ***/

static int add_url(GSList **list, char *name)
{
	return add_unique(list, name);
}

/*** ---------------------------------------------------------------------- ***/

static char *cleanupstring(char *s)
{
	char *p;
	
	if (empty(s))
		return s;
	p = strchr(s, ';');
	if (p)
		*p = '\0';
	return chomp(s);
}

/*** ---------------------------------------------------------------------- ***/

static char **loadfromfile(const char *filename)
{
	FILE *fp;
	char **lines = NULL;
	char *mem;
	size_t size;
	char *linestart;
	size_t nlines = 0;
	char *p;
	
	fp = fopen(filename, "rb");
	if (fp == NULL)
	{
		CHM_DEBUG_LOG(0, "%s: %s\n", filename, strerror(errno));
		return NULL;
	}
	fseek(fp, 0, SEEK_END);
	size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	if (size == 0)
	{
		lines = g_new(char *, 1);
		lines[0] = NULL;
	} else
	{
		mem = g_new(char, size + 1);
		if (mem != NULL)
		{
			fread(mem, 1, size, fp);
			mem[size] = '\0';
			p = mem;
			while (*p != '\0')
			{
				linestart = p;
				while (*p != '\0' && *p != 0x0d && *p != 0x0a)
					p++;
				lines = g_renew(char *, lines, nlines + 2);
				lines[nlines++] = linestart;
				if (*p == 0x0d)
					*p++ = '\0';
				if (*p == 0x0a)
					*p++ = '\0';
			}
			if (lines == NULL)
				lines = g_renew(char *, lines, nlines + 1);
			lines[nlines] = NULL;
		}
	}
	fclose(fp);
	return lines;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean add_alias(ChmProject *project, char *key, char *contextname)
{
	ChmContextNode *node;
	int fileindex;
	GSList *l;
	
	chomp(key);
	chomp(contextname);
	if (!empty(contextname) && (fileindex = add_url(&project->files, key)) >= 0)
	{
		for (l = project->alias; l != NULL; l = l->next)
		{
			node = (ChmContextNode *)l->data;
			if (node->contextname != NULL && strcmp(node->contextname, contextname) == 0)
			{
				CHM_DEBUG_LOG(0, "warning: redefinition of alias %s\n", contextname);
				node->fileindex = fileindex;
				return TRUE;
			}
		}
		node = ChmContextNode_Create(fileindex, contextname);
		project->alias = g_slist_append(project->alias, node);
		return TRUE;
	}
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

static void processalias(ChmProject *project, char **strs)
{
	size_t i;
	char *s;
	char *orig;
	char **strs2;
	char *p;
	size_t len;
	
	if (strs == NULL)
		return;
	for (i = 0; (orig = strs[i]) != NULL; i++)
	{
		s = g_strdup(orig);
		cleanupstring(s);
		if (g_ascii_strncasecmp(s, "#include", 8) == 0)
		{
			memmove(s, s + 8, strlen(s + 8) + 1);
			s = chomp(s);
			len = strlen(s);
			if (*s == '<' || *s == '"')
			{
				memmove(s, s + 1, strlen(s + 1) + 1);
				len--;
			}
			if (!empty(s))
			{
				if (s[len - 1] == '>' || s[len - 1] == '"')
					s[--len] = '\0';
				if (len > 0)
				{
					char *path = g_build_filename(project->basepath, s, NULL);
					strs2 = loadfromfile(path);
					processalias(project, strs2);
					if (strs2 != NULL)
						g_free(strs2[0]);
					g_free(strs2);
					g_free(path);
				}
			}
		} else
		{
			p = strchr(s, '=');
			if (p != NULL)
			{
				*p++ = '\0';
				add_alias(project, p, s);
			}
		}
		g_free(s);
	}
}

/*** ---------------------------------------------------------------------- ***/

static gboolean add_map(ChmProject *project, char *number, char *contextname)
{
	ChmContextNode *node;
	GSList *l;
	
	chomp(number);
	chomp(contextname);
	if (empty(contextname) || empty(number))
		return FALSE;
	for (l = project->alias; l != NULL; l = l->next)
	{
		node = (ChmContextNode *)l->data;
		if (node->contextname != NULL && strcmp(node->contextname, contextname) == 0)
		{
			if (node->number_valid)
			{
				CHM_DEBUG_LOG(0, "warning: redefinition of mapping %s\n", contextname);
			}
			node->number = (int)strtol(number, NULL, 0);
			node->number_valid = TRUE;
			return TRUE;
		}
	}
	CHM_DEBUG_LOG(0, "warning: alias for %s was not defined\n", contextname);
	node = ChmContextNode_Create(-1, contextname);
	node->number = (int)strtol(number, NULL, 0);
	node->number_valid = TRUE;
	project->alias = g_slist_append(project->alias, node);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static void processmap(ChmProject *project, char **strs)
{
	size_t i;
	char *s;
	char *orig;
	char **strs2;
	char *p;
	size_t len;
	
	if (strs == NULL)
		return;
	for (i = 0; (orig = strs[i]) != NULL; i++)
	{
		s = g_strdup(orig);
		cleanupstring(s);
		if (g_ascii_strncasecmp(s, "#include", 8) == 0)
		{
			memmove(s, s + 8, strlen(s + 8) + 1);
			s = chomp(s);
			len = strlen(s);
			if (*s == '<' || *s == '"')
			{
				memmove(s, s + 1, strlen(s + 1) + 1);
				len--;
			}
			if (!empty(s))
			{
				if (s[len - 1] == '>' || s[len - 1] == '"')
					s[--len] = '\0';
				if (len > 0)
				{
					char *path = g_build_filename(project->basepath, s, NULL);
					strs2 = loadfromfile(path);
					processmap(project, strs2);
					if (strs2 != NULL)
						g_free(strs2[0]);
					g_free(strs2);
					g_free(path);
				}
			}
		} else if (g_ascii_strncasecmp(s, "#define", 7) == 0)
		{
			memmove(s, s + 7, strlen(s + 7) + 1);
			s = chomp(s);
			p = strchr(s, ' ');
			if (p != NULL)
			{
				*p++ = '\0';
				add_map(project, p, s);
			}
		} else
		{
			CHM_DEBUG_LOG(1, "unrecognized entry in [MAP]: %s\n", s);
		}
		g_free(s);
	}
}

/*** ---------------------------------------------------------------------- ***/

static void ChmProject_Clear(ChmProject *project)
{
	g_freep(&project->default_font);
	g_freep(&project->default_page);
	g_slist_free_full(project->files, g_free);
	project->files = NULL;
	g_slist_free_full(project->alias, (GDestroyNotify)ChmContextNode_Destroy);
	project->alias = NULL;
	g_strfreev(project->alias_contents);
	project->alias_contents = NULL;
	g_strfreev(project->map_contents);
	project->map_contents = NULL;
	g_slist_free_full(project->otherfiles, g_free);
	project->otherfiles = NULL;
	g_freep(&project->index_filename);
	g_freep(&project->hhp_filename);
	g_freep(&project->out_filename);
	g_freep(&project->toc_filename);
	g_freep(&project->title);
	g_slist_free_full(project->windows, (GDestroyNotify)ChmWindow_Destroy);
	project->windows = NULL;
	g_slist_free_full(project->mergefiles, g_free);
	project->mergefiles = NULL;
	g_freep(&project->default_window);
	g_slist_free_full(project->allowed_extensions, g_free);
	project->allowed_extensions = NULL;
	AVLTree_Destroy(project->TotalFileList);
	project->TotalFileList = NULL;
	g_slist_free_full(project->anchorlist, g_free);
	project->anchorlist = NULL;
	g_freep(&project->basepath);
	g_freep(&project->ReadmeMessage);
	ChmSiteMap_Destroy(project->toc);
	project->toc = NULL;
	ChmSiteMap_Destroy(project->index);
	project->index = NULL;
	ChmStream_Close(project->tocstream);
	project->tocstream = NULL;
	ChmStream_Close(project->indexstream);
	project->indexstream = NULL;
	g_freep(&project->custom_tab);
	g_freep(&project->sample_staging_path);
	g_freep(&project->sample_list_file);
	g_freep(&project->citation);
	g_freep(&project->copyright);
	g_freep(&project->error_log_file);
	g_freep(&project->fts_stop_list_file_name);
}

/*** ---------------------------------------------------------------------- ***/

static void ChmProject_Init(ChmProject *project)
{
	project->allowed_extensions = g_slist_append(project->allowed_extensions, g_strdup(".htm"));
	project->allowed_extensions = g_slist_append(project->allowed_extensions, g_strdup(".html"));
	project->TotalFileList = AVLTree_Create(compare_file, g_free);
	project->MakeBinaryIndex = TRUE;
	project->flat = TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static char *getnext(const char *s, size_t *i, size_t len)
{
	char *result = NULL;
	size_t ind;
	
	ind = *i;
	if (ind >= len)
		return NULL;
	if (s[ind] == '"')
	{
		++ind;
		while (ind < len && s[ind] != '"')
			++ind;
		if ((ind - *i - 1) > 0)
			result = g_strndup(s + *i + 1, ind - *i - 1);
		++ind; /* skip " */
	} else
	{
		while (ind < len && s[ind] != ',')
			++ind;
		if ((ind - *i) > 0)
			result = g_strndup(s + *i, ind - *i);
	}
	*i = ind + 1; /* skip , */
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

static void ChmWindow_LoadFromIni(ChmWindow *win, const char *name, const char *txt)
{
	size_t ind;
	size_t len;
	int k;
	int arr[4];
	gboolean bArr;
	char *s2;
	
	if (empty(name))
		return;
	ChmWindow_Clear(win);
	if (empty(txt))
		return;
	win->strings_alloced = TRUE;
	ind = 0;
	len = strlen(txt);
	win->flags = 0;
	win->window_name.s = g_strdup(name);
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
			s2 = chomp(s2);
			if (!empty(s2))
			{
				win->flags |= HHWIN_PARAM_RECT;
				arr[k] = (int)strtoul(s2, NULL, 0);
			}
			++k;
		} while (bArr && j == NULL && ind < len && k < 4);
	}
	g_free(s2);
	 
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

gboolean ChmProject_LoadFromHhp(ChmProject *project, const char *filename)
{
	char **strs;
	size_t i;
	Profile *profile;
	char *windows;
	const char *base;
	char *str;
	unsigned int id;
	
	if ((profile = Profile_Load(filename, CREATOR)) == NULL)
		return FALSE;

	ChmProject_Clear(project);
	ChmProject_Init(project);
	
	project->hhp_filename = g_strdup(filename);
			
	base = chm_basename(filename);
	if (base == filename)
		project->basepath = g_strdup(".");
	else
		project->basepath = g_strndup(filename, base - filename);
	
	/* Do the files section first so that we can emit errors if */
	/* other sections reference unknown files. */
	strs = Profile_GetSection(profile, "FILES");
	if (strs)
	{
		for (i = 0; strs[i] != NULL; i++)
		{
			cleanupstring(strs[i]);
			add_url(&project->files, strs[i]);
		}
	}
	g_strfreev(strs);
	
	/* aliases also add file nodes. */
	project->alias_contents = Profile_GetSection(profile, "ALIAS");
	processalias(project, project->alias_contents);
	
	/* map files only add to existing file nodes. */
	project->map_contents = Profile_GetSection(profile, "MAP");
	processmap(project, project->map_contents);
	
	windows = Profile_GetKeyNames(profile, "WINDOWS", NULL);
	if (windows)
	{
		char *name = windows;
		char *value;
		ChmWindow *win;
		
		while (*name)
		{
			if (Profile_ReadStringUnquoted(profile, "WINDOWS", name, &value))
			{
				win = ChmWindow_Create();
				ChmWindow_LoadFromIni(win, name, value);
				project->windows = g_slist_append(project->windows, win);
				g_free(value);
			}
			name += strlen(name) + 1;
		}
		g_free(windows);
	}
	
	strs = Profile_GetSection(profile, "MERGE FILES");
	if (strs)
	{
		for (i = 0; strs[i] != NULL; i++)
		{
			cleanupstring(strs[i]);
			if (!empty(strs[i]))
				project->mergefiles = g_slist_append(project->mergefiles, strs[i]);
		}
		g_free(strs);
	}
	
	Profile_ReadString(profile, sec_options, "Title", &project->title);
	Profile_ReadString(profile, sec_options, "Default topic", &project->default_page);
	Profile_ReadString(profile, sec_options, "Default Window", &project->default_window);
	Profile_ReadString(profile, sec_options, "Default Font", &project->default_font);
	Profile_ReadCard(profile, sec_options, "Language", &id);
	project->language_id = id;
	Profile_ReadBool(profile, sec_options, "Auto Index", &project->auto_index);
	Profile_ReadInt(profile, sec_options, "Auto TOC", &project->auto_toc);
	if (!Profile_ReadBool(profile, sec_options, "Binary Index", &project->MakeBinaryIndex))
		project->MakeBinaryIndex = TRUE;
	Profile_ReadBool(profile, sec_options, "Binary TOC", &project->MakeBinaryTOC);
	Profile_ReadString(profile, sec_options, "Compiled file", &project->out_filename);
	convexternalslash(project->out_filename);
	Profile_ReadString(profile, sec_options, "Contents file", &project->toc_filename);
	convexternalslash(project->toc_filename);
	Profile_ReadString(profile, sec_options, "Index file", &project->index_filename);
	convexternalslash(project->index_filename);
	Profile_ReadString(profile, sec_options, "Error log", &project->error_log_file);
	convexternalslash(project->error_log_file);
	if (Profile_ReadString(profile, sec_options, "Compatibility", &str))
	{
		if (strncmp(str, "1.0", 3) == 0)
			project->compatibility = TRUE;
		g_free(str);
	}
	Profile_ReadBool(profile, sec_options, "Create CHI file", &project->create_chi_file);
	Profile_ReadBool(profile, sec_options, "DBCS", &project->dbcs);
	Profile_ReadBool(profile, sec_options, "Display compile notes", &project->display_compile_notes);
	Profile_ReadBool(profile, sec_options, "Display compile progress", &project->display_compile_progress);
	Profile_ReadBool(profile, sec_options, "Enhanced decompilation", &project->enhanced_decompilation);
	if (!Profile_ReadBool(profile, sec_options, "Flat", &project->flat))
		project->flat = TRUE;
	Profile_ReadString(profile, sec_options, "Full text search stop list file", &project->fts_stop_list_file_name);
	Profile_ReadBool(profile, sec_options, "Full-text search", &project->full_text_search);
	Profile_ReadString(profile, sec_options, "Sample Staging Path", &project->sample_staging_path);
	Profile_ReadString(profile, sec_options, "Sample list file", &project->sample_list_file);
	Profile_ReadString(profile, sec_options, "Custom tab", &project->custom_tab);
	Profile_ReadString(profile, sec_options, "CITATION", &project->citation);
	Profile_ReadString(profile, sec_options, "COPYRIGHT", &project->copyright);
	Profile_ReadInt(profile, sec_options, "COMPRESS", &project->compress);
	
	if (project->alias)
	{
		GSList *l;
		const ChmContextNode *node;
		for (l = project->alias; l; l = l->next)
		{
			node = (const ChmContextNode *)l->data;
			if (!node->number_valid)
			{
				CHM_DEBUG_LOG(0, "warning: no mapping defined for %s\n", node->contextname);
			}
		}
	}
	
	/* IGNORED: TMPDIR */
	/* NYI: PREFIX */
	
	/* TODO: [TEXT POPUPS] */
	/* TODO: [INFOTYPES] */
	/* TODO: [SUBSETS] */
	
	Profile_Delete(profile);
	project->ScanHtmlContents = TRUE;
	
	return TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

gboolean ChmProject_SaveToHhp(ChmProject *project, const char *filename)
{
	Profile *profile;
	gboolean retV;
	
	if (project == NULL)
		return FALSE;
	if (filename == NULL)
		filename = project->hhp_filename;
	if (filename == NULL)
		return FALSE;
	if ((profile = Profile_New(filename)) == NULL)
		return FALSE;
	Profile_SetBoolStrings(profile, "Yes", "No");
	
	Profile_WriteString(profile, sec_options, "Title", project->title);
	Profile_WriteString(profile, sec_options, "Default topic", project->default_page);
	Profile_WriteString(profile, sec_options, "Default Window", project->default_window);
	Profile_WriteString(profile, sec_options, "Default Font", project->default_font);
	Profile_WriteCard(profile, sec_options, "Language", project->language_id);
	Profile_WriteBool(profile, sec_options, "Auto Index", project->auto_index);
	if (project->auto_toc != 0)
		Profile_WriteInt(profile, sec_options, "Auto TOC", project->auto_toc);
	Profile_WriteBool(profile, sec_options, "Binary Index", project->MakeBinaryIndex);
	Profile_WriteBool(profile, sec_options, "Binary TOC", project->MakeBinaryTOC);
	Profile_WriteString(profile, sec_options, "Compiled file", project->out_filename);
	Profile_WriteString(profile, sec_options, "Contents file", project->toc_filename);
	Profile_WriteString(profile, sec_options, "Index file", project->index_filename);
	Profile_WriteString(profile, sec_options, "Error log", project->error_log_file);
	Profile_WriteString(profile, sec_options, "Compatibility", project->compatibility ? "1.0" : "1.1 or later");
	Profile_WriteBool(profile, sec_options, "Create CHI file", project->create_chi_file);
	Profile_WriteBool(profile, sec_options, "DBCS", project->dbcs);
	Profile_WriteBool(profile, sec_options, "Display compile notes", project->display_compile_notes);
	Profile_WriteBool(profile, sec_options, "Display compile progress", project->display_compile_progress);
	Profile_WriteBool(profile, sec_options, "Enhanced decompilation", project->enhanced_decompilation);
	Profile_WriteBool(profile, sec_options, "Flat", project->flat);
	Profile_WriteString(profile, sec_options, "Full text search stop list file", project->fts_stop_list_file_name);
	Profile_WriteBool(profile, sec_options, "Full-text search", project->full_text_search);
	Profile_WriteString(profile, sec_options, "Sample Staging Path", project->sample_staging_path);
	Profile_WriteString(profile, sec_options, "Sample list file", project->sample_list_file);
	Profile_WriteString(profile, sec_options, "Custom tab", project->custom_tab);
	Profile_WriteString(profile, sec_options, "CITATION", project->citation);
	Profile_WriteString(profile, sec_options, "COPYRIGHT", project->copyright);
	if (project->compress)
		Profile_WriteInt(profile, sec_options, "COMPRESS", project->compress);
	
	if (project->windows)
	{
		GSList *l;
		const ChmWindow *win;
		char *buf;
		
		for (l = project->windows; l; l = l->next)
		{
			win = (const ChmWindow *)l->data;
#define str(s) s ? "\"" : "", s ? s : "", s ? "\"" : ""
			buf = g_strdup_printf("%s%s%s,%s%s%s,%s%s%s,%s%s%s,%s%s%s,%s%s%s,%s%s%s,%s%s%s,%s%s%s,0x%x,%d,0x%x,[%d,%d,%d,%d],0x%x,0x%x,%d,%d,%d,%d,%d",
				str(win->caption.c),
				str(win->toc_file.c),
				str(win->index_file.c),
				str(win->default_file.c),
				str(win->home_button_file.c),
				str(win->jump1_url.c),
				str(win->jump1_text.c),
				str(win->jump2_url.c),
				str(win->jump2_text.c),
				win->win_properties,
				win->navpanewidth,
				win->buttons,
				win->pos.left, win->pos.top, win->pos.right, win->pos.bottom,
				win->styleflags,
				win->xtdstyleflags,
				win->show_state,
				win->not_expanded,
				win->navtype,
				win->tabpos,
				win->wm_notify_id);
			Profile_WriteStringUnquoted(profile, "WINDOWS", win->window_name.c, buf);
			g_free(buf);
#undef str
		}
	}
	
	if (project->files)
	{
		GSList *l;
		const char *name;
		char *str = g_strdup("");
		char *tmp;
		
		for (l = project->files; l; l = l->next)
		{
			name = (const char *)l->data;
			tmp = g_strconcat(str, name, "\n", NULL);
			g_free(str);
			str = tmp;
		}
		Profile_SetSection(profile, "FILES", str);
		g_free(str);
	}
	
	if (project->alias_contents)
	{
		size_t i;
		char *str = g_strdup("");
		char *tmp;
		char *s;
		
		for (i = 0; (s = project->alias_contents[i]) != NULL; i++)
		{
			if (!empty(s))
			{
				tmp = g_strconcat(str, s, "\n", NULL);
				g_free(str);
				str = tmp;
			}
		}
		if (str)
			Profile_SetSection(profile, "ALIAS", str);
		g_free(str);
	} else if (project->alias)
	{
		GSList *l;
		const ChmContextNode *node;
		const char *s;
		
		for (l = project->alias; l; l = l->next)
		{
			node = (const ChmContextNode *)l->data;
			if (node->fileindex >= 0 && (s = (char *)g_slist_nth_data(project->files, node->fileindex)) != NULL)
			{
				Profile_WriteString(profile, "ALIAS", node->contextname, s);
			}
		}		
	}
	
	if (project->map_contents)
	{
		size_t i;
		char *str = g_strdup("");
		char *tmp;
		char *s;
		
		for (i = 0; (s = project->map_contents[i]) != NULL; i++)
		{
			if (!empty(s))
			{
				tmp = g_strconcat(str, s, "\n", NULL);
				g_free(str);
				str = tmp;
			}
		}
		if (str)
			Profile_SetSection(profile, "MAP", str);
		g_free(str);
	} else if (project->alias)
	{
		GSList *l;
		const ChmContextNode *node;
		char *str = g_strdup("");
		char *tmp1, *tmp2;
		
		for (l = project->alias; l; l = l->next)
		{
			node = (const ChmContextNode *)l->data;
			if (node->number_valid)
			{
				tmp1 = g_strdup_printf("#define %s %d\n", node->contextname, node->number);
				tmp2 = g_strconcat(str, tmp1, NULL);
				g_free(str);
				str = tmp2;
				g_free(tmp1);
			}
		}		
		if (str)
			Profile_SetSection(profile, "MAP", str);
		g_free(str);
	}
	
	if (project->mergefiles)
	{
		GSList *l;
		const char *name;
		char *str = g_strdup("");
		char *tmp;
		
		for (l = project->mergefiles; l; l = l->next)
		{
			name = (const char *)l->data;
			tmp = g_strconcat(str, name, "\n", NULL);
			g_free(str);
			str = tmp;
		}
		Profile_SetSection(profile, "MERGE FILES", str);
		g_free(str);
	}
	
	if (strcmp(filename, "-") == 0)
		retV = Profile_Dump(profile, stdout);
	else
		retV = Profile_Save(profile);
	Profile_Delete(profile);
	return retV;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void xml_write_bool(FILE *fp, const char *section, const char *name, gboolean value)
{
	fprintf(fp, "    <%s name=\"%s\" value=\"%s\"/>\n", section, name, value ? "True" : "False");
}

/*** ---------------------------------------------------------------------- ***/

static void xml_write_int(FILE *fp, const char *section, const char *name, int value)
{
	fprintf(fp, "    <%s name=\"%s\" value=\"%d\"/>\n", section, name, value);
}

/*** ---------------------------------------------------------------------- ***/

static void xml_write_card(FILE *fp, const char *section, const char *name, unsigned int value)
{
	fprintf(fp, "    <%s name=\"%s\" value=\"0x%x\"/>\n", section, name, value);
}

/*** ---------------------------------------------------------------------- ***/

static void xml_write_str(FILE *fp, const char *section, const char *name, const char *value)
{
	char *s;
	
	if (value == NULL)
		return;
	s = xml_quote(value);
	fprintf(fp, "    <%s name=\"%s\" value=%s/>\n", section, name, printnull(s));
	g_free(s);
}

/*** ---------------------------------------------------------------------- ***/

static void ChmWindow_SaveToXml(const ChmWindow *win, FILE *out)
{
	char *s;
	
	fprintf(out, "    <param");
	s = xml_quote(win->window_name.c);
	fprintf(out, " name=%s", printnull(s));
	g_free(s);
	if (win->caption.c)
	{
		s = xml_quote(win->caption.c);
		fprintf(out, " caption=%s", printnull(s));
		g_free(s);
	}
	if (win->toc_file.c)
	{
		s = xml_quote(win->toc_file.c);
		fprintf(out, " toc_file=%s", printnull(s));
		g_free(s);
	}
	if (win->index_file.c)
	{
		s = xml_quote(win->index_file.c);
		fprintf(out, " index_file=%s", printnull(s));
		g_free(s);
	}
	if (win->default_file.c)
	{
		s = xml_quote(win->default_file.c);
		fprintf(out, " default_file=%s", printnull(s));
		g_free(s);
	}
	if (win->home_button_file.c)
	{
		s = xml_quote(win->home_button_file.c);
		fprintf(out, " home_button_file=%s", printnull(s));
		g_free(s);
	}
	if (win->jump1_url.c)
	{
		s = xml_quote(win->jump1_url.c);
		fprintf(out, " jump1_url=%s", printnull(s));
		g_free(s);
	}
	if (win->jump1_text.c)
	{
		s = xml_quote(win->jump1_text.c);
		fprintf(out, " jump1_text=%s", printnull(s));
		g_free(s);
	}
	if (win->jump2_url.c)
	{
		s = xml_quote(win->jump2_url.c);
		fprintf(out, " jump2_url=%s", printnull(s));
		g_free(s);
	}
	if (win->jump2_text.c)
	{
		s = xml_quote(win->jump2_text.c);
		fprintf(out, " jump2_text=%s", printnull(s));
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

gboolean ChmProject_SaveToXml(ChmProject *project, const char *filename)
{
	FILE *fp;
	
	if (project == NULL)
		return FALSE;
	if (filename == NULL)
		return FALSE;
	if (strcmp(filename, "-") ==0)
		fp = stdout;
	else
		fp = fopen(filename, "w");
	if (fp == NULL)
		return FALSE;
	
	fprintf(fp, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
	fprintf(fp, "<ProjectFile>\n");

	fprintf(fp, "  <Settings>\n");
	xml_write_str(fp, xml_options, "Title", project->title);
	xml_write_str(fp, xml_options, "DefaultTopic", project->default_page);
	xml_write_str(fp, xml_options, "DefaultWindow", project->default_window);
	xml_write_str(fp, xml_options, "DefaultFont", project->default_font);
	xml_write_card(fp, xml_options, "Language", project->language_id);
	xml_write_bool(fp, xml_options, "AutoIndex", project->auto_index);
	if (project->auto_toc != 0)
		xml_write_int(fp, xml_options, "AutoTOC", project->auto_toc);
	xml_write_bool(fp, xml_options, "BinaryIndex", project->MakeBinaryIndex);
	xml_write_bool(fp, xml_options, "BinaryTOC", project->MakeBinaryTOC);
	xml_write_str(fp, xml_options, "OutputFilename", project->out_filename);
	xml_write_str(fp, xml_options, "TOCFilename", project->toc_filename);
	xml_write_str(fp, xml_options, "IndexFilename", project->index_filename);
	xml_write_str(fp, xml_options, "ErrorlogFilename", project->error_log_file);
	xml_write_bool(fp, xml_options, "Compatibility", project->compatibility);
	xml_write_bool(fp, xml_options, "CreateCHIFie", project->create_chi_file);
	xml_write_bool(fp, xml_options, "DBCS", project->dbcs);
	xml_write_bool(fp, xml_options, "DisplayCompileNotes", project->display_compile_notes);
	xml_write_bool(fp, xml_options, "DisplayCompileProgress", project->display_compile_progress);
	xml_write_bool(fp, xml_options, "EnhancedDecompilation", project->enhanced_decompilation);
	xml_write_bool(fp, xml_options, "Flat", project->flat);
	xml_write_str(fp, xml_options, "StoplistFilename", project->fts_stop_list_file_name);
	xml_write_bool(fp, xml_options, "FullTextSearch", project->full_text_search);
	xml_write_str(fp, xml_options, "SampleStagingPath", project->sample_staging_path);
	xml_write_str(fp, xml_options, "SampleListFile", project->sample_list_file);
	xml_write_str(fp, xml_options, "CustomTabs", project->custom_tab);
	xml_write_str(fp, xml_options, "Citation", project->citation);
	xml_write_str(fp, xml_options, "Copyright", project->copyright);
	xml_write_bool(fp, xml_options, "AutoFollowLinks", project->AutoFollowLinks);
	xml_write_bool(fp, xml_options, "ScanHtmlContents", project->ScanHtmlContents);
	if (project->compress)
		xml_write_int(fp, xml_options, "Compress", project->compress);
	fprintf(fp, "  </Settings>\n");

	if (project->windows)
	{
		GSList *l;
		const ChmWindow *win;
		
		fprintf(fp, "  <Windows>\n");
		for (l = project->windows; l; l = l->next)
		{
			win = (const ChmWindow *)l->data;
			ChmWindow_SaveToXml(win, fp);
		}
		fprintf(fp, "  </Windows>\n");
	}
	
	if (project->files)
	{
		GSList *l;
		const char *name;
		
		fprintf(fp, "  <Files>\n");
		for (l = project->files; l; l = l->next)
		{
			name = (const char *)l->data;
			xml_write_str(fp, "param", "name", name);
		}
		fprintf(fp, "  </Files>\n");
	}
	
	if (project->otherfiles)
	{
		GSList *l;
		const char *name;
		
		fprintf(fp, "  <OtherFiles>\n");
		for (l = project->otherfiles; l; l = l->next)
		{
			name = (const char *)l->data;
			xml_write_str(fp, "param", "name", name);
		}
		fprintf(fp, "  </OtherFiles>\n");
	}
	
	if (project->alias)
	{
		GSList *l;
		const ChmContextNode *node;
		char *s;
		
		fprintf(fp, "  <Alias>\n");
		for (l = project->alias; l; l = l->next)
		{
			node = (const ChmContextNode *)l->data;
			s = xml_quote(node->contextname);
			fprintf(fp, "    <param name=%s", printnull(s));
			g_free(s);
			if (node->fileindex >= 0 && (s = (char *)g_slist_nth_data(project->files, node->fileindex)) != NULL)
			{
				s = xml_quote(s);
				fprintf(fp, " topic=%s", printnull(s));
				g_free(s);
			}
			if (node->number_valid)
			{
				fprintf(fp, " id=\"%d\"", node->number);
			}
			fprintf(fp, "/>\n");
		}
		fprintf(fp, "  </Alias>\n");
	}
	
	if (project->mergefiles)
	{
		GSList *l;
		const char *name;
		
		fprintf(fp, "  <MergeFiles>\n");
		for (l = project->mergefiles; l; l = l->next)
		{
			name = (const char *)l->data;
			xml_write_str(fp, "param", "name", name);
		}
		fprintf(fp, "  </MergeFiles>\n");
	}
	
	fprintf(fp, "</ProjectFile>\n");
	
	fflush(fp);
	if (fp != stdout)
		fclose(fp);
	return TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

gboolean ChmProject_LoadFromXml(ChmProject *project, const char *filename);

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

ChmProject *ChmProject_Create(void)
{
	ChmProject *project;
	
	project = g_new0(ChmProject, 1);
	if (project == NULL)
		return NULL;
	
	ChmProject_Init(project);
	
	return project;
}

/*** ---------------------------------------------------------------------- ***/

void ChmProject_Destroy(ChmProject *project)
{
	if (project == NULL)
		return;
	ChmProject_Clear(project);
	g_free(project);
}
