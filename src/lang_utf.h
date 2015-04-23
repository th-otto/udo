/**(TAB=0)**********************************************************************
*
*  Project name : UDO
*  Module name  : lang_utf.h
*  Symbol prefix: lang
*
*  Description  : This file handles all language-specific, localizable strings 
*                 used by UDO. Keep in mind that the localizable strings are 
*                 UTF-8 encoded since UDO v7. - Again:
*
*         --->    THIS FILE IS UTF-8 ENCODED !!!   <---
*         --->    THIS FILE IS UTF-8 ENCODED !!!   <---
*         --->    THIS FILE IS UTF-8 ENCODED !!!   <---
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
*  Localizators : cs:  Petr Jandík, CZ-PRAHA
*                 da:  Henning Nymand, DK-NORRE ALSLEV
*                 de:  <various UDO developers>
*                 en:  <various UDO developers>
*                 es:  Manuel Angel Amaro Carmona, Venezuela (dassault.sis@gmail.com)
*                 fr:  corrections by Didier Briel (ddc@imaginet.fr)
*                 it:  - g.morando@agora.stm.it
*                      - Sergio Febo, IT
*                 ja:  Koichi MATSUMOTO
*                 lv:  Mārtiņš Zemzaris, LV
*                 nl:  - Rogier Cobben (rogier_cobben@nextjk.stuyts.nl)
*                      - Paul Pasveer, NL-LEEUWARDEN
*                      - Alexander Henket, NL-ROTTERDAM
*                 pl:  Dominik Siecinski, PL-LESZNO
*                 sv:  Karl-Johan Norén, SE-VÄRNAMO
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
*  2010:
*    fd  Feb 19: file introduced (extracted from LANG.C)
*    fd  May 19: new: LANG.degree
*    fd  Sep 11: tiny adjustments to esp. better reflect multiple translators
*  2011:
*    fd  Aug 09: more nl strings adjusted
*    fd  Aug 29: more es strings adjusted by Angel Carmona
*  2012:
*    fd  Feb 01: html_home localized to Spanish
*  2013:
*    fd  Feb 15: Japanese added (Microsoft Translator; not verified yet)
*    fd  May 02: UDOSTRINGS resorted
*    fd  Jun 03: some Japanese strings updated (by Koichi MATSUMOTO)
*
******************************************|************************************/

/*******************************************************************************
*
*     INCLUDE FILES
*
******************************************|************************************/

#include "constant.h"                     /* TOGER, etc. */
#include "udo_type.h"                     /* LANG */




/*******************************************************************************
*
*     MACRO DEFINITIONS
*
******************************************|************************************/

#define MONTH_LEN  50                     /* Byte (!) length of localized month name */





/*******************************************************************************
*
*     TYPE DEFINITIONS
*
******************************************|************************************/

typedef struct _months
{
   int    lan;                            /* TOGER, etc. */
   char   month[12][MONTH_LEN];           /* 12, of course ;-)) */
}  _MONTHS;


typedef struct _udostrings
{
   int          lan;                      /* TOGER, etc. */
   const LANG   udostring;                /* localized UDO strings (UDO_TYPE.H) */
}  _UDOSTRINGS;





/*******************************************************************************
*
*     GLOBAL INITIALIZED CONSTANTS
*
******************************************|************************************/

