/* $VER: 2.0a ARexxGuide.rexx (10 Apr 1994) by Robin Evans

		Launch ARexxGuide. Will optionally opens a public screen with
		rexxarplib, and load in the requester port if that version is used.

		It also closes down after AmigaGuide is closed and any of the ports
		that might have been opened by ARexxGuide. It removes amigaguide.library
		from memory since some versions that library can interfere with other
		ARexx function libraries.

		Initial setup is done with the file ARx_Setup.rexx. That file
		is required to get started and required if the Env:ARexxGuide vars.
		are deleted. Otherwise it isn't needed.

*/
/* call trace 'b'*/
signal ON ERROR
signal ON FAILURE
signal on syntax

if ~show('P', 'ARX_GUIDE') then do

		/* It will mess up CheckLib if it's on the list */
	call remlib('amigaguide.library')
	AddBackLibs = RemUnknownLib()
	if ~checklib('rexxsupport.library',0,-30,0) then signal NoSpt
		/* add it back at a higher priority */
	call remlib('rexxreqtools.library')
	ReqT = CheckLib('rexxreqtools.library',32)
   Rarp = CheckLib('rexxarplib.library')

		/* Run setup if it hasn't been done yet */
	if find(getenv('arexxguide/setup'), 'LAUNCH') = 0 then
		call 'ARx_Setup.rexx'('LAUNCH')

		/* Get command used to show AmigaGuide                     */
	AGCmd = getenv('ARexxGuide/AGCmd')
	if AGCmd = '' then  signal NOCMD

	if abbrev(AGCmd, 'Multi') then
		PrtOpt = ''
	else
		PrtOpt = 'portname ARX_GUIDE'

		/* If this is the requester version, then load the requester port **
		** now so it will be available when first used.                   */
	if ReqT & getenv('ARexxguide/RqVer') = 1 then
			/* Give it a fake lookup word, just so the port will open      */
		address AREXX '"ARx_GlossaryPort.rexx ''foo'' ''ARX_GUIDE''"'

			/* Open a pubscreen if requested */
	ARxScr = ''  		   /* pub screen option not used by default */
	PScr = getenv('arexxguide/PubScr')
	if PScr = '' then PScr = 'WORKBENCH'
		/* This uses rexxarplib to open a public screen. Other utilities **
		** could be substituted. Even under 2.0+, rexxarplib works best  **
		** if screenshare.library is available. I haven't yet been able  **
		** to get apig.library to open a public screen. If anyone knows  **
		** how to do that, tell me, and I'll add apig.library as the     **
		** first choice.                                                 */
	if RArp then do
		if ~((PScr = "") | (PScr = 'WORKBENCH')) then do
			ArxScr = 'pubscreen' PScr
			call setclip('ARxScreen', PScr)
			if ScreenToFront(word(ARxScr,2)) = 0 then
				if ~OpenScreen((ScreenRows()-400) ,, 'HIRES|LACE', 'ARexxGuide', PScr,,640 ,400 ,(ScreenCols()-640)%2 ) then do
					ARxScr = ''
					call setclip('ARxScreen', PScr)
				end
		end
	end

	if AddBackLibs > '' then call ReturnLibs(AddBackLibs)

			/* This loads AmigaGuide (or Multiview) and then waits   */
	address command AGCmd 'ARexxGuide.guide' PrtOpt ARxScr

			/* AG was closed so shut down everything we've set up    */
	if PScr ~= 'WORKBENCH' then do
		call CloseScreen(PScr)
		call setclip('ARxScreen')
	end
		/* Turn off the requester port when AG is closed.            */
	if show('P', 'ARX_REQPORT') then
		address 'ARX_REQPORT' 'QUIT'

		/* Don't need amigaguide.library for this, so remove it from **
		** ARexx list (but probably not from mem.)                   */
	if show('l', 'amigaguide.library') then do
		call expungexref()
		call remlib('amigaguide.library')
	end
end
else do
	/* This brings the window, or screen to the front if the guide  **
	** was already loaded.                                          */
	address ARX_GUIDE
	if getclip('ARxScreen') > '' then
		call ScreenToFront(getclip('ARxScreen'))
	'windowtofront'
	'ActivateWindow'
end

exit 0

NOCMD:
ERROR:
FAILURE:
	call PutErrMsg(SIGL,'Couldn''t run AmigaGuide viewer. Check env:ARexxGuide/AGCmd\or run the setup program again by typing\   rx ARx_Setup\from a shell.')
	if show('L', 'amigaguide.library') then do
		call expungexref()
		call remlib('amigaguide.library')
	end
	exit 0


	/* This uses rexxarplib's GETENV() if it's here */
