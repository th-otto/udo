Unit CustomFileControls;

// 26/9/0
// Fixed filter combo box for when filter is invalid and results in
// no list entries: crashes because it tries to set item index to 0.
Interface

Uses
  Dos,
  SysUtils,
  Classes,
  Forms,
  StdCtrls,
  CustomListBox,
  Graphics;


Type
    TCustomDirectoryListBox=Class;
    TCustomDriveComboBox=Class;
    TCustomFilterComboBox=Class;

    {ftVolumnID has no effect, but exists For compatibility Of TFileAttr}
    TFileAttr=(ftReadOnly,ftHidden,ftSystem,ftVolumeID,ftDirectory,ftArchive,
         ftNormal);
    TFileType=Set Of TFileAttr;

    TCustomFilelistBox=Class(TCustomListBox)
      Private
         FMask: String;
         FExcludeMask: string;
         FOldMask: String;
         FDirectory: String;
         FOldDirectory: String;
         FFileType: TFileType;
         FOldFileType: TFileType;
         FFileEdit: TEdit;
         FFilterCombo: TCustomFilterComboBox;
         FOnChange: TNotifyEvent;
         FDirList: TCustomDirectoryListBox;
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirectory(NewDir:String);
         Procedure SetFileName(NewFile:String);
         Function GetFileName:String;
         Procedure SetMask(NewMask:String);
         Procedure SetExcludeMask(NewMask:String);
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
         Procedure Reload;
      Published
         Property FileEdit:TEdit Read FFileEdit Write SetFileEdit;
         Property FileType:TFileType Read FFileType Write SetFileType;
         Property Mask:String Read fMask Write SetMask;
         Property ExcludeMask:String Read fExcludeMask Write SetExcludeMask;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
    End;

    TCustomDirectoryListBox=Class(TListBox)
      Private
         FPictureOpen: TBitmap;
         FPictureClosed: TBitmap;
         FPictureOpenMask: TBitmap;
         FPictureClosedMask: TBitmap;
         FDirectory: String;
         FDirLabel: TLabel;
         FFileList: TCustomFileListBox;
         FOnChange: TNotifyEvent;
         FDriveCombo: TCustomDriveComboBox;
         Procedure SetDirectory(NewDir:String);
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirLabel(ALabel:TLabel);
         Procedure SetFilelistBox(AFileList:TCustomFileListBox);
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Procedure DrawOpenFolder( Var X: longint; Y: LongInt );
         Procedure DrawClosedFolder( Var X: longint; Y: LongInt );
         Procedure MeasureItem(Index:LongInt;Var Width,Height:LongInt);Override;
         Procedure DrawItem( Index: LongInt;
                             rec: TRect;
                             State: TOwnerDrawState );Override;
         Procedure SetupShow;Override;

         Procedure SetPictureOpen(NewBitmap:TBitmap);
         Procedure SetPictureClosed(NewBitmap:TBitmap);

         Property Duplicates;
         Property ExtendedSelect;
         Property MultiSelect;
         Property Sorted;
         Property Style;
         Property OnDrawItem;
         Property OnMeasureItem;
         Property Items;

      Public
         Destructor Destroy; Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Directory:String Read FDirectory Write SetDirectory;
         Property Drive:Char Read GetDrive Write SetDrive;
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
         Property FileList:TCustomFileListBox Read FFileList Write SetFilelistBox;
         Property Font;
         Property HorzScroll;
         Property IntegralHeight;
         Property ItemHeight;
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

         Property PictureClosed:TBitmap Read FPictureClosed Write SetPictureClosed;
         Property PictureOpen:TBitmap Read FPictureOpen Write SetPictureOpen;

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
    TCustomDriveComboBox=Class(TComboBox)
      Private
         FDirList:TCustomDirectoryListBox;
         FOnChange:TNotifyEvent;
         FLastIndex:longint;
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirListBox(ADirList:TCustomDirectoryListBox);
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
         Procedure DrawItem( Canvas: TCanvas;
                             S: string;
                             Data: TObject;
                             rec: TRect;
                             State: TOwnerDrawState );
      Public
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Drive:Char Read GetDrive Write SetDrive;
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
         Property DirList:TCustomDirectoryListBox Read FDirList Write SetDirListBox;
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
    TCustomFilterComboBox=Class(TComboBox)
      Private
         FFilter:String;
         FFileList:TCustomFilelistBox;
         FMaskList:TStringList;
         FOnChange:TNotifyEvent;
         Procedure SetFilter(NewFilter:String);
         Procedure SetFilelistBox(AFileList:TCustomFilelistBox);
         Function GetMask:String;
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure SetupShow;Override;
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
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Mask:String Read GetMask;
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
         Property FileList:TCustomFilelistBox Read FFileList Write SetFilelistBox;
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



