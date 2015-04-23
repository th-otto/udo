Unit FileDialogForm;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

// This form is a generic, sizeable file dialog. I never
// got round to making it a seperate thing. Better would be
// to enhance the one in SPCC.

Uses
  Classes,
  Forms,
  StdCtrls,
  Buttons,
  Messages,
  CustomFileControls,
  SplitBar,
  MultiColumnListBox,
  ACLLanguageUnit;

// Note: filters have the form:
// <Description 1>|<filename mask 1>|<Description 2>|<filename mask 2>...

function DoSaveFileDialog( const Caption: string;
                           const Filters: string;
                           const DefaultFilename: string;
                           var Directory: string;
                           var Filename: string ): boolean;

function DoOpenFileDialog( const Caption: string;
                           const Filters: string;
                           const DefaultFilename: string;
                           var Directory: string;
                           var Filename: string ): boolean;

function DoOpenMultiFileDialog( const Caption: string;
                                const Filters: string;
                                const DefaultFilename: string;
                                Var Directory: string;
                                Var KeepCurrent: boolean;
                                Filenames: TStrings ): boolean;

Const
  WM_CHECKFOCUS = WM_USER + 103;

Type
  TFileDialogForm = Class (TForm)
    FilenameEdit: TEdit;
    FileNameLabel: TLabel;
    KeepCurrentCheckBox: TCheckBox;
    CompletionsListBox: TListBox;
    FilesLabel: TLabel;
    FilterLabel: TLabel;
    DrivesLabel: TLabel;
    DirectoriesLabel: TLabel;
    DirectoryListBox: TCustomDirectoryListBox;
    DriveComboBox: TCustomDriveComboBox;
    HelpButton: TButton;
    FileListBox: TMultiColumnListBox;
    FilterComboBox: TCustomFilterComboBox;
    OKButton: TButton;
    CancelButton: TButton;
    SplitBar: TSplitBar;
    Procedure FileDialogFormOnSetupShow (Sender: TObject);
    Procedure FilterComboBoxOnChange (Sender: TObject);
    Procedure DirectoryListBoxOnChange (Sender: TObject);
    Procedure CancelButtonOnEnter (Sender: TObject);
    Procedure OKButtonOnEnter (Sender: TObject);
    Procedure FilterComboBoxOnEnter (Sender: TObject);
    Procedure FileListBoxOnEnter (Sender: TObject);
    Procedure DirectoryListBoxOnEnter (Sender: TObject);
    Procedure DriveComboBoxOnEnter (Sender: TObject);
    Procedure CompletionsListBoxOnExit (Sender: TObject);
    Procedure FilenameEditOnChange (Sender: TObject);
    Procedure FilenameEditOnExit (Sender: TObject);
    Procedure FilenameEditOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure CompletionsListBoxOnScan (Sender: TObject;
      Var KeyCode: TKeyCode);
    Procedure FileListBoxOnItemSelect (Sender: TObject; Index: LongInt);
    Procedure FileDialogFormOnDismissDlg (Sender: TObject);
    Procedure FileDialogFormOnResize (Sender: TObject);
    Procedure SplitBarOnChange (NewSplit: LongInt);
    Procedure FileListBoxOnDblClick (Sender: TObject);
    Procedure FileDialogFormOnShow (Sender: TObject);
    Procedure FileDialogFormOnDestroy (Sender: TObject);
    Procedure FileListBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure FileDialogFormOnCreate (Sender: TObject);
  Protected

    Split: real;
    Filenames: TStringList;
    RequireFileExists: boolean;
    DefaultFilename: string;
    FocussingFile: boolean;
    FileMask: string;
    Procedure LayoutControls;
    Procedure ShowCompletions;
    Procedure ReadFiles;

  Protected
    Procedure OnLanguageEvent( Language: TLanguageFile;
                               const Apply: boolean );
    InvalidFilterErrorTitle: string;
    InvalidFilterError: string;
    FileNotFoundErrorTitle: string;
    FileNotFoundError: string;
    MultiSelectErrorTitle: string;
    MultiSelectError: string;

  Public
    Procedure WMCheckFocus( Var Msg: TMessage ); message WM_CHECKFOCUS;
  End;

Implementation

uses
  BseDos,
  OS2Def,
  PmWin,
  SysUtils,
  FileUtilsUnit,
  ACLDialogs,
  ACLString,
  AStringUtilityUnit,
  ControlsUtility,
  SettingsUnit,
  HelpFile,
  StringUtilsUnit,
  DebugUnit;

