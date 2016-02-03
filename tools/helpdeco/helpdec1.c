/*
helpdeco -- utility program to dissect Windows help files
Copyright (C) 1997 Manfred Winterhoff

This file is part of helpdeco; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place, Suite 330, Boston, MA, 02111-1307, USA or visit:
http://www.gnu.org
*/

/* HELPDEC1.C - HELPDECO supporting functions */
#include "helpdeco.h"

void error(const char *format, ...)
{
	va_list arg;

	fputs("\n", stderr);
	va_start(arg, format);
	vfprintf(stderr, format, arg);
	va_end(arg);
	fputs("\n", stderr);
}


void fatal(const char *format, ...)
{
	va_list arg;

	fputs("\n", stderr);
	va_start(arg, format);
	vfprintf(stderr, format, arg);
	va_end(arg);
	fputs("\n", stderr);
	exit(1);
}


/* limited string copy */
size_t my_strlcpy(char *dest, const void *psrc, size_t len)
{
	size_t i;
	const char *src = (const char *)psrc;
	
	if (!dest)
		return 0;
	for (i = 0; i < len - 1 && src && src[i]; i++)
		dest[i] = src[i];
	dest[i] = '\0';
	return i;
}


void *my_malloc(int32_t bytes)				/* save malloc function */
{
	void *ptr;

	if (bytes < 1L || ((ssize_t) bytes != bytes) || (ptr = malloc((size_t) bytes)) == NULL)
	{
		fatal("Allocation of %ld bytes failed. File too big.", (long)bytes);
	}
	return ptr;
}

void *my_realloc(void *ptr, int32_t bytes)	/* save realloc function */
{
	if (!ptr)
		return my_malloc(bytes);
	if (bytes < 1L || bytes != (ssize_t) bytes || (ptr = realloc(ptr, (size_t) bytes)) == NULL)
	{
		fatal("Reallocation to %ld bytes failed. File too big.", (long)bytes);
	}
	return ptr;
}


/* save strdup function */
char *my_strdup(const char *ptr)
{
	size_t len;
	char *dup;

	if (!ptr)
		return NULL;
	len = strlen(ptr);
	dup = (char *)my_malloc(len + 1);
	strcpy(dup, ptr);
	return dup;
}


/* save fread function */
size_t my_fread(void *ptr, int32_t bytes, FILE *f)
{
	ssize_t result = 0;

	if (bytes == 0)
		return 0;
	if (bytes < 0 || bytes != (ssize_t) bytes || (result = fread(ptr, 1, (size_t) bytes, f)) != bytes)
	{
		fatal("my_fread(%ld) at %ld failed", (long)bytes, (long)ftell(f));
	}
	return result;
}


/* read nul terminated string from regular file */
size_t my_gets(char *ptr, size_t size, FILE *f)
{
	size_t i;
	int c;

	i = 0;
	while ((c = getc(f)) > 0)
	{
		if (i >= size - 1)
		{
			fatal("String length exceeds decompiler limit.");
		}
		ptr[i++] = c;
	}
	ptr[i] = '\0';
	return i;
}


/* checks if disk is full */
void my_fclose(FILE *f)
{
	if (ferror(f) != 0)
	{
		fatal("File write error. Program aborted.");
	}
	fclose(f);
}


/* save fopen function */
FILE *my_fopen(const char *filename, const char *mode)
{
	FILE *f;

	if (!overwrite)
	{
		f = fopen(filename, "rb");
		if (f)
		{
			fclose(f);
			fprintf(stderr, "File %s already exists\n", filename);
		}
	}
	f = fopen(filename, mode);
	if (!f)
	{
		error("Can not create '%s'.", filename);
	} else
	{
		fprintf(stderr, "Creating %s...\n", filename);
	}
	return f;
}


/* get 16 bit quantity */
uint16_t my_getw(FILE *f)
{
	int ch;

	ch = getc(f);
	return ch | (getc(f) << 8);
}


/* get long */
uint32_t getdw(FILE *f)
{
	uint16_t w;

	w = my_getw(f);
	return (((int32_t)(short)my_getw(f)) << 16) | (uint32_t) w;
}


/* write 16 bit quantity */
void my_putw(uint16_t w, FILE *f)
{
	putc((w & 0xFF), f);
	putc((w >> 8), f);
}


/* write long to file */
void putdw(uint32_t x, FILE *f)
{
	my_putw(x & 0xffff, f);
	my_putw((x >> 16) & 0xffff, f);
}


/* write compressed long to file */
void putcdw(uint32_t x, FILE *f)
{
	if (x > 32767L)
	{
		my_putw((unsigned int) (x << 1) + 1, f);
		my_putw(x >> 15, f);
	} else
	{
		my_putw(x << 1, f);
	}
}


/* write compressed word to file */
void putcw(unsigned int x, FILE *f)
{
	if (x > 127)
	{
		my_putw((x << 1) + 1, f);
	} else
	{
		putc(x << 1, f);
	}
}


/*
 * HELPDECO sometimes has to work off the help file, sometimes needs to do
 * the same with (decompressed) information stored in memory. MFILE and the
 * memory mapped file functions allow to write the same code for both, but
 * this approach needs some declarations first...
 */

/* put char to memory mapped file */
int MemoryPut(MFILE *f, char c)
{
	if (f->ptr >= f->end)
		return 0;
	*f->ptr++ = c;
	return 1;
}


/* put char to regular file */
int FilePut(MFILE *f, char c)
{
	if (putc(c, f->f) == -1)
		return 0;
	return 1;
}


