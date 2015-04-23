
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit FileCtrl;

Interface

Uses Dos,SysUtils,Classes,Forms,StdCtrls;


Type
    TDirectoryListBox=Class;
    TDriveComboBox=Class;
    TFilterComboBox=Class;


    {ftVolumnID has no effect, but exists For compatibility Of TFileAttr}
    TFileAttr=(ftReadOnly,ftHidden,ftSystem,ftVolumeID,ftDirectory,ftArchive,
         ftNormal);
    TFileType=Set Of TFileAttr;

    TFileListBox=Class(TListBox)
      Private
         FMask:String;
         FOldMask:String;
         FDirectory:String;
         FOldDirectory:String;
         FFileType:TFileType;
         FOldFileType:TFileType;
         FFileEdit:TEdit;
         FDirList:TDirectoryListBox;
         FFilterCombo:TFilterComboBox;
         FOnChange:TNotifyEvent;
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirectory(NewDir:String);
         Procedure SetFileName(NewFile:String);
         Function GetFileName:String;
         Procedure SetMask(NewMask:String);
         Procedure SetFileType(Attr:TFileType);
         Procedure SetFileEdit(NewEdit:TEdit);
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemFocus(Index:LongInt);Override;
         Procedure Change;Virtual;
         Property Duplicates;
         Property Sorted;
         Procedure SetupShow;Override;
      Public
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property FileName:String Read GetFileName Write SetFileName;
         Property Directory:String Read FDirectory Write SetDirectory;
         Property Drive:Char Read GetDrive Write SetDrive;
         Property Items;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ExtendedSelect;
         Property FileEdit:TEdit Read FFileEdit Write SetFileEdit;
         Property FileType:TFileType Read FFileType Write SetFileType;
         Property Font;
         Property HorzScroll;
         Property IntegralHeight;
         Property ItemHeight;
         Property Mask:String Read fMask Write SetMask;
         Property MultiSelect;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowDragRects;
         Property ShowHint;
         Property Style;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDrawItem;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMeasureItem;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TDirectoryListBox=Class(TListBox)
      Private
         FDirectory:String;
         FOldDirectory:String;
         FDirLabel:TLabel;
         FFileList:TFileListBox;
         FDriveCombo:TDriveComboBox;
         FOnChange:TNotifyEvent;
         Procedure SetDirectory(NewDir:String);
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirLabel(ALabel:TLabel);
         Procedure SetFileListBox(AFileList:TFileListBox);
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Procedure DrawOpenFolder(X,Y:LongInt);
         Procedure DrawClosedFolder(X,Y:LongInt);
         Procedure MeasureItem(Index:LongInt;Var Width,Height:LongInt);Override;
         Procedure DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);Override;
         Procedure SetupShow;Override;
         Property Duplicates;
         Property ExtendedSelect;
         Property ItemHeight;
         Property MultiSelect;
         Property Sorted;
         Property Style;
         Property OnDrawItem;
         Property OnMeasureItem;
      Public
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Directory:String Read FDirectory Write SetDirectory;
         Property Drive:Char Read GetDrive Write SetDrive;
         Property Items;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DirLabel:TLabel Read FDirLabel Write SetDirLabel;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property FileList:TFileListBox Read FFileList Write SetFileListBox;
         Property Font;
         Property HorzScroll;
         Property IntegralHeight;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowDragRects;
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


    {$HINTS OFF}
    TDriveComboBox=Class(TComboBox)
      Private
         FDrive:Char;
         FDirList:TDirectoryListBox;
         FOnChange:TNotifyEvent;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirListBox(ADirList:TDirectoryListBox);
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Property Duplicates;
         Property MaxLength;
         Property SelLength;
         Property SelStart;
         Property SelText;
         Property Sorted;
         Property Style;
         Property TextExtension;
      Public
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Drive:Char Read FDrive Write SetDrive;
         Property Items;
         Property Text;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DirList:TDirectoryListBox Read FDirList Write SetDirListBox;
         Property DragCursor;
         Property DragMode;
         Property DropDownCount;
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
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDropDown;
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
    {$HINTS ON}


    {$HINTS OFF}
    TFilterComboBox=Class(TComboBox)
      Private
         FFilter:String;
         FFileList:TFileListBox;
         FMaskList:TStringList;
         FOnChange:TNotifyEvent;
         Procedure SetFilter(NewFilter:String);
         Procedure SetFileListBox(AFileList:TFileListBox);
         Function GetMask:String;
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure SetupShow;Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Property Duplicates;
         Property Mask:String Read GetMask;
         Property MaxLength;
         Property SelLength;
         Property SelStart;
         Property SelText;
         Property Sorted;
         Property Style;
         Property TextExtension;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Items;
         Property Text;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property DropDownCount;
         Property Enabled;
         Property FileList:TFileListBox Read FFileList Write SetFileListBox;
         Property Filter:String Read FFilter Write SetFilter;
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
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDropDown;
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
    {$HINTS ON}