GetEnv: procedure	expose RArp

	EnvVar = ''
	if RArp = 1 then
		EnvVar = 'GetEnv'(arg(1))
	else if open(6Env, 'env:'arg(1), R) then do
		EnvVar = readln(6Env)
		call close 6Env
	end
	return EnvVar


CountChar:
   return length(arg(2)) - length(compress(arg(2), arg(1)))

RemUnknownLib: procedure
	AddBackLibs = ''
	/* remove unknown library names from the list to avoid problems    **
	** I'm not familiar with all the libs included here, so I won't    **
	** guarantee that they set a proper return code, but they are at   **
	** least documented in the ARexx Applications list.                */
	KnownLib = 'rexxsupport.library rexxarplib.library rexxreqtools.library apig.library rexxextend.library RexxDosSupport.library rxgen.library rx_intui.library rexxmathlib.library rexxserdev.library GDArexxSupport.library rexxflow.library rexxarray.library xferq.library QuickSortPort REXX'
		/* A few libs that we know don't belong on the list */
	BadLib = 'rexxsyslib.library reqtools.library arp.library rexxapp.library'
	CurLibs = show('l')
	do i = 1 to words(CurLibs)
		TLib = word(CurLibs,i)
		if find(KnownLib, TLib) = 0 then do
			call remlib(TLib)
			if find(BadLib,TLib) = 0 then
				AddBackLibs = AddBackLibs TLib
		end
	end
	return AddBackLibs

ReturnLibs:
	do i = 1 to words(AddBackLibs)
		if pos('.library', word(AddBackLibs,i)) > 0 then
			call addlib(word(AddBackLibs, i), 0, -30, 0)
		else
			call addlib(word(AddBackLibs, i),-i-32)
	end
	AddBackLibs = ''	/* Changes the variable in calling environment */
	return 0


CheckLib: procedure
	call trace(b)
	CheckLib = 1
	parse arg LibName, Priority, Offset, Version

	if LibName = '' then return 0    /* Must include a library name */
	signal on syntax


	if ~show('L', LibName) then do  /* Is the library already on the list? */
	      /* Set defaults for ADDLIB() */
	   if Priority = '' then Priority = 0
	   if Offset = '' then Offset = -30
	   if Version = '' then Version = 0
	      /* The return from the function doesn't matter, so use CALL¤¤    */
	   call addlib(LibName, Priority, Offset, Version)
	end

	   /* This call to a non-existent (I hope) function will force all     **
	   ** libraries to be loaded. It will generate a syntax error (#15)    **
	   ** but that will be trapped by the SIGNAL¤¤ instruction             */
	call FooBarian()

	   /* Unlikely we'd make it this far, but maybe someone will use       **
	   ** 'FooBarian' as a function name.                                  */
	return 1

syntax:
	signal off syntax
	if CheckLib = 1 then do		/* Use default Checklib() didn't call it */
	      /* This subroutine will be called on any syntax error. The call  **
	      ** to FooBarian() above is almost guaranteed to generate an      **
	      ** error. We're interested in the type of error. #14 means that  **
	      ** the library we tried to load isn't available. #15 is OK. It   **
	      ** means "Function not found" and we expect that.                */
	   if rc = 14 then do
	      call remlib(LibName)
	      return 0
	   end
	   else
	      return 1    /* Function not found, but library was loaded        */
	end
	else do
		call PutErrMsg(SIGL,'+++ Error' rc 'in line' SIGL':' errortext(rc))
		exit 0
	end

NoSpt:
	call PutErrMsg(SIGL, 'rexxsupport.library could not be loaded.\Make sure the library is in your libs:\directory.')
	exit 0

PutErrMsg:
   call trace b
   ErrMsg ='Sorry an enexpected error has occurred in line' arg(1)'.\\'arg(2)
   signal off syntax
   signal off halt
   signal off break_c
   WinHi = 59 + CountChar('\', ErrMsg) * 11
   if open(6ErrWin, 'raw:0/0/640/'WinHi'/ARexxGuide.rexx error/SCREEN *') then do
      call writeln(6ErrWin, translate(ErrMsg,'0a'x, '\'))
      call writech(6ErrWin, '0a'x'        -- Press any key -- ')
      call readch(6ErrWin)
   end
	call close 6ErrWin
  	if symbol('ADDBACKLIBS') = 'VAR' & AddBackLibs > '' then
		call ReturnLibs(AddBackLibs)
	return 0
