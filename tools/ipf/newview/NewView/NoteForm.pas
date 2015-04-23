Unit NoteForm;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
  Classes,
  Forms,
  StdCtrls,
  Buttons,
  ACLString,
  ACLLanguageUnit;

Type
  TNoteForm = Class (TForm)
    NoteMemo: TMemo;
    TextLabel: TLabel;
    HelpButton1: TButton;
    DeleteNoteButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    Procedure NoteFormOnSetupShow (Sender: TObject);
    Procedure NoteFormOnDestroy (Sender: TObject);
    Procedure NoteFormOnCreate (Sender: TObject);
    Procedure OKButtonOnClick (Sender: TObject);
    Procedure NoteFormOnShow (Sender: TObject);
  public
    Text: TAString;
  protected
    Procedure OnLanguageEvent( Language: TLanguageFile;
                               const Apply: boolean );
  End;

Var
  NoteForm: TNoteForm;

Implementation

uses
  SysUtils,
  ControlsUtility,
  DebugUnit,
  StringUtilsUnit;

Procedure TNoteForm.NoteFormOnSetupShow (Sender: TObject);
Begin
  ScaleForm( self, 11, 16 );
End;

Procedure TNoteForm.OnLanguageEvent( Language: TLanguageFile;
                                     const Apply: boolean );
begin
  // LogEvent(LogI18n, 'TNoteForm.OnLanguageEvent apply: "' + BoolToStr(Apply) + '"');
  Language.LoadComponentLanguage( self, Apply );
end;

Procedure TNoteForm.NoteFormOnDestroy (Sender: TObject);
Begin
  Text.Destroy;
End;

Procedure TNoteForm.NoteFormOnCreate (Sender: TObject);
Begin
  RegisterEventForLanguages( OnLanguageEvent );

  Text := TAString.Create;
End;

Procedure TNoteForm.OKButtonOnClick (Sender: TObject);
var
  P: PChar;
Begin
  P := NoteMemo.Lines.GetText;
  Text.AssignPChar( P );
  StrDispose( P );
End;

Procedure TNoteForm.NoteFormOnShow (Sender: TObject);
Begin
  OKButton.Default := true;
  NoteMemo.Lines.SetText( Text.AsPChar );
  NoteMemo.Focus;
End;

Initialization
  RegisterClasses ([TNoteForm, TMemo, TLabel, TButton]);
End.
