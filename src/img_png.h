#ifndef UDO_IMG_PNG_H
#define UDO_IMG_PNG_H

/*	############################################################
	# @(#) img_png.h
	# @(#)
	# @(#) Copyright (c) 1995-2001 by Dirk Hagedorn
	# @(#) Dirk Hagedorn (udo@dirk-hagedorn.de)
	#
	# This program is free software; you can redistribute it and/or
	# modify it under the terms of the GNU General Public License
	# as published by the Free Software Foundation; either version 2
	# of the License, or (at your option) any later version.
	# 
	# This program is distributed in the hope that it will be useful,
	# but WITHOUT ANY WARRANTY; without even the implied warranty of
	# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	# GNU General Public License for more details.
	# 
	# You should have received a copy of the GNU General Public License
	# along with this program; if not, write to the Free Software
	# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
	# 
	############################################################	*/
LOCAL const unsigned char pdf_png_mw[]=
{
#if 0 /* Made With Udo6 */
	0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
	0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x1F, 0x04, 0x03, 0x00, 0x00, 0x00, 0x91, 0xE6, 0x17,
	0xD3, 0x00, 0x00, 0x00, 0x30, 0x50, 0x4C, 0x54, 0x45, 0x00, 0x00, 0x00, 0x99, 0x99, 0x99, 0x00,
	0xFF, 0xFF, 0x00, 0xFF, 0x00, 0x00, 0x99, 0x00, 0x99, 0x00, 0x00, 0x00, 0x00, 0x99, 0xCC, 0xCC,
	0xCC, 0xFF, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x99, 0x99, 0x00, 0x00, 0x99, 0x99, 0x99, 0x00, 0x99,
	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x46, 0x59, 0xE8, 0x1E, 0x00, 0x00, 0x01,
	0xE7, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x95, 0xD3, 0xB1, 0x6E, 0xDB, 0x30, 0x10, 0x00, 0xD0,
	0x63, 0x3C, 0xD0, 0x1A, 0xEC, 0x88, 0x13, 0x47, 0x17, 0x5A, 0xB3, 0x14, 0x90, 0x3E, 0x20, 0x43,
	0x3E, 0xC0, 0x8B, 0xF7, 0x4E, 0x9D, 0x6F, 0xE3, 0x14, 0x68, 0xAC, 0x97, 0x00, 0x59, 0x32, 0x68,
	0x08, 0xE0, 0xD9, 0xBF, 0xE0, 0x0F, 0xC8, 0xDA, 0xA1, 0x68, 0x12, 0x04, 0xCE, 0x07, 0x14, 0x88,
	0x10, 0x2E, 0xCE, 0xC8, 0xDE, 0x1D, 0xC9, 0xC4, 0x09, 0x5A, 0xDB, 0xA1, 0xAD, 0xB3, 0x64, 0x3F,
	0x9E, 0x8F, 0x47, 0x09, 0xD6, 0x87, 0x8F, 0x9F, 0x70, 0xEB, 0x0E, 0x1E, 0x98, 0x31, 0xEA, 0x4F,
	0xE0, 0xE2, 0x72, 0xBF, 0xCE, 0x18, 0xBB, 0x4E, 0x34, 0x1C, 0x82, 0x8B, 0x4E, 0x34, 0xCE, 0x79,
	0x06, 0x5A, 0x79, 0x81, 0x05, 0xC5, 0xE7, 0x65, 0x09, 0xA5, 0x55, 0x6F, 0x98, 0x12, 0xB3, 0x76,
	0xC3, 0xF9, 0x0F, 0xBE, 0x52, 0x60, 0x95, 0x42, 0xA3, 0x94, 0x15, 0x6C, 0x15, 0x6E, 0xE3, 0xD1,
	0x3D, 0xE3, 0x29, 0xDE, 0x45, 0x5C, 0x96, 0x94, 0x94, 0x00, 0xBC, 0x62, 0xD8, 0xC2, 0xC5, 0x35,
	0xE9, 0xAB, 0x29, 0x5E, 0xDC, 0x09, 0x36, 0x58, 0x1A, 0x9A, 0xA0, 0x94, 0x4C, 0x64, 0x6C, 0x32,
	0xA6, 0xAE, 0x15, 0x1D, 0xE9, 0xD9, 0x14, 0xE7, 0x17, 0x37, 0xB1, 0xE6, 0x92, 0xDE, 0x52, 0xB3,
	0x53, 0xEA, 0x5D, 0x19, 0xC7, 0xCF, 0x9A, 0xD6, 0x77, 0x7D, 0xC5, 0x78, 0x7E, 0xB3, 0xBB, 0x1B,
	0x18, 0xC2, 0x33, 0x37, 0x63, 0x76, 0x08, 0x1E, 0x85, 0xB0, 0xC9, 0x78, 0xB8, 0x0F, 0x1F, 0xAF,
	0xC3, 0xF7, 0x84, 0x1D, 0x0E, 0xF7, 0xE1, 0xF0, 0x3B, 0x63, 0xD4, 0x7C, 0x8B, 0xB4, 0x2F, 0x7C,
	0xB4, 0x21, 0x04, 0x02, 0xAD, 0x44, 0xE7, 0xF8, 0x43, 0xF0, 0x26, 0x61, 0x3D, 0xF8, 0xCA, 0x1B,
	0xD8, 0x7A, 0x3E, 0x18, 0x7B, 0x17, 0xA3, 0xCC, 0xF1, 0x19, 0x03, 0x69, 0x4A, 0x5C, 0xD7, 0xAC,
	0x13, 0xF6, 0x66, 0x12, 0x6C, 0x90, 0x48, 0x89, 0xFD, 0x44, 0x30, 0x84, 0xCD, 0x37, 0x87, 0x45,
	0x37, 0xD3, 0xA3, 0xBA, 0x6E, 0x12, 0x26, 0x66, 0xDF, 0x62, 0x3C, 0xA4, 0xCF, 0xB0, 0xD1, 0x40,
	0x7A, 0xEA, 0x06, 0xEB, 0xFA, 0x4C, 0xE7, 0x1F, 0x25, 0x4E, 0x12, 0x6C, 0x7D, 0x78, 0x49, 0xDB,
	0x0D, 0xD8, 0x03, 0xEF, 0xE3, 0xA0, 0xFE, 0xF5, 0x11, 0x73, 0xBD, 0x8C, 0x43, 0x5A, 0x20, 0x5D,
	0x8E, 0xFB, 0x9E, 0x6F, 0xE4, 0x41, 0xDD, 0xFC, 0x17, 0x1B, 0x8A, 0x5C, 0xB3, 0xC3, 0xC7, 0xBE,
	0x5F, 0xFC, 0x03, 0xB7, 0x82, 0x5B, 0x29, 0xC3, 0x45, 0x5C, 0x03, 0x3E, 0x3D, 0xFE, 0x59, 0x50,
	0x1D, 0x50, 0x37, 0xA7, 0x29, 0x93, 0x8F, 0x31, 0x36, 0x66, 0x1B, 0x9F, 0x62, 0xFF, 0xB4, 0x5C,
	0xB8, 0xA3, 0x2F, 0x1A, 0x1A, 0xC8, 0x58, 0x5A, 0xE2, 0x39, 0x6B, 0x48, 0x6D, 0x17, 0xDC, 0x10,
	0xEE, 0x97, 0x0B, 0xAC, 0x2A, 0xD2, 0x8E, 0xCB, 0xA0, 0x61, 0x78, 0x49, 0x2C, 0xF9, 0x5C, 0x36,
	0xD0, 0xCB, 0x02, 0xCF, 0x22, 0x1E, 0x55, 0xD5, 0x89, 0x96, 0x27, 0x9C, 0x77, 0xCB, 0xB6, 0x51,
	0xD1, 0x87, 0xB1, 0x2E, 0x16, 0x9E, 0xF0, 0xB8, 0x5F, 0xEA, 0xA3, 0x75, 0xB5, 0x4A, 0x4F, 0xAF,
	0x31, 0x46, 0x82, 0x95, 0x73, 0x1B, 0xBF, 0xCB, 0xD8, 0xE1, 0x98, 0x4A, 0xAE, 0x1E, 0x56, 0x70,
	0x7E, 0xBB, 0xE3, 0xA6, 0x13, 0x4C, 0xFF, 0x0D, 0x9A, 0xF0, 0xC9, 0x0A, 0xDC, 0xB9, 0xDD, 0x8D,
	0x77, 0xE5, 0xFA, 0x88, 0x3F, 0x33, 0xFE, 0x02, 0xBF, 0xA8, 0x70, 0x49, 0x35, 0x01, 0xE4, 0x58,
	0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
#else /* Made With Udo7 */
	0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
	0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x1F, 0x04, 0x03, 0x00, 0x00, 0x00, 0x91, 0xE6, 0x17,
	0xD3, 0x00, 0x00, 0x00, 0x30, 0x50, 0x4C, 0x54, 0x45, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00,
	0xFF, 0xFF, 0x00, 0xFF, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x80, 0x80, 0xFF, 0x00, 0xFF, 0xFF, 0x00,
	0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x80, 0x80, 0x00, 0x80, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,
	0x00, 0x80, 0x00, 0x80, 0x80, 0x00, 0x00, 0x00, 0xFF, 0xF5, 0x1F, 0x1E, 0xBD, 0x00, 0x00, 0x01,
	0xA6, 0x49, 0x44, 0x41, 0x54, 0x38, 0x8D, 0x95, 0xD4, 0x31, 0x6E, 0x83, 0x30, 0x14, 0x00, 0x50,
	0x2B, 0x58, 0x61, 0x20, 0x52, 0xC8, 0x0D, 0x2A, 0xA4, 0xEC, 0x95, 0x3C, 0x23, 0x79, 0xF0, 0x96,
	0x81, 0x29, 0x37, 0xA8, 0x58, 0xB2, 0x34, 0x13, 0x43, 0x56, 0x0F, 0x6C, 0xE9, 0xDA, 0xBD, 0x07,
	0xE8, 0xD0, 0xA6, 0xAA, 0x48, 0x4F, 0x10, 0xAB, 0xCA, 0x05, 0x22, 0x71, 0x82, 0x28, 0x43, 0x07,
	0x98, 0xDC, 0xFF, 0x6D, 0x48, 0x68, 0xAB, 0x02, 0xB1, 0xC4, 0xC7, 0x48, 0x4F, 0xDF, 0x9F, 0x6F,
	0x03, 0xC9, 0xFA, 0x8F, 0x67, 0xF2, 0x22, 0x7A, 0x0F, 0x5E, 0x63, 0x4E, 0xAF, 0xC0, 0xEE, 0x7D,
	0xB7, 0xAE, 0x31, 0x4F, 0x12, 0xA3, 0x49, 0x1F, 0xEC, 0x26, 0x46, 0xF3, 0xB8, 0x2D, 0x7F, 0x85,
	0x21, 0x31, 0x6A, 0x31, 0x8C, 0xEF, 0xBA, 0xB1, 0xF7, 0x86, 0xD8, 0xE7, 0x9B, 0x3E, 0xD8, 0x5D,
	0x81, 0x5E, 0xFA, 0x7C, 0xB1, 0xE9, 0xC2, 0xD0, 0x35, 0x37, 0x01, 0x3D, 0xF1, 0x79, 0xBC, 0x78,
	0xEA, 0xC0, 0xE3, 0x13, 0x85, 0xF7, 0x5B, 0x2D, 0x11, 0xC7, 0x80, 0xA3, 0x2F, 0xBC, 0x22, 0xAD,
	0x35, 0x80, 0xC8, 0x44, 0xA1, 0xF1, 0x09, 0x30, 0xD7, 0xFA, 0x84, 0xCD, 0x98, 0x9C, 0x71, 0x81,
	0x17, 0xE2, 0x42, 0xD8, 0x68, 0x70, 0x81, 0xD8, 0xD3, 0xBA, 0xAC, 0xF1, 0xB0, 0x81, 0x8B, 0x74,
	0xAD, 0xA5, 0x36, 0xD1, 0xE4, 0x96, 0x88, 0xC7, 0x99, 0x7E, 0xAC, 0xB0, 0xE0, 0xC3, 0x0A, 0x03,
	0x93, 0x97, 0xD8, 0xC0, 0xFA, 0xBD, 0xC6, 0x9C, 0xE2, 0x11, 0x69, 0xB0, 0xF5, 0x19, 0x63, 0x06,
	0x83, 0xCB, 0x0A, 0x53, 0xE7, 0x96, 0x8A, 0x9F, 0xB8, 0x10, 0x7F, 0x31, 0x01, 0x0D, 0x89, 0x19,
	0xBB, 0xA5, 0xFF, 0x60, 0x0C, 0x80, 0x89, 0x2E, 0x1F, 0x04, 0x77, 0x93, 0x09, 0xF5, 0x18, 0x0B,
	0x9B, 0x38, 0x32, 0x38, 0x6A, 0x62, 0x41, 0x4A, 0x4A, 0x40, 0xFB, 0xC2, 0xC9, 0xD8, 0xC1, 0x62,
	0x58, 0xD4, 0x44, 0xDB, 0x18, 0x69, 0xAB, 0xB0, 0xDB, 0x4D, 0xB8, 0x22, 0xB8, 0x8F, 0x0E, 0xFB,
	0x38, 0x63, 0xD3, 0x92, 0x02, 0xB3, 0x9A, 0x3E, 0x5F, 0xB0, 0x18, 0x29, 0x85, 0x07, 0xD9, 0x61,
	0xA1, 0xC1, 0x30, 0x52, 0xDC, 0x0D, 0x94, 0x38, 0xC7, 0x2A, 0x52, 0x8B, 0x21, 0xE9, 0x56, 0xA9,
	0xFC, 0x82, 0xC1, 0x15, 0x32, 0xB2, 0x0A, 0x6E, 0x69, 0x5D, 0x32, 0x62, 0x46, 0xF8, 0x6E, 0xFB,
	0x99, 0x43, 0x1D, 0x84, 0x85, 0x7B, 0xEC, 0x7F, 0x9A, 0xA6, 0x26, 0x48, 0x33, 0x97, 0xCD, 0x83,
	0xC4, 0xF6, 0x5C, 0xED, 0x8E, 0xB9, 0x18, 0xDC, 0x50, 0x12, 0x76, 0x7D, 0x56, 0x21, 0x60, 0x75,
	0xCC, 0x79, 0x10, 0x80, 0x16, 0xB4, 0x1D, 0x1F, 0x2C, 0xF6, 0x82, 0x60, 0x4A, 0xDB, 0x68, 0x8D,
	0x47, 0xEA, 0x48, 0x07, 0x59, 0x30, 0xEF, 0xF8, 0xE3, 0x18, 0x2C, 0xF8, 0x08, 0x4A, 0x0E, 0x5E,
	0xE7, 0x64, 0xD6, 0xAA, 0x11, 0xC3, 0xDA, 0x84, 0x02, 0x9E, 0xCE, 0x89, 0x98, 0xC9, 0x76, 0xDC,
	0xBA, 0xF2, 0x2F, 0x7C, 0xCD, 0xF8, 0x06, 0x6C, 0xA9, 0xF7, 0x67, 0x69, 0xCB, 0x48, 0xA5, 0x00,
	0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
#endif
};

/*	############################################################
	# img_png.h
	############################################################	*/

#endif /* UDO_IMG_PNG_H */

