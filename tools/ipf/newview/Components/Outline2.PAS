Unit Outline2;

Interface

Uses
  Classes,
  Forms,
  SysUtils,
  BseDos;

{
History

V1.4.13 20/1/1
Standardised border, use DrawSystemBorder.
Added smooth scrolling.

V1.4.12 16/9/00
Added recursive collapse functions. Incl TOutline2.CollapseAll;

V1.4.11 9/8/00
Small optimisation for adding nodes outside
of Update...
If the node is collapsed, don't check refresh

V1.4.10 9/8/00
Added level and parent functions to TNOde

V1.4.9 9/8/00
Fixed problem with not setting up scroll bars after update.?
Draw selected node correctly, with inverted colors.

V1.4.8 31/7/00
Crap - I damaged the node setting.

V1.4.7 30/7/00
Improved handling during updates: if the
selected node is set during update then the new node is
just saved and applied at end update.

V1.4.6 30/7/00
When clearing a node's children do it last node first
for efficiency in list handling.

V1.4.5 30/7/00
Minor bit of fiddling with child list allocation.

V1.4.4 26/4/00
Added goto next node up and down
(includes non-visible nodes; renamed previous
methods to gotonextVISIBLEnodeup/down)

V1.4.3 26/4/00
Added page up and down

V1.4.2 26/4/00
Fixed problem clearing corner rect between scrollbars.

V1.4.1 26/4/00
Added +/- keyboard commands
If selected node would be hidden when collapsing then
make the collapsing node the selected one.

V1.4.0 26/4/00
Hmm, did I really do nothing for all that time ?
Anyway, now has keyboard support, home/end/cursor up/down

V1.3.1 12/4/00
Tree lines have a seperate color
Limit plus minus size to min 7
ScanExtents sets lineheight to textheight if textheight is bigger.

V1.3.0 12/4/00
Optimised a lot more. Now drawing can be just of a single node
which eliminates most flickering. Made the plus/minus buttons
show feedback when clicked, exactly like original TOutline.

V1.2.0 11/4/00
Worked some more on visual aspects:
- can now draw 3d or flat plus/minus
- optimise background clearing somewhat (draw per node)
- can show selected node as whole line or just text

THis reduces flicker but, it coudl be better.
Main thing to do would be to seperate out the layout:

Function Layout:
Reads from root to last expanded node. Works out Y position of
each node and stores in the node. (?)

This would allow node drawing to be done basically independently...

V1.1.0 ???
Now can set topnode to anything. Will draw
correctly.
Added ExpandParents method to help
}

const
  AllNodes = nil;
  WM_MOUSEENTER = $041E;
  WM_MOUSELEAVE = $041F;

