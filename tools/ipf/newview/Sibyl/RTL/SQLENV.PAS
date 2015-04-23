UNIT SQLENV;

{**************************************************************************
 *                                                                        *
 * Module Name    = SQLENV.H                                              *
 *                                                                        *
 * Descriptive Name = External Include File for Environment Commands      *
 *                                                                        *
 * Copyright = 5622-044 (C) Copyright IBM Corp. 1987, 1993                *
 *             Licensed Material - Program Property of IBM                *
 *             Refer to Copyright Instructions Form Number G120-3083      *
 *                                                                        *
 * Function = Include File defining                                       *
 *              Database Environment Command Interfaces                   *
 *              SQL Return Codes in SQLCODE for Environment Commands      *
 *                                                                        *
 **************************************************************************}

INTERFACE

USES sql,sqlaprep,sqlcodes,Os2Def;

CONST
     { Service type }
     SQLJ_DCSSV               = 1;     { Connection Services            }
     SQLJ_DBSV                = 2;     { Database Services              }

     { Connection Service request types }
     SQLJR_NOOP              = 0;     { Reserved (No-op)               }
     SQLJR_STOPGW            = 1;     { Stop Database function         }
     SQLJR_INT               = 2;     { Interrupt the request          }
     SQLJR_STARTGW           = 3;     { Start Database Connection      }
     SQLJR_RPC               = 4;     { Application Remote Interface   }
     SQLJR_CS_MAXOP          = 5;     { Highest Valid Request + 1      }

     { Database Services request types }
     SQLJR_PREPINIT          = 1;     { Precompiler/Binder
                                         Initialization                 }
     SQLJR_PREPFINI          = 2;     { Precompiler/Binder Termination }
     SQLJR_COMPILE           = 3;     { Compile                        }
     SQLJR_FREEDA            = 4;     { Free SQLDA                     }
     SQLJR_OPEN              = 5 ;    { Open Cursor                    }
     SQLJR_FETCH             = 6 ;    { Fetch with Cursor              }
     SQLJR_CLOSE             = 7 ;    { Close Cursor                   }
     SQLJR_EXECUTE           = 8 ;    { Execute                        }
     SQLJR_PREPARE           = 9 ;    { Prepare                        }
     SQLJR_EXECIMMD          = 10;    { Execute Immediate              }
     SQLJR_COMMIT            = 11;    { Commit                         }
     SQLJR_ROLLBACK          = 12;    { Rollback                       }
     SQLJR_RUNSTATS          = 13;    { Runstats                       }
     SQLJR_PREREORG          = 14;    { Reserved for Database Manager
                                         use only                       }
     SQLJR_DESCRIBE          = 15;    { Describe                       }
     SQLJR_RQSVPT            = 17;    { Request Savepoint              }
     SQLJR_ENSVPT            = 18;    { End Savepoint                  }
     SQLJR_RBSVPT            = 19;    { Rollback Savepoint             }
     SQLJR_GETAA             = 20;    { Reserved for Database Manager
                                         use only                       }
     SQLJR_NOT_USED          = 21;    { Not used                       }
     SQLJR_REORG             = 22;    { Reserved for Database Manager
                                         use only                       }
     SQLJR_GETTA             = 23;    { Get Table/View Authorizations  }
     SQLJR_DS_MAXOP          = 24;    { Highest Valid Request + 1      }

     { DCS Interface Positive Return Codes  returned to and by sqledcsr          }
     SQLJR_RCF_OK          =$0000;    { Successful Execution           }
     SQLJR_RCF_COMMIT      =$0001;    { Commit Performed               }
     SQLJR_RCF_ROLLBACK    =$0002;    { Rollback Performed             }
     SQLJR_RCF_CLOSED      =$0004;    { Cursors Closed                 }
     SQLJR_RCF_HOLD        =$0008;    { Cursor has Hold option         }
     SQLJR_RCF_BLOCK       =$0010;    { Cursor can be blocked          }
     SQLJR_RCF_NOBLK       =$0020;    { Cursor cannot be blocked       }
     SQLJR_RCF_SQLCA       =$0040;    { SQLCA Modified                 }
     SQLJR_RCF_FETCHERR    =$0080;    { Cursor closed on fetch         }
     SQLJR_RCF_TERMINATE   =$0100;    { Database Connection Terminated }
     SQLJR_RCF_SECURITY    =$0200;    { Security error                 }
     SQLJR_RCF_FORCE_RLBK  =$0400;    { Forced rollback                }

     { Number of triplets in sqljra }
     SQLJCSRA_DATA_ITEMS     =  5;  { Default Connection Services      }
     SQLJDSRA_DATA_ITEMS     =  9;  { Default Database Services        }
     SQLJR_STARTGW_DATA_ITEMS=  5;  { Extra triplets for STARTGW       }
     SQLJR_MAX_DATA_ITEMS    = 11;  { Maximum triplets for any request }

     { Data types }
     SQLJ_TYP_CHAR           =  1;    { Fixed length character string  }
     SQLJ_TYP_INTEGER        =  2;    { 4 byte unsigned short          }
     SQLJ_TYP_SMALL          =  3;    { 2 byte unsigned long           }
     SQLJ_TYP_BIN            =  4;    { Fixed length binary data       }
     SQLJ_TYP_INSQLDA        =  5;    { Input SQLDA                    }
     SQLJ_TYP_OUTSQLDA       =  6;    { Output SQLDA                   }
     SQLJ_TYP_INHV           =  7;    { Input SQLDA for host variable
                                         descriptions                  }
     SQLJ_TYP_OUTHV          =  8;    { Output SQLDA for host variable
                                         descriptions                   }
     SQLJ_TYP_SQLCA          =  9;    { SQLCA                          }
     SQLJ_TYP_BNDOPT         = 10;    { Bind option array              }
     SQLJ_TYP_CSTRING        = 11;    { Null-terminated character
                                         string                         }

     { Length and count defaults }

     SQLJ_LEN_SQLCA         = 136;    { SQLCA                          }
     SQLJ_LEN_CTK           =   8;    { Consistency token              }
     SQLJ_LEN_USERID        =   8;    { Userid                         }
     SQLJ_LEN_PGMN          =   8;    { Package name                   }
     SQLJ_LEN_SMALL         =   2;    { 2-Byte signed integer          }
     SQLJ_LEN_CDPG          =   4;    { Application or Database
                                              codepage                       }
     SQLJ_LEN_TBLNAM        =  18;    { Table name                     }
     SQLJ_LEN_DBNAME        =   8;    { Database name                  }
     SQLJ_LEN_DRDADBNAME    =  18;    { DRDA-1 database name           }
     SQLJ_LEN_PSWD          =   8;    { User password                  }
     SQLJ_LEN_NODE          =   8;    { Node name                      }
     SQLJ_BNDOPT_CNT        =   6;    { Bind option array count        }
     SQLJ_INDICATOR_ARRAY_SIZE= 8;    { Indicator array count          }

     SQLJ_RELNO         =$0100    ;    { SQLJRA version number          }
     SQLJRA_TTL       = 'SQLJRA  ';    { SQLJRA title                   }

     {********************************************************************}
     { Indicator array offset defintions                                  }
     {********************************************************************}

  {  sqlrtype = SQLJR_STARTGW
                          - sqlrflag[SQLJ_CONN_OFF]
                          - sqlrflag[SQLJ_USE_OFF]                           }

     SQLJ_CONN_OFF            = 0 ;   { Offset for Connection type     }
     SQLJ_USE_OFF             = 1 ;   { Offset for database use        }

     { SQLJ_CONN_OFF values                                                      }
     SQLJ_CONNECT             = 1 ;   { Connection operation           }
     SQLJ_MIGRATE             = 2 ;   { Migrate operation              }
     SQLJ_RESTORE             = 3 ;   { Restore database               }
     SQLJ_RESTART             = 4 ;   { Restart/recover database       }
     SQLJ_BACKUP              = 5 ;   { Backup database                }
     SQLJ_RECOVER             = 6 ;   { Recover database               }

     { SQLJ_USE_OFF values                                                       }
     SQLJ_USE_SHR           = 'S' ;   { Shared use connection          }
     SQLJ_USE_EXC           = 'X' ;   { Exclusive use connection       }

     {  sqlrtype = all SQLJ_DBSV sqlrtypes : Standards option
                             - sqlrflag[SQLJ_STND_OFF]                       }

     SQLJ_STND_OFF          =  0 ;   { Offset for standards option    }

     { SQLJ_STND_OFF values                                                      }
     SQLJ_STND_NONE         = '0' ;   { No compliance required         }
     SQLJ_STND_MIA          = '1' ;   { MIA compliance required        }
     SQLJ_STND_SQL89        = '2' ;   { SQL 89 compliance required     }

     { sqlrtype = SQLJR_COMMIT
                                - sqlrflag[SQLJ_CMMT_OFF]                  }

     SQLJ_CMMT_OFF            = 1 ;   { Offset for hold option         }

     { SQLJ_CMMT_OFF values                                                      }
     SQLJ_CMMT_NOHOLD         = 0 ;   { Commit                         }
     SQLJ_CMMT_HOLD           = 1 ;   { Commit hold                    }

     { sqlrtype = SQLJR_COMPILE
                           - sqlrflag[SQLJ_DCSR_OFF]
                           - sqlrflag[SQLJ_CSRH_OFF]
                           - sqlrflag[SQLJ_SG_OFF]                           }

     SQLJ_DCSR_OFF            = 1 ;   { Offset for Statement type      }
     SQLJ_CSRH_OFF            = 2 ;   { Offset for Cursor Hold option  }
     SQLJ_SG_OFF              = 3 ;   { Offset for Shallow Grammar     }

     { SQLJ_DCSR_OFF values                                                      }
     SQLJ_STMT_NDCLR          = 0 ;   { Statement is not Declare Cursor}
     SQLJ_STMT_DCLR           = 1 ;   { Statement is Declare Cursor    }

     { SQLJ_CSRH_OFF values                                                      }
     SQLJ_CSR_NOHOLD          = 0 ;   { Cursor not declared with Hold  }
     SQLJ_CSR_HOLD            = 1 ;   { Cursor declared with Hold      }

     { SQLJ_SG_OFF values                                                        }
     SQLJ_STMT_VALID          = 0 ;   { Statement recognized by
                                         precompiler                    }
     SQLJ_STMT_UNKNOWN        = 1 ;   { Statement not recognized by
                                         precompiler                    }

     { sqlrtype = SQLJR_EXECUTE
                             sqlrflag[SQLJ_EXEC_OFF]                      }

     SQLJ_EXEC_OFF            = 1 ;   { Offset for output SQLDA option }

     { SQLJ_EXEC_OFF and SQLJ_CSRDA_OFF values                                   }
     SQLJ_NO_OUTSQLDA         = 0 ;   { Do not return output SQLDA     }
     SQLJ_OUTSQLDA            = 1 ;   { Return output SQLDA            }


     { sqlrtype =  SQLJR_OPEN
                               - sqlrflag[SQLJ_CSRDA_OFF]
                               - sqlrflag[SQLJ_CSRRW_OFF]                 }

     SQLJ_CSRDA_OFF           = 1 ;   { Offset for SQLDA option        }
     SQLJ_CSRRW_OFF           = 2 ;   { Offset for READ/UPDATE option  }

     { SQLJ_CSRDA_OFF values                                                     }
     SQLJ_READ                = 0 ;   { Output SQLDA for read-only     }
     SQLJ_UPDATE              = 1 ;   { Output SQLDA will be modified  }

     { sqlrtype = SQLJR_PREPFINI
                            - sqlrflag[SQLJ_PFINI_OFF]                     }

     SQLJ_PFINI_OFF           = 0 ;   { Offset for Commit/Rollback     }

     { SQLJ_PFINI_OFF values                                                     }
     SQLJ_COMMIT              = 1 ;   { Commit package                 }
     SQLJ_ROLLBACK            = 0 ;   { Rollback package               }

     { sqlrtype = SQLJR_RUNSTATS
                            - sqlrflag[SQLJ_STATS_OFF]
                            - sqlrflag[SQLJ_SHRLV_OFF]                   }

     SQLJ_STATS_OFF           = 1 ;   { Offset for Statistics option   }
     SQLJ_SHRLV_OFF           = 2 ;   { Offset for Share level         }

     { SQLJ_STATS_OFF values are defined in sqlutil.pas                 }

     { SQLJ_SHRLV_OFF values  are defined in sqlutil.pas                }

