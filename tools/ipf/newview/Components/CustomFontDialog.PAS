Unit CustomFontDialog;

Interface

Uses
  Classes,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  Graphics;

Type

    TCustomFontDialog=Class(TDialog)
      Private
         FNameList: TListBox;
         FNameLabel: TLabel;
         FSizeCombo: TComboBox;
         FSizeLabel: TLabel;
         FStyleLabel: TLabel;
         FStyleListbox: TListBox;
         FExampleText: TEdit;
         FItalicCheck:TCheckBox;
         FBoldCheck:TCheckBox;
         FOutlineCheck:TCheckBox;
         FUnderscoreCheck:TCheckBox;
         FStrikeOutCheck:TCheckBox;
         FActualFaceLabel:TLabel;
         FOKButton:TButton;
         FCancelButton:TButton;
         FEditFont: TFont;

         FAllowSimulations: boolean;

         FUpdating: boolean;
         FFontLoadRequired: boolean;

         Function GetFaceName: String;
         Procedure SetFaceName( s: String );

         Function GetStyleName: String;
         Procedure SetStyleName( s: String );

         Function GetPointSize: LongInt;
         Procedure SetPointSize( Value:LongInt );

         Function GetStyleFont: TFont;

         Function GetAttributes: TFontAttributes;
         Procedure SetAttributes( NewValue: TFontAttributes );

         Procedure InsertSizes;
         Procedure InsertStyles;

         Procedure OnSelectFace( Sender: TObject; Index: LongInt );
         Procedure OnSelectStyle( Sender: TObject; Index: LongInt );
         Procedure OnSetSize( Sender: TObject );
         Procedure OnStyleChanged( Sender:TObject );

         Procedure OnSizeClick( Sender: TObject; Index: longint );

         Procedure SetEditFont( NewFont:TFont );

         Function FindFace( FaceName: string ): TFont;

      Protected
         Procedure SetupComponent; Override;
         Procedure SetupShow; Override;
         Procedure LayoutControls;
         Procedure Resize; override;
         Procedure SelectFont;
      public
         Property FaceName: String read GetFaceName write SetFaceName;
         Property StyleName: String read GetStyleName write SetStyleName;
         Property PointSize: longint read GetPointSize write SetPointSize;
         Property Attributes: TFontAttributes read GetAttributes write SetAttributes;

         Property EditFont: TFont Read FEditFont Write SetEditFont;
         Property AllowSimulations: boolean read FAllowSimulations write FAllowSimulations;
    End;

Exports
  TCustomFontDialog, 'User', 'CustomFontDialog.bmp';

Implementation

uses
  SysUtils,
  PmWin,
  StringUtilsUnit;

// Returns true if s ends with endstr (case insensitive)
Function StringAtEnd( const endStr: string; const s: string ): boolean;
Var
  i, j: integer;
Begin
  Result := false;
  if Length( s ) < length( endStr ) then
    exit;
  j := Length( s );
  for i := length( endstr ) downto 1 do
  begin
    if UpCase( s[ j ] ) <> UpCase( endStr[ i ] ) then
      exit;
    dec( j );
  end;
  Result := true;
End;

// Returns S minus count characters from the right
Function StringLeftWithout( const S:string; const count:integer ):string;
Begin
  Result := copy( S, 1, length( S )-count );
End;

Function RemoveIfMatchAtEnd( Var s: string; const SearchString: string ): boolean;
begin
  Result := StringAtEnd( SearchString, s );
  if Result then
    s := Trim( StringLeftWithout( s, Length( SearchString ) ) );
end;

Procedure RemoveStyleNames( Var FaceName: string );
Begin
  FaceName := Trim( FaceName );
  RemoveIfMatchAtEnd( FaceName, 'Italic' );
  RemoveIfMatchAtEnd( FaceName, 'Oblique' );
  RemoveIfMatchAtEnd( FaceName, 'Bold' );
  RemoveIfMatchAtEnd( FaceName, 'Normal' );
