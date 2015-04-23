/** REXX **/

say "========================================================================="
say "= NewView Stub tests                                                    ="
say "========================================================================="
say
say "testing the command line"
say
say "first starting a new newview instance"
say
pull



say "*************************************************************************"
say "* viewstub                                                              *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the NewView help.                             *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub"
pull


say "*************************************************************************"
say "* viewstub cmdref                                                       *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
pull


say "*************************************************************************"
say "* viewstub cmdref copy                                                  *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - only 'OS/2 Commands by name' is expanded                            *"
say "*   and 'COPY' is selected                                              *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref copy"
pull


say "*************************************************************************"
say "* viewstub /s cmdref copy                                               *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected (copy is visible in the search entry field)  *"
say "* - 'COPY' is selected and visible at the right                         *"
say "* - on contents tab only 'OS/2 Commands by name' is expanded            *"
say "*   and 'COPY' is selected                                              *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub /s cmdref copy"
pull


say "*************************************************************************"
say "* viewstub /s cmdref                                                    *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected                                              *"
say "*     (the search entry field is empty)                                 *"
say "* - no hits visible and the right part is empty                         *"
say "* - all contents are collapsed                                          *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub /s cmdref"
pull


say "*************************************************************************"
say "* viewstub /s cmdref net access                                         *"
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
"start ..\build\newview_stub\viewstub /s cmdref net access"
pull


say "*************************************************************************"
say "* viewstub /s cmdref net access                                         *"
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
'start ..\build\newview_stub\viewstub /s cmdref "net access"'
pull


say "*************************************************************************"
say "* viewstub /g cmdref copy                                               *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "* - The 'Search all fieles' dialog is opend and searches for copy       *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub /g cmdref copy"
pull


say "*************************************************************************"
say "* viewstub /g copy                                                      *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows nothing                                       *"
say "* - left navigation is NOT shown                                        *"
say "* - The 'Search all fieles' dialog is opend and searches for copy       *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub /g copy"
pull


say "*************************************************************************"
say "* viewstub -h                                                           *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the NewView help.                             *"
say "* - command line dialog is shown                                        *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub -h"
pull


say
say "second using a already running newview instance"
say
pull



say "*************************************************************************"
say "* viewstub                                                              *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the NewView help.                             *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub"
call SysSleep 1
"start ..\build\newview_stub\viewstub"
pull


say "*************************************************************************"
say "* viewstub cmdref                                                       *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
"start ..\build\newview_stub\viewstub cmdref"
pull


say "*************************************************************************"
say "* viewstub cmdref                                                       *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView starts and shows the NewView help.                            *"
say "* a second NewView starts and shows the 'Command Reference' help        *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub"
call SysSleep 1
"start ..\build\newview_stub\viewstub cmdref"
pull


say "*************************************************************************"
say "* viewstub cmdref copy                                                  *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected (copy is visible in the search entry field)  *"
say "* - 'COPY' is selected and visible at the right                         *"
say "* - on contents tab only 'OS/2 Commands by name' is expanded            *"
say "*   and 'COPY' is selected                                              *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
"start ..\build\newview_stub\viewstub cmdref copy"
pull


say "*************************************************************************"
say "* viewstub /s cmdref copy                                               *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected (copy is visible in the search entry field)  *"
say "* - 'COPY' is selected and visible at the right                         *"
say "* - on contents tab only 'OS/2 Commands by name' is expanded            *"
say "*   and 'COPY' is selected                                              *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
"start ..\build\newview_stub\viewstub /s cmdref copy"
pull


say "*************************************************************************"
say "* viewstub /s cmdref                                                    *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
"start ..\build\newview_stub\viewstub /s cmdref"
pull


say "*************************************************************************"
say "* viewstub /s cmdref net access                                         *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected                                              *"
say "*     ('net access' is visible in the search entry field)               *"
say "* - search was done for net OR access                                   *"
say "* - 'NET ACCESS' is selected and visible at the right                   *"
say "* - on contents tab only 'LAN Server Commands' is expanded              *"
say "*   and 'NET ACCESS' is selected                                        *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
"start ..\build\newview_stub\viewstub /s cmdref net access"
pull


say "*************************************************************************"
say "* viewstub /s cmdref net access                                         *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - search tab is selected                                              *"
say "*     ('""net access""' is visible in the search entry field)           *"
say "* - search was done for net AND access                                  *"
say "* - 'NET ACCESS' is selected and visible at the right                   *"
say "* - on contents tab only 'LAN Server Commands' is expanded              *"
say "*   and 'NET ACCESS' is selected                                        *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
'start ..\build\newview_stub\viewstub /s cmdref "net access"'
pull


say "*************************************************************************"
say "* viewstub /g cmdref copy                                               *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows the 'Command Reference' help                  *"
say "* There is no second instance of NewView.                               *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "* - The 'Search all fieles' dialog is opend and searches for copy       *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub cmdref"
call SysSleep 1
"start ..\build\newview_stub\viewstub /g cmdref copy"
pull


say "*************************************************************************"
say "* viewstub /g copy                                                      *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView start and shows own help                                      *"
say "* a second NewView start and shows nothing                              *"
say "* - left navigation is NOT shown                                        *"
say "* - The 'Search all fieles' dialog is opend and searches for copy       *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub"
call SysSleep 1
"start ..\build\newview_stub\viewstub /g copy"
pull


say "*************************************************************************"
say "* viewstub -h                                                           *"
say "*                                                                       *"
say "* Expected                                                              *"
say "* NewView starts and shows the NewView help.                            *"
say "* There is no second instance of NewView.                               *"
say "* - command line dialog is shown                                        *"
say "* - left navigation is shown                                            *"
say "* - contents tab is selected                                            *"
say "* - all contents are collapsed                                          *"
say "* - 'Introduction' is selected and visible at the right                 *"
say "*************************************************************************"
"start ..\build\newview_stub\viewstub"
call SysSleep 1
"start ..\build\newview_stub\viewstub -h"
pull

