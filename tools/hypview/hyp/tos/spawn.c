#include "hypdefs.h"
#include <stdlib.h>
#include <sys/types.h>

#include <limits.h>
#include <errno.h>
#include <osbind.h>
#include <mintbind.h>
#include "stat_.h"

#if !defined(__PUREC__) || defined(__USE_GEMLIB)
#define _XltErr(r) ((int)(-(r)))
#else
extern int _XltErr(unsigned int err);
#endif
extern int _unx2dos(const char *unx, char *dos, size_t len);
extern char **environ;

#define TOS_ARGS 126

/* comment this out, if you don't want script execution */
#define HASH_BANG 1


static char const *const extensions[] = { ".ttp", ".prg", ".tos", NULL };

static int _spawnvp(int mode, const char *execname, int argc, const char *const *argv);


static int EXISTS(const char *name)
{
	struct stat dummy;

	if (rpl_stat(name, &dummy) != 0)
		return 0;
	if (!S_ISREG(dummy.st_mode))
		return 0;
	return 1;
}


static char *findfile(const char *fname, const char *fpath, const char *const *fext)
{
	char c;
	char const *const *nextext;
	const char *t;
	const char *start;
	gboolean hasext = FALSE;
	gboolean haspath = FALSE;
	char *trypath, *path;
	
	if (!fname || !*fname)
		return NULL;

	t = fname;

/* copy the file in, checking to see if a path and/or extension are already
   given */

	while ((c = *t++) != 0)
	{
		if (G_IS_DIR_SEPARATOR(c))
		{
			haspath = TRUE;
			hasext = FALSE;
		} else if (c == '.')
		{
			hasext = TRUE;
		}
	}

	if (haspath || !fpath)
		fpath = "";

	path = g_strdup(fname);
	for (;;)
	{									/* loop on path elements */
		trypath = g_strdup(path);
		if (EXISTS(trypath))
			break;
		g_free(trypath);
		if (!hasext && fext)
		{
			nextext = fext;
			while (*nextext)
			{								/* loop on extensions */
				trypath = g_strconcat(path, *nextext++, NULL);
				if (EXISTS(trypath))
					goto found;
				g_free(trypath);
			}
		}
		trypath = NULL;
		if (!*fpath)
			break;						/* no more places to look */

/* copy in next element of path list */
		start = fpath;
		/* an attempt to accomodate within reason TOS specs  -- mj */
		if (fpath[0] && fpath[1] == ':')
		{
			if (G_IS_DIR_SEPARATOR(fpath[2]) && (*fpath != '.' && *fpath != ':'))
			{
				fpath += 3;
			}
		}
		while ((c = *fpath) != 0 && c != ':' && c != ',' && c != ';')
		{
			fpath++;
		}
		trypath = g_strndup(start, fpath - start);
		if (c)
			fpath++;
		
		path = g_build_filename(trypath, fname, NULL);
		g_free(trypath);
	}
found:
	g_free(path);
	return trypath;
}


#if HASH_BANG

static int interpret_script(int mode, const char *path, const char *_path, int argcount, const char *const *argv)
{
	char *shell;
	char *shellargs;
	const char **shellargv;
	int nargcount;
	int fd;
	int i, rv;
	char buf[1024],	*bufp, *argp;
	long r;
	
	/* path is already converted to dos */
	if ((fd = (int) Fopen(path, 0)) < 0)
	{
		__set_errno(_XltErr((int)fd));
		return -1;
	}

	r = Fread(fd, (long) sizeof(buf) - 1L, buf);
	Fclose(fd);
	if (r < 0)
	{
		__set_errno(_XltErr((int)r));
		return -1;
	}
	buf[r] = 0;

	if (buf[0] == '#' && buf[1] == '!')
	{
		/* skip blanks */
		bufp = buf + 2;
		while (*bufp == '\t' || *bufp == ' ')
			bufp++;

		/* read filename */
		shell = bufp;
		while (*bufp && *bufp != ' ' && *bufp != '\t' && *bufp != '\r' && *bufp != '\n')
			bufp++;

		if (*bufp && *bufp != '\r' && *bufp != '\n')
			*bufp++ = 0;
		/* else the null will be added below */

		/* 
		 * read arguments if any
		 */
		argp = shellargs = bufp;
		nargcount = 0;
		i = 0;
		while (*bufp && *bufp != '\r' && *bufp != '\n')
		{
			/* skip blanks */
			while (*bufp == ' ' || *bufp == '\t')
				bufp++;

			if (*bufp == '\r' || *bufp == '\n')
				break;

			while (*bufp && *bufp != ' ' && *bufp != '\t' && *bufp != '\r' && *bufp != '\n')
				*argp++ = *bufp++;
			*argp++ = '\0';
			nargcount++;
		}
		*argp = '\0';

		if (*shell)
		{
			shell = findfile(shell, getenv("PATH"), extensions);
			if (!shell)
			{
				__set_errno(ENOENT);
				return -1;				/* file not found */
			}

			shellargv = g_new(const char *, (argcount + nargcount + 2));
			if (!shellargv)
			{
				g_free(shell);
				__set_errno(ENOMEM);
				return -1;
			}

			i = 0;
			shellargv[i++] = shell;
			while (*shellargs != '\0')
			{
				shellargv[i++] = shellargs;
				while (*shellargs++ != '\0')
					;
			}

			/* use the full pathname of the script instead of argv[0] */
			shellargv[i++] = _path;
			while (*++argv != NULL)
				shellargv[i++] = *argv;
			shellargv[i] = NULL;

			rv = _spawnvp(mode, shell, i, shellargv);
			g_free(shellargv);
			g_free(shell);
			return rv;
		}
	}

	__set_errno(ENOEXEC);
	return -1;
}

