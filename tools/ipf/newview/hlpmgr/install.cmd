rem unlock HelpMgr (may fail if already unlocked)
replmod c:\os2\dll\helpmgr.dll

rem back up helpmgr if needed
if exist c:\os2\dll\helpmgr.bak goto HelpMgrAlreadyBackedUp
copy c:\os2\dll\helpmgr.dll c:\os2\dll\helpmgr.bak
:HelpMgrAlreadyBackedUp

rem copy new helpmgr
copy w:\newview\helpmgr\helpmgr.dll c:\os2\dll\helpmgr.dll

:done
