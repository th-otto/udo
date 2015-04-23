Unit CustomHeaderControl;

// Modified Header control.
// Improved and simplified drawing of sections
// ... ReadSCUResource clears the sections list
// Copied property editor from IDE code. Since translation
// is too confusing converted to english only.
Interface

Uses
  Messages,Classes,Forms,Graphics,Buttons,ExtCtrls,Dos;

Type
    TCustomHeaderSectionsPropertyEditor=CLASS(TClassPropertyEditor)
      PUBLIC
         FUNCTION Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;OVERRIDE;
    END;


    TCustomHeaderControl=Class;

    {$M+}
    TCustomHeaderSectionStyle=(hsText,hsOwnerDraw);
    {$M-}

    TCustomHeaderSection=Class(TCollectionItem)
      Private
         FText:PString;
         FWidth:LongInt;
         FMinWidth:LongInt;
         FMaxWidth:LongInt;
         FAlignment:TAlignment;
         FStyle:TCustomHeaderSectionStyle;
         FAllowClick:Boolean;
         FAllowSize:Boolean;
      Private
         Function GetText:String;
         Procedure SetText(Const NewValue:String);
         Procedure SetWidth(NewValue:LongInt);
         Function GetLeft:LongInt;
         Function GetRight:LongInt;
         Procedure SetStyle(NewValue:TCustomHeaderSectionStyle);
         Procedure SetAlignment(NewValue:TAlignment);
         Procedure SetMaxWidth(NewValue:LongInt);
         Procedure SetMinWidth(NewValue:LongInt);
      Public
         Constructor Create(ACollection:TCollection);Override;
         Destructor Destroy;Override;
         Procedure Assign(Source:TCollectionItem);Override;
      Public
         Property Left:LongInt Read GetLeft;
         Property Right:LongInt Read GetRight;
      Published
         Property Text:String Read GetText Write SetText;
         Property Width:LongInt Read FWidth Write SetWidth;
         Property MinWidth:LongInt Read FMinWidth Write SetMinWidth;
         Property MaxWidth:LongInt Read FMaxWidth Write SetMaxWidth;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property AllowClick:Boolean Read FAllowClick Write FAllowClick;
         Property AllowSize:Boolean Read FAllowSize Write FAllowSize;
         Property Style:TCustomHeaderSectionStyle Read FStyle Write SetStyle;
    End;

    {$HINTS OFF}
    TCustomHeaderSections=Class(TCollection)
      Private
         FHeaderControl:TCustomHeaderControl;
         Function GetItem(Index:LongInt):TCustomHeaderSection;
         Procedure SetItem(Index:LongInt;NewValue:TCustomHeaderSection);
      Public
         Procedure Update(Item:TCollectionItem);Override;
         Procedure SetupComponent;Override;
         Function Add:TCustomHeaderSection;
      Public
         Property Items[Index:LongInt]:TCustomHeaderSection Read GetItem Write SetItem;Default;
         Property HeaderControl:TCustomHeaderControl Read FHeaderControl;
    End;
    {$HINTS ON}
    TCustomHeaderSectionsClass=Class Of TCustomHeaderSections;

    {$M+}
    TSectionTrackState=(tsTrackBegin,tsTrackMove,tsTrackEnd);

    TCustomHeaderSectionNotifyEvent=Procedure(HeaderControl:TCustomHeaderControl;section:TCustomHeaderSection) Of Object;
    TDrawSectionEvent=Procedure(HeaderControl:TCustomHeaderControl;section:TCustomHeaderSection;
                                Const rc:TRect;Pressed:Boolean) Of Object;
    TSectionTrackEvent=Procedure(HeaderControl:TCustomHeaderControl;section:TCustomHeaderSection;
                                 Width:LongInt;State:TSectionTrackState) Of Object;

    TCustomHeaderControl=Class(TControl)
      Private
         FSections:TCustomHeaderSections;
         FSpacing:LongInt;
         FOnDrawSection:TDrawSectionEvent;
         FOnSectionClick:TCustomHeaderSectionNotifyEvent;
         FOnSectionResize:TCustomHeaderSectionNotifyEvent;
         FOnSectionTrack:TSectionTrackEvent;
         FSectionTrackState:TSectionTrackState;
         FClickSection:TCustomHeaderSection;
         FClickBase:TCustomHeaderSection;
         FSizeStartX:LongInt;
         FSizeX:LongInt;
         FSizeSection:TCustomHeaderSection;
         FBevelWidth:LongInt;
         FShape:TCursor;
         FSectionsClass:TCustomHeaderSectionsClass;
      Private
         Procedure SetSections(NewValue:TCustomHeaderSections);
         Procedure SetSpacing(NewValue:LongInt);
         Procedure SetBevelWidth(NewValue:LongInt);
         Function GetSections:TCustomHeaderSections;
      Protected
         Function GetMouseHeader(X,Y:LongInt):TCustomHeaderSection;Virtual;
         Procedure UpdateHeader(Header:TCustomHeaderSection);Virtual;
         Procedure DrawSection(section:TCustomHeaderSection;Const rc:TRect;Pressed:Boolean);Virtual;
         Procedure SectionClick(section:TCustomHeaderSection);Virtual;
         Procedure SectionResize(section:TCustomHeaderSection);Virtual;
         Procedure SectionTrack(section:TCustomHeaderSection;Width:LongInt;State:TSectionTrackState);Virtual;
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
      Protected
         Property ClickSection:TCustomHeaderSection read FClickSection write FClickSection;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Public
         Property SectionsClass:TCustomHeaderSectionsClass read FSectionsClass write FSectionsClass;
      Published
         Property Align;
         Property BevelWidth:LongInt Read FBevelWidth Write SetBevelWidth;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Sections:TCustomHeaderSections Read GetSections Write SetSections;
         Property ShowHint;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property Spacing:LongInt Read FSpacing Write SetSpacing;
         Property TabOrder;
         Property TabStop;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnStartDrag;
         Property OnEndDrag;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSectionClick:TCustomHeaderSectionNotifyEvent Read FOnSectionClick Write FOnSectionClick;
         Property OnDrawSection:TDrawSectionEvent Read FOnDrawSection Write FOnDrawSection;
         Property OnSectionResize:TCustomHeaderSectionNotifyEvent Read FOnSectionResize Write FOnSectionResize;
         Property OnSectionTrack:TSectionTrackEvent Read FOnSectionTrack Write FOnSectionTrack;
    End;

