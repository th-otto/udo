#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

#define INCL_DOSMISC
#include <os2.h>

#include "Utility.h"

#define LOG_DIR_VAR "HELPMGR_LOG_DIR"
#define LOG_FILENAME "helpmgr.log"

int g_CheckedEnvironment = 0;
char* g_LogFilePath = NULL;

void stoplog()
{
  g_LogFilePath = NULL;
}

void LogEvent( char* format, ... )
{
  char* LogDir;
  va_list ap;
  FILE* f;

  if ( g_CheckedEnvironment )
  {
    if ( g_LogFilePath == NULL )
      /* logging is not enabled */
      return;
  }
  else
  {
    /* check the environment var to see if logging is enabled */
    g_CheckedEnvironment = 1;
    LogDir = getenv( LOG_DIR_VAR );
    if ( LogDir == NULL )
      /* not defined */
      return;
    if ( strlen( LogDir ) == 0 )
      /* defined as blank? */
      return;

    /* allocate space for full path, plus slash, plus terminator */
    g_LogFilePath = malloc( strlen( LogDir ) + strlen( LOG_FILENAME ) + 2 );
    if ( g_LogFilePath == NULL )
      /* out of memory */
      return;

   /* copy path */
    strcpy( g_LogFilePath, LogDir );

    /* add ending slash if needed */
    if ( g_LogFilePath[ strlen( g_LogFilePath ) - 1 ] != '\\' )
      strcat( g_LogFilePath, "\\" );

    /* add filename */
    strcat( g_LogFilePath, LOG_FILENAME );
  }

  f = fopen( g_LogFilePath, "a" );
  if ( f == NULL )
  {
    DosBeep( 2000, 50 );
    printf( "fopen failed, errno %d: %s", errno, strerror( errno ) );
    return;
  }

  va_start( ap, format );
  vfprintf( f, format, ap );
  fprintf( f, "\n" );
  fclose( f );
  va_end( ap );
}

void LogData( char* data, int length )
{
  char* p;
  char buffer[ 64 ];
  char hex[ 4 ];
  int i;

  i = 0;
  p = data;

  while ( p < data + length )
  {
    if ( i == 0 )
    {
      strcpy( buffer, "" );
    }

    sprintf( hex, "%02x ", (int) *p );
    strcat( buffer, hex );

    p ++;

    i ++;
    if ( i == 16 )
    {
      i = 0;
      LogEvent( buffer );
    }
  }
  if ( i > 0 )
  {
    LogEvent( buffer );
  }
}
