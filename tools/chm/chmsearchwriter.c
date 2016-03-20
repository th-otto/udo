#include "chmtools.h"
#include "chmsearchwriter.h"
#include "chmfiftimain.h"

struct _ChmSearchWriter {
	FiftiMainHeader HeaderRec;
	ChmStream *stream;
	IndexedWordList *WordList;
	FIftiNode *ActiveLeafNode;
};

void ChmSearchWriter_ProcessWords(ChmSearchWriter *writer);
void ChmSearchWriter_WriteHeader(ChmSearchWriter *writer, gboolean IsPlaceHolder);
void ChmSearchWriter_WriteAWord(ChmSearchWriter, IndexedWord *word);
void FIftiNode_FillRemainingSpace(FIftiNode *node);

char *FIftiNode_AdjustedWord(FIftiNode *node, const char *AWord, uint8_t *AOffset, const char *AOldWord);

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static uint32_t TFIftiNode_RemainingSpace(ChmSearchWriter *chm, FIftiNode *node)
{
	return chm->HeaderRec.NodeSize - ChmStream_Tell(node->BlockStream);
}

/*** ---------------------------------------------------------------------- ***/

static IndexNode *FIftiNode_CreateIndex(ChmStream *stream, size_t blocksize)
{
	IndexNode *node;
	
	node = g_new0(IndexNode, 1);
	if (node == NULL)
		return NULL;
	node->node.WriteStream = stream;
	node->node.BlockStream = ChmStream_CreateMem(blocksize);
	node->node.OwnsParentNode = FALSE;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static LeafNode *FIftiNode_CreateLeaf(ChmStream *stream, size_t blocksize)
{
	LeafNode *node;
	
	node = g_new0(LeafNode, 1);
	if (node == NULL)
		return NULL;
	node->node.WriteStream = stream;
	node->node.BlockStream = ChmStream_CreateMem(blocksize);
	node->node.OwnsParentNode = FALSE;
	return node;
}

/*** ---------------------------------------------------------------------- ***/

static void FIftiNode_Destroy(FIftiNode *node)
{
	if (node == NULL)
		return;
	ChmStream_Close(node->BlockStream);
	if (node->OwnsParentNode)
		FIftiNode_Destroy(node->ParentNode);
	g_free(node);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void ChmSearchWriter_Destroy(ChmSearchWriter *writer)
{
	(void) writer;
	(void) TFIftiNode_RemainingSpace;
	(void) FIftiNode_CreateIndex;
	(void) FIftiNode_CreateLeaf;
	(void) FIftiNode_Destroy;
}
