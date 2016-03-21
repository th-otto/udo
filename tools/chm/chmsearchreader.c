#include "chmtools.h"
#include "chmsearchreader.h"
#include "chmfiftimain.h"

struct _ChmSearchReader {
/* private: */
	ChmStream *stream;
	ChmReader *reader;
	gboolean FileIsValid;
	FiftiMainHeader HeaderRec;
	uint32_t ActiveNodeStart;
	uint16_t ActiveNodeFreeSpace;
	uint32_t NextLeafNode;
};

#undef Max
#define Max(a, b) ((a) > (b) ? (a) : (b))
#undef Min
#define Min(a, b) ((a) < (b) ? (a) : (b))

#define FIFTIMAIN "/$FIftiMain"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static uint32_t GetCompressedIntegerBE(ChmStream *stream)
{
	int c;
	uint32_t value = 0;
	int shift = 0;
	
	do
	{
		c = ChmStream_fgetc(stream);
		if (c == EOF)
			return 0;
		value |= (c & 0x7F) << shift;
		shift += 7;
	} while ((c & 0x80) != 0);
	return value;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmSearchReader_ReadCommonData(ChmSearchReader *chm)
{
	ChmStream *stream = chm->stream;
	int i;
	
	if (!ChmStream_Seek(stream, 0))
		return FALSE;
	chm->HeaderRec.sig = chmstream_read_le32(stream);
	chm->FileIsValid = chm->HeaderRec.sig == 0x00280000;
	CHM_DEBUG_LOG(1, "%s: sig: $%08x\n", FIFTIMAIN, chm->HeaderRec.sig);

	if (!chm->FileIsValid)
		return FALSE;

	chm->HeaderRec.HTMLFilesCount = chmstream_read_le32(stream);

	/* root node address */
	chm->HeaderRec.RootNodeOffset = chmstream_read_le32(stream);
	chm->HeaderRec.unknown1 = chmstream_read_le32(stream);
	chm->HeaderRec.LeafNodeCount = chmstream_read_le32(stream);
	chm->HeaderRec.CopyOfRootNodeOffset = chmstream_read_le32(stream);

	/* Tree Depth */
	chm->HeaderRec.TreeDepth = chmstream_read_le16(stream);
	chm->HeaderRec.unknown2 = chmstream_read_le32(stream);

	/* Root sizes for scale and root integers */
	chm->HeaderRec.DocIndexScale = ChmStream_fgetc(stream);
	chm->HeaderRec.DocIndexRootSize = ChmStream_fgetc(stream);
	chm->HeaderRec.CodeCountScale = ChmStream_fgetc(stream);
	chm->HeaderRec.CodeCountRootSize = ChmStream_fgetc(stream);
	chm->HeaderRec.LocationCodeScale = ChmStream_fgetc(stream);
	chm->HeaderRec.LocationCodeRootSize = ChmStream_fgetc(stream);
	for (i = 0; i < 10; i++)
		chm->HeaderRec.unknown3[i] = ChmStream_fgetc(stream);

	chm->HeaderRec.NodeSize = chmstream_read_le32(stream);
	chm->HeaderRec.unknown4 = chmstream_read_le32(stream);
	chm->HeaderRec.LastDupWordIndex = chmstream_read_le32(stream);
	chm->HeaderRec.LastDupCharIndex = chmstream_read_le32(stream);
	chm->HeaderRec.LongestWordLength = chmstream_read_le32(stream);
	chm->HeaderRec.TotalWordsIndexed = chmstream_read_le32(stream);
	chm->HeaderRec.TotalWords = chmstream_read_le32(stream);
	chm->HeaderRec.TotalWordsLengthPart1 = chmstream_read_le32(stream);
	chm->HeaderRec.TotalWordsLengthPart2 = chmstream_read_le32(stream);
	chm->HeaderRec.TotalWordsLength = chmstream_read_le32(stream);
	chm->HeaderRec.WordBlockUnusedBytes = chmstream_read_le32(stream);
	chm->HeaderRec.unknown5 = chmstream_read_le32(stream);
	chm->HeaderRec.HTMLFilesCountMinusOne = chmstream_read_le32(stream);
	for (i = 0; i < 24; i++)
		chm->HeaderRec.unknown6[i] = ChmStream_fgetc(stream);
	chm->HeaderRec.codepage = chmstream_read_le32(stream);
	chm->HeaderRec.locale_id = chmstream_read_le32(stream);
	
	CHM_DEBUG_LOG(1, "%s: HTMFilesCount: %u\n", FIFTIMAIN, chm->HeaderRec.HTMLFilesCount);
	CHM_DEBUG_LOG(1, "%s: RootNodeOffset: $%x\n", FIFTIMAIN, chm->HeaderRec.RootNodeOffset);
	CHM_DEBUG_LOG(1, "%s: unknown1: %u\n", FIFTIMAIN, chm->HeaderRec.unknown1);
	CHM_DEBUG_LOG(1, "%s: LeafNodeCount: %u\n", FIFTIMAIN, chm->HeaderRec.LeafNodeCount);
	CHM_DEBUG_LOG(1, "%s: CopyOfRootNodeOffset: $%x\n", FIFTIMAIN, chm->HeaderRec.CopyOfRootNodeOffset);
	CHM_DEBUG_LOG(1, "%s: TreeDepth: %d\n", FIFTIMAIN, chm->HeaderRec.TreeDepth);
	CHM_DEBUG_LOG(1, "%s: unknown2: $%x\n", FIFTIMAIN, chm->HeaderRec.unknown2);
	CHM_DEBUG_LOG(1, "%s: DocIndexScale: $%x\n", FIFTIMAIN, chm->HeaderRec.DocIndexScale);
	CHM_DEBUG_LOG(1, "%s: DocIndexRootSize: $%x\n", FIFTIMAIN, chm->HeaderRec.DocIndexRootSize);
	CHM_DEBUG_LOG(1, "%s: CodeCountScale: $%x\n", FIFTIMAIN, chm->HeaderRec.CodeCountScale);
	CHM_DEBUG_LOG(1, "%s: CodeCountRootSize: $%x\n", FIFTIMAIN, chm->HeaderRec.CodeCountRootSize);
	CHM_DEBUG_LOG(1, "%s: LocationCodeScale: $%x\n", FIFTIMAIN, chm->HeaderRec.LocationCodeScale);
	CHM_DEBUG_LOG(1, "%s: LocationCodeRootSize: $%x\n", FIFTIMAIN, chm->HeaderRec.LocationCodeRootSize);
	CHM_DEBUG_LOG(1, "%s: unknown3: $%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n", FIFTIMAIN,
		chm->HeaderRec.unknown3[0], chm->HeaderRec.unknown3[1], chm->HeaderRec.unknown3[2],
		chm->HeaderRec.unknown3[3], chm->HeaderRec.unknown3[4], chm->HeaderRec.unknown3[5],
		chm->HeaderRec.unknown3[6], chm->HeaderRec.unknown3[7], chm->HeaderRec.unknown3[8],
		chm->HeaderRec.unknown3[9]);
	CHM_DEBUG_LOG(1, "%s: NodeSize: $%x\n", FIFTIMAIN, chm->HeaderRec.NodeSize);
	CHM_DEBUG_LOG(1, "%s: unknown4: $%x\n", FIFTIMAIN, chm->HeaderRec.unknown4);
	CHM_DEBUG_LOG(1, "%s: LastDupWordIndex: %d\n", FIFTIMAIN, chm->HeaderRec.LastDupWordIndex);
	CHM_DEBUG_LOG(1, "%s: LastDupCharIndex: %d\n", FIFTIMAIN, chm->HeaderRec.LastDupCharIndex);
	CHM_DEBUG_LOG(1, "%s: LongestWordLength: %d\n", FIFTIMAIN, chm->HeaderRec.LongestWordLength);
	CHM_DEBUG_LOG(1, "%s: TotalWordsIndexed: %d\n", FIFTIMAIN, chm->HeaderRec.TotalWordsIndexed);
	CHM_DEBUG_LOG(1, "%s: TotalWords: %d\n", FIFTIMAIN, chm->HeaderRec.TotalWords);
	CHM_DEBUG_LOG(1, "%s: TotalWordsLengthPart1: %d\n", FIFTIMAIN, chm->HeaderRec.TotalWordsLengthPart1);
	CHM_DEBUG_LOG(1, "%s: TotalWordsLengthPart2: %d\n", FIFTIMAIN, chm->HeaderRec.TotalWordsLengthPart2);
	CHM_DEBUG_LOG(1, "%s: TotalWordsLength: %d\n", FIFTIMAIN, chm->HeaderRec.TotalWordsLength);
	CHM_DEBUG_LOG(1, "%s: WordBlockUnusedBytes: %d\n", FIFTIMAIN, chm->HeaderRec.WordBlockUnusedBytes);
	CHM_DEBUG_LOG(1, "%s: unknown5: $%x\n", FIFTIMAIN, chm->HeaderRec.unknown5);
	CHM_DEBUG_LOG(1, "%s: HTMLFilesCountMinusOne: %d\n", FIFTIMAIN, chm->HeaderRec.HTMLFilesCountMinusOne);
	CHM_DEBUG_LOG(1, "%s: unknown6: $%02x %02x %02x %02x %02x %02x %02x %02x\n", FIFTIMAIN,
		chm->HeaderRec.unknown6[0], chm->HeaderRec.unknown6[1], chm->HeaderRec.unknown6[2],
		chm->HeaderRec.unknown6[3], chm->HeaderRec.unknown6[4], chm->HeaderRec.unknown6[5],
		chm->HeaderRec.unknown6[6], chm->HeaderRec.unknown6[7]);
	CHM_DEBUG_LOG(1, "%s: unknown6: $%02x %02x %02x %02x %02x %02x %02x %02x\n", FIFTIMAIN,
		chm->HeaderRec.unknown6[8], chm->HeaderRec.unknown6[9], chm->HeaderRec.unknown6[10],
		chm->HeaderRec.unknown6[11], chm->HeaderRec.unknown6[12], chm->HeaderRec.unknown6[13],
		chm->HeaderRec.unknown6[14], chm->HeaderRec.unknown6[15]);
	CHM_DEBUG_LOG(1, "%s: unknown6: $%02x %02x %02x %02x %02x %02x %02x %02x\n", FIFTIMAIN,
		chm->HeaderRec.unknown6[16], chm->HeaderRec.unknown6[17], chm->HeaderRec.unknown6[18],
		chm->HeaderRec.unknown6[19], chm->HeaderRec.unknown6[20], chm->HeaderRec.unknown6[21],
		chm->HeaderRec.unknown6[23], chm->HeaderRec.unknown6[23]);
	CHM_DEBUG_LOG(1, "%s: codepage: %d\n", FIFTIMAIN, chm->HeaderRec.codepage);
	CHM_DEBUG_LOG(1, "%s: lcid: $%04x %s\n", FIFTIMAIN, chm->HeaderRec.locale_id, get_lcid_string(chm->HeaderRec.locale_id));

	if (chm->HeaderRec.DocIndexScale != 2 || chm->HeaderRec.CodeCountScale != 2 || chm->HeaderRec.LocationCodeScale != 2)
	{
		/* we only can read the files when scale is 2 */
		chm->FileIsValid = FALSE;
		ChmReader_SetError(chm->reader, CHM_ERR_NOT_SUPPORTED_VERSION);
		CHM_DEBUG_LOG(0, "%s: one of the scale parameters has a value other than two, which is not yet supported\n", FIFTIMAIN);
	}

	if (chm->HeaderRec.RootNodeOffset != chm->HeaderRec.CopyOfRootNodeOffset)
	{
		CHM_DEBUG_LOG(0, "%s: the two root index offsets are not equal, dunno which to trust\n", FIFTIMAIN);
	}
	
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmSearchReader_MoveToNode(ChmSearchReader *chm, uint32_t NodeOffset, unsigned int NodeDepth)
{
	ChmStream *stream = chm->stream;

	if (!ChmStream_Seek(stream, NodeOffset))
		return FALSE;
	chm->ActiveNodeStart = NodeOffset;
	if (NodeDepth > 1)
	{
		chm->NextLeafNode = 0;
		/* empty space at end of node */
		chm->ActiveNodeFreeSpace = chmstream_read_le16(stream);
	} else
	{
		chm->NextLeafNode = chmstream_read_le32(stream);
		chmstream_read_le16(stream);
		chm->ActiveNodeFreeSpace = chmstream_read_le16(stream);
	}
	if (chm->ActiveNodeFreeSpace >= chm->HeaderRec.NodeSize)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmSearchReader_MoveToRootNode(ChmSearchReader *chm)
{
	return ChmSearchReader_MoveToNode(chm, chm->HeaderRec.RootNodeOffset, chm->HeaderRec.TreeDepth);
}

/*** ---------------------------------------------------------------------- ***/

static char *ChmSearchReader_ReadWordOrPartialWord(ChmSearchReader *chm, const char *LastWord)
{
	ChmStream *stream = chm->stream;
	uint8_t WordLength = ChmStream_fgetc(stream);
	uint8_t CopyLastWordCharCount = ChmStream_fgetc(stream);
	char *result = NULL;
	
	if (WordLength == 0)
	{
		CHM_DEBUG_LOG(1, "%s: zero new_len\n", FIFTIMAIN);
		return NULL;
	}
	if (LastWord == NULL && CopyLastWordCharCount > 0)
	{
		CHM_DEBUG_LOG(1, "%s: old_len was non-zero at the start of a node\n", FIFTIMAIN);
	}
	result = g_strndup(LastWord, CopyLastWordCharCount);
	if (WordLength > 1)
	{
		size_t len = (WordLength - 1) + CopyLastWordCharCount;
		result = g_renew(char, result, len + 1);
		if (ChmStream_Read(stream, result + CopyLastWordCharCount, WordLength - 1))
			result[len] = '\0';
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmSearchReader_ReadIndexNodeEntry(ChmSearchReader *chm, const char *LastWord, char **word, uint32_t *SubNodeStart)
{
	ChmStream *stream = chm->stream;

	if ((ChmStream_Tell(stream) - chm->ActiveNodeStart) >= (chm->HeaderRec.NodeSize - chm->ActiveNodeFreeSpace))
		return FALSE;
	*word = ChmSearchReader_ReadWordOrPartialWord(chm, LastWord);
	*SubNodeStart = chmstream_read_le32(stream);
	chmstream_read_le16(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmSearchReader_MoveToFirstLeafNode(ChmSearchReader *chm)
{
	uint16_t NodeDepth;
	uint32_t NodeOffset;
	char *LastWord;
	char *NewWord;
	gboolean result;
	
	if (!ChmSearchReader_MoveToRootNode(chm))
		return FALSE;
	NodeDepth = chm->HeaderRec.TreeDepth;
	LastWord = NULL;
	result = TRUE;
	while (result && NodeDepth > 1)
	{
		--NodeDepth;
		if (!ChmSearchReader_ReadIndexNodeEntry(chm, LastWord, &NewWord, &NodeOffset))
		{
			result = FALSE;
			break;
		}
		g_free(LastWord);
		LastWord = NewWord;
		result = ChmSearchReader_MoveToNode(chm, NodeOffset, NodeDepth);
	}
	g_free(LastWord);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean ChmSearchReader_ReadLeafNodeEntry(
	ChmSearchReader *chm,
	const char *LastWord,
	char **word,
	gboolean *intitle,
	uint32_t *wlc_count,
	uint32_t *wlc_offset,
	uint32_t *wlc_length)
{
	ChmStream *stream = chm->stream;
	uint16_t tmp;
	int context;
	
	if ((ChmStream_Tell(stream) - chm->ActiveNodeStart) >= (chm->HeaderRec.NodeSize - chm->ActiveNodeFreeSpace))
		return FALSE;
	*word = ChmSearchReader_ReadWordOrPartialWord(chm, LastWord);
	context = ChmStream_fgetc(stream);
	if (context != 0 && context != 1)
	{
		CHM_DEBUG_LOG(0, "%s: unknown context %d\n", FIFTIMAIN, context);
	}
	*intitle = context == 1;
	*wlc_count = GetCompressedIntegerBE(stream);
	*wlc_offset = chmstream_read_le32(stream);
	tmp = chmstream_read_le16(stream);
	if (tmp != 0)
	{
		CHM_DEBUG_LOG(1, "%s: warning: an unknown field was non-zero: $%x\n", FIFTIMAIN, tmp);
	}
	*wlc_length = GetCompressedIntegerBE(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

typedef uint32_t SRINT;

struct wlc {
	uint8_t *p;
	uint32_t remaining;
	uint8_t *end;
	int bit;
};

/*
 find the first unset bit in memory
 return the number of set bits found
 return -1 if the buffer runs out before we find an unset bit
*/
static int ffus(struct wlc *wlc)
{
	int bits = 0;

	while (*wlc->p & (1 << wlc->bit))
	{
		/* if( !len-- ) return -1; */
		if (wlc->bit)
			wlc->bit--;
		else
		{
			wlc->p++;
			wlc->bit = 7;
		}
		bits++;
	}
	if (wlc->bit)
	{
		wlc->bit--;
	} else
	{
		wlc->p++;
		wlc->bit = 7;
	}
	return bits;
}


/* read a scale & root encoded integer from memory */
/* Does not yet support s =4, 8, 16, etc */
static SRINT get_SRINT(struct wlc *wlc, /* unsigned int s, */ unsigned int r)
{
	SRINT ret;
	uint8_t mask;
	int n, n_bits, num_bits, base, count;

	if (wlc->bit > 7 /* || s != 2 */)
		return ~(SRINT) 0;
	ret = 0;
	count = ffus(wlc);
	n_bits = n = r + (count ? count - 1 : 0);
	while (n > 0)
	{
		num_bits = n > wlc->bit ? wlc->bit : n - 1;
		base = n > wlc->bit ? 0 : wlc->bit - (n - 1);
		switch (num_bits)
		{
		case 0:
			mask = 1;
			break;
		case 1:
			mask = 3;
			break;
		case 2:
			mask = 7;
			break;
		case 3:
			mask = 0xf;
			break;
		case 4:
			mask = 0x1f;
			break;
		case 5:
			mask = 0x3f;
			break;
		case 6:
			mask = 0x7f;
			break;
		case 7:
			mask = 0xff;
			break;
		default:
			mask = 0xff;
			CHM_DEBUG_LOG(2, "warning: impossible condition found reading s/r int\n");
			break;
		}
		mask <<= base;
		ret = (ret << (num_bits + 1)) | (SRINT) ((*wlc->p & mask) >> base);
		if (n > wlc->bit)
		{
			wlc->p++;
			n -= wlc->bit + 1;
			wlc->bit = 7;
		} else
		{
			wlc->bit -= n;
			n = 0;
		}
	}
	if (count)
		ret |= (SRINT) 1 << n_bits;
	return ret;
}


static ChmWLCTopicArray ChmSearchReader_ReadWLCEntries(ChmSearchReader *chm, uint32_t wlc_count, uint32_t wlc_offset, uint32_t wlc_length)
{
	ChmStream *stream = chm->stream;
	uint32_t TopicHits;
	unsigned int i, nonemptycount;
	unsigned int j;
	uint32_t document_index;
	uint32_t location_code;
	struct wlc wlc;
	ChmWLCTopicArray result;
	
	if ((wlc_offset + wlc_length) > ChmStream_Size(stream))
	{
		CHM_DEBUG_LOG(1, "%s: unexpected end of input in word location entries", FIFTIMAIN);
		return NULL;
	}
	result = g_new0(ChmWLCTopic, wlc_count + 1);
	if (result == NULL)
		return NULL;
	wlc.remaining = wlc_length;
	wlc.p = ChmStream_Memptr(stream) + wlc_offset;
	wlc.end = wlc.p + wlc_length;
	wlc.bit = 7;
	document_index = 0;

	for (i = 0, nonemptycount = 0; i < wlc_count && wlc.p < wlc.end; i++)
	{
		/* Entries are padded to a full byte (usually with zeros) */
		if (wlc.bit != 7)
			wlc.p++;
		wlc.bit = 7;
		document_index += get_SRINT(&wlc, chm->HeaderRec.DocIndexRootSize);
		result[nonemptycount].TopicIndex = document_index;
		result[nonemptycount].topic = ChmReader_LookupTopicByID(chm->reader, document_index, NULL);
		
		TopicHits = get_SRINT(&wlc, chm->HeaderRec.CodeCountRootSize);

		if (TopicHits > 0)
		{
			result[nonemptycount].NumLocationCodes = TopicHits;
			result[nonemptycount].LocationCodes = g_new(uint32_t, TopicHits);
			if (result[nonemptycount].LocationCodes == NULL)
			{
				ChmSearchReader_FreeTopics(result);
				result = NULL;
				break;
			}
			location_code = 0;
			for (j = 0; j < TopicHits; j++)
			{
				location_code += get_SRINT(&wlc, chm->HeaderRec.LocationCodeRootSize);
				result[nonemptycount].LocationCodes[j] = location_code;
			}
			nonemptycount++;
		}
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSearchReader_DumpData(ChmSearchReader *chm, ChmSearchReaderFoundDataEvent proc, void *obj)
{
	char *LastWord;
	char *TheWord;
	gboolean intitle;
	uint32_t wlc_count;
	uint32_t wlc_offset;
	uint32_t wlc_length;
	ChmWLCTopicArray FoundHits;
	gboolean result;
	unsigned int word_i;
	
	if (ChmSearchReader_MoveToFirstLeafNode(chm) == FALSE)
		return FALSE;
	
	LastWord = NULL;
	result = TRUE;
	word_i = 0;
	while (result)
	{
		if (ChmSearchReader_ReadLeafNodeEntry(chm, LastWord, &TheWord, &intitle, &wlc_count, &wlc_offset, &wlc_length) == FALSE)
		{
			if (chm->NextLeafNode != 0)
			{
				g_free(LastWord);
				LastWord = NULL;
				result = ChmSearchReader_MoveToNode(chm, chm->NextLeafNode, 1);
				word_i = 0;
			} else
			{
				break;
			}
		} else
		{
			word_i++;
			g_free(LastWord);
			LastWord = TheWord;
			FoundHits = ChmSearchReader_ReadWLCEntries(chm, wlc_count, wlc_offset, wlc_length);
			if (FoundHits)
			{
				proc(obj, TheWord, intitle, FoundHits);
				ChmSearchReader_FreeTopics(FoundHits);
			}
		}
	}
	g_free(LastWord);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSearchReader_LookupWord(ChmSearchReader *chm, const char *word, ChmWLCTopicArray *TitleHits, ChmWLCTopicArray *WordHits, gboolean StartsWith)
{
	char *LastWord;
	char *NewWord;
	unsigned int NodeLevel;
	uint32_t NewNodePosition;
	gboolean intitle, next_intitle;
	uint32_t wlc_count;
	uint32_t wlc_offset;
	uint32_t wlc_length;
	int CompareResult;
	gboolean ReadNextResult;
	char *aword;
	size_t awordlen;
	gboolean result;
	
	*TitleHits = NULL;
	*WordHits = NULL;
	
	if (chm == NULL)
		return FALSE;
	
	aword = g_strdup(word);
	chm_searchword_downcase(aword);
	awordlen = strlen(aword);
	NodeLevel = chm->HeaderRec.TreeDepth;
	if (!ChmSearchReader_MoveToRootNode(chm))
		return FALSE;
	LastWord = NULL;
	/* descend the index node tree until we find the leafnode */
	result = TRUE;
	while (result && NodeLevel > 1)
	{
		if (ChmSearchReader_ReadIndexNodeEntry(chm, LastWord, &NewWord, &NewNodePosition))
		{
			g_free(LastWord);
			LastWord = NewWord;
			CompareResult = chm_compare_words(NewWord, aword);
			if (CompareResult >= 0)
			{
				g_free(LastWord);
				LastWord = NULL;;
				--NodeLevel;
				result = ChmSearchReader_MoveToNode(chm, NewNodePosition, NodeLevel);
			}
		} else
		{
			break;
		}
	}
	if (NodeLevel > 1 || result == FALSE)
	{
		/* the entry we are looking for is > than the last entry of the last index node */
		g_free(LastWord);
		g_free(aword);
		return result;
	}
	
	/* now we are in a leafnode */
	result = TRUE;
	while (result && ChmSearchReader_ReadLeafNodeEntry(chm, LastWord, &NewWord, &intitle, &wlc_count, &wlc_offset, &wlc_length))
	{
		g_free(LastWord);
		LastWord = NewWord;
		if (strlen(NewWord) < awordlen)
			continue;
	
		if (StartsWith) /* it only has to start with the searched term */
			CompareResult = chm_compare_words_n(aword, NewWord, awordlen);
		else /* it must match exactly */
			CompareResult = chm_compare_words(aword, NewWord);
		if (CompareResult < 0)
			break;
		if (CompareResult == 0)
		{
			if (intitle)
				*TitleHits = ChmSearchReader_ReadWLCEntries(chm, wlc_count, wlc_offset, wlc_length);
			else
				*WordHits = ChmSearchReader_ReadWLCEntries(chm, wlc_count, wlc_offset, wlc_length);
			/* check if the next entry is the same word since there is an entry for titles and for body */
			
			NewWord = NULL;
			if (ChmSearchReader_ReadLeafNodeEntry(chm, LastWord, &NewWord, &next_intitle, &wlc_count, &wlc_offset, &wlc_length))
			{
				ReadNextResult = TRUE;
			} else if (chm->NextLeafNode != 0)
			{
				result = ChmSearchReader_MoveToNode(chm, chm->NextLeafNode, 1);
				g_free(LastWord);
				LastWord = NULL;
				ReadNextResult = ChmSearchReader_ReadLeafNodeEntry(chm, LastWord, &NewWord, &next_intitle, &wlc_count, &wlc_offset, &wlc_length);
			} else
			{
				ReadNextResult = FALSE;
			}
			if (ReadNextResult && chm_compare_words(NewWord, aword) == 0)
			{
				if (intitle == next_intitle)
				{
					CHM_DEBUG_LOG(0, "%s: warning: two entries for same word\n", FIFTIMAIN);
				}
				if (next_intitle)
				{
					ChmSearchReader_FreeTopics(*TitleHits);
					*TitleHits = ChmSearchReader_ReadWLCEntries(chm, wlc_count, wlc_offset, wlc_length);
				} else
				{
					ChmSearchReader_FreeTopics(*WordHits);
					*WordHits = ChmSearchReader_ReadWLCEntries(chm, wlc_count, wlc_offset, wlc_length);
				}
			}
			break;
		}
	}
	g_free(LastWord);
	g_free(aword);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSearchReader_FreeTopics(ChmWLCTopicArray topics)
{
	unsigned int i;
	
	if (topics == NULL)
		return;
	for (i = 0; topics[i].LocationCodes != NULL; i++)
		g_free(topics[i].LocationCodes);
	g_free(topics);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/


ChmSearchReader *ChmSearchReader_Create(ChmReader *r)
{
	ChmSearchReader *reader;
	ChmStream *stream;
	
	if (r == NULL)
		return NULL;
	stream = ChmReader_GetObject(r, FIFTIMAIN);
	if (stream == NULL)
		return NULL;
	reader = g_new0(ChmSearchReader, 1);
	if (reader == NULL)
	{
		ChmStream_Close(stream);
		return NULL;
	}
	reader->stream = stream;
	reader->reader = r;
	
	if (!ChmSearchReader_ReadCommonData(reader))
	{
		ChmSearchReader_Destroy(reader);
		reader = NULL;
	}
	return reader;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSearchReader_Destroy(ChmSearchReader *reader)
{
	if (reader == NULL)
		return;
	ChmStream_Close(reader->stream);
	
	g_free(reader);
}
