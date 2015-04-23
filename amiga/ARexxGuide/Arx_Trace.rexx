/*	$VER: 1.3   ARx_Trace.rexx   by Robin Evans (14 Oct 1993,12 Mar 1994)  */
/* 1.3: added 'S*' to window specs for WShell users to open it            **
** on front screen. Fixed some problems with ? option                     */

/* Demonstrate various trace options                                      **
**   Thanks to Dean Adams for suggested changes.                          */

call trace(b)

call addlib('rexxsupport.library',0,-30,0)
signal on syntax; signal on failure

LF = '0a'x;	LFS = LF'   '
csi='9b'x;
slant=csi'3m';bold=csi'1m';norm=csi'0m';
black=csi'31m';white=csi'32m';blue=csi'33m'
CLS = csi'0;0H'csi'J';NoCursor = csi'302070'x
CursorOn=csi'2070'
FontSize = FontInfo()
MaxHi = 400

Tr. = ''
Tr.1 = I; Tr.I.1Num = 1; Tr.I = 'Intermediates'
Tr.2 = R; Tr.R.1Num = 2; Tr.R = 'Results'
Tr.3 = A; Tr.A.1Num = 3; Tr.A = 'All'
Tr.4 = C; Tr.C.1Num = 4; Tr.C = 'Commands'
Tr.5 = E; Tr.E.1Num = 5; Tr.E = 'Errors'
Tr.6 = N; Tr.N.1Num = 6; Tr.N = 'Normal'
Tr.7 = O; Tr.O.1Num = 7; Tr.O = 'Off'
Tr.8 = B; Tr.B.1Num = 8; Tr.B = 'Background'
Tr.9 = S; Tr.S.1Num = 9; Tr.S = 'Scan'
Tr.10= L; Tr.L.1Num =10; Tr.L = 'Labels'
Char = '?'
Tr.11 = Char; Tr.Char.1Num = 11; Tr.Char = 'Interactive'
Tr.12 = '!'; Tr.!.1Num = 12; Tr.! = 'No commands'

ColPos = 90
OpenMode:
if open(ModeWin, 'raw:0/'ColPos'/128/'min(MaxHi, 27*FontSize)'/Modes/NOCLOSE/INACTIVE/NOALT/NOPROP/NOSIZE/SCREEN *', W) then do
		/* cursor invisible, don't wordwrap, move to top left  */
	call writech(ModeWin, '9b3020709b3f376c9b48'x' ')
	call writech(ModeWin, '9b302071'x)
	BoundRpt = readch(ModeWin, 12)
	parse var BoundRpt ';'. ';' WinLines ';' .
	if WinLines < 25 then do
		if MaxHi = 400 then do
			MaxHi = 200
			MinPos = 1
			call close ModeWin
			ColPos = 0
			signal OpenMode
		end
	end

	do j = 1 to WinLines%2
		call writeln ModeWin, white||value('Tr.'Tr.j)
		call writeln ModeWin, blue' --'black Tr.j
	end
		/* get window bounds report */
end
else
	signal error

ExampleLine = LocateEx()


ListPos = 14*FontSize
if MinPos = 1 then
	RowPos = 11
else
	RowPos = ListPos - 11

ListOpen = open(ListWin, 'con:70/0/468/'ListPos'/Program being traced/NOCLOSE/INACTIVE/SCREEN *', 'W')
if ListOpen then do
		/* cursor invisible */
	call writech(ListWin, NoCursor)
		/* don't word wrap */
	call writech(ListWin, '9b3f376c'x)
end

		/* is the trace console open? If so, close it */
if show(F, STDERR) then do
	call writeln(stderr, 'Trying to close this stream')
	address command 'TCC'
end
	/* Turn off global trace flag. OK if it isn't on */
address command 'TE'

