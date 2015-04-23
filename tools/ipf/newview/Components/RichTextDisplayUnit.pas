Unit RichTextDisplayUnit;

Interface

uses
  Classes,
  CanvasFontManager,
  RichTextStyleUnit, RichTextLayoutUnit;

// Selection start and end should both be nil if no selection is to be applied
Procedure DrawRichTextLayout( const FontManager: TCanvasFontManager;
                              const Layout: TRichTextLayout;
                              const SelectionStart: PChar;
                              const SelectionEnd: PChar;
                              const StartLine: longint;
                              const EndLine: longint;
                              const StartPoint: TPoint );

// Print as much of the given layout as will fit on the page,
// starting at StartY and StartLine
// EndY is set to the final Y output position used + 1.
// EndLine is set to the last line printed + 1
Procedure PrintRichTextLayout( const FontManager: TCanvasFontManager;
                               const Layout: TRichTextLayout;
                               const StartLine: longint;
                               var EndLine: longint;
                               const StartY: longint;
                               var EndY: longint );

Implementation

uses
  SysUtils,
  Forms, Graphics,
  ACLString, ACLUtility,
  RichTextDocumentUnit;

// For the given point in the text, update selected if the point
// is at start or end of selection
// Returns true if changed
function SelectionChange( P: PChar;
                          SelectionStart: PChar;
                          SelectionEnd: PChar;
                          var NextSelected: boolean ): boolean;
begin
  Result := false;
  if P = SelectionStart then
  begin
    Result := true;
    if SelectionStart < SelectionEnd then
      // reached start of selection
      NextSelected := true
    else
      // reached end
      NextSelected := false;
  end
  else if P = SelectionEnd then
  begin
    Result := true;
    if SelectionStart < SelectionEnd then
      // reached end of selection
      NextSelected := false
    else
      // reached start
      NextSelected := true;
  end;
end;

function InvertRGB( Arg: TColor ): TColor;
begin
  Result := SysColorToRGB( Arg ); // in case it's a system color e.g. button face
  Result := Result xor $ffffff; // now invert the RGB components
end;

// Draw a string at the given location with given color/selected state
Procedure DrawRichTextString( FontManager: TCanvasFontManager;
                              Var X: longint;
                              Y: longint;
                              S: PChar;
                              Len: longint;
                              Selected: Boolean;
                              PenColor: TColor;
                              BackColor: TColor );
var
  Point: TPoint;
begin
  if Len = 0 then
    exit;

  Point.X := X;
  Point.Y := Y;
{  if FDebug then
  begin
    // generate a random dark color
    Canvas.Brush.Color := random( 191 ) * 65536 //r
                         + random( 191 ) * 256 //g
                         + random( 191 );      //b
    Canvas.Pen.Color := clWhite;
  end
  else}

  if Selected then
  begin
    FontManager.Canvas.Brush.Color := InvertRGB( BackColor );
    FontManager.Canvas.Pen.Color := InvertRGB( PenColor );
  end
  else
  begin
    FontManager.Canvas.Brush.Color := BackColor;
    FontManager.Canvas.Pen.Color := PenColor;
  end;
  FontManager.DrawString( Point, Len, S );
  X := Point.X;
end;

var
  // global, so that we don't reallocate every drawline
  StringToDraw: TAString = nil;

// Draw the specified line at the specified
// (physical) location
Procedure DrawRichTextLine( FontManager: TCanvasFontManager;
                            Layout: TRichTextLayout;
                            SelectionStart: PChar;
                            SelectionEnd: PChar;

                            Line: TLayoutLine;
                            Start: TPoint );
var
  X, Y: longint;
  Element: TTextElement;
  StartedDrawing: boolean;
  Style: TTextDrawStyle;
  P: PChar;
  NextP: PChar;
  EndP: PChar;

  BitmapIndex: longint;
  Bitmap: TBitmap;

  BitmapRect: TRect;

  TextBlockStart: PChar;

  Selected: boolean;
  NextSelected: boolean;

  NewMarginX: longint;

  procedure DrawTextBlock;
  var
    PhysX: longint;
  begin
    PhysX := X div FontWidthPrecisionFactor;

    DrawRichTextString( FontManager,
                        PhysX,
                        Y,
                        StringToDraw.AsPChar,
                        StringToDraw.Length,
                        Selected,
                        Style.Color,
                        Style.BackgroundColor );
    X := PhysX * FontWidthPrecisionFactor;
    StringToDraw.AssignString( '' );
  end;


