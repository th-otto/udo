/***************************************************************************
 *                        lzx.c - LZX decompression routines               *
 *                           -------------------                           *
 *                                                                         *
 *  maintainer: Jed Wing <jedwin@ugcs.caltech.edu>                         *
 *  source:     modified lzx.c from cabextract v0.5                        *
 *  notes:      This file was taken from cabextract v0.5, which was,       *
 *              itself, a modified version of the lzx decompression code   *
 *              from unlzx.                                                *
 *                                                                         *
 *  platforms:  In its current incarnation, this file has been tested on   *
 *              two different Linux platforms (one, redhat-based, with a   *
 *              2.1.2 glibc and gcc 2.95.x, and the other, Debian, with    *
 *              2.2.4 glibc and both gcc 2.95.4 and gcc 3.0.2).  Both were *
 *              Intel x86 compatible machines.                             *
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

#include "chmtools.h"
#include "lzx.h"

#undef BITS_ORDER_LSB
#define BITS_ORDER_MSB
#define HUFF_MAXBITS 16
#define D(x)


/* some constants defined by the LZX specification */
#define LZX_MIN_MATCH                (2)
#define LZX_MAX_MATCH                (257)
#define LZX_NUM_CHARS                (256)
#define LZX_BLOCKTYPE_INVALID        (0)	/* also blocktypes 4-7 invalid */
#define LZX_BLOCKTYPE_VERBATIM       (1)
#define LZX_BLOCKTYPE_ALIGNED        (2)
#define LZX_BLOCKTYPE_UNCOMPRESSED   (3)
#define LZX_PRETREE_NUM_ELEMENTS     (20)
#define LZX_ALIGNED_NUM_ELEMENTS     (8)	/* aligned offset tree #elements */
#define LZX_NUM_PRIMARY_LENGTHS      (7)	/* this one missing from spec! */
#define LZX_NUM_SECONDARY_LENGTHS    (249)	/* length tree #elements */

/* LZX huffman defines: tweak tablebits as desired */
#define LZX_PRETREE_MAXSYMBOLS  (LZX_PRETREE_NUM_ELEMENTS)
#define LZX_PRETREE_TABLEBITS   (6)
#define LZX_MAINTREE_MAXSYMBOLS (LZX_NUM_CHARS + 290*8)
#define LZX_MAINTREE_TABLEBITS  (12)
#define LZX_LENGTH_MAXSYMBOLS   (LZX_NUM_SECONDARY_LENGTHS+1)
#define LZX_LENGTH_TABLEBITS    (12)
#define LZX_ALIGNED_MAXSYMBOLS  (LZX_ALIGNED_NUM_ELEMENTS)
#define LZX_ALIGNED_TABLEBITS   (7)

#define LZX_LENTABLE_SAFETY (64)			/* we allow length table decoding overruns */

#define LZX_DECLARE_TABLE(tbl) \
  uint16_t tbl##_table[(1<<LZX_##tbl##_TABLEBITS) + (LZX_##tbl##_MAXSYMBOLS<<1)];\
  uint8_t tbl##_len  [LZX_##tbl##_MAXSYMBOLS + LZX_LENTABLE_SAFETY]

struct _LZXstate
{
	uint8_t *window;					/* the actual decoding window              */
	uint32_t window_size;				/* window size (32Kb through 2Mb)          */
	uint32_t actual_size;				/* window size when it was first allocated */
	uint32_t window_posn;				/* current offset within the window        */
	uint32_t R0, R1, R2;				/* for the LRU offset system               */
	unsigned int num_offsets;			/* number of match_offset entries in table */
	int header_read;					/* have we started decoding at all yet?    */
	uint16_t block_type;				/* type of this block                      */
	uint32_t block_length;				/* uncompressed length of this block       */
	uint32_t block_remaining;			/* uncompressed bytes still left to decode */
	uint32_t frames_read;				/* the number of CFDATA blocks processed   */
	int32_t intel_filesize;				/* magic header value used for transform   */
	int32_t intel_curpos;				/* current offset in transform space       */
	int intel_started;					/* have we seen any translatable data yet? */

	LZX_DECLARE_TABLE(PRETREE);
	LZX_DECLARE_TABLE(MAINTREE);
	LZX_DECLARE_TABLE(LENGTH);
	LZX_DECLARE_TABLE(ALIGNED);
	char LENGTH_empty;
};

/* LZX decruncher */

