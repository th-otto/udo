/**(TAB=0)**********************************************************************
*
*  Project name : UDO
*  Module name  : chr_ttf.h
*  Symbol prefix: chr
*
*  Description  : Zeichenbreiten von True Type Fonts
*                 Werte basieren auf TTFWIDTH.APP von Dirk Haun @ WI2
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
*  Co-Authors   : Ulf Dunkel (fd), Gerhard Stoll (ggs)
*  Write access : fd, ggs
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
*    fd  Feb 10: header updated, file reformatted and tidied up (TAB-free)
*
******************************************|************************************/

/*******************************************************************************
*
*     Times New Roman, 11pt
*
******************************************|************************************/

LOCAL const int width_times_11_regular[256] =
{
    3,  6,  6,  6,  6,  5,  8,  6,  7,  4,  6,  6,  6,  6,  6,  6,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  6,  9,  6,  6,  6,  6,
    3,  5,  6,  7,  7, 12, 11,  3,  5,  5,  7,  8,  3,  5,  3,  4,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  4,  4,  8,  8,  8,  6,
   13, 10,  9,  9, 10,  9,  8, 10, 10,  5,  5, 10,  9, 12, 10, 10,
    8, 10,  9,  8,  9, 10, 10, 13, 10, 10,  9,  5,  4,  5,  7,  7,
    5,  6,  7,  6,  7,  6,  5,  7,  7,  4,  4,  7,  4, 11,  7,  7,
    7,  7,  5,  5,  4,  7,  7, 10,  7,  7,  6,  7,  3,  7,  8,  6,
    9,  7,  6,  6,  6,  6,  6,  6,  6,  6,  6,  4,  4,  4, 10, 10,
    9,  9, 12,  7,  7,  7,  7,  7,  7, 10, 10,  7,  7,  7,  7,  7,
    6,  4,  7,  7,  7, 10,  4,  4,  6,  6,  8, 10, 10,  5,  7,  7,
    6,  7, 10,  7, 10, 12, 10, 10, 10,  5,  5,  7,  6, 11, 11, 14,
   10, 10,  9,  9,  9,  5,  5,  5,  5, 10, 10, 10, 10, 10, 10,  6,
    6,  6,  5,  5,  5,  5,  7, 14,  6,  6,  6,  6,  6,  7, 14,  6,
    6,  6,  6,  6,  6,  6,  8,  6,  6,  6,  6,  6,  6,  6,  6,  6,
    6,  8,  6,  6,  6,  6,  8,  6,  6,  5,  5,  3,  6,  4,  4,  7
};

LOCAL const int width_times_11_bold[256] =
{
    3,  7,  7,  7,  7,  5,  8,  7,  7,  5,  7,  7,  7,  7,  7,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  6,  9,  7,  7,  7,  7,
    3,  5,  8,  7,  7, 14, 12,  4,  5,  5,  7,  8,  3,  5,  3,  4,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  5,  5,  8,  8,  8,  7,
   13, 10,  9, 10, 10,  9,  9, 11, 11,  5,  7, 11,  9, 13, 10, 11,
    9, 11, 10,  8,  9, 10, 10, 14, 10, 10,  9,  5,  4,  5,  8,  7,
    5,  7,  8,  6,  8,  6,  5,  7,  8,  4,  5,  8,  4, 12,  8,  7,
    8,  8,  6,  5,  5,  8,  7, 10,  7,  7,  6,  6,  3,  6,  7,  7,
   10,  8,  6,  7,  7,  7,  7,  6,  6,  6,  6,  4,  4,  4, 10, 10,
    9, 10, 14,  7,  7,  7,  8,  8,  7, 11, 10,  7,  7,  7,  8,  7,
    7,  4,  7,  8,  8, 10,  4,  5,  7,  7,  8, 10, 10,  5,  7,  7,
    7,  7, 11,  7, 10, 14, 10, 10, 11,  5,  5,  7,  8, 10, 10, 14,
   10, 10,  9,  9,  9,  5,  5,  5,  5, 11, 11, 11, 10, 10, 10,  7,
    7,  7,  5,  5,  5,  5,  7, 14,  7,  7,  7,  7,  7,  7, 14,  7,
    7,  7,  7,  7,  7,  7,  8,  7,  7,  7,  7,  7,  7,  7,  7,  7,
    7,  8,  7,  7,  7,  7,  8,  7,  6,  5,  5,  3,  7,  4,  4,  7
};

