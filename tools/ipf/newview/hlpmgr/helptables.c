#include <stdlib.h>
#include <string.h>

#define INCL_WINHELP
#define INCL_DOSRESOURCES
#include <os2.h>

#include "HelpTables.h"
#include "log.h"

void LoadHelpTableFromResource( PHELPTABLE* ppHelpTable,
                                HMODULE Module,
                                USHORT idHelpTable )
{
  int i;
  int TableEntryCount;
  APIRET rc;
  USHORT idSubTable;
  PHELPTABLE pHelpTable;
  PHELPSUBTABLE2 pHelpSubTable;
  PVOID pResourceData;
  ULONG ulResourceSize;

  PBYTE p;
  PHELPSUBTABLEENTRY pEntry;

  LogEvent( "Loading Help Table from Resource %hu", idHelpTable );

  rc = DosQueryResourceSize( Module,
                             RT_HELPTABLE,
                             idHelpTable,
                             & ulResourceSize );
  if ( rc != 0 )
  {
    LogEvent( "  DosQueryResourceSize Failed, rc = %d", rc );
    return;
  }

  LogEvent( "  Resource Size: %u", ulResourceSize );
  TableEntryCount = ulResourceSize / sizeof( HELPTABLE );
  LogEvent( "    Count: %d", TableEntryCount );

  rc = DosGetResource( Module,
                       RT_HELPTABLE,
                       idHelpTable,
                       & pResourceData );

  if ( rc != 0 )
  {
    LogEvent( "  DosGetResource Failed, rc = %d", rc );
    return;
  }

  pHelpTable = (PHELPTABLE) malloc( ( TableEntryCount + 1 ) // space for terminator
                                    * sizeof( HELPTABLE ) );
  memcpy( pHelpTable, pResourceData, ulResourceSize );
  DosFreeResource( pResourceData );

  *ppHelpTable = pHelpTable;

  LogEvent( "# Win Panel Sub" );
  for ( i = 0; i < TableEntryCount; i ++ )
  {
    LogEvent( "%d %hu %hu %hu",
              i,
              pHelpTable[ i ].idAppWindow,
              pHelpTable[ i ].idExtPanel,
              (USHORT) pHelpTable[ i ].phstHelpSubTable );

    idSubTable = (USHORT) pHelpTable[ i ].phstHelpSubTable;
    LogEvent( "Loading subtable %hu", idSubTable );

    pHelpSubTable = NULL;

    rc = DosQueryResourceSize( Module,
                               RT_HELPSUBTABLE,
                               idSubTable,
                               & ulResourceSize );
    if ( rc == 0 )
    {
      LogEvent( "  Resource Size: %u", ulResourceSize );
      rc = DosGetResource( Module,
                           RT_HELPSUBTABLE,
                           idSubTable,
                           & pResourceData );
      if ( rc == 0 ) 
      {
        // allocate space including terminator
        pHelpSubTable = 
          (PHELPSUBTABLE2) malloc( ulResourceSize 
                                   + 2 * sizeof( USHORT ) ); 
        memcpy( pHelpSubTable, pResourceData, ulResourceSize );

        // terminate
        memset( (char*) pHelpSubTable + ulResourceSize, 0, 2 * sizeof( USHORT ) );

        LogEvent( "  Subtable: %8x", pHelpSubTable );
	LogData( pResourceData, ulResourceSize );

        DosFreeResource( pResourceData );

        p = (PBYTE) pHelpSubTable -> HelpSubTableEntry;

        while(    ( ( (PHELPSUBTABLEENTRY) p ) -> idWindow != 0 )
               || ( ( (PHELPSUBTABLEENTRY) p ) -> idPanel != 0 ) )
        {       
          pEntry = (PHELPSUBTABLEENTRY) p;

          LogEvent( "  Window: %hu Panel: %hu",
                    pEntry -> idWindow,
                    pEntry -> idPanel );
        
          p += pHelpSubTable -> usSubitemSize * sizeof( USHORT );
        }
      }
      else
      {
        LogEvent( "  DosGetResource Failed, rc = %d", rc );
      }
    }
    else
    {
      LogEvent( "  DosQueryResourceSize Failed, rc = %d", rc );
    }

    // save help subtable
    pHelpTable[ i ].phstHelpSubTable = (PHELPSUBTABLE) pHelpSubTable;
  }

  // terminate
  memset( & pHelpTable[ TableEntryCount ], 0, sizeof( HELPTABLE ) );

  LogEvent( "Help Table Loaded" );
}

