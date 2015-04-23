
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit Dialogs;


Interface

{$IFDEF OS2}
Uses BseDos,BseErr,PmWin,PmStdDlg;
{$ENDIF}
{$IFDEF Win95}
Uses WinDef,WinBase,WinUser,CommDlg;
{$ENDIF}

Uses Dos,SysUtils,Classes,Graphics,Forms,Buttons,StdCtrls,ExtCtrls,ComCtrls,
     FileCtrl,Printers;

Type
    TDialog=Class(TForm)
      Protected
         Procedure SetupComponent;Override;
         Property AutoScroll;
         Property EnableDocking;
         Property HorzScrollBar;
         Property MinTrackWidth;
         Property MinTrackHeight;
         Property MaxTrackWidth;
         Property MaxTrackHeight;
         Property Menu;
         Property FormStyle;
         Property VertScrollBar;
         Property OnMDIActivate;
         Property OnMDIDeactivate;
         Property OnMenuInit;
         Property OnMenuEnd;
         Property OnMenuItemFocus;
      Public
         Function Execute:Boolean;Virtual;
         Property Align;
         Property BorderIcons;
         Property BorderStyle;
         Property Bottom;
         Property ClientHeight;
         Property ClientWidth;
         Property Color;
         Property Cursor;
         Property Enabled;
         Property Font;
         Property Height;
         Property Hint;
         Property Icon;
         Property Left;
         Property PenColor;
         Property PopupMenu;
         Property Right;
         Property ScrollBars;
         Property ShowHint;
         Property Top;
         Property Visible;
         Property Width;
         Property WindowState;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;

         Property OnActivate;
         Property OnClose;
         Property OnCloseQuery;
         Property OnCommand;
         Property OnCreate;
         Property OnDeactivate;
         Property OnDestroy;
         Property OnDismissDlg;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnHide;
         Property OnKeyPress;
         Property OnMaximize;
         Property OnMinimize;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnMove;
         Property OnPaint;
         Property OnResize;
         Property OnRestore;
         Property OnScan;
         Property OnSetupShow;
         Property OnShow;
         Property OnTranslateShortCut;
    End;


    TSystemOpenSaveDialog=Class(TComponent)
      Private
         FOkName:String;
         FTitle:String;
         FFileName:String;
         FDefaultExt:String;
         FFilter:String;
         FFilterIndex:LongInt;
         FMaskList:TStringList;
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
      Published
         Property DefaultExt:String Read FDefaultExt Write FDefaultExt;
         Property FileName:String Read FFileName Write FFileName;
         Property Filter:String Read FFilter Write FFilter;
         Property FilterIndex:LongInt Read FFilterIndex Write FFilterIndex;
         Property OkName:String Read FOkName Write FOkName;
         Property Title:String Read FTitle Write FTitle;
    End;


    TSystemOpenDialog=Class(TSystemOpenSaveDialog)
      Protected
         Procedure SetupComponent;Override;
      Public
         Function Execute:Boolean;
    End;


    TSystemSaveDialog=Class(TSystemOpenSaveDialog)
      Protected
         Procedure SetupComponent;Override;
      Public
         Function Execute:Boolean;
    End;


    TOpenDialog=Class(TDialog)
      Private
         FCurDir:String;
         FTitle:String;
         FFileName:String;
         FFilter:String;
         FFilterIndex:LongInt;
         FDefaultExt:String;
         FOkName:String;
         FFileNameEdit:TEdit;
         FFilterCombo:TFilterComboBox;
         FDriveCombo:TDriveComboBox;
         FFileList:TFileListBox;
         FDirectoryList:TDirectoryListBox;
         FCurrentNamePanel:TPanel;
         FOkButton:TBitBtn;
         FCancelButton:TBitBtn;
         FHelpButton:TBitBtn;
         Procedure SetFileName(Value:String);
         Function GetFileName:String;
         Procedure SetCurDir(Value:String);
         Procedure FileChange(Sender:TObject);
         Procedure FileSelect(Sender:TObject;Index:LongInt);
         Procedure EvKillFocus(Sender:TObject);
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Procedure DismissDlg(Result:TCommand);Override;
         Procedure AddFilter(Name,Mask:String);
         Property Caption;
      Published
         Property DefaultExt:String Read FDefaultExt Write FDefaultExt;
         Property FileName:String Read FFileName Write FFileName;
         Property Filter:String Read FFilter Write FFilter;
         Property FilterIndex:LongInt Read FFilterIndex Write FFilterIndex;
         Property OkName:String Read FOkName Write FOkName;
         Property Title:String Read FTitle Write FTitle;
    End;


    TSaveDialog=Class(TOpenDialog)
      Private
         FCreateButton:TSpeedButton;
         Procedure EvCreateDir(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
    End;


    TCreateDirDialog=Class(TDialog)
      Private
         FOkName:String;
         FDirectory:String;
         FChangeDir:Boolean;
         FDirEdit:TEdit;
         FChangeCheck:TCheckBox;
         FOkButton:TBitBtn;
         FCancelButton:TBitBtn;
         FHelpButton:TBitBtn;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Procedure DismissDlg(Result:TCommand);Override;
      Published
         Property ChangeDir:Boolean Read FChangeDir Write FChangeDir;
         Property Directory:String Read FDirectory Write FDirectory;
         Property OkName:String Read FOkName Write FOkName;
    End;


    TChangeDirDialog=Class(TDialog)
      Private
         FOkName:String;
         FDirectory:String;
         FFileNameEdit:TEdit;
         FDriveCombo:TDriveComboBox;
         FDirectoryList:TDirectoryListBox;
         FOkButton:TBitBtn;
         FCancelButton:TBitBtn;
         FCreateButton:TBitBtn;
         FHelpButton:TBitBtn;
         Procedure DirectoryChange(Sender:TObject);
         Procedure EvCreateDir(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Function Execute:Boolean;Override;
      Published
         Property Directory:String Read FDirectory Write FDirectory;
         Property OkName:String Read FOkName Write FOkName;
    End;


    {$M+}
    TFindDirection = (fdForward,fdBackward);
    TFindOrigin    = (foEntireScope,foCursor);
    TFindScope     = (fsGlobal,fsSelection);
    TFindOptions   = Set Of (foCaseSensitive,foWordsOnly);
    {$M-}

    TFindDialog=Class(TDialog)
      Private
         Lab_Find:TLabel;
         CoB_Find:TComboBox;
         Grp_Options:TGroupBox;
         ChB_CaseSense:TCheckBox;
         ChB_WordsOnly:TCheckBox;
         Grp_Scope:TGroupBox;
         RaB_Global:TRadioButton;
         RaB_Selection:TRadioButton;
         Grp_Origin:TGroupBox;
         RaB_EntireScope:TRadioButton;
         RaB_Cursor:TRadioButton;
         Grp_Direction:TGroupBox;
         RaB_Forward:TRadioButton;
         RaB_Backward:TRadioButton;
         BiB_Find:TBitBtn;
         BiB_Cancel:TBitBtn;
         BiB_Help:TBitBtn;
         FFindTextExt:String;
         Function GetFindOptions:TFindOptions;
         Procedure SetFindOptions(Value:TFindOptions);
         Function GetFindOrigin:TFindOrigin;
         Procedure SetFindOrigin(Value:TFindOrigin);
         Function GetFindScope:TFindScope;
         Procedure SetFindScope(Value:TFindScope);
         Function GetFindDirection:TFindDirection;
         Procedure SetFindDirection(Value:TFindDirection);
         Function GetFindText:String;
         Procedure SetFindText(Const Value:String);
         Procedure SetFindTextExtend(Const Value:String);
         Procedure SetFindHistory(Const Strings:TStringList);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Property FindHistory:TStringList Write SetFindHistory;
      Published
         Property Options:TFindOptions Read GetFindOptions Write SetFindOptions;
         Property Origin:TFindOrigin Read GetFindOrigin Write SetFindOrigin;
         Property Scope:TFindScope Read GetFindScope Write SetFindScope;
         Property Direction:TFindDirection Read GetFindDirection Write SetFindDirection;
         Property FindText:String Read GetFindText Write SetFindText;
         Property FindTextExtend:String Read FFindTextExt Write SetFindTextExtend;
    End;


    TReplaceDialog=Class(TFindDialog)
      Private
         CoB_Replace:TComboBox;
         ChB_Confirm:TCheckBox;
         Function GetConfirm:Boolean;
         Procedure SetConfirm(Value:Boolean);
         Function GetReplaceText:String;
         Procedure SetReplaceText(Const Value:String);
         Procedure SetReplaceHistory(Const Strings:TStringList);
      Protected
         Procedure SetupComponent;Override;
      Public
         Property ReplaceHistory:TStringList Write SetReplaceHistory;
      Published
         Property Confirm:Boolean Read GetConfirm Write SetConfirm;
         Property ReplaceText:String Read GetReplaceText Write SetReplaceText;
    End;


    TColorDialog=Class(TDialog)
      Private
         FSelColor:TColor;
         FRedScroll,FGreenScroll,FBlueScroll:TScrollBar;
         FColorArea:TPanel;
         FOkBtn:TBitBtn;
         FDefaultCombo:TComboBox;
         Procedure SetSelColor(Value:TColor);
         Procedure EvSelectComboItem(Sender:TObject;Index:LongInt);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);Override;
         Procedure UpdateColorArea;
      Public
         Property RGBColor:TColor Read FSelColor Write SetSelColor;
    End;


    TFontDialog=Class(TDialog)
      Private
         FNameCombo:TComboBox;
         FSizeCombo:TComboBox;
         FExampleText:TButton;
         FItalicCheck:TCheckBox;
         FBoldCheck:TCheckBox;
         FOutlineCheck:TCheckBox;
         FUnderscoreCheck:TCheckBox;
         FStrikeOutCheck:TCheckBox;
         FOkBtn:TBitBtn;
         Function GetFontName:String;
         Procedure SetFontName(Value:String);
         Function GetFaceName:String;
         Procedure SetFaceName(Value:String);
         Function GetPointSize:LongInt;
         Procedure SetPointSize(Value:LongInt);
         Procedure SetTheFont;
         Procedure InsertSizes(Var TheFont:TFont);
         Procedure EvComboSelect(Sender:TObject;Index:LongInt);
         Procedure EvComboSizeSelect(Sender:TObject;Index:LongInt);
         Function GetEditFont:TFont;
         Procedure SetEditFont(NewFont:TFont);
         Function GetAttributes:TFontAttributes;
         Procedure SetAttributes(NewValue:TFontAttributes);
         Procedure StyleChanged(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Property FaceName:String Read GetFaceName Write SetFaceName;
         Property PointSize:LongInt Read GetPointSize Write SetPointSize;
      Published
         Property FontName:String Read GetFontName Write SetFontName;
         Property EditFont:TFont Read GetEditFont Write SetEditFont;
         Property Attributes:TFontAttributes Read GetAttributes Write SetAttributes;
    End;


    TPrinterSetupDialog = Class (TDialog)
      Private
         FPrinterListHeadLine: TLabel;
         FPrinterList: TListBox;
         FPrinterGroupCaption: String;
         FSetPrinterButton: TBitBtn;
         FCancelButton: TBitBtn;
         FPropertyButton: TBitBtn;
         FHelpButton: TBitBtn;
         FOkName: String;
         FOldPrinterIndex: LongInt;
         Procedure PrinterSelected (Sender: TObject; Index: LongInt);
         Procedure PrinterFocused (Sender: TObject; Index: LongInt);
         Procedure PropertyBtnClicked (Sender: TObject);
         Procedure SetOkName (NewName: String);
      Protected
         Procedure SetupComponent; Override;
      Public
         Function Execute: Boolean; Override;
      Published
         Property OkName: String Read FOkName Write SetOkName;
    End;


    TPrintDialog = Class (TDialog)
      Private
         FTitleBox: TGroupBox;
         FTitle: TEdit;
         FOptionsGroupBox: TGroupBox;
         FNumberOfCopiesLabel: TLabel;
         FNumberOfCopies: TUpDown;
         FNumberOfCopiesEdit: TEdit;
         FPagesBox: TRadioGroup;
         FPrintFromLabel: TRadioButton;
         FPrintFrom: TUpDown;
         FPrintFromEdit: TEdit;
         FPrintToLabel: TLabel;
         FPrintTo: TUpDown;
         FPrintToEdit: TEdit;
         FPrintAll: TRadioButton;
         FOptionsBox: TRadioGroup;
         FPrinter: TRadioButton;
         FFileOutPut: TRadioButton;
         FFile: TEdit;
         FPrintButton: TBitBtn;
         FCancelButton: TBitBtn;
         FPropertyButton: TBitBtn;
         FHelpButton: TBitBtn;
         FCopies: LongInt;
         FMinPage: LongInt;
         FMaxPage: LongInt;
         FFromPage: LongInt;
         FToPage: LongInt;
         FAllPages: Boolean;
         FOkName: String;
         FOldPrinterIndex: LongInt;
      Protected
         Procedure PropertyBtnClicked (Sender: TObject);
         Procedure SetupComponent; Override;
         Procedure SetMinPage (NewValue: LongInt);
         Procedure SetMaxPage (NewValue: LongInt);
         Procedure SetToPage (NewValue: LongInt);
         Procedure SetFromPage (NewValue: LongInt);
         Procedure SetOkName (NewName: String);
         Procedure UpdateSpinSize (Sender: TObject);
      Public
         Function Execute: Boolean; Override;
         Property AllPages: Boolean Read FAllPages;
         Property MinPage: LongInt Read FMinPage Write SetMinPage;
         Property MaxPage: LongInt Read FMaxPage Write SetMaxPage;
         Property FromPage: LongInt Read FFromPage Write SetFromPage;
         Property ToPage: LongInt Read FToPage Write SetToPage;
      Published
         Property OkName: String Read FOkName Write SetOkName;
    End;


    TMessageBox=Class(TDialog)
      Private
         FMsg:String;
         FHelpCtx:THelpContext;
         FButtons:TMsgDlgButtons;
         fType:TMsgDlgType;
      Protected
         Procedure SetupShow;Override;
         Procedure SetupComponent;Override;
      Published
         Property Message:String Read FMsg Write FMsg;
         Property Buttons:TMsgDlgButtons Read FButtons Write FButtons;
         Property DlgType:TMsgDlgType Read fType Write fType;
         Property HelpCtx:THelpContext Read FHelpCtx Write FHelpCtx;
    End;



Function MessageBox(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Function ErrorBox(Const Msg:String):TMsgDlgReturn;

Function CreateMessageDialog(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons):TForm;
Function MessageDlg(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext):TMsgDlgReturn;
Function MessageDlgPos(Const Msg:String;DlgType: TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext;
                       X,Y:LongInt):TMsgDlgReturn;
Procedure ShowMessage(Const Msg:String);
Procedure ShowMessagePos(Const Msg:String;X,Y:LongInt);
Function InputBox(Const ACaption,APrompt,ADefault:String):String;
Function InputQuery(Const ACaption,APrompt:String;Var Value:String):Boolean;

Function ExpandPath(Path,CurDir:String):String;

Implementation

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: Some useful FUNCTIONs                                       บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function MessageBox(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Var  Dlg:TMessageBox;
     OldDesignerForm:TForm;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=200;
     Dlg.Height:=200;
     Dlg.Buttons:=Buttons;
     Dlg.DlgType:=Typ;
     Dlg.FMsg:=Msg;

     If OldDesignerForm <> Nil {Reset the designer flag}
     Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmOk:     Result:=mrOk;
       cmCancel: Result:=mrCancel;
       cmYes:    Result:=mrYes;
       cmNo:     Result:=mrNo;
       cmIgnore: Result:=mrIgnore;
       cmRetry:  Result:=mrRetry;
       cmAbort:  Result:=mrAbort;
       Else      Result:=mrCancel;
     End;
     Dlg.Destroy;
End;


Function ErrorBox(Const Msg:String):TMsgDlgReturn;
Begin
     Beep(1000,200);
     Result:=MessageBox(Msg,mtError,[mbOk]);
End;


Procedure ShowMessage(Const Msg:String);
Var  Dlg:TMessageBox;
     OldDesignerForm:TForm;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=200;
     Dlg.Height:=200;
     Dlg.FButtons:=[mbOk];
     Dlg.fType:=mtInformation;
     Dlg.FMsg:=Msg;
     Dlg.Caption:=ParamStr(0);

     If OldDesignerForm <> Nil {Reset the designer flag}
     Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Dlg.Destroy;
End;

Procedure ShowMessagePos(Const Msg:String;X,Y:LongInt);
Var  Dlg:TMessageBox;
     OldDesignerForm:TForm;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=200;
     Dlg.Height:=200;
     Dlg.Left:=X;
     Dlg.Top:=Y;
     Dlg.FButtons:=[mbOk];
     Dlg.fType:=mtInformation;
     Dlg.FMsg:=Msg;
     Dlg.Caption:=ParamStr(0);

     If OldDesignerForm <> Nil {Reset the designer flag}
     Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Dlg.Destroy;
End;

Function CreateMessageDialog(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons):TForm;
Var Dlg:TMessageBox;
    OldDesignerForm:TForm;
Begin
    OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

    Dlg.Create(Screen.ActiveForm);
    Dlg.Width:=200;
    Dlg.Height:=200;
    Dlg.DlgType:=DlgType;
    Dlg.Buttons:=DlgButtons;
    Dlg.FMsg:=Msg;

    If OldDesignerForm <> Nil {Reset the designer flag}
      Then Include(OldDesignerForm.ComponentState, csDesigning);

    Result:=Dlg;
End;

Function MessageDlg(Const Msg:String;DlgType:TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext):TMsgDlgReturn;
Var Dlg:TMessageBox;
Begin
     Dlg:=TMessageBox(CreateMessageDialog(Msg,DlgType,DlgButtons));
     Dlg.HelpCtx:=HelpCtx;
     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmOk:     Result:=mrOk;
       cmCancel: Result:=mrCancel;
       cmYes:    Result:=mrYes;
       cmNo:     Result:=mrNo;
       cmIgnore: Result:=mrIgnore;
       cmRetry:  Result:=mrRetry;
       cmAbort:  Result:=mrAbort;
       Else      Result:=mrCancel;
     End;
     Dlg.Destroy;
End;

Function MessageDlgPos(Const Msg:String;DlgType: TMsgDlgType;DlgButtons:TMsgDlgButtons;HelpCtx:THelpContext;
                       X,Y:LongInt):TMsgDlgReturn;
Var Dlg:TMessageBox;
Begin
     Dlg:=TMessageBox(CreateMessageDialog(Msg,DlgType,DlgButtons));
     Dlg.HelpCtx:=HelpCtx;
     Dlg.Left:=X;
     Dlg.Top:=Y;
     Dlg.Execute;
     Case Dlg.ModalResult Of
       cmOk:     Result:=mrOk;
       cmCancel: Result:=mrCancel;
       cmYes:    Result:=mrYes;
       cmNo:     Result:=mrNo;
       cmIgnore: Result:=mrIgnore;
       cmRetry:  Result:=mrRetry;
       cmAbort:  Result:=mrAbort;
       Else      Result:=mrCancel;
     End;
     Dlg.Destroy;
End;

Function InputBox(Const ACaption,APrompt,ADefault:String):String;
Begin
     Result:=ADefault;
     InputQuery(ACaption,APrompt,Result);
End;

Function InputQuery(Const ACaption,APrompt:String;Var Value:String):Boolean;
Var
   Dlg:TDialog;
   OldDesignerForm:TForm;
   FEdit:TEdit;
Begin
     OldDesignerForm := Nil;
     If Screen.ActiveForm <> Nil Then
       If Screen.ActiveForm.Designed Then
       Begin {Clear the designer flag To Assign the correct Font}
            OldDesignerForm := Screen.ActiveForm;
            Exclude(OldDesignerForm.ComponentState, csDesigning);
       End;

     Dlg.Create(Screen.ActiveForm);
     Dlg.Width:=355;
     Dlg.Height:=150;
     Dlg.Caption:=ACaption;

     InsertBitBtn(Dlg,20,10,90,30,bkOk,LoadNLSStr(SOkButton),'');
     InsertBitBtn(Dlg,120,10,90,30,bkCancel,LoadNLSStr(SCancelButton),'');

     InsertLabel(Dlg,20,90,310,20,APrompt);

     FEdit.Create(Dlg);
     FEdit.SetWindowPos(20,60,310,20);
     FEdit.Text:=Value;
     FEdit.parent:=Dlg;
     FEdit.Focus;

     If OldDesignerForm <> Nil {Reset the designer flag}
      Then Include(OldDesignerForm.ComponentState, csDesigning);

     Dlg.Execute;
     Case Dlg.ModalResult Of
        cmOk:
        Begin
             Value:=FEdit.Text;
             Result:=True;
        End;
        Else Result:=False;
     End; {Case}
     Dlg.Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TDialog Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'Dialog';
     XAlign := xaCenter;
     YAlign := yaCenter;
     PenColor := clStaticText;
     Color := clDlgWindow;
     ParentPenColor := False;
     ParentColor := False;
     BorderIcons := [biSystemMenu];
     BorderStyle := bsDialog;
     Visible := FALSE;
End;


Function TDialog.Execute:Boolean;
Begin
     ShowModal;
     Result := ModalResult In [cmOk,cmYes];
     DestroyHandle;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TSystemOpenSaveDialog Class Implementation                  บ
บ                                                                           บ
บ (C) 1995,98 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSystemOpenSaveDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'SystemOpenSaveDialog';
     FFileName := '';
     FDefaultExt := '';
     FFilter := '';
     FFilterIndex := 1;
     FMaskList.Create;
End;


Destructor TSystemOpenSaveDialog.Destroy;
Begin
     Inherited Destroy;

     FMaskList.Destroy;
     FMaskList := Nil;
End;

{$IFDEF OS2}
Procedure SetupFilters(hFCB:Longword;SOSD:TSystemOpenSaveDialog);
Var  AMask,AFilter:String;
     S:String;
     cs:CString;
     P:Integer;
Begin
     If hFCB = 0 Then exit;
     If SOSD = Nil Then exit;

     WinSendMsg(hFCB,LM_DELETEALL,0,0);
     WinSetWindowText(hFCB,'');

     SOSD.FMaskList.Clear;

     S := SOSD.FFilter;
     P := Pos('|',S);
     While P > 0 Do
     Begin
          AFilter := Copy(S,1,P-1);
          Delete(S,1,P);
          P := Pos('|',S);
          If P > 0 Then
          Begin
               AMask := Copy(S,1,P-1);
               Delete(S,1,P);
          End
          Else
          Begin
               AMask := S;
               S := '';
          End;
          cs := AFilter;
          WinSendMsg(hFCB,LM_INSERTITEM,LIT_END,LongWord(@cs));
          SOSD.FMaskList.Add(AMask);
          P := Pos('|',S);
     End;
     WinSendMsg(hFCB,LM_SELECTITEM,SOSD.FFilterIndex-1,1);
End;


Function GetMask(hFCB:Longword;SOSD:TSystemOpenSaveDialog):String;
Var  itp:LONGINT;
Begin
     Result := '';
     If hFCB = 0 Then exit;
     If SOSD = Nil Then exit;

     itp := WinSendMsg(hFCB,LM_QUERYSELECTION,MPFROMSHORT(LIT_FIRST),0);

     If (itp >= 0) And (itp < SOSD.FMaskList.Count)
     Then Result := SOSD.FMaskList[itp]
End;

Function FileDlgWndProc(Win:HWindow;Msg:LONGWORD;Param1,Param2:LONGWORD):LONGWORD;CDECL;
Var  hFCB,hFNEd:HWindow;
     Ext:CString;
     DlgAdr:^FileDlg;
     SOSD:TSystemOpenSaveDialog;
Begin
     If (Msg = WM_INITDLG) Then
     Begin
          DlgAdr := Pointer(WinQueryWindowULong(Win,QWL_USER));
          SOSD := TSystemOpenSaveDialog (DlgAdr^.ulUser);
          hFCB := WinWindowFromId(Win,DID_FILTER_CB);
          hFNEd := WinWindowFromId(Win,DID_FILENAME_ED);
          // init the filter combobox
          SetupFilters(hFCB, SOSD);
          (*
          If SOSD.FFileName = '' Then
            If SOSD.FFilterIndex > 0 Then
              If SOSD.FFilterIndex <= SOSD.FMaskList.Count Then
              Begin
                   Ext := SOSD.FMaskList[SOSD.FFilterIndex-1];
                   WinSetWindowText(hFNEd,Ext);
                   WinSetFocus(HWND_DESKTOP,hFNEd);
                   WinPostMsg(hFNEd, WM_CHAR, MPFROM2SHORT(KC_VIRTUALKEY,0),MPFROM2SHORT(0,VK_ENTER));
              End;
          *)
     End;

     If (Msg = WM_CONTROL) And
        (Lo(param1) = DID_FILTER_CB) And (Hi(param1) = CBN_ENTER) Then
     Begin
          DlgAdr := Pointer(WinQueryWindowULong(Win,QWL_USER));
          SOSD := TSystemOpenSaveDialog (DlgAdr^.ulUser);
          hFCB := WinWindowFromId(Win,DID_FILTER_CB);
          hFNEd := WinWindowFromId(Win,DID_FILENAME_ED);
          // get selected extension
          Ext := GetMask(hFCB, SOSD);
          WinSetWindowText(hFNEd,Ext);
          WinSetFocus(HWND_DESKTOP,hFNEd);
          WinPostMsg(hFNEd, WM_CHAR, MPFROM2SHORT(KC_VIRTUALKEY,0),MPFROM2SHORT(0,VK_ENTER));
          FileDlgWndProc := 0;
          exit;
     End;

     FileDlgWndProc := WinDefFileDlgProc(Win, Msg, Param1, Param2);
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TSystemOpenDialog Class Implementation                      บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSystemOpenDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'SystemOpenDialog';
     FTitle := LoadNLSStr(SOpenAFile);
     FOkName := LoadNLSStr(SOpen);
End;


Function TSystemOpenDialog.Execute:Boolean;
Var  cTitle,cOKName:cstring;
     D,N,E:String;
     {$IFDEF OS2}
     Dlg:FileDlg;
     {$ENDIF}
     {$IFDEF Win95}
     O:OPENFILENAME;
     cDefExt:cstring;
     cres:cstring;
     {$ENDIF}
Begin
     cTitle:=FTitle;
     cOKName:=FOkName;
     {$IFDEF OS2}
     FillChar(Dlg,SizeOf(FileDlg),0); {Clear Dialog structure}

     Dlg.cbSize:=SizeOf(FileDlg);
     Dlg.fl:=FDS_OPEN_DIALOG | FDS_CENTER | FDS_ENABLEFILELB | FDS_FILTERUNION;
     Dlg.pszTitle:=@cTitle;
     Dlg.pszOkButton:=@cOKName;
     Dlg.szFullFile:=FFileName;
     Dlg.ulUser := Longword(Self);
     Dlg.pfnDlgProc := @FileDlgWndProc;

     WinFileDlg(HWND_DESKTOP,HWND_DESKTOP,Dlg);
     Result := Dlg.lReturn = 1; {DID_OK}
     If Result Then FFileName := Dlg.szFullFile;
     {$ENDIF}

     {$IFDEF Win95}
     FillChar(O,SizeOf(OPENFILENAME),0); {Clear Dialog structure}

     O.lStructSize:=SizeOf(OPENFILENAME);
     If Owner Is TControl Then O.hwndOwner:=TControl(Owner).Handle
     Else O.hwndOwner:=0;
     O.lpStrTitle:=@cTitle;
     cDefExt:=FDefaultExt;
     O.lpstrDefExt:=@cDefExt;
     O.Flags:=OFN_PATHMUSTEXIST Or OFN_FILEMUSTEXIST;
     cres:=FFileName;
     O.lpStrFile:=@cres;
     O.nMaxFile:=254;
     O.hInstance:=AppHandle;
     Result := GetOpenFileName(O);
     If Result Then FFileName := O.lpStrFile^;
     {$ENDIF}

     If Result Then
     Begin
          FSplit(FFileName,D,N,E);
          If E = '' Then FFileName := FFileName + '.' + FDefaultExt;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TSystemSaveDialog Class Implementation                      บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSystemSaveDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'SystemSaveDialog';
     FTitle := LoadNLSStr(SSaveFileAs);
     FOkName := LoadNLSStr(SSave);
End;


Function TSystemSaveDialog.Execute:Boolean;
Var  cTitle,cOKName:cstring;
     D,N,E:String;
     {$IFDEF OS2}
     Dlg:FileDlg;
     {$ENDIF}
     {$IFDEF Win95}
     O:OPENFILENAME;
     cDefExt:cstring;
     cres:cstring;
     {$ENDIF}
Begin
     cTitle:=FTitle;
     cOKName:=FOkName;
     {$IFDEF OS2}
     FillChar(Dlg,SizeOf(FileDlg),0); {Clear Dialog structure}

     Dlg.cbSize:=SizeOf(FileDlg);
     Dlg.fl:=FDS_SAVEAS_DIALOG | FDS_CENTER | FDS_ENABLEFILELB | FDS_FILTERUNION;
     Dlg.pszTitle:=@cTitle;
     Dlg.pszOkButton:=@cOKName;
     Dlg.szFullFile:=FFileName;
     Dlg.ulUser := Longword(Self);
     Dlg.pfnDlgProc := @FileDlgWndProc;

     WinFileDlg(HWND_DESKTOP,HWND_DESKTOP,Dlg);
     Result := Dlg.lReturn = 1; {DID_OK}
     If Result Then FFileName := Dlg.szFullFile;
     {$ENDIF}
     {$IFDEF Win95}
     FillChar(O,SizeOf(OPENFILENAME),0); {Clear Dialog structure}

     O.lStructSize:=SizeOf(OPENFILENAME);
     If Owner Is TControl Then O.hwndOwner:=TControl(Owner).Handle
     Else O.hwndOwner:=0;
     O.lpStrTitle:=@cTitle;
     cDefExt:=FDefaultExt;
     O.lpstrDefExt:=@cDefExt;
     O.Flags:=0;
     cres:=FFileName;
     O.lpStrFile:=@cres;
     O.nMaxFile:=254;
     O.hInstance:=AppHandle;
     Result := GetOpenFileName(O);
     If Result Then FFileName := O.lpStrFile^;
     {$ENDIF}

     If Result Then
     Begin
          FSplit(FFileName,D,N,E);
          If E = '' Then FFileName := FFileName + '.' + FDefaultExt;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TOpenDialog Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TOpenDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     ClientWidth := 470;
     ClientHeight := 370;
     Name := 'OpenDialog';
     FOkName := LoadNLSStr(SOpenButton);
     FTitle := LoadNLSStr(SOpenAFile);
     FFileName := '';
     FFilter := '';
     FFilterIndex := 1;
     FDefaultExt := '';

     InsertLabel(Self,20,340,390,20,LoadNLSStr(SFilename)+':');
     FFileNameEdit := InsertEdit(Self,20,314,430,26,'',''); {oder Combo}

     InsertLabel(Self,20,290,160,20,LoadNLSStr(SDrive)+':');
     FDriveCombo := InsertDriveComboBox(Self,20,264,170,26);

     InsertLabel(Self,200,290,250,20,LoadNLSStr(SFileType)+':');
     FFilterCombo := InsertFilterComboBox(Self,200,264,250,26);

     InsertLabel(Self,20,240,160,20,LoadNLSStr(SDirectories)+':');
     FDirectoryList := InsertDirectoryListBox(Self,20,90,170,148);
     FDirectoryList.HorzScroll := True;
     FDirectoryList.OnExit := EvKillFocus;

     InsertLabel(Self,200,240,250,20,LoadNLSStr(SFiles)+':');
     FFileList := InsertFileListBox(Self,200,90,250,148);
     FFileList.HorzScroll := True;
     FFileList.OnChange := FileChange;
     FFileList.OnItemSelect := FileSelect;
     FFileList.OnExit := EvKillFocus;

     FCurrentNamePanel := InsertPanel(Self,20,55,430,25,bvNone,bvLowered,1,'');
     FCurrentNamePanel.Alignment := taLeftJustify;
     FCurrentNamePanel.PenColor := clWindowText;

     FOkButton := InsertBitBtn(Self,20,15,100,30,bkOk,LoadNLSStr(SOpenButton),LoadNLSStr(SClickHereToAccept));
     FCancelButton := InsertBitBtn(Self,130,15,100,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     FHelpButton := InsertBitBtn(Self,350,15,100,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));

     {Connect}
     FDriveCombo.DirList := FDirectoryList;
     FFilterCombo.FileList := FFileList;
     FDirectoryList.FileList := FFileList;
     {FFileList.FileEdit := FFileNameEdit; See FileChange}

     SetCurDir(''); {Current dir}
End;


Procedure TOpenDialog.SetupShow;
Begin
     Inherited SetupShow;

     Caption := FTitle;
     FOkButton.Caption := FOkName;

     If FFilter <> '' Then FFilterCombo.Filter := FFilter;
     If FFilterIndex >= 1 Then FFilterCombo.ItemIndex := FFilterIndex - 1;
     SetFileName(FFileName);
     FileChange(Nil);

     {$IFDEF Win32}
     FFileList.SetWindowPos(200,90,250,148);
     {$ENDIF}

     FFileNameEdit.Focus;
     FOkButton.Default := True;
End;


Function ExpandPath(Path,CurDir:String):String;
Var  I,P:Byte;
     S:String;
Label L,l2;
Begin
     S := CurDir;
     If Length(S) = 3 Then
       If S[2] = ':' Then
         If S[3] In ['\','/'] Then Dec(S[0]);

     If (Pos('\',Path) = 1) Or (Pos('/',Path) = 1)
     Then Path := Copy(S,1,2) + Path;

     If (Length(Path) >= 2) And (Path[2] = ':') Then
     Begin
          S := Copy(Path,1,2);
          Delete(Path,1,2);
     End;
     If Not (Path[1] In ['\','/']) Then Path := '\'+ Path;

     Repeat
           If ((Pos('\..',Path) = 1) Or (Pos('/..',Path) = 1)) Then
           Begin
                If (Length(Path) >= 4) And (Not (Path[4] In ['\','/'])) Then Goto l2;
                Delete(Path,1,3);
                For I := Length(S) DownTo 3 Do
                Begin
                     If S[I] = ':' Then break;
                     Dec(S[0]);
                     If S[I] In ['\','/'] Then break;
                End;
           End
           Else
           If ((Pos('\.',Path) = 1) Or (Pos('/.',Path) =1)) Then
           Begin
                If (Length(Path) >= 3) And (Not (Path[3] In ['\','/'])) Then Goto l2;
                Delete(Path,1,2);
           End
           Else
           If ((Pos('\',Path) = 1) Or (Pos('/',Path) = 1)) Then
           Begin
l2:
                Delete(Path,1,1);
                S := S + '\';
           End
           Else
           Begin
L:
                P := Pos('\',Path);
                If P = 0 Then P := Pos('/',Path);
                If P > 0 Then
                Begin
                     S := S + Copy(Path,1,P-1);
                     Delete(Path,1,P-1);
                End
                Else
                Begin
                     S := S + Path;
                     Path := '';
                End;
           End;
     Until Path = '';
     If Length(S) = 2 Then S := S +'\';

     Result := S;
End;


Procedure TOpenDialog.DismissDlg(Result:TCommand);
Var  S,D,N,E,lw,dn:String;
     dismiss:Boolean;
     Status:Integer;
     Search:TSearchRec;
     pn:Integer;
Begin
     If Result = cmOk Then
     Begin
          {check If we can dismiss}
          S := FFileNameEdit.Caption;
          While S[Length(S)] = #32 Do Dec(S[0]);
          If S = '' Then
          Begin
               ModalResult := cmNull; {Reset}
               Exit;
          End;

          dismiss := True;
          {check If we MUST Change dir}
          S := ExpandPath(S,FCurDir);
          FSplit(S,D,N,E);
          pn := Pos('*',N);
          If (E = '') Or (pn <> 0) Then
          Begin {Test If we MUST Change Directory}
               lw := D+N;
               Delete(lw,1,1); {Test 'x:\'; FindFirst can't detect it}

               dn := D + N;
               If dn[Length(dn)] In ['\','/'] Then SetLength(dn,Length(dn)-1);

               Status := FindFirst(dn,faDirectory,Search);
               If (Status = 0) Or (lw = ':\') Or (lw = ':/') Then
               Begin
                    If pn <> 0 Then SetCurDir(D)
                    Else SetCurDir(D+N);

                    If pn = 0 Then {no wildcards}
                    Begin
                         FFileList.Directory := FCurDir; {?}
                         If E = '' Then FFileNameEdit.Caption := FFileList.Mask
                         Else FFileNameEdit.Caption := E; {???}
                         FFileNameEdit.SelectAll;
                         dismiss := False;
                    End;
               End;
               FindClose(Search);
          End;

          If pn <> 0 Then
          Begin
               FFileList.Directory := FCurDir; {?}
               FFileList.Mask := N + E;
               FFileNameEdit.Caption := FFileList.Mask;
               FFileNameEdit.SelectAll;
               dismiss := False;
          End;

          If Not dismiss Then
          Begin
               ModalResult := cmNull; {Reset}
               Exit;
          End;
     End;

     FFileName := GetFileName;
     FFilterIndex := FFilterCombo.ItemIndex + 1;

     Inherited DismissDlg(Result);
End;


Procedure TOpenDialog.AddFilter(Name,Mask:String);
Begin
     If FFilter <> '' Then Name := '|' + Name;
     FFilter := FFilter + Name + '|' + Mask;
End;


{$HINTS OFF}
Procedure TOpenDialog.FileChange(Sender:TObject);
Var  S,D,N,E:String;
Begin
     {TFileListBox.Change}
     If ExtractFileName(FFileList.FileName) <> '' Then
     Begin
          FFileNameEdit.Caption := ExtractFileName(FFileList.FileName);
          FFileNameEdit.SelectAll;
     End; {Else the old FileName}

     FCurDir := FFileList.Directory;
     S := FCurDir + '\' + FFileNameEdit.Caption;
     If FDefaultExt <> '' Then
     Begin
          FSplit(S,D,N,E);
          If E = '' Then S := S + '.' + FDefaultExt;
     End;
     FCurrentNamePanel.Caption := S;
End;


Procedure TOpenDialog.FileSelect(Sender:TObject;Index:LongInt);
Begin
     FileChange(Sender);
     DismissDlg(cmOk);
End;
{$HINTS ON}


Procedure TOpenDialog.SetFileName(Value:String);
Var  D,N,E,actdir:String;
Begin
     FSplit(Value,D,N,E);

     {$I-}
     GetDir(0,actdir);
     If Length(D) > 3 Then Dec(D[0]);
     ChDir(D);
     If InOutRes = 0 Then
     Begin
          SetCurDir(D);
          FFileList.Directory := FCurDir; {?}
     End;
     ChDir(actdir);
     {$I+}

     If N + E <> '' Then FFileNameEdit.Caption := N + e
     Else FFileNameEdit.Caption := FFileList.Mask;
End;


Function TOpenDialog.GetFileName:String;
Var  D,N,E:String;
Begin
     Result := FFileNameEdit.Caption;
     If Pos('\',Result) = 0 Then Result := FCurDir + '\' + Result;

     FSplit(Result,D,N,E);
     If E = '' Then If N<>'' Then Result := D + N + '.' + FDefaultExt;
End;


Procedure TOpenDialog.SetCurDir(Value:String);
Begin
     If Value = '' Then
     Begin
          {$I-}
          GetDir(0,FCurDir);
          {$I+}
     End
     Else FCurDir := Value;

     If FCurDir[Length(FCurDir)] In ['\','/'] Then Dec(FCurDir[0]);
     FCurrentNamePanel.Caption := FCurDir + '\' + FFileNameEdit.Caption;
End;


{$HINTS OFF}
Procedure TOpenDialog.CMTextChanged(Var Msg:TMessage);
Begin
     FTitle := Caption;
End;


Procedure TOpenDialog.EvKillFocus(Sender:TObject);
Begin
     If Sender Is TListBox Then TListBox(Sender).ItemIndex := -1;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TSaveDialog Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSaveDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'SaveDialog';
     FOkName := LoadNLSStr(SSaveButton);
     FTitle := LoadNLSStr(SSaveFileAs);

     FFileNameEdit.Width := FFileNameEdit.Width - 30;

     FCreateButton := InsertSpeedButton(Self,450-25,314,25,25,0,'',
                                        LoadNLSStr(SCreateDirectory));
     FCreateButton.Kind := bkOpen;
     FCreateButton.Caption := '';
     FCreateButton.OnClick := EvCreateDir;
End;

{$HINTS OFF}
Procedure TSaveDialog.EvCreateDir(Sender:TObject);
Var  CreateDirDlg:TCreateDirDialog;
Begin
     CreateDirDlg.Create(Self);
     CreateDirDlg.Directory := FDirectoryList.Directory;
     If CreateDirDlg.Execute Then
     Begin
          If CreateDirDlg.ChangeDir
          Then FDirectoryList.Directory := CreateDirDlg.Directory
          Else FDirectoryList.Directory := FDirectoryList.Directory; {rebuild List}
     End;
     CreateDirDlg.Destroy;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCreateDirDialog Class Implementation                       บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCreateDirDialog.SetupComponent;
Var  group:TGroupBox;
Begin
     Inherited SetupComponent;

     ClientWidth := 370;
     ClientHeight := 180;

     Name := 'CreateDirDialog';
     Caption := LoadNLSStr(SCreateDirectory);
     FOkName := LoadNLSStr(SCreateButton);
     FDirectory := '';

     group := InsertGroupBox(Self,20,60,330,100,LoadNLSStr(SEnterNewDirectory));
     FDirEdit := InsertEdit(group,15,45,300,26,'','');
     FChangeCheck := InsertCheckBox(group,15,15,300,20,LoadNLSStr(SChangeToTargetDir),'');

     FOkButton := InsertBitBtn(Self,20,15,100,30,bkOk,FOkName,LoadNLSStr(SClickHereToAccept));
     FCancelButton := InsertBitBtn(Self,130,15,100,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     FHelpButton := InsertBitBtn(Self,240,15,100,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
End;


Procedure TCreateDirDialog.SetupShow;
Begin
     Inherited SetupShow;

     If FDirectory = '' Then
     Begin
          {$I-}
          GetDir(0,FDirectory);
          {$I+}
          If FDirectory[Length(FDirectory)] In ['\','/']
          Then Dec(FDirectory[0]);
     End;

     FDirEdit.Text := FDirectory;
     FDirEdit.Focus;
     FDirEdit.SelectAll;
     FChangeCheck.Checked := FChangeDir;
     FOkButton.Caption := FOkName;
     FOkButton.Default := True;
End;


Function CreateDir(Init,dir:String):Boolean;
{$IFDEF OS2}
Const
  NoError = NO_ERROR;
  PathNotFound = ERROR_PATH_NOT_FOUND;
{$ENDIF}
{$IFDEF WIN32}
Const
  NoError = 0;
  PathNotFound = 3;
{$ENDIF}

  Procedure NormalizeDir(Var S:String);
  Begin
       If Length(S) > 3 Then
         If S[Length(S)] = '\' Then SetLength(S,Length(S)-1);
  End;

Var
  Name,ext,makedir,dir1:String;
  rc,P:LongWord;
Label err;
Begin
     Result := True;
     If Init = '' Then
     Begin
          {$I-}
          GetDir(0,Init);
          {$I+}
     End;
     NormalizeDir(dir);

     If Pos('\',dir) = 1 Then dir := Copy(Init,1,2) + dir;
     If Pos(':',dir) = 0 Then dir := Init + '\' + dir;
     NormalizeDir(dir);

     makedir := '';
     rc := PathNotFound;
     While rc <> NoError Do
     Begin
          {$I-}
          MkDir(dir);
          {$I+}
          rc := IOResult;
          If rc = PathNotFound Then
          Begin
               FSplit(dir,dir1,Name,ext);
               dir := dir1;
               NormalizeDir(dir);
               If dir[Length(dir)] = ':' Then Goto err;
               makedir := Name + '\' + makedir;
          End
          Else If rc <> NoError Then Goto err;
     End;

     While makedir <> '' Do
     Begin
          P := Pos('\',makedir);
          dir := dir + '\' + Copy(makedir,1,P-1);
          Delete(makedir,1,P);
          {$I-}
          MkDir(dir);
          {$I+}
          rc := IOResult;
          If rc <> NoError Then Goto err;
     End;
     Exit;
err:
     ErrorBox(LoadNLSStr(SError)+' [' + tostr(rc) + '] : '+LoadNLSStr(SCannotCreateDir)+' !');
     Result := False;
End;


Procedure TCreateDirDialog.DismissDlg(Result:TCommand);
Var  FInitDir:String;
Begin
     If Result = cmOk Then
     Begin
          FInitDir := FDirectory;  {Initial Directory from App}
          FDirectory := ExpandPath(FDirEdit.Text,FInitDir);
          FChangeDir := FChangeCheck.Checked;

          If CreateDir(FInitDir,FDirectory) Then
          Begin
               If FChangeDir Then
               Begin
                    {$I-}
                    ChDir(FDirectory);
                    {$I+}
               End;
          End
          Else
          Begin
               ModalResult := cmNull; {Reset}
               FDirEdit.CaptureFocus;
               Exit;
          End;
     End;

     Inherited DismissDlg(Result);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TChangeDirDialog Class Implementation                       บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TChangeDirDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     ClientWidth := 440;
     ClientHeight := 300;

     Name := 'ChangeDirDialog';
     Caption := LoadNLSStr(SChangeDirectory);
     FOkName := LoadNLSStr(SChangeButton);
     InsertLabel(Self,20,265,270,20,LoadNLSStr(SDirectoryName)+':');
     FFileNameEdit := InsertEdit(Self,20,240,270,26,'','');

     InsertLabel(Self,20,215,270,20,LoadNLSStr(SDrive)+':');
     FDriveCombo := InsertDriveComboBox(Self,20,185,270,26);

     InsertLabel(Self,20,160,270,20,LoadNLSStr(SDirectories)+':');
     {$IFDEF OS2}
     FDirectoryList := InsertDirectoryListBox(Self,20,20,270,140);
     {$ENDIF}
     {$IFDEF WIN32}
     FDirectoryList := InsertDirectoryListBox(Self,20,45{???},270,140);
     {$ENDIF}
     FDirectoryList.OnChange := DirectoryChange;
     FDriveCombo.DirList := FDirectoryList;

     FOkButton := InsertBitBtn(Self,315,240,105,30,bkOk,FOkName,LoadNLSStr(SClickHereToAccept));
     FOkButton.Margin := 10;
     FCancelButton := InsertBitBtn(Self,315,200,105,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     FCancelButton.Margin := 10;
     FCreateButton := InsertBitBtn(Self,315,160,105,30,bkOpen,LoadNLSStr(SCreateButton),LoadNLSStr(SClickHereToCreateADir));
     FCreateButton.Margin := 10;
     FCreateButton.ModalResult := 0; {dont Close the Dialog}
     FCreateButton.OnClick := EvCreateDir;
     FHelpButton := InsertBitBtn(Self,315,120,105,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
     FHelpButton.Margin := 10;
End;


Procedure TChangeDirDialog.SetupShow;
Begin
     Inherited SetupShow;

     If FDirectory = '' Then
     Begin
          {$I-}
          GetDir(0,FDirectory);
          {$I+}
          If FDirectory[Length(FDirectory)] In ['\','/']
          Then Dec(FDirectory[0]);
     End;
     FDirectoryList.Directory := FDirectory;

     FFileNameEdit.Focus;
     FFileNameEdit.SelectAll;
     FOkButton.Caption := FOkName;
     FOkButton.Default := True;
End;


{$HINTS OFF}
Procedure TChangeDirDialog.DirectoryChange(Sender:TObject);
Begin
     FFileNameEdit.Caption := FDirectoryList.Directory;
End;
{$HINTS ON}


Function TChangeDirDialog.Execute:Boolean;
Begin
     Result := Inherited Execute;
     If Result Then
     Begin
          FDirectory := ExpandPath(FFileNameEdit.Caption, FDirectoryList.Directory);

          If Length(FDirectory) > 3 Then
            If FDirectory[Length(FDirectory)] = '\'
            Then SetLength(FDirectory,Length(FDirectory)-1);
          {$I-}
          ChDir(FDirectory);
          {$I+}
     End;
End;

{$HINTS OFF}
Procedure TChangeDirDialog.EvCreateDir(Sender:TObject);
Var  CreateDirDlg:TCreateDirDialog;
Begin
     CreateDirDlg.Create(Self);
     CreateDirDlg.Directory := FDirectoryList.Directory;
     If CreateDirDlg.Execute Then
     Begin
          If CreateDirDlg.ChangeDir
          Then FDirectoryList.Directory := CreateDirDlg.Directory
          Else FDirectoryList.Directory := FDirectoryList.Directory; {rebuild List}
     End;
     CreateDirDlg.Destroy;
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TFindDialog Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFindDialog.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FindDialog';
     Caption := LoadNLSStr(SFindText);
     ClientWidth := 430;
     ClientHeight := 310;

     Lab_Find := InsertLabel(Self,20,270,70,20,LoadNLSStr(SFind)+':');
     CoB_Find := InsertComboBox(Self,110,270,300,20,csDropDown);

     Grp_Options := InsertGroupBox(Self,20,170,180,75,LoadNLSStr(SOptions));
     ChB_CaseSense := InsertCheckBox(Grp_Options,15,30,160,20,LoadNLSStr(SCaseSensitive),'');
     ChB_WordsOnly := InsertCheckBox(Grp_Options,15,10,160,20,LoadNLSStr(SWordsOnly),'');

     Grp_Scope := InsertGroupBox(Self,230,170,180,75,LoadNLSStr(SScope));
     RaB_Global := InsertRadioButton(Grp_Scope,15,30,160,20,LoadNLSStr(SGlobal),'');
     RaB_Selection := InsertRadioButton(Grp_Scope,15,10,160,20,LoadNLSStr(SSelectedText),'');

     Grp_Origin := InsertGroupBox(Self,20,70,180,75,LoadNLSStr(SOrigin));
     RaB_EntireScope := InsertRadioButton(Grp_Origin,15,30,160,20,LoadNLSStr(SEntireScope),'');
     RaB_Cursor := InsertRadioButton(Grp_Origin,15,10,160,20,LoadNLSStr(SFromCursor),'');

     Grp_Direction := InsertGroupBox(Self,230,70,180,75,LoadNLSStr(SDirection));
     RaB_Forward := InsertRadioButton(Grp_Direction,15,30,160,20,LoadNLSStr(SForwardButton),'');
     RaB_Backward := InsertRadioButton(Grp_Direction,15,10,160,20,LoadNLSStr(SBackwardButton),'');

     BiB_Find := InsertBitBtn(Self,20,20,90,30,bkOk,LoadNLSStr(SFindButton),LoadNLSStr(SClickHereToAccept));
     BiB_Cancel := InsertBitBtn(Self,130,20,100,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     BiB_Help := InsertBitBtn(Self,320,20,90,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
End;


Procedure TFindDialog.SetupShow;
Begin
     Inherited SetupShow;

     CoB_Find.Focus;
     BiB_Find.Default := True;
End;


Function TFindDialog.GetFindOptions:TFindOptions;
Begin
     Result := [];
     If ChB_CaseSense.Checked Then Result := Result + [foCaseSensitive];
     If ChB_WordsOnly.Checked Then Result := Result + [foWordsOnly];
End;

Procedure TFindDialog.SetFindOptions(Value:TFindOptions);
Begin
     ChB_CaseSense.Checked := Value * [foCaseSensitive] <> [];
     ChB_WordsOnly.Checked := Value * [foWordsOnly] <> [];
End;

Function TFindDialog.GetFindOrigin:TFindOrigin;
Begin
     If RaB_EntireScope.Checked Then Result := foEntireScope
     Else Result := foCursor;
End;

Procedure TFindDialog.SetFindOrigin(Value:TFindOrigin);
Begin
     RaB_EntireScope.Checked := Value = foEntireScope;
     RaB_Cursor.Checked := Value = foCursor;
End;

Function TFindDialog.GetFindScope:TFindScope;
Begin
     If RaB_Global.Checked Then Result := fsGlobal
     Else Result := fsSelection;
End;

Procedure TFindDialog.SetFindScope(Value:TFindScope);
Begin
     RaB_Global.Checked := Value = fsGlobal;
     RaB_Selection.Checked := Value = fsSelection;
End;

Function TFindDialog.GetFindDirection:TFindDirection;
Begin
     If RaB_Forward.Checked Then Result := fdForward
     Else Result := fdBackward;
End;

Procedure TFindDialog.SetFindDirection(Value:TFindDirection);
Begin
     RaB_Forward.Checked := Value = fdForward;
     RaB_Backward.Checked := Value = fdBackward;
End;

Function TFindDialog.GetFindText:String;
Begin
     Result := CoB_Find.Caption;
End;

Procedure TFindDialog.SetFindText(Const Value:String);
Begin
     CoB_Find.Caption := Value;
End;

Procedure TFindDialog.SetFindTextExtend(Const Value:String);
Begin
     CoB_Find.TextExtension := Value;
     FFindTextExt := Value;
End;

Procedure TFindDialog.SetFindHistory(Const Strings:TStringList);
Begin
     CoB_Find.Items := Strings;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TReplaceDialog Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TReplaceDialog.SetupComponent;
Var  BiB_All:TBitBtn;
Begin
     Inherited SetupComponent;

     Name := 'ReplaceDialog';
     Caption := LoadNLSStr(SReplaceText);
     ClientWidth := 430;
     ClientHeight := 350;

     Lab_Find.Bottom := 310;
     CoB_Find.Bottom := 310;
     InsertLabel(Self,20,270,70,20,LoadNLSStr(SReplace)+':');
     CoB_Replace := InsertComboBox(Self,110,270,300,20,csDropDown);
     CoB_Replace.TabOrder := CoB_Find.TabOrder +1;

     Grp_Options.SetWindowPos(20,150,180,95);
     ChB_CaseSense.Bottom := 50;
     ChB_WordsOnly.Bottom := 30;
     ChB_Confirm := InsertCheckBox(Grp_Options,15,10,160,20,LoadNLSStr(SConfirmButton),'');
     ChB_Confirm.TabOrder := ChB_WordsOnly.TabOrder +1;

     BiB_Find.Width := 110;
     BiB_Find.Caption := LoadNLSStr(SReplaceButton);
     BiB_All := InsertBitBtn(Self,140,20,75,30,bkAll,LoadNLSStr(SAllButton),'');
     BiB_All.TabOrder := BiB_Find.TabOrder +1;
     BiB_Cancel.SetWindowPos(225,20,95,30);
     BiB_Help.SetWindowPos(330,20,80,30);
End;

Function TReplaceDialog.GetConfirm:Boolean;
Begin
     Result := ChB_Confirm.Checked;
End;

Procedure TReplaceDialog.SetConfirm(Value:Boolean);
Begin
     ChB_Confirm.Checked := Value;
End;

Function TReplaceDialog.GetReplaceText:String;
Begin
     Result := CoB_Replace.Caption;
End;

Procedure TReplaceDialog.SetReplaceText(Const Value:String);
Begin
     CoB_Replace.Caption := Value;
End;

Procedure TReplaceDialog.SetReplaceHistory(Const Strings:TStringList);
Begin
     CoB_Replace.Items := Strings;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TColorDialog Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TColorDialog.SetupComponent;
Var  T:LongInt;
     Btn:TBitBtn;
Begin
     Inherited SetupComponent;

     ClientWidth:=420;
     ClientHeight:=200;
     Name:='ColorDialog';
     Caption:=LoadNLSStr(SSelectAColor);

     FRedScroll:=InsertScrollBar(Self,20,20,16,160,sbVertical);
     FRedScroll.color:=clRed;
     FRedScroll.SetScrollRange(0,255,1);
     FRedScroll.LargeChange:=8;
     FGreenScroll:=InsertScrollBar(Self,50,20,16,160,sbVertical);
     FGreenScroll.color:=clLime;
     FGreenScroll.SetScrollRange(0,255,1);
     FGreenScroll.LargeChange:=8;
     FBlueScroll:=InsertScrollBar(Self,80,20,16,160,sbVertical);
     FBlueScroll.color:=clBlue;
     FBlueScroll.SetScrollRange(0,255,1);
     FBlueScroll.LargeChange:=8;

     FDefaultCombo:=InsertComboBox(Self,120,160,150,20,csDropDownList);
     FDefaultCombo.Text:=LoadNLSStr(SDefaultColors);
     FDefaultCombo.sorted:=True;
     FDefaultCombo.DropDownCount := 7;
     FDefaultCombo.OnItemSelect:=EvSelectComboItem;
     For T:=1 To MaxDefaultColors
        Do FDefaultCombo.Items.Add(DefaultColors[T].Name);
     For T:=1 To MaxSystemColors
        Do FDefaultCombo.Items.Add(SystemColors[T].Name);

     FColorArea.Create(Self);
     FColorArea.SetWindowPos(120,20,150,120);
     FColorArea.BorderStyle:=bsSingle;
     FColorArea.BevelInner:=bvNone;
     FColorArea.BevelOuter:=bvNone;
     InsertControl(FColorArea);
     SetSelColor(FSelColor);

     FOkBtn := InsertBitBtn(Self,300,145,100,35,bkOk,LoadNLSStr(SSelectButton),LoadNLSStr(SClickHereToAccept));
     FOkBtn.Margin := 10;
     Btn := InsertBitBtn(Self,300,105,100,35,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     Btn.Margin := 10;
     Btn := InsertBitBtn(Self,300,65,100,35,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));
     Btn.Margin := 10;
End;


Procedure TColorDialog.SetupShow;
Begin
     Inherited SetupShow;

     FColorArea.Canvas.Brush.Mode := bmTransparent;

     FDefaultCombo.Focus;
     FOkBtn.Default := True;
End;


Procedure TColorDialog.SetSelColor(Value:TColor);
Begin
     FSelColor := SysColorToRGB(Value);
     FColorArea.color := FSelColor;
     FRedScroll.Position := TRGB(FSelColor).Red;
     FGreenScroll.Position := TRGB(FSelColor).Green;
     FBlueScroll.Position := TRGB(FSelColor).Blue;
     UpdateColorArea;
End;

{$HINTS OFF}
Procedure TColorDialog.Scroll(ScrollBar:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Begin
     TRGB(FSelColor).Fill:=0;
     If ScrollBar=FRedScroll Then TRGB(FSelColor).Red:=ScrollPos
     Else If ScrollBar=FGreenScroll Then TRGB(FSelColor).Green:=ScrollPos
     Else If ScrollBar=FBlueScroll Then TRGB(FSelColor).Blue:=ScrollPos;

     FDefaultCombo.Text := LoadNLSStr(SDefaultColors);
     UpdateColorArea;
End;


Procedure TColorDialog.EvSelectComboItem(Sender:TObject;Index:LongInt);
Var S:String;
    Col:TColor;
    T:LongInt;
Label found;
Begin
     S:=FDefaultCombo.Caption;

     For T:=1 To MaxDefaultColors Do
     Begin
          If DefaultColors[T].Name=S Then
          Begin
               FSelColor:=DefaultColors[T].Value;
               Goto found;
          End;
     End;

     For T:=1 To MaxSystemColors Do
     Begin
          If SystemColors[T].Name=S Then
          Begin
               FSelColor:=SystemColors[T].Value;
               break;
          End;
     End;
found:

     Col:=SysColorToRGB(FSelColor);
     FRedScroll.Position:=TRGB(Col).Red;
     FGreenScroll.Position:=TRGB(Col).Green;
     FBlueScroll.Position:=TRGB(Col).Blue;

     UpdateColorArea;
End;
{$HINTS ON}


Procedure TColorDialog.UpdateColorArea;
Var  Col:TColor;
Begin
     Col:=SysColorToRGB(FSelColor);
     FColorArea.PenColor := OppositeRGB(Col);
     FColorArea.color := Col;
     FColorArea.Caption := 'RGB('+tostr(TRGB(Col).Red)+','
                                 +tostr(TRGB(Col).Green)+','
                                 +tostr(TRGB(Col).Blue)+')';
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TFontDialog Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFontDialog.SetupComponent;
Var  T:LongInt;
     aFont:TFont;
     group:TGroupBox;
Begin
     Inherited SetupComponent;

     Name:='FontDialog';
     Caption:=LoadNLSStr(SSelectAFont);
     Width:=400;
     Height:=330;
     color:=clLtGray;

     group:=InsertGroupBox(Self,5,5,280,Height-40,'');
     group.ZOrder:=zoBottom;

     InsertLabel(Self,12,270,80,20,LoadNLSStr(SName)+':');
     FNameCombo:=InsertComboBox(Self,12,250-100,200,120,csDropDownList);
     FNameCombo.sorted := True;
     FNameCombo.Duplicates:=False;
     FNameCombo.OnItemSelect:=EvComboSelect;

     InsertLabel(Self,218,270,50,20,LoadNLSStr(SSize)+':');
     FSizeCombo:=InsertComboBox(Self,218,250-100,60,120,csDropDown);
     FSizeCombo.OnItemSelect:=EvComboSizeSelect;
     FSizeCombo.Duplicates:=False;

     group:=InsertGroupBox(Self,12,150,110,90,LoadNLSStr(SStyle));
     group.ZOrder:=zoTop;
     FItalicCheck:=InsertCheckBox(Self,20,200,95,20,LoadNLSStr(SItalic),'');
     FItalicCheck.OnClick:=StyleChanged;
     FBoldCheck:=InsertCheckBox(Self,20,180,95,20,LoadNLSStr(SBold),'');
     FBoldCheck.OnClick:=StyleChanged;

     group:=InsertGroupBox(Self,127,150,150,90,LoadNLSStr(SEmphasis));
     group.ZOrder:=zoTop;
     FOutlineCheck:=InsertCheckBox(Self,135,200,135,20,LoadNLSStr(SOutline),'');
     FOutlineCheck.OnClick:=StyleChanged;
     FStrikeOutCheck:=InsertCheckBox(Self,135,180,135,20,LoadNLSStr(SStrikeout),'');
     FStrikeOutCheck.OnClick:=StyleChanged;
     FUnderscoreCheck:=InsertCheckBox(Self,135,160,135,20,LoadNLSStr(SUnderscore),'');
     FUnderscoreCheck.OnClick:=StyleChanged;

     FExampleText:=InsertButton(Self,10,20,270,120,LoadNLSStr(SExampleText),'');
     FExampleText.OnClick:=StyleChanged;

     For T:=0 To Screen.FontCount-1 Do
     Begin
          aFont:=Screen.Fonts[T];
          FNameCombo.Items.Add(aFont.FaceName);
     End;
     FNameCombo.Items.Add('System Default Font');

     FOkBtn := InsertBitBtn(Self,290,240,90,30,bkOk,LoadNLSStr(SOkButton),LoadNLSStr(SClickHereToAccept));
     InsertBitBtn(Self,290,200,90,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     InsertBitBtn(Self,290,160,90,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));

     SetFontName('');  {Init}
End;


Procedure TFontDialog.SetupShow;
Begin
     SetTheFont;

     Inherited SetupShow;

     FNameCombo.Focus;
     FOkBtn.Default := True;
End;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
     Result:=FontName;
     UpcaseStr(FontName);
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',FontName)=0 Then Result:=Result+'.Italic';
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',FontName)=0 Then Result:=Result+'.Bold';
     If Attrs*[faOutline]<>[] Then Result:=Result+'.Outline';
     If Attrs*[faStrikeOut]<>[] Then Result:=Result+'.Strikeout';
     If Attrs*[faUnderScore]<>[] Then Result:=Result+'.Underscore';
End;

Function TFontDialog.GetAttributes:TFontAttributes;
Var S:String;
Begin
     Result:=[];

     S:=FNameCombo.Caption;
     UpcaseStr(S);
     If FItalicCheck.Checked Then
       If Pos(' ITALIC',S)=0 Then Result:=Result+[faItalic];
     If FBoldCheck.Checked Then
       If Pos(' BOLD',S)=0 Then Result:=Result+[faBold];
     If FOutlineCheck.Checked Then Result:=Result+[faOutline];
     If FStrikeOutCheck.Checked Then Result:=Result+[faStrikeOut];
     If FUnderscoreCheck.Checked Then Result:=Result+[faUnderScore];
End;

Procedure TFontDialog.SetAttributes(NewValue:TFontAttributes);
Var S:String;
Begin
     S:=FNameCombo.Caption;
     S:=ModifyFontName(S,NewValue);
     If PointSize<>0 Then FontName:=tostr(PointSize)+'.'+s
     Else FontName:=S;
End;

Function TFontDialog.GetFaceName:String;
Begin
     Result:=FNameCombo.Caption;
     Result:=ModifyFontName(Result,Attributes);
End;

Procedure TFontDialog.SetFaceName(Value:String);
Var S:String;
Begin
     S:=Value;
     UpcaseStr(S);
     FBoldCheck.Checked:=FBoldCheck.Checked Or(Pos(' BOLD',S)<>0);
     FItalicCheck.Checked:=FItalicCheck.Checked Or(Pos(' ITALIC',S)<>0);
     Value:=ModifyFontName(Value,Attributes);
     If PointSize<>0 Then FontName:=tostr(PointSize)+'.'+Value
     Else FontName:=Value;
End;


Function TFontDialog.GetPointSize:LongInt;
Var S:String;
    C:Integer;
Begin
     If FNameCombo.Caption='System Default Font' Then Result:=Screen.DefaultFont.PointSize
     Else
     Begin
         S:=FSizeCombo.Caption;
         Val(S,Result,C);
         If C<>0 Then Result:=0;
     End;
End;


Procedure TFontDialog.SetPointSize(Value:LongInt);
Begin
     If Value=0 Then Value:=8;
     FontName:=tostr(Value)+'.'+FaceName;
End;


Function TFontDialog.GetEditFont:TFont;
Begin
     Result:=Screen.GetFontFromPointSize(FaceName,PointSize);
End;

Procedure TFontDialog.SetEditFont(NewFont:TFont);
Var S:String;
    Attrs:TFontAttributes;
Begin
     If NewFont=Nil Then NewFont:=Screen.DefaultFont;

     If NewFont.IsDefault Then
     Begin
          S:=tostr(Screen.DefaultFont.PointSize)+'.'+'System Default Font';;
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=False;
          FontName:=S;
     End
     Else
     Begin
          S:=NewFont.FaceName;
          UpcaseStr(S);
          Attrs:=NewFont.Attributes;
          FBoldCheck.Checked:=(Pos(' BOLD',S)<>0)Or(Attrs*[faBold]<>[]);
          FItalicCheck.Checked:=(Pos(' ITALIC',S)<>0)Or(Attrs*[faItalic]<>[]);
          S:=NewFont.FaceName;
          S:=ModifyFontName(S,NewFont.Attributes);
          If NewFont.PointSize<>0 Then FontName:=tostr(NewFont.PointSize)+'.'+s
          Else FontName:=S;
     End;
End;

{$HINTS OFF}
Procedure TFontDialog.StyleChanged(Sender:TObject);
Begin
     If Handle<>0 Then SetTheFont;
End;
{$HINTS ON}

Function TFontDialog.GetFontName:String;
Begin
     Result := tostr(PointSize) + '.' + FaceName;
End;


Procedure TFontDialog.SetFontName(Value:String);
Var  S,s1:String;
     DefPointSize,T:LongInt;
     B:Byte;
     C:Integer;
     Attrs:TFontAttributes;
Label L;
Begin
     If Value = '' Then Value := '8.Helv';
     B := Pos('.',Value);
     If B <> 0 Then
     Begin
          S := Copy(Value,1,B-1);
          Delete(Value,1,B);
          If Value='' Then Value:='Helv';
          Val(S,DefPointSize,C);
          If C <> 0 Then DefPointSize := 8;
     End
     Else DefPointSize := 8;

     Attrs:=[];
     S:=Value;
     UpcaseStr(S);
L:
     For T:=Length(S) DownTo 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    Value[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
               End;
          End;
     End;

     If Value='System Default Font' Then
     Begin
          FNameCombo.Caption := Value;
          FSizeCombo.Caption := tostr(Screen.DefaultFont.PointSize);
     End
     Else
     Begin
          For T := 0 To Screen.FontCount-1 Do If Screen.Fonts[T].FaceName = Value Then
          Begin
               FNameCombo.Caption := Value;
               FSizeCombo.Caption := tostr(DefPointSize);
               break;
          End;
     End;

     UpcaseStr(Value);
     FItalicCheck.Checked:=((Attrs*[faItalic]<>[])Or(Pos(' ITALIC',Value)<>0));
     FBoldCheck.Checked:=((Attrs*[faBold]<>[])Or(Pos(' BOLD',Value)<>0));

     FOutlineCheck.Checked:=Attrs*[faOutline]<>[];
     FUnderscoreCheck.Checked:=Attrs*[faUnderScore]<>[];
     FStrikeOutCheck.Checked:=Attrs*[faStrikeOut]<>[];

     If Handle<>0 Then SetTheFont;
End;


Procedure TFontDialog.SetTheFont;
{$IFDEF OS2}
Var  C:cstring;
{$ENDIF}
Var  Font:TFont;
     IsDefault:Boolean;
     S,Value:String;
     T:LongInt;
     B:Byte;
Label L;
Begin
     IsDefault:=False;
     S:=FNameCombo.Caption;
     If S='System Default Font' Then
     Begin
          FSizeCombo.Caption:=tostr(Screen.DefaultFont.PointSize);
          FSizeCombo.Enabled:=False;
          IsDefault:=True;
     End
     Else FSizeCombo.Enabled:=True;

     For T:=0 To Screen.FontCount-1 Do
     Begin
          Font:=Screen.Fonts[T];
          If Font.FaceName=S Then
          Begin
               If Font.FontType=ftBitmap Then
               Begin
                    FOutlineCheck.Checked:=False;
                    FOutlineCheck.Enabled:=False;
               End
               Else FOutlineCheck.Enabled:=Not IsDefault;
               Goto L;
          End;
     End;

     FOutlineCheck.Enabled:=Not IsDefault;
L:
     Value:=FNameCombo.Caption;
     UpcaseStr(Value);

     If Pos(' ITALIC',Value)<>0 Then
     Begin
          If Not FItalicCheck.Checked Then
          Begin
               B:=Pos(' ITALIC',Value);
               S:=FNameCombo.Caption;
               Delete(S,B,7);
               FNameCombo.Caption:=S;
          End;
          FItalicCheck.Enabled:=True;
     End
     Else FItalicCheck.Enabled:=Not IsDefault;

     If Pos(' BOLD',Value)<>0 Then
     Begin
          If Not FBoldCheck.Checked Then
          Begin
               B:=Pos(' BOLD',Value);
               S:=FNameCombo.Caption;
               Delete(S,B,5);
               FNameCombo.Caption:=S;
          End;
          FBoldCheck.Enabled:=True;
     End
     Else FBoldCheck.Enabled:=Not IsDefault;

     Value:=FNameCombo.Caption;
     UpcaseStr(Value);
     FItalicCheck.Checked:=FItalicCheck.Checked Or (Pos(' ITALIC',Value)<>0);
     FBoldCheck.Checked:=FBoldCheck.Checked Or (Pos(' BOLD',Value)<>0);

     FStrikeOutCheck.Enabled:=Not IsDefault;
     FUnderscoreCheck.Enabled:=Not IsDefault;

     Font:=Screen.GetFontFromPointSize(FaceName,PointSize);
     InsertSizes(Font);
     If Font<>Nil Then
     Begin
          Font:=Screen.CreateCompatibleFont(Font);
          Font.AutoDestroy:=True;
          FExampleText.Font:=Font;
          FNameCombo.Caption:=FExampleText.Font.FaceName;
          FSizeCombo.Caption:=tostr(FExampleText.Font.PointSize);
     End
     Else
     Begin
          {$IFDEF OS2}
          C := FontName;
          WinSetPresParam(FExampleText.Handle,PP_FONTNAMESIZE,Length(C)+1,C);
          {$ENDIF}
     End;
End;

Procedure TFontDialog.InsertSizes(Var TheFont:TFont);
Var  C,c1,c2,T,t1:LongInt;
     OldCaption:String;
     cc:Integer;
     CaptionUpdated:Boolean;
     OldFont:TFont;
Label weiter,found,TryThis;
{$IFDEF WIN32}
Label defSize;
{$ENDIF}
Begin
     OldCaption:=FSizeCombo.Caption;

     FSizeCombo.BeginUpdate;
     FSizeCombo.Clear;

     {$IFDEF WIN32}
     goto defSize;
     {$ENDIF}

     If TheFont=Nil Then
     Begin
{$IFDEF WIN32}
defsize:
{$ENDIF}
          C:=4;
          While C<48 Do
          Begin
               FSizeCombo.Items.Add(tostr(C));
               Inc(C,2);
          End;
     End
     Else
     Begin
          If TheFont.MinimumPointSize=TheFont.MaximumPointSize Then
          Begin
               CaptionUpdated:=False;
TryThis:
               For T:=0 To Screen.FontCount-1 Do
               Begin
                    If Screen.Fonts[T].FaceName=FNameCombo.Caption Then
                    Begin
                         c2:=Screen.Fonts[T].MinimumPointSize;
                         If c2<4 Then c2:=4;

                         While ((c2<48)And(c2<=Screen.Fonts[T].MaximumPointSize)) Do
                         Begin
                              C:=c2;

                              For t1:=0 To FSizeCombo.Items.Count-1 Do
                              Begin
                                   Val(FSizeCombo.Items[t1],c1,cc);
                                   If cc=0 Then
                                   Begin
                                       If c1<4 Then c1:=4;
                                       If c1=C Then Goto weiter;
                                       If c1>C Then
                                       Begin
                                           Goto found;
                                       End;
                                   End;
                              End;
                              t1:=FSizeCombo.Items.Count;
found:
                              FSizeCombo.Items.Insert(t1,tostr(C));
weiter:
                              If c2 And 1<>0 Then Inc(c2)
                              Else Inc(c2,2);
                         End; //While
                    End;
               End;

               If ((Not CaptionUpdated)And(FSizeCombo.Items.IndexOf(OldCaption)<0)) Then
               Begin
                    If ((TheFont.NominalPointSize<>0)And
                        (FSizeCombo.Items.IndexOf(tostr(TheFont.NominalPointSize))>=0)) Then
                      OldCaption:=tostr(TheFont.NominalPointSize)
                    Else If FSizeCombo.Items.Count>0 Then
                      OldCaption:=FSizeCombo.Items[0];
               End;
          End
          Else
          Begin
               C:=TheFont.MinimumPointSize;
               If C<4 Then C:=4;

               While ((C<48)And(C<=TheFont.MaximumPointSize)) Do
               Begin
                    FSizeCombo.Items.Add(tostr(C));
                    If C And 1<>0 Then Inc(C)
                    Else Inc(C,2);
               End;

               Val(OldCaption,c1,cc);
               If cc=0 Then
               Begin
                    If ((c1<TheFont.MinimumPointSize)Or(c1>TheFont.MaximumPointSize)) Then
                    Begin
                         If TheFont.NominalPointSize<>0 Then
                           OldCaption:=tostr(TheFont.NominalPointSize)
                         Else If FSizeCombo.Items.Count>0 Then
                           OldCaption:=FSizeCombo.Items[0];
                    End;
               End;
               CaptionUpdated:=True;
               Goto TryThis;
          End;
     End;

     FSizeCombo.Caption := OldCaption;
     FSizeCombo.EndUpdate;
     //recreate Font In Case that Size changed
     OldFont:=TheFont;
     TheFont:=Screen.GetFontFromPointSize(FaceName,PointSize);
     If TheFont=Nil Then TheFont:=OldFont;
End;


{$HINTS OFF}
Procedure TFontDialog.EvComboSelect(Sender:TObject;Index:LongInt);
Var S:String;
Begin
     S:=FNameCombo.Text;
     UpcaseStr(S);
     If Pos(' BOLD',S)<>0 Then
     Begin
          If Pos(' ITALIC',S)<>0 Then
          Begin
               FBoldCheck.Checked:=True;
               FItalicCheck.Checked:=True;
          End
          Else
          Begin
               FBoldCheck.Checked:=True;
               FItalicCheck.Checked:=False;
          End;
     End
     Else If Pos(' ITALIC',S)<>0 Then
     Begin
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=True;
     End
     Else
     Begin
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=False;
     End;

     SetTheFont;
End;


Procedure TFontDialog.EvComboSizeSelect(Sender:TObject;Index:LongInt);
Begin
     SetTheFont;
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPrintDialog Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TPrintDialog.Execute;
Begin
  FPrintAll.Checked := True;
  FPrinter.Checked := True;
  FPrinter.Caption := Printer.Printers [Printer.PrinterIndex];
  FNumberOfCopiesEdit.Caption := '1';
  FPrintFromEdit.Caption := IntToStr (FMinPage);
  FPrintToEdit.Caption := IntToStr (FMaxPage);
  FNumberOfCopies.Min := 1;
  FNumberOfCopies.Max := 9999;
  FTitle.Caption := Printer.Title;
  Result := Inherited Execute;
  If Result Then
  Begin
    Printer.Title := FTitle.Caption;
    If FFileOutPut.Checked Then
    Begin
      Printer.PrintToFile := True;
      Printer.FileName := FFile.Caption;
    End
    Else
      Printer.PrintToFile := False;
    If FPrintAll.Checked Then
    Begin
      FAllPages := True;
      FromPage := MinPage;
      ToPage := MaxPage;
    End
    Else
    Begin
      FAllPages := False;
      FromPage := StrToInt (FPrintFromEdit.Caption);
      ToPage := StrToInt (FPrintToEdit.Caption);
      MinPage := StrToInt (FPrintFromEdit.Caption);
      MaxPage := StrToInt (FPrintToEdit.Caption);
    End;
    Printer.copies := StrToInt (FNumberOfCopiesEdit.Caption);
  End;
End;

Procedure TPrintDialog.SetMinPage;
Begin
  FMinPage := NewValue;
  FFromPage := FMinPage;
  FPrintFrom.Min := FFromPage;
  FPrintTo.Min := FFromPage;
End;

Procedure TPrintDialog.SetMaxPage;
Begin
  FMaxPage := NewValue;
  FToPage := FMaxPage;
  FPrintFrom.Max := FToPage;
  FPrintTo.Max := FToPage;
End;

Procedure TPrintDialog.SetToPage;
Begin
  FToPage := NewValue;
  FPrintFrom.Max := FToPage;
  FPrintTo.Max := FToPage;
End;

Procedure TPrintDialog.SetFromPage;
Begin
  FFromPage := NewValue;
  FPrintFrom.Min := FFromPage;
  FPrintTo.Min := FFromPage;
End;

Procedure TPrintDialog.SetOkName;
Begin
  FPrintButton.Caption := NewName;
  FOkName := NewName;
End;

{$HINTS OFF}
Procedure TPrintDialog.PropertyBtnClicked;
Begin
  Printer.OptionsDlg;
End;
{$HINTS ON}

Procedure TPrintDialog.SetupComponent;
Begin
  Inherited SetupComponent;
  Name := 'PrintDialog';
  Caption := LoadNLSStr(SPrint);
  FOkName := LoadNLSStr(SPrintButton);
  Width := 500;
  Height := 330;
  FPrintButton := TBitBtn.Create (Self);
  FPrintButton.Kind := bkOk;
  FPrintButton.Margin := 10;
  FCancelButton := TBitBtn.Create (Self);
  FCancelButton.Kind := bkCancel;
  FCancelButton.Margin := 10;
  FPropertyButton := TBitBtn.Create (Self);
  FPropertyButton.Glyph.LoadFromResourceName('StdBmpProp');
  FPropertyButton.Kind := bkCustom;
  FPropertyButton.Margin := 10;
  FHelpButton := TBitBtn.Create (Self);
  FHelpButton.Kind := bkHelp;
  FHelpButton.Command := cmHelp;
  FHelpButton.Margin := 10;
  FTitleBox := TGroupBox.Create (Self);
  FTitle := TEdit.Create (Self);
  FPagesBox := TRadioGroup.Create (Self);
  FPrintFromLabel := TRadioButton.Create (Self);
  FPrintFromEdit := TEdit.Create (Self);
  FPrintFrom := TUpDown.Create (Self);
  FPrintToLabel := TLabel.Create (Self);
  FPrintToEdit := TEdit.Create (Self);
  FPrintTo := TUpDown.Create (Self);
  FPrintAll := TRadioButton.Create (Self);
  FOptionsBox := TRadioGroup.Create (Self);
  FPrinter := TRadioButton.Create (Self);
  FFileOutPut := TRadioButton.Create (Self);
  FFile := TEdit.Create (Self);
  FNumberOfCopiesLabel := TLabel.Create (Self);
  FNumberOfCopiesEdit := TEdit.Create (Self);
  FNumberOfCopies := TUpDown.Create (Self);
  FPrintButton.SetWindowPos (330, 250, 150, 30);
  FCancelButton.SetWindowPos (330, 210, 150, 30);
  FPropertyButton.SetWindowPos (330, 170, 150, 30);
  FHelpButton.SetWindowPos (330, 15, 150, 30);
  FTitleBox.SetWindowPos (15, 230, 300, 60);
  FTitle.SetWindowPos (10, 13, 280, 20);
  FPagesBox.SetWindowPos (15, 140, 300, 85);
  FPrintFromLabel.SetWindowPos (10, 40, 70, 20);
  FPrintFromEdit.SetWindowPos (85, 37, 60, 20);
  FPrintFrom.SetWindowPos (145, 37, 21, 20);
  FPrintToLabel.SetWindowPos (175, 37, 30, 20);
  FPrintToLabel.PenColor := clBlack;
  FPrintToEdit.SetWindowPos (205, 37, 60, 20);
  FPrintTo.SetWindowPos (265, 37, 21, 20);
  FPrintAll.SetWindowPos (10, 15, 60, 20);
  FOptionsBox.SetWindowPos (15, 15, 300, 120);
  FPrinter.SetWindowPos (10, 75, 280, 20);
  FFileOutPut.SetWindowPos (10, 50, 50, 20);
  FFile.SetWindowPos (85, 48, 200, 20);
  FNumberOfCopiesLabel.SetWindowPos (12, 17, 60, 20);
  FNumberOfCopiesLabel.PenColor := clBlack;
  FNumberOfCopiesEdit.SetWindowPos (85, 15, 60, 20);
  FNumberOfCopies.SetWindowPos (145, 15, 21, 20);
  InsertControl (FPrintButton);
  InsertControl (FCancelButton);
  InsertControl (FPropertyButton);
  InsertControl (FHelpButton);
  InsertControl (FTitleBox);
  FTitleBox.InsertControl (FTitle);
  InsertControl (FOptionsBox);
  FOptionsBox.InsertControl (FNumberOfCopiesLabel);
  FOptionsBox.InsertControl (FNumberOfCopies);
  FOptionsBox.InsertControl (FNumberOfCopiesEdit);
  InsertControl (FPagesBox);
  FPagesBox.InsertControl (FPrintFromLabel);
  FPagesBox.InsertControl (FPrintFrom);
  FPagesBox.InsertControl (FPrintFromEdit);
  FPagesBox.InsertControl (FPrintToLabel);
  FPagesBox.InsertControl (FPrintTo);
  FPagesBox.InsertControl (FPrintToEdit);
  FPagesBox.InsertControl (FPrintAll);
  FOptionsBox.InsertControl (FPrinter);
  FOptionsBox.InsertControl (FFileOutPut);
  FOptionsBox.InsertControl (FFile);
  FPrintButton.Caption := LoadNLSStr(SPrintButton);
  FCancelButton.Caption := LoadNLSStr(SCancelButton);
  FPropertyButton.Caption := LoadNLSStr(SProperties);
  FHelpButton.Caption := LoadNLSStr(SHelpButton);
  FTitleBox.Caption := LoadNLSStr(STitle);
  FOptionsBox.Caption := LoadNLSStr(SOptions);
  FNumberOfCopiesLabel.Caption := LoadNLSStr(SCopies);
  FPagesBox.Caption := LoadNLSStr(SPages);
  FPrintFromLabel.Caption := LoadNLSStr(SFrom);
  FPrintToLabel.Caption := LoadNLSStr(STo);
  FPrintAll.Caption := LoadNLSStr(SAllButton);
  FOptionsBox.Caption := LoadNLSStr(SOptions);
  FFileOutPut.Caption := LoadNLSStr(SFile);
  FPrintFrom.Associate := FPrintFromEdit;
  FPrintTo.Associate := FPrintToEdit;
  FNumberOfCopies.Associate := FNumberOfCopiesEdit;
  FTitle.Caption := Printer.Title;
  FPropertyButton.OnClick := PropertyBtnClicked;
  FMaxPage := 1;
  FMinPage := 1;
  FFromPage := FMinPage;
  FToPage := FMaxPage;
  FPrintFrom.Min := FFromPage;
  FPrintFrom.Max := FToPage;
  FPrintTo.Min := FFromPage;
  FPrintTo.Max := FToPage;
  FPrintButton.Hint := LoadNLSStr(SClickHereToAccept);
  FCancelButton.Hint := LoadNLSStr(SClickHereToCancel);
  FPropertyButton.Hint := LoadNLSStr(SClickHereToSetProperties);
  FHelpButton.Hint := LoadNLSStr(SClickHereToGetHelp);
  FNumberOfCopiesEdit.OnFontChange := UpdateSpinSize;
  FPrintFromEdit.OnFontChange := UpdateSpinSize;
  FPrintToEdit.OnFontChange := UpdateSpinSize;
  FPrintButton.Focus;
  FPrintButton.TabStop := True;
  FCancelButton.TabStop := True;
  FPropertyButton.TabStop := True;
  FHelpButton.TabStop := True;
  FTitle.TabStop := True;
  FNumberOfCopiesEdit.TabStop := True;
  FPrintFromLabel.TabStop := True;
  FPrintFromEdit.TabStop := True;
  FTitleBox.TabStop := False;
  FOptionsBox.TabStop := False;
  FNumberOfCopiesLabel.TabStop := False;
  FNumberOfCopies.TabStop := False;
  FPagesBox.TabStop := False;
  FPrintFrom.TabStop := False;
  FPrintToLabel.TabStop := False;
  FPrintTo.TabStop := False;
  FPrintButton.TabOrder := 0;
  FCancelButton.TabOrder := 1;
  FPropertyButton.TabOrder := 2;
  FHelpButton.TabOrder := 3;
  FTitle.TabOrder := 4;
  FPrintFromLabel.TabOrder := 5;
  FPrintFromEdit.TabOrder := 6;
  FPrintToEdit.TabOrder := 7;
  FPrintAll.TabOrder := 8;
  FPrinter.TabOrder := 9;
  FFileOutPut.TabOrder := 10;
  FFile.TabOrder := 11;
  FNumberOfCopiesEdit.TabOrder := 12;
End;

{$HINTS OFF}
Procedure TPrintDialog.UpdateSpinSize;
Begin
  FNumberOfCopies.Height := FNumberOfCopiesEdit.Height;
  FPrintFrom.Height := FPrintFromEdit.Height;
  FPrintTo.Height := FPrintToEdit.Height;
End;
{$HINTS ON}



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPrinterSetupDialog Class Implementation                    บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$HINTS OFF}
Procedure TPrinterSetupDialog.PrinterSelected(Sender:TObject;Index:LongInt);
Begin
  Printer.PrinterIndex := FPrinterList.ItemIndex;
  DismissDlg (cmOk);
End;

Procedure TPrinterSetupDialog.PrinterFocused(Sender:TObject;Index:LongInt);
Begin
  Printer.PrinterIndex := FPrinterList.ItemIndex;
End;

Procedure TPrinterSetupDialog.PropertyBtnClicked(Sender:TObject);
Begin
  Printer.OptionsDlg;
End;
{$HINTS ON}

Procedure TPrinterSetupDialog.SetOkName;
Begin
  FSetPrinterButton.Caption := NewName;
  FOkName := NewName;
End;

Procedure TPrinterSetupDialog.SetupComponent;
Begin
  Inherited SetupComponent;
  Name := 'PrinterSetupDialog';
  Caption := LoadNLSStr(SSetupPrinter);
  FOkName := LoadNLSStr(SSetPrinter);
  Width := 450;
  Height := 285;
  color := clDlgWindow;
  FPrinterListHeadLine := TLabel.Create (Self);
  FPrinterList := TListBox.Create (Self);
  FSetPrinterButton := TBitBtn.Create (Self);
  FSetPrinterButton.Kind := bkOk;
  FSetPrinterButton.Margin := 10;
  FCancelButton := TBitBtn.Create (Self);
  FCancelButton.Kind := bkCancel;
  FCancelButton.Margin := 10;
  FPropertyButton := TBitBtn.Create (Self);
  FPropertyButton.ModalResult := cmNull;
  FPropertyButton.Glyph.LoadFromResourceName('StdBmpProp');
  FPropertyButton.Margin := 10;
  FHelpButton := TBitBtn.Create (Self);
  FHelpButton.Kind := bkHelp;
  FHelpButton.Command := cmHelp;
  FHelpButton.Margin := 10;
  FPrinterListHeadLine.SetWindowPos (15, 230, 250, 20);
  FPrinterList.SetWindowPos (15, 15, 250, 215);
  FSetPrinterButton.SetWindowPos (280, 200, 150, 30);
  FCancelButton.SetWindowPos (280, 160, 150, 30);
  FPropertyButton.SetWindowPos (280, 120, 150, 30);
  FHelpButton.SetWindowPos (280, 15, 150, 30);
  InsertControl (FPrinterListHeadLine);
  InsertControl (FPrinterList);
  InsertControl (FSetPrinterButton);
  InsertControl (FCancelButton);
  InsertControl (FPropertyButton);
  InsertControl (FHelpButton);
  FPropertyButton.OnClick := PropertyBtnClicked;
  FPrinterList.OnItemSelect := PrinterSelected;
  FPrinterList.OnItemFocus := PrinterFocused;
  FPrinterListHeadLine.Caption := LoadNLSStr(SCurrentPrinter)+':';
  FSetPrinterButton.Caption := LoadNLSStr(SSetPrinter);
  FCancelButton.Caption := LoadNLSStr(SCancelButton);
  FPropertyButton.Caption := LoadNLSStr(SProperties);
  FSetPrinterButton.Hint := LoadNLSStr(SClickHereToAccept);
  FPropertyButton.Hint := LoadNLSStr(SClickHereToSetProperties);
  FCancelButton.Hint := LoadNLSStr(SClickHereToCancel);
  FHelpButton.Hint := LoadNLSStr(SClickHereToGetHelp);
  FPrinterListHeadLine.TabStop := False;
  FPrinterList.TabStop := True;
  FSetPrinterButton.TabStop := True;
  FPropertyButton.TabStop := True;
  FCancelButton.TabStop := True;
  FHelpButton.TabStop := True;
  FPrinterList.TabOrder := 1;
  FSetPrinterButton.TabOrder := 2;
  FCancelButton.TabOrder := 3;
  FPropertyButton.TabOrder := 4;
  FHelpButton.TabOrder := 5;
  FSetPrinterButton.Focus;
End;

Function TPrinterSetupDialog.Execute;
Begin
  FPrinterList.Items := Printer.Printers;
  FOldPrinterIndex := Printer.PrinterIndex;
  FPrinterList.ItemIndex := FOldPrinterIndex;
  Result := Inherited Execute;
  If Not Result Then
    Printer.PrinterIndex := FOldPrinterIndex;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMessageBox Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMessageBox.SetupComponent;
Begin
     Inherited SetupComponent;

     FButtons:=[mbOk];
     fType:=mtInformation;
     Caption:='';
End;

Procedure TMessageBox.SetupShow;
Const SButtonNames:Array[mbYes..mbHelp] Of String[15]=
          (
           '~Yes','~No','~OK','~Cancel','~Abort','~Retry','~Ignore','~All','~Help'
          );
      SButtonKinds:Array[mbYes..mbHelp] Of TBitBtnKind=
          (
           bkYes,bkNo,bkOk,bkCancel,bkAbort,bkRetry,bkIgnore,bkAll,bkHelp
          );
      ButtonOrder:Array[0..8] of TMsgDlgBtn=
          (
           mbHelp, mbYes, mbOK, mbRetry, mbAll, mbIgnore, mbNo, mbAbort, mbCancel
          );
Var  FLabel:TLabel;
     CX,CY:LongInt;
     LabelX:LongInt;
     BtnX:LongInt;
     tw:LongInt;
     PictureY:LongWord;
     ButtonNames:Array[1..10] Of String[15];
     ButtonKinds:Array[1..10] Of TBitBtnKind;
     ButtonCount,T:LongInt;
     Btn:TBitBtn;
     Button:TMsgDlgBtn;
     ButtonIndex:longint;
     MaxWidth,W:LongInt;
Begin
     Inherited SetupShow;

     SButtonNames[mbYes]:=LoadNLSStr(SYesButton);
     SButtonNames[mbNo]:=LoadNLSStr(SNoButton);
     SButtonNames[mbOk]:=LoadNLSStr(SOkButton);
     SButtonNames[mbCancel]:=LoadNLSStr(SCancelButton);
     SButtonNames[mbAbort]:=LoadNLSStr(SAbortButton);
     SButtonNames[mbRetry]:=LoadNLSStr(SRetryButton);
     SButtonNames[mbIgnore]:=LoadNLSStr(SIgnoreButton);
     SButtonNames[mbAll]:=LoadNLSStr(SAllButton);
     SButtonNames[mbHelp]:=LoadNLSStr(SHelpButton);

     //check Single Buttons. only the following values are Valid And can be or'ed
     //mbYes,mbNo,mbOk,mbCancel,mbHelp,mbAbort.mbRetry,mbIgnore,mbAll
     //All Buttons are invisible
     MaxWidth:=340;
     W:=0;
     ButtonCount:=0;

     For ButtonIndex:=Low(ButtonOrder) To High(ButtonOrder) Do
     Begin
          Button := ButtonOrder[ ButtonIndex ];
          If Button IN FButtons Then
          Begin
               Inc(ButtonCount);
               ButtonNames[ButtonCount]:=SButtonNames[ Button ];
               ButtonKinds[ButtonCount]:=SButtonKinds[ Button ];

               Inc(W, Canvas.TextWidth(ButtonNames[ButtonCount]) + 20);
               If ShowBitBtnGlyph Then Inc(W, 25);
               //Inc(W,100);

               If W > MaxWidth Then
               Begin
                    If W > Screen.Width-50 Then break;
                    MaxWidth := W;
               End;
          End;
     End;

     LabelX := 20;
     If fType<>mtCustom Then Inc(LabelX,32);

     FLabel := InsertLabel(Self,LabelX,60,MaxWidth,20,FMsg);
     FLabel.WordWrap := True;
     FLabel.ShowAccelChar := False;
     FLabel.Height := FLabel.Canvas.Font.Height * FLabel.Rows;

     PictureY := FLabel.Bottom + FLabel.Height - 32;

     CX := LabelX + MaxWidth + 25;
     CY := 10 + 30 + 20 + FLabel.Height + 45;

     {Center Box}
     SetWindowPos(Left,Bottom,CX,CY);

     If fType<>mtCustom Then
     Begin
          If fType=mtConfirmation Then InsertImageName(Self,10,PictureY,32,32,'StdBmpAsk')
          Else If fType In [mtError,mtCritical,mtWarning] Then InsertImageName(Self,10,PictureY,32,32,'StdBmpHand')
          Else InsertImageName(Self,10,PictureY,32,32,'StdBmpInfo');
     End;

     If Caption='' Then  //overwrite Default
     Begin
         If fType=mtWarning Then Caption:=LoadNLSStr(SWarning)
         Else If fType=mtInformation Then Caption:=LoadNLSStr(sInformation)
         Else If fType=mtConfirmation Then Caption:=LoadNLSStr(SConfirmation)
         Else If fType=mtCritical Then Caption:=LoadNLSStr(SCriticalError)
         Else If fType=mtError Then Caption:=LoadNLSStr(SError)
         Else If fType=mtCustom Then Caption:=ParamStr(0)
         Else Caption:=LoadNLSStr(sInformation);
     End;

     //Create the Buttons
     BtnX:=10;
     For T:=1 To ButtonCount Do
     Begin
          tw := Canvas.TextWidth(ButtonNames[T]) + 20;
          If ShowBitBtnGlyph Then Inc(tw, 25);
          Btn := InsertBitBtn(Self,BtnX,10,tw,30,ButtonKinds[T],ButtonNames[T],'');
          Inc(BtnX, tw + 10);
          //Inc(BtnX,100);
          If T=1 Then Btn.Focus;
     End;
End;



Begin
End.

