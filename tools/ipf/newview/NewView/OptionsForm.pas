Unit OptionsForm;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
  Classes,
  Forms,
  Buttons,
  ExtCtrls,
  StdCtrls,
  TabCtrls,
  ComCtrls,
  ColorWheel,
  CustomFontDialog,
  ACLLanguageUnit,
  SettingsUnit;

// The correct sizes are:
// Form: 479x378
// Notebook: 471x306

Type
  TOptionsForm = Class (TForm)
    TabbedNotebook: TTabbedNotebook;
    SmoothScrollingCheckBox: TCheckBox;
    UseOriginalDialogsCheckBox: TCheckBox;
    Label1: TLabel;
    NormalFontPanel: TPanel;
    Label2: TLabel;
    FixedFontPanel: TPanel;
    Label5: TLabel;
    ColorItemsListBox: TListBox;
    GroupBox1: TGroupBox;
    FontDialog: TCustomFontDialog;
    NormalFontButton: TButton;
    FixedFontButton: TButton;
    DefaultFontsButton: TButton;
    OpenBackgroundImageButton: TButton;
    ClearBackgroundBitmapButton: TButton;
    CancelButton: TButton;
    OKButton: TButton;
    FixedFontSubstitutionCheckBox: TCheckBox;
    FixedFontSubstitutesEdit: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ConfirmWinHelpCheckBox: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox2: TGroupBox;
    ShowLeftPanel_HelpCheckBox: TCheckBox;
    ShowLeftPanel_StandaloneCheckBox: TCheckBox;
    DefaultColorsButton: TButton;
    ToolbarStyleRadioGroup: TRadioGroup;
    ApplicationFontPanel: TPanel;
    ApplicationFontButton: TButton;
    ApplicationFontLabel: TLabel;
    IndexStyleRadioGroup: TRadioGroup;
    StartupHelpCheckBox: TCheckBox;
    RedTrackBar: TTrackBar;
    RedEdit: TEdit;
    GreenTrackBar: TTrackBar;
    GreenEdit: TEdit;
    BlueTrackBar: TTrackBar;
    BlueEdit: TEdit;
    RedLabel: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RedUpDown: TUpDown;
    GreenUpDown: TUpDown;
    BlueUpDown: TUpDown;
    OpenWithExpandedContentsCheckBox: TCheckBox;
    ColorWheel: TColorWheel;
    ValueBar: TValueBar;
    BackgroundImageFilenameEdit: TEdit;
    Label6: TLabel;
    Procedure OptionsFormOnSetupShow (Sender: TObject);
    Procedure ApplicationFontButtonOnClick (Sender: TObject);
    Procedure ColorItemsListBoxOnClick (Sender: TObject);
    Procedure DefaultFontsButtonOnClick (Sender: TObject);
    Procedure DefaultColorsButtonOnClick (Sender: TObject);
    Procedure BlueUpDownOnChanging (Sender: TComponent;
      Var AllowChange: Boolean);
    Procedure GreenUpDownOnChanging (Sender: TComponent;
      Var AllowChange: Boolean);
    Procedure RedUpDownOnChanging (Sender: TComponent;
      Var AllowChange: Boolean);
    Procedure RedTrackBarOnChange (Sender: TObject);
    Procedure GreenTrackBarOnChange (Sender: TObject);
    Procedure BlueTrackBarOnChange (Sender: TObject);
    Procedure BlueEditOnChange (Sender: TObject);
    Procedure GreenEditOnChange (Sender: TObject);
    Procedure RedEditOnChange (Sender: TObject);
    Procedure ClearBackgroundBitmapButtonOnClick (Sender: TObject);
    Procedure OpenBackgroundImageButtonOnClick (Sender: TObject);
    Procedure OptionsFormOnCreate (Sender: TObject);
    Procedure ValueBarOnChange (Sender: TObject);
    Procedure ColorItemsListBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure FixedFontButtonOnClick (Sender: TObject);
    Procedure NormalFontButtonOnClick (Sender: TObject);
    Procedure OptionsFormOnShow (Sender: TObject);
  Protected
    Colors: Array[ 0..NumColorSettings - 1 ] of TColor;
    UpdatingColor: boolean;
    ImageDirectory: string;
    ApplicationFontCustomised: boolean;
    Procedure SetSelectedColor( bit: longword;
                                value: longint;
                                ExcludeControl: TComponent );
    Procedure SetFontCaptions;
    Procedure DisplayColorItem( ExcludeControl: TComponent );

    function GetFontString( Font: TFont ): string;

  Protected
    Procedure OnLanguageEvent( Language: TLanguageFile;
                               const Apply: boolean );

    SelectBitmapTitle: string;
    BitmapFilesDesc: string;
    BoldFontSuffix: string;
    ItalicFontSuffix: string;

  Public
    MyParent: TForm;
  End;

