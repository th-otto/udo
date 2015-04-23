
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit EXTCTRLS;


Interface

Uses SysUtils,Classes,Forms,Graphics,Buttons,StdCtrls;


Type
    TShapeType=(stRectangle,stSquare,stRoundRect,stRoundSquare,
                stEllipse,stCircle,stTriangle);

    TShape=Class(TControl)
      Private
         FTempPen:TPen;
         FTempBrush:TBrush;
         FShape:TShapeType;
         Function GetBrush:TBrush;
         Function GetPen:TPen;
         Procedure SetShape(NewShape:TShapeType);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Property Canvas;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Brush:TBrush Read GetBrush;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property Pen:TPen Read GetPen;
         Property Shape:TShapeType Read FShape Write SetShape;
         Property ShowHint;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TPaintBox=Class(TControl)
      Protected
         Procedure SetupComponent;Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property ShowHint;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPaint;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TImage=Class(TControl)
      Private
         FPicture:TPicture;
         FNeedBitmap:Boolean;
         FAutoSize:Boolean;
         FStretch:Boolean;
         FCenter:Boolean;
         FOnChange:TNotifyEvent;
         Procedure SetStretch(NewValue:Boolean);
         Procedure SetCenter(NewValue:Boolean);
         Procedure SetBitmap(NewBitmap:TBitmap);
         Function GetBitmap:TBitmap;
         Function GetIcon:TIcon;
         Procedure SetIcon(NewIcon:TIcon);
         Function GetGraphic:TGraphic;
         Procedure SetGraphic(NewGraphic:TGraphic);
         Procedure PictureChanged(Sender:TObject);
      Protected
         Procedure Change;Virtual;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Property NeedBitmap:Boolean Read FNeedBitmap Write FNeedBitmap;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Public
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
         Property Picture:TPicture Read {Get}FPicture;
         Property Graphic:TGraphic read GetGraphic write SetGraphic;
         Property Icon:TIcon Read GetIcon Write SetIcon;
      Published
         Property Align;
         Property AutoSize:Boolean Read FAutoSize Write FAutoSize;
         Property Center:Boolean Read FCenter Write SetCenter;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property Bitmap:TBitmap Read GetBitmap Write SetBitmap;
         Property PopupMenu;
         Property ShowHint;
         Property Stretch:Boolean Read FStretch Write SetStretch;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent read FOnChange write FOnChange;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    {$M+}
    TBevelShape=(bsBottomLine,bsBox,bsFrame,bsLeftLine,bsRightLine,bsTopLine,
      bsBorder);

    TBevelStyle=(bsLowered,bsRaised);
    {$M-}

    TBevel=Class(TControl)
      Private
         FShape:TBevelShape;
         FStyle:TBevelStyle;
         Procedure SetShape(NewShape:TBevelShape);
         Procedure SetStyle(NewStyle:TBevelStyle);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property ParentShowHint;
         Property PopupMenu;
         Property Shape:TBevelShape Read FShape Write SetShape;
         Property ShowHint;
         Property Style:TBevelStyle Read FStyle Write SetStyle;
         Property Visible;
         Property ZOrder;

         Property OnCommand;
         Property OnResize;
         Property OnSetupShow;
    End;


    {$M+}
    TPanelBevel=(bvRaised,bvLowered,bvNone);
    {$M-}

    TPanel=Class(TControl)
      Private
         FBevelInner:TPanelBevel;
         FBevelOuter:TPanelBevel;
         FBevelWidth:LongInt;
         FBorderStyle:TBorderStyle;
         FBorderWidth:LongInt;
         FAlignment:TAlignment;
         FInterior:TRect;
         Procedure CMTextChanged(Var Msg:TMessage); Message CM_TEXTCHANGED;
         Procedure SetBevelInner(NewBevel:TPanelBevel);
         Procedure SetBevelOuter(NewBevel:TPanelBevel);
         Procedure SetBevelWidth(NewWidth:LongInt);
         Procedure SetBorderStyle(NewStyle:TBorderStyle);
         Procedure SetBorderWidth(NewWidth:LongInt);
         Procedure SetAlignment(ta:TAlignment);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure DrawText(Const rec:TRect);Virtual;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property BevelInner:TPanelBevel Read FBevelInner Write SetBevelInner;
         Property BevelOuter:TPanelBevel Read FBevelOuter Write SetBevelOuter;
         Property BevelWidth:LongInt Read FBevelWidth Write SetBevelWidth;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property BorderWidth:LongInt Read FBorderWidth Write SetBorderWidth;
         Property Caption;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnCommand;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPaint;
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TRadioGroup=Class(TGroupBox)
      Private
         FItems:TStrings;
         FRadios:TList;
         FItemIndex:LongInt;
         FColumns:LongInt;
         FOnClick:TNotifyEvent;
         FIsTabStop:boolean; // radio buttons are tabstops
         Procedure SetItemIndex(Value:LongInt);
         Procedure SetColumns(Value:LongInt);
         Procedure SetItems(Value:TStrings);
         Procedure SetRadioCount(Value:LongInt);
         Function GetItemsEnabled(Index:LongInt):Boolean;
         Procedure SetItemsEnabled(Index:LongInt;Value:Boolean);
         Procedure UpdateRadios;
         Procedure ArrangeRadios;
         Procedure EvItemsChange(Sender:TObject);
         Procedure EvRadioClick(Sender:TObject);
         procedure UpdateTabList;
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Procedure FontChange;Override;
         Procedure Click;Virtual;
         Procedure ItemIndexChange;Virtual;
         function GetTabStop:boolean;
         procedure SetTabStop(Value:boolean);
         procedure WMFocussing( Var Msg: TMessage ); message WM_FOCUSSING;
      Public
         Destructor Destroy;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property ItemsEnabled[Index:LongInt]:Boolean Read GetItemsEnabled Write SetItemsEnabled;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Caption;
         Property Color;
         Property Columns:LongInt Read FColumns Write SetColumns;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ItemIndex:LongInt Read FItemIndex Write SetItemIndex;
         Property Items:TStrings Read FItems Write SetItems;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property ShowHint;
         Property TabOrder;
         property TabStop: boolean read GetTabStop write SetTabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnSetupShow;
         Property OnStartDrag;
    End;



