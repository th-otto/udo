// Enhanced version of TCoolBar from Sibyl samples
// - Bitmap for first button draws correctly
// - Draws a border line underneath
// - Buttons look better (have black frame, when pressed look sunken, background moves)
// - Button text highlights under mouse (HotColor property)
// - bitmap does not overwrite border of button
// (C) 1998 SpeedSoft

Unit coolbar2;

Interface

Uses Classes,Forms,Graphics,Buttons,StdCtrls,ComCtrls,Dialogs, Messages;

Type
    TCoolSection2=Class(THeaderSection)
      Private
         FImage:LongInt;
         FHotImage:LongInt;
         FDisabledImage:LongInt;
         FDisabled:Boolean;
      Private
         Procedure SetDisabled(NewValue:Boolean);
         Procedure SetImage(NewValue:LongInt);
         Procedure SetHotImage(NewValue:LongInt);
         Procedure SetDisabledImage(NewValue:LongInt);
      Public
         Hint:string;
         Constructor Create(ACollection:TCollection);Override;
         Procedure Assign(Source:TCollectionItem);Override;
      Public
         Property Disabled:Boolean read FDisabled write SetDisabled;
         Property Image:LongInt read FImage write SetImage;
         Property HotImage:LongInt read FHotImage write SetHotImage;
         Property DisabledImage:LongInt read FDisabledImage write SetDisabledImage;
    End;

    TCoolSections2=Class(THeaderSections)
      Protected
         Function GetSection( Index: longint ): TCoolSection2;
      Public
         Procedure SetupComponent;Override;
         Property Items[ Index: Longint ]: TCoolSection2 read GetSection; default;
    End;

    TDrawCoolSectionEvent=Procedure(HeaderControl:THeaderControl;Section:TCoolSection2;
                                    Const rc:TRect;Pressed,Hot,Enabled:Boolean) Of Object;

    TCoolBar2=Class(THeaderControl)
      Private
         FBackgroundBitmap:TBitmap;
         FActiveSection:TCoolSection2;
         FImages:TImageList;
         FFlat:Boolean;
         FBackgroundOffset:LongWord;
         FMouseTimer:TTimer;
         FOnDrawSection:TDrawCoolSectionEvent;
         FHotColor: TColor;
         FShowText: boolean;
         FShowImages: boolean;
      Private
         Procedure EvFMouseTimer(Sender:TObject);
         Procedure SetBackgroundBitmap(NewValue:TBitmap);
         Procedure UpdateHeader(Header:THeaderSection);Override;
         Procedure SetImages(NewValue:TImageList);
         Procedure SetFlat(NewValue:Boolean);
         Procedure SetBackgroundOffset(NewValue:LongWord);
         Function GetSections:TCoolSections2;
         Procedure SetSections(NewValue:TCoolSections2);

         Procedure SetShowText( NewValue: boolean );
         Procedure SetShowImages( NewValue: boolean );

      Protected
         Procedure DrawSection(Section:TCoolSection2;Const rc:TRect;Pressed,Hot,Enabled:Boolean);Virtual;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure Notification( AComponent: TComponent;
                                 Operation:TOperation ); Override;
         Procedure DrawBackground( rec: TRect;
                                   XOffset, YOffset: longint );
      Public
         Procedure SetupComponent;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure EditSections;

         Procedure SetMinConstButtonWidth;
      Published
         Property BackgroundBitmap:TBitmap read FBackgroundBitmap write SetBackgroundBitmap;
         Property BackgroundOffset:LongWord read FBackgroundOffset write SetBackgroundOffset;
         Property Images:TImageList read FImages write SetImages;
         Property Flat:Boolean read FFlat write SetFlat;
         Property Sections:TCoolSections2 Read GetSections Write SetSections;
         Property HotColor: TColor read FHotColor write FHotColor;

         Property ShowText: boolean read FShowText write SetShowText;
         Property ShowImages: boolean read FShowImages write SetShowImages;

      Published
         Property OnDrawSection:TDrawCoolSectionEvent Read FOnDrawSection Write FOnDrawSection;
         Property OnFontChange;
    End;

Implementation

// default bitmap from resource file
// {$R CoolBar2}

exports
  TCoolBar2, 'User', 'Coolbar2.bmp';
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCoolSection2 Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TCoolSection2.Create(ACollection:TCollection);
Begin
     Inherited Create(ACollection);
     FImage:=-1;
     FHotImage:=-1;
     FDisabledImage:=-1;
     AllowSize:= false;
     Width:= 60;
     Alignment:= taCenter;
End;

Procedure TCoolSection2.Assign(Source:TCollectionItem);
Begin
     Inherited Assign(Source);
     If Source Is TCoolSection2 Then
       If Source<>Self Then
     Begin
          FImage:=TCoolSection2(Source).Image;
          FHotImage:=TCoolSection2(Source).HotImage;
          FDisabledImage:=TCoolSection2(Source).DisabledImage;
          FDisabled:=TCoolSection2(Source).Disabled;
     End;
End;

Procedure TCoolSection2.SetDisabled(NewValue:Boolean);
Begin
     If NewValue=FDisabled Then exit;
     FDisabled:=NewValue;
     Changed(False);
