#ifndef __HTMLINDEXER_H__
#define __HTMLINDEXER_H__ 1

typedef struct _IndexDocument IndexDocument;

IndexDocument *IndexDocument_Create(int DocumentIndex);
void IndexDocument_Destroy(IndexDocument *doc);
int IndexDocument_GetWordIndex(IndexDocument *doc, int i);
void IndexDocument_AddWordIndex(IndexDocument *doc, int index);
int IndexDocument_DocumentIndex(IndexDocument *doc);
int IndexDocument_NumberofIndexEntries(IndexDocument *doc);

typedef struct _IndexedWord IndexedWord;

int IndexedWord_DocumentCount(IndexedWord *word);
IndexDocument *IndexedWord_GetLogicalDocument(IndexedWord *word, int index);
gboolean IndexDocument_IsTitle(IndexedWord *word);

typedef struct _IndexedWordList IndexedWordList;

IndexedWordList *IndexedWordList_Create(void);
void IndexedWordList_Destroy(IndexedWordList *list);

/* returns the documents <Title> */
const char *IndexedWordList_IndexFile(IndexedWordList *list, ChmStream *stream, int TOPICIndex, gboolean IndexOnlyTitles);
typedef void (*IndexedWordList_ForEachProc)(IndexedWordList *list, IndexedWord *word, void *state);
void IndexedWordList_ForEach(IndexedWordList *list, IndexedWordList_ForEachProc proc, void *state);

char *chm_searchword_downcase(char *word);
#define chm_compare_words strcmp
#define chm_compare_words_n strncmp

#endif /* __HTMLINDEXER_H__ */