/* get char from memory mapped file */
int MemoryGet(MFILE *f)
{
	if (f->ptr >= f->end)
		return -1;
	return *(unsigned char *) f->ptr++;
}


/* get char from regular file */
int FileGet(MFILE *f)
{
	return getc(f->f);
}


/* read function for memory mapped file */
size_t MemoryRead(MFILE *f, void *ptr, int32_t bytes)
{
	if (bytes < 0 || bytes > f->end - f->ptr)
	{
		error("read(%ld) failed", (long)bytes);
		bytes = f->end - f->ptr;
	}
	memcpy(ptr, f->ptr, bytes);
	f->ptr += bytes;
	return bytes;
}


/* read function for regular file */
size_t FileRead(MFILE *f, void *ptr, int32_t bytes)
{
	return my_fread(ptr, bytes, f->f);
}


/* tell for memory mapped file */
int32_t MemoryTell(MFILE *f)
{
	return (int32_t)(f->ptr - f->base);
}


/* tell for regular file */
int32_t FileTell(MFILE *f)
{
	return ftell(f->f);
}


/* seek in memory mapped file */
void MemorySeek(MFILE *f, int32_t offset)
{
	f->ptr = f->base + offset;
}


/* seek in regular file */
void FileSeek(MFILE *f, int32_t offset)
{
	fseek(f->f, offset, SEEK_SET);
}


/* assign a memory mapped file */
MFILE *CreateMap(const char *ptr, size_t size)
{
	MFILE *f;
	union {
		const char *cp;
		char *sp;
	} u;
	
	f = (MFILE *)my_malloc(sizeof(MFILE));
	f->f = NULL;
	u.cp = ptr;
	f->ptr = u.sp;
	f->base = f->ptr;
	f->end = u.sp + size;
	f->get = MemoryGet;
	f->put = MemoryPut;
	f->read = MemoryRead;
	f->tell = MemoryTell;
	f->seek = MemorySeek;
	return f;
}


/* assign a real file */
MFILE *CreateVirtual(FILE *f)
{
	MFILE *mf;

	mf = (MFILE *)my_malloc(sizeof(MFILE));
	mf->f = f;
	mf->ptr = mf->end = mf->base = NULL;
	mf->get = FileGet;
	mf->put = FilePut;
	mf->read = FileRead;
	mf->tell = FileTell;
	mf->seek = FileSeek;
	return mf;
}


/* close a MFILE */
void CloseMap(MFILE *f)
{
	if (f)
		free(f);
}


/* read 16 bit value from memory mapped file or regular file */
int GetWord(MFILE *f)
{
	unsigned char b;

	b = f->get(f);
	return ((uint16_t) (f->get(f)) << 8) | (uint16_t) b;
}


/* get compressed word from memory mapped file or regular file */
uint16_t GetCWord(MFILE *f)
{
	unsigned char b;

	b = f->get(f);
	if (b & 1)
		return (((uint16_t) (f->get(f)) << 8) | (uint16_t) b) >> 1;
	return ((uint16_t) b >> 1);
}


/* get compressed long from memory mapped file or regular file */
uint32_t GetCDWord(MFILE *f)
{
	uint16_t w;

	w = GetWord(f);
	if (w & 1)
		return (((uint32_t) GetWord(f) << 16) | (uint32_t) w) >> 1;
	return ((uint32_t) w >> 1);
}

uint32_t GetDWord(MFILE *f)		/* get long from memory mapped file or regular file */
{
	uint16_t w;

	w = GetWord(f);
	return ((uint32_t) GetWord(f) << 16) | (uint32_t) w;
}


size_t StringRead(char *ptr, size_t size, MFILE *f)	/* read nul terminated string from memory mapped or regular file */
{
	size_t i;
	int c;

	i = 0;
	while ((c = f->get(f)) > 0)
	{
		if (i >= size - 1)
		{
			fputs("String length exceeds decompiler limit.\n", stderr);
			exit(1);
		}
		ptr[i++] = c;
	}
	ptr[i] = '\0';
	return i;
}


int32_t copy(FILE *f, int32_t bytes, FILE *out)
{
	int32_t length;
	int size;
	char buffer[1024];

	for (length = 0; length < bytes; length += size)
	{
		size = (int) (bytes - length > (int)sizeof(buffer) ? (int)sizeof(buffer) : bytes - length);
		my_fread(buffer, size, f);
		fwrite(buffer, size, 1, out);
	}
	return length;
}


int32_t CopyBytes(MFILE *f, int32_t bytes, FILE *out)
{
	int32_t length;
	int size;
	char buffer[1024];

	for (length = 0; length < bytes; length += size)
	{
		size = (int) (bytes - length > (int)sizeof(buffer) ? (int)sizeof(buffer) : bytes - length);
		f->read(f, buffer, size);
		fwrite(buffer, size, 1, out);
	}
	return length;
}

static signed char runlen_count;						/* for run len decompression */

static int DeRun(MFILE *f, char c)			/* expand runlen compressed data */
{
	int i;

	if (runlen_count & 0x7F)
	{
		if (runlen_count & 0x80)
		{
			f->put(f, c);
			runlen_count--;
			return 1;
		}
		for (i = 0; i < runlen_count; i++)
		{
			f->put(f, c);
		}
		runlen_count = 0;
		return i;
	}
	runlen_count = (signed char) c;
	return 0;
}

/*
 * copies bytes from (memory mapped or regular file) f to (memory mapped or
 * regular file) fTarget, decompressed using method
 * 0: copy (no decompression)
 * 1: runlen decompression
 * 2: LZ77 decompression
 * 3: runlen and LZ77 decompression
 * returns number of bytes copied to fTarget. Doesn't complain if fTarget
 * is a memory mapped file and buffer is full, just stops writing
 */
