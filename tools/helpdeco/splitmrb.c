/*
helpdeco -- utility program to dissect Windows help files
Copyright (C) 1996 Manfred Winterhoff
Copyright (C) 2001 Ben Collver

This file is part of helpdeco; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place, Suite 330, Boston, MA, 02111-1307, USA or visit:
http://www.gnu.org
*/

/*
SPLITMRB - splits MRB into SHG/BMP/WMF and SHG into BMP/WMF files - Version 1.5
M.Winterhoff <mawin@gmx.net>, Geschw.-Scholl-Ring 17, 38444 Wolfsburg, Germany

usage: SPLITMRB filename[.mrb] ...
       SPLITMRB filename.shg ...

Output files are created in the current directory using resolution-dependent
extensions *.EGA,*.VGA,*.CGA,*.854,*.MAC or *.BMP,*.WMF or *.Snn,*.nnn (where
n is a digit from 0 to 9). Discarded hotspot info will be written to stdout.
*/
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <limits.h>
#include <stdint.h>
#include "compat.h"

typedef enum { FALSE, TRUE } BOOL;

typedef struct
{
	uint16_t bfType;
	uint32_t bfSize;
	uint16_t bfReserved1;
	uint16_t bfReserved2;
	uint32_t bfOffBits;
} BITMAPFILEHEADER;
#define SIZEOF_BITMAPFILEHEADER 14

typedef struct
{
	uint32_t biSize;
	int32_t biWidth;
	int32_t biHeight;
	uint16_t biPlanes;
	uint16_t biBitCount;
	uint32_t biCompression;
	uint32_t biSizeImage;
	int32_t biXPelsPerMeter;
	int32_t biYPelsPerMeter;
	uint32_t biClrUsed;
	uint32_t biClrImportant;
} BITMAPINFOHEADER;
#define SIZEOF_BITMAPINFOHEADER 40

typedef struct tagRECT
{
	int16_t left;
	int16_t top;
	int16_t right;
	int16_t bottom;
} RECT;

typedef struct
{
	uint32_t dwKey;
	uint16_t hMF;
	RECT rcBBox;
	uint16_t wInch;
	uint32_t dwReserved;
	uint16_t wChecksum;
} APMFILEHEADER;


/* read 16 bit value from memory mapped file or regular file */
static int GetWord(FILE *f)
{
	unsigned char b;

	b = getc(f);
	return ((uint16_t) (getc(f)) << 8) | (uint16_t) b;
}


/* get compressed word from regular file */
static uint16_t GetCWord(FILE *f)
{
	unsigned char b;

	b = getc(f);
	if (b & 1)
		return (((uint16_t) getc(f) << 8) | (uint16_t) b) >> 1;
	return ((uint16_t) b >> 1);
}

/* get compressed long from regular file */
static uint32_t GetCDWord(FILE *f)
{
	uint16_t w;

	w = GetWord(f);
	if (w & 1)
		return (((uint32_t) GetWord(f) << 16) | (uint32_t) w) >> 1;
	return ((uint32_t) w >> 1);
}


static uint32_t GetDWord(FILE * f)
{
	uint16_t w;

	w = GetWord(f);
	return ((uint32_t) GetWord(f) << 16) | (uint32_t) w;
}


static int32_t copy(FILE * f, int32_t bytes, FILE * out)
{
	int32_t length;
	int size;
	char buffer[1024];

	for (length = 0; length < bytes; length += size)
	{
		size = (int) (bytes - length > (int)sizeof(buffer) ? (int)sizeof(buffer) : bytes - length);
		fread(buffer, 1, size, f);
		fwrite(buffer, size, 1, out);
	}
	return length;
}

static signed char runlen_count;						/* for run len decompression */

static int derun(int c, FILE * f)				/* expand runlen compressed data */
{
	int i;

	if (runlen_count & 0x7F)
	{
		if (runlen_count & 0x80)
		{
			putc(c, f);
			runlen_count--;
			return 1;
		}
		for (i = 0; i < runlen_count; i++)
		{
			putc(c, f);
		}
		runlen_count = 0;
		return i;
	}
	runlen_count = (signed char) c;
	return 0;
}


