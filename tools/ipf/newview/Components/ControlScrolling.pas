Unit ControlScrolling;

Interface

uses
  Forms, Classes;

Procedure ScrollControlRect( Control: TControl;
                             Rect: TRect;
                             XScrollDistance, YScrollDistance: longint;
                             BackGroundColor: TColor;
                             Smooth: boolean );

Implementation

uses
  Os2Def, PmWin, PmGpi, Graphics;

Procedure ScrollRect( Control: TControl;
                      Rect: TRect;
                      XScrollDistance, YScrollDistance: longint;
                      BackGroundColor: TColor );
var
  SourceRect: RECTL;
  InvalidRegion: HRGN;
  rc: APIRET;
begin
  SourceRect:= RECTL( Rect );
  inc( SourceRect.yTop, 1 ); // WinScrollWindow expects top/right + 1
  inc( SourceRect.xRight, 1 );

  InvalidRegion:= GpiCreateRegion( Control.Canvas.Handle, 0, nil );
  WinScrollWindow( Control.Handle,
                   XScrollDistance,
                   YScrollDistance,
                   SourceRect,
                   SourceRect, // destination clip
                   InvalidRegion,
                   nil,
                   SW_INVALIDATERGN );

  // Clear the invalidated area.
  Control.Canvas.Pen.Color := BackgroundColor;
  Control.Canvas.Brush.Style:= bsSolid;
  rc:= GpiPaintRegion( Control.Canvas.Handle, InvalidRegion );

  GpiDestroyRegion( Control.Canvas.Handle, InvalidRegion );
end;

Function FSign( arg: double ): double;
begin
  if arg>0 then
    Result:= 1
  else if arg<0 then
    Result:= -1
  else
    Result:= 0;
end;

Function Sign( arg: longint ): longint;
begin
  if arg>0 then
    Result:= 1
  else if arg<0 then
    Result:= -1
  else
    Result:= 0;
end;

Procedure ScrollControlRect( Control: TControl;
                             Rect: TRect;
                             XScrollDistance, YScrollDistance: longint;
                             BackGroundColor: TColor;
                             Smooth: boolean );
var
  LastTime: ULONG;
  X, Y: double;
  XScrolled, YScrolled: longint;
  NextX, NextY: double;
  Width: longint;
  Height: longint;
  XScrollStep: double;
  YScrollStep: double;
  XScrollAmount: longint;
  YScrollAmount: longint;
begin
  Height:= Rect.Top - Rect.Bottom + 1;
  Width:= Rect.Right - Rect.Left + 1;

  if ( XScrollDistance = 0 )
     and ( YScrollDistance = 0 ) then
    exit;

  if   ( Abs( XScrollDistance ) >= Width )
    or ( Abs( YScrollDistance ) >= Height ) then
  begin
    // scrolling more than a screen in height
    Control.InvalidateRect( Rect );
    exit;
  end;

  if not Smooth then
  begin
    ScrollRect( Control,
                Rect,
                XScrollDistance,
                YScrollDistance,
                BackGroundColor );

    exit;
  end;
  Y:= 0;
  X:= 0;
  XScrolled:= 0;
  YScrolled:= 0;

  if XScrollDistance <> 0 then
  begin
    XScrollStep:= Abs( XScrollDistance ) / 10.0
                  + 0.0001; // add a small amount so we always add up to at least scrolldistance
    // no less than 1 pixel
    if XScrollStep < 1 then
      XScrollStep:= 1;
  end
  else
    XScrollStep:= 0;

  if YScrollDistance <> 0 then
  begin
    YScrollStep:= Abs( YScrollDistance ) / 10.0
                  + 0.0001; // add a small amount so we always add up to at least scrolldistance

    if YScrollStep < 1 then
      YScrollStep:= 1;
  end
  else
    YScrollStep:= 0;

  while ( XScrolled < Abs( XScrollDistance ) )
        or ( YScrolled < Abs( YScrollDistance ) ) do
  begin
    LastTime:= WinGetCurrentTime( AppHandle );

    NextX:= X + XScrollStep;
    NextY:= Y + YScrollStep;

    XScrollAmount:= trunc( NextX ) - trunc( X );
    YScrollAmount:= trunc( NextY ) - trunc( Y );

    ScrollRect( Control,
                Rect,
                XScrollAmount * sign( XScrollDistance ),
                YScrollAmount * sign( YScrollDistance ),
                BackGroundColor );

    X:= X + XScrollStep;
    Y:= Y + YScrollStep;

    inc( XScrolled, XScrollAmount );
    inc( YScrolled, YScrollAmount );

    // wait at least 5 ms
    while WinGetCurrentTime( AppHandle ) - LastTime < 5 do
      ;
  end;
end;

Initialization
End.
