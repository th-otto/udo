UNIT SQLAPREP;

{***************************************************************************
                                                                           *
  Module Name    = SQLAPREP.H                                              *
                                                                           *
  Descriptive Name = External Include file for Precompiler Services        *
                                                                           *
  Copyright = 5622-044 (C) Copyright IBM Corp. 1988, 1993                  *
              Licensed Material - Program Property of IBM                  *
              Refer to Copyright Instructions Form Number G120-3083        *
                                                                           *
  Function = Include File defining                                         *
               Global equates and structures                               *
               Precompiler and Runtime Command Interfaces                  *
                                                                           *
****************************************************************************}

INTERFACE

USES sql,sqlcodes,Os2Def;


TYPE
   /* SQLDA: SQL Descriptor Area - Variable descriptor                        */
   PSQLDA=^TSQLDA;
   TSQLDA=RECORD
               sqldaid:CSTRING[7];         /* Eye catcher = 'SQLDA   '        */
               sqldabc:LONG;               /* SQLDA size in bytes=16+44*SQLN  */
               sqln:SHORT;                 /* Number of SQLVAR elements       */
               sqld:SHORT;                 /* # of used SQLVAR elements       */
               sqlvar:RECORD                /* Variable Description            */
                        sqltype:SHORT;           /* Variable data type              */
                        sqllen:SHORT;            /* Variable data length            */
                        sqldata:POINTER; /* Pointer to variable data value*/
                        sqlind:POINTER;  /* Pointer to Null indicator     */
                        sqlname:RECORD            /* Variable Name                   */
                                   alength:SHORT;         /* Name length [1..30]             */
                                   data:CSTRING[29];       /* Variable or Column name         */
                                END;
                     END;
         END;

/* macro for allocating SQLDA */
{  SQLDASIZE(n) (sizeof(struct sqlda) + (n-1)*sizeof(struct sqlvar))}


/*
** Macro used to calculate size of a precompiler option array, an input
** parameter of SQLAINIT.
*/

{        SQLA_NUM_OPTIONS(n) (sizeof(struct sqla_options_header) + \
                             (n)*sizeof(struct sqla_option)        )}

