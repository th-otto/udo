/**(TAB=0)**********************************************************************
*
*  Project name : UDO
*  Module name  : lang.c
*  Symbol prefix: lang
*
*  Description  : This file handles all language-specific, localizable strings 
*                 used by UDO. Keep in mind that the localizable strings are 
*                 UTF-8 encoded since UDO v7.
*
*  Copyright    : 1995-2001 Dirk Hagedorn
*  Open Source  : since 2001
*
*                 This program is free software; you can redistribute it and/or
*                 modify it under the terms of the GNU General Public License
*                 as published by the Free Software Foundation; either version 2
*                 of the License, or (at your option) any later version.
*                 
*                 This program is distributed in the hope that it will be useful,
*                 but WITHOUT ANY WARRANTY; without even the implied warranty of
*                 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*                 GNU General Public License for more details.
*                 
*                 You should have received a copy of the GNU General Public License
*                 along with this program; if not, write to the Free Software
*                 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*
*-------------------------------------------------------------------------------
*
*  Author       : Dirk Hagedorn (udo@dirk-hagedorn.de)
*  Co-Authors   : Ulf Dunkel (fd)
*  Write access : fd
*
*  Notes        : Please add yourself as co-author when you change this file.
*
*-------------------------------------------------------------------------------
*  Things to do : -
*
*-------------------------------------------------------------------------------
*  History:
*
*  2008:
*    fd  Nov 14: Latvian strings localized (hard encoded in windows-1257 so far)
*    fd  Nov 14: Polish strings introduced
*  2009:
*    fd  Apr 23: Polish encoding set to ISO-8859-2 (hard encoded)
*    fd  Jun 04: !docinfo [translator] introduced
*    fd  Dec 03: - Swedish month names should be used in lowercase (Karl-Johan Nor�en)
*                - more Swedish adjustments
*    fd  Dec 16: lang.translator adjusted (fr)
*  2010:
*    fd  Feb 19: - uni2ascii() renamed -> recode_udo()
*                - init_lang_date() + init_lang() generalized
*                - init_lang_date() debugged: don't recode a const string via pointer :-(
*
******************************************|************************************/

/*******************************************************************************
*
*     INCLUDE FILES
*
******************************************|************************************/

#include "import.h"
#include <stdio.h>
#include <string.h>
#include <time.h>
#include "udoport.h"

#include "version.h"                      /* IMPORTANT macros! */ 
#include "constant.h"                     /* IMPORTANT macros! */
#include "udo_type.h"                     /* several type definitions */
#include "chr.h"                          /* character code maps */
#include "toc.h"                          /* !node, !alias, !label, !toc */
#include "udo.h"                          /* global prototypes */
#include "lang_utf.h"                     /* localized strings */

#include "export.h"
#include "lang.h"





/*******************************************************************************
*
*     GLOBAL FUNCTIONS
*
******************************************|************************************/

/*******************************************************************************
*
*  init_lang_date():
*     set time and date to the desired language
*
*  Notes:
*     We have to "fool" recode() here, because iEncodingSource & iEncodingTarget
*     can be identical and thus recode() wouldn't do anything.
*
*  Out:
*     -
*
******************************************|************************************/

