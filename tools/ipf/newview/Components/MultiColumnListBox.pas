unit MultiColumnListBox;

interface

uses
  Messages, SysUtils, Classes, Graphics, Forms, Dialogs,
  StdCtrls, ComCtrls, CustomHeaderControl; // menus for SPCC v2.5+

const
  mclbImageMarker = #11;

type
  TMultiColumnListBox = class(TControl)
  protected
    FHeader: TCustomHeaderControl;
    FLIstBox: TListBox;
    FImageList: TImageList;

    FSavedSelectedObject: TObject;

    FBorderStyle: TBorderStyle;
    Procedure SetBorderStyle( NewValue: TBorderStyle );

    function GetHeaderPenColor: TColor;
    procedure SetHeaderPenColor( NewValue: TColor );
    function GetListPenColor: TColor;
    procedure SetListPenColor( NewValue: TColor );

    function GetEnabled: boolean; //override;
    function GetExtendedSelect: boolean;
    function GetHeaderFont: TFont;
    function GetHeaderHeight: integer;
    function GetHeaderParentFont: boolean;
    function GetItemHeight: integer;
    function GetListFont: TFont;
    function GetListParentFont: boolean;
    function GetMultiSelect: boolean;
    function GetParentColor: boolean;
    function GetParentShowHint: boolean;
    function GetThePopupMenu: TPopupMenu; 
    function GetShowHint: boolean;
//    procedure SetEnabled(NewState:Boolean); override;
    procedure SetExtendedSelect(const Value: boolean);
    procedure SetHeaderFont(const Value: TFont);
    procedure SetHeaderHeight(const Value: integer);
    procedure SetHeaderParentFont(const Value: boolean);
    procedure SetItemHeight(const Value: integer);
    procedure SetListFont(const Value: TFont);
    procedure SetListParentFont(const Value: boolean);
    procedure SetMultiSelect(const Value: boolean);
    procedure SetParentShowHint(const Value: boolean);
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure SetShowHint(const Value: boolean);
    procedure SetSelectedObject(const Value: TObject);
    function GetOnClick: TNotifyEvent;
    procedure SetOnClick(const Value: TNotifyEvent);
    function GetOnDblClick: TNotifyEvent;
    procedure SetOnDblClick(const Value: TNotifyEvent);
    procedure SetSelectedItem(const Value: string);
    function GetTopObject: TObject;
    procedure SetTopObject(const Value: TObject);

    function GetItems: TStrings;
    procedure SetItems( Items: TStrings );
    function GetHeaderSections: TCustomHeaderSections;
    procedure SetHeaderSections( Sections: TCustomHeaderSections );
    function GetSelectedItem: string;
    function GetSelectedObject: TObject;
    function GetItemIndex: integer;
    procedure SetItemIndex( const Value: integer );
    procedure SetImageList( ImageList: TImageList );
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;

    procedure SetOnItemFocus( Value: TItemFocusEvent );
    function GetOnItemFocus: TItemFocusEvent;
    function GetOnItemSelect: TItemSelectEvent;
    procedure SetOnItemSelect( Value: TItemSelectEvent );

    function GetOnEnter: TNotifyEvent;
    procedure SetOnEnter( Value: TNotifyEvent );
    function GetOnExit: TNotifyEvent;
    procedure SetOnExit( Value: TNotifyEvent );

    procedure SetSelected( Index: longint; Value: boolean );
    function GetSelected( Index: longint ): boolean;

    Procedure SetColor(NewColor:TColor); Override;

    procedure Layout;
    procedure DrawListBoxItem( Sender: TObject;
                               Index: longint;
                               Rect: TRect;
                               State: TOwnerDrawState );
    procedure ChangeHeader( HeaderControl: TCustomHeaderControl;
                            Section: TCustomHeaderSection );
    procedure Resize; override;
    procedure SetupShow; override;
    procedure SetupComponent; override;

    Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
    Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;

    function GetTabStop:boolean;
    procedure SetTabStop(Value:boolean);

    procedure WMFocussing( Var Msg: TMessage ); message WM_FOCUSSING;
  public
    destructor Destroy; override;

    property ItemIndex: integer read GetItemIndex write SetItemIndex;
    property SelectedItem: string read GetSelectedItem write SetSelectedItem;
    property SelectedObject: TObject read GetSelectedObject write SetSelectedObject;
    property TopObject: TObject read GetTopObject write SetTopObject;

    procedure SetSelectedItemTo( Text: string );
    property Selected[ Index: longint ]: boolean read GetSelected write SetSelected;

    property Parent;

  published
    property Items: TStrings
             read GetItems
             write SetItems;
    property HeaderColumns: TCustomHeaderSections
             read GetHeaderSections
             write SetHeaderSections;
    property ImageList: TImageList
             read FImageList
             write SetImageList;

    Property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle;

    property ListPenColor: TColor read GetListPenColor write SetListPenColor;
    property HeaderPenColor: TColor read GetHeaderPenColor write SetHeaderPenColor;

    property ListFont: TFont read GetListFont write SetListFont;
    property ListParentFont: boolean read GetListParentFont write SetListParentFont;

    property HeaderFont: TFont read GetHeaderFont write SetHeaderFont;
    property HeaderParentFont: boolean read GetHeaderParentFont write SetHeaderParentFont;

    property ShowHint: boolean read GetShowHint write SetShowHint;
    property ParentShowHint: boolean read GetParentShowHint write SetParentShowHint;

    property PopupMenu: TPopupMenu read GetThePopupMenu write SetPopupMenu;

    property HeaderHeight: integer read GetHeaderHeight write SetHeaderHeight;
    property ItemHeight: integer read GetItemHeight write SetItemHeight;

    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property ExtendedSelect: boolean read GetExtendedSelect write SetExtendedSelect;

    property Enabled; //: boolean read GetEnabled write SetEnabled;

    property Align;
    property Color;
    property ParentColor;
    property TabStop: boolean read GetTabStop write SetTabStop;
    property TabOrder;

    // Events
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
    property OnDblClick: TNotifyEvent read GetOnDblClick write SetOnDblClick;
    property OnItemFocus: TItemFocusEvent read GetOnItemFocus write SetOnItemFocus;
    property OnItemSelect: TItemSelectEvent read GetOnItemSelect write SetOnItemSelect;
    property OnEnter: TNotifyEvent read GetOnEnter write SetOnEnter;
    property OnExit: TNotifyEvent read GetOnExit write SetOnExit;
  end;

