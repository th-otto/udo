#ifndef __CHMFIFTIMAIN_H__
#define __CHMFIFTIMAIN_H__ 1

typedef struct _FiftiMainHeader FiftiMainHeader;
struct _FiftiMainHeader {
	/* 0000 */ uint32_t sig;					/* $00,$00,$28,$00 */
	/* 0004 */ uint32_t HTMLFilesCount;
	/* 0008 */ uint32_t RootNodeOffset;
	/* 000c */ uint32_t unknown1;				/* = 0 */
	/* 0010 */ uint32_t LeafNodeCount;
	/* 0014 */ uint32_t CopyOfRootNodeOffset;
	/* 0018 */ uint16_t TreeDepth;
	/* 001a */ uint32_t unknown2;				/* = 7 */
	/* 001e */ uint8_t DocIndexScale;
	/* 001f */ uint8_t DocIndexRootSize;
	/* 0020 */ uint8_t CodeCountScale;
	/* 0021 */ uint8_t CodeCountRootSize;
	/* 0022 */ uint8_t LocationCodeScale;
	/* 0023 */ uint8_t LocationCodeRootSize;
	/* 0024 */ uint8_t unknown3[10];			/* = 0 */
	/* 002e */ uint32_t NodeSize;				/* 4096 */
	/* 0032 */ uint32_t unknown4;				/* 0 or 1 */
	/* 0036 */ uint32_t LastDupWordIndex;
	/* 003a */ uint32_t LastDupCharIndex;
	/* 003e */ uint32_t LongestWordLength;		/* maximum 99 */
	/* 0042 */ uint32_t TotalWordsIndexed;		/* includes duplicates */
	/* 0046 */ uint32_t TotalWords;				/* word count not including duplicates */
	/* 004a */ uint32_t TotalWordsLengthPart1;	/* length of all the words with duplicates plus the next dword! */
	/* 004e */ uint32_t TotalWordsLengthPart2;
	/* 0052 */ uint32_t TotalWordsLength;		/* length of all words not including duplicates */
	/* 0056 */ uint32_t WordBlockUnusedBytes;	/* who knows, this makes no sense when there are more than one blocks */
	/* 005a */ uint32_t unknown5;				/* 0 */
	/* 005e */ uint32_t HTMLFilesCountMinusOne;	/* maybe */
	/* 0062 */ uint8_t unknown6[24];			/* 0 */
	/* 007a */ uint32_t codepage;				/* usually 1252 */
	/* 007e */ LCID locale_id;
	/* 0082 */ uint8_t Unknown7[894];			/* 0 */
	/* 0400 */ 
};

typedef struct _FIftiNode FIftiNode;
struct _FIftiNode {
	char *LastWord;
	ChmStream *WriteStream;
	ChmMemoryStream *BlockStream;
	FIftiNode *ParentNode;
	gboolean OwnsParentNode;
};

typedef struct _LeafNode {
	FIftiNode node;
	uint32_t LeafNodeCount;
	uint32_t LastNodeStart;
	uint32_t FreeSpace;
	uint8_t DocRootSize;
	uint8_t CodeRootSize;
	uint8_t LocRootSize;
} LeafNode;

typedef struct _IndexNode {
	FIftiNode node;
} IndexNode;

#endif /* __CHMFIFTIMAIN_H__ */