Imports
  // Redeclared since the Sibyl declaration passes text as a cstring :(
  Function _WinSetWindowText( ahwnd: HWND;
                              pszText: pchar ): BOOL;
                              APIENTRY;
                              'PMWIN' index 877;

  Function _WinQueryWindowText( ahwnd: HWND;
                                cchBufferMax: LONG;
                                pchBuffer: pchar ): LONG;
                                APIENTRY;
                                'PMWIN' index 841;

end;

Procedure TFileDialogForm.FileDialogFormOnSetupShow (Sender: TObject);
Begin
  ScaleForm( self, 11, 16 );

  FileNameEdit.YAlign := yaTop;
  FileNameEdit.xStretch := xsFrame;
  FileNameLabel.YAlign := yaTop;

  CompletionsListBox.YAlign := yaTop;
  CompletionsListBox.xStretch := xsFrame;

  FilterComboBox.YAlign := yaTop;
  FilterLabel.YAlign := yaTop;
  DriveComboBox.YAlign := yaTop;
  DrivesLabel.YAlign := yaTop;
  DirectoryListBox.YStretch := ysFrame;
  DirectoriesLabel.YAlign := yaTop;
  FileListBox.yStretch := ysFrame;
  FilesLabel.YAlign := yaTop;
  FileNames := TStringList.Create;
  SplitBar.YStretch := ysFrame;

  LayoutControls;
End;

Procedure TFileDialogForm.FilterComboBoxOnChange (Sender: TObject);
Begin
  FileMask := FilterComboBox.Mask;
  FileNameEdit.Text := FileMask;
  ReadFiles;
End;

Procedure TFileDialogForm.DirectoryListBoxOnChange (Sender: TObject);
Begin
  ReadFiles;
End;

Procedure TFileDialogForm.CancelButtonOnEnter (Sender: TObject);
Begin
  CompletionsListBox.Hide;
End;

Procedure TFileDialogForm.OKButtonOnEnter (Sender: TObject);
Begin
  CompletionsListBox.Hide;
End;

Procedure TFileDialogForm.FilterComboBoxOnEnter (Sender: TObject);
Begin
  CompletionsListBox.Hide;
End;

Procedure TFileDialogForm.FileListBoxOnEnter (Sender: TObject);
Begin
  CompletionsListBox.Hide;
End;

Procedure TFileDialogForm.DirectoryListBoxOnEnter (Sender: TObject);
Begin
  CompletionsListBox.Hide;
End;

Procedure TFileDialogForm.DriveComboBoxOnEnter (Sender: TObject);
Begin
  CompletionsListBox.Hide;
End;

Procedure TFileDialogForm.CompletionsListBoxOnExit (Sender: TObject);
Begin
End;

Procedure TFileDialogForm.FilenameEditOnChange (Sender: TObject);
Begin
  if FocussingFile then
    exit;
  ShowCompletions;
End;

Procedure TFileDialogForm.FilenameEditOnExit (Sender: TObject);
Begin
End;

Procedure TFileDialogForm.WMCheckFocus( Var Msg: TMessage );
begin
end;

Procedure TFileDialogForm.FilenameEditOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  if KeyCode = kbCDown then
  begin
    if CompletionsListBox.Visible then
    begin
      CompletionsListBox.ItemIndex := 0;
      CompletionsListBox.Focus;
      KeyCode := kbNull;
    end;
  end
  else if KeyCode = kbTab then
  begin
    DriveComboBox.Focus;
  end
  else
  begin
    ShowCompletions;
  end;
End;

Procedure TFileDialogForm.CompletionsListBoxOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  if KeyCode = kbCR then
  begin
    if CompletionsListBox.ItemIndex <> -1 then
    begin
      FilenameEdit.Text := CompletionsListBox.Items[ CompletionsListBox.ItemIndex ];
      FilenameEdit.Focus;
      ShowCompletions;
      KeyCode := kbNull; // eat the keystroke
    end;
  end
  else if KeyCode = kbCUp then
  begin
    if CompletionsListBox.ItemIndex = 0 then
    begin
      CompletionsListBox.ItemIndex := -1;
      FilenameEdit.Focus;
      KeyCode := kbNull;
    end;
  end;
End;

Procedure TFileDialogForm.ShowCompletions;
var
  i: integer;
  search: string;
  filename: string;
  ShowList: boolean;
  tmpNameAndTitle: string;