Var
  OptionsForm: TOptionsForm;

procedure EnsureOptionsFormLoaded;

Implementation

uses
  SysUtils,
  ACLUtility,
  ControlsUtility,
  FileDialogForm,
  DebugUnit,
  StringUtilsUnit;

Procedure TOptionsForm.OptionsFormOnSetupShow (Sender: TObject);
Begin
  ScaleForm( self, 11, 16 );
End;

Procedure TOptionsForm.ApplicationFontButtonOnClick (Sender: TObject);
Begin
  FontDialog.EditFont := ApplicationFontPanel.Font;
  if FontDialog.Execute then
  begin
    ApplicationFontPanel.Font := Screen.CreateCompatibleFont( FontDialog.EditFont );
    ApplicationFontCustomised := true;
    SetFontCaptions;
  end;
End;

function TOptionsForm.GetFontString( Font: TFont ): string;
begin
  Result := Font.FaceName
            + ' '
            + IntToStr( Font.PointSize );
  if faBold in Font.Attributes then
    Result := Result + BoldFontSuffix;
  if faItalic in Font.Attributes then
    Result := Result + ItalicFontSuffix;
end;

Procedure TOptionsForm.ColorItemsListBoxOnClick (Sender: TObject);
Begin

End;

const
  DefaultColorItemNames: array[ 0 .. NumColorSettings - 1 ] of string =
  (
    'Contents Background',
    '  Text',
    '  Lines',
    'Index Background',
    '  Text',
    'Search Background',
    '  Text',
    'Notes Background',
    '  Text',
    'Topic Background',
    '  Notes Text',
    'Search Highlight'
  );

Procedure TOptionsForm.OnLanguageEvent( Language: TLanguageFile;
                                        const Apply: boolean );
var
  i: longint;
  ColorItemName: string;
  tmpPrefix : String;
begin
  // LogEvent(LogI18n, 'TOptionsForm.OnLanguageEvent apply: "' + BoolToStr(Apply) + '"');
  Language.LoadComponentLanguage( self, Apply );

  if Apply then
  begin
    ColorItemsListBox.Items.BeginUpdate;
    ColorItemsListBox.Items.Clear;
  end;

  tmpPrefix := 'OptionsForm' + LANGUAGE_LABEL_DELIMITER;

  for i := 0 to NumColorSettings - 1 do
  begin
    Language.LL( Apply,
                 ColorItemName,
                 tmpPrefix + 'ColorItemName' + IntToStr( i ),
                 DefaultColorItemNames[ i ] );
    if Apply then
      ColorItemsListBox.Items.Add( ColorItemName );
  end;

  if Apply then
    ColorItemsListBox.EndUpdate;

  Language.LL( Apply, SelectBitmapTitle, tmpPrefix + 'SelectBitmapTitle', 'Select Bitmap File' );
  Language.LL( Apply, BitmapFilesDesc, tmpPrefix + 'BitmapFilesDesc', 'Bitmaps (*.bmp)' );
  Language.LL( Apply, BoldFontSuffix, tmpPrefix + 'BoldFontSuffix', ' Bold' );
  Language.LL( Apply, ItalicFontSuffix, tmpPrefix + 'ItalicFontSuffix', ' Italic' );
