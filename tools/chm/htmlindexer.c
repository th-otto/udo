#include "chmtools.h"
#include "htmlindexer.h"
#include "fasthtmlparser.h"
#include "avltree.h"

struct _IndexDocument {
	int DocumentIndex;
	int WordIndexCount;
	int WordIndexSize;
	int *WordIndex;
};

struct _IndexedWord {
	gboolean IsTitle;
	char *word;			/* converted by chm_searchword_downcase */
	IndexDocument *CachedTopic;
	int documents_count;
	int documents_size;
	IndexDocument **documents;
};

struct _IndexedWordList {
	unsigned int IndexedFileCount;
	unsigned int TotalDifferentWordLength;
	unsigned int TotalDifferentWords;
	unsigned int TotalWordCount;
	unsigned int TotalWordLength;
	unsigned int LongestWord;
	AVLTree *avltree;
	IndexedWord *spare;

	/* vars while processing page */
	gboolean InTitle;
	gboolean InBody;
	int WordCount;			/* only words in body */
	char *DocTitle;
	int TopicIndex;
	gboolean IndexTitlesOnly;
};


#define GrowSpeed 10

#undef Max
#define Max(a, b) ((a) > (b) ? (a) : (b))

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

char *chm_searchword_downcase(char *word)
{
	/* FIXME: should use something like g_utf8_casefold() or g_utf8_normalize() */
	return g_strdown(word);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static IndexedWord *IndexedWord_Create(const char *wordtext, size_t len, gboolean IsTitle)
{
	IndexedWord *word;
	
	word = g_new(IndexedWord, 1);
	word->IsTitle = IsTitle;
	word->word = g_strndup(wordtext, len);;
	chm_searchword_downcase(word->word);
	word->CachedTopic = NULL;
	word->documents_count = 0;
	word->documents_size = 0;
	word->documents = NULL;
	return word;
}

/*** ---------------------------------------------------------------------- ***/

static void IndexedWord_Destroy(IndexedWord *word)
{
	int i;
	
	if (word == NULL)
		return;
	for (i = 0; i < word->documents_count; i++)
		IndexDocument_Destroy(word->documents[i]);
	g_free(word->documents);
	g_free(word->word);
	g_free(word);
}

/*** ---------------------------------------------------------------------- ***/

int IndexedWord_DocumentCount(IndexedWord *word)
{
	if (word == 0)
		return 0;
	return word->documents_count;
}

/*** ---------------------------------------------------------------------- ***/

gboolean IndexDocument_IsTitle(IndexedWord *word)
{
	return word && word->IsTitle;
}

/*** ---------------------------------------------------------------------- ***/

IndexDocument *IndexedWord_GetLogicalDocument(IndexedWord *word, int index)
{
	if (word == NULL || index < 0 || index >= word->documents_count)
		return NULL;
	return word->documents[index];
}

/*** ---------------------------------------------------------------------- ***/

static IndexDocument *IndexedWord_GetDocument(IndexedWord *word, int TopicIndexNum)
{
	int i;
	IndexDocument *doc;
	
	if (word == NULL)
		return NULL;
	if (word->CachedTopic != NULL && word->CachedTopic->DocumentIndex == TopicIndexNum)
		return word->CachedTopic;

	for (i = 0; i < word->documents_count; i++)
		if (word->documents[i]->DocumentIndex == TopicIndexNum)
			return word->documents[i];
	if (word->documents_count >= word->documents_size)
	{
		const int inc = 1;
		IndexDocument **newdocs = g_renew(IndexDocument *, word->documents, word->documents_size + inc);
		if (newdocs == NULL)
			return NULL;
		word->documents = newdocs;
		word->documents_size += inc;
	}
	doc = IndexDocument_Create(TopicIndexNum);
	if (doc == NULL)
		return NULL;
	word->documents[word->documents_count] = doc;
	word->documents_count++;
	word->CachedTopic = doc;
	return doc;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static int CompareProcObj(const void *node1, const void *node2)
{
	const IndexedWord *n1 = (const IndexedWord *)node1;
	const IndexedWord *n2 = (const IndexedWord *)node2;
	int result = chm_compare_words(n1->word, n2->word);
	if (result == 0)
	{
		result = (int)n2->IsTitle - (int)n1->IsTitle;
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static void IndexedWordList_AddWord(IndexedWordList *list, IndexedWord *word)
{
	AVLTree_Add(list->avltree, word);
}

/*** ---------------------------------------------------------------------- ***/

static IndexedWord *IndexedWordList_AddGetWord(IndexedWordList *list, char *word, size_t len, gboolean IsTitle)
{
	AVLTreeNode *n;
	IndexedWord *result;
		
	if (list->spare == NULL)
	{
		list->spare = IndexedWord_Create(word, len, IsTitle);
	} else
	{
		g_free(list->spare->word);
		list->spare->word = word;
		chm_searchword_downcase(list->spare->word);
		list->spare->IsTitle = IsTitle;
	}
	
	n = AVLTree_Find(list->avltree, list->spare);
	if (n)
	{
		result = (IndexedWord *)n->data;
	} else
	{
		list->TotalDifferentWordLength += len;
		++list->TotalDifferentWords;
		result = list->spare;
		list->spare = NULL;
		IndexedWordList_AddWord(list, result);
	
		list->LongestWord = Max(list->LongestWord, len);
	}
	list->TotalWordLength += len;
	++list->TotalWordCount;
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean IndexedWordList_CBFoundTag(void *obj, const char *tag, size_t len)
{
	IndexedWordList *list = (IndexedWordList *)obj;
	
	if (list->InBody)
	{
		if (g_ascii_strncasecmp(tag, "</BODY>", len) == 0)
			list->InBody = FALSE;
	} else
	{
		if (g_ascii_strncasecmp(tag, "<TITLE>", len) == 0)
			list->InTitle = FALSE;
		else if (g_ascii_strncasecmp(tag, "</TITLE>", len) == 0)
			list->InTitle = TRUE;
		else if (g_ascii_strncasecmp(tag, "<BODY>", len) == 0)
			list->InBody = TRUE;
	}
	if (list->InBody && list->IndexTitlesOnly)
		return TRUE;
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean IsEndOfWord(unsigned char c, gboolean InWord, gboolean IsNumberWord)
{
	gboolean result;
	
	result = (c < 'a' || c > 'z') && (c < 'A' || c > 'Z') && (c < '0' || c > '9') && c != 0x01 && c < 0x80;
	if (result && IsNumberWord)
		result &= c != '.';
	if (result && InWord)
		result &= c != '\'';
	return result;
}

/*** ---------------------------------------------------------------------- ***/

static void IndexedWordList_EatWords(IndexedWordList *list, const char *words, size_t len, gboolean IsTitle)
{
	const char *WordStart;
	const char *WordPtr;
	const char *end;
	gboolean InWord;
	gboolean IsNumberWord;
	IndexedWord *WordIndex;
	
	if (IsTitle)
	{
		g_free(list->DocTitle);
		list->DocTitle = g_strndup(words, len);
	}
	WordStart = words;
	WordPtr = WordStart;
	end = words + len;
	IsNumberWord = FALSE;
	InWord = FALSE;
	while (WordPtr < end)
	{
		if (InWord && IsEndOfWord(*WordPtr, InWord, IsNumberWord))
		{
			size_t len = WordPtr - WordStart;
			char *WordName = g_strndup(WordStart, len);
			char *fpos;
			
			while ((fpos = strchr(WordName, '\'')) != NULL)
			{
				memmove(fpos, fpos + 1, strlen(fpos + 1) + 1);
				len--;
			}
			WordIndex = IndexedWordList_AddGetWord(list, WordName, len, IsTitle);
			InWord = FALSE;
			IsNumberWord = FALSE;
			IndexDocument_AddWordIndex(IndexedWord_GetDocument(WordIndex, list->TopicIndex), list->WordCount);
			++list->WordCount;
		} else if (!InWord && !IsEndOfWord(*WordPtr, InWord, IsNumberWord))
		{
			InWord = TRUE;
			WordStart = WordPtr;
			IsNumberWord = *WordPtr >= '0' && *WordPtr <= '9';
		}
		WordPtr = g_utf8_skipchar(WordPtr);
	}

	if (InWord)
	{
		size_t len = WordPtr - WordStart;
		char *WordName = g_strndup(WordStart, len);
		WordIndex = IndexedWordList_AddGetWord(list, WordName, len, IsTitle);
		IndexDocument_AddWordIndex(IndexedWord_GetDocument(WordIndex, list->TopicIndex), list->WordCount);
		if (!IsTitle)
			++list->WordCount;
	}
}

/*** ---------------------------------------------------------------------- ***/

static gboolean IndexedWordList_CBFoundText(void *obj, const char *text, size_t len)
{
	IndexedWordList *list;

	if (len < 1)
		return FALSE;
	list = (IndexedWordList *)obj;
	IndexedWordList_EatWords(list, text, len, list->InTitle && !list->InBody);
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

void IndexedWordList_ForEach(IndexedWordList *list, IndexedWordList_ForEachProc proc, void *state)
{
	AVLTreeNode *node;
	
	if (list == NULL || proc == 0)
		return;
	node = AVLTree_FindLowest(list->avltree);
	while (node != NULL)
	{
		IndexedWord *word = (IndexedWord *)node->data;
		proc(list, word, state);
		node = AVLTree_FindSuccessor(node);
	}
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

const char *IndexedWordList_IndexFile(IndexedWordList *list, ChmStream *stream, int TOPICIndex, gboolean IndexOnlyTitles)
{
	char *TheFile;
	size_t size;
	HTMLParser *parser;
	const char *title = NULL;
	
	if (ChmStream_Seek(stream, 0) == FALSE)
		return NULL;
	size = ChmStream_Size(stream);
	if (size == 0)
		return NULL;
	TheFile = g_new(char, size + 1);
	if (TheFile == NULL)
		return NULL;
	if (ChmStream_Read(stream, TheFile, size) == FALSE)
	{
		g_free(TheFile);
		return NULL;
	}
	TheFile[size] = '\0';
	parser = HTMLParser_Create(TheFile, size);
	if (parser != NULL)
	{
		list->InBody = FALSE;
		list->InTitle= FALSE;
		list->IndexTitlesOnly = IndexOnlyTitles;
		list->WordCount = 0;
		list->TopicIndex = TOPICIndex;
		list->IndexedFileCount++;
		list->DocTitle = NULL;
		
		parser->OnFoundTag = IndexedWordList_CBFoundTag;
		parser->OnFoundText = IndexedWordList_CBFoundText;
		parser->obj = list;
		HTMLParser_Destroy(parser);
		title = list->DocTitle;
	}
	g_free(TheFile);
	return title;
}

/*** ---------------------------------------------------------------------- ***/

static void DestroyWord(void *data)
{
	IndexedWord *word = (IndexedWord *) data;
	IndexedWord_Destroy(word);
}

/*** ---------------------------------------------------------------------- ***/

IndexedWordList *IndexedWordList_Create(void)
{
	IndexedWordList *list;
	
	list = g_new0(IndexedWordList, 1);
	if (list == NULL)
		return NULL;
	list->avltree = AVLTree_Create(CompareProcObj, DestroyWord);
	return list;
}

/*** ---------------------------------------------------------------------- ***/

void IndexedWordList_Destroy(IndexedWordList *list)
{
	if (list == NULL)
		return;
	AVLTree_Destroy(list->avltree);
	g_free(list->DocTitle);
	DestroyWord(list->spare);
	g_free(list);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

void IndexDocument_Destroy(IndexDocument *doc)
{
	if (doc == NULL)
		return;
	g_free(doc->WordIndex);
	g_free(doc);
}

/*** ---------------------------------------------------------------------- ***/

IndexDocument *IndexDocument_Create(int DocumentIndex)
{
	IndexDocument *doc;
	
	doc = g_new(IndexDocument, 1);
	if (doc == NULL)
		return NULL;
	doc->DocumentIndex = DocumentIndex;
	doc->WordIndexCount = 0;
	doc->WordIndexSize = 0;
	doc->WordIndex = NULL;
	return doc;
}

/*** ---------------------------------------------------------------------- ***/

int IndexDocument_GetWordIndex(IndexDocument *doc, int i)
{
	if (doc != NULL && i >= 0 && i < doc->WordIndexCount)
		return doc->WordIndex[i];
	return -1;
}

/*** ---------------------------------------------------------------------- ***/

int IndexDocument_DocumentIndex(IndexDocument *doc)
{
	if (doc != NULL)
		return doc->DocumentIndex;
	return -1;
}

/*** ---------------------------------------------------------------------- ***/

int IndexDocument_NumberofIndexEntries(IndexDocument *doc)
{
	if (doc != NULL)
		return doc->WordIndexCount;
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

void IndexDocument_AddWordIndex(IndexDocument *doc, int index)
{
	if (doc == NULL || index < 0)
		return;
	if (doc->WordIndexCount >= doc->WordIndexSize)
	{
		const int inc = GrowSpeed;
		int *newindex = g_renew(int, doc->WordIndex, doc->WordIndexSize + inc);
		if (newindex == NULL)
			return;
		doc->WordIndex = newindex;
		doc->WordIndexSize += inc;
	}
	doc->WordIndex[doc->WordIndexCount] = index;
	doc->WordIndexCount++;
}
