Unit SplitBar;

Interface

Uses
  Classes, Forms, ExtCtrls, Graphics;

Type
  TSplitChange = procedure( NewSplit: longint ) of Object;

  TSplitBar=Class(TPanel)
  Protected
    FOldFgMode: TPenMode;
    FOldPanelX: longint;
    FOffset: longint;
    FMinimum: longint;
    FMaximum: longint;

    FOnChange: TSplitChange;

    Function GetX( XInParent: longint ): longint;
    Procedure DrawSplitLine( X: longint );
    Procedure SetupComponent; Override;
    Procedure MouseDown( Button: TMouseButton;
                         Shift: TShiftState;
                         X: LongInt; Y: LongInt ); override;
    Procedure MouseMove( Shift: TShiftState;
                         X: LongInt; Y: LongInt); override;
    Procedure MouseUp( Button: TMouseButton;
                       Shift: TShiftState;
                       X: LongInt; Y: LongInt); override;

  Protected
    Procedure SetMinimum( Minimum: longint );
    Procedure SetMaximum( Maximum: longint );
  Protected
    // Hide some properties
    property Caption;
    property Align;
    property Alignment;
    property DragCursor;
    property DragMode;
    property Font;
    property ParentFont;
    property PenColor;
    property ParentPenColor;

    property OnCanDrag;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnFontChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  Public
    Destructor Destroy; Override;
  published
    property Minimum: longint read FMinimum write SetMinimum;
    property Maximum: longint read FMaximum write SetMaximum;
    property OnChange: TSplitChange read FOnChange write FOnChange;

  End;

Exports
  TSplitBar,'User','SplitBar.bmp';

Implementation

Procedure TSplitBar.SetupComponent;
Begin
  Inherited SetupComponent;
  Width:= 6;
  BevelWidth:= 2;
  FMinimum:= 0;
  FMaximum:= -1; // maximum in parent
  Caption:= '';
  Name:= 'SplitBar';
  Cursor:= crHSplit;
End;

Destructor TSplitBar.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TSplitBar.SetMinimum( Minimum: longint );
begin
  FMinimum:= Minimum;
  if Left < Minimum then
    Left:= Minimum;
end;

Procedure TSplitBar.SetMaximum( Maximum: longint );
begin
  FMaximum:= Maximum;
  if Left > Maximum then
    Left:= Maximum;
end;

Function TSplitBar.GetX( XInParent: longint ): longint;
begin
  Result:= Left + XInParent - FOffset;
  if Result < FMinimum then
    Result:= FMinimum;
  if Result < 0 then
    Result:= 0;

  if FMaximum <> -1 then
  begin
    if Result > FMaximum then
      Result:= FMaximum;
  end;
  if Result > ( Parent.ClientWidth - Width ) then
    Result:= Parent.ClientWidth - Width;
end;

Procedure TSplitBar.DrawSplitLine( X: longint );
var
  ClientPoint, ScreenPoint: TPoint;
  r: TRect;
begin
  ClientPoint.x:= X;
  ClientPoint.y:= Bottom;
  ScreenPoint:= Parent.ClientToScreen( ClientPoint );
  r.Left:= ScreenPoint.X;
  r.Bottom:= ScreenPoint.Y;
  r.Top:= ScreenPoint.Y + Height - 1;
  r.Right:= ScreenPoint.X + Width - 1;
  Screen.Canvas.Box( r );
end;

Procedure TSplitBar.MouseUp( Button: TMouseButton;
                             Shift: TShiftState;
                             X: LongInt; Y: LongInt);
Begin
  if not MouseCapture then
    exit;

  // final erase of cursor
  DrawSplitLine( FOldPanelX );
  MouseCapture:= false;

  Left:= GetX( X );
  if FOnChange <> nil then
    FOnChange( Left  );
End;

Procedure TSplitBar.MouseMove( Shift: TShiftState;
                               X: LongInt; Y: LongInt);
Begin
  if not MouseCapture then
    exit;

  // erase cursor
  DrawSplitLine( FOldPanelX );

  X:= GetX(  X );

  FOldPanelX:= X;

  // draw new cursor
  DrawSplitLine( X );

End;

Procedure TSplitBar.MouseDown( Button: TMouseButton;
                               Shift: TShiftState;
                               X: LongInt; Y: LongInt );
Begin
  if Button <> mbLeft then
    exit;

  MouseCapture:= true;
  FOldFgMode := Screen.Canvas.Pen.Mode;

  Screen.Canvas.Pen.Mode := pmNot;

  // Store the offset within the control that the mouse was clicked
  FOffset:= X;

  X:= Left;

  // Draw cursor
  DrawSplitLine( X );

  FOldPanelX:= X;
End;

Initialization
  {Register classes}
  RegisterClasses([TSplitBar]);
End.