Begin
  CompletionsListBox.Items.Clear;
  search := FilenameEdit.Text;

  if Search <> '' then
  begin
    for i := 0 to FileListBox.Items.Count - 1 do
    begin
      tmpNameAndTitle := FileListBox.Items[ i ];
      Filename := StrLeftUntil(tmpNameAndTitle, [StrTAB]);

      if StrStartsWithIgnoringCase(filename, search) then
        CompletionsListBox.Items.Add( filename );
    end;
  end;

  ShowList := false;
  if CompletionsListBox.Items.Count = 1 then
  begin
    if not StrEqualIgnoringCase(CompletionsListBox.Items[0], search) then
      ShowList := true;
  end
  else if CompletionsListBox.Items.Count > 0 then
  begin
    ShowList := true;
  end;

  if ShowList then
  begin
    CompletionsListBox.BringToFront;
    CompletionsListBox.Height := ( CompletionsListBox.Items.Count + 1 )
                                 * CompletionsListBox.ItemHeight
                                 + 6;
    CompletionsListBox.Bottom := FilenameEdit.Bottom
                                 - CompletionsListBox.Height;
  end;

  CompletionsListBox.Visible := ShowList;

End;

Procedure TFileDialogForm.FileListBoxOnItemSelect (Sender: TObject;
  Index: LongInt);
Begin
  OKButton.Click;
End;

Procedure TFileDialogForm.FileDialogFormOnDismissDlg (Sender: TObject);
Begin
  WriteWindowPos( self );
  Settings.FileDialogSplit := Split;
End;

Procedure TFileDialogForm.FileDialogFormOnResize (Sender: TObject);
Begin
  LayoutControls;
End;

Procedure TFileDialogForm.SplitBarOnChange (NewSplit: LongInt);
Begin
  Split := NewSplit / ClientWidth;

  if Split < 0.2 then
    Split := 0.2;
  if Split > 0.8 then
    Split := 0.8;

  LayoutControls;
End;

Procedure TFileDialogForm.LayoutControls;
var
  SplitX: longint;
  LeftPaneWidth: longint;
  RightPaneWidth: longint;
  RightPaneX: longint;
begin
  SplitX := round( ClientWidth * Split );
  LeftPaneWidth := SplitX - 8; // note we are not including borders here
  RightPaneWidth := ClientWidth - SplitX - 8;
  RightPaneX := SplitX + 3;

  DrivesLabel.Width := LeftPaneWidth;
  DriveComboBox.Width := LeftPaneWidth;

  DirectoriesLabel.Width := LeftPaneWidth;
  DirectoryListBox.Width := LeftPaneWidth;

  FilesLabel.Left := RightPaneX;
  FilesLabel.Width := RightPaneWidth;
  FileListBox.Left := RightPaneX;
  FileListBox.Width := RightPaneWidth;

  FilterLabel.Left := RightPaneX;
  FilterLabel.Width := RightPaneWidth;
  FilterComboBox.Left := RightPaneX;
  FilterComboBox.Width := RightPaneWidth;

  SplitBar.Left := SplitX - 3;
end;

Procedure TFileDialogForm.FileListBoxOnDblClick (Sender: TObject);
Begin
  OKButton.Click;
End;

Procedure TFileDialogForm.FileDialogFormOnShow (Sender: TObject);
Begin
  Split := Settings.FileDialogSplit;

  ReadWindowPos( self );

  OKButton.Default := true;

  // get some more space in the edit field
  SendMsg( FilenameEdit.Handle,
           EM_SETTEXTLIMIT,
           1024,
           0 );

  FilenameEdit.Text := DefaultFilename;
  FilenameEdit.Focus;

  // re-read files
  ReadFiles;

  ShowCompletions;

  KeepCurrentCheckBox.Checked := false;
End;

Procedure TFileDialogForm.FileDialogFormOnDestroy (Sender: TObject);
Begin
  FileNames.Destroy;
End;

Procedure TFileDialogForm.FileListBoxOnItemFocus (Sender: TObject;
  Index: LongInt);
var
  FileIndex: longint;
  NameAndTitle: string;
  FilenamesString: TAString;
Begin
  FileNames.Clear;
  for FileIndex := 0 to FileListBox.Items.Count - 1 do
  begin
    if FileListBox.Selected[ FileIndex ] then
    begin
      NameAndTitle := FileListBox.Items[ FileIndex ];
      FileNames.Add(StrLeftUntil(NameAndTitle, [StrTAB]));
    end;
  end;
  FocussingFile := true;
  FilenamesString := TAString.Create;
  ListToAString( Filenames, FilenamesString, '+' );
  _WinSetWindowText( FileNameEdit.Handle,
                     FilenamesString.AsPChar );
  FilenamesString.Destroy;
  FocussingFile := false;
End;

