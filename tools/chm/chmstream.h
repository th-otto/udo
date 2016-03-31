#ifndef __CHMSTREAM_H__
#define __CHMSTREAM_H__

typedef enum _chmstream_type {
	chm_stream_null,
	chm_stream_file,
	chm_stream_fd,
	chm_stream_mem
} chmstream_type;

typedef uint64_t chm_off_t;

typedef struct _ChmStream ChmStream;

typedef ChmStream ChmMemoryStream;
typedef ChmStream ChmFileStream;

ChmFileStream *ChmStream_CreateForFile(FILE *);
ChmFileStream *ChmStream_Open(const char *filename, gboolean readonly);
ChmMemoryStream *ChmStream_CreateMem(chm_off_t size);
const char *ChmStream_GetFilename(ChmStream *stream);

chmstream_type ChmStream_Type(ChmStream *stream);
FILE *ChmStream_Fileptr(ChmStream *stream);
unsigned char *ChmStream_Memptr(ChmStream *stream);

gboolean ChmStream_Close(ChmStream *stream);
gboolean ChmStream_Seek(ChmStream *stream, chm_off_t pos) G_GNUC_WARN_UNUSED_RESULT;
chm_off_t ChmStream_Tell(ChmStream *stream);
size_t ChmStream_Write(ChmStream *stream, const void *buffer, size_t len) /* G_GNUC_WARN_UNUSED_RESULT */;
size_t ChmStream_Read(ChmStream *stream, void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
int ChmStream_fgetc(ChmStream *stream) G_GNUC_WARN_UNUSED_RESULT;
int ChmStream_fputc(ChmStream *stream, int c) /* G_GNUC_WARN_UNUSED_RESULT */;

gboolean ChmStream_CopyFrom(ChmMemoryStream *stream, ChmStream *src, size_t size) /* G_GNUC_WARN_UNUSED_RESULT */;
chm_off_t ChmStream_Size(ChmStream *stream);

uint16_t chmstream_read_le16(ChmStream *stream);
uint32_t chmstream_read_le32(ChmStream *stream);
uint64_t chmstream_read_le64(ChmStream *stream);

uint16_t chmstream_read_be16(ChmStream *stream);
uint32_t chmstream_read_be32(ChmStream *stream);
uint64_t chmstream_read_be64(ChmStream *stream);

gboolean chmstream_write_le16(ChmStream *stream, uint16_t val);
gboolean chmstream_write_le32(ChmStream *stream, uint32_t val);
gboolean chmstream_write_le64(ChmStream *stream, uint64_t val);

gboolean chmstream_write_be16(ChmStream *stream, uint16_t val);
gboolean chmstream_write_be32(ChmStream *stream, uint32_t val);
gboolean chmstream_write_be64(ChmStream *stream, uint64_t val);

#endif /* __CHMSTREAM_H__ */
