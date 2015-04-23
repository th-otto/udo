//Chart Components for Sibyl (Normal and Database aware)
//for this version, the property editors are missing and will be added soon.
//For these components demos are also available (PIEDEMO.SPR and BARDEMO.SPR)
//(C) 1997 SpeedSoft
//Disclosure prohibited, Comments and suggestions welcome
//- mail to 100614.306@compuserve.com !


Unit Chart;

Interface

Uses
  SysUtils,Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons,
  DbBase;

Type
  TChart=Class;
  TChartSeries=Class;

  //Chart series values
  TChartValue=Class
      Private
            FValue:Extended;
            FSerie:TChartSeries;
            FOutlined:Boolean;
            FOutlineColor:TColor;
            FFillColor:TColor;
            FLabel:PString;
            FStartAngle,FSweepAngle:Extended;
            FEndPoint:TPoint;
            FProcessed:Boolean;
      Private
            Procedure SetOutlined(NewValue:Boolean);
            Procedure SetOutlineColor(NewValue:TColor);
            Procedure SetFillColor(NewValue:TColor);
            Function GetLabel:String;
            Procedure SetLabel(Const NewValue:String);
            Procedure SetValue(Const NewValue:Extended);
      Public
            Constructor Create(Serie:TChartSeries;Outlined:Boolean;
                               OutlineColor,FillColor:TColor;
                               Const aLabel:String;Value:Extended);Virtual;
            Destructor Destroy;Override;
      Public
            Property Outlined:Boolean read FOutlined write SetOutlined;
            Property OutlineColor:TColor read FOutlineColor write SetOutlineColor;
            Property FillColor:TColor read FFillColor write SetFillColor;
            Property ValueLabel:String read GetLabel write SetLabel;
            Property Value:Extended read FValue write SetValue;
            Property Serie:TChartSeries read FSerie;
  End;

  {$M+}
  TSeriesTitleAlignment=(staLeft,staCenter,staRight);
  TSeriesMarksStyle=(smsValue,smsPercent,smsLabel,smsLabelPercent,
                     smsLabelValue,smsLegend);
  {$M-}

  //Chart marks
  TSeriesMarks=Class
      Private
            FTransparent:Boolean;
            FArrowPen:TPenStyle;
            FArrowColor:TColor;
            FArrowLength:LongInt;
            FBackColor:TColor;
            FBorderColor:TColor;
            FBorderPen:TPenStyle;
            FFont:TFont;
            FStyle:TSeriesMarksStyle;
            FVisible:Boolean;
            FSerie:TChartSeries;
            FFormatStr:PChar;
            FMargin:LongInt;
      Private
            Procedure SetTransparent(NewValue:Boolean);
            Procedure SetArrowPen(NewValue:TPenStyle);
            Procedure SetArrowColor(NewValue:TColor);
            Procedure SetArrowLength(NewValue:LongInt);
            Procedure SetBackColor(NewValue:TColor);
            Procedure SetBorderColor(NewValue:TColor);
            Procedure SetBorderPen(NewValue:TPenStyle);
            Function GetFont:TFont;
            Procedure SetFont(NewValue:TFont);
            Procedure SetStyle(NewValue:TSeriesMarksStyle);
            Procedure SetVisible(NewValue:Boolean);
            Function GetFormatStr:String;
            Procedure SetFormatStr(Const NewValue:String);
            Procedure SetMargin(NewValue:LongInt);
      Public
            Constructor Create(Serie:TChartSeries);Virtual;
            Destructor Destroy;Override;
      Public
            Property Transparent:Boolean read FTransparent write SetTransparent;
            Property ArrowPen:TPenStyle read FArrowPen write SetArrowPen;
            Property ArrowColor:TColor read FArrowColor write SetArrowColor;
            Property ArrowLength:LongInt read FArrowLength write SetArrowLength;
            Property BackColor:TColor read FBackColor write SetBackColor;
            Property Style:TSeriesMarksStyle read FStyle write SetStyle;
            Property Font:TFont read GetFont write SetFont;
            Property BorderPen:TPenStyle read FBorderPen write SetBorderPen;
            Property BorderColor:TColor read FBorderColor write SetBorderColor;
            Property Visible:Boolean read FVisible write SetVisible;
            Property Serie:TChartSeries read FSerie;
            Property FormatStr:String read GetFormatStr write SetFormatStr;
            Property Margin:LongInt read FMargin write SetMargin;
  End;

  //Chart series
  TChartSeries=Class(TComponent)
      Private
            FChart:TChart;
            FValues:TList;
            FTitle:TStrings;
            FTitleVisible:Boolean;
            FTitleAlignment:TSeriesTitleAlignment;
            FActive:Boolean;
            FMarks:TSeriesMarks;
            FFont:TFont;
            FTitleColor:TColor;
            FDataLink:TTableDataLink;
            FLabelSource:PString;
            FValueSource:PString;
      Private
            Function GetValueCount:LongInt;
            Function GetChartValue(Index:LongInt):TChartValue;
            Procedure SetTitleAlignment(NewValue:TSeriesTitleAlignment);
            Procedure SetTitleVisible(NewValue:Boolean);
            Procedure SetTitle(NewValue:TStrings);
            Procedure SetActive(NewValue:Boolean);
            Function GetFont:TFont;
            Procedure SetFont(NewValue:TFont);
            Procedure SetTitleColor(NewValue:TColor);
            Procedure SetDataSource(NewValue:TDataSource);
            Function GetDataSource:TDataSource;
            Function GetLabelSource:String;
            Procedure SetLabelSource(Const NewValue:String);
            Function GetValueSource:String;
            Procedure SetValueSource(Const NewValue:String);
            Procedure SetDBValues(Update:Boolean);
      Protected
            Procedure DataChange(Sender:TObject;event:TDataChange);Virtual;
      Public
            Constructor Create(Chart:TChart;Title:TStrings;TitleVisible:Boolean;
                               TitleAlignment:TSeriesTitleAlignment);Virtual;
            Destructor Destroy;Override;
            Procedure AddValue(Const Value:Extended;Const aLabel:String;
                               Outlined:Boolean;OutlineColor,FillColor:TColor);
            Procedure AddAutoValue(Const Value:Extended;Const aLabel:String;
                                   Outlined:Boolean;OutlineColor:TColor);
            Procedure AddY(Const Value:Extended;Const aLabel:String;FillColor:TColor);
            Procedure RemoveValue(Index:LongInt);
            Procedure ClearValues;
      Public
            Property Active:Boolean read FActive write SetActive;
            Property ValueCount:LongInt read GetValueCount;
            Property Values[Index:LongInt]:TChartValue read GetChartValue;
            Property Chart:TChart read FChart;
            Property TitleAlignment:TSeriesTitleAlignment read FTitleAlignment write SetTitleAlignment;
            Property TitleVisible:Boolean read FTitleVisible write SetTitleVisible;
            Property Title:TStrings read FTitle write SetTitle;
            Property TitleColor:TColor read FTitleColor write SetTitleColor;
            Property Marks:TSeriesMarks read FMarks;
            Property Font:TFont read GetFont write SetFont;
            Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
            Property ValueSource:String read GetValueSource write SetValueSource;
            Property LabelSource:String read GetLabelSource write SetLabelSource;
  End;

  {$M+}
  TLegendAlignment=(laLeft,laRight,laTop,laBottom);
  TLegendTextStyle=(ltsPlain,ltsLeftValue,ltsRightValue,ltsLeftPercent,
                    ltsRightPercent);
  {$M-}

  //Chart legend
  TChartLegend=Class
      Private
            FChart:TChart;
            FAlignment:TLegendAlignment;
            FShadowColor:TColor;
            FShadowSize:Byte;
            FTextStyle:TLegendTextStyle;
            FFrameColor:TColor;
            FFrameStyle:TPenStyle;
            FVisible:Boolean;
            FMaxLines:Byte;
            FTopPosPercentage:Byte;
            FColorWidthPercentage:Byte;
            FXMargin:Byte;
            FYMargin:Byte;
            FFont:TFont;
            FFormatStr:PString;
            FBackColor:TColor;
      Private
            Procedure SetAlignment(NewValue:TLegendAlignment);
            Procedure SetShadowColor(NewValue:TColor);
            Procedure SetShadowSize(NewValue:Byte);
            Procedure SetTextStyle(NewValue:TLegendTextStyle);
            Procedure SetFrameColor(NewValue:TColor);
            Procedure SetFrameStyle(NewValue:TPenStyle);
            Procedure SetVisible(NewValue:Boolean);
            Procedure SetMaxLines(NewValue:Byte);
            Procedure SetTopPosPercentage(NewValue:Byte);
            Procedure SetColorWidthPercentage(NewValue:Byte);
            Procedure SetXMargin(NewValue:Byte);
            Procedure SetYMargin(NewValue:Byte);
            Function GetFont:TFont;
            Procedure SetFont(NewValue:TFont);
            Function GetFormatStr:String;
            Procedure SetFormatStr(Const NewValue:String);
            Procedure SetBackColor(NewValue:TColor);
      Public
            Constructor Create(Chart:TChart);Virtual;
            Destructor Destroy;Override;
      Public
            Property Chart:TChart read FChart;
            Property Alignment:TLegendAlignment read FAlignment write SetAlignment;
            Property ShadowColor:TColor read FShadowColor write SetShadowColor;
            Property ShadowSize:Byte read FShadowSize write SetShadowSize;
            Property TextStyle:TLegendTextStyle read FTextStyle write SetTextStyle;
            Property FrameColor:TColor read FFrameColor write SetFrameColor;
            Property FrameStyle:TPenStyle read FFrameStyle write SetFrameStyle;
            Property Visible:Boolean read FVisible write SetVisible;
            Property MaxLines:Byte read FMaxLines write SetMaxLines;
            Property TopPosPercentage:Byte read FTopPosPercentage write SetTopPosPercentage;
            Property ColorWidthPercentage:Byte read FColorWidthPercentage write SetColorWidthPercentage;
            Property XMargin:Byte read FXMargin write SetXMargin;
            Property YMargin:Byte read FYMargin write SetYMargin;
            Property Font:TFont read GetFont write SetFont;
            Property FormatStr:String read GetFormatStr write SetFormatStr;
            Property BackColor:TColor read FBackColor write SetBackColor;
  End;

  {$M+}
  TGradientStyle=(grsNone,grsLeftRight,grsRightLeft,grsBottomTop,grsTopBottom);
  {$M-}

  //Abtract chart base class
  TChart=Class(TPanel)
      Private
            FSeries:TList;
            FView3D:Boolean;
            FPercent3D:Byte;
            FUpdateCount:LongInt;
            FMarginLeft,FMarginRight,FMarginBottom,FMarginTop:Byte;
            FGradientStyle:TGradientStyle;
            FGradientStart:TColor;
            FGradientEnd:TColor;
            FLegend:TChartLegend;
            FDesignSerie:TChartSeries;
      Private
            Procedure SetView3D(NewValue:Boolean);
            Procedure SetPercent3D(NewValue:Byte);
            Function GetSeriesCount:LongInt;
            Function GetChartSerie(Index:LongInt):TChartSeries;
            Procedure SetMarginLeft(NewValue:Byte);
            Procedure SetMarginRight(NewValue:Byte);
            Procedure SetMarginBottom(NewValue:Byte);
            Procedure SetMarginTop(NewValue:Byte);
            Procedure SetGradientStyle(NewValue:TGradientStyle);
            Procedure SetGradientStart(NewValue:TColor);
            Procedure SetGradientEnd(NewValue:TColor);
            Procedure CreateDesignSerie;
            Procedure DrawGradient(rc:TRect;HColor,LColor:TColor;Style:TGradientStyle);
      Protected
            Function GetChartStrDim(v:TChartValue;Var CX,CY:LongInt):String;Virtual;
            Procedure InvalidateGraph;Virtual;
            Procedure DrawLegend(Serie:TChartSeries;Var ClientRect:TRect);Virtual;
            Function  GetLegendExtent(Serie:TChartSeries;Var CX,CY,ColorWidth:LongInt;
                                      Width,Height:LongInt):LongInt;Virtual;
      Public
            Procedure SetupComponent;Override;
            Destructor Destroy;Override;
            Procedure AddSerie(Title:String;TitleVisible:Boolean;
                               TitleAlignment:TSeriesTitleAlignment);
            Procedure BeginUpdate;
            Procedure EndUpdate;
            Function DrawChartFrame:TRect;
      Public
            Property SeriesCount:LongInt read GetSeriesCount;
            Property Series[Index:LongInt]:TChartSeries read GetChartSerie;
            Property Legend:TChartLegend read FLegend;
      Published
            Property View3D:Boolean read FView3D write SetView3D;
            Property Percent3D:Byte read FPercent3D write SetPercent3D;
            Property MarginLeft:Byte read FMarginLeft write SetMarginLeft;
            Property MarginRight:Byte read FMarginRight write SetMarginRight;
            Property MarginBottom:Byte read FMarginBottom write SetMarginBottom;
            Property MarginTop:Byte read FMarginTop write SetMarginTop;
            Property GradientStyle:TGradientStyle read FGradientStyle write SetGradientStyle;
            Property GradientStart:TColor read FGradientStart write SetGradientStart;
            Property GradientEnd:TColor read FGradientEnd write SetGradientEnd;
  End;

  //Pie Chart
  TPieChart=Class(TChart)
      Private
           FRotation:Word;
           FCircled:Boolean;
      Private
           Procedure SetRotation(NewValue:Word);
           Procedure SetCircled(NewValue:Boolean);
           Procedure CalcMarksRect(Serie:TChartSeries;Var PieRect:TRect);
           Procedure DrawMarks(s:TChartSeries;PieRect:TRect;
                               PieBottom,CenterX,CenterY,RadiusX,RadiusY:LongInt;
                               ChartRect:TRect;HandleClip:Boolean);
      Protected
           Procedure InvalidateGraph;Override;
      Public
           Procedure SetupComponent;Override;
           Procedure Redraw(Const rec:TRect);Override;
      Published
           Property Rotation:Word read FRotation write SetRotation;
           Property Circled:Boolean read FCircled write SetCircled;
  End;

  TDBPieChart=Class(TPieChart)
      Private
           Procedure SetDataSource(NewValue:TDataSource);
           Function GetDataSource:TDataSource;
           Function GetLabelSource:String;
           Procedure SetLabelSource(Const NewValue:String);
           Function GetValueSource:String;
           Procedure SetValueSource(Const NewValue:String);
      Public
           Procedure Redraw(Const rec:TRect);Override;
      Published
           Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
           Property ValueSource:String read GetValueSource write SetValueSource;
           Property LabelSource:String read GetLabelSource write SetLabelSource;
  End;

  TBarChartStyle=(bcsRectangle,bcsRectGradient);

  TBarChart=Class(TChart)
     Private
           FPercentBarWidth:Byte;
           FPercentBarOffset:Integer;
           FPointsPerPage:LongWord;
           FLeftWallVisible:Boolean;
           FLeftWallColor:TColor;
           FBottomWallVisible:Boolean;
           FBottomWallColor:TColor;
           FBackWallVisible:Boolean;
           FBackWallColor:TColor;
           FSeparationPercent:Byte;
           FVAxisGrid:Boolean;
           FHAxisGrid:Boolean;
           FAxisFormatStr:PString;
           FVAxisVisible:Boolean;
           FHAxisVisible:Boolean;
           FVAxisTicksLen:Byte;
           FHAxisTicksLen:Byte;
           FStyle:TBarChartStyle;
     Private
           Procedure SetPercentBarWidth(NewValue:Byte);
           Procedure SetPercentBarOffset(NewValue:Integer);
           Procedure SetPointsPerPage(NewValue:LongWord);
           Procedure SetLeftWallVisible(NewValue:Boolean);
           Procedure SetLeftWallColor(NewValue:TColor);
           Procedure SetBottomWallVisible(NewValue:Boolean);
           Procedure SetBottomWallColor(NewValue:TColor);
           Procedure SetBackWallVisible(NewValue:Boolean);
           Procedure SetBackWallColor(NewValue:TColor);
           Procedure SetSeparationPercent(NewValue:Byte);
           Procedure SetVAxisGrid(NewValue:Boolean);
           Procedure SetHAxisGrid(NewValue:Boolean);
           Function GetAxisFormatStr:String;
           Procedure SetAxisFormatStr(Const NewValue:String);
           Procedure SetVAxisVisible(NewValue:Boolean);
           Procedure SetHAxisVisible(NewValue:Boolean);
           Procedure SetVAxisTicksLen(NewValue:Byte);
           Procedure SetHAxisTicksLen(NewValue:Byte);
           Procedure SetStyle(NewValue:TBarChartStyle);
     Protected
           Procedure InvalidateGraph;Override;
     Public
           Procedure SetupComponent;Override;
           Destructor Destroy;Override;
           Procedure Redraw(Const rec:TRect);Override;
     Published
           Property PercentBarWidth:Byte read FPercentBarWidth write SetPercentBarWidth;
           Property PercentBarOffset:Integer read FPercentBarOffset write SetPercentBarOffset;
           Property PointsPerPage:LongWord read FPointsPerPage write SetPointsPerPage;
           Property LeftWallVisible:Boolean read FLeftWallVisible write SetLeftWallVisible;
           Property LeftWallColor:TColor read FLeftWallColor write SetLeftWallColor;
           Property BottomWallVisible:Boolean read FBottomWallVisible write SetBottomWallVisible;
           Property BottomWallColor:TColor read FBottomWallColor write SetBottomWallColor;
           Property BackWallVisible:Boolean read FBackWallVisible write SetBackWallVisible;
           Property BackWallColor:TColor read FBackWallColor write SetBackWallColor;
           Property SeparationPercent:Byte read FSeparationPercent write SetSeparationPercent;
           Property VAxisGrid:Boolean read FVAxisGrid write SetVAxisGrid;
           Property HAxisGrid:Boolean read FHAxisGrid write SetHAxisGrid;
           Property AxisFormatStr:String read GetAxisFormatStr write SetAxisFormatStr;
           Property VAxisVisible:Boolean read FVAxisVisible write SetVAxisVisible;
           Property HAxisVisible:Boolean read FHAxisVisible write SetHAxisVisible;
           Property VAxisTicksLen:Byte read FVAxisTicksLen write SetVAxisTicksLen;
           Property HAxisTicksLen:Byte read FHAxisTicksLen write SetHAxisTicksLen;
           Property Style:TBarChartStyle read FStyle write SetStyle;
  End;

  TDBBarChart=Class(TBarChart)
     Private
              Procedure SetDataSource(NewValue:TDataSource);
              Function GetDataSource:TDataSource;
              Function GetLabelSource:String;
              Procedure SetLabelSource(Const NewValue:String);
              Function GetValueSource:String;
              Procedure SetValueSource(Const NewValue:String);
         Public
              Procedure Redraw(Const rec:TRect);Override;
         Published
              Property DataSource:TDataSource Read GetDataSource Write SetDataSource;
              Property ValueSource:String read GetValueSource write SetValueSource;
              Property LabelSource:String read GetLabelSource write SetLabelSource;
  End;