Function InsertShape(parent:TControl;Left,Bottom,Width,Height:LongInt):TShape;
Function InsertImage(parent:TControl;Left,Bottom,Width,Height:LongInt;BitmapId:LongWord):TImage;
Function InsertImageName(parent:TControl;Left,Bottom,Width,Height:LongInt;Const BitmapId:String):TImage;
Function InsertBevel(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Shape:TBevelShape;Style:TBevelStyle):TBevel;
Function InsertPanel(parent:TControl;Left,Bottom,Width,Height:LongInt;
           BevelInner:TPanelBevel;BevelOuter:TPanelBevel;BevelWidth:LongInt;
           Caption:String):TPanel;
Function InsertRadioGroup(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Caption:String):TRadioGroup;


Implementation


Function InsertShape(parent:TControl;Left,Bottom,Width,Height:LongInt):TShape;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertImage(Parent:TControl;Left,Bottom,Width,Height:LongInt;
  BitmapId:LongWord):TImage;
Var  Bitmap:TBitmap;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Bitmap.Create;
     Bitmap.LoadFromResourceId(BitmapId);
     Result.Picture.Graphic:=Bitmap;
     Bitmap.Destroy; {#}
     Result.Parent := Parent;
End;

Function InsertImageName(Parent:TControl;Left,Bottom,Width,Height:LongInt;
  Const BitmapId:String):TImage;
Var  Bitmap:TBitmap;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Bitmap.Create;
     Bitmap.LoadFromResourceName(BitmapId);
     Result.Picture.Graphic:=Bitmap;
     Bitmap.Destroy; {#}
     Result.Parent := Parent;
End;


Function InsertBevel(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Shape:TBevelShape;Style:TBevelStyle):TBevel;
Begin
     Result.Create(parent);
     Result.Shape := Shape;
     Result.Style := Style;
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertPanel(parent:TControl;Left,Bottom,Width,Height:LongInt;
  BevelInner:TPanelBevel;BevelOuter:TPanelBevel;BevelWidth:LongInt;
  Caption:String):TPanel;
Begin
     Result.Create(parent);
     Result.BevelInner:=BevelInner;
     Result.BevelOuter:=BevelOuter;
     Result.BevelWidth:=BevelWidth;
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.parent := parent;
End;


Function InsertRadioGroup(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Caption:String):TRadioGroup;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.parent := parent;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TShape Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TShape.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Shape';
     Height:=100;
     Width:=100;
     ParentPenColor:=False;
     ParentColor:=True;
     TabStop:=False;
     ZOrder:=zoBottom;
     FShape:=stRectangle;
     FTempBrush.Create(Nil);
     //FTempBrush.Color := clWhite;
     FTempPen.Create(Nil);
End;

Procedure TShape.SetupShow;
Begin
     Inherited SetupShow;

     Canvas.Brush:=FTempBrush;
     Canvas.Pen:=FTempPen;
End;

Destructor TShape.Destroy;
Begin
     Inherited Destroy;

     FTempBrush.Destroy;
     FTempPen.Destroy;
End;

Function TShape.GetBrush:TBrush;
Begin
     If Canvas <> Nil Then Result := Canvas.Brush
     Else Result := FTempBrush;
End;

Function TShape.GetPen:TPen;
Begin
     If Canvas <> Nil Then Result := Canvas.Pen
     Else Result := FTempPen;
End;

Procedure TShape.SetShape(NewShape:TShapeType);
Begin
     FShape:=NewShape;
     Invalidate;
End;

Procedure TShape.Redraw(Const rec:TRect);
Var SaveColor:TColor;
    OldPenColor,OldBrushColor:TColor;
    SaveStyle:TBrushStyle;
    Radius,middleX,MiddleY,W,H:LongInt;
    rc:TRect;

    Procedure DrawTriangle;
    Begin
         Canvas.PenPos:=Point(0,0);
         Canvas.LineTo(Width,0);
         Canvas.LineTo(Width Div 2,Height);
         Canvas.LineTo(0,0);
    End;
Begin
     If Canvas = Nil Then exit;
     OldPenColor := Canvas.Pen.Color;
     OldBrushColor := Canvas.Brush.Color;

     SaveColor:=Canvas.Pen.color;

     If Canvas.Brush.Style=bsSolid Then Canvas.Pen.color:=Canvas.Brush.color;

     middleX := ClientWidth Div 2;
     MiddleY := ClientHeight Div 2;

     Case FShape Of
       stTriangle:
       Begin
            Canvas.BeginPath;
            DrawTriangle;
            Canvas.EndPath;
            Canvas.FillPath;
            Canvas.Pen.color:=SaveColor;

            Canvas.BeginPath;
            DrawTriangle;
            Canvas.EndPath;
            Canvas.OutlinePath;

            Canvas.BeginPath;
            DrawTriangle;
            Canvas.EndPath;
            Canvas.PathToClipRegion(paDiff);
       End;
       stRectangle,stSquare:
       Begin
            If FShape=stSquare Then
            Begin
                 If Width>Height Then
                 Begin
                      rc.Bottom:=0;
                      rc.Top:=Height-1;
                      rc.Left:=(Width-Height) Div 2;
                      rc.Right:=rc.Left+Height;
                 End
                 Else
                 Begin
                      rc.Left:=0;
                      rc.Right:=Width-1;
                      rc.Bottom:=(Height-Width) Div 2;
                      rc.Top:=rc.Bottom+Width;
                 End;
            End
            Else rc:=ClientRect;

            Canvas.BeginPath;
            Canvas.Rectangle(rc);
            Canvas.EndPath;
            Canvas.FillPath;
            Canvas.Pen.color:=SaveColor;

            Canvas.BeginPath;
            Canvas.Rectangle(rc);
            Canvas.EndPath;
            Canvas.OutlinePath;

            Canvas.BeginPath;
            Canvas.Rectangle(rc);
            Canvas.EndPath;
            Canvas.PathToClipRegion(paDiff);
       End;
       stRoundRect,stRoundSquare:
       Begin
            If FShape=stRoundSquare Then
            Begin
                 If Width>Height Then
                 Begin
                      rc.Bottom:=0;
                      rc.Top:=Height-1;
                      rc.Left:=(Width-Height) Div 2;
                      rc.Right:=rc.Left+Height;
                 End
                 Else
                 Begin
                      rc.Left:=0;
                      rc.Right:=Width-1;
                      rc.Bottom:=(Height-Width) Div 2;
                      rc.Top:=rc.Bottom+Width;
                 End;
            End
            Else rc:=ClientRect;

            W:=(rc.Right-rc.Left) Div 10;
            H:=(rc.Top-rc.Bottom) Div 10;

            Canvas.BeginPath;
            Canvas.RoundRect(rc,W,H);
            Canvas.EndPath;
            Canvas.FillPath;
            Canvas.Pen.color:=SaveColor;

            Canvas.BeginPath;
            Canvas.RoundRect(rc,W,H);
            Canvas.EndPath;
            Canvas.OutlinePath;

            Canvas.BeginPath;
            Canvas.RoundRect(rc,W,H);
            Canvas.EndPath;
            Canvas.PathToClipRegion(paDiff);
       End;
       stEllipse:
       Begin
           Canvas.BeginPath;
           Canvas.Ellipse(middleX,MiddleY,middleX-1,MiddleY-1);
           Canvas.EndPath;
           Canvas.FillPath;
           Canvas.Pen.color:=SaveColor;

           Canvas.BeginPath;
           Canvas.Ellipse(middleX,MiddleY,middleX-1,MiddleY-1);
           Canvas.EndPath;
           Canvas.OutlinePath;

           Canvas.BeginPath;
           Canvas.Ellipse(middleX,MiddleY,middleX-1,MiddleY-1);
           Canvas.EndPath;
           Canvas.PathToClipRegion(paDiff);
       End;
       stCircle:
       Begin
           If ClientWidth>ClientHeight Then Radius:=MiddleY
           Else Radius:=middleX;

           Canvas.BeginPath;
           Canvas.Circle(middleX,MiddleY,Radius-1);
           Canvas.EndPath;
           Canvas.FillPath;
           Canvas.Pen.color:=SaveColor;

           Canvas.BeginPath;
           Canvas.Circle(middleX,MiddleY,Radius-1);
           Canvas.EndPath;
           Canvas.OutlinePath;

           Canvas.BeginPath;
           Canvas.Circle(middleX,MiddleY,Radius-1);
           Canvas.EndPath;
           Canvas.PathToClipRegion(paDiff);
       End;
     End; //Case

     Canvas.Pen.Color := OldPenColor;
     Canvas.Brush.Color := OldBrushColor;

     SaveColor:=Canvas.Pen.color;
     SaveStyle:=Canvas.Brush.Style;

     Canvas.Pen.color:=color;
     Canvas.Brush.Style:=bsSolid;
     Canvas.Box(rec);

     Canvas.Pen.color:=SaveColor;
     Canvas.Brush.Style:=SaveStyle;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TImage Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TImage.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Image';
     Caption:=Name;
     Width:=50;
     Height:=50;
     ParentPenColor:=False;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     FNeedBitmap:=True;
     ZOrder:=zoBottom;
     FAutoSize:=False;
     FStretch:=True;
     FCenter:=False;

     FPicture.Create(Self);
     FPicture.OnChange := PictureChanged;
End;

Procedure TImage.Change;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;

Procedure TImage.PictureChanged(Sender:TObject);
Begin
    Change;
    Invalidate;
End;


Procedure TImage.SetStretch(NewValue:Boolean);
Begin
     FStretch:=NewValue;
     Invalidate;
End;

Procedure TImage.SetCenter(NewValue:Boolean);
Begin
     FCenter:=NewValue;
     Invalidate;
End;

Procedure TImage.SetBitmap(NewBitmap:TBitmap);
Begin
     Picture.Bitmap := NewBitmap;
End;

Function TImage.GetBitmap:TBitmap;
Begin
     If ((Picture.HasFormat(TBitmap))Or(Picture.Empty)) Then
       Result := Picture.Bitmap
     Else
       Result:=Nil;
End;

Function TImage.GetIcon:TIcon;
Begin
     If ((Picture.HasFormat(TIcon))Or(Picture.Empty)) Then
       Result := Picture.Icon
     Else
       Result:=Nil;
End;

Procedure TImage.SetIcon(NewIcon:TIcon);
Begin
     Picture.Icon:=NewIcon;
End;

Function TImage.GetGraphic:TGraphic;
Begin
     Result:=Picture.Graphic;
End;

Procedure TImage.SetGraphic(NewGraphic:TGraphic);
Begin
     Picture.Graphic:=NewGraphic;
End;

Procedure TImage.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
       If Form Is TForm Then
     Begin
          Form.BringToFront;

          LastMsg.Handled:=True; {!!}
          LastMsg.Result:=0;
     End;
End;

Procedure TImage.Redraw(Const rec:TRect);
Var  rc:TRect;
     X,Y:LongInt;
     aGraphic:TGraphic;
Label proceed;
Begin
     If Canvas = Nil Then Exit;

     If FPicture.Graphic <> Nil Then
       If not FPicture.Graphic.Empty Then
       Begin
            aGraphic := FPicture.Graphic;
            //clear background for icons and pointers
            If    (aGraphic Is TIcon)
               Or (aGraphic Is TPointer)
               Or (aGraphic Is TMetaFile) Then
                 Inherited Redraw(rec);
            goto proceed; // what is the 60's - AaronL
       End;

     Inherited Redraw(rec);

     If Designed Then
     Begin
          Canvas.DeleteClipRegion;
          Canvas.Brush.color:=color;
          Canvas.Pen.color:=clBlack;
          Canvas.TextOut(4,4,Name);
          rc.Left:=1;
          rc.Top:=Height-1;
          rc.Bottom:=1;
          rc.Right:=Width-1;
          Canvas.Rectangle(rc);
     End;
     Exit;

proceed:
     {If aGraphic Is TBitmap Then
       Bitmap.RealizePalette(Canvas);}
     If Stretch Then Canvas.StretchDraw(0,0,Width,Height,aGraphic)
     Else If ((Center)And(aGraphic.Width<=Width)And(aGraphic.Height<=Height)) Then
     Begin
          X:=Width Div 2;
          Y:=Height Div 2;
          Dec(X,aGraphic.Width Div 2);
          Dec(Y,aGraphic.Height Div 2);
          Canvas.Draw(X,Y,aGraphic);
          rc.Left:=X;
          rc.Right:=X+aGraphic.Width-1;
          rc.Bottom:=Y;
          rc.Top:=Y+aGraphic.Height-1;
          Canvas.ExcludeClipRect(rc);
          Inherited Redraw(rec);
     End
     Else
     Begin
          Canvas.Draw(0,0,aGraphic);
          rc.Left:=0;
          rc.Right:=aGraphic.Width-1;
          rc.Bottom:=0;
          rc.Top:=aGraphic.Height-1;
          Canvas.ExcludeClipRect(rc);
          Inherited Redraw(rec);
     End;
End;

Procedure TImage.SetupShow;
Var  needBMP:Boolean;
     aBMP:TBitmap;
Begin
     needBmp := FALSE;

     If Designed Then
       If FNeedBitmap Then
         If ComponentState * [csDetail,csLoaded] = [] Then needBmp := TRUE;

     If FPicture.Graphic <> Nil Then
       If not FPicture.Graphic.Empty Then needBMP := FALSE;


     If needBMP Then
     Begin
          aBMP := Bitmap;

          If CallClassPropertyEditor(aBMP) = peOk Then
          Begin
               Width := aBMP.Width;
               Height := aBMP.Height;
          End
          Else
          Begin
               //aBMP.Destroy;
               Bitmap := Nil;
          End;
     End;

     {$IFDEF OS2}
     If FPicture.Graphic Is TBitmap Then
        Bitmap.RealizePalette(Canvas);
     {$ENDIF}

     Inherited SetupShow;
End;

Destructor TImage.Destroy;
Begin
     If FPicture <> Nil Then
     Begin
        FPicture.Destroy;
        FPicture := Nil;
     End;

     Inherited Destroy;
End;

Procedure TImage.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnPicture Then
     Begin
          If DataLen <> 0 Then Bitmap.ReadSCUResource(rnBitmap,Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TImage.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FPicture.Graphic Is TBitmap
     Then Result := Bitmap.WriteSCUResourceName(Stream,rnPicture);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBevel Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBevel.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Bevel';
     Height:=100;
     Width:=100;
     ParentPenColor:=True;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     ZOrder:=zoBottom;
     FShape:=bsBox;
     FStyle:=bsLowered;
     Include(ComponentState, csAcceptsControls);
End;

Procedure TBevel.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
       If Form Is TForm Then
     Begin
          Form.BringToFront;

          LastMsg.Handled:=True; {!!}
          LastMsg.Result:=0;
     End;
End;

Procedure TBevel.SetShape(NewShape:TBevelShape);
Begin
     FShape := NewShape;
     If Handle <> 0 Then Invalidate;
End;

Procedure TBevel.SetStyle(NewStyle:TBevelStyle);
Begin
     FStyle := NewStyle;
     If Handle <> 0 Then Invalidate;
End;

Procedure TBevel.Redraw(Const rec:TRect);
Var  rc1:TRect;
     RaisedColor:TColor;
     LoweredColor:TColor;
Begin
     If Canvas = Nil Then Exit;
     Inherited Redraw(rec);

     rc1 := ClientRect;

     If FStyle=bsRaised Then
     Begin
          RaisedColor:=clWhite;
          LoweredColor:=clDkGray;
     End
     Else
     Begin
          RaisedColor:=clDkGray;
          LoweredColor:=clWhite;
     End;

     Case FShape Of
         bsBottomLine:
         Begin
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Left,rc1.Bottom,rc1.Right,rc1.Bottom);
              Inc(rc1.Bottom);
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Left,rc1.Bottom,rc1.Right,rc1.Bottom);
         End;
         bsBox:
         Begin
              Canvas.ShadowedBorder(rc1,RaisedColor,LoweredColor);
         End;
         bsFrame:
         Begin
              DrawSystemFrame(Self,rc1,LoweredColor,RaisedColor);
         End;
         bsBorder:
         Begin
              DrawSystemBorder(Self,rc1,bsSingle);  {only lowered}
         End;
         bsLeftLine:
         Begin
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Left,rc1.Bottom);
              Inc(rc1.Left);
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Left,rc1.Bottom);
         End;
         bsRightLine:
         Begin
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Right,rc1.Top,rc1.Right,rc1.Bottom);
              Dec(rc1.Right);
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Right,rc1.Top,rc1.Right,rc1.Bottom);
         End;
         bsTopLine:
         Begin
              Canvas.Pen.color:=RaisedColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Right,rc1.Top);
              Dec(rc1.Top);
              Canvas.Pen.color:=LoweredColor;
              Canvas.Line(rc1.Left,rc1.Top,rc1.Right,rc1.Top);
         End;
     End; {Case}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPanel Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPanel.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Panel';
     Caption:=Name;
     Height:=100;
     Width:=100;
     ParentPenColor:=True;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     ZOrder:=zoBottom;
     FBevelInner:=bvNone;
     FBevelOuter:=bvRaised;
     FBevelWidth:=1;
     FBorderStyle:=bsNone;
     FBorderWidth:=0;
     FAlignment:=taCenter;
     Include(ComponentState, csAcceptsControls);
