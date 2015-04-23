Unit MainFormUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
  OS2Def,
  PmWin,
  Classes,
  Forms,
  Graphics,
  ExtCtrls,
  Buttons,
  StdCtrls,
  TabCtrls,
  ComCtrls;

Const
  Vendor = 'Aaron Lawrence';
  Description = 'NewView Install';

  Version =        'V1.10.0'; // $SS_REQUIRE_NEW_VERSION$
  BldLevelVersion = '1.10.0'; // Embedded for IBM BLDLEVEL tool

  // BLDLevel - compatible - mostly
  EmbeddedVersion: string =
      '@#'
    + Vendor
    + ':'
    + BldLevelVersion
    + '#@'
    + Description
    + #0;

Type
  TMainForm = Class (TForm)
    CancelButton: TButton;
    BackButton: TButton;
    NextButton: TButton;
    Notebook: TNoteBook;
    Label2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    InstallProgressBar: TProgressBar;
    Label12: TLabel;
    RunAppCheckBox: TCheckBox;
    Label13: TLabel;
    Bevel1: TBevel;
    AssociateAsDefaultCheckBox: TCheckBox;
    AssociateCheckBox: TCheckBox;
    Image1: TImage;
    InstallToSourceCheckbox: TCheckBox;
    InstallTypeRadioGroup: TRadioGroup;
    InstallFolderLabel: TLabel;
    InstallFolderEdit: TEdit;
    ChooseInstallFolderButton: TButton;
    CreateIconCheckBox: TCheckBox;
    InstallTypeHelpLabel: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RestartRequiredLabel: TLabel;
    RestartCheckBox: TCheckBox;
    WelcomeLabel: TLabel;
    Label7: TLabel;
    Label15: TLabel;
    Procedure AssociateCheckBoxOnClick (Sender: TObject);
    Procedure CreateIconCheckBoxOnClick (Sender: TObject);
    Procedure InstallToSourceCheckboxOnClick (Sender: TObject);
    Procedure InstallTypeRadioGroupOnClick (Sender: TObject);
    Procedure MainFormOnCreate (Sender: TObject);
    Procedure MainFormOnCloseQuery (Sender: TObject; Var CanClose: Boolean);
    Procedure RestartCheckBoxOnClick (Sender: TObject);
    Procedure ChooseInstallFolderButtonOnClick (Sender: TObject);
    Procedure BackButtonOnClick (Sender: TObject);
    Procedure NextButtonOnClick (Sender: TObject);
    Procedure MainFormOnShow (Sender: TObject);
    Procedure Label5OnClick (Sender: TObject);
    Procedure CancelButtonOnClick (Sender: TObject);
  Protected
    Procedure EnableButtons;
    Function SkipPage( Page: longint ): boolean;
    Function GetInstallType: longint;

    FCancelled: boolean;
    FAllowClose: boolean;
    FAppInUse: boolean;
    FDLLInUse: boolean;

    FSourceDir: string;
    FSystemDir: string;
    FSystemDLLDir: string;

    FEnv_OSDir: string;
    FEnv_Programs: string;

    FStubInstallPath: string;
    FAppInstallPath: string;
    FDllInstallPath: string;

    Function Install: boolean;
    Function FullInstall: boolean;
    Function StandAloneInstall: boolean;

    Function InstallFile( const SourceFilename: string;
                          const DestinationPath: string;
                          const Backup: string;
                          const IsModule: boolean; // true if an executeable module
                          var DestInUse: boolean ): boolean;

    function InstallMultipleFiles( const Filter: string;
                                   const DestDir: string ): boolean;

    function CreateDesktopIcon( const ExePath: string;
                                const ID: string;
                                const Description: string;
                                const Associations: string ): HOBJECT;

    Procedure RunNewView;
    Procedure RefreshInstallTypeHelp;
    Procedure CheckEnvironment;

    function GetAssociations: string;
    Procedure UpdateAssociate;
  End;

Var
  MainForm: TMainForm;

const
  // RenameModule return codes
  RM_PARAM_ERROR = 1;
  RM_NAME_LENGTHS_DIFFERENT = 2;
  RM_FILE_ERROR = 3;
  RM_INVALID_FORMAT = 4;
  RM_WRONG_FORMAT = 5;
  RM_NAME_MISMATCH = 6;
  RM_WRITE_ERROR = 7;

  // RenameModule actions
  RM_RENAME_MODULE = 0;
  RM_RENAME_IMPORTED_MODULE = 1;
  RM_LIST_NAMES = 2;

imports
  function RenameModule( Filename: pchar;
                         Action: longint;
                         OldModuleName: pchar;
                         NewModuleName: pchar ): longint;
    APIENTRY;
    'RENMODUL' Name 'RenameModule';

  Function DosReplaceModule( pszOldModule: pchar;
                             pszNewModule: pchar;
                             pszBackupModule: pchar )
    : APIRET;
    apientry;
    'DOSCALLS' index 417;

end;

Implementation

