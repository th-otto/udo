
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit StdCtrls;


Interface

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmGpi,PmDev,PmStdDlg;
{$ENDIF}

{$IFDEF Win95}
Uses WinDef,WinBase,WinNt,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Dos,SysUtils,Classes,Forms,Graphics,Buttons;


Type
    TGroupBox=Class(TControl)
      Private
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Function EvaluateShortCut(KeyCode:TKeyCode):Boolean;Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
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
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TLabel=Class(TControl)
      Private
         RemoveAccel:Boolean;
         FAutoSize:Boolean;
         FAlignment:TAlignment;
         FWordWrap:Boolean;
         FRows:Integer;
         FFocusControl:TControl;
         FShowAccelChar:Boolean;
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
         Procedure SetAutoSize(Value:Boolean);
         Procedure SetAlignment(Value:TAlignment);
         Procedure SetWordWrap(Value:Boolean);
         Procedure SetAccelChar(Value:Boolean);
         Procedure SetFocusControl(Value:TControl);
         Function GetRows:Integer;
         Procedure DoDrawLine(Const S:String; Var Row:Integer);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Function EvaluateShortCut(KeyCode:TKeyCode):Boolean;Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Property Rows:Integer Read GetRows;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property AutoSize:Boolean Read FAutoSize Write SetAutoSize;
         Property Caption;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property FocusControl:TControl Read FFocusControl Write SetFocusControl;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property ShowAccelChar:Boolean Read FShowAccelChar Write SetAccelChar;
         Property ShowHint;
         Property Visible;
         Property WordWrap:Boolean Read FWordWrap Write SetWordWrap;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnCommand;
         Property OnDblClick;
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
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    EMemoIndexError=Class(Exception);

    TMemo=Class(TControl)
      Private
         FLines:TStrings;
         FInitLines:TStringList;
         FScrollBars:TScrollStyle;
         FBorderStyle:TBorderStyle;
         FWordWrap:Boolean;
         FReadOnly:Boolean;
         FWantTabs:Boolean;
         FModified:Boolean;
         FOnChange:TNotifyEvent;
         FUpdateCount:LongInt;
         FEnableWindowUpdate:Boolean;
      Private
         Function GetLines:TStrings;
         Procedure SetLines(AStrings:TStrings);
         Procedure SetScrollBars(NewValue:TScrollStyle);
         Procedure SetBorderStyle(NewBorder:TBorderStyle);
         Procedure SetWordWrap(Value:Boolean);
         Procedure SetReadOnly(Value:Boolean);
         Procedure SetWantTabs(Value:Boolean);
         {$IFDEF Win95}
         Procedure WMGetDlgCode(Var Msg:TMessage); Message WM_GETDLGCODE;
         {$ENDIF}
      Protected
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure DestroyWnd;Override;
         Procedure ParentNotification(Var Msg:TMessage);Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure Resize;Override;
         Procedure Changed;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Clear;
         Procedure ClearSelection;
         Procedure CutToClipBoard;
         Procedure CopyToClipboard;
         Procedure PasteFromClipBoard;
         Procedure SelectAll;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Procedure BeginUpdate;
         Procedure EndUpdate;
      Public
         Property Modified:Boolean Read FModified Write FModified;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property Lines:TStrings Read GetLines Write SetLines;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property ReadOnly:Boolean Read FReadOnly Write SetReadOnly;
         Property ScrollBars:TScrollStyle Read FScrollBars Write SetScrollBars;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property WantTabs:Boolean Read FWantTabs Write SetWantTabs;
         Property WordWrap:Boolean Read FWordWrap Write SetWordWrap;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
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
    TEditCharCase = (ecNormal,ecUpperCase,ecLowerCase);
    {$M-}

    TEdit=Class(TControl)
      Private
         FMaxLength:LongInt;
         FAlignment:TAlignment;
         FUnreadable:Boolean;
         FModified:Boolean;
         FAutoSize:Boolean;
         FAutoScroll:Boolean;
         FAutoSelect:Boolean;
         FExtension:PString;
         FBorderStyle:TBorderStyle;
         FInsertMode:Boolean;
         FReadOnly:Boolean;
         FCharCase:TEditCharCase;
         FSelStart:LongInt;
         FSelLen:LongInt;
         FTempCaption:PString;
         FNumbersOnly:Boolean;
         FOnChange:TNotifyEvent;
         Procedure SetMaxLength(Value:LongInt);
         Procedure SetUnreadable(Value:Boolean);
         Procedure SetBorderStyle(Value:TBorderStyle);
         Procedure SetAutoSize(Value:Boolean);
         Procedure SetAlignment(Value:TAlignment);
         Procedure SetAutoScroll(Value:Boolean);
         Procedure SetSelStart(X:LongInt);
         Function GetSelStart:LongInt;
         Procedure SetSelLength(X:LongInt);
         Function GetSelLength:LongInt;
         Function GetSelText:String;
         Procedure SetSelText(Const Value:String);
         Procedure SetExtension(Const Value:String);
         Function GetExtension:String;
         Procedure SetReadOnly(Value:Boolean);
         Procedure SetInsertMode(Value:Boolean);
         Procedure SetCharCase(Value:TEditCharCase);
         Procedure AdjustHeight;Virtual;
         Procedure SetSelection(Start,len:LongInt);
      Protected
         Procedure SetupComponent;Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Procedure CreateWnd;Override;
         Procedure SetupShow;Override;
         Procedure DestroyWnd;Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure ParentNotification(Var Msg:TMessage);Override;
         Procedure FontChange;Override;
         Procedure Change;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Clear;
         Procedure ClearSelection;
         Procedure CutToClipBoard;
         Procedure CopyToClipboard;
         Procedure PasteFromClipBoard;
         Procedure SelectAll;
         Property Modified:Boolean Read FModified Write FModified;
         Property SelStart:LongInt Read GetSelStart Write SetSelStart;
         Property SelLength:LongInt Read GetSelLength Write SetSelLength;
         Property SelText:String Read GetSelText Write SetSelText;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Alignment:TAlignment Read FAlignment Write SetAlignment;
         Property AutoScroll:Boolean Read FAutoScroll Write SetAutoScroll;
         Property AutoSelect:Boolean Read FAutoSelect Write FAutoSelect;
         Property AutoSize:Boolean Read FAutoSize Write SetAutoSize;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property CharCase:TEditCharCase Read FCharCase Write SetCharCase;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property InsertMode:Boolean Read FInsertMode Write SetInsertMode;
         Property MaxLength:LongInt Read FMaxLength Write SetMaxLength;
         Property NumbersOnly:Boolean Read FNumbersOnly Write FNumbersOnly;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property ReadOnly:Boolean Read FReadOnly Write SetReadOnly;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Text;
         Property TextExtension:String Read GetExtension Write SetExtension;
         Property Unreadable:Boolean Read FUnreadable Write SetUnreadable;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnResize;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TComboBox=Class;

    EListBoxIndexError=Class(Exception);

    {$M+}
    TListBoxStyle=(lbStandard,lbOwnerdrawFixed);

    TOwnerDrawState=Set Of (odSelected,odGrayed,odDisabled,odChecked,odFocused);

    TItemFocusEvent=Procedure(Sender:TObject;Index:LongInt) Of Object;
    TItemSelectEvent=Procedure(Sender:TObject;Index:LongInt) Of Object;
    TListBoxMeasureItemEvent=Procedure(Sender:TObject;Index:LongInt;
         Var Width,Height:LongInt) Of Object;
    TListBoxDrawItemEvent=Procedure(Sender:TObject;Index:LongInt;
         rec:TRect;State:TOwnerDrawState) Of Object;
    {$M-}

    TListBox=Class(TControl)
      Private
         FDragging:Boolean;
         FComboBox:TComboBox;
         FItems:TStrings;
         FInitItems:TStringList;
         FInitItemIndex:LongInt;
         FInitTopIndex:LongInt;
         FStyle:TListBoxStyle;
         FIntegralHeight:Boolean;
         FHorzScroll:Boolean;
         FMultiSelect:Boolean;
         FExtendedSelect:Boolean;
         FSorted:Boolean;
         FItemHeight:LongInt;
         FDuplicates:Boolean; {only For Add}
         FUpdateCount:LongInt;
         FDragSelected:LongInt;
         FDragRectValid:Boolean;
         FDragRect:TRect;
         FShowDragRects:Boolean;
         FEnableWindowUpdate:Boolean;
         FOnItemFocus:TItemFocusEvent;
         FOnItemSelect:TItemSelectEvent;
         FOnMeasureItem:TListBoxMeasureItemEvent;
         FOnDrawItem:TListBoxDrawItemEvent;
         Procedure SetIntegralHeight(Value:Boolean);
         Procedure SetHorzScroll(Value:Boolean);
         Procedure SetMultiSelect(Value:Boolean);
         Procedure SetExtendedSelect(Value:Boolean);
         Procedure SetSorted(Value:Boolean);
         Procedure SetStyle(NewStyle:TListBoxStyle);
         Function GetItems:TStrings;
         Procedure SetItems(AStrings:TStrings);
         Function GetItemIndex:LongInt;
         Procedure SetItemIndex(Value:LongInt);
         Function GetSelCount:LongInt;
         Function GetSelect(Index:LongInt):Boolean;
         Procedure SetSelect(Index:LongInt;Value:Boolean);
         Function GetTopIndex:LongInt;
         Procedure SetTopIndex(Index:LongInt);
         Function GetItemHeight:LongInt;
         Procedure SetItemHeight(Value:LongInt);
         Procedure DrawDragRect;
      Protected
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure DestroyWnd;Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure ParentNotification(Var Msg:TMessage);Override;
         Procedure ItemFocus(Index:LongInt);Virtual;
         Procedure ItemSelect(Index:LongInt);Virtual;
         Procedure MeasureItem(Index:LongInt;Var Width,Height:LongInt);Virtual;
         Procedure DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);Virtual;
         Procedure DragOver(Source:TObject;X,Y:LongInt;State:TDragState;
                            Var Accept:Boolean);Override;
         Procedure DragDrop(Source:TObject;X,Y:LongInt);Override;
         Procedure KillFocus;Override;
      Public
         Destructor Destroy;Override;
         Procedure Show;Override;
         Procedure Clear;Virtual;
         Procedure BeginUpdate;
         Procedure EndUpdate;
         Function ItemAtPos(Pos:TPoint;existing:Boolean):LongInt;
         Function ItemRect(Index:LongInt):TRect;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Property ItemIndex:LongInt Read GetItemIndex Write SetItemIndex;
         Property SelCount:LongInt Read GetSelCount;
         Property Selected[Index:LongInt]:Boolean Read GetSelect Write SetSelect;
         Property TopIndex:LongInt Read GetTopIndex Write SetTopIndex;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Duplicates:Boolean Read FDuplicates Write FDuplicates;
         Property Enabled;
         Property ExtendedSelect:Boolean Read FExtendedSelect Write SetExtendedSelect;
         Property Font;
         Property HorzScroll:Boolean Read FHorzScroll Write SetHorzScroll;
         Property IntegralHeight:Boolean Read FIntegralHeight Write SetIntegralHeight;
         Property ItemHeight:LongInt Read GetItemHeight Write SetItemHeight;
         Property Items:TStrings Read GetItems Write SetItems;
         Property MultiSelect:Boolean Read FMultiSelect Write SetMultiSelect;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property ShowDragRects:Boolean Read FShowDragRects Write FShowDragRects;
         Property ShowHint;
         Property Sorted:Boolean Read FSorted Write SetSorted;
         Property Style:TListBoxStyle Read FStyle Write SetStyle;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDrawItem:TListBoxDrawItemEvent Read FOnDrawItem Write FOnDrawItem;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnItemFocus:TItemFocusEvent Read FOnItemFocus Write FOnItemFocus;
         Property OnItemSelect:TItemSelectEvent Read FOnItemSelect Write FOnItemSelect;
         Property OnKeyPress;
         Property OnMeasureItem:TListBoxMeasureItemEvent Read FOnMeasureItem Write FOnMeasureItem;
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
    TComboBoxStyle=(csDropDown,csSimple,csDropDownList);
    {$M-}

    // Event for drawing an owner draw combobox.
    // S indicates the text to be drawn
    // Data is the object data
    TComboBoxDrawItemEvent=procedure( Canvas: TCanvas;
                                      S: string;
                                      Data: TObject;
                                      Rect: TRect;
                                      State: TOwnerDrawState ) of object;
    TStandardComboEdit=Class;
    TOwnerDrawComboEdit=Class;

    {$HINTS OFF}
    TComboBox=Class(TControl)
      Private
         FListBoxHeight:LongInt;
         FStyle:TComboBoxStyle;
         FEdit:TControl; // either a standard or owner draw comboedit
         FEditHeight:LongInt;
         FShowButton:TControl;
         FListBox:TListBox;
         FDropped:Boolean;
         FSelectedObject:TObject; // selected object
         FAlternate:Boolean;
         FDropDownCount:LongInt;
         FPopupMenu:TPopupMenu;
         FBorderStyle:TBorderStyle;

         FOnItemFocus:TItemFocusEvent;
         FOnItemSelect:TItemSelectEvent;
         FOnDrawItem:TComboBoxDrawItemEvent;
         FOnDropDown:TNotifyEvent;
         FOnChange:TNotifyEvent;
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;
         Procedure EvEditChanged(Sender:TObject);
         Procedure EvEditEnter(Sender:TObject);
         Procedure EvEditExit(Sender:TObject);
         Procedure EvKillFocus(Sender:TObject);
         Function GetListBoxHeight:LongInt;
         Procedure SetupShowButton;
         Procedure DestroyShowButton;
         Procedure SetStyle(NewStyle:TComboBoxStyle);
         Function GetItems:TStrings;
         Procedure SetItems(AStrings:TStrings);
         Function GetItemIndex:LongInt;
         Procedure SetItemIndex(Value:LongInt);
         Function GetSorted:Boolean;
         Procedure SetSorted(Value:Boolean);
         Function GetDuplicates:Boolean;
         Procedure SetDuplicates(Value:Boolean);
         Procedure SetExtension(Const Value:String);
         Function GetExtension:String;
         Function GetMaxLength:Integer;
         Procedure SetMaxLength(tl:Integer);
         Procedure SetSelStart(X:Integer);
         Function GetSelStart:Integer;
         Procedure SetSelLength(X:Integer);
         Function GetSelLength:Integer;
         Function GetSelText:String;
         Procedure SetSelText(Const Value:String);
         Procedure SetAlternate(Value:Boolean);
         Procedure SetDroppedDown(Value:Boolean);
         Procedure AdjustDropDown;
         Procedure SetPopupMenu(NewMenu:TPopupMenu);
         Procedure SetBorderStyle(NewValue:TBorderStyle);
         Procedure SetOwnerDraw(NewValue:Boolean);
         Function StandardEdit: TStandardComboEdit;
         Function UsesStandardEdit: boolean;
         Function GetListItemIndexAtCursor: longint;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure DestroyWnd;Override;
         Procedure Move;Override;
         Procedure Resize;Override;
         Procedure EditChange;Virtual;
         Procedure FontChange;Override;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;
         Procedure ItemFocus(Index:LongInt);Virtual;
         Procedure ItemSelect(Index:LongInt);Virtual;
         Procedure ListBoxMouseUp;
         Procedure UpdateListBoxPos(Var aLeft,aBottom,aWidth,aHeight:LongInt);Virtual;
         Property AlternateButton:Boolean Read FAlternate Write SetAlternate;
         Procedure DrawListBoxItem( Sender:TObject;
                                    Index:LongInt;
                                    rec:TRect;
                                    State:TOwnerDrawState);
         Procedure CreateEdit;
      Public
         Destructor Destroy;Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Procedure Invalidate;Override;
         Procedure Update;Override;
         Procedure Hide;Override;
         Procedure SelectAll;
         Procedure Clear;
         Procedure BeginUpdate;
         Procedure EndUpdate;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Property ItemIndex:LongInt Read GetItemIndex Write SetItemIndex;
         Property SelectedObject: TObject read FSelectedObject;
         Property DroppedDown:Boolean Read FDropped Write SetDroppedDown;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property DropDownCount:LongInt Read FDropDownCount Write FDropDownCount;
         Property Duplicates:Boolean Read GetDuplicates Write SetDuplicates;
         Property Enabled;
         Property Font;
         Property Items:TStrings Read GetItems Write SetItems;
         Property MaxLength:Integer Read GetMaxLength Write SetMaxLength;
         Property OwnerDraw:Boolean Read FOwnerDraw Write SetOwnerDraw;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu:TPopupMenu Read FPopupMenu Write SetPopupMenu;
         Property SelLength:Integer Read GetSelLength Write SetSelLength;
         Property SelStart:Integer Read GetSelStart Write SetSelStart;
         Property SelText:String Read GetSelText Write SetSelText;
         Property ShowHint;
         Property Sorted:Boolean Read GetSorted Write SetSorted;
         Property Style:TComboBoxStyle Read FStyle Write SetStyle;
         Property TabOrder;
         Property TabStop;
         Property Text;
         Property TextExtension:String Read GetExtension Write SetExtension;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnClick;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDrawItem:TComboBoxDrawItemEvent Read FOnDrawItem Write FOnDrawItem;
         Property OnDropDown:TNotifyEvent Read FOnDropDown Write FOnDropDown;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnItemFocus:TItemFocusEvent Read FOnItemFocus Write FOnItemFocus;
         Property OnItemSelect:TItemSelectEvent Read FOnItemSelect Write FOnItemSelect;
         Property OnKeyPress;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;
    {$HINTS ON}


    {$M+}
    TValueSetContentStyle=(vscBitmap,vscText,vscRGBColor);
    {$M-}

    TValueSet=Class(TScrollingWinControl)
      Private
         FMemory:Pointer;
         FRows:LongInt;
         FColumns:LongInt;
         FCount:LongInt;
         FSelection:LongInt;
         FCtl3D:Boolean;
         FBorderStyle:TBorderStyle;
         FItemBorder:TBorderStyle;
         FScaleBitmap:Boolean;
         FContentStyle:TValueSetContentStyle;
         FAutoSize:Boolean;
         FMargin,FSpacing:LongInt;
         FItemWidth,FItemHeight:LongInt;
         FUpdateCount:LongInt;
         FOnItemFocus:TItemFocusEvent;
         FOnItemSelect:TItemSelectEvent;
         Procedure SetCtl3D(Value:Boolean);
         Procedure SetBorderStyle(Value:TBorderStyle);
         Procedure SetItemBorder(Value:TBorderStyle);
         Procedure SetScaleBitmap(Value:Boolean);
         Procedure SetContentStyle(NewStyle:TValueSetContentStyle);
         Procedure SetRows(Value:LongInt);
         Procedure SetColumns(Value:LongInt);
         Function GetData(Index:LongInt):Pointer;
         Procedure FreeData(Index:LongInt);
         Procedure SetRGB(Index:LongInt;NewValue:TColor);
         Function GetRGB(Index:LongInt):TColor;
         Procedure SetBitmap(Index:LongInt;NewValue:TBitmap);
         Function GetBitmap(Index:LongInt):TBitmap;
         Procedure SetText(Index:LongInt;NewValue:String);
         Function GetText(Index:LongInt):String;
         Procedure SetAutoSize(NewValue:Boolean);
         Procedure SetItemWidth(NewValue:LongInt);
         Procedure SetItemHeight(NewValue:LongInt);
         Procedure SetSelection(Value:LongInt);
         Procedure SetupScrollBars;
         Procedure GetXYVisible(Var xVisible,yVisible:LongInt);
      Protected
         Function RectFromIndex(Index:LongInt):TRect;
         Function IndexFromPoint(X,Y:LongInt):LongInt;
         Procedure SetupComponent;Override;
         Procedure DrawSelection(Index:LongInt);Virtual;
         Procedure DrawInterior(Index:LongInt);Virtual;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure ItemFocus(Index:LongInt);Virtual;
         Procedure ItemSelect(Index:LongInt);Virtual;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure Resize;Override;
         Procedure SetupShow;Override;
         Procedure Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);Override;
         Property Margin:LongInt Read FMargin Write FMargin;
         Property Spacing:LongInt Read FSpacing Write FSpacing;
         Property Scrollbars;
      Public
         Destructor Destroy;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Function IndexFromColumnRow(Column,Row:LongInt):LongInt;
         Procedure ColumnRowFromIndex(Index:LongInt;Var Column,Row:LongInt);
         Procedure SetDimension(Column,Row:LongInt);
         Procedure SetColorArray(Index:LongInt;Const Data:Array Of TColor);
         Procedure SetBitmapArray(Index:LongInt;Const Data:Array Of TBitmap);
         Procedure SetStringArray(Index:LongInt;Const Data:Array Of String);
         Procedure BeginUpdate;
         Procedure EndUpdate;
         Property Count:LongInt Read FCount;
         Property Colors[Index:LongInt]:TColor Read GetRGB Write SetRGB;
         Property Bitmaps[Index:LongInt]:TBitmap Read GetBitmap Write SetBitmap;
         Property Strings[Index:LongInt]:String Read GetText Write SetText;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property AutoSize:Boolean Read FAutoSize Write SetAutoSize;
         Property BorderStyle:TBorderStyle Read FBorderStyle Write SetBorderStyle;
         Property Color;
         Property Ctl3D:Boolean Read FCtl3D Write SetCtl3D;
         Property ColCount:LongInt Read FColumns Write SetColumns;
         Property ContentStyle:TValueSetContentStyle Read FContentStyle Write SetContentStyle;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Font;
         Property ItemBorder:TBorderStyle Read FItemBorder Write SetItemBorder;
         Property ItemHeight:LongInt Read FItemHeight Write SetItemHeight;
         Property ItemWidth:LongInt Read FItemWidth Write SetItemWidth;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PenColor;
         Property PopupMenu;
         Property RowCount:LongInt Read FRows Write SetRows;
         Property ScaleBitmap:Boolean Read FScaleBitmap Write SetScaleBitmap;
         Property Selection:LongInt Read FSelection Write SetSelection;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDblClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnItemFocus:TItemFocusEvent Read FOnItemFocus Write FOnItemFocus;
         Property OnItemSelect:TItemSelectEvent Read FOnItemSelect Write FOnItemSelect;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


