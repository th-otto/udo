#include <string.h>

#include "Utility.h"
#include "Log.h"
#include "misc.h"

USHORT APIENTRY NHMSearchMIndex( PVOID pInstance,
                                 HWND hwnd,
                                 PSZ pchText )
{
  LogEvent( "SearchMIndex" );
  return 0;
}


// e.g.   p = DBMstrtok2(EnvStr, "; \0");
// probably just use strtok unless you really want to support dbcs
PCH APIENTRY NHMDBMstrtok2( PCH s1, PCH s2 )
{
  LogEvent( "DBMstrtok2" );
  return strtok( s1, s2 );
}


INT APIENTRY NHMMscStrniCmp( PCH s1, PCH s2, INT len, PVOID thing )
{
  LogEvent( "MscStrniCmp" );
  // No idea what thing parameter might be for
  return strnicmp( s1, s2, len );
}


// e.g.
// pCountry = (PVOID)WinSendMsg ( _hwndMIndexInstance,
//                                HM_QPSTRUCT,
//                                MPFROMSHORT(STRUCT_COUNTRY_INFO),
//                                NULL );
// if ( MscStriCmp( TabText.pString, szBuf1, pCountry ) )
//   ...
INT APIENTRY NHMMscStriCmp( PCH s1, PCH s2, PVOID thing )
{
  LogEvent( "MscStriCmp" );
  return stricmp( s1, s2 );
}

// typedef void* PINSTANCE;


// Attempt to see if we can get OpenChat running (not with help tho)
BOOL APIENTRY NHM32SetHelpDatabase(PINSTANCE pInstance, PSZ DatabaseName, USHORT usObtimizeType)
{
  // Jolly good, whatever you say...
  LogEvent( "NHM32SetHelpDatabase" );
  LogEvent( "  DatabaseName: %s", DatabaseName );
  LogEvent( "  usObtimizeType: %hu", usObtimizeType );
  LogData( (char*) pInstance, sizeof( INSTANCE ) );
  return TRUE;
}


BOOL APIENTRY NHM32IOLoadAllTOC( PINSTANCE pInstance )
{
  LogEvent( "NHM32IOLoadAllTOC" );
  return TRUE;
}


BOOL APIENTRY NHM32IOFreeIOInfoList( PINSTANCE pInstance )
{
  LogEvent( "NHM32IOFreeIOInfoList" );
  return TRUE;
}


BOOL APIENTRY NHM32IOFreeAllTOC( PINSTANCE pInstance )
{
  LogEvent( "NHM32IOFreeAllTOC" );
  return TRUE;
}

