Unit HelpWindowUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

uses
  Classes,
  Forms,
  Graphics,
  RichTextView,
  HelpTopic,
  HelpWindowDimensions;

type
  THelpWindow = class;

  THelpWindowCloseEvent = procedure( Window: THelpWindow ) of Object;
  THelpWindowCloseQueryEvent = procedure( Window: THelpWindow;
                                          Var CanClose: boolean ) of Object;

  // A window containing a topic.
  THelpWindow = class
  protected
    FForm: TForm;

    FView: TRichTextView;

    FImages: TImageList;

    FTopic: TTopic;           // the topic being displayed
    FGroup: longint;          // IPF group number currently assigned
                             // Set by either topic's contents group index,
                             // OR by a link group index

    FChildWindows: TList;     // Windows within this one. Rarely used. (e.g. OS2UG)
    FDependentWindows: TList; // windows to close when this one closes
                             // NOT the same as child windows
                             // * Not yet implemented *
    FRect: THelpWindowRect;

    FParentHelpWindow: THelpWindow;

  protected
    FOnClose: THelpWindowCloseEvent;
    FOnCloseQuery: THelpWindowCloseQueryEvent;
    FOnDragOver: TDragOverEvent;
    FOnDragDrop: TDragDropEvent;
    FOnFontChange: TNotifyEvent;
    FOnTab: TNotifyEvent;
    FOnBackTab: TNotifyEvent;

  protected
    procedure OnResize( Sender: TObject );

    function GetParent: TControl;
    procedure SetParent( NewValue: TControl );

    procedure SetVisible( NewValue: boolean );
    function GetVisible: boolean;

    procedure SetCaption( const NewValue: string );
    function GetCaption: string;

    procedure OnFormClose( Sender: TObject;
                           Action: TCloseAction );
    procedure OnFormCloseQuery( Sender: TObject;
                                Var CanClose: boolean );

    procedure OnDragOverView( Sender: TObject;
                              Source: TObject;
                              X ,Y: LongInt;
                              State: TDragState;
                              Var Accept: Boolean );
    procedure OnDragDropToView( Sender: TObject;
                                Source: TObject;
                                X, Y: LongInt );
    procedure OnViewFontChange( Sender: TObject );
    procedure OnViewScan( Sender: TObject;
                          var KeyCode: TKeyCode );

  public

    constructor Create( ShowBorder: boolean );
    destructor Destroy; override;

    procedure SetLayout;
    procedure SetupRTView;

    function GetMaster: TControl;

    procedure BringToFront;

    procedure Show;

    property Caption: string read GetCaption write SetCaption;

    property Parent: TControl read GetParent write SetParent;
    property Visible: boolean read GetVisible write SetVisible;

    property OnClose: THelpWindowCloseEvent read FOnClose write FOnClose;
    property OnCloseQuery: THelpWindowCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;

    property OnDragOver: TDragOverEvent read FOnDragOver write FOnDragOver;
    property OnDragDrop: TDragDropEvent read FOnDragDrop write FOnDragDrop;

    property OnFontChange: TNotifyEvent read FOnFontChange write FOnFontChange;

    property OnTab: TNotifyEvent read FOnTab write FOnTab;
    property OnBackTab: TNotifyEvent read FOnBackTab write FOnBackTab;

    property View: TRichTextView read FView;
    property Images: TImageList read FImages;

    property Topic: TTopic read FTopic write FTopic;
    property Group: longint read FGroup write FGroup;

    property ChildWindows: TList read FChildWindows;
    property DependentWindows: TList read FDependentWindows;
    property Rect: THelpWindowRect read FRect write FRect;

    property ParentHelpWindow: THelpWindow read FParentHelpWindow write FParentHelpWindow;

  public
    Highlights: TList; // list of indexes into text of highlighted entries
  end;

var
  g_TopicIcon: TIcon;

Implementation

uses
  ACLUtility,
  RichTextStyleUnit,
  ControlsUtility,
  SettingsUnit;

{$R Images}

constructor THelpWindow.Create( ShowBorder: boolean );
begin
  inherited Create;

  FForm := nil;

  FView := TRichTextView.Create( nil );

  if ShowBorder then
  begin
    FForm := TForm.Create( nil );
    FForm.Name := 'HelpWindowForm';
    FForm.Visible := false;
    FForm.FormStyle := fsMDIChild;
    Exclude( FForm.BorderIcons, biMinimize );

    FForm.Tag := longint( self );

    FForm.Parent := Parent;

    FForm.OnClose := OnFormClose;
    FForm.OnCloseQuery := OnFormCloseQuery;
    FForm.OnResize := OnResize;

    FView.Parent := FForm;
    FView.Align := alClient;

    FView.TabOrder := 0;
    FView.Visible := true;
  end
  else
  begin
    FView.Parent := Parent;
    FView.Visible := false;
  end;

  FView.OnDragOver := OnDragOverView;
  FView.OnDragDrop := OnDragDropToView;
  FView.OnFontChange := OnViewFontChange;
  FView.OnScan := OnViewScan;

  SetupRTView;

  FRect := THelpWindowRect.Create;

  FImages := TImageList.Create( Parent );

  FChildWindows := TList.Create;

  FDependentWindows := TList.Create;

  Highlights := TList.Create;
end;

destructor THelpWindow.Destroy;
begin
  FImages.Destroy;
  DestroyListObjects( FChildWindows );
  FChildWindows.Destroy;
  FRect.Destroy;
  FDependentWindows.Destroy;
  FView.Destroy;
  if FForm <> nil then
    FForm.Destroy;
  Highlights.Destroy;
  inherited Destroy;
end;

