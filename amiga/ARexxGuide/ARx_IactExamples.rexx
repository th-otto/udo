/* $VER: 1.2 ARx_IactExamples by Robin Evans (8 Jul 1993,15 Oct 1993,11,20 Mar 1994)
**     v1.1: Added '+' to numbers in Numeric demo to un-exponent them   **
**     v1.2: Added showvalidsymbol which was left out the orig. guide.  */

foo = address()
address REXX
call trace 'B'

call addlib('rexxsupport.library',0,-30,0)

	/* My thanks to Tom Miller on GEnie for pointing out this elegant **
	** way to redirect output and input to a new window               */

arg SubR .

	/* set up various formatting codes in compound variables that     **
	** can be exposed to subroutines by using just the stem           */
csi='9b'x;f.slant=csi'3m'; f.bold=csi'1m'; f.norm=csi'0m'
			 f.black=csi'31m'; f.white=csi'32m'; f.blue=csi'33m'
			 f.lf = '0a'x; f.cls = csi'0;0H'csi'J'

options prompt f.white':::' f.norm

	/* Create a new standard-I/O console, so that we can use say      **
	** and pull instead of writeln() and readln() for output and      **
	** input. Note: the { system "rx.."} used in the AG link is       **
	** there because this setup won't work when AG is called by icon  **
	** unless that kludge is there. Using AG's RX command, the input  **
	** stream isn't opened under a workbench call                     */
call close STDOUT
if open(STDOUT, "con:98/8/584/345/ARexxGuide Examples/NOCLOSE/SCREEN *", w) then do
	call close STDIN
	call open STDIN, "*", W
	call pragma '*' STDOUT
	call pragma '*' STDIN
		/* for some odd reason, the Amiga shell won't reliably call an  **
		** external function when at the default Amigaguide address     */
	address REXX
	interpret 'call' SubR 'CLOSE'
	call close STDOUT
	call close STDIN
	call pragma('*')
	return 0
	address
end
else
	signal error

SYNTAX:
	ErrCo = rc
ERROR:
	signal off SYNTAX			/* to prevent any possibility of an endless loop */

	say '0a'x
	say 'Sorry, an unexpected error has occurred in line' SIGL
	if datatype(ErrCo, 'N') then
	say '      'ErrCo':' errortext(ErrCo)
	call delay(1000)
	push endcli
exit 9

/*	$VER: 1.0 ShowNumeric.rexx by Robin Evans (21 May 1993) */

ShowNumeric: procedure expose f.

/* Demonstrate the effect of different settings of NUMERIC DIGITS
**	and NUMERIC FUZZ
*/
arg CLOSE
options failat 21	/* to retain control when an error occurs */
signal on ERROR
signal on SYNTAX

say f.white||'   This example will demonstrate how different settings of'
say '   'f.black'NUMERIC DIGITS'f.white 'and' f.black'NUMERIC FUZZ'f.white 'affect the comparison'
say '   of numeric values.'||'0a'x
say '   Enter two numbers separated by at least one space, then'
say '   press <'f.blue||f.bold'Enter'f.norm'>.'
say f.lf||f.black'To quit, press <'f.blue||f.bold'Q'f.norm'> and <'f.blue||f.bold'Enter'f.norm'>.'f.lf

