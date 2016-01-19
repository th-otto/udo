/*
 * resource set indices for hypview
 *
 * created by ORCS 2.14
 */

/*
 * Number of Strings:        124
 * Number of Bitblks:        0
 * Number of Iconblks:       0
 * Number of Color Iconblks: 15
 * Number of Color Icons:    29
 * Number of Tedinfos:       18
 * Number of Free Strings:   17
 * Number of Free Images:    0
 * Number of Objects:        85
 * Number of Trees:          7
 * Number of Userblks:       0
 * Number of Images:         0
 * Total file size:          26042
 */

#undef RSC_NAME
#define RSC_NAME "hypview"
#undef RSC_ID
#ifdef hypview
#define RSC_ID hypview
#else
#define RSC_ID 0
#endif

#if !defined(RSC_STATIC_FILE) || !RSC_STATIC_FILE
#define NUM_STRINGS 124
#define NUM_FRSTR 17
#define NUM_UD 0
#define NUM_IMAGES 0
#define NUM_BB 0
#define NUM_FRIMG 0
#define NUM_IB 0
#define NUM_CIB 15
#define NUM_TI 18
#define NUM_OBS 85
#define NUM_TREE 7
#endif



#define DIAL_LIBRARY                       0 /* form/dialog */
#define DI_ICON                            1 /* CICON in tree DIAL_LIBRARY */ /* max len 1 */

#define TOOLBAR                            1 /* form/dialog */
#define TO_BACKGRND                        0 /* BOX in tree TOOLBAR */
#define TO_BUTTONBOX                       1 /* IBOX in tree TOOLBAR */
#define TO_BACK                            2 /* CICON in tree TOOLBAR */ /* max len 4 */
#define TO_HISTORY                         3 /* CICON in tree TOOLBAR */ /* max len 0 */
#define TO_MEMORY                          4 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_PREV                            5 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_HOME                            6 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_NEXT                            7 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_INDEX                           8 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_KATALOG                         9 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_REFERENCES                     10 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_HELP                           11 /* CICON in tree TOOLBAR */ /* max len 0 */
#define TO_INFO                           12 /* CICON in tree TOOLBAR */ /* max len 0 */
#define TO_LOAD                           13 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_SAVE                           14 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_MENU                           15 /* CICON in tree TOOLBAR */ /* max len 1 */
#define TO_SEARCHBOX                      16 /* BOX in tree TOOLBAR */
#define TO_SEARCH                         17 /* FTEXT in tree TOOLBAR */ /* max len 25 */
#define TO_STRNOTFOUND                    18 /* TEXT in tree TOOLBAR */ /* max len 11 */

#define CONTEXT                            2 /* form/dialog */
#define CO_BACK                            1 /* STRING in tree CONTEXT */
#define CO_COPY                            2 /* STRING in tree CONTEXT */
#define CO_PASTE                           3 /* STRING in tree CONTEXT */
#define CO_SELECT_ALL                      5 /* STRING in tree CONTEXT */
#define CO_SAVE                            7 /* STRING in tree CONTEXT */
#define CO_SEARCH                          9 /* STRING in tree CONTEXT */
#define CO_SEARCH_AGAIN                   10 /* STRING in tree CONTEXT */
#define CO_DELETE_STACK                   11 /* STRING in tree CONTEXT */
#define CO_PRINT                          12 /* STRING in tree CONTEXT */

#define EMPTYPOPUP                         3 /* form/dialog */
#define EM_BACK                            0 /* BOX in tree EMPTYPOPUP */
#define EM_1                               1 /* STRING in tree EMPTYPOPUP */
#define EM_2                               2 /* STRING in tree EMPTYPOPUP */
#define EM_3                               3 /* STRING in tree EMPTYPOPUP */
#define EM_4                               4 /* STRING in tree EMPTYPOPUP */
#define EM_5                               5 /* STRING in tree EMPTYPOPUP */
#define EM_6                               6 /* STRING in tree EMPTYPOPUP */
#define EM_7                               7 /* STRING in tree EMPTYPOPUP */
#define EM_8                               8 /* STRING in tree EMPTYPOPUP */
#define EM_9                               9 /* STRING in tree EMPTYPOPUP */
#define EM_10                             10 /* STRING in tree EMPTYPOPUP */
#define EM_11                             11 /* STRING in tree EMPTYPOPUP */
#define EM_12                             12 /* STRING in tree EMPTYPOPUP */

