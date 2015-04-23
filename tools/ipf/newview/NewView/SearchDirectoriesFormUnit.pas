Unit SearchDirectoriesFormUnit;

Interface

Uses
  Classes,
  Forms,
  Buttons,
  StdCtrls,
  ACLLanguageUnit,
  CustomFileControls;

Type
  TSearchDirectoriesForm = Class (TForm)
    OKButton: TButton;
    CancelButton: TButton;
    DirectoriesLabel: TLabel;
    HelpButton: TButton;
    AddButton: TButton;
    AddDirectoryButton: TButton;
    SubdirectoriesCheckBox: TCheckBox;
    DirectoryListBox: TCustomDirectoryListBox;
    DriveComboBox: TCustomDriveComboBox;      
    DirectoriesListBox: TListBox;
    DriveLabel: TLabel;
    DirectoryLabel: TLabel;
    Procedure SearchDirectoriesFormOnSetupShow (Sender: TObject);
    Procedure AddDirectoryButtonOnClick (Sender: TObject);
    Procedure SearchDirectoriesFormOnDestroy (Sender: TObject);
    Procedure AddButtonOnClick (Sender: TObject);
    Procedure SearchDirectoriesFormOnCreate (Sender: TObject);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure SearchDirectoriesFormOnShow (Sender: TObject);
  Protected
    Procedure ShowBrowseControls( Show: boolean );

  Public
    {Insert public declarations here}
    Procedure OnLanguageEvent( Language: TLanguageFile;
                               const Apply: boolean );

    SelectedFolders: TStringList; // input/output.
      // On input; if the associated object is non-nil, then
      // the folder will be displayed as non-selected.
    CustomDirAdded: boolean; // output
  End;

Var
  SearchDirectoriesForm: TSearchDirectoriesForm;

Implementation

Uses
  ControlsUtility,
  DebugUnit,
  StringUtilsUnit;

Procedure TSearchDirectoriesForm.SearchDirectoriesFormOnSetupShow (Sender: TObject);
Begin
  ScaleForm( self, 11, 16 );
End;

Procedure TSearchDirectoriesForm.AddDirectoryButtonOnClick (Sender: TObject);
var
  Dir: string;
  i: longint;
Begin
  Dir := DirectoryListBox.Directory;
  if SubdirectoriesCheckBox.Checked then
    Dir := Dir + '...';

  i := DirectoriesListBox.Items.IndexOf( Dir );

  if i = -1 then
  begin
    // not already present...
    i := DirectoriesListBox.Items.Add( Dir );
    CustomDirAdded := true;
  end;
  DirectoriesListBox.Selected[ i ] := true;

  DirectoriesListBox.TopIndex := i;
End;

Procedure TSearchDirectoriesForm.SearchDirectoriesFormOnDestroy (Sender: TObject);
Begin
  SelectedFolders.Destroy;
End;

// Show or hide controls so they are in the tab order when appropriate
Procedure TSearchDirectoriesForm.ShowBrowseControls( Show: boolean );
Begin
  DriveComboBox.Visible := Show;
  DirectoryListBox.Visible := Show;
  AddDirectoryButton.Visible := Show;
  SubdirectoriesCheckBox.Visible := Show;
End;

Procedure TSearchDirectoriesForm.AddButtonOnClick (Sender: TObject);
Begin
  ShowBrowseControls( true );

  ClientWidth := DirectoryListBox.Left
                 + DirectoryListBox.Width
                 + DirectoriesListBox.Left; // same margin as left
  DriveComboBox.Focus;

  AddButton.Visible := false;
End;

Procedure TSearchDirectoriesForm.OnLanguageEvent( Language: TLanguageFile;
                                                   const Apply: boolean );
begin
  // LogEvent(LogI18n, 'TSearchDirectoriesForm.OnLanguageEvent apply: "' + BoolToStr(Apply) + '"');
  Language.LoadComponentLanguage( self, Apply );
end;

Procedure TSearchDirectoriesForm.SearchDirectoriesFormOnCreate (Sender: TObject);
Begin
  RegisterEventForLanguages( OnLanguageEvent );
  ClientWidth := DirectoriesListBox.Left + DirectoriesListBox.Width + DirectoriesListBox.Left;

  ShowBrowseControls( false );

  SelectedFolders := TStringList.Create;
End;

Procedure TSearchDirectoriesForm.OKButtonOnClick (Sender: TObject);
var
  i: longint;
begin
  // SelectedDrives := '';
  SelectedFolders.Clear;
  for i := 0 to DirectoriesListBox.Items.Count -1 do
  begin
    if DirectoriesListBox.Selected[ i ] then
    begin
      LogEvent(LogDebug, 'Adding directory ' + DirectoriesListBox.Items[i]);
      SelectedFolders.Add( DirectoriesListBox.Items[i] );
    end;
  end;
end;

Procedure TSearchDirectoriesForm.SearchDirectoriesFormOnShow (Sender: TObject);
var
  i: longint;
Begin
  CustomDirAdded := false;
  OKButton.Default := true;

  DirectoriesListBox.CLear;

  for i := 0 to SelectedFolders.Count - 1 do
  begin
    DirectoriesListBox.Items.Add( SelectedFolders[ i ] );
    if SelectedFolders.Objects[ i ] = nil then
      DirectoriesListBox.Selected[ i ] := true;
  end;
End;

Initialization
  RegisterClasses ([TSearchDirectoriesForm, TButton,
    TLabel, TCustomDirectoryListBox, TCustomDriveComboBox, TListBox, TCheckBox]);
End.
