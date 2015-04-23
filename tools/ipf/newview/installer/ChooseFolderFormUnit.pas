Unit ChooseFolderFormUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
  Classes,
  Forms,
  Graphics,
  Buttons,
  CustomFileControls,
  StdCtrls;

Type
  TChooseFolderForm = Class (TForm)
    CancelButton: TButton;
    OKButton: TButton;
    DriveComboBox: TCustomDriveComboBox;
    Label1: TLabel;
    DirectoryListBox: TCustomDirectoryListBox;
    Label2: TLabel;
    Procedure ChooseFolderFormOnShow (Sender: TObject);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure DriveComboBoxOnChange (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
    Folder: string;
  End;

Var
  ChooseFolderForm: TChooseFolderForm;

Implementation

Procedure TChooseFolderForm.ChooseFolderFormOnShow (Sender: TObject);
Begin
  DirectoryListBox.Directory := Folder;
End;

Procedure TChooseFolderForm.OKButtonOnClick (Sender: TObject);
Begin
  Folder := DirectoryListBox.Directory;
End;

Procedure TChooseFolderForm.DriveComboBoxOnChange (Sender: TObject);
Begin

End;

Initialization
  RegisterClasses ([TChooseFolderForm, TButton, TCustomDriveComboBox, TLabel,
    TCustomDirectoryListBox]);
End.