/* Microsoft's LZX document (in cab-sdk.exe) and their implementation
 * of the com.ms.util.cab Java package do not concur.
 *
 * In the LZX document, there is a table showing the correlation between
 * window size and the number of position slots. It states that the 1MB
 * window = 40 slots and the 2MB window = 42 slots. In the implementation,
 * 1MB = 42 slots, 2MB = 50 slots. The actual calculation is 'find the
 * first slot whose position base is equal to or more than the required
 * window size'. This would explain why other tables in the document refer
 * to 50 slots rather than 42.
 *
 * The constant NUM_PRIMARY_LENGTHS used in the decompression pseudocode
 * is not defined in the specification.
 *
 * The LZX document does not state the uncompressed block has an
 * uncompressed length field. Where does this length field come from, so
 * we can know how large the block is? The implementation has it as the 24
 * bits following after the 3 blocktype bits, before the alignment
 * padding.
 *
 * The LZX document states that aligned offset blocks have their aligned
 * offset huffman tree AFTER the main and length trees. The implementation
 * suggests that the aligned offset tree is BEFORE the main and length
 * trees.
 *
 * The LZX document decoding algorithm states that, in an aligned offset
 * block, if an extra_bits value is 1, 2 or 3, then that number of bits
 * should be read and the result added to the match offset. This is
 * correct for 1 and 2, but not 3, where just a huffman symbol (using the
 * aligned tree) should be read.
 *
 * Regarding the E8 preprocessing, the LZX document states 'No translation
 * may be performed on the last 6 bytes of the input block'. This is
 * correct.  However, the pseudocode provided checks for the *E8 leader*
 * up to the last 6 bytes. If the leader appears between -10 and -7 bytes
 * from the end, this would cause the next four bytes to be modified, at
 * least one of which would be in the last 6 bytes, which is not allowed
 * according to the spec.
 *
 * The specification states that the huffman trees must always contain at
 * least one element. However, many CAB files contain blocks where the
 * length tree is completely empty (because there are no matches), and
 * this is expected to succeed.
 *
 * The errors in LZX documentation appear have been corrected in the
 * new documentation for the LZX DELTA format.
 *
 *     http://msdn.microsoft.com/en-us/library/cc483133.aspx
 *
 * However, this is a different format, an extension of regular LZX.
 * I have noticed the following differences, there may be more:
 *
 * The maximum window size has increased from 2MB to 32MB. This also
 * increases the maximum number of position slots, etc.
 *
 * If the match length is 257 (the maximum possible), this signals
 * a further length decoding step, that allows for matches up to
 * 33024 bytes long.
 *
 * The format now allows for "reference data", supplied by the caller.
 * If match offsets go further back than the number of bytes
 * decompressed so far, that is them accessing the reference data.
 */


/* LZX static data tables:
 *
 * LZX uses 'position slots' to represent match offsets.  For every match,
 * a small 'position slot' number and a small offset from that slot are
 * encoded instead of one large offset.
 *
 * The number of slots is decided by how many are needed to encode the
 * largest offset for a given window size. This is easy when the gap between
 * slots is less than 128Kb, it's a linear relationship. But when extra_bits
 * reaches its limit of 17 (because LZX can only ensure reading 17 bits of
 * data at a time), we can only jump 128Kb at a time and have to start
 * using more and more position slots as each window size doubles.
 *
 * position_base[] is an index to the position slot bases
 *
 * extra_bits[] states how many bits of offset-from-base data is needed.
 *
 * They are calculated as follows:
 * extra_bits[i] = 0 where i < 4
 * extra_bits[i] = floor(i/2)-1 where i >= 4 && i < 36
 * extra_bits[i] = 17 where i >= 36
 * position_base[0] = 0
 * position_base[i] = position_base[i-1] + (1 << extra_bits[i-1])
 */
static const unsigned int position_slots[11] = {
	30, 32, 34, 36, 38, 42, 50, 66, 98, 162, 290
};

static const uint8_t extra_bits[36] = {
	 0,  0,  0,  0,  1,  1,  2,  2,  3,  3,  4,  4,  5,  5,  6,  6,
	 7,  7,  8,  8,  9,  9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14,
	15, 15, 16, 16
};

