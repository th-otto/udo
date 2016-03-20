#ifndef __CHMSEARCHREADER_H__
#define __CHMSEARCHREADER_H__ 1

#include "htmlindexer.h"
#include "chmreader.h"

typedef struct _ChmSearchReader ChmSearchReader;

ChmSearchReader *ChmSearchReader_Create(ChmReader *reader);
void ChmSearchReader_Destroy(ChmSearchReader *reader);

typedef struct _ChmWLCTopic { 
	uint32_t TopicIndex;
	const char *topic;
	uint32_t NumLocationCodes;
	uint32_t *LocationCodes;
} ChmWLCTopic;
typedef ChmWLCTopic *ChmWLCTopicArray;

gboolean ChmSearchReader_LookupWord(ChmSearchReader *chm, const char *word, ChmWLCTopicArray *TitleHits, ChmWLCTopicArray *WordHits, gboolean StartsWith);
void ChmSearchReader_FreeTopics(ChmWLCTopicArray topics);

typedef void (*ChmSearchReaderFoundDataEvent)(void *obj, const char *word, gboolean title, const ChmWLCTopicArray hits);

gboolean ChmSearchReader_DumpData(ChmSearchReader *chm, ChmSearchReaderFoundDataEvent proc, void *obj);

#endif /* __CHMSEARCHREADER_H__ */
