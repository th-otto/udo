#include "chmtools.h"
#include "chmproject.h"
#include "chmxml.h"
#include "fasthtmlparser.h"
#include "htmlutil.h"
#include <libxml/HTMLparser.h>
#include <libxml/tree.h>

#define CREATOR "CHM"

typedef struct _ChmContextNode {
	int fileindex;			/* index into the project->files list */
	char *number;			/* mapping definition */
	gboolean number_valid;
	HelpContext number_value;
	char *contextname;		/* title or alias name */
	int context_defined_in;	/* index into the project->otherfiles list */
	int number_defined_in;	/* index into the project->otherfiles list */
} ChmContextNode;

static char const sec_options[] = "OPTIONS";
static char const xml_options[] = "param";

#define inProject  (1 << 0)
#define inSettings (1 << 1)
#define inWindows  (1 << 2)
#define inFiles    (1 << 3)
#define inOther    (1 << 4)
#define inAlias    (1 << 5)
#define inMerge    (1 << 6)
#define inParam (inSettings|inWindows|inFiles|inOther|inAlias|inMerge)

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
	node->number = NULL;
	node->number_valid = FALSE;
	node->number_value = 0;
	node->context_defined_in = -1;
	node->number_defined_in = -1;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static void ChmContextNode_Destroy(ChmContextNode *node)
{
	if (node == NULL)
		return;
	g_free(node->number);
	g_free(node->contextname);
	g_free(node);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean FileInTotalList(ChmProject *project, char *s)
{
	StringIndex SpareString;
	SpareString.TheString = s;
	SpareString.StrId = 0;
	return AVLTree_Find(project->TotalFileList, &SpareString) != NULL;
}

/*** ---------------------------------------------------------------------- ***/

static char *findattribute(xmlNode *node, const char *attributename)
{
	xmlAttr *attr;
	
	if (node)
	{
		for (attr = node->properties; attr; attr = attr->next)
		{
			if (g_ascii_strcasecmp(attributename, (const char *)attr->name) == 0)
			{
				return attr->children ? (char *)attr->children->content : NULL;
			}
		}
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

static int anchorlist_indexof(GSList *list, const char *name)
{
	GSList *l;
	int index;
	
	for (l = list, index = 0; l != NULL; l = l->next, index++)
		if (g_ascii_strcasecmp((const char *)l->data, name) == 0)
			return index;
	return -1;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean sanitizeurl(ChmProject *project, const char *instring, const char *localpath, const char *localname, char **outstring)
{
	char *p;
	char *anchor;
	int j;
	
	*outstring = NULL;
	if (empty(instring))
		return FALSE;
	/* Check for protocols before adding local path */
	if (g_ascii_strncasecmp(instring, "http:", 5) == 0)
		return FALSE;
	if (g_ascii_strncasecmp(instring, "https:", 6) == 0)
		return FALSE;
	if (g_ascii_strncasecmp(instring, "ftp:", 4) == 0)
		return FALSE;
	if (g_ascii_strncasecmp(instring, "ms-its:", 7) == 0)
		return FALSE;
	if (g_ascii_strncasecmp(instring, "mk:@MSITStore:", 14) == 0)
		return FALSE;
	if (g_ascii_strncasecmp(instring, "mailto:", 7) == 0)
		return FALSE;
	
	*outstring = g_strconcat(localpath, instring, NULL);
	p = strchr(*outstring, '#');
	
	if (p != NULL)
	{
		if (p > *outstring)
			anchor = g_strdup(*outstring);
		else
			anchor = g_strconcat(localname, outstring, NULL);
		project->onerror(project, chmnote, _("Anchor found %s while scanning %s"), anchor, localname);
		j = anchorlist_indexof(project->anchorlist, anchor);
		if (j < 0)
		{
			project->anchorlist = g_slist_append(project->anchorlist, anchor);
			anchor = NULL;
		}
		*p = '\0';
		g_free(anchor);
	}

	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static void checkattributes(ChmProject *project, xmlNode *node, const char *attributename, const char *localpath, const char *localname, GSList **filelist)
{
	char *fn;
	char *val;
	
	val = findattribute(node, attributename);
	if (sanitizeurl(project, val, localpath, localname, &fn))
	{
		/* Skip links to self using named anchors */
		if (!empty(fn) && !FileInTotalList(project, fn))
		{
			*filelist = g_slist_append(*filelist, fn);
			fn = NULL;
		}
	}
	g_free(fn);
}

/*** ---------------------------------------------------------------------- ***/

/* Seach first matching tag in siblings */
static void scantags(ChmProject *project, xmlNode *parent, const char *localpath, const char *localname, GSList **filelist)
{
	xmlNode *child;
	char *s;
	char *anchor;
	int i;
	
	if (parent)
	{
		for (child = parent; child; child = child->next)
		{
			scantags(project, child->children, localpath, localname, filelist);	/* depth first. */
			if (child->type == XML_ELEMENT_NODE)
			{
				if (g_ascii_strcasecmp((const char *)child->name, "link") == 0)
				{
					checkattributes(project, child, "href", localpath, localname, filelist);
				}
				if (g_ascii_strcasecmp((const char *)child->name, "img") == 0)
				{
					checkattributes(project, child, "src", localpath, localname, filelist);
				}
				if (g_ascii_strcasecmp((const char *)child->name, "A") == 0)
				{
					checkattributes(project, child, "href", localpath, localname, filelist);
					s = findattribute(child, "name");
					if (!empty(s))
					{
						anchor = g_strconcat(localname, "#", s, NULL);
						i = anchorlist_indexof(project->anchorlist, anchor);
						if (i < 0)
						{
							project->anchorlist = g_slist_append(project->anchorlist, anchor);
							project->onerror(project, chmnote, _("New Anchor with name %s found while scanning %s"), s, localname);
							anchor = NULL;
						} else
						{
							project->onerror(project, chmwarning, _("Duplicate anchor definitions with name %s found while scanning %s"), s, localname);
						}
						g_free(anchor);
					}
				}
			}
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

static void scanitems(ChmProject *project, ChmSiteMapItems *it, GSList **newfiles)
{
	GSList *l;
	ChmSiteMapItem *x;
	char *s;
	StringIndex *strrec;
	struct stat st;
	
	if (it == NULL)
		return;
	for (l = it->list; l != NULL; l = l->next)
	{
		x = (ChmSiteMapItem *)l->data;
		/* sanitize, remove stuff etc. */
		if (sanitizeurl(project, x->local, "", x->name, &s))
		{
			if (!FileInTotalList(project, s))
			{
				char *path = g_build_filename(project->basepath, s, NULL);
				if (stat(path, &st) == 0)
				{
					strrec = StringIndex_Create();
					strrec->TheString = s;
					AVLTree_Add(project->TotalFileList, strrec);
					*newfiles = g_slist_append(*newfiles, g_strdup(s));
					s = NULL;
				} else
				{
					project->onerror(project, chmnote, _("File %s does not exist"), s);
				}
				g_free(path);
			} else
			{
				project->onerror(project, chmnote, _("duplicate url: %s"), s);
			}
		} else
		{
			project->onerror(project, chmnote, _("Bad url: %s"), s);
		}
		g_free(s);
		
		scanitems(project, x->children, newfiles);
	}
}

/*** ---------------------------------------------------------------------- ***/

static void AddStrings(GSList **list, GSList *strings)
{
	GSList *l;
	
	for (l = strings; l; l = l->next)
		*list = g_slist_append(*list, g_strdup((const char *)l->data));
}

/*** ---------------------------------------------------------------------- ***/

static gboolean trypath(ChmProject *project, char *vn, const char *fn, GSList **newfiles)
{
	StringIndex *strrec;
	char *path;
	gboolean result;
	struct stat st;
	
	if (FileInTotalList(project, vn))
	{
		project->onerror(project, chmnote, _("Found duplicate file %s while scanning %s"), vn, fn);
		return TRUE;
	}

	result = FALSE;
	path = g_build_filename(project->basepath, vn, NULL);
	if (stat(path, &st) == 0)
	{
		result = TRUE;
		strrec = StringIndex_Create();
		strrec->TheString = g_strdup(vn);
		strrec->StrId = 0;
		AVLTree_Add(project->TotalFileList, strrec);
		*newfiles = g_slist_append(*newfiles, g_strdup(vn));
		CHM_DEBUG_LOG(0, "Found file %s while scanning %s\n", vn, fn);
	}
	g_free(path);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean is_allowed_extension(ChmProject *project, const char *name)
{
	GSList *l;
	const char *ext;
	
	ext = strrchr(name, '.');
	if (ext == NULL)
		return FALSE;
	for (l = project->allowed_extensions; l != NULL; l = l->next)
		if (g_ascii_strcasecmp((const char *)l->data, ext) == 0)
			return TRUE;
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

static char *extractfilepath(const char *filename)
{
	const char *base;

	base = chm_basename(filename);
	if (base == filename)
		return g_strdup(".");
	return g_strndup(filename, base - filename);
}

/*** ---------------------------------------------------------------------- ***/

/* toscan, list to search for htmlfiles to scan. */
/* newfiles, the resulting list of files. */
/* totalfilelist, the list that contains all found and specified files to check against. */
/* localfilelist (local var), files found in this file. */
static void scanlist(ChmProject *project, GSList *toscan, GSList **newfiles, gboolean recursion)
{
	GSList *localfilelist;
	htmlDocPtr doc;
	char *fn, *s;
	char *localpath;
	GSList *l, *local;
	char *path;
	struct stat st;
	
	localfilelist = NULL;
	for (l = toscan; l; l = l->next)
	{
		fn = (char *)l->data;
		g_slist_free_full(localfilelist, g_free);
		localfilelist = NULL;
		if (is_allowed_extension(project, fn))
		{
			path = g_build_filename(project->basepath, fn, NULL);
			if (stat(path, &st) == 0)
			{
				project->onerror(project, chmnote, _("Scanning file %s"), fn);
				doc = htmlParseFile(path, NULL);
				if (doc != NULL)
				{
					localpath = extractfilepath(fn);
					if (strcmp(localpath, ".") == 0)
						*localpath = '\0';
					scantags(project, doc->children, localpath, chm_basename(fn), &localfilelist);
					for (local = localfilelist; local; local = local->next)
					{
						s = (char *)local->data;
						if (!trypath(project, s, fn, newfiles))
							/* if (!trypath(project, localpath+s, fn, newfiles)) */
								project->onerror(project, chmwarning, _("Found file %s while scanning %s, but couldn't find it on disk"), s, fn);
					}
					g_free(localpath);
					xmlFreeDoc(doc);
				} else
				{
					project->onerror(project, chmerror, _("Html parsing %s, failed"), fn);
				}
			} else
			{
				project->onerror(project, chmnote, _("Can't find file %s to scan."), fn);
			}
			g_free(path);
		} else
		{
			project->onerror(project, chmnote, _("Not scanning file %s because of unknown extension"), fn);
		}
	}

	g_slist_free_full(localfilelist, g_free);
	localfilelist = NULL;
	if (*newfiles != NULL && recursion)
	{
		scanlist(project, *newfiles, &localfilelist, TRUE);
		AddStrings(newfiles, localfilelist);
		g_slist_free_full(localfilelist, g_free);
	}
}

/*** ---------------------------------------------------------------------- ***/

static void ChmProject_ScanSitemap(ChmProject *project, ChmSiteMap *sitemap, GSList **newfiles, gboolean recursion)
{
	GSList *localfilelist;
	
	localfilelist = NULL;
	scanitems(project, sitemap->items, newfiles);
	scanlist(project, *newfiles, &localfilelist, recursion);
	AddStrings(newfiles, localfilelist);
	g_slist_free_full(localfilelist, g_free);
}

/*** ---------------------------------------------------------------------- ***/

static void ChmProject_ScanHtml(ChmProject *project)
{
	GSList *helplist;
	GSList *localfilelist;
	GSList *l;
	StringIndex *strrec;

	for (l = project->otherfiles; l; l = l->next)
	{
		strrec = StringIndex_Create();
		strrec->TheString = g_strdup((const char *)l->data);
		strrec->StrId = 0;
		AVLTree_Add(project->TotalFileList, strrec);
	}

	for (l = project->files; l; l = l->next)
	{
		strrec = StringIndex_Create();
		strrec->TheString = g_strdup((const char *)l->data);
		strrec->StrId = 0;
		AVLTree_Add(project->TotalFileList, strrec);
	}

	localfilelist = NULL;
	scanlist(project, project->files, &localfilelist, TRUE);
	AddStrings(&project->otherfiles, localfilelist);
	g_slist_free_full(localfilelist, g_free);
	localfilelist = NULL;
	if (!empty(project->default_page) && !FileInTotalList(project, project->default_page))
	{
		project->onerror(project, chmnote, _("Scanning default file : %s"), project->default_page);
		helplist = NULL;
		helplist = g_slist_append(helplist, project->default_page);
		scanlist(project, helplist, &localfilelist, TRUE);
		AddStrings(&project->otherfiles, localfilelist);
		g_slist_free_full(localfilelist, g_free);
		localfilelist = NULL;
		g_slist_free(helplist);
	}
	if (project->toc)
	{
		project->onerror(project, chmnote, _("Scanning TOC file : %s"), project->toc_filename);
		ChmProject_ScanSitemap(project, project->toc, &localfilelist, TRUE);
		AddStrings(&project->otherfiles, localfilelist);
		g_slist_free_full(localfilelist, g_free);
		localfilelist = NULL;
	}
	if (project->index)
	{
		project->onerror(project, chmnote, _("Scanning Index file : %s"), project->index_filename);
		ChmProject_ScanSitemap(project, project->index, &localfilelist, TRUE);
		AddStrings(&project->otherfiles, localfilelist);
		g_slist_free_full(localfilelist, g_free);
		localfilelist = NULL;
	}
}

/*** ---------------------------------------------------------------------- ***/

static ChmMemoryStream *loadfile(const char *filename)
{
	ChmStream *stream;
	chm_off_t size;
	ChmStream *mem;
	unsigned char *buffer;
	
	stream = ChmStream_Open(filename, TRUE);
	if (stream == NULL)
	{
		return NULL;
	}
	size = ChmStream_Size(stream);
	mem = ChmStream_CreateMem(size);
	if (mem == NULL ||
		(buffer = ChmStream_Memptr(mem)) == NULL ||
		ChmStream_Read(stream, buffer, size) != size)
	{
		ChmStream_Close(mem);
		ChmStream_Close(stream);
		return NULL;
	}
	ChmStream_Close(stream);
	buffer[size] = '\0';
	return mem;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmProject_GetData(void *obj, const char *dataname, ChmMemoryStream **stream)
{
	ChmProject *project = (ChmProject *)obj;
	char *filename = g_build_filename(project->basepath, dataname, NULL);
	*stream = loadfile(filename);
	if (project->OnProgress)
		project->OnProgress(project, dataname);
	g_free(filename);
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

/* #IDXHDR (merged files) goes into the system file, and need to keep TOC sitemap around */
static void ChmProject_LoadSiteMaps(ChmProject *project)
{
	char *path;
	
	if (!empty(project->toc_filename))
	{
		path = g_build_filename(project->basepath, project->toc_filename, NULL);
		ChmStream_Close(project->tocstream);
		project->tocstream = NULL;
		ChmSiteMap_Destroy(project->toc);
		project->toc = NULL;
		if ((project->tocstream = loadfile(path)) == NULL ||
			(project->toc = ChmSiteMap_Create(stTOC)) == NULL ||
			ChmSiteMap_LoadFromStream(project->toc, project->tocstream) == FALSE)
		{
			ChmStream_Close(project->tocstream);
			project->tocstream = NULL;
			ChmSiteMap_Destroy(project->toc);
			project->toc = NULL;
			project->onerror(project, chmerror, _("Error loading TOC file %s"), project->toc_filename);
		}
		g_free(path);
	}

	if (!empty(project->index_filename))
	{
		path = g_build_filename(project->basepath, project->index_filename, NULL);
		ChmStream_Close(project->indexstream);
		project->indexstream = NULL;
		ChmSiteMap_Destroy(project->index);
		project->index = NULL;
		if ((project->indexstream = loadfile(path)) == NULL ||
			(project->index = ChmSiteMap_Create(stIndex)) == NULL ||
			ChmSiteMap_LoadFromStream(project->index, project->indexstream) == FALSE)
		{
			ChmStream_Close(project->indexstream);
			project->indexstream = NULL;
			ChmSiteMap_Destroy(project->index);
			project->index = NULL;
			project->onerror(project, chmerror, _("Error loading Index file %s"), project->index_filename);
		}
		g_free(path);
	}
}

/*** ---------------------------------------------------------------------- ***/

static void ChmProject_LastFileAdded(void *obj, void *sender)
{
	ChmProject *project = (ChmProject *)obj;
	ChmWriter *chm = (ChmWriter *)sender;

	/* Assign the TOC and index files */
	if (project->indexstream)
	{
		if (ChmStream_Seek(project->indexstream, 0) == FALSE)
			{}
		ChmWriter_AppendIndex(chm, project->indexstream);
		if (project->MakeBinaryIndex)
		{
			ChmWriter_AppendBinaryIndexFromSiteMap(chm, project->index, FALSE);
		}
	}
	if (project->tocstream)
	{
		ChmWriter_AppendTOC(chm, project->tocstream);
		if (project->MakeBinaryTOC)
		{
			ChmWriter_AppendBinaryTOCFromSiteMap(chm, project->toc);
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmProject_WriteChm(ChmProject *project, ChmStream *out)
{
	ChmWriter *Writer;
	GSList *l;
	
	ChmProject_LoadSiteMaps(project);

	/* Scan html for "rest" files. */
	if (project->ScanHtmlContents)
		ChmProject_ScanHtml(project); 								/* Since this is slowing we opt to skip this step, and only do this on html load. */

	Writer = ChmWriter_Create(out, FALSE);

	/* our callback to get data */
	Writer->itsf.OnGetFileData = ChmProject_GetData;
	Writer->itsf.OnLastFile = ChmProject_LastFileAdded;
	Writer->itsf.user_data = project;
	
	Writer->locale_id = project->locale_id;
	Writer->dbcs = project->dbcs;
	
	/* give it the list of html files */
	AddStrings(&Writer->itsf.FilesToCompress, project->files);

	/* give it the list of other files */

	AddStrings(&Writer->itsf.FilesToCompress, project->otherfiles);

	/* now some settings in the chm */
	Writer->default_page = g_strdup(project->default_page);
	Writer->title = g_strdup(project->title);
	Writer->default_font = g_strdup(project->default_font);
	Writer->FullTextSearch = project->full_text_search;
	Writer->HasBinaryTOC = project->MakeBinaryTOC;
	Writer->HasBinaryIndex = project->MakeBinaryIndex;
	Writer->index_filename = g_strdup(project->index_filename);
	Writer->toc_filename = g_strdup(project->toc_filename);
	Writer->itsf.ReadmeMessage = g_strdup(project->ReadmeMessage);
	Writer->default_window = g_strdup(project->default_window);
	for (l = project->files; l; l = l->next)
	{
		char *s = (char *)l->data;
		char *path = g_build_filename(project->basepath, s, NULL);
		struct stat st;
		
		if (stat(path, &st) != 0)
			project->onerror(project, chmwarning, _("File %s does not exist"), s);
		g_free(path);
	}
	for (l = project->alias; l; l = l->next)
	{
		const ChmContextNode *node = (const ChmContextNode *)l->data;
		char *s;
		if (node->fileindex >= 0 && (s = (char *)g_slist_nth_data(project->files, node->fileindex)) != NULL)
		{
			if (node->number_valid)
				ChmWriter_AddContext(Writer, node->number_value, s);
		}
	}
	ChmWriter_SetWindows(Writer, project->windows);
	ChmWriter_SetMergefiles(Writer, project->mergefiles);
	Writer->TocSitemap = project->toc;

	/* and write! */

	project->onerror(project, chmhint, _("Writing CHM %s"), project->out_filename);

	ChmWriter_Execute(Writer);

	ChmStream_Close(project->tocstream);
	project->tocstream = NULL;
	ChmSiteMap_Destroy(project->toc);
	project->toc = NULL;

	ChmStream_Close(project->indexstream);
	project->indexstream = NULL;
	ChmSiteMap_Destroy(project->index);
	project->index = NULL;

	ChmWriter_Destroy(Writer);
	
	return TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int compare_strings(const void *s1, const void *s2)
{
	const StringIndex *n1 = (const StringIndex *)s1;
	const StringIndex *n2 = (const StringIndex *)s2;
	return ChmCompareText(n1->TheString, n2->TheString);
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
	char *p2;
	
	if (empty(s))
		return s;
	p = strchr(s, ';');
	if (p)
		*p = '\0';
	p = strchr(s, '/');
	if (p)
	{
		if (p[1] == '/')
		{
			*p = '\0';
		} else if (p[1] == '*' && (p2 = strchr(p + 2, '*')) != NULL && p2[1] == '/')
		{
			memmove(p, p2 + 2, strlen(p2 + 2) + 1);
		}
	}
	return chomp(s);
}

/*** ---------------------------------------------------------------------- ***/

static char **loadfromfile(ChmProject *project, const char *filename)
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
		project->onerror(project, chmerror, "%s: %s", filename, strerror(errno));
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

static ChmContextNode *add_alias(ChmProject *project, char *key, char *contextname)
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
				project->onerror(project, chmwarning, _("redefinition of alias %s"), contextname);
				node->fileindex = fileindex;
				return node;
			}
		}
		node = ChmContextNode_Create(fileindex, contextname);
		project->alias = g_slist_append(project->alias, node);
		return node;
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

static void processalias(ChmProject *project, char **strs, int defined_in)
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
					int include_idx = add_unique(&project->otherfiles, s);
					strs2 = loadfromfile(project, path);
					processalias(project, strs2, include_idx);
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
				ChmContextNode *node;
				
				*p++ = '\0';
				if (*p == '"' && p[strlen(p) - 1] == '"')
				{
					p[strlen(p) - 1] = '\0';
					*p++ = '\0';
				}
				node = add_alias(project, p, s);
				if (node)
					node->context_defined_in = defined_in;
			}
		}
		g_free(s);
	}
}

/*** ---------------------------------------------------------------------- ***/

static ChmContextNode *add_map(ChmProject *project, char *number, char *contextname)
{
	ChmContextNode *node;
	GSList *l;
	char *p;
	
	chomp(number);
	chomp(contextname);
	if (empty(contextname) || empty(number))
		return NULL;
	p = strchr(number, ' ');
	if (p)
		*p = '\0';
	p = strchr(number, '\t');
	if (p)
		*p = '\0';
	for (l = project->alias; l != NULL; l = l->next)
	{
		node = (ChmContextNode *)l->data;
		if (node->contextname != NULL && strcmp(node->contextname, contextname) == 0)
		{
			if (node->number_valid)
			{
				project->onerror(project, chmwarning, _("redefinition of mapping %s"), contextname);
			}
			g_free(node->number);
			node->number = g_strdup(number);
			node->number_value = (HelpContext)strtol(number, NULL, 0);
			node->number_valid = TRUE;
			return node;
		}
	}
	project->onerror(project, chmwarning, _("alias for %s was not defined"), contextname);
	node = ChmContextNode_Create(-1, contextname);
	node->number = g_strdup(number);
	node->number_value = (HelpContext)strtol(number, NULL, 0);
	node->number_valid = TRUE;
	project->alias = g_slist_append(project->alias, node);
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static void processmap(ChmProject *project, char **strs, int defined_in)
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
					int include_idx = add_unique(&project->otherfiles, s);
					strs2 = loadfromfile(project, path);
					processmap(project, strs2, include_idx);
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
				ChmContextNode *node;
				
				*p++ = '\0';
				node = add_map(project, p, s);
				if (node)
					node->number_defined_in = defined_in;
			}
		} else
		{
			project->onerror(project, chmnote, _("unrecognized entry in [MAP]: %s"), s);
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
	g_slist_free_full(project->otherfiles, g_free);
	project->otherfiles = NULL;
	g_freep(&project->index_filename);
	g_freep(&project->hhp_filename);
	g_freep(&project->xml_filename);
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
	g_freep(&project->fts_stop_list_filename);
}

/*** ---------------------------------------------------------------------- ***/

static void ChmProject_Init(ChmProject *project)
{
	project->allowed_extensions = g_slist_append(project->allowed_extensions, g_strdup(".htm"));
	project->allowed_extensions = g_slist_append(project->allowed_extensions, g_strdup(".html"));
	project->TotalFileList = AVLTree_Create(compare_strings, (GDestroyNotify)StringIndex_Destroy);
	project->AutoFollowLinks = FALSE;
	project->auto_index = FALSE;
	project->auto_toc = 0;
	project->compatibility = FALSE;
	project->MakeBinaryTOC = FALSE;
	project->MakeBinaryIndex = TRUE;
	project->full_text_search = FALSE;
	project->display_compile_progress = FALSE;
	project->display_compile_notes = FALSE;
	project->enhanced_decompilation = FALSE;
	project->flat = TRUE;
	project->locale_id = MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US);
	project->ScanHtmlContents = TRUE;
	project->compress = 0;
	project->create_chi_file = FALSE;
	project->dbcs = FALSE;
}

/*** ---------------------------------------------------------------------- ***/

static void check_mappings(ChmProject *project)
{
	GSList *l;
	const ChmContextNode *node;
	
	for (l = project->alias; l; l = l->next)
	{
		node = (const ChmContextNode *)l->data;
		if (!node->number_valid)
			project->onerror(project, chmwarning, _("no mapping defined for %s"), node->contextname);
	}
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
	/* "[" int,int,int,int "]", |, */
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
	char *str;
	unsigned int id;
	
	if ((profile = Profile_Load(filename, CREATOR)) == NULL)
	{
		project->onerror(project, chmerror, "%s: %s", filename, strerror(errno));
		return FALSE;
	}
	
	ChmProject_Clear(project);
	ChmProject_Init(project);
	
	project->hhp_filename = g_strdup(filename);
	project->xml_filename = changefileext(filename, ".xml");
			
	project->basepath = extractfilepath(filename);
	
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
	strs = Profile_GetSection(profile, "ALIAS");
	processalias(project, strs, -1);
	g_strfreev(strs);
	
	/* map files only add to existing file nodes. */
	strs = Profile_GetSection(profile, "MAP");
	processmap(project, strs, -1);
	g_strfreev(strs);
	
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
	project->locale_id = id;
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
	Profile_ReadString(profile, sec_options, "Full text search stop list file", &project->fts_stop_list_filename);
	Profile_ReadBool(profile, sec_options, "Full-text search", &project->full_text_search);
	Profile_ReadString(profile, sec_options, "Sample Staging Path", &project->sample_staging_path);
	Profile_ReadString(profile, sec_options, "Sample list file", &project->sample_list_file);
	Profile_ReadString(profile, sec_options, "Custom tab", &project->custom_tab);
	Profile_ReadString(profile, sec_options, "CITATION", &project->citation);
	Profile_ReadString(profile, sec_options, "COPYRIGHT", &project->copyright);
	Profile_ReadInt(profile, sec_options, "COMPRESS", &project->compress);
	
	/* IGNORED: TMPDIR */
	/* NYI: PREFIX */
	
	/* TODO: [TEXT POPUPS] */
	/* TODO: [INFOTYPES] */
	/* TODO: [SUBSETS] */
	
	Profile_Delete(profile);
	
	if (project->out_filename == NULL)
		project->out_filename = changefileext(chm_basename(filename), ".chm");
	check_mappings(project);
	
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
	Profile_WriteCard(profile, sec_options, "Language", project->locale_id);
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
	Profile_WriteString(profile, sec_options, "Full text search stop list file", project->fts_stop_list_filename);
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
	
	if (project->alias)
	{
		GSList *l;
		const ChmContextNode *node;
		const char *s;
		int nother = g_slist_length(project->otherfiles);
		const char **othernames = g_new0(const char *, nother);
		char *alias = g_strdup("");
		char *map = g_strdup("");
		char *tmp1, *tmp2;
		const char *other;
		
		for (l = project->alias; l; l = l->next)
		{
			node = (const ChmContextNode *)l->data;
			if (node->fileindex >= 0 && (s = (char *)g_slist_nth_data(project->files, node->fileindex)) != NULL)
			{
				if (node->context_defined_in >= 0)
				{
					assert(node->context_defined_in < nother);
					if (othernames[node->context_defined_in] == NULL)
					{
						other = (const char *)g_slist_nth_data(project->otherfiles, node->context_defined_in);
						othernames[node->context_defined_in] = other;
						tmp1 = g_strdup_printf("#include \"%s\"\n", other);
						tmp2 = g_strconcat(alias, tmp1, NULL);
						g_free(alias);
						alias = tmp2;
						g_free(tmp1);
					}
				} else
				{
					other = (const char *)g_slist_nth_data(project->files, node->fileindex);
					assert(other != NULL);
					tmp1 = g_strdup_printf("%s=%s\n", node->contextname, other);
					tmp2 = g_strconcat(alias, tmp1, NULL);
					g_free(alias);
					alias = tmp2;
					g_free(tmp1);
				}

				if (node->number_defined_in >= 0)
				{
					assert(node->number_defined_in < nother);
					if (othernames[node->number_defined_in] == NULL)
					{
						other = (const char *)g_slist_nth_data(project->otherfiles, node->number_defined_in);
						othernames[node->number_defined_in] = other;
						tmp1 = g_strdup_printf("#include \"%s\"\n", other);
						tmp2 = g_strconcat(map, tmp1, NULL);
						g_free(map);
						map = tmp2;
						g_free(tmp1);
					}
				} else
				{
					other = (const char *)g_slist_nth_data(project->files, node->fileindex);
					assert(other != NULL);
					tmp1 = g_strdup_printf("#define %s %s\n", node->contextname, fixnull(node->number));
					tmp2 = g_strconcat(map, tmp1, NULL);
					g_free(map);
					map = tmp2;
					g_free(tmp1);
				}
			}
		}		
		if (alias)
			Profile_SetSection(profile, "ALIAS", alias);
		if (map)
			Profile_SetSection(profile, "MAP", map);
		g_free(alias);
		g_free(map);
		g_free(othernames);
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
		fprintf(out, " win_properties=\"0x%x\"", win->win_properties);
	if (win->flags & HHWIN_PARAM_NAV_WIDTH)
		fprintf(out, " navpanewidth=\"%d\"", win->navpanewidth);
	if (win->flags & HHWIN_PARAM_TB_FLAGS)
		fprintf(out, " buttons=\"0x%x\"", win->buttons);
	if (win->flags & HHWIN_PARAM_RECT)
	{
		fprintf(out, " left=\"%d\"", win->pos.left);
		fprintf(out, " top=\"%d\"", win->pos.top);
		fprintf(out, " right=\"%d\"", win->pos.right);
		fprintf(out, " bottom=\"%d\"", win->pos.bottom);
	}
	if (win->flags & HHWIN_PARAM_STYLES)
		fprintf(out, " styleflags=\"0x%x\"", win->styleflags);
	if (win->flags & HHWIN_PARAM_EXSTYLES)
		fprintf(out, " xtdstyleflags=\"0x%x\"", win->xtdstyleflags);
	if (win->flags & HHWIN_PARAM_SHOWSTATE)
		fprintf(out, " show_state=\"%d\"", win->show_state);
	if (win->flags & HHWIN_PARAM_EXPANSION)
		fprintf(out, " not_expanded=\"%d\"", win->not_expanded);
	if (win->flags & HHWIN_PARAM_CUR_TAB)
		fprintf(out, " navtype=\"%d\"", win->navtype);
	if (win->flags & HHWIN_PARAM_TABPOS)
		fprintf(out, " tabpos=\"%d\"", win->tabpos);
	if (win->flags & HHWIN_PARAM_NOTIFY_ID)
		fprintf(out, " wm_notify_id=\"%d\"", win->wm_notify_id);
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
	xml_write_card(fp, xml_options, "Language", project->locale_id);
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
	xml_write_bool(fp, xml_options, "CreateCHIFile", project->create_chi_file);
	xml_write_bool(fp, xml_options, "DBCS", project->dbcs);
	xml_write_bool(fp, xml_options, "DisplayCompileNotes", project->display_compile_notes);
	xml_write_bool(fp, xml_options, "DisplayCompileProgress", project->display_compile_progress);
	xml_write_bool(fp, xml_options, "EnhancedDecompilation", project->enhanced_decompilation);
	xml_write_bool(fp, xml_options, "Flat", project->flat);
	xml_write_str(fp, xml_options, "StoplistFilename", project->fts_stop_list_filename);
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
		const char *other;
		
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
			if (node->number_valid && node->number)
			{
				s = xml_quote(node->number);
				fprintf(fp, " id=%s", s);
				g_free(s);
			}
			if (node->context_defined_in >= 0 &&
				(other = (const char *)g_slist_nth_data(project->otherfiles, node->context_defined_in)) != NULL)
			{
				s = xml_quote(other);
				fprintf(fp, " aliasinclude=%s", s);
				g_free(s);
			}
			if (node->number_defined_in >= 0 &&
				(other = (const char *)g_slist_nth_data(project->otherfiles, node->number_defined_in)) != NULL)
			{
				s = xml_quote(other);
				fprintf(fp, " mapinclude=%s", s);
				g_free(s);
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

typedef struct {
	unsigned int tags;
	ChmProject *project;
	gboolean valid;
} XmlProjectState;


static gboolean xml_bool_val(const char *str)
{
	gboolean val;
	int x;
	
	if (g_ascii_strcasecmp(str, "true") == 0)
		val = TRUE;
	else if (g_ascii_strcasecmp(str, "false") == 0)
		val = FALSE;
	else if (g_ascii_strcasecmp(str, "on") == 0)
		val = TRUE;
	else if (g_ascii_strcasecmp(str, "off") == 0)
		val = FALSE;
	else if (g_ascii_strcasecmp(str, "yes") == 0)
		val = TRUE;
	else if (g_ascii_strcasecmp(str, "no") == 0)
		val = FALSE;
	else if (g_ascii_strcasecmp(str, "undef") == 0)
		val = -1;
	else
	{
		CHM_DEBUG_LOG(0, "must be boolean, not %s.\n", str);
		x = (int)strtol(str, NULL, 10);
		val = x == -1 ? -1 : x != 0;
	}
	return val;
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

static void ChmWindow_LoadFromXml(ChmWindow *win, const char *name, const char *tag, size_t taglen)
{
	if (win == NULL || empty(name))
		return;
	ChmWindow_Clear(win);
	if (tag == NULL || taglen == 0)
		return;
	win->strings_alloced = TRUE;
	win->flags = 0;
	win->window_name.s = g_strdup(name);
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

static gboolean FoundTag(void *obj, const char *tag, size_t taglen)
{
	XmlProjectState *state = (XmlProjectState *)obj;
	char *TagName;
	
	TagName = GetTagName(tag, taglen);
	if (TagName == NULL)
		return FALSE;

	if (!(state->tags & inProject))
	{
		if (g_ascii_strcasecmp(TagName, "ProjectFile") == 0)
		{
			state->tags |= inProject;
			state->valid = TRUE;
		}
	} else
	{
		if (g_ascii_strcasecmp(TagName, "/ProjectFile") == 0)
			state->tags &= ~inProject;
	}
	
	if (state->tags & inProject)
	{
		ChmProject *project = state->project;

		if (g_ascii_strcasecmp(TagName, "Settings") == 0)
		{
			state->tags |= inSettings;
		} else if (g_ascii_strcasecmp(TagName, "/Settings") == 0)
		{
			state->tags &= ~inParam;
		} else if (g_ascii_strcasecmp(TagName, "Windows") == 0)
		{
			state->tags |= inWindows;
		} else if (g_ascii_strcasecmp(TagName, "/Windows") == 0)
		{
			state->tags &= ~inParam;
		} else if (g_ascii_strcasecmp(TagName, "Files") == 0)
		{
			state->tags |= inFiles;
		} else if (g_ascii_strcasecmp(TagName, "/Files") == 0)
		{
			state->tags &= ~inParam;
		} else if (g_ascii_strcasecmp(TagName, "OtherFiles") == 0)
		{
			state->tags |= inOther;
		} else if (g_ascii_strcasecmp(TagName, "/OtherFiles") == 0)
		{
			state->tags &= ~inParam;
		} else if (g_ascii_strcasecmp(TagName, "Alias") == 0)
		{
			state->tags |= inAlias;
		} else if (g_ascii_strcasecmp(TagName, "/Alias") == 0)
		{
			state->tags &= ~inParam;
		} else if (g_ascii_strcasecmp(TagName, "MergeFiles") == 0)
		{
			state->tags |= inMerge;
		} else if (g_ascii_strcasecmp(TagName, "/MergeFile") == 0)
		{
			state->tags &= ~inParam;
		} else
		{
			project->onerror(project, chmnote, _("unknown tag %s in project file"), TagName);
		}
		if ((state->tags & inParam) && g_ascii_strcasecmp(TagName, "PARAM") == 0)
		{
			char *name = GetVal(tag, taglen, "name");
			char *value = GetVal(tag, taglen, "value");
			
			if (!empty(name))
			{
				if ((state->tags & inSettings) && value)
				{
					if (g_ascii_strcasecmp(name, "Title") == 0)
					{
						project->title = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "DefaultTopic") == 0)
					{
						project->default_page = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "DefaultWindow") == 0)
					{
						project->default_window = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "DefaultFont") == 0)
					{
						project->default_font = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "Language") == 0)
					{
						project->locale_id = (LCID)strtoul(value, NULL, 0);
					} else if (g_ascii_strcasecmp(name, "AutoIndex") == 0)
					{
						project->auto_index = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "AutoTOC") == 0)
					{
						project->auto_toc = (int)strtol(value, NULL, 0);
					} else if (g_ascii_strcasecmp(name, "BinaryIndex") == 0)
					{
						project->MakeBinaryIndex = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "BinaryTOC") == 0)
					{
						project->MakeBinaryTOC = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "OutputFilename") == 0)
					{
						project->out_filename = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "TOCFilename") == 0)
					{
						project->toc_filename = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "IndexFilename") == 0)
					{
						project->index_filename = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "ErrorlogFilename") == 0)
					{
						project->error_log_file = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "Compatibility") == 0)
					{
						project->compatibility = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "CreateCHIFile") == 0)
					{
						project->create_chi_file = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "DBCS") == 0)
					{
						project->dbcs = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "DisplayCompileNotes") == 0)
					{
						project->display_compile_notes = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "DisplayCompileProgress") == 0)
					{
						project->display_compile_progress = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "EnhancedDecompilation") == 0)
					{
						project->enhanced_decompilation = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "Flat") == 0)
					{
						project->flat = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "StoplistFilename") == 0)
					{
						project->fts_stop_list_filename = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "FullTextSearch") == 0)
					{
						project->full_text_search = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "SampleStagingPath") == 0)
					{
						project->sample_staging_path = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "SampleListFile") == 0)
					{
						project->sample_list_file = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "CustomTabs") == 0)
					{
						project->custom_tab = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "Citation") == 0)
					{
						project->citation = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "Copyright") == 0)
					{
						project->copyright = value;
						value = NULL;
					} else if (g_ascii_strcasecmp(name, "AutoFollowLinks") == 0)
					{
						project->AutoFollowLinks = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "ScanHtmlContents") == 0)
					{
						project->ScanHtmlContents = xml_bool_val(value);
					} else if (g_ascii_strcasecmp(name, "Compress") == 0)
					{
						project->compress = (int)strtol(value, NULL, 0);
					} else
					{
						project->onerror(project, chmnote, _("unsupported setting %s"), name);
					}
				} else if (state->tags & inWindows)
				{
					ChmWindow *win;
					win = ChmWindow_Create();
					ChmWindow_LoadFromXml(win, name, tag, taglen);
					project->windows = g_slist_append(project->windows, win);
				} else if ((state->tags & inFiles) && value)
				{
					project->files = g_slist_append(project->files, value);
					value = NULL;
				} else if ((state->tags & inOther) && value)
				{
					project->otherfiles = g_slist_append(project->otherfiles, value);
					value = NULL;
				} else if ((state->tags & inMerge) && value)
				{
					project->mergefiles = g_slist_append(project->mergefiles, value);
					value = NULL;
				} else if ((state->tags & inAlias))
				{
					ChmContextNode *node;
					char *topic = GetVal(tag, taglen, "topic");
					char *other;
					int idx;
					
					node = add_alias(project, topic, name);
					if (node)
					{
						node->number = GetVal(tag, taglen, "id");
						if (node->number)
						{
							node->number_valid = TRUE;
							node->number_value = (HelpContext)strtol(node->number, NULL, 0);
						}
						other = GetVal(tag, taglen, "aliasinclude");
						if (other)
						{
							idx = add_unique(&project->otherfiles, other);
							node->context_defined_in = idx;
						}
						g_free(other);
						other = GetVal(tag, taglen, "mapinclude");
						if (other)
						{
							idx = add_unique(&project->otherfiles, other);
							node->number_defined_in = idx;
						}
						g_free(other);
					}
					
					g_free(topic);
				}
			}
			g_free(value);
			g_free(name);
		}
	}
	
	g_free(TagName);
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmProject_LoadFromXml(ChmProject *project, const char *filename)
{
	ChmStream *stream;
	gboolean result = FALSE;
	HTMLParser *htmlparser;
	XmlProjectState state;
	
	stream = loadfile(filename);
	if (stream == NULL)
	{
		project->onerror(project, chmerror, "%s: %s", filename, strerror(errno));
		return FALSE;
	}
	htmlparser = HTMLParser_Create((const char *)ChmStream_Memptr(stream), ChmStream_Size(stream));
	if (htmlparser != NULL)
	{
		state.tags = 0;
		state.project = project;
		state.valid = FALSE;
		
		htmlparser->obj = &state;
		htmlparser->OnFoundTag = FoundTag;
		ChmProject_Clear(project);
		ChmProject_Init(project);
		project->xml_filename = g_strdup(filename);
		project->hhp_filename = changefileext(filename, ".hhp");
		project->basepath = extractfilepath(filename);
		HTMLParser_Exec(htmlparser);
		HTMLParser_Destroy(htmlparser);
		result = state.valid;
		if (!state.valid)
			project->onerror(project, chmerror, _("invalid file fomat"));
		if (project->out_filename == NULL)
			project->out_filename = changefileext(chm_basename(filename), ".chm");
		check_mappings(project);
	} else
	{
		project->onerror(project, chmerror, "%s: %s", filename, strerror(errno));
	}
	ChmStream_Close(stream);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

void ChmProject_ShowUndefinedAnchors(ChmProject *project)
{
	GSList *l;
	
	for (l = project->anchorlist; l; l = l->next)
	{
		char *name = (char *)l->data;
		/* NYI */
		UNUSED(name);
	}
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ChmProject_OnError(ChmProject *project, ChmProjectErrorKind errorkind, const char *msg, ...)
{
	va_list args;
	
	UNUSED(project);
	va_start(args, msg);
	if ((errorkind == chmhint && verbose >= 1) ||
		(errorkind == chmnote && verbose >= 1) ||
		(errorkind == chmerror) ||
		(errorkind == chmwarning))
	{
		switch (errorkind)
		{
			case chmerror: fputs(_("error: "), stderr); break;
			case chmwarning: fputs(_("warning: "), stderr); break;
			case chmnote: fputs(_("note: "), stderr); break;
			case chmhint: fputs(_("hint: "), stderr); break;
		}
		vfprintf(stderr, msg, args);
		fputc('\n', stderr);
	}
	va_end(args);
}

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
	project->onerror = ChmProject_OnError;
	
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