End;

Procedure TCoolSection2.SetImage(NewValue:LongInt);
Begin
     If NewValue=FImage Then exit;
     FImage:=NewValue;
     Changed(False);
End;

Procedure TCoolSection2.SetHotImage(NewValue:LongInt);
Begin
     If NewValue=FHotImage Then exit;
     FHotImage:=NewValue;
     Changed(False);
End;

Procedure TCoolSection2.SetDisabledImage(NewValue:LongInt);
Begin
     If NewValue=FDisabledImage Then exit;
     FDisabledImage:=NewValue;
     Changed(False);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCoolSections2 Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCoolSections2.SetupComponent;
Begin
    Inherited SetupComponent;
    Name:='CoolSections';
    ItemClass:=TCoolSection2;
End;

Function TCoolSections2.GetSection( Index: longint ): TCoolSection2;
begin
  Result:= ( inherited Items[ Index ] ) as TCoolSection2;
end;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCoolBar2 Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCoolBar2.SetupComponent;
Begin
     Inherited SetupComponent;

     FBackgroundBitmap := nil;
//     FBackgroundBitmap.Create;
//     FBackgroundBitmap.LoadFromResourceName('Cool');
     FFlat:=True;
     FMouseTimer.Create(Self);
     Include(FMouseTimer.ComponentState, csDetail);
     FMouseTimer.Interval := 50;
     FMouseTimer.OnTimer := EvFMouseTimer;
     Name:='CoolBar';
     SectionsClass:=TCoolSections2;
     FHotColor:= clBlue;
End;

Procedure TCoolBar2.SetFlat(NewValue:Boolean);
Begin
     If NewValue=FFlat Then exit;
     FFlat:=NewValue;
     Invalidate;
End;

Function TCoolBar2.GetSections:TCoolSections2;
Begin
     Result:=TCoolSections2(Inherited Sections);
End;

Procedure TCoolBar2.SetSections(NewValue:TCoolSections2);
Begin
     Inherited Sections:=NewValue;
End;

Procedure TCoolBar2.SetImages(NewValue:TImageList);
Begin
     If NewValue = FImages Then
       exit;
     If FImages<>Nil Then
       FImages.Notification( Self, opRemove );
     FImages:= NewValue;
     If FImages <> Nil Then
       FImages.FreeNotification( Self );
     Invalidate;
End;

Procedure TCoolBar2.SetShowText( NewValue: boolean );
begin
     If NewValue = FShowText Then
       exit;
     FShowText := NewValue;
     Invalidate;
end;

Procedure TCoolBar2.SetShowImages( NewValue: boolean );
begin
     If NewValue = FShowImages Then
       exit;
     FShowImages := NewValue;
     Invalidate;
end;

Procedure TCoolBar2.SetMinConstButtonWidth;
var
  i: longint;
  TextWidth: longint;
  ImageWidth: longint;
  Section: TCoolSection2;
  Bitmap: TBitmap;
  ButtonWidth: longint;
begin
  if Handle = 0 then
    exit;

  ButtonWidth := 0;

  for i := 0 to Sections.Count - 1 do
  begin
    Section := Sections[ i ];

    TextWidth :=  0;

    if FShowText then
      TextWidth := Canvas.TextWidth( Section.Text );

    ImageWidth := 0;

    if     ( FImages <> nil )
       and FShowImages then
    begin
      if Section.Image < FImages.Count then
      begin
        Bitmap := FImages.GetBitmapReference( Section.Image );
        ImageWidth := Bitmap.Width;
      end;
    end;

    if TextWidth > ButtonWidth then
      ButtonWidth := TextWidth;
    if ImageWidth > ButtonWidth then
      ButtonWidth := ImageWidth;
  end;

  inc( ButtonWidth, 8 ); // allow for borders etc

  for i := 0 to Sections.Count - 1 do
  begin
    Section := Sections[ i ];
    Section.Width := ButtonWidth;
  end;

end;

Procedure TCoolBar2.Notification( AComponent: TComponent;
                                  Operation: TOperation );
Begin
     Inherited Notification( AComponent, Operation );

     If Operation = opRemove Then
       If AComponent = FImages Then
         FImages := Nil;
End;


Procedure TCoolBar2.SetBackgroundBitmap(NewValue:TBitmap);
Begin
     If NewValue=FBackgroundBitmap Then exit;
     If FBackgroundBitmap<>Nil Then FBackgroundBitmap.Destroy;
     If NewValue<>Nil Then FBackgroundBitmap:=NewValue.Copy
     Else FBackgroundBitmap:=Nil;
     Invalidate;
End;

Procedure TCoolBar2.SetBackgroundOffset(NewValue:LongWord);
Begin
     If NewValue=FBackgroundOffset Then exit;
     FBackgroundOffset:=NewValue;
     Invalidate;
End;