Function InsertLabel(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Caption:String):TLabel;
Function InsertComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Style:TComboBoxStyle):TComboBox;
Function InsertValueSet(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Columns,Rows:LongInt;ContentStyle:TValueSetContentStyle):TValueSet;
Function InsertGroupBox(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Caption:String):TGroupBox;
Function InsertEdit(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Text,Hint:String):TEdit;
Function InsertListBox(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Hint:String):TListBox;
Function InsertMemo(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Hint:String):TMemo;
Function InsertScrollBar(parent:TControl;Left,Bottom,Width,Height:LongInt;
           Kind:TScrollBarKind):TScrollBar;


Implementation


Function InsertListBox(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Hint:String):TListBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Hint:=Hint;
     Result.parent := parent;
End;


Function InsertEdit(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Text,Hint:String):TEdit;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Text:=Text;
     Result.Hint:=Hint;
     Result.AutoSize:=True;
     Result.parent := parent;
End;


Function InsertLabel(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Caption:String):TLabel;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.AutoSize := False;  {!}
     Result.parent := parent;
End;


Function InsertGroupBox(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Caption:String):TGroupBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := Caption;
     Result.parent := parent;
End;


Function InsertComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Style:TComboBoxStyle):TComboBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Style := Style;
     Result.parent := parent;
End;


Function InsertValueSet(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Columns,Rows:LongInt;ContentStyle:TValueSetContentStyle):TValueSet;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.ColCount := Columns;
     Result.RowCount := Rows;
     Result.ContentStyle := ContentStyle;
     Result.parent := parent;
End;


Function InsertMemo(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Hint:String):TMemo;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Hint := Hint;
     Result.parent := parent;
End;


Function InsertScrollBar(parent:TControl;Left,Bottom,Width,Height:LongInt;
  Kind:TScrollBarKind):TScrollBar;
Begin
     Result.Create(parent);
     Result.Kind := Kind;
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
บ This section: TComboBox Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TComboListShowButton=Class(TControl)
      Private
         FCombo:TComboBox;
         FDown:Boolean;
         FDroppingDown:Boolean;
         Procedure SetDown(Value:Boolean);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Property Down:Boolean Read FDown Write SetDown;
    End;


Procedure TComboListShowButton.SetupComponent;
Begin
     Inherited SetupComponent;

     color := clBtnFace;
     FDroppingDown := false;
End;


Procedure TComboListShowButton.SetDown(Value:Boolean);
Begin
     If Value <> FDown Then
     Begin
          FDown := Value;
          Refresh;
     End;
End;


Procedure TComboListShowButton.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Begin
     {$IFDEF Win32}
     If FCombo.FEdit.FBorderStyle = bsSingle Then
     Begin
          // decrease size to be inside edit border
          Dec(NewLeft,4);
          Inc(NewBottom,4);
          Dec(NewHeight,2);
     End;
     {$ENDIF}
     Inherited SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
End;


Procedure TComboListShowButton.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If Designed Then Exit;

          LastMsg.Handled := True;
          LastMsg.Result := 0;

          MouseCapture := true;

          if not FCombo.DroppedDown then
          begin
               FCombo.DroppedDown := True;   {aufklappen}
               FDroppingDown := true;
          end;
     End;
End;


Procedure TComboListShowButton.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If Designed Then Exit;
          MouseDown(Button,ShiftState,X,Y);
          {$IFDEF OS2}
          MouseUp(Button,ShiftState,X,Y);   {Win95 sends it Self}
          {$ENDIF}
     End;
End;

Procedure TComboListShowButton.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
var
     Index:longint;
     ThePoints: POINTS;
Begin
     if not MouseCapture then Exit;
     Index := FCombo.GetListItemIndexAtCursor;
     if Index <> -1 then
     Begin
          // focus the item in the listbox.
          FCombo.FListBox.ItemIndex := Index;
     End;
End;

Procedure TComboListShowButton.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If Designed Then Exit;

          If not MouseCapture Then Exit;

          MouseCapture := false;

          if FDroppingDown Then
          Begin
              // Mouse up after initial click.
              FDroppingDown := false;
              if FCombo.GetListItemIndexAtCursor <> -1 then
              begin
                   // release over list box; select item
                   FCombo.ItemSelect( FCombo.FListBox.ItemIndex );
                   FCombo.DroppedDown := False;  {einklappen}
              end
              else if not PointInRect(Point(X,Y),ClientRect) then
              begin
                   // outside of the button/listbox, so cancel
                   FCombo.DroppedDown := False;  {einklappen}
              end;
          End
          else
          Begin
              // click while combo is already dropped down
              if PointInRect(Point(X,Y),ClientRect) then
              Begin
                   // second click to close.
                   FCombo.DroppedDown := False;
                   // select the item
                   FCombo.ItemSelect( FCombo.FListBox.ItemIndex );
              End;
          End;

          LastMsg.Handled := True;
          LastMsg.Result := 0;
     End;
End;


Procedure TComboListShowButton.Redraw(Const rec:TRect);
Var  pt:TPoint;
     arrow:Array[0..2] Of TPoint;
     rc1,rec1:TRect;
     Alternate:Boolean;
Begin
     If Canvas = Nil Then Exit;

     Inherited Redraw(rec);

     rc1 := ClientRect;

     Canvas.Pen.color := clBtnShadow;
     Canvas.Line(rc1.Left,rc1.Bottom,rc1.Left,rc1.Top);
     Inc(rc1.Left);
     {$IFDEF OS2}
     If Down Then
     Begin
          Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
          InflateRect(rc1,-1,-1);
          Canvas.ShadowedBorder(rc1,clBtnShadow,clBtnHighlight);
          Inc(rc1.Left);
          Dec(rc1.Bottom);
          Inc(rc1.Right);
          Dec(rc1.Top);
     End Else
     Begin
          Canvas.ShadowedBorder(rc1,clBtnHighlight,clBtnShadow);
          InflateRect(rc1,-1,-1);
          Canvas.ShadowedBorder(rc1,clBtnHighlight,clBtnShadow);
     End;
     {$ENDIF}

     {$IFDEF Win32}
     If Down Then
     Begin
          Canvas.Pen.color := clBtnShadow;
          Canvas.Rectangle(rc1);
     End
     Else
     Begin
          Canvas.ShadowedBorder(rc1,clBtnHighlight,cl3DDkShadow);
          InflateRect(rc1,-1,-1);
          Canvas.ShadowedBorder(rc1,cl3DLight,clBtnShadow);
     End;
     {$ENDIF}

     InflateRect(rc1,-1,-1);

     If FCombo <> Nil Then Alternate := FCombo.AlternateButton
     Else Alternate := False;

     Canvas.Pen.color := clBtnText;
     If Alternate Then
     Begin
          pt.X := (rc1.Left + rc1.Right) Div 2;
          pt.Y := (rc1.Bottom + rc1.Top) Div 2;

          rec1.Left := pt.X-4;
          rec1.Bottom := pt.Y;
          rec1.Right := rec1.Left+1;
          rec1.Top := rec1.Bottom+1;
          Canvas.Box(rec1);
          rec1.Left := pt.X;
          rec1.Bottom := pt.Y;
          rec1.Right := rec1.Left+1;
          rec1.Top := rec1.Bottom+1;
          Canvas.Box(rec1);
          rec1.Left := pt.X+4;
          rec1.Bottom := pt.Y;
          rec1.Right := rec1.Left+1;
          rec1.Top := rec1.Bottom+1;
          Canvas.Box(rec1);
     End
     Else
     Begin
          pt.X := (rc1.Left + rc1.Right) Div 2;
          pt.Y := (rc1.Bottom+rc1.Top) Div 2 + 2;

          arrow[0].X := pt.X - 3;
          arrow[0].Y := pt.Y;
          arrow[1].X := pt.X + 3;
          arrow[1].Y := pt.Y;
          arrow[2].X := pt.X;
          arrow[2].Y := pt.Y - 3;
          Canvas.Polygon(arrow);
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TOwnerDrawComboEdit Class                                   บ
บ This is a completely custom drawn control, not based on an edit box.      บ
บ As well as handling some keys and doing autoheight, it has a paint        บ
บ method and handles various events to redraw itself. It's paint method     บ
บ only normally draws the border, passing the remainder to the combo box    บ
บ drawitem event.                                                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TOwnerDrawComboEdit=Class(TControl)
      Private
         FComboBox:TComboBox;
         FBorderStyle:TBorderStyle;
         Procedure EvKeyPress(Sender:TObject;Var Key:Char);
         Procedure EvScan(Sender:TObject;Var KeyCode:TKeyCode);
      Protected
         Procedure CMTextChanged(Var Msg:TMessage);Message CM_TEXTCHANGED;

         // Adjust size automatically...
         Procedure SetupShow;Override;
         Procedure SetBorderStyle(Value:TBorderStyle);
         Procedure AdjustHeight;
         Procedure FontChange;Override;

         Procedure SetupComponent;Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure Resize;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure SetFocus;Override;
         Procedure KillFocus;Override;

         Procedure Paint(const rec:TRect);Override;
      Public
         Property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    End;

Procedure TOwnerDrawComboEdit.SetupComponent;
Begin
     inherited SetupComponent;

     Name := 'OwnerDrawComboEdit';
     Caption := '';
     Width := 100;
     Height := 20;
     Color := clEntryField;
     ParentPenColor := False;
     ParentColor := False;
     Ownerdraw := True;

     FBorderStyle := bsSingle;
     FTabOrder := 0;
end;

Procedure TOwnerDrawComboEdit.SetupShow;
begin
     inherited SetupShow;
     AdjustHeight;
end;

Procedure TOwnerDrawComboEdit.CMTextChanged(Var Msg:TMessage);
begin
     if FComboBox <> nil then
          FComboBox.EvEditChanged( self ); // tell the combo about it.
     // Our text has changed, repaint!
     Invalidate;
end;

Procedure TOwnerDrawComboEdit.Paint(const rec:TRect);
var
     Rect: TRect;
     State: TOwnerDrawState;
Begin
     Canvas.ClipRect := rec;
     Rect := ClientRect;

     // Draw border if one is needed.
     DrawSystemBorder( self, Rect, FBorderStyle );

     dec( Rect.Right, FComboBox.FShowButton.Width );

     // leave 1 pixel blank as per standard controls
     Canvas.Pen.Color := Color;
     Canvas.Pen.Style := psSolid;
     Canvas.Rectangle( Rect );
     InflateRect( Rect, -1, -1 );

     // prevent user from overwriting stuff
     Canvas.ClipRect := IntersectRect( rec, Rect );

     // Work out the state of drawing
     State := [];
     if HasFocus then
     begin
          Include( State, odFocused );
          Include( State, odSelected ); // always for an owner draw edit
     end;
     if not FComboBox.Enabled then
          Include( State, odDisabled );

     // Draw the selected combo item, if there is one,
     // otherwise draw blank box.
     if FComboBox.FOnDrawItem <> nil then
     begin
          FComboBox.FOnDrawItem( Canvas, Text, FComboBox.SelectedObject, Rect, State )
     end
     else
     begin
          if odSelected in State then
               Canvas.FillRect( Rect, clHighlight )
          else
               Canvas.FillRect( Rect, Color );
     end;
end;

Procedure TOwnerDrawComboEdit.SetBorderStyle(Value:TBorderStyle);
Begin
     If FBorderStyle <> Value Then
     Begin
          FBorderStyle := Value;
          AdjustHeight;
          Refresh;
     End;
End;

// Adjust the control height to match the height of
// the font being used, taking border into account
Procedure TOwnerDrawComboEdit.AdjustHeight;
Var
     NewHeight:LongInt;
Begin
     NewHeight := Font.Height + 2;
     If FBorderStyle = bsSingle Then Inc( NewHeight,4 );
     Height := NewHeight;
     If FComboBox <> Nil Then FComboBox.Resize;
End;


Procedure TOwnerDrawComboEdit.FontChange;
Begin
     // Font has changed, so adjust height to match
     AdjustHeight;

     Inherited FontChange;
End;

Procedure TOwnerDrawComboEdit.SetFocus;
Begin
     Inherited SetFocus;
     Refresh;
End;

Procedure TOwnerDrawComboEdit.KillFocus;
Begin
     Inherited KillFocus;
     Refresh;
End;

// The remaining methods of TOwnerDrawComboEdit are basically copies
// of TStandardComboEdit. I couldn't see any clean way to share them.
//  Multiple inheritance would have been nice :)
Procedure TOwnerDrawComboEdit.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button=mbLeft Then If FComboBox.Enabled Then
     Begin
          // If combo text is not editable:
          If FComboBox.FStyle=csDropDownList Then
          Begin
            // Drop down when the edit is clicked.
            MouseCapture:=False;
            FComboBox.DroppedDown:=not FComboBox.DroppedDown;
          End;
     End;
End;

Procedure TOwnerDrawComboEdit.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If Designed Then Exit;
          MouseDown(Button,ShiftState,X,Y);
          MouseDown(Button,ShiftState,X,Y);
     End;
End;

Procedure TOwnerDrawComboEdit.CharEvent(Var key:Char;RepeatCount:Byte);
Begin
     If FComboBox<>Nil Then
       If FComboBox.Style=csDropDownList Then
       begin
         // send the keypress to the listbox
         SendMsg( FComboBox.FListBox.Handle,
                  WM_CHAR,
                  KC_CHAR,
                  MPARAM( key ) );
         FComboBox.ItemSelect(FComboBox.FListBox.ItemIndex);
         FComboBox.SelectAll;
         key:=#0;
       end;

     Inherited CharEvent(key,RepeatCount);
End;


Procedure TOwnerDrawComboEdit.EvKeyPress(Sender:TObject;Var Key:Char);
Begin
     If FComboBox <> Nil Then
       If FComboBox.OnKeyPress <> Nil Then FComboBox.OnKeyPress(FComboBox, Key);
End;


Procedure TOwnerDrawComboEdit.EvScan(Sender:TObject;Var KeyCode:TKeyCode);
Begin
     If FComboBox <> Nil Then
       If FComboBox.OnScan <> Nil Then FComboBox.OnScan(FComboBox, KeyCode);
End;


Procedure TOwnerDrawComboEdit.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     If FComboBox <> Nil Then
     Begin
          Case KeyCode Of
            kbAltCDown:
            Begin
                 FComboBox.DroppedDown := True;
                 KeyCode := kbNull;
            End;
            kbAltCUp:
            Begin
                 FComboBox.DroppedDown := False;
                 KeyCode := kbNull;
            End;
            kbCDown:
            Begin
                 If FComboBox.ItemIndex < FComboBox.Items.Count - 1 Then
                 Begin
                      FComboBox.ItemIndex := FComboBox.ItemIndex + 1;
                      FComboBox.ItemSelect(FComboBox.ItemIndex);
                      FComboBox.SelectAll;
                 End;
                 KeyCode := kbNull;
            End;
            kbCUp:
            Begin
                 If FComboBox.ItemIndex > 0 Then
                 Begin
                      FComboBox.ItemIndex := FComboBox.ItemIndex - 1;
                      FComboBox.ItemSelect(FComboBox.ItemIndex);
                      FComboBox.SelectAll;
                 End;
                 KeyCode := kbNull;
            End;
            else
              Inherited ScanEvent(KeyCode,RepeatCount);
          End;
     End
     Else Inherited ScanEvent(KeyCode,RepeatCount);
End;


Procedure TOwnerDrawComboEdit.Resize;
Var  rec:TRect;
     Button:TControl;
Begin
     Inherited Resize;

     rec := ClientRect;
     If FBorderStyle = bsSingle Then InflateRect(rec, -2, -2);

     If FComboBox <> Nil Then
       If FComboBox.FShowButton <> Nil Then
       Begin
            Button := FComboBox.FShowButton;
            Button.SetWindowPos(rec.Right-Button.Width+1,rec.Bottom,
                                Button.Width,rec.Top-rec.Bottom);
       End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TStandardComboEdit Class                                    บ
บ This is a standard edit box, modified to pass some key strokes to the     บ
บ list part of the combo. It has hard-coded autoheight (so the edit height  บ
บ exactly fits the font and border (if any). This edit is used for cases    บ
บ where the combo edit can be modified, or the combo is not owner drawn.    บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}
type
    TStandardComboEdit=Class(TEdit)
      Private
         FComboBox:TComboBox;
         Procedure AdjustHeight;Override;
         Procedure EvKeyPress(Sender:TObject;Var Key:Char);
         Procedure EvScan(Sender:TObject;Var KeyCode:TKeyCode);
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Override;
         Procedure Resize;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
    End;

Procedure TStandardComboEdit.SetupComponent;
Begin
     Inherited SetupComponent;
     If Not Designed Then Include(ComponentState, csAcceptsControls);
     OnKeyPress := EvKeyPress;
     OnScan := EvScan;
     FTabOrder := 0;
End;

Procedure TStandardComboEdit.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);
     Params.Style := Params.Style Or WS_CLIPCHILDREN; {clip ShowButton}
End;

Procedure TStandardComboEdit.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button=mbLeft Then If FComboBox.Enabled Then
     Begin
          // If combo text is not editable:
          If FComboBox.FStyle=csDropDownList Then
          Begin
            // Drop down when the edit is clicked.
            MouseCapture:=False;
            FComboBox.DroppedDown:=not FComboBox.DroppedDown;
          End;
     End;
End;

Procedure TStandardComboEdit.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If Designed Then Exit;
          MouseDown(Button,ShiftState,X,Y);
          MouseDown(Button,ShiftState,X,Y);
     End;
End;


Procedure TStandardComboEdit.AdjustHeight;
Begin
     Inherited AdjustHeight;
     If FComboBox <> Nil Then FComboBox.Resize; // tell the combo to resize to match
End;


Procedure TStandardComboEdit.CharEvent(Var key:Char;RepeatCount:Byte);
Begin
     If FComboBox<>Nil Then
       If FComboBox.Style=csDropDownList Then
       begin
         // send the keypress to the listbox
         SendMsg( FComboBox.FListBox.Handle,
                  WM_CHAR,
                  KC_CHAR,
                  MPARAM( key ) );
         FComboBox.ItemSelect(FComboBox.FListBox.ItemIndex);
         FComboBox.SelectAll;
         key:=#0;
       end;

     Inherited CharEvent(key,RepeatCount);
End;


Procedure TStandardComboEdit.EvKeyPress(Sender:TObject;Var Key:Char);
Begin
     If FComboBox <> Nil Then
       If FComboBox.OnKeyPress <> Nil Then FComboBox.OnKeyPress(FComboBox, Key);
End;


Procedure TStandardComboEdit.EvScan(Sender:TObject;Var KeyCode:TKeyCode);
Begin
     If FComboBox <> Nil Then
       If FComboBox.OnScan <> Nil Then FComboBox.OnScan(FComboBox, KeyCode);
End;


