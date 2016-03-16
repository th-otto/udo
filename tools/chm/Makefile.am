include ../../silent.am

INCLUDES = -I$(top_srcdir)/tools/hypview/include
AM_CPPFLAGS = $(GLIB_CFLAGS)

noinst_PROGRAMS = chmls xmltest

if !CROSS_COMPILING
noinst_SCRIPTS = $(build_triplet)-chmls$(EXEEXT)
endif

chmls_SOURCES = \
	chmls.c \
	chmbase.c chmbase.h \
	chmwriter.c chmobjinstconst.h \
	fasthtmlparser.c fasthtmlparser.h \
	htmlutil.c htmlutil.h \
	chmtypes.c chmtypes.h \
	chmstream.c chmstream.h \
	chmreader.c chmreader.h \
	chmsitemap.c chmsitemap.h \
	chmfiftimain.c chmfiftimain.h \
	chmglib.c \
	lzxdec.c lzx.h \
	xgetopt.c \
	cp_1252.h \
	chmxml.c chmxml.h htmlentity.h \
	kwset.c obstack.c \
	$(empty)
chmls_LDADD = $(GLIB_LIBS) $(INTLLIBS)

$(build_triplet)-chmls$(EXEEXT): chmls$(EXEEXT)
	cp -a $? $@

xmltest_SOURCES = xmltest.c kwset.c obstack.c
xmltest_LDADD = $(GLIB_LIBS)
