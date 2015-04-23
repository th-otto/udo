/* ARx_GlossaryPort.rexx v1.1a  (02 Apr 1994)                              **
** Because the setup time to read all the compounds is rather slow, this  **
** reads them all just the first time that ARx_Glossary.rexx is called.   **
** It then sets up a port to present requesters on later calls.           **
** 	To shut down the port: "address 'ARX_REQPORT' 'QUIT'"               */

arg LkUp AGPort .
if open(6HereWin, 'raw:10/50/360/48/Arx_GlossaryPort.rexx/NOCLOSE/SCREEN *') then do
   call writech(6HereWin,'9b302070'x'Setting up glossary port for ARexxGuide.'||'0a'x'Please wait...')
end

call addlib('rexxsupport.library',1,-30,0)
	/* If it's added as a function host, this lib can cause severe probs   */
call remlib('amigaguide.library')
	/* Want this one added at a high priority                              */
call remlib('rexxreqtools.library')
call addlib('rexxreqtools.library',32,-30,0)

if find(getenv('arexxguide/Setup'), 'REQPORT') = 0 then
	if 'ARx_Setup.rexx'('REQPORT') ~= 0 then call BadSetup

PortName = 'ARX_REQPORT'
	/* It's possible to get here twice when clicking too quickly */
if show('P', 'ARX_REQPORT') then exit 10
call SetGlossaryVars

call close 6HereWin

	/* Show requester the first time this is called */
if glossary.LkUp > '' then call ShowReq(LkUp)
call setclip('ARX_SHOWREQ', 0)

/* This will hang around to put up subsequent requesters                 */

OPort = openport(PortName)
   /* Loop until a Cmd -- QUIT --  changes the value of [Status] */
do until Status = 'CLOSE'
		/* Wierdness: waitpkt() won't wait if setclip() is within the loop. Odd.   */
   call waitpkt(PortName)
   Packet = getpkt(PortName)
      /* Make sure we have a real message in [Packet] */
   if Packet ~= null() then do
      Cmd = getarg(Packet)
		select
			when abbrev(Cmd, 'DISPLAY') then do
				if words(Cmd) >= 3 then AGport = word(Cmd, 3)
			   	/* Was AG closed when we weren't looking? */
		   	if ~show('P', AGport) then do
					call rtezRequest('The port' AGport 'is no longer available',,'ARexxGuide')
		   		Status = 'CLOSE'
		   	end
		   	else
					call showReq word(Cmd, 2)
			end
			when abbrev('QUIT', upper(Cmd)) then
				Status = 'CLOSE'
			otherwise
		end
      call reply(Packet, 0)
   end
end
call closeport OPort

call setclip('ARX_SHOWREQ')
address command 'SETENV ARexxGuide/RqVer 1'
exit 0

ShowReq:
	arg LkUp
	if glossary.LkUp > '' then do
			/* Show the requester                                             */
		resp = rtezrequest(glossary.LkUp,glossary.LkUp.Buttons,'Glossary:' LkUp,tags)
			/* Is there a command associated with this response?              */
		if glossary.LkUp.resp > '' then do
				/* Issue the command */
			address value AGport
			''glossary.LkUp.resp
			address
		end
	end
	return resp

GetEnv: procedure
		/* Use rexxarplib or RexxDosSupport if available, but this script**
		** does not add them to the list                                 */
   if show('L', 'RexxDosSupport.library') then
   	return GetVar(arg(1))
   else if show('L', 'rexxarplib.library') then
      return 'GetEnv'(arg(1))

      /*  OPEN()  will fail if variable is not defined. Null will be    **
      ** returned in that case                                          */
   else if open(6Env, 'env:'arg(1), 'R') then do
      EnvVar = readln(6Env)
      call close 6Env
   end
   else EnvVar = ''
   return EnvVar