#define PROGINFO                           4 /* form/dialog */
#define PROG_OK                            5 /* BUTTON in tree PROGINFO */
#define PROG_NAME                          6 /* STRING in tree PROGINFO */
#define PROG_FILE                          7 /* TEXT in tree PROGINFO */ /* max len 40 */
#define PROG_DATABASE                      8 /* TEXT in tree PROGINFO */ /* max len 40 */
#define PROG_AUTHOR                        9 /* TEXT in tree PROGINFO */ /* max len 40 */
#define PROG_VERSION                      10 /* TEXT in tree PROGINFO */ /* max len 40 */
#define PROG_DATE                         11 /* STRING in tree PROGINFO */

#define SEARCH_RESULT                      5 /* form/dialog */
#define SR_FSTL_UP                         1 /* BOXCHAR in tree SEARCH_RESULT */
#define SR_FSTL_BACK                       2 /* BOX in tree SEARCH_RESULT */
#define SR_FSTL_WHITE                      3 /* BOX in tree SEARCH_RESULT */
#define SR_FSTL_DOWN                       4 /* BOXCHAR in tree SEARCH_RESULT */
#define SR_BOX                             5 /* IBOX in tree SEARCH_RESULT */
#define SR_FSTL_0                          6 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_1                          7 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_2                          8 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_3                          9 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_4                         10 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_5                         11 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_6                         12 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_7                         13 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_8                         14 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_FSTL_9                         15 /* TEXT in tree SEARCH_RESULT */ /* max len 70 */
#define SR_ABORT                          16 /* BUTTON in tree SEARCH_RESULT */

#define HYPFIND                            6 /* form/dialog */
#define HYPFIND_STRING                     2 /* FTEXT in tree HYPFIND */ /* max len 30 */
#define HYPFIND_TEXT                       3 /* BUTTON in tree HYPFIND */
#define HYPFIND_PAGES                      4 /* BUTTON in tree HYPFIND */
#define HYPFIND_REF                        5 /* BUTTON in tree HYPFIND */
#define HYPFIND_ABORT                      6 /* BUTTON in tree HYPFIND */
#define HYPFIND_ALL_PAGE                   7 /* BUTTON in tree HYPFIND */
#define HYPFIND_ALL_HYP                    8 /* BUTTON in tree HYPFIND */

#define WARN_FEXIST                        0 /* Alert string */
/* [2][Tento soubor ji� existuje.|Chcete jej nahradit?][Nahradit|Zru�it] */

#define WARN_ERASEMARK                     1 /* Alert string */
/* [2][Chcete odstranit|%s|z va�ich z�lo�ek?][  Ano  |  Ne  ] */

#define ASK_SETMARK                        2 /* Alert string */
/* [2][Chcete p�idat|%s|do va�ich z�lo�ek?][  Ano  |  Ne  ] */

#define ASK_SAVEMARKFILE                   3 /* Alert string */
/* [2][Ulo�it z�lo�ky?][  Ano  |  Ne  ] */

#define WARN_NORESULT                      4 /* Alert string */
/* [1][HypView: nemohu naj�t|<%s>][ Zru�it ] */

#define FSLX_LOAD                          5 /* Free string */
/* Vyberte hypertext k na�ten�: */

#define FSLX_SAVE                          6 /* Free string */
/* Ulo�it ASCII text jako: */

#define WDLG_SEARCH_PATTERN                7 /* Free string */
/* Search Pattern... */

#define DI_MEMORY_ERROR                    8 /* Alert string */
/* [1][P��kaz nemohl b�t vykon�n.|Nen� dost voln�|pam�ti.][Zru�it] */

#define DI_WDIALOG_ERROR                   9 /* Alert string */
/* [1][Pros�m nainstalujte syst�mov�|n�stroj WDIALOG.PRG][Zru�it] */

#define DI_VDI_WKS_ERROR                  10 /* Alert string */
/* [1][Nemohu otev��t VDI stanici.][Zru�it] */

#define HV_ERR_NO_HOSTNAME                11 /* Alert string */
/* [1][No hostname specified in|Hypertext.][Cancel] */

#define HV_ERR_HOST_NOT_FOUND             12 /* Alert string */
/* [1][Host application not found.][Cancel] */

#define HV_ERR_NOT_IMPLEMENTED            13 /* Alert string */
/* [1][Not Implemented.][Cancel] */

#define DI_WDIALOG_FONTSEL_ERROR          14 /* Alert string */
/* [1][Cannot create a fontselector.|Maybe the system does not|support it.][Cancel] */

#define PROGINFO_FROM                     15 /* Free string */
/* from: %s */

#define PROGINFO_TITLE                    16 /* Free string */
/* Programinfo... */




#ifdef __STDC__
#ifndef _WORD
#  ifdef WORD
#    define _WORD WORD
#  else
#    define _WORD short
#  endif
#endif
extern _WORD hypview_rsc_load(void);
extern _WORD hypview_rsc_gaddr(_WORD type, _WORD idx, void *gaddr);
extern _WORD hypview_rsc_free(void);
#endif
