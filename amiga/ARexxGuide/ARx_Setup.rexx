/* ARx_Setup.rexx version 1.2  (05 Apr 1994)                          **
** Called by help key, launch program, and requester port to set up   **
** env: variables and other information needed for utility progs.     */

   /* CallProg  := (LAUNCH|HELP|REQPORT) : code for calling script    **
   ** SetWhat   := what values should be set? (not used now)          **
   ** Envir     := used by help keys. Address of the calling script   */

/* Special thanks to John A. Conant for fixes to the OS 3.x parts,    **
** and to Steve Plegge and Doug Tittle for pointing out some of the   **
** many problems with the initial version.                            */

options results
arg CallProg ., SetWhat, Envir

signal on syntax

	/* The AG library doesn't seem to set a proper return code for ARexx **
	** and has been known to cause crashes on some systems, so...        */
call remlib('amigaguide.library')

if open(6HereWin, 'raw:14/60/360/48/Arx_Setup.rexx/NOCLOSE/SCREEN *') then do
   call writech(6HereWin,'9b302070'x'Getting setup information for ARexxGuide.'||'0a'x'Please answer a few questions.')
end

   /* Default sets everything at once                                 */
if CallProg = '' then CallProg = 'GEN'

if CallProg = 'GEN' then
	AddBackLibs = RemUnknownLib()
else
	AddBackLibs = ''

if ~checklib('rexxsupport.library',0,-30) then signal NOSUPPORT

MultiRq. = 0
call makedir('env:ARexxGuide')

	/* Used to determine if .rexx scripts should be copied.            */
parse source . . . SetupPath
	SetupPath = strip(ParseFileName(SetupPath, P),b)
if pos('Ram Disk:', SetupPath) = 1 then
 	SetupPath = delstr(SetupPath, 4 ,5)

csi='9b'x;k!.slant=csi'3m';k!.bold=csi'1m';k!.norm=csi'0m';k!.black=csi'31m';k!.white=csi'32m';k!.blue=csi'33m'


   /* Function returns either 1 if rexxarplib is available or    **
   ** 0 if it isn't. [RArp] and [ReqT] can be used later as the  **
   ** condition in IF statements.                                */
DReq = 0
if CheckLib('rexxreqtools.library',32) then do
	/* addlib() won't let us check for the decimal on a version   **
	** so this assures us that 37.50 is the minimum version used. */
	RqLibVer = LibVer('rexxreqtools.library')
	if RqLibVer >= 37.50 then
		ReqT = 1
   else do
   	ReqT = 0
   	call remlib('rexxreqtools.library')
   	if RqLibVer > -1 then
	   	SetReqWarn = 1 /* After we know more about system, we'll warn folks */
   end
end
else ReqT = 0

   /* Use requester commands if they are available.              */
if ~ReqT then
   if exists('c:requestchoice') then do
         /* Copy under new name so we can delete them later without  **
         ** deleting a copy that user might have put into t:         */
      address command 'copy c:requestchoice t:rqchoice'
      address command 'copy c:requestfile t:rqfile'
      DReq = 1
   end

if CheckLib('rexxarplib.library') then do
      /* Set a default position */
   if getclip('RASLpos') = '' then
      call setclip('RASLpos', '20 50 354 300 #?')
   RArp = 1
end
else RArp = 0

	/* Tell user we've removed rexxreqtools.library */
if SetReqWarn = 1 then do
	call InfoReq('ARexxGuide utilities', 'A minimum version of 37.50 is required\by ARexxGuide for rexxreqtools.library.\\The version on your system will not\be used.','OK')
end

call pragma('w', Null)
GoodAGPath = 0
CurAGPath = GetEnv('amigaguide/path')
do i = 1 to words(CurAGPath)
	if exists(AddPathPart(word(CurAGPath,i), 'ARexxGuide.guide')) then do
		GoodAGPath = 1
		leave
	end
