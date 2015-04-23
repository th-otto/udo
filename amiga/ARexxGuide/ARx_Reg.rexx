/* $VER: 1.1	ARx_Reg.rexx by robin evans  (26 May 1993) */
/*
** Produces a registration form and prompts user for input.
** Helpfully modified by Dean Adams. Thanks, Dean.
*/


csi='9b'x;f.slant=csi'3m'; f.bold=csi'1m'; f.norm=csi'0m'
			 f.black=csi'31m'; f.white=csi'32m'; f.blue=csi'33m'
			 f.lf = '0a'x; f.cls = csi'0;0H'csi'J'
/*
 * NO CURSOR
 */
f.nc=csi'302070'x

signal on break_c
signal on break_e
signal on failure

options prompt f.blue||'::: 'f.black
say f.blue'Setting up prompts...'f.black

NumPrompts = SetPrompts()
Amount = $15.00

call writech STDOUT, f.cls
do i = 1 to NumPrompts
	say f.blue||PROMPT.i.6Prompt
	say f.white'Please enter' PROMPT.i':'
	parse pull Entry.i
end

	say f.lf||f.white||f.cls'You entered:'||f.lf||f.black
	do j = 1 to NumPrompts
		call WordWrap Entry.j, 63, f.blue||right(j,2)'.)'f.black'  ', 6, 'STDOUT'
		/*
		DivPos = lastpos(' ', Entry.j' ', 62) + 1
		say f.blue||right(j,2)'.)'f.black'   'left(Entry.j, DivPos)
		do while DivPos <= length(Entry.j)
			EndPos = lastpos(' ',Entry.j' ', DivPos + 63)
			say '       'substr(Entry.j, DivPos, EndPos-DivPos)
			DivPos = EndPos + 1
		end
		*/
	end

	do forever		/* Leave on result of prompt below */
		say f.white'Would you like to change something? (Y/N)'
		pull ChangeResp
		if abbrev(ChangeResp, 'N') then leave
		if abbrev(ChangeResp, 'Y') then do
			say f.white||'Enter the number of the item to be changed:'
			pull ChNum
			if datatype(ChNum, N) & ChNum < NumPrompts then do
				say '            'Entry.ChNum
				say f.blue||PROMPT.ChNum.6Prompt
				say f.white'Please enter ' PROMPT.ChNum':'
				parse pull Entry.ChNum
			end
			else
				say 'Invalid input.'
		end
		else
			say f.black'    Please enter Y or N'f.lf
	end

	FileName = ''
		/* Keep repeating the prompt until recognizable response is obtained */
	do until verify(left(Dest,1), 'PFQ') = 0
		say '0a'x'Save file to Printer or File?'
		say 'Enter <P> for Printer or <F> for File.' f.blue'Enter <Q> to quit'

		pull Dest
		if abbrev(Dest, 'P') then
			FileName = 'PRT:'
		else if abbrev(Dest, 'F') then
			FileName = GetFile()
				/* Give the prompt again until the response is correct */
	end
	if FileName > '' then do
			/* Save the information */
		if open(6OFile, FileName, W) then do
			call writeln(6OFile, f.bold||'      ARexxGuide registration.  Second edition.'f.norm)
			call writeln(6OFile, '0a0a0a'x || '      Send this form and registration fee to')
			call writeln(6OFile, copies(' ',40)'Robin Evans')
			call writeln(6OFile, copies(' ',40)'1020 Seneca St. #405')
			call writeln(6OFile, copies(' ',40)'Seattle WA  98101-2720')
			call writeln(6OFile, '0a0a'x||copies(' ',6)'REGISTERED USER:')
			do i = 1 to 7
				call writeln(6OFile, copies(' ',16)Entry.i)
			end
			call writeln(6OFile, '0a'x||copies(' ',6)'Enclosed is' Amount 'to register ARexxGuide.')
			call writeln(6OFile, '0a0a'x||copies(' ',2)'MACHINE INFORMATION:')
			do i = 8 to 11
				call writeln(6OFile, right(Prompt.i,31)'  'Entry.i)
			end
			parse version . Ver Proc .
			if Proc = 68070 then Proc = 68040
			call writeln(6OFile, right('Processor',31)'  'Proc)
			call writeln(6OFile, '0a0a'x||copies(' ',4)'ARexx INFORMATION:')
			call writeln(6OFile, right('ARexx version',31)'  'Ver)
			do i = 13 to NumPrompts - 1
				call writeln(6OFile, right(Prompt.i,31)'  'Entry.i)
			end
			call writeln(6OFile, '0a0a'x||copies(' ',6)'COMMENTS:')
			call WordWrap Entry.NumPrompts, 73, '        ', 8, 6OFile
			say f.cls||f.black'The registration form has been saved to' FileName'.'
			say f.lf'Thank you very much for registering.'
		end
	end
	else signal ProblemExit
	options prompt f.lf||f.blue||f.nc'   Press <'f.white||f.bold'Enter'f.norm||f.blue'>'f.norm
	pull .

