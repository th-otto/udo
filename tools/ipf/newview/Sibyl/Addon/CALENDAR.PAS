Unit Calendar;

Interface

Uses
  SysUtils, Classes, Forms, Grids;

{Declare new class}
Type
  TCalendar=Class(TGrid)
    Private
      FDate: TDateTime;
      FMonthOffset: Integer;
      FOnChange:TNotifyEvent;
    Private
      Function DayNum(Col,Row:LongInt):LongInt;
      Function DaysThisMonth:LongInt;
      Function GetYear:LongInt;
      Function GetMonth:LongInt;
      Function GetDay:LongInt;
      Procedure SetYear(NewValue:LongInt);
      Procedure SetMonth(NewValue:LongInt);
      Procedure SetDay(NewValue:LongInt);
      Function IsLeapYear:Boolean;
      Procedure UpdateCalendar;
      Procedure SetCalendarDate(NewValue:TDateTime);
    Protected
      Procedure SetupComponent; Override;
      Procedure Resize; Override;
      Procedure DrawCell(Col,Row:LONGINT;rec:TRect;AState:TGridDrawState); Override;
      Procedure Change;Virtual;
    Public
      Destructor Destroy; Override;
      Procedure NextYear;
      Procedure PrevYear;
      Procedure NextMonth;
      Procedure PrevMonth;
    Public
      Property Year:LongInt read GetYear write SetYear;
      Property Month:LongInt read GetMonth write SetMonth;
      Property Day:LongInt read GetDay write SetDay;
      Property CalendarDate:TDateTime read FDate write SetCalendarDate;
    Published
      Property OnChange:TNotifyEvent  read FOnChange write FOnChange;
      Property Align;
      Property Bottom;
      Property DragCursor;
      Property DragMode;
      Property Enabled;
      Property Font;
      Property Height;
      Property Left;
      Property ParentFont;
      Property ParentShowHint;
      Property PopupMenu;
      Property ShowHint;
      Property TabOrder;
      Property Visible;
      Property Width;
      Property ZOrder;

      Property OnCanDrag;
      Property OnCommand;
      Property OnDblClick;
      Property OnDragDrop;
      Property OnDragOver;
      Property OnEndDrag;
      Property OnEnter;
      Property OnExit;
      Property OnFontChange;
  End;

Implementation

Procedure TCalendar.Change;
Begin
  IF FOnChange<>Nil Then FOnChange(Self);
End;

Procedure TCalendar.SetCalendarDate(NewValue: TDateTime);
Begin
  FDate := NewValue;
  UpdateCalendar;
  Change;
End;

Function TCalendar.GetYear:LongInt;
Var AYear,AMonth,ADay:Word;
Begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  Result := AYear;
End;

Function TCalendar.GetMonth:LongInt;
Var AYear,AMonth,ADay:Word;
Begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  Result := AMonth;
End;

Function TCalendar.GetDay:LongInt;
Var AYear,AMonth,ADay:Word;
Begin
  DecodeDate(FDate, AYear, AMonth, ADay);
  Result := ADay;
End;

Procedure TCalendar.SetYear(NewValue:LongInt);
Var AYear,AMonth,ADay:Word;
Begin
  If NewValue<0 Then exit;
  DecodeDate(FDate, AYear, AMonth, ADay);
  AYear:=NewValue;
  FDate := EncodeDate(AYear, AMonth, ADay);
  UpdateCalendar;
  Change;
End;

Procedure TCalendar.SetMonth(NewValue:LongInt);
Var AYear,AMonth,ADay:Word;
Begin
  If NewValue<0 Then exit;
  DecodeDate(FDate, AYear, AMonth, ADay);
  AMonth:=NewValue;
  FDate := EncodeDate(AYear, AMonth, ADay);
  UpdateCalendar;
  Change;
End;

