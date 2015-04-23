Unit CustomMemo;

Interface

{$ifdef win32}
Uses
  StdCtrls;

type
  TMemoType = TMemo;

{$else}
Uses
  Classes, Forms, StdCtrls, Messages;

{Declare new class}
Type
  TCustomMemo=Class(TMemo)
  Protected
    FStoreLines: boolean;
    Procedure DestroyWnd; Override;
    Procedure SetupComponent; Override;
  Public
    Procedure WMChar(Var Msg:TWMChar); message WM_CHAR;
    Procedure AddSelectedLine( NewText: string );
    Procedure AddText( NewText: PChar );
    // If it can be found, make the given text the
    // top of the window. Returns true if it was found
    Function JumpToText( Text: string ): boolean;
    // Returns contents as Ansi String
    Function Text: AnsiString;
    // Returns total height of all text. Does not include borders at this time :-(
    Function TotalHeight: longint;
    // If the text fits entirely within the control, hide the scrollbars
    Procedure AdjustScrollbars;
  Published
    Property StoreLines: boolean read FStoreLines write FStoreLines;
  End;

  TMemoType = TCustomMemo;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  TCustomMemo,'User','CustomMemo.bmp';
{$endif}

procedure AddSelectedMemoText( Memo: TMemoType;
                               Text: string );

Implementation

{$ifdef os2}
Uses
  PMWin, SysUtils, Os2Def;
{$endif}

procedure AddSelectedMemoText( Memo: TMemoType;
                               Text: string );
{$ifdef win32}
var
  StartPos: integer;
{$endif}
begin
{$ifdef win32}
  StartPos := Length( Memo.Lines.Text );
  Memo.Lines.Add( Text );
  Memo.SelStart := StartPos;
  Memo.SelLength := Length( Memo.Lines.Text ) - StartPos;
{$else}
  Memo.AddSelectedLine( Text );
{$endif}
end;

{$ifdef os2}
Procedure TCustomMemo.SetupComponent;
begin
  inherited SetupComponent;
  FStoreLines := true;
end;

Procedure TCustomMemo.DestroyWnd;
Begin
  if FStoreLines then
    inherited DestroyWnd
  else
    TControl.DestroyWnd;
End;

Procedure TCustomMemo.AdjustScrollbars;
begin
  if TotalHeight < Height - 10 then
    Scrollbars := ssNone;
end;

Procedure TCustomMemo.AddText( NewText: PChar );
Var
  addPoint: longint;
Begin
  // Set to LF-only format
  WinSendMsg( Handle, MLM_FORMAT, MLFIE_CFTEXT, 0);

  addPoint:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );

  // add text
  WinSendMsg( Handle, MLM_SETIMPORTEXPORT, LongWord( NewText ), strlen( NewText ) );
  WinSendMsg( Handle, MLM_IMPORT, LongWord( @addPoint ), strlen( NewText ) );
End;

Procedure TCustomMemo.AddSelectedLine( NewText: string );
Var
  currentLength: longint;
  startOfLine: longint;
  endOfLine: longint;
  lineLength: longint;
  rc: longint;
  csText: cstring;
  addPoint: longint;
  line: longint;
Begin
  // Set to LF-only format
  WinSendMsg( Handle, MLM_FORMAT, MLFIE_NOTRANS, 0 ); {LF!}

  // If the last line is actually empty, we don't need
  // to add a new line character.
  currentLength:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );
  line:=WinSendMsg( Handle, MLM_LINEFROMCHAR, currentLength, 0 );
  startOfLine:=WinSendMsg( Handle, MLM_CHARFROMLINE, currentLength, 0 );
  lineLength:= WinSendMsg( Handle, MLM_QUERYLINELENGTH, startOfLine,0);

  if lineLength>0 then
  begin
    // Find end of text
    addPoint:= currentLength;

    // Add a new line
    csText:=#10;
    WinSendMsg( Handle, MLM_SETIMPORTEXPORT, LongWord(@csText), 255 );
    WinSendMsg( Handle, MLM_IMPORT, LongWord( @addPoint ), Length(csText) );

    // find start of new line
    startOfLine:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );
  end;

  addPoint:=startOfLine;

  // add text
  csText:=NewText;
  WinSendMsg( Handle, MLM_SETIMPORTEXPORT, LongWord(@csText), 255 );
  WinSendMsg( Handle, MLM_IMPORT, LongWord( @addPoint ), Length(csText) );

  // find the end of the new line
  endOfLine:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );

  // get focus, otherwise selection won't happen
  Focus;
  rc:=WinSendMsg( Handle, MLM_SETSEL, startOfLine, endOfLine  );