end;

Function GetFontFamilyName( Font: TFont ): string;
begin
  Result := Font.Family;
  SubstituteAllOccurencesOfChar( Result, '-', ' ' );
  SubstituteAllOccurencesOfChar( Result, '_', ' ' );

  if Result = 'Roman' then
    if StrStartsWithIgnoringCase(Font.FaceName,'Tms Rmn') then
      // one particularly stupid example
      Result := 'Tms Rmn';

  if Result = 'Swiss' then
    if StrStartsWithIgnoringCase(Font.FaceName, 'Helv') then
      // one particularly stupid example
      Result := 'Helv';

  // some fonts have family names with styles!
  RemoveStyleNames( Result );

end;

Function GetFontStyleName( Font: TFont ): string;
var
  FamilyName: string;
begin
  Result := Font.FaceName;
  SubstituteAllOccurencesOfChar( Result, '-', ' ' );
  SubstituteAllOccurencesOfChar( Result, '_', ' ' );

  FamilyName := GetFontFamilyName( Font );
  if StrStartsWithIgnoringCase(Result, FamilyName) then
  begin
    Result := StrSubstringFrom( Result, length( FamilyName ) + 1 );
    Result := StrTrimChars( Result, [ ' ', '-', '_' ] );

    if Result = '' then
      Result := 'Normal';
  end;
end;

Procedure TCustomFontDialog.SetupComponent;
Var
     FontIndex: LongInt;
     aFont: TFont;
     FontList: TStringList;
     FamilyIndex: longint;
     FontFamilyName: string;
     FontStyleName: string;
