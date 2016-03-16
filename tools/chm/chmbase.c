#include "chmtools.h"
#include <assert.h>

DEFINE_GUID(ITSFHeaderGUID, 0x7C01FD10, 0x7BAA, 0x11D0, 0x9E, 0x0C, 0x00, 0xA0, 0xC9, 0x22, 0xE6, 0xEC);
CHMSignature const ITSFFileSig = { { 'I', 'T', 'S', 'F' } };

DEFINE_GUID(ITSPHeaderGUID, 0x5D02926A, 0x212E, 0x11D0, 0x9D, 0xF9, 0x00, 0xA0, 0xC9, 0x22, 0xE6, 0xEC);
CHMSignature const ITSPHeaderSig = { { 'I', 'T', 'S', 'P' } };

CHMSignature const PMGIsig = { { 'P', 'M', 'G', 'I' } };

uint32_t GetCompressedInteger(ChmStream *Stream)
{
	uint64_t total = 0;
	int temp;
	int sanity = 0;
	
	temp = ChmStream_fgetc(Stream);
	if (temp == EOF)
		return 0;
	while (temp >= 0x80)
	{
		total <<= 7;
		total += temp & 0x7f;
		temp = ChmStream_fgetc(Stream);
		if (temp == EOF)
			return 0;
		++sanity;
		assert(sanity <= 8);
	}
	total <<= 7;
	total += temp;
	return total;
}


/*
 * returns the number of bytes written to the stream
 */
uint32_t WriteCompressedInteger(ChmStream *Stream, uint32_t ANumber)
{
	uint64_t Buffer;
	uint32_t count = PutCompressedInteger(&Buffer, ANumber);
	return ChmStream_Write(Stream, &Buffer, count) ? count : 0;
}


uint32_t PutCompressedInteger(void *Buffer, uint32_t ANumber)
{
	int bit;
	uint32_t mask;
	uint8_t *buf;
	uint32_t TheEnd = 0;
	
	buf = (uint8_t *)Buffer;
	bit = 28;
	for (;;)
	{
		mask = (uint32_t)0x7f << bit;
		if ((bit == 0) || ((ANumber & mask) != 0))
			break;
		bit -= 7;
	}
	for (;;)
	{
		*buf = (uint8_t)(((ANumber >> bit) & 0x7f));
		if (bit == 0)
			break;
		*buf++ |= 0x80;
		bit -= 7;
		++TheEnd;
	}
	++TheEnd;
	
	if (TheEnd > 8)
	{
		CHM_DEBUG_LOG(0, "%u WRITE_COMPRESSED_INTEGER too big!: %d\n", ANumber, TheEnd);
	}
	return TheEnd;
}


int ChmCompareText(const char *S1, const char *S2)
{
	return strcasecmp(S1, S2);
}