Type

  TNodeFindFunction = function( Data: TObject ): boolean;

  TOutline2 = class;

  TNode = class
  protected
    _Text: ^string;
    _Data: TObject;
    _Children: TList;
    _Parent: TNode; // nil if head
    _Expanded: boolean; // only applicable if _Children.Count> 0
    _Outline: TOutline2;
    Function GetChild( index: longint ): TNode;
    Function IsVisible: boolean;
    procedure CheckChangeRefresh;
    Function GetText: string;
    procedure SetText( const NewText: string );
    procedure FreeText;
  public
    property Children[ index: longint ]: TNode read GetChild;
    property Text: string read GetText write SetText;
    property Data: TObject read _Data write _Data;

    constructor Create( Parent: TNode );

    function AddChild( const TheText: string;
                       const TheData: TObject ): TNode;
    function HasChildren: boolean;
    function ChildCount: longint;

    procedure Clear; // clear children

    destructor Destroy; override;

    function Level: longint; // 0 is top level.
    function Parent: TNode; // nil if at top level
    function FullPath( const Separator: string ): string;
    function IndexOfChild( Child: TNode ): longint;
    function IndexInParent: longint;
    function FindData( DataToFind: TObject ): TNode;
    function FindByFunction( FindFunction: TNodeFindFunction ): TNode;

    // Returns true if the given node is a parent of
    // this node
    function NodeIsAParent( Node: TNode ): boolean;

    property Expanded: boolean read _Expanded;
    procedure Expand;
    procedure ExpandChildren( Recursive: boolean );

    // Expand all parents if needed
    procedure ExpandParents;

    procedure Collapse;
    procedure CollapseChildren( Recursive: boolean );
  end;

  TNodePart =
  (
    npNothing,
    npPlusMinus,
    npBitmap, // not yet implemented
    npText,
    npOther
  );

  TPlusMinusStyle = ( pmFlat, pm3d );

  TNodeEvent = procedure( Node: TNode ) of object;

  TOutline2=Class(TControl)
  Protected
    _UpdateCount: integer;
    _NewSelectedNode: TNode; // during update

    _MouseDownNode: TNode;
    _MouseDownPart: TNodePart;
    _MouseDownFeedback: boolean;
    _LastMouseMoveFeedback: boolean;

    _LastMouseX: longint;
    _LastMouseY: longint;

    _HScrollbar: TScrollbar;
    _VScrollbar: TScrollbar;
    _NeedVScroll, _NeedHScroll: boolean;

    // Scroll information
    // we use these rather than the scrollbar positions direct,
    // since those are not updated during tracking
    FXScroll: longint;
    FYScroll: longint;

    FLastXScroll: longint;
    FLastYScroll: longint;

    FSmoothScroll: boolean;

    _Root: TNode;

    _HoverTimer: TTimer;
    _HintWindow: THintWindow;

    // appearance controls
    _BorderStyle: TBorderStyle;
    _ScrollbarWidth: longint;
    _LineHeight: longint;
    _AutoLineHeight: boolean;
    _Indent: longint; // X distance between branches
    _LeftMargin: longint; // X distance to left of first plus/minus col
    _TextIndent: longint; // pixels between stub end and text
    _PlusMinusWidth: longint;
    _PlusMinusHeight: longint;
    _StubWidth: longint; // additional distance beyond indent to draw lines
    _PlusMinusStyle: TPlusMinusStyle;
    _SelectLine: boolean;
    _TreeLineColor: TColor;

    _PathSeparator: string;

    _SelectedNode: TNode;

    _OnItemDblClick: TNodeEvent;
    _OnItemFocus: TNodeEvent;
    _OnItemClick: TNodeEvent;
    _OnExpand: TNodeEvent;
    _OnCollapse: TNodeEvent;

    _DrawNode: TNode; // nil for all

    Procedure SetupComponent; Override;

    Procedure ScanExtents;
    Procedure ScanNodeExtents( Node: TNode;
                               X: longint;
                               Var MaxX: longint;
                               Var MaxY: longint );

    Function RowIsVisible( Y: longint ): boolean;

    function GetNodePosition( const Node: TNode;
                              Var NodeTop: longint ): boolean;
    function NodeGetNodePosition( const NodeToFind: TNode;
                                  const NodeToScan: TNode;
                                  Var NodeTop: longint ): boolean;

    procedure DrawNode( Node: TNode );

    procedure Draw;
    Procedure DrawBorder;
    Procedure PaintNode( Node: TNode;
                         X: longint;
                         Var Y: longint );

    procedure DrawPlusMinus( Rect: TRect;
                             Expanded: boolean;
                             Pressed: boolean );

    Procedure TestHit( Point: TPoint;
                       Var Node: TNode;
                       Var Part: TNodePart );
    Procedure TestNodeHit( Node: TNode;
                           Point: TPoint;
                           X: longint;
                           Var Y: longint;
                           Var HitNode: TNode;
                           Var Part: TNodePart );
    Procedure SetupScrollbars;
    function GetDrawRect: TRect;
    function GetTextRect: TRect;
    function DrawHeight: longint;
    function GetLineRect( LineBottom: longint ): TRect;
    Function GetPlusMinusRect( Left, LineBottom: longint ): TRect;

    Procedure DoHorizontalScroll( NewX: longint );
    Procedure DoVerticalScroll( NewY: longint );

    // Property handlers
    Procedure SetSelectedNode( Node: TNode );
    Procedure SetTopNode( Node: TNode );

    Function GetChild( index: longint ): TNode;
    Function GetChildCount: longint;

    Procedure SetLineHeight( LineHeight: longint );
    Procedure SetAutoLineHeight( Value: boolean );
    Procedure SetIndent( Indent: longint );
    Procedure SetBorderStyle( BorderStyle: TBorderStyle );
    Procedure SetScrollbarWidth( ScrollbarWidth: longint );
    Procedure SetLeftMargin( LeftMargin: longint );
    Procedure SetTextIndent( TextIndent: longint );
    Procedure SetPlusMinusWidth( PlusMinusWidth: longint );
    Procedure SetPlusMinusHeight( PlusMinusHeight: longint );
    Procedure SetStubWidth( StubWidth: longint );
    Procedure SetPlusMinusStyle( NewValue: TPlusMinusStyle );
    Procedure SetSelectLine( NewValue: boolean );
    Procedure SetTreeLineColor( NewValue: TColor );
  Public
    Procedure OnHoverTimeout( Sender: TObject );
    // PM Events
    Procedure Redraw( const rec: TRect ); Override;
    Procedure Resize; override;
    Procedure MouseDblClick( Button: TMouseButton;
                             ShiftState: TShiftState;
                             X, Y: Longint ); override;
    Procedure MouseDown( Button: TMouseButton;
                         ShiftState: TShiftState;
                         X, Y: Longint ); override;
    Procedure MouseUp( Button: TMouseButton;
                       ShiftState: TShiftState;
                       X, Y: Longint ); override;
    Procedure MouseMove( ShiftState: TShiftState;
                         X, Y: Longint ); override;

    Procedure Scroll( Sender: TScrollbar;
                      ScrollCode: TScrollCode;
                      Var ScrollPos: Longint ); override;

    Procedure SetupShow; override;

    Procedure ScanEvent( Var KeyCode: TKeyCode;
                         RepeatCount: Byte ); override;
    Procedure CharEvent( Var Key: Char;
                         RepeatCount: Byte ); override;
    Procedure WMMouseLeave( Var Msg: TMessage ); message WM_MOUSELEAVE;

    Procedure FontChange; override;

    Procedure SetFocus; override;
    Procedure KillFocus; override;
  published
    property Align;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentPenColor;
    property ParentShowHint;
    property PenColor;
    property PopupMenu;
    property ShowHint;
    Property TabOrder;
    Property TabStop;
    property Visible;
    property ZOrder;

    property LineHeight: longint read _LineHeight write SetLineHeight;
    property AutoLineHeight: boolean read _AutoLineHeight write SetAutoLineHeight;
    property Indent: longint read _Indent write SetIndent;
    property BorderStyle: TBorderStyle read _BorderStyle write SetBorderStyle;
    property ScrollbarWidth: longint read _ScrollbarWidth write SetScrollbarWidth;
    property LeftMargin: longint read _LeftMargin write SetLeftMargin;
    property TextIndent: longint read _TextIndent write SetTextIndent;
    property PlusMinusWidth: longint read _PlusMinusWidth write SetPlusMinusWidth;
    property PlusMinusHeight: longint read _PlusMinusHeight write SetPlusMinusHeight;
    property StubWidth: longint read _StubWidth write SetStubWidth;
    property PlusMinusStyle: TPlusMinusStyle read _PlusMinusStyle write SetPlusMinusStyle;
    property SelectLine: boolean read _SelectLine write SetSelectLine;
    property TreeLineColor: TColor read _TreeLineColor write SetTreeLineColor;

    property SmoothScroll: boolean read FSmoothScroll write FSmoothScroll;

    property PathSeparator:string read _PathSeparator write _PathSeparator;

    property OnItemDblClick: TNodeEvent read _OnItemDblClick write _OnItemDblClick;
    property OnItemFocus: TNodeEvent read _OnItemFocus write _OnItemFocus;
    property OnItemClick: TNodeEvent read _OnItemClick write _OnItemClick;
    property OnExpand: TNodeEvent read _OnExpand write _OnExpand;
    property OnCollapse: TNodeEvent read _OnCollapse write _OnCollapse;
    property OnClick;
    property OnDblClick;
    property OnDragOver;
    property OnDragDrop;
    property OnEndDrag;
    Property OnEnter;
    Property OnExit;
    Property OnFontChange;
    Property OnHide;
    property OnKeyPress;
    Property OnResize;
    Property OnScan;
    Property OnSetupShow;
    Property OnShow;

  public

    procedure Clear;

    function AddChild( const TheText: string;
                       const TheObject: TObject ): TNode;
    property Children[ index: longint ]: TNode read GetChild;
    property ChildCount: longint read GetChildCount;

    procedure BeginUpdate;
    procedure EndUpdate;

    Destructor Destroy; Override;

    function NextNodeUp( Node: TNode;
                         VisibleOnly: boolean ): TNode;
    function NextNodeDown( Node: TNode;
                           VisibleOnly: boolean ): TNode;
    function LastVisibleNode: TNode;

    Procedure GotoFirstNode;
    Procedure GotoLastVisibleNode;

    // The following 4 functions return false if
    // they could not do the requested movement
    function GotoNextVisibleNodeUp: boolean;
    function GotoNextVisibleNodeDown: boolean;
    function GotoNextNodeUp: boolean;
    function GotoNextNodeDown: boolean;

    Procedure PageUp;
    Procedure PageDown;

    Procedure ExpandAll;
    Procedure CollapseAll;

    // search for a node which starts with the given text
    // Note: if you use VisibleOnly true, then make sure you
    // start with a visible node!!
    Function FindNextNodeByText( StartNode: TNode;
                                 const S: string;
                                 VisibleOnly: boolean ): TNode;

{    Procedure ScrollUpLine;
    Procedure ScrollDownLine;
    Procedure ScrollUpPage;
    Procedure ScrollDownPage;
}
{    Procedure ScrollLeftLine;
    Procedure ScrollRightLine;
    Procedure ScrollLeftPage;
    Procedure ScrollRightPage;
}
    property SelectedNode: TNode read _SelectedNode write SetSelectedNode;
    procedure SetSelectedObject( Data: TObject );
    function NodeFromObject( Data: TObject ): TNode;
    function FindByFunction( FindFunction: TNodeFindFunction ): TNode;

//    property TopNode: TNode read _TopNode write SetTopNode;
  End;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  TOutline2,'User','Outline2.bmp';

Implementation

uses
  Messages,
  ControlScrolling,
  StringUtilsUnit;

// ============================================================================
// Node implementation
// ============================================================================

Function TNode.IsVisible: boolean;
var
  Node: TNode;
begin
  Result:= true;
  Node:= self;
  while Node._Parent <> nil do
  begin
    Node:= Node._Parent;
    if not Node._Expanded then
      Result:= false;
  end;
end;

// Call when a node changes (add, delete, rename, collapse/expand )
procedure TNode.CheckChangeRefresh;
begin
  if _Outline.Handle = 0 then
    exit;

  if _Outline._UpdateCount > 0 then
    exit;

  if IsVisible then
  begin
    _Outline.ScanExtents;
    _Outline.Refresh;
  end;
end;

function TNode.GetText: string;
begin
  Result:= _Text^;
end;

procedure TNode.FreeText;
begin
  if _Text <> nil then
    FreeMem( _Text, Length( _Text^ ) + 1 );
end;

procedure TNode.SetText( const NewText: string );
begin
  FreeText;
  GetMem( _Text, Length( NewText ) + 1 );
  _Text^:= NewText;
end;

function TNode.AddChild( const TheText: string;
                         const TheData: TObject ): TNode;
Var
  NewNode: TNode;
