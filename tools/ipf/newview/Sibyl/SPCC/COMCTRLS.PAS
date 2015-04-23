
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit ComCtrls;


Interface

Uses Messages,Classes,Forms,Graphics,Buttons,ExtCtrls,Dos;

Type
    {$M+}
    TProgressString=(psPercent,psCaption,psPosition);
    TProgressOrigin=(poLeft,poRight,poBottom,poTop);
    {$M-}

    TProgressBar=Class(TControl)
      Protected
         FBorderStyle:TBorderStyle;
         FInterior:TRect;
         FMin:LongInt;
         FMax:LongInt;
         FPosition:LongInt;
         FBitmap:TBitmap;
         FProgressString:TProgressString;
         FOrigin:TProgressOrigin;
         FOnChange:TNotifyEvent;
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
         Procedure SetBorderStyle(bs:TBorderStyle);
         Procedure SetMin(lr:LongInt);
         Procedure SetMax(hr:LongInt);
         Procedure SetPosition(ps:LongInt);
         Procedure SetProgressString(ps:TProgressString);
         Procedure SetBitmap(NewBitmap:TBitmap);
         Function GetBitmap:TBitmap;
         Procedure SetOrigin(NewOrigin:TProgressOrigin);
         Procedure DrawInterior(Const rec:TRect);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Change;Virtual;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Destructor Destroy;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property Bitmap:TBitmap Read GetBitmap Write SetBitmap;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property Caption;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property Origin:TProgressOrigin Read FOrigin Write SetOrigin;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ProgressString:TProgressString Read FProgressString Write SetProgressString;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    {$M+}
    TUDOrientation=(udHorizontal,udVertical);
    TUDAlignButton=(udLeft,udRight,udBottom,udTop,udNone);
    TUDBtnType=(btNext,btPrev);

    TOnUDChangingEvent=Procedure(Sender:TComponent;Var AllowChange:Boolean) Of Object;
    TOnUDClickEvent=Procedure(Sender:TComponent;Button:TUDBtnType) Of Object;
    {$M-}

    TUpDown=Class(TControl)
      Protected
         FArrowKeys:Boolean;
         FIncrement:LongInt;
         FMin:LongInt;
         FMax:LongInt;
         FOrientation:TUDOrientation;
         FPosition:LongInt;
         FThousands:Boolean;
         FWrap:Boolean;
         FAssociate:TControl;
         FAlignButton:TUDAlignButton;
         FUpRightButton:TSpeedButton;
         FDownLeftButton:TSpeedButton;
         FOnChanging:TOnUDChangingEvent;
         FOnClick:TOnUDClickEvent;
         Procedure SetAssociate(NewControl:TControl);
         Procedure SetMin(NewValue:LongInt);
         Procedure SetMax(NewValue:LongInt);
         Procedure SetOrientation(NewValue:TUDOrientation);
         Procedure SetPosition(NewValue:LongInt);
         Procedure SetAlignButton(NewValue:TUDAlignButton);
         Procedure AlignButtons;
         Procedure EvButtonClick(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Resize;Override;
         Function CanChange:Boolean;Virtual;
         Procedure Click(Button:TUDBtnType);Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
      Public
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property AlignButton:TUDAlignButton Read FAlignButton Write SetAlignButton;
         Property ArrowKeys:Boolean Read FArrowKeys Write FArrowKeys;
         Property Associate:TControl Read FAssociate Write SetAssociate;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Increment:LongInt Read FIncrement Write FIncrement;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property Orientation:TUDOrientation Read FOrientation Write SetOrientation;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentShowHint;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Thousands:Boolean Read FThousands Write FThousands;
         Property Visible;
         Property Wrap:Boolean Read FWrap Write FWrap;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChanging:TOnUDChangingEvent Read FOnChanging Write FOnChanging;
         Property OnClick:TOnUDClickEvent Read FOnClick Write FOnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    {$M+}
    TTrackBarOrientation=(trHorizontal,trVertical);
    TTickMarks=(tmBoth,tmBottomRight,tmTopLeft);
    TTickStyle=(tsAuto,tsManual,tsNone);
    TTrackBarSelMode=(smManual,smAuto);
    TTrackSliderShape=(tsArrow,tsBox);
    TTrackSliderSize=(tssAuto,tssVeryLarge,tssLarge,tssMedium,tssSmall);
    {$M-}

    TTrackBar=Class(TControl)
      Protected
         FPosition:LongInt;
         FLineSize:LongInt;
         FPageSize:LongInt;
         FMax:LongInt;
         FMin:LongInt;
         FOrientation:TTrackBarOrientation;
         FSelEnd:LongInt;
         FSelStart:LongInt;
         FTickMarks:TTickMarks;
         FTickStyle:TTickStyle;
         FFrequency:LongInt;
         FTracking:Boolean;
         FSelMode:TTrackBarSelMode;
         FTickSize:LongInt;
         FTrackTimer:TTimer;
         FSliderShape:TTrackSliderShape;
         FOnChange:TNotifyEvent;
         FTicks:TList;
         FUpdating:Boolean;
         FShowFocusRect:Boolean;
         FSliderSize:TTrackSliderSize;
         Procedure SetMax(NewValue:LongInt);
         Procedure SetMin(NewValue:LongInt);
         Procedure SetOrientation(NewValue:TTrackBarOrientation);
         Procedure SetPosition(NewValue:LongInt);
         Procedure SetSelEnd(NewValue:LongInt);
         Procedure SetSelStart(NewValue:LongInt);
         Procedure SetTickMarks(NewValue:TTickMarks);
         Procedure SetTickStyle(NewValue:TTickStyle);
         Procedure SetFrequency(NewValue:LongInt);
         Procedure SetSliderSize(NewSize:TTrackSliderSize);
         Procedure SetSelMode(NewMode:TTrackBarSelMode);
         Procedure DrawTrack(SliderW,SliderH:LongInt);
         Procedure DrawSlider(SliderW,SliderH:LongInt);
         Procedure GetSliderExtent(Var SliderWidth,SliderHeight:LongInt);
         Function PosInsideSlider(X,Y:LongInt):Boolean;
         Function PosInsideTrack(X,Y:LongInt):Boolean;
         Procedure UpdateSlider;
         Procedure EvTimer(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure Change;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Function CoordFromPos(Position:LongInt):LongInt;
         Function PosFromCoord(Coord:LongInt):LongInt;
         Procedure SetTick(Pos:LongInt);
         Procedure ClearTicks;
         Procedure BeginUpdate;
         Procedure EndUpdate;
         Property Tracking:Boolean Read FTracking;
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
         Property Frequency:LongInt Read FFrequency Write SetFrequency;
         Property LineSize:LongInt Read FLineSize Write FLineSize;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property Orientation:TTrackBarOrientation Read FOrientation Write SetOrientation;
         Property PageSize:LongInt Read FPageSize Write FPageSize;
         Property ParentColor;
         Property ParentShowHint;
         Property PopupMenu;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property SelEnd:LongInt Read FSelEnd Write SetSelEnd;
         Property SelMode:TTrackBarSelMode Read FSelMode Write SetSelMode;
         Property SelStart:LongInt Read FSelStart Write SetSelStart;
         Property ShowFocusRect:Boolean Read FShowFocusRect Write FShowFocusRect;
         Property ShowHint;
         Property SliderSize:TTrackSliderSize Read FSliderSize Write SetSliderSize;
         Property TabOrder;
         Property TabStop;
         Property TickMarks:TTickMarks Read FTickMarks Write SetTickMarks;
         Property TickStyle:TTickStyle Read FTickStyle Write SetTickStyle;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

    {$M+}
    TStatusPanelStyle=(psText, psOwnerDraw);
    TStatusPanelBevel=(pbNone, pbLowered, pbRaised);
    {$M-}

    TStatusPanel=Class(TCollectionItem)
      Protected
         FText:PString;
         FWidth:LongInt;
         FAlignment:TAlignment;
         FBevel:TStatusPanelBevel;
         FStyle:TStatusPanelStyle;
      Protected
         Function GetText:String;
         Procedure SetText(Const NewValue:String);
         Procedure SetWidth(NewValue:LongInt);
         Procedure SetAlignment(NewValue:TAlignment);
         Procedure SetBevel(NewValue:TStatusPanelBevel);
         Procedure SetStyle(NewValue:TStatusPanelStyle);
      Public
         Constructor Create(ACollection:TCollection);Override;
         Destructor Destroy;Override;
         Procedure Assign(Source:TCollectionItem);Override;
      Published
         Property Text:String Read GetText Write SetText;
         Property Width:LongInt Read FWidth Write SetWidth;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property Bevel:TStatusPanelBevel Read FBevel Write SetBevel;
         Property Style:TStatusPanelStyle Read FStyle Write SetStyle;
    End;

    TStatusBar=Class;

    {$HINTS OFF}
    TStatusPanels=Class(TCollection)
      Protected
         FStatusBar:TStatusBar;
         Function GetItem(Index:LongInt):TStatusPanel;
         Procedure SetItem(Index:LongInt;Value:TStatusPanel);
      Public
         Procedure Update(Item:TCollectionItem);Override;
         Procedure SetupComponent;Override;
         Function Add:TStatusPanel;
      Public
         Property Items[Index:LongInt]:TStatusPanel Read GetItem Write SetItem;Default;
         Property StatusBar:TStatusBar Read FStatusBar;
    End;
    {$HINTS ON}

    {$M+}
    TDrawPanelEvent=Procedure(StatusBar:TStatusBar;Panel:TStatusPanel;Const rc:TRect) Of Object;
    {$M-}

    TStatusBar=Class(TBevel)
      Protected
         FSimpleText:String;
         FSimplePanel:Boolean;
         FPanels:TStatusPanels;
         FSizeGrip:Boolean;
         FSpacing:LongInt;
         FOnDrawPanel:TDrawPanelEvent;
         Procedure SetSimpleText(Const NewText:String);
         Procedure SetSimplePanel(NewValue:Boolean);
         Procedure SetPanels(NewValue:TStatusPanels);
         Procedure SetSizeGrip(NewValue:Boolean);
         Procedure UpdatePanel(Panel:TStatusPanel);
         Procedure SetSpacing(NewValue:LongInt);
         Property Shape;
      Protected
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Procedure DrawPanel(Panel:TStatusPanel;Const rc:TRect);Virtual;
         Function IsPointOnSizeGrip(X,Y:longint):Boolean;
         Procedure MouseDown(Button:TMouseButton;
                             ShiftState:TShiftState;
                             X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;
                             X,Y:LongInt);Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Published
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnSetupShow;
         Property OnStartDrag;
         Property OnClick;
         Property OnDblClick;
         Property Panels:TStatusPanels Read FPanels Write SetPanels;
         Property SimpleText:String Read FSimpleText Write SetSimpleText;
         Property SimplePanel:Boolean Read FSimplePanel Write SetSimplePanel;
         Property SizeGrip:Boolean Read FSizeGrip Write SetSizeGrip;
         Property OnDrawPanel:TDrawPanelEvent Read FOnDrawPanel Write FOnDrawPanel;
         Property Spacing:LongInt Read FSpacing Write SetSpacing;
    End;

    THeaderControl=Class;

    {$M+}
    THeaderSectionStyle=(hsText,hsOwnerDraw);
    {$M-}

    THeaderSection=Class(TCollectionItem)
      Protected
         FText:PString;
         FWidth:LongInt;
         FMinWidth:LongInt;
         FMaxWidth:LongInt;
         FAlignment:TAlignment;
         FStyle:THeaderSectionStyle;
         FAllowClick:Boolean;
         FAllowSize:Boolean;
      Protected
         Function GetText:String;
         Procedure SetText(Const NewValue:String);
         Procedure SetWidth(NewValue:LongInt);
         Function GetLeft:LongInt;
         Function GetRight:LongInt;
         Procedure SetStyle(NewValue:THeaderSectionStyle);
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
         Property Style:THeaderSectionStyle Read FStyle Write SetStyle;
    End;

    {$HINTS OFF}
    THeaderSections=Class(TCollection)
      Protected
         FHeaderControl:THeaderControl;
         Function GetItem(Index:LongInt):THeaderSection;
         Procedure SetItem(Index:LongInt;NewValue:THeaderSection);
      Public
         Procedure Update(Item:TCollectionItem);Override;
         Procedure SetupComponent;Override;
         Function Add:THeaderSection;
      Public
         Property Items[Index:LongInt]:THeaderSection Read GetItem Write SetItem;Default;
         Property HeaderControl:THeaderControl Read FHeaderControl;
    End;
    {$HINTS ON}
    THeaderSectionsClass=Class Of THeaderSections;

    {$M+}
    TSectionTrackState=(tsTrackBegin,tsTrackMove,tsTrackEnd);

    TSectionNotifyEvent=Procedure(HeaderControl:THeaderControl;section:THeaderSection) Of Object;
    TDrawSectionEvent=Procedure(HeaderControl:THeaderControl;section:THeaderSection;
                                Const rc:TRect;Pressed:Boolean) Of Object;
    TSectionTrackEvent=Procedure(HeaderControl:THeaderControl;section:THeaderSection;
                                 Width:LongInt;State:TSectionTrackState) Of Object;

    THeaderControl=Class(TControl)
      Protected
         FSections:THeaderSections;
         FSpacing:LongInt;
         FOnDrawSection:TDrawSectionEvent;
         FOnSectionClick:TSectionNotifyEvent;
         FOnSectionResize:TSectionNotifyEvent;
         FOnSectionTrack:TSectionTrackEvent;
         FSectionTrackState:TSectionTrackState;
         FClickSection:THeaderSection;
         FClickBase:THeaderSection;
         FSizeStartX:LongInt;
         FSizeX:LongInt;
         FSizeSection:THeaderSection;
         FBevelWidth:LongInt;
         FShape:TCursor;
         FSectionsClass:THeaderSectionsClass;
      Protected
         Procedure SetSections(NewValue:THeaderSections);
         Procedure SetSpacing(NewValue:LongInt);
         Procedure SetBevelWidth(NewValue:LongInt);
         Function GetSections:THeaderSections;
      Protected
         Function GetMouseHeader(X,Y:LongInt):THeaderSection;Virtual;
         Procedure UpdateHeader(Header:THeaderSection);Virtual;
         Procedure DrawSection(section:THeaderSection;Const rc:TRect;Pressed:Boolean);Virtual;
         Procedure SectionClick(section:THeaderSection);Virtual;
         Procedure SectionResize(section:THeaderSection);Virtual;
         Procedure SectionTrack(section:THeaderSection;Width:LongInt;State:TSectionTrackState);Virtual;
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
      Protected
         Property ClickSection:THeaderSection read FClickSection write FClickSection;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Public
         Property SectionsClass:THeaderSectionsClass read FSectionsClass write FSectionsClass;
      Published
         Property Align;
         Property BevelWidth:LongInt Read FBevelWidth Write SetBevelWidth;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Sections:THeaderSections Read GetSections Write SetSections;
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
         Property OnSectionClick:TSectionNotifyEvent Read FOnSectionClick Write FOnSectionClick;
         Property OnDrawSection:TDrawSectionEvent Read FOnDrawSection Write FOnDrawSection;
         Property OnSectionResize:TSectionNotifyEvent Read FOnSectionResize Write FOnSectionResize;
         Property OnSectionTrack:TSectionTrackEvent Read FOnSectionTrack Write FOnSectionTrack;
    End;

    THeader=Class(THeaderControl)  //For Delphi 1.0 compatibility
      Protected
         Function GetSectionWidth(Index:LongInt):LongInt;
         Procedure SetSectionWidth(Index:LongInt;NewValue:LongInt);
      Public
         Property SectionWidth[Index:LongInt]:LongInt Read GetSectionWidth Write SetSectionWidth;
    End;

Function InsertProgressBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TProgressBar;
Function InsertUpDown(parent:TControl;Left,Bottom,Width,Height:LongInt):TUpDown;
Function InsertTrackBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TTrackBar;
Function InsertStatusBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TStatusBar;
Function InsertHeaderControl(parent:TControl;Left,Bottom,Width,Height:LongInt):THeaderControl;

Implementation

{$IFDEF OS2}
Uses PmWin;
{$ENDIF}

{$IFDEF WIN32}
Uses WinUser;
{$ENDIF}

Function InsertProgressBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TProgressBar;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertUpDown(parent:TControl;Left,Bottom,Width,Height:LongInt):TUpDown;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertTrackBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TTrackBar;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;

Function InsertStatusBar(parent:TControl;Left,Bottom,Width,Height:LongInt):TStatusBar;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;

Function InsertHeaderControl(parent:TControl;Left,Bottom,Width,Height:LongInt):THeaderControl;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TProgressBar Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TProgressBar.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnBitmap Then
     Begin
          If DataLen <> 0 Then Bitmap.ReadSCUResource(rnBitmap,Data,DataLen);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TProgressBar.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FBitmap <> Nil
     Then Result := FBitmap.WriteSCUResourceName(Stream,rnBitmap);
End;


Procedure TProgressBar.SetBitmap(NewBitmap:TBitmap);
Var  OldBitmap:TBitmap;
Begin
     OldBitmap := FBitmap;

     {Create internal Copy}
     If NewBitmap <> Nil Then FBitmap := NewBitmap.Copy
     Else FBitmap := Nil;

     If FBitmap <> Nil Then Include(FBitmap.ComponentState, csDetail);

     If OldBitmap <> Nil Then
       If OldBitmap <> NewBitmap Then OldBitmap.Destroy;

     If Handle <> 0 Then Invalidate;
End;


Function TProgressBar.GetBitmap:TBitmap;
Begin
     If FBitmap = Nil Then
     Begin
          FBitmap.Create;
          Include(FBitmap.ComponentState, csDetail);
     End;
     Result := FBitmap;
End;


{$HINTS OFF}
Procedure TProgressBar.CMTextChanged(Var Msg:TMessage);
Begin
     DrawInterior(ClientRect);
End;
{$HINTS ON}


Procedure TProgressBar.SetBorderStyle(bs:TBorderStyle);
Begin
     FBorderStyle := bs;
     If Handle<>0 Then Invalidate;
End;


Procedure TProgressBar.SetMin(lr:LongInt);
Begin
     If lr > FMax Then Exit;
     FMin := lr;
     If Handle<>0 Then DrawInterior(ClientRect);
     Change;
End;


Procedure TProgressBar.SetMax(hr:LongInt);
Begin
     If hr < FMin Then Exit;
     FMax := hr;
     If Handle<>0 Then DrawInterior(ClientRect);
     Change;
End;


Procedure TProgressBar.SetPosition(ps:LongInt);
Begin
     FPosition := ps;
     If Handle<>0 Then DrawInterior(ClientRect);
     Change;
End;


Procedure TProgressBar.SetProgressString(ps:TProgressString);
Begin
     FProgressString := ps;
     If Handle<>0 Then DrawInterior(ClientRect);
End;


Procedure TProgressBar.SetOrigin(NewOrigin:TProgressOrigin);
Begin
     FOrigin := NewOrigin;
     If Handle<>0 Then DrawInterior(ClientRect);
End;


{$HINTS OFF}
Procedure TProgressBar.DrawInterior(Const rec:TRect);
Var  X,Y,CX,CY,xm,ym:LongInt;
     Percent:LongInt;
     rec1:TRect;
     S:String;
Begin
     If Canvas = Nil Then Exit;
     If FMax = FMin Then
     Begin
          If FPosition < FMin Then Percent := 0
          Else Percent := 100;
     End
     Else Percent := ((FPosition-FMin) * 100) Div (FMax-FMin);
     If Percent < 0 Then Percent := 0;
     If Percent > 100 Then Percent := 100;

     If Percent <> 0 Then
     Begin
          Case FOrigin Of
            poLeft:
            Begin
                 xm := ((FInterior.Right-FInterior.Left) * Percent) Div 100;
                 Inc(xm,FInterior.Left);
            End;
            poRight:
            Begin
                 xm := ((FInterior.Right-FInterior.Left) * Percent) Div 100;
                 xm := FInterior.Right - xm;
            End;
            poBottom:
            Begin
                 ym := ((FInterior.Top-FInterior.Bottom) * Percent) Div 100;
                 Inc(ym,FInterior.Bottom);
            End;
            poTop:
            Begin
                 ym := ((FInterior.Top-FInterior.Bottom) * Percent) Div 100;
                 ym := FInterior.Top - ym;
            End;
          End;
     End
     Else
     Begin
          Case FOrigin Of
            poLeft:   xm := FInterior.Left-1;
            poRight:  xm := FInterior.Right+1;
            poBottom: ym := FInterior.Bottom-1;
            poTop:    ym := FInterior.Top+1;
          End;
     End;

     Case FProgressString Of
         psCaption:  S := Caption;
         psPosition: S := tostr(FPosition) + Caption;
         psPercent:  S := tostr(Percent) + ' %' + Caption;
     End;
     Canvas.GetTextExtent(S,CX,CY);
     Inc(CX);
     X := FInterior.Left + (FInterior.Right-FInterior.Left-CX) Div 2;
     Y := FInterior.Bottom + (FInterior.Top-FInterior.Bottom-CY) Div 2;
     If Y < FInterior.Bottom Then Y := FInterior.Bottom;

     If (FBitmap <> Nil) And (Not FBitmap.Empty)
     Then Canvas.Brush.Mode := bmTransparent
     Else Canvas.Brush.Mode := bmOpaque;

     rec1 := FInterior;
     Case FOrigin Of
       poLeft:   rec1.Right := xm;
       poRight:  rec1.Left := xm;
       poBottom: rec1.Top := ym;
       poTop:    rec1.Bottom := ym;
     End;
     Canvas.SetClipRegion([rec1]);
     If (FBitmap <> Nil) And (Not FBitmap.Empty) Then
     Begin
          Canvas.StretchDraw(FInterior.Left,
                             FInterior.Bottom,
                             FInterior.Right-FInterior.Left,
                             FInterior.Top-FInterior.Bottom,
                             FBitmap);
     End
     Else Canvas.FillRect(ClientRect,PenColor);

     Canvas.Pen.color := color;
     Canvas.Brush.color := PenColor;
     Canvas.Brush.Mode := bmTransparent;
     Canvas.TextOut(X,Y,S);

     rec1 := FInterior;
     Case FOrigin Of
       poLeft:   rec1.Left := xm+1;
       poRight:  rec1.Right := xm-1;
       poBottom: rec1.Bottom := ym+1;
       poTop:    rec1.Top := ym-1;
     End;
     Canvas.SetClipRegion([rec1]);
     Canvas.FillRect(ClientRect,color);

     Canvas.Pen.color := PenColor;
     Canvas.Brush.color := color;
     Canvas.TextOut(X,Y,S);
End;
{$HINTS ON}


Procedure TProgressBar.Redraw(Const rec:TRect);
Begin
     If Canvas = Nil Then Exit;

     FInterior:=ClientRect;

     DrawSystemBorder(Self,FInterior,FBorderStyle);

     DrawInterior(rec);
End;


Procedure TProgressBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'ProgressBar';
     Width := 200;
     Height := 25;
     PenColor := clHighlight;
     ParentPenColor := False;
     ParentColor := True;
     TabStop := False;

     FBorderStyle := bsSingle;
     FMin := 0;
     FMax := 100;
     FPosition := 0;
     FProgressString := psPercent;
     FBitmap := Nil;
     FOrigin := poLeft;
End;


Procedure TProgressBar.SetupShow;
Var  I:LongInt;
Begin
     Inherited SetupShow;

     If FBorderStyle = bsNone Then I := 1
     Else I := 3;
     FInterior := ClientRect;
     Forms.InflateRect(FInterior,-I,-I);
End;


Procedure TProgressBar.Change;
Begin
     If FOnChange <> Nil Then FOnChange(Self);
End;


Destructor TProgressBar.Destroy;
Begin
     If FBitmap <> Nil Then FBitmap.Destroy;
     FBitmap := Nil;

     Inherited Destroy;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TUpDown Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TUpDownBtn=Class(TSpeedButton)
      Protected
         FUp:Boolean;
         FTimer:TTimer;
      Protected
        Procedure SetupComponent;Override;
      Public
        Procedure Redraw(Const rec:TRect);Override;
        Procedure OnTimer(Sender:TObject);
        Procedure OnMDown(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
        Procedure OnMUp(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
    End;

Procedure TUpDownBtn.SetupComponent;
Begin
     Inherited SetupComponent;
     Include(ComponentState, csDetail);
     Caption := '';
     ParentPenColor := True;
     FTimer.Create(Self);
     FTimer.Interval:=400;
     FTimer.OnTimer:=OnTimer;
     OnMouseDown:=OnMDown;
     OnMouseUp:=OnMUp;
End;

Procedure TUpDownBtn.OnMDown(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     FTimer.Stop;
     FTimer.Interval:=400;
     FTimer.Start;
End;

Procedure TUpDownBtn.OnMUp(Sender:TObject;Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     FTimer.Stop;
End;

Procedure TUpDownBtn.OnTimer(Sender:TObject);
Begin
     FTimer.Stop;
     OnClick(Self);
     FTimer.Interval:=150;
     FTimer.Start;
End;

Procedure TUpDownBtn.Redraw(Const rec:TRect);
Var pts:Array[0..2] Of TPoint;
    WH:LongInt;
    space:LongInt;
Const MinSpace=2;
Begin
     Inherited Redraw(rec);

     Canvas.ClipRect:=rec;

     WH:=Height;
     If Width<WH Then WH:=Width;
     Dec(WH,4);
     If WH<1 Then WH:=1;
     space:=WH Div 5;
     If space<MinSpace Then space:=MinSpace;
     Dec(WH,space*2);

     If TUpDown(Owner).Orientation=udHorizontal Then
     Begin
          pts[0].X:=(Width-WH) Div 2;
          If Down Then Inc(pts[0].X);
          If pts[0].X<MinSpace Then pts[0].X:=MinSpace;

          If FUp Then  //Pfeil nach rechts
          Begin
               pts[0].Y:=Height-((Height-WH) Div 2);
               If pts[0].Y>Height-MinSpace Then pts[0].Y:=Height-MinSpace;

          End
          Else //Pfeil nach links
          Begin
               pts[0].Y:=Height Div 2;
               If pts[0].Y<MinSpace Then pts[0].Y:=MinSpace;
          End;
          If Down Then Dec(pts[0].Y);

          pts[1].X:=Width-((Width-WH) Div 2);
          If Down Then Inc(pts[1].X);
          If pts[1].X>Width-MinSpace Then pts[1].X:=Width-MinSpace;

          If FUp Then
          Begin
               pts[1].Y:=Height Div 2;
               If pts[1].Y<MinSpace Then pts[1].Y:=MinSpace;
          End
          Else
          Begin
               pts[1].Y:=Height-((Height-WH) Div 2);
               If pts[1].Y>Height-MinSpace Then pts[1].Y:=Height-MinSpace;
          End;
          If Down Then Dec(pts[1].Y);

          If FUp Then pts[2].X:=pts[0].X
          Else pts[2].X:=pts[1].X;

          pts[2].Y:=(Height-WH) Div 2;
          If pts[2].Y<MinSpace Then pts[2].Y:=MinSpace;
          If Down Then Dec(pts[2].Y);
     End
     Else
     Begin
          pts[0].X:=(Width-WH) Div 2;
          If Down Then Inc(pts[0].X);
          If pts[0].X<MinSpace Then pts[0].X:=MinSpace;

          If FUp Then
          Begin
               pts[0].Y:=(Height-WH) Div 2;
               If pts[0].Y<MinSpace Then pts[0].Y:=MinSpace;
          End
          Else
          Begin
               pts[0].Y:=Height-((Height-WH) Div 2);
               If pts[0].Y>Height-MinSpace Then pts[0].Y:=Height-MinSpace;
          End;
          If Down Then Dec(pts[0].Y);

          pts[1].X:=Width-((Width-WH) Div 2);
          If Down Then Inc(pts[1].X);
          If pts[1].X>Width-MinSpace Then pts[1].X:=Width-MinSpace;

          pts[1].Y:=pts[0].Y;

          pts[2].X:=pts[0].X+WH Div 2;
          If Down Then Inc(pts[2].X);

          If FUp Then
          Begin
               pts[2].Y:=Height-((Height-WH) Div 2);
               If pts[2].Y>Height-MinSpace Then pts[2].Y:=Height-MinSpace;
          End
          Else
          Begin
               pts[2].Y:=(Height-WH) Div 2;
               If pts[2].Y<MinSpace Then pts[2].Y:=MinSpace;
          End;
          If Down Then Dec(pts[2].Y);
     End;

     Canvas.Pen.color:=PenColor;
     Canvas.BeginPath;
     Canvas.Polygon(pts);
     Canvas.EndPath;
     Canvas.FillPath;
End;

///////////////////////////////////////////////////////////////////////

Procedure TUpDown.SetAssociate(NewControl:TControl);
Begin
     If NewControl=Self Then Exit;

     If FAssociate<>Nil Then FAssociate.Notification(Self,opRemove);
     FAssociate := NewControl;
     If FAssociate <> Nil Then FAssociate.FreeNotification(Self);
     AlignButton := FAlignButton;

     If Associate<>Nil Then
     Begin
          If Associate Is TScrollBar Then TScrollBar(Associate).Position:=FMin
          Else If Associate Is TProgressBar Then TProgressBar(Associate).Position:=FMin
          Else If Associate Is TTrackBar Then TTrackBar(Associate).Position:=FMin
          Else Associate.Caption:=tostr(FMin);
     End;
End;


Procedure TUpDown.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FAssociate Then FAssociate := Nil;
End;


Procedure TUpDown.SetOrientation(NewValue:TUDOrientation);
Begin
     FOrientation:=NewValue;
     AlignButtons;
End;


Procedure TUpDown.SetPosition(NewValue:LongInt);
Begin
     If NewValue<Min Then NewValue:=Min;
     If NewValue>Max Then NewValue:=Max;
     If NewValue=FPosition Then Exit;
     FPosition:=NewValue;
     If Associate<>Nil Then
     Begin
          If Associate Is TScrollBar Then TScrollBar(Associate).Position:=FPosition
          Else If Associate Is TProgressBar Then TProgressBar(Associate).Position:=FPosition
          Else If Associate Is TTrackBar Then TTrackBar(Associate).Position:=FPosition
          Else Associate.Caption:=tostr(FPosition);
     End;
End;


Procedure TUpDown.SetMin(NewValue:LongInt);
Begin
     If NewValue>Max Then Exit;
     FMin:=NewValue;
     If Position<FMin Then Position:=FMin;
End;


Procedure TUpDown.SetMax(NewValue:LongInt);
Begin
     If NewValue<Min Then Exit;
     FMax:=NewValue;
     If Position>FMax Then Position:=FMax;
End;


Procedure TUpDown.SetAlignButton(NewValue:TUDAlignButton);
Begin
     FAlignButton:=NewValue;
     If Associate Is TControl Then
     Case AlignButton Of
       udRight:  SetWindowPos(Associate.Left+Associate.Width,Associate.Bottom,
                              Width,Height);
       udLeft:   SetWindowPos(Associate.Left-Width,Associate.Bottom,
                              Width,Height);
       udTop:    SetWindowPos(Associate.Left,Associate.Bottom+Associate.Height,
                              Width,Height);
       udBottom: SetWindowPos(Associate.Left,Associate.Bottom-Height,
                              Width,Height);
     End;
End;


Function GetUpRightButton(UpDown:TUpDown):TSpeedButton;
Begin
     Result:=UpDown.FUpRightButton;
End;

Function GetDownLeftButton(UpDown:TUpDown):TSpeedButton;
Begin
     Result:=UpDown.FDownLeftButton;
End;

Procedure TUpDown.SetupComponent;
Begin
     Inherited SetupComponent;

     ParentColor:=True;
     FArrowKeys:=True;
     FIncrement:=1;
     FMin:=0;
     FMax:=10;
     FPosition:=0;
     FThousands:=True;
     FWrap:=False;
     Name:='UpDown';
     ParentColor:=True;
     PenColor:=clBlack;
     Width:=39;
     Height:=50;
     FAlignButton:=udNone;
     FOrientation:=udVertical;

     FUpRightButton:=TUpDownBtn.Create(Self);
     TUpDownBtn(FUpRightButton).FUp:=True;
     TUpDownBtn(FUpRightButton).OnClick:=EvButtonClick;
     InsertControl(FUpRightButton);
     FDownLeftButton:=TUpDownBtn.Create(Self);
     TUpDownBtn(FDownLeftButton).OnClick:=EvButtonClick;
     InsertControl(FDownLeftButton);
End;


Procedure TUpDown.AlignButtons;
Begin
     Case FOrientation Of
         udHorizontal:
         Begin
              FDownLeftButton.SetWindowPos(0,0,(Width Div 2),Height);
              FUpRightButton.SetWindowPos((Width Div 2),0,(Width Div 2),Height);
         End;
         udVertical:
         Begin
              FDownLeftButton.SetWindowPos(0,0,Width,(Height Div 2));
              FUpRightButton.SetWindowPos(0,(Height Div 2),Width,(Height Div 2));
         End;
     End;
End;


Procedure TUpDown.SetupShow;
Begin
     Inherited SetupShow;

     AlignButtons;
End;


Procedure TUpDown.Resize;
Begin
     Inherited Resize;

     AlignButtons;
End;


Procedure TUpDown.EvButtonClick(Sender:TObject);
Begin
     If Not CanChange Then Exit;

     If TBitBtn(Sender)=FUpRightButton Then
     Begin
          If Position=Max Then
          Begin
               If Not FWrap Then Exit;
               Position:=Min;
          End
          Else Position:=Position+1;
          Click(btNext);
     End
     Else
     Begin
          If Position=Min Then
          Begin
               If Not FWrap Then Exit;
               Position:=Max;
          End
          Else Position:=Position-1;
          Click(btPrev);
     End;
End;


Function TUpDown.CanChange:Boolean;
Begin
     Result := True;
     If FOnChanging <> Nil Then FOnChanging(Self,Result);
End;


Procedure TUpDown.Click(Button:TUDBtnType);
Begin
     If FOnClick <> Nil Then FOnClick(Self,Button);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TTrackBar Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TTrackBar.SetMax(NewValue:LongInt);
Begin
     If NewValue<Min Then Exit;
     FMax:=NewValue;
     If Position>Max Then Position:=Max;
End;

Procedure TTrackBar.SetMin(NewValue:LongInt);
Begin
     If NewValue>Max Then Exit;
     FMin:=NewValue;
     If FSelMode=smAuto Then If FSelStart<>Min Then
     Begin
          FSelStart:=Min;
          FSelEnd:=FPosition;
          If Not FUpdating Then Invalidate;
     End;
     If Position<Min Then Position:=Min;
End;

Procedure TTrackBar.SetOrientation(NewValue:TTrackBarOrientation);
Begin
     If FOrientation=NewValue Then Exit;
     FOrientation:=NewValue;
     //Exchange Width And Height
     SetWindowPos(Left,Bottom,Height,Width)
End;

Procedure TTrackBar.SetPosition(NewValue:LongInt);
Begin
     If NewValue<Min Then NewValue:=Min;
     If NewValue>Max Then NewValue:=Max;
     If NewValue=Position Then Exit;
     FPosition:=NewValue;
     If FSelMode=smAuto Then
     Begin
          FSelStart:=Min;
          FSelEnd:=FPosition;
     End;
     UpdateSlider;
     Change;
End;

Procedure TTrackBar.Change;
Begin
     If OnChange<>Nil Then OnChange(Self);
End;

Procedure TTrackBar.SetSelEnd(NewValue:LongInt);
Begin
     If FSelMode<>smManual Then Exit;
     FSelEnd:=NewValue;
     If FSelEnd>FSelStart Then If Not FUpdating Then UpdateSlider;
End;

Procedure TTrackBar.SetSelStart(NewValue:LongInt);
Begin
     If FSelMode<>smManual Then Exit;
     FSelStart:=NewValue;
     If FSelStart<FSelEnd Then If Not FUpdating Then UpdateSlider;
End;

Procedure TTrackBar.SetTickMarks(NewValue:TTickMarks);
Begin
     FTickMarks:=NewValue;
     If NewValue=tmBoth Then FSliderShape:=tsBox
     Else FSliderShape:=tsArrow;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetTickStyle(NewValue:TTickStyle);
Begin
     FTickStyle:=NewValue;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetFrequency(NewValue:LongInt);
Begin
     If NewValue<1 Then NewValue:=1;
     If Min+NewValue>Max Then NewValue:=Max-Min;
     FFrequency:=NewValue;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetSelMode(NewMode:TTrackBarSelMode);
Begin
     FSelMode:=NewMode;
     If FSelMode=smAuto Then
     Begin
          FSelStart:=Min;
          FSelEnd:=Position;
     End;
     If Not FUpdating Then Invalidate;
End;

Procedure TTrackBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='TrackBar';
     ParentColor:=True;
     FShowFocusRect:=True;
     FPosition:=0;
     FLineSize:=1;
     FPageSize:=5;
     FMax:=10;
     FMin:=0;
     FOrientation:=trHorizontal;
     FSelEnd:=0;
     FSelStart:=0;
     FTickMarks:=tmBottomRight;
     FTickStyle:=tsAuto;
     FFrequency:=1;
     FSelMode:=smManual;
     FSliderShape:=tsArrow;
     Width:=200;
     Height:=50;
     FTrackTimer.Create(Self);
     Include(FTrackTimer.ComponentState, csDetail);
     FTrackTimer.Interval:=400;
     FTrackTimer.OnTimer:=EvTimer;
     FSliderSize:=tssAuto;
End;

Destructor TTrackBar.Destroy;
Begin
     If FTicks<>Nil Then FTicks.Destroy;
     Inherited Destroy;
End;

Procedure TTrackBar.DrawSlider(SliderW,SliderH:LongInt);
Var
   pts:Array[0..5] Of TPoint;
   Diff,Diff1:LongInt;

   Procedure Draw;
   Begin
        Canvas.BeginPath;
        Canvas.PolyLine(pts);
        Canvas.EndPath;
   End;

   Procedure Inflate;
   Begin
        If Orientation=trHorizontal Then
        Begin
             If FSliderShape=tsBox Then
             Begin
                  Dec(pts[0].X);
                  Dec(pts[0].Y);

                  Inc(pts[1].X);
                  Dec(pts[1].Y);

                  Inc(pts[2].X);
                  Inc(pts[2].Y);

                  Dec(pts[3].X);
                  Inc(pts[3].Y);

                  pts[4]:=pts[0];
                  pts[5]:=pts[0];
             End
             Else
             Begin
                  Dec(pts[0].Y);
                  Dec(pts[1].Y);
                  Inc(pts[2].X);
                  Inc(pts[3].X);
                  Inc(pts[3].Y);
                  Dec(pts[4].X);
                  Inc(pts[4].Y);
                  Dec(pts[5].X);
             End;
        End
        Else
        Begin
             If FSliderShape=tsBox Then
             Begin
                  Dec(pts[0].X);
                  Dec(pts[0].Y);

                  Inc(pts[1].X);
                  Dec(pts[1].Y);

                  Inc(pts[2].X);
                  Inc(pts[2].Y);

                  Dec(pts[3].X);
                  Inc(pts[3].Y);

                  pts[4]:=pts[0];
                  pts[5]:=pts[0];
             End
             Else
             Begin
                  Dec(pts[0].Y);
                  Inc(pts[1].Y);
                  Inc(pts[2].X);
                  Inc(pts[2].Y);
                  Dec(pts[3].X);
                  Inc(pts[3].Y);
                  Dec(pts[4].X);
                  Dec(pts[4].Y);
                  Inc(pts[5].X);
                  Dec(pts[5].Y);
             End;
        End;
   End;

   Procedure DrawBoxL;
   Begin
        Canvas.PenPos:=pts[0];
        If FSliderShape=tsBox Then
        Begin
             Canvas.LineTo(pts[3].X,pts[3].Y);
             Canvas.LineTo(pts[2].X,pts[2].Y);
        End
        Else
        Begin
             Canvas.LineTo(pts[5].X,pts[5].Y);
             Canvas.LineTo(pts[4].X,pts[4].Y);
             Canvas.LineTo(pts[3].X,pts[3].Y);
        End;
   End;

   Procedure DrawBoxR;
   Begin
        Canvas.PenPos:=pts[0];
        If FSliderShape=tsBox Then
        Begin
             Canvas.LineTo(pts[1].X,pts[1].Y);
             Canvas.LineTo(pts[2].X,pts[2].Y);
        End
        Else
        Begin
             Canvas.LineTo(pts[1].X,pts[1].Y);
             Canvas.LineTo(pts[2].X,pts[2].Y);
             Canvas.LineTo(pts[3].X,pts[3].Y);
        End;
   End;

Begin
     Canvas.Pen.color:=color;

     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     If Orientation=trHorizontal Then
     Begin
          If FSliderShape=tsBox Then
          Begin
               pts[0].X:=2+CoordFromPos(Position)-SliderW Div 2;
               pts[0].Y:=Height-Diff-SliderH+SliderH Div 6;
               pts[1].X:=pts[0].X+SliderW-5;
               pts[1].Y:=pts[0].Y;
               pts[2].X:=pts[1].X;
               pts[2].Y:=pts[0].Y+SliderH-2-SliderH Div 6;
               pts[3].X:=pts[0].X;
               pts[3].Y:=pts[2].Y;
               pts[4]:=pts[0];
               pts[5]:=pts[0];
          End
          Else
          Begin
               pts[0].X:=CoordFromPos(Position)-1;
               pts[0].Y:=Height-Diff-SliderH+2;

               pts[1].X:=pts[0].X+2;
               pts[1].Y:=pts[0].Y;

               pts[2].X:=pts[1].X+((SliderW-8) Div 2);
               pts[2].Y:=pts[1].Y+(SliderH Div 3);

               pts[3].X:=pts[2].X;
               pts[3].Y:=pts[0].Y+SliderH-4;

               pts[4].X:=pts[0].X-((SliderW-6) Div 2);
               pts[4].Y:=pts[3].Y;

               pts[5].X:=pts[4].X;
               pts[5].Y:=pts[2].Y;

               If TickMarks=tmTopLeft Then
               Begin
                    Diff1:=pts[2].Y-pts[0].Y;
                    pts[3].Y:=pts[0].Y;
                    pts[0].Y:=pts[4].Y+SliderH Div 6;
                    pts[4].Y:=pts[3].Y;
                    pts[1].Y:=pts[0].Y;
                    pts[5].Y:=pts[0].Y-Diff1;
                    pts[2].Y:=pts[5].Y;
               End;
          End;
     End
     Else
     Begin
          If FSliderShape=tsBox Then
          Begin
               pts[0].X:=Diff+2;
               pts[0].Y:=2+CoordFromPos(Position)-SliderW Div 2;
               pts[1].X:=pts[0].X+SliderH-3-SliderH Div 6;
               pts[1].Y:=pts[0].Y;
               pts[2].Y:=pts[0].Y+SliderW-5;
               pts[2].X:=pts[1].X;
               pts[3].Y:=pts[2].Y;
               pts[3].X:=pts[0].X;
               pts[4]:=pts[0];
               pts[5]:=pts[0];
          End
          Else
          Begin
               pts[0].Y:=CoordFromPos(Position)-1;
               pts[0].X:=Diff+SliderH-1;

               pts[1].Y:=pts[0].Y+2;
               pts[1].X:=pts[0].X;

               pts[2].Y:=pts[1].Y+((SliderW-8) Div 2);
               pts[2].X:=pts[1].X-(SliderH Div 3);

               pts[3].Y:=pts[2].Y;
               pts[3].X:=Diff+2;

               pts[4].Y:=pts[0].Y-((SliderW-6) Div 2);
               pts[4].X:=pts[3].X;

               pts[5].Y:=pts[4].Y;
               pts[5].X:=pts[2].X;

               If TickMarks=tmTopLeft Then
               Begin
                    Diff1:=pts[0].X-pts[2].X;
                    pts[3].X:=pts[0].X;
                    pts[0].X:=pts[4].X-SliderH Div 6;
                    pts[4].X:=pts[3].X;
                    pts[1].X:=pts[0].X;
                    pts[5].X:=pts[0].X+Diff1;
                    pts[2].X:=pts[5].X;
               End;
          End;
     End;

     //Draw filled portion
     If FTracking Then
     Begin
          Canvas.Brush.color:=clWhite;
          Canvas.Brush.Style:=bsDiagCross;
     End;
     Draw;
     Canvas.FillPath;
     If FTracking Then
     Begin
          Canvas.Brush.Style:=bsSolid;
          Canvas.Brush.color:=color;
     End;

     Inflate;

     Canvas.Pen.color:=clBtnHighlight;
     DrawBoxL;

     Canvas.Pen.color:=clBtnShadow;
     DrawBoxR;

     Inflate;

     Canvas.Pen.color:=clBtnHighlight;
     DrawBoxL;

     Canvas.Pen.color:=clBtnDefault;
     DrawBoxR;

     Draw;
     Canvas.PathToClipRegion(paDiff);
End;

Procedure TTrackBar.DrawTrack(SliderW,SliderH:LongInt);
Var  rc,rc1:TRect;
     Diff:LongInt;
Begin
     //Draw Slider
     DrawSlider(SliderW,SliderH);

     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     //Draw Box
     If Orientation=trHorizontal Then
     Begin
          rc.Left := 2;
          rc.Bottom := Height-Diff-(SliderH Div 3)*2 -1;
          rc.Right := Width-3;
          rc.Top := (Height-Diff-SliderH Div 6)-2 +1;
     End
     Else
     Begin
          rc.Left := Diff+2+(SliderH Div 6) -1;
          rc.Bottom := 2;
          rc.Right := rc.Left + (SliderH Div 6) + (SliderH Div 3);
          rc.Top := Height-3;
     End;
     DrawSystemBorder(Self,rc,bsSingle);

     If FSelMode=smAuto Then
     Begin
          FSelStart:=Min;
          FSelEnd:=FPosition;
     End;

     If FSelEnd>FSelStart Then
     Begin
          If Orientation=trHorizontal Then
          Begin
               rc1.Left:=CoordFromPos(FSelStart);
               rc1.Right:=CoordFromPos(FSelEnd);
               If rc.Top-rc.Bottom>6 Then  //medium And large
               Begin
                    rc1.Bottom:=rc.Bottom+2;
                    rc1.Top:=rc.Top-2;
               End
               Else //small
               Begin
                    rc1.Bottom:=rc.Bottom+1;
                    rc1.Top:=rc.Top-1;
               End;
               Canvas.FillRect(rc1,clHighlight);
               Canvas.ExcludeClipRect(rc1);
          End
          Else
          Begin
               rc1.Bottom:=CoordFromPos(FSelStart);
               rc1.Top:=CoordFromPos(FSelEnd);
               If rc.Right-rc.Left>6 Then  //medium And large
               Begin
                    rc1.Left:=rc.Left+2;
                    rc1.Right:=rc.Right-2;
               End
               Else //small
               Begin
                    rc1.Left:=rc.Left+1;
                    rc1.Right:=rc.Right-1;
               End;
               Canvas.FillRect(rc1,clHighlight);
               Canvas.ExcludeClipRect(rc1);
          End;
     End;

     Canvas.FillRect(rc,clWhite);
     Forms.InflateRect(rc, 2, 2);
     Canvas.ExcludeClipRect(rc);
End;

Procedure TTrackBar.Redraw(Const rec:TRect);
Var SliderWidth,SliderHeight:LongInt;
    T:LongInt;
    X,Y,Diff:LongInt;
    rc:TRect;

    Procedure DrawTick(X,Y,X1,y1:LongInt);
    Var rc:TRect;
    Begin
         rc.LeftBottom:=Point(X1,y1);
         rc.RightTop:=Point(X,Y);
         Canvas.BeginPath;
         Canvas.Rectangle(rc);
         Canvas.EndPath;
         Canvas.OutlinePath;
         Canvas.BeginPath;
         Canvas.Rectangle(rc);
         Canvas.EndPath;
         Canvas.PathToClipRegion(paDiff);
    End;

    Procedure DrawLabelX;
    Begin
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then
         Begin
              DrawTick(X,Y,X,Y-FTickSize);
         End;
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then
         Begin
              DrawTick(X,Height-Diff+6,X,Height-Diff+6+FTickSize)
         End;
    End;

    Procedure DrawLabelY;
    Begin
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then
         Begin
              If ((SliderHeight=45)Or(SliderHeight=38)) Then
              Begin
                   If FSliderShape=tsBox Then
                      DrawTick(Diff+SliderHeight,Y,Diff+SliderHeight+FTickSize,Y)
                   Else
                      DrawTick(Diff+SliderHeight+2,Y,Diff+SliderHeight+2+FTickSize,Y)
              End
              Else  DrawTick(Diff+SliderHeight+2,Y,Diff+SliderHeight+2+FTickSize,Y)
         End;
         If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then
         Begin
              DrawTick(X,Y,X-FTickSize,Y);
         End;
    End;
Begin
     GetSliderExtent(SliderWidth,SliderHeight);

     //Draw Slider And Box
     DrawTrack(SliderWidth,SliderHeight);

     //Draw Ticks
     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;
     If Orientation=trHorizontal Then
     Begin
          Case FTickStyle Of
             tsAuto:
             Begin
                  Y:=Height-Diff-SliderHeight+2;
                  Dec(Y,5);

                  Canvas.Pen.color:=clBlack;
                  For T:=Min To Max Do
                  Begin
                       X:=CoordFromPos(T);
                       DrawLabelX;
                       Inc(T,FFrequency-1);
                  End;
             End;
             tsManual,tsNone:
             Begin
                  Y:=Height-Diff-SliderHeight+2;
                  Dec(Y,5);

                  Canvas.Pen.color:=clBlack;
                  If FTickStyle=tsManual Then
                  Begin
                       X:=CoordFromPos(Min);
                       DrawLabelX;

                       X:=CoordFromPos(Max);
                       DrawLabelX;
                  End;

                  If FTicks<>Nil Then For T:=0 To FTicks.Count-1 Do
                  Begin
                       X:=CoordFromPos(LongInt(FTicks[T]));
                       DrawLabelX;
                  End;
             End;
          End; {Case}
          X:=CoordFromPos(Max); // always final tick
          DrawLabelX;
     End
     Else
     Begin
          Case FTickStyle Of
             tsAuto:
             Begin
                  X:=Diff-5;
                  If SliderHeight<>12 Then Dec(X,2);

                  Canvas.Pen.color:=clBlack;
                  For T:=Min To Max Do
                  Begin
                       Y:=CoordFromPos(T);
                       DrawLabelY;
                       Inc(T,FFrequency-1);
                  End;
             End;
             tsManual,tsNone:
             Begin
                  X:=Diff-5;
                  If SliderHeight<>12 Then Dec(X,2);

                  Canvas.Pen.color:=clBlack;
                  If FTickStyle=tsManual Then
                  Begin
                       Y:=CoordFromPos(Min);
                       DrawLabelY;

                       Y:=CoordFromPos(Max);
                       DrawLabelY;
                  End;

                  If FTicks<>Nil Then For T:=0 To FTicks.Count-1 Do
                  Begin
                       Y:=CoordFromPos(LongInt(FTicks[T]));
                       DrawLabelY;
                  End;
             End;
          End; {Case}
          Y:=CoordFromPos(Max); // always final tick
          DrawLabelY;
     End;

     //Erase background
     If HasFocus Then
     Begin
          rc:=ClientRect;
          Forms.InflateRect(rc,-1,-1);
     End
     Else rc:=rec;
     Inherited Redraw(rc);

     If HasFocus Then If ShowFocusRect Then
     Begin
          Canvas.DeleteClipRegion;
          rc:=ClientRect;
          Canvas.DrawFocusRect(rc);
     End;
End;

Procedure TTrackBar.GetSliderExtent(Var SliderWidth,SliderHeight:LongInt);
Var Extent,Diff:LongInt;
Label vl,L,M,S;
Begin
     Case SliderSize Of
        tssAuto:
        Begin
             If Orientation=trHorizontal Then Extent:=Height
             Else Extent:=Width;
             If TickMarks=tmBoth Then Diff:=44
             Else If TickMarks=tmTopLeft Then Diff:=24
             Else If TickMarks=tmBottomRight Then Diff:=24;

             If Extent>35+Diff Then //super large Size
             Begin
vl:
                  SliderWidth:=24;
                  SliderHeight:=45;
                  FTickSize:=12;
             End
             Else If Extent>25+Diff Then //large Size
             Begin
L:
                  SliderWidth:=20;
                  SliderHeight:=38;
                  FTickSize:=8;
             End
             Else If Extent>20+Diff Then //medium Size
             Begin
M:
                  SliderWidth:=16;
                  SliderHeight:=30;
                  FTickSize:=6;
             End
             Else //small Size
             Begin
S:
                  SliderWidth:=6;
                  SliderHeight:=12;
                  FTickSize:=3;
             End;
        End;
        tssVeryLarge:Goto vl;
        tssLarge:Goto L;
        tssMedium:Goto M;
        tssSmall:Goto S;
     End; {Case}
End;

Function TTrackBar.CoordFromPos(Position:LongInt):LongInt;
Var
   Scale:Extended;
   WH:LongInt;
   SliderWidth,SliderHeight:LongInt;
Begin
     GetSliderExtent(SliderWidth,SliderHeight);
     If Orientation=trHorizontal Then WH:=Width-2
     Else WH:=Height-2;
     Dec(WH,SliderWidth);
     Scale:=WH/(Max-Min);
     Result:=Round((Position-Min)*Scale);
     Inc(Result,1+SliderWidth Div 2)
End;

Function TTrackBar.PosFromCoord(Coord:LongInt):LongInt;
Var
   Scale:Extended;
   WH:LongInt;
   SliderWidth,SliderHeight:LongInt;
Begin
     GetSliderExtent(SliderWidth,SliderHeight);
     If Orientation=trHorizontal Then WH:=Width-2
     Else WH:=Height-2;
     Dec(WH,SliderWidth Div 2);
     Scale:=WH/(Max-Min);
     Result:=Min+Round((Coord-1)/Scale);
End;

Function TTrackBar.PosInsideSlider(X,Y:LongInt):Boolean;
Var SliderW,SliderH,Diff:LongInt;
    pts:Array[0..3] Of TPoint;
Begin
     GetSliderExtent(SliderW,SliderH);
     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     If Orientation=trHorizontal Then
     Begin
         pts[0].X:=CoordFromPos(Position)-SliderW Div 2;
         pts[0].Y:=Height-Diff-SliderH+2;
         pts[1].X:=pts[0].X+SliderW;
         pts[1].Y:=Height-Diff;

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End
     Else
     Begin
         pts[0].Y:=CoordFromPos(Position)-SliderW Div 2;
         pts[0].X:=Diff+2;
         pts[1].Y:=pts[0].Y+SliderW;
         pts[1].X:=pts[0].X+SliderH;

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End;
End;

Function TTrackBar.PosInsideTrack(X,Y:LongInt):Boolean;
Var SliderW,SliderH,Diff:LongInt;
    pts:Array[0..3] Of TPoint;
Begin
     GetSliderExtent(SliderW,SliderH);
     If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Diff:=20
     Else Diff:=2;

     If Orientation=trHorizontal Then
     Begin
         pts[0].X:=3;
         pts[0].Y:=Height-Diff-((SliderH Div 3)*2);
         pts[1].X:=Width-3;
         pts[1].Y:=Height-Diff-(SliderH Div 6);

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End
     Else
     Begin
         pts[0].Y:=3;
         pts[0].X:=Diff+SliderH Div 6;
         pts[1].Y:=Height-3;
         pts[1].X:=Diff+((SliderH Div 3)*2);

         Result:=((X>=pts[0].X)And(X<=pts[1].X)And(Y>=pts[0].Y)And(Y<=pts[1].Y));
     End;
End;

Procedure TTrackBar.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);
     If Button=mbLeft Then
     Begin
          Focus;
          If PosInsideSlider(X,Y) Then
          Begin
               MouseCapture:=True;
               FTracking:=True;
               UpdateSlider;
          End
          Else If PosInsideTrack(X,Y) Then
          Begin
               MouseCapture:=True;
               FTrackTimer.Start;
          End;
     End;
End;

Procedure TTrackBar.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);
     If Button=mbLeft Then
     Begin
          If FTracking Then
          Begin
               MouseCapture:=False;
               FTracking:=False;
               UpdateSlider;
               Change;
          End
          Else
          Begin
               MouseCapture:=False;
               FTrackTimer.Stop;
          End;
     End;
End;

Procedure TTrackBar.UpdateSlider;
Var rc,rc1:TRect;
    SliderWidth,SliderHeight:LongInt;
Begin
     If Canvas<>Nil Then
     Begin
         rc:=ClientRect;
         Inc(rc.Right);
         Inc(rc.Top);

         rc1:=rc;
         GetSliderExtent(SliderWidth,SliderHeight);

         If Orientation=trHorizontal Then
         Begin
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Dec(rc.Top,15);
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then
              Begin
                   rc.Bottom:=rc.Top-SliderHeight-4;
                   If SliderHeight=45 Then Inc(rc.Bottom);
              End;
         End
         Else
         Begin
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmTopLeft)) Then Inc(rc.Left,15);
              If ((FTickMarks=tmBoth)Or(FTickMarks=tmBottomRight)) Then rc.Right:=rc.Left+SliderHeight+5;
         End;

         If rc.Top=rc1.Top Then Dec(rc.Top);
         If rc.Right=rc1.Right Then Dec(rc.Right);
         If rc.Left=rc1.Left Then Inc(rc.Left);
         If rc.Bottom=rc1.Bottom Then Inc(rc.Bottom);
         Canvas.ClipRect:=rc;
         DrawTrack(SliderWidth,SliderHeight);
         {?????????+-1}
         Dec(rc.Right);
         Dec(rc.Top);
         Canvas.FillRect(rc,color);
         Canvas.DeleteClipRegion;
     End;
End;

Procedure TTrackBar.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var NewPos:LongInt;
Begin
     Inherited MouseMove(ShiftState,X,Y);
     If FTracking Then
     Begin
          If Orientation=trHorizontal Then NewPos:=PosFromCoord(X)
          Else NewPos:=PosFromCoord(Y);
          Position:=NewPos;
     End;
End;

Procedure TTrackBar.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var C:LongInt;
Begin
     Inherited MouseClick(Button,ShiftState,X,Y);
     If Button=mbLeft Then
     Begin
          If Not PosInsideSlider(X,Y) Then //If PosInsideTrack(X,Y) Then
          Begin
               C:=CoordFromPos(Position);
               If Orientation=trHorizontal Then
               Begin
                    If C<X Then Position:=Position+PageSize
                    Else Position:=Position-PageSize;
               End
               Else
               Begin
                    If C<Y Then Position:=Position+PageSize
                    Else Position:=Position-PageSize;
               End;
          End;
     End;
End;

Procedure TTrackBar.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     MouseClick(Button,ShiftState,X,Y);
End;

Procedure TTrackBar.EvTimer(Sender:TObject);
Var MPos:Array[0..0] Of TPoint;
    C:LongInt;
    SliderW,SliderH:LongInt;
Begin
     If Sender=FTrackTimer Then
     Begin
          GetSliderExtent(SliderW,SliderH);
          MPos[0]:=Screen.MousePos;
          Screen.MapPoints(Self,MPos);
          C:=CoordFromPos(Position);
          If Not PosInsideSlider(MPos[0].X,MPos[0].Y) Then
          Begin
               If Orientation=trHorizontal Then
               Begin
                    If C+SliderW<MPos[0].X Then Position:=Position+PageSize
                    Else If C>MPos[0].X+SliderW Then Position:=Position-PageSize;
               End
               Else
               Begin
                    If C+SliderW Div 2<MPos[0].Y Then Position:=Position+PageSize
                    Else If C>MPos[0].Y+SliderW Div 2 Then Position:=Position-PageSize;
               End;
          End;
     End;
End;

Procedure TTrackBar.SetFocus;
Begin
     Inherited SetFocus;
     Invalidate;
End;

Procedure TTrackBar.KillFocus;
Begin
     Inherited KillFocus;
     Invalidate;
End;

Procedure TTrackBar.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     Case KeyCode Of
         kbCLeft:If Orientation=trHorizontal Then Position:=Position-LineSize;
         kbCRight:If Orientation=trHorizontal Then Position:=Position+LineSize;
         kbCUp:If Orientation=trVertical Then Position:=Position+LineSize;
         kbCDown:If Orientation=trVertical Then Position:=Position-LineSize;
         kbPageDown:Position:=Position-PageSize;
         kbPageUp:Position:=Position+PageSize;
         Else
         Begin
              Inherited ScanEvent(KeyCode,RepeatCount);
              exit;
         End;
     End; //Case

     // had a match... swallow keypress
     KeyCode := kbNull;
End;

Procedure TTrackBar.SetTick(Pos:LongInt);
Begin
     If FTicks=Nil Then FTicks.Create;
     FTicks.Add(Pointer(Pos));
End;

Procedure TTrackBar.ClearTicks;
Begin
     If FTicks<>Nil Then FTicks.Clear;
End;

Procedure TTrackBar.BeginUpdate;
Begin
     FUpdating:=True;
End;

Procedure TTrackBar.EndUpdate;
Begin
     FUpdating:=False;
     Invalidate;
End;

Procedure TTrackBar.SetSliderSize(NewSize:TTrackSliderSize);
Begin
     FSliderSize:=NewSize;
     If Not FUpdating Then Invalidate;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TStatusPanel Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TStatusPanel.GetText:String;
Begin
     If FText<>Nil Then Result:=FText^
     Else Result:='';
End;

Procedure TStatusPanel.SetText(Const NewValue:String);
Begin
     If FText<>Nil Then
     Begin
          If NewValue=FText^ Then Exit;
          FreeMem(FText,Length(FText^)+1);
     End;

     GetMem(FText,Length(NewValue)+1);
     FText^:=NewValue;
     changed(False);
End;

Procedure TStatusPanel.SetWidth(NewValue:LongInt);
Begin
     If NewValue=FWidth Then Exit;
     FWidth:=NewValue;
     changed(True);
End;

Procedure TStatusPanel.SetAlignment(NewValue:TAlignment);
Begin
     If NewValue=FAlignment Then Exit;
     FAlignment:=NewValue;
     changed(False);
End;

Procedure TStatusPanel.SetBevel(NewValue:TStatusPanelBevel);
Begin
     If NewValue=FBevel Then Exit;
     FBevel:=NewValue;
     changed(True);
End;

Procedure TStatusPanel.SetStyle(NewValue:TStatusPanelStyle);
Begin
     If NewValue=FStyle Then Exit;
     FStyle:=NewValue;
     changed(False);
End;

Constructor TStatusPanel.Create(ACollection:TCollection);
Begin
     FBevel:=pbLowered;
     FAlignment:=taLeftJustify;
     FStyle:=psText;
     FWidth:=100;
     Inherited Create(ACollection);
End;

Destructor TStatusPanel.Destroy;
Begin
     If FText<>Nil Then FreeMem(FText,Length(FText^)+1);

     Inherited Destroy;
End;

Procedure TStatusPanel.Assign(Source:TCollectionItem);
Begin
     If Source Is TStatusPanel Then
       If Source<>Self Then
     Begin
          FBevel:=TStatusPanel(Source).Bevel;
          FStyle:=TStatusPanel(Source).Style;
          FAlignment:=TStatusPanel(Source).Alignment;
          Width:=TStatusPanel(Source).Width;
          Text:=TStatusPanel(Source).Text;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TStatusPanels Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TStatusPanels.GetItem(Index:LongInt):TStatusPanel;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited GetItem(Index);
     Result:=TStatusPanel(dummy);
End;

Procedure TStatusPanels.SetItem(Index:LongInt;Value:TStatusPanel);
Begin
     Inherited SetItem(Index,Value);
End;

Procedure TStatusPanels.Update(Item:TCollectionItem);
Begin
     If FStatusBar=Nil Then Exit;
     If Item=Nil Then FStatusBar.Invalidate
     Else FStatusBar.UpdatePanel(TStatusPanel(Item));
End;

Procedure TStatusPanels.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='StatusPanels';
     If Owner Is TStatusBar Then FStatusBar:=TStatusBar(Owner);
     ItemClass:=TStatusPanel;
End;

Function TStatusPanels.Add:TStatusPanel;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited Add;
     Result:=TStatusPanel(dummy);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TStatusBar Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TStatusBar.UpdatePanel(Panel:TStatusPanel);
Var rc:TRect;
    T:LongInt;
Begin
     If FSimplePanel Then
     Begin
          Invalidate;
          Exit;
     End;

     //Get Rectangle For the Panel
     rc:=ClientRect;
     For T:=0 To FPanels.Count-1 Do
     Begin
          If FPanels[T]=Panel Then break
          Else Inc(rc.Left,FPanels[T].Width+FSpacing);
     End;

     rc.Right:=rc.Left+Panel.Width;
     InvalidateRect(rc);
     Update;
End;

Procedure TStatusBar.SetSimpleText(Const NewText:String);
Begin
     FSimpleText:=NewText;
     If FSimplePanel Then Invalidate;
End;

Procedure TStatusBar.SetSimplePanel(NewValue:Boolean);
Begin
     FSimplePanel:=NewValue;
     {If FSimplePanel Then} Invalidate;
End;

Procedure TStatusBar.SetPanels(NewValue:TStatusPanels);
Begin
     FPanels.Assign(NewValue);
End;

Procedure TStatusBar.SetSizeGrip(NewValue:Boolean);
Begin
     FSizeGrip:=NewValue;
     Invalidate;
End;

Procedure TStatusBar.SetSpacing(NewValue:LongInt);
Begin
     If FSpacing<0 Then FSpacing:=0;
     FSpacing:=NewValue;
     Invalidate;
End;

Procedure TStatusBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Align:=alBottom;
     Name:='StatusBar';
     FSizeGrip:=True;
     FPanels.Create(Self);
     Height:=35;
     FSpacing:=2;
End;

Destructor TStatusBar.Destroy;
Begin
     FPanels.Destroy;
     Inherited Destroy;
End;

Procedure TStatusBar.DrawPanel(Panel:TStatusPanel;Const rc:TRect);
Var
   Align:TAlignment;
   S:String;
   Bev:TStatusPanelBevel;
   CX,CY,H:LongInt;
   RaisedColor,LoweredColor:TColor;
   rec:TRect;
Begin
     If Panel=Nil Then
     Begin
          Align:=taLeftJustify;
          S:=FSimpleText;
          If Style=bsLowered Then Bev:=pbLowered
          Else Bev:=pbRaised;
     End
     Else
     Begin
          Align:=Panel.Alignment;
          S:=Panel.Text;
          Bev:=Panel.Bevel;
     End;

     Canvas.GetTextExtent(S,CX,CY);

     Case Align Of
        taLeftJustify:rec.Left:=rc.Left+3;
        taRightJustify:rec.Left:=rc.Right-3-CX;
        Else //taCenter
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX) Div 2);
        End;
     End; //Case

     If rec.Left<rc.Left+3 Then rec.Left:=rc.Left+3;
     H:=rc.Top-rc.Bottom;
     rec.Bottom:=rc.Bottom+((H-CY) Div 2);
     If rec.Bottom<rc.Bottom+3 Then rec.Bottom:=rc.Bottom+3;
     rec.Right:=rec.Left+CX-1;
     rec.Top:=rec.Bottom+CY-1;

     Canvas.TextOut(rec.Left,rec.Bottom,S);

     Canvas.ExcludeClipRect(rec);

     If Bev=pbNone Then Canvas.FillRect(rc,color)
     Else
     Begin
          If Bev=pbRaised Then
          Begin
               RaisedColor:=clWhite;
               LoweredColor:=clDkGray;
          End
          Else
          Begin
               RaisedColor:=clDkGray;
               LoweredColor:=clWhite;
          End;

          Canvas.ShadowedBorder(rc,RaisedColor,LoweredColor);
          rec:=rc;
          Forms.InflateRect(rec,-1,-1);
          Canvas.FillRect(rec,color)
     End;
