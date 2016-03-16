#include "chmtools.h"
#include "fasthtmlparser.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

/*
 * default dummy "do nothing" events if events are unassigned
 */
void HTMLParser_NilOnFoundTag(void *obj, const char *ActualTag, size_t len)
{
	UNUSED(obj);
	UNUSED(ActualTag);
	UNUSED(len);
}

/*** ---------------------------------------------------------------------- ***/

void HTMLParser_NilOnFoundText(void *obj, const char *Text, size_t len)
{
	UNUSED(obj);
	UNUSED(Text);
	UNUSED(len);
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

HTMLParser *HTMLParser_Create(const char *sRaw, size_t size)
{
	HTMLParser *parser;
	
	if (sRaw == NULL || *sRaw == '\0')
		return NULL;
	parser = g_new(HTMLParser, 1);
	if (parser == NULL)
		return NULL;
	parser->Done = FALSE;
	/* set nil events once rather than checking for nil each time tag is found */
	parser->OnFoundTag = HTMLParser_NilOnFoundTag;
	parser->OnFoundText = HTMLParser_NilOnFoundText;
	parser->Raw = sRaw;
	parser->size = size;
	parser->FCurrent = NULL;
	parser->obj = NULL;
	return parser;
}

/*** ---------------------------------------------------------------------- ***/

void HTMLParser_Destroy(HTMLParser *parser)
{
	if (parser)
	{
		g_free(parser);
	}
}

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

size_t HTMLParser_CurrentPos(HTMLParser *parser)
{
	if (parser && parser->Raw && parser->FCurrent)
		return parser->FCurrent - parser->Raw;
	return 0;
}

/*** ---------------------------------------------------------------------- ***/

void HTMLParser_Exec(HTMLParser *parser)
{
	size_t L;
	size_t TL;
	size_t I;
	const char *TagStart;
	const char *TextStart;
	const char *P;
	char c;
	
	parser->Done = FALSE;
	P = parser->Raw;
	if (P == NULL)
		return;
	TL = parser->size;
	I = 0;

	TagStart = NULL;
	do {
		TextStart = P;
		/* Get next tag position */
		while (I < TL && *P != '<' && *P != '\0')
		{
			++P;
			++I;
			if (I >= TL)
			{
				parser->Done = TRUE;
				break;
			}
		}
		if (parser->Done)
			break;
		
		/* Is there any text before ? */
		if (TextStart != NULL && P > TextStart)
		{
			L = P - TextStart;
			/* Yes, copy to buffer */
			parser->FCurrent = P;
			parser->OnFoundText(parser->obj, TextStart, L);
		} else
		{
			TextStart = NULL;
		}
		
		TagStart = P;
		while (I < TL && *P != '>' && *P != '\0')
		{
			/* Find string in tag */
			if (*P == '"' || *P == '\'')
			{
				c = *P;
				P++;
				I++;
				/* Skip until string end */
				while (I < TL && *P != '\0' && *P != c)
				{
					P++;
					I++;
				}
			}
			P++;
			I++;
			if (I >= TL)
			{
				parser->Done = TRUE;
				break;
			}
		}
		if (parser->Done)
			break;
		/* Copy this tag to buffer */
		L = P - TagStart + 1;
		parser->FCurrent = P;
		parser->OnFoundTag(parser->obj, TagStart, L);
		P++;
		I++;
		if (I >= TL)
			break;
	} while (!parser->Done);	
}
