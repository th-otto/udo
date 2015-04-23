Unit CustomListBox;
// Enhanced list box with the following additional features
// - During updates, remembers selection and top index and
//   at the end will attempt to reselect and reposition the same
// - Remembers which item was right clicked (PopupIndex)
// - When an item is right clicked, it is selected if it isn't already
// - Calls an event when presentation parameters (color/pencolor)
//   are changed

Interface


{$ifdef win32}
Uses
  StdCtrls;

Type
  TListBoxType = TCustomListBox;

{$else}
Uses
  Classes, Forms, StdCtrls;

Type
  TCustomListBox=Class( TListBox )
  Protected
    Procedure SetupComponent; Override;
    FPopupIndex: longint;
    Procedure MouseDown( Button: TMouseButton;
                         ShiftState: TShiftState;
                         X, Y: LongInt ); Override;

    // These are used to hold previous selection during Update
    FSavedSelected:TStringList;
    FSavedTopItem: string;

    Procedure DefaultHandler( Var message ); override;
    function GetSelectedObject: TObject;
    procedure SetSelectedObject(const Value: TObject);
    function GetSelectedItem: string;
    procedure SetSelectedItem(const Value: string);
  Public
    // These do the same as BeginUpdate and EndUpdate, with additions
    // (They remember selection & topindex)
    Procedure StartUpdate; Virtual;
    Procedure CompleteUpdate; Virtual;

    Property PopupIndex: longint read FPopupIndex;
    Destructor Destroy; Override;

    // Loads selected items (with associated objects, if any)
    // into Destination
    Procedure GetSelectedItems( Destination: TStrings );

    property SelectedItem: string read GetSelectedItem write SetSelectedItem;
    property SelectedObject: TObject read GetSelectedObject write SetSelectedObject;

    Procedure SelectAll;
  End;
  TListBoxType = TCustomListBox;

Exports
  TCustomListBox,'User','CustomListBox.bmp';
{$endif}

Implementation

{$ifdef os2}
Uses
  Messages, PMWin, OS2Def;
{$endif}

{$ifdef os2}
// Loads selected items (with associated objects, if any)
// into Destination
Procedure TCustomListBox.GetSelectedItems( Destination: TStrings );
Var
  i: longint;
Begin
  Destination.Clear;
  for i:=0 to Items.Count-1 do
    if Selected[ i ] then
      Destination.AddObject( Items[ i ],
                             Items.Objects[ i ] );
End;

Procedure TCustomListBox.DefaultHandler( Var message );
Begin
  inherited DefaultHandler( message );
// stupid private declarations
//  if FUpdatingPP then exit;
  if TMessage( message ).msg=WM_PRESPARAMCHANGED then
    exit;
    // call event...
End;

Procedure TCustomListBox.StartUpdate;
Var
  i: longint;
Begin
  FSavedSelected.Clear;
  for i:=0 to Items.Count-1 do
  begin
    if Selected[ i ] then
      FSavedSelected.Add( Items[ i ] );
  End;
  FSavedTopItem:='---';
  if Items.Count>0 then
    FSavedTopItem:=Items[ TopIndex ];
  BeginUpdate;
End;

Procedure TCustomListBox.CompleteUpdate;
Var
  i: longint;
  Index: longint;
  FirstSelectedIndex: longint;
Begin
  FirstSelectedIndex := -1;
  for i:=0 to FSavedSelected.Count-1 do
  begin
    Index:=Items.IndexOf( FSavedSelected[ i ] );
    if Index>-1 then
    begin
      Selected[ index ]:=true;
      if FirstSelectedIndex = -1 then
        FirstSelectedIndex := Index;
    end;
  End;
  FSavedSelected.Clear;
  Index:=Items.IndexOf( FSavedTopItem );
  if Index>-1 then
    TopIndex:=Index;
  EndUpdate;
  if FirstSelectedIndex <> -1 then
    ItemIndex := FirstSelectedIndex;
End;

Procedure TCustomListBox.MouseDown( Button: TMouseButton;
                                    ShiftState: TShiftState;
                                    X, Y: LongInt );
Var
  ThePoint: TPoint;
Begin
  ThePoint.X:= X;
  ThePoint.Y:= Y;
  if Button<>mbRight then
  begin
    Inherited MouseDown( Button, ShiftState, X, Y);

    if MultiSelect then
      if not ( SSCtrl in ShiftState )
         and not ( SSShift in ShiftState ) then
        ItemIndex:= ItemAtPos( ThePoint, True );
    exit;
  end;
  FPopupIndex:= ItemAtPos( ThePoint, True );
  if FPopupIndex>-1 then
    if not Selected[ FPopupIndex ] then
      // If what they're clicking on is not already selected, select it
      ItemIndex:= FPopupIndex;
  Inherited MouseDown( Button, ShiftState, X, Y);
End;

Procedure TCustomListBox.SetupComponent;
Begin
  Inherited SetupComponent;
  FSavedSelected:= TStringList.Create;
End;

Destructor TCustomListBox.Destroy;
Begin
  FSavedSelected.Destroy;
  Inherited Destroy;
End;

function TCustomListBox.GetSelectedObject: TObject;
begin
  if ItemIndex <> -1 then
    Result:= Items.Objects[ ItemIndex ]
  else
    Result:= nil;
end;

procedure TCustomListBox.SetSelectedObject(const Value: TObject);
begin
  ItemIndex:= Items.IndexOfObject( Value );
end;

function TCustomListBox.GetSelectedItem: string;
begin
  if ItemIndex <> -1 then
    Result:= Items[ ItemIndex ]
  else
    Result:= '';
end;

procedure TCustomListBox.SetSelectedItem(const Value: string);
begin
  ItemIndex:= Items.IndexOf( Value );
end;

Procedure TCustomListBox.SelectAll;
var
  i: longint;
begin
  BeginUpdate;
  for i := 0 to Items.Count - 1 do
    Selected[ i ] := true;
  EndUpdate;
end;

Initialization
  {Register classes}
  RegisterClasses([TCustomListBox]);

{$endif}

End.