do MainLoop = 1		/* exits on the datatype() check 4 lines down */
	say f.lf||f.blue'Enter two numbers to be compared:'
	pull Num.1 Num.2 .
	do i = 1 to 2
			/* any non-numeric value (including null) causes an exit from
			**	the main loop above.
			*/
		Num.i = compress(Num.i, ',')
		if ~datatype(Num.i,N) then do
			if ~abbrev(upper(Num.i), 'Q') then do
				say 'You must enter two numbers.'f.white '   <Enter' f.blue'Q'f.white 'to quit>'f.black
				iterate MainLoop
			end
			else
				leave MainLoop
		end
			/* a decimal point is not considered part of a number's length */
		Num.i.len = length(compress(+Num.i,'.'))
	end
	MNum = max(num.1, num.2)
	XLen = max(num.1.len, num.2.len)
	numeric digits min(XLen, 14)
	if XLen > 14 then do
		say f.white'The greatest precision available in ARexx is 14 digits.'
		say 'The number you entered with' XLen 'digits would always'
		say 'be rounded to the closest 14-digit value:'||f.norm
			/*
			**	the prefix + sign causes MNum to be evaluated according to the
			**	current digits() setting
			*/
		say '       ' (+MNum) '0a'x
		XLen = 14
	end
	NLen = min(num.1.len, num.2.len)
		/* begin with a setting that will handle the largest number entered */

		/* if the numbers are equal under the most precise setting, then
		**	they will be equal under any other setting as well
		*/
	if num.1 = num.2 then do
		say (+num.1) 'will always be equal in any comparison to' (+num.2)
		call ShowImprecise
	end
	else do
		numeric fuzz digits() - 1
			/*
				check for equality under the least precise setting and then
				find out the most precise setting at which the two are equal
			*/
		if num.1 = num.2 then do
		numeric fuzz		/* reset to make the first comparison at 0 */
			do i=0 to XLen-1 while num.1 ~= num.2
				numeric fuzz i
			end
			if num.1 = num.2 then do
				say (+num.1) 'is considered equal to' (+num.2) 'under these conditions:'
				say '   DIGITS setting of' digits()
				say '   FUZZ   setting of' fuzz()
				say '   or at a FUZZ setting of 0 and DIGITS setting of' digits() - fuzz()
				numeric fuzz
				say f.white'      The following table shows how the numbers are presented'
				say '      under different settings of NUMERIC DIGITS.'
				say '      Digits()   'left(Num.1,18)	(Num.2)
				say f.blue'      ---------  ------------------ ------------------'f.norm
				do j = max(1,digits()-i) to xlen until strip(MNum) == (+MNum)
					numeric digits j
					say '     'center(digits(),11) left((+Num.1),18) (+Num.2)
				end
			end
		end
		else do
			say max((+num.1), (+num.2)) 'will always be considered greater than' min((+num.1), (+num.2))
			call ShowImprecise
		end
	end
	numeric fuzz
	numeric digits
end
if close = 'CLOSE' then
	push endcli
return 0

ShowImprecise:

		say f.white'   The following chart shows the two numbers under the'
		say '   most imprecise settings of NUMERIC DIGITS 1 and 2'
		say '   'left(+Num.1,15) (+Num.2)
		say f.blue'    -------------- --------------'f.norm
		numeric fuzz
		numeric digits 1
		say '   'left((+Num.1),15) (+Num.2)
		numeric digits 2
		say '   'left((+Num.1),15) (+Num.2)||f.norm
return

/* $VER: 1.1 ShowValidSymbol  (20 Mar 1994) */

ShowValidSymbol: procedure expose f.
call addlib('amigaguide.library',-2,-30,0)
if ~loadxref('ARx_Guide.xref') then CheckXR = 0
else CheckXR = 1
LineLen = 62; Tab = 3  /* Values for wordwrap function */
/* Tests whether a value input by the user is a valid symbol */
say WordWrap("This demonstration lets you enter a string of any kind. The",
			"program will tell you if the string could be used as a valid",
			f.white"symbol" f.black"in ARexx. Some symbols can serve as" f.white"variables"f.black"; some",
			"cannot. The program will tell you whether the string you",
			"entered is a" f.white"variable symbol"f.black "or a" f.white"constant"f.black".",,
			LineLen, 6)

