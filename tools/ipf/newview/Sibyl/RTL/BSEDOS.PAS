UNIT BseDos;

{****************************** Module Header *****************************
*                                                                         *
* Module Name: BSEDOS.PAS                                                 *
*                                                                         *
* OS/2 Base include file.                                                 *
*                                                                         *
***************************************************************************}

INTERFACE

USES Os2Def,BseTib,BseExcpt;

{ Access protection }
CONST
     PAG_READ          =$00000001;      { read access                      }
     PAG_WRITE         =$00000002;      { write access                     }
     PAG_EXECUTE       =$00000004;      { execute access                   }
     PAG_GUARD         =$00000008;      { guard protection                 }
     PAG_DEFAULT       =$00000400;      { default (initial) access         }

{ Commit}
     PAG_COMMIT        =$00000010;      { commit storage                   }
     PAG_DECOMMIT      =$00000020;      { decommit storage                 }

{ Allocation attributes }
     OBJ_TILE          =$00000040;      { tile object                      }
     OBJ_PROTECTED     =$00000080;      { protect object
                                          NOTE: This flag is NOT available at
                                          the api level }
     OBJ_GETTABLE      =$00000100;      { gettable by other processes      }
     OBJ_GIVEABLE      =$00000200;      { giveable to other processes      }


     fPERM             =PAG_EXECUTE OR PAG_READ OR PAG_WRITE;
     fSHARE            =OBJ_GETTABLE OR OBJ_GIVEABLE;

{ DosAllocMem flags }
     fALLOC            =OBJ_TILE OR PAG_COMMIT OR fPERM;


{ DosAllocSharedMem flags }
     fALLOCSHR         =OBJ_TILE OR PAG_COMMIT OR fSHARE OR fPERM;

{ DosGetNamedSharedMem flags }
     fGETNMSHR         =fPERM;

{ DosGetSharedMem flags }
     fGETSHR           =fPERM;

{ DosGiveSharedMem flags }
     fGIVESHR          =fPERM;

{ DosSetMem flags }
     fSET              =PAG_COMMIT + PAG_DECOMMIT + PAG_DEFAULT + fPERM;

{ Dos32SubSet flags }
     DOSSUB_INIT       =$01;      { initialize memory object for
                                    suballocation                    }
     DOSSUB_GROW       =$02;      { increase size of memory pool
                                    for suballocation                }
     DOSSUB_SPARSE_OBJ =$04;      { indicator for DosSub to
                                    manage the commitment of
                                    pages spanned by the memory pool }
     DOSSUB_SERIALIZE  =$08;      { indicates that access to the
                                    memory pool is to be
                                    serialized by DosSub             }


{ Allocation type (returned from DosQueryMem) }
     PAG_SHARED        =$00002000; { shared object                    }
     PAG_FREE          =$00004000; { pages are free                   }
     PAG_BASE          =$00010000; { first page in object             }


{ DosExit codes }
CONST
      EXIT_THREAD        =0;
      EXIT_PROCESS       =1;

TYPE
    PFNTHREAD=POINTER;

{ Action code values }
CONST
      DCWA_PROCESS       =0;
      DCWA_PROCESSTREE   =1;

   { Wait option values }

      DCWW_WAIT          =0;
      DCWW_NOWAIT        =1;

{ Thread Flags for DosCreateThread options 59468 }

   CREATE_READY          =0;                   { defect 65437  }
   CREATE_SUSPENDED      =1;
   STACK_SPARSE          =0;
   STACK_COMMITTED       =2;

TYPE
    PRESULTCODES=^RESULTCODES;
    RESULTCODES=RECORD
                     codeTerminate:ULONG;
                     codeResult:ULONG;
                END;


