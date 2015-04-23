/** $VER: ARX_Help.rexx 1.0 (06 Oct 1993)
 ** by Robin Evans (based on getxref.ttx by David N. Junod)
 **
 ** Display the ARexxGuide page for the word on command line.
 **
 ** This can be used as a shell help-key macro with WShell.
 ** Add the following (or something similar) to Config-FComp:
 **
 ** KEY 95 QUAL 8 NAME "CTRL-HELP"     FMT "*E[61]arx_help *N"
 **
 **  With this definition, a word can be typed on the shell. When
 **  Ctrl-Help is pressed, the ARexxGuide node for that word will
 **  be displayed.
 **
 ** Functions are (usually) recognized without the '()'
 **
 ** You may want to add the following lines to your S:user-startup file.
 **
 **   RXLIB amigaguide.library 0 -30
 **
 ** Be careful with that library, however. I've found that it interferes
 ** in some cases with rexxarplib.library. If that happens, it can be
 ** removed with this shell command:
 **
 **   RX "remlib('amigaguide.library')
 **
 **  THE AMIGAGUIDE/PATH ENVIRONMENTAL VARIABLE MUST INCLUDE THE DIRECTORY
 **  WHERE ARx_Guide.xref IS LOCATED.
 **/

signal on syntax
signal on break_c
signal on halt
signal on failure


arg LkUp

	if ~show('L','amigaguide.library') then
		call addlib('amigaguide.library',-2,-30,0)
   if ~show('L','rexxsupport.library') then
	   call addlib('rexxsupport.library',0,-30,0)

	XrefFile = 'ARx_Guide.xref'
	if getxref('STATEF()') = 10 then
		call loadxref(XrefFile)

	if open(.GtEnv, 'env:arexxguide/agcmd', R) then do
		AGCmd = readln(.GtEnv)
		call close .GtEnv
	end
	else
	signal NoCmd
	if abbrev(AGCmd, 'Multi') then
	   PrtOpt = ''
	else
	   PrtOpt = 'portname ARX_GUIDE'

	if LkUp = '' then do
		File = 'Arx_Index'
		LkUp = 'ARx_NdxCont'
	end
	else do
		File = ''
		if getxref(LkUp) = 10 then do
			if getxref(LkUp'()') ~= 10 then
				LkUp = LkUp'()'
		end
		if getxref(LkUp) = 10 then do
			say 'Can''t find ARexxGuide reference to' LkUp'.'
			options prompt 'View index? (y/N) '
			pull resp
			if abbrev(resp, 'Y') then do
				File = 'Arx_Index'
				LkUp = 'MAIN'
			end
			else exit 5
		end
	end
   Cmd = ''

      /* See if our AG window is open */
   if ~show('P','ARX_GUIDE') then do
      if Cmd = '' then
         Cmd = 'run' AGCmd File 'document' LkUp PrtOpt 'requester'

      address command cmd
	end
   else do

         /* What command do we use to show the node */
	   LinkCmd = "Link"
		if File > '' then
			LkUp = File'/'LkUp
	   address ARX_GUIDE LinkCmd LkUp
	   address ARX_GUIDE 'unzoomwindow'
	   address ARX_GUIDE 'windowtofront'
	end

exit 0

XRefError:
	ErrLine = SIGL
	ErrMsg.0 = 5
	ErrMsg.2 = 'Unable to load the cross-reference file ARx_Guide.xref'
	if ~exists('env:amigaguide/path') then
		ErrMsg.3 = 'Your environmental variable "amigaguide/path" is not set.'
	else
		ErrMsg.3 = '   Be sure to include that file''s directory in env:amigaguide/path.'
	ErrMsg.4 = '   The .xref file may be put into the current directory or into'
	ErrMsg.5 = '   any directory included in the amigaguide/path environmental variable.'
	signal PutErrMsg
NoCmd:
	ErrLine = SIGL
	ErrMsg.0 = 4
	ErrMsg.2 = 'Can''t read environmental variable "env:arexxguide/AGcmd".'
	ErrMsg.3 = '   That variable must hold the name of the command you use'
	ErrMsg.4 = '   to show AmigaGuide files.'
	signal PutErrMsg
Syntax:
	ErrLine = SIGL
	ErrMsg.0 = 2
	ErrMsg.2 = '   Syntax error #'rc ':' errortext(rc)
	Signal PutErrMsg
Failure:
	ErrMsg.0 = 2
	ErrMsg.2 = '   Command "'sourceline(SIGL)'" failed.'
	ErrLine = SIGL
	Signal PutErrMsg
Halt:
Break_C:
	ErrMsg.0 = 2
	ErrMsg.2 = '   Execution halted.'
	ErrLine = SIGL
PutErrMsg:
	call trace b
	ErrMsg.1 ='Sorry an enexpected error has occured in line' ErrLine'.'

	signal off syntax
	signal off halt
	signal off break_c
	WinHi = 48 + ErrMsg.0 * 11
	'SetStatusBar ARx_Help.ttx error.'
	if open(.ErrWin, 'con:0/0/640/'WinHi'/Arx_Help Error/CLOSE') then do
		do i = 1 to ErrMsg.0
			call writeln(.ErrWin, ErrMsg.i)
		end
		call writech(.ErrWin, '0a'x'               Press <Enter>')
		call readln(.ErrWin)
	end
exit 0
