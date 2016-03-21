#ifndef __CHMLIB_H__
#define __CHMLIB_H__ 1

#include <stdio.h>
#include <stdarg.h>
#include <stdint.h>
#include <inttypes.h>
#if defined(HAVE_WCHAR_H)
#include <wchar.h>
#elif defined(__WCHAR_TYPE__)
typedef __WCHAR_TYPE__ wchar_t;
#else
typedef unsigned short wchar_t;
#endif

#if defined(HAVE_GTK)
# define HAVE_GLIB 1
#endif

#define GLIB_DISABLE_DEPRECATION_WARNINGS

#if defined(HAVE_GLIB)

#define g_slist_length g_slist_length_noconst
#define g_slist_nth_data g_slist_nth_data_noconst

#include <glib.h>

#undef g_slist_length
#undef g_slist_nth_data 

#endif

#if defined(__WIN32__)
#ifndef G_OS_WIN32
#define G_OS_WIN32 1
#endif
#ifndef G_PLATFORM_WIN32
#define G_PLATFORM_WIN32 1
#endif
#elif defined(__TOS__)
#define G_OS_TOS 1
#else
#ifndef G_OS_UNIX
#define G_OS_UNIX 1
#endif
#endif

#ifndef FALSE
#  define FALSE 0
#  define TRUE 1
#endif

#ifndef __GNUC_PREREQ
# ifdef __GNUC__
#   define __GNUC_PREREQ(maj, min) ((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))
# else
#   define __GNUC_PREREQ(maj, min) 0
# endif
#endif

#ifndef __LEAF
# if __GNUC_PREREQ (4, 6) && !defined _LIBC
#  define __LEAF , __leaf__
#  define __LEAF_ATTR __attribute__ ((__leaf__))
# else
#  define __LEAF
#  define __LEAF_ATTR
# endif
#endif

#ifndef __THROW
# if !defined __cplusplus && __GNUC_PREREQ (3, 3)
#  define __THROW	__attribute__ ((__nothrow__ __LEAF))
# else
#  if defined __cplusplus && __GNUC_PREREQ (2,8)
#   define __THROW	throw ()
#  else
#   define __THROW
#  endif
# endif
#endif

#ifndef __attribute_format_arg__
#if __GNUC_PREREQ (2,8)
# define __attribute_format_arg__(x) __attribute__ ((__format_arg__ (x)))
#else
# define __attribute_format_arg__(x) /* Ignore */
#endif
#endif

#ifndef G_LIKELY
#if defined(__GNUC__) && (__GNUC__ > 2) && defined(__OPTIMIZE__)
#if !defined(_G_BOOLEAN_EXPR)
#define _G_BOOLEAN_EXPR(expr)                   \
 __extension__ ({                            \
   int _g_boolean_var_;                         \
   if (expr)                                    \
      _g_boolean_var_ = 1;                      \
   else                                         \
      _g_boolean_var_ = 0;                      \
   _g_boolean_var_;                             \
})
#endif
#define G_LIKELY(expr) (__builtin_expect (_G_BOOLEAN_EXPR(expr), 1))
#define G_UNLIKELY(expr) (__builtin_expect (_G_BOOLEAN_EXPR(expr), 0))
#else
#define G_LIKELY(expr) (expr)
#define G_UNLIKELY(expr) (expr)
#endif
#endif

#ifndef EXTERN_C_BEG
#ifdef __cplusplus
#  define EXTERN_C_BEG extern "C" {
#  define EXTERN_C_END }
#else
#  define EXTERN_C_BEG
#  define EXTERN_C_END
#endif
#endif

#ifndef __G_LIB_H__
typedef int gboolean;
typedef uint32_t gunichar;
typedef unsigned short gunichar2;
typedef void *gpointer;
typedef const void *gconstpointer;

#define GLIB_CHECK_VERSION(a, b, c) 0

#if __GNUC_PREREQ(3, 4)
#define G_GNUC_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
#define G_GNUC_WARN_UNUSED_RESULT
#endif

#define g_malloc(n) malloc(n)
#define g_try_malloc(n) malloc(n)
#define g_calloc(n, s) calloc(n, s)
#define g_malloc0(n) calloc(n, 1)
#define g_realloc(ptr, s) realloc(ptr, s)
#define g_free free

