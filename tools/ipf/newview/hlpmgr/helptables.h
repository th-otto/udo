#ifndef HELPTABLES_H
#define HELPTABLES_H

// correct definition for Help subtable

typedef struct
{
  USHORT idWindow; // window ID
  USHORT idPanel;  // IPF topic (panel ID)
  // there may be extra data here.
} HELPSUBTABLEENTRY;

typedef HELPSUBTABLEENTRY* PHELPSUBTABLEENTRY;

typedef struct
{
  USHORT            usSubitemSize;        //  Size of each entry
  HELPSUBTABLEENTRY HelpSubTableEntry[];  // Entries
} HELPSUBTABLE2; 

typedef HELPSUBTABLE2* PHELPSUBTABLE2;

void LoadHelpTableFromResource( PHELPTABLE* ppHelpTable,
                                HMODULE Module,
                                USHORT idHelpTable );

void LoadHelpTableFromMemory( PHELPTABLE* ppDestTable,
                              PHELPTABLE pSourceTable );

BOOL FindIDInHelpTable( USHORT idWindow,
                        PHELPTABLE pHelpTable,
                        USHORT* pExtendedHelpPanelID,
                        PHELPSUBTABLE2* ppHelpSubTable );

BOOL FindIDInHelpSubTable( USHORT id,
                           PHELPSUBTABLE2 pHelpSubTable,
                           USHORT* pPanelID );

void FreeHelpTable( PHELPTABLE* ppHelpTable );

#endif