uses
  BseDos,
  BseErr,
  PmWp,
  PmShl,
  PmErr,
  SysUtils,
  Dos,
  Dialogs,
  ACLUtility,
  ACLDialogs,
  ControlsUtility,
  ChooseFolderFormUnit,
  FileUtilsUnit,
  CharUtilsUnit,
  StringUtilsUnit;

{$R NewViewInstall}

const
  pgWelcome = 0;
  pgInstallType = 1;
  pgInstallFolder = 2;
  pgReady = 3;
  pgInstalling = 4;
  pgDone = 5;

const // install types
  itComplete = 0;
  itViewOnly = 1;
  itStandAlone = 2;

  ECSNewViewObjectID = '<ECS_NEWVIEW>';
  NewViewObjectID = '<NEWVIEW>';
  IPFFiles = '*.INF,*.HLP'; // NOTE: PM is case sensitive here

Procedure TMainForm.AssociateCheckBoxOnClick (Sender: TObject);
Begin
  UpdateAssociate;
End;

Procedure TMainForm.CreateIconCheckBoxOnClick (Sender: TObject);
Begin
  UpdateAssociate;
End;

Procedure TMainForm.UpdateAssociate;
Begin
  AssociateCheckBox.Enabled := CreateIconCheckBox.Checked
                               and ( GetInstallType = itStandAlone );
  AssociateAsDefaultCheckBox.Enabled := AssociateCheckBox.Enabled
                                        and AssociateCheckBox.Checked;
End;

Procedure TMainForm.InstallToSourceCheckboxOnClick (Sender: TObject);
Begin
  if InstallToSourceCheckbox.Checked then
    InstallFolderLabel.PenColor := clBtnShadow
  else
    InstallFolderLabel.ParentPenColor := true;

  InstallFolderEdit.Enabled := not InstallToSourceCheckbox.Checked;
  ChooseInstallFolderButton.Enabled := not InstallToSourceCheckbox.Checked;
End;

Function TMainForm.GetInstallType: longint;
begin
  Result := InstallTypeRadioGroup.ItemIndex;
end;

Procedure TMainForm.InstallTypeRadioGroupOnClick (Sender: TObject);
Begin
  RefreshInstallTypeHelp;
  UpdateAssociate;
End;

Procedure TMainForm.RefreshInstallTypeHelp;
var
  Help: string;
begin
  case InstallTypeRadioGroup.ItemIndex of
    itComplete:
      Help := 'This option will replace both online help and help icons. '
              + 'It will backup and replace View.exe and HelpMgr.dll.';
    itViewOnly:
      Help := 'This option will replace help icons only, by '
              + 'backing up and replacing View.exe.';
    itStandAlone:
      Help := 'This option will not change the existing help system. '
              + 'NewView will be installed as a normal application.';
  end;

  InstallTypeHelpLabel.Caption := Help;
end;

Procedure TMainForm.MainFormOnCreate (Sender: TObject);
Begin
  // set up form icons
  Forms.FormIconResourceID := 1;
  Font := GetNiceDefaultFont;
  WelcomeLabel.Font := Screen.CreateCompatibleFont( Font );
  WelcomeLabel.Font.Attributes := [ faBold ];

  CheckEnvironment;
End;

Procedure TMainForm.MainFormOnCloseQuery (Sender: TObject;
  Var CanClose: Boolean);
Begin
  if FAllowClose then
  begin
    Canclose := true;
    exit;
  end;

  FCancelled := true;
  CanClose := false;
End;

Procedure TMainForm.RestartCheckBoxOnClick (Sender: TObject);
Begin
  RunAppCheckBox.Enabled := not RestartCheckBox.Checked;
  if RestartCheckbox.Checked then
    RunAppCheckBox.Checked := false;
End;

Procedure TMainForm.ChooseInstallFolderButtonOnClick (Sender: TObject);
Begin
  ChooseFolderForm.Folder := InstallFolderEdit.Text;
  if ChooseFolderForm.ShowModal <> mrOK then
    exit;
  InstallFolderEdit.Text := ChooseFolderForm.Folder;
End;

Procedure TMainForm.BackButtonOnClick (Sender: TObject);
var
  PreviousPage: longint;
Begin
  PreviousPage := Notebook.PageIndex - 1;
  while SkipPage( PreviousPage ) do
    dec( PreviousPage );

  Notebook.PageIndex := PreviousPage;

  EnableButtons;
End;

Function TMainForm.SkipPage( Page: longint ): boolean;
begin
  Result := false;
  if Page = pgInstallFolder then
    if GetInstallType <> itStandAlone then
      result := true;
end;

Procedure TMainForm.NextButtonOnClick (Sender: TObject);
var
  NextPage: longint;
