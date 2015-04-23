Unit MultiColumnListBox;

Interface

Uses
  Classes, Forms, ExtCtrls, StdCtrls, ComCtrls, SysUtils, Dialogs, Graphics;

{Declare new class}
Type
  TMultiColumnListBox=Class(TListBox)
    Private
      BmpList: TList;
      sections: THeaderSections;
      sep_char: string;

      Function GetBitmap(Index:LongInt):TBitmap;
      Procedure SetBitmap(index:LongInt;bmp:TBitmap);
      Function GetSepChar:string;
      Procedure SetSepChar(Value:string);
    Protected
      Procedure SetupComponent;Override;
      Procedure DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);Override;
    Public
      Function Add(s:string):LongInt;
      Function AddObject(s:string;o:TObject):LongInt;
      Property Bitmaps[index:LongInt]:TBitmap write SetBitmap read GetBitmap;
      Procedure SetHeader(s: THeaderSections);
      Procedure Sort(section:Integer);
      Destructor Destroy; Override;
      Procedure Clear; Override;
      Property Separator:string read GetSepChar write SetSepChar;
  End;

Type
  MultiColumnList=Class(TPanel)
  Private
    List: TMultiColumnListBox;
    Header: THeaderControl;
    Fenabled: Boolean;
    drag_mode:TDragMode;
    Function GetSections:THeaderSections;
    Function GetSectionsItem(Index:LongInt):THeaderSection;//gehn
    Function GetSectionsCount:LongInt;//gehn
    Procedure SetSections(Value:THeaderSections);
    Function GetDuplicates:Boolean;
    Procedure SetDuplicates(Value:Boolean);
    Function GetExtendedSelect:Boolean;
    Procedure SetExtendedSelect(Value:Boolean);
    Function GetItemIndex:LongInt;
    Procedure SetItemIndex(Value:LongInt);
    Function GetMultiSelect:Boolean;
    Procedure SetMultiSelect(Value:Boolean);
    Function GetOnItemFocus:TItemFocusEvent;
    Procedure SetOnItemFocus(Value:TItemFocusEvent);
    Function GetOnItemSelect:TItemSelectEvent;
    Procedure SetOnItemSelect(Value:TItemSelectEvent);
    Function GetSelCount:LongInt;
    Function GetSelected(Index:LongInt):Boolean;
    Procedure SetSelected(Index:LongInt;Value:Boolean);
    Function GetTheFont:TFont;
    Procedure SetTheFont(Value:TFont);
    Function GetValue(field,index:LongInt):string;
    Procedure SetValue(field,index:LongInt;Value:string);
    Function GetBitmap(index:LongInt):TBitmap;
    Procedure SetBitmap(index:LongInt; bmp:TBitmap);
    Function GetHint:string;
    Procedure SetHint(Value:string);
    Function GetObjects(Index:LongInt):TObject;
    Procedure SetObjects(Index:LongInt;Value:TObject);
    Function GetShowDragRects:Boolean;
    Procedure SetShowDragRects(Value:Boolean);
    Function GetHeaderHint:string;
    Procedure SetHeaderHint(Value:string);
    Procedure SetEnabled(Value:Boolean);
    Function GetCount:LongInt;
    Procedure SetDragMode(Value:TDragMode);
    Procedure EvSectionPressed(sender: THeaderControl; section: THeaderSection);
    Procedure EvSectionTrack(sender: THeaderControl; section: THeaderSection; width: LongInt; State:TSectionTrackState);
    Procedure EvCanDrag(sender: TObject; X,Y: LongInt; var Accept: Boolean);
    Procedure EvDragDrop(sender: TObject; source: TObject; X,Y: LongInt);
    Procedure EvDragOver(sender: TObject; source: TObject; X,Y: LongInt; State: TDragState; var Accept: Boolean);

    Function GetSepChar:string;
    Procedure SetSepChar(Value:string);

  Protected
    Procedure SetupComponent; Override;
    Procedure SetupShow;Override;
    Procedure Resize;Override;

  Public
    Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
    Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
    Destructor Destroy; Override;
    Constructor Create(AOwner:TComponent); Override;
    Procedure SelectAll;
    Procedure DeselectAll;
    Function Add(s:string):LongInt;
    Function AddObject(s:string;o:TObject):LongInt;
    Procedure Delete(Index:LongInt);
    Procedure Clear;
    Function ItemRect(Index:LongInt):TRect;
    Function IsDraggedSourceMe(source: TObject):Boolean;
    Procedure Sort(section:Integer);
    Function IndexOf(s:string):LongInt;
    Procedure BeginUpdate;
    Procedure EndUpdate;
    //gehn
    Procedure SetSectionsItemText(Index:LongInt; NewText:String);

    Property ListBox: TMultiColumnListBox read List;
    Property HeaderControl: THeaderControl read Header;
    Property SelCount: LongInt read GetSelCount;
    Property Selected[Index: LongInt]: Boolean read GetSelected write SetSelected;
    Property Values[field,index:LongInt]: string read GetValue write SetValue;default;
    Property Bitmaps[index:LongInt]:TBitmap write SetBitmap read GetBitmap;
    Property Objects[index:LongInt]:TObject read GetObjects write SetObjects;
    Property Count:LongInt read GetCount;
    Property ItemIndex: LongInt read GetItemIndex write SetItemIndex;
    Property TabStop;

  Published
    Property Sections: THeaderSections read GetSections write SetSections;
    Property Duplicates: Boolean read GetDuplicates write SetDuplicates;
    Property ExtendedSelect: Boolean read GetExtendedSelect write SetExtendedSelect;
    Property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    Property OnItemFocus: TItemFocusEvent read GetOnItemFocus write SetOnItemFocus;
    Property OnItemSelect: TItemSelectEvent read GetOnItemSelect write SetOnItemSelect;
    Property Font:TFont read GetTheFont write SetTheFont;
    Property Hint:string read GetHint write SetHint;
    Property HeaderHint:string read GetHeaderHint write SetHeaderHint;
    Property Enabled:Boolean read Fenabled write SetEnabled;
    Property ShowDragRects:Boolean read GetShowDragRects write SetShowDragRects;
    Property DragMode:TDragMode read drag_mode write SetDragMode;
    Property Separator:string read GetSepChar write SetSepChar;
  End;


