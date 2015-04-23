Unit ACLDialogs;
// A variety of useful message box functions, including displaying
// lists. They all allow specification of a caption.

 Interface

Uses
  Classes,
{$ifdef os2}
  ACLMessageForm
{$else}
  Controls,
  MessageFormWin
{$endif}
  ;

// Shows a message box
Procedure DoMessageDlg( Caption: String;
                        Message: string );

// Shows an error message box
Procedure DoErrorDlg( Caption: String;
                      Message: string );

// Shows a warning message box
Procedure DoWarningDlg( Caption: String;
                        Message: string );

// Shows a long message box
Procedure DoLongMessageDlg( Caption: String;
                            Message: PChar );

// Shows a dialog with OK and cancel buttons
// Returns true if OK pressed
Function DoConfirmDlg( Caption: string;
                       Message: string ): boolean;

// Returns true if confirmation given.
Function DoConfirmListDlg( Caption: string;
                           Message: string;
                           List: TStrings ): boolean;

// Shows a message containing a list
Procedure DoMessageListDlg( Caption: string;
                            Message: string;
                            List: TStrings );

// Shows an error message containing a list
Procedure DoErrorListDlg( Caption: string;
                          Message: string;
                          List: TStrings );

// Returns true if yes is clicked
Function DoYesNoListDlg( Caption: string;
                         Message: string;
                         List: TStrings ): boolean;

// Returns true if yes is clicked
Function DoYesNoDlg( Caption: string;
                     Message: string ): boolean;

// Shows a message containing a list
// with a help callback for items in the list
Procedure DoMessageListHelpDlg( Caption: string;
                                Message: string;
                                List: TStrings;
                                ListHelpCallback: TListHelpCallback );

{$ifdef os2}
Function DoInputQuery( Const ACaption: String;
                       Const APrompt: String;
                       Var Value: String ): Boolean;

{$endif}

Implementation

uses
  SysUtils,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
{$ifdef os2}
  ACLLanguageUnit, ControlsUtility,
{$endif}
  CharUtilsUnit,
  DebugUnit;

// -------------------------------------------------

Function DoACLDialog( const Caption: string;
                      const Message: string;
                      const List: TStrings;
                      const ShowCancel: boolean;
                      const IconType: TMessageIconType;
                      const ShowHelp: boolean;
                      const UseYesNo: boolean;
                      const ListHelpCallBack: TListHelpCallBack ): TModalResult;
var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog := TMessageForm.Create( nil );
  TheDialog.Caption := Caption;
  PMessage := NewPCharAsCopyOfStr(Message);
  TheDialog.TheText := PMessage;

  TheDialog.ShowCancel := ShowCancel;
  TheDialog.IconType := IconType;
  TheDialog.ShowHelp := ShowHelp;
  TheDialog.UseYesNo := UseYesNo;
  TheDialog.ListHelpCallBack := ListHelpCallBack;

  if List <> nil then
  begin
    TheDialog.ShowList := true;
    TheDialog.ListBox.Items.Assign( List );
  end
  else
  begin
    TheDialog.ShowList := false;
  end;

  Result := TheDialog.ShowModal;

  TheDialog.Destroy;
  StrDispose( PMessage );
end;

Procedure DoMessageListDlg( Caption: string;
                            Message: string;
                            List: TStrings );
Begin
  DoACLDialog( Caption,
               Message,
               List,
               false, // show cancel
               mitInfo,
               false, // show help
               false, // use yes no
               nil
               );
End;

Procedure DoMessageListHelpDlg( Caption: string;
                                Message: string;
                                List: TStrings;
                                ListHelpCallback: TListHelpCallback );
Begin
  DoACLDialog( Caption,
               Message,
               List,
               false, // show cancel
               mitInfo,
               true, // show help
               false, // use yes no
               ListHelpCallBack
               );
End;

Function DoConfirmListDlg( Caption: string;
                           Message: string;
                           List: TStrings ): boolean;
Begin
  Result :=
    DoACLDialog( Caption,
                 Message,
                 List,
                 true, // show cancel
                 mitQuestion,
                 false, // show help
                 false, // use yes no
                 nil // no help callback
               ) = mrOK;
End;

Function DoConfirmDlg( Caption: string;
                       Message: string ): boolean;
Begin
  Result :=
    DoACLDialog( Caption,
                 Message,
                 nil, // no list
                 true, // show cancel
                 mitQuestion,
                 false, // show help
                 false, // use yes no
                 nil // no help callback
               ) = mrOK;
End;

Procedure DoLongMessageDlg( Caption: String;
                            Message: PChar );
Var
  TheDialog: TMessageForm;
Begin
  TheDialog := TMessageForm.Create( nil );
  TheDialog.Caption := Caption;
  TheDialog.TheText := Message;

  TheDialog.ShowList := false;
  TheDialog.ShowCancel := false;
  TheDialog.IconType := mitInfo;
  TheDialog.ShowHelp := false;
  TheDialog.UseYesNo := false;

  TheDialog.ShowModal;
  TheDialog.Destroy;
End;

Procedure DoMessageDlg( Caption: String;
                        Message: string );
