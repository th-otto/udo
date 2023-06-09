/**(TAB=0)**********************************************************************
*
*  Project name : UDO
*  Module name  : udo2ps.h
*  Symbol prefix: udo2ps
*
*  Description  : ???
*
*  Copyright    : 1998 Christian Krueger (chrisker@freeyellow.com)
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
*  Co-Authors   : Christian 'chrisker' Kr"uger (CK)
*                 Norbert Hanz NHz
*                 Gerhard Stoll (ggs),
*                 Ulf Dunkel (fd)
*  Write access : ggs, fd
*
*  Notes        : Please add yourself as co-author when you change this file.
*
*-------------------------------------------------------------------------------
*  Things to do : - check if this huge 'string' can be handled in a way which 
*                   does not make Linux gcc complain (in -pedantic mode only):
*
*                  "string length '12721' is greater than the length '509' ISO C90
*                   compilers are required to support"
*
*-------------------------------------------------------------------------------
*  History:
*
*  1998:
*    CK        : v1.0: initial version
*  1999:
*    NHz May 17: additional functions for PostScript output
*  2002-2005:
*    NHz       : extensions added
*  2010:
*    fd  Feb 22: header adjusted
*    fd  May 20: old history stuff added
*
******************************************|************************************/

const char *UDO2PS =
   "%%!PS-Adobe-2.0\n"
   "%% ------------\n"
   "%% This is a very 'sophisticated' PostScript program.\n"
   "%% That's the reason why it doesn't use the DSC!\n"
   "%% It will not work under PostScript level 1!\n"
   "%% --------------------------------------------------\n"
   "%% UDO to PS V1.0 was written in 1998\n"
   "%% (c) by Christian 'chrisker' Kr\"uger\n"
   "%%     (chrisker@freeyellow.com)\n"
   "%% Extensions had been written in 2002 - 2005\n"
   "%% (c) by Norbert Hanz\n"
   "%%     (norbert@familie-hanz.de)\n"
   "%% Use at own risk!\n"
   "%% --------------------------------------------------\n"
   "\n"
   "%%--- The set of 'private' variables\n"
   "\n"
   "/wordlen        0   def     %%--- aktuelle Wortlaenge\n"
   "/strlen         0   def     %%--- aktuelle Stringlaenge\n"
   "/linelen        0   def     %%--- aktuelle Zeilenlaenge \n"
   "/spacecounter   0   def     %%--- Anzahl der Spaces\n"
   "/spacewidth     0   def     %%--- initiale Weite eines Spaces\n"
   "\n"
   "/localvar       0       def\n"
   "/fontsize      11       def\n"
   "/basefont       2       def    %% 1 = Helvetica, 2 = Times-Roman\n"
   "/actualfont     0       def\n"
   "/actx           0       def\n"
   "/acty           0       def\n"
   "/strike         false   def\n"
   "/underline      false   def\n"
   "/bold           false   def\n"
   "/descript       false   def\n"
   "/NodeName       ()      def\n"
   "/FootAuthor     ()      def\n"
   "\n"
   "/offCount       -1      def\n"
   "/offCountS      0       def\n"
   "/offList\n"
   "[/offList1 /offList2 /offList3 /offList4 () () () ()]\n"
   "def\n"
   "\n"
/* need for future use
   "100 string\n"
   "/oString exch def\n"
   "/oIndex 0 def\n"
   "100 string\n"
   "/Reset exch def\n"
   "/pAlign 0 def\n"
   "\n"
*/
   "/UdoFonts\n"
   "[/UdoSwiss /UdoSwissItalic /UdoSwissBold /UdoSwissBoldItalic\n"
   " /UdoTimes /UdoTimesItalic /UdoTimesBold /UdoTimesBoldItalic\n"
   " /UdoCourier /UdoCourierItalic /UdoCourierBold /UdoCourierBoldItalic\n"
   " /UdoSymbol]\n"
   "def\n"
   "\n"
   "%%-- Procedures:\n"
   "\n"
   "/makeisomap          %% PRIVATE!\n"
   "{\n"
   "   findfont\n"
   "   dup length dict begin\n"
   "     {1 index /FID ne {def} {pop pop} ifelse} forall\n"
   "     /Encoding ISOLatin1Encoding def\n"
   "     currentdict\n"
   "   end\n"
   "   definefont pop\n"
   "}\n"
   "bind def\n"
   "\n"
