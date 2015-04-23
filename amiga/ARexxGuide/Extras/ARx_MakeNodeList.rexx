/* ARx_MakeNodeList.rexx 	Version 2.0	(02 Mar 1994)
**
**		Make an AmigaGuide .xref cross-reference file for all files matching
**    a supplied pattern.
**
**    NOTE TO WShell USERS: Pasted to the bottom of this script is a version
**    that does the same thing but with _far_ more efficiency. It uses WShell's
**    ExecIO utility, though, so those who haven't yet bought WShell can't
**    use it. Moral: If you're going to use ARexx, buy WShell.
*/

parse arg FPat
if FPat = '' | FPat = '?' then do
	options prompt 'PATTERN/A: '
	parse pull FPat
end
if FPat = '' then exit 0

FList = 't:ARx_NFiles'		/* Used for list of files to be processed */
NList = 't:ARx_NodeList'   /* Used for the actual node list          */
File. = ''

NPath = ParseFileName(FPat, 'P')
if NPath > '' then
	OrgPath = pragma('D', NPath)

if verify(FPat, '#?~!()*', 'M') = 0 then do
	File.0 = 1
	File.1 = FPat
end
else do		/* We have a pattern. Use list to expand it */
	address command
	'list quick nohead' FPat 'to' FList
	if exists(FList) & word(statef(FList),2) > 0 then do
		if open(6FList, FList, R) then do
			call delete FList
			do i = 1 until eof(6FList)
				File.i = readln(6FList)
			end
			call close 6FList
			File.0 = i - 1		/* Last value is always blank */
		end
	end
	else signal NoFile
end

	/* We have a list of files, so look for '@node' within each file */

NodeList = '01010101010a'x	/* Dummy pattern is replaced after sort with 'XREF:' */
NodeNum = 0						/* Count extra compound used for long lists     */
do i = 1 to File.0
	say '   Creating node list for file' File.i
	FNOnly = ParseFileName(File.i)
	PrgMsg = '      Reading file ...'
	if open(6Input, File.i, 'R') then do until eof(6Input)
		call writech(STDOUT, PrgMsg)
			/* Read the whole file at once -- or as much of it as we can get. **
			** Concatenate FText in case previous read broke it in the middle **
			** of node reference.                                             */
		FText = FText || upper(readch(6Input, 65532-length(FText)))
			/* Look for '@NODE' in the file variable                          */
		do until pos('@NODE', FText) = 0
			parse var FText . '@NODE ' NName FText
					/* If the node name is quoted, check for multiple words     */
			if pos('"', NName) then do
				parse var FText NName2 '"' FText
				NName = '"'NName || NName2'"'
			end
				/* Cut off name from other line if there's nothing else on line */
			parse var NName NName '0a'x .
			if NName ~= 'MAIN' & NName > '' then
				NodeList = NodeList || left(NName, 18) '"'FNOnly'" 0 0' || '0a'x
				/* Split the list if it's getting too big */
			if i < File.0 & length(NodeList) >= 64000 then do
				/* The var [NodeList] is different than the stem [NodeList.]   */
				NodeNum = NodeNum + 1
				NodeList.NodeNum = NodeList
				NodeList = ''
			end
		end
		PrgMsg = '..'
			/* There's a small chance that a _very_ long node would leave so  **
			** so much in [FText] that we'd never get out of the node. This   **
			** prevents that by chopping off text that doesn't include the    **
			** start of an AG label of some kind.                             */
		if pos('0a'x||'@', FText) = 0 then FText = ''
		else FText = substr(FText,pos('0a'x||'@', FText))
	end
	else say 'Can''t open file' File.i
	call close 6Input
	say ''
end

if length(NodeList) > 10 | NodeNum > 0 then do
	if open(6Output, NList'.pre', 'W') then do
		say 'Sorting node list'
		do i = 1 to NodeNum
			call writech(6Output, NodeList.i)
		end
		call writech(6Output, Nodelist)
		call close 6Output
	end
	else
	signal NoOutput

	'sort from' NList'.pre to' NList
	if rc = 0 then do
		call delete NList'.pre'
		if open(6List, NList, 'R') then do
			call writech(6List, 'XREF:')
			call seek(6List, 0, 'E')
			call writeln(6List, '#')
			call close 6List
		end
	end
	say 'Cross-ref file for' FPat 'created.'
	say '   Saved to file' NList
end


exit 0

NoFile:
	say 'No files match the pattern "'FPat'".'
	exit 5

NoOutput:
	say 'Can''t open file' NList' for output.'
	exit 5

ParseFileName: procedure
   /* Arguments:                                                     **
   ** FilePath   := Any valid AmigaDOS file specification            **
   ** Part       := [Optional] 'F', 'FILE', or omit to get filename  **
   **                          Anything else to retrieve the path    */
   parse arg FilePath, Part

   DivPos = max(lastpos(':', FilePath),lastpos('/', FilePath)) +1
   if abbrev('FILE', upper(Part))
      then return substr(FilePath, DivPos)
   else
      return strip(left(FilePath, DivPos-1),'T', '/')

/* ARx_MakeNodeList.rexx 	Version 1.3	(21 Aug 93)
**
**		Make an AmigaGuide .xref cross-reference file for all files matching
**    a supplied pattern.
**
**    Uses WShell ExecIO utility.
*/


nodeFN = 't:NodeList'
parse arg FilePat
if FilePat = '' then
	FilePat = '(arexxguide.guide|arx#?.ag)'

NPath = ParseFileName(FPat, 'P')
if NPath > '' then
	OrgPath = pragma('D', NPath)

'list quick nohead' FilePat 'lformat "execio read %s stem Nodes. locate *"@node*" colend 5" | execio stem FileCmd.'
call open(NodeFile, NodeFN ,w)
call writeln(NodeFile, '!!!!'||'0a'x)
do i = 1 to FileCmd.0
	File = word(FileCmd.i, 3)
	say '   Reading file' File
	select
		when pos('FUNC', upper(File)) > 0 then Type = '0 1'
		when pos('INSTR', upper(File)) > 0 then Type = '0 2'
		otherwise Type = '0 0'
	end
	FileCmd.i	/* this is a command to AmigaDOS */
	do j = 1 to Nodes.0
		node = word(Nodes.j, 2)
		if upper(node) ~= 'MAIN' & ~abbrev(upper(node), 'ABOUT') then
			call writeln(NodeFile, left(Node, 24) '"'File'"' Type)
	end
end

call close NodeFile
call delete(NodeFN'.sort')
address command 'sort' nodeFN nodeFN'.sort'
if open(NodeStart, NodeFN'.sort', R) then do
	call writech(NodeStart, 'XREF:')
	NewPos = seek(NodeStart,0,E)
	call writeln(NodeStart, '#')
	call close NodeStart
end

	/*** Include the ParseFileName() function            ***/