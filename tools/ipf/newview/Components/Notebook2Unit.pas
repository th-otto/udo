unit Notebook2Unit;

interface

uses
  Messages, Os2Def, SysUtils, Classes, Forms, Graphics,
  StdCtrls;

type

  TNotebook2Page = class(TControl)
  private
    procedure WMHitTest(var Message:TMessage); message WM_HITTEST;
  protected
//    procedure ReadState(Reader: TReader); override;
    procedure Paint(const Rect:TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
{
    property Height stored False;
    property TabOrder stored False;
    property Visible stored False;
    property Width stored False;
}
  end;

  TNotebook2 = class(TControl)
  private
    FPageList: TList;
    FAccess: TStrings;
    FPageIndex: Integer;
    FOnPageChanged: TNotifyEvent;
    procedure SetPages(Value: TStrings);
    procedure SetActivePage(const Value: string);
    function GetActivePage: string;
    procedure SetPageIndex(Value: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    function GetChildOwner: TComponent; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
//    procedure ReadState(Reader: TReader); override;
//    procedure ShowControl(AControl: TControl); //override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ActivePage: string read GetActivePage write SetActivePage stored False;
    property Align;
//    property Anchors;
    property Color;
    property Ctl3D;
    property DragCursor;
//    property DragKind;
    property DragMode;
    property Font;
    property Enabled;
//    property Constraints;
    property PageIndex: Integer read FPageIndex write SetPageIndex default 0;
    property Pages: TStrings read FAccess write SetPages stored False;
    property ParentColor;
//    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
//    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
//    property OnStartDock;
    property OnStartDrag;
  end;

{
procedure NotebookHandlesNeeded(Notebook: TNotebook2);
}

Exports
  TNotebook2, 'User', 'Notebook2.bmp';

implementation

//uses Consts;
uses
  PmWin;


// Call HandleNeeded for each page in notebook.  Used to allow anchors to work
// on invisible pages.
{
procedure NotebookHandlesNeeded(Notebook: TNotebook2);
var
  I: Integer;
begin
  if Notebook <> nil then
    for I := 0 to Notebook.FPageList.Count - 1 do
      with TNotebook2Page(Notebook.FPageList[I]) do
      begin
        DisableAlign;
        try
          HandleNeeded;
          ControlState := ControlState - [csAlignmentNeeded];
        finally
          EnableAlign;
        end;
      end;
end;
}
{ TPageAccess }

type
  TPageAccess = class(TStrings)
  private
    PageList: TList;
    Notebook: TNotebook2;
  protected
    function GetCount: longint; override;
    function Get(Index: longint): string; override;
    procedure Put(Index: longint; const S: string); override;
    function GetObject(Index: longint): TObject; override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    constructor Create(APageList: TList; ANotebook: TNotebook2);
    procedure Clear; override;
    procedure Delete(Index: longint); override;
    procedure Insert(Index: longint; const S: string); override;
    procedure Move(CurIndex, NewIndex: longint); override;
  end;

constructor TPageAccess.Create(APageList: TList; ANotebook: TNotebook2);
begin
  inherited Create;
  PageList := APageList;
  Notebook := ANotebook;
end;

function TPageAccess.GetCount: Integer;
begin
  Result := PageList.Count;
end;

function TPageAccess.Get(Index: longint): string;
begin
  Result := TNotebook2Page(PageList[Index]).Caption;
end;

procedure TPageAccess.Put(Index: longint; const S: string);
begin
  TNotebook2Page(PageList[Index]).Caption := S;
end;

function TPageAccess.GetObject(Index: longint): TObject;
begin
  Result := PageList[Index];
end;

procedure TPageAccess.SetUpdateState(Updating: Boolean);
begin
  { do nothing }
end;

procedure TPageAccess.Clear;
var
  I: Integer;
begin
  for I := 0 to PageList.Count - 1 do
    TNotebook2Page(PageList[I]).Free;
  PageList.Clear;
end;

procedure TPageAccess.Delete(Index: longint);
//var
//  Form: TForm;
begin
  TNotebook2Page(PageList[Index]).Free;
  PageList.Delete(Index);
  NoteBook.PageIndex := 0;

{  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;}
end;

procedure TPageAccess.Insert(Index: longint; const S: string);
var
  Page: TNotebook2Page;
//  Form: TForm;
begin
  Page := TNotebook2Page.Create(Notebook);
  with Page do
  begin
    Parent := Notebook;
    Caption := S;
  end;
  PageList.Insert(Index, Page);

  NoteBook.PageIndex := Index;

{
  if csDesigning in NoteBook.ComponentState then
  begin
    Form := GetParentForm(NoteBook);
    if (Form <> nil) and (Form.Designer <> nil) then
      Form.Designer.Modified;
  end;
}
end;

procedure TPageAccess.Move(CurIndex, NewIndex: longint);
var
  AObject: TObject;
begin
  if CurIndex <> NewIndex then
  begin
    AObject := PageList[CurIndex];
    PageList[CurIndex] := PageList[NewIndex];
    PageList[NewIndex] := AObject;
  end;
end;

{ TNotebook2Page }

constructor TNotebook2Page.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := False;
  //ControlStyle := ControlStyle + [csAcceptsControls, csNoDesignVisible];
  Include( ComponentState, csAcceptsControls );
  Align := alClient;
end;

procedure TNotebook2Page.Paint(const Rect:TRect);
begin
  inherited Paint(Rect);
  if csDesigning in ComponentState then
    with Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle( Forms.Rect(0, 0, Width, Height));
    end;
end;

{
procedure TNotebook2Page.ReadState(Reader: TReader);
begin
  if Reader.Parent is TNotebook2 then
    TNotebook2(Reader.Parent).FPageList.Add(Self);
  inherited ReadState(Reader);
end;
}
procedure TNotebook2Page.WMHitTest(var Message:TMessage);
begin
  if not (csDesigning in ComponentState) then
    Message.Result := HT_TRANSPARENT
  else
    inherited;
end;

{ TNotebook2 }

const
  Registered: Boolean = False;

constructor TNotebook2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 150;
  Height := 150;
  FPageList := TList.Create;
  FAccess := TPageAccess.Create(FPageList, Self);
  FPageIndex := -1;
  FAccess.Add('Default');
  PageIndex := 0;
//  Exclude(FComponentStyle, csInheritable);
  if not Registered then
  begin
    Classes.RegisterClasses([TNotebook2Page]);
    Registered := True;
  end;
end;

destructor TNotebook2.Destroy;
begin
  FAccess.Free;
  FPageList.Free;
  inherited Destroy;
end;

procedure TNotebook2.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN
             and not (CS_SIZEREDRAW);
  end;
end;

{function TNotebook2.GetChildOwner: TComponent;
begin
  Result := Self;
end;
}
procedure TNotebook2.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FPageList.Count - 1 do Proc(TControl(FPageList[I]));
end;

{
procedure TNotebook2.ReadState(Reader: TReader);
begin
  Pages.Clear;
  inherited ReadState(Reader);
  if (FPageIndex <> -1) and (FPageIndex >= 0) and (FPageIndex < FPageList.Count) then
    with TNotebook2Page(FPageList[FPageIndex]) do
    begin
      BringToFront;
      Visible := True;
      Align := alClient;
    end
  else FPageIndex := -1;
end;

procedure TNotebook2.ShowControl(AControl: TControl);
var
  I: Integer;
begin
  for I := 0 to FPageList.Count - 1 do
    if FPageList[I] = AControl then
    begin
      SetPageIndex(I);
      Exit;
    end;
  inherited ShowControl(AControl);
end;
}
procedure TNotebook2.SetPages(Value: TStrings);
begin
  FAccess.Assign(Value);
end;

procedure TNotebook2.SetPageIndex(Value: Integer);
var
  ParentForm: TForm;
  Page: TNotebook2Page;
begin
  if csLoading in ComponentState then
  begin
    FPageIndex := Value;
    Exit;
  end;
  if (Value <> FPageIndex) and (Value >= 0) and (Value < FPageList.Count) then
  begin
    ParentForm := GetParentForm(Self);
    if ParentForm <> nil then
      if ContainsControl(ParentForm.ActiveControl) then
        ParentForm.ActiveControl := Self;
    Page := TNotebook2Page(FPageList[Value]);
    with Page do
    begin
      BringToFront;
      Visible := True;
      Align := alClient;
    end;
    if (FPageIndex >= 0) and (FPageIndex < FPageList.Count) then
      TNotebook2Page(FPageList[FPageIndex]).Visible := False;
    FPageIndex := Value;
//    if ParentForm <> nil then
//      if ParentForm.ActiveControl = Self then SelectFirst;
    if Assigned(FOnPageChanged) then
      FOnPageChanged(Self);
  end;
end;

procedure TNotebook2.SetActivePage(const Value: string);
begin
  SetPageIndex(FAccess.IndexOf(Value));
end;

function TNotebook2.GetActivePage: string;
begin
  Result := FAccess[FPageIndex];
end;

initialization
  RegisterClasses( [TNotebook2] );
end.