ValidChars = 	xrange('a','z')xrange('A','Z')xrange(0,9)
Info = '0a'x||f.white'Enter a string or press <'f.blue||f.bold'Enter'f.norm||f.white'> alone to quit.'
options Prompt f.white'::: 'f.black
do forever
	Say Info
	pull Resp
	if Resp = '' then leave
	if ~datatype(resp, 'S') then do
		say '0a'x||f.white||Resp f.blue'in not a valid symbol in ARexx'f.black
		BadPos = verify(Resp, ValidChars'$_.!@#')
		say WordWrap("The character at position" BadPos "--"f.bold||f.white||substr(resp,BadPos,1)f.norm"-- in the string is invalid.",
		   "Any of the characters `"f.white"a"f.black"' through `"f.white"z"f.black"' or `"f.white"A"f.black"' through `"f.white"Z"f.black"',",
		   "or the digits `"f.white"0"f.black"' through `"f.white"9"f.black"' can be used.",
		   "You can also use any of these special characters:"f.white "$_!@#"f.black,
		   "The period character `"f.white"."f.black"' can be used, but it has special",
		   "significance.", LineLen, Tab)
	end
	else do
		say '0a'x||f.white||Resp f.blue'is a valid symbol.'f.black
		select
			when datatype(resp,'N') then do
				say WordWrap("Since it's a "f.white"number"f.black", it's what is known as a" f.white"constant",
				   "symbol"f.black". This symbol can be used in any" f.white"arithmetic operation"f.black,
				   "but it cannot be used as the target of an" f.white"assignment"f.black".",,
					LineLen, Tab)
				if pos('E', resp) > 0 then do
			   	numeric digits 14; numeric form scientific; stdnum = (+resp)
					numeric digits length(compress(left(resp,pos('E', resp)),'E.'))
					scinum = (+resp)
			   	numeric form engineering; engnum = (+resp)
			   	if SciNum == StdNum then NumCompare = '.'
			   	else if SciNum == EngNum then
			   		NumCompare = " or as"f.white SciNum f.black"in both scientific",
			   	   "and engineering notation."
			   	else
			   		NumCompare = ", as"f.white SciNum f.black"in scientific",
			   	   "notation, or as"f.white EngNum f.black"in engineering notation."
			   	say WordWrap('0a'x"   The `"f.white"E"f.black"' in this string represents" f.white"exponential notation"f.black".",
			   	   "The number can be expressed as"f.white StdNum f.black"in the highest",
			   	   "precision available in ARexx" || NumCompare,,
			   	   LineLen, Tab)
				   numeric digits; numeric form  scientific
			   end
			   else do
			   	NumLen = length(compress(strip(resp,'L',0),'.'))
			   	if NumLen > 9 then do
			   		say WordWrap('0a'x"   A" NumLen"-digit number is longer than what can be handled with the",
			   		   "default 9-digit" f.white"precision"f.black "of ARexx. If this number were used in an",
			   		   "an arithmetic operation, it would be rounded to" (+Resp)".",,
			   			LineLen, Tab)
			   		if NumLen > 14 then do
			   			numeric digits 14
				   		say WordWrap('0a'x"   The maximum precision in ARexx is 14 digits, so the closest value",
				   		   "that is available is" (+Resp)".", LineLen, Tab)
			   		end
			   		else do
			   			numeric digits NumLen
			   			say WordWrap('0a'x"   If the digits setting is increased to" NumLen "with the" f.white"NUMERIC DIGITS"f.black,
			   			   "instruction, then the number will be expanded to" (+resp)".",,
			   			   LineLen, Tab)
			   		end
			   		numeric digits
			   	end
			   end
			end
			when datatype(left(Resp, 1), 'N') then do
				say WordWrap("This is a `"f.white"constant symbol"f.black"' because of the digit at the",
				   "beginning. It cannot be used as the target of an",
				   "assignment. Because of the alphabetic characters in",
				   "the symbol, it cannot be used as a" f.white"number"f.black".",
				   "It may, however, be used as the logical "f.slant"<name>"f.norm" of a file",
				   "in OPEN(<name>, <filename>, <opt>).", LineLen, Tab)
				if pos('.', resp) > 0 then do
					say WordWrap('0a'x"   Despite the dot -- `.' -- at position" pos('.', resp) "in"f.white Resp||f.black", this",
					   "symbol cannot be used as a"f.white "compound variable"f.black "because",
					   "the"f.white "stem"f.black "of a compound cannot be a" f.white"constant"f.black".",,
						LineLen, Tab)
				end
				else do
					say WordWrap('0a'x"   It could also be used as a value in the" f.white"tail"f.black "of a",
					  f.white"compound variable"f.black". (Something like" f.white"FOO."resp||f.black".) Using",
					  "a" f.white"constant"f.black "as a tail value assures that another value",
					  "will not be substituted before the variable is evaluated.",,
					  LineLen, Tab)
				end
			end
			when verify(Resp,	ValidChars'$_!@#') = 0 then do
					say WordWrap("This is a `"f.white"simple symbol"f.black"' that can be used as the name of",
					   "a "f.white"variable"f.black".", LineLen, Tab)
						/* Is it a keyword? */
					if CheckXR then
						if word(getxref(resp),3) = 2 then do
							say WordWrap('0a'x||f.white"   "Resp f.black"is an "f.white"instruction keyword" f.black"in ARexx. (See" f.slant"Instruction",
							   "reference"f.norm "for more information.) Despite that, it is not",
							   "reserved and can be used as a"f.white "variable"f.black "in most situations.",,
							   LineLen, Tab)
						end
					if find('RESULT RC SIGL', Resp) > 0 then do
						say WordWrap('0a'x"   "f.white||Resp f.black"is one of three"f.white "special variables"f.black "used by the interpreter.",
						   "Although it can be assigned a value in a script, it is not wise",
						   "to use it that way since the interpreter might change its value.",,
						    LineLen, Tab)
					end
				end
			when pos('.', Resp) > 0 then
				select
					when left(Resp, 1) = '.' then do
						say WordWrap("Because of the period at the beginning, this is a "f.white"constant",
						   "symbol"f.black". It cannot be used as the target of an assignment.",
						   "The ANSI REXX committee has warned that symbols like this",
						   "might become invalid in the future.", LineLen, Tab)
					end
					when right(resp, 1) == '.' then
							/* make sure there's not a second period in there */
						if lastpos('.', Resp, length(Resp) - 1) = 0 & IsVar(resp) then do
							say WordWrap("This is a `"f.white"stem symbol"f.black"'. It is used as the base upon which a",
							   f.white"compound variable"f.black "can be built, but it can also be used by",
							   "itself in an assignment. If it is, then all compound variables",
							   "built from this stem -- like"f.white resp"1"f.black "-- will be assigned",
							   "the same value as a default value.", LineLen, Tab)
						end
						else do
							say WordWrap("This is a `"f.white"complex symbol"f.black"'. Note that it is not a" f.white"stem" f.black"because",
							   "it contains more that one `.' characters. Only the part of the",
							   "symbol before and including the first period --" f.white || left(resp, pos('.', resp))f.black "--",
							   "is a stem symbol.", LineLen, Tab)
						end
					when IsVar(resp) then do
						parse var Resp stem '.' tail
						say WordWrap("This is a `"f.white"complex symbol"f.black"'. The `"f.white||stem"."f.black"' part of the symbol",
						         "is called the `"f.white"stem"f.black"'. The rest of it, `"f.white||tail||f.black"', is called",
						         "the `"f.white"tail"f.black"'. If any simple symbol in the tail is assigned a",
						         "value, then that value is substituted when the variable",
						         "named by this symbol is evaluated in an expression.",,
						         LineLen,Tab)

					end
					otherwise
						say "   This is a" f.white"constant symbol"f.black". It cannot be assigned a value."
				end
			otherwise NOP
		end
	end