syntax:
   if rc = 14 then do
   	ErrMsg = 'Library not found for a function in this line SIGL:\strip(sourceline(SIGL),,'09'x)'
   	if pos('rtez', sourceline(SIGL) then
   		ErrMsg = ErrMsg'\Make sure version 37.50 or higher of\rexxreqtools.library is in your libs:\directory.'
      call PutErrMsg(SIGL, ErrMsg)
      exit 10
   end
	else do
		call PutErrMsg(SIGL, '+++ Error' rc 'in line' SIGL':' errortext(rc))
		exit 10
	end

BadSetup:
	call PutErrMsg(SIGL, 'A problem occurred in the setup script, but\we''ll attempt to continue...')

PutErrMsg:
   call trace b
   ErrMsg ='Sorry an enexpected error has occurred in line' arg(1)'.\\'arg(2)

   signal off syntax
   signal off halt
   signal off break_c
   WinHi = 59 + CountChar('\', ErrMsg) * 11
   if open(6ErrWin, 'raw:0/0/640/'WinHi'/Arx_GlossaryPort.rexx error/SCREEN *') then do
      call writeln(6ErrWin, translate(ErrMsg,'0a'x, '\'))
      call writech(6ErrWin, '0a'x'        -- Press any key -- ')
      call readch(6ErrWin)
   end
   call close 6ErrWin
	return 0

CountChar:
   return length(arg(2)) - length(compress(arg(2), arg(1)))

SetGlossaryVars:
	/* call trace off */
NL = '0a'x
if find(getenv('ARexxGuide/Setup'), 'REQPORT') = 0 then
	call 'ARx_Setup.rexx'('REQPORT')
tags = ''
if getenv('ARexxGuide/ReqFont') > '' then
	tags  = 'rt_font='getenv('ARexxGuide/ReqFont')
if getenv('ARexxGuide/PubScr') > '' then
	tags  = tags 'rt_pubscrname='getenv('ARexxGuide/PubScr')
		/* [AGport] won't be expanded until the 'interpret' that shows the node */
glossary. = ''

glossary.Address_string =,
'A four-character (4-byte) string that represents a'NL ||,
'machine address. The character string will be'NL ||,
'meaningless in itself, but can be translated to'NL ||,
'meaningful form with the c2d() or c2x() functions.'
glossary.Address_string.Buttons = '_Ok|Node: c2_D()|Node: c2_X()|Node: _Address functions|_Cancel'
glossary.Address_string.2 = 'link ARx_Func2.ag/c2d()'
glossary.Address_string.3 = 'link ARx_Func2.ag/c2x()'
glossary.Address_string.4 = 'link ARx_Func4.ag/memlist'

glossary.Assignment =,
'A process that gives (assigns) a value of some kind'NL ||,
'to a variable. An assignment clause takes this form:'NL || NL ||,
'               <symbol> = <expression>;'NL || NL ||,
'The <symbol> -- a variable --  becomes a placeholder'NL ||,
'for the value of <expression>.'NL || NL ||,
'There are also other, less common, ways that an'NL ||,
'assignment can be made, notably the PARSE and'NL ||,
'DO instructions.'
glossary.Assignment.Buttons = '_Ok|Node: _Assignment|_Cancel'
glossary.Assignment.2 = 'link ARx_Elements3.ag/ASSIGNMENT'

glossary.Boolean =,
'Either true or false, which -- in ARexx -- is'NL ||,
'considered to be 1 for true and 0 for false. Named'NL ||,
'after the mathematician George Boole.'
glossary.Boolean.Buttons = '_Ok|Node: con_Ditionals|_Cancel'
glossary.Boolean.2 = 'link ARx_Elements3.ag/Conditional'


glossary.Clause =,
'A collection of tokens forming a program statement'NL ||,
'that can be executed by ARexx, usually contained on a'NL ||,
'single line. A clause is the smallest language unit'NL ||,
'that can be executed as a statement.'
glossary.Clause.Buttons = '_Ok|Node: _Clause|_Cancel'
glossary.Clause.2 = 'link ARx_Elements3.ag/Clause'

glossary.Command =,
'A program statement (a clause) that is sent to an'NL ||,
'external environment (the host) to be run. The host'NL ||,
'determines the syntax and other requirements for a'NL ||,
'command. Although it is often overlooked, commands'NL ||,
'should be enclosed in quotation marks.'
glossary.Command.Buttons = '_Ok|Node: co_Mmand|Node: Command _String|Node: _Host|_Cancel'
glossary.Command.2 = 'link ARx_Elements3.ag/Command'
glossary.Command.3 = 'link ARx_Elements3.ag/CmdString'
glossary.Command.4 = 'link ARx_Elements3.ag/Host'

glossary.CON =,
'Or: Console Window. A logical_device that opens a'NL ||,
'text window on the Workbench or other public screen.'NL ||,
'This device can be used as the <filename> with the'NL ||,
'file I/O functions to direct output to a window'NL ||,
'opened by the script.'
glossary.CON.Buttons = '_Ok|Node: _Special I/O|_Cancel'
glossary.CON.2 = 'link ARx_Func3.ag/otherio'

glossary.Concatenate =,
'To combine one part with another to form a new whole.'NL ||,
'When two strings are concatenated, they are joined'NL ||,
'together to form a new string.'NL || NL ||,
'A space between two expressions acts as a concaten-'NL ||,
'ation operator in ARexx as do the characters `||''.'
glossary.Concatenate.Buttons = '_Ok|Node: Concatenation _Operators|Node: _Strings|_Cancel'
glossary.Concatenate.2 = 'link ARx_Operator.ag/CONCATENATION'
glossary.Concatenate.3 = 'link ARx_Elements2.ag/STRINGEXPR'


glossary.Constant =,
'In ARexx, a symbol that cannot be used as the target'NL ||,
'of a variable assignment. The most common constants'NL ||,
'in ARexx are numbers.'
glossary.Constant.Buttons = '_Ok|Node: cons_Tant|Node: _Number|_Cancel'
glossary.Constant.2 = 'link ARx_Elements.ag/Constant'
glossary.Constant.3 = 'link ARx_Elements2.ag/Number'

glossary.Continuation_Token =,
'When a comma `,'' is used as the last significant'NL ||,
'token in a line, it indicates that the current line'NL ||,
'should be combined with the next line to form a'NL ||,
'single clause. Comments and other null values may be'NL ||,
'included after the continuation token.'
glossary.Continuation_Token.Buttons = '_Ok|Node: Co_Mma|Node: _Token|_Cancel'
glossary.Continuation_Token.2 = 'link ARx_Elements.ag/Comma'
glossary.Continuation_Token.3 = 'link ARx_Elements.ag/Token'

glossary.Control_Structure =,
'A programming construct that allows a series of'NL ||,
'statements to be executed as part of a block. The'NL ||,
'instructions DO, SELECT, and IF create control'NL ||,
'structures in ARexx.'
glossary.Control_Structure.Buttons = '_Ok|Node: _DO|Node: _SELECT|Node: _IF|_Cancel'
glossary.Control_Structure.2 = 'link ARx_Instr.ag/DO'
glossary.Control_Structure.3 = 'link ARx_Instr3.ag/SELECT'
glossary.Control_Structure.4 = 'link ARx_Instr.ag/IF'

glossary.Debug =,
'To search for and eliminate (eventually) problems or'NL ||,
'bugs in a program. The TRACE instruction aids'NL ||,
'debugging in ARexx.'
glossary.Debug.Buttons = '_Ok|Node: _Trace|_Cancel'
glossary.Debug.2 = 'link ARx_Instr3.ag/Trace'

glossary.Dyadic =,
'Having two parts. In ARexx, the term refers to'NL ||,
'operations that have two operands (2 + 2, for'NL ||,
'instance). Some operations have only one operator'NL ||,
'(-1, for instance) and are referred to here as'NL ||,
'prefix operations. The more technical name for the'NL ||,
'opposite of a dyadic operation is unary operation.'
glossary.Dyadic.Buttons = '_Ok|Node: _Operators|_Cancel'
glossary.Dyadic.2 = 'link ARx_Operator.ag/MAIN'

glossary.Egregious =,
'It means "very bad," but use of this word shows that'NL ||,
'the writer has spent too much time in the company of'NL ||,
'lawyers. (Which may be the same thing, come to think'NL ||,
'of it.)'
glossary.Egregious.Buttons = '_OK'

glossary.Exponential_Notation = ,
'A way of writing a number in which one value -- the'NL ||,
'exponent -- is a power of ten by which the other'NL ||,
'value will be multiplied before use.'NL || NL ||,
'In ARexx, an `e'' in a number indicates exponential'NL ||,
'notation. 7.34e6 is the same number as 7340000.'
glossary.Exponential_Notation.Buttons = '_Ok|Node: _Numbers|_Cancel'
glossary.Exponential_Notation.2 = 'link ARx_Elements2.ag/NUMBER'

glossary.Expression =,
'One or more tokens that can be evaluated to produce a'NL ||,
'single value. An expression can be anything from a'NL ||,
'single number to a mixture of numbers, strings,'NL ||,
'variables, sub-expressions, and function calls.'
glossary.Expression.Buttons = '_Ok|Node: _Expression|_Cancel'
glossary.Expression.2 = 'link ARx_Elements2.ag/Expression'

glossary.Function =,
'A subprogram that returns a single value to the'NL ||,
'calling environment. A function might be defined in'NL ||,
'any of several ways. Some are a built-in feature of'NL ||,
'the language, some are available in external'NL ||,
'libraries, and some are written by the user either as'NL ||,
'a subroutine in the executing script or as an'NL ||,
'external program.'
glossary.Function.Buttons = '_Ok|Node: _Function|_Cancel'
glossary.Function.2 = 'link ARx_Elements3.ag/Function'

glossary.GUI =,
'Graphic User Interface. It''s the acronym used to refer to'NL ||,
'things like windows, icons, mouse pointers, menus,'NL ||,
'and requesters that are common on the current'NL ||,
'generations of computer systems.'
glossary.GUI.Buttons = '_Ok|Node: _GUI function libs|_Cancel'
glossary.GUI.2 = 'link ARx_Elements3.ag/LIBFUNC 13'

glossary.Host =,
'A program that can accept and act on commands issued'NL ||,
'from an ARexx script. The ADDRESS instruction is used'NL ||,
'to set up communication with a host.'
glossary.Host.Buttons = '_Ok|Node: _Address|Node: _Host|_Cancel'
glossary.Host.2 = 'link ARx_Instr.ag/Address'
glossary.Host.3 = 'link ARx_Elements3.ag/Host'

glossary.Instruction =,
'The basic program statement in ARexx scripts. An'NL ||,
'instruction may include several clauses, but always'NL ||,
'begins with a REXX keyword which must be the first'NL ||,
'token in the initial clause.'NL || NL ||,
'Instructions include IF, CALL, DO and similar'NL ||,
'statements.'
glossary.Instruction.Buttons = '_Ok|Node: _Instruction|Node: _Reference|_Cancel'
glossary.Instruction.2 = 'link ARx_Elements3.ag/Instruction'
glossary.Instruction.3 = 'link ARx_Instr.ag/MAIN'

glossary.Interpreter =,
'A program that translates source code (the program'NL ||,
'lines you write) into machine instructions. It does'NL ||,
'that each time the script is run. RexxMast is the'NL ||,
'ARexx interpreter program.'
glossary.Interpreter.Buttons = '_Ok|Node: _RexxMast|_Cancel'
glossary.Interpreter.2 = 'link ARx_Cmd.ag/REXXMAST'

glossary.IO =,
'Input/Output. The term refers to the various ways of'NL ||,
'obtaining data and displaying or saving it. The I/O'NL ||,
'system on the Amiga includes disk drives, windows,'NL ||,
'and requesters.'
glossary.IO.Buttons = '_Ok|Node: _File I/O|_Cancel'
glossary.IO.2 = 'link ARx_Func3.ag/iofunc'

glossary.Iteration =,
'A program-ese synonym for 'repetition'. To a human'NL ||,
'the instruction to "Do forever" would be a Sisyphean'NL ||,
'punishment. To a computer, it is just another task.'NL ||,
'In ARexx, iteration is performed by a single'NL ||,
'instruction, DO, which has a wide range of options'NL ||,
'to give the programmer control over when the'NL ||,
'iteration stops.'
glossary.Iteration.Buttons = '_Ok|Node: _DO|_Cancel'
glossary.Iteration.2 = 'link ARx_Instr.ag/DO'

glossary.Keyword =,
'The word that identifies an ARexx instruction or the'NL ||,
'option to an instruction. Keywords and instructions'NL ||,
'are detailed in the Instruction reference.'
glossary.Keyword.Buttons = '_Ok|Node: _Instruction reference|_Cancel'
glossary.Keyword.2 = 'link ARx_Instr.ag/MAIN'

glossary.Logical_Device =,
'A part of the computer system defined through'NL ||,
'software. In AmigaDOS, logical devices intervene'NL ||,
'between the application program (including ARexx) and'NL ||,
'such hardware devices as disk drives, printers, and'NL ||,
'the monitor screen.'
glossary.Logical_Device.Buttons = '_Ok|Node: _File I/O|_Cancel'
glossary.Logical_Device.2 = 'link ARx_Func3.ag/iofunc'

glossary.Loop =,
'A section of program code that is repeated (or'NL ||,
'iterated). Looping in ARexx is controlled by the DO'NL ||,
'instruction.'
glossary.Loop.Buttons = '_Ok|Node: _DO|_Cancel'
glossary.Loop.2 = 'link ARx_Instr.ag/DO'

glossary.Mantra =,
'In Hinduism, a sacred formula, repeated over and over'NL ||,
'again, that is believed to posses special power.'NL ||,
'(Looking up this word demonstrates one of two things:'NL ||,
'either the user wasn''t around for the 60''s or wasn''t'NL ||,
'paying attention. <insert smiley chars> )'
glossary.Mantra.Buttons = '_Ok'

glossary.Nested =,
'To place one thing within another just as an egg is'NL ||,
'placed in a bird''s nest. A nested function is one'NL ||,
'function used as an argument to another function as'NL ||,
'in RIGHT(TRUNC(Amount, 2), 6). Here the TRUNC()'NL ||,
'function, which truncates the decimal points on a'NL ||,
'number, is nested within the RIGHT() function, which'NL ||,
'right-justifies the resulting number.'
glossary.Nested.Buttons = '_Ok| Node: _Function ref.|Node: _Parentheses|_Cancel'
glossary.Nested.2 = 'link ARx_Func.ag/MAIN'
glossary.Nested.3 = 'link ARx_Operator.ag/PARENPRIORITY'

glossary.NIL =,
'A logical device recognized by AmigaDOS that will'NL ||,
'throw away input or output directed to it.'
glossary.NIL.Buttons = '_Ok|Node: _Special I/O|_Cancel'
glossary.NIL.2 = 'link ARx_Func3.ag/otherio'

glossary.Number =,
'A string or symbol made up only of digits (0 - 9)'NL ||,
'with an optional decimal point `.'' that may be'NL ||,
'placed anywhere within the string -- at the'NL ||,
'beginning, at the end, or anywhere in between.'NL || NL ||,
'Another option allows for exponential notation'NL ||,
'when the letter `e'' is included within the string:'NL ||,
'The number to the right of the `e'' is interpreted'NL ||,
'as the exponent to the value on the left.'
glossary.Number.Buttons = '_Ok|Node: _Number|Node: _Symbol|_Cancel'
glossary.Number.2 = 'link ARx_Elements2.ag/Number'
glossary.Number.3 = 'link ARx_Elements.ag/Symbol'

glossary.Operation =,
'An expression that includes an operator and (usually)'NL ||,
'two terms that are combined in a way specified by the'NL ||,
'operator to produce a new single value. `3+5'' is an'NL ||,
'arithmetic operation. 'NL || NL ||,
'Some operators (like negation) act on a single term'
glossary.Operation.Buttons = '_Ok|Node: o_Perators|Node: _Expressions|_Cancel'
glossary.Operation.2 = 'link arx_Operator.ag/MAIN'
glossary.Operation.3 = 'link ARx_Elements2.ag/Expression'

glossary.Operator =,
'Any of a variety of tokens that represent an'NL ||,
'operation that is to be performed on the adjoining'NL ||,
'expression(s). Operators include these characters'NL ||,
'(sometimes used in combination):'NL || NL ||,
'                + - * / % | & = ~ > <'NL || NL ||,
'A space between two strings is also an operator.'
glossary.Operator.Buttons = '_Ok|Node: o_Perator reference|_Cancel'
glossary.Operator.2 = 'link arx_Operator.ag/MAIN'

glossary.Preferences =,
'A series of programs that are part of the Amiga OS.'NL ||,
'They allow the user to customize most aspects of the'NL ||,
'system.'
glossary.Preferences.Buttons = '_Ok'

glossary.Prototyping =,
'The process of developing an initial version of a'NL ||,
'software application in one language to test the'NL ||,
'logic of the code and the usefulness of contemplated'NL ||,
'options.'
glossary.Prototyping.Buttons = '_Ok'

glossary.PRT =,
'A logical device recognized by AmigaDOS that directs'NL ||,
'output to the printer defined in Preferences. This'NL ||,
'device can be used as the <filename> with the file'NL ||,
'I/O functions to print data from an ARexx script.'
glossary.PRT.Buttons = '_Ok|Node: _Special I/O|_Cancel'
glossary.PRT.2 = 'link ARx_Func3.ag/otherio'

glossary.Reserved =,
'A token that serves a specialized purpose in the'NL ||,
'language and cannot be used for any other purpose.'NL || NL ||,
'REXX has a limited set of reserved tokens: The single'NL ||,
'characters representing operators and special 'NL ||,
'characters are reserved in all situations.'NL ||,
'Instruction keywords and sub-keywords are reserved'NL ||,
'only within the limited range of the instruction'NL ||,
'itself. The variables [x] and [b] -- although they'NL ||,
'are not technically reserved -- should be avoided'NL ||,
'because of possible conflicts with hex and binary'NL ||,
'strings.'
glossary.Reserved.Buttons = '_Ok|Node: _Tokens|_Cancel'
glossary.Reserved.2 = 'link ARx_Elements.ag/Token'

glossary.STDERR =,
'Standard error device. This is the logical name'NL ||,
'assigned to a device to which ARexx will send error'NL ||,
'messages and the output of tracing. If the trace'NL ||,
'console is open, that will become STDERR. The PARSE'NL ||,
'EXTERNAL instruction retrieves input from this device.'
glossary.STDERR.Buttons = '_Ok|Node: _Standard I/O|_Cancel'
glossary.STDERR.2 = 'link ARx_Func3.ag/stdio'

glossary.STDIN =,
'Standard input device. This is the logical name'NL ||,
'assigned to a device from which ARexx will retrieve'NL ||,
'input then the PARSE PULL instruction is used. It'NL ||,
'is usually the shell from which a program was'NL ||,
'launched, although a script started from another'NL ||,
'environment will often have STDIN assigned to NIL:.'
glossary.STDIN.Buttons = '_Ok| Node: _Standard I/O|Node: _Parse|_Cancel'
glossary.STDIN.2 = 'link ARx_Func3.ag/stdio'
glossary.STDIN.3 = 'link ARx_Instr2.ag/Parse'

glossary.STDOUT =,
'Standard output device. This is the logical name of'NL ||,
'the device to which ARexx will output the expression'NL ||,
'used in a SAY instruction. It is usually the shell'NL ||,
'from which a program was launched, although a script'NL ||,
'started from another environment will often have'NL ||,
'STDOUT assigned to NIL:.'
glossary.STDOUT.Buttons = '_Ok|Node: _Standard I/O|_Cancel'
glossary.STDOUT.2 = 'link ARx_Func3.ag/stdio'

glossary.String =,
'A character or group of characters that are stored'NL ||,
'and referenced as a unit. A `literal string'' or'NL ||,
'`string token'' is surrounded by quotation marks --'NL ||,
'either single { '' } or double { " }, but the word'NL ||,
'`string'' may also refer to the value of a variable,'NL ||,
'or the result of an expression.'|| NL || NL ||,
'A string can comprise up to 65535 characters.'
glossary.String.Buttons = '_Ok|Node: _String|_Cancel'
glossary.String.2 = 'link ARx_Elements2.ag/StringExpr'

glossary.Subroutine =,
'A section of code separated from the main body of a'NL ||,
'program. In ARexx, subroutines are identified by'NL ||,
'labels and usually serve as internal functions.'
glossary.Subroutine.Buttons = '_Ok| Node: _Label|Node: _Internal function|_Cancel'
glossary.Subroutine.2 = 'link ARx_Elements3.ag/Label'
glossary.Subroutine.3 = 'link ARx_Elements3.ag/ProgFunc'

glossary.Symbol =,
'A token made up of any of the following alphabetic'NL ||,
'characters, digits, or special characters:'NL || NL ||,
'    A to Z  a to z  0 to 9  . ! $ _ @ #'NL || NL ||,
'The following are symbols: Names for variables or'NL ||,
'functions, numbers, and instruction keywords. A'NL ||,
'symbol may be entered in a mixture of upper- and'NL ||,
'lowercase alphabetic characters, but all symbols are'NL ||,
'translated to uppercase during evaluation.'NL || NL,
'Symbols can have up to 65535 characters.'
glossary.Symbol.Buttons = '_Ok|Node: _Symbol|_Cancel'
glossary.Symbol.2 = 'link ARx_Elements.ag/Symbol'

glossary.Token =,
'The simplest (smallest) item in the language, from'NL ||,
'which more complex elements are formed. A token might'NL ||,
'be a single character like `+'' or `/'', a number, or a'NL ||,
'word like `FOO'' or `CALL''.'
glossary.Token.Buttons = '_Ok|Node: _Token|_Cancel'
glossary.Token.2 = 'link ARx_Elements.ag/Token'

glossary.TRL2 =,
'A common abbreviation for the book that defines the'NL ||,
'standard for the language: The REXX Programming'NL ||,
'Language: A Practical Approach to Programming, Second'NL ||,
'Edition, by M.F. Cowlishaw.'
glossary.TRL2.Buttons = '_Ok|Node: _References|_Cancel'
glossary.TRL2.2 = 'link ARx_Intro.ag/REF'

glossary.Truncate =,
'To shorten by chopping off the trailing end. If a'NL ||,
'decimal number like 1.9 is truncated to one digit, it'NL ||,
'would become 1, rather than the number 2 that would'NL ||,
'result from rounding the number.'
glossary.Truncate.Buttons = '_Ok'

glossary.Variable =,
'A symbol that becomes a placeholder for another value'NL ||,
'and can, in most cases, be used in place of the'NL ||,
'literal value it represents. A variable name follows'NL ||,
'general symbol-naming rules.'
glossary.Variable.Buttons = '_Ok|Node: _Variable |Node: _Symbol|_Cancel'
glossary.Variable.2 = 'link ARx_Elements2.ag/Variable'
glossary.Variable.3 = 'link ARx_Elements.ag/symbol'

return 0