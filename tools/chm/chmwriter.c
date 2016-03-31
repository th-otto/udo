#include "chmtools.h"
#include "avltree.h"
#include "chmsitemap.h"
#include "chmwriter.h"
#include "chmobjinstconst.h"
#include "chmspecialfiles.h"
#include "chmsearchwriter.h"
#include "lzx_compress.h"
#include <sys/time.h>

static char const defaulthhc[] = "default.hhc";
static char const defaulthhk[] = "default.hhk";

#define LZX_WINDOW_SIZE 16 /* 16 == 2 frames == 1 shl 16 */
#define LZX_FRAME_SIZE 0x8000


/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

StringIndex *StringIndex_Create(void)
{
	StringIndex *strrec;
	
	strrec = g_new(StringIndex, 1);
	if (strrec == NULL)
		return NULL;
	strrec->TheString = NULL;
	strrec->StrId = 0;
	return strrec;
}

/*** ---------------------------------------------------------------------- ***/

void StringIndex_Destroy(StringIndex *str)
{
	if (str == NULL)
		return;
	g_free(str->TheString);
	g_free(str);
}

/*** ---------------------------------------------------------------------- ***/

UrlStrIndex *UrlStrIndex_Create(void)
{
	UrlStrIndex *strrec;
	
	strrec = g_new(UrlStrIndex, 1);
	if (strrec == NULL)
		return NULL;
	strrec->UrlStr = NULL;
	strrec->UrlStrId = 0;
	return strrec;
}

/*** ---------------------------------------------------------------------- ***/

