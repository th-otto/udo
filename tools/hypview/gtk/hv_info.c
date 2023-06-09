#include "hv_gtk.h"
#include "hypdebug.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void message_destroyed(GtkWidget *w, GtkWidget *dialog)
{
	UNUSED(w);
	check_toplevels(dialog);
}

/*** ---------------------------------------------------------------------- ***/

static void expander_toggled(GtkWidget *w, GtkWidget *dialog)
{
	UNUSED(w);
	UNUSED(dialog);
	gl_profile.viewer.detail_info = !gl_profile.viewer.detail_info;
	HypProfile_SetChanged();
}

/*** ---------------------------------------------------------------------- ***/

static void help_clicked(GtkWidget *w, WINDOW_DATA *win)
{
	UNUSED(w);
	Help_Contents(win);
}

/*** ---------------------------------------------------------------------- ***/

void DocumentInfos(WINDOW_DATA *win)
{
	DOCUMENT *doc = win->data;
	GtkWidget *dialog, *vbox, *label;
	GtkWidget *button;
	GtkWidget *expander, *frame;
	char *str;
	
	dialog = gtk_dialog_new();
	g_object_set_data(G_OBJECT(dialog), "hypview_window_type", NO_CONST("message"));
	g_signal_connect(G_OBJECT(dialog), "destroy", G_CALLBACK(message_destroyed), dialog);
	gtk_window_set_title(GTK_WINDOW(dialog), _("File Info"));
	gtk_window_set_modal(GTK_WINDOW(dialog), FALSE);
	gtk_window_set_position(GTK_WINDOW(dialog), GTK_WIN_POS_MOUSE);
	/* needed ot make the dialog shrink when the expander is closed */
	gtk_window_set_resizable(GTK_WINDOW(dialog), FALSE);
	
	vbox = gtk_vbox_new(FALSE, 0);
	gtk_container_set_border_width(GTK_CONTAINER(vbox), 15);
	gtk_box_pack_start(GTK_BOX(gtk_dialog_get_content_area(GTK_DIALOG(dialog))), vbox, TRUE, TRUE, 0);

#if 0
	{
	str = g_strdup_printf("%s %s", gl_program_name, gl_program_version);
	label = gtk_label_new(str);
	gtk_misc_set_alignment(GTK_MISC(label), 0.0, 0.5);
	gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);
	g_free(str);
	str = g_strdup_printf(_("from: %s"), gl_compile_date);
	label = gtk_label_new(str);
	gtk_misc_set_alignment(GTK_MISC(label), 0.0, 0.5);
	gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);
	g_free(str);
	}
#endif

	str = g_strdup_printf(_("File: %s"), hyp_basename(doc->path));
	label = gtk_label_new(str);
	gtk_misc_set_alignment(GTK_MISC(label), 0.0, 0.5);
	gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);
	g_free(str);

	if (doc->type == HYP_FT_HYP)
	{
		HYP_HOSTNAME *h;
		HYP_DOCUMENT *hyp = (HYP_DOCUMENT *)doc->data;

		str = g_strdup_printf(_("Topic    : %s\n"
		                        "Author   : %s\n"
		                        "Version  : %s\n"
		                        "Subject  : %s\n"
		                        "Language : %s%s\n"),
		                        fixnull(hyp->database),
		                        fixnull(hyp->author),
		                        fixnull(hyp->version),
		                        fixnull(hyp->subject),
		                        fixnull(hyp->language),
		                        hyp->language_guessed ? _(" (guessed)") : "");
		label = gtk_label_new(str);
		gtk_misc_set_alignment(GTK_MISC(label), 0.0, 0.5);
		gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);
		g_free(str);
		
		expander = gtk_expander_new(_("Details"));
		gtk_box_pack_start(GTK_BOX(vbox), expander, FALSE, FALSE, 0);
		frame = gtk_frame_new(NULL);
		gtk_container_add(GTK_CONTAINER(expander), frame);
		vbox = gtk_vbox_new(FALSE, 0);
		gtk_container_set_border_width(GTK_CONTAINER(vbox), 15);
		gtk_container_add(GTK_CONTAINER(frame), vbox);
		g_signal_connect(G_OBJECT(expander), "activate", G_CALLBACK(expander_toggled), dialog);
		gtk_expander_set_expanded(GTK_EXPANDER(expander), gl_profile.viewer.detail_info);
		
		str = g_strdup_printf(_("Nodes       : %7u\n"
		                        "Index Size  : %7ld\n"
		                        "HCP-Version : %3u\n"
		                        "Compiled on : %s\n"
		                        "@charset    : %s\n"
		                        "@default    : %s\n"
		                        "@help       : %s\n"
		                        "@options    : %s\n"
		                        "@width      : %3u"),
		                        hyp->num_index,
		                        hyp->itable_size,
		                        hyp->comp_vers,
		                        hyp_osname(hyp->comp_os),
		                        hyp_charset_name(hyp->comp_charset),
		                        fixnull(hyp->default_name),
		                        fixnull(hyp->help_name),
		                        fixnull(hyp->hcp_options),
		                        hyp->line_width);
		label = gtk_label_new(str);
		gtk_misc_set_alignment(GTK_MISC(label), 0.0, 0.5);
		gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);
		g_free(str);
		
		for (h = hyp->hostname; h != NULL; h = h->next)
		{
			str = g_strdup_printf(_("@hostname   : %s"), h->name);
			label = gtk_label_new(str);
			gtk_misc_set_alignment(GTK_MISC(label), 0.0, 0.5);
			gtk_box_pack_start(GTK_BOX(vbox), label, FALSE, FALSE, 0);
			g_free(str);
		}
	}
	
	button = gtk_button_new_help();
	gtk_dialog_add_action_widget(GTK_DIALOG(dialog), button, GTK_RESPONSE_HELP);
	gtk_widget_set_can_default(button, TRUE);
	gtk_button_box_set_child_secondary(GTK_BUTTON_BOX(gtk_dialog_get_action_area(GTK_DIALOG(dialog))), button, TRUE);
	g_signal_connect(G_OBJECT(button), "clicked", G_CALLBACK(help_clicked), win);
	
	button = gtk_button_new_ok();
	gtk_dialog_add_action_widget(GTK_DIALOG(dialog), button, GTK_RESPONSE_OK);
	gtk_widget_set_can_default(button, TRUE);
	g_signal_connect_swapped(G_OBJECT(button), "clicked", G_CALLBACK(gtk_widget_destroy), dialog);
	gtk_widget_grab_default(button);

	gtk_window_set_transient_for(GTK_WINDOW(dialog), GTK_WINDOW(win));
	gtk_widget_show_all(dialog);
}
