#define INCL_DOS
#define INCL_DOSERRORS
#include <os2.h>

#include <stdio.h>
#include <stdlib.h>


#define  _PMPRINTF_
#include <PMPRINTF.H>


#define VERSION "0.9.1"



/********************************************************************
 *                                                                  *
 *  LZW decompression                                               *
 *                                                                  *
 *******************************************************************/

/*
 *  This is based on code (W) by Peter Fitzsimmons, pfitz@ican.net.
 *  His liner notes in the original:
 *      has its roots in a June 1990
 *      DDJ article "LZW REVISITED", by Shawn M. Regan
 *      --=>revision history<=--
 *      1 lzw.c 21-Aug-96,2:24:36,`PLF' ;
 *      2 lzw.c 24-Aug-96,2:27:24,`PLF' wip
 *
 *  The code has been modified to take the input not from an
 *  open file, but from any memory region. For this, a double
 *  pointer is used, which must be passed to LZWDecompressBlock.
 *  I've also added a few comments for clarity.
 *
 */

/* -- Stuff for LZW decompression -- */
#define INIT_BITS 9
#define MAX_BITS 12     /*PLF Tue  95-10-03 02:16:56*/
#define HASHING_SHIFT MAX_BITS - 8

#if MAX_BITS == 15
  #define TABLE_SIZE 36768
#elif MAX_BITS == 14
  #define TABLE_SIZE 18041
#elif MAX_BITS == 13
  #define TABLE_SIZE 9029
#else
  #define TABLE_SIZE 5021
#endif

#define CLEAR_TABLE 256
#define TERMINATOR  257
#define FIRST_CODE  258
#define CHECK_TIME  100

#define MAXVAL(n) (( 1 << (n)) -1)

static unsigned int prefix_code[ TABLE_SIZE ];
static unsigned char append_character[ TABLE_SIZE ];

static unsigned char decode_stack[4000];
static int num_bits;
static int max_code;

/*
 * decode_string:
 *
 */
char* decode_string(unsigned char* buffer, unsigned int code, BOOL* error) {
    int i = 0;
    *error = FALSE;

    while (code > 255) {
        *buffer++ = append_character[code];
        code = prefix_code[code];
        if (i++ >= 4000) {
            *error = TRUE;
            return( buffer );
        }
    }
    *buffer = code;
    return (buffer);
}



/*
 * input_code:
 *      this function reads in bytes from the input
 *      stream.
 */
unsigned input_code(PBYTE* ppbInput, unsigned bytes_to_read) {
    unsigned int return_value;
    static unsigned long bytes_out = 0;
    static int input_bit_count = 0;
    static unsigned long input_bit_buffer = 0L;

    while (input_bit_count <= 24) {
        if (bytes_out <= bytes_to_read) {
            input_bit_buffer |= (unsigned long)(**ppbInput) << (24 - input_bit_count);
            (*ppbInput)++;
        } else
            input_bit_buffer |= 0x00;
        bytes_out++;
        input_bit_count += 8;
    }
    return_value = input_bit_buffer >> (32 - num_bits);
    input_bit_buffer <<= num_bits;
    input_bit_count -= num_bits;
    if (bytes_out > bytes_to_read) {    /* flush static vars and quit */
        bytes_out = 0;
        input_bit_count = 0;
        input_bit_buffer = 0L;
        return (TERMINATOR);
    }
    else
        return (return_value);
}


/*
 * LZWDecompressBlock:
 *      this takes one of the INF bitmap blocks
 *      and decompresses it using LZW algorithms.
 */
BOOL APIENTRY LZWDecompressBlock( PBYTE pbInput,             // in: compressed data
                                  PBYTE pOutput,             // out: uncompressed data
                                  unsigned int number_bytes, // in: bytes to decompress
                                  unsigned long * pBytesOut, // out: bytes decompressed.
                                  PBYTE pLastCode)           // out: last byte decompressed.
{
    unsigned int next_code = FIRST_CODE;
    unsigned int new_code;
    unsigned int old_code;
    int character, clear_flag = 1;
    unsigned char *string;
    BOOL error;

    num_bits = INIT_BITS;
    max_code = MAXVAL(num_bits);

    *pBytesOut = 0;

    _Pmpf(("LZWDecompressBlock"));

    while ((new_code = input_code(&pbInput, number_bytes)) != TERMINATOR) {
        if (clear_flag) {
            clear_flag = 0;
            old_code = new_code;
            character = old_code;
            *pOutput = (BYTE)old_code;
            pOutput ++;
            *pLastCode = (BYTE)old_code;
            (*pBytesOut) ++;
            continue;
        }
        if (new_code == CLEAR_TABLE) {
            clear_flag = 1;
            num_bits = INIT_BITS;
            next_code = FIRST_CODE;
            max_code = MAXVAL(num_bits);
            continue;
        }

        if (new_code >= next_code) {
            *decode_stack = character;
            string = decode_string(decode_stack + 1, old_code, &error);
        }
        else
            string = decode_string(decode_stack, new_code, &error);

        if ( error ) {
            return FALSE;
        }
        character = *string;
        while (string >= decode_stack) {
            *pOutput = *string;
            pOutput ++;
            string --;

            (*pBytesOut)++;
        }
            *pLastCode = *( string+1 );

        if (next_code <= max_code) {
            prefix_code[next_code] = old_code;
            append_character[next_code++] = character;
            if (next_code == max_code && num_bits < MAX_BITS) {
                max_code = MAXVAL(++num_bits);
            }
        }
        old_code = new_code;
    }
    return (TRUE);
}
