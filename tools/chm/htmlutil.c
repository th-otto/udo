#include "chmtools.h"
#include "htmlutil.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

/*
 * Return tag name, case preserved
 */
char *GetTagName(const char *tag, size_t len)
{
	const char *P;
	const char *S;
	const char *end;
	
	P = tag;
	end = tag + len;
	while (P < end && (*P == '<' || *P == ' ' || *P == '\t'))
	{
		P++;
	}
	S = P;
	while (P < end && *P != '\0' && *P != ' ' && *P != '>')
	{
		P++;
	}
	if (P == S)
		return NULL;
	return g_strndup(S, P - S);
}

/*** ---------------------------------------------------------------------- ***/

/*
 * Return tag name in uppercase
 */
char *GetUpTagName(const char *tag, size_t len)
{
	return g_strup(GetTagName(tag, len));
}

/*** ---------------------------------------------------------------------- ***/

/*
 * Return name=value pair ignoring case of NAME, preserving case of VALUE
 */
char *GetNameValPair(const char *tag, size_t taglen, const char *attribname_ci)
{
	const char *P;
	const char *S;
	char *UpperTag;
	char *UpperAttrib;
	size_t Start;
	size_t L;
	char c;
	char *result = NULL;
	
	if (taglen == 0 || empty(tag) || empty(attribname_ci))
		return NULL;
	/* must be space before case insensitive NAME, i.e. <a HREF="" STYLE="" */
	UpperAttrib = g_strconcat(" ", attribname_ci, NULL);
	g_strup(UpperAttrib);
	UpperTag = g_strup(g_strndup(tag, taglen));
	P = UpperTag;
	S = strstr(P, UpperAttrib);
	if (S != NULL)
	{
		S++;	/* skip space */
		P = S;
		while (*P != '\0' && *P != '=' && *P != ' ' && *P != '>')
			P++;
		if (*P == '=')
			++P;
		while (*P != '\0' && *P != ' ' && *P != '>')
		{
			if (*P == '"' || *P == '\'')
			{
				c = *P;
				++P;
			} else
			{
				c = ' ';
			}
			while (*P != '\0' && *P != '>' && *P != c)
				P++;
			if (*P != '>' && *P != '\0')
				P++;
			break;
		}
		L = P - S;
		Start = S - UpperTag;
		P = tag;
		S = P + Start;
		result = g_strndup(S, L);
	}
	g_free(UpperTag);
	g_free(UpperAttrib);
	return result;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * Get value of attribute, e.g WIDTH=36 -return-> 36, preserves case sensitive
 */
char *GetValFromNameVal(const char *namevalpair)
{
	const char *P;
	const char *S;
	char c;
	char *result = NULL;
	
	P = namevalpair;
	if (empty(P))
		return NULL;
	S = strchr(P, '=');

	if (S != NULL)
	{
		S++; 	/* skip equal */
		P = S;	/* set P to a character after = */
		while (*P == ' ')
			P++;
		if (*P == '"' || *P == '\'')
		{
			c = *P;
			P++; /* Skip current character */
		} else
		{
			c = ' ';
		}
		S = P;
		while (*P != c && *P != '\0')
			P++;

		if (P != S)
			result = g_strndup(S, P - S);
	}
	return result;
}

/*** ---------------------------------------------------------------------- ***/

/*
 * return value of an attribute (attribname_ci), case ignored for NAME portion, but return value case is preserved
 */
char *GetVal(const char *tag, size_t taglen, const char *attribname_ci)
{
	/* returns full name=value pair */
	char *namevalpair = GetNameValPair(tag, taglen, attribname_ci);
	/* extracts value portion only */
	char *result = GetValFromNameVal(namevalpair);
	g_free(namevalpair);
	return result;
}
