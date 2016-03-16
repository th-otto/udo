static char const testinp[] = "\
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n\
        \"http://www.w3.org/TR/html4/loose.dtd\">\n\
<!-- last modified on 2016/03/15 -->\n\
<html lang=\"en\">\n\
<head>\n\
<title>\n\
The guide of UDO: Deprecated commands\n\
</title>\n\
<meta http-equiv=\"Content-Type\" content=\"text/html;charset=Windows-1252\">\n\
<meta http-equiv=\"Content-Language\" content=\"en\">\n\
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">\n\
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">\n\
<meta name=\"Generator\" content=\"UDO Version 7.11 (1242) for Win32\">\n\
<link rev=\"made\" href=\"http://www.udo-open-source.org/contact/\" title=\"E-Mail\">\n\
<link rel=\"author\" href=\"http://www.udo-open-source.org/contact/\" title=\"E-Mail\">\n\
<link rel=\"copyright\" href=\"aboutudo.html\" title=\"UDO7\">\n\
<link rel=\"stylesheet\" type=\"text/css\" href=\"udo.css\">\n\
<link rel=\"shortcut icon\" href=\"favicon.ico\">\n\
</head>\n\
<body>\n\
\n\
<a href=\"index.html\"><img src=\"udo_hm.gif\" alt=\"Home\" title=\"Home\" border=\"0\" width=\"24\" height=\"24\"></a>\n\
<a href=\"cmds.html\"><img src=\"udo_up.gif\" alt=\"Command index\" title=\"Command index\" border=\"0\" width=\"24\" height=\"24\">Command index</a>\n\
<a href=\"cmd_backslash.html\"><img src=\"udo_lf.gif\" alt=\"!\\\" title=\"!\\\" border=\"0\" width=\"24\" height=\"24\">!\\</a>\n\
<a href=\"aboutudo.html\"><img src=\"udo_rg.gif\" alt=\"UDO7\" title=\"UDO7\" border=\"0\" width=\"24\" height=\"24\">UDO7</a>\n\
\n\
<hr>\n\
\n\
<img src=\"udo_fo.gif\" width=\"16\" height=\"13\" alt=\"\" title=\"\" border=\"0\">&nbsp;<a href=\"index.html\">The guide of UDO</a>\n\
<br><img src=\"udo_fs.gif\" width=\"20\" height=\"13\" alt=\"\" title=\"\" border=\"0\"><img src=\"udo_fo.gif\" width=\"16\" height=\"13\" alt=\"\" title=\"\" border=\"0\">&nbsp;<a href=\"cmds.html\">Command index</a>\n\
<hr>\n\
\n\
<h1><a name=\"Deprecated_20commands\">Deprecated commands</a></h1>\n\
<p>The following list shows deprecated UDO commands and switches\n\
which are no longer supported in the current version.\n\
</p>\n\
<div align=\"center\"><table border=\"1\" frame=\"box\" class=\"UDO_env_table\">\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><b>Old</b></td>\n\
  <td align=\"left\" valign=\"top\"><b>Function</b></td>\n\
  <td align=\"left\" valign=\"top\"><b>New</b></td>\n\
  <td align=\"left\" valign=\"top\"><b>Deprecated since</b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_aqv-eq.html\">!=aqv</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[aqv]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_asc-eq.html\">!=asc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[asc]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_aqv.html\">!aqv</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[aqv]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_asc.html\">!asc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[asc]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_author.html\">!author</a></td>\n\
  <td align=\"left\" valign=\"top\">define author's name</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[author]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_authorimage.html\">!authorimage</a></td>\n\
  <td align=\"left\" valign=\"top\">define author's logo for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[authorimage]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_begin_asc.html\">!begin_asc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[asc]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">5</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_begin_stg.html\">!begin_stg</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[stg]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">5</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code.html\">!code</a></td>\n\
  <td align=\"left\" valign=\"top\">define encoding of source document</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code_dos.html\">!code_dos</a></td>\n\
  <td align=\"left\" valign=\"top\">switch to another encoding</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b> oder <b><tt><a href=\"cmd_code_target.html\">!code_target</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code_hp8.html\">!code_hp8</a></td>\n\
  <td align=\"left\" valign=\"top\">switch to another encoding</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b> oder <b><tt><a href=\"cmd_code_target.html\">!code_target</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code_iso.html\">!code_iso</a></td>\n\
  <td align=\"left\" valign=\"top\">switch to another encoding</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b> oder <b><tt><a href=\"cmd_code_target.html\">!code_target</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code_mac.html\">!code_mac</a></td>\n\
  <td align=\"left\" valign=\"top\">switch to another encoding</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b> oder <b><tt><a href=\"cmd_code_target.html\">!code_target</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code_next.html\">!code_next</a></td>\n\
  <td align=\"left\" valign=\"top\">switch to another encoding</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b> oder <b><tt><a href=\"cmd_code_target.html\">!code_target</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_code_tos.html\">!code_tos</a></td>\n\
  <td align=\"left\" valign=\"top\">switch to another encoding</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_code_source.html\">!code_source</a></tt></b> oder <b><tt><a href=\"cmd_code_target.html\">!code_target</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.00</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_country.html\">!country</a></td>\n\
  <td align=\"left\" valign=\"top\">define author's country for address block in title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo [address]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_date.html\">!date</a></td>\n\
  <td align=\"left\" valign=\"top\">set date information for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo [date]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_docinfo.html\">!docinfo</a> <b><tt>webmastername</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">set webmaster name (or company, website, etc.) for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> [[domain_name</td>\n\
  <td align=\"left\" valign=\"top\">]])</td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_docinfo.html\">!docinfo</a> <b><tt>webmasterurl</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">set webmaster link (see above) for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo [domain_link]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_docinfo.html\">!docinfo</a> <b><tt>webmasteremail</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">set webmaster email (or contact page link) for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo [contact_name]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_docinfo.html\">!docinfo</a> <b><tt>webmastermailurl</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">set webmaster email or contact page link for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo [contact_link]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_drc.html\">!drc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[drc]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_begin_asc.html#UDO__21else_asc\">!else_asc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[asc]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">5</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_begin_stg.html#UDO__21else_stg\">!else_stg</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[stg]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">5</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_email.html\">!email</a></td>\n\
  <td align=\"left\" valign=\"top\">set email information for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo [contact_name]</a></tt></b> or <b><tt><a href=\"cmd_docinfo.html\">!docinfo [contact_link]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_begin_asc.html#UDO__21end_asc\">!end_asc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[asc]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">5</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_begin_stg.html#UDO__21end_stg\">!end_stg</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[stg]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">5</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_english.html\">!english</a></td>\n\
  <td align=\"left\" valign=\"top\">set language</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_language.html\">!language</a></tt></b> <b><tt>[english]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_french.html\">!french</a></td>\n\
  <td align=\"left\" valign=\"top\">set language</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_language.html\">!language</a></tt></b> <b><tt>[french]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_german.html\">!german</a></td>\n\
  <td align=\"left\" valign=\"top\">set language</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_language.html\">!language</a></tt></b> <b><tt>[german]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_htag-eq.html\">!=htag</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[htag]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html-eq.html\">!=html</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[html]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_htag.html\">!htag</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[htag]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html.html\">!html</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[html]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_frames_column_color.html\">!html_frames_column_color</a></td>\n\
  <td align=\"left\" valign=\"top\">set background color of left frame (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_frames_backcolor.html\">!html_frames_backcolor</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_frames_column_image.html\">!html_frames_column_image</a></td>\n\
  <td align=\"left\" valign=\"top\">set background image of left frame (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_frames_backimage.html\">!html_frames_backimage</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_frames_column_width.html\">!html_frames_column_width</a></td>\n\
  <td align=\"left\" valign=\"top\">set width of frame in frames layout (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_frames_width.html\">!html_frames_width</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_modern_column_color.html\">!html_modern_column_color</a></td>\n\
  <td align=\"left\" valign=\"top\">set background color in <q>modern</q> layout (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_modern_backcolor.html\">!html_modern_backcolor</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_modern_column_image.html\">!html_modern_column_image</a></td>\n\
  <td align=\"left\" valign=\"top\">set background image in <q>modern</q> layout (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_modern_backimage.html\">!html_modern_backimage</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_modern_column_width.html\">!html_modern_column_width</a></td>\n\
  <td align=\"left\" valign=\"top\">set width of left column in <q>modern</q> layout (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_modern_width.html\">!html_modern_width</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_html_use_xlist.html\">!html_use_xlist</a></td>\n\
  <td align=\"left\" valign=\"top\">output <a href=\"style_lists.html#xlist_20environment\">xlist environment</a> like <a href=\"format_asc.html\">ASCII</a> (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_xlist.html\">!use_xlist [html]</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_htmlkeywords.html\">!htmlkeywords</a></td>\n\
  <td align=\"left\" valign=\"top\">set <a href=\"format_html.html#HTML\">HTML</a> meta keywords</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_keywords.html\">!html_keywords</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_htmlname.html\">!htmlname</a></td>\n\
  <td align=\"left\" valign=\"top\">assign file name (<a href=\"format_html.html#HTML\">HTML</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_html_name.html\">!html_name</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_info-eq.html\">!=info</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[info]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_image().html\">(!image)</a></td>\n\
  <td align=\"left\" valign=\"top\">output image</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_image.html\">!image</a></tt></b>, <b><tt><a href=\"cmd_image_asterisk.html\">!image*</a></tt></b>, <b><tt><a href=\"cmd_img().html\">(!img)</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_info.html\">!info</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[info]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_italian.html\">!italian</a></td>\n\
  <td align=\"left\" valign=\"top\">set language</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_language.html\">!language</a></tt></b> <b><tt>[italian]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_jumpid.html\">!jumpid</a></td>\n\
  <td align=\"left\" valign=\"top\">output a node ID (<a href=\"format_winhelp.html\">WinHelp</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_win_helpid.html\">!win_helpid</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_keyword.html\">!keyword</a></td>\n\
  <td align=\"left\" valign=\"top\">set index entry or keyword</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_index.html\">!index</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_ldoc-eq.html\">!=ldoc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[ldoc]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_ldoc.html\">!ldoc</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[ldoc]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_list_parsep.html\">!list_parsep</a></td>\n\
  <td align=\"left\" valign=\"top\">compress <a href=\"basics_environments.html#environments\">environments</a></td>\n\
  <td align=\"left\" valign=\"top\"><b><a href=\"cmd_short.html\">!short</a></b> &gt; <b><tt><a href=\"cmd_compressed.html\">!compressed</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 &gt; 7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_list_parsep_off.html\">!list_parsep_off</a></td>\n\
  <td align=\"left\" valign=\"top\">compress <a href=\"basics_environments.html#environments\">environments</a></td>\n\
  <td align=\"left\" valign=\"top\"><b><a href=\"cmd_short.html\">!short</a></b> &gt; <b><tt><a href=\"cmd_compressed.html\">!compressed</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 &gt; 7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_list_parsep_on.html\">!list_parsep_on</a></td>\n\
  <td align=\"left\" valign=\"top\">compress <a href=\"basics_environments.html#environments\">environments</a></td>\n\
  <td align=\"left\" valign=\"top\"><b><a href=\"cmd_short.html\">!short</a></b> &gt; <b><tt><a href=\"cmd_compressed.html\">!compressed</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 &gt; 7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_man-eq.html\">!=man</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[man]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_man.html\">!man</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[man]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_no_toc_subnodes.html\">!no_toc_subnodes</a></td>\n\
  <td align=\"left\" valign=\"top\">don't list subnodes in table of contents</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ignore_subtoc.html\">!ignore_subtoc</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_no_toc_subsubnodes.html\">!no_toc_subsubnodes</a></td>\n\
  <td align=\"left\" valign=\"top\">don't list subsubnodes in table of contents</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ignore_subsubtoc.html\">!ignore_subsubtoc</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_no_toc_subsubsubnodes.html\">!no_toc_subsubsubnodes</a></td>\n\
  <td align=\"left\" valign=\"top\">don't list subsubsubnodes in table of contents</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ignore_subsubsubtoc.html\">!ignore_subsubsubtoc</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_pch-eq.html\">!=pch</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[pch]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_pdf-eq.html\">!=pdf</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[pdf]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_pch.html\">!pch</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[pch]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_pdf.html\">!pdf</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[pdf]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_program.html\">!program</a></td>\n\
  <td align=\"left\" valign=\"top\">define program name for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[program]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_programimage.html\">!programimage</a></td>\n\
  <td align=\"left\" valign=\"top\">define program image (icon) for title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[programimage]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_rtf-eq.html\">!=rtf</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[rtf]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_rtf.html\">!rtf</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[rtf]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_stg-eq.html\">!=stg</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[stg]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_short.html\">!short</a></td>\n\
  <td align=\"left\" valign=\"top\">compress environment output</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_compressed.html\">!compressed</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_spanish.html\">!spanish</a></td>\n\
  <td align=\"left\" valign=\"top\">set language</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_language.html\">!language</a></tt></b> <b><tt>[spanish]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_stg.html\">!stg</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[stg]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_stg_no_database.html\">!stg_no_database</a></td>\n\
  <td align=\"left\" valign=\"top\">don't output database line (<a href=\"format_stg.html\">ST-Guide</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[stgdatabase]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_stg_parwidth.html\">!stg_parwidth</a></td>\n\
  <td align=\"left\" valign=\"top\">set line width (<a href=\"format_stg.html\">ST-Guide</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_parwidth.html\">!parwidth</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_street.html\">!street</a></td>\n\
  <td align=\"left\" valign=\"top\">set author's street for address block in title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[address]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_swedish.html\">!swedish</a></td>\n\
  <td align=\"left\" valign=\"top\">set language</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_language.html\">!language</a></tt></b> <b><tt>[swedish]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_tex-eq.html\">!=tex</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[tex]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_tex.html\">!tex</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[tex]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_tex_book.html\">!tex_book</a></td>\n\
  <td align=\"left\" valign=\"top\">output target file as <q>book</q></td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_style_book.html\">!use_style_book</a></tt></b> <b><tt>[tex]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_title.html\">!title</a></td>\n\
  <td align=\"left\" valign=\"top\">define document title</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[title]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_town.html\">!town</a></td>\n\
  <td align=\"left\" valign=\"top\">set author's hometown for address block in title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[address]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_udoinfo.html\">!udoinfo</a></td>\n\
  <td align=\"left\" valign=\"top\">output information page about UDO</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_about_udo.html\">!use_about_udo</a></tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_use_justified.html\">!use_justified</a></td>\n\
  <td align=\"left\" valign=\"top\">use justification</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_justification.html\">!use_justification</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\">!use_short_descriptions</td>\n\
  <td align=\"left\" valign=\"top\">compress environment output</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_compressed_descriptions.html\">!use_compressed_descriptions</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\">!use_short_enumerates</td>\n\
  <td align=\"left\" valign=\"top\">compress environment output</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_compressed_enumerates.html\">!use_compressed_enumerates</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_use_short_envs.html\">!use_short_envs</a></td>\n\
  <td align=\"left\" valign=\"top\">compress environment output</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_compressed_envs.html\">!use_compressed_envs</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\">!use_short_itemizes</td>\n\
  <td align=\"left\" valign=\"top\">compress environment output</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_compressed_itemizes.html\">!use_compressed_itemizes</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\">!use_short_lists</td>\n\
  <td align=\"left\" valign=\"top\">compress environment output</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_use_compressed_lists.html\">!use_compressed_lists</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">7.01</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_use_xlist.html\">!use_xlist</a></td>\n\
  <td align=\"left\" valign=\"top\">output xlist <a href=\"basics_environments.html#environments\">environments</a> like <a href=\"format_asc.html\">ASCII</a></td>\n\
  <td align=\"left\" valign=\"top\">kein Ersatzkommando, xlist-Ausgabeformatierung ge&auml;ndert</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_verbatim_no_umlaute.html\">!verbatim_no_umlaute</a></td>\n\
  <td align=\"left\" valign=\"top\">don't output umlauts in verbatim <a href=\"basics_environments.html#environments\">environments</a></td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_no_verbatim_umlaute.html\">!no_verbatim_umlaute</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6.0</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_version.html\">!version</a></td>\n\
  <td align=\"left\" valign=\"top\">set program version number for the title page</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_docinfo.html\">!docinfo</a></tt></b> <b><tt>[version]</tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_win-eq.html\">!=win</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifndest.html\">!ifndest</a></tt></b> <b><tt>[win]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_win.html\">!win</a></td>\n\
  <td align=\"left\" valign=\"top\">query output format</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_ifdest.html\">!ifdest</a></tt></b> <b><tt>[win]</tt></b></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_win_background.html\">!win_background</a></td>\n\
  <td align=\"left\" valign=\"top\">define background color for <a href=\"format_winhelp.html\">WinHelp</a></td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_win_backcolor.html\">!win_backcolor</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6 PL14</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
<tr>\n\
  <td align=\"left\" valign=\"top\"><a href=\"cmd_win_html_look.html\">!win_html_look</a></td>\n\
  <td align=\"left\" valign=\"top\">output pages with gray background (<a href=\"format_winhelp.html\">WinHelp</a> only)</td>\n\
  <td align=\"left\" valign=\"top\"><b><tt><a href=\"cmd_win_backcolor.html\">!win_backcolor</a></tt></b>, <b><tt><a href=\"cmd_win_propfont.html\">!win_propfont</a></tt></b>, <b><tt><a href=\"cmd_win_monofont.html\">!win_monofont</a></tt></b></td>\n\
  <td align=\"left\" valign=\"top\">6</td>\n\
  <td align=\"center\" valign=\"top\"></td>\n\
</tr>\n\
</table>\n\
</div>\n\
\n\
<span class=\"page-break\"></span>\n\
<hr>\n\
\n\
<address>Copyright &copy; <a href=\"http://www.udo-open-source.org/\">www.udo-open-source.org</a> (<a href=\"http://www.udo-open-source.org/contact/\">http://www.udo-open-source.org/contact/</a>)<br>\n\
Last updated on March 15, 2016</address>\n\
\n\
<hr>\n\
\n\
<a href=\"index.html\"><img src=\"udo_hm.gif\" alt=\"Home\" title=\"Home\" border=\"0\" width=\"24\" height=\"24\"></a>\n\
<a href=\"cmds.html\"><img src=\"udo_up.gif\" alt=\"Command index\" title=\"Command index\" border=\"0\" width=\"24\" height=\"24\">Command index</a>\n\
<a href=\"cmd_backslash.html\"><img src=\"udo_lf.gif\" alt=\"!\\\" title=\"!\\\" border=\"0\" width=\"24\" height=\"24\">!\\</a>\n\
<a href=\"aboutudo.html\"><img src=\"udo_rg.gif\" alt=\"UDO7\" title=\"UDO7\" border=\"0\" width=\"24\" height=\"24\">UDO7</a>\n\
</body>\n\
</html>\n\
";