CONST
     /*
      ** Values used for option[n].type, an input parameter of SQLAINIT.
      */

        SQLA_FORMAT        = SQL_FRMT_OPT ;/* Option: date/time format     */
        SQLA_ACCESS_PLAN   = 2            ;/* Option: access plan creation */
        SQLA_BIND_FILE     = 3            ;/* Option: bind file creation   */
        SQLA_ISOLATION     = SQL_ISO_OPT  ;/* Option: isolation level      */
        SQLA_BLOCK         = SQL_BLOCK_OPT;/* Option: record blocking      */
        SQLA_STDS_LEVEL    = 7            ;/* Option: standards compliance */

      /*
       ** Values used for option[n].val when option[n].type is SQLA_FORMAT in
       ** the Precompiler Option Array.
      */

        SQLA_POA_DEF       = 0;/* Default date/time format */
        SQLA_POA_USA       = 1;/* USA date/time format */
        SQLA_POA_EUR       = 2;/* European date/time format */
        SQLA_POA_ISO       = 3;/* International date/time format */
        SQLA_POA_JIS       = 4;/* Japanese date/time format */
        SQLA_POA_LOC       = 5;/* Local date/time format */

      /*
       ** Values used for option[n].val when option[n].type is SQLA_ACCESS_PLAN in
       ** the Precompiler Option Array.
      */

        SQLA_CREATE_PLAN   = 1;/* Create an access plan */
        SQLA_NO_PLAN       = 0;/* Do not create an access plan */

      /*
       ** Values used for option[n].val when option[n].type is SQLA_BIND_FILE in
       ** the Precompiler Option Array.
      */

        SQLA_CREATE_BIND_FILE=1;/* Create a bind file */
        SQLA_NO_BIND_FILE    =0;/* Do not create a bind file */

      /*
       ** Values used for option[n].val when option[n].type is SQLA_ISOLATION in
       ** the Precompiler Option Array.
      */

        SQLA_REPEATABLE_READ =SQL_REP_READ   ;/* RR isolation level */
        SQLA_CURSOR_STABILITY=SQL_CURSOR_STAB;/* CS Isolation level */
        SQLA_UNCOMMITTED_READ=SQL_UNCOM_READ ;/* UR Isolation level */

      /*
       ** Values used for option[n].val when option[n].type is SQLA_BLOCK in
       ** the Precompiler Option Array.
      */

        SQLA_BLOCK_UNAMBIG  = SQL_BL_UNAMBIG;
        SQLA_BLOCK_ALL      = SQL_BL_ALL;
        SQLA_NO_BLOCK       = SQL_NO_BL;

      /*
       ** Values used for option[n].val when option[n].type is SQLA_STDS_LEVEL in
       ** the Precompiler Option Array.
      */

        SQLA_STND_NONE     = 0;/* No compliance required   */
        SQLA_STND_MIA      = 1;/* Comply with MIA standard */

      /*
       ** Values used for location, an input parameter of SQLAAHVR.
      */

        SQLA_DECLARE_SECT  = 0;/* Add host var found in a declare section */
        SQLA_SQL_STMT      = 1;/* Add host var found in an SQL statement  */

      /*
       ** Values assigned to task[n].func, an output parameter of SQLACMPL.
      */

        SQLA_START         = 0;/* Generate a call to sqlastrt */
        SQLA_DECLARE       = 1;/* Begin or end parsing hvar declarations */
        SQLA_INCLUDE       = 2;/* Generate code for an SQLCA or SQLDA */
        SQLA_ALLOC_INPUT   = 3;/* Allocate an input SQLDA using SQLAALOC */
        SQLA_ALLOC_OUTPUT  = 4;/* Allocate an output SQLDA using SQLAALOC */
        SQLA_SETS          = 5;/* Register a host variable using SQLASETS */
        SQLA_USDA_INPUT    = 6;/* Register an input user-defined SQLDA */
        SQLA_USDA_OUTPUT   = 7;/* Register an output user-defined SQLDA */
        SQLA_CALL          = 8;/* Generate a call to SQLACALL */
        SQLA_DEALLOC       = 9;/* Generate a call to SQLADLOC */
        SQLA_STOP          =10;/* Generate a call to SQLASTOP */
        SQLA_SQLERROR      =11;/* Generate code for WHENEVER SQLERROR */
        SQLA_SQLWARNING    =12;/* Generate code for WHENEVER SQLWARNING */
        SQLA_NOT_FOUND     =13;/* Generate code for WHENEVER NOT_FOUND */
        SQLA_CONNECT_EXCL  =14;/* Generate code for an SQL         */
                               /* 'CONNECT TO x IN EXCLUSIVE MODE' */
                               /* statement                        */
        SQLA_CONNECT_RESET =15;/* Generate code for an SQL         */
                               /* 'CONNECT RESET' statement        */
        SQLA_CONNECT_SHARE =16;/* Generate code for an SQL         */
                               /* 'CONNECT TO x [IN SHARE MODE]'   */
                               /* statement                        */
        SQLA_INC_TEXTFILE  =17;/* Process an INCLUDE text-file stmt */

      /*
       ** Values returned in task[n].val when task[n].func is SQLA_DECLARE.
       ** This is an output parameter of SQLACMPL.
      */

        SQLA_BEGIN         = 0;
        SQLA_END           = 1;

      /*
       ** Values returned in task[n].val when task[n].func is SQLA_INCLUDE.
       ** This is an output parameter of SQLACMPL.
      */

        SQLA_SQLCA         =10;
        SQLA_SQLDA         =11;

      /*
       ** Values returned in task[n].val when task[n].func is SQLA_CALL.
       ** This is an output parameter of SQLACMPL.
      */

        SQLA_CLOSE         =20;
        SQLA_COMMIT        =21;
        SQLA_DESCRIBE      =22;
        SQLA_EXECIMMD      =23;
        SQLA_EXECUTE       =24;
        SQLA_FETCH         =25;
        SQLA_OPEN          =26;
        SQLA_PREPARE       =27;
        SQLA_ROLLBACK      =28;
        SQLA_CONNECT       =29;

      /*
       ** Values assigned to token[n].use, an output parameter of SQLACMPL.
      */

        SQLA_INPUT_HVAR     =0;/* Input host var, no indicator var */
        SQLA_INPUT_WITH_IND =1;/* Input host var followed by indicator var */
        SQLA_OUTPUT_HVAR    =2;/* Output host var, no indicator var */
        SQLA_OUTPUT_WITH_IND=3;/* Output host var followed by indicator var*/
        SQLA_INDICATOR      =4;/* Indicator variable */
        SQLA_USER_SQLDA     =5;/* SQLDA structure */
        SQLA_INVALID_USE    =6;/* Host variable type does not match use */
        SQLA_INVALID_ID     =7;/* Host variable token ID is not valid */

      /*
       ** Values assigned to stmt_type, an output parameter of SQLACMPL.
      */

        SQLA_TYPE_BEGIN            = 0;
        SQLA_TYPE_CLOSE            =10;
        SQLA_TYPE_COMMIT           =20;
        SQLA_TYPE_CONNECT_NOP      =23;
        SQLA_TYPE_CONNECT_EXCLUSIVE=24;
        SQLA_TYPE_CONNECT_RESET    =25;
        SQLA_TYPE_CONNECT_SHARE    =26;
        SQLA_TYPE_DECLARE_SELECT   =30;
        SQLA_TYPE_DECLARE_SNAME    =40;
        SQLA_TYPE_DESCRIBE         =50;
        SQLA_TYPE_END              =60;
        SQLA_TYPE_EXECUTE          =70;
        SQLA_TYPE_EXECUTE_IMM      =80;
        SQLA_TYPE_FETCH            =90;
        SQLA_TYPE_INCLUDE_SQLCA   =100;
        SQLA_TYPE_INCLUDE_SQLDA   =110;
        SQLA_TYPE_INCLUDE_TEXTFILE=115;
        SQLA_TYPE_OPEN            =120;
        SQLA_TYPE_PREPARE         =130;
        SQLA_TYPE_ROLLBACK        =140;
        SQLA_TYPE_SELECT          =150;
        SQLA_TYPE_SELECT_INTO     =160;
        SQLA_TYPE_WHEN_NOT_FOUND  =170;
        SQLA_TYPE_WHEN_SQLERROR   =180;
        SQLA_TYPE_WHEN_SQLWARNING =190;
        SQLA_TYPE_OTHER           =200;

      /*
       ** Values used for term_option, an input parameter of SQLAFINI.
      */

        SQLA_SAVE          = 1;/* Save the access plan and/or bind file */
        SQLA_DISCARD       = 0;/* Discard the access plan and/or bind file */

      /*
       ** Miscellaneous Constants
      */

        SQL_MAX_FILE_NAME_LENGTH = 128;/* size of SQLAINIT file name buffer */
        SQL_CMPL_BUFSIZ          = 128;/* size of SQLACMPL output buffers */
        SQL_PID_LENGTH           =  40;/* length of precompiler pid */

      /*
       ** Return codes from Precompiler Services and Runtime Services functions.
      */

        SQLA_SQLCA_BAD    = -1;/* sqlca pointer/length invalid */
        SQLA_CHECK_SQLCA  =  0;/* check sqlca completion status */

     /*
      ** Values returned in sqlca.sqlcode by Precompiler or Runtime Services
     */

        SQLA_RC_CHAR_BAD              =  SQL_RC_E007;
        SQLA_RC_STRING_NOT_TERMINATED =  SQL_RC_E010;
        SQLA_RC_EMPTY_DEL_IDENT       =  SQL_RC_E013;
        SQLA_RC_BFILE_OPEN_ERROR      =-31;
        SQLA_RC_BFILE_DISK_ERROR      =-32;
        SQLA_RC_SECTION_LIMIT         =-51;
        SQLA_RC_MEMORY_BAD            =-83;
        SQLA_RC_SNAME_DUP             =-85;
        SQLA_RC_STMT_LIMIT            =  SQL_RC_E101;
        SQLA_RC_NUMBER_BAD            =  SQL_RC_E103;
        SQLA_RC_STMT_SYNTAX_BAD       =  SQL_RC_E104;
        SQLA_RC_GSTRING_BAD           =  SQL_RC_E105;         /* DBCS only */
        SQLA_RC_IDENTIFIER_LIMIT      =  SQL_RC_E107;
        SQLA_RC_QUALIFIER_BAD         =  SQL_RC_E108;
        SQLA_RC_DDSBAD                =  SQL_RC_E142;
        SQLA_RC_DDSIGN                =  SQL_RC_W143;
        SQLA_RC_DDSWRN                =  SQL_RC_W143;
        SQLA_RC_KEYWORD_BAD           =  SQL_RC_E199;
        SQLA_RC_HVAR_NOT_DEC         =-306;
        SQLA_RC_HVAR_DUP_NAME        =-307;
        SQLA_RC_HVAR_LIMIT           =-308;
        SQLA_RC_STMT_HVAR_LIMIT      =-310;
        SQLA_RC_HVAR_USE_BAD         =-324;
        SQLA_RC_CURSOR_DUP           =-505;
        SQLA_RC_STMT_MODIFY_ALL      = 513;
        SQLA_RC_DISK_FULL            =   SQL_RC_E968;
        SQLA_RC_FATAL_ERROR         =-4901;
        SQLA_RC_PARM_CHARS_BAD      =-4902;
        SQLA_RC_PARM_LENGTH_BAD     =    SQLA_RC_OPTION_LEN_BAD;
        SQLA_RC_PARM_POINTER_BAD    =    SQLA_RC_OPTION_PTR_BAD;
        SQLA_RC_PARM_RANGE_BAD      =    SQLA_RC_OPTION_SIZE_BAD;
        SQLA_RC_HVAR_SQLTYPE_BAD    =-4911;
        SQLA_RC_HVAR_SQLLEN_BAD     =-4912;
        SQLA_RC_HVAR_TOKEN_ID_DUP   =-4913;
        SQLA_RC_HVAR_TOKEN_ID_BAD   =-4914;
        SQLA_RC_INIT_DUP            =-4915;
        SQLA_RC_INIT_REQUIRED       =-4916;
        SQLA_RC_OPTION_BAD          =    SQLA_RC_OPTION_DATA_BAD;
        SQLA_RC_TERM_OPTION_BAD     =-4918;
        SQLA_RC_TASK_ARRAY_LIMIT    =-4919;
        SQLA_RC_STMT_CLAUSE_BAD     =-4940;/* Prep version of -109 */
        SQLA_RC_STMT_BLANK          =-4941;/* Prep version of -198 */
        SQLA_RC_SELECT_HVAR_TYPE_BAD=-4942;/* Prep version of -303 */
        SQLA_RC_SELECT_LIST_BAD     = 4943;/* Prep version of -313 */
        SQLA_RC_COLUMN_NOT_NULLABLE =-4944;/* Prep version of -407 */
        SQLA_RC_STMT_MARKER_BAD     =-4945;/* Prep version of -418 */
        SQLA_RC_CURSOR_NOT_DECLARED =-4946;/* Prep version of -504 */
        SQLA_RC_SQLDA_ID_BAD        =-4951;
        SQLA_RC_SQLVAR_INDEX_BAD    =-4952;
        SQLA_RC_CALL_TYPE_BAD       =-4953;
        SQLA_RC_SECTION_BAD         =-4954;

      /*
       ** Temporary value used in sqlca.sqlcode after an SQLAALOC function.  Runtime
       ** code can check sqlca.sqlcode to determine whether or not the SQLASETV
       ** function needs to be called to initialize the sqlda sqlvar elements.
      */

        SQLA_RC_SQLVARS_SET         = 4959;/* sqlvars already initialized */

      /*
       ** Errors that cause Precompiler Services to enter the fatal error state.
       ** After encountering one of these types of errors, Precompiler Services
       ** requires an SQLAFINI and SQLAINIT call before it will continue.
      */

        SQLA_RC_INV_INSERT             = SQL_RC_E803 ;
        SQLA_RC_INV_SQLDA_ADR          = SQL_RC_E822 ;
        SQLA_RC_SYS_ERROR              = SQL_RC_E902 ;
        SQLA_RC_DEADLOCK_ERR           = SQL_RC_E911 ;
        SQLA_RC_FAT_SYS_ERR            = SQL_RC_E912 ;
        SQLA_RC_TOO_MANY_LKS           = SQL_RC_E930 ;
        SQLA_RC_STORAGE_ERR            = SQL_RC_E954 ;
        SQLA_RC_DB_HEAP_ERR            = SQL_RC_E956 ;
        SQLA_RC_TOOMANY_OFLS           = SQL_RC_E958 ;
        SQLA_RC_TOOMANY_FILES          = SQL_RC_E960 ;
        SQLA_RC_LOG_FULL               = SQL_RC_E964 ;
        SQLA_RC_FILE_SYS_FULL          = SQL_RC_E968 ;
        SQLA_RC_READ_ONLY_FIL          = SQL_RC_E970 ;
        SQLA_RC_INCORRECT_DSK          = SQL_RC_E972 ;
        SQLA_RC_DB_DRV_LOCKED          = SQL_RC_E974 ;
        SQLA_RC_DRV_DOOR_OPEN          = SQL_RC_E976 ;
        SQLA_RC_DISK_WRT_PRO           = SQL_RC_E978 ;
        SQLA_RC_DISK_ERROR             = SQL_RC_E980 ;
        SQLA_RC_DISK_ERR               = SQL_RC_E982 ;
        SQLA_RC_COMM_RB_ERR            = SQL_RC_E984 ;
        SQLA_RC_CAT_FILE_ERR           = SQL_RC_E985 ;
        SQLA_RC_TAB_FILE_ERR           = SQL_RC_E986 ;
        SQLA_RC_INDEX_ERR              = SQL_RC_E990 ;
        SQLA_RC_REL_NUM_BAD            = SQL_RC_E992 ;
        SQLA_RC_CTRL_BREAK         = -4994;/* Prep version of -952 */
        SQLA_RC_CODEPAGE_BAD       = -4995;/* Country info not found */
        SQLA_RC_SQLUSER_BAD        = -4997;/* Prep version of -1046 */
        SQLA_RC_DB_DISCONNECTED    = -4998;/* Prep version of -900 */
        SQLA_RC_INTERNAL_ERR       = -4999;/* Precompiler Services err */

    /*********************** Precompiler Services Structures *******************/