Begin
     Inherited SetupComponent;

     FAllowSimulations := true;

     BorderStyle := bsSizeable;
     BorderIcons := [ biSystemMenu, biMaximize ];

     Caption := LoadNLSStr( SSelectAFont );
     Width := 480;
     Height := 350;
     MinTrackHeight := 350;
     MinTrackWidth := 400;

     // Give controls names for purposes of language support...

     FNameList := TListBox.Create( self );
     FNameList.Parent := self;
     FNameList.Sorted := true;
     FNameList.Duplicates := false;
     FNameList.OnItemFocus := OnSelectFace;
     FNameList.Name := 'NameList';

     FNameLabel := TLabel.Create( self );
     FNameLabel.Parent := self;
     FNameLabel.Caption := '~Name:';
     FNameLabel.FocusControl := FNameList;
     FNameLabel.Name := 'NameLabel';

     FStyleListbox := TListBox.Create( self );
     FStyleListbox.Parent := self;
     FStyleListbox.Name := 'StyleListBox';
     FStyleListBox.Sorted := true;
     FStyleListBox.OnItemFocus := OnSelectStyle;

     FStyleLabel := TLabel.Create( self );
     FStyleLabel.Parent := self;
     FStyleLabel.Caption := 'S~tyle:';
     FStyleLabel.FocusControl := FStyleListBox;
     FStyleLabel.Name := 'StyleLabel';

     FBoldCheck := TCheckBox.Create( self );
     FBoldCheck.Parent := self;
     FBoldCheck.OnClick := OnStyleChanged;
     FBoldCheck.Caption := '~Bold (Simulated)';
     FBoldCheck.Name := 'BoldCheck';

     FItalicCheck := TCheckBox.Create( self );
     FItalicCheck.Parent := self;
     FItalicCheck.OnClick := OnStyleChanged;
     FItalicCheck.Caption := '~Italic (Simulated)';
     FItalicCheck.Name := 'ItalicCheck';

     FUnderscoreCheck := TCheckBox.Create( self );
     FUnderscoreCheck.Parent := self;
     FUnderscoreCheck.OnClick := OnStyleChanged;
     FUnderscoreCheck.Caption := LoadNLSStr( SUnderscore );
     FUnderscoreCheck.Name := 'UnderscoreCheck';

     FOutlineCheck := TCheckBox.Create( self );
     FOutlineCheck.Parent := self;
     FOutlineCheck.OnClick := OnStyleChanged;
     FOutlineCheck.Caption := LoadNLSStr( SOutline );
     FOutlineCheck.Name := 'OutlineCheck';

     FStrikeOutCheck := TCheckBox.Create( self );
     FStrikeOutCheck.Parent := self;
     FStrikeOutCheck.OnClick := OnStyleChanged;
     FStrikeOutCheck.Caption := 'St~rikeout';
     FStrikeOutCheck.Name := 'StrikeOutCheck';

     FSizeCombo := TComboBox.Create( self );
     FSizeCombo.Style := csSimple;
     FSizeCombo.Parent := self;
     FSizeCombo.OnChange := OnSetSize;
     FSizeCombo.OnItemFocus := OnSizeClick;
     FSizeCombo.Name := 'SizeCombo';

     FSizeLabel := TLabel.Create( self );
     FSizeLabel.Parent := self;
     FSizeLabel.Caption := '~Size:';
     FSizeLabel.FocusControl := FSizeCombo;
     FSizeLabel.Name := 'SizeLabel';

     FExampleText := TEdit.Create( self );
     FExampleText.Parent := self;
     FExampleText.Text := 'abc ABC def DEF';
     FExampleText.Autosize := false;
     FExampleText.Name := 'ExampleText';

     FActualFaceLabel := TLabel.Create( self );
     FActualFaceLabel.Parent := self;
     FActualFaceLabel.Caption := '';
     FActualFaceLabel.Name := 'ActualFaceLabel';
     FActualFaceLabel.Alignment := taRightJustify;

     For FontIndex := 0 To Screen.FontCount - 1 Do
     Begin
          aFont := Screen.Fonts[ FontIndex ];

          FontStyleName := GetFontStyleName( aFont );
          FontFamilyName := GetFontFamilyName( aFont );

          FamilyIndex := FNameList.Items.IndexOf( FontFamilyName );
          if FamilyIndex = -1 then
          begin
            // new family
            FontList := TStringList.Create;
            FNameList.Items.AddObject( FontFamilyName, FontList );
          end
          else
          begin
            FontList := FNameList.Items.Objects[ FamilyIndex ] as TStringList;
          end;
          if FontList.IndexOf( FontStyleName ) = -1 then
          begin
            // new font for this family
            FontList.AddObject( FontStyleName, aFont );
          end;
     End;

     FOKButton := InsertButton( Self, 150, 10, 90, 30,
                                LoadNLSStr( SOkButton ),
                                '' );
     FOKButton.Name := 'OKButton';
     FOKButton.Default := true;
     FOKButton.ModalResult := mrOK;

     FCancelButton := InsertButton( Self, 250, 10, 90, 30,
                                    LoadNLSStr( SCancelButton ),
                                    '' );
     FCancelButton.Name := 'CancelButton';
     FCancelButton.Cancel := true;
     FCancelButton.ModalResult := mrCancel;

     LayoutControls;

     SetEditFont( Screen.DefaultFont );
End;

Function TCustomFontDialog.FindFace( FaceName: string ): TFont;
Var
     FontIndex: LongInt;
     aFont: TFont;
begin
     For FontIndex := 0 To Screen.FontCount - 1 Do
     Begin
          aFont := Screen.Fonts[ FontIndex ];
          if AnsiCompareText( aFont.FaceName, FaceName ) = 0 then
          begin
            Result := aFont;
            exit;
          end;
     End;
     Result := nil;
end;

Procedure TCustomFontDialog.LayoutControls;
Var
     W: longint;
     H: longint;
     ExampleH: longint;
     VSplit: longint;
     GrpH: longint;
     TopH: longint;
