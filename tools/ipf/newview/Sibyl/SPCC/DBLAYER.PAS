
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
                    
Unit DbLayer;

Interface

Uses Dos,SysUtils,IniFiles;

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin;
{$ENDIF}
{$IFDEF Win95}
Uses WinNt,WinDef,WinBase;
{$ENDIF}

Uses Classes;

Type
    HENV=LongWord;
    HDBC=LongWord;
    HSTMT=LongWord;
    RETCODE=Integer;

    SQLHENV=HENV;
    SQLHDBC=HDBC;
    SQLHSTMT=HSTMT;
    SQLHWND=HWND;

    SWORD=Integer;
    UWORD=Word;
    SQLSMALLINT=SWORD;
    SQLUSMALLINT=UWORD;
    SQLUINTEGER=LongWord;
    SQLINTEGER=LongInt;
    SQLRETURN=SQLSMALLINT;
    SQLCHAR=cstring;
    SQLPOINTER=Pointer;

Const
     SQL_SUCCESS             =0;
     SQL_SUCCESS_WITH_INFO   =1;
     SQL_NO_DATA_FOUND       =100;
     SQL_NEED_DATA           =99;
     SQL_NO_DATA             =SQL_NO_DATA_FOUND;
     SQL_STILL_EXECUTING     =2;
     SQL_ERROR               =-1;
     SQL_INVALID_HANDLE      =-2;

     SQL_COMMIT              =0;
     SQL_ROLLBACK            =1;

    /* Options For SQLSetConnectOption/SQLGetConnectOption */
Const
    SQL_ACCESS_MODE              =101;
    SQL_AUTOCOMMIT               =102;
    SQL_LOGIN_TIMEOUT            =103;
    SQL_OPT_TRACE                =104;
    SQL_OPT_TRACEFILE            =105;
    SQL_TRANSLATE_DLL            =106;
    SQL_TRANSLATE_OPTION         =107;
    SQL_TXN_ISOLATION            =108;
    SQL_CURRENT_QUALIFIER        =109;
    SQL_ODBC_CURSORS             =110;
    SQL_QUIET_MODE               =111;
    SQL_PACKET_SIZE              =112;
    SQL_CONNECT_OPT_DRVR_START   =1000;

    SQL_PARAM_TYPE_UNKNOWN       =0;
    SQL_PARAM_INPUT              =1;
    SQL_PARAM_INPUT_OUTPUT       =2;
    SQL_RESULT_COL               =3;
    SQL_PARAM_OUTPUT             =4;
    SQL_RETURN_VALUE             =5;
    SQL_PARAM_RESULT             =6; //Oracle7

    /* Options For SQLGetConnectOption/SQLSetConnectOption extensions */
    SQL_WCHARTYPE                =1252;
    SQL_LONGDATA_COMPAT          =1253;
    SQL_CURRENT_SCHEMA           =1254;
    SQL_DB2EXPLAIN               =1258;
    SQL_DB2ESTIMATE              =1259;
    SQL_PARAMOPT_ATOMIC          =1260;
    SQL_STMTTXN_ISOLATION        =1261;
    SQL_MAXCONN                  =1262;

    /* Options For SQLSetConnectOption, SQLSetEnvAttr */
    SQL_CONNECTTYPE              =1255;
    SQL_SYNC_POINT               =1256;

    /* Options For SQL_LONGDATA_COMPAT */
    SQL_LD_COMPAT_YES            =1;
    SQL_LD_COMPAT_NO             =0;
    SQL_LD_COMPAT_DEFAULT        =SQL_LD_COMPAT_NO;

    /*  Options For SQL_PARAMOPT_ATOMIC*/
    SQL_ATOMIC_YES               =1;
    SQL_ATOMIC_NO                =0;
    SQL_ATOMIC_DEFAULT           =SQL_ATOMIC_YES;

    /* Options For SQL_CONNECT_TYPE */
    SQL_CONCURRENT_TRANS         =1;
    SQL_COORDINATED_TRANS        =2;
    SQL_CONNECTTYPE_DEFAULT      =SQL_CONCURRENT_TRANS;

    /* Options For SQL_SYNCPOINT */
    SQL_ONEPHASE                 =1;
    SQL_TWOPHASE                 =2;
    SQL_SYNCPOINT_DEFAULT        =SQL_ONEPHASE;

    /* Options For SQL_DB2ESTIMATE */
    SQL_DB2ESTIMATE_ON           =1;
    SQL_DB2ESTIMATE_OFF          =0;
    SQL_DB2ESTIMATE_DEFAULT      =SQL_DB2ESTIMATE_OFF;

    /* Options For SQL_DB2EXPLAIN */
    SQL_DB2EXPLAIN_ON            =1;
    SQL_DB2EXPLAIN_OFF           =0;
    SQL_DB2EXPLAIN_DEFAULT       =SQL_DB2EXPLAIN_OFF;

    /* Options For SQL_WCHARTYPE */
    SQL_WCHARTYPE_CONVERT        =1;
    SQL_WCHARTYPE_NOCONVERT      =0;
    SQL_WCHARTYPE_DEFAULT        =SQL_WCHARTYPE_NOCONVERT;

    /* SQL_ACCESS_MODE Options */
    SQL_MODE_READ_WRITE          =0;
    SQL_MODE_READ_ONLY           =1;
    SQL_MODE_DEFAULT             =SQL_MODE_READ_WRITE;

    /* SQL_AUTOCOMMIT Options */
    SQL_AUTOCOMMIT_OFF           =0;
    SQL_AUTOCOMMIT_ON            =1;
    SQL_AUTOCOMMIT_DEFAULT       =SQL_AUTOCOMMIT_ON;

    /* SQL_LOGIN_TIMEOUT Options */
    SQL_LOGIN_TIMEOUT_DEFAULT    =0;

    /* Column types And scopes In SQLSpecialColumns */
    SQL_BEST_ROWID               =1;
    SQL_ROWVER                   =2;

    SQL_SCOPE_CURROW             =0;
    SQL_SCOPE_TRANSACTION        =1;
    SQL_SCOPE_SESSION            =2;

    /* Defines For SQLStatistics */
    SQL_INDEX_UNIQUE             =0;
    SQL_INDEX_ALL                =1;

    SQL_QUICK                    =0;
    SQL_ENSURE                   =1;

    /* Defines For SQLStatistics (returned In the Result Set) */
    SQL_TABLE_STAT               =0;
    SQL_INDEX_CLUSTERED          =1;
    SQL_INDEX_HASHED             =2;
    SQL_INDEX_OTHER              =3;

    /* Defines For SQLSpecialColumns (returned In the Result Set) */
    SQL_PC_UNKNOWN               =0;
    SQL_PC_NOT_PSEUDO            =1;
    SQL_PC_PSEUDO                =2;

    /* SQLDataSources "fDirection" values, also used ON SQLExtendedFetch() */
    /* See sqlext.H For additional SQLExtendedFetch fetch Direction Defines */
    SQL_FETCH_NEXT             =1;
    SQL_FETCH_FIRST            =2;
    SQL_FETCH_LAST             =3;
    SQL_FETCH_PRIOR            =4;
    SQL_FETCH_ABSOLUTE         =5;
    SQL_FETCH_RELATIVE         =6;

    /* Special Length values  */
    SQL_NULL_DATA        =-1;
    SQL_DATA_AT_EXEC     =-2;
    SQL_NTS              =-3;      /* NTS = Null Terminated String    */

    /* SQLFreeStmt option values  */
    SQL_CLOSE               =0;
    SQL_DROP                =1;
    SQL_UNBIND              =2;
    SQL_RESET_PARAMS        =3;

    /* SQLColAttributes Defines */
    SQL_COLUMN_COUNT             =0;
    SQL_COLUMN_NAME              =1;
    SQL_COLUMN_TYPE              =2;
    SQL_COLUMN_LENGTH            =3;
    SQL_COLUMN_PRECISION         =4;
    SQL_COLUMN_SCALE             =5;
    SQL_COLUMN_DISPLAY_SIZE      =6;
    SQL_COLUMN_NULLABLE          =7;
    SQL_COLUMN_UNSIGNED          =8;
    SQL_COLUMN_MONEY             =9;
    SQL_COLUMN_UPDATABLE        =10;
    SQL_COLUMN_AUTO_INCREMENT   =11;
    SQL_COLUMN_CASE_SENSITIVE   =12;
    SQL_COLUMN_SEARCHABLE       =13;
    SQL_COLUMN_TYPE_NAME        =14;
    SQL_COLUMN_TABLE_NAME       =15;
    SQL_COLUMN_OWNER_NAME       =16;
    SQL_COLUMN_QUALIFIER_NAME   =17;
    SQL_COLUMN_LABEL            =18;
    SQL_COLUMN_SCHEMA_NAME      =SQL_COLUMN_OWNER_NAME;
    SQL_COLUMN_CATALOG_NAME     =SQL_COLUMN_QUALIFIER_NAME;
    SQL_COLUMN_DISTINCT_TYPE    =1250;

    /* SQLColAttributes Defines For SQL_COLUMN_UPDATABLE condition */
    SQL_ATTR_READONLY           = 0;
    SQL_ATTR_WRITE              = 1;
    SQL_ATTR_READWRITE_UNKNOWN  = 2;

    /* Standard SQL Data types */
    SQL_CHAR                =1;
    SQL_NUMERIC             =2;
    SQL_DECIMAL             =3;
    SQL_INTEGER             =4;
    SQL_SMALLINT            =5;
    SQL_FLOAT               =6;
    SQL_REAL                =7;
    SQL_DOUBLE              =8;
    SQL_DATE                =9;
    SQL_TIME               =10;
    SQL_TIMESTAMP          =11;
    SQL_VARCHAR            =12;

    /* SQL Extended Data types */
    SQL_LONGVARCHAR        =-1;
    SQL_BINARY             =-2;
    SQL_VARBINARY          =-3;
    SQL_LONGVARBINARY      =-4;
    SQL_BIGINT             =-5;  /* Not supported */
    SQL_TINYINT            =-6;  /* Not supported */
    SQL_BIT                =-7;  /* Not supported */
    SQL_GRAPHIC            =-95;
    SQL_VARGRAPHIC         =-96;
    SQL_LONGVARGRAPHIC     =-97;
    SQL_BLOB               =-98;
    SQL_CLOB               =-99;
    SQL_DBCLOB             =-350;

    SQL_SIGNED_OFFSET      =-20;
    SQL_UNSIGNED_OFFSET    =-22;

    /* C Data Type To SQL Data Type mapping */
    SQL_C_CHAR       =SQL_CHAR;      /* Char, VARCHAR, DECIMAL, NUMERIC */
    SQL_C_LONG       =SQL_INTEGER;   /* Integer                         */
    SQL_C_SHORT      =SQL_SMALLINT;  /* SMALLINT                        */
    SQL_C_FLOAT      =SQL_REAL;      /* Real                            */
    SQL_C_DOUBLE     =SQL_DOUBLE;    /* FLOAT, Double                   */
    SQL_C_DATE       =SQL_DATE;      /* date                            */
    SQL_C_TIME       =SQL_TIME;      /* Time                            */
    SQL_C_TIMESTAMP  =SQL_TIMESTAMP; /* TIMESTAMP                       */
    SQL_C_BINARY     =SQL_BINARY;    /* binary, VARGINARY               */
    SQL_C_BIT        =SQL_BIT;
    SQL_C_TINYINT    =SQL_TINYINT;
    SQL_C_DBCHAR     =SQL_DBCLOB;
    SQL_C_DEFAULT    =99;

    /* For ODBC compatibility only */
    SQL_C_SLONG      =SQL_C_LONG+SQL_SIGNED_OFFSET;
    SQL_C_SSHORT     =SQL_C_SHORT+SQL_SIGNED_OFFSET;
    SQL_C_STINYINT   =SQL_C_TINYINT+SQL_SIGNED_OFFSET;
    SQL_C_ULONG      =SQL_C_LONG+SQL_UNSIGNED_OFFSET;
    SQL_C_USHORT     =SQL_C_SHORT+SQL_UNSIGNED_OFFSET;
    SQL_C_UTINYINT   =SQL_C_TINYINT+SQL_UNSIGNED_OFFSET;

    /* generally useful constants */
    SQL_SQLSTATE_SIZE        = 5;   /* Size Of SQLSTATE, Not including
                                          Null terminating Byte           */
    SQL_MAX_MESSAGE_LENGTH   =1024; /* Message Buffer Size             */
    SQL_MAX_DSN_LENGTH       =32;   /* maximum Data Source Name Size   */
    SQL_MAX_ID_LENGTH        =18;   /* maximum identifier Name Size, */

    //SQLSetStmtOption values
    SQL_QUERY_TIMEOUT =0;
    SQL_MAX_ROWS      =1;
    SQL_NOSCAN        =2;
    SQL_MAX_LENGTH    =3;
    SQL_ASYNC_ENABLE  =4;
    SQL_BIND_TYPE     =5;
    SQL_CURSOR_TYPE   =6;
    SQL_CONCURRENCY   =7;
    SQL_KEYSET_SIZE   =8;
    SQL_ROWSET_SIZE   =9;
    SQL_SIMULATE_CURSOR =10;
    SQL_RETRIEVE_DATA =11;
    SQL_USE_BOOKMARKS =12;
    SQL_GET_BOOKMARK  =13;
    SQL_ROW_NUMBER    =14;

    //SQLScrollOptions
    SQL_SO_FORWARD_ONLY         = 1;
    SQL_SO_KEYSET_DRIVEN        = 2;
    SQL_SO_DYNAMIC              = 4;
    SQL_SO_MIXED                = 8;
    SQL_SO_STATIC               = 16;

    //CursorType
    SQL_CURSOR_FORWARD_ONLY     =0;
    SQL_CURSOR_KEYSET_DRIVEN    =1;
    SQL_CURSOR_DYNAMIC          =2;
    SQL_CURSOR_STATIC           =3;

    SQL_NO_NULLS                =0;
    SQL_NULLABLE                =1;
    SQL_NULLABLE_UNKNOWN        =2;


