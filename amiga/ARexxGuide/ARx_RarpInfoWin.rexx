/* $VER: ARx_RArpInfoWin.rexx v 2.0                                    **
**    Opens a rexxarplib window that displays information about the    **
**    ARexx statement on the current line of an editor. Called as      **
**    external function by ARx_Help.#?.                                **
** Arguments:                                                          **
**		HLine    := The full line on which cursor is located             **
**		LkUp     := The word on which cursor is located                  **
**		CurPos   := Cursor x position within HLine                       **
**		Kwd      := The first word in HLine                              **
**    PoC      := Port to which button commands will be sent           **
**		ExecStr  := The string that's sent by rexxarplib button press    **
**		WInfo    := Position and screen name of editor window            */

parse arg HLine, LkUp, CurPos, Kwd, PoC,ExecStr, WInfo
	/* They should still be on list, but just in case...                */
call addlib('rexxsupport.library', 0, -30, 0)
call addlib('rexxarplib.library', 0, -30, 0)
call addlib('amigaguide.library', -2, -30, 0)

if word(ExecStr, 1) = 'QUOTE' then do
	QuoteCmd = 1
	ExecStr = subword(ExecStr, 2)
end
else
	QuoteCmd = 0
   /* figure out what type of clause the current line is */
select
		/* Is it an assignment? Check later on for valid var */
	when word(HLine, 2) = '=' then
		CType = 2
		/* Is it a comment?    */
   when pos('/*', HLine) < CurPos & pos('/*', HLine) ~= 0 then
      if pos('*/', HLine) > CurPos | pos('*/', HLine) = 0 then
         CType = 4
      /* Is it an instruction? */
   when getxref(word(HLine,1)) ~= 10 then do
      Xref = getxref(word(HLine,1))
      if word(Xref,3) = 2 then
         CType = 1
   end
   	/* Is it a label?      */
   when right(word(HLine,1), 1) = ':' then
      CType = 3
      /* Is it null?         */
   when HLine = '' then
      CType = 5
      /* Then it must be a command or assignment without spaces. */
   otherwise
      CType = 0
      	/* Is it an assignment instead of a command? */
      EqPos = pos('=', HLine)
      if EqPos > 0 then do
      		/* Add spaces for later checks        */
         if symbol(strip(left(HLine, EqPos-1))) ~= 'BAD' then do
            HLine=insert(' ', HLine, EqPos - 1)
            HLine = insert(' ', HLine, EqPos + 2)
            CType = 2
            if CurPos > EqPos then CurPos = CurPos + 2
         end
      end
end
if CType = 2 then
   if ~IsVar(word(HLine, 1)) then
      CType = 0

/* Prepare window gadgets to explain the clause. */
CName.0 = 'Command'
CName.1 = 'Instruction'
CName.2 = 'Assignment'
CName.3 = 'Label'
CName.4 = 'Comment'
CName.5 = 'Null'
Gad. = ''
Gad.1.6Txt = 'Current clause is'
Gad.1.6Btn = CName.CType
Gad.1.6Cmd = ExecStr CName.CType
Gadgets = 1
select
   when CType = 1 then do
      Gad.2.6Txt = 'Current keyword is'
      Gad.2.6Btn = Kwd
      Gad.2.6Cmd = ExecStr Kwd
      Gadgets = 2
   end
   when CType = 3 then do
      Gad.2.6Txt = 'Name of subroutine:' word(HLine,1)'.'
      Gadgets = 2
   end
   	/* happens when cursor is at the end of a comment */
   when ~datatype(CType, 'N') then
   	Gadgets = 0
   otherwise
end

      /* Figure out what the current word is doing */
      /* Use variables to make the bit settings more obvious */
