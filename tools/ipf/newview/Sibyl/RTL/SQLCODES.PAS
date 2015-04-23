UNIT SQLCODES;

{**************************************************************************
 *                                                                        *
 * Module Name    = SQLCODES.H                                            *
 *                                                                        *
 * Descriptive Name = External Include file for SQLCODES                  *
 *                                                                        *
 * Copyright = 5622-044 (C) Copyright IBM Corp. 1988, 1993                *
 *             Licensed Material - Program Property of IBM                *
 *             Refer to Copyright Instructions Form Number G120-3083      *
 *                                                                        *
 * Function = Include File defining                                       *
 *              SQLCODES                                                  *
 *                                                                        *
 **************************************************************************}

INTERFACE

USES OS2Def;

CONST
          /* SQL Return Codes in SQLCODE */
          SQL_RC_OK     =    0  ;       /* successful execution               */

                                        /* ------------ warnings ------------ */
          SQL_RC_W012   =   12  ;       /* correlation without qualification  */
          SQL_RC_W100   =  100  ;       /* eof                                */
          SQL_RC_W139   =  139  ;       /* duplicate column conistraint       */
          SQL_RC_W143   =  143  ;       /* invalid syntax ignored             */
          SQL_RC_W541   =  541  ;       /* duplicate referential constraint   */
          SQL_RC_W605   =  605  ;       /* index already exists */
          SQL_RC_W965   =  965  ;       /* unknown SQL warning another product*/

                                        /* ------------- errors ------------- */
          SQL_RC_E007   =   -7  ;       /* illegal character                  */
          SQL_RC_E010   =  -10  ;       /* string constant not terminated     */
          SQL_RC_E013   =  -13  ;       /* cursor or statement name = ""      */
          SQL_RC_E051   =  -51  ;       /* reserved                           */
          SQL_RC_E084   =  -84  ;       /* bad sql statement                  */

          SQL_RC_E101   = -101  ;       /* statement too long                 */
          SQL_RC_E102   = -102  ;       /* string constant too long           */
          SQL_RC_E103   = -103  ;       /* invalid numeric literal            */
          SQL_RC_E104   = -104  ;       /* invalid character/token            */
          SQL_RC_E105   = -105  ;       /* invalid string constant            */
          SQL_RC_E107   = -107  ;       /* name too long                      */
          SQL_RC_E108   = -108  ;       /* name has too many qualifiers       */
          SQL_RC_E109   = -109  ;       /* clause not permitted               */
          SQL_RC_E111   = -111  ;       /* no column name                     */
          SQL_RC_E112   = -112  ;       /* operand is sql function            */
          SQL_RC_E117   = -117  ;       /* wrong nbr of insert values         */
          SQL_RC_E118   = -118  ;       /* object table in from clause        */
          SQL_RC_E119   = -119  ;       /* column not in group by             */
          SQL_RC_E120   = -120  ;       /* clause includes sql fn             */
          SQL_RC_E121   = -121  ;       /* dup column name                    */
          SQL_RC_E122   = -122  ;       /* no group by                        */
          SQL_RC_E125   = -125  ;       /* no result column                   */
          SQL_RC_E127   = -127  ;       /* dup distinct                       */
          SQL_RC_E129   = -129  ;       /* too many table names               */
          SQL_RC_E131   = -131  ;       /* incompatible data for like         */
          SQL_RC_E132   = -132  ;       /* like predicate invalid             */
          SQL_RC_E134   = -134  ;       /* improper use of long string        */
          SQL_RC_E138   = -138  ;       /* substr arg out of range            */
          SQL_RC_E142   = -142  ;       /* syntax not supported               */
          SQL_RC_E150   = -150  ;       /* view not updatable                 */
          SQL_RC_E151   = -151  ;       /* column not updatable               */
          SQL_RC_E153   = -153  ;       /* no column list                     */
          SQL_RC_E156   = -156  ;       /* command not allowed on view        */
          SQL_RC_E157   = -157  ;       /* view name in foreign key           */
          SQL_RC_E158   = -158  ;       /* nbr of columns does not match      */
          SQL_RC_E159   = -159  ;       /* drop view on table                 */
          SQL_RC_E160   = -160  ;       /* with check not allowed on view     */
          SQL_RC_E161   = -161  ;       /* with check violation               */
          SQL_RC_E170   = -170  ;       /* nbr of arguments invalid           */
          SQL_RC_E171   = -171  ;       /* argument invalid                   */
          SQL_RC_E172   = -172  ;       /* function name invalid              */
          SQL_RC_E176   = -176  ;       /* translate scalar argument invalid  */
          SQL_RC_E180   = -180  ;       /* datetime syntax invalid            */
          SQL_RC_E181   = -181  ;       /* datetime value invalid             */
          SQL_RC_E182   = -182  ;       /* datetime arithmetic invalid        */
          SQL_RC_E183   = -183  ;       /* datetime arithmetic out of range   */
          SQL_RC_E198   = -198  ;       /* no statement text                  */
          SQL_RC_E199   =  -199 ;        /* illegal use of reserved word       */

          /* SQL Return Codes in SQLCODE */

          SQL_RC_E203   = -203  ;       /* ambiguous column reference         */
          SQL_RC_E204   = -204  ;       /* undefined name                     */
          SQL_RC_E205   = -205  ;       /* not a column                       */
          SQL_RC_E206   = -206  ;       /* not a column of referenced tables  */
          SQL_RC_E207   = -207  ;       /* cannot orderby column name w/union */
          SQL_RC_E208   = -208  ;       /* column not part of result table    */
          SQL_RC_E212   = -212  ;       /* duplicate table designator         */

          SQL_RC_E301   = -301  ;       /* host variable has invalid type     */
          SQL_RC_E302   = -302  ;       /* host variable value too large      */
          SQL_RC_E303   = -303  ;       /* data types not comparable          */
          SQL_RC_E304   = -304  ;       /* value not in range of host var     */
          SQL_RC_E305   = -305  ;       /* host var cannot be null            */
          SQL_RC_E309   = -309  ;       /* host var should not be null        */
          SQL_RC_E311   = -311  ;       /* length of host var is negative     */
          SQL_RC_E312   = -312  ;       /* unusable host variable             */
          SQL_RC_E313   = -313  ;       /* wrong nbr of host variables        */
          SQL_RC_E332   = -332  ;       /* no conversn source-cp to target-cp */

          SQL_RC_E401   = -401  ;       /* operands not comparable            */
          SQL_RC_E402   = -402  ;       /* invalid type for arithmetic op     */
          SQL_RC_E404   = -404  ;       /* update/insert string too long      */
          SQL_RC_E405   = -405  ;       /* numeric literal out of range       */
          SQL_RC_E406   = -406  ;       /* derived value out of range         */
          SQL_RC_E407   = -407  ;       /* column cannot be null              */
          SQL_RC_E408   = -408  ;       /* invalid data type for column       */
          SQL_RC_E409   = -409  ;       /* invalid operand for count          */
          SQL_RC_E410   = -410  ;       /* float literal too long             */
          SQL_RC_E412   = -412  ;       /* multiple columns in subquery       */
          SQL_RC_E413   = -413  ;       /* overflow during data conversion    */
          SQL_RC_E415   = -415  ;       /* incompatible data types for union  */
          SQL_RC_E416   = -416  ;       /* long string in union               */
          SQL_RC_E417   = -417  ;       /* invalid use of parameter markers   */
          SQL_RC_E418   = -418  ;       /* parameter marker in select clause  */
          SQL_RC_E419   = -419  ;       /* division produced negative scale   */
          SQL_RC_E421   = -421  ;       /* diff number of columns for union   */
          SQL_RC_E436   = -436  ;       /* C language char string missing null*/

          SQL_RC_E501   = -501  ;       /* cursor not open (fetch/close)      */
          SQL_RC_E502   = -502  ;       /* cursor already open                */
          SQL_RC_E503   = -503  ;       /* column not in update clause        */
          SQL_RC_E504   = -504  ;       /* cursor name not defined            */
          SQL_RC_E507   = -507  ;       /* cursor not open (update/delete)    */
          SQL_RC_E508   = -508  ;       /* cursor not on a row                */
          SQL_RC_E509   = -509  ;       /* table not same as for cursor       */
          SQL_RC_E510   = -510  ;       /* table cannot be modified           */
          SQL_RC_E511   = -511  ;       /* for update not allowed             */
          SQL_RC_E514   = -514  ;       /* cursor not prepared                */
          SQL_RC_E516   = -516  ;       /* describe not a prepared statement  */
          SQL_RC_E517   = -517  ;       /* prepared statment not a select     */
          SQL_RC_E518   = -518  ;       /* execute not a prepared statement   */
          SQL_RC_E519   = -519  ;       /* statement has an open cursor       */
          SQL_RC_E530   = -530  ;       /* invalid foreign key value          */
          SQL_RC_E531   = -531  ;       /* cannot update primary key          */
          SQL_RC_E532   = -532  ;       /* delete is restricted               */
          SQL_RC_E533   = -533  ;       /* multi-row insert not allowed       */
          SQL_RC_E534   = -534  ;       /* multi-row update of pk             */
          SQL_RC_E535   = -535  ;       /* multi-row delete not allowed       */
          SQL_RC_E536   = -536  ;       /* descendent in subquery             */
          SQL_RC_E537   = -537  ;       /* dup column in key def              */
          SQL_RC_E538   = -538  ;       /* foreign key does not match pk      */
          SQL_RC_E539   = -539  ;       /* table does not have primary key    */
          SQL_RC_E541   = -541  ;       /* duplicate referential constraint   */
          SQL_RC_E542   = -542  ;       /* pk column cannot allow nulls       */
          SQL_RC_E551   = -551  ;       /* authorization error w/obj insert   */
          SQL_RC_E552   = -552  ;       /* auth error w/o obj ins             */
          SQL_RC_E553   = -553  ;       /* SYSIBM qualifier                   */
          SQL_RC_E554   = -554  ;       /* cannot grant privilege to self     */
          SQL_RC_E555   = -555  ;       /* cannot revoke privilege from self  */
          SQL_RC_E556   = -556  ;       /* revoke stmt denied--priv not held  */
          SQL_RC_E557   = -557  ;       /* invalid combination of privileges  */
          SQL_RC_E558   = -558  ;       /* revoke stmt denied--has CONTROL    */
          SQL_RC_E562   = -562  ;       /* privilege not allowed for public   */
          SQL_RC_E567   = -567  ;       /* invalid authorization id           */

          /* SQL Return Codes in SQLCODE */

          SQL_RC_E601   = -601  ;       /* duplicate table/view name          */
          SQL_RC_E602   = -602  ;       /* too many columns in index          */
          SQL_RC_E603   = -603  ;       /* cannot create unique index         */
          SQL_RC_E604   = -604  ;       /* invalid length, precision, scale   */
          SQL_RC_E607   = -607  ;       /* op not allowed on system tables    */
          SQL_RC_E612   = -612  ;       /* duplicate column name              */
          SQL_RC_E613   = -613  ;       /* primary key too long               */
          SQL_RC_E614   = -614  ;       /* index key too long                 */
          SQL_RC_E624   = -624  ;       /* table already has primary key      */
          SQL_RC_E629   = -629  ;       /* foreign key is not nullable        */
          SQL_RC_E631   = -631  ;       /* foreign key is too long            */
          SQL_RC_E632   = -632  ;       /* delete rule restriction            */
          SQL_RC_E633   = -633  ;       /* delete rule is restricted          */
          SQL_RC_E634   = -634  ;       /* delete rule cannot be CASCADE      */
          SQL_RC_E637   = -637  ;       /* dup pk or drop pk clause           */
          SQL_RC_E638   = -638  ;       /* no column definitions              */
          SQL_RC_E667   = -667  ;       /* ref constraint does not hold       */
          SQL_RC_E669   = -669  ;       /* cannot drop primary key            */
          SQL_RC_E670   = -670  ;       /* row length too large               */
          SQL_RC_E673   = -673  ;       /* primary key not unique             */
          SQL_RC_E680   = -680  ;       /* too many columns for table         */
          SQL_RC_E683   = -683  ;       /* incompatible column constraint     */

          SQL_RC_E802   = -802  ;       /* arith overflow or divide by zero   */
          SQL_RC_E803   = -803  ;       /* distinct violation                 */
          SQL_RC_E804   = -804  ;       /* bad input parameters               */
          SQL_RC_E805   = -805  ;       /* program not found                  */
          SQL_RC_E811   = -811  ;       /* more than one row/value            */
          SQL_RC_E818   = -818  ;       /* time stamp conflict                */
          SQL_RC_E822   = -822  ;       /* invalid address in sqlda           */
          SQL_RC_E840   = -840  ;       /* too many items in list             */

          SQL_RC_E902   = -902  ;       /* fatal error                        */
          SQL_RC_E910   = -910  ;       /* drop pending                       */
          SQL_RC_E911   = -911  ;       /* deadlock                           */
          SQL_RC_E912   = -912  ;       /* too many lock requests             */
          SQL_RC_E920   = -920  ;       /* reject DB connection to SA REQ     */
          SQL_RC_E930   = -930  ;       /* insufficient storage               */
          SQL_RC_E950   = -950  ;       /* cursors active on dropped object   */
          SQL_RC_E951   = -951  ;       /* table in use - alter disallowed    */
          SQL_RC_E952   = -952  ;       /* user cancel                        */
          SQL_RC_E953   = -953  ;       /* agent heap too small               */
          SQL_RC_E954   = -954  ;       /* application heap too small         */
          SQL_RC_E955   = -955  ;       /* sort heap error                    */
          SQL_RC_E956   = -956  ;       /* database heap too small            */
          SQL_RC_E957   = -957  ;       /* requestor comm heap too small      */
          SQL_RC_E958   = -958  ;       /* max nbr of files open              */
          SQL_RC_E959   = -959  ;       /* server comm heap too small         */
          SQL_RC_E960   = -960  ;       /* max nbr of files in database       */
          SQL_RC_E961   = -961  ;       /* rqstr remote svcs heap too small   */
          SQL_RC_E962   = -962  ;       /* svr remote svcs heap too small     */
          SQL_RC_E964   = -964  ;       /* log file full                      */
          SQL_RC_E966   = -966  ;       /* error opening sqlcode mapping file */
          SQL_RC_E967   = -967  ;       /* format error in sqlcode map file   */
          SQL_RC_E968   = -968  ;       /* disk full                          */
          SQL_RC_E969   = -969  ;       /* unknown sql error another product  */
          SQL_RC_E970   = -970  ;       /* read-only file                     */
          SQL_RC_E972   = -972  ;       /* incorrect diskette                 */
          SQL_RC_E974   = -974  ;       /* drive locked                       */
          SQL_RC_E976   = -976  ;       /* diskette door open                 */
          SQL_RC_E978   = -978  ;       /* diskette write-protected           */
          SQL_RC_E980   = -980  ;       /* disk error                         */
          SQL_RC_E982   = -982  ;       /* disk error on temp file            */
          SQL_RC_E984   = -984  ;       /* unsuccessful commit or rollback    */
          SQL_RC_E985   = -985  ;       /* file error - catalog file bad      */
          SQL_RC_E986   = -986  ;       /* file error - file renamed          */
          SQL_RC_E990   = -990  ;       /* index structure limit error        */
          SQL_RC_E992   = -992  ;       /* release number incompatible        */
          SQL_RC_E994   = -994  ;       /* reserved                           */
          SQL_RC_E996   = -996  ;       /* reserved                           */

          SQL_RC_E1216  = -1216 ;       /* invalid use of graphic data        */

          SQL_RC_E30000 = -30000;       /* Distribution protocol error,       */
                                        /*   no disconnect                    */
          SQL_RC_E30020 = -30020;       /* Distribution protocol error,       */
                                        /*   disconnect                       */
          SQL_RC_E30021 = -30021;       /* Distribution compatibility error   */
          SQL_RC_E30040 = -30040;       /* Distribution memory allocation err */
          SQL_RC_E30041 = -30041;       /* Distribution memory allocation err */
                                        /*   disconnect                       */
          SQL_RC_E30050 = -30050;       /* Invalid command while bind in prog */
          SQL_RC_E30051 = -30051;       /* Bind not active                    */
          SQL_RC_E30053 = -30053;       /* Bind Owner authorization failure   */
          SQL_RC_E30060 = -30060;       /* RDB authorization failure          */
          SQL_RC_E30061 = -30061;       /* RDB not found                      */
          SQL_RC_E30070 = -30070;       /* Distribution command error         */
          SQL_RC_E30071 = -30071;       /* Distribution object error          */
          SQL_RC_E30072 = -30072;       /* Distribution parameter error       */
          SQL_RC_E30073 = -30073;       /* Distribution parameter value error */
          SQL_RC_E30074 = -30074;       /* Distribution reply error           */
          SQL_RC_E30080 = -30080;       /* Communication error                */
          SQL_RC_E30090 = -30090;       /* Remote operation invalid           */

IMPLEMENTATION

END.