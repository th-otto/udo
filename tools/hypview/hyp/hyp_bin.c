#include "hypdoc.h"
#include "hv_ascii.h"
#include "hypdebug.h"

#ifdef __PUREC__
#include "hv_defs.h" /* Pure-C does not like anonymous struct _window_data_ */
#endif


/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

long BinaryAutolocator(WINDOW_DATA *win, long line, const char *search, gboolean casesensitive, gboolean wordonly)
{
	DOCUMENT *doc = hypwin_doc(win);
	FMT_ASCII *ascii = (FMT_ASCII *) doc->data;
	const unsigned char *src, *end;
	size_t len = strlen(search);
	int ret;
	
	if (!ascii)							/* no file loaded */
		return -1;

	UNUSED(wordonly); /* TODO */
	
	end = ascii->start + ascii->length - len;
	src = ascii->start + line * gl_profile.viewer.binary_columns;
	if (doc->autolocator_dir > 0)
	{
		while (src <= end)
		{
			ret = casesensitive ? strncmp((const char *)src, search, len) : strncasecmp((const char *)src, search, len);
			if (ret == 0)
			{
				return (src - 1 - ascii->start) / gl_profile.viewer.binary_columns;
			}
			src++;
		}
	} else
	{
		while (src >= ascii->start)
		{
			ret = casesensitive ? strncmp((const char *)src, search, len) : strncasecmp((const char *)src, search, len);
			if (ret == 0)
			{
				return (src - 1 - ascii->start) / gl_profile.viewer.binary_columns;
			}
			src--;
		}
	}
	return -1;
}

/*** ---------------------------------------------------------------------- ***/

gboolean BinaryBlockOperations(WINDOW_DATA *win, hyp_blockop op, BLOCK *block, void *param)
{
	DOCUMENT *doc = hypwin_doc(win);
	FMT_ASCII *ascii = (FMT_ASCII *) doc->data;

	if (!block->valid)
	{
		HYP_DBG(("Operation on invalid block"));
		return FALSE;
	}

	switch (op)
	{
	case BLK_ASCIISAVE:
		{
			ssize_t ret, len;
			const unsigned char *src;
			int *handle = (int *) param;

			src = ascii->start + block->start.line * gl_profile.viewer.binary_columns + block->start.offset;
			len = (block->end.line - block->start.line) * gl_profile.viewer.binary_columns + block->end.offset - block->start.offset;
			ret = write(*handle, src, len);
			if (ret != len)
			{
				HYP_DBG(("Error %s while writing file. Abort.", hyp_utf8_strerror(errno)));
				return FALSE;
			}
		}
		break;
		
	case BLK_PRINT:
		break;
	}
	
	return TRUE;
}
