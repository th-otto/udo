UNIT PmWP;

INTERFACE

USES Os2Def,PmWin;


IMPORTS

FUNCTION WinCreateObject(ClassName,Title,SetupString,Location:CSTRING;
                         ulFlags:ULONG):ULONG;
                    APIENTRY;             'PMWP' index 281;
FUNCTION WinDeRegisterObjectClass(ClassName:CSTRING):BOOL;
                    APIENTRY;             'PMWP' index 201;
FUNCTION WinDestroyObject(aobject:HOBJECT):BOOL;
                    APIENTRY;             'PMWP' index 251;
FUNCTION WinEnumObjectClasses(VAR apObjClass:OBJCLASS;VAR pulSize:ULONG):BOOL;
                    APIENTRY;             'PMWP' index 205;
FUNCTION WinFreeFileIcon(hptr:HPOINTER):BOOL;
                    APIENTRY;             'PMWP' index 216;
FUNCTION WinLoadFileIcon(pszFileName:CSTRING;fPrivate:BOOL):HPOINTER;
                    APIENTRY;             'PMWP' index 209;
FUNCTION WinQueryObject(pszObjectID:CSTRING):MRESULT;
                    APIENTRY;             'PMWP' index 252;
FUNCTION WinRegisterObjectClass(pszClassName,pszModName:CSTRING):BOOL;
                    APIENTRY;             'PMWP' index 200;
FUNCTION WinReplaceObjectClass(pszOldClassName,pszNewClassName:CSTRING;
                               fReplace:BOOL):BOOL;
                    APIENTRY;             'PMWP' index 219;
FUNCTION WinRestoreWindowPos(pszAppName,pszKeyName:CSTRING;ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWP' index 208;
FUNCTION WinSetFileIcon(pszFileName:CSTRING;VAR pIcon:ICONINFO):BOOL;
                    APIENTRY;             'PMWP' index 210;
FUNCTION WinSetObjectData(aobject:HOBJECT;pszSetupString:CSTRING):BOOL;
                    APIENTRY;             'PMWP' index 250;
FUNCTION WinShutdownSystem(ahab:HAB;ahmq:HMQ):BOOL;
                    APIENTRY;             'PMWP' index 149;
FUNCTION WinStoreWindowPos(pszAppName,pszKeyName:CSTRING;ahwnd:HWND):BOOL;
                    APIENTRY;             'PMWP' index 207;

END;

CONST
  CO_FAILIFEXISTS = 0;
  CO_REPLACEIFEXISTS = 1;
  CO_UPDATEIFEXISTS = 2;

IMPLEMENTATION

BEGIN
END.