End;

Procedure TPanel.Redraw(Const rec:TRect);
Var  OuterRaisedColor:TColor;
     OuterLoweredColor:TColor;
     InnerRaisedColor:TColor;
     InnerLoweredColor:TColor;
     rc1:TRect;

  Procedure DrawFrame(rc:TRect;FrameWidth:LongInt;HiColor,LoColor:TColor);
  Var  PointsArray:Array[0..5] Of TPoint;
       offs:LongInt;
  Begin
       offs := FrameWidth-1;

       If FrameWidth > 1 Then
       Begin
            PointsArray[0] := Point(rc.Left,rc.Bottom);
            PointsArray[1] := Point(rc.Left+offs,rc.Bottom+offs);
            PointsArray[2] := Point(rc.Left+offs,rc.Top-offs);
            PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
            PointsArray[4] := Point(rc.Right,rc.Top);
            PointsArray[5] := Point(rc.Left,rc.Top);
            Canvas.Pen.color := HiColor;
            Canvas.Polygon(PointsArray);
            PointsArray[2] := Point(rc.Right-offs,rc.Bottom+offs);
            PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
            PointsArray[4] := Point(rc.Right,rc.Top);
            PointsArray[5] := Point(rc.Right,rc.Bottom);
            Canvas.Pen.color := LoColor;
            Canvas.Polygon(PointsArray);
       End
       Else Canvas.ShadowedBorder(rc1,HiColor,LoColor);
  End;