Procedure TCoolBar2.DrawSection(Section:TCoolSection2;Const rc:TRect;Pressed,Hot,Enabled:Boolean);
Var
   Align:TAlignment;
   S:String;
   CX,CY,CX1,CY1,H,X,Y:LongInt;
   rec:TRect;
   PointsArray:Array[0..5] Of TPoint;
   offs:LongInt;
   Bitmap,Mask:TBitmap;
   bevelrc: TRect;
   bgrc: TRect;

   HaveText: boolean;
   HaveImage: boolean;

   Procedure DrawMasked(Bitmap,Mask:TBitmap;X,Y:LongInt);
   Var Source,Dest:TRect;
   Begin
        If Bitmap=Nil Then exit;
        Source.Left:=0;
        Source.Bottom:=0;
        Dest.Left:=X;
        Dest.Bottom:=Y;

        If Mask<>Nil Then
        Begin
             Source.Right:=Mask.Width;
             Source.Top:=Mask.Height;
             Dest.Top:=Dest.Bottom+Mask.Height;
             Dest.Right:=Dest.Left+Mask.Width;
             Mask.Canvas.BitBlt(Canvas,Dest,Source,cmSrcAnd,bitfIgnore);
        End;

        Source.Right:=Bitmap.Width;
        Source.Top:=Bitmap.Height;
        Dest.Top:=Dest.Bottom+Bitmap.Height;
        Dest.Right:=Dest.Left+Bitmap.Width;
        If Mask<>Nil Then
          Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcPaint,bitfIgnore)
        Else
          Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcCopy,bitfIgnore);

//        Canvas.ExcludeClipRect(Dest);
   End;

   Procedure DestroyIfEmpty( Var Bitmap: TBitmap );
   Begin
     If Bitmap<>Nil Then
     Begin
       If Bitmap.Empty Then
       begin
         Bitmap.Destroy;
         Bitmap := Nil;
       End;
     End;
   End;

Begin
     Align:=section.Alignment;
     S:=section.Text;

     HaveText :=     ( S <> '' )
                 and FShowText;
     If not HaveText Then
     Begin
          CX:=0;
          CY:=0;
     End
     Else Canvas.GetTextExtent(S,CX,CY);

     // First get or generate bitmap to draw.

     Bitmap := Nil;
     Mask := Nil;

     If     ( FImages <> Nil )
        and FShowImages Then
     Begin
       If FImages.Count>0 Then
       Begin
          If not Enabled Then
          Begin
              If Section.DisabledImage>=0 Then
              begin
                If FImages.Count>Section.DisabledImage Then
                Begin
                     Bitmap := TBitmap.Create;
                     FImages.GetBitmap(Section.DisabledImage,Bitmap);
                     Mask  := TBitmap.Create;
                     Images.GetMask(Section.DisabledImage,Mask);
                End;
              end
              else
              begin
                     Bitmap := TBitmap.Create;
                     FImages.GetBitmap(Section.Image,Bitmap);
                     Mask  := TBitmap.Create;
                     FImages.GetMask(Section.Image,Mask);
                     Y:= 0;
                     while Y < Mask.Height do
                     begin
                       X:= 0;
                       if ( Y mod 2 ) = 1 then
                         X:= 1;
                       while X < Mask.Width do
                       begin
                         Mask.Canvas.Pixels[ X, Y ]:= clBlack;
                         Bitmap.Canvas.Pixels[ X, Y ]:= clBlack;
                         inc( X, 2 );
                       end;
                       inc( Y, 1 );
                     end;
              end;
          End
          Else If Hot Then
          Begin
              If Section.HotImage>=0 Then
              If Section.HotImage < FImages.Count Then
              Begin
                   Bitmap := TBitmap.Create;
                   FImages.GetBitmap(Section.HotImage,Bitmap);
                   Mask := TBitmap.Create;
                   FImages.GetMask(Section.HotImage,Mask);
              End;
          End;

          DestroyIfEmpty( Bitmap );
          DestroyIfEmpty( Mask );

          If Bitmap=Nil Then
          Begin
               If Section.Image>=0 Then
               If FImages.Count>Section.Image Then
               Begin
                    Bitmap := TBitmap.Create;
                    FImages.GetBitmap(Section.Image,Bitmap);
                    Mask := TBitmap.Create;
                    FImages.GetMask(Section.Image,Mask);
               End;
          End;

          DestroyIfEmpty( Bitmap );
          DestroyIfEmpty( Mask );
       End;
     End;

     CX1:=CX;
     CY1:=CY;

     HaveImage := Bitmap <> Nil;

     If HaveImage Then
     Begin
          If Align=taCenter Then
            inc(CY1,Bitmap.Height)
          Else
            inc(CX1,Bitmap.Width);

          If HaveText Then
            // space between
            If Align=taCenter Then
              inc(CY1,3)
            Else
              inc(CX1,3);
     End;

     Case Align Of
        taLeftJustify:
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX1) Div 2);
        End;
        taRightJustify:
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX1) Div 2);
             If Bitmap<>Nil Then inc(rec.Left,Bitmap.Width);
        End
        Else //taCenter
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX) Div 2);
        End;
     End; //Case

     If rec.Left<rc.Left+3 Then rec.Left:=rc.Left+3;

     H:=rc.Top-rc.Bottom;
     rec.Bottom:=rc.Bottom+((H-CY1) Div 2);
     If rec.Bottom<rc.Bottom+3 Then rec.Bottom:=rc.Bottom+3;
     rec.Right:=rec.Left+CX-1;
     rec.Top:=rec.Bottom+CY-1;

     // Draw background
     bgrc:= rc;
     If ((not Flat)Or(Hot And Enabled)) Then
       InflateRect( bgrc,
                    - ( 1 + BevelWidth ),
                    - ( 1 + BevelWidth ) );

     if Pressed then
       DrawBackground( bgrc, 1, -1 )
     else
       DrawBackground( bgrc, 0, 0 );

     // Draw Bitmap
     If Bitmap<>Nil Then
     Begin
        H:=rc.Top-rc.Bottom;
        Y:=rc.Bottom+((H-CY1) Div 2);
        If Y<rc.Bottom+3 Then Y:=rc.Bottom+3;

        Canvas.Pen.Color:= clBlack;
        Case Align Of
            taLeftJustify:
            Begin
                 DrawMasked(Bitmap,Mask,rec.Right+3,Y);
            End;
            taRightJustify:
            Begin
                 DrawMasked(Bitmap,Mask,rec.Left-3-Bitmap.Width,Y);
            End;
            Else //taCenter
            Begin
                 H:=rc.Right-rc.Left;
                 X:=rc.Left+((H-Bitmap.Width) Div 2);
                 If X<rc.Left+3 Then X:=rc.Left+3;
                 if Pressed then
                 begin
                   inc( X );
                   dec( Y );
                 end;
                 if HaveText then
                   inc( Y, 3 );
                 DrawMasked(Bitmap,Mask,X,Y+CY);
            End;
         End; //Case

         Bitmap.Destroy;
         If Mask<>Nil Then Mask.Destroy;
     End;

     // Draw text
     If     ( S <> '' )
        And FShowText Then
     Begin
        Canvas.Brush.Mode:=bmTransparent;
        If not Enabled Then
          Canvas.Pen.Color:=clDkGray
        Else if Hot then
          Canvas.Pen.Color:= FHotColor
        else
          Canvas.Pen.Color:=PenColor;

        if Pressed then
          Canvas.TextOut(rec.Left+1,rec.Bottom-1,S)
        else
          Canvas.TextOut(rec.Left,rec.Bottom,S);
        Canvas.Brush.Mode:=bmOpaque;