#undef g_ascii_isspace
#define g_ascii_isspace(c) ((c) == ' ' || (c) == '\t' || (c) == '\r' || (c) == '\n' || (c) == '\f' || (c) == '\v')
#undef g_ascii_isdigit
#define g_ascii_isdigit(c) ((c) >= '0' && (c) <= '9')
#undef g_ascii_isxdigit
#define g_ascii_isxdigit(c) (g_ascii_isdigit(c) || ((c) >= 'a' && (c) <= 'f') || ((c) >= 'A' && (c) <= 'F'))
#undef g_ascii_isalpha
#define g_ascii_isalpha(c) (((c) >= 'a' && (c) <= 'z') || ((c) >= 'A' && (c) <= 'Z'))
#undef g_ascii_isalnum
#define g_ascii_isalnum(c) ((c) == '_' || g_ascii_isalpha((c)) || g_ascii_isdigit((c)))
#undef g_ascii_toupper
#define g_ascii_toupper(c) toupper(c)

#undef g_new
#define g_new(t, n) ((t *)g_malloc(sizeof(t) * (n)))
#undef g_renew
#define g_renew(t, p, n) ((t *)g_realloc(p, sizeof(t) * (n)))
#undef g_new0
#define g_new0(t, n) ((t *)g_calloc((n), sizeof(t)))

char *g_strdup_printf(const char *format, ...) __attribute__((format(printf, 1, 2)));
char *g_strdup_vprintf(const char *format, va_list args);

char *g_strdup(const char *);
char *g_strndup(const char *, size_t len);
char *g_strconcat(const char *, ...);
char **g_strsplit(const char *string, const char *delimiter, int max_tokens);
char *g_strjoinv(const char *separator, char **str_array);
char *g_stpcpy(char *dest, const char *src);

char *g_build_filename(const char *, ...);
char *g_get_current_dir(void);
gboolean g_path_is_absolute(const char *path);
char *g_strchomp(char *str);
char *g_strchug(char *str);
void g_strfreev(char **str_array);
unsigned int g_strv_length(char **str_array);

#ifndef g_getenv
#define g_getenv(s) getenv(s)
#endif

typedef struct _gslist GSList;
struct _gslist {
	GSList *next;
	void *data;
};

typedef void (*GDestroyNotify)(gpointer data);
typedef int (*GCompareFunc)(gconstpointer a, gconstpointer b);

GSList *g_slist_remove(GSList *list, gconstpointer data) G_GNUC_WARN_UNUSED_RESULT;
GSList *g_slist_prepend(GSList  *list, gpointer  data) G_GNUC_WARN_UNUSED_RESULT;
GSList *g_slist_append(GSList *list, gpointer data);
#define g_slist_free_1(l) g_free(l)
void g_slist_free_full(GSList *list, GDestroyNotify freefunc);
void g_slist_free(GSList *list);
GSList *g_slist_sort(GSList *list, GCompareFunc compare_func) G_GNUC_WARN_UNUSED_RESULT;

char *g_strup(char *s);
char *g_strdown(char *s);

#endif /* __G_LIB_H__ */

GSList *g_slist_nth(GSList *list, unsigned int i);
void *g_slist_nth_data(const GSList *list, unsigned int i);
unsigned int g_slist_length(const GSList *list);

#define STR0TERM  ((size_t)-1)

double g_ascii_strtodouble(const char *nptr, const char **endptr);
gboolean g_is_number(const char *val, gboolean is_unsigned);
int g_ascii_strcasecmp(const char *s1, const char *s2);
int g_ascii_strncasecmp(const char *s1, const char *s2, size_t n);

void chomp(char **str);
void g_freep(char **str);
gboolean convexternalslash(char *str);
void convslash(char *str);

#define empty(str) ((str) == NULL || *(str) == '\0')
#define fixnull(str) ((str) != NULL ? (str) : "")
#define printnull(str) ((str) != NULL ? (const char *)(str) : "(nil)")

typedef uint32_t chm_unichar_t;
#define CHM_UTF8_CHARMAX 6

typedef uint16_t chm_wchar_t;
size_t chm_wcslen(const chm_wchar_t *str);
char *chm_wchar_to_utf8(const chm_wchar_t *str, size_t wlen);
chm_wchar_t *chm_utf8_to_wchar(const char *str, size_t len, size_t *lenp);
size_t g_utf8_str_len(const char *p, size_t len);
const char *g_utf8_skipchar(const char *p);
gboolean g_utf8_validate(const char *str, ssize_t max_len, const char **end);
char *chm_conv_to_utf8(const void *src, size_t len);
const char *chm_utf8_getchar(const char *p, chm_unichar_t *ch);

#include "chmstream.h"
#include "chmbase.h"

#endif /* __CHMLIB_H__ */
