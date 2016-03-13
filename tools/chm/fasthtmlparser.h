#ifndef __FASTHTMLPARSER_H__
#define __FASTHTMLPARSER_H__ 1

/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    FastHTMLParser unit to parse HTML
                  (disect html into its tags and text.)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 TITLE        : Fast HTML Parser (modified)
 CLASS        : TjsFastHTMLParser
 VERSION      : 0.4La

 AUTHOR       : James Azarja
                http://www.jazarsoft.com/

 CONTRIBUTORS : L505
                http://z505.com

                YourName Here...


 LEGAL        : Copyright (C) 2004 Jazarsoft, All Rights Reserved.
                Modified 2005 Lars (L505)

--------------------------------------------------------------------------------

  - Modified for use as a pure command line unit (no dialogs) for freepascal.
  - Also added UPPERCASE tags so that when you check for <font> it returns all
    tags like <FONT> and <FoNt> and <font>

 Use it for what reasons:
    -make your own web browsers,
    -make your own text copies of web pages for caching purposes
    -Grab content from websites -without- using regular expressions
    -Seems to be MUCH MUCH FASTER than regular expressions, as it is after all
     a true parser
    -convert website tables into spreadsheets (parse <TD> and <TR>, turn in to
     CSV or similar)
    -convert websites into text files (parse all text, and tags <BR> <P> )
    -convert website tables into CSV/Database (<parse <TD> and <TR>)
    -find certain info from a web page.. i.e. all the bold text or hyperlinks in
     a page.
    -Parse websites remotely from a CGI app using something like Sockets or
     Synapse and SynWrap to first get the HTML site. This would allow you to
     dynamically parse info from websites and display data on your site in real
     time.
    -HTML editor.. WYSIWYG or a partial WYSIWYG editor. Ambitious, but possible.
    -HTML property editor. Not completely wysiwyg but ability to edit proprties
     of tags. Work would need to be done to parse each property in a tag.


--------------------------------------------------------------------------------
 LICENSE/TERMS
--------------------------------------------------------------------------------

 This code may be used and modified by anyone so long as  this header and
 copyright  information remains intact.

 The code is provided "AS-IS" and without WARRANTY OF ANY KIND,
 expressed, implied or otherwise, including and without limitation, any
 warranty of merchantability or fitness for a  particular purpose. 

 In no event shall the author be liable for any special, incidental,
 indirect or consequential damages whatsoever (including, without
 limitation, damages for loss of profits, business interruption, loss
 of information, or any other loss), whether or not advised of the
 possibility of damage, and on any theory of liability, arising out of
 or in connection with the use or inability to use this software.  


--------------------------------------------------------------------------------
 HISTORY:
--------------------------------------------------------------------------------

 0.1     -  James:
             Initial Development
             mostly based on Peter Irlam works & ideas

 0.2     -  James:
             Some minor bug has fixed

 0.3     -  James:
             Some jsHTMLUtil function bug has been fixed

 0.4     -  James:
             jsHTMLUtil Tag Attributes bug has been fixed
             thanks to Dmitry [mail@vader.ru]

 0.4L.1a -  L505:
             Made unit work with freepascal, added UPCASE (case insensitive)
             exec function

 0.4L.1b -  L505:
             Changed case insensitive version to a new class instead of
             the old ExecUpcase
*/

typedef struct _TObject TObject;

/*
 * when tag content found in HTML, including names and values
 * case insensitive analysis available via NoCaseTag
 */
typedef void (*TOnFoundTag)(const char *ActualTag, size_t len);

/*
 * when text found in the HTML
 */
typedef void (*TOnFoundText)(const char *Text, size_t len);

typedef struct _HTMLParser {
/* private: */
	gboolean Done;
/* public: */
	TOnFoundTag OnFoundTag;
	TOnFoundText OnFoundText;
	const char *Raw;
	const char *FCurrent;
} HTMLParser;

HTMLParser *HTMLParser_Create(const char *sRaw);
void HTMLParser_Exec(HTMLParser *parser);
void HTMLParser_Destroy(HTMLParser *parser);

size_t HTMLParser_CurrentPos(HTMLParser *parser);

void HTMLParser_NilOnFoundTag(const char *ActualTag, size_t len);
void HTMLParser_NilOnFoundText(const char *Text, size_t len);

#endif /* __FASTHTMLPARSER_H__ */
