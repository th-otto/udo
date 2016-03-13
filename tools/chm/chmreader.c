#include "chmtools.h"
#include "chmreader.h"
#include "lzx.h"

#define isSig(s, str) \
	((((unsigned char)s.sig[0] << 24) | ((unsigned char)s.sig[1] << 16) | ((unsigned char)s.sig[2] << 8) | ((unsigned char)s.sig[3])) == \
	 (((unsigned char)str[0] << 24) | ((unsigned char)str[1] << 16) | ((unsigned char)str[2] << 8) | ((unsigned char)str[3])))

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

const char *ChmErrorToStr(chm_error Error)
{
	switch (Error)
	{
		case CHM_ERR_STREAM_NOT_ASSIGNED: return strerror(EBADF);
		case CHM_ERR_NOT_SUPPORTED_VERSION: return _("unsupported file version");
		case CHM_ERR_NOT_VALID_FILE: return _("invalid file type");
		case CHM_ERR_NO_ERR: return _("no error");
	}
	return "";
}

/*** ---------------------------------------------------------------------- ***/

const char *print_guid(const GUID *guid)
{
	static char buf[50];
	sprintf(buf, "{%08X-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}",
		guid->Data1,
		guid->Data2,
		guid->Data3,
		guid->Data4[0],
		guid->Data4[1],
		guid->Data4[2],
		guid->Data4[3],
		guid->Data4[4],
		guid->Data4[5],
		guid->Data4[6],
		guid->Data4[7]);
	return buf;
}

/*** ---------------------------------------------------------------------- ***/