exports
  TCustomHeaderControl, 'User', 'CustomHeaderControl.bmp';

Implementation

Uses
  PmWin, Dialogs, StdCtrls, SysUtils;

procedure DrawBevel( Canvas: TCanvas;
                     BevelRc: TRect;
                     BevelWidth: longint;
                     Sunken: boolean );
var
  offs: longint;
  PointsArray: Array[0..5] Of TPoint;
  OldPenColor: TColor;
begin
  If BevelWidth > 1 Then
  Begin
    OldPenColor:= Canvas.Pen.Color;
    offs := BevelWidth-1;
    PointsArray[0] := Point(bevelrc.Left,bevelrc.Bottom);
    PointsArray[1] := Point(bevelrc.Left+offs,bevelrc.Bottom+offs);
    PointsArray[2] := Point(bevelrc.Left+offs,bevelrc.Top-offs);
    PointsArray[3] := Point(bevelrc.Right-offs,bevelrc.Top-offs);
    PointsArray[4] := Point(bevelrc.Right,bevelrc.Top);
    PointsArray[5] := Point(bevelrc.Left,bevelrc.Top);
    if Sunken then
      Canvas.Pen.color := clDkGray
    else
      Canvas.Pen.color := clWhite;
    Canvas.Polygon(PointsArray);
    PointsArray[2] := Point(bevelrc.Right-offs,bevelrc.Bottom+offs);
    PointsArray[3] := Point(bevelrc.Right-offs,bevelrc.Top-offs);
    PointsArray[4] := Point(bevelrc.Right,bevelrc.Top);
    PointsArray[5] := Point(bevelrc.Right,bevelrc.Bottom);
    if Sunken then
      Canvas.Pen.color := clWhite
    else
      Canvas.Pen.color := clDkGray;
    Canvas.Polygon(PointsArray);
    Canvas.Pen.color:= OldPenColor;
  End
  Else
    if Sunken then
      Canvas.ShadowedBorder(bevelrc,clDkGray,clWhite)
    else
      Canvas.ShadowedBorder(bevelrc,clWhite,clDkGray);
end;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCustomHeaderControl Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TCustomHeaderSection.GetText:String;
Begin
     If FText<>Nil Then Result:=FText^
     Else Result:='';
End;

Procedure TCustomHeaderSection.SetText(Const NewValue:String);
Begin
     If FText<>Nil Then
     Begin
          If FText^=NewValue Then Exit;
          FreeMem(FText,Length(FText^)+1);
     End;
     GetMem(FText,Length(NewValue)+1);
     FText^:=NewValue;
     changed(False);
End;

Procedure TCustomHeaderSection.SetWidth(NewValue:LongInt);
Begin
     If NewValue<FMinWidth Then NewValue:=FMinWidth;
     If NewValue>FMaxWidth Then NewValue:=FMaxWidth;
     If NewValue=FWidth Then Exit;
     FWidth:=NewValue;
     changed(True);
End;

Function TCustomHeaderSection.GetLeft:LongInt;
Var T:LongInt;
    Sections:TCustomHeaderSections;
Begin
     Result:=0;
     Sections:=TCustomHeaderSections(collection);
     If Sections<>Nil Then For T:=0 To Index-1 Do
     Begin
           Inc(Result,Sections[T].Width);
           If Sections.FHeaderControl<>Nil Then Inc(Result,Sections.FHeaderControl.FSpacing);
     End;