Procedure TStandardComboEdit.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     If FComboBox <> Nil Then
     Begin
          Case KeyCode Of
            kbAltCDown:
            Begin
                 FComboBox.DroppedDown := True;
                 KeyCode := kbNull;
            End;
            kbAltCUp:
            Begin
                 FComboBox.DroppedDown := False;
                 KeyCode := kbNull;
            End;
            kbCDown:
            Begin
                 If FComboBox.ItemIndex < FComboBox.Items.Count - 1 Then
                 Begin
                      FComboBox.ItemIndex := FComboBox.ItemIndex + 1;
                      FComboBox.ItemSelect(FComboBox.ItemIndex);
                      FComboBox.SelectAll;
                 End;
                 KeyCode := kbNull;
            End;
            kbCUp:
            Begin
                 If FComboBox.ItemIndex > 0 Then
                 Begin
                      FComboBox.ItemIndex := FComboBox.ItemIndex - 1;
                      FComboBox.ItemSelect(FComboBox.ItemIndex);
                      FComboBox.SelectAll;
                 End;
                 KeyCode := kbNull;
            End;
            else
              Inherited ScanEvent(KeyCode,RepeatCount);


//            kbTab,
            {$IFDEF OS2}
//            kbBackTab,
//            kbEnter,
            {$ENDIF}
//            kbCR:Inherited ScanEvent(KeyCode,RepeatCount);
//            Else
//            Begin // WTF? Why!!!
//                 If FComboBox.Style=csDropDownList Then KeyCode:=kbNull
//                 Else Inherited ScanEvent(KeyCode,RepeatCount);
//            End;
          End;
     End
     Else Inherited ScanEvent(KeyCode,RepeatCount);
End;


Procedure TStandardComboEdit.Resize;
Var  rec:TRect;
     Button:TControl;
Begin
     Inherited Resize;

     // Adjust the dropdown button size to fit.
     rec := ClientRect;
     If FBorderStyle = bsSingle Then InflateRect(rec, -2, -2);

     If FComboBox <> Nil Then
       If FComboBox.FShowButton <> Nil Then
       Begin
            Button := FComboBox.FShowButton;
            Button.SetWindowPos(rec.Right-Button.Width+1,rec.Bottom,
                                Button.Width,rec.Top-rec.Bottom);
       End;
End;

/////////////////////////////////////////////////////////////////////////////


Procedure TComboBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'ComboBox';
     Height := 120;
     Width := 100;
     {Include(WindowStyle, wsChild);????????}

     FOwnerDraw := false;
     Color := clEntryField;
     ParentPenColor := False;
     ParentColor := False;

     FListBoxHeight := 100;
     FDropDownCount := 8;
     FStyle := csDropDown;
     FDropped := False;
     FBorderStyle := bsSingle;

     FEdit := nil;

     FListBox.Create(Self);
     FListBox.Visible := False;
     FListBox.TabStop := False;
     FListBox.FComboBox := Self;
     FListBox.ParentPenColor := True;
     FListBox.ParentColor := True;
     FListBox.SetDesigning(Designed);
     FListBox.OnExit := EvKillFocus;
     FListBox.OnDrawItem := DrawListBoxItem;
     Include(FListBox.ComponentState, csDetail);

     // don't insert it into our controls (set parent).
     // We'll do that later when we set the style.

     CreateEdit;

     FTabStop := false; // the edit is the tabstop

End;

// Returns the comboedit as a standard combo edit.
// Will fail with exception if it isn't one.
Function TComboBox.StandardEdit: TStandardComboEdit;
begin
  Result := FEdit as TStandardComboEdit;
end;

Function TComboBox.UsesStandardEdit: boolean;
Begin
  Result :=    ( not FOwnerDraw )
            or ( Style <> csDropDownList );
End;

// Create the combo edit: a standard one if
// the combo is not owner draw, or the text is editable.
// A owner draw edit if the text is not editable (dropdown list) and
// the combo is owner draw.
// Note: If a combo has editable text (simple,dropdown) then the list
// items will be owner drawn but the edit will not.
Procedure TComboBox.CreateEdit;
var
     OwnerDrawEdit: TOwnerDrawComboEdit;
     StandardEdit: TStandardComboEdit;
begin
     if FEdit <> nil then
     begin
       FEdit.Destroy;
       FShowButton := nil;
     end;

     if UsesStandardEdit then
     begin
       StandardEdit := TStandardComboEdit.Create(Self);
       StandardEdit.FComboBox := Self;
       StandardEdit.OnChange := EvEditChanged;
       StandardEdit.BorderStyle:= BorderStyle;
       FEdit := StandardEdit;
     end
     else
     begin
       OwnerDrawEdit := TOwnerDrawComboEdit.Create(Self);
       OwnerDrawEdit.FComboBox := Self;
       OwnerDrawEdit.BorderStyle:= BorderStyle;
       FEdit := OwnerDrawEdit;
     end;

     FEdit.Text := Text;
     FEdit.TabStop := True; // yes, this is tabbable!
     FEdit.ParentPenColor := True;
     FEdit.ParentColor := True;
     FEdit.Align := alTop;
     FEdit.OnEnter := EvEditEnter;
     FEdit.OnExit := EvEditExit;
     Include(FEdit.ComponentState, csDetail);

     InsertControl(FEdit);
end;

Function TComboBox.GetListItemIndexAtCursor: longint;
var
     P:TPoint;
Begin
     P := FListBox.ScreenToClient(Screen.MousePos);
     Result := FListBox.ItemAtPos(P,true);
End;

Procedure TComboBox.SetOwnerDraw(NewValue:boolean);
begin
  if FOwnerDraw = NewValue then
    exit;

  FOwnerDraw := NewValue;

  // set listbox style to match
  if NewValue then
    FListBox.Style := lbOwnerDrawFixed
  else
    FListBox.Style := lbStandard;

  SetStyle( FStyle );
end;

Procedure TComboBox.DrawListBoxItem( Sender:TObject;
                                     Index:LongInt;
                                     rec:TRect;
                                     State:TOwnerDrawState);
begin
  if FOnDrawItem <> nil then
  begin
    // correct slight problem from listbox rectangle
    inc( rec.Left );
    dec( rec.top );
    FOnDrawItem( FListBox.Canvas,
                 FListBox.Items[Index], // text
                 FListBox.Items.Objects[Index], // data
                 rec,
                 State )
  end
  else
    FListBox.DrawItem( Index, rec , State );
end;

Procedure TComboBox.SetBorderStyle(NewValue:TBorderStyle);
Begin
     If FBorderStyle <> NewValue Then
     Begin
          FBorderStyle:=NewValue;
          RecreateWnd;
     End;
End;


Procedure TComboBox.SetPopupMenu(NewMenu:TPopupMenu);
Begin
     If NewMenu=FPopupMenu Then Exit;

     If FEdit<>Nil Then FEdit.PopupMenu:=NewMenu;
     If FListBox<>Nil Then FListBox.PopupMenu:=NewMenu;
End;


Procedure TComboBox.SetStyle(NewStyle:TComboBoxStyle);
Var  ComboHeight:LongInt;
     AParent:TControl;
Begin
     FStyle := NewStyle;
     CreateEdit;

     If FStyle = csSimple Then
     Begin
          FListBox.parent := Nil;

          ComboHeight := FEdit.Height + GetListBoxHeight;
          SetBounds(Left,Top,Width,ComboHeight);
          FListBox.SetWindowPos(0,0,Width,GetListBoxHeight);

          FListBox.SetDesigning(True); //Error At CheckMenuPopup
          FListBox.Visible := True;
          FListBox.SetDesigning(Designed);
          FListBox.Hint := Hint;
          FEdit.Hint := Hint;

          FListBox.parent := Self;
          FDropped := True;
     End
     Else
     Begin
          SetupShowButton;

          FListBox.SetDesigning(False); //Error At CheckMenuPopup
          FListBox.Visible := False;
          FListBox.SetDesigning(Designed);
          FListBox.Hint := Hint;
          FEdit.Hint := Hint;
          ComboHeight := FEdit.Height;
          SetBounds(Left,Top,Width,ComboHeight);

          if csDesigning in ComponentState then
          begin
            FListBox.parent := nil;
          end
          else
          begin
            AParent := parent;
            If Form <> Nil Then
              If Form.Frame <> Nil Then AParent := Form.Frame; {!}
            FListBox.parent := AParent;
          end;
          FDropped := False;
     End;

     if UsesStandardEdit then
          StandardEdit.ReadOnly := FStyle = csDropDownList;
      // else - ownerdraw edit is always readonly

End;


Function TComboBox.GetListBoxHeight:LongInt;
Var  ItemCount:LongInt;
Begin
     If FStyle <> csSimple Then
     Begin
          ItemCount := Items.Count;
          If ItemCount > FDropDownCount Then ItemCount := FDropDownCount;
          If ItemCount < 1 Then ItemCount := 1;
          Result := ItemCount * FListBox.ItemHeight + 6;
     End
     Else Result := FListBoxHeight;
End;


Procedure TComboBox.SetupShowButton;
Var  T,fw:LongInt;
     ComboButton:TComboListShowButton;
     X,Y,W,H:LongInt;
Begin
     If FShowButton = Nil Then
     Begin
          ComboButton.Create(self);
          ComboButton.TabStop := False;
          ComboButton.FCombo := Self;
          ComboButton.SetDesigning(Designed);
          ComboButton.Hint := Hint;
          Include(ComboButton.ComponentState, csDetail);
          FShowButton := ComboButton;
          FEdit.InsertControl(FShowButton);
     End;
     T := Screen.SystemMetrics(smCxVScroll);
     If BorderStyle = bsNone Then fw := 0
     Else fw := 2;
     X:=FEdit.Width-T-fw;
     Y:=fw;
     W:=T;
     H:=FEdit.Height-2*fw;
     If ((FShowButton.Left<>X)Or(FShowButton.Bottom<>Y)Or(FShowButton.Width<>W)Or
         (FShowButton.Height<>H)) Then FShowButton.SetWindowPos(X,Y,W,H);
End;


Procedure TComboBox.DestroyShowButton;
Begin
     If FShowButton <> Nil Then
     Begin
          FShowButton.Destroy;
          FShowButton := Nil;
          If FEdit <> Nil Then FEdit.Resize; {call Arrange}
     End;
End;


Procedure TComboBox.CreateWnd;
Begin
     Inherited CreateWnd;

     SetStyle(FStyle); {Set it again, To determine the Right Listbox parent}
End;


Procedure TComboBox.DestroyWnd;
Begin
     Inherited DestroyWnd;

     If FStyle <> csSimple Then
       If FListBox <> Nil Then
       Begin
            If DroppedDown Then DroppedDown := False;
            FListBox.DestroyWnd;
       End;
End;


Procedure TComboBox.Move;
Begin
     Inherited Move;

     If FStyle <> csSimple Then
       If DroppedDown Then DroppedDown := False;
End;


Procedure TComboBox.Resize;
Begin
     Inherited Resize;

     If FStyle = csSimple Then
     Begin
          FListBoxHeight := Height - FEdit.Height;
          If FListBox <> Nil
          Then FListBox.SetWindowPos(0,0,Width,FListBoxHeight);
     End
     Else
     Begin
          If Height<>FEdit.Height Then
            SetBounds(Left,Top,Width,FEdit.Height);
          SetupShowButton; {Realign}
          If DroppedDown Then DroppedDown := False;
     End;
End;


Procedure TComboBox.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Begin
     Inherited SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);

     If FStyle = csSimple Then FListBoxHeight := Height - FEdit.Height;
End;


Destructor TComboBox.Destroy;
Begin
     If FStyle <> csSimple Then
       If FListBox <> Nil Then
       Begin
            FListBox.Destroy;
            FListBox := Nil;
       End;

     Inherited Destroy;
End;


Procedure TComboBox.SetFocus;
Var  OldEvent:TNotifyEvent;
Begin
     OldEvent := OnEnter;
     OnEnter := Nil;

     Inherited SetFocus;

     OnEnter := OldEvent;

     If Not Designed Then
       If FEdit <> Nil Then FEdit.CaptureFocus;
End;


Procedure TComboBox.KillFocus;
Var  OldEvent:TNotifyEvent;
Begin
     OldEvent := OnExit;
     OnExit := Nil;

     Inherited KillFocus;

     OnExit := OldEvent;
End;


{$HINTS OFF}
Procedure TComboBox.EvKillFocus(Sender:TObject); //ListBox
Begin
     If FStyle <> csSimple Then
       If DroppedDown Then DroppedDown := False;
End;
{$HINTS ON}


Procedure TComboBox.SetDroppedDown(Value:Boolean);
Begin
     If Handle = 0 Then Exit;
     If FStyle = csSimple Then Exit;

     If FDropped <> Value Then
     Begin
          FDropped := Value;
          TComboListShowButton(FShowButton).Down := FDropped;

          If FDropped Then
          Begin
               {Update Colors manually, because lb Is Not In the Comp List}
               FListBox.PenColor := PenColor;
               FListBox.color := color;
               FListBox.Font := Font;

               If FOnDropDown <> Nil Then FOnDropDown(Self);
               If Not FDropped Then Exit;  {DropDown already Handled}

               AdjustDropDown;
          End
          Else
          Begin
               FListBox.Hide;
               If Not Designed Then
               Begin
                    FEdit.CaptureFocus; {!}
                    if UsesStandardEdit then
                         StandardEdit.SelectAll;
                    // else - owner draw edit is always all selected
               End;
          End;
     End;
End;


{$HINTS OFF}
{Koordinaten sind relativ zum parent der ComboBox anzugeben;
 phys. parent der Listbox ist TFrameControl}
Procedure TComboBox.UpdateListBoxPos(Var aLeft,aBottom,aWidth,aHeight:LongInt);
Var  ListOrigin:TPoint;
     ListParentOrigin:TPoint;
     ListOffsetY:LongInt;
     FormHeight:LongInt;
     AForm:TForm;
Begin
     If Handle = 0 Then Exit;
     If parent = Nil Then Exit;
     If FListBox.parent = Nil Then Exit;

     {Rechnen mit Screen Koordinaten}
     ListOrigin := parent.ClientToScreen(Point(aLeft,aBottom));
     ListParentOrigin := FListBox.parent.ClientToScreen(Point(0,0)); {Frame}
     ListOffsetY := ListOrigin.Y - ListParentOrigin.Y;

     If ListOffsetY < 0 Then {unterhalb der Form}
     Begin
          If Form Is TForm Then
          Begin
               FormHeight := Form.ClientHeight;
               AForm:=TForm(Form);
               Asm
                  PUSH DWord Ptr AForm
                  CALLN32 Forms.GetTopBottomHeight
                  MOV EBX,FormHeight
                  ADD EBX,EAX
                  MOV FormHeight,EBX
               End;
          End
          Else FormHeight := 0; {?}

          If ListOffsetY + aHeight + Height + aHeight < FormHeight
          Then aBottom := Bottom + Height;           {nach oben aufklappen}
     End;
End;
{$HINTS ON}


Procedure TComboBox.AdjustDropDown;
Var  X,Y,W,H,I:LongInt;
     ListOrigin:TPoint;
     ListParentOrigin:TPoint;
Begin
     W := Width;
     H := GetListBoxHeight;
     X := Left;
     Y := Bottom - H;
     {Koordinaten wie Die Combo}
     UpdateListBoxPos(X,Y,W,H);

     {umrechnen auf FormFrame Koordinaten}
     If parent Is TControl
       Then ListOrigin := parent.ClientToScreen(Point(X,Y))
       Else ListOrigin := Point(X,Y);
     If FListBox.parent Is TControl
       Then ListParentOrigin := FListBox.parent.ClientToScreen(Point(0,0)) {Frame}
       Else ListParentOrigin := Point(0,0);
     {Offset zum parent der Listbox}
     X := ListOrigin.X - ListParentOrigin.X;
     Y := ListOrigin.Y - ListParentOrigin.Y;

     {Select the Item called like Text}
     I := FListBox.Items.IndexOf(Text);
     If I >= 0 Then
     Begin
          FListBox.FInitItemIndex := I;
          FListBox.FInitTopIndex := I;
     End;

     FListBox.SetWindowPos(X,Y,W,H);
     FListBox.Show;
     If Not Designed Then FListBox.CaptureFocus; {!}
End;


Procedure TComboBox.FontChange;
Begin
     Inherited FontChange;

     If FEdit <> Nil Then FEdit.Font := Font;        {auto Size}
     If FListBox <> Nil Then FListBox.Font := Font;
End;


{$HINTS OFF}
Procedure TComboBox.CMTextChanged(Var Msg:TMessage);
Begin
     If FEdit <> Nil Then FEdit.Text := Text;
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TComboBox.EvEditEnter(Sender:TObject);
Begin
     If OnEnter <> Nil Then OnEnter(Self);
End;


Procedure TComboBox.EvEditExit(Sender:TObject);
Begin
     If OnExit <> Nil Then OnExit(Self);
End;


Procedure TComboBox.EvEditChanged(Sender:TObject);
Var  OldEdit:TControl;
Begin
     OldEdit := FEdit;
     FEdit := Nil; {prevent recursion}
     Text := OldEdit.Text;
     if Style in [ csSimple, csDropDown ] then
          // select the matching item in the list, if any.
          FListBox.ItemIndex := FListBox.Items.IndexOf( Text );
     FEdit := OldEdit;
     EditChange;
End;
{$HINTS ON}


Procedure TComboBox.EditChange;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;


Function TComboBox.GetItems:TStrings;
Begin
     If FListBox <> Nil Then Result := FListBox.Items
     Else Result := Nil;
End;


Procedure TComboBox.SetItems(AStrings:TStrings);
Begin
     If FListBox <> Nil Then FListBox.Items := AStrings;
End;


Function TComboBox.GetItemIndex:LongInt;
Begin
     If FListBox <> Nil Then Result := FListBox.ItemIndex
     Else Result := -1;
End;


Procedure TComboBox.SetItemIndex(Value:LongInt);
Begin
     If FListBox <> Nil Then
     Begin
          FListBox.ItemIndex := Value;
          ItemSelect(Value);
     End;
End;


Function TComboBox.GetSorted:Boolean;
Begin
     If FListBox <> Nil Then Result := FListBox.sorted
     Else Result := False;
End;


Procedure TComboBox.SetSorted(Value:Boolean);
Begin
     If FListBox <> Nil Then FListBox.sorted := Value;
End;


Function TComboBox.GetDuplicates:Boolean;
Begin
     If FListBox <> Nil Then Result := FListBox.Duplicates
     Else Result := False;
End;


Procedure TComboBox.SetDuplicates(Value:Boolean);
Begin
     If FListBox <> Nil Then FListBox.Duplicates := Value;
End;


Procedure TComboBox.SetExtension(Const Value:String);
Begin
End;


Function TComboBox.GetExtension:String;
Begin
     Result := ''; // no longer supported
End;


Function TComboBox.GetMaxLength:Integer;
Begin
     if not UsesStandardEdit then
     begin
          Result := 255;
          exit;
     end;

     If FEdit <> Nil Then Result := StandardEdit.MaxLength
     Else Result := 0;
End;


Procedure TComboBox.SetMaxLength(tl:Integer);
Begin
     if not UsesStandardEdit then
          exit;
     If FEdit <> Nil Then StandardEdit.MaxLength := tl;
End;


Function TComboBox.GetSelStart:Integer;
Begin
     if not UsesStandardEdit then
     begin
          Result := 0;
          exit;
     end;
     If FEdit <> Nil Then Result := StandardEdit.SelStart
     Else Result := 0;
End;


Procedure TComboBox.SetSelStart(X:Integer);
Begin
     if not UsesStandardEdit then
          exit;
     If FEdit <> Nil Then StandardEdit.SelStart := X;
End;


Function TComboBox.GetSelLength:Integer;
Begin
     if not UsesStandardEdit then
     begin
          Result := Length( FEdit.Text );
          exit;
     end;
     If FEdit <> Nil Then Result := StandardEdit.SelLength
     Else Result := 0;
End;


Procedure TComboBox.SetSelLength(X:Integer);
Begin
     if not UsesStandardEdit then
          exit;
     If FEdit <> Nil Then StandardEdit.SelLength := X;
End;


Function TComboBox.GetSelText:String;
Begin
     if not UsesStandardEdit then
     begin
          Result := FEdit.Text;
          exit;
     end;

     If FEdit <> Nil Then Result := StandardEdit.SelText
     Else Result := ''
End;


Procedure TComboBox.SetSelText(Const Value:String);
Begin
     if not UsesStandardEdit then
          exit;
     If FEdit <> Nil Then StandardEdit.SelText := Value;
End;


Procedure TComboBox.SetAlternate(Value:Boolean);
Begin
     FAlternate := Value;
     If FShowButton <> Nil Then FShowButton.Invalidate;
End;


{$HINTS OFF}
Procedure TComboBox.ItemFocus(Index:LongInt);
Begin
     If FOnItemFocus <> Nil Then FOnItemFocus(Self,Index);
End;


