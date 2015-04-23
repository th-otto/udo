UNIT Os2Def;

{****************************** Module Header ******************************
 *                                                                         *
 * Module Name: OS2DEF.PAS                                                 *
 *                                                                         *
 * OS/2 Common Definitions file                                            *
 *                                                                         *
 *                                                                         *
 ***************************************************************************}


INTERFACE

{Note: An ARRAY [0..x] OF CHAR is equal to a CSTRING[x] !
       CString and PSZ are null terminated strings
       PSZ is changed to PChar (^CString) in records}


TYPE
     ULONG    =LONGWORD;
     LONG     =LONGINT;
     USHORT   =WORD;
     SHORT    =INTEGER;
     UINT     =LONGWORD;
     PUCHAR   =^UCHAR;
     UCHAR    =BYTE;
     SEL      =WORD;

     PSZ      =CSTRING;

     LHANDLE  =LONGWORD;
     HMODULE  =LONGWORD;
     PID      =LONGWORD;
     TID      =LONGWORD;
     SGID     =USHORT;
     PVOID    =POINTER;
     PBYTE    =^BYTE;
     PUSHORT  =^USHORT;
     PSHORT   =^SHORT;
     PULONG   =^ULONG;
     PLONG    =^LONG;
     ERRORID  =ULONG;

TYPE
     MPARAM   =ULONG;
     MRESULT  =ULONG;

     HPS      =LHANDLE;
     HPAL     =LHANDLE;
     HMF      =LHANDLE;
     COLOR    =LONGINT;

     PPOINTL=^POINTL;
     POINTL=RECORD
                  x:LONGINT;
                  y:LONGINT;
            END;

     PPOINTS=^POINTS;
     POINTS=RECORD
                  x:INTEGER;
                  y:INTEGER;
            END;

     PRECTL=^RECTL;
     RECTL=RECORD
               xLeft:LONGINT;
               yBottom:LONGINT;
               xRight:LONGINT;
               yTop:LONGINT;
           END;

     www=Pchar;

     HWND=LHANDLE;
     HMQ=LHANDLE;
     HBITMAP=LHANDLE;
     HAB=LHANDLE;
     WRECT=RECTL;
     WPOINT=POINTL;
     BOOL=LONGBOOL;
     HDC=LHANDLE;
     HRGN=LHANDLE;
     APIRET=LONGWORD;
     HPOINTER=LHANDLE;

     PSWP=^SWP;
     SWP=RECORD
               fl:ULONG;
               cy:LONG;
               cx:LONG;
               y:LONG;
               x:LONG;
               hwndInsertBehind:HWND;
               hwnd:HWND;
               ulReserved1:ULONG;
               ulReserved2:ULONG;
         END;

     PSWPBUF=^TSWPBUF;
     TSWPBUF=ARRAY[0..20] OF SWP;


     PLONGBUF=^TLONGBUF;
     TLONGBUF=ARRAY[0..65530] OF LONGWORD;

     PQMSG=^QMSG;
     QMSG=RECORD
              hwnd:HWND;
              msg:LONGWORD;
              mp1:ULONG;
              mp2:ULONG;
              time:LONGWORD;
              ptl:POINTL;
              reserved:LONGWORD;
          END;

     MOUSEMSG=^TMOUSEMSG;
     TMOUSEMSG=RECORD
                     msg:ULONG;
                     x,y:INTEGER;
                     codeHitTest:WORD;
                     fsInp:WORD;
               END;

     CHARMSG=^TCHARMSG;
     TCHARMSG=RECORD
                    msg:ULONG;
                    fs:WORD;
                    cRepeat:BYTE;
                    ScanCode:BYTE;
                    chr:WORD;
                    vkey:WORD;
              END;

     COMMANDMSG=^TCOMMANDMSG;
     TCOMMANDMSG=RECORD
                       msg:ULONG;
                       cmd:WORD;              /* mp1 */
                       unused:WORD;
                       source:WORD;           /* mp2 */
                       fMouse:WORD;
                 END;


     PFNWP = FUNCTION(ahwnd:HWND;msg:ULONG;mp1,mp2:MPARAM):MRESULT;CDECL;



CONST
     NULLSHANDLE     =0;

     { Severity codes }