end;

Procedure TOptionsForm.DefaultFontsButtonOnClick (Sender: TObject);
Begin
  NormalFontPanel.Font := Screen.GetFontFromPointSize( DefaultTopicFontName,
                                                       DefaultTopicFontSize );
  FixedFontPanel.Font := Screen.GetFontFromPointSize( DefaultTopicFixedFontName,
                                                      DefaultTopicFixedFontSize );
  ApplicationFontCustomised := false;
  ApplicationFontPanel.Font := GetNiceDefaultFont;

  SetFontCaptions;
End;

Procedure TOptionsForm.DefaultColorsButtonOnClick (Sender: TObject);
var
  i: longint;
Begin
  // restore default colors
  for i := 0 to NumColorSettings - 1 do
  begin
    Colors[ i ] := DefaultColors[ i ];
  end;
  DisplayColorItem( nil );
End;

Procedure TOptionsForm.SetSelectedColor( bit: longword;
                                         value: longint;
                                         ExcludeControl: TComponent );
var
  mask: longword;
begin
  if UpdatingColor then
    exit;

  if value < 0 then
    value := 0;
  if value > 255 then
    value := 255;

  UpdatingColor := true;

  Mask := $ffffff and not ( $ff shl bit );

  Colors[ ColorItemsListBox.ItemIndex ] :=
    Colors[ ColorItemsListBox.ItemIndex ]
    and Mask
    or ( Value shl bit );

  DisplayColorItem( ExcludeControl );

  UpdatingColor := false;

end;

Procedure TOptionsForm.RedUpDownOnChanging (Sender: TComponent;
  Var AllowChange: Boolean);
Begin
  SetSelectedColor( 16, RedUpDown.Position, RedUpDown );
End;

Procedure TOptionsForm.GreenUpDownOnChanging (Sender: TComponent;
  Var AllowChange: Boolean);
Begin
  SetSelectedColor( 8, GreenUpDown.Position, GreenUpDown );
End;

Procedure TOptionsForm.BlueUpDownOnChanging (Sender: TComponent;
  Var AllowChange: Boolean);
Begin
  SetSelectedColor( 0, BlueUpDown.Position, BlueUpDown );
End;

Procedure TOptionsForm.RedTrackBarOnChange (Sender: TObject);
Begin
  SetSelectedColor( 16, RedTrackBar.Position, RedTrackBar );
End;

Procedure TOptionsForm.GreenTrackBarOnChange (Sender: TObject);
Begin
  SetSelectedColor( 8, GreenTrackBar.Position, GreenTrackBar );
End;

Procedure TOptionsForm.BlueTrackBarOnChange (Sender: TObject);
Begin
  SetSelectedColor( 0, BlueTrackBar.Position, BlueTrackBar );
End;

Procedure TOptionsForm.RedEditOnChange (Sender: TObject);
Begin
  try
    SetSelectedColor( 16, StrToInt( RedEdit.Text ), RedEdit );
  except
  end;
End;

Procedure TOptionsForm.GreenEditOnChange (Sender: TObject);
Begin
  try
    SetSelectedColor( 8, StrToInt( GreenEdit.Text ), GreenEdit );
  except
  end;
End;

Procedure TOptionsForm.BlueEditOnChange (Sender: TObject);
Begin
  try
    SetSelectedColor( 0, StrToInt( BlueEdit.Text ), BlueEdit );
  except
  end;
End;

Procedure TOptionsForm.ClearBackgroundBitmapButtonOnClick (Sender: TObject);
Begin
  BackgroundImageFilenameEdit.Text := '';
End;

Procedure TOptionsForm.OpenBackgroundImageButtonOnClick (Sender: TObject);
var
  Filename: string;
Begin
  if DoOpenFileDialog( SelectBitmapTitle,
                       BitmapFilesDesc + '|*.bmp',
                       '*.bmp',
                       ImageDirectory,
                       Filename ) then
  begin
    BackgroundImageFilenameEdit.Text := Filename;
  end;
End;