void LoadHelpTableFromMemory( PHELPTABLE* ppDestTable,
                              PHELPTABLE pSourceTable )
{
  int i;
  int ItemSize;
  int SubTableSize;
  int TableSize;
  PHELPTABLE pDestTable;
  PHELPSUBTABLE2 pSourceSubTable;
  PHELPSUBTABLE2 pDestSubTable;
  PBYTE p;
  PHELPSUBTABLEENTRY pEntry;

  LogEvent( "Loading Help Table from Memory" );
  LogEvent( "  Source: %8x", (ULONG) pSourceTable );

  // First go thru the table to find the end and hence size to copy
  i = 0;
  LogEvent( "# Win Panel Sub" );
  while (    ( pSourceTable[ i ].idAppWindow != 0 )
          || ( pSourceTable[ i ].idExtPanel != 0 )
          || ( pSourceTable[ i ].phstHelpSubTable != 0 ) )
  {
    LogEvent( "%d %hu %hu %8x",
              i,
              pSourceTable[ i ].idAppWindow,
              pSourceTable[ i ].idExtPanel,
              (ULONG) pSourceTable[ i ].phstHelpSubTable );
    i ++;
  }
  // i is now count of entries, less terminating null entry
  LogEvent( "  Found %d entries", i );

  // Calculate table size, 
  // including terminating null entry
  TableSize = ( i + 1 ) * sizeof( HELPTABLE ); 
 
  // allocate mem for the copied table
  pDestTable = (PHELPTABLE) malloc( TableSize );

  LogEvent( "  New Table: %8x", (ULONG) pDestTable );

  // Copy table
  // we will later overwrite the copied subtable pointers
  memcpy( pDestTable, pSourceTable, TableSize );

  // store new table return value
  *ppDestTable = pDestTable;

  // now go thru subtables and copy them
  i = 0;
  while (    ( pSourceTable[ i ].idAppWindow != 0 )
          || ( pSourceTable[ i ].idExtPanel != 0 )
          || ( pSourceTable[ i ].phstHelpSubTable != 0 ) )
  {
    // copy subtable
    
    // get pointer to source subtable
    pSourceSubTable = 
      (PHELPSUBTABLE2) pSourceTable[ i ].phstHelpSubTable;

    LogEvent( "Loading subtable at %8x", 
              (ULONG) pSourceSubTable );

    LogEvent( "  Entry size: %hu", 
              pSourceSubTable -> usSubitemSize );

    // calculate size of subtable entries (which is variable)
    ItemSize = ( pSourceSubTable -> usSubitemSize ) 
               * sizeof( USHORT );

    // now see how large the subtable is
    SubTableSize = 0;
    p = (PBYTE) pSourceSubTable -> HelpSubTableEntry;
    while(    ( ( (PHELPSUBTABLEENTRY) p ) -> idWindow != 0 )
           || ( ( (PHELPSUBTABLEENTRY) p ) -> idPanel != 0 )  )
    {       
      pEntry = (PHELPSUBTABLEENTRY) p;
      p += ItemSize;
      SubTableSize += ItemSize;
    }   

    // allow for null terminating entry
    SubTableSize += ItemSize; 

    LogEvent( "  Total subtable size: %d", SubTableSize );
   
    LogEvent( "  Allocating mem" );
    pDestSubTable = (PHELPSUBTABLE2) malloc( SubTableSize );
    LogEvent( "  Copying subtable" );
    memcpy( pDestSubTable, pSourceSubTable, SubTableSize );

    // save help subtable
    pDestTable[ i ].phstHelpSubTable = (PHELPSUBTABLE) pDestSubTable;

    LogEvent( "  SubTable loaded" );

    i ++;
  }

  LogEvent( "Help Table Loaded" );
}

