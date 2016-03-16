#include "chmtools.h"
#include "chmreader.h"
#include "lzx.h"

#define isSig(s, str) \
	((((unsigned char)s.sig[0] << 24) | ((unsigned char)s.sig[1] << 16) | ((unsigned char)s.sig[2] << 8) | ((unsigned char)s.sig[3])) == \
	 (((unsigned char)str[0] << 24) | ((unsigned char)str[1] << 16) | ((unsigned char)str[2] << 8) | ((unsigned char)str[3])))

#define NO_SUCH_STREAM ((CHMMemoryStream *)-1)

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

char *changefileext(const char *filename, const char *ext)
{
	const char *p;
	char *changed;
	char *tmp;
	
	p = strrchr(filename, '.');
	if (p == NULL)
		return g_strconcat(filename, ext, NULL);
	tmp = g_strndup(filename, p - filename);
	changed = g_strconcat(tmp, ext, NULL);
	g_free(tmp);
	return changed;
}

/*** ---------------------------------------------------------------------- ***/

const char *print_guid(const GUID *guid)
{
	/*
	 * non-reentrant here, but this function
	 * is only used for debug output
	 */
	static char buf[50];
	sprintf(buf, "{%08X-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}",
		(unsigned int)guid->Data1,
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

chm_nametype chm_get_nametype(const char *name, size_t len)
{
	if (name == NULL || len == 0)
		return chm_name_empty;
	/* ::DataSpace/NameList etc. */
	if (*name == ':')
		return chm_name_storage;
	if (*name == '/')
	{
		name++;
		len--;
		if (len == 0)
			return chm_name_external;
	}
	if (*name == '$' || *name == '#')
		return chm_name_internal;
	return chm_name_external;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean read_guid(CHMStream *stream, GUID *guid)
{
	guid->Data1 = chmstream_read_le32(stream);
	guid->Data2 = chmstream_read_le16(stream);
	guid->Data3 = chmstream_read_le16(stream);
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
	HeaderEntries[0].PosFromZero = chmstream_read_le64(stream);
	HeaderEntries[0].Length = chmstream_read_le64(stream);
	HeaderEntries[1].PosFromZero = chmstream_read_le64(stream);
	HeaderEntries[1].Length = chmstream_read_le64(stream);
	CHM_DEBUG_LOG(1, "Header section 0 = offset $%016" PRIx64 ", length $%016" PRIx64 "\n", HeaderEntries[0].PosFromZero, HeaderEntries[0].Length);
	CHM_DEBUG_LOG(1, "Header section 1 = offset $%016" PRIx64 ", length $%016" PRIx64 "\n", HeaderEntries[1].PosFromZero, HeaderEntries[1].Length);
	
	reader->HeaderSuffix.Offset = 0;
	if (reader->ITSFheader.Version >= 3 && reader->ITSFheader.HeaderLength >= 0x60)
		reader->HeaderSuffix.Offset = chmstream_read_le64(stream);
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
	reader->DirectoryHeader.Version = chmstream_read_le32(stream);
	reader->DirectoryHeader.DirHeaderLength = chmstream_read_le32(stream);
	reader->DirectoryHeader.Unknown1 = chmstream_read_le32(stream);
	reader->DirectoryHeader.ChunkSize = chmstream_read_le32(stream);
	reader->DirectoryHeader.Density = chmstream_read_le32(stream);
	reader->DirectoryHeader.IndexTreeDepth = chmstream_read_le32(stream);
	reader->DirectoryHeader.IndexOfRootChunk = chmstream_read_le32(stream);
	reader->DirectoryHeader.FirstPMGLChunkIndex = chmstream_read_le32(stream);
	reader->DirectoryHeader.LastPMGLChunkIndex = chmstream_read_le32(stream);
	reader->DirectoryHeader.Unknown2 = chmstream_read_le32(stream);
	reader->DirectoryHeader.DirectoryChunkCount = chmstream_read_le32(stream);
	reader->DirectoryHeader.LanguageID = chmstream_read_le32(stream);
	if (read_guid(stream, &reader->DirectoryHeader.guid) == FALSE)
		return FALSE;
	reader->DirectoryHeader.LengthAgain = chmstream_read_le32(stream);
	reader->DirectoryHeader.Unknown3 = chmstream_read_le32(stream);
	reader->DirectoryHeader.Unknown4 = chmstream_read_le32(stream);
	reader->DirectoryHeader.Unknown5 = chmstream_read_le32(stream);

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
	reader->ITSFheader.Version = chmstream_read_le32(stream);
	reader->ITSFheader.HeaderLength = chmstream_read_le32(stream);
	reader->ITSFheader.Unknown_1 = chmstream_read_le32(stream);
	reader->ITSFheader.TimeStamp = chmstream_read_be32(stream);
	reader->ITSFheader.LanguageID = chmstream_read_le32(stream);
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
	PMGLChunk->UnusedSpace = chmstream_read_le32(stream);
	PMGLChunk->Unknown1 = chmstream_read_le32(stream);
	PMGLChunk->PreviousChunkIndex = chmstream_read_le32(stream);
	PMGLChunk->NextChunkIndex = chmstream_read_le32(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_LookupPMGIchunk(CHMMemoryStream *stream, PMGIIndexChunk *PMGIChunk)
{
	/* signature already read by GetChunkType */
	PMGIChunk->UnusedSpace = chmstream_read_le32(stream);
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

gboolean ITSFReader_GetCompleteFileList(ITSFReader *reader, void *obj, FileEntryForEach ForEach)
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
				ChmFileInfo info;
				char *namecopy;
				
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
				info.namelen = Entry.NameLength;
				namecopy = g_strndup(Entry.Name, info.namelen);
				info.name = namecopy;
				info.type = chm_get_nametype(info.name, info.namelen);
				info.offset = Entry.ContentOffset;
				info.uncompressedsize = Entry.DecompressedLength;
				info.section = Entry.ContentSection;
				ForEach(obj, &info);
				g_free(namecopy);
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
	
	num_entries = chmstream_read_le16(ChunkStream);
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
		QuickRefIndex[i] = chmstream_read_le16(ChunkStream);
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
	char *freeme = NULL;
	
	if (reader == NULL || empty(Name))
		return FALSE;
	if (reader->DirectoryHeader.DirectoryChunkCount == 0)
		return FALSE;
	
	if (*Name != '/' && chm_get_nametype(Name, strlen(Name)) == chm_name_external)
	{
		freeme = g_strconcat("/", Name, NULL);
		if (freeme == NULL)
			return FALSE;
		Name = freeme;
	}
	
	/* we've already looked it up */
	if (reader->CachedEntry.Name && strcmp(reader->CachedEntry.Name, Name) == 0)
	{
		g_free(freeme);
		return TRUE;
	}
	
	ChunkStream = CHMStream_CreateMem(reader->DirectoryHeader.ChunkSize);
	if (ChunkStream == NULL)
	{
		g_free(freeme);
		return FALSE;
	}
	
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
	
	g_free(freeme);
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
	
	EntryCount = chmstream_read_le16(stream);
	for (X = 0; X < EntryCount; X++)
	{
		StrLength = chmstream_read_le16(stream);
		/* the strings are stored null terminated */
		StrLength++;
		WString = g_new(chm_wchar_t, StrLength);
		for (i = 0; i < StrLength; i++)
		{
			WString[i] = chmstream_read_le16(stream);
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
	(void) chmstream_read_le32(stream); /* version? */
	BlockCount = chmstream_read_le32(stream);
	entrysize = chmstream_read_le32(stream);
	if (entrysize != sizeof(uint64_t))
	{
		CHM_DEBUG_LOG(0, "bogus entry size %u in reset table\n", entrysize);
		return 0;
	}
	headersize = chmstream_read_le32(stream);
	*UnCompressedSize = chmstream_read_le64(stream);
	*CompressedSize = chmstream_read_le64(stream);
	blocksize = chmstream_read_le64(stream);

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
		table[i] = chmstream_read_le64(stream);
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
	/*
	 * Name in ResetTableEntry will be freed when the next
	 * entry is read, make sure we don't use it
	 */
	ResetTableEntry.Name = NULL;
	
	/* First make sure that it is a compression we can read */
	tmp = g_strconcat(SectionPrefix, "ControlData", NULL);
	exists = ITSFReader_ObjectExists(reader, tmp);
	g_free(tmp);
	if (exists)
	{
		if (CHMStream_seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset) == FALSE)
			return NULL;
		CompressionVersion = chmstream_read_le32(stream);
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
		CompressionVersion = chmstream_read_le32(stream);
		LZXResetInterval = chmstream_read_le32(stream);
		LZXWindowSize = chmstream_read_le32(stream);
		LZXCacheSize = chmstream_read_le32(stream);
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

const char *ContextList_GetURL(const ContextList *list, HelpContext context)
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

char *ChmReader_ReadStringsEntry(ChmReader *reader, uint32_t position)
{
	size_t size;
	
	if (reader->StringsStream == NULL)
	{
		reader->StringsStream = ITSFReader_GetObject(reader->itsf, "/#STRINGS");
		if (reader->StringsStream == NULL)
			reader->StringsStream = NO_SUCH_STREAM;
		else
			CHMStream_TakeOwner(reader->StringsStream, TRUE);
	}
	if (reader->StringsStream != NO_SUCH_STREAM)
	{
		char *base;
		
		size = CHMStream_Size(reader->StringsStream);
		if (position >= size)
		{
			/*
			 * quite often an offset of -1 is used
			 */
			if (position == 0xffffffff)
				return g_strdup("");
			return g_strdup_printf("<string pos %u exceeds size %u>", position, (unsigned int) size);
		}
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
	uint32_t pos = chmstream_read_le32(strm);
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
		EntryCount = chmstream_read_le32(windows);
		EntrySize = chmstream_read_le32(windows);
		
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
				win->version = chmstream_read_le32(windows);
				win->unicode_strings = chmstream_read_le32(windows);
				win->window_name.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->flags = chmstream_read_le32(windows);
				win->win_properties = chmstream_read_le32(windows);
				win->caption.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->styleflags = chmstream_read_le32(windows);
				win->xtdstyleflags = chmstream_read_le32(windows);
				win->pos.left = (int)chmstream_read_le32(windows);
				win->pos.top = (int)chmstream_read_le32(windows);
				win->pos.right = (int)chmstream_read_le32(windows);
				win->pos.bottom = (int)chmstream_read_le32(windows);
				win->show_state = chmstream_read_le32(windows);
				win->hwndhelp = chmstream_read_le32(windows);
				win->hwndcaller = chmstream_read_le32(windows);
				win->p_info_types = chmstream_read_le32(windows);
				win->hwndtoolbar = chmstream_read_le32(windows);
				win->hwndnavigation = chmstream_read_le32(windows);
				win->hwndhtml = chmstream_read_le32(windows);
				win->navpanewidth = (int)chmstream_read_le32(windows);
				win->topic.left = (int)chmstream_read_le32(windows);
				win->topic.top = (int)chmstream_read_le32(windows);
				win->topic.right = (int)chmstream_read_le32(windows);
				win->topic.bottom = (int)chmstream_read_le32(windows);
				win->toc_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->toc_file.s);
				win->index_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->index_file.s);
				win->default_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->default_file.s);
				win->home_button_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->home_button_file.s);
				win->buttons = chmstream_read_le32(windows);
				win->not_expanded = chmstream_read_le32(windows);
				win->navtype = chmstream_read_le32(windows);
				win->tabpos = chmstream_read_le32(windows);
				win->wm_notify_id = chmstream_read_le32(windows);
				for (i = 0; i <= HH_MAX_TABS; i++)
					win->taborder[i] = CHMStream_fgetc(windows);
				win->history = chmstream_read_le32(windows);
				win->jump1_text.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->jump2_text.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				win->jump1_url.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->jump1_url.s);
				win->jump2_url.c = ChmReader_ReadStringsEntryFromStream(reader, windows);
				convexternalslash(win->jump2_url.s);
				win->minsize.left = (int)chmstream_read_le32(windows);
				win->minsize.top = (int)chmstream_read_le32(windows);
				win->minsize.right = (int)chmstream_read_le32(windows);
				win->minsize.bottom = (int)chmstream_read_le32(windows);
				
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
	idx->timestamp = chmstream_read_le32(stream);
	idx->unknown1 = chmstream_read_le32(stream);
	idx->num_topics = chmstream_read_le32(stream);
	idx->unknown2 = chmstream_read_le32(stream);
	idx->imagelist.c = ChmReader_ReadStringsEntryFromStream(reader, stream);
	idx->unknown3 = chmstream_read_le32(stream);
	idx->imagetype_is_folder = chmstream_read_le32(stream);
	idx->background = chmstream_read_le32(stream);
	idx->foreground = chmstream_read_le32(stream);
	idx->foreground = chmstream_read_le32(stream);
	idx->window_styles = chmstream_read_le32(stream);
	idx->exwindow_styles = chmstream_read_le32(stream);
	idx->unknown4 = chmstream_read_le32(stream);
	idx->framename.c = ChmReader_ReadStringsEntryFromStream(reader, stream);
	idx->windowname.c = ChmReader_ReadStringsEntryFromStream(reader, stream);
	idx->num_information_types = chmstream_read_le32(stream);
	idx->unknown5 = chmstream_read_le32(stream);
	idx->num_merge_files = chmstream_read_le32(stream);
	idx->unknown6 = chmstream_read_le32(stream);
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

const ContextList *ChmReader_GetContextList(ChmReader *reader)
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
			sys->version = chmstream_read_le32(system);
			pos = CHMStream_tell(system);
			
			result = TRUE;
			while ((pos + 4) < size)
			{
				code = chmstream_read_le16(system);
				EntrySize = chmstream_read_le16(system);
				
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
						sys->locale_id = chmstream_read_le32(system);
						sys->dbcs = chmstream_read_le32(system);
						sys->fulltextsearch = chmstream_read_le32(system);
						sys->klinks = chmstream_read_le32(system);
						sys->alinks = chmstream_read_le32(system);
						sys->timestamp = chmstream_read_le64(system);
						sys->collection = chmstream_read_le32(system);
						sys->unknown1 = chmstream_read_le32(system);
					}
					break;
				case 5:
					sys->default_window.s = read_sys_string(system, EntrySize);
					break;
				case 6:
					sys->chm_filename.s = read_sys_string(system, EntrySize);
					break;
				case 7:
					sys->binary_index_dword = chmstream_read_le32(system);
					break;
				case 8:
					if (EntrySize < 0x10)
					{
						CHM_DEBUG_LOG(0, "entry #%u in /#SYSTEM has only %u bytes\n", code, EntrySize);
					} else
					{
						sys->unknown2 = chmstream_read_le32(system);
						sys->abbrev.c = ChmReader_ReadStringsEntryFromStream(reader, system);
						sys->unknown3 = chmstream_read_le32(system);
						sys->abbrev_explanation.c = ChmReader_ReadStringsEntryFromStream(reader, system);
					}
					break;
				case 9:
					sys->chm_compiler_version.s = read_sys_string(system, EntrySize);
					break;
				case 10:
					sys->local_timestamp = chmstream_read_le32(system);
					break;
				case 11:
					sys->binary_toc_dword = chmstream_read_le32(system);
					break;
				case 12:
					sys->num_information_types = chmstream_read_le32(system);
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
					sys->msoffice_windows = chmstream_read_le32(system);
					break;
				case 15:
					sys->info_type_checksum = chmstream_read_le32(system);
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
	ivbsize = chmstream_read_le32(IVB);
	pos = 4;
	if (pos + ivbsize > size)
	{
		CHM_DEBUG_LOG(0, "bogus #IVB size %u\n", ivbsize);
		ivbsize = size - pos;
	}
	while (ivbsize >= 8)
	{
		value = chmstream_read_le32(IVB);
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

static gboolean ChmReader_CheckCommonStreams(ChmReader *reader)
{
	if (reader == NULL)
		return FALSE;
	
	if (reader->TOPICSStream == NULL)
	{
		reader->TOPICSStream = ITSFReader_GetObject(reader->itsf, "/#TOPICS");
		if (reader->TOPICSStream == NULL)
			reader->TOPICSStream = NO_SUCH_STREAM;
		else
			CHMStream_TakeOwner(reader->TOPICSStream, TRUE);
	}

	if (reader->URLSTRStream == NULL)
	{
		reader->URLSTRStream = ITSFReader_GetObject(reader->itsf, "/#URLSTR");
		if (reader->URLSTRStream == NULL)
			reader->URLSTRStream = NO_SUCH_STREAM;
		else
			CHMStream_TakeOwner(reader->URLSTRStream, TRUE);
	}

	if (reader->URLTBLStream == NULL)
	{
		reader->URLTBLStream = ITSFReader_GetObject(reader->itsf, "/#URLTBL");
		if (reader->URLTBLStream == NULL)
			reader->URLTBLStream = NO_SUCH_STREAM;
		else
			CHMStream_TakeOwner(reader->URLTBLStream, TRUE);
	}

	if (reader->TOPICSStream == NO_SUCH_STREAM)
		return FALSE;
	if (reader->URLSTRStream == NO_SUCH_STREAM)
		return FALSE;
	if (reader->URLTBLStream == NO_SUCH_STREAM)
		return FALSE;

	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

CHMMemoryStream *ChmReader_GetObject(ChmReader *reader, const char *Name)
{
	char *freeme = NULL;
	CHMMemoryStream *o;
	
	if (reader == NULL || empty(Name))
		return NULL;
	if (*Name != '/' && chm_get_nametype(Name, strlen(Name)) == chm_name_external)
	{
		freeme = g_strconcat("/", Name, NULL);
		if (freeme == NULL)
			return NULL;
		Name = freeme;
	}
	
	if (ChmCompareText(Name, "/#STRINGS") == 0 ||
		ChmCompareText(Name, "/#WINDOWS") == 0 ||
		ChmCompareText(Name, "/#SYSTEM") == 0 ||
		ChmCompareText(Name, "/#IDXHDR") == 0 ||
		ChmCompareText(Name, "/#IVB") == 0)
	{
		CHM_DEBUG_LOG(0, "ChmReader_GetObject(%s): use specialized version instead\n", Name);
	}
	if (ChmCompareText(Name, "/#STRINGS") == 0)
	{
		g_free(ChmReader_ReadStringsEntry(reader, 0));
		if (reader->StringsStream == NO_SUCH_STREAM)
			o = NULL;
		else
			o = reader->StringsStream;
	} else if (ChmCompareText(Name, "/#TOPICS") == 0)
	{
		ChmReader_CheckCommonStreams(reader);
		if (reader->TOPICSStream == NO_SUCH_STREAM)
			o = NULL;
		else
			o = reader->TOPICSStream;
	} else if (ChmCompareText(Name, "/#URLSTR") == 0)
	{
		ChmReader_CheckCommonStreams(reader);
		if (reader->URLSTRStream == NO_SUCH_STREAM)
			o = NULL;
		else
			o = reader->URLSTRStream;
	}
	if (ChmCompareText(Name, "/#URLTBL") == 0)
	{
		ChmReader_CheckCommonStreams(reader);
		if (reader->URLTBLStream == NO_SUCH_STREAM)
			o = NULL;
		else
			o = reader->URLTBLStream;
	} else
	{
		o = ITSFReader_GetObject(reader->itsf, Name);
	}
	g_free(freeme);
	return o;
}

/*** ---------------------------------------------------------------------- ***/

const char *ChmReader_ReadURLSTR(ChmReader *reader, uint32_t APosition)
{
	size_t URLStrURLOffset;
	size_t URLStrURLSize;
	
	if (!ChmReader_CheckCommonStreams(reader))
		return NULL;

	if (CHMStream_seek(reader->URLTBLStream, APosition) == FALSE)
		return NULL;
	chmstream_read_le32(reader->URLTBLStream); /* unknown */
	chmstream_read_le32(reader->URLTBLStream); /* TOPIC index # */
	URLStrURLOffset = chmstream_read_le32(reader->URLTBLStream);
	URLStrURLSize = CHMStream_Size(reader->URLSTRStream);
	if (URLStrURLSize == 0)
		return NULL;
	if (URLStrURLOffset >= URLStrURLSize || CHMStream_seek(reader->URLSTRStream, URLStrURLOffset) == FALSE)
		return NULL;
	chmstream_read_le32(reader->URLSTRStream);
	chmstream_read_le32(reader->URLSTRStream);
	URLStrURLOffset += 8;
	if (URLStrURLOffset < URLStrURLSize)
		return (const char *)CHMStream_Memptr(reader->URLSTRStream) + URLStrURLOffset;
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

const char *ChmReader_LookupTopicByID(ChmReader *reader, uint32_t ATopicID, char **ATitle)
{
	uint32_t TopicURLTBLOffset;
	uint32_t TopicTitleOffset;
	size_t topic_pos;

	*ATitle = NULL;
	if (!ChmReader_CheckCommonStreams(reader))
		return NULL;
	topic_pos = ATopicID * 16;
	if (CHMStream_seek(reader->TOPICSStream, topic_pos))
	{
		chmstream_read_le32(reader->TOPICSStream);	/* skip TOCIDX offset */
		TopicTitleOffset = chmstream_read_le32(reader->TOPICSStream);
		TopicURLTBLOffset = chmstream_read_le32(reader->TOPICSStream);
		if (TopicTitleOffset != 0xFFFFFFFFUL)
			*ATitle = ChmReader_ReadStringsEntry(reader, TopicTitleOffset);
		return ChmReader_ReadURLSTR(reader, TopicURLTBLOffset);
	}
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

const GSList *ChmReader_GetWindows(ChmReader *reader)
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

/*
 * sitemap functions
 */

/*** ---------------------------------------------------------------------- ***/

static ChmSiteMap *ChmReader_GetIndexSitemapXML(ChmReader *reader)
{
	ChmSiteMap *sitemap = NULL;
	CHMMemoryStream *Index;
	const char *o;
	char *freeme = NULL;
	
	if (reader->system != NULL && reader->system->index_file.c != NULL)
	{
		o = reader->system->index_file.c;
	} else if (reader->system != NULL && reader->system->chm_filename.c)
	{
		freeme = g_strconcat(reader->system->chm_filename.c, ".hhk", NULL);
		o = freeme;
	} else if ((o = ChmStream_GetFilename(reader->itsf->Stream)) != NULL)
	{
		freeme = changefileext(chm_basename(o), ".hhk");
		o = freeme;
	}
	Index = ChmReader_GetObject(reader, o);
	if (Index != NULL)
	{
		sitemap = ChmSiteMap_Create(stIndex);
		ChmSiteMap_LoadFromStream(sitemap, Index);
		CHMStream_close(Index);
	}
	g_free(freeme);
	return sitemap;
}

/*** ---------------------------------------------------------------------- ***/

#define get_le16(var, p) \
	var = ((uint16_t)((p)[1]) << 8) | (uint16_t)((p)[0]), p += 2

#define get_le32(var, p) \
		var = ((uint32_t)((p)[3]) << 24) | ((uint32_t)((p)[2]) << 16) | ((uint32_t)((p)[1]) << 8) | (uint32_t)((p)[0]), p += 4
	
#if 0
#  define DEBUG_BININDEX(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
#else
#  define DEBUG_BININDEX(fmt, ...)
#endif

static gboolean LoadBtreeHeader(CHMStream *m, BtreeHeader *hdr)
{
	unsigned char buf[SIZEOF_BTREEHEADER];
	const unsigned char *p = buf;
	
	if (CHMStream_read(m, buf, SIZEOF_BTREEHEADER) == FALSE)
		return FALSE;
	hdr->ident[0] = *p++;
	hdr->ident[1] = *p++;
	get_le16(hdr->flags, p);
	get_le16(hdr->blocksize, p);
	memcpy(hdr->dataformat, p, 16); p += 16;
	get_le32(hdr->unknown0, p);
	get_le32(hdr->lastlistblock, p);
	get_le32(hdr->indexrootblock, p);
	get_le32(hdr->unknown1, p);
	get_le32(hdr->nrblock, p);
	get_le16(hdr->treedepth, p);
	get_le32(hdr->nrkeywords, p);
	get_le32(hdr->codepage, p);
	get_le32(hdr->lcid, p);
	get_le32(hdr->ischm, p);
	get_le32(hdr->unknown2, p);
	get_le32(hdr->unknown3, p);
	get_le32(hdr->unknown4, p);
	get_le32(hdr->unknown5, p);
	assert(p == (buf + SIZEOF_BTREEHEADER));
	DEBUG_BININDEX("btree: flags : $%x\n", hdr->flags);
	DEBUG_BININDEX("btree: blocksize : %u\n", hdr->blocksize);
	DEBUG_BININDEX("btree: lastlistblock : %d\n", hdr->lastlistblock);
	DEBUG_BININDEX("btree: indexrootblock : %d\n", hdr->indexrootblock);
	DEBUG_BININDEX("btree: nrblock: %d\n", hdr->nrblock);
	DEBUG_BININDEX("btree: treedepth: %d\n", hdr->treedepth);
	DEBUG_BININDEX("btree: nrkeywords: %d\n", hdr->nrkeywords);
	DEBUG_BININDEX("btree: codepage: %d\n", hdr->codepage);
	DEBUG_BININDEX("btree: lcid: $%x\n", hdr->lcid);
	DEBUG_BININDEX("btree: ischm: %u\n", hdr->ischm);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static void createindexsitemapentry(ChmSiteMap *sitemap, ChmSiteMapItem **item, const chm_wchar_t *name, int charindex, const char *topic, const char *title)
{
	ChmSiteMapItem *litem;
	
	if (charindex == 0)
	{
		*item = ChmSiteMapItems_NewItem(sitemap->items);
		(*item)->name = chm_wchar_to_utf8(name, STR0TERM);
		(*item)->local = g_strdup(topic);
		if (title && strcmp((*item)->name, title) != 0)
			(*item)->keyword = g_strdup(title);
		printf("new item: %s %s\n", (*item)->name, (*item)->local);
	} else
	{
		char *longpart = chm_wchar_to_utf8(name + charindex, STR0TERM);
		char *shortname = chm_wchar_to_utf8(name, charindex - 1);
		if (*item && strcmp(shortname, (*item)->name) == 0)
		{
			litem = ChmSiteMapItems_NewItem((*item)->children);
			litem->name = longpart; /* recursively split this? No examples. */
			litem->local = g_strdup(topic);
			litem->keyword = g_strdup(title);
			g_free(shortname);
		} else
		{
			*item = ChmSiteMapItems_NewItem(sitemap->items);
			(*item)->name = shortname;
			(*item)->local = g_strdup(topic);
			(*item)->keyword = g_strdup(title);
			litem = ChmSiteMapItems_NewItem((*item)->children);
			litem->name = longpart;
			litem->local = g_strdup(topic);
			litem->keyword = g_strdup(title); /* recursively split this? No examples. */
		}
	}
}

/*** ---------------------------------------------------------------------- ***/

static gboolean readwcharstring(const uint8_t **head, const uint8_t *tail, chm_wchar_t **Name)
{
	const uint8_t *pw;
	unsigned int i, n;
	
	pw = *head;
	while (pw < tail && (pw[0] != 0 || pw[1] != 0))
		pw += 2;
	pw += 2; /* skip trailing NUL */
	*Name = NULL;
	if (pw >= tail)		/* >= because more data needs to follow the name */
		return FALSE;
	n = (pw - *head) / 2;
	pw = *head;
	*Name = g_new(chm_wchar_t, n);
	if (*Name == NULL)
		return FALSE;
	for (i = 0; i < n; i++)
	{
		get_le16((*Name)[i], pw);
	}
	*head = pw;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean parselistingblock(ChmReader *reader, ChmSiteMap *sitemap, ChmSiteMapItem **item, const uint8_t *p, unsigned int blocksize)
{
	const uint8_t *head, *tail;
	BtreeBlockHeader hdr;
	chm_wchar_t *Name;
	chm_wchar_t *seealsostr;
	BtreeBlockEntry entry;
	unsigned int i;
	uint32_t dummy;
	char *title;
	const char *topic;
	uint16_t entrynum;
	
	get_le16(hdr.Length, p);
	get_le16(hdr.NumberOfEntries, p);
	get_le32(hdr.IndexOfPrevBlock, p);
	get_le32(hdr.IndexOfNextBlock, p);
	DEBUG_BININDEX("blockhdr: Length : %u\n", hdr.Length);
	DEBUG_BININDEX("blockhdr: numberofentries : %u\n", hdr.NumberOfEntries);
	DEBUG_BININDEX("blockhdr: IndexOfPrevBlock : %d\n", hdr.IndexOfPrevBlock);
	DEBUG_BININDEX("blockhdr: IndexOfNextBlock : %d\n", hdr.IndexOfNextBlock);
	if (hdr.Length > (blocksize - SIZEOF_BTREEBLOCKHEADER))
	{
		CHM_DEBUG_LOG(0, "invalid length %u in btree block header\n", hdr.Length);
		return FALSE;
	}
	
	tail = p + blocksize - hdr.Length - SIZEOF_BTREEBLOCKHEADER;
	head = p;
	
	entrynum = 0;
	while (head < tail && entrynum < hdr.NumberOfEntries)
	{
		if (!readwcharstring(&head, tail, &Name))
			break;
		DEBUG_BININDEX("blockentry %u: name: %s\n", entrynum, chm_wchar_to_utf8(Name, STR0TERM));
		if ((head + SIZEOF_BTREEBLOCKENTRY) >= tail)	/* >= because more data needs to follow the name */
		{
			g_free(Name);
			break;
		}
		get_le16(entry.isseealso, head);
		get_le16(entry.entrydepth, head);
		get_le32(entry.charindex, head);
		get_le32(entry.unknown0, head);
		get_le32(entry.nrpairs, head);
		DEBUG_BININDEX("blockentry %u: isseealso: %u\n", entrynum, entry.isseealso);
		DEBUG_BININDEX("blockentry %u: entrydepth: %u\n", entrynum, entry.entrydepth);
		DEBUG_BININDEX("blockentry %u: charindex: %u\n", entrynum, entry.charindex);
		DEBUG_BININDEX("blockentry %u: unknown0: %u\n", entrynum, entry.unknown0);
		DEBUG_BININDEX("blockentry %u: nrpairs: %u\n", entrynum, entry.nrpairs);
		
		title = NULL;
		topic = NULL;
		if (entry.isseealso > 0)
		{
			if (!readwcharstring(&head, tail, &seealsostr))
			{
				g_free(Name);
				break;
			}
			/* have to figure out first what to do with it. */
			/* is See Also really mutually exclusive with pairs? */
			/* or is the number of pairs equal to the number of seealso */
			/* strings? */
			DEBUG_BININDEX("blockentry %u: seealso: %s\n", entrynum, chm_wchar_to_utf8(seealsostr, STR0TERM));
			g_free(seealsostr);
		} else
		{
			for (i = 0; head < tail && i < entry.nrpairs; i++)
			{
				uint32_t nameind;
				
				get_le32(nameind, head);
				g_free(title);
				topic = ChmReader_LookupTopicByID(reader, nameind, &title);
				DEBUG_BININDEX("blockentry %u: topic: %s\n", entrynum, topic);
				DEBUG_BININDEX("blockentry %u: title: %s\n", entrynum, title);
			}
		}
		
		if (entry.nrpairs > 0)
			createindexsitemapentry(sitemap, item, Name, entry.charindex, topic, title);
		g_free(Name);
		g_free(title);
		if (head < tail)
		{
			get_le32(dummy, head);  /* always 1 */
		}
		if (head < tail)
		{
			get_le32(dummy, head);
			DEBUG_BININDEX("blockentry %u: Zero based index (13 higher than last) : %u\n", entrynum, dummy);
		}
		entrynum++;
		UNUSED(dummy);
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

ChmSiteMap *ChmReader_GetIndexSitemap(ChmReader *reader, gboolean ForceXML)
{
	gboolean trytextual;
	BtreeHeader hdr;
	uint8_t *block;
	uint32_t i;
	CHMMemoryStream *Index;
	ChmSiteMap *sitemap;
	ChmSiteMapItem *item;
	chm_off_t indexsize;
	
	/* First Try Binary */
	if (ForceXML || (Index = ChmReader_GetObject(reader, "/$WWKeywordLinks/BTree")) == NULL)
	{
		return ChmReader_GetIndexSitemapXML(reader);
	}
	
	if (!ChmReader_CheckCommonStreams(reader))
	{
		CHMStream_close(Index);
		return ChmReader_GetIndexSitemapXML(reader);
	}
	
	sitemap = ChmSiteMap_Create(stIndex);
	item = NULL;
	
	trytextual = TRUE;
	hdr.lastlistblock = 0;
	
	indexsize = CHMStream_Size(Index);
	if (indexsize >= SIZEOF_BTREEHEADER &&
		LoadBtreeHeader(Index, &hdr) &&
		hdr.lastlistblock != 0xffffffff &&
		hdr.blocksize >= 0x200)
	{
		block = g_new(uint8_t, hdr.blocksize);
		
		if (block != NULL)
		{
			for (i = 0; i <= hdr.lastlistblock; i++)
			{
				if (CHMStream_read(Index, block, hdr.blocksize) == FALSE)
					break;
				parselistingblock(reader, sitemap, &item, block, hdr.blocksize);
			}
			g_free(block);
		}
		trytextual = FALSE;
	}

	CHMStream_close(Index);
	if (trytextual)
	{
		ChmSiteMap_Destroy(sitemap);
		sitemap = ChmReader_GetIndexSitemapXML(reader);
	}

	return sitemap;
}

/*** ---------------------------------------------------------------------- ***/

static ChmSiteMap *ChmReader_GetTOCSitemapXML(ChmReader *reader)
{
	ChmSiteMap *sitemap = NULL;
	CHMMemoryStream *TOC;
	const char *o;
	char *freeme = NULL;

	if (reader->system != NULL && reader->system->toc_file.c != NULL)
	{
		o = reader->system->toc_file.c;
	} else if (reader->system != NULL && reader->system->chm_filename.c)
	{
		freeme = g_strconcat(reader->system->chm_filename.c, ".hhc", NULL);
		o = freeme;
	} else if ((o = ChmStream_GetFilename(reader->itsf->Stream)) != NULL)
	{
		freeme = changefileext(chm_basename(o), ".hhc");
		o = freeme;
	}
	TOC = ChmReader_GetObject(reader, o);
	if (TOC != NULL)
	{
		sitemap = ChmSiteMap_Create(stTOC);
		ChmSiteMap_LoadFromStream(sitemap, TOC);
		CHMStream_close(TOC);
	}
	g_free(freeme);
	return sitemap;
}

/*** ---------------------------------------------------------------------- ***/

static uint32_t AddTOCItem(ChmReader *reader, CHMMemoryStream *TOC, uint32_t itemoffset, ChmSiteMapItems *items)
{
	uint32_t props;
	ChmSiteMapItem *item;
	uint32_t NextEntry;
	uint32_t TopicsIndex;
	char *title;
	uint32_t result;
	
	if (CHMStream_seek(TOC, itemoffset + 4) == FALSE)
		return 0;
	item = ChmSiteMapItems_NewItem(items);
	props = chmstream_read_le32(TOC);
	TopicsIndex = chmstream_read_le32(TOC);
	if (!(props & TOC_ENTRY_HAS_LOCAL))
	{
		item->name = ChmReader_ReadStringsEntry(reader, TopicsIndex);
	} else
	{
		item->local = g_strdup(ChmReader_LookupTopicByID(reader, TopicsIndex, &title));
		item->name = title;
	}
	chmstream_read_le32(TOC); /* skip offset to parent book */
	result = chmstream_read_le32(TOC);
	
	if (props & TOC_ENTRY_HAS_CHILDREN)
	{
		NextEntry = chmstream_read_le32(TOC);
		do
			NextEntry = AddTOCItem(reader, TOC, NextEntry, item->children);
		while (NextEntry != 0);
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

ChmSiteMap *ChmReader_GetTOCSitemap(ChmReader *reader, gboolean ForceXML)
{
	CHMMemoryStream *TOC;
	ChmSiteMap *sitemap = NULL;
	uint32_t TOPICSOffset;
	uint32_t EntriesOffset;
	uint32_t EntryCount;
	uint32_t EntryInfoOffset;
	uint32_t NextItem;

	/* First Try Binary */
	if (ForceXML || (TOC = ChmReader_GetObject(reader, "/#TOCIDX")) == NULL)
	{
		/* Second Try text toc */
		return ChmReader_GetTOCSitemapXML(reader);
	}
	
	/*
	 * TOPICS URLSTR URLTBL must all exist to read binary toc
	 * if they don't then try text file
	 */
	if (!ChmReader_CheckCommonStreams(reader))
	{
		CHMStream_close(TOC);
		return ChmReader_GetTOCSitemapXML(reader);
	}
	
	/* Binary Toc Exists */
	sitemap = ChmSiteMap_Create(stTOC);

	EntryInfoOffset = chmstream_read_le32(TOC);
	EntriesOffset = chmstream_read_le32(TOC);
	EntryCount = chmstream_read_le32(TOC);
	TOPICSOffset = chmstream_read_le32(TOC);

	if (EntryCount != 0)
	{
		NextItem = EntryInfoOffset;
		do
			NextItem = AddTOCItem(reader, TOC, NextItem, sitemap->items);
		while (NextItem != 0);
	}
	
	CHMStream_close(TOC);
	return sitemap;
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
	ContextList_Destroy(reader->contextList);
	g_slist_free_full(reader->WindowsList, (GDestroyNotify)CHMWindow_Destroy);
	ChmSystem_Destroy(reader->system);
	ChmSearchReader_Destroy(reader->SearchReader);
	if (reader->TOPICSStream != NO_SUCH_STREAM)
	{
		CHMStream_TakeOwner(reader->TOPICSStream, FALSE);
		CHMStream_close(reader->TOPICSStream);
	}
	if (reader->URLSTRStream != NO_SUCH_STREAM)
	{
		CHMStream_TakeOwner(reader->URLSTRStream, FALSE);
		CHMStream_close(reader->URLSTRStream);
	}
	if (reader->URLTBLStream != NO_SUCH_STREAM)
	{
		CHMStream_TakeOwner(reader->URLTBLStream, FALSE);
		CHMStream_close(reader->URLTBLStream);
	}
	if (reader->StringsStream != NO_SUCH_STREAM)
	{
		CHMStream_TakeOwner(reader->StringsStream, FALSE);
		CHMStream_close(reader->StringsStream);
	}
	ITSFReader_Destroy(reader->itsf);
	g_free(reader);
}