Function InsertCustomFilelistBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilelistBox;
Function InsertCustomDirectoryListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDirectoryListBox;
Function InsertCustomDriveComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDriveComboBox;
Function InsertFilterComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilterComboBox;

Exports
  TCustomFileListBox, 'User', 'CustomFileListBox.bmp',
  TCustomDirectoryListBox, 'User', 'CustomDirectoryListBox.bmp';

Exports
  TCustomDriveComboBox, 'User', 'CustomDriveComboBox.bmp';

Exports
  TCustomFilterComboBox, 'User', 'CustomFilterComboBox.bmp';

Implementation

Uses
  BseDos,
  OS2Def,
  BseDev,
  BseErr,

  Dialogs,
  FileUtilsUnit,
  ACLUtility,
  BitmapUtility,
  StringUtilsUnit;

var
  DriveTypeBitmaps: array[ Low( TDriveType ).. High( TDriveType ) ] of TBitmap;
  DriveTypeBitmapMasks: array[ Low( TDriveType ).. High( TDriveType ) ] of TBitmap;

const
  DriveTypeBitmapNames: array[ Low( TDriveType ).. High( TDriveType ) ]  of string =
  (
    '',
    'FloppyDrive',
    'HardDrive',
    'CDDrive',
    'NetworkDrive',
    'RemovableDrive'
  );

{$R FileImages}

Function InsertCustomFilelistBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilelistBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertCustomDirectoryListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDirectoryListBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertCustomDriveComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDriveComboBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertFilterComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilterComboBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;

// ---------------------------------------------------------------------
// TCustomFilelistBox
// ---------------------------------------------------------------------

Procedure TCustomFilelistBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FileListBox';
     Sorted := True;
     FFileType := [ftNormal];
     Mask := '';
     Directory := '';
     ExcludeMask:='';
End;


Procedure TCustomFilelistBox.ItemFocus(Index:LongInt);
Begin
     Inherited ItemFocus(Index);

     Change;
End;

Procedure TCustomFilelistBox.BuildList;
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
     ExcludeList:TStringList;
     FindIndex:longint;
     ThisFilter: string;
     NextFilter: integer;
Begin
     FOldDirectory:=FDirectory;
     FOldMask:=FMask;
     FOldFileType:=FFileType;

     BeginUpdate;
     Clear;

     DosErrorAPI( FERR_DISABLEHARDERR );

     Attr := 0;
     For AttrIndex := Low(TFileAttr) To High(TFileAttr) Do
     Begin
          If FFileType * [AttrIndex] <> []
          Then Attr := Attr Or AttrSet[AttrIndex];
     End;

     // First make a list of files to exclude...
     ExcludeList:= TStringList.Create;
     ExcludeList.Sorted:= true;
     S:=fExcludeMask;
     While S<>'' Do
     Begin
          NextFilter:=Pos(PATH_SEPARATOR,S);
          If NextFilter<>0 Then
          Begin
            ThisFilter:=Copy( S, 1, NextFilter-1 );
            Delete( S, 1, NextFilter );
          End
          Else
          Begin
            ThisFilter:=S;
            S:='';
          End;

          Status := SysUtils.FindFirst(FDirectory + DIRECTORY_SEPARATOR + ThisFilter, Attr,Search);
          While Status = 0 Do
          Begin
               ExcludeList.Add( Search.Name );
               Status := SysUtils.FindNext(Search);
          End;
          SysUtils.FindClose( Search );
     End;

     // Now search for files to include...
     S:=fMask;
     While S<>'' Do
     Begin
          If Pos(PATH_SEPARATOR,S)<>0 Then
          Begin
               s1:=S;
               Delete(s1,1,Pos(PATH_SEPARATOR,S));
               SetLength(S,Pos(PATH_SEPARATOR,S)-1);
          End
          Else s1:='';

          Status := SysUtils.FindFirst(FDirectory + DIRECTORY_SEPARATOR + S, Attr,Search);
          While Status = 0 Do
          Begin
               if not ExcludeList.Find( Search.Name,
                                        FindIndex ) then
               begin
                    If Search.Attr And faDirectory = faDirectory Then
                    Begin
                         Items.Add( '['+ Search.Name +']' );
                    End
                    Else
                    Begin
                         Items.Add( Search.Name );
                    End;
               end;
               Status := SysUtils.FindNext(Search);
          End;
          SysUtils.FindClose( Search );
          S:=s1;
     End;

     DosErrorAPI( FERR_ENABLEHARDERR );

     ExcludeList.Destroy;
     EndUpdate;
