/** REXX **/

say "========================================================================="
say "= NewView tests                                                         ="
say "========================================================================="
say
say "testing the command line"
say
pull



say "*************************************************************************"
say "* newview                                                               *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the NewView help.                             *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview\newview"
pull


say "*************************************************************************"
say "* newview cmdref                                                        *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview\newview cmdref"
pull


say "*************************************************************************"
say "* newview cmdref copy                                                   *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - only 'OS/2 Commands by name' is expanded                            *"
say "*   and 'COPY' is selected                                              *"
say "*************************************************************************"
"start ..\build\newview\newview cmdref copy"
pull


say "*************************************************************************"
say "* newview /s cmdref copy                                                *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected (copy is visible in the search entry field)  *"
say "* - 'COPY' is selected and visible at the right                         *"
say "* - on contents tab only 'OS/2 Commands by name' is expanded            *"
say "*   and 'COPY' is selected                                              *"
say "*************************************************************************"
"start ..\build\newview\newview /s cmdref copy"
pull


say "*************************************************************************"
say "* newview /s cmdref                                                     *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - no hits visible and the right part is empty                         *"
say "* - all contents are collapsed                                          *"
say "*************************************************************************"
"start ..\build\newview\newview /s cmdref"
pull


say "*************************************************************************"
say "* newview /s cmdref net access                                          *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected                                              *"
say "*     ('net access' is visible in the search entry field)               *"
say "* - search was done for net OR access                                   *"
say "* - 'NET ACCESS' is selected and visible at the right                   *"
say "* - on contents tab only 'LAN Server Commands' is expanded              *"
say "*   and 'NET ACCESS' is selected                                        *"
say "*************************************************************************"
"start ..\build\newview\newview /s cmdref net access"
pull


say "*************************************************************************"
say "* newview /s cmdref net access                                          *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected                                              *"
say "*     ('""net access""' is visible in the search entry field)           *"
say "* - search was done for net AND access                                  *"
say "* - 'NET ACCESS' is selected and visible at the right                   *"
say "* - on contents tab only 'LAN Server Commands' is expanded              *"
say "*   and 'NET ACCESS' is selected                                        *"
say "*************************************************************************"
'start ..\build\newview\newview /s cmdref "net access"'
pull


say "*************************************************************************"
say "* newview /g cmdref copy                                                *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "* - The 'Search all fieles' dialog is opend and searches for copy       *"
say "*************************************************************************"
"start ..\build\newview\newview /g cmdref copy"
pull


say "*************************************************************************"
say "* newview /g copy                                                       *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows nothing                                       *"
say "* - left navigation is NOT shown                                        *"
say "* - The 'Search all fieles' dialog is opend and searches for copy       *"
say "*************************************************************************"
"start ..\build\newview\newview /g copy"
pull


say "*************************************************************************"
say "* newview -i                                                            *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help.                 *"
say "* - left navigation is shown                                            *"
say "* - index tab is selected                                               *"
say "* - all contents are collapsed                                          *"
say "* - noting is selected                                                  *"
say "* - 'Introduction' is visible at the right                              *"
say "*************************************************************************"
"start ..\build\newview\newview -i cmdref"
pull


say "*************************************************************************"
say "* newview -i GLOSSARY                                                   *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Glossary' help.                          *"
say "* - left navigation is shown                                            *"
say "* - index tab is selected                                               *"
say "* - all contents are collapsed                                          *"
say "* - noting is selected                                                  *"
say "* - '3270 Telnet' is visible at the right                               *"
say "*************************************************************************"
"start ..\build\newview\newview -i GLOSSARY"
pull


say "*************************************************************************"
say "* newview -h                                                            *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the NewView help.                             *"
say "* - command line dialog is shown                                        *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview\newview -h"
pull