exit 0

Failure:
Break_C:
Break_E:
ProblemExit:
	say f.cls||f.blue'Hmm.' f.black'I hope we didn''t run into a problem on that.'
	say 'I hope you''ll consider registering even if I didn''t get this'
	say 'little thing quite right.'
	say f.white'By the way: This will use ReqTools or rexxarplib.library'
	say 'if one of them is available. Otherwise, a far less friendly'
	say 'window is opened for the file request.'
	say '                  '  f.black'Thanks.'
	options prompt f.lf||f.blue||f.nc'   Press <'f.white||f.bold'Enter'f.norm||f.blue'>'f.norm
	pull .

	exit 5

WordWrap: procedure
	parse arg Line, Length, Heading, Tab, File
	DivPos = lastpos(' ', Line' ', Length) + 1
	call writeln(File, Heading || left(Line, DivPos))
	do while DivPos <= length(Line)
		EndPos = lastpos(' ',Line' ', DivPos + Length+1)
		call writeln(File, copies(' ', Tab) || substr(Line, DivPos, EndPos-DivPos))
		DivPos = EndPos + 1
	end

return

/*
 * It would be more efficient to set the values directly by
 * a series of assignments. It's both faster and more complex
 * but this provides an example of how in-line data can be read
 * from the program code.
 */

SetPrompts: procedure expose RegType. Prompt.

	Prompt. = ''
	PNum = 0
	do i = GetLine() by 2
		PNum = PNum + 1
		parse value sourceline(i) with Prompt.PNum
		if Prompt.PNum = '*/' then leave
		parse value sourceline(i+1) with ICode Text
		if ICode = 'Int' then
			interpret 'Prompt.PNum.6Prompt = 'Text
		else
			Prompt.PNum.6Prompt = Text
	end
	return PNum-1

	/* See the note to the function SOURCELINE() for an explanation of **
	** this technique for copying data from the script                 */
SendLine:
	return SIGL + 2
GetLine:
	signal SendLine
/*
Name
.   Enter your full name.
Street Address
.   Include suite/apartment number
City
.   Enter your city only.
State/Province
.   Enter the 2-char. code
Zip/Postal Code

Country
.   Enter your country
Network address
.   Enter E-mail address and name of network
Model number
.   Examples: 500, or 1200, or 2000HD
Chip memory
.   Examples: 500K, 1M, 2M, 3M
Fast memory
.   Examples: 0K, 1M, 8M
Hard drive size
.   Examples: 0M, 40M, 120M, 240M
time using ARexx
Int '0a'x'   The following questions concern your level'||'0a'x'   of ARexx expertise.'
your skill level
.   Examples: Expert, Beginner, Novice
programs used with ARexx
Int '0a'x'Include the names of any programs for'||'0a'x'which you will use ARexx to write macros.'
comments about the guide
Int '   Continue typing past the end of line.'||'0a'x'   Text will be wrapped afterwards.'
*/

GetFile:	procedure expose f.	/* make formatting codes global for syntax: */
		/* If rexxarplib isn't available, this will call syntax:, which **
		** will ask for a file less politely                            */
	if checklib('rexxreqtools.library',0,-30,37)
		then return rtfilerequest(,,'Save registration form',,'rtfi_flags=freqf_patgad')
	else if checklib('rexxarplib.library',0,-30,0)
		then return 'GetFile'(60,20,,,'Save registration form as:',,PATGAD,,,300)
	else do
		if open(6FWin, 'con:0/8/400/77/ARxxxGuide registration/SCREEN *', W) then do
			call writeln(6FWin, f.blue'Sorry. We couldn''t open a file requester.')
			call writeln(6FWin, f.white'Please enter full path of file.'||'0a'x)
			call writech(6FWin, f.black'File: ')
			FileN = readln(6FWin)
			call close 6FWin
			return FileN
		end
		else
			return ''
	end

CheckLib: procedure   /* delete 'procedure' for external function       */
	parse arg LibName, Priority, Offset, Version .
	CheckLib = 1
	if LibName = '' then return 0    /* Must include a library name */
	signal on syntax

	if ~show('L', LibName) then do  /* Is the library already on the list? */
	      /* Set defaults for ADDLIB() */
	   if Priority = '' then Priority = 0
	   if Offset = '' then Offset = -30
	   if Version = '' then Version = 0
	      /* The return from the function doesn't matter, so use  CALL     */
	   call addlib(LibName, Priority, Offset, Version)
	end

	call FooBarian()
	return 1

syntax:
   if CheckLib = 1 then do
      CheckLib = 0
      if rc = 14 then do
         call remlib(LibName)
         return 0
      end
      else
         return 1    /* Function not found, but library was loaded     */
   end
   /* else do standard syntax checking                                 */
