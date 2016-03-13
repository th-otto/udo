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

#endif /* __CHMTOOLS_H__ */