static const uint32_t position_base[290] = {
	       0,        1,        2,        3,       4,         6,        8,       12,       16,       24,       32,       48,       64,       96,      128,      192,
	     256,      384,      512,      768,    1024,      1536,     2048,     3072,     4096,     6144,     8192,    12288,    16384,    24576,    32768,    49152,
	   65536,    98304,   131072,   196608,  262144,    393216,   524288,   655360,   786432,   917504,  1048576,  1179648,  1310720,  1441792,  1572864,  1703936,
	 1835008,  1966080,  2097152,  2228224,  2359296,  2490368,  2621440,  2752512,  2883584,  3014656,  3145728,  3276800,  3407872,  3538944,  3670016,  3801088,
	 3932160,  4063232,  4194304,  4325376,  4456448,  4587520,  4718592,  4849664,  4980736,  5111808,  5242880,  5373952,  5505024,  5636096,  5767168,  5898240,
	 6029312,  6160384,  6291456,  6422528,  6553600,  6684672,  6815744,  6946816,  7077888,  7208960,  7340032,  7471104,  7602176,  7733248,  7864320,  7995392,
	 8126464,  8257536,  8388608,  8519680,  8650752,  8781824,  8912896,  9043968,  9175040,  9306112,  9437184,  9568256,  9699328,  9830400,  9961472, 10092544,
	10223616, 10354688, 10485760, 10616832, 10747904, 10878976, 11010048, 11141120, 11272192, 11403264, 11534336, 11665408, 11796480, 11927552, 12058624, 12189696,
	12320768, 12451840, 12582912, 12713984, 12845056, 12976128, 13107200, 13238272, 13369344, 13500416, 13631488, 13762560, 13893632, 14024704, 14155776, 14286848,
	14417920, 14548992, 14680064, 14811136, 14942208, 15073280, 15204352, 15335424, 15466496, 15597568, 15728640, 15859712, 15990784, 16121856, 16252928, 16384000,
	16515072, 16646144, 16777216, 16908288, 17039360, 17170432, 17301504, 17432576, 17563648, 17694720, 17825792, 17956864, 18087936, 18219008, 18350080, 18481152,
	18612224, 18743296, 18874368, 19005440, 19136512, 19267584, 19398656, 19529728, 19660800, 19791872, 19922944, 20054016, 20185088, 20316160, 20447232, 20578304,
	20709376, 20840448, 20971520, 21102592, 21233664, 21364736, 21495808, 21626880, 21757952, 21889024, 22020096, 22151168, 22282240, 22413312, 22544384, 22675456,
	22806528, 22937600, 23068672, 23199744, 23330816, 23461888, 23592960, 23724032, 23855104, 23986176, 24117248, 24248320, 24379392, 24510464, 24641536, 24772608,
	24903680, 25034752, 25165824, 25296896, 25427968, 25559040, 25690112, 25821184, 25952256, 26083328, 26214400, 26345472, 26476544, 26607616, 26738688, 26869760,
	27000832, 27131904, 27262976, 27394048, 27525120, 27656192, 27787264, 27918336, 28049408, 28180480, 28311552, 28442624, 28573696, 28704768, 28835840, 28966912,
	29097984, 29229056, 29360128, 29491200, 29622272, 29753344, 29884416, 30015488, 30146560, 30277632, 30408704, 30539776, 30670848, 30801920, 30932992, 31064064,
	31195136, 31326208, 31457280, 31588352, 31719424, 31850496, 31981568, 32112640, 32243712, 32374784, 32505856, 32636928, 32768000, 32899072, 33030144, 33161216,
	33292288, 33423360
};

LZXstate *LZXinit(int window_bits)
{
	LZXstate *lzx;
	uint32_t window_size = 1 << window_bits;
	int is_delta = 0;
	
	/* LZX DELTA window sizes are between 2^17 (128KiB) and 2^25 (32MiB),
	 * regular LZX windows are between 2^15 (32KiB) and 2^21 (2MiB)
	 */
	if (is_delta)
	{
		if (window_bits < 17 || window_bits > 25)
			return NULL;
	} else
	{
		if (window_bits < 15 || window_bits > 21)
			return NULL;
	}
	
	/* allocate state and associated window */
	lzx = (LZXstate *) calloc(1, sizeof(*lzx));
	if (lzx == NULL)
		return NULL;
	if ((lzx->window = (uint8_t *) calloc(1, window_size)) == NULL)
	{
		free(lzx);
		return NULL;
	}
	lzx->actual_size = window_size;
	lzx->window_size = window_size;

	/* calculate required position slots */
	lzx->num_offsets = position_slots[window_bits - 15] << 3;

	/** alternatively **/
	/* posn_slots=i=0; while (i < window_size) i += 1 << extra_bits[posn_slots++]; */

	/* initialize other state */
	lzx->frames_read = 0;
	lzx->intel_curpos = 0;
	lzx->intel_started = 0;
	lzx->intel_filesize = 0;
	lzx->window_posn = 0;
	lzx->LENGTH_empty = 0;
	LZXreset(lzx);

	return lzx;
}


void LZXteardown(LZXstate *lzx)
{
	if (lzx)
	{
		if (lzx->window)
			free(lzx->window);
		free(lzx);
	}
}


int LZXreset(LZXstate *lzx)
{
	int i;

	lzx->R0 = 1;
	lzx->R1 = 1;
	lzx->R2 = 1;
	lzx->header_read = 0;
	lzx->frames_read = 0;
	lzx->block_remaining = 0;
	lzx->block_type = LZX_BLOCKTYPE_INVALID;
	lzx->intel_curpos = 0;
	lzx->intel_started = 0;
	lzx->window_posn = 0;

	/* initialise tables to 0 (because deltas will be applied to them) */
	for (i = 0; i < LZX_MAINTREE_MAXSYMBOLS + LZX_LENTABLE_SAFETY; i++)
		lzx->MAINTREE_len[i] = 0;
	for (i = 0; i < LZX_LENGTH_MAXSYMBOLS + LZX_LENTABLE_SAFETY; i++)
		lzx->LENGTH_len[i] = 0;

	return DECR_OK;
}


