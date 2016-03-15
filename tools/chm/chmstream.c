/*
 * define any symbols that might be needed to get 
 * support for large files
 */
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE
#define _FILE_OFFSET_BITS 64

#include "chmtools.h"

struct _CHMStream {
	chmstream_type type;
	chm_off_t len;
	gboolean owned;
	gboolean (*close)(CHMStream *stream);
	gboolean (*seek)(CHMStream *stream, chm_off_t pos, int whence);
	chm_off_t (*tell)(CHMStream *stream);
	gboolean (*write)(CHMStream *stream, const void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
	gboolean (*read)(CHMStream *stream, void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
	int (*fgetc)(CHMStream *stream) G_GNUC_WARN_UNUSED_RESULT;
	int (*fputc)(CHMStream *stream, int c) G_GNUC_WARN_UNUSED_RESULT;
	union {
		FILE *file;
		int fd;
		struct {
			unsigned char *base;
			chm_off_t pos;
			gboolean alloced;
		} mem;
	};
};

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean file_close(CHMStream *stream)
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

static chm_off_t file_tell(CHMStream *stream)
{
#ifdef __WIN32__
	return _ftelli64(stream->file);
#else
	return ftello(stream->file);
#endif
}

/*** ---------------------------------------------------------------------- ***/

static gboolean file_seek(CHMStream *stream, chm_off_t pos, int whence)
{
	int res;
	
#ifdef __WIN32__
	res = fseeko64(stream->file, pos, whence);
#else
	res = fseeko(stream->file, pos, whence);
#endif
	if (res != 0 ||
		stream->tell(stream) != pos)
	{
		if (pos > (uint32_t)0x7fffffff)
		{
			static int warned;
			if (!warned)
			{
				int save_errno = errno;
				
				fprintf(stderr, "seek error (file too large?)\n");
				warned = TRUE;
				errno = save_errno;
			}
		}
		return FALSE;
	}
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean file_write(CHMStream *stream, const void *buffer, size_t len)
{
	chm_off_t written = fwrite(buffer, 1, len, stream->file);
	return written == len;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean file_read(CHMStream *stream, void *buffer, size_t len)
{
	chm_off_t read = fread(buffer, 1, len, stream->file);
	return read == len;
}

/*** ---------------------------------------------------------------------- ***/

static int file_getc(CHMStream *stream)
{
	return getc(stream->file);
}

/*** ---------------------------------------------------------------------- ***/

static int file_putc(CHMStream *stream, int c)
{
	return putc(c, stream->file);
}

/*** ---------------------------------------------------------------------- ***/

CHMStream *CHMStream_CreateForFile(FILE *fp)
{
	CHMStream *stream;
	
	if (fp == NULL)
		return NULL;
	stream = g_new(CHMStream, 1);
	if (stream == NULL)
		return NULL;
	stream->type = chm_stream_file;
	stream->owned = FALSE;
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
	return stream;
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

static gboolean mem_close(CHMStream *stream)
{
	if (stream->mem.alloced)
	{
		g_free(stream->mem.base);
	}
	g_free(stream);
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static chm_off_t mem_tell(CHMStream *stream)
{
	return stream->mem.pos;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean mem_seek(CHMStream *stream, chm_off_t pos, int whence)
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

static gboolean mem_write(CHMStream *stream, const void *buffer, size_t len)
{
	chm_off_t space = stream->len - stream->mem.pos;
	
	if (len > space)
	{
		errno = EIO;
		return FALSE;
	}
	memcpy(stream->mem.base + stream->mem.pos, buffer, len);
	stream->mem.pos += len;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static gboolean mem_read(CHMStream *stream, void *buffer, size_t len)
{
	chm_off_t space = stream->len - stream->mem.pos;
	
	if (len > space)
	{
		errno = EIO;
		return FALSE;
	}
	memcpy(buffer, stream->mem.base + stream->mem.pos, len);
	stream->mem.pos += len;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

static int mem_getc(CHMStream *stream)
{
	if (stream->mem.pos >= stream->len)
		return EOF;
	return stream->mem.base[stream->mem.pos++];
}

/*** ---------------------------------------------------------------------- ***/

static int mem_putc(CHMStream *stream, int c)
{
	if (stream->mem.pos >= stream->len)
		return EOF;
	stream->mem.base[stream->mem.pos++] = c;
	return c;
}

/*** ---------------------------------------------------------------------- ***/

CHMMemoryStream *CHMStream_CreateMem(size_t size)
{
	CHMStream *stream;
	
	stream = g_new(CHMStream, 1);
	if (stream == NULL)
		return NULL;
	stream->type = chm_stream_mem;
	stream->owned = FALSE;
	stream->mem.base = g_new(unsigned char, size);
	if (stream->mem.base == NULL)
	{
		g_free(stream);
		return NULL;
	}
	stream->len = size;
	stream->mem.pos = 0;
	stream->mem.alloced = TRUE;
	stream->close = mem_close;
	stream->tell = mem_tell;
	stream->seek = mem_seek;
	stream->write = mem_write;
	stream->read = mem_read;
	stream->fgetc = mem_getc;
	stream->fputc = mem_putc;
	return stream;
}

/*** ---------------------------------------------------------------------- ***/

gboolean CHMStream_CopyFrom(CHMMemoryStream *stream, CHMStream *src, size_t size)
{
	chm_off_t space;

	assert(stream);
	assert(src);
	assert(stream->type == chm_stream_mem);
	space = stream->len - stream->mem.pos;
	if (space < size)
		return FALSE;
	if (src->read(src, stream->mem.base + stream->mem.pos, size) == FALSE)
		return FALSE;
	stream->mem.pos += size;
	return TRUE;
}

/*** ---------------------------------------------------------------------- ***/

chm_off_t CHMStream_Size(CHMStream *stream)
{
	if (stream == NULL)
		return 0;
	return stream->len;
}

/*** ---------------------------------------------------------------------- ***/

void CHMStream_TakeOwner(CHMStream *stream, gboolean owned)
{
	if (stream)
		stream->owned = owned;
}

/*** ---------------------------------------------------------------------- ***/

unsigned char *CHMStream_Memptr(CHMStream *stream)
{
	if (stream == NULL || stream->type != chm_stream_mem)
		return NULL;
	return stream->mem.base;
}

/*** ---------------------------------------------------------------------- ***/

chmstream_type CHMStream_type(CHMStream *stream)
{
	return stream ? stream->type : chm_stream_null;
}

/*** ---------------------------------------------------------------------- ***/

FILE *CHMStream_filep(CHMStream *stream)
{
	return stream && stream->type == chm_stream_file ? stream->file : NULL;
}

/*** ---------------------------------------------------------------------- ***/

gboolean CHMStream_close(CHMStream *stream)
{
	if (stream == NULL || stream->owned)
		return FALSE;
	return stream->close(stream);
}

/*** ---------------------------------------------------------------------- ***/

gboolean CHMStream_seek(CHMStream *stream, chm_off_t pos)
{
	assert(stream);
	return stream->seek(stream, pos, SEEK_SET);
}

/*** ---------------------------------------------------------------------- ***/

chm_off_t CHMStream_tell(CHMStream *stream)
{
	assert(stream);
	return stream->tell(stream);
}

/*** ---------------------------------------------------------------------- ***/

gboolean CHMStream_write(CHMStream *stream, const void *buffer, size_t len)
{
	assert(stream);
	return stream->write(stream, buffer, len);
}

/*** ---------------------------------------------------------------------- ***/

gboolean CHMStream_read(CHMStream *stream, void *buffer, size_t len)
{
	assert(stream);
	return stream->read(stream, buffer, len);
}

/*** ---------------------------------------------------------------------- ***/

int CHMStream_fgetc(CHMStream *stream)
{
	assert(stream);
	return stream->fgetc(stream);
}

/*** ---------------------------------------------------------------------- ***/

int CHMStream_fputc(CHMStream *stream, int c)
{
	assert(stream);
	return stream->fputc(stream, c);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

uint16_t chmstream_read_le16(CHMStream *stream)
{
	uint32_t c1, c2;
	
	c1 = CHMStream_fgetc(stream);
	c2 = CHMStream_fgetc(stream);
	return (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

uint32_t chmstream_read_le32(CHMStream *stream)
{
	uint32_t c1, c2, c3, c4;
	
	c1 = CHMStream_fgetc(stream);
	c2 = CHMStream_fgetc(stream);
	c3 = CHMStream_fgetc(stream);
	c4 = CHMStream_fgetc(stream);
	return (c4 << 24) | (c3 << 16) | (c2 << 8) | c1;
}

/*** ---------------------------------------------------------------------- ***/

uint64_t chmstream_read_le64(CHMStream *stream)
{
	uint64_t l1, l2;
	
	l1 = chmstream_read_le32(stream);
	l2 = chmstream_read_le32(stream);
	return (l2 << 32) | l1;
}

/*** ---------------------------------------------------------------------- ***/

uint32_t chmstream_read_be32(CHMStream *stream)
{
	uint32_t c1, c2, c3, c4;
	
	c1 = CHMStream_fgetc(stream);
	c2 = CHMStream_fgetc(stream);
	c3 = CHMStream_fgetc(stream);
	c4 = CHMStream_fgetc(stream);
	return (c1 << 24) | (c2 << 16) | (c3 << 8) | c4;
}