Implementation

{$IFDEF OS2}
Uses PmWin,PmGpi;
{$ENDIF}
{$IFDEF WIN32}
Uses WinUser,WinGDI;
{$ENDIF}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TChartValue Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TChartValue.SetOutlined(NewValue:Boolean);
Begin
    If FOutlined=NewValue Then exit;
    FOutlined:=NewValue;
    If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TChartValue.SetOutlineColor(NewValue:TColor);
Begin
   If FOutlineColor=NewValue Then exit;
   FOutlineColor:=NewValue;
   If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TChartValue.SetFillColor(NewValue:TColor);
Begin
   If FFillColor=NewValue Then exit;
   FFillColor:=NewValue;
   If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Function TChartValue.GetLabel:String;
Begin
   If FLabel<>Nil Then Result:=FLabel^
   Else Result:='';
End;

Procedure TChartValue.SetLabel(Const NewValue:String);
Begin
   If FLabel<>Nil Then
   Begin
        If FLabel^=NewValue Then exit;
        FreeMem(FLabel,length(FLabel^)+1);
   End;
   GetMem(FLabel,length(NewValue)+1);
   FLabel^:=NewValue;
   If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TChartValue.SetValue(Const NewValue:Extended);
Begin
   If FValue=NewValue Then exit;
   FValue:=NewValue;
   If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Constructor TChartValue.Create(Serie:TChartSeries;Outlined:Boolean;
                               OutlineColor,FillColor:TColor;
                               Const aLabel:String;Value:Extended);
Begin
     Inherited Create;

     FSerie:=Serie;
     FOutlined:=Outlined;
     FOutlineColor:=OutlineColor;
     FFillColor:=FillColor;
     GetMem(FLabel,length(aLabel)+1);
     FLabel^:=aLabel;
     FValue:=Value;
End;

Destructor TChartValue.Destroy;
Begin
     FSerie.FValues.Remove(Self);
     If FLabel<>Nil Then FreeMem(FLabel,length(FLabel^)+1);
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;

     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TSeriesMarks Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSeriesMarks.SetTransparent(NewValue:Boolean);
Begin
     If NewValue=FTransparent Then exit;
     FTransparent:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetArrowPen(NewValue:TPenStyle);
Begin
     If NewValue=FArrowPen Then exit;
     FArrowPen:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetArrowColor(NewValue:TColor);
Begin
     If NewValue=FArrowColor Then exit;
     FArrowColor:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetArrowLength(NewValue:LongInt);
Begin
     If NewValue=FArrowLength Then exit;
     FArrowLength:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetBackColor(NewValue:TColor);
Begin
     If NewValue=FBackColor Then exit;
     FBackColor:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetBorderColor(NewValue:TColor);
Begin
     If NewValue=FBorderColor Then exit;
     FBorderColor:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetBorderPen(NewValue:TPenStyle);
Begin
     If NewValue=FBorderPen Then exit;
     FBorderPen:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetFont(NewValue:TFont);
Begin
     If FFont=NewValue Then exit;
     FFont:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Function TSeriesMarks.GetFont:TFont;
Begin
     If FFont=Nil Then Result:=FSerie.FChart.Font
     Else Result:=FFont;
End;


Procedure TSeriesMarks.SetStyle(NewValue:TSeriesMarksStyle);
Begin
     If FStyle=NewValue Then exit;
     FStyle:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetVisible(NewValue:Boolean);
Begin
     If FVisible=NewValue Then exit;
     FVisible:=NewValue;
     If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Constructor TSeriesMarks.Create(Serie:TChartSeries);
Begin
     Inherited Create;

     FSerie:=Serie;
     FVisible:=True;
     FTransparent:=False;
     FArrowPen:=psSolid;
     FArrowLength:=5;
     FArrowColor:=clBlack;
     FBackColor:=clInfo;
     FBorderPen:=psSolid;
     FStyle:=smsLabelValue;
     FMargin:=10;
End;

Destructor TSeriesMarks.Destroy;
Begin
    If FFormatStr<>Nil Then FreeMem(FFormatStr,length(FFormatStr^)+1);
    Inherited Destroy;
End;

Function TSeriesMarks.GetFormatStr:String;
Begin
    If FFormatStr<>Nil Then Result:=FFormatStr^
    Else Result:='';
End;

Procedure TSeriesMarks.SetFormatStr(Const NewValue:String);
Begin
    If FFormatStr<>Nil Then
    Begin
         If FFormatStr^=NewValue Then exit;
         FreeMem(FFormatStr,length(FFormatStr^)+1);
    End;
    GetMem(FFormatStr,length(NewValue)+1);
    FFormatStr^:=NewValue;
    If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

Procedure TSeriesMarks.SetMargin(NewValue:LongInt);
Begin
    If NewValue=FMargin Then exit;
    FMargin:=NewValue;
    If FSerie.FChart.FUpdateCount=0 Then FSerie.FChart.Invalidate;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TChartSeries Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TChartSeries.Create(Chart:TChart;Title:TStrings;TitleVisible:Boolean;
                                TitleAlignment:TSeriesTitleAlignment);
Begin
     Inherited Create(Nil);

     FChart:=Chart;
     FValues.Create;
     FMarks.Create(Self);
     FTitle:=TStringList.Create;
     FTitle.Assign(Title);
     FTitleVisible:=TitleVisible;
     FTitleColor:=clBlack;
     FDataLink.Create(Self);
     FDataLink.OnDataChange:=DataChange;
     Include(FDataLink.ComponentState, csDetail);
End;

Destructor TChartSeries.Destroy;
Var
    l:LongInt;
Begin
     FDataLink.OnDataChange:=Nil;
     FDataLink.Destroy;
     FDataLink:=Nil;
     If FLabelSource<>Nil Then FreeMem(FLabelSource,length(FLabelSource^)+1);
     FLabelSource:=Nil;
     If FValueSource<>Nil Then FreeMem(FValueSource,length(FValueSource^)+1);
     FValueSource:=Nil;

     FTitle.Destroy;
     FTitle:=Nil;
     If Self<>FChart.FDesignSerie Then FChart.FSeries.Remove(Self);

     l:=FChart.FUpdateCount;
     ClearValues;
     FValues.Destroy;
     FValues:=Nil;
     FMarks.Destroy;
     FMarks:=Nil;
     FChart.FUpdateCount:=l;

     Inherited Destroy;
End;

Procedure TChartSeries.RemoveValue(Index:LongInt);
Var v:TChartValue;
    l:LongInt;
Begin
     l:=FChart.FUpdateCount;
     FChart.FUpdateCount:=1;
     v:=FValues[Index];
     v.Destroy;
     FChart.FUpdateCount:=l;
     If FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Procedure TChartSeries.ClearValues;
Var l,t:LongInt;
    v:TChartValue;
Begin
     l:=FChart.FUpdateCount;
     FChart.FUpdateCount:=1;
     For t:=FValues.Count-1 Downto 0 Do
     Begin
          v:=FValues[t];
          v.Destroy;
     End;
     FChart.FUpdateCount:=l;
     If FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Procedure TChartSeries.SetDBValues(Update:Boolean);
Var DataSet:TDataSet;
    t:LongInt;
    v:TChartValue;
    Value:Extended;
    ValueLabel:String;
    Field:TField;
    SaveCurrentRow,SaveCurrentField:LongInt;
Begin
     If FDataLink=Nil Then exit;

     If ((not Update)Or(FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)Or
         (FDataLink.DataSource.DataSet.Active=False)Or(ValueSource='')) Then
     Begin
          inc(FChart.FUpdateCount);
          For t:=FValues.Count-1 Downto 0 Do
          Begin
              v:=FValues[t];
              v.Destroy;
          End;
          FValues.Destroy;
          FValues.Create;
          If Designed Then If ((FDataLink.DataSource=Nil)Or
                               (FDataLink.DataSource.DataSet=Nil)Or
                               (FDataLink.DataSource.DataSet.Active=False)Or
                               (ValueSource='')) Then
          Begin
               AddValue(20,'cars',True,clBlack,clRed);
               AddValue(50,'bikes',True,clBlack,clGreen);
               AddValue(40,'food',True,clBlack,clBlue);
               AddValue(10,'guns',True,clBlack,clYellow);
               AddValue(20,'shirts',True,clBlack,clAqua);
          End;
          dec(FChart.FUpdateCount);
     End;

     If ((FDataLink.DataSource=Nil)Or(FDataLink.DataSource.DataSet=Nil)Or
         (FDataLink.DataSource.DataSet.Active=False)Or(ValueSource='')) Then exit;

     DataSet:=FDataLink.DataSource.DataSet;

     SaveCurrentRow:=DataSet.CurrentRow;
     SaveCurrentField:=DataSet.CurrentField;

     DataSet.First;
     While not DataSet.EOF Do
     Begin
          Field:=DataSet.FieldByName(ValueSource);
          Value:=Field.AsFloat;
          If LabelSource='' Then ValueLabel:=''
          Else
          Begin
               Field:=DataSet.FieldByName(LabelSource);
               ValueLabel:=Field.AsString;
          End;

          If ((not Update)Or(DataSet.CurrentRow>FValues.Count-1)Or
              (FValues.Count=0)) Then AddAutoValue(Value,ValueLabel,True,clBlack)
          Else
          Begin
               v:=FValues[DataSet.CurrentRow];
               v.Value:=Value;
               v.ValueLabel:=ValueLabel;
          End;

          DataSet.Next;
     End;

     If SaveCurrentRow>=0 Then DataSet.CurrentRow:=SaveCurrentRow;
     If SaveCurrentField>=0 Then DataSet.CurrentField:=SaveCurrentField;
End;

Procedure TChartSeries.SetDataSource(NewValue:TDataSource);
Begin
     If FDataLink.DataSource=NewValue Then exit;
     FDataLink.DataSource:=NewValue;
     SetDBValues(False);
     If FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Function TChartSeries.GetDataSource:TDataSource;
Begin
     Result:=FDataLink.DataSource;
End;

Function TChartSeries.GetLabelSource:String;
Begin
     If FLabelSource<>Nil Then Result:=FLabelSource^
     Else Result:='';
End;

Procedure TChartSeries.SetLabelSource(Const NewValue:String);
Begin
     If FLabelSource<>Nil Then
     Begin
          If FLabelSource^=NewValue Then exit;
          FreeMem(FLabelSource,length(FLabelSource^)+1);
     End;
     GetMem(FLabelSource,length(NewValue)+1);
     FLabelSource^:=NewValue;
     If ((FDataLink.DataSource<>Nil)And(FDataLink.DataSource.DataSet<>Nil)) Then
       SetDBValues(False);
     If FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Function TChartSeries.GetValueSource:String;
Begin
     If FValueSource<>Nil Then Result:=FValueSource^
     Else Result:='';
End;

Procedure TChartSeries.SetValueSource(Const NewValue:String);
Begin
     If FValueSource<>Nil Then
     Begin
          If FValueSource^=NewValue Then exit;
          FreeMem(FValueSource,length(FValueSource^)+1);
     End;
     GetMem(FValueSource,length(NewValue)+1);
     FValueSource^:=NewValue;
     If ((FDataLink.DataSource<>Nil)And(FDataLink.DataSource.DataSet<>Nil)) Then
       SetDBValues(False);
     If FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Procedure TChartSeries.DataChange(Sender:TObject;Event:TDataChange);
Begin
     If Event=dePositionChanged Then exit;
     SetDBValues(True);
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;
{$HINTS ON}

Procedure TChartSeries.SetTitleColor(NewValue:TColor);
Begin
     If NewValue=FTitleColor Then exit;
     FTitleColor:=NewValue;
     IF FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Procedure TChartSeries.SetFont(NewValue:TFont);
Begin
     If FFont=NewValue Then exit;
     FFont:=NewValue;
     IF FChart.FUpdateCount=0 THEN FChart.Invalidate;
End;

Function TChartSeries.GetFont:TFont;
Begin
     If FFont=Nil Then Result:=FChart.Font
     Else Result:=FFont;
End;

Procedure TChartSeries.SetActive(NewValue:Boolean);
Var t:LongInt;
    s:TChartSeries;
Begin
     If FActive=NewValue Then exit;
     FActive:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartSeries.SetTitleAlignment(NewValue:TSeriesTitleAlignment);
Begin
     If NewValue=FTitleAlignment Then exit;
     FTitleAlignment:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartSeries.SetTitleVisible(NewValue:Boolean);
Begin
     If NewValue=FTitleVisible Then exit;
     FTitleVisible:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartSeries.SetTitle(NewValue:TStrings);
Begin
     If NewValue.Equals(FTitle) Then exit;
     FTitle.Assign(NewValue);
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartSeries.AddY(Const Value:Extended;Const aLabel:String;FillColor:TColor);
Begin
     AddValue(Value,aLabel,True,clBlack,FillColor);
End;

Procedure TChartSeries.AddValue(Const Value:Extended;Const aLabel:String;
                                Outlined:Boolean;OutlineColor,FillColor:TColor);
Var v:TChartValue;
Begin
     v.Create(Self,Outlined,OutlineColor,FillColor,aLabel,Value);
     FValues.Add(v);
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Const AutoColors:Array[0..14] Of TColor=
            (
             clRed,clGreen,clNavy,clYellow,
             clBlue,clFuchsia,clLime,clAqua,
             clMaroon,clDkGray,clPurple,clTeal,
             clSilver,clOlive,clWhite
            );

Procedure TChartSeries.AddAutoValue(Const Value:Extended;Const aLabel:String;
                                    Outlined:Boolean;OutlineColor:TColor);
Var FillColor:TColor;
Begin
     If FValues.Count<15 Then FillColor:=AutoColors[FValues.Count]
     Else
     Begin //Randomize Color Value
          Randomize;
          FillColor:=ValuesToRGB(Random(256),Random(256),Random(256));
     End;
     AddValue(Value,aLabel,Outlined,OutlineColor,FillColor);
End;


Function TChartSeries.GetValueCount:LongInt;
Begin
     Result:=FValues.Count;
End;

Function TChartSeries.GetChartValue(Index:LongInt):TChartValue;
Begin
     Result:=FValues[Index];
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TChartLegend Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TChartLegend.SetAlignment(NewValue:TLegendAlignment);
Begin
     If FAlignment=NewValue Then exit;
     FAlignment:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetShadowColor(NewValue:TColor);
Begin
     If FShadowColor=NewValue Then exit;
     FShadowColor:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetShadowSize(NewValue:Byte);
Begin
     If FShadowSize=NewValue Then exit;
     FShadowSize:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetBackColor(NewValue:TColor);
Begin
     If FBackColor=NewValue Then exit;
     FBackColor:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetTextStyle(NewValue:TLegendTextStyle);
Begin
     If FTextStyle=NewValue Then exit;
     FTextStyle:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetFrameColor(NewValue:TColor);
Begin
     If FFrameColor=NewValue Then exit;
     FFrameColor:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetFrameStyle(NewValue:TPenStyle);
Begin
     If FFrameStyle=NewValue Then exit;
     FFrameStyle:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetVisible(NewValue:Boolean);
Begin
     If FVisible=NewValue Then exit;
     FVisible:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetMaxLines(NewValue:Byte);
Begin
     If FMaxLines=NewValue Then exit;
     FMaxLines:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetTopPosPercentage(NewValue:Byte);
Begin
     If FTopPosPercentage=NewValue Then exit;
     FTopPosPercentage:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetColorWidthPercentage(NewValue:Byte);
Begin
     If FColorWidthPercentage=NewValue Then exit;
     FColorWidthPercentage:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetXMargin(NewValue:Byte);
Begin
     If FXMargin=NewValue Then exit;
     FXMargin:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetYMargin(NewValue:Byte);
Begin
     If FYMargin=NewValue Then exit;
     FYMargin:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Procedure TChartLegend.SetFont(NewValue:TFont);
Begin
     If FFont=NewValue Then exit;
     FFont:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Function TChartLegend.GetFont:TFont;
Begin
     If FFont=Nil Then Result:=FChart.Font
     Else Result:=FFont;
End;

Function TChartLegend.GetFormatStr:String;
Begin
     If FFormatStr<>Nil Then Result:=FFormatStr^
     Else Result:='';
End;

Procedure TChartLegend.SetFormatStr(Const NewValue:String);
Begin
     If FFormatStr<>Nil Then
     Begin
          If FFormatStr^=NewValue Then exit;
          FreeMem(FFormatStr,length(FFormatStr^)+1);
     End;
     GetMem(FFormatStr,length(NewValue)+1);
     FFormatStr^:=NewValue;
     If FChart.FUpdateCount=0 Then FChart.Invalidate;
End;

Constructor TChartLegend.Create(Chart:TChart);
Begin
     Inherited Create;

     FChart:=Chart;
     FAlignment:=laLeft;
     FShadowColor:=clBlack;
     FShadowSize:=2;
     FTextStyle:=ltsPlain;
     FFrameColor:=clBlack;
     FFrameStyle:=psSolid;
     FVisible:=True;
     FMaxLines:=255;
     FTopPosPercentage:=50;
     FColorWidthPercentage:=20;
     FXMargin:=5;
     FYMargin:=2;
     FBackColor:=clWhite;
End;

Destructor TChartLegend.Destroy;
Begin
    If FFormatStr<>Nil Then FreeMem(FFormatStr,length(FFormatStr^)+1);
    Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TChart Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TChart.SetupComponent;
Begin
     Inherited SetupComponent;

     FSeries.Create;
     Width:=310;
     Height:=240;
     FView3D:=True;
     FPercent3D:=15;
     Name:='Chart';
     FMarginLeft:=3;
     FMarginRight:=3;
     FMarginBottom:=3;
     FMarginTop:=3;
     FGradientStyle:=grsNone;
     FGradientStart:=clYellow;
     FGradientEnd:=clWhite;
     FLegend.Create(Self);
End;

Function TChart.DrawChartFrame:TRect;
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
     If BevelInner = bvRaised Then
     Begin
          InnerRaisedColor := clBtnHighlight;
          InnerLoweredColor := clBtnShadow;
     End
     Else
     Begin
          InnerRaisedColor := clBtnShadow;
          InnerLoweredColor := clBtnHighlight;
     End;

     If BevelOuter = bvRaised Then
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
     DrawSystemBorder(Self,rc1,BorderStyle);

     If BevelOuter <> bvNone Then If BevelWidth > 0 Then
     Begin
          DrawFrame(rc1,BevelWidth,OuterRaisedColor,OuterLoweredColor);
          Forms.InflateRect(rc1,-BevelWidth,-BevelWidth);
     End;

     If BorderWidth > 0 Then
     Begin
          DrawFrame(rc1,BorderWidth,color,color);
          Forms.InflateRect(rc1,-BorderWidth,-BorderWidth);
     End;

     If BevelInner <> bvNone Then If BevelWidth > 0 Then
     Begin
          DrawFrame(rc1,BevelWidth,InnerRaisedColor,InnerLoweredColor);
          Forms.InflateRect(rc1,-BevelWidth,-BevelWidth);
     End;

     result := rc1;
End;


Destructor TChart.Destroy;
Var t:LongInt;
    s:TChartSeries;
Begin
     FUpdateCount:=1;
     For t:=FSeries.Count-1 Downto 0 Do
     Begin
          s:=FSeries[t];
          s.Destroy;
     End;
     FSeries.Destroy;
     FLegend.Destroy;
     If FDesignSerie<>Nil Then FDesignSerie.Destroy;

     Inherited Destroy;
End;

Procedure TChart.AddSerie(Title:String;TitleVisible:Boolean;
                          TitleAlignment:TSeriesTitleAlignment);
Var s:TChartSeries;
    ts:TStringList;
Begin
     If FDesignSerie<>Nil Then
     Begin
         FDesignSerie.Destroy;
         FDesignSerie:=Nil;
     End;
     ts.Create;
     ts.Text:=Title;
     s.Create(Self,ts,TitleVisible,TitleAlignment);
     ts.Destroy;
     FSeries.Add(s);
     s.Active:=True;
End;

Procedure TChart.CreateDesignSerie;
Var ts:TStringList;
    DBSerie,DBValues:Boolean;
    DataSource:TDataSource;
Begin
     If FSeries.Count>0 Then DataSource:=TChartSeries(FSeries[0]).DataSource
     Else DataSource:=Nil;
     DBSerie:=Self Is TDBPieChart;
     DBSerie:=DBSerie Or (Self Is TDBBarChart);

     If DBSerie Then
     Begin
          DBValues:=((DataSource=Nil)Or(TDBPieChart(Self).ValueSource='')Or
                     (DataSource.DataSet=Nil)Or(DataSource.DataSet.Active=False));
     End
     Else DBValues:=True;

     DBValues:=DBValues And Designed;

     If DBSerie Then
     Begin
          If FSeries.Count>0 Then If FDesignSerie=Nil Then FDesignSerie:=FSeries[0];

          If FDesignSerie<>Nil Then
          Begin
              If FDesignSerie.ValueCount=0 Then
              Begin
                   If DBValues Then
                   Begin
                        FDesignSerie.AddValue(20,'cars',True,clBlack,clRed);
                        FDesignSerie.AddValue(50,'bikes',True,clBlack,clGreen);
                        FDesignSerie.AddValue(40,'food',True,clBlack,clBlue);
                        FDesignSerie.AddValue(10,'guns',True,clBlack,clYellow);
                        FDesignSerie.AddValue(20,'shirts',True,clBlack,clAqua);
                   End;
              End;
              //Else If not DBValues Then FDesignSerie.ClearValues;
              If FSeries.Count=0 Then FSeries.Add(FDesignSerie);
              FDesignSerie:=Nil;
          End;
          If FSeries.Count>0 Then exit;
     End
     Else If not Designed Then exit;

     If FDesignSerie<>Nil Then exit;
     ts.Create;
     If DBSerie Then
     Begin
          If Designed Then ts.Add('Serie')
          Else ts.Add('');
     End
     Else ts.Add('Serie');
     FDesignSerie.Create(Self,ts,True,staCenter);
     If DBSerie Then FSeries.Add(FDesignSerie);
     ts.Destroy;

     If DBValues Then
     Begin
        FDesignSerie.AddValue(20,'cars',True,clBlack,clRed);
        FDesignSerie.AddValue(50,'bikes',True,clBlack,clGreen);
        FDesignSerie.AddValue(40,'food',True,clBlack,clBlue);
        FDesignSerie.AddValue(10,'guns',True,clBlack,clYellow);
        FDesignSerie.AddValue(20,'shirts',True,clBlack,clAqua);
     End;

     FDesignSerie.Active:=True;
     If DBSerie Then FDesignSerie:=Nil;
End;

Function TChart.GetSeriesCount:LongInt;
Begin
     Result:=FSeries.Count;
End;

Function TChart.GetChartSerie(Index:LongInt):TChartSeries;
Begin
     Result:=FSeries[Index];
End;

Procedure TChart.SetView3D(NewValue:Boolean);
Begin
     If NewValue=FView3D Then exit;
     FView3D:=NewValue;
     Invalidate;
End;

Procedure TChart.SetPercent3D(NewValue:Byte);
Begin
     If NewValue=FPercent3D Then exit;
     If NewValue>100 Then NewValue:=100;
     FPercent3D:=NewValue;
     InvalidateGraph;
End;

Procedure TChart.InvalidateGraph;
Begin
     Invalidate;
End;

Procedure TChart.DrawGradient(rc:TRect;HColor,LColor:TColor;Style:TGradientStyle);
Var
   DRed,DGreen,DBlue,DR,DG,DB:Extended;
   StartLoop,EndLoop:LongInt;
   rec:TRect;
   H,W:LongInt;
Begin
     H:=rc.Top-rc.Bottom;
     W:=rc.Right-rc.Left;
     DRed:=TRGB(LColor).Red;
     DGreen:=TRGB(LColor).Green;
     DBlue:=TRGB(LColor).Blue;
     DR:=TRGB(HColor).Red-DRed;
     DG:=TRGB(HColor).Green-DGreen;
     DB:=TRGB(HColor).Blue-DBlue;

     Case Style Of
        grsBottomTop,grsTopBottom:
        Begin
             DR:=DR / H;
             DG:=DG / H;
             DB:=DB / H;
        End
        Else
        Begin
             DR:=DR / W;
             DG:=DG / W;
             DB:=DB / W;
        End;
     End; //case

     If Style=grsBottomTop Then
     Begin
          StartLoop:=rc.Bottom;
          EndLoop:=rc.Bottom+(rc.Top-rc.Bottom);
     End
     Else If Style=grsTopBottom Then
     Begin
          StartLoop:=rc.Bottom+(rc.Top-rc.Bottom);
          EndLoop:=rc.Bottom;
     End
     Else If Style=grsLeftRight Then
     Begin
          StartLoop:=rc.Left;
          EndLoop:=rc.Left+(rc.Right-rc.Left);
     End
     Else
     Begin
          StartLoop:=rc.Left+(rc.Right-rc.Left);
          EndLoop:=rc.Left;
     End;

     While StartLoop<>EndLoop Do
     Begin
          If Style In [grsBottomTop,grsTopBottom] Then
          Begin
               rec.Left:=rc.Left;
               rec.Right:=rc.Right;
               rec.Bottom:=StartLoop;
               rec.Top:=rec.Bottom+3;
               If Style=grsTopBottom Then
               Begin
                    If rec.Top<EndLoop Then exit;
               End
               Else If rec.Bottom>EndLoop Then exit;

               If rec.Top>rc.Top Then rec.Top:=rc.Top;
               If rec.Bottom<rc.Bottom Then rec.Bottom:=rc.Bottom;
          End
          Else
          Begin
               rec.Left:=StartLoop;
               rec.Right:=rec.Left+8;
               rec.Bottom:=rc.Bottom;
               rec.Top:=rc.Top;
               If Style=grsRightLeft Then
               Begin
                    If rec.Right<EndLoop Then exit;
               End
               Else If rec.Left>EndLoop Then exit;

               If rec.Right>rc.Right Then rec.Right:=rc.Right;
               If rec.Left<rc.Left Then rec.Left:=rc.Left;
          End;
          Canvas.FillRect(rec,ValuesToRGB(Round(DRed),Round(DGreen),Round(DBlue)));

          DRed:=DRed+DR*3;
          If DRed>255 Then DRed:=255;
          DGreen:=DGreen+DG*3;
          If DGreen>255 Then DGreen:=255;
          DBlue:=DBlue+DB*3;
          If DBlue>255 Then DBlue:=255;

          If Style In [grsBottomTop,grsLeftRight] Then
          Begin
               inc(StartLoop,3);
               If Style=grsLeftRight Then
               Begin
                    inc(StartLoop,5);
                    DRed:=DRed+DR*5;
                    If DRed>255 Then DRed:=255;
                    DGreen:=DGreen+DG*5;
                    If DGreen>255 Then DGreen:=255;
                    DBlue:=DBlue+DB*5;
                    If DBlue>255 Then DBlue:=255;
               End;
          End
          Else
          Begin
               dec(StartLoop,3);
               If Style=grsRightLeft Then
               Begin
                    dec(StartLoop,5);
                    DRed:=DRed+DR*5;
                    If DRed>255 Then DRed:=255;
                    DGreen:=DGreen+DG*5;
                    If DGreen>255 Then DGreen:=255;
                    DBlue:=DBlue+DB*5;
                    If DBlue>255 Then DBlue:=255;
               End;
          End;
     End; //While