static int32_t decompress(int method, FILE * f, int32_t bytes, FILE * fTarget)
{
	static unsigned char lzbuffer[0x1000];
	int (*Emit) (int c, FILE * f);
	unsigned char bits, mask;
	int pos, len, back;
	int32_t n;

	n = 0;
	if (method & 1)
	{
		Emit = derun;
		runlen_count = 0;
	} else
	{
		Emit = fputc;
	}
	if (method & 2)
	{
		mask = 0;
		pos = 0;
		while (bytes-- > 0L)
		{
			if (!mask)
			{
				bits = getc(f);
				mask = 1;
			} else
			{
				if (bits & mask)
				{
					if (bytes-- == 0)
						break;
					back = GetWord(f);
					len = ((back >> 12) & 15) + 3;
					back = pos - (back & 0xFFF) - 1;
					while (len-- > 0)
					{
						n += Emit(lzbuffer[pos++ & 0xFFF] = lzbuffer[back++ & 0xFFF], fTarget);
					}
				} else
				{
					n += Emit(lzbuffer[pos++ & 0xFFF] = getc(f), fTarget);
				}
				mask <<= 1;
			}
		}
	} else
	{
		while (bytes-- > 0L)
			n += Emit(getc(f), fTarget);
	}
	return n;
}


/* RulLen decompression */
static int GetPackedByte(FILE * f)
{
	static unsigned char count, value;

	if (!f)								/* initialize */
	{
		count = value = 0;
	} else
	{
		if ((count & 0x7F) == 0)
		{
			count = getc(f);
			value = getc(f);
		} else if (count & 0x80)
		{
			value = getc(f);
		}
		count--;
	}
	return value;
}


typedef struct
{
	uint8_t id0, id1, id2;
	uint16_t x, y, w, h;
	uint32_t hash;
} HOTSPOT;



/* write 16 bit quantity */
static void my_putw(uint16_t w, FILE *f)
{
	putc((w & 0xFF), f);
	putc((w >> 8), f);
}


/* write long to file */
static void putdw(uint32_t x, FILE *f)
{
	my_putw(x & 0xffff, f);
	my_putw((x >> 16) & 0xffff, f);
}


static void read_hotspot(FILE *f, HOTSPOT *hotspot)
{
	hotspot->id0 = getc(f);
	hotspot->id1 = getc(f);
	hotspot->id2 = getc(f);
	hotspot->x = GetWord(f);
	hotspot->y = GetWord(f);
	hotspot->w = GetWord(f);
	hotspot->h = GetWord(f);
	hotspot->hash = GetDWord(f);
}


static void put_bitmapfileheader(FILE *f, const BITMAPFILEHEADER *bmfh)
{
	my_putw(bmfh->bfType, f);
	putdw(bmfh->bfSize, f);
	my_putw(bmfh->bfReserved1, f);
	my_putw(bmfh->bfReserved2, f);
	putdw(bmfh->bfOffBits, f);
}


static void put_bitmapinfoheader(FILE *f, const BITMAPINFOHEADER *bmih)
{
	putdw(bmih->biSize, f);
	putdw(bmih->biWidth, f);
	putdw(bmih->biHeight, f);
	my_putw(bmih->biPlanes, f);
	my_putw(bmih->biBitCount, f);
	putdw(bmih->biCompression, f);
	putdw(bmih->biSizeImage, f);
	putdw(bmih->biXPelsPerMeter, f);
	putdw(bmih->biYPelsPerMeter, f);
	putdw(bmih->biClrUsed, f);
	putdw(bmih->biClrImportant, f);
}


static void put_apmfileheader(FILE *f, const APMFILEHEADER *apm)
{
	putdw(apm->dwKey, f);
	my_putw(apm->hMF, f);
	my_putw(apm->rcBBox.left, f);
	my_putw(apm->rcBBox.top, f);
	my_putw(apm->rcBBox.right, f);
	my_putw(apm->rcBBox.bottom, f);
	my_putw(apm->wInch, f);
	putdw(apm->dwReserved, f);
	my_putw(apm->wChecksum, f);
}