end
call pragma('w')
if ~GoodAGPath then do CheckPath = 1
   call InfoReq('Choose ARexxGuide directory.','Pick the directory where ARexxGuide\files were stored.','OK')
	if pos('REXX', upper(SetupPath)) = 0 then
		ARxPath = SetupPath
	else
		ArxPath = pragma('d')
	if pos('Ram Disk:', ArxPath) = 1 then
	 	ArxPath = delstr(ArxPath, 4 ,5)
   ArxPath = strip(FileInfoReq(ARxPath,,'Choose ARexxGuide directory.',1),'T', '/')
   if ~exists(AddPathPart(ARxPath, 'ARexxGuide.guide')) | ARxPath = '' then do
      if InfoReq('Problem with chosen path.','Sorry.\The file ARexxGuide.guide can''t be found\in' ARxPath'.\\It is one of the files in archive.\Try again?', 'BOOL') then
         iterate
      else
      	signal NOARXPATH
   end
   if find(upper(CurAGPath), upper(ARxPath)) = 0 then do
	   call makedir('env:AmigaGuide')
	   call setenv('AmigaGuide/path', strip(CurAGPath ARxPath, l))
	end
	break /* because this is in a loop */
end

if find('LAUNCH HELP GEN', CallProg) > 0 then do
   /* Set the command to be used to show AG files               */
   AGCmd = getenv('ARexxGuide/AGCmd')
      /* Check for file only when this var is not already set   */
   if AGCmd > '' then do
      AGDir = ParseFileName(AGCmd, 'P')
      AGProg = ParseFileName(AGCmd)
   end
   else do
      call pragma('w', null)     /* Turn off volume requesters */
      if exists('SYS:Utilities') then
         AGDir = 'SYS:Utilities'
      else
         AGDir = ''
      if exists('SYS:Utilities/AmigaGuide') then
         AGProg = 'AmigaGuide'
      else
         AGProg = 'Multiview'
      call pragma('W')           /* Turn requesters on again   */
   end

   if (~exists(AGCmd) | AGCmd = '') then do
      call InfoReq('Choose AmigaGuide utility', 'The program needs information about\the location of your AmigaGuide utility.\Please choose the program you use\to view AmigaGuide files.', 'OK')
   	CheckARxCmd = 1
   end
   else if abbrev(CallProg, 'GEN') then
      if InfoReq('ARexxGuide help system','Would you like to change setting of\command variable?\\Current:\  'AGCmd, 'BOOL') then
			CheckARxCmd = 1

	if CheckARxCmd = 1 then do
            /* We have a default value, now ask for the real thing   */
      AGCmd = FileInfoReq(AGDir, AGProg, 'Choose AmigaGuide utility')
      if AGCmd = '' then
         signal NOARXPATH
      else
         call setenv('ARexxGuide/AGCmd', AGCmd)
   end


   if find('LAUNCH GEN', CallProg) > 0 then do
         /* Launch prog. uses rexxarplib to open & control a pub screen */
      if RArp then
         if InfoReq('ARexxGuide public screen','Do you want ARexxGuide to open on\its own public screen?', 'BOOL') then
            PubScr = 'ARX_GUIDE'
         else
            PubScr = 'WORKBENCH'
      else PubScr = 'WORKBENCH'
      call setenv('ARexxGuide/PubScr', PubScr)
   end
   if find('HELP GEN', CallProg) > 0 then do
   		/* Get paths for help key */
      if InfoReq('Choose cross-ref files','Pick OK to add cross-ref files\from other guides to be loaded\with the help system.\\You will be able to choose from\multiple directories.\Pick from initial dir now.\\Directories will be added to\env:AmigaGuide/path.', 'CANCEL') then do
			CurAGPath = GetEnv('amigaguide/path')
         XRfiles = getenv('ARexxGuide/XRFiles')
         XCount = 1
         XAddMore = 1   /* Default for first time through */
         do until XAddMore = 0
            /* Open a display console for current choices.  */
            if XRFiles > '' then do
               if ~show('F', 'XRdisplay') then
                  call open('XRdisplay', 'con:180/0/220/300/XRef files chosen:','R')
                     /* Check again in case it didn't open       */
               if show('F', 'XRdisplay') then
                  do i = XCount to words(XRfiles)
                     call writeln('XRdisplay', ParseFileName(word(XRFiles, i)))
                  end
               XAddMore = InfoReq('Cross-ref files','Add files from other directories?','BOOL')
               XCount = i
            end
            if XAddMore then do
               call FileInfoReq(ParseFileName(value('MultiRq.'MultiRq.0),'P'),,'Choose cross-ref files.',,1)
              	if MultiRq.0 > 0 then
              		XPath = ParseFileName(MultiRq.1, P)
              	else
              		XPath = ''
               do CheckX = 1 to MultiRq.0
               		/* Make sure it's not repeated */
                 	Xfile = ParseFileName(MultiRq.CheckX)
                  if find(XRFiles, Xfile) = 0 then do
                  		/* is it missing the .xref extension */
                  	if pos('.XREF', upper(Xfile)) = 0 then do
                  		if exists(MultiRq.CheckX'.xref') then
                  			Xfile = Xfile'.xref'
                  		else if open(6CheckX, MultiRq.CheckX, R) then do
                  		 	if ~abbrev(upper(readch(6CheckX, 12)), 'XREF:') then
                  		 		iterate CheckX
                  		 end
                  	end
                     XRfiles = XRfiles Xfile
                  end
               end
                	/* Drop out if no files were chosen in the requester */
			   	if MultiRq.0 = 0 then
				   	XAddMore =  0
						/* Add dir to path if it isn't there already */
					else if find(upper(CurAGpath), upper(Xpath)) = 0 then do
						SetAGpath = 1
						CurAGpath = CurAGpath Xpath
					end
            end
 		   end
		   call setenv('AmigaGuide/path', CurAGpath)
			call setenv('ARexxGuide/XRFiles', XRfiles)
      end
		call close 'XRdisplay'
			/* Should the fullhelp window be displayed? */
      if Rarp then do
      	if InfoReq('ARexxGuide help system','Would you like to see a window with\information about the current clause\when help system doesn''t find a\match for chosen word?', 'BOOL') then
				call setenv( 'ARexxGuide/ShowFullHelp', 1)
			else
				call setenv( 'ARexxGuide/ShowFullHelp', 0)
		end
   end