/* Bitstream reading macros:
 *
 * INIT_BITSTREAM    should be used first to set up the system
 * READ_BITS(var,n)  takes N bits from the buffer and puts them in var
 *
 * ENSURE_BITS(n)    ensures there are at least N bits in the bit buffer
 * PEEK_BITS(n)      extracts (without removing) N bits from the bit buffer
 * REMOVE_BITS(n)    removes N bits from the bit buffer
 *
 * These bit access routines work by using the area beyond the MSB and the
 * LSB as a free source of zeroes. This avoids having to mask any bits.
 * So we have to know the bit width of the bitbuffer variable. This is
 * sizeof(uint32_t) * 8, also defined as ULONG_BITS
 */

/* number of bits in ULONG. Note: This must be at multiple of 16, and at
 * least 32 for the bitbuffer code to work (ie, it must be able to ensure
 * up to 17 bits - that's adding 16 bits when there's one bit left, or
 * adding 32 bits when there are no bits left. The code should work fine
 * for machines where ULONG >= 32 bits.
 */
#define ULONG_BITS (sizeof(uint32_t)<<3)

#define INIT_BITSTREAM do { bitsleft = 0; bitbuf = 0; } while (0)

#define ENSURE_BITS(n)							\
  while (bitsleft < (n)) {						\
    bitbuf |= ((inpos[1]<<8)|inpos[0]) << (ULONG_BITS-16 - bitsleft);	\
    bitsleft += 16; inpos+=2;						\
  }

#define PEEK_BITS(n)   (bitbuf >> (ULONG_BITS - (n)))
#define REMOVE_BITS(n) ((bitbuf <<= (n)), (bitsleft -= (n)))

#define READ_BITS(v,n) do {						\
  ENSURE_BITS(n);							\
  (v) = PEEK_BITS(n);							\
  REMOVE_BITS(n);							\
} while (0)


/* Huffman macros */

#define TABLEBITS(tbl)   (LZX_##tbl##_TABLEBITS)
#define MAXSYMBOLS(tbl)  (LZX_##tbl##_MAXSYMBOLS)
#define SYMTABLE(tbl)    (lzx->tbl##_table)
#define LENTABLE(tbl)    (lzx->tbl##_len)

/* BUILD_TABLE(tablename) builds a huffman lookup table from code lengths.
 * In reality, it just calls make_decode_table() with the appropriate
 * values - they're all fixed by some #defines anyway, so there's no point
 * writing each call out in full by hand.
 */
#define BUILD_TABLE(tbl)						\
  if (make_decode_table(						\
    MAXSYMBOLS(tbl), TABLEBITS(tbl), LENTABLE(tbl), SYMTABLE(tbl)	\
  )) { return DECR_ILLEGALDATA; }

#define BUILD_TABLE_MAYBE_EMPTY(tbl) do {				\
    lzx->tbl##_empty = 0;						\
    if (make_decode_table(MAXSYMBOLS(tbl), TABLEBITS(tbl),		\
                          LENTABLE(tbl), SYMTABLE(tbl)))	\
    {									\
	for (i = 0; i < MAXSYMBOLS(tbl); i++) {				\
	    if (LENTABLE(tbl)[i] > 0) {					\
		return DECR_ILLEGALDATA;		\
	    }								\
	}								\
	/* empty tree - allow it, but don't decode symbols with it */	\
	lzx->tbl##_empty = 1;						\
    }									\
} while (0)


/* READ_HUFFSYM(tablename, var) decodes one huffman symbol from the
 * bitstream using the stated table and puts it in var.
 */
#define READ_HUFFSYM(tbl,var) do {					\
  ENSURE_BITS(16);							\
  hufftbl = SYMTABLE(tbl);						\
  if ((i = hufftbl[PEEK_BITS(TABLEBITS(tbl))]) >= MAXSYMBOLS(tbl)) {	\
    j = 1 << (ULONG_BITS - TABLEBITS(tbl));				\
    do {								\
      j >>= 1; i <<= 1; i |= (bitbuf & j) ? 1 : 0;			\
      if (!j) { return DECR_ILLEGALDATA; }	                        \
    } while ((i = hufftbl[i]) >= MAXSYMBOLS(tbl));			\
  }									\
  j = LENTABLE(tbl)[(var) = i];						\
  REMOVE_BITS(j);							\
} while (0)


/* READ_LENGTHS(tablename, first, last) reads in code lengths for symbols
 * first to last in the given table. The code lengths are stored in their
 * own special LZX way.
 */
#define READ_LENGTHS(tbl, first, last) do { \
  lb.bb = bitbuf; lb.bl = bitsleft; lb.ip = inpos; \
  if (lzx_read_lens(lzx, LENTABLE(tbl),(first),(last),&lb)) { \
    return DECR_ILLEGALDATA; \
  } \
  bitbuf = lb.bb; bitsleft = lb.bl; inpos = lb.ip; \
} while (0)


/* make_decode_table(nsyms, nbits, length[], table[])
 *
 * This function was originally coded by David Tritscher.
 * It builds a fast huffman decoding table from
 * a canonical huffman code lengths table.
 *
 * nsyms  = total number of symbols in this huffman tree.
 * nbits  = any symbols with a code length of nbits or less can be decoded
 *          in one lookup of the table.
 * length = A table to get code lengths from [0 to nsyms-1]
 * table  = The table to fill up with decoded symbols and pointers.
 *          Should be ((1<<nbits) + (nsyms*2)) in length.
 *
 * Returns 0 for OK or 1 for error
 */
