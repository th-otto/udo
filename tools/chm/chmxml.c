#include "chmtools.h"
#include <assert.h>
#include "kwset.h"
#include "chmxml.h"

typedef uint32_t chm_unichar_t;
#define CHM_UTF8_CHARMAX 6

typedef struct _htmlEntityDesc {
	/* the UNICODE value for the character */	
	chm_unichar_t value;
	/* its utf-8 equivalent */
	unsigned char utf8_bytes[CHM_UTF8_CHARMAX];
	unsigned char utf8_len;
    /* The entity name, with leading '&' and trailing ';' */
	unsigned char name_len;
	const char *name;
	/* the description */
	const char *desc;
} htmlEntityDesc;

static kwset_t xml_dequote_kwset;
static kwset_t xml_enquote_kwset;

#include "htmlentity.h"

#define chm_put_unichar(p, wc) \
	if (wc < 0x80) \
	{ \
		*p++ = wc; \
	} else if (wc < 0x800) \
	{ \
		p[1] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[0] = wc | 0xc0; \
		p += 2; \
	} else if (wc < 0x10000UL) \
	{ \
		p[2] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[1] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[0] = wc | 0xe0; \
		p += 3; \
	} else if (wc < 0x200000UL) \
	{ \
		p[3] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[2] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[1] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[0] = wc | 0xf0; \
		p += 4; \
	} else if (wc < 0x4000000UL) \
	{ \
		p[4] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[3] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[2] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[1] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[0] = wc | 0xf8; \
		p += 5; \
	} else \
	{ \
		p[5] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[4] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[3] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[2] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[1] = (wc & 0x3f) | 0x80; \
		wc >>= 6; \
		p[0] = wc | 0xfc; \
		p += 6; \
	}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

/*
 * code to check and re-print the table, in case you
 * need to add some entries
 */
#if 0
typedef struct _sortentry {
	const char *name;
	chm_unichar_t value;
	int pos;
} sortentry;

static int cmpname(const void *_e1, const void *_e2)
{
	const sortentry *e1 = (const sortentry *)_e1;
	const sortentry *e2 = (const sortentry *)_e2;
	return strcmp(e1->name, e2->name);
}

static int cmpvalue(const void *_e1, const void *_e2)
{
	const sortentry *e1 = (const sortentry *)_e1;
	const sortentry *e2 = (const sortentry *)_e2;
	return (e1->value > e2->value) ? 1 : -1;
}

static sortentry *table;

#undef assert
#define assert(e)       ((e) ? (void)0 : my__assert(i, __FILE__, __LINE__, #e))

static void my__assert(int i, const char *filename, int line, const char *msg)
{
	int pos = table[i].pos;
	fprintf(stderr, "assertion failed: %s, file %s, line %d, i=%d (%s), pos=%d (%s)\n",
		msg, filename, line,
		i, htmlEntitiesTable[i].name,
		pos, htmlEntitiesTable[pos].name);
	exit(1);
}

void xml_print_table(void);
void xml_print_table(void)
{
	int i;
	int n = (sizeof(htmlEntitiesTable) / sizeof(htmlEntitiesTable[0]));
	unsigned char bytes[CHM_UTF8_CHARMAX];
	int utf8len, name_len;
	unsigned char *p;
	chm_unichar_t wc;
	int pos;
	
	table = g_new(sortentry, n);
	for (i = 0; i < n; i++)
	{
		table[i].name = htmlEntitiesTable[i].name;
		table[i].value = htmlEntitiesTable[i].value;
		table[i].pos = i;
	}
	
	/*
	 * do some sanity checks,
	 * and check conditions assumed by the lookup functions
	 */
	for (i = 0; i < n; i++)
	{
		assert(htmlEntitiesTable[i].value != 0);
		assert(htmlEntitiesTable[i].name);
		assert(htmlEntitiesTable[i].name[0] == '&');
		name_len = (int)strlen(htmlEntitiesTable[i].name);
		assert(name_len < 256);
		assert(htmlEntitiesTable[i].name[name_len - 1] == ';');
		p = bytes;
		memset(bytes, 0, sizeof(bytes));
		wc = htmlEntitiesTable[i].value;
		chm_put_unichar(p, wc);
		utf8len = (int)(p - bytes);
		assert(name_len > utf8len);
	}
		
	/*
	 * sort by value, and check that it is unique
	 */
	qsort(table, n, sizeof(*table), cmpvalue);
	for (i = 0; i < (n - 1); i++)
	{
		assert(htmlEntitiesTable[table[i].pos].value < htmlEntitiesTable[table[i + 1].pos].value);
	}
	
	/*
	 * now sort by name, and spit out table
	 */
	qsort(table, n, sizeof(*table), cmpname);
	printf("static const htmlEntityDesc htmlEntitiesTable[] =\n");
	printf("{\n");
	for (i = 0; i < n; i++)
	{
		pos = table[i].pos;
		p = bytes;
		memset(bytes, 0, sizeof(bytes));
		wc = htmlEntitiesTable[pos].value;
		chm_put_unichar(p, wc);
		utf8len = (int)(p - bytes);
		name_len = (int)strlen(htmlEntitiesTable[pos].name);
		printf("\t{ 0x%04x, { 0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x }, %u, %u, \"%s\", \"%s\" }%s\n",
			htmlEntitiesTable[pos].value,
			bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5],
			utf8len,
			name_len,
			htmlEntitiesTable[pos].name,
			htmlEntitiesTable[pos].desc ? htmlEntitiesTable[pos].desc : "NULL",
			(i + 1) < n ? "," : "");
	}
	printf("};\n");
	printf("\n");
	
}

