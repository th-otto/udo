Unit BitmapUtility;

Interface

uses
  Classes, Forms, Graphics;

// Given the source bitmap, creates a mask bitmap for it
// AND masks off areas in the source so that it will draw correctly
// Uses bottom left pixel of the bitmap to choose transparent color.
Procedure CreateAutoMaskedBitmap( Var Source: TBitmap;
                                  Var Mask: TBitmap );

Procedure CreateMaskedBitmap( Var Source: TBitmap;
                              Var Mask: TBitmap;
                              TransparentColor: TColor );

Procedure StoreBitmap( Var CurrentBitmap: TBitmap;
                       Var MaskBitmap: TBitmap;
                       const NewBitmap: TBitmap );

Procedure DrawMaskedBitmap( Bitmap: TBitmap;
                            Mask: TBitmap;
                            Canvas: TCanvas;
                            X,Y: LongInt );

Implementation

uses
  SysUtils;

Procedure CreateAutoMaskedBitmap( Var Source: TBitmap;
                                  Var Mask: TBitmap );
var
  TransparentColor: TColor;
begin
  TransparentColor:= Source.Canvas.Pixels[ 0, 0 ];
  CreateMaskedBitmap( Source,
                      Mask,
                      TransparentColor );
end;

// Given the source bitmap, creates a mask bitmap for it
// AND masks off areas in the source so that it will draw correctly
Procedure CreateMaskedBitmap( Var Source: TBitmap;
                              Var Mask: TBitmap;
                              TransparentColor: TColor );
var
  X, Y: longint;
begin
  Mask.Free;
  Mask:= Source.Copy;

  for y:= 0 to Source.Height - 1 do
    for X:= 0 to Source.Width - 1 do
    begin
      if Source.Canvas.Pixels[ X, Y ] = TransparentColor then
      begin
        Source.Canvas.Pixels[ X, Y ] := clBlack;
        Mask.Canvas.Pixels[ X, Y ]:= clWhite;
      end
      else
        Mask.Canvas.Pixels[ X, Y ] := clBlack;
    end;
end;

Procedure StoreBitmap( Var CurrentBitmap: TBitmap;
                       Var MaskBitmap: TBitmap;
                       const NewBitmap: TBitmap );
begin
  if NewBitmap = nil then
  begin
    CurrentBitmap.Free;
    CurrentBitmap:= nil;
    MaskBitmap.Free;
    MaskBitmap:= nil;
  end
  else
  begin
    if CurrentBitmap = nil then
      CurrentBitmap:= TBitmap.Create;

    CurrentBitmap.LoadFromBitmap( NewBitmap );
    CreateAutoMaskedBitmap( CurrentBitmap, MaskBitmap );
  end;
end;

Procedure DrawMaskedBitmap( Bitmap: TBitmap;
                            Mask: TBitmap;
                            Canvas: TCanvas;
                            X,Y: LongInt );
Var
  Source, Dest: TRect;
Begin
  If Bitmap = Nil Then
    exit;

  Source.Left:= 0;
  Source.Bottom:= 0;
  Dest.Left:= X;
  Dest.Bottom:= Y;

  if ( Mask.Width <> Bitmap.Width )
    or ( Mask.Height <> Bitmap.Height ) then
    raise Exception.Create( 'DrawMaskedBitmap: mask dimensions do not match bitmap' );

  Source.Right:= Mask.Width;
  Source.Top:= Mask.Height;
  Dest.Right:= Dest.Left + Mask.Width;
  Dest.Top:= Dest.Bottom + Mask.Height;

  If Mask <> Nil Then
    Mask.Canvas.BitBlt( Canvas, Dest, Source, cmSrcAnd, bitfIgnore );

  If Mask<>Nil Then
    Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcPaint,bitfIgnore)
  Else
    Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcCopy,bitfIgnore);
End;

Initialization
End.
