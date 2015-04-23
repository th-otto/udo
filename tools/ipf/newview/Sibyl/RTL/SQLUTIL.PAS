UNIT SQLUTIL;

{**************************************************************************
 *                                                                        *
 * Module Name    = SQLUTIL.H                                             *
 *                                                                        *
 * Descriptive Name =  Utility/Configuration Commands External Include    *
 *                     File                                               *
 *                                                                        *
 * Copyright = 5622-044 (C) Copyright IBM Corp. 1987, 1993                *
 *             Licensed Material - Program Property of IBM                *
 *             Refer to Copyright Instructions Form Number G120-3083      *
 *                                                                        *
 * Function = Include File defining                                       *
 *              Utility/Configuration Command Interfaces                  *
 *              SQL Return Codes in SQLCODE for Utility Commands          *
 *                                                                        *
 **************************************************************************}

INTERFACE

USES sql,Os2Def;

CONST
     { Interface Parameters/Structures/Return Codes }

     { Parameters for SQLUFROL }
     SQLUM_ROLLFWD           = 1 ;  { Roll forward to requested point }
     SQLUM_STOP              = 2 ;  { End roll-forward recovery       }
     SQLUM_ROLLFWD_STOP      = 3 ;  { Roll forward to requested point }
                                    { and end roll-forward recovery   }
     SQLUM_QUERY             = 4 ;  { Query:  nextArcFile,            }
                                    {         firstDeleteArc,         }
                                    {         lastDeleteArc,          }
                                    {         lastCommitTime          }
     SQLUM_INFINITY_TIMESTAMP=  '9999-12-31-23.59.59.999999';{ Roll   }
                                       { forward until STOP specified    }
     SQLUM_ARCHIVE_FILE_LEN  =  12; { Length of Archive File name     }
     SQLUM_TIMESTAMP_LEN     =  26; { Length of ISO format Timestamp  }


     { Parameters for Backup/Restore }
     SQLU_NSD_ID          = '0' ; { User exit used, not SD interface}

     { Parameters for RUNSTATS }
     SQL_STATS_TABLE      = 'T' ;  { TABLEOPT = Table w/o Indexes }
     SQL_STATS_BOTH       = 'B' ;  { TABLEOPT = Table and Indexes }
     SQL_STATS_INDEX      = 'I' ;  { TABLEOPT = Indexes w/o Table }
     SQL_STATS_REF        = 'R' ;  { SHAREOPT = Reference }
     SQL_STATS_CHG        = 'C' ;  { SHAREOPT = Change }

     { Parameters for selection method in sqldcol }
     SQL_METH_N           = 'N'; { Names      }
     SQL_METH_P           = 'P'; { Positional }
     SQL_METH_D           = 'D'; { Default    }
     SQL_METH_L           = 'L'; { Locations  }

     { File Types for Import/Export }
     SQL_IXF              = 'IXF' ;
     SQL_WSF              = 'WSF' ;
     SQL_DEL              = 'DEL' ;
     SQL_ASC              = 'ASC' ;

     { Equates for Configuration Utilities }

     { Token equates for SQLFupd structure for Kernel config file }
     SQLF_KTN_RQRIOBLK   =  1 ;
     SQLF_KTN_SVRIOBLK   =  3 ;
     SQLF_KTN_SQLENSEG   =  5 ;
     SQLF_KTN_NUMDB      =  6 ;
     SQLF_KTN_NNAME      =  7 ;
     SQLF_KTN_COMHEAPSZ  =  8 ;
     SQLF_KTN_RSHEAPSZ   =  9 ;
     SQLF_KTN_NUMRC      = 10 ;
     SQLF_KTN_TIMEOUT    = 11 ;
     SQLF_KTN_AGENT_INIT = 12 ;
     SQLF_KTN_DBAGENT    = 13 ;
     SQLF_KTN_DBMKEY     = 14 ;
     SQLF_KTN_DBMCOMQUE  = 15 ;
     SQLF_KTN_DBMSYSQUE  = 16 ;
     SQLF_KTN_SQLSTMTSZ  = 17 ;
     SQLF_KTN_DBMSYS     = 18 ;
     SQLF_KTN_INDEXREC   = 20 ;
     SQLF_KTN_SHEAPTHRES = 21 ;
     SQLF_KTN_NODETYPE   =100 ;
     SQLF_KTN_RELEASE    =101 ;
     SQLF_KTN_DBMONID    =102 ;
     SQLF_KTN_SYSADMID   =103 ;
     SQLF_KTN_DBMID      =104 ;

     { Nodetype equates }
     SQLF_NT_STANDALONE  =  0 ;
     SQLF_NT_SERVER      =  1 ;
     SQLF_NT_REQUESTOR   =  2 ;
     SQLF_NT_STAND_REQ   =  3 ;

     { Token equates for SQLFupd structure for DB config file }
     SQLF_DBTN_LOCKLIST        =   1 ;
     SQLF_DBTN_BUFFPAGE        =   2 ;
     SQLF_DBTN_MAXFILOP        =   3 ;
     SQLF_DBTN_LOGFILE         =   4 ;
     SQLF_DBTN_SOFTMAX         =   5 ;
     SQLF_DBTN_MAXAPPLS        =   6 ;
     SQLF_DBTN_APPLHEAPSZ      =   7 ;
     SQLF_DBTN_DBHEAP          =   8 ;
     SQLF_DBTN_DLCHKTIME       =   9 ;
     SQLF_DBTN_MAXTOTFILOP     =  10 ;
     SQLF_DBTN_SORTHEAP        =  11 ;
     SQLF_DBTN_LOGEXT          =  12 ;
     SQLF_DBTN_LOGMAXEXT       =  13 ;
     SQLF_DBTN_AGENTHEAP       =  14 ;
     SQLF_DBTN_MAXLOCKS        =  15 ;
     SQLF_DBTN_LOGPRIMARY      =  16 ;
     SQLF_DBTN_LOGSECOND       =  17 ;
     SQLF_DBTN_LOGFILSIZ       =  18 ;
     SQLF_DBTN_STMTHEAP        =  19 ;
     SQLF_DBTN_NEWLOGPATH      =  20 ;
     SQLF_DBTN_DETS            =  21 ;
     SQLF_DBTN_COPY_PROTECT    =  22 ;
     SQLF_DBTN_LOG_RETAIN      =  23 ;
     SQLF_DBTN_USER_EXIT       =  24 ;
     SQLF_DBTN_AUTO_RESTART    =  25 ;
     SQLF_DBTN_INDEXREC        =  30 ;
     SQLF_DBTN_COUNTRY         = 100 ;
     SQLF_DBTN_CODEPAGE        = 101 ;
     SQLF_DBTN_RELEASE         = 102 ;
     SQLF_DBTN_LOGPATH         = 103 ;
     SQLF_DBTN_INTFLAGS        = 104 ;
     SQLF_DBTN_LOGHEAD         = 105 ;
     SQLF_DBTN_NEXTACTIVE      = 107 ;
     SQLF_DBTN_CONSISTENT      = 111 ;
     SQLF_DBTN_BACKUP_PENDING  = 112 ;
     SQLF_DBTN_ROLLFWD_PENDING = 113 ;
     SQLF_DBTN_LOG_RETAIN_STATUS=114 ;
     SQLF_DBTN_USER_EXIT_STATUS =115 ;


     { You may manipulate the bits of SQLF_DBTN_DETS and SQLF_DBTN_INTFLAGS
       ** or you can enable, disable, or query the current setting through
       ** the individual tokens.
       **
       ** Defines for: SQLF_DBTN_COPY_PROTECT    , SQLF_DBTN_LOG_RETAIN
       **              SQLF_DBTN_USER_EXIT       , SQLF_DBTN_AUTO_RESTART
       **              SQLF_DBTN_CONSISTENT      , SQLF_DBTN_BACKUP_PENDING
       **              SQLF_DBTN_ROLLFWD_PENDING , SQLF_DBTN_LOG_RETAIN_STATUS
       **              SQLF_DBTN_USER_EXIT_STATUS
     }

     SQLF_DISABLE =0 ;
     SQLF_ENABLE  =1 ;


     {
      ** Defines for Database Details - SQLF_DBTN_DETS
      **
      ** The following meanings apply when the bits are set on.
      **
      ** SQLF_COPY_PROTECT       - Database is copy protected.
      ** SQLF_ENABLE_LOG_RETAIN  - Next time database is started in normal
      **                           conditions, the log files will be retained
      **                           for the purpose of roll-forward recovery.
      ** SQLF_ENABLE_USER_EXIT   - Next time database is started in normal
      **                           conditions, the user log exit will be enabled
      **                           for the purpose of roll-forward recovery.
      ** SQLF_ENABLE_AUTO_RESTART- The RESTART DATABASE function will be
      **                           invoked when needed.
    }

    SQLF_COPY_NOPROT         =$00 ;  { xxxx xxxx xxxx xxx0 }
    SQLF_COPY_PROTECT        =$01 ;  { xxxx xxxx xxxx xxx1 }
    SQLF_ENABLE_LOG_RETAIN   =$02 ;  { xxxx xxxx xxxx xx1x }
    SQLF_ENABLE_USER_EXIT    =$04 ;  { xxxx xxxx xxxx x1xx }
    SQLF_ENABLE_AUTO_RESTART =$08 ;  { xxxx xxxx xxxx 1xxx }

    {
     ** Defines for Logging Flags    - SQLF_DBTN_INTFLAGS
     **
     ** The following meanings apply when the bits are set on.
     **
     ** SQLF_CONSISTENT      - Database is in a consistent state.
     ** SQLF_BACKUP_PENDING  - User is required to take a backup of the
     **                        database before the system will allow the
     **                        database to be opened for normal processing.
     ** SQLF_ROLLFWD_PENDING - User is required to roll forward the database
     **                        before the system will allow the database to
     **                        be opened for normal processing.
     ** SQLF_LOG_RETAIN      - Log files are retained so that a database can be
     **                        rolled forward after it has been restored from
     **                        a backup copy.
     ** SQLF_USER_EXIT       - User exit is taken when log files are filled and
     **                        when log files are needed and not found.
    }

    SQLF_CONSISTENT          =$0001 ;{ xxxx xxxx xxxx xxx1 }
    SQLF_BACKUP_PENDING      =$0004 ;{ xxxx xxxx xxxx x1xx }
    SQLF_ROLLFWD_PENDING     =$0008 ;{ xxxx xxxx xxxx 1xxx }
    SQLF_LOG_RETAIN          =$0010 ;{ xxxx xxxx xxx1 xxxx }
    SQLF_USER_EXIT           =$0020 ;{ xxxx xxxx xx1x xxxx }


