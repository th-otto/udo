#include "chmtools.h"
#include "chmreader.h"
#include "lzx.h"

#define isSig(s, str) \
	((((unsigned char)s.sig[0] << 24) | ((unsigned char)s.sig[1] << 16) | ((unsigned char)s.sig[2] << 8) | ((unsigned char)s.sig[3])) == \
	 (((unsigned char)str[0] << 24) | ((unsigned char)str[1] << 16) | ((unsigned char)str[2] << 8) | ((unsigned char)str[3])))

#define NO_SUCH_STREAM ((ChmMemoryStream *)-1)

struct _ITSFReader {
	ChmStream *Stream;
	gboolean FreeStreamOnDestroy;
	ITSFHeader ITSFheader;
	ITSFHeaderSuffix HeaderSuffix;
	ITSPHeader DirectoryHeader;
	chm_off_t DirectoryHeaderPos;
	chm_off_t DirectoryHeaderLength;
	chm_off_t DirectoryEntriesStartPos;
	PMGLListChunkEntry CachedEntry; /* contains the last entry found by ObjectExists */
	uint32_t DirectoryEntriesCount;
	chm_error ChmLastError;
};

typedef struct _convstr {
	uint32_t pos;
	char *s;
} convstr;

struct _ChmReader {
	ITSFReader itsf;
	ContextList *contextList;
	ChmMemoryStream *TOPICSStream;
	ChmMemoryStream *URLSTRStream;
	ChmMemoryStream *URLTBLStream;
	ChmMemoryStream *StringsStream;
	convstr *strings_converted;
	size_t convstrings_len;
	size_t convstrings_size;
	GSList *WindowsList; /* of ChmWindow * */
	ChmSystem *system;
};

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