#endif /* HASH_BANG */


char *make_argv(char cmd[128], const char *const *argv)
{
	size_t cmlen;
	size_t enlen = 0;
	size_t used;
	const char *p;
	char *s, *t;
	char *env;
	const char *const *envp;
	
	SavePD();
	
	envp = (const char *const *)environ;

/* count up space needed for environment */
	for (cmlen = 0; argv[cmlen]; cmlen++)
		enlen += strlen(argv[cmlen]) + 1;
	enlen += 64;						/* filler for stuff like ARGV= and zeros, 
										 * minibuffer for empty param index conversion 
										 */
	for (cmlen = 0; envp[cmlen]; cmlen++)
		enlen += strlen(envp[cmlen]) + 1;

  need_more_core:
	enlen += 1024;						/* buffer for _unx2dos */

	if ((env = (char *) Malloc((long) enlen)) == NULL)
	{
		RestorePD();
		return NULL;
	}

	used = 0;
	s = env;

	while ((p = *envp) != 0)
	{
		/*
		 * do not copy old ARGV environment variable.
		 * This can happen e.g. when called from PC.PRG,
		 * which does not use ARGV method
		 */
		if (strncmp(p, "ARGV=", 5) != 0)
		{
			/* copy variable without any conversion */
			while (*p)
			{
				*s++ = *p++;
				used++;
			}
			*s++ = 0;
			used++;
		}
		
		envp++;
	}

	strcpy(s, "ARGV=");
	s += 6;								/* s+=sizeof("ARGV=") */
	used += 6;
	
	if (argv && *argv)
	{
		unsigned int null_params = 0;
		int ndigits, i;
		const char *digits;
		char digitbuf[10];
		unsigned int idx, val;
		const char *const *ap;

		/* communicate empty arguments thru ARGV= value
		 */
		for (ap = argv, idx = 0; *ap; ap++, idx++)
		{
			if (!**ap)
			{
				/* empty argument found
				 */
				if (!null_params)
				{
					strcpy(s - 1, "NULL:");
					s += 4;				/* s now points after "NULL:" */
					used += 6;
				} else
				{
					*s++ = ',';
					used++;
				}
				null_params++;

				/* convert index of zero param to ascii
				 */
				if (idx == 0)
				{
					digits = "0";
					ndigits = 1;
				} else
				{
					ndigits = 0;
					val = idx;
					while (val)
					{
						ndigits++;
						digitbuf[sizeof(digitbuf) - ndigits] = "0123456789"[val % 10];
						val /= 10;
					}
					digits = digitbuf + sizeof(digitbuf) - ndigits;
				}

				used += ndigits + 2;		/* 2 = sizeof( ',' in NULL:
										 * list + ' ' we put in place
										 * of empty params
										 */
				if (used >= enlen)
				{
					Mfree(env);
					goto need_more_core;
				}
				for (i = 0; i < ndigits; i++)
					*s++ = *digits++;
			}
		}

		if (null_params)
		{
			*s++ = 0;					/* finish "NULL:" list */
		}

		/* copy argv[0] first (because it doesn't go into 
		 * the command line)
		 */
		p = *argv;
		if (!*p)
		{								/* if empty argument */
			*s++ = ' ';					/* replace by space */
		} else
		{
			do
			{
				*s++ = *p++;
			} while (*p);
		}
		*s++ = '\0';
	}

	t = cmd;
	memset(t, 0, TOS_ARGS + 2);

/* s points at the environment's copy of the args */
/* t points at the command line copy to be put in the basepage */

	cmlen = 0;
	if (argv && *argv)
	{
		t++;
		while (*++argv)
		{
			p = *argv;
			if (!*p)
			{							/* if empty argument */
				*s++ = ' ';				/* replace by space */
				/* write '' in TOS cmdlin
				 */
				if (cmlen < TOS_ARGS)
					*t++ = '\'';
				cmlen++;
				if (cmlen < TOS_ARGS)
					*t++ = '\'';
				cmlen++;
			} else
			{
				do
				{
					if (cmlen < TOS_ARGS)
						*t++ = *p;
					cmlen++;
					*s++ = *p++;
				} while (*p);
			}
			if (*(argv + 1))
			{
				if (cmlen < TOS_ARGS)
					*t++ = ' ';
				cmlen++;
			}
			*s++ = '\0';
		}
	}

	/* tie off environment */
	*s++ = '\0';
	*s = '\0';

#if 0
	/*
	 * therotically, we don't need to use ARGV if the arguments fit into
	 * the command line. In practise though, a lot of programs
	 * have bugs parsing empty and/or quoted arguments correctly
	 */
	if (cmlen <= TOS_ARGS)
	{
		*cmd = (unsigned char)cmlen;
		Mfree(env);
		env = NULL;
	} else
#endif
	{
		/* signal Extended Argument Passing */
		*cmd = 0x7f;
	}
	
	RestorePD();
	
	return env;
}