TYPE

TYPE
    sqldcol=RECORD
                 dcolmeth:SHORT;
                 dcolnum:SHORT;
                 dcolname:ARRAY[0..1] OF RECORD
                               dcolnlen:SHORT;
                               dcolnptr:PChar;
                 END;
            END;

   {************************************************}
   { Structure for Pairs of Locations for ASC files }
   {************************************************}

   sqlloctab=RECORD
                  locpair:ARRAY[0..1] OF RECORD
                               begin_loc:SHORT;
                               end_loc:SHORT;
                  END;
             END;

   {************************************************}
   { Structures for Configuration Utility APIs.     }
   {************************************************}

   sqlfupd=RECORD
                token:WORD;
                ptrvalue:PChar;
           END;

{
** Constants and structure used by SQLGADAU and sqluadau.
}
CONST
        SQL_USER_AUTHORIZED   =  1  ;
        SQL_USER_UNAUTHORIZED =  0  ;
        SQL_AUTHORIZATION_SIZE=  22 ;

TYPE
    sql_authorizations=RECORD
                          sql_authorizations_len:SHORT;
                          sql_sysadm_auth:SHORT;
                          sql_dbadm_auth:SHORT;
                          sql_createtab_auth:SHORT;
                          sql_bindadd_auth:SHORT;
                          sql_connect_auth:SHORT;
                          sql_sysadm_grp_auth:SHORT;
                          sql_dbadm_grp_auth:SHORT;
                          sql_createtab_grp_auth:SHORT;
                          sql_bindadd_grp_auth:SHORT;
                          sql_connect_grp_auth:SHORT;
                       END;