Begin
  NewNode:= TNode.Create( self );
  NewNode.Text:= TheText;
  NewNode.Data:= TheData;
  NewNode._Outline:= _Outline;

  if _Children.Count = 0 then
    _Children.Capacity:= 4;

  _Children.Add( NewNode );
  Result:= NewNode;

  if _Expanded
     or ( _Children.Count = 1 ) // we just added first child; need to display +
    then
    CheckChangeRefresh;
End;

function TNode.IndexOfChild( Child: TNode ): longint;
begin
  Result:= _Children.IndexOf( Child );
end;

function TNode.NodeIsAParent( Node: TNode ): boolean;
begin
  if _Parent = _Outline._Root then
    Result:= false
  else if _Parent = Node then
    Result:= true
  else
    Result:= _Parent.NodeIsAParent( Node );
end;

function TNode.IndexInParent: longint;
begin
  if _Parent = nil then
    result:= -1
  else
    Result:= _Parent.IndexOfChild( Self );
end;

procedure TNode.ExpandChildren( Recursive: boolean );
Var
  ChildIndex: longint;
  Child: TNode;
begin
  _Outline.BeginUpdate;
  for ChildIndex:= 0 to _Children.Count - 1 do
  begin
    Child:= _Children[ ChildIndex ];
    Child.Expand;
    if Recursive then
      Child.ExpandChildren( true );
  end;
  _Outline.EndUpdate;
end;

procedure TNode.CollapseChildren( Recursive: boolean );
Var
  ChildIndex: longint;
  Child: TNode;
begin
  _Outline.BeginUpdate;
  for ChildIndex:= 0 to _Children.Count - 1 do
  begin
    Child:= _Children[ ChildIndex ];
    Child.Collapse;
    if Recursive then
      Child.CollapseChildren( true );
  end;
  _Outline.EndUpdate;
end;

function TNode.FindData( DataToFind: TObject ): TNode;
Var
  ChildIndex: longint;
  Child: TNode;
begin
  if _Parent <> nil then
    // not root...
    if Data = DataToFind then
    begin
      Result:= self;
      exit;
    end;
  for ChildIndex:= 0 to _Children.Count - 1 do
  begin
    Child:= _Children[ ChildIndex ];
    Result:= Child.FindData( DataToFind );
    if Result <> nil then
      exit;
  end;
  Result:= nil;
end;

function TNode.FindByFunction( FindFunction: TNodeFindFunction ): TNode;
Var
  ChildIndex: longint;
  Child: TNode;
  d: TObject;
begin
  if _Parent <> nil then
  begin
    // not root...
    d:= Data;
    if FindFunction( Data ) then
    begin
      Result:= self;
      exit;
    end;
  end;
  for ChildIndex:= 0 to _Children.Count - 1 do
  begin
    Child:= _Children[ ChildIndex ];
    Result:= Child.FindByFunction( FindFunction );
    if Result <> nil then
      exit;
  end;
  Result:= nil;
end;

constructor TNode.Create( Parent: TNode );
Begin
  _Parent:= Parent;
  _Children:= TList.Create;
  _Expanded:= false;
  _Text:= nil;
End;

procedure TNode.Clear;
begin
  // Delete children
  // (They will remove themselves from us)
  // Remove them from end of list first for efficiency.
  while _Children.Count > 0 do
    TNode( _Children[ _Children.Count - 1 ] ).Destroy;
end;

destructor TNode.Destroy;
Begin
  Clear;
  _Children.Destroy;
  // Delete self from parent
  if _Parent <> nil then
    _Parent._Children.Remove( self );

  if _Outline._NewSelectedNode = self then
    _Outline._NewSelectedNode := nil;

  if _Outline._SelectedNode = self then
    _Outline.SetSelectedNode( nil );

  FreeText;
  CheckChangeRefresh;
End;

function TNode.ChildCount: longint;
Begin
  Result:= _Children.Count;
End;

function TNode.HasChildren: boolean;
Begin
  Result:= _Children.Count > 0;
End;

Function TNode.GetChild( index: longint ): TNode;
Begin
  Result:= _Children[ index ];
End;

function TNode.Level: longint;
Var
  NextNode: TNode;
Begin
  Result:= -1; // since root is a special case
  NextNode:= _Parent;
  while NextNode <> nil do
  begin
    inc( Result );
    NextNode:= NextNode._Parent;
  end;
End;

Function TNode.Parent: TNode;
begin
  if _Parent = nil then
    Result:= nil
  else if _Parent._Parent = nil then
    Result:= nil // parent is really root but we don't want to give access to root
  else
    Result:= _Parent;
end;

Function TNode.FullPath( const Separator: string ): string;
Var
  NextNode: TNode;
Begin
  Result:= Text;
  NextNode:= _Parent;
  while NextNode <> nil do
  begin
    Result:= NextNode.Text + Separator + Result;
    NextNode:= NextNode._Parent;
  end;
End;

procedure TNode.Expand;
begin
  if _Expanded then
    exit;
  _Expanded:= true;
  if Assigned( _Outline._OnExpand ) then
    _Outline._OnExpand( self );
  CheckChangeRefresh;
end;

procedure TNode.Collapse;
begin
  if not _Expanded then
    exit;
  if _Outline.SelectedNode <> nil then
    if _Outline.SelectedNode.NodeIsAParent( Self ) then
      // selected node is in collapsed nodes, make ourself the selected one
      _Outline._SelectedNode:= Self;
  if Assigned( _Outline._OnCollapse ) then
    _Outline._OnCollapse( self );
  _Expanded:= false;
  CheckChangeRefresh;
end;

// Returns true if a row starting at Y will be at least partially visible
Function TOutline2.RowIsVisible( Y: longint ): boolean;
begin
  Result:= ( Y < Height + _LineHeight ) and ( Y >= 0 );
end;

// ============================================================================
// Outline component implementation
// ============================================================================

Procedure TOutline2.ScanExtents;
Var
  ChildIndex: longint;
  MaxWidth, MaxHeight: longint;
  AvailableHeight: longint;
  AvailableWidth: longint;
  TextRect: TRect;
  TextHeight: longint;
Begin
  if csDesigning in ComponentState then
    exit;
  if Handle = 0 then
    exit;

  MaxWidth:= 0;
  MaxHeight:= 0;
  _NeedVScroll:= false;
  _NeedHScroll:= false;

  TextRect:= GetTextRect;
  AvailableWidth:= TextRect.Right - TextRect.Left;
  AvailableHeight:= TextRect.Top - TextRect.Bottom;

  TextHeight:= Canvas.TextHeight( 'H' );
  if TextHeight > _LineHeight then
    _LineHeight := TextHeight;

  // draw children
  for ChildIndex:= 0 to _Root.ChildCount - 1 do
  begin
    ScanNodeExtents( _Root.Children[ ChildIndex ],
                     0,
                     MaxWidth,
                     MaxHeight );
  end;

  if MaxWidth > AvailableWidth then
  begin
    // will need horizontal scroll bar...
    _NeedHScroll:= true;
    dec( AvailableHeight, _ScrollBarWidth );
  end;

  if MaxHeight > AvailableHeight then
  begin
    // will need vertical scroll bar
    _NeedVScroll:= true;
    dec( AvailableWidth, _ScrollBarWidth );
    if _NeedHScroll = false then
      // check if we need one now,
      if MaxWidth > AvailableWidth then
      begin
        // will need horizontal scroll bar after all
        dec( AvailableHeight, _ScrollBarWidth );
        _NeedHScroll:= true;
      end;
  end;

  if _NeedVScroll then
  begin
    if _VScrollBar.Position > ( MaxHeight - AvailableHeight ) then
      _VScrollBar.Position:= MaxHeight - AvailableHeight;

    _VScrollBar.Min:= 0;
    _VScrollBar.Max:= MaxHeight;
    _VScrollBar.SliderSize:= AvailableHeight;
    _VScrollBar.SmallChange:= _LineHeight;
    _VScrollBar.LargeChange:= AvailableHeight div 2;
  end
  else
    // everything will fit vertically.
    _VScrollBar.Position:= 0;

  if _NeedHScroll then
  begin
    if _HScrollBar.Position > ( MaxWidth - AvailableWidth ) then
      _HScrollBar.Position:= MaxWidth - AvailableWidth;

    _HScrollBar.Min:= 0;
    _HScrollBar.Max:= MaxWidth;
    _HScrollBar.SliderSize:= AvailableWidth;
    _HScrollBar.SmallChange:= _LineHeight;
    _HScrollBar.LargeChange:= AvailableWidth div 2;
  end
  else
    // everything will fit horizontally
    _HScrollBar.Position:= 0; // no offset

  SetupScrollBars;