Begin
  FCancelled := false;

  NextPage := Notebook.PageIndex + 1;
  while SkipPage( NextPage ) do
    inc( NextPage );

  Notebook.PageIndex := NextPage;

  EnableButtons;

  case Notebook.PageIndex of
    pgInstalling:
    begin
      FAllowClose := false;

      if not Install then
      begin
        FAllowClose := true;
        Close;
        exit;
      end;

      FAllowClose := true;

      RestartRequiredLabel.Visible := FDLLInUse or FAppInUse;

      if FDLLInUse then
      begin
        RestartRequiredLabel.Caption :=
          'NOTE: You will need to restart your computer for '
          + 'the installation to take effect.';

        RestartCheckBox.Visible := true;
      end
      else
      begin
        RestartCheckBox.Visible := false;

        if FAppInUse then
        begin
          RestartRequiredLabel.Caption :=
            'NewView is currently running. Restart it to activate the new version.';
          RunAppCheckBox.Checked := false;
          RunAppCheckBox.Enabled := false;

        end;
      end;

      Notebook.PageIndex := Notebook.PageIndex + 1;

      EnableButtons;

    end;

    pgDone:
    begin
      Close;
      if RestartCheckBox.Checked then
      begin
        // prevent ourselves from hanging the shutdown
        WinShutdownSystem( AppHandle, HMQ_CURRENT )
      end
      else if RunAppCheckBox.Checked then
      begin
        RunNewView;
      end;
    end;
  end;
End;

Function GetEnvironmentFolder( const VariableName: string ): string;
begin
  Result := GetEnv( VariableName );
  if Result <> '' then
    if not DirectoryExists( Result ) then
      Result := '';

  // make sure it ends in a backslash
  if Result <> '' then
    Result := AddDirectorySeparator( Result );
end;

Procedure TMainForm.CheckEnvironment;
begin
  FSourceDir := GetApplicationDir;

  FSystemDir := GetBootDriveLetter + ':\os2\';
  FSystemDLLDir := FSystemDir + 'dll\';

  // ecs things
  FEnv_OSDir := GetEnvironmentFolder( 'OSDIR' );
  FEnv_Programs := GetEnvironmentFolder( 'PROGRAMS' );
end;

Procedure TMainForm.MainFormOnShow (Sender: TObject);
Begin
  Notebook.PageIndex := 0;
  EnableButtons;

  // default standalone dir

  if FEnv_Programs <> '' then
    InstallFolderEdit.Text := AddDirectorySeparator(FEnv_Programs) + 'NewView'
  else
    InstallFolderEdit.Text := GetBootDriveLetter + ':\NewView';

  CreateIconCheckBox.Checked := true;

  RefreshInstallTypeHelp;
  UpdateAssociate;

  FAllowClose := true;
End;

Procedure TMainForm.EnableButtons;
Begin
  BackButton.Visible :=     ( Notebook.PageIndex > 0 )
                        and ( Notebook.PageIndex < pgInstalling );
  NextButton.Enabled :=    ( Notebook.PageIndex < pgInstalling )
                        or ( Notebook.PageIndex = pgDone );

  if Notebook.PageIndex < pgReady then
    NextButton.Caption := '~Next >'
  else if Notebook.PageIndex = pgReady then
    NextButton.Caption := '~Install >'
  else
    NextButton.Caption := '~Close';

  CancelButton.Enabled := Notebook.PageIndex < pgDone;

End;

Procedure TMainForm.Label5OnClick (Sender: TObject);
Begin

End;

Procedure TMainForm.CancelButtonOnClick (Sender: TObject);
Begin
  Close;
End;

// Install specified module from source, to dest.
// If backup is not '' then the original file will
// be copied to Backup.
// If the file is in use then:
// If IsModule is false then the install will fail.
// If IsModule is true then DosReplaceModule will
// be used to unlock the module, and DestInUse will be set true.
Function TMainForm.InstallFile( const SourceFilename: string;
                                const DestinationPath: string;
                                const Backup: string;
                                const IsModule: boolean; // true if an executeable module
                                var DestInUse: boolean ): boolean;
var
  rc: APIRET;
  szDest: cstring;
  szSource: cstring;
  szBackup: cstring;
  FileHandle: HFILE;
  ActionTaken: ULONG;
  SourcePath: string;
