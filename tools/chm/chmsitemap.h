#ifndef __CHMSITEMAP_H__
#define __CHMSITEMAP_H__ 1

typedef struct _ChmSiteMap ChmSiteMap;
typedef struct _ChmSiteMapItem ChmSiteMapItem;
typedef struct _ChmSiteMapItems ChmSiteMapItems;

typedef enum { stTOC, stIndex } SiteMapType;

struct _ChmSiteMapItem {
	ChmSiteMapItems *children;
	char *name;
	char *keyword;
	char *comment;
	int imagenumber;
	gboolean increaseimageindex;
	char *local;
	ChmSiteMapItems *owner;
	char *seealso;
	char *url;
	char *merge;
	char *framename;
	char *windowname;
};

ChmSiteMapItem *ChmSiteMapItem_Create(ChmSiteMapItems *owner);
void ChmSiteMapItem_Destroy(ChmSiteMapItem *item);

struct _ChmSiteMapItems {
	uint32_t internaldata;
	GSList *list; /* of ChmSiteMapItem * */
	ChmSiteMap *owner;
	ChmSiteMapItem *parentitem;
};

ChmSiteMapItems *ChmSiteMapItems_Create(ChmSiteMap *owner, ChmSiteMapItem *parentitem);
void ChmSiteMapItems_Destroy(ChmSiteMapItems *self);
void ChmSiteMapItems_Delete(ChmSiteMapItems *self, int index);
int ChmSiteMapItems_Add(ChmSiteMapItems *self, ChmSiteMapItem *item);
ChmSiteMapItem *ChmSiteMapItems_NewItem(ChmSiteMapItems *self);
void ChmSiteMapItems_Sort(ChmSiteMapItems *self, int (*compare)(const ChmSiteMapItem *item1, const ChmSiteMapItem *item2));

#define smtNone    0
#define smtUnknown (1 << 0)
#define smtHTML    (1 << 1)
#define smtHEAD    (1 << 2)
#define smtBODY    (1 << 3)
typedef unsigned int SiteMapTags;

#define smbtNone    0
#define smbtUnknown (1 << 0)
#define smbtUL      (1 << 1)
#define smbtLI      (1 << 2)
#define smbtOBJECT  (1 << 3)
#define smbtPROPS   (1 << 4)
#define smbtSITEMAP (1 << 5)
typedef unsigned int SiteMapBodyTags;

typedef enum _LIObjectParamType { ptName, ptLocal, ptKeyword } LIObjectParamType;

struct _ChmSiteMap {
	gboolean autogenerated;
	SiteMapType sitemaptype;
	ChmSiteMapItems *items;

	/* "text/site properties" */
	uint32_t background;
	uint32_t foreground;
	uint32_t colormask;			/* seems to be used by custom images */
	char *windowname;
	uint32_t windowstyles;
#define CHM_TOC_HASBUTTONS            0x00000001 /* TVS_HASBUTTONS */
#define CHM_TOC_HASLINES              0x00000002 /* TVS_HASLINES */
#define CHM_TOC_LINESATROOT           0x00000004 /* TVS_LINESATROOT */
#define CHM_TOC_SHOWSELALWAYS         0x00000020 /* TVS_SHOWSELALWAYS */
#define CHM_TOC_TRACKSELECT           0x00000200 /* TVS_TRACKSELECT */
#define CHM_TOC_SINGLEEXPAND          0x00000400 /* TVS_SINGLEEXPAND */
#define CHM_TOC_FULLROWSELECT         0x00001000 /* TVS_FULLROWSELECT */
#define CHM_TOC_BORDER                0x00800000 /* WS_BORDER */
#define CHM_TOC_DLGFRAME              0x00400000 /* WS_DLGFRAME */

#define CHM_TOC_EX_RAISED             0x00000100 /* WS_EX_WINDOWEDGE */
#define CHM_TOC_EX_SUNKEN             0x00000000
#define CHM_TOC_EX_RTLREADING         0x00002000 /* WS_EX_RTLREADING */
#define CHM_TOC_EX_LEFTSCROLLBAR      0x00004000 /* WS_EX_LEFTSCROLLBAR */
#define CHM_TOC_DEF_STYLES (CHM_TOC_BORDER|CHM_TOC_HASBUTTONS|CHM_TOC_SHOWSELALWAYS|CHM_TOC_LINESATROOT)
	uint32_t exwindowstyles;
	char *font;
	char *framename;
	char *imagelist;
	int imagewidth;
	gboolean usefolderimages;

	/* parser related */
	ChmSiteMapItems *currentitems;
	SiteMapTags sitemaptags;
	SiteMapBodyTags sitemapbodytags;
	int level;
	gboolean levelforced;
};

ChmSiteMap *ChmSiteMap_Create(SiteMapType type);
void ChmSiteMap_Destroy(ChmSiteMap *self);
gboolean ChmSiteMap_LoadFromFile(ChmSiteMap *self, const char *filename);
gboolean ChmSiteMap_LoadFromStream(ChmSiteMap *self, ChmStream *stream);
gboolean ChmSiteMap_SaveToFile(ChmSiteMap *self, const char *filename);
gboolean ChmSiteMap_SaveToStream(ChmSiteMap *self, ChmStream *stream);

void ChmSiteMap_SetItems(ChmSiteMap *self, ChmSiteMapItems *items);

#endif /* __CHMSITEMAP_H__ */