Procedure TOptionsForm.OptionsFormOnCreate (Sender: TObject);
Begin
  RegisterEventForLanguages( OnLanguageEvent );

  TabbedNoteBook.ShowPageHint := false;
  TabbedNoteBook.NotebookMargin := 2;
  TabbedNoteBook.PageIndex := 0;

  // Select the first colour item
  ColorItemsListBox.ItemIndex := 0;
  RedTrackBar.Frequency := 32;
  GreenTrackBar.Frequency := 32;
  BlueTrackBar.Frequency := 32;

  ImageDirectory := GetApplicationDir;
End;

Procedure TOptionsForm.ValueBarOnChange (Sender: TObject);
Begin
  if UpdatingColor then
    exit;

  UpdatingColor := true;

  Colors[ ColorItemsListBox.ItemIndex ] := ValueBar.SelectedColor;

  DisplayColorItem( ColorWheel );

  UpdatingColor := false;
End;

Procedure TOptionsForm.ColorItemsListBoxOnItemFocus (Sender: TObject;
  Index: LongInt);
begin
  DisplayColorItem( nil );
end;

Procedure TOptionsForm.DisplayColorItem( ExcludeControl: TComponent );
Var
  c: longint;
  r: longint;
  g: longint;
  b: longint;
Begin
  c := Colors[ ColorItemsListBox.ItemIndex ];
  c := SysColorToRGB( c );
  r := ( c shr 16 ) and 255;
  g := ( c shr  8 ) and 255;
  b := ( c        ) and 255;

  if ExcludeControl <> ColorWheel then
    ColorWheel.SetSelectedColor( c );

  if ExcludeControl <> RedEdit then
    RedEdit.Text := IntToStr( r );
  if ExcludeControl <> GreenEdit then
    GreenEdit.Text := IntToStr( g );
  if ExcludeControl <> BlueEdit then
    BlueEdit.Text := IntToStr( b );

  if ExcludeControl <> RedTrackBar then
    RedTrackBar.Position := r;
  if ExcludeControl <> GreenTrackBar then
    GreenTrackBar.Position := g;
  if ExcludeControl <> BlueTrackBar then
    BlueTrackBar.Position := b;

  if ExcludeControl <> RedUpDown then
    RedUpDown.Position := r;
  if ExcludeControl <> GreenUpDown then
    GreenUpDown.Position := g;
  if ExcludeControl <> BlueUpDown then
    BlueUpDown.Position  := b;
End;

Procedure TOptionsForm.OKButtonOnClick (Sender: TObject);
var
  ColorIndex: integer;
Begin
  // Save settings from controls
  Settings.ShowLeftPanel_Help := ShowLeftPanel_HelpCheckBox.Checked;
  Settings.ShowLeftPanel_StandAlone := ShowLeftPanel_StandaloneCheckBox.Checked;

  Settings.NormalFont := NormalFontPanel.Font;
  Settings.FixedFont := FixedFontPanel.Font;

  Settings.FixedFontSubstitution := FixedFontSubstitutionCheckBox.Checked;
  Settings.FixedFontSubstitutes := FixedFontSubstitutesEdit.Text;

  Settings.StartupHelp := StartupHelpCheckBox.Checked;

  Settings.IndexStyle := TIndexStyle( IndexStyleRadioGroup.ItemIndex );
  Settings.SmoothScrolling := SmoothScrollingCheckbox.Checked;
  Settings.UseOriginalDialogs := UseOriginalDialogsCheckBox.Checked;
  Settings.OpenWithExpandedContents := OpenWithExpandedContentsCheckBox.Checked;

  for ColorIndex := 0 to High( Settings.Colors ) do
    Settings.Colors[ ColorIndex ] := Colors[ ColorIndex ];

  Settings.ToolbarBackgroundImageFilename := BackgroundImageFilenameEdit.Text;

  Settings.ToolbarStyle := TToolbarStyle( ToolbarStyleRadioGroup.ItemIndex );

  if ApplicationFontCustomised then
    Settings.Fonts[ ApplicationFontIndex ] := ApplicationFontPanel.Font
  else
    Settings.Fonts[ ApplicationFontIndex ] := nil;

  Settings.ConfirmWinHelp := ConfirmWinHelpCheckBox.Checked;
