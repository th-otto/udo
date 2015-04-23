UNIT SQL;

{*************************************************************************
 *                                                                       *
 * Module Name    = SQL.H                                                *
 *                                                                       *
 * Descriptive Name = External Include file for Database Manager         *
 *                                                                       *
 * Copyright = 5622-044 (C) Copyright IBM Corp. 1988, 1993               *
 *             Licensed Material - Program Property of IBM               *
 *             Refer to Copyright Instructions Form Number G120-3083     *
 *                                                                       *
 * Function = Include File defining                                      *
 *              System Constants                                         *
 *              SQLCA/SQLDA Constants                                    *
 *              Dynamic Link Interface to BINDER                         *
 *              Error Message Retrieval Interface                        *
 *              Authorization Constants                                  *
 *                                                                       *
 *************************************************************************}

INTERFACE

USES OS2Def;

TYPE
 /* SQL Communication Area - SQLCA */
 PSQLCA=^TSQLCA;
 TSQLCA=RECORD
            sqlcaid: ARRAY[0..7] OF BYTE;  /* Eyecatcher = 'SQLCA   ' */
            sqlcabc:LONG;                  /* SQLCA size in bytes = 136 */
            sqlcode:LONG;                  /* SQL return code */
            sqlerrml:SHORT;                /* Length for SQLERRMC */
            sqlerrmc: ARRAY[0..69] OF BYTE; /* Error message tokens */
            sqlerrp:ARRAY[0..7] OF BYTE;   /* Diagnostic information */
            sqlerrd:ARRAY[0..5] OF LONG;   /* Diagnostic information */
            sqlwarn:ARRAY[0..10] OF BYTE;  /* Warning flags */
            sqlstate:ARRAY[0..4] OF BYTE;  /* State corresponding to SQLCODE */
        END;

VAR
   sqlca:TSQLCA;

VAR
   SQLCODE   :LONG ABSOLUTE sqlca.sqlcode;
   SQLWARN0  :BYTE ABSOLUTE sqlca.sqlwarn[0];
   SQLWARN1  :BYTE ABSOLUTE sqlca.sqlwarn[1];
   SQLWARN2  :BYTE ABSOLUTE sqlca.sqlwarn[2];
   SQLWARN3  :BYTE ABSOLUTE sqlca.sqlwarn[3];
   SQLWARN4  :BYTE ABSOLUTE sqlca.sqlwarn[4];
   SQLWARN5  :BYTE ABSOLUTE sqlca.sqlwarn[5];
   SQLWARN6  :BYTE ABSOLUTE sqlca.sqlwarn[6];
   SQLWARN7  :BYTE ABSOLUTE sqlca.sqlwarn[7];
   SQLWARN8  :BYTE ABSOLUTE sqlca.sqlwarn[8];
   SQLWARN9  :BYTE ABSOLUTE sqlca.sqlwarn[9];
   SQLWARNA  :BYTE ABSOLUTE sqlca.sqlwarn[10];