Begin
  DoACLDialog( Caption,
               Message,
               nil, // no list
               false, // show cancel
               mitInfo,
               false, // show help
               false, // use yes no
               nil // no help callback
             );
End;

Procedure DoErrorListDlg( Caption: string;
                          Message: string;
                          List: TStrings );
Begin
  DoACLDialog( Caption,
               Message,
               List,
               false, // show cancel
               mitError,
               false, // show help
               false, // use yes no
               nil // no help callback
             );
End;

Procedure DoErrorDlg( Caption: String;
                      Message: string );
Begin
  DoACLDialog( Caption,
               Message,
               nil, // no list
               false, // show cancel
               mitError,
               false, // show help
               false, // use yes no
               nil // no help callback
             );
End;

Procedure DoWarningDlg( Caption: String;
                        Message: string );
begin
  DoACLDialog( Caption,
               Message,
               nil, // no list
               false, // show cancel
               mitWarning,
               false, // show help
               false, // use yes no
               nil // no help callback
             );
end;

Function DoYesNoListDlg( Caption: string;
                         Message: string;
                         List: TStrings ): boolean;
Begin
  Result :=
    DoACLDialog( Caption,
                 Message,
                 List,
                 true, // show "cancel" (=no)
                 mitQuestion,
                 false, // show help
                 true, // use yes no
                 nil // no help callback
               ) = mrYes;
End;

Function DoYesNoDlg( Caption: string;
                     Message: string ): boolean;
Begin
  Result :=
    DoACLDialog( Caption,
                 Message,
                 nil, // no list
                 true, // show "cancel" (=no)
                 mitQuestion,
                 false, // show help
                 true, // use yes no
                 nil // no help callback
               ) = mrYes;
End;

{$ifdef os2}

var
  OKButtonCaption: string;
  CancelButtonCaption: string;

Procedure OnLanguageEvent(Language: TLanguageFile; const Apply: boolean);
var
  tmpPrefix : String;
begin
  if Language = nil then
  begin
    OKButtonCaption := '~OK';
    CancelButtonCaption :='~Cancel';
  end
  else
  begin
    tmpPrefix := 'TextInputForm' + LANGUAGE_LABEL_DELIMITER; // use messageform captions
    Language.LL(Apply, OKButtonCaption, tmpPrefix + 'OKButtonCaption', '~OK');
    Language.LL(Apply, CancelButtonCaption, tmpPrefix + 'CancelButtonCaption', '~Cancel');
  end;
end;

type
  TACLQueryDialog = class( TDialog )
    FEdit: TEdit;
    FMessageLabel: TLabel;
    FOKButton: TButton;
    FCancelButton: TButton;
    procedure SetupComponent; override;
    procedure SetupShow; override;
  end;

procedure TACLQueryDialog.SetupComponent;
begin
  inherited SetupComponent;

  Name := 'TextInputForm';

  ClientWidth := 340;
  ClientHeight := 120;

  FMessageLabel := InsertLabel( self, 10, 90, 320, 20, '' );

  FEdit := TEdit.Create( self );
  FEdit.SetWindowPos( 10, 60, 320, 20 );
  FEdit.parent := self;
  FEdit.TabOrder := 0;
  FEdit.AutoSize := true;

  FOKButton := InsertButton( self, 10, 10, 90, 30, OKButtonCaption, '' );
  FOKButton.Name := 'OKButton';
  FOKButton.ModalResult := mrOK;
  FOKButton.Default := true;
  FOKButton.TabOrder := 1;

  FCancelButton := InsertButton( self, 120, 10, 90, 30, CancelButtonCaption, '' );
  FCancelButton.Name := 'CancelButon';
  FCancelButton.ModalResult := mrCancel;
  FCancelButton.Cancel := true;
  FCancelButton.TabOrder := 2;

end;

procedure TACLQueryDialog.SetupShow;
begin
  ScaleForm( self, 11, 16 );
  FOKButton.Default := true;
  FEdit.Focus;
end;

Var
  QueryDlg: TACLQueryDialog;

// This is a copy of InputQuery from SPCC with the following changes:
// - slight layout mods
// - normal buttons instead of bitmap buttons
// - buttons are centered like my other popup dialogs
Function DoInputQuery( Const ACaption: String;
                       Const APrompt: String;
                       Var Value: String ): Boolean;
Begin
  if QueryDlg = nil then
  begin
    QueryDlg := TACLQueryDialog.Create( Screen.ActiveForm );
  end;

  QueryDlg.Caption := ACaption;
  QueryDlg.FMessageLabel.Caption := APrompt;
  QueryDlg.FEdit.Text := Value;

  QueryDlg.Execute;
  Case QueryDlg.ModalResult Of
     cmOk:
     Begin
       Value := QueryDlg.FEdit.Text;
       Result := True;
     End;

     Else
     Begin
       Result := False;
     End;
  End; {Case}

End;

{$endif}

{$ifdef os2}
Initialization
  RegisterProcForLanguages( OnLanguageEvent );

  // load our defaults in case the app using us doesn't know about languages
  OnLanguageEvent( nil, true );

Finalization

// I think application .Destroy will do this.
//  if QueryDlg <> nil then
//    QueryDlg.Destroy;

{$endif}

End.