End;

Procedure TOptionsForm.FixedFontButtonOnClick (Sender: TObject);
Begin
  FontDialog.EditFont := FixedFontPanel.Font;
  if FontDialog.Execute then
  begin
    FixedFontPanel.Font := Screen.CreateCompatibleFont( FontDialog.EditFont );
    SetFontCaptions;
  end;

End;

Procedure TOptionsForm.NormalFontButtonOnClick (Sender: TObject);
Begin
  FontDialog.EditFont := NormalFontPanel.Font;
  if FontDialog.Execute then
  begin
    NormalFontPanel.Font := FontDialog.EditFont;
    SetFontCaptions;
  end;
End;

Procedure TOptionsForm.OptionsFormOnShow (Sender: TObject);
var
  ColorIndex: integer;
Begin

  // Load settings into controls.
  ShowLeftPanel_HelpCheckBox.Checked := Settings.ShowLeftPanel_Help;
  ShowLeftPanel_StandaloneCheckBox.Checked := Settings.ShowLeftPanel_StandAlone;

  NormalFontPanel.Font := Settings.NormalFont;
  FixedFontPanel.Font := Settings.FixedFont;

  ApplicationFontCustomised := Settings.Fonts[ ApplicationFontIndex ] <> nil;
  if ApplicationFontCustomised then
    ApplicationFontPanel.Font := Settings.Fonts[ ApplicationFontIndex ]
  else
    ApplicationFontPanel.Font := GetNiceDefaultFont;

  SetFontCaptions;

  FixedFontSubstitutionCheckBox.Checked := Settings.FixedFontSubstitution;
  FixedFontSubstitutesEdit.Text := Settings.FixedFontSubstitutes;

  StartupHelpCheckBox.Checked := Settings.StartupHelp;

  SmoothScrollingCheckbox.Checked := Settings.SmoothScrolling;
  IndexStyleRadioGroup.ItemIndex := integer( Settings.IndexStyle );
  UseOriginalDialogsCheckBox.Checked := Settings.UseOriginalDialogs;
  OpenWithExpandedContentsCheckBox.Checked := Settings.OpenWithExpandedContents;

  for ColorIndex := 0 to High( Settings.Colors ) do
    Colors[ ColorIndex ] := Settings.Colors[ ColorIndex ];

  DisplayColorItem( nil );

  FontDialog.Font := Font;

  BackgroundImageFilenameEdit.Text := Settings.ToolbarBackgroundImageFilename;

  ToolbarStyleRadioGroup.ItemIndex := Ord( Settings.ToolbarStyle );

  ConfirmWinHelpCheckBox.Checked := Settings.ConfirmWinHelp;

  UpdatingColor := false;

  SmoothScrollingCheckBox.Focus; // TNotebook should do this for us, but doesn't (a bug)

  OKButton.Default := true;
End;

Procedure TOptionsForm.SetFontCaptions;
begin
  NormalFontPanel.Caption := GetFontString( NormalFontPanel.Font );
  FixedFontPanel.Caption := GetFontString( FixedFontPanel.Font );
  if ApplicationFontCustomised then
    ApplicationFontPanel.Caption := GetFontString( ApplicationFontPanel.Font )
  else
    ApplicationFontPanel.Caption := '(Default)';
end;

procedure EnsureOptionsFormLoaded;
begin
  if OptionsForm = nil then
    OptionsForm := TOptionsForm.Create( nil );
end;

Initialization
  RegisterClasses ([TOptionsForm,
    TLabel, TTabbedNotebook
   , TCheckBox, TPanel, TListBox, TGroupBox,
    TCustomFontDialog, TEdit, TColorWheel, TValueBar, TTrackBar, TUpDown
   , TRadioGroup, TButton]);

  RegisterUpdateProcForLanguages( EnsureOptionsFormLoaded );
End.