End;


Function TCustomFilelistBox.GetDrive:Char;
Begin
     Result := FDirectory[1];
End;


Procedure TCustomFilelistBox.SetDrive(NewDrive:Char);
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

Procedure TCustomFilelistBox.SetDirectory(NewDir:String);
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
          If (s[length(s)])=DIRECTORY_SEPARATOR Then dec(s[0]);
          If not (NewDir[1] In ['/',DIRECTORY_SEPARATOR]) Then s:=s+DIRECTORY_SEPARATOR;
          NewDir:=s+NewDir;
     End;

     If NewDir[Length(NewDir)] = DIRECTORY_SEPARATOR Then SetLength(NewDir,Length(NewDir)-1);
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


Procedure TCustomFilelistBox.SetFileName(NewFile:String);
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


Function TCustomFilelistBox.GetFileName:String;
Var  idx:LongInt;
     s:String;
Begin
     idx := ItemIndex;
     If (idx < 0) Or (idx >= Items.Count) Then Result := ''
     Else Result := Items[ idx ];
     s:=Directory;
     If s[Length(s)] In [DIRECTORY_SEPARATOR,'/'] Then dec(s[0]);
     If s<>'' Then If Result<>'' Then Result:=s+DIRECTORY_SEPARATOR+Result;
End;


Procedure TCustomFilelistBox.SetMask(NewMask:String);
Begin
     If NewMask <> '' Then
     Begin
          If FMask=NewMask Then exit;
          FMask := NewMask
     End
     Else
     Begin
          If FMask='*' Then exit;
          FMask := '*';
     End;

     If Handle<>0 Then BuildList;
     Change;
End;

Procedure TCustomFilelistBox.SetExcludeMask(NewMask:String);
Begin
     If FExcludeMask=NewMask Then
       exit;
     FExcludeMask := NewMask;
     If Handle<>0 Then BuildList;
     Change;
End;

Procedure TCustomFilelistBox.SetFileEdit(NewEdit:TEdit);
Begin
     FFileEdit := NewEdit;
     If FFileEdit <> Nil Then
     Begin
          FFileEdit.FreeNotification(Self);
          If FileName <> '' Then FFileEdit.Caption := FileName
          Else FFileEdit.Caption := Mask;
     End;
End;


Procedure TCustomFilelistBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFileEdit Then FFileEdit := Nil;
End;


Procedure TCustomFilelistBox.SetFileType(Attr:TFileType);
Begin
     If FFileType <> Attr Then
     Begin
          FFileType := Attr;
          If Handle<>0 Then BuildList;
          Change;
     End;
End;


Procedure TCustomFilelistBox.Change;
Begin
     If FFileEdit <> Nil Then
     Begin
          If FileName <> '' Then FFileEdit.Caption := FileName
          Else FFileEdit.Caption := Mask;

          FFileEdit.SelectAll;
     End;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Function TCustomFilelistBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

Procedure TCustomFilelistBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;

Procedure TCustomFilelistBox.Reload;
Begin
     StartUpdate;
     If Handle<>0 Then BuildList;
     CompleteUpdate;
End;