int32_t decompress(int method, MFILE *f, int32_t bytes, MFILE *fTarget)
{
	static unsigned char lzbuffer[0x1000];
	int (*Emit) (MFILE *f, char c);
	unsigned char bits = 0, mask;
	int pos, len, back;
	int32_t n;

	n = 0;
	if (method & 1)
	{
		Emit = DeRun;
		runlen_count = 0;
	} else
	{
		Emit = fTarget->put;
	}
	if (method & 2)
	{
		mask = 0;
		pos = 0;
		while (bytes-- > 0L)
		{
			if (!mask)
			{
				bits = f->get(f);
				mask = 1;
			} else
			{
				if (bits & mask)
				{
					if (bytes-- == 0)
						break;
					back = GetWord(f);
					len = ((back >> 12) & 15) + 3;
					back = pos - (back & 0xFFF) - 1;
					while (len-- > 0)
					{
						n += Emit(fTarget, lzbuffer[pos++ & 0xFFF] = lzbuffer[back++ & 0xFFF]);
					}
				} else
				{
					n += Emit(fTarget, lzbuffer[pos++ & 0xFFF] = f->get(f));
				}
				mask <<= 1;
			}
		}
	} else
	{
		while (bytes-- > 0L)
			n += Emit(fTarget, f->get(f));
	}
	return n;
}


int32_t DecompressIntoBuffer(int method, FILE *HelpFile, int32_t bytes, char *ptr, int32_t size)
{
	MFILE *f;
	MFILE *mf;

	f = CreateMap(ptr, size);
	mf = CreateVirtual(HelpFile);
	bytes = decompress(method, mf, bytes, f);
	CloseMap(mf);
	CloseMap(f);
	return bytes;
}


int32_t DecompressIntoFile(int method, MFILE *f, int32_t bytes, FILE *fTarget)
{
	MFILE *mf;

	mf = CreateVirtual(fTarget);
	bytes = decompress(method, f, bytes, mf);
	CloseMap(mf);
	return bytes;
}



void HexDump(FILE *f, int32_t FileLength, int32_t offset)
{
	unsigned char b[16];
	int32_t l;
	int n, i;

	puts("[-Addr-] [--------------------Data---------------------] [-----Text-----]");
	fseek(f, offset, SEEK_CUR);
	for (l = offset; l < FileLength; l += 16)
	{
		printf("%08lX ", (long)l);
		n = (int) (FileLength - l > 16 ? 16 : FileLength - l);
		for (i = 0; i < n; i++)
			printf("%02X ", b[i] = getc(f));
		while (i++ < 16)
			printf("         ");
		for (i = 0; i < n; i++)
			putchar(isprint(b[i]) ? b[i] : '.');
		putchar('\n');
	}
}


void HexDumpMemory(const unsigned char *bypMem, unsigned int FileLength)
{
	unsigned char b[16];
	unsigned int l;
	int n, i;

	puts("[-Addr-] [--------------------Data---------------------] [-----Text-----]");
	for (l = 0; l < FileLength; l += 16)
	{
		printf("%08lX ", (long)l);
		n = (int) (FileLength - l > 16 ? 16 : FileLength - l);
		for (i = 0; i < n; i++)
			printf("%02X ", b[i] = *bypMem++);
		while (i++ < 16)
			printf("         ");
		for (i = 0; i < n; i++)
			putchar(isprint(b[i]) ? b[i] : '.');
		putchar('\n');
	}
}


/*
 * write str to stdout, replacing nonprintable characters with hex codes,
 * returning str+len. PrintString doesn't stop at NUL characters
 */
const char *PrintString(const char *str, unsigned int len)
{
	while (len-- > 0)
	{
		if (isprint((unsigned char) *str))
		{
			putchar(*str);
		} else
		{
			printf("(%02x)", *(const unsigned char *) str);
		}
		str++;
	}
	return str;
}


/*
 * get next bit (lsb first) from 32 bit words in f, initialized if f = NULL
 * important to read longs to stop at right position
 */
BOOL GetBit(FILE *f)
{
	static unsigned int mask;
	static unsigned int value;
	static int bitcnt;
	
	if (f)
	{
		mask <<= 1;
		bitcnt++;
		if (bitcnt >= 32)
		{
			value = getdw(f);
			mask = 1L;
			bitcnt = 0;
		}
	} else
	{
		mask = 0L;						/* initialize */
		bitcnt = 31;
	}
	return (value & mask) != 0L;
}


/* output str to RTF file, escaping neccessary characters */
void putrtf(FILE *rtf, const char *str)
{
	if (rtf)
		while (*str)
		{
			if (*str == '{' || *str == '}' || *str == '\\')
			{
				putc('\\', rtf);
				putc(*str++, rtf);
			} else if (isprint((unsigned char) *str))
			{
				putc(*str++, rtf);
			} else
			{
				fprintf(rtf, "\\'%02x", (unsigned char) *str++);
			}
		}
}


/* scan-functions for reading compressed values from LinkData1 */

/* scan a compressed short */
short scanint(const char **ptr)
{
	short ret;

	if (*(*ptr) & 1)
	{
		ret = (*(((const uint16_t *) (*ptr))) >> 1) - 0x4000;
		*ptr = *ptr + 2;
	} else
	{
		ret = (*(((const unsigned char *) (*ptr))) >> 1) - 0x40;
		*ptr = (*ptr) + 1;
	}
	return ret;
}