//        Canvas.ExcludeClipRect(rec);
     End;

     If ((not Flat)Or(Hot And Enabled)) Then
     Begin
        // draw button outline
         Canvas.Pen.Color:= clBlack;
         Canvas.Rectangle( rc );
         bevelrc:= rc;
         InflateRect( bevelrc, -1, -1 );
         If BevelWidth > 1 Then
         Begin
              offs := BevelWidth-1;
              PointsArray[0] := Point(bevelrc.Left,bevelrc.Bottom);
              PointsArray[1] := Point(bevelrc.Left+offs,bevelrc.Bottom+offs);
              PointsArray[2] := Point(bevelrc.Left+offs,bevelrc.Top-offs);
              PointsArray[3] := Point(bevelrc.Right-offs,bevelrc.Top-offs);
              PointsArray[4] := Point(bevelrc.Right,bevelrc.Top);
              PointsArray[5] := Point(bevelrc.Left,bevelrc.Top);
              if Pressed then
                Canvas.Pen.color := clDkGray
              else
                Canvas.Pen.color := clWhite;
              Canvas.Polygon(PointsArray);
              PointsArray[2] := Point(bevelrc.Right-offs,bevelrc.Bottom+offs);
              PointsArray[3] := Point(bevelrc.Right-offs,bevelrc.Top-offs);
              PointsArray[4] := Point(bevelrc.Right,bevelrc.Top);
              PointsArray[5] := Point(bevelrc.Right,bevelrc.Bottom);
              if Pressed then
                Canvas.Pen.color := clWhite
              else
                Canvas.Pen.color := clDkGray;
              Canvas.Polygon(PointsArray);
              Canvas.Pen.color:=PenColor;
         End
         Else
           if Pressed then
             Canvas.ShadowedBorder(bevelrc,clDkGray,clWhite)
           else
             Canvas.ShadowedBorder(bevelrc,clWhite,clDkGray);
     End;
End;

Type
    PHeaderItem=^THeaderItem;
    THeaderItem=Record
        Image:LongInt;
        HotImage:LongInt;
        DisabledImage:LongInt;
        Disabled:Boolean;
    End;

Const rnCoolHeaders='rnCoolHeaders';

Procedure TCoolBar2.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PHeaderItem;
   section:TCoolSection2;
   T:LongInt;
