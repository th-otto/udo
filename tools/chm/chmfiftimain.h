#ifndef __CHMFIFITIMAIN_H__
#define __CHMFIFITIMAIN_H__ 1

typedef struct _ChmSearchReader {
/* private: */
	CHMStream *Stream;
	gboolean FileIsValid;
	gboolean FreeStreamOnDestroy;
	int DocRootSize;
	int CodeCountRootSize;
	int LocCodeRootSize;
	int TreeDepth;
	uint32_t RootNodeOffset;
	uint32_t ActiveNodeStart;
	uint16_t ActiveNodeFreeSpace;
	uint32_t NextLeafNode;
} ChmSearchReader;

ChmSearchReader *ChmSearchReader_Create(CHMStream *AStream, gboolean AFreeStreamOnDestroy);
void ChmSearchReader_Destroy(ChmSearchReader *reader);

#endif /* __CHMFIFITIMAIN_H__ */