// ---------------------------------------------------------------------
// CustomDirectoryListBox
// ---------------------------------------------------------------------

const
  dfSubDir = 256;
  dfErrorMessage = 512;

Procedure TCustomDirectoryListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'DirectoryListBox';

     Directory := '';

     Style:=lbOwnerDrawFixed;

     FDriveCombo:= nil;

     FPictureOpen:= TBitmap.Create;
     FPictureOpen.LoadFromResourceName( 'FolderOpen' );
     CreateMaskedBitmap( FPictureOpen, FPictureOpenMask, $ff00ff );

     FPictureClosed:= TBitmap.Create;
     FPictureClosed.LoadFromResourceName( 'FolderClosed' );
     CreateMaskedBitmap( FPictureClosed, FPictureClosedMask, $ff00ff );
End;

Destructor TCustomDirectoryListBox.Destroy;
begin
  FPictureOpen.Free;
  FPictureClosed.Free;
  inherited Destroy;
end;

Procedure TCustomDirectoryListBox.MeasureItem(Index:LongInt;Var Width,Height:LongInt);
Begin
   Inherited MeasureItem(Index,Width,Height);
   If Height<15 Then Height:=15;
End;

Procedure TCustomDirectoryListBox.DrawItem( Index: LongInt;
                                            rec: TRect;
                                            State: TOwnerDrawState );
Var
  X,Y,Y1,CX,CY,cx1,cy1:LongInt;
  S: String;
  Data: longint;
  IndentLevel: longint;
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
  dec( rec.top ); // minor adjustments since we seem to get a slightly
  inc( rec.left ); // incorrect area to draw on...

  Canvas.FillRect(rec,Canvas.Brush.color);

  X := rec.Left + 2;
  Y := rec.Bottom + 1;
  CX := rec.Right - X;
  CY := rec.Top - Y;

  S := '';
  Data := 0;
  if Index <> -1 then
  begin
    S := Items[ Index ];
    Data:= longint( Items.Objects[ Index ] );
  end;
  IndentLevel:= Data and 255;

  inc( X, IndentLevel * 5 );

  Y1:=rec.Bottom+((CY- FPictureOpen.Height ) Div 2);
  If Y1 < rec.Bottom+1 Then
    Y1 := rec.Bottom+1;
  inc(Y1);

  if ( Data and dfErrorMessage ) > 0 Then
    // error message - draw nothing

  else if ( Data and dfSubDir ) > 0 Then
    // subdir
    DrawClosedFolder( X, Y1 )
  else
    // parent dir
    DrawOpenFolder( X, Y1 );

  inc( X, 5 );

  Canvas.GetTextExtent(S,cx1,cy1);
  Y := Y + ((CY - cy1) Div 2);
  If Y < rec.Bottom Then
    Y := rec.Bottom;
  Canvas.Brush.Mode := bmTransparent;
  Canvas.TextOut(X,Y,S);
  Canvas.Brush.Mode := bmOpaque;
End;

Procedure TCustomDirectoryListBox.DrawOpenFolder( Var X: longint; Y: LongInt );
Var
  SaveBrushColor,SavePenColor:TColor;
Begin
  SaveBrushColor:=Canvas.Brush.Color;
  SavePenColor:=Canvas.Pen.Color;

  DrawMaskedBitmap( FPictureOpen,
                    FPictureOpenMask,
                    Canvas,
                    X, Y );

  if FPictureOpen <> nil then
    inc( X, FPictureOpen.Width );

  Canvas.Brush.Color:=SaveBrushColor;
  Canvas.Pen.Color:=SavePenColor;
End;

Procedure TCustomDirectoryListBox.DrawClosedFolder( Var X: longint; Y: LongInt );
Var
  SaveBrushColor,SavePenColor:TColor;
Begin
  SaveBrushColor:=Canvas.Brush.Color;
  SavePenColor:=Canvas.Pen.Color;

  DrawMaskedBitmap( FPictureClosed,
                    FPictureClosedMask,
                    Canvas,
                    X, Y );

  if FPictureClosed <> nil then
    inc( X, FPictureClosed.Width );

  Canvas.Brush.Color:=SaveBrushColor;
  Canvas.Pen.Color:=SavePenColor;