static void PrintHotspotInfo(FILE *f)
{
	int i, l, n;
	HOTSPOT *hotspot;
	char name[80];
	char buffer[128];

	if (getc(f) == 1)
	{
		n = GetWord(f);
		if (n > 0)
		{
			hotspot = (HOTSPOT *)malloc(n * sizeof(HOTSPOT));
			if (hotspot)
			{
				l = GetDWord(f);			/* macro data size */
				for (i = 0; i < n; i++)
					read_hotspot(f, hotspot + i);
				for (i = 0; i < l; i++)
					getc(f);
				for (i = 0; i < n; i++)
				{
					for (l = 0; l < (int)sizeof(name) && (name[l] = getc(f)) != '\0'; l++)
						;
					for (l = 0; l < (int)sizeof(buffer) && (buffer[l] = getc(f)) != '\0'; l++)
						;
					printf("'%s' ", buffer);
					if ((hotspot[i].id0 & 0xF0) == 0xC0)
					{
						printf("Macro ");
					} else if (hotspot[i].id0 & 1)
					{
						printf("Jump ");
					} else
					{
						printf("Pop-up ");
					}
					if (hotspot[i].id1)
					{
						printf("Invisible");
					} else
					{
						printf("Visible ");
					}
					printf(" '%s' %d,%d,%d,%d\n", name, hotspot[i].x, hotspot[i].y, hotspot[i].x + hotspot[i].w, hotspot[i].y + hotspot[i].h);
				}
				free(hotspot);
			}
		}
	}
}