#endif

#ifdef MAIN
#include <time.h>
#include <sys/time.h>
#include "testinp.h"

int replacements;
int printmatch;
#endif

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static char *xml_dequote_slow(const char *src, size_t len)
{
	const char *end;
	const char *p = src;
	size_t allocsize = 1024;
	size_t dstlen;
	char *dst;
	int i, n;
	
	dst = g_new(char, allocsize);
	dstlen = 0;
	end = src + len;
#ifdef MAIN
	replacements = 0;
#endif
	n = (int)(sizeof(htmlEntitiesTable) / sizeof(htmlEntitiesTable[0]));
	while (p < end)
	{
		int found = FALSE;
		
		if (*p == '&')
		{
			for (i = 0; i < n; i++)
			{
				size_t l;
				l = htmlEntitiesTable[i].name_len;
				if (p + l <= end && strncmp(p, htmlEntitiesTable[i].name, l) == 0)
				{
#ifdef MAIN
					replacements++;
#endif
					p += l;
					l = htmlEntitiesTable[i].utf8_len;
					if ((dstlen + l) > allocsize)
					{
						allocsize += 1024;
						dst = g_renew(char, dst, allocsize);
					}
					memcpy(dst + dstlen, htmlEntitiesTable[i].utf8_bytes, l);
					dstlen += l;
					found = TRUE;
					break;
				}
			}
		}
		
		if (!found)
		{
			if ((dstlen + 1) > allocsize)
			{
				allocsize += 1024;
				dst = g_renew(char, dst, allocsize);
			}
			dst[dstlen++] = *p++;
		}
	}
	dst = g_renew(char, dst, dstlen + 1);
	dst[dstlen] = '\0';
	return dst;
}

/*** ---------------------------------------------------------------------- ***/

char *xml_dequote_inplace(char *src, size_t len)
{
	const char *end;
	const char *p = src;
	char *dst;
	int i, n;
	
	dst = src;
	end = src + len;
#ifdef MAIN
	replacements = 0;
#endif
	n = (int)(sizeof(htmlEntitiesTable) / sizeof(htmlEntitiesTable[0]));
	while (p < end)
	{
		int found = FALSE;
		
		if (*p == '&')
		{
			for (i = 0; i < n; i++)
			{
				size_t l;
				l = htmlEntitiesTable[i].name_len;
				if (p + l <= end && strncmp(p, htmlEntitiesTable[i].name, l) == 0)
				{
#ifdef MAIN
					replacements++;
#endif
					p += l;
					l = htmlEntitiesTable[i].utf8_len;
					memcpy(dst, htmlEntitiesTable[i].utf8_bytes, l);
					found = TRUE;
					break;
				}
			}
		}
		
		if (!found)
		{
			*dst++ = *p++;
		}
	}
	*dst = '\0';
	return src;
}

/*** ---------------------------------------------------------------------- ***/

static char *xml_dequote_fast(const char *src, size_t len)
{
	const char *end;
	const char *p = src;
	size_t allocsize = 1024;
	size_t dstlen;
	char *dst;
	struct kwsmatch kwsmatch;
	size_t off;
#ifdef MAIN
	replacements = 0;
#endif
	
	dst = g_new(char, allocsize);
	dstlen = 0;
	end = src + len;
	while (p < end)
	{
		if ((off = kwsexec(xml_dequote_kwset, p, len, &kwsmatch)) != (size_t)-1)
		{
			int i = kwsmatch.index;
			const htmlEntityDesc *ent = &htmlEntitiesTable[i];
			size_t l;
			
#ifdef MAIN
			replacements++;
#endif
			l = ent->utf8_len;
			if ((dstlen + off + l) > allocsize)
			{
				allocsize += off + l + 1024;
				dst = g_renew(char, dst, allocsize);
			}
			memcpy(dst + dstlen, p, off);
			memcpy(dst + dstlen + off, ent->utf8_bytes, l);
			dstlen += off + l;
			l = off + ent->name_len;
			p += l;
			len -= l;
		} else
		{
			if ((dstlen + len) > allocsize)
			{
				allocsize += len + 1;
				dst = g_renew(char, dst, allocsize);
			}
			memcpy(dst + dstlen, p, len);
			dstlen += len;
			p += len;
			len = 0;
		}
	}
	dst = g_renew(char, dst, dstlen + 1);
	dst[dstlen] = '\0';
	return dst;
}