End;

Procedure TStatusBar.Redraw(Const rec:TRect);
Var T:LongInt;
    rc,rc2:TRect;
    Panel:TStatusPanel;
Begin
     Canvas.ClipRect:=rec;
     Canvas.Pen.color:=PenColor;
     Canvas.Brush.color:=color;

     If ((FSimplePanel)Or(FPanels.Count=0)) Then
     Begin
          rc:=ClientRect;
          DrawPanel(Nil,rc);
     End
     Else
     Begin
          rc:=ClientRect;

          For T:=0 To FPanels.Count-1 Do
          Begin
               Panel:=FPanels[T];
               If T=FPanels.Count-1 Then rc.Right:=Width-1
               Else rc.Right:=rc.Left+Panel.Width;
               If rc.Right>Width-1 Then rc.Right:=Width-1;

               rc2:=Forms.IntersectRect(rc,rec);
               If Not Forms.IsRectEmpty(rc2) Then
               Begin
                    Canvas.ClipRect:=rc2;

                    If Panel.Style=psOwnerDraw Then
                    Begin
                         If OnDrawPanel<>Nil Then OnDrawPanel(Self,Panel,rc)
                         Else DrawPanel(Panel,rc);
                    End
                    Else DrawPanel(Panel,rc);
               End;
               Inc(rc.Left,Panel.Width+FSpacing);
          End;

          Canvas.ClipRect:=rec;
          rc:=ClientRect;
          For T:=0 To FPanels.Count-1 Do
          Begin
               Panel:=FPanels[T];
               If T=FPanels.Count-1 Then rc.Right:=Width-1
               Else rc.Right:=rc.Left+Panel.Width;
               If rc.Right>Width-1 Then rc.Right:=Width-1;

               Canvas.ExcludeClipRect(rc);
               Inc(rc.Left,Panel.Width+FSpacing);
          End;

          Canvas.FillRect(rec,color); //Delete rest
     End;
     Canvas.DeleteClipRegion;

     If SizeGrip Then
     Begin
          For T:=0 To 12 Do
          Begin
               Canvas.Pen.color:=clLtGray;
               Canvas.Line(Width-T-1,0,Width-1,T);
               Inc(T);
               Canvas.Pen.color:=clDkGray;
               Canvas.Line(Width-T-1,0,Width-1,T);
               Inc(T);
               Canvas.Pen.color:=clWhite;
               Canvas.Line(Width-T-1,0,Width-1,T);
          End;
     End;
