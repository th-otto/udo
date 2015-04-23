#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define INCL_PM
#include <os2.h>

#include "Viewer.h"
#include "log.h"

char* pszViewerFilename = "view.exe";
char* OWN_HELP_MARKER = "[NVHELP]";

BOOL StartViewer(   char* pszParameters,
                    HWND hTerminateNotify,
                    HWND hAppWindow,
                    HAB hab )
{
  PROGDETAILS Details;
  char pszMessageCaption[ 1024 ];
  HAPP hApplication;
  BOOL result;

  Details.Length                      = sizeof(PROGDETAILS);
  Details.progt.progc                 = PROG_PM;
  Details.progt.fbVisible             = SHE_VISIBLE;
  Details.pszTitle                    = "Help Viewer";
  Details.pszExecutable               = pszViewerFilename;
  Details.pszParameters               = pszParameters;
  Details.pszStartupDir               = "";
  Details.pszIcon                     = NULL; // default app icon
  Details.pszEnvironment              = NULL;
  Details.swpInitial.fl               = SWP_ACTIVATE;
  Details.swpInitial.cy               = 0;
  Details.swpInitial.cx               = 0;
  Details.swpInitial.y                = 0;
  Details.swpInitial.x                = 0;
  Details.swpInitial.hwndInsertBehind = HWND_TOP;
  Details.swpInitial.hwnd             = hAppWindow;
  Details.swpInitial.ulReserved1      = 0;
  Details.swpInitial.ulReserved2      = 0;


  LogEvent( "Launching: %s %s", Details.pszExecutable, pszParameters );

  hApplication =
    WinStartApp( hTerminateNotify,    // window to be notified of termination
                 & Details,           // details
                 NULL,                // parameters - used Details
                 NULL,                // reserved
                 SAF_INSTALLEDCMDLINE ); // options

  if ( hApplication == NULL )
  {
    LogEvent( "  Failed to launch viewer, rc=%8X", WinGetLastError( hab ) );
    sprintf( pszMessageCaption, "Unable to start help viewer %s", pszViewerFilename );
    WinMessageBox( HWND_DESKTOP, // parent
                   hAppWindow,   // owner
                   pszMessageCaption,
                   "Help Error", // title
                   0,            // ID
                   MB_OK | MB_WARNING | MB_MOVEABLE );
    result = FALSE;
  }
  else
  {
    result = TRUE;
  }

  free( pszParameters );
  return result;
}


// appends the given filenames to the output string,
// replace spaces between filenames with a +
// and stripping redundant spaces.
void ModifyFilenames( char* Filenames, char* Output )
{
  BOOL First;
  BOOL InQuote;
  char QuoteChar;

  First = TRUE;
  InQuote = FALSE;
  while ( *Filenames != 0 )
  {
    // skip spaces
    while (    *Filenames != 0
            && *Filenames == ' ' )
      Filenames ++;

    // add a plus sign (+), after first word
    if (    ! First
         && *Filenames != 0 )
    {
      * Output = '+';
      Output ++;
    }

    First = FALSE;
    // copy non-space characters
    // or all characters if in quotes
    while (    *Filenames != 0
            && ( *Filenames != ' ' || InQuote ) )
    {
      * Output = *Filenames;
      if ( ! InQuote )
      {
        if (    *Filenames == '\''
             || *Filenames == '\"' )
        {
          InQuote = TRUE;
          QuoteChar = *Filenames;
          * Output = '\"'; // change singles to doubles
        }
      }
      else
      {
        if ( *Filenames == QuoteChar )
        {
          InQuote = FALSE;
          * Output = '\"'; // change singles to doubles
        }
      }

      Output ++;
      Filenames ++;
    }
  }

  // null terminate
  *Output = 0;
}


BOOL ViewHelpFile( char* pszHelpFileName,
                   char* pszWindowTitle,
                   HWND hHelpWindow,
                   HWND hAppWindow,
                   HAB hab )
{
  char* pszParameters;

  // set up viewer parameters:
  // <helpfilename> /hm:<helpwindow>
  // currently not used: /owner:<ownerwindow>

  pszParameters = (char*) malloc(   strlen( pszHelpFileName )
                                  + strlen( pszWindowTitle )
                                  + 512 );

  sprintf( pszParameters, "/hm:%u ", hHelpWindow );

  if ( pszHelpFileName != NULL )
  {
    // add (modified) filenames to parameters
    ModifyFilenames( pszHelpFileName,
                     pszParameters + strlen( pszParameters ) );
  }

  if ( pszWindowTitle != NULL )
  {
    // add window title parameter
    strcat( pszParameters, " \"/title:" );
    strcat( pszParameters, pszWindowTitle );
    strcat( pszParameters, "\"" );
  }

  return StartViewer(   pszParameters,
                        hHelpWindow,
                        hAppWindow,
                        hab );
}


void ViewHelpOnHelp( HAB hab )
{
  StartViewer(  OWN_HELP_MARKER,
                NULL,
                NULL,
                hab );
}