static gboolean read_guid(ChmStream *stream, GUID *guid)
{
	guid->Data1 = chmstream_read_le32(stream);
	guid->Data2 = chmstream_read_le16(stream);
	guid->Data3 = chmstream_read_le16(stream);
	guid->Data4[0] = ChmStream_fgetc(stream);
	guid->Data4[1] = ChmStream_fgetc(stream);
	guid->Data4[2] = ChmStream_fgetc(stream);
	guid->Data4[3] = ChmStream_fgetc(stream);
	guid->Data4[4] = ChmStream_fgetc(stream);
	guid->Data4[5] = ChmStream_fgetc(stream);
	guid->Data4[6] = ChmStream_fgetc(stream);
	guid->Data4[7] = ChmStream_fgetc(stream);
	return TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean ITSFReader_ReadHeaderEntries(ITSFReader *reader)
{
	ChmStream *stream = reader->Stream;
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
	if (ChmStream_Seek(stream, HeaderEntries[1].PosFromZero) == FALSE)
		return FALSE;
	
	/*
	 * read directory header
	 */
	reader->DirectoryHeader.ITSPsig.sig[0] = ChmStream_fgetc(stream);
	reader->DirectoryHeader.ITSPsig.sig[1] = ChmStream_fgetc(stream);
	reader->DirectoryHeader.ITSPsig.sig[2] = ChmStream_fgetc(stream);
	reader->DirectoryHeader.ITSPsig.sig[3] = ChmStream_fgetc(stream);
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

	reader->DirectoryEntriesStartPos = ChmStream_Tell(stream);
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
	CHM_DEBUG_LOG(1, "LanguageID              = $%04x %s\n", (unsigned int)reader->DirectoryHeader.LanguageID, fixnull(get_lcid_string(reader->DirectoryHeader.LanguageID)));
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
	ChmStream *stream = reader->Stream;
	
	if (ChmStream_Seek(stream, 0) == FALSE)
		return FALSE;
	reader->ITSFheader.ITSFsig.sig[0] = ChmStream_fgetc(stream);
	reader->ITSFheader.ITSFsig.sig[1] = ChmStream_fgetc(stream);
	reader->ITSFheader.ITSFsig.sig[2] = ChmStream_fgetc(stream);
	reader->ITSFheader.ITSFsig.sig[3] = ChmStream_fgetc(stream);
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
	CHM_DEBUG_LOG(1, "LanguageID    = $%04x %s\n", (unsigned int)reader->ITSFheader.LanguageID, fixnull(get_lcid_string(reader->ITSFheader.LanguageID)));
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

static gboolean ITSFReader_LookupPMGLchunk(ChmMemoryStream *stream, PMGLListChunk *PMGLChunk)
{
	/* signature already read by GetChunkType */
	PMGLChunk->UnusedSpace = chmstream_read_le32(stream);
	PMGLChunk->Unknown1 = chmstream_read_le32(stream);
	PMGLChunk->PreviousChunkIndex = chmstream_read_le32(stream);
	PMGLChunk->NextChunkIndex = chmstream_read_le32(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_LookupPMGIchunk(ChmMemoryStream *stream, PMGIIndexChunk *PMGIChunk)
{
	/* signature already read by GetChunkType */
	PMGIChunk->UnusedSpace = chmstream_read_le32(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_LookupAOLIchunk(ChmMemoryStream *stream, AOLIIndexChunk *chunk)
{
	/* signature already read by GetChunkType */
	chunk->QuickRefSize = chmstream_read_le32(stream);
	chunk->ChunkIndex = chmstream_read_le64(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_LookupAOLLchunk(ChmMemoryStream *stream, AOLLListChunk *chunk)
{
	/* signature already read by GetChunkType */
	chunk->QuickRefSize = chmstream_read_le32(stream);
	chunk->ChunkIndex = chmstream_read_le64(stream);
	chunk->PreviousChunkIndex = chmstream_read_le64(stream);
	chunk->NextChunkIndex = chmstream_read_le64(stream);
	chunk->FirstEntryIndex = chmstream_read_le64(stream);
	chunk->unknown0 = chmstream_read_le32(stream);
	chunk->unknown1 = chmstream_read_le32(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFReader_ReadPMGLchunkEntryFromStream(ChmMemoryStream *stream, PMGLListChunkEntry *PMGLEntry)
{
	char *buf;

	PMGLEntry->NameLength = GetCompressedInteger(stream);

	/* failed GetCompressedInteger sanity check */
	if (PMGLEntry->NameLength == 0)
		return FALSE;
	buf = g_new(char, PMGLEntry->NameLength + 1);
	if (buf == NULL)
		return FALSE;
	if (ChmStream_Read(stream, buf, PMGLEntry->NameLength) != PMGLEntry->NameLength)
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

static gboolean ITSFReader_ReadPMGIchunkEntryFromStream(ChmMemoryStream *stream, PMGIIndexChunkEntry *PMGIEntry)
{
	char *buf;
	
	PMGIEntry->NameLength = GetCompressedInteger(stream);
	if (PMGIEntry->NameLength == 0)
		return FALSE;
	buf = g_new(char, PMGIEntry->NameLength + 1);
	if (buf == NULL)
		return FALSE;
	if (ChmStream_Read(stream, buf, PMGIEntry->NameLength) != PMGIEntry->NameLength)
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

static gboolean ITSFReader_GetDirectoryChunk(ITSFReader *reader, uint32_t Index, ChmMemoryStream *mem)
{
	ChmStream *src;
	
	src = reader->Stream;
	if (ChmStream_Seek(src, reader->DirectoryEntriesStartPos + (reader->DirectoryHeader.ChunkSize * Index)) == FALSE)
		return FALSE;
	if (ChmStream_Seek(mem, 0) == FALSE ||
		ChmStream_CopyFrom(mem, src, reader->DirectoryHeader.ChunkSize) == FALSE ||
		ChmStream_Seek(mem, 0) == FALSE)
	{
		return FALSE;
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static DirChunkType ChunkType(ChmStream *stream, PMGLListChunk *PMGLChunk)
{
	PMGLChunk->sig.sig[0] = ChmStream_fgetc(stream);
	PMGLChunk->sig.sig[1] = ChmStream_fgetc(stream);
	PMGLChunk->sig.sig[2] = ChmStream_fgetc(stream);
	PMGLChunk->sig.sig[3] = ChmStream_fgetc(stream);
	if (isSig(PMGLChunk->sig, "PMGL"))
		return ctPMGL;
	if (isSig(PMGLChunk->sig, "PMGI"))
		return ctPMGI;
	if (isSig(PMGLChunk->sig, "AOLL"))
		return ctAOLL;
	if (isSig(PMGLChunk->sig, "AOLI"))
		return ctAOLI;
	return ctUnknown;
}

/*** ---------------------------------------------------------------------- ***/

#if 0 /* not used */
static DirChunkType ITSFReader_GetChunkType(ITSFReader *reader, ChmMemoryStream *stream, uint32_t ChunkIndex, PMGLListChunk *PMGLChunk)
{
	if (ChmStream_Seek(stream, reader->DirectoryEntriesStartPos + (reader->DirectoryHeader.ChunkSize * ChunkIndex)) == FALSE)
		return ctUnknown;
	return ChunkType(stream, PMGLChunk);
}
#endif

/*** ---------------------------------------------------------------------- ***/

gboolean ITSFReader_GetCompleteFileList(ITSFReader *reader, void *obj, FileEntryForEach ForEach)
{
	ChmMemoryStream *ChunkStream;
	uint32_t i;
	PMGLListChunkEntry Entry;
	PMGLListChunk PMGLChunk;
	AOLLListChunk AOLLChunk;
	uint32_t CutOffPoint;
	PMGIIndexChunk PMGIChunk;
	AOLIIndexChunk AOLIChunk;
	PMGIIndexChunkEntry PMGIEntry;
	gboolean result = TRUE;
	
	if (reader == NULL || ForEach == NULL)
		return FALSE;
	ChunkStream = ChmStream_CreateMem(reader->DirectoryHeader.ChunkSize, "<Chunks>");
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
			while (ChmStream_Tell(ChunkStream) < CutOffPoint)
			{
				ChmFileInfo info;
				char *namecopy;
				
				Entry.Name = NULL;
				if (!ITSFReader_ReadPMGLchunkEntryFromStream(ChunkStream, &Entry))
					break;
				if (empty(Entry.Name) || ChmStream_Tell(ChunkStream) > CutOffPoint)
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
			PMGIChunk.sig = PMGLChunk.sig;
			if (!ITSFReader_LookupPMGIchunk(ChunkStream, &PMGIChunk))
			{
				result = FALSE;
				break;
			}
			CHM_DEBUG_LOG(2, "PMGI %u: Unused %u\n", i, PMGIChunk.UnusedSpace);
			CutOffPoint = reader->DirectoryHeader.ChunkSize - PMGIChunk.UnusedSpace - 10;
			while (ChmStream_Tell(ChunkStream) < CutOffPoint)
			{
				PMGIEntry.Name = NULL;
				if (!ITSFReader_ReadPMGIchunkEntryFromStream(ChunkStream, &PMGIEntry))
					break;
				CHM_DEBUG_LOG(3, "  %u %s\n", PMGIEntry.ListingChunk, PMGIEntry.Name);
				g_free(PMGIEntry.Name);
			}
			break;
		case ctAOLL:
			AOLLChunk.sig = PMGLChunk.sig;
			if (!ITSFReader_LookupAOLLchunk(ChunkStream, &AOLLChunk))
			{
				result = FALSE;
				break;
			}
			break;
		case ctAOLI:
			AOLIChunk.sig = PMGLChunk.sig;
			if (!ITSFReader_LookupAOLIchunk(ChunkStream, &AOLIChunk))
			{
				result = FALSE;
				break;
			}
			break;
		case ctUnknown:
		default:
			CHM_DEBUG_LOG(0, "%u: unknown chunktype '%c%c%c%c'\n", i,
				PMGLChunk.sig.sig[0],
				PMGLChunk.sig.sig[1],
				PMGLChunk.sig.sig[2],
				PMGLChunk.sig.sig[3]);
			break;
		}
	}
	
	ChmStream_Close(ChunkStream);
	
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static uint16_t *ReadQuickRefSection(ITSFReader *reader, ChmMemoryStream *ChunkStream)
{
	chm_off_t OldPosn;
	chm_off_t Posn;
	unsigned int i;
	unsigned int num_entries;
	unsigned int qr_density;
	unsigned int qr_entries;
	uint16_t *QuickRefIndex;
	
	OldPosn = ChmStream_Tell(ChunkStream);
	Posn = reader->DirectoryHeader.ChunkSize - sizeof(uint16_t);
	if (ChmStream_Seek(ChunkStream, Posn) == FALSE)
		return NULL;
	
	num_entries = chmstream_read_le16(ChunkStream);
	qr_density = (1 + (1 << reader->DirectoryHeader.Density));
	qr_entries = (num_entries + qr_density - 1) / qr_density;
	if (Posn < (qr_entries * 2))
		return NULL;
	Posn -= qr_entries * 2;
	if (ChmStream_Seek(ChunkStream, Posn) == FALSE)
		return NULL;
	QuickRefIndex = g_new(uint16_t, qr_entries);
	for (i = qr_entries; i > 0; )
	{
		--i;
		QuickRefIndex[i] = chmstream_read_le16(ChunkStream);
	}
	if (!ChmStream_Seek(ChunkStream, OldPosn))
		{}
	return QuickRefIndex;
}

/*** ---------------------------------------------------------------------- ***/

static char *ReadString(ChmStream *stream)
{
	uint32_t NameLength;
	char *result;
	
	NameLength = GetCompressedInteger(stream);
	result = g_new(char, NameLength + 1);
	if (NameLength > 0)
	{
		if (ChmStream_Read(stream, result, NameLength) != NameLength)
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
	ChmMemoryStream *ChunkStream;
	uint16_t *QuickRefIndex;
	PMGLListChunk PMGLChunk;
	PMGIIndexChunk PMGIChunk;
	PMGLListChunkEntry Entry;
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
	
	ChunkStream = ChmStream_CreateMem(reader->DirectoryHeader.ChunkSize, "<Chunks>");
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
			PMGIChunk.sig = PMGLChunk.sig;
			if (!ITSFReader_LookupPMGIchunk(ChunkStream, &PMGIChunk))
			{
				NextIndex = -1;
				break;
			}
			i = 0;
			CutOffPoint = reader->DirectoryHeader.ChunkSize - PMGIChunk.UnusedSpace;
			while (ChmStream_Tell(ChunkStream) <= CutOffPoint)
			{
				EntryName = ReadString(ChunkStream);
				if (EntryName == NULL)
					break;
				if (ChmStream_Tell(ChunkStream) >= CutOffPoint)
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
			while (ChmStream_Tell(ChunkStream) <= CutOffPoint)
			{
				/* we consume the entry by reading it */
				Entry.Name = NULL;
				if (!ITSFReader_ReadPMGLchunkEntryFromStream(ChunkStream, &Entry))
					break;
				if (empty(Entry.Name) || ChmStream_Tell(ChunkStream) > CutOffPoint)
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
				PMGLChunk.sig.sig[0],
				PMGLChunk.sig.sig[1],
				PMGLChunk.sig.sig[2],
				PMGLChunk.sig.sig[3]);
			NextIndex = -1;
			break;
		}
		
		g_free(QuickRefIndex);
	}
	
	ChmStream_Close(ChunkStream);
	
	g_free(freeme);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

WStringList *ITSFReader_GetSections(ITSFReader *reader)
{
	ChmStream *stream;
	uint16_t EntryCount;
	uint16_t X;
	uint16_t i;
	chm_wchar_t *wstring;
	uint16_t StrLength;
	WStringList *sections;
	
	sections = NULL;
	stream = ITSFReader_GetObject(reader, "::DataSpace/NameList");

	if (stream == NULL)
		return sections;

	if (ChmStream_Seek(stream, 2) == FALSE)
		return sections;
	
	EntryCount = chmstream_read_le16(stream);
	for (X = 0; X < EntryCount; X++)
	{
		StrLength = chmstream_read_le16(stream);
		/* the strings are stored null terminated */
		StrLength++;
		wstring = g_new(chm_wchar_t, StrLength);
		for (i = 0; i < StrLength; i++)
		{
			wstring[i] = chmstream_read_le16(stream);
		}
		wstring[StrLength - 1] = 0;
		sections = g_slist_append(sections, wstring);
	}
	ChmStream_Close(stream);
	return sections;
}

/*** ---------------------------------------------------------------------- ***/

static uint64_t ITSFReader_FindBlocksFromUnCompressedAddr(
	ITSFReader *reader,
	const PMGLListChunkEntry *ResetTableEntry,
	uint64_t *CompressedSize,
	uint64_t *UnCompressedSize,
	LZXResetTableArr *LZXResetTable)
{
	uint32_t BlockCount;
	uint32_t i;
	uint64_t blocksize;
	ChmStream *stream = reader->Stream;
	uint32_t entrysize;
	uint32_t headersize;
	LZXResetTableArr table;
	
	if (ChmStream_Seek(stream, reader->HeaderSuffix.Offset + ResetTableEntry->ContentOffset) == FALSE)
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
		if (ChmStream_Seek(stream, reader->HeaderSuffix.Offset + ResetTableEntry->ContentOffset + headersize) == FALSE)
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

static ChmMemoryStream *ITSFReader_GetBlockFromSection(
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
	PMGLListChunkEntry ResetTableEntry;
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
	ChmStream *result = NULL;
	ChmStream *stream = reader->Stream;
	
#define ReadBlock() \
	if (ReadCount > inbuf_size) \
	{ \
		if ((InBuf = g_renew(uint8_t, InBuf, ReadCount)) == NULL) \
			goto fail; \
		inbuf_size = ReadCount; \
	} \
	if (ChmStream_Read(stream, InBuf, ReadCount) != ReadCount) \
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
			if (ChmStream_Seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset + StartPos) == FALSE)
				goto fail;
			result = ChmStream_CreateMem(BlockLength, "<Block>");
			if (ChmStream_CopyFrom(result, stream, BlockLength) == FALSE)
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
		if (ChmStream_Seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset) == FALSE)
			return NULL;
		CompressionVersion = chmstream_read_le32(stream);
		CHM_DEBUG_LOG(1, "LZXHeaderLength = %u\n", CompressionVersion);
		Sig.sig[0] = ChmStream_fgetc(stream);
		Sig.sig[1] = ChmStream_fgetc(stream);
		Sig.sig[2] = ChmStream_fgetc(stream);
		Sig.sig[3] = ChmStream_fgetc(stream);
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
		
		result = ChmStream_CreateMem(BlockLength, "<Block>");
		inbuf_size = BlockSize;
		InBuf = g_new(uint8_t, inbuf_size);
		OutBuf = g_new(uint8_t, BlockSize);
		
		/* if FirstBlock is odd (1,3,5,7 etc) we have to read the even block before it first. */
		if ((FirstBlock & 1) != 0)
		{
			if (ChmStream_Seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset + ResetTable[FirstBlock-1]) == FALSE)
				goto fail;
			ReadCount = ResetTable[FirstBlock] - ResetTable[FirstBlock-1];
			BlockWriteLength = BlockSize;
			ReadBlock();
			ResultCode = LZXdecompress(lzx, InBuf, OutBuf, ReadCount, BlockWriteLength);
		}
		/* now start the actual decompression loop */
		for (X = FirstBlock; X <= LastBlock; X++)
		{
			if (ChmStream_Seek(stream, reader->HeaderSuffix.Offset + reader->CachedEntry.ContentOffset + ResetTable[X]) == FALSE)
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
				if (ChmStream_Write(result, &OutBuf[WriteStart], WriteCount) != WriteCount)
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
	ChmStream_Close(result);
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

ChmMemoryStream *ITSFReader_GetObject(ITSFReader *reader, const char *Name)
{
	WStringList *SectionNames;
	PMGLListChunkEntry Entry;
	char *SectionName;
	ChmMemoryStream *stream;
	stream = NULL;

	if (ITSFReader_ObjectExists(reader, Name) == FALSE)
	{
		return NULL;
	}

	Entry = reader->CachedEntry;
	if (Entry.ContentSection == 0)
	{
		stream = ChmStream_CreateMem(Entry.DecompressedLength, Name);
		if (ChmStream_Seek(reader->Stream, reader->HeaderSuffix.Offset + Entry.ContentOffset) == FALSE ||
			ChmStream_CopyFrom(stream, reader->Stream, Entry.DecompressedLength) == FALSE)
		{
			ChmStream_Close(stream);
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
		if (ChmStream_Seek(stream, 0) == FALSE)
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

void ITSFReader_SetError(ITSFReader *reader, chm_error err)
{
	if (reader == NULL)
		return;
	reader->ChmLastError = err;
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFReader_Init(ITSFReader *reader, ChmStream *stream, gboolean FreeStreamOnDestroy)
{
	reader->Stream = stream;
	reader->FreeStreamOnDestroy = FreeStreamOnDestroy;
	if (!ITSFReader_ReadHeader(reader) ||
		!ITSFReader_IsValidFile(reader))
		{}
}

/*** ---------------------------------------------------------------------- ***/

LCID ITSFReader_GetLCID(ITSFReader *reader)
{
	if (reader == NULL)
		return 0;
	return reader->ITSFheader.LanguageID;
}

/*** ---------------------------------------------------------------------- ***/

ITSFReader *ITSFReader_Create(ChmStream *stream, gboolean FreeStreamOnDestroy)
{
	ITSFReader *reader;
	
	if (stream == NULL)
		return NULL;
	reader = g_new0(ITSFReader, 1);
	if (reader == NULL)
		return NULL;
	ITSFReader_Init(reader, stream, FreeStreamOnDestroy);
	return reader;
}

/*** ---------------------------------------------------------------------- ***/

void ITSFReader_Destroy(ITSFReader *reader)
{
	if (reader == NULL)
		return;
	if (reader->FreeStreamOnDestroy)
		ChmStream_Close(reader->Stream);
	g_freep(&reader->CachedEntry.Name);
	g_free(reader);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ContextList_AddContext(ContextList **list, HelpContext context, const char *url)
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
	/* the url is from the strings table and must not be freed */
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
	return ITSFReader_GetError(&reader->itsf);
}

/*** ---------------------------------------------------------------------- ***/

void ChmReader_SetError(ChmReader *reader, chm_error err)
{
	if (reader == NULL)
		return;
	return ITSFReader_SetError(&reader->itsf, err);
}

/*** ---------------------------------------------------------------------- ***/

const char *ChmReader_ReadStringsEntry(ChmReader *reader, uint32_t position, gboolean convslash)
{
	size_t size;
	const char *base;
	
	if (reader->StringsStream == NULL)
	{
		reader->StringsStream = ITSFReader_GetObject(&reader->itsf, "/#STRINGS");
		if (reader->StringsStream == NULL)
			reader->StringsStream = NO_SUCH_STREAM;
		else
			ChmStream_TakeOwner(reader->StringsStream, TRUE);
	}
	if (reader->StringsStream != NO_SUCH_STREAM && (base = (const char *)ChmStream_Memptr(reader->StringsStream)) != NULL)
	{
		uint32_t l, r, m;
		gboolean found;
		
		size = ChmStream_Size(reader->StringsStream);
		if (position >= size)
		{
			/*
			 * quite often an offset of -1 is used
			 */
			if (position == 0xffffffff)
				return "";
			CHM_DEBUG_LOG(0, "string pos %u exceeds size %u", position, (unsigned int) size);
			return "<out-of-range>";
		}
		/*
		 * look up converted string
		 */
		l = 0;
		r = reader->convstrings_len;
		found = FALSE;
		while (l < r)
		{
			m = (l + r) >> 1;				/* == ((a + b) / 2) */
			if (position == reader->strings_converted[m].pos)
			{
				l = m;
				found = TRUE;
				break;
			}
			if (position < reader->strings_converted[m].pos)
				r = m;
			else
				l = m + 1;
		}
		if (!found)
		{
			size_t len;
			char *s;
			
			if (reader->convstrings_len >= reader->convstrings_size)
			{
				size_t newstring_size = reader->convstrings_size + 10;
				convstr *newstr = g_renew(convstr, reader->strings_converted, newstring_size);
				if (newstr == NULL)
					return "";
				reader->strings_converted = newstr;
				reader->convstrings_size = newstring_size;
			}
			for (r = reader->convstrings_len; r != l; )
			{
				--r;
				reader->strings_converted[r + 1] = reader->strings_converted[r];
			}
			reader->convstrings_len++;
			reader->strings_converted[l].pos = position;

			base += position;
			len = 0;
			/* be paranoid... */
			while (position < size && base[len] != '\0')
			{
				len++;
				position++;
			}
			if (!g_utf8_validate(base, len, NULL))
			{
				s = chm_conv_to_utf8(base, len);
			} else
			{
				s = g_strndup(base, len);
			}
			if (convslash)
				convexternalslash(s);
			reader->strings_converted[l].s = s;
		}
		
		return reader->strings_converted[l].s;
	}
	return position == 0 ? "" : "<no #STRINGS>";
}

/*** ---------------------------------------------------------------------- ***/

static const char *ChmReader_ReadStringsEntryFromStream(ChmReader *reader, ChmStream *strm, gboolean convslash)
{
	uint32_t pos = chmstream_read_le32(strm);
	return ChmReader_ReadStringsEntry(reader, pos, convslash);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmReader_ReadWindows(ChmReader *reader)
{
	ChmMemoryStream *windows;
	uint32_t EntryCount;
	uint32_t EntrySize;
	uint32_t X;
	chm_off_t size;
	gboolean result = FALSE;
	ChmWindow *win;
	int i;
	
	if (reader->WindowsList != NULL)
		return TRUE;
	windows = ITSFReader_GetObject(&reader->itsf, "/#WINDOWS");
	if (windows == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #WINDOWS\n\n");
		return FALSE;
	}
	size = ChmStream_Size(windows);
	if (size > 8)
	{
		EntryCount = chmstream_read_le32(windows);
		EntrySize = chmstream_read_le32(windows);
		
		if (EntryCount > 0 && EntrySize >= CHM_WIN_MINSIZE && (EntryCount * EntrySize + 8) <= size)
		{
			result = TRUE;
			for (X = 0; X < EntryCount; X++)
			{
				if (ChmStream_Seek(windows, X * EntrySize + 8) == FALSE)
				{
					CHM_DEBUG_LOG(0, "/#WINDOWS file corrupted\n");
					continue;
				}
				win = ChmWindow_Create();
				if (win == NULL)
					break;
				win->version = chmstream_read_le32(windows);
				win->unicode_strings = chmstream_read_le32(windows);
				win->window_name.c = ChmReader_ReadStringsEntryFromStream(reader, windows, FALSE);
				win->flags = chmstream_read_le32(windows);
				win->win_properties = chmstream_read_le32(windows);
				win->caption.c = ChmReader_ReadStringsEntryFromStream(reader, windows, FALSE);
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
				win->toc_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows, TRUE);
				win->index_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows, TRUE);
				win->default_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows, TRUE);
				win->home_button_file.c = ChmReader_ReadStringsEntryFromStream(reader, windows, TRUE);
				win->buttons = chmstream_read_le32(windows);
				win->not_expanded = chmstream_read_le32(windows);
				win->navtype = chmstream_read_le32(windows);
				win->tabpos = chmstream_read_le32(windows);
				win->wm_notify_id = chmstream_read_le32(windows);
				for (i = 0; i <= HH_MAX_TABS; i++)
					win->taborder[i] = ChmStream_fgetc(windows);
				win->history = chmstream_read_le32(windows);
				win->jump1_text.c = ChmReader_ReadStringsEntryFromStream(reader, windows, FALSE);
				win->jump2_text.c = ChmReader_ReadStringsEntryFromStream(reader, windows, FALSE);
				win->jump1_url.c = ChmReader_ReadStringsEntryFromStream(reader, windows, TRUE);
				win->jump2_url.c = ChmReader_ReadStringsEntryFromStream(reader, windows, TRUE);
				win->minsize.left = (int)chmstream_read_le32(windows);
				win->minsize.top = (int)chmstream_read_le32(windows);
				win->minsize.right = (int)chmstream_read_le32(windows);
				win->minsize.bottom = (int)chmstream_read_le32(windows);
				
				reader->WindowsList = g_slist_append(reader->WindowsList, win);
				/*
				 * the strings are owned by the string file object
				 * and must not be freed
				 */
				win->strings_alloced = FALSE;
			}
		} else
		{
			CHM_DEBUG_LOG(0, "/#WINDOWS file corrupted\n");
		}
	} else
	{
		CHM_DEBUG_LOG(0, "/#WINDOWS file truncated\n");
	}
	ChmStream_Close(windows);
	
	return result;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void read_idxhdr(ChmReader *reader, ChmIdxhdr *idx, ChmMemoryStream *stream, unsigned int size)
{
	unsigned int i;
	
	idx->sig.sig[0] = ChmStream_fgetc(stream);
	idx->sig.sig[1] = ChmStream_fgetc(stream);
	idx->sig.sig[2] = ChmStream_fgetc(stream);
	idx->sig.sig[3] = ChmStream_fgetc(stream);
	idx->timestamp = chmstream_read_le32(stream);
	idx->unknown1 = chmstream_read_le32(stream);
	idx->num_topics = chmstream_read_le32(stream);
	idx->unknown2 = chmstream_read_le32(stream);
	idx->imagelist.c = ChmReader_ReadStringsEntryFromStream(reader, stream, FALSE);
	idx->unknown3 = chmstream_read_le32(stream);
	idx->imagetype_is_folder = chmstream_read_le32(stream);
	idx->background = chmstream_read_le32(stream);
	idx->foreground = chmstream_read_le32(stream);
	idx->font.c = ChmReader_ReadStringsEntryFromStream(reader, stream, FALSE);
	idx->window_styles = chmstream_read_le32(stream);
	idx->exwindow_styles = chmstream_read_le32(stream);
	idx->unknown4 = chmstream_read_le32(stream);
	idx->framename.c = ChmReader_ReadStringsEntryFromStream(reader, stream, FALSE);
	idx->windowname.c = ChmReader_ReadStringsEntryFromStream(reader, stream, FALSE);
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
		idx->merge_files[i].c = ChmReader_ReadStringsEntryFromStream(reader, stream, TRUE);
}

/*** ---------------------------------------------------------------------- ***/

ChmIdxhdr *ChmReader_GetIdxhdr(ChmReader *reader)
{
	ChmIdxhdr *idx;
	ChmMemoryStream *idxhdr;
	chm_off_t size;
	
	if (reader == NULL)
		return NULL;
	idxhdr = ITSFReader_GetObject(&reader->itsf, "/#IDXHDR");
	if (idxhdr == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #IDXHDR\n\n");
		return NULL;
	}
	size = ChmStream_Size(idxhdr);
	if (size < CHM_IDXHDR_MINSIZE)
	{
		CHM_DEBUG_LOG(0, "/#IDXHDR has only %u bytes\n", (unsigned int)size);
		ChmStream_Close(idxhdr);
		return NULL;
	}
	idx = ChmIdxhdr_Create();
	if (idx)
		read_idxhdr(reader, idx, idxhdr, size);
	ChmStream_Close(idxhdr);
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
static char *read_sys_string(ChmMemoryStream *system, unsigned int len)
{
	char *tmp;
	
	if (len == 0)
		return NULL;
	tmp = g_new(char, len + 1);
	if (tmp == NULL)
		return NULL;
	if (ChmStream_Read(system, tmp, len) != len)
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
	ChmMemoryStream *system;
	uint16_t code;
	uint16_t EntrySize;
	chm_off_t pos, size;
	gboolean result = FALSE;
	ChmSystem *sys;
	
	if (reader->system != NULL)
		return TRUE;
	system = ITSFReader_GetObject(&reader->itsf, "/#SYSTEM");
	if (system == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #SYSTEM\n\n");
		return FALSE;
	}
	size = ChmStream_Size(system);
	if (size > 4)
	{
		sys = ChmSystem_Create();
		if (sys != NULL)
		{
			reader->system = sys;
			sys->version = chmstream_read_le32(system);
			pos = ChmStream_Tell(system);
			
			result = TRUE;
			while ((pos + 4) < size)
			{
				code = chmstream_read_le16(system);
				EntrySize = chmstream_read_le16(system);
				
				switch (code)
				{
				case Contents_file_CODE:
					sys->toc_file.s = read_sys_string(system, EntrySize);
					break;
				case Index_file_CODE:
					sys->index_file.s = read_sys_string(system, EntrySize);
					break;
				case Default_topic_CODE:
					sys->default_page.s = read_sys_string(system, EntrySize);
					break;
				case Title_CODE:
					sys->caption.s = read_sys_string(system, EntrySize);
					break;
				case Language_DBCS_FTS_KLinks_ALinks_FILETIME_CODE:
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
				case Default_Window_CODE:
					sys->default_window.s = read_sys_string(system, EntrySize);
					break;
				case Compiled_file_CODE:
					sys->chm_filename.s = read_sys_string(system, EntrySize);
					break;
				case Binary_Index_CODE:
					sys->binary_index_dword = chmstream_read_le32(system);
					break;
				case ABBREVIATIONS_N_EXPLANATIONS_CODE:
					if (EntrySize < 0x10)
					{
						CHM_DEBUG_LOG(0, "entry #%u in /#SYSTEM has only %u bytes\n", code, EntrySize);
					} else
					{
						sys->unknown2 = chmstream_read_le32(system);
						sys->abbrev.c = ChmReader_ReadStringsEntryFromStream(reader, system, FALSE);
						sys->unknown3 = chmstream_read_le32(system);
						sys->abbrev_explanation.c = ChmReader_ReadStringsEntryFromStream(reader, system, FALSE);
					}
					break;
				case COMPILED_BY_CODE:
					sys->chm_compiler_version.s = read_sys_string(system, EntrySize);
					break;
				case time_t_STAMP_CODE:
					sys->local_timestamp = chmstream_read_le32(system);
					break;
				case Binary_TOC_CODE:
					sys->binary_toc_dword = chmstream_read_le32(system);
					break;
				case NUM_INFORMATION_TYPES_CODE:
					sys->num_information_types = chmstream_read_le32(system);
					break;
				case IDXHDR_FILE_CODE:
					if (EntrySize < CHM_IDXHDR_MINSIZE)
					{
						CHM_DEBUG_LOG(0, "entry #%u in /#SYSTEM has only %u bytes\n", code, EntrySize);
					} else
					{
						sys->idxhdr = ChmIdxhdr_Create();
						read_idxhdr(reader, sys->idxhdr, system, EntrySize);
					}
					break;
				case Custom_tabs_CODE:
					sys->custom_tabs = chmstream_read_le32(system);
					break;
				case INFORMATION_TYPE_CHECKSUM_CODE:
					sys->info_type_checksum = chmstream_read_le32(system);
					break;
				case Default_Font_CODE:
					sys->default_font.c = ChmReader_ReadStringsEntryFromStream(reader, system, FALSE);
					break;
				default:
					CHM_DEBUG_LOG(0, "unknown entry #%u in /#SYSTEM file (size %u)\n", code, EntrySize);
					break;
				}
				pos += EntrySize + 4;
				if (ChmStream_Seek(system, pos) == FALSE)
				{
					CHM_DEBUG_LOG(0, "/#SYSTEM file corrupted\n");
					break;
				}
			}
		}
	} else
	{
		CHM_DEBUG_LOG(0, "/#SYSTEM file truncated\n");
	}
	ChmStream_Close(system);
	
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmReader_ReadContextIds(ChmReader *reader)
{
	ChmMemoryStream *IVB;
	chm_off_t size, pos;
	uint32_t ivbsize;
	uint32_t value;
	const char *str;
	
	if (reader->contextList != NULL)
		return TRUE;
	IVB = ITSFReader_GetObject(&reader->itsf, "/#IVB");
	if (IVB == NULL)
	{
		CHM_DEBUG_LOG(1, "\nno #IVB\n\n");
		return FALSE;
	}
	size = ChmStream_Size(IVB);
	if (size < 4)
	{
		ChmStream_Close(IVB);
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
		str = ChmReader_ReadStringsEntryFromStream(reader, IVB, TRUE);
		ivbsize -= 8;
		ContextList_AddContext(&reader->contextList, value, str);
	}
	ChmStream_Close(IVB);
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
		reader->TOPICSStream = ITSFReader_GetObject(&reader->itsf, "/#TOPICS");
		if (reader->TOPICSStream == NULL)
			reader->TOPICSStream = NO_SUCH_STREAM;
		else
			ChmStream_TakeOwner(reader->TOPICSStream, TRUE);
	}

	if (reader->URLSTRStream == NULL)
	{
		reader->URLSTRStream = ITSFReader_GetObject(&reader->itsf, "/#URLSTR");
		if (reader->URLSTRStream == NULL)
			reader->URLSTRStream = NO_SUCH_STREAM;
		else
			ChmStream_TakeOwner(reader->URLSTRStream, TRUE);
	}

	if (reader->URLTBLStream == NULL)
	{
		reader->URLTBLStream = ITSFReader_GetObject(&reader->itsf, "/#URLTBL");
		if (reader->URLTBLStream == NULL)
			reader->URLTBLStream = NO_SUCH_STREAM;
		else
			ChmStream_TakeOwner(reader->URLTBLStream, TRUE);
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

ChmMemoryStream *ChmReader_GetObject(ChmReader *reader, const char *Name)
{
	char *freeme = NULL;
	ChmMemoryStream *o;
	
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
		ChmReader_ReadStringsEntry(reader, 0, FALSE);
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
		o = ITSFReader_GetObject(&reader->itsf, Name);
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

	if (ChmStream_Seek(reader->URLTBLStream, APosition) == FALSE)
		return NULL;
	chmstream_read_le32(reader->URLTBLStream); /* unknown */
	chmstream_read_le32(reader->URLTBLStream); /* TOPIC index # */
	URLStrURLOffset = chmstream_read_le32(reader->URLTBLStream);
	URLStrURLSize = ChmStream_Size(reader->URLSTRStream);
	if (URLStrURLSize == 0)
		return NULL;
	if (URLStrURLOffset >= URLStrURLSize || ChmStream_Seek(reader->URLSTRStream, URLStrURLOffset) == FALSE)
		return NULL;
	chmstream_read_le32(reader->URLSTRStream);
	chmstream_read_le32(reader->URLSTRStream);
	URLStrURLOffset += 8;
	if (URLStrURLOffset < URLStrURLSize)
		return (const char *)ChmStream_Memptr(reader->URLSTRStream) + URLStrURLOffset;
	return NULL;
}

/*** ---------------------------------------------------------------------- ***/

const char *ChmReader_LookupTopicByID(ChmReader *reader, uint32_t ATopicID, const char **ATitle)
{
	uint32_t TopicURLTBLOffset;
	uint32_t TopicTitleOffset;
	size_t topic_pos;

	if (ATitle)
		*ATitle = NULL;
	if (!ChmReader_CheckCommonStreams(reader))
		return NULL;
	topic_pos = ATopicID * 16;
	if (ChmStream_Seek(reader->TOPICSStream, topic_pos))
	{
		chmstream_read_le32(reader->TOPICSStream);	/* skip TOCIDX offset */
		TopicTitleOffset = chmstream_read_le32(reader->TOPICSStream);
		TopicURLTBLOffset = chmstream_read_le32(reader->TOPICSStream);
		if (ATitle && TopicTitleOffset != 0xFFFFFFFFUL)
			*ATitle = ChmReader_ReadStringsEntry(reader, TopicTitleOffset, FALSE);
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
	ChmMemoryStream *Index;
	const char *o;
	char *freeme = NULL;
	
	if (reader->system != NULL && reader->system->index_file.c != NULL)
	{
		o = reader->system->index_file.c;
	} else if (reader->system != NULL && reader->system->chm_filename.c)
	{
		freeme = g_strconcat(reader->system->chm_filename.c, ".hhk", NULL);
		o = freeme;
	} else if ((o = ChmStream_GetFilename(reader->itsf.Stream)) != NULL)
	{
		freeme = changefileext(chm_basename(o), ".hhk");
		o = freeme;
	}
	Index = ChmReader_GetObject(reader, o);
	if (Index != NULL)
	{
		sitemap = ChmSiteMap_Create(stIndex);
		ChmSiteMap_LoadFromStream(sitemap, Index);
		ChmStream_Close(Index);
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

static gboolean LoadBtreeHeader(ChmStream *m, BtreeHeader *hdr)
{
	unsigned char buf[SIZEOF_BTREEHEADER];
	const unsigned char *p = buf;
	
	if (ChmStream_Read(m, buf, SIZEOF_BTREEHEADER) != SIZEOF_BTREEHEADER)
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
	const char *title;
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
				topic = ChmReader_LookupTopicByID(reader, nameind, &title);
				DEBUG_BININDEX("blockentry %u: topic: %s\n", entrynum, topic);
				DEBUG_BININDEX("blockentry %u: title: %s\n", entrynum, title);
			}
		}
		
		if (entry.nrpairs > 0)
			createindexsitemapentry(sitemap, item, Name, entry.charindex, topic, title);
		g_free(Name);
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
	ChmMemoryStream *Index;
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
		ChmStream_Close(Index);
		return ChmReader_GetIndexSitemapXML(reader);
	}
	
	sitemap = ChmSiteMap_Create(stIndex);
	item = NULL;
	
	trytextual = TRUE;
	hdr.lastlistblock = 0;
	
	indexsize = ChmStream_Size(Index);
	if (indexsize >= SIZEOF_BTREEHEADER &&
		LoadBtreeHeader(Index, &hdr) &&
		hdr.lastlistblock != 0xffffffff &&
		hdr.blocksize >= 0x200)
	{
		sitemap->lcid = hdr.lcid;
		sitemap->codepage = hdr.codepage;
		
		block = g_new(uint8_t, hdr.blocksize);
		
		if (block != NULL)
		{
			for (i = 0; i <= hdr.lastlistblock; i++)
			{
				if (ChmStream_Read(Index, block, hdr.blocksize) != hdr.blocksize)
					break;
				parselistingblock(reader, sitemap, &item, block, hdr.blocksize);
			}
			g_free(block);
		}
		trytextual = FALSE;
	}

	ChmStream_Close(Index);
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
	ChmMemoryStream *TOC;
	const char *o;
	char *freeme = NULL;
	const ChmSystem *sys;
	
	if ((sys = reader->system) != NULL && sys->toc_file.c != NULL)
	{
		o = sys->toc_file.c;
	} else if (sys != NULL && sys->chm_filename.c)
	{
		freeme = g_strconcat(sys->chm_filename.c, ".hhc", NULL);
		o = freeme;
	} else if ((o = ChmStream_GetFilename(reader->itsf.Stream)) != NULL)
	{
		freeme = changefileext(chm_basename(o), ".hhc");
		o = freeme;
	}
	TOC = ChmReader_GetObject(reader, o);
	if (TOC != NULL)
	{
		sitemap = ChmSiteMap_Create(stTOC);
		ChmSiteMap_LoadFromStream(sitemap, TOC);
		ChmStream_Close(TOC);
	}
	g_free(freeme);
	return sitemap;
}

/*** ---------------------------------------------------------------------- ***/

static uint32_t AddTOCItem(ChmReader *reader, ChmMemoryStream *TOC, uint32_t itemoffset, ChmSiteMapItems *items, int level)
{
	uint32_t props;
	ChmSiteMapItem *item;
	uint32_t NextEntry;
	uint32_t TopicsIndex;
	const char *title;
	uint32_t ParentPageBookInfoOffset;
	uint32_t NextPageBookOffset;
	
	if (ChmStream_Seek(TOC, itemoffset + 4) == FALSE)
		return 0;
	item = ChmSiteMapItems_NewItem(items);
	props = chmstream_read_le32(TOC);
	TopicsIndex = chmstream_read_le32(TOC);
	if (!(props & TOC_ENTRY_HAS_LOCAL))
	{
		item->name = g_strdup(ChmReader_ReadStringsEntry(reader, TopicsIndex, FALSE));
	} else
	{
		item->local = g_strdup(ChmReader_LookupTopicByID(reader, TopicsIndex, &title));
		item->name = g_strdup(title);
	}
	ParentPageBookInfoOffset = chmstream_read_le32(TOC);
	NextPageBookOffset = chmstream_read_le32(TOC);
#if 0
	fprintf(stderr, "%d: pos=%04x props=%04x TopicsIndex=%04x parent=%04x next=%04x\n", level, itemoffset, props, TopicsIndex, ParentPageBookInfoOffset, NextPageBookOffset);
#endif
	
	if (props & TOC_ENTRY_HAS_CHILDREN)
	{
		NextEntry = chmstream_read_le32(TOC);
		do
			NextEntry = AddTOCItem(reader, TOC, NextEntry, item->children, level + 1);
		while (NextEntry != 0);
	}
	UNUSED(ParentPageBookInfoOffset);
	return NextPageBookOffset;
}

/*** ---------------------------------------------------------------------- ***/

ChmSiteMap *ChmReader_GetTOCSitemap(ChmReader *reader, gboolean ForceXML)
{
	ChmMemoryStream *TOC;
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
		ChmStream_Close(TOC);
		return ChmReader_GetTOCSitemapXML(reader);
	}
	
	/* Binary Toc Exists */
	sitemap = ChmSiteMap_Create(stTOC);

	EntryInfoOffset = chmstream_read_le32(TOC);
	EntriesOffset = chmstream_read_le32(TOC);
	EntryCount = chmstream_read_le32(TOC);
	TOPICSOffset = chmstream_read_le32(TOC);
#if 0
	fprintf(stderr, "EntryInfoOffset=%04x\n", EntryInfoOffset);
	fprintf(stderr, "EntriesOffset=%04x\n", EntriesOffset);
	fprintf(stderr, "EntryCount=%04x\n", EntryCount);
	fprintf(stderr, "TOPICSOffset=%04x\n", TOPICSOffset);
#endif
	UNUSED(EntriesOffset);
	UNUSED(TOPICSOffset);
	
	if (EntryCount != 0)
	{
		NextItem = EntryInfoOffset;
		do
			NextItem = AddTOCItem(reader, TOC, NextItem, sitemap->items, 0);
		while (NextItem != 0);
	}
	
	ChmStream_Close(TOC);
	return sitemap;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmReader_ObjectExists(ChmReader *reader, const char *name)
{
	return reader != NULL && ITSFReader_ObjectExists(&reader->itsf, name);
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmReader_GetCompleteFileList(ChmReader *reader, void *obj, FileEntryForEach ForEach)
{
	return reader != NULL && ITSFReader_GetCompleteFileList(&reader->itsf, obj, ForEach);
}

/*** ---------------------------------------------------------------------- ***/

LCID ChmReader_GetLCID(ChmReader *reader)
{
	return ITSFReader_GetLCID(&reader->itsf);
}

/*** ---------------------------------------------------------------------- ***/

ChmReader *ChmReader_Create(ChmStream *stream, gboolean FreeStreamOnDestroy)
{
	ChmReader *reader;
	
	if (stream == NULL)
		return NULL;
	reader = g_new0(ChmReader, 1);
	if (reader == NULL)
		return NULL;
	ITSFReader_Init(&reader->itsf, stream, FreeStreamOnDestroy);
	if (ITSFReader_IsValidFile(&reader->itsf))
	{
		ChmReader_ReadCommonData(reader);
	}
	return reader;
}

/*** ---------------------------------------------------------------------- ***/

void ChmReader_Destroy(ChmReader *reader)
{
	size_t i;
	
	if (reader == NULL)
		return;
	ContextList_Destroy(reader->contextList);
	g_slist_free_full(reader->WindowsList, (GDestroyNotify)ChmWindow_Destroy);
	ChmSystem_Destroy(reader->system);
	if (reader->TOPICSStream != NO_SUCH_STREAM)
	{
		ChmStream_TakeOwner(reader->TOPICSStream, FALSE);
		ChmStream_Close(reader->TOPICSStream);
	}
	if (reader->URLSTRStream != NO_SUCH_STREAM)
	{
		ChmStream_TakeOwner(reader->URLSTRStream, FALSE);
		ChmStream_Close(reader->URLSTRStream);
	}
	if (reader->URLTBLStream != NO_SUCH_STREAM)
	{
		ChmStream_TakeOwner(reader->URLTBLStream, FALSE);
		ChmStream_Close(reader->URLTBLStream);
	}
	if (reader->StringsStream != NO_SUCH_STREAM)
	{
		ChmStream_TakeOwner(reader->StringsStream, FALSE);
		ChmStream_Close(reader->StringsStream);
	}
	for (i = 0; i < reader->convstrings_len; i++)
		g_free(reader->strings_converted[i].s);
	g_free(reader->strings_converted);
	
	ITSFReader_Destroy(&reader->itsf);
}