End;

Procedure TOutline2.ScanNodeExtents( Node: TNode;
                                     X: longint;
                                     Var MaxX: longint;
                                     Var MaxY: longint );
Var
  ChildIndex: longint;
  TextW, TextH: longint;
  TextX: longint;

Begin
  Canvas.GetTextExtent( Node.Text, TextW, TextH );
  TextX:= X + _PlusMinusWidth + _StubWidth + _TextIndent;

  if TextX + TextW > MaxX then
    MaxX:= TextX + TextW;

  inc( MaxY, _LineHeight );

  if Node.ChildCount > 0 then
    if Node._Expanded then
      // check children
      for ChildIndex:= 0 to Node.ChildCount-1 do
        ScanNodeExtents( Node.Children[ ChildIndex ],
                         X + Indent,
                         MaxX,
                         MaxY );

End;

function TOutline2.GetDrawRect: TRect;
begin
  Result := ClientRect;
  if _NeedHScroll then
    inc( Result.Bottom, _ScrollbarWidth );
  if _NeedVScroll then
    dec( Result.Right, _ScrollbarWidth );
end;

function TOutline2.GetTextRect: TRect;
begin
  Result := GetDrawRect;
  if _BorderStyle <> bsNone then
    InflateRect( Result, -2, -2 );
end;

function TOutline2.DrawHeight: longint;
begin
  Result := ClientRect.Top - ClientRect.Bottom;
  if _NeedHScroll then
    dec( Result, _ScrollbarWidth );

  if _BorderStyle <> bsNone then
  begin
    dec( Result, 2 ); // top border
    if not _NeedHScroll then
      dec( Result, 2 ); // bottom border
  end;
end;

Procedure TOutline2.Redraw( const rec: TRect );
Var
  OldClip: TRect;
  TextRect: TRect;
Begin
  OldClip:= Canvas.ClipRect;

  if csDesigning in ComponentState then
  begin
    _NeedVScroll:= false;
    _NeedHScroll:= false;
    DrawBorder;
    Canvas.FillRect( GetTextRect, Color );
    exit;
  end;

  FYScroll:= _VScrollBar.Position;
  FLastYScroll:= FYScroll;
  FXScroll:= _HScrollBar.Position;
  FLastXScroll:= FXScroll;

  DrawBorder;

  TextRect:= GetTextRect;
  Canvas.ClipRect:= IntersectRect( rec, TextRect );

  _DrawNode:= AllNodes;
  Draw;

  Canvas.ClipRect:= OldClip;

end;

procedure TOutline2.DrawNode( Node: TNode );
var
  OldClip: TRect;
  TextRect: TRect;
begin
  if Node = nil then
    exit;
  if InDesigner then
    exit;
  if Handle = 0 then
    exit;
  _DrawNode:= Node;

  TextRect:= GetTextRect;
  OldClip:= Canvas.ClipRect;
  Canvas.ClipRect:= TextRect;

  Draw;

  Canvas.ClipRect:= OldClip;
end;

procedure TOutline2.Draw;
var
  Y: longint;
  ChildIndex: longint;
  TextRect: Trect;
begin
  TextRect:= GetTextRect;

  Y:= TextRect.Top + _VScrollBar.Position + 1;

  // draw children
  for ChildIndex:= 0 to _Root.ChildCount - 1 do
  begin
    PaintNode( _Root.Children[ ChildIndex ],
               _LeftMargin - _HScrollBar.Position,
               Y );
    if y < 0 then
      break;
  end;

  // clear remainder -
  if Y>0 then
  begin
    TextRect.Top:= Y - 1;
    Canvas.FillRect( TextRect, Color );
  end;
End;

Procedure TOutline2.DrawBorder;
var
  Rect: TRect;
  CornerRect: TRect;
begin
  Rect:= GetDrawRect;
  DrawSystemBorder( Self, Rect, _BorderStyle );
  if _NeedHScroll and _NeedVScroll then
  begin
    CornerRect.Left:= Width - _ScrollBarWidth;
    CornerRect.Bottom:= 0;
    CornerRect.Right:= Width;
    CornerRect.Top:= _ScrollBarWidth;
    Canvas.ClipRect:= IntersectRect( Canvas.ClipRect, CornerRect );
    Canvas.FillRect( CornerRect, Parent.Color );
  end;
end;

Procedure DrawDottedRect( Canvas: TCanvas; Rect: TRect );
var
  OldStyle: TPenStyle;
begin
  OldStyle:= Canvas.Pen.Style;
  Canvas.Pen.Style:= psInsideFrame; // psAlternate for SPCC v2.5+
  Canvas.MoveTo( Rect.Left, Rect.Bottom - 1 );
  Canvas.LineTo( Rect.Left, Rect.Top );
  Canvas.LineTo( Rect.Right, Rect.Top );
  Canvas.LineTo( Rect.Right, Rect.Bottom );
  Canvas.LineTo( Rect.Left, Rect.Bottom );
  Canvas.Pen.Style:= OldStyle;
end;

procedure TOutline2.DrawPlusMinus( Rect: TRect;
                                   Expanded: boolean;
                                   Pressed: boolean );
var
  CentreY: integer;
  CentreX: integer;
begin
  CentreY:= ( Rect.Top + Rect.Bottom ) div 2;
  CentreX:= ( Rect.Left + Rect.Right ) div 2;

  Canvas.Pen.Color:= clBlack;

  case _PlusMinusStyle of
    pmFlat:
    begin
      if Pressed then
        Canvas.FillRect( Rect, clHighlight );
      DrawDottedRect( Canvas, Rect );
    end;

    pm3d:
    begin
      Canvas.Rectangle( Rect );

      InflateRect( Rect, -1, -1 );
      Canvas.FillRect( Rect, clLtGray );
      if Pressed then
        Canvas.ShadowedBorder( Rect,
                               clDkGray,
                               clWhite )
      else
        Canvas.ShadowedBorder( Rect,
                               clWhite,
                              clDkGray );
    end;
  end;

  // draw minus
  Canvas.Line( Rect.Left + 2, CentreY,
               Rect.Right - 2, CentreY );

  if not Expanded then
    // draw vertical stroke of +
    Canvas.Line( CentreX, Rect.Top - 2,
                 CentreX, Rect.Bottom + 2 );
end;

Function TOutline2.GetPlusMinusRect( Left, LineBottom: longint ): TRect;
Var
  CentreY: longint;
Begin
  CentreY:= LineBottom + _LineHeight div 2;

  Result.Left:= Left;
  Result.Right:= Left + _PlusMinusWidth - 1;
  Result.Bottom:= CentreY - _PlusMinusHeight div 2;
  Result.Top:= Result.Bottom + _PlusMinusHeight - 1;
end;

Function TOutline2.GetLineRect( LineBottom: longint ): TRect;
begin
  Result:= GetTextRect;

  Result.Top:= LineBottom + _LineHeight - 1;
  Result.Bottom:= LineBottom;
end;

Procedure TOutline2.PaintNode( Node: TNode;
                               X: longint;
                               Var Y: longint );