begin
  Result := false;
  // DestInUse := false;

  SourcePath := FSourceDir + SourceFilename;

  // Check the source file exists.
  if not FileExists( SourcePath ) then
  begin
    DoErrorDlg( 'Internal Error',
                'The file '
                + SourcePath
                + ' was not found for installation' );
    exit;
  end;

  // Convert to null-terminated strings
  szDest := DestinationPath;
  szSource := SourcePath;
  szBackup := Backup;

  // If the destination exists, unlock and back it up
  if FileExists( DestinationPath ) then
  begin
    if FileIsReadOnly( DestinationPath ) then
    begin
      DoErrorDlg( 'Installation Error',
                  'The file ' + StrCRLF
                  + ' ' + DestinationPath + StrCRLF
                  + 'is read-only and cannot be replaced.' );
      exit;
    end;
    // see if it's in use.
    rc := DosOpen( szDest,
                   FileHandle,
                   ActionTaken,
                   0, // new size: not used
                   0, // attributes: not used
                   OPEN_ACTION_FAIL_IF_NEW
                   + OPEN_ACTION_OPEN_IF_EXISTS,
                   OPEN_FLAGS_FAIL_ON_ERROR
                   + OPEN_SHARE_DENYREADWRITE
                   + OPEN_ACCESS_READWRITE,
                   nil ); // e.a.s: not used
    DosClose( FileHandle );

    if rc = ERROR_SHARING_VIOLATION then
    begin
      // file in use
      DestInUse := true;

      if not IsModule then
      begin
        // Show error. It would be nicer to
        // fall back on alternative update method e.g.
        // locked file device driver IBMLANLK.SYS
        // But that's overkill for NewView
        DoErrorDlg( 'Installation Error',
                    'This file is in use: ' + StrCRLF
                    + ' ' + DestinationPath + StrCRLF
                    + 'and cannot be replaced.' );
        exit;
      end;

      // unlock the module
      rc := DosReplaceModule( Addr( szDest ),
                              nil,
                              nil );

      if rc <> 0 then
      begin
        // error
        DoErrorDlg( 'Install Error',
                    'Could not unlock ' + StrCRLF
                    + ' ' + DestinationPath + StrCRLF
                    + SysErrorMessage( rc ) );

        exit;
      end;
    end
    else if rc <> 0 then
    begin
      DoErrorDlg( 'Install Error',
                  'Unable to acces ' + StrCRLF
                  + ' ' + DestinationPath + StrCRLF
                  + SysErrorMessage( rc ) );
      exit;
    end;

    // OK, done...

    if Backup <> '' then
    begin
      // make backup if it doesn't already exist.
      if not FileExists( Backup ) then
      begin
        rc := DosCopy( szDest,
                       szBackup,
                       0 ); // no special options (don't overwrite).
        if rc <> 0 then
        begin
          // error
          DoErrorDlg( 'Install Error',
                      'Could not backup ' + StrCRLF
                      + ' ' + DestinationPath + StrCRLF
                      + ' to' + StrCRLF
                      + ' ' + Backup + StrCRLF
                      + StrCRLF
                      + SysErrorMessage( rc ) );
          exit;
        end;
      end;
    end;
  end;

  // OK, now copy the new file on
  rc := DosCopy( szSource,
                 szDest,
                 DCPY_EXISTING ); // overwrite
  if rc <> 0 then
  begin
    // error
    DoErrorDlg( 'Install Error',
                'Could not copy new file ' + StrCRLF
                + ' ' + SourcePath + StrCRLF
                + ' to' + StrCRLF
                + ' ' + DestinationPath + StrCRLF
                + StrCRLF
                + SysErrorMessage( rc ) );
    exit;
  end;

  // done
  result := true;
end;

function TMainForm.InstallMultipleFiles( const Filter: string;
                                         const DestDir: string ): boolean;
var
  Files: TStringList;
  i: longint;
  InUse: boolean;
begin
  Result := false;

  Files := TStringList.Create;
  ListFilesInDirectory( FSourceDir,
                 Filter,
                 false, // don't need subdirs
                 Files); // don't need subdirs

  for i := 0 to Files.Count - 1 do
  begin
    if not InstallFile( Files[ i ],
                        DestDir + Files[ i ],
                        '', // no backup
                        false, // not in use
                        InUse ) then
      exit;
  end;
  Result := true;
end;

const
  FilterAssociationsKey = 'PMWP_ASSOC_FILTER';
  MAX_HANDLE_TEXT_SIZE = 10;

function ReadAssociatedObjects( const Filter: string;
                                ObjectList: TList ): boolean;
var

  HandleListSize: ULONG;
  pHandleListData: pchar;
  pHandleString: pchar;
  HandleString: string;
  Handle: HOBJECT;
  RemainingLength: longint;
begin
  Result := false;

  if not PrfQueryProfileSize( HINI_USER,
                              FilterAssociationsKey,
                              Filter,
                              HandleListSize ) then
    exit;

  GetMem( pHandleListData, HandleListSize );

  FillMem( pHandleListData, HandleListSize, $ff );

  if not PrfQueryProfileData( HINI_USER,
                              FilterAssociationsKey,
                              Filter,
                              pHandleListData^,
                              HandleListSize ) then
  begin
    FreeMem( pHandleListData, HandleListSize );
    exit;
  end;

  try
    pHandleString := pHandleListData;
    while ( pHandleString < pHandleListData + HandleListSize ) do
    begin
      // work out remaining length of buffer
      // so we don't overrun it if the data is invalid, ie. non terminated
      RemainingLength := PCharPointerDiff( pHandleListData + HandleListSize,
                                    pHandleString );
      HandleString := StrPasWithLength( pHandleString, RemainingLength );

      // convert to integer object handle
      Handle := StrToInt( HandleString );
      ObjectList.Add( pointer( Handle ) );

      // skip to next in data
      pHandleString := pHandleString + Length( HandleString ) + 1;
    end;
  except
    begin
      FreeMem( pHandleListData, HandleListSize );
      ObjectList.Destroy;
      exit;
    end;
  end;

  FreeMem( pHandleListData, HandleListSize );
  Result := true;