End;

// If it can be found, make the given text the
// top of the window
Function TCustomMemo.JumpToText( Text: string ): boolean;
Var
  SearchData: MLE_SearchData;
  rc: longint;
  csText: cstring;
  line: longint;
  newTopChar: longint;
Begin
  Result:=false;
  // Search all text
  SearchData.iptStart:=0;
  SearchData.iptStop:=-1;

  csText:=Text;
  SearchData.pchFind:=@csText;

  rc:=WinSendMsg( Handle, MLM_SEARCH, 0, LongWord( @SearchData ) );
  if rc=0 then
    exit;
  // find which line the text is on:
  line:=WinSendMsg( Handle, MLM_LINEFROMCHAR, SearchData.iptStart, 0 );
  // find the start of the line
  newTopChar:=WinSendMsg( Handle, MLM_CHARFROMLINE, line, 0 );
  // set it as the first char in the memo
  WinSendMsg( Handle, MLM_SETFIRSTCHAR, newTopChar, 0 );
  Result:=true;
End;

// Returns contents as Ansi String
Function TCustomMemo.Text: AnsiString;
Var
  pc: PChar;
Begin
  pc:=Lines.GetText;
  Result:=AnsiString( pc );
  StrDispose( pc );
End;

// Returns total height of all text
Function TCustomMemo.TotalHeight: longint;
Var
  currentLength: longint;
  line: longint;
Begin
  // Set to LF-only format
  WinSendMsg( Handle, MLM_FORMAT, MLFIE_NOTRANS, 0 ); {LF!}

  currentLength:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );
  line:= WinSendMsg( Handle, MLM_LINEFROMCHAR, currentLength, 0 );

  Result:= ( line+1 )* Font.Height;
end;

Procedure TCustomMemo.WMChar(Var Msg:TWMChar);
var
  CursorPosition: longint;
  SelectionStart: longint;
begin
  If Msg.KeyData And KC_KEYUP = 0 Then
  begin
    // keydown
    if Msg.VirtualKeyCode in [ VK_PAGEDOWN, VK_PAGEUP ] then
    begin
      // we want to do some different things from the original
      // OS/2 actions for page up/down
      if Msg.KeyData And KC_CTRL <> 0 then
      begin
        // Ctrl PgUp/Down now goes to top or bottom of text
        // not whatever weird behaviour the MLE thinks...
        if Msg.VirtualKeyCode = VK_PAGEUP then
          Msg.VirtualKeyCode := VK_HOME
        else
          Msg.VirtualKeyCode := VK_END;
      end;

      if Msg.KeyData And KC_SHIFT <> 0 then
      begin
        // with shift
        SelectionStart := SendMsg( Handle,
                                   MLM_QUERYSEL,
                                   MLFQS_ANCHORSEL,
                                   0 );
      end;

      inherited WMChar( Msg );

      if Msg.KeyData And KC_SHIFT <> 0 then
      begin
        CursorPosition := SendMsg( Handle,
                                   MLM_QUERYSEL,
                                   MLFQS_CURSORSEL,
                                   0 );

        SendMsg( Handle,
                 MLM_SETSEL,
                 SelectionStart,
                 CursorPosition );
      end;
      exit;
    end;
  end;

  inherited WMChar( Msg );

end;

Initialization
  {Register classes}
  RegisterClasses([TCustomMemo]);
{$endif}

End.