/* scan a compressed unsiged short */
uint16_t scanword(const char **ptr)
{
	short ret;

	if (*(*ptr) & 1)
	{
		ret = (*(((const uint16_t *) (*ptr))) >> 1);
		*ptr = *ptr + 2;
	} else
	{
		ret = (*(((const unsigned char *) (*ptr))) >> 1);
		*ptr = (*ptr) + 1;
	}
	return ret;
}


/* scan a compressed long */
int32_t scanlong(const char **ptr)
{
	int32_t ret;

	if (*(*ptr) & 1)
	{
		ret = (*(((const unsigned int *) (*ptr))) >> 1) - 0x40000000L;
		*ptr = *ptr + 4;
	} else
	{
		ret = (*(((const uint16_t *) (*ptr))) >> 1) - 0x4000;
		*ptr = *ptr + 2;
	}
	return ret;
}


static void check_ferror(FILE *f)
{
	if (feof(f) || ferror(f) != 0)
	{
		fatal("File read error. Program aborted.");
	}
}


static void read_filehdr(FILE *f, FILEHEADER *hdr)
{
	hdr->ReservedSpace = getdw(f);
	hdr->UsedSpace = getdw(f);
	hdr->FileFlags = getc(f);
	check_ferror(f);
}


void read_btreeheader(FILE *f, BTREEHEADER *hdr)
{
	hdr->Magic = my_getw(f);
	hdr->Flags = my_getw(f);
	hdr->PageSize = my_getw(f);
	my_fread(hdr->Structure, 16, f);
	hdr->MustBeZero = my_getw(f);
	hdr->PageSplits = my_getw(f);
	hdr->RootPage = my_getw(f);
	hdr->MustBeNegOne = my_getw(f);
	hdr->TotalPages = my_getw(f);
	hdr->NLevels = my_getw(f);
	hdr->TotalBtreeEntries = getdw(f);
	check_ferror(f);
}


void read_contextrec(FILE *f, CONTEXTREC *hdr)
{
	hdr->HashValue = getdw(f);
	hdr->TopicOffset = getdw(f);
	check_ferror(f);
}


void read_btreenode(FILE *f, BTREENODEHEADER *hdr)
{
	hdr->Unknown = my_getw(f);
	hdr->NEntries = my_getw(f);
	hdr->PreviousPage = my_getw(f);
	hdr->NextPage = my_getw(f);
	check_ferror(f);
}


void read_btreeindex(FILE *f, BTREENODEHEADER *hdr)
{
	hdr->Unknown = my_getw(f);
	hdr->NEntries = my_getw(f);
	hdr->PreviousPage = my_getw(f);
	hdr->NextPage = -1;
	check_ferror(f);
}


void read_systemheader(FILE *f, SYSTEMHEADER *hdr)
{
	hdr->Magic = my_getw(f);
	hdr->Minor = my_getw(f);
	hdr->Major = my_getw(f);
	hdr->GenDate = getdw(f);
	hdr->Flags = my_getw(f);
	check_ferror(f);
}


void read_groupheader(FILE *f, GROUPHEADER *hdr)
{
	hdr->Magic = getdw(f);
	hdr->BitmapSize = getdw(f);
	hdr->LastTopic = getdw(f);
	hdr->FirstTopic = getdw(f);
	hdr->TopicsUsed = getdw(f);
	hdr->TopicCount = getdw(f);
	hdr->GroupType = getdw(f);
	hdr->Unknown1 = getdw(f);
	hdr->Unknown2 = getdw(f);
	hdr->Unknown3 = getdw(f);
	check_ferror(f);
}


void read_phrindexhdr(FILE *f, PHRINDEXHDR *hdr)
{
	uint16_t w;
	
	hdr->always4A01 = getdw(f);
	hdr->entries = getdw(f);
	hdr->compressedsize = getdw(f);
	hdr->phrimagesize = getdw(f);
	hdr->phrimagecompressedsize = getdw(f);
	hdr->always0 = getdw(f);
	w = my_getw(f);
	hdr->bits = w & 0xf;
	hdr->unknown = w >> 4;
	hdr->always4A00 = my_getw(f);
	check_ferror(f);
}


void read_topicblockheader(FILE *f, TOPICBLOCKHEADER *hdr)
{
	hdr->LastTopicLink = getdw(f);
	hdr->FirstTopicLink = getdw(f);
	hdr->LastTopicHeader = getdw(f);
	check_ferror(f);
}


void read_violarec(FILE *f, VIOLAREC *hdr)
{
	hdr->TopicOffset = getdw(f);
	hdr->WindowNumber = getdw(f);
}


static void read_kwmaprec(FILE *f, KWMAPREC *hdr)
{
	hdr->FirstRec = getdw(f);
	hdr->PageNum = my_getw(f);
	check_ferror(f);
}


static void read_catalogheader(FILE *f, CATALOGHEADER *hdr)
{
	hdr->magic = my_getw(f);
	hdr->always8 = my_getw(f);
	hdr->always4 = my_getw(f);
	hdr->entries = getdw(f);
	my_fread(hdr->zero, sizeof(hdr->zero), f);
	check_ferror(f);
}


void read_ctxomaprec(FILE *f, CTXOMAPREC *hdr)
{
	hdr->MapID = getdw(f);
	hdr->TopicOffset = getdw(f);
	check_ferror(f);
}


void read_stopheader(FILE *f, STOPHEADER *hdr)
{
	int i;
	
	hdr->Magic = getdw(f);
	hdr->BytesUsed = my_getw(f);
	for (i = 0; i < 17; i++)
		hdr->Unused[i] = my_getw(f);;
	check_ferror(f);
}