End;

Type
    PPanelItem=^TPanelItem;
    TPanelItem=Record
        Style:TStatusPanelStyle;
        Bevel:TStatusPanelBevel;
        Width:LongInt;
        Alignment:TAlignment;
    End;

Procedure TStatusBar.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PPanelItem;
   Panel:TStatusPanel;
   T:LongInt;
   ps:^String;
Begin
     If ResName = rnStatusPanels Then
     Begin
          Count:=@Data;
          Items:=@Data;
          Inc(Items,4);
          For T:=1 To Count^ Do
          Begin
               Panel:=FPanels.Add;
               ps:=Pointer(Items);
               Panel.Text:=ps^;
               Inc(Items,Length(ps^)+1);
               Panel.Bevel:=Items^.Bevel;
               Panel.Style:=Items^.Style;
               Panel.Alignment:=Items^.Alignment;
               Panel.Width:=Items^.Width;
               Inc(Items,SizeOf(TPanelItem));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TStatusBar.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:TPanelItem;
    Panel:TStatusPanel;
    S:String;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FPanels.Count>0 Then
     Begin
          MemStream.Create;
          T:=FPanels.Count;
          MemStream.Write(T,4);
          For T:=0 To FPanels.Count-1 Do
          Begin
               Panel:=FPanels[T];
               S:=Panel.Text;
               MemStream.Write(S,Length(S)+1);
               Item.Style:=Panel.Style;
               Item.Bevel:=Panel.Bevel;
               Item.Width:=Panel.Width;
               Item.Alignment:=Panel.Alignment;
               MemStream.Write(Item,SizeOf(TPanelItem));
          End;

          Result:=Stream.NewResourceEntry(rnStatusPanels,MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;

// Returns true if the given X,Y position is on the
// sizing grip
Function TStatusBar.IsPointOnSizeGrip(X,Y:longint):Boolean;
Begin
  Result := false;
  if X < (Width-16) then
    exit;
  if Y > 16 then
    exit;
  if ( X - (Width-16) ) < Y then
    exit;
  Result := true;
End;

Procedure TStatusBar.MouseDown(Button:TMouseButton;
                               ShiftState:TShiftState;
                               X,Y:LongInt);
Begin
  inherited MouseDown(Button,ShiftState,X,Y);
  if not IsPointOnSizeGrip(X,Y) then
    exit;
  if not ( Parent is TForm ) then
    exit;
  // tell frame window to start tracking from this position.
  SendMsg( TForm( Parent ).Frame.Handle,
           WM_TRACKFRAME,
           TF_BOTTOM + TF_RIGHT, // size bottom and right sides
           0 );
End;

Procedure TStatusBar.MouseMove(ShiftState:TShiftState;
                               X,Y:LongInt);
Begin
  inherited MouseMove(ShiftState,X,Y);

  // if mouse is over size grip
  if IsPointOnSizeGrip(X,Y) then
    // change to a sizing cursor
    Cursor := crSizeNWSE
  else
    // it's not, back to normal cursor
    Cursor := crDefault;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: THeaderControl Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function THeaderSection.GetText:String;
Begin
     If FText<>Nil Then Result:=FText^
     Else Result:='';
End;

Procedure THeaderSection.SetText(Const NewValue:String);
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

Procedure THeaderSection.SetWidth(NewValue:LongInt);
Begin
     If NewValue<FMinWidth Then NewValue:=FMinWidth;
     If NewValue>FMaxWidth Then NewValue:=FMaxWidth;
     If NewValue=FWidth Then Exit;
     FWidth:=NewValue;
     changed(True);
End;

Function THeaderSection.GetLeft:LongInt;
Var T:LongInt;
    Sections:THeaderSections;
Begin
     Result:=0;
     Sections:=THeaderSections(collection);
     If Sections<>Nil Then For T:=0 To Index-1 Do
     Begin
           Inc(Result,Sections[T].Width+1);
           If Sections.FHeaderControl<>Nil Then Inc(Result,Sections.FHeaderControl.FSpacing);
     End;
End;

Function THeaderSection.GetRight:LongInt;
Begin
     Result:=Left+Width;
End;

Procedure THeaderSection.SetStyle(NewValue:THeaderSectionStyle);
Begin
     If NewValue=FStyle Then Exit;
     FStyle:=NewValue;
     changed(False);
End;

Procedure THeaderSection.SetAlignment(NewValue:TAlignment);
Begin
     If NewValue=FAlignment Then Exit;
     FAlignment:=NewValue;
     changed(False);
End;

Procedure THeaderSection.SetMaxWidth(NewValue:LongInt);
Begin
     If NewValue>10000 Then NewValue:=10000;
     If NewValue<FMinWidth Then NewValue:=FMinWidth;
     FMaxWidth:=NewValue;
     Width:=FWidth;  //Update
End;

Procedure THeaderSection.SetMinWidth(NewValue:LongInt);
Begin
     If NewValue<0 Then NewValue:=0;
     If NewValue>FMaxWidth Then NewValue:=FMaxWidth;
     FMinWidth:=NewValue;
     Width:=FWidth; //Update
End;

Constructor THeaderSection.Create(ACollection:TCollection);
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

Destructor THeaderSection.Destroy;
Begin
     If FText<>Nil Then FreeMem(FText,Length(FText^)+1);

     Inherited Destroy;
End;

Procedure THeaderSection.Assign(Source:TCollectionItem);
Begin
     If Source Is THeaderSection Then
       If Source<>Self Then
     Begin
          FMinWidth:=THeaderSection(Source).MinWidth;
          FMaxWidth:=THeaderSection(Source).MaxWidth;
          FAlignment:=THeaderSection(Source).Alignment;
          FStyle:=THeaderSection(Source).Style;
          FAllowClick:=THeaderSection(Source).AllowClick;
          FAllowSize:=THeaderSection(Source).AllowSize;
          Width:=THeaderSection(Source).Width;
          Text:=THeaderSection(Source).Text;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: THeaderSections Class Implementation                        บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function THeaderSections.GetItem(Index:LongInt):THeaderSection;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited GetItem(Index);
     Result:=THeaderSection(dummy);
End;

Procedure THeaderSections.SetItem(Index:LongInt;NewValue:THeaderSection);
Begin
     Inherited SetItem(Index,NewValue);
End;

Procedure THeaderSections.Update(Item:TCollectionItem);
Begin
     If FHeaderControl=Nil Then Exit;
     If Item=Nil Then FHeaderControl.Invalidate
     Else FHeaderControl.UpdateHeader(THeaderSection(Item));
End;

Procedure THeaderSections.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='HeaderSections';
     If Owner Is THeaderControl Then FHeaderControl:=THeaderControl(Owner);
     ItemClass:=THeaderSection;
End;

Function THeaderSections.Add:THeaderSection;
Var dummy:TCollectionItem;
Begin
     dummy:=Inherited Add;
     Result:=THeaderSection(dummy);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: THeaderControl Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function THeaderControl.GetSections:THeaderSections;
Begin
     If FSections=Nil Then FSections:=FSectionsClass.Create(Self);
     Result:=FSections;
End;

Procedure THeaderControl.SetSections(NewValue:THeaderSections);
Begin
     Sections.Assign(NewValue);
End;

Procedure THeaderControl.UpdateHeader(Header:THeaderSection);
Var T:LongInt;
    rc:TRect;
Begin
     //Get Rectangle For the Panel
     rc:=ClientRect;
     If FSections<>Nil Then
      For T:=0 To FSections.Count-1 Do
      Begin
           If FSections[T]=Header Then break
           Else Inc(rc.Left,FSections[T].Width+FSpacing+1);
      End;

     rc.Right:=rc.Left+Header.Width;
     InvalidateRect(rc);
     Update;
End;

{$HINTS OFF}
Procedure THeaderControl.DrawSection(section:THeaderSection;Const rc:TRect;Pressed:Boolean);
Var
   Align:TAlignment;
   S:String;
   CX,CY,H:LongInt;
   rec:TRect;
   PointsArray:Array[0..5] Of TPoint;
   offs:LongInt;
Begin
     Align:=section.Alignment;
     S:=section.Text;

     Canvas.GetTextExtent(S,CX,CY);

     Case Align Of
        taLeftJustify:rec.Left:=rc.Left+3;
        taRightJustify:rec.Left:=rc.Right-3-CX;
        Else //taCenter
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX) Div 2);
        End;
     End; //Case

     If rec.Left<rc.Left+3 Then rec.Left:=rc.Left+3;
     H:=rc.Top-rc.Bottom;
     rec.Bottom:=rc.Bottom+((H-CY) Div 2);
     If rec.Bottom<rc.Bottom+3 Then rec.Bottom:=rc.Bottom+3;
     rec.Right:=rec.Left+CX-1;
     rec.Top:=rec.Bottom+CY-1;

     Canvas.TextOut(rec.Left,rec.Bottom,S);

     Canvas.ExcludeClipRect(rec);

     If BevelWidth > 1 Then
     Begin
          offs := BevelWidth-1;
          PointsArray[0] := Point(rc.Left,rc.Bottom);
          PointsArray[1] := Point(rc.Left+offs,rc.Bottom+offs);
          PointsArray[2] := Point(rc.Left+offs,rc.Top-offs);
          PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
          PointsArray[4] := Point(rc.Right,rc.Top);
          PointsArray[5] := Point(rc.Left,rc.Top);
          Canvas.Pen.color := clWhite;
          Canvas.Polygon(PointsArray);
          PointsArray[2] := Point(rc.Right-offs,rc.Bottom+offs);
          PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
          PointsArray[4] := Point(rc.Right,rc.Top);
          PointsArray[5] := Point(rc.Right,rc.Bottom);
          Canvas.Pen.color := clDkGray;
          Canvas.Polygon(PointsArray);
          Canvas.Pen.color:=PenColor;
     End
     Else Canvas.ShadowedBorder(rc,clWhite,clDkGray);

     rec:=rc;
     Forms.InflateRect(rec,-BevelWidth,-BevelWidth);
     Canvas.FillRect(rec,color)