void UrlStrIndex_Destroy(UrlStrIndex *str)
{
	if (str == NULL)
		return;
	g_free(str->UrlStr);
	g_free(str);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static void ITSFWriter_InitITSFHeader(ITSFWriter *itsf)
{
	time_t now;
	struct tm tm;
	
	itsf->ITSFheader.ITSFsig = ITSFFileSig;
	itsf->ITSFheader.Version = 3;
	itsf->ITSFheader.HeaderLength = SIZEOF_ITSFHEADER + (SIZEOF_ITSFHEADERENTRY * 2) + SIZEOF_ITSFHEADERSUFFIX;
	itsf->ITSFheader.Unknown_1 = 1;
	now = time(NULL);
	tm = *localtime(&now);
	itsf->ITSFheader.TimeStamp = (((tm.tm_hour * 60) + tm.tm_min) * 60 + tm.tm_sec) * 1000;
	itsf->ITSFheader.LanguageID = MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US); /* English / English_US */
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_InitHeaderSectionTable(ITSFWriter *itsf)
{
	/* header section 0 */
	itsf->HeaderSection0Table.PosFromZero = itsf->ITSFheader.HeaderLength;
	itsf->HeaderSection0Table.Length = SIZEOF_ITSPHEADERPREFIX;

	/* header section 1 */
	itsf->HeaderSection1Table.PosFromZero = itsf->HeaderSection0Table.PosFromZero + itsf->HeaderSection0Table.Length;
	itsf->HeaderSection1Table.Length = SIZEOF_ITSPHEADER + ChmStream_Size(itsf->DirectoryListings);

	/* contains the offset of CONTENT Section0 from zero */
	itsf->HeaderSuffix.Offset = itsf->HeaderSection1Table.PosFromZero + itsf->HeaderSection1Table.Length;

	itsf->HeaderSection0.Unknown1 = 0x01FE;
	itsf->HeaderSection0.Unknown2 = 0;
	/* at this point we are putting together the headers. content sections 0 and 1 are complete */
	itsf->HeaderSection0.FileSize = itsf->HeaderSuffix.Offset + ChmStream_Size(itsf->Section0) + itsf->Section1Size;
	itsf->HeaderSection0.Unknown3 = 0;
	itsf->HeaderSection0.Unknown4 = 0;
	
	itsf->HeaderSection1.ITSPsig = ITSPHeaderSig;
	itsf->HeaderSection1.Version = 1;
	itsf->HeaderSection1.DirHeaderLength = SIZEOF_ITSPHEADER;	/* Length of the directory header */
	itsf->HeaderSection1.Unknown1 = 0x0A;
	itsf->HeaderSection1.ChunkSize = 0x1000;
	itsf->HeaderSection1.Density = 2;
	/* updated when directory listings were created */
	itsf->HeaderSection1.IndexTreeDepth = 1;		/* 1 if there is no index 2 if there is one level of PMGI chunks. will update as */
	itsf->HeaderSection1.IndexOfRootChunk = -1;		/* if no root chunk */
	itsf->HeaderSection1.FirstPMGLChunkIndex = 0;
	itsf->HeaderSection1.LastPMGLChunkIndex = 0;

	itsf->HeaderSection1.Unknown2 = -1;
	itsf->HeaderSection1.DirectoryChunkCount = 0;
	itsf->HeaderSection1.LanguageID = itsf->ITSFheader.LanguageID;
	itsf->HeaderSection1.guid = ITSPHeaderGUID;
	itsf->HeaderSection1.LengthAgain = SIZEOF_ITSPHEADER;
	itsf->HeaderSection1.Unknown3 = -1;
	itsf->HeaderSection1.Unknown4 = -1;
	itsf->HeaderSection1.Unknown5 = -1;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean write_guid(ChmStream *stream, const GUID *guid)
{
	chmstream_write_le32(stream, guid->Data1);
	chmstream_write_le16(stream, guid->Data2);
	chmstream_write_le16(stream, guid->Data3);
	if (ChmStream_fputc(stream, guid->Data4[0]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[1]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[2]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[3]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[4]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[5]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[6]) < 0) return FALSE;
	if (ChmStream_fputc(stream, guid->Data4[7]) < 0) return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFWriter_WriteHeader(ITSFWriter *itsf, ChmStream *stream)
{
	if (ChmStream_fputc(stream, itsf->ITSFheader.ITSFsig.sig[0]) < 0) return FALSE;
	if (ChmStream_fputc(stream, itsf->ITSFheader.ITSFsig.sig[1]) < 0) return FALSE;
	if (ChmStream_fputc(stream, itsf->ITSFheader.ITSFsig.sig[2]) < 0) return FALSE;
	if (ChmStream_fputc(stream, itsf->ITSFheader.ITSFsig.sig[3]) < 0) return FALSE;
	chmstream_write_le32(stream, itsf->ITSFheader.Version);
	chmstream_write_le32(stream, itsf->ITSFheader.HeaderLength);
	chmstream_write_le32(stream, itsf->ITSFheader.Unknown_1);
	chmstream_write_be32(stream, itsf->ITSFheader.TimeStamp);
	chmstream_write_le32(stream, itsf->ITSFheader.LanguageID);
	if (itsf->ITSFheader.Version < 4)
	{
		write_guid(stream, &ITSFHeaderGUID);
		write_guid(stream, &ITSFHeaderGUID);
	}

	chmstream_write_le64(stream, itsf->HeaderSection0Table.PosFromZero);
	chmstream_write_le64(stream, itsf->HeaderSection0Table.Length);
	chmstream_write_le64(stream, itsf->HeaderSection1Table.PosFromZero);
	chmstream_write_le64(stream, itsf->HeaderSection1Table.Length);
	chmstream_write_le64(stream, itsf->HeaderSuffix.Offset);

	chmstream_write_le32(stream, itsf->HeaderSection0.Unknown1);
	chmstream_write_le32(stream, itsf->HeaderSection0.Unknown2);
	chmstream_write_le64(stream, itsf->HeaderSection0.FileSize);
	chmstream_write_le32(stream, itsf->HeaderSection0.Unknown3);
	chmstream_write_le32(stream, itsf->HeaderSection0.Unknown4);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean UpdateLastListChunk(ITSFWriter *itsf, int LastListIndex, int ChunkIndex)
{
	chm_off_t tmp;
	
	if (ChunkIndex < 1)
		return TRUE;
	
	tmp = ChmStream_Tell(itsf->DirectoryListings);
	/* seek to the NextChunkIndex field */
	if (ChmStream_Seek(itsf->DirectoryListings, LastListIndex * itsf->HeaderSection1.ChunkSize + 16) == FALSE)
		return FALSE;
	chmstream_write_le32(itsf->DirectoryListings, ChunkIndex);
	if (ChmStream_Seek(itsf->DirectoryListings, tmp) == FALSE)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean WriteIndexChunk(ITSFWriter *itsf, DirectoryChunk *IndexBlock, int *ChunkIndex, gboolean ShouldFinish)
{
	PMGIIndexChunk IndexHeader;
	DirectoryChunk *ParentIndex;
	DirectoryChunk *TmpIndex;

	IndexHeader.sig = PMGIsig;
	IndexHeader.UnusedSpace = DirectoryChunk_FreeSpace(IndexBlock);
	PMGIDirectoryChunk_WriteHeader(IndexBlock, &IndexHeader);
	if (PMGIDirectoryChunk_WriteChunkToStream(IndexBlock, itsf->DirectoryListings, ChunkIndex, ShouldFinish) == FALSE)
		return FALSE;
	DirectoryChunk_Clear(IndexBlock);
	if (itsf->HeaderSection1.IndexOfRootChunk < 0)
		itsf->HeaderSection1.IndexOfRootChunk = *ChunkIndex;
	if (ShouldFinish)
	{
		itsf->HeaderSection1.IndexTreeDepth = 2;
		ParentIndex = IndexBlock->ParentChunk;
		if (ParentIndex != NULL)
		{
			/* the parent index is notified by our child index when to write */
			do
			{
				itsf->HeaderSection1.IndexOfRootChunk = *ChunkIndex;
				TmpIndex = ParentIndex;
				ParentIndex = ParentIndex->ParentChunk;
				DirectoryChunk_Destroy(TmpIndex);
				++itsf->HeaderSection1.IndexTreeDepth;
				++(*ChunkIndex);
			} while (ParentIndex != NULL);
		}
	}
	++(*ChunkIndex);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

typedef struct _FirstListEntry {
	uint8_t entry[512];
	int size;
} FirstListEntry;

static gboolean WriteListChunk(ITSFWriter *itsf, DirectoryChunk *ListingBlock, DirectoryChunk *IndexBlock, int *LastListIndex, int *ChunkIndex, const FirstListEntry *firstlistentry)
{
	PMGLListChunk ListHeader;
	
	ListHeader.sig = PMGLsig;
	ListHeader.UnusedSpace = DirectoryChunk_FreeSpace(ListingBlock);
	ListHeader.Unknown1 = 0;
	ListHeader.PreviousChunkIndex = *LastListIndex;
	ListHeader.NextChunkIndex = -1; /* we update this when we write the next chunk */

	if (itsf->HeaderSection1.FirstPMGLChunkIndex <= 0)
		itsf->HeaderSection1.FirstPMGLChunkIndex = *ChunkIndex;
	itsf->HeaderSection1.LastPMGLChunkIndex = *ChunkIndex;
	PMGLDirectoryChunk_WriteHeader(ListingBlock, &ListHeader);
	if (DirectoryChunk_WriteChunkToStream(ListingBlock, itsf->DirectoryListings) == FALSE)
		return FALSE;
	DirectoryChunk_Clear(ListingBlock);
	UpdateLastListChunk(itsf, *LastListIndex, *ChunkIndex);

	*LastListIndex = *ChunkIndex;
	++(*ChunkIndex);
	/* now add to index */
	if (!DirectoryChunk_CanHold(IndexBlock, firstlistentry->size))
		WriteIndexChunk(itsf, IndexBlock, ChunkIndex, FALSE);
	if (DirectoryChunk_WriteEntry(IndexBlock, firstlistentry->size, firstlistentry->entry) == FALSE)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_CreateDirectoryListings(ITSFWriter *itsf)
{
	uint8_t buffer[512];
	DirectoryChunk *IndexBlock;
	DirectoryChunk *ListingBlock;
	int size;
	int FESize;
	const char *FileName;
	int FileNameSize;
	int LastListIndex;
	FirstListEntry firstlistentry;
	int ChunkIndex;
	GSList *l;
	
	/* first sort the listings */
	FileEntryList_Sort(itsf->InternalFiles);
	itsf->HeaderSection1.IndexTreeDepth = 1;
	itsf->HeaderSection1.IndexOfRootChunk = -1;

	ChunkIndex = 0;

	IndexBlock = DirectoryChunk_Create(SIZEOF_PMGIINDEXCHUNK);
	ListingBlock = DirectoryChunk_Create(SIZEOF_PMGLLISTCHUNK);

	LastListIndex  = -1;

	/* add files to a pmgl block until it is full. */
	/* after the block is full make a pmgi block and add the first entry of the pmgl block */
	/* repeat until the index block is full and start another. */
	/* the pmgi chunks take care of needed parent chunks in the tree */
	for (l = itsf->InternalFiles->items; l; l = l->next)
	{
		const FileEntryRec *entry = (const FileEntryRec *)l->data;
		
		size = 0;
		FileName = entry->path.c;
		FileNameSize = (int)strlen(FileName);
		/* filename length */
		size += PutCompressedInteger(&buffer[size], FileNameSize);
		/* filename */
		memcpy(&buffer[size], FileName, FileNameSize);
		size += FileNameSize;
		FESize = size;
		/* File is compressed... */
		size += PutCompressedInteger(&buffer[size], entry->Compressed);
		/* Offset from section start */
		size += PutCompressedInteger(&buffer[size], entry->DecompressedOffset);
		/* Size when uncompressed */
		size += PutCompressedInteger(&buffer[size], entry->DecompressedSize);

		if (!DirectoryChunk_CanHold(ListingBlock, size))
			WriteListChunk(itsf, ListingBlock, IndexBlock, &LastListIndex, &ChunkIndex, &firstlistentry);

		if (DirectoryChunk_WriteEntry(ListingBlock, size, buffer) == FALSE) {}

		/* add the first list item to the index */
		if (ListingBlock->ItemCount == 1)
		{
			memcpy(firstlistentry.entry, buffer, FESize);
			firstlistentry.size = FESize + PutCompressedInteger(&firstlistentry.entry[FESize], ChunkIndex);
		}
	}
	if (ListingBlock->ItemCount > 0)
		WriteListChunk(itsf, ListingBlock, IndexBlock, &LastListIndex, &ChunkIndex, &firstlistentry);

	if (ChunkIndex > 1)
	{
		if (IndexBlock->ItemCount > 1 || (IndexBlock->ItemCount > 0 && itsf->HeaderSection1.IndexOfRootChunk > -1))
			WriteIndexChunk(itsf, IndexBlock, &ChunkIndex, TRUE);
	}

	itsf->HeaderSection1.DirectoryChunkCount = ChmStream_Size(itsf->DirectoryListings) / itsf->HeaderSection1.ChunkSize;

	DirectoryChunk_Destroy(IndexBlock);
	DirectoryChunk_Destroy(ListingBlock);
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFWriter_WriteDirectoryListings(ITSFWriter *itsf, ChmStream *stream)
{
	if (ChmStream_fputc(stream, itsf->HeaderSection1.ITSPsig.sig[0]) < 0) return FALSE;
	if (ChmStream_fputc(stream, itsf->HeaderSection1.ITSPsig.sig[1]) < 0) return FALSE;
	if (ChmStream_fputc(stream, itsf->HeaderSection1.ITSPsig.sig[2]) < 0) return FALSE;
	if (ChmStream_fputc(stream, itsf->HeaderSection1.ITSPsig.sig[3]) < 0) return FALSE;
	chmstream_write_le32(stream, itsf->HeaderSection1.Version);
	chmstream_write_le32(stream, itsf->HeaderSection1.DirHeaderLength);
	chmstream_write_le32(stream, itsf->HeaderSection1.Unknown1);
	chmstream_write_le32(stream, itsf->HeaderSection1.ChunkSize);
	chmstream_write_le32(stream, itsf->HeaderSection1.Density);
	chmstream_write_le32(stream, itsf->HeaderSection1.IndexTreeDepth);
	chmstream_write_le32(stream, itsf->HeaderSection1.IndexOfRootChunk);
	chmstream_write_le32(stream, itsf->HeaderSection1.FirstPMGLChunkIndex);
	chmstream_write_le32(stream, itsf->HeaderSection1.LastPMGLChunkIndex);
	chmstream_write_le32(stream, itsf->HeaderSection1.Unknown2);
	chmstream_write_le32(stream, itsf->HeaderSection1.DirectoryChunkCount);
	chmstream_write_le32(stream, itsf->HeaderSection1.LanguageID);
	write_guid(stream, &itsf->HeaderSection1.guid);
	chmstream_write_le32(stream, itsf->HeaderSection1.LengthAgain);
	chmstream_write_le32(stream, itsf->HeaderSection1.Unknown3);
	chmstream_write_le32(stream, itsf->HeaderSection1.Unknown4);
	chmstream_write_le32(stream, itsf->HeaderSection1.Unknown5);

	if (ChmStream_Seek(itsf->DirectoryListings, 0) == FALSE)
		return FALSE;
	if (ChmStream_CopyFrom(stream, itsf->DirectoryListings, ChmStream_Size(itsf->DirectoryListings)) == FALSE)
		return FALSE;
	if (ChmStream_Seek(itsf->DirectoryListings, 0) == FALSE)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFWriter_WriteREADMEFile(ITSFWriter *itsf)
{
	static char const DISCLAIMER_STR[] = "This archive was not made by the MS HTML Help Workshop(r)(tm) program.\x0d\x0a";
	FileEntryRec entry;
	
	/* This procedure puts a file in the archive that says it wasn't compiled with the MS compiler */
	entry.Compressed = FALSE;
	entry.searchable = FALSE;
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	if (ChmStream_Write(itsf->Section0, DISCLAIMER_STR, sizeof(DISCLAIMER_STR) - 1) != sizeof(DISCLAIMER_STR) - 1)
		return FALSE;
	if (!empty(itsf->ReadmeMessage))
	{
		if (ChmStream_Write(itsf->Section0, itsf->ReadmeMessage, strlen(itsf->ReadmeMessage)) != strlen(itsf->ReadmeMessage))
			return FALSE;
	}
	entry.DecompressedSize = ChmStream_Tell(itsf->Section0) - entry.DecompressedOffset;
	/* try to use a name that won't conflict with normal names */
	entry.path.c = "/_#_README_#_";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, TRUE);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFWriter_WriteSection0(ITSFWriter *itsf)
{
	if (ChmStream_Seek(itsf->Section0, 0) == FALSE)
		return FALSE;
	if (ChmStream_CopyFrom(itsf->OutStream, itsf->Section0, ChmStream_Size(itsf->Section0)) == FALSE)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFWriter_WriteSection1(ITSFWriter *itsf)
{
	if (WriteContentToStream(itsf->OutStream, itsf->Section1) == 0 && ChmStream_Size(itsf->Section1) != 0)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ITSFWriter_WriteDataSpaceFiles(ITSFWriter *itsf)
{
	FileEntryRec entry;
	
	/* This procedure will write all files starting with :: */
	entry.Compressed = FALSE; /* None of these files are compressed */
	entry.searchable = FALSE;
	
	/*	::DataSpace/NameList */
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	entry.DecompressedSize = WriteNameListToStream(itsf->Section0, snUnCompressed|snMSCompressed);
	entry.path.c = "::DataSpace/NameList";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, FALSE);

	/*	::DataSpace/Storage/MSCompressed/ControlData */
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	entry.DecompressedSize = WriteControlDataToStream(itsf->Section0, (1 << LZX_WINDOW_SIZE) / LZX_FRAME_SIZE, (1 << LZX_WINDOW_SIZE) / LZX_FRAME_SIZE, 1);
	entry.path.c = "::DataSpace/Storage/MSCompressed/ControlData";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, FALSE);

	/*	::DataSpace/Storage/MSCompressed/SpanInfo */
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	entry.DecompressedSize = WriteSpanInfoToStream(itsf->Section0, itsf->ReadCompressedSize);
	entry.path.c = "::DataSpace/Storage/MSCompressed/SpanInfo";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, FALSE);

	/*	::DataSpace/Storage/MSCompressed/Transform/List */
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	entry.DecompressedSize = WriteTransformListToStream(itsf->Section0);
	entry.path.c = "::DataSpace/Storage/MSCompressed/Transform/List";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, FALSE);

	/*	::DataSpace/Storage/MSCompressed/Transform/{7FC28940-9D31-11D0-9B27-00A0C91E9C7C}/ */
	/*	::DataSpace/Storage/MSCompressed/Transform/{7FC28940-9D31-11D0-9B27-00A0C91E9C7C}/InstanceData/ResetTable */
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	entry.DecompressedSize = WriteResetTableToStream(itsf->Section0, itsf->Section1ResetTable);
	entry.path.c = "::DataSpace/Storage/MSCompressed/Transform/{7FC28940-9D31-11D0-9B27-00A0C91E9C7C}/InstanceData/ResetTable";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, FALSE);

	/*	::DataSpace/Storage/MSCompressed/Content do this last */
	entry.DecompressedOffset = ChmStream_Tell(itsf->Section0);
	entry.DecompressedSize = itsf->Section1Size; /* we will write it directly to OutStream later */
	entry.path.c = "::DataSpace/Storage/MSCompressed/Content";
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, FALSE);
	
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static int ITSFWriter_AtEndOfData(void *arg)
{
	ITSFWriter *itsf = (ITSFWriter *)arg;
	
	if (itsf->ForceExit)
		return TRUE;
	return itsf->CurrentIndex >= (itsf->FilesToCompressCount - 1) &&
		ChmStream_Tell(itsf->CurrentStream) >= ChmStream_Size(itsf->CurrentStream);
}

/*** ---------------------------------------------------------------------- ***/

static int ITSFWriter_GetData(void *arg, int count, void *_buffer)
{
	ITSFWriter *itsf = (ITSFWriter *)arg;
	uint8_t *buffer = (uint8_t *)_buffer;
	FileEntryRec FileEntry;
	int result = 0;
	
	while (result < count && !ITSFWriter_AtEndOfData(itsf))
	{
		result += ChmStream_Read(itsf->CurrentStream, &buffer[result], count - result);
		if (result < count && !ITSFWriter_AtEndOfData(itsf))
		{
			const char *path;
			
			/* the current file has been read. move to the next file in the list */
			ChmStream_Close(itsf->CurrentStream);
			++itsf->CurrentIndex;
			path = (const char *)g_slist_nth_data(itsf->FilesToCompress, itsf->CurrentIndex);
			itsf->ForceExit = itsf->OnGetFileData(itsf->user_data, path, &itsf->CurrentStream);
			FileEntry.path.s = g_strconcat("/", path, NULL);
			FileEntry.DecompressedSize = ChmStream_Size(itsf->CurrentStream);
			FileEntry.DecompressedOffset = itsf->ReadCompressedSize;
			FileEntry.Compressed = TRUE;
			FileEntry.searchable = TRUE;

			itsf->FileAdded(itsf, itsf->CurrentStream, &FileEntry);

			FileEntryList_AddEntry(itsf->InternalFiles, &FileEntry, TRUE);
			g_free(FileEntry.path.s);
			/* So the next file knows it's offset */
			itsf->ReadCompressedSize += FileEntry.DecompressedSize;
		}

		/* this is intended for programs to add perhaps a file */
		/* after all the other files have been added. */
		if (ITSFWriter_AtEndOfData(itsf) && itsf->CurrentStream != itsf->PostStream)
		{
			itsf->PostStreamActive = TRUE;
			if (itsf->OnLastFile)
				itsf->OnLastFile(itsf->user_data, itsf);
			ChmStream_Close(itsf->CurrentStream);
			itsf->WriteFinalCompressedFiles(itsf);
			itsf->CurrentStream = itsf->PostStream;
			if (ChmStream_Seek(itsf->CurrentStream, 0) == FALSE) {}
			itsf->ReadCompressedSize += ChmStream_Size(itsf->CurrentStream);
		}
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static int ITSFWriter_WriteCompressedData(void *arg, int count, void *buffer)
{
	ITSFWriter *itsf = (ITSFWriter *)arg;

	int result = ChmStream_Write(itsf->Section1, buffer, count);
	itsf->Section1Size += result;
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static void IncEntryCount(ITSFWriter *itsf)
{
	chm_off_t OldPos;
	uint32_t value;

	OldPos = ChmStream_Tell(itsf->Section1ResetTable);
	if (ChmStream_Seek(itsf->Section1ResetTable, 4) == FALSE) {}
	value = chmstream_read_le32(itsf->Section1ResetTable) + 1;
	if (ChmStream_Seek(itsf->Section1ResetTable, 4) == FALSE) {}
	chmstream_write_le32(itsf->Section1ResetTable, value);
	if (ChmStream_Seek(itsf->Section1ResetTable, OldPos) == FALSE) {}
}

/*** ---------------------------------------------------------------------- ***/

static void UpdateTotalSizes(ITSFWriter *itsf, uint32_t CompressedTotal)
{
	chm_off_t OldPos;
	
	OldPos = ChmStream_Tell(itsf->Section1ResetTable);
	if (ChmStream_Seek(itsf->Section1ResetTable, 0x10) == FALSE) {}
	chmstream_write_le64(itsf->Section1ResetTable, itsf->ReadCompressedSize); /* size of read data that has been compressed */
	chmstream_write_le64(itsf->Section1ResetTable, CompressedTotal);
	if (ChmStream_Seek(itsf->Section1ResetTable, OldPos) == FALSE) {}
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_MarkFrame(void *arg, uint32_t UnCompressedTotal, uint32_t CompressedTotal)
{
	ITSFWriter *itsf = (ITSFWriter *)arg;

	UNUSED(UnCompressedTotal);
	if (ChmStream_Size(itsf->Section1ResetTable) == 0)
	{
		/* Write the header */
		chmstream_write_le32(itsf->Section1ResetTable, 2);
		chmstream_write_le32(itsf->Section1ResetTable, 0); /* number of entries. we will correct this with IncEntryCount */
		chmstream_write_le32(itsf->Section1ResetTable, 8); /* Size of Entries (qword) */
		chmstream_write_le32(itsf->Section1ResetTable, 0x28); /* Size of this header */
		chmstream_write_le64(itsf->Section1ResetTable, 0); /* Total Uncompressed Size */
		chmstream_write_le64(itsf->Section1ResetTable, 0); /* Total Compressed Size */
		chmstream_write_le64(itsf->Section1ResetTable, LZX_FRAME_SIZE); /* Block Size */
		chmstream_write_le64(itsf->Section1ResetTable, 0); /* First Block start */
	}
	IncEntryCount(itsf);
	UpdateTotalSizes(itsf, CompressedTotal);
	chmstream_write_le64(itsf->Section1ResetTable, CompressedTotal); /* Next Block Start */
	/* We have to trim the last entry off when we are done because there is no next block in that case */
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_StartCompressingStream(ITSFWriter *itsf)
{
	lzx_data *lzx;
	unsigned int wsize;
	lzx_results results;
	
	lzx_init(&lzx, LZX_WINDOW_SIZE, ITSFWriter_GetData, itsf, ITSFWriter_AtEndOfData,
						ITSFWriter_WriteCompressedData, itsf, ITSFWriter_MarkFrame, itsf);

	wsize = 1 << LZX_WINDOW_SIZE;
	while (!ITSFWriter_AtEndOfData(itsf))
	{
		lzx_reset(lzx);
		lzx_compress_block(lzx, wsize, TRUE);
	}

	lzx_finish(lzx, &results);

	/* we have to mark the last frame manually */
	ITSFWriter_MarkFrame(itsf, results.len_uncompressed_input, results.len_compressed_output);
}

/*** ---------------------------------------------------------------------- ***/

void ITSFWriter_Execute(ITSFWriter *itsf)
{
	ITSFWriter_InitITSFHeader(itsf);
	if (ChmStream_Seek(itsf->OutStream, 0) == FALSE) {}
	itsf->Section1Size = 0;
	
	itsf->FilesToCompressCount = g_slist_length(itsf->FilesToCompress);
	
	/* write any internal files to FCurrentStream that we want in the compressed section */
	itsf->WriteInternalFilesBefore(itsf);

	/* move back to zero so that we can start reading from zero :) */
	itsf->ReadCompressedSize = ChmStream_Size(itsf->CurrentStream);

	/* this gathers ALL files that should be in section1 (the compressed section) */
	ITSFWriter_StartCompressingStream(itsf);

	itsf->WriteInternalFilesAfter(itsf);

	/* this creates all special files in the archive that start with ::DataSpace */
	ITSFWriter_WriteDataSpaceFiles(itsf);

	/* creates all directory listings including header */
	ITSFWriter_CreateDirectoryListings(itsf);

	/* do this after we have compressed everything so that we know the values that must be written */
	ITSFWriter_InitHeaderSectionTable(itsf);

	/* Now we can write everything to FOutStream */
	ITSFWriter_WriteHeader(itsf, itsf->OutStream);
	ITSFWriter_WriteDirectoryListings(itsf, itsf->OutStream);
	ITSFWriter_WriteSection0(itsf); /* does NOT include section 1 even though section0.content IS section1 */
	ITSFWriter_WriteSection1(itsf); /* writes section 1 to FOutStream */
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_WriteFinalCompressedFiles(ITSFWriter *itsf)
{
	UNUSED(itsf);
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_FileAdded(ITSFWriter *itsf, ChmStream *stream, const FileEntryRec *entry)
{
	/* do nothing here */
	UNUSED(itsf);
	UNUSED(stream);
	UNUSED(entry);
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_WriteInternalFilesAfter(ITSFWriter *itsf)
{
	UNUSED(itsf);
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_WriteInternalFilesBefore(ITSFWriter *itsf)
{
	/* written to Section0 (uncompressed) */
	ITSFWriter_WriteREADMEFile(itsf);
}

/*** ---------------------------------------------------------------------- ***/

/* this procedure is used to manually add files to compress to an internal stream that is */
/* processed before FileToCompress is called. Files added this way should not be */
/* duplicated in the FilesToCompress property. */
gboolean ITSFWriter_AddStreamToArchive(ITSFWriter *itsf, const char *path, ChmStream *stream, gboolean compress, gboolean searchable)
{
	ChmStream *TargetStream;
	FileEntryRec entry;
	
	/* in case AddStreamToArchive is used after we should be writing to the post stream */
	if (itsf->PostStreamActive)
	{
		return ITSFWriter_PostAddStreamToArchive(itsf, path, stream, compress, searchable);
	}
	if (stream == NULL)
		return TRUE;
	if (compress)
		TargetStream = itsf->CurrentStream;
	else
		TargetStream = itsf->Section0;

	entry.path.c = path;
	entry.Compressed = compress;
	entry.searchable = searchable;
	entry.DecompressedOffset = ChmStream_Tell(TargetStream);
	entry.DecompressedSize = ChmStream_Size(stream);
	itsf->FileAdded(itsf, stream, &entry);
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, TRUE);
	if (ChmStream_Seek(stream, 0) == FALSE)
		return FALSE;
	if (ChmStream_CopyFrom(TargetStream, stream, ChmStream_Size(stream)) == FALSE)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ITSFWriter_PostAddStreamToArchive(ITSFWriter *itsf, const char *path, ChmStream *stream, gboolean compress, gboolean searchable)
{
	ChmStream *TargetStream;
	FileEntryRec entry;
	
	if (stream == NULL)
		return TRUE;
	if (compress)
		TargetStream = itsf->PostStream;
	else
		TargetStream = itsf->Section0;

	entry.path.c = path;
	entry.Compressed = compress;
	entry.searchable = searchable;
	if (!compress)
		entry.DecompressedOffset = ChmStream_Tell(TargetStream);
	else
		entry.DecompressedOffset = itsf->ReadCompressedSize + ChmStream_Tell(TargetStream);
	entry.DecompressedSize = ChmStream_Size(stream);
	FileEntryList_AddEntry(itsf->InternalFiles, &entry, TRUE);
	if (ChmStream_Seek(stream, 0) == FALSE)
		return FALSE;
	if (ChmStream_CopyFrom(TargetStream, stream, ChmStream_Size(stream)) == FALSE)
		return FALSE;
	itsf->FileAdded(itsf, stream, &entry);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static void ITSFWriter_Init(ITSFWriter *itsf, ChmStream *OutStream, gboolean FreeStreamOnDestroy)
{
	itsf->OutStream = OutStream;
	itsf->DestroyStream = FreeStreamOnDestroy;
	itsf->CurrentIndex = -1;
	itsf->CurrentStream = ChmStream_CreateMem(0);
	itsf->InternalFiles = FileEntryList_Create();
	itsf->Section0 = ChmStream_CreateMem(0);
	itsf->Section1 = ChmStream_CreateMem(0);
	itsf->Section1ResetTable = ChmStream_CreateMem(0);
	itsf->DirectoryListings = ChmStream_CreateMem(0);
	itsf->PostStream = ChmStream_CreateMem(0);
	itsf->FilesToCompress = NULL;
	itsf->FilesToCompressCount = 0;
	itsf->WriteInternalFilesBefore = ITSFWriter_WriteInternalFilesBefore;
	itsf->WriteInternalFilesAfter = ITSFWriter_WriteInternalFilesAfter;
	itsf->WriteFinalCompressedFiles = ITSFWriter_WriteFinalCompressedFiles;
	itsf->FileAdded = ITSFWriter_FileAdded;
}

ITSFWriter *ITSFWriter_Create(ChmStream *OutStream, gboolean FreeStreamOnDestroy)
{
	ITSFWriter *itfs;
	
	if (OutStream == NULL)
	{
		errno = EINVAL;
		return NULL;
	}
	itfs = g_new0(ITSFWriter, 1);
	if (itfs == NULL)
		return NULL;
	ITSFWriter_Init(itfs, OutStream, FreeStreamOnDestroy);
	return itfs;
}

/*** ---------------------------------------------------------------------- ***/

void ITSFWriter_Destroy(ITSFWriter *itsf)
{
	if (itsf == NULL)
		return;
	if (itsf->DestroyStream)
		ChmStream_Close(itsf->OutStream);
	FileEntryList_Destroy(itsf->InternalFiles);
	ChmStream_Close(itsf->CurrentStream);
	ChmStream_Close(itsf->Section0);
	ChmStream_Close(itsf->Section1);
	ChmStream_Close(itsf->Section1ResetTable);
	ChmStream_Close(itsf->DirectoryListings);
	g_slist_free_full(itsf->FilesToCompress, g_free);
	g_free(itsf);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/ 
/******************************************************************************/

static uint32_t addstring(ChmWriter *chm, const char *str)
{
	uint32_t space;
	uint32_t pos;
	StringIndex *StrRec;
	AVLTreeNode *n;
	struct {
		const char *TheString;
		int32_t StrId;
	} SpareString;
	unsigned int len;
	
	/* #STRINGS starts with a null char */
	if (ChmStream_Size(chm->StringsStream) == 0)
		ChmStream_fputc(chm->StringsStream, 0);
	if (empty(str))
		return 0;
	
	SpareString.TheString = str;
	n = AVLTree_Find(chm->AvlStrings, &SpareString);
	if (n)
		return ((StringIndex *)(n->data))->StrId;

	/* each entry is a null terminated string */
	pos = ChmStream_Tell(chm->StringsStream);

	/* Strings are contained in $1000 byte blocks and cannot cross blocks */
	space = 0x00001000 - (0xFFFFF000 & pos);
	len = strlen(str) + 1;
	if (len > space)
	{
		unsigned int i;
		
		for (i = 0; i < space; i++)
			ChmStream_fputc(chm->StringsStream, 0);
	}

	pos = ChmStream_Tell(chm->StringsStream);
	ChmStream_Write(chm->StringsStream, str, len);
	StrRec = StringIndex_Create();
	StrRec->TheString = g_strdup(str);
	StrRec->StrId = pos;
	AVLTree_Add(chm->AvlStrings, StrRec);
	return pos;
}

/*** ---------------------------------------------------------------------- ***/ 

static void CheckURLStrBlockCanHold(ChmWriter *chm, const char *str)
{
	uint32_t len, rem;

	rem = 0x4000 - ((uint32_t)ChmStream_Size(chm->URLSTRStream) % 0x4000);
	len = 9 + strlen(str);	/* 2 dwords the string and NT */
	if (len > rem)
	{
		while (rem > 0)
		{
			ChmStream_fputc(chm->URLSTRStream, 0);
			--rem;
		}
	}
}

/*** ---------------------------------------------------------------------- ***/ 

static uint32_t AddURLString(ChmWriter *chm, const char *str)
{
	UrlStrIndex *urlstrrec;
	uint32_t result;
	
	if (ChmStream_Size(chm->URLSTRStream) == 0)
		ChmStream_fputc(chm->URLSTRStream, 0);
	CheckURLStrBlockCanHold(chm, str);
	result = ChmStream_Tell(chm->URLSTRStream);
	urlstrrec = UrlStrIndex_Create();
	urlstrrec->UrlStr = g_strdup(str);
	urlstrrec->UrlStrId = result;
	AVLTree_Add(chm->AvlURLStr, urlstrrec);
	chmstream_write_le32(chm->URLSTRStream, 0); /* URL Offset for topic after the the "Local" value */
	chmstream_write_le32(chm->URLSTRStream, 0); /* Offset of FrameName?? */
	ChmStream_Write(chm->URLSTRStream, str, strlen(str) + 1);
	return result;
}

/*** ---------------------------------------------------------------------- ***/ 

static uint32_t LookupUrlString(ChmWriter *chm, const char *url)
{
	AVLTreeNode *n;
	struct {
		const char *UrlStr;
		int32_t UrlStrId;
	} SpareUrlStr;
	
	SpareUrlStr.UrlStr = url;
	n = AVLTree_Find(chm->AvlURLStr, &SpareUrlStr);
	if (n)
		return ((UrlStrIndex *)(n->data))->UrlStrId;
	return AddURLString(chm, url);
}

/*** ---------------------------------------------------------------------- ***/ 

static uint32_t addurl(ChmWriter *chm, const char *url, uint32_t TopicsIndex)
{
	uint32_t UrlIndex;
	uint32_t result;
	
	if (*url == '/')
		url++;
	UrlIndex = LookupUrlString(chm, url);

	result = ChmStream_Tell(chm->URLTBLStream);
	if ((result & 0xFFC) == 0xFFC) /* we are at 4092 */
	{
		chmstream_write_le32(chm->URLTBLStream, 0);
		result += 4;
	}
	chmstream_write_le32(chm->URLTBLStream, 0);		/* 0x231e9f5c;  unknown */
	chmstream_write_le32(chm->URLTBLStream, TopicsIndex); /* Index of topic in #TOPICS */
	chmstream_write_le32(chm->URLTBLStream, UrlIndex);
	return result;
}

/*** ---------------------------------------------------------------------- ***/ 

static uint32_t NextTopicIndex(ChmWriter *chm)
{
	return ChmStream_Size(chm->TopicsStream) / 16;
}

/*** ---------------------------------------------------------------------- ***/ 

static uint32_t ChmWriter_AddTopic(ChmWriter *chm, const char *title, const char *url, int code)
{
	TopicEntry entry;
	uint32_t result;
	
	if (title)
		entry.StringsOffset = addstring(chm, title);
	else
		entry.StringsOffset = -1;
	result = NextTopicIndex(chm);
	entry.URLTableOffset = addurl(chm, url, result);
	if (code == -1)
	{
		if (title)
			entry.InContents = 6;
		else
			entry.InContents = 2;
		if (strchr(url, '#') != NULL)
			entry.InContents = 0;
	} else
	{
		entry.InContents = code;
	}
	
	++chm->NrTopics;
	entry.Unknown = 0;
	entry.TocOffset = 0;
	chmstream_write_le32(chm->TopicsStream, entry.TocOffset);
	chmstream_write_le32(chm->TopicsStream, entry.StringsOffset);
	chmstream_write_le32(chm->TopicsStream, entry.URLTableOffset);
	chmstream_write_le16(chm->TopicsStream, entry.InContents);
	chmstream_write_le16(chm->TopicsStream, entry.Unknown);
	return result;
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteTOPICS(ChmWriter *chm)
{
	if (ChmStream_Size(chm->TopicsStream) == 0)
		return;
	if (chm->toc_filename)
		ChmWriter_AddTopic(chm, NULL, chm->toc_filename, 2);
	if (chm->index_filename)
		ChmWriter_AddTopic(chm, NULL, chm->index_filename, 2);
	ITSFWriter_PostAddStreamToArchive(&chm->itsf, "/#TOPICS", chm->TopicsStream, TRUE, FALSE);
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteURL_STR_TBL(ChmWriter *chm)
{
	if (ChmStream_Size(chm->URLSTRStream) != 0)
		ITSFWriter_PostAddStreamToArchive(&chm->itsf, "/#URLSTR", chm->URLSTRStream, TRUE, FALSE);
	
	if (ChmStream_Size(chm->URLTBLStream) != 0)
		ITSFWriter_PostAddStreamToArchive(&chm->itsf, "/#URLTBL", chm->URLTBLStream, TRUE, FALSE);
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteWINDOWS(ChmWriter *chm)
{
	ChmMemoryStream *WindowStream;
	int i;
	const ChmWindow *win;
	const GSList *l;
	
	if (chm->windows)
	{
		WindowStream = ChmStream_CreateMem(0);
		chmstream_write_le32(WindowStream, g_slist_length(chm->windows));
		chmstream_write_le32(WindowStream, 196); /* 1.1 or later. 188 is old style. */
		for (l = chm->windows; l; l = l->next)
		{
			win = (const ChmWindow *)l->data;
			chmstream_write_le32(WindowStream, 196);									/*  0 size of entry. */
			chmstream_write_le32(WindowStream, win->unicode_strings); 					/*  4 unknown (bool Unicodestrings?) */
			chmstream_write_le32(WindowStream, addstring(chm, win->window_name.c));		/*  8 Arg 0, name of window */
			chmstream_write_le32(WindowStream, win->flags);								/*  C valid fields */
			chmstream_write_le32(WindowStream, win->win_properties);					/* 10 arg 10 navigation pane style */
			chmstream_write_le32(WindowStream, addstring(chm, win->caption.c));			/* 14 Arg 1,  title bar text */
			chmstream_write_le32(WindowStream, win->styleflags);						/* 18 Arg 14, style flags */
			chmstream_write_le32(WindowStream, win->xtdstyleflags); 					/* 1C Arg 15, xtd style flags */
			chmstream_write_le32(WindowStream, win->pos.left);							/* 20 Arg 13, rect.left */
			chmstream_write_le32(WindowStream, win->pos.top); 							/* 24 Arg 13, rect.top */
			chmstream_write_le32(WindowStream, win->pos.right); 						/* 28 Arg 13, rect.right */
			chmstream_write_le32(WindowStream, win->pos.bottom);						/* 2C Arg 13, rect.bottom */
			chmstream_write_le32(WindowStream, win->show_state);						/* 30 Arg 16, window show state */
			chmstream_write_le32(WindowStream, 0); 										/* 34	- 	, HWND hwndhelp								OUT: window handle" */
			chmstream_write_le32(WindowStream, 0); 										/* 38	- 	, HWND hwndcaller							OUT: who called this window" */
			chmstream_write_le32(WindowStream, 0); 										/* 3C	- 	, HH_INFO_TYPE paINFO_TYPES		IN: Pointer to an array of Information Types" */
			chmstream_write_le32(WindowStream, 0); 										/* 40	- 	, HWND hwndtoolbar 						OUT: toolbar window in tri-pane window" */
			chmstream_write_le32(WindowStream, 0); 										/* 44	- 	, HWND hwndnavigation					OUT: navigation window in tri-pane window" */
			chmstream_write_le32(WindowStream, 0); 										/* 48	- 	, HWND hwndhtml								OUT: window displaying HTML in tri-pane window" */
			chmstream_write_le32(WindowStream, win->navpanewidth);						/* 4C Arg 11, width of nav pane */
			chmstream_write_le32(WindowStream, 0); 										/* 50	- 	, rect.left, 	OUT:Specifies the coordinates of the Topic pane */
			chmstream_write_le32(WindowStream, 0); 										/* 54	- 	, rect.top , 	OUT:Specifies the coordinates of the Topic pane */
			chmstream_write_le32(WindowStream, 0); 										/* 58	- 	, rect.right,	OUT:Specifies the coordinates of the Topic pane */
			chmstream_write_le32(WindowStream, 0); 										/* 5C	- 	, rect.bottom, OUT:Specifies the coordinates of the Topic pane */
			chmstream_write_le32(WindowStream, addstring(chm, win->toc_file.c));		/* 60 Arg 2,  toc file */
			chmstream_write_le32(WindowStream, addstring(chm, win->index_file.c));		/* 64 Arg 3,  index file */
			chmstream_write_le32(WindowStream, addstring(chm, win->default_file.c));	/* 68 Arg 4,  default file */
			chmstream_write_le32(WindowStream, addstring(chm, win->home_button_file.c));	/* 6c Arg 5,  home button file. */
			chmstream_write_le32(WindowStream, win->buttons); 							/* 70 arg 12, */
			chmstream_write_le32(WindowStream, win->not_expanded);						/* 74 arg 17 */
			chmstream_write_le32(WindowStream, win->navtype); 							/* 78 arg 18, */
			chmstream_write_le32(WindowStream, win->tabpos);							/* 7C arg 19, */
			chmstream_write_le32(WindowStream, win->wm_notify_id);						/* 80 arg 20, */
			for (i = 0; i <= HH_MAX_TABS; i++)
				ChmStream_fputc(WindowStream, win->taborder[i]); 						/* 84	- 		byte[20] unknown -  "BYTE tabOrder[HH_MAX_TABS + 1];  IN/OUT: tab order: Contents, Index, Search, History, Favorites, Reserved 1-5, Custom tabs" */
			chmstream_write_le32(WindowStream, 0); 										/* 94	- 		int cHistory; IN/OUT: number of history items to keep (default is 30) */
			chmstream_write_le32(WindowStream, addstring(chm, win->jump1_text.c));		/* 9C Arg 7,  The text of the Jump 1 button. */
			chmstream_write_le32(WindowStream, addstring(chm, win->jump2_text.c));		/* A0 Arg 9,  The text of the Jump 2 button. */
			chmstream_write_le32(WindowStream, addstring(chm, win->jump1_url.c)); 		/* A4 Arg 6,  The file shown for Jump 1 button. */
			chmstream_write_le32(WindowStream, addstring(chm, win->jump2_url.c)); 		/* A8 Arg 8,  The file shown for Jump 1 button. */
			chmstream_write_le32(WindowStream, win->minsize.left); 						/* AA	- 		byte[16] (TRECT) "RECT rcMinSize; Minimum size for window (ignored in version 1)" */
			chmstream_write_le32(WindowStream, win->minsize.top);
			chmstream_write_le32(WindowStream, win->minsize.right);
			chmstream_write_le32(WindowStream, win->minsize.bottom);
			/* 1.1+ fields */
			chmstream_write_le32(WindowStream, 0); 										/* BC -			int cbInfoTypes; size of paInfoTypes; */
			chmstream_write_le32(WindowStream, 0); 										/* C0	- 		LPCTSTR pszCustomTabs; multiple zero-terminated strings */
		}
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/#WINDOWS", WindowStream, TRUE, FALSE);
		ChmStream_Close(WindowStream);
	}
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteSTRINGS(ChmWriter *chm)
{
	if (ChmStream_Size(chm->StringsStream) == 0)
	{
		if (ChmStream_fputc(chm->StringsStream, 0) == FALSE) {}
	}
	ITSFWriter_PostAddStreamToArchive(&chm->itsf, "/#STRINGS", chm->StringsStream, TRUE, FALSE);
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteIDXHDR(ChmWriter *chm)
{
	int count = g_slist_length(chm->mergefiles);
	ChmStream *stream = chm->IDXHdrStream;
	const GSList *l;
	int i;
	
	/* I assume text/site properties could also trigger idxhdr */
	if (count == 0)
		return;
	
	chmstream_write_be32(stream, 0x5423534d);			/*	0 Magic 'T#SM' */
	chmstream_write_le32(stream, 1);					/*	4 Unknown timestamp/checksum */
	chmstream_write_le32(stream, 1);					/*	8 1 (unknown) */
	chmstream_write_le32(stream, chm->NrTopics);		/*	C Number of topic nodes including the contents & index files */
	chmstream_write_le32(stream, 0);					/* 10 0 (unknown) */

	/* 14 Offset in the #STRINGS file of the ImageList param of the "text/site properties" object of the sitemap contents (0/-1 == none) */
	if (chm->TocSitemap && chm->TocSitemap->imagelist != NULL)
		chmstream_write_le32(stream, addstring(chm, chm->TocSitemap->imagelist));
	else
		chmstream_write_le32(stream, 0);

	/* 18 0 (unknown) */
	chmstream_write_le32(stream, 0);

	/* 1C 1 if the value of the ImageType param of the "text/site properties" object of the sitemap contents is Folder. 0 otherwise. */
	if (chm->TocSitemap)
		chmstream_write_le32(stream, chm->TocSitemap->usefolderimages);
	else
		chmstream_write_le32(stream, 0);

	/* 20 The value of the Background param of the "text/site properties" object of the sitemap contents */
	if (chm->TocSitemap)
		chmstream_write_le32(stream, chm->TocSitemap->background);
	else
		chmstream_write_le32(stream, 0);

	/* 24 The value of the Foreground param of the "text/site properties" object of the sitemap contents */
	if (chm->TocSitemap)
		chmstream_write_le32(stream, chm->TocSitemap->foreground);
	else
		chmstream_write_le32(stream, 0);

	/* 28 Offset in the #STRINGS file of the Font param of the "text/site properties" object of the sitemap contents (0/-1 == none) */
	if (chm->TocSitemap && chm->TocSitemap->font)
		chmstream_write_le32(stream, addstring(chm, chm->TocSitemap->font));
	else
		chmstream_write_le32(stream, 0);

	/* 2C The value of the Window Styles param of the "text/site properties" object of the sitemap contents */
	if (chm->TocSitemap)
		chmstream_write_le32(stream, chm->TocSitemap->windowstyles);
	else
		chmstream_write_le32(stream, 0);

	/* 30 The value of the EXWindow Styles param of the "text/site properties" object of the sitemap contents */
	if (chm->TocSitemap)
		chmstream_write_le32(stream, chm->TocSitemap->exwindowstyles);
	else
		chmstream_write_le32(stream, 0);

	/* 34 Unknown. Often -1. Sometimes 0. */
	chmstream_write_le32(stream, -1);

	/* 38 Offset in the #STRINGS file of the FrameName param of the "text/site properties" object of the sitemap contents (0/-1 == none) */
	if (chm->TocSitemap && chm->TocSitemap->framename)
		chmstream_write_le32(stream, addstring(chm, chm->TocSitemap->framename));
	else
		chmstream_write_le32(stream, 0);

	/* 3C Offset in the #STRINGS file of the WindowName param of the "text/site properties" object of the sitemap contents (0/-1 == none) */
	if (chm->TocSitemap && chm->TocSitemap->windowname)
		chmstream_write_le32(stream, addstring(chm, chm->TocSitemap->windowname));
	else
		chmstream_write_le32(stream, 0);

	chmstream_write_le32(stream, 0);				/* 40 Number of information types. */
	chmstream_write_le32(stream, 0);				/* 44 Unknown. Often 1. Also 0, 3. */
	chmstream_write_le32(stream, count);			/* 48 Number of files in the [MERGE FILES] list. */

	/* 4C Unknown. Often 0. Non-zero mostly in files with some files in the merge files list. */
	chmstream_write_le32(stream, count > 0 ? 1 : 0);

	for (l = chm->mergefiles; l; l = l->next)
		chmstream_write_le32(stream, addstring(chm, (const char *)l->data));

	for (i = 0; i < CHM_IDXHDR_MAXFILES - count; i++)
		chmstream_write_le32(stream, 0);
	
	ITSFWriter_PostAddStreamToArchive(&chm->itsf, "/#IDXHDR", stream, TRUE, FALSE);
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteFiftiMain(ChmWriter *chm)
{
	ChmSearchWriter *SearchWriter;

	if (ChmStream_Size(chm->TopicsStream) == 0)
		return;
	SearchWriter = ChmSearchWriter_Create(chm->FiftiMainStream, chm->IndexedFiles, chm->locale_id, chm->codepage);
	/* do not add an empty $FIftiMain */
	if (!ChmSearchWriter_HasData(SearchWriter))
	{
		chm->FullTextSearchAvailable = FALSE;
		ChmSearchWriter_Destroy(SearchWriter);
		return;
	}
	chm->FullTextSearchAvailable = TRUE;
	ChmSearchWriter_WriteToStream(SearchWriter);
	ChmSearchWriter_Destroy(SearchWriter);

	if (ChmStream_Size(chm->FiftiMainStream) == 0)
		return;

	ITSFWriter_PostAddStreamToArchive(&chm->itsf, "/$FIftiMain", chm->FiftiMainStream, TRUE, FALSE);
}

/*** ---------------------------------------------------------------------- ***/ 

/* this creates the /#SYSTEM file */
static void WriteSYSTEM(ChmWriter *chm)
{
	FileEntryRec entry;
	static char const VersionStr[] = "HHA Version 4.74.8702"; /* does this matter? */
	ChmStream *stream = chm->itsf.Section0;
	uint32_t len;
	
	entry.path.c = "/#SYSTEM";
	entry.Compressed = FALSE;
	entry.searchable = FALSE;
	entry.DecompressedOffset = ChmStream_Tell(stream);

	/* EntryCodeOrder: 10 9 4 2 3 16 6 0 1 5 */
	chmstream_write_le32(stream, 3); /* Version */

	/* Code -> Length -> Data */
	/* 10 */
	chmstream_write_le16(stream, time_t_STAMP_CODE);
	chmstream_write_le16(stream, sizeof(uint32_t));
	chmstream_write_le32(stream, (uint32_t)time(NULL));
	
	/* 9 */
	chmstream_write_le16(stream, COMPILED_BY_CODE);
	len = sizeof(VersionStr);
	chmstream_write_le16(stream, len);
	ChmStream_Write(stream, VersionStr, len);

	/* 4 A struct that is only needed to set if full text search is on. */
	chmstream_write_le16(stream, Language_DBCS_FTS_KLinks_ALinks_FILETIME_CODE);
	chmstream_write_le16(stream, 36); /* size */

	chmstream_write_le32(stream, chm->locale_id);
	chmstream_write_le32(stream, chm->dbcs);
	chmstream_write_le32(stream, chm->FullTextSearch & chm->FullTextSearchAvailable);
	chmstream_write_le32(stream, chm->HasKLinks);
	chmstream_write_le32(stream, chm->HasALinks);
	{
		uint64_t timestamp;
		struct timeval tv;
		gettimeofday(&tv, NULL);
		timestamp = (((uint64_t)tv.tv_sec * 1000000UL + tv.tv_usec) * 10) + NT_TICKS_1601_TO_1970;
		chmstream_write_le64(stream, timestamp);
	}
	chmstream_write_le32(stream, 0);
	chmstream_write_le32(stream, 0);


	/* 2	default page to load */
	if (chm->default_page)
	{
		len = strlen(chm->default_page) + 1;
		chmstream_write_le16(stream, Default_topic_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, chm->default_page, len);
	}

	/* 3	Title */
	if (chm->title)
	{
		len = strlen(chm->title) + 1;
		chmstream_write_le16(stream, Title_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, chm->title, len);
	}

	/* 16 Default Font */
	if (chm->default_font)
	{
		len = strlen(chm->default_font) + 1;
		chmstream_write_le16(stream, Default_Font_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, chm->default_font, len);
	}

	/* 6 */
	/* unneeded. if output file is :	/somepath/OutFile.chm the value here is outfile(lowercase) */
	{
		char *tmp = changefileext(chm_basename(ChmStream_GetFilename(chm->itsf.OutStream)), NULL);
		len = strlen(tmp) + 1;
		chmstream_write_le16(stream, Compiled_file_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, tmp, len);
		g_free(tmp);
	}

	/* 0 Table of contents filename */
	if (chm->HasTOC)
	{
		const char *tmp;
		if (empty(chm->toc_filename))
			tmp = defaulthhc;
		else
			tmp = chm->toc_filename;
		len = strlen(tmp) + 1;
		chmstream_write_le16(stream, Contents_file_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, tmp, len);
	}

	/* 1 */
	/* hhk Index */
	if (chm->HasIndex)
	{
		const char *tmp;
		if (empty(chm->index_filename))
			tmp = defaulthhk;
		else
			tmp = chm->index_filename;
		len = strlen(tmp) + 1;
		chmstream_write_le16(stream, Index_file_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, tmp, len);
	}

	/* 5 Default Window */
	if (chm->default_window)
	{
		len = strlen(chm->default_window) + 1;
		chmstream_write_le16(stream, Default_Window_CODE);
		chmstream_write_le16(stream, len);
		ChmStream_Write(stream, chm->default_window, len);
	}

	/* 7 Binary Index */
	if (chm->HasBinaryIndex)
	{
		chmstream_write_le16(stream, Binary_Index_CODE);
		chmstream_write_le16(stream, sizeof(uint32_t));
		chmstream_write_le32(stream, 0); /* what is this number to be? */
	}

	/* 11 Binary TOC */
	if (chm->HasBinaryTOC)
	{
		chmstream_write_le16(stream, Binary_TOC_CODE);
		chmstream_write_le16(stream, sizeof(uint32_t));
		chmstream_write_le32(stream, 0); /* what is this number to be? */
	}

	/* 13 */
	len = ChmStream_Size(chm->IDXHdrStream);
	if (len > 0)
	{
		chmstream_write_le16(stream, IDXHDR_FILE_CODE);
		chmstream_write_le16(stream, len);
		if (ChmStream_Seek(chm->IDXHdrStream, 0) == FALSE) {}
		if (ChmStream_CopyFrom(stream, chm->IDXHdrStream, len) == FALSE) {}
	}

	/* ABBREVIATIONS_N_EXPLANATIONS_CODE */
	/* NUM_INFORMATION_TYPES_CODE */
	/* Custom_tabs_CODE */
	/* INFORMATION_TYPE_CHECKSUM_CODE */
	
	entry.DecompressedSize = ChmStream_Tell(stream) - entry.DecompressedOffset;
	FileEntryList_AddEntry(chm->itsf.InternalFiles, &entry, TRUE);
}

/*** ---------------------------------------------------------------------- ***/ 

/* This is an empty and useless file */
static void WriteITBITS(ChmWriter *chm)
{
	FileEntryRec entry;
	
	entry.path.c = "/#ITBITS";
	entry.Compressed = FALSE;
	entry.searchable = FALSE;
	entry.DecompressedOffset = 0; /* ChmStream_Tell(chm->itsf.Section0); */
	entry.DecompressedSize = 0;

	FileEntryList_AddEntry(chm->itsf.InternalFiles, &entry, TRUE);
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteIVB(ChmWriter *chm)
{
	if (chm->ContextStream == NULL)
		return;

	if (ChmStream_Seek(chm->ContextStream, 0) == FALSE) {}
	/* the size of all the entries */
	chmstream_write_le32(chm->ContextStream, ChmStream_Size(chm->ContextStream) - 4);

	ITSFWriter_AddStreamToArchive(&chm->itsf, "/#IVB", chm->ContextStream, TRUE, FALSE);
}

/*** ---------------------------------------------------------------------- ***/ 

static void WriteOBJINST(ChmWriter *chm)
{
	int i;
	ChmMemoryStream *ObjStream;

	ObjStream = ChmStream_CreateMem(0);
	
	/* this file is needed to enable searches for the ms reader */
	chmstream_write_le32(ObjStream, 0x04000000);
	chmstream_write_le32(ObjStream, 2); /* two entries */

	chmstream_write_le32(ObjStream, 24); /* offset into file of entry */
	chmstream_write_le32(ObjStream, 2691); /* size */

	chmstream_write_le32(ObjStream, 2715); /* offset into file of entry */
	chmstream_write_le32(ObjStream, 36); /* size */

	/* first entry */
	/* write guid 4662DAAF-D393-11D0-9A56-00C04FB68BF7 */
	chmstream_write_le32(ObjStream, 0x4662DAAF);
	chmstream_write_le16(ObjStream, 0xD393);
	chmstream_write_le16(ObjStream, 0x11D0);
	chmstream_write_le16(ObjStream, 0x569A);
	ChmStream_fputc(ObjStream, 0x00);
	ChmStream_fputc(ObjStream, 0xC0);
	ChmStream_fputc(ObjStream, 0x4F);
	ChmStream_fputc(ObjStream, 0xB6);
	ChmStream_fputc(ObjStream, 0x8B);
	ChmStream_fputc(ObjStream, 0xF7);

	chmstream_write_le32(ObjStream, 0x04000000);
	chmstream_write_le32(ObjStream, 11);	/* bit flags */
	chmstream_write_le32(ObjStream, chm->codepage);
	chmstream_write_le32(ObjStream, chm->locale_id);
	chmstream_write_le32(ObjStream, 0x00000000);
	chmstream_write_le32(ObjStream, 0x00000000);
	chmstream_write_le32(ObjStream, 0x00145555);
	chmstream_write_le32(ObjStream, 0x00000A0F);
	chmstream_write_le16(ObjStream, 0x0100);
	chmstream_write_le32(ObjStream, 0x00030005);
	for (i = 0; i < 6; i++)
		chmstream_write_le32(ObjStream, 0x00000000);
	chmstream_write_le16(ObjStream, 0x0000);
	/* okay now the fun stuff */
	for (i = 0; i < 256; i++)
		ChmStream_Write(ObjStream, ObjInstEntries[i], sizeof(TObjInstEntry));
#if 0
	{
		int Flags;
		
		if (i == 1)
			Flags = 7;
		else
			Flags = 0;
		if (i >= 0x41 && i <= 0x5A)
			Flags |= 2;
		if (i >= 0x61 && i <= 0x7A)
			Flags |= 1;
		if (i == 0x27)
			Flags |= 6;
		chmstream_write_le16(ObjStream, Flags);
		chmstream_write_le16(ObjStream, i);
		if (i >= 0x41 && i <= 0x5A)
			ChmStream_fputc(ObjStream, i+0x20);
		else
			ChmStream_fputc(ObjStream, i);
		ChmStream_fputc(ObjStream, i);
		ChmStream_fputc(ObjStream, i);
		ChmStream_fputc(ObjStream, i);
		chmstream_write_le16(ObjStream, 0x0000);
	}
#endif
	chmstream_write_le32(ObjStream, 0xE66561C6);
	chmstream_write_le32(ObjStream, 0x73DF6561);
	chmstream_write_le32(ObjStream, 0x656F8C73);
	chmstream_write_le16(ObjStream, 0x6F9C);
	ChmStream_fputc(ObjStream, 0x65);

	/* third bit of second entry */
	/* write guid 8FA0D5A8-DEDF-11D0-9A61-00C04FB68BF7 */
	chmstream_write_le32(ObjStream, 0x8FA0D5A8);
	chmstream_write_le16(ObjStream, 0xDEDF);
	chmstream_write_le16(ObjStream, 0x11D0);
	chmstream_write_le16(ObjStream, 0x619A);
	ChmStream_fputc(ObjStream, 0x00);
	ChmStream_fputc(ObjStream, 0xC0);
	ChmStream_fputc(ObjStream, 0x4F);
	ChmStream_fputc(ObjStream, 0xB6);
	ChmStream_fputc(ObjStream, 0x8B);
	ChmStream_fputc(ObjStream, 0xF7);

	chmstream_write_le32(ObjStream, 0x04000000);
	chmstream_write_le32(ObjStream, 1);
	chmstream_write_le32(ObjStream, chm->codepage);
	chmstream_write_le32(ObjStream, chm->locale_id);
	chmstream_write_le32(ObjStream, 0);

	/* second entry */
	/* write guid 4662DAB0-D393-11D0-9A56-00C04FB68B66 */
	chmstream_write_le32(ObjStream, 0x4662DAB0);
	chmstream_write_le16(ObjStream, 0xD393);
	chmstream_write_le16(ObjStream, 0x11D0);
	chmstream_write_le16(ObjStream, 0x569A);
	ChmStream_fputc(ObjStream, 0x00);
	ChmStream_fputc(ObjStream, 0xC0);
	ChmStream_fputc(ObjStream, 0x4F);
	ChmStream_fputc(ObjStream, 0xB6);
	ChmStream_fputc(ObjStream, 0x8B);
	ChmStream_fputc(ObjStream, 0x66);

	chmstream_write_le32(ObjStream, 666); /* not kidding */
	chmstream_write_le32(ObjStream, chm->codepage);
	chmstream_write_le32(ObjStream, chm->locale_id);
	chmstream_write_le32(ObjStream, 10031);
	chmstream_write_le32(ObjStream, 0);

	ITSFWriter_AddStreamToArchive(&chm->itsf, "/$OBJINST", ObjStream, TRUE, FALSE);
	ChmStream_Close(ObjStream);
}

/*** ---------------------------------------------------------------------- ***/ 

static void CheckFileMakeSearchable(ChmWriter *chm, ChmStream *stream, const FileEntryRec *entry)
{
	if (entry->searchable)
	{
		const char *title = IndexedWordList_IndexFile(chm->IndexedFiles, stream, NextTopicIndex(chm), chm->SearchTitlesOnly);
		ChmWriter_AddTopic(chm, title, entry->path.c, -1);
	}
}

/*** ---------------------------------------------------------------------- ***/ 

static void ChmWriter_FileAdded(ITSFWriter *itsf, ChmStream *stream, const FileEntryRec *entry)
{
	ChmWriter *chm = (ChmWriter *) itsf;
	ITSFWriter_FileAdded(&chm->itsf, stream, entry);
	if (chm->FullTextSearch)
		CheckFileMakeSearchable(chm, stream, entry);
}

/*** ---------------------------------------------------------------------- ***/ 

static void ChmWriter_WriteFinalCompressedFiles(ITSFWriter *itsf)
{
	ChmWriter *chm = (ChmWriter *) itsf;
	ITSFWriter_WriteFinalCompressedFiles(&chm->itsf);
	WriteTOPICS(chm);
	WriteURL_STR_TBL(chm);
	WriteWINDOWS(chm);
	WriteIDXHDR(chm);
	WriteSTRINGS(chm);
	WriteFiftiMain(chm);
}

/*** ---------------------------------------------------------------------- ***/ 

static void ChmWriter_WriteInternalFilesAfter(ITSFWriter *itsf)
{
	ChmWriter *chm = (ChmWriter *) itsf;
	/* This creates and writes the #ITBITS (empty) file to section0 */
	WriteITBITS(chm);
	/* This creates and writes the #SYSTEM file to section0 */
	WriteSYSTEM(chm);
}

/*** ---------------------------------------------------------------------- ***/ 

static void ChmWriter_WriteInternalFilesBefore(ITSFWriter *itsf)
{
	ChmWriter *chm = (ChmWriter *) itsf;
	ITSFWriter_WriteInternalFilesBefore(&chm->itsf);
	WriteIVB(chm);
	WriteOBJINST(chm);
}

/*** ---------------------------------------------------------------------- ***/

void ChmWriter_Execute(ChmWriter *chm)
{
	ITSFWriter_Execute(&chm->itsf);
}

/*** ---------------------------------------------------------------------- ***/

void ChmWriter_SetWindows(ChmWriter *chm, const GSList *windows)
{
	chm->windows = windows;
}

/*** ---------------------------------------------------------------------- ***/

void ChmWriter_SetMergefiles(ChmWriter *chm, const GSList *mergefiles)
{
	chm->mergefiles = mergefiles;
}

/*** ---------------------------------------------------------------------- ***/

void ChmWriter_AddContext(ChmWriter *chm, HelpContext context, const char *topic)
{
	uint32_t offset;
	
	if (chm->ContextStream == NULL)
	{
		chm->ContextStream = ChmStream_CreateMem(0);
		/* #IVB starts with a dword which is the size of the stream - sizeof(dword) */
		chmstream_write_le32(chm->ContextStream, 0);
		/* we will update this when we write the file to the final stream */
	}
	/* an entry is a context id and then the offset of the name of the topic in the strings file */
	chmstream_write_le32(chm->ContextStream, context);
	offset = addstring(chm, topic);
	chmstream_write_le32(chm->ContextStream, offset);
}

/*** ---------------------------------------------------------------------- ***/

void ChmWriter_AppendTOC(ChmWriter *chm, ChmStream *stream)
{
	const char *name;
	char *tmp;
	
	chm->HasTOC = TRUE;
	if (empty(chm->toc_filename))
		name = defaulthhc;
	else
		name = chm->toc_filename;
	tmp = g_strconcat("/", name, NULL);
	ITSFWriter_PostAddStreamToArchive(&chm->itsf, tmp, stream, TRUE, FALSE);
	g_free(tmp);
}

/*** ---------------------------------------------------------------------- ***/ 

#if 0
static gboolean FixParentBookFirstChildOffset(ChmStream *EntryInfoStream, ChmSiteMapItems *MenuItems)
{
	uint32_t ChildOffset;
	uint32_t FirstChildOffset;
	
	ChildOffset = ChmStream_Tell(EntryInfoStream);
	/* read parent entry */
	if (ChmStream_Seek(EntryInfoStream, MenuItems->internaldata + 20) == FALSE)
		return FALSE;
	/* update child offset */
	FirstChildOffset = 4096 + ChildOffset;
	/* write back to stream */
	chmstream_write_le32(EntryInfoStream, FirstChildOffset);
	/* move to end of stream */
	if (ChmStream_Seek(EntryInfoStream, ChildOffset) == FALSE)
		return FALSE;
	return TRUE;
}
#endif

/*** ---------------------------------------------------------------------- ***/ 

struct bintocinfo {
	ChmMemoryStream *EntryInfoStream;
	ChmMemoryStream *EntryTopicOffsetStream;
	ChmMemoryStream *EntryStream;

	ChmMemoryStream *TOCIDXStream;
	uint32_t EntryCount;
	uint32_t HeaderSize;
};

/*** ---------------------------------------------------------------------- ***/ 

static void writeentries(ChmWriter *chm, ChmSiteMapItems *MenuItems, struct bintocinfo *bininfo, uint32_t parentoffset)
{
	TOCEntryPageBookInfo EntryInfo;
	int i, count;
	ChmSiteMapItem *MenuItem;
	uint32_t pos_NextPageBookOffset;
	
	count = ChmSiteMapItems_GetCount(MenuItems);
	for (i = 0; i < count; i++)
	{
		MenuItem = ChmSiteMapItems_GetItem(MenuItems, i);
		/* first figure out the props */
		EntryInfo.Props = 0;
		if (ChmSiteMapItems_GetCount(MenuItem->children) > 0)
			EntryInfo.Props |= TOC_ENTRY_HAS_CHILDREN;
		if (!empty(MenuItem->local))
			EntryInfo.Props |= TOC_ENTRY_HAS_LOCAL;

		if (EntryInfo.Props & TOC_ENTRY_HAS_LOCAL)
		{
			TocEntry entry;
			TopicEntry topicentry;
			
			/* Write #TOPICS entry */
			topicentry.TocOffset = bininfo->HeaderSize + (uint32_t)ChmStream_Tell(bininfo->EntryInfoStream);
			topicentry.StringsOffset = addstring(chm, MenuItem->name);
			topicentry.URLTableOffset = addurl(chm, MenuItem->local, NextTopicIndex(chm));
			topicentry.InContents = 2;
			topicentry.Unknown = 0;
			EntryInfo.TopicsIndexOrStringsOffset = NextTopicIndex(chm);
			
			chmstream_write_le32(chm->TopicsStream, topicentry.TocOffset);
			chmstream_write_le32(chm->TopicsStream, topicentry.StringsOffset);
			chmstream_write_le32(chm->TopicsStream, topicentry.URLTableOffset);
			chmstream_write_le16(chm->TopicsStream, topicentry.InContents);
			chmstream_write_le16(chm->TopicsStream, topicentry.Unknown);
			
			chmstream_write_le32(bininfo->EntryTopicOffsetStream, EntryInfo.TopicsIndexOrStringsOffset);

			/* write TOCEntry */
			entry.PageBookInfoOffset = bininfo->HeaderSize + (uint32_t)ChmStream_Tell(bininfo->EntryInfoStream);
			entry.IncrementedInt = bininfo->EntryCount + 0x29a;
			entry.TopicsOffset = 0; /* FIXME */
			entry.TopicsIndex = EntryInfo.TopicsIndexOrStringsOffset;
			chmstream_write_le32(bininfo->EntryStream, entry.PageBookInfoOffset);
			chmstream_write_le32(bininfo->EntryStream, entry.IncrementedInt);
			chmstream_write_le32(bininfo->EntryStream, entry.TopicsOffset);
			chmstream_write_le32(bininfo->EntryStream, entry.TopicsIndex);
			++bininfo->EntryCount;
		} else
		{
			EntryInfo.TopicsIndexOrStringsOffset = addstring(chm, MenuItem->name);
		}

		/* write TOCEntryInfo */

		EntryInfo.Unknown1 = 0;
		EntryInfo.EntryIndex = bininfo->EntryCount; /* who knows how useful any of this is */
		EntryInfo.ParentPageBookInfoOffset = parentoffset;
		EntryInfo.Unknown3 = 0;
	
		/* write to stream */
		chmstream_write_le16(bininfo->EntryInfoStream, EntryInfo.Unknown1);
		chmstream_write_le16(bininfo->EntryInfoStream, EntryInfo.EntryIndex);
		chmstream_write_le32(bininfo->EntryInfoStream, EntryInfo.Props);
		chmstream_write_le32(bininfo->EntryInfoStream, EntryInfo.TopicsIndexOrStringsOffset);
		chmstream_write_le32(bininfo->EntryInfoStream, EntryInfo.ParentPageBookInfoOffset);
		pos_NextPageBookOffset = (uint32_t)ChmStream_Tell(bininfo->EntryInfoStream);
		chmstream_write_le32(bininfo->EntryInfoStream, 0); /* NextPageBookOffset; will be updated below */

		if (ChmSiteMapItems_GetCount(MenuItem->children) > 0)
		{
			/* Only if TOC_ENTRY_HAS_CHILDREN is set are these written */
			chmstream_write_le32(bininfo->EntryInfoStream, bininfo->HeaderSize + pos_NextPageBookOffset + 12);
			chmstream_write_le32(bininfo->EntryInfoStream, EntryInfo.Unknown3);
			writeentries(chm, MenuItem->children, bininfo, bininfo->HeaderSize + (uint32_t)ChmStream_Tell(bininfo->EntryInfoStream));
		}
		
		/*
		 * now update the offset to the next entry
		 */
		if (ChmStream_Seek(bininfo->EntryInfoStream, pos_NextPageBookOffset) == FALSE) {}
		if ((i + 1) == count)
			EntryInfo.NextPageBookOffset = 0;
		else
			EntryInfo.NextPageBookOffset = bininfo->HeaderSize + ChmStream_Tell(bininfo->EntryInfoStream);
		chmstream_write_le32(bininfo->EntryInfoStream, EntryInfo.NextPageBookOffset);

		if (ChmStream_Seek(bininfo->EntryInfoStream, ChmStream_Size(bininfo->EntryInfoStream)) == FALSE) {}
		
	}
}

/*** ---------------------------------------------------------------------- ***/ 

void ChmWriter_AppendBinaryTOCFromSiteMap(ChmWriter *chm, ChmSiteMap *sitemap)
{
	TOCIdxHeader header;
	struct bintocinfo bininfo;
	
	memset(&header, 0, sizeof(header));
	/* create streams */
	bininfo.TOCIDXStream = ChmStream_CreateMem(0);
	bininfo.EntryInfoStream = ChmStream_CreateMem(0);
	bininfo.EntryTopicOffsetStream = ChmStream_CreateMem(0);
	bininfo.EntryStream = ChmStream_CreateMem(0);
	bininfo.EntryCount = 0;
	bininfo.HeaderSize = 4096;
	
	if (ChmSiteMapItems_GetCount(sitemap->items) > 0)
		writeentries(chm, sitemap->items, &bininfo, 0);

	/* write all streams to TOCIdxStream and free everything */
	if (ChmStream_Seek(bininfo.EntryInfoStream, 0) == FALSE) {}
	if (ChmStream_Seek(bininfo.EntryTopicOffsetStream, 0) == FALSE) {}
	if (ChmStream_Seek(bininfo.EntryStream, 0) == FALSE) {}

	header.EntryInfoOffset = bininfo.HeaderSize;
	header.EntriesOffset = bininfo.HeaderSize + ChmStream_Size(bininfo.EntryInfoStream) + ChmStream_Size(bininfo.EntryTopicOffsetStream);
	header.EntriesCount = bininfo.EntryCount;
	header.TopicsOffset = bininfo.HeaderSize + ChmStream_Size(bininfo.EntryInfoStream);
	chmstream_write_le32(bininfo.TOCIDXStream, header.EntryInfoOffset);
	chmstream_write_le32(bininfo.TOCIDXStream, header.EntriesOffset);
	chmstream_write_le32(bininfo.TOCIDXStream, header.EntriesCount);
	chmstream_write_le32(bininfo.TOCIDXStream, header.TopicsOffset);
	ChmStream_Write(bininfo.TOCIDXStream, header.EmptyBytes, sizeof(header.EmptyBytes));

	ChmStream_CopyFrom(bininfo.TOCIDXStream, bininfo.EntryInfoStream, ChmStream_Size(bininfo.EntryInfoStream));
	ChmStream_Close(bininfo.EntryInfoStream);

	ChmStream_CopyFrom(bininfo.TOCIDXStream, bininfo.EntryTopicOffsetStream, ChmStream_Size(bininfo.EntryTopicOffsetStream));
	ChmStream_Close(bininfo.EntryTopicOffsetStream);

	ChmStream_CopyFrom(bininfo.TOCIDXStream, bininfo.EntryStream, ChmStream_Size(bininfo.EntryStream));
	ChmStream_Close(bininfo.EntryStream);

	ITSFWriter_AddStreamToArchive(&chm->itsf, "/#TOCIDX", bininfo.TOCIDXStream, TRUE, FALSE);
	ChmStream_Close(bininfo.TOCIDXStream);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/ 
/******************************************************************************/

#define put_le16(p, w) \
	*p++ = (uint8_t)(w), \
	*p++ = (uint8_t)((w) >> 8)

#define put_le32(p, w) \
	*p++ = (uint8_t)(w), \
	*p++ = (uint8_t)((w) >> 8), \
	*p++ = (uint8_t)((w) >> 16), \
	*p++ = (uint8_t)((w) >> 24)

#define DefBlocksize 2048

typedef uint8_t IndexBlock[DefBlocksize];

struct binidxinfo {
	ChmWriter *chm;
	ChmMemoryStream *IndexStream;
	IndexBlock curblock;		/* current listing block being built */
	IndexBlock testblock;		/* each entry is first built here. then moved to curblock */
	int curind;					/* next byte to write in testblock. */
	int blocknr;				/* blocknr of block in testblock; */
	int lastblock;				/* blocknr of last block. */
	int entries;				/* Number of entries in this block so far */
	int totalentries;			/* Total number of entries */
	int mapentries;
	int mapindex;
	int indexblocknr;
	int blockind;				/* next byte to write in blockn[blocknr] */
	int blockentries;			/* entries so far ins blockn[blocknr] */
	uint8_t *blockn;
	int blockn_len;
	uint8_t *blocknplus1;
	int blocknplus1_len;
	int mod13value;				/* A value that is increased by 13 for each entry. (?!?!) */
	gboolean entrytoindex;		/* helper var to make sure the first block is always indexed. */
	int blocknplusindex;		/* blocks in level n+1 (second part) */
	int blocknplusentries;		/* The other blocks indexed on creation. */
	ChmMemoryStream *datastream;
	ChmMemoryStream *mapstream;
	ChmMemoryStream *propertystream;
};

/*** ---------------------------------------------------------------------- ***/ 

static void preparecurrentblock(struct binidxinfo *info, gboolean force)
{
	uint8_t *p;
	
	p = info->curblock;
	memset(p, 0, DefBlocksize);
	put_le16(p, DefBlocksize - info->curind);
	put_le16(p, info->entries);
	put_le32(p, info->lastblock);
	if (force && info->blocknr == 0)	/* only one listblock -> no indexblocks. */
		put_le32(p, -1);
	else
		put_le32(p, info->blocknr);
	ChmStream_Write(info->IndexStream, info->curblock, DefBlocksize);
	memset(p, 0, DefBlocksize);
	chmstream_write_le32(info->mapstream, info->mapentries);
	chmstream_write_le32(info->mapstream, info->blocknr);
	info->mapentries = info->totalentries;
	info->curind = SIZEOF_BTREEBLOCKHEADER; 	/* index into current block; */
	info->lastblock = info->blocknr;
	++info->blocknr;
	info->entries = 0;
}

/*** ---------------------------------------------------------------------- ***/ 

static void prepareindexblockn(struct binidxinfo *info, int listingblocknr)
{
	uint8_t *p;
	
	p = &info->blockn[info->indexblocknr * DefBlocksize];
	put_le16(p, DefBlocksize - info->blockind);
	put_le16(p, info->blockentries);

	++info->indexblocknr;
	info->blockentries = 0;
	info->blockind = 0;
	if (info->indexblocknr >= info->blockn_len)
	{
		info->blockn = g_renew(uint8_t, info->blockn, (info->blockn_len + 1) * DefBlocksize);
		memset(info->blockn + info->blockn_len * DefBlocksize, 0, DefBlocksize);
		info->blockn_len++;
	}
	p = &info->blockn[info->indexblocknr * DefBlocksize] + 4;
	put_le16(p, listingblocknr);
	info->blockind = SIZEOF_BTREEINDEXBLOCKHEADER;
}

/*** ---------------------------------------------------------------------- ***/ 

static void finalizeindexblockn(uint8_t *p, int ind, int xEntries)
{
	put_le16(p, DefBlocksize - ind);
	put_le16(p, xEntries);
}

/*** ---------------------------------------------------------------------- ***/ 

static void CurEntryToIndex(struct binidxinfo *info, int entrysize)
{
	uint8_t *p;
	uint8_t *pentry;
	int indexentrysize;
	
	indexentrysize = entrysize - 4; 				/* index entry is 4 bytes shorter, and only the last dword differs */
	if ((info->blockind + indexentrysize) >= DefBlocksize)
		prepareindexblockn(info, info->blocknr);
	p = &info->blockn[info->indexblocknr * DefBlocksize] + info->blockind;
	memcpy(p, info->testblock, indexentrysize);
	pentry = p + indexentrysize - 4;				/* ptr to last dword */
	put_le32(pentry, info->blocknr); 				/* patch up the "index of child field" */
	info->blockind += indexentrysize;
}

/*** ---------------------------------------------------------------------- ***/ 

static void CreateEntry(struct binidxinfo *info, const ChmSiteMapItem *item, const chm_wchar_t *str, int commaatposition)
{
	uint8_t *p;
	uint32_t topicid;
	int seealso;
	int entrysize;
	int i;

	static uint8_t const DataEntry[13] = { 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00 };

	++info->totalentries;
	memset(info->testblock, 0, DefBlocksize);
	p = info->testblock;
	for (i = 0; str[i] != 0; i++)
	{
		put_le16(p, str[i]);		/* write the wstr in little endian */
	}
	put_le16(p, 0); 				/* NT */
#if 0
	/* no seealso for now */
	if (item->seealso)
		seealso = 2;
	else
#endif
		seealso = 0;
	put_le16(p, seealso); 				/* ==0 not a see also 2 ==seealso */
	put_le16(p, 0); 					/* Entrydepth.  We can't know it, so write 2. */
	put_le32(p, commaatposition);		/* position of the comma */
	put_le32(p, 0);						/* unused 0 */
	put_le32(p, 1);						/* for now only one local pair. */
	topicid = ChmWriter_AddTopic(info->chm, item->name, item->local, -1);
	put_le32(p, topicid);
	/* if seealso then _here_ a wchar NT string with seealso? */
	put_le32(p, 1);					/* always 1 (unknown); */
	put_le32(p, info->mod13value); 	/* a value that increments with 13. */
	info->mod13value += 13;
	entrysize = (int)(p - info->testblock);
	if ((info->curind + entrysize) >= DefBlocksize)
	{
		preparecurrentblock(info, FALSE);
		info->entrytoindex = TRUE;
	}
	if (info->entrytoindex)
	{
		CurEntryToIndex(info, entrysize);
		info->entrytoindex = FALSE;
	}
	memcpy(&info->curblock[info->curind], info->testblock, entrysize);
	info->curind += entrysize;
	ChmStream_Write(info->datastream, DataEntry, sizeof(DataEntry));
	++info->entries;
}

/*** ---------------------------------------------------------------------- ***/ 

static void MoveIndexEntry(struct binidxinfo *info, int nr, int bytes, int childblock)
{
	uint8_t *psrc;
	uint8_t *pdest;
	
	if ((info->blockind + bytes) >= DefBlocksize)
	{
		finalizeindexblockn(&info->blocknplus1[info->blocknplusindex * DefBlocksize], info->blockind, info->blocknplusentries);
		++info->blocknplusindex;
		if (info->blocknplusindex >= info->blocknplus1_len)
		{
			info->blocknplus1 = g_renew(uint8_t, info->blocknplus1, (info->blocknplus1_len + 1) * DefBlocksize);
			memset(info->blocknplus1 + info->blocknplus1_len * DefBlocksize, 0, DefBlocksize);
			info->blocknplus1_len += 1;
		}
		info->blockind = SIZEOF_BTREEINDEXBLOCKHEADER;
		pdest = &info->blocknplus1[info->blocknplusindex * DefBlocksize + 4];
		put_le32(pdest, childblock);	/* init 2nd level index to first 1st level index block */
	}

	/* copy entry from one indexblock to another */
	psrc = &info->blockn[nr * DefBlocksize + SIZEOF_BTREEINDEXBLOCKHEADER];
	pdest = &info->blocknplus1[info->blocknplusindex * DefBlocksize + info->blockind];
	memcpy(pdest, psrc, bytes);
	pdest += bytes - 4;
	put_le32(pdest, childblock); 	/* correcting the childindex */
	info->blockind += bytes;
	++info->blocknplusentries; /* not needed for writing, but used to check if something has been written. End condition */
}

/*** ---------------------------------------------------------------------- ***/ 

#define get_le32(var, p) \
	var = ((uint32_t)((p)[3]) << 24) | ((uint32_t)((p)[2]) << 16) | ((uint32_t)((p)[1]) << 8) | (uint32_t)((p)[0]), p += 4

static int ScanIndexBlock(uint8_t *blk)
{
	uint8_t *start;
	int n;
	int i;

	start = &blk[SIZEOF_BTREEINDEXBLOCKHEADER];
	blk = start;
	while (blk[0] != 0 || blk[1] != 0) 	/* skip wchar */
		blk += 2;
	blk += 2;					/* skip NT */
	blk += 2;					/* skip see also */
	blk += 2;					/* skip depth */
	blk += 4; 					/* skip Character Index. */
	blk += 4; 					/* skip always 0 */
	get_le32(n, blk);			/* get nr of pairs. */
	for (i = 0; i < n; i++)
		blk += 4; 				/* skip <n> topicids */
	blk += 4; 					/* skip childindex */
	return (int)(blk - start);
}

/*** ---------------------------------------------------------------------- ***/ 

static void CombineWithChildren(struct binidxinfo *info, ChmSiteMapItem *ParentItem, const chm_wchar_t *str, int commaatposition, gboolean first)
{
	int i, count;
	ChmSiteMapItem *item;

	count = ChmSiteMapItems_GetCount(ParentItem->children);
	if (count == 0)
	{
		/* comment/fix next */
		/* 	if commatposition==length(str) then commaatposition = 0; */
		if (first)
			CreateEntry(info, ParentItem, str, 0);
		else
			CreateEntry(info, ParentItem, str, commaatposition);
	} else
	{
		for (i = 0; i < count; i++)
		{
			chm_wchar_t *tmp;
			size_t len, len1, len2;
			chm_wchar_t *wtext;
			
			item = ChmSiteMapItems_GetItem(ParentItem->children, i);
			tmp = chm_utf8_to_wchar(item->name, STR0TERM, NULL);
			len1 = chm_wcslen(str);
			len2 = chm_wcslen(tmp);
			len = len1 + 2 + len2 + 1;
			wtext = g_new(chm_wchar_t, len);
			memcpy(wtext, str, len1 * sizeof(chm_wchar_t));
			wtext[len1++] = ',';
			wtext[len1++] = ' ';
			memcpy(wtext + len1, tmp, len2 * sizeof(chm_wchar_t));
			wtext[len1 + len2] = 0;
			g_free(tmp);
			if (first)
				CombineWithChildren(info, item, wtext, commaatposition + 2, FALSE);
			else
				CombineWithChildren(info, item, wtext, commaatposition, FALSE);
			g_free(wtext);
		}
	}
}

/*** ---------------------------------------------------------------------- ***/ 

static void AddDummyALink(ChmWriter *chm)
{
	ChmMemoryStream *stream;

	stream = ChmStream_CreateMem(4);
	chmstream_write_le32(stream, 0);
	ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWAssociativeLinks/Property", stream, TRUE, FALSE);
	ChmStream_Close(stream);
}

/*** ---------------------------------------------------------------------- ***/ 

void ChmWriter_AppendBinaryIndexFromSiteMap(ChmWriter *chm, ChmSiteMap *sitemap, gboolean chw)
{
	int i, count;
	chm_wchar_t *key;
	ChmSiteMapItem *item;
	int listingblocks;
	int entrybytes;
	int treedepth;
	struct binidxinfo _info;
	struct binidxinfo *info = &_info;
	uint8_t *p;
	
	static uint8_t const AlwaysX44[16] = { 'X', '4', '4', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

	memset(info, 0, sizeof(*info));
	info->chm = chm;
	
	info->IndexStream = ChmStream_CreateMem(0);
	ChmStream_Write(info->IndexStream, info->curblock, SIZEOF_BTREEHEADER);
	
	info->datastream = ChmStream_CreateMem(0);
	info->mapstream  = ChmStream_CreateMem(0);
	chmstream_write_le16(info->mapstream, 0);
	info->propertystream	= ChmStream_CreateMem(0);
	chmstream_write_le32(info->propertystream, 0);
	
	/* we iterate over all entries and write listingblocks directly to the stream. */
	/* and the first (and maybe last) level is written to blockn. */
	/* we can't do higher levels yet because we don't know how many listblocks we get */
	info->blocknr = 0;  /* current block number */
	info->lastblock = -1;	/* previous block nr or -1 if none. */
	info->entries = 0;  /* entries in this block */
	info->totalentries = 0;  /* entries so far. */
	info->mod13value = 0;  /* value that increments by 13 entirely. */
	info->indexblocknr = 0;  /* nr of first index block. */
	info->blockentries = 0;  /* entries into current block; */
	info->mapentries = 0;  /* entries before the current listing block, for MAP file */
	treedepth = 0;

	info->curind = SIZEOF_BTREEBLOCKHEADER; 		/* index into current listing block; */
	info->blockind = SIZEOF_BTREEINDEXBLOCKHEADER; /* index into current index block */

	info->blockn_len = 1;
	info->blockn = g_new0(uint8_t, info->blockn_len * DefBlocksize);
	info->entrytoindex = TRUE;

	count = ChmSiteMapItems_GetCount(sitemap->items);
	for (i = 0; i < count; i++)
	{
		size_t klen;
		item = ChmSiteMapItems_GetItem(sitemap->items, i);
		key = chm_utf8_to_wchar(item->name, STR0TERM, &klen);

		CombineWithChildren(info, item, key, klen, TRUE);
		g_free(key);
	}
	preparecurrentblock(info, TRUE);		/* flush last listing block. */

	listingblocks = info->blocknr;	/* blocknr is from now on the number of the first block in blockn. */

	/* we still need the # of listingblocks for the header though */
	/* we have now created and written the listing blocks, and created the first level of index in <blockn> */
	/* the following loop uses <blockn> to calculate the next level (in blocknplus1), then write out blockn, */
	/* and repeat until we have no entries left. */

	/* First we finalize the current set of blocks */
	if (info->blocknr > 1)
	{
		if (info->blockind != SIZEOF_BTREEINDEXBLOCKHEADER)
		{
			finalizeindexblockn(&info->blockn[info->indexblocknr * DefBlocksize], info->blockind, info->blockentries);
			++info->indexblocknr;
		}

		while (info->indexblocknr > 1)
		{
			info->blockind = SIZEOF_BTREEINDEXBLOCKHEADER;
			/* init 2nd level index to first 1st level index block */
			p = info->blockn + 4;
			put_le32(p, listingblocks);
			info->blocknplusindex = 0;
			info->blocknplusentries = 0;
			if (info->blocknplus1_len < 1)
			{
				info->blocknplus1_len = 1;
				info->blocknplus1 = g_new0(uint8_t, info->blocknplus1_len * DefBlocksize);
			}

			info->entrytoindex = TRUE;
			for (i = 0; i < info->indexblocknr; i++)
			{
				entrybytes = ScanIndexBlock(&info->blockn[i * DefBlocksize]);
				MoveIndexEntry(info, i, entrybytes, info->blocknr + i);
				ChmStream_Write(info->IndexStream, &info->blockn[i * DefBlocksize], DefBlocksize);
			}

			if (info->blockind != SIZEOF_BTREEINDEXBLOCKHEADER)
			{
				finalizeindexblockn(&info->blocknplus1[info->blocknplusindex * DefBlocksize], info->blockind, info->blocknplusentries);
				++info->blocknplusindex;
			}

			info->blocknr += info->indexblocknr;

			info->indexblocknr = info->blocknplusindex;
			memcpy(info->blockn, info->blocknplus1, info->blocknplus1_len * DefBlocksize);
			info->blocknplus1_len = 1;

			++treedepth;
		}
		ChmStream_Write(info->IndexStream, info->blockn, DefBlocksize);
		++info->blocknr;
	}

	/* Fixup header. */
	if (ChmStream_Seek(info->IndexStream, 0) == FALSE) {}
	ChmStream_fputc(info->IndexStream, 0x3B);
	ChmStream_fputc(info->IndexStream, 0x29);
	chmstream_write_le16(info->IndexStream, 2);						/* bit $2 is always 1, bit $0400 1 if dir? (always on) */
	chmstream_write_le16(info->IndexStream, DefBlocksize); /* size of blocks (2048) */
	ChmStream_Write(info->IndexStream, AlwaysX44, 16);				/* "X44" always the same, see specs. */
	chmstream_write_le32(info->IndexStream, 0); 					/* always 0 */
	chmstream_write_le32(info->IndexStream, listingblocks - 1);		/* index of last listing block in the file; */
	chmstream_write_le32(info->IndexStream, info->blocknr - 1);		/* Index of the root block in the file. */
	chmstream_write_le32(info->IndexStream, -1); 					/* always -1 */
	chmstream_write_le32(info->IndexStream, info->blocknr); 		/* Number of blocks */
	chmstream_write_le16(info->IndexStream, treedepth); 			/* The depth of the tree of blocks (1 if no index blocks, 2 one level of index blocks, ...) */
	chmstream_write_le32(info->IndexStream, info->totalentries);	/* number of keywords in the file. */
	chmstream_write_le32(info->IndexStream, chm->codepage); 		/* Windows code page identifier (usually 1252 - Windows 3.1 US (ANSI)) */
	chmstream_write_le32(info->IndexStream, chm->locale_id);		/* LCID from the HHP file. */
	chmstream_write_le32(info->IndexStream, !chw); 					/* 0 if this a BTREE and is part of a CHW file, 1 if it is a BTree and is part of a CHI or CHM file */
	chmstream_write_le32(info->IndexStream, 10031);					/* Unknown. Almost always 10031. Also 66631 (accessib.chm, ieeula.chm, iesupp.chm, iexplore.chm, msoe.chm, mstask.chm, ratings.chm, wab.chm). */
	chmstream_write_le32(info->IndexStream, 0); 					/* unknown 0 */
	chmstream_write_le32(info->IndexStream, 0); 					/* unknown 0 */
	chmstream_write_le32(info->IndexStream, 0); 					/* unknown 0 */

	AddDummyALink(chm);
	if (chw)
	{
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/BTREE", info->IndexStream, TRUE, FALSE);
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/DATA", info->datastream, TRUE, FALSE);
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/MAP", info->mapstream, TRUE, FALSE);
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/PROPERTY", info->propertystream, TRUE, FALSE);
	} else
	{
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/BTree", info->IndexStream, TRUE, FALSE);
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/Data", info->datastream, TRUE, FALSE);
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/Map", info->mapstream, TRUE, FALSE);
		ITSFWriter_AddStreamToArchive(&chm->itsf, "/$WWKeywordLinks/Property", info->propertystream, TRUE, FALSE);
	}
	ChmStream_Close(info->IndexStream);
	ChmStream_Close(info->propertystream);
	ChmStream_Close(info->mapstream);
	ChmStream_Close(info->datastream);
	
	chm->HasKLinks = info->totalentries > 0;
}

/*** ---------------------------------------------------------------------- ***/ 

void ChmWriter_AppendIndex(ChmWriter *chm, ChmStream *stream)
{
	const char *name;
	char *tmp;
	
	chm->HasIndex = TRUE;
	if (empty(chm->index_filename))
		name = defaulthhk;
	else
		name = chm->index_filename;
	tmp = g_strconcat("/", name, NULL);
	ITSFWriter_PostAddStreamToArchive(&chm->itsf, tmp, stream, TRUE, FALSE);
	g_free(tmp);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/ 
/******************************************************************************/

static int compare_strings(const void *s1, const void *s2)
{
	const StringIndex *n1 = (const StringIndex *)s1;
	const StringIndex *n2 = (const StringIndex *)s2;
	return ChmCompareText(n1->TheString, n2->TheString);
}

static int compare_urlstr(const void *s1, const void *s2)
{
	const UrlStrIndex *n1 = (const UrlStrIndex *)s1;
	const UrlStrIndex *n2 = (const UrlStrIndex *)s2;
	return ChmCompareText(n1->UrlStr, n2->UrlStr);
}

ChmWriter *ChmWriter_Create(ChmStream *OutStream, gboolean FreeStreamOnDestroy)
{
	ChmWriter *chm;
	
	if (OutStream == NULL)
	{
		errno = EINVAL;
		return NULL;
	}
	chm = g_new0(ChmWriter, 1);
	if (chm == NULL)
		return NULL;
	
	ITSFWriter_Init(&chm->itsf, OutStream, FreeStreamOnDestroy);
	chm->itsf.WriteFinalCompressedFiles = ChmWriter_WriteFinalCompressedFiles;
	chm->itsf.WriteInternalFilesAfter = ChmWriter_WriteInternalFilesAfter;
	chm->itsf.WriteInternalFilesBefore = ChmWriter_WriteInternalFilesBefore;
	chm->itsf.FileAdded = ChmWriter_FileAdded;
	chm->StringsStream = ChmStream_CreateMem(0);
	chm->TopicsStream = ChmStream_CreateMem(0);
	chm->URLSTRStream = ChmStream_CreateMem(0);
	chm->FiftiMainStream = ChmStream_CreateMem(0);
	chm->IndexedFiles = IndexedWordList_Create();
	chm->AVLTopicdedupe = AVLTree_Create(compare_strings, (GDestroyNotify)StringIndex_Destroy);
	chm->AvlStrings = AVLTree_Create(compare_strings, (GDestroyNotify)StringIndex_Destroy);
	chm->AvlURLStr = AVLTree_Create(compare_urlstr, (GDestroyNotify)UrlStrIndex_Destroy);
	chm->IDXHdrStream = ChmStream_CreateMem(4096);
	chm->locale_id = MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US);
	chm->codepage = 1252;
	
	return chm;
}

/*** ---------------------------------------------------------------------- ***/

void ChmWriter_Destroy(ChmWriter *chm)
{
	if (chm == NULL)
		return;
	ChmStream_Close(chm->ContextStream);
	chm->mergefiles = NULL;
	IndexedWordList_Destroy(chm->IndexedFiles);
	ChmStream_Close(chm->StringsStream);
	ChmStream_Close(chm->TopicsStream);
	ChmStream_Close(chm->URLSTRStream);
	ChmStream_Close(chm->URLTBLStream);
	ChmStream_Close(chm->FiftiMainStream);
	ChmStream_Close(chm->IDXHdrStream);
	AVLTree_Destroy(chm->AvlURLStr);
	AVLTree_Destroy(chm->AvlStrings);
	AVLTree_Destroy(chm->AVLTopicdedupe);
	chm->windows = NULL;
	g_free(chm->title);
	g_free(chm->default_window);
	g_free(chm->toc_filename);
	g_free(chm->index_filename);
	g_free(chm->default_font);
	g_free(chm->default_page);
	ITSFWriter_Destroy(&chm->itsf);
}
