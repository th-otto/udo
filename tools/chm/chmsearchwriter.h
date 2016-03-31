#ifndef __CHMSEARCHWRITER_H__
#define __CHMSEARCHWRITER_H__ 1

#include "htmlindexer.h"

typedef struct _ChmSearchWriter ChmSearchWriter;

void ChmSearchWriter_WriteToStream(ChmSearchWriter *writer);
gboolean ChmSearchWriter_HasData(ChmSearchWriter *writer);
ChmSearchWriter *ChmSearchWriter_Create(ChmStream *stream, IndexedWordList *WordList, LCID locale_id, int codepage);
void ChmSearchWriter_Destroy(ChmSearchWriter *writer);

#endif /* __CHMSEARCHWRITER_H__ */