Procedure TCalendar.SetDay(NewValue:LongInt);
Var AYear,AMonth,ADay:Word;
Begin
  If NewValue<0 Then exit;
  DecodeDate(FDate, AYear, AMonth, ADay);
  ADay:=NewValue;
  FDate := EncodeDate(AYear, AMonth, ADay);
  UpdateCalendar;
  Change;
End;

Procedure TCalendar.UpdateCalendar;
Var AYear, AMonth, ADay: Word;
    ADate:TDateTime;
Begin
  If FDate <> 0 Then
  Begin
    DecodeDate(FDate,AYear,AMonth,ADay);
    ADate:=EncodeDate(AYear,AMonth,1);
    FMonthOffset:=2-DayOfWeek(ADate);
    Row:=(ADay-FMonthOffset) Div 7+1;
    Col:=(ADay-FMonthOffset) Mod 7;
  End;
  Refresh;
End;

Procedure TCalendar.SetupComponent;
Begin
  Inherited SetupComponent;
  Name:='Calendar';
  ColCount:=7;
  RowCount:=7;
  FixedCols:=0;
  FixedRows:=1;
  FDate:=Date;
  Options:=Options-[goMouseSelect]+[goAlwaysShowSelection];
  UpdateCalendar;
End;

Destructor TCalendar.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TCalendar.Resize;
Begin
  Inherited Resize;
  DefaultColWidth:=Width DIV 7;
  DefaultRowHeight:=Height DIV 7;
End;

Function TCalendar.DayNum(Col,Row:LongInt):LongInt;
Begin
  Result:=FMonthOffset+Col+(Row-1)*7;
  If (Result<1)Or(Result>DaysThisMonth) Then Result :=-1;
End;

Function TCalendar.DaysThisMonth:LongInt;
Const
  DaysPerMonth:Array[1..12] Of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
Begin
  If FDate = 0 Then Result:=0
  Else
  Begin
    Result := DaysPerMonth[Month];
    If ((Month=2)And(IsLeapYear)) Then inc(Result);
  End;
End;

Function TCalendar.IsLeapYear:Boolean;
Begin
  Result:=(Year mod 4=0)And((Year mod 100<>0)Or(Year mod 400=0));
End;

Procedure TCalendar.DrawCell(Col,Row:LONGINT;rec:TRect;AState:TGridDrawState);
Var OldClip,Exclude:TRect;
    X,Y,CX,CY:LongInt;
    Cap:String;
    Day:LongInt;
    Back,Fore:TColor;
Begin
  SetupCellColors(Col,Row,AState,Back,Fore);
  Canvas.Brush.Color:=Back;
  Canvas.Pen.Color:=Fore;

  If Row=0 Then Cap:=ShortDayNames[Col+1] //Fixed
  Else
  Begin
       Day:=DayNum(Col,Row);
       If Day>=0 Then Cap:=tostr(Day)
       Else Cap:='';
  End;

  X:=rec.Left+2;
  Y:=rec.Top-2-Canvas.Font.Height;
  Canvas.GetTextExtent(Cap,CX,CY);
  Canvas.TextOut(X,Y,Cap);

  OldClip:=Canvas.ClipRect;
  Exclude.Left:=X;
  Exclude.Right:=X+CX-1;
  Exclude.Bottom:=Y;
  Exclude.Top:=Y+CY-1;
  Canvas.ClipRect:=rec;
  Canvas.ExcludeClipRect(Exclude);
  Inherited DrawCell(Col,Row,rec,AState);
  Canvas.ClipRect:=OldClip;
End;

Procedure TCalendar.NextYear;
Begin
  Year:=Year+1;
End;

Procedure TCalendar.PrevYear;
Begin
  Year:=Year-1;
End;

Procedure TCalendar.NextMonth;
Begin
  If Month=12 Then
  Begin
     Month:=1;
     NextYear;
  End
  Else Month:=Month+1;
End;

Procedure TCalendar.PrevMonth;
Begin
  If Month=1 Then
  Begin
     Month:=12;
     PrevYear;
  End
  Else Month:=Month-1;
End;

Initialization
  {Register classes}
  RegisterClasses([TCalendar]);
End.