{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  MultiColumnList,'User','';


Implementation

Procedure TMultiColumnListBox.Sort(section:Integer);
  Function CurrencyToFloat(s:string):double;
  Var
    i:LongInt;
  Begin
    // Get rid of any non numeric symbols...
    i:=1;
    If s[i]='-' then
      Inc(i);
    While (i<=Length(s)) do
    Begin
      /* gehn
      If ((s[i]<'0') Or (s[i]>'9')) And (s[i]<>'.') then
      */
      If ((s[i]<'0') Or (s[i]>'9')) And (s[i]<>DecimalSeparator) then
        Delete(s,i,1);
      i:=i+1;
    End;
    Try
      Result:=StrToFloat(s);
    Except
      Result:=0.0;
    End;
  End;

Var
  strings:TStringList;

  Function DoCompare(Const S, T: String): Integer;
  Var
    s1,s2,ds1,ds2,tmp: string;
    indx,i:Integer;
    dt1,dt2:TDateTime;
    f1,f2:Extended;
    h1,m1,h2,m2:LongInt;
  Begin
    s1:= S;
    s2:= T;
    // Remove the T/F flag that occupies the first char
    // and remove the bitmap number at the start.
    Delete(s1,1,1);
    Delete(s2,1,1);
    For i:=1 To section Do
    Begin
      indx:=Pos(sep_char,s1);
      if indx>0 then System.Delete(s1,1,indx);
      indx:=Pos(sep_char,s2);
      if indx>0 then System.Delete(s2,1,indx);
    End;
    Try
      ds1:=s1;
      indx:=Pos(sep_char,ds1);
      if indx>0 then System.SubStr(ds1,1,indx-1);
      ds2:=s2;
      indx:=Pos(sep_char,ds2);
      if indx>0 then System.SubStr(ds2,1,indx-1);
      dt1:=StrToDate(ds1);
      dt2:=StrToDate(ds2);
      If dt1<dt2 then
        Result:=1
      Else If dt1>dt2 then
        Result:=-1
      Else
        Result:=0;
    Except
      Try
        If ds1[2]=':' then
        Begin
          tmp:=ds1;
          SubStr(tmp,1,1);
          h1:=StrToInt(tmp);
          tmp:=ds1;
          SubStr(tmp,3,2);
          m1:=StrToInt(tmp);
          If h1=12 then h1:=0;
          tmp:=ds1;
          SubStr(tmp,5,2);
          If CompareText(tmp,'pm')=0 then
            h1:=h1+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else If ds1[3]=':' then
        Begin
          tmp:=ds1;
          SubStr(tmp,1,2);
          h1:=StrToInt(tmp);
          tmp:=ds1;
          SubStr(tmp,4,2);
          m1:=StrToInt(tmp);
          If h1=12 then h1:=0;
          tmp:=ds1;
          SubStr(tmp,6,2);
          If CompareText(tmp,'pm')=0 then
            h1:=h1+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else
          Raise EConvertError.Create('');
        If ds2[2]=':' then
        Begin
          tmp:=ds2;
          SubStr(tmp,1,1);
          h2:=StrToInt(tmp);
          tmp:=ds2;
          SubStr(tmp,3,2);
          m2:=StrToInt(tmp);
          If h2=12 then h2:=0;
          tmp:=ds2;
          SubStr(tmp,5,2);
          If CompareText(tmp,'pm')=0 then
            h2:=h2+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else If ds2[3]=':' then
        Begin
          tmp:=ds2;
          SubStr(tmp,1,2);
          h2:=StrToInt(tmp);
          tmp:=ds2;
          SubStr(tmp,4,2);
          m2:=StrToInt(tmp);
          If h2=12 then h2:=0;
          tmp:=ds2;
          SubStr(tmp,6,2);
          If CompareText(tmp,'pm')=0 then
            h2:=h2+12
          Else If CompareText(tmp,'am')<>0 then
            Raise EConvertError.Create('');
        End Else
          Raise EConvertError.Create('');
        If h1<h2 then
          Result:=1
        Else If h1>h2 then
          Result:=-1
        Else If m1<m2 then
          Result:=1
        Else If m1>m2 then
          Result:=-1
        Else
          Result:=0;
      Except
        // Then try currency!
        Try
          f1:=CurrencyToFloat(ds1);
          f2:=CurrencyToFloat(ds2);
          If f1<f2 then
            Result:=-1
          Else If f1>f2 then
            Result:=1
          Else
            Raise EConvertError.Create('');
        Except
          // Or a number.
          Try
            f1:=StrToFloat(ds1);
            f2:=StrToFloat(ds2);
            If f1<f2 then
              Result:=-1
            Else If f1>f2 then
              Result:=1
            Else
              Raise EConvertError.Create('');
          Except
            // Then just compare the text!
            Result:=CompareText(s1,s2);
          End;
        End;
      End;
    End;
    If Result=0 then
      Result:=CompareText(S,T);
  End;

  Procedure Exchange(I, J:LongInt);
  Var
    p:Pointer;
  Begin
    strings.Exchange(I,J);
    Try
      p:=BmpList[I];
      BmpList[I]:=BmpList[J];
      BmpList[J]:=p;
    Except
      If BmpList.Count<Items.Count then
        BmpList.Count:=Items.Count;
    End;
  End;

  Procedure Reheap(I, K: LongInt);
  Var
    J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
    Begin
      If DoCompare(strings[J Shl 1 - 1], strings[J Shl 1 + 1 - 1]) > 0 Then J := J Shl 1
      Else J := J Shl 1 + 1;
    End;
    If J Shl 1 = K Then J := K;

    While DoCompare(strings[I - 1], strings[J - 1]) > 0 Do J := J Shr 1;

    Exchange(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
    Begin
      Exchange(I - 1, J - 1);
      J := J Shr 1;
    End;
  End;

Var
  I, C: LongInt;
  s:string;
Begin

  strings.Create;
  For I:=0 to Items.Count-1 do
  Begin
    // Save the selected flag to be restored later.
    If Selected[I] then
      strings.AddObject('T'+Items[I],Items.Objects[I])
    Else
      strings.AddObject('F'+Items[I],Items.Objects[I]);
  End;
  C := strings.Count;
  For I := C Shr 1 DownTo 1 Do Reheap(I, C);
  For I := C DownTo 2 Do
  Begin
    Exchange(0, I - 1);
    Reheap(1, I - 1);
  End;
  Items.Clear;
  For I:=0 to strings.Count-1 do
  Begin
    s:=strings[I];
    Delete(s,1,1);
    Items.AddObject(s,strings.Objects[I]);
    Selected[I]:=(strings[I][1]='T');
  End;
  strings.Free;
End;

Procedure TMultiColumnListBox.SetupComponent;
Begin
  Inherited SetupComponent;
  Style:=lbOwnerdrawFixed;
  BmpList:=TList.Create;
  sep_char:='|';
End;

Destructor TMultiColumnListBox.Destroy;
Begin
  Inherited Destroy;
  BmpList.Free;
End;

Procedure TMultiColumnListBox.Clear;
Begin
  Inherited Clear;
  BmpList.Clear;
End;

Function TMultiColumnListBox.Add(s:string):LongInt;
Begin
  Result:=Items.Add(s);
  If BmpList.Count<Items.Count then
    BmpList.Count:=Items.Count;
End;

Function TMultiColumnListBox.AddObject(s:string;o:TObject):LongInt;
Begin
  Result:=Items.AddObject(s,o);
  If BmpList.Count<Items.Count then
    BmpList.Count:=Items.Count;
End;

Procedure TMultiColumnListBox.DrawItem(Index:LONGINT;Rec:TRect;State:TOwnerDrawState);
Var
  x,y,y1,cx,cy,cx1,cy1:LONGINT;
  idx,i:LONGINT;
  s,s1:STRING;
  rec1:TRect;
  bmp:TBitmap;
Begin
  If State * [odSelected] <> [] Then
  Begin
    Canvas.Pen.Color := clHighLightText;
    Canvas.Brush.Color := clHighLight;
  End Else
  Begin
    If Not Enabled then
      Canvas.Pen.Color := clDkGray
    Else
      Canvas.Pen.Color := PenColor;
    Canvas.Brush.Color := Color;
  End;
  Rec.Top:=Rec.Top-1;
  Canvas.FillRect(Rec,Canvas.Brush.Color);

  x := Rec.Left + 2;
  y := Rec.Bottom;
  cx := Rec.Right - x;
  cy := Rec.Top - y;

  Try
    bmp:=TBitmap(BmpList[Index]);
  Except
    bmp:=Nil;
  End;
  i := 1;
  s := Items.Strings[Index];
  While (i<=sections.Count) And (s<>'') do
  Begin
    idx:=Pos(sep_char,s);
    If idx=0 Then
    Begin
      s1:=s;
      s:='';
    End Else
    Begin
      s1:=s;
      SubStr(s1,1,idx-1);
      Delete(s,1,idx);
    End;
    rec1.top:=rec.top+50;
    If rec1.top<2 then
      Exit;
    rec1.bottom:=rec.bottom;
    If rec1.bottom<2 then
      rec1.bottom:=2;
    rec1.left:=sections.Items[i-1].Left;
    rec1.right:=sections.Items[i-1].Right;
    If (i=1) And (bmp<>Nil) then
    Begin
      cx1:=bmp.Width;
      cy1:=bmp.Height;
    End Else
      Canvas.GetTextExtent(s1,cx1,cy1);
    If sections[i-1].Alignment=taRightJustify then
    Begin
      x:=sections[i-1].Right-2-cx1;
    End Else
    Begin
      If sections[i-1].Alignment=taLeftJustify then
        x:=sections[i-1].Left+2
      Else
        x:=(sections[i-1].Left+sections[i-1].Right-cx1)/2+2;
    End;
    y1 := y + ((cy - cy1) Div 2);
    If y1 < Rec.Bottom Then y1 := Rec.Bottom;
    If (i=1) And (bmp<>Nil) then
    Begin
      Canvas.Draw(x,y1,bmp);
    End Else Begin
      Canvas.Brush.Mode := bmTransparent;
      Canvas.TextRect(rec1,x,y1,s1);
    End;
    i := i + 1;
  End;
End;

Function TMultiColumnListBox.GetSepChar:string;
Begin
  Result:=sep_char;
End;

Procedure TMultiColumnListBox.SetSepChar(Value:string);
Begin
  sep_char:=Value;
End;

Function TMultiColumnListBox.GetBitmap(Index:LongInt):TBitmap;
Begin
  If (Index<0) Or (Index>=BmpList.Count) then
    Result:=Nil
  Else
    Result:=BmpList[Index];
End;

Procedure TMultiColumnListBox.SetBitmap(Index:LongInt; bmp:TBitmap);
Begin
  If BmpList.Count<Items.Count then
    BmpList.Count:=Items.Count;
  If BmpList.Count>Index then
    BmpList[Index]:=bmp;
End;

Procedure TMultiColumnListBox.SetHeader(s: THeaderSections);
Begin
  sections:=s;
End;

Function MultiColumnList.GetValue(field,index:LongInt):string;
Var
  i, p: LongInt;
Begin
  If (index>=List.Items.Count) Or (field<0) Or (index<0) then
    Result:=''
  Else Begin
    Result:=List.Items[index];
    For i:=0 to field-1 do
    Begin
      If Length(Result)>0 then
      Begin
        p:=Pos(List.Separator,Result);
        If p>0 then
          System.Delete(Result,1,p);
      End;
    End;
    If Length(Result)>0 then
    Begin
      p:=Pos(List.Separator,Result);
      If p>0 then
        SubStr(Result,1,p-1);
    End;
  End;
End;

Procedure MultiColumnList.SetValue(field,index:LongInt;Value:string);
Var
  i, p: LongInt;
  sl,sr,s:string;
Begin
  If (field<sections.Count) And (index<List.Items.Count) And
     (field>=0) And (index>=0) then
  Begin
    sr:=List.Items[index];
    sl:='';
    For i:=0 to field-1 do
    Begin
      p:=Pos(List.Separator,sr);
      If p>0 then
      Begin
        s:=sr;
        System.SubStr(s,1,p-1);
        System.Delete(sr,1,p);
      End;
      sl:=sl+s+List.Separator;
    End;
    p:=Pos(List.Separator,sr);
    If p>0 then
    Begin
      System.Delete(sr,1,p);
      List.Items[Index]:=sl+Value+List.Separator+sr;
    End Else
      List.Items[Index]:=sl+Value;
  End;
End;

Function MultiColumnList.GetSepChar:string;
Begin
  Result:=List.Separator;
End;

Procedure MultiColumnList.SetSepChar(Value:string);
Begin
  List.Separator:=Value;
End;

Function MultiColumnList.GetHint:string;
Begin
  Result:=List.Hint;
End;

Procedure MultiColumnList.SetHint(Value:string);
Begin
  List.Hint:=Value;
End;

Procedure MultiColumnList.SetEnabled(Value:Boolean);
Begin
  Fenabled:=Value;
  If Fenabled then
  Begin
    Header.Enabled:=True;
    List.Enabled:=True;
    Header.PenColor:=clBlack;
  End Else
  Begin
    Header.Enabled:=False;
    List.Enabled:=False;
    Header.PenColor:=clDkGray;
  End;
End;

Function MultiColumnList.GetHeaderHint:string;
Begin
  Result:=Header.Hint;
End;

Procedure MultiColumnList.SetHeaderHint(Value:string);
Begin
  Header.Hint:=Value;
End;

Function MultiColumnList.GetShowDragRects:Boolean;
Begin
  Result:=List.ShowDragRects;
End;

Procedure MultiColumnList.SetShowDragRects(Value:Boolean);
Begin
  List.ShowDragRects:=Value;
End;

Function MultiColumnList.GetTheFont:TFont;
Begin
  Result:=List.Font;
End;

Procedure MultiColumnList.SetTheFont(Value:TFont);
Begin
  List.Font:=Value;
  Header.Font:=Value;
End;

Function MultiColumnList.GetSections:THeaderSections;
Begin
  Result := Header.sections;
End;

//gehn
Function MultiColumnList.GetSectionsCount:LongInt;
Begin
  Result := GetSections.Count;
End;

//gehn
Function MultiColumnList.GetSectionsItem(Index:LongInt):THeaderSection;
Begin
  If (Index < 0) or (Index > GetSectionsCount-1) then
    Begin
      Result := Nil;
    End
  else
    Begin
      Result := Header.Sections.Items[Index];
    End;
End;
//gehn
Procedure MultiColumnList.SetSectionsItemText(Index:LongInt; NewText:String);
Var
  SectionsItem: THeaderSection;
Begin
  If (Index > 0) or (Index < GetSectionsCount-1) then
  Begin
    SectionsItem := GetSectionsItem(Index);
    SectionsItem.Text := NewText;
    Header.Sections.Items[Index] := SectionsItem;
  End;
End;

Procedure MultiColumnList.SetSections(Value:THeaderSections);
Begin
  Header.sections := Value;
End;

Function MultiColumnList.GetDuplicates:Boolean;
Begin
  Result:=List.Duplicates;
End;

Procedure MultiColumnList.SetDuplicates(Value:Boolean);
Begin
  List.Duplicates:=Value;
End;

Function MultiColumnList.GetExtendedSelect:Boolean;
Begin
  Result:= List.ExtendedSelect;
End;

Procedure MultiColumnList.SetExtendedSelect(Value:Boolean);
Begin
  List.ExtendedSelect:= Value;
End;

Function MultiColumnList.GetItemIndex:LongInt;
Begin
  Result:= List.ItemIndex;
End;

Procedure MultiColumnList.SetItemIndex(Value:LongInt);
Begin
  List.ItemIndex:= Value;
End;

Function MultiColumnList.GetMultiSelect:Boolean;
Begin
  Result:= List.MultiSelect;
End;

Procedure MultiColumnList.SetMultiSelect(Value:Boolean);
Begin
  List.MultiSelect:= Value;
End;

Function MultiColumnList.GetOnItemFocus:TItemFocusEvent;
Begin
  Result:= List.OnItemFocus;
End;

Procedure MultiColumnList.SetOnItemFocus(Value:TItemFocusEvent);
Begin
  List.OnItemFocus:= Value;
End;

Function MultiColumnList.GetOnItemSelect:TItemSelectEvent;
Begin
  Result:= List.OnItemSelect;
End;

Procedure MultiColumnList.SetOnItemSelect(Value:TItemSelectEvent);
Begin
  List.OnItemSelect:= Value;
End;

Function MultiColumnList.GetSelCount:LongInt;
Begin
  Result:= List.SelCount;
End;

Function MultiColumnList.GetSelected(Index:LongInt):Boolean;
Begin
  Result:= List.Selected[Index];
End;

Procedure MultiColumnList.SetSelected(Index:LongInt;Value:Boolean);
Begin
  List.Selected[Index]:= Value;
End;

Function MultiColumnList.GetBitmap(Index:LongInt):TBitmap;
Begin
  Result:=List.Bitmaps[Index];
End;

Procedure MultiColumnList.SetBitmap(Index:LongInt; bmp:TBitmap);
Begin
  List.Bitmaps[Index]:=bmp;
End;

Function MultiColumnList.GetObjects(Index:LongInt):TObject;
Begin
  Result:=List.Items.Objects[Index];
End;

Procedure MultiColumnList.SetObjects(Index:LongInt;Value:TObject);
Begin
  List.Items.Objects[Index]:=Value;
End;

Function MultiColumnList.GetCount;
Begin
  Result:=List.Items.Count;
End;

Procedure MultiColumnList.EvSectionPressed(sender: THeaderControl; section: THeaderSection);
Begin
  Sort(section.Index);
End;

Procedure MultiColumnList.EvSectionTrack(sender: THeaderControl; section: THeaderSection; width: LongInt; State:TSectionTrackState);
Begin
  If state = tsTrackEnd then Invalidate;
End;

Procedure MultiColumnList.SetupComponent;
Begin
  Inherited SetupComponent;

  Name:='MultiColumnList';
  Width:=150;
  Height:=150;
  ParentPenColor := True;
  ParentColor := True;
  ParentFont := True;
  TabStop := False;

  Header.Create(Self);
  Header.Align:=alTop;
  Header.parent:=Self;
  Header.height:=25;
  Header.OnSectionClick:=EvSectionPressed;
  Header.OnSectionTrack:=EvSectionTrack;
  Header.ParentFont:=True;
  Header.TabStop:=False;
  If Designed Then Include(Header.ComponentState, csDetail);

  List.Create(Self);
  List.SetHeader(Header.Sections);
  List.Align:=alBottom;
  List.parent:=Self;
  List.height:=height-24;
  List.ParentFont:=True;
  List.OnDragDrop:=EvDragDrop;
  List.OnCanDrag:=EvCanDrag;
  List.OnDragOver:=EvDragOver;
  List.TabStop:=True;
  If Designed Then Include(List.ComponentState, csDetail);
End;

Procedure MultiColumnList.SetupShow;
Begin
  Inherited SetupShow;

  Resize;
End;

Procedure MultiColumnList.Resize;
Begin
  Inherited Resize;

  Header.height:=25;
  List.height:=height-24;
End;


Constructor MultiColumnList.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  Fenabled:=True;
End;

Destructor MultiColumnList.Destroy;
Begin
  Inherited Destroy;
End;

Function MultiColumnList.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
  Result := Inherited WriteSCUResource(Stream);
  If Not Result Then Exit;
  Result := List.WriteSCUResource(Stream);
  If Not Result Then Exit;
  Result := Header.WriteSCUResource(Stream);
End;

Procedure MultiColumnList.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
  List.ReadSCUResource(ResName,Data,DataLen);
  Header.ReadSCUResource(ResName,Data,DataLen);
  Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure MultiColumnList.SelectAll;
Var
  i:LongInt;
Begin
  List.BeginUpdate;
  For i:=0 to List.Items.Count-1 do
    Selected[i]:=True;
  List.EndUpdate;
End;

Procedure MultiColumnList.DeselectAll;
Var
  i:LongInt;
Begin
  List.BeginUpdate;
  For i:=0 to List.Items.Count-1 do
    Selected[i]:=False;
  List.EndUpdate;
End;

Function MultiColumnList.Add(s:string):LongInt;
Begin
  Result:=List.Add(s);
End;

Function MultiColumnList.AddObject(s:string;o:TObject):LongInt;
Begin
  Result:=List.AddObject(s,o);
End;

Procedure MultiColumnList.Delete(Index:LongInt);
Begin
  List.Items.Delete(Index);
End;

Procedure MultiColumnList.Clear;
Begin
  List.Clear;
End;

Function MultiColumnList.ItemRect(Index:LongInt):TRect;
Begin
  Result:=List.ItemRect(Index);
End;

Procedure MultiColumnList.SetDragMode(Value:TDragMode);
Begin
  drag_mode:=Value;
  List.DragMode:=Value;
End;

Procedure MultiColumnList.EvCanDrag(sender: TObject; X,Y: LongInt; var Accept: Boolean);
Begin
  If OnCanDrag<>Nil then
    OnCanDrag(Self,X,Y,Accept);
End;

Procedure MultiColumnList.EvDragDrop(sender: TObject; source: TObject; X,Y: LongInt);
Begin
  If OnDragDrop<>Nil then
    OnDragDrop(Self,source,X,Y);
End;

Procedure MultiColumnList.EvDragOver(sender: TObject; source: TObject; X,Y: LongInt; State: TDragState; var Accept: Boolean);
Begin
  If OnDragOver<>Nil then
    OnDragOver(Self,source,X,Y,state,Accept);
End;

Function MultiColumnList.IsDraggedSourceMe(source: TObject):Boolean;
Begin
  Result:=(source=Self) Or (source=List);
End;

Procedure MultiColumnList.Sort(section:Integer);
Begin
  List.Sort(section);
End;

Function MultiColumnList.IndexOf(s:string):LongInt;
Begin
  Result:=List.Items.IndexOf(s);
End;

Procedure MultiColumnList.BeginUpdate;
Begin
  List.BeginUpdate;
End;

Procedure MultiColumnList.EndUpdate;
Begin
  List.EndUpdate;
End;

Initialization
  {Register classes}
  RegisterClasses([MultiColumnList,TMultiColumnListBox]);
End.

