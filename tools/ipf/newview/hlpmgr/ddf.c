#include "Utility.h"
#include "Log.h"

#ifndef HDDF
      typedef VOID *HDDF;
#endif

//--------------------------------------------------------------------------------
// Place holder DDF (dynamic data formatting) functions
// This seems very obscure so is not implemented
//--------------------------------------------------------------------------------
HDDF APIENTRY  NHMDdfInitialize( HWND hwndHelpInstance,
                                 ULONG cbBuffer,
                                 ULONG ulIncrement )
{
  LogEvent( "DdfInitialize" );
  return NULLHANDLE;
}
      
BOOL APIENTRY  NHMDdfPara( HDDF hddf )
{
  LogEvent( "DdfPara" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfSetFormat( HDDF hddf,
                                ULONG fFormatType )
{
  LogEvent( "DdfSetFormat" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfSetTextAlign( HDDF hddf,
                                   ULONG fAlign )
{
  LogEvent( "DdfSetTextAlign" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfSetColor( HDDF hddf,
                               COLOR fBackColor,
                               COLOR fForColor )
{
  LogEvent( "DdfSetColor" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfInform( HDDF hddf,
                             PSZ pszText,
                             ULONG resInformNumber )
{
  LogEvent( "DdfInform" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfSetFontStyle( HDDF hddf,
                                   ULONG fFontStyle )
{
  LogEvent( "DdfSetFontStyle" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfHyperText( HDDF hddf,
                                PSZ pszText,
                                PSZ pszReference,
                                ULONG fReferenceType )
{
  LogEvent( "DdfHyperText" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfBeginList( HDDF hddf,
                                ULONG ulWidthDT,
                                ULONG fBreakType,
                                ULONG fSpacing )
{
  LogEvent( "DdfBeginList" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfListItem( HDDF hddf,
                               PSZ pszTerm,
                               PSZ pszDescription )
{
  LogEvent( "DdfListItem" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfEndList( HDDF hddf )
{
  LogEvent( "DdfEndList" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfMetafile( HDDF hddf,
                               HMF hmf,
                               PRECTL prclRect )
{
  LogEvent( "DdfMetafile" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfText( HDDF hddf,
                           PSZ pszText )
{
  LogEvent( "DdfText" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfSetFont( HDDF hddf,
                              PSZ pszFaceName,
                              ULONG ulWidth,
                              ULONG ulHeight )
{
  LogEvent( "DdfSetFont" );
  return FALSE;
}
      
BOOL APIENTRY  NHMDdfBitmap( HDDF hddf,
                             HBITMAP hbm,
                             ULONG fAlign )
{
  LogEvent( "DdfBitmap" );
  return FALSE;
}