End;
{$HINTS ON}


Procedure THeaderControl.Redraw(Const rec:TRect);
Var T:LongInt;
    rc,rc2:TRect;
    section:THeaderSection;
    IsPressed:Boolean;
    PointsArray:Array[0..5] Of TPoint;
    offs:LongInt;
Begin
     Canvas.Brush.color:=color;
     Canvas.Pen.color:=PenColor;

     rc:=ClientRect;
     Inc(rc.Bottom);
     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          rc.Right:=rc.Left+section.Width;
          If rc.Right>Width-1 Then rc.Right:=Width-1;

          IsPressed:=section=FClickSection;
          If IsPressed Then
          Begin
               Inc(rc.Left);
               Inc(rc.Right);
               Dec(rc.Bottom);
               Dec(rc.Top);
          End;

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

          If IsPressed Then
          Begin
               Dec(rc.Left);
               Dec(rc.Right);
               Inc(rc.Bottom);
               Inc(rc.Top);
          End;
          Inc(rc.Left,section.Width+FSpacing+1);
     End;

     //Draw rest Bevel
     If FSections<>Nil Then If ((rc.Left<Width)And(FSections.Count>0)) Then
     Begin
          rc.Right:=Width-1;
          rc2:=Forms.IntersectRect(rc,rec);
          If Not Forms.IsRectEmpty(rc2) Then
          Begin
               Canvas.ClipRect:=rc2;

               If BevelWidth > 1 Then
               Begin
                   offs := BevelWidth-1;
                   PointsArray[0] := Point(rc.Left,rc.Bottom);
                   PointsArray[1] := Point(rc.Left+offs,rc.Bottom+offs);
                   PointsArray[2] := Point(rc.Left+offs,rc.Top-offs);
                   PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
                   PointsArray[4] := Point(rc.Right,rc.Top);
                   PointsArray[5] := Point(rc.Left,rc.Top);
                   Canvas.Pen.color := clWhite;
                   Canvas.Polygon(PointsArray);
                   PointsArray[2] := Point(rc.Right-offs,rc.Bottom+offs);
                   PointsArray[3] := Point(rc.Right-offs,rc.Top-offs);
                   PointsArray[4] := Point(rc.Right,rc.Top);
                   PointsArray[5] := Point(rc.Right,rc.Bottom);
                   Canvas.Pen.color := clDkGray;
                   Canvas.Polygon(PointsArray);
                   Canvas.Pen.color:=PenColor;
               End
               Else Canvas.ShadowedBorder(rc,clWhite,clDkGray);

               Forms.InflateRect(rc,-BevelWidth,-BevelWidth);
               Canvas.FillRect(rc,color);
          End;
     End;

     Canvas.ClipRect:=rec;
     rc:=ClientRect;
     Inc(rc.Bottom);
     If FSections<>Nil Then For T:=0 To FSections.Count-1 Do
     Begin
          section:=FSections[T];
          rc.Right:=rc.Left+section.Width;
          If rc.Right>Width-1 Then rc.Right:=Width-1;

          IsPressed:=section=FClickSection;
          If IsPressed Then
          Begin
               Inc(rc.Left);
               Inc(rc.Right);
               Dec(rc.Bottom);
               Dec(rc.Top);
          End;

          Canvas.ExcludeClipRect(rc);
          Inc(rc.Left,section.Width+FSpacing+1);
     End;

     //Draw rest Bevel
     If FSections<>Nil Then If ((rc.Left<Width)And(FSections.Count>0)) Then
     Begin
          rc.Right:=Width-1;
          Canvas.ExcludeClipRect(rc);
     End;


     Canvas.FillRect(rec,color); //Delete rest
     Canvas.DeleteClipRegion;
