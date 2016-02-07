#ifndef __HYPMEM_H__
#define __HYPMEM_H__

#define MEM_GARBAGE_FRIENDLY 0

/*
 * values for DEBUG_ALLOC:
 * 0 - disable
 * 1 - track number of blocks and total allocated size
 * 2 - track every block and where it is allocated
 * 3 - same as 2 and track maximum allocated size & number
 * 4 - same as 3 and write log file to "dbgalloc.trc"
 */
#ifndef DEBUG_ALLOC
#  define DEBUG_ALLOC 0
#endif

#ifdef HAVE_GTK
#  define HAVE_GLIB 1
#  include <glib.h>
#endif

#if DEBUG_ALLOC >= 2
void *dbg_malloc(size_t n, const char *file, long line);
void *dbg_calloc(size_t n, size_t s, const char *file, long line);
char *dbg_strdup(const char *s, const char *file, long line);
char *dbg_strndup(const char *s, size_t len, const char *file, long line);
void dbg_free(void *p, const char *file, long line);
void *dbg_realloc(void *p, size_t s, const char *file, long line);
#endif

#ifdef HAVE_GLIB
#include <glib.h>
#else

#include <stdint.h>

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

/* Define G_VA_COPY() to do the right thing for copying va_list variables.
 * config.h may have already defined G_VA_COPY as va_copy or __va_copy.
 */
#if !defined (G_VA_COPY)
#  if defined (__GNUC__)
#    define G_VA_COPY(ap1, ap2)	va_copy(ap1, ap2)
#  elif defined (G_VA_COPY_AS_ARRAY)
#    define G_VA_COPY(ap1, ap2)	  memmove ((ap1), (ap2), sizeof (va_list))
#  else /* va_list is a pointer */
#    define G_VA_COPY(ap1, ap2)	  ((ap1) = (ap2))
#  endif /* va_list is a pointer */
#endif /* !G_VA_COPY */

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

#define g_malloc(n) malloc(n)
#define g_try_malloc(n) malloc(n)
#define g_calloc(n, s) calloc(n, s)
#define g_malloc0(n) calloc(n, 1)
#define g_realloc(ptr, s) realloc(ptr, s)
#define g_free(t) free(t)

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

#if DEBUG_ALLOC >= 2
#define malloc(n) dbg_malloc(n, __FILE__, __LINE__)
#define calloc(n, s) dbg_calloc(n, s, __FILE__, __LINE__)
#define g_strdup(s) dbg_strdup(s, __FILE__, __LINE__)
#endif
#if DEBUG_ALLOC >= 1
#define free(p) dbg_free(p, __FILE__, __LINE__)
#define realloc(p, n) dbg_realloc(p, n, __FILE__, __LINE__)
#endif

#ifndef G_LOCK_DEFINE_STATIC
#define G_LOCK_DEFINE_STATIC(x) extern int x
#define G_LOCK(x)
#define G_UNLOCK(x)
#endif

#define G_ASCII_DTOSTR_BUF_SIZE (29 + 10)

char *g_ascii_dtostr(char *buffer, int buf_len, double d);
char *g_ascii_formatd(char *buffer, int buf_len, const char *format, double d);

#ifndef g_getenv
#define g_getenv(s) getenv(s)
#endif

#endif /* HAVE_GLIB */

#undef g_utf8_next_char
#define g_utf8_next_char(p) ((p) + _hyp_utf8_skip_data[*(const unsigned char *)(p)])
extern const char _hyp_utf8_skip_data[256];
gboolean g_utf8_validate(const char *str, ssize_t max_len, const char **end);


#if MEM_GARBAGE_FRIENDLY
#define mem_garbage_clear(p) p = NULL
#else
#define mem_garbage_clear(p)
#endif

double g_ascii_strtodouble(const char *nptr, const char **endptr);

#undef G_IS_DIR_SEPARATOR
#undef G_SEARCHPATH_SEPARATOR
#undef G_DIR_SEPARATOR
#undef G_DOSTYLE_PATHNAMES

#if defined(G_OS_TOS)
#  define G_SEARCHPATH_SEPARATOR ';'
#  define G_DIR_SEPARATOR '\\'
#  define G_DOSTYLE_PATHNAMES 1
#endif
#if defined(G_OS_WIN32)
#  define G_SEARCHPATH_SEPARATOR ';'
#  define G_DOSTYLE_PATHNAMES 1
#endif
#ifndef G_SEARCHPATH_SEPARATOR
#  define G_SEARCHPATH_SEPARATOR ':'
#endif
#ifndef G_DIR_SEPARATOR
#  define G_DIR_SEPARATOR '/'
#endif

#define G_IS_DIR_SEPARATOR(c) ((c) == '/' || (c) == '\\')

#if defined(__TOS__) || defined(__WIN32__)
#  define G_DOSTYLE_PATHNAMES 1
#endif

const char *hyp_basename(const char *path);
char *hyp_path_get_basename(const char *path);
char *hyp_path_get_dirname(const char *path);

extern const char *g_secure_getenv(const char *name);
gboolean is_allupper(const char *str);
char *replace_ext(const char *str, const char *from, const char *to);

#define STR0TERM  ((size_t)-1)

char *strslash(const char *str);
char *strrslash(const char *str);
void convslash(char *str);
gboolean convexternalslash(char *str);

void _crtexit(void);
void _crtinit(void);

#if !DEBUG_ALLOC
#define _crtexit()
#endif

#if DEBUG_ALLOC < 4
#define _crtinit()
#endif

#endif /* __HYPMEM_H__ */