Begin
     If ResName = rnCoolHeaders Then
     Begin
          Count:=@Data;
          Items:=@Data;
          Inc(Items,4);
          For T:=1 To Count^ Do
          Begin
               Section:=TCoolSection2(Sections[t-1]);
               section.Image:=Items^.Image;
               section.HotImage:=Items^.HotImage;
               section.DisabledImage:=Items^.DisabledImage;
               section.Disabled:=Items^.Disabled;
               Inc(Items,SizeOf(THeaderItem));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TCoolBar2.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:THeaderItem;
    section:TCoolSection2;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If Sections<>Nil Then If Sections.Count>0 Then
     Begin
          MemStream.Create;
          T:=Sections.Count;
          MemStream.Write(T,4);
          For T:=0 To Sections.Count-1 Do
          Begin
               section:=TCoolSection2(Sections[T]);
               Item.Image:=section.Image;
               Item.HotImage:=section.HotImage;
               Item.DisabledImage:=section.DisabledImage;
               Item.Disabled:=section.Disabled;
               MemStream.Write(Item,SizeOf(THeaderItem));
          End;

          Result:=Stream.NewResourceEntry(rnCoolHeaders,MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;

Procedure TCoolbar2.DrawBackground( rec: TRect;
                                    XOffset, YOffset: longint );
var
  X: longint;
  Y: longint;
  DrawRect: TRect;
  SourceRect: TRect;
  BlockWidth: longint;
  BlockHeight: longint;
  BitmapX: longint;
  BitmapY: longint;
begin
  If FBackgroundBitmap=Nil Then
  begin
    Canvas.FillRect( rec, Color );
    exit;
  end;

  Y:= rec.Bottom;
  While Y<=rec.Top Do
  Begin
    BitmapY:= ( Y - YOffset ) mod FBackGroundBitmap.Height;
    if BitmapY < 0 then
      BitmapY:= FBackGroundBitmap.Height + BitmapY;

    BlockHeight:= FBackgroundBitmap.Height - BitmapY;
    if Y + BlockHeight > rec.Top then
      BlockHeight:= rec.Top - Y + 1;

    X:= rec.Left;
    While X<=rec.Right Do
    Begin
      BitmapX:= ( X - XOffset ) mod FBackgroundBitmap.Width;
      if BitmapX < 0 then
        BitmapX:= FBackgroundBitmap.Width + BitmapX;

      BlockWidth:= FBackgroundBitmap.Width - BitmapX;
      if X + BlockWidth > rec.Right then
        BlockWidth:= rec.Right - X + 1;

      DrawRect.Left:= X;
      DrawRect.Right:= X + BlockWidth;
      DrawRect.Bottom:= Y;
      DrawRect.Top:= Y + BlockHeight;

      SourceRect.Left:= BitmapX;
      SourceRect.Right:= BitmapX + BlockWidth;
      SourceRect.Bottom:= BitmapY;
      SourceRect.Top:= BitmapY + BlockHeight;

      FBackgroundBitmap.PartialDraw( Canvas,
                                     SourceRect,
                                     DrawRect );
      inc( X, BlockWidth );
    End;
    inc( Y, BlockHeight );
  End;
end;

Procedure TCoolBar2.Redraw(Const rec:TRect);
Var rc,rc2:TRect;
    FSections:TCoolSections2;
    Section:TCoolSection2;
    IsPressed:Boolean;
    t:LongInt;
Begin
    Canvas.ClipRect:=rec;

    Canvas.Pen.Color:= clDkGray;
    Canvas.Line( 0, 0, Width -1, 0 );
//    Canvas.Pen.Color:= cl3dLight;
//    Canvas.Line( 0, 0, Width -1, 0 );

    FSections:=TCoolSections2(Sections);
    rc:=ClientRect;
    Inc(rc.Bottom,1);
    For T:=0 To FSections.Count-1 Do
    Begin
          Section:=TCoolSection2(FSections[T]);
          rc.Right:=rc.Left+section.Width;
          If rc.Right>Width-1 Then rc.Right:=Width-1;

          IsPressed:=Section=ClickSection;

          rc2:=Forms.IntersectRect(rc,rec);
          If Not Forms.IsRectEmpty(rc2) Then
          Begin
               Canvas.ClipRect:=rc2;

               If ( Section.Style=hsOwnerDraw )
                  and ( OnDrawSection<>Nil ) Then
                 OnDrawSection(Self,section,rc,IsPressed,Section=FActiveSection,Section.Disabled=False)
               Else
                 DrawSection(section,rc,IsPressed,Section=FActiveSection,Section.Disabled=False);
          End;

          // draw space between this button and next
          rc2:= rc;
          rc2.Left:= rc.Right + 1;
          rc2.Right:= rc2.Left + Spacing - 1;
          rc2:=Forms.IntersectRect(rc2,rec);

          If Not Forms.IsRectEmpty(rc2) Then
          Begin
            Canvas.ClipRect:=rc2;
            DrawBackGround( rc2, 0, 0 );
          end;

          Inc(rc.Left,Section.Width+Spacing+1);
     End;

     rc.Right:= Width-1;
     rc2:=Forms.IntersectRect(rc,rec);
     If Not Forms.IsRectEmpty(rc2) Then
     Begin
       inc(rc2.Right);
       Canvas.ClipRect:=rc2;
       DrawBackground( rc, 0, 0 );
     end;
     Canvas.DeleteClipRegion;
End;

Procedure TCoolBar2.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:TCoolSection2;
    FSections:TCoolSections2;
Begin
     TControl.MouseDown(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     FSections:=TCoolSections2(Sections);
     For T:=0 To FSections.Count-1 Do
     Begin
          section:=TCoolSection2(FSections[T]);
          If ((section.AllowSize)And(X>section.Right-2)And(X<section.Right+2)) Then
          Begin
               Inherited MouseDown(Button,ShiftState,X,Y);
               exit;
          End;
     End;

     If Designed Then Exit;

     //Test Press
     Section:=TCoolSection2(GetMouseHeader(X,Y));
     If Section<>Nil Then If section.AllowClick Then If not Section.Disabled Then
       Inherited MouseDown(Button,ShiftState,X,Y);
End;

Procedure TCoolBar2.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var section:TCoolSection2;
Begin
     If Button=mbLeft Then
     Begin
          Section:=TCoolSection2(GetMouseHeader(X,Y));
          If Section<>Nil Then If section.AllowClick Then If not Section.Disabled Then
            Inherited MouseDblClick(Button,ShiftState,X,Y);
     End
     Else Inherited MouseDblClick(Button,ShiftState,X,Y);
End;

Procedure TCoolBar2.UpdateHeader(Header:THeaderSection);
Var T:LongInt;
    rc:TRect;
    FSections:TCoolSections2;
Begin
     //Get Rectangle For the Panel
     rc:=ClientRect;
     FSections:=TCoolSections2(Sections);
     For T:=0 To FSections.Count-1 Do
     Begin
          If FSections[T]=Header Then break
          Else Inc(rc.Left,FSections[T].Width+Spacing+1);
     End;

     rc.Right:=rc.Left+Header.Width+1;
     If not Flat Then InflateRect(rc,-BevelWidth*2,-BevelWidth*2);
     InvalidateRect(rc);
     Update;
End;


Procedure TCoolBar2.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var
     OldActiveSection:TCoolSection2;
Begin
     FMouseTimer.Stop;

     OldActiveSection:=FActiveSection;
     FActiveSection:=TCoolSection2(GetMouseHeader(X,Y));
     
     if FActiveSection <> nil Then
          if FActiveSection.Disabled Then
               FActiveSection := nil;

     If FActiveSection<>OldActiveSection Then
     Begin
          If FActiveSection <> nil Then
               Hint := FActiveSection.Hint
          Else
               Hint := '';
     End;

     Inherited MouseMove(ShiftState,X,Y);

     If FActiveSection<>OldActiveSection Then
     Begin
          If OldActiveSection<>Nil Then UpdateHeader(OldActiveSection);
          If FActiveSection<>Nil Then UpdateHeader(FActiveSection);
     End;

     If FFlat Then FMouseTimer.Start;
End;


Procedure TCoolBar2.EvFMouseTimer(Sender:TObject);
Var
  AControl:TControl;
  OldActiveSection:TCoolSection2;
Begin
  FMouseTimer.Stop;

  AControl := Screen.GetControlFromPoint(Screen.MousePos);

  If AControl <> Self Then
  Begin
    OldActiveSection:=FActiveSection;
    FActiveSection := Nil;
    If OldActiveSection<>Nil Then UpdateHeader(OldActiveSection);
  End
  Else FMouseTimer.Start;
End;

Procedure TCoolBar2.EditSections;
begin
  CallClassPropertyEditor( FSections );
end;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Version 2.0                                                         บ
บ                                                                           บ
บ This section: TCoolSectionsPropertyEditor Class implementation            บ
บ                                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
  TCoolSectionsPropertyEditor=Class(TClassPropertyEditor)
    Public
      Function Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;Override;
  End;

  TCoolSectionsPropEditDialog=Class(TDialog)
    Private
      FSections:TCoolSections2;
      FListBox:TListBox;
      FText:TEdit;
      FWidth:TEdit;
      FMinWidth,FMaxWidth:TEdit;
      FImage,FHotImage,FDisabledImage:TEdit;
      FStyle:TComboBox;
      FAlignment:TComboBox;
      FAllowClick:TCheckBox;
      FAllowSize:TCheckBox;
      FDisabled:TCheckBox;
      FCurrentSection:TCoolSection2;
    Protected
      Function GetCurrentSection: TCoolSection2;
      Procedure SetupComponent;Override;
      Procedure RefreshListBox;
      Procedure NewClicked(Sender:TObject);
      Procedure DeleteClicked(Sender:TObject);
      Procedure UpdateClicked(Sender:TObject);
      Procedure MoveUpClicked(Sender:TObject);
      Procedure MoveDownClicked(Sender:TObject);
      Procedure ListItemFocus(Sender:TObject;Index:LongInt);
      Procedure SetupShow; override;
      Procedure StoreItem;
  End;

Function TCoolSectionsPropEditDialog.GetCurrentSection: TCoolSection2;
begin
  Result := FCurrentSection;
end;

{$HINTS OFF}

Procedure TCoolSectionsPropEditDialog.UpdateClicked(Sender:TObject);
Begin
  StoreItem;
  FSections.Update(Nil);
End;

Procedure TCoolSectionsPropEditDialog.NewClicked(Sender:TObject);
Var
  Section: THeaderSection;
Begin
  StoreItem;
  Section:= FSections.Add;
  RefreshListBox;
  FListBox.ItemIndex:= Section.Index;
  FText.SetFocus;
End;

Procedure TCoolSectionsPropEditDialog.RefreshListBox;
Var
  Index: LongInt;
  Section: TCoolSection2;
Begin
  FListBox.BeginUpdate;
  FListBox.Clear;
  for Index := 0 to FSections.Count - 1 do
  begin
    Section := FSections[ Index ];
    FListBox.Items.AddObject( ToStr( Index )
                              + ' - '
                              + Section.Text,
                              Section );
  end;
  FListBox.EndUpdate;

  FSections.Update( Nil );
end;

Procedure TCoolSectionsPropEditDialog.DeleteClicked(Sender:TObject);
Var
  Section: THeaderSection;
  Index: longint;
Begin
  Section:= GetCurrentSection;
  Index := Section.Index;
  Section.Destroy;

  FCurrentSection := nil; // so we don't crash in storeitem
  RefreshListBox;

  // Select the next section (now in the same position)
  // or the previous if we deleted the last item
  if FSections.Count > 0 then
  begin
    if Index < FSections.Count then
      FListBox.ItemIndex := Index
    else
      FListBox.ItemIndex := Index - 1;
  end;
End;

Procedure TCoolSectionsPropEditDialog.MoveUpClicked(Sender:TObject);
Var
  Section: THeaderSection;
  Index: longint;
Begin
  StoreItem;

  Section := GetCurrentSection;
  If Section = nil Then
    exit;

  Index := Section.Index;
  if Index <= 0 then
    // can't move top section up
    exit;
  FSections.Swap( Index, Index - 1 );
  RefreshListBox;
  FListBox.ItemIndex := Index - 1;
End;

Procedure TCoolSectionsPropEditDialog.MoveDownClicked(Sender:TObject);
Var
  Section: THeaderSection;
  Index: longint;
Begin
  StoreItem;

  Section := GetCurrentSection;
  If Section = nil Then
    exit;

  Index := Section.Index;
  if Index >= FSections.Count - 1 then
    // can't move bottom section down
    exit;
  FSections.Swap( Index, Index + 1 );
  RefreshListBox;
  FListBox.ItemIndex := Index + 1;
End;

{$HINTS ON}

Procedure TCoolSectionsPropEditDialog.StoreItem;
Var
  c: Integer;
  i: LongInt;
  Section: TCoolSection2;
Begin
  Section := GetCurrentSection;
  if Section = nil then
    exit;

  if FText.Text <> Section.Text then
  begin
    // Text has changed, refresh the display
    Section.Text:= FText.Text;
    RefreshListBox;
    FListBox.ItemIndex := Section.Index;
  end;

  VAL(FWidth.Text,i,c);
  If c<>0 Then
    i:=100;
  Section.Width:=i;

  VAL(FMinWidth.Text,i,c);
  If c<>0 Then
    i:=0;
  Section.MinWidth:=i;

  VAL(FMaxWidth.Text,i,c);
  If c<>0 Then
    i:=10000;
  Section.MaxWidth:=i;

  VAL(FImage.Text,i,c);
  If c<>0 Then
    i:=10000;
  Section.Image:=i;

  VAL(FHotImage.Text,i,c);
  If c<>0 Then
    i:=10000;
  Section.HotImage:=i;

  VAL(FDisabledImage.Text,i,c);
  If c<>0 Then
    i:=10000;
  Section.DisabledImage:=i;

  Section.Disabled:=FDisabled.Checked;

  If FStyle.Text='OwnerDraw' Then
    Section.Style:=hsOwnerDraw
  Else
    Section.Style:=hsText;

  If FAlignment.Text='Center' Then
    Section.Alignment:=taCenter
  Else If FAlignment.Text='Right justify' Then
    Section.Alignment:=taRightJustify
  Else
    Section.Alignment:=taLeftJustify;

  Section.AllowClick:=FAllowClick.Checked;
  Section.AllowSize:=FAllowSize.Checked;

End;

Procedure TCoolSectionsPropEditDialog.ListItemFocus(Sender:TObject;Index:LongInt);
var
  Section: TCoolSection2;
Begin
  StoreItem;

  Section := FSections[ Index ];
  FCurrentSection := Section;

  FText.Text:= Section.Text;
  FWidth.Text:=tostr( Section.Width);
  FMinWidth.Text:=tostr( Section.MinWidth);
  FMaxWidth.Text:=tostr( Section.MaxWidth);
  FImage.Text:=tostr( Section.Image);
  FHotImage.Text:=tostr( Section.HotImage);
  FDisabledImage.Text:=tostr( Section.DisabledImage);
  FDisabled.Checked:= Section.Disabled;
  If Section.Style=hsText Then
    FStyle.Text:='Text'
  Else
    FStyle.Text:='OwnerDraw';

  Case Section.Alignment Of
    taRightJustify:
      FAlignment.Text:='Right justify';
    taCenter:
      FAlignment.Text:='Center';
    Else
      FAlignment.Text:='Left justify';
  End;

  FAllowClick.Checked:= Section.AllowClick;
  FAllowSize.Checked:= Section.AllowSize;
End;

Procedure TCoolSectionsPropEditDialog.SetupComponent;
Var
  Button: TButton;
Begin
  Inherited SetupComponent;

  Caption:='CoolBar sections editor';
  Width:=445;
  Height:=380;

  InsertGroupBox(Self,10,50,180,290,'Sections');
  FListBox:=InsertListBox(Self,20,140,160,180,'');
  FListBox.OnItemFocus:=ListItemFocus;

  Button:=InsertButton(Self,20,60,70,30,'&New','New Section');
  Button.OnClick:=NewClicked;
  Button:=InsertButton(Self,100,60,70,30,'&Delete','Delete Section');
  Button.OnClick:=DeleteClicked;

  Button:=InsertButton(Self,100,100,70,30,'&Up','Move Section Up');
  Button.OnClick:=MoveUpClicked;
  Button:=InsertButton(Self,20,100,70,30,'Do&wn','Move Section Down');
  Button.OnClick:=MoveDownClicked;

  InsertGroupBox(Self,200,50,230,290,'Section Properties');

  InsertLabel(Self,210,290,50,20,'Text');
  FText:=InsertEdit(Self,280,295,140,20,'','');

  InsertLabel(Self,210,260,100,20,'Width');
  FWidth:=InsertEdit(Self,280,265,140,20,'','');
  FWidth.NumbersOnly:=TRUE;

  InsertLabel(Self,210,230,60,20,'Min/Max');
  FMinWidth:=InsertEdit(Self,280,235,65,20,'','');
  FMinWidth.NumbersOnly:=TRUE;
  FMaxWidth:=InsertEdit(Self,355,235,65,20,'','');
  FMaxWidth.NumbersOnly:=TRUE;

  InsertLabel(Self,210,200,100,20,'Style');
  FStyle:=InsertComboBox(Self,280,205,140,20,csDropDownList);
  FStyle.Items.Add('Text');
  FStyle.Items.Add('OwnerDraw');

  InsertLabel(Self,210,170,100,20,'Alignment');
  FAlignment:=InsertComboBox(Self,280,175,140,20,csDropDownList);
  FAlignment.Items.Add('Left justify');
  FAlignment.Items.Add('Right justify');
  FAlignment.Items.Add('Center');

  FAllowClick:=InsertCheckBox(Self,210,135,100,20,'Allow Click','');
  FAllowSize:=InsertCheckBox(Self,210,115,100,20,'Allow Size','');
  FDisabled:=InsertCheckBox(Self,210,95,100,20,'Disabled','');

  InsertLabel(Self,300,133,100,20,'Image');
  FImage:=InsertEdit(Self,400,138,20,20,'','');
  FImage.NumbersOnly:=TRUE;

  InsertLabel(Self,300,113,100,20,'HotImage');
  FHotImage:=InsertEdit(Self,400,118,20,20,'','');
  FHotImage.NumbersOnly:=TRUE;

  InsertLabel(Self,300,93,100,20,'DisabledImage');
  FDisabledImage:=InsertEdit(Self,400,98,20,20,'','');
  FDisabledImage.NumbersOnly:=TRUE;

  Button:=InsertButton(Self,210,60,200,30,'Update','Update Section');
  Button.OnClick:=UpdateClicked;

  InsertBitBtn(Self,10,10,90,30,bkOk,'~Ok','Click here to accept');
  InsertBitBtn(Self,110,10,90,30,bkCancel,'~Cancel','Click here to cancel');
  InsertBitBtn(Self,210,10,90,30,bkHelp,'~Help','Click here to get help');

  FCurrentSection := nil;
End;

Procedure TCoolSectionsPropEditDialog.SetupShow;
begin
  inherited SetupShow;
  RefreshListBox;
  If FSections.Count > 0 Then
    FListBox.ItemIndex:= 0;
end;

Function TCoolSectionsPropertyEditor.Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Var
  HeaderSections: TCoolSections2;
  FDialog: TCoolSectionsPropEditDialog;
  SaveHeaders: TCoolSections2;
Begin
  HeaderSections:=TCoolSections2(ClassToEdit);
  If HeaderSections.HeaderControl=Nil Then
  Begin
       result:=peNoEditor;
       exit;
  End;

  SaveHeaders.Create(Nil);
  SaveHeaders.Assign(HeaderSections);

  FDialog.Create(Nil);
  FDialog.FSections:=HeaderSections;
  FDialog.ShowModal;

  //Modify ClassToEdit here
  result:=peCancel;
  Case FDialog.ModalResult Of
     cmOk:
     Begin
          FDialog.StoreItem;
          result:=peOk;
     End;
     Else
     Begin
          HeaderSections.Assign(SaveHeaders);
          result:=peCancel;
     End;
  End; {Case}

  SaveHeaders.Destroy;
  FDialog.Destroy;
End;

Initialization
   RegisterClasses([TCoolBar2]);
   //Register property editor
   AddClassPropertyEditor(TCoolSections2,TCoolSectionsPropertyEditor);
End.