{ User's Debug Buffer structure }

TYPE
    PDbgBuf=^TDbgBuf;
    TDbgBuf=RECORD
                 Pid:PID;                 { Debuggee Process id          }
                 Tid:TID;                 { Debuggee Thread id           }
                 Cmd:LONGINT;             { Command or Notification      }
                 Value:LONGINT;           { Generic Data Value           }
                 Addr:LONGWORD;           { Debuggee Address             }
                 Buffer:LONGWORD;         { Debugger Buffer Address      }
                 Len:LONGWORD;            { Length of Range              }
                 index:LONGWORD;          { Generic Identifier Index     }
                 MTE:LONGWORD;            { Module Table Entry Handle    }
                 EAX:LONGWORD;            { Register Set                 }
                 ECX:LONGWORD;
                 EDX:LONGWORD;
                 EBX:LONGWORD;
                 ESP:LONGWORD;
                 EBP:LONGWORD;
                 ESI:LONGWORD;
                 EDI:LONGWORD;
                 EFlags:LONGWORD;
                 EIP:LONGWORD;
                 CSLim:LONGWORD;
                 CSBase:LONGWORD;
                 CSAcc:BYTE;
                 CSAtr:BYTE;
                 CS:WORD;
                 DSLim:LONGWORD;
                 DSBase:LONGWORD;
                 DSAcc:BYTE;
                 DSAtr:BYTE;
                 DS:WORD;
                 ESLim:LONGWORD;
                 ESBase:LONGWORD;
                 ESAcc:BYTE;
                 ESAtr:BYTE;
                 ES:WORD;
                 FSLim:LONGWORD;
                 FSBase:LONGWORD;
                 FSAcc:BYTE;
                 FSAtr:BYTE;
                 FS:WORD;
                 GSLim:LONGWORD;
                 GSBase:LONGWORD;
                 GSAcc:BYTE;
                 GSAtr:BYTE;
                 GS:WORD;
                 SSLim:LONGWORD;
                 SSBase:LONGWORD;
                 SSAcc:BYTE;
                 SSAtr:BYTE;
                 SS:WORD;
         END;

{ DosDebug Command Numbers
 *
 *      These numbers are placed in the Cmd field of the uDB on
 *      entry to DosDebug.
 *
 *      These numbers identify which command DosDebug is requested
 *      to perform.
 *
 }

CONST
   DBG_C_Null              =0;       { Null                         }
   DBG_C_ReadMem           =1;       { Read Word                    }
   DBG_C_ReadMem_I         =1;       { Read Word                    }
   DBG_C_ReadMem_D         =2;       { Read Word (same as 1)        }
   DBG_C_ReadReg           =3;       { Read Register Set            }
   DBG_C_WriteMem          =4;       { Write Word                   }
   DBG_C_WriteMem_I        =4;       { Write Word                   }
   DBG_C_WriteMem_D        =5;       { Write Word (same as 4)       }
   DBG_C_WriteReg          =6;       { Write Register Set           }
   DBG_C_Go                =7;       { Go                           }
   DBG_C_Term              =8;       { Terminate                    }
   DBG_C_SStep             =9;       { Single Step                  }
   DBG_C_Stop              =10;      { Stop                         }
   DBG_C_Freeze            =11;      { Freeze Thread                }
   DBG_C_Resume            =12;      { Resume Thread                }
   DBG_C_NumToAddr         =13;      { Object Number to Address     }
   DBG_C_ReadCoRegs        =14;      { Read Coprocessor Registers   }
   DBG_C_WriteCoRegs       =15;      { Write Coprocessor Registers  }
                                        { 16 is reserved               }
   DBG_C_ThrdStat          =17;      { Get Thread Status            }
   DBG_C_MapROAlias        =18;      { Map read-only alias          }
   DBG_C_MapRWAlias        =19;      { Map read-write alias         }
   DBG_C_UnMapAlias        =20;      { Unmap Alias                  }
   DBG_C_Connect           =21;      { Connect to Debuggee          }
   DBG_C_ReadMemBuf        =22;      { Read Memory Buffer           }
   DBG_C_WriteMemBuf       =23;      { Write Memory Buffer          }
   DBG_C_SetWatch          =24;      { Set Watchpoint               }
   DBG_C_ClearWatch        =25;      { Clear Watchpoint             }
   DBG_C_RangeStep         =26;      { Range Step                   }
   DBG_C_Continue          =27;      { Continue after an Exception  }
   DBG_C_AddrToObject      =28;      { Address to Object            }
   DBG_C_XchgOpcode        =29;      { Exchange opcode and go       }
   DBG_C_LinToSel          =30;      { 32 to 16 conversion      A001}
   DBG_C_SelToLin          =31;      { 16 to 32 conversion      A001}

   {------ Constants -------------------}
   DBG_L_386               =1;
   DBG_O_OBJMTE            =$10000000;

   {------ Notifications ---------------}
   DBG_N_SUCCESS             = 0;
   DBG_N_ERROR               =-1;
   DBG_N_ProcTerm            =-6;
   DBG_N_Exception           =-7;
   DBG_N_ModuleLoad          =-8;
   DBG_N_CoError             =-9;
   DBG_N_ThreadTerm          =-10;
   DBG_N_AsyncStop           =-11;
   DBG_N_NewProc             =-12;
   DBG_N_AliasFree           =-13;
   DBG_N_Watchpoint          =-14;
   DBG_N_ThreadCreate        =-15;
   DBG_N_ModuleFree          =-16;
   DBG_N_RangeStep           =-17;

   DBG_X_PRE_FIRST_CHANCE    = 0;
   DBG_X_FIRST_CHANCE        = 1;
   DBG_X_LAST_CHANCE         = 2;
   DBG_X_STACK_INVALID       = 3;

   DBG_W_Local               =$0000001;
   DBG_W_Global              =$0000002;
   DBG_W_Execute             =$00010000;
   DBG_W_Write               =$00020000;
   DBG_W_ReadWrite           =$00030000;

{ codeTerminate values (also passed to ExitList routines) }

CONST
      TC_EXIT            =0;
      TC_HARDERROR       =1;
      TC_TRAP            =2;
      TC_KILLPROCESS     =3;
      TC_EXCEPTION       =4;

TYPE
    PFNEXITLIST=POINTER;


{ DosExitList functions }

CONST
    EXLST_ADD          =1;
    EXLST_REMOVE       =2;
    EXLST_EXIT         =3;


{ DosExecPgm functions }
CONST
      EXEC_SYNC          =0;
      EXEC_ASYNC         =1;
      EXEC_ASYNCRESULT   =2;
      EXEC_TRACE         =3;
      EXEC_BACKGROUND    =4;
      EXEC_LOAD          =5;
      EXEC_ASYNCRESULTDB =6;



{ Priority scopes }
CONST
      PRTYS_PROCESS      =0;
      PRTYS_PROCESSTREE  =1;
      PRTYS_THREAD       =2;

{ Priority classes }
CONST
      PRTYC_NOCHANGE         =0;
      PRTYC_IDLETIME         =1;
      PRTYC_REGULAR          =2;
      PRTYC_TIMECRITICAL     =3;
      PRTYC_FOREGROUNDSERVER =4;

   { Priority deltas }

      PRTYD_MINIMUM     =-31;
      PRTYD_MAXIMUM     = 31;



CONST
      DKP_PROCESSTREE    =0;
      DKP_PROCESS        =1;

   {************************************************************************
   * CCHMAXPATH is the maximum fully qualified path name length including  *
   * the drive letter, colon, backslashes and terminating NULL.            *
   *************************************************************************}
      CCHMAXPATH         =260;

   {************************************************************************
   * CCHMAXPATHCOMP is the maximum individual path component name length   *
   * including a terminating NULL.                                         *
   *************************************************************************}
      CCHMAXPATHCOMP     =256;

{ DosSetFilePtr() file position codes }
CONST
      FILE_BEGIN      =$0000;   { Move relative to beginning of file }
      FILE_CURRENT    =$0001;   { Move relative to current fptr position }
      FILE_END        =$0002;   { Move relative to end of file }

   { DosFindFirst/Next Directory handle types }
      HDIR_SYSTEM      =  1;    { Use system handle (1) }
      HDIR_CREATE      = -1;    { Allocate a new, unused handle }

   { DosCopy control bits; may be or'ed together }
      DCPY_EXISTING   =$0001;   { Copy even if target exists }
      DCPY_APPEND     =$0002;   { Append to existing file, do not replace }
      DCPY_FAILEAS    =$0004;   { Fail if EAs not supported on target}

   { DosOpen/DosQFHandState/DosQueryFileInfo et al file attributes; also }
   { known as Dos File Mode bits... }
      FILE_NORMAL     =$0000;
      FILE_READONLY   =$0001;
      FILE_HIDDEN     =$0002;
      FILE_SYSTEM     =$0004;
      FILE_DIRECTORY  =$0010;
      FILE_ARCHIVED   =$0020;

      FILE_IGNORE     =$10000;     { ignore file attribute in }
   { DosSetPath/File Info if }
   { this bit is set}

      MUST_HAVE_READONLY     =(FILE_READONLY  SHL 8) OR FILE_READONLY;
      MUST_HAVE_HIDDEN       =(FILE_HIDDEN SHL 8) OR FILE_HIDDEN;
      MUST_HAVE_SYSTEM       =(FILE_SYSTEM SHL 8) OR FILE_SYSTEM;
      MUST_HAVE_DIRECTORY    =(FILE_DIRECTORY SHL 8) OR FILE_DIRECTORY;
      MUST_HAVE_ARCHIVED     =(FILE_ARCHIVED SHL 8) OR FILE_ARCHIVED;

   { DosOpen() actions }
      FILE_EXISTED    =$0001;
      FILE_CREATED    =$0002;
      FILE_TRUNCATED  =$0003;

   { DosOpen() open flags }
      FILE_OPEN       =$0001;
      FILE_TRUNCATE   =$0002;
      FILE_CREATE     =$0010;

   {     this nibble applies if file already exists                xxxx }
      OPEN_ACTION_FAIL_IF_EXISTS     =$0000;  { ---- ---- ---- 0000 }
      OPEN_ACTION_OPEN_IF_EXISTS     =$0001;  { ---- ---- ---- 0001 }
      OPEN_ACTION_REPLACE_IF_EXISTS  =$0002;  { ---- ---- ---- 0010 }

   {     this nibble applies if file does not exist           xxxx      }
      OPEN_ACTION_FAIL_IF_NEW        =$0000;  { ---- ---- 0000 ---- }
      OPEN_ACTION_CREATE_IF_NEW      =$0010;  { ---- ---- 0001 ---- }

   { DosOpen/DosSetFHandState flags }
      OPEN_ACCESS_READONLY           =$0000;  { ---- ---- ---- -000 }
      OPEN_ACCESS_WRITEONLY          =$0001;  { ---- ---- ---- -001 }
      OPEN_ACCESS_READWRITE          =$0002;  { ---- ---- ---- -010 }
      OPEN_SHARE_DENYREADWRITE       =$0010;  { ---- ---- -001 ---- }
      OPEN_SHARE_DENYWRITE           =$0020;  { ---- ---- -010 ---- }
      OPEN_SHARE_DENYREAD            =$0030;  { ---- ---- -011 ---- }
      OPEN_SHARE_DENYNONE            =$0040;  { ---- ---- -100 ---- }
      OPEN_FLAGS_NOINHERIT           =$0080;  { ---- ---- 1--- ---- }
      OPEN_FLAGS_NO_LOCALITY         =$0000;  { ---- -000 ---- ---- }
      OPEN_FLAGS_SEQUENTIAL          =$0100;  { ---- -001 ---- ---- }
      OPEN_FLAGS_RANDOM              =$0200;  { ---- -010 ---- ---- }
      OPEN_FLAGS_RANDOMSEQUENTIAL    =$0300;  { ---- -011 ---- ---- }
      OPEN_FLAGS_NO_CACHE            =$1000;  { ---1 ---- ---- ---- }
      OPEN_FLAGS_FAIL_ON_ERROR       =$2000;  { --1- ---- ---- ---- }
      OPEN_FLAGS_WRITE_THROUGH       =$4000;  { -1-- ---- ---- ---- }
      OPEN_FLAGS_DASD                =$8000;  { 1--- ---- ---- ---- }
      OPEN_FLAGS_NONSPOOLED          =$00040000;
      OPEN_FLAGS_PROTECTED_HANDLE =$40000000;


   { DosSearchPath() constants }
      SEARCH_PATH           =$0000;
      SEARCH_CUR_DIRECTORY  =$0001;
      SEARCH_ENVIRONMENT    =$0002;
      SEARCH_IGNORENETERRS  =$0004;


   {***********************************************************
   EA Info Levels & Find First/Next
   =========================================
   API's: DosFindFirst, DosQueryFileInfo, DosQueryPathInfo, DosSetFileInfo,
   DosSetPathInfo
   ***********************************************************}

   { File info levels&gml All listed API's }
      FIL_STANDARD          =1;     { Info level 1, standard file info }
      FIL_QUERYEASIZE       =2;     { Level 2, return Full EA size }
      FIL_QUERYEASFROMLIST  =3;     { Level 3, return requested EA's }

   { File info levels: Dos...PathInfo only }
      FIL_QUERYFULLNAME     =5;     { Level 5, return fully qualified
   name of file }


   { DosFsAttach() }
   { Attact or detach }
      FS_ATTACH             =0;     { Attach file server }
      FS_DETACH             =1;     { Detach file server }
      FS_SPOOLATTACH        =2;     { Register a spooler device }
      FS_SPOOLDETACH        =3;     { De-register a spooler device }


   { DosFsCtl() }
   { Routing type }
      FSCTL_HANDLE          =1;     { File Handle directs req routing }
      FSCTL_PATHNAME        =2;     { Path Name directs req routing }
      FSCTL_FSDNAME         =3;     { FSD Name directs req routing }

   { defined FSCTL functions }
      FSCTL_ERROR_INFO      =1;     { return error info from FSD }
      FSCTL_MAX_EASIZE      =2;     { Max ea size for the FSD }

TYPE
   PEASIZEBUF=^EASIZEBUF;
   EASIZEBUF=RECORD       { struct for FSCTL fn 2 - max ea size }
                cbMaxEASize:WORD;        { max. size of one EA }
                cbMaxEAListSize:ULONG;   { max size of the full EA List }
             END;

   { DosQueryFSAttach() }
   { Information level types (defines method of query) }
CONST
      FSAIL_QUERYNAME       =1;     { Return data for a Drive or Device }
      FSAIL_DEVNUMBER       =2;     { Return data for Ordinal Device # }
      FSAIL_DRVNUMBER       =3;     { Return data for Ordinal Drive # }

   { Item types (from data structure item "iType") }
      FSAT_CHARDEV          =1;     { Resident character device }
      FSAT_PSEUDODEV        =2;     { Pusedu-character device }
      FSAT_LOCALDRV         =3;     { Local drive }
      FSAT_REMOTEDRV        =4;     { Remote drive attached to FSD }

TYPE
   PFSQBUFFER=^FSQBUFFER;
   FSQBUFFER=RECORD       { fsqbuf Data structure for QFSAttach}
                iType:WORD;       { Item type }
                cbName:WORD;      { Length of item name, sans NULL }
                szName:BYTE;      { ASCIIZ item name }
                cbFSDName:WORD;   { Length of FSD name, sans NULL }
                szFSDName:BYTE;   { ASCIIZ FSD name }
                cbFSAData:USHORT; { Length of FSD Attach data returned }
                rgFSAData:BYTE;  { FSD Attach data from FSD }
             END;

   PFSQBUFFER2=^FSQBUFFER2;
   FSQBUFFER2=RECORD       { fsqbuf Data structure for QFSAttach}
                iType:USHORT;
                cbName:USHORT;
                cbFSDName:USHORT;
                cbFSAData:USHORT;
                szName:BYTE;
                szFSDName:BYTE;
                rgFSAData:BYTE;
             END;

   PSPOOLATTACH=^SPOOLATTACH;
   SPOOLATTACH=RECORD
                   hNmPipe:USHORT;            { Named pipe handle }
                   ulKey:ULONG;               { Attached key }
               END;


{****************************************************************************
 * File System Drive Information&gml DosQueryFSInfo DosSetFSInfo            *
 ****************************************************************************}

   { FS Drive Info Levels }
CONST
      FSIL_ALLOC            =1;     { Drive allocation info (Query only) }
      FSIL_VOLSER           =2;     { Drive Volum/Serial info }

   { DosQueryFHType() }
   { Handle classes (low 8 bits of Handle Type) }
      FHT_DISKFILE          =$0000;   { Disk file handle }
      FHT_CHRDEV            =$0001;   { Character device handle }
      FHT_PIPE              =$0002;   { Pipe handle }

   { Handle bits (high 8 bits of Handle Type) }
      FHB_DSKREMOTE         =$8000;   { Remote disk }
      FHB_CHRDEVREMOTE      =$8000;   { Remote character device }
      FHB_PIPEREMOTE        =$8000;   { Remote pipe }


TYPE
    PFTIME=^FTIME;
    FTIME=WORD;  {twosecs Bit 0..4, minutes bit 5..10, hours bit 11..15}

    PFDATE=^FDATE;
    FDATE=WORD;  {Day Bit 0..4, Month Bit 5..8, year bit 9..15}

    PVOLUMELABEL=^VOLUMELABEL;
    VOLUMELABEL=RECORD
                      cch:BYTE;
                      szVolLabel:CSTRING[11];
                END;

    PFSINFO=^FSINFO;
    FSINFO=RECORD
               fdateCreation:FDATE;
               ftimeCreation:FTIME;
               vol:VOLUMELABEL;
           END;

   { HANDTYPE values }
CONST
      HANDTYPE_FILE         =$0000;
      HANDTYPE_DEVICE       =$0001;
      HANDTYPE_PIPE         =$0002;
      HANDTYPE_PROTECTED    =$4000;
      HANDTYPE_NETWORK      =$8000;

TYPE
      PFILELOCK=^FILELOCK;
      FILELOCK=RECORD
                    lOffset:LONG;
                    lRange:LONG;
               END;

      HFILE=LHANDLE;
      HEV=ULONG;
      FHLOCK=ULONG;


TYPE
      PFILEFINDBUF=^FILEFINDBUF;
      FILEFINDBUF=RECORD
                     fdateCreation:FDATE;
                     ftimeCreation:FTIME;
                     fdateLastAccess:FDATE;
                     ftimeLastAccess:FTIME;
                     fdateLastWrite:FDATE;
                     ftimeLastWrite:FTIME;
                     cbFile:ULONG;
                     cbFileAlloc:ULONG;
                     attrFile:USHORT;
                     cchName:BYTE;
                     achName:CSTRING[CCHMAXPATHCOMP-1];
                END;

      PFILEFINDBUF2=^FILEFINDBUF2;
      FILEFINDBUF2=RECORD    {pack 2}
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:ULONG;
                        cbFileAlloc:ULONG;
                        attrFile:USHORT;
                        cbList:ULONG;
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                   END;

      PFILEFINDBUF3=^FILEFINDBUF3;
      FILEFINDBUF3=RECORD  { pack 2 }
                        oNextEntryOffset:ULONG;            { new field }
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:ULONG;
                        cbFileAlloc:ULONG;
                        attrFile:ULONG;          { widened field }
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                  END;

      PFILEFINDBUF4=^FILEFINDBUF4;
      FILEFINDBUF4=RECORD   { pack 2 }
                        oNextEntryOffset:ULONG;            { new field }
                        fdateCreation:FDATE;
                        ftimeCreation:FTIME;
                        fdateLastAccess:FDATE;
                        ftimeLastAccess:FTIME;
                        fdateLastWrite:FDATE;
                        ftimeLastWrite:FTIME;
                        cbFile:ULONG;
                        cbFileAlloc:ULONG;
                        attrFile:ULONG;       { widened field }
                        cbList:ULONG;
                        cchName:BYTE;
                        achName:CSTRING[CCHMAXPATHCOMP-1];
                  END;

      { extended attribute structures }

      PGEA=^GEA;
      GEA=RECORD  {pack 2}
                cbName:BYTE;        { name length not including NULL }
                szName:CHAR;        { attribute name }
          END;

      PGEALIST=^GEALIST;
      GEALIST=RECORD  { pack 2 }
                   cbList:ULONG;    { total bytes of structure including full list }
                   list:GEA;        { variable length GEA structures }
              END;

      PFEA=^FEA;
      FEA=RECORD  {pack 2}
                fEA:BYTE;           { flags                              }
                cbName:BYTE;        { name length not including NULL }
                cbValue:USHORT;     { value length }
          END;

      { flags for _FEA.fEA }
CONST
         FEA_NEEDEA         =$80;   { need EA bit }

TYPE
      PFEALIST=^FEALIST;
      FEALIST=RECORD { pack 2}
                   cbList:ULONG;    { total bytes of structure including full list }
                   list:FEA;        { variable length FEA structures }
              END;

      PEAOP=^EAOP;
      EAOP=RECORD { pack 2}
                 fpGEAList:PGEALIST; { general EA list }
                 fpFEAList:PFEALIST; { full EA list }
                 oError:ULONG;
           END;

      PFEA2=^FEA2;
      FEA2=RECORD {pack 1}
                 oNextEntryOffset:ULONG;    { new field }
                 fEA:BYTE;
                 cbName:BYTE;
                 cbValue:USHORT;
                 szName:CString[1];            { new field }
           END;

      PFEA2LIST=^FEA2LIST;
      FEA2LIST=RECORD {pack 1}
                     cbList:ULONG;
                     list:ARRAY[0..0] OF FEA2;
               END;

      PGEA2=^GEA2;
      GEA2=RECORD {pack 1}
                 oNextEntryOffset:ULONG; { new field }
                 cbName:BYTE;
                 szName:ARRAY[0..0] OF BYTE;         { new field }
           END;

      PGEA2LIST=^GEA2LIST;
      GEA2LIST=RECORD      { pack 1 }
                     cbList:ULONG;
                     list:ARRAY[0..0] OF GEA2;
               END;

      PEAOP2=^EAOP2;
      EAOP2=RECORD  { pack 1 }
                  fpGEA2List:PGEA2LIST;       { GEA set }
                  fpFEA2List:PFEA2LIST;       { FEA set }
                  oError:ULONG;           { offset of FEA error }
            END;

      {
      * Equates for the types of EAs that follow the convention that we have
      * established.
      *
      * Values =$FFFE thru =$8000 are reserved.
      * Values =$0000 thru =$7fff are user definable.
      * Value  =$FFFC is not used
      }
CONST
         EAT_BINARY      =$FFFE;      { length preceeded binary }
         EAT_ASCII       =$FFFD;      { length preceeded ASCII }
         EAT_BITMAP      =$FFFB;      { length preceeded bitmap }
         EAT_METAFILE    =$FFFA;      { length preceeded metafile }
         EAT_ICON        =$FFF9;      { length preceeded icon }
         EAT_EA          =$FFEE;      { length preceeded ASCII }
                                          { name of associated data (#include) }
         EAT_MVMT        =$FFDF;      { multi-valued, multi-typed field }
         EAT_MVST        =$FFDE;      { multi-valued, single-typed field }
         EAT_ASN1        =$FFDD;      { ASN.1 field }

   { File time and date types }

TYPE
   PFILESTATUS=^FILESTATUS;
   FILESTATUS=RECORD
                  fdateCreation:FDATE;
                  ftimeCreation:FTIME;
                  fdateLastAccess:FDATE;
                  ftimeLastAccess:FTIME;
                  fdateLastWrite:FDATE;
                  ftimeLastWrite:FTIME;
                  cbFile:ULONG;
                  cbFileAlloc:ULONG;
                  attrFile:WORD;
              END;

   PFILESTATUS2=^FILESTATUS2;
   FILESTATUS2=RECORD
                  fdateCreation:FDATE;
                  ftimeCreation:FTIME;
                  fdateLastAccess:FDATE;
                  ftimeLastAccess:FTIME;
                  fdateLastWrite:FDATE;
                  ftimeLastWrite:FTIME;
                  cbFile:ULONG;
                  cbFileAlloc:ULONG;
                  attrFile:WORD;
                  cbList:ULONG;
               END;

   PFILESTATUS3=^FILESTATUS3;
   FILESTATUS3=RECORD
                     fdateCreation:FDATE;
                     ftimeCreation:FTIME;
                     fdateLastAccess:FDATE;
                     ftimeLastAccess:FTIME;
                     fdateLastWrite:FDATE;
                     ftimeLastWrite:FTIME;
                     cbFile:ULONG;
                     cbFileAlloc:ULONG;
                     attrFile:ULONG;
               END;

   PFILESTATUS4=^FILESTATUS4;
   FILESTATUS4=RECORD
                     fdateCreation:FDATE;
                     ftimeCreation:FTIME;
                     fdateLastAccess:FDATE;
                     ftimeLastAccess:FTIME;
                     fdateLastWrite:FDATE;
                     ftimeLastWrite:FTIME;
                     cbFile:ULONG;
                     cbFileAlloc:ULONG;
                     attrFile:ULONG;
                     cbList:ULONG;
               END;

   PFSALLOCATE=^FSALLOCATE;
   FSALLOCATE=RECORD
                   idFileSystem:ULONG;
                   cSectorUnit:ULONG;
                   cUnit:ULONG;
                   cUnitAvail:ULONG;
                   cbSector:USHORT;
              END;

   HDIR=LHANDLE;

   { defines for DosSetPathInfo -pathinfo flag }
CONST
      DSPI_WRTTHRU    =$10;    { write through }


TYPE
   PDENA1=^DENA1;
   DENA1=RECORD  { pack 1 }
              reserved:UCHAR;     { 0 }
              cbName:UCHAR;       { length of name exculding NULL }
              cbValue:USHORT;     { length of value }
              szName:UCHAR;       { variable length asciiz name }
         END;

   PDENA2=^DENA2;
   DENA2=FEA2;

   { Infolevels for DosEnumAttribute  }
CONST
      ENUMEA_LEVEL_NO_VALUE   =1;      { FEA without value }
   { Reference types for DosEnumAttribute }
      ENUMEA_REFTYPE_FHANDLE  =0;       { file handle }
      ENUMEA_REFTYPE_PATH     =1;       { path name }
      ENUMEA_REFTYPE_MAX      =ENUMEA_REFTYPE_PATH;


{ 32-bit Semaphore Support }

{ Semaphore Attributes }
CONST
      DC_SEM_SHARED   =$01;   { DosCreateMutex, DosCreateEvent, and     }
                              {   DosCreateMuxWait use it to indicate   }
                              {   whether the semaphore is shared or    }
                              {   private when the PSZ is null          }
      DCMW_WAIT_ANY   =$02;   { DosCreateMuxWait option for wait on any }
                              {   event/mutex to occur                  }
      DCMW_WAIT_ALL   =$04;   { DosCreateMuxWait option for wait on all }
                              {   events/mutexs to occur                }

      SEM_INDEFINITE_WAIT     =-1;
      SEM_IMMEDIATE_RETURN    = 0;


TYPE
    HSEM=LONGWORD;

    PSEMRECORD=^SEMRECORD;
    SEMRECORD=RECORD
                    hsemCur:HSEM;
                    ulUser:ULONG;
              END;


   HMTX=ULONG;
   HMUX=ULONG;


TYPE
     HTIMER=LHANDLE;

CONST
      PT_16BIT        =0;
      PT_32BIT        =1;

{** Resource support }

{ Predefined resource types }
CONST
      RT_POINTER      =1;   { mouse pointer shape }
      RT_BITMAP       =2;   { bitmap }
      RT_MENU         =3;   { menu template }
      RT_DIALOG       =4;   { dialog template }
      RT_STRING       =5;   { string tables }
      RT_FONTDIR      =6;   { font directory }
      RT_FONT         =7;   { font }
      RT_ACCELTABLE   =8;   { accelerator tables }
      RT_RCDATA       =9;   { binary data }
      RT_MESSAGE      =10;  { error msg     tables }
      RT_DLGINCLUDE   =11;  { dialog include file name }
      RT_VKEYTBL      =12;  { key to vkey tables }
      RT_KEYTBL       =13;  { key to UGL tables }
      RT_CHARTBL      =14;  { glyph to character tables }
      RT_DISPLAYINFO  =15;  { screen display information }

      RT_FKASHORT     =16;  { function key area short form }
      RT_FKALONG      =17;  { function key area long form }

      RT_HELPTABLE    =18;  { Help table for Cary Help manager }
      RT_HELPSUBTABLE =19;  { Help subtable for Cary Help manager }

      RT_FDDIR        =20;  { DBCS uniq/font driver directory }
      RT_FD           =21;  { DBCS uniq/font driver }

      RT_MAX          =22;  { 1st unused Resource Type }


      RF_ORDINALID    =$80000000; { ordinal id flag in resource table }


{** NLS Support }

TYPE
   PCOUNTRYCODE=^COUNTRYCODE;
   COUNTRYCODE=RECORD
                    country:ULONG;
                    codepage:ULONG;
               END;

   PCOUNTRYINFO=^COUNTRYINFO;
   COUNTRYINFO=RECORD
                    country:ULONG;
                    codepage:ULONG;
                    fsDateFmt:ULONG;
                    szCurrency:CSTRING[4];
                    szThousandsSeparator:CSTRING[1];
                    szDecimal:CSTRING[1];
                    szDateSeparator:CSTRING[1];
                    szTimeSeparator:CSTRING[1];
                    fsCurrencyFmt:UCHAR;
                    cDecimalPlace:UCHAR;
                    fsTimeFmt:UCHAR;
                    abReserved1:ARRAY[0..1] OF USHORT;
                    szDataSeparator:CSTRING[1];
                    abReserved2:ARRAY[0..4] OF USHORT;
              END;

   { DosSetSigExceptionFocus codes }
CONST
      SIG_UNSETFOCUS  =0;
      SIG_SETFOCUS    =1;

TYPE
    HQUEUE=LHANDLE;

    PREQUESTDATA=^REQUESTDATA;
    REQUESTDATA=RECORD
                    pid:PID;
                    ulData:ULONG;
                END;

CONST
         QUE_FIFO              =0;
         QUE_LIFO              =1;
         QUE_PRIORITY          =2;
         QUE_NOCONVERT_ADDRESS =0;
         QUE_CONVERT_ADDRESS   =4;

   { definitions for DosSearchPath control word }
CONST
      DSP_IMPLIEDCUR          =1; { current dir will be searched first }
      DSP_PATHREF             =2; { from env.variable }
      DSP_IGNORENETERR        =4; { ignore net errs & continue search }

   { indices for DosQuerySysInfo }
      QSV_MAX_PATH_LENGTH     =1;
      Q_MAX_PATH_LENGTH       =QSV_MAX_PATH_LENGTH;
      QSV_MAX_TEXT_SESSIONS   =2;
      QSV_MAX_PM_SESSIONS     =3;
      QSV_MAX_VDM_SESSIONS    =4;
      QSV_BOOT_DRIVE          =5;       { 1=A, 2=B, etc. }
      QSV_DYN_PRI_VARIATION   =6;       { 0=Absolute, 1=Dynamic }
      QSV_MAX_WAIT            =7;       { seconds }
      QSV_MIN_SLICE           =8;       { milli seconds }
      QSV_MAX_SLICE           =9;       { milli seconds }
      QSV_PAGE_SIZE           =10;
      QSV_VERSION_MAJOR       =11;
      QSV_VERSION_MINOR       =12;
      QSV_VERSION_REVISION    =13;      { Revision letter }
      QSV_MS_COUNT            =14;      { Free running millisecond counter }
      QSV_TIME_LOW            =15;      { Low dword of time in seconds }
      QSV_TIME_HIGH           =16;      { High dword of time in seconds }
      QSV_TOTPHYSMEM          =17;      { Physical memory on system }
      QSV_TOTRESMEM           =18;      { Resident memory on system }
      QSV_TOTAVAILMEM         =19;      { Available memory for all processes }
      QSV_MAXPRMEM            =20;      { Avail private mem for calling proc }
      QSV_MAXSHMEM            =21;      { Avail shared mem for calling proc }
      QSV_TIMER_INTERVAL      =22;      { Timer interval in tenths of ms }
      QSV_MAX_COMP_LENGTH     =23;      { max len of one component in a name }
      QSV_MAX                 =QSV_MAX_COMP_LENGTH;

   { definitions for DosError - combine with | }
      FERR_DISABLEHARDERR     =$00000000;     { disable hard error popups }
      FERR_ENABLEHARDERR      =$00000001;     { enable hard error popups }
      FERR_ENABLEEXCEPTION    =$00000000;     { enable exception popups }
      FERR_DISABLEEXCEPTION   =$00000002;     { disable exception popups }

   { definitions for DosQueryRASInfo Index }
      SIS_MMIOADDR            =0;
      SIS_MEC_TABLE           =1;
      SIS_SYS_LOG             =2;

{** Session manager support }
TYPE
   PSTARTDATA=^STARTDATA;
   STARTDATA=RECORD
                  Length:USHORT;
                  Related:USHORT;
                  FgBg:USHORT;
                  TraceOpt:USHORT;
                  PgmTitle:PChar;
                  PgmName:PChar;
                  PgmInputs:PChar;
                  TermQ:PBYTE;
                  Environment:PBYTE;
                  InheritOpt:USHORT;
                  SessionType:USHORT;
                  IconFile:PChar;
                  PgmHandle:ULONG;
                  PgmControl:USHORT;
                  InitXPos:USHORT;
                  InitYPos:USHORT;
                  InitXSize:USHORT;
                  InitYSize:USHORT;
                  Reserved:USHORT;
                  ObjectBuffer:PChar;
                  ObjectBuffLen:ULONG;
            END;

CONST
      SSF_RELATED_INDEPENDENT =0;
      SSF_RELATED_CHILD       =1;

      SSF_FGBG_FORE           =0;
      SSF_FGBG_BACK           =1;

      SSF_TRACEOPT_NONE       =0;
      SSF_TRACEOPT_TRACE      =1;
      SSF_TRACEOPT_TRACEALL   =2;

      SSF_INHERTOPT_SHELL     =0;
      SSF_INHERTOPT_PARENT    =1;

   { note that these types are identical to those in pmshl.h for PROG_* }
      SSF_TYPE_DEFAULT        =0;
      SSF_TYPE_FULLSCREEN     =1;
      SSF_TYPE_WINDOWABLEVIO  =2;
      SSF_TYPE_PM             =3;
      SSF_TYPE_VDM            =4;
      SSF_TYPE_GROUP          =5;
      SSF_TYPE_DLL            =6;
      SSF_TYPE_WINDOWEDVDM    =7;
      SSF_TYPE_PDD            =8;
      SSF_TYPE_VDD            =9;

   { note that these flags are identical to those in pmshl.h for SHE_* }
      SSF_CONTROL_VISIBLE     =$0000;
      SSF_CONTROL_INVISIBLE   =$0001;
      SSF_CONTROL_MAXIMIZE    =$0002;
      SSF_CONTROL_MINIMIZE    =$0004;
      SSF_CONTROL_NOAUTOCLOSE =$0008;
      SSF_CONTROL_SETPOS      =$8000;

TYPE
   PSTATUSDATA=^STATUSDATA;
   STATUSDATA=RECORD
                    Length:USHORT;
                    SelectInd:USHORT;
                    BondInd:USHORT;
              END;

   { SelectInd and BondInd paramater values for DosSetSession }
CONST
      SET_SESSION_UNCHANGED      =0;
      SET_SESSION_SELECTABLE     =1;
      SET_SESSION_NON_SELECTABLE =2;
      SET_SESSION_BOND           =1;
      SET_SESSION_NO_BOND        =2;

   { TargetOption (scope) parameter values for DosStopSession }
      STOP_SESSION_SPECIFIED     =0;
      STOP_SESSION_ALL           =1;

   { AppType returned in by DosQueryAppType in pFlags as follows          }
CONST
      FAPPTYP_NOTSPEC         =$0000;
      FAPPTYP_NOTWINDOWCOMPAT =$0001;
      FAPPTYP_WINDOWCOMPAT    =$0002;
      FAPPTYP_WINDOWAPI       =$0003;
      FAPPTYP_BOUND           =$0008;
      FAPPTYP_DLL             =$0010;
      FAPPTYP_DOS             =$0020;
      FAPPTYP_PHYSDRV         =$0040;  { physical device driver       }
      FAPPTYP_VIRTDRV         =$0080;  { virtual device driver        }
      FAPPTYP_PROTDLL         =$0100;  { 'protected memory' dll       }
      FAPPTYP_WINDOWSREAL     =$0200;  { Windows real mode app        }
      FAPPTYP_WINDOWSPROT     =$0400;  { Windows protect mode app     }
      FAPPTYP_WINDOWSPROT31   =$1000;  { Windows 3.1 protect mode app }
      FAPPTYP_32BIT           =$4000;
      FAPPTYP_EXETYPE         =FAPPTYP_WINDOWAPI;

      FAPPTYP_RESERVED        =NOT (FAPPTYP_WINDOWAPI | FAPPTYP_BOUND |
                                    FAPPTYP_DLL | FAPPTYP_DOS |
                                    FAPPTYP_PHYSDRV | FAPPTYP_VIRTDRV |
                                    FAPPTYP_PROTDLL | FAPPTYP_32BIT);

      EAT_APPTYP_PMAPI        =$00;            { Uses PM API }
      EAT_APPTYP_DOS          =$01;            { DOS APP }
      EAT_APPTYP_PMW          =$02;            { Window compatible }
      EAT_APPTYP_NOPMW        =$03;            { Not Window compatible }
      EAT_APPTYP_EXETYPE      =$03;            { EXE type mask }
      EAT_APPTYP_RESERVED     =NOT EAT_APPTYP_EXETYPE;

CONST
      DEVINFO_PRINTER         =0;       { Number of printers attached }
      DEVINFO_RS232           =1;       { Number of RS232 ports }
      DEVINFO_FLOPPY          =2;       { Number of diskette drives }
      DEVINFO_COPROCESSOR     =3;       { Presence of math coprocessor }
      DEVINFO_SUBMODEL        =4;       { PC Submodel Type }
      DEVINFO_MODEL           =5;       { PC Model Type }
      DEVINFO_ADAPTER         =6;       { Primary display adapter type }


CONST
      INFO_COUNT_PARTITIONABLE_DISKS  =1;       { # of partitionable disks }
      INFO_GETIOCTLHANDLE             =2;       { Obtain handle            }
      INFO_FREEIOCTLHANDLE            =3;       { Release handle           }



{** Data structures used with named pipes **}
TYPE
   HPIPE=LHANDLE;


   PAVAILDATA=^AVAILDATA;
   AVAILDATA=RECORD
                 cbpipe:USHORT;      { bytes left in the pipe }
                 cbmessage:USHORT;   { bytes left in the current message }
             END;

   PPIPEINFO=^PIPEINFO;
   PIPEINFO=RECORD
                 cbOut:USHORT;       { length of outgoing I/O buffer }
                 cbIn:USHORT;        { length of incoming I/O buffer }
                 cbMaxInst:BYTE;     { maximum number of instances   }
                 cbCurInst:BYTE;     { current number of instances   }
                 cbName:BYTE;        { length of pipe name           }
                 szName:CHAR;        { start of name                 }
            END;

   PPIPESEMSTATE=^PIPESEMSTATE;
   PIPESEMSTATE=RECORD
                     fStatus:BYTE;  { type of record, 0 = EOI, 1 = read ok, }
                                    { 2 = write ok, 3 = pipe closed         }
                     fFlag:BYTE;    { additional info, 01 = waiting thread  }
                     usKey:USHORT;  { user's key value                      }
                     usAvail:USHORT;{ available data/space if status = 1/2  }
                END;

CONST
      NP_INDEFINITE_WAIT      =-1;
      NP_DEFAULT_WAIT         =0;

   { DosPeekNmPipe() pipe states }

      NP_STATE_DISCONNECTED   =$0001;
      NP_STATE_LISTENING      =$0002;
      NP_STATE_CONNECTED      =$0003;
      NP_STATE_CLOSING        =$0004;

   { DosCreateNPipe open modes }

      NP_ACCESS_INBOUND       =$0000;
      NP_ACCESS_OUTBOUND      =$0001;
      NP_ACCESS_DUPLEX        =$0002;
      NP_INHERIT              =$0000;
      NP_NOINHERIT            =$0080;
      NP_WRITEBEHIND          =$0000;
      NP_NOWRITEBEHIND        =$4000;

   { DosCreateNPipe and DosQueryNPHState state }

      NP_READMODE_BYTE        =$0000;
      NP_READMODE_MESSAGE     =$0100;
      NP_TYPE_BYTE            =$0000;
      NP_TYPE_MESSAGE         =$0400;
      NP_END_CLIENT           =$0000;
      NP_END_SERVER           =$4000;
      NP_WAIT                 =$0000;
      NP_NOWAIT               =$8000;
      NP_UNLIMITED_INSTANCES  =$00FF;

   { values in fStatus }
CONST
      NPSS_EOI                   =0;     { End Of Information    }
      NPSS_RDATA                 =1;     { read data available   }
      NPSS_WSPACE                =2;     { write space available }
      NPSS_CLOSE                 =3;     { pipe in CLOSING state }

   { values in npss_flag }
      NPSS_WAIT                  =$01;  { waiting thread on end of pipe }

   { defined bits in pipe mode }
      NP_NBLK                    =$8000; { non-blocking read/write }
      NP_SERVER                  =$4000; { set if server end       }
      NP_WMESG                   =$0400; { write messages          }
      NP_RMESG                   =$0100; { read as messages        }
      NP_ICOUNT                  =$00FF; { instance count field    }


   {Named pipes may be in one of several states depending on the actions
   * that have been taken on it by the server end and client end.  The
   * following state/action table summarizes the valid state transitions:
   *
   * Current state           Action                  Next state
   *
   *  <none>             server DosMakeNmPipe        DISCONNECTED
   *  DISCONNECTED       server connect              LISTENING
   *  LISTENING          client open                 CONNECTED
   *  CONNECTED          server disconn              DISCONNECTED
   *  CONNECTED          client close                CLOSING
   *  CLOSING            server disconn              DISCONNECTED
   *  CONNECTED          server close                CLOSING
   *  <any other>        server close                <pipe deallocated>
   *
   * If a server disconnects his end of the pipe, the client end will enter a
   * special state in which any future operations (except close) on the file
   * descriptor associated with the pipe will return an error.
   }

   {
   *      Values for named pipe state
   }

      NP_DISCONNECTED       =1;         { after pipe creation or Disconnect }
      NP_LISTENING          =2;         { after DosNmPipeConnect            }
      NP_CONNECTED          =3;         { after Client open                 }
      NP_CLOSING            =4;         { after Client or Server close      }


   { DosProfile ordinal number }
CONST
      PROF_ORDINAL        =133;

   { DosProfile usType }

      PROF_SYSTEM           =0;
      PROF_USER             =1;
      PROF_USEDD            =2;
      PROF_KERNEL           =4;
      PROF_VERBOSE          =8;
      PROF_ENABLE           =16;

   { DosProfile usFunc }

      PROF_ALLOC            =0;
      PROF_CLEAR            =1;
      PROF_ON               =2;
      PROF_OFF              =3;
      PROF_DUMP             =4;
      PROF_FREE             =5;

   { DosProfile tic count granularity (DWORD) }

      PROF_SHIFT            =2;

   { DosProfile module name string length }

      PROF_MOD_NAME_SIZE    =10;

   { DosProfile error code for end of data }

      PROF_END_OF_DATA      =13;


TYPE
    HVDD=LHANDLE;


IMPORTS

FUNCTION DosBeep(freq,dur:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 286;
FUNCTION DosExit(action,result:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 234;
FUNCTION DosCreateThread(VAR aptid:TID;pfn:POINTER;param:POINTER;flag:ULONG;
                         cbStack:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 311;
FUNCTION DosResumeThread(atid:TID):APIRET;
                    APIENTRY;             'DOSCALLS' index 237;
FUNCTION DosSuspendThread(atid:TID):APIRET;
                    APIENTRY;             'DOSCALLS' index 238;
FUNCTION DosGetInfoBlocks(VAR pptib:PTIB;VAR pppib:PPIB):APIRET;
                    APIENTRY;             'DOSCALLS' index 312;
FUNCTION DosKillThread(atid:TID):APIRET;
                    APIENTRY;             'DOSCALLS' index 111;
FUNCTION DosWaitChild(action,option:ULONG;VAR pres:RESULTCODES;
                      VAR appid:PID;apid:PID):APIRET;
                    APIENTRY;             'DOSCALLS' index 280;
FUNCTION DosWaitThread(VAR aptid:TID;option:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 349;
FUNCTION DosSleep(msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 229;
FUNCTION DosDebug(VAR apdbgbuf:TDBGBUF):APIRET;
                    APIENTRY;             'DOSCALLS' index 317;
FUNCTION DosEnterCritSec:APIRET;
                    APIENTRY;             'DOSCALLS' index 232;
FUNCTION DosExitCritSec:APIRET;
                    APIENTRY;             'DOSCALLS' index 233;
FUNCTION DosExitList(ordercode:ULONG;pfn:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 296;
FUNCTION DosExecPgm(pObjname:POINTER;cbObjname:LONG;execFlag:ULONG;
                    VAR pArg,pEnv:CSTRING;VAR pRes:RESULTCODES;
                    CONST pName:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 283;
FUNCTION  DosSetPriority(scope,aclass:ULONG;delta:LONG;PorTid:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 236;
FUNCTION DosKillProcess(action:ULONG;apid:PID):APIRET;
                    APIENTRY;             'DOSCALLS' index 235;
FUNCTION DosSetFileLocks(ahFile:HFILE;VAR pflUnlock,pflLock:FILELOCK;
                         timeout,flags:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 428;
FUNCTION DosProtectSetFileLocks(ahFile:HFILE;VAR pflUnlock,pflLock:FILELOCK;
                                timeout,flags:ULONG;
                                fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 639;
FUNCTION DosCancelLockRequest(ahFile:HFILE;VAR pflLock:FILELOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 429;
FUNCTION DosOpen(pszFileName:CSTRING;VAR pHf:HFILE;VAR pulAction:ULONG;
                 cbFile,ulAttribute,fsOpenFlags,fsOpenMode:ULONG;
                 VAR apeaop2:EAOP2):APIRET;
                    APIENTRY;             'DOSCALLS' index 273;
FUNCTION DosProtectOpen(pszFileName:CSTRING;VAR phf:HFILE;VAR pulAction:ULONG;
                        cbFile,ulAttribute,fsOpenFlags,fsOpenMode:ULONG;
                        VAR apeaop2:EAOP2;
                        VAR pfhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 637;
FUNCTION DosClose(ahFile:HFILE):APIRET;
                    APIENTRY;             'DOSCALLS' index 257;
FUNCTION DosProtectClose(ahFile:HFILE;fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 638;
FUNCTION DosRead(ahFile:HFILE;VAR pBuffer;cbRead:ULONG;
                 VAR pcbActual:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 281;
FUNCTION DosProtectRead(ahFile:HFILE;VAR pBuffer;cbRead:ULONG;
                        VAR pcbActual:ULONG;fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 641;
FUNCTION DosWrite(ahFile:HFILE;CONST pBuffer;cbWrite:ULONG;
                  VAR pcbActual:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 282;
FUNCTION DosProtectWrite(ahFile:HFILE;VAR pBuffer;cbWrite:ULONG;
                         VAR pcbActual:ULONG;
                         fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 642;
FUNCTION DosDelete(VAR pszFile:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 259;
FUNCTION DosForceDelete(VAR pszFile:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 110;
FUNCTION DosDupHandle(ahFile:HFILE;VAR apHfile:HFILE):APIRET;
                    APIENTRY;             'DOSCALLS' index 260;
FUNCTION DosQueryFHState(ahFile:HFILE;VAR pMode:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 276;
FUNCTION DosProtectQueryFHState(ahFile:HFILE;VAR pMode:ULONG;
                                fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 645;
FUNCTION DosSetFHState(ahFile:HFILE;mode:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 221;
FUNCTION DosProtectSetFHState(ahFile:HFILE;mode:ULONG;
                              fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 644;
FUNCTION DosQueryHType(ahFile:HFILE;VAR pType,pAttr:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 224;
FUNCTION DosFindFirst(VAR pszFileSpec:CSTRING;VAR aphdir:HDIR;flAttribute:ULONG;
                      VAR pfindbuf;cbBuf:ULONG;VAR pcFileNames:ULONG;
                      ulInfoLevel:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 264;
FUNCTION DosFindNext(ahDir:HDIR;VAR pfindbuf;cbfindbuf:ULONG;
                     VAR pcFilenames:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 265;
FUNCTION DosFindClose(ahDir:HDIR):APIRET;
                    APIENTRY;             'DOSCALLS' index 263;
FUNCTION DosFSAttach(VAR pszDevice:CSTRING;VAR pszFilesystem:CSTRING;VAR pData;
                     cbData:ULONG;flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 269;
FUNCTION DosQueryFSAttach(VAR pszDeviceName:CSTRING;ulOrdinal,ulFSAInfoLevel:ULONG;
                          VAR pfsqb:FSQBUFFER2;
                          VAR pcbBuffLength:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 277;
FUNCTION DosFSCtl(VAR pData;cbData:ULONG;VAR pcbData:ULONG;VAR pParms;
                  cbParms:ULONG;VAR pcbParms:ULONG;afunction:ULONG;
                  VAR pszRoute:CSTRING;ahFile:HFILE;method:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 285;
FUNCTION DosSetFileSize(ahFile:HFILE;cbSize:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 272;
FUNCTION DosProtectSetFileSize(ahFile:HFILE;cbSize:ULONG;
                               fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 640;
FUNCTION DosResetBuffer(ahFile:HFILE):APIRET;
                    APIENTRY;             'DOSCALLS' index 254;
FUNCTION DosSetFilePtr(ahFile:HFILE;ib:LONG;method:ULONG;
                       VAR ibActual:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 256;
FUNCTION DosProtectSetFilePtr(ahFile:HFILE;ib:LONG;method:ULONG;
                              VAR ibActual:ULONG;
                              fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 621;
FUNCTION DosMove(VAR pszOld,pszNew:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 271;
FUNCTION DosCopy(VAR pszOld,pszNew:CSTRING;option:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 258;
FUNCTION DosEditName(metalevel:ULONG;VAR pszSource,pszEdit:CSTRING;
                     VAR pszTarget;cbTarget:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 261;
FUNCTION DosCreateDir(pszDirName:CSTRING;VAR apeaop2:EAOP2):APIRET;
                    APIENTRY;             'DOSCALLS' index 270;
FUNCTION DosDeleteDir(pszDir:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 226;
FUNCTION DosSetDefaultDisk(disknum:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 220;
FUNCTION DosQueryCurrentDisk(VAR pdisknum,plogical:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 275;
FUNCTION DosSetCurrentDir(pszDir:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 255;
FUNCTION DosQueryCurrentDirAPI(disknum:ULONG;VAR pBuf;
                               VAR pcbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 274;
FUNCTION DosQueryFSInfo(disknum,infolevel:ULONG;VAR pBuf;
                        cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 278;
FUNCTION DosSetFSInfo(disknum,infolevel:ULONG;VAR pBuf;
                      cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 222;
FUNCTION DosQueryVerify(VAR apBool:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 225;
FUNCTION DosSetVerify(apBool:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 210;
FUNCTION DosSetMaxFH(cFH:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 209;
FUNCTION DosSetRelMaxFH(VAR pcbReqCount:LONG;
                        VAR pcbCurMaxFH:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 382;
FUNCTION DosQueryFileInfo(hf:HFILE;ulInfoLevel:ULONG;
                          VAR pInfo;cbInfoBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 279;
FUNCTION DosProtectQueryFileInfo(hf:HFILE;ulInfoLevel:ULONG;
                                 VAR pInfo;cbInfoBuf:ULONG;
                                 fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 646;
FUNCTION DosSetFileInfo(hf:HFILE;ulInfoLevel:ULONG;VAR pInfoBuf;
                        cbInfoBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 218;
FUNCTION DosProtectSetFileInfo(hf:HFILE;ulInfoLevel:ULONG;VAR pInfoBuf;
                               cbInfoBuf:ULONG;
                               fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 643;
FUNCTION DosQueryPathInfo(VAR pszPathName:CSTRING;ulInfoLevel:ULONG;VAR pInfoBuf;
                          cbInfoBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 223;
FUNCTION DosSetPathInfo(pszPathName:CSTRING;ulInfoLevel:ULONG;VAR pInfoBuf;
                        cbInfoBuf,flOptions:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 219;
FUNCTION DosShutdown(ulReserved:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 415;
FUNCTION DosEnumAttribute(ulRefType:ULONG;VAR pvFile;ulEntry:ULONG;
                          VAR pvBuf;cbBuf:ULONG;VAR pulCount:ULONG;
                          ulInfoLevel:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 372;
FUNCTION DosProtectEnumAttribute(ulRefType:ULONG;VAR pvFile;
                                 ulEntry:ULONG;VAR pvBuf;cbBuf:ULONG;
                                 VAR pulCount:ULONG;ulInfoLevel:ULONG;
                                 fhFileHandleLockID:FHLOCK):APIRET;
                    APIENTRY;             'DOSCALLS' index 636;
FUNCTION DosAllocMem(VAR ppb:POINTER;cb,flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 299;
FUNCTION DosFreeMem(pb:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 304;
FUNCTION DosSetMem(pb:POINTER;cb,flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 305;
FUNCTION DosGiveSharedMem(pb:POINTER;apid:PID;flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 303;
FUNCTION DosGetSharedMem(pb:POINTER;flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 302;
FUNCTION DosGetNamedSharedMem(VAR ppb:POINTER;pszName:CSTRING;
                              flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 301;
FUNCTION DosAllocSharedMem(VAR ppb:POINTER;VAR pszName:CSTRING;
                           cb,flag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 300;
FUNCTION DosQueryMem(pb:POINTER;VAR pcb,pFlag:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 306;
FUNCTION DosSubAllocMem(pbBase:POINTER;VAR ppb:POINTER;
                        cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 345;
FUNCTION DosSubFreeMem(pbBase:POINTER;pb:POINTER;cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 346;
FUNCTION DosSubSetMem(pbBase:POINTER;flag,cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 344;
FUNCTION DosSubUnsetMem(pbBase:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 347;
FUNCTION DosCreateEventSem(VAR pszName:CSTRING;VAR aphev:HEV;flAttr:ULONG;
                           fState:BOOL):APIRET;
                    APIENTRY;             'DOSCALLS' index 324;
FUNCTION DosOpenEventSem (VAR pszName:CSTRING;VAR aphev:HEV):APIRET;
                    APIENTRY;             'DOSCALLS' index 325;
FUNCTION DosCloseEventSem(ahev:HEV):APIRET;
                    APIENTRY;             'DOSCALLS' index 326;
FUNCTION DosResetEventSem(ahev:HEV;VAR pulPostCt:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 327;
FUNCTION DosPostEventSem(ahev:HEV):APIRET;
                    APIENTRY;             'DOSCALLS' index 328;
FUNCTION DosWaitEventSem(ahev:HEV;ulTimeout:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 329;
FUNCTION DosQueryEventSem(ahev:HEV;VAR pulPostCt:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 330;
FUNCTION DosCreateMutexSem(pszName:CSTRING;VAR aphmtx:HMTX;flAttr:ULONG;
                           fState:BOOL):APIRET;
                    APIENTRY;             'DOSCALLS' index 331;
FUNCTION DosOpenMutexSem (pszName:CSTRING;VAR phmtx:HMTX):APIRET;
                    APIENTRY;             'DOSCALLS' index 332;
FUNCTION DosCloseMutexSem (ahmtx:HMTX):APIRET;
                    APIENTRY;             'DOSCALLS' index 333;
FUNCTION DosRequestMutexSem(ahmtx:HMTX;ulTimeout:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 334;
FUNCTION DosReleaseMutexSem(ahmtx:HMTX):APIRET;
                    APIENTRY;             'DOSCALLS' index 335;
FUNCTION DosQueryMutexSem(ahmtx:HMTX;VAR appid:PID;VAR aptid:TID;
                          VAR pulCount:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 336;
FUNCTION DosCreateMuxWaitSem(VAR pszName:CSTRING;VAR aphmux:HMUX;cSemRec:ULONG;
                             VAR pSemRec;flAttr:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 337;
FUNCTION DosOpenMuxWaitSem(VAR pszName:CSTRING;VAR aphmux:HMUX):APIRET;
                    APIENTRY;             'DOSCALLS' index 338;
FUNCTION DosCloseMuxWaitSem(ahmux:HMUX):APIRET;
                    APIENTRY;             'DOSCALLS' index 339;
FUNCTION DosWaitMuxWaitSem(ahmux:HMUX;ulTimeout:ULONG;
                           VAR pulUser:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 340;
FUNCTION DosAddMuxWaitSem(ahmux:HMUX;VAR pSemRec:SEMRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 341;
FUNCTION DosDeleteMuxWaitSem(ahmux:HMUX;ahSem:HSEM):APIRET;
                    APIENTRY;             'DOSCALLS' index 342;
FUNCTION DosQueryMuxWaitSem(ahmux:HMUX;VAR pcSemRec:ULONG;
                            VAR pSemRec:SEMRECORD;
                            VAR pflAttr:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 343;
FUNCTION DosGetDateTime(VAR pdt:DATETIME):APIRET;
                    APIENTRY;             'DOSCALLS' index 230;
FUNCTION DosSetDateTime(VAR pdt:DATETIME):APIRET;
                    APIENTRY;             'DOSCALLS' index 292;
FUNCTION DosAsyncTimer(msec:ULONG;ahsem:HSEM;VAR aphtimer:HTIMER):APIRET;
                    APIENTRY;             'DOSCALLS' index 350;
FUNCTION DosStartTimer(msec:ULONG;ahsem:HSEM;VAR aphtimer:HTIMER):APIRET;
                    APIENTRY;             'DOSCALLS' index 351;
FUNCTION DosStopTimer(ahtimer:HTIMER):APIRET;
                    APIENTRY;             'DOSCALLS' index 290;
FUNCTION DosLoadModule(pszName:CSTRING;cbName:ULONG;pszModname:CSTRING;
                       VAR phmod:HMODULE):APIRET;
                    APIENTRY;             'DOSCALLS' index 318;
FUNCTION DosFreeModule(hmod:HMODULE):APIRET;
                    APIENTRY;             'DOSCALLS' index 322;
FUNCTION DosQueryProcAddr(hmod:HMODULE;ordinal:ULONG;VAR pszName:CSTRING;
                          VAR ppfn:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 321;
FUNCTION DosQueryModuleHandle(VAR pszModname:CSTRING;VAR phmod:HMODULE):APIRET;
                    APIENTRY;             'DOSCALLS' index 319;
FUNCTION DosQueryModuleName(hmod:HMODULE;cbName:ULONG;VAR apch):APIRET;
                    APIENTRY;             'DOSCALLS' index 320;
FUNCTION DosQueryProcType(hmod:HMODULE;ordinal:ULONG;VAR pszName:CSTRING;
                          VAR pulproctype:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 586;
FUNCTION DosGetResource(hmod:HMODULE;idType,idName:ULONG;
                        VAR ppb:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 352;
FUNCTION DosFreeResource(pb:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 353;
FUNCTION DosQueryResourceSize(hmod:HMODULE;idt,idn:ULONG;
                              VAR pulsize:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 572;
FUNCTION DosQueryCtryInfo(cb:ULONG;VAR pcc:COUNTRYCODE;VAR pci:COUNTRYINFO;
                          VAR pcbActual:ULONG):APIRET;
                    APIENTRY;             'NLS' index 5;
FUNCTION DosQueryDBCSEnv(cb:ULONG;VAR pcc:COUNTRYCODE;
                         VAR pBuf):APIRET;
                    APIENTRY;             'NLS' index 6;
FUNCTION DosMapCase(cb:ULONG;VAR pcc:COUNTRYCODE;VAR apch):APIRET;
                    APIENTRY;             'NLS' index 7;
FUNCTION DosQueryCollate(cb:ULONG;VAR pcc:COUNTRYCODE;
                         VAR apch;VAR pcch:ULONG):APIRET;
                    APIENTRY;             'NLS' index 8;
FUNCTION DosQueryCp(cb:ULONG;VAR arCP,pcCP:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 291;
FUNCTION DosSetProcessCp(cp:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 289;
FUNCTION DosSetExceptionHandler(VAR PERegrec:EXCEPTIONREGISTRATIONRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 354;
FUNCTION DosUnsetExceptionHandler(VAR PERegRec:EXCEPTIONREGISTRATIONRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 355;
FUNCTION DosRaiseException(VAR Pexcept:EXCEPTIONREPORTRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 356;
FUNCTION DosSendSignalException(apid:PID;exception:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 379;
FUNCTION DosUnwindException(VAR pHandler:EXCEPTIONREGISTRATIONRECORD;
                            VAR pTargetIP;
                            VAR pERepRec:EXCEPTIONREPORTRECORD):APIRET;
                    APIENTRY;             'DOSCALLS' index 357;
FUNCTION DosSetSignalExceptionFocus(flag:BOOL;VAR pulTimes:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 378;
FUNCTION DosEnterMustComplete(VAR pulNesting:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 380;
FUNCTION DosExitMustComplete(VAR pulNesting:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 381;
FUNCTION DosAcknowledgeSignalException(ulSignalNum:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 418;
FUNCTION DosCreatePipe(VAR phfRead,phfWrite:HFILE;cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 239;
FUNCTION DosCloseQueue(hq:HQUEUE):APIRET;
                    APIENTRY;             'QUECALLS' index 11;
FUNCTION DosCreateQueue(VAR phq:HQUEUE;priority:ULONG;VAR pszName:CSTRING):APIRET;
                    APIENTRY;             'QUECALLS' index 16;
FUNCTION DosOpenQueue(VAR appid:PID;VAR phq:HQUEUE;VAR pszName:CSTRING):APIRET;
                    APIENTRY;             'QUECALLS' index 15;
FUNCTION DosPeekQueue(hq:HQUEUE;VAR pRequest:REQUESTDATA;VAR pcbData:ULONG;
                      VAR ppbuf;VAR element:ULONG;nowait:BOOL;
                      VAR ppriority;hsem:HEV):APIRET;
                    APIENTRY;             'QUECALLS' index 13;
FUNCTION DosPurgeQueue(hq:HQUEUE):APIRET;
                    APIENTRY;             'QUECALLS' index 10;
FUNCTION DosQueryQueue(hq:HQUEUE;VAR pcbEntries:ULONG):APIRET;
                    APIENTRY;             'QUECALLS' index 12;
FUNCTION DosReadQueue(hq:HQUEUE;VAR pRequest:REQUESTDATA;VAR pcbData:ULONG;
                      VAR ppbuf;element:ULONG;wait:BOOL;
                      VAR ppriority;hsem:HEV):APIRET;
                    APIENTRY;             'QUECALLS' index 9;
FUNCTION DosWriteQueue(hq:HQUEUE;request,cbData:ULONG;VAR pbData;
                       priority:ULONG):APIRET;
                    APIENTRY;             'QUECALLS' index 14;
FUNCTION DosErrorAPI(error:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 212;
FUNCTION DosErrClass(code:ULONG;VAR pClass,pAction,pLocus:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 211;
FUNCTION DosInsertMessage(VAR pTable;cTable:ULONG;VAR pszMsg:CSTRING;cbMsg:ULONG;
                          VAR pBuf;cbBuf:ULONG;VAR pcbMsg:ULONG):APIRET;
                    APIENTRY;             'MSG' index 4;
FUNCTION DosPutMessage(ahfile:HFILE;cbMsg:ULONG;VAR pBuf):APIRET;
                    APIENTRY;             'MSG' index 5;
FUNCTION DosQuerySysInfo(iStart,iLast:ULONG;VAR pBuf;cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 348;
FUNCTION DosScanEnv(VAR pszName:CSTRING;VAR ppszValue:PCHAR):APIRET;
                    APIENTRY;             'DOSCALLS' index 227;
FUNCTION DosSearchPath(flag:ULONG;VAR pszPathOrName,pszFilename:CSTRING;
                       VAR pBuf;cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 228;
FUNCTION DosQueryRASInfo(index:ULONG;VAR Addr:POINTER):APIRET;
                    APIENTRY;             'DOSCALLS' index 112;
FUNCTION DosStartSession(VAR psd:STARTDATA;VAR pidSession:ULONG;
                         VAR appid:PID):APIRET;
                    APIENTRY;             'SESMGR' index 37;
FUNCTION DosSetSession(idSession:ULONG;VAR psd:STATUSDATA):APIRET;
                    APIENTRY;             'SESMGR' index 39;
FUNCTION DosSelectSessionAPI(idSession:ULONG):APIRET;
                    APIENTRY;             'SESMGR' index 38;
FUNCTION DosStopSession(scope,idSession:ULONG):APIRET;
                    APIENTRY;             'SESMGR' index 40;
FUNCTION DosQueryAppType(CONST pszName:CSTRING;VAR pFlags:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 323;
FUNCTION DosDevConfig(VAR pdevinfo;item:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 231;
FUNCTION DosDevIOCtl(hDevice:HFILE;category,afunction:ULONG;
                     VAR pParams;cbParmLenMax:ULONG;VAR pcbParmLen:ULONG;
                     VAR pData;cbDataLenMax:ULONG;VAR pcbDataLen:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 284;
FUNCTION DosPhysicalDisk(afunction:ULONG;VAR pBuf;cbBuf:ULONG;
                         VAR pParams;cbParams:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 287;
FUNCTION DosCallNPipe(VAR pszName:CSTRING;VAR pInbuf;cbIn:ULONG;VAR pOutbuf;
                      cbOut:ULONG;VAR pcbActual:ULONG;msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 240;
FUNCTION DosConnectNPipe(ahpipe:HPIPE):APIRET;
                    APIENTRY;             'DOSCALLS' index 241;
FUNCTION DosDisConnectNPipe(ahpipe:HPIPE):APIRET;
                    APIENTRY;             'DOSCALLS' index 242;
FUNCTION DosCreateNPipe(VAR pszName:CSTRING;VAR apHpipe:HPIPE;openmode,pipemode,
                        cbInbuf,cbOutbuf,msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 243;
FUNCTION DosPeekNPipe(ahpipe:HPIPE;VAR pBuf;cbBuf:ULONG;VAR pcbActual:ULONG;
                      VAR pAvail:AVAILDATA;VAR pState:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 244;
FUNCTION DosQueryNPHState(ahpipe:HPIPE;VAR pState:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 245;
FUNCTION DosQueryNPipeInfo(ahpipe:HPIPE;infolevel:ULONG;VAR pBuf;
                           cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 248;
FUNCTION DosQueryNPipeSemState(ahsem:HSEM;VAR pnpss:PIPESEMSTATE;
                               cbBuf:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 249;
FUNCTION DosRawReadNPipe(VAR pszName:CSTRING;cb:ULONG;VAR pLen:ULONG;
                         VAR pBuf):APIRET;
                    APIENTRY;             'DOSCALLS' index 246;
FUNCTION DosRawWriteNPipe(VAR pszName:CSTRING;cb:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 247;
FUNCTION DosSetNPHState(ahpipe:HPIPE;state:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 250;
FUNCTION DosSetNPipeSem(ahpipe:HPIPE;ahsem:HSEM;key:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 251;
FUNCTION DosTransactNPipe(ahpipe:HPIPE;VAR pOutbuf;cbOut:ULONG;
                          VAR pInbuf;cbIn:ULONG;VAR pcbRead:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 252;
FUNCTION DosWaitNPipe(VAR pszName:CSTRING;msec:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 253;
FUNCTION DosTmrQueryFreq(VAR pulTmrFreq:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 362;
FUNCTION DosTmrQueryTime(VAR pqwTmrTime):APIRET;
                    APIENTRY;             'DOSCALLS' index 363;
FUNCTION DosRegisterPerfCtrs(VAR pbDataBlk;VAR pbTextBlk;
                             flFlags:ULONG):APIRET;
                    APIENTRY;             'DOSCALLS' index 367;
FUNCTION DosOpenVDD(VAR pszVDD:CSTRING;VAR aphvdd:HVDD):APIRET;
                    APIENTRY;             'DOSCALLS' index 308;
FUNCTION DosRequestVDD(ahvdd:HVDD;asgid:SGID;cmd,cbInput:ULONG;VAR pInput;
                       cbOutput:ULONG;VAR pOutput):APIRET;
                    APIENTRY;             'DOSCALLS' index 309;
FUNCTION DosCloseVDD(ahvdd:HVDD):APIRET;
                    APIENTRY;             'DOSCALLS' index 310;
FUNCTION DosQueryDOSProperty(asgid:SGID;VAR pszName:CSTRING;cb:ULONG;VAR apch):APIRET;
                    APIENTRY;             'DOSCALLS' index 373;
FUNCTION DosSetDOSProperty(asgid:SGID;VAR pszName:CSTRING;cb:ULONG;pch:CSTRING):APIRET;
                    APIENTRY;             'DOSCALLS' index 374;

END; {IMPORTS}


{OS/2 API errors ??}

{exception instance is deleted if pBuf crosses 64K boundary}
FUNCTION DosQueryCurrentDir(disknum:LONGWORD;VAR pBuf;
                            VAR pcbBuf:LONGWORD):LONGWORD;

{ds and es are zeroed under some circumstances}
FUNCTION DosSelectSession(idSession:ULONG):APIRET;

{additional parameter required in redirected function}
FUNCTION DosQueryMessageCP(VAR pb;cb:ULONG;VAR pszFilename:CSTRING;
                           VAR cbBuf:ULONG):APIRET;

{additional parameter required in redirected function}
FUNCTION DosGetMessage(VAR pTable;cTable:ULONG; VAR pBuf;cbBuf,msgnumber:ULONG;
                       CONST pszFile:CSTRING;VAR pcbMsg:ULONG):APIRET;


IMPLEMENTATION


FUNCTION DosQueryCurrentDir(disknum:LONGWORD;VAR pBuf;
                            VAR pcbBuf:LONGWORD):LONGWORD;
BEGIN
     //a bug in OS/2 ??
     //exception instance is deleted if pBuf crosses 64K boundary
     ASM
        XOR EAX,EAX
        DB $64,$FF,$30  //PUSHD FS:[EAX]
     END;
     Result := DosQueryCurrentDirAPI(disknum,pBuf,pcbBuf);
     ASM
        XOR EAX,EAX
        DB $64,$8F,$00  //POPD FS:[EAX]
     END;
END;


FUNCTION DosSelectSession(idSession:ULONG):APIRET;
BEGIN
     //a bug in OS/2 ???
     //DS and ES are sometimes set to 0 selectors !
     ASM
        DB $1E,06   //PUSH DS PUSH ES
     END;
     Result := DosSelectSessionAPI(idSession);
     ASM
        DB 07,$1F   //POP ES POP DS
     END;
END;




IMPORTS

FUNCTION DosIQueryMessageCP(VAR pb;cb:ULONG;VAR pszFilename:CSTRING;
                            VAR cbBuf:ULONG;Signature:POINTER):APIRET;
                    APIENTRY;             'MSG' index 8;
FUNCTION DosTrueGetMessage(Signature:POINTER;VAR pTable;cTable:ULONG;
                           VAR pBuf;cbBuf,msgnumber:ULONG;
                           CONST pszFile:CSTRING;VAR pcbMsg:ULONG):APIRET;
                    APIENTRY;             'MSG' index 6;

END; {IMPORTS}

VAR
    MagicHeaderAddress:POINTER;
    MagicEndAddress:POINTER;

{start of _MSGSEG32 segment}
ASSEMBLER
BseDos.!MagicHeaderStart PROC NEAR32
   DB $0FF
   DB $4D,$53,$47,$53,$45,$47,$33,$32, 0       //'MSGSEG32'
   DD $8001
   DD @BseDos.!MAGICHEADEREND
BseDos.!MagicHeaderStart ENDP
END;

FUNCTION DosGetMessage(VAR pTable;cTable:ULONG; VAR pBuf;cbBuf,msgnumber:ULONG;
                       CONST pszFile:CSTRING;VAR pcbMsg:ULONG):APIRET;
BEGIN
     Result := DosTrueGetMessage(MagicHeaderAddress,pTable,cTable,
                                 pBuf,cbBuf,msgnumber,pszFile,pcbMsg);
END;


FUNCTION DosQueryMessageCP(VAR pb;cb:ULONG;VAR pszFilename:CSTRING;
                           VAR cbBuf:ULONG):APIRET;
BEGIN
     Result := DosIQueryMessageCP(pb,cb,pszFileName,cbBuf,MagicEndAddress);
END;

ASSEMBLER
BseDos.!MagicHeaderEnd PROC NEAR32
   DD $0FFFF0000
BseDos.!MagicHeaderEnd ENDP
END;

BEGIN
     ASM
        MOV EAX,@BseDos.!MagicHeaderStart
        MOV BseDos.MagicHeaderAddress,EAX
        MOV EAX,@BseDos.!MagicHeaderEnd
        MOV BseDos.MagicEndAddress,EAX
     END;
END.