Var
  ChildIndex: longint;
  CentrePMX: longint;
  CentreY: longint;
  ChildCentreY: longint;
  TextW, TextH: longint;
  PlusMinusRect: TRect;
  TextX: longint;
  LineRect: TRect;
  SelectedRect: TRect;
Begin
  dec( Y, _LineHeight );

  PlusMinusRect:= GetPlusMinusRect( X, Y );

  CentrePMX:= X + _PlusMinusWidth div 2;
  CentreY:= Y + _LineHeight div 2;

  if     (    ( _DrawNode = AllNodes )
           or ( Node = _DrawNode ) )
     and ( Y + _LineHeight >= Canvas.ClipRect.Bottom ) // line top above bottom
     and ( Y <= Canvas.ClipRect.Top )  // line bottom below top
    then
  begin
    Canvas.GetTextExtent( Node.Text, TextW, TextH );
    TextX:= PlusMinusRect.Right + _StubWidth + _TextIndent;

    LineRect:= GetLineRect( Y );

    if Node = _SelectedNode then
    begin
      Canvas.Pen.Color:= clHighlightText;
      Canvas.Brush.Color:= clHighlight;
      if _SelectLine then
        SelectedRect:= LineRect
      else
      begin
        SelectedRect.Left:= TextX - _TextIndent div 2;
        SelectedRect.Top:= CentreY + TextH div 2 - 1;
        SelectedRect.Right:= TextX + TextW + _TextIndent div 2;
        SelectedRect.Bottom:= SelectedRect.Top - TextH + 1;
        // clear line
        Canvas.FillRect( LineRect, Color );
      end;

      // Draw selected background (either whole line, or just text background)
      Canvas.FillRect( SelectedRect, clHighLight );

      if HasFocus then
        Canvas.DrawFocusRect( SelectedRect );
    end
    else
    begin
      // Clear line
      Canvas.FillRect( LineRect, Color );
      Canvas.Pen.Color:= PenColor;
      Canvas.Brush.Color:= Color;
    end;

    // Draw text
    Canvas.Brush.Mode:= bmTransparent;
    Canvas.TextOut( TextX,
                    CentreY - TextH div 2,
                    Node.Text );

    if Node.ChildCount > 0 then
    begin
      // draw plus/minus
      DrawPlusMinus( PlusMinusRect,
                     Node._Expanded,
                     ( _MouseDownNode = Node )
                     and ( _MouseDownPart = npPlusMinus )
                     and ( _MouseDownFeedback ) );
      // Draw stub from plus/minus
      if _StubWidth > 0 then
      begin
        Canvas.Pen.Color:= _TreeLineColor;
        Canvas.Line( PlusMinusRect.Right + 1,
                     CentreY,
                     PlusMinusRect.Right + _StubWidth,
                     CentreY );
      end;

    end
    else
    begin
      // no children
      if Node._Parent <> _Root then
      begin
        Canvas.Pen.Color:= _TreeLineColor;
        // draw stub, no Plus minus
        Canvas.Line( X,
                     CentreY,
                     PlusMinusRect.Right + _StubWidth,
                     CentreY );
      end;
    end;
  end;

  if ( Node.ChildCount > 0 )
     and Node._Expanded then
  begin
    // draw children
    for ChildIndex:= 0 to Node.ChildCount-1 do
    begin
      // make sure truncation of the half pixel works same as for parent
      ChildCentreY:= Y - _LineHeight + _LineHeight div 2;
      if y < 0 then
        break;
      PaintNode( Node.Children[ ChildIndex ],
                 X + Indent,
                 Y );
      Canvas.Pen.Color:= _TreeLineColor;
      Canvas.Line( CentrePMX,
                   ChildCentreY,
                   X + _Indent,
                   ChildCentreY );
    end;

    // draw vertical branch line
    Canvas.Pen.Color:= _TreeLineColor;
    Canvas.Line( CentrePMX,
                 PlusMinusRect.Bottom - 1,
                 CentrePMX,
                 ChildCentreY );
  end;

End;

// Outline component implementation
Procedure TOutline2.TestHit( Point: TPoint;
                             Var Node: TNode;
                             Var Part: TNodePart );
Var
  ChildIndex: longint;
  Y: longint;
  DrawRect: TRect;
Begin
  Node:= nil;

  DrawRect:= GetDrawRect;
  if ( Point.X < DrawRect.Left )
     or ( Point.X > DrawRect.Right )
     or ( Point.Y > DrawRect.Top )
     or ( Point.Y < DrawRect.Bottom ) then
    exit;

  Y:= DrawRect.Top + _VScrollBar.Position;

  // test children
  for ChildIndex:= 0 to _Root.ChildCount - 1 do
  begin
    TestNodeHit( _Root.Children[ ChildIndex ],
                 Point,
                 _LeftMargin - _HScrollBar.Position,
                 Y,
                 Node,
                 Part );
    if Node <> nil then
      break;
    if Y < 0 then
      break;
  end;

End;

Procedure TOutline2.TestNodeHit( Node: TNode;
                                 Point: TPoint;
                                 X: longint;
                                 Var Y: longint;
                                 Var HitNode: TNode;
                                 Var Part: TNodePart );
Var
  ChildIndex: longint;
  TextW, TextH: longint;
  TextX: longint;
  PlusMinusRect: TRect;
  CentreY: longint;
  TextRect: TRect;
Begin

  dec( Y, _LineHeight );

  if ( Point.Y >= Y )
    and ( Point.Y < Y + _LineHeight ) then
  begin
    // this node. What part?

    HitNode:= Node;

    CentreY:= Y + _LineHeight div 2;

    PlusMinusRect:= GetPlusMinusRect( X, Y );

    if PointInRect( Point, PlusMinusRect ) then
    begin
      Part:= npPlusMinus;
      exit;
    end;

    Canvas.GetTextExtent( Node.Text, TextW, TextH );
    TextX:= X + _PlusMinusWidth + _StubWidth + _TextIndent;
    TextRect.Left:= TextX;
    TextRect.Right:= TextX + TextW;
    TextRect.Top:= CentreY + TextH div 2;
    TextRect.Bottom:= TextRect.Top + TextH;

    if PointInRect( Point, TextRect ) then
    begin
      Part:= npText;
      exit;
    end;

    // bitmap...

    Part:= npOther;
    exit;
  end;

  if Node.ChildCount > 0 then
    if Node._Expanded then
      // check children
      for ChildIndex:= 0 to Node.ChildCount-1 do
      begin
        TestNodeHit( Node.Children[ ChildIndex ],
                     Point,
                     X + Indent,
                     Y,
                     HitNode,
                     Part );
        if HitNode <> nil then
          break;
        if y < 0 then
          break;
      end;

End;

// Finds the distance from the top of the given node.
function TOutline2.GetNodePosition( const Node: TNode;
                                    Var NodeTop: longint ): boolean;
Var
  ChildIndex: longint;
  DrawRect: TRect;
Begin
  DrawRect:= GetDrawRect;

  NodeTop:= 0;

  // test children
  for ChildIndex:= 0 to _Root.ChildCount - 1 do
  begin
    if NodeGetNodePosition( Node,
                            _Root.Children[ ChildIndex ],
                            NodeTop ) then
    begin
      Result:= true;
      NodeTop:= - NodeTop;
      exit;
    end;
  end;
  Result:= false;
End;

function TOutline2.NodeGetNodePosition( const NodeToFind: TNode;
                                        const NodeToScan: TNode;
                                        Var NodeTop: longint ): boolean;
Var
  ChildIndex: longint;
Begin
  if NodeToFind = NodeToScan then
  begin
    Result:= true;
    exit;
  end;

  dec( NodeTop, _LineHeight );

  if NodeToScan.ChildCount > 0 then
    if NodeToScan._Expanded then
      // check children
      for ChildIndex:= 0 to NodeToScan.ChildCount-1 do
      begin
        if NodeGetNodePosition( NodeToFind,
                                NodeToScan.Children[ ChildIndex ],
                                NodeTop ) then
        begin
          Result:= true;
          exit;
        end;
      end;
  Result:= false;
