#ifndef __CHMSPECIALFILES_H__
#define __CHMSPECIALFILES_H__ 1

int WriteNameListToStream(ChmStream *stream, SectionNames sectionnames);
int WriteControlDataToStream(ChmStream *stream, uint32_t LZXResetInterval, uint32_t WindowSize, uint32_t CacheSize);
int WriteSpanInfoToStream(ChmStream *stream, uint64_t UncompressedSize);
int WriteTransformListToStream(ChmStream *stream);
int WriteResetTableToStream(ChmStream *stream, ChmMemoryStream *ResetTableStream);
int WriteContentToStream(ChmStream *stream, ChmStream *ContentStream);

#endif /* __CHMSPECIALFILES_H__ */