end;

function WriteAssociatedObjects( const Filter: string;
                                 ObjectList: TList ): boolean;
var

  HandleListSize: ULONG;
  pHandleListData: pchar;
  pHandleString: pchar;
  HandleString: string;
  Handle: HOBJECT;
  i: longint;
  ActualLength: longint;
begin
  Result := false;

  HandleListSize := ObjectList.Count * MAX_HANDLE_TEXT_SIZE;
  GetMem( pHandleListData, HandleListSize );

  pHandleString := pHandleListData;

  for i := 0 to ObjectList.Count - 1 do
  begin
    Handle := HOBJECT( ObjectList[ i ] );
    HandleString := IntToStr( Handle );

    MemCopy( Addr( HandleString[ 1 ] ),
             pHandleString,
             Length( HandleString ) );

    pHandleString := pHandleString + Length( HandleString );

    // zero terminate this entry
    pHandleString^ := #0;
    inc( pHandleString );
  end;

  // additional terminator... AssoEdit does this... is it needed?
  pHandleString^ := #0;
  inc( pHandleString );

  ActualLength := PCharPointerDiff( pHandleString, pHandleListData );
  result := PrfWriteProfileData( HINI_USER,
                                 FilterAssociationsKey,
                                 Filter,
                                 pHandleListData^,
                                 ActualLength );

  FreeMem( pHandleListData, HandleListSize );
end;

function MakeDefaultAssociation( const Filter: string;
                                 hDesktopObject: HObject ): boolean;
var
  ObjectList: TList;
  i: longint;
begin
  ObjectList := TList.Create;
  result := false;

  if not ReadAssociatedObjects( Filter, ObjectList ) then
  begin
    DoErrorDlg( 'Association',
                'Unable to read associations for ' + Filter );
    ObjectList.Destroy;
    exit;
  end;

  // find object in existing list
  i := ObjectList.IndexOf( pointer( hDesktopObject ) );
  if i <> - 1 then
    // found, delete it
    ObjectList.Delete( i );

  ObjectList.Insert( 0, pointer( hDesktopObject ) );

  result := WriteAssociatedObjects( Filter, ObjectList );

  if not result then
    DoErrorDlg( 'Association',
                'Unable to update associations for ' + Filter );

  ObjectList.Destroy;
end;

// association one of more file filters,
// separated by commas, with the given object
function MakeDefaultAssociations( const aMask: string;
                                  hDesktopObject: HOBJECT ): boolean;
var
  tmpMask : String;
  tmpMasks : TStringList;
  i : longint;