procedure THelpWindow.OnFormClose( Sender: TObject;
                                   Action: TCloseAction );
begin
  if Assigned( FOnClose ) then
    FOnClose( self );
  Action := caFree; // make form free itself and what it owns...
  FForm := nil ;// so we don't destroy it in destructor
  Destroy; // destroy ourselves
end;

procedure THelpWindow.OnFormCloseQuery( Sender: TObject;
                                        Var CanClose: boolean );
begin
  if Assigned( FOnCloseQuery ) then
    FOnCloseQuery( self, CanClose );
end;

procedure THelpWindow.OnDragOverView( Sender: TObject;
                                      Source: TObject;
                                      X, Y: LongInt;
                                      State: TDragState;
                                      Var Accept: Boolean );

begin
  if Assigned( FOnDragOver ) then
    FOnDragOver( Sender, Source, X, Y, State, Accept );
end;

procedure THelpWindow.OnDragDropToView( Sender: TObject;
                                        Source: TObject;
                                        X, Y: LongInt );

begin
  if Assigned( FOnDragDrop ) then
    FOnDragDrop( Sender, Source, X, Y );
end;

procedure THelpWindow.OnViewFontChange( Sender: TObject );
begin
  if Assigned( FOnFontChange ) then
    FOnFontChange( Sender );
end;

procedure THelpWindow.OnViewScan( Sender: TObject;
                                  var KeyCode: TKeyCode );
begin
  if KeyCode = kbTab then
  begin
    // see if view wants to handle
    if FView.HighlightNextLink then
    begin
      KeyCode := kbNull;
    end
    else if FOnTab <> nil then
    begin
      KeyCode := kbNull;
      FOnTab( self );
    end;
  end;

  if KeyCode = kbShiftTab then
  begin
    if FView.HighlightPreviousLink then
    begin
      KeyCode := kbNull;
    end
    else if FOnBackTab <> nil then
    begin
      KeyCode := kbNull;
      FOnBackTab( self );
    end;
  end;
end;

function THelpWindow.GetMaster: TControl;
begin
  if FForm <> nil then
    Result := FForm
  else
    Result := FView;
end;

function THelpWindow.GetParent: TControl;
begin
  Result := GetMaster.Parent;
end;

procedure THelpWindow.SetParent( NewValue: TControl );
begin
  GetMaster.Parent := NewValue;
end;

procedure THelpWindow.SetVisible( NewValue: boolean );
begin
  GetMaster.Visible := NewValue;
end;

function THelpWindow.GetVisible: boolean;
begin
  Result := GetMaster.Visible;
end;

procedure THelpWindow.SetCaption( const NewValue: string );
begin
  if Assigned( FForm ) then
    FForm.Caption := NewValue;
end;

function THelpWindow.GetCaption: string;
begin
  if Assigned( FForm ) then
    Result := FForm.Caption
  else
    Result := '';
end;

procedure THelpWindow.BringToFront;
begin
  GetMaster.BringToFront;
end;

procedure THelpWindow.Show;
begin
  GetMaster.Show;
  if FForm <> nil then
    FForm.Icon := g_TopicIcon;
end;

// Setup the rich text control
procedure THelpWindow.SetupRTView;
begin
  FView.UseDefaultMenu := false;
  FView.Color := Settings.Colors[ TopicBackgroundColorIndex ];
  FView.SmoothScroll := Settings.SmoothScrolling;

  with FView.RichTextSettings do
  begin
    BeginUpdate;
    NormalFont := Settings.NormalFont;
    FixedFont := Settings.FixedFont;
    Margins := Forms.Rect( 5, 10, 5, 10 );
    AtLeastOneWordBeforeWrap := true; // not sure
    DefaultBackgroundColor := Settings.Colors[ TopicBackgroundColorIndex ];
    DefaultColor := clBlack;
    MarginSizeStyle := msAverageCharWidth;
    EndUpdate;
  end;
end;

procedure THelpWindow.SetLayout;
var
  X, Y: longint;
  W, H: longint;
  Maximize: boolean;
begin
  // Position the window correctly.

  W:= FRect.Width * Parent.ClientWidth div 100;
  H:= FRect.Height * Parent.ClientHeight div 100;

  if FRect.Left = XYPosCenter then
    X:= Parent.ClientWidth div 2 - W div 2
  else if FRect.Left = XPosRight then
    X:= Parent.ClientWidth - W
  else
    X:= FRect.Left * Parent.ClientWidth div 100;

  if FRect.Bottom = XYPosCenter then
    Y:= Parent.ClientHeight div 2 - H div 2
  else if FRect.Bottom = YPosTop then
    Y:= Parent.ClientHeight - H
  else
    Y:= FRect.Bottom * Parent.ClientHeight div 100;

  // If this window is set to use the whole screen (exactly)
  // then we maximize it.
  Maximize :=
         ( X = 0 )
     and ( y = 0 )
     and ( FRect.Width = 100 )
     and ( FRect.height = 100 );

  if FForm <> nil then
    SmartSetWindowPos( FForm,
                       X, Y, W, H,
                       Maximize )
  else
    FView.SetWindowPos( X, Y, W, H );
end;

procedure THelpWindow.OnResize( Sender: TObject );
var
  Child: THelpWindow;
  ChildIndex: longint;
begin
  for ChildIndex := 0 to FChildWindows.Count - 1 do
  begin
    Child := FChildWindows[ ChildIndex ];
    Child.SetLayout;
  end;
end;

Initialization

  // create topic icon global
  g_TopicIcon := TIcon.Create;
  // load icon from resource
  g_TopicIcon.LoadFromResourceName( 'TopicIcon' );

Finalization
  g_TopicIcon.Destroy;

End.
