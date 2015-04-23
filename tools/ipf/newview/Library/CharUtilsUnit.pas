Unit CharUtilsUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003-2006 Aaron Lawrence
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// Helper functions to work with characters

Interface

uses
  Classes;

const
  CharTAB = chr(9);
  CharCR = chr(13);
  CharLF = chr(10);
  CharSingleQuote = '''';
  CharDoubleQuote = '"';


  TYPE
    TSetOfChars = set of char;

  // Returns true if aChar is a digit 0..9
  Function CharIsDigit(const aChar : char) : boolean;

  // Returns true if aChar is an alphabetic character a..z A..Z
  Function CharIsAlpha(const aChar : char) : boolean;


  // ---------------
  // ---- PChar ----
  // ---------------


  // Allocates enough memory for a copy of aString as a PChar
  // and copies aString to it.
  Function NewPCharAsCopyOfStr(const aString: String) : PChar;

  // Converts a PChar into a String like StrPas
  // but conversts at least the first aLength chars
  Function StrPasWithLength(const aPChar: PChar; const aLength: integer) : String;

  // Returns the difference of the pointers
  Function PCharPointerDiff(const aMinuend: PChar; const aSubtrahend : PChar)  : Longword;

  // Concatentate AddText to Text. Reallocate and expand
  // Text if necessary. This is a size-safe StrCat
  Procedure AddAndResize(var aText: PChar; const aTextToAdd: PChar);


Implementation

  uses
    SysUtils;

  Function CharIsDigit(const aChar : char) : boolean;
  begin
    Result := (aChar >= '0') and (aChar <= '9');
  end;

  Function CharIsAlpha(const aChar : char) : boolean;
  begin
    Result := ( (aChar >= 'A') and (aChar <= 'Z') ) or ((aChar >= 'a') and (aChar <= 'z'));
  end;


  // ---------------
  // ---- PChar ----
  // ---------------


  Function StrPasWithLength(const aPChar: PChar; const aLength: integer) : String;
  var
    i: integer;
  begin
    Result := '';
    i := 0;
    while (aPChar[i] <> #0) and (i < aLength) do
    begin
      Result := Result + aPChar[i];
      inc( i );
    end;
  end;


  Function PCharPointerDiff(const aMinuend: PChar; const aSubtrahend : PChar) : Longword;
  begin
    Result := Longword(aMinuend) - Longword(aSubtrahend);
  end;


  Procedure CheckPCharSize(Var aText: PChar; const aNeededSize: longword);
  var
    tmpPChar: PChar;
    tmpNewBufferSize: longword;
  begin
    if (aNeededSize + 1) // + 1 to allow for null terminator
       > StrBufSize(aText) then
    begin
      // allocate new buffer, double the size...
      tmpNewBufferSize := StrBufSize(aText) * 2;
      // or if that's not enough...
      if tmpNewBufferSize < (aNeededSize + 1) then
      begin
        // double what we are going to need
        tmpNewBufferSize:= aNeededSize * 2;
      end;

      tmpPChar := StrAlloc(tmpNewBufferSize);

      // copy string to new buffer
      StrCopy(tmpPChar, aText);
      StrDispose(aText);
      aText:= tmpPChar;
    end;
  end;


  Procedure AddAndResize(var aText: PChar; const aTextToAdd: PChar);
  begin
    CheckPCharSize(aText, strlen(aText) + strlen(aTextToAdd));
    StrCat(aText, aTextToAdd);
  end;

  Function NewPCharAsCopyOfStr(const aString: String) : PChar;
  begin
    Result := StrAlloc(length(aString) + 1);
    StrPCopy(Result, aString);
  end;

END.
