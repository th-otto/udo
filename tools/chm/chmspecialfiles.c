#include "chmtools.h"
#include "chmspecialfiles.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

int WriteNameListToStream(ChmStream *stream, SectionNames sectionnames)
{
	uint16_t size = 2;
	uint16_t nentries = 0;
	static unsigned char const MSCompressedName[] = "MSCompressed";
	static unsigned char const UnCompressedName[] = "Uncompressed";
	int i;
	
	if (sectionnames & snUnCompressed)
	{
		size += sizeof(UnCompressedName) + 1;
		++nentries;
	}

	if (sectionnames & snMSCompressed)
	{
		size += sizeof(MSCompressedName) + 1;
		++nentries;
	}
	
	chmstream_write_le16(stream, size);
	chmstream_write_le16(stream, nentries);

	if (sectionnames & snUnCompressed)
	{
		chmstream_write_le16(stream, sizeof(UnCompressedName) - 1);
		for (i = 0; i < (int)sizeof(UnCompressedName); i++)
			chmstream_write_le16(stream, UnCompressedName[i]);
	}
		
	if (sectionnames & snMSCompressed)
	{
		chmstream_write_le16(stream, sizeof(MSCompressedName) - 1);
		for (i = 0; i < (int)sizeof(MSCompressedName); i++)
			chmstream_write_le16(stream, MSCompressedName[i]);
	}
		
	return size * 2;
}

/*** ---------------------------------------------------------------------- ***/

int WriteControlDataToStream(ChmStream *stream, uint32_t LZXResetInterval, uint32_t WindowSize, uint32_t CacheSize)
{
	chm_off_t pos = ChmStream_Tell(stream);
	
	chmstream_write_le32(stream, 6);				/* number of dwords following this one */
	chmstream_write_be32(stream, 0x4c5a5843);		/* 'LZXC' */
	chmstream_write_le32(stream, 2);				/* version */
	chmstream_write_le32(stream, LZXResetInterval);
	chmstream_write_le32(stream, WindowSize);
	chmstream_write_le32(stream, CacheSize);
	chmstream_write_le32(stream, 0);
	
	return (int)(ChmStream_Tell(stream) - pos);
}

/*** ---------------------------------------------------------------------- ***/

int WriteSpanInfoToStream(ChmStream *stream, uint64_t UncompressedSize)
{
	chmstream_write_le64(stream, UncompressedSize);
	return 8;
}

/*** ---------------------------------------------------------------------- ***/

/* ::DataSpace/Storage/MSCompressed/Transform/List */
int WriteTransformListToStream(ChmStream *stream)
{
	/* aguid = '{7FC28940-9D31-11D0-9B27-00A0C91E9C7C}'; */
	/* use the broken guid */
	static char const guid[] = { '{', 0, '7', 0, 'F', 0, 'C', 0, '2', 0, '8', 0, '9', 0, '4', 0, '0', 0, '-', 0, '9', 0, 'D', 0, '3', 0, '1', 0, '-', 0, '1', 0, '1', 0, 'D', 0, '0', 0 };
	return ChmStream_Write(stream, guid, sizeof(guid));
}

/*** ---------------------------------------------------------------------- ***/

/* ::DataSpace/Storage/MSCompressed/Transform/{7FC28940-9D31-11D0-9B27-00A0C91E9C7C}/InstanceData/ResetTable */
int WriteResetTableToStream(ChmStream *stream, ChmMemoryStream *ResetTableStream)
{
	chm_off_t size;
	
	if (ChmStream_Seek(ResetTableStream, 0) == FALSE)
		return 0;
	size = ChmStream_Size(ResetTableStream) - 8;
	if (ChmStream_CopyFrom(stream, ResetTableStream, size) == FALSE)
		return 0;
	return size;
}

/*** ---------------------------------------------------------------------- ***/

/* ::DataSpace/Storage/MSCompressed/Content */
int WriteContentToStream(ChmStream *stream, ChmStream *ContentStream)
{
	chm_off_t size;
	
	if (ChmStream_Seek(ContentStream, 0) == FALSE)
		return 0;
	size = ChmStream_Size(ContentStream);
	if (ChmStream_CopyFrom(stream, ContentStream, size) == FALSE)
		return 0;
	return size;
}