LOCAL const int width_times_11_italic[256] =
{
    3,  7,  7,  7,  7,  5,  9,  7,  7,  4,  7,  7,  7,  7,  7,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  6,  9,  7,  7,  7,  7,
    3,  5,  6,  7,  7, 12, 11,  3,  5,  5,  7,  9,  3,  5,  3,  4,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  5,  5,  9,  9,  9,  7,
   13,  9,  9,  9, 10,  9,  9, 10, 10,  5,  6,  9,  8, 12,  9, 10,
    9, 10,  9,  7,  8, 10,  9, 12,  9,  8,  8,  5,  4,  5,  6,  7,
    5,  7,  7,  6,  7,  6,  4,  7,  7,  4,  4,  6,  4, 10,  7,  7,
    7,  7,  5,  5,  4,  7,  6,  9,  6,  6,  5,  6,  4,  6,  8,  7,
    9,  7,  6,  7,  7,  7,  7,  6,  6,  6,  6,  4,  4,  4,  9,  9,
    9,  9, 12,  7,  7,  7,  7,  7,  6, 10, 10,  7,  7,  7,  7,  7,
    7,  4,  7,  7,  7,  9,  4,  4,  7,  7,  9, 10, 10,  5,  7,  7,
    7,  7, 10,  7,  9, 13,  9,  9, 10,  5,  5,  7,  7, 11, 11, 14,
    9,  9,  9,  9,  9,  5,  5,  5,  5, 10, 10, 10, 10, 10, 10,  8,
    8,  8,  5,  5,  5,  5,  7, 12,  7,  7,  7,  7,  7,  7, 14,  7,
    7,  7,  7,  7,  7,  7,  8,  7,  7,  7,  7,  7,  7,  7,  7,  7,
    7,  8,  7,  7,  7,  7,  8,  7,  6,  5,  5,  3,  7,  4,  4,  7
};





/*******************************************************************************
*
*     Arial, 10pt
*
******************************************|************************************/

LOCAL const int width_arial_10_regular[256] =
{
    4,  7,  7,  7,  7,  4,  7,  7,  7,  4,  7,  7,  7,  7,  7,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  8,  7,  7,  7,  7,
    4,  4,  5,  7,  7, 11,  8,  2,  4,  4,  5,  7,  4,  4,  4,  4,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  4,  4,  7,  7,  7,  7,
   13,  8,  8,  9,  9,  8,  8, 10,  9,  4,  6,  8,  7, 11,  9, 10,
    8, 10,  9,  8,  8,  9,  8, 12,  8,  8,  8,  4,  4,  4,  6,  7,
    4,  7,  7,  6,  7,  7,  4,  7,  7,  3,  3,  6,  3, 11,  7,  7,
    7,  7,  4,  6,  4,  7,  6,  9,  6,  6,  6,  4,  3,  4,  7,  7,
    9,  7,  7,  7,  7,  7,  7,  6,  7,  7,  7,  4,  4,  4,  8,  8,
    8, 11, 13,  7,  7,  7,  7,  7,  6, 10,  9,  7,  7,  7,  8,  7,
    7,  4,  7,  7,  7,  9,  5,  5,  8,  7,  7, 11, 11,  4,  7,  7,
    7,  7, 10,  8, 12, 13,  8,  8, 10,  4,  4,  7,  7,  9,  9, 13,
    8,  8,  8,  8,  8,  4,  4,  4,  4, 10, 10, 10,  9,  9,  9,  4,
    4,  4,  3,  3,  4,  4,  7, 13,  7,  7,  7,  7,  7,  7, 13,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  5,  4,  4,  4,  7,  4,  4,  7
};