/*
 * locates internal file FileName or internal directory if FileName is NULL
 * reads FILEHEADER and returns TRUE with current position in HelpFile set
 * to first byte of data of FileName or returns FALSE if not found. Stores
 * UsedSpace (that's the file size) in FileLength if FileLength isn't NULL
 */
BOOL SearchFile(FILE *HelpFile, const char *FileName, int32_t *FileLength)
{
	HELPHEADER Header;
	FILEHEADER FileHdr;
	BTREEHEADER BtreeHdr;
	BTREENODEHEADER CurrNode;
	int32_t offset;
	char TempFile[19];
	int i, n;

	fseek(HelpFile, 0L, SEEK_SET);
	Header.Magic = getdw(HelpFile);
	Header.DirectoryStart = getdw(HelpFile);
	Header.FreeChainStart = getdw(HelpFile);
	Header.EntireFileSize = getdw(HelpFile);
	if (Header.Magic != 0x00035F3FL)
		return FALSE;
	fseek(HelpFile, Header.DirectoryStart, SEEK_SET);
	read_filehdr(HelpFile, &FileHdr);
	if (!FileName)
	{
		if (FileLength)
			*FileLength = FileHdr.UsedSpace;
		return TRUE;
	}
	read_btreeheader(HelpFile, &BtreeHdr);
	offset = ftell(HelpFile);
	fseek(HelpFile, offset + BtreeHdr.RootPage * (int32_t) BtreeHdr.PageSize, SEEK_SET);
	for (n = 1; n < BtreeHdr.NLevels; n++)
	{
		read_btreeindex(HelpFile, &CurrNode);
		for (i = 0; i < CurrNode.NEntries; i++)
		{
			my_gets(TempFile, sizeof(TempFile), HelpFile);
			if (strcmp(FileName, TempFile) < 0)
				break;
			CurrNode.PreviousPage = my_getw(HelpFile);
		}
		fseek(HelpFile, offset + CurrNode.PreviousPage * (int32_t) BtreeHdr.PageSize, SEEK_SET);
	}
	read_btreenode(HelpFile, &CurrNode);
	for (i = 0; i < CurrNode.NEntries; i++)
	{
		my_gets(TempFile, sizeof(TempFile), HelpFile);
		offset = getdw(HelpFile);
		if (strcmp(TempFile, FileName) == 0)
		{
			fseek(HelpFile, offset, SEEK_SET);
			read_filehdr(HelpFile, &FileHdr);
			if (FileLength)
				*FileLength = FileHdr.UsedSpace;
			return TRUE;
		}
	}
	return FALSE;
}


/*
 * read first (and next) page from B+ tree. HelpFile must be positioned
 * at start of internal file prior calling GetFirstPage. It will be
 * positioned at first B+ tree entry after return from GetFirstPage.
 * Number of TotalBtreeEntries stored in TotalEntries if pointer is
 * not NULL, NumberOfEntries of first B+ tree page returned.
 * buf stores position, so GetNextPage will seek to position itself.
 */
short GetFirstPage(FILE *HelpFile, BUFFER *buf, int32_t *TotalEntries)
{
	int CurrLevel;
	BTREEHEADER BTreeHdr;
	BTREENODEHEADER CurrNode;

	read_btreeheader(HelpFile, &BTreeHdr);
	if (TotalEntries)
		*TotalEntries = BTreeHdr.TotalBtreeEntries;
	if (!BTreeHdr.TotalBtreeEntries)
		return 0;
	buf->FirstLeaf = ftell(HelpFile);
	buf->PageSize = BTreeHdr.PageSize;
	fseek(HelpFile, buf->FirstLeaf + BTreeHdr.RootPage * (int32_t) BTreeHdr.PageSize, SEEK_SET);
	for (CurrLevel = 1; CurrLevel < BTreeHdr.NLevels; CurrLevel++)
	{
		read_btreeindex(HelpFile, &CurrNode);
		fseek(HelpFile, buf->FirstLeaf + CurrNode.PreviousPage * (int32_t) BTreeHdr.PageSize, SEEK_SET);
	}
	read_btreenode(HelpFile, &CurrNode);
	buf->NextPage = CurrNode.NextPage;
	return CurrNode.NEntries;
}


/* walk Btree */
short GetNextPage(FILE *HelpFile, BUFFER *buf)
{
	BTREENODEHEADER CurrNode;

	if (buf->NextPage == -1)
		return 0;
	fseek(HelpFile, buf->FirstLeaf + buf->NextPage * (int32_t) buf->PageSize, SEEK_SET);
	read_btreenode(HelpFile, &CurrNode);
	buf->NextPage = CurrNode.NextPage;
	return CurrNode.NEntries;
}


/*
 * reads next record from |SYSTEM file, returns NULL if no more available
 * Use last system record as parameter SysRec (saves filehandle and pos)
 */
SYSTEMRECORD *GetNextSystemRecord(SYSTEMRECORD *SysRec)
{
	if (SysRec->Remaining < 4)
	{
		free(SysRec);
		return NULL;
	}
	fseek(SysRec->File, SysRec->SavePos, SEEK_SET);
	SysRec->RecordType = my_getw(SysRec->File);
	SysRec->DataSize = my_getw(SysRec->File);
	SysRec->Remaining -= 4;
	if (SysRec->Remaining < SysRec->DataSize)
	{
		free(SysRec);
		return NULL;
	}
	SysRec = (SYSTEMRECORD *)my_realloc(SysRec, sizeof(SYSTEMRECORD) + SysRec->DataSize);
	my_fread(SysRec->Data, SysRec->DataSize, SysRec->File);
	SysRec->Data[SysRec->DataSize] = '\0';
	SysRec->Remaining -= SysRec->DataSize;
	SysRec->SavePos = ftell(SysRec->File);
	return SysRec;
}