Procedure TComboBox.ItemSelect(Index:LongInt);
begin
     if Index = -1 then
          exit;

     // Item selected from listbox, copy the item
     // to the edit and store the selected object
     FEdit.Text := Items.Strings[Index];

     if UsesStandardEdit then
     begin
          StandardEdit.SelectAll;
     end;
     FSelectedObject := Items.Objects[Index];

     If FOnItemSelect <> Nil Then FOnItemSelect(Self,Index);
End;
{$HINTS ON}

Procedure TComboBox.ListBoxMouseUp;
var
     idx: longint;
begin
     If FStyle <> csSimple Then
     Begin
          // select the item under the cursor when button released
          idx := FListBox.ItemIndex;
          If (idx < 0) Or (idx >= Items.Count) Then Exit;
          DroppedDown := false;
          ItemSelect(idx);
     End;
end;

Procedure TComboBox.Invalidate;
Begin
     If FEdit <> Nil Then FEdit.Invalidate;
     If FShowButton <> Nil Then FShowButton.Invalidate;
     If FListBox <> Nil Then FListBox.Invalidate;
End;


Procedure TComboBox.Update;
Begin
     If FEdit <> Nil Then FEdit.Update;
     If FShowButton <> Nil Then FShowButton.Update;
     If FListBox <> Nil Then FListBox.Update;
End;


Procedure TComboBox.Hide;
Begin
     Inherited Hide;
     If FStyle <> csSimple Then
       If DroppedDown Then DroppedDown := False;
End;


Procedure TComboBox.SelectAll;
Begin
     if not UsesStandardEdit then
          exit;
     If FEdit <> Nil Then StandardEdit.SelectAll;
End;


Procedure TComboBox.Clear;
Begin
     if not UsesStandardEdit then
          If FEdit <> Nil Then StandardEdit.Clear;
     If FListBox <> Nil Then FListBox.Clear;
End;


Procedure TComboBox.BeginUpdate;
Begin
     If FListBox <> Nil Then FListBox.BeginUpdate;
End;


Procedure TComboBox.EndUpdate;
Begin
     If FListBox <> Nil Then FListBox.EndUpdate;
End;


Function TComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
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


Procedure TComboBox.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
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
บ This section: TEdit Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TEdit.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'Edit';
     Caption := '';
     Width := 100;
     Height := 20;
     color := clEntryField;
     ParentPenColor := False;
     ParentColor := False;
     Ownerdraw := False;

     FUnreadable := False;
     FModified := False;
     FInsertMode := True;
     FReadOnly := False;
     FMaxLength := 0;
     FAutoSize := True;
     FAutoScroll := True;
     FAutoSelect := True;
     FCharCase := ecNormal;
     FBorderStyle := bsSingle;
     FAlignment := taLeftJustify;
     FExtension := Nil;
     FSelStart := 0;
     FSelLen := 0;
End;


Procedure TEdit.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF OS2}
     ClassData.ClassULong := WC_ENTRYFIELD;
     {$ENDIF}
     {$IFDEF Win95}
     CreateSubClass(ClassData,'EDIT');
     {$ENDIF}
End;


Procedure TEdit.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Case FAlignment Of
       taLeftJustify:  Params.Style := Params.Style Or ES_LEFT;
       taRightJustify: Params.Style := Params.Style Or ES_RIGHT;
       taCenter:       Params.Style := Params.Style Or ES_CENTER;
     End;
     If FAutoScroll Then Params.Style := Params.Style Or ES_AUTOSCROLL;
     If FUnreadable Then Params.Style := Params.Style Or ES_UNREADABLE;
     If FReadOnly Then Params.Style := Params.Style Or ES_READONLY;
     If FBorderStyle = bsSingle Then Params.Style := Params.Style Or ES_MARGIN;
     {$ENDIF}
     {$IFDEF Win95}
     {Case FAlignment Of
       taLeftJustify:  Params.Style := Params.Style Or ES_LEFT;
       taRightJustify: Params.Style := Params.Style Or ES_RIGHT;
       taCenter:       Params.Style := Params.Style Or ES_CENTER;
     End;}
     If FAutoScroll Then Params.Style := Params.Style Or ES_AUTOHSCROLL;
     If FUnreadable Then Params.Style := Params.Style Or ES_PASSWORD;
     If FReadOnly Then Params.Style := Params.Style Or ES_READONLY;
     If FBorderStyle = bsSingle Then
     Begin
          Params.Style := Params.Style Or WS_BORDER;
          Params.ExStyle := Params.ExStyle Or WS_EX_CLIENTEDGE;  {Double}
     End;
     {$ENDIF}
End;


Procedure TEdit.CreateWnd;
Begin
     FTempCaption := NewStr(Caption);

     Inherited CreateWnd;
End;


Procedure TEdit.SetupShow;
{$IFDEF OS2}
Var  Value:LongInt;
{$ENDIF}
Begin
     Inherited SetupShow;

     {$IFDEF OS2}
     If FMaxLength <= 0 Then Value := 255
     Else Value := FMaxLength;
     WinSendMsg(Handle,EM_SETTEXTLIMIT,Value,0);
     WinSendMsg(Handle,EM_SETINSERTMODE,LongWord(FInsertMode),0);
     {$ENDIF}
     If FTempCaption<>Nil Then Caption := FTempCaption^
     Else Caption:='';
     DisposeStr(FTempCaption);
     FTempCaption := Nil;
     SetSelection(FSelStart,FSelLen);
     If FAutoSize Then AdjustHeight;
End;


Procedure TEdit.UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Begin
     {$IFDEF OS2}
     If FBorderStyle = bsSingle Then
     Begin
          Inc(NewLeft,3);
          Inc(NewBottom,3);
          Dec(NewWidth,6);
          Dec(NewHeight,6);
     End;
     {$ENDIF}
     Inherited UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
End;


{$HINTS OFF}
Procedure TEdit.CharEvent(Var key:Char;RepeatCount:Byte);
Var  S:String;
Begin
     If NumbersOnly Then
     Begin
          If Not (key In ['0'..'9','.','+','-']) Then
          Begin
               key := #0;
               Exit;
          End;
     End;

     Case FCharCase Of
       ecNormal: ;
       ecUpperCase:
         Begin
              S := AnsiUpperCase(key);
              key := S[1];
         End;
       ecLowerCase:
         Begin
              S := lowercase(key);
              key := S[1];
         End;
     End;
End;
{$HINTS ON}


Procedure TEdit.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
{$IFDEF OS2}
Var  FCursor:LongInt;
     ext:String;
{$ENDIF}
Begin
     Case KeyCode Of
       kbCLeft: ; {!}
       kbCRight: {extension}
       Begin
            If FReadOnly Then Exit;
            {$IFDEF OS2}
            FCursor := WinSendMsg(Handle,EM_QUERYSEL,0,0);
            FCursor := FCursor Shr 16;
            If (Length(TextExtension) > 0) And (FCursor = Length(Text)) Then
            Begin
                 ext := TextExtension;
                 Text := Text + ext[1];
                 Delete(ext,1,1);
                 TextExtension := ext;
            End;
            {$ENDIF}
       End;
       Else Inherited ScanEvent(KeyCode,RepeatCount);
     End;
End;

Procedure TEdit.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     SelectAll;
     inherited MouseDblClick(Button,ShiftState,X,Y);
     LastMsg.Handled := true; // don't want default handler.
End;

Procedure TEdit.ParentNotification(Var Msg:TMessage);
Begin
     {$IFDEF OS2}
     Case Msg.Msg Of
       WM_CONTROL:
       Begin
            Case Msg.Param1Hi Of
              EN_CHANGE:
                If FTempCaption = Nil Then {External Change}
                Begin
                     FModified := True;
                     Change;
                End;
              EN_SETFOCUS:
                If FAutoSelect Then SelectAll;
            End;
       End;
     End;
     {$ENDIF}
     {$IFDEF Win95}
     Case Msg.Msg Of
       WM_COMMAND:
       Begin
            Case Msg.Param1Hi Of
              EN_CHANGE:
              If FTempCaption = Nil Then
              Begin
                   FModified := True;
                   Change;
              End;
              EN_SETFOCUS:
              Begin
                   DefaultHandler(Msg);
                   If FAutoSelect Then SelectAll;
              End;
              Else DefaultHandler(Msg);
            End;
            Msg.Handled:=True; //!!!
       End;
     End;
     {$ENDIF}
End;


Procedure TEdit.Change;
Begin
     TextExtension := '';
     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TEdit.DestroyWnd;
Begin
     FSelStart := SelStart;
     FSelLen := SelLength;

     Inherited DestroyWnd;
End;


Destructor TEdit.Destroy;
Begin
     DisposeStr(FExtension);
     FExtension := Nil;

     Inherited Destroy;
End;


Procedure TEdit.SetBorderStyle(Value:TBorderStyle);
Begin
     If FBorderStyle <> Value Then
     Begin
          FBorderStyle := Value;
          If FAutoSize Then AdjustHeight;
          RecreateWnd;
     End;
End;


Procedure TEdit.SetAutoSize(Value:Boolean);
Begin
     If FAutoSize <> Value Then
     Begin
          FAutoSize := Value;
          If FAutoSize Then AdjustHeight;
     End;
End;


Procedure TEdit.AdjustHeight;
Var  NewHeight:LongInt;
Begin
     NewHeight := Font.Height + 2;
     If FBorderStyle = bsSingle Then Inc(NewHeight,4);
     Height := NewHeight;
End;


Procedure TEdit.FontChange;
Begin
     If FAutoSize Then AdjustHeight;

     Inherited FontChange;
End;


Procedure TEdit.SetAlignment(Value:TAlignment);
Begin
     If FAlignment <> Value Then
     Begin
          FAlignment := Value;
          RecreateWnd;
     End;
End;


Procedure TEdit.SetMaxLength(Value:LongInt);
Begin
     If Value > 255 Then Value := 255;
     If FMaxLength <> Value Then
     Begin
          FMaxLength := Value;
          {$IFDEF OS2}
          If Handle <> 0 Then
          Begin
               If Value <= 0 Then Value := 255;
               WinSendMsg(Handle,EM_SETTEXTLIMIT,Value,0);
          End;
          {$ENDIF}
          {$IFDEF WIN32}
          If Handle <> 0 Then
          Begin
               If Value <= 0 Then Value := 255;
               WinUser.SendMessage(Handle,EM_LIMITTEXT,Value,0);
          End;
          {$ENDIF}
          RecreateWnd; {Reset the original string!}
     End;
End;


Procedure TEdit.SetAutoScroll(Value:Boolean);
Begin
     If FAutoScroll <> Value Then
     Begin
          FAutoScroll := Value;
          RecreateWnd;
     End;
End;


Procedure TEdit.SetUnreadable(Value:Boolean);
Begin
     If FUnreadable <> Value Then
     Begin
          FUnreadable := Value;
          RecreateWnd;
     End;
End;


Procedure TEdit.SetReadOnly(Value:Boolean);
Var ro:LongBool;
Begin
     If FReadOnly <> Value Then
     Begin
          FReadOnly := Value;
          {$IFDEF OS2}
          ro:=FReadOnly;
          If Handle <> 0 Then WinSendMsg(Handle,EM_SETREADONLY,LongWord(ro),0);
          {$ENDIF}
          {$IFDEF WIN32}
          ro:=FReadOnly;
          If Handle <> 0 Then WinUser.SendMessage(Handle,EM_SETREADONLY,LongWord(ro),0);
          {$ENDIF}
     End;
End;


Procedure TEdit.SetInsertMode(Value:Boolean);
Begin
     If FInsertMode <> Value Then
     Begin
          FInsertMode := Value;
          {$IFDEF OS2}
          If Handle <> 0 Then WinSendMsg(Handle,EM_SETINSERTMODE,
                                         LongWord(FInsertMode),0);
          {$ENDIF}
     End;
End;


Procedure TEdit.SetCharCase(Value:TEditCharCase);
Begin
     If FCharCase <> Value Then
     Begin
          FCharCase := Value;
          Case FCharCase Of
            ecNormal: ;
            ecUpperCase: Text := AnsiUpperCase(Text);
            ecLowerCase: Text := lowercase(Text);
          End;
     End;
End;


Procedure TEdit.SetExtension(Const Value:String);
Begin
     AssignStr(FExtension,Value);
End;


Function TEdit.GetExtension:String;
Begin
     If FExtension <> Nil Then Result := FExtension^
     Else Result := '';
End;


Procedure TEdit.SetSelection(Start,len:LongInt);
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(Handle,EM_SETSEL,Start+((Start+len) Shl 16),0);
          {$ENDIF}
          {$IFDEF WIN32}
          If ((Start=0)And(len=255)) Then //Select all
            WinUser.SendMessage(Handle,EM_SETSEL,0,-1)
          Else
            WinUser.SendMessage(Handle,EM_SETSEL,Start,Start+len);
          {$ENDIF}
     End;
     FSelStart := Start;
     FSelLen := len;
End;


Procedure TEdit.SetSelStart(X:LongInt);
Begin
     SetSelection(X,SelLength);
End;


Function TEdit.GetSelStart:LongInt;
Var  Sel:LongInt;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          Sel := WinSendMsg(Handle,EM_QUERYSEL, 0, 0);
          {$ENDIF}
          {$IFDEF WIN32}
          Sel := WinUser.SendMessage(Handle,EM_GETSEL,0,0);
          {$ENDIF}
          Result := Sel And $FFFF;
     End
     Else Result := FSelStart;
End;


Procedure TEdit.SetSelLength(X:LongInt);
Begin
     SetSelection(SelStart,X);
End;

Function TEdit.GetSelLength:LongInt;
Var  Sel:LongInt;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          Sel := WinSendMsg(Handle,EM_QUERYSEL, 0, 0);
          {$ENDIF}
          {$IFDEF WIN32}
          Sel := WinUser.SendMessage(Handle,EM_GETSEL,0,0);
          {$ENDIF}
          Result := (Sel Shr 16) - (Sel And $FFFF);
     End
     Else Result := FSelStart;
End;


Procedure TEdit.SetSelText(Const Value:String);
Var  S:String;
     X,CX:LongInt;
Begin
     S := Text;
     X := SelStart;
     CX := SelLength;
     Delete(S,X+1,CX);
     Insert(Value,S,X+1);
     Text := S;
     SelStart := X;
     SelLength := Length(Value);
End;


Function TEdit.GetSelText:String;
Begin
     Result := Copy(Text,SelStart+1,SelLength);
End;


Procedure TEdit.SelectAll;
Begin
     SetSelection(0,255);
End;


Procedure TEdit.Clear;
Begin
     Text := '';
End;


Procedure TEdit.ClearSelection;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,EM_CLEAR,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_CLEAR,0,0);
     {$ENDIF}
End;


Procedure TEdit.CutToClipBoard;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,EM_CUT,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_CUT,0,0);
     {$ENDIF}
End;


Procedure TEdit.CopyToClipboard;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,EM_COPY,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_COPY,0,0);
     {$ENDIF}
End;


Procedure TEdit.PasteFromClipBoard;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,EM_PASTE,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_PASTE,0,0);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TListBox Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TListBoxStrings=Class(TStrings)
      Private
         Listbox:TListBox;
      Protected
         Function GetCount:LongInt; Override;
         Function Get(Index:LongInt):String; Override;
         Function GetObject(Index:LongInt):TObject; Override;
         Procedure Put(Index:LongInt;Const S:String); Override;
         Procedure PutObject(Index:LongInt;AObject:TObject); Override;
         Procedure indexerror;
         {$IFDEF OS2}
         Procedure LoadStrings( Strings: TStrings ); // quick load to displayed list
         {$ENDIF}
      Public
         Procedure Assign(AStrings:TStrings); Override;
         Procedure AddStrings(AStrings: TStrings); Override;
         Function Add(Const S:String):LongInt; Override;
         Procedure Insert(Index:LongInt;Const S:String); Override;
         Procedure Delete(Index:LongInt); Override;
         Procedure Clear; Override;
         {$IFDEF OS2}
         Function IndexOf(Const S:String):LongInt; Override;
         {$ENDIF}
    End;


{$M+}


Function TListBoxStrings.GetCount:LongInt;
Begin
     {$IFDEF OS2}
     Result := WinSendMsg(Listbox.Handle,LM_QUERYITEMCOUNT,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     Result := SendMessage(Listbox.Handle,LB_GETCOUNT,0,0);
     {$ENDIF}
End;


Function TListBoxStrings.Get(Index:LongInt):String;
Var  len:LongInt;
     {$IFDEF WIN32}
     c:CString;
     {$ENDIF}
Begin
     Result := '';
     If (Index < 0) Or (Index >= Count) Then indexerror;

     {$IFDEF OS2}
     len := WinSendMsg(Listbox.Handle,LM_QUERYITEMTEXT,
                       MPFROM2SHORT(Index,SizeOf(Result)),LongWord(@Result[1]));
     SetLength(Result,len);
     {$ENDIF}
     {$IFDEF Win95}
     len := SendMessage(Listbox.Handle,LB_GETTEXT,Index,LongWord(@Result[1]));
     SetLength(Result,len);
     c:=Result;
     AnsiToOem(c,c);
     Result:=c;
     {$ENDIF}
End;


Function TListBoxStrings.GetObject(Index:LongInt):TObject;
Begin
     Result := Nil;
     If (Index < 0) Or (Index >= Count) Then indexerror;

     {$IFDEF OS2}
     Result := TObject(WinSendMsg(Listbox.Handle,LM_QUERYITEMHANDLE,Index,0));
     {$ENDIF}
     {$IFDEF Win95}
     Result := TObject(SendMessage(Listbox.Handle,LB_GETITEMDATA,Index,0));
     {$ENDIF}
End;


Procedure TListBoxStrings.Put(Index:LongInt;Const S:String);
Var  CS:cstring;
     {$IFDEF WIN32}
     s1:String;
     {$ENDIF}
Begin
     If (Index < 0) Or (Index >= Count) Then indexerror;

     {$IFDEF OS2}
     CS := S;
     WinSendMsg(Listbox.Handle,LM_SETITEMTEXT,Index,LongWord(@CS));
     {$ENDIF}
     {$IFDEF Win95}
     BeginUpdate;
     SendMessage(Listbox.Handle,LB_DELETESTRING,Index,0);
     s1:=s;
     StrOemToAnsi(s1);
     cs:=s1;
     SendMessage(Listbox.Handle,LB_INSERTSTRING,Index,LongWord(@CS));
     EndUpdate;
     {$ENDIF}
End;


Procedure TListBoxStrings.PutObject(Index:LongInt;AObject:TObject);
Begin
     If (Index < 0) Or (Index >= Count) Then indexerror;

     {$IFDEF OS2}
     WinSendMsg(Listbox.Handle,LM_SETITEMHANDLE,Index,LongWord(AObject));
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Listbox.Handle,LB_SETITEMDATA,Index,LongWord(AObject));
     {$ENDIF}
End;


Procedure TListBoxStrings.Assign(AStrings:TStrings);
Begin
     Listbox.BeginUpdate;
     Inherited Assign(AStrings);
     Listbox.EndUpdate;
End;

{$ifdef os2}
// Loads a stringlist into the displayed PM list,
// quickly. This is done by copying into an array
// as zero-terminated cstrings, then using PM's multi-item
// load message
const
  BufferArraySize = 100; // how many strings will be loaded at once

Procedure TListBoxStrings.LoadStrings( Strings: TStrings );
var
  ArrayOfPChar: array[ 0..BufferArraySize-1 ] of pchar;
  ArrayOfCString: array[ 0..BufferArraySize-1 ] of cstring;
  StringIndex: longint;
  BufferIndex: longint;
  InitialCount: longint;

  // This procedure sends the contents of the buffer
  // to PM (and instructs PM to sort the listbox, if specified)
  Procedure SendBuffer( Count: longint;
                        Sort: Boolean );
  var
    ListBoxInfo: LBOXINFO;
  Begin
    if Sort then
      ListBoxInfo.lItemIndex:= LIT_SORTASCENDING
    else
      ListBoxInfo.lItemIndex:= LIT_END;
    ListBoxInfo.ulItemCount := Count;
    WinSendMsg( ListBox.Handle,
                LM_INSERTMULTITEMS,
                Mparam( Addr( ListBoxInfo ) ),
                Mparam( Addr( ArrayOfPChar ) ) );
  End;