/* Adobe Distiller doesn't konow anything about SymbolEncoding
   Symbols must be done by Glyphs
   "%%-- for Symbol-Font\n"
   "/makeisomapSymbol          %% PRIVATE!\n"
   "{\n"
   "   findfont\n"
   "   dup length dict begin\n"
   "     {1 index /FID ne {def} {pop pop} ifelse} forall\n"
   "     /Encoding SymbolEncoding def\n"
   "     currentdict\n"
   "   end\n"
   "   definefont pop\n"
   "}\n"
   "bind def\n"
   "\n"
*/
   "%%--------------------\n"
   "% Extract from Antiword by Adri van Os\n"
   "/newcodes  % ISO-8859-1 character encodings\n"
   "[\n"
   "128/Euro 129/ring 140/ellipsis 141/trademark 142/perthousand 143/bullet\n"
   "144/quoteleft 145/quoteright 146/guilsinglleft 147/guilsinglright\n"
   "148/quotedblleft 149/quotedblright 150/quotedblbase 151/endash 152/emdash\n"
   "153/minus 154/OE 155/oe 156/dagger 157/daggerdbl 158/fi 159/fl\n"
   "160/space 161/exclamdown 162/cent 163/sterling 164/currency\n"
   "165/yen 166/brokenbar 167/section 168/dieresis 169/copyright\n"
   "170/ordfeminine 171/guillemotleft 172/logicalnot 173/hyphen 174/registered\n"
   "175/macron 176/degree 177/plusminus 178/twosuperior 179/threesuperior\n"
   "180/acute 181/mu 182/paragraph 183/periodcentered 184/cedilla\n"
   "185/onesuperior 186/ordmasculine 187/guillemotright 188/onequarter\n"
   "189/onehalf 190/threequarters 191/questiondown 192/Agrave 193/Aacute\n"
   "194/Acircumflex 195/Atilde 196/Adieresis 197/Aring 198/AE 199/Ccedilla\n"
   "200/Egrave 201/Eacute 202/Ecircumflex 203/Edieresis 204/Igrave 205/Iacute\n"
   "206/Icircumflex 207/Idieresis 208/Eth 209/Ntilde 210/Ograve 211/Oacute\n"
   "212/Ocircumflex 213/Otilde 214/Odieresis 215/multiply 216/Oslash\n"
   "217/Ugrave 218/Uacute 219/Ucircumflex 220/Udieresis 221/Yacute 222/Thorn\n"
   "223/germandbls 224/agrave 225/aacute 226/acircumflex 227/atilde\n"
   "228/adieresis 229/aring 230/ae 231/ccedilla 232/egrave 233/eacute\n"
   "234/ecircumflex 235/edieresis 236/igrave 237/iacute 238/icircumflex\n"
   "239/idieresis 240/eth 241/ntilde 242/ograve 243/oacute 244/ocircumflex\n"
   "245/otilde 246/odieresis 247/divide 248/oslash 249/ugrave 250/uacute\n"
   "251/ucircumflex 252/udieresis 253/yacute 254/thorn 255/ydieresis\n"
   "] bind def\n"
   "\n"
   "/reencdict 12 dict def\n"
   "\n"
   "\n"
   "% change fonts using ISO-8859-x characters\n"
   "/ChgFnt    % size psname natname => font\n"
   "{\n"
   "   dup FontDirectory exch known      % is re-encoded name known?\n"
   "   { exch pop }            % yes, get rid of long name\n"
   "   { dup 3 1 roll ReEncode } ifelse  % no, re-encode it\n"
   "   findfont exch scalefont setfont\n"
   "} bind def\n"
   "\n"
   "/ReEncode\n"
   "{\n"
   "reencdict begin\n"
   "   /newname exch def\n"
   "   /basename exch def\n"
   "   /basedict basename findfont def\n"
   "   /newfont basedict maxlength dict def\n"
   "   basedict\n"
   "   { exch dup /FID ne\n"
   "      { dup /Encoding eq\n"
   "         { exch dup length array copy newfont 3 1 roll put }\n"
   "         { exch newfont 3 1 roll put } ifelse\n"
   "      }\n"
   "      { pop pop } ifelse\n"
   "   } forall\n"
   "   newfont /FontName newname put\n"
   "   newcodes aload pop newcodes length 2 idiv\n"
   "   { newfont /Encoding get 3 1 roll put } repeat\n"
   "   newname newfont definefont pop\n"
   "end\n"
   "} bind def\n"
   "%--- End of Extract\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/setup               %% In: void\n"
   "{\n"
   "  /actx leftmargin def\n"
   "  /acty topmargin def\n"
   "  actx acty moveto\n"
   "  %%--- Setup the 12 fonts...\n"