FuncName = 0; Arg = 1; Str = 2; Var = 3; Num=4; Hex=5; Bin=6; Cnst=7; Cmpd = 8
if CType <= 3 & LkUp > '' then do
      /* Split the string so we can compare both sides */
   parse var HLine LStr =CurPos RStr
      /* Get only the portion of the string which contains LkUp */
   WdRange = substr(HLine, max(1, CurPos - length(LkUp)), length(LkUp) *2)

      /* Use Bit functions to keep multiple matches */
   WType = null()||null() /* Using more than 8 bytes */
      /* Is it a string in single quotes ? */
   if IsVar(LkUp) then do
      WType = bitset(WType, Var)
      if Kwd = 'CALL' then
      	if abbrev(word(HLine, 2), LkUp) then
      		WType = bitset(WType, FuncName)
      	else
      		WType = bitset(Wtype, Arg)
   end
   if verify(HLine, '"''', M) > 0 then do
      if CountChar(LStr, "'")//2 then do
         WType = bitset(WType, Str)
            /* Is it a quoted function name? */
         if pos(LkUp"'(", WdRange) & bittst(WType, Var) then
               WType = bitset(WType, FuncName)
         else if datatype(LkUp, X) then
            if pos(upper(LkUp)"'X", upper(HLine)) > 0 then
               WType = bitset(WType, Hex)
         else if datatype(LkUp, B) then
            if pos(upper(LkUp)"'B", upper(WdRange)) > 0 then
               WType = bitset(WType, Bin)
      end
         /* Is it a string in double quotes? */
      else if CountChar(LStr, '"')//2 then do
         WType = bitset(WType, Str)
         if pos(LkUp'"(', WdRange) & bittst(WType, Var) then
               WType = bitset(WType, FuncName)
         else if datatype(LkUp, X) then
            if pos(upper(LkUp)'"X', upper(HLine)) then
               WType = bitset(WType, Hex)
         else if datatype(LkUp, B) then
            if pos(upper(LkUp)'"B', upper(WdRange)) > 0 then
               WType = bitset(WType, Bin)
      end
      	/* If it's a string, it isn't a variable          */
      if bittst(WType, Str) then
         WType = bitclr(WType, Var)
   end
      /* Is current word enclosed in parens? */
   if verify(HLine, "()", M) > 0 then do
      if CountChar(LStr, "(") - CountChar(LStr, ")") > 0 then
            WType = bitset(WType, Arg)
      if pos(LkUp'(', WdRange) > 0 & bittst(WType, Var) then
            WType = bitset(WType, FuncName)
   end

      /* is it a number or constant? */
   if datatype(LkUp, N) then do
         /* Make sure it isn't already a hex or bin string */
      if ~bittst(WType, Hex) & ~bittst(WType, Bin) then
            WType = bitset(WType, Num)
   end
      /* compare String/Var. If it isn't one of those it's a constant */
   else if ~bittst(WType, Var) then do
      if ~bittst(WType, Str) then
         WType = bitset(WType, Cnst)
   end
   else if pos('.', LkUp) > 0 then
   	WType = bitset(WType, Cmpd)
      /* it could have been assigned FuncName in either check above **
      ** In either case, a Function name isn't a variable           */
   if bittst(WType, FuncName) then
      WType = bitclr(WType, Var)
   if CType = 3 then
   	if abbrev(Kwd, upper(LkUp)) then
   		WType = null()

		/* Now take out the string def from hex/bin numbers           */
	if verify(bitcomp(WType, bitand(d2c(hex), d2c(bin))), Hex Bin) = 0 then
		WType = bitclr(WType, Str)
      /** Prepare gadgets to explain current word **/
   if WType ~= null() then do
      interpret 'Gad.'Gadgets+1'.6Txt = ''"''Lkup''" is'''
      if bittst(WType, FuncName) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Function name'
         Gad.Gadgets.6Cmd = ExecStr 'FUNCTION'
      end
      if bittst(WType, Arg) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Function argument'
         Gad.Gadgets.6Cmd = ExecStr 'FUNCARG'
      end
      if bittst(WType, Str) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'String'
         Gad.Gadgets.6Cmd = ExecStr 'STRINGEXPR'
      end
      if bittst(WType, Hex) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Hex string'
         Gad.Gadgets.6Cmd = ExecStr 'HEXSTRING'
      end
      if bittst(WType, Bin) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Binary string'
         Gad.Gadgets.6Cmd = ExecStr 'HEXSTRING'
      end
      if bittst(WType, Var) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Variable'
         Gad.Gadgets.6Cmd = ExecStr 'VARIABLE'
      end
      if bittst(WType, Cmpd) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn= 'Compound variable'
         Gad.Gadgets.6Cmd = ExecStr 'COMPVAR'
      end
      if bittst(WType, Num) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Number'
         Gad.Gadgets.6Cmd = ExecStr 'NUMBER'
      end
      if bittst(WType, Cnst) then do
         Gadgets = Gadgets + 1
         Gad.Gadgets.6Btn = 'Constant symbol'
         Gad.Gadgets.6Cmd = ExecStr 'CONSTANT'
      end
   end