End;

Function TCustomHeaderSection.GetRight:LongInt;
Begin
     Result:=Left+Width;
End;

Procedure TCustomHeaderSection.SetStyle(NewValue:TCustomHeaderSectionStyle);
Begin
     If NewValue=FStyle Then Exit;
     FStyle:=NewValue;
     changed(False);
End;

Procedure TCustomHeaderSection.SetAlignment(NewValue:TAlignment);
Begin
     If NewValue=FAlignment Then Exit;
     FAlignment:=NewValue;
     changed(False);
End;

Procedure TCustomHeaderSection.SetMaxWidth(NewValue:LongInt);
Begin
     If NewValue>10000 Then NewValue:=10000;
     If NewValue<FMinWidth Then NewValue:=FMinWidth;
     FMaxWidth:=NewValue;
     Width:=FWidth;  //Update
End;

Procedure TCustomHeaderSection.SetMinWidth(NewValue:LongInt);
Begin
     If NewValue<0 Then NewValue:=0;
     If NewValue>FMaxWidth Then NewValue:=FMaxWidth;
     FMinWidth:=NewValue;
     Width:=FWidth; //Update
End;

Constructor TCustomHeaderSection.Create(ACollection:TCollection);
Begin
     FWidth:=100;
     FMinWidth:=0;
     FMaxWidth:=10000;
     FAlignment:=taLeftJustify;
     FStyle:=hsText;
     FAllowClick:=True;
     FAllowSize:=True;
     Inherited Create(ACollection);
End;

Destructor TCustomHeaderSection.Destroy;
Begin
     If FText<>Nil Then FreeMem(FText,Length(FText^)+1);

     Inherited Destroy;
End;

Procedure TCustomHeaderSection.Assign(Source:TCollectionItem);
Begin
     If Source Is TCustomHeaderSection Then
       If Source<>Self Then
     Begin
          FMinWidth:=TCustomHeaderSection(Source).MinWidth;
          FMaxWidth:=TCustomHeaderSection(Source).MaxWidth;
          FAlignment:=TCustomHeaderSection(Source).Alignment;
          FStyle:=TCustomHeaderSection(Source).Style;
          FAllowClick:=TCustomHeaderSection(Source).AllowClick;
          FAllowSize:=TCustomHeaderSection(Source).AllowSize;
          Width:=TCustomHeaderSection(Source).Width;
          Text:=TCustomHeaderSection(Source).Text;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCustomHeaderSections Class Implementation                        บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TCustomHeaderSections.GetItem(Index:LongInt):TCustomHeaderSection;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited GetItem(Index);
     Result:=TCustomHeaderSection(dummy);
End;

Procedure TCustomHeaderSections.SetItem(Index:LongInt;NewValue:TCustomHeaderSection);
Begin
     Inherited SetItem(Index,NewValue);
End;

Procedure TCustomHeaderSections.Update(Item:TCollectionItem);
Begin
     If FHeaderControl=Nil Then Exit;
     If Item=Nil Then FHeaderControl.Invalidate
     Else FHeaderControl.UpdateHeader(TCustomHeaderSection(Item));
End;

Procedure TCustomHeaderSections.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='HeaderSections';
     If Owner Is TCustomHeaderControl Then FHeaderControl:=TCustomHeaderControl(Owner);
     ItemClass:=TCustomHeaderSection;
End;

Function TCustomHeaderSections.Add:TCustomHeaderSection;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited Add;
     Result:=TCustomHeaderSection(dummy);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCustomHeaderControl Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TCustomHeaderControl.GetSections:TCustomHeaderSections;
Begin
     If FSections=Nil Then FSections:=FSectionsClass.Create(Self);
     Result:=FSections;
End;

Procedure TCustomHeaderControl.SetSections(NewValue:TCustomHeaderSections);
Begin
     Sections.Assign(NewValue);
End;

Procedure TCustomHeaderControl.UpdateHeader(Header:TCustomHeaderSection);
Var T:LongInt;
    rc:TRect;
Begin
     //Get Rectangle For the Panel
     rc:=ClientRect;
     If FSections<>Nil Then
      For T:=0 To FSections.Count-1 Do
      Begin
           If FSections[T]=Header Then break
           Else Inc(rc.Left,FSections[T].Width+FSpacing);
      End;

     rc.Right:=rc.Left+Header.Width;
     InvalidateRect(rc);
     Update;
End;

{$HINTS OFF}
Procedure TCustomHeaderControl.DrawSection(section:TCustomHeaderSection;Const rc:TRect;Pressed:Boolean);
Var
   Align:TAlignment;
   S:String;
   CX,CY,H:LongInt;
   rec:TRect;