CONST
        { Values for CALLERAC parameter in RESTORE                                  }

        SQLUD_RESTORE          = 0 ; { Restore database                     }
        SQLUD_CONTINUE         = 1 ; { Continue  after a warning occurred   }
        SQLUD_TERMINATE        = 2 ; { Terminate after a warning occurred   }
        SQLUD_RST_NOROLLFWD    = 3 ; { Restore database, turn off the       }
                                     {  ROLL FORWARD PENDING flag           }

        { Roll Forward Return Codes }

        SQLU_RC_NOLFH          =    -1258; { Log Control file not found.  }
        SQLU_RC_IOELFH         =    -1259; { I/O Error accessing LFH.     }
        SQLU_RC_RFNOTEN        =    -1260; { DB not enabled for Roll Fwd  }
        SQLU_RC_RFNOTP         =    -1261; { Roll Forward is not Pending  }
        SQLU_RC_BADPIT         =    -1262; { Bad Point in Time specified  }
        SQLU_RC_INVEXT         =    -1263; { Invalid Log Extent file      }
        SQLU_RC_NOTEXT         =    -1264; { Log Extent file does not     }
                                           { belong to DB                 }
        SQLU_RC_IVREXT         =    -1265; { Log extent file is incorrect }
                                           { version                      }
        SQLU_RC_PRTIME         =    -1266; { Time specified is before     }
                                           { previous roll-forward time   }

        SQLU_RC_UEXIT_ERR      =    -1268; { User exit encountered an     }
                                           { error (other than retry)     }
                                           { while attempting to retrieve }
                                           { a log extent file for roll   }
                                           { forward                      }

        { General Utility Return Codes }
        SQLU_BAD_DRIVE           =  -2000;{ invalid output drive            }
        SQLU_USER_TERM           =  -2001;{ Backup terminated by user       }
        SQLU_NOT_LOCAL           =  -2002;{ database not local              }
        SQLU_DOS_ERROR           =  -2003;{ base operating system error     }
        SQLU_SQL_ERROR           =  -2004;{ SQL error occurred              }
        SQLU_READ_ERROR          =  -2005;{ read wrong # of bytes           }
        SQLU_WRITE_ERROR         =  -2006;{ wrote wrong # of bytes          }
        SQLU_INVALID_ACTION      =  -2008;{ call out of sequence            }
        SQLU_INSUFF_MEMORY       =  -2009;{ insufficient memory             }
        SQLU_STRD_ERROR          =  -2010;{ error in Start Using            }
        SQLU_STPD_ERROR          =  -2011;{ error in Stop Using             }
        SQLU_INT_ERROR           =  -2012;{ error in ints                   }
        SQLU_DIR_ERROR           =  -2013;{ directory Scan error            }
        SQLU_DBM_ERROR           =  -2014;{ pause or Continue or migration  }
                                          { error                           }
        SQLU_INVALID_DBNAME      =  -2015;{ invalid database name           }
        SQLU_INVALID_PATH        =  -2016;{ invalid path in environment     }
        SQLU_START_SESSION       =  -2017;{ Start Session failed            }
        SQLU_INVALID_AUTHS       =  -2018;{ invalid authorizations          }
        SQLU_AUTOBIND            =  -2019;{ auto-binding failed             }
        SQLU_TIMESTAMP           =  -2020;{ conflict after auto-bind        }
        SQLU_WRONG_DISKETTE      =  -2021;{ Wrong diskette inserted         }
        SQLU_IO_ERROR_LFH        =  -2023;{ I/O error in accessing the log  }
                                          { control file                    }
        SQLU_IO_ERROR_BRG        =  -2024;{ I/O error in accessing the      }
                                          { Backup/Restore flag file        }
        SQLU_IO_ERROR            =  -2025;{ System I/O error occurred       }
        SQLU_PAUSE_ERROR         =  -2026;{ error in PAUSE the started DB   }
        SQLU_CONT_ERROR          =  -2027;{ error in CONTINUE the stoped DB }
        SQLU_INT_INST_ERR        =  -2028;{ interruption installing error   }
        SQLU_UEXIT_RC            =  -2029;{ user exit returned non-zero rc  }
        SQLU_DISK_FULL           =  -2030;{ a specific fixed disk is full   }

        { Reorganize Table Return Codes }
        SQLUR_INVALID_AUTHID      = -2200;{ invalid authid on index name    }
        SQLUR_INVALID_TABLENAME   = -2203;{ invalid tablename syntax        }
        SQLUR_INVALID_INDEXNAME   = -2204;{ invalid tablename syntax        }
        SQLUR_INDEX_NOT_FOUND     = -2205;{ index doesn't exist             }
        SQLUR_INVALID_FILEPATH    = -2207;{ invalid filepath pointer        }
        SQLUR_TABLE_NOT_FOUND     = -2211;{ table does not exist            }
        SQLUR_VIEW_ERROR          = -2212;{ cannot reorg a view             }
        SQLUR_INSAUTH             = -2214;{ insuffic authority              }
        SQLUR_SQLERR_COMPREV      = -2215;{ SQL error commiting prev work   }
        SQLUR_SQLERR_REORG        = -2216;{ SQL error during reorganization }

        { Run Statistics Return Codes }
        SQLUS_INVALID_AUTHID      = -2300;{ invalid authid                  }
        SQLUS_INVALID_TABLE_NAME  = -2301;{ invalid table name              }
        SQLUS_INVALID_INDEX_LIST  = -2302;{ invalid index pointer           }
        SQLUS_INVALID_STATS_OPT   = -2303;{ statsopt parameter invalid      }
        SQLUS_INVALID_SHARE_LEV   = -2304;{ sharelev parameter invalid      }
        SQLUS_VIEWS_NOT_ALLOWED   = -2305;{ table specified is a view       }
        SQLUS_OBJ_DOES_NOT_EXIST  = -2306;{ object doesn't exist            }
        SQLUS_SYS_TABLE_NOT_ALLOWED=-2307;{ system table not allowed        }
        SQLUS_INVALID_INDEX_AUTHID= -2308;{ index authid invalid            }
        SQLUS_INVALID_INDEX_NAME  = -2309;{ index name invalid              }
        SQLUS_ERROR_STAT          = -2310;{ error running statistics        }
        SQLUS_INSAUTH             = -2311;{ insuffic authority for runstats }

        { Backup Return Codes }
        SQLUB_BAD_TYPE            = -2400;{ invalid type                    }
        SQLUB_TYPE_MUSTBE_DB      = -2401;{ type must be database           }
        SQLUB_USER_NOT_AUTH       = -2403;{ insufficient auth for backup    }
        SQLUB_MEDIA_FULL          = -2404;{ The target disk/diskette is full}
        SQLUB_RST_IN_PROG         = -2405;{ The backup can't run because    }
                                          { the Restore is in progress      }
        SQLUB_ROLLFWD_PENDING     = -2406;{ The Backup can't run because    }
                                          { roll forward is pending         }
        SQLUB_BR_INPROG           = -2407;{ The Backup can't run because    }
                                          { B/R flag file existed and read  }
                                          { I/O error occurred              }
        SQLUB_DEL_BRG_ERR         =  2408;{ Backup process is successful,   }
                                          { but unable to delete BRG file   }
        SQLUB_WRONG_BASE_IMAGE    = -2409;{ 'change-only' is only applied   }
                                          { to the most recent base image   }
        SQLUB_NO_CHG_NSD          = -2410;{ change only, backup not allowed }
                                          { to user exit                    }
        SQLUB_IO_ERROR            = -2411;{ I/O error during backup         }

        { Restore Return Codes }
        SQLUD_CANNOT_RESTORE      = -2501;{ can't read restored database    }
        SQLUD_DISKETTE_ERROR      = -2502;{ error reading backup diskette   }
        SQLUD_WRONG_DATABASE      = -2503;{ wrong backup diskette           }
        SQLUD_DISKETTE_PROMPT     =  2504;{ prompt for backup diskette      }
        SQLUD_DROP_WARNING        =  2505;{ warn that drop will be done     }
        SQLUD_DATABASE_WARNING    =  2506;{ Restore worked, but not cleanup }
        SQLUD_BIND_WARNING        =  2507;{ Restore utility not bound       }
        SQLUD_INVALID_DBDRV       = -2509;{ invalid database drive          }
        SQLUD_SEM_ERROR           = -2510;{ semaphore error                 }
        SQLUD_DROP_ERROR          = -2511;{ error dropping database         }
        SQLUD_CREATE_ERROR        = -2512;{ error creating database         }
        SQLUD_REN_ERROR           = -2513;{ error renaming database         }
        SQLUD_BAD_VERSION         = -2514;{ restored database wrong version }
        SQLUD_INSAUTH             = -2515;{ insuffic authority to restore   }
        SQLUD_DBACT               = -2516;{ a database active               }
        SQLUD_MIGRATED            =  2517;{ database migrated               }
        SQLUD_RST_DBCONG_ERR      = -2518;{ error in restoring DB config.   }
                                          { file                            }
        SQLUD_MIGRATE_ERROR       = -2519;{ error in migrating the database }
        SQLUD_DBCON_WARN          =  2520;{ DBCON file is restored using the}
                                          { backup version                  }
        SQLUD_DEL_BRG_ERR         =  2521;{ Restore process is successful,  }
                                          { but unable to delete BRG file   }

        { SQLGAUAD and sqluadau Return codes }
        SQLUA_BAD_INPUT_PARAMETER = -2600;{ sql_authorizations parameter bad}

        { IMPORT/EXPORT Return codes }
        SQLUE_DFO                =  -3001;{ error opening output file       }
        SQLUE_IOE                =  -3002;{ i/o error writing output file   }
        SQLUE_CLS                =  -3003;{ i/o error closing output file   }
        SQLUE_IFT                =  -3004;{ invalid filetype parameter      }
        SQLUE_CBI                =  -3005;{ function interrupted            }
        SQLUE_MFO                =  -3006;{ i/o error opening message file  }
        SQLUE_MFW                =  -3007;{ i/o error writing message file  }
        SQLUE_STA                =  -3008;{ start using database failed     }
        SQLUE_STR                =  -3009;{ invalid tcolstrg                }
        SQLUE_COL                =  -3010;{ invalid dcoldata                }

        SQLUE_MEM                =  -3011;{ memory allocation error         }
        SQLUE_SYSERR             =  -3012;{ system error                    }
        SQLUE_FTMOD              =  -3013;{ invalid filetmod                }
        SQLUE_MFC                =  -3014;{ failure on closing message file }
        SQLUE_SQLERR             =  -3015;{ SQL error occurred              }
        SQLUE_FMODNK             =  -3016;{ no keywords found               }
        SQLUE_FMODID             =  -3017;{ invalid delimiter or duplicate  }
        SQLUE_FMODDEC            =  -3018;{ decimal used for char delimiter }
        SQLUE_NTS                =  -3019;{ no tcolstrg                     }
        SQLUE_RC_INSAUTH         =  -3020;{ insufficient authority for exp. }

        SQLUI_RC_INSAUTH         =  -3021;{ insufficient authority for imp. }
        SQLUE_SQL_PREP_ERR       =  -3022;{ SQL error on input string       }
        SQLUE_DATABASE           =  -3023;{ invalid database name           }
        SQLUE_DATAFILE           =  -3025;{ invalid datafile                }
        SQLUE_MSGFILE            =  -3026;{ invalid msgfile                 }
        SQLUE_DCOLMETH           =  -3028;{ Export method indicator not n/d }
        SQLUE_NUL_FTYPE          =  -3029;{ filetype is null                }

        SQLUI_DFO                =  -3030;{ error opening input data file   }
        SQLUI_IOE                =  -3031;{ i/o error reading input file    }
        SQLUI_DCOLMETH           =  -3032;{ Import method not n/d/p         }
        SQLUI_TINSERT            =  -3033;{ invalid insert in tcolstrg      }
        SLQUI_TINTO              =  -3034;{ invalid into in tcolstrg        }
        SQLUI_TABLENAME          =  -3035;{ invalid tablename in tcolstrg   }
        SQLUI_CPAREN             =  -3036;{ close paren not in tcolstrg     }
        SQLUE_SQL_PREP_INSERT    =  -3037;{ SQL error on insert string      }
        SQLUI_TCOLJUNK           =  -3038;{ tcolstrg invalid                }

        SQLUIC_BAD_DCOL_POS      =  -3045;{ invalid dcol position for CSV   }
        SQLUI_NONDEF_DCOL_NOCOLS =  -3046;{ non-default dcol and no cols    }
        SQLUI_BAD_DCOL_METH      =  -3047;{ dcolinfo has invalid method     }
        SQLUI_NODCOL_FOR_NONNULL_DBCOL=-3048;{ non nullable column          }
        SQLUIC_UNSUPTYP_NONULLS  =  -3049;{ unsupported column type         }

        SQLUE_ROWCT_TOOBIG       =  -3053;{ too many rows for WSF export    }
        SQLUII_HEOF              =  -3054;{ eof reading first rec in IXF    }
        SQLUII_HLEN_CONV         =  -3055;{ length of 'H' rec not numeric   }
        SQLUII_HLEN_SHORT        =  -3056;{ first record too short          }
        SQLUII_HTYP              =  -3057;{ first IXF rec is not 'H'        }
        SQLUII_HID               =  -3058;{ no 'IXF'                        }
        SQLUII_HVERS             =  -3059;{ invalid version field in 'H'    }

        SQLUII_HCNT              =  -3060;{ HCNT in 'H' not numeric         }
        SQLUII_HSBCP_BAD         =  -3061;{ SBCP in 'H' not numeric         }
        SQLUII_HDBCP_BAD         =  -3062;{ DBCP in 'H' not numeric         }
        SQLUII_HSBCP_CMP         =  -3063;{ 'H' SBCP not compat w/data SBCP }
        SQLUII_HDBCP_CMP         =  -3064;{ 'H' DBCP not compat w/data DBCP }
        SQLUII_DB_CODEPG         =  -3065;{ can't get codepages             }
        SQLUII_TEOF              =  -3066;{ eof reading/looking for 'T' rec }
        SQLUII_TLEN_CONV         =  -3067;{ length of 'T' rec not numeric   }
        SQLUII_TLEN_SHORT        =  -3068;{ 'T' record is too short         }
        SQLUII_TTYP              =  -3069;{ first non-'A' rec not 'T' rec   }

        SQLUII_ALEN_BAD          =  -3070;{ invalid rec length of 'A' rec   }
        SQLUII_TCONV             =  -3071;{ invalid data convention in 'T'  }
        SQLUII_TFORM             =  -3072;{ invalid data format in 'T'      }
        SQLUII_TMFRM             =  -3073;{ invalid machine form in 'T'     }
        SQLUII_TLOC              =  -3074;{ invalid data location in 'T'    }
        SQLUII_TCCNT             =  -3075;{ 'C' rec cnt in 'T' not numeric  }
        SQLUII_TNAML             =  -3076;{ name len fld in 'T' not numeric }
        SQLUII_CCNT_HIGH         =  -3077;{ too many 'C' records            }
        SQLUII_ALEN_CONV         =  -3078;{ length of 'A' rec not numeric   }
        SQLUII_CLEN_CONV         =  -3079;{ length of 'C' rec not numeric   }

        SQLUII_CLEN_SHORT        =  -3080;{ 'C' record is too short         }
        SQLUII_CTYP              =  -3081;{ wrong rec type / 'C' expected   }
        SQLUII_CEOF              =  -3082;{ EOF while processing 'C' recs   }
        SQLUII_CDRID             =  -3083;{ 'D' rec id field not numeric    }
        SQLUII_CPOSN             =  -3084;{ 'D' rec posn field not numeric  }
        SQLUII_CIDPOS            =  -3085;{ 'D' id/position not consistent  }
        SQLUII_NOCREC_FOR_NONNULL_DBCOL=-3086;{ IXF column does not exist   }
        SQLUII_INVCREC_NONNULL_DBCOL  = -3087;{ IXF column not valid        }
        SQLUII_CRECCOMP_NONNULL_DBCOL = -3088;{ IXF column not compatible   }
        SQLUII_DTYP              =  -3089;{ wrong rec type / 'D' expected   }

        SQLUII_DLEN_CONV         =  -3090;{ length of 'D' rec not numeric   }
        SQLUII_DLEN_RANGE        =  -3091;{ length of 'D' rec not valid     }
        SQLUII_DID               =  -3092;{ invalid id field in 'D' rec     }
        SQLUIW_IFILE_INV         =  -3093;{ import file not valid WSF       }
        SQLUIW_NNCOL_LOST        =  -3094;{ DOS non-nullable name not found }
        SQLUIW_PCOL_INV          =  -3095;{ col position out of range       }
        SQLUIW_UCOLTYP_NONUL     =  -3096;{ unsup col type - not nullable   }
        SQLUIW_RECLEN_INV        =  -3097;{ record length invalid           }
        SQLUIW_INROW_INV         =  -3098;{ row number out of range         }
        SQLUIW_INCOL_INV         =  -3099;{ col number out of range         }

        SQLUE_COL_TOOBIG         =   3100;{ column longer than 254 chars    }
        SQLUE_DATA_CHARDEL       =   3101;{ column has char delimiter       }
        SQLUE_DCNUM_HIGH         =   3102;{ dcol column nbr > tcol number   }
        SQLUE_DCNUM_LOW          =   3103;{ dcol column nbr < tcol number   }
        SQLUE_WARNING            =   3107;{ warning message issued          }

        SQLUI_FEWER_DCOLS_DBCOLS_NULLED = 3112;{ extra database cols        }
        SQLUIC_UNSUPTYP_NULLABLE =   3113;{ column will be nulled           }
        SQLUIC_IGNORED_CHAR      =   3114;{ character ignored               }
        SQLUIC_FIELD_TOO_LONG      = 3115;{ input CSV field too long        }
        SQLUIC_CF_REQFIELD_MISSING = 3116;{ field value missing             }
        SQLUIC_CFINT2_NULLED       = 3117;{ smallint field nulled           }
        SQLUIC_CFINT2_ROWREJ       = 3118;{ smallint field error            }
        SQLUIC_CFINT4_NULLED       = 3119;{ int field nulled                }

        SQLUIC_CFINT4_ROWREJ       = 3120;{ int field error                 }
        SQLUIC_CFFLOAT_NULLED      = 3121;{ float field nulled              }
        SQLUIC_CFFLOAT_ROWREJ      = 3122;{ float field error               }
        SQLUIC_CFDEC_NULLED        = 3123;{ decimal field nulled            }
        SQLUIC_CFDEC_ROWREJ        = 3124;{ decimal field error             }
        SQLUIC_CFTRUNC             = 3125;{ char field truncated            }

        SQLUIC_CFCHAR_NULLED       = 3126;{ char field nulled               }
        SQLUIC_CFCHAR_ROWREJ       = 3127;{ char field error                }
        SQLUIC_CFDATETRUNC         = 3128;{ date field truncated            }
        SQLUIC_CFDTPAD             = 3129;{ date/time/stamp field padded    }

        SQLUIC_CFTIMETRUNC         = 3130;{ time field truncated            }
        SQLUIC_CFSTAMPTRUNC        = 3131;{ stamp field truncated           }
        SQLUIC_ROWTOOSHORT         = 3137;{ not enough columns              }
        SQLUIC_EOF_IN_CHARDELS     = 3138;{ end of input data file          }
        SQLUE_SQLSTPDB_ERR         = 3139;{ stop using database failed      }

        SQLUE_WSFLAB_LEN           = 3142;{ WSF label too big               }
        SQLUE_CHAR_MTRUNC          = 3143;{ WSF char type length too long   }
        SQLUE_CHAR_WTRUNC          = 3144;{ WSF char type length too long   }
        SQLUE_CHAR_ITRUNC          = 3145;{ WSF char truncated at 240       }
        SQLUE_ROWCT_LARGE          = 3147;{ row count exceeds 2048          }
        SQLUE_3148                 = 3148;{ row not inserted                }

        SQLUII_TCNTCMP             = 3154;{ 'H' hcnt not equal 'T' rec ccnt }
        SQLUII_CNAML               = 3155;{ invalid name length in 'C' rec  }
        SQLUII_CNULL               = 3156;{ invalid null field in 'C' rec   }
        SQLUII_CTYPE               = 3157;{ invalid type field in 'C' rec   }
        SQLUII_CSBCP               = 3158;{ invalid SBCP field in 'C' rec   }
        SQLUII_CDBCP               = 3159;{ invalid DBCP field in 'C' rec   }

        SQLUII_CLENG               = 3160;{ invalid col len fld in 'C' rec  }
        SQLUII_CPREC               = 3161;{ invalid precision in 'C' rec    }
        SQLUII_CSCAL               = 3162;{ invalid scale field in 'C' rec  }
        SQLUII_CFLOAT_BLANKLENG    = 3163;{ use 00008 for float col length  }
        SQLUII_CFLOAT_BADLENG      = 3164;{ invalid float col len in 'C'    }
        SQLUII_CUTYPE              = 3165;{ 'C' record has invalid type     }
        SQLUII_NOCREC_FOR_NULL_DBCOL  =   3166;{ IXF col does not exist     }
        SQLUII_INVCREC_FOR_NULL_DBCOL =   3167;{ IXF col is invalid         }
        SQLUII_CRECCOMP_NULL_DBCOL    =   3168;{ IXF col not compatible     }

        SQLUII_DEOF_INROW             =   3170;{ EOF found in row of data   }
        SQLUIW_NONLAB_HDR             =   3171;{ non-label cell in hdr row  }
        SQLUIW_NCOL_LOST              =   3172;{ nullable colnam not found  }
        SQLUIW_UCOLTYP_NULL           =   3174;{ unsup col type - nullable  }
        SQLUIW_INTYPE_INV             =   3175;{ wrong rec type for db col  }
        SQLUIW_DATE_INV               =   3176;{ date value out of range    }
        SQLUIW_TIME_INV               =   3177;{ time value out of range    }
        SQLUIW_INTIME_INV             =   3178;{ int rec for time invalid   }
        SQLUIW_NODATA_NNULL           =   3179;{ no data / non nullable col}

        SQLUE_INSERT_DISK             =   3180;{ insert diskette request    }
        SQLUII_AE_NOTFOUND            =   3181;{ file ended before AE rec   }
        SQLUII_INSERT_DISK_RETRY      =   3182;{ retry to insert diskette   }
        SQLUEC_NOBLANK_B4KW           =   3183;{ mult del o'rides/no blanks }
        SQLUI_PREVMESG_ROWNO          =   3185;{ row of previous warning    }
        SQLUI_LOGFULL_INSWARN         =   3186;{ log full inserting row     }
        SQLUI_INDEX_WARN              =   3187;{ error creating index       }
        SQLUI_TRUNCATE_TABLE          =  -3188;{ error truncating table     }

        SQLUI_INDEXIXF                =  -3190;{ invalid INDEXIXF option    }
        SQLUI_VIEW_ERROR              =  -3193;{ cannot import to this view }
        SQLUI_SYSTBL_ERROR            =  -3194;{ cannot import system table }
        SQLUE_RETRY_DISK              =   3195;{ not enough space           }
        SQLUI_IN_NOTFD                =  -3196;{ input file not found       }

        SQLUI_REPL_PAR                =  -3201;{ cant replace parent table  }
        SQLUI_IUOPT_NOPK              =  -3203;{ cant update without PK's   }
        SQLUI_IUOPT_NOVIEW            =  -3204;{ cant update views          }
        SQLUI_VIEW_REF                =  -3205;{ cant replace ref cons view }
        SQLUI_VIEW_SQUERY             =  -3206;{ cant replace subquery view }

        SQLUIW_RCSEQ_INV              =  -3300;{ row/col sequence invalid   }
        SQLUIW_BOF_INV                =  -3301;{ BOF in middle of WSF file  }
        SQLUIW_EARLY_EOF              =  -3302;{ unexpected EOF             }
        SQLUI_IXFONLY                 =  -3303;{ filetype not ixf           }
        SQLUI_DELTABLE                =  -3304;{ table does not exist       }
        SQLUI_CREATE_ERR              =  -3305;{ table already exists       }
        SQLUI_EXECUTE_ERR             =  -3306;{ SQL error during insert    }
        SQLUI_INC_COL                 =  -3307;{ incomplete col info        }
        SQLUI_CP_MISMATCH             =  -3308;{ codepage mismatch          }
        SQLUI_DBLDATA                 =  -3309;{ double byte data found     }

        SQLUI_UNREC_CTYPE             =  -3310;{ unrec col type             }
        SQLUI_INVCREC_FOR_CREATE      =  -3310;{ invalid IXF column         }
        SQLUE_DISK_FULL               =  -3313;{ disk full                  }
        SQLUII_ASTAMP_NOMATCH         =  -3314;{ 'A' data/ time not as 'H'  }
        SQLUII_ACREC_BADVOL           =  -3315;{ invalid volume info        }
        SQLUII_CLOSE_NOTLAST          =  -3316;{ error closing IXF file     }
        SQLUW_FTMOD_INV               =  -3317;{ conflict in filetmod       }
        SQLUEC_DUP_KEYWORD            =  -3318;{ keyword repeated/filetmod  }
        SQLUI_ERR_CREATETAB           =  -3319;{ error creating table       }

        SQLUEC_NOROOM_AFTERKW         =  -3320;{ keyword at end of filetmod }
        SQLUI_LOGFULL_INSERR          =  -3321;{ circular log full          }
        SQLUE_SEM_ERROR               =  -3322;{ semaphore error            }
        SQLUE_INVCOLTYPE              =  -3324;{ column type invalid        }
        SQLUEI_SYSERROR               =  -3327;{ system error               }

        SQLUII_ODD2GRAPH              =   3330;{ odd leng char -> graphic   }
        SQLUE_OEACCESS                =  -3331;{ permission denied          }
        SQLUE_OEMFILE                 =  -3332;{ too many files open        }
        SQLUE_OENOENT                 =  -3333;{ no such file or directory  }
        SQLUE_OENOMEM                 =  -3334;{ not enough memory          }
        SQLUE_OENOSPC                 =  -3335;{ no space left              }

        SQLUIA_BAD_DCOL_METH          =  -3400;{ invalid method for ASC     }
        SQLUI_DCOLM_ALL               =  -3401;{ invalid import method      }
        SQLUIA_NULLLOC                =  -3402;{ zeroes as begin/end        }
        SQLUIA_LOCPAIR                =  -3403;{ invalid pair               }
        SQLUIA_LOCNUM                 =  -3404;{ invalid pair for number    }
        SQLUIA_LOCDATE                =  -3405;{ invalid pair for date      }
        SQLUIA_LOCTIME                =  -3406;{ invalid pair for time      }
        SQLUIA_LOCSTAMP               =  -3407;{ invalid pair for timestamp }
        SQLUIA_LOCLONG                =   3408;{ pair defines long field    }
        SQLUIA_LOCSHORT               =   3409;{ pair defines short field   }
        SQLUIA_LOCODD                 =  -3410;{ invalid pair for graphic   }
        SQLUIA_CFGRAPH_NULLED         =   3411;{ value not graphic--null    }
        SQLUIA_CFGRAPH_ROWREJ         =   3412;{ value not graphic--not null}
        SQLUIA_SHORTFLDNULLED         =   3413;{ field too short--nulled    }

        SQLUE_MSG                     =  -3999;{ Export message             }

        { Roll-Forward Recovery SQLCODES }

        SQLU_INVALID_PARAM            =  -4904;{ invalid parameter          }
        SQLU_INVALID_RANGE            =  -4905;{ invalid parameter range    }


        { Configuration SQLCODES }

        SQLF_RC_SYSAUTH               =  -5001;{ only sysadm can chg Database
                                                  Manager Config file        }
        SQLF_RC_DBAUTH                =  -5002;{ only sysadm can chg Database
                                                  Configuration file         }
        SQLF_RC_SYSERR                =  -5005;{ system error               }
        SQLF_RC_PATHNAME              =  -5010;{ path name error            }
        SQLF_RC_INVNDB                =  -5011;{ invalid # of concurrent db }
        SQLF_RC_INVNSS                =  -5012;{ invalid # of shared seg    }
        SQLF_RC_INVRIO                =  -5013;{ invalid req I/O blk size   }
        SQLF_RC_INVSIO                =  -5015;{ invalid serv I/O blk size  }
        SQLF_RC_INVCHEAP              =  -5016;{ invalid communication heap }
        SQLF_RC_INVRSHEAP             =  -5017;{ invalid remote service heap}
        SQLF_RC_INVNUMRC              =  -5018;{ invalid max # remote connct}
        SQLF_RC_INVNODENAME           =  -5020;{ invalid node name          }
        SQLF_RC_INVSYSIDX             =  -5021; {Invalid system flag }
        SQLF_RC_INVDBIDX              =  -5022; {Invalid database flag }
        SQLF_RC_KCON                  =  -5025;{ not current sys config     }
        SQLF_RC_INVSHPTHR             =  -5027;{ invalid sort heap threshold}
        SQLF_RC_REL                   =  -5030;{ invalid release nbr        }
        SQLF_RC_NEEDMIG               =  -5035;{ database needs migration;
                                                  Release number is a back
                                                  level.                     }
        SQLF_RC_DBSYSTM               =  -5045;{ incompatible sys/db config
                                                    (standalone)             }
        SQLF_RC_DBSYS2                =  -5046;{  incompatible sys/db config
                                                    (concurrent dbs)         }
        SQLF_RC_INSMEM                =  -5047;{  insufficient memory to
                                                   support stack switching   }
        SQLF_RC_SYSCSUM               =  -5050;{ invalid sys config file    }
        SQLF_RC_DBCSUM                =  -5055;{ invalid db config file     }
        SQLF_RC_INVTKN                =  -5060;{ invalid token parameter    }
        SQLF_RC_INVNT                 =  -5065;{ invalid node type          }
        SQLF_RC_CNTINV                =  -5070;{ invalid count parameter    }
        SQLF_RC_CNTBRK                =  -5075;{ interrupt received         }
        SQLF_RC_INVNLL                =  -5080;{ invalid # of locklist      }
        SQLF_RC_INVNBP                =  -5081;{ invalid # bufr pool pages  }
        SQLF_RC_INVNDBF               =  -5082;{ invalid # of DB files open }
        SQLF_RC_INVILF                =  -5083;{ invalid initial log size   }
        SQLF_RC_INVSCP                =  -5084;{ invalid soft check pt val  }
        SQLF_RC_INVNAP                =  -5085;{ invalid # of active appls  }
        SQLF_RC_INVAHP                =  -5086;{ invalid application heapsz }
        SQLF_RC_INVDHP                =  -5087;{ invalid database heap size }
        SQLF_RC_INVDLT                =  -5088;{ invalid deadlock detection }
        SQLF_RC_INVTAF                =  -5089;{ invalid # of total files open
                                                    per application          }
        SQLF_RC_INVSHP                =  -5090;{ invalid sortlist heap      }
        SQLF_RC_INVLFE                =  -5091;{ invalid logfile extention  }
        SQLF_RC_INVNLE                =  -5092;{ invalid # of log extention }
        SQLF_RC_INVAGHP               =  -5093;{ invalid Sapphire agent heap}
        SQLF_RC_INVMAL                =  -5094;{ invalid maxlocks per applic}
        SQLF_RC_INVSTMHP              =  -5095;{ invalid statement heap     }
        SQLF_RC_INVLOGPRIM            =  -5096;{ invalid number primary
                                                  log files                  }
        SQLF_RC_INVLOG2ND             =  -5097;{ invalid number of secondary
                                                  log files                  }
        SQLF_RC_INVLOGFSZ             =  -5098;{ invalid log file size      }
        SQLF_RC_INVNEWLOGP            =  -5099;{ invalid new log path       }

        SQLF_RC_INVK1                 =  -5100;{ shared segs/# databases    }
        SQLF_RC_INVDB1                =  -5101;{ incompatible logfile param }
        SQLF_RC_INVDB2                =  -5102;{ incompatible file open par }
        SQLF_RC_INVDB3                =  -5103;{ incompatible buffer pool and
                                                    maximum # of appls       }
        SQLF_RC_INVK2                 =  -5104;{ no DB's / req only         }
        SQLF_RC_INVK3                 =  -5105;{ standalone nodetype does not
                                                  support nodename           }

        SQLF_RC_RWS_EXIST             =  -5106;{ remote workstation has
                                                  already been configured    }
        SQLF_RC_RWS_SYSADM            =  -5107;{ <authid> does not have
                                                  authority to add or drop
                                                  a remote workstation       }
        SQLF_RC_RWS_NOT_EXIST         =  -5108;{ remote workstation has not
                                                  been previously setup using
                                                  sqlarws                    }
        SQLF_RC_RWS_MACHINENAME       =  -5109;{ machine name is missing or
                                                  is too long.               }
        SQLF_RC_RWS_INV_OPT           =  -5110;{ configuration option is
                                                  not valid                  }
        SQLF_RC_ENV_VAR_NOTDEF        =  -5111;{ Environment variable
                                                  WKSTPROF is not defined    }
        SQLF_RC_INV_BIT_VALUE         =  -5112;{ Invalid bit value
                                                  must be 0 or 1             }
        SQLF_RC_LF_1_3                =  -5120;{ Both R1 & R3 Log parameters
                                                  may not be modified        }
        SQLF_RC_INVDETS               =  -5121;{ Invalid DB config details  }
        SQLF_RC_PROTECT               =  -5122;{ Database is copied protect }
        SQLF_RC_LOGIO                 =  -5123;{ I/O Error with log header  }
        SQLF_RC_INV_DBMENT            =  -5126;{ Invalid DBM Cfg file entry }
        SQLF_RC_INVTOUT               =  -5130; {Invalid timeout value      }
        SQLF_RC_INVAGT                =  -5131; {Invalid agent init range   }
        SQLF_RC_INVDBAGT              =  -5132; {Invalid number of agents   }
        SQLF_RC_INV_SHMEMSZ           =  -5133; {Invalid sz for shared mem  }
        SQLF_RC_INVSQL                =  -5134; {Invalid SQL stmt size      }


{ Database Utility Commands -- Function Prototypes }

IMPORTS
       { GET ADMINISTRATIVE AUTHORIZATIONS }
       FUNCTION sqluadau (VAR a:sql_authorizations;
                          VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                APIENTRY; 'SQLAPI32' name 'sqluadau';
       { GET AUTHORIZATIONS }
       FUNCTION sqluauth_api (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                APIENTRY; 'SQLE32' name 'sqluauth_api';
       { BACKUP }
       FUNCTION sqluback_api (database:CSTRING;     { database }
                              passwd:CSTRING;       { spare, was password }
                              typ:LONGINT;            { type }
                              drive:LONGWORD;           { drive }
                              VAR asqlca:TSQLCA):INTEGER;    { SQLCA }
                APIENTRY; 'SQLUB32' name 'sqluback_api';
       { RESTORE }
       FUNCTION sqludres_api (database:CSTRING;     { database }
                              drive:LONGWORD;           { database drive }
                              passwd:CSTRING;       { spare, was password }
                              inputdrive:LONGWORD;      { input drive }
                              callerac:LONGINT;       { callerac }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                APIENTRY; 'SQLUB32' name 'sqludres_api';
       { EXPORT FROM }
       FUNCTION sqluexp_api (database:CSTRING;      { database }
                             passwd:CSTRING;        { spare, was password }
                             datafile:CSTRING;      { datafile }
                             VAR asqldcol:SQLDCOL;  { dcoldata }
                             VAR asqlchar:TSQLCHAR;  { tcolstrg }
                             VAR filetype;          { filetype }
                             VAR asqlchar2:TSQLCHAR; { filetmod }
                             msgfile:CSTRING;       { msgfile }
                             caction:LONGINT;         { caller action }
                             VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                APIENTRY; 'SQLUB32' name 'sqluexp_api';
       FUNCTION sqlufrol_api (database:CSTRING;     { database name }
                              action:LONGWORD;          { action        }
                              Stop:CSTRING;         { Stop Timestamp       }
                              NFile:CSTRING;        { Next Archive File needed        }
                              FFile:CSTRING;        { First Archive File to be deleted}
                              LFile:CSTRING;        { Last Archive File to be deleted }
                              RetStamp:CSTRING;     { Returned Timestamp   }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA                }
                APIENTRY; 'SQLUB32' name 'sqlufrol_api';
       { IMPORT TO }
       FUNCTION sqluimp_api  (database:CSTRING;     { database }
                              passwd:CSTRING;       { spare, was password }
                              datafile:CSTRING;     { datafile }
                              VAR asqldcol:SQLDCOL; { dcoldata }
                              VAR asqlchar:TSQLCHAR; { tcolstrg }
                              VAR filetype;         { filetype }
                              VAR asqlchar2:TSQLCHAR;{ filetmod }
                              msgfile:CSTRING;      { msgfile }
                              action:LONGINT;         { caller action }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                APIENTRY; 'SQLUB32' name 'sqluimp_api';
       { REORG }
       FUNCTION sqlureor_api (database:CSTRING;     { database }
                              passwd:CSTRING;       { spare, was password }
                              table:CSTRING;        { table name }
                              iname:CSTRING;        { iname }
                              filepath:CSTRING;     { filepath }
                              action:LONGINT;         { spare, was callerac }
                              VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                APIENTRY; 'SQLUB32' name 'sqlureor_api';
        { RUNSTATS }
        FUNCTION sqlustat_api (table:CSTRING;      { table name }
                                nbr:LONGWORD;           { nbr indexes }
                                ilist:CSTRING;      { indexlist }
                                opt:CSTRING;        { statsopt }
                                lvl:CSTRING;        { sharelvl }
                                VAR asqlca:TSQLCA):INTEGER;  { SQLCA }
                 APIENTRY; 'SQLUB32' name 'sqlustat_api';
        { GET TABLE AUTH's }
        FUNCTION sqlutbau (table:CSTRING;   { fully-qualified table name }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLUB32' name 'sqlutbau';
        { GET ADMINISTRATIVE AUTHORIZATIONS }
        FUNCTION SQLGADAU  (VAR a:sql_authorizations;
                            VAR asqlca:TSQLCA):INTEGER;     { SQLCA                             }
                 APIENTRY; 'SQLAPI32' name 'SQLGADAU';
        { BACKUP }
        FUNCTION SQLGBACK (spare:LONGWORD;      { Spare1 }
                           dlen:LONGWORD;       { Database name length }
                           Typ:LONGINT;       { Type }
                           drive:LONGWORD;      { Drive }
                           VAR asqlca:TSQLCA;{ SQLCA }
                           Spare2:CSTRING;  { Spare2 }
                           Database:CSTRING):INTEGER; { Database }
                 APIENTRY; 'SQLAPI32' name 'SQLGBACK';
        { RESTORE }
        FUNCTION SQLGDRES (Spare1:LONGWORD;      { Spare1 }
                           dlen:LONGWORD;        { Database length }
                           action:LONGINT;     { Caller action }
                           Drive:LONGWORD;       { Drive }
                           ddrive:LONGWORD;      { Database drive }
                           VAR asqlca:TSQLCA; { Sqlca }
                           Spare2:CSTRING;   { Spare2 }
                           DataBase:CSTRING):INTEGER; { Database }
                 APIENTRY; 'SQLAPI32' name 'SQLGRES';
        { EXPORT FROM }
        FUNCTION SQLGEXP (mlen:LONGWORD;      { Message file name length }
                          ftlen:LONGWORD;     { File type length }
                          dlen:LONGWORD;      { Data file name length }
                          Spare1:LONGWORD;    { Spare1 }
                          dblen:LONGWORD;     { Database name length }
                          action:LONGWORD;    { Caller action }
                          VAR asqlca:TSQLCA; { SQLCA }
                          msgfile:CSTRING;{ Message file  }
                          VAR asqlchar:TSQLCHAR; { File mode }
                          FileType:CSTRING; { File type }
                          VAR asqlchar2:TSQLCHAR; { tcolstrg }
                          VAR asqldcol:SQLDCOL;    { dcoldata }
                          datafile:CSTRING; { datafile }
                          Spare2:CSTRING;   { Spare2 }
                          Database:CSTRING):INTEGER;    { Database }
                 APIENTRY; 'SQLAPI32' name 'SQLGEXP';
        { IMPORT TO }
        FUNCTION SQLGIMP (mlen:LONGWORD;      { Message file name length }
                          ftlen:LONGWORD;     { File type length }
                          dlen:LONGWORD;      { Data file name length }
                          Spare1:LONGWORD;    { Spare1 }
                          dblen:LONGWORD;     { Database name length }
                          action:LONGINT;   { Caller action }
                          VAR asqlca:TSQLCA; { Sqlca }
                          mfile:CSTRING;  { Message file  }
                          VAR asqlchar:TSQLCHAR; { File mode }
                          FileType:CSTRING; { File type }
                          VAR asqlchar2:TSQLCHAR; { tcolstrg }
                          VAR asqldcol:SQLDCOL;   { dcoldata }
                          datafile:CSTRING;    { datafile }
                          spare2:CSTRING;  { Spare2 }
                          database:CSTRING):INTEGER;    { Database }
                APIENTRY; 'SQLAPI32' name 'SQLGIMP';
        { REORG }
        FUNCTION SQLGREOR (fplen:LONGWORD;      { Filepath length }
                           tlen:LONGWORD;       { Table name length }
                           ilen:LONGWORD;       { inname length }
                           spare1:LONGWORD;     { Spare1 }
                           dlen:LONGWORD;       { database length }
                           spare3:LONGINT;    { Spare3 }
                           VAR asqlca:TSQLCA;{ SQLCA }
                           filepath:CSTRING;{ filepath }
                           table:CSTRING;   { table name }
                           iname:CSTRING;   { inname }
                           spare2:CSTRING;  { Spare2 }
                           database:CSTRING):INTEGER; { Database }
                APIENTRY; 'SQLAPI32' name 'SQLGREOR';
        { RUNSTATS }
        FUNCTION SQLGSTAT (tlen:LONGWORD;       { table name length }
                           count:LONGWORD;      { number of indices }
                           option:LONGWORD;     { stats option }
                           slevel:LONGWORD;     { share level }
                           VAR ilen:LONGWORD;   { index lengths }
                           VAR asqlca:TSQLCA;{ SQLCA }
                           VAR list:PChar;  { index list }
                           table:CSTRING):INTEGER;  { table name }
                 APIENTRY; 'SQLAPI32' name 'SQLGSTAT';
        FUNCTION SQLGFROL ( dbnamel:LONGWORD;
                            pointInTimel :LONGWORD;
                            action :LONGWORD;
                            VAR asqlca:TSQLCA;
                            dbname:CSTRING;
                            pointInTime:CSTRING;
                            VAR nextArcFilel:WORD;
                            VAR nextArcFile:CSTRING;
                            VAR firstDeleteArcl:WORD;
                            VAR firstDeleteArc:CSTRING;
                            VAR lastDeleteArcl:WORD;
                            VAR lastDeleteArc:CSTRING;
                            VAR lastCommitTimel:WORD;
                            VAR lastCommitTime:CSTRING):INTEGER;
                 APIENTRY; 'SQLAPI32' name 'SQLGFROL';
        FUNCTION SQLGDREF ( data_length:LONGWORD;
                            VAR target_buffer;
                            VAR source_buffer:POINTER):INTEGER;
                 APIENTRY; 'SQLAPI32' name 'SQLGDREF';
        FUNCTION SQLGADDR ( VAR inptr;
                            VAR outptr:POINTER):INTEGER;
                 APIENTRY; 'SQLAPI32' name 'SQLGADDR';
        { Configuration Utility Commands }
        { RESET DM CONFIGURATION   }
        FUNCTION sqlfrsys (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLF32' name 'sqlfrsys';
        { RESET DATABASE CONFIGURATION }
        FUNCTION sqlfrdbc (database:CSTRING;    { database }
                           passwd:CSTRING;      { password }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLF32' name 'sqlfrdbc';
        { UPDATE DM CONFIGURATION   }
        FUNCTION sqlfusys (count:LONGWORD;              { count }
                           VAR asqlfupd:SQLFUPD;    { list of items }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLF32' name 'sqlfusys';
        { UPDATE DATABASE CONFIGURATION }
        FUNCTION sqlfeudb (database:CSTRING;    { database }
                           passwd:CSTRING;      { password }
                           count:LONGWORD;          { count }
                           VAR asqlfupd:SQLFUPD;{ list of items }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLF32' name 'sqlfeudb';
        { RETURN DM CONFIGURATION }
        FUNCTION sqlfxsys (count:LONGWORD;              { count }
                           VAR asqlfupd:SQLFUPD;    { list of items }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLF32' name 'sqlfxsys';
        { RETURN DATABASE CONFIGURATION }
        FUNCTION sqlfxdbc (database:CSTRING;    { database }
                           passwd:CSTRING;      { password }
                           count:LONGWORD;          { count }
                           VAR asqlfupd:SQLFUPD;{ list of items }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLF32' name 'sqlfxdbc';
        { RESET DM CONFIGURATION }
        FUNCTION SQLGRSYS (VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLAPI32' name 'SQLGRSYS';
        { RESET DATABASE CONFIGURATION }
        FUNCTION SQLGRDBC (spare1:LONGWORD;      { Spare1 }
                           dlen:LONGWORD;        { Database name length }
                           VAR asqlca:TSQLCA; { SQLCA }
                           spare2:CSTRING;   { Spare2 }
                           database:CSTRING):INTEGER;    { database }
                 APIENTRY; 'SQLAPI32' name 'SQLGRDBC';
        { UPDATE DM CONFIGURATION }
        FUNCTION SQLGUSYS (count:LONGWORD;       { count }
                           VAR llen:WORD;    { List of item lengths }
                           VAR asqlfupd:SQLFUPD;    { list of items }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLAPI32' name 'SQLGUSYS';
        { UPDATE DATABASE CONFIGURATION }
        FUNCTION SQLGEUDB (spare1:LONGWORD;      { Spare1 }
                           dlen:LONGWORD;        { Database name length }
                           count:LONGWORD;       { count }
                           VAR llen:WORD;    { List of item lengths }
                           VAR asqlfupd:SQLFUPD;    { list of items }
                           VAR asqlca:TSQLCA; { SQLCA }
                           Spare2:CSTRING;   { Spare2 }
                           Database:CSTRING):INTEGER;{ database }
                 APIENTRY; 'SQLAPI32' name 'SQLGEUDB';
        { RETURN DM CONFIGURATION }
        FUNCTION SQLGXSYS (count:LONGWORD;      { count }
                           VAR asqlfupd:SQLFUPD;    { list of items }
                           VAR asqlca:TSQLCA):INTEGER;     { SQLCA }
                 APIENTRY; 'SQLAPI32' name 'SQLGXSYS';
        { RETURN DATABASE CONFIGURATION }
        FUNCTION SQLGXDBC (Spare1:LONGWORD;      { Spare1}
                           dlen:LONGWORD;        { Database name length }
                           count:LONGWORD;       { count }
                           VAR asqlfupd:SQLFUPD;    { list of items }
                           VAR asqlca:TSQLCA; { SQLCA }
                           spare2:CSTRING;   { Spare2 }
                           database:CSTRING):INTEGER; { database                           }
                 APIENTRY; 'SQLAPI32' name 'SQLGXDBC';
END;

IMPLEMENTATION

END.