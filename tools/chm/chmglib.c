#include "chmtools.h"
#include <ctype.h>

typedef uint32_t chm_unichar_t;
#define CHM_UTF8_CHARMAX 6

#include "cp_1252.h"

#undef __set_errno
#undef __clear_errno
#define __set_errno(e) errno = e
#define __clear_errno() __set_errno(0)
#ifndef unreachable
# define unreachable() abort()
#endif

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

#ifndef HAVE_GLIB

#ifndef g_strdup
char *g_strdup(const char *str)
{
	char *dst;
	
	if (str == NULL)
		return NULL;
	dst = g_new(char, strlen(str) + 1);
	if (dst == NULL)
		return NULL;
	return strcpy(dst, str);
}
#endif

/*** ---------------------------------------------------------------------- ***/

#ifndef g_strndup
char *g_strndup(const char *str, size_t len)
{
	char *dst;
	
	if (str == NULL)
		return NULL;
	if (len == STR0TERM)
		len = strlen(str);
	dst = g_new(char, len + 1);
	if (dst == NULL)
		return NULL;
	memcpy(dst, str, sizeof(char) * len);
	dst[len] = '\0';
	return dst;
}
#endif

/*** ---------------------------------------------------------------------- ***/

char *g_strconcat(const char *first, ...)
{
	va_list args;
	size_t len;
	const char *str;
	char *ret, *ptr;
	
	if (first == NULL)
		return NULL;
	len = strlen(first) + 1;
	va_start(args, first);
	for (;;)
	{
		str = va_arg(args, const char *);
		if (str == NULL)
			break;
		len += strlen(str);
	}
	va_end(args);
	ret = g_new(char, len);
	if (ret == NULL)
		return NULL;
	strcpy(ret, first);
	ptr = ret + strlen(ret);
	va_start(args, first);
	for (;;)
	{
		str = va_arg(args, const char *);
		if (str == NULL)
			break;
		strcpy(ptr, str);
		ptr += strlen(ptr);
	}
	va_end(args);
	return ret;
}

/*** ---------------------------------------------------------------------- ***/

char *g_strdup_vprintf(const char *format, va_list args)
{
	char *res;
	int len;
	size_t initsize;
	
/* Pure-C lacks vsnprintf() */
#if defined(__PUREC__) && defined(_PUREC_SOURCE)
	initsize = 1000000ul;
	res = g_new(char, initsize);
	while (res == NULL && initsize > 128)
	{
		initsize >>= 1;
		res = g_new(char, initsize);
	}
	if (res == NULL)
	{
		return NULL;
	}

	len = vsprintf(res, format, args);
	if (len >= initsize)
	{
		unreachable();
	}
	res = g_renew(char, res, (len + 1));
#else
	va_list args2;

	initsize = 1024;
	res = g_new(char, initsize);
	if (res == NULL)
	{
		return NULL;
	}
	G_VA_COPY(args2, args);

	len = vsnprintf(res, initsize, format, args);
	if ((size_t)len >= initsize)
	{
		initsize = len + 1;
		res = g_renew(char, res, initsize);
		if (res != NULL)
		{
			len = vsnprintf(res, initsize, format, args2);
			if ((size_t)len >= initsize)
			{
				unreachable();
			}
		}
	}
	va_end(args2);
#endif
	
	return res;
}

/*** ---------------------------------------------------------------------- ***/

