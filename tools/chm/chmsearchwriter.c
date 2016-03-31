#include "chmtools.h"
#include "chmsearchwriter.h"
#include "chmfiftimain.h"

#define FIFTI_NODE_SIZE 4096

#undef Max
#define Max(a, b) ((a) > (b) ? (a) : (b))
#undef Min
#define Min(a, b) ((a) < (b) ? (a) : (b))

struct _ChmSearchWriter {
	FiftiMainHeader HeaderRec;
	ChmStream *stream;
	IndexedWordList *WordList;
	LeafNode *ActiveLeafNode;
};

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static uint32_t FIftiNode_RemainingSpace(ChmSearchWriter *writer, FIftiNode *node)
{
	return writer->HeaderRec.NodeSize - ChmStream_Tell(node->BlockStream);
}

/*** ---------------------------------------------------------------------- ***/

static void FIftiNode_FillRemainingSpace(ChmSearchWriter *writer, FIftiNode *node)
{
	uint32_t remsize = FIftiNode_RemainingSpace(writer, node);
	while (remsize > 0)
	{
		ChmStream_fputc(node->BlockStream, 0);
		remsize--;
	}
}

/*** ---------------------------------------------------------------------- ***/

static void WriteCompressedIntegerBE(ChmStream *stream, uint32_t number)
{
	int bits;
	uint32_t tmp;
	uint8_t buf;

	tmp = number;
	bits = 0;
	while (tmp != 0)
	{
		tmp >>= 1;
		++bits;
	}

	do
	{
		buf = (number >> tmp) & 0x7F;
		if (bits > 7)
			buf |= 0x80;
		bits -= 7;
		tmp += 7;
		ChmStream_fputc(stream, buf);
	} while (bits > 0);
}

/*** ---------------------------------------------------------------------- ***/

