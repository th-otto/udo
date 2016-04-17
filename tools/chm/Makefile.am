include ../../silent.am

INCLUDES = -I$(top_srcdir)/tools/hypview/include
AM_CPPFLAGS = $(GLIB_CFLAGS) $(XML_CFLAGS)

noinst_PROGRAMS = chmls chmc xmltest

if !CROSS_COMPILING
noinst_SCRIPTS = $(build_triplet)-chmls$(EXEEXT) $(build_triplet)-chmc$(EXEEXT)
endif

common_sources = \
	chmversion.h \
	chmbase.c chmbase.h chm_htmlhelp.h langid.h \
	fasthtmlparser.c fasthtmlparser.h \
	htmlutil.c htmlutil.h \
	chmtypes.c chmtypes.h \
	chmstream.c chmstream.h \
	chmreader.c chmreader.h \
	chmsitemap.c chmsitemap.h \
	chmspecialfiles.c chmspecialfiles.h \
	htmlindexer.c htmlindexer.h \
	avltree.c avltree.h \
	chmsearchreader.c chmsearchreader.h chmfiftimain.h \
	chmsearchwriter.c chmsearchwriter.h \
	chmglib.c \
	lzxdec.c lzx.h \
	lzx_layer_nonslide.c lzx_compress.h lzx_constants.h \
	lzx_nonslide.c lzx_nonslide.h \
	xgetopt.c \
	profile.c \
	cp_1252.h \
	chmxml.c chmxml.h htmlentity.h \
	kwset.c obstack.c \
	$(empty)

chmls_SOURCES = \
	chmls.c \
	$(common_sources)

chmls_LDADD = $(GLIB_LIBS) $(INTLLIBS)

$(build_triplet)-chmls$(EXEEXT): chmls$(EXEEXT)
	cp -a $? $@

chmc_SOURCES = \
	chmcmd.c \
	chmproject.c chmproject.h \
	chmwriter.c chmwriter.h chmobjinstconst.h \
	$(common_sources)

chmc_LDADD = $(GLIB_LIBS) $(XML_LIBS) $(INTLLIBS)
if WITH_GUI_GTK
chmc_LDFLAGS = -Wl,-rpath,$(GTK_LIBDIR)
endif

$(build_triplet)-chmc$(EXEEXT): chmc$(EXEEXT)
	cp -a $? $@

xmltest_SOURCES = xmltest.c kwset.c obstack.c chmglib.c
xmltest_LDADD = $(GLIB_LIBS)

EXTRA_DIST = \
	lzx_layer.c \
	lzx_hash_slide.c lzx_hash_slide.h \
	lzx_slide.c lzx_slide.h