TYPE
   /*
    ** Precompiler Option Array.  Used with SQLAINIT.
   */
   PSQLA_OPTIONS=^TSQLA_OPTIONS;
   TSQLA_OPTIONS=RECORD
                       header:RECORD
                                  allocated:ULONG;
                                  used:ULONG;
                              END;
                       option:RECORD
                                  atype:ULONG;
                                  aval:ULONG;
                              END;
                 END;

TYPE
   /*
    ** Program ID.  Used by Precompiler Services and Runtime Services
   */
   PSQLA_PROGRAM_ID=^TSQLA_PROGRAM_ID;
   TSQLA_PROGRAM_ID=RECORD
                        alength:WORD;
                        rp_rel_num:WORD;
                        db_rel_num:WORD;
                        bf_rel_num:WORD;
                        sqluser:CSTRING[7];
                        planname:CSTRING[7];
                        contoken:CSTRING[7];
                        buffer:CSTRING[7];
                    END;

TYPE
    /*
     ** Precompiler Task Array.  Used with SQLACMPL.
    */
    PSQLA_TASKS=^TSQLA_TASKS;
    TSQLA_TASKS=RECORD
                     header:RECORD
                                  allocated:ULONG;
                                  used:ULONG;
                            END;
                     task:RECORD
                               func:ULONG;
                               aval:ULONG;
                          END;
                END;