CONST
     SEVERITY_NOERROR         =$0000;
     SEVERITY_WARNING         =$0004;
     SEVERITY_ERROR           =$0008;
     SEVERITY_SEVERE          =$000C;
     SEVERITY_UNRECOVERABLE   =$0010;

     { Base component error values }

     WINERR_BASE             =$1000;  { Window Manager                  }
     GPIERR_BASE             =$2000;  { Graphics Presentation Interface }
     DEVERR_BASE             =$3000;  { Device Manager                  }
     SPLERR_BASE             =$4000;  { Spooler                         }


TYPE
     PCH=POINTER;

     { structure for Device Driver data }

TYPE
     PDRIVDATA=^DRIVDATA;
     DRIVDATA=RECORD
                   cb:LONGINT;
                   lVersion:LONGINT;
                   szDeviceName:CSTRING[31];
                   abGeneralData:CHAR;
              END;

     {array indices for array parameter for DevOpenDC,SplQmOpen or SplQpOpen}

CONST
     ADDRESS         =0;
     DRIVER_NAME     =1;
     DRIVER_DATA     =2;
     DATA_TYPE       =3;
     COMMENT         =4;
     PROC_NAME       =5;
     PROC_PARAMS     =6;
     SPL_PARAMS      =7;
     NETWORK_PARAMS  =8;

     { structure definition as an alternative of the array parameter }

TYPE
     DEVOPENSTRUC=RECORD
                       pszLogAddress:PChar;
                       pszDriverName:PChar;
                       pdriv:PDRIVDATA;
                       pszDataType:PChar;
                       pszComment:PChar;
                       pszQueueProcName:PChar;
                       pszQueueProcParams:PChar;
                       pszSpoolerParams:PChar;
                       pszNetworkParams:PChar;
                  END;

     { common PMWP object and PMSTDDLG drag data }

TYPE
     PDEVOPENDATA=^PChar;

     PRINTDEST=RECORD
                     cb:ULONG;
                     lType:LONG;
                     pszToken:PChar;
                     lCount:LONG;
                     pdopData:PDEVOPENDATA;
                     fl:ULONG;
                     pszPrinter:PChar;
               END;

CONST
     PD_JOB_PROPERTY            =$0001; { Flags for .fl field           }

     { common AVIO/GPI types }

CONST
     { values of fsSelection field of FATTRS structure }
     FATTR_SEL_ITALIC            =$0001;
     FATTR_SEL_UNDERSCORE        =$0002;
     FATTR_SEL_OUTLINE           =$0008;
     FATTR_SEL_STRIKEOUT         =$0010;
     FATTR_SEL_BOLD              =$0020;

     { values of fsType field of FATTRS structure }
     FATTR_TYPE_KERNING          =$0004;
     FATTR_TYPE_MBCS             =$0008;
     FATTR_TYPE_DBCS             =$0010;
     FATTR_TYPE_ANTIALIASED      =$0020;

     { values of fsFontUse field of FATTRS structure }
     FATTR_FONTUSE_NOMIX         =$0002;
     FATTR_FONTUSE_OUTLINE       =$0004;
     FATTR_FONTUSE_TRANSFORMABLE =$0008;

     { values of fsType field of FONTMETRICS structure }
CONST
     FM_TYPE_FIXED           =$0001;
     FM_TYPE_LICENSED        =$0002;
     FM_TYPE_KERNING         =$0004;
     FM_TYPE_DBCS            =$0010;
     FM_TYPE_MBCS            =$0018;
     FM_TYPE_64K             =$8000;
     FM_TYPE_ATOMS           =$4000;
     FM_TYPE_FAMTRUNC        =$2000;
     FM_TYPE_FACETRUNC       =$1000;

     { values of fsDefn field of FONTMETRICS structure }
     FM_DEFN_OUTLINE         =$0001;
     FM_DEFN_IFI             =$0002;
     FM_DEFN_WIN             =$0004;
     FM_DEFN_GENERIC         =$8000;

     { values of fsSelection field of FONTMETRICS structure }
     FM_SEL_ITALIC           =$0001;
     FM_SEL_UNDERSCORE       =$0002;
     FM_SEL_NEGATIVE         =$0004;
     FM_SEL_OUTLINE          =$0008;          /* Hollow Outline Font */
     FM_SEL_STRIKEOUT        =$0010;
     FM_SEL_BOLD             =$0020;
     FM_SEL_ISO9241_TESTED   =$0040;

     { values of fbPassed/FailedISO field in the PANOSE structure }
     FM_ISO_9518_640         =$01;
     FM_ISO_9515_640         =$02;
     FM_ISO_9515_1024        =$04;
     FM_ISO_9517_640         =$08;
     FM_ISO_9517_1024        =$10;

     { values of fsCapabilities field of FONTMETRICS structure }
     FM_CAP_NOMIX            =$0001;