End;

Procedure TCustomDirectoryListBox.ItemSelect(Index:LongInt);
Var
  S: String;
  Data: longint;
  FullPath: string;
Begin
  If (Index < 0) Or (Index > Items.Count-1) Then Exit;

  Data := longint( Items.Objects[ Index ] );
  if ( Data and dfErrorMessage ) > 0 Then
    Exit; // error item

  FullPath:= Items[ Index ];
  dec( Index );
  while Index >= 0 do
  begin
    S := Items[ Index ];
    Data:= longint( Items.Objects[ Index ] );
    if ( Data and dfSubDir ) = 0 then
      FullPath:= AddDirectorySeparator( S ) + FullPath;
    dec( Index );
  end;

  Directory:= FullPath;

  Inherited ItemSelect(Index);
End;

Procedure TCustomDirectoryListBox.BuildList;
Var
  S: String;
  Search: TSearchRec;
  Status: Integer;
  Path: string;
  SubDirs: TStringList;
  IndentLevel: longint;
  PathSoFar: string;
  tmpPathElements : TStringList;
  i : integer;
Begin
  Screen.Cursor := crHourGlass;
  BeginUpdate;

  IndentLevel:= 0;

  // Add Drive
  Items.Clear;
  Items.AddObject( Drive+':\', pointer( IndentLevel ) );

  DosErrorAPI( FERR_DISABLEHARDERR );

  // Add all subdirs
  Path := Copy( Directory, 4, 255 );
  PathSoFar := Copy( Directory, 1, 3 );

  tmpPathElements := TStringList.Create;
  StrExtractStrings(tmpPathElements, Path, [DIRECTORY_SEPARATOR], #0);

  for i := 0 to tmpPathElements.Count - 1 do
  begin
    inc( IndentLevel );
    S := tmpPathElements[i];

    if not DirectoryExists( PathSoFar + S ) then
    begin
      // directory specified doesn't exist.
      FDirectory := PathSoFar;
      break;
    end;
    Items.AddObject( S, pointer( IndentLevel ) );
    PathSoFar := PathSoFar + S + DIRECTORY_SEPARATOR;
  End;

  tmpPathElements.Destroy;
  ItemIndex:= Items.Count - 1;

  inc( IndentLevel );

  SubDirs:= TStringList.Create;

  Status := SysUtils.FindFirst( AddDirectorySeparator( Directory ) + '*.*', faDirectory, Search);
  While Status = 0 Do
  Begin
    S := Search.Name;
    If Search.Attr And faDirectory = faDirectory Then
    Begin
      {avoid .. In Mainpath}
      If     ( S <> '.' )
         and ( S <> '..' ) Then
        SubDirs.AddObject( S, pointer( IndentLevel + dfSubDir ) );
    End;
    Status := SysUtils.FindNext( Search );
  End;
  if Status <> - ERROR_NO_MORE_FILES then
    SubDirs.AddObject( '[Error reading directories]',
                       pointer( 1 + dfErrorMessage  ) );

  SysUtils.FindClose( Search );

  DosErrorAPI( FERR_ENABLEHARDERR );

  SubDirs.Sort;
  Items.AddStrings( SubDirs );
  SubDirs.Destroy;

  EndUpdate;
  Refresh;
  Screen.Cursor := crDefault;
End;


Procedure TCustomDirectoryListBox.SetDirectory(NewDir:String);
Var
  s: String;
Begin
  If NewDir = '' Then
  Begin
    {$I-}
    // Get current drive
    GetDir(0,NewDir);
    {$I+}
  End;

  If Pos(':',NewDir)<>2 Then
  Begin
    {$I-}
    // Get current directory on specified drive
    GetDir(Ord(UpCase(Drive))-Ord('A')+1,s);
    {$I+}
    S:= RemoveRightDirectorySeparator( S );
    S:= AddDirectorySeparator( S );
    NewDir:=s+NewDir;
  End;

  NewDir:= RemoveRightDirectorySeparator( NewDir );

  FDirectory := NewDir;
  if Handle <> 0 then
    BuildList;

  If FDriveCombo <> Nil Then
  Begin
    If UpCase( FDriveCombo.Drive ) <> UpCase( Drive ) Then
      FDriveCombo.Drive := Drive;
  End;

  Change;

End;


Procedure TCustomDirectoryListBox.SetDrive(NewDrive:Char);
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


Function TCustomDirectoryListBox.GetDrive:Char;
Begin
     Result := FDirectory[1];
End;


Procedure TCustomDirectoryListBox.SetDirLabel(ALabel:TLabel);
Begin
     FDirLabel := ALabel;
     If FDirLabel <> Nil Then
     Begin
          FDirLabel.FreeNotification(Self);
          FDirLabel.Caption := FDirectory;
     End;
End;


Procedure TCustomDirectoryListBox.SetFileListBox(AFileList:TCustomFileListBox);
Begin
     If FFileList <> Nil Then FFileList.FDirList := Nil;
     FFileList := AFileList;
     If FFileList <> Nil Then
     Begin
          FFileList.FDirList := Self;
          FFileList.FreeNotification(Self);
     End;
End;


Procedure TCustomDirectoryListBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
     Begin
          If AComponent = FFileList Then
            FFileList := Nil;
          If AComponent = FDirLabel Then
            FDirLabel := Nil;
     End;
End;


Procedure TCustomDirectoryListBox.Change;
Begin
     If FDirLabel <> Nil Then
       FDirLabel.Caption := FDirectory;
     If FFileList <> Nil Then
       FFileList.Directory := FDirectory;

     If FOnChange <> Nil Then FOnChange(Self);
End;

Function TCustomDirectoryListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

Procedure TCustomDirectoryListBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;

Procedure TCustomDirectoryListBox.SetPictureClosed( NewBitmap: TBitmap );
Begin
  StoreBitmap( FPictureClosed, FPictureClosedMask, NewBitmap );
  Invalidate;
End;

Procedure TCustomDirectoryListBox.SetPictureOpen( NewBitmap: TBitmap );
Begin
  StoreBitmap( FPictureOpen, FPictureOpenMask, NewBitmap );
  Invalidate;
End;

// ---------------------------------------------------------------------
// TCustomDriveComboBox
// ---------------------------------------------------------------------

Procedure TCustomDriveComboBox.SetupComponent;
Var
  DriveNumber: longint;
  CurrentDir: string;

  DriveString: String;
  DriveType: TDriveType;
  DriveLabel: string;

Begin
  Inherited SetupComponent;

  Name := 'DriveComboBox';
  Style := csDropDownList;
  sorted := False;

  OwnerDraw := true;
  OnDrawItem := DrawItem;

  {Fill Drive Combo}

  For DriveNumber := MinDriveNumber To MaxDriveNumber Do
  begin
    DriveType := GetDriveType( DriveNumber );
    DriveString := Chr( DriveNumber + Ord( 'A' ) - 1 ) + ': ';

    if DriveType <> dtNone then
    begin
      if DriveType = dtHard then
      begin
        try
          DriveLabel := GetVolumeLabel( DriveNumberToDriveLetter( DriveNumber ) );
          DriveString := DriveString + DriveLabel;
        except
        end;
      end;

      if DriveType = dtNetwork then
      begin
        if not Designed then
        begin
          DriveString := DriveString
                         + LowerCase( GetNetworkDriveRemotePath( DriveNumber ) );
        end;
      end;

      Items.AddObject( DriveString, TObject( DriveType ) );
    end;
  end;

  // Get current drive
  try
    GetDir( 0, CurrentDir );
    Drive := CurrentDir[ 1 ];
  except
    on EInOutError do
      // Current drive inaccessible
      Drive := GetBootDriveLetter;
  end;
End;

Procedure TCustomDriveComboBox.DrawItem( Canvas: TCanvas;
                                         S: string;
                                         Data: TObject;
                                         rec: TRect;
                                         State: TOwnerDrawState );
Var
  X,Y,CX,CY: LongInt;
  DriveType: TDriveType;
  DrivePath: string;
  TypeBitmap: TBitmap;
  TypeBitmapMask: TBitmap;
  TextHeight: longint;
  TextWidth: longint;
  TextBottom: longint;
  BitmapBottom: longint;
Begin
  If odSelected in State Then
  Begin
    Canvas.Pen.color := clHighlightText;
    Canvas.Brush.color := clHighlight;
  End
  Else
  Begin
    Canvas.Pen.color := PenColor;
    Canvas.Brush.color := Color;
  End;
  Canvas.FillRect(rec,Canvas.Brush.color);

  X := rec.Left + 2;
  Y := rec.Bottom + 1;
  CX := rec.Right - X;
  CY := rec.Top - Y;

  DrivePath := Copy( S, 1, 2 ); // "a:"
  Delete( S, 1, 3 ); // delete "a: "

  DriveType := TDriveType( Data );
  TypeBitmap := DriveTypeBitmaps[ DriveType ];
  TypeBitmapMask := DriveTypeBitmapMasks[ DriveType ];

  // see how high the text is, and the widest (W)
  Canvas.GetTextExtent( 'W: ', TextWidth, TextHeight );

  TextBottom := Y + ( CY - TextHeight ) div 2;
  if TextBottom < rec.Bottom then
    TextBottom := rec.Bottom;

  BitmapBottom := Y + ( CY - TypeBitmap.Height ) div 2;
  if BitmapBottom < rec.Bottom then
    BitmapBottom := rec.Bottom;

  // Draw drive type image
  DrawMaskedBitmap( TypeBitmap, TypeBitmapMask,
                    Canvas,
                    X, BitmapBottom );
  inc( X, TypeBitmap.Width );
  inc( X, 5 );

  // Draw drive letter
  Canvas.TextOut( X, TextBottom, DrivePath );
  inc( X, TextWidth );

  Canvas.TextOut( X, TextBottom, S );
end;

Procedure TCustomDriveComboBox.ItemSelect(Index:LongInt);
Begin
     Inherited ItemSelect(Index);

     Change;
End;


Procedure TCustomDriveComboBox.Change;
var
  DriveLabel: string;
  DriveValid: boolean;
  DriveType: TDriveType;
Begin
     {determine volume label}
     If ItemIndex <> -1 Then
     Begin
          DriveValid := false;
          DriveType := TDriveType( Items.Objects[ ItemIndex ] );
          while not DriveValid do
          begin
               try
                    Screen.Cursor := crHourGlass;

                    DriveLabel := GetVolumeLabel( Text[1] );
                    DriveValid := true;

                    if DriveType <> dtNetwork then
                    begin
                      Text := Copy( Text, 1, 3 ) + DriveLabel;
                      Items[ ItemIndex ] := Text;
                    end;
               except
                    on E: EInOutError do
                    begin
                         DriveValid := false;
                         Screen.Cursor := crDefault;
                         if MessageBox( e.Message,
                                        mtError,
                                        [ mbRetry, mbCancel ] ) = mrCancel then
                         begin
                              // Cancelling: back to last.
                              // Actually it could be that the original drive is now
                              // invalid... :|
                              if ItemIndex = FLastIndex then
                              begin
                                // we were trying to re-read the
                                // current drive, and it failed,
                                // and the user doesn't want to retry,
                                // so go back to boot drive.
                                SetDrive(GetBootDriveLetter);
                                Screen.Cursor := crDefault;
                                Exit;
                              end;
                              ItemIndex := FLastIndex;
                              DriveValid := true;
                         end;
                    end;
               end;
          end;
     End;
     Screen.Cursor := crDefault;

     FLastIndex := ItemIndex;

     If FDirList <> Nil Then FDirList.Drive := Drive;

     If FOnChange <> Nil Then FOnChange(Self);

End;

Function TCustomDriveComboBox.GetDrive:Char;
Begin
     Result := Text[1];
End;

Procedure TCustomDriveComboBox.SetDrive(NewDrive:Char);
Var S:String;
    T:LongInt;
    {$IFDEF Win95}
    sernum,complen,Flags:LongWord;
    FileSystem,volname:cstring;
    {$ENDIF}
Begin
     NewDrive := UpCase(NewDrive);
     If UpCase(Drive) = NewDrive Then Exit;

     // Find the drive in the list
     For T := 0 To Items.Count-1 Do
     Begin
          S := Items.Strings[T];
          If UpCase(S[1]) = NewDrive Then
          Begin
               // Found
               ItemIndex := T;
               break;
          End;
     End;
End;


Procedure TCustomDriveComboBox.SetDirListBox(ADirList:TCustomDirectoryListBox);
Begin
     If FDirList <> Nil Then FDirList.FDriveCombo := Nil;
     FDirList := ADirList;
     If FDirList <> Nil Then
     Begin
          FDirList.FDriveCombo := Self;
          FDirList.FreeNotification(Self);
     End;
End;


Procedure TCustomDriveComboBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FDirList Then
         FDirList := Nil;
End;


Function TCustomDriveComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;


// ---------------------------------------------------------------------
// TCustomFilterComboBox
// ---------------------------------------------------------------------

Procedure TCustomFilterComboBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FilterComboBox';
     Style := csDropDownList;
     sorted := False;

     FFilter := LoadNLSStr(SAllFiles)+' (*.*)|*.*';
     FMaskList.Create;
End;


Procedure TCustomFilterComboBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;


Destructor TCustomFilterComboBox.Destroy;
Begin
     FMaskList.Destroy;
     FMaskList := Nil;

     Inherited Destroy;
End;


Procedure TCustomFilterComboBox.ItemSelect(Index:LongInt);
Begin
     Inherited ItemSelect(Index);

     Text := Items[Index];
     Change;
End;


Procedure TCustomFilterComboBox.Change;
Begin
     If FFileList <> Nil Then FFileList.Mask := Mask;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TCustomFilterComboBox.BuildList;
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
     if Items.Count > 0 then
       ItemIndex := 0;
End;


Procedure TCustomFilterComboBox.SetFilter(NewFilter:String);
Begin
     If FFilter <> NewFilter Then
     Begin
          FFilter := NewFilter;
          BuildList;
          Change;
     End;
End;


Procedure TCustomFilterComboBox.SetFilelistBox(AFileList:TCustomFilelistBox);
Begin
     If FFileList <> Nil Then FFileList.FFilterCombo := Nil;
     FFileList := AFileList;
     If FFileList <> Nil Then
     Begin
          FFileList.FFilterCombo := Self;
          FFileList.FreeNotification(Self);
     End;
End;


Procedure TCustomFilterComboBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFileList Then FFileList := Nil;
End;


Function TCustomFilterComboBox.GetMask:String;
Var  idx:LongInt;
Begin
     idx := ItemIndex;
     If (idx < 0) Or (idx >= FMaskList.Count) Then Result := '*.*'
     Else Result := FMaskList[idx];
End;


Function TCustomFilterComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

var
  DriveType: TDriveType;
  ResourceName: string;
  Bitmap: TBitmap;
  MaskBitmap: TBitmap;
Initialization
  RegisterClasses( [ TCustomDriveComboBox,
                     TCustomDirectoryListBox,
                     TCustomFilelistBox,
                     TCustomFilterComboBox ] );

  for DriveType := Low( TDriveType ) to High( TDriveType ) do
  begin
    if DriveType = dtNone then
    begin
      DriveTypeBitmaps[ DriveType ] := nil;
      DriveTypeBitmapMasks[ DriveType ] := nil;
      continue; // don't load a bitmap for the none
    end;

    ResourceName := DriveTypeBitmapNames[ DriveType ];

    Bitmap:= TBitmap.Create;
    Bitmap.LoadFromResourceName( ResourceName );
    DriveTypeBitmaps[ DriveType ] := Bitmap;

    MaskBitmap:= TBitmap.Create;
    CreateMaskedBitmap( Bitmap, MaskBitmap, $ff00ff );
    DriveTypeBitmapMasks[ DriveType ] := MaskBitmap;
  end;

finalization

  for DriveType := Low( TDriveType ) to High( TDriveType ) do
  begin
    if DriveTypeBitmaps[ DriveType ] <> nil then
      DriveTypeBitmaps[ DriveType ].Destroy;
 
    if DriveTypeBitmapMasks[ DriveType ] <> nil then
      DriveTypeBitmapMasks[ DriveType ].Destroy;
  end;

End.


