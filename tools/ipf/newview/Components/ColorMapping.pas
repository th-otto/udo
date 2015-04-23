Unit ColorMapping;

Interface

Uses
  Classes, Graphics;

// IN these functions the following definitions apply:
// Hue: 0 - 1535
//   red = 0  green = 512  blue = 1024
// Saturation: 0 - 1
//   grey (no color) = 0  max color = 1
// Value: 0 - 1
//   black =0   max brightness = 1
Procedure RGBToHSV( C: TColor;
                    Var Hue: longint;
                    Var Saturation, Value: real );

Function HSVToRGB( const H: longint; const S, V: real ): TColor;

Function Min( a, b: longint ): longint;

Function Max( a, b: longint ): longint;

Implementation

Function Min( a, b: longint ): longint;
Begin
  if a>b then
    Result:=b
  else
    Result:=a;
End;

Function Max( a, b: longint ): longint;
Begin
  if a>b then
    Result:=a
  else
    Result:=b;
End;

Procedure RGBToHSV( C: TColor;
                    Var Hue: longint;
                    Var Saturation, Value: real );
Var
  r,g,b: longint;
  hi, lo: longint;
  d: longint;
Begin
  r:= (c div 65536) and 255;
  g:= (c div 256) and 255;
  b:=  c and 255;
  hi:= max( max( r, g ), b );
  lo:= min( min( r, g ), b );
  d:= hi-lo;
  Value:= hi/256;
  if d>0 then
  begin
    if r=hi then
      Hue:= round( 256*(g-b)/d )
    else if g=hi then
      Hue:= round( 512+256*(b-r)/d )
    else
      Hue:= round( 1024+256*(r-g)/d );
    if Hue<0 then
      Hue:= Hue+1536;
  end
  else
    Hue:= 0; // doesn't matter (grey: Sat = 0)

  if hi>0 then
    Saturation:= d/hi
  else
    Saturation:= 0; // doesn't matter (black: Val = 0
End;

Function HSVToRGB( const H: longint; const S, V: real ):TColor;
Var
  r,g,b: longint;
Begin
  if ( h<0 ) or ( h>1535 )
     or ( S<0 ) or ( S>1 )
     or ( V<0 ) or ( V>1 ) then
  begin
    // Invalid value, use black
    Result:= 0;
    exit;
  end;
  case h div 256 of
  0:
   begin
    r:= 255;
    g:= h;
    b:= 0;
   end;
  1:
   begin
    r:= 511-h;
    g:= 255;
    b:= 0;
   end;
  2:
   begin
    r:= 0;
    g:= 255;
    b:= h-512;
   end;
  3:
   begin
    r:= 0;
    g:= 1023-h;
    b:= 255;
   end;
  4:
   begin
    r:= h-1024;
    g:= 0;
    b:= 255;
   end;
  5:
   begin
    r:= 255;
    g:= 0;
    b:= 1535-h;
   end;
  end;
  r:= round( V*( 255- S*(255-r) ) );
  g:= round( V*( 255- S*(255-g) ) );
  b:= round( V*( 255- S*(255-b) ) );
  Result:= b + 256*g + 65536*r;
end;

Initialization
End.