CONST
          /* System Constants */

          SQL_KEYPMAX       =     16 ;  /* Maximum nbr of key parts in Index */
          SQL_KEYLMAX       =    255 ;  /* Maximum key length                */
          SQL_SORTFLDLMT    =    254 ;  /* Maximum size of field for sort    */
          SQL_MAXRECL       =   4005 ;  /* Maximum record length             */
          SQL_MAXTABLES     =     15 ;  /* Maximum nbr of tables in a SELECT */
          SQL_MAXSEL_ITEMS  =    255 ;  /* Maximum nbr of items in a SELECT  */
          SQL_MAXVARS       =    880 ;  /* Maximum nbr of unique Host Vars   */
          SQL_MAXVARS_STMT  =   1489 ;  /* Maximum nbr of Host Vars per stmt */
          SQL_MAXSTMTS      =    400 ;  /* Maximum nbr of Sections in a Plan */
          SQL_MAXCOLS       =    255 ;  /* Maximum nbr of columns in a table */
          SQL_MAX_STMT_SIZ  =  32765 ;  /* Maximum statement size            */

          SQL_SMALL_LENGTH  =      2 ;  /* Size of a SMALLINT                */
          SQL_MAXSMALLVAL   =  32767 ;  /* Maximum value of a SMALLINT       */
          SQL_MINSMALLVAL   = -32768 ;  /* Minimum value of a SMALLINT       */
          SQL_INT_LENGTH    =      4 ;  /* Size of an INTEGER                */
          SQL_MAXINTVAL = maxint     ;  /* Maximum value of an INTEGER       */
          SQL_MININTVAL = minint     ;  /* Minimum value of an INTEGER       */
          SQL_FLOAT_LENGTH    =    8 ;  /* Size of a FLOAT                   */
          SQL_DEFDEC_PRECISION=    5 ;  /* Default precision for DECIMAL     */
          SQL_DEFDEC_SCALE  =      0 ;  /* Default scale for DECIMAL         */
          SQL_MAXDECIMAL    =     31 ;  /* Maximum scale/prec. for DECIMAL   */
          SQL_DEFCHAR       =      1 ;  /* Default length for a CHAR         */
          SQL_MAXCHAR       =    254 ;  /* Maximum length of a CHAR          */
          SQL_MAXLSTR       =    255 ;  /* Maximum length of an LSTRING      */
          SQL_MAXVCHAR=(SQL_MAXRECL-5); /* Maximum length of a VARCHAR       */
          SQL_MAXVGRAPH     =   2000 ;  /* Maximum length of a VARGRAPHIC    */
          SQL_VCHAROH       =      4 ;  /* Overhead for VARCHAR in record    */
          SQL_LONGMAX       =  32700 ;  /* Maximum length of a LONG VARCHAR  */
          SQL_LONGGRMAX     =  16350 ;  /* Max. length of a LONG VARGRAPHIC  */
          SQL_LVCHAROH      =     24 ;  /* Overhead for LONG VARCHAR in rec. */
          SQL_TIME_LENGTH   =      3 ;  /* Size of a TIME field              */
          SQL_TIME_STRLEN   =      8 ;  /* Size of a TIME field output       */
          SQL_TIME_MINSTRLEN=      5 ;  /* Size of a non-USA TIME field output
                                          without seconds                   */
          SQL_DATE_LENGTH   =      4 ;  /* Size of a DATE field              */
          SQL_DATE_STRLEN   =     10 ;  /* Size of a DATE field output       */
          SQL_STAMP_LENGTH  =     10 ;  /* Size of a TIMESTAMP field         */
          SQL_STAMP_STRLEN  =     26 ;  /* Size of a TIMESTAMP field output  */
          SQL_STAMP_MINSTRLEN=    19 ;  /* Size of a TIMESTAMP field output
                                           without microseconds              */
          SQL_IND_LENGTH    =      2 ;  /* Size of a indicator value         */

          SQL_LG_IDENT      =     18 ;  /* Maximum length of Long Identifer  */
          SQL_SH_IDENT      =      8 ;  /* Maximum length of Short Identifer */
          SQL_MN_IDENT      =      1 ;  /* Minimum length of Identifiers     */
          SQL_MAX_VAR_NAME  =     30 ;  /* Max size of Host Variable Name    */



          /* Codepages */
          SQL_CP_437        =    437 ;  /* Codepage 437 - US, Europe         */
          SQL_CP_813        =    813 ;  /* Codepage 813 - AIX Greece         */
          SQL_CP_819        =    819 ;  /* Codepage 819 - ISO 8859-1         */
          SQL_CP_850        =    850 ;  /* Codepage 850 - International PC   */
          SQL_CP_852        =    852 ;  /* Codepage 852 - OS2 Latin2         */
          SQL_CP_857        =    857 ;  /* Codepage 857 - OS2 Turkey         */
          SQL_CP_860        =    860 ;  /* Codepage 860 - Portuguese         */
          SQL_CP_862        =    862 ;  /* Codepage 860 - OS2 Hebrew         */
          SQL_CP_863        =    863 ;  /* Codepage 863 - Canadian-French    */
          SQL_CP_864        =    864 ;  /* Codepage 863 - OS2 Arabic         */
          SQL_CP_865        =    865 ;  /* Codepage 865 - Norway, Denmark    */
          SQL_CP_869        =    869 ;  /* Codepage 869 - OS2 Greece         */
          SQL_CP_891        =    891 ;  /* Codepage 891 - Korean             */
          SQL_CP_897        =    897 ;  /* Codepage 897 - Japanese           */
          SQL_CP_903        =    903 ;  /* Codepage 903 - Chinese            */
          SQL_CP_904        =    904 ;  /* Codepage 904 - Taiwan             */
          SQL_CP_912        =    912 ;  /* Codepage 912 - AIX Latin2         */
          SQL_CP_916        =    916 ;  /* Codepage 916 - AIX Hebrew         */
          SQL_CP_920        =    920 ;  /* Codepage 920 - AIX Turkey         */
          SQL_CP_1040       =   1040 ;  /* Codepage 1040 - Extended Korean   */
          SQL_CP_1041       =   1041 ;  /* Codepage 1041 - Extended Japanese */
          SQL_CP_1042       =   1042 ;  /* Codepage 1042 - Extended Chinese  */
          SQL_CP_1043       =   1043 ;  /* Codepage 1043 - Extended Taiwan   */
          SQL_CP_1046       =   1046 ;  /* Codepage 1046 - AIX Arabic        */
          SQL_CP_1088       =   1088 ;  /* Codepage 1088 - Korea Std         */
          SQL_CP_1089       =   1089 ;  /* Codepage1089 - AIX Arabic         */

          /* DBCS Codepages */
          SQL_CP_926        =    926 ;  /* Codepage 926 - Korean             */
          SQL_CP_951        =    951 ;  /* Codepage 951 - New Korean         */
          SQL_CP_301        =    301 ;  /* Codepage 301 - Japanese           */
          SQL_CP_928        =    928 ;  /* Codepage 928 - Chinese            */
          SQL_CP_927        =    927 ;  /* Codepage 927 - Taiwan             */

          /* Combined Codepages */
          SQL_CP_934        =    934 ;  /* Codepage 891 + 926 - Korean       */
          SQL_CP_949        =    949 ;  /* CP 1088 + 951 - Korean Std        */
          SQL_CP_932        =    932 ;  /* Codepage 897 + 301 - Japanese     */
          SQL_CP_936        =    936 ;  /* Codepage 903 + 928 - Chinese      */
          SQL_CP_938        =    938 ;  /* Codepage 904 + 927 - Taiwan       */
          SQL_CP_944        =    944 ;  /* Codepage 1040 + 926 - Ext.Korean  */
          SQL_CP_942        =    942 ;  /* Codepage 1041 + 301 - Ext.Japanese*/
          SQL_CP_946        =    946 ;  /* Codepage 1042 + 928 - Ext.Chinese */
          SQL_CP_948        =    948 ;  /* Codepage 1043 + 927 - Ext.Taiwan  */