end

if find('REQPORT GEN', CallProg) > 0 & ReqT then do
	if CallProg = 'GEN' then
		call setenv('ARexxGuide/RqVer', 0)
	if CallProg = 'GEN' then
		if ~InfoReq('ARexxGuide help system','Are you using the RQ (Requester) version?', 'BOOL') then
			break /* Don't want to do the rest of this stuff */
		else
			call setenv('ARexxGuide/RqVer', 1)
   CurFont = getenv('arexxguide/reqfont')
   if pos('/', CurFont) > 0 then do
   	if InfoReq('Glossary requesters', 'Do you wish to change the font\used with reqesters?\\Current:' CurFont,'BOOL') then
   		FontReq = 1
   end
  	else if InfoReq('Glossary requesters', 'Do you wish to specify a font\to be used with the glossary\requesters?','BOOL') then
  		FontReq = 1

   if FontReq = 1 then do
      RqFont. = ''
      call rtfontrequest('Choose font for requesters', ,,RqFont)
      if RqFont.name > '' then
         call setenv( 'ARexxGuide/ReqFont', RqFont.name'/'RqFont.height)
   end
   		/* Ask about public screen only if it wasn't set in the LAUNCH part */
	if symbol('PUBSCR') ~== 'VAR' then
	   if InfoReq('Glossary requesters','Do you display ARexxGuide on\a public screen other than\Workbench?','BOOL') then do
   		PubScr = getenv('ARexxGuide/PubScr')
	      if PubScr = '' then PubScr = 'ARX_GUIDE'
		   PubScr = rtgetstring('ARX_GUIDE', translate('What is the public screen name.\(Press OK to accept default name.)','0a'x,'\'),'Glossary requesters')
   		if PubScr > '' then
   		   call setenv( 'ARexxGuide/PubScr', PubScr)
   	end
end

	/* Copy .rexx scripts to REXX: if they're in the guide directory */
if find(upper(translate(SetupPath,' ','/:')), 'REXX') = 0 then do
	if InfoReq('Copy .rexx files', 'Do you want .rexx scripts for ARexxGuide\to be copied to REXX: directory?', 'BOOL') then do
		address command
		'copy >nil:' AddPathPart(SetupPath, '#?.(rexx|ed|TTX|edge)') 'REXX:' clone
		if rc = 0 then do
			'copy >nil:' AddPathPart(SetupPath, 'ARx_Setup.rexx.info') 't:'
			'delete >nil:' AddPathPart(SetupPath, '#?.rexx(%|.info)')
			'copy >nil: t:ARx_Setup.rexx.info' '"'SetupPath'"'
			call delete('t:ARx_Setup.rexx.info')
		end
		address
	end
end

   /* Record that this session has already been run  */
if CallProg = 'GEN' then
   call setenv('ARexxGuide/Setup', 'HELP LAUNCH REQPORT')
      /* Don't put multiple copies of name into env: var */
else if find(getenv('ARexxGuide/Setup'), Callprog) = 0 then
   call setenv( 'ARexxGuide/Setup', getenv('ARexxGuide/Setup') CallProg)

if InfoReq('Help system setup', 'Would you like to save this information\to disk so it will be available\permanently?', 'BOOL') then do
   address command 'copy >nil: env:ARexxGuide/#? envarc:ARexxGuide'
	if SetAGPath = 1 then
      address command 'copy >nil: env:AmigaGuide envarc:AmigaGuide all'
end

   /* get rid of copies of command that we might have put in t: */
call delete 't:RqChoice'; call delete 't:RqFile'
if AddBackLibs > '' then call ReturnLibs()

return 0

   /* This uses rexxarplib's GETENV() if it's here */
GetEnv: procedure expose RArp

   EnvVar = ''
   if RArp then
      EnvVar = 'GetEnv'(arg(1))
   else if open(6Env, 'env:'arg(1), R) then do
      EnvVar = readln(6Env)
      call close 6Env
   end
   return EnvVar

SetEnv: procedure expose RArp

   if RArp then
      EnvVar = 'SetEnv'(arg(1), arg(2))

   if arg(2, 'E') then do
      if open(6Env, 'env:'arg(1), 'W') then do
         Success = (writech(6Env, arg(2)) > 0)
         call close 6Env
      end
      else
         Success = 0
      return Success
   end
   else                    /* Var is deleted if there's no value to set */
      return delete('env:'arg(1))

InfoReq: procedure expose RArp ReqT DReq Envir k!.
   /* Puts up a Yes/No requester. Returns a Boolean                    **
   **    Arguments:                                                    **
   **       arg(1)  := title of requester                              **
   **       arg(2)  := body text                                       **
   **       arg(3)  := {OK | BOOL | CANCEL} -- type of requester       */

   select
      when ReqT then do
         Buttons = word('_Ok _Yes|_No _Ok|_Cancel', find('OK BOOL CANCEL', arg(3)))
         return rtezrequest(translate(arg(2), '0a'x, '\'), Buttons, arg(1))
      end
      when DReq then do
         Buttons = word('Ok Yes|No Ok|Cancel', find('OK BOOL CANCEL', arg(3)))
            /* Add line-feed code if necessary */
         BText = arg(2)
         LfPos = pos('\', BText)
         do while LfPos > 0
            BText = insert('N',overlay('*',BText,LfPos),LfPos)
            LfPos = pos('\', BText)
         end
         address command 't:RqChoice >env:RqPick' '"'arg(1)'"' '"'BText'"' '"'Buttons'"'
            /* Get the response unless it's a simple OK */
         RqPick = 0
         if arg(3) ~= 'OK' then
         	return (getenv('RqPick') = 1)
      end
      when RArp then do
         Buttons. = ''
         select
            when arg(3) = 'OK' then
               return (request(word(getclip('RASLpos'),1),word(getclip('RASLpos'),2),arg(2),,' Ok ') = 'OKAY')
            when arg(3) = 'BOOL' then
               return (request(word(getclip('RASLpos'),1),word(getclip('RASLpos'),2),arg(2),,' Yes ',' No ') = 'OKAY')
            otherwise
               return (request(word(getclip('RASLpos'),1),word(getclip('RASLpos'),2),arg(2),,' Ok ', ' Cancel ') = 'OKAY')
         end
      end
      otherwise
         /* Open a raw: window to display information            */
         depth = 68 + (11 * (countchar('\', arg(2))+3))
         select
            when arg(3) = 'OK' then
               RspMsg = '0a'x '   <'k!.white'Press any key'k!.black'>'
            when arg(3) = 'BOOL' then
               RspMsg = '0a'x '   <'k!.white'Enter'k!.black'> or <'k!.white'Y'k!.black'> = "Yes"'|| '0a'x '   <'k!.white'Esc'k!.black'>   or <'k!.white'N'k!.black'> = "No"' || '0a'x '   <'k!.blue'Press a key'k!.black'>'
            otherwise
               RspMsg = '0a'x '   <'k!.white'Enter'k!.black'> or <'k!.white'Y'k!.black'> = "Ok"' || '0a'x '   <'k!.white'Esc'k!.black'>   or <'k!.white'N'k!.black'> = "Cancel"' || '0a'x '   <'k!.blue'Press a key<'k!.black'>'
         end
         if open(6Info, 'raw:10/20/346/'Depth'/'arg(1), w) then do
            call writeln(6Info, translate(arg(2), '0a'x, '\'))
            call writech(6Info, '0a'x || RspMsg)
            resp = (verify(upper(readch(6Info)), '0d594f'x) = 0)
            call close 6Info
            return resp
         end
         else
            return -1
   end
   return -1

FileInfoReq: procedure Expose RArp ReqT DReq Envir MultiRq. k!.
   /* Puts up a file requester using the following choices:
         1. RexxReqTools
         2. RexxArpLib
         3. ADos 3.0 requester commands (I hope)
         3. An ugly console window
   */

   parse arg /* InfoMsg,*/ DefDir, DefProg, Title, DirOnly, Multi
   MultiRq. = 0
   /* if InfoMsg > '' then call InfoReq(Title,InfoMsg,'OK') */
   if DefDir = ''then do
      parse value pragma('d') with DefDir ':'
      DefDir = DefDir':'
   end
   select
      when ReqT then do
         if DirOnly = 1 then flags = 'RTFI_Flags=FREQF_NoFiles'
         else flags = 'RTFI_Flags=FREQF_PatGad'
         if Multi = 1 then flags = flags'|FREQF_MultiSelect'
         ChFile = rtfilerequest(DefDir,DefProg, Title,,Flags,MultiRq)
         MultiRq.0 = MultiRq.count  /* Switch to the standard counter */
      end
      when DReq then do
         Opts = 'DRAWER "'DefDir'"'
         if DefProg > '' then
            Opts = Opts 'FILE "'File'"'
         Opts = Opts 'Title "'Title'"'
         if DirOnly = 1 then
            Opts = Opts 'DRAWERSONLY'
         if Multi = 1 then
            Opts = Opts 'MULTISELECT'
         address command 't:RqFile >env:FlPick' Opts
         if rc = 0 then do
         	ChFile = GetEnv('FlPick')
            if Multi = 1 then do
               do i = 1 while ChFile > ''
                  parse var ChFile '"' MultiRq.i '"' ChFile
               end
               MultiRq.0 = i
            end
            else
               ChFile = strip(ChFile, B, '"')
         end
         else
            ChFile = -10
         call delete('env:FlPick')
      end

      when RArp then do
         if DirOnly = 1 then flags = 'NOFILES'
         else flags = 'PATGAD'
         if Multi = 1 then flags = flags'|MULTISELECT'
         call GetFile(word(getclip('RASLpos'),1),word(getclip('RASLpos'),2),DefDir,DefProg,Title,,Flags,MultiRq,word(getclip('RASLpos'),3),word(getclip('RASLpos'),4),word(getclip('RASLpos'),5))
            /* lib is returning everything in the compound variable */
         if Multi ~= 1 then
            ChFile = MultiRq.1
            /* Record current position */
         call setclip('RASLpos', MultiRq.LeftEdge MultiRq.TopEdge MultiRq.Width MultiRq.Height MultiRq.Pattern)
      end
     /*  when Envir > '' & show('P', Envir) then do
         address value Envir
         if abbrev(Envir, 'TURBO') then do
            'RequestFile PROMPT "'Title'" PATH' AddPathPart(DefDir, DefProg)
            if rc = 0 then
               ChFile = result
            else
               ChFile = ''
         end
         else if abbrev(Envir, 'EDGE') then do
            if DirOnly = 1 then Flags = 'DIR'
            else Flags = ''
            RqCmd = 'requestfile TITLE "'Title'" PATH' DefDir 'FILE' DefProg
            if DirOnly = 1 then RqCmd = RqCmd 'GETDIR'
            if Multi = 1 then RqCmd = RqCmd 'MULTISELECT'
            address value Envir
            ""RqCmd
            if Multi ~= 1 then
               ChFile = result
            else do
               if pos('(', result) > 0 then do
                  parse value ' 'result with CommonPath '(' MultiFiles ')'
               end
               else do
                  MultiFiles = result
                  CommonPath = ''
               end
               do i = 1 until MultiFiles = ''
                  parse var MultiFiles MultiRq.i '|'
                  MultiRq.i = strip(AddPathPart(CommonPath, MultiRq.i))
               end
               MultiRq = i
            end

            address              /* toggle back to whereever we were */
         end
      end  */
      otherwise
         call close STDOUT
         if open(STDOUT, 'con:10/98/366/94/File name choice','R') then do
            call close STDIN
            call open(STDIN, '*', R)
            /* pragma('*') is redundant on 2.0+ and WShell, but... */
            /*call pragma('*', STDIN); call pragma('*', STDOUT)*/
         end
            /* if that didn't work we'll try for the best with the standard **
            ** window defined in the icon (if that was used)                */
         do forever  /* Break after checking for existence of file at end */
            say k!.white||Title
            say ''
            say k!.blue'Please enter complete path of file'k!.black
            options prompt k!.black'File?' k!.white'::: 'k!.black
            parse pull ChFile
            if ~exists(ChFile) | ChFile = '' then do
               say ChFile 'is not a valid file name'
               say k!.blue'Try again?'
               options prompt k!.white'(y/n) ::: 'k!.black
               pull resp
               if abbrev(resp, 'Y') then iterate
            end
            /* If Multi is set, then return is expected in the compound */
            if Multi = 1 then do
               MultiRq.0 = MultiRq.0 + 1
               interpret 'MultiRq.'MultiRq.0 '=' 'ChFile'
               say k!.blue'Add another file?'
               options prompt k!.white'(y/n) ::: 'k!.black
               pull resp
               if abbrev(resp, 'Y') then iterate
      	   end
         	break
         end
       /* Works better not to close the window we've opened as STDOUT */
   end
   if ~exists(ChFile) then return -1
   else return ChFile

AddPathPart: procedure
   /* Add a filename to a path to make one spec.           */
   /* A function that does this is available in rexxextend.library   */

   if verify(right(arg(1),1), '/:','m') = 0 then
      FName = strip(arg(1)'/'arg(2),b,' "')
   else
      FName = strip(arg(1)arg(2),b,' "')
   if pos('Ram Disk:', FName) = 1 then
   	FName = delstr(FName, 4 ,5)
   if pos(' ', FName) > 0 then
   	return '"'FName'"'
   else
   	return FName


CountChar:
   return length(arg(2)) - length(compress(arg(2), arg(1)))

ParseFileName: procedure
   /* Arguments:                                                     **
   ** FilePath   := Any valid AmigaDOS file specification            **
   ** Part       := [Optional] 'F', 'FILE', or omit to get filename  **
   **                          Anything else to retrieve the path    */
   /* A function that does this is available in rexxextend.library   */
   call trace b
   parse arg FilePath, Part

   DivPos = max(lastpos(':', FilePath),lastpos('/', FilePath)) +1
   if abbrev('FILE', upper(Part))
      then return substr(FilePath, DivPos)
   else
      return strip(left(FilePath, DivPos-1),'T', '/')

RemUnknownLib: procedure
	AddBackLibs = ''
		/* remove library names not used to avoid problems    */
	KnownLib = 'rexxsupport.library rexxarplib.library rexxreqtools.library RexxDosSupport.library REXX QuickSortPort'
		/* A few libs that we know don't belong on the list */
	BadLib = 'rexxsyslib.library reqtools.library arp.library'
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

LibVer: procedure
   parse arg libname
   if right(libname,8) ~= '.library' then
      libname = libname'.library'
   if ~showlist('L', libname) then
      return -1
   else do
		LibAddress = showlist('L',libname,,'a')
		call forbid    /* probibit multitasking during read       */
		libver = import(offset(LibAddress,20),4)
		call permit
   end
   return c2d(left(libver,2))'.'c2d(libver,2)

CheckLib: procedure
	call trace b
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

Syntax:
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
		call PutErrMsg(SIGL, '+++ Error' rc 'in line' SIGL':' errortext(rc))
		exit 0
	end

   /* more to come */
NoSupport:
	call PutErrMsg(SIGL, 'rexxsupport.library could not be loaded.\Make sure the library is in your libs:\directory.')
	exit 0

PutErrMsg:
   call trace b
   ErrMsg ='Sorry an enexpected error has occurred in line' arg(1)'.\\'arg(2)

   signal off syntax
   signal off halt
   signal off break_c
   WinHi = 59 + CountChar('\', ErrMsg) * 11
   if open(6ErrWin, 'raw:0/0/640/'WinHi'/Arx_Setup.rexx error/SCREEN *') then do
      call writeln(6ErrWin, translate(ErrMsg,'0a'x, '\'))
      call writech(6ErrWin, '0a'x'        -- Press any key -- ')
      call readch(6ErrWin)
   end
	if symbol('ADDBACKLIBS') = 'VAR' & AddBackLibs > '' then
		call ReturnLibs(AddBackLibs)
	return 0

NoAGuide:
NoARxPath:
	if symbol('ADDBACKLIBS') = 'VAR' & AddBackLibs > '' then
		call ReturnLibs(AddBackLibs)
   exit 2