end
call remlib('amigaguide.library')
return 0

IsVar:
   /* call trace b */
   return symbol(arg(1)) ~== 'BAD' & (datatype(left(arg(1),1), m),
                                     | verify(left(arg(1),1), '!$_@#', M))

 WordWrap: procedure
   /* Arguments:                                                        **
   ** Text       := The string that is to be split into parts           **
   ** Length     := Maximum length of lines desired.                    **
   ** Tab        := White space to add at start of line                 */
   parse arg Text, Length, Tab

   Line. = ''                            /* All compounds are now null  */
   EndPos = length(Text); DivPos = 1     /* Preliminary values for loop */
   numeric digits
   Length = Length - Tab	/* shorten it to allow for the tab           */
   Line = ''; csi = '9b'x
   do i = 1 while EndPos <= length(Text)
   		/* Get a rough count of control characters in the line        */
   	FmtChar = CountChar(csi, substr(Text, DivPos, Length + 12))*4
      EndPos = lastpos(' ',Text' ', DivPos + FmtChar + Length+1)
         /* Handle a word that's bigger than the line length by         **
         ** splitting it arbitrarily at the line length                 */
      if EndPos < DivPos then do
         EndPos = DivPos + Length - 1
         Text = insert('- ', Text, EndPos-2)
      end
      Line = Line || copies(' ', Tab)substr(Text, DivPos, EndPos-DivPos)'0a'x
         /* Add one to DivPos because we want to get rid of the space   **
         ** at the start of each line.                                  */
      DivPos = EndPos + 1
   end
   return strip(Line,'t', '0a'x)

CountChar:
   return length(arg(2)) - length(compress(arg(2), arg(1)))




/*	$VER: 1.0 ShowSTDIO.rexx by Robin Evans (11 Jun 1993) */

ShowSTDIO: procedure expose f.

/* Demonstrate the effect of redirected IO. */

arg CLOSE
options failat 21	/* to retain control when an error occurs */
signal on ERROR
signal on SYNTAX

LFS = f.lf||f.white