Begin
     If Canvas = Nil Then Exit;

     If FBevelInner = bvRaised Then
     Begin
          InnerRaisedColor := clBtnHighlight;
          InnerLoweredColor := clBtnShadow;
     End
     Else
     Begin
          InnerRaisedColor := clBtnShadow;
          InnerLoweredColor := clBtnHighlight;
     End;

     If FBevelOuter = bvRaised Then
     Begin
          OuterRaisedColor := clBtnHighlight;
          OuterLoweredColor := clBtnShadow;
     End
     Else
     Begin
          OuterRaisedColor := clBtnShadow;
          OuterLoweredColor := clBtnHighlight;
     End;

     rc1 := ClientRect;
     DrawSystemBorder(Self,rc1,FBorderStyle);

     If FBevelOuter <> bvNone Then
       If FBevelWidth > 0 Then
     Begin
          DrawFrame(rc1,FBevelWidth,OuterRaisedColor,OuterLoweredColor);
          InflateRect(rc1,-FBevelWidth,-FBevelWidth);
     End;

     If FBorderWidth > 0 Then
     Begin
          DrawFrame(rc1,FBorderWidth,color,color);
          InflateRect(rc1,-FBorderWidth,-FBorderWidth);
     End;

     If FBevelInner <> bvNone Then
       If FBevelWidth > 0 Then
     Begin
          DrawFrame(rc1,FBevelWidth,InnerRaisedColor,InnerLoweredColor);
          InflateRect(rc1,-FBevelWidth,-FBevelWidth);
     End;

     FInterior := rc1;
     DrawText(rec);