Function InsertFileListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TFileListBox;
Function InsertDirectoryListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TDirectoryListBox;
Function InsertDriveComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TDriveComboBox;
Function InsertFilterComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TFilterComboBox;


Implementation

{$IFDEF OS2}
Uses BseDos;
{$ENDIF}

{$IFDEF Win95}
Uses WinBase;
{$ENDIF}


Function InsertFileListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TFileListBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertDirectoryListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TDirectoryListBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertDriveComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TDriveComboBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertFilterComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TFilterComboBox;
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
บ This section: TFileListBox Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFileListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FileListBox';
     Sorted := True;
     FFileType := [ftNormal];
     Mask := '';
     Directory := '';
End;


Procedure TFileListBox.ItemFocus(Index:LongInt);
Begin
     Inherited ItemFocus(Index);

     Change;
End;


Procedure TFileListBox.BuildList;
{$IFDEF OS2}
Const AttrSet:Array[TFileAttr] Of Word = (faReadOnly,faHidden,faSysFile,0,faDirectory,faArchive,0);
{$ENDIF}
{$IFDEF WIN32}
Const AttrSet:Array[TFileAttr] Of Word = (faReadOnly,faHidden,faSysFile,0,faDirectory,faArchive,faArchive);
{$ENDIF}
Var  Search:TSearchRec;
     Status:Integer;
     Attr:Word;
     AttrIndex:TFileAttr;
     S,s1:String;
