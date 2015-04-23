Unit ProductInformationFormUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
  Classes,
  Forms,
  Buttons,
  StdCtrls,
  ExtCtrls,
  ACLLanguageUnit;

Type
  TProductInformationForm = Class (TForm)
    OKButton: TButton;
    NameAndVersionEdit: TEdit;
    CopyrightEdit: TEdit;
    Image1: TImage;
    Bevel1: TBevel;
    LicenseEdit: TEdit;
    TranslationInfoLabel: TLabel;
    WebPageEdit: TEdit;
    EmailEdit: TEdit;
    Procedure EmailEditOnClick (Sender: TObject);
    Procedure WebPageEditOnClick (Sender: TObject);
    Procedure ProductInformationFormOnSetupShow (Sender: TObject);
    Procedure AboutBoxOnCreate (Sender: TObject);
  Public
    Procedure OnLanguageEvent( Language: TLanguageFile;
                               const Apply: boolean );
    VersionMsg: string;
  End;

Var
  ProductInformationForm: TProductInformationForm;

procedure EnsureProductInformationFormLoaded;

Implementation

uses
  VersionUnit,
  ControlsUtility,
  WebBrowserUnit,
  DebugUnit,
  StringUtilsUnit;

Procedure TProductInformationForm.EmailEditOnClick (Sender: TObject);
Begin
  LaunchURL( 'mailto://' + EmailEdit.Text );
End;

Procedure TProductInformationForm.WebPageEditOnClick (Sender: TObject);
Begin
  LaunchURL( 'http://' + WebPageEdit.Text );
End;

Procedure TProductInformationForm.ProductInformationFormOnSetupShow (Sender: TObject);
Begin
  ScaleForm( self, 11, 16 );
End;

Procedure TProductInformationForm.OnLanguageEvent( Language: TLanguageFile;
                                                   const Apply: boolean );
var
  tmpPrefix : String;
begin
  // LogEvent(LogI18n, 'TProductInformationForm.OnLanguageEvent apply: "' + BoolToStr(Apply) + '"');
  Language.LoadComponentLanguage( self, Apply );

  tmpPrefix := 'ProductInformationForm' + LANGUAGE_LABEL_DELIMITER;

  Language.LL( Apply, VersionMsg, tmpPrefix + 'VersionMsg', 'Version: ' );
end;

Procedure TProductInformationForm.AboutBoxOnCreate (Sender: TObject);
Begin
  RegisterEventForLanguages( OnLanguageEvent );

  NameAndVersionEdit.Text := 'NewView ' + GetAppVersion;

  NameAndVersionEdit.Font := Screen.CreateCompatibleFont( Font );
  NameAndVersionEdit.Font.Attributes := [ faBold ];

  WebPageEdit.Font := Screen.CreateCompatibleFont( Font );
  WebPageEdit.Font.Attributes := [ faUnderscore ];
  EmailEdit.Font := WebPageEdit.Font;

  // custom cursor used to prevent user from selecting the text :(
  // fix in SPCC forms.pas now makes it work
  // Argh! That causes other problems, due to default cursor being set
  // by the default window proc on every mouse move... (?)

  // Might be able to use WM_CONTROLPOINTER instead... 

  //  WebPageEdit.Cursor := GetLinkCursor;
  // EmailEdit.Cursor := GetLinkCursor;
End;

procedure EnsureProductInformationFormLoaded;
begin
  if ProductInformationForm = nil then
    ProductInformationForm := TProductInformationForm.Create( nil );
end;

Initialization
  RegisterClasses ([TProductInformationForm, TButton,
    TEdit, TImage, TLabel, TBevel]);

  RegisterUpdateProcForLanguages( EnsureProductInformationFormLoaded );
End.