LOCAL const int width_arial_10_bold[256] =
{
    4,  8,  8,  8,  8,  4,  7,  8,  7,  4,  8,  8,  8,  8,  8,  8,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  8,  8,  8,  8,  8,
    4,  4,  6,  7,  7, 11,  9,  3,  4,  4,  5,  7,  4,  4,  4,  4,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  4,  4,  7,  7,  7,  8,
   12,  9,  9,  9,  9,  8,  8, 10,  9,  4,  7,  9,  8, 11,  9, 10,
    8, 10,  9,  8,  8,  9,  8, 12,  8,  8,  8,  4,  4,  4,  7,  7,
    4,  7,  8,  7,  8,  7,  4,  8,  8,  4,  4,  7,  4, 11,  8,  8,
    8,  8,  5,  7,  4,  8,  7, 10,  7,  7,  6,  5,  4,  5,  7,  8,
    9,  8,  7,  7,  7,  7,  7,  7,  7,  7,  7,  4,  4,  4,  9,  9,
    8, 11, 13,  8,  8,  8,  8,  8,  7, 10,  9,  7,  7,  7,  8,  7,
    7,  4,  8,  8,  8,  9,  5,  5,  8,  8,  7, 11, 11,  4,  7,  7,
    7,  8, 10,  8, 12, 13,  9,  9, 10,  4,  4,  7,  7,  9,  9, 13,
    9,  9,  8,  8,  8,  4,  4,  4,  4, 10, 10, 10,  9,  9,  9,  6,
    6,  6,  4,  4,  4,  4,  7, 13,  8,  8,  8,  8,  8,  7, 13,  8,
    8,  8,  8,  8,  8,  8,  7,  8,  8,  8,  8,  8,  8,  8,  8,  8,
    8,  7,  8,  8,  8,  8,  7,  8,  5,  4,  4,  4,  8,  4,  4,  7
};

LOCAL const int width_arial_10_italic[256] =
{
    4,  7,  7,  7,  7,  4,  7,  7,  7,  4,  7,  7,  7,  7,  7,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  8,  7,  7,  7,  7,
    4,  4,  5,  7,  7, 11,  8,  2,  4,  4,  5,  7,  4,  4,  4,  4,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  4,  4,  7,  7,  7,  7,
   13,  8,  8,  9,  9,  8,  8, 10,  9,  4,  6,  8,  7, 11,  9, 10,
    8, 10,  9,  8,  8,  9,  8, 12,  8,  8,  8,  4,  4,  4,  6,  7,
    4,  7,  7,  6,  7,  7,  4,  7,  7,  3,  3,  6,  3, 11,  7,  7,
    7,  7,  4,  6,  4,  7,  6,  9,  6,  6,  6,  4,  3,  4,  7,  7,
    9,  7,  7,  7,  7,  7,  7,  6,  7,  7,  7,  4,  4,  4,  8,  8,
    8, 11, 13,  7,  7,  7,  7,  7,  6, 10,  9,  7,  7,  7,  8,  7,
    7,  4,  7,  7,  7,  9,  5,  5,  8,  7,  7, 11, 11,  4,  7,  7,
    7,  7, 10,  8, 12, 13,  8,  8, 10,  4,  4,  7,  7,  9,  9, 13,
    8,  8,  8,  8,  8,  4,  4,  4,  4, 10, 10, 10,  9,  9,  9,  4,
    4,  4,  3,  3,  4,  4,  7, 13,  7,  7,  7,  7,  7,  7, 13,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,
    7,  7,  7,  7,  7,  7,  7,  7,  5,  4,  4,  4,  7,  4,  4,  7
};





/*******************************************************************************
*
*     Courier, 10pt
*
******************************************|************************************/

LOCAL const int width_courier_10_regular[256] =
{
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8
};

LOCAL const int width_courier_10_bold[256] =
{
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8
};

LOCAL const int width_courier_10_italic[256] =
{
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
   8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8
};