Begin
     If FDirectory=FOldDirectory Then
       If FMask=FOldMask Then
         If FFileType=FOldFileType Then exit; //same dir
     FOldDirectory:=FDirectory;
     FOldMask:=FMask;
     FOldFileType:=FFileType;

     BeginUpdate;
     Clear;

     Attr := 0;
     For AttrIndex := Low(TFileAttr) To High(TFileAttr) Do
     Begin
          If FFileType * [AttrIndex] <> []
          Then Attr := Attr Or AttrSet[AttrIndex];
     End;

     S:=fMask;
     While S<>'' Do
     Begin
          If Pos(';',S)<>0 Then
          Begin
               s1:=S;
               Delete(s1,1,Pos(';',S));
               SetLength(S,Pos(';',S)-1);
          End
          Else s1:='';

          Status := FindFirst(FDirectory + '\' + S, Attr,Search);
          While Status = 0 Do
          Begin
               If Search.Attr And faDirectory = faDirectory Then
               Begin
                    Items.Add('['+ Search.Name +']');
               End
               Else Items.Add(Search.Name);
               Status := FindNext(Search);
          End;
          S:=s1;
     End;

     EndUpdate;
End;


Function TFileListBox.GetDrive:Char;
Begin
     Result := FDirectory[1];
End;


Procedure TFileListBox.SetDrive(NewDrive:Char);
Var  NewDir:String;
Begin
     If UpCase(NewDrive) <> UpCase(Drive) Then
     Begin
          {Change To Current Directory At NewDrive}
          {$I-}
          GetDir(Ord(UpCase(NewDrive))-Ord('A')+1, NewDir);
          {$I+}
          If IOResult = 0 Then SetDirectory(NewDir);
     End;
End;

Procedure TFileListBox.SetDirectory(NewDir:String);
Var s:String;
Begin
     If NewDir = '' Then
     Begin
          {$I-}
          GetDir(0,NewDir);
          {$I+}
     End;

     If Pos(':',NewDir)<>2 Then
     Begin
          {$I-}
          GetDir(Ord(UpCase(Drive))-Ord('A')+1,s);
          {$I+}
          If (s[length(s)])='\' Then dec(s[0]);
          If not (NewDir[1] In ['/','\']) Then s:=s+'\';
          NewDir:=s+NewDir;
     End;

     If NewDir[Length(NewDir)] = '\' Then SetLength(NewDir,Length(NewDir)-1);
     If FDirectory=NewDir Then exit;
     FDirectory := NewDir;

     If Handle<>0 Then BuildList;
     Change;

     If FDirList <> Nil Then
     Begin
          If uppercase(FDirList.Directory) <> uppercase(Directory)
          Then FDirList.Directory := Directory;
     End;
End;


Procedure TFileListBox.SetFileName(NewFile:String);
Var Dir,Name,Ext:String;
Begin
     If GetFileName <> NewFile Then
     Begin
          FSplit(NewFile,Dir,Name,Ext);
          If Dir='' Then
          Begin
              ItemIndex := Items.IndexOf(NewFile);
              Change;
          End
          Else
          Begin
              SetDirectory(Dir);
              SetFileName(Name+Ext);
          End;
     End;
End;


Function TFileListBox.GetFileName:String;
Var  idx:LongInt;
     s:String;
Begin
     idx := ItemIndex;
     If (idx < 0) Or (idx >= Items.Count) Then Result := ''
     Else Result := Items[idx];
     s:=Directory;
     If s[Length(s)] In ['\','/'] Then dec(s[0]);
     If s<>'' Then If Result<>'' Then Result:=s+'\'+Result;
End;


Procedure TFileListBox.SetMask(NewMask:String);
Begin
     If NewMask <> '' Then
     Begin
          If FMask=NewMask Then exit;
          FMask := NewMask
     End
     Else
     Begin
          If FMask='*.*' Then exit;
          FMask := '*.*';
     End;

     If Handle<>0 Then BuildList;
     Change;
End;


Procedure TFileListBox.SetFileEdit(NewEdit:TEdit);
Begin
     FFileEdit := NewEdit;
     If FFileEdit <> Nil Then
     Begin
          FFileEdit.FreeNotification(Self);
          If FileName <> '' Then FFileEdit.Caption := FileName
          Else FFileEdit.Caption := Mask;
     End;
End;


Procedure TFileListBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFileEdit Then FFileEdit := Nil;
End;


Procedure TFileListBox.SetFileType(Attr:TFileType);
Begin
     If FFileType <> Attr Then
     Begin
          FFileType := Attr;
          If Handle<>0 Then BuildList;
          Change;
     End;
End;


Procedure TFileListBox.Change;
Begin
     If FFileEdit <> Nil Then
     Begin
          If FileName <> '' Then FFileEdit.Caption := FileName
          Else FFileEdit.Caption := Mask;

          FFileEdit.SelectAll;
     End;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Function TFileListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

Procedure TFileListBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TDirectoryListBox Class Implementation                      บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TDirectoryListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'DirectoryListBox';
     sorted := True;
     Directory := '';
     Style:=lbOwnerDrawFixed;
End;

Procedure TDirectoryListBox.MeasureItem(Index:LongInt;Var Width,Height:LongInt);
Begin
   Inherited MeasureItem(Index,Width,Height);
   If Height<15 Then Height:=15;
End;

Procedure TDirectoryListBox.DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);
Var X,Y,Y1,CX,CY,cx1,cy1:LongInt;
    S,Dir,Dir1:String;
    t:LongInt;
Begin
     If State * [odSelected] <> [] Then
     Begin
          Canvas.Pen.color := clHighlightText;
          Canvas.Brush.color := clHighlight;
     End
     Else
     Begin
          Canvas.Pen.color := PenColor;
          Canvas.Brush.color := color;
     End;
     Canvas.FillRect(rec,Canvas.Brush.color);

     X := rec.Left + 1;
     Y := rec.Bottom + 1;
     CX := rec.Right - X;
     CY := rec.Top - Y;

     S := Items.Strings[Index];

     For t:=1 To Length(S) Do
      If S[t] In ['\','/'] Then inc(X,2);

     If Index>0 Then inc(X,2);
     Y1:=Y+((CY-13) Div 2);
     If Y1 < rec.Bottom+1 Then Y1 := rec.Bottom+1;
     inc(Y1);
     Dir:=Directory;
     UpcaseStr(Dir);
     Dir1:=S;
     UpcaseStr(Dir1);
     If ((Index=0)Or(Pos(Dir1,Dir)<>0)) Then DrawOpenFolder(X,Y1)
     Else DrawClosedFolder(X,Y1);
     inc(X,20);

     t:=Pos('\',S);
     If t=0 Then t:=Pos('/',S);
     If Index>0 Then While t<>0 Do
     Begin
          Delete(S,1,t);
          t:=Pos('\',S);
          If t=0 Then t:=Pos('/',S);
     End;

     Canvas.GetTextExtent(S,cx1,cy1);
     Y := Y + ((CY - cy1) Div 2);
     If Y < rec.Bottom Then Y := rec.Bottom;
     Canvas.Brush.Mode := bmTransparent;
     Canvas.TextOut(X,Y,S);
     Canvas.Brush.Mode := bmOpaque;
End;

Procedure TDirectoryListBox.DrawOpenFolder(X,Y:LongInt);
Var SaveBrushColor,SavePenColor:TColor;
Begin
    SaveBrushColor:=Canvas.Brush.Color;
    SavePenColor:=Canvas.Pen.Color;

    Canvas.Brush.Style:=bsDiagCross;
    Canvas.Brush.Color:=clYellow;
    Canvas.Pen.Color:=clWhite;
    Canvas.Polygon([Point(X+3,Y),Point(X+16,Y),Point(X+16,Y+10),
                    Point(X+15,Y+10),Point(X+14,Y+12),Point(X+10,Y+12),
                    Point(X+9,Y+10),Point(X+3,Y+10),Point(X+3,Y+8),
                    Point(X,Y+8)]);


    Canvas.PenPos:=Point(X+3,Y);
    Canvas.Pen.Color:=clBlack;
    Canvas.LineTo(X+16,Y);
    Canvas.LineTo(X+16,Y+10);
    Canvas.LineTo(X+15,Y+10);
    Canvas.LineTo(X+14,Y+12);
    Canvas.LineTo(X+10,Y+12);
    Canvas.LineTo(X+9,Y+10);
    Canvas.LineTo(X+3,Y+10);
    Canvas.LineTo(X+3,Y+8);

    Canvas.PenPos:=Point(X+16,Y);
    Canvas.LineTo(X+13,Y+8);
    Canvas.LineTo(X,Y+8);
    Canvas.LineTo(X+3,Y);

    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=SaveBrushColor;
    Canvas.Pen.Color:=SavePenColor;
End;

Procedure TDirectoryListBox.DrawClosedFolder(X,Y:LongInt);
Var SaveBrushColor,SavePenColor:TColor;
Begin
    SaveBrushColor:=Canvas.Brush.Color;
    SavePenColor:=Canvas.Pen.Color;

    Canvas.Brush.Style:=bsDiagCross;
    Canvas.Brush.Color:=clYellow;
    Canvas.Pen.Color:=clWhite;
    Canvas.Polygon([Point(X+3,Y),Point(X+16,Y),Point(X+16,Y+10),
                    Point(X+15,Y+10),Point(X+14,Y+12),Point(X+10,Y+12),
                    Point(X+9,Y+10),Point(X+3,Y+10)]);

    Canvas.PenPos:=Point(X+3,Y);
    Canvas.Pen.Color:=clBlack;
    Canvas.LineTo(X+16,Y);
    Canvas.LineTo(X+16,Y+10);
    Canvas.LineTo(X+15,Y+10);
    Canvas.LineTo(X+14,Y+12);
    Canvas.LineTo(X+10,Y+12);
    Canvas.LineTo(X+9,Y+10);
    Canvas.LineTo(X+3,Y+10);
    Canvas.LineTo(X+3,Y);

    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=SaveBrushColor;
    Canvas.Pen.Color:=SavePenColor;
End;

Procedure TDirectoryListBox.ItemSelect(Index:LongInt);
Var S,S1:String;
    t:LongInt;
Begin
     If (Index < 0) Or (Index > Items.Count-1) Then Exit;

     S := Items.Strings[Index];
     Directory:=S;

     Inherited ItemSelect(Index);

     UpcaseStr(S);
     For t:=0 To Items.Count-1 Do
     Begin
         S1:=Items[t];
         UpcaseStr(S1);
         If S=S1 Then
         Begin
              ItemIndex:=t;
              exit;
         End;
     End;
End;

Procedure TDirectoryListBox.BuildList;
Var  S,S1:String;
     Search:TSearchRec;
     Status:Integer;
     b:Byte;
     t:LongInt;
     Dir:String;
Begin
     If FDirectory=FOldDirectory Then exit; //same dir
     FOldDirectory:=FDirectory;

     BeginUpdate;
     Clear;

     //Add Drive
     Items.Clear;
     Items.Add(Drive+':\');

     //Add all subdirs
     S:=Directory;
     S[3]:=#1; //replace \
     b:=Pos('\',S);
     If b=0 Then b:=Pos('/',S);
     While b<>0 Do
     Begin
          S1:=Copy(s,1,b-1);
          S[b]:=#1; //replace \

          For t:=1 To Length(S1) Do If S1[t]=#1 Then S1[t]:='\'; //replace #
          Items.Add(S1);

          b:=Pos('\',S);
          If b=0 Then b:=Pos('/',S);
     End;
     For t:=1 To Length(S) Do If S[t]=#1 Then S[t]:='\'; //replace #
     If length(S)>3 Then Items.Add(S);

     Dir:=Directory;
     If Dir[Length(Dir)] In ['\','/'] Then Dec(Dir[0]);
     Status := FindFirst(Dir+'\*.*',faDirectory,Search);
     While Status = 0 Do
     Begin
          S := Search.Name;
          If Search.Attr And faDirectory = faDirectory Then
          Begin
               {avoid .. In Mainpath}
               If S <> '.' Then
                 If S <> '..' Then Items.Add(Dir+'\'+S);
          End;
          Status := FindNext(Search);
     End;

     EndUpdate;
End;


Procedure TDirectoryListBox.SetDirectory(NewDir:String);
Var s:String;
Begin
     If NewDir = '' Then
     Begin
          {$I-}
          GetDir(0,NewDir);
          {$I+}
     End;

     If Pos(':',NewDir)<>2 Then
     Begin
          {$I-}
          GetDir(Ord(UpCase(Drive))-Ord('A')+1,s);
          {$I+}
          If (s[length(s)])='\' Then dec(s[0]);
          If not (NewDir[1] In ['/','\']) Then s:=s+'\';
          NewDir:=s+NewDir;
     End;

     If NewDir[Length(NewDir)] In ['\','/'] Then
       If Length(NewDir)>3 Then dec(NewDir[0]);
     If FDirectory=NewDir Then exit;
     FDirectory := NewDir;

     If Handle<>0 Then BuildList;
     Change;

     If FDriveCombo <> Nil Then
     Begin
          If UpCase(FDriveCombo.Drive) <> UpCase(Drive)
          Then FDriveCombo.Drive := Drive;
     End;
End;


Procedure TDirectoryListBox.SetDrive(NewDrive:Char);
Var  NewDir:String;
Begin
     If UpCase(NewDrive) <> UpCase(Drive) Then
     Begin
          {Change To Current Directory At NewDrive}
          {$I-}
          GetDir(Ord(UpCase(NewDrive))-Ord('A')+1, NewDir);
          {$I+}
          If IOResult = 0 Then SetDirectory(NewDir);
     End;
End;


Function TDirectoryListBox.GetDrive:Char;
Begin
     Result := FDirectory[1];
End;


Procedure TDirectoryListBox.SetDirLabel(ALabel:TLabel);
Begin
     FDirLabel := ALabel;
     If FDirLabel <> Nil Then
     Begin
          FDirLabel.FreeNotification(Self);
          FDirLabel.Caption := FDirectory;
     End;
End;


Procedure TDirectoryListBox.SetFileListBox(AFileList:TFileListBox);
Begin
     If FFileList <> Nil Then FFileList.FDirList := Nil;
     FFileList := AFileList;
     If FFileList <> Nil Then
     Begin
          FFileList.FDirList := Self;
          FFileList.FreeNotification(Self);
     End;
End;


Procedure TDirectoryListBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
     Begin
          If AComponent = FFileList Then FFileList := Nil;
          If AComponent = FDirLabel Then FDirLabel := Nil;
     End;
End;


Procedure TDirectoryListBox.Change;
Begin
     If FDirLabel <> Nil Then FDirLabel.Caption := FDirectory;
     If FFileList <> Nil Then FFileList.Directory := FDirectory;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Function TDirectoryListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

Procedure TDirectoryListBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TDriveComboBox Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TDriveComboBox.SetupComponent;
Var  DriveMap:LongWord;
     SDrive:Byte;
     actdir:String;
     {$IFDEF OS2}
     ActualDrive:LongWord;
     {$ENDIF}
Begin
     Inherited SetupComponent;

     Name := 'DriveComboBox';
     Style := csDropDownList;
     sorted := False;

     {Fill Drive Combo}
     {$IFDEF OS2}
     DosQueryCurrentDisk(ActualDrive,DriveMap);
     {$ENDIF}
     {$IFDEF Win95}
     DriveMap := GetLogicalDrives;
     {$ENDIF}
     For SDrive := 0 To 25 Do
     Begin
          If DriveMap And (1 Shl SDrive) <> 0 Then
          Begin
               actdir := Chr(SDrive + 65) + ':';
               Items.Add(actdir);
          End;
     End;

     {$I-}
     GetDir(0,actdir);
     {$I+}
     Drive := actdir[1];
End;


Procedure TDriveComboBox.ItemSelect(Index:LongInt);
Var  S:String;
Begin
     Inherited ItemSelect(Index);

     S := Text;
     If S <> '' Then Drive := S[1];
End;


Procedure TDriveComboBox.Change;
Begin
     If FDirList <> Nil Then FDirList.Drive := FDrive;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TDriveComboBox.SetDrive(NewDrive:Char);
Var S:String;
    T:LongInt;
    C:cstring;
    cc:^cstring;
    {$IFDEF Win95}
    sernum,complen,Flags:LongWord;
    FileSystem,volname:cstring;
    {$ENDIF}
Label L;
Begin
     NewDrive := UpCase(NewDrive);
     If UpCase(FDrive) = NewDrive Then Exit;

     S := Text;
     If NewDrive <> S[1] Then
     Begin
          For T := 0 To Items.Count-1 Do
          Begin
               S := Items.Strings[T];
               If UpCase(S[1]) = NewDrive Then
               Begin
                    Text := S;
                    Goto L;
               End;
          End;
          {Not found In List}
          NewDrive := FDrive;  {Use Current Drive}
     End;
L:
     FDrive := NewDrive;
     If Pos('[',S) = 0 Then
     Begin
          {determine volume id's}
          T := Items.IndexOf(S);
          If T <> -1 Then
          Begin
               FillChar(C,255,0);
               {$IFDEF OS2}
               DosErrorAPI(FERR_DISABLEHARDERR);      {no effect}
               DosQueryFSInfo(Ord(S[1])-64,FSIL_VOLSER,C,255);
               DosErrorAPI(FERR_ENABLEHARDERR);
               cc := @C[5];
               If cc^ <> '' Then S := S +' ['+ cc^ +']';
               {$ENDIF}
               {$IFDEF Win95}
               C := S[1] + ':\';
               volname := '';
               GetVolumeInformation(C,volname,255,sernum,complen,Flags,
                                    FileSystem,255);
               If volname <> '' Then S := S + ' ['+ volname +']';
               {$ENDIF}
               Text := S;
               Items[T] := S;
          End;
     End;

     Change;
End;


Procedure TDriveComboBox.SetDirListBox(ADirList:TDirectoryListBox);
Begin
     If FDirList <> Nil Then FDirList.FDriveCombo := Nil;
     FDirList := ADirList;
     If FDirList <> Nil Then
     Begin
          FDirList.FDriveCombo := Self;
          FDirList.FreeNotification(Self);
     End;
End;


Procedure TDriveComboBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FDirList Then FDirList := Nil;
End;


Function TDriveComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TDriveComboBox Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TFilterComboBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FilterComboBox';
     Style := csDropDownList;
     sorted := False;

     FFilter := LoadNLSStr(SAllFiles)+' (*.*)|*.*';
     FMaskList.Create;
End;


Procedure TFilterComboBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;


Destructor TFilterComboBox.Destroy;
Begin
     FMaskList.Destroy;
     FMaskList := Nil;

     Inherited Destroy;
End;


Procedure TFilterComboBox.ItemSelect(Index:LongInt);
Begin
     Inherited ItemSelect(Index);

     Text := Items[Index];
     Change;
End;


Procedure TFilterComboBox.Change;
Begin
     If FFileList <> Nil Then FFileList.Mask := Mask;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TFilterComboBox.BuildList;
Var  AMask,AFilter:String;
     S:String;
     P:Integer;
Begin
     BeginUpdate;
     Clear;
     FMaskList.Clear;

     S := FFilter;
     P := Pos('|',S);
     While P > 0 Do
     Begin
          AFilter := Copy(S,1,P-1);
          Delete(S,1,P);
          P := Pos('|',S);
          If P > 0 Then
          Begin
               AMask := Copy(S,1,P-1);
               Delete(S,1,P);
          End
          Else
          Begin
               AMask := S;
               S := '';
          End;
          Items.Add(AFilter);
          FMaskList.Add(AMask);
          P := Pos('|',S);
     End;
     EndUpdate;
     ItemIndex := 0;
End;


Procedure TFilterComboBox.SetFilter(NewFilter:String);
Begin
     If FFilter <> NewFilter Then
     Begin
          FFilter := NewFilter;
          BuildList;
          Change;
     End;
End;


Procedure TFilterComboBox.SetFileListBox(AFileList:TFileListBox);
Begin
     If FFileList <> Nil Then FFileList.FFilterCombo := Nil;
     FFileList := AFileList;
     If FFileList <> Nil Then
     Begin
          FFileList.FFilterCombo := Self;
          FFileList.FreeNotification(Self);
     End;
End;


Procedure TFilterComboBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFileList Then FFileList := Nil;
End;


Function TFilterComboBox.GetMask:String;
Var  idx:LongInt;
Begin
     idx := ItemIndex;
     If (idx < 0) Or (idx >= FMaskList.Count) Then Result := '*.*'
     Else Result := FMaskList[idx];
End;


Function TFilterComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;


Begin
End.