static int make_decode_table(uint32_t nsyms, uint32_t nbits, uint8_t *length, uint16_t *table)
{
	register uint16_t sym;
	register uint32_t leaf;
	register uint8_t bit_num;
	uint32_t fill;
	uint32_t pos = 0;						/* the current position in the decode table */
	uint32_t table_mask = 1 << nbits;
	uint32_t bit_mask = table_mask >> 1;	/* don't do 0 length codes */
	uint32_t next_symbol;					/* base of allocation for long codes */
#ifdef BITS_ORDER_LSB
	register unsigned int reverse;
#endif

	/* fill entries for codes short enough for a direct mapping */
	for (bit_num = 1; bit_num <= nbits; bit_num++)
	{
		for (sym = 0; sym < nsyms; sym++)
		{
			if (length[sym] == bit_num)
			{
#ifdef BITS_ORDER_MSB
				leaf = pos;
#else
				/* reverse the significant bits */
				fill = length[sym];
				reverse = pos >> (nbits - fill);
				leaf = 0;
				do
				{
					leaf <<= 1;
					leaf |= reverse & 1;
					reverse >>= 1;
				} while (--fill);
#endif

				pos += bit_mask;
				if (pos > table_mask)
					return 1;			/* table overrun */

				/* fill all possible lookups of this symbol with the symbol itself */
				fill = bit_mask;
#ifdef BITS_ORDER_MSB
				while (fill-- > 0)
					table[leaf++] = sym;
#else
				next_symbol = 1 << bit_num;
				do
				{
					table[leaf] = sym;
					leaf += next_symbol;
				} while (--fill);
#endif
			}
		}
		bit_mask >>= 1;
	}

	/* exit with success if table is now complete */
	if (pos == table_mask)
		return 0;

	/* mark all remaining table entries as unused */
	for (sym = pos; sym < table_mask; sym++)
	{
#ifdef BITS_ORDER_MSB
		table[sym] = 0xffff;
#else
		reverse = sym;
		leaf = 0;
		fill = nbits;
		do
		{
			leaf <<= 1;
			leaf |= reverse & 1;
			reverse >>= 1;
		} while (--fill);
		table[leaf] = 0xFFFF;
#endif
	}

	/* next_symbol = base of allocation for long codes */
	next_symbol = ((table_mask >> 1) < nsyms) ? nsyms : (table_mask >> 1);

	/* give ourselves room for codes to grow by up to 16 more bits.
	 * codes now start at bit nbits+16 and end at (nbits+16-codelength) */
	pos <<= 16;
	table_mask <<= 16;
	bit_mask = 1 << 15;

	for (bit_num = nbits + 1; bit_num <= HUFF_MAXBITS; bit_num++)
	{
		for (sym = 0; sym < nsyms; sym++)
		{
			if (length[sym] == bit_num)
			{
				if (pos >= table_mask)
					return 1;				/* table overflow */
	
#ifdef BITS_ORDER_MSB
				leaf = pos >> 16;
#else
				/* leaf = the first nbits of the code, reversed */
				reverse = pos >> 16;
				leaf = 0;
				fill = nbits;
				do
				{
					leaf <<= 1;
					leaf |= reverse & 1;
					reverse >>= 1;
				} while (--fill);
#endif
				for (fill = 0; fill < (bit_num - nbits); fill++)
				{
					/* if this path hasn't been taken yet, 'allocate' two entries */
					if (table[leaf] == 0xffff)
					{
						table[(next_symbol << 1)] = 0xffff;
						table[(next_symbol << 1) + 1] = 0xffff;
						table[leaf] = next_symbol++;
					}

					/* follow the path and select either left or right for next bit */
					leaf = table[leaf] << 1;
					if ((pos >> (15 - fill)) & 1)
						leaf++;
				}
				table[leaf] = sym;
				pos += bit_mask;
			}
		}
		bit_mask >>= 1;
	}

	/* full table? */
	if (pos == table_mask)
		return 0;

	/* either erroneous table, or all elements are 0 - let's find out. */
	for (sym = 0; sym < nsyms; sym++)
		if (length[sym])
			return 1;
	return 0;
}

struct lzx_bits
{
	uint32_t bb;
	int bl;
	const uint8_t *ip;
};