Begin
     Align:=section.Alignment;
     S:=section.Text;

     Canvas.GetTextExtent(S,CX,CY);

     Case Align Of
        taLeftJustify:
          rec.Left:=rc.Left+3;
        taRightJustify:
          rec.Left:=rc.Right-3-CX;
        Else //taCenter
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX) Div 2);
        End;
     End; //Case

     If rec.Left<rc.Left+3 Then
       rec.Left:=rc.Left+3;
     if Pressed then
       inc( rec.Left );
     H:=rc.Top-rc.Bottom;
     rec.Bottom:=rc.Bottom+((H-CY) Div 2);
     If rec.Bottom<rc.Bottom+3 Then rec.Bottom:=rc.Bottom+3;
     if Pressed then
       dec( rec.Bottom );
     rec.Right:=rec.Left+CX-1;
     rec.Top:=rec.Bottom+CY-1;

     Canvas.TextOut(rec.Left,rec.Bottom,S);

     Canvas.ExcludeClipRect(rec);

     DrawBevel( Canvas, rc, BevelWidth, Pressed );

     rec:=rc;
     Forms.InflateRect(rec,-BevelWidth,-BevelWidth);
     Canvas.FillRect(rec,Color)
End;
{$HINTS ON}


Procedure TCustomHeaderControl.Redraw(Const rec:TRect);
Var T:LongInt;
    rc,rc2:TRect;
    section:TCustomHeaderSection;
    IsPressed:Boolean;
Begin
     Canvas.Brush.color:=color;
     Canvas.Pen.color:=PenColor;

     rc:=ClientRect;
     If FSections<>Nil Then
     begin
       For T:=0 To FSections.Count-1 Do
       Begin
          section:=FSections[T];
          rc.Right:=rc.Left+section.Width -1;

          If rc.Right>Width-1 Then
            rc.Right:=Width-1;

          if T = FSections.Count - 1 then
            // always expand last column to width
            rc.Right:=Width-1;

          IsPressed:= section = FClickSection;

          rc2:=Forms.IntersectRect(rc,rec);
          If Not Forms.IsRectEmpty(rc2) Then
          Begin
               Canvas.ClipRect:=rc2;

               If section.Style=hsOwnerDraw Then
               Begin
                    If OnDrawSection<>Nil Then OnDrawSection(Self,section,rc,IsPressed)
                    Else DrawSection(section,rc,IsPressed);
               End
               Else DrawSection(section,rc,IsPressed);
          End;


          Inc( rc.Left, section.Width );
          if FSpacing > 0 then
          begin
            rc.Right:= rc.Left + FSpacing ;
            Canvas.FillRect( rc, Color );
            Inc( rc.Left, FSpacing );
          end;
          if rc.Left > Width then
            break;
        End;

        if FSections.COunt = 0 then
        begin
          // No sections
          Canvas.ClipRect:=rc;
          DrawBevel( Canvas, rc, BevelWidth, false );
          InflateRect( rc, -BevelWidth, -BevelWidth );
          Canvas.FillRect( rc, COlor );
        end;

      end;

     Canvas.DeleteClipRegion;
End;

Type
    PHeaderItem=^THeaderItem;
    THeaderItem=Record
        Style:TCustomHeaderSectionStyle;
        Width:LongInt;
        MinWidth,MaxWidth:LongInt;
        AllowClick,AllowSize:Boolean;
        Alignment:TAlignment;
    End;


Procedure TCustomHeaderControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PHeaderItem;
   section:TCustomHeaderSection;
   T:LongInt;
   ps:^String;