End;

Procedure TOutline2.SetSelectedNode( Node: TNode );
var
  OldSelectedNode: TNode;
  NodePosition: longint;
  DrawRect: TRect;
  DrawHeight: longint;
  OldScroll: longint;
begin
  if _UpdateCount > 0 then
  begin
    _NewSelectedNode:= Node;
    exit;
  end;

  if _SelectedNode = Node then
    exit;

  OldSelectedNode:= _SelectedNode;

  _SelectedNode:= Node;

  if Node = nil then
  begin
    DrawNode( OldSelectedNode ); // clear old
    exit;
  end;

  if not Node.IsVisible then
    _SelectedNode.ExpandParents // this will refresh the whole thing...
  else
    DrawNode( OldSelectedNode ); // clear old

  DrawRect:= GetDrawRect;
  DrawHeight:= DrawRect.Top - DrawRect.Bottom;

  OldScroll:= _VScrollBar.Position;
  if GetNodePosition( Node, NodePosition ) then
  begin
    if NodePosition + _LineHeight > _VScrollBar.Position + DrawHeight then
      // Node is below bottom of control - scroll down
      _VScrollBar.Position:= NodePosition - DrawHeight + _LineHeight;

    if NodePosition < _VScrollBar.Position then
      // Node is aobve top of control - scroll up
      _VScrollBar.Position:= NodePosition;
  end;


  // draw new
  if OldScroll = _VScrollBar.Position then
    DrawNode( _SelectedNode )
  else
    Refresh;

  if _OnItemFocus <> nil then
    _OnItemFocus( Node );

end;

Procedure TOutline2.SetTopNode( Node: TNode );
var
  NodePosition: longint;
begin
  Node.ExpandParents;

  if GetNodePosition( Node, NodePosition ) then
  begin
     _VScrollBar.Position:= NodePosition;
  end;
end;

Procedure TOutline2.SetAutoLineHeight( Value: boolean );
begin
  _AutoLineHeight := Value;
  if Value then
    FontChange;
end;

Procedure TOutline2.SetLineHeight( LineHeight: longint );
begin
  if LineHeight < _PlusMinusHeight + 1 then
    LineHeight := _PlusMinusHeight + 1;
  if _LineHeight = LineHeight then
    exit;
  _LineHeight:= LineHeight;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetIndent( Indent: longint );
begin
  if _Indent = Indent then
    exit;

  _Indent:= Indent;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetBorderStyle( BorderStyle: TBorderStyle );
begin
  if _BorderStyle = BorderStyle then
    exit;
  _BorderStyle:= BorderStyle;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetScrollbarWidth( ScrollbarWidth: longint );
begin
  _ScrollBarWidth:= ScrollBarWidth;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetLeftMargin( LeftMargin: longint );
begin
  if _LeftMargin = LeftMargin then
    exit;
  _LeftMargin:= LeftMargin;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetTextIndent( TextIndent: longint );
begin
  if _TextIndent = TextIndent then
    exit;
  _TextIndent:= TextIndent;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetPlusMinusWidth( PlusMinusWidth: longint );
begin
  if _PlusMinusWidth = PlusMinusWidth then
    exit;

  if PlusMinusWidth < 7 then
    PlusMinusWidth:= 7;

  _PlusMinusWidth:= PlusMinusWidth;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetPlusMinusHeight( PlusMinusHeight: longint );
begin
  if _PlusMinusHeight = PlusMinusHeight then
    exit;
  if PlusMinusHeight < 7 then
    PlusMinusHeight:= 7;

  _PlusMinusHeight:= PlusMinusHeight;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetStubWidth( StubWidth: longint );
begin
  if _StubWidth = StubWidth then
    exit;
  _StubWidth:= StubWidth;
  ScanExtents;
  Refresh;
end;

Procedure TOutline2.SetPlusMinusStyle( NewValue: TPlusMinusStyle );
begin
  if _PlusMinusStyle = NewValue then
    exit;

  _PlusMinusStyle:= NewValue;
  Refresh;
end;

Procedure TOutline2.SetSelectLine( NewValue: boolean );
begin
  if _SelectLine = NewValue then
    exit;
  _SelectLine:= NewValue;
  DrawNode( _SelectedNode );
end;

Procedure TOutline2.SetTreeLineColor( NewValue: TColor );
begin
  if _TreeLineColor = NewValue then
    exit;
  _TreeLineColor:= NewValue;
  Refresh;
end;

procedure TNode.ExpandParents;
var
  AParent: TNode;
begin
  AParent:= self._Parent;
  while AParent._Parent <> nil do
  begin
    AParent.Expand;
    AParent:= AParent._Parent;
  end;
end;

procedure TOutline2.Clear;
begin
  BeginUpdate;
  _Root.Clear;
  EndUpdate;
end;

Function TOutline2.AddChild( const TheText: string;
                             const TheObject: TObject ): TNode;
Begin
  Result := _Root.AddChild( TheText, TheObject );
End;

Function TOutline2.GetChild( index: longint ): TNode;
Begin
  Result:= _Root.Children[ index ];
End;

Function TOutline2.GetChildCount: longint;
begin
  Result:= _Root.ChildCount;
end;

Procedure TOutline2.SetupScrollbars;
Begin
  _VScrollbar.Visible:= _NeedVScroll;
  if _NeedVScroll then
  begin
    _VScrollbar.Left:= Width - _ScrollbarWidth;
    _VScrollbar.Width:= _ScrollbarWidth;

    if _NeedHScroll then
    begin
      _VScrollbar.Bottom:= _ScrollbarWidth;
      _VScrollbar.Height:= Height - _ScrollbarWidth
    end
    else
    begin
      _VScrollbar.Bottom:= 0;
      _VScrollbar.Height:= Height;
    end;
  end;

  _HScrollbar.Visible:= _NeedHScroll;
  if _NeedHScroll then
  begin
    _HScrollbar.Left:= 0;
    _HScrollbar.Bottom:= 0;
    _HScrollbar.Height:= _ScrollbarWidth;

    if _NeedVScroll then
      _HScrollbar.Width:= Width - _ScrollBarWidth
    else
      _HScrollbar.Width:= Width;
  end;

End;

Procedure TOutline2.Resize;
begin
  ScanExtents;
end;

Procedure TOutline2.SetupComponent;
Begin
  Inherited SetupComponent;
  Name:= 'Outline2';

  Width:= 100;
  Height:= 100;

  _BorderStyle:= bsSingle;
  FSmoothScroll := true;

  _StubWidth:= 0;
  _Indent:= 11;
  _PlusMinusWidth:= 11;
  _PlusMinusHeight:= 11;
  _AutoLineHeight := true;
  _LeftMargin:= 5;
  _TextIndent:= 5;
  _ScrollbarWidth:= 15;
  _PlusMinusStyle:= pm3d;
  _SelectLine:= false;
  _TreeLineColor:= clGray;

  Color:= clEntryField;
  ParentPenColor:= true;
  Exclude( ComponentState, csAcceptsControls );

  if not InDesigner then
  begin
    _Root:= TNode.Create( nil );
    _Root.Text:= 'Root';
    _Root._Outline:= self;
    _Root._Expanded:= true; // by definition
    _SelectedNode:= nil;

    _MouseDownNode:= nil;
    _MouseDownPart:= npNothing;

    _HScrollbar.Create( self );
    _HScrollbar.Kind:= sbHorizontal;
    Include( _HScrollbar.ComponentState, csDetail );
    _HScrollbar.Parent:= self;

    _VScrollbar.Create( self );
    _VScrollbar.Kind:= sbVertical;
    Include( _VScrollbar.ComponentState, csDetail );
    _VScrollbar.Parent:= self;

    _UpdateCount:= 0;

    _HoverTimer := TTimer.Create( self );
    _HoverTimer.Interval := 500;
    _HoverTimer.OnTImer := OnHoverTimeout;
    _HintWindow:= THintWindow.Create( self );
    _HintWindow.CreateWnd;
  end;