{***************************************************************************}
{ Triplet defintions                                                        }
{***************************************************************************}

     { sqlrtype = SQLJR_STARTGW                                                  }
     SQLJ_UPW_OFF             = 0 ;   {  user password                 }
     SQLJ_ACP_OFF             = 1 ;   {  application code page         }
     SQLJ_ANN_OFF             = 2 ;   {  application node name         }
     SQLJ_APN_OFF             = 3 ;   {  application name              }
     SQLJ_DPW_OFF             = 4 ;   {  database password             }

     { sqlrtype = SQLJR_RPC                                                      }
     SQLJ_PRC_OFF             = 0 ;   {  procedure return code         }
     SQLJ_RPN_OFF             = 1 ;   {  remote procedure name         }
     SQLJ_IDA_OFF             = 2 ;   {  input sqlda                   }
     SQLJ_ODA_OFF             = 3 ;   {  output sqlda                  }
     SQLJ_DAT_OFF             = 4 ;   {  input data area               }

     { sqlrtype = SQLJR_COMPILE                                                  }
     SQLJ_STN_OFF             = 0 ;   {  statement number              }
     SQLJ_STT_OFF             = 1 ;   {  statement text                }
     SQLJ_CRN_OFF             = 2 ;   {  cursor name                   }
     SQLJ_SEL_OFF             = 3 ;   {  select string                 }

     { sqlrtype =  SQLJR_EXECIMMD
     SQLJR_PREPARE   SQLJR_REORG                                                   }
     SQLJ_TXT_OFF             = 0 ;   {  statement text                }
     SQLJ_ALP_OFF             = 1 ;   {  alternate path                }

     { sqlrtype = SQLJR_GETTA
              SQLJR_RUNSTATS                                             }
     SQLJ_TNM_OFF             = 0 ;   {  table name                    }
     SQLJ_INX_OFF             = 1 ;   {  index list                    }

     { sqlrtype = SQLJR_PREPINIT                                                 }

     SQLJ_BOA_OFF             = 0 ;   {  bind option array             }

{***************************************************************************}
{ Bind Option codepoints                                                    }
{ These are the DDM codepoints which correspond to the all the bind options }
{ which may be specified with the Database Connection Services Programming  }
{ Interface.                                                                }
{***************************************************************************}

     { sqlrtype = SQLJR_PREPINIT, sqljra.sqlrdata[SQLJ_BOA_OFF],             }
     { sqljra_bindopts.option                                                }

     SQLJ_BO_BNDCRTCTL       =$211D ;  { Bind create package option      }
     SQLJ_BO_BNDCHKEXS       =$211B ;  { Bind existence checking         }
     SQLJ_BO_PKGRPLOPT       =$211C ;  { Bind package replacement option }
     SQLJ_BO_PKGATHOPT       =$211E ;  { Bind package authorization      }
     SQLJ_BO_STTSTRDEL       =$2120 ;  { Bind statement string delimiter }
     SQLJ_BO_STTDECDEL       =$2121 ;  { Bind statement decimal delimiter}
     SQLJ_BO_STTDATFMT       =$2122 ;  { Bind date format option         }
     SQLJ_BO_STTTIMFMT       =$2123 ;  { Bind time format option         }
     SQLJ_BO_PKGISOLVL       =$2124 ;  { Isolation level                 }
     SQLJ_BO_PKGDFTCST       =$2125 ;  { Package default char subtype    }
     SQLJ_BO_QRYBLKCTL       =$2132 ;  { Query block protocol            }
     SQLJ_BO_DECPRC          =$2106 ;  { Decimal precision               }
     SQLJ_BO_PKGDFTCC        =$119A ;  { Package default CCSIDs of col   }
     SQLJ_BO_RDBRLSOPT       =$2129 ;  { RDB release option              }
     SQLJ_BO_BNDEXPOPT       =$2130 ;  { Bind explain option             }
     SQLJ_BO_PKGOWNID        =$2131 ;  { Package owner id                }
     SQLJ_BO_DFTRDBCOL       =$2128 ;  { Default RDB collection id       }
     SQLJ_BO_TITLE           =$0045 ;  { Default RDB collection id       }

     {   Database Manager internal values                                        }
     SQLJ_BO_STANDARD        =$F901 ;  { Standards compliance option     }