TYPE
   /*
    ** Token return structure.  Used to return length and offset of
    ** a token within an SQL statement.  Overlaid on top of the val
    ** member of the task array.
   */
   PSQLA_RETURN_TOKEN=^TSQLA_RETURN_TOKEN;
   TSQLA_RETURN_TOKEN=RECORD
                           offset:WORD;
                           alength:WORD;
                      END;

TYPE
   /*
    ** Precompiler Token ID Array.  Used with SQLACMPL
    */
   PSQLA_TOKENS=^TSQLA_TOKENS;
   TSQLA_TOKENS=RECORD
                     header:RECORD
                                allocated:ULONG;
                                used:ULONG;
                            END;
                     token:RECORD
                                id:ULONG;
                                use:ULONG;
                           END;
                END;


IMPORTS
       /* ADD A HOST VARIABLE DECLARATION */
       FUNCTION sqlaahvr (VAR hostnamelen:WORD;   /* host variable name length */
                          hostname:CSTRING;       /* host variable name */
                          VAR HostData:WORD;      /* host variable SQL data type */
                          VAR VarLen:WORD;        /* host variable length */
                          TokenID:POINTER;        /* host variable token id */
                          VAR HostLoc:WORD;       /* host variable location */
                          reserved:POINTER;       /* reserved */
                          asqlca : TSQLCA):INTEGER; /* SQLCA */
                  APIENTRY; 'SQLAI32' name 'sqlaahvr';

       /* COMPILE AN SQL STATEMENT */
       FUNCTION sqlacmpl (VAR len:WORD;          /* SQL statement text length */
                          statement:CSTRING;      /* SQL statement text */
                          VAR linenum:WORD;      /* source line number */
                          VAR asqla_tasks:TSQLA_TASKS;   /* task array */
                          VAR asqla_tokens:TSQLA_TOKENS; /* token id array */
                          VAR sectionnum:WORD;   /* section number */
                          VAR sqlstattype:WORD;  /* type of SQL statement */
                          buffer1:CSTRING;       /* 128 byte string buffer 1 */
                          buffer2:CSTRING;       /* 128 byte string buffer 2 */
                          buffer3:CSTRING;       /* 128 byte string buffer 3 */
                          reserved:POINTER;      /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;  /* SQLCA */
                  APIENTRY; 'SQLAI32' name 'sqlacmpl';

       /* TERMINATE AN ACCESS PLAN */
       FUNCTION sqlafini (VAR bindfile:WORD;    /* save/discard plan/bind file */
                          reserved:POINTER;     /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;  /* SQLCA */
                  APIENTRY; 'SQLAI32' name 'sqlafini';

       /* INITIALIZE AN ACCESS PLAN */
       FUNCTION sqlainit (VAR prognamelen:WORD;  /* program name length */
                          ProgName:CSTRING;      /* program name */
                          VAR DatabaseNameLen:WORD; /* database name length */
                          DataBase:CSTRING;      /* database name */
                          VAR passwdlen:WORD;    /* password length */
                          passwd:CSTRING;        /* database password */
                          VAR bindfilenamelen:WORD; /* bind file name length */
                          bindfile:CSTRING;      /* bind file name */
                          VAR asqla_options:TSQLA_OPTIONS; /* precompiler option array */
                          VAR asqla_program_id:TSQLA_PROGRAM_ID; /* precompiler program ID */
                          reserved:POINTER;      /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;     /* SQLCA */
                  APIENTRY; 'SQLAI32' name 'sqlainit';

       /* ADD A HOST VARIABLE DECLARATION */
       FUNCTION SQLGAHVR (VAR hostnamelen:WORD; /* host variable name length */
                          hostname:CSTRING;     /* host variable name */
                          VAR sqldatatype:WORD; /* host variable SQL data type */
                          VAR hostvarlen:WORD;  /* host variable length */
                          tokenid:POINTER;      /* host variable token id */
                          VAR loc:WORD;         /* host variable location */
                          reserved:POINTER;     /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;     /* SQLCA */
                  APIENTRY; 'SQLAPI32' name 'SQLGAHVR';

       /* COMPILE AN SQL STATEMENT */
       FUNCTION SQLGCMPL (VAR textlen:WORD;    /* SQL statement text length */
                          statement:CSTRING;   /* SQL statement text */
                          VAR linenum:WORD;    /* source line number */
                          VAR asqla_tasks:TSQLA_TASKS; /* task array */
                          VAR asqla_tokens:TSQLA_TOKENS; /* token id array */
                          VAR section:WORD;    /* section number */
                          VAR sqltype:WORD;    /* type of SQL statement */
                          buffer1:CSTRING;     /* 128 byte string buffer 1 */
                          buffer2:CSTRING;     /* 128 byte string buffer 2 */
                          buffer3:CSTRING;     /* 128 byte string buffer 3 */
                          reserved:POINTER;    /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;     /* SQLCA */
                  APIENTRY; 'SQLAPI32' name 'SQLGCMPL';

       /* TERMINATE AN ACCESS PLAN */
       FUNCTION SQLGFINI (VAR bindfile:WORD;   /* save/discard plan/bind file */
                          reserved:POINTER;    /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;  /* SQLCA */
                  APIENTRY; 'SQLAPI32' name 'SQLGFINI';

       /* INITIALIZE AN ACCESS PLAN */
       FUNCTION SQLGINIT (VAR ProgNameLen:WORD;   /* program name length */
                          ProgName:CSTRING;       /* program name */
                          VAR databasenamelen:WORD; /* database name length */
                          database:CSTRING;       /* database name */
                          VAR passwdlen:WORD;     /* password length */
                          passwd:CSTRING;         /* database password */
                          VAR bindfilelen:WORD;   /* bind file name length */
                          bindfile:CSTRING;       /* bind file name */
                          VAR asqla_options:TSQLA_OPTIONS; /* precompiler option array */
                          VAR asqla_program_id:TSQLA_PROGRAM_ID; /* precompiler program ID */
                          reserved:POINTER;       /* reserved */
                          VAR asqlca:TSQLCA):INTEGER;  /* SQLCA */
                  APIENTRY; 'SQLAPI32' name 'SQLGINIT';

       /* Begin Runtime Services  prototypes : **************************************/

       FUNCTION sqlaaloc (id:LONGWORD;      /* sqlda identification number        */
                          elems:LONGWORD;   /* number of sqlvar elements needed   */
                          statementid:LONGWORD; /* statement identification number    */
                          reserved:POINTER):INTEGER;  /* reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqlaaloc';

       FUNCTION sqlacall (typ:LONGWORD;     /* function call type                 */
                          aplan:LONGWORD;   /* access plan section                */
                          id:LONGWORD;      /* input SQLDA ID                     */
                          outputid:LONGWORD;/* output SQLDA ID                    */
                          reserved:POINTER):INTEGER;  /* reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqlacall';

       FUNCTION sqladloc (id:LONGWORD;      /* SQLDA ID                           */
                          reserved:POINTER):INTEGER;  /* reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqladloc';

        FUNCTION sqlasets (textlen:LONGWORD; /* SQL statement text length          */
                           statement:POINTER; /* SQL statement text                 */
                           reserved:POINTER):INTEGER; /* reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqlasets';

        FUNCTION sqlasetv (id:LONGWORD;      /* SQLDA ID                           */
                           elem:LONGWORD;    /* sqlvar element                     */
                           datatype:LONGWORD;/* SQL data type                      */
                           len:LONGWORD;     /* declared length                    */
                           hostvaradr:POINTER; /* address of host var                */
                           indicatoradr:POINTER; /* address of indicator var           */
                           reserved:POINTER):INTEGER; /* reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqlasetv';

        FUNCTION sqlastop (reserved:POINTER):INTEGER;             /* reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqlastop';

        FUNCTION sqlastrt (ProgId:POINTER;   /* runtime program ID                 */
                           reserved:POINTER; /* reserved                           */
                           VAR asqlca:TSQLCA):INTEGER;     /* SQLCA                              */
                  APIENTRY; 'SQLAK32' name 'sqlastrt';

        FUNCTION sqlausda (id:LONGWORD;     /* SQLDA id                           */
                           VAR asqlda:TSQLDA;   /* SQLDA pointer                      */
                           reserved:POINTER):INTEGER;             /* Reserved                           */
                  APIENTRY; 'SQLAK32' name 'sqlausda';

END;

IMPLEMENTATION

END.