End;

Destructor TOutline2.Destroy;
Begin
  if not InDesigner then
  begin
    _Root.Destroy;
  end;
  Inherited Destroy;
End;

Procedure TOutline2.SetupShow;
begin
  Inherited SetupShow;
  _UpdateCount:= 0;

  if not InDesigner then
    ScanExtents;
end;

Procedure TOutline2.MouseDown( Button: TMouseButton;
                               ShiftState: TShiftState;
                               X, Y: Longint );
var
  Node: TNode;
  Part: TNodePart;
  Point: TPoint;
begin
  inherited MouseDown( Button, ShiftState, X, Y );

  if InDesigner then
    exit;

  Focus;

  MouseCapture:= true;
  Point.X:= X;
  Point.Y:= Y;
  TestHit( Point,
           Node,
           Part );
  if Node <> nil then
  begin
    _MouseDownNode:= Node;
    _MouseDownPart:= Part;

    _MouseDownFeedback:= true;
    _LastMouseMoveFeedback:= true;

    DrawNode( _MouseDownNode );
  end;
end;

Procedure TOutline2.MouseMove( ShiftState: TShiftState;
                               X, Y: Longint );
var
  Node: TNode;
  Part: TNodePart;
  Point: TPoint;
begin
  if InDesigner then
    exit;

  if not MouseCapture then
  begin
    _HoverTimer.Stop;
//    _HoverTimer.Start;
    _LastMouseX := X;
    _LastMouseY := Y;
    exit;
  end;

  Point.X:= X;
  Point.Y:= Y;
  TestHit( Point,
           Node,
           Part );

  _MouseDownFeedback:=
    ( Node = _MouseDownNode )
    and ( Part = _MouseDownPart );

  if _LastMouseMoveFeedback <> _MouseDownFeedback then
    DrawNode( _MouseDownNode );

  _LastMouseMoveFeedback:= _MouseDownFeedback;
end;

Procedure TOutline2.MouseUp( Button: TMouseButton;
                             ShiftState: TShiftState;
                             X, Y: Longint );
var
  Node: TNode;
  Part: TNodePart;
  Point: TPoint;
  MouseDownNode: TNode;
begin
  if InDesigner then
    exit;

  if not MouseCapture then
    exit;

  MouseDownNode:= _MouseDownNode;
  _MouseDownNode:= nil;
  MouseCapture:= false;

  Point.X:= X;
  Point.Y:= Y;
  TestHit( Point,
           Node,
           Part );

  if ( Node <> nil )
     and ( Node = MouseDownNode )
     and ( Part = _MouseDownPart )
  then
  begin
    if Part = npPlusMinus then
    begin
      if Node.Expanded then
        Node.Collapse
      else
        Node.Expand;
    end
    else
    begin
      SelectedNode:= Node;

      if Assigned( _OnItemClick ) then
        _OnItemClick( Node );
    end;

  end
  else
  begin
    DrawNode( MouseDownNode );
  end;

end;

Procedure TOutline2.MouseDblClick( Button: TMouseButton;
                                   ShiftState: TShiftState;
                                   X, Y: Longint );
var
  Node: TNode;
  Part: TNodePart;
  Point: TPoint;
begin
  if InDesigner then
    exit;

  Point.X:= X;
  Point.Y:= Y;
  TestHit( Point,
           Node,
           Part );
  if Node <> nil then
  begin
    if Part = npPlusMinus then
      if Node.Expanded then
        Node.Collapse
      else
        Node.Expand
    else
    begin
      SelectedNode:= Node;
      if Assigned( _OnItemDblClick ) then
       _OnItemDblClick( Node );
    end;

  end;
end;

procedure TOutline2.BeginUpdate;
begin
  if _UpdateCount = 0 then
    _NewSelectedNode:= _SelectedNode;

  inc( _UpdateCount );
end;

procedure TOutline2.EndUpdate;
begin
  dec( _UpdateCount );
  if _UpdateCount = 0 then
  begin
    ScanExtents;
    Refresh;
    SetSelectedNode( _NewSelectedNode );
  end
  else if _UpdateCount < 0 then
    raise Exception.Create( 'Too many EndUpdates in TOutline2!' );
end;

procedure TOutline2.SetSelectedObject( Data: TObject );
var
  Node: TNode;
begin
  Node:= _Root.FindData( Data );
  SelectedNode:= Node;
end;

function TOutline2.NodeFromObject( Data: TObject ): TNode;
begin
  Result:= _Root.FindData( Data );
end;

function TOutline2.FindByFunction( FindFunction: TNodeFindFunction ): TNode;
begin
  Result:= _Root.FindByFunction( FindFunction );
end;

Procedure TOutline2.GotoFirstNode;
begin
  if ChildCount > 0 then
    SelectedNode:= Children[ 0 ];
end;

Procedure TOutline2.GotoLastVisibleNode;
var
  Node: TNode;
begin
  Node:= LastVisibleNode;
  if Node <> nil then
    SelectedNode:= Node;
end;

function TOutline2.LastVisibleNode: TNode;
begin
  Result:= nil;
  if ChildCount > 0 then
  begin
    Result:= _Root;
    while Result.HasChildren do
    begin
      if Result.Expanded then
        Result:= Result.Children[ Result.ChildCount - 1 ]
      else
        break;
    end;
  end;
end;

function TOutline2.NextNodeUp( Node: TNode;
                               VisibleOnly: boolean ): TNode;
var
  NodeIndexInParent: longint;
begin
  NodeIndexInParent:= Node.IndexInParent;
  if NodeIndexInParent = 0 then
  begin
    if Node._Parent = _Root then
      Result:= nil // nothing above this one
    else
      Result:= Node._Parent
  end
  else
  begin
    Result:= Node._Parent.Children[ NodeIndexInParent - 1 ];
    while Result.HasChildren
          and ( Result.Expanded or ( not VisibleOnly ) ) do
    begin
      Result:= Result.Children[ Result.ChildCount - 1 ];
    end;
  end;

end;

function TOutline2.NextNodeDown( Node: TNode;
                                 VisibleOnly: boolean ): TNode;
var
  NodeIndexInParent: longint;
begin
  if Node.HasChildren
     and ( Node.Expanded or ( not VisibleOnly ) ) then
    Result:= Node.Children[ 0 ]
  else
  begin
    Result:= node;
    while Result <> _Root do
    begin
      NodeIndexInParent:= Result.IndexInParent;
      if NodeIndexInParent < Result._Parent.ChildCount - 1 then
      begin
        Result:= Result._Parent.Children[ NodeIndexInParent + 1 ];
        break;
      end;
      Result:= Result._Parent;
    end;
    if Result = _Root then
    begin
      Result:= nil;
      // already at bottom
      exit;
    end;
  end;
end;

function TOutline2.GotoNextVisibleNodeUp: boolean;
var
  NextNode: TNode;
begin
  Result := true;
  if SelectedNode <> nil then
  begin
    NextNode:= NextNodeUp( SelectedNode, true );
    if NextNode <> nil then
      SelectedNode:= NextNode
    else
      Result := false;
  end
  else
    GotoFirstNode;
end;

function TOutline2.GotoNextVisibleNodeDown: boolean;
var
  NextNode: TNode;
begin
  Result := true;
  if SelectedNode <> nil then
  begin
    NextNode:= NextNodeDown( SelectedNode, true );
    if NextNode <> nil then
      SelectedNode:= NextNode
    else
      Result := false;
  end
  else
    GotoFirstNode;
end;

function TOutline2.GotoNextNodeUp: boolean;
var
  NextNode: TNode;