call close STDOUT
if open(STDOUT, 'con:70/'RowPos'/570/'MaxHi-RowPos'/ARexxGuide Examples/SCREEN *', W) then do
	CurTrace = trace('N')
	if pos('?', CurTrace) then call trace('?')
	call close STDIN
	call open STDIN, "*", R
	call close STDERR
	call open  STDERR, "*"
	say CLS

	say white||'This demonstration will show how the various options to the TRACE()'
	say 'function and TRACE instruction affect the display of a program.'
	say LF'We will output the trace to this window rather than redirecting'
	say 'it to the trace console.'||black

	if ListOpen then do
		call CopyPrg(ExampleLine ListWin)
		say '0a'x'The program we will trace is listed in the window above.'
		say 'The available modes are listed to the left.'
	end

	else
		signal error
	drop i

	if AKey() then return 0
	Options prompt white'   Enter the tracing mode to use: 'black
	do MPrompt = 1 until TMode = 'Q'
		say LF||blue'Enter <'black'Q'blue'> to quit or mode code.'black
		pull TMode
		TOpt = ''
		if TMode ~= 'Q' & TMode ~= '' then do
			if verify(TMode, '!?', 'M') > 0 then do
					/* Is there another char in front of '?' or '!' ? */
				if verify(TMode, '?!') = 1 then do
					say 'The characters "?" or "!" must precede the letter option.'
					iterate MPrompt
				end
					/* [TOpt] used for info messages.   */
				TStr = compress(TMode,'?! ')
				parse var TMode TOpt (TStr)
				TMode = TStr
				if TMode = '' then do
					TMode = TOpt
					TOpt = ''
				end
			end
			else do
				TOpt = ''
				TMode = left(TMode, 1)
				if Tr.Tmode = '' then do
					say TMode 'is not a recognized trace option.'LF
					iterate MPrompt
					end
				end
				say CLS
				say blue'************ TRACE' upper(Tr.TMode)':'black
				if verify(TOpt,'!','M') > 0 then say white'Commands will not be executed'black
				if verify(TOpt,'?','M') > 0 | pos('?', TMode) > 0 then do
					say white'Interactive tracing will be used.'black
					call IactMsg
				end
				select
					when datatype(TMode, 'N') then do
						say cls||white'You may enter a positive number to temporarily disable'
						say 'interactive tracing. A negative number will turn off tracing'
						say 'altogether for the specified number of lines.'
						say 'We''ll start the trace as' black'?R'white'.'
						say blue'At any of the >+> pause points below, you may:'white
						say '   Enter' black'TRACE' abs(TMode) white'to disable the pause through' abs(TMode) 'lines'
						say '   Enter' black'TRACE -'abs(TMode) white'to quiet the trace for' abs(TMode) 'lines.'
						say black'                 Press <Enter> to continue.'NoCursor
						call readln(STDIN)
						TMode = '?R'
					end
					when Tr.TMode.1Num = 12 then do
						say white'"!" is one of the options that can be used in conjunction with'
						say 'any of the letter options.'black
					end
					when Tr.TMode.1Num = 11 then do
						say white'The "?" symbol works as a toggle. We''ll start the trace as'
						say 'TRACE ?R which will show results. Enter TRACE ? again at any'
						say 'pause point to end the interactive trace.'black
						TMode = '?R'
					end
					when Tr.TMode.1Num = 10 then do
						say white'Since there are no function calls in the program being'
						say 'traced, the "Label" option will be turned on before reaching'
						say 'the subroutine that contains the code being traced.'black
						OldT = trace(TMode)
					end
					when Tr.TMode.1Num = 9 then do
						say white'We cannot run a scan trace on a subroutine in this program'
						say 'because the RETURN that ends the subroutine will not be'
						say 'recognized. The example will be copied to T: and scanned'
						say 'from there.'LF||black
						if ~exists('t:ScanTrace') then
							if open(1Prg, 't:ScanTrace', W) then do
								call writeln(1Prg, '/**/ SIGNAL ON SYNTAX')
								call CopyPrg(ExampleLine 1Prg)
								call writeln(1Prg, 'SYNTAX:')
								call writeln(1Prg, '   return 0')
								call close 1Prg
							end
						address REXX 't:ScanTrace' TOpt'S'
						iterate MPrompt
					end
					when Tr.TMode.1Num > 6 then do
						say white'TRACE' Tr.TMode 'will turn off tracing. To see how it works,'
						say 'enter TRACE' TMode 'at any of the pause points ( >+> ).'
						say 'You will be presented with one more pause point before the new'
						say 'option takes effect.'||black
						TMode = '?R'
					end
					when Tr.TMode.1Num = 5 then do
						say white'This dummy command executed in an external environment'
						say 'will show how the option works. Note that AmigaDOS outputs'
						say 'the initial error message -- the first two lines.'LF||black
						call ErrCmd E
						iterate MPrompt
					end
					when Tr.TMode.1Num = 6 then do
						say white'TRACE Normal will output only those clauses that contain a'
						say 'command that sets a return code higher than the current'
						say 'failure level which would cause the ARexx exec to terminate.'LF
						say 'This dummy command executed in an external environment'
						say 'will show how the option works. Note that AmigaDOS outputs'
						say 'the initial error message -- the first two lines.'LF||black
						call ErrCmd N
						iterate MPrompt
					end
					when TMode = 'A' then do
						say white'Only the clauses in the program will be output. Results are not'
						say 'shown with this option.'LF||black
					end
					otherwise
				end
				say ''
				call TracePrg TOpt||TMode
				if show('F', IactWin) then
					call close IactWin
						/* With interactve tracing, it's possible for the user **
						** to cause DirFile not to be closed. This makes sure  **
						** it is now closed.                                   */
				if show('F', DirFile) then
					call close DirFile
				if exists('t:dirs') then
					call delete('t:dirs')
				if pos('L', trace()) > 0 then
					call trace(OldT)
			end
		end
		call close ListWin
		call close ModeWin
		call close STDOUT
		call close STDIN
		call pragma('*')
	end
	return 0