exports
  TMultiColumnListBox, 'User', 'MultiColumnListBox.bmp';

implementation

uses
  StringUtilsUnit;
  
{ TMultiColumnListBox }

procedure TMultiColumnListBox.SetupComponent;
var
  Section: TCustomHeaderSection;
begin
  inherited SetupComponent;

  Width := 100;
  Height := 100;

  ParentCOlor := true;

  Name := 'MultiColumnListBox';

  FTabStop := false;

  FHeader := TCustomHeaderControl.Create( Self );
  FHeader.Parent := self;
  FHeader.Height := 22;
  FHeader.BevelWidth := 1;
  FHeader.TabStop := false;
  Include( FHeader.ComponentState, csDetail );

  // Create a couple of default header sections
  // so it's obvious that it's there.
  Section := FHeader.Sections.Add;
  Section.Text := 'Column 1';
  Section.AllowClick := false;
  Section := FHeader.Sections.Add;
  Section.Text := 'Column 2';

  FListBox := TListBox.Create( Self );
  FListBox.Parent := self;
//  FListBox.ItemHeight := 16;

  FListBox.Style := lbOwnerDrawFixed;

  FListBox.OnDrawItem := DrawListBoxItem;

  FListBox.TabStop := true;
  Include( FListBox.ComponentState, csDetail );
  FListBox.ParentColor := true;

//  FListBox.BorderStyle := bsNone; // we draw it ourselves

  FHeader.OnSectionResize := ChangeHeader;

  FImageList := nil;

//  FAlwaysFocusChild := FListBox;

  Layout;

end;

procedure TMultiColumnListBox.SetupShow;
begin
  Layout;
end;

destructor TMultiColumnListBox.Destroy;
begin
  inherited Destroy;
end;

Procedure TMultiColumnListBox.ReadSCUResource( Const ResName: TResourceName;
                                               Var Data;DataLen: LongInt );
begin
  if ResName = rnHeaders then
    FHeader.ReadSCUResource( ResName, Data, DataLen )
  else
    inherited ReadSCUResource( ResName, Data, DataLen );

end;

Function TMultiColumnListBox.WriteSCUResource( Stream: TResourceStream ): Boolean;
begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then
    Exit;
  FHeader.WriteScuResource( Stream );
end;

procedure TMultiColumnListBox.WMFocussing( Var Msg: TMessage );
begin
  // focus listbox instead
  Msg.Result := LONGWORD( FListBox );
  msg.Handled := true;
end;

function TMultiColumnListBox.GetTabStop:boolean;
begin
  result:=FListBox.TabStop;
end;