LOCAL _MONTHS const MONTHS[] =                      /* localized months names */
{
   {TOCZE, {"ledna",    "února",     "března", "dubna",    "kvítna", "června",   "července", "srpna",    "září",       "října",       "listopadu", "prosince" }},
   {TODAN, {"Januar",   "Februar",   "Marts",  "April",    "Maj",    "Juni",     "Juli",     "August",   "September",  "Oktober",     "November",  "December" }},
   {TODUT, {"januari",  "februari",  "maart",  "april",    "mei",    "juni",     "juli",     "augustus", "september",  "oktober",     "november",  "december" }},
   {TOENG, {"January",  "February",  "March",  "April",    "May",    "June",     "July",     "August",   "September",  "October",     "November",  "December" }},
   {TOFIN, {"January",  "February",  "March",  "April",    "May",    "June",     "July",     "August",   "September",  "October",     "November",  "December" }},
   {TOFRA, {"janvier",  "février",   "mars",   "avril",    "mai",    "juin",     "juillet",  "août",     "septembre",  "octobre",     "novembre",  "décembre" }},
   {TOGER, {"Januar",   "Februar",   "März",   "April",    "Mai",    "Juni",     "Juli",     "August",   "September",  "Oktober",     "November",  "Dezember" }},
   {TOITA, {"Gennaio",  "Febbraio",  "Marzo",  "Aprile",   "Maggio", "Giugno",   "Luglio",   "Agosto",   "Settembre",  "Ottobre",     "Novembre",  "Dicembre" }},
   {TOJAP, {"1 月",     "2 月",      "3 月",   "4 月",     "5 月",   "6 月",     "7 月",     "8 月",     "9 月",       "10 月",       "11 月",     "12 月" }},
   {TOLVA, {"Janvāris", "Februāris", "Marts",  "Aprīlis",  "Maijs",  "Jūnijs",   "Jūlijs",   "Augusts",  "Septembris", "Oktobris",    "Novembris", "Decembris" }},
   {TONOR, {"January",  "February",  "March",  "April",    "May",    "June",     "July",     "August",   "September",  "October",     "November",  "December" }},
   {TOPOL, {"styczeń",  "luty",      "marzec", "kwiecień", "maj",    "czerwiec", "lipiec",   "sierpień", "wrzesień",   "październik", "listopad",  "grudzień" }},
   {TOPOR, {"January",  "February",  "March",  "April",    "May",    "June",     "July",     "August",   "September",  "October",     "November",  "December" }},
   {TOSPA, {"Enero",    "Febrero",   "Marzo",  "Abril",    "Mayo",   "Junio",    "Julio",    "Agosto",   "Septiembre", "Octubre",     "Noviembre", "Diciembre" }},
   {TOSWE, {"januari",  "februari",  "mars",   "april",    "maj",    "juni",     "juli",     "augusti",  "september",  "oktober",     "november",  "december" }},
   
   {  -1, {"", "", "", "", "", "", "", "", "", "", "", ""} }
};