Begin
     W := ClientWidth;
     H := ClientHeight;

     // Example is minimum 40 pixels, or 20% of height
     ExampleH := 40;
     if ( H div 5 ) > ExampleH then
       ExampleH := H div 5;

     // Base of name/size/style (45 allows for buttons/spacing)
     VSplit := 45 + ExampleH;
     TopH := H - VSplit - 25;

     GrpH := TopH + 20;
     //                             Left     Bottom      Width    Height
     FNameLabel      .SetWindowPos( 5,       H - 25,     W - 210, 20      );
     FNameList       .SetWindowPos( 5,       VSplit,     W - 210, TopH    );

     FStyleLabel     .SetWindowPos( W - 200, H - 25,     120,     20      );

     FStyleListbox   .SetWindowPos( W - 200, H - 100,    145,     75      );

     FBoldCheck      .SetWindowPos( W - 200, H - 125,    145,     20      );
     FItalicCheck    .SetWindowPos( W - 200, H - 145,    145,     20      );
     FUnderscoreCheck.SetWindowPos( W - 200, H - 165,    145,     20      );
     FOutlineCheck   .SetWindowPos( W - 200, H - 185,    145,     20      );
     FStrikeOutCheck .SetWindowPos( W - 200, H - 205,    145,     20      );

     FSizeLabel      .SetWindowPos( W - 50,  H - 25,     45,      20      );
     FSizeCombo      .SetWindowPos( W - 50,  VSplit,     45,      TopH    );

     FExampleText    .SetWindowPos( 5,       40,         W - 10,  ExampleH );

     FActualFaceLabel.SetWindowPos( 180,     10,         W - 185,  20      );

     FOKButton       .SetWindowPos( 5,       5,          80,      30      );
     FCancelButton   .SetWindowPos( 90,      5,          80,      30      );

End;


Procedure TCustomFontDialog.SetupShow;
Begin
     Inherited SetupShow;

     FNameList.Focus;
     FOKButton.Default := True;

     FBoldCheck.Enabled := FAllowSimulations;
     FItalicCheck.Enabled := FAllowSimulations;
     if not FAllowSimulations then
     begin
       FBoldCheck.Checked := false;
       FItalicCheck.Checked := false;
     end;

    FaceName := GetFontFamilyName( FEditFont );
    StyleName := GetFontStyleName( FEditFont );
    PointSize := FEditFont.PointSize;
    Attributes := FEditFont.Attributes;

    FFontLoadRequired := false;

    SelectFont; // display it

End;

Procedure TCustomFontDialog.Resize;
begin
  inherited Resize;
  LayoutControls;
end;

Function TCustomFontDialog.GetFaceName: string;
begin
  if FNameList.ItemIndex = -1 then
    Result := ''
  else
    Result := FNameList.Items[ FNameList.ItemIndex ];
end;

Procedure TCustomFontDialog.SetFaceName( s: string );
begin
  FNameList.ItemIndex := FNameList.Items.IndexOf( s );

  if FNameList.ItemIndex > 4 then
    FNameList.TopIndex := FNameList.ItemIndex - 4
  else
    FNameList.TopIndex := 0;
end;

Function TCustomFontDialog.GetStyleName: String;
begin
  if FStyleListBox.ItemIndex = -1 then
    Result := ''
  else
    Result := FStyleListBox.Items[ FStyleListBox.ItemIndex ];
end;

Procedure TCustomFontDialog.SetStyleName( s: String );
begin
  FStyleListBox.ItemIndex := FStyleListBox.Items.IndexOf( s );

  if FNameList.ItemIndex = -1 then
    FNameList.ItemIndex := 0;
end;

Function TCustomFontDialog.GetAttributes: TFontAttributes;
Begin
     Result :=[];
     If FItalicCheck.Checked Then
       Include( Result, faItalic );
     If FBoldCheck.Checked Then
       Include( Result, faBold );
     If FOutlineCheck.Checked Then
       Include( Result, faOutline );
     If FStrikeOutCheck.Checked Then
       Include( Result, faStrikeOut );
     If FUnderscoreCheck.Checked Then
       Include( Result, faUnderScore );
End;

