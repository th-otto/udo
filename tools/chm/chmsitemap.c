#include "chmtools.h"
#include "chmreader.h"
#include "fasthtmlparser.h"
#include "htmlutil.h"
#include "chmxml.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

ChmSiteMapItem *ChmSiteMapItem_Create(ChmSiteMapItems *owner)
{
	ChmSiteMapItem *item;
	
	item = g_new0(ChmSiteMapItem, 1);
	if (item == NULL)
		return NULL;
	item->imagenumber = -1;
	item->owner = owner;
	item->children = ChmSiteMapItems_Create(owner->owner, item);
	return item;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSiteMapItem_Destroy(ChmSiteMapItem *self)
{
	if (self == NULL)
		return;
	ChmSiteMapItems_Destroy(self->children);
	g_free(self->comment);
	g_free(self->name);
	g_free(self->keyword);
	g_free(self->local);
	g_free(self->seealso);
	g_free(self->url);
	g_free(self->merge);
	g_free(self->framename);
	g_free(self->windowname);
	g_free(self);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

ChmSiteMapItems *ChmSiteMapItems_Create(ChmSiteMap *owner, ChmSiteMapItem *parentitem)
{
	ChmSiteMapItems *self;
	
	self = g_new0(ChmSiteMapItems, 1);
	if (self == NULL)
		return NULL;
	self->list = NULL;
	self->owner = owner;
	self->parentitem = parentitem;
	self->internaldata = 0xffffffff;
	return self;
}

/*** ---------------------------------------------------------------------- ***/

static void ChmSiteMapItems_Reset(ChmSiteMapItems *self)
{
	if (self == NULL)
		return;
	g_slist_free_full(self->list, (GDestroyNotify)ChmSiteMapItem_Destroy);
	self->list = NULL;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSiteMapItems_Destroy(ChmSiteMapItems *self)
{
	if (self == NULL)
		return;
	ChmSiteMapItems_Reset(self);
	g_free(self);
}

/*** ---------------------------------------------------------------------- ***/

static ChmSiteMapItem *ChmSiteMapItems_GetItem(ChmSiteMapItems *self, int index)
{
	return (ChmSiteMapItem *)g_slist_nth_data(self->list, index);
}

/*** ---------------------------------------------------------------------- ***/

static int ChmSiteMapItems_GetCount(ChmSiteMapItems *self)
{
	if (self == NULL)
		return 0; /* should not happen; maybe return -1? */
	return g_slist_length(self->list);
}

/*** ---------------------------------------------------------------------- ***/

void ChmSiteMapItems_Delete(ChmSiteMapItems *self, int index)
{
	GSList *l = g_slist_nth(self->list, index);
	ChmSiteMapItem *item = (ChmSiteMapItem *)l->data;
	ChmSiteMapItem_Destroy(item);
	self->list = g_slist_remove(self->list, item);
}

/*** ---------------------------------------------------------------------- ***/

int ChmSiteMapItems_Add(ChmSiteMapItems *self, ChmSiteMapItem *item)
{
	int index;
	
	if (item == NULL)
		return -1;
	index = g_slist_length(self->list);
	self->list = g_slist_append(self->list, item);
	return index;
}

/*** ---------------------------------------------------------------------- ***/

ChmSiteMapItem *ChmSiteMapItems_NewItem(ChmSiteMapItems *self)
{
	ChmSiteMapItem *item = ChmSiteMapItem_Create(self);
	ChmSiteMapItems_Add(self, item);
	return item;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSiteMapItems_Sort(ChmSiteMapItems *self, int (*compare)(const ChmSiteMapItem *item1, const ChmSiteMapItem *item2))
{
	self->list = g_slist_sort(self->list, (GCompareFunc)compare);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void ChmSiteMap_SetItems(ChmSiteMap *self, ChmSiteMapItems *items)
{
	if (self->items == items)
		return;
	ChmSiteMapItems_Destroy(self->items);
	self->items = items;
}

/*** ---------------------------------------------------------------------- ***/

static void ChmSiteMap_Reset(ChmSiteMap *self)
{
	if (self == NULL)
		return;
	g_freep(&self->windowname);
	g_freep(&self->framename);
	g_freep(&self->imagelist);
	g_freep(&self->font);
	self->background = 0;
	self->foreground = 0;
	self->colormask = 0;
	self->windowstyles = CHM_TOC_DEF_STYLES;
	self->exwindowstyles = 0;
	self->imagewidth = 0;
	self->usefolderimages = FALSE;
	self->currentitems = NULL;
	self->sitemaptags = smtNone;
	self->sitemapbodytags = smbtNone;
	self->level = 0;
	self->levelforced = FALSE;
	ChmSiteMapItems_Reset(self->items);
}

/*** ---------------------------------------------------------------------- ***/

ChmSiteMap *ChmSiteMap_Create(SiteMapType type)
{
	ChmSiteMap *self;
	
	self = g_new0(ChmSiteMap, 1);
	if (self == NULL)
		return NULL;
	self->sitemaptype = type;
	ChmSiteMap_Reset(self);
	self->items = ChmSiteMapItems_Create(self, NULL);
	return self;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSiteMap_Destroy(ChmSiteMap *self)
{
	if (self == NULL)
		return;
	ChmSiteMap_Reset(self);
	ChmSiteMapItems_Destroy(self->items);
	self->items = NULL;
	g_free(self);
}

/*** ---------------------------------------------------------------------- ***/

static ChmSiteMapItem *ActiveItem(ChmSiteMap *self)
{
	ChmSiteMapItem *item = ChmSiteMapItems_GetItem(self->currentitems, ChmSiteMapItems_GetCount(self->currentitems) - 1);
	assert(item);
	return item;
}

/*** ---------------------------------------------------------------------- ***/

static void IncreaseULevel(ChmSiteMap *self)
{
	if (self->currentitems == NULL)
	{
		self->currentitems = self->items;
	} else
	{
		self->currentitems = ActiveItem(self)->children;
	}
	++self->level;
}

/*** ---------------------------------------------------------------------- ***/

static void DecreaseULevel(ChmSiteMap *self)
{
	if (self->currentitems && self->currentitems->parentitem)
		self->currentitems = self->currentitems->parentitem->owner;
	else
		self->currentitems = NULL;
	--self->level;
}

/*** ---------------------------------------------------------------------- ***/

static void NewSiteMapItem(ChmSiteMap *self)
{
	ChmSiteMapItems_Add(self->currentitems, ChmSiteMapItem_Create(self->currentitems));
}

static void FoundTag(void *obj, const char *tag, size_t taglen)
{
	ChmSiteMap *self = (ChmSiteMap *)obj;
	char *TagName;
	
	TagName = GetUpTagName(tag, taglen);
	if (TagName == NULL)
		return;

#if 0
	if (!(self->sitemaptags & smtHTML))
	{
		if (strcmp(TagName, "HTML") == 0 || strcmp(TagName, "/HTML") == 0)
			self->sitemaptags |= smtHTML;
	} else
	{
		/* looking for /HTML */
		if (strcmp(TagName, "/HTML") == 0)
			self->sitemaptags &= ~smtHTML;
	}
#endif
	
	/* if (self->sitemaptags & smtHTML)) */
	if (!(self->sitemaptags & smtBODY))
	{
		if (strcmp(TagName, "BODY") == 0)
			self->sitemaptags |= smtBODY;
	} else
	{
		if (strcmp(TagName, "/BODY") == 0)
			self->sitemaptags &= ~smtBODY;
	}

	if (self->sitemaptags & smtBODY)
	{
		if (strcmp(TagName, "UL") == 0)
		{
			IncreaseULevel(self);
		} else if (strcmp(TagName, "/UL") == 0)
		{
			DecreaseULevel(self);
		} else if (strcmp(TagName, "LI") == 0 && self->level == 0)
		{
			self->levelforced = TRUE;
		} else if (strcmp(TagName, "OBJECT") == 0)
		{
			char *TagAttributeType = GetVal(tag, taglen, "type");
			
			self->sitemapbodytags |= smbtOBJECT;
			if (TagAttributeType)
			{
				if (strcmp(TagAttributeType, "text/site properties") == 0)
				{
					self->sitemapbodytags |= smbtPROPS;
				} else if (strcmp(TagAttributeType, "text/sitemap") == 0)
				{
					self->sitemapbodytags |= smbtSITEMAP;
					if (self->levelforced)
						IncreaseULevel(self);
				}
				g_free(TagAttributeType);
				if (self->level > 0 && (self->sitemapbodytags & smbtSITEMAP))		/* if it is zero it is the site properties */
					NewSiteMapItem(self);
			}
		} else if (strcmp(TagName, "/OBJECT") == 0)
		{
			if (self->levelforced && (self->sitemapbodytags & smbtSITEMAP))
			{
				DecreaseULevel(self);
				self->levelforced = FALSE;;
			}
			self->sitemapbodytags &= ~(smbtOBJECT | smbtPROPS | smbtSITEMAP);
		} else
		{
			/* we are the properties of the object tag */
			if (self->sitemapbodytags & smbtOBJECT)
			{
				if (self->level > 0 && (self->sitemapbodytags & smbtSITEMAP))
				{
					if (strcmp(TagName, "PARAM") == 0)
					{
						char *TagAttributeName = GetVal(tag, taglen, "name");
						char *TagAttributeValue = GetVal(tag, taglen, "value");
						if (!empty(TagAttributeName) && TagAttributeValue)
						{
							ChmSiteMapItem *item = ActiveItem(self);
							if (g_ascii_strcasecmp(TagAttributeName, "keyword") == 0 ||
								g_ascii_strcasecmp(TagAttributeName, "name") == 0)
							{
								if (item->name)
								{
									g_free(item->keyword);
									item->keyword = item->name;
								}
								item->name = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (g_ascii_strcasecmp(TagAttributeName, "local") == 0)
							{
								g_free(item->local);
								convexternalslash(TagAttributeValue);
								item->local = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (g_ascii_strcasecmp(TagAttributeName, "URL") == 0)
							{
								g_free(item->url);
								convexternalslash(TagAttributeValue);
								item->url = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (g_ascii_strcasecmp(TagAttributeName, "ImageNumber") == 0)
							{
								item->imagenumber = (int)strtol(TagAttributeValue, NULL, 0);
							} else if (g_ascii_strcasecmp(TagAttributeName, "New") == 0)
							{
								item->increaseimageindex = g_ascii_strcasecmp(TagAttributeValue, "yes") == 0;
							} else if (g_ascii_strcasecmp(TagAttributeName, "Comment") == 0)
							{
								g_free(item->comment);
								item->comment = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (g_ascii_strcasecmp(TagAttributeName, "Merge") == 0)
							{
								g_free(item->merge);
								item->merge = TagAttributeValue;
								TagAttributeValue = NULL;
							} else
							{
								CHM_DEBUG_LOG(0, "unrecognized sitemap param name=\"%s\" value=\"%s\"\n", TagAttributeName, TagAttributeValue);
							}
						}
						g_free(TagAttributeValue);
						g_free(TagAttributeName);
					}
				} else if (self->level <= 0 && (self->sitemapbodytags & smbtPROPS))
				{
					/* object and level is zero? */
					if (strcmp(TagName, "PARAM") == 0)
					{
						char *TagAttributeName = GetVal(tag, taglen, "name");
						char *TagAttributeValue = GetVal(tag, taglen, "value");
						if (!empty(TagAttributeName) && TagAttributeValue)
						{
							g_strup(TagAttributeName);
							if (strcmp(TagAttributeName, "FRAMENAME") == 0)
							{
								g_free(self->framename);
								self->framename = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (strcmp(TagAttributeName, "WINDOWNAME") == 0)
							{
								g_free(self->windowname);
								self->windowname = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (strcmp(TagAttributeName, "WINDOW STYLES") == 0)
							{
								self->windowstyles = strtol(TagAttributeValue, NULL, 0);
							} else if (strcmp(TagAttributeName, "EXWINDOW STYLES") == 0)
							{
								self->exwindowstyles = strtol(TagAttributeValue, NULL, 0);
							} else if (strcmp(TagAttributeName, "FOREGROUND") == 0)
							{
								self->foreground = strtol(TagAttributeValue, NULL, 0);
							} else if (strcmp(TagAttributeName, "BACKGROUND") == 0)
							{
								self->foreground = strtol(TagAttributeValue, NULL, 0);
							} else if (strcmp(TagAttributeName, "FONT") == 0)
							{
								g_free(self->font);
								self->font =TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (strcmp(TagAttributeName, "IMAGELIST") == 0)
							{
								g_free(self->imagelist);
								self->imagelist = TagAttributeValue;
								TagAttributeValue = NULL;
							} else if (strcmp(TagAttributeName, "IMAGETYPE") == 0)
							{
								self->usefolderimages = g_ascii_strcasecmp(TagAttributeValue, "FOLDER") == 0;
							} else if (strcmp(TagAttributeName, "IMAGE WIDTH") == 0)
							{
								self->imagewidth = strtol(TagAttributeValue, NULL, 0);
							} else if (strcmp(TagAttributeName, "SAVETYPE") == 0)
							{
								/* info type name (inclusive); TODO */
							} else if (strcmp(TagAttributeName, "SAVEEXCLUSIVE") == 0)
							{
								/* info type name (exclusive); TODO */
							} else if (strcmp(TagAttributeName, "SAVETYPEDESC") == 0)
							{
								/* info type description; TODO */
							} else if (strcmp(TagAttributeName, "CATEGORY") == 0)
							{
								/* TODO */
							} else if (strcmp(TagAttributeName, "CATEGORYDESC") == 0)
							{
								/* TODO */
							} else
							{
								CHM_DEBUG_LOG(0, "unrecognized site property name=\"%s\" value=\"%s\"\n", TagAttributeName, TagAttributeValue);
							}
						}
						g_free(TagAttributeValue);
						g_free(TagAttributeName);
					}
				}
			}
		}
	}
	g_free(TagName);
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSiteMap_LoadFromFile(ChmSiteMap *self, const char *filename)
{
	CHMStream *stream;
	chm_off_t size;
	gboolean result = FALSE;
	HTMLParser *htmlparser;
	
	stream = ChmStream_Open(filename, TRUE);
	if (stream == NULL)
		return FALSE;
	size = CHMStream_Size(stream);
	if (size >= (chm_off_t)0x7fffffffUL)
	{
		errno = EFBIG;
	} else
	{
		char *buffer = g_new(char, size + 1);
		if (buffer != NULL &&
			CHMStream_read(stream, buffer, size))
		{
			buffer[size] = '\0';
			htmlparser = HTMLParser_Create(buffer, size);
			if (htmlparser != NULL)
			{
				htmlparser->obj = self;
				htmlparser->OnFoundTag = FoundTag;
				ChmSiteMap_Reset(self);
				HTMLParser_Exec(htmlparser);
				HTMLParser_Destroy(htmlparser);
				result = TRUE;
			}
		}
		g_free(buffer);
	}
	CHMStream_close(stream);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSiteMap_LoadFromStream(ChmSiteMap *self, CHMStream *stream)
{
	gboolean result = FALSE;
	size_t size = CHMStream_Size(stream);
	char *buffer = (char *)CHMStream_Memptr(stream);
	HTMLParser *htmlparser = HTMLParser_Create(buffer, size);
	if (htmlparser != NULL)
	{
		htmlparser->obj = self;
		htmlparser->OnFoundTag = FoundTag;
		ChmSiteMap_Reset(self);
		HTMLParser_Exec(htmlparser);
		HTMLParser_Destroy(htmlparser);
		result = TRUE;
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSiteMap_SaveToFile(ChmSiteMap *self, const char *filename)
{
	gboolean result = FALSE;
	CHMStream *stream;
	
	stream = ChmStream_Open(filename, FALSE);
	result = ChmSiteMap_SaveToStream(self, stream);
	CHMStream_close(stream);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static void indent(FILE *out, int level)
{
	int i;
	
	for (i = 0; i < level * 8; i++)
		fputc(' ', out);
}

/*** ---------------------------------------------------------------------- ***/

static void writeparam(FILE *out, int level, const char *name, const char *value)
{
	char *s1;
	char *s2;

	if (value == NULL)
		return;
	s1 = xml_quote(name);
	s2 = xml_quote(value);
	indent(out, level);
	fprintf(out, "<param name=%s value=%s>\n", s1, s2);
	g_free(s2);
	g_free(s1);
}

static void writeparamf(FILE *out, int level, const char *name, char *value)
{
	writeparam(out, level, name, value);
	g_free(value);
}

static void writeentries(ChmSiteMap *self, ChmSiteMapItems *items, FILE *out, int level)
{
	int i, count;
	ChmSiteMapItem *item;
	
	count = ChmSiteMapItems_GetCount(items);
	for (i = 0; i < count; i++)
	{
		item = ChmSiteMapItems_GetItem(items, i);
		indent(out, level);
		fputs("<LI> <OBJECT type=\"text/sitemap\">\n", out);
		++level;

		writeparam(out, level, "Name", item->keyword);  /* yes, it appears twice */
		writeparam(out, level, "Name", item->name);
		writeparam(out, level, "Local", item->local);
		writeparam(out, level, "URL", item->url);
		writeparam(out, level, "See Also", item->seealso);
		writeparam(out, level, "FrameName", item->framename);
		writeparam(out, level, "WindowName", item->windowname);
		writeparam(out, level, "Comment", item->comment);
		if (item->increaseimageindex)
			writeparam(out, level, "New", "yes"); /* is this a correct value? */
		if (item->imagenumber != -1)
			writeparamf(out, level, "ImageNumber", g_strdup_printf("%d", item->imagenumber));
		--level;
		indent(out, level);
		fputs("     </OBJECT>\n", out);
		/* Now Sub Entries */
		if (ChmSiteMapItems_GetCount(item->children) > 0)
		{
			indent(out, level);
			fputs("<UL>\n", out);
			writeentries(self, item->children, out, level + 1);
			indent(out, level);
			fputs("</UL>\n", out);
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSiteMap_SaveToStream(ChmSiteMap *self, CHMStream *stream)
{
	gboolean result = FALSE;
	FILE *out;
	int level = 0;
	
	if (self == NULL || stream == NULL)
		return FALSE;
	out = CHMStream_filep(stream);
	
	fputs("<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\">\n", out);
	fputs("<HTML>\n", out);
	fputs("<HEAD>\n", out);
	fprintf(out, "<meta name=\"GENERATOR\" content=\"%s version %s\">\n", gl_program_name, gl_program_version);
	fputs("<!-- Sitemap 1.0 -->\n", out);
	fputs("</HEAD><BODY>\n", out);

	// Site Properties
	fputs("<OBJECT type=\"text/site properties\">\n", out);
	++level;
	/* if (self->sitemaptype == stTOC) */
	{
		writeparam(out, level, "FrameName", self->framename);
		writeparam(out, level, "WindowName", self->windowname);
		writeparam(out, level, "ImageList", self->imagelist);
		if (self->imagewidth != 0)
			writeparamf(out, level, "Image Width", g_strdup_printf("%d", self->imagewidth));
		if (self->background != 0)
			writeparamf(out, level, "Background", g_strdup_printf("0x%x", self->background));
		if (self->foreground != 0)
			writeparamf(out, level, "Foreground", g_strdup_printf("0x%x", self->foreground));
		if (self->windowstyles != 0)
			writeparamf(out, level, "Window Styles", g_strdup_printf("0x%x", self->windowstyles));
		if (self->exwindowstyles != 0)
			writeparamf(out, level, "ExWindow Styles", g_strdup_printf("0x%x", self->exwindowstyles));
		if (self->usefolderimages)
			writeparam(out, level, "ImageType", "Folder");
	}
	
	/* both TOC and Index have font */
	writeparam(out, level, "Font", self->font);

	--level;
	fputs("</OBJECT>\n", out);
	
	// And now the items
	if (ChmSiteMapItems_GetCount(self->items) > 0)
	{
		fputs("<UL>\n", out);
		writeentries(self, self->items, out, level + 1);
		fputs("</UL>\n", out);
	}
	
	fputs("</BODY></HTML>\n", out);
	
	result = TRUE;
	return result;
}
