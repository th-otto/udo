/*	$VER: 1.0 ARx_Cmpr.rexx by Robin Evans (31 May 1993) */

/*	Demonstrate the effect of different comparison operations */

arg close

csi='9b'x;slant=csi'3m';bold=csi'1m';norm=csi'0m';black=csi'31m';white=csi'32m';blue=csi'33m'
LF = '0a'x
options prompt white':::' black

say white'This demonstration allows you to enter a pair a values'
say 'to see how they fare in various comparison tests.'
say 'The file that runs the demo is called "ARx_Cmpr.rexx"'
say 'and is located in your rexx: directory.'
say 'Type'black 'Q' white || 'at any "::: " prompt to exit the application' '0a0a'x || norm

do forever
	say LF||white'Enter two values to be compared.'
	say blue'   Enclose a value that includes a space in double { " } quotes'
	parse pull v
	parse var v '"' val.1 '"' '"' val.2 '"' , '"' . '"' val.3 ., val.4 val.5 .
	trace off

	vari. = ''
	vn = 0
	do i = 1 to 5 until vn = 1
		if val.i > '' then do
			vn = vari.0 > ''
			vari.vn = val.i
		end
	end
	if vn < 1 then do
		if upper(vari.0) = 'Q' then leave
		say lf||black'You must enter two values to be compared.'
		say '   Enter <Q> to leave the demonstration.'
		iterate
	end
		/*
			the expression below uses a series of comparison operations to arrive
			at a number which indicates whether the string are equal, >, or <.
			The same operation could have been performed with a select instruction.
			That would even be easier to decipher. This method is offered just
			'because it was there'.
		*/
	numeric digits 14
	Cmprsn = (vari.0 = vari.1) + (vari.0 == vari.1) * 2 + (vari.0 > vari.1) * 4,
			 + (vari.0 < vari.1) * 8
	numeric digits

	Cmpr.1 = 'is equal to'
	Cmpr.3 = 'is exactly equal to'
	Cmpr.4 = 'is greater than'
	Cmpr.8 = 'is less than'

	say ''
	Say '"'vari.0'"' Cmpr.Cmprsn '"'vari.1'"'
	say ''

	select
		when Cmprsn = 1 then do
			say "Leading and trailing spaces are ignored in normal"
			say "comparison operations, but not when the strict comparison"
			say "operators are used."
			say white"   This is true:"
			say black"      "vari.0 '=' vari.1
			say white"   This is false:"
			say black"      "vari.0 '==' vari.1
		end
		when datatype(vari.0, N) && datatype(vari.1, N) then do
			say "Since only one of the values is numeric, the comparison"
			say "is made on the ASCII character values of each string."
			say "Numerals have a lower ASCII value than alphabetic characters."
		end
		when datatype(vari.0, N) then
			say "A numeric comparison was performed."
		otherwise
			say "The comparison was character-based."
			if Cmprsn > 3 then do
				DifPos = compare(vari.0, vari.1)
				do i = 0 to 1
					DifChar.i = substr(vari.i, DifPos, 1)
				end
				BigChar = (DifChar.1 > DifChar.0); LtlChar = ~BigChar
				say "The two strings are different at character" DifPos":"
				say 'Character "'DifChar.BigChar'" in "'vari.BigChar'" has an ASCII value'
				say 'of' c2d(DifChar.BigChar) 'compared to an ASCII value of' c2d(DifChar.LtlChar) 'for'
				say 'the character "'DifChar.LtlChar'" in the other string.'

				if length(vari.0) ~= length(vari.1) then
				do
					lngr = (length(vari.1) > length(vari.0)); shrtr = ~lngr
					say LF||white'      Note that since "'vari.lngr'" is a longer string,'
					say '      "'vari.shrtr'" was expanded to' length(vari.lngr) 'characters by padding'
					say '      it with spaces before the comparison.'norm
				end
			end
	end
end
if close = 'CLOSE' then
	address command 'endcli'
return 0
