/**(TAB=0)**********************************************************************
*
*  Project name : UDO
*  Module name  : img_win.h
*  Symbol prefix: img_win
*
*  Description  : ???
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
*  Co-Authors   : Gerhard Stoll (ggs), Ulf Dunkel
*  Write access : ggs, fd
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
*    fd  Feb 22: - header adjusted
*
******************************************|************************************/
#ifndef UDO_IMG_WIN_H
#define UDO_IMG_WIN_H

LOCAL const _UBYTE win_bmp_fc[222] =
{
#if 0 /* old */
   0x42, 0x4D, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x68, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
   0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x80,
   0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x80,
   0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF,
   0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF,
   0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x88, 0x88,
   0x88, 0x88, 0x88, 0x88, 0x88, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x78, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x78, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x78, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0x00, 0x87, 0xB7, 0xB7, 0xB7, 0x88, 0x88, 0x88, 0xF0, 0xF8, 0x7B,
   0x7B, 0x78, 0xFF, 0xFF, 0xFF, 0xF0, 0xFF, 0x88, 0x88, 0x8F, 0xFF, 0xFF, 0xFF, 0xF0
#else
   0x42, 0x4D, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x68, 0x00, 0x00, 0x00, 0xC4, 0x0E, 0x00, 0x00, 0xC4, 0x0E, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x80,
   0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x80,
   0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF,
   0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF,
   0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x88, 0x88,
   0x88, 0x88, 0x88, 0x88, 0x88, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x78, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x78, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x78, 0x00, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x8F, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0x00, 0x87, 0xB7, 0xB7, 0xB7, 0x88, 0x88, 0x88, 0x70, 0x78, 0x7B,
   0x7B, 0x78, 0x77, 0x77, 0x77, 0x70, 0x77, 0x88, 0x88, 0x87, 0x77, 0x77, 0x77, 0x70
#endif
};

LOCAL const _UBYTE win_bmp_fo[222] =
{
#if 0 /* old */
   0x42, 0x4D, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x68, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
   0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x80,
   0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x80,
   0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF,
   0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF,
   0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x88,
   0x88, 0x88, 0x88, 0x88, 0x88, 0x00, 0xFF, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0xF8, 0xFB,
   0x7B, 0x7B, 0x7B, 0x7B, 0x70, 0x80, 0xF8, 0xF7, 0xB7, 0xB7, 0xB7, 0xB7, 0x80, 0x80, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x08, 0x80, 0x8F, 0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0x07, 0x80, 0x88, 0x88,
   0x88, 0x88, 0x88, 0x88, 0x8B, 0x80, 0xF8, 0xF7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0x80, 0xF8, 0xFB,
   0x7B, 0x7B, 0x7F, 0xFF, 0xFF, 0x80, 0xF8, 0xF7, 0xB7, 0xB7, 0xF8, 0x88, 0x88, 0x8F, 0xFF, 0x8F,
   0xFF, 0xFF, 0x8F, 0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0x88, 0x88, 0xFF, 0xFF, 0xFF, 0xFF
#else
   0x42, 0x4D, 0xDE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x68, 0x00, 0x00, 0x00, 0xC4, 0x0E, 0x00, 0x00, 0xC4, 0x0E, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x80,
   0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x80,
   0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF,
   0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF,
   0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x77, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x77, 0x88,
   0x88, 0x88, 0x88, 0x88, 0x88, 0x00, 0x77, 0x8F, 0xB7, 0xB7, 0xB7, 0xB7, 0xB8, 0x00, 0x78, 0xFB,
   0x7B, 0x7B, 0x7B, 0x7B, 0x70, 0x80, 0x78, 0xF7, 0xB7, 0xB7, 0xB7, 0xB7, 0x80, 0x80, 0x8F, 0x7B,
   0x7B, 0x7B, 0x7B, 0x7B, 0x08, 0x80, 0x8F, 0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0x07, 0x80, 0x88, 0x88,
   0x88, 0x88, 0x88, 0x88, 0x8B, 0x80, 0x78, 0xF7, 0xB7, 0xB7, 0xB7, 0xB7, 0xB7, 0x80, 0x78, 0xFB,
   0x7B, 0x7B, 0x7F, 0xFF, 0xFF, 0x80, 0x78, 0xF7, 0xB7, 0xB7, 0xF8, 0x88, 0x88, 0x87, 0x77, 0x8F,
   0xFF, 0xFF, 0x87, 0x77, 0x77, 0x77, 0x77, 0x78, 0x88, 0x88, 0x77, 0x77, 0x77, 0x77
#endif
};


#if 0 /* no longer used */
LOCAL const _UBYTE win_bmp_fs[114] =
{
   0x42, 0x4D, 0x72, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00,
   0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF,
   0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF,
   0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF,
   0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF,
   0xF0, 0x00
};
#endif


LOCAL const _UBYTE win_bmp_mw[1482] =
{
#if 0 /* Made With Udo6 */
   0x42, 0x4D, 0xCA, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x54, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
   0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x80,
   0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x80,
   0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF,
   0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF,
   0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x22,
   0x07, 0x77, 0x77, 0x00, 0x07, 0x77, 0x0E, 0xEE, 0xE6, 0x66, 0x00, 0x77, 0x7F, 0x87, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x22, 0x20, 0x77, 0x70, 0x0B,
   0x30, 0x77, 0x0E, 0xEE, 0xF6, 0x66, 0x00, 0x7F, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x22, 0x20, 0x70, 0x0B, 0xBB, 0x33, 0x07, 0x0E, 0xFF,
   0xEE, 0x66, 0x00, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x88, 0x88, 0x88, 0x77, 0x77, 0x88, 0x88,
   0x88, 0x87, 0x77, 0x77, 0x77, 0x88, 0x88, 0x87, 0x77, 0x77, 0x77, 0x77, 0x77, 0x88, 0x87, 0x77,
   0x77, 0x70, 0xF7, 0x22, 0x20, 0x70, 0xBB, 0xBB, 0x33, 0x30, 0x0F, 0xEE, 0xEE, 0xE6, 0x07, 0x07,
   0x77, 0x77, 0x77, 0x77, 0x7C, 0xCC, 0xCC, 0xC8, 0x87, 0x7C, 0xCC, 0xCC, 0xCC, 0x88, 0x77, 0x77,
   0x7C, 0xCC, 0xCC, 0x88, 0x87, 0x77, 0x77, 0x77, 0x7C, 0xCC, 0x87, 0x77, 0x77, 0x70, 0xF7, 0xA2,
   0x20, 0x70, 0xBB, 0xBB, 0x33, 0x30, 0x70, 0xEE, 0xEE, 0xE0, 0x07, 0x00, 0x77, 0x07, 0x77, 0x77,
   0xCC, 0xCC, 0xCC, 0xCC, 0x88, 0x7C, 0xCC, 0xCC, 0xCC, 0xCC, 0x87, 0x77, 0xCC, 0xCC, 0xCC, 0xCC,
   0x88, 0x77, 0x77, 0x77, 0xCC, 0xCC, 0xC8, 0x77, 0x77, 0x70, 0xF7, 0xAA, 0x20, 0x70, 0xBB, 0xBF,
   0x33, 0x30, 0x77, 0x0E, 0xE0, 0x07, 0x00, 0xA2, 0x00, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x7C,
   0xC8, 0x7C, 0xC8, 0x77, 0x77, 0xCC, 0xC8, 0x7C, 0xCC, 0x87, 0x77, 0xCC, 0xC8, 0x77, 0x77, 0x7C,
   0xC8, 0x7C, 0xCC, 0x87, 0x77, 0x70, 0xF7, 0xAA, 0x00, 0x70, 0xBF, 0xFB, 0xB3, 0x30, 0x77, 0x70,
   0x07, 0x00, 0xAA, 0xA2, 0x20, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x7C, 0xC8, 0x77, 0xCC, 0x87,
   0x77, 0x7C, 0xC8, 0x7C, 0xC8, 0x77, 0x77, 0x7C, 0xC8, 0x87, 0x77, 0x7C, 0xC8, 0x77, 0xCC, 0x87,
   0x77, 0x70, 0xF7, 0x00, 0x77, 0x70, 0xFB, 0xBB, 0xBB, 0x30, 0x77, 0x77, 0x77, 0x0A, 0xAA, 0xA2,
   0x22, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87, 0x77, 0x7C, 0xCC, 0x8C,
   0xC8, 0x77, 0x77, 0x7C, 0xCC, 0x87, 0x77, 0x7C, 0xC8, 0x77, 0xCC, 0x87, 0x77, 0x70, 0xF7, 0x77,
   0x77, 0x77, 0x0B, 0xBB, 0xBB, 0x00, 0x77, 0x77, 0x77, 0x0A, 0xAA, 0xA2, 0x22, 0x07, 0x77, 0x77,
   0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x8C, 0xC8, 0x77, 0x77, 0x77,
   0xCC, 0x87, 0x77, 0x7C, 0xCC, 0x88, 0xCC, 0x87, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x00, 0x70, 0xBB,
   0x00, 0x77, 0x70, 0x07, 0x77, 0x0A, 0xAA, 0xF2, 0x22, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77,
   0xCC, 0x87, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x8C, 0xC8, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x7C,
   0xCC, 0xCC, 0xCC, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x00, 0xC4, 0x07, 0x00, 0x77, 0x70, 0x09, 0x10,
   0x77, 0x0A, 0xFF, 0xAA, 0x22, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87,
   0x77, 0x77, 0xCC, 0x8C, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x7C, 0xC8, 0xCC, 0xC7, 0x77,
   0x77, 0x70, 0xF7, 0x00, 0xCC, 0xC4, 0x40, 0x77, 0x70, 0x09, 0x99, 0x11, 0x07, 0x0F, 0xAA, 0xAA,
   0xA2, 0x07, 0x77, 0x77, 0x7C, 0xC8, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87,
   0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x0C,
   0xCC, 0xC4, 0x44, 0x00, 0x09, 0x99, 0x99, 0x11, 0x10, 0x70, 0xAA, 0xAA, 0xA0, 0x07, 0x77, 0x77,
   0x7C, 0xC8, 0x77, 0x77, 0x7C, 0xC8, 0x7C, 0xC8, 0x88, 0x8C, 0xCC, 0x87, 0xCC, 0xC8, 0x88, 0x8C,
   0xCC, 0x87, 0x77, 0x77, 0xCC, 0xC8, 0x8C, 0xC8, 0x77, 0x70, 0xF7, 0x0C, 0xCC, 0xC4, 0x44, 0x09,
   0x99, 0x99, 0x99, 0x11, 0x11, 0x07, 0x0A, 0xA0, 0x07, 0x77, 0x77, 0x77, 0x7C, 0xC8, 0x77, 0x77,
   0x7C, 0xC8, 0x7C, 0xCC, 0xCC, 0xCC, 0xC8, 0x77, 0x7C, 0xCC, 0xCC, 0xCC, 0xC8, 0x77, 0x77, 0x77,
   0x7C, 0xCC, 0xCC, 0xC8, 0x77, 0x70, 0xF7, 0x0C, 0xCC, 0xF4, 0x44, 0x09, 0x99, 0x99, 0x99, 0x11,
   0x11, 0x10, 0x70, 0x07, 0x70, 0x07, 0x77, 0x77, 0x7C, 0xC7, 0x77, 0x77, 0x7C, 0xC7, 0x7C, 0xCC,
   0xCC, 0xCC, 0x77, 0x77, 0x77, 0x7C, 0xCC, 0xCC, 0x77, 0x77, 0x77, 0x77, 0x77, 0xCC, 0xCC, 0x77,
   0x77, 0x70, 0xF7, 0x0C, 0xFF, 0xCC, 0x44, 0x09, 0x99, 0x99, 0x99, 0x11, 0x11, 0x10, 0x77, 0x70,
   0x0D, 0x57, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x0F,
   0xCC, 0xCC, 0xC4, 0x09, 0x99, 0x99, 0x99, 0x11, 0x11, 0x10, 0x70, 0x0D, 0xDD, 0x57, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x70, 0xCC, 0xCC, 0xC0, 0x09,
   0x99, 0x99, 0x99, 0x11, 0x11, 0x10, 0x70, 0xDD, 0xDD, 0x57, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x0C, 0xC0, 0x07, 0x09, 0x99, 0x99, 0x9F, 0x91,
   0x11, 0x10, 0x70, 0xDD, 0xDD, 0x57, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x77, 0x70, 0x07, 0x77, 0x09, 0x99, 0x9F, 0xF9, 0x99, 0x11, 0x10, 0x70, 0xDD,
   0xDF, 0x57, 0x77, 0x77, 0x77, 0x70, 0x87, 0x70, 0x80, 0x87, 0x70, 0x80, 0x00, 0x87, 0x00, 0x08,
   0x77, 0x77, 0x08, 0x08, 0x80, 0x87, 0x08, 0x70, 0x87, 0x08, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77,
   0x77, 0x77, 0x77, 0x09, 0x9F, 0xF9, 0x99, 0x99, 0x91, 0x10, 0x70, 0xDF, 0xFD, 0xD7, 0x77, 0x77,
   0x77, 0x70, 0x88, 0x70, 0x80, 0x88, 0x80, 0x80, 0x87, 0x08, 0x08, 0x77, 0x77, 0x70, 0x80, 0x80,
   0x80, 0x87, 0x08, 0x70, 0x88, 0x08, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x0F,
   0xF9, 0x99, 0x99, 0x99, 0x99, 0x10, 0x70, 0xFD, 0xDD, 0xD7, 0x77, 0x77, 0x77, 0x70, 0x80, 0x80,
   0x87, 0x00, 0x08, 0x70, 0x87, 0x08, 0x00, 0x87, 0x77, 0x70, 0x87, 0x70, 0x80, 0x87, 0x08, 0x70,
   0x00, 0x08, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x70, 0x99, 0x99, 0x99, 0x99,
   0x99, 0x90, 0x77, 0x0D, 0xDD, 0xD7, 0x77, 0x77, 0x77, 0x70, 0x08, 0x00, 0x87, 0x08, 0x08, 0x70,
   0x88, 0x08, 0x08, 0x87, 0x77, 0x70, 0x87, 0x70, 0x80, 0x87, 0x08, 0x70, 0x87, 0x08, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x09, 0x99, 0x99, 0x99, 0x90, 0x07, 0x77, 0x70,
   0xDD, 0x07, 0x77, 0x77, 0x77, 0x70, 0x87, 0x70, 0x87, 0x70, 0x87, 0x70, 0x00, 0x87, 0x00, 0x08,
   0x77, 0x70, 0x87, 0x70, 0x80, 0x80, 0x00, 0x80, 0x87, 0x08, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x70, 0x99, 0x99, 0x90, 0x07, 0x77, 0x77, 0x77, 0x00, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x09, 0x90, 0x07, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0x07, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xFF, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF0
#else /* Made With Udo7 */
   0x42, 0x4D, 0xCA, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, 0x00, 0x28, 0x00,
   0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x54, 0x05, 0x00, 0x00, 0x12, 0x0B, 0x00, 0x00, 0x12, 0x0B, 0x00, 0x00, 0x10, 0x00,
   0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x80,
   0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x80,
   0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF,
   0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF,
   0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   0x00, 0x00, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x22,
   0x07, 0x77, 0x77, 0x00, 0x07, 0x77, 0x0E, 0xEE, 0xE6, 0x66, 0x00, 0x77, 0x7F, 0x87, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x22, 0x20, 0x77, 0x70, 0x0B,
   0x30, 0x77, 0x0E, 0xEE, 0xF6, 0x66, 0x00, 0x7F, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x22, 0x20, 0x70, 0x0B, 0xBB, 0x33, 0x07, 0x0E, 0xFF,
   0xEE, 0x66, 0x00, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x22, 0x20, 0x70, 0xBB, 0xBB, 0x33, 0x30, 0x0F, 0xEE, 0xEE, 0xE6, 0x07, 0x07,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0xA2,
   0x20, 0x70, 0xBB, 0xBB, 0x33, 0x30, 0x70, 0xEE, 0xEE, 0xE0, 0x07, 0x00, 0x77, 0x07, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0xAA, 0x20, 0x70, 0xBB, 0xBF,
   0x33, 0x30, 0x77, 0x0E, 0xE0, 0x07, 0x00, 0xA2, 0x00, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0xAA, 0x00, 0x70, 0xBF, 0xFB, 0xB3, 0x30, 0x77, 0x70,
   0x07, 0x00, 0xAA, 0xA2, 0x20, 0x77, 0x77, 0x77, 0x77, 0x88, 0x88, 0x88, 0x77, 0x77, 0x88, 0x88,
   0x88, 0x87, 0x77, 0x77, 0x77, 0x88, 0x88, 0x87, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x00, 0x77, 0x70, 0xFB, 0xBB, 0xBB, 0x30, 0x77, 0x77, 0x77, 0x0A, 0xAA, 0xA2,
   0x22, 0x07, 0x77, 0x77, 0x7C, 0xCC, 0xCC, 0xC8, 0x87, 0x7C, 0xCC, 0xCC, 0xCC, 0x88, 0x77, 0x77,
   0x7C, 0xCC, 0xCC, 0x88, 0x87, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77,
   0x77, 0x77, 0x0B, 0xBB, 0xBB, 0x00, 0x77, 0x77, 0x77, 0x0A, 0xAA, 0xA2, 0x22, 0x07, 0x77, 0x77,
   0xCC, 0xCC, 0xCC, 0xCC, 0x88, 0x7C, 0xCC, 0xCC, 0xCC, 0xCC, 0x87, 0x77, 0xCC, 0xCC, 0xCC, 0xCC,
   0x88, 0x77, 0x77, 0x77, 0xCC, 0x88, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x00, 0x70, 0xBB,
   0x00, 0x77, 0x70, 0x07, 0x77, 0x0A, 0xAA, 0xF2, 0x22, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x7C,
   0xC8, 0x7C, 0xC8, 0x77, 0x77, 0xCC, 0xC8, 0x7C, 0xCC, 0x87, 0x77, 0xCC, 0xC8, 0x77, 0x77, 0x77,
   0x7C, 0xC8, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x00, 0xC4, 0x07, 0x00, 0x77, 0x70, 0x09, 0x10,
   0x77, 0x0A, 0xFF, 0xAA, 0x22, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x7C, 0xC8, 0x77, 0xCC, 0x87,
   0x77, 0x7C, 0xC8, 0x7C, 0xC8, 0x77, 0x77, 0x7C, 0xC8, 0x87, 0x77, 0x77, 0x7C, 0xC8, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x00, 0xCC, 0xC4, 0x40, 0x77, 0x70, 0x09, 0x99, 0x11, 0x07, 0x0F, 0xAA, 0xAA,
   0xA2, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87, 0x77, 0x7C, 0xCC, 0x8C,
   0xC8, 0x77, 0x77, 0x7C, 0xCC, 0x87, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0x70, 0xF7, 0x0C,
   0xCC, 0xC4, 0x44, 0x00, 0x09, 0x99, 0x99, 0x11, 0x10, 0x70, 0xAA, 0xAA, 0xA0, 0x07, 0x77, 0x77,
   0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x8C, 0xC8, 0x77, 0x77, 0x77,
   0xCC, 0x87, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0x70, 0xF7, 0x0C, 0xCC, 0xC4, 0x44, 0x09,
   0x99, 0x99, 0x99, 0x11, 0x11, 0x07, 0x0A, 0xA0, 0x07, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77,
   0xCC, 0x87, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x8C, 0xC8, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77,
   0x77, 0x7C, 0xC8, 0x77, 0x77, 0x70, 0xF7, 0x0C, 0xCC, 0xF4, 0x44, 0x09, 0x99, 0x99, 0x99, 0x11,
   0x11, 0x10, 0x70, 0x07, 0x70, 0x07, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87,
   0x77, 0x77, 0xCC, 0x8C, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0x77, 0x7C, 0xC8, 0x77,
   0x77, 0x70, 0xF7, 0x0C, 0xFF, 0xCC, 0x44, 0x09, 0x99, 0x99, 0x99, 0x11, 0x11, 0x10, 0x77, 0x70,
   0x0D, 0x57, 0x77, 0x77, 0x7C, 0xC8, 0x77, 0x77, 0xCC, 0x87, 0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87,
   0xCC, 0x87, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x70, 0xF7, 0x0F,
   0xCC, 0xCC, 0xC4, 0x09, 0x99, 0x99, 0x99, 0x11, 0x11, 0x10, 0x70, 0x0D, 0xDD, 0x57, 0x77, 0x77,
   0x7C, 0xC8, 0x77, 0x77, 0x7C, 0xC8, 0x7C, 0xC8, 0x88, 0x8C, 0xCC, 0x87, 0xCC, 0xC8, 0x88, 0x8C,
   0xCC, 0x87, 0x77, 0x77, 0x77, 0x77, 0xCC, 0x87, 0x77, 0x70, 0xF7, 0x70, 0xCC, 0xCC, 0xC0, 0x09,
   0x99, 0x99, 0x99, 0x11, 0x11, 0x10, 0x70, 0xDD, 0xDD, 0x57, 0x77, 0x77, 0x7C, 0xC8, 0x77, 0x77,
   0x7C, 0xC8, 0x7C, 0xCC, 0xCC, 0xCC, 0xC8, 0x77, 0x7C, 0xCC, 0xCC, 0xCC, 0xC8, 0x77, 0x77, 0x77,
   0xCC, 0xCC, 0xCC, 0xC8, 0x77, 0x70, 0xF7, 0x77, 0x0C, 0xC0, 0x07, 0x09, 0x99, 0x99, 0x9F, 0x91,
   0x11, 0x10, 0x70, 0xDD, 0xDD, 0x57, 0x77, 0x77, 0x7C, 0xC7, 0x77, 0x77, 0x7C, 0xC7, 0x7C, 0xCC,
   0xCC, 0xCC, 0x77, 0x77, 0x77, 0x7C, 0xCC, 0xCC, 0x77, 0x77, 0x77, 0x77, 0xCC, 0xCC, 0xCC, 0xCC,
   0x77, 0x70, 0xF7, 0x77, 0x70, 0x07, 0x77, 0x09, 0x99, 0x9F, 0xF9, 0x99, 0x11, 0x10, 0x70, 0xDD,
   0xDF, 0x57, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77,
   0x77, 0x77, 0x77, 0x09, 0x9F, 0xF9, 0x99, 0x99, 0x91, 0x10, 0x70, 0xDF, 0xFD, 0xD7, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x0F,
   0xF9, 0x99, 0x99, 0x99, 0x99, 0x10, 0x70, 0xFD, 0xDD, 0xD7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x70, 0x99, 0x99, 0x99, 0x99,
   0x99, 0x90, 0x77, 0x0D, 0xDD, 0xD7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x09, 0x99, 0x99, 0x99, 0x90, 0x07, 0x77, 0x70,
   0xDD, 0x07, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x70, 0x99, 0x99, 0x90, 0x07, 0x77, 0x77, 0x77, 0x00, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x09, 0x90, 0x07, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0x07, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x70, 0xF7, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
   0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x70, 0xFF, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF0
#endif
};


#endif /* UDO_IMG_WIN_H */
