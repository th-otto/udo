#ifndef __CHMSEARCHWRITER_H__
#define __CHMSEARCHWRITER_H__ 1

#include "htmlindexer.h"

typedef struct _ChmSearchWriter ChmSearchWriter;

void ChmSearchWriter_WriteToStream(ChmSearchWriter *writer);
gboolean ChmSearchWriter_HasData(ChmSearchWriter *writer);
ChmSearchWriter *ChmSearchWriter_Create(ChmSearchWriter *writer, ChmStream *stream, IndexedWordList *WordList);
void ChmSearchWriter_Destroy(ChmSearchWriter *writer);

#endif /* __CHMSEARCHWRITER_H__ */