/* reads first record from |SYSTEM file, returns NULL if none found */
SYSTEMRECORD *GetFirstSystemRecord(FILE *HelpFile)
{
	SYSTEMHEADER SysHdr;
	SYSTEMRECORD *SysRec;
	int32_t FileLength;

	if (!SearchFile(HelpFile, "|SYSTEM", &FileLength))
		return NULL;
	read_systemheader(HelpFile, &SysHdr);
	if (SysHdr.Major != 1 || SysHdr.Minor < 16)
		return NULL;
	SysRec = (SYSTEMRECORD *)my_malloc(sizeof(SYSTEMRECORD));
	SysRec->File = HelpFile;
	SysRec->SavePos = ftell(HelpFile);
	SysRec->Remaining = FileLength - SIZEOF_SYSTEMHEADER;
	return GetNextSystemRecord(SysRec);
}


/* display internal directory */
void ListFiles(FILE *HelpFile)
{
	BUFFER buf;
	char FileName[20];
	int i, n;

    puts("FileName                FileOffset");
	puts("----------------------------------");
	for (n = GetFirstPage(HelpFile, &buf, NULL); n; n = GetNextPage(HelpFile, &buf))
	{
		for (i = 0; i < n; i++)
		{
			my_gets(FileName, sizeof(FileName), HelpFile);
			printf("%-23s 0x%08lX\n", FileName, (long)getdw(HelpFile));
		}
	}
}


/* writes out [BAGGAGE] section */
void ListBaggage(FILE *HelpFile, FILE *hpj, BOOL before31)
{
	BOOL headerwritten;
	const char *leader;
	char FileName[20];
	int32_t FileLength;
	BUFFER buf;
	int i, n;
	FILE *f;
	int32_t savepos;

	headerwritten = FALSE;
	leader = "|bm" + before31;
	SearchFile(HelpFile, NULL, NULL);
	for (n = GetFirstPage(HelpFile, &buf, NULL); n; n = GetNextPage(HelpFile, &buf))
	{
		for (i = 0; i < n; i++)
		{
			my_gets(FileName, sizeof(FileName), HelpFile);
			getdw(HelpFile);
			if (FileName[0] != '|' && memcmp(FileName, leader, strlen(leader)) != 0 && !strstr(FileName, ".GRP")
				&& !strstr(FileName, ".tbl"))
			{
				savepos = ftell(HelpFile);
				if (SearchFile(HelpFile, FileName, &FileLength))
				{
					if (!headerwritten)
					{
						fputs("[BAGGAGE]\n", hpj);
						headerwritten = TRUE;
					}
					fprintf(hpj, "%s\n", FileName);
					f = my_fopen(FileName, "wb");
					if (f)
					{
						copy(HelpFile, FileLength, f);
						my_fclose(f);
					}
				}
				fseek(HelpFile, savepos, SEEK_SET);
			}
		}
	}
	if (headerwritten)
		putc('\n', hpj);
}


void PrintWindow(FILE *hpj, const SECWINDOW *SWin)
{
	if (SWin->Flags & WSYSFLAG_NAME)
		fprintf(hpj, "%s", SWin->Name);
	putc('=', hpj);
	if (SWin->Flags & WSYSFLAG_CAPTION)
		fprintf(hpj, "\"%s\"", SWin->Caption);
	putc(',', hpj);
	if (SWin->Flags & (WSYSFLAG_X | WSYSFLAG_Y | WSYSFLAG_WIDTH | WSYSFLAG_HEIGHT))
	{
		putc('(', hpj);
		if (SWin->Flags & WSYSFLAG_X)
			fprintf(hpj, "%d", SWin->X);
		putc(',', hpj);
		if (SWin->Flags & WSYSFLAG_Y)
			fprintf(hpj, "%d", SWin->Y);
		putc(',', hpj);
		if (SWin->Flags & WSYSFLAG_WIDTH)
			fprintf(hpj, "%d", SWin->Width);
		putc(',', hpj);
		if (SWin->Flags & WSYSFLAG_HEIGHT)
			fprintf(hpj, "%d", SWin->Height);
		putc(')', hpj);
	}
	putc(',', hpj);
	if (SWin->Maximize)
		fprintf(hpj, "%u", SWin->Maximize);
	putc(',', hpj);
	if (SWin->Flags & WSYSFLAG_RGB)
		fprintf(hpj, "(%d,%d,%d)", SWin->Rgb[0], SWin->Rgb[1], SWin->Rgb[2]);
	putc(',', hpj);
	if (SWin->Flags & WSYSFLAG_RGBNSR)
		fprintf(hpj, "(%d,%d,%d)", SWin->RgbNsr[0], SWin->RgbNsr[1], SWin->RgbNsr[2]);
	putc(',', hpj);
	if (SWin->Flags & (WSYSFLAG_TOP | WSYSFLAG_AUTOSIZEHEIGHT))
	{
		if (SWin->Flags & WSYSFLAG_AUTOSIZEHEIGHT)
		{
			if (SWin->Flags & WSYSFLAG_TOP)
			{
				fputs("f3", hpj);
			} else
			{
				fputs("f2", hpj);
			}
		} else
		{
			fputs("1", hpj);
		}
	} else
	{
		fprintf(hpj, "%u", SWin->Flags);
	}
	putc('\n', hpj);
}