End;

Procedure TChart.SetMarginLeft(NewValue:Byte);
Begin
     If NewValue=FMarginLeft Then exit;
     If NewValue>100 Then NewValue:=100;
     FMarginLeft:=NewValue;
     If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.SetMarginRight(NewValue:Byte);
Begin
     If NewValue=FMarginRight Then exit;
     If NewValue>100 Then NewValue:=100;
     FMarginRight:=NewValue;
     If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.SetMarginBottom(NewValue:Byte);
Begin
     If NewValue=FMarginBottom Then exit;
     If NewValue>100 Then NewValue:=100;
     FMarginBottom:=NewValue;
     If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.SetMarginTop(NewValue:Byte);
Begin
     If NewValue=FMarginTop Then exit;
     If NewValue>100 Then NewValue:=100;
     FMarginTop:=NewValue;
     If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.SetGradientStyle(NewValue:TGradientStyle);
Begin
    If NewValue=FGradientStyle Then exit;
    FGradientStyle:=NewValue;
    If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.SetGradientStart(NewValue:TColor);
Begin
    If NewValue=FGradientStart Then exit;
    FGradientStart:=NewValue;
    If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.SetGradientEnd(NewValue:TColor);
Begin
    If NewValue=FGradientEnd Then exit;
    FGradientEnd:=NewValue;
    If FUpdateCount=0 Then Invalidate;
End;

Procedure TChart.BeginUpdate;
Begin
     If FUpdateCount = 0 Then
     Begin
          If Handle <> 0 Then
          Begin
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


Procedure TChart.EndUpdate;
Begin
     If FUpdateCount=0 Then Exit;
     Dec(FUpdateCount);
     If FUpdateCount = 0 Then
     Begin
          If Handle <> 0 Then
          Begin
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,True);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,1,0);
               {$ENDIF}
          End;
          Invalidate;
     End;
End;

Function TChart.GetChartStrDim(v:TChartValue;Var CX,CY:LongInt):String;
Var
    SaveFont:TFont;
Begin
     CX:=0;
     CY:=0;
     If v.Serie.Marks.Visible Then
     Begin
          Case v.Serie.Marks.Style Of
            smsValue:Result:=FormatFloat(v.Serie.Marks.FormatStr,v.Value);
            smsPercent:Result:=FormatFloat(v.Serie.Marks.FormatStr,v.FSweepAngle*100/360)+'%';
            smsLabel:Result:=v.ValueLabel;
            smsLabelPercent:Result:=v.ValueLabel+' '+
                               FormatFloat(v.Serie.Marks.FormatStr,v.FSweepAngle*100/360)+'%';
            smsLabelValue:Result:=v.ValueLabel+' '+
                             FormatFloat(v.Serie.Marks.FormatStr,v.Value);
            smsLegend:Result:=v.ValueLabel; //???
          End;

          SaveFont:=Canvas.Font;
          Canvas.Font:=v.Serie.Marks.Font;
          Canvas.GetTextExtent(Result,CX,CY);
          Canvas.Font:=SaveFont;
          inc(CX,2); //Border
          inc(CY,2); //Border
     End;
End;

Function TChart.GetLegendExtent(Serie:TChartSeries;
                                Var CX,CY,ColorWidth:LongInt;
                                Width,Height:LongInt):LongInt;
Var t:LongInt;
    v:TChartValue;
    SaveFont:TFont;
    s:String;
    CX1,CY1:LongInt;
    Lines:Byte;
    X,Y:LongInt;
Begin
     SaveFont:=Canvas.Font;
     Canvas.Font:=Legend.Font;

     //Lngsten String ermitteln
     CX:=0;
     CY:=0;
     If Serie<>Nil Then For t:=0 To Serie.FValues.Count-1 Do
     Begin
          v:=Serie.FValues[t];

          Case Legend.TextStyle Of
            ltsPlain:s:=v.ValueLabel;
            ltsLeftValue:s:=FormatFloat(Legend.FormatStr,v.Value)+' '+v.ValueLabel;
            ltsRightValue:s:=v.ValueLabel+' '+FormatFloat(Legend.FormatStr,v.Value);
            ltsLeftPercent:s:=FormatFloat(Legend.FormatStr,v.FSweepAngle*100/360)+'%'+
                          ' '+v.ValueLabel;
            ltsRightPercent:s:=v.ValueLabel+' '+
                               FormatFloat(Legend.FormatStr,v.FSweepAngle*100/360)+'%';
          End; //case

          Canvas.GetTextExtent(s,CX1,CY1);
          If CX1>CX Then CX:=CX1;
     End;

     CX:=CX+3;

     ColorWidth:=(CX*Legend.ColorWidthPercentage) Div 100;

     //CY ermitteln
     Lines:=0;
     If Legend.Alignment In [laLeft,laRight] Then
     Begin
          Y:=Height;
          CY:=0;
          Result:=CX;
     End
     Else
     Begin
          Y:=Height Div 2; //maximal die Hlfte fr horz Legende
          CY:=CY1+Legend.YMargin;
          Result:=0;
     End;

     X:=0;

     If Serie<>Nil Then For t:=0 To Serie.FValues.Count-1 Do
     Begin
          v:=Serie.FValues[t];

          Case Legend.TextStyle Of
            ltsPlain:s:=v.ValueLabel;
            ltsLeftValue:s:=FormatFloat(Legend.FormatStr,v.Value)+' '+v.ValueLabel;
            ltsRightValue:s:=v.ValueLabel+' '+FormatFloat(Legend.FormatStr,v.Value);
            ltsLeftPercent:s:=FormatFloat(Legend.FormatStr,v.FSweepAngle*100/360)+'%'+
                          ' '+v.ValueLabel;
            ltsRightPercent:s:=v.ValueLabel+' '+
                               FormatFloat(Legend.FormatStr,v.FSweepAngle*100/360)+'%';
          End; //case

          Canvas.GetTextExtent(s,CX1,CY1);

          Case Legend.Alignment Of
             laLeft,laRight:
             Begin
                  If Y-CY1-Legend.YMargin<0 Then break;
                  dec(Y,CY1+Legend.YMargin);
                  inc(CY,CY1+Legend.YMargin);
                  inc(Lines);
                  If Y<0 Then break;
                  If Lines>Legend.MaxLines Then break;
             End;
             Else
             Begin
                  If X+CX+ColorWidth+6+Legend.XMargin>Width Then
                  Begin
                       dec(X,ColorWidth+6+Legend.XMargin);
                       If X>Result Then Result:=X;
                       inc(Lines);
                       dec(Y,CY1+Legend.YMargin);
                       inc(CY,CY1+Legend.YMargin);
                       If Y<0 Then break;
                       If Lines>Legend.MaxLines Then break;
                       X:=0;
                  End;

                  inc(X,CX+ColorWidth+6+Legend.XMargin);
             End;
          End; //case
     End;

     If Legend.Alignment In [laBottom,laTop] Then
     Begin
          If X>Result Then Result:=X;
          Inc(Result,2);
     End;

     Canvas.Font:=SaveFont;
End;

Procedure TChart.DrawLegend(Serie:TChartSeries;Var ClientRect:TRect);
Var CX,CY,CX1,CY1,ColorWidth:LongInt;
    rc,rc1:TRect;
    SaveFont:TFont;
    X,Y:LongInt;
    Lines:Byte;
    t:LongInt;
    v:TChartValue;
    s:String;
    SaveColor:TColor;
    W:LongInt;

    Procedure DrawLegendLabel(X,Y:LongInt;Const s:String);
    Var rc1:TRect;
        SaveColor:TColor;
    Begin
         SaveColor:=Canvas.Pen.Color;
         Canvas.Pen.Color:=v.FillColor;
         rc1.Left:=X+2;
         rc1.Right:=rc1.Left+ColorWidth;
         rc1.Bottom:=Y+2;
         rc1.Top:=Y+CY1-4;
         Forms.InflateRect(rc1,-1,-1);
         Canvas.Box(rc1);
         Canvas.Pen.Color:=SaveColor;
         Forms.InflateRect(rc1,1,1);
         Canvas.Rectangle(rc1);

         Canvas.Pen.Color:=Legend.BackColor;

         rc1.Left:=X;
         rc1.Right:=rc1.Left+1;
         rc1.Bottom:=Y;
         rc1.Top:=rc1.Bottom+CY1-1;
         Canvas.Box(rc1);

         rc1.Left:=rc1.Right;
         rc1.Right:=rc1.Left+ColorWidth+1;
         rc1.Top:=rc1.Bottom+1;
         Canvas.Box(rc1);

         rc1.Bottom:=Y+CY1-3;
         rc1.Top:=rc1.Bottom+2;
         Canvas.Box(rc1);

         rc1.Left:=X+3+ColorWidth;
         rc1.Right:=rc1.Left+3;
         rc1.Bottom:=Y;
         rc1.Top:=rc1.Bottom+CY1-1;
         Canvas.Box(rc1);

         rc1.Left:=X+3+ColorWidth+4+CX1;
         rc1.Right:=rc.Right-1;
         Canvas.Box(rc1);

         rc1.Left:=X;
         rc1.Right:=rc.Right-1;
         rc1.Bottom:=Y-Legend.YMargin;
         If rc1.Bottom<rc.Bottom+1 Then rc1.Bottom:=rc.Bottom+1;
         rc1.Top:=Y-1;
         Canvas.Box(rc1);

         Canvas.Pen.Color:=SaveColor;

         inc(X,3+ColorWidth+4);
         Canvas.TextOut(X,Y,s);
    End;

Begin
     If ((not Legend.Visible)Or(Legend.MaxLines=0)) Then exit;

     W:=GetLegendExtent(Serie,CX,CY,ColorWidth,ClientRect.Right-ClientRect.Left,
                        ClientRect.Top-ClientRect.Bottom);

     If CY=0 Then exit;

     Case Legend.Alignment Of
         laLeft:
         Begin
              rc.Left:=ClientRect.Left;
              rc.Bottom:=ClientRect.Bottom+0+Legend.ShadowSize; //50%
              rc.Right:=rc.Left+CX+ColorWidth+2+6;
              rc.Top:=rc.Bottom+CY+2;
              inc(ClientRect.Left,CX+ColorWidth+2+6+Legend.ShadowSize);
         End;
         laRight:
         Begin
              rc.Left:=ClientRect.Right-CX-ColorWidth-2-2-6;
              rc.Bottom:=ClientRect.Bottom+0+Legend.ShadowSize; //50%
              rc.Right:=ClientRect.Right-2;
              rc.Top:=rc.Bottom+CY+2;
              dec(ClientRect.Right,CX+ColorWidth+2+6+Legend.ShadowSize);
         End;
         laTop:
         Begin
              rc.Left:=ClientRect.Left+((ClientRect.Right-ClientRect.Left-W) Div 2);
              rc.Right:=rc.Left+W;
              rc.Bottom:=ClientRect.Top-CY-2;
              rc.Top:=ClientRect.Top;
              dec(ClientRect.Top,CY+2+Legend.ShadowSize);
         End;
         laBottom:
         Begin
              rc.Left:=ClientRect.Left+((ClientRect.Right-ClientRect.Left-W) Div 2);
              rc.Right:=rc.Left+W;
              rc.Bottom:=ClientRect.Bottom+Legend.ShadowSize+2;
              rc.Top:=rc.Bottom+CY+2;
              inc(ClientRect.Bottom,CY+2+Legend.ShadowSize);
         End;
     End; //case

     Canvas.Pen.Color:=Legend.FrameColor;
     Canvas.Brush.Color:=Legend.BackColor;
     SaveFont:=Canvas.Font;
     Canvas.Font:=Legend.Font;

     Canvas.Rectangle(rc);
     X:=rc.Left+1;
     Y:=rc.Top;
     CY1:=0;
     Lines:=0;
     If Serie<>Nil Then For t:=0 To Serie.FValues.Count-1 Do
     Begin
          v:=Serie.FValues[t];

          Case Legend.TextStyle Of
            ltsPlain:s:=v.ValueLabel;
            ltsLeftValue:s:=FormatFloat(Legend.FormatStr,v.Value)+' '+v.ValueLabel;
            ltsRightValue:s:=v.ValueLabel+' '+FormatFloat(Legend.FormatStr,v.Value);
            ltsLeftPercent:s:=FormatFloat(Legend.FormatStr,v.FSweepAngle*100/360)+'%'+
                          ' '+v.ValueLabel;
            ltsRightPercent:s:=v.ValueLabel+' '+
                               FormatFloat(Legend.FormatStr,v.FSweepAngle*100/360)+'%';
          End; //case

          Canvas.GetTextExtent(s,CX1,CY1);

          Case Legend.Alignment Of
             laLeft,laRight:
             Begin
                  If Y-CY1-Legend.YMargin<rc.Bottom Then break;

                  DrawLegendLabel(X,Y-CY1,s);

                  dec(Y,CY1+Legend.YMargin);
                  inc(CY,CY1+Legend.YMargin);
                  inc(Lines);
                  If Y<rc.Bottom Then break;
                  If Lines>Legend.MaxLines Then break;
             End;
             Else
             Begin
                  If X+CX+ColorWidth+6+Legend.XMargin>rc.Right Then
                  Begin
                       inc(Lines);
                       dec(Y,CY1+Legend.YMargin);
                       If Y<rc.Bottom Then
                       Begin
                            inc(Y,CY1);
                            break;
                       End;
                       If Lines>Legend.MaxLines Then break;
                       X:=rc.Left+1;
                  End;

                  DrawLegendLabel(X,Y-CY1,s);

                  SaveColor:=Canvas.Pen.Color;
                  Canvas.Pen.Color:=Legend.BackColor;
                  rc1.Left:=X+CX+ColorWidth+6;
                  rc1.Right:=rc1.Left+Legend.XMargin;
                  If rc1.Right>rc.Right-1 Then rc1.Right:=rc.Right-1;
                  rc1.Bottom:=Y-CY1;
                  If rc1.Bottom<rc.Bottom+1 Then rc1.Bottom:=rc.Bottom+1;
                  rc1.Top:=Y-1;
                  Canvas.Box(rc1);
                  Canvas.Pen.Color:=SaveColor;

                  inc(X,CX+ColorWidth+6+Legend.XMargin);
             End;
          End; //case
     End;

     If Legend.Alignment In [laBottom,laTop] Then dec(Y,CY1+Legend.YMargin);
     SaveColor:=Canvas.Pen.Color;
     Canvas.Pen.Color:=Legend.BackColor;
     rc1.Left:=rc.Left+1;
     rc1.Right:=rc.Right-1;
     rc1.Bottom:=rc.Bottom+1;
     rc1.Top:=Y-1;
     If rc1.Top>=rc1.Bottom Then Canvas.Box(rc1);

     If Legend.ShadowSize>0 Then
     Begin
          rc1.Left:=rc.Right;
          rc1.Right:=rc1.Left+Legend.ShadowSize;
          rc1.Bottom:=rc.Bottom-Legend.ShadowSize;
          rc1.Top:=rc.Top-Legend.ShadowSize;

          Canvas.Pen.Color:=Legend.ShadowColor;
          Canvas.Box(rc1);

          Canvas.BeginPath;
          Canvas.Rectangle(rc1);
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);

          rc1.Left:=rc.Left+Legend.ShadowSize;
          rc1.Right:=rc.Right;
          rc1.Bottom:=rc.Bottom-Legend.ShadowSize;
          rc1.Top:=rc.Bottom;
          Canvas.Box(rc1);

          Canvas.BeginPath;
          Canvas.Rectangle(rc1);
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);
     End;

     Canvas.Pen.Color:=SaveColor;


     Canvas.BeginPath;
     Canvas.Rectangle(rc);
     Canvas.EndPath;
     Canvas.PathToClipRegion(paDiff);

     Canvas.Font:=SaveFont;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPieChart Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPieChart.CalcMarksRect(Serie:TChartSeries;Var PieRect:TRect);
