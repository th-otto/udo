{ ********************************* }
{ *       Sibyl Component         * }
{ *            TLed               * }
{ *                               * }
{ *   written by Michael Kroll    * }
{ *          25.11.1996           * }
{ *                               * }
{ *      Fido: 2:2448/136.16      * }
{ ********************************* }

Unit LED;

InterFace

{$r Led}

Uses
  Classes, StdCtrls, Graphics, Forms;

{$M+}

Type
  TLedColor = (lRed, lGreen, lYellow, lBlue);

{$M-}

Type
  TLed = Class (TControl)
  Private
    FCondition: Boolean;
    FLedColor: TLedColor;
    FBitmaps: Array [0..7] of TBitmap;

    Procedure SetCondition (Condition: Boolean);
    Procedure SetLedColor (LedColor: TLedColor);

  Public
    Destructor Destroy; Override;

    Procedure Redraw (Const Rec: TRect); Override;
    Procedure SetupComponent; Override;
    Procedure Show; Override;

  Published
    Property LedCondition: Boolean Read FCondition Write SetCondition;
    Property LedColor: TLedColor Read FLedColor Write SetLedColor;
  End;

Implementation

Destructor TLed.Destroy;
Var
  I: Integer;
Begin
  For I := 0 to 7 do FBitMaps[I].Free;
  Inherited Destroy;
End;

Procedure TLed.SetCondition (Condition: Boolean);
Begin
  FCondition := Condition;
  Invalidate;
End;

Procedure TLed.SetLedColor (LedColor: TLedColor);
Begin
  FLedColor := LedColor;
  Invalidate;
End;

Procedure TLed.SetupComponent;
Begin
  Inherited SetupComponent;
  Caption := 'Led';
  Name := Caption;
  Width := 15;
  Height := 15;
  FBitMaps[0].Create;
  FBitmaps[0].LoadFromResourceName ('RedOn');
  FBitMaps[1].Create;
  FBitmaps[1].LoadFromResourceName ('RedOff');
  FBitMaps[2].Create;
  FBitmaps[2].LoadFromResourceName ('GrOn');
  FBitMaps[3].Create;
  FBitmaps[3].LoadFromResourceName ('GrOff');
  FBitMaps[4].Create;
  FBitmaps[4].LoadFromResourceName ('YwOn');
  FBitMaps[5].Create;
  FBitmaps[5].LoadFromResourceName ('YwOff');
  FBitMaps[6].Create;
  FBitmaps[6].LoadFromResourceName ('BlOn');
  FBitMaps[7].Create;
  FBitmaps[7].LoadFromResourceName ('BlOff');
End;

Procedure TLed.Show;
Begin
  Inherited Show;
  If FCondition = True then
  Begin
    If FLedColor = lRed then FBitMaps[0].RealizePalette (Canvas);
    If FLedColor = lGreen then FBitMaps[2].RealizePalette (Canvas);
    If FLedColor = lYellow then FBitMaps[4].RealizePalette (Canvas);
    If FLedColor = lBlue then FBitMaps[6].RealizePalette (Canvas);
  End
  Else If FCondition = False then
  Begin
    If FLedColor = lRed then FBitMaps[1].RealizePalette (Canvas);
    If FLedColor = lGreen then FBitMaps[3].RealizePalette (Canvas);
    If FLedColor = lYellow then FBitMaps[5].RealizePalette (Canvas);
    If FLedColor = lBlue then FBitMaps[7].RealizePalette (Canvas);
  End;
End;

Procedure TLed.Redraw;
Begin
  If FCondition = True then
  Begin
    If FLedColor = lRed then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[0]);
    If FLedColor = lGreen then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[2]);
    If FLedColor = lYellow then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[4]);
    If FLedColor = lBlue then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[6]);
  End
  Else
  Begin
    If FLedColor = lRed then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[1]);
    If FLedColor = lGreen then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[3]);
    If FLedColor = lYellow then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[5]);
    If FLedColor = lBlue then Canvas.StretchDraw (0, 0, Width, Height, FBitmaps[7]);
  End;
End;

Begin
  RegisterClasses ([TLed]);
End.
