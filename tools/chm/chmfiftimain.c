#include "chmtools.h"
#include "chmreader.h"

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

ChmSearchReader *ChmSearchReader_Create(CHMStream *AStream, gboolean AFreeStreamOnDestroy)
{
	ChmSearchReader *reader = NULL;
	(void) AStream;
	(void) AFreeStreamOnDestroy;
	return reader;
}

/*** ---------------------------------------------------------------------- ***/

void ChmSearchReader_Destroy(ChmSearchReader *reader)
{
	if (reader == NULL)
		return;
	g_free(reader);
}
