#ifndef __CHMLZX_H__
#define __CHMLZX_H__ 1

/***************************************************************************
 *                        lzx.h - LZX decompression routines               *
 *                           -------------------                           *
 *                                                                         *
 *  maintainer: Jed Wing <jedwin@ugcs.caltech.edu>                         *
 *  source:     modified lzx.c from cabextract v0.5                        *
 *  notes:      This file was taken from cabextract v0.5, which was,       *
 *              itself, a modified version of the lzx decompression code   *
 *              from unlzx.                                                *
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.  Note that an exemption to this   *
 *   license has been granted by Stuart Caie for the purposes of           *
 *   distribution with chmlib.  This does not, to the best of my           *
 *   knowledge, constitute a change in the license of this (the LZX) code  *
 *   in general.                                                           *
 *                                                                         *
 ***************************************************************************/

EXTERN_C_BEG

/* return codes */
#define DECR_OK           (0)
#define DECR_DATAFORMAT   (1)
#define DECR_ILLEGALDATA  (2)
#define DECR_NOMEMORY     (3)

#define LZX_FRAME_SIZE (32768) /* the size of a frame in LZX */

/* opaque state structure */
typedef struct _LZXstate LZXstate;

/* create an lzx state object */
LZXstate *LZXinit(int window);

/* destroy an lzx state object */
void LZXteardown(LZXstate *pState);

/* reset an lzx stream */
int LZXreset(LZXstate *pState);

/* decompress an LZX compressed block */
int LZXdecompress(LZXstate *pState, const unsigned char *inpos, unsigned char *outpos, int inlen, int outlen);

EXTERN_C_END

#endif /* __CHMLZX_H__ */