Type
    TDBTypes=(Unkown_DB,Native,Native_DBase,Native_mSQL,Sybase,DB2,
              Native_Paradox,Native_Oracle7,ODBC);

    TODBCDate=Record
       Year,Month,Day:Word;
    End;


    TODBCTime=Record
        Hour,Minute,Second:Word;
    End;


    TODBCDateTime=Record
        Date:TODBCDate;
        Time:TODBCTime;
    End;

    PDBProcs=^TDBProcs;
    TDBProcs=Record
                   ModHandle:LongWord;  //Module Handle
                   ahenv:SQLHENV;       //Environment Handle
                   ahdbc:SQLHDBC;       //DataBase Handle
                   ahstmt:SQLHSTMT;     //statement Handle
                   DataBase:cstring;    //DataBase Name
                   AliasName:String;    //Server alias Name
                   Host:string;         //database host
                   uid:cstring;         //user Id
                   pwd:cstring;         //pasword
                   Assigned:Boolean;    //True if functions and heap-structures are valid
                   FuncTable:Pointer;   //function table for some native db's (like mSQL)
                   IsStoredProc:Boolean;//True for stored procs

                   Case DBType:TDBTypes Of
                     Native_DBase,Native_Paradox,Unkown_DB,Native,Native_mSQL,Sybase,DB2,ODBC:
                     (
                        SQLAllocEnv:Function(Var phenv:SQLHENV):SQLRETURN;APIENTRY;
                        SQLAllocConnect:Function(ahenv:SQLHENV;Var phdbc:SQLHDBC):SQLRETURN;APIENTRY;
                        SqlConnect:Function(ahdbc:SQLHDBC;Const szDSN:SQLCHAR;
                                            cbDSN:LongInt;Const szUID:SQLCHAR;
                                            cbUID:LongInt;Const szAuthString:SQLCHAR;
                                            cbAuthString:LongInt):SQLRETURN;APIENTRY;
                        {
                        SQLDriverConnect:Function(ahdbc:SQLHDBC;HWindow:SQLHWND;
                                                  Const szConnStrIn:SQLCHAR;cbConnStrIn:LongInt;
                                                  Var szConnStrOut:SQLCHAR;cbConnStrOutMax:LongInt;
                                                  Var pcbConnStrOut:SQLSMALLINT;
                                                  fDriverCompletion:LongWord):SQLRETURN;APIENTRY;
                        }
                        SQLDataSources:Function(ahenv:SQLHENV;fDirection:LongWord;
                                                Var szDSN:SQLCHAR;cbDSNMax:LongInt;
                                                Var pcbDSN:SQLSMALLINT;
                                                Var szDescription:SQLCHAR;cbDescriptionMax:LongInt;
                                                Var pcbDescription:SQLSMALLINT):SQLRETURN;APIENTRY;
                        {SQLGetInfo:Function(ahdbc:SQLHDBC;fInfoType:LongWord;Var rgbInfoValue;cbInfoValueMax:LongInt;
                                            Var pcbInfoValue:SQLSMALLINT):SQLRETURN;APIENTRY;
                        SQLGetFunctions:Function(ahdbc:SQLHDBC;fFunction:LongWord;Var pfExists:SQLUSMALLINT):SQLRETURN;APIENTRY;
                        }
                        SQLGetTypeInfo:Function(ahstmt:SQLHSTMT;fSQLType:LongInt):SQLRETURN;APIENTRY;
                        SQLSetConnectOption:Function(ahdbc:SQLHDBC;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
                        //SQLGetConnectOption:Function(ahdbc:SQLHDBC;fOption:LongWord;Var pvParam):SQLRETURN;APIENTRY;
                        SQLSetStmtOption:Function(ahstmt:SQLHSTMT;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
                        {SQLGetStmtOption:Function(ahstmt:SQLHSTMT;fOption:LongWord;Var pvParam):SQLRETURN;APIENTRY;}
                        SQLAllocStmt:Function(ahdbc:SQLHDBC;Var phstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                        {SQLPrepare:Function(ahstmt:SQLHSTMT;Const szSqlStr:SQLCHAR;cbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;}
                        SQLBindParameter:Function(ahstmt:SQLHSTMT;ipar:LongWord;fParamType:LongInt;
                                                  fCType:LongInt;fSQLType:LongInt;cbParamDef:SQLUINTEGER;
                                                  ibScale:LongInt;Var rgbValue;cbValueMax:SQLINTEGER;
                                                  Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                        {SQLSetParam:Function(ahstmt:SQLHSTMT;ipar:LongWord;fCType:LongInt;fSQLType:LongInt;
                                             cbParamDef:SQLUINTEGER;ibScale:LongInt;Var rgbValue;
                                             Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                        SQLParamOptions:Function(ahstmt:SQLHSTMT;crow:SQLUINTEGER;Var pirow:SQLUINTEGER):SQLRETURN;APIENTRY;}
                        SQLGetCursorName:Function(ahstmt:SQLHSTMT;Var szCursor:SQLCHAR;cbCursorMax:LongInt;
                                                  Var pcbCursor:SQLSMALLINT):SQLRETURN;APIENTRY;
                        {SQLSetCursorName:Function(ahstmt:SQLHSTMT;Const szCursor:SQLCHAR;cbCursor:LongInt):SQLRETURN;APIENTRY;
                        SQLExecute:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;}
                        SQLExecDirect:Function(ahstmt:SQLHSTMT;Const szSqlStr:SQLCHAR;cbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;
                        {SQLNativeSql:Function(ahdbc:SQLHDBC;Const szSqlStrIn:SQLCHAR;cbSqlStrIn:SQLINTEGER;
                                              Var szSqlStr:SQLCHAR;cbSqlStrMax:SQLINTEGER;Var pcbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;}
                        SQLNumParams:Function(ahstmt:SQLHSTMT;Var pcpar:SQLSMALLINT):SQLRETURN;APIENTRY;
                        {SQLParamData:Function(ahstmt:SQLHSTMT;Var prgbValue):SQLRETURN;APIENTRY;
                        SQLPutData:Function(ahstmt:SQLHSTMT;Var rgbValue;Var cbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                        SQLRowCount:Function(ahstmt:SQLHSTMT;Var pcrow:SQLINTEGER):SQLRETURN;APIENTRY;}
                        SQLNumResultCols:Function(ahstmt:SQLHSTMT;Var pccol:SQLSMALLINT):SQLRETURN;APIENTRY;
                        SQLDescribeCol:Function(ahstmt:SQLHSTMT;icol:LongWord;Var szColName:SQLCHAR;
                                                cbColNameMax:LongInt;Var pcbColName:SQLSMALLINT;
                                                Var pfSqlType:SQLSMALLINT;Var pcbColDef:SQLUINTEGER;
                                                Var pibScale:SQLSMALLINT;Var pfNullable:SQLSMALLINT):SQLRETURN;APIENTRY;
                        {SQLColAttributes:Function(ahstmt:SQLHSTMT;icol:LongWord;fDescType:LongWord;
                                                  Var rgbDesc:SQLCHAR;cbDescMax:LongInt;
                                                  Var pcbDesc:SQLSMALLINT;Var pfDesc:SQLINTEGER):SQLRETURN;APIENTRY;}
                        SQLBindCol:Function(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;Var rgbValue;
                                            cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                        SQLFetch:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                        SQLExtendedFetch:Function(ahstmt:SQLHSTMT;fFetchType:LongWord;irow:SQLINTEGER;
                                                  Var pcrow:SQLUINTEGER;Var rgfRowStatus):SQLRETURN;APIENTRY;
                        SQLGetData:Function(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;
                                            Var rgbValue;cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
                        {SQLMoreResults:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;}
                        SQLError:Function(ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT;Var szSqlState:SQLCHAR;
                                          Var pfNativeError:SQLINTEGER;Var szErrorMsg;
                                          cbErrorMsgMax:LongInt;Var pcbErrorMsg:SQLSMALLINT):SQLRETURN;APIENTRY;
                        {SQLColumns:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                           Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                           Const szTableName:SQLCHAR;cbTableName:LongInt;
                                           Const szColumnName:SQLCHAR;cbColumnName:LongInt):SQLRETURN;APIENTRY;}
                        SQLForeignKeys:Function(ahstmt:SQLHSTMT;Const szPkCatalogName:SQLCHAR;cbPkCatalogName:LongInt;
                                                Const szPkSchemaName:SQLCHAR;cbPkSchemaName:LongInt;
                                                Const szPkTableName:SQLCHAR;cbPkTableName:LongInt;
                                                Const szFkCatalogName:SQLCHAR;cbFkCatalogName:LongInt;
                                                Const szFkSchemaName:SQLCHAR;cbFkSchemaName:LongInt;
                                                Const szFkTableName:SQLCHAR;cbFkTableName:LongInt):SQLRETURN;APIENTRY;
                        SQLPrimaryKeys:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                                Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                                Const szTableName:SQLCHAR;cbTableName:LongInt):SQLRETURN;APIENTRY;
                        SQLProcedureColumns:Function(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                                                     Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                                                     Const szProcName:SQLCHAR;cbProcName:LongInt;
                                                     Const szColumnName:SQLCHAR;cbColumnName:LongInt):SQLRETURN;APIENTRY;
                        SQLProcedures:Function(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                                               Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                                               Const szProcName:SQLCHAR;cbProcName:LongInt):SQLRETURN;APIENTRY;
                        {SQLSpecialColumns:Function(ahstmt:SQLHSTMT;fColType:LongWord;
                                                   Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                                   Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                                   Const szTableName:SQLCHAR;cbTableName:LongInt;
                                                   fScope:LongWord;fNullable:LongWord):SQLRETURN;APIENTRY;}
                        SQLStatistics:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                               Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                               Const szTableName:SQLCHAR;cbTableName:LongInt;
                                               fUnique:LongWord;fAccuracy:LongWord):SQLRETURN;APIENTRY;
                        {
                        SQLTablePrivileges:Function(ahstmt:SQLHSTMT;Const szTableQualifier:SQLCHAR;cbTableQualifier:LongInt;
                                                    Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                                    Const szTableName:SQLCHAR;cbTableName:LongInt):SQLRETURN;APIENTRY;}
                        SQLTables:Function(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                           Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                           Const szTableName:SQLCHAR;cbTableName:LongInt;
                                           Const szTableType:SQLCHAR;cbTableType:LongInt):SQLRETURN;APIENTRY;
                        SQLFreeStmt:Function(ahstmt:SQLHSTMT;fOption:LongWord):SQLRETURN;APIENTRY;
                        SQLCancel:Function(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
                        SQLTransact:Function(ahenv:SQLHENV;ahdbc:SQLHDBC;fType:LongWord):SQLRETURN;APIENTRY;
                        SQLDisconnect:Function(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
                        SQLFreeConnect:Function(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
                        SQLFreeEnv:Function(ahenv:SQLHENV):SQLRETURN;APIENTRY;
                        Oracle7GetProcParams:Function(Const Name:String;DBProcs:PDBProcs;ParamName:TStrings;ParamType,ParamMode:TList):Boolean;
                     );
    End;

Type
    EProcAddrError=Class(Exception);

Function FillDBProcs(Var DbProcs:TDBProcs):Boolean;
Procedure FreeDBProcs(Var DbProcs:TDBProcs);
Function SQLErrorText(Var DbProcs:TDBProcs;ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT):String;

Function GetDBServersCount:LongInt;
Procedure GetDBServer(Index:LongInt;Var AliasName,DllName:String;Var DBType:TDBTypes);
Procedure GetDBServerFromAlias(Const alias:String;Var DllName:String;Var DBType:TDBTypes);
Procedure AddServerAlias(Const AliasName,DllName:String;DBType:TDBTypes);
Procedure ModifyServerAlias(Const AliasName,NewAliasName,DllName:String;DBType:TDBTypes);
Procedure RemoveServerAlias(Const AliasName:String);
Function IsDefaultServer(Const AliasName:String):Boolean;

Function GetDBAliasNamesCount:LongInt;
Procedure GetDBAlias(Index:LongInt;Var AliasName,DriverName,Advanced,UID:String);
Procedure GetDBServerFromDBAlias(Const AliasName:String;Var DriverName,Advanced,UID:String);
Procedure AddDatabaseAlias(Const AliasName,DriverName,Advanced,UID:String);
Procedure ModifyDatabaseAlias(Const AliasName,NewAliasName,DriverName,Advanced,UID:String);
Procedure RemoveDatabaseAlias(Const AliasName:String);


Function AllocateDBEnvironment(Var Procs:TDBProcs):SQLRETURN;
Procedure RegisterDBDrivers(IniName:String);
Procedure RegisterDBAliasNames(IniName:String);


Implementation


{*******************************************************************************************
 *                                                                                         *
 * Oracle7 section (native support)                                                        *
 *                                                                                         *
 *                                                                                         *
 *******************************************************************************************}

//Oracle 7 definitions

/*  internal/external datatype codes */
Const
     O7_VARCHAR2_TYPE          =  1;
     O7_NUMBER_TYPE            =  2;
     O7_INT_TYPE               =  3;
     O7_FLOAT_TYPE             =  4;
     O7_STRING_TYPE            =  5;
     O7_ROWID_TYPE             = 11;
     O7_DATE_TYPE              = 12;

     PARSE_NO_DEFER         = 0;
     PARSE_V7_LNG           = 2;

/*  ORACLE error codes used in demonstration programs */
Const
     VAR_NOT_IN_LIST       =1007;
     NO_DATA_FOUND         =1403;
     NULL_VALUE_RETURNED   =1405;

/*  some SQL and OCI function codes */
Const
     FT_INSERT             =   3;
     FT_SELECT             =   4;
     FT_UPDATE             =   5;
     FT_DELETE             =   9;

     FC_OOPEN              =  14;

/*
** Size of HDA area:
** 512 for 64 bit arquitectures
** 256 for 32 bit arquitectures
*/

Const HDA_SIZE =512;

Type
    eb1=Byte;        /* use where sign not important */
    ub1=Byte;       /* use where unsigned important */
    sb1=ShortInt;   /* use where   signed important */

Type
    eb2=Integer;   /* use where sign not important */
    ub2=Word;      /* use where unsigned important */
    sb2=Integer;   /* use where   signed important */

Type
    eb4=LongInt;   /* use where sign not important */
    ub4=LongWord;  /* use where unsigned important */
    sb4=LongInt;   /* use where   signed important */

Type
    dvoid=Pointer;

/* The cda_head struct is strictly PRIVATE.  It is used
   internally only. Do not use this struct in OCI programs. */

Type cda_head=record
                    v2_rc:sb2;
                    ft:ub2;
                    rpc:ub4;
                    peo:ub2;
                    fc:ub1;
                    rcs1:ub1;
                    rc:ub2;
                    wrn:ub1;
                    rcs2:ub1;
                    rcs3:LongInt;
                    rid:record
                        rd:record
                                 rcs4:ub4;
                                 rcs5:ub2;
                                 rcs6:ub1;
                        End;
                        rcs7:ub4;
                        rcs8:ub2;
                    End;
                    ose:LongInt;
                    rcsp:Pointer;
     End;

/* the real CDA, padded to 64 bytes in size */
Type
   cda_def=Record
                 v2_rc:sb2;                       /* V2 return code */
                 ft:ub2;                          /* SQL function type */
                 rpc:ub4;                         /* rows processed count */
                 peo:ub2;                         /* parse error offset */
                 fc:ub1;                          /* OCI function code */
                 rcs1:ub1;                        /* filler area */
                 rc:ub2;                          /* V7 return code */
                 wrn:ub1;                         /* warning flags */
                 rcs2:ub1;                        /* reserved */
                 rcs3:LongInt;                      /* reserved */
                 rid:record                       /* rowid structure */
                    rd:record
                             rcs4:ub4;
                             rcs5:ub2;
                             rcs6:ub1;
                    End;
                    rcs7:ub4;
                    rcs8:ub2;
                 End;
                 ose:LongInt;                       /* OSD dependent error */
                 rcsp:Pointer;                    /* pointer to reserved area */
                 rcs9:Array[0..((64 - sizeof (cda_head))-1)] Of ub1; /* filler to 64 */
   End;


/* the logon data area (LDA) is the same shape as the CDA */
Type Lda_Def=cda_def;

Const /* input data types */
     SQLT_CHR  =1;              /* (ORANET TYPE) character string */
     SQLT_NUM  =2;                /* (ORANET TYPE) oracle numeric */
     SQLT_INT  =3;                       /* (ORANET TYPE) integer */
     SQLT_FLT  =4;         /* (ORANET TYPE) Floating point number */
     SQLT_STR  =5;                      /* zero terminated string */
     SQLT_VNU  =6;              /* NUM with preceding length byte */
     SQLT_PDN  =7;        /* (ORANET TYPE) Packed Decimal Numeric */
     SQLT_LNG  =8;                                        /* long */
     SQLT_VCS  =9;                   /* Variable character string */
     SQLT_NON  =10;            /* Null/empty PCC Descriptor entry */
     SQLT_RID  =11;                                      /* rowid */
     SQLT_DAT  =12;                      /* date in oracle format */
     SQLT_VBI  =15;                       /* binary in VCS format */
     SQLT_BIN  =23;                        /* binary data(DTYBIN) */
     SQLT_LBI  =24;                                /* long binary */
     SQLT_UIN  =68;                           /* unsigned integer */
     SQLT_SLS  =91;              /* Display sign leading separate */
     SQLT_LVC  =94;                        /* Longer longs (char) */
     SQLT_LVB  =95;                         /* Longer long binary */
     SQLT_AFC  =96;                            /* Ansi fixed char */
     SQLT_AVC  =97;                              /* Ansi Var char */
     SQLT_LAB  =105;                                /* label type */
     SQLT_OSL  =106;                              /* oslabel type */

Type
    POracle7Func=^TOracle7Func;
    TOracle7Func=Record
                       obndra:Function(Var Cursor:cda_def;Var sqlvar:CString;sqlvl:LongInt;
                                       Var progv;progvl:LongInt;ftype:LongInt;scale:LongInt;
                                       Var indp:sb2;Var alen:ub2;Var arcode:ub2;maxsiz:ub4;
                                       Var cursiz:ub4;Var fmt:CString;fmtl:LongInt;fmtt:LongInt):LongInt;APIENTRY;
                       obndrv:Function(Var cursor:cda_def;Const sqlvar:CString;
                                       sqlvl:LongInt;Var progv;progvl:LongInt;
                                       ftype,scale:LongInt;
                                       Var indp:sb2;Const fmt:CString;
                                       fmtl,fmtt:LongInt):LongInt;APIENTRY;
                       ocan:Function(Var cursor:cda_def):LongInt;APIENTRY;
                       oclose:Function(Var cursor:cda_def):LongInt;APIENTRY;
                       ocof:Function(Var lda:cda_def):LongInt;APIENTRY;
                       ocom:Function(Var lda:cda_def):LongInt;APIENTRY;
                       ocon:Function(Var lda:cda_def):LongInt;APIENTRY;
                       odefin:Function(Var cursor:cda_def;pos:LongInt;Var buf;bufl:LongInt;ftype:LongInt;
                                       scale:LongInt;Var indp:sb2;Const fmt:CString;
                                       fmtl:LongInt;fmtt:LongInt;Var rlen:ub2;Var rcode:ub2):LongInt;APIENTRY;
                       odescr:Function(Var cursor:cda_def;pos:LongInt;Var dbsize:sb4;
                                       Var dbtype:sb2;Var cbuf:CString;Var cbufl:sb4;Var dsize:sb4;
                                       Var prec:sb2;Var scale:sb2;Var nullok:sb2):LongInt;APIENTRY;
                       oerhms:Function(Var lda:cda_def;rcode:sb2;Var buf:CString;bufsiz:LongInt):LongInt;APIENTRY;
                       oexec:Function(Var cursor:cda_def):LongInt;APIENTRY;
                       ofetch:Function(Var cursor:cda_def):LongInt;APIENTRY;
                       ologof:Function(Var lda:cda_def):LongInt;APIENTRY;
                       olon:Function(Var lda:cda_def;uid:CString;uidl:LongInt;
                                     pswd:CString;pswdl:LongInt;audit:LongInt):LongInt;APIENTRY;
                       oopen:Function(Var cursor:cda_def;Var lda:cda_def;
                                      Const dbn:CString;dbnl:LongInt;arsize:LongInt;
                                      Const uid:CString;uidl:LongInt):LongInt;APIENTRY;
                       oparse:Function(Var cursor:cda_def;Const sqlstm:CString;sqllen:sb4;
                                       defflg:LongInt;lngflg:ub4):LongInt;APIENTRY;

                       orlon:Function(Var lda:cda_def;Var hda:ub1;uid:CString;
                                      uidl:LongInt;Const pswd:CString;pswdl:LongInt;audit:LongInt):LongInt;APIENTRY;
                       orol:Function(Var lda:cda_def):LongInt;APIENTRY;
                       odessp:Function(Var lda:lda_def;Const ProcName:CString;ProcNameLen:LongInt;
                                       Var rsv1;rsv1ln:LongInt;Var rsv2;rsv2ln:LongInt;Var ovrld,pos,
                                       level,argnm,arnlen,dtype,defsup,mode,
                                       dtsiz,prec,scale,radix,sparem,arrsiz):LongInt;APIENTRY;

                       lda:cda_def;
                       hda:Array[0..HDA_SIZE] Of ub1;
                       aDBProcs:PDBProcs;
                       Connected:Boolean;
    End;

    P_henv=POracle7Func;

    P_hdbc=P_henv;

    P_hstmt=^T_hstmt;
    T_hstmt=Record
                 ahdbc:P_hdbc;
                 cda:cda_def;
                 CursorValid:Boolean;
                 Executed:Boolean;
                 ColList:TList;
    End;

    P_stmtcol=^T_stmtcol;
    T_stmtcol=Record
                   dbsize:sb4;
                   dbtype:sb2;
                   ColName:CString;
                   dsize:sb4;
                   precision:sb2;
                   scale:sb2;
                   Nullok:sb2;
                   Data:Pointer;
                   DataLen:LongInt;
                   OutLen:ub2;
                   BindVar:Pointer;
                   BindVarMax:LongInt;
                   BindType:LongInt;
                   pcbValue:^SQLINTEGER;
    End;

Function MapODBCTypes(oratyp:sb2):SQLSMALLINT;
Begin
     Case oratyp Of
         SQLT_CHR:Result:=SQL_VARCHAR;
         SQLT_NUM:Result:=SQL_INTEGER;
         SQLT_INT:Result:=SQL_INTEGER;
         SQLT_FLT:Result:=SQL_FLOAT;
         SQLT_STR:Result:=SQL_CHAR;
         SQLT_LNG:Result:=SQL_LONGVARBINARY;
         SQLT_VCS:Result:=SQL_VARCHAR;
         SQLT_VBI:Result:=SQL_VARBINARY;
         SQLT_BIN:Result:=SQL_BINARY;
         SQLT_LBI:Result:=SQL_LONGVARBINARY;
         SQLT_UIN:Result:=SQL_INTEGER;
         SQLT_LVC:Result:=SQL_LONGVARCHAR;
         SQLT_DAT:Result:=SQL_TIMESTAMP;
         Else Result:=SQL_VARCHAR;
     End; //case
End;

Function MapOracleTypes(oratyp:SQLSMALLINT):sb2;
Begin
     Case oratyp Of
         SQL_C_CHAR:Result:=SQLT_STR;
         SQL_C_LONG,SQL_C_SHORT:Result:=SQLT_INT;
         SQL_C_FLOAT:Result:=SQLT_FLT;
         SQL_C_BINARY:Result:=SQLT_BIN;
         SQL_C_TIMESTAMP:Result:=SQLT_DAT;
         Else Result:=SQLT_STR;
     End; //case
End;

{$HINTS OFF}
Function Oracle7_SQLAllocConnect(ahenv:SQLHENV;Var phdbc:SQLHDBC):SQLRETURN;APIENTRY;
Begin
     phdbc:=SQLHDBC(ahenv);
     Result:=SQL_SUCCESS;
End;

Function Oracle7_SqlConnect(ahdbc:SQLHDBC;Const szDSN:SQLCHAR;
                            cbDSN:LongInt;Const szUID:SQLCHAR;
                            cbUID:LongInt;Const szAuthString:SQLCHAR;
                            cbAuthString:LongInt):SQLRETURN;APIENTRY;
Var hdbc:P_hdbc;
    s,s1:String;
    UID_DSN:CString;
    UID,DSN:^Pointer;
Begin
     {$IFDEF OS2}
     ASM
        xor eax,eax
        db $64,$ff,$30  //pushd fs:[eax]
     END;
     {$ENDIF}

     hdbc:=PDBProcs(ahdbc)^.FuncTable;
     UID:=@szUID;
     DSN:=@szDSN;
     If UID=Nil Then s:=''
     Else s:=szUID;
     If DSN=Nil Then s1:=''
     Else s1:=szDSN;
     UID_DSN:=s+'@'+s1;
     if hdbc^.orlon(hdbc^.lda,hdbc^.hda[0],UID_DSN,-1,szAuthString,-1,0)<>0 Then Result:=SQL_ERROR
     Else
     Begin
          hdbc^.Connected:=True;
          Result:=SQL_SUCCESS;
     End;

     {$IFDEF OS2}
     ASM
        xor eax,eax
        db $64,$8f,$00  //popd fs:[eax]
     END;
     {$ENDIF}
End;

Function Oracle7_SQLDataSources(ahenv:SQLHENV;fDirection:LongWord;
                                Var szDSN:SQLCHAR;cbDSNMax:LongInt;
                                Var pcbDSN:SQLSMALLINT;
                                Var szDescription:SQLCHAR;cbDescriptionMax:LongInt;
                                Var pcbDescription:SQLSMALLINT):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function Oracle7_SQLSetConnectOption(ahdbc:SQLHDBC;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
Var hdbc:P_hdbc;
Begin
   If ahdbc=0 Then
   Begin
        Result:=SQL_ERROR;
        exit;
   End;

   hdbc:=PDBProcs(ahdbc)^.FuncTable;

   Result:=SQL_SUCCESS;
   Case fOption Of
      SQL_AUTOCOMMIT:
      Begin
           Case vParam Of
              SQL_AUTOCOMMIT_OFF:hdbc^.ocon(hdbc^.lda);
              SQL_AUTOCOMMIT_ON:hdbc^.ocof(hdbc^.lda);
              Else Result:=SQL_ERROR; //driver not capable
           End; //case
      End;
      Else Result:=SQL_ERROR; //driver not capable
    End; //case
End;

Function Oracle7_SQLSetStmtOption(ahstmt:SQLHSTMT;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function Oracle7_SQLAllocStmt(ahdbc:SQLHDBC;Var phstmt:SQLHSTMT):SQLRETURN;APIENTRY;
Var stmt:P_hstmt;
Begin
     new(stmt);
     stmt^.ahdbc:=PDBProcs(ahdbc)^.FuncTable;
     If stmt^.ahdbc^.oopen(stmt^.cda,stmt^.ahdbc^.lda,Nil,-1,-1,Nil,-1)<>0 Then
     Begin
          Dispose(stmt);
          phstmt:=0;
          Result:=SQL_ERROR;
     End
     Else
     Begin
          stmt^.CursorValid:=True;
          stmt^.ColList.Create;
          phstmt:=SQLHSTMT(stmt);
          Result:=SQL_SUCCESS;
     End;
End;

Function Oracle7_SQLBindParameter(ahstmt:SQLHSTMT;ipar:LongWord;fParamType:LongInt;
                                  fCType:LongInt;fSQLType:LongInt;cbParamDef:SQLUINTEGER;
                                  ibScale:LongInt;Var rgbValue;cbValueMax:SQLINTEGER;
                                  Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
Var s:String;
    stmt:P_hstmt;
    c:CString;
Begin
     stmt:=P_hstmt(ahstmt);
     If fParamType=SQL_PARAM_RESULT Then s:=':p0'
     Else s:=':p'+tostr(ipar);
     c:=s;
     If pcbValue=SQL_NTS Then pcbValue:=255; //String

     If stmt^.ahdbc^.obndrv(stmt^.cda,c,-1,rgbValue,pcbValue,
                            MapOracleTypes(fcType),-1,
                            Nil,Nil,0,0)<>0 Then
       Result:=SQL_ERROR
     Else
       Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLGetCursorName(ahstmt:SQLHSTMT;Var szCursor:SQLCHAR;cbCursorMax:LongInt;
                                  Var pcbCursor:SQLSMALLINT):SQLRETURN;APIENTRY;
Begin
     szCursor:='';
     pcbCursor:=0;
     Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLExecDirect(ahstmt:SQLHSTMT;Var szSqlStr:SQLCHAR;cbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;
Var stmt:P_hstmt;
    t:LongInt;
    col:P_stmtcol;
    ColNameLen:LongInt;
    typ:LongInt;
Label float;
Begin
     stmt:=P_hstmt(ahstmt);
     stmt^.Executed:=False;
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;

     if stmt^.ahdbc^.oparse(stmt^.cda,szSqlStr,-1,1{PARSE_NO_DEFER},PARSE_V7_LNG)<>0 Then Result:=SQL_ERROR
     Else
     Begin
          Result:=SQL_SUCCESS;

          //describe result cols and store it into stmt
          For t:=1 To stmt^.ColList.Count-1 Do
          Begin
              col:=stmt^.ColList[t];
              If col^.DataLen>0 Then FreeMem(col^.Data,col^.DataLen);
              Dispose(col);
          End;
          stmt^.ColList.Clear;

          Result:=SQL_SUCCESS;
          If stmt^.cda.ft=FT_SELECT Then
          Begin
               //describe cols
               t:=1;
               Repeat
                    //describe one row
                    New(Col);

                    ColNameLen:=255;
                    If stmt^.ahdbc^.odescr(stmt^.cda,t,col^.dbsize,col^.dbtype,col^.ColName,
                                           ColNameLen,Col^.dsize,col^.precision,
                                           Col^.scale,Col^.nullok)<>0 Then
                    Begin
                         If stmt^.cda.rc=VAR_NOT_IN_LIST Then
                         Begin
                              Dispose(Col);
                              break;
                         End
                         Else
                         Begin
                              Dispose(Col);
                              Result:=SQL_ERROR;
                              break;
                         End;
                    End
                    Else
                    Begin
                         col^.ColName[ColNameLen]:=#0;
                         stmt^.ColList.Add(Col);
                    End;

                    inc(t);
               Until False;

               //bind params
               If Result<>SQL_ERROR Then For t:=1 To stmt^.ColList.Count Do
               Begin
                    col:=stmt^.ColList[t-1];

                    Case col^.dbType Of
                        SQLT_NUM,SQLT_INT,SQLT_UIN:
                        Begin
                            If Col^.Scale<>0 Then goto float;
                            If ((Col^.Precision=0)And(Col^.Scale=0)) Then goto float;

                            Col^.DataLen:=4;
                            typ:=SQLT_INT;
                        End;
                        SQLT_CHR,SQLT_STR,SQLT_VCS,SQLT_LVC:
                        Begin
                            Col^.DataLen:=col^.dbSize+1;
                            typ:=SQLT_STR;
                        End;
                        SQLT_FLT:
                        Begin
float:
                             Col^.DataLen:=8;
                             typ:=SQLT_FLT;
                        End;
                        SQLT_VBI,SQLT_BIN,SQLT_LBI,SQLT_LNG:
                        Begin
                             Col^.DataLen:=col^.dbSize;
                             typ:=SQLT_BIN;
                        End;
                        SQLT_DAT:
                        Begin
                             Col^.DataLen:=col^.dbSize;
                             typ:=SQLT_DAT;
                        End;
                        SQLT_RID:
                        Begin
                             Col^.DataLen:=255;
                             typ:=SQLT_STR;
                        End;
                    End; //case

                    GetMem(col^.Data,col^.DataLen);

                    Col^.OutLen:=0;
                    if stmt^.ahdbc^.odefin(stmt^.cda,t,col^.data^,col^.datalen,Typ,-1,Nil,Nil,-1,-1,col^.OutLen,Nil)<>0 Then
                      Result:=SQL_ERROR
                    Else
                      Result:=SQL_SUCCESS;
               End;
          End
          Else
          Begin
               If stmt^.ahdbc^.aDBProcs^.IsStoredProc Then exit;

               If stmt^.ahdbc^.oexec(stmt^.cda)<>0 Then
               Begin
                    Result:=SQL_ERROR;
                    exit;
               End;
               stmt^.Executed:=True;
          End;
     End;
End;

Function Oracle7_SQLNumParams(ahstmt:SQLHSTMT;Var pcpar:SQLSMALLINT):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function Oracle7_SQLNumResultCols(ahstmt:SQLHSTMT;Var pccol:SQLSMALLINT):SQLRETURN;APIENTRY;
Begin
     pccol:=P_hstmt(ahstmt)^.ColList.Count;
     Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLDescribeCol(ahstmt:SQLHSTMT;icol:LongWord;Var szColName:SQLCHAR;
                                cbColNameMax:LongInt;Var pcbColName:SQLSMALLINT;
                                Var pfSqlType:SQLSMALLINT;Var pcbColDef:SQLUINTEGER;
                                Var pibScale:SQLSMALLINT;Var pfNullable:SQLSMALLINT):SQLRETURN;APIENTRY;
Var stmt:P_hstmt;
    Col:P_stmtcol;
    p:^Pointer;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;
     dec(icol);
     If icol>stmt^.ColList.Count-1 Then Result:=SQL_ERROR
     Else
     Begin
          Result:=SQL_SUCCESS;

          Col:=stmt^.ColList[icol];
          szColName:=Col^.ColName;
          pcbColName:=length(szColName)+1;
          pfSqlType:=MapODBCTypes(Col^.dbType);
          If pfSqlType In [SQL_INTEGER,SQL_FLOAT] Then
          Begin
              pcbColDef:=Col^.Precision;
              pibScale:=Col^.Scale;
          End
          Else
          Begin
              If Col^.dbType=O7_DATE_TYPE Then pcbColDef:=12
              Else pcbColDef:=Col^.dbSize;
              pibScale:=0;
          End;
          If Col^.dbType=O7_NUMBER_TYPE Then
          Begin
               If pibScale=0 Then
               Begin
                    If pcbColDef=0 Then pfSQLType:=SQL_FLOAT
                    Else pfSQLType:=SQL_INTEGER
               End
               Else pfSQLType:=SQL_FLOAT;
          End;
          p:=@pfNullable;
          If p<>Nil Then
          Begin
               If Col^.NullOk<>0 Then pfNullable:=SQL_NULLABLE
               Else pfNullable:=SQL_NO_NULLS;
          End;
     End;
End;

Function Oracle7_SQLBindCol(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;Var rgbValue;
                            cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
Var
    stmt:P_hstmt;
    Col:P_stmtcol;
Begin
     stmt:=P_hstmt(ahstmt);
     dec(icol);
     If icol>stmt^.ColList.Count-1 Then Result:=SQL_Error
     Else
     Begin
          Col:=stmt^.ColList[icol];
          Col^.BindVar:=@rgbValue;
          Col^.BindVarMax:=cbValueMax;
          Col^.BindType:=fCType;
          Col^.pcbValue:=@pcbValue;
          Result:=SQL_SUCCESS;
     End;
End;

Function Oracle7_SQLGetData(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;
                            Var rgbValue;cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
Var Col:P_stmtcol;
    stmt:P_hstmt;
    pc:PChar;
    pl:^LongInt;
    pd:^Double;
    s:String;
    c:CString;
    ss:single;
    d:double;
    e:extended;
    p:Pointer;
Label float;
Type OracleDateRec=Record
        Cent,Year,Month,Day,Hour,Minute,Second:Byte;
     End;

Var ODate:^OracleDateRec;
    date:TODBCDate;
    time:TODBCTime;
    dateTime:TODBCDateTime;
    year,month,day,hour,minute,second:word;
Begin
     Result:=SQL_ERROR;

     stmt:=P_hstmt(ahstmt);
     dec(icol);
     If icol>stmt^.ColList.Count-1 Then exit;

     Col:=stmt^.ColList[icol];
     pcbValue:=Col^.OutLen;

     If pcbValue>0 Then //No Null datas
     Case Col^.dbType Of
        SQLT_CHR,SQLT_STR,SQLT_VCS,SQLT_LVC,SQLT_RID:
        Begin
             inc(pcbValue);
             pc:=Col^.Data;

             Case fcType Of
                SQL_C_CHAR,SQL_C_DEFAULT:
                Begin
                     If pcbValue<cbValueMax Then Move(pc^,rgbValue,pcbValue)
                     Else
                     Begin
                          Move(pc^,rgbValue,cbValueMax);
                          pcbValue:=cbValueMax;
                     End;
                End;
             End; //case
        End;
        SQLT_NUM,SQLT_INT,SQLT_UIN:
        Begin
             If Col^.Scale<>0 Then goto float;
             If ((Col^.Precision=0)And(Col^.Scale=0)) Then goto float;

             pl:=Col^.Data;
             Case fcType Of
                SQL_C_DEFAULT:
                Begin
                     Move(pl^,rgbValue,cbValueMax);
                     pcbValue:=cbValueMax;
                End;
                SQL_C_LONG,SQL_C_SLONG,SQL_C_ULONG:
                Begin
                     Move(pl^,rgbValue,4);
                     pcbValue:=4;
                End;
                SQL_C_SHORT,SQL_C_SSHORT,SQL_C_USHORT:
                Begin
                     Move(pl^,rgbValue,cbValueMax);
                     pcbValue:=cbValueMax;
                End;
                SQL_C_CHAR:
                Begin
                    s:=tostr(pl^);
                    c:=s;
                    Move(c,rgbValue,length(c)+1);
                    pcbValue:=length(c)+1;
                End;
                SQL_C_FLOAT:
                Begin
                     d:=pl^;
                     p:=@d;
                     Move(p^,rgbValue,8);
                     pcbValue:=8;
                End;
                SQL_C_DOUBLE:
                Begin
                     e:=pl^;
                     p:=@e;
                     Move(p^,rgbValue,10);
                     pcbValue:=10;
                End;
             End; //case
        End;
        SQLT_FLT:
        Begin
float:
             pd:=Col^.Data;
             Case fcType Of
                SQL_C_DEFAULT:
                Begin
                     Case cbValueMax Of
                         4:
                         Begin
                              ss:=pd^;
                              p:=@ss;
                              Move(p^,rgbValue,4);
                              pcbValue:=4;
                         End;
                         8:
                         Begin
                              d:=pd^;
                              p:=@d;
                              Move(p^,rgbValue,8);
                              pcbValue:=8;
                         End;
                         Else
                         Begin
                              e:=pd^;
                              p:=@e;
                              Move(p^,rgbValue,10);
                              pcbValue:=10;
                         End;
                     End; //case
                End;
                SQL_C_FLOAT:
                Begin
                     ss:=pd^;
                     p:=@ss;
                     Move(p^,rgbValue,4);
                     pcbValue:=4;
                End;
                SQL_C_DOUBLE:
                Begin
                     d:=pd^;
                     p:=@d;
                     Move(p^,rgbValue,8);
                     pcbValue:=8;
                End;
                SQL_C_CHAR:
                Begin
                     Str(pd^,s);
                     c:=s;
                     Move(c,rgbValue,length(c)+1);
                     pcbValue:=length(c)+1;
                End;
             End; //case
        End;
        SQLT_VBI,SQLT_BIN,SQLT_LBI,SQLT_LNG:
        Begin
             If pcbValue<cbValueMax Then Move(Col^.Data^,rgbValue,pcbValue)
             Else
             Begin
                  Move(Col^.Data^,rgbValue,cbValueMax);
                  pcbValue:=cbValueMax;
             End;
        End;
        SQLT_DAT:
        Begin
            ODate:=Col^.Data;

            If pcbValue<>7 Then //no internal Oracle format
            Begin
                 Result:=SQL_ERROR;
                 exit;
            End;

            year:=((ODate^.Cent-100)*100)+ODate^.Year-100;
            month:=ODate^.month;
            day:=ODate^.Day;
            Hour:=ODate^.Hour-1;
            Minute:=ODate^.Minute-1;
            Second:=ODate^.Second-1;

            Case fcType Of
               SQL_C_DATE:
               Begin
                    date.year:=year;
                    date.month:=month;
                    date.day:=day;
                    pcbValue:=sizeof(TODBCDate);
                    Move(Date,rgbValue,pcbValue);
               End;
               SQL_C_TIME:
               Begin
                    time.Hour:=hour;
                    time.minute:=minute;
                    time.second:=second;
                    pcbValue:=sizeof(TODBCTime);
                    Move(Time,rgbValue,pcbValue);
               End;
               SQL_C_TIMESTAMP,SQL_C_DEFAULT:
               Begin
                    datetime.Date.year:=year;
                    datetime.Date.month:=month;
                    datetime.Date.day:=day;
                    datetime.Time.Hour:=hour;
                    datetime.Time.minute:=minute;
                    datetime.Time.second:=second;
                    pcbValue:=sizeof(TODBCDateTime);
                    Move(DateTime,rgbValue,pcbValue);
               End;
               Else //invalid conversion
               Begin
                    Result:=SQL_ERROR;
                    exit;
               End;
            End; //case
        End;
     End; //case

     If pcbValue=0 Then pcbValue:=SQL_NULL_DATA;
     Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLFetch(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
var stmt:P_hstmt;
    t:LongInt;
    Col:P_stmtcol;
Begin
     stmt:=P_hstmt(ahstmt);
     If not (stmt^.Executed) Then
     Begin
          If stmt^.ahdbc^.oexec(stmt^.cda)<>0 Then
          Begin
               Result:=SQL_ERROR;
               exit;
          End;
          stmt^.Executed:=True;
     End;

     If stmt^.ahdbc^.aDBProcs^.IsStoredProc Then
     Begin
          Result:=SQL_SUCCESS;
          exit;
     End;

     If stmt^.ahdbc^.ofetch(stmt^.cda)<>0 Then
     Begin
          If stmt^.cda.rc=NO_DATA_FOUND Then Result:=SQL_NO_DATA_FOUND
          Else If stmt^.cda.rc<>NULL_VALUE_RETURNED Then Result:=SQL_ERROR
          Else Result:=SQL_SUCCESS;
     End
     Else Result:=SQL_SUCCESS;

     If Result=SQL_SUCCESS Then
     Begin
          //store result into bound variables
          For t:=0 To stmt^.ColList.Count-1 Do
          Begin
               Col:=stmt^.ColList[t];

               If Col^.BindVar<>Nil Then
               Begin
                    Result:=Oracle7_SQLGetData(ahstmt,t+1,Col^.BindType,Col^.BindVar^,Col^.BindVarMax,
                                               Col^.pcbValue^);
               End;
          End;
     End;
End;

Function Oracle7_SQLExtendedFetch(ahstmt:SQLHSTMT;fFetchType:LongWord;irow:SQLINTEGER;
                                  Var pcrow:SQLUINTEGER;Var rgfRowStatus):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function Oracle7_SQLError(ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT;Var szSqlState:SQLCHAR;
                          Var pfNativeError:SQLINTEGER;Var szErrorMsg;
                          cbErrorMsgMax:LongInt;Var pcbErrorMsg:SQLSMALLINT):SQLRETURN;APIENTRY;
Var Msg:CString;
    henv:P_henv;
    stmt:P_hstmt;
Begin
     henv:=PDBProcs(ahenv)^.FuncTable;
     stmt:=P_hstmt(ahstmt);

     pfNativeError:=henv^.lda.rc;
     If henv^.lda.rc=0 Then
     Begin
          If ((stmt=Nil)Or(stmt^.cda.rc=0)) Then Msg:='Driver not capable'
          Else
          Begin
               henv^.oerhms(henv^.lda,stmt^.cda.rc,Msg,sizeof(msg));
               pfNativeError:=stmt^.cda.rc;
          End;
     End
     Else henv^.oerhms(henv^.lda,henv^.lda.rc,Msg,sizeof(msg));
     pcbErrorMsg:=length(Msg)+1;
     Move(Msg,szErrorMsg,length(Msg)+1);
     szSQLState:='[Sibyl Oracle7 driver] SQLSTATE:'+tostr(pfNativeError);
     Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLPrimaryKeys(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                                Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                                Const szTableName:SQLCHAR;cbTableName:LongInt):SQLRETURN;APIENTRY;
Var Ansi:AnsiString;
    stmt:P_hstmt;
    s:String;
    p:Pointer;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;
     p:=@szTableName;
     If p=Nil Then s:=''
     Else s:=szTableName;
     If Pos('.',s)<>0 Then Delete(s,1,pos('.',s));
     Ansi:='SELECT I.TABLE_OWNER,I.TABLE_OWNER,I.TABLE_NAME,I.COLUMN_NAME FROM CONSTRAINT_DEFS D,'+
           'ALL_IND_COLUMNS I WHERE D.OWNER<>'#39'SYS'#39' AND D.CONSTRAINT_NAME=I.INDEX_NAME';
     If s<>'' Then Ansi:=Ansi+' AND I.TABLE_NAME='#39+s+#39;
     Result:=Oracle7_SqlExecDirect(ahstmt,PChar(Ansi)^,length(PChar(Ansi)^)+1);
End;

Function Oracle7_SQLForeignKeys(ahstmt:SQLHSTMT;Const szPkCatalogName:SQLCHAR;cbPkCatalogName:LongInt;
                                Const szPkSchemaName:SQLCHAR;cbPkSchemaName:LongInt;
                                Const szPkTableName:SQLCHAR;cbPkTableName:LongInt;
                                Const szFkCatalogName:SQLCHAR;cbFkCatalogName:LongInt;
                                Const szFkSchemaName:SQLCHAR;cbFkSchemaName:LongInt;
                                Const szFkTableName:SQLCHAR;cbFkTableName:LongInt):SQLRETURN;APIENTRY;
Var Ansi:AnsiString;
    stmt:P_hstmt;
    s:String;
    p:Pointer;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;
     p:=@szFkTableName;
     If p=Nil Then s:=''
     Else s:=szFkTableName;
     If Pos('.',s)<>0 Then Delete(s,1,pos('.',s));
     Ansi:='SELECT I.TABLE_OWNER,I.TABLE_OWNER,I.TABLE_NAME,I.COLUMN_NAME,D.OWNER,D.OWNER,D.TABLE_NAME,C.COLUMN_NAME ';
     Ansi:=Ansi+'FROM CONSTRAINT_DEFS D,ALL_CONS_COLUMNS C,ALL_IND_COLUMNS I ';
     Ansi:=Ansi+' WHERE D.OWNER<>'#39'SYS'#39' AND D.OWNER<>'#39'SYSTEM'#39' ';
     Ansi:=Ansi+' AND D.R_CONSTRAINT_NAME=I.INDEX_NAME AND D.CONSTRAINT_NAME=C.CONSTRAINT_NAME';
     If s<>'' Then Ansi:=Ansi+' AND D.TABLE_Name='#39+s+#39;
     Result:=Oracle7_SqlExecDirect(ahstmt,PChar(Ansi)^,length(PChar(Ansi)^)+1);
End;

Function Oracle7_SQLProcedureColumns(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                                     Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                                     Const szProcName:SQLCHAR;cbProcName:LongInt;
                             Const szColumnName:SQLCHAR;cbColumnName:LongInt):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function Oracle7_SQLProcedures(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                               Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                               Const szProcName:SQLCHAR;cbProcName:LongInt):SQLRETURN;APIENTRY;
VAR C:CString;
    stmt:P_hstmt;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;
     C:='SELECT OWNER,OWNER,OBJECT_NAME FROM ALL_OBJECTS WHERE OBJECT_TYPE='#39'PROCEDURE'#39+
        ' OR OBJECT_TYPE='#39'FUNCTION'#39;
     Result:=Oracle7_SqlExecDirect(ahstmt,c,length(c)+1);
End;

Function Oracle7_SQLStatistics(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                               Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                               Const szTableName:SQLCHAR;cbTableName:LongInt;
                               fUnique:LongWord;fAccuracy:LongWord):SQLRETURN;APIENTRY;
Var Name,Qual:String;
    s:AnsiString;
    stmt:P_hstmt;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;

     Name:=szTableName;
     UpcaseStr(Name);
     If Pos('.',Name)<>0 Then
     Begin
          Qual:=Copy(Name,1,pos('.',Name)-1);
          Delete(Name,1,pos('.',Name));
     End
     Else Qual:='';

     s:='SELECT TABLE_OWNER,TABLE_OWNER,TABLE_NAME,TABLE_NAME,INDEX_OWNER,INDEX_NAME';
     s:=s+' INDEX_NAME,COLUMN_POSITION,COLUMN_NAME,COLUMN_NAME FROM ALL_IND_COLUMNS';
     If Qual<>'' Then
       s:=s+' WHERE TABLE_OWNER='#39+Qual+#39+' AND TABLE_NAME='#39+Name+#39
     Else If Name<>'' Then
       s:=s+' WHERE TABLE_NAME='#39+Name+#39;
     Result:=Oracle7_SqlExecDirect(ahstmt,PChar(s)^,SQL_NTS);
End;

Function Oracle7_SQLTables(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                           Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                           Const szTableName:SQLCHAR;cbTableName:LongInt;
                           Const szTableType:SQLCHAR;cbTableType:LongInt):SQLRETURN;APIENTRY;
Var s:String;
    c:CString;
    p:Pointer;
    stmt:P_hstmt;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;
     s:='SELECT OWNER,OWNER,TABLE_NAME,TABLE_TYPE FROM ALL_CATALOG';
     If szTableType='SYSTEM TABLE' Then
     Begin
          s:=s+' WHERE TABLE_TYPE='#39'TABLE'#39;
          s:=s+' AND OWNER='#39'SYS'#39'OR OWNER='#39'SYSTEM'#39;
     End
     Else
     Begin
          s:=s+' WHERE TABLE_TYPE='+#39+szTableType+#39;
          s:=s+' AND OWNER<>'#39'SYSTEM'#39' AND OWNER<>'#39'SYS'#39;
     End;
     p:=@szSchemaName;
     If p<>Nil Then s:=s+' AND OWNER='+#39+szSchemaName+#39;
     p:=@szTableName;
     If p<>Nil Then s:=s+' AND TABLE_NAME='+#39+szTableName+#39;

     c:=s;
     Result:=Oracle7_SqlExecDirect(ahstmt,c,length(c)+1);
End;

Function Oracle7_SQLFreeStmt(ahstmt:SQLHSTMT;fOption:LongWord):SQLRETURN;APIENTRY;
Var stmt:P_hstmt;
    t:LongInt;
    col:P_stmtcol;
Begin
     stmt:=P_hstmt(ahstmt);
     stmt^.Executed:=False;
     For t:=1 To stmt^.ColList.Count-1 Do
     Begin
         col:=stmt^.ColList[t];
         If col^.DataLen>0 Then FreeMem(Col^.Data,Col^.datalen);
         Dispose(col);
     End;
     stmt^.ColList.Clear;

     If stmt^.CursorValid Then
     Begin
          If stmt^.ahdbc^.oclose(stmt^.cda)<>0 Then
          Begin
               Result:=SQL_ERROR;
               exit;
          End;
          stmt^.CursorValid:=False;
     End;

     Case fOption Of
        SQL_CLOSE:;
        Else
        Begin
            stmt^.ColList.Destroy;
            Dispose(stmt);
        End;
     End;

     Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLCancel(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
Var stmt:P_hstmt;
Begin
     stmt:=P_hstmt(ahstmt);
     If stmt^.ahdbc^.ocan(stmt^.cda)<>0 Then Result:=SQL_ERROR
     Else Result:=Oracle7_SQLFreeStmt(ahstmt,SQL_CLOSE);
End;

Function Oracle7_SQLTransact(ahenv:SQLHENV;ahdbc:SQLHDBC;fType:LongWord):SQLRETURN;APIENTRY;
Var henv:P_henv;
Begin
    Result:=SQL_SUCCESS;
    henv:=PDBProcs(ahenv)^.FuncTable;
    Case fType Of
      SQL_COMMIT:If henv^.ocom(henv^.lda)<>0 Then Result:=SQL_ERROR;
      SQL_ROLLBACK:If henv^.orol(henv^.lda)<>0 Then Result:=SQL_ERROR;
      Else Result:=SQL_ERROR;
    End;
End;

Function Oracle7_SQLDisconnect(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
Var hdbc:P_hdbc;
Begin
     hdbc:=PDBProcs(ahdbc)^.FuncTable;
     If hdbc^.ologof(hdbc^.lda)<>0 Then Result:=SQL_ERROR
     Else
     Begin
          hdbc^.Connected:=False;
          Result:=SQL_SUCCESS;
     End;
End;

Function Oracle7_SQLFreeConnect(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_SUCCESS;
End;

Function Oracle7_SQLFreeEnv(ahenv:SQLHENV):SQLRETURN;APIENTRY;
Var env:P_henv;
Begin
     If ahenv=0 Then
     Begin
          Result:=SQL_ERROR;
          exit;
     End;

     env:=PDBProcs(ahenv)^.FuncTable;
     If env=Nil Then Result:=SQL_ERROR
     Else
     Begin
          If ((env^.Connected)And(env^.ologof(env^.lda)<>0)) Then Result:=SQL_ERROR
          Else Result:=SQL_SUCCESS;
     End;
End;

Function Oracle7_GetProcParams(Const Name:String;DBProcs:PDBProcs;ParamName:TStrings;ParamType,ParamMode:TList):Boolean;
Var env:P_henv;
Const ASIZE=50;
Var ovrld:Array[0..ASIZE] Of ub2;
    pos:Array[0..ASIZE] Of ub2;
    level:Array[0..ASIZE] Of ub2;
    argnm:Array[0..ASIZE] Of CString[29];
    arnlen:Array[0..ASIZE] Of ub2;
    dtype:Array[0..ASIZE] Of ub2;
    defsup:Array[0..ASIZE] Of ub1;
    mode:Array[0..ASIZE] Of ub1;
    dtsize:Array[0..ASIZE] Of ub4;
    prec:Array[0..ASIZE] Of sb2;
    scale:Array[0..ASIZE] Of sb2;
    radix:Array[0..ASIZE] Of ub1;
    spare:Array[0..ASIZE] Of ub4;
    arrsiz:ub4;
    rc:sword;
    t,c:LongInt;
    s:string;
Begin
     If DBProcs^.ahenv=0 Then
     Begin
          Result:=False;
          exit;
     End;

     env:=PDBProcs(DBProcs^.ahenv)^.FuncTable;
     arrsiz:=ASIZE;
     env^.odessp(env^.lda,Name,-1,Nil,0,Nil,0,ovrld,
                 pos,level,argnm,arnlen,dtype,
                 defsup,mode,dtsize,prec,scale,radix,
                 spare,arrsiz);
     if ((env^.lda.rc=0)and(arrsiz<50)) then
     Begin
          Result:=True;
          For t:=0 To arrsiz-1 Do
          Begin
               move(argnm[t],s[1],arnlen[t]);
               s[0]:=chr(arnlen[t]);
               If s[length(s)]=#0 Then
                If length(s)>0 Then dec(s[0]);
               ParamName.Add(s);
               c:=MapOdbcTypes(dtype[t]);
               ParamType.Add(Pointer(c));
               c:=mode[t];
               if pos[t]=0 Then //result
                 c:=c+16;
               ParamMode.Add(Pointer(c));
          End;
     End
     Else Result:=False;
End;
{$HINTS OFF}


{*******************************************************************************************
 *                                                                                         *
 * mSQL section (native support)                                                           *
 *                                                                                         *
 *                                                                                         *
 *******************************************************************************************}

Type m_row=Pointer;

     Pm_field=^m_field;
     m_field=Record
                   Name:PChar;
                   Table:PChar;
                   Typ:LongInt;
                   len:LongInt;
                   Flags:LongInt;
             End;

     Pm_data=^m_data;
     m_data=Record
                  width:LongInt;
                  data:m_row;
                  next:Pm_data;
            End;

     Pm_fdata=^m_fdata;
     m_fdata=Record
                   field:m_field;
                   next:Pm_fdata;
             End;

     Pm_result=^m_result;
     m_result=Record
                    queryData:Pm_Data;
                    Cursor:Pm_Data;
                    FieldData:Pm_fdata;
                    FieldCursor:Pm_fdata;
                    numRows:LongInt;
                    NumFields:LongInt;
              End;


Const
    INT_TYPE        =1;
    CHAR_TYPE       =2;
    REAL_TYPE       =3;
    IDENT_TYPE      =4;
    NULL_TYPE       =5;
    TEXT_TYPE       =6;
    DATE_TYPE       =7;
    UINT_TYPE       =8;
    MONEY_TYPE      =9;
    TIME_TYPE       =10;
    LAST_REAL_TYPE  =10;
    IDX_TYPE        =253;
    SYSVAR_TYPE     =254;
    ANY_TYPE        =255;

//Field flags
Const
    NOT_NULL_FLAG   =1;
    UNIQUE_FLAG     =2;

Type PmSQLFunc=^TmSQLFunc;
     TmSQLFunc=Record
                   msqlGetErrMsg:Function(Var Buffer):PChar;APIENTRY;
                   msqlUserConnect:Function(Host,User:PChar):LongInt;APIENTRY;
                   msqlSelectDB:Function(Sock:LongInt;Const DBName:CString):LongInt;APIENTRY;
                   msqlQuery:Function(Sock:LongInt;Const Query:CString):LongInt;APIENTRY;
                   msqlClose:Procedure(Sock:LongInt);APIENTRY;
                   msqlDataSeek:Procedure(result:Pm_result;Position:LongInt);APIENTRY;
                   msqlFieldSeek:Procedure(result:Pm_result;Position:LongInt);APIENTRY;
                   msqlFreeResult:Procedure(result:Pm_result);APIENTRY;
                   msqlFetchRow:Function(result:Pm_result):m_row;APIENTRY;
                   msqlFetchField:Function(result:Pm_result):Pm_field;APIENTRY;
                   msqlListDBs:Function(Sock:LongInt):Pm_result;APIENTRY;
                   msqlListTables:Function(Sock:LongInt):Pm_result;APIENTRY;
                   msqlListFields:Function(Sock:LongInt;Const TableName:CString):Pm_result;APIENTRY;
                   msqlStoreResult:Function:Pm_result;APIENTRY;
                   msqlListIndex:Function(Sock:LongInt;Const TableName,IndexType:CString):Pm_result;APIENTRY;

                   DataSourceCount:LongInt;
               End;

     Pmsqlhdbc=^Tmsqlhdbc;
     Tmsqlhdbc=Record
                    Procs:PDBProcs;
                    Socket:LongInt;
                    Connected:Boolean;
     End;

     PBindCol=^TBindCol;
     TBindCol=Record
                    fcType:LongInt;
                    Value:Pointer;
                    cbValueMax:LongInt;
                    pcbValue:^SQLInteger;
     End;

     PBindCols=^TBindCols;
     TBindCols=Array[1..65535] Of PBindCol;

     PmsqlStmt=^TmsqlStmt;
     TmsqlStmt=Record
                     hdbc:Pmsqlhdbc;
                     Procs:PDBProcs;
                     result:Pm_result;
                     BindColsCount:LongInt;
                     BindCols:PBindCols;
                     m_row:Pointer;
     End;


{$HINTS OFF}
Function msql_SQLError(ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT;Var szSqlState:SQLCHAR;
                       Var pfNativeError:SQLINTEGER;Var szErrorMsg;
                       cbErrorMsgMax:LongInt;Var pcbErrorMsg:SQLSMALLINT):SQLRETURN;APIENTRY;
Var Procs:PDBProcs;
Begin
     Procs:=PDBProcs(ahenv);
     PmSQLFunc(Procs^.FuncTable)^.msqlGetErrMsg(szErrorMsg);
     szSQLState:='';
     pfNativeError:=1;
     pcbErrorMsg:=length(CString(szErrorMsg))+1;
     Result:=SQL_SUCCESS;
End;

Function msql_SQLGetCursorName(ahstmt:SQLHSTMT;Var szCursor:SQLCHAR;cbCursorMax:LongInt;
                               Var pcbCursor:SQLSMALLINT):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If stmt^.result=Nil Then Result:=SQL_ERROR
     Else
     Begin
          szCursor:=tostr(LongInt(stmt^.Result^.Cursor));
          pcbCursor:=length(szCursor)+1;
          Result:=SQL_SUCCESS;
     End;
End;

Function msql_SQLFreeEnv(ahenv:SQLHENV):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_SUCCESS;
End;

Function msql_SQLNumParams(ahstmt:SQLHSTMT;Var pcpar:SQLSMALLINT):SQLRETURN;APIENTRY;
Begin
     pcpar:=0;
     Result:=SQL_SUCCESS;
End;

Function msql_SQLAllocConnect(ahenv:SQLHENV;Var phdbc:SQLHDBC):SQLRETURN;APIENTRY;
Var hdbc:Pmsqlhdbc;
Begin
     new(hdbc);
     hdbc^.Procs:=PDBProcs(ahenv);
     phdbc:=SQLHDBC(hdbc);
     result:=SQL_SUCCESS;
End;

Function msql_SQLSetConnectOption(ahdbc:SQLHDBC;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_SUCCESS;
End;

Function msql_SQLSetStmtOption(ahstmt:SQLHSTMT;fOption:LongWord;vParam:SQLUINTEGER):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_SUCCESS;
End;

Function msql_SQLCancel(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_SUCCESS;
End;

Function msql_SQLTransact(ahenv:SQLHENV;ahdbc:SQLHDBC;fType:LongWord):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_SUCCESS;
End;

Function msql_SQLProcedureColumns(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                                  Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                                  Const szProcName:SQLCHAR;cbProcName:LongInt;
                                  Const szColumnName:SQLCHAR;cbColumnName:LongInt):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function msql_SQLFreeConnect(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
Var hdbc:Pmsqlhdbc;
Begin
     hdbc:=Pmsqlhdbc(ahdbc);
     if hdbc^.Socket<>0 Then PmSQLFunc(hdbc^.Procs^.FuncTable)^.msqlClose(hdbc^.Socket);
     dispose(hdbc);
     result:=SQL_SUCCESS;
End;

Function msql_SQLDisconnect(ahdbc:SQLHDBC):SQLRETURN;APIENTRY;
Var hdbc:Pmsqlhdbc;
Begin
     hdbc:=Pmsqlhdbc(ahdbc);
     if hdbc^.Socket<>0 Then PmSQLFunc(hdbc^.Procs^.FuncTable)^.msqlClose(hdbc^.Socket);
     hdbc^.Socket:=0;
     Result:=SQL_SUCCESS;
End;

//returns connect socket
Function msqlConnect(Procs:PDBProcs;UID:CString):LongInt;
Var Host,UI:PChar;
Begin
     If Procs^.Host='' Then Host:=Nil
     Else Host:=@Procs^.Host;
     If UID='' Then UI:=Nil
     Else UI:=@UID;
     Result:=PmSQLFunc(Procs^.FuncTable)^.msqlUserConnect(Host,UI);
End;

Function msql_SQLAllocStmt(ahdbc:SQLHDBC;Var phstmt:SQLHSTMT):SQLRETURN;APIENTRY;
var Stmt:PmsqlStmt;
Begin
     New(Stmt);
     Stmt^.Procs:=Pmsqlhdbc(ahdbc)^.Procs;
     Stmt^.hdbc:=Pmsqlhdbc(ahdbc);
     phstmt:=SQLHSTMT(Stmt);
     result:=SQL_SUCCESS;
End;

Function msql_SQLFreeStmt(ahstmt:SQLHSTMT;fOption:LongWord):SQLRETURN;APIENTRY;
Var Stmt:PmsqlStmt;
    t:LongInt;
    BindCol:PBindCol;
Begin
     Stmt:=PmsqlStmt(ahstmt);
     If Stmt^.result<>Nil Then PmSQLFunc(Stmt^.Procs^.FuncTable)^.msqlFreeResult(Stmt^.result);
     Stmt^.Result:=Nil;
     If Stmt^.BindColsCount>0 Then
     Begin
          For t:=1 To Stmt^.BindColsCount Do
          Begin
               BindCol:=Stmt^.BindCols[t];
               If BindCol<>Nil Then Dispose(BindCol);
          End;
          FreeMem(Stmt^.BindCols,Stmt^.BindColsCount*4);
          Stmt^.BindCols:=Nil;
          Stmt^.BindColsCount:=0;
     End;
     Dispose(Stmt);
     result:=SQL_SUCCESS;
End;

Function msql_SQLPrimaryKeys(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                             Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                             Const szTableName:SQLCHAR;cbTableName:LongInt):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
    p:Pointer;
    s:String;
Begin
     Result:=SQL_SUCCESS_WITH_INFO;
     stmt:=PmsqlStmt(ahstmt);
     If stmt=Nil Then
     Begin
         Result:=SQL_ERROR;
         exit;
     End;
     If stmt^.Result<>Nil Then PmSQLFunc(stmt^.Procs^.FuncTable)^.msqlFreeResult(Stmt^.result);
     p:=@szTableName;
     If p=Nil Then s:=''
     Else s:=szTableName;
     If Pos('.',s)<>0 Then Delete(s,1,pos('.',s));
     stmt^.result:=PmSQLFunc(Stmt^.Procs^.FuncTable)^.msqlListIndex(stmt^.hdbc^.Socket,s,'avl');
     If stmt^.result<>Nil Then Result:=SQL_SUCCESS;
End;

Function msql_SQLProcedures(ahstmt:SQLHSTMT;Const szProcCatalog:SQLCHAR;cbProcCatalog:LongInt;
                            Const szProcSchema:SQLCHAR;cbProcSchema:LongInt;
                            Const szProcName:SQLCHAR;cbProcName:LongInt):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR;
End;

Function msql_SQLBindParameter(ahstmt:SQLHSTMT;ipar:LongWord;fParamType:LongInt;
                               fCType:LongInt;fSQLType:LongInt;cbParamDef:SQLUINTEGER;
                               ibScale:LongInt;Var rgbValue;cbValueMax:SQLINTEGER;
                               Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
Begin
     Result:=SQL_ERROR; //not supported
End;

Function msql_SQLDataSources(ahenv:SQLHENV;fDirection:LongWord;
                             Var szDSN:SQLCHAR;cbDSNMax:LongInt;
                             Var pcbDSN:SQLSMALLINT;
                             Var szDescription:SQLCHAR;cbDescriptionMax:LongInt;
                             Var pcbDescription:SQLSMALLINT):SQLRETURN;APIENTRY;
var res:Pm_result;
    Procs:PDBProcs;
    t:LongInt;
    row:m_row;
    pc:PChar;
    Sock:LongInt;
Begin
     szDescription:='';
     pcbDescription:=0;

     Procs:=PDBProcs(ahenv);
     If fDirection=SQL_FETCH_FIRST Then PmSQLFunc(Procs^.FuncTable)^.DataSourceCount:=0
     Else inc(PmSQLFunc(Procs^.FuncTable)^.DataSourceCount);

     Result:=msqlConnect(Procs,'');
     If Result=SQL_ERROR Then exit;
     Sock:=Result;

     res:=PmSQLFunc(Procs^.FuncTable)^.msqlListDbs(Sock);
     Result:=SQL_NO_DATA_FOUND;
     If res<>Nil Then
     Begin
         For t:=1 To PmSQLFunc(Procs^.FuncTable)^.DataSourceCount Do
           row:=PmSQLFunc(Procs^.FuncTable)^.msqlFetchRow(res);

         row:=PmSQLFunc(Procs^.FuncTable)^.msqlFetchRow(res);

         If row<>Nil Then
         Begin
             Move(row^,pc,4);
             szDSN:=pc^;
             pcbDSN:=length(szDSN)+1;

             Result:=SQL_SUCCESS;
         End;

         PmSQLFunc(Procs^.FuncTable)^.msqlFreeResult(res);
     End;

     PmSQLFunc(Procs^.FuncTable)^.msqlClose(Sock);
End;

Function msql_SqlConnect(ahdbc:SQLHDBC;Const szDSN:SQLCHAR;
                         cbDSN:LongInt;Const szUID:SQLCHAR;
                         cbUID:LongInt;Const szAuthString:SQLCHAR;
                         cbAuthString:LongInt):SQLRETURN;APIENTRY;
var hdbc:Pmsqlhdbc;
Begin
     hdbc:=Pmsqlhdbc(ahdbc);
     If hdbc^.Socket<>0 Then Result:=SQL_ERROR
     Else
     Begin
          Try
             hdbc^.Socket:=msqlConnect(hdbc^.Procs,szUID);
             If hdbc^.Socket<=0 Then Result:=SQL_ERROR
             Else Result:=PmSQLFunc(hdbc^.Procs^.FuncTable)^.msqlSelectDB(hdbc^.Socket,szDSN);
          Except
             Result:=SQL_ERROR;
          End;
     End;
End;

Function msql_SQLTables(ahstmt:SQLHSTMT;Const szCatalogName:SQLCHAR;cbCatalogName:LongInt;
                        Const szSchemaName:SQLCHAR;cbSchemaName:LongInt;
                        Const szTableName:SQLCHAR;cbTableName:LongInt;
                        Const szTableType:SQLCHAR;cbTableType:LongInt):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
    Procs:PDBProcs;
Begin
     If szTableType<>'TABLE' Then
     Begin
          Result:=SQL_ERROR;
          exit;
     End;

     //query available tables
     stmt:=PmsqlStmt(ahstmt);
     Procs:=stmt^.Procs;
     If stmt^.Result<>Nil Then PmSQLFunc(Procs^.FuncTable)^.msqlFreeResult(Stmt^.result);

     stmt^.result:=PmSQLFunc(Procs^.FuncTable)^.msqlListTables(stmt^.hdbc^.Socket);
     If stmt^.result=Nil Then Result:=SQL_ERROR
     Else Result:=SQL_SUCCESS;
End;

Function msql_SQLNumResultCols(ahstmt:SQLHSTMT;Var pccol:SQLSMALLINT):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If stmt^.result=Nil Then pccol:=0
     Else pccol:=stmt^.Result^.NumFields;
     Result:=SQL_SUCCESS;
End;

Function msql_SQLDescribeCol(ahstmt:SQLHSTMT;icol:LongWord;Var szColName:SQLCHAR;
                             cbColNameMax:LongInt;Var pcbColName:SQLSMALLINT;
                             Var pfSqlType:SQLSMALLINT;Var pcbColDef:SQLUINTEGER;
                             Var pibScale:SQLSMALLINT;Var pfNullable:SQLSMALLINT):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
    Procs:PDBProcs;
    Field:Pm_Field;
    pi:^Pointer;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If stmt^.result=Nil Then Result:=SQL_ERROR
     Else
     Begin
          Procs:=stmt^.Procs;
          PmSQLFunc(Procs^.FuncTable)^.msqlFieldSeek(stmt^.result,icol-1);
          Field:=PmSQLFunc(Procs^.FuncTable)^.msqlFetchField(stmt^.result);
          PmSQLFunc(Procs^.FuncTable)^.msqlFieldSeek(stmt^.result,0);

          If Field=Nil Then Result:=SQL_ERROR
          Else
          Begin
               Result:=SQL_SUCCESS;

               szColName:=Field^.Name^;
               pcbColName:=length(Field^.Name^)+1;
               Case Field^.Typ Of
                   INT_TYPE:pfSqlType:=SQL_INTEGER;
                   CHAR_TYPE:pfSqlType:=SQL_CHAR;
                   REAL_TYPE:pfSqlType:=SQL_REAL;
                   TEXT_TYPE:pfSqlType:=SQL_LONGVARCHAR;
                   DATE_TYPE:pfSqlType:=SQL_DATE;
                   UINT_TYPE:pfSqlType:=SQL_INTEGER;
                   MONEY_TYPE:pfSqlType:=SQL_REAL;
                   TIME_TYPE:pfSqlType:=SQL_TIME;
                   Else pfSqlType:=SQL_VARCHAR;
               End; //case
               pcbColDef:=Field^.len;
               pibScale:=0;
               pi:=@pfNullable;
               If pi<>Nil Then
               Begin
                  If (Field^.Flags And NOT_NULL_FLAG)<>0 Then pfNullable:=0
                  else pfNullable:=1;
               End;
          End;
     End;
End;

Function msql_SQLBindCol(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;Var rgbValue;
                                       cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If stmt^.result=Nil Then Result:=SQL_ERROR
     Else
     Begin
        If stmt^.BindCols=Nil Then
        Begin
            stmt^.BindColsCount:=stmt^.Result^.NumFields;
            GetMem(stmt^.BindCols,stmt^.BindColsCount*4);
        End;

        If stmt^.BindCols^[icol]<>Nil Then Dispose(stmt^.BindCols^[icol]);
        New(stmt^.BindCols^[icol]);
        stmt^.BindCols^[icol]^.fcType:=fcType;
        stmt^.BindCols^[icol]^.Value:=@rgbValue;
        stmt^.BindCols^[icol]^.cbValueMax:=cbValueMax;
        stmt^.BindCols^[icol]^.pcbValue:=@pcbValue;

        Result:=SQL_SUCCESS;
     End;
End;

Const Months:Array[1..12] Of String[4]=('JAN','FEB','MAR','APR','MAY','JUN','JUL',
                                        'AUG','SEP','OCT','NOV','DEC');

Function GetDataFromField(stmt:PmsqlStmt;icol:LongInt;Var rgbValue;cbValueMax:LongInt;
                          Var pcbValue:LongInt):SQLRETURN;
Var
    p:^Pointer;
    Field:Pm_Field;
    FieldData:Pm_fdata;
    t:LongInt;
    c:PChar;
    cc:Integer;
    i:LongInt;
    ui:LongWord;
    s,s1:String;
    e:extended;
Type TTempDate=Record
                     Year,Month,Day:Word;
               End;
Var date:TTempDate;
Type TTempTime=Record
                     Hour,Minute,Second:Word;
               End;
Var Time:TTempTime;
Begin
     FieldData:=stmt^.result^.FieldData;
     For t:=1 To icol-1 Do FieldData:=FieldData^.Next;
     Field:=@FieldData^.Field;

     p:=stmt^.m_row;
     inc(p,(icol-1)*4);
     p:=p^;

     if p=Nil Then //NULL
     Begin
          pcbValue:=SQL_NULL_DATA;
          Result:=SQL_SUCCESS;
          exit;
     End;

     Case Field^.Typ Of
         INT_TYPE: //convert from signed int
         Begin
             c:=Pointer(p);
             s:=c^;
             Val(s,i,cc);
             If cc<>0 Then
             Begin
                  Result:=SQL_ERROR;
                  exit;
             End;

             Case Field^.Len Of
               1:ShortInt(rgbValue):=i;
               2:Integer(rgbValue):=i;
               Else LongInt(rgbValue):=i;
             End;

             pcbValue:=Field^.Len;
         End;
         UINT_TYPE: //convert from int
         Begin
             c:=Pointer(p);
             s:=c^;
             Val(s,ui,cc);
             If cc<>0 Then
             Begin
                  Result:=SQL_ERROR;
                  exit;
             End;

             Move(ui,rgbValue,Field^.Len);
             pcbValue:=Field^.Len;
         End;
         REAL_TYPE,MONEY_TYPE: //convert from real
         Begin
              c:=Pointer(p);
              s:=c^;
              Val(s,e,cc);
              If cc<>0 Then
              Begin
                   Result:=SQL_ERROR;
                   exit;
              End;

              Case Field^.Len Of
               4:Single(rgbValue):=e;
               8:Double(rgbValue):=e;
               Else Extended(rgbValue):=e;
              End;

              pcbValue:=Field^.Len;
         End;
         DATE_TYPE: //convert from Date
         Begin
              Result:=SQL_ERROR;

              c:=Pointer(p);
              s:=c^;
              s1:=copy(s,1,pos('-',s)-1);
              Delete(s,1,pos('-',s));
              Val(s1,date.day,cc);
              if cc<>0 Then exit;
              s1:=copy(s,1,pos('-',s)-1);
              Delete(s,1,pos('-',s));
              UpcaseStr(s1);
              date.Month:=0;
              For t:=1 To 12 Do If s1=Months[t] Then date.Month:=t;
              If date.Month=0 Then exit;
              Val(s,date.year,cc);
              If cc<>0 Then exit;
              move(date,rgbValue,sizeof(date));
              pcbValue:=sizeof(date);
         End;
         TIME_TYPE: //convert from time
         Begin
              Result:=SQL_ERROR;

              c:=Pointer(p);
              s:=c^;
              s1:=copy(s,1,pos(':',s)-1);
              Delete(s,1,pos(':',s));
              Val(s1,time.hour,cc);
              if cc<>0 Then exit;
              s1:=copy(s,1,pos(':',s)-1);
              Delete(s,1,pos(':',s));
              Val(s1,time.minute,cc);
              if cc<>0 Then exit;
              s1:=copy(s,1,pos(':',s)-1);
              Delete(s,1,pos(':',s));
              Val(s1,time.second,cc);
              if cc<>0 Then exit;

              move(time,rgbValue,sizeof(time));
              pcbValue:=sizeof(time);
         End;
         Else
         Begin //use string
              If cbValueMax>Field^.len Then
              Begin
                  Move(p^,rgbValue,Field^.Len);
                  pcbValue:=length(PChar(p)^);
              End
              Else
              Begin
                  Move(p^,rgbValue,cbValueMax);
                  pcbValue:=cbValueMax;
              End;
         End;
     End; //case

     Result:=SQL_SUCCESS;
End;

Function msql_SQLFetch(ahstmt:SQLHSTMT):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
    t:LongInt;
    BindCol:PBindCol;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If stmt^.result=Nil Then Result:=SQL_ERROR
     Else
     Begin
          stmt^.m_row:=PmSqlFunc(stmt^.Procs^.FuncTable)^.msqlFetchRow(stmt^.result);
          If stmt^.m_row=Nil Then Result:=SQL_ERROR
          Else
          Begin
               If Stmt^.BindCols<>Nil Then
               Begin
                    For t:=1 To Stmt^.BindColsCount Do
                    Begin
                         BindCol:=Stmt^.BindCols^[t];
                         If BindCol<>Nil Then
                         Begin
                              Result:=GetDataFromField(stmt,t,BindCol^.Value^,BindCol^.cbValueMax,
                                                       BindCol^.pcbValue^);
                              If Result<>SQL_SUCCESS Then exit;
                         End;
                    End;
               End;

               Result:=SQL_SUCCESS;
          End;
     End;
End;

Function msql_SQLExtendedFetch(ahstmt:SQLHSTMT;fFetchType:LongWord;irow:SQLINTEGER;
                               Var pcrow:SQLUINTEGER;Var rgfRowStatus):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If stmt^.result=Nil Then Result:=SQL_ERROR
     Else
     Begin
          pcRow:=0;

          If fFetchType=SQL_FETCH_FIRST Then irow:=0
          Else If fFetchType=SQL_FETCH_NEXT Then
          Begin
               Result:=msql_SQLFetch(ahstmt);
               exit;
          End
          Else If fFetchType=SQL_FETCH_ABSOLUTE Then
          Begin
               If irow>Stmt^.result^.NumRows Then
               Begin
                    Result:=SQL_NO_DATA_FOUND;
                    exit;
               End;
          End
          Else
          Begin
               Result:=SQL_ERROR;
               exit;
          End;

          PmSqlFunc(stmt^.Procs^.FuncTable)^.msqlDataSeek(stmt^.Result,irow-1);
          Result:=msql_SQLFetch(ahstmt);
     End;
End;

Function msql_SQLExecDirect(ahstmt:SQLHSTMT;Const szSqlStr:SQLCHAR;cbSqlStr:SQLINTEGER):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If Stmt^.result<>Nil Then PmSQLFunc(Stmt^.Procs^.FuncTable)^.msqlFreeResult(Stmt^.result);
     Stmt^.result:=Nil;
     Result:=PmSqlFunc(stmt^.Procs^.FuncTable)^.msqlQuery(stmt^.hdbc^.Socket,szSqlStr);
     If Result=SQL_ERROR Then exit;
     stmt^.result:=PmSqlFunc(stmt^.Procs^.FuncTable)^.msqlStoreResult;
     Result:=SQL_SUCCESS;
End;

Function msql_SQLGetData(ahstmt:SQLHSTMT;icol:LongWord;fCType:LongInt;
                          Var rgbValue;cbValueMax:SQLINTEGER;Var pcbValue:SQLINTEGER):SQLRETURN;APIENTRY;
Var stmt:PmsqlStmt;
Begin
     stmt:=PmsqlStmt(ahstmt);
     If ((stmt^.result=Nil)Or(stmt^.m_row=Nil)Or
         (icol>stmt^.result^.NumFields)) Then Result:=SQL_ERROR
     Else Result:=GetDataFromField(stmt,icol,rgbValue,cbValueMax,pcbValue);
End;
{$HINTS ON}

{*******************************************************************************************
 *                                                                                         *
 * general functions                                                                       *
 *                                                                                         *
 *                                                                                         *
 *******************************************************************************************}

Function AllocateDBEnvironment(Var Procs:TDBProcs):SQLRETURN;
Begin
    Case Procs.DBType Of
       Native_DBase,Native_Paradox,Native_mSQL,Native_Oracle7:
       Begin
            Procs.ahenv:=HENV(@Procs);
            Result:=SQL_SUCCESS;
       End
       Else Result:=Procs.SQLAllocEnv(Procs.ahenv);
    End; //case
End;

Function SQLErrorText(Var DbProcs:TDBProcs;ahenv:SQLHENV;ahdbc:SQLHDBC;ahstmt:SQLHSTMT):String;
Var SQLSTATE:SQLCHAR;
    Buffer:cstring;
    sqlCode:SQLINTEGER;
    len:SQLSMALLINT;
Begin
     Result:=#13#10;
     While DbProcs.SQLError(ahenv,ahdbc,ahstmt,SQLSTATE,sqlCode,Buffer,
                            255,len)=SQL_SUCCESS Do
     Begin
          Result:=Result+'SQLSTATE: '+SQLSTATE+#13#10+
                         'Native error code: '+tostr(sqlCode)+#13#10+
                         Buffer;
          If DbProcs.DBType In [Native_Oracle7,Native_mSQL] Then break;
     End;
     If Result=#13#10 Then Result:='';
End;


{DLL stuff}

Function LoadDLL(Name:String):LONGWORD;
{$IFDEF OS2}
Var  c:CString;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If DosLoadModule(c,255,Name,Result) <> 0 Then Result := 0;
     {$ENDIF}
     {$IFDEF Win32}
     Result := LoadLibrary(Name);
     {$ENDIF}
End;

Function FreeDLL(Var Handle:LONGWORD):BOOLEAN;
Begin
     Result := FALSE;
     {$IFDEF OS2}
     If Handle <> 0 Then Result := DosFreeModule(Handle) = 0;
     {$ENDIF}
     {$IFDEF Win32}
     If Handle <> 0 Then Result := FreeLibrary(Handle);
     {$ENDIF}
     If Result Then Handle := 0;
End;

Function GetDLLProcAddress(Handle:LONGWORD;Const ProcName:String):POINTER;
Var  c:CString;
Begin
     c := ProcName;
     {$IFDEF OS2}
     If DosQueryProcAddr(Handle,0,c,Result) <> 0 Then Result := Nil;
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetProcAddress(Handle,c);
     {$ENDIF}
End;


Var CurrentProcName:String;

Function GetProcAddr(DllHandle:LongWord;Const ProcName:String):Pointer;
Begin
     CurrentProcName:=ProcName;
     Result:=GetDLLProcAddress(DllHandle,ProcName);
     If Result=Nil Then
       Raise EProcAddrError.Create(ProcName);
End;


Procedure FreeDBProcs(Var DbProcs:TDBProcs);
Begin
     If Not DbProcs.Assigned Then Exit;

     // free library
     FreeDLL(DbProcs.ModHandle);


     // free structures
     Case DbProcs.DbType Of
       Native_mSQL:
       Begin
            FreeMem(DbProcs.FuncTable,SizeOf(TmSqlFunc));
            DbProcs.FuncTable := Nil;
       End;
       Native_Oracle7:
       Begin
            FreeMem(DBProcs.FuncTable,sizeof(TOracle7Func));
       End;
     End;

     DbProcs.Assigned := False;
End;


Function FillDBProcs(Var DbProcs:TDBProcs):Boolean;
Var  DllName:String;
     DBType:TDBTypes;
Begin
     Result:=True;

     If DbProcs.Assigned Then Exit;

     GetDBServerFromAlias(DbProcs.AliasName,DllName,DBType);

     If DllName='' Then
     Begin
          Result:=False;
          Exit; //alias Not found
     End;

     UpcaseStr(DllName);

     DbProcs.ModHandle:=LoadDLL(DllName);
     If DbProcs.ModHandle=0 Then
     Begin
          ErrorBox2('Database DLL not found: '+DllName);
          Result:=False;
          Exit;
     End;

     DbProcs.DbType:=DBType;

     Case DBType Of
        Native_DBase,Native_Paradox,
        ODBC,DB2,Sybase:
        Begin
            Try
               With DbProcs Do
               Begin
                    SQLAllocEnv:=Pointer(GetProcAddr(ModHandle,'SQLAllocEnv'));
                    SQLAllocConnect:=Pointer(GetProcAddr(ModHandle,'SQLAllocConnect'));
                    SQLConnect:=Pointer(GetProcAddr(ModHandle,'SQLConnect'));
                    //SQLDriverConnect:=Pointer(GetProcAddr(ModHandle,'SQLDriverConnect'));
                    SQLDataSources:=Pointer(GetProcAddr(ModHandle,'SQLDataSources'));
                    //SQLGetInfo:=Pointer(GetProcAddr(ModHandle,'SQLGetInfo'));
                    //SQLGetFunctions:=Pointer(GetProcAddr(ModHandle,'SQLGetFunctions'));
                    SQLGetTypeInfo:=Pointer(GetDLLProcAddress(ModHandle,'SQLGetTypeInfo'));
                    SQLSetConnectOption:=Pointer(GetProcAddr(ModHandle,'SQLSetConnectOption'));
                    //SQLGetConnectOption:=Pointer(GetProcAddr(ModHandle,'SQLGetConnectOption'));
                    SQLSetStmtOption:=Pointer(GetProcAddr(ModHandle,'SQLSetStmtOption'));
                    //SQLGetStmtOption:=Pointer(GetProcAddr(ModHandle,'SQLGetStmtOption'));
                    SQLAllocStmt:=Pointer(GetProcAddr(ModHandle,'SQLAllocStmt'));
                    //SQLPrepare:=Pointer(GetProcAddr(ModHandle,'SQLPrepare'));
                    SQLBindParameter:=Pointer(GetProcAddr(ModHandle,'SQLBindParameter'));
                    //SQLSetParam:=Pointer(GetProcAddr(ModHandle,'SQLSetParam'));
                    //SQLParamOptions:=Pointer(GetProcAddr(ModHandle,'SQLParamOptions'));
                    SQLGetCursorName:=Pointer(GetProcAddr(ModHandle,'SQLGetCursorName'));
                    //SQLSetCursorName:=Pointer(GetProcAddr(ModHandle,'SQLSetCursorName'));
                    //SQLExecute:=Pointer(GetProcAddr(ModHandle,'SQLExecute'));
                    SQLExecDirect:=Pointer(GetProcAddr(ModHandle,'SQLExecDirect'));
                    //SQLNativeSql:=Pointer(GetProcAddr(ModHandle,'SQLNativeSql'));
                    SQLNumParams:=Pointer(GetProcAddr(ModHandle,'SQLNumParams'));
                    //SQLParamData:=Pointer(GetProcAddr(ModHandle,'SQLParamData'));
                    //SQLPutData:=Pointer(GetProcAddr(ModHandle,'SQLPutData'));
                    //SQLRowCount:=Pointer(GetProcAddr(ModHandle,'SQLRowCount'));
                    SQLNumResultCols:=Pointer(GetProcAddr(ModHandle,'SQLNumResultCols'));
                    SQLDescribeCol:=Pointer(GetProcAddr(ModHandle,'SQLDescribeCol'));
                    //SQLColAttributes:=Pointer(GetProcAddr(ModHandle,'SQLColAttributes'));
                    SQLBindCol:=Pointer(GetProcAddr(ModHandle,'SQLBindCol'));
                    SQLFetch:=Pointer(GetProcAddr(ModHandle,'SQLFetch'));
                    SQLExtendedFetch:=Pointer(GetProcAddr(ModHandle,'SQLExtendedFetch'));
                    SQLGetData:=Pointer(GetProcAddr(ModHandle,'SQLGetData'));
                    //SQLMoreResults:=Pointer(GetProcAddr(ModHandle,'SQLMoreResults'));
                    SQLError:=Pointer(GetProcAddr(ModHandle,'SQLError'));
                    //SQLColumns:=Pointer(GetProcAddr(ModHandle,'SQLColumns'));
                    SQLForeignKeys:=Pointer(GetDLLProcAddress(ModHandle,'SQLForeignKeys'));
                    SQLPrimaryKeys:=Pointer(GetProcAddr(ModHandle,'SQLPrimaryKeys'));
                    SQLProcedureColumns:=Pointer(GetProcAddr(ModHandle,'SQLProcedureColumns'));
                    SQLProcedures:=Pointer(GetProcAddr(ModHandle,'SQLProcedures'));
                    //SQLSpecialColumns:=Pointer(GetProcAddr(ModHandle,'SQLSpecialColumns'));
                    SQLStatistics:=Pointer(GetDLLProcAddress(ModHandle,'SQLStatistics'));
                    //SQLTablePrivileges:=Pointer(GetProcAddr(ModHandle,'SQLTablePrivileges'));
                    SQLTables:=Pointer(GetProcAddr(ModHandle,'SQLTables'));
                    SQLFreeStmt:=Pointer(GetProcAddr(ModHandle,'SQLFreeStmt'));
                    SQLCancel:=Pointer(GetProcAddr(ModHandle,'SQLCancel'));
                    SQLTransact:=Pointer(GetProcAddr(ModHandle,'SQLTransact'));
                    SQLDisconnect:=Pointer(GetProcAddr(ModHandle,'SQLDisconnect'));
                    SQLFreeConnect:=Pointer(GetProcAddr(ModHandle,'SQLFreeConnect'));
                    SQLFreeEnv:=Pointer(GetProcAddr(ModHandle,'SQLFreeEnv'));
               End;

               //Start DataBase Manager
               {
               If Pos('DB2CLI',DllName)<>0 Then
               Begin
                    If DosLoadModule(C,255,'SQLE32',sql32Handle)=0 Then
                    Begin
                         sqlestar:=Pointer(GetProcAddr(sql32Handle,'sqlestar_api'));
                         sqlestar;
                    End;
               End;
               }

               If DBType In [Native_DBase,Native_Paradox] Then 
                           Begin
                                DbProcs.Host := ParamStr(0);
               End;

            Except
               ON EProcAddrError Do
               Begin
                    ErrorBox2('Cannot retrieve SQL Procedure: '+CurrentProcName);
                    FreeDLL(DbProcs.ModHandle);
                    Result:=False;
               End
               Else Raise;
            End;
        End; //ODBC
        Native_mSQL:
        Begin
            GetMem(DbProcs.FuncTable,sizeof(TmSqlFunc));
            Try
               With DbProcs,PmSQLFunc(DbProcs.FuncTable)^ Do
               Begin
                   msqlGetErrMsg:=Pointer(GetProcAddr(ModHandle,'msqlGetErrMsg'));
                   msqlUserConnect:=Pointer(GetProcAddr(ModHandle,'msqlUserConnect'));
                   msqlSelectDB:=Pointer(GetProcAddr(ModHandle,'msqlSelectDB'));
                   msqlQuery:=Pointer(GetProcAddr(ModHandle,'msqlQuery'));
                   msqlClose:=Pointer(GetProcAddr(ModHandle,'msqlClose'));
                   msqlDataSeek:=Pointer(GetProcAddr(ModHandle,'msqlDataSeek'));
                   msqlFieldSeek:=Pointer(GetProcAddr(ModHandle,'msqlFieldSeek'));
                   msqlFreeResult:=Pointer(GetProcAddr(ModHandle,'msqlFreeResult'));
                   msqlFetchRow:=Pointer(GetProcAddr(ModHandle,'msqlFetchRow'));
                   msqlFetchField:=Pointer(GetProcAddr(ModHandle,'msqlFetchField'));
                   msqlListDBs:=Pointer(GetProcAddr(ModHandle,'msqlListDBs'));
                   msqlListTables:=Pointer(GetProcAddr(ModHandle,'msqlListTables'));
                   msqlListFields:=Pointer(GetProcAddr(ModHandle,'msqlListFields'));
                   msqlStoreResult:=Pointer(GetProcAddr(ModHandle,'msqlStoreResult'));
                   msqlListIndex:=Pointer(GetProcAddr(ModHandle,'msqlListIndex'));

                   SQLFreeEnv:=@msql_SQLFreeEnv;
                   SQLDataSources:=@msql_SQLDataSources;
                   SQLAllocStmt:=@msql_SQLAllocStmt;
                   SQLFreeStmt:=@msql_SQLFreeStmt;
                   SQLAllocConnect:=@msql_SQLAllocConnect;
                   SQLFreeConnect:=@msql_SQLFreeConnect;
                   SQLDisconnect:=@msql_SQLDisconnect;
                   SQLTables:=@msql_SQLTables;
                   SQLConnect:=@msql_SQLConnect;
                   SQLError:=@msql_SQLError;
                   SQLSetConnectOption:=@msql_SQLSetConnectOption;
                   SQLPrimaryKeys:=@msql_SQLPrimaryKeys;
                   SQLNumResultCols:=@msql_SQLNumResultCols;
                   SQLSetStmtOption:=@msql_SQLSetStmtOption;
                   SQLBindParameter:=@msql_SQLBindParameter;
                   SQLDescribeCol:=@msql_SQLDescribeCol;
                   SQLBindCol:=@msql_SQLBindCol;
                   SQLFetch:=@msql_SQLFetch;
                   SQLExecDirect:=@msql_SQLExecDirect;
                   SQLCancel:=@msql_SQLCancel;
                   SQLTransact:=@msql_SQLTransact;
                   SQLExtendedFetch:=@msql_SQLExtendedFetch;
                   SQLGetData:=@msql_SQLGetData;
                   SQLNumParams:=@msql_SQLNumParams;
                   SQLProcedureColumns:=@msql_SQLProcedureColumns;
                   SQLProcedures:=@msql_SQLProcedures;
                   SQLGetCursorName:=@msql_SQLGetCursorName;
               End;
            Except
               ON EProcAddrError Do
               Begin
                    ErrorBox2('Cannot retrieve SQL Procedure: '+CurrentProcName);
                    FreeDLL(DbProcs.ModHandle);
                    FreeMem(DbProcs.FuncTable,SizeOf(TmSqlFunc));
                    DbProcs.FuncTable:=Nil;
                    Result:=False;
               End
               Else Raise;
            End;
        End;
        Native_Oracle7:
        Begin
            GetMem(DbProcs.FuncTable,sizeof(TOracle7Func));
            Try
               With DbProcs,POracle7Func(DbProcs.FuncTable)^ Do
               Begin
                   {$IFDEF OS2}
                   obndra:=Pointer(GetProcAddr(ModHandle,'OBNDRA'));
                   ocan:=Pointer(GetProcAddr(ModHandle,'OCAN'));
                   oclose:=Pointer(GetProcAddr(ModHandle,'OCLOSE'));
                   ocof:=Pointer(GetProcAddr(ModHandle,'OCOF'));
                   ocom:=Pointer(GetProcAddr(ModHandle,'OCOM'));
                   ocon:=Pointer(GetProcAddr(ModHandle,'OCON'));
                   odefin:=Pointer(GetProcAddr(ModHandle,'ODEFIN'));
                   odescr:=Pointer(GetProcAddr(ModHandle,'ODESCR'));
                   oerhms:=Pointer(GetProcAddr(ModHandle,'OERHMS'));
                   oexec:=Pointer(GetProcAddr(ModHandle,'OEXEC'));
                   ofetch:=Pointer(GetProcAddr(ModHandle,'OFETCH'));
                   ologof:=Pointer(GetProcAddr(ModHandle,'OLOGOF'));
                   olon:=Pointer(GetProcAddr(ModHandle,'OLON'));
                   oopen:=Pointer(GetProcAddr(ModHandle,'OOPEN'));
                   oparse:=Pointer(GetProcAddr(ModHandle,'OPARSE'));
                   orlon:=Pointer(GetProcAddr(ModHandle,'ORLON'));
                   orol:=Pointer(GetProcAddr(ModHandle,'OROL'));
                   odessp:=Pointer(GetProcAddr(ModHandle,'ODESSP'));
                   obndrv:=Pointer(GetProcAddr(ModHandle,'OBNDRV'));
                   {$ENDIF}
                   {$IFDEF WIN32}
                   obndra:=Pointer(GetProcAddr(ModHandle,'obndra'));
                   ocan:=Pointer(GetProcAddr(ModHandle,'ocan'));
                   oclose:=Pointer(GetProcAddr(ModHandle,'oclose'));
                   ocof:=Pointer(GetProcAddr(ModHandle,'ocof'));
                   ocom:=Pointer(GetProcAddr(ModHandle,'ocom'));
                   ocon:=Pointer(GetProcAddr(ModHandle,'ocon'));
                   odefin:=Pointer(GetProcAddr(ModHandle,'odefin'));
                   odescr:=Pointer(GetProcAddr(ModHandle,'odescr'));
                   oerhms:=Pointer(GetProcAddr(ModHandle,'oerhms'));
                   oexec:=Pointer(GetProcAddr(ModHandle,'oexec'));
                   ofetch:=Pointer(GetProcAddr(ModHandle,'ofetch'));
                   ologof:=Pointer(GetProcAddr(ModHandle,'ologof'));
                   olon:=Pointer(GetProcAddr(ModHandle,'olon'));
                   oopen:=Pointer(GetProcAddr(ModHandle,'oopen'));
                   oparse:=Pointer(GetProcAddr(ModHandle,'oparse'));
                   orlon:=Pointer(GetProcAddr(ModHandle,'orlon'));
                   orol:=Pointer(GetProcAddr(ModHandle,'orol'));
                   odessp:=Pointer(GetProcAddr(ModHandle,'odessp'));
                   obndrv:=Pointer(GetProcAddr(ModHandle,'obndrv'));
                   {$ENDIF}

                   SQLFreeEnv:=@Oracle7_SQLFreeEnv;
                   SQLDataSources:=@Oracle7_SQLDataSources;
                   SQLAllocStmt:=@Oracle7_SQLAllocStmt;
                   SQLFreeStmt:=@Oracle7_SQLFreeStmt;
                   SQLAllocConnect:=@Oracle7_SQLAllocConnect;
                   SQLFreeConnect:=@Oracle7_SQLFreeConnect;
                   SQLDisconnect:=@Oracle7_SQLDisconnect;
                   SQLTables:=@Oracle7_SQLTables;
                   SQLConnect:=@Oracle7_SQLConnect;
                   SQLError:=@Oracle7_SQLError;
                   SQLSetConnectOption:=@Oracle7_SQLSetConnectOption;
                   SQLPrimaryKeys:=@Oracle7_SQLPrimaryKeys;
                   SQLNumResultCols:=@Oracle7_SQLNumResultCols;
                   SQLSetStmtOption:=@Oracle7_SQLSetStmtOption;
                   SQLBindParameter:=@Oracle7_SQLBindParameter;
                   SQLDescribeCol:=@Oracle7_SQLDescribeCol;
                   SQLBindCol:=@Oracle7_SQLBindCol;
                   SQLFetch:=@Oracle7_SQLFetch;
                   SQLExecDirect:=@Oracle7_SQLExecDirect;
                   SQLCancel:=@Oracle7_SQLCancel;
                   SQLTransact:=@Oracle7_SQLTransact;
                   SQLExtendedFetch:=@Oracle7_SQLExtendedFetch;
                   SQLGetData:=@Oracle7_SQLGetData;
                   SQLNumParams:=@Oracle7_SQLNumParams;
                   SQLProcedureColumns:=@Oracle7_SQLProcedureColumns;
                   SQLProcedures:=@Oracle7_SQLProcedures;
                   SQLGetCursorName:=@Oracle7_SQLGetCursorName;
                   SQLForeignKeys:=@Oracle7_SQLForeignKeys;
                   Oracle7GetProcParams:=@Oracle7_GetProcParams;
                   aDBProcs:=@DBProcs;
                   SQLStatistics:=@Oracle7_SQLStatistics;
               End;
            Except
               ON EProcAddrError Do
               Begin
                    ErrorBox2('Cannot retrieve SQL Procedure: '+CurrentProcName);
                    FreeDLL(DbProcs.ModHandle);
                    FreeMem(DbProcs.FuncTable,SizeOf(TOracle7Func));
                    DbProcs.FuncTable:=Nil;
                    Result:=False;
               End
               Else Raise;
            End;
        End;
        Else Result:=False;
     End; //case

     DbProcs.Assigned:=Result;
End;


Type
    PDBServers=^TDBServers;
    TDBServers=Record
                      DllName:String[10];
                      AliasName:String;
                      DBType:TDBTypes;
                End;

{$IFDEF OS2}
Const
     MaxDBServers=7;
     DBServers:Array[1..MaxDBServers] Of TDBServers=
          ((DllName:'DB2CLI';AliasName:'DB2/2 2.1';DBType:DB2),
           (DllName:'WOD502';AliasName:'Sybase SQL Anywhere 5.0';DBType:Sybase),
           (DllName:'ODBC';AliasName:'ODBC';DBType:ODBC),
           (DllName:'MSQL';AliasName:'mSQL 2.x';DBType:Native_mSQL),
           (DllName:'SDE';AliasName:'dBASE';DBType:Native_DBase),
           (DllName:'SDE';AliasName:'Paradox';DBType:Native_Paradox),
           (DllName:'ORA_D71O';AliasName:'Oracle 7.1';DBType:Native_Oracle7)
          );
{$ENDIF}
{$IFDEF Win95}
Const
     MaxDBServers=10;
     DBServers:Array[1..MaxDBServers] Of TDBServers=
          ((DllName:'WOD50t';AliasName:'Sybase SQL Anywhere 5.0';DBType:ODBC),
           (DllName:'ODBC32';AliasName:'ODBC';DBType:ODBC),
           (DllName:'MSQL';AliasName:'mSQL 2.x';DBType:Native_mSQL),
           (DllName:'SDE';AliasName:'dBASE';DBType:Native_DBase),
           (DllName:'SDE';AliasName:'Paradox';DBType:Native_Paradox),
           (DllName:'ORANT71';AliasName:'Oracle 7.1 NT';DBType:Native_Oracle7),
           (DllName:'ORA71';AliasName:'Oracle 7.1 Win95';DBType:Native_Oracle7),
           (DllName:'ORANT73';AliasName:'Oracle 7.3 NT';DBType:Native_Oracle7),
           (DllName:'ORA73';AliasName:'Oracle 7.3 Win95';DBType:Native_Oracle7),
           (DllName:'ORANT71';AliasName:'Oracle 7.1';DBType:Native_Oracle7)
          );
{$ENDIF}

Var DBServerList:TList;

Procedure AddServerAlias(Const AliasName,DllName:String;DBType:TDBTypes);
Var D,N,E:String;
    T:LongInt;
    dummy:PDBServers;
Begin
     If AliasName='' Then exit; //invalid
     FSplit(DllName,D,N,E);
     N:=D+N;
     D:=AliasName;
     UpcaseStr(D);

     For T:=0 To DBServerList.Count-1 Do
     Begin
          dummy:=DBServerList[T];
          E:=dummy^.AliasName;
          UpcaseStr(E);
          If D=E Then Exit; //alias already present
     End;

     New(dummy);
     dummy^.AliasName:=AliasName;
     dummy^.DllName:=N;
     dummy^.DBType:=DBType;
     DBServerList.Add(dummy);
End;

Function GetDBServersCount:LongInt;
Begin
     Result:=DBServerList.Count;
End;

Procedure GetDBServer(Index:LongInt;Var AliasName,DllName:String;Var DBType:TDBTypes);
Var dummy:PDBServers;
Begin
     If ((Index<0)Or(Index>DBServerList.Count-1)) Then
     Begin
          AliasName:='';
          DllName:='';
          DbType:=Unkown_DB;
     End
     Else
     Begin
          dummy:=DBServerList[Index];
          AliasName:=dummy^.AliasName;
          DllName:=dummy^.DllName;
          DBType:=dummy^.DBType;
     End;
End;

Procedure GetDBServerFromAlias(Const Alias:String;Var DllName:String;Var DBType:TDBTypes);
Var T:LongInt;
    dummy:PDBServers;
    S,s1:String;
Begin
     S:=alias;
     UpcaseStr(S);
     For T:=0 To DBServerList.Count-1 Do
     Begin
          dummy:=DBServerList[T];
          s1:=dummy^.AliasName;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               DllName:=dummy^.DllName;
               DBType:=dummy^.DBType;
               Exit;
          End;
     End;

     DllName:='';
     DBType:=Unkown_DB;
End;

Procedure ModifyServerAlias(Const AliasName,NewAliasName,DllName:String;DBType:TDBTypes);
Var T:LongInt;
    dummy:PDBServers;
    S,s1:String;
Begin
     S:=AliasName;
     UpcaseStr(S);
     For T:=0 To DBServerList.Count-1 Do
     Begin
          dummy:=DBServerList[T];
          s1:=dummy^.AliasName;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               If NewAliasName<>'' Then dummy^.AliasName:=NewAliasName;
               dummy^.DllName:=DllName;
               dummy^.DBType:=DBType;
               Exit;
          End;
     End;
End;

Procedure RemoveServerAlias(Const AliasName:String);
Var T:LongInt;
    dummy:PDBServers;
    S,s1:String;
Begin
     S:=AliasName;
     UpcaseStr(S);
     For T:=0 To DBServerList.Count-1 Do
     Begin
          dummy:=DBServerList[T];
          s1:=dummy^.AliasName;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               DBServerList.Remove(dummy);
               Dispose(dummy);
               Exit;
          End;
     End;

End;

Procedure InitDefaultServers;
Var T:LongInt;
Begin
     For T:=1 To MaxDBServers Do AddServerAlias(DBServers[T].AliasName,DBServers[T].DllName,
                                                DBServers[T].DBType);
End;

Function IsDefaultServer(Const AliasName:String):Boolean;
Var s,s1:String;
    t:LongInt;
Begin
     s:=AliasName;
     UpcaseStr(s);
     Result:=False;
     For T:=1 To MaxDBServers Do
     Begin
          s1:=DBServers[t].AliasName;
          UpcaseStr(s1);
          If s1=s Then
          Begin
             Result:=True;
             exit;
          End;
     End;
End;

Type
    PDBAliasNames=^TDBAliasNames;
    TDBAliasNames=Record
                      AliasName:String;
                      DriverName:String;
                      UID:String;
                      Advanced:String;
                  End;

Var DBAliasList:TList;

Function GetDBAliasNamesCount:LongInt;
Begin
     Result:=DBAliasList.Count;
End;

Procedure GetDBAlias(Index:LongInt;Var AliasName,DriverName,Advanced,UID:String);
Var dummy:PDBAliasNames;
Begin
     If ((Index<0)Or(Index>DBAliasList.Count-1)) Then
     Begin
          AliasName:='';
          DriverName:='';
          Advanced:='';
          UID:='';
     End
     Else
     Begin
          dummy:=DBAliasList[Index];
          AliasName:=dummy^.AliasName;
          DriverName:=dummy^.DriverName;
          Advanced:=dummy^.Advanced;
          UID:=dummy^.UID;
     End;
End;


Procedure GetDBServerFromDBAlias(Const AliasName:String;Var DriverName,Advanced,UID:String);
Var T:LongInt;
    dummy:PDBAliasNames;
    S,s1:String;
Begin
     S:=AliasName;
     UpcaseStr(S);
     For T:=0 To DBAliasList.Count-1 Do
     Begin
          dummy:=DBAliasList[T];
          s1:=dummy^.AliasName;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               DriverName:=dummy^.DriverName;
               Advanced:=dummy^.Advanced;
               UID:=dummy^.UID;
               Exit;
          End;
     End;

     DriverName:='';
     Advanced:='';
     UID:='';
End;


Procedure AddDatabaseAlias(Const AliasName,DriverName,Advanced,UID:String);
Var t:LongInt;
    dummy:PDBAliasNames;
    d,n,e:String;
Begin
     If AliasName='' Then exit; //invalid
     D:=AliasName;
     UpcaseStr(D);

     For T:=0 To DBAliasList.Count-1 Do
     Begin
          dummy:=DBAliasList[T];
          E:=dummy^.AliasName;
          UpcaseStr(E);
          If D=E Then Exit; //alias already present
     End;

     New(dummy);
     dummy^.AliasName:=AliasName;
     dummy^.DriverName:=DriverName;
     dummy^.Advanced:=Advanced;
     dummy^.UID:=UID;
     DBAliasList.Add(dummy);
End;

Procedure RemoveDataBaseAlias(Const AliasName:String);
Var T:LongInt;
    dummy:PDBAliasNames;
    S,s1:String;
Begin
     S:=AliasName;
     UpcaseStr(S);
     For T:=0 To DBAliasList.Count-1 Do
     Begin
          dummy:=DBAliasList[T];
          s1:=dummy^.AliasName;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               DBAliasList.Remove(dummy);
               Dispose(dummy);
               Exit;
          End;
     End;

End;


Procedure ModifyDatabaseAlias(Const AliasName,NewAliasName,DriverName,Advanced,UID:String);
Var T:LongInt;
    dummy:PDBAliasNames;
    S,s1:String;
Begin
     S:=AliasName;
     UpcaseStr(S);
     For T:=0 To DBAliasList.Count-1 Do
     Begin
          dummy:=DBAliasList[T];
          s1:=dummy^.AliasName;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               If NewAliasName<>'' Then dummy^.AliasName:=NewAliasName;
               dummy^.DriverName:=DriverName;
               dummy^.Advanced:=Advanced;
               dummy^.UID:=UID;
               Exit;
          End;
     End;
End;



Type
    TUnsortedAsciiIniFile = CLASS(TAsciiIniFile)
       Protected
           Procedure InitIniFile;Override;
    End;

Procedure TUnsortedAsciiIniFile.InitIniFile;
Begin
  Inherited InitIniFile;
  SectionSort := TRUE;
  IdentSort := FALSE;
End;

Procedure RegisterDBDrivers(IniName:String);
Var a,D,N,E,S:String;
    DbType:TDBTypes;
    Ini:TUnsortedAsciiIniFile;
    IniStrings:TStringList;
    t,t1:LONGINT;
    c:Integer;
Begin
     If IniName = '' Then
     Begin
          D := GetEnv('SIBYLDBE');
          If D <> '' THEN
          Begin
               If D[Length(D)] <> '\' Then D := D + '\';
          End
          Else FSplit(ParamStr(0),D,N,E);

          IniName := D +'SIBYL.DBD';
     End;

     //read available drivers from SIBYL.DBD and add it to the listbox
     Try
        Ini.Create(IniName);
     Except
        Ini:=Nil;
     End;

     If Ini=Nil Then exit;

     IniStrings.Create;

     Try
        Ini.ReadSectionValues('DRIVERS',IniStrings);

        For t:=0 To IniStrings.Count-1 Do
        Begin
             s:=IniStrings[t];
             UpcaseStr(s);
             If pos('ALIAS=',s)=1 Then
             Begin
                  a:=IniStrings[t];
                  delete(a,1,length('ALIAS='));
                  While ((length(a)>0)And(a[1]=#32)) Do Delete(a,1,1);
                  While a[length(a)]=#32 Do Dec(a[0]);
                  inc(t);
             End
             Else a:='';

             If t<IniStrings.Count Then s:=IniStrings[t]
             Else s:='';
             UpcaseStr(s);
             If pos('DRIVER=',s)=1 Then
             Begin
                  d:=IniStrings[t];
                  delete(d,1,length('DRIVER='));
                  While ((length(d)>0)And(d[1]=#32)) Do Delete(d,1,1);
                  While d[length(d)]=#32 Do Dec(d[0]);
                  inc(t);
             End
             Else d:='';

             DBType:=ODBC;
             If t<IniStrings.Count Then s:=IniStrings[t]
             Else s:='';
             UpcaseStr(s);
             If pos('DBTYPE=',s)=1 Then
             Begin
                  delete(s,1,length('DBTYPE='));
                  VAL(s,t1,c);
                  If c<>0 Then Move(t1,DBType,sizeof(DBType));
                  inc(t);
             End;

             IF ((a<>'')And(d<>'')) Then
             Begin
                   AddServerAlias(a,d,DbType);
                   dec(t);
             End;
        End;
     Except
     End;

     IniStrings.Destroy;

     Ini.Destroy;
End;

Procedure RegisterDBAliasNames(IniName:String);
Var a,D,H,N,E,S,u:String;
    DbType:TDBTypes;
    IniStrings:TStringList;
    Ini:TUnsortedAsciiIniFile;
    t,t1:LONGINT;
    c:Integer;
Begin
     If IniName = '' Then
     Begin
          D := GetEnv('SIBYLDBE');
          If D <> '' THEN
          Begin
               If D[Length(D)] <> '\' Then D := D + '\';
          End
          Else FSplit(ParamStr(0),D,N,E);

          IniName := D +'SIBYL.DBA';
     End;

     //read available drivers from SIBYL.DBA and add it to the listbox
     Try
        Ini.Create(IniName);
     Except
        Ini:=Nil;
     End;

     If Ini=Nil Then exit;

     IniStrings.Create;

     Try
        Ini.ReadSectionValues('ALIAS NAMES',IniStrings);

        For t:=0 TO IniStrings.Count-1 Do
        Begin
             s:=IniStrings[t];
             UpcaseStr(s);
             If pos('ALIAS=',s)=1 Then
             Begin
                  a:=IniStrings[t];
                  delete(a,1,length('ALIAS='));
                  While ((length(a)>0)And(a[1]=#32)) Do Delete(a,1,1);
                  While a[length(a)]=#32 Do Dec(a[0]);
                  inc(t);
             End
             Else a:='';

             If t<IniStrings.Count Then s:=IniStrings[t]
             Else s:='';
             UpcaseStr(s);
             If pos('DRIVER=',s)=1 Then
             Begin
                  d:=IniStrings[t];
                  delete(d,1,length('DRIVER='));
                  While ((length(d)>0)And(d[1]=#32)) Do Delete(d,1,1);
                  While d[length(d)]=#32 Do Dec(d[0]);
                  inc(t);
             End
             Else d:='';

             If t<IniStrings.Count Then s:=IniStrings[t]
             Else s:='';
             UpcaseStr(s);
             If pos('ADVANCED=',s)=1 Then
             Begin
                  h:=IniStrings[t];
                  delete(h,1,length('ADVANCED='));
                  While ((length(h)>0)And(h[1]=#32)) Do Delete(h,1,1);
                  While h[length(h)]=#32 Do Dec(h[0]);
                  inc(t);
             End
             Else h:='';

             If t<IniStrings.Count Then s:=IniStrings[t]
             Else s:='';
             UpcaseStr(s);
             If pos('UID=',s)=1 Then
             Begin
                  u:=IniStrings[t];
                  delete(u,1,length('UID='));
                  While ((length(u)>0)And(u[1]=#32)) Do Delete(u,1,1);
                  While u[length(u)]=#32 Do Dec(u[0]);
                  inc(t);
             End
             Else u:='';

             If ((a<>'')And(d<>'')) Then
             Begin
                  AddDatabaseAlias(a,d,h,u);
                  dec(t);
             End;
        End;
     Except
     End;

     IniStrings.Destroy;

     Ini.Destroy;
End;


Begin
     DBServerList.Create;
     DBAliasList.Create;
     //Add Default servers
     InitDefaultServers;

     Try
        RegisterDBDrivers('');
     Except
     End;

     Try
        RegisterDBAliasNames('');
     Except
     End;
End.