LOCAL _UDOSTRINGS const UDOSTRINGS[] =              /* localized UDO strings */
{
   /*
    * Note: The comments here are LEFT to the values, because you may 
    * ----- want to see and edit this file in a 1-byte C sourcecode editor,
    *       which shows Unicode characters as various numbers of bytes
    */
    
   {
      TOCZE,                              /* Czech */
      {
         /* preface     */    "Předmluva",
         /* chapter     */    "Kapitola",
         /* title       */    "Titul",
         /* appendix    */    "Příloha",
         /* contents    */    "Obsah",
         /* listfigure  */    "Seznam obrázků",
         /* listtable   */    "Seznam tabulek",
         /* figure      */    "Obrázek",
         /* table       */    "Tabulka",
         /* index       */    "Rejstřík",
         /* page        */    "strana",
         /* see         */    "viz",
         /* also        */    "viz též",
         /* by          */    "",
         /* fur         */    "pro",
         /* up          */    "Nahoru",
         /* exit        */    "Odchod",
         /* unknown     */    "Není známo",
         /* update      */    "Poslední aktualizace",
         /* lcid        */    "0x405",
         /* html_home   */    "Domů",
         /* html_up     */    "Nahoru",
         /* html_prev   */    "Předchozí",
         /* html_next   */    "Následující",
         /* html_lang   */    "cs",
         /* html_start  */    "Začátek dokumentu",
         /* translator  */    "Překládání:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "czech",
         /* lyx_langname */   "czech",
         /* degree      */    "stupeň",
         "",""
      }
   },
   {
      TODAN,                              /* Danish */
      {
         /* preface     */    "Forord",
         /* chapter     */    "Kapitel",
         /* title       */    "Titel",
         /* appendix    */    "Tillæg",
         /* contents    */    "Indhold",
         /* listfigure  */    "Figur liste",
         /* listtable   */    "Tabel liste",
         /* figure      */    "Figur",
         /* table       */    "Tabel",
         /* index       */    "Indeks",
         /* page        */    "Side",
         /* see         */    "se",
         /* also        */    "se også",
         /* by          */    "af",
         /* fur         */    "for",
         /* up          */    "&Op",
         /* exit        */    "&Udgang",
         /* unknown     */    "ukendt",
         /* update      */    "sidst opdateret den",
         /* lcid        */    "0x406",
         /* html_home   */    "Hjem",
         /* html_up     */    "Op",
         /* html_prev   */    "Tidligere",
         /* html_next   */    "næste",
         /* html_lang   */    "da",
         /* html_start  */    "start af dokument",
         /* translator  */    "Oversættelse:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "danish",
         /* lyx_langname */   "danish",
         /* degree      */    "grad",
         "",""
      }
   },
   {
      TODUT,                              /* Dutch */
      {
         /* preface     */    "Voorwoord",
         /* chapter     */    "Hoofdstuk",
         /* title       */    "Titel",
         /* appendix    */    "Bijlage",
         /* contents    */    "Inhoud",
         /* listfigure  */    "Afbeeldingenlijst",
         /* listtable   */    "Tabellenlijst",
         /* figure      */    "Afbeelding",
         /* table       */    "Tabel",
         /* index       */    "Index",
         /* page        */    "bladzijde",
         /* see         */    "zie",
         /* also        */    "ook",
         /* by          */    "door",
         /* fur         */    "voor",
         /* up          */    "&Omhoog",
         /* exit        */    "Beëi&ndigen",
         /* unknown     */    "Onbekend",
         /* update      */    "Laatst gewijzigd op",
         /* lcid        */    "0x413",
         /* html_home   */    "Start",
         /* html_up     */    "Omhoog",
         /* html_prev   */    "Vorige",
         /* html_next   */    "Volgende",
         /* html_lang   */    "nl",
         /* html_start  */    "Begin van het document",
         /* translator  */    "Vertaling:",
         /* distributor */    "Distributeur:",
         /* tex_stylename */  "dutch",
         /* lyx_langname */   "dutch",
         /* degree      */    "graad",
         "",""
      }
   },
   {
      TOENG,                              /* English */
      {
         /* preface     */    "Preface",
         /* chapter     */    "Chapter",
         /* title       */    "Title",
         /* appendix    */    "Appendix",
         /* contents    */    "Contents",
         /* listfigure  */    "List of Figures",
         /* listtable   */    "List of Tables",
         /* figure      */    "Figure",
         /* table       */    "Table",
         /* index       */    "Index",
         /* page        */    "page",
         /* see         */    "see",
         /* also        */    "see also",
         /* by          */    "by",
         /* fur         */    "for",
         /* up          */    "&Up",
         /* exit        */    "E&xit",
         /* unknown     */    "Unknown",
         /* update      */    "Last updated on",
         /* lcid        */    "0x409",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "en",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Translation:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "english",
         /* lyx_langname */   "english",
         /* degree      */    "degree",
         "",""
      }
   },
   {
      TOFIN,                              /* Finnish */
      {
         /* preface     */    "Esipuhe",
         /* chapter     */    "Luku",
         /* title       */    "Title",
         /* appendix    */    "Liite",
         /* contents    */    "Sisältö",
         /* listfigure  */    "Kuvat",
         /* listtable   */    "Taulukot",
         /* figure      */    "Kuva",
         /* table       */    "Taulukko",
         /* index       */    "Hakemisto",
         /* page        */    "Sivu",
         /* see         */    "katso",
         /* also        */    "katso myös",
         /* by          */    "by",
         /* fur         */    "for",
         /* up          */    "&Up",
         /* exit        */    "E&xit",
         /* unknown     */    "Unknown",
         /* update      */    "Last updated on",
         /* lcid        */    "0x40b",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "fi",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Kääntäminen:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "finnish",
         /* lyx_langname */   "finnish",
         /* degree      */    "aste",
         "",""
      }
   },
   {
      TOFRA,                              /* French */
      {
         /* preface     */    "Préface",
         /* chapter     */    "Chapitre",
         /* title       */    "Titre",
         /* appendix    */    "Annexe",
         /* contents    */    "Sommaire",
         /* listfigure  */    "Table des figures",
         /* listtable   */    "Liste des tableaux",
         /* figure      */    "Figure",
         /* table       */    "Tableau",
         /* index       */    "Index",
         /* page        */    "page",
         /* see         */    "voir",
         /* also        */    "voir aussi",
         /* by          */    "de",
         /* fur         */    "pour",
         /* up          */    "&Haut",
         /* exit        */    "&Fin",
         /* unknown     */    "Inconnu",
         /* update      */    "Dernière mise à jour le",
         /* lcid        */    "0x40c",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "fr",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Traduction :",
         /* distributor */    "Distribution :",
         /* tex_stylename */  "french",
         /* lyx_langname */   "french",
         /* degree      */    "degré",
         "",""
      }
   },
   {
      TOGER,                              /* German */
      {
         /* preface     */    "Vorwort",
         /* chapter     */    "Kapitel",
         /* title       */    "Titel",
         /* appendix    */    "Anhang",
         /* contents    */    "Inhaltsverzeichnis",
         /* listfigure  */    "Abbildungsverzeichnis",
         /* listtable   */    "Tabellenverzeichnis",
         /* figure      */    "Abbildung",
         /* table       */    "Tabelle",
         /* index       */    "Index",
         /* page        */    "Seite",
         /* see         */    "siehe",
         /* also        */    "siehe auch",
         /* by          */    "von",
         /* fur         */    "für",
         /* up          */    "Hoch",
         /* exit        */    "Beenden",
         /* unknown     */    "Unbekannt",
         /* update      */    "Letzte Aktualisierung am",
         /* lcid        */    "0x407",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "de",
         /* html_start  */    "Beginn des Dokumentes",
         /* translator  */    "Übersetzung:",
         /* distributor */    "Vertrieb:",
         /* tex_stylename */  "german,a4",
         /* lyx_langname */   "german",
         /* degree      */    "Grad",
         "",""
      }
   },
   {
      TOITA,                              /* Italian */
      {
         /* preface     */    "Prefazione",
         /* chapter     */    "Capitolo",
         /* title       */    "Titolo",
         /* appendix    */    "Appendice",
         /* contents    */    "Contenuto",
         /* listfigure  */    "Lista di Figure",
         /* listtable   */    "Lista di Tabelle",
         /* figure      */    "Figura",
         /* table       */    "Tabella",
         /* index       */    "Indice",
         /* page        */    "pagina",
         /* see         */    "vedere",
         /* also        */    "vedere anche",
         /* by          */    "da",
         /* fur         */    "pro",
         /* up          */    "S&u",
         /* exit        */    "Uscita",
         /* unknown     */    "Ignoto",
         /* update      */    "Ultimo aggiornamento",
         /* lcid        */    "0x410",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "it",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Traduzione:",
         /* distributor */    "Distribuzione:",
         /* tex_stylename */  "italian",
         /* lyx_langname */   "italian",
         /* degree      */    "grado",
         "",""
      }
   },
   {
      TOJAP,                              /* Japanese */
      {
         /* preface     */    "序文",
         /* chapter     */    "章",
         /* title       */    "タイトル",
         /* appendix    */    "付録",
         /* contents    */    "目次",
         /* listfigure  */    "図一覧",
         /* listtable   */    "表の一覧",
         /* figure      */    "図",
         /* table       */    "表",
         /* index       */    "索引",
         /* page        */    "ページ",
         /* see         */    "参照してください",
         /* also        */    "参照してください",
         /* by          */    "作者",
         /* fur         */    "所属",
         /* up          */    "上へ",
         /* exit        */    "終了",
         /* unknown     */    "不明",
         /* update      */    "最終更新日",
         /* lcid        */    "0x411",
         /* html_home   */    "ホーム",
         /* html_up     */    "を",
         /* html_prev   */    "戻る",
         /* html_next   */    "進む",
         /* html_lang   */    "ja",
         /* html_start  */    "ドキュメントの開始",
         /* translator  */    "翻訳：",
         /* distributor */    "販売元：",
         /* tex_stylename */  "japanese",
         /* lyx_langname */   "japanese",
         /* degree      */    "度",
         "",""
      }
   },
   {
      TOLVA,                              /* Latvian */
      {
         /* preface     */    "Priekšvārds",
         /* chapter     */    "Nodaļa",
         /* title       */    "Nosaukums",
         /* appendix    */    "Pielikums",
         /* contents    */    "Saturs",
         /* listfigure  */    "Attēlu saraksts",
         /* listtable   */    "Tabulu saraksts",
         /* figure      */    "Attēls",
         /* table       */    "Tabula",
         /* index       */    "Alfabētiskais rādītājs",
         /* page        */    "lappuse",
         /* see         */    "skatīt",
         /* also        */    "skatīt arī",
         /* by          */    "pēc",
         /* fur         */    "",
         /* up          */    "Augšup",
         /* exit        */    "Iziet",
         /* unknown     */    "Nezināms",
         /* update      */    "Pēdējoreiz atjaunots",
         /* lcid        */    "0x426",
         /* html_home   */    "Sākums",
         /* html_up     */    "Augšup",
         /* html_prev   */    "Iepriekšējais",
         /* html_next   */    "Nākamais",
         /* html_lang   */    "lv",
         /* html_start  */    "Dokumenta sākums",
         /* translator  */    "Translation:",
         /* distributor */    "Izplatītājs:",
         /* tex_stylename */  "latvian",
         /* lyx_langname */   "latvian",
         /* degree      */    "degree",
         "",""
      }
   },
   {
      TONOR,                              /* Norwegian (Nynorsk)*/
      {
         /* preface     */    "Preface",
         /* chapter     */    "Chapter",
         /* title       */    "Title",
         /* appendix    */    "Appendix",
         /* contents    */    "Contents",
         /* listfigure  */    "List of Figures",
         /* listtable   */    "List of Tables",
         /* figure      */    "Figure",
         /* table       */    "Table",
         /* index       */    "Index",
         /* page        */    "page",
         /* see         */    "see",
         /* also        */    "see also",
         /* by          */    "by",
         /* fur         */    "for",
         /* up          */    "&Up",
         /* exit        */    "E&xit",
         /* unknown     */    "Unknown",
         /* update      */    "Last updated on",
         /* lcid        */    "0x414",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "no",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Omsetjing:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "norsk",
         /* lyx_langname */   "norsk",
         /* degree      */    "grad",
         "",""
      }
   },
   {
      TOPOL,                              /* Polish */
      {
         /* preface     */    "Preface",
         /* chapter     */    "Chapter",
         /* title       */    "Title",
         /* appendix    */    "Aneks",
         /* contents    */    "Zawartość",
         /* listfigure  */    "List of Figures",
         /* listtable   */    "List of Tables",
         /* figure      */    "Figure",
         /* table       */    "Table",
         /* index       */    "Indeks",
         /* page        */    "page",
         /* see         */    "see",
         /* also        */    "see also",
         /* by          */    "by",
         /* fur         */    "for",
         /* up          */    "Up",
         /* exit        */    "Exit",
         /* unknown     */    "Unknown",
         /* update      */    "Ostatnie zmiany",
         /* lcid        */    "0x415",
         /* html_home   */    "Główna",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "pl",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Tłumaczenie:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "polish",
         /* lyx_langname */   "polish",
         /* degree      */    "stopień",
         "",""
      }
   },
   {
      TOPOR,                              /* Portuguese */
      {
         /* preface     */    "Prefácio",
         /* chapter     */    "Captèulo",
         /* title       */    "Tètulo",
         /* appendix    */    "Apêndice",
         /* contents    */    "Contepúdo",
         /* listfigure  */    "Lista de Figuras",
         /* listtable   */    "Lista de Tabelas",
         /* figure      */    "Figure",
         /* table       */    "Tabela",
         /* index       */    "Índice",
         /* page        */    "Página",
         /* see         */    "ver",
         /* also        */    "ver também",
         /* by          */    "by",
         /* fur         */    "for",
         /* up          */    "&Up",
         /* exit        */    "E&xit",
         /* unknown     */    "Unknown",
         /* update      */    "Last updated on",
         /* lcid        */    "0x816",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "pt",
         /* html_start  */    "Begin of the document",
         /* translator  */    "Tradução:",
         /* distributor */    "Distributor:",
         /* tex_stylename */  "portuges",
         /* lyx_langname */   "portuges",
         /* degree      */    "grau",
         "",""
      }
   },
   {
      TOSPA,                              /* Spanish */
      {
         /* preface     */    "Prefacio",
         /* chapter     */    "Capìtulo",
         /* title       */    "Tìtulo",
         /* appendix    */    "Apéndice",
         /* contents    */    "Contenido",
         /* listfigure  */    "Lista de figuras",
         /* listtable   */    "Lista de tablas",
         /* figure      */    "Figura",
         /* table       */    "Tabla",
         /* index       */    "Índice",
         /* page        */    "Página",
         /* see         */    "Ver",
         /* also        */    "Además",
         /* by          */    "Por",
         /* fur         */    "Para",
         /* up          */    "Arriba",
         /* exit        */    "Salida",
         /* unknown     */    "desconocido",
         /* update      */    "Última actualización el",
         /* lcid        */    "0x40a",
         /* html_home   */    "Inicio",
         /* html_up     */    "Arriba",
         /* html_prev   */    "Anterior",
         /* html_next   */    "Siguiente",
         /* html_lang   */    "es",
         /* html_start  */    "Comienzo del documento",
         /* translator  */    "Traducción:",
         /* distributor */    "Distribuidor:",
         /* tex_stylename */  "spanish",
         /* lyx_langname */   "spanish",
         /* degree      */    "grado",
         "",""
      }
   },
   {
      TOSWE,                              /* Swedish */
      {
         /* preface     */    "Förord",
         /* chapter     */    "Kapitel",
         /* title       */    "Titel",
         /* appendix    */    "Appendix",
         /* contents    */    "Innehållsförteckning",
         /* listfigure  */    "Figurer",
         /* listtable   */    "Tabeller",
         /* figure      */    "Figur",
         /* table       */    "Tabell",
         /* index       */    "Index",
         /* page        */    "Sida",
         /* see         */    "se",
         /* also        */    "se även",
         /* by          */    "av",
         /* fur         */    "för",
         /* up          */    "&Upp",
         /* exit        */    "Avsluta",
         /* unknown     */    "Okänd",
         /* update      */    "Senast uppdaterad",
         /* lcid        */    "0x41d",
         /* html_home   */    "Home",
         /* html_up     */    "Up",
         /* html_prev   */    "Prev",
         /* html_next   */    "Next",
         /* html_lang   */    "sv",
         /* html_start  */    "Dokumentets början",
         /* translator  */    "Översättning:",
         /* distributor */    "Distributör:",
         /* tex_stylename */  "swedish",
         /* lyx_langname */   "swedish",
         /* degree      */    "grad",
         "",""
      }
   },
   
   {  -1, { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" }}
};
