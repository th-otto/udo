unit ACLMessageForm;

interface

Uses
  CustomMemo,
  Classes, Forms, Graphics, StdCtrls,
  Buttons, ExtCtrls, Dialogs,
  SystemIconUnit;

Type
  TListHelpCallback=procedure( ListObjectRef: TObject );

  TMessageIconType = ( mitInfo, mitQuestion, mitError, mitWarning );

  TMessageForm = Class (TDialog)
    OKButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    Image: TSystemIcon;
    MessageMemo: TCustomMemo;
    ListBox: TListBox;
    Procedure HelpButtonOnClick (Sender: TObject);
    Procedure SetupShow; override;
    Destructor Destroy; override;

  public
    TheText: PChar; // pointer to zero-terminated text to put in message memo
    ShowList: boolean;
    ShowCancel: boolean;
    UseYesNo: boolean;

    IconType: TMessageIconType;

    ShowHelp: boolean;
    ListHelpCallback: TListHelpCallback;

    Procedure SetupComponent; Override;

  End;




Implementation

Uses
  SysUtils,
  ACLLanguageUnit;

{$R DialogIcons}

const
  spc = 10; // spacing

var
  OKButtonCaption: string;
  CancelButtonCaption: string;
  HelpButtonCaption: string;
  YesButtonCaption: string;
  NoButtonCaption: string;

Procedure OnLanguageEvent(Language: TLanguageFile; const Apply: boolean);
var
  tmpPrefix : String;
begin
  tmpPrefix := '';
  if Language = nil then
  begin
    OKButtonCaption := '~OK';
    CancelButtonCaption := '~Cancel';
    HelpButtonCaption := '~Help';
    YesButtonCaption := '~Yes';
    NoButtonCaption := '~No';
  end
  else
  begin
    tmpPrefix := 'MessageForm' + LANGUAGE_LABEL_DELIMITER; // use messageform captions

    Language.LL(Apply, OKButtonCaption, tmpPrefix + 'OKButtonCaption', '~OK');
    Language.LL(Apply, CancelButtonCaption, tmpPrefix + 'CancelButtonCaption', '~Cancel');
    Language.LL(Apply, HelpButtonCaption, tmpPrefix + 'HelpButtonCaption', '~Help');
    Language.LL(Apply, YesButtonCaption, tmpPrefix + 'YesButtonCaption', '~Yes');
    Language.LL(Apply, NoButtonCaption, tmpPrefix + 'NoButtonCaption', '~No');
  end;
end;

Procedure TMessageForm.SetupComponent;
begin
  Inherited SetupComponent;
  Width := 375;
  Height := 300;

  OKButton := InsertButton( self, 0, spc, 80, 30, OKButtonCaption, '' );
  CancelButton := InsertButton( self, 0, spc, 80, 30, CancelButtonCaption, '' );
  HelpButton := InsertButton( self, 0, spc, 80, 30, HelpButtonCaption, '' );
  HelpButton.OnClick := HelpButtonOnClick;

  Image := TSystemIcon.Create( self );
  Image.Parent := Self;
  Image.Left := spc;
  Image.Bottom := 220;

  MessageMemo := TCustomMemo.Create( self );
  MessageMemo.Parent := Self;
  MessageMemo.Left := 55;
  MessageMemo.Bottom := 160;
  MessageMemo.Width := 300;
  MessageMemo.Height := 105;
  MessageMemo.ParentColor := true;
  MessageMemo.BorderStyle := bsNone;
  MessageMemo.ReadOnly := true;

  ListBox := InsertListBox( self,
                            50, OKButton.Bottom + OKButton.Height + spc,
                            275, 110, '' );

end;

Procedure TMessageForm.HelpButtonOnClick (Sender: TObject);
Var
  ListObject: TObject;
  Index: longint;
Begin
  Index := ListBox.ItemIndex;
  if Index = -1 then
  begin
    ListHelpCallback( nil )
  end
  else
  begin
    ListObject := ListBox.Items.Objects[ Index ];
    ListHelpCallback( ListObject );
  end;
End;

destructor TMessageForm.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TMessageForm.SetupShow;
Var
  TextHeight: longint;
  ImageHeight: longint;
  MessageHeight: longint;
  TotalButtonWidth: longint;
  X: longint;
  DesiredClientHeight: longint;
Begin
  Inherited SetupShow;

  MessageMemo.Lines.SetText( TheText );

  TextHeight := MessageMemo.TotalHeight + 10;

  case IconType of
  mitInfo:
    Image.ID := siIconInformation;
  mitQuestion:
    Image.ID := siIconQuestion;
  mitError:
    Image.ID := siIconError;
  mitWarning:
    Image.ID := siIconWarning;
  end;

  ImageHeight := Image.Height;

  MessageHeight := TextHeight;
  if ImageHeight > TextHeight then
    MessageHeight := ImageHeight;

  MessageMemo.Height := MessageHeight;

  if ShowList then
  begin
    DesiredClientHeight := spc + OKButton.Height + spc + ListBox.Height + spc + MessageHeight + spc;
    ListBox.Show;
  end
  else
  begin
    DesiredClientHeight := spc + OKButton.Height + spc + MessageHeight + spc;
    ListBox.Hide;
  end;

  MessageMemo.Bottom := DesiredClientHeight - spc - MessageHeight;
  Image.Bottom := MessageMemo.Bottom + ( MessageHeight - ImageHeight ) div 2; // centre vertically

  MessageMemo.Left := spc + Image.Width + spc;
  ListBox.Left := MessageMemo.Left;
  ListBox.Width := ClientWidth - ( MessageMemo.Left * 2 );

  ClientHeight := DesiredClientHeight;

  TotalButtonWidth := OKButton.Width;
  if ShowHelp then
    inc( TotalButtonWidth, HelpButton.Width + spc );
  if ShowCancel then
    inc( TotalButtonWidth, CancelButton.Width + spc );
  X := ClientWidth div 2 - TotalButtonWidth div 2;

  HelpButton.Left := X;
  if ShowHelp then
    inc( X, HelpButton.Width + spc );

  OKButton.Left := X;
  inc( X, OKButton.Width + spc );

  CancelButton.Left := X;

  CancelButton.Visible := ShowCancel;
  if ShowCancel then
    CancelButton.Cancel := true
  else
    OKButton.Cancel := true; // so escape will finish the dialog

  if UseYesNo then
  begin
    OKButton.Caption := YesButtonCaption;
    OKButton.ModalResult := mrYes;
    CancelButton.Caption := NoButtonCaption;
    CancelButton.ModalResult := mrNo;
  end
  else
  begin
    OKButton.Caption := OKButtonCaption;
    OKButton.ModalResult := mrOK;
    CancelButton.Caption := CancelButtonCaption;
    CancelButton.ModalResult := mrCancel;
  end;

  HelpButton.Visible := ShowHelp;

  OKButton.Focus;

End;

Initialization
  RegisterClasses ([TButton, TImage, TMessageForm, TCustomMemo, TListBox]);

  RegisterProcForLanguages( OnLanguageEvent );

  // load our defaults in case the app using us doesn't know about languages
  OnLanguageEvent( nil, true );

end.
