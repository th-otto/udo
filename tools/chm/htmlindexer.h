#ifndef __HTMLINDEXER_H__
#define __HTMLINDEXER_H__ 1

#include "avltree.h"

typedef struct _IndexDocument IndexDocument;

IndexDocument *IndexDocument_Create(int DocumentIndex);
void IndexDocument_Destroy(IndexDocument *doc);
int IndexDocument_GetWordIndex(IndexDocument *doc, int i);
void IndexDocument_AddWordIndex(IndexDocument *doc, int index);
int IndexDocument_DocumentIndex(IndexDocument *doc);
int IndexDocument_NumberofIndexEntries(IndexDocument *doc);

typedef struct _IndexedWord IndexedWord;
struct _IndexedWord {
	gboolean IsTitle;
	char *word;			/* converted by chm_searchword_downcase */
	IndexDocument *CachedTopic;
	int documents_count;
	int documents_size;
	IndexDocument **documents;
};

int IndexedWord_DocumentCount(IndexedWord *word);
IndexDocument *IndexedWord_GetLogicalDocument(IndexedWord *word, int index);
gboolean IndexDocument_IsTitle(IndexedWord *word);

typedef struct _IndexedWordList IndexedWordList;
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
	int32_t TopicIndex;
	gboolean IndexTitlesOnly;
};

IndexedWordList *IndexedWordList_Create(void);
void IndexedWordList_Destroy(IndexedWordList *list);

/* returns the documents <Title> */
const char *IndexedWordList_IndexFile(IndexedWordList *list, ChmStream *stream, int32_t TOPICIndex, gboolean IndexOnlyTitles);
typedef void (*IndexedWordList_ForEachProc)(IndexedWordList *list, IndexedWord *word, void *state);
void IndexedWordList_ForEach(IndexedWordList *list, IndexedWordList_ForEachProc proc, void *state);
unsigned int IndexedWordList_FileCount(IndexedWordList *list);

char *chm_searchword_downcase(char *word);
#define chm_compare_words strcmp
#define chm_compare_words_n strncmp

#endif /* __HTMLINDEXER_H__ */