End;

{$HINTS OFF}
Procedure TPanel.DrawText(Const rec:TRect);
Var  X,Y,CX,CY:LongInt;
Begin
     If Canvas = Nil Then Exit;

     Canvas.FillRect(FInterior,color);
     Canvas.SetClipRegion([FInterior]);

     {Draw Caption}
     If Caption <> '' Then
     Begin
          Canvas.GetTextExtent(Caption,CX,CY);
          Case FAlignment Of
            taLeftJustify:   X := FInterior.Left+1;
            taRightJustify:  X := FInterior.Right-CX;
            taCenter:        X := (Width-CX) Div 2;
          End;
          Y := (Height-CY) Div 2;
          Canvas.Pen.color := PenColor;
          Canvas.Brush.color := color;
          Canvas.TextOut(X,Y,Caption);
     End;

     Canvas.DeleteClipRegion;  {Win95!}
End;
{$HINTS ON}


Procedure TPanel.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
       If Form Is TForm Then
     Begin
          Form.BringToFront;

          LastMsg.Handled:=True; {!!}
          LastMsg.Result:=0;
     End;
End;


Procedure TPanel.SetBevelInner(NewBevel:TPanelBevel);
Begin
     FBevelInner:=NewBevel;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBevelOuter(NewBevel:TPanelBevel);