static int lzx_read_lens(LZXstate *lzx, uint8_t *lens, uint32_t first, uint32_t last, struct lzx_bits *lb)
{
	uint32_t i, j, x, y;
	int z;
	register uint32_t bitbuf = lb->bb;
	register int bitsleft = lb->bl;
	const uint8_t *inpos = lb->ip;
	const uint16_t *hufftbl;

	/* read lengths for pretree (20 symbols, lengths stored in fixed 4 bits) */
	for (x = 0; x < 20; x++)
	{
		READ_BITS(y, 4);
		LENTABLE(PRETREE)[x] = (uint8_t)y;
	}
	BUILD_TABLE(PRETREE);

	for (x = first; x < last;)
	{
		READ_HUFFSYM(PRETREE, z);
		if (z == 17)
		{
			/* code = 17, run of ([read 4 bits]+4) zeros */
			READ_BITS(y, 4);
			y += 4;
			while (y--)
				lens[x++] = 0;
		} else if (z == 18)
		{
			/* code = 18, run of ([read 5 bits]+20) zeros */
			READ_BITS(y, 5);
			y += 20;
			while (y--)
				lens[x++] = 0;
		} else if (z == 19)
		{
			/* code = 19, run of ([read 1 bit]+4) [read huffman symbol] */
			READ_BITS(y, 1);
			y += 4;
			READ_HUFFSYM(PRETREE, z);
			z = lens[x] - z;
			if (z < 0)
				z += 17;
			while (y--)
				lens[x++] = z;
		} else
		{
			/* code = 0 to 16, delta current length entry */
			z = lens[x] - z;
			if (z < 0)
				z += 17;
			lens[x++] = z;
		}
	}

	lb->bb = bitbuf;
	lb->bl = bitsleft;
	lb->ip = inpos;
	return 0;
}


