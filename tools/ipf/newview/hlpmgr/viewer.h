#ifndef VIEWER_H
#define VIEWER_H

// Start viewer for specified help file and window
BOOL ViewHelpFile( char* pszHelpFileName,
                   char* pszWindowTitle,
                   HWND hHelpWindow,
                   HWND hAppWindow,
                   HAB hab );

// Start viewer for "using help" 
void ViewHelpOnHelp( HAB hab );

// APPENDS the given filenames to the output string,
// replace spaces between filenames with a +
// and stripping redundant spaces.
void ModifyFilenames( char* Filenames,
                      char* Output );

#endif