void FreeHelpTable( PHELPTABLE* ppHelpTable )
{
  int i;  
  PHELPTABLE pHelpTable;

  pHelpTable = *ppHelpTable;

  if ( pHelpTable == NULL )  
    return;

  LogEvent( "Freeing subtables" );

  i = 0;
  while (    ( pHelpTable[ i ].idAppWindow != 0 )
          || ( pHelpTable[ i ].idExtPanel != 0 )
          || ( pHelpTable[ i ].phstHelpSubTable != 0 ) )
  {
    LogEvent( "  Subtable %d", i );
    if ( pHelpTable[ i ].phstHelpSubTable != NULL )
      free( pHelpTable[ i ].phstHelpSubTable );
    i ++;
  }

  LogEvent( "Freeing help table" );

  free( pHelpTable );

  *ppHelpTable = NULL;

  LogEvent( "Done" );

}

BOOL FindIDInHelpTable( USHORT idWindow,
                        PHELPTABLE pHelpTable,
                        USHORT* pExtendedHelpPanelID,
                        PHELPSUBTABLE2* ppHelpSubTable )
{
  int i;

  LogEvent( "FindIDInHelpTable" );
  LogEvent( "  Search for Window ID: %hu", idWindow );
  LogEvent( "  In Help Table: %8x", (ULONG) pHelpTable );
  i = 0;
  while (    ( pHelpTable[ i ].idAppWindow != 0 )
          || ( pHelpTable[ i ].idExtPanel != 0 )
          || ( pHelpTable[ i ].phstHelpSubTable != 0 ) )
  {
    LogEvent( "  Window ID: %hu Extended Panel: %hu", 
              pHelpTable[ i ].idAppWindow,
              pHelpTable[ i ].idExtPanel );

    if ( pHelpTable[ i ].idAppWindow == idWindow ) 
    {
      // found
      LogEvent( "  Found", i );
        
      // note the cast to PHELPSUBTABLE2 because the PM definition
      // is a bit wonky...
      *ppHelpSubTable = 
        (PHELPSUBTABLE2) pHelpTable[ i ].phstHelpSubTable; 

      *pExtendedHelpPanelID = pHelpTable[ i ].idExtPanel;
      return TRUE;
    }
    i ++;
  }
  LogEvent( "  Not found" );
  return FALSE;
}

BOOL FindIDInHelpSubTable( USHORT id,
                           PHELPSUBTABLE2 pHelpSubTable,
                           USHORT* pPanelID )
{
  PBYTE p;
  PHELPSUBTABLEENTRY pEntry;

  LogEvent( "FindIDInHelpSubTable" );
  LogEvent( "  Entry size: %hu", 
            pHelpSubTable -> usSubitemSize );

  p = (PBYTE) pHelpSubTable -> HelpSubTableEntry;

  while(    ( ( (PHELPSUBTABLEENTRY) p ) -> idWindow != 0 )
         || ( ( (PHELPSUBTABLEENTRY) p ) -> idPanel != 0 ) )
  {       
    pEntry = (PHELPSUBTABLEENTRY) p;

    LogEvent( "  Window: %hu Panel: %hu",
              pEntry -> idWindow,
              pEntry -> idPanel );
    if ( pEntry -> idWindow == id ) 
    {
      // found
      *pPanelID = pEntry -> idPanel;
      return TRUE;
    }
    p += pHelpSubTable -> usSubitemSize * sizeof( USHORT );
  }

  return FALSE;
}