int LZXdecompress(LZXstate *lzx, const unsigned char *inpos, unsigned char *outpos, int inlen, int outlen)
{
	const uint8_t *endinp = inpos + inlen;
	uint8_t *window = lzx->window;
	uint8_t *runsrc, *rundest;
	const uint16_t *hufftbl;			/* used in READ_HUFFSYM macro as chosen decoding table */
	uint32_t window_posn = lzx->window_posn;
	uint32_t window_size = lzx->window_size;
	uint32_t R0 = lzx->R0;
	uint32_t R1 = lzx->R1;
	uint32_t R2 = lzx->R2;
	register uint32_t bitbuf;
	register int bitsleft;
	uint32_t match_offset, i, j;		/* ijk used in READ_HUFFSYM macro */
	struct lzx_bits lb;					/* used in READ_LENGTHS macro */
	int togo = outlen;
	int this_run;
	int main_element;
	int aligned_bits;
	int match_length;
	int length_footer;
	int extra;
	int verbatim_bits;

	INIT_BITSTREAM;

	/* read header if necessary */
	if (!lzx->header_read)
	{
		/* read 1 bit. if bit=0, intel filesize = 0.
		 * if bit=1, read intel filesize (32 bits) */
		j = 0;
		READ_BITS(i, 1);
		if (i)
		{
			READ_BITS(i, 16);
			READ_BITS(j, 16);
		}
		lzx->intel_filesize = (i << 16) | j;	/* or 0 if not encoded */
		lzx->header_read = 1;
	}

	/* main decoding loop */
	while (togo > 0)
	{
		/* last block finished, new block expected */
		if (lzx->block_remaining == 0)
		{
			if (lzx->block_type == LZX_BLOCKTYPE_UNCOMPRESSED)
			{
				if (lzx->block_length & 1)
					inpos++;			/* realign bitstream to word */
				INIT_BITSTREAM;
			}

			/* read block type (3 bits) and block length (24 bits) */
			READ_BITS(lzx->block_type, 3);
			READ_BITS(i, 16);
			READ_BITS(j, 8);
			lzx->block_length = (i << 8);
			lzx->block_remaining = lzx->block_length | j;

			/* read individual block headers */
			switch (lzx->block_type)
			{
			case LZX_BLOCKTYPE_ALIGNED:
				/* read lengths of and build aligned huffman decoding tree */
				for (i = 0; i < 8; i++)
				{
					READ_BITS(j, 3);
					LENTABLE(ALIGNED)[i] = j;
				}
				BUILD_TABLE(ALIGNED);
				/* no break -- rest of aligned header is same as verbatim */

			case LZX_BLOCKTYPE_VERBATIM:
				/* read lengths of and build main huffman decoding tree */
				READ_LENGTHS(MAINTREE, 0, 256);
				READ_LENGTHS(MAINTREE, 256, LZX_NUM_CHARS + lzx->num_offsets);
				BUILD_TABLE(MAINTREE);
				/* if the literal 0xE8 is anywhere in the block... */
				if (LENTABLE(MAINTREE)[0xE8] != 0)
					lzx->intel_started = 1;

				/* read lengths of and build lengths huffman decoding tree */
				READ_LENGTHS(LENGTH, 0, LZX_NUM_SECONDARY_LENGTHS);
				BUILD_TABLE_MAYBE_EMPTY(LENGTH);
				break;

			case LZX_BLOCKTYPE_UNCOMPRESSED:
				/* because we can't assume otherwise */
				lzx->intel_started = 1;
				ENSURE_BITS(16);		/* get up to 16 pad bits into the buffer */
				if (bitsleft > 16)
					inpos -= 2;			/* and align the bitstream! */

				/* read 12 bytes of stored R0 / R1 / R2 values */
				R0 = inpos[0] | (inpos[1] << 8) | (inpos[2] << 16) | (inpos[3] << 24);
				inpos += 4;
				R1 = inpos[0] | (inpos[1] << 8) | (inpos[2] << 16) | (inpos[3] << 24);
				inpos += 4;
				R2 = inpos[0] | (inpos[1] << 8) | (inpos[2] << 16) | (inpos[3] << 24);
				inpos += 4;
				break;

			default:
				return DECR_ILLEGALDATA;
			}
		}

		/* buffer exhaustion check */
		if (inpos > endinp)
		{
			/* it's possible to have a file where the next run is less than
			 * 16 bits in size. In this case, the READ_HUFFSYM() macro used
			 * in building the tables will exhaust the buffer, so we should
			 * allow for this, but not allow those accidentally read bits to
			 * be used (so we check that there are at least 16 bits
			 * remaining - in this boundary case they aren't really part of
			 * the compressed data)
			 */
			if (inpos > (endinp + 2) || bitsleft < 16)
				return DECR_ILLEGALDATA;
		}

		while ((this_run = lzx->block_remaining) > 0 && togo > 0)
		{
			if (this_run > togo)
				this_run = togo;
			togo -= this_run;
			lzx->block_remaining -= this_run;

			/* apply 2^x-1 mask */
			window_posn &= window_size - 1;
			/* runs can't straddle the window wraparound */
			if ((window_posn + this_run) > window_size)
				return DECR_DATAFORMAT;

			switch (lzx->block_type)
			{
			case LZX_BLOCKTYPE_VERBATIM:
				while (this_run > 0)
				{
					READ_HUFFSYM(MAINTREE, main_element);

					if (main_element < LZX_NUM_CHARS)
					{
						/* literal: 0 to LZX_NUM_CHARS-1 */
						window[window_posn++] = main_element;
						this_run--;
					} else
					{
						/* match: LZX_NUM_CHARS + ((slot<<3) | length_header (3 bits)) */
						main_element -= LZX_NUM_CHARS;

						match_length = main_element & LZX_NUM_PRIMARY_LENGTHS;
						if (match_length == LZX_NUM_PRIMARY_LENGTHS)
						{
							if (lzx->LENGTH_empty)
							{
								D(("LENGTH symbol needed but tree is empty"))
								return DECR_ILLEGALDATA;
							}
							READ_HUFFSYM(LENGTH, length_footer);
							match_length += length_footer;
						}
						match_length += LZX_MIN_MATCH;

						/* get match offset */
						match_offset = main_element >> 3;
						if (match_offset > 2)
						{
							/* not repeated offset */
							if (match_offset != 3)
							{
								extra = (match_offset >= 36) ? 17 : extra_bits[match_offset];
								READ_BITS(verbatim_bits, extra);
								match_offset = position_base[match_offset] - 2 + verbatim_bits;
							} else
							{
								match_offset = 1;
							}

							/* update repeated offset LRU queue */
							R2 = R1;
							R1 = R0;
							R0 = match_offset;
						} else if (match_offset == 0)
						{
							match_offset = R0;
						} else if (match_offset == 1)
						{
							match_offset = R1;
							R1 = R0;
							R0 = match_offset;
						} else			/* match_offset == 2 */
						{
							match_offset = R2;
							R2 = R0;
							R0 = match_offset;
						}

						rundest = window + window_posn;
						runsrc = rundest - match_offset;
						window_posn += match_length;
						if (window_posn > window_size)
						{
							D(("match ran over window wrap"))
							return DECR_ILLEGALDATA;
						}
						this_run -= match_length;

						/* copy any wrapped around source data */
						while ((runsrc < window) && (match_length-- > 0))
						{
							*rundest++ = *(runsrc + window_size);
							runsrc++;
						}
						/* copy match data - no worries about destination wraps */
						while (match_length-- > 0)
							*rundest++ = *runsrc++;
					}
				}
				break;

			case LZX_BLOCKTYPE_ALIGNED:
				while (this_run > 0)
				{
					READ_HUFFSYM(MAINTREE, main_element);

					if (main_element < LZX_NUM_CHARS)
					{
						/* literal: 0 to LZX_NUM_CHARS-1 */
						window[window_posn++] = main_element;
						this_run--;
					} else
					{
						/* match: LZX_NUM_CHARS + ((slot<<3) | length_header (3 bits)) */
						main_element -= LZX_NUM_CHARS;

						match_length = main_element & LZX_NUM_PRIMARY_LENGTHS;
						if (match_length == LZX_NUM_PRIMARY_LENGTHS)
						{
							if (lzx->LENGTH_empty)
							{
								D(("LENGTH symbol needed but tree is empty"))
								return DECR_ILLEGALDATA;
							}
							READ_HUFFSYM(LENGTH, length_footer);
							match_length += length_footer;
						}
						match_length += LZX_MIN_MATCH;

						match_offset = main_element >> 3;

						if (match_offset > 2)
						{
							/* not repeated offset */
							extra = (match_offset >= 36) ? 17 : extra_bits[match_offset];
							match_offset = position_base[match_offset] - 2;
							if (extra > 3)
							{
								/* verbatim and aligned bits */
								extra -= 3;
								READ_BITS(verbatim_bits, extra);
								match_offset += (verbatim_bits << 3);
								READ_HUFFSYM(ALIGNED, aligned_bits);
								match_offset += aligned_bits;
							} else if (extra == 3)
							{
								/* aligned bits only */
								READ_HUFFSYM(ALIGNED, aligned_bits);
								match_offset += aligned_bits;
							} else if (extra > 0)
							{			/* extra==1, extra==2 */
								/* verbatim bits only */
								READ_BITS(verbatim_bits, extra);
								match_offset += verbatim_bits;
							} else		/* extra == 0 */
							{
								/* ??? */
								match_offset = 1;
							}

							/* update repeated offset LRU queue */
							R2 = R1;
							R1 = R0;
							R0 = match_offset;
						} else if (match_offset == 0)
						{
							match_offset = R0;
						} else if (match_offset == 1)
						{
							match_offset = R1;
							R1 = R0;
							R0 = match_offset;
						} else			/* match_offset == 2 */
						{
							match_offset = R2;
							R2 = R0;
							R0 = match_offset;
						}

						rundest = window + window_posn;
						runsrc = rundest - match_offset;
						window_posn += match_length;
						if (window_posn > window_size)
							return DECR_ILLEGALDATA;
						this_run -= match_length;

						/* copy any wrapped around source data */
						while ((runsrc < window) && (match_length-- > 0))
						{
							*rundest++ = *(runsrc + window_size);
							runsrc++;
						}
						/* copy match data - no worries about destination wraps */
						while (match_length-- > 0)
							*rundest++ = *runsrc++;
					}
				}
				break;

			case LZX_BLOCKTYPE_UNCOMPRESSED:
				if ((inpos + this_run) > endinp)
					return DECR_ILLEGALDATA;
				memcpy(window + window_posn, inpos, (size_t) this_run);
				inpos += this_run;
				window_posn += this_run;
				break;

			default:
				return DECR_ILLEGALDATA;	/* might as well */
			}

		}
	}

	if (togo != 0)
		return DECR_ILLEGALDATA;
	memcpy(outpos, window + ((!window_posn) ? window_size : window_posn) - outlen, (size_t) outlen);

	lzx->window_posn = window_posn;
	lzx->R0 = R0;
	lzx->R1 = R1;
	lzx->R2 = R2;

	/* intel E8 decoding */
	if ((lzx->frames_read++ < 32768) && lzx->intel_filesize != 0)
	{
		if (outlen <= 6 || !lzx->intel_started)
		{
			lzx->intel_curpos += outlen;
		} else
		{
			uint8_t *data = outpos;
			uint8_t *dataend = data + outlen - 10;
			int32_t curpos = lzx->intel_curpos;
			int32_t filesize = lzx->intel_filesize;
			int32_t abs_off, rel_off;

			lzx->intel_curpos = curpos + outlen;

			while (data < dataend)
			{
				if (*data++ != 0xE8)
				{
					curpos++;
					continue;
				}
				abs_off = data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
				/* XXX abs_off >= curpos - 1 */
				if ((abs_off >= -curpos) && (abs_off < filesize))
				{
					rel_off = (abs_off >= 0) ? abs_off - curpos : abs_off + filesize;
					data[0] = (uint8_t) rel_off;
					data[1] = (uint8_t) (rel_off >> 8);
					data[2] = (uint8_t) (rel_off >> 16);
					data[3] = (uint8_t) (rel_off >> 24);
				}
				data += 4;
				curpos += 5;
			}
		}
	}
	return DECR_OK;
}


#ifdef LZX_CHM_TESTDRIVER
int main(int c, char **v)
{
	FILE *fin, *fout;
	LZXstate *state;
	uint8_t ibuf[16384];
	uint8_t obuf[32768];
	int ilen, olen;
	int status;
	int i;
	int count = 0;
	int w = atoi(v[1]);

	state = LZXinit(w);
	fout = fopen(v[2], "wb");
	for (i = 3; i < c; i++)
	{
		fin = fopen(v[i], "rb");
		ilen = fread(ibuf, 1, 16384, fin);
		status = LZXdecompress(state, ibuf, obuf, ilen, 32768);
		switch (status)
		{
		case DECR_OK:
			printf("ok\n");
			fwrite(obuf, 1, 32768, fout);
			break;
		case DECR_DATAFORMAT:
			printf("bad format\n");
			break;
		case DECR_ILLEGALDATA:
			printf("illegal data\n");
			break;
		case DECR_NOMEMORY:
			printf("no memory\n");
			break;
		default:
			break;
		}
		fclose(fin);
		if (++count == 2)
		{
			count = 0;
			LZXreset(state);
		}
	}
	fclose(fout);
}
#endif