int main(int argc, char *argv[])
{
	FILE *f;

	FILE *fTarget;

	int i,
	 j,
	 l,
	 m,
	 n;
	uint32_t colors;

	unsigned char byType,
	 byPacked;

	int32_t dwDataSize,
	 dwHotspotOffset,
	 dwHotspotSize,
	 w,
	 h,
	 offset;

	BITMAPFILEHEADER bmfh;

	BITMAPINFOHEADER bmih;

	APMFILEHEADER afh;

	char filename[PATH_MAX];

	BOOL res[7];

	assert(sizeof(HOTSPOT) == 15);

	if (argc < 2)
	{
		fprintf(stderr, "SPLITMRB - splits MRB into SHG/BMP/WMF and SHG into BMP/WMF files - Version 1.5\n"
				"M.Winterhoff <mawin@gmx.net>, Geschw.-Scholl-Ring 17, 38444 Wolfsburg, Germany\n"
				"\n"
				"usage: SPLITMRB filename[.mrb] ...\n"
				"       SPLITMRB filename.shg ...\n"
				"\n"
				"Output files are created in the current directory using resolution-dependent\n"
				"extensions *.EGA,*.VGA,*.CGA,*.854,*.MAC or *.BMP,*.WMF or *.Snn,*.nnn (where\n"
				"n is a digit from 0 to 9). Discarded hotspot info will be written to stdout.\n" "\n");
	} else
		for (i = 1; i < argc; i++)
		{
			strcpy(filename, argv[i]);
			l = strlen(filename);
			while (l > 0 && filename[l - 1] != '\\' && filename[l - 1] != '/' && filename[l - 1] != ':')
				l--;
			m = l;
			while (filename[l] != '\0' && filename[l] != '.')
				l++;
			if (filename[l] == '\0')
				strcpy(filename + l, ".mrb");
			f = fopen(filename, "rb");
			if (!f)
			{
				fprintf(stderr, "Can not open '%s'\n", filename);
			} else
			{
				if ((GetWord(f) & 0xDFFF) != 0x506C)
				{
					fprintf(stderr, "'%s' is no MRB/SHG bitmap\n", argv[i]);
				} else
				{
					n = GetWord(f);
					res[0] = res[1] = res[2] = res[3] = res[4] = res[5] = res[6] = FALSE;
					for (j = 0; j < n; j++)
					{
						fseek(f, 4 * (j + 1), SEEK_SET);
						fread(&offset, sizeof(offset), 1, f);
						fseek(f, offset, SEEK_SET);
						byType = getc(f);	/* type of picture: 5=DDB, 6=DIB, 8=METAFILE */
						byPacked = getc(f);	/* packing method: 0=unpacked, 1=RunLen, 2=LZ77 */
						if (byType == 6 || (byType == 5 && byPacked < 2))
						{
							memset(&bmfh, 0, sizeof(bmfh));
							memset(&bmih, 0, sizeof(bmih));
							bmfh.bfType = 0x4D42;	/* bitmap magic ("BM") */
							bmih.biSize = SIZEOF_BITMAPINFOHEADER;
							w = GetCDWord(f);
							bmih.biXPelsPerMeter = (w * 79L + 1) / 2;
							h = GetCDWord(f);
							bmih.biYPelsPerMeter = (h * 79L + 1) / 2;
							bmih.biPlanes = GetCWord(f);
							bmih.biBitCount = GetCWord(f);
							bmih.biWidth = GetCDWord(f);
							bmih.biHeight = GetCDWord(f);
							colors = bmih.biClrUsed = GetCDWord(f);
							if (!colors)
								colors = 1 << bmih.biBitCount;
							bmih.biClrImportant = GetCDWord(f);
							dwDataSize = GetCDWord(f);
							dwHotspotSize = GetCDWord(f);
							GetDWord(f);	/* dwPictureOffset */
							dwHotspotOffset = GetDWord(f);
							if (dwHotspotOffset && n > 1)	/* dwHotspotOffset */
							{
								/* save as SHG */
								sprintf(filename + l, ".S%02d", j);
								fTarget = fopen(filename + m, "wb");
								if (fTarget)
								{
									fprintf(stderr, "Extracting Segmented Hotspot Graphic '%s'...\n", filename + m);
									my_putw(0x506C, fTarget);
									my_putw(1, fTarget);
									my_putw(8, fTarget);
									my_putw(0, fTarget);
									fseek(f, offset, SEEK_SET);
									copy(f, dwHotspotOffset + dwHotspotSize, fTarget);
									fclose(fTarget);
								} else
								{
									fprintf(stderr, "Can not create '%s'\n", filename + m);
								}
							} else
							{
								sprintf(filename + l, ".%03d", j);
								if (w == 96 && h == 48 && !res[0])
								{
									strcpy(filename + l, ".cga");
									res[0] = TRUE;
								} else if (w == 96 && h == 72 && !res[1])
								{
									strcpy(filename + l, ".ega");
									res[1] = TRUE;
								} else if (w == 96 && h == 96 && !res[2])
								{
									strcpy(filename + l, ".vga");
									res[2] = TRUE;
								} else if (w == 120 && h == 120 && !res[3])
								{
									strcpy(filename + l, ".854");
									res[3] = TRUE;
								} else if (w == 72 && h == 72 && !res[4])
								{
									strcpy(filename + l, ".mac");
									res[4] = TRUE;
								} else if (!res[6])
								{
									strcpy(filename + l, ".bmp");
									res[6] = TRUE;
								}
								fTarget = fopen(filename + m, "wb");
								if (fTarget)
								{
									fprintf(stderr, "Extracting %ld x %ld x %u Bitmap '%s' (%ldx%ld dpi)...\n",
											(long)bmih.biWidth, (long)bmih.biHeight, bmih.biPlanes * bmih.biBitCount, filename + m,
											(long)w, (long)h);
									put_bitmapfileheader(fTarget, &bmfh);
									put_bitmapinfoheader(fTarget, &bmih);
									if (byType == 6)
									{
										copy(f, colors * 4L, fTarget);
									} else
									{
										putdw(0x000000L, fTarget);
										putdw(0xFFFFFFL, fTarget);
									}
									bmfh.bfOffBits = SIZEOF_BITMAPFILEHEADER + SIZEOF_BITMAPINFOHEADER + colors * 4L;
									bmih.biSizeImage = (((bmih.biWidth * bmih.biBitCount + 31) / 32) * 4) * bmih.biHeight;
									if (byType == 5)	/* convert 3.0 DDB to 3.1 DIB */
									{
										int32_t width, length, l;
										int pad;

										width = ((bmih.biWidth * bmih.biBitCount + 15) / 16) * 2;
										pad = (int) (((width + 3) / 4) * 4 - width);
										GetPackedByte(NULL);
										for (l = 0; l < bmih.biHeight; l++)
										{
											if (byPacked == 1)
											{
												for (length = 0; length < width; length++)
													putc(GetPackedByte(f), fTarget);
											} else
											{
												copy(f, width, fTarget);
											}
											if (pad)
												fwrite("    ", pad, 1, fTarget);
										}
									} else
									{
										decompress(byPacked, f, dwDataSize, fTarget);
									}
									/* update bitmap headers */
									bmfh.bfSize = ftell(fTarget);
									fseek(fTarget, 0L, SEEK_SET);
									put_bitmapfileheader(fTarget, &bmfh);
									put_bitmapinfoheader(fTarget, &bmih);
									fclose(fTarget);
									if (dwHotspotOffset)
									{
										fseek(f, offset + dwHotspotOffset, SEEK_SET);
										PrintHotspotInfo(f);
									}
								} else
								{
									fprintf(stderr, "Can not create '%s'\n", filename + m);
								}
							}
						} else if (byType == 8)	/* Windows MetaFile */
						{
							memset(&afh, 0, sizeof(afh));
							afh.dwKey = 0x9AC6CDD7L;
							GetCWord(f);	/* mapping mode */
							afh.rcBBox.right = GetWord(f);	/* width of metafile-picture */
							afh.rcBBox.bottom = GetWord(f);	/* height of metafile-picture */
							GetCDWord(f);
							dwDataSize = GetCDWord(f);
							dwHotspotSize = GetCDWord(f);	/* dwHotspotSize */
							GetDWord(f);	/* dwPictureOffset */
							dwHotspotOffset = GetDWord(f);
							if (dwHotspotOffset && n > 1)	/* dwHotspotOffset */
							{
								sprintf(filename + l, ".S%02d", j);
								fTarget = fopen(filename + m, "wb");
								if (fTarget)
								{
									fprintf(stderr, "Extracting Segmented Hotspot Graphic '%s'...\n", filename + m);
									my_putw(0x506C, fTarget);
									my_putw(1, fTarget);
									my_putw(8, fTarget);
									my_putw(0, fTarget);
									fseek(f, offset, SEEK_SET);
									copy(f, dwHotspotOffset + dwHotspotSize, fTarget);
									fclose(fTarget);
								} else
								{
									fprintf(stderr, "Can not create '%s'\n", filename + m);
								}
							} else
							{
								afh.wInch = 2540;
							 	afh.wChecksum ^= afh.dwKey & 0xffff;
								afh.wChecksum ^= (afh.dwKey >> 16) & 0xffff;
								afh.wChecksum ^= afh.hMF;
								afh.wChecksum ^= afh.rcBBox.left;
								afh.wChecksum ^= afh.rcBBox.top;
								afh.wChecksum ^= afh.rcBBox.right;
								afh.wChecksum ^= afh.rcBBox.bottom;
								afh.wChecksum ^= afh.wInch;
								afh.wChecksum ^= afh.dwReserved & 0xffff;
								afh.wChecksum ^= (afh.dwReserved >> 16) & 0xffff;
								if (!res[5])
								{
									strcpy(filename + l, ".wmf");
									res[5] = TRUE;
								} else
								{
									sprintf(filename + l, ".%03d", j);
								}
								fTarget = fopen(filename + m, "wb");
								if (fTarget)
								{
									fprintf(stderr, "Extracting Metafile '%s'...\n", filename + m);
									put_apmfileheader(fTarget, &afh);
									decompress(byPacked, f, dwDataSize, fTarget);
									fclose(fTarget);
								}
								if (dwHotspotOffset)
								{
									fseek(f, offset + dwHotspotOffset, SEEK_SET);
									PrintHotspotInfo(f);
								}
							}
						} else
						{
							fprintf(stderr, "Picture %d of '%s' unknown type %02x pack=%02x skipped.\n", j, argv[i],
									byType, byPacked);
						}
					}
				}
				fclose(f);
			}
		}
	return 0;
}