void PrintMVBWindow(FILE *hpj, const MVBWINDOW *SWin)
{
	fprintf(hpj, "%s", SWin->Name);
	putc('=', hpj);
	fprintf(hpj, "\"%s\"", SWin->Caption);
	putc(',', hpj);
	putc('(', hpj);
	fprintf(hpj, "%d", SWin->X);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Y);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Width);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Height);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Maximize);
	putc(')', hpj);
	putc(',', hpj);
	putc('(', hpj);
	fprintf(hpj, "%d", 0);
	putc(')', hpj);
	putc(',', hpj);
	fprintf(hpj, "(%d,%d,%d)", SWin->TopRgb[0], SWin->TopRgb[1], SWin->TopRgb[2]);
	putc(',', hpj);
	fprintf(hpj, "(%d,%d,%d)", SWin->RgbNsr[0], SWin->RgbNsr[1], SWin->RgbNsr[2]);
	putc(',', hpj);
	fprintf(hpj, "(%d,%d,%d)", SWin->Rgb[0], SWin->Rgb[1], SWin->Rgb[2]);
	putc(',', hpj);
	putc('(', hpj);
	fprintf(hpj, "%d", SWin->X2);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Y2);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Width2);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Height2);
	putc(',', hpj);
	fprintf(hpj, "%d", 0);
	putc(')', hpj);
	putc(',', hpj);
	putc('(', hpj);
	fprintf(hpj, "%d", 1);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->X3);
	putc(',', hpj);
	fprintf(hpj, "%d", SWin->Y3);
	putc(')', hpj);
	putc(',', hpj);
	putc('(', hpj);
	fprintf(hpj, "%d", 0);
	putc(')', hpj);
	putc(',', hpj);
	putc('(', hpj);
	fprintf(hpj, "%d", 1);
	putc(')', hpj);
	putc('\n', hpj);
}


void ToMapDump(FILE *HelpFile, int32_t FileLength)
{
	int32_t i;

	for (i = 0; i * 4L < FileLength; i++)
	{
		printf("TopicNum: %-12ld TopicOffset: 0x%08lX\n", (long)i, (long)getdw(HelpFile));
	}
}


void GroupDump(FILE *HelpFile)
{
	GROUPHEADER GroupHeader;
	char *ptr;
	uint32_t i;

	read_groupheader(HelpFile, &GroupHeader);
	switch (GroupHeader.GroupType)
	{
	case 2:
		ptr = (char *)my_malloc(GroupHeader.BitmapSize);
		my_fread(ptr, GroupHeader.BitmapSize, HelpFile);
		for (i = GroupHeader.FirstTopic; i <= GroupHeader.LastTopic; i++)
		{
			if (ptr[i >> 3] & (1 << (i & 7)))
				printf("TopicNumber: %lu\n", (unsigned long)i);
		}
		free(ptr);
		break;
	case 1:
		for (i = GroupHeader.FirstTopic; i <= GroupHeader.LastTopic; i++)
		{
			printf("TopicNumber: %lu\n", (unsigned long)i);
		}
		break;
	default:
		error("GroupHeader GroupType %ld unknown", (long)GroupHeader.GroupType);
		break;
	}
}


void KWMapDump(FILE *HelpFile)
{
	uint16_t n, i;
	KWMAPREC KeywordMap;

	n = my_getw(HelpFile);
	for (i = 0; i < n; i++)
	{
		read_kwmaprec(HelpFile, &KeywordMap);
		printf("Keyword: %-12ld LeafPage: %u\n", (long)KeywordMap.FirstRec, KeywordMap.PageNum);
	}
}


void KWDataDump(FILE *HelpFile, int32_t FileLength)
{
	int32_t i;

	for (i = 0; i < FileLength; i += 4)
	{
		printf("KWDataAddress: 0x%08lx TopicOffset: 0x%08lX\n", (long)i, (long)getdw(HelpFile));
	}
}


void CatalogDump(FILE *HelpFile)
{
	CATALOGHEADER catalog;
	int32_t n;

	read_catalogheader(HelpFile, &catalog);
	for (n = 0; n < catalog.entries; n++)
	{
		printf("Topic: %-12ld TopicOffset: 0x%08lx\n", (long)n + 1, (long)getdw(HelpFile));
	}
}


void CTXOMAPDump(FILE *HelpFile)
{
	CTXOMAPREC CTXORec;
	uint16_t n, i;

	n = my_getw(HelpFile);
	for (i = 0; i < n; i++)
	{
		read_ctxomaprec(HelpFile, &CTXORec);
		printf("MapId: %-12ld TopicOffset: 0x%08lX\n", (long)CTXORec.MapID, (long)CTXORec.TopicOffset);
	}
}


void LinkDump(FILE *HelpFile)
{
	int32_t data[3];
	int n, i;

	n = my_getw(HelpFile);
	for (i = 0; i < n; i++)
	{
		data[0] = getdw(HelpFile);
		data[1] = getdw(HelpFile);
		data[2] = getdw(HelpFile);
		printf("Annotation for topic 0x%08lx 0x%08lx 0x%08lx\n", (long)data[0], (long)data[1], (long)data[2]);
	}
}


void AnnotationDump(FILE *HelpFile, int32_t FileLength, const char *name)
{
	int32_t l;

	printf("Annotation %s for topic 0x%08lx:\n", name, atol(name));
	for (l = 0; l < FileLength; l++)
		putchar(getc(HelpFile));
	putchar('\n');
}