Var t:LongInt;
    v:TChartValue;
    MiddleAngle:Extended;
    s:String;
    CX,CY:LongInt;
    MaxX,MaxY:LongInt;
Begin
    MaxX:=0;
    MaxY:=0;
    For t:=0 To Serie.ValueCount-1 Do
    Begin
         v:=Serie.FValues[t];

         GetChartStrDim(v,CX,CY);
         If CX>MaxX Then MaxX:=CX;
         If CY>MaxY Then MaxY:=CY;
    End;

    //Margins
    inc(MaxX,Serie.Marks.Margin);
    inc(MaxY,Serie.Marks.Margin);

    inc(PieRect.Left,MaxX);
    dec(PieRect.Right,MaxX);
    inc(PieRect.Bottom,MaxY);
    dec(PieRect.Top,MaxY);
End;

Procedure TPieChart.DrawMarks(s:TChartSeries;PieRect:TRect;
                              PieBottom,CenterX,CenterY,RadiusX,RadiusY:LongInt;
                              ChartRect:TRect;HandleClip:Boolean);
Var t:LongInt;
    v:TChartValue;
    MiddleAngle:Extended;
    pt,TangentPoint:TPoint;
    Margin:LongInt;
    rc:TRect;
    PieHeight:LongInt;
    Correct:Extended;
    CX,CY:LongInt;
    ss:String;
    SaveFont:TFont;
    SaveColor:TColor;
Begin
    SetTrigMode(Deg);

    PieHeight:=Round(((PieRect.Top-PieRect.Bottom)*FPercent3d)/100);

    For t:=0 To s.FValues.Count-1 Do
    Begin
         v:=s.FValues[t];
         MiddleAngle:=v.FStartAngle+v.FSweepAngle/2;
         If MiddleAngle>360 Then MiddleAngle:=MiddleAngle-360;

         Canvas.Pen.Color:=s.Marks.ArrowColor;

         Canvas.Arc(CenterX,CenterY,RadiusX,RadiusY,MiddleAngle,0);
         TangentPoint:=Canvas.PenPos;

         //eine Strecke in Richtung Mittelpunkt mit Marks.ArrowLength
         If not HandleClip Then
         Begin
             Margin:=s.Marks.ArrowLength;
             If ((MiddleAngle>=0)And(MiddleAngle<=90)) Then //Quadrant 1
             Begin
                  If MiddleAngle<=45 Then
                  Begin
                     pt.X:=TangentPoint.X-Margin;
                     If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                     Else pt.Y:=TangentPoint.Y-(Margin/cot(MiddleAngle));
                  End
                  Else
                  Begin
                     pt.Y:=TangentPoint.Y-Margin;
                     If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                     Else pt.X:=TangentPoint.X-(Margin/tan(MiddleAngle));
                  End;
             End
             Else If ((MiddleAngle>90)And(MiddleAngle<=180)) Then //Quadrant 2
             Begin
                  MiddleAngle:=90-(MiddleAngle-90);
                  If MiddleAngle<=45 Then
                  Begin
                      pt.X:=TangentPoint.X+Margin;
                      If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                      Else pt.Y:=TangentPoint.Y-(Margin/cot(MiddleAngle));
                  End
                  Else
                  Begin
                      pt.Y:=TangentPoint.Y-Margin;
                      If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                      Else pt.X:=TangentPoint.X+(Margin/tan(MiddleAngle));
                  End;
             End
             Else If ((MiddleAngle>180)And(MiddleAngle<=270)) Then //Quadrant 3
             Begin
                  MiddleAngle:=MiddleAngle-180;
                  If MiddleAngle<=45 Then
                  Begin
                      pt.X:=TangentPoint.X+Margin;
                      If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                      Else pt.Y:=TangentPoint.Y+(Margin/cot(MiddleAngle));
                  End
                  Else
                  Begin
                      pt.Y:=TangentPoint.Y+Margin;
                      If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                      Else pt.X:=TangentPoint.X+(Margin/tan(MiddleAngle));
                  End;
             End
             Else //Quadrant 4
             Begin
                  MiddleAngle:=90-(MiddleAngle-270);
                  If MiddleAngle<=45 Then
                  Begin
                       pt.X:=TangentPoint.X-Margin;
                       If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                       Else pt.Y:=TangentPoint.Y+(Margin/cot(MiddleAngle));
                  End
                  Else
                  Begin
                       pt.Y:=TangentPoint.Y+Margin;
                       If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                       Else pt.X:=TangentPoint.X-(Margin/tan(MiddleAngle));
                  End;
             End;

             Canvas.LineTo(pt.X,pt.Y);
         End;

         //von TangentenPunt eine Strecke von Marks.Margin zeichnen
         MiddleAngle:=v.FStartAngle+v.FSweepAngle/2;
         If MiddleAngle>360 Then MiddleAngle:=MiddleAngle-360;

         Margin:=s.Marks.Margin;

         //H”he Pie bercksichtigen
         If ((FView3D)And(MiddleAngle>180)And(MiddleAngle<360)) Then
              Margin:=Margin+Abs(Sin(MiddleAngle-180))*PieHeight
         Else
              Margin:=Margin+Abs(Sin(MiddleAngle-180))*Margin;

         If ((MiddleAngle>=0)And(MiddleAngle<=90)) Then //Quadrant 1
         Begin
              If MiddleAngle<=45 Then
              Begin
                 pt.X:=TangentPoint.X+Margin;
                 If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                 Else pt.Y:=TangentPoint.Y+(Margin/cot(MiddleAngle));
              End
              Else
              Begin
                 pt.Y:=TangentPoint.Y+Margin;
                 If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                 Else pt.X:=TangentPoint.X+(Margin/tan(MiddleAngle));
              End;
         End
         Else If ((MiddleAngle>90)And(MiddleAngle<=180)) Then //Quadrant 2
         Begin
              MiddleAngle:=90-(MiddleAngle-90);
              If MiddleAngle<=45 Then
              Begin
                  pt.X:=TangentPoint.X-Margin;
                  If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                  Else pt.Y:=TangentPoint.Y+(Margin/cot(MiddleAngle));
              End
              Else
              Begin
                  pt.Y:=TangentPoint.Y+Margin;
                  If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                  Else pt.X:=TangentPoint.X-(Margin/tan(MiddleAngle));
              End;
         End
         Else If ((MiddleAngle>180)And(MiddleAngle<=270)) Then //Quadrant 3
         Begin
              MiddleAngle:=MiddleAngle-180;
              If MiddleAngle<=45 Then
              Begin
                  pt.X:=TangentPoint.X-Margin;
                  If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                  Else pt.Y:=TangentPoint.Y-(Margin/cot(MiddleAngle));
              End
              Else
              Begin
                  pt.Y:=TangentPoint.Y-Margin;
                  If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                  Else pt.X:=TangentPoint.X-(Margin/tan(MiddleAngle));
              End;
         End
         Else //Quadrant 4
         Begin
              MiddleAngle:=90-(MiddleAngle-270);
              If MiddleAngle<=45 Then
              Begin
                   pt.X:=TangentPoint.X+Margin;
                   If ((MiddleAngle=0)Or(MiddleAngle=180)) Then pt.Y:=TangentPoint.Y
                   Else pt.Y:=TangentPoint.Y-(Margin/cot(MiddleAngle));
              End
              Else
              Begin
                   pt.Y:=TangentPoint.Y-Margin;
                   If ((MiddleAngle=90)Or(MiddleAngle=270)) Then pt.X:=TangentPoint.X
                   Else pt.X:=TangentPoint.X+(Margin/tan(MiddleAngle));
              End;
         End;

         If not HandleClip Then
         Begin
              Canvas.PenPos:=TangentPoint;
              Canvas.LineTo(pt.X,pt.Y);
         End;

         If HandleClip Then
         Begin
             Canvas.BeginPath;
             Canvas.PenPos:=TangentPoint;
             Canvas.LineTo(pt.X,pt.Y);
             Canvas.EndPath;
             Canvas.PathToClipRegion(paDiff);
         End;

         If HandleClip Then
         Begin
             //Draw mark
             Case v.Serie.Marks.Style Of
               smsValue:ss:=FormatFloat(v.Serie.Marks.FormatStr,v.Value);
               smsPercent:ss:=FormatFloat(v.Serie.Marks.FormatStr,v.FSweepAngle*100/360)+'%';
               smsLabel:ss:=v.ValueLabel;
               smsLabelPercent:ss:=v.ValueLabel+' '+
                                  FormatFloat(v.Serie.Marks.FormatStr,v.FSweepAngle*100/360)+'%';
               smsLabelValue:ss:=v.ValueLabel+' '+
                                FormatFloat(v.Serie.Marks.FormatStr,v.Value);
               smsLegend:ss:=v.ValueLabel; //???
             End;

             SaveFont:=Canvas.Font;
             Canvas.Font:=v.Serie.Marks.Font;
             Canvas.GetTextExtent(ss,CX,CY);
             Canvas.Font:=SaveFont;
             inc(CX,2); //Border
             inc(CY,2); //Border

             Canvas.Brush.Color:=s.Marks.BackColor;
             rc.Left:=pt.X;
             rc.Bottom:=pt.Y;

             MiddleAngle:=v.FStartAngle+v.FSweepAngle/2;
             If MiddleAngle>360 Then MiddleAngle:=MiddleAngle-360;

             If ((MiddleAngle>90)And(MiddleAngle<270)) Then
             Begin
                  rc.Right:=rc.Left;
                  rc.Left:=rc.Right-CX+2;

                  If rc.Left<ChartRect.Left Then
                  Begin
                       rc.Left:=ChartRect.Left;
                       rc.Right:=rc.Left+CX-2;
                  End;
             End
             Else
             Begin
                  rc.Right:=rc.Left+CX-2;
                  If rc.Right>ChartRect.Right Then
                  Begin
                       rc.Right:=ChartRect.Right;
                       rc.Left:=rc.Right-CX+2;
                  End;
             End;

             If ((MiddleAngle>180)And(MiddleAngle<360)) Then
             Begin
                  rc.Top:=rc.Bottom;
                  rc.Bottom:=rc.Top-CY+2;

                  If rc.Bottom<ChartRect.Bottom Then
                  Begin
                       rc.Bottom:=ChartRect.Bottom;
                       rc.Top:=rc.Bottom+CY-2;
                  End;
             End
             Else
             Begin
                  rc.Top:=rc.Bottom+CY-2;
                  If rc.Top>ChartRect.Top Then
                  Begin
                       rc.Top:=ChartRect.Top;
                       rc.Bottom:=rc.Top-CY+2;
                  End;
             End;

             Canvas.TextOut(rc.Left,rc.Bottom,ss);
             Canvas.Rectangle(rc);
             Canvas.BeginPath;
             Canvas.Rectangle(rc);
             Canvas.EndPath;
             Canvas.PathToClipRegion(paDiff);
         End;
    End;
End;

Procedure TPieChart.Redraw(Const rec:TRect);
Var t,t1:LongInt;
    s:TChartSeries;
    v:TChartValue;
    CenterX,CenterY,RadiusX,RadiusY:LongInt;
    Sum:Extended;
    FRot,Angle,SAngle,StartAngle,SweepAngle:Extended;
    ChartRect,PieRect,rc,clRect:TRect;
    LastTopPos,LastBottomPos,pt1:TPoint;
    Processed:LongInt;
    ShadowColor:TColor;
    red,green,blue:Byte;
    W,H:LongInt;
    PieBottom,CX,CY:LongInt;
    Title:TStrings;
    SaveFont:TFont;
    Save:TPenStyle;