static uint32_t read_le32(CHMStream *stream)
{
	uint32_t c1, c2, c3, c4;
	
	c1 = CHMStream_fgetc(stream);
	c2 = CHMStream_fgetc(stream);
	c3 = CHMStream_fgetc(stream);
	c4 = CHMStream_fgetc(stream);
	return (c4 << 24) | (c3 << 16) | (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

static uint64_t read_le64(CHMStream *stream)
{
	uint64_t l1, l2;
	
	l1 = read_le32(stream);
	l2 = read_le32(stream);
	return (l2 << 32) | l1;
}

/*** ---------------------------------------------------------------------- ***/

static uint32_t read_be32(CHMStream *stream)
{
	uint32_t c1, c2, c3, c4;
	
	c1 = CHMStream_fgetc(stream);
	c2 = CHMStream_fgetc(stream);
	c3 = CHMStream_fgetc(stream);
	c4 = CHMStream_fgetc(stream);
	return (c1 << 24) | (c2 << 16) | (c3 << 8) | c4;
}

/*** ---------------------------------------------------------------------- ***/

static uint16_t read_le16(CHMStream *stream)
{
	uint32_t c1, c2;
	
	c1 = CHMStream_fgetc(stream);
	c2 = CHMStream_fgetc(stream);
	return (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean read_guid(CHMStream *stream, GUID *guid)
{
	guid->Data1 = read_le32(stream);
	guid->Data2 = read_le16(stream);
	guid->Data3 = read_le16(stream);
	guid->Data4[0] = CHMStream_fgetc(stream);
	guid->Data4[1] = CHMStream_fgetc(stream);
	guid->Data4[2] = CHMStream_fgetc(stream);
	guid->Data4[3] = CHMStream_fgetc(stream);
	guid->Data4[4] = CHMStream_fgetc(stream);
	guid->Data4[5] = CHMStream_fgetc(stream);
	guid->Data4[6] = CHMStream_fgetc(stream);
	guid->Data4[7] = CHMStream_fgetc(stream);
	return TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean ITSFReader_ReadHeaderEntries(ITSFReader *reader)
{
	CHMStream *stream = reader->Stream;
	ITSFHeaderEntry HeaderEntries[2];
	
	/* Copy EntryData into memory */
	HeaderEntries[0].PosFromZero = read_le64(stream);
	HeaderEntries[0].Length = read_le64(stream);
	HeaderEntries[1].PosFromZero = read_le64(stream);
	HeaderEntries[1].Length = read_le64(stream);
	CHM_DEBUG_LOG(1, "Header section 0 = offset $%016" PRIx64 ", length $%016" PRIx64 "\n", HeaderEntries[0].PosFromZero, HeaderEntries[0].Length);
	CHM_DEBUG_LOG(1, "Header section 1 = offset $%016" PRIx64 ", length $%016" PRIx64 "\n", HeaderEntries[1].PosFromZero, HeaderEntries[1].Length);
	
	reader->HeaderSuffix.Offset = 0;
	if (reader->ITSFheader.Version >= 3 && reader->ITSFheader.HeaderLength >= 0x60)
		reader->HeaderSuffix.Offset = read_le64(stream);
	/* otherwise this is filled in below */

	reader->DirectoryHeaderPos = HeaderEntries[1].PosFromZero;
	if (CHMStream_seek(stream, HeaderEntries[1].PosFromZero) == FALSE)
		return FALSE;
	
	/*
	 * read directory header
	 */
	reader->DirectoryHeader.ITSPsig.sig[0] = CHMStream_fgetc(stream);
	reader->DirectoryHeader.ITSPsig.sig[1] = CHMStream_fgetc(stream);
	reader->DirectoryHeader.ITSPsig.sig[2] = CHMStream_fgetc(stream);
	reader->DirectoryHeader.ITSPsig.sig[3] = CHMStream_fgetc(stream);
	reader->DirectoryHeader.Version = read_le32(stream);
	reader->DirectoryHeader.DirHeaderLength = read_le32(stream);
	reader->DirectoryHeader.Unknown1 = read_le32(stream);
	reader->DirectoryHeader.ChunkSize = read_le32(stream);
	reader->DirectoryHeader.Density = read_le32(stream);
	reader->DirectoryHeader.IndexTreeDepth = read_le32(stream);
	reader->DirectoryHeader.IndexOfRootChunk = read_le32(stream);
	reader->DirectoryHeader.FirstPMGLChunkIndex = read_le32(stream);
	reader->DirectoryHeader.LastPMGLChunkIndex = read_le32(stream);
	reader->DirectoryHeader.Unknown2 = read_le32(stream);
	reader->DirectoryHeader.DirectoryChunkCount = read_le32(stream);
	reader->DirectoryHeader.LanguageID = read_le32(stream);
	if (read_guid(stream, &reader->DirectoryHeader.guid) == FALSE)
		return FALSE;
	reader->DirectoryHeader.LengthAgain = read_le32(stream);
	reader->DirectoryHeader.Unknown3 = read_le32(stream);
	reader->DirectoryHeader.Unknown4 = read_le32(stream);
	reader->DirectoryHeader.Unknown5 = read_le32(stream);

	reader->DirectoryEntriesStartPos = CHMStream_tell(stream);
	reader->DirectoryHeaderLength = HeaderEntries[1].Length;
	if (reader->HeaderSuffix.Offset == 0)
		reader->HeaderSuffix.Offset = reader->DirectoryEntriesStartPos + reader->DirectoryHeader.ChunkSize * reader->DirectoryHeader.DirectoryChunkCount;

	CHM_DEBUG_LOG(1, "Directory header:\n");
	CHM_DEBUG_LOG(1, "Signature               = %c%c%c%c\n", reader->DirectoryHeader.ITSPsig.sig[0], reader->DirectoryHeader.ITSPsig.sig[1], reader->DirectoryHeader.ITSPsig.sig[2], reader->DirectoryHeader.ITSPsig.sig[3]);
	CHM_DEBUG_LOG(1, "Version                 = %u\n", reader->DirectoryHeader.Version);
	CHM_DEBUG_LOG(1, "Directory header length = %u\n", reader->DirectoryHeader.DirHeaderLength);
	CHM_DEBUG_LOG(1, "Unknown1                = %u\n", reader->DirectoryHeader.Unknown1);
	CHM_DEBUG_LOG(1, "ChunkSize               = %u\n", reader->DirectoryHeader.ChunkSize);
	CHM_DEBUG_LOG(1, "Density                 = %u\n", reader->DirectoryHeader.Density);
	CHM_DEBUG_LOG(1, "PMGI depth              = %u\n", reader->DirectoryHeader.IndexTreeDepth);
	CHM_DEBUG_LOG(1, "PMGI Root               = %u\n", reader->DirectoryHeader.IndexOfRootChunk);
	CHM_DEBUG_LOG(1, "First PMGL              = %u\n", reader->DirectoryHeader.FirstPMGLChunkIndex);
	CHM_DEBUG_LOG(1, "Last PMGL               = %u\n", reader->DirectoryHeader.LastPMGLChunkIndex);
	CHM_DEBUG_LOG(1, "Unknown2                = %d\n", reader->DirectoryHeader.Unknown2);
	CHM_DEBUG_LOG(1, "DirCount                = %u\n", reader->DirectoryHeader.DirectoryChunkCount);
	CHM_DEBUG_LOG(1, "LanguageID              = $%04x\n", reader->DirectoryHeader.LanguageID);
	CHM_DEBUG_LOG(1, "guid                    = %s\n", print_guid(&reader->DirectoryHeader.guid));
	CHM_DEBUG_LOG(1, "LengthAgain             = %u\n", reader->DirectoryHeader.LengthAgain);
	CHM_DEBUG_LOG(1, "Unknown3                = %d\n", reader->DirectoryHeader.Unknown3);
	CHM_DEBUG_LOG(1, "Unknown4                = %d\n", reader->DirectoryHeader.Unknown4);
	CHM_DEBUG_LOG(1, "Unknown5                = %d\n", reader->DirectoryHeader.Unknown5);
	CHM_DEBUG_LOG(1, "First Section           = $%016" PRIx64 "\n", reader->HeaderSuffix.Offset);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ITSFReader_ReadHeader(ITSFReader *reader)
{
	CHMStream *stream = reader->Stream;
	
	if (CHMStream_seek(stream, 0) == FALSE)
		return FALSE;
	reader->ITSFheader.ITSFsig.sig[0] = CHMStream_fgetc(stream);
	reader->ITSFheader.ITSFsig.sig[1] = CHMStream_fgetc(stream);
	reader->ITSFheader.ITSFsig.sig[2] = CHMStream_fgetc(stream);
	reader->ITSFheader.ITSFsig.sig[3] = CHMStream_fgetc(stream);
	reader->ITSFheader.Version = read_le32(stream);
	reader->ITSFheader.HeaderLength = read_le32(stream);
	reader->ITSFheader.Unknown_1 = read_le32(stream);
	reader->ITSFheader.TimeStamp = read_be32(stream);
	reader->ITSFheader.LanguageID = read_le32(stream);
	CHM_DEBUG_LOG(1, "ITSF header:\n");
	CHM_DEBUG_LOG(1, "Signature     = %c%c%c%c\n", reader->ITSFheader.ITSFsig.sig[0], reader->ITSFheader.ITSFsig.sig[1], reader->ITSFheader.ITSFsig.sig[2], reader->ITSFheader.ITSFsig.sig[3]);
	CHM_DEBUG_LOG(1, "Version       = %u\n", reader->ITSFheader.Version);
	CHM_DEBUG_LOG(1, "Header length = %u\n", reader->ITSFheader.HeaderLength);
	CHM_DEBUG_LOG(1, "Unknown 1     = %u\n", reader->ITSFheader.Unknown_1);
	CHM_DEBUG_LOG(1, "TimeStamp     = $%08x\n", reader->ITSFheader.TimeStamp);
	CHM_DEBUG_LOG(1, "LanguageID    = $%04x\n", reader->ITSFheader.LanguageID);
	if (reader->ITSFheader.Version < 4)
	{
		if (read_guid(stream, &reader->ITSFheader.guid1) == FALSE)
			return FALSE;
		if (read_guid(stream, &reader->ITSFheader.guid2) == FALSE)
			return FALSE;
	}
	CHM_DEBUG_LOG(1, "guid 1        = %s\n", print_guid(&reader->ITSFheader.guid1));
	CHM_DEBUG_LOG(1, "guid 2        = %s\n", print_guid(&reader->ITSFheader.guid2));
	if (!ITSFReader_IsValidFile(reader))
		return FALSE;
	return ITSFReader_ReadHeaderEntries(reader);
}

/*** ---------------------------------------------------------------------- ***/

gboolean ITSFReader_IsValidFile(ITSFReader *reader)
{
	if (reader == NULL)
		return FALSE;
	if (reader->Stream == NULL)
		reader->ChmLastError = CHM_ERR_STREAM_NOT_ASSIGNED;
	else if (!isSig(reader->ITSFheader.ITSFsig, "ITSF"))
		reader->ChmLastError = CHM_ERR_NOT_VALID_FILE;
	else if (reader->ITSFheader.Version != 2 && reader->ITSFheader.Version != 3 && reader->ITSFheader.Version != 4)
		reader->ChmLastError = CHM_ERR_NOT_SUPPORTED_VERSION;
	return reader->ChmLastError == CHM_ERR_NO_ERR;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_LookupPMGLchunk(CHMMemoryStream *stream, PMGListChunk *PMGLChunk)
{
	/* signature already read by GetChunkType */
	PMGLChunk->UnusedSpace = read_le32(stream);
	PMGLChunk->Unknown1 = read_le32(stream);
	PMGLChunk->PreviousChunkIndex = read_le32(stream);
	PMGLChunk->NextChunkIndex = read_le32(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_LookupPMGIchunk(CHMMemoryStream *stream, PMGIIndexChunk *PMGIChunk)
{
	/* signature already read by GetChunkType */
	PMGIChunk->UnusedSpace = read_le32(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_ReadPMGLchunkEntryFromStream(CHMMemoryStream *stream, PMGListChunkEntry *PMGLEntry)
{
	char *buf;

	PMGLEntry->NameLength = GetCompressedInteger(stream);

	/* failed GetCompressedInteger sanity check */
	if (PMGLEntry->NameLength == 0)
		return FALSE;
	buf = g_new(char, PMGLEntry->NameLength + 1);
	if (buf == NULL)
		return FALSE;
	if (CHMStream_read(stream, buf, PMGLEntry->NameLength) == FALSE)
	{
		g_free(buf);
		return FALSE;
	}
	buf[PMGLEntry->NameLength] = '\0';
	PMGLEntry->Name = buf;
	PMGLEntry->ContentSection = GetCompressedInteger(stream);
	PMGLEntry->ContentOffset = GetCompressedInteger(stream);
	PMGLEntry->DecompressedLength = GetCompressedInteger(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_ReadPMGIchunkEntryFromStream(CHMMemoryStream *stream, PMGIIndexChunkEntry *PMGIEntry)
{
	char *buf;
	
	PMGIEntry->NameLength = GetCompressedInteger(stream);
	if (PMGIEntry->NameLength == 0)
		return FALSE;
	buf = g_new(char, PMGIEntry->NameLength + 1);
	if (buf == NULL)
		return FALSE;
	if (CHMStream_read(stream, buf, PMGIEntry->NameLength) == FALSE)
	{
		g_free(buf);
		return FALSE;
	}
	
	buf[PMGIEntry->NameLength] = '\0';
	PMGIEntry->Name = buf;

	PMGIEntry->ListingChunk = GetCompressedInteger(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_GetDirectoryChunk(ITSFReader *reader, uint32_t Index, CHMMemoryStream *mem)
{
	CHMStream *src;
	
	src = reader->Stream;
	if (CHMStream_seek(src, reader->DirectoryEntriesStartPos + (reader->DirectoryHeader.ChunkSize * Index)) == FALSE)
		return FALSE;
	if (CHMStream_seek(mem, 0) == FALSE ||
		CHMStream_CopyFrom(mem, src, reader->DirectoryHeader.ChunkSize) == FALSE ||
		CHMStream_seek(mem, 0) == FALSE)
	{
		return FALSE;
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static DirChunkType ChunkType(CHMStream *stream, PMGListChunk *PMGLChunk)
{
	PMGLChunk->PMGLsig.sig[0] = CHMStream_fgetc(stream);
	PMGLChunk->PMGLsig.sig[1] = CHMStream_fgetc(stream);
	PMGLChunk->PMGLsig.sig[2] = CHMStream_fgetc(stream);
	PMGLChunk->PMGLsig.sig[3] = CHMStream_fgetc(stream);
	if (isSig(PMGLChunk->PMGLsig, "PMGL"))
		return ctPMGL;
	if (isSig(PMGLChunk->PMGLsig, "PMGI"))
		return ctPMGI;
	if (isSig(PMGLChunk->PMGLsig, "AOLL"))
		return ctAOLL;
	if (isSig(PMGLChunk->PMGLsig, "AOLI"))
		return ctAOLI;
	return ctUnknown;
}

/*** ---------------------------------------------------------------------- ***/

#if 0 /* not used */
static DirChunkType ITSFReader_GetChunkType(ITSFReader *reader, CHMMemoryStream *stream, uint32_t ChunkIndex, PMGListChunk *PMGLChunk)
{
	if (CHMStream_seek(stream, reader->DirectoryEntriesStartPos + (reader->DirectoryHeader.ChunkSize * ChunkIndex)) == FALSE)
		return ctUnknown;
	return ChunkType(stream, PMGLChunk);
}
#endif

/*** ---------------------------------------------------------------------- ***/

gboolean ITSFReader_GetCompleteFileList(ITSFReader *reader, void *obj, FileEntryForEach ForEach, gboolean AIncludeInternalFiles /* = TRUE */)
{
	CHMMemoryStream *ChunkStream;
	uint32_t i;
	PMGListChunkEntry Entry;
	PMGListChunk PMGLChunk;
	uint32_t CutOffPoint;
	PMGIIndexChunk PMGIChunk;
	PMGIIndexChunkEntry PMGIEntry;
	gboolean result = TRUE;
	
	if (reader == NULL || ForEach == NULL)
		return FALSE;
	ChunkStream = CHMStream_CreateMem(reader->DirectoryHeader.ChunkSize);
	if (ChunkStream == NULL)
		return FALSE;
	
	for (i = 0; i < reader->DirectoryHeader.DirectoryChunkCount; i++)
	{
		if (!ITSFReader_GetDirectoryChunk(reader, i, ChunkStream))
		{
			result = FALSE;
			break;
		}
		switch (ChunkType(ChunkStream, &PMGLChunk))
		{
		case ctPMGL:
			if (!ITSFReader_LookupPMGLchunk(ChunkStream, &PMGLChunk))
			{
				result = FALSE;
				break;
			}
			CHM_DEBUG_LOG(2, "PMGL %u: Unused %u Prev %d Next %d\n", i, PMGLChunk.UnusedSpace, PMGLChunk.PreviousChunkIndex, PMGLChunk.NextChunkIndex);
			CutOffPoint = reader->DirectoryHeader.ChunkSize - PMGLChunk.UnusedSpace;
			while (CHMStream_tell(ChunkStream) < CutOffPoint)
			{
				Entry.Name = NULL;
				if (!ITSFReader_ReadPMGLchunkEntryFromStream(ChunkStream, &Entry))
					break;
				if (empty(Entry.Name) || CHMStream_tell(ChunkStream) > CutOffPoint)
				{
					/* we have entered the quickref section */
					g_free(Entry.Name);
					break;
				}
				g_freep(&reader->CachedEntry.Name);
				reader->CachedEntry = Entry;	/* if the caller trys to get this data we already know where it is :) */
				if  (Entry.NameLength == 1 ||
					AIncludeInternalFiles ||
					(Entry.NameLength > 1 && (Entry.Name[1] != '#' || Entry.Name[1] != '$' || Entry.Name[1] != ':')))
				{
					ForEach(obj, Entry.Name, Entry.ContentOffset, Entry.DecompressedLength, Entry.ContentSection);
				}
			}
			break;
		case ctPMGI:
			PMGIChunk.PMGIsig = PMGLChunk.PMGLsig;
			if (!ITSFReader_LookupPMGIchunk(ChunkStream, &PMGIChunk))
			{
				result = FALSE;
				break;
			}
			CHM_DEBUG_LOG(2, "PMGI %u: Unused %u\n", i, PMGIChunk.UnusedSpace);
			CutOffPoint = reader->DirectoryHeader.ChunkSize - PMGIChunk.UnusedSpace - 10;
			while (CHMStream_tell(ChunkStream) < CutOffPoint)
			{
				PMGIEntry.Name = NULL;
				if (!ITSFReader_ReadPMGIchunkEntryFromStream(ChunkStream, &PMGIEntry))
					break;
				CHM_DEBUG_LOG(3, "  %u %s\n", PMGIEntry.ListingChunk, PMGIEntry.Name);
				g_free(PMGIEntry.Name);
			}
			break;
		case ctUnknown:
		case ctAOLL:
		case ctAOLI:
		default:
			CHM_DEBUG_LOG(0, "%u: unknown chunktype '%c%c%c%c'\n", i,
				PMGLChunk.PMGLsig.sig[0],
				PMGLChunk.PMGLsig.sig[1],
				PMGLChunk.PMGLsig.sig[2],
				PMGLChunk.PMGLsig.sig[3]);
			break;
		}
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static uint16_t *ReadQuickRefSection(ITSFReader *reader, CHMMemoryStream *ChunkStream)
{
	chm_off_t OldPosn;
	chm_off_t Posn;
	unsigned int i;
	unsigned int num_entries;
	unsigned int qr_density;
	unsigned int qr_entries;
	uint16_t *QuickRefIndex;
	
	OldPosn = CHMStream_tell(ChunkStream);
	Posn = reader->DirectoryHeader.ChunkSize - sizeof(uint16_t);
	if (CHMStream_seek(ChunkStream, Posn) == FALSE)
		return NULL;
	
	num_entries = read_le16(ChunkStream);
	qr_density = (1 + (1 << reader->DirectoryHeader.Density));
	qr_entries = (num_entries + qr_density - 1) / qr_density;
	if (Posn < (qr_entries * 2))
		return NULL;
	Posn -= qr_entries * 2;
	if (CHMStream_seek(ChunkStream, Posn) == FALSE)
		return NULL;
	QuickRefIndex = g_new(uint16_t, qr_entries);
	for (i = qr_entries; i > 0; )
	{
		--i;
		QuickRefIndex[i] = read_le16(ChunkStream);
	}
	if (!CHMStream_seek(ChunkStream, OldPosn))
		{}
	return QuickRefIndex;
}

/*** ---------------------------------------------------------------------- ***/

static char *ReadString(CHMStream *stream)
{
	uint32_t NameLength;
	char *result;
	
	NameLength = GetCompressedInteger(stream);
	result = g_new(char, NameLength + 1);
	if (NameLength > 0)
	{
		if (!CHMStream_read(stream, result, NameLength))
		{
			g_free(result);
			return NULL;
		}
	}
	result[NameLength] = '\0';
	return result;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ITSFReader_ObjectExists(ITSFReader *reader, const char *Name)
{
	CHMMemoryStream *ChunkStream;
	uint16_t *QuickRefIndex;
	PMGListChunk PMGLChunk;
	PMGIIndexChunk PMGIChunk;
	PMGListChunkEntry Entry;
	int32_t NextIndex;
	char *EntryName;
	int CRes;
	int32_t i;
	gboolean result = FALSE;
	uint32_t CutOffPoint;
	
	if (reader == NULL || empty(Name))
		return FALSE;
	if (reader->DirectoryHeader.DirectoryChunkCount == 0)
		return FALSE;
	
	/* we've already looked it up */
	if (reader->CachedEntry.Name && strcmp(reader->CachedEntry.Name, Name) == 0)
		return TRUE;

	ChunkStream = CHMStream_CreateMem(reader->DirectoryHeader.ChunkSize);
	if (ChunkStream == NULL)
		return FALSE;

	NextIndex = reader->DirectoryHeader.IndexOfRootChunk;
	if (NextIndex < 0)
		NextIndex = 0; /* no PMGI chunks */

	while (NextIndex >= 0)
	{
		if (!ITSFReader_GetDirectoryChunk(reader, NextIndex, ChunkStream))
		{
			result = FALSE;
			break;
		}
		NextIndex = -1;
		QuickRefIndex = ReadQuickRefSection(reader, ChunkStream);
		switch (ChunkType(ChunkStream, &PMGLChunk))
		{
		case ctPMGI: /* we must follow the PMGI tree until we reach a PMGL block */
			PMGIChunk.PMGIsig = PMGLChunk.PMGLsig;
			if (!ITSFReader_LookupPMGIchunk(ChunkStream, &PMGIChunk))
			{
				NextIndex = -1;
				break;
			}
			i = 0;
			CutOffPoint = reader->DirectoryHeader.ChunkSize - PMGIChunk.UnusedSpace;
			while (CHMStream_tell(ChunkStream) <= CutOffPoint)
			{
				EntryName = ReadString(ChunkStream);
				if (EntryName == NULL)
					break;
				if (CHMStream_tell(ChunkStream) >= CutOffPoint)
				{
					g_free(EntryName);
					break;
				}
				CRes = ChmCompareText(Name, EntryName);
				g_free(EntryName);
				if (CRes == 0)
				{
					/* no more need of this block. onto the next! */
					NextIndex = GetCompressedInteger(ChunkStream);
					break;
				}
				if (CRes < 0)
				{
					if (i == 0) /* File doesnt exist */
						break;
					/* file is in previous entry */
					break;
				}
				NextIndex = GetCompressedInteger(ChunkStream);
				++i;
			}
			break;
		case ctPMGL:
			if (!ITSFReader_LookupPMGLchunk(ChunkStream, &PMGLChunk))
			{
				NextIndex = -1;
				break;
			}
			i = 0;
			CutOffPoint = reader->DirectoryHeader.ChunkSize - PMGLChunk.UnusedSpace;
			while (CHMStream_tell(ChunkStream) <= CutOffPoint)
			{
				/* we consume the entry by reading it */
				Entry.Name = NULL;
				if (!ITSFReader_ReadPMGLchunkEntryFromStream(ChunkStream, &Entry))
					break;
				if (empty(Entry.Name) || CHMStream_tell(ChunkStream) > CutOffPoint)
				{
					/* we have entered the quickref section */
					g_free(Entry.Name);
					break;
				}
				CRes = ChmCompareText(Name, Entry.Name);
				if (CRes == 0)
				{
					g_freep(&reader->CachedEntry.Name);
					reader->CachedEntry = Entry;
					result = TRUE;
					break;
				}
				g_free(Entry.Name);
				++i;
			}
			break;
		case ctUnknown: /* something is wrong */
		case ctAOLL:
		case ctAOLI:
		default:
			CHM_DEBUG_LOG(0, "unknown chunktype '%c%c%c%c'\n",
				PMGLChunk.PMGLsig.sig[0],
				PMGLChunk.PMGLsig.sig[1],
				PMGLChunk.PMGLsig.sig[2],
				PMGLChunk.PMGLsig.sig[3]);
			NextIndex = -1;
			break;
		}
		
		g_free(QuickRefIndex);
	}
	
	CHMStream_close(ChunkStream);
	
	return result;
}

/*** ---------------------------------------------------------------------- ***/

WStringList *ITSFReader_GetSections(ITSFReader *reader)
{
	CHMStream *stream;
	uint16_t EntryCount;
	uint16_t X;
	uint16_t i;
	chm_wchar_t *WString;
	uint16_t StrLength;
	WStringList *sections;
	
	sections = NULL;
	stream = ITSFReader_GetObject(reader, "::DataSpace/NameList");

	if (stream == NULL)
		return sections;

	if (!CHMStream_seek(stream, 2))
		return sections;
	
	EntryCount = read_le16(stream);
	for (X = 0; X < EntryCount; X++)
	{
		StrLength = read_le16(stream);
		/* the strings are stored null terminated */
		StrLength++;
		WString = g_new(chm_wchar_t, StrLength);
		for (i = 0; i < StrLength; i++)
		{
			WString[i] = read_le16(stream);
		}
		WString[StrLength - 1] = 0;
		sections = g_slist_append(sections, WString);
	}
	CHMStream_close(stream);
	return sections;
}

/*** ---------------------------------------------------------------------- ***/

static uint64_t ITSFReader_FindBlocksFromUnCompressedAddr(
	ITSFReader *reader,
	const PMGListChunkEntry *ResetTableEntry,
	uint64_t *CompressedSize,
	uint64_t *UnCompressedSize,
	LZXResetTableArr *LZXResetTable)
{
	uint32_t BlockCount;
	uint32_t i;
	uint64_t blocksize;
	CHMStream *stream = reader->Stream;
	uint32_t entrysize;
	uint32_t headersize;
	LZXResetTableArr table;
	
	if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + ResetTableEntry->ContentOffset) == FALSE)
		return 0;
	(void) read_le32(stream); /* version? */
	BlockCount = read_le32(stream);
	entrysize = read_le32(stream);
	if (entrysize != sizeof(uint64_t))
	{
		CHM_DEBUG_LOG(0, "bogus entry size %u in reset table\n", entrysize);
		return 0;
	}
	headersize = read_le32(stream);
	*UnCompressedSize = read_le64(stream);
	*CompressedSize = read_le64(stream);
	blocksize = read_le64(stream);

	if (headersize != 40)
	{
		CHM_DEBUG_LOG(0, "bogus header size %u in reset table\n", headersize);
		if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + ResetTableEntry->ContentOffset + headersize) == FALSE)
			return 0;
	}

	/* now we are located at the first block index */

	table = g_new(uint64_t, BlockCount);
	if (table == NULL)
		return 0;
	for (i = 0; i < BlockCount; i++)
		table[i] = read_le64(stream);
	*LZXResetTable = table;
	return blocksize;
}

/*** ---------------------------------------------------------------------- ***/

static CHMMemoryStream *ITSFReader_GetBlockFromSection(
	ITSFReader *reader,
	const char *SectionPrefix,
	uint64_t StartPos,
	uint64_t BlockLength)
{
	gboolean exists;
	CHMSignature Sig;
	uint32_t CompressionVersion;
	uint64_t CompressedSize;
	uint64_t UnCompressedSize;
	PMGListChunkEntry ResetTableEntry;
	LZXResetTableArr ResetTable = NULL;
	uint64_t WriteCount;
	uint64_t BlockWriteLength;
	uint32_t WriteStart;
	uint32_t ReadCount;
	uint32_t inbuf_size = 0;
	LZXstate *lzx = NULL;
	uint8_t *InBuf = NULL;
	uint8_t *OutBuf = NULL;
	uint64_t BlockSize;
	uint32_t X;
	uint32_t FirstBlock, LastBlock;
	int ResultCode;
	uint32_t LZXResetInterval;
	uint32_t LZXWindowSize;
	uint32_t LZXCacheSize;
	int window_bits;
	char *tmp;
	CHMStream *result = NULL;
	CHMStream *stream = reader->Stream;
	
#define ReadBlock() \
	if (ReadCount > inbuf_size) \
	{ \
		if ((InBuf = g_renew(uint8_t, InBuf, ReadCount)) == NULL) \
			goto fail; \
		inbuf_size = ReadCount; \
	} \
	if (CHMStream_read(stream, InBuf, ReadCount) == FALSE) \
		goto fail

	/* okay now the fun stuff ;) */
	tmp = g_strconcat(SectionPrefix, "Transform/{7FC28940-9D31-11D0-9B27-00A0C91E9C7C}/InstanceData/ResetTable", NULL);
	exists = ITSFReader_ObjectExists(reader, tmp);
	g_free(tmp);
	/* the easy method */
	if (!exists)
	{
		tmp = g_strconcat(SectionPrefix, "Content", NULL);
		exists = ITSFReader_ObjectExists(reader, tmp);
		g_free(tmp);
		if (exists)
		{
			if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset + StartPos) == FALSE)
				goto fail;
			result = CHMStream_CreateMem(BlockLength);
			if (CHMStream_CopyFrom(result, stream, BlockLength) == FALSE)
				goto fail;
		}
		return result;
	}

	ResetTableEntry = reader->CachedEntry;

	/* First make sure that it is a compression we can read */
	tmp = g_strconcat(SectionPrefix, "ControlData", NULL);
	exists = ITSFReader_ObjectExists(reader, tmp);
	g_free(tmp);
	if (exists)
	{
		if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset) == FALSE)
			return NULL;
		CompressionVersion = read_le32(stream);
		CHM_DEBUG_LOG(1, "LZXHeaderLength = %u\n", CompressionVersion);
		Sig.sig[0] = CHMStream_fgetc(stream);
		Sig.sig[1] = CHMStream_fgetc(stream);
		Sig.sig[2] = CHMStream_fgetc(stream);
		Sig.sig[3] = CHMStream_fgetc(stream);
		if (!isSig(Sig, "LZXC"))
		{
			CHM_DEBUG_LOG(0, "no LZXC signature in control file");
			goto fail;
		}
		CompressionVersion = read_le32(stream);
		LZXResetInterval = read_le32(stream);
		LZXWindowSize = read_le32(stream);
		LZXCacheSize = read_le32(stream);
		CHM_DEBUG_LOG(1, "LZXVersion = %u\n", CompressionVersion);
		switch (CompressionVersion)
		{
		case 1:
			break;
		case 2:
		case 3:
			LZXResetInterval *= LZX_FRAME_SIZE;
			LZXWindowSize *= LZX_FRAME_SIZE;
			LZXCacheSize *= LZX_FRAME_SIZE;
			break;
		default:
			CHM_DEBUG_LOG(0, "bad controldata version %u", CompressionVersion);
			goto fail;
		}
		CHM_DEBUG_LOG(1, "LZXResetInterval = %u\n", LZXResetInterval);
		CHM_DEBUG_LOG(1, "LZXWindowSize = %u\n", LZXWindowSize);
		CHM_DEBUG_LOG(1, "LZXCacheSize = %u\n", LZXCacheSize);
	
		/* find window_bits from window size */
		switch (LZXWindowSize)
		{
		case 0x008000:
			window_bits = 15;
			break;
		case 0x010000:
			window_bits = 16;
			break;
		case 0x020000:
			window_bits = 17;
			break;
		case 0x040000:
			window_bits = 18;
			break;
		case 0x080000:
			window_bits = 19;
			break;
		case 0x100000:
			window_bits = 20;
			break;
		case 0x200000:
			window_bits = 21;
			break;
		default:
			CHM_DEBUG_LOG(0, "bad controldata window size %u", LZXWindowSize);
			goto fail;
		}

		BlockSize = ITSFReader_FindBlocksFromUnCompressedAddr(reader, &ResetTableEntry, &CompressedSize, &UnCompressedSize, &ResetTable);
		if (BlockSize == 0)
			goto fail;
		UNUSED(UnCompressedSize);
		FirstBlock = StartPos / BlockSize;
		LastBlock = (StartPos + BlockLength) / BlockSize;
	
		tmp = g_strconcat(SectionPrefix, "Content", NULL);
		exists = ITSFReader_ObjectExists(reader, tmp);
		g_free(tmp);
		if (!exists)
		{
			CHM_DEBUG_LOG(0, "no content");
			goto fail;
		}

		/* First Init a LZXState */
		lzx  = LZXinit(window_bits);
		if (lzx == NULL)
		{
			goto fail;
		}
		
		result = CHMStream_CreateMem(BlockLength);
		inbuf_size = BlockSize;
		InBuf = g_new(uint8_t, inbuf_size);
		OutBuf = g_new(uint8_t, BlockSize);
		
		/* if FirstBlock is odd (1,3,5,7 etc) we have to read the even block before it first. */
		if ((FirstBlock & 1) != 0)
		{
			if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset + ResetTable[FirstBlock-1]) == FALSE)
				goto fail;
			ReadCount = ResetTable[FirstBlock] - ResetTable[FirstBlock-1];
			BlockWriteLength = BlockSize;
			ReadBlock();
			ResultCode = LZXdecompress(lzx, InBuf, OutBuf, ReadCount, BlockWriteLength);
		}
		/* now start the actual decompression loop */
		for (X = FirstBlock; X <= LastBlock; X++)
		{
			if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset + ResetTable[X]) == FALSE)
				goto fail;
	
			if (X == FirstBlock)
				WriteStart = StartPos - (X * BlockSize);
			else
				WriteStart = 0;
	
			if (X == LastBlock || FirstBlock == LastBlock)
				ReadCount = CompressedSize - ResetTable[X];
			else
				ReadCount = ResetTable[X + 1] - ResetTable[X];
	
			BlockWriteLength = BlockSize;
	
			if (FirstBlock == LastBlock)
				WriteCount = BlockLength;
			else if (X == LastBlock)
				WriteCount = (StartPos + BlockLength) - (X * BlockSize);
			else
				WriteCount = BlockSize - WriteStart;
	
			ReadBlock();
			ResultCode = LZXdecompress(lzx, InBuf, OutBuf, ReadCount, BlockWriteLength);
	
			/* now write the decompressed data to the stream */
			if (ResultCode == DECR_OK)
			{
				if (CHMStream_write(result, &OutBuf[WriteStart], WriteCount) == FALSE)
					goto fail;
			} else
			{
				CHM_DEBUG_LOG(0, "'Decompress FAILED with error code: %d\n", ResultCode);
				goto fail;
			}
	
			/* if the next block is an even numbered block we have to reset the decompressor state */
			if (X < LastBlock && (X & 1) != 0)
				LZXreset(lzx);
		}
	}

	goto done;
	
fail:
	CHMStream_close(result);
	result = NULL;
done:
	g_free(InBuf);
	g_free(OutBuf);
	g_free(ResetTable);
	LZXteardown(lzx);

#undef ReadBlock
	return result;
}

/*** ---------------------------------------------------------------------- ***/

CHMMemoryStream *ITSFReader_GetObject(ITSFReader *reader, const char *Name)
{
	WStringList *SectionNames;
	PMGListChunkEntry Entry;
	char *SectionName;
	CHMMemoryStream *stream;
	stream = NULL;

	if (ITSFReader_ObjectExists(reader, Name) == FALSE)
	{
		return NULL;
	}

	Entry = reader->CachedEntry;
	if (Entry.ContentSection == 0)
	{
		stream = CHMStream_CreateMem(Entry.DecompressedLength);
		if (CHMStream_seek(reader->Stream, reader->HeaderSuffix.Offset + Entry.ContentOffset) == FALSE ||
			CHMStream_CopyFrom(stream, reader->Stream, Entry.DecompressedLength) == FALSE)
		{
			CHMStream_close(stream);
			stream = NULL;
		}
	} else
	{
		char *tmp;
		chm_wchar_t *wstring;
		
		/* we have to get it from ::DataSpace/Storage/[MSCompressed,Uncompressed]/ControlData */
		SectionNames = ITSFReader_GetSections(reader);
		wstring = (chm_wchar_t *)g_slist_nth_data(SectionNames, Entry.ContentSection);
		tmp = chm_wchar_to_utf8(wstring, STR0TERM);
		SectionName = g_strdup_printf("::DataSpace/Storage/%s/", tmp);
		stream = ITSFReader_GetBlockFromSection(reader, SectionName, Entry.ContentOffset, Entry.DecompressedLength);
		g_free(tmp);
		g_free(SectionName);
		g_slist_free_full(SectionNames, g_free);
	}
	if (stream != NULL)
	{
		if (CHMStream_seek(stream, 0) == FALSE)
			{}
	}
	return stream;
}

/*** ---------------------------------------------------------------------- ***/

chm_error ITSFReader_GetError(ITSFReader *reader)
{
	if (reader == NULL)
		return CHM_ERR_STREAM_NOT_ASSIGNED;
	return reader->ChmLastError;
}

/*** ---------------------------------------------------------------------- ***/

ITSFReader *ITSFReader_Create(CHMStream *AStream, gboolean FreeStreamOnDestroy)
{
	ITSFReader *reader;
	
	reader = g_new0(ITSFReader, 1);
	if (reader == NULL)
		return NULL;
	reader->Stream = AStream;
	reader->FreeStreamOnDestroy = FreeStreamOnDestroy;
	if (!ITSFReader_ReadHeader(reader) ||
		!ITSFReader_IsValidFile(reader))
		{}
	return reader;
}

/*** ---------------------------------------------------------------------- ***/

void ITSFReader_Destroy(ITSFReader *reader)
{
	if (reader == NULL)
		return;
	if (reader->FreeStreamOnDestroy)
		CHMStream_close(reader->Stream);
	g_freep(&reader->CachedEntry.Name);
	g_free(reader);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void ContextList_AddContext(ContextList **list, HelpContext context, char *url)
{
	ContextItem *item;
	
	item = g_new(ContextItem, 1);
	if (item == NULL)
		return;
	item->context = context;
	item->url = url;
	*list = g_slist_append(*list, item);
}

/*** ---------------------------------------------------------------------- ***/

const char *ContextList_GetURL(ContextList *list, HelpContext context)
{
	while (list != NULL)
	{
		const ContextItem *item = (const ContextItem *)list->data;
		if (item->context == context)
			return item->url;
		list = list->next;
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

static void destroy_context_item(void *data)
{
	ContextItem *item = (ContextItem *)data;
	g_free(item->url);
	g_free(item);
}

void ContextList_Destroy(ContextList *list)
{
	g_slist_free_full(list, destroy_context_item);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

chm_error ChmReader_GetError(ChmReader *reader)
{
	if (reader == NULL)
		return CHM_ERR_STREAM_NOT_ASSIGNED;
	return ITSFReader_GetError(reader->itsf);
}

/*** ---------------------------------------------------------------------- ***/

static char *ChmReader_ReadStringsEntry(ChmReader *reader, uint32_t position)
{
	size_t size;
	
	if (position == 0)
		return g_strdup("");
	if (reader->StringsStream == NULL)
	{
		reader->StringsStream = ITSFReader_GetObject(reader->itsf, "/#STRINGS");
		if (reader->StringsStream == NULL)
			reader->StringsStream = (CHMMemoryStream *)-1;
	}
	if (reader->StringsStream != (CHMMemoryStream *)-1)
	{
		char *base;
		
		size = CHMStream_Size(reader->StringsStream);
		if (position >= size)
			return g_strdup_printf("<string pos %u exceeds size %u>", position, (unsigned int) size);
		base = (char *)CHMStream_Memptr(reader->StringsStream);
		if (base)
		{
			size_t len;
			
			base += position;
			len = 0;
			/* be paranoid... */
			while (position < size && base[len] != '\0')
			{
				len++;
				position++;
			}
			if (position >= size || !g_utf8_validate(base, len, NULL))
			{
				base = chm_conv_to_utf8(base, len);
			} else
			{
				base = g_strndup(base, len);
			}
			return base;
		}
	}
	return g_strdup(position == 0 ? "" : "<no #STRINGS>");
}

/*** ---------------------------------------------------------------------- ***/

static char *ChmReader_ReadStringsEntryFromStream(ChmReader *reader, CHMStream *strm)
{
	uint32_t pos = read_le32(strm);
	return ChmReader_ReadStringsEntry(reader, pos);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmReader_ReadWindows(ChmReader *reader)
{
	CHMMemoryStream *windows;
	uint32_t EntryCount;
	uint32_t EntrySize;
	uint32_t X;
	chm_off_t size;
	gboolean result = FALSE;
	CHMWindow *win;
	int i;
	
	if (reader->WindowsList != NULL)
		return TRUE;
	windows = ITSFReader_GetObject(reader->itsf, "/#WINDOWS");
	if (windows == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #WINDOWS\n\n");
		return FALSE;
	}
	size = CHMStream_Size(windows);
	if (size > 8)
	{
		EntryCount = read_le32(windows);
		EntrySize = read_le32(windows);
		
		if (EntryCount > 0 && EntrySize >= CHM_WIN_MINSIZE && (EntryCount * EntrySize + 8) <= size)
		{
			result = TRUE;
			for (X = 0; X < EntryCount; X++)
			{
				if (CHMStream_seek(windows, X * EntrySize + 8) == FALSE)
				{
					CHM_DEBUG_LOG(0, "/#WINDOWS file corrupted\n");
					continue;
				}
				win = CHMWindow_Create(NULL);
				if (win == NULL)
					break;
				win->version = read_le32(windows);
				win->unicode_strings = read_le32(windows);
				win->window_name.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->flags = read_le32(windows);
				win->win_properties = read_le32(windows);
				win->caption.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->styleflags = read_le32(windows);
				win->xtdstyleflags = read_le32(windows);
				win->pos.left = (int)read_le32(windows);
				win->pos.top = (int)read_le32(windows);
				win->pos.right = (int)read_le32(windows);
				win->pos.bottom = (int)read_le32(windows);
				win->show_state = read_le32(windows);
				win->hwndhelp = read_le32(windows);
				win->hwndcaller = read_le32(windows);
				win->p_info_types = read_le32(windows);
				win->hwndtoolbar = read_le32(windows);
				win->hwndnavigation = read_le32(windows);
				win->hwndhtml = read_le32(windows);
				win->navpanewidth = (int)read_le32(windows);
				win->topic.left = (int)read_le32(windows);
				win->topic.top = (int)read_le32(windows);
				win->topic.right = (int)read_le32(windows);
				win->topic.bottom = (int)read_le32(windows);
				win->toc_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->toc_file.s);
				win->index_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->index_file.s);
				win->default_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->default_file.s);
				win->home_button_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->home_button_file.s);
				win->buttons = read_le32(windows);
				win->not_expanded = read_le32(windows);
				win->navtype = read_le32(windows);
				win->tabpos = read_le32(windows);
				win->wm_notify_id = read_le32(windows);
				for (i = 0; i <= HH_MAX_TABS; i++)
					win->taborder[i] = CHMStream_fgetc(windows);
				win->history = read_le32(windows);
				win->jump1_text.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->jump2_text.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->jump1_url.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->jump1_url.s);
				win->jump2_url.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->jump2_url.s);
				win->minsize.left = (int)read_le32(windows);
				win->minsize.top = (int)read_le32(windows);
				win->minsize.right = (int)read_le32(windows);
				win->minsize.bottom = (int)read_le32(windows);
				
				reader->WindowsList = g_slist_append(reader->WindowsList, win);
				/*
				 * due to character set conversion, we can't
				 * directly use the entries from #STRINGS
				 */
				win->strings_alloced = TRUE;
			}
		} else
		{
			CHM_DEBUG_LOG(0, "/#WINDOWS file corrupted\n");
		}
	} else
	{
		CHM_DEBUG_LOG(0, "/#WINDOWS file truncated\n");
	}
	CHMStream_close(windows);
	
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void read_idxhdr(ChmReader *reader, ChmIdxhdr *idx, CHMMemoryStream *stream, unsigned int size)
{
	unsigned int i;
	
	idx->sig.sig[0] = CHMStream_fgetc(stream);
	idx->sig.sig[1] = CHMStream_fgetc(stream);
	idx->sig.sig[2] = CHMStream_fgetc(stream);
	idx->sig.sig[3] = CHMStream_fgetc(stream);
	idx->timestamp = read_le32(stream);
	idx->unknown1 = read_le32(stream);
	idx->num_topics = read_le32(stream);
	idx->unknown2 = read_le32(stream);
	idx->imagelist.c = ChmReader_ReadStringsEntryFromStream(reader, stream);
	idx->unknown3 = read_le32(stream);
	idx->imagetype_is_folder = read_le32(stream);
	idx->background = read_le32(stream);
	idx->foreground = read_le32(stream);
	idx->foreground = read_le32(stream);
	idx->window_styles = read_le32(stream);
	idx->exwindow_styles = read_le32(stream);
	idx->unknown4 = read_le32(stream);
	idx->framename.c = ChmReader_ReadStringsEntryFromStream(reader, stream);
	idx->windowname.c = ChmReader_ReadStringsEntryFromStream(reader, stream);
	idx->num_information_types = read_le32(stream);
	idx->unknown5 = read_le32(stream);
	idx->num_merge_files = read_le32(stream);
	idx->unknown6 = read_le32(stream);
	if (CHM_IDXHDR_MINSIZE + (idx->num_merge_files * 4) > size)
	{
		CHM_DEBUG_LOG(0, "bogus number of merge files in IDXHDR");
		idx->num_merge_files = (size - CHM_IDXHDR_MINSIZE) / 4;
	}
	for (i = 0; i < idx->num_merge_files; i++)
		idx->merge_files[i].c = ChmReader_ReadStringsEntryFromStream(reader, stream);
}

/*** ---------------------------------------------------------------------- ***/

ChmIdxhdr *ChmReader_GetIdxhdr(ChmReader *reader)
{
	ChmIdxhdr *idx;
	CHMMemoryStream *idxhdr;
	chm_off_t size;
	
	if (reader == NULL)
		return NULL;
	idxhdr = ChmReader_GetObject(reader, "/#IDXHDR");
	if (idxhdr == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #IDXHDR\n\n");
		return NULL;
	}
	size = CHMStream_Size(idxhdr);
	if (size < CHM_IDXHDR_MINSIZE)
	{
		CHM_DEBUG_LOG(0, "/#IDXHDR has only %u bytes\n", (unsigned int)size);
		CHMStream_close(idxhdr);
		return NULL;
	}
	idx = ChmIdxhdr_Create();
	if (idx)
		read_idxhdr(reader, idx, idxhdr, size);
	CHMStream_close(idxhdr);
	return idx;
}

/*** ---------------------------------------------------------------------- ***/

ContextList *ChmReader_GetContextList(ChmReader *reader)
{
	return reader->contextList;
}

/*** ---------------------------------------------------------------------- ***/

const char *ChmReader_GetContextUrl(ChmReader *reader, HelpContext context)
{
	return ContextList_GetURL(reader->contextList, context);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

/*
 * should already be NUL terminated, but don't count on it
 */
static char *read_sys_string(CHMMemoryStream *system, unsigned int len)
{
	char *tmp;
	
	if (len == 0)
		return NULL;
	tmp = g_new(char, len + 1);
	if (tmp == NULL)
		return NULL;
	if (CHMStream_read(system, tmp, len) == FALSE)
	{
		g_free(tmp);
		return NULL;
	}
	tmp[len] = '\0';
	if (!g_utf8_validate(tmp, len, NULL))
	{
		char *tmp2 = chm_conv_to_utf8(tmp, len);
		g_free(tmp);
		tmp = tmp2;
	}
	return tmp;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmReader_ReadSystem(ChmReader *reader)
{
	CHMMemoryStream *system;
	uint16_t code;
	uint16_t EntrySize;
	chm_off_t pos, size;
	gboolean result = FALSE;
	ChmSystem *sys;
	
	if (reader->system != NULL)
		return TRUE;
	system = ITSFReader_GetObject(reader->itsf, "/#SYSTEM");
	if (system == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #SYSTEM\n\n");
		return FALSE;
	}
	size = CHMStream_Size(system);
	if (size > 4)
	{
		sys = ChmSystem_Create();
		if (sys != NULL)
		{
			reader->system = sys;
			sys->version = read_le32(system);
			pos = CHMStream_tell(system);
			
			result = TRUE;
			while ((pos + 4) < size)
			{
				code = read_le16(system);
				EntrySize = read_le16(system);
				
				switch (code)
				{
				case 0:
					sys->toc_file.s = read_sys_string(system, EntrySize);
					break;
				case 1:
					sys->index_file.s = read_sys_string(system, EntrySize);
					break;
				case 2:
					sys->default_page.s = read_sys_string(system, EntrySize);
					break;
				case 3:
					sys->caption.s = read_sys_string(system, EntrySize);
					break;
				case 4:
					if (EntrySize < 0x20)
					{
						CHM_DEBUG_LOG(0, "entry #%u in /#SYSTEM has only %u bytes\n", code, EntrySize);
					} else
					{
						sys->locale_id = read_le32(system);
						sys->dbcs = read_le32(system);
						sys->fulltextsearch = read_le32(system);
						sys->klinks = read_le32(system);
						sys->alinks = read_le32(system);
						sys->timestamp = read_le64(system);
						sys->collection = read_le32(system);
						sys->unknown1 = read_le32(system);
					}
					break;
				case 5:
					sys->default_window.s = read_sys_string(system, EntrySize);
					break;
				case 6:
					sys->chm_filename.s = read_sys_string(system, EntrySize);
					break;
				case 7:
					sys->binary_index_dword = read_le32(system);
					break;
				case 8:
					if (EntrySize < 0x10)
					{
						CHM_DEBUG_LOG(0, "entry #%u in /#SYSTEM has only %u bytes\n", code, EntrySize);
					} else
					{
						sys->unknown2 = read_le32(system);
						sys->abbrev.c = ChmReader_ReadStringsEntryFromStream(reader, system);
						sys->unknown3 = read_le32(system);
						sys->abbrev_explanation.c = ChmReader_ReadStringsEntryFromStream(reader, system);
					}
					break;
				case 9:
					sys->chm_compiler_version.s = read_sys_string(system, EntrySize);
					break;
				case 10:
					sys->local_timestamp = read_le32(system);
					break;
				case 11:
					sys->binary_toc_dword = read_le32(system);
					break;
				case 12:
					sys->num_information_types = read_le32(system);
					break;
				case 13:
					if (EntrySize < CHM_IDXHDR_MINSIZE)
					{
						CHM_DEBUG_LOG(0, "entry #%u in /#SYSTEM has only %u bytes\n", code, EntrySize);
					} else
					{
						sys->idxhdr = ChmIdxhdr_Create();
						read_idxhdr(reader, sys->idxhdr, system, EntrySize);
					}
					break;
				case 14:
					sys->msoffice_windows = read_le32(system);
					break;
				case 15:
					sys->info_type_checksum = read_le32(system);
					break;
				case 16:
					sys->preferred_font.c = ChmReader_ReadStringsEntryFromStream(reader, system);
					break;
				default:
					CHM_DEBUG_LOG(0, "unknown entry #%u in /#SYSTEM file (size %u)\n", code, EntrySize);
					break;
				}
				pos += EntrySize + 4;
				if (CHMStream_seek(system, pos) == FALSE)
				{
					CHM_DEBUG_LOG(0, "/#SYSTEM file corrupted\n");
					break;
				}
			}

			/*
			 * due to character set conversion, we can't
			 * directly use the entries from #STRINGS
			 */
			sys->strings_alloced = TRUE;
		}
	} else
	{
		CHM_DEBUG_LOG(0, "/#SYSTEM file truncated\n");
	}
	CHMStream_close(system);
	
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmReader_ReadContextIds(ChmReader *reader)
{
	CHMMemoryStream *IVB;
	chm_off_t size, pos;
	uint32_t ivbsize;
	uint32_t value;
	char *str;
	
	if (reader->contextList != NULL)
		return TRUE;
	IVB = ITSFReader_GetObject(reader->itsf, "/#IVB");
	if (IVB == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #IVB\n\n");
		return FALSE;
	}
	size = CHMStream_Size(IVB);
	if (size < 4)
	{
		CHMStream_close(IVB);
		CHM_DEBUG_LOG(0, "corrupted #IVB\n");
		return FALSE;
	}
	ivbsize = read_le32(IVB);
	pos = 4;
	if (pos + ivbsize > size)
	{
		CHM_DEBUG_LOG(0, "bogus #IVB size %u\n", ivbsize);
		ivbsize = size - pos;
	}
	while (ivbsize >= 8)
	{
		value = read_le32(IVB);
		str = ChmReader_ReadStringsEntryFromStream(reader, IVB);
		convexternalslash(str);
		ivbsize -= 8;
		ContextList_AddContext(&reader->contextList, value, str);
	}
	CHMStream_close(IVB);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmReader_ReadCommonData(ChmReader *reader)
{
	return ChmReader_ReadSystem(reader) &
	       ChmReader_ReadWindows(reader) &
	       ChmReader_ReadContextIds(reader);
}

/*** ---------------------------------------------------------------------- ***/

CHMMemoryStream *ChmReader_GetObject(ChmReader *reader, const char *Name)
{
	if (reader == NULL || empty(Name))
		return NULL;
	if (ChmCompareText(Name, "/#STRINGS") == 0 ||
		ChmCompareText(Name, "/#WINDOWS") == 0 ||
		ChmCompareText(Name, "/#SYSTEM") == 0 ||
		ChmCompareText(Name, "/#IVB") == 0)
	{
		CHM_DEBUG_LOG(0, "ChmReader_GetObject(%s): use specialized version instead\n", Name);
	}
	return ITSFReader_GetObject(reader->itsf, Name);
}

/*** ---------------------------------------------------------------------- ***/

GSList *ChmReader_GetWindows(ChmReader *reader)
{
	if (reader == NULL)
		return NULL;
	ChmReader_ReadWindows(reader);
	return reader->WindowsList;
}

/*** ---------------------------------------------------------------------- ***/

const ChmSystem *ChmReader_GetSystem(ChmReader *reader)
{
	if (reader == NULL)
		return NULL;
	ChmReader_ReadSystem(reader);
	return reader->system;
}

/*** ---------------------------------------------------------------------- ***/

ChmReader *ChmReader_Create(CHMStream *AStream, gboolean FreeStreamOnDestroy)
{
	ChmReader *reader;
	
	reader = g_new0(ChmReader, 1);
	if (reader == NULL)
		return NULL;
	reader->itsf = ITSFReader_Create(AStream, FreeStreamOnDestroy);
	if (!ITSFReader_IsValidFile(reader->itsf))
	{
		ChmReader_Destroy(reader);
		return NULL;
	}
	ChmReader_ReadCommonData(reader);
	return reader;
}

/*** ---------------------------------------------------------------------- ***/

void ChmReader_Destroy(ChmReader *reader)
{
	if (reader == NULL)
		return;
	g_slist_free(reader->contextList);
	g_slist_free_full(reader->WindowsList, (GDestroyNotify)CHMWindow_Destroy);
	ChmSystem_Destroy(reader->system);
	ChmSearchReader_Destroy(reader->SearchReader);
	CHMStream_close(reader->TOPICSStream);
	CHMStream_close(reader->URLSTRStream);
	CHMStream_close(reader->URLTBLStream);
	if (reader->StringsStream != (CHMMemoryStream *)-1)
		CHMStream_close(reader->StringsStream);
	ITSFReader_Destroy(reader->itsf);
	g_free(reader);
}