end
else
	signal error

SYNTAX:
	ErrCo = rc
ERROR:
FAILURE:
	signal off SYNTAX			/* to prevent any possibility of an endless loop */

	say '0a0a'x||'Sorry, an unexpected error has occurred in line' SIGL
	if datatype(ErrCo, 'N') then
		say '      'ErrCo':' errortext(ErrCo)
	options prompt '                Press <Enter>'
	pull .
	drop ErrCo
return 9

BREAK_C:
	return

CopyPrg: procedure

	arg PgLn1 CopyTo .
	do i = PgLn1 while sourceline(i) ~= 'return'
		call writeln(CopyTo, sourceline(i))
	end
return 0

LocateEx: 	/* used to locate the line number of the preceding */
	Signal SendLine:
SendLine:
	return Sigl +7

TracePrg: procedure expose LF DirFile
signal on failure; signal on break_c

 /*******  FileName.rexx  ** Demonstrate TRACE *******/
 arg TMode; call trace TMode; say trace() '--' tmode
 address command "list nohead quick : dirs to t:dirs"
 if open(DirFile, 't:dirs', R) then do
 	FDir = readln(DirFile);	call close DirFile
 end
 parse source . . . FilePath .
 DivPos =  1 + max(lastpos(':', FilePath),,
     lastpos('/', FilePath))
 parse var FilePath Dir =DivPos FileName
 say LF'File: "'Filename'" Directory: "'Dir'".'LF
return

AKey:
	options prompt LF||blue'   Type <'black'Q'blue'> and <'black'Enter'blue'> to quit. Press <'black'Enter'blue'> alone to continue.'
	pull AKey
	if AKey = Q then return 1
	else return 0

IactMsg:
	if open(IactWin, 'con:3/6/472/'9*FontSize'/Interactive tracing options/NOCLOSE/INACTIVE/NOALT/NOPROP/NOSIZE/SCREEN *', W) then do
		call writeln(IactWin, white||'	You have these options at the >+> prompt:')
		call writeln(IactWin, LF' -- Press <'black'Enter'white'> to continue to next clause')
		call writeln(IactWin, ' -- Type = and <'black'Enter'white'> to reexecute previous clause.	')
		call writeln(IactWin, ' -- Enter any valid ARexx clause.')
		call writeln(IactWin, '    That clause will be interpreted as though it was a')
		call writeln(IactWin, '    part of the program. Try changing the value of the')
		call writeln(IactWin, '    variable [FileName], for instance.')
	end
	else
		signal error
return 0

ErrCmd: procedure
	arg TOpt
	signal off failure
	signal off error
	address command "RX ""call trace" TOpt "; address command 'copy foo moo'"""
return

FontInfo: procedure
		/* Get default font */

	gfxbase=showlist(l, 'graphics.library',,a)

	FontAddr = next(gfxbase,154)
	call forbid()
	FSize = c2d(import(offset(FontAddr, 20),2))
	call permit()
return FSize