Begin
     rc:=rec;
     Forms.InflateRect(rc,1,1);
     Canvas.ClipRect:=rc;

     //Calculate overall sum of all values
     Sum:=0;
     s:=Nil;
     For t:=0 To FSeries.Count-1 Do
     Begin
          s:=FSeries[t];
          If s.Active Then
          Begin
              For t1:=0 To s.FValues.Count-1 Do
              Begin
                  v:=s.FValues[t1];
                  Sum:=Sum+v.Value;
                  v.FProcessed:=False;
              End;
              break;
          End;
     End;
     If s<>Nil Then If s.Active=False Then s:=Nil;

     If s=Nil Then If Designed Then
     Begin
          CreateDesignSerie;
          s:=FDesignSerie;
          Sum:=0;
          For t1:=0 To s.FValues.Count-1 Do
          Begin
               v:=s.FValues[t1];
               Sum:=Sum+v.Value;
               v.FProcessed:=False;
          End;
     End;

     //calculate percentage value of each value and startpoint
     StartAngle:=Rotation;
     If s<>Nil Then For t:=0 To s.FValues.Count-1 Do
     Begin
          v:=s.FValues[t];
          v.FStartAngle:=StartAngle;
          v.FSweepAngle:=Round((v.Value*360)/Sum);
          StartAngle:=v.FStartAngle+v.FSweepAngle;
     End;

     clRect:=DrawChartFrame;

     ChartRect:=clRect;
     inc(ChartRect.Left,MarginLeft);
     inc(ChartRect.Bottom,MarginBottom);
     dec(ChartRect.Right,MarginRight);
     dec(ChartRect.Top,MarginTop);

     If s<>Nil Then If s.TitleVisible Then
     Begin
          Title:=s.Title;
          If Title.Count>0 Then
          Begin
              SaveFont:=Canvas.Font;
              Canvas.Font:=s.Font;
          End;
          For t:=0 To Title.Count-1 Do
          Begin
               Canvas.GetTextExtent(Title.Strings[t],CX,CY);
               dec(ChartRect.Top,CY);
          End;
          If Title.Count>0 Then Canvas.Font:=SaveFont;
     End;

     //Draw the chart's legend
     DrawLegend(s,ChartRect);

     W:=ChartRect.Right-ChartRect.Left;
     H:=ChartRect.Top-ChartRect.Bottom;
     inc(ChartRect.Bottom,Round(H*MarginBottom/100));
     dec(ChartRect.Top,Round(H*MarginTop/100));
     inc(ChartRect.Left,Round(W*MarginLeft/100));
     dec(ChartRect.Right,Round(W*MarginRight/100));

     //calculate radius and center of pie
     PieRect:=ChartRect;
     //If marks are shown, reduce the size of the pierect
     If s<>Nil Then If s.Marks.Visible Then CalcMarksRect(s,PieRect);

     If FView3D Then PieBottom:=PieRect.Bottom+Round(((PieRect.Top-PieRect.Bottom)*FPercent3d)/100)
     Else PieBottom:=PieRect.Bottom;

     RadiusX:=(PieRect.Right-PieRect.Left) Div 2;
     RadiusY:=(PieRect.Top-PieBottom) Div 2;
     If FCircled Then
     Begin
          If RadiusX>RadiusY Then RadiusX:=RadiusY
          Else RadiusY:=RadiusX;
     End;

     CenterX:=PieRect.Left+RadiusX;
     CenterY:=PieBottom+RadiusY;

     If s<>Nil Then For t:=0 To s.FValues.Count-1 Do
     Begin
          v:=s.FValues[t];
          If v.Outlined Then Canvas.Pen.Color:=v.OutlineColor
          Else Canvas.Pen.Color:=v.FillColor;
          Canvas.Brush.Color:=v.FillColor;

          Canvas.Pie(CenterX,CenterY,RadiusX,RadiusY,v.FStartAngle,v.FSweepAngle);
          Canvas.Arc(CenterX,CenterY,RadiusX,RadiusY,v.FStartAngle+v.FSweepAngle,0);
          v.FEndPoint:=Canvas.PenPos;
     End;

     If FView3D Then If s<>Nil Then
     Begin
          LastTopPos:=Point(PieRect.Left,PieBottom+RadiusY);
          LastBottomPos:=Point(PieRect.Left,PieRect.Bottom+RadiusY);
          StartAngle:=180;

          t:=0;
          Processed:=0;
          If s.FValues.Count>0 Then
          Repeat;
              v:=s.FValues[t];
              SAngle:=v.FStartAngle;              //StartWinkel
              If SAngle>=360 Then SAngle:=SAngle-360;
              SweepAngle:=v.FSweepAngle;
              If SweepAngle>=360 Then SweepAngle:=SweepAngle-360;
              Angle:=SAngle+SweepAngle; //EndWinkel

              If SAngle<={FRotation+}StartAngle Then
               If ((Angle{v.FStartAngle+v.FSweepAngle}>=180)Or(Processed>0)) Then
                 If not v.FProcessed Then
              Begin
                   v.FProcessed:=True;
                   inc(Processed);

                   RGBToValues(v.FillColor,red,green,blue);
                   If red>40 Then red:=red-40
                   Else red:=0;
                   If blue>40 Then blue:=blue-40
                   Else blue:=0;
                   If green>40 Then green:=green-40
                   Else Green:=0;
                   ShadowColor:=ValuesToRGB(red,green,blue);

                   If v.Outlined Then Canvas.Pen.Color:=v.OutlineColor
                   Else Canvas.Pen.Color:=ShadowColor;
                   Canvas.PenPos:=LastTopPos;
                   Canvas.LineTo(LastBottomPos.X,LastBottomPos.Y);

                   Canvas.Pen.Color:=ShadowColor;

                   Canvas.BeginPath;
                   Canvas.PenPos:=LastTopPos;
                   If Angle<StartAngle Then Angle:=Angle+360;
                   SweepAngle:=Angle-StartAngle;
                   If StartAngle+SweepAngle>360 Then SweepAngle:=360-StartAngle;
                   Canvas.Arc(CenterX,PieBottom+RadiusY-1,
                              RadiusX,RadiusY,StartAngle,SweepAngle);

                   SAngle:=270-(StartAngle+SweepAngle-180);
                   If SAngle>360 Then SAngle:=SAngle-360;
                   //Draw clockwise arc
                   If SweepAngle=0 Then SweepAngle:=0.000000000000000001;
                   Canvas.Arc(CenterX,PieRect.Bottom+RadiusY+1,RadiusX,RadiusY,
                              SAngle,-SweepAngle);
                   Canvas.EndPath;
                   Canvas.FillPath;

                   If v.Outlined Then Canvas.Pen.Color:=v.OutlineColor
                   Else Canvas.Pen.Color:=ShadowColor;

                   Canvas.Arc(CenterX,PieRect.Bottom+RadiusY+1,RadiusX,RadiusY,
                              StartAngle+SweepAngle,0);
                   pt1:=LastBottomPos;
                   LastBottomPos:=Canvas.PenPos;

                   Canvas.PenPos:=LastTopPos;
                   Canvas.LineTo(pt1.X,pt1.Y);

                   Canvas.PenPos:=LastBottomPos;
                   If v.FEndPoint.Y>PieBottom+RadiusY Then
                       Canvas.LineTo(PieRect.Left+RadiusX*2,PieBottom+RadiusY)
                   Else
                       Canvas.LineTo(v.FEndPoint.X,v.FEndPoint.Y);
                   Canvas.Arc(CenterX,PieRect.Bottom+RadiusY,
                              RadiusX,RadiusY,StartAngle,SweepAngle);

                   LastTopPos.X:=v.FEndPoint.X;
                   LastTopPos.Y:=v.FEndPoint.Y;
                   StartAngle:=StartAngle+SweepAngle;
                   If StartAngle=360 Then break;
              End;

              inc(t);
              If t>=s.FValues.Count Then t:=0;
          Until Processed=s.FValues.Count;
     End;

     If s<>Nil Then
     Begin
          If s.Marks.Visible Then DrawMarks(s,PieRect,PieBottom,
                                            CenterX,CenterY,
                                            RadiusX,RadiusY,
                                            ChartRect,False);
          Canvas.BeginPath;
          Canvas.Arc(CenterX,CenterY,RadiusX,RadiusY,0,180);
          Canvas.LineTo(PieRect.Left,PieRect.Bottom+RadiusY);
          Canvas.Arc(CenterX,PieRect.Bottom+RadiusY,RadiusX,RadiusY,180,180);
          Canvas.LineTo(PieRect.Left+RadiusX*2,PieBottom+RadiusY);
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);

          If s.Marks.Visible Then DrawMarks(s,PieRect,PieBottom,
                                            CenterX,CenterY,
                                            RadiusX,RadiusY,
                                            ChartRect,True);
     End;

     If GradientStyle=grsNone Then Canvas.FillRect(clRect,Color)
     Else DrawGradient(clRect,FGradientEnd,FGradientStart,FGradientStyle);

     If s<>Nil Then If s.TitleVisible Then
     Begin
          ChartRect:=clRect;
          inc(ChartRect.Left,MarginLeft);
          inc(ChartRect.Bottom,MarginBottom);
          dec(ChartRect.Right,MarginRight);
          dec(ChartRect.Top,MarginTop);

          Canvas.Pen.Color:=s.TitleColor;
          Canvas.Brush.Mode:=bmTransparent;
          Title:=s.Title;
          If Title.Count>0 Then
          Begin
              SaveFont:=Canvas.Font;
              Canvas.Font:=s.Font;
          End;
          For t:=0 To Title.Count-1 Do
          Begin
               Canvas.GetTextExtent(Title.Strings[t],CX,CY);
               Case s.TitleAlignment Of
                   staLeft:rc.Left:=ChartRect.Left;
                   staCenter:
                   Begin
                        rc.Left:=ChartRect.Left+(((ChartRect.Right-ChartRect.Left)-CX) Div 2);
                        If rc.Left<ChartRect.Left Then rc.Left:=ChartRect.Left;
                   End;
                   staRight:rc.Left:=ChartRect.Right-CX;
               End; //case

               rc.Right:=rc.Left+CX;
               rc.Bottom:=ChartRect.Top-CY;
               dec(ChartRect.Top,CY);
               rc.Top:=rc.Bottom+CY;
               Canvas.TextOut(rc.Left,rc.Bottom,Title.Strings[t]);
          End;
          If Title.Count>0 Then Canvas.Font:=SaveFont;
          Canvas.Brush.Mode:=bmOpaque;
     End;

End;

Procedure TPieChart.SetRotation(NewValue:Word);
Begin
     If NewValue=FRotation Then exit;
     If NewValue>=360 Then NewValue:=NewValue-360;
     FRotation:=NewValue;
     InvalidateGraph;
End;

Procedure TPieChart.SetCircled(NewValue:Boolean);
Begin
     If NewValue=FCircled Then exit;
     FCircled:=NewValue;
     Invalidate;
End;

Procedure TPieChart.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='PieChart';
End;

Procedure TPieChart.InvalidateGraph;
Var rc:TRect;
    clRect,ChartRect:TRect;
    t:LongInt;
    s:TChartSeries;
    Title:TStrings;
    SaveFont:TFont;
    CX,CY,ColorWidth:LongInt;
    Sum:Extended;
    v:TChartValue;
    StartAngle:Extended;
Begin
     If Handle=0 Then exit;

     If FSeries.Count=0 Then
     Begin
          Invalidate;
          exit;
     End;

     s:=Nil;
     For t:=0 To FSeries.Count-1 Do
     Begin
          s:=FSeries[t];
          If s.Active Then break;
     End;

     If s=Nil Then If Designed Then
     Begin
          CreateDesignSerie;
          s:=FDesignSerie;
     End;

     If ((s=Nil)Or(not s.Active)) Then
     Begin
          Invalidate;
          exit;
     End;

     rc:=ClientRect;
     clRect:=DrawChartFrame;

     ChartRect:=clRect;
     inc(ChartRect.Left,MarginLeft);
     inc(ChartRect.Bottom,MarginBottom);
     dec(ChartRect.Right,MarginRight);
     dec(ChartRect.Top,MarginTop);

     If s.TitleVisible Then
     Begin
          Title:=s.Title;
          If Title.Count>0 Then
          Begin
              SaveFont:=Canvas.Font;
              Canvas.Font:=s.Font;
          End;
          For t:=0 To Title.Count-1 Do
          Begin
               Canvas.GetTextExtent(Title.Strings[t],CX,CY);
               dec(ChartRect.Top,CY);
          End;
          If Title.Count>0 Then Canvas.Font:=SaveFont;
     End;

     If ((Legend.Visible)And(Legend.MaxLines>0)) Then
     Begin
          Sum:=0;
          For t:=0 To s.FValues.Count-1 Do
          Begin
               v:=s.FValues[t];
               Sum:=Sum+v.Value;
               v.FProcessed:=False;
          End;

          //calculate percentage value of each value and startpoint
          StartAngle:=Rotation;
          For t:=0 To s.FValues.Count-1 Do
          Begin
              v:=s.FValues[t];
              v.FStartAngle:=StartAngle;
              v.FSweepAngle:=Round((v.Value*360)/Sum);
              StartAngle:=v.FStartAngle+v.FSweepAngle;
          End;

          GetLegendExtent(s,CX,CY,ColorWidth,ChartRect.Right-ChartRect.Left,
                          ChartRect.Top-ChartRect.Bottom);
          Case Legend.Alignment Of
             laLeft:inc(ChartRect.Left,CX+ColorWidth+2+6+Legend.ShadowSize);
             laRight:dec(ChartRect.Right,CX+ColorWidth+2+6+Legend.ShadowSize);
             laTop:dec(ChartRect.Top,CY+2+Legend.ShadowSize);
             laBottom:inc(ChartRect.Bottom,CY+2+Legend.ShadowSize);
          End; //case
     End;

     Redraw(ChartRect);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TDBPieChart Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TDBPieChart.SetDataSource(NewValue:TDataSource);
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then TChartSeries(FSeries[0]).DataSource:=NewValue;
End;

Function TDBPieChart.GetDataSource:TDataSource;
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then Result:=TChartSeries(FSeries[0]).DataSource
     Else Result:=Nil;
End;

Function TDBPieChart.GetLabelSource:String;
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then Result:=TChartSeries(FSeries[0]).LabelSource
     Else Result:='';
End;

Procedure TDBPieChart.SetLabelSource(Const NewValue:String);
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then TChartSeries(FSeries[0]).LabelSource:=NewValue;
End;

Function TDBPieChart.GetValueSource:String;
Begin
     If FSeries.Count>0 Then Result:=TChartSeries(FSeries[0]).ValueSource
     Else Result:='';
End;

Procedure TDBPieChart.SetValueSource(Const NewValue:String);
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then TChartSeries(FSeries[0]).ValueSource:=NewValue;
End;

Procedure TDBPieChart.Redraw(Const rec:TRect);
Var l:LongInt;
Begin
     l:=FUpdateCount;
     FUpdateCount:=1;
     CreateDesignSerie;
     FUpdateCount:=l;
     Inherited Redraw(rec);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBarChart Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBarChart.SetupComponent;
Begin
     Inherited SetupComponent;
     FPercentBarWidth:=70;
     FPercent3D:=20;
     FLeftWallVisible:=True;
     FLeftWallColor:=clAqua;
     FBottomWallVisible:=True;
     FBottomWallColor:=clWhite;
     FBackWallVisible:=True;
     FBackWallColor:=clAqua;
     FSeparationPercent:=10;
     FVAxisGrid:=True;
     FHAxisGrid:=True;
     FVAxisVisible:=True;
     FVAxisTicksLen:=4;
     FHAxisVisible:=True;
     FHAxisTicksLen:=4;

     Name:='BarChart';
End;

Destructor TBarChart.Destroy;
Begin
     If FAxisFormatStr<>Nil Then FreeMem(FAxisFormatStr,length(FAxisFormatStr^)+1);
     FAxisFormatStr:=Nil;
     Inherited Destroy;
End;

Function TBarChart.GetAxisFormatStr:String;
Begin
     If FAxisFormatStr<>Nil Then Result:=FAxisFormatStr^
     Else Result:='';
End;

Procedure TBarChart.SetAxisFormatStr(Const NewValue:String);
Begin
     If FAxisFormatStr<>Nil Then
     Begin
          If NewValue=FAxisFormatStr^ Then exit;
          FreeMem(FAxisFormatStr,length(FAxisFormatStr^)+1);
     End;
     GetMem(FAxisFormatStr,length(NewValue)+1);
     FAxisFormatStr^:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetPercentBarWidth(NewValue:Byte);
Begin
     If NewValue=FPercentBarWidth Then exit;
     If NewValue>100 Then NewValue:=100;
     FPercentBarWidth:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetPointsPerPage(NewValue:LongWord);
Begin
     If NewValue=FPointsPerPage Then exit;
     FPointsPerPage:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetPercentBarOffset(NewValue:Integer);
Begin
     If NewValue=FPercentBarOffset Then exit;
     If NewValue<-100 Then NewValue:=-100;
     If NewValue>100 Then NewValue:=100;
     FPercentBarOffset:=NewValue;
     InvalidateGraph;
End;


Procedure TBarChart.InvalidateGraph;
Var rc:TRect;
    clRect,ChartRect:TRect;
    t:LongInt;
    s:TChartSeries;
    Title:TStrings;
    SaveFont:TFont;
    CX,CY,ColorWidth:LongInt;
    Sum:Extended;
    v:TChartValue;
    StartAngle:Extended;
Begin
     If Handle=0 Then exit;

     If FSeries.Count=0 Then
     Begin
          Invalidate;
          exit;
     End;

     s:=Nil;
     For t:=0 To FSeries.Count-1 Do
     Begin
          s:=FSeries[t];
          If s.Active Then break;
     End;

     If s=Nil Then If Designed Then
     Begin
          CreateDesignSerie;
          s:=FDesignSerie;
     End;

     If ((s=Nil)Or(not s.Active)) Then
     Begin
          Invalidate;
          exit;
     End;

     rc:=ClientRect;
     clRect:=DrawChartFrame;

     ChartRect:=clRect;
     inc(ChartRect.Left,MarginLeft);
     inc(ChartRect.Bottom,MarginBottom);
     dec(ChartRect.Right,MarginRight);
     dec(ChartRect.Top,MarginTop);

     If s.TitleVisible Then
     Begin
          Title:=s.Title;
          If Title.Count>0 Then
          Begin
              SaveFont:=Canvas.Font;
              Canvas.Font:=s.Font;
          End;
          For t:=0 To Title.Count-1 Do
          Begin
               Canvas.GetTextExtent(Title.Strings[t],CX,CY);
               dec(ChartRect.Top,CY);
          End;
          If Title.Count>0 Then Canvas.Font:=SaveFont;
     End;

     If ((Legend.Visible)And(Legend.MaxLines>0)) Then
     Begin
          Sum:=0;
          For t:=0 To s.FValues.Count-1 Do
          Begin
               v:=s.FValues[t];
               Sum:=Sum+v.Value;
               v.FProcessed:=False;
          End;

          GetLegendExtent(s,CX,CY,ColorWidth,ChartRect.Right-ChartRect.Left,
                          ChartRect.Top-ChartRect.Bottom);
          Case Legend.Alignment Of
             laLeft:inc(ChartRect.Left,CX+ColorWidth+2+6+Legend.ShadowSize);
             laRight:dec(ChartRect.Right,CX+ColorWidth+2+6+Legend.ShadowSize);
             laTop:dec(ChartRect.Top,CY+2+Legend.ShadowSize);
             laBottom:inc(ChartRect.Bottom,CY+2+Legend.ShadowSize);
          End; //case
     End;

     Redraw(ChartRect);