end
   /* Open the rexxarplib requester window */
CPort = 'ARX_ARP'
if ~InfoWin(CPort, Gadgets+2, 'Lookup:' LkUp, PoC, word(WInfo, 1), word(WInfo, 2), word(Winfo, 3)) then return 10


if PoC = 'ARX_HELP' then
	CloseCmd = 'address' CPort '"QUIT";Status = CLOSE'
else if abbrev(PoC, 'TURBO') then
	CloseCmd = 'ExecARexxString address' CPort '"QUIT"'
else
	CloseCmd = 'address' CPort '"QUIT"'

	/* Draw the gadgets into the window     */
x = 10; y = 32
do i = 1 to Gadgets
   call move(CPort, x, y)
   if Gad.i.6Btn = '' then
      Txt = center(Gad.i.6Txt,47)
   else
      Txt = right(Gad.i.6Txt, 21)
   call Text(CPort, Txt)
   if Gad.i.6Btn > '' then do
		if QuoteCmd then
			Gad.i.6Cmd = '"'Gad.i.6Cmd'"'
      call AddGadget(CPort, 192, y - 9, i, ' 'left(Gad.i.6Btn, 26),Gad.i.6Cmd)
   end
   y = y + 15
end
	/* Can't open onto the index contents because that is in main */
if QuoteCmd then
	IdxCmd = '"'ExecStr 'ARx_NdxCont"'
else
	IdxCmd = ExecStr 'ARx_NdxCont'
call AddGadget(CPort, 10, y-4, 14, ' View ARexxGuide index ',IdxCmd)
call AddGadget(CPort, 344, y-4, 15, ' Cancel ', CloseCmd)

/* Since some editors can't receive commands to be sent on to AmigaGuide **
** this port can be used to receive command from the button window. It's **
** opened if the address established by the SETADDRESS function in the   **
** editor macro is set to 'ARX_HELP'                                     */
if PoC = 'ARX_HELP' then do
   PortAddr = openport(Poc)
      /* Loop until a Cmd changes the value of [Status] */
   do until Status = 'CLOSE'
      call waitpkt(PoC)
      Packet = getpkt(PoC)
         /* Make sure we have a real message in [Packet] */
      if Packet ~= null() then do
         Cmd = strip(getarg(Packet),,'"')
         interpret Cmd
         call reply(Packet, 0)
         status = 'CLOSE'	/* It was a good command, so get out */
      end
   end
   call closeport PortAddr
end

return 0


InfoWin: procedure
   parse arg CPort, Rows, WinTitle, PoC, x, y, PubScr

      /** shut down previous requester if it's still around **/
   if show(P, CPort) then do; address value CPort; quit; address; end
      /* change notifyport (PoC) to a port read by this script */
   address ARexx "'call CreateHost("CPort"," PoC", "PubScr")'"
      /**   Open the window   **/
   idcmp = 'CLOSEWINDOW+GADGETUP'
   flags = 'WINDOWCLOSE+WINDOWDRAG+WINDOWDEPTH+ACTIVATE'
   address command 'waitforport' CPort
   Height = 16+15*Rows
   if rc = 0 then do
      call OpenWindow(CPort, x, y, 422, Height, idcmp,flags, WinTitle)
      call SetAPen(CPort, 2)
      call SetNotify(CPort, CLOSEWINDOW, CPort)
      return 1
	end
   else
      return 0


CountChar:
call trace b
return length(arg(1)) - length(compress(arg(1), arg(2)))

IsVar:
   call trace b
   return symbol(arg(1)) ~== 'BAD' & (datatype(left(arg(1),1), m),
                                     | verify(left(arg(1),1), '!$_@#', M))
