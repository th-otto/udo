Unit ComponentsTestForm;

Interface

Uses
  Classes,
  Forms,
  Graphics,
  RichTextView,
  Buttons,
  TabCtrls,
  ComCtrls,
  ExtCtrls,
  StdCtrls,
  Outline2,
  ACLDialogs,
  ColorWheel,
  CustomListBox,
  Coolbar2,
  CustomFileControls,
  CustomFontDialog,
  MultiColumnListBox,
  SystemIconUnit,
 
  // custom components not directly used but there to
  // compile
  SplitBar,
  Tabset2Unit,
  GenericThread;

type
  TScanParameters = class
    Path: string;
  end;

  TComponentsTestForm = Class (TForm)
    TabbedNotebook1: TTabbedNotebook;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu5: TMainMenu;
    ImageList2: TImageList;
    Button7: TButton;
    SpeedButton1: TSpeedButton;
    Button10: TButton;
    ListBox2: TListBox;
    Button13: TButton;
    Button14: TButton;
    Memo1: TMemo;
    Button16: TButton;
    Image1: TImage;
    DirectoryListBox1: TCustomDirectoryListBox;
    Button15: TButton;
    Panel1: TPanel;
    Button12: TButton;
    Button11: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Button6: TButton;
    RadioGroup1: TRadioGroup;
    Button3: TButton;
    Button8: TButton;
    Button4: TButton;
    Button5: TButton;
    RT: TRichTextView;
    Button2: TButton;
    Button1: TButton;
    AnOutline: TOutline2;
    Procedure Edit1OnChange (Sender: TObject);
    Procedure Button16OnClick (Sender: TObject);
    Procedure Button15OnClick (Sender: TObject);
    Procedure Button14OnClick (Sender: TObject);
    Procedure Button13OnClick (Sender: TObject);
    Procedure Button12OnClick (Sender: TObject);
    Procedure Button11OnClick (Sender: TObject);
    Procedure Button10OnClick (Sender: TObject);
    Procedure Button9OnClick (Sender: TObject);
    Procedure SpeedButton1OnClick (Sender: TObject);
    Procedure Button7OnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    Procedure Button6OnClick (Sender: TObject);
    Procedure CoolBar1OnSectionClick (HeaderControl: THeaderControl;
      section: THeaderSection);
    Procedure Button8OnClick (Sender: TObject);
    Procedure Button7OnClick (Sender: TObject);
    Procedure Button5OnClick (Sender: TObject);
    Procedure Button4OnClick (Sender: TObject);
    Procedure Button3OnClick (Sender: TObject);
    Procedure RTOnClickLink (Sender: TRichTextView; Link: String);
    Procedure RTOnOverLink (Sender: TRichTextView; Link: String);
    Procedure RichTextView1OnOverLink (Sender: TRichTextView; Link: String);
    Procedure Button2OnClick (Sender: TObject);
    Procedure TabbedNotebook1OnSetupShow (Sender: TObject);
    Procedure MainFormOnCreate (Sender: TObject);
    Procedure RTOnSetupShow (Sender: TObject);
    Procedure MainFormOnShow (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
  Protected
  MLB: TMultiColumnListBox;
    cb: TCoolbar2;
    clb: TCustomListBox;
    Procedure Oncustomlistitemfocus( Sender: TObject; Index: longint );
    procedure OnOutlineEvent( Node: TNode );
    Procedure loadcustomlist;
  End;

Var
  ComponentsTestForm: TComponentsTestForm;

Implementation

uses
  PMWin,
  Os2Def,
  Dialogs,
  SysUtils,
  Printers,
  ControlScrolling,
  ACLResourceUtility,
  RichTextPrintUnit,
  RichTextStyleUnit,
  ACLLanguageUnit,
  CharUtilsUnit,
  DebugUnit;

{$R DialogIcons}

Procedure TComponentsTestForm.Edit1OnChange (Sender: TObject);
Begin

End;

Procedure TComponentsTestForm.Button16OnClick (Sender: TObject);
var
  p: pchar;
  l: longint;
Begin
  l := SendMsg( RT.Handle,
                RT_QUERYSELTEXT,
                0, // length only
                0 );
  Memo1.Lines.Add( 'length is ' + IntToStr( l ) );
  p := StrAlloc( l );

  SendMsg( RT.Handle,
           RT_QUERYSELTEXT,
           ULONG( p ),
           4 );

  Memo1.Lines.Add( StrPasWithLength( p, l ) );

  StrDispose( p );
End;

Procedure TComponentsTestForm.Button15OnClick (Sender: TObject);
var
  s: string;
Begin
  DoInputQUery( 'Cake', 'Enter cake:', s );
End;

Procedure TComponentsTestForm.Button14OnClick (Sender: TObject);
Begin
  Application.HelpContents;
End;

Procedure TComponentsTestForm.Button13OnClick (Sender: TObject);
var
  PageY: longint;
  RichTextSettings: TRichTextSettings;
Begin
  if Printer.Printers.Count = 0 then
  begin
    ShowMessage( 'You don''t have a printer configured.' );
    exit;
  end;

  Printer.Title := 'Test print';

  Printer.BeginDoc;

//  Printer.Canvas.Font := Screen.GetFontFromPointSize( 'Courier', 12 );
//  Printer.Canvas.TextOut( 0, 0, 'Bergurk' );


  PageY := Printer.PageHeight - 1;

  RichTextSettings:= TRichTextSettings.Create( self );

  RichTextSettings.NormalFont := Screen.GetFontFromPointSize( 'Tms Rmn', 8 );
//  RichTextSettings.FixedFont := Screen.GetFontFromPointSize( 'Helv', 8 );

  PrintRichText( 'Some cake and cheese honk-wozel',
                 nil,
                 RichTextSettings,
                 PageY );

  Printer.EndDoc;

End;

Procedure TComponentsTestForm.Button12OnClick (Sender: TObject);
Begin
  loadcustomlist;
End;

Procedure TComponentsTestForm.Button11OnClick (Sender: TObject);
Begin
  cb.EditSections;
End;

Procedure TComponentsTestForm.Button10OnClick (Sender: TObject);
var
  dlg: TFontDialog;
Begin
  dlg:= TFontDialog.Create( self );
  dlg.Execute;
  dlg.Destroy;
End;

Procedure TComponentsTestForm.Button9OnClick (Sender: TObject);
var
  dlg: TCustomFontDialog;
Begin
  dlg:= TCustomFontDialog.Create( self );
  dlg.Execute;
  dlg.Destroy;
End;

Procedure TComponentsTestForm.SpeedButton1OnClick (Sender: TObject);
Begin
  MLB.Enabled := not MLB.Enabled;
End;

Procedure TComponentsTestForm.Button7OnMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
Begin

End;

Procedure TComponentsTestForm.Button6OnClick (Sender: TObject);
Begin
End;

Procedure TComponentsTestForm.CoolBar1OnSectionClick (HeaderControl: THeaderControl; section: THeaderSection);
Begin

End;

Procedure TComponentsTestForm.Button8OnClick (Sender: TObject);
Begin
//  DirectoryListBox1.Directory:= DriveComboBox3.Drive + ':\';
End;

Procedure TComponentsTestForm.Button7OnClick (Sender: TObject);
Begin
End;


Procedure TComponentsTestForm.Button5OnClick (Sender: TObject);
Begin
  AnOutline.GotoNextNodeDown;
End;

Procedure TComponentsTestForm.Button4OnClick (Sender: TObject);
Begin
  AnOutline.GotoNextNodeUp;
End;

Procedure TComponentsTestForm.Button3OnClick (Sender: TObject);
var
  M1: longword;
Begin
  M1:= MemAvail;
  AnOutline.Clear;
  StatusBar.SimpleText:= 'Mem freed from outline: ' + IntToStr( MemAvail - M1  );
End;

Procedure TComponentsTestForm.RTOnClickLink (Sender: TRichTextView;
  Link: String);
Begin
  ShowMessage( 'You clicked: ' + Link );
End;

Procedure TComponentsTestForm.RTOnOverLink (Sender: TRichTextView;
  Link: String);
Begin
  StatusBar.SimpleText:= 'Link to: ' + Link;
  StatusBar.Refresh;
End;

Procedure TComponentsTestForm.RichTextView1OnOverLink (Sender: TRichTextView;
  Link: String);
Begin

End;

Procedure TComponentsTestForm.Button2OnClick (Sender: TObject);
Begin
  DoConfirmDlg( 'Test', 'THis is the prompt you should be seeing' );
End;

Procedure TComponentsTestForm.TabbedNotebook1OnSetupShow (Sender: TObject);
Begin
End;

Procedure TComponentsTestForm.Oncustomlistitemfocus( Sender: TObject;
                                                     Index: longint );
begin
  if   Panel1.Color = clBlack then
    Panel1.Color := clRed
  else
    Panel1.Color := clBlack;
end;

Procedure TComponentsTestForm.loadcustomlist;
begin
  clb.StartUpdate;
  clb.Items.Clear;
  clb.Items.Add( 'A' );
  clb.Items.Add( 'B' );
  clb.Items.Add( 'C' );
  clb.ItemIndex := 0;
  clb.CompleteUpdate;
end;

Procedure TComponentsTestForm.MainFormOnCreate (Sender: TObject);
var
//  DriveCombobox: TCustomDriveComboBox;
  IconImage: TSystemIcon;
Begin
  IconImage := TSystemIcon.Create( self );
  IconImage.Parent := self; //TabbedNotebook1.Pages.Pages[ 3 ];

  IconImage.Bottom := ListBox2.Bottom;
  IconImage.ID := siIconInformation;

  clb:= Tcustomlistbox.Create( self );
  clb.Parent := TabbedNotebook1.Pages.Pages[ 0 ];
  clb.MultiSelect := true;
  clb.ExtendedSelect := true;
  clb.OnItemFocus := Oncustomlistitemfocus;

  loadcustomlist;

  cb := TCoolbar2.Create( self );
  cb.Parent := TabbedNotebook1.Pages.Pages[ 6 ];



//  DriveCombobox:= TCustomDriveComboBox.Create( self );
//  DriveCombobox.Parent:= self;
//  DriveCombobox.Width := 200;
  RadioGRoup1.ItemIndex := 3;

//  RT.Images:= nil;
//  ImageList2.Destroy;
  TabbedNotebook1.yStretch:= ysFrame;
  StatusBar.SimpleText:= 'OK';
End;

Procedure TComponentsTestForm.RTOnSetupShow (Sender: TObject);
Begin

End;

Procedure TComponentsTestForm.MainFormOnShow (Sender: TObject);
var
  Node, Node2: TNode;
  i,j: integer;
  M1: longint;


  Stream:TResourceStream;
  met: TMetafile;
  cw: TColorWHeel;
Begin
  met := TMetafile.cReate;
  met.LoadFromFIle( 'w:\sibyl\martin\test1.met' );

  Image1.Graphic := met;
  ListBox2.Sorted := true;
  ListBox2.Items.Add( 'Banana' );
  ListBox2.Items.Add( 'Apple' );

  cw := TColorWHeel.Create( self );
  cw.Parent := TabbedNotebook1.Pages.Pages[ 1 ];

  RT:= TRichTextView.Create( self );

  RT.Parent:= TabbedNotebook1.Pages.Pages[ 1 ];

  RT.RichTextSettings.Margins.Left := 0; // 50;
  RT.RichTextSettings.Margins.Right := 0; // 50;

  RT.RichTextSettings.DefaultWrap := true;
  RT.RichTextSettings.AtLeastOneWordBeforeWrap := true;
  RT.RichTextSettings.MarginSizeStyle := msAverageCharWidth;


  RT.Align:= alClient;
//  RT.BorderStyle := bsNone;
//  RT.RichTextSettings.NormalFont := Screen.GetFontFromPointSize( 'Times New Roman', 10 );
//  RT.RichTextSettings.FixedFont := Screen.GetFontFromPointSize( 'Courier New', 10 );
//  RT.AddParagraph( 'Bok<leftmargin 10>Cheese weasels and cake, not to mention substantial '
//                   + 'widgings of wodgeriness!' );
//  RT.RichTextSettings.NormalFont := Screen.GetFontFromPointSize( 'Arial', 24 );

  RT.AddParagraph( 'This <leftmargin here><b>is</b> a big <h2>box</h> of cheese' );
  RT.AddParagraph( '<tt>This <i>is</i> a </tt> big <h2>box</h> of cheese' );
  RT.AddParagraph( '<font "Photina" 11><leftmargin 4>big font </font> heading by << Jiggolo >>' );

  RT.AddParagraph( '<align center>Centered<align default>' );
  Rt.AddParagraph( '<leftmargin 5>WinAddAtom <leftmargin 2>' );
  RT.AddParagraph( '<h2>Left subheading</h> some more text' );
  RT.AddParagraph( 'Some more cake' );
  RT.AddParagraph( 'This is    the <color #c0c0c0>t<color #808080>e<color #404040>x<color #000000>t for this subheading, what it''s about I cannot tell' );
//  RT.AddParagraph( 'And here <font "Tms Rmn" 12>is an image <image 0> to test the scrolling changes.' );
  RT.AddParagraph( '' );
  RT.AddParagraph( 'In <tt>theory</tt> this is a <red><u><link cake>hyperlink</link><black></u>' );
  RT.AddParagraph( '<align right>A right aligned part.<align default>' );
  RT.AddParagraph( 'Back to normal, but now <font Impact 18>different font</font>' );
  RT.AddParagraph( '<backcolor green>Background color</backcolor> and now not.' );

  RT.AddParagraph( 'Let''s<leftmargin 10>test some margins' );

  RT.AddParagraph( '<font "Courier" 10>__ANSI__ </font><leftmargin 4>' );
  RT.AddParagraph( 'Allows only language constructs that conform to ISO/ANSI C standard.' );

  RT.Images:= Imagelist2;
//  RT.TopCharIndex := 50;
  RT.Color := clWhite;//Red;

  AnOutline:= TOutline2.Create( self );
  AnOutline.TabStop := true;
  AnOutline.Parent:= TabbedNotebook1.Pages.Pages[ 2 ];
  AnOutline.Align:= alLeft;
  AnOutline.Width:= 200;
//  AnOutline.Height:= 180;
  AnOutline.LineHeight:= 16;
//  AnOutline.PlusMinusWidth:= 11;
//  AnOutline.PlusMinusHeight:= 11;

  AnOutline.SelectLine:= false;
  AnOutline.PlusMinusStyle:= pm3d;

  AnOutline.OnItemDblClick:= OnOutlineEvent;
  AnOutline.PenColor:= clBlue;

  M1:= MemAvail;

  AnOutline.BeginUpdate;

  Node:= AnOutline.AddChild( 'Seven', nil );
  Node:= Node.AddChild( 'Biscuit', nil );
  Node.AddChild( 'Afghan', nil );
  node2:= Node.AddChild( 'Toffee pop', nil );
  node2.AddChild( 'Supreme toffee pop', nil );
  node2.AddChild( 'Budget toffee pop', nil );
  node2.AddChild( 'Mysterious toffee pop', nil );
  node2.AddChild( 'Cheese flavoured toffee pop', nil );
  node2.Expand;

//  AnOutline.SelectedNode:= node2;

  Node.AddChild( 'Cheese', nil );
  Node.AddChild( 'Cake', nil );

  for i:= 0 to 20 do
  begin
    Node2:= AnOutline.AddChild( 'Item ' + IntToStr( i ) + ' This is a big cheese', nil );
    for j:= 0 to 20 do
      Node2.AddChild( 'Item ' + IntToStr( j ) + 'this is a giant sausage', nil );
  end;
  AnOutline.EndUpdate;
  StatusBar.SimpleText:= 'Mem used loading outline: ' + IntToStr( M1 - MemAvail );


  MLB:= TMultiColumnListBox.Create( self );

  MLB.Parent:= TabbedNotebook1.Pages.Pages[ 5 ];
  MLB.ALign:= alClient;
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.ImageList:= ImageList1;

End;

Procedure TComponentsTestForm.Button1OnClick (Sender: TObject);
var
  TheList: TStringList;
Begin
  TheList:= TStringList.Create;
  TheList.Add( 'List item 1' );
  TheList.Add( 'LIst item 2' );
  DoConfirmListDlg( 'Test',
                    'THis is the message. In theory it can be quite long and the dialog '
                    + 'should autosize to fit it best.',
                    TheList );
  TheList.Destroy;

End;

procedure TComponentsTestForm.OnOutlineEvent( Node: TNode );
begin
  ShowMessage( 'Node string: ' + Node.Text );
end;

Initialization
  RegisterClasses ([TComponentsTestForm, TTabbedNotebook, TStatusBar
   , TImageList, TOutline2, TMainMenu, TButton, TRichTextView,
    TCustomDriveComboBox,
    TCustomDirectoryListBox, TCustomFilelistBox, TListBox, TRadioGroup
   , TEdit, TSpeedButton, TPanel, THeaderControl, TMemo, TImage]);

   SetLogAspects('LogDebug');
End.