begin
  P := Line.Text;
  EndP := Line.Text + Line.Length;

  if P = EndP then
  begin
    // Empty line
    exit;
  end;

  Selected := false;
  if SelectionStart <= Line.Text then
    // selection start is above.
    Selected := true;
  if SelectionEnd <= Line.Text then
    // selection end is above.
    Selected := not Selected;

  if StringToDraw = nil then
    StringToDraw := TAString.Create;

  Style := Line.Style;
  FontManager.SetFont( Style.Font );
  StartedDrawing := false;

  TextBlockStart := P;

  Y := Start.Y + Line.MaxDescender;

  while P < EndP do
  begin
    Element := ExtractNextTextElement( P, NextP );

    if SelectionChange( P,
                        SelectionStart,
                        SelectionEnd,
                        NextSelected ) then
    begin
      DrawTextBlock;
      TextBlockStart := P;
      Selected := NextSelected;
    end;

    case Element.ElementType of
      teWordBreak,
      teText,
      teImage:
      begin
        if not StartedDrawing then
        begin
          // we haven't yet started drawing:
          // so work out alignment
          X := Start.X * FontWidthPrecisionFactor
               + Layout.GetStartX( Style, Line );
          StartedDrawing := true;
        end;

        // Now do the drawing
        if Element.ElementType = teImage then
        begin
          DrawTextBlock;
          TextBlockStart := NextP;

          try
            BitmapIndex := StrToInt( Element.Tag.Arguments );
          except
            BitmapIndex := -1;
          end;
          if Layout.IsValidBitmapIndex( BitmapIndex ) then
          begin
            Bitmap := Layout.Images.GetBitmapReference( BitmapIndex );

            BitmapRect.Left := X div FontWidthPrecisionFactor;
            BitmapRect.Bottom := Start.Y;
            BitmapRect.Right := BitmapRect.Left
                                + Bitmap.Width
                                  * Layout.HorizontalImageScale;
            BitmapRect.Top := BitmapRect.Bottom
                              + Bitmap.Height
                                * Layout.VerticalImageScale;;

            Bitmap.Draw( FontManager.Canvas,
                         BitmapRect );


            inc( X,
                 trunc( Bitmap.Width
                        * FontWidthPrecisionFactor
                        * Layout.HorizontalImageScale ) );
          end;
        end
        else
        begin
          // character (or word break)
          // build up the successive characters...
          StringToDraw.AddString( Element.Character );
        end;
      end;

      teStyle:
      begin
        DrawTextBlock;
        TextBlockStart := NextP;

        if     ( Element.Tag.TagType = ttItalicOff )
           and ( faItalic in Style.Font.Attributes )
           and ( not FontManager.IsFixed )
           then
          // end of italic; add a space
          inc( X, FontManager.CharWidth( ' ' )  );

        Layout.PerformStyleTag( Element.Tag,
                                Style,
                                X );
        NewMarginX := ( Start.X + Style.LeftMargin ) * FontWidthPrecisionFactor;
        if NewMarginX > X then
        begin
          //skip across...
          X := NewMarginX;
        end;
      end;
    end;
    P := NextP;
  end;

  DrawTextBlock;
end;

Procedure DrawRichTextLayout( const FontManager: TCanvasFontManager;
                              const Layout: TRichTextLayout;
                              const SelectionStart: PChar;
                              const SelectionEnd: PChar;
                              const StartLine: longint;
                              const EndLine: longint;
                              const StartPoint: TPoint );
Var
  Line: TLayoutLine;
  LineIndex: longint;

  Y: longint;

  BottomOfLine: longint;
begin
  assert( StartLine >= 0 );
  assert( StartLine <= Layout.FNumLines );
  assert( EndLine >= 0 );
  assert( EndLine <= Layout.FNumLines );
  assert( StartLine <= EndLine );

  if Layout.FNumLines = 0 then
    // no text to draw
    exit;

  Y := StartPoint.Y
      - Layout.FRichTextSettings.Margins.Top;

  LineIndex := 0;

  repeat
    Line := Layout.FLines[ LineIndex ];
    BottomOfLine := Y - Line.Height + 1; // bottom pixel row is top - height + 1

    if // the line is in the range to be drawn
           ( LineIndex >= StartLine )
       and ( LineIndex <= EndLine )

       // and the line is within the cliprect
       and ( BottomOfLine <= FontManager.Canvas.ClipRect.Top )
       and ( Y            >  FontManager.Canvas.ClipRect.Bottom ) then
    begin
      // draw it. First decided whether selection is started or not.
      DrawRichTextLine( FontManager,
                        Layout,
                        SelectionStart,
                        SelectionEnd,
                        Line,
                        Point( StartPoint.X,
                               BottomOfLine ) );

    end;
    dec( Y, Line.Height );

    if Y < 0 then
      // past bottom of output canvas
      break;

    inc( LineIndex );

    if LineIndex >= Layout.FNumLines then
      // end of text
      break;

  until false;

End;

Procedure PrintRichTextLayout( const FontManager: TCanvasFontManager;
                               const Layout: TRichTextLayout;
                               const StartLine: longint;
                               var EndLine: longint;
                               const StartY: longint;
                               var EndY: longint );
Var
  Selected: boolean;
  Line: TLayoutLine;
  LineIndex: longint;

  Y: longint;

  BottomOfLine: longint;

  LinesPrinted: longint;
begin
  assert( StartLine >= 0 );
  assert( StartLine <= Layout.FNumLines );

  if Layout.FNumLines = 0 then
    // no text to draw
    exit;

  Y := StartY;
//       - Layout.FRichTextSettings.Margins.Top;

  Selected := false; // it's not going to change.

  LinesPrinted := 0;

  LineIndex := StartLine;

  repeat
    Line := Layout.FLines[ LineIndex ];
    BottomOfLine := Y - Line.Height + 1; // bottom pixel row is top - height + 1

    if BottomOfLine < Layout.FRichTextSettings.Margins.Bottom then
      // past bottom of page (less margin)
      if LinesPrinted > 0 then
        // stop, as long as we've printed at least 1 line
        break;

    // draw it
    DrawRichTextLine( FontManager,
                      Layout,
                      nil,
                      nil,
                      Line,
                      Point( 0,
                             BottomOfLine ) );

    dec( Y, Line.Height );

    inc( LinesPrinted );

    inc( LineIndex );

    if LineIndex >= Layout.FNumLines then
      // end of text
      break;

  until false;

  EndY := Y;
  EndLine := LineIndex;
End;

Initialization
End.