begin
  Result := false;

  tmpMasks := TStringList.Create;
  StrExtractStrings(tmpMasks, aMask, [','], #0);

  for i := 0 to tmpMasks.Count - 1 do
  begin
    tmpMask := tmpMasks[i];
    if not makeDefaultAssociation(tmpMask, hDesktopObject ) then
    begin
      tmpMasks.Destroy;
      exit;
    end;
  end;

  tmpMasks.Destroy;

  Result := true;
end;

function TMainForm.CreateDesktopIcon( const ExePath: string;
                                      const ID: string;
                                      const Description: string;
                                      const Associations: string ): HOBJECT;
var
  szSetupString: cstring;
  PMError: ERRORID;
begin
  szSetupString := 'PROGTYPE=PM;EXENAME='
                   + ExePath
                   + ';OBJECTID='
                   + ID;
  if Associations <> '' then
    szSetupString := szSetupString
                     + ';ASSOCFILTER='
                     + Associations;
  Result :=
    WinCreateObject( 'WPProgram', // class
                     Description,
                     szSetupString, // setup string
                     '<WP_DESKTOP>',
                     CO_REPLACEIFEXISTS );

  if Result <> NULLHANDLE then
    // OK
    exit;

  // error
  PMError := WinGetLastError( AppHandle );

  // Handle a few specific errors

  case ( PMError and $ffff ) of
    WPERR_INVALID_FOLDER:
      DoErrorDlg( 'Warning',
                  'Unable to create desktop icon:' + StrCRLF
                  + IntToHex( PMError, 8 )
                  + ': The desktop is not correctly installed '
                  + '(<WP_DESKTOP> missing). ' );

    WPERR_NOT_WORKPLACE_CLASS:
      DoErrorDlg( 'Warning',
                  'Unable to create desktop icon:' + StrCRLF
                  + IntToHex( PMError, 8 )
                  + ': WPProgram class is missing.' );

    else
      DoErrorDlg( 'Installation Error',
                  'Unable to create desktop icon' + StrCRLF
                  + IntToHex( PMError, 8 )
                  + ': There may be some problem with the desktop.' );
  end;
end;

Function TMainForm.Install: boolean;
begin
  if GetInstallType = itStandAlone then
    result := StandAloneInstall
  else
    result := FullInstall;
end;

function CheckConflicts( const VarNames: string;
                         const CorrectPath: string ): boolean;
var
  Files: TStringList;
  i: longint;
  FileName: string;
  tmpVarNames : TStringList;
  FileDir: string;
  CorrectDir: string;
begin
  Files := TStringList.Create;

  // ignore duplicates if found by multiple path vars
  Files.Duplicates := dupIgnore;

  FileName := ExtractFileName( CorrectPath );

  tmpVarNames := TStringList.Create;
  StrExtractStrings(tmpVarNames, VarNames, [';'], #0);
  for i := 0 to tmpVarNames.Count - 1 do
  begin
    GetFilesInPath( tmpVarNames[i], FileName, Files );
  end;
  tmpVarNames.Destroy;

  CorrectDir := ExtractFilePath( CorrectPath );

  // delete the correct path, if found
  // or files in the current (install) directory
  // - found if . is in path
  i := 0;
  while i < Files.Count do
  begin
    // where is the file?
    FileDir := ExtractFilePath( Files[ i ] );

    // if it's where we're aiming for then that's fine
    if    StrEqualIgnoringCase( FileDir, CorrectDir )
       or StrEqualIgnoringCase( FileDir, GetApplicationDir )
      then
      Files.Delete( i )
    else
      inc( i );
  end;

  if Files.Count > 0 then
    Result :=
      DoConfirmListDlg( 'Duplicates Warning',
                        'The file'
                        + StrCRLF
                        + '  ' + FileName
                        + StrCRLF
                        + 'will be installed to '
                        + StrCRLF
                        + '  ' + ExtractFilePath( CorrectPath )
                        + StrCRLF
                        + 'but there are other copies on your computer. '
                        + 'The wrong file might be used. '
                        + 'Continue?',
                        Files )
  else
    Result := true;
  Files.Destroy;
end;

function TMainForm.GetAssociations: string;
begin
  if AssociateCheckBox.Checked then
    Result := IPFFiles
  else
    Result := '';
end;

function CopyFileError( const Source: string;
                        const Dest: string ): boolean;
begin
  Result := CopyFile( Source,
                      Dest  );
  if not result then
    DoErrorDlg( 'Copy Error',
                'Error copying '
                + Source
                + ' to '
                + Dest );
end;

// Do a full install, replacing parts of the operating system
// as needed.
// Either view only, or view and helpmgr
Function TMainForm.FullInstall: boolean;
var
  LanguageDir: string;
  HelpDir: string;
  BookDir: string;
  DocDir: string;
  AppDir: string;
  Dummy: boolean;
  ProgramObjectHandle: HOBJECT;
  ObjectID: string;
  rc: longint;
  HelpMgrBackupPath: string;
  StubBackupPath: string;
  IBMHelpMgrPath: cstring;
  IBMStubPath: cstring;
  ViewDocPath: cstring;
  ViewDocBackupPath: cstring;
begin
  Result := false;

  FAppInUse := false;
  FDLLInUse := false;

  InstallProgressBar.Position := 0;
  Application.ProcessMessages;

  // validate system path
  if not DirectoryExists( FSystemDir ) then
  begin
    DoErrorDlg( 'System Folder Error',
                'The system folder '
                + FSystemDir
                + ' does not exist!' );
    exit;
  end;

  if GetInstallType = itComplete then
  begin
    // validate system DLL path
    if not DirectoryExists( FSystemDLLDir ) then
    begin
      DoErrorDlg( 'System Folder Error',
                  'The system DLL folder '
                  + FSystemDLLDir
                  + ' does not exist!' );
      exit;
    end;
  end;

  // Validate help directory...
  if FEnv_OSDir <> '' then
    HelpDir := FEnv_OSDir + 'help\'
  else
    HelpDir := FSystemDir + 'help\';

  if not DirectoryExists( HelpDir ) then
  begin
    DoErrorDlg( 'System Folder Error',
                'The system help folder '
                + HelpDir
                + ' does not exist!' );
    exit;
  end;

  if FEnv_OSDir <> '' then
    BookDir := FEnv_OSDir + 'book\'
  else
    BookDir := FSystemDir + 'book\';

  // Docs: Use a subdirectory
  if FEnv_OSDir <> '' then
    DocDir := FEnv_OSDir + 'doc\NewView\'
  else
    DocDir := BookDir + 'NewView\';

  if not DirectoryExists( DocDir ) then
  begin
  try
      MakeDirs( DocDir );
    except
      on E: EInOutError do
      begin
        DoErrorDlg( 'Folder Error',
                    'Could not create the NewView doc folder '
                    + DocDir+ StrCRLF
                    + SysErrorMessage( E.ErrorCode ) );
        exit;
      end;
    end;
  end;

  // install viewer app to either x:\os2
  // or on eCS, %OSDIR%\bin
  if FEnv_OSDir <> '' then
  begin
    // ecs - with a dir specified
    AppDir := FEnv_OSDir + 'bin\';
  end
  else
  begin
    // OS/2
    AppDir := FSystemDir;
  end;

  LanguageDir := AppDir; // for now.

  // Where shall we put the programs eh?
  FAppInstallPath := AppDir + 'NewView.exe';
  FStubInstallPath := FSystemDir + 'view.exe';
  FDllInstallPath := FSystemDLLDir + 'newview.dll';

  // check for existing files that might conflict
  if not CheckConflicts( 'PATH',
                         FAppInstallPath ) then
    exit;

  if not CheckConflicts( 'PATH',
                         FStubInstallPath ) then
    exit;

  if not CheckConflicts( 'HELP;BOOKSHELF',
                         HelpDir + 'newview*.hlp' ) then
    exit;

  {
  // Doh! Not possible as LIBPATH is not an environment variable,
  // and there is no API to get it. Primitive... :/
  if not CheckConflicts( 'LIBPATH',
                         FDllInstallPath ) then
    exit;
  }

  InstallProgressBar.Position := 10;
  // ------------------------------------------

  // Main program
  if not InstallFile( 'NewView.exe',
                      FAppInstallPath,
                      '', // no backup
                      true,
                      FAppInUse ) then
    exit;

  InstallProgressBar.Position := 20;
  // ------------------------------------------

  // Stub (View.exe)
  StubBackupPath := ChangeFileExt( FStubInstallPath, '.bak' );
  if not InstallFile( 'ViewStub.exe',
                      FStubInstallPath,
                      StubBackupPath,
                      true,
                      FAppInUse ) then
    exit;

  IBMStubPath := FSystemDir + 'ibmview.exe';
  if not FileExists( IBMStubPath ) then
  begin
    // copy view.bak to ibmview.exe
    if not CopyFileError( StubBackupPath,
                          IBMStubPath ) then
      exit;

    rc := RenameModule( Addr( IBMStubPath ),
                        RM_RENAME_IMPORTED_MODULE,
                        'HELPMGR',
                        'IBMHMGR' );
    if rc <> 0 then
    begin
      DoErrorDlg( 'Rename Module Error',
                  'Error changing references to HelpMgr DLL in '
                  + IBMStubPath
                  + ': '
                  + IntToStr( rc ) );
      exit;
    end;
  end;;

  // backup viewdoc.exe
  ViewDocPath := FSystemDir + 'viewdoc.exe';
  ViewDocBackupPath := FSystemDir + 'viewdoc.bak';
  if not FileExists( ViewDocBackupPath ) then
    if not CopyFileError( ViewDocPath,
                          ViewDocBackupPath ) then
      exit;

  // In this case we do actually have to modify the
  // original file; because original View is hardcoded
  // with the name of viewdoc.exe (AFAIK)
  rc := RenameModule( Addr( ViewDocPath ),
                      RM_RENAME_IMPORTED_MODULE,
                      'HELPMGR',
                      'IBMHMGR' );
  if rc <> 0 then
  begin
    DoErrorDlg( 'Rename Module Error',
                'Error changing references to HelpMgr DLL in '
                + ViewDocPath
                + ': '
                + IntToStr( rc ) );
    exit;
  end;

  InstallProgressBar.Position := 30;
  // ------------------------------------------

  // Help Manager DLL
  if GetInstallType = itComplete then
  begin
    HelpMgrBackupPath := FSystemDLLDir + 'HelpMgr.bak';
    if not InstallFile( 'HelpMgr.dll',
                        FSystemDLLDir + 'HelpMgr.dll',
                        HelpMgrBackupPath,
                        true,
                        FDLLInUse ) then
      exit;

    // if needed, copy backed up file to ibmhmgr.dll,
    // do internal rename
    IBMHelpMgrPath := FSystemDLLDir + 'ibmhmgr.dll';

    if not FileExists( IBMHelpMgrPath ) then
    begin
      if not CopyFileError( HelpMgrBackupPath,
                            IBMHelpMgrPath ) then
        exit;

      rc := RenameModule( Addr( IBMHelpMgrPath ),
                          RM_RENAME_MODULE,
                          'HELPMGR',
                          'IBMHMGR' );
      if rc <> 0 then
      begin
        DoErrorDlg( 'Rename Module Error',
                    'Error changing old HelpMgr DLL module name: '
                    + IntToStr( rc ) );
        exit;
      end;
    end;

  end;

  InstallProgressBar.Position := 35;
  // ------------------------------------------

  // newview.dll
  if not InstallFile( 'NewView.dll',
                      FDllInstallPath,
                      '', // no backup
                      false, // not in use
                      Dummy ) then
    exit;

  InstallProgressBar.Position := 40;
  // ------------------------------------------

  // Help files
  if not InstallMultipleFiles( '*.hlp',
                               HelpDir ) then
    exit;

  // delete old newview.inf help files

  // shouldn't have gone in the \os2\ dir
  if FileExists( FSystemDir + 'newview.inf' ) then
    DeleteFile( FSystemDir + 'newview.inf' );

  // and we no longer want the .inf file at all
  if FileExists( BookDir + 'newview.inf' ) then
    DeleteFile( BookDir + 'newview.inf' );

  InstallProgressBar.Position := 50;
  // ------------------------------------------

  // Text files
  if not InstallMultipleFiles( '*.txt',
                               DocDir ) then
    exit;

  InstallProgressBar.Position := 60;
  // ------------------------------------------

  // Language files
  if not InstallMultipleFiles( '*.lng',
                               LanguageDir ) then
    exit;

  InstallProgressBar.Position := 80;
  // ------------------------------------------

  // Desktop icon
  // create new object
  if CreateIconCheckBox.Checked then
  begin
    // see if this is ECS with NewView
    ProgramObjectHandle :=
      WinQueryObject( ECSNewViewObjectID );

    if ProgramObjectHandle <> NULLHANDLE then
      // yes, replace that
      ObjectID := ECSNewViewObjectID
    else
      // no, create our own
      ObjectID := NewViewObjectID;

    if CreateDesktopIcon( FAppInstallPath,
                          ObjectID,
                          'Help Viewer',
                          IPFFiles // always associate
                          ) = NULLHANDLE then
      exit;
  end;

  InstallProgressBar.Position := 100;

  Result := true;

end;

// Do a standalone install. Don't touch the operating system.
Function TMainForm.StandAloneInstall: boolean;
var
  InstallDir: string;
  Dummy: boolean;
  hDesktopObject: HOBJECT;
begin
  Result := false;

  FAppInUse := false;
  FDLLInUse := false;

  InstallProgressBar.Position := 0;
  Application.ProcessMessages;

  // validate/create install dir
  InstallDir := AddDirectorySeparator(InstallFolderEdit.Text);
  if InstallToSourceCheckbox.Checked then
  begin
    InstallDir := FSourceDir;
  end
  else if not DirectoryExists( InstallDir ) then
  begin
    try
      MakeDirs( InstallDir );
    except
      on E: EInOutError do
      begin
        DoErrorDlg( 'Folder Error',
                    'Could not create the installation folder '
                    + InstallDir + StrCRLF
                    + SysErrorMessage( E.ErrorCode ) );
        exit;
      end;
    end;
  end;

  // Where to put programs
  FAppInstallPath := InstallDir + 'NewView.exe';
  FStubInstallPath := InstallDir + 'ViewStub.exe';
  FDllInstallPath := InstallDir + 'newview.dll';

  // check for existing files that might conflict
  if not CheckConflicts( 'PATH',
                         FAppInstallPath ) then
    exit;

  if not CheckConflicts( 'PATH',
                         FStubInstallPath ) then
    exit;

  if not CheckConflicts( 'HELP;BOOKSHELF',
                         InstallDir + 'newview*.hlp' ) then
    exit;

  // if not installing as-is...
  if UpperCase( FSourceDir ) <> UpperCase( InstallDir ) then
  begin
    // Main program
    if not InstallFile( 'NewView.exe',
                        FAppInstallPath,
                        '', // no backup
                        true,
                        FAppInUse ) then
      exit;

    InstallProgressBar.Position := 20;
    // ------------------------------------------

    // Stub
    if not InstallFile( 'ViewStub.exe',
                        FStubInstallPath,
                        '', // no backup
                        true,
                        FAppInUse ) then
      exit;

    InstallProgressBar.Position := 40;
    // ------------------------------------------

    // newview.dll
    if not InstallFile( 'NewView.dll',
                        FDllInstallPath,
                        '', // no backup
                        false, // not in use
                        Dummy ) then
      exit;

    if FileExists( InstallDir + 'newview.inf' ) then
      DeleteFile( InstallDir + 'newview.inf' );

    // Help files
    if not InstallMultipleFiles( '*.hlp',
                                 InstallDir ) then
      exit;

    InstallProgressBar.Position := 50;
    // ------------------------------------------

    // Text files
    if not InstallMultipleFiles( '*.txt',
                                 InstallDir ) then
      exit;

    InstallProgressBar.Position := 60;
    // ------------------------------------------

    // Language files
    if not InstallMultipleFiles( '*.lng',
                                 InstallDir ) then
      exit;
  end;

  InstallProgressBar.Position := 80;
  // ------------------------------------------

  // Desktop icon
  if CreateIconCheckBox.Checked then
  begin
    hDesktopObject := CreateDesktopIcon( FAppInstallPath,
                                         NewViewObjectID,
                                         'NewView',
                                         GetAssociations );
    if hDesktopObject = NULLHANDLE then
      exit;
    if AssociateCheckBox.Checked then
      if AssociateAsDefaultCheckBox.Checked then
        if not MakeDefaultAssociations( IPFFiles,
                                        hDesktopObject ) then
          exit;
  end;

  InstallProgressBar.Position := 100;

  Result := true;
end;

Procedure TMainForm.RunNewView;
begin
  Exec( FAppInstallPath, '' );
end;

Initialization
  RegisterClasses ([TMainForm, TLabel, TButton, TNoteBook,
    TCheckBox, TProgressBar, TBevel, TRadioGroup, TEdit, TImage]);
End.