begin
  InitialCount := ListBox.Items.Count;

  BufferIndex := 0;

  // Insert all strings
  for StringIndex := 0 to Strings.Count - 1 do
  begin
    // Copy string to buffer array
    ArrayOfCstring[ BufferIndex ] := Strings[ StringIndex ];
    // store pointer to the cstring
    ArrayOfPChar[ BufferIndex ]:= Addr( ArrayOfCstring[ BufferIndex ] );
    inc( BufferIndex );

    if BufferIndex > BufferArraySize - 1 then
    begin
      // Buffer is full, send it, *without* sorting
      // so that we know the order of the added items
      SendBuffer( BufferArraySize, false );
      BufferIndex := 0;
    end;
  end;

  if BufferIndex > 0 then
    // send remainder of strings
    SendBuffer( BufferIndex, false );

  // Set associated objects. Unfortunately can't do this
  // in the LM_INSERTMULTITEMS message. However since we
  // have not sorted yet, we know the items have been inserted
  // in the same order we sent them
  for StringIndex := 0 to Strings.Count - 1 do
  begin
    WinSendMsg( ListBox.Handle,
                LM_SETITEMHANDLE,
                Mparam( InitialCount + StringIndex ),
                Mparam( Strings.Objects[ StringIndex ] ) );
  end;

  // Finally sort the listbox, if needed
  If ListBox.FSorted then
    SendBuffer( 0, true );

End;
{$endif}

Procedure TListBoxStrings.AddStrings( AStrings: TStrings );
Begin
{$ifdef os2}
     LoadStrings( AStrings ); // faster!
{$else}
     Inherited AddStrings( AStrings );
{$endif}
End;

Function TListBoxStrings.Add(Const S:String):LongInt;
Var  CS:cstring;
     {$IFDEF OS2}
     Sort:LONG;
     {$ENDIF}
     {$IFDEF WIN32}
     s1:String;
     {$ENDIF}
Begin
     If Not Listbox.Duplicates Then
     Begin
          Result := IndexOf(S);
          If Result >= 0 Then Exit;
     End;

     {$IFDEF OS2}
     CS := S;
     If Listbox.FSorted Then Sort := LIT_SORTASCENDING
     Else Sort := LIT_END;
     Result := WinSendMsg(Listbox.Handle,LM_INSERTITEM,Sort,LongWord(@CS));
     {$ENDIF}
     {$IFDEF Win95}
     s1:=s;
     StrOemToAnsi(s1);
     cs:=s1;
     Result := SendMessage(Listbox.Handle,LB_ADDSTRING,0,LongWord(@CS));
     {$ENDIF}
End;


Procedure TListBoxStrings.Insert(Index:LongInt;Const S:String);
Var  CS:cstring;
     {$IFDEF WIN32}
     s1:String;
     {$ENDIF}
Begin
     If (Index < 0) Or (Index > Count) Then indexerror;

     {$IFDEF OS2}
     CS := S;
     WinSendMsg(Listbox.Handle,LM_INSERTITEM,Index,LongWord(@CS));
     {$ENDIF}
     {$IFDEF Win95}
     s1:=s;
     StrOemToAnsi(s1);
     cs:=s1;
     SendMessage(Listbox.Handle,LB_INSERTSTRING,0,LongWord(@CS));
     {$ENDIF}
End;


Procedure TListBoxStrings.Delete(Index:LongInt);
Begin
     If (Index < 0) Or (Index >= Count) Then indexerror;

     {$IFDEF OS2}
     WinSendMsg(Listbox.Handle,LM_DELETEITEM,Index,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Listbox.Handle,LB_DELETESTRING,Index,0);
     {$ENDIF}
End;


Procedure TListBoxStrings.Clear;
Begin
     {$IFDEF OS2}
     WinSendMsg(Listbox.Handle,LM_DELETEALL,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Listbox.Handle,LB_RESETCONTENT,0,0);
     {$ENDIF}
End;


{$IFDEF OS2}
Function TListBoxStrings.IndexOf(Const S:String):LongInt;
Var  CS:cstring;
Begin
     CS := S;
     Result := WinSendMsg(Listbox.Handle,LM_SEARCHSTRING,
                         MPFROM2SHORT(LSS_CASESENSITIVE,LIT_FIRST),
                         LongWord(@CS));
     If Result In [LIT_ERROR,LIT_NONE] Then Result := -1;
End;
{$ENDIF}


Procedure TListBoxStrings.indexerror;
Begin
     Raise EListBoxIndexError.Create(LoadNLSStr(SInvalidListBoxItemIndex));
End;

////////////////////////////////////////////////////////////////////////////

Procedure TListBox.KillFocus;
Begin
     if FComboBox <> nil then
          if FComboBox.DroppedDown then
               FComboBox.DroppedDown := false;
End;

Function TListBox.GetItemHeight:LongInt;
Begin
     If FStyle = lbOwnerdrawFixed Then Result := FItemHeight
     Else Result := Font.Height;
End;

Procedure TListBox.SetItemHeight(Value:LongInt);
Begin
     If FItemHeight <> Value Then
     Begin
          FItemHeight := Value;
          If FStyle = lbOwnerdrawFixed Then RecreateWnd;
     End;
End;


Procedure TListBox.DrawDragRect;
Begin
     If Canvas = Nil Then Exit;
     Canvas.Pen.Mode:=pmNot;
     Canvas.Pen.color:=clBlack;
     Canvas.Pen.Style:=psDot;
     Canvas.Rectangle(FDragRect);
     Canvas.Pen.Mode:=pmCopy;
End;


Procedure TListBox.DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);
Var Index:LongInt;
Label invalid;
Begin
     Index:=-1;
     Inherited DragOver(Source,X,Y,State,Accept);
     If FShowDragRects Then
     Begin
          If Accept Then
          Begin
               Index:=ItemAtPos(Point(X,Y),True);
               If Index<>-1 Then
               Begin
                    Case State Of
                       dsDragEnter:
                       Begin
                            CreateDragCanvas;
                            If FDragRectValid Then DrawDragRect; //Delete old
                            FDragRect := ItemRect(Index);
                            FDragRectValid:=True;
                            DrawDragRect;  //Draw New
                            DeleteDragCanvas;
                       End;
                       dsDragMove:
                       If Index<>FDragSelected Then
                       Begin
                            CreateDragCanvas;
                            If FDragRectValid Then DrawDragRect; //Delete old
                            FDragRect := ItemRect(Index);
                            FDragRectValid:=True;
                            DrawDragRect; //Draw New
                            DeleteDragCanvas;
                       End;
                       dsDragLeave:
                       Begin
                            If FDragRectValid Then
                            Begin
                                 FDragRectValid:=False;
                                 CreateDragCanvas;
                                 DrawDragRect; //Delete old
                                 DeleteDragCanvas;
                            End;
                       End;
                    End; //Case
               End
               Else Goto invalid;
          End
          Else
          Begin
invalid:
               If FDragRectValid Then
               Begin
                    FDragRectValid:=False;
                    CreateDragCanvas;
                    DrawDragRect; //Delete old
                    DeleteDragCanvas;
               End;
          End;
          FDragSelected:=Index;
     End;
End;


Procedure TListBox.DragDrop(Source:TObject;X,Y:LongInt);
Begin
     If FDragRectValid Then
     Begin
          CreateDragCanvas;
          DrawDragRect; //Delete old
          DeleteDragCanvas;
          FDragRectValid:=False;
     End;
     Inherited DragDrop(Source,X,Y);
End;


Function TListBox.ItemAtPos(Pos:TPoint;existing:Boolean):LongInt;
Var  aBottom,aTop:LongInt;
Begin
     If PointInRect(Pos,ClientRect) Then
     Begin
          Result := TopIndex;
          aBottom := Height-ItemHeight-3;
          aTop := Height-3;

          While Result < Items.Count Do
          Begin
               If Pos.Y >= aBottom Then
                 If Pos.Y < aTop Then Exit; //found
               Dec(aTop,ItemHeight);
               Dec(aBottom,ItemHeight);
               Inc(Result);
          End;
          If Not existing Then Exit;
     End;
     Result := -1;
End;


Function TListBox.ItemRect(Index:LongInt):TRect;
Var  I:LongInt;
Begin
     If Index <= Items.Count Then
     Begin
          Result.Left := 2;
          Result.Right := Width-4;
          Result.Bottom := Height-ItemHeight-3;
          Result.Top := Height-3;
          For I := TopIndex To Index-1 Do
          Begin
               Dec(Result.Top,ItemHeight);
               Dec(Result.Bottom,ItemHeight);
          End;
     End
     Else FillChar(Result,SizeOf(Result),0);
End;


Procedure TListBox.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF Win95}
     CreateSubClass(ClassData,'LISTBOX');
     {$ENDIF}
     {$IFDEF OS2}
     ClassData.ClassULong := WC_LISTBOX;
     {$ENDIF}
End;


Procedure TListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'ListBox';
     Height := 100;
     Width := 130;
     Ownerdraw := False;
     color := clEntryField;
     ParentPenColor := False;
     ParentColor := False;

     FItems := TListBoxStrings.Create;
     TListBoxStrings(FItems).Listbox := Self;
     FInitItems.Create;
     FStyle := lbStandard;
     FIntegralHeight := False;
     FHorzScroll := False;
     FMultiSelect := False;
     FExtendedSelect := False;
     FDuplicates := True;
     FSorted := False;
     FItemHeight := Font.Height;
     FUpdateCount := 0;
     FInitItemIndex := -1;
End;


Procedure TListBox.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     If Not FIntegralHeight Then Params.Style := Params.Style Or LS_NOADJUSTPOS;
     If FHorzScroll Then Params.Style := Params.Style Or LS_HORZSCROLL;
     If FMultiSelect Then Params.Style := Params.Style Or LS_MULTIPLESEL;
     If FExtendedSelect Then Params.Style := Params.Style Or LS_EXTENDEDSEL;
     If FStyle = lbOwnerdrawFixed Then Params.Style := Params.Style Or LS_OWNERDRAW;
     {$ENDIF}

     {$IFDEF Win95}
     Params.Style := Params.Style Or WS_BORDER Or LBS_NOTIFY Or WS_VSCROLL;
     Params.ExStyle := Params.ExStyle Or WS_EX_CLIENTEDGE;

     If Not FIntegralHeight Then Params.Style := Params.Style Or LBS_NOINTEGRALHEIGHT;
     If FHorzScroll Then Params.Style := Params.Style Or WS_HSCROLL;
     If FMultiSelect Then Params.Style := Params.Style Or LBS_MULTIPLESEL;
     If FExtendedSelect Then Params.Style := Params.Style Or LBS_EXTENDEDSEL;
     If FStyle = lbOwnerdrawFixed Then
       Params.Style := Params.Style Or LBS_OWNERDRAWFIXED OR LBS_HASSTRINGS;
     If FSorted Then Params.Style := Params.Style Or LBS_SORT;
     {$ENDIF}
End;


Procedure TListBox.SetupShow;
Begin
     Inherited SetupShow;

     FItems.Assign(FInitItems);
     FInitItems.Clear;

     If Style = lbOwnerdrawFixed Then
     Begin
          CreateCanvas;
          Canvas.OwnerDraw:=True;
     End;

     If (FInitItemIndex >= 0) And (FInitItemIndex < Items.Count) Then
     Begin
          ItemIndex := FInitItemIndex;
          TopIndex := FInitTopIndex;
     End;
End;


Procedure TListBox.Show;
Begin
     Inherited Show;
End;


Procedure TListBox.DestroyWnd;
Begin
     If Handle <> 0 Then
       If FInitItems <> Nil Then
       Begin
            FInitItems.Assign(FItems);
            FInitItemIndex := ItemIndex;
            FInitTopIndex := TopIndex;
       End;

     Inherited DestroyWnd;
End;


Destructor TListBox.Destroy;
Begin
     FItems.Destroy;
     FItems := Nil;
     FInitItems.Destroy;
     FInitItems := Nil;

     Inherited Destroy;
End;


Procedure TListBox.SetIntegralHeight(Value:Boolean);
Begin
     If FIntegralHeight <> Value Then
     Begin
          FIntegralHeight := Value;
          RecreateWnd;
     End;
End;


Procedure TListBox.SetHorzScroll(Value:Boolean);
Begin
     If FHorzScroll <> Value Then
     Begin
          FHorzScroll := Value;
          RecreateWnd;
     End;
End;


Procedure TListBox.SetMultiSelect(Value:Boolean);
Begin
     If FMultiSelect <> Value Then
     Begin
          FMultiSelect := Value;
          RecreateWnd;
     End;
End;


Procedure TListBox.SetExtendedSelect(Value:Boolean);
Begin
     If FExtendedSelect <> Value Then
     Begin
          FExtendedSelect := Value;
          RecreateWnd;
     End;
End;


Procedure TListBox.SetSorted(Value:Boolean);
Begin
     If FSorted <> Value Then
     Begin
          FSorted := Value;
          If Handle <> 0 Then
               RecreateWnd
          else
               FInitItems.Sorted := Value;
     End;
End;


Procedure TListBox.SetStyle(NewStyle:TListBoxStyle);
Begin
     If FStyle <> NewStyle Then
     Begin
          FStyle := NewStyle;
          RecreateWnd;
     End;
End;


Procedure TListBox.Clear;
Begin
     Items.Clear;
End;


Function TListBox.GetItems:TStrings;
Begin
     If Handle <> 0 Then Result := FItems
     Else Result := FInitItems;
End;


Procedure TListBox.SetItems(AStrings:TStrings);
Begin
     If AStrings <> Items Then Items.Assign(AStrings);
End;


Function TListBox.GetItemIndex:LongInt;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          Result := WinSendMsg(Handle,LM_QUERYSELECTION,LIT_CURSOR,0);
          {$ENDIF}
          {$IFDEF Win95}
          Result := SendMessage(Handle,LB_GETCURSEL,0,0);
          {$ENDIF}
     End
     Else Result := FInitItemIndex;
End;


Procedure TListBox.SetItemIndex(Value:LongInt);
Begin
     If Handle <> 0 Then
     Begin
          If GetItemIndex <> Value Then
          Begin
               {$IFDEF OS2}
               If FMultiSelect Then WinSendMsg(Handle,LM_SELECTITEM,LIT_NONE,0);
               WinSendMsg(Handle,LM_SELECTITEM,Value,1);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,LB_SETCURSEL,Value,0);
               {$ENDIF}
          End;
     End;
     FInitItemIndex := Value;
End;


Function TListBox.GetSelCount:LongInt;
Var  I:LongInt;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          If FMultiSelect Then
          Begin
               I := LIT_FIRST;
               Result := 0;
               While True Do
               Begin
                    I := WinSendMsg(Handle,LM_QUERYSELECTION,I,0);
                    If I = LIT_NONE Then break;
                    Inc(Result);
               End;
          End
          Else If WinSendMsg(Handle,LM_QUERYSELECTION,LIT_FIRST,0) <> LIT_NONE
               Then Result := 1
               Else Result := 0;
          {$ENDIF}
          {$IFDEF Win95}
          Result := SendMessage(Handle,LB_GETSELCOUNT,0,0);
          {$ENDIF}
     End
     Else Result := 0;
End;


Function TListBox.GetSelect(Index:LongInt):Boolean;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          Result := WinSendMsg(Handle,LM_QUERYSELECTION,Index-1,0) = Index;
          {$ENDIF}
          {$IFDEF Win95}
          Result := SendMessage(Handle,LB_GETSEL,Index,0) <> 0;
          {$ENDIF}
     End
     Else Result := False;
End;


Procedure TListBox.SetSelect(Index:LongInt;Value:Boolean);
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(Handle,LM_SELECTITEM,Index,LongWord(Value));
          {$ENDIF}
          {$IFDEF Win95}
          SendMessage(Handle,LB_SETSEL,LongWord(Value),Index);
          {$ENDIF}
     End;
End;


Function TListBox.GetTopIndex:LongInt;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          Result := WinSendMsg(Handle,LM_QUERYTOPINDEX,0,0);
          {$ENDIF}
          {$IFDEF Win95}
          Result := SendMessage(Handle,LB_GETTOPINDEX,0,0);
          {$ENDIF}
     End
     Else Result := 0;
End;


Procedure TListBox.SetTopIndex(Index:LongInt);
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(Handle,LM_SETTOPINDEX,Index,0);
          {$ENDIF}
          {$IFDEF Win95}
          SendMessage(Handle,LB_SETTOPINDEX,Index,0);
          {$ENDIF}
     End;
     FInitTopIndex := Index;
End;

Procedure TListBox.ParentNotification(Var Msg:TMessage);
Var  Index:LongInt;
     CX,CY:LongInt;
     State:TOwnerDrawState;
     {$IFDEF OS2}
     OwnerItem:POwnerItem;
     rec:TRect;
     clip:TRect;
     {$ENDIF}
     {$IFDEF Win95}
     Measure_Item:^MEASUREITEMSTRUCT;
     Draw_Item:^DRAWITEMSTRUCT;
     rclItem:TRect;
     L:LongInt;
     OldPS:LongWord;
     {$ENDIF}
Begin
     Inherited ParentNotification(Msg); {call DefaultHandler}

     {$IFDEF OS2}
     Case Msg.Msg Of
       WM_CONTROL:
       Begin
            If FUpdateCount > 0 Then Exit;
            Case Msg.Param1Hi Of
              LN_ENTER:
              Begin
                   Index := ItemIndex;
                   If (Index < 0) Or (Index >= Items.Count) Then Exit;
                   ItemSelect(Index);
                   Msg.Handled := True;
              End;
              LN_SELECT:
              Begin
                   ItemFocus(ItemIndex);
                   Msg.Handled := True;
              End;
            End;
       End;
       WM_MEASUREITEM:
       Begin
            MeasureItem(Msg.Param2,CX,CY);
            If OnMeasureItem <> Nil Then OnMeasureItem(Self,Msg.Param2,CX,CY);
            Msg.Handled := True;
            Msg.Result := CY + 65536 * CX;
       End;
       WM_DRAWITEM:
       Begin
            If Canvas = Nil Then Exit;
            If Items = Nil Then Exit;
            OwnerItem := Pointer(Msg.Param2);
            If OwnerItem <> Nil Then
              If OwnerItem^.iditem >= 0 Then
                If OwnerItem^.iditem < Items.Count Then
            Begin
                 rec := TRect(OwnerItem^.rclItem);
                 Dec(rec.Left);
                 clip := rec;
                 clip.Left := 2;
                 Dec(clip.Right);
                 If clip.Bottom < 2 Then clip.Bottom := 2;
                 Canvas.ClipRect := clip;

                 State := [];
                 If OwnerItem^.fsState And 1=1 Then Include(State,odSelected);
                 {...}
                 OwnerItem^.fsState := 0;
                 OwnerItem^.fsStateOld := 0;
                 DrawItem(OwnerItem^.iditem,rec,State);
                 If OnDrawItem <> Nil
                 Then OnDrawItem(Self,OwnerItem^.iditem,rec,State);
                 Msg.Handled := True;
                 Msg.Result := 1;
            End;
       End;
     End;
     {$ENDIF}

     {$IFDEF Win95}
     Case Msg.Msg Of
       WM_COMMAND:
       Begin
            Msg.Handled:=True; //!!
            If FUpdateCount > 0 Then Exit;
            Index := ItemIndex;
            If (Index < 0) Or (Index >= Items.Count) Then Exit;
            Case Msg.Param1Hi Of
              LBN_DBLCLK:ItemSelect(Index);
              LBN_SELCHANGE:ItemFocus(Index);
            End;
       End;
       WM_MEASUREITEM:
       Begin
            Measure_Item := Pointer(Msg.Param2);
            MeasureItem(0,CX,CY); {Index 0 ?}
            If OnMeasureItem <> Nil Then OnMeasureItem(Self,0,CX,CY);
            Measure_Item^.ItemHeight := CY;
            Msg.Handled := True;
            Msg.Result := 1;
       End;
       WM_DRAWITEM:
       Begin
            If Canvas = Nil Then Exit;
            If Items = Nil Then Exit;
            Draw_Item := Pointer(Msg.Param2);
            OldPS := Canvas.Handle;
            Canvas.Handle := Draw_Item^.HDC;
            {Canvas.Font := Canvas.Font;} //This causes recursion ??
            SetTextAlign(Canvas.Handle,TA_LEFT Or TA_BOTTOM);
            Index:=Draw_Item^.ItemId;
            If Index >= 0 Then
              If Index < Items.Count Then
            Begin
                 State := [];
                 If Draw_Item^.ItemState And ODS_SELECTED <> 0
                 Then Include(State,odSelected);
                 {...}
                 rclItem := TRect(Draw_Item^.rcItem);
                 L := rclItem.Top;
                 rclItem.Top := rclItem.Bottom;
                 rclItem.Bottom := L;
                 TransformRectToOS2(rclItem,Self,Nil);
                 DrawItem(Index,rclItem,State);
                 If OnDrawItem <> Nil
                 Then OnDrawItem(Self,Index,rclItem,State);
                 Msg.Handled := True;
                 Msg.Result := 1;
            End;
            Canvas.Handle := OldPS;
       End;
     End;
     {$ENDIF}