Begin
     If ResName = rnHeaders Then
     Begin
          Sections.Clear;
          Count:=@Data;
          Items:=@Data;
          Inc(Items,4);
          For T:=1 To Count^ Do
          Begin
               Section:=Sections.Add;
               ps:=Pointer(Items);
               section.Text:=ps^;
               Inc(Items,Length(ps^)+1);
               section.Style:=Items^.Style;
               section.Alignment:=Items^.Alignment;
               section.Width:=Items^.Width;
               section.MinWidth:=Items^.MinWidth;
               section.MaxWidth:=Items^.MaxWidth;
               section.AllowClick:=Items^.AllowClick;
               section.AllowSize:=Items^.AllowSize;
               Inc(Items,SizeOf(THeaderItem));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TCustomHeaderControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:THeaderItem;
    section:TCustomHeaderSection;
    S:String;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FSections<>Nil Then If FSections.Count>0 Then
     Begin
          MemStream.Create;
          T:=FSections.Count;
          MemStream.Write(T,4);
          For T:=0 To FSections.Count-1 Do
          Begin
               section:=FSections[T];
               S:=section.Text;
               MemStream.Write(S,Length(S)+1);
               Item.Style:=section.Style;
               Item.Width:=section.Width;
               Item.MinWidth:=section.MinWidth;
               Item.MaxWidth:=section.MaxWidth;
               Item.AllowClick:=section.AllowClick;
               Item.AllowSize:=section.AllowSize;
               Item.Alignment:=section.Alignment;
               MemStream.Write(Item,SizeOf(THeaderItem));
          End;

          Result:=Stream.NewResourceEntry(rnHeaders,MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;

Procedure TCustomHeaderControl.SectionClick(section:TCustomHeaderSection);
Begin
     If FOnSectionClick<>Nil Then FOnSectionClick(Self,section);
End;

Procedure TCustomHeaderControl.SectionResize(section:TCustomHeaderSection);
Begin
     If FOnSectionResize<>Nil Then FOnSectionResize(Self,section);
End;

Procedure TCustomHeaderControl.SectionTrack(section:TCustomHeaderSection;Width:LongInt;State:TSectionTrackState);
Begin
     If FOnSectionTrack<>Nil Then FOnSectionTrack(Self,section,Width,State);
End;

Procedure TCustomHeaderControl.SetSpacing(NewValue:LongInt);
Begin
     If NewValue<0 Then NewValue:=0;
     FSpacing:=NewValue;
     Invalidate;
End;

Procedure TCustomHeaderControl.SetBevelWidth(NewValue:LongInt);
Begin
     If NewValue<1 Then NewValue:=1;
     If NewValue>20 Then NewValue:=20;
     FBevelWidth:=NewValue;
     Invalidate;
End;

Procedure TCustomHeaderControl.SetupComponent;
Begin
     Inherited SetupComponent;

     Align:=alTop;
     color:=clDlgWindow;
     Name:='HeaderControl';
     FSectionsClass:=TCustomHeaderSections;
     Height:=50;
     FSpacing:=0;
     FSectionTrackState:=tsTrackEnd;
     FBevelWidth:=1;
     HandlesDesignMouse:=True;
     Include(ComponentState,csAcceptsControls);
     FShape:=crDefault;
End;

Destructor TCustomHeaderControl.Destroy;
Begin
     If FSections<>Nil Then FSections.Destroy;
     Inherited Destroy;
End;

Procedure TCustomHeaderControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:TCustomHeaderSection;
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          If ((section.AllowSize)And(X>section.Right-2)And(X<section.Right+2)) Then
          Begin
               Cursor:=crHSplit;
               FShape:=crHSplit;
               LastMsg.Handled:=True;   {dont pass To Form Editor}
               Canvas.Pen.Mode:=pmNot;
               Canvas.Pen.color:=clBlack;
               FSizeSection:=section;
               FSizeStartX:=section.Right;
               FSizeX:=FSizeStartX;
               Canvas.Line(FSizeX,0,FSizeX,Height);
               MouseCapture:=True;
               Canvas.Pen.Mode:=pmCopy;
               FSectionTrackState:=tsTrackBegin;
               If OnSectionTrack<>Nil Then OnSectionTrack(Self,FSizeSection,FSizeX-FSizeSection.Left,
                                                          FSectionTrackState);
               Exit;
          End;
     End;

     If Designed Then Exit;

     //Test Press
     section:=GetMouseHeader(X,Y);
     If section<>Nil Then If section.AllowClick Then
     Begin
          FClickBase:=section;
          FClickSection:=section;
          UpdateHeader(section);
          MouseCapture:=True;
     End;
End;

Function TCustomHeaderControl.GetMouseHeader(X,Y:LongInt):TCustomHeaderSection;
Var T:LongInt;
    section:TCustomHeaderSection;
Begin
     Result:=Nil;
     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          If ((Y>1)And(Y<Height-1)And(X>section.Left+1)And(X<section.Right-1)) Then
          Begin
               Result:=section;
               Exit;
          End;
     End;
End;

Procedure TCustomHeaderControl.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var section:TCustomHeaderSection;
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button=mbLeft Then
     Begin
          section:=GetMouseHeader(X,Y);
          If section<>Nil Then If section.AllowClick Then
          Begin
               FClickSection:=section;
               UpdateHeader(section);
               Delay(20);
               FClickSection:=Nil;
               UpdateHeader(section);
               If OnSectionClick<>Nil Then OnSectionClick(Self,section);
          End;
     End;
End;

Procedure TCustomHeaderControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var ClickHeader:TCustomHeaderSection;
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     If FSectionTrackState In [tsTrackBegin,tsTrackMove] Then
     Begin
          LastMsg.Handled:=True; {dont pass To Form Editor}
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.color:=clBlack;
          {Delete old rubberline}
          Canvas.Line(FSizeX,0,FSizeX,Height);
          MouseCapture:=False;
          Cursor:=crDefault;
          FShape:=crDefault;
          Canvas.Pen.Mode:=pmCopy;

          If FSizeX<FSizeSection.Left Then FSizeX:=FSizeSection.Left;

          FSizeSection.Width:=FSizeX-FSizeSection.Left;

          FSectionTrackState:=tsTrackEnd;
          If OnSectionTrack<>Nil Then OnSectionTrack(Self,FSizeSection,FSizeSection.Width,
                                                     FSectionTrackState);
          If OnSectionResize<>Nil Then
            OnSectionResize(Self,FSizeSection);
          FSizeSection:=Nil;
     End;

     If FClickBase<>Nil Then
     Begin
          ClickHeader:=GetMouseHeader(X,Y);
          MouseCapture:=False;
          If ClickHeader=FClickBase Then //clicked
          Begin
               FClickSection:=Nil;
               FClickBase:=Nil;
               UpdateHeader(ClickHeader);
               If OnSectionClick<>Nil Then OnSectionClick(Self,ClickHeader);
          End
          Else
          Begin
               ClickHeader:=FClickBase;
               FClickSection:=Nil;
               FClickBase:=Nil;
               UpdateHeader(ClickHeader);
          End;
     End;
End;

Procedure TCustomHeaderControl.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:TCustomHeaderSection;
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FSectionTrackState In [tsTrackBegin,tsTrackMove] Then
     Begin
          LastMsg.Handled:=True; {dont pass To Form Editor}
          Canvas.Pen.Mode:=pmNot;
          Canvas.Pen.color:=clBlack;
          {Delete old rubberline}
          Canvas.Line(FSizeX,0,FSizeX,Height);
          {Draw New Line}
          FSizeX:=X;
          If FSizeX<FSizeSection.Left Then FSizeX:=FSizeSection.Left;
          If FSizeX>=Width Then FSizeX:=Width;
          Canvas.Line(FSizeX,0,FSizeX,Height);
          Canvas.Pen.Mode:=pmCopy;

          FSectionTrackState:=tsTrackMove;
          If OnSectionTrack<>Nil Then OnSectionTrack(Self,FSizeSection,FSizeX-FSizeSection.Left,
                                                     FSectionTrackState);
          Exit;
     End
     Else
     Begin
          If FClickBase<>Nil Then
          Begin
               section:=GetMouseHeader(X,Y);
               If section<>FClickSection Then
               Begin
                    If FClickSection<>Nil Then
                    Begin
                         section:=FClickSection;
                         FClickSection:=Nil;
                         If section<>Nil Then UpdateHeader(section);
                    End
                    Else
                    Begin
                         If section=FClickBase Then
                         Begin
                              FClickSection:=section;
                              If FClickSection<>Nil Then UpdateHeader(FClickSection);
                         End;
                    End;
               End;
          End
          Else
          Begin
               If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
               Begin
                    section:=FSections[T];
                    If ((section.AllowSize)And(X>section.Right-2)And(X<section.Right+2)) Then
                    Begin
                         FShape:=crHSplit;
                         {$IFDEF OS2}
                         WinSetPointer(HWND_DESKTOP,Screen.Cursors[FShape]);
                         {$ENDIF}
                         {$IFDEF Win95}
                         SetClassWord(Handle,-12{GCW_HCURSOR},0);
                         SetCursor(Screen.Cursors[FShape]);
                         {$ENDIF}
                         LastMsg.Handled:=True; {dont pass To Form Editor}
                         Exit;
                    End;
               End;
          End;
     End;

     If FShape<>crDefault Then
     Begin
          FShape:=crDefault;

          {$IFDEF OS2}
          WinSetPointer(HWND_DESKTOP,Screen.Cursors[FShape]);
          {$ENDIF}
          {$IFDEF Win95}
          SetClassWord(Handle,-12{GCW_HCURSOR},0);
          SetCursor(Screen.Cursors[FShape]);
          {$ENDIF}
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ This section: THeaderSectionsPropertyEditor Class implementation          บ
บ                                                                           บ
บ Last modified: September 1995                                             บ
บ                                                                           บ
บ (C) 1995 SpeedSoft. All rights reserved. Disclosure probibited !          บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

TYPE
    TCustomHeaderSectionsPropEditDialog=CLASS(TDialog)
      PRIVATE
         FSections:TCustomHeaderSections;
         FListBox:TListBox;
         FText:TEdit;
         FWidth:TEdit;
         FMinWidth,FMaxWidth:TEdit;
         FStyle:TComboBox;
         FAlignment:TComboBox;
         FCurrentSection:TCustomHeaderSection;
         FCurrentIndex:LONGINT;
         FAllowClick:TCheckBox;
         FAllowSize:TCheckBox;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE NewClicked(Sender:TObject);
         PROCEDURE DeleteClicked(Sender:TObject);
         PROCEDURE UpdateClicked(Sender:TObject);
         PROCEDURE ListItemFocus(Sender:TObject;Index:LONGINT);
         PROCEDURE StoreItem;
         PROCEDURE TextChange(Sender:TObject);
         PROCEDURE WidthChange(Sender:TObject);
         PROCEDURE MinWidthChange(Sender:TObject);
         PROCEDURE MaxWidthChange(Sender:TObject);
         PROCEDURE StyleSelect(Sender:TObject;Index:LONGINT);
         PROCEDURE AlignmentSelect(Sender:TObject;Index:LONGINT);
    END;


{$HINTS OFF}
PROCEDURE TCustomHeaderSectionsPropEditDialog.TextChange(Sender:TObject);
BEGIN
     IF FCurrentSection=NIL THEN exit;
     FCurrentSection.Text:=FText.Text;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.WidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentSection=NIL THEN exit;
     VAL(FWidth.Text,i,c);
     IF c<>0 THEN exit;
     FCurrentSection.Width:=i;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.MinWidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentSection=NIL THEN exit;
     VAL(FMinWidth.Text,i,c);
     IF c<>0 THEN exit;
     FCurrentSection.MinWidth:=i;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.MaxWidthChange(Sender:TObject);
VAR i:LONGINT;
    c:Integer;
BEGIN
     IF FCurrentSection=NIL THEN exit;
     VAL(FMaxWidth.Text,i,c);
     IF c<>0 THEN exit;
     FCurrentSection.MaxWidth:=i;
END;


PROCEDURE TCustomHeaderSectionsPropEditDialog.StyleSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentSection=NIL THEN exit;
     IF FStyle.Text='OwnerDraw' THEN FCurrentSection.Style:=hsOwnerDraw
     ELSE FCurrentSection.Style:=hsText;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.AlignmentSelect(Sender:TObject;Index:LONGINT);
BEGIN
     IF FCurrentSection=NIL THEN exit;
     IF FAlignment.Text='Center' THEN FCurrentSection.Alignment:=taCenter
     ELSE IF FAlignment.Text='Right justify' THEN FCurrentSection.Alignment:=taRightJustify
     ELSE FCurrentSection.Alignment:=taLeftJustify;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.UpdateClicked(Sender:TObject);
BEGIN
     StoreItem;
     FSections.Update(NIL);
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.NewClicked(Sender:TObject);
VAR Section:TCustomHeaderSection;
BEGIN
     Section:=FSections.Add;
     IF Section.Text='' THEN FListBox.Items.Add(tostr(Section.Index)+' - (Untitled)')
     ELSE FListBox.Items.Add(tostr(Section.Index)+' - '+Section.Text);
     FListBox.ItemIndex:=Section.Index;
     FSections.Update(NIL);
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.DeleteClicked(Sender:TObject);
VAR Section:TCustomHeaderSection;
    Index:LONGINT;
BEGIN
     Index:=FListBox.ItemIndex;
     IF Index<0 THEN exit;
     FListBox.Items.Delete(Index);
     Section:=FSections[Index];
     Section.Destroy;
     FCurrentSection:=NIL;
     FCurrentIndex:=-1;
     IF FListBox.Items.Count>0 THEN FListBox.ItemIndex:=0;
END;
{$HINTS ON}

PROCEDURE TCustomHeaderSectionsPropEditDialog.StoreItem;
VAR c:Integer;
    i:LONGINT;
BEGIN
     IF FCurrentSection<>NIL THEN //store values
     BEGIN
          FCurrentSection.Text:=FText.Text;
          IF FText.Text='' THEN FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - (Untitled)'
          ELSE FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - '+FText.Text;

          VAL(FWidth.Text,i,c);
          IF c<>0 THEN i:=100;
          FCurrentSection.Width:=i;

          VAL(FMinWidth.Text,i,c);
          IF c<>0 THEN i:=0;
          FCurrentSection.MinWidth:=i;

          VAL(FMaxWidth.Text,i,c);
          IF c<>0 THEN i:=10000;
          FCurrentSection.MaxWidth:=i;

          IF FStyle.Text='OwnerDraw' THEN FCurrentSection.Style:=hsOwnerDraw
          ELSE FCurrentSection.Style:=hsText;

          IF FAlignment.Text='Center' THEN FCurrentSection.Alignment:=taCenter
          ELSE IF FAlignment.Text='Right justify' THEN FCurrentSection.Alignment:=taRightJustify
          ELSE FCurrentSection.Alignment:=taLeftJustify;

          FCurrentSection.AllowClick:=FAllowClick.Checked;
          FCurrentSection.AllowSize:=FAllowSize.Checked;
     END;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.ListItemFocus(Sender:TObject;Index:LONGINT);
BEGIN
     StoreItem;

     FCurrentSection:=FSections[Index];
     FCurrentIndex:=Index;
     FText.Text:=FCurrentSection.Text;
     FWidth.Text:=tostr(FCurrentSection.Width);
     FMinWidth.Text:=tostr(FCurrentSection.MinWidth);
     FMaxWidth.Text:=tostr(FCurrentSection.MaxWidth);
     IF FCurrentSection.Style=hsText THEN FStyle.Text:='Text'
     ELSE FStyle.Text:='OwnerDraw';

     CASE FCurrentSection.Alignment OF
        taRightJustify:FAlignment.Text:='Right justify';
        taCenter:FAlignment.Text:='Center';
        ELSE FAlignment.Text:='Left justify';
     END;

     FAllowClick.Checked:=FCurrentSection.AllowClick;
     FAllowSize.Checked:=FCurrentSection.AllowSize;
END;

PROCEDURE TCustomHeaderSectionsPropEditDialog.SetupComponent;
VAR Button:TButton;
BEGIN
     Inherited SetupComponent;

     Caption:='Header sections';
     Width:=435;
     Height:=350;

     InsertGroupBox(SELF,10,50,180,260,'Sections');
     FListBox:=InsertListBox(SELF,20,100,160,190,'');
     FListBox.OnItemFocus:=ListItemFocus;

     Button:=InsertButton(SELF,20,60,70,30,'New','Create a new section' );
     Button.OnClick:=NewClicked;
     Button:=InsertButton(SELF,100,60,70,30,'Delete', 'Delete section' );
     Button.OnClick:=DeleteClicked;

     InsertGroupBox(SELF,200,50,220,260,'Section properties' );

     InsertLabel(SELF,210,260,50,20,'Text');
     FText:=InsertEdit(SELF,280,265,130,20,'','');
     FText.OnChange:=TextChange;

     InsertLabel(SELF,210,230,100,20,'Width');
     FWidth:=InsertEdit(SELF,280,235,130,20,'','');
     FWidth.OnChange:=WidthChange;
     FWidth.NumbersOnly:=TRUE;

     InsertLabel(SELF,210,200,60,20,'Min/max');
     FMinWidth:=InsertEdit(SELF,280,205,60,20,'','');
     FMinWidth.OnChange:=MinWidthChange;
     FMinWidth.NumbersOnly:=TRUE;
     FMaxWidth:=InsertEdit(SELF,350,205,60,20,'','');
     FMaxWidth.OnChange:=MaxWidthChange;
     FMaxWidth.NumbersOnly:=TRUE;

     InsertLabel(SELF,210,170,100,20,'Style');
     FStyle:=InsertComboBox(SELF,280,175,130,20,csDropDownList);
     FStyle.Items.Add('Text');
     FStyle.Items.Add('OwnerDraw');
     FStyle.OnItemSelect:=StyleSelect;

     InsertLabel(SELF,210,140,100,20,'Alignment');
     FAlignment:=InsertComboBox(SELF,280,145,130,20,csDropDownList);
     FAlignment.Items.Add('Left justify');
     FAlignment.Items.Add('Right justify');
     FAlignment.Items.Add('Center');
     FAlignment.OnItemSelect:=AlignmentSelect;

     FAllowClick:=InsertCheckBox(SELF,210,115,180,20,'Allow click','');
     FAllowSize:=InsertCheckBox(SELF,210,95,180,20,'Allow size','');

     Button:=InsertButton(SELF,210,60,170,30,'Update','Update the section' );
     Button.OnClick:=UpdateClicked;

     InsertBitBtn(SELF,10,10,90,30,bkOk,'OK','');
     InsertBitBtn(SELF,110,10,90,30,bkCancel,'Cancel','');
     InsertBitBtn(SELF,210,10,90,30,bkHelp,'Help','');
END;

FUNCTION TCustomHeaderSectionsPropertyEditor.Execute(VAR ClassToEdit:TObject):TClassPropertyEditorReturn;
VAR  HeaderSections:TCustomHeaderSections;
     FDialog:TCustomHeaderSectionsPropEditDialog;
     SaveHeaders:TCustomHeaderSections;
     Section:TCustomHeaderSection;
     t:LONGINT;
BEGIN
     HeaderSections:=TCustomHeaderSections(ClassToEdit);
     IF HeaderSections.HeaderControl=NIL THEN
     BEGIN
          result:=peNoEditor;
          exit;
     END;

     SaveHeaders.Create(NIL);
     SaveHeaders.Assign(HeaderSections);

     FDialog.Create(NIL);
//     FDialog.HelpContext := hctxDialogHeaderSectionsPropertyEditor;
     FDialog.FSections:=HeaderSections;

     FOR t:=0 TO HeaderSections.Count-1 DO
     BEGIN
          Section:=HeaderSections[t];
          IF Section.Text='' THEN FDialog.FListBox.Items.Add(tostr(t)+' - (Untitled)')
          ELSE FDialog.FListBox.Items.Add(tostr(t)+' - '+Section.Text);
     END;
     IF FDialog.FListBox.Items.Count>0 THEN FDialog.FListBox.ItemIndex:=0;

     FDialog.ShowModal;

     //Modify ClassToEdit here
     result:=peCancel;
     CASE FDialog.ModalResult OF
        cmOk:
        BEGIN
             FDialog.StoreItem;
             result:=peOk;
        END;
        ELSE
        BEGIN
             HeaderSections.Assign(SaveHeaders);
             result:=peCancel;
        END;
     END; {case}

     SaveHeaders.Destroy;
     FDialog.Destroy;
END;

Begin
  RegisterClasses( [TCustomHeaderControl] );
  AddClassPropertyEditor( TCustomHeaderSections, TCustomHeaderSectionsPropertyEditor );
End.