GLOBAL void init_lang_date(void)
{
   time_t      timer;                  /* */
   struct tm  *zeit;                   /* */
   char        month[MONTH_LEN] = "";  /* ^ month name in MONTHS[] */ 
   int         i = 0;                  /* counter for MONTHS[] */


   time(&timer);
   zeit = localtime(&timer);

   iDateDay   = zeit->tm_mday;            /* Global sichern z.B. fuer RTF */
   iDateMonth = zeit->tm_mon + 1;
   iDateYear  = zeit->tm_year + 1900;
   iDateHour  = zeit->tm_hour;
   iDateMin   = zeit->tm_min;
   iDateSec   = zeit->tm_sec;
   
   while (MONTHS[i].lan >= 0)           /* find localized month name */
   {
      if (MONTHS[i].lan == destlang)      /* desired language found */
      {                                   /* remember month name */
         strcpy(month, MONTHS[i].month[zeit->tm_mon]);
         break;                           /* done! */
      }
      
      i++;                                /* next language */
   }
   
   recode(month, CODE_UTF8, iEncodingTarget);
   
   switch (destlang)
   {
   case TOGER:                            /* German */
      sprintf(lang.today, "%d. %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOFRA:                            /* French */
      sprintf(lang.today, "%d %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOITA:                            /* Italian */
      sprintf(lang.today, "%d. %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOSWE:                            /* Swedish */
      sprintf(lang.today, "%d %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%0d-%02d-%02d", 1900+zeit->tm_year, zeit->tm_mon+1, zeit->tm_mday);
      break;

   case TOSPA:                            /* Spanish */
      sprintf(lang.today, "%d. %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TODUT:                            /* Dutch */
      sprintf(lang.today, "%d %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d-%02d-%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TODAN:                            /* Danish */
      sprintf(lang.today, "%d %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d-%02d-%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOCZE:                            /* Czech */
      sprintf(lang.today, "%d. %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOLVA:                            /* Latvian */
      sprintf(lang.today, "%d. %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOPOL:                            /* Polish */
      sprintf(lang.today, "%d. %s %d", zeit->tm_mday, month, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%02d.%02d.%d", zeit->tm_mday, zeit->tm_mon+1, 1900+zeit->tm_year);
      break;

   case TOENG:                            /* English */
   default:                               /* UDO v7: German is no longer default language! */
      sprintf(lang.today, "%s %d, %d", month, zeit->tm_mday, 1900+zeit->tm_year);
      sprintf(lang.short_today, "%0d/%02d/%02d", 1900+zeit->tm_year, zeit->tm_mon+1, zeit->tm_mday);
      break;
   }
}





/*******************************************************************************
*
*  init_lang():
*     initialize the UDO defined strings for the desired language.
*
*  Notes:
*     We have to "fool" recode() here, because iEncodingSource & iEncodingTarget
*     can be identical and thus recode() wouldn't do anything.
*
*  Out:
*     -
*
******************************************|************************************/

GLOBAL void init_lang(void)
{
   int    i = 0;    /* counter for MONTHS[] */

   memset(&lang, 0, sizeof(LANG));

   while (UDOSTRINGS[i].lan >= 0)       /* find localized month name */
   {
      if (UDOSTRINGS[i].lan == destlang)  /* desired language found */
      {
         lang = UDOSTRINGS[i].udostring;  /* copy these strings! */
         break;                           /* done! */
      }
      
      i++;                                /* next language */
   }

   init_lang_date();

   if (iEncodingTarget >= 0 && iEncodingTarget != CODE_UTF8)
   {
      recode(lang.preface,     CODE_UTF8, iEncodingTarget);
      recode(lang.chapter,     CODE_UTF8, iEncodingTarget);
      recode(lang.title,       CODE_UTF8, iEncodingTarget);
      recode(lang.appendix,    CODE_UTF8, iEncodingTarget);
      recode(lang.contents,    CODE_UTF8, iEncodingTarget);
      recode(lang.listfigure,  CODE_UTF8, iEncodingTarget);
      recode(lang.listtable,   CODE_UTF8, iEncodingTarget);
      recode(lang.figure,      CODE_UTF8, iEncodingTarget);
      recode(lang.table,       CODE_UTF8, iEncodingTarget);
      recode(lang.index,       CODE_UTF8, iEncodingTarget);
      recode(lang.page,        CODE_UTF8, iEncodingTarget);
      recode(lang.see,         CODE_UTF8, iEncodingTarget);
      recode(lang.also,        CODE_UTF8, iEncodingTarget);
      recode(lang.by,          CODE_UTF8, iEncodingTarget);
      recode(lang.fur,         CODE_UTF8, iEncodingTarget);
      recode(lang.up,          CODE_UTF8, iEncodingTarget);
      recode(lang.exit,        CODE_UTF8, iEncodingTarget);
      recode(lang.unknown,     CODE_UTF8, iEncodingTarget);
      recode(lang.update,      CODE_UTF8, iEncodingTarget);
      recode(lang.html_home,   CODE_UTF8, iEncodingTarget);
      recode(lang.html_up,     CODE_UTF8, iEncodingTarget);
      recode(lang.html_prev,   CODE_UTF8, iEncodingTarget);
      recode(lang.html_next,   CODE_UTF8, iEncodingTarget);
      recode(lang.html_lang,   CODE_UTF8, iEncodingTarget);
      recode(lang.html_start,  CODE_UTF8, iEncodingTarget);
      recode(lang.translator,  CODE_UTF8, iEncodingTarget);
      recode(lang.distributor, CODE_UTF8, iEncodingTarget);
      recode(lang.degree,      CODE_UTF8, iEncodingTarget);
   }

   toc_init_lang();
}