End;


{$HINTS OFF}
Procedure TListBox.ItemSelect(Index:LongInt);
Begin
     If FComboBox <> Nil Then
     Begin
          If FComboBox.Style <> csSimple Then
               FComboBox.DroppedDown := False; {wirkt nur bei DropDownCombo}
          FComboBox.ItemSelect(Index);
          Exit;
     End;

     If OnItemSelect <> Nil Then OnItemSelect(Self,Index);
End;


Procedure TListBox.ItemFocus(Index:LongInt);
Begin
     If FComboBox <> Nil Then
     Begin
          FComboBox.ItemFocus(Index);
          Exit;
     End;

     If OnItemFocus <> Nil Then OnItemFocus(Self,Index);
End;
{$HINTS ON}


Procedure TListBox.MeasureItem(Index:LongInt;Var Width,Height:LongInt);
Begin
     Width := 0; {Standard}
     Height := FItemHeight;
     If Canvas = Nil Then
     Begin
          If FStyle = lbOwnerdrawFixed Then
          Begin
              If Handle=0 Then exit; //sinnlos ein Canvas zu erzeugen...
              CreateCanvas;
          End
          Else Exit;
     End;
     If FStyle = lbOwnerdrawFixed Then Canvas.OwnerDraw:=True;

     If (Index >= 0) And (Index < Items.Count) Then
     Begin
          Canvas.GetTextExtent(Items.Strings[Index],Width,Height);
          If FItemHeight > Height Then Height := FItemHeight;
     End;
End;


Procedure TListBox.DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);
Var  X,Y,CX,CY,cx1,cy1:LongInt;
     S:String;
Begin
     If FOnDrawItem <> Nil Then Exit;
     If FStyle = lbOwnerdrawFixed Then Canvas.OwnerDraw:=True;

     If State * [odSelected] <> [] Then
     Begin
          Canvas.Pen.color := clHighlightText;
          Canvas.Brush.color := clHighlight;
     End Else
     Begin
          Canvas.Pen.color := PenColor;
          Canvas.Brush.color := color;
     End;
     Canvas.FillRect(rec,Canvas.Brush.color);
     X := rec.Left + 2;
     Y := rec.Bottom;
     CX := rec.Right - X;
     CY := rec.Top - Y;

     S := Items.Strings[Index];
     Canvas.GetTextExtent(S,cx1,cy1);
     Y := Y + ((CY - cy1) Div 2);
     If Y < rec.Bottom Then Y := rec.Bottom;
     Canvas.Brush.Mode := bmTransparent;
     Canvas.TextOut(X,Y,S);
End;


Procedure TListBox.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then FDragging := True;
End;


Procedure TListBox.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     LastMsg.CallDefaultHandler;    {ensure the Selection Is up To date}

     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          If FComboBox <> Nil Then
               FComboBox.ListBoxMouseUp;
          If Not FDragging Then Exit;
     End;
End;


{$HINTS OFF}
Procedure TListBox.CharEvent(Var key:Char;RepeatCount:Byte);
Begin
     {no Inherited call, To avoid passing the key To the Form}
End;
{$HINTS ON}


Procedure TListBox.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var  idx:LongInt;
Begin
     Case KeyCode Of
       kbCUp,kbCDown: ; {!}
       {$IFDEF OS2}
       //kbCR: ; {!}
       kbCR: {handle CR and don't forward to parent window}
       Begin
            idx := ItemIndex;
            If (idx < 0) Or (idx >= Items.Count) Then Exit;
            ItemSelect(idx);

            KeyCode := kbNull;
       End;
       kbEsc:
       Begin
            If FComboBox <> Nil Then
              If FComboBox.FStyle <> csSimple Then
                FComboBox.DroppedDown := false;
       End;
       {$ENDIF}
       {$IFDEF Win95}
       kbCR:
       Begin
            idx := ItemIndex;
            If FComboBox <> Nil Then
              If FComboBox.FStyle <> csSimple Then ItemSelect(idx);

            KeyCode := kbNull;
       End;
       {$ENDIF}
       kbAltCUp: If FComboBox <> Nil Then FComboBox.DroppedDown := False;
       Else Inherited ScanEvent(KeyCode,RepeatCount);
     End;
End;


Procedure TListBox.BeginUpdate;
Begin
     If FUpdateCount = 0 Then
     Begin
          If (Handle <> 0) And Visible Then
          Begin
               FEnableWindowUpdate := True;
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,False);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,0,0);
               {$ENDIF}
          End;
     End;
     Inc(FUpdateCount);
End;


Procedure TListBox.EndUpdate;
Begin
     If FUpdateCount=0 Then Exit;
     Dec(FUpdateCount);
     If FUpdateCount = 0 Then
     Begin
          If (Handle <> 0) And FEnableWindowUpdate Then
          Begin
               FEnableWindowUpdate := False;
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,True);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,1,0);
               {$ENDIF}
          End;
     End;
End;


Function TListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
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


Procedure TListBox.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
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
บ This section: TGroupBox Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TGroupBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='GroupBox';
     Caption:=Name;
     Height:=100;
     Width:=130;
     ParentPenColor:=True;
     ParentColor:=True;
     CursorTabStop:=False;
     TabStop:=False;
     ZOrder:=zoBottom;
     Include(ComponentState, csAcceptsControls);
End;


Procedure TGroupBox.Redraw(Const rec:TRect);
Var  S:String;
     rcy,CX,CY:LongInt;
     rc1,rctext:TRect;
     LightColor,DarkColor:TColor;
     P:Integer;
Begin
     If Canvas = Nil Then Exit;
     Inherited Redraw(rec);

     rc1 := ClientRect;
     rcy := rc1.Top;

     If Caption <> '' Then
     Begin
          Dec(rc1.Top,Canvas.Font.Height Div 2);
          Canvas.Pen.color := PenColor;
          Canvas.Brush.color := color;
          Canvas.Brush.Mode := bmTransparent;
          S := Caption;
          P := Pos('~',S);  { & }
          If P = Length(S) Then P := 0;
          If P > 0 Then Delete(S,P,1);
          Canvas.GetTextExtent(S,CX,CY);
          rctext.Left := 10;
          rctext.Bottom := rcy-Canvas.Font.Height;
          rctext.Right := rctext.Left + CX;
          rctext.Top := rctext.Bottom + CY;
          If P = 0 Then Canvas.TextOut(rctext.Left,rctext.Bottom, Caption)
          Else Canvas.MnemoTextOut(rctext.Left,rctext.Bottom, Caption);
          Canvas.ExcludeClipRect(rctext);
     End;

     Case Application.Platform Of
       Win32,OS2Ver40:
       Begin
            DarkColor := clDkGray;
            LightColor := clWhite;
       End;
       Else
       Begin
            DarkColor := clWindowFrame;
            LightColor := clBtnHighlight;
       End;
     End;

     DrawSystemFrame(Self,rc1,LightColor,DarkColor);

     Canvas.DeleteClipRegion;
End;


Procedure TGroupBox.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
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


{$HINTS OFF}
Procedure TGroupBox.CMTextChanged(Var Msg:TMessage);
Begin
     Invalidate;
End;
{$HINTS ON}


Function TGroupBox.EvaluateShortCut(KeyCode:TKeyCode):Boolean;
Var  S:String;
     P:Integer;
     key:TKeyCode;
     FocusControl:TControl;
Begin
     FocusControl := GetFirstTabControl( nil, false );
     if FocusControl = nil Then
          FocusControl := Nil;

     S := Caption;
     P := Pos('~',S);    { & }
     If (P > 0) And (P < Length(S)) Then
     Begin
          key := (Ord(S[P+1]) Or $20) + kb_Alt + kb_Char;
          If key = KeyCode Then {found}
            If FocusControl <> Nil Then
            Begin
                 Result := True;
                 Try
                    FocusControl.Focus;
                 Except
                    Result := False;
                 End;
                 If Result Then Exit;
            End;
     End;
     Result := Inherited EvaluateShortCut(KeyCode);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TLabel Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TLabel.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'Label';
     Caption := Name;
     Height := 20;
     Width := 100;
     ParentPenColor := True;
     ParentColor := True;
     CursorTabStop := False;
     TabStop := False;
     FAutoSize := False;
     FAlignment := taLeftJustify;
     FWordWrap := False;
     FRows := 1;
     FFocusControl := Nil;
     FShowAccelChar := True;
End;

Procedure TLabel.SetupShow;
Begin
     Inherited SetupShow;

     SetAutoSize(FAutoSize);
End;

{$HINTS OFF}
Procedure TLabel.CMTextChanged(Var Msg:TMessage);
Begin
     Invalidate;
     SetAutoSize(FAutoSize);
End;
{$HINTS ON}

Procedure TLabel.SetAutoSize(Value:Boolean);
Var  CX,CY:LongInt;
     S:String;
     P:Integer;
Begin
     FAutoSize := Value;
     If FAutoSize Then
     Begin
          FWordWrap := False;
          If Canvas <> Nil Then
          Begin
               S := Caption;
               If FShowAccelChar Then
               Begin
                    P := Pos('~',S);  { & }
                    If (P > 0) And (P < Length(S)) Then Delete(S,P,1);
               End;
               Canvas.GetTextExtent(S,CX,CY);
               SetWindowPos(Left,Bottom,CX,CY);
          End;
     End;
End;

Procedure TLabel.SetAlignment(Value:TAlignment);
Begin
     If Value <> FAlignment Then
     Begin
          FAlignment := Value;
          If Handle <> 0 Then Invalidate;
     End;
End;

Procedure TLabel.SetWordWrap(Value:Boolean);
Begin
     If Value <> FWordWrap Then
     Begin
          FWordWrap := Value;
          If FWordWrap Then FAutoSize := False;
          If Handle <> 0 Then Invalidate;
     End;
End;

Procedure TLabel.SetAccelChar(Value:Boolean);
Begin
     If FShowAccelChar <> Value Then
     Begin
          FShowAccelChar := Value;
          Invalidate;
     End;
End;

Procedure TLabel.SetFocusControl(Value:TControl);
Begin
     FFocusControl := Value;
     If FFocusControl <> Nil Then FFocusControl.FreeNotification(Self);
End;

Procedure TLabel.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFocusControl Then FFocusControl := Nil;
End;

Function TLabel.GetRows:Integer;
Var  S,s1,news:String;
     P,p10,I:Integer;
     CX,CY:LongInt;
     forcebreak:Boolean;