End;

Procedure TBarChart.SetLeftWallVisible(NewValue:Boolean);
Begin
     If NewValue=FLeftWallVisible Then exit;
     FLeftWallVisible:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetLeftWallColor(NewValue:TColor);
Begin
     If NewValue=FLeftWallColor Then exit;
     FLeftWallColor:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetBottomWallVisible(NewValue:Boolean);
Begin
     If NewValue=FBottomWallVisible Then exit;
     FBottomWallVisible:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetBottomWallColor(NewValue:TColor);
Begin
     If NewValue=FBottomWallColor Then exit;
     FBottomWallColor:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetBackWallVisible(NewValue:Boolean);
Begin
     If NewValue=FBackWallVisible Then exit;
     FBackWallVisible:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetBackWallColor(NewValue:TColor);
Begin
     If NewValue=FBackWallColor Then exit;
     FBackWallColor:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetSeparationPercent(NewValue:Byte);
Begin
     If NewValue=FSeparationPercent Then exit;
     FSeparationPercent:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetVAxisGrid(NewValue:Boolean);
Begin
     If NewValue=FVAxisGrid Then exit;
     FVAxisGrid:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetHAxisGrid(NewValue:Boolean);
Begin
     If NewValue=FHAxisGrid Then exit;
     FHAxisGrid:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetVAxisVisible(NewValue:Boolean);
Begin
     If NewValue=FVAxisVisible Then exit;
     FVAxisVisible:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetHAxisVisible(NewValue:Boolean);
Begin
     If NewValue=FHAxisVisible Then exit;
     FHAxisVisible:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetVAxisTicksLen(NewValue:Byte);
Begin
     If NewValue=FVAxisTicksLen Then exit;
     FVAxisTicksLen:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetHAxisTicksLen(NewValue:Byte);
Begin
     If NewValue=FHAxisTicksLen Then exit;
     FHAxisTicksLen:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.SetStyle(NewValue:TBarChartStyle);
Begin
     If NewValue=FStyle Then exit;
     FStyle:=NewValue;
     InvalidateGraph;
End;

Procedure TBarChart.Redraw(Const rec:TRect);
Var t,t1:LongInt;
    s,s1,FirstSerie,LastSerie:TChartSeries;
    v:TChartValue;
    Title:TStrings;
    SaveFont:TFont;
    rc,rc1,rc2,clRect,ChartRect,BarRect:TRect;
    CX,CY,W,H,HH:LongInt;
    W3d,BarWidth,MarginWidth:LongInt;
    Percent:Extended;
    X,Y:LongInt;
    red,green,blue:Byte;
    ShadowColor:TColor;
    LastX0:LongInt;
    SeriesCount:LongInt;
    MaxValue,MinValue,e,RangeValue:Extended;
    Range:Extended;
    VAxisLen,HAxisLen:LongInt;
    ss:String;
    YY:Extended;
Label l,l1,l2;
Begin
     rc:=rec;
     Forms.InflateRect(rc,1,1);
     Canvas.ClipRect:=rc;

     clRect:=DrawChartFrame;

     ChartRect:=clRect;
     inc(ChartRect.Left,MarginLeft);
     inc(ChartRect.Bottom,MarginBottom);
     dec(ChartRect.Right,MarginRight);
     dec(ChartRect.Top,MarginTop);

     //Look for first active serie
     s1:=Nil;
     For t:=0 To FSeries.Count-1 Do
     Begin
          s:=FSeries[t];
          If s.Active Then
          Begin
               s1:=s;
               break;
          End;
     End;

     If s1=Nil Then If Designed Then
     Begin
          CreateDesignSerie;
          s1:=FDesignSerie;
     End;

     If s1<>Nil Then If s1.TitleVisible Then
     Begin
          Title:=s1.Title;
          If Title.Count>0 Then
          Begin
              SaveFont:=Canvas.Font;
              Canvas.Font:=s1.Font;
          End;
          For t:=0 To Title.Count-1 Do
          Begin
               Canvas.GetTextExtent(Title.Strings[t],CX,CY);
               dec(ChartRect.Top,CY);
          End;
          If Title.Count>0 Then Canvas.Font:=SaveFont;
     End;

     //Draw the chart's legend
     DrawLegend(s1,ChartRect);

     SeriesCount:=0;
     If FSeries.Count>0 Then
     Begin
         For t:=0 To FSeries.Count-1 Do
         Begin
             s:=FSeries[t];
             If s.Active Then If s.FValues.Count>0 Then inc(SeriesCount);
         End;
     End
     Else If s1<>Nil Then inc(SeriesCount);

     W:=ChartRect.Right-ChartRect.Left;
     H:=ChartRect.Top-ChartRect.Bottom;
     inc(ChartRect.Bottom,Round(H*MarginBottom/100));
     dec(ChartRect.Top,Round(H*MarginTop/100));
     inc(ChartRect.Left,Round(W*MarginLeft/100));
     dec(ChartRect.Right,Round(W*MarginRight/100));
     W:=ChartRect.Right-ChartRect.Left;
     H:=ChartRect.Top-ChartRect.Bottom;

     //calculate radius and center of pie
     BarRect:=ChartRect;

     //calculate width of Bars
     W:=BarRect.Right-BarRect.Left;
     H:=BarRect.Top-BarRect.Bottom;
     If ((View3D)And(Percent3d>0)And(SeriesCount>0)) Then W3d:=(W Div SeriesCount Div 4*Percent3d) Div 100
     Else W3d:=0;
     dec(W,W3d*SeriesCount);
     dec(H,W3d);

     If SeriesCount>0 Then
     Begin
         dec(H,W3D Div 2);
         For t:=FSeries.Count-1 Downto 0 Do
         Begin
            s:=FSeries[t];
            If s.Active Then goto l1;
         End;
         If s1<>Nil Then
         Begin
              dec(H,W3D Div 2);
              s:=s1;
              goto l1;
         End;
     End
     Else If s1<>Nil Then
     Begin
          dec(H,W3D Div 2);
          s:=s1;
l1:
          If s.Marks.Visible Then
          Begin
               SaveFont:=Canvas.Font;
               Canvas.Font:=s.Marks.Font;
               Canvas.GetTextExtent('AByT',CX,CY);
               dec(H,CY+s.Marks.ArrowLength*2);
               Canvas.Font:=SaveFont;
          End;
     End;

     For t:=1 To FSeries.Count-1 Do
     Begin
          s:=FSeries[t];
          If s.Active Then
            If s.FValues.Count>0 Then dec(W,(W3d Div 2)+15);
     End;
     dec(W,W3d*(SeriesCount-1));

     MaxValue:=0;
     MinValue:=0;
     FirstSerie:=Nil;
     If FSeries.Count>0 Then
     Begin
          For t:=0 To FSeries.Count-1 Do
          Begin
             s:=FSeries[t];
             If s.Active Then
             Begin
l2:
                 If FirstSerie=Nil Then FirstSerie:=s;
                 LastSerie:=s;
                 If t>0 Then If s.FValues.Count>0 Then dec(H,W3d+W3d Div 2);
                 For t1:=0 To s.FValues.Count-1 Do
                 Begin
                     v:=s.FValues[t1];
                     If v.Value>MaxValue Then MaxValue:=v.Value;
                     If v.Value<MinValue Then MinValue:=v.Value;
                 End;
             End;
          End
     End
     Else If s1<>Nil Then
     Begin
          t:=0;
          s:=s1;
          goto l2;
     End;

     If HAxisVisible Then If LastSerie<>Nil Then
     Begin
          dec(H,HAxisTicksLen);
          HAxisLen:=0;
          For t1:=0 To LastSerie.FValues.Count-1 Do
          Begin
               v:=LastSerie.FValues[t1];
               ss:=v.ValueLabel;
               Canvas.GetTextExtent(ss,CX,CY);
               If CY>HAxisLen Then HAxisLen:=CY;
          End;

          dec(H,HAxisLen+2);
          inc(BarRect.Bottom,HAxisLen+2);
     End;

     inc(H,(W3d Div 2)*(SeriesCount-1));
     RangeValue:=MaxValue-MinValue;
     RangeValue:=RangeValue/SeparationPercent;
     Range:=H*SeparationPercent/100;

     If VAxisVisible Then
     Begin
          dec(W,VAxisTicksLen);
          e:=MinValue;
          VAxisLen:=0;
          If RangeValue>0 Then While e<=MaxValue Do
          Begin
               If e=0 Then ss:='0'
               Else ss:=FormatFloat(AxisFormatStr,e);
               Canvas.GetTextExtent(ss,CX,CY);
               If CX>VAxisLen Then VAxisLen:=CX;
               e:=e+RangeValue;
          End;
          dec(W,VAxisLen+2);
          inc(BarRect.Left,VAxisLen+2);
     End;

     BarWidth:=(W*PercentBarWidth) Div 100;
     MarginWidth:=W-BarWidth;

     If PointsPerPage<>0 Then BarWidth:=BarWidth Div PointsPerPage
     Else
     Begin
          //determine serie with most points
          t1:=0;
          If FSeries.Count>0 Then For t:=0 To FSeries.Count-1 Do
          Begin
               s:=FSeries[t];
               If s.Active Then
                 If s.FValues.Count>t1 Then t1:=s.FValues.Count;
          End
          Else If s1<>Nil Then t1:=s1.FValues.Count;
          If t1>0 Then BarWidth:=BarWidth Div t1;
     End;

     Y:=BarRect.Bottom;
     LastX0:=BarRect.Left+W3D*SeriesCount+BarWidth-15;
     If FSeries.Count>0 Then For t:=0 To FSeries.Count-1 Do
     Begin
          X:=LastX0-BarWidth+15;
          s:=FSeries[t];
          If not s.Active Then continue;