Begin
     FBevelOuter:=NewBevel;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBevelWidth(NewWidth:LongInt);
Begin
     If NewWidth<0 Then NewWidth:=0;
     FBevelWidth:=NewWidth;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBorderStyle(NewStyle:TBorderStyle);
Begin
     FBorderStyle:=NewStyle;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetBorderWidth(NewWidth:LongInt);
Begin
     If NewWidth<0 Then NewWidth:=0;
     FBorderWidth:=NewWidth;
     If Handle<>0 Then Invalidate;
End;

Procedure TPanel.SetAlignment(ta:TAlignment);
Begin
     FAlignment:=ta;
     If Handle<>0 Then DrawText(ClientRect);
End;

{$HINTS OFF}
Procedure TPanel.CMTextChanged(Var Msg:TMessage);
Begin
     DrawText(ClientRect);
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TRadioGroup Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TRadioGroup.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'RadioGroup';
     Caption := Name;

     FRadios.Create;
     FItems := TStringList.Create;
     TStringList(FItems).OnChange := EvItemsChange;
     FItemIndex := -1;
     FColumns := 1;
End;


Procedure TRadioGroup.SetupShow;
Begin
     Inherited SetupShow;

     UpdateRadios;
     SetItemIndex(FItemIndex);
     ArrangeRadios;