/*** ---------------------------------------------------------------------- ***/

char *xml_dequote(const char *src, size_t len)
{
	if (xml_dequote_kwset)
		return xml_dequote_fast(src, len);
	return xml_dequote_slow(src, len);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static char *xml_enquote_slow(const char *src, size_t len)
{
	const char *end;
	const char *p = src;
	size_t allocsize = 1024;
	size_t dstlen;
	char *dst;
	int i, n;
	
	dst = g_new(char, allocsize);
	dstlen = 0;
	dst[dstlen++] = '"';
	end = src + len;
#ifdef MAIN
	replacements = 0;
#endif
	n = (int)(sizeof(htmlEntitiesTable) / sizeof(htmlEntitiesTable[0]));
	while (p < end)
	{
		int found = FALSE;
		
		for (i = 0; i < n; i++)
		{
			size_t l;
			l = htmlEntitiesTable[i].utf8_len;
			if (p + l <= end && memcmp(p, htmlEntitiesTable[i].utf8_bytes, l) == 0)
			{
#ifdef MAIN
				replacements++;
#endif
				p += l;
				l = htmlEntitiesTable[i].name_len;
				if ((dstlen + l + 2) > allocsize)
				{
					allocsize += 1024;
					dst = g_renew(char, dst, allocsize);
				}
				memcpy(dst + dstlen, htmlEntitiesTable[i].name, l);
				dstlen += l;
				found = TRUE;
				break;
			}
		}
		
		if (!found)
		{
			if ((dstlen + 2) > allocsize)
			{
				allocsize += 1024;
				dst = g_renew(char, dst, allocsize);
			}
			dst[dstlen++] = *p++;
		}
	}
	dst = g_renew(char, dst, dstlen + 2);
	dst[dstlen++] = '"';
	dst[dstlen] = '\0';
	return dst;
}

/*** ---------------------------------------------------------------------- ***/

static char *xml_enquote_fast(const char *src, size_t len)
{
	const char *end;
	const char *p = src;
	size_t allocsize = 1024;
	size_t dstlen;
	char *dst;
	struct kwsmatch kwsmatch;
	size_t off;
#ifdef MAIN
	replacements = 0;
#endif
	
	dst = g_new(char, allocsize);
	dstlen = 0;
	dst[dstlen++] = '"';
	end = src + len;
	while (p < end)
	{
		if ((off = kwsexec(xml_enquote_kwset, p, len, &kwsmatch)) != (size_t)-1)
		{
			int i = kwsmatch.index;
			const htmlEntityDesc *ent = &htmlEntitiesTable[i];
			size_t l;
			
#ifdef MAIN
			replacements++;
#endif
			l = ent->name_len;
			if ((dstlen + off + l + 2) > allocsize)
			{
				allocsize += off + l + 2 + 1024;
				dst = g_renew(char, dst, allocsize);
			}
			memcpy(dst + dstlen, p, off);
			memcpy(dst + dstlen + off, ent->name, l);
			dstlen += off + l;
			l = off + ent->utf8_len;
			p += l;
			len -= l;
		} else
		{
			if ((dstlen + len + 2) > allocsize)
			{
				allocsize += len + 2;
				dst = g_renew(char, dst, allocsize);
			}
			memcpy(dst + dstlen, p, len);
			dstlen += len;
			p += len;
			len = 0;
		}
	}
	dst = g_renew(char, dst, dstlen + 2);
	dst[dstlen++] = '"';
	dst[dstlen] = '\0';
	return dst;
}

/*** ---------------------------------------------------------------------- ***/

char *xml_enquote(const char *src, size_t len)
{
	char *dst;
	
	if (src == NULL || len == 0)
	{
		dst = g_new(char, 3);
		dst[0] = '"';
		dst[1] = '"';
		dst[2] = '\0';
	} else if (xml_dequote_kwset)
	{
		dst = xml_enquote_fast(src, len);
	} else
	{
		dst = xml_enquote_slow(src, len);
	}
	return dst;
}

/*** ---------------------------------------------------------------------- ***/

char *xml_quote(const char *src)
{
	if (src == NULL)
		return xml_enquote(src, 0);
	return xml_enquote(src, strlen(src));
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

int xml_init(void)
{
	int i, n;

	n = (int)(sizeof(htmlEntitiesTable) / sizeof(htmlEntitiesTable[0]));

	if (xml_dequote_kwset == NULL)
	{
		xml_dequote_kwset = kwsalloc(NULL);
		
		for (i = 0; i < n; i++)
		{
			if (kwsincr(xml_dequote_kwset, htmlEntitiesTable[i].name, htmlEntitiesTable[i].name_len, NULL) == FALSE)
			{
				kwsfree(xml_dequote_kwset);
				xml_dequote_kwset = NULL;
				break;
			}
		}
		if (kwsprep(xml_dequote_kwset) == FALSE)
		{
			kwsfree(xml_dequote_kwset);
			xml_dequote_kwset = NULL;
		}

		if (xml_dequote_kwset == NULL)
			return FALSE;
	}
	
	if (xml_enquote_kwset == NULL)
	{
		xml_enquote_kwset = kwsalloc(NULL);
		
		for (i = 0; i < n; i++)
		{
			if (kwsincr(xml_enquote_kwset, (const char *)htmlEntitiesTable[i].utf8_bytes, htmlEntitiesTable[i].utf8_len, NULL) == FALSE)
			{
				kwsfree(xml_enquote_kwset);
				xml_enquote_kwset = NULL;
				break;
			}
		}
		if (kwsprep(xml_enquote_kwset) == FALSE)
		{
			kwsfree(xml_enquote_kwset);
			xml_enquote_kwset = NULL;
		}

		if (xml_enquote_kwset == NULL)
			return FALSE;
	}
	
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

void xml_exit(void)
{
	kwsfree(xml_dequote_kwset);
	xml_dequote_kwset = NULL;
	kwsfree(xml_enquote_kwset);
	xml_enquote_kwset = NULL;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

#ifdef MAIN

void benchmark(void);
void benchmark(void)
{
	long elapsed;
	long loops;
	size_t len = strlen(testinp);
#ifdef HAVE_CLOCK_GETTIME
	struct timespec start, end;
#define USECS 1000000000l
#define START() \
	clock_gettime(CLOCK_REALTIME, &start)
#define ELAPSED() \
	clock_gettime(CLOCK_REALTIME, &end); \
	elapsed = (end.tv_sec - start.tv_sec) * USECS + end.tv_nsec - start.tv_nsec
#else
	struct timeval start, end;
#define USECS 1000000l
#define START() \
	gettimeofday(&start, NULL)
#define ELAPSED() \
	gettimeofday(&end, NULL); \
	elapsed = (end.tv_sec - start.tv_sec) * USECS + end.tv_usec - start.tv_usec
#endif
	const int test_secs = 5;
	const long test_duration = test_secs * USECS;

#if 0
	{
		char *p;
		START();
		for (loops = 0; ; loops++)
		{
			printmatch = loops == 0;
			p = xml_dequote_slow(testinp, len);
			g_free(p);
			ELAPSED();
			if (elapsed >= test_duration)
				break;
		}
		printf("%ld loops in %ld.%ld secs, %d replacements\n", loops, elapsed / USECS, elapsed % USECS, replacements);
	}
#endif

#if 0
	{
		char *p;
		START();
		for (loops = 0; ; loops++)
		{
			printmatch = loops == 0;
			p = g_new(char, len + 1);
			strcpy(p, testinp);
			xml_dequote_inplace(p, len);
			g_free(p);
			ELAPSED();
			if (elapsed >= test_duration)
				break;
		}
		printf("%ld loops in %ld.%ld secs, %d replacements\n", loops, elapsed / USECS, elapsed % USECS, replacements);
	}
#endif
	
#if 1
	{
		char *p;
		START();
		for (loops = 0; ; loops++)
		{
			printmatch = loops == 0;
			p = xml_dequote_fast(testinp, len);
			g_free(p);
			ELAPSED();
			if (elapsed >= test_duration)
				break;
		}
		printf("%ld loops in %ld.%ld secs, %d replacements\n", loops, elapsed / USECS, elapsed % USECS, replacements);
	}
#endif

#if 0
	{
		char *dequote = xml_dequote_fast(testinp, len);
		size_t dequote_len = strlen(dequote);
		char *p;
		
		START();
		for (loops = 0; ; loops++)
		{
			printmatch = loops == 0;
			p = xml_enquote_fast(dequote, dequote_len);
			g_free(p);
			ELAPSED();
			if (elapsed >= test_duration)
				break;
		}
		printf("%ld loops in %ld.%ld secs, %d replacements\n", loops, elapsed / USECS, elapsed % USECS, replacements);
	}
#endif

#undef START
#undef ELAPSED
}

/*** ---------------------------------------------------------------------- ***/

int main(void)
{
	if (xml_init() == FALSE)
	{
		perror("");
		return 1;
	}
	benchmark();
	
	xml_exit();
	
	return 0;
}

#endif /* MAIN */