/* Datastream Types */
          SQL_JPN_PC        =    1;/* Japanese-PC                          */
          SQL_CHN_PC        =    2;/* Chinese-PC                           */
          SQL_KOR_PC        =    3;/* Korean-PC                            */
          SQL_KSC_PC        =    4;/* New Korean-PC                        */
          SQL_SBC_PC        =    0;/* Single byte PC                       */
          SQL_UNKN_PC       =  255;/* Unknown                              */

          /* SQLCA Constants */

          SQL_RC_INVALID_SQLCA = -1;     /* Invalid SQLCA address */

          /* Size of SQLCA */
          SQLCA_SIZE   =  sizeof(sqlca);

          /* SQL Error message token delimiter */
          SQL_ERRMC_PRES =$FF;           /* delimiter for string entry */

          /* Offset in SQLERRD - Diagnostic information */
          SQL_ERRD_RC   =0 ;            /* return code */
          SQL_ERRD_REAS =1 ;            /* reason code */
          SQL_ERRD_CNT  =2 ;            /* nbr rows inserted/updated/deleted */
          SQL_ERRD_OPTM =3 ;            /* optimizer information */
          SQL_ERRD_DCNT =4 ;            /* nbr of cascaded deletes/updates */
          SQL_ERRD_LINE =4 ;            /* line number for recompile error */
          SQL_ERRD_DIAG =5 ;            /* diagnostics */

          /* Indexes in SQLWARN - Warning flags */
          SQL_WARN_ANY  =0;             /* composite - set if any warnings */
          SQL_WARN_TRUNC=1;             /* string column truncated */
          SQL_WARN_NUL  =2;             /* null values eliminated */
          SQL_WARN_MISM =3;             /* nbr of columns/host vars mismatch */
          SQL_WARN_ALLR =4;             /* no WHERE clause in update/delete */
          SQL_WARN_DATE =6;             /* date has been truncated */

          /* Values for Warning flags in SQLWARN */
          SQL_WARNING   ='W';           /* warning indicator */
          SQL_NULL_TRN  ='N';           /* null terminator truncated warning */
          SQL_NO_WARN   =' ';           /* no warning indicator */



          /* SQLDA Constants */

          /* increment for type with null indicator */
          SQL_TYP_NULINC     =  1 ;

          /* Variable Types */
          SQL_TYP_DATE      = 384 ;     /* DATE */
          SQL_TYP_NDATE     = (SQL_TYP_DATE+SQL_TYP_NULINC);

          SQL_TYP_TIME      = 388 ;     /* TIME */
          SQL_TYP_NTIME     = (SQL_TYP_TIME+SQL_TYP_NULINC);

          SQL_TYP_STAMP     = 392 ;     /* TIMESTAMP */
          SQL_TYP_NSTAMP    = (SQL_TYP_STAMP+SQL_TYP_NULINC);

          SQL_TYP_VARCHAR   = 448 ;     /* VARCHAR(i) - varying length string
                                                        (2 byte length) */
          SQL_TYP_NVARCHAR  = (SQL_TYP_VARCHAR+SQL_TYP_NULINC);

          SQL_TYP_CHAR      = 452 ;     /* CHAR(i) - fixed length string */
          SQL_TYP_NCHAR     = (SQL_TYP_CHAR+SQL_TYP_NULINC);

          SQL_TYP_LONG      = 456 ;     /* LONG VARCHAR - varying length
                                                          string */
          SQL_TYP_NLONG     = (SQL_TYP_LONG+SQL_TYP_NULINC);

          SQL_TYP_CSTR      = 460 ;     /* varying length string for C
                                            (null terminated) */
          SQL_TYP_NCSTR     = (SQL_TYP_CSTR+SQL_TYP_NULINC);

          SQL_TYP_VARGRAPH  = 464 ;     /* VARGRAPHIC(i) - varying length
                                           graphic string (2 byte length) */
          SQL_TYP_NVARGRAPH = (SQL_TYP_VARGRAPH+SQL_TYP_NULINC);

          SQL_TYP_GRAPHIC   = 468 ;     /* GRAPHIC(i) - fixed length graphic
                                           string */
          SQL_TYP_NGRAPHIC  = (SQL_TYP_GRAPHIC+SQL_TYP_NULINC);

          SQL_TYP_LONGRAPH  = 472 ;     /* LONG VARGRAPHIC(i) - varying length
                                           graphic string */
          SQL_TYP_NLONGRAPH = (SQL_TYP_LONGRAPH+SQL_TYP_NULINC);

          SQL_TYP_LSTR      = 476 ;     /* varying length string for Pascal
                                            (1-byte length) */
          SQL_TYP_NLSTR     = (SQL_TYP_LSTR+SQL_TYP_NULINC);

          SQL_TYP_FLOAT     = 480 ;     /* FLOAT - 8-byte floating point   */
          SQL_TYP_NFLOAT    = (SQL_TYP_FLOAT+SQL_TYP_NULINC);

          SQL_TYP_DECIMAL   = 484 ;    /* DECIMAL (m,n)                    */
          SQL_TYP_NDECIMAL  = (SQL_TYP_DECIMAL+SQL_TYP_NULINC);

          SQL_TYP_ZONED     = 488 ;     /* Zoned Decimal -> DECIMAL (m,n)  */
          SQL_TYP_NZONED    = (SQL_TYP_ZONED+SQL_TYP_NULINC);       /* &01 */

          SQL_TYP_INTEGER   = 496 ;     /* INTEGER - 4-byte signed integer */
          SQL_TYP_NINTEGER  = (SQL_TYP_INTEGER+SQL_TYP_NULINC);

          SQL_TYP_SMALL     = 500 ;     /* SMALLINT - 2-byte signed integer*/
          SQL_TYP_NSMALL    = (SQL_TYP_SMALL+SQL_TYP_NULINC);

          SQL_TYP_NUMERIC   = 504 ;     /* NUMERIC -> DECIMAL (m,n)    &01 */
          SQL_TYP_NNUMERIC  = (SQL_TYP_NUMERIC+SQL_TYP_NULINC);     /* &01 */



          /* Return Codes for sqlabind and sqlabndr */

          SQLA_RC_BINDERROR    = -1 ;   /* Bind execution failed */
          SQLA_RC_BAD_BINDNAME = -2 ;   /* Invalid bind file */
          SQLA_RC_BAD_DBNAME   = -3 ;   /* Invalid database */
          SQLA_RC_BAD_PASSWD   = -4 ;   /* Invalid password
                                           (not used after Release 2) */
          SQLA_RC_BAD_MSGNAME  = -5 ;   /* Invalid message file */
          SQLA_RC_BAD_FORMAT   = -6 ;   /* Invalid format */
          SQLA_RC_OPEN_ERROR   = -31;   /* Error opening list file */
          SQLA_RC_BAD_BNDFILE  = -39;   /* Bind file corrupted */
          SQLA_RC_LIST_ERROR   = -40;   /* Bind list errors */
          SQLA_RC_INTERRUPT    = -94;   /* Interrupt */

          /* Additional return Codes for sqlabndr only */
          SQLA_RC_OPTION_LEN_BAD =-4903;/* Option array length is invalid */
          SQLA_RC_OPTION_PTR_BAD =-4904;/* Option array ptr is invalid    */
          SQLA_RC_OPTION_SIZE_BAD=-4905;/* Option array size is invalid   */
          SQLA_RC_OPTION_DATA_BAD=-4917;/* Option array data is invalid   */

          /* Values used for the date/time format parameter of sqlabind */
          SQL_FMT_DEF       =  'DEF' ;  /* FORMAT = Default for Country Code */
          SQL_FMT_USA       =  'USA' ;  /* FORMAT = USA   */
          SQL_FMT_EUR       =  'EUR' ;  /* FORMAT = EUR   */
          SQL_FMT_ISO       =  'ISO' ;  /* FORMAT = ISO   */
          SQL_FMT_JIS       =  'JIS' ;  /* FORMAT = JIS   */
          SQL_FMT_LOC       =  'LOC' ;  /* FORMAT = LOCAL */