End;


Destructor TRadioGroup.Destroy;
Begin
     SetRadioCount(0);
     FRadios.Destroy;
     FRadios := Nil;
     TStringList(FItems).OnChange := Nil;
     FItems.Destroy;
     FItems := Nil;

     Inherited Destroy;
End;


Procedure TRadioGroup.Resize;
Begin
     Inherited Resize;

     ArrangeRadios;
End;


Procedure TRadioGroup.FontChange;
Var  I:LongInt;
     Radio:TRadioButton;
Begin
     Inherited FontChange;

     For I := 0 To FRadios.Count-1 Do
     Begin
          Radio := TRadioButton(FRadios.Items[I]);
          Radio.Font := Font;
     End;
     ArrangeRadios;
End;


Procedure TRadioGroup.Click;
Begin
     If FOnClick <> Nil Then FOnClick(Self);
End;


Procedure TRadioGroup.SetItemIndex(Value:LongInt);
Begin
     If ComponentState * [csReading] <> [] Then
     Begin
          FItemIndex := Value;
          Exit;
     End;

     If Value < 0 Then Value := -1;
     If Value >= FItems.Count Then Value := FItems.Count-1;

     if Handle <> 0 then
     begin
           // Update the radio buttons
           {deselect old because New Value can be < 0}
           If (FItemIndex >= 0) And (FItemIndex < FRadios.Count)
           Then TRadioButton(FRadios[FItemIndex]).Checked := False;

           FItemIndex := Value;
           If FItemIndex >= 0 {Select New} Then
           Begin
                TRadioButton(FRadios[FItemIndex]).Checked := True;
                If HasFocus then
                     TRadioButton(FRadios[FItemIndex]).Focus;
           End;
           UpdateTabList;

     end
     else
     begin
          // No radios to update yet - AaronL
          FItemIndex := Value;
     end;

     ItemIndexChange;
End;


Procedure TRadioGroup.ItemIndexChange;
Begin
End;


Procedure TRadioGroup.SetColumns(Value:LongInt);
Begin
     If Value <= 0 Then Value := 1;
     If FColumns <> Value Then
     Begin
          FColumns := Value;
          ArrangeRadios;
     End;
End;


Procedure TRadioGroup.SetItems(Value:TStrings);
Begin
     If Value <> FItems Then FItems.Assign(Value);
End;


Procedure TRadioGroup.SetRadioCount(Value:LongInt);
Var  Radio:TRadioButton;
Begin
     While FRadios.Count < Value Do
     Begin
          Radio.Create(Self);
          Include(Radio.ComponentState, csDetail);
          Radio.Font := Font;
          Radio.OnClick := EvRadioClick;
          Radio.TabStop := True;
          Radio.CursorTabStop := true;
          FRadios.Add(Radio);
     End;
     While FRadios.Count > Value Do
     Begin
          Radio := TRadioButton(FRadios.Last);
          FRadios.Remove(Radio);
          Radio.Destroy;
     End;
End;


Function TRadioGroup.GetItemsEnabled(Index:LongInt):Boolean;
Var  Radio:TRadioButton;
Begin
     Radio := TRadioButton(FRadios.Items[Index]);
     Result := Radio.Enabled;
End;