l:
          For t1:=0 To s.FValues.Count-1 Do
          Begin
               v:=s.FValues[t1];

               RGBToValues(v.FillColor,red,green,blue);
               If red>40 Then red:=red-40
               Else red:=0;
               If blue>40 Then blue:=blue-40
               Else blue:=0;
               If green>40 Then green:=green-40
               Else Green:=0;
               ShadowColor:=ValuesToRGB(red,green,blue);

               rc1.Left:=X;
               rc1.Right:=rc1.Left+BarWidth;
               rc1.Bottom:=Y;
               If MinValue<0 Then
               Begin
                    Percent:=(-MinValue*100)/(MaxValue-MinValue);
                    inc(rc1.Bottom,Round((H*Percent)/100));
                    HH:=H;
                    dec(HH,Round((H*Percent)/100));
               End
               Else HH:=H;
               If MaxValue<>0 Then Percent:=(v.Value*100)/MaxValue
               Else Percent:=0;
               rc1.Top:=rc1.Bottom+W3D*SeriesCount+Round((HH*Percent)/100);
               dec(rc1.Top,(W3d Div 2)*(SeriesCount-1));
               If rc1.Top<rc1.Bottom Then
               Begin
                    HH:=rc1.Top;
                    rc1.Top:=rc1.Bottom;
                    rc1.Bottom:=HH;
               End;

               Case Style Of
                 bcsRectangle:
                 Begin
                      Canvas.Pen.Color:=v.FillColor;
                      Canvas.Box(rc1);
                      Canvas.Pen.Color:=v.OutlineColor;
                      Canvas.Rectangle(rc1);
                      Canvas.ExcludeClipRect(rc1);
                 End;
                 bcsRectGradient:
                 Begin
                      dec(rc1.Bottom,2);
                      DrawGradient(rc1,v.FillColor,clWhite,grsTopBottom);
                      inc(rc1.Bottom,2);
                      Canvas.Pen.Color:=v.OutlineColor;
                      Canvas.Rectangle(rc1);
                      Canvas.ExcludeClipRect(rc1);
                 End;
               End; //case

               inc(X,BarWidth);
               If ((PointsPerPage<>0)And(s.FValues.Count>PointsPerPage)) Then inc(X,MarginWidth Div PointsPerPage)
               Else inc(X,MarginWidth Div s.FValues.Count);

               If t1+1=PointsPerPage Then break;
          End;

          //exclude the rectangles for 3d
          If ((PointsPerPage<>0)And(s.FValues.Count>PointsPerPage)) Then dec(X,MarginWidth Div PointsPerPage)
          Else dec(X,MarginWidth Div s.FValues.Count);
          dec(X,BarWidth);
          For t1:=s.FValues.Count-1 DownTo 0 Do
          Begin
               v:=s.FValues[t1];

               RGBToValues(v.FillColor,red,green,blue);
               If red>40 Then red:=red-40
               Else red:=0;
               If blue>40 Then blue:=blue-40
               Else blue:=0;
               If green>40 Then green:=green-40
               Else Green:=0;
               ShadowColor:=ValuesToRGB(red,green,blue);

               rc1.Left:=X;
               rc1.Right:=rc1.Left+BarWidth;
               rc1.Bottom:=Y;
               If MinValue<0 Then
               Begin
                    Percent:=(-MinValue*100)/(MaxValue-MinValue);
                    inc(rc1.Bottom,Round((H*Percent)/100));
                    HH:=H;
                    dec(HH,Round((H*Percent)/100));
               End
               Else HH:=H;
               If MaxValue<>0 Then Percent:=(v.Value*100)/MaxValue
               Else Percent:=0;
               rc1.Top:=rc1.Bottom+W3D*SeriesCount+Round((HH*Percent)/100);
               dec(rc1.Top,(W3d Div 2)*(SeriesCount-1));
               If rc1.Top<rc1.Bottom Then
               Begin
                    HH:=rc1.Top;
                    rc1.Top:=rc1.Bottom;
                    rc1.Bottom:=HH;
               End;

               v.FEndPoint:=Point(rc1.Left+BarWidth Div 2,rc1.Bottom);

               If t1=0 Then LastX0:=rc1.Right+W3d Div 2;

               Canvas.Pen.Color:=ShadowColor;
               Canvas.Polygon([Point(rc1.Left,rc1.Top),
                               Point(rc1.Left+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Left+W3d Div 2+BarWidth,rc1.Top+W3d Div 2),
                               Point(rc1.Left+BarWidth,rc1.Top)]);

               Canvas.Pen.Color:=v.OutlineColor;
               Canvas.PolyLine([Point(rc1.Left,rc1.Top),
                               Point(rc1.Left+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Right+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Right,rc1.Top)]);

               Canvas.Pen.Color:=ShadowColor;
               Canvas.Polygon([Point(rc1.Right,rc1.Bottom),
                               Point(rc1.Right,rc1.Top),
                               Point(rc1.Right+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Right+W3d Div 2,rc1.Bottom+W3d Div 2)]);

               Canvas.Pen.Color:=v.OutlineColor;
               Canvas.PolyLine([Point(rc1.Right,rc1.Bottom),
                               Point(rc1.Right,rc1.Top),
                               Point(rc1.Right+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Right+W3d Div 2,rc1.Bottom+W3d Div 2),
                               Point(rc1.Right,rc1.Bottom)]);

               If s.Marks.Visible Then
               Begin
                    SaveFont:=Canvas.Font;
                    ss:=GetChartStrDim(v,CX,CY);
                    Canvas.Brush.Color:=s.Marks.BackColor;

                    rc2.Left:=rc1.Left+((rc1.Right-rc1.Left) Div 2)+W3d Div 2-CX Div 2;
                    rc2.Right:=rc2.Left+CX;
                    rc2.Bottom:=rc1.Top+W3d Div 2+s.Marks.ArrowLength;
                    rc2.Top:=rc2.Bottom+CY;
                    Canvas.Pen.Color:=s.Marks.BackColor;
                    Canvas.Box(rc2);
                    Canvas.Pen.Color:=s.Marks.BorderColor;
                    Canvas.Brush.Mode:=bmTransparent;
                    Canvas.TextOut(rc2.Left,rc2.Bottom,ss);
                    Canvas.Brush.Mode:=bmOpaque;
                    Canvas.Rectangle(rc2);
                    Canvas.BeginPath;
                    Canvas.Rectangle(rc2);
                    Canvas.EndPath;
                    Canvas.PathToClipRegion(paDiff);

                    Canvas.Pen.Color:=s.Marks.ArrowColor;
                    Canvas.PenPos:=Point(rc2.Left+(rc2.Right-rc2.Left) Div 2,rc2.Bottom);
                    Canvas.LineTo(rc2.Left+(rc2.Right-rc2.Left) Div 2,rc2.Bottom-s.Marks.ArrowLength-2);

                    Canvas.BeginPath;
                    Canvas.PenPos:=Point(rc2.Left+(rc2.Right-rc2.Left) Div 2,rc2.Bottom);
                    Canvas.LineTo(rc2.Left+(rc2.Right-rc2.Left) Div 2,rc2.Bottom-s.Marks.ArrowLength-2);
                    Canvas.EndPath;
                    Canvas.PathToClipRegion(paDiff);

                    Canvas.Font:=SaveFont;
               End;

               Canvas.BeginPath;
               Canvas.PolyLine([Point(rc1.Left,rc1.Top),
                               Point(rc1.Left+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Left+W3d Div 2+BarWidth,rc1.Top+W3d Div 2),
                               Point(rc1.Left+BarWidth,rc1.Top)]);

               Canvas.EndPath;
               Canvas.PathToClipRegion(paDiff);

               Canvas.BeginPath;
               Canvas.PolyLine([Point(rc1.Right,rc1.Bottom),
                               Point(rc1.Right,rc1.Top),
                               Point(rc1.Right+W3d Div 2,rc1.Top+W3d Div 2),
                               Point(rc1.Right+W3d Div 2,rc1.Bottom+W3d Div 2)]);
               Canvas.EndPath;
               Canvas.PathToClipRegion(paDiff);

               If ((PointsPerPage<>0)And(s.FValues.Count>PointsPerPage)) Then dec(X,MarginWidth Div PointsPerPage)
               Else dec(X,MarginWidth Div s.FValues.Count);
               dec(X,BarWidth);

               If t1+1=PointsPerPage Then break;
          End;

          inc(Y,W3d Div 2);
          If t>FSeries.Count-1 Then Break;
     End
     Else If s1<>Nil Then
     Begin
          s:=s1;
          X:=LastX0-BarWidth+15;
          t:=1;
          goto l;
     End;

     For t:=1 To FSeries.Count-1 Do
     Begin
          s:=FSeries[t];
          If s.Active Then
            If s.FValues.Count>0 Then inc(W,(W3d Div 2)+15);
     End;
     dec(W,W3d);

     rc1.Left:=BarRect.Left+(W3d*SeriesCount);
     rc1.Bottom:=BarRect.Bottom+(W3d*SeriesCount);
     rc1.Right:=rc1.Left+W+(W3d*SeriesCount);
     rc1.Top:=BarRect.Top;

     //Draw Walls
     If LeftWallVisible Then
     Begin
          Canvas.Pen.Color:=LeftWallColor;
          Canvas.Polygon([Point(BarRect.Left,BarRect.Bottom),
                          Point(BarRect.Left,BarRect.Top-(W3D*SeriesCount)),
                          Point(BarRect.Left+(W3D*SeriesCount),BarRect.Top),
                          Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount))
                         ]);
     End;

     If BottomWallVisible Then
     Begin
          Canvas.Pen.Color:=BottomWallColor;
          Canvas.Polygon([Point(BarRect.Left,BarRect.Bottom),
                          Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount)),
                          Point(BarRect.Left+(W3D*SeriesCount*2)+W,BarRect.Bottom+(W3D*SeriesCount)),
                          Point(BarRect.Left+(W3D*SeriesCount)+W,BarRect.Bottom)
                         ]);
     End;

     If BackWallVisible Then
     Begin
          Canvas.Pen.Color:=BackWallColor;
          Canvas.Box(rc1);
     End;

     X:=BarRect.Left;
     YY:=BarRect.Bottom;
     //Canvas.Pen.Style:=psDash;
     Canvas.Pen.Color:=clDkGray;
     If FHAxisGrid Then While YY<BarRect.Top-W3d*SeriesCount Do
     Begin
          Canvas.PenPos:=Point(X,Round(YY));
          Canvas.LineTo(X+W3D*SeriesCount,Round(YY)+W3D*SeriesCount);
          YY:=YY+Range;
     End;
     //Canvas.Pen.Style:=psSolid;
     Canvas.Pen.Color:=clBlack;

     If BottomWallVisible Then
     Begin
          Canvas.PolyLine([Point(BarRect.Left,BarRect.Bottom),
                           Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount)),
                           Point(BarRect.Left+(W3D*SeriesCount*2)+W,BarRect.Bottom+(W3D*SeriesCount)),
                           Point(BarRect.Left+(W3D*SeriesCount)+W,BarRect.Bottom),
                           Point(BarRect.Left,BarRect.Bottom)
                         ]);
          Canvas.BeginPath;
          Canvas.PolyLine([Point(BarRect.Left,BarRect.Bottom),
                          Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount)),
                          Point(BarRect.Left+(W3D*SeriesCount*2)+W,BarRect.Bottom+(W3D*SeriesCount)),
                          Point(BarRect.Left+(W3D*SeriesCount)+W,BarRect.Bottom)
                         ]);

          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);
     End;

     If LeftWallVisible Then
     Begin
          Canvas.PolyLine([Point(BarRect.Left,BarRect.Bottom),
                           Point(BarRect.Left,BarRect.Top-(W3D*SeriesCount)),
                           Point(BarRect.Left+(W3D*SeriesCount),BarRect.Top),
                           Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount))
                          ]);
          Canvas.BeginPath;
          Canvas.PolyLine([Point(BarRect.Left,BarRect.Bottom),
                          Point(BarRect.Left,BarRect.Top-(W3D*SeriesCount)),
                          Point(BarRect.Left+(W3D*SeriesCount),BarRect.Top),
                          Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount))
                         ]);
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);
     End;

     If BackWallVisible Then
     Begin
          Canvas.Rectangle(rc1);
          X:=BarRect.Left+W3D*SeriesCount;
          YY:=BarRect.Bottom+W3D*SeriesCount;
          Canvas.Pen.Style:=psDash;
          Canvas.Pen.Color:=clDkGray;
          If FVAxisGrid Then While YY<BarRect.Top Do
          Begin
               Canvas.PenPos:=Point(X,Round(YY));
               Canvas.LineTo(X+W3D*SeriesCount+W,Round(YY));

               YY:=YY+Range;
          End;
          If FHAxisGrid Then If s1<>Nil Then For t:=0 To s1.FValues.Count-1 Do
          Begin
               v:=s1.FValues[t];
               Canvas.PenPos:=Point(v.FEndPoint.X+W3d*SeriesCount,v.FEndPoint.Y+W3d*SeriesCount);
               Canvas.LineTo(v.FEndPoint.X+W3d*SeriesCount,BarRect.Top);
          End;

          Canvas.Pen.Style:=psSolid;
          Canvas.Pen.Color:=clBlack;

          Canvas.BeginPath;
          Canvas.Rectangle(rc1);
          Canvas.EndPath;
          Canvas.PathToClipRegion(paDiff);
     End;

     If GradientStyle=grsNone Then Canvas.FillRect(clRect,Color)
     Else DrawGradient(clRect,FGradientEnd,FGradientStart,FGradientStyle);

     Canvas.Pen.Color:=clBlack;

     If not LeftWallVisible Then
       Canvas.PolyLine([Point(BarRect.Left,BarRect.Bottom),
                        Point(BarRect.Left,BarRect.Top-(W3D*SeriesCount)),
                        Point(BarRect.Left+(W3D*SeriesCount),BarRect.Top),
                        Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount))
                       ]);

     If VAxisVisible Then
     Begin
          e:=MinValue;
          Canvas.Brush.Mode:=bmTransparent;
          YY:=BarRect.Bottom;
          If RangeValue>0 Then While YY<BarRect.Top-W3d*SeriesCount Do
          Begin
               If e=0 Then ss:='0'
               Else ss:=FormatFloat(AxisFormatStr,e);
               Canvas.GetTextExtent(ss,CX,CY);
               Canvas.TextOut(BarRect.Left-CX-2-VAxisTicksLen,Round(YY)-CY Div 2,ss);
               If VAxisTicksLen>0 Then
               Begin
                    Canvas.PenPos:=Point(BarRect.Left,Round(YY));
                    Canvas.LineTo(BarRect.Left-VAxisTicksLen,Round(YY));
               End;
               e:=e+RangeValue;
               YY:=YY+Range;
          End;
          Canvas.Brush.Mode:=bmOpaque;
     End;

     If HAxisVisible Then If FirstSerie<>Nil Then
     Begin
          Canvas.Brush.Mode:=bmTransparent;
          For t1:=0 To FirstSerie.ValueCount-1 Do
          Begin
               v:=FirstSerie.Values[t1];
               Canvas.PenPos:=Point(v.FEndPoint.X,BarRect.Bottom);
               Canvas.LineTo(v.FEndPoint.X,BarRect.Bottom-HAxisTicksLen);
               ss:=v.ValueLabel;
               Canvas.GetTextExtent(ss,CX,CY);
               Canvas.TextOut(v.FEndPoint.X-CX Div 2,BarRect.Bottom-2-HAxisTicksLen-CY,ss);
          End;
          Canvas.Brush.Mode:=bmOpaque;
     End;

     If not BottomWallVisible Then
       Canvas.PolyLine([Point(BarRect.Left,BarRect.Bottom),
                        Point(BarRect.Left+(W3D*SeriesCount),BarRect.Bottom+(W3D*SeriesCount)),
                        Point(BarRect.Left+(W3D*SeriesCount*2)+W,BarRect.Bottom+(W3D*SeriesCount)),
                        Point(BarRect.Left+(W3D*SeriesCount)+W,BarRect.Bottom),
                        Point(BarRect.Left,BarRect.Bottom)
                       ]);

     If not BackWallVisible Then
     Begin
         Canvas.Rectangle(rc1);

         X:=BarRect.Left+W3D*SeriesCount;
         YY:=BarRect.Bottom+W3D*SeriesCount;
         Canvas.Pen.Style:=psDash;
         Canvas.Pen.Color:=clDkGray;
         If FVAxisGrid Then While YY<BarRect.Top Do
         Begin
              Canvas.PenPos:=Point(X,Round(YY));
              Canvas.LineTo(X+W3D*SeriesCount+W,Round(YY));

              YY:=YY+Range;
         End;
         If FHAxisGrid Then If s1<>Nil Then For t:=0 To s1.FValues.Count-1 Do
         Begin
              v:=s1.FValues[t];
              Canvas.PenPos:=Point(v.FEndPoint.X+W3d*SeriesCount,v.FEndPoint.Y+W3d*SeriesCount);
              Canvas.LineTo(v.FEndPoint.X+W3d*SeriesCount,BarRect.Top);
         End;

         Canvas.Pen.Style:=psSolid;
         Canvas.Pen.Color:=clBlack;
     End;

     If s1<>Nil Then If s1.TitleVisible Then
     Begin
          ChartRect:=clRect;
          inc(ChartRect.Left,MarginLeft);
          inc(ChartRect.Bottom,MarginBottom);
          dec(ChartRect.Right,MarginRight);
          dec(ChartRect.Top,MarginTop);

          Canvas.Pen.Color:=s.TitleColor;
          Canvas.Brush.Mode:=bmTransparent;
          Title:=s1.Title;
          If Title.Count>0 Then
          Begin
              SaveFont:=Canvas.Font;
              Canvas.Font:=s1.Font;
          End;
          For t:=0 To Title.Count-1 Do
          Begin
               Canvas.GetTextExtent(Title.Strings[t],CX,CY);
               Case s.TitleAlignment Of
                   staLeft:rc.Left:=ChartRect.Left;
                   staCenter:
                   Begin
                        rc.Left:=ChartRect.Left+(((ChartRect.Right-ChartRect.Left)-CX) Div 2);
                        If rc.Left<ChartRect.Left Then rc.Left:=ChartRect.Left;
                   End;
                   staRight:rc.Left:=ChartRect.Right-CX;
               End; //case

               rc.Right:=rc.Left+CX;
               rc.Bottom:=ChartRect.Top-CY;
               dec(ChartRect.Top,CY);
               rc.Top:=rc.Bottom+CY;
               Canvas.TextOut(rc.Left,rc.Bottom,Title.Strings[t]);
          End;
          If Title.Count>0 Then Canvas.Font:=SaveFont;
          Canvas.Brush.Mode:=bmOpaque;
     End;

End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TDBBarChart Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TDBBarChart.SetDataSource(NewValue:TDataSource);
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then TChartSeries(FSeries[0]).DataSource:=NewValue;
End;

Function TDBBarChart.GetDataSource:TDataSource;
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then Result:=TChartSeries(FSeries[0]).DataSource
     Else Result:=Nil;
End;

Function TDBBarChart.GetLabelSource:String;
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then Result:=TChartSeries(FSeries[0]).LabelSource
     Else Result:='';
End;

Procedure TDBBarChart.SetLabelSource(Const NewValue:String);
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then TChartSeries(FSeries[0]).LabelSource:=NewValue;
End;

Function TDBBarChart.GetValueSource:String;
Begin
     If FSeries.Count>0 Then Result:=TChartSeries(FSeries[0]).ValueSource
     Else Result:='';
End;

Procedure TDBBarChart.SetValueSource(Const NewValue:String);
Begin
     CreateDesignSerie;
     If FSeries.Count>0 Then TChartSeries(FSeries[0]).ValueSource:=NewValue;
End;

Procedure TDBBarChart.Redraw(Const rec:TRect);
Var l:LongInt;
Begin
     l:=FUpdateCount;
     FUpdateCount:=1;
     CreateDesignSerie;
     FUpdateCount:=l;
     Inherited Redraw(rec);
End;


Initialization
    RegisterClasses([TPieChart,TBarChart,TDBPieChart,TDBBarChart]);
End.