/* "  /UdoSwiss             /Helvetica             makeisomap\n"
   "  /UdoSwissItalic       /Helvetica-Oblique     makeisomap\n"
   "  /UdoSwissBold         /Helvetica-Bold        makeisomap\n"
   "  /UdoSwissBoldItalic   /Helvetica-BoldOblique makeisomap\n"
   "  /UdoTimes             /Times-Roman           makeisomap\n"
   "  /UdoTimesItalic       /Times-Italic          makeisomap\n"
   "  /UdoTimesBold         /Times-Bold            makeisomap\n"
   "  /UdoTimesBoldItalic   /Times-BoldItalic      makeisomap\n"
   "  /UdoCourier           /Courier               makeisomap\n"
   "  /UdoCourierItalic     /Courier-Oblique       makeisomap\n"
   "  /UdoCourierBold       /Courier-Bold          makeisomap\n"
   "  /UdoCourierBoldItalic /Courier-BoldQblique   makeisomap\n"
*/
   "  10.0 /Helvetica              /UdoSwiss              ChgFnt\n"
   "  10.0 /Helvetica-Oblique      /UdoSwissItalic        ChgFnt\n"
   "  10.0 /Helvetica-Bold         /UdoSwissBold          ChgFnt\n"
   "  10.0 /Helvetica-BoldOblique  /UdoSwissBoldItalic    ChgFnt\n"
   "  10.0 /Times-Roman            /UdoTimes              ChgFnt\n"
   "  10.0 /Times-Italic           /UdoTimesItalic        ChgFnt\n"
   "  10.0 /Times-Bold             /UdoTimesBold          ChgFnt\n"
   "  10.0 /Times-BoldItalic       /UdoTimesBoldItalic    ChgFnt\n"
   "  10.0 /Courier                /UdoCourier            ChgFnt\n"
   "  10.0 /Courier-Oblique        /UdoCourierItalic      ChgFnt\n"
   "  10.0 /Courier-Bold           /UdoCourierBold        ChgFnt\n"
   "  10.0 /Courier-BoldOblique    /UdoCourierBoldItalic  ChgFnt\n"
   "  /UdoSymbol            /Symbol                makeisomap\n"
   "  setUdoFont         \n"
   "}\n"
   "def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/newpage           %% In: void\n"
   "{\n"
   "  /Bmerk false def\n"
   "  /fontmerk -1 def\n"
   "  actualfont 8 ge\n"
   "  { /fontmerk actualfont def\n"
   "    Voff\n"
   "  } if\n"
   "  /fontsizemerk fontsize def\n"
   "  11 changeFontSize\n"
   "  bold true eq\n"
   "  { Boff\n"
   "   /Bmerk true def\n"
   "  } if\n"
   "\n"
   "  footout\n"
   "  /footnumbers 0 def\n"
   "  /lowermargin cclowermargin def\n"
   "\n"
   "  ccleftmargin 2 sub cclowermargin 15 sub moveto\n"
   "  ccrightmargin cclowermargin 15 sub lineto\n"
   "  stroke\n"
   "\n"
   "  ccleftmargin cclowermargin 30 sub moveto\n"
   "  Ion NodeName udoshow\n"
   "  ccrightmargin FootAuthor stringwidth pop sub cclowermargin 30 sub moveto\n"
   "  FootAuthor udoshow Ioff\n"
   "\n"
   "  /strlen 0 def\n"
   "  /acty topmargin def\n"
   "  /actx leftmargin def\n"
   "  actx acty moveto\n"
   "\n"
   "  ccleftmargin cctopmargin moveto\n"
   "  /pagenumber pagenumber 1 add def\n"
   "  /Seite (Seite     ) def\n"
   "  Seite 6 pagenumber (xxxx) cvs putinterval\n"
   "  Ion Titeltext udoshow Seite Right setAlign Ioff\n"
   "\n"
   "  ccleftmargin 2 sub cctopmargin 5 sub moveto\n"
   "  ccrightmargin cctopmargin 5 sub lineto\n"
   "  stroke\n"
   "\n"
   "  /topmargin cctopmargin 30 sub def\n"
   "  Bmerk true eq\n"
   "  { Bon\n"
   "    /Bmerk false def\n"
   "  } if\n"
   "  fontsizemerk changeFontSize\n"
   "  fontmerk -1 gt\n"
   "  { Von\n"
   "    /fontmerk -1 def\n"
   "  } if\n"
   "\n"
   "  showpage\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/newline            %% In: void\n"
   "{\n"
   "  /strlen 0 def                %% akt. Ausgabelaenge = 0\n"
   "    foot\n"
   "  {\n"
   "     /actx ccleftmargin 10 add def\n"
   "     /acty acty fontsize sub def\n"
   "  }\n"
   "  {\n"
   "    /actx leftmargin def\n"
   "    /acty acty fontsize linespacing mul sub def\n"
   "    acty lowermargin lt\n"
   "    {\n"
   "      newpage\n"
   "    }\n"
   "    if\n"
   "  } ifelse\n"
   "  actx acty moveto\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/calcwordlen        %% PRIVATE! \n"
   "{\n"
   "    /wordlen\n"
   "    exch\n"
   "    stringwidth pop def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/showout           %% PRIVATE!\n"
   "{\n"
   "    strike                          %% Streichung beachten\n"
   "    {\n"
   "      currentpoint 3 -1 roll\n"
   "      show\n"
   "      currentpoint 4 2 roll\n"
   "      currentpoint 2 add moveto   %% Strich 2 Typopoint hoeher...\n"
   "      2 add lineto\n"
   "      stroke moveto\n"
   "    }\n"
   "    {\n"
   "      underline                        %% Unterstreichung beachten\n"
   "      {\n"
   "          currentpoint 3 -1 roll\n"
   "          show\n"
   "          currentpoint 4 2 roll\n"
   "          currentpoint 1 sub moveto   %% Unterstr. 1 Typopoint tiefer...\n"
   "          1 sub lineto\n"
   "          stroke moveto\n"
   "      }\n"
   "      {\n"
   "          show\n"
   "      }\n"
   "      ifelse\n"
   "    }\n"
   "    ifelse\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/wordout            %% PRIVATE!\n"
   "{\n"
   "    exch\n"
   "    dup\n"
   "    () ne    %%-- Leere Strings ignorieren...\n"
   "    {\n"
   "      /strlen strlen wordlen add def\n"
   "      strlen linelen gt\n"
   "      {\n"
   "        newline\n"
   "        /strlen wordlen def\n"
   "      }\n"
   "      if\n"
   "         showout     %% -- Wort ausgeben\n"
   "      }\n"
   "     {\n"
   "       pop  %%-- Leerstring entfernen\n"
   "     }\n"
   "     ifelse\n"
   "     \n"
   "     {             %% Spaceflag auswerten...\n"
   "       showout   %% -- Space ausgeben\n"
   "       /strlen strlen spacewidth add def\n"
   "     }\n"
   "    if\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/udoshow            %% In: (String)\n"
   "{ \n"
   "  /linelen rightmargin leftmargin sub def\n"
   "  /spacewidth ( ) stringwidth pop def\n"
   "\n"
   "  {  \n"
   "    ( ) search      %%--- Spaces suchen\n"
   "    {               %%--- gefunden\n"
   "        dup            %%--- Wort duplizieren\n"
   "        calcwordlen\n"
   "        true        %%--- 2 x show (mit Space)        \n"
   "        wordout\n"
   "    }\n"
   "    {               %%--- kein Space gefunden\n"
   "        dup\n"
   "        calcwordlen\n"
   "        false       %%--- 1 x show\n"
   "        wordout\n"
   "        exit    \n"
   "    }\n"
   "    ifelse\n"
   "  }\n"
   "  loop\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "%%-- Fontprocs:\n"
   "\n"
   "/setUdoFont             %% PRIVATE!\n"
   "{\n"
   "    UdoFonts actualfont get fontsize selectfont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Ion                    %% In: void\n"
   "{\n"
   "   /actualfont actualfont 1 add def\n"
   "   setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Ioff                   %% In: void\n"
   "{\n"
   "   /actualfont actualfont 1 sub def\n"
   "   setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Bon                    %% In: void\n"
   "{\n"
   "   /actualfont actualfont 2 add def\n"
   "   setUdoFont\n"
   "   /bold true def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Boff                   %% In: void\n"
   "{\n"
   "   /actualfont actualfont 2 sub def\n"
   "   setUdoFont\n"
   "   /bold false def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Son                    %% In: void\n"
   "{\n"
   "   /strike true def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Soff                   %% In: void\n"
   "{\n"
   "   /strike false def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Uon                    %% In: void\n"
   "{\n"
   "   /underline true def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Uoff                   %% In: void\n"
   "{\n"
   "   /underline false def\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Von                    %% In: void\n"
   "{\n"
   "   /actualfont actualfont 3 basefont sub 4 mul add def\n"
   "   setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "                        %% In: void\n"
   "/Voff\n"
   "{\n"
   "   /actualfont actualfont 3 basefont sub 4 mul sub def\n"
   "   setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Symbolon               %% In: void\n"
   "{\n"
   "   /remember actualfont def\n"
   "   /actualfont 12 def\n"
   "   setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/Symboloff              %% In: void\n"
   "{\n"
   "   /actualfont remember def\n"
   "   setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/setBaseFont         %% In: basefont\n"
   "{\n"
   "   1 basefont eq   %% Basis ist Helvetica\n"
   "   {\n"
   "     /actualfont 0 def\n"
   "     setUdoFont\n"
   "   }\n"
   "   {\n"
   "     /actualfont 4 def\n"
   "     setUdoFont\n"
   "   }\n"
   "   ifelse\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/changeBaseFont         %% In: void\n"
   "{\n"
   "   1 basefont eq\n"
   "   {\n"
   "     /basefont 2 def    %% Basis ist Times\n"
   "     actualfont 8 lt    %% -- Courier? -> nein -> gleich umschalten\n"
   "     {\n"
   "         /actualfont actualfont 4 add def\n"
   "         setUdoFont\n"
   "     }\n"
   "     if\n"
   "   }\n"
   "   {\n"
   "     /basefont 1 def    %% Basis ist Helvetica\n"
   "     actualfont 8 lt    %% -- Courier? -> nein -> gleich umschalten\n"
   "     {\n"
   "         /actualfont actualfont 4 sub def\n"
   "         setUdoFont\n"
   "     }\n"
   "     if\n"
   "   }\n"
   "   ifelse\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/changeFontSize        %% In: size\n"
   "{\n"
   "    /fontsize exch def\n"
   "    setUdoFont\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "%%-- Lists\n"
   "\n"
   "/description\n"
   "{\n"
   "  descript\n"
   "  {\n"
   "    /descript false def\n"
   "  }\n"
   "  {\n"
   "    /descript true def\n"
   "  } ifelse\n"
   "} bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/addStrSpaceLeft        %% In: /var (String)\n"
   "{\n"
   "   /localvar exch stringwidth pop def\n"
   "   /leftmargin localvar leftmargin add def\n"
   "   localvar def\n"
   "      offList offCountS localvar put\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/addStrSpaceLeftList    %% In: /var [(String) (..)]\n"
   "{\n"
   "    /localvar 0 def\n"
   "    { stringwidth pop dup\n"
   "      localvar gt\n"
   "      {\n"
   "        /localvar exch def\n"
   "      }\n"
   "      {\n"
   "        pop\n"
   "      }\n"
   "      ifelse\n"
   "    }\n"
   "    forall\n"
   "       /leftmargin localvar leftmargin add def\n"
   "    localvar def\n"
   "}\n"
   "bind def \n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/subOffFromLeft         %% In: var\n"
   "{\n"
   "  /leftmargin exch leftmargin exch sub def\n"
   "  leftmargin acty moveto\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/writeBeforeLeft    %% In: (String) var\n"
   "{\n"
   "    /localvar exch def\n"
   "\n"
   "    newline\n"
   "%    leftmargin exch sub acty moveto\n"
   "    leftmargin localvar sub acty moveto\n"
   "    dup show\n"
   "\n"
   "    descript\n"
   "    {\n"
   "      calcwordlen\n"
   "      /strlen wordlen 10 add localvar sub def\n"
   "      currentpoint pop 10 add acty moveto\n"
   "    }\n"
   "    {\n"
   "      leftmargin acty moveto\n"
   "    } ifelse\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "\n"
   "/writeBulletLeft    %% In: (String) var\n"
   "{\n"
   "    newline\n"
   "     leftmargin 2 add exch sub acty moveto\n"
   "     glyphshow\n"
   "     leftmargin acty moveto\n"
   "}\n"
   "bind def\n"
   "\n"
   "%%--------------------\n"
   "%%-- GFX\n"
   "\n"
   "/hline              %% In: void\n"
   "{\n"
   "    newline\n"
   "    rightmargin acty lineto\n"
   "    stroke\n"
   "    newline\n"
   "}\n"
   "bind def\n"
   "\n"
   "%% --------------------------------------------------\n";