Begin
     If (Handle <> 0) And (Not Visible) Then
     Begin
          Result := 1;
          If FWordWrap Then
          Begin
               S := Caption;
               Repeat
                  I := Pos(#13#10,S);
                  If I > 0 Then Delete(S,I,1);
               Until I = 0;

               Repeat
                  I := Pos(#10#13,S);
                  If I > 0 Then Delete(S,I+1,1);
               Until I = 0;

               For I := 1 To Length(S) Do
                  If S[I] = #13 Then S[I] := #10;

               news := '';
               While S <> '' Do
               Begin
                    P := Pos(' ',S);
                    p10 := Pos(#10,S);
                    {Select First separator}
                    forcebreak := False;
                    If p10 > 0 Then
                    Begin
                         If (P > p10) Or (P = 0) Then
                         Begin
                              S[p10] := ' ';
                              forcebreak := True;
                              P := p10;
                         End;
                    End;

                    If P > 0 Then s1 := Copy(S,1,P)
                    Else s1 := S;
                    Delete(S,1,Length(s1));         {s1 Is the First Word Of S}

                    Canvas.GetTextExtent(news+s1,CX,CY);
                    If CX > Width Then
                    Begin
                         If news <> '' Then news := s1;
                         Inc(Result);
                    End
                    Else news := news + s1;

                    If forcebreak And (news <> '') Then
                    Begin
                         Inc(Result);
                         news := '';
                    End;

                    If S = '' Then Inc(Result);
               End;
          End;
     End
     Else Result := FRows;
End;

Procedure TLabel.DoDrawLine(Const S:String; Var Row:Integer);
Var  X,Y,CX,CY:LongInt;
     drawMnemo:Boolean;
     s1:String;
     P:Integer;
Begin
     If S = '' Then Exit;
     s1 := S;

     drawMnemo := False;
     If RemoveAccel Then
     Begin
          P := Pos('~',s1);   { & }
          If (P > 0) And (P < Length(s1)) Then
          Begin
               Delete(s1,P,1);
               RemoveAccel := False;
               drawMnemo := True;
          End;
     End;

     Canvas.GetTextExtent(s1,CX,CY);

     Case FAlignment Of
       taLeftJustify:  X := 0;
       taRightJustify: X := Width - CX;
       taCenter:       X := (Width - CX) Div 2;
     End;
     Y := Height - (Row * CY);

     If drawMnemo Then
     Begin
          Insert('~',s1,P);
          Canvas.MnemoTextOut(X,Y,s1);
     End
     Else Canvas.TextOut(X,Y,s1);

     FRows := Row;
     Inc(Row);
End;

Procedure TLabel.Redraw(Const rec:TRect);
Var  S,s1,news:String;
     Row,P,p10,I:Integer;
     CX,CY:LongInt;
     forcebreak:Boolean;
Begin
     If Canvas = Nil Then Exit;

     Canvas.Pen.color := PenColor;
     Canvas.Brush.color := color;

     Inherited Redraw(rec);

     RemoveAccel := FShowAccelChar;
     Row := 1;
     If FWordWrap Then
     Begin
          S := Caption;
          Repeat
             I := Pos(#13#10,S);
             If I > 0 Then Delete(S,I,1);
          Until I = 0;

          Repeat
             I := Pos(#10#13,S);
             If I > 0 Then Delete(S,I+1,1);
          Until I = 0;

          For I := 1 To Length(S) Do
             If S[I] = #13 Then S[I] := #10;

          news := '';
          While S <> '' Do
          Begin
               {Search most Left separator}
               P := Pos(' ',S);
               p10 := Pos(#10,S);

               {Select First separator}
               forcebreak := False;
               If p10 > 0 Then
               Begin
                    If (P > p10) Or (P = 0) Then
                    Begin
                         S[p10] := ' ';
                         forcebreak := True;
                         P := p10;
                    End;
               End;

               If P > 0 Then s1 := Copy(S,1,P)
               Else s1 := S;
               Delete(S,1,Length(s1));         {s1 Is the First Word Of S}

               Canvas.GetTextExtent(news+s1,CX,CY);
               If CX > Width Then
               Begin
                    If news <> '' Then
                    Begin
                         DoDrawLine(news,Row);
                         news := s1;
                    End
                    Else DoDrawLine(s1,Row);
               End
               Else news := news + s1;

               If forcebreak And (news <> '') Then
               Begin
                    DoDrawLine(news,Row);
                    news := '';
               End;

               If S = '' Then DoDrawLine(news,Row);
          End;
     End
     Else DoDrawLine(Caption,Row);
End;


Procedure TLabel.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
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

Function TLabel.EvaluateShortCut(KeyCode:TKeyCode):Boolean;
Var  S:String;
     P:Integer;
     key:TKeyCode;
Begin
     S := Caption;
     P := Pos('~',S);    { & }
     If (P > 0) And (P < Length(S)) Then
     Begin
          key := (Ord(S[P+1]) Or $20) + kb_Alt + kb_Char;
          If key = KeyCode Then {found}
            If FFocusControl <> Nil Then
            Begin
                 Result := True;
                 Try
                    FFocusControl.Focus;
                 Except
                    Result := False;
                 End;
                 If Result Then Exit;
            End;
     End;
     Result := Inherited EvaluateShortCut(KeyCode);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TValueSet Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TValueSetArray=Array[0..MaxInt] Of Pointer;
    PValueSetArray=^TValueSetArray;


Procedure TValueSet.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='ValueSet';
     Width:=100;
     Height:=100;
     ParentPenColor:=True;
     ParentColor:=True;
     AutoScroll := False;

     FRows:=1;
     FColumns:=1;
     FCount:=1;
     GetMem(FMemory,FCount*4);
     FCtl3D:=True;
     FBorderStyle:=bsSingle;
     FItemBorder:=bsSingle;
     FScaleBitmap:=False;
     FSelection:=0;
     ContentStyle:=vscText;
     FMargin:=8;
     FSpacing:=8;
     FItemWidth:=30;
     FItemHeight:=30;
     FAutoSize:=True;
     FUpdateCount:=0;
     If Not Designed Then Include(ComponentState, csAcceptsControls);
End;


Procedure TValueSet.SetupShow;
Begin
     Inherited SetupShow;
     SetupScrollBars;
End;


Procedure TValueSet.BeginUpdate;
Begin
     Inc(FUpdateCount);
End;


Procedure TValueSet.EndUpdate;
Begin
     Dec(FUpdateCount);
     If FUpdateCount = 0 Then
     Begin
          SetupScrollBars;
          Invalidate;
     End;
End;


Procedure TValueSet.GetXYVisible(Var xVisible,yVisible:LongInt);
Var  rc:TRect;
Begin
     rc := ClientRect;

     xVisible := (rc.Right +1 - rc.Left - (2*FMargin) + FSpacing) Div
                 (FItemWidth + FSpacing);
     yVisible := (rc.Top +1 - rc.Bottom - (2*FMargin) + FSpacing) Div
                 (FItemHeight + FSpacing);
End;


Procedure TValueSet.SetupScrollBars;
Var  xVisible,yVisible:LongInt;
Begin
     If Handle = 0 Then Exit;

     If Not AutoSize Then
     Begin
          {look If we need A ScrollBar}
          GetXYVisible(xVisible,yVisible);

          If xVisible < FColumns Then
          Begin
               If yVisible < FRows Then
               Begin
                    ScrollBars := ssBoth;

                    VertScrollBar.SetScrollRange(1,FRows,yVisible);
                    VertScrollBar.Position := 1;
               End
               Else ScrollBars := ssHorizontal;

               HorzScrollBar.SetScrollRange(1,FColumns,xVisible);
               HorzScrollBar.Position := 1;
          End
          Else
          Begin
               If yVisible < FRows Then
               Begin
                    ScrollBars := ssVertical;

                    VertScrollBar.SetScrollRange(1,FRows,yVisible);
                    VertScrollBar.Position := 1;
               End
               Else ScrollBars := ssNone;
          End;
     End
     Else ScrollBars := ssNone;
End;


Procedure TValueSet.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Begin
     Inherited Scroll(Sender,ScrollCode,ScrollPos);
     Invalidate;
End;


Procedure TValueSet.Resize;
Begin
     Inherited Resize;
     SetupScrollBars;
End;


Procedure TValueSet.SetAutoSize(NewValue:Boolean);
Begin
     FAutoSize := NewValue;
     If FUpdateCount = 0 Then Invalidate;
End;


Procedure TValueSet.SetItemWidth(NewValue:LongInt);
Begin
     If NewValue < 2 Then NewValue := 2;
     FItemWidth := NewValue;
     If Not AutoSize Then
     Begin
          If FUpdateCount = 0 Then
          Begin
               SetupScrollBars;
               Invalidate;
          End;
     End;
End;


Procedure TValueSet.SetItemHeight(NewValue:LongInt);
Begin
     If NewValue < 2 Then NewValue := 2;
     FItemHeight := NewValue;
     If Not AutoSize Then
     Begin
          If FUpdateCount = 0 Then
          Begin
               SetupScrollBars;
               Invalidate;
          End;
     End;
End;


Destructor TValueSet.Destroy;
Var  I:LongInt;
Begin
     If FMemory <> Nil Then
     Begin
          For I := 0 To FCount-1 Do FreeData(I);

          FreeMem(FMemory, FCount * 4);
          FMemory := Nil;
     End;
     Inherited Destroy;
End;


Procedure TValueSet.DrawSelection(Index:LongInt);
Var  rc:TRect;
Begin
     rc := RectFromIndex(Index);

     InflateRect(rc,4,4);
     Canvas.Rectangle(rc);

     If HasFocus Then
     Begin
          InflateRect(rc,-2,-2);
          Canvas.DrawFocusRect(rc);
     End;
End;


Procedure TValueSet.DrawInterior(Index:LongInt);
Var C:TColor;
    B:TBitmap;
    S:^String;
    P:Pointer;
    XX,yy,CX,CY:LongInt;
    rc1:TRect;
    rc:TRect;
Begin
     If FMemory=Nil Then Exit;

     rc := RectFromIndex(Index);
     InflateRect(rc,-1,-1);  {Exclude the border}

     P := GetData(Index);

     Case FContentStyle Of
       vscText:
       Begin
            S:=P;
            If S<>Nil Then
            Begin
                 Canvas.GetTextExtent(S^,CX,CY);
                 XX:=rc.Right-rc.Left-CX;
                 If XX<0 Then XX:=0;
                 yy:=rc.Top-rc.Bottom-CY;
                 If yy<0 Then yy:=0;

                 XX:=rc.Left+(XX Div 2);
                 yy:=rc.Bottom+(yy Div 2);

                 Canvas.Pen.color:=PenColor;
                 Canvas.Brush.color := color;
                 Canvas.TextOut(XX,yy,S^);

                 rc1.Left:=XX;
                 rc1.Right:=XX+CX-1;
                 rc1.Bottom:=yy;
                 rc1.Top:=yy+CY-1;
                 Canvas.ExcludeClipRect(rc1);
            End;
            Canvas.FillRect(rc,color);
       End;
       vscBitmap:
       Begin
            B:=P;
            If B=Nil Then
            Begin
                 Canvas.FillRect(rc,color);
                 Exit;
            End;

            If FScaleBitmap Then
            Begin
                 Canvas.StretchDraw(rc.Left,rc.Bottom,
                                    rc.Right-rc.Left,
                                    rc.Top-rc.Bottom,B);
            End
            Else
            Begin
                 rc1:=rc;

                 XX:=rc.Right-rc.Left-B.Width;
                 If XX<0 Then XX:=0;
                 yy:=rc.Top-rc.Bottom-B.Height;
                 If yy<0 Then yy:=0;

                 XX:=rc.Left+(XX Div 2);
                 yy:=rc.Bottom+(yy Div 2);

                 CX:=rc.Right-rc.Left;
                 If CX>B.Width Then CX:=B.Width;
                 CY:=rc.Top-rc.Bottom;
                 If CY>B.Height Then CY:=B.Height;

                 rc.Left:=0;
                 rc.Right:=CX;
                 rc.Bottom:=0;
                 rc.Top:=CY;

                 Canvas.PartialDraw(XX,yy,rc,B);

                 rc.Left:=XX;
                 rc.Right:=XX+CX-1;
                 rc.Bottom:=yy;
                 rc.Top:=yy+CY-1;
                 Canvas.ExcludeClipRect(rc);
                 Canvas.FillRect(rc1,color);
            End;
       End;
       vscRGBColor:
       Begin
            C:=TColor(P);
            Canvas.FillRect(rc,C);
       End;
     End; {Case}
End;


{$HINTS OFF}
Procedure TValueSet.Redraw(Const rec:TRect);
Var  clip,rc,rc1:TRect;
     X,Y:LongInt;
     StartRow,StartCol:LongInt;
     idx:LongInt;
Begin
     If Canvas = Nil Then Exit;

     rc := ClientRect;

     If FBorderStyle = bsSingle Then
     Begin
          If Not FCtl3D Then
          Begin
               Canvas.Pen.color := clDkGray;
               Canvas.Rectangle(rc);
               InflateRect(rc,-1,-1);
          End
          Else DrawSystemBorder(Self,rc,FBorderStyle); {Inflate -2}
     End
     Else
     Begin
          Canvas.Pen.color := color;
          Canvas.Rectangle(rc);
          InflateRect(rc,-1,-1);
     End;

     clip := Canvas.ClipRect;
     If IsRectEmpty(clip) Then Canvas.ClipRect := rc
     Else Canvas.ClipRect := IntersectRect(rec,rc);

     If VertScrollBar <> Nil Then StartRow := VertScrollBar.Position
     Else StartRow := 1;

     If HorzScrollBar <> Nil Then StartCol := HorzScrollBar.Position
     Else StartCol := 1;

     For Y := StartRow To FRows Do
     Begin
          For X := StartCol To FColumns Do
          Begin
               idx := IndexFromColumnRow(X,Y);
               rc1 := RectFromIndex(idx);

               If Not AutoSize Then
                 If IsRectEmpty(IntersectRect(rc1, rec)) Then continue;

               DrawInterior(idx);

               If FItemBorder = bsSingle Then
               Begin
                    If Not FCtl3D Then
                    Begin
                         Canvas.Pen.color := clDkGray;
                         Canvas.Rectangle(rc1);
                    End
                    Else Canvas.ShadowedBorder(rc1,clDkGray,clWhite);
               End
               Else
               Begin
                    Canvas.Pen.color := color;
                    Canvas.Rectangle(rc1);
               End;
               Canvas.ExcludeClipRect(rc1);
          End;
     End;

     Inherited Redraw(rec);

     Canvas.Pen.color := clDkGray;
     DrawSelection(FSelection);

     Canvas.DeleteClipRegion;
End;


Procedure TValueSet.SetCtl3D(Value:Boolean);
Begin
     If FCtl3D <> Value Then
     Begin
          FCtl3D := Value;
          If FUpdateCount = 0 Then Invalidate;
     End;
End;


Procedure TValueSet.SetBorderStyle(Value:TBorderStyle);
Begin
     If FBorderStyle <> Value Then
     Begin
          FBorderStyle := Value;
          If FUpdateCount = 0 Then Invalidate;
     End;
End;


Procedure TValueSet.SetItemBorder(Value:TBorderStyle);
Begin
     If FItemBorder <> Value Then
     Begin
          FItemBorder := Value;
          If FUpdateCount = 0 Then Invalidate;
     End;
End;


Procedure TValueSet.SetScaleBitmap(Value:Boolean);
Begin
     If FScaleBitmap <> Value Then
     Begin
          FScaleBitmap := Value;
          If FContentStyle = vscBitmap Then
            If FUpdateCount = 0 Then Invalidate;
     End;
End;


Procedure TValueSet.ItemFocus(Index:LongInt);
Begin
     If FOnItemFocus <> Nil Then FOnItemFocus(Self,Index);
End;


Procedure TValueSet.ItemSelect(Index:LongInt);
Begin
     If OnItemSelect <> Nil Then OnItemSelect(Self,Index);
End;
{$HINTS ON}


Procedure TValueSet.SetSelection(Value:LongInt);
Var StartRow,StartCol,ColCount,RowCount,FX,FY:LongInt;
    Paint:Boolean;
Begin
     If FSelection <> Value Then
     Begin
          If Handle <> 0 Then
            If FUpdateCount = 0 Then
          Begin
               {Clear old Selection}
               Canvas.Pen.color := color;
               DrawSelection(FSelection);

               Canvas.Pen.color := clDkGray;
               DrawSelection(Value);
          End;
          FSelection := Value;

          //If the Selection Is outside the Visible area, Scroll the valueset !
          ColumnRowFromIndex(FSelection,FX,FY);

          If VertScrollBar <> Nil Then StartRow := VertScrollBar.Position
          Else StartRow := 1;

          If HorzScrollBar <> Nil Then StartCol := HorzScrollBar.Position
          Else StartCol := 1;

          GetXYVisible(ColCount,RowCount);

          Paint:=False;

          If HorzScrollBar<>Nil Then
            If ((FX<StartCol)Or(FX>=StartCol+ColCount)) Then
          Begin
              HorzScrollBar.Position:=FX;
              Paint:=True;
          End;

          If VertScrollBar<>Nil Then
            If ((FY<StartRow)Or(FY>=StartRow+RowCount)) Then
          Begin
              VertScrollBar.Position:=FY;
              Paint:=True;
          End;

          If Paint Then Invalidate;
     End;
End;




Procedure TValueSet.SetContentStyle(NewStyle:TValueSetContentStyle);
Var  I:LongInt;
Begin
     If FContentStyle = NewStyle Then Exit;

     For I := 0 To FCount-1 Do FreeData(I);

     FContentStyle := NewStyle;
     If FUpdateCount = 0 Then Invalidate;
End;


Procedure TValueSet.SetRows(Value:LongInt);
Begin
     SetDimension(FColumns, Value);
End;


Procedure TValueSet.SetColumns(Value:LongInt);
Begin
     SetDimension(Value, FRows);
End;


Procedure TValueSet.SetDimension(Column,Row:LongInt);
Var  NewMem:^Pointer;
     CopyCount,I:LongInt;
Begin
     If Column <= 0 Then Exit;
     If Row <= 0 Then Exit;

     GetMem(NewMem, Row * Column * 4);      {FillChar #0}

     CopyCount := FCount;
     If CopyCount > Column * Row Then CopyCount := Column * Row;

     {Free the Last Items}
     For I := CopyCount To FCount-1 Do FreeData(I);

     System.Move(FMemory^, NewMem^, CopyCount * 4);
     FreeMem(FMemory, FCount * 4);

     FColumns := Column;
     FRows := Row;
     FCount := FColumns * FRows;
     FMemory := NewMem;

     If FUpdateCount = 0 Then
     Begin
          SetupScrollBars;
          Invalidate;
     End;
End;


Function TValueSet.IndexFromColumnRow(Column,Row:LongInt):LongInt;
Begin
     Result := ((Row-1) * FColumns) + Column-1;
End;


Procedure TValueSet.ColumnRowFromIndex(Index:LongInt;Var Column,Row:LongInt);
Begin
     Column := (Index Mod FColumns) + 1;
     Row := (Index Div FColumns) + 1;
End;


Function TValueSet.RectFromIndex(Index:LongInt):TRect;
Var  W,H,X1,y1:LongInt;
     xInc,yInc,XPos,YPos:LongInt;
     rc1:TRect;
     StartRow,StartCol:LongInt;
     Row,Column:LongInt;
Begin
     Result := Rect(0,0,0,0);

     ColumnRowFromIndex(Index,Column,Row);

     rc1 := ClientRect;

     If AutoSize Then
     Begin
          W := rc1.Right - rc1.Left - (2*FMargin) - (FColumns-1) * FSpacing;
          If W < 0 Then W := 0;
          H := rc1.Top - rc1.Bottom - (2*FMargin) - (FRows-1) * FSpacing;
          If H < 0 Then H := 0;

          xInc := W Div FColumns;
          yInc := H Div FRows;
     End
     Else
     Begin
          xInc := FItemWidth;
          yInc := FItemHeight;
     End;

     If VertScrollBar <> Nil Then StartRow := VertScrollBar.Position
     Else StartRow := 1;

     If HorzScrollBar <> Nil Then StartCol := HorzScrollBar.Position
     Else StartCol := 1;

     If (Column < StartCol) Or (Row < StartRow) Then Exit;

     XPos := rc1.Left + FMargin;
     YPos := rc1.Top - FMargin;
     For y1 := StartRow To FRows Do
     Begin
          For X1 := StartCol To FColumns Do
          Begin
               If X1 = Column Then
                 If y1 = Row Then
               Begin
                    Result.Left := XPos;
                    Result.Right := Result.Left + xInc;
                    Result.Top := YPos;
                    Result.Bottom := Result.Top - yInc;
                    Exit;
               End;
               Inc(XPos, xInc + FSpacing);
          End;

          XPos := rc1.Left + FMargin;
          Dec(YPos, yInc + FSpacing);
     End;
End;


Function TValueSet.IndexFromPoint(X,Y:LongInt):LongInt;
Var  W,H,X1,y1:LongInt;
     xInc,yInc,XPos,YPos:LongInt;
     rec,rc1:TRect;
     pt:TPoint;
Begin
     Result := -1;

     rc1 := ClientRect;

     If AutoSize Then
     Begin
          W := rc1.Right - rc1.Left - (2*FMargin) - (FColumns-1) * FSpacing;
          If W < 0 Then W := 0;
          H := rc1.Top - rc1.Bottom - (2*FMargin) - (FRows-1) * FSpacing;
          If H < 0 Then H := 0;

          xInc := W Div FColumns;
          yInc := H Div FRows;
     End
     Else
     Begin
          xInc := FItemWidth;
          yInc := FItemHeight;
     End;

     XPos := rc1.Left + FMargin;
     YPos := rc1.Top - FMargin;
     pt := Point(X,Y);
     For y1 := 1 To FRows Do
     Begin
          For X1 := 1 To FColumns Do
          Begin
               rec := Rect(XPos, YPos-yInc, XPos+xInc, YPos);
               If PointInRect(pt, rec) Then
               Begin
                    If HorzScrollBar <> Nil
                      Then Inc(X1, HorzScrollBar.Position-1);
                    If VertScrollBar <> Nil
                      Then Inc(y1, VertScrollBar.Position-1);
                    Result := (y1-1) * FColumns + X1-1;
                    Exit;
               End;

               Inc(XPos, xInc + FSpacing);
          End;

          XPos := rc1.Left + FMargin;
          Dec(YPos, yInc + FSpacing);
     End;
End;


{$HINTS OFF}
Procedure TValueSet.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  idx:LongInt;
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          idx := IndexFromPoint(X,Y);
          If idx < 0 Then Exit;

          SetSelection(idx);
          ItemFocus(idx);
          Focus;
     End;
End;


Procedure TValueSet.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  idx:LongInt;
Begin
     Inherited MouseDblClick(Button,ShiftState,X,Y);

     If Button = mbLeft Then
     Begin
          idx := IndexFromPoint(X,Y);
          If idx < 0 Then Exit;

          ItemSelect(idx);
     End;
End;
{$HINTS ON}


Procedure TValueSet.SetFocus;
Begin
     Inherited SetFocus;
     Invalidate;
End;


Procedure TValueSet.KillFocus;
Begin
     Inherited KillFocus;
     Invalidate;
End;


Procedure TValueSet.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var  FSel:LongInt;
Begin
     Case KeyCode Of
        kbHome:
        Begin
             FSel := 0;
             SetSelection(FSel);
             ItemFocus(FSel);
             KeyCode := kbNull;
        End;
        kbEnd:
        Begin
             FSel := FCount-1;
             SetSelection(FSel);
             ItemFocus(FSel);
             KeyCode := kbNull;
        End;
        kbCLeft:
        Begin
             If FSelection >= 0 Then
             Begin
                  FSel := ((FSelection Div FColumns) * FColumns) +
                          ((FSelection + FColumns - 1) Mod FColumns);
             End
             Else FSel := 0;
             SetSelection(FSel);
             KeyCode := kbNull;
        End;
        kbCRight:
        Begin
             If FSelection >= 0 Then
             Begin
                  FSel := ((FSelection Div FColumns) * FColumns) +
                          ((FSelection + 1) Mod FColumns);
             End
             Else FSel := 0;
             SetSelection(FSel);
             KeyCode := kbNull;
        End;
        kbCUp:
        Begin
             If FSelection >= 0 Then
             Begin
                  FSel := ((FSelection - FColumns) + FCount) Mod FCount;
             End
             Else FSel := 0;
             SetSelection(FSel);
             KeyCode := kbNull;
        End;
        kbCDown:
        Begin
             If FSelection >= 0 Then
             Begin
                  FSel := (FSelection + FColumns) Mod FCount;
             End
             Else FSel := 0;
             SetSelection(FSel);
             KeyCode := kbNull;
        End;
        kbPageUp:
        Begin
             If FSelection >= 0 Then
             Begin
                  FSel := FSelection Mod FColumns;
             End
             Else FSel := 0;
             SetSelection(FSel);
             KeyCode := kbNull;
        End;
        kbPageDown:
        Begin
             If FSelection >= 0 Then
             Begin
                  FSel := ((FRows-1) * FColumns) + (FSelection Mod FColumns);
             End
             Else FSel := 0;
             SetSelection(FSel);
             KeyCode := kbNull;
        End;
        {$IFDEF OS2}
        kbEnter,
        {$ENDIF}
        kbCR:
        Begin
             If (FSelection >= 0) And (FSelection < FCount)
             Then ItemSelect(FSelection);
             KeyCode := kbNull;
        End;
        Else Inherited ScanEvent(KeyCode,RepeatCount);
     End; {Case}
End;


Procedure TValueSet.CharEvent(Var key:Char;RepeatCount:Byte);
Var  FSel:LongInt;
Begin
     Case key Of
       #32:
       Begin
            If FSelection >= 0 Then
            Begin
                 FSel := FSelection + 1;
                 If FSel >= FCount Then FSel := 0;
            End
            Else FSel := 0;
            SetSelection(FSel);
            key := #0;
       End;
       Else Inherited CharEvent(key,RepeatCount);
     End;
End;


Procedure TValueSet.SetColorArray(Index:LongInt;Const Data:Array Of TColor);
Var  T:LongInt;
     P:PValueSetArray;
     Col:TColor;
Begin
     If FContentStyle <> vscRGBColor Then Exit;
     If (Index < 0) Or (Index >= FCount) Then Exit;

     P := FMemory;
     For T := 0 To High(Data) Do
     Begin
          If Index + T >= FCount Then break;
          Col := Data[T];
          {$IFDEF Win95}
          If Col = $00CCCCCC Then Col := clLtGray;
          {$ENDIF}
          P^[Index + T] := Pointer(Col);
     End;

     If FUpdateCount = 0 Then Invalidate;
End;


Procedure TValueSet.SetBitmapArray(Index:LongInt;Const Data:Array Of TBitmap);
Var  T:LongInt;
     P:PValueSetArray;
     Bitmap:TBitmap;
     OldBitmap:TBitmap;
Begin
     If FContentStyle <> vscBitmap Then Exit;
     If (Index < 0) Or (Index >= FCount) Then Exit;

     P := FMemory;
     For T := 0 To High(Data) Do
     Begin
          If Index + T >= FCount Then break;
          OldBitmap := P^[Index + T];
          If OldBitmap <> Nil Then OldBitmap.Destroy; {Destroy old local Copy}
          Bitmap := Data[T];
          If Bitmap <> Nil Then Bitmap := Bitmap.Copy;
          P^[Index + T] := Pointer(Bitmap);
     End;

     If FUpdateCount = 0 Then Invalidate;
End;


Procedure TValueSet.SetStringArray(Index:LongInt;Const Data:Array Of String);
Var  T:LongInt;
     P:PValueSetArray;
     ps:PString;
Begin
     If FContentStyle <> vscText Then Exit;
     If (Index < 0) Or (Index >= FCount) Then Exit;

     P := FMemory;
     For T := 0 To High(Data) Do
     Begin
          If Index + T >= FCount Then break;
          ps := P^[Index + T];
          AssignStr(ps,Data[T]);
          P^[Index + T] := Pointer(ps);
     End;

     If FUpdateCount = 0 Then Invalidate;
End;


Function TValueSet.GetData(Index:LongInt):Pointer;
Var  P:PValueSetArray;
Begin
     Result := Nil;
     If FMemory = Nil Then Exit;
     If (Index < 0) Or (Index >= FCount) Then Exit;

     P := FMemory;
     Result := P^[Index];
End;


Procedure TValueSet.FreeData(Index:LongInt);
Var  P:PValueSetArray;
     Bitmap:TBitmap;
     ps:PString;
Begin
     If FMemory = Nil Then Exit;
     If (Index < 0) Or (Index >= FCount) Then Exit;

     P := FMemory;
     Case FContentStyle Of
       vscBitmap:
       Begin
            Bitmap := TBitmap(P^[Index]);
            If Bitmap <> Nil Then Bitmap.Destroy;
       End;
       vscText:
       Begin
            ps := P^[Index];
            DisposeStr(ps);
       End;
     End;
     P^[Index] := Nil;
End;


Procedure TValueSet.SetRGB(Index:LongInt;NewValue:TColor);
Begin
     SetColorArray(Index,[NewValue]);
End;


Function TValueSet.GetRGB(Index:LongInt):TColor;
Begin
     Result := 0;
     If FContentStyle <> vscRGBColor Then Exit;
     Result := TColor(GetData(Index));
End;


Procedure TValueSet.SetBitmap(Index:LongInt;NewValue:TBitmap);
Begin
     SetBitmapArray(Index,[NewValue]);
End;


Function TValueSet.GetBitmap(X,Y:LongInt):TBitmap;
Begin
     Result := Nil;
     If FContentStyle <> vscBitmap Then Exit;
     Result := TBitmap(GetData(Index));
End;


Procedure TValueSet.SetText(Index:LongInt;NewValue:String);
Begin
     SetStringArray(Index,[NewValue]);
End;


Function TValueSet.GetText(Index:LongInt):String;
Var  ps:PString;
Begin
     Result := '';
     If FContentStyle <> vscText Then Exit;
     ps := GetData(Index);
     If ps <> Nil Then Result := ps^;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMemo Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TMemoStrings=Class(TStrings)
      Private
         Memo:TMemo;
      Protected
         Function GetCount:LongInt; Override;
         Function Get(Index:LongInt):String; Override;
         Procedure Put(Index:LongInt;Const S:String); Override;
         Function GetText:PChar; Override;
         Procedure SetText(Text:PChar); Override;
         Procedure indexerror;
      Public
         Procedure Assign(AStrings:TStrings); Override;
         Procedure Clear; Override;
         Procedure Insert(Index:LongInt;Const S:String); Override;
         Procedure Delete(Index:LongInt); Override;
    End;



Function TMemoStrings.GetCount:LongInt;
{$IFDEF OS2}
Var  Start:IPT;
     len:LongInt;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result := WinSendMsg(Memo.Handle,MLM_QUERYLINECOUNT,0,0);

     Start := WinSendMsg(Memo.Handle,MLM_CHARFROMLINE,Result-1,0);
     len := WinSendMsg(Memo.Handle,MLM_QUERYLINELENGTH,Start,0);
     If len = 0 Then Dec(Result);
     {$ENDIF}
     {$IFDEF Win95}
     Result:=WinUser.SendMessage(Memo.Handle,EM_GETLINECOUNT,0,0);
     If WinUser.SendMessage(Memo.Handle,EM_LINELENGTH,
                            WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,Result-1,0),0)=0 Then
       Dec(Result);
     {$ENDIF}
End;


Function TMemoStrings.Get(Index:LongInt):String;
Var  cnt:LongInt;
     {$IFDEF OS2}
     Start:IPT;
     len,TotalLen:LongInt;
     pBuf:PChar;
     {$ENDIF}
     {$IFDEF WIN95}
     len,len1:LongInt;
     pBuf:CString;
     {$ENDIF}
Begin
     Result := '';
     cnt := Count;
     If (Index < 0) Or (Index >= cnt) Then indexerror;

     {$IFDEF OS2}
     WinSendMsg(Memo.Handle,MLM_FORMAT,MLFIE_NOTRANS,0);     {LF!}

     Start := WinSendMsg(Memo.Handle,MLM_CHARFROMLINE,Index,0);
     len := WinSendMsg(Memo.Handle,MLM_QUERYLINELENGTH,Start,0);
     If len = 0 Then Exit;

     GetMem(pBuf,len+1);
     WinSendMsg(Memo.Handle,MLM_SETIMPORTEXPORT,LongWord(pBuf),len+1);
     TotalLen := WinSendMsg(Memo.Handle,MLM_EXPORT,ULONG(@Start),ULONG(@len));
     Result := StrPas(pBuf);
     FreeMem(pBuf,len+1);

     If (WinSendMsg(Memo.Handle,MLM_QUERYLINECOUNT,0,0) <> cnt) Or
        (Index < cnt-1) Then SetLength(Result,TotalLen-1);  {del lf}
     {$ENDIF}
     {$IFDEF Win95}
     pBuf[0]:=#254;
     pBuf[1]:=#0;
     pBuf[WinUser.SendMessage(Memo.Handle,EM_GETLINE,Index,LongWord(@pBuf))]:=#0;
     Result:=pBuf;
     {$ENDIF}
End;


Procedure TMemoStrings.Put(Index:LongInt;Const S:String);
Var  cnt:LongInt;
     {$IFDEF OS2}
     Start:IPT;
     len:LongInt;
     CS:cstring;
     {$ENDIF}
     {$IFDEF WIN95}
     Start,Len:LongInt;
     CS:CString;
     {$ENDIF}
Begin
     cnt := Count;
     If (Index < 0) Or (Index >= cnt) Then indexerror;

     {$IFDEF OS2}
     CS := S;
     WinSendMsg(Memo.Handle,MLM_FORMAT,MLFIE_NOTRANS,0);     {LF!}

     Start := WinSendMsg(Memo.Handle,MLM_CHARFROMLINE,Index,0);
     len := WinSendMsg(Memo.Handle,MLM_QUERYLINELENGTH,Start,0);
     If len > 0 Then {Delete old String}
     Begin
          If Index < cnt-1 Then Dec(len); {Not the Line break}
          If len > 0 Then WinSendMsg(Memo.Handle,MLM_DELETE,Start,len);
     End;

     WinSendMsg(Memo.Handle,MLM_SETIMPORTEXPORT,LongWord(@CS),255);
     WinSendMsg(Memo.Handle,MLM_IMPORT,ULONG(@Start),Length(S));
     {$ENDIF}
     {$IFDEF Win95}
     Start:=WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,Index,0);
     Len:=WinUser.SendMessage(Memo.Handle,EM_LINELENGTH,Start,0);
     WinUser.SendMessage(Memo.Handle,EM_SETSEL,Start,Start+Len);
     CS:=S;
     WinUser.SendMessage(Memo.Handle,EM_REPLACESEL,0,LongWord(@CS));
     {$ENDIF}
     Memo.FModified := True;
End;


Procedure TMemoStrings.Assign(AStrings:TStrings);
{$IFDEF OS2}
Var  MemoVis:Boolean;
{$ENDIF}
Begin
     {$IFDEF OS2}
     MemoVis := Memo.Visible;
     If MemoVis Then WinSendMsg(Memo.Handle,MLM_DISABLEREFRESH,0,0);
     {$ENDIF}
     Inherited Assign(AStrings);
     {$IFDEF OS2}
     If MemoVis Then WinSendMsg(Memo.Handle,MLM_ENABLEREFRESH,0,0);
     {$ENDIF}
End;


Procedure TMemoStrings.Insert(Index:LongInt;Const S:String);
{$IFDEF OS2}
Var  Start:IPT;
     CS:cstring;
     len:LongInt;
     ACount:LongInt;
{$ENDIF}
{$IFDEF WIN32}
Var Start,Len:LongInt;
    c:CString;
    ACount:LongInt;
{$ENDIF}
Begin
     ACount:=Count;
     If (Index < 0) Or (Index > ACount) Then indexerror;

     {$IFDEF OS2}
     WinSendMsg(Memo.Handle,MLM_FORMAT,MLFIE_NOTRANS,0);     {LF!}

     If ((Index>0)And(Index=ACount)) Then Start:=-1
     Else Start := WinSendMsg(Memo.Handle,MLM_CHARFROMLINE,Index,0);
     If Start < 0 Then {Add}
     Begin
          Start := WinSendMsg(Memo.Handle,MLM_CHARFROMLINE,Index-1,0);
          If Start < 0 Then Exit;
          len := WinSendMsg(Memo.Handle,MLM_QUERYLINELENGTH,Start,0);
          If len = 0 Then Exit;
          Inc(Start,len);
          CS := #10 + S;
     End
     Else
     Begin
          If ((Start=0)And(ACount=0)) Then CS:=S
          Else CS := S + #10;
     End;

     WinSendMsg(Memo.Handle,MLM_SETIMPORTEXPORT,LongWord(@CS),255);
     WinSendMsg(Memo.Handle,MLM_IMPORT,ULONG(@Start),Length(CS));
     {$ENDIF}
     {$IFDEF Win95}
     Start:=WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,Index,0);
     If Start>=0 Then c:=s+#13#10
     Else
     Begin
          Start:=WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,Index-1,0);
          If Start<0 Then exit;
          Len:=WinUser.SendMessage(Memo.Handle,EM_LINELENGTH,Start,0);
          Start:=Start+Len;
          If Start>0 Then c:=#13#10+s
          Else c:=s+#13#10;
     End;
     WinUser.SendMessage(Memo.Handle,EM_SETSEL,Start,Start);
     WinUser.SendMessage(Memo.Handle,EM_REPLACESEL,0,LongWord(@c));
     {$ENDIF}
     Memo.FModified := True;
End;


Procedure TMemoStrings.Delete(Index:LongInt);
{$IFDEF OS2}
Var  Start:IPT;
     len:LongInt;
{$ENDIF}
{$IFDEF WIN95}
Var
   Start,SelEnd:LongInt;
{$ENDIF}
Begin
     If (Index < 0) Or (Index >= Count) Then indexerror;

     {$IFDEF OS2}
     WinSendMsg(Memo.Handle,MLM_FORMAT,MLFIE_NOTRANS,0);     {LF!}

     Start := WinSendMsg(Memo.Handle,MLM_CHARFROMLINE,Index,0);
     len := WinSendMsg(Memo.Handle,MLM_QUERYLINELENGTH,Start,0);
     If len > 0 Then WinSendMsg(Memo.Handle,MLM_DELETE,Start,len);
     {$ENDIF}
     {$IFDEF Win95}
     Start:=WinUser.SendMessage(Memo.Handle,EM_LINELENGTH,Index,0);
     SelEnd:=WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,Index+1,0);
     If SelEnd<0 Then
      SelEnd:=Start+WinUser.SendMessage(Memo.Handle,EM_LINELENGTH,Start,0);
     WinUser.SendMessage(Memo.Handle,EM_SETSEL,Start,SelEnd);
     WinUser.SendMessage(Memo.Handle,WM_CLEAR,0,0);
     {$ENDIF}
     Memo.FModified := True;
End;


Procedure TMemoStrings.Clear;
{$IFDEF OS2}
Var  Start:IPT;
     len,cnt:LongInt;
{$ENDIF}
{$IFDEF WIN95}
Var
   Start,Len:LongInt;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Start := 0;
     len := WinSendMsg(Memo.Handle,MLM_QUERYTEXTLENGTH,0,0);
     cnt := Count;
     If cnt > 0 Then Inc(len,cnt-1);   {Add the Line breaks}
     If len > 0 Then WinSendMsg(Memo.Handle,MLM_DELETE,Start,len);
     {$ENDIF}
     {$IFDEF Win95}
     {Start:=WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,0,0);
     Len:=WinUser.SendMessage(Memo.Handle,EM_LINEINDEX,Count-1,0);
     WinUser.SendMessage(Memo.Handle,EM_SETSEL,Start,Start+Len);
     WinUser.SendMessage(Memo.Handle,WM_CLEAR,0,0);}
     SetWindowText(Memo.Handle,'');
     {$ENDIF}
     Memo.FModified := True;
End;


Function TMemoStrings.GetText:PChar;
{$IFDEF OS2}
Var  Start:IPT;
     len,breaks:LongInt;
     TotalLen:LongInt;
{$ENDIF}
{$IFDEF WIN32}
Var Len:LongInt;
{$ENDIF}
Begin
     Result := NewStr('');
     {$IFDEF OS2}
     WinSendMsg(Memo.Handle,MLM_FORMAT,MLFIE_CFTEXT,0);     {CRLF!}

     len := WinSendMsg(Memo.Handle,MLM_QUERYTEXTLENGTH,0,0);
     breaks := WinSendMsg(Memo.Handle,MLM_QUERYLINECOUNT,0,0) - 1;
     TotalLen := len + breaks;
     If TotalLen <= 0 Then Exit;

     Start := 0;
     Result := StrAlloc(TotalLen+1);
     WinSendMsg(Memo.Handle,MLM_SETIMPORTEXPORT,LongWord(Result),TotalLen+1);
     WinSendMsg(Memo.Handle,MLM_EXPORT,ULONG(@Start),ULONG(@TotalLen));
     {$ENDIF}
     {$IFDEF Win95}
     Len:=WinUser.SendMessage(Memo.Handle,WM_GETTEXTLENGTH,0,0);
     Result:=StrAlloc(Len+1);
     WinUser.SendMessage(Memo.Handle,WM_GETTEXT,Len+1,LongWord(Result));
     {$ENDIF}
End;


Procedure TMemoStrings.SetText(Text:PChar);
{$IFDEF OS2}
Var  Start:IPT;
     len:LongInt;
{$ENDIF}
Begin
     Clear;
     If Text = Nil Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Memo.Handle,MLM_FORMAT,MLFIE_CFTEXT,0);     {CRLF!}

     Start := 0;
     len := StrLen(Text);
     WinSendMsg(Memo.Handle,MLM_SETIMPORTEXPORT,LongWord(Text),len+1);
     WinSendMsg(Memo.Handle,MLM_IMPORT,ULONG(@Start),len);
     {$ENDIF}
     {$IFDEF Win95}
     WinUser.SendMessage(Memo.Handle,WM_SETTEXT,0,LongWord(Text));
     {$ENDIF}