TYPE
   /* Structures used system wide                                             */
   PSQLCHAR=^TSQLCHAR;
   TSQLCHAR=RECORD
                length:SHORT;
                data:BYTE;
           END;

VAR
   sqlchar:TSQLCHAR;

TYPE
   /* Structure used to store binder options when calling sqlabndr            */
   PSQLOPT=^TSQLOPT;
   TSQLOPT=RECORD
               header:RECORD               /* Header for sqlopt structur */
                          allocated:ULONG; /* Number of options allocated */
                          used:ULONG;      /* Number of options used */
                      END;
               option:RECORD
                          atype:ULONG;     /* Type of bind option */
                          val:ULONG;       /* Value of bind option */
                      END;
          END;

VAR
    sqlopt:TSQLOPT;

CONST
     /* Values used for option[n].type in the sqlopt structure of sqlabndr */
     SQL_FRMT_OPT          = 1 ;   /* Option for date/time format */
     SQL_ISO_OPT           = 4 ;   /* Option for isolation level */
     SQL_BLOCK_OPT         = 5 ;   /* Option for record blocking */
     SQL_GRANT_OPT         = 6 ;   /* Option for granting privileges */

     /* Values used for option[n].val when option[n].type is SQL_FRMT_OPT */
     /* These can be also be used for the date/time format parameter of sqlabind */
     SQL_FMT_0             ='0';   /* FORMAT = Default for Country Code */
     SQL_FMT_1             ='1';   /* FORMAT = USA   */
     SQL_FMT_2             ='2';   /* FORMAT = EUR   */
     SQL_FMT_3             ='3';   /* FORMAT = ISO   */
     SQL_FMT_4             ='4';   /* FORMAT = JIS   */
     SQL_FMT_5             ='5';   /* FORMAT = LOCAL */

     /* Values used for option[n].val when option[n].type is SQL_ISO_OPT */
     SQL_REP_READ          = 0 ;   /* Repeatable read level  */
     SQL_CURSOR_STAB       = 1 ;   /* Cursor stability level */
     SQL_UNCOM_READ        = 2 ;   /* Uncommitted read level */

     /* Values used for option[n].val when option[n].type is SQL_BLOCK_OPT */
     SQL_BL_UNAMBIG        = 0 ;   /* Block Unambiguous cursors */
     SQL_BL_ALL            = 1 ;   /* Block All cursors */
     SQL_NO_BL             = 2 ;   /* Block No cursors */


     /* Return Codes for sqlaintp */
     SQLA_ERR_BADCC        =-1 ;   /* insufficient memory for msg file */
     SQLA_ERR_NOCOD        =-2 ;   /* no error code in SQLCA */
     SQLA_ERR_NOMSG        =-3 ;   /* requested message not found */
     SQLA_ERR_BADLL        =-4 ;   /* specified line length negative */
     SQLA_ERR_BADCA        =-5 ;   /* invalid sqlca/buffer addr/length */



     /* Administrative/Database Authorizations returned from Get Administrative
        Authorizations function */

     /* Authorizations granted explicitly to user */
     SQL_SYSADM          =$0001 ;  /* SYSADM Authority    */
     SQL_DBADM           =$0002 ;  /* DBADM Authority     */
     SQL_CREATETAB       =$0004 ;  /* CREATETAB Privilege */
     SQL_BINDADD         =$0008 ;  /* BINDADD Privilege   */
     SQL_CONNECT         =$0010 ;  /* CONNECT Privilege   */

     /* Composite of authorizations granted explicitly to user,
        to groups of which user is a member, and to PUBLIC */
     SQL_SYSADM_GRP     =(SQL_SYSADM SHL 8);
     SQL_DBADM_GRP      =(SQL_DBADM SHL 8);
     SQL_CREATETAB_GRP  =(SQL_CREATETAB SHL 8);
     SQL_BINDADD_GRP    =(SQL_BINDADD SHL 8);
     SQL_CONNECT_GRP    =(SQL_CONNECT SHL 8);

     /* Table/View Authorizations/Dependencies Bit definitions
        in SYSTABAUTH.TABAUTH and SYSPLANDEP.TABAUTH */
     SQL_TAB_CTL         =$0001 ;  /* Control Authority           */
     SQL_TAB_ALT         =$0002 ;  /* Alter Privilege             */
     SQL_TAB_DEL         =$0004 ;  /* Delete Privilege/Dependency */
     SQL_TAB_IDX         =$0008 ;  /* Index Privilege             */
     SQL_TAB_INS         =$0010 ;  /* Insert Privilege/Dependency */
     SQL_TAB_SEL         =$0020 ;  /* Select Privilege/Dependency */
     SQL_TAB_UPD         =$0040 ;  /* Update Privilege/Dependency */
     SQL_TAB_REF         =$0080 ;  /* Reference Privilege         */
     SQL_TAB_KEY         =$2000 ;  /* Key Dependency              */
     SQL_TAB_CAS         =$4000 ;  /* Cascade Dependency          */

     /* Definitions for application remote interface */
     SQLZ_DISCONNECT_PROC = 1;       /* Unload Progam                */
     SQLZ_HOLD_PROC       = 2;       /* Keep program loaded          */