do forever		/* Loop allows reentering the demonstration */
	say f.white||f.cls
	say '      This demonstration will write a small ARexx file to the t:'
	say '      directory.'
	say
	say '      That file will be called with various forms of' f.black'redirection'f.white
	say '      to demonstrate the effect of redirection characters on '
	say '      ARexx files.'f.norm

		/* Save the demo file to the ram: disk T: directory */
	TFName = 't:testIO.rexx'
	TestCode = '/**/'f.lf'options prompt "0a"x||"Enter any text then press <Enter>: "'f.lf'pull T$'f.lf'say "0a"x||"You entered:" T$'f.lf
	if open(TFile, TFName, w) then do
		call writech(TFile, TestCode)
		call close TFile
		if QKey() then return 0
		say LFS'The file has been written to the T: directory:'
		call showSPrompt('list' left(TFName, 5)'#?')
		call showSPrompt( 'type' TFname)
		if QKey() then return 0
		say f.lf LFS'We will now run that program. Enter some text when prompted:'
		call showSPrompt('rx' TFname)
		say LFS'Notice that the program output to the shell the text you entered.'
		if QKey() then return 0
		say LFS'We''ll run it again, but this time we''ll redirect output using'
		say '   the DOS ">" redirection operator.'
		call showSPrompt('rx' TFname '>T:IOutput')
		say LFS'Notice that the program didn''t output anything this time, even'
		say '   though the SAY instruction is still in the program.'
		say '   What happened? Observe:'
		call showSPrompt('type T:IOutput')
		say LFS'Because of the redirection operator, the output of SAY went to a'
		say '   file instead of to the screen.'
		if QKey() then return 0
		say LFS'What happens when both input and output are redirected?'
		call showSPrompt('rx' TFname '<'TFName '>T:IOutput')
		say LFS'There was no prompt this time because the PULL instruction was'
		say '   redirected to look for its input from the file "'TFName'".'
		say '   It pulled the first line from that file:'
		call showSPrompt('type T:IOutput')
	end
	say f.lf||f.white||f.slant'This concludes the demonstration.'f.norm
	say '   Press <'f.white||f.bold'Enter'f.norm'> to quit or <'f.white||f.bold'R'f.norm'> and <'f.white||f.bold'Enter'f.norm'> to repeat the demo.'
	pull Rsp
	if Rsp ~= 'R' then leave
end
return 0

QKey: procedure expose f.
	options prompt f.lf||f.blue'   Type <Q> and <Enter> to quit. Press <Enter> alone to continue.'f.norm
	pull QKey
	if QKEY = Q then return 1
	else return 0

ShowSPrompt: procedure expose f.
	address command
	parse arg DCmd
	call writech(STDOUT, f.lf||f.blue'Shell'f.white'> 'f.norm)
	call delay(30)
	say DCmd
	""DCmd
return 0

DoBreak: procedure expose f.
      /* Show how the break keys work in a subroutine */
		signal off break_e
      Say f.white" Press Control and E to stop the obnoxious listing that"
      say " will follow this message."f.black
      if QKey() then return
      NumRepeats = AdInfinit()
      say f.white||f.lf'The message was repeated' NumRepeats 'times.'
      say f.lf'We have returned from a subroutine to the main code of'
      say 'the program. The break key was detected within the subroutine'
      say 'but control could still be returned to the main program.'
      say f.lf||f.white'   This demo is coded in the file' f.blue'ARx_IactExamples.rexx'
      say f.white'   in the subroutine' f.blue'DoBreak:'
      say f.black||f.lf'- Press any key - '
      pull .
      return

         /* The subroutine being called by SIGNAL can be anywhere in **
         ** program. PROCEDUREい, used in AdInfinit blinds it to     **
         ** variables in the main program, but still allows the      **
         ** BREAK_E subroutine to retrieve the [Rep] variable.       */

      BREAK_E:
         say f.blue'Break detected at line' SIGL':'
         say f.white||sourceline(SIGL)
         return Rep

      AdInfinit: PROCEDURE expose f.
            /* turning on the signal within the subroutineい means    **
            ** it will be effective only while this subroutine is     **
            ** active                                                 */
         signal on break_e
         do Rep = 1
            say 'Press Ctrl-E at any time.'
            call delay 25
            say 'Stop me. Please.'
         end
            /* because the loopい above is endless, this RETURNい     **
            ** will never be reached.                                 */
         return 0