End;


Procedure TMemoStrings.indexerror;
Begin
     Raise EMemoIndexError.Create(LoadNLSStr(SInvalidMemoLineIndex));
End;


////////////////////////////////////////////////////////////////////////////

Procedure TMemo.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF OS2}
     ClassData.ClassULong := WC_MLE;
     {$ENDIF}
     {$IFDEF Win95}
     CreateSubClass(ClassData,'EDIT');
     {$ENDIF}
End;


Procedure TMemo.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'Memo';
     Height := 100;
     Width := 100;
     Ownerdraw := False;
     color := clEntryField;
     ParentPenColor := False;
     ParentColor := False;

     FLines := TMemoStrings.Create;
     TMemoStrings(FLines).Memo := Self;
     FInitLines.Create;
     FScrollBars := ssNone;
     FBorderStyle := bsSingle;
     FWordWrap := True;
     FReadOnly := False;
     FModified := False;
End;


Procedure TMemo.BeginUpdate;
Begin
     If FUpdateCount = 0 Then
     Begin
          If (Handle <> 0) And Visible Then
          Begin
               FEnableWindowUpdate := True;
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,False);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,0,0);
               {$ENDIF}
          End;
     End;
     Inc(FUpdateCount);
End;


Procedure TMemo.EndUpdate;
Begin
     If FUpdateCount=0 Then Exit;
     Dec(FUpdateCount);
     If FUpdateCount = 0 Then
     Begin
          If (Handle <> 0) And FEnableWindowUpdate Then
          Begin
               FEnableWindowUpdate := False;
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,True);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,1,0);
               {$ENDIF}
          End;
     End;
End;


Procedure TMemo.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     {$IFDEF OS2}
     Params.Style := Params.Style or MLS_LIMITVSCROLL;
     If FScrollBars In [ssHorizontal,ssBoth]
       Then Params.Style := Params.Style Or MLS_HSCROLL;
     If FScrollBars In [ssVertical,ssBoth]
       Then Params.Style := Params.Style Or MLS_VSCROLL;
     If FBorderStyle = bsSingle
       Then Params.Style := Params.Style Or MLS_BORDER;
     If FWordWrap Then Params.Style := Params.Style Or MLS_WORDWRAP;
     If FReadOnly Then Params.Style := Params.Style Or MLS_READONLY;
     If Not FWantTabs Then Params.Style := Params.Style Or MLS_IGNORETAB;
     {$ENDIF}
     {$IFDEF Win95}
     Params.Style := Params.Style Or ES_MULTILINE Or ES_LEFT Or
                                     ES_AUTOVSCROLL Or WS_CHILD;
     If FScrollBars In [ssHorizontal,ssBoth]
       Then Params.Style := Params.Style Or WS_HSCROLL;
     If FScrollBars In [ssVertical,ssBoth]
       Then Params.Style := Params.Style Or WS_VSCROLL;
     If FBorderStyle = bsSingle Then
     Begin
          Params.Style := Params.Style Or WS_BORDER;             {Single}
          Params.ExStyle := Params.ExStyle Or WS_EX_CLIENTEDGE;  {Double}
     End;
     If Not FWordWrap Then Params.Style := Params.Style Or ES_AUTOHSCROLL;
     {$ENDIF}
End;


Procedure TMemo.SetupShow;
Begin
     Inherited SetupShow;

     FLines.Assign(FInitLines);
     FInitLines.Clear;
End;


Procedure TMemo.DestroyWnd;
Begin
     If Handle <> 0 Then
       If FInitLines <> Nil Then FInitLines.Assign(FLines);

     Inherited DestroyWnd;
End;


Destructor TMemo.Destroy;
Begin
     FLines.Destroy;
     FLines := Nil;
     FInitLines.Destroy;
     FInitLines := Nil;

     Inherited Destroy;
End;


Procedure TMemo.Clear;
Begin
     Lines.Clear;
End;


Procedure TMemo.SelectAll;
{$IFDEF OS2}
Var  len:LongInt;
{$ENDIF}
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     len := WinSendMsg(Handle,MLM_QUERYTEXTLENGTH,0,0);
     WinSendMsg(Handle,MLM_SETSEL,0,len);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,EM_SETSEL,0,-1);
     {$ENDIF}
End;


Procedure TMemo.ClearSelection;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,MLM_CLEAR,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_CLEAR,0,0);
     {$ENDIF}
End;


Procedure TMemo.CutToClipBoard;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,MLM_CUT,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_CUT,0,0);
     {$ENDIF}
End;


Procedure TMemo.CopyToClipboard;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,MLM_COPY,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_COPY,0,0);
     {$ENDIF}
End;


Procedure TMemo.PasteFromClipBoard;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinSendMsg(Handle,MLM_PASTE,0,0);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_PASTE,0,0);
     {$ENDIF}
End;


Function TMemo.GetLines:TStrings;
Begin
     If Handle <> 0 Then Result := FLines
     Else Result := FInitLines;
End;


Procedure TMemo.SetLines(AStrings:TStrings);
Begin
     If AStrings <> Lines Then Lines.Assign(AStrings);
End;


Procedure TMemo.SetScrollBars(NewValue:TScrollStyle);
Begin
     If FScrollBars <> NewValue Then
     Begin
          FScrollBars := NewValue;
          RecreateWnd;
     End;
End;


Procedure TMemo.SetBorderStyle(NewBorder:TBorderStyle);
Begin
     If FBorderStyle <> NewBorder Then
     Begin
          FBorderStyle := NewBorder;
          RecreateWnd;
     End;
End;


Procedure TMemo.SetWordWrap(Value:Boolean);
Begin
     If FWordWrap <> Value Then
     Begin
          FWordWrap := Value;
          {$IFDEF OS2}
          If Handle <> 0 Then SendMsg(Handle,MLM_SETWRAP,Ord(Value),0);
          {$ENDIF}
          {$IFDEF Win95}
          RecreateWnd;
          {$ENDIF}
     End;
End;


Procedure TMemo.SetReadOnly(Value:Boolean);
Begin
     If FReadOnly <> Value Then
     Begin
          FReadOnly := Value;
          {$IFDEF OS2}
          If Handle <> 0 Then SendMsg(Handle,MLM_SETREADONLY,Ord(Value),0);
          {$ENDIF}
          {$IFDEF Win95}
          If Handle <> 0 Then SendMsg(Handle,EM_SETREADONLY,Ord(Value),0);
          {$ENDIF}
     End;
End;


Procedure TMemo.SetWantTabs(Value:Boolean);
Begin
     If FWantTabs <> Value Then
     Begin
          FWantTabs := Value;
          {$IFDEF OS2}
          RecreateWnd;
          {$ENDIF}
     End;
End;


{$IFDEF Win95}
Procedure TMemo.WMGetDlgCode(Var Msg:TMessage);
Begin
     If FWantTabs Then Msg.Result := Msg.Result Or DLGC_WANTTAB
     Else Msg.Result := Msg.Result And Not DLGC_WANTTAB;
     {If Not FWantReturns Then
     Message.Result := Message.Result And Not DLGC_WANTALLKEYS;}
End;
{$ENDIF}


Procedure TMemo.Resize;
Begin
     Inherited Resize;
     Invalidate;
End;


Procedure TMemo.changed;
Begin
     If OnChange <> Nil Then OnChange(Self);
End;


Procedure TMemo.ParentNotification(Var Msg:TMessage);
Begin
     Inherited ParentNotification(Msg);  {call DefaultHandler}

     {$IFDEF OS2}
     If Msg.Param1Hi = MLN_CHANGE Then
     {$ENDIF}
     {$IFDEF Win95}
     If Msg.Param1Hi = EN_CHANGE Then
     {$ENDIF}
     Begin
          FModified := True;
          changed;
          Msg.Handled := True;
     End;
End;

{$HINTS OFF}
Procedure TMemo.CharEvent(Var key:Char;RepeatCount:Byte);
Begin
End;


Procedure TMemo.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     // Always pass shift-Tab thru to TControl as focus change.
     // Pass Tab through as focus change, *unless*
     // it's an editable memo (FReadOnly not set)
     // AND WantTabs is set.
     // If it's editable and WantTabs is set then
     // the memo will allow tabs to be inserted in it's text.
     If     ( KeyCode = kbShiftTab )
         Or (     ( KeyCode = kbTab )
              And (    ( Not FWantTabs )
                    Or FReadOnly         ) ) Then
     Begin
          // Handle as focus change
          Inherited ScanEvent(KeyCode,RepeatCount);
          KeyCode := kbNull;
     End
     Else
     Begin
          // Pass to memo for insertion.
          LastMsg.CallDefaultHandler;
          KeyCode := kbNull;
     End;
End;
{$HINTS ON}


Function TMemo.WriteSCUResource(Stream:TResourceStream):Boolean;
Var  aText:PChar;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     aText := Lines.GetText;
     If aText <> Nil Then
     Begin
          Result := Stream.NewResourceEntry(rnLines,aText^,Length(aText^)+1);
          StrDispose(aText);
     End;
End;


Procedure TMemo.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var  aText:PChar;
Begin
     If ResName = rnLines Then
     Begin
          aText := @Data;
          Lines.SetText(aText);
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Begin
End.