begin
  Result := true;
  if SelectedNode <> nil then
  begin
    NextNode:= NextNodeUp( SelectedNode, false );
    if NextNode <> nil then
      SelectedNode:= NextNode
    else
      Result := false;
  end
  else
    GotoFirstNode;
end;

function TOutline2.GotoNextNodeDown: boolean;
var
  NextNode: TNode;
begin
  Result := true;
  if SelectedNode <> nil then
  begin
    NextNode:= NextNodeDown( SelectedNode, false );
    if NextNode <> nil then
      SelectedNode:= NextNode
    else
      Result := false;
  end
  else
    GotoFirstNode;
end;

Procedure TOutline2.PageUp;
var
  NextNode: TNode;
  Y: longint;
begin
  if SelectedNode <> nil then
  begin
    NextNode:= NextNodeUp( SelectedNode, true );
    Y:= _LineHeight;
    while ( NextNode <> nil )
          and ( Y < DrawHeight ) do
    begin
      inc( Y, _LineHeight );
      NextNode:= NextNodeUp( NextNode, true );
    end;
    if NextNode = nil then
      GotoFirstNode
    else
      SelectedNode:= NextNode;

  end
  else
    GotoFirstNode;
end;

Procedure TOutline2.PageDown;
var
  NextNode: TNode;
  Y: longint;
begin
  if SelectedNode <> nil then
  begin
    NextNode:= NextNodeDown( SelectedNode, true );
    Y:= _LineHeight;
    while ( NextNode <> nil )
          and ( Y < DrawHeight ) do
    begin
      inc( Y, _LineHeight );
      NextNode:= NextNodeDown( NextNode, true );
    end;
    if NextNode = nil then
      GotoLastVisibleNode
    else
      SelectedNode:= NextNode;

  end
  else
    GotoFirstNode;
end;

Procedure TOutline2.CollapseAll;
begin
  _Root.CollapseChildren( true );
end;

Procedure TOutline2.ExpandAll;
begin
  _Root.ExpandChildren( true );
end;

Procedure TOutline2.SetFocus;
begin
  inherited SetFocus;
  if _SelectedNode <> nil then
    DrawNode( _SelectedNode );
end;

Procedure TOutline2.KillFocus;
begin
  inherited KillFocus;
  if _SelectedNode <> nil then
    DrawNode( _SelectedNode );
end;

Procedure TOutline2.ScanEvent( Var KeyCode: TKeyCode;
                               RepeatCount: Byte );
Begin
  if InDesigner then
  begin
    inherited ScanEvent( KeyCode, RepeatCount );
    exit;
  end;

  Case KeyCode Of
    kbHome, kbCtrlHome, kbCtrlPageUp:
      GotoFirstNode;

    kbEnd, kbCtrlEnd, kbCtrlPageDown:
      GotoLastVisibleNode;

    kbCUp:
    begin
      GotoNextVisibleNodeUp;
      KeyCode := kbNull; // prevent sibyl changing focus
    end;

    kbCDown:
    begin
      GotoNextVisibleNodeDown;
      KeyCode := kbNull; // prevent sibyl changing focus
    end;

    kbPageUp:
      PageUp;

    kbPageDown:
      PageDown;

  End;

  inherited ScanEvent( KeyCode, RepeatCount );

End;

Function TOutline2.FindNextNodeByText( StartNode: TNode;
                                       const S: string;
                                       VisibleOnly: boolean ): TNode;

var
  Node: TNode;
begin
  Result := nil;

  if StartNode = nil then
    exit;

  Node := StartNode;

  while true do
  begin
    Node := NextNodeDown( Node, VisibleOnly );
    if Node = nil then
      // reached bottom, start from top again.
      Node := Children[ 0 ];

    if Node = StartNode then
      // searched all nodes, done.
      exit;

    if StrStartsWithIgnoringCase(Node.Text, S) then
    begin
      // found
      Result := Node;
      exit;
    end;
  end;
end;

Procedure TOutline2.CharEvent( Var Key: Char;
                               RepeatCount: Byte );
var
  Node: TNode;
  NextNode: TNode;
begin
  if InDesigner then
  begin
    inherited CharEvent( Key, RepeatCount );
    exit;
  end;

  if SelectedNode <> nil then
  begin
    case Key of
      '+', '=': // = to catch non-shifted + on most keyboards
        SelectedNode.Expand;

      '-':
        SelectedNode.Collapse;

      ' ': // space toggles expanded/collapsed
        if SelectedNode.Expanded then
          SelectedNode.Collapse
        else
          SelectedNode.Expand;

      '*': // Alberto thinks this would be nice to expand the tree...
      begin
        SelectedNode.Expand;
        SelectedNode.ExpandChildren( true );
      end;

      else
      begin
        // search by first letter, in visible nodes.

        if ChildCount = 0 then
          // no nodes to search in
          exit;

        if SelectedNode = nil then
          Node := _Root.Children[ 0 ]
        else
          Node := SelectedNode;

        NextNode := FindNextNodeByText( Node, key, true ); // visible only
        if NextNode <> nil then
          SelectedNode := NextNode;

      end;
    end;
  end;

  inherited CharEvent( Key, RepeatCount );
end;

Procedure TOutline2.OnHoverTimeout( Sender: TObject );
var
  R: TRect;
begin
  R.Left := _LastMouseX;
  R.Bottom := _LastMouseY;
  R.Right := R.Left + 100;
  R.Top := R.Bottom + 50;
  // show hint
  R.LeftBottom := ClientToScreen( R.LeftBottom );
  R.RightTop := ClientToScreen( R.RightTop );
  _HintWindow.Parent := Parent;
  _HintWindow.ActivateHint( R, 'Yees' );
  _HoverTimer.Stop;
end;

Procedure TOutline2.WMMouseLeave( Var Msg: TMessage );
begin
  if InDesigner then
    exit;
  _HoverTimer.Stop;
//  _HintWindow.DeactivateHint;
end;

Procedure TOutline2.FontChange;
begin
  inherited FontChange;

  if _AutoLineHeight then
  begin
    LineHeight := Canvas.TextHeight( 'H' ) + 1;
    Refresh; // lineheight change alone may not be enough.
  end;
end;

Procedure TOutline2.DoVerticalScroll( NewY: longint );
var
  ScrollDistance: longint;
begin
  if not Visible then
    exit;

  FYScroll := NewY;
  ScrollDistance:= FYScroll - FLastYScroll;

  ScrollControlRect( Self,
                     GetTextRect,
                     0,
                     ScrollDistance,
                     Color,
                     FSmoothScroll );

  FLastYScroll:= FYScroll;
  PostMsg( Handle, WM_PAINT, 0, 0 );
end;

Procedure TOutline2.DoHorizontalScroll( NewX: longint );
var
  ScrollDistance: longint;
begin
  if not Visible then
    exit;

  FXScroll := NewX;
  ScrollDistance:= FXScroll - FLastXScroll;

  ScrollControlRect( Self,
                     GetTextRect,
                     - ScrollDistance,
                     0,
                     Color,
                     FSmoothScroll );

  FLastXScroll:= FXScroll;
  PostMsg( Handle, WM_PAINT, 0, 0 );
end;

Procedure TOutline2.Scroll( Sender: TScrollbar;
                            ScrollCode: TScrollCode;
                            Var ScrollPos: Longint );

begin
  case ScrollCode of
//    scVertEndScroll,
    scVertPosition,
    scPageUp,
    scPageDown,
    scVertTrack,
    scLineDown,
    scLineUp:
    begin
      DoVerticalScroll( ScrollPos );
    end;

    scHorzPosition,
    scPageRight,
    scPageLeft,
    scHorzTrack,
    scColumnRight,
    scColumnLeft:
    begin
      DoHorizontalScroll( ScrollPos );
    end;
  end;
end;

Initialization
  {Register classes}
  RegisterClasses([TOutline2]);
End.