End;

Type
    PHeaderItem=^THeaderItem;
    THeaderItem=Record
        Style:THeaderSectionStyle;
        Width:LongInt;
        MinWidth,MaxWidth:LongInt;
        AllowClick,AllowSize:Boolean;
        Alignment:TAlignment;
    End;


Procedure THeaderControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PHeaderItem;
   section:THeaderSection;
   T:LongInt;
   ps:^String;
Begin
     If ResName = rnHeaders Then
     Begin
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


Function THeaderControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:THeaderItem;
    section:THeaderSection;
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

Procedure THeaderControl.SectionClick(section:THeaderSection);
Begin
     If FOnSectionClick<>Nil Then FOnSectionClick(Self,section);
End;

Procedure THeaderControl.SectionResize(section:THeaderSection);
Begin
     If FOnSectionResize<>Nil Then FOnSectionResize(Self,section);
End;

Procedure THeaderControl.SectionTrack(section:THeaderSection;Width:LongInt;State:TSectionTrackState);
Begin
     If FOnSectionTrack<>Nil Then FOnSectionTrack(Self,section,Width,State);
End;

Procedure THeaderControl.SetSpacing(NewValue:LongInt);
Begin
     If NewValue<0 Then NewValue:=0;
     FSpacing:=NewValue;
     Invalidate;