Procedure TRadioGroup.SetItemsEnabled(Index:LongInt;Value:Boolean);
Var  Radio:TRadioButton;
Begin
     Radio := TRadioButton(FRadios.Items[Index]);
     Radio.Enabled := Value;
End;


Procedure TRadioGroup.UpdateRadios;
Var  I:LongInt;
     Radio:TRadioButton;
Begin
     SetRadioCount(FItems.Count);
     For I := 0 To FItems.Count- 1 Do
     Begin
          Radio := TRadioButton(FRadios.Items[I]);
          Radio.Caption := FItems[I];
     End;
     SetItemIndex(FItemIndex);
     ArrangeRadios;
End;


Procedure TRadioGroup.ArrangeRadios;
Const Margin=10;
Var  I:LongInt;
     Radio:TRadioButton;
     RadioWidth:LongInt;
     RadioHeight:LongInt;
     RadiosPerColumn:LongInt;
     XPos,YPos:LongInt;
     rc:TRect;
Begin
     If Handle = 0 Then Exit;
     If FRadios.Count = 0 Then Exit;

     rc := ClientRect;
     Inc(rc.Left,Margin);
     Inc(rc.Bottom,Margin);
     Dec(rc.Right,Margin);
     Dec(rc.Top,Margin+Font.Height);

     RadiosPerColumn :=  (FRadios.Count + FColumns - 1) Div FColumns;
     RadioWidth := (rc.Right - rc.Left) Div FColumns;
     RadioHeight := (rc.Top - rc.Bottom) Div RadiosPerColumn;

     XPos := rc.Left;
     YPos := rc.Top - RadioHeight;
     For I := 0 To FRadios.Count-1 Do
     Begin
          Radio := TRadioButton(FRadios[I]);
          Radio.SetWindowPos(XPos,YPos,RadioWidth,RadioHeight);
          If Radio.parent = Nil Then Radio.parent := Self;

          If ((I+1) Mod RadiosPerColumn) = 0 Then
          Begin
               YPos := rc.Top - RadioHeight;
               Inc(XPos,RadioWidth);
          End
          Else Dec(YPos,RadioHeight);
     End;
End;


{$HINTS OFF}
Procedure TRadioGroup.EvItemsChange(Sender:TObject);
Begin
     If ComponentState * [csReading] = [] Then
     Begin
          UpdateRadios;
     End;
End;
{$HINTS ON}

Procedure TRadioGroup.EvRadioClick(Sender:TObject);
Begin
     FItemIndex := FRadios.IndexOf(Sender);

     UpdateTabList;
     ItemIndexChange;
     Click;
End;


function TRadioGroup.GetTabStop:boolean;
Begin
     result := FIsTabStop;
End;

procedure TRadioGroup.UpdateTabList;
Begin
     If Handle = 0 then
          exit;
     if FTabList = nil then
        FTabList := TList.Create;
     FTabList.Clear;
     If not FIsTabStop then
          exit;
     if FRadios.Count = 0 then
          exit;

     If FItemIndex >= 0 {Select New} Then
     Begin
          FTabList.Add(FRadios[FItemIndex]);
     End
     Else If FRadios.Count > 0 Then
     Begin
          // tabbing will go to the first radio...
          FTabList.Add(FRadios[0]);
     End;
End;

procedure TRadioGroup.SetTabStop(Value:boolean);
Begin
     FIsTabStop := Value;
     UpdateTabList;
End;

procedure TRadioGroup.WMFocussing( Var Msg: TMessage );
Begin
     if FItemIndex <> -1 then
          Msg.Result := LONGWORD( FRadios[ FItemIndex ] );
     Msg.Handled := true;
End;


Function TRadioGroup.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     aText := Items.GetText;
     If aText <> Nil Then
     Begin
          Result := Stream.NewResourceEntry(rnItems,aText^,Length(aText^)+1);
          StrDispose(aText);
     End;
End;


Procedure TRadioGroup.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
     If ResName = rnItems Then
     Begin
          aText := @Data;
          Items.SetText(aText);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPaintBox Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPaintBox.SetupComponent;
Begin
     Inherited SetupComponent;
     Name:='PaintBox';
     Height:=200;
     Width:=200;
     ParentPenColor:=True;
     ParentColor:=True;
     TabStop:=False;
     ZOrder:=zoBottom;
End;


Procedure TPaintBox.Redraw(Const rec:TRect);
Var rc:TRect;
Begin
     Inherited Redraw(rec);

     If Designed Then
     Begin
          rc:=ClientRect;
          Canvas.Brush.color:=color;
          Canvas.Pen.color:=clBlack;
          Canvas.TextOut(20,20,'PaintBox');
          Canvas.Pen.Style := psDash;
          Canvas.Brush.Style := bsClear;
          Canvas.Rectangle(rc);
     End;
End;


Begin
End.