static int WriteScaleRootInt(uint32_t number, uint32_t *bits, int root)
{
	uint32_t tmp;
	uint32_t mask;
	int neededbits;
	int prefixbits;
	int rootbits;
	int result;
	
	tmp = number;
	neededbits = 0;
	while (tmp != 0)
	{
		++neededbits;
		tmp >>= 1;
	}
	prefixbits = Max(0, neededbits - root);

	rootbits = neededbits - 1;
	if (rootbits < root)
		rootbits = root;
	if (rootbits < 0)
		rootbits = 0;

	mask = 0;
	if ((rootbits - 1) >= 0)
	{
		for (root = 0; root < rootbits; root++)
			mask |= (uint32_t)1 << root;
	}
	*bits = ~mask;
	*bits <<= 1; /* make space for empty bit */
	*bits |= (number & mask);

	result = prefixbits + 1 + rootbits;
	*bits = (*bits << (32 - result)) >> (32 - result);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static IndexNode *FIftiNode_CreateIndex(ChmSearchWriter *writer, ChmStream *stream)
{
	IndexNode *node;
	
	node = g_new0(IndexNode, 1);
	if (node == NULL)
		return NULL;
	node->node.WriteStream = stream;
	node->node.BlockStream = ChmStream_CreateMem(writer->HeaderRec.NodeSize);
	node->node.OwnsParentNode = FALSE;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static const char *FIftiNode_AdjustedWord(FIftiNode *node, const char *word, uint8_t *offset, const char *oldword)
{
	int count1;
	int count2;
	int count;
	int i;

	UNUSED(node);
	
	count2 = strlen(word);

	if (oldword == NULL || strcmp(word, oldword) == 0)
	{
		*offset = count2;
		return "";
	}
	
	count1 = strlen(oldword);

	if (count1 < count2)
		count = count1;
	else
		count = count2;

	for (i = 0; i < count; i++)
	{
		*offset = i;
		if (oldword[i] != word[i])
			return word + i;
	}
	*offset = 0;
	return word;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean IndexNode_GuessIfCanHold(IndexNode *node, const char *word, ChmSearchWriter *writer)
{
	uint8_t offset;
	
	return (uint32_t)ChmStream_Tell(node->node.BlockStream) + 8 + strlen(FIftiNode_AdjustedWord(&node->node, word, &offset, node->node.LastWord)) < writer->HeaderRec.NodeSize;
}

/*** ---------------------------------------------------------------------- ***/

static void IndexNode_Flush(ChmSearchWriter *writer, IndexNode *node, gboolean NewBlockNeeded);

static void IndexNode_ChildIsFull(ChmSearchWriter *writer, IndexNode *node, const char *word, uint32_t NodeOffset)
{
	uint8_t offset;
	const char *newword;
	uint8_t len;
	
	if (ChmStream_Tell(node->node.BlockStream) == 0)
		chmstream_write_le16(node->node.BlockStream, 0); /* free space at end. updated when the block is flushed */
	if (IndexNode_GuessIfCanHold(node, word, writer) == FALSE)
		IndexNode_Flush(writer, node, TRUE);
	newword = FIftiNode_AdjustedWord(&node->node, word, &offset, node->node.LastWord);
	g_free(node->node.LastWord);
	node->node.LastWord = g_strdup(word);

	/* Write the Index node Entry */
	len = (uint8_t)strlen(newword);
	ChmStream_fputc(node->node.BlockStream, len + 1);
	ChmStream_fputc(node->node.BlockStream, offset);
	ChmStream_Write(node->node.BlockStream, newword, len);
	chmstream_write_le32(node->node.BlockStream, NodeOffset);
	chmstream_write_le16(node->node.BlockStream, 0);
	if ((uint32_t)ChmStream_Tell(node->node.BlockStream) > writer->HeaderRec.NodeSize)
		CHM_DEBUG_LOG(0, "FIFTIMAIN Index node has written past the block!\n");
}

/*** ---------------------------------------------------------------------- ***/

static void IndexNode_Flush(ChmSearchWriter *writer, IndexNode *node, gboolean NewBlockNeeded)
{
	uint32_t remsize;

	if (NewBlockNeeded)
	{
		if (node->node.ParentNode == NULL)
		{
			node->node.ParentNode = FIftiNode_CreateIndex(writer, node->node.WriteStream);
			node->node.OwnsParentNode = TRUE;
		}
	}

	if (node->node.ParentNode != NULL)
		IndexNode_ChildIsFull(writer, node->node.ParentNode, node->node.LastWord, (uint32_t)ChmStream_Tell(node->node.WriteStream));

	remsize = FIftiNode_RemainingSpace(writer, &node->node);
	FIftiNode_FillRemainingSpace(writer, &node->node);
	if (ChmStream_Seek(node->node.BlockStream, 0) == FALSE) {}
	chmstream_write_le16(node->node.BlockStream, remsize);

	if (ChmStream_Seek(node->node.BlockStream, 0) == FALSE) {}

	ChmStream_CopyFrom(node->node.WriteStream, node->node.BlockStream, writer->HeaderRec.NodeSize);
	if (ChmStream_Seek(node->node.BlockStream, 0) == FALSE) {}

	node->node.LastWord = NULL;

	if (NewBlockNeeded)
		chmstream_write_le16(node->node.BlockStream, 0); /* placeholder to write free space in when block is full */
	else if (node->node.ParentNode != NULL)
		IndexNode_Flush(writer, node->node.ParentNode, NewBlockNeeded);
}

/*** ---------------------------------------------------------------------- ***/

static LeafNode *FIftiNode_CreateLeaf(ChmSearchWriter *writer, ChmStream *stream)
{
	LeafNode *node;
	
	node = g_new0(LeafNode, 1);
	if (node == NULL)
		return NULL;
	node->node.WriteStream = stream;
	node->node.BlockStream = ChmStream_CreateMem(writer->HeaderRec.NodeSize);
	node->node.OwnsParentNode = FALSE;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean LeafNode_GuessIfCanHold(LeafNode *node, const char *word, ChmSearchWriter *writer)
{
	uint8_t wordoffset;
	
	return 17 + strlen(FIftiNode_AdjustedWord(&node->node, word, &wordoffset, node->node.LastWord)) < FIftiNode_RemainingSpace(writer, &node->node);
}

/*** ---------------------------------------------------------------------- ***/

static void LeafNode_Flush(ChmSearchWriter *writer, LeafNode *node, gboolean NewBlockNeeded)
{
	uint32_t tmppos;
	
	++node->LeafNodeCount;
	tmppos = ChmStream_Tell(node->node.WriteStream);
	/* update the previous leaf node about our position. */
	if (node->LastNodeStart > 0)
	{
		if (ChmStream_Seek(node->node.WriteStream, node->LastNodeStart) == FALSE) {}
		chmstream_write_le32(node->node.WriteStream, tmppos);
		if (ChmStream_Seek(node->node.WriteStream, tmppos) == FALSE) {}
	}
	node->LastNodeStart = tmppos;

	node->FreeSpace = FIftiNode_RemainingSpace(writer, &node->node);

	FIftiNode_FillRemainingSpace(writer, &node->node);

	/* update the leaf header to show the available space. */
	if (ChmStream_Seek(node->node.BlockStream, 6) == FALSE) {}
	chmstream_write_le16(node->node.BlockStream, node->FreeSpace);

	/* copy the leaf block to the fiftimain file */
	if (ChmStream_Seek(node->node.BlockStream, 0) == FALSE) {}
	ChmStream_CopyFrom(node->node.WriteStream, node->node.BlockStream, writer->HeaderRec.NodeSize);
	if (ChmStream_Seek(node->node.BlockStream, 0) == FALSE) {}

	if (NewBlockNeeded || (!NewBlockNeeded && node->node.ParentNode != NULL))
	{
		if (node->node.ParentNode == NULL)
		{
			node->node.ParentNode = FIftiNode_CreateIndex(writer, node->node.WriteStream);
			node->node.OwnsParentNode = TRUE;
		}
		IndexNode_ChildIsFull(writer, node->node.ParentNode, node->node.LastWord, node->LastNodeStart);
		if (NewBlockNeeded == FALSE)
			IndexNode_Flush(writer, node->node.ParentNode, FALSE);
	}

	node->node.LastWord = NULL;
}

/*** ---------------------------------------------------------------------- ***/

static void LeafNode_WriteInitialHeader(LeafNode *node)
{
	chmstream_write_le32(node->node.BlockStream, 0);
	chmstream_write_le16(node->node.BlockStream, 0);
	chmstream_write_le16(node->node.BlockStream, 0);
}

/*** ---------------------------------------------------------------------- ***/

struct wlc {
	int usedbits;
	uint8_t buf;
	ChmStream *stream;
};

static void FlushBuffer(struct wlc *wlc)
{
	if (wlc->usedbits > 0)
		ChmStream_fputc(wlc->stream, wlc->buf);
	wlc->usedbits = 0;
	wlc->buf = 0;
}

static void AddValue(struct wlc *wlc, uint32_t value, int bitcount)
{
	int neededbits;
	uint8_t tmp;
	int bits;
	
	value = value << (32 - bitcount);
	while (bitcount > 0)
	{
		neededbits = 8 - wlc->usedbits;
		tmp = value >> (wlc->usedbits + 24);
		wlc->buf |= tmp;
		bits = Min(bitcount, neededbits);
		wlc->usedbits += bits;
		value <<= bits;
		bitcount -= bits;

		if (wlc->usedbits == 8)
		{
			ChmStream_fputc(wlc->stream, wlc->buf);
			wlc->usedbits = 0;
			wlc->buf = 0;
		}
	}
}

static uint32_t LeafNode_WriteWLCEntries(LeafNode *node, IndexedWord *word)
{
	int LastDocIndex;
	int LastLocCode;
	int DocDelta;
	int LocDelta;
	uint32_t startpos;
	uint32_t bits;
	int bitcount;
	int i, j;
	IndexDocument *doc;
	struct wlc wlc;
	
	startpos = ChmStream_Tell(node->node.WriteStream);
	LastDocIndex = 0;
	wlc.usedbits = 0;
	wlc.buf = 0;
	wlc.stream = node->node.WriteStream;
	for (i = 0; i < IndexedWord_DocumentCount(word); i++)
	{
		int DocIndex;
		
		LastLocCode = 0;
		doc = IndexedWord_GetLogicalDocument(word, i);
		DocIndex = IndexDocument_DocumentIndex(doc);
		DocDelta = DocIndex - LastDocIndex;
		LastDocIndex = DocIndex;
		bitcount = WriteScaleRootInt(DocDelta, &bits, node->DocRootSize);
		AddValue(&wlc, bits, bitcount);
		bitcount = WriteScaleRootInt(IndexDocument_NumberofIndexEntries(doc), &bits, node->CodeRootSize);
		AddValue(&wlc, bits, bitcount);
	
		for (j = 0; j < IndexDocument_NumberofIndexEntries(doc); j++)
		{
			int LocCode = IndexDocument_GetWordIndex(doc, j);
			LocDelta = LocCode - LastLocCode;
			LastLocCode = LocCode;
			bitcount = WriteScaleRootInt(LocDelta, &bits, node->LocRootSize);
			AddValue(&wlc, bits, bitcount);
		}
		FlushBuffer(&wlc);
	}

	return (uint32_t)ChmStream_Tell(node->node.WriteStream) - startpos;
}

/*** ---------------------------------------------------------------------- ***/

static void LeafNode_AddWord(ChmSearchWriter *writer, LeafNode *node, IndexedWord *word)
{
	uint8_t offset;
	const char *newword;
	uint32_t WLCSize;
	int len;
	
	/* Maximum word length is 99 */
	if (strlen(word->word) > 99)
	{
		return;
	}
	if (ChmStream_Tell(node->node.BlockStream) == 0)
		LeafNode_WriteInitialHeader(node);

	newword = FIftiNode_AdjustedWord(&node->node, word->word, &offset, node->node.LastWord);

	g_free(node->node.LastWord);
	node->node.LastWord = g_strdup(word->word);

	len = strlen(newword);
	ChmStream_fputc(node->node.BlockStream, len + 1);
	ChmStream_fputc(node->node.BlockStream, offset);

	/* length can be 0 if it is the same word as the last. there is a word entry each for title and content */
	if (len > 0)
		ChmStream_Write(node->node.BlockStream, newword, len);

	ChmStream_fputc(node->node.BlockStream, word->IsTitle);
	WriteCompressedIntegerBE(node->node.BlockStream, IndexedWord_DocumentCount(word));
	chmstream_write_le32(node->node.BlockStream, (uint32_t)ChmStream_Tell(node->node.WriteStream));
	chmstream_write_le16(node->node.BlockStream, 0);

	/* write WLC to FWriteStream so we can write the size of the wlc entries */
	WLCSize = LeafNode_WriteWLCEntries(node, word);

	WriteCompressedIntegerBE(node->node.BlockStream, WLCSize);
	if ((uint32_t)ChmStream_Tell(node->node.BlockStream) > writer->HeaderRec.NodeSize)
		CHM_DEBUG_LOG(0, "FIFTIMAIN Leaf node has written past the block!\n");
}

/*** ---------------------------------------------------------------------- ***/

static void ChmSearchWriter_WriteAWord(IndexedWordList *list, IndexedWord *word, void *state)
{
	ChmSearchWriter *writer = (ChmSearchWriter *)state;
	
	UNUSED(list);
	if (writer->ActiveLeafNode == NULL)
	{
		writer->ActiveLeafNode = FIftiNode_CreateLeaf(writer, writer->stream);
		writer->ActiveLeafNode->DocRootSize = writer->HeaderRec.DocIndexRootSize;
		writer->ActiveLeafNode->CodeRootSize = writer->HeaderRec.CodeCountRootSize;
		writer->ActiveLeafNode->LocRootSize = writer->HeaderRec.LocationCodeRootSize;
	}
	if (LeafNode_GuessIfCanHold(writer->ActiveLeafNode, word->word, writer) == FALSE)
	{
		LeafNode_Flush(writer, writer->ActiveLeafNode, TRUE);
	}
	LeafNode_AddWord(writer, writer->ActiveLeafNode, word);
}

/*** ---------------------------------------------------------------------- ***/

static void FIftiNode_Destroy(FIftiNode *node)
{
	if (node == NULL)
		return;
	ChmStream_Close(node->BlockStream);
	if (node->OwnsParentNode)
		FIftiNode_Destroy(&node->ParentNode->node);
	g_free(node);
}

/*** ---------------------------------------------------------------------- ***/

static void ChmSearchWriter_ProcessWords(ChmSearchWriter *writer)
{
	IndexedWordList_ForEach(writer->WordList, ChmSearchWriter_WriteAWord, writer);
	if (writer->ActiveLeafNode != NULL)
		LeafNode_Flush(writer, writer->ActiveLeafNode, FALSE); /* causes the unwritten parts of the tree to be written */
}

/*** ---------------------------------------------------------------------- ***/

static void ChmSearchWriter_WriteHeader(ChmSearchWriter *writer, gboolean IsPlaceHolder)
{
	FIftiNode *TmpNode;
	int i;
	ChmStream *stream = writer->stream;
	
	if (IsPlaceHolder)
	{
		/* the header size. we will fill this after the nodes have been determined */
		for (i = 0; i < 1024; i++)
			ChmStream_fputc(stream, 0);
		return;
	}
	/* write the glorious header */
	writer->HeaderRec.sig = 0x00002800;
	writer->HeaderRec.HTMLFilesCount = IndexedWordList_FileCount(writer->WordList);
	writer->HeaderRec.NodeSize = FIFTI_NODE_SIZE;
	writer->HeaderRec.RootNodeOffset = ChmStream_Size(stream) - writer->HeaderRec.NodeSize;
	writer->HeaderRec.LeafNodeCount = writer->ActiveLeafNode ? writer->ActiveLeafNode->LeafNodeCount : 0;
	writer->HeaderRec.CopyOfRootNodeOffset = writer->HeaderRec.RootNodeOffset;
	writer->HeaderRec.TreeDepth = 0;
	TmpNode = &writer->ActiveLeafNode->node;
	while (TmpNode != NULL)
	{
		++writer->HeaderRec.TreeDepth;
		TmpNode = &TmpNode->ParentNode->node;
	}

	writer->HeaderRec.LongestWordLength = writer->WordList->LongestWord;
	writer->HeaderRec.TotalWordsIndexed = writer->WordList->TotalWordCount;
	writer->HeaderRec.TotalWords = writer->WordList->TotalDifferentWords;
	writer->HeaderRec.TotalWordsLengthPart1 = writer->WordList->TotalWordLength;
	writer->HeaderRec.TotalWordsLength = writer->WordList->TotalDifferentWordLength;
	writer->HeaderRec.unknown2 = 7;
	writer->HeaderRec.LastDupWordIndex = 1;
	writer->HeaderRec.LastDupCharIndex = 5;
	writer->HeaderRec.WordBlockUnusedBytes = writer->ActiveLeafNode ? writer->ActiveLeafNode->FreeSpace : 0;
	
	if (ChmStream_Seek(stream, 0) == FALSE) {}

	chmstream_write_be32(stream, writer->HeaderRec.sig);
	chmstream_write_le32(stream, writer->HeaderRec.HTMLFilesCount);
	chmstream_write_le32(stream, writer->HeaderRec.RootNodeOffset);
	chmstream_write_le32(stream, writer->HeaderRec.unknown1);
	chmstream_write_le32(stream, writer->HeaderRec.LeafNodeCount);
	chmstream_write_le32(stream, writer->HeaderRec.CopyOfRootNodeOffset);
	chmstream_write_le16(stream, writer->HeaderRec.TreeDepth);
	chmstream_write_le32(stream, writer->HeaderRec.unknown2);
	ChmStream_fputc(stream, writer->HeaderRec.DocIndexScale);
	ChmStream_fputc(stream, writer->HeaderRec.DocIndexRootSize);
	ChmStream_fputc(stream, writer->HeaderRec.CodeCountScale);
	ChmStream_fputc(stream, writer->HeaderRec.CodeCountRootSize);
	ChmStream_fputc(stream, writer->HeaderRec.LocationCodeScale);
	ChmStream_fputc(stream, writer->HeaderRec.LocationCodeRootSize);
	for (i = 0; i < 10; i++)
		ChmStream_fputc(stream, writer->HeaderRec.unknown3[i]);
	chmstream_write_le32(stream, writer->HeaderRec.NodeSize);
	chmstream_write_le32(stream, writer->HeaderRec.unknown4);
	chmstream_write_le32(stream, writer->HeaderRec.LastDupWordIndex);
	chmstream_write_le32(stream, writer->HeaderRec.LastDupCharIndex);
	chmstream_write_le32(stream, writer->HeaderRec.LongestWordLength);
	chmstream_write_le32(stream, writer->HeaderRec.TotalWordsIndexed);
	chmstream_write_le32(stream, writer->HeaderRec.TotalWords);
	chmstream_write_le32(stream, writer->HeaderRec.TotalWordsLengthPart1);
	chmstream_write_le32(stream, writer->HeaderRec.TotalWordsLengthPart2);
	chmstream_write_le32(stream, writer->HeaderRec.TotalWordsLength);
	chmstream_write_le32(stream, writer->HeaderRec.WordBlockUnusedBytes);
	chmstream_write_le32(stream, writer->HeaderRec.unknown5);
	chmstream_write_le32(stream, writer->HeaderRec.HTMLFilesCount - 1);
	for (i = 0; i < 24; i++)
		ChmStream_fputc(stream, writer->HeaderRec.unknown6[i]);
	chmstream_write_le32(stream, writer->HeaderRec.codepage);
	chmstream_write_le32(stream, writer->HeaderRec.locale_id);
	for (i = 0; i < 894; i++)
		ChmStream_fputc(stream, writer->HeaderRec.unknown7[i]);
}

/*** ---------------------------------------------------------------------- ***/

void ChmSearchWriter_WriteToStream(ChmSearchWriter *writer)
{
	if (writer == NULL)
		return;
	ChmSearchWriter_WriteHeader(writer, TRUE);
	ChmSearchWriter_ProcessWords(writer);
	ChmSearchWriter_WriteHeader(writer, FALSE);
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmSearchWriter_HasData(ChmSearchWriter *writer)
{
	if (writer == NULL)
		return FALSE;
	return IndexedWordList_FileCount(writer->WordList) > 0;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

ChmSearchWriter *ChmSearchWriter_Create(ChmStream *stream, IndexedWordList *WordList, LCID locale_id, int codepage)
{
	ChmSearchWriter *writer;
	
	writer = g_new0(ChmSearchWriter, 1);
	if (writer == NULL)
		return NULL;
	writer->stream = stream;
	writer->WordList = WordList;
	writer->ActiveLeafNode = NULL;
	writer->HeaderRec.DocIndexScale = 2;
	writer->HeaderRec.DocIndexRootSize = 1;
	writer->HeaderRec.CodeCountScale = 2;
	writer->HeaderRec.CodeCountRootSize = 1;
	writer->HeaderRec.LocationCodeScale = 2;
	writer->HeaderRec.LocationCodeRootSize = 4;
	writer->HeaderRec.locale_id = locale_id;
	writer->HeaderRec.codepage = codepage;
	return writer;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSearchWriter_Destroy(ChmSearchWriter *writer)
{
	if (writer == NULL)
		return;
	FIftiNode_Destroy(&writer->ActiveLeafNode->node);
	g_free(writer);
}