TYPE
    ICONINFO=RECORD
                   cb:ULONG;         { size of ICONINFO structure       }
                   fFormat:ULONG;
                   pszFileName:PChar;{ use when fFormat = ICON_FILE     }
                   hmod:HMODULE;     { use when fFormat = ICON_RESOURCE }
                   resid:ULONG;      { use when fFormat = ICON_RESOURCE }
                   cbIconData:ULONG; { use when fFormat = ICON_DATA     }
                   pIconData:PVOID;  { use when fFormat = ICON_DATA     }
             END;

CONST
     ICON_FILE     =1;         /* flags for fFormat */
     ICON_RESOURCE =2;
     ICON_DATA     =3;
     ICON_CLEAR    =4;


FUNCTION MAKEP(sel,off:LONGWORD):POINTER;
FUNCTION MAKEULONG(l,h:WORD):ULONG;
FUNCTION MAKELONG(l,h:WORD):LONG;
FUNCTION MAKEUSHORT(l,h:BYTE):WORD;
FUNCTION MAKESHORT(l,h:BYTE):INTEGER;
FUNCTION LOBYTE(w:WORD):BYTE;
FUNCTION HIBYTE(w:WORD):BYTE;
FUNCTION LOUCHAR(w:WORD):BYTE;
FUNCTION HIUCHAR(w:WORD):BYTE;
FUNCTION LOUSHORT(w:LONGWORD):WORD;
FUNCTION HIUSHORT(w:LONGWORD):WORD;
FUNCTION MAKEERRORID(sev,error:WORD):ERRORID;
FUNCTION ERRORIDERROR(errid:ERRORID):WORD;
FUNCTION ERRORIDSEV(errid:ERRORID):WORD;


IMPLEMENTATION

FUNCTION MAKEP(sel,off:LONGWORD):POINTER;
BEGIN
     MAKEP:=POINTER((sel SHR 16) OR off);
END;

FUNCTION MAKEULONG(l,h:WORD):ULONG;
BEGIN
     MAKEULONG:=l OR (LONGWORD(h) SHL 16);
END;

FUNCTION MAKELONG(l,h:WORD):LONG;
BEGIN
     MAKELONG:=l OR (LONGWORD(h) SHL 16);
END;


FUNCTION MAKEUSHORT(l,h:BYTE):WORD;
BEGIN
     MAKEUSHORT:=l OR (WORD(h) SHL 8);
END;

FUNCTION MAKESHORT(l,h:BYTE):INTEGER;
BEGIN
     MAKESHORT:=l OR (WORD(h) SHL 8);
END;

FUNCTION LOBYTE(w:WORD):BYTE;
BEGIN
     LOBYTE:=Lo(w);
END;

FUNCTION HIBYTE(w:WORD):BYTE;
BEGIN
     HIBYTE:=Hi(w);
END;


FUNCTION LOUCHAR(w:WORD):BYTE;
BEGIN
     LOUCHAR:=Lo(w);
END;

FUNCTION HIUCHAR(w:WORD):BYTE;
BEGIN
     HIUCHAR:=Hi(w);
END;

FUNCTION LOUSHORT(w:LONGWORD):WORD;
BEGIN
     LOUSHORT:=Lo(w);
END;

FUNCTION HIUSHORT(w:LONGWORD):WORD;
BEGIN
     HIUSHORT:=Hi(w);
END;


FUNCTION MAKEERRORID(sev,error:WORD):ERRORID;
BEGIN
     MAKEERRORID:=MAKEULONG(Error,Sev);
END;


FUNCTION ERRORIDERROR(errid:ERRORID):WORD;
BEGIN
     ERRORIDERROR:=LOUSHORT(errid);
END;

FUNCTION ERRORIDSEV(errid:ERRORID):WORD;
BEGIN
     ERRORIDSEV:=HIUSHORT(errid);
END;


BEGIN
END.
