#ifndef __CHMTOOLS_H__
#define __CHMTOOLS_H__ 1

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define CHM_DEBUG 1

#if !defined(CHM_DEBUG) || !CHM_DEBUG
#define NDEBUG
#endif

#include "windows_.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include "string_.h"
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include "time_.h"
#include "stat_.h"

#include "chmlib.h"
#include "chmtypes.h"
#include "chmintl.h"
#include "profile.h"

#include <assert.h>

#ifndef UNUSED
#  define UNUSED(x) (void)(x)
#endif

#ifdef __PUREC__
#  define ANONYMOUS_STRUCT_DUMMY(x) struct x { int dummy; };
#endif

#ifndef ANONYMOUS_STRUCT_DUMMY
#  define ANONYMOUS_STRUCT_DUMMY(x)
#endif

#ifdef CHM_DEBUG
#  define CHM_DEBUG_LOG(level, fmt, ...) if (verbose >= level) fprintf(stderr, fmt, ##__VA_ARGS__)
#else
#  define CHM_DEBUG_LOG(level, fmt, ...)
#endif

extern int verbose;
extern char const gl_program_name[];
extern char const gl_program_version[];

#ifndef G_DIR_SEPARATOR
#  define G_DIR_SEPARATOR '/'
#endif

/*
 * we need to deal with path names
 * coming either from filesystem or from ITSF storage files
 */
#undef G_IS_DIR_SEPARATOR
#define G_IS_DIR_SEPARATOR(c) ((c) == '/' || (c) == '\\')

void ChmStream_TakeOwner(ChmStream *stream, gboolean owned);
char *changefileext(const char *filename, const char *ext);

int g_mkdir_with_parents(const char *pathname, int mode);

#ifdef __WIN32__
#include <direct.h>
#define mkdir(s, m) _mkdir(s)
#endif

#endif /* __CHMTOOLS_H__ */
