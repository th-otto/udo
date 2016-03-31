/*
 * define any symbols that might be needed to get 
 * support for large files
 */
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE
#define _FILE_OFFSET_BITS 64

#include "chmtools.h"

struct _ChmStream {
	chmstream_type type;
	chm_off_t len;
	gboolean owned;
	gboolean supports_64bit;
	gboolean warned_64bit;
	char *filename;
	gboolean (*close)(ChmStream *stream);
	gboolean (*seek)(ChmStream *stream, chm_off_t pos, int whence);
	chm_off_t (*tell)(ChmStream *stream);
	size_t (*write)(ChmStream *stream, const void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
	size_t (*read)(ChmStream *stream, void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
	int (*fgetc)(ChmStream *stream) G_GNUC_WARN_UNUSED_RESULT;
	int (*fputc)(ChmStream *stream, int c) G_GNUC_WARN_UNUSED_RESULT;
	union {
		FILE *file;
		int fd;
		struct {
			unsigned char *base;
			size_t pos;
			size_t alloclen;
			gboolean alloced;
		} mem;
	};
};

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean check_64bit(ChmStream *stream, chm_off_t pos)
{
	if (!stream->supports_64bit && pos >= (uint32_t)0x7ffffff0UL)
	{
		if (!stream->warned_64bit)
		{
			fprintf(stderr, _("seek error (file too large?)\n"));
			stream->warned_64bit = TRUE;
		}
		errno = EFBIG;
		return FALSE;
	}
	return TRUE;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean file_close(ChmStream *stream)
{
	int ret;
	
	if (stream->file == stdout || stream->file == stderr || stream->file == stdin)
	{
		ret = fflush(stream->file);
	} else
	{
		ret = fclose(stream->file);
	}
	g_free(stream);
	return ret == 0;
}

/*** ---------------------------------------------------------------------- ***/

static chm_off_t file_tell(ChmStream *stream)
{
#ifdef __WIN32__
	return ftello64(stream->file);
#else
	return ftello(stream->file);
#endif
}

/*** ---------------------------------------------------------------------- ***/

static gboolean file_seek(ChmStream *stream, chm_off_t pos, int whence)
{
	int res;
	
	if (!check_64bit(stream, pos))
		return FALSE;
#ifdef __WIN32__
	res = fseeko64(stream->file, pos, whence);
#else
	res = fseeko(stream->file, pos, whence);
#endif
	if (res != 0 ||
		(whence == SEEK_SET && stream->tell(stream) != pos))
	{
		return FALSE;
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static size_t file_write(ChmStream *stream, const void *buffer, size_t len)
{
	size_t written = fwrite(buffer, 1, len, stream->file);
	return written;
}

/*** ---------------------------------------------------------------------- ***/

static size_t file_read(ChmStream *stream, void *buffer, size_t len)
{
	size_t nread = fread(buffer, 1, len, stream->file);
	return nread;
}

/*** ---------------------------------------------------------------------- ***/

static int file_getc(ChmStream *stream)
{
	return getc(stream->file);
}

/*** ---------------------------------------------------------------------- ***/

static int file_putc(ChmStream *stream, int c)
{
	return putc(c, stream->file);
}

/*** ---------------------------------------------------------------------- ***/

ChmStream *ChmStream_CreateForFile(FILE *fp)
{
	ChmStream *stream;
	
	if (fp == NULL)
		return NULL;
	stream = g_new0(ChmStream, 1);
	if (stream == NULL)
		return NULL;
	stream->type = chm_stream_file;
	stream->owned = FALSE;
	stream->filename = NULL;
	stream->len = 0;
	stream->file = fp;
	stream->close = file_close;
	stream->tell = file_tell;
	stream->seek = file_seek;
	stream->read = file_read;
	stream->write = file_write;
	stream->fgetc = file_getc;
	stream->fputc = file_putc;
	if (fp != stdout && fp != stderr && fp != stdin)
	{
		if (stream->seek(stream, 0, SEEK_END))
		{
			stream->len = stream->tell(stream);
			stream->seek(stream, 0, SEEK_SET);
		}
	}		
#ifdef __WIN32__
	stream->supports_64bit = TRUE;
#else
	stream->supports_64bit = sizeof(off_t) >= 8;
#endif
	stream->warned_64bit = FALSE;
	return stream;
}

/*** ---------------------------------------------------------------------- ***/

ChmStream *ChmStream_Open(const char *filename, gboolean readonly)
{
	ChmStream *stream;
	FILE *fp;
	
	if (!readonly && strcmp(filename, "-") == 0)
	{
		fp = stdout;
		filename = "<stdout>";
	} else
	{
		fp = fopen(filename, readonly ? "rb" : "wb");
	}
	if (fp == NULL)
		return NULL;
	stream = ChmStream_CreateForFile(fp);
	if (stream)
		stream->filename = g_strdup(filename);
	return stream;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean mem_close(ChmStream *stream)
{
	if (stream->mem.alloced)
	{
		g_free(stream->mem.base);
	}
	g_free(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static chm_off_t mem_tell(ChmStream *stream)
{
	return stream->mem.pos;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean mem_seek(ChmStream *stream, chm_off_t pos, int whence)
{
	if (whence != SEEK_SET)
		return FALSE;
	if (pos > stream->len)
	{
		errno = EINVAL;
		return FALSE;
	}
	stream->mem.pos = pos;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean mem_make_space(ChmStream *stream, size_t len)
{
	size_t space = stream->mem.alloclen - stream->mem.pos;
	
	if (len > space)
	{
		size_t newsize;
		unsigned char *newbuf;
		
		if (!stream->mem.alloced)
		{
			errno = EIO;
			return FALSE;
		}
		newsize = ((stream->len + len + 0x1000 - 1) / 0x1000) * 0x1000;
		newbuf = g_renew(unsigned char, stream->mem.base, newsize);
		if (newbuf == NULL)
			return FALSE;
		stream->mem.base = newbuf;
		stream->mem.alloclen = newsize;
	}
	if ((stream->mem.pos + len) > stream->len)
		stream->len = stream->mem.pos + len;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static size_t mem_write(ChmStream *stream, const void *buffer, size_t len)
{
	if (!mem_make_space(stream, len))
		return 0;
	memcpy(stream->mem.base + stream->mem.pos, buffer, len);
	stream->mem.pos += len;
	return len;
}

/*** ---------------------------------------------------------------------- ***/

static size_t mem_read(ChmStream *stream, void *buffer, size_t len)
{
	size_t space = stream->len - stream->mem.pos;
	
	if (len > space)
	{
		len = space;
	}
	memcpy(buffer, stream->mem.base + stream->mem.pos, len);
	stream->mem.pos += len;
	return len;
}

/*** ---------------------------------------------------------------------- ***/

static int mem_getc(ChmStream *stream)
{
	if (stream->mem.pos >= stream->len)
		return EOF;
	return stream->mem.base[stream->mem.pos++];
}

/*** ---------------------------------------------------------------------- ***/

static int mem_putc(ChmStream *stream, int c)
{
	if (!mem_make_space(stream, 1))
		return FALSE;
	stream->mem.base[stream->mem.pos++] = c;
	return c;
}

/*** ---------------------------------------------------------------------- ***/

ChmMemoryStream *ChmStream_CreateMem(chm_off_t size)
{
	ChmStream *stream;
	
	if (size >= (chm_off_t)0x7ffffff0UL || (size_t)size != size)
	{
		errno = EFBIG;
		return NULL;
	}
	stream = g_new0(ChmStream, 1);
	if (stream == NULL)
		return NULL;
	stream->type = chm_stream_mem;
	stream->owned = FALSE;
	stream->filename = NULL;
	stream->mem.base = g_new(unsigned char, size + 1);
	if (stream->mem.base == NULL)
	{
		g_free(stream);
		return NULL;
	}
	stream->len = size;
	stream->mem.pos = 0;
	stream->mem.alloclen = size;
	stream->mem.alloced = TRUE;
	stream->close = mem_close;
	stream->tell = mem_tell;
	stream->seek = mem_seek;
	stream->write = mem_write;
	stream->read = mem_read;
	stream->fgetc = mem_getc;
	stream->fputc = mem_putc;
	/*
	 * even if it would work on 64bit hosts,
	 * we don't want memory streams of excessive size
	 */
	stream->supports_64bit = FALSE;
	stream->warned_64bit = FALSE;
	return stream;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmStream_CopyFrom(ChmMemoryStream *stream, ChmStream *src, size_t size)
{
	assert(stream);
	assert(src);
	if (stream->type == chm_stream_mem)
	{
		if (!mem_make_space(stream, size))
			return FALSE;
		if (src->read(src, stream->mem.base + stream->mem.pos, size) != size)
			return FALSE;
		stream->mem.pos += size;
		return TRUE;
	} else if (src->type == chm_stream_mem)
	{
		if (stream->write(stream, src->mem.base + src->mem.pos, size) != size)
			return FALSE;
		src->mem.pos += size;
		return TRUE;
	}
	/* NYI */
	return FALSE;
}

/*** ---------------------------------------------------------------------- ***/

chm_off_t ChmStream_Size(ChmStream *stream)
{
	if (stream == NULL)
		return 0;
	return stream->len;
}

/*** ---------------------------------------------------------------------- ***/

void ChmStream_TakeOwner(ChmStream *stream, gboolean owned)
{
	if (stream)
		stream->owned = owned;
}

/*** ---------------------------------------------------------------------- ***/

unsigned char *ChmStream_Memptr(ChmStream *stream)
{
	if (stream == NULL || stream->type != chm_stream_mem)
		return NULL;
	return stream->mem.base;
}

/*** ---------------------------------------------------------------------- ***/

chmstream_type ChmStream_Type(ChmStream *stream)
{
	return stream ? stream->type : chm_stream_null;
}

/*** ---------------------------------------------------------------------- ***/

FILE *ChmStream_Fileptr(ChmStream *stream)
{
	return stream && stream->type == chm_stream_file ? stream->file : NULL;
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmStream_Close(ChmStream *stream)
{
	if (stream == NULL || stream->owned)
		return FALSE;
	g_free(stream->filename);
	return stream->close(stream);
}

/*** ---------------------------------------------------------------------- ***/

gboolean ChmStream_Seek(ChmStream *stream, chm_off_t pos)
{
	assert(stream);
	return stream->seek(stream, pos, SEEK_SET);
}

/*** ---------------------------------------------------------------------- ***/

chm_off_t ChmStream_Tell(ChmStream *stream)
{
	assert(stream);
	return stream->tell(stream);
}

/*** ---------------------------------------------------------------------- ***/

size_t ChmStream_Write(ChmStream *stream, const void *buffer, size_t len)
{
	assert(stream);
	return stream->write(stream, buffer, len);
}

/*** ---------------------------------------------------------------------- ***/

size_t ChmStream_Read(ChmStream *stream, void *buffer, size_t len)
{
	assert(stream);
	return stream->read(stream, buffer, len);
}

/*** ---------------------------------------------------------------------- ***/

int ChmStream_fgetc(ChmStream *stream)
{
	assert(stream);
	return stream->fgetc(stream);
}

/*** ---------------------------------------------------------------------- ***/

int ChmStream_fputc(ChmStream *stream, int c)
{
	assert(stream);
	return stream->fputc(stream, c);
}

/*** ---------------------------------------------------------------------- ***/

const char *ChmStream_GetFilename(ChmStream *stream)
{
	if (stream == NULL)
		return NULL;
	return stream->filename;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

uint16_t chmstream_read_le16(ChmStream *stream)
{
	uint32_t c1, c2;
	
	c1 = ChmStream_fgetc(stream);
	c2 = ChmStream_fgetc(stream);
	return (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

uint32_t chmstream_read_le32(ChmStream *stream)
{
	uint32_t c1, c2, c3, c4;
	
	c1 = ChmStream_fgetc(stream);
	c2 = ChmStream_fgetc(stream);
	c3 = ChmStream_fgetc(stream);
	c4 = ChmStream_fgetc(stream);
	return (c4 << 24) | (c3 << 16) | (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

uint64_t chmstream_read_le64(ChmStream *stream)
{
	uint64_t l1, l2;
	
	l1 = chmstream_read_le32(stream);
	l2 = chmstream_read_le32(stream);
	return (l2 << 32) | l1;
}

/*** ---------------------------------------------------------------------- ***/

uint16_t chmstream_read_be16(ChmStream *stream)
{
	uint32_t c1, c2;
	
	c2 = ChmStream_fgetc(stream);
	c1 = ChmStream_fgetc(stream);
	return (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

uint32_t chmstream_read_be32(ChmStream *stream)
{
	uint32_t c1, c2, c3, c4;
	
	c1 = ChmStream_fgetc(stream);
	c2 = ChmStream_fgetc(stream);
	c3 = ChmStream_fgetc(stream);
	c4 = ChmStream_fgetc(stream);
	return (c1 << 24) | (c2 << 16) | (c3 << 8) | c4;
}

/*** ---------------------------------------------------------------------- ***/

uint64_t chmstream_read_be64(ChmStream *stream)
{
	uint64_t l1, l2;
	
	l2 = chmstream_read_be32(stream);
	l1 = chmstream_read_be32(stream);
	return (l2 << 32) | l1;
}

/*** ---------------------------------------------------------------------- ***/

gboolean chmstream_write_le16(ChmStream *stream, uint16_t val)
{
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	val >>= 8;
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean chmstream_write_le32(ChmStream *stream, uint32_t val)
{
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	val >>= 8;
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	val >>= 8;
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	val >>= 8;
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean chmstream_write_le64(ChmStream *stream, uint64_t val)
{
	if (chmstream_write_le32(stream, val) == FALSE)
		return FALSE;
	val >>= 32;
	if (chmstream_write_le32(stream, val) == FALSE)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean chmstream_write_be16(ChmStream *stream, uint16_t val)
{
	if (ChmStream_fputc(stream, val >> 8) < 0)
		return FALSE;
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean chmstream_write_be32(ChmStream *stream, uint32_t val)
{
	if (ChmStream_fputc(stream, val >> 24) < 0)
		return FALSE;
	if (ChmStream_fputc(stream, val >> 16) < 0)
		return FALSE;
	if (ChmStream_fputc(stream, val >> 8) < 0)
		return FALSE;
	if (ChmStream_fputc(stream, val) < 0)
		return FALSE;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

gboolean chmstream_write_be64(ChmStream *stream, uint64_t val)
{
	if (chmstream_write_be32(stream, val >> 32) == FALSE)
		return FALSE;
	if (chmstream_write_be32(stream, val) == FALSE)
		return FALSE;
	return TRUE;
}