End;

Procedure THeaderControl.SetBevelWidth(NewValue:LongInt);
Begin
     If NewValue<1 Then NewValue:=1;
     If NewValue>20 Then NewValue:=20;
     FBevelWidth:=NewValue;
     Invalidate;
End;

Procedure THeaderControl.SetupComponent;
Begin
     Inherited SetupComponent;

     Align:=alTop;
     color:=clDlgWindow;
     Name:='HeaderControl';
     FSectionsClass:=THeaderSections;
     Height:=50;
     FSpacing:=1;
     FSectionTrackState:=tsTrackEnd;
     FBevelWidth:=1;
     HandlesDesignMouse:=True;
     Include(ComponentState,csAcceptsControls);
     FShape:=crDefault;
End;

Destructor THeaderControl.Destroy;
Begin
     If FSections<>Nil Then FSections.Destroy;
     Inherited Destroy;
End;

Procedure THeaderControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:THeaderSection;
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

Function THeaderControl.GetMouseHeader(X,Y:LongInt):THeaderSection;
Var T:LongInt;
    section:THeaderSection;
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

Procedure THeaderControl.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var section:THeaderSection;
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

Procedure THeaderControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var ClickHeader:THeaderSection;
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

Procedure THeaderControl.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:THeaderSection;
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

Function THeader.GetSectionWidth(Index:LongInt):LongInt;
Begin
     Result:=Sections.Items[Index].Width;
End;

Procedure THeader.SetSectionWidth(Index:LongInt;NewValue:LongInt);
Begin
     Sections.Items[Index].Width:=NewValue;
End;

Begin
End.



