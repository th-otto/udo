#ifndef __CHMSTREAM_H__
#define __CHMSTREAM_H__

typedef enum _chmstream_type {
	chm_stream_null,
	chm_stream_file,
	chm_stream_fd,
	chm_stream_mem
} chmstream_type;

typedef uint64_t chm_off_t;

typedef struct _CHMStream CHMStream;

typedef CHMStream CHMMemoryStream;
typedef CHMStream CHMFileStream;

CHMFileStream *CHMStream_CreateForFile(FILE *);
CHMFileStream *ChmStream_Open(const char *filename, gboolean readonly);
CHMMemoryStream *CHMStream_CreateMem(size_t size);
const char *ChmStream_GetFilename(CHMStream *stream);

chmstream_type CHMStream_type(CHMStream *stream);
FILE *CHMStream_filep(CHMStream *stream);
unsigned char *CHMStream_Memptr(CHMStream *stream);

gboolean CHMStream_close(CHMStream *stream);
gboolean CHMStream_seek(CHMStream *stream, chm_off_t pos) G_GNUC_WARN_UNUSED_RESULT;
chm_off_t CHMStream_tell(CHMStream *stream);
gboolean CHMStream_write(CHMStream *stream, const void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
gboolean CHMStream_read(CHMStream *stream, void *buffer, size_t len) G_GNUC_WARN_UNUSED_RESULT;
int CHMStream_fgetc(CHMStream *stream) G_GNUC_WARN_UNUSED_RESULT;
int CHMStream_fputc(CHMStream *stream, int c) G_GNUC_WARN_UNUSED_RESULT;

gboolean CHMStream_CopyFrom(CHMMemoryStream *stream, CHMStream *src, size_t size) G_GNUC_WARN_UNUSED_RESULT;
chm_off_t CHMStream_Size(CHMStream *stream);

uint16_t chmstream_read_le16(CHMStream *stream);
uint32_t chmstream_read_le32(CHMStream *stream);
uint64_t chmstream_read_le64(CHMStream *stream);
uint32_t chmstream_read_be32(CHMStream *stream);

#endif /* __CHMSTREAM_H__ */