char *g_strdup_printf(const char *format, ...)
{
	va_list args;
	char *res;
	
	va_start(args, format);
	res = g_strdup_vprintf(format, args);
	va_end(args);
	return res;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * Removes trailing whitespace from a string.
 */
char *g_strchomp(char *str)
{
	char *end;
	
	if (str == NULL)
		return NULL;
	end = str + strlen(str) - 1;
	while (end > str && (*end == ' ' || *end == '\t' || *end == '\r' || *end == '\n'))
		--end;
	*++end = '\0';
	return str;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * Removes leading whitespace from a string, by moving the rest of the characters forward.
 */
char *g_strchug(char *str)
{
	char *src;
	
	if (str == NULL)
		return NULL;
	src = str;
	while (*src == ' ' || *src == '\t')
		src++;
	if (str != src)
		memmove(str, src, strlen(src) + 1);
	return str;
}

/*** ---------------------------------------------------------------------- ***/

void g_strfreev(char **str_array)
{
	if (str_array)
	{
		int i;

		for (i = 0; str_array[i] != NULL; i++)
			g_free(str_array[i]);

		g_free(str_array);
	}
}

/*** ---------------------------------------------------------------------- ***/

unsigned int g_strv_length(char **str_array)
{
	int i = 0;
	if (str_array)
	{
		for (; str_array[i] != NULL; i++)
			;
	}
	return i;
}

/*** ---------------------------------------------------------------------- ***/

char **g_strsplit(const char *string, const char *delimiter, int max_tokens)
{
	char **str_array;
	const char *s;
	unsigned int n;
	const char *remainder;
	size_t delimiter_len;
	int tokens;
	
	if (string == NULL)
		return NULL;
	if (delimiter == NULL)
		return NULL;
	delimiter_len = strlen(delimiter);
	if (delimiter_len == 0)
		return NULL;

	if (max_tokens < 1)
		max_tokens = INT_MAX;

	remainder = string;
	n = 0;
	s = strstr(remainder, delimiter);
	tokens = max_tokens;
	if (s)
	{
		while (--tokens && s)
		{
			n++;
			remainder = s + delimiter_len;
			s = strstr(remainder, delimiter);
		}
	}
	if (*string)
	{
		n++;
	}

	str_array = g_new(char *, n + 1);
	if (str_array == NULL)
		return NULL;
	
	remainder = string;
	n = 0;
	s = strstr(remainder, delimiter);
	tokens = max_tokens;
	if (s)
	{
		while (--tokens && s)
		{
			size_t len;

			len = (const char *)s - remainder;
			str_array[n] = g_strndup(remainder, len);
			n++;
			remainder = s + delimiter_len;
			s = strstr(remainder, delimiter);
		}
	}
	if (*string)
	{
		str_array[n] = g_strdup(remainder);
		n++;
	}

	str_array[n] = NULL;

	return str_array;
}

/*** ---------------------------------------------------------------------- ***/

char *g_stpcpy(char *dest, const char *src)
{
	if (dest == NULL)
		return NULL;
	if (src == NULL)
		return NULL;
#ifdef HAVE_STPCPY
	return stpcpy(dest, src);
#else
	do
		*dest++ = *src;
	while (*src++ != '\0');

	return dest - 1;
#endif
}

/*** ---------------------------------------------------------------------- ***/

char *g_strjoinv(const char *separator, char **str_array)
{
	char *string;
	char *ptr;

	if (str_array == NULL)
		return NULL;

	if (separator == NULL)
		separator = "";

	if (*str_array)
	{
		int i;
		size_t len;
		size_t separator_len;

		separator_len = strlen(separator);
		/* First part, getting length */
		len = 1 + strlen(str_array[0]);
		for (i = 1; str_array[i] != NULL; i++)
			len += strlen(str_array[i]);
		len += separator_len * (i - 1);

		/* Second part, building string */
		string = g_new(char, len);
		ptr = g_stpcpy(string, *str_array);
		for (i = 1; str_array[i] != NULL; i++)
		{
			ptr = g_stpcpy(ptr, separator);
			ptr = g_stpcpy(ptr, str_array[i]);
		}
	} else
	{
		string = g_strdup("");
	}
	
	return string;
}

/*** ---------------------------------------------------------------------- ***/

#define ISSPACE(c)              ((c) == ' ' || (c) == '\f' || (c) == '\n' || \
                                 (c) == '\r' || (c) == '\t' || (c) == '\v')
#define ISUPPER(c)              ((c) >= 'A' && (c) <= 'Z')
#define ISLOWER(c)              ((c) >= 'a' && (c) <= 'z')
#define ISALPHA(c)              (ISUPPER (c) || ISLOWER (c))
#define TOUPPER(c)              (ISLOWER (c) ? (c) - 'a' + 'A' : (c))
#define TOLOWER(c)              (ISUPPER (c) ? (c) - 'A' + 'a' : (c))

int g_ascii_strcasecmp(const char *s1, const char *s2)
{
	int c1, c2;

	while (*s1 && *s2)
    {
		c1 = (int)(unsigned char) TOLOWER (*s1);
		c2 = (int)(unsigned char) TOLOWER (*s2);
		if (c1 != c2)
			return c1 - c2;
		s1++; s2++;
	}

	return (((int)(unsigned char) *s1) - ((int)(unsigned char) *s2));
}

/*** ---------------------------------------------------------------------- ***/

int g_ascii_strncasecmp(const char *s1, const char *s2, size_t n)
{
	int c1, c2;
	
	while (n && *s1 && *s2)
	{
		n -= 1;
		c1 = (int)(unsigned char) TOLOWER (*s1);
		c2 = (int)(unsigned char) TOLOWER (*s2);
		if (c1 != c2)
			return c1 - c2;
		s1++; s2++;
	}
	
	if (n)
		return (((int) (unsigned char) *s1) - ((int) (unsigned char) *s2));
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

GSList *g_slist_remove(GSList *list, gconstpointer data)
{
	GSList *l, **last;
	
	for (last = &list; (l = *last) != NULL; last = &(*last)->next)
	{
		if (l->data == data)
		{
			*last = l->next;
			g_slist_free_1(l);
			break;
		}
	}
	return list;
}

/*** ---------------------------------------------------------------------- ***/

GSList *g_slist_prepend(GSList *list, gpointer data)
{
	GSList *l;
	
	l = g_new(GSList, 1);
	l->data = data;
	l->next = list;
	return l;
}

/*** ---------------------------------------------------------------------- ***/

GSList *g_slist_append(GSList *list, gpointer data)
{
	GSList *l, **last;
	
	for (last = &list; *last != NULL; last = &(*last)->next)
		;
	l = g_new(GSList, 1);
	l->data = data;
	l->next = NULL;
	*last = l;
	return list;
}

/*** ---------------------------------------------------------------------- ***/

void g_slist_free_full(GSList *list, void (*freefunc)(void *))
{
	GSList *l, *next;
	
	for (l = list; l; l = next)
	{
		next = l->next;
		if (freefunc)
 			freefunc(l->data);
		g_free(l);
	}
}

/*** ---------------------------------------------------------------------- ***/

void g_slist_free(GSList *list)
{
	g_slist_free_full(list, 0);
}

/*** ---------------------------------------------------------------------- ***/

char *g_strup(char *s)
{
	char *p;
	
	p = s;
	if (p != NULL)
	{
		while (*p)
		{
			*p = toupper(*p);
			p++;
		}
	}
	return s;
}

/*** ---------------------------------------------------------------------- ***/

GSList *g_slist_nth(GSList *list, unsigned int i)
{
	GSList *l;
	unsigned int index;
	
	for (l = list, index = 0; l != NULL; l = l->next, index++)
		if (index == i)
			return l;
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

void *g_slist_nth_data(const GSList *list, unsigned int i)
{
	const GSList *l;
	unsigned int index;
	
	for (l = list, index = 0; l != NULL; l = l->next, index++)
		if (index == i)
			return l->data;
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

unsigned int g_slist_length(const GSList *list)
{
	const GSList *l;
	unsigned int index;
	
	for (l = list, index = 0; l != NULL; l = l->next, index++)
		;
	return index;
}

/*** ---------------------------------------------------------------------- ***/

static GSList *g_slist_sort_merge(GSList * l1, GSList * l2, GCompareFunc compare_func)
{
	GSList list, *l;
	int cmp;

	l = &list;

	while (l1 && l2)
	{
		cmp = compare_func(l1->data, l2->data);

		if (cmp <= 0)
		{
			l = l->next = l1;
			l1 = l1->next;
		} else
		{
			l = l->next = l2;
			l2 = l2->next;
		}
	}
	l->next = l1 ? l1 : l2;

	return list.next;
}

GSList *g_slist_sort(GSList *list, GCompareFunc compare_func)
{
	GSList *l1, *l2;

	if (!list)
		return NULL;
	if (!list->next)
		return list;

	l1 = list;
	l2 = list->next;

	while ((l2 = l2->next) != NULL)
	{
		if ((l2 = l2->next) == NULL)
			break;
		l1 = l1->next;
	}
	l2 = l1->next;
	l1->next = NULL;

	return g_slist_sort_merge(g_slist_sort(list, compare_func), g_slist_sort(l2, compare_func), compare_func);
}

/*** ---------------------------------------------------------------------- ***/

#define VALIDATE_BYTE(mask, expect)                      \
    if (G_UNLIKELY((*p & (mask)) != (expect))) \
      goto error

/* see IETF RFC 3629 Section 4 */

static const unsigned char *fast_validate(const unsigned char *str)
{
	const unsigned char *p = str;

	for (; *p; p++)
	{
		if (*p < 0x80)
			/* done */ ;
		else
		{
			const unsigned char *last;

			last = p;
			if (*p < 0xe0)	/* 110xxxxx */
			{
				if (G_UNLIKELY(*p < 0xc2))
					goto error;
			} else
			{
				if (*p < 0xf0)	/* 1110xxxx */
				{
					switch (*p++ & 0x0f)
					{
					case 0:
						VALIDATE_BYTE(0xe0, 0xa0);	/* 0xa0 ... 0xbf */
						break;
					case 0x0d:
						VALIDATE_BYTE(0xe0, 0x80);	/* 0x80 ... 0x9f */
						break;
					default:
						VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
						break;
					}
				} else if (*p < 0xf5)	/* 11110xxx excluding out-of-range */
				{
					switch (*p++ & 0x07)
					{
					case 0:
						VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
						if (G_UNLIKELY((*p & 0x30) == 0))
							goto error;
						break;
					case 4:
						VALIDATE_BYTE(0xf0, 0x80);	/* 0x80 ... 0x8f */
						break;
					default:
						VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
						break;
					}
					p++;
					VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
				} else
					goto error;
			}

			p++;
			VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */

			continue;

		  error:
			return last;
		}
	}

	return p;
}

/*** ---------------------------------------------------------------------- ***/

static const unsigned char *fast_validate_len(const unsigned char *str, ssize_t max_len)
{
	const unsigned char *p = str;

	for (; ((p - str) < max_len) && *p; p++)
	{
		if (*p < 0x80)
			/* done */ ;
		else
		{
			const unsigned char *last;

			last = p;
			if (*p < 0xe0)	/* 110xxxxx */
			{
				if (G_UNLIKELY(max_len - (p - str) < 2))
					goto error;

				if (G_UNLIKELY(*p < 0xc2))
					goto error;
			} else
			{
				if (*p < 0xf0)	/* 1110xxxx */
				{
					if (G_UNLIKELY(max_len - (p - str) < 3))
						goto error;

					switch (*p++ & 0x0f)
					{
					case 0:
						VALIDATE_BYTE(0xe0, 0xa0);	/* 0xa0 ... 0xbf */
						break;
					case 0x0d:
						VALIDATE_BYTE(0xe0, 0x80);	/* 0x80 ... 0x9f */
						break;
					default:
						VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
						break;
					}
				} else if (*p < 0xf5)	/* 11110xxx excluding out-of-range */
				{
					if (G_UNLIKELY(max_len - (p - str) < 4))
						goto error;

					switch (*p++ & 0x07)
					{
					case 0:
						VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
						if (G_UNLIKELY((*p & 0x30) == 0))
							goto error;
						break;
					case 4:
						VALIDATE_BYTE(0xf0, 0x80);	/* 0x80 ... 0x8f */
						break;
					default:
						VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
						break;
					}
					p++;
					VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */
				} else
					goto error;
			}

			p++;
			VALIDATE_BYTE(0xc0, 0x80);	/* 10xxxxxx */

			continue;

		  error:
			return last;
		}
	}

	return p;
}

gboolean g_utf8_validate(const char *str, ssize_t max_len, const char **end)
{
	const char *p;

	if (max_len < 0)
		p = (const char *)fast_validate((const unsigned char *)str);
	else
		p = (const char *)fast_validate_len((const unsigned char *)str, max_len);

	if (end)
		*end = p;

	if ((max_len >= 0 && p != str + max_len) || (max_len < 0 && *p != '\0'))
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

int g_mkdir_with_parents(const char *pathname, int mode)
{
	char *fn, *p;
	struct stat st;
	int res;
	
	if (pathname == NULL || *pathname == '\0')
	{
		errno = EINVAL;
		return -1;
	}

	fn = g_strdup(pathname);

	p = fn;
	if (G_IS_DIR_SEPARATOR(*p))
	{
		/* Skip initial slashes */
		while (G_IS_DIR_SEPARATOR(*p))
			p++;
	}
	
	do
	{
		while (*p && !G_IS_DIR_SEPARATOR(*p))
			p++;

		if (!*p)
			p = NULL;
		else
			*p = '\0';

		res = stat(fn, &st);
		if (res != 0)
		{
			if (mkdir(fn, mode) == -1 && errno != EEXIST)
			{
				int errno_save = errno;

				g_free(fn);
				errno = errno_save;
				return -1;
			}
		} else if (!S_ISDIR(st.st_mode))
		{
			g_free(fn);
			errno = ENOTDIR;
			return -1;
		}
		if (p)
		{
			*p++ = G_DIR_SEPARATOR;
			while (*p && G_IS_DIR_SEPARATOR(*p))
				p++;
		}
	} while (p);

	g_free(fn);

	return 0;
}

#endif /* HAVE_GLIB */

/*** ---------------------------------------------------------------------- ***/

void g_freep(char **str)
{
	if (*str != NULL)
	{
		g_free(*str);
		*str = NULL;
	}
}

/*** ---------------------------------------------------------------------- ***/

void chomp(char **str)
{
	if (*str != NULL)
	{
		g_strchomp(*str);
		g_strchug(*str);
	}
	if (empty(*str))
	{
		g_freep(str);
	}
}

/*** ---------------------------------------------------------------------- ***/

void convslash(char *str)
{
	char *p = str;
	if (p != NULL)
	{
		while (*p)
		{
			if (G_IS_DIR_SEPARATOR(*p))
				*p = G_DIR_SEPARATOR;
			p++;
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

gboolean convexternalslash(char *str)
{
	gboolean replaced = FALSE;
	
	char *p = str;
	if (p != NULL)
	{
		while (*p)
		{
			if (*p == '\\')
			{
				*p = '/';
				replaced = TRUE;
			}
			p++;
		}
	}
	return replaced;
}

/*** ---------------------------------------------------------------------- ***/

const char *chm_basename(const char *path)
{
	const char *p;
	const char *base = NULL;
	
	if (path == NULL)
		return path;
	p = path;
	while (*p != '\0')
	{
		if (*p == '/' || *p == '\\')
			base = p + 1;
		++p;
	}
	if (base != NULL)
		return base;
	
	if (isalpha(path[0]) && path[1] == ':')
	{
    	/* can only be X:name, without slash */
    	path += 2;
	}
	
	return path;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

#define CONTINUATION_CHAR                           \
  if ((*(const unsigned char *)p & 0xc0) != 0x80) /* 10xxxxxx */ \
    goto error;                                     \
  val <<= 6;                                        \
  val |= (*(const unsigned char *)p) & 0x3f

#define UNICODE_VALID(Char)                   \
    ((Char) < 0x110000UL &&                     \
     (((Char) & 0xFFFFF800UL) != 0xD800UL) &&     \
     ((Char) < 0xFDD0UL || (Char) > 0xFDEFUL) &&  \
     ((Char) & 0xFFFEUL) != 0xFFFEUL)

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

/*** ---------------------------------------------------------------------- ***/

char *chm_conv_to_utf8(const void *src, size_t len)
{
	char *dst;
	const chm_unichar_t *cset;
	size_t i;
	
	if (src == NULL)
		return NULL;
	if (len == STR0TERM)
		len = strlen((const char *) src);
	cset = cp1252_to_unicode;
	{
		const unsigned char *ptr;
		char *p;
		chm_unichar_t wc;
		
		ptr = (const unsigned char *)src;
		
		dst = p = g_new(char, len * CHM_UTF8_CHARMAX + 1);
		if (dst != NULL)
		{
			ptr = (const unsigned char *)src;
			for (i = 0; i < len; i++)
			{
				wc = cset[*ptr++];
				chm_put_unichar(p, wc);
			}
			*p++ = '\0';
			dst = g_renew(char, dst, p - dst);
		}
	}
	return dst;
}

/*** ---------------------------------------------------------------------- ***/

size_t chm_wcslen(const chm_wchar_t *str)
{
	size_t len = 0;
	
	if (str)
	{
		while (*str++)
			len++;
	}
	return len;
}

/*** ---------------------------------------------------------------------- ***/

const char *g_utf8_skipchar(const char *p)
{
	const char *last;

	if (*(const unsigned char *) p < 0x80)
		return p + 1;
	last = p;
	if ((*(const unsigned char *) p & 0xe0) == 0xc0)	/* 110xxxxx */
	{
		if (G_UNLIKELY((*(const unsigned char *) p & 0x1e) == 0))
			goto error;
		p++;
		if (G_UNLIKELY((*(const unsigned char *) p & 0xc0) != 0x80))	/* 10xxxxxx */
			goto error;
	} else
	{
		chm_unichar_t val = 0;
		chm_unichar_t min = 0;
		
		if ((*(const unsigned char *) p & 0xf0) == 0xe0)	/* 1110xxxx */
		{
			min = (1 << 11);
			val = *(const unsigned char *) p & 0x0f;
			goto TWO_REMAINING;
		} else if ((*(const unsigned char *) p & 0xf8) == 0xf0)	/* 11110xxx */
		{
			min = ((chm_unichar_t)1 << 16);
			val = *(const unsigned char *) p & 0x07;
		} else
		{
			goto error;
		}
		
		p++;
		CONTINUATION_CHAR;
	  TWO_REMAINING:
		p++;
		CONTINUATION_CHAR;
		p++;
		CONTINUATION_CHAR;

		if (G_UNLIKELY(val < min))
			goto error;

		if (G_UNLIKELY(!UNICODE_VALID(val)))
			goto error;
	}

	return p + 1;

  error:
	return last + 1;
}

/*** ---------------------------------------------------------------------- ***/

size_t g_utf8_str_len(const char *p, size_t len)
{
	size_t l = 0;
	const char *end;
	
	if (p == NULL)
		return l;
	if (len == STR0TERM)
		len = strlen(p);
	end = p + len;
	while (p < end && *p)
	{
		p = g_utf8_skipchar(p);
		l++;
	}
	return l;
}

/*** ---------------------------------------------------------------------- ***/

static const char *chm_utf8_getchar(const char *p, chm_unichar_t *ch)
{
	const char *last;

	if (*(const unsigned char *) p < 0x80)
	{
		*ch = *(const unsigned char *) p;
		return p + 1;
	}
	last = p;
	if ((*(const unsigned char *) p & 0xe0) == 0xc0)	/* 110xxxxx */
	{
		if (G_UNLIKELY((*(const unsigned char *) p & 0x1e) == 0))
			goto error;
		*ch = (*(const unsigned char *) p & 0x1f) << 6;
		p++;
		if (G_UNLIKELY((*(const unsigned char *) p & 0xc0) != 0x80))	/* 10xxxxxx */
			goto error;
		*ch |= (*(const unsigned char *) p) & 0x3f;
	} else
	{
		chm_unichar_t val = 0;
		chm_unichar_t min = 0;
		
		if ((*(const unsigned char *) p & 0xf0) == 0xe0)	/* 1110xxxx */
		{
			min = (1 << 11);
			val = *(const unsigned char *) p & 0x0f;
			goto TWO_REMAINING;
		} else if ((*(const unsigned char *) p & 0xf8) == 0xf0)	/* 11110xxx */
		{
			min = ((chm_unichar_t)1 << 16);
			val = *(const unsigned char *) p & 0x07;
		} else
		{
			goto error;
		}
		
		p++;
		CONTINUATION_CHAR;
	  TWO_REMAINING:
		p++;
		CONTINUATION_CHAR;
		p++;
		CONTINUATION_CHAR;

		if (G_UNLIKELY(val < min))
			goto error;

		if (G_UNLIKELY(!UNICODE_VALID(val)))
			goto error;
		*ch = val;
	}

	return p + 1;

  error:
    *ch = 0xffff;
	return last + 1;
}

/*** ---------------------------------------------------------------------- ***/

char *chm_wchar_to_utf8(const chm_wchar_t *str, size_t wlen)
{
	size_t len;
	char *dst, *p;
	chm_unichar_t wc;
	
	if (str == NULL)
		return NULL;
	if (wlen == STR0TERM)
		wlen = chm_wcslen(str);
	len = wlen * CHM_UTF8_CHARMAX + 1;
	dst = p = g_new(char, len);
	if (G_UNLIKELY(dst == NULL))
		return NULL;
	while (wlen)
	{
		wc = *str++;
		chm_put_unichar(p, wc);
		wlen--;
	}
	*p++ = '\0';
	return g_renew(char, dst, p - dst);
}

/*** ---------------------------------------------------------------------- ***/

chm_wchar_t *chm_utf8_to_wchar(const char *str, size_t len, size_t *lenp)
{
	size_t wlen;
	chm_wchar_t *dst, *p;
	chm_unichar_t ch;
	const char *end;
	
	if (str == NULL)
		return NULL;
	if (len == STR0TERM)
		len = strlen(str);
	wlen = g_utf8_str_len(str, len);
	dst = g_new(chm_wchar_t, wlen + 1);
	if (G_UNLIKELY(dst == NULL))
		return NULL;
	end = str + len;
	p = dst;
	while (str < end)
	{
		str = chm_utf8_getchar(str, &ch);
		*p++ = (chm_wchar_t) ch;
	}
	*p = 0;
	if (lenp)
		*lenp = wlen;
	return dst;
}