procedure TMultiColumnListBox.SetTabStop(Value:boolean);
begin
  FListBox.TabStop:=Value;
end;

procedure TMultiColumnListBox.DrawListBoxItem( Sender: TObject;
                                               Index: longint;
                                               Rect: TRect;
                                               State: TOwnerDrawState );
var
  ColumnIndex: integer;
  X: integer;
  ItemToDraw: string;
  Line: string;
  BitmapIndex: integer;
  ColumnWidth: integer;
  ItemRect: TRect;
  Dest: TRect;
  LineClipRect: TRect;
  tmpColumns : TStringList;
  i : longint;
begin
  LineClipRect := FListBox.Canvas.ClipRect;

  ColumnIndex := 0;

  Dest := rect;
  dec( Dest.top ); // minor adjustments since we seem to get a slightly
  inc( Dest.left ); // incorrect area to draw on...

  X := Dest.Left;
  Line := FListBox.Items[ Index ];

  with FListBox.Canvas do
  begin
    Pen.Color := FListBox.PenColor;
    Brush.Color := FListBox.Color;
    IF State * [odSelected] <> [] THEN
    begin
      Brush.Color := clHighLight;
      Pen.Color := Color;
    end;

    FillRect( Dest, Brush.Color );
  end;

  tmpColumns := TStringList.Create;
  StrExtractStrings(tmpColumns, Line, [#9], #0);

  for i := 0 to tmpColumns.Count - 1 do
  begin
    ItemToDraw := tmpColumns[i];
    if ColumnIndex < FHeader.Sections.Count then
      ColumnWidth := FHeader.Sections[ ColumnIndex ].Width
    else
      ColumnWidth := 50;

    ItemRect := Dest;
    ItemRect.Left := X;
    ItemRect.Right := X + ColumnWidth - 2;
    FListBox.Canvas.ClipRect := IntersectRect( LineClipRect,
                                              ItemRect );

    if StrLeft( ItemToDraw, 1 ) = mclbImageMarker then
    begin
      Delete( ItemToDraw, 1, 1 );
      try
        BitmapIndex := StrToInt( ItemToDraw );
      except
        BitmapIndex := -1;
      end;
      if Assigned( FImageList ) then
        if ( BitmapIndex >= 0 )
           and ( BitmapIndex < FImageList.Count ) then
        begin
          FImageList.Draw( FListBox.Canvas,
                           X, Dest.Bottom,
                           BitmapIndex );
        end
        else
        begin
          tmpColumns.Destroy;
          raise Exception.Create( 'Bitmap index out of range in MultiColumnListBox' )
        end
      else
      begin
        tmpColumns.Destroy;
        raise Exception.Create( 'No imagelist assigned in MultiColumnListBox' );
      end
    end
    else
    begin
      FListBox.Canvas.TextOut(  X, Dest.Bottom,
                                ItemToDraw );
    end;
    inc( X, ColumnWidth );
    inc( ColumnIndex );
  end;
  tmpColumns.Destroy;
end;

procedure TMultiColumnListBox.SetItems( Items: TStrings );
begin
   FListBox.Items.Assign( Items );
end;

function TMultiColumnListBox.GetHeaderSections: TCustomHeaderSections;
begin
  Result := FHeader.Sections;
end;

function TMultiColumnListBox.GetItems: TStrings;
begin
  Result := FListBox.Items;
end;

procedure TMultiColumnListBox.Layout;
var
  LastSection: TCustomHeaderSection;
begin
  FHeader.Align := alTop;

  //FListBox.Align := alClient;
{
  if FBorderStyle = bsNone then
  begin
}
    FListBox.Left := 0;
    FListBox.Width := Width;
    FListBox.Bottom := 0;
    FListBox.Height := Height - FHeader.Height + 2; // hide the top edge under header
    FListBox.SendToBack;
{
  end
  else
  begin
    FListBox.Left := 2;
    FListBox.Width := Width - 4;
    FListBox.Bottom := 2;
    FListBox.Height := Height - FHeader.Height - 4;
  end;
}

  if HeaderColumns.Count > 0 then
  begin
    // Resize the last column to fit, if possible
    LastSection := HeaderColumns[ HeaderColumns.Count - 1 ];
    if LastSection.Left < Width then
      LastSection.Width := Width - LastSection.Left;
  end;

end;

procedure TMultiColumnListBox.SetBorderStyle( NewValue: TBorderStyle );
begin
  if NewValue = FBorderStyle then
    exit;
  FBorderStyle := NewValue;
  Layout;
  Invalidate;
end;

procedure TMultiColumnListBox.SetImageList(ImageList: TImageList);
begin
  if FImageList <> nil then
    // Tell the old imagelist not to inform us any more
    FImageList.Notification( Self, opRemove );

  FImageList := ImageList;

  if FImageList <> nil then
  begin
    // request notification when other is freed
    FImageList.FreeNotification( Self );
  end;
end;

procedure TMultiColumnListBox.SetHeaderSections(Sections: TCustomHeaderSections);
begin
  FHeader.Sections.Assign( Sections );
end;

procedure TMultiColumnListBox.Notification( AComponent: TComponent;
                                            Operation: TOperation);
begin
  inherited Notification( AComponent, Operation );
  if AComponent = FImageList then
    if Operation = opRemove then
      // Image list is being destroyed
      FImageList := nil;
end;

procedure TMultiColumnListBox.ChangeHeader(HeaderControl: TCustomHeaderControl;
  Section: TCustomHeaderSection);
begin
  Layout;
  FListBox.Invalidate;
end;

function TMultiColumnListBox.GetSelectedItem: string;
begin
  Result := '';
  if FListBox.ItemIndex <> -1 then
    Result := FListBox.Items[ FListBox.ItemIndex ];
end;

function TMultiColumnListBox.GetSelectedObject: TObject;
begin
  Result := nil;
  if FListBox.ItemIndex <> -1 then
    Result := FListBox.Items.Objects[ FListBox.ItemIndex ];

end;

procedure TMultiColumnListBox.SetItemIndex(const Value: integer );
begin
  FListBox.ItemIndex := Value;
end;

function TMultiColumnListBox.GetItemIndex: integer;
begin
  Result := FListBox.ItemIndex;
end;

function TMultiColumnListBox.GetHeaderPenColor: TColor;
begin
  Result := FHeader.PenColor;
end;

procedure TMultiColumnListBox.SetHeaderPenColor( NewValue: TColor );
begin
  FHeader.PenColor := NewValue;
end;

function TMultiColumnListBox.GetListPenColor: TColor;
begin
  Result := FListBox.PenColor;
end;

procedure TMultiColumnListBox.SetListPenColor( NewValue: TColor );
begin
  FListBox.PenColor := NewValue;
end;

function TMultiColumnListBox.GetEnabled: boolean;
begin
  Result := FListBox.Enabled;
end;

function TMultiColumnListBox.GetExtendedSelect: boolean;
begin
  Result := FListBox.ExtendedSelect;
end;

function TMultiColumnListBox.GetHeaderFont: TFont;
begin
  Result := FHeader.Font;
end;

function TMultiColumnListBox.GetHeaderHeight: integer;
begin
  Result := FHeader.Height;
end;

function TMultiColumnListBox.GetHeaderParentFont: boolean;
begin
  Result := FHeader.ParentFont;
end;

function TMultiColumnListBox.GetItemHeight: integer;
begin
  Result := FListBox.ItemHeight;
end;

function TMultiColumnListBox.GetListFont: TFont;
begin
  Result := FListBox.Font;
end;

function TMultiColumnListBox.GetListParentFont: boolean;
begin
  Result := FListBox.ParentFont;
end;

function TMultiColumnListBox.GetMultiSelect: boolean;
begin
  Result := FListBox.MultiSelect;
end;

function TMultiColumnListBox.GetParentColor: boolean;
begin
  Result := FListBox.ParentColor;
end;

function TMultiColumnListBox.GetParentShowHint: boolean;
begin
  Result := FListBox.ParentShowHint;
end;

function TMultiColumnListBox.GetThePopupMenu: TPopupMenu;
begin
  Result := FListBox.PopupMenu;
end;

function TMultiColumnListBox.GetShowHint: boolean;
begin
  Result := FListBox.ShowHint;
end;

{
procedure TMultiColumnListBox.SetEnabled(NewState:Boolean);
begin
  FListBox.Enabled := NewState;
  FHeader.Enabled := NewState;
end;
}

procedure TMultiColumnListBox.SetExtendedSelect(const Value: boolean);
begin
  FListBox.ExtendedSelect := Value;
end;

procedure TMultiColumnListBox.SetHeaderFont(const Value: TFont);
begin
  FHeader.Font := Value;
end;

procedure TMultiColumnListBox.SetHeaderHeight(const Value: integer);
begin
  FHeader.Height := Value;
end;

procedure TMultiColumnListBox.SetHeaderParentFont(const Value: boolean);
begin
  FHeader.ParentFont := Value;
end;

procedure TMultiColumnListBox.SetItemHeight(const Value: integer);
begin
  FListBox.ItemHeight := Value;
end;

procedure TMultiColumnListBox.SetListFont(const Value: TFont);
begin
  FListBox.Font := Value;
end;

procedure TMultiColumnListBox.SetListParentFont(const Value: boolean);
begin
  FListBox.ParentFont := Value;
end;

procedure TMultiColumnListBox.SetMultiSelect(const Value: boolean);
begin
  FListBox.MultiSelect := Value;
end;

procedure TMultiColumnListBox.SetParentShowHint(const Value: boolean);
begin
  FListBox.ParentShowHint := Value;
  FHeader.ParentShowHint := Value;
end;

procedure TMultiColumnListBox.SetPopupMenu(const Value: TPopupMenu);
begin
  FListBox.PopupMenu := Value;
  FHeader.PopupMenu := Value;
end;

procedure TMultiColumnListBox.SetShowHint(const Value: boolean);
begin
  FListBox.ShowHint := Value;
  FHeader.ShowHint := Value;
end;

procedure TMultiColumnListBox.SetSelectedObject(const Value: TObject);
var
  Index: integer;
begin
  Index := FListBox.Items.IndexOfObject( Value );
  FListBox.ItemIndex := Index;
end;

function TMultiColumnListBox.GetOnClick: TNotifyEvent;
begin
  Result := FListBox.OnClick;
end;

procedure TMultiColumnListBox.SetOnClick(const Value: TNotifyEvent);
begin
  FListBox.OnClick := Value;
end;

function TMultiColumnListBox.GetOnDblClick: TNotifyEvent;
begin
  Result := FListBox.OnDblClick;
end;

procedure TMultiColumnListBox.SetOnDblClick(const Value: TNotifyEvent);
begin
  FListBox.OnDblClick := Value;
end;

procedure TMultiColumnListBox.SetSelectedItem(const Value: string);
var
  Index: integer;
begin
  Index := FListBox.Items.IndexOf( Value );
  FListBox.ItemIndex := Index;
end;

procedure TMultiColumnListBox.SetSelectedItemTo(Text: string );
begin
  if ItemIndex = -1 then
    raise Exception.Create( 'MultiColumnListBox: no item selected to set!' );

  Items[ ItemIndex ] := Text;
end;

procedure TMultiColumnListBox.Resize;
begin
  Layout;
end;


function TMultiColumnListBox.GetTopObject: TObject;
begin
  Result := nil;
  if ( FListBox.TopIndex >0 )
     and ( FListBox.TopIndex < FListBox.Items.Count ) then
    Result := FListBox.Items.Objects[ FLIstBox.TopIndex ];

end;

procedure TMultiColumnListBox.SetTopObject(const Value: TObject);
var
  Index: integer;
begin
  Index := FListBox.Items.IndexOfObject( Value );
  if Index <> -1 then
    FListBox.TopIndex := Index;
end;

procedure TMultiColumnListBox.SetOnItemFocus( Value: TItemFocusEvent );
begin
  FListBox.OnItemFocus := Value;
end;

function TMultiColumnListBox.GetOnItemFocus: TItemFocusEvent;
begin
  Result := FListBox.OnItemFocus;
end;

function TMultiColumnListBox.GetOnItemSelect: TItemSelectEvent;
begin
  Result := FListBox.OnItemSelect;
end;

procedure TMultiColumnListBox.SetOnItemSelect( Value: TItemSelectEvent );
begin
  FListBox.OnItemSelect := Value;
end;

function TMultiColumnListBox.GetOnEnter: TNotifyEvent;
begin
  Result := FListBox.OnEnter;
end;

procedure TMultiColumnListBox.SetOnEnter( Value: TNotifyEvent );
begin
  FListBox.OnEnter := Value;
end;

function TMultiColumnListBox.GetOnExit: TNotifyEvent;
begin
  Result := FListBox.OnExit;
end;

procedure TMultiColumnListBox.SetOnExit( Value: TNotifyEvent );
begin
  FListBox.OnExit := Value;
end;

procedure TMultiColumnListBox.SetSelected( Index: longint; Value: boolean );
begin
  FListBox.Selected[ Index ] := Value;
end;

function TMultiColumnListBox.GetSelected( Index: longint ): boolean;
begin
  Result := FListBox.Selected[ Index ];
end;

Procedure TMultiColumnListBox.SetColor(NewColor:TColor);
begin
  inherited SetColor( NewColor );
end;

Initialization
  {Register classes}
  RegisterClasses([TMultiColumnListBox]);
end.