Procedure TCustomFontDialog.SetAttributes( NewValue: TFontAttributes );
Begin
     if FAllowSimulations then
     begin
       FBoldCheck.Checked := faBold in NewValue;
       FItalicCheck.Checked := faItalic in NewValue;
     end;
     FOutlineCheck.Checked := faOutline in NewValue;
     FStrikeoutCheck.Checked := faStrikeout in NewValue;
     FUnderscoreCheck.Checked := faUnderscore in NewValue;
End;

Function TCustomFontDialog.GetPointSize: LongInt;
Var
  S: String;
  C: Integer;
Begin
  S := FSizeCombo.Text;
  Val( S, Result, C );
  If C <> 0 Then
    // invalid conversion
    Result := 0;
End;

Procedure TCustomFontDialog.SetPointSize( Value:LongInt );
Begin
  If Value = 0 Then
    Value := 8;
  FSizeCombo.Text := IntToStr( Value );

  // if there's an exact match, select it, if not select nothing
  FSizeCombo.ItemIndex := FSizeCombo.Items.IndexOf( IntToStr( Value ) );
End;

Function TCustomFontDialog.GetStyleFont: TFont;
begin
  if FStyleListBox.ItemIndex = -1 then
  begin
    // during startup
    Result := Screen.DefaultFont;
    exit;
  end;
  Result := FStyleListBox.Items.Objects[ FStyleListBox.ItemIndex ] as TFont;

end;

Procedure TCustomFontDialog.SelectFont;
var
  Attrs: TFontAttributes;
  StyleFont: TFont;
begin
  if FFontLoadRequired then
    // we are starting up and don't want to set edit font yet!
    exit;

  Screen.Cursor := crHourGlass; // in case it takes a while to load up the font

  Attrs := GetAttributes;

  StyleFont := GetStyleFont;

  DereferenceFont( FEditFont );
  FEditFont :=
    Screen.CreateCompatibleFont(
      Screen.GetFontFromPointSize( StyleFont.FaceName,
                                   GetPointSize ) );
  FEditFont.Attributes := GetAttributes;

  FActualFaceLabel.Caption := StyleFont.FaceName;

  FExampleText.Font := FEditFont;

  Screen.Cursor := crDefault;
end;

Procedure TCustomFontDialog.SetEditFont( NewFont:TFont );
Begin
  If NewFont = Nil Then
    NewFont := Screen.DefaultFont;

  DereferenceFont( FEditFont );
  FEditFont := NewFont;
  ReferenceFont( FEditFont );

  if Handle <> 0 then
  begin
    FaceName := GetFontFamilyName( NewFont );
    StyleName := GetFontStyleName( NewFont );
    PointSize := NewFont.PointSize;
    Attributes := NewFont.Attributes;
  end
  else
  begin
    FFontLoadRequired := true;
  end;
End;

const
  StandardOutlineSizes: array[ 0 .. 11 ] of longint =
  (
    4, 5, 6, 8, 10, 12,
    15, 18, 24, 36, 48, 72
  );

function LongintListCompare( Item1: pointer;
                             Item2: pointer ): longint;
begin
  if item1 < item2 then
    result := -1
  else if item1 > item2 then
    result := 1
  else
    result := 0;
end;

Procedure TCustomFontDialog.InsertStyles;
var
  FontList: TStringList;
  OldStyleName: string;
  NewIndex: longint;
begin
  FontList := FNameList.Items.Objects[ FNameList.ItemIndex ] as TStringList;
  if FStyleListbox.ItemIndex <> -1 then
    OldStyleName := FStyleListbox.Items[ FStyleListbox.ItemIndex ]
  else
    OldStyleName := 'Normal';
  FStyleListbox.Items.Assign( FontList );

  NewIndex := FStyleListbox.Items.IndexOf( OldStyleName );
  if NewIndex = -1 then
    NewIndex := FStyleListbox.Items.IndexOf( 'Normal' );
  if NewIndex = -1 then
    NewIndex := 0;
  FStyleListbox.ItemIndex := NewIndex;
end;