static int _spawnvp(int mode, const char *_path, int argc, const char *const *argv)
{
	char pathbuf[PATH_MAX];
	char *path;
	long rval;
	int execmode;
	char cmd[TOS_ARGS + 2];
#if HASH_BANG
	const char *const *_argv;
#endif
	char *env;
	
	path = pathbuf;
	(void) _unx2dos(_path, path, sizeof(pathbuf));	/* convert filename, if necessary */

#ifdef HASH_BANG
	_argv = argv;
#endif

	if ((env = make_argv(cmd, argv)) == NULL)
	{
		__set_errno(ENOMEM);
		return -1;
	}
	
	{
		if (mode == P_WAIT)
			execmode = 0;
		else if (mode == P_OVERLAY)
			execmode = 200;
		else
			execmode = 100;
		
		rval = Pexec(execmode, path, cmd, env);
		
		if (rval < 0)
		{
#ifdef HASH_BANG
			if (rval == -ETOS_NOEXEC)
			{
				/*
				 * Always check the environment here, don't remove.
				 * If UNIXMODE isn't set we run scripts by default
				 * otherwise, check the 's' flag for activation.
				 */
				const char *unixmode = getenv("UNIXMODE");
	
				if (!unixmode || (unixmode && strchr(unixmode, 's')))
				{
					SavePD();
					(void) Mfree(env);
					RestorePD();
					return interpret_script(mode, path, _path, argc, _argv);
				}
			}
#endif
			__set_errno(_XltErr((int)rval));
			rval = -1;
		} else if (mode == P_OVERLAY)
		{
			_exit((int) rval);
		}
		
		{
		SavePD();
		(void) Mfree(env);
		RestorePD();
		}
	}
	return (int) rval;
}


int hyp_utf8_spawnvp(int mode, int argc, const char *const *argv)
{
	char *execname;
	char **new_argv;
	int retval;
	int i;
	
	execname = findfile(argv[0], getenv("PATH"), extensions);
	if (!execname)
	{
		__set_errno(ENOENT);
		return -1;						/* file not found */
	}
	new_argv = g_new(char *, argc + 1);
	if (new_argv == NULL)
		return -1;
	for (i = 0; i < argc; i++)
		new_argv[i] = hyp_utf8_to_charset(hyp_get_current_charset(), argv[i], STR0TERM, NULL);
	new_argv[i] = NULL;
	retval = _spawnvp(mode, execname, argc, (const char *const *)new_argv);
	for (i = 0; i < argc; i++)
		g_free(new_argv[i]);
	g_free(execname);
	return retval;
}