Procedure TFileDialogForm.OKButtonOnClick (Sender: TObject);
var
  FileNameText: string;
  FileName: string;
  Directory: string;
  NewDirectory: string;
  FilePath: string;
  FilenameString: TAString;
  i: longint;
Begin
  FileNameText := trim( FileNameEdit.Text );
  if FileNameText = '' then
    exit;

  if    ( Pos( '*', FileNameText ) > 0 )
     or ( Pos( '?', FileNameText ) > 0 ) then
  begin
    if    ( Pos( '\', FileNameText ) > 0 )
       or ( Pos( ':', FileNameText ) > 0 )
       or ( Pos( '/', FileNameText ) > 0 )
       then
    begin
      DoErrorDlg( InvalidFilterErrorTitle,
                  StrInDoubleQuotes(FileNameText)
                  + InvalidFilterError
                  + StrCRLF
                  + '  \ / :' );
      exit;
    end;

    // Treat as a filter
    FileMask := FileNameText;
    ReadFiles;

    exit;
  end;

  // First, see if it's a directory to change to
  // (in order to support typing directories, either full or relative)
  Directory := DirectoryListBox.Directory;
  NewDirectory := ExpandPath( Directory, FileNameText );

  DosErrorAPI( FERR_DISABLEHARDERR );

  if DirectoryExists( NewDirectory ) then
  begin
    // Yes, the typed text is a directory, so change to it.
    DirectoryListBox.Directory:= NewDirectory;
    FileNameEdit.Text := '';
    DosErrorAPI( FERR_ENABLEHARDERR );

    exit;
  end;

  // No, the text entered is a filename or set of filenames
  // Break it up into individual filenames at '+' char
  // Check each file exists

  FilenameString := TAString.Create;
  FilenameString.Length := WinQueryWindowTextLength( FileNameEdit.Handle );
  _WinQueryWindowText( FileNameEdit.Handle,
                       FilenameString.Length + 1, // allow zero term
                       FilenameString.AsPChar );

  FileNames.Clear;

  AStringToList( FilenameString, Filenames, '+' );

  for i := 0 to Filenames.Count - 1 do
  begin
    FileName := Filenames[ i ];

    // Work out directory
    FilePath := ExtractFilePath( FileName );
    FilePath := ExpandPath( Directory, FilePath );

    FileName := AddDirectorySeparator( FilePath )
                + ExtractFileName( FileName );
    if RequireFileExists then
    begin
      if not FileExists( FileName ) then
      begin
        DoErrorDlg( FileNotFoundErrorTitle,
                    FileNotFoundError + Filename );
        DosErrorAPI( FERR_ENABLEHARDERR );
        FilenameString.Destroy;
        exit;
      end;
    end;
    FileNames[ i ] := FileName;
  end;

  FilenameString.Destroy;

  DosErrorAPI( FERR_ENABLEHARDERR );

  if not FilelistBox.MultiSelect then
  begin
    if FileNames.Count > 1 then
    begin
      DoErrorDlg( MultiSelectErrorTitle,
                  MultiSelectError );
      exit;
    end;
  end;
  // Done
  DismissDlg( mrOK );
End;

Procedure TFileDialogForm.OnLanguageEvent( Language: TLanguageFile;
                                           const Apply: boolean );
var
  tmpPrefix : String;
begin
  // LogEvent(LogI18n, 'TFileDialogForm.OnLanguageEvent apply: "' + BoolToStr(Apply) + '"');
  Language.LoadComponentLanguage( self, Apply );

  tmpPrefix := 'FileDialogForm' + LANGUAGE_LABEL_DELIMITER;

  Language.LL( Apply, InvalidFilterErrorTitle, tmpPrefix + 'InvalidFilterErrorTitle', 'File Filter Error' );
  Language.LL( Apply,
               InvalidFilterError,
               tmpPrefix + 'InvalidFilterError',
               ' is not a valid filename filter. '
               + 'You cannot use any of these characters: ' );
  Language.LL( Apply, FileNotFoundErrorTitle, tmpPrefix + 'FileNotFoundErrorTitle', 'File Not Found' );
  Language.LL( Apply, FileNotFoundError, tmpPrefix + 'FileNotFoundError', 'File does not exist:' );
  Language.LL( Apply, MultiSelectErrorTitle, tmpPrefix + 'MultiSelectErrorTitle', 'Multi-Select' );
  Language.LL( Apply, MultiSelectError, tmpPrefix + 'MultiSelectError', 'You can only select one file' );
end;

Procedure TFileDialogForm.FileDialogFormOnCreate (Sender: TObject);
Begin
  RegisterEventForLanguages( OnLanguageEvent );

  FileMask := '*.*';
End;

Procedure TFileDialogForm.ReadFiles;
var
  Filenames: TStringList;
  i: longint;

  Filename: string;
  Title: string;
begin
  Filenames := TStringList.Create;

  DosErrorAPI( FERR_DISABLEHARDERR );

  ListFilesInDirectory( DirectoryListBox.Directory,
                        FileMask,
                        false,
                        Filenames);

  Filenames.Sort;

  FileListBox.Items.BeginUpdate;
  FileListBox.Items.Clear;

  for i := 0 to Filenames.Count - 1 do
  begin
    Filename := Filenames[ i ];

    Title := GetHelpFileTitle( AddDirectorySeparator( DirectoryListBox.Directory )
                               + Filename );

    FileListBox.Items.Add(Filename + StrTAB + Title );
  end;
  FileListBox.Items.EndUpdate;

  DosErrorAPI( FERR_ENABLEHARDERR );

  Filenames.Destroy;
end;

// ----------------------------------------------------------------------

Var
  FileDialogForm: TFileDialogForm;

procedure EnsureFileDialogFormLoaded;
begin
  if FileDialogForm = nil then
    FileDialogForm := TFileDialogForm.Create( nil );
end;

function DoSaveFileDialog( const Caption: string;
                           const Filters: string;
                           const DefaultFilename: string;
                           Var Directory: string;
                           Var Filename: string ): boolean;
begin
  EnsureFileDialogFormLoaded;

  FileDialogForm.Caption := Caption;
  FileDialogForm.FilelistBox.MultiSelect := false;
  FileDialogForm.RequireFileExists := false;
  FileDialogForm.FilterComboBox.Filter := Filters;
  FileDialogForm.DirectoryListBox.Directory := Directory;
  FileDialogForm.DefaultFilename := DefaultFilename;
  FileDialogForm.KeepCurrentCheckBox.Visible := false;

  Result := FileDialogForm.ShowModal = mrOK;

  if Result then
  begin
    Directory := FileDialogForm.DirectoryListBox.Directory;
    Filename := FileDialogForm.Filenames[ 0 ];
  end;

end;

function DoOpenFileDialog( const Caption: string;
                           const Filters: string;
                           const DefaultFilename: string;
                           Var Directory: string;
                           Var Filename: string ): boolean;
begin
  EnsureFileDialogFormLoaded;

  FileDialogForm.Caption := Caption;
  FileDialogForm.FilelistBox.MultiSelect := false;
  FileDialogForm.RequireFileExists := true;
  FileDialogForm.FilterComboBox.Filter := Filters;
  FileDialogForm.DirectoryListBox.Directory := Directory;
  FileDialogForm.DefaultFilename := DefaultFilename;
  FileDialogForm.KeepCurrentCheckBox.Visible := false;

  Result := FileDialogForm.ShowModal = mrOK;

  if Result then
  begin
    Directory := FileDialogForm.DirectoryListBox.Directory;
    Filename := FileDialogForm.Filenames[ 0 ];
  end;
end;

function DoOpenMultiFileDialog( const Caption: string;
                                const Filters: string;
                                const DefaultFilename: string;
                                Var Directory: string;
                                Var KeepCurrent: boolean;
                                Filenames: TStrings ): boolean;
begin
  EnsureFileDialogFormLoaded;

  FileDialogForm.Caption := Caption;
  FileDialogForm.FilelistBox.MultiSelect := true;
  FileDialogForm.RequireFileExists := true;
  FileDialogForm.FilterComboBox.Filter := Filters;
  FileDialogForm.DirectoryListBox.Directory := Directory;
  FileDialogForm.DefaultFilename := DefaultFilename;

  FileDialogForm.KeepCurrentCheckBox.Checked := KeepCurrent;
  FileDialogForm.KeepCurrentCheckBox.Visible := true;

  Result := FileDialogForm.ShowModal = mrOK;

  if Result then
  begin
    Directory := FileDialogForm.DirectoryListBox.Directory;
    Filenames.Assign( FileDialogForm.Filenames );
    KeepCurrent := FileDialogForm.KeepCurrentCheckBox.Checked;
  end;
end;

Initialization
  RegisterClasses ([TFileDialogForm, TEdit, TLabel,
    TCustomDirectoryListBox, TCustomDriveComboBox,
    TCustomFilterComboBox, TSplitBar, TButton,
    TListBox, TMultiColumnListBox, TCheckBox]);

  RegisterUpdateProcForLanguages( EnsureFileDialogFormLoaded );
End.