{***************************************************************************}
{ Bind Option values                                                        }
{ These are the DDM codepoints which correspond to the values for the bind  }
{ options which may be specified with the Database Connection Services      }
{ Programming Interface.                                                    }
{***************************************************************************}

     { sqlrtype = SQLJR_PREPINIT, sqljra.sqlrdata[SQLJ_BOA_OFF],                 }
     {            sqljra_bindopts.value                                          }

     SQLJ_BO_BNDCHKONL      =$2421 ;   { Syntax Check only               }
     SQLJ_BO_BNDNERALW      =$2422 ;   { Create package if no errors     }
     SQLJ_BO_BNDERRALW      =$2423 ;   { Create Package even if errors   }
     SQLJ_BO_BNDCHK         =$2421 ;   { Don't create package            }
     SQLJ_BO_BNDCRT         =$2422 ;   { Create package if no errors     }
     SQLJ_BO_BNDERR         =$2423 ;   { Create package if errors        }
     SQLJ_BO_EURFMT         =$242B ;   { European date format            }
     SQLJ_BO_EURTIMFMT      =$2430 ;   { European time format            }
     SQLJ_BO_ISOFMT         =$2429 ;   { ISO date format                 }
     SQLJ_BO_ISOTIMFMT      =$242E ;   { ISO time format                 }
     SQLJ_BO_JAPANFMT       =$242C ;   { Japanese date format            }
     SQLJ_BO_JISTIMFMT      =$2431 ;   { Japanese time format            }
     SQLJ_BO_USAFMT         =$242A ;   { USA date format                 }
     SQLJ_BO_USATIMFMT      =$242F ;   { USA time format                 }
     SQLJ_BO_FRCSNGROW      =$2410 ;   { Force single row query          }
     SQLJ_BO_LMTBLCK        =$2417 ;   { Limited block query             }
     SQLJ_BO_SNGROW         =$2418 ;   { Single row query                }
     SQLJ_BO_ISOLVLCHG      =$2441 ;   { Isolation lvl = change          }
     SQLJ_BO_ISOLVLCS       =$2442 ;   { Isolation lvl = cursor stability}
     SQLJ_BO_ISOLVLRR       =$2444 ;   { Isolation lvl = repeatable read }

     {   Database Manager internal values                                        }
     SQLJ_BO_STDSQL89        =$F902;   { SQL 89 standards compliance     }
     SQLJ_BO_STDMIA          =$F903;   { MIA standards compliance        }
     SQLJ_BO_STDNONE         =$F904;   { No standards compliance required}
     SQLJ_BO_DEFFMT          =$F905;   { Default country date format     }
     SQLJ_BO_DEFTIMFMT       =$F907;   { Default country time format     }
     SQLJ_BO_LOCAL           =$F906;   { Local country date format       }
     SQLJ_BO_LOCALTIM        =$F906;   { Local country time format       }

{***************************************************************************}
{ Structure Definitions                                                     }
{***************************************************************************}

TYPE
    { Bind Option Array Element                                                 }
    sqljra_bindopts=RECORD
                      alength:WORD;
                      option:WORD;
                      value:WORD;
                    END;

    { SQLJRA Triplet element                                                    }
    SQLJDATA=RECORD
                   sqlrdtl:ULONG;
                   sqlrdtt:ULONG;
                   sqlrdtp:PChar;
             END;

    { SQLJRA                                                                    }
    SQLJRA=RECORD
                sqlraid:ARRAY[0..7] OF BYTE;{Eye catcher = 'SQLJRA  '       }
                sqlrabc:ULONG;              { Size in bytes                  }
                sqlrelno:WORD;              { Version number                 }
                sqltype:WORD;               { Service type                   }
                sqlrtype:WORD;              { Request type                   }
                sqlrdnum:WORD;              { Number of triplets             }
                                            { SQLCA                          }
                sqlrcal:ULONG;              {   Length of SQLCA              }
                sqlrcat:ULONG;              {   Data type of SQLCA           }
                sqlrcap:PChar;              {   Pointer to SQLCA             }
                                            { Input SQLDA                    }
                sqlrdail:ULONG;             {   Length of input SQLDA        }
                sqlrdait:ULONG;             {   Data type of input SQLDA     }
                sqlrdapi:PChar;             {   Pointer to input SQLDA       }
                                            { Output SQLDA                   }
                sqlrdaol:ULONG;             {   Length of output SQLDA       }
                sqlrdaot:ULONG;             {   Data type of output SQLDA    }
                sqlrdapo:PChar;             {   Pointer to output SQLDA      }
                                            { Indicator array                }
                sqlrflgl:ULONG;             {   Length of indicator array    }
                sqlrflgt:ULONG;             {   Data type of indicator array }
                sqlrflag:PChar;             {   Pointer to indicator array   }
                                            { Userid                         }
                sqlrusrl:ULONG;             {   Length of userid             }
                sqlrusrt:ULONG;             {   Data type of userid          }
                sqlruser:PChar;             {   Pointer to userid            }
                                            { Database name                  }
                sqlrdbnl:ULONG;             {   Length of database name      }
                sqlrdbnt:ULONG;             {   Data type of database name   }
                sqlrdbnm:PChar;             {   Pointer to database name     }
                                            { Package creator                }
                sqlrcrel:ULONG;             {   Length of package creator    }
                sqlrcret:ULONG;             {   Data type of package creator }
                sqlrcrea:PChar;             {   Pointer to package creator   }
                                            { Section Number                 }
                sqlrsctl:ULONG;             {   Length of section number     }
                sqlrsctt:ULONG;             {   Data type of section number  }
                sqlrsect:PChar;             {   Pointer to section number    }
                                            { Package Name                   }
                sqlrpgml:ULONG;             {   Length of package name       }
                sqlrpgmt:ULONG;             {   Data type of package name    }
                sqlrpgmn:PChar;             {   Pointer to package name      }
                                            { Consistency token              }
                sqlrctkl:ULONG;             {   Length of consistency token  }
                sqlrctkt:ULONG;             {   Data type of consistency token}
                sqlrctkp:PChar;             {   Pointer to consistency token }
                                            {   Data triplets                }
                sqlrdata:ARRAY[0..SQLJR_MAX_DATA_ITEMS-1] OF SQLJDATA;
           END;

    SQLJCSRA=SQLJRA;                        { Connection Services
                                              SQLJRA                }
    SQLJDSRA=SQLJRA;                        { Database Services
                                              SQLJRA                }

CONST
     SQLJ_LEN_SQLJRA       =sizeof(SQLJRA);      { SQLJRA size           }
     SQLJ_LEN_SQLJCSRA     =sizeof(SQLJRA);      { SQLJCSRA size         }
     SQLJ_LEN_SQLJDSRA     =sizeof(SQLJRA);      { SQLJDSRA size         }


     SQLJACB_TTL       ='SQLJACB ';    { SQLJACB Title }
     SQLJACB_VER       =$0100;         { SQLJACB Version }

     { Connection type - SQLJ_ACBH.conn_type }
     SQLJ_CONN_DRD1   = 1;
     SQLJ_CONN_ASP0   = 2;
     SQLJ_CONN_LOC    = 3;
     SQLJ_CONN_VNDR   = 0;

     { ACB type - SQLJACB.sqlapcont }
     SQLJALOC        =$00 ;          { Database is local to Application }
     SQLJAREM        =$01 ;          { Database is remote to Application }

     { ACB Connection States - SQLJACB.sqlapconst }
     SQLJAINA        =$00000000 ;    { Application not connected }
     SQLJAIDL        =$00000001 ;    { Application is connected to DB }
     SQLJAREQ        =$00000003 ;    { SQL in progress, interrupt valid }
     SQLJAERR        =$00000004 ;    { Connection in error state }
     SQLJRCVY        =$00000005 ;    { Connection in Recovery state }
     SQLJ_CONN_PAUS  =$00000009 ;    { Connection in Paused state }
     SQLJ_IN_LUW     =$00000011 ;    { In Logical Unit of Work }

     { ACB Connection Pending States - SQLJACB.sqlapconst }
     SQLJAACT        =$00000000 ;    { Nothing Pending }
     SQLJASTA        =$00000100 ;    { Start Database Pending }
     SQLJASTO        =$00000200 ;    { Stop Database Pending }
     SQLJAINT        =$00000400 ;    { Request interrupted }
     SQLJ_PAUS_PEND  =$00000800 ;    { Pause Database Pending }
     SQLJ_DB_TERM    =$00001000 ;    { Database has Terminated }

     { ACB Information States - SQLJACB.sqlapconst }
     SQLJLOCR        =$00000000 ;    { Local Request }
     SQLJREMR        =$00010000 ;    { Remote Request }
     SQLJBUSY        =$00020000 ;    { Cleanup already in progress }

     { ACB Information States - SQLJACB.sqlapconst }
     SQLJNOIN        =$00000000 ;    { No Info }
     SQLJREST        =$01000000 ;    { Restart Request in Progress }
     SQLJCDIP        =$02000000 ;    { Create Database in Progress }
     SQLJBURS        =$04000000 ;    { Backup/Restore in Progress }
     SQLJMIGR        =$08000000 ;    { Migrate in Progress }
     SQLJBACK        =$10000000 ;    { Backup Only in Progress }

TYPE
     { SQLJ_ACBH }
     SQLJ_ACBH=RECORD
                     handle:LONG;
                     conn_type:SHORT;       { int to short. }
               END;

     SQLJACB=RECORD
                   sqlacbid:CSTRING[7];   { Control block eye catcher }
                   sqlacbsz:ULONG;        { Size in bytes }
                   sqlacbver:WORD;        { Version number }

                   sqlnacb:WORD;          { Reserved for Database Connection
                                            Router use only }
                   sqlapcont:WORD;        { Application connection type }
                   sqlapconst:ULONG;      { Application connection state }

                   { Process and thread id }
                   sqlappid:WORD;      { Process ID of source element }
                   sqlaptid:WORD;      { Thread ID of source element }

                   { Codepages }
                   sqlapcpg:WORD;      { Codepage of originating
                                         application }
                   sqldbcpg:WORD;      { Codepage of database }

                   { Datastream type }
                   sqldtast:WORD;      { Datastream type }

                   { Originating Application node }
                   sqlapnnl:ULONG;      { Length of application node name }
                   sqlapnnt:WORD;       { Data type of application node name }
                   sqlapnn:POINTER;     { Pointer to application node name }

                   { Originating Application ID }
                   sqlapidl:ULONG;      { Length of application id }
                   sqlapidt:WORD;       { Data type of application id }
                   sqlapid:POINTER;     { Pointer to application id }

                   { Database Connection Router internal control block }
                   sqlcrtcbl:ULONG;     { Length of Database Connection
                                          Router internal control block }
                   sqlcrtcbt:WORD;      { Data type of Database Connection
                                          Router internal control block }
                   sqlcrtcb:POINTER;    { Pointer to Database Connection
                                          Router internal control block
                                          (Database Connection Router use
                                           only) }

                   { Target internal control block }
                   sqlcsvcbl:ULONG;     { Length of target internal control
                                          block }
                   sqlcsvcbt:WORD;      { Data type of target internal
                                          control block }
                   sqlcsvcb:POINTER;    { Pointer to target internal control
                                          block }

                   { Userid }
                   sqlusl:ULONG;        { Length of userid }
                   sqlust:WORD;         { Data type of userid }
                   sqluser:PChar;       { Pointer to userid }

                   { Alias name in system database directory }
                   sqldball:ULONG;      { Length of alias name }
                   sqldbalt:WORD;       { Data type of alias name }
                   sqldbal:PChar;       { Pointer to alias name of database
                                           in system database directory }

                   { Database name in system database directory }
                   sqlldbnl:ULONG;      { Length of database name }
                   sqlldbnt:WORD;       { Data type of database name }
                   sqlldbn:PChar;       { Pointer to name of database
                                          in system database directory }

                   { Node name in system database directory }
                   sqlnnl:ULONG;        { Length of node name }
                   sqlnnt:WORD;         { Data type of node name }
                   sqlnn:PChar;         { Pointer to node name in system
                                          database directory }

                   { Database name in Database Connection Services directory }
                   sqlsdbnl:ULONG;      { Length of database name }
                   sqlsdbnt:WORD;       { Data type of database name }
                   sqlsdbn:PChar;       { Pointer to database name in Database
                                          Connection Services directory }

                   { Target DLL name }
                   sqlpgmnl:ULONG;      { Length of DLL name }
                   sqlpgmnt:WORD;       { Data type of DLL name }
                   sqlpgmn:PChar;       { Pointer to DLL name of target
                                          element }

                   { Parameter string }
                   sqlparml:ULONG;      { Length of parameter string }
                   sqlparmt:WORD;       { Data type of parameter string }
                   sqlparm:PChar;       { Pointer to parameter string from
                                          Database Connection Services
                                          directory }
                   { Target element data heap }
                   sqlrshpl:ULONG;      { Length of target data heap }
                   sqlrshpt:WORD;       { Data type of target data heap }
                   sqlrshp:PChar;       { Pointer to target data heap }
             END;

CONST
     SQLJ_LEN_SQLJACB =sizeof(SQLJACB);

     { Interface Parameters/Structures/Return Codes }


     { Parameters for START USING DATABASE }
     SQL_USE_SHR           = 'S';      { USE = Share           }
     SQL_USE_EXC           = 'X';      { USE = Exclusive       }

     { Sizes for entries in sqledinfo, sqleninfo, sqledbstat, sqleusrstat &
                        sql_dir_entry                                }

     SQL_ALIAS_SZ          = 8  ;      { Alias name            }
     SQL_USERID_SZ         = 8  ;      { User Id               }
     SQL_DBNAME_SZ         = 8  ;      { Database name         }
     SQL_DRIVE_SZ          = 2  ;      { Drive (Qualified)     }
     SQL_INAME_SZ          = 8  ;      { Internal db name      }
     SQL_NNAME_SZ          = 8  ;      { Node name             }
     SQL_DBTYP_SZ          = 20 ;      { Type of database      }
     SQL_CMT_SZ            = 30 ;      { Comment               }
     SQL_LOCLU_SZ          = 8  ;      { Local_lu              }
     SQL_RMTLU_SZ          = 8  ;      { Partner_lu            }
     SQL_MODE_SZ           = 8  ;      { Mode                  }
     SQL_NRESERVE_SZ       = 0  ;      { Reserved              }
     SQL_DBSTAT_ALIAS_SZ   = 16 ;      { Alias name            }
     SQL_DBSTAT_DBNAME_SZ  = 16 ;      { Database name         }
     SQL_LONG_NAME_SZ      = 18 ;      { Host database name    }
     SQL_CS_SZ             = 256;      { collating sequence    }
     SQL_PARAMETER_SZ      = 512;      { Parameter string      }
     SQL_NETID_SZ          = 8  ;      { Network ID            }

     { Parameters for Entry Type in sqledinfo }

     SQL_HOME              = '2' ;     { Database is home      }
     SQL_REMOTE            = '1' ;     { Database is remote    }
     SQL_INDIRECT          = '0' ;     { Database is indirect  }

     { Parameters for adapter number in sqlectnd }

     SQL_ADAPTER_0         = 0 ;       { Adapter number 0      }
     SQL_ADAPTER_1         = 1 ;       { Adapter number 1      }
     SQL_ADAPTER_MIN       = 0 ;       { Minimum adapter number}
     SQL_ADAPTER_MAX       = 1 ;       { Maximum adapter number}

     { Definitions of constants used for Structure IDs }

     SQL_DCS_STR_ID           =$0100 ;  { DCS directory entry id    }
     SQL_NODE_STR_ID          =$0100 ;  { Catalog node struct id    }

     { Parameters for protcol types in sqlectnd }

     SQL_PROTOCOL_APPC       =$00 ;    { APPC                       }
     SQL_PROTOCOL_NETB       =$01 ;    { NETBIOS                    }
     SQL_PROTOCOL_APPN       =$02 ;    { APPN                       }

     { Parameters for New Create Database api }

     SQL_CS_SYSTEM        =  0 ;       { Coll. Seq. from System    }
     SQL_CS_USER          = -1 ;       { Coll. Seq. from User      }
     SQL_CS_NONE          = -2 ;       { Coll. Seq. - none         }


TYPE
    {****************************************}
    { Database Description Block structure   }
    {****************************************}
    sqledbdesc=RECORD
                 sqldbdid:CSTRING[7];      { eye catcher                }
                 sqldbccp:LONG;            { comment code page          }
                 sqldbcss:LONG;            { Source of collating seq.   }
                 sqldbudc:ARRAY[0..SQL_CS_SZ-1] OF BYTE; { user-defined collating seq.}
                 sqldbcmt:ARRAY[0..SQL_CMT_SZ] OF BYTE;  { comment                    }
               END;

    {****************************************}
    { Database Directory Scan data structure }
    {****************************************}
    sqledinfo=RECORD
                  alias:ARRAY[0..SQL_ALIAS_SZ-1] OF BYTE;   { Alias name                 }
                  dbname:ARRAY[0..SQL_DBNAME_SZ-1] OF BYTE; { Database name              }
                  drive:ARRAY[0..SQL_DRIVE_SZ-1] OF BYTE;   { Drive 'd:'                 }
                  intname:ARRAY[0..SQL_INAME_SZ-1] OF BYTE; { Database subdirectory      }
                  nodename:ARRAY[0..SQL_NNAME_SZ-1] OF BYTE;{ Node name                  }
                  dbtype:ARRAY[0..SQL_DBTYP_SZ-1] OF BYTE;  { Release information        }
                  comment:ARRAY[0..SQL_CMT_SZ-1] OF BYTE;   { Comment                    }
                  com_codepage:SHORT;                       { Code page of comment       }
                  atype:BYTE;                               { Entry type - defines above }
              END;

    {************************************}
    { Node Directory Scan data structure }
    {************************************}
    sqleninfo=RECORD
                nodename:ARRAY[0..SQL_NNAME_SZ-1] OF BYTE;    { Node name             }
                local_lu:ARRAY[0..SQL_LOCLU_SZ-1] OF BYTE;    { Local_lu name         }
                partner_lu:ARRAY[0..SQL_RMTLU_SZ-1] OF BYTE;  { Partner_lu name       }
                mode:ARRAY[0..SQL_MODE_SZ-1] OF BYTE;         { Mode                  }
                comment:ARRAY[0..SQL_CMT_SZ-1] OF BYTE;       { Comment               }
                com_codepage:WORD;                            { Comment code page     }
                adapter:WORD;                                 { Adapter # for Net Bios}
                networkid:ARRAY[0..SQL_NETID_SZ-1] OF BYTE;   { Network ID            }
                protocol:BYTE;                                { Protocol type         }
              END;

    {********************************************}
    { General Catalog Node structures and defines}
    {********************************************}
    sqle_node_struct=RECORD
                        struct_id:WORD;          { Structure Identifier  }
                        codepage:WORD;           { Codepage for comment  }
                        comment:ARRAY[0..SQL_CMT_SZ] OF BYTE; { Comment               }
                        nodename:ARRAY[0..SQL_NNAME_SZ] OF BYTE;{ Node name             }
                        protocol:BYTE;           { Protocol Type         }
                     END;

    sqle_node_appc=RECORD             { For APPC protocol     }
                     local_lu:ARRAY[0..SQL_LOCLU_SZ] OF BYTE;    { Local_lu name         }
                     partner_lu:ARRAY[0..SQL_RMTLU_SZ] OF BYTE;  { Alias Partner_lu name }
                     mode:ARRAY[0..SQL_MODE_SZ] OF BYTE;         { Mode                  }
                   END;

    sqle_node_netb=RECORD             { For Netbios Protocol  }
                     adapter:WORD;                       { Adapter Number        }
                     remote_nname:ARRAY[0..SQL_RMTLU_SZ] OF BYTE;{ Remote Workstation name}
                   END;

    sqle_node_appn=RECORD             { For APPN protocol     }
                     networkid:ARRAY[0..SQL_NETID_SZ] OF BYTE;   { Network ID            }
                     remote_lu:ARRAY[0..SQL_RMTLU_SZ] OF BYTE;   { Remoter lu name       }
                     local_lu:ARRAY[0..SQL_LOCLU_SZ] OF BYTE;    { Local_lu name         }
                     mode:ARRAY[0..SQL_MODE_SZ] OF BYTE;         { Mode                  }
                   END;


CONST
    { Sizes for entries in sqlesystat & sqleusrstat }

    SQL_PRODNAME_SZ        = 30 ;      { Product name          }
    SQL_COMPID_SZ          = 9  ;      { Component Id          }
    SQL_CORRLVL_SZ         = 8  ;      { Corrective serv level }
    SQL_RLSLVL_SZ          = 4  ;      { Release level         }

    { Defines for STATUS parameter on Collect Database Status }
    SQL_OPSTAT_SYSTEM      = 1  ;      { Collect system status }
    SQL_OPSTAT_DATABASE    = 2  ;      { Collect database stat }
    SQL_OPSTAT_ALL         = 3  ;      { Collect all status    }

    { Defines for OBJECT parameter on Collect Database Status }
    SQL_OBJECT_DATABASE    = 1  ;      { Specified database    }
    SQL_OBJECT_DRIVE       = 2  ;      { Specified drive       }
    SQL_OBJECT_LOCAL       = 3  ;      { All local databases   }

    { Defines for 'location' field in sqledbstat }
    SQL_LOCAL_TYPE         = 'L';
    SQL_REMOTE_TYPE        = 'R';

    { Defines for 'trans_state' field in sqleusrstat }
    SQL_TRANS_STATE_STARTED= 'S';
    SQL_TRANS_STATE_READ   = 'R';
    SQL_TRANS_STATE_CHANGED= 'C';

    { Defines for 'lock_state' field in sqleusrstat }
    SQL_LOCK_STATE_WAIT    = 'W';
    SQL_LOCK_STATE_NOWAIT  = 'N';


TYPE
    {*****************************************}
    { Collect Database Status data structures }
    {*****************************************}

    { System Status data structure }
    sqlesystat=RECORD
                     current_time:ULONG;
                     time_zone_disp:LONG;
                     product_name:ARRAY[0..SQL_PRODNAME_SZ-1] OF BYTE;
                     component_id:ARRAY[0..SQL_COMPID_SZ-1] OF BYTE;
                     reserved:BYTE;                       { Reserved byte  }
                     release_lvl:ARRAY[0..SQL_RLSLVL_SZ-1] OF BYTE;
                     corr_serv_lvl:ARRAY[0..SQL_CORRLVL_SZ-1] OF BYTE;
               END;

    { Database Status data structure }
    sqledbstat=RECORD
                  backup_time:ULONG;        { Last backup time           }
                  time_zone_disp:LONG;      { Time zone of backup time   }
                  connects:WORD;            { Number of current users    }
                  db_alias:ARRAY[0..SQL_DBSTAT_ALIAS_SZ-1] OF BYTE;  { Alias name          }
                  db_name:ARRAY[0..SQL_DBSTAT_DBNAME_SZ-1] OF BYTE;  { Database name       }
                  location:BYTE;            { Local / Remote Database    }
                  reserved:BYTE;            { Reserved byte              }
                  drive:ARRAY[0..SQL_DRIVE_SZ-1] OF BYTE;     { Drive containing database  }
                  node:ARRAY[0..SQL_NNAME_SZ-1] OF BYTE;      { Node containing database   }
                  db_type:ARRAY[0..SQL_DBTYP_SZ-1] OF BYTE;   { "OS2 DB2"                  }
               END;

    { User Status data structure }
    sqleusrstat=RECORD
                    con_trans:ULONG;        { Transactions since connect }
                    con_reqs:ULONG;         { Requests since connect     }
                    cur_reqs:ULONG;         { Requests current transact  }
                    connect_time:ULONG;     { Time since connect         }
                    trans_time:ULONG;       { Time since current transact}
                    authid:ARRAY[0..SQL_USERID_SZ-1] OF BYTE;   { User's Id                  }
                    node:ARRAY[0..SQL_NNAME_SZ-1] OF BYTE;      { Nodename of connected user }
                    authority_lvl:WORD;     { User's authority level     }
                    trans_state:BYTE;       { Transaction state          }
                    lock_state:BYTE;        { Transaction lock state     }
                END;

    {*****************************************}
    { DDCS Directory Entry Data Structure     }
    {*****************************************}

    sql_dir_entry=RECORD
                    struct_id:WORD;           { Structure Identifier       }
                    release:WORD;             { Release level of entry     }
                    codepage:WORD;            { Codepage of comment        }
                    comment:ARRAY[0..SQL_CMT_SZ] OF BYTE;   { Directory entry comment    }
                    ldb:ARRAY[0..SQL_DBNAME_SZ] OF BYTE;    { Local DB name              }
                    tdb:ARRAY[0..SQL_LONG_NAME_SZ] OF BYTE; { Target (host) DB name      }
                    ar:ARRAY[0..SQL_DBNAME_SZ] OF BYTE;     { Appl. requester DLL name   }
                    parm:ARRAY[0..SQL_PARAMETER_SZ] OF BYTE;{ Parameter string           }
                  END;

CONST
     SQLENOP = 0;

     { SQL Return Codes in SQLCODE for Environment Commands }

     SQLE_RC_INLUW        =  -752; { Connect to other DB not allowed   }
     SQLE_RC_W863         =   863; { only SBCS data allowed            }

     SQLE_RC_E953         =  -953; { agent heap too small              }
     SQLE_RC_E957         =  -957; { requestor comm heap too small     }
     SQLE_RC_E959         =  -959; { server comm heap too small        }
     SQLE_RC_E961         =  -961; { rqstr remote svcs heap too small  }
     SQLE_RC_E962         =  -962; { svr remote svcs heap too small    }

     SQLE_RC_INVNEWLOGP   =   993; { New log path is invalid           }
     SQLE_RC_INVLOGP      =   995; { Current log path is invalid       }

     SQLE_RC_INVALIAS     =  -1000;{ invalid alias                     }
     SQLE_RC_INVDBNAME    =  -1001;{ invalid database name             }
     SQLE_RC_INVDRIVE     =  -1002;{ invalid drive                     }
     SQLE_RC_INVPSW       =  -1003;{ invalid password                  }
     SQLE_RC_INSSTOR      =  -1004;{ insuf storage on file system      }
     SQLE_RC_DUPALIAS     =  -1005;{ duplicate alias                   }
     SQLE_RC_WRONGCODEPG  =  -1006;{ Appl code page does not match db  }
     SQLE_RC_INV_NEWPSW   =  -1008;{ invalid new password              }
     SQLE_RC_INVREMOTE    =  -1009;{ invalid remote command            }

     SQLE_RC_INVTYPE      =  -1010;{ invalid type                      }
     SQLE_RC_NODRIVE      =  -1011;{ no drive for indirect entry       }
     SQLE_RC_NONODE       =  -1012;{ no nodename for remote entry      }
     SQLE_RC_NODB         =  -1013;{ alias or database name not found  }
     SQLE_RC_NOMORE       =   1014;{ no more entries                   }
     SQLE_RC_DB_RESTART   =  -1015;{ database needs restart            }
     SQLE_RC_INVLLU       =  -1016;{ invalid local_lu alias            }
     SQLE_RC_INVMODE      =  -1017;{ invalid mode                      }
     SQLE_RC_DUPNODE      =  -1018;{ duplicate node name               }
     SQLE_RC_INVNODE      =  -1019;{ invalid node name                 }

     SQLE_RC_MAXNODE      =  -1020;{ node could not be cataloged       }
     SQLE_RC_NOTNODE      =  -1021;{ nodename not found                }
     SQLE_RC_INSSYS       =  -1022;{ insufficient system resources     }
     SQLE_RC_NOCONV       =  -1023;{ communication conversation failed }
     SQLE_RC_NOSUDB       =  -1024;{ no start using database issued    }
     SQLE_RC_DBACT        =  -1025;{ databases are active              }
     SQLE_RC_INVSTRT      =  -1026;{ DATABASE MANAGER already started  }
     SQLE_RC_NONODEDIR    =  -1027;{ node directory not found          }
     SQLE_RC_INVRLU       =  -1029;{ partner lu not specified          }

     SQLE_RC_MAXDB        =  -1030;{ database directory full           }
     SQLE_RC_NODBDIR      =  -1031;{ database directory not found      }
     SQLE_RC_NOSTARTG     =  -1032;{ START DATABASE MANAGER not issued }
     SQLE_RC_DIRBUSY      =  -1033;{ database directory being updated  }
     SQLE_RC_DBBAD        =  -1034;{ database is damaged               }
     SQLE_RC_DB_INUSE     =  -1035;{ database already in use           }
     SQLE_RC_FILEDB       =  -1036;{ database file error               }
     SQLE_RC_FILENODE     =  -1038;{ node directory file error         }
     SQLE_RC_FILEDIR      =  -1039;{ directory file error              }

     SQLE_RC_MAXAPPLS     =  -1040;{ Maximum Number of applications    }
     SQLE_RC_MAXDBS       =  -1041;{ Maximum Number of DB started      }
     SQLE_RC_SYSERR       =  -1042;{ system error                      }
     SQLE_RC_CATBOOT      =  -1043;{ catalog bootstrap failure         }
     SQLE_RC_INTRRPT      =  -1044;{ request interrupted by ctrl+break }
     SQLE_RC_INVINDIR     =  -1045;{ invalid level of indirection      }
     SQLE_RC_INVAUTHID    =  -1046;{ invalid userid                    }
     SQLE_RC_APCONN       =  -1047;{ appl already connect to another db}
     SQLE_RC_USEINVALID   =  -1048;{ invalid use specified             }
     SQLE_RC_APPSERR      =   -900;{ appl state in error               }

     SQLE_RC_UNCHOME      =  -1050;{ cannot uncatalog home database    }
     SQLE_RC_NODIRDRV     =  -1051;{ db direct. drive does not exist   }
     SQLE_RC_NODBDRV      =  -1052;{ database drive does not exist     }
     SQLE_RC_INTBUSY      =  -1053;{ interrupt already in progress     }
     SQLE_RC_COMMINP      =  -1054;{ commit in progress - no int's     }
     SQLE_RC_ROLLINP      =  -1055;{ rollback in progress - no int's   }
     SQLE_RC_MAXSCAN      =  -1056;{ maximum allowable scans exceeded  }
     SQLE_RC_NODENTRY     =   1057;{ no entries in directory           }
     SQLE_RC_INVHAND      =  -1058;{ invalid input handle              }
     SQLE_RC_NOSCAN       =  -1059;{ open scan not issued              }

     SQLE_RC_NOCONNECT    =  -1060;{ user lacks connect privilege      }
     SQLE_RC_BADPATH      =  -1062;{ database path not found           }
     SQLE_RC_START_OK     =  -1063;{ startdbs successful               }
     SQLE_RC_STOP_OK      =  -1064;{ stopdbs successful                }
     SQLE_RC_DB_BADBINDS  =   1065;{ n utilities not bound             }
     SQLE_RC_NOMSG        =  -1068;{ message file not found            }
     SQLE_RC_INVDROP      =  -1069;{ DB invalid type for drop          }

     SQLE_RC_INVDBNAME_PTR=  -1070;{ Invalid Database Name ptr         }
     SQLE_RC_INVALIAS_PTR =  -1071;{ Invalid Alias pointer             }
     SQLE_RC_INVPSW_PTR   =  -1074;{ Invalid Password pointer          }
     SQLE_RC_INVCOMM_PTR  =  -1075;{ Invalid Comment pointer           }
     SQLE_RC_INVCNT_PTR   =  -1076;{ Invalid Count pointer             }
     SQLE_RC_INVHAND_PTR  =  -1077;{ Invalid Handle Pointer            }
     SQLE_RC_INVBUFF_PTR  =  -1078;{ Invalid Buffer pointer            }
     SQLE_RC_INVNODE_PTR  =  -1079;{ Invalid Node Pointer              }

     SQLE_RC_INVLLU_PTR   =  -1080;{ Invalid Local Lu Pointer          }
     SQLE_RC_INVRLU_PTR   =  -1081;{ Invalid Remote Lu Pointer         }
     SQLE_RC_INVMODE_PTR  =  -1082;{ Invalid Mode Pointer              }
     SQLE_RC_BAD_DBDB     =  -1083;{ Bad Database Description Block    }
     SQLE_RC_KSEGSFAIL    =  -1084;{ Cannot Allocate Kernel Segments   }
     SQLE_RC_APPHEAPFAIL  =  -1085;{ Cannot Allocate Application heap  }
     SQLE_RC_OS2ERROR     =  -1086;{ Unexpected OS/2 error             }
     SQLE_RC_BIND_LIST    =   1087;{ Bind list could not be opened     }
     SQLE_RC_BIND_ERROR   =   1088;{ Error occurred during bind        }
     SQLE_RC_BIND_INTRRPT =   1089;{ Binding was interrupted           }

     SQLE_RC_BAD_APP_REL  =  -1090;{ Release number of APP is invalid  }
     SQLE_RC_BAD_DB_REL   =  -1091;{ Release number of database bad    }

     SQLE_RC_INSAUTH      =  -1092;{ Authorization error               }
     SQLE_RC_NOLOGON      =  -1093;{ User not logged on                }
     SQLE_RC_NDBUSY       =  -1094;{ Node dir being updated            }
     SQLE_RC_MAX_NDSCAN   =  -1095;{ Max node scans open               }
     SQLE_RC_REQTYPE      =  -1096;{ Invalid type for requester node   }
     SQLE_RC_NODERR       =  -1097;{ Node not found for remote db      }
     SQLE_RC_APCONN_SAME  =  -1098;{ appl is already connected to db   }
     SQLE_RC_WRPROT_ERR   =  -1099;{ write protect error on diskette   }

     SQLE_RC_NODE_WARN    =   1100;{ node not cataloged for database   }
     SQLE_RC_REMCONN_ERR  =  -1101;{ remote communications error       }
     SQLE_RC_MIG_NODB     =  -1102;{ No Database Name provided in Call }
     SQLE_RC_MIG_OK       =  -1103;{ Migration Successful Message      }
     SQLE_RC_INVPROG_PTR  =  -1104;{ Invalid program name pointer     }
     SQLE_RC_INV_SPDB     =  -1105;{ Invalid Stop Using Database       }
     SQLE_RC_INVALID_PROC =  -1106;{ Program invalid                   }
     SQLE_RC_INTRP_PROC   =  -1107;{ Program interrupted               }
     SQLE_RC_SYSERR_PROC  =  -1108;{ Unexpected I/O or OS/2 error      }
     SQLE_RC_NOFILE_PROC  =  -1109;{ Program file not found            }
     SQLE_RC_ERROR_PROC   =  -1110;{ Program error                     }
     SQLE_RC_BADPGN_PROC  =  -1111;{ Invalid DLL name format           }
     SQLE_RC_INSMEM_PROC  =  -1112;{ No memory loading DLL             }
     SQLE_RC_SQLDA_DATATYPE= -1113;{ Data type in output SQLDA changed }
     SQLE_RC_SQLDA_LENGTH =  -1114;{ Data length in output SQLDA change}
     SQLE_RC_SQLDA_VARS   =  -1115;{ Number of sqlvars changed in SQLDA}
     SQLE_RC_BKP_PEND     =  -1116;{ Backup pending                    }
     SQLE_RC_ROLLFWD_PEND =  -1117;{ Roll forward pending              }
     SQLE_RC_BKP_INPROG   =  -1118;{ need to rerun the Backup process  }
     SQLE_RC_RST_INPROG   =  -1119;{ need to rerun the Restore process }
     SQLE_RC_BR_INPROG    =  -1120;{ need to rerun either Backup or    }

     SQLE_RC_INVNODESTR_PTR= -1121;{ Node strucutre ptr invalid        }
     SQLE_RC_INVPROTOCOL_PTR=-1122;{ Protocol strucutre ptr invalid    }
     SQLE_RC_INVPROTOCOL  =  -1123;{ Invalid protocol type             }
     SQLE_RC_INVRNNAME    =  -1124;{ Invalid remote workstation name   }
     SQLE_RC_INVADAPTER   =  -1125;{ Invalid adapter number            }
     SQLE_RC_INVNETID     =  -1126;{ Invalid network id                }
     SQLE_RC_INVPLU       =  -1127;{ Invalid real partner LU name      }

     SQLE_RC_INVOS_OBJ    =  -1200;{ invalid object specified          }
     SQLE_RC_INVOS_STAT   =  -1201;{ invalid status specified          }
     SQLE_RC_INVOS_NOSTAT =  -1202;{ status has not been collected     }
     SQLE_RC_INVOS_NOUSER =  -1203;{ no users connected to database    }
     SQLE_RC_UNSUPP_CODEPG=  -1204;{ active codepage is not supported  }

     SQLE_RC_NO_SHRD_SEG  =  -1220;{ DBM shared mem set unavailable    }
     SQLE_RC_NO_ASL_HEAP  =  -1221;{ ASL heap cannot be allocated      }
     SQLE_RC_ASL_TOO_SMALL=  -1222;{ ASL heap is too small             }
     SQLE_RC_NO_AGENT_AVAIL= -1223;{ No more agents available          }
     SQLE_RC_DBM_NOT_RUNNING=-1224;{ DBM is not started                }

     SQLE_RC_NOUEXIT      =  -1267;{ SQLUEXIT file not found           }

     SQLE_RC_FILEDCS      =  -1310;{ DCS Directory file access error   }
     SQLE_RC_DCSDIR_NF    =  -1311;{ DCS Directory not found           }
     SQLE_RC_NO_ENTRY     =  -1312;{ DCS Directory is empty            }
     SQLE_RC_MAX_ENTRY    =  -1313;{ DCS Directory is full             }
     SQLE_RC_INVENTRY_PTR =  -1314;{ Entry parameter pointer invalid   }
     SQLE_RC_INVLDB       =  -1315;{ LDB name has invalid chars        }
     SQLE_RC_LDB_NF       =  -1316;{ DCS Directory entry not found     }
     SQLE_RC_DUPLDB       =  -1317;{ DCS Directory duplicate entry     }
     SQLE_RC_INVLENGTH    =  -1318;{ Invalid element length            }
     SQLE_RC_ENTRYNOT_COL =  -1319;{ Entries have not been collected   }
     SQLE_RC_GDBUSY       =  -1320;{ Cannot access DCS Dir at this time}
     SQLE_RC_INVSTRUCT_ID =  -1321;{ Invalid structure ID              }
     SQLE_RC_DRDANSP      =  -1325;{ Remote function not supported     }
     SQLE_RC_ACCD         =  -1326;{ File or directory access denied   }
     SQLE_RC_IMPLCONN_INVDB= -1327;{ Implicit connect - invalid dbname }
     SQLE_RC_IMPLCONN_NODB=  -1328;{ Implicit connect - alias not found}
     SQLE_RC_PATH_TOO_LONG=  -1329;{ Input path too long               }



    {******************************************************}
    { Database Environment Commands -- Function Prototypes }
    {******************************************************}

IMPORTS
       { ALTER DATABASE PASSWORD }
       FUNCTION sqlealtd_api (database:CSTRING;     { database }
                              oldpasswd:CSTRING;    { old password }
                              newpasswd:CSTRING;    { new password }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlealtd_api';
       { CATALOG DATABASE }
       FUNCTION sqlecatd_api (database:CSTRING;     { database }
                              alias:CSTRING;        { alias }
                              atype:LONGWORD;           { type }
                              nodename:CSTRING;     { nodename }
                              drive:LONGWORD;           { drive }
                              comment:CSTRING;      { comment }
                              commentcp:LONGWORD;       { comment codepage }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlecatd_api';
       { CATALOG NODE }
       FUNCTION sqlecatn_api (nodename:CSTRING;     { nodename }
                              locallu:CSTRING;      { local lu }
                              remotelu:CSTRING;     { remote lu }
                              mode:CSTRING;         { mode }
                              comment:CSTRING;      { comment }
                              cp:LONGINT;             { codepage }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA    }
                  APIENTRY; 'SQLE32' name 'sqlecatn_api';
       { NEW CREATE DATABASE }
       FUNCTION sqlecrdb_api (database:CSTRING;     { database }
                              drive:LONGWORD;           { drive }
                              VAR dblock:sqledbdesc;{ database descriptor block }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA  }
                  APIENTRY; 'SQLE32' name 'sqlecrdb_api';
       { CREATE DATABASE }
       FUNCTION sqlecred_api (database:CSTRING;     { database }
                              drive:LONGWORD;           { drive }
                              passwd:CSTRING;       { spare, was password }
                              comment:CSTRING;      { comment }
                              cp:LONGINT;             { comment code page }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlecred_api';
       { GENERAL CATALOG NODE }
       FUNCTION sqlectnd_api (VAR node:sqle_node_struct; { Node Structure pointer }
                              p:POINTER;         { Protocol Structure pointer }
                              VAR asqlca:TSQLCA):INTEGER;  { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlectnd_api';
       { CHANGE DATABASE COMMENT }
       FUNCTION sqledchg_api (database:CSTRING;     { database }
                              drive:LONGWORD;           { drive }
                              comment:CSTRING;      { comment }
                              cp:LONGINT;             { comment codepage }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqledchg_api';
       { CLOSE DIRECTORY SCAN }
       FUNCTION sqledcls_api (handle:LONGWORD;      { handle }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqledcls_api';
       { GET NEXT DIRECTORY ENTRY }
       FUNCTION sqledgne_api (handle:LONGWORD;          { handle }
                              VAR buffer:sqledinfo; { buffer }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqledgne_api';
       { OPEN DIRECTORY SCAN }
       FUNCTION sqledops_api (drive:LONGWORD;           { drive }
                              VAR Handle:WORD;      { handle }
                              VAR Count:WORD;       { count }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqledops_api';
       { DROP DATABASE }
       FUNCTION sqledrpd_api (database:CSTRING;     { database }
                              passwd:CSTRING;       { spare, was password }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqledrpd_api';
       { END SAVE-POINT }
       FUNCTION sqleensp (VAR asqlca:TSQLCA):INTEGER;       { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqleensp';
       { FREE DATABASE STATUS RESOURCES }
       FUNCTION sqlefree_api (VAR asqlca:TSQLCA):INTEGER;     { SQLCA                          }
                  APIENTRY; 'SQLE32' name 'sqlefree_api';

       { ADD DCS DIRECTORY ENTRY   }
       FUNCTION sqlegdad_api (VAR entry:sql_dir_entry;  { Pointer to entry structure }
                              VAR asqlca:TSQLCA):INTEGER;         { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlegdad_api';
       { CLOSE DCS DIRECTORY SCAN }
       FUNCTION sqlegdcl_api (VAR asqlca:TSQLCA):INTEGER;
                  APIENTRY; 'SQLE32' name 'sqlegdcl_api';
       { DELETE DCS DIRECTORY ENTRY }
       FUNCTION sqlegdel_api (VAR entry:sql_dir_entry;  { Pointer to entry structure }
                              VAR asqlca:TSQLCA):INTEGER;       { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlegdel_api';
       { GET DCS DIRECTORY ENTRY }
       FUNCTION sqlegdge_api (VAR entry:sql_dir_entry;  { Pointer to entry structure }
                              VAR asqlca:TSQLCA):INTEGER;         { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlegdge_api';
       { COPY DCS DIRECTORY ENTRIES }
       FUNCTION sqlegdgt_api (VAR Count:SHORT;   { Pointer to count variable }
                              VAR entry:sql_dir_entry;  { Pointer to entry structure }
                              VAR asqlca:TSQLCA):INTEGER;  { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlegdgt_api';
       { SCAN DCS DIRECTORY       }
       FUNCTION sqlegdsc_api (VAR Count:SHORT;   { Pointer to count variable }
                              VAR asqlca:TSQLCA):INTEGER;         { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlegdsc_api';
       { DCS PROGRAMMING INTERFACE }
       FUNCTION sqledcsr_api (VAR handle:sqlj_acbh;      { SQLJACB handle }
                              VAR asqljra:SQLJRA):INTEGER;        { Pointer to SQLJRA }
                  APIENTRY; 'SQLE32' name 'sqledcsr_api';
       { INTERRUPT }
       FUNCTION sqleintr_api:INTEGER;
                  APIENTRY; 'SQLE32' name 'sqleintr_api';
       { INSTALL SIGNAL HANDLER }
       FUNCTION sqleisig_api (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqleisig_api';
       { FORCE USERS OFF DATABASE & STOPDBM}
       FUNCTION sqlekill (VAR asqlca:TSQLCA):INTEGER;         { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlekill';
       { MIGRATE DATABASE }
       FUNCTION sqlemigd_api (database:CSTRING;     { database name }
                              passwd:CSTRING;       { password }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA pointer }
                  APIENTRY; 'SQLE32' name 'sqlemigd_api';
       { CLOSE NODE DIRECTORY SCAN }
       FUNCTION sqlencls_api (handle:LONGWORD;          { handle }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlencls_api';
       { GET NEXT DATABASE STATUS BLOCK }
       FUNCTION sqlenext_api (VAR Count:WORD;   { count pointer }
                              VAR Buffer;       { buffer pointer }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlenext_api';
       { GET NEXT NODE ENTRY }
       FUNCTION sqlengne_api (handle:LONGWORD;       { handle }
                              VAR buffer:^sqleninfo; { buffer }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlengne_api';
       { OPEN NODE DIRECTORY SCAN }
       FUNCTION sqlenops_api (VAR Handle:WORD;    { handle }
                              VAR Count:WORD;     { count }
                              VAR asqlca:TSQLCA):INTEGER; { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlenops_api';

       { DB APPLICATION REMOTE INTERFACE }
       FUNCTION sqleproc_api (path:CSTRING;    { Path Name of program to run }
                              VAR area:TSQLCHAR;{ variable length area pointer }
                              VAR isqlda:TSQLDA;  { input SQLDA }
                              VAR osqlda:TSQLDA;  { output SQLDA }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqleproc_api';
       { ROLLBACK SAVE-POINT }
       FUNCTION sqlerbsp (VAR asqlca:TSQLCA):INTEGER;       { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlerbsp';
       { RESTART DATABASE }
       FUNCTION sqlerest_api (database:CSTRING;     { database }
                              passwd:CSTRING;       { spare, password }
                              VAR asqlca:TSQLCA):INTEGER;   { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlerest_api';
       { REQUEST SAVE-POINT }
       FUNCTION sqlerqsp (VAR asqlca:TSQLCA):INTEGER;  { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlerqsp';
       { START DATABASE MANAGER }
       FUNCTION sqlestar_api:INTEGER;
                  APIENTRY; 'SQLE32' name 'sqlestar_api';
       { COLLECT DATABASE STATUS }
       FUNCTION sqlestat_api (status:LONGWORD;     { status requested }
                              objtype:LONGWORD;    { object type }
                              objlen:LONGWORD;     { length of object }
                              VAR obj;         { object pointer }
                              VAR Count:WORD;  { count pointer }
                              VAR Buffer;      { buffer pointer }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlestat_api';
       { STOP DATABASE MANAGER }
       FUNCTION sqlestop_api (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlestop_api';
       { STOP USING DATABASE   }
       FUNCTION sqlestpd_api (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlestpd_api';
       { START USING DATABASE  }
       FUNCTION sqlestrd_api (database:CSTRING;     { database }
                              passwd:CSTRING;       { spare, password }
                              use:LONGWORD;             { use }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqlestrd_api';
       { UNCATALOG DATABASE    }
       FUNCTION sqleuncd_api (database:CSTRING;     { database }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqleuncd_api';
       { UNCATALOG NODE }
       FUNCTION sqleuncn_api (nodename:CSTRING;    { nodename }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqleuncn_api';
       { GET USER STATUS }
       FUNCTION sqleuser_api (lendbname:LONGWORD;      { length of db name }
                              dbname:CSTRING;      { db name pointer }
                              VAR Buffer;          { buffer pointer }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLE32' name 'sqleuser_api';

       { ALTER DATABASE PASSWORD }
       FUNCTION SQLGALTD (newpwdlen:LONGWORD;      { new password length }
                          oldpwdlen:LONGWORD;      { old password length }
                          databaselen:LONGWORD;    { database length }
                          VAR asqlca :TSQLCA;  { SQLCA }
                          newpwd:CSTRING;      { new password }
                          OldPwd:CSTRING;      { old password }
                          Database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGALTD';
       { CATALOG DATABASE }
       FUNCTION SQLGCATD (clen:LONGWORD;      { comment length }
                          nlen:LONGWORD;      { node name length }
                          alen:LONGWORD;      { alias length }
                          dlen:LONGWORD;      { database length }
                          drive:LONGWORD;     { drive }
                          cp:LONGINT;       { comment code page }
                          atype:LONGWORD;     { type }
                          VAR asqlca:TSQLCA;     { SQLCA }
                          comment:CSTRING; { comment }
                          node:CSTRING;    { node name }
                          alias:CSTRING;   { alias }
                          database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGCATD';

       { GENERIC API FOR CATALOG NODE }
       FUNCTION SQLGCATN (clen:LONGWORD;     { comment length }
                          nlen:LONGWORD;     { mode length }
                          llen:LONGWORD;     { partner lu length }
                          ulen:LONGWORD;     { local lu length }
                          nolen:LONGWORD;    { node name length }
                          cp:LONGWORD;       { code page }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          comment:CSTRING; { comment }
                          mode:CSTRING;    { mode }
                          plu:CSTRING;     { partner lu }
                          loclu:CSTRING;   { local lu }
                          nodename:CSTRING):INTEGER; { nodename }
                  APIENTRY; 'SQLAPI32' name 'SQLGCATN';

       {NEW CREATE DATABASE}
       FUNCTION SQLGCRDB ( dbnamel:LONGWORD; { database name length     }
                           drive:LONGWORD;   { drive                    }
                           VAR asqlca:TSQLCA;   { pointer to sqlca         }
                           dbname:CSTRING;  { pointer to database name }
                           VAR desc:sqledbdesc):INTEGER;   { ptr to db descript block }
                  APIENTRY; 'SQLAPI32' name 'SQLGCRDB';
       { CREATE DATABASE }
       FUNCTION SQLGCRED (clen:LONGWORD;      { comment length }
                          plen:LONGWORD;      { spare1, was password length }
                          dlen:LONGWORD;      { database length }
                          drive:LONGWORD;     { drive }
                          cp:LONGINT;       { comment code page }
                          comment:CSTRING;{ comment }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          passwd:CSTRING; { spare2, was password }
                          database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGCRED';
       { GENERAL CATALOG NODE }
       FUNCTION SQLGCTND (VAR asqlca:TSQLCA;         { ptr to sqlca       }
                          VAR node:sqle_node_struct; { ptr to node struct }
                          prot_struct:POINTER        { ptr to protocol    }
                                                     {   structure        }
                          ):INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGCTND';

       { CHANGE DATABASE COMMENT }
       FUNCTION SQLGDCHG  (clen:LONGWORD;      { comment length }
                           dlen:LONGWORD;      { database length }
                           cp:LONGINT;       { comment codepage }
                           drive:LONGWORD;     { drive }
                           VAR asqlca:TSQLCA;      { SQLCA }
                           comment:CSTRING;     { comment }
                           database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGDCHG';
       { CLOSE DIRECTORY SCAN }
       FUNCTION SQLGDCLS  (handle:LONGWORD;      { handle }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGDCLS';
       { GET NEXT DIRECTORY ENTRY }
       FUNCTION SQLGDGNE (handle:LONGWORD;      { handle }
                          VAR buffer:^sqledinfo; { buffer }
                          VAR asqlca:TSQLCA):INTEGER;   { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGDGNE';
       { OPEN DIRECTORY SCAN }
       FUNCTION SQLGDOPS (drive:LONGWORD;         { drive }
                          VAR handle:WORD;    { handle }
                          VAR Count:WORD;     { count }
                          VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGDOPS';
       { DROP DATABASE }
       FUNCTION SQLGDRPD (plen:LONGWORD;      { spare1, was password length }
                          dlen:LONGWORD;      { database length }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          passwd:CSTRING; { spare2, was password }
                          database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGDRPD';
       { FREE DATABASE STATUS RESOURCES }
       FUNCTION SQLGFREE (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGFREE';
       { ADD DCS DIRECTORY ENTRY   }
       FUNCTION SQLGGDAD ( VAR asqlca:TSQLCA;         { Ptr to SQLCA           }
                           VAR dir:sql_dir_entry   { Ptr to Directory Entry }
                         ):INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGGDAD';
       { CLOSE DCS DIRECTORY SCAN }
       FUNCTION SQLGGDCL (VAR asqlca:TSQLCA;           { Pointer to SQLCA        }
                         ): INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGGDCL';
       { DELETE DCS DIRECTORY ENTRY }
       FUNCTION SQLGGDEL ( VAR asqlca:TSQLCA;       { Ptr to SQLCA           }
                           VAR dir:sql_dir_entry;   { Ptr to Directory Entry }
                         ):INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGGDEL';
       { GET DCS DIRECTORY ENTRY }
       FUNCTION SQLGGDGE ( VAR asqlca:TSQLCA;        { Ptr to SQLCA           }
                           VAR dir:sql_dir_entry;    { Ptr to Directory Entry }
                         ):INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGGDGE';
       { COPY DCS DIRECTORY ENTRIES }
       FUNCTION SQLGGDGT (VAR asqlca:TSQLCA;          { Ptr to SQLCA        }
                          VAR count:SHORT;            { DCR 911 Ptr to count var    }
                          VAR dir:sql_dir_entry;      { Ptr to entry buffer }
                         ):INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGGDGT';
       { SCAN DCS DIRECTORY       }
       FUNCTION SQLGGDSC ( VAR asqlca:TSQLCA;          { Pointer to SQLCA        }
                           VAR count:SHORT;            { DCR 911    Count variable          }
                         ): INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGGDSC';
       { INTERRUPT }
       FUNCTION SQLGINTR:INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGINTR';
       { INSTALL SIGNAL HANDLER }
       FUNCTION SQLGISIG (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGISIG';
       { MIGRATE DATABASE }
       FUNCTION SQLGMIGD (dlen:LONGWORD;      { Database name length }
                          plen:LONGWORD;      { password length }
                          database:CSTRING;  { database name }
                          passwd:CSTRING; { password }
                          VAR asqlca:TSQLCA):INTEGER;  { SQLCA pointer }
                  APIENTRY; 'SQLAPI32' name 'SQLGMIGD';

       { CLOSE NODE DIRECTORY SCAN }
       FUNCTION SQLGNCLS (handle:LONGWORD;      { handle }
                          VAR asqlca:TSQLCA):INTEGER;     { sqlca }
                  APIENTRY; 'SQLAPI32' name 'SQLGNCLS';
       { GET NEXT DATABASE STATUS BLOCK }
       FUNCTION SQLGNEXT (VAR Count:WORD;    { count pointer }
                          VAR Buffer;        { buffer pointer }
                          VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGNEXT';
       { GET NEXT NODE ENTRY }
       FUNCTION SQLGNGNE (handle:LONGWORD;      { handle }
                          VAR Buffer:^sqleninfo; { buffer }
                          VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGNGNE';
       { OPEN NODE DIRECTORY SCAN }
       FUNCTION SQLGNOPS  (VAR Handle:WORD;    { handle }
                           VAR Count:WORD;     { count }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGNOPS';
       { COLLECT DATABASE STATUS }
       FUNCTION SQLGOPST (status:LONGWORD;      { status requested }
                          objtype:LONGWORD;     { object type }
                          objlen:LONGWORD;      { length of object }
                          VAR obj;          { object pointer }
                          VAR count:WORD;   { count pointer }
                          VAR Buffer;       { buffer pointer }
                          VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGOPST';
       { DB APPLICATION REMOTE INTERFACE }
       FUNCTION SQLGPROC (plen:LONGWORD;        { program name length }
                          VAR asqlca:TSQLCA;{ SQLCA  }
                          path:CSTRING;     { Path Name of program to run }
                          VAR isqlda:TSQLDA;{ input SQLDA }
                          VAR osqlda:TSQLDA;{ output SQLDA }
                          VAR asqlchar:TSQLCHAR):INTEGER; { variable length area pointer }
                  APIENTRY; 'SQLAPI32' name 'SQLGPROC';
       { RESTART DATABASE }
       FUNCTION SQLGREST (plen:LONGWORD;      { spare1, was password length }
                          dlen:LONGWORD;      { database length }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          passwd:CSTRING; { spare2, was password }
                          database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGREST';

       { START DATABASE MANAGER }
       FUNCTION SQLGSTAR:INTEGER;
                  APIENTRY; 'SQLAPI32' name 'SQLGSTAR';
       { STOP DATABASE MANAGER }
       FUNCTION SQLGSTDM (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGSTDM';
       { STOP USING DATABASE }
       FUNCTION SQLGSTPD (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGSTPD';
       { START USING DATABASE }
       FUNCTION SQLGSTRD (plen:LONGWORD;       { spare1, was password length }
                          dlen:LONGWORD;       { database length }
                          use:LONGWORD;        { use }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          passwd:CSTRING;  { spare2, was password }
                          database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGSTRD';
       { UNCATALOG DATABASE }
       FUNCTION SQLGUNCD (dlen:LONGWORD;      { database length }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          database:CSTRING):INTEGER;    { database }
                  APIENTRY; 'SQLAPI32' name 'SQLGUNCD';
       { UNCATALOG NODE }
       FUNCTION SQLGUNCN (nlen:LONGWORD;      { nodename length }
                          VAR asqlca:TSQLCA;      { SQLCA }
                          nodename:CSTRING):INTEGER;    { nodename }
                  APIENTRY; 'SQLAPI32' name 'SQLGUNCN';
       { GET USER STATUS }
       FUNCTION SQLGUSER (dlen:LONGWORD;      { length of db name }
                          database:CSTRING;     { db name pointer }
                          VAR Buffer;      { buffer pointer }
                          VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                  APIENTRY; 'SQLAPI32' name 'SQLGUSER';
END;


IMPLEMENTATION

END.