IMPORTS
       /* Binder Interface Parameters/Return Codes */
       FUNCTION sqlabind (name:CSTRING;               /* program name */
                          database:CSTRING;           /* database */
                          spare:CSTRING;              /* spare */
                          msgfile:CSTRING;            /* message file */
                          datetimefmt:CSTRING;        /* date/time format */
                          VAR asqlca:TSQLCA):INTEGER; /* SQLCA */
                    APIENTRY; 'SQLA32' name 'sqlabind';
       FUNCTION sqlabndr (name:CSTRING;               /* program name */
                          database:CSTRING;           /* database     */
                          msgfile:CSTRING;            /* message file */
                          VAR asqlopt:TSQLOPT;        /* binder options */
                          VAR asqlca:TSQLCA):INTEGER; /* SQLCA */
                    APIENTRY; 'SQLA32' name 'sqlabndr';

       /* Generic Dynamic Link Interface to the Binder */
       FUNCTION SQLGBIND (spare1:LONGWORD;            /* spare1 */
                          msgfilelen:LONGWORD;        /* Message file length */
                          fmtoptlen:LONGWORD;         /* Format option length */
                          PlanNameLen:LONGWORD;       /* Plan name length */
                          DataBaseNameLen:LONGWORD;   /* Database name length */
                          VAR asqlca:TSQLCA;          /* SQLCA */
                          spare2:CSTRING;             /* spare2 */
                          msgfile:CSTRING;            /* Message file */
                          DateTimeFmt:CSTRING;        /* Date/time format */
                          ProgName:CSTRING;           /* Program name */
                          DataBase:CSTRING):INTEGER;  /* Database */
                     APIENTRY; 'SQLAPI32' name 'SQLGBIND';
       FUNCTION SQLGBNDR (PlanNameLen:LONGWORD;       /* Plan name length */
                          DataBaseNameLen:LONGWORD;   /* Database name length */
                          MsgFileLen:LONGWORD;        /* Message file length */
                          ProgName:CSTRING;           /* program name */
                          DataBase:CSTRING;           /* database */
                          MsgFile:CSTRING;            /* message file */
                          VAR asqlopt :TSQLOPT;       /* binder options */
                          VAR asqlca : TSQLCA):INTEGER; /* SQLCA */
                     APIENTRY; 'SQLAPI32' name 'SQLGBNDR';

       /* Error Message Retrieval Interface Parameters/Return Codes */

       /* Error Message Retrieval Macro */
       {sqlaintp(msgbuf,bufsize,linesize,sqlcaptr) \
       sqlaintp_api(msgbuf,bufsize,linesize, \
                    (char *)"sqlzk001.mo",sqlcaptr)}
       FUNCTION sqlaintp_api (VAR buffer;         /* buffer for message text */
                              BufSize:LONGWORD;   /* buffer size */
                              linewidth:LONGWORD; /* line width */
                              msgfile:CSTRING;    /* message file */
                              VAR asqlca:TSQLCA):INTEGER; /* SQLCA */
                     APIENTRY; 'SQLA32' name 'sqlaintp_api';

       /* Generic Dynamic Link Interface to Error Message Retrieval */
       FUNCTION SQLGINTP (bufsize:LONGWORD;     /* buffer size */
                          linewidth:LONGWORD;   /* line width */
                          VAR asqlca :TSQLCA;   /* SQLCA */
                          VAR buffer):INTEGER;  /* buffer */
                    APIENTRY; 'SQLAPI32' name 'SQLGINTP';
END;

IMPLEMENTATION

END.