Procedure TCustomFontDialog.InsertSizes;
var
     Face: string;
     TheFont: TFont;
     FontIndex: longint;
     SizeIndex: longint;
     OldSize: longint;
     SizeString: string;

     LimitedSizes: boolean;
     Size: longint;
     NearestSize: longint;
     NearestSizeIndex: longint;

     Sizes: TList;

     procedure AddSize( const size: longint );
     begin
       if Sizes.IndexOf( pointer( size ) ) = -1 then
         Sizes.Add( pointer( size ) );
     end;
Begin
     Sizes := TList.Create;

     Face := GetStyleFont.FaceName;
     try
       OldSize := StrToInt( FSizeCombo.Caption );
     except
       OldSize := 8;
     end;

     FSizeCombo.BeginUpdate;
     FSizeCombo.Clear;

     LimitedSizes := true;

     For FontIndex := 0 To Screen.FontCount - 1 Do
     Begin
       TheFont := Screen.Fonts[ FontIndex ];
       If TheFont.FaceName = Face Then
       Begin
          // this is a font for the current face.
          if TheFont.FontType = ftBitmap then
          begin
            // just insert the specified point size
            AddSize( TheFont.NominalPointSize );
          end
          else
          begin
            // an outline font...
            LimitedSizes := false;
            for SizeIndex := Low( StandardOutlineSizes ) to High( StandardOutlineSizes ) do
            begin
              AddSize( StandardOutlineSizes[ SizeIndex ] );
            end;
          end;
       end;
     End;

     // sort from small to large
     Sizes.Sort( LongintListCompare );

     // add to combobox
     For SizeIndex := 0 to Sizes.Count - 1 do
     begin
       SizeString := IntToStr( longint( Sizes[ SizeIndex ] ) );
       FSizeCombo.Items.Add( SizeString );
     end;

     if LimitedSizes then
     begin
       // Find nearest match for old size
       if Sizes.Count > 0 then
       begin
         NearestSizeIndex := 0;
         NearestSize := longint( Sizes[ 0 ] );
         for SizeIndex := 1 to Sizes.Count - 1 do
         begin
           Size := longint( Sizes[ SizeIndex ] );
           if Abs( Size - OldSize ) < Abs( NearestSize - OldSize ) then
           begin
             // closer,
             NearestSizeIndex := SizeIndex;
             NearestSize := Size;
           end;
         end;
       end
       else
       begin
         NearestSizeIndex := -1;
       end;

       FSizeCombo.ItemIndex := NearestSizeIndex;
     end
     else
     begin
       FSizeCombo.Text := IntToStr( OldSize );

       // if there's an exact match, select it, if not select nothing
       NearestSizeIndex := FSizeCombo.Items.IndexOf( IntToStr( OldSize ) );

       FSizeCombo.ItemIndex := NearestSizeIndex

     end;

     FSizeCombo.EndUpdate;

     Sizes.Destroy;
End;


{$HINTS OFF}
Procedure TCustomFontDialog.OnSelectFace( Sender: TObject; Index: LongInt );
Begin
     FUpdating := true;
     InsertStyles;
     InsertSizes;
     FUpdating := false;
     SelectFont;
End;

Procedure TCustomFontDialog.OnSelectStyle( Sender: TObject; Index: LongInt );
Begin
     if FUpdating then
       exit;
     FUpdating := true;
     InsertSizes;
     FUpdating := false;
     SelectFont;
End;

Procedure TCustomFontDialog.OnSetSize( Sender: TObject );
Begin
     if FUpdating then
       exit;
     SelectFont;
End;

Procedure TCustomFontDialog.OnSizeClick( Sender: TObject; Index: longint );
Begin
  // make a single click select
  FSizeCombo.Text := FSizeCombo.Items[ Index ];
End;

Procedure TCustomFontDialog.OnStyleChanged( Sender:TObject );
Begin
     SelectFont;
End;

Initialization
  {Register classes}
  RegisterClasses([TCustomFontDialog]);
End.

