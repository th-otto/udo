AUTOMAKE_OPTIONS = -Wno-portability

include ../Makefile.common

if WITH_GUI_WIN32
bin_PROGRAMS = hypview
endif

INCLUDES = -I$(hyp_srcdir)/include -I$(top_srcdir)/rcintl

AM_CPPFLAGS =	-DBINDIR="\"$(bindir)\"" \
		-DPKGDATADIR="\"$(pkgdatadir)\""
	
hypview_SOURCES = \
	hv_main.c \
	hv_defs.h \
	\
	hv_about.c \
	hv_asc.c \
	hv_autol.c \
	hv_bin.c \
	hv_block.c \
	hv_click.c \
	hv_curs.c \
	hv_disp.c \
	hv_eref.c \
	hv_error.c \
	hv_file.c \
	hv_font.c \
	hv_fsel.c \
	hv_gfx.c \
	hv_globl.c \
	hv_help.c \
	hv_hfind.c \
	hv_hist.c \
	hv_info.c \
	hv_init.c \
	hv_mark.c \
	hv_misc.c \
	hv_nav.c \
	hv_popup.c \
	hv_prefs.c \
	hv_srch.c \
	hv_tbar.c \
	hv_win.c \
	autoloc.c \
	$(empty)

hypview_DEPENDENCIES = resource.res $(LIBHYP_DEP) $(LIBHYPDOC_DEP) $(LIBRCINTL_DEP)
hypview_LDADD = resource.res $(LIBPIC) $(LIBHYPDOC) $(LIBHYP) $(INTLLIBS) -lshell32 -lgdi32 -lcomdlg32
hypview_LDFLAGS = -mconsole

EVAL_MOFILES = cat $(srcdir)/../po/LINGUAS | sed -e '/^\#/d' -e 's@^\(.*\)@ ../po/\1@CATOBJEXT@ @'
MOFILES := $(shell $(EVAL_MOFILES))

resource_files = \
	$(srcdir)/resource.rc \
	$(srcdir)/resource.rh \
	$(srcdir)/resource_en.rc \
	$(srcdir)/resource_de.rc \
	$(empty)

resource.res: $(resource_files) $(srcdir)/../po/linguas.rc $(MOFILES)
	$(AM_V_RC)$(WINDRES) $(INCLUDES) --target=$(RC_TARGET) --input-format rc --output-format coff -o $@ $(srcdir)/resource.rc

EXTRA_DIST = $(resource_files)

CLEANFILES = *.res