include ../Makefile.common

EXTRA_DIST = \
	hypview.h  hypview.ico \
	back.h     back.ico \
	help.h     help.ico \
	home.h     home.ico \
	index.h    index.ico \
	info.h     info.ico \
	katalog.h  katalog.ico \
	load.h     load.ico \
	memory.h   memory.ico \
	menu.h     menu.ico \
	history.h  history.ico \
	next.h     next.ico \
	previous.h previous.ico \
	referenc.h referenc.ico \
	save.h     save.ico \
	$(empty)

icons: \
	$(srcdir)/hypview.h \
	$(srcdir)/back.h \
	$(srcdir)/help.h \
	$(srcdir)/home.h \
	$(srcdir)/index.h \
	$(srcdir)/info.h \
	$(srcdir)/katalog.h \
	$(srcdir)/load.h \
	$(srcdir)/memory.h \
	$(srcdir)/menu.h \
	$(srcdir)/history.h \
	$(srcdir)/next.h \
	$(srcdir)/previous.h \
	$(srcdir)/referenc.h \
	$(srcdir)/save.h \
	$(empty)

GEN_PIXBUF_CSOURCE = gen-pixbuf-csource

$(srcdir)/hypview.h: $(srcdir)/hypview.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=hypview_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/back.h: $(srcdir)/back.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=back_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/help.h: $(srcdir)/help.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=help_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/home.h: $(srcdir)/home.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=home_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/index.h: $(srcdir)/index.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=index_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/info.h: $(srcdir)/info.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=info_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/katalog.h: $(srcdir)/katalog.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=katalog_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/load.h: $(srcdir)/load.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=load_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/memory.h: $(srcdir)/memory.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=memory_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/menu.h: $(srcdir)/menu.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=menu_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/history.h: $(srcdir)/history.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=history_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/next.h: $(srcdir)/next.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=next_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/previous.h: $(srcdir)/previous.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=previous_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/referenc.h: $(srcdir)/referenc.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=reference_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

$(srcdir)/save.h: $(srcdir)/save.ico
	$(AM_V_GEN)$(GEN_PIXBUF_CSOURCE) --raw --static --name=save_icon_data $< > $@.tmp && mv $@.tmp $@ || { $(RM) $@.tmp; false; }