void read_hotspot(MFILE *f, HOTSPOT *hotspot)
{
	hotspot->id0 = f->get(f);
	hotspot->id1 = f->get(f);
	hotspot->id2 = f->get(f);
	hotspot->x = GetWord(f);
	hotspot->y = GetWord(f);
	hotspot->w = GetWord(f);
	hotspot->h = GetWord(f);
	hotspot->hash = GetDWord(f);
}


void read_fontheader(FILE *f, FONTHEADER *hdr)
{
	hdr->NumFacenames = my_getw(f);
	hdr->NumDescriptors = my_getw(f);
	hdr->FacenamesOffset = my_getw(f);
	hdr->DescriptorsOffset = my_getw(f);
	hdr->NumFormats = my_getw(f);
	hdr->FormatsOffset = my_getw(f);
	hdr->NumCharmaps = my_getw(f);
	hdr->CharmapsOffset = my_getw(f);
	check_ferror(f);
}


void read_charmapheader(FILE *f, CHARMAPHEADER *hdr)
{
	int i;
	
	hdr->Magic = my_getw(f);
	hdr->Size = my_getw(f);
	hdr->Unknown1 = my_getw(f);
	hdr->Unknown2 = my_getw(f);
	hdr->Entries = my_getw(f);
	hdr->Ligatures = my_getw(f);
	hdr->LigLen = my_getw(f);
	for (i = 0; i < 13; i++)
		hdr->Unknown[i] = my_getw(f);
	check_ferror(f);
}


void read_mvbfont(FILE *f, MVBFONT *hdr)
{
	int i;
	
	hdr->FontName = my_getw(f);
	hdr->expndtw = my_getw(f);
	hdr->style = my_getw(f);
	hdr->FGRGB[0] = getc(f);
	hdr->FGRGB[1] = getc(f);
	hdr->FGRGB[2] = getc(f);
	hdr->BGRGB[0] = getc(f);
	hdr->BGRGB[1] = getc(f);
	hdr->BGRGB[2] = getc(f);
	hdr->Height = getdw(f);
	for (i = 0; i < 12; i++)
		hdr->mostlyzero[i] = getc(f);
	hdr->Weight = my_getw(f);
	hdr->unknown10 = getc(f);
	hdr->unknown11 = getc(f);
	hdr->Italic = getc(f);
	hdr->Underline = getc(f);
	hdr->StrikeOut = getc(f);
	hdr->DoubleUnderline = getc(f);
	hdr->SmallCaps = getc(f);
	hdr->unknown17 = getc(f);
	hdr->unknown18 = getc(f);
	hdr->PitchAndFamily = getc(f);
	hdr->unknown20 = getc(f);
	hdr->up = getc(f);
	check_ferror(f);
}


void read_mvbstyle(FILE *f, MVBSTYLE *hdr)
{
	int i;
	
	hdr->StyleNum = my_getw(f);
	hdr->BasedOn = my_getw(f);
	read_mvbfont(f, &hdr->font);
	for (i = 0; i < 35; i++)
		hdr->unknown[i] = getc(f);
	for (i = 0; i < 65; i++)
		hdr->StyleName[i] = getc(f);
	check_ferror(f);
}


void read_newfont(FILE *f, NEWFONT *hdr)
{
	int i;
	
	hdr->unknown1 = getc(f);
	hdr->FontName = my_getw(f);
	hdr->FGRGB[0] = getc(f);
	hdr->FGRGB[1] = getc(f);
	hdr->FGRGB[2] = getc(f);
	hdr->BGRGB[0] = getc(f);
	hdr->BGRGB[1] = getc(f);
	hdr->BGRGB[2] = getc(f);
	hdr->unknown5 = getc(f);
	hdr->unknown6 = getc(f);
	hdr->unknown7 = getc(f);
	hdr->unknown8 = getc(f);
	hdr->unknown9 = getc(f);
	hdr->Height = getdw(f);
	for (i = 0; i < 12; i++)
		hdr->mostlyzero[i] = getc(f);
	hdr->Weight = my_getw(f);
	hdr->unknown10 = getc(f);
	hdr->unknown11 = getc(f);
	hdr->Italic = getc(f);
	hdr->Underline = getc(f);
	hdr->StrikeOut = getc(f);
	hdr->DoubleUnderline = getc(f);
	hdr->SmallCaps = getc(f);
	hdr->unknown17 = getc(f);
	hdr->unknown18 = getc(f);
	hdr->PitchAndFamily = getc(f);
	check_ferror(f);
}


void read_newstyle(FILE *f, NEWSTYLE *hdr)
{
	int i;
	
	hdr->StyleNum = my_getw(f);
	hdr->BasedOn = my_getw(f);
	read_newfont(f, &hdr->font);
	for (i = 0; i < 35; i++)
		hdr->unknown[i] = getc(f);
	for (i = 0; i < 65; i++)
		hdr->StyleName[i] = getc(f);
	check_ferror(f);
}


void read_oldfont(FILE *f, OLDFONT *hdr)
{
	hdr->Attributes = getc(f);
	hdr->HalfPoints = getc(f);
	hdr->FontFamily = getc(f);
	hdr->FontName = my_getw(f);
	hdr->FGRGB[0] = getc(f);
	hdr->FGRGB[1] = getc(f);
	hdr->FGRGB[2] = getc(f);
	hdr->BGRGB[0] = getc(f);
	hdr->BGRGB[1] = getc(f);
	hdr->BGRGB[2] = getc(f);
	check_ferror(f);
}
