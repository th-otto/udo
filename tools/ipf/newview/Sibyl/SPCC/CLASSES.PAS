
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit Classes;


Interface

Uses Dos,SysUtils;

{$IFDEF OS2}
Uses PmWin,BseDos;
{$ENDIF}
{$IFDEF Win95}
Uses WinUser,WinBase;
{$ENDIF}

//TStream Seek origins
Const
  soFromBeginning = 0;
  soFromCurrent   = 1;
  soFromEnd       = 2;

Type
    EStreamError=Class(Exception);
    EFCreateError=Class(EStreamError);
    EFOpenError=Class(EStreamError);

    TStream=Class(TObject)
      Private
         Function GetSize:LongInt;Virtual;
         Function GetPosition:LongInt;
         Procedure SetPosition(NewPos:LongInt);
         Procedure Error(ResourceId:Word);Virtual;
      Public
         Procedure ReadBuffer(Var Buffer;Count:LongInt);
         Procedure WriteBuffer(Const Buffer;Count:LongInt);
         Function CopyFrom(Source: TStream; Count: LongInt): LongInt;
         Function Read(Var Buffer;Count:LongInt):LongInt;Virtual;Abstract;
         Function Write(Const Buffer;Count:LongInt):LongInt;Virtual;Abstract;
         Function Seek(Offset:LongInt;Origin:Word):LongInt;Virtual;Abstract;
         Function EndOfData: Boolean; Virtual;
         Function ReadLn: String; Virtual;
         Procedure WriteLn(Const S: String); Virtual;
      Public
         Property Position:LongInt Read GetPosition Write SetPosition;
         Property Size:LongInt Read GetSize;
    End;


Const
    {FileStream Open modes}
    fmCreate = $FFFF;            (* Delphi *)

    Stream_Create    = fmCreate; (* compatibility only *)
    Stream_Open      = fmInOut;  (* compatibility only *)
    Stream_OpenRead  = fmOpenRead Or fmShareDenyWrite;

Type
    THandleStream= Class(TStream)
      Private
         FHandle: LongInt;
      Public
         Constructor Create(AHandle: LongInt);
         Function Read(Var Buffer; Count: LongInt): LongInt; Override;
         Function Write(Const Buffer; Count: LongInt): LongInt; Override;
         Function Seek(Offset: LongInt; Origin: Word): LongInt; Override;
      Public
         Property Handle: LongInt Read FHandle;
    End;

Type
    TFileStream=Class(TStream)
      Private
         PStreamFile:File;
      Public
         Constructor Create(Const FileName:String;Mode:LongWord);
         Destructor Destroy;Override;
         Function Read(Var Buffer;Count:LongInt):LongInt;Override;
         Function Write(Const Buffer;Count:LongInt):LongInt;Override;
         Function Seek(Offset:LongInt;Origin:Word):LongInt;Override;
    End;


    TMemoryStream=Class(TStream)
      Private
         FBuffer: PByteArray;
         FSize, FCapacity, FPosition: LongInt;
         Procedure SetCapacity(NewCapacity: LongInt);
      Protected
         Property Capacity:LongInt Read FCapacity Write SetCapacity;
      Public
         Destructor Destroy;Override;
         Function Read(Var Buffer;Count:LongInt):LongInt;Override;
         Function Write(Const Buffer; Count: LongInt):LongInt;Override;
         Function Seek(Offset: LongInt; Origin: Word):LongInt;Override;
         Procedure LoadFromStream(Stream: TStream);
         Procedure LoadFromFile(Const FileName:String);
         Procedure SaveToStream(Stream: TStream);
         Procedure SaveToFile(Const FileName:String);
         Procedure SetSize(NewSize: LongInt);
         Procedure Clear;
      Public
         Property Memory: PByteArray Read FBuffer;
    End;


Const
    MaxListSize = MaxLongInt Div SizeOf(Pointer);

    { A notify event Is A method variable, I.E. A Procedure
    variable For Objects. Some Classes allow the specification
    Of Objects To be notified Of changes. }


Type
    TComponent=Class;

{$M+}
    TNotifyEvent = Procedure(Sender:TObject) Of Object;
{$M-}

    EListError = Class(Exception);

    {TList Class}
    TList = Class;
    PPointerList = ^TPointerList;
    TPointerList = Array[0..MaxListSize-1] Of Pointer;
    TListSortCompare = Function(Item1,Item2: Pointer):LongInt;

    TFreeListItem = Procedure(Sender:TObject;Item:Pointer) Of Object;

    TList = Class
      Private
         FList:PPointerList;
         FCount:LongInt;
         FCapacity:LongInt;
         FGrowth:LongInt;
         FOnFreeItem:TFreeListItem;
         Function Get(Index:LongInt):Pointer;
         Procedure Put(Index:LongInt;Item:Pointer);
         Procedure SetCount(NewCount:LongInt);
      Protected
         Procedure Error; Virtual;
         Procedure Grow; Virtual;
         Procedure SetCapacity(NewCapacity:LongInt); Virtual;
         Procedure FreeItem(Item:Pointer); Virtual;
      Public
         Destructor Destroy; Override;
         Procedure Clear; Virtual;
         Function Add(Item:Pointer):LongInt;
         Procedure Delete(Index:LongInt);
         Function Remove(Item:Pointer):LongInt;
         Procedure Cut(Index1,Index2:LongInt);
         Procedure Insert(Index:LongInt;Item:Pointer);
         Procedure Exchange(Index1,Index2:LongInt);
         Procedure Move(CurIndex,NewIndex:LongInt);
         Function IndexOf(Item:Pointer):LongInt;
         Function First:Pointer;
         Function Last:Pointer;
         Function Expand:TList;
         Procedure Pack;
         Procedure Sort(Compare: TListSortCompare);
         Procedure AddList(List:TList);
         Procedure Assign(List:TList);
      Public
         Property  Capacity:LongInt Read FCapacity Write SetCapacity;
         Property  Count:LongInt Read FCount Write SetCount;
         Property  Growth:LongInt Read FGrowth Write FGrowth;
         Property  Items[Index:LongInt]:Pointer Read Get Write Put; Default;
         Property  List:PPointerList Read FList;
         Property  OnFreeItem:TFreeListItem Read FOnFreeItem Write FOnFreeItem;
    End;


    {TChainList Class}
    PChainListItem = ^TChainListItem;
    TChainListItem = Record
                           Prev:PChainListItem;
                           Item:Pointer;
                           Next:PChainListItem;
    End;


    TChainList = Class(TObject)
      Private
         FList:PChainListItem;
         FListEnd:PChainListItem;
         FCount:LongInt;
         FOnFreeItem:TFreeListItem;
      Private
         Function Index2PLE(Index:LongInt):PChainListItem;
         Function Item2PLE(Item:Pointer):PChainListItem;
         Function PLE2Index(ple:PChainListItem):LongInt;
         Function Item2Index(Item:Pointer):LongInt;
         Procedure Connect(ple1,ple2:PChainListItem);
         Function Get(Index:LongInt):Pointer;
         Procedure Put(Index:LongInt;Item:Pointer);
      Protected
         Procedure Error; Virtual;
         Procedure FreeItem(Item:Pointer); Virtual;
      Public
         Destructor Destroy; Override;
         Procedure Clear; Virtual;
         Function Add(Item:Pointer):LongInt;
         Function Remove(Item:Pointer):LongInt;
         Procedure Delete(Index:LongInt);
         Function First:Pointer;
         Function Last:Pointer;
         Function IndexOf(Item:Pointer):LongInt;
         Procedure Insert(Index:LongInt;Item:Pointer);
         Procedure Move(CurIndex,NewIndex:LongInt);
         Procedure Exchange(Index1,Index2:LongInt);
         Procedure Pack;
      Public
         Property  Count:LongInt Read FCount;
         Property  Items[Index:LongInt]:Pointer Read Get Write Put; Default;
         Property  OnFreeItem:TFreeListItem Read FOnFreeItem Write FOnFreeItem;
    End;

 { TStrings Is an Abstract base Class For storing a
  Number Of Strings. Every String can be associated
  With A Value As well As With an Object. So, If you
  want To Store simple Strings, Or collections Of
  keys And values, Or collection Of named Objects,
  TStrings Is the Abstract ancestor you should
  derive your Class from. }

Type
  EStringListError = Class(Exception);

  TStrings = Class(TObject)
     Private
       FUpdateSemaphore: LongInt;
       FPreventFree: Boolean;
       Function GetValue(Const Name: String): String;
       Procedure SetValue(Const Name, Value: String);
       Function FindValue(Const Name: String; Var Value: String): LongInt;
       Function GetName(Index: LongInt): String;
     Protected
       Function Get(Index: LongInt): String; Virtual; Abstract;
       Function GetCount: LongInt; Virtual; Abstract;
       Function GetObject(Index: LongInt): TObject; Virtual;
       Procedure Put(Index: LongInt; Const S: String); Virtual;
       Procedure PutObject(Index: LongInt; AObject: TObject); Virtual;
       Procedure SetUpdateState(Updating: Boolean); Virtual;
       Function GetTextStr: AnsiString; Virtual;
       Procedure SetTextStr(Const Value: AnsiString); Virtual;
     Public
       Function Add(Const S: String): LongInt; Virtual;
       Function AddObject(Const S: String; AObject: TObject): LongInt; Virtual;
       Procedure AddStrings(AStrings: TStrings); Virtual;
       Procedure Append(Const S: String);
       Procedure Assign(AStrings: TStrings); Virtual;
       Procedure BeginUpdate;
       Procedure Clear; Virtual; Abstract;
       Procedure Delete(Index: LongInt); Virtual; Abstract;
       Procedure EndUpdate;
       Function Equals(AStrings: TStrings): Boolean;
       Procedure Exchange(Index1, Index2: LongInt); Virtual;
       Function GetText: PChar;Virtual;
       Function IndexOf(Const S: String): LongInt; Virtual;
       Function IndexOfName(Const Name: String): LongInt;
       Function IndexOfObject(AObject: TObject): LongInt;
       Procedure Insert(Index: LongInt; Const S: String); Virtual; Abstract;
       Procedure InsertObject(Index: LongInt; Const S: String; AObject: TObject); Virtual;
       Procedure LoadFromFile(Const FileName: String);
       Procedure SetText(Text: PChar);Virtual;
       Procedure LoadFromStream(Stream: TStream); Virtual;
       Procedure Move(CurIndex, NewIndex: LongInt); Virtual;
       Procedure SaveToFile(Const FileName: String);
       Procedure SaveToStream(Stream: TStream); Virtual;
     Public
       Property Names[Index: LongInt]: String Read GetName;
       Property Count: LongInt Read GetCount;
       Property Objects[Index: LongInt]: TObject Read GetObject Write PutObject;
       Property values[Const Name: String]: String Read GetValue Write SetValue;
       Property Strings[Index: LongInt]: String Read Get Write Put; Default;
       Property Text:AnsiString Read GetTextStr Write SetTextStr;
  End;

{ TStringList Is A concrete Class derived
  from TStrings. TStringList stores its Items
  In A Private field Of Type TList. It's very
  fast, since it performs binary Search For
  retrieving Objects by Name. you can specify
  whether you want TStringList To be sorted Or
  unsorted As well As Case-sensitive Or Not.
  you can also specify the way A TStringList
  Object handles duplicate entries.

  TStringList Is able To notify the user when
  the list's Data changes Or has been changed.
  Use the properties OnChange And OnChanged. }

Type
  TDuplicates = (dupIgnore, dupAccept, dupError);

  TFreeStringListItem = Procedure(Sender:TObject;AObject:TObject) Of Object;

Type
  TStringList = Class(TStrings)
  Private
    FList: TList;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    FOnFreeItem: TFreeStringListItem;
    FLockChange:Boolean;
    Procedure BottomUpHeapSort;
    Procedure SetSorted(Value: Boolean);
    Procedure SetCaseSensitive(Value: Boolean);
  Protected
    Procedure changed; Virtual;
    Procedure Changing; Virtual;
    Function Get(Index: LongInt): String; Override;
    Function GetCount: LongInt; Override;
    Function GetObject(Index: LongInt): TObject; Override;
    Procedure Put(Index: LongInt; Const S: String); Override;
    Procedure PutObject(Index: LongInt; AObject: TObject); Override;
    Procedure SetUpdateState(Updating: Boolean); Override;
    Procedure FreeItem(AObject: TObject);Virtual;
    Function GetValuePtr(Index:Longint): PString;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Add(Const S: String): LongInt; Override;
    Procedure Clear; Override;
    Procedure Delete(Index: LongInt); Override;
    Procedure Exchange(Index1, Index2: LongInt); Override;
    Function Find(Const S: String; Var Index: LongInt): Boolean; Virtual;
    Function IndexOf(Const S: String): LongInt; Override;
    Procedure Insert(Index: LongInt; Const S: String); Override;
    Procedure Sort; Virtual;
    Property Duplicates: TDuplicates Read FDuplicates Write FDuplicates;
    Property CaseSensitive: Boolean Read FCaseSensitive Write SetCaseSensitive;
    Property sorted: Boolean Read FSorted Write SetSorted;
    Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
    Property OnChanging: TNotifyEvent Read FOnChanging Write FOnChanging;
    Property OnFreeItem: TFreeStringListItem Read FOnFreeItem Write FOnFreeItem;
    Property ValuePtrs[Index:Longint]: PString Read GetValuePtr;
  End;

{ StrItem Is A space-efficient way To Store an Object
  associated With A String. it Is used inside TStringList. }

Type
  PStrItem = ^TStrItem;
  TStrItem = Record
     FObject: TObject;
     FString: String;
  End;

Function NewStrItem(Const AString: String; AObject: TObject): PStrItem;
Procedure DisposeStrItem(P: PStrItem);

Type

{ TBits implements A Boolean Array. entries are
  numbered 0 .. Size - 1, As usual. Bits allows
  Read / Write access To entries. OpenBit returns
  Index Of First True bit, Or -1 If none Is True. }

  PBitsArray = ^TBitsArray;
  TBitsArray = Array[0..MaxLongInt Div 4] Of LongWord;

  EBitsError = Class(Exception);

  TBits = Class
  Private
    FBits: PBitsArray;
    FSize: LongInt;
    Procedure Error;
    Function GetBit(Index: LongInt): Boolean;
    Procedure SetBit(Index: LongInt; bit: Boolean);
    Procedure SetSize(NewSize: LongInt);
  Public
    Destructor Destroy; Override;
    Function OpenBit: LongInt;
    Property Bits[Index: LongInt]: Boolean Read GetBit Write SetBit; Default;
    Property Size: LongInt Read FSize Write SetSize;
  End;


Type
    //General types
    HWindow=LongWord;

    PMessage=^TMessage;
{$M+}
    TMessage=Record
{$M-}
         Msg:LongWord;
         ReceiverClass: TObject;
         Receiver: HWindow;
         Handled: LongBool;  {True If the Message was Handled}
         Case Integer Of
            0: ( Param1: LongWord;
                 Param2: LongWord;
                 Result: LongWord);
            1: ( WParam: LongWord;
                 LParam: LongWord;
                 MsgResult: LongWord);
            2: ( Param1Lo: Word;
                 Param1Hi: Word;
                 Param2Lo: Word;
                 Param2Hi: Word;
                 ResultLo: Word;
                 ResultHi: Word);
            3: ( Param1LoByteLo:Byte;
                 Param1LoByteHi:Byte;
                 Param1HiByteLo:Byte;
                 Param1HiByteHi:Byte;
                 Param2LoByteLo:Byte;
                 Param2LoByteHi:Byte;
                 Param2HiByteLo:Byte;
                 Param2HiByteHi:Byte;
                 ResultLoByteLo:Byte;
                 ResultLoByteHi:Byte;
                 ResultHiByteLo:Byte;
                 ResultHiByteHi:Byte);
    End;

    HDC=LongWord;
    HPalette=LongWord;

{$M+}
    TColor=LongInt;
{$M-}

    PPoint=^TPoint;
{$M+}
    TPoint=Record
         X,Y:LongInt;
    End;
{$M-}

    PRect=^TRect;
{$M+}
    TRect=Record
         Case LongInt Of
           0: (Left,Bottom,Right,Top:LongInt);
           1: (LeftBottom,RightTop:TPoint);
    End;
{$M-}


    PSize=^TSize;
{$M+}
    TSize=Record
         CX,CY:LongInt;
    End;

    TRGB=Record
         Blue:Byte;
         Green:Byte;
         Red:Byte;
         Fill:Byte;
    End;
{$M-}

Const
{$M+}
    {Default RGB color values}
    clBlack                    = TColor($00000000);
    clMaroon                   = TColor($00800000);
    clGreen                    = TColor($00008000);
    clOlive                    = TColor($00808000);
    clNavy                     = TColor($00000080);
    clPurple                   = TColor($00800080);
    clTeal                     = TColor($00008080);
    clGray                     = TColor($00808080);
    clSilver                   = TColor($00C6C6C6);
    clRed                      = TColor($00FF0000);
    clLime                     = TColor($0000FF00);
    clYellow                   = TColor($00FFFF00);
    clBlue                     = TColor($000000FF);
    clFuchsia                  = TColor($00FF00FF);
    clAqua                     = TColor($0000FFFF);
    clLtGray                   = TColor($00CCCCCC);
    clDkGray                   = TColor($00808080);
    clWhite                    = TColor($00FFFFFF);

    {System Colors}
    clScrollbar                = TColor(0 Or $80000000);
    clBackGround               = TColor(1 Or $80000000);
    clActiveCaption            = TColor(2 Or $80000000);
    clInactiveCaption          = TColor(3 Or $80000000);
    clMenu                     = TColor(4 Or $80000000);
    clWindow                   = TColor(5 Or $80000000);
    clWindowFrame              = TColor(6 Or $80000000);
    clMenuText                 = TColor(7 Or $80000000);
    clWindowText               = TColor(8 Or $80000000);
    clCaptionText              = TColor(9 Or $80000000);
    clActiveBorder             = TColor(10 Or $80000000);
    clInactiveBorder           = TColor(11 Or $80000000);
    clAppWorkSpace             = TColor(12 Or $80000000);
    clHighlight                = TColor(13 Or $80000000);
    clHighlightText            = TColor(14 Or $80000000);
    clBtnFace                  = TColor(15 Or $80000000);
    clBtnShadow                = TColor(16 Or $80000000);
    clGrayText                 = TColor(17 Or $80000000);
    clBtnText                  = TColor(18 Or $80000000);
    clInactiveCaptionText      = TColor(19 Or $80000000);
    clBtnHighlight             = TColor(20 Or $80000000);
    cl3DDkShadow               = TColor(21 Or $80000000);
    cl3DLight                  = TColor(22 Or $80000000);
    clInfoText                 = TColor(23 Or $80000000);
    clInfo                     = TColor(24 Or $80000000);
    clBtnDefault               = TColor(25 Or $80000000);
    clDlgWindow                = TColor(26 Or $80000000);
    clEntryField               = TColor(27 Or $80000000);
    clStaticText               = TColor(28 Or $80000000);
{$M-}


Type
    TColorName = Record
         Name: String[20];
         Value: LongInt;
    End;

Const
    MaxDefaultColors = 18;
    DefaultColors: Array[1..MaxDefaultColors] Of TColorName = (
         (Name:'clBlack'; Value:clBlack),
         (Name:'clMaroon'; Value:clMaroon),
         (Name:'clGreen'; Value:clGreen),
         (Name:'clOlive'; Value:clOlive),
         (Name:'clNavy'; Value:clNavy),
         (Name:'clPurple'; Value:clPurple),
         (Name:'clTeal'; Value:clTeal),
         (Name:'clGray'; Value:clGray),
         (Name:'clSilver'; Value:clSilver),
         (Name:'clRed'; Value:clRed),
         (Name:'clLime'; Value:clLime),
         (Name:'clYellow'; Value:clYellow),
         (Name:'clBlue'; Value:clBlue),
         (Name:'clFuchsia'; Value:clFuchsia),
         (Name:'clAqua'; Value:clAqua),
         (Name:'clLtGray'; Value:clLtGray),
         (Name:'clDkGray'; Value:clDkGray),
         (Name:'clWhite'; Value:clWhite));

    MaxSystemColors = 29;
    SystemColors: Array[1..MaxSystemColors] Of TColorName = (
         (Name:'clScrollbar'; Value:clScrollbar),
         (Name:'clBackGround'; Value:clBackGround),
         (Name:'clActiveCaption'; Value:clActiveCaption),
         (Name:'clInactiveCaption'; Value:clInactiveCaption),
         (Name:'clMenu'; Value:clMenu),
         (Name:'clWindow'; Value:clWindow),
         (Name:'clWindowFrame'; Value:clWindowFrame),
         (Name:'clMenuText'; Value:clMenuText),
         (Name:'clWindowText'; Value:clWindowText),
         (Name:'clCaptionText'; Value:clCaptionText),
         (Name:'clActiveBorder'; Value:clActiveBorder),
         (Name:'clInactiveBorder'; Value:clInactiveBorder),
         (Name:'clAppWorkSpace'; Value:clAppWorkSpace),
         (Name:'clHighLight'; Value:clHighlight),
         (Name:'clHighLightText'; Value:clHighlightText),
         (Name:'clBtnFace'; Value:clBtnFace),
         (Name:'clBtnShadow'; Value:clBtnShadow),
         (Name:'clGrayText'; Value:clGrayText),
         (Name:'clBtnText'; Value:clBtnText),
         (Name:'clInactiveCaptionText'; Value:clInactiveCaptionText),
         (Name:'clBtnHighlight'; Value:clBtnHighlight),
         (Name:'cl3DDkShadow'; Value:cl3DDkShadow),
         (Name:'cl3DLight'; Value:cl3DLight),
         (Name:'clInfoText'; Value:clInfoText),
         (Name:'clInfo'; Value:clInfo),
         (Name:'clBtnDefault'; Value:clBtnDefault),
         (Name:'clDlgWindow'; Value:clDlgWindow),
         (Name:'clEntryField'; Value:clEntryField),
         (Name:'clStaticText'; Value:clStaticText));


Function ColorName(ColorValue:TColor):String;
Function ColorValue(ColorName:String):TColor;


Type
    TResourceName=String[32];

    TResourceStream=Class(TMemoryStream)
      Private
         FHeaderPos:LongInt;
         FResourceList:TList;
         SCUStream:TStream;
      Public
         Function NewResourceEntry(Const ResName:TResourceName;
                                   Var Data;DataLen:LongInt):Boolean;
         Function WriteResourcesToStream(Stream:TMemoryStream):Boolean;
         Destructor Destroy;Override;
    End;


{Standard Resource Names For NewResourceEntry}
Const
    rnGlyph         = 'rnGlyph';
    rnBitmap        = 'rnBitmap';
    rnPicture       = 'rnPicture';
    rnPictureLeaf   = 'rnPictureLeaf';
    rnPictureOpen   = 'rnPictureOpen';
    rnPictureClosed = 'rnPictureClosed';
    rnFont          = 'rnFont';
    rnTabFont       = 'rnTabFont';
    rnLines         = 'rnLines';
    rnItems         = 'rnItems';
    rnTabs          = 'rnTabs';
    rnDBServer      = 'rnDBServer';
    rnDBDataBase    = 'rnDBDataBase';
    rnDBTable       = 'rnDBTable';
    rnDBQuery       = 'rnDBQuery';
    rnDBDataField   = 'rnDBDataField';
    rnGridSizes     = 'rnGridSize';
    rnFileName      = 'rnFileName';
    rnIcon          = 'rnIcon';
    rnDBGridCols    = 'rnDBGridCols';
    rnStatusPanels  = 'rnStatusPanels';
    rnHeaders       = 'rnHeaders';
    rnBitmapList    = 'rnBitmapList';
    rnScrollExtents = 'rnScrollExtents';

Type
    TComponentState=Set Of (csDesigning,csReading,csWriting,csDestroying,
                            csLoaded,csForm,csDetail,csReferenceControl,
                            csReference,csAcceptsControls,csHandleLinks,
                            csHasMainMenu,csLoading);

    TDesignerState=Set Of (dsFormVisible,dsNoRealSizing,
                           dsNoSourceCode,dsStored,dsAutoCreate);

    TOperation=(opInsert,opRemove);

    TGetChildProc=Procedure(Child:TComponent) Of Object;


    ESCUError=Class(Exception);

    TPersistent=Class(TObject)
       Private
             Procedure AssignError(Source:TPersistent);
       Protected
             Procedure AssignTo(Dest:TPersistent);Virtual;
       Public
             Procedure Assign(Source:TPersistent);Virtual;
    End;

    TPersistentClass = class of TPersistent;

    TComponent=Class(TPersistent)
      Private
         FLanguages:Pointer;
         FName:PString;
         FUnitName:PString;
         FTypeName:PString;
         FOwner:TComponent;
         FComponentState:TComponentState;
         FDesignerState:TDesignerState;
         FCreateFromSCU:Boolean;
         FComponents:TList;
         FFreeNotifyList:TList;
         FMethods:Pointer;
         FTag:LongInt;
         FWriteComponentCount:LongInt;
         SCUStream:TMemoryStream;
         SCUResStream:TResourceStream;
         SCUWriteError:Boolean;
         FReference:TComponent;
         Function GetComponentCount:LongInt;
         Function GetComponent(AIndex:LongInt):TComponent;
         Function GetComponentIndex:LongInt;
         Procedure SetComponentIndex(Index:LongInt);
         Function GetName:String;
         Procedure SetName(Const NewName:String);
         Function GetUnitName:String;
         Function GetTypeName:String;
         Procedure SetTypeName(NewName:String);
         Function GetDesigned:Boolean;
         Procedure SetupSCU;
         Function ReadPropertiesSCU(COwner:TComponent;Namep,Resourcep:Pointer;Var ClassPointer:Pointer):Boolean;
         Function ReadComponentsSCU(NameTable,ResourceTable:Pointer;Var ClassP:Pointer):Boolean;
         Procedure ReadResourceSCU(ResourceTable:Pointer;Var ClassP:Pointer);
         Procedure WriteComponent(Child:TComponent);
         Procedure ReadSCU(Data:Pointer);
      Protected
         Procedure SetupComponent;Virtual;
         Procedure Loaded;Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Virtual;
         Procedure LoadingFromSCU(SCUParent:TComponent);Virtual;
         Procedure GetChildren(Proc:TGetChildProc);Virtual;
         Function HasParent:Boolean;Virtual;
         Procedure UpdateLinkList(Const PropertyName:String;LinkList:TList);Virtual;  //For Component links
      Public
         Constructor Create(AOwner:TComponent);Virtual;
         Destructor Destroy;Override;
         Procedure InsertComponent(AComponent:TComponent);Virtual;
         Procedure RemoveComponent(AComponent:TComponent);Virtual;
         Function IndexOfComponent(AComponent:TComponent):LongInt;
         Procedure DestroyComponents;
         Function FindComponent(Const AName:String):TComponent;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Virtual;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Virtual;
         Procedure ReadFromStream(SCUStream:TStream);
         Procedure WriteToStream(SCUStream:TStream);
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Virtual;
         Procedure FreeNotification(AComponent:TComponent);Virtual;
         Procedure SetDesigning(Value:Boolean);Virtual;
         Procedure GetDesignerPopupEvents(AString:TStringList);Virtual;
         Procedure DesignerPopupEvent(Id:LongInt);Virtual;
         Property Owner:TComponent Read FOwner write FOwner;
         Property Components[Index:LongInt]:TComponent Read GetComponent;
         Property ComponentCount:LongInt Read GetComponentCount;
         Property ComponentIndex:LongInt Read GetComponentIndex Write SetComponentIndex;
         Property ComponentState:TComponentState Read FComponentState Write FComponentState;
         Property DesignerState:TDesignerState Read FDesignerState Write FDesignerState; stored;
         Property UnitName:String Read GetUnitName;
         Property TypeName:String Read GetTypeName Write SetTypeName;
         Property Designed:Boolean Read GetDesigned;
         Property FreeNotifyList:TList Read FFreeNotifyList;
         Property Methods:Pointer Read FMethods Write FMethods;      {undocumented}
      Published
         Property Name:String Read GetName Write SetName;
         Property Tag:LongInt Read FTag Write FTag;
    End;
    TComponentClass=Class Of TComponent;

    TCollection = Class;

    TCollectionItem = Class
      Private
         FCollection:TCollection;
      Private
         Function GetIndex:LongInt;
         Procedure SetCollection(NewValue:TCollection);
      Protected
         Procedure SetIndex(NewIndex:LongInt);Virtual;
         Procedure changed(AllItems:Boolean);
      Public
         Procedure Assign(Source:TCollectionItem);Virtual;Abstract;
         Constructor Create(ACollection: TCollection);Virtual;
         Destructor Destroy;Override;
      Public
         Property collection:TCollection Read FCollection Write SetCollection;
         Property Index:LongInt Read GetIndex Write SetIndex;
    End;

    TCollectionItemClass=Class Of TCollectionItem;

    TCollection=Class(TComponent)
      Private
         FItemClass:TCollectionItemClass;
         FItems:TList;
         FUpdateCount:LongInt;
      Private
         Function GetCount:LongInt;
         Procedure InsertItem(Item:TCollectionItem);
         Procedure RemoveItem(Item:TCollectionItem);
      Protected
         Procedure changed;
         Function GetItem(Index:LongInt):TCollectionItem;
         Procedure SetItem(Index:LongInt;Value:TCollectionItem);
      Public
         Procedure Update(Item:TCollectionItem);Virtual;
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Function Add:TCollectionItem;
         Procedure Assign(Source:TCollection);Virtual;
         Procedure BeginUpdate;
         Procedure Clear;
         Procedure EndUpdate;
         Function Insert(Index:longint):TCollectionItem;
         Procedure Swap(Index1,Index2:longint);
      Public
         Property Count:LongInt Read GetCount;
         Property Items[Index:LongInt]:TCollectionItem Read GetItem Write SetItem;
         Property ItemClass:TCollectionItemClass Read FItemClass Write FItemClass;
    End;


    TStringSelectList=Class(TComponent)
      Private
         FList:TStringList;
         FSelected:String;
      Protected
         Procedure SetStringItem(NewValue:String);Virtual;
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Function GetItems:TStringList;Virtual;
         Property SelectedItem:String Read FSelected Write SetStringItem;
         Property Items:TStringList Read GetItems;
    End;


    {$M+}
    TThreadPriority=(tpIdle,tpLowest,tpLower,tpNormal,tpHigher,tpHighest,tpTimeCritical);
    {$M-}

    TThreadMethod=Procedure Of Object;

    TThread=Class
      Private
         FOnTerminate:TNotifyEvent;
         FHandle:LongWord;
         FPriority:TThreadPriority;
         FFreeOnTerminate:Boolean;
         FTerminated:Boolean;
         FReturnValue:LongInt;
         FSuspended:Boolean;
         FFinished:Boolean;
         FThreadId:LongWord;
         FParameter:Pointer;
         FMethod:TThreadMethod;
         Procedure SetSuspended(NewValue:Boolean);
         Procedure SetPriority(NewValue:TThreadPriority);
         Procedure SyncTerminate;
         Procedure MsgIdle;
      Protected
         Procedure DoTerminate;Virtual;
         Procedure Execute;Virtual;Abstract;
      Public
         Constructor Create(CreateSuspended:Boolean);
         Constructor ExtCreate(CreateSuspended:Boolean;StackSize:LongWord;
                               Priority:TThreadPriority;Param:Pointer);
         Destructor Destroy;Override;
         Function WaitFor:LongInt;
         Procedure Terminate;
         Procedure Suspend;
         Procedure Resume;
         Procedure Kill;
         Procedure Synchronize(method:TThreadMethod);
         Procedure ProcessMsgs;
         Property Terminated:Boolean Read FTerminated;
         Property ReturnValue:LongInt Read FReturnValue Write FReturnValue;
         Property ThreadId:LongWord Read FThreadId;
         Property Handle:LongWord Read FHandle;
         Property Priority:TThreadPriority Read FPriority Write SetPriority;
         Property Parameter:Pointer Read FParameter Write FParameter;
         Property Suspended:Boolean Read FSuspended Write SetSuspended;
         Property FreeOnTerminate:Boolean Read FFreeOnTerminate Write FFreeOnTerminate;
         Property OnTerminate:TNotifyEvent Read FOnTerminate Write FOnTerminate;
    End;


Procedure RegisterClasses(Const ComponentClasses: Array Of TComponentClass);
Function SearchClassByName(Const Name:String):TComponentClass;
Function CallReadProp(Objekt:TObject;FuncAddr:Pointer;Typ:Byte;
                      TypLen:LongInt;Value:Pointer):Boolean;
Function CallWriteProp(Objekt:TObject;ProcAddr:Pointer;Typ:Byte;
                       TypLen:LongInt;Value:Pointer):Boolean;


Type
    PSCUFileFormat=^TSCUFileFormat;
    TSCUFileFormat=Record
         Version:String[5];
         ObjectOffset,ObjectLen:LongInt;
         NameTableOffset,NameTableLen:LongInt;
         ResourceOffset,ResourceLen:LongInt;
         ObjectCount:LongInt;
         UseEntry:LongInt; {used by project management}
         NextEntry:Pointer;
         {auch System ndern (AddSCUData) und Compiler.PAS}
    End;


    PFormListItem=^TFormListItem;
    TFormListItem=Record
         Form:TComponent;
         FormName:String[64];
         UnitName:String;
         AutoCreate:Boolean;
         SCUPointer:Pointer;
         SCUSize:LongInt;
    End;


Function WritePropertiesToStream(FormList:TList):TMemoryStream;
Function WritePropertiesToFile(FileName:String;FormList:TList):Boolean;


Type
    TMsgDlgBtn=(mbYes,mbNo,mbOk,mbCancel,mbAbort,mbRetry,mbIgnore,mbAll,mbHelp);
    TMsgDlgButtons=Set Of TMsgDlgBtn;
    TMsgDlgType=(mtWarning,mtError,mtInformation,mtConfirmation,mtCustom,mtCritical);
    TMsgDlgReturn=LongWord;
Const
    mrBase    = $8000;      //cmBase
    mrOk      = mrBase+50;  //cmOk
    mrCancel  = mrBase+51;  //cmCancel
    mrYes     = mrBase+53;  //cmYes
    mrNo      = mrBase+54;  //cmNo
    mrIgnore  = mrBase+58;  //cmIgnore
    mrRetry   = mrBase+57;  //cmRetry
    mrAbort   = mrBase+56;  //cmAbort
    mrNone    = 0;          //cmNull
    mrAll     = mrBase+59;  //cmAll

Const
    mbYesNo=[mbYes,mbNo];
    mbYesNoCancel=[mbYes,mbNo,mbCancel];
    mbOkCancel=[mbOk,mbCancel];
    mbAbortRetryIgnore=[mbAbort,mbRetry,mbIgnore];


Function MessageBox2(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Function ErrorBox2(Const Msg:String):TMsgDlgReturn;

Function GetExperts:TList;  {noch raus?}


Var RegisteredClasses:TList;
    PropertyEditDialogs:TList;
    LibExperts:TList;
    LibExpertInstances:TList;

Type
    TPropertyEditorReturn=(edOk,edCancel,edList,edNoEditor);

    TPropertyEditor=Class(TComponent)
       Private
         FPropertyOwner:TComponent;
         FPropertyName:String;
         FList:TStringList;
       Public
         Function Execute(Var Value;ValueLen:LongInt):TPropertyEditorReturn;Virtual;Abstract;
       Public
         Property PropertyOwner:TComponent Read FPropertyOwner;
         Property PropertyName:String Read FPropertyName;
         Property List:TStringList Read FList;
    End;
    TPropertyEditorClass=Class Of TPropertyEditor;

    {$HINTS OFF}
    TStringPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:String;ValueLen:LongInt):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TShortIntPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:ShortInt):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TIntegerPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:Integer):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TLongIntPropertyEditor=Class(TPropertyEditor)
       Public
         Function Execute(Var Value:LongInt):TPropertyEditorReturn;Virtual;Abstract;
    End;

    TClassPropertyEditorReturn=(peOk,peCancel,peClear,peNoEditor);

    TClassPropertyEditor=Class(TPropertyEditor)
      Private
         Property PropertyOwner;
         Property PropertyName;
         Property List;
      Public
         Function Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;Virtual;
    End;
    TClassPropertyEditorClass=Class Of TClassPropertyEditor;
    {$HINTS ON}

    EClassNotFound=Class(Exception);

Procedure RegisterClass(Const ComponentClass:TComponentClass);
Function GetClass(Const ClassName:String):TComponentClass;
Function FindClass(Const ClassName:String):TComponentClass;
Procedure UnRegisterClass(AClass:TComponentClass);
Procedure UnRegisterClasses(Const AClasses:Array of TComponentClass);
Procedure AddPropertyEditor(OwnerClass:TClass;PropertyName:String;PropertyEditor:TPropertyEditorClass);
Function CallPropertyEditor(Owner:TComponent;PropertyName:String;Var Value;ValueLen:LongInt;
                             Var List:TStringList):TPropertyEditorReturn;
Function PropertyEditorAvailable(OwnerClass:TClass;PropertyName:String):Boolean;

Procedure AddClassPropertyEditor(ClassToEdit:TClass;PropertyEditor:TClassPropertyEditorClass);
Function CallClassPropertyEditor(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Function ClassPropertyEditorAvailable(ClassName:String):Boolean;

Procedure AddDesignerPopupEvent(AString:TStringList;Caption:String;Id:LongInt);

Function GetTempFileName:String;
Function InDesigner:Boolean;


Implementation

//!!!!!!!!!! bei nderungen auch Language Manager und SIB_DLG ndern!!!!!!!!!!!!!!!!!!!
Type
     PLanguageMessages=^TLanguageMessages;
     TLanguageMessages=Record
                         Name:PString;  //Language Name
                         StringTableLen:LongWord;
                         StringTable:Pointer;
                         Next:PLanguageMessages;
     End;

     PLanguageComponent=^TLanguageComponent;
     TLanguageComponent=Record
                         Name:PString;
                         OriginalInstance:TComponent;
                         Instance:TComponent;
                         ValueScope:Byte;
                         ValueTyp:Byte;
                         ValueRead:TPropertyReadWriteRecord;
                         ValueWrite:TPropertyReadWriteRecord;
                         ValueSize:LongWord;
                         ValueLen:LongWord;
                         Value:Pointer;
                         ControlLeft,ControlBottom:LongInt;
                         ControlWidth,ControlHeight:LongInt;
                         OrigControlLeft,OrigControlBottom:LongInt;
                         OrigControlWidth,OrigControlHeight:LongInt;
                         Next:PLanguageComponent;
     End;

     PLanguageItem=^TLanguageItem;
     TLanguageItem=Record
                         Name:PString;
                         Components:PLanguageComponent;
                         Menus:PLanguageComponent;
                         StringTables:PLanguageComponent;
                         Next:PLanguageItem;
     End;
//!!!!!!!!!! bei nderungen auch Language Manager ndern!!!!!!!!!!!!!!!!!!!
     PLanguageInfo=^TLanguageInfo;
     TLanguageInfo=Record
                         CurrentLanguageName:PString;  //only Copy !!
                         CurrentLanguageComponents:PLanguageComponent;  //only Copy !
                         CurrentLanguageMenus:PLanguageComponent; //only Copy !
                         CurrentLanguageStringTables:PLanguageComponent; //only Copy
                         Items:PLanguageItem;
     End;
//!!!!!!!!!! bei nderungen auch Language Manager und SIB_DLG ndern!!!!!!!!!!!!!!!!!!!
//////////////////////////////////////////////////////////////////////////////////////////////////////////

Var LanguageMessages:PLanguageMessages;
    AppLanguage:String;

Procedure DestroyMessages;
Var dummy:PLanguageMessages;
Begin
     While LanguageMessages<>NIL Do
     Begin
          dummy:=LanguageMessages^.Next;
          If LanguageMessages^.Name<>Nil Then
            FreeMem(LanguageMessages^.Name,length(LanguageMessages^.Name^)+1);
          If LanguageMessages^.StringTable<>Nil Then
            FreeMem(LanguageMessages^.StringTable,LanguageMessages^.StringTableLen);
          Dispose(LanguageMessages);
          LanguageMessages:=dummy;
     End;
     LanguageMessages:=Nil;
     AppLanguage:='Default';
End;

Type TLanguageComponentKinds=(Captions,Menus,StringTables);


Procedure SetupLanguageComponents(Component:TComponent;Items:PLanguageComponent;Kind:TLanguageComponentKinds);
Var
    WriteTyp,ReadTyp:Byte;
    WriteOffset,ReadOffset:LongWord;
    ValueTyp:Byte;
    Info:TPropertyTypeInfo;
    S,s1:String;
    T:LongInt;
    Temp,Temp1:TComponent;
    p2:^LongWord;
    B:Byte;
    C:TObject;

    Procedure WriteInt(Const Name:String;Value:LongInt);
    Var Info:TPropertyTypeInfo;
    Begin
         If Temp.GetPropertyTypeInfo(Name,Info) Then
         Begin
              //Info available
              Case Info.Write.Kind Of
                 1:
                 Begin
                      p2:=Pointer(Temp);
                      Inc(p2,Info.Write.VarOffset);
                      System.Move(Value,p2^,Info.Size);
                 End;
                 2,3:
                 Begin
                      CallWriteProp(Temp,Pointer(Info.Write.VarOffset),
                                    Info.Typ,Info.Size,@Value);
                 End;
              End; //Case
         End;
    End;

Label skip;
Begin
     While Items<>Nil Do //process All Language Components
     Begin
          If ((Items^.ValueTyp<>0)And(Items^.ValueWrite.Kind<>0)And(Items^.Instance<>Nil)) Then //Read And Write information are Valid
          Begin
               ValueTyp:=Items^.ValueTyp;
               WriteTyp:=Items^.ValueWrite.Kind;
               WriteOffset:=Items^.ValueWrite.VarOffset;
               ReadTyp:=Items^.ValueRead.Kind;
               ReadOffset:=Items^.ValueRead.VarOffset;
               Temp:=Items^.Instance;
          End
          Else
          Begin
               Temp:=Component;
               S:=Items^.Name^;
               B:=Pos('.',S);
               While B<>0 Do
               Begin
                    s1:=Copy(S,1,B-1);
                    Delete(S,1,B);

                    Temp1:=Nil;
                    For T:=0 To Temp.ComponentCount-1 Do
                    Begin
                        Temp1:=Temp.Components[T];
                        If Temp1.Name=s1 Then
                        Begin
                             Temp:=Temp1;
                             break; //found !
                        End;
                        Temp1:=Nil;
                    End;
                    If Temp1=Nil Then Goto skip;  //Not found

                    B:=Pos('.',S);
               End;

               If Not Temp.GetPropertyTypeInfo(S,Info) Then Goto skip;

               Items^.Instance:=Temp;
               Items^.ValueRead:=Info.Read;
               Items^.ValueWrite:=Info.Write;
               Items^.ValueSize:=Info.Size;
               Items^.ValueTyp:=Info.Typ;
               ValueTyp:=Info.Typ;
               WriteTyp:=Info.Write.Kind;
               WriteOffset:=Info.Write.VarOffset;
               ReadTyp:=Info.Read.Kind;
               ReadOffset:=Info.Read.VarOffset;
          End;

          If ((ValueTyp=PropType_Class)And(Kind=StringTables)) Then
          Begin
               Case ReadTyp Of
                 0:Goto skip;
                 1:
                 Begin
                    p2:=Pointer(Temp);
                    Inc(p2,ReadOffset);
                    System.Move(p2^,C,4);
                 End;
                 2,3:
                 Begin
                    CallReadProp(Temp,Pointer(ReadOffset),
                                 ValueTyp,4,@C);
                End;
                Else Goto skip;
               End; //Case

               If Not (C Is TStrings) Then Goto skip;
               TStrings(C).SetText(Pointer(Items^.Value));
               Goto skip;
          End
          Else If ((ValueTyp<>PropType_String)And(ValueTyp<>PropType_CString)) Then Goto skip;

          //Info available
          Case WriteTyp Of
             1:
             Begin
                 p2:=Pointer(Temp);
                 Inc(p2,WriteOffset);
                 System.Move(Items^.Value^,p2^,Items^.ValueLen);
             End;
             2,3:
             Begin
                 CallWriteProp(Temp,Pointer(WriteOffset),
                               ValueTyp,
                               Items^.ValueLen,Items^.Value);
             End;
             Else Goto skip;
          End; //Case

          If Kind=Captions Then
            If Not (csForm In Temp.ComponentState) Then
          Begin
               //Write Language specific Position
               WriteInt('Left',Items^.ControlLeft);
               WriteInt('Bottom',Items^.ControlBottom);
               WriteInt('Width',Items^.ControlWidth);
               WriteInt('Height',Items^.ControlHeight);
          End;
skip:
          Items:=Items^.Next;
     End;
End;

Procedure GetLanguage(Component:TComponent;Var Language:String);
Var Info:PLanguageInfo;
Begin
   Info:=PLanguageInfo(Component.FLanguages);
   If ((Info=Nil)Or(Info^.CurrentLanguageName=Nil)) Then Language:='Default'
   Else Language:=Info^.CurrentLanguageName^;
End;

Procedure UpdateLanguageComponents(Items:PLanguageComponent;Kind:TLanguageComponentKinds);
Var
    ReadTyp:Byte;
    ReadOffset:LongWord;
    ValueTyp:Byte;
    Temp:TComponent;
    p2:^LongWord;
    C:TObject;
    P:PChar;
    S:String;

    Procedure ReadInt(Const Name:String;Var Value:LongInt);
    Var Info:TPropertyTypeInfo;
    Begin
         If Temp.GetPropertyTypeInfo(Name,Info) Then
         Begin
              //Info available
              Case Info.Read.Kind Of
                 1:
                 Begin
                      p2:=Pointer(Temp);
                      Inc(p2,Info.Read.VarOffset);
                      System.Move(p2^,Value,Info.Size);
                 End;
                 2,3:
                 Begin
                      CallReadProp(Temp,Pointer(Info.Read.VarOffset),
                                   Info.Typ,Info.Size,@Value);
                 End;
              End; //Case
         End;
    End;

Label skip;
Begin
     While Items<>Nil Do //process All Language Components
     Begin
          If ((Items^.ValueTyp<>0)And(Items^.ValueRead.Kind>0)And(Items^.Instance<>Nil)) Then
          Begin
               ValueTyp:=Items^.ValueTyp;
               ReadTyp:=Items^.ValueWrite.Kind;
               ReadOffset:=Items^.ValueRead.VarOffset;
               Temp:=Items^.Instance;

               If not (Temp Is TComponent) Then continue;

               Try
                  If ((ValueTyp=PropType_Class)And(Kind=StringTables)) Then
                  Begin
                       Case ReadTyp Of
                         0:Goto skip;
                         1:
                         Begin
                            p2:=Pointer(Temp);
                            Inc(p2,ReadOffset);
                            System.Move(p2^,C,4);
                         End;
                         2,3:
                         Begin
                            CallReadProp(Temp,Pointer(ReadOffset),
                                         ValueTyp,4,@C);
                        End;
                        Else Goto skip;
                       End; //Case

                       If Not (C Is TStrings) Then Goto skip;
                       P:=TStrings(C).GetText;
                       If Items^.ValueLen>0 Then FreeMem(Items^.Value,Items^.ValueLen);
                       If P=Nil Then
                       Begin
                            Items^.ValueLen:=0;
                            Items^.Value:=Nil;
                       End
                       Else
                       Begin
                            Items^.ValueLen:=Length(P^)+1;
                            GetMem(Items^.Value,Items^.ValueLen);
                            Move(P^,Items^.Value^,Items^.ValueLen);
                            StrDispose(P);
                       End;

                       Goto skip;
                  End
                  Else If ValueTyp<>PropType_String Then Goto skip;

                  //Info available
                  S:='';
                  Case ReadTyp Of
                     1:
                     Begin
                         p2:=Pointer(Temp);
                         Inc(p2,ReadOffset);
                         System.Move(p2^,S,Items^.ValueSize);
                     End;
                     2,3:
                     Begin
                         CallReadProp(Temp,Pointer(ReadOffset),
                                      ValueTyp,
                                      Items^.ValueSize,@S);
                     End;
                     Else Goto skip;
                  End; //Case

                  If Items^.ValueLen>0 Then FreeMem(Items^.Value,Items^.ValueLen);
                  Items^.ValueLen:=Length(S)+1;
                  GetMem(Items^.Value,Items^.ValueLen);
                  Move(S,Items^.Value^,Items^.ValueLen);

                  If Kind=Captions Then
                    If Not (csForm In Temp.ComponentState) Then
                  Begin
                       //Write Language specific Position
                       ReadInt('Left',Items^.ControlLeft);
                       ReadInt('Bottom',Items^.ControlBottom);
                       ReadInt('Width',Items^.ControlWidth);
                       ReadInt('Height',Items^.ControlHeight);
                  End;
               Except
               End;
          End;
skip:
          Items:=Items^.Next;
     End;
End;


Procedure SetLanguage(Component:TComponent;Language:String);
Var Info:PLanguageInfo;
    Item:PLanguageItem;
    S,s1,s2:String;
Begin
     Info:=PLanguageInfo(Component.FLanguages);
     If Info=Nil Then Exit;
     S:=Language;
     UpcaseStr(S);
     If Info^.CurrentLanguageName<>Nil Then
     Begin
          s1:=Info^.CurrentLanguageName^;
          UpcaseStr(s1);
          If S=s1 Then If S<>'DEFAULT' Then
          Begin
               Item:=Info^.Items;
               While Item<>Nil Do
               Begin
                    s1:=Item^.Name^;
                    UpcaseStr(s1);
                    If S=s1 Then Exit; //the Item Is present And Set !
                    Item:=Item^.Next;
               End;

               S:='DEFAULT';
          End;

          //Update old Language
          s1:=Info^.CurrentLanguageName^;
          UpcaseStr(s1);
          Item:=Info^.Items;
          While Item<>Nil Do
          Begin
               s2:=Item^.Name^;
               UpcaseStr(s2);
               If s1=s2 Then
               Begin
                    UpdateLanguageComponents(Item^.Components,Captions);
                    UpdateLanguageComponents(Item^.Menus,Menus);
                    UpdateLanguageComponents(Item^.StringTables,StringTables);
                    break;
               End;
               Item:=Item^.Next;
          End;
     End;

     Item:=Info^.Items;
     While Item<>Nil Do
     Begin
          s1:=Item^.Name^;
          UpcaseStr(s1);
          If S=s1 Then
          Begin
               SetupLanguageComponents(Component,Item^.Components,Captions);
               SetupLanguageComponents(Component,Item^.Menus,Menus);
               SetupLanguageComponents(Component,Item^.StringTables,StringTables);

               Info^.CurrentLanguageName:=Item^.Name;
               Info^.CurrentLanguageComponents:=Item^.Components;
               Info^.CurrentLanguageMenus:=Item^.Menus;
               Info^.CurrentLanguageStringTables:=Item^.StringTables;

               Exit;
          End;
          Item:=Item^.Next;
     End;
End;

Procedure GetAppLanguage(Var Language:String);
Begin
     Language:=AppLanguage;
End;

Procedure SetAppLanguage(Const Language:String);
Begin
     AppLanguage:=Language;
End;

Const
    {$IFDEF OS2}
    SCUVersion:String[5] = 'SCU01';
    {$ENDIF}
    {$IFDEF Win95}
    SCUVersion:String[5] = 'SCW01';
    {$ENDIF}

Var
    InsideCompLib:Boolean;
    InsideWriteSCU:Boolean;
    InsideWriteSCUAdr:^Boolean;
    InsideDesigner:Boolean;
    InsideLanguageDesigner:Boolean;

Type
    PIDE_OwnerList=^TIDE_OwnerList;
    TIDE_OwnerList=Record
         PropertyName:PString;
         Objekt:TComponent;
    End;

    PIDE_Methods=^TIDE_Methods;
    TIDE_Methods=Record
         Name:PString;
         Params:PString;
         Owners:TList;
         Next:PIDE_Methods;
    End;


Function GetTempFileName:String;
Var  Hour,Minute,Second,Sec100:Word;
     S,dir:String;
Begin
     If GetTime(Hour,Minute,Second,Sec100) = 0 Then
     Begin
          S := 'tmp'+ tostr(Minute)+tostr(Second)+tostr(Sec100) +'.tmp';
     End
     Else S := 'tmp0001.tmp';

     dir := GetEnv('TMP');
     If dir = '' Then dir := GetEnv('TEMP');
     If dir = '' Then
     Begin
          {$I-}
          GetDir(0,dir);
          {$I+}
     End;
     If dir[Length(dir)] <> '\' Then dir := dir + '\';
     Result := dir + S;
End;


Function InDesigner:Boolean;
Begin
     Result:=InsideDesigner;
End;


Function ColorName(ColorValue:TColor):String;
Var  T:LongInt;
Begin
     For T := 1 To MaxDefaultColors Do
     Begin
          If DefaultColors[T].Value = ColorValue Then
          Begin
               Result := DefaultColors[T].Name;
               Exit;
          End;
     End;

     For T := 1 To MaxSystemColors Do
     Begin
          If SystemColors[T].Value = ColorValue Then
          Begin
               Result := SystemColors[T].Name;
               Exit;
          End;
     End;

     Result := tostr(ColorValue);
End;


Function ColorValue(ColorName:String):TColor;
Var  T:LongInt;
     C:Integer;
     S:String;
Begin
     UpcaseStr(ColorName);

     For T := 1 To MaxDefaultColors Do
     Begin
          S := DefaultColors[T].Name;
          UpcaseStr(S);
          If S = ColorName Then
          Begin
               Result := DefaultColors[T].Value;
               Exit;
          End;
     End;

     For T := 1 To MaxSystemColors Do
     Begin
          S := SystemColors[T].Name;
          UpcaseStr(S);
          If S = ColorName Then
          Begin
               Result := SystemColors[T].Value;
               Exit;
          End;
     End;

     Val(ColorName,Result,C);
     If C <> 0 Then Result := 0;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TStream Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TStream.CopyFrom(Source:TStream;Count:LongInt):LongInt;
Var
  ActBufSize,T:LongInt;
  StreamBuffer:Pointer;
Const
  MaxBufSize = $FFFF;
Begin
  If Count = 0 Then
  Begin
    Count := Source.Size;
    Source.Position := 0;
  End;

  Result := Count;

  If Count > MaxBufSize Then ActBufSize:=MaxBufSize
  Else ActBufSize := Count;

  GetMem(StreamBuffer,ActBufSize);

  Try
    While Count<>0 Do
    Begin
      If Count>ActBufSize Then T:=ActBufSize
      Else T:=Count;

      Source.ReadBuffer(StreamBuffer^,T);
      WriteBuffer(StreamBuffer^,T);
      Dec(Count,T);
    End;
  Finally
    FreeMem(StreamBuffer, ActBufSize);
  End;
End;

Function TStream.GetSize:LongInt;
Var
   OldPos:LongInt;
   Result:LongInt;
Begin
     OldPos:=GetPosition;
     Result:=Seek(0,Seek_End);
     SetPosition(OldPos);
     GetSize:=Result;
End;

Function TStream.EndOfData: Boolean;
Begin
  Result := (Position >= Size);
End;

Function TStream.GetPosition:LongInt;
Begin
     GetPosition:=Seek(0,Seek_Current);
End;

Procedure TStream.SetPosition(NewPos:LongInt);
Begin
     Seek(NewPos,Seek_Begin);
End;

Procedure TStream.ReadBuffer(Var Buffer;Count:LongInt);
Begin
     If Count=0 Then Exit;  {Nothing To Read}
     If Read(Buffer,Count)<>Count Then Error(SStreamReadErrorText);
End;

Procedure TStream.WriteBuffer(Const Buffer;Count:LongInt);
Begin
     If Count=0 Then Exit;
     If Write(Buffer,Count)<>Count Then Error(SStreamWriteErrorText);
End;

Procedure TStream.Error;
Begin
     Raise EStreamError.Create(LoadNLSStr(ResourceId));
End;

Function TStream.ReadLn: String;
Var
  Buffer: cstring[260];
  OldPos, Count, Temp: LongInt;
Begin
  OldPos := Position;

  Count := Read(Buffer[0], 257);
  Buffer[Count] := #0;

  Temp := 0;
  While Not (Buffer[Temp] In [#10, #13, #26])
    And (Temp < Count) And (Temp < 255) Do Inc (Temp);

  Move(Buffer[0], Result[1], Temp);
  Result[0]:=Chr(Temp);
  Inc(Temp);

  If (Buffer[Temp - 1] = #13) And (Buffer[Temp] = #10) Then Inc(Temp);

  Position := OldPos + Temp;
End;

Procedure TStream.WriteLn(Const S: String);
Var
  CRLF: Word;
Begin
  CRLF := $0A0D;
  WriteBuffer(S[1], Length(S));
  WriteBuffer(CRLF, 2);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: THandleStream Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor THandleStream.Create(AHandle: LongInt);
Begin
  FHandle := AHandle;
End;

Function THandleStream.Read(Var Buffer; Count: LongInt): LongInt;
Begin
  Result := FileRead(Handle, Buffer, Count);
  If Result = -1 Then Result := 0;
End;

Function THandleStream.Write(Const Buffer; Count: LongInt): LongInt;
Var Temp:^Byte;
Begin
  Temp:=@Buffer;
  Result := FileWrite(Handle, Temp^, Count);
  If Result = -1 Then Result := 0;
End;

Function THandleStream.Seek(Offset: LongInt; Origin: Word): LongInt;
Begin
  Result := FileSeek(Handle, Offset, Origin);
  If Result < 0 Then Error(SStreamSeekErrorText);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TFileStream Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TFileStream.Create(Const FileName:String;Mode:LongWord);
Var
  SaveMode: LongWord;
Begin
     Inherited Create;

     SaveMode := FileMode;

     If Mode = fmCreate Then FileMode := fmOpenReadWrite Or fmShareExclusive
     Else FileMode := Mode;

     Try
        Assign(PStreamFile,FileName);
        If Mode = fmCreate Then
        Begin
            {$I-}
            Rewrite(PStreamFile,1);
            {$I+}
            If InOutRes<>0 Then Raise EFCreateError.Create(LoadNLSStr(SStreamCreateErrorText));
        End
        Else
        Begin
           {$I-}
           Reset(PStreamFile,1);
           {$I+}
           If InOutRes<>0 Then Raise EFOpenError.Create(LoadNLSStr(SStreamOpenErrorText));
        End;
     Finally
        FileMode := SaveMode;
     End;
End;

Destructor TFileStream.Destroy;
Begin
     {$I-}
     Close(PStreamFile);
     {$I+}
     Inherited Destroy;
End;

Function TFileStream.Read(Var Buffer;Count:LongInt):LongInt;
Var
   Result:LongWord;
Begin
     {$I-}
     BlockRead(PStreamFile,Buffer,Count,Result);
     {$I+}
     If InOutRes<>0 Then Error(SStreamReadErrorText);
     Read:=Result;
End;

Function TFileStream.Write(Const Buffer;Count:LongInt):LongInt;
Var
   pb:Pointer;
   Result:LongWord;
Begin
     pb:=@Buffer;
     {$I-}
     BlockWrite(PStreamFile,pb^,Count,Result);
     {$I+}
     If InOutRes<>0 Then Error(SStreamWriteErrorText);
     Write:=Result;
End;

Function TFileStream.Seek(Offset:LongInt;Origin:Word):LongInt;
Var
   SaveSeekMode:LongWord;
Begin
     SaveSeekMode:=SeekMode;
     SeekMode:=Origin;
     {$I-}
     System.Seek(PStreamFile,Offset);
     {$I+}
     If InOutRes<>0 Then Error(SStreamSeekErrorText);
     SeekMode:=SaveSeekMode;
     {$I-}
     Seek:=FilePos(PStreamFile);
     {$I+}
     If InOutRes<>0 Then Error(SStreamSeekErrorText);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMemoryStream Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
  MemoryDelta = 8192;

Destructor TMemoryStream.Destroy;
Begin
  Clear;
  Inherited Destroy;
End;

Function TMemoryStream.Read(Var Buffer; Count: LongInt): LongInt;
Begin
  If Count > 0 Then
  Begin
    Result := FSize - FPosition;
    If Count < Result Then Result := Count;
    Move(FBuffer^[FPosition], Buffer, Result);
    Inc(FPosition, Result);
  End
  Else Result := 0;
End;

Function TMemoryStream.Write(Const Buffer; Count: LongInt): LongInt;
Var
  NewPos, Needed: LongInt;
Begin
  If Count > 0 Then
  Begin
    NewPos := FPosition + Count;
    If NewPos > FSize Then
    Begin
      FSize := NewPos;
      If NewPos > FCapacity Then
      Begin
        Needed := (NewPos - FCapacity + MemoryDelta - 1) Div MemoryDelta;
        SetCapacity(FCapacity + Needed * MemoryDelta);
      End;
    End;
    Move(Buffer, FBuffer^[FPosition], Count);
    FPosition := NewPos;
  End;
  Result := Count;
End;

Function TMemoryStream.Seek(Offset: LongInt; Origin: Word): LongInt;
Begin
  Case Origin Of
    soFromBeginning: Result := Offset;
    soFromCurrent:   Result := FPosition + Offset;
    soFromEnd:       Result := FSize - Offset;
  End;
  If (Result < 0) Or (Result > FSize) Then Error(SStreamSeekErrorText)
  Else FPosition := Result;
End;

Procedure TMemoryStream.LoadFromStream(Stream: TStream);
Var
  ToDo: LongInt;
Begin
  Stream.Position := 0;
  ToDo := Stream.Size;
  SetSize(ToDo);
  If ToDo <> 0 Then Stream.ReadBuffer(FBuffer^[0], ToDo);
End;

Procedure TMemoryStream.LoadFromFile(Const FileName:String);
Var
  Source: TFileStream;
Begin
  Source := TFileStream.Create(FileName, Stream_OpenRead);
  Try
    LoadFromStream(Source);
  Finally
    Source.Destroy;
  End;
End;

Procedure TMemoryStream.SaveToStream(Stream: TStream);
Begin
  If FSize <> 0 Then Stream.WriteBuffer(FBuffer^[0], FSize);
End;

Procedure TMemoryStream.SaveToFile(Const FileName:String);
Var
  Dest: TFileStream;
Begin
  Dest := TFileStream.Create(FileName, Stream_Create);
  Try
    SaveToStream(Dest);
  Finally
    Dest.Destroy;
  End;
End;

Procedure TMemoryStream.SetCapacity(NewCapacity: LongInt);
Begin
  If FCapacity=NewCapacity Then Exit;
  FBuffer := ReAllocMem(FBuffer, FCapacity, NewCapacity);
  FCapacity := NewCapacity;
  If FSize > FCapacity Then FSize := FCapacity;
  If FPosition > FSize Then FPosition := FSize;
End;

Procedure TMemoryStream.SetSize(NewSize: LongInt);
Begin
  Clear;
  SetCapacity(NewSize);
  FSize := NewSize;
End;

Procedure TMemoryStream.Clear;
Begin
  SetCapacity(0);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TList Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TList.Error;
Begin
     Raise EListError.Create(LoadNLSStr(SListErrorText));
End;


Function TList.Get(Index:LongInt):Pointer;
Begin
     Result := Nil;
     If (Index < 0) Or (Index >= FCount) Then Error
     Else Result := FList^[Index];
End;


Procedure TList.Put(Index:LongInt;Item:Pointer);
Begin
     If (Index < 0) Or (Index >= FCount) Then Error
     Else FList^[Index] := Item;
End;


Procedure TList.Grow;
Var  gr:LongInt;
Begin
     If FGrowth <= 0 Then
     Begin
          If FCapacity < 128 Then gr := 16
          Else gr := FCapacity Shr 3;
     End
     Else gr := FGrowth;
     SetCapacity(FCapacity + gr);
End;


Procedure TList.SetCapacity(NewCapacity:LongInt);
Var  NewList:PPointerList;
Begin
     If (NewCapacity > MaxListSize) Or (NewCapacity < FCount) Then Error
     Else
     If NewCapacity <> FCapacity Then
     Begin
          If NewCapacity > 0 Then
          Begin
               GetMem(NewList, NewCapacity*SizeOf(Pointer));
               If FCount > 0 Then System.Move(FList^,NewList^,
                                              FCount*SizeOf(Pointer));
          End
          Else NewList := Nil;
          If FList<>Nil Then FreeMem(FList, FCapacity*SizeOf(Pointer));
          FCapacity := NewCapacity;
          FList := NewList;
     End;
End;


Procedure TList.SetCount(NewCount:LongInt);
Var  I:LongInt;
Begin
     If NewCount=FCount Then Exit;
     If (NewCount > MaxListSize) Or (NewCount < 0) Then Error
     Else
     Begin
          If NewCount > FCapacity Then SetCapacity(NewCount);
          If NewCount < FCount Then
          Begin
               For I := NewCount To FCount-1 Do FreeItem(FList^[I]);
          End
          Else FillChar(FList^[FCount], (NewCount-FCount)*SizeOf(Pointer),0);
          FCount := NewCount;
     End;
End;


{--- Public part ------------------------------------------------------------}

(* Clear the whole List And Destroy the List Object *)
Destructor TList.Destroy;
Begin
     Clear;
     Inherited Destroy;
End;


(* Clear the whole List And Release the allocated Memory *)
Procedure TList.Clear;
Begin
     SetCount(0);
     SetCapacity(0);
End;


(*  Append A New Item At the End Of the List And return the New Index *)
Function TList.Add(Item:Pointer):LongInt;
Begin
     If FCount = FCapacity Then Grow;
     FList^[FCount] := Item;
     Inc(FCount);
     Result := FCount-1;
End;


(* Delete the Item And decrement the Count Of elements In the List *)
Procedure TList.Delete(Index:LongInt);
Begin
     If (Index < 0) Or (Index >= FCount) Then Error
     Else
     Begin
          FreeItem(FList^[Index]);

          Dec(FCount);
          If Index <> FCount Then System.Move(FList^[Index + 1],FList^[Index],
                                              (FCount-Index)*SizeOf(Pointer));
     End;
End;


(* Remove the Item And decrement the Count Of elements In the List *)
Function TList.Remove(Item:Pointer):LongInt;
Begin
     Result := IndexOf(Item);
     If Result <> -1 Then Delete(Result);
End;


(* Release the Memory allocated by the Item *)
Procedure TList.FreeItem(Item:Pointer);
Begin
     If FOnFreeItem <> Nil Then FOnFreeItem(Self,Item);
End;


(* Cut the specified Range out Of the List (including both indices) *)
Procedure TList.Cut(Index1,Index2:LongInt);
Var  I,Swap:LongInt;
Begin
     If (Index1 < 0) Or (Index1 >= FCount) Or
        (Index2 < 0) Or (Index2 >= FCount) Then Error
     Else
     Begin
          If Index2 < Index1 Then
          Begin
               Swap := Index1;
               Index1 := Index2;
               Index2 := Swap;
          End;

          For I := Index1 To Index2 Do FreeItem(FList^[I]);

          If Index2 <> FCount-1 Then System.Move(FList^[Index2+1],FList^[Index1],
                                                 (FCount-Index2)*SizeOf(Pointer));
          Dec(FCount,Index2-Index1+1);
     End;
End;


(* Insert A New Item At the specified Position In the List *)
Procedure TList.Insert(Index:LongInt;Item:Pointer);
Begin
     If (Index < 0) Or (Index > FCount) Then Error
     Else
     Begin
          If FCount = FCapacity Then Grow;
          If Index <> FCount Then System.Move(FList^[Index],FList^[Index+1],
                                              (FCount-Index)*SizeOf(Pointer));
          FList^[Index] := Item;
          Inc(FCount);
     End;
End;


(* Exchange two Items In the List *)
Procedure TList.Exchange(Index1,Index2:LongInt);
Var  Item:Pointer;
Begin
     Item := Get(Index1);
     Put(Index1, Get(Index2));
     Put(Index2, Item);
End;


(* Move an Item To A New Position In the List *)
Procedure TList.Move(CurIndex,NewIndex:LongInt);
Var  Item:Pointer;
Begin
     If (CurIndex < 0) Or (CurIndex >= FCount) Or
        (NewIndex < 0) Or (NewIndex >= FCount) Then Error
     Else
     If CurIndex <> NewIndex Then
     Begin
          Item := FList^[CurIndex];
          If CurIndex < NewIndex
          Then System.Move(FList^[CurIndex+1], FList^[CurIndex],
                           (NewIndex-CurIndex)*SizeOf(Pointer))
          Else System.Move(FList^[NewIndex], FList^[NewIndex+1],
                           (CurIndex-NewIndex)*SizeOf(Pointer));
          FList^[NewIndex] := Item;
     End;
End;


(* return the Index Of an Item *)
Function TList.IndexOf(Item:Pointer):LongInt;
Begin
     For Result := 0 To FCount-1 Do
        If FList^[Result] = Item Then Exit;
     Result := -1;
End;


(* return the First Item In the List *)
Function TList.First:Pointer;
Begin
     Result := Get(0);
End;


(* return the Last Item In the List *)
Function TList.Last:Pointer;
Begin
     Result := Get(FCount-1);
End;


(* Expand the List If Capacity Is reached *)
Function TList.Expand:TList;
Begin
     If FCount = FCapacity Then Grow;
     Result := Self;
End;


(* Remove All Nil elements In the List *)
Procedure TList.Pack;
Var  I:LongInt;
Begin
     For I := FCount-1 DownTo 0 Do
        If FList^[I] = Nil Then Delete(I);
End;


Procedure TList.Sort(Compare: TListSortCompare);

  Procedure Swap(I, K: LongInt);
  Var
    Item: Pointer;
  Begin
    Item := FList^[I];
    FList^[I] := FList^[K];
    FList^[K] := Item;
  End;

  Procedure Reheap(I, K: LongInt);
  Var
    J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
    Begin
      If Compare(FList^[J Shl 1 - 1], FList^[J Shl 1 + 1 - 1]) > 0 Then J := J Shl 1
      Else J := J Shl 1 + 1;
    End;
    If J Shl 1 = K Then J := K;

    While Compare(FList^[I - 1], FList^[J - 1]) > 0 Do J := J Shr 1;

    Swap(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
    Begin
      Swap(I - 1, J - 1);
      J := J Shr 1;
    End;
  End;

Var
  I, C: LongInt;
Begin
  C := Count;
  For I := C Shr 1 DownTo 1 Do Reheap(I, C);
  For I := C DownTo 2 Do
  Begin
    Swap(0, I - 1);
    Reheap(1, I - 1);
  End;
End;

Procedure TList.AddList(List:TList);
var
  Source: PPointerList;
  Dest: PPointerList;
Begin
  if FCount + List.FCount > FCapacity then
    Capacity := FCapacity + List.FCount;

  Source := List.FList;
  Dest := ( FList + FCount * sizeof( pointer ) );
  System.Move( Source^,
               Dest^,
               List.FCount * sizeof( pointer ) );
  inc( FCount, List.FCount );
End;

Procedure TList.Assign(List:TList);
Begin
  Clear;
  AddList(List);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TChainList Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TChainList.Error;
Begin
     Raise EListError.Create(LoadNLSStr(SListErrorText));
End;


Function TChainList.Index2PLE(Index:LongInt):PChainListItem;
Var  I:LongInt;
Begin
     If (Index < 0) Or (Index >= FCount) Then Result := Nil
     Else
     Begin
          Result := FList;
          For I := 0 To Index-1 Do Result := Result^.Next;
          If Result = Nil Then Exit;
     End;
End;


Function TChainList.Item2PLE(Item:Pointer):PChainListItem;
Begin
     Result := FList;
     While Result <> Nil Do
     Begin
          If Result^.Item = Item Then Exit;
          Result := Result^.Next;
     End;
End;


Function TChainList.PLE2Index(ple:PChainListItem):LongInt;
Var  ple1:PChainListItem;
Begin
     Result := -1;
     ple1 := FList;
     While ple1 <> Nil Do
     Begin
          Inc(Result);
          If ple1 = ple Then Exit;
          ple1 := ple1^.Next;
     End;
     Result := -1;
End;


Function TChainList.Item2Index(Item:Pointer):LongInt;
Var  ple:PChainListItem;
Begin
     Result := -1;
     ple := FList;
     While ple <> Nil Do
     Begin
          Inc(Result);
          If ple^.Item = Item Then Exit;
          ple := ple^.Next;
     End;
     Result := -1;
End;


Procedure TChainList.Connect(ple1,ple2:PChainListItem);
Begin
     If ple1 <> Nil Then ple1^.Next := ple2
     Else FList := ple2;
     If ple2 <> Nil Then ple2^.Prev := ple1
     Else FListEnd := ple1;
End;


Function TChainList.Get(Index:LongInt):Pointer;
Var  ple:PChainListItem;
Begin
     ple := Index2PLE(Index);
     If ple = Nil Then Error;
     Result := ple^.Item;
End;


Procedure TChainList.Put(Index:LongInt;Item:Pointer);
Var  ple:PChainListItem;
Begin
     ple := Index2PLE(Index);
     If ple = Nil Then Error;
     ple^.Item := Item;
End;



Destructor TChainList.Destroy;
Begin
     Clear;
     Inherited Destroy;
End;


Procedure TChainList.Clear;
Var  I:LongInt;
     ple,plenext:PChainListItem;
Begin
     ple := FList;
     For I := 0 To FCount-1 Do
     Begin
          FreeItem(ple^.Item);

          plenext := ple^.Next;
          Dispose(ple);
          ple := plenext;
     End;
     FCount := 0;
     FList := Nil;
     FListEnd := Nil;
End;


Function TChainList.Add(Item:Pointer):LongInt;
Var  plenew:PChainListItem;
Begin
     New(plenew);
     plenew^.Item := Item;
     plenew^.Next := Nil;
     Connect(FListEnd,plenew);
     FListEnd := plenew;
     Result := FCount;
     Inc(FCount);
End;


Function TChainList.Remove(Item:Pointer):LongInt;
Var  I:LongInt;
     ple:PChainListItem;
Begin
     ple := FList;
     For I := 0 To FCount-1 Do
     Begin
          If ple^.Item = Item Then
          Begin
               FreeItem(ple^.Item);

               Result := I;
               Connect(ple^.Prev,ple^.Next);
               Dispose(ple);
               Dec(FCount);
               Exit;
          End;
          ple := ple^.Next;
     End;
     Result := -1;
End;


Procedure TChainList.Delete(Index:LongInt);
Var  ple:PChainListItem;
Begin
     ple := Index2PLE(Index);
     If ple = Nil Then Error;

     FreeItem(ple^.Item);

     Connect(ple^.Prev,ple^.Next);
     Dispose(ple);
     Dec(FCount);
End;


Procedure TChainList.FreeItem(Item:Pointer);
Begin
     If FOnFreeItem <> Nil Then FOnFreeItem(Self,Item);
End;


Function TChainList.First:Pointer;
Var  ple:PChainListItem;
Begin
     ple := FList;
     If ple = Nil Then Error;
     Result := ple^.Item;
End;


Function TChainList.Last:Pointer;
Var  ple:PChainListItem;
Begin
     ple := FListEnd;
     If ple = Nil Then Error;
     Result := ple^.Item;
End;


Function TChainList.IndexOf(Item:Pointer):LongInt;
Begin
     Result := Item2Index(Item);
End;


Procedure TChainList.Insert(Index:LongInt;Item:Pointer);
Var  ple,plenew:PChainListItem;
Begin
     If Index < 0 Then Error;
     If Index > FCount Then Error;

     ple := Index2PLE(Index);
     If ple <> Nil Then
     Begin
          New(plenew);
          plenew^.Item := Item;
          Connect(ple^.Prev,plenew);
          Connect(plenew,ple);
          Inc(FCount);
     End
     Else Add(Item);
End;


Procedure TChainList.Move(CurIndex,NewIndex:LongInt);
Var  TempItem:Pointer;
Begin
     If CurIndex < 0 Then Error;
     If CurIndex >= FCount Then Error;
     If NewIndex < 0 Then Error;
     If NewIndex >= FCount Then Error;
     If CurIndex = NewIndex Then Exit;

     TempItem := Get(CurIndex);
     Delete(CurIndex);
     Insert(NewIndex,TempItem);
End;


Procedure TChainList.Exchange(Index1,Index2:LongInt);
Var  ple1,ple2:PChainListItem;
     TempItem:Pointer;
Begin
     ple1 := Index2PLE(Index1);
     ple2 := Index2PLE(Index2);
     If (ple1 = Nil) Or (ple2 = Nil) Then Error;

     TempItem := ple1^.Item;
     ple1^.Item := ple2^.Item;
     ple2^.Item := TempItem;
End;


Procedure TChainList.Pack;
Var  I:LongInt;
     ple,plenext:PChainListItem;
Begin
     ple := FList;
     For I := 0 To FCount-1 Do
     Begin
          plenext := ple^.Next;
          If ple^.Item = Nil Then
          Begin
               Connect(ple^.Prev,ple^.Next);
               Dispose(ple);
               Dec(FCount);
          End;
          ple := plenext;
     End;
End;


{ --- Utility FUNCTIONs For TStrItem --- }

Function NewStrItem(Const AString: String; AObject: TObject): PStrItem;
Begin
  GetMem(Result, SizeOf(TObject) + Length(AString) + 1);
  Result^.FObject := AObject;
  Result^.FString := AString;
End;

Procedure DisposeStrItem(P: PStrItem);
Begin
  FreeMem(P, SizeOf(TObject) + Length(P^.FString) + 1);
End;


{ --- TStrings --- }

Procedure TStrings.Append(Const S: String);
Begin
  Add(S);
End;

Procedure TStrings.Put(Index: LongInt; Const S: String);
Var  Temp:TObject;
Begin
  Temp := GetObject(Index);
  Delete(Index);
  InsertObject(Index, S, Temp);
End;

{$HINTS OFF}
Function TStrings.GetObject(Index: LongInt): TObject;
Begin
  Result := Nil;
End;

Procedure TStrings.PutObject(Index: LongInt; AObject: TObject);
Begin
End;
{$HINTS ON}

Function TStrings.Add(Const S: String): LongInt;
Begin
  Result := Count;
  Insert(Result, S);
End;

Function TStrings.AddObject(Const S: String; AObject: TObject): LongInt;
Begin
  Result := Add(S);
  PutObject(Result, AObject);
End;

Procedure TStrings.AddStrings(AStrings: TStrings);
Var
  I: LongInt;
Begin
  BeginUpdate;
  Try
    For I := 0 To AStrings.Count - 1 Do
       AddObject(AStrings.Get(I), AStrings.GetObject(I));
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.Assign(AStrings: TStrings);
Begin
  If AStrings=Self Then Exit;
  BeginUpdate;
  Try
    Clear;
    If AStrings<>Nil Then AddStrings(AStrings);
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.BeginUpdate;
Begin
  If FUpdateSemaphore = 0 Then SetUpdateState(True);
  Inc(FUpdateSemaphore);
End;

Procedure TStrings.EndUpdate;
Begin
  Dec(FUpdateSemaphore);
  If FUpdateSemaphore = 0 Then SetUpdateState(False);
End;

Function TStrings.Equals(AStrings: TStrings): Boolean;
Var
  N: LongInt;
Begin
  Result := False;
  If Count <> AStrings.Count Then Exit;
  For N := 0 To Count - 1 Do If Get(N) <> AStrings.Get(N) Then Exit;
  Result := True;
End;

Procedure TStrings.Exchange(Index1, Index2: LongInt);
Var
  S: String;
  O: TObject;
Begin
  S := Get(Index1);
  O := GetObject(Index1);
  Put(Index1, Get(Index2));
  PutObject(Index1, GetObject(Index2));
  Put(Index2, S);
  PutObject(Index2, O);
End;

Function TStrings.GetName(Index: LongInt): String;
Var
  P: Integer;
Begin
  Result := Get(Index);
  P := Pos('=', Result);
  System.Delete(Result, P, Length(Result) - P + 1);
End;

Procedure SingleLineToBuffer(Const S: String; Var P: PChar);
Begin
  Move(S[1], P[0], Length(S));
  Inc(P, Length(S));
  P[0] := #13;
  P[1] := #10;
  Inc(P, 2);
End;

Function TStrings.GetText: PChar;
Var
  N, BufSize: LongInt;
  BufPtr: PChar;
Begin
  BufSize := 1;
  For N := 0 To Count - 1 Do Inc(BufSize, Length(Get(N)) + 2);
  Result := StrAlloc(BufSize);

  BufPtr := Result;
  For N := 0 To Count - 1 Do SingleLineToBuffer(Get(N), BufPtr);
  BufPtr[0] := #0;
End;

Function TStrings.GetTextStr: AnsiString;
Var
  N, BufSize: LongInt;
  BufPtr: PChar;
Begin
  BufSize := 0;
  For N := 0 To Count - 1 Do Inc(BufSize, Length(Get(N)) + 2);
  SetLength(Result, BufSize);
  BufPtr := PChar(Result);
  For N := 0 To Count - 1 Do SingleLineToBuffer(Get(N), BufPtr);
End;

Function TStrings.GetValue(Const Name: String): String;
Begin
  FindValue(Name, Result);
End;

Function TStrings.FindValue(Const Name: String; Var Value: String): LongInt;
Var
  P: Integer;
Begin
  For Result := 0 To Count - 1 Do
  Begin
    Value := Get(Result);
    P := Pos('=', Value);
    If P <> 0 Then
    Begin
      If CompareText(Copy(Value, 1, P - 1), Name) = 0 Then
      Begin
        System.Delete(Value, 1, P);
        Exit;
      End;
    End;
  End;
  Result := -1;
  Value := '';
End;

Function TStrings.IndexOfName(Const Name: String): LongInt;
Var
  P: Integer;
  S: String;
Begin
  For Result := 0 To Count - 1 Do
  Begin
    S := Get(Result);
    P := Pos('=', S);
    If CompareText(Copy(S, 1, P - 1), Name) = 0 Then Exit;
  End;
  Result := -1;
End;

Function TStrings.IndexOf(Const S: String): LongInt;
Begin
  For Result := 0 To Count-1 Do If CompareText(Get(Result), S) = 0 Then Exit;
  Result := -1;
End;

Function TStrings.IndexOfObject(AObject: TObject): LongInt;
Begin
  For Result := 0 To Count-1 Do If GetObject(Result) = AObject Then Exit;
  Result := -1;
End;

Procedure TStrings.InsertObject(Index: LongInt; Const S: String; AObject: TObject);
Begin
  Insert(Index, S);
  PutObject(Index, AObject);
End;

Procedure TStrings.LoadFromFile(Const FileName: String);
Var
  Source: TFileStream;
Begin
  Try
    Source := TFileStream.Create(FileName, Stream_OpenRead);
  Except
    Source.Destroy;
    Raise;
  End;

  Try
    LoadFromStream(Source);
  Finally
    Source.Destroy;
  End;
End;

Procedure TStrings.LoadFromStream(Stream: TStream);
Begin
  BeginUpdate;
  Clear;
  Try
    While Not Stream.EndOfData Do Add(Stream.ReadLn);
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.Move(CurIndex, NewIndex: LongInt);
Var
  O: TObject;
  S: String;
Begin
  If CurIndex = NewIndex Then Exit;
  S := Get(CurIndex);
  O := GetObject(CurIndex);
  FPreventFree := True;
  Delete(CurIndex);
  InsertObject(NewIndex, S, O);
  FPreventFree := False;
End;

Procedure TStrings.SaveToFile(Const FileName: String);
Var
  Dest: TFileStream;
Begin
  Try
    Dest := TFileStream.Create(FileName, Stream_Create);
  Except
    Dest.Destroy;
    Raise;
  End;

  Try
    SaveToStream(Dest);
  Finally
    Dest.Destroy;
  End;
End;

Procedure TStrings.SaveToStream(Stream: TStream);
Var
  N: LongInt;
Begin
  For N := 0 To Count - 1 Do Stream.WriteLn(Get(N));
End;

Procedure TStrings.SetText(Text: PChar);

  Function SingleLineFromBuffer(Var P: PChar): String;
  Var
    I: Integer;
    Q: PChar;
  Begin
    I := 0;
    Q := P;
    While Not (Q[0] In [#13, #10, #26, #0]) And (I < 255) Do
    Begin
      Inc(Q);
      Inc(I);
    End;
    StrMove(@Result[1], P, I);
    SetLength(Result, I);
    P := Q;
    If P[0] = #13 Then Inc(P);
    If P[0] = #10 Then Inc(P);
  End;

Begin
  BeginUpdate;
  Try
    Clear;
    If Text<>Nil Then While Not (Text[0] In [#0, #26]) Do
    Begin
      Add(SingleLineFromBuffer(Text));
    End;
  Finally
    EndUpdate;
  End;
End;

Procedure TStrings.SetTextStr(Const Value: AnsiString);
Begin
    SetText(PChar(Value));
End;

{$HINTS OFF}
Procedure TStrings.SetUpdateState(Updating: Boolean);
Begin
End;
{$HINTS ON}

Procedure TStrings.SetValue(Const Name, Value: String);
Var
  I: LongInt;
  S: String;
Begin
  I := FindValue(Name, S);
  If I < 0 Then
  Begin
    If Length(Value) <> 0 Then Add(Name + '=' + Value)
  End
  Else
  Begin
    If Length(Value) <> 0 Then Put(I, Name + '=' + Value)
    Else Delete(I);
  End;
End;

{ --- TStringList --- }

Constructor TStringList.Create;
Begin
  Inherited Create;
  FList := TList.Create;
  FCaseSensitive := False;
End;

Destructor TStringList.Destroy;
Begin
  { Die folgenden zwei Zeilen spter wieder ndern }
  Pointer(FOnChanging) := Nil;
  Pointer(FOnChange) := Nil;
  Clear;
  FList.Destroy;
  FList := Nil;
  Inherited Destroy;
End;

Function TStringList.Add(Const S: String): LongInt;
Begin
  If FSorted Then
  Begin
    If Find(S, Result) Then
    Begin
      Case FDuplicates Of
        dupIgnore: Exit;
        dupError: Raise EStringListError.Create(LoadNLSStr(SStringListDupeErrorText));
      End;
    End;
  End
  Else Result := Count;
  Changing;
  FList.Insert(Result, NewStrItem(S, Nil));
  changed;
End;

Procedure TStringList.changed;
Begin
  If (FUpdateSemaphore = 0) And (FOnChange <> Nil) Then FOnChange(Self);
End;

Procedure TStringList.Changing;
Begin
  If (FUpdateSemaphore = 0) And (FOnChanging <> Nil) Then FOnChanging(Self);
End;

Procedure TStringList.Clear;
Var
  N: LongInt;
Begin
  If Count > 0 Then
  Begin
    Changing;
    FLockChange:=True;
    For N := Count - 1 DownTo 0 Do Delete(N);
    FLockChange:=False;
    changed;
  End;
End;

Procedure TStringList.Delete(Index: LongInt);
Begin
  If FLockChange Then
  Begin
       FreeItem(GetObject(Index));
       DisposeStrItem(FList.Get(Index));
       FList.Delete(Index);
  End
  Else
  Begin
       Changing;
       If Not FPreventFree Then FreeItem(GetObject(Index));
       DisposeStrItem(FList.Get(Index));
       FList.Delete(Index);
       changed;
  End;
End;

Procedure TStringList.FreeItem(AObject:TObject);
Begin
     If FOnFreeItem <> Nil Then FOnFreeItem(Self,AObject);
End;

Procedure TStringList.Exchange(Index1, Index2: LongInt);
Begin
  Changing;
  FList.Exchange(Index1, Index2);
  changed;
End;

Function TStringList.Find(Const S: String; Var Index: LongInt): Boolean;
Var
  Low, High: LongInt;
  CMP: Integer;
  DoCompare: Function(Const S, T: String): Integer;

Begin
  If CaseSensitive Then DoCompare := CompareStr // No Ansi equiv
  Else DoCompare := AnsiCompareText;

  If sorted Then
  Begin
    { binary Search }
    Low := 0;
    High := GetCount - 1;
    Index := 0;
    CMP := -1;
    While (CMP <> 0) And (Low <= High) Do
    Begin
      Index := (Low + High) Div 2;
      CMP := DoCompare(S, Get(Index));
      If CMP < 0 Then High := Index -1
      Else If CMP > 0 Then Low := Index + 1;
    End;
    If Low = Index + 1 Then Inc(Index);
    Result := (CMP = 0);
  End
  Else
  Begin
    { Linear Search }
    Index := 0;
    While (Index < Count) And (DoCompare(Get(Index), S) <> 0) Do Inc(Index);
    Result := (Index < Count);
  End;
End;

Function TStringList.Get(Index: LongInt): String;
Begin
  Result := PStrItem(FList.Get(Index))^.FString;
End;

Function TStringList.GetCount: LongInt;
Begin
  Result := FList.Count;
End;

Function TStringList.GetObject(Index: LongInt): TObject;
Begin
  Result := PStrItem(FList.Get(Index))^.FObject;
End;

Function TStringList.IndexOf(Const S: String): LongInt;
Begin
  If Not Find(S, Result) Then Result := -1;
End;

Procedure TStringList.Insert(Index: LongInt; Const S: String);
Begin
  Changing;
  If FSorted Then Raise EListError.Create(LoadNLSStr(SStringListInsertErrorText))
  Else FList.Insert(Index, NewStrItem(S, Nil));
  changed;
End;

Procedure TStringList.Put(Index: LongInt; Const S: String);
Var  TempObj:TObject;
     pstr:PStrItem;
Begin
  Changing;
  pstr := FList.Get(Index);
  TempObj := pstr^.FObject;
  DisposeStrItem(pstr);
  FList.Put(Index, NewStrItem(S, TempObj));
  changed;
End;

Procedure TStringList.PutObject(Index: LongInt; AObject: TObject);
Var
  P: PStrItem;
Begin
  P := FList.Get(Index);
  P^.FObject := AObject;
End;

Procedure TStringList.BottomUpHeapSort;
Var
  DoCompare: Function (Const S, T: String): Integer;

  Procedure Reheap(I, K: LongInt);
  Var
    J: LongInt;
  Begin
    J := I;
    While J Shl 1 < K Do
    Begin
      If DoCompare(Get(J Shl 1 - 1), Get(J Shl 1 + 1 - 1)) > 0 Then J := J Shl 1
      Else J := J Shl 1 + 1;
    End;
    If J Shl 1 = K Then J := K;

    While DoCompare(Get(I - 1), Get(J - 1)) > 0 Do J := J Shr 1;

    FList.Exchange(I - 1, J - 1);
    J := J Shr 1;

    While J >= I Do
    Begin
      FList.Exchange(I - 1, J - 1);
      J := J Shr 1;
    End;
  End;

Var
  I, C: LongInt;
Begin
  If CaseSensitive Then DoCompare := CompareStr
  Else DoCompare := CompareText;

  C := Count;
  For I := C Shr 1 DownTo 1 Do Reheap(I, C);
  For I := C DownTo 2 Do
  Begin
    FList.Exchange(0, I - 1);
    Reheap(1, I - 1);
  End;
End;

Procedure TStringList.SetCaseSensitive(Value: Boolean);
Var
  old: Boolean;
Begin
  Changing;
  old := FCaseSensitive;
  FCaseSensitive := Value;
  If FSorted And (FCaseSensitive <> old) Then Sort;
  changed;
End;

Procedure TStringList.SetSorted(Value: Boolean);
Begin
  Changing;
  If (Not FSorted) And Value Then Sort;
  FSorted := Value;
  changed;
End;

Procedure TStringList.SetUpdateState(Updating: Boolean);
Begin
  If Updating Then Changing
  Else changed;
End;

Procedure TStringList.Sort;
Begin
  If Count > 1 Then
  Begin
    Changing;
    BottomUpHeapSort;
    changed;
  End;
End;

Function TStringList.GetValuePtr(Index:Longint): PString;
var
  Item: PStrItem;
Begin
  Item := PStrItem(FList.Get(Index));
  Result := Addr( Item^.FString );
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: Some useful FUNCTIONs                                       บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function MessageBox2(Const Msg:String;Typ:TMsgDlgType;Buttons:TMsgDlgButtons):TMsgDlgReturn;
Var C,Title:cstring;
    iFlags:LongWord;
    mresult:LongWord;
Begin
     C:=Msg;

     {$IFDEF OS2}
     iFlags:=MB_MOVEABLE OR MB_APPLMODAL;

     If Typ=mtError Then
     Begin
          Title:=LoadNLSStr(SError);
          iFlags:=iFlags Or MB_ERROR;
     End
     Else If Typ=mtCritical Then
     Begin
          Title:=LoadNLSStr(SCriticalError);
          iFlags:=iFlags Or MB_CRITICAL;
     End
     Else If Typ=mtInformation Then
     Begin
          Title:=LoadNLSStr(sInformation);
          iFlags:=iFlags Or MB_INFORMATION;
     End
     Else If Typ=mtWarning Then
     Begin
          Title:=LoadNLSStr(SWarning);
          iFlags:=iFlags Or MB_WARNING;
     End
     Else If Typ=mtConfirmation Then
     Begin
          Title:=LoadNLSStr(SMessage);
          iFlags:=iFlags Or MB_ICONQUESTION;
     End
     Else
     Begin
          Title:=ParamStr(0);
          iFlags:=iFlags Or MB_NOICON;
     End;

     If Buttons*[mbOk]<>[] Then
     Begin
          If Buttons*[mbCancel]<>[] Then iFlags:=iFlags Or MB_OKCANCEL
          Else iFlags:=iFlags Or MB_OK;
     End
     Else If Buttons*[mbCancel]<>[] Then
     Begin
          If Buttons*mbYesNo<>[] Then iFlags:=iFlags Or MB_YESNOCANCEL
          Else If Buttons*[mbRetry]<>[] Then iFlags:=iFlags Or MB_RETRYCANCEL
          Else iFlags:=iFlags Or MB_CANCEL;
     End
     Else If Buttons*[mbYes]<>[] Then
     Begin
          If Buttons*[mbNo]<>[] Then iFlags:=iFlags Or MB_YESNO
          Else iFlags:=iFlags Or MB_OK;
     End;

     If Buttons*mbAbortRetryIgnore<>[] Then iFlags:=iFlags Or MB_ABORTRETRYIGNORE;

     InitPM;
     mresult:=WinMessageBox(HWND_DESKTOP,HWND_DESKTOP,C,Title,0,iFlags);

     Case mresult Of
         MBID_OK:Result:=mrOk;
         MBID_CANCEL:Result:=mrCancel;
         MBID_YES:Result:=mrYes;
         MBID_NO:Result:=mrNo;
         MBID_IGNORE:Result:=mrIgnore;
         MBID_ABORT:Result:=mrAbort;
         MBID_RETRY:Result:=mrRetry;
         Else Result:=mrCancel;
     End; {Case}
     {$ENDIF}
     {$IFDEF Win95}
     iFlags:=MB_TASKMODAL;

     If Typ=mtError Then
     Begin
          Title:=LoadNLSStr(SError);
          iFlags:=iFlags Or MB_ICONHAND;
     End
     Else If Typ=mtCritical Then
     Begin
          Title:=LoadNLSStr(SCriticalError);
          iFlags:=iFlags Or MB_ICONHAND;
     End
     Else If Typ=mtInformation Then
     Begin
          Title:=LoadNLSStr(sInformation);
          iFlags:=iFlags Or MB_ICONEXCLAMATION;
     End
     Else If Typ=mtWarning Then
     Begin
          Title:=LoadNLSStr(SWarning);
          iFlags:=iFlags Or MB_ICONEXCLAMATION;
     End
     Else If Typ=mtConfirmation Then
     Begin
          Title:=LoadNLSStr(SMessage);
          iFlags:=iFlags Or MB_ICONQUESTION;
     End
     Else
     Begin
          Title:=ParamStr(0);
     End;

     If Buttons*[mbOk]<>[] Then
     Begin
          If Buttons*[mbCancel]<>[] Then iFlags:=iFlags Or MB_OKCANCEL
          Else iFlags:=iFlags Or MB_OK;
     End
     Else If Buttons*[mbCancel]<>[] Then
     Begin
          If Buttons*mbYesNo<>[] Then iFlags:=iFlags Or MB_YESNOCANCEL
          Else If Buttons*[mbRetry]<>[] Then iFlags:=iFlags Or MB_RETRYCANCEL
          Else iFlags:=iFlags Or MB_OK; //MB_CANCEL only Not present
     End
     Else If Buttons*[mbYes]<>[] Then
     Begin
          If Buttons*[mbNo]<>[] Then iFlags:=iFlags Or MB_YESNO
          Else iFlags:=iFlags Or MB_OK;
     End;

     If Buttons*mbAbortRetryIgnore<>[] Then iFlags:=iFlags Or MB_ABORTRETRYIGNORE;

     mresult:=WinUser.MessageBox(0,C,Title,iFlags);

     Case mresult Of
         IDOK:Result:=mrOk;
         IDCANCEL:Result:=mrCancel;
         IDYES:Result:=mrYes;
         IDNO:Result:=mrNo;
         IDIGNORE:Result:=mrIgnore;
         IDABORT:Result:=mrAbort;
         IDRETRY:Result:=mrRetry;
         Else Result:=mrCancel;
     End; {Case}
     {$ENDIF}
End;


Function ErrorBox2(Const Msg:String):TMsgDlgReturn;
Begin
     Beep(1000,200);
     Result:=MessageBox2(Msg,mtError,[mbOk]);
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: SCU File format types And records                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    PResourceEntry=^TResourceEntry;
    TResourceEntry=Record
                         ResName:TResourceName;
                         DataOffset:LongInt;
                         DataLen:LongInt;
                   End;

Function CompareResMem(Var Buf1,Buf2;Size:LongWord):Boolean;
Var R:Boolean;
Begin
     Asm
        CLD
        MOV ESI,Buf1
        MOV EDI,Buf2
        MOV ECX,Size
        CLD
        REP
        CMPSB
        SETE AL
        MOV R,AL
     End;
     Result:=R;
End;

{$HINTS OFF}
Function TResourceStream.NewResourceEntry(Const ResName:TResourceName;
                                          Var Data;DataLen:LongInt):Boolean;
Var dummy:PResourceEntry;
    SavePos,T,HeadPos:LongInt;
    P:Pointer;
Label L;
Begin
     Result:=False;
     If DataLen=0 Then Exit;

     SavePos:=Position;
     HeadPos:=8;          {Initial Resource Header}
     If FResourceList<>Nil Then
     Begin
          For T:=0 To FResourceList.Count-1 Do
          Begin
               dummy:=FResourceList.Items[T];
               If dummy^.ResName=ResName Then
                 If dummy^.DataLen=DataLen Then
               Begin
                    Position:=dummy^.DataOffset;
                    P:=Pointer(FBuffer);
                    Inc(P,Position);
                    If CompareResMem(P^,Data,DataLen) Then
                    Begin
                         Position:=SavePos;
                         SavePos:=dummy^.DataOffset;
                         Goto L;
                    End;
               End;
               Inc(HeadPos,SizeOf(TResourceEntry));  {Length Of Info}
          End;
     End;
     Position:=SavePos;

     If Write(Data,DataLen)=0 Then Exit;

     //reserve A Header entry
     HeadPos:=FHeaderPos;
     Inc(FHeaderPos,SizeOf(TResourceEntry));  {Length Of Info}

     New(dummy);

     dummy^.ResName:=ResName;
     dummy^.DataOffset:=SavePos;
     dummy^.DataLen:=DataLen;

     If FResourceList=Nil Then FResourceList.Create;
     FResourceList.Add(dummy);
L:
     //Write Position Of Resource
     If SCUStream.Write(HeadPos,4)=0 Then Exit;

     Result:=True;
End;
{$HINTS ON}

Function TResourceStream.WriteResourcesToStream(Stream:TMemoryStream):Boolean;
Var T,t1:LongInt;
    PatchOffset,StartPos:LongInt;
    dummy:PResourceEntry;
    P:Pointer;
Begin
     Result:=False;
     If FResourceList=Nil Then
     Begin
          T:=0;  //no resources
          If Stream.Write(T,4)=0 Then Exit;
          Result:=True;
          Exit;
     End;

     StartPos:=Stream.Position;

     T:=FResourceList.Count;          //Count Of Resource entries
     If Stream.Write(T,4)=0 Then Exit;

     PatchOffset:=Stream.Position;
     T:=0;
     If Stream.Write(T,4)=0 Then Exit;  // Resource Data Offset patched later

     For T:=0 To FResourceList.Count-1 Do
     Begin
          dummy:=FResourceList.Items[T];
          If Stream.Write(dummy^,SizeOf(TResourceEntry))=0 Then Exit;
     End;

     //patch Offset To Resource Data
     T:=Stream.Position;
     Stream.Position:=PatchOffset;
     t1:=T-StartPos;
     If Stream.Write(t1,4)=0 Then Exit;
     Stream.Position:=T;

     //Write Resource Data

     P:=Memory;
     If Stream.Write(P^,Size)=0 Then Exit;

     Result:=True;
End;

Destructor TResourceStream.Destroy;
Var T:LongInt;
    dummy:PResourceEntry;
Begin
     If FResourceList<>Nil Then
     Begin
          For T:=0 To FResourceList.Count-1 Do
          Begin
               dummy:=FResourceList.Items[T];
               Dispose(dummy);
          End;
          FResourceList.Destroy;
          FResourceList := Nil;
     End;

     Inherited Destroy;
End;

Type
    TPropertyTyp=(TPropString,TPropSet,TPropLongInt,TPropEnum,
                  TPropClass);

    PSCUPropInit=^TSCUPropInit;
    TSCUPropInit=Record
                   PropertyName:String;
                   PropertySize:LongInt;
                   PropertyTyp:TPropertyTyp;
                   PropertyValue:Pointer;
    End;

    PSCUDesc=^TSCUDesc;
    TSCUDesc=Record
                   NextEntryOffset:LongInt;
                   ClassName:String;      //subclassed Class Name
                   BaseClassName:String;  //base Class Name For designer
                   PropertyCount:LongInt; //Count Of properties To initialize
                   properties:PSCUPropInit;
    End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPersistent Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPersistent.AssignError(Source:TPersistent);
Var Msg:String;
Begin
     If Source=Nil Then Msg:='Nil'
     Else Msg:=Source.ClassName;
     Raise EConvertError.Create('Convert '+ClassName+' to '+Msg+'.');
End;

Procedure TPersistent.AssignTo(Dest:TPersistent);
Begin
     Dest.AssignError(Self);
End;

Procedure TPersistent.Assign(Source:TPersistent);
Begin
     If Source<>Nil Then Source.AssignTo(Self)
     Else AssignError(nil);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TComponent Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const //OldStyleFormat:Boolean=False;
      LastSCUForm:TComponent=Nil;

Function GetClassNameFromSCU(NameTable:Pointer;Namep:LongWord):String;
Var ps:^String;
Begin
     ps:=NameTable;
     Inc(ps,Namep);
     Result:=ps^;
End;

Function GetParentSCUFormDesign(Component:TComponent):TComponent;
Var AOwner:TComponent;
Begin
     Result:=Nil;
     AOwner:=Component;

     //Search For First parent that has Is A Form And TypeName match
     While AOwner <> Nil Do
     Begin
          //If AOwner.IDESCU_Data<>Nil Then
          If csForm In AOwner.ComponentState Then
          Begin
               Result:=AOwner;
               Exit;
          End;

          AOwner:=AOwner.FOwner;
     End;
     Result := Nil;   //Error
End;

Function GetParentSCUFormRuntime(Component:TComponent;Name:String):TComponent;
Var AOwner:TComponent;
    S:String;
Begin
     Result:=Nil;
     AOwner:=Component;
     UpcaseStr(Name);

     //Search For First parent that has TypeName match
     While AOwner <> Nil Do
     Begin
          S:=AOwner.ClassName;
          UpcaseStr(S);
          If S=Name Then
          Begin
               Result:=AOwner;
               Exit;
          End;
          AOwner:=AOwner.FOwner;
     End;
     Result := Nil;   //Error
End;

Procedure InsertSCUMethod(AParent,Objekt:TComponent;
                          ProcName,ProcParams,PropertyName:String);
Var Methods:PIDE_Methods;
    S,s2:String[64];
    s1,s3:String;
    Own:PIDE_OwnerList;
Label L;
Begin
     S:=ProcName;
     UpcaseStr(S);
     s1:=ProcParams;
     UpcaseStr(s1);
     s2:=PropertyName;
     UpcaseStr(s2);

     //look If method Is still here
     Methods:=AParent.FMethods;
     While Methods<>Nil Do
     Begin
          s3:=Methods^.Name^;
          UpcaseStr(s3);
          If s3=S Then  //ProcNames match
          Begin
               s3:=Methods^.Params^;
               UpcaseStr(s3);
               If s3=s1 Then  //Parameters match --> only Add To List
               Begin
                    Goto L;
               End;
          End;

          Methods:=Methods^.Next;
     End;

     //Insert New Item
     New(Methods);
     Methods^.Next:=AParent.FMethods;
     AParent.FMethods:=Methods;

     AssignStr(Methods^.Name,ProcName);
     AssignStr(Methods^.Params,ProcParams);
     Methods^.Owners.Create;
L:
     New(Own);
     AssignStr(Own^.PropertyName,PropertyName);
     Own^.Objekt:=Objekt;
     Methods^.Owners.Add(Own);
End;

Function GetSCUProcParamsFromName(Objekt:TComponent;PropertyName:String):String;
Var p1:^LongWord;
    B:Byte;
    S,s1:String;
    ps:^String;
    pParent:Pointer;
    Scope:Byte;
    NameIndex:LongInt;
    NameTable:^String;
Label L,ex,again;
Begin
     //Search PropertyName
     UpcaseStr(PropertyName);
     p1:=Objekt.ClassInfo;
again:
     //overread Object Size
     Inc(p1,4);
     pParent:=Pointer(p1^);
     Inc(p1,8);               //onto First Property Name
     p1:=Pointer(p1^);
     Inc(p1,4);               //overread End Ptr
     NameTable:=Pointer(p1^); //Name Table Of Class
     Inc(p1,4);               //overread Name Table poinzer

     NameIndex:=p1^ And 255;
     Inc(p1);
     While NameIndex<>0 Do
     Begin
          s1[0]:=Chr(NameIndex);
          Move(p1^,s1[1],NameIndex);
          Inc(p1,NameIndex);

          Scope:=p1^ And 255;
          Inc(p1);
          If Scope And 16=16 Then  //stored ??
          Begin
               UpcaseStr(s1);
               If s1=PropertyName Then  //found
               Begin
                   p1:=Pointer(p1^);   //Type information

                   //overread Property access Info
                   If p1^ And 255<>0 Then Inc(p1,5)
                   Else Inc(p1);
                   If p1^ And 255<>0 Then Inc(p1,5)
                   Else Inc(p1);

                   //overread Property Type len
                   Inc(p1,4);

                   //Get Property Type
                   B:=p1^ And 255;
                   If Not (B In [PropType_ProcVar,PropType_FuncVar]) Then Goto ex;  //Error
                   Inc(p1);
                   Goto L;
               End;
          End;

          Inc(p1,4);    //overread Type information Pointer
          NameIndex:=p1^ And 255;
          Inc(p1);
     End;

     If pParent<>Nil Then
     Begin
          p1:=pParent;
          Inc(p1,4);
          p1:=Pointer(p1^);  //ClassInfo
          Goto again;
     End;
ex:
     Result:='?';
     Exit;  //Not found;
L:
     NameIndex:=p1^;
     Inc(p1,4);
     S:='';
     While NameIndex<>0 Do
     Begin
          If S<>'' Then S:=S+';';
          ps:=NameTable+NameIndex;
          s1:=ps^;

          B:=p1^ And 255;
          Inc(p1);
          Case B Of
            1:s1:='VAR '+s1;
            2:;
            3:s1:='CONST '+s1;
          End;

          S:=S+s1;
          NameIndex:=p1^;  //TypeName
          Inc(p1,4);
          If NameIndex<>0 Then
          Begin
               ps:=NameTable+NameIndex;
               s1:=ps^;
               S:=S+':'+s1;
          End;

          NameIndex:=p1^;
          Inc(p1,4);
     End; //While

     If S<>'' Then Result:='('+S+');'
     Else Result:=S;
End;


Type PPropertyLink=^TPropertyLink;
     TPropertyLink=Record
                         SelfPtr:TComponent;
                         Owner:TComponent;
                         WriteTyp:Byte;
                         WriteOffset:LongInt;
                         //WriteName:String[64];
                         LinkName:String[64];
                         Next:PPropertyLink;
     End;

Const PropertyLinks:PPropertyLink=Nil;


Function GetPropertyTypeInfo2(Instance:TComponent;PropertyName:String;Var Info:TPropertyTypeInfo):Boolean;
Var L,C:^LongWord;
    ps:^String;
    S:String;
Label weiter;
Begin
     Result:=False;
     UpcaseStr(PropertyName);

     L:=Pointer(Instance);
     L:=Pointer(L^);  //VMT address
     While L<>Nil Do
     Begin
          Inc(L,4);
          L:=Pointer(L^);  //Class Info
          C:=L;
          Inc(L,12);
          L:=Pointer(L^);  //Property Info
          Inc(L,4);
          Info.NameTable:=Pointer(L^);
          Inc(L,4);        //Start Of properties
          ps:=Pointer(L);
          While ps^[0]<>#0 Do
          Begin
               If ps^[0]=PropertyName[0] Then  //found !!
               Begin
                    S:=ps^;
                    UpcaseStr(S);
                    If S=PropertyName Then
                    Begin
                         Result:=True;
                         Inc(L,Ord(ps^[0])+1); //skip Name
                         Info.Scope:=L^ And 255;

                         Inc(L);
                         L:=Pointer(L^);     //Type And access Info

                         If ((Info.Scope And 24=0)Or(L=Nil)) Then
                         Begin
                              L:=Pointer(ps);
                              Goto weiter;   //Search also parent !
                         End;

                         Info.PropInfo:=Pointer(L);
                         Info.Read.Kind:=L^ And 255;
                         Inc(L);
                         If Info.Read.Kind<>0 Then
                         Begin
                              Info.Read.VarOffset:=L^;
                              Inc(L,4);
                         End;
                         Info.Write.Kind:=L^ And 255;
                         Inc(L);
                         If Info.Write.Kind<>0 Then
                         Begin
                              Info.Write.VarOffset:=L^;
                              Inc(L,4);
                         End;
                         Info.Size:=L^;
                         Inc(L,4);
                         Info.TypeInfo:=Pointer(L);
                         Info.Typ:=L^ And 255;

                         Exit;
                    End;
               End;
weiter:
               Inc(L,Ord(ps^[0])+6);    //skip This entry
               ps:=Pointer(L);
          End;

          Inc(C,4);
          L:=Pointer(C^);  //parent VMT Or Nil
     End;
End;


Function GetReference(Owner:TComponent):TComponent;
Begin
     Result:=Owner.FReference;
End;

Procedure SetReference(Owner,Ref:TComponent);
Begin
     Owner.FReference:=Ref;
End;


{$HINTS OFF}
Procedure TComponent.UpdateLinkList(Const PropertyName:String;LinkList:TList);
Begin
     //LinkList Is A List Of TComponent Instances that the Inspector
     //will display For the specified Property, you may only Remove Items !
End;
{$HINTS ON}


Type SCUTypes=(SCUNull,SCUByte,SCUWord,SCULongWord,SCUShortInt,SCUInteger,SCULongInt,SCUSingle,
               SCUDouble,SCUExtended,SCUByteBool,SCUWordBool,SCULongBool,SCUString,
               SCUCString,SCURecord,SCUSet4,SCUSet32,SCUEnum,SCUProcVar,SCUFuncVar,SCUClassVar,
               SCULink,SCUClass,SCUChar,SCUBinary);


{$HINTS OFF}
Function TComponent.ReadPropertiesSCU(COwner:TComponent;Namep,Resourcep:Pointer;Var ClassPointer:Pointer):Boolean;
Var P,p2:^LongInt;
    B:Byte;
    tt,TypeLen:LongInt;
    Typ:Byte;
    WriteTyp:Byte;
    WriteOffset,PropNameOffset:LongInt;
    Value,Temp:Pointer;
    TypeName,ProcName,PropertyName:String[64];
    ProcParams:String;
    ActComponentClass:TComponentClass;
    Proc:Pointer;
    AParent:TComponent;
    dummy:PPropertyLink;
    Error:Boolean;
    Info:TPropertyTypeInfo;
    InheritedComp:TComponent;
    SectionLen:LongWord;
    SCUTyp:SCUTypes;
Label L,err;
Begin
     Result:=False;
     P:=ClassPointer;
     SectionLen:=P^;
     Inc(P,4);  //overread Property section len
L:
     Error:=False;
     B:=P^ And 255;  //properties avail ?
     Inc(P);
     If ((B=1)Or(B=2)) Then
     Begin
          //there follows A Property entry - we are At Name Index
          PropNameOffset:=P^;
          Inc(P,4);

          SCUTyp:=SCUNull;
          System.Move(P^,SCUTyp,1);
          Inc(P);
          If ((SCUTyp=SCURecord)Or(SCUTyp=SCUBinary)) Then
          Begin
               System.Move(P^,TypeLen,4);
               Inc(P,4);
          End;

          PropertyName:=GetClassNameFromSCU(Namep,PropNameOffset);
          If Not GetPropertyTypeInfo2(Self,PropertyName,Info) Then
          Begin
               //evtll schon beim Rausschreiben skippen
               ErrorBox2(FmtLoadNLSStr(SPropertyNotFound,[PropertyName,ClassName])+' !'#13+
                         LoadNLSStr(SPropertySkipped));
               Case SCUTyp Of
                   SCUByte,SCUShortInt,SCUByteBool,SCUChar:Inc(P,1);
                   SCUWord,SCUInteger,SCUWordBool:Inc(P,2);
                   SCULongWord,SCULongInt,SCULongBool,SCUSingle:Inc(P,4);
                   SCUDouble:Inc(P,8);
                   SCUExtended:Inc(P,10);
                   SCUString:Inc(P,(P^ And 255)+1);
                   SCUCString:
                   Begin
                        While (P^ And 255)<>0 Do Inc(P);
                        Inc(P); //skip #0
                   End;
                   SCULink:Inc(P,4);  //Name Index
                   SCURecord,SCUBinary:Inc(P,TypeLen);
                   SCUSet4:Inc(P,4);
                   SCUSet32:Inc(P,32);
                   SCUEnum:Inc(P,4);
                   SCUProcVar,SCUFuncVar:Inc(P,12); //Owner,method,Property Name Index
                   {SCUClassVar:Inc(P,4);
                   SCUClass:Inc(P,4);}
                   Else Goto err; //Error !
               End;
               Goto L;  //Until All properties Read
err:
               Inc(ClassPointer,SectionLen);
               Result:=True;
               Exit;
          End;

          TypeLen:=Info.Size;
          Typ:=Info.Typ;
          WriteTyp:=Info.Write.Kind;
          WriteOffset:=Info.Write.VarOffset;

          Case WriteTyp Of
              1,2,3:;
              Else If Typ<>PropType_Class Then
              Begin
                   ErrorBox2(FmtLoadNLSStr(SPropertyReadOnly,[PropertyName])+'. '+
                             LoadNLSStr(SPropertySkipped)+'.');
                   Error:=True;
              End;
          End; {Case}

          If B=2 Then //Link
          Begin
               Typ:=PropType_Link;
          End;

          If Typ=PropType_String Then //String
          Begin
               B:=P^ And 255;
               TypeLen:=B+1;
          End;

          Case Typ Of
            PropType_Class: //Class
            Begin
                 //Get Value Of the Property
                 Case Info.Read.Kind Of
                   1:
                   Begin
                        GetMem(Value,TypeLen);
                        p2:=Pointer(Self);
                        Inc(p2,Info.Read.VarOffset);
                        Move(p2^,Value^,TypeLen);
                   End;
                   2,3:
                   Begin
                        GetMem(Value,TypeLen);
                        If Not CallReadProp(Self,Pointer(Info.Read.VarOffset),Typ,TypeLen,Value) Then
                        Begin
                            ErrorBox2('SCU Error 3: '+FmtLoadNLSStr(SCouldNotReadFromProperty,[PropertyName])+'.');
                            FreeMem(Value,TypeLen);
                            Exit;
                        End;
                   End;
                   Else
                   Begin
                        ErrorBox2(FmtLoadNLSStr(SCouldNotReadFromProperty,[PropertyName])+'.');
                        Goto err;
                   End;
                 End;

                 System.Move(Value^,InheritedComp,4);
                 If InheritedComp=Nil Then
                 Begin
                      ErrorBox2('Property '+Name+'.'+PropertyName+' is NIL');
                      FreeMem(Value,TypeLen);
                      Goto err;
                 End;

                 If Not InheritedComp.ReadPropertiesSCU(COwner,Namep,Resourcep,P) Then
                 Begin
                      ErrorBox2('Property '+Name+'.'+PropertyName+' could not be initialized');
                      FreeMem(Value,TypeLen);
                      Goto err;
                 End;
                 Error:=True; {!!}
            End;
            PropType_ProcVar,PropType_FuncVar:  //ProcVar,FuncVar
            Begin
                 tt:=P^;
                 Inc(P,4);
                 TypeName:='T'+GetClassNameFromSCU(Namep,tt);
                 tt:=P^;
                 Inc(P,4);
                 ProcName:=GetClassNameFromSCU(Namep,tt);
                 tt:=P^;
                 Inc(P,4);
                 PropertyName:=GetClassNameFromSCU(Namep,tt);

                 If TypeLen<>8 Then Exit;  //Of Object !!

                 GetMem(Value,TypeLen);

                 If ((InsideDesigner)Or(InsideLanguageDesigner)) Then
                 Begin
                      //Owner IDESCU_Data suchen !
                      AParent:=GetParentSCUFormDesign(Self);
                      If AParent=Nil Then Exit; //Error
                      //Proc In AParent IDESCU_Data einfgen

                      ProcParams:=GetSCUProcParamsFromName(Self,PropertyName);
                      If ProcParams='?' Then
                      Begin
                           ErrorBox2(FmtLoadNLSStr(SPropError,[PropertyName]));
                           Error:=True;
                      End
                      Else InsertSCUMethod(AParent,Self,ProcName,ProcParams,PropertyName);
                      FillChar(Value^,TypeLen,0);  {!!}
                 End
                 Else
                 Begin
                      //Search For TypeName.ProcName
                      //dazu In SetupSCU alle Forms mit RegisterClasses registrieren
                      ActComponentClass:=SearchClassByName(TypeName);
                      If ActComponentClass=Nil Then
                      Begin
                           ErrorBox2('SCU Error 1: '+FmtLoadNLSStr(SComponentNotFound,[TypeName])+'.'#13+
                                     LoadNLSStr(SUseRegisterClasses));
                           Error:=True;
                      End
                      Else
                      Begin
                           //Get Object For that method
                           AParent:=GetParentSCUFormRuntime(Self,TypeName);
                           If AParent=Nil Then
                           Begin
                                ErrorBox2(FmtLoadNLSStr(SSCUErrorInClass,[TypeName]));
                                Error:=True;
                           End
                           Else
                           Begin
                                Proc:=AParent.MethodAddress(ProcName);
                                If Proc=Nil Then
                                Begin
                                     ErrorBox2(FmtLoadNLSStr(SMethodNotFound,[ProcName,ClassName]));
                                     Error:=True;
                                End
                                Else
                                Begin
                                     //Proc Adresse setzen
                                     Move(Proc,Value^,4);
                                     Inc(Value,4);
                                     //method Object Pointer setzen
                                     Move(AParent,Value^,4);
                                     Dec(Value,4);
                                End;
                           End;
                      End;
                 End;
            End;
            PropType_Link: //Link
            Begin
                 If ComponentState*[csForm]<>[] Then
                   If PropertyName='Menu' Then
                 Begin
                     Include(ComponentState,csHasMainMenu);
                 End;

                 //Name Of Property To Link
                 tt:=P^;
                 Inc(P,4);
                 PropertyName:=GetClassNameFromSCU(Namep,tt);

                 If PropertyLinks=Nil Then
                 Begin
                      New(PropertyLinks);
                      dummy:=PropertyLinks;
                      dummy^.Next:=Nil;
                 End
                 Else
                 Begin
                      New(dummy);
                      dummy^.Next:=PropertyLinks;
                      PropertyLinks:=dummy;
                 End;
                 dummy^.SelfPtr:=Self;
                 dummy^.Owner:=COwner;
                 dummy^.WriteTyp:=WriteTyp;
                 dummy^.WriteOffset:=WriteOffset;
                 dummy^.LinkName:=PropertyName;
                 Goto L; //dont Write here
            End;
            Else
            Begin
                 GetMem(Value,TypeLen);
                 Move(P^,Value^,TypeLen);
                 Inc(P,TypeLen);
            End;
          End; {Case}

          If Not Error Then
             Case WriteTyp Of
               1:
               Begin
                    p2:=Pointer(Self);
                    Inc(p2,WriteOffset);
                    Move(Value^,p2^,TypeLen);
               End;
               2,3:
               Begin
                    If Not CallWriteProp(Self,Pointer(WriteOffset),Typ,TypeLen,Value) Then
                    Begin
                         ErrorBox2('SCU Error 3: '+FmtLoadNLSStr(SCouldNotWriteToProperty,[PropertyName])+' !');
                    End;
               End;
               Else Goto err;  //Some Error
             End;

          FreeMem(Value,TypeLen);

          Goto L;  //Until All properties Read
     End
     Else If B<>0 Then Exit;  //Some Error
     ClassPointer:=P;
     Result:=True;
End;
{$HINTS ON}


Procedure TComponent.ReadResourceSCU(ResourceTable:Pointer;Var ClassP:Pointer);
Var DataOfs:LongWord;
    P:^LongWord;
    ps:PString;
    ResName:TResourceName;
    Data:Pointer;
    DataLen:LongInt;
    pp:^LongWord;
    DOfs:LongWord;
    reshead:LongWord;
Label L;
Begin
L:
     pp:=ClassP;
     Inc(ClassP,4);
     reshead:=pp^;
     If reshead=0 Then Exit; {no resources For This Component}

     P:=ResourceTable+4;  //onto Resource Data Offset
     DataOfs:=P^;

     P:=ResourceTable;
     Inc(P,reshead);      {Offset To Resource Header}

     {process Resource Header}
     ps := PString(P);
     ResName := TResourceName(ps^);
     Inc(P,SizeOf(TResourceName));
     Data:=ResourceTable;
     DOfs:=P^;
     Inc(Data,DataOfs+DOfs);  //Start Of Resource information
     Inc(P,4);
     DataLen:=P^;
     Inc(P,4);
     //Load resources For This Component
     ReadSCUResource(ResName,Data^,DataLen);
     Goto L; {Until no more resources For This}
End;


Procedure HandlePropertyLinks(Component:TComponent);
Var dummy,Next:PPropertyLink;
    P,p2:Pointer;
    T,t1:LongInt;
    Comp,Comp1,Comp2:TComponent;
    S:String;
Label found,again;
Begin
     dummy:=PropertyLinks;
     While dummy<>Nil Do
     Begin
          UpcaseStr(dummy^.LinkName);
          P:=Nil;
          Comp1:=Component;
again:
          For T:=0 To Comp1.ComponentCount-1 Do
          Begin
               Comp:=Comp1.Components[T];

               If csReferenceControl In Comp.ComponentState Then continue;

               If Comp Is TComponent Then
               Begin
                    S:=Comp.Name;
                    UpcaseStr(S);
                    If S=dummy^.LinkName Then
                    Begin
                        P:=@Comp;
                        Goto found;
                    End;
               End;

               For t1:=0 To Comp.ComponentCount-1 Do
               Begin
                   Comp2:=Comp.Components[t1];

                   If csReferenceControl In Comp2.ComponentState Then continue;

                   If Comp2 Is TComponent Then
                   Begin
                        S:=Comp2.Name;
                        UpcaseStr(S);
                        If S=dummy^.LinkName Then
                        Begin
                            P:=@Comp2;
                            Goto found;
                        End;
                   End;
               End;
          End;

          Comp1:=Comp1.Owner;
          If Comp1<>Nil Then Goto again;
found:
          If P<>Nil Then
          Begin
               Case dummy^.WriteTyp Of
                 1:
                 Begin
                     p2:=Pointer(dummy^.SelfPtr);
                     Inc(p2,dummy^.WriteOffset);
                     Move(P^,p2^,4);
                 End;
                 2,3:  //method call (direct Or VMT)
                 Begin
                     If Not CallWriteProp(dummy^.SelfPtr,Pointer(dummy^.WriteOffset),PropType_Unsigned,4,P) Then
                     Begin
                     End;
                 End;
               End; {Case}
          End;

          dummy:=dummy^.Next;
     End;

     dummy:=PropertyLinks;
     While dummy<>Nil Do
     Begin
          If dummy^.SelfPtr=Nil Then
          Begin
               ErrorBox2('SCU Error: '+FmtLoadNLSStr(SLinkNotFound,[dummy^.LinkName])+' !');
          End;

          If ((dummy^.SelfPtr<>Nil)And(dummy^.SelfPtr.FComponentState*[csLoaded]=[])) Then
          Begin
               dummy^.SelfPtr.LoadedFromSCU(dummy^.Owner);
               dummy^.SelfPtr.Loaded;
          End;

          Next:=dummy^.Next;
          Dispose(dummy);
          dummy:=Next;
     End;

     PropertyLinks:=Nil;
End;


Function TComponent.ReadComponentsSCU(NameTable,ResourceTable:Pointer;Var ClassP:Pointer):Boolean;
Var ChildCount,T:LongInt;
    NameIndex,NameIndex1:LongInt;
    ComponentClass:TComponentClass;
    Component:TComponent;
    S,s1:String[64];
    ClassPointer:^LongWord;
    B:Byte;
    P:Pointer;
    RemoveReferenceButton:Boolean;
    ChildIsReferenceButton:Boolean;
    SavePropertyLinks,dummy:PPropertyLink;
    idx:LongInt;
    Ref:TComponent;
    LastReference:TComponent;

    Procedure SkipChildComponents;
    Var t1,Count:LongInt;
        B:Byte;
    Begin
         Count:=ClassPointer^;
         Inc(ClassPointer,4);
         For t1:=1 To Count Do //skip All Child Components
         Begin
              Inc(ClassPointer,4);  //skip Name Index
              B:=ClassPointer^ And 255;
              Inc(ClassPointer);
              If B=1 Then  {runtime Class Name differs from Inspector Class Name}
              Begin
                   Inc(ClassPointer,4);  //skip NameIndex
              End;

              {overread Property section}
              Inc(ClassPointer,ClassPointer^);

              {overread Components section}
              SkipChildComponents; //overread All Child Components

              {overread Resource section}
              While ClassPointer^<>0 Do Inc(ClassPointer,4);
              Inc(ClassPointer,4);  {overread 0}
         End;
    End;

Label skip,skipIt;
Begin
     Result:=False;
     SavePropertyLinks:=PropertyLinks;
     PropertyLinks:=Nil;
     ClassPointer:=ClassP;
     ChildCount:=ClassPointer^;
     Inc(ClassPointer,4);
     LastReference:=Nil;
     For T:=1 To ChildCount Do
     Begin
          NameIndex:=ClassPointer^;
          Inc(ClassPointer,4);
          S:=GetClassNameFromSCU(NameTable,NameIndex); {Of the New Child}

          RemoveReferenceButton := False;
          ChildIsReferenceButton := False;
          If S = 'TReferenceWindow' Then
          Begin
               ChildIsReferenceButton := True;
               If Not InsideDesigner Then RemoveReferenceButton := True;
          End;
          s1 := '';

          {check If runtime Class Name Is avail}
          B:=ClassPointer^ And 255;
          Inc(ClassPointer);
          If B=1 Then  {runtime Class Name differs from Inspector Class Name}
          Begin
               NameIndex1:=ClassPointer^;
               Inc(ClassPointer,4);
               s1:=GetClassNameFromSCU(NameTable,NameIndex1);
               {Use runtime Class Name To Create the Class}
               If Not ((InsideDesigner)Or(InsideLanguageDesigner)) Then
                 If s1 <> '' Then S := s1; {!!}
          End;

          {note: runtime Class Names MUST be registered In Form Unit Or
                 main Program Of an Application !!}

          If RemoveReferenceButton Then ComponentClass:=SearchClassByName('TCONTROL')
          Else ComponentClass:=SearchClassByName(S);

          If ComponentClass=Nil Then
          Begin
               ErrorBox2('SCU Error 2: '+FmtLoadNLSStr(SComponentNotFound,[S])+'.'#13 +
                         LoadNLSStr(SUseRegisterClasses)+' !');
               Goto skipIt;
          End;

          {C R E A T E  the Child Object}
          FCreateFromSCU := True;
          Component := ComponentClass.Create(LastSCUForm);
          FCreateFromSCU := False;

          {zur Sicherheit}
          If ChildIsReferenceButton Then
            If Not RemoveReferenceButton Then
          Begin {Predecessor Is the Reference -> Set the flag}
               idx := LastSCUForm.IndexOfComponent(LastReference);
               If idx >= 0 Then
               Begin
                    Ref := LastSCUForm.Components[idx];
                    Include(Ref.ComponentState, csReference); {!}
               End;
          End;

          Component.SetDesigning(InsideDesigner Or InsideLanguageDesigner);
          Component.LoadingFromSCU(Self);

          If ((InsideDesigner)Or(InsideLanguageDesigner)) Then
          {Set TypeName And IDESCU_Data}
            If s1<>'' Then
            Begin
                 Component.TypeName:=s1;
                 Component.FMethods:=Nil; {no Methods defined}
            End;

          If RemoveReferenceButton Then
          Begin
               Component.Destroy;   {besser gar nicht erst erzeugen}
skipIt:
               {overread Property section}
               Inc(ClassPointer,ClassPointer^);

               {overread Components section}
               SkipChildComponents; //overread All Child Components

               {overread Resource section}
               While ClassPointer^<>0 Do Inc(ClassPointer,4);
               Inc(ClassPointer,4);  {overread 0}

               continue;
          End
          Else
          Begin
               If Not Component.ReadPropertiesSCU(Self,NameTable,ResourceTable,ClassPointer) Then Exit;
               If Not Component.ReadComponentsSCU(NameTable,ResourceTable,ClassPointer) Then Exit;
               Component.ReadResourceSCU(ResourceTable,ClassPointer);
          End;


          If Not ((InsideDesigner)Or(InsideLanguageDesigner)) Then
          Begin
               {Set Object variable If present}
               P := LastSCUForm.FieldAddress(Component.Name);
               If P <> Nil Then Move(Component,P^,4);
          End;

          //If This Component expects A Link Then we don't call Loaded unless the
          //Link Is established
          dummy:=PropertyLinks;
          While dummy<>Nil Do
          Begin
               If dummy^.SelfPtr=Component Then Goto skip;
               dummy:=dummy^.Next;
          End;

          If Component.FComponentState*[csLoaded]=[] Then
          Begin
               If ChildIsReferenceButton Then
               Begin
                    //Set the Reference
                    Component.FReference:=LastReference;
                    Include(LastReference.ComponentState,csReference);
                    Component.LoadedFromSCU(Self);
               End
               Else Component.LoadedFromSCU(Self);
               Component.Loaded;
          End;
skip:
          //This Is the Last Reference Window
          //we have To Store it because it may contain Child Items...
          LastReference:=Component;
     End;

     If PropertyLinks<>Nil Then
     Begin
          dummy:=PropertyLinks;
          While dummy^.Next<>Nil Do dummy:=dummy^.Next;
          dummy^.Next:=SavePropertyLinks;  {Append}
     End
     Else PropertyLinks:=SavePropertyLinks;

     ClassP:=ClassPointer;
     Result:=True;
End;


Function SearchClassSCU(Data:Pointer;NameToFind:String;ObjectCount:LongInt;ClassUnit:String):Pointer;
Var dummy:^LongWord;
    len:LongWord;
    Count:LongInt;
    ps:^String;
    S,D,N,E:String;
Label L;
Begin
     Result:=Nil;
     Count:=0;
     UpcaseStr(ClassUnit);
L:
     If Count>=ObjectCount Then Exit;
     dummy:=Data;
     len:=dummy^;   //len Of This entry
     Inc(dummy,4);  //onto Inspector Class Name
     Inc(dummy,(dummy^ And 255)+1); //overread Inspector Name
     ps:=Pointer(dummy);     //runtime Class Name
     S:=ps^;
     UpcaseStr(S);
     If S=NameToFind Then
     Begin
          Inc(ps,Length(S)+1);               //ON Unit Name
          S:=ps^;
          UpcaseStr(S);
          FSplit(S,D,N,E);
          If N=ClassUnit Then
          Begin
               Result:=Data;
               Exit;
          End;
     End;

     Inc(Data,len); //Next entry
     Inc(Count);
     Goto L;
End;


Procedure TComponent.SetupSCU;
Var
    SaveSCU:Pointer;
    OldInsideDesigner:Boolean;
Begin
     If SCUPointer=Nil Then Exit;
     If ComponentState * [csForm] = [] Then Exit;

     OldInsideDesigner:=InsideDesigner;
     SaveSCU:=SCUPointer;
     SCUPointer:=Nil; //prevent recursion
     Try
        ReadSCU(SaveSCU);
     Except
        On E:Exception Do
          If ((InsideDesigner)Or(InsideLanguageDesigner)) Then ErrorBox2('Illegal SCU format:'+E.Message);
     End;

     SCUPointer:=SaveSCU;
     InsideDesigner:=OldInsideDesigner;
End;


{$HINTS OFF}
Procedure TComponent.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
End;

Function TComponent.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result:=True;
End;

Procedure TComponent.LoadedFromSCU(SCUParent:TComponent);
Begin
     Exclude(FComponentState, csReading);
     Exclude(FComponentState, csLoading);
     Include(FComponentState, csLoaded);
End;

Procedure TComponent.LoadingFromSCU(SCUParent:TComponent);
Begin
     Include(FComponentState, csReading);
     Include(FComponentState, csLoading);
     Exclude(FComponentState, csLoaded);
End;
{$HINTS ON}

Procedure TComponent.Loaded;
Begin
End;


Procedure TComponent.SetupComponent;
Begin
     //Name := 'Component';
     Name := Copy(ClassName,2,255);
     Tag := 0;
     If Designed Then Include(ComponentState,csReference);
End;


Constructor TComponent.Create(AOwner:TComponent);
Begin
     //Inherited Create;

     If InsideWriteSCUAdr^ Then Include(ComponentState, csWriting);

     If AOwner Is TComponent Then AOwner.InsertComponent(Self);

     SetupComponent;
End;


Procedure SetupFormSCU(Form:TComponent);
Begin
     If SCUPointer <> Nil Then Form.SetupSCU;
End;


Procedure TComponent.Notification(AComponent:TComponent;Operation:TOperation);
Var  I:LongInt;
Begin
     If (FFreeNotifyList <> Nil) And (Operation = opRemove) Then
     Begin
          FFreeNotifyList.Remove(AComponent);
          If FFreeNotifyList.Count = 0 Then
          Begin
               FFreeNotifyList.Destroy;
               FFreeNotifyList := Nil;
          End;
     End;

     For I := 0 To ComponentCount-1 Do
     Begin
          Components[I].Notification(AComponent,Operation);
     End;
End;


Procedure TComponent.FreeNotification(AComponent:TComponent);
Begin
     If FFreeNotifyList = Nil Then FFreeNotifyList.Create;

     If FFreeNotifyList.IndexOf(AComponent) < 0 Then
     Begin
          FFreeNotifyList.Add(AComponent);
          AComponent.FreeNotification(Self);
     End;
End;


Function GetLanguages(Component:TComponent):PLanguageInfo;
Begin
     Result:=Component.FLanguages;
End;

Procedure SetLanguages(Component:TComponent;Info:PLanguageInfo);
Begin
     Component.FLanguages:=Info;
End;

Procedure FreeLanguage(Var LangComp:PLanguageComponent);
Var NextLangComp:PLanguageComponent;
Begin
     While LangComp<>Nil Do
     Begin
          FreeMem(LangComp^.Name,Length(LangComp^.Name^)+1);
          If LangComp^.ValueLen>0 Then
           FreeMem(LangComp^.Value,LangComp^.ValueLen);

          NextLangComp:=LangComp^.Next;
          Dispose(LangComp);
          LangComp:=NextLangComp;
     End;
End;

Destructor TComponent.Destroy;
Var Meth,Last:PIDE_Methods;
    T:LongInt;
    Own:PIDE_OwnerList;
    I:LongInt;
    LangItem,NextLangItem:PLanguageItem;
Begin
     {inform All linked Components}
     If FFreeNotifyList <> Nil Then
     Begin
          For I := 0 To FFreeNotifyList.Count-1 Do
          Begin
               TComponent(FFreeNotifyList[I]).Notification(Self,opRemove);
          End;
          FFreeNotifyList.Destroy;
          FFreeNotifyList := Nil;
     End;

     Meth:=FMethods;
     While Meth<>Nil Do
     Begin
          DisposeStr(Meth^.Name);
          DisposeStr(Meth^.Params);
          If Meth^.Owners<>Nil Then
          Begin
               For T:=0 To Meth^.Owners.Count-1 Do
               Begin
                    Own:=Meth^.Owners.Items[T];
                    DisposeStr(Own^.PropertyName);
               End;
               Meth^.Owners.Destroy;
          End;

          Last:=Meth^.Next;
          Dispose(Meth);
          Meth:=Last;
     End;
     FMethods := Nil;

     //Free registered languages
     If FLanguages<>Nil Then
     Begin
          LangItem:=PLanguageInfo(FLanguages)^.Items;
          FreeMem(FLanguages,SizeOf(TLanguageInfo));
          FLanguages:=Nil;
          While LangItem<>Nil Do
          Begin
               FreeMem(LangItem^.Name,Length(LangItem^.Name^)+1);

               FreeLanguage(LangItem^.Components);
               FreeLanguage(LangItem^.Menus);
               FreeLanguage(LangItem^.StringTables);

               NextLangItem:=LangItem^.Next;
               Dispose(LangItem);
               LangItem:=NextLangItem;
          End;
     End;


     DestroyComponents;

     If FOwner <> Nil Then FOwner.RemoveComponent(Self);

     DisposeStr(FName);
     FName := Nil;
     DisposeStr(FUnitName);
     FUnitName := Nil;
     DisposeStr(FTypeName);
     FTypeName := Nil;

     Inherited Destroy;
End;


Procedure TComponent.DestroyComponents;
Var  I:LongInt;
     Component:TComponent;
Begin
     If FComponents <> Nil Then
     Begin
          I := ComponentCount;
          While I > 0 Do
          Begin
               Component := Components[I-1];
               RemoveComponent(Component);
               Component.Destroy;
               I := ComponentCount;
          End;

          FComponents.Destroy;
          FComponents := Nil;
     End;
End;

Function TComponent.GetComponentIndex:LongInt;
Begin
     Result := -1;
     If FOwner = Nil Then Exit;
     If FOwner.FComponents = Nil Then Exit;
     Result := FOwner.FComponents.IndexOf(Self);
End;

Procedure TComponent.SetComponentIndex(Index:LongInt);
Var  I:LongInt;
Begin
     If FOwner = Nil Then Exit;
     I := FOwner.IndexOfComponent(Self);
     If I < 0 Then Exit;
     If Index = I Then Exit;
     If Index < 0 Then Index := 0;
     If Index >= FOwner.FComponents.Count
     Then Index := FOwner.FComponents.Count -1;
     FOwner.FComponents.Move(I,Index);
End;

Function TComponent.GetComponentCount:LongInt;
Begin
     If FComponents=Nil Then Result:=0
     Else Result:=FComponents.Count;
End;

Function TComponent.GetComponent(AIndex:LongInt):TComponent;
Begin
     If (FComponents=Nil) Or (AIndex<0) Or (AIndex>=FComponents.Count)
     Then Result:=Nil
     Else Result:=FComponents.Items[AIndex];
End;

Function TComponent.GetName:String;
Begin
     If FName<>Nil Then Result:=FName^
     Else Result:='';
End;

Procedure TComponent.SetName(Const NewName:String);
Begin
     AssignStr(FName,NewName);
End;

Function TComponent.GetUnitName:String;
Begin
     If FUnitName <> Nil Then Result := FUnitName^
     Else Result := '';
End;

Function TComponent.GetTypeName:String;
Begin
     If FTypeName <> Nil Then Result := FTypeName^
     Else Result := '';
End;

Procedure TComponent.SetTypeName(NewName:String);
Begin
     AssignStr(FTypeName,NewName);
End;

Function TComponent.GetDesigned:Boolean;
Begin
     Result := FComponentState * [csDesigning] <> [];
End;

Procedure TComponent.InsertComponent(AComponent:TComponent);
Begin
     If FComponents = Nil Then FComponents.Create;
     FComponents.Add(AComponent);
     AComponent.FOwner := Self;

     AComponent.SetDesigning(Designed);    {!}

     Notification(AComponent,opInsert);
End;

Procedure TComponent.RemoveComponent(AComponent:TComponent);
Begin
     Notification(AComponent,opRemove);
     If FComponents = Nil Then Exit;
     FComponents.Remove(AComponent);
End;

Function TComponent.IndexOfComponent(AComponent:TComponent):LongInt;
Begin
     Result := -1;
     If FComponents = Nil Then Exit;
     Result := FComponents.IndexOf(AComponent);
End;

Function TComponent.FindComponent(Const AName:String):TComponent;
Var  I:LongInt;
Begin
     Result := Nil;
     For I := 0 To ComponentCount-1 Do
       If Components[I].Name = AName Then
       Begin
            Result := Components[I];
            break;
       End;
End;


Procedure TComponent.SetDesigning(Value:Boolean);
Var  I:LongInt;
Begin
     If Value Then Include(FComponentState, csDesigning)
     Else Exclude(FComponentState, csDesigning);

     For I := 0 To ComponentCount-1 Do Components[I].SetDesigning(Value);
End;


Procedure AddDesignerPopupEvent(AString:TStringList;Caption:String;Id:LongInt);
Begin
     If AString Is TStringList Then AString.AddObject(Caption, TObject(Id));
End;


{event from the designer PopupMenu}
{$HINTS OFF}
Procedure TComponent.GetDesignerPopupEvents(AString:TStringList);
Begin
End;

Procedure TComponent.DesignerPopupEvent(Id:LongInt);
Begin
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: General FUNCTIONs Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
   SearchCompLibComponentByName:Function(Const Name:String):TComponentClass=Nil;
   CallCompLibClassPropertyEditor:Function(Var ClassToEdit:TObject):TClassPropertyEditorReturn=Nil;
   CallCompLibPropertyEditor:Function(Owner:TComponent;PropertyName:String;Var Value;ValueLen:LongInt;
                                      Var List:TStringList):TPropertyEditorReturn=Nil;
   CallCompLibPropertyEditorAvailable:Function(OwnerClass:TClass;PropertyName:String):Boolean=Nil;
   CallCompLibClassPropertyEditorAvailable:Function(ClassName:String):Boolean=Nil;

Var
    NameTable:TList;

Function NameTableAdd(P:PString):LongInt;
Var T:LongInt;
    Ofs:LongInt;
    pp:PString;
Begin
     Ofs:=0;
     For T:=0 To NameTable.Count-1 Do
     Begin
          pp:=NameTable.Items[T];
          If pp^=P^ Then
          Begin
               Result:=Ofs;
               Exit;
          End;
          Inc(Ofs,Length(pp^)+1);
     End;
     NameTable.Add(P);
     Result:=Ofs;
End;


Function SearchClassByName(Const Name:String):TComponentClass;
Var  T:LongInt;
     Comp:TComponentClass;
     S,s1:String;
Begin
     Result := Nil;
     S := Name;
     UpcaseStr(S);
     For T := 0 To RegisteredClasses.Count-1 Do
     Begin
          Comp := RegisteredClasses.Items[T];
          s1 := Comp.ClassName;
          UpcaseStr(s1);
          If s1 = S Then
          Begin
               Result := Comp;
               Exit;
          End;
     End;

     {Search In registered Components Of the complib}
     If @SearchCompLibComponentByName<>Nil
     Then Result := SearchCompLibComponentByName(Name);
End;

Procedure RegisterClass(Const ComponentClass:TComponentClass);
Var Comp:TComponentClass;
    t1:LongInt;
Begin
     For t1:=0 To RegisteredClasses.Count-1 Do
     Begin
          Comp:=RegisteredClasses.Items[t1];
          If Comp.ClassName=ComponentClass.ClassName Then exit;
     End;

     RegisteredClasses.Add(ComponentClass);
End;

Function GetClass(Const ClassName:String):TComponentClass;
Begin
     Result:=SearchClassByName(ClassName);
End;

Function FindClass(Const ClassName:String):TComponentClass;
Begin
     Result:=GetClass(ClassName);
     If Result=Nil Then Raise EClassNotFound.Create(ClassName);
End;

Procedure UnRegisterClass(AClass:TComponentClass);
Var t1:LongInt;
    Comp:TComponentClass;
Label again;
Begin
again:
     For t1:=0 To RegisteredClasses.Count-1 Do
     Begin
          Comp:=RegisteredClasses.Items[t1];
          If Comp.ClassName=AClass.ClassName Then
          Begin
               RegisteredClasses.Remove(Comp);
               goto again;
          End;
     End;
End;

Procedure UnRegisterClasses(Const AClasses:Array of TComponentClass);
Var t:LongInt;
Begin
     For t:=0 To High(AClasses) Do UnRegisterClass(AClasses[t]);
End;


Procedure RegisterClasses(Const ComponentClasses: Array Of TComponentClass);
Var T,t1:LongInt;
    Comp,Comp1:TComponentClass;
Label l1;
Begin
     For T:=0 To High(ComponentClasses) Do
     Begin
          Comp1:=ComponentClasses[T];
          For t1:=0 To RegisteredClasses.Count-1 Do
          Begin
               Comp:=RegisteredClasses.Items[t1];
               If Comp.ClassName=Comp1.ClassName Then Goto l1;
          End;

          RegisteredClasses.Add(Comp1);
l1:
     End;
End;

{copies actual Value Of Property To Value.
 Value MUST be allocated With At least TypLen Bytes !}
Function CallReadProp(Objekt:TObject;FuncAddr:Pointer;Typ:Byte;
                      TypLen:LongInt;Value:Pointer):Boolean;
Var
    FResult:LongInt;
    Func:Function(SelfObj:TObject):LongInt;
    FuncVar:Function(VarRef:Pointer;SelfObj:TObject):LongInt;
Begin
     Result:=False;

     If FuncAddr=Nil Then Exit;  //method Not found

     If ((Typ=PropType_Set)And(TypLen=4)) Then Typ:=PropType_Unsigned;

     If LongWord(FuncAddr)<65535 Then //VMT call
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Asm
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,FuncAddr        //VMT Index
                     CALLN32 System.!VmtCall
                     MOV FResult,EAX
                  End;
                  Move(FResult,Value^,TypLen);
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  Asm
                     PUSH DWord Ptr Value    //Var Parameter Of return Value
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,FuncAddr        //VMT Index
                     CALLN32 System.!VmtCall
                  End;
             End;
             Else Exit;  //Some Error
          End; {Case}
     End
     Else
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Func:=FuncAddr;
                  FResult:=Func(Objekt);
                  Move(FResult,Value^,TypLen);
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  FuncVar:=FuncAddr;
                  FResult:=FuncVar(Value,Objekt);
             End;
             Else Exit;  //Some Error
          End; {Case}
     End;

     Result:=True;
End;

{copies actual Value Of Value To the Property.
 Value MUST be allocated With At least TypLen Bytes !}
Function CallWriteProp(Objekt:TObject;ProcAddr:Pointer;Typ:Byte;
                       TypLen:LongInt;Value:Pointer):Boolean;
Var
    Proc:Procedure(Value:LongWord;SelfObj:TObject);
    ProcVar:Procedure(Value:Pointer;SelfObj:TObject);
    pb:^LongWord;
    pw:^Word;
    pl:^LongWord;
    L:LongWord;
Begin
     Result:=False;

     If ProcAddr=Nil Then Exit;  //method Not found

     If TypLen In [1,2,3,4] Then
       If Not (Typ In [PropType_String,PropType_CString]) Then Typ:=PropType_Unsigned;

     If LongWord(ProcAddr)<65535 Then //VMT call
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Case TypLen Of
                    1:
                    Begin
                         pb:=Value;
                         L:=pb^;
                    End;
                    2:
                    Begin
                         pw:=Value;
                         L:=pw^;
                    End;
                    3:
                    Begin
                         L:=0;
                         Move(pl^,L,3);
                    End;
                    4:
                    Begin
                         pl:=Value;
                         L:=pl^;
                    End;
                    Else Exit;  //no Valid Type Size For Val
                  End; {Case}

                  Asm
                     PUSH DWord Ptr L        //Value To Set
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,ProcAddr        //VMT Index
                     CALLN32 System.!VmtCall
                  End;
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  Asm
                     PUSH DWord Ptr Value    //Var Parameter Of Data To Assign
                     PUSH DWord Ptr Objekt   //Self
                     MOV EAX,ProcAddr        //VMT Index
                     CALLN32 System.!VmtCall
                  End;
             End;
             Else Exit;  //Some Error
          End; {Case}
     End
     Else
     Begin
          Case Typ Of
             PropType_Unsigned,PropType_Signed,PropType_Class,
             PropType_Enum,PropType_Boolean,PropType_Char,PropType_ClassVar:
             Begin
                  Proc:=ProcAddr;
                  Case TypLen Of
                    1:
                    Begin
                         pb:=Value;
                         L:=pb^;
                    End;
                    2:
                    Begin
                         pw:=Value;
                         L:=pw^;
                    End;
                    3:
                    Begin
                         L:=0;
                         Move(pl^,L,3);
                    End;
                    4:
                    Begin
                         pl:=Value;
                         L:=pl^;
                    End;
                    Else Exit;  //no Valid Type Size For Val
                  End; {Case}

                  Proc(L,Objekt);
             End;
             PropType_Float,PropType_String,PropType_Set,PropType_CString,
             PropType_ProcVar,PropType_FuncVar,PropType_Record:
             Begin
                  ProcVar:=ProcAddr;
                  ProcVar(Value,Objekt);
             End;
             Else Exit;  //Some Error
          End; {Case}
     End;

     Result:=True;
End;

Var PropertyNameTable:Pointer;


Const SCUUnsignedTypes:Array[1..4] Of SCUTypes=(SCUByte,SCUWord,SCUNull,SCULongWord);
      SCUSignedTypes:Array[1..4] Of SCUTypes=(SCUShortInt,SCUInteger,SCUNull,SCULongInt);
      SCUFloatTypes:Array[4..10] Of SCUTypes=(SCUSingle,SCUNull,SCUNull,SCUNull,SCUDouble,SCUNull,SCUExtended);
      SCUBooleanTypes:Array[1..4] Of SCUTypes=(SCUByteBool,SCUWordBool,SCUNull,SCULongBool);

Function WriteProperties(Stream:TMemoryStream;p1:Pointer;Objekt:TComponent;
                         pParent:Pointer):Boolean; Forward;


Function WritePropertyValues(Stream:TMemoryStream;P:Pointer;Objekt:TComponent;
                             Namep:Pointer;ReferenceObjekt:TComponent):Boolean;
Var Typep,p1,p2:^LongInt;
    Typ,B:Byte;
    tt,TypLen:LongInt;
    ReadTyp,WriteTyp:Byte;
    S:String;
    ps:^String;
    Value,ReferenceValue:^LongInt;
    ValueLen:LongInt;
    ReadOffset,WriteOffset:LongInt;
    s3:String;
    ReadAddr,WriteAddr:Pointer;
    ValidProp:Boolean;
    AOwner:TComponent;
    Methods:PIDE_Methods;
    Own:PIDE_OwnerList;
    MyComp:TComponent;
    pParent1:Pointer;
Label L,lll,lll1,ex,weiter;
Begin
     Result:=False;
     ValidProp:=True;
     p1:=P;
     MyComp:=Nil;

     ReadTyp:=p1^ And 255;
     Inc(p1);
     Case ReadTyp Of
        0:;  //Not avail
        1:   //Var Offset
        Begin
             ReadOffset:=p1^;
             Inc(p1,4);
        End;
        2,3:   //Procedure Or Function (direct Or VMT call)
        Begin
             ReadAddr:=Pointer(p1^);
             Inc(p1,4);
        End;
        Else Goto ex;  //Some Error
     End;

     WriteTyp:=p1^ And 255;
     Inc(p1);
     Case WriteTyp Of
        0:;  //Not avail
        1:   //Var Offset
        Begin
             WriteOffset:=p1^;
             Inc(p1,4);
        End;
        2,3:   //Procedure Or Function (direct Or VMT call)
        Begin
             WriteAddr:=Pointer(p1^);
             Inc(p1,4);
        End;
        Else Goto ex;  //Some Error
     End;

     //determine Type Of the Property
     TypLen:=p1^;
     ValueLen:=TypLen;
     GetMem(Value,TypLen);
     GetMem(ReferenceValue,TypLen);
     Inc(p1,4);
     Typ:=p1^ And 255;             //Property Type
     Typep:=p1;

     //Write Value Of the Property
     Case ReadTyp Of
        0:;  //Not avail
        1:   //Var Offset
        Begin
             p2:=Pointer(Objekt);
             Inc(p2,ReadOffset);
             Move(p2^,Value^,TypLen);
             p2:=Pointer(ReferenceObjekt);
             Inc(p2,ReadOffset);
             Move(p2^,ReferenceValue^,TypLen);
        End;
        2,3:   //Procedure Or Function (direct Or VMT call)
        Begin
             If Not CallReadProp(Objekt,ReadAddr,Typ,TypLen,Value) Then Goto ex;
             If Not CallReadProp(ReferenceObjekt,ReadAddr,Typ,TypLen,ReferenceValue) Then Goto ex;
        End;
        Else Goto ex;  //Some Error
     End;

     If ReadTyp In [1,2,3] Then
     Begin
          If Typ In [PropType_ProcVar,PropType_FuncVar,
                     PropType_Class,PropType_ClassVar] Then //ON... properties
                                                            //ClassVar And
                                                            //Classes
          Begin
               Own:=Nil;
               If Value^=0 Then
               Begin
                    If Typ In [PropType_ProcVar,PropType_FuncVar] Then //ON properties
                    Begin
                         //Search Owner
                         AOwner:=Objekt;
                         ps:=Namep;
                         S:=ps^;
                         UpcaseStr(S);
lll:
                         While AOwner<>Nil Do
                         Begin
                              Methods:=AOwner.FMethods;

                              While Methods<>Nil Do
                              Begin
                                   For tt:=0 To Methods^.Owners.Count-1 Do
                                   Begin
                                       Own:=Methods^.Owners.Items[tt];
                                       s3:=Own^.PropertyName^;
                                       UpcaseStr(s3);
                                       If S=s3 Then
                                         If Own^.Objekt=TComponent(Objekt) Then
                                       Begin  //found
                                            Goto lll1;
                                       End;
                                   End;

                                   Methods:=Methods^.Next;
                              End;
weiter:
                              AOwner:=AOwner.FOwner;
                              Goto lll;
                         End;  //While AOwner<>Nil

                         Goto L;  //Not found --> dont Write
                    End
                    Else Goto L; //dont Write
               End;

               If Typ=PropType_Class Then {Class}
               Begin
                    MyComp:=Pointer(Value^);
                    If MyComp<>Nil Then
                      If MyComp Is TComponent Then
                        If MyComp.Designed Then
                           If MyComp.ComponentState * [csHandleLinks] <> [] Then
                           Begin
                               Typ:=PropType_Link;  //Link
                               Goto lll1;
                           End;

                    If MyComp Is TComponent Then
                      If MyComp.DesignerState*[dsStored]<>[] Then
                    Begin
                         p1:=Pointer(PropertyNameTable);

                         p2:=Pointer(MyComp);  //Object address
                         If p2<>Nil Then
                         Begin
                              //Write properties Of the Class
                              B:=1;
                              If Stream.Write(B,1)=0 Then Goto ex;

                              tt:=NameTableAdd(Namep);  //Name Of the Property
                              If Stream.Write(tt,4)=0 Then Goto ex;

                              {Type Info For the Property}
                              B:=Ord(SCUClass);
                              If Stream.Write(B,1)=0 Then Goto ex;


                              p2:=Pointer(p2^);  //VMT address
                              Inc(p2,4);
                              p2:=Pointer(p2^);  //Class Info
                              Inc(p2,4);
                              pParent1:=Pointer(p2^); //parent Class VMT Or Nil
                              Inc(p2,8);
                              p2:=Pointer(p2^);  //Property Info
                              If Not WriteProperties(Stream,p2,MyComp,pParent1) Then Goto ex;
                              PropertyNameTable:=Pointer(p1);
                         End;
                    End;
               End;

               //dont Write TBitmap here (Extra Data In BitButton Or Picture)

               Goto L; //don't Write Class/ClassVar
          End
          Else
          Begin
               //only Write If Value Is different from Default Value
              If Typ=PropType_String Then ValueLen:=(Value^ And 255)+1;  //String
              If ValueLen>TypLen Then ValueLen:=TypLen;

               If CompareResMem(Value^,ReferenceValue^,ValueLen) Then Goto L;
          End;
lll1:
          //the Value differs from the Default Value And MUST be written

          If Typ=PropType_Link Then B:=2
          Else B:=1;
          If Stream.Write(B,1)=0 Then Goto ex;

          tt:=NameTableAdd(Namep);  //Name Of the Property
          If Stream.Write(tt,4)=0 Then Goto ex;

          tt:=0;
          Case Typ Of
              PropType_Unsigned:B:=Ord(SCUUnsignedTypes[ValueLen]);
              PropType_Signed:B:=Ord(SCUSignedTypes[ValueLen]);
              PropType_Float:B:=Ord(SCUFloatTypes[ValueLen]);
              PropType_Set:
              Begin
                   If ValueLen=4 Then B:=Ord(SCUSet4)
                   Else B:=Ord(SCUSet32);
              End;
              PropType_CString:B:=Ord(SCUCString);
              PropType_Record:
              Begin
                   B:=Ord(SCURecord);
                   If Stream.Write(B,1)=0 Then Goto ex;
                   tt:=ValueLen;
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
              PropType_Class:B:=Ord(SCUClass);
              PropType_String:B:=Ord(SCUString);
              PropType_Enum:B:=Ord(SCUEnum);
              PropType_Boolean:B:=Ord(SCUBooleanTypes[ValueLen]);
              PropType_Char:B:=Ord(SCUChar);
              PropType_ClassVar:B:=Ord(SCUClassVar);
              PropType_ProcVar:B:=Ord(SCUProcVar);
              PropType_FuncVar:B:=Ord(SCUFuncVar);
              PropType_Link:B:=Ord(SCULink);
              Else
              Begin
                   B:=Ord(SCUBinary);
                   If Stream.Write(B,1)=0 Then Goto ex;
                   tt:=ValueLen;
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
          End;

          If tt=0 Then If Stream.Write(B,1)=0 Then Goto ex; //Not For records

          Case Typ Of
              PropType_ProcVar,PropType_FuncVar: //Events
              Begin
                   //Owner Type Name
                   If AOwner.FName=Nil Then AOwner.Name:=AOwner.ClassName;
                   tt:=NameTableAdd(AOwner.FName);
                   If Stream.Write(tt,4)=0 Then Goto ex;

                   //method Name
                   tt:=NameTableAdd(Methods^.Name);
                   If Stream.Write(tt,4)=0 Then Goto ex;

                   //Property Name
                   tt:=NameTableAdd(Namep);
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
              PropType_Link:  //Link
              Begin
                   //Link field Name
                   If MyComp=Nil Then Goto ex;

                   If MyComp.FName=Nil Then MyComp.Name:=MyComp.ClassName;
                   tt:=NameTableAdd(MyComp.FName);
                   If Stream.Write(tt,4)=0 Then Goto ex;
              End;
              Else //others
              Begin
                  If Typ=PropType_String Then ValueLen:=(Value^ And 255)+1;  //String
                  If ValueLen>TypLen Then ValueLen:=TypLen;
                  If Stream.Write(Value^,ValueLen)=0 Then Goto ex;
              End;
          End; {Case}
     End
     Else Goto ex; //Some Error
L:
     Result:=True;
ex:
     FreeMem(Value,TypLen);
     FreeMem(ReferenceValue,TypLen);
End;



Function WriteProperties(Stream:TMemoryStream;p1:Pointer;Objekt:TComponent;
                         pParent:Pointer):Boolean;
Var Namep,P,pp,p2:^LongInt;
    B:Byte;
    NameLen:LongInt;
    len,OldPos,EndPos:LongInt;
    ReferenceObjekt:TComponent;
    ObjektClass:TComponentClass;
    Scope:Byte;
Label L,ex;
Begin
     Result:=False;
     P:=p1;

     ObjektClass:=Objekt.ClassType;
     InsideWriteSCUAdr^:=True;
     ReferenceObjekt:=Nil;
     Try
        ReferenceObjekt:=ObjektClass.Create({Objekt.FOwner}Nil);
        Include(ReferenceObjekt.ComponentState, csWriting);
        InsideWriteSCUAdr^:=False;

        OldPos:=Stream.Position;
        len:=0;                     //patched later
        If Stream.Write(len,4)=0 Then Goto ex;
        Inc(P,4);                  //onto Property Name Table
        PropertyNameTable:=Pointer(P^);
        Inc(P,4);                  //onto First Name
L:
        NameLen:=P^ And 255;
        Namep:=Pointer(P);

        If NameLen<>0 Then
        Begin
             Inc(P,NameLen+1);  //overread Name
             Scope:=P^ And 255;
             Inc(P);
             If Scope And 16=0 Then  //Not stored
             Begin
                  Inc(P,4);
                  Goto L;
             End;

             //Property Is stored, Find out If we need To Write the Value Of it To the SCU Stream
             p2:=Pointer(P^);   //Property Type And access Info
             If p2<>Nil Then
               If Not WritePropertyValues(Stream,p2,Objekt,Namep,ReferenceObjekt) Then Goto ex;  //Some Error
             Inc(P,4);   //Until All properties written
             Goto L;
        End;

        If pParent<>Nil Then
        Begin
             pp:=pParent;            //parent VMT Info
             Inc(pp,4);
             pp:=Pointer(pp^);       //ClassInfo
             Inc(pp,4);
             pParent:=Pointer(pp^);  //parent Class VMT Or Nil
             Inc(pp,8);
             pp:=Pointer(pp^);       //Property Pointer
             P:=pp;
             p1:=P;
             Inc(P,4);               //onto Property Name Table
             PropertyNameTable:=Pointer(P^);
             Inc(P,4);               //onto First Name
             Goto L;                 //Write parent properties
        End;

        B:=0;
        If Stream.Write(B,1)=0 Then Goto ex;

        EndPos:=Stream.Position;
        len:=EndPos-OldPos;
        Stream.Position:=OldPos;
        If Stream.Write(len,4)=0 Then Goto ex;
        Stream.Position:=EndPos;

        Result:=True;
ex:
     Finally
        If ReferenceObjekt<>Nil Then ReferenceObjekt.Destroy;
        InsideWriteSCUAdr^:=False;
     End;
End;

Function WriteNameTable(Stream:TMemoryStream):Boolean;
Var T:LongInt;
    pp:PString;
Begin
     Result:=False;

     For T:=0 To NameTable.Count-1 Do
     Begin
          pp:=NameTable.Items[T];
          If Stream.Write(pp^,Length(pp^)+1)=0 Then Exit;
     End;

     NameTable.Destroy; {!!}
     Result:=True;
End;


Function WriteObjectComponents(Stream:TMemoryStream;ResStream:TResourceStream;
                               Objekt:TComponent):Boolean;
Var  Count:LongInt;
     PatchStreamPos:LongInt;
     CurStreamPos:LongInt;
Begin
     Result := False;

     Objekt.SCUStream := Stream;
     Objekt.SCUResStream := ResStream;
     PatchStreamPos := Stream.Position;

     Count := 0;
     If Stream.Write(Count,4) = 0 Then Exit; {Write dummy, patch it later}
     Objekt.FWriteComponentCount := 0;
     Objekt.GetChildren(Objekt.WriteComponent);
     Count := Objekt.FWriteComponentCount;

     Objekt.SCUStream := Nil;
     Objekt.SCUResStream := Nil;

     CurStreamPos := Stream.Position;
     Stream.Position := PatchStreamPos;
     If Stream.Write(Count,4) = 0 Then Exit;
     Stream.Position := CurStreamPos;

     Result := Not Objekt.SCUWriteError;
End;


{Write SCU information Of the Child Component}
Procedure TComponent.WriteComponent(Child:TComponent);
Const Zero:LongInt=0;
Var  pp,pp1,pParent1:^LongInt;
     tt:LongInt;
     B:Byte;
     Ok:Boolean;
     err:String[40];
Label ex;
Begin
     If csReferenceControl In Child.ComponentState Then
     Begin //Write the referenced Component before Self
          If Child.FReference <> Nil Then WriteComponent(Child.FReference);
     End;

     Ok:=False;
     err:='Stream write error';
     Try
        SCUWriteError := True;
        If SCUStream = Nil Then Goto ex;
        If SCUResStream = Nil Then Goto ex;

        pp:=Pointer(Child);
        pp:=Pointer(pp^);       //VMT Info

        Inc(pp,4);
        pp:=Pointer(pp^);       //ClassInfo
        pp1:=pp;
        Inc(pp,4);
        pParent1:=Pointer(pp^); //parent Class VMT Or Nil
        Inc(pp,8);
        pp:=Pointer(pp^);       //Property Pointer

        //Write Inspector Class Name
        Inc(pp1,16);   //onto ClassName
        tt:=NameTableAdd(Pointer(pp1));
        If SCUStream.Write(tt,4)=0 Then Goto ex;

        //Write runtime Class Name
        If Child.FTypeName=Nil Then
        Begin
             B:=0;     //runtime And Inspector Type Name are identical
             If SCUStream.Write(B,1)=0 Then Goto ex;
        End
        Else
        Begin
             B:=1;     //runtime Name Is different from Inspector Name
             If SCUStream.Write(B,1)=0 Then Goto ex;
             tt:=NameTableAdd(Child.FTypeName);
             If SCUStream.Write(tt,4)=0 Then Goto ex;
        End;

        If Not WriteProperties(SCUStream,pp,Child,pParent1) Then
        Begin
             err:='WriteProperties error';
             Goto ex;  //Some Error
        End;

        //Write Components that are owned by the Object
        If Not WriteObjectComponents(SCUStream,SCUResStream,Child) Then
        Begin
             err:='WriteObjectComponents error';
             Goto ex;
        End;

        //Write Extra Data For that Component
        If Not Child.WriteSCUResource(SCUResStream) Then
        Begin
             err:='WriteSCUResource error';
             Goto ex;
        End;
        If SCUStream.Write(Zero,4)=0 Then Goto ex; {no more resources}

        SCUWriteError := False;

        Inc(FWriteComponentCount);

        Ok:=True;
     Except
        err:=err+' due to exception';
     End;
ex:
     If Not Ok Then
     Begin
          Raise ESCUError.Create('SCU write error for '+Child.ClassName+': '+err);
     End;
End;


Procedure TComponent.WriteToStream(SCUStream:TStream);
Const Zero:LongInt=0;
Var  Stream:TMemoryStream;
     ResourceStream:TResourceStream;
     P,p1,pParent:^LongInt;
     FileDesc:TSCUFileFormat;
Begin
     Stream.Create;
     Stream.Capacity:=32768;

     ResourceStream.Create;
     ResourceStream.Capacity:=32768;
     ResourceStream.SCUStream:=Stream;
     ResourceStream.FHeaderPos:=8;    {Initial Resource Header}

     NameTable.Create; {wo zerst”rt??}

     FillChar(FileDesc,SizeOf(TSCUFileFormat),0);
     FileDesc.Version:=SCUVersion;
     If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then  //SCU Header
       Raise ESCUError.Create('Stream write error');

     FileDesc.ObjectOffset:=Stream.Position;
     FileDesc.ObjectCount:=1;      //Count Of Objects

     P:=Pointer(Self);
     P:=Pointer(P^);               //VMT Info

     Inc(P,4);
     P:=Pointer(P^);               //ClassInfo
     p1:=P;
     Inc(P,4);
     pParent:=Pointer(P^);         //parent Class VMT Or Nil
     Inc(P,8);
     P:=Pointer(P^);               //Property Pointer

     Inc(p1,16);                   //onto ClassName

     If Not WriteProperties(Stream,P,Self,pParent) Then
       Raise ESCUError.Create('WriteProperties failed');

     //Write Components that are owned by the Object
     If Not WriteObjectComponents(Stream,ResourceStream,Self) Then
       Raise ESCUError.Create('WriteObjectComponents failed');

     If Not WriteSCUResource(ResourceStream) Then
         Raise ESCUError.Create('WriteSCUResource failed');
     If Stream.Write(Zero,4)=0 Then
         Raise ESCUError.Create('Stream Write Error'); {no more resources}

     FileDesc.ObjectLen:=Stream.Position-FileDesc.ObjectOffset;

     //patch Name Table
     FileDesc.NameTableOffset:=Stream.Position;
     If Not WriteNameTable(Stream) Then
       Raise ESCUError.Create('Stream write error');
     FileDesc.NameTableLen:=Stream.Position-FileDesc.NameTableOffset;

     FileDesc.ResourceOffset:=Stream.Position;
     {Write Resource information}
     If Not ResourceStream.WriteResourcesToStream(Stream) Then
       Raise ESCUError.Create('Stream write error');
     ResourceStream.Destroy;
     FileDesc.ResourceLen:=Stream.Position-FileDesc.ResourceOffset;

     Stream.Position:=0;    //patch Header
     If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then
       Raise ESCUError.Create('Stream write error');

     //Copy Stream
     SCUStream.WriteBuffer(Stream.FBuffer^,Stream.FSize);
     Stream.Destroy;
End;

Procedure TComponent.ReadSCU(Data:Pointer);
Var
   ClassPointer,P,p1:^LongWord;
   dummy:PSCUFileFormat;
   NameTable:^LongWord;
   ResourceTable:^LongWord;
   ActComponentClass:TComponentClass;
   S,s1:String;
   ObjectCount:LongInt;
   ps:^String;
   OldInsideDesigner:Boolean;
   LanguageInfo:^LongWord;
   MessageInfo:^LongWord;
   Flags:Byte;
   T:LongInt;
   CurrentLanguage:String;
   LangItem:PLanguageItem;
   Msgs:PLanguageMessages;
   MsgLen:LongWord;

   Procedure ReadLanguage(Var Components:PLanguageComponent);
   Var
      LangComp:PLanguageComponent;
      ps:^String;
   Begin
        Components:=Nil;

        While (LanguageInfo^ And 255)<>0 Do //Read All Components entries
        Begin
             Inc(LanguageInfo);  //skip 1

             If Components=Nil Then
             Begin
                  New(Components);
                  LangComp:=Components;
             End
             Else
             Begin
                  LangComp:=Components;
                  While LangComp^.Next<>Nil Do LangComp:=LangComp^.Next;
                  New(LangComp^.Next);
                  LangComp:=LangComp^.Next;
             End;
             LangComp^.Next:=Nil;

             ps:=Pointer(LanguageInfo);
             GetMem(LangComp^.Name,Length(ps^)+1);
             LangComp^.Name^:=ps^;
             Inc(LanguageInfo,Length(ps^)+1);

             LangComp^.ValueTyp:=LanguageInfo^ And 255;
             Inc(LanguageInfo);

             LangComp^.ValueLen:=LanguageInfo^;
             Inc(LanguageInfo,4);

             GetMem(LangComp^.Value,LangComp^.ValueLen);
             Move(LanguageInfo^,LangComp^.Value^,LangComp^.ValueLen);
             Inc(LanguageInfo,LangComp^.ValueLen);

             LangComp^.ControlLeft:=LanguageInfo^;
             Inc(LanguageInfo,4);
             LangComp^.ControlBottom:=LanguageInfo^;
             Inc(LanguageInfo,4);
             LangComp^.ControlWidth:=LanguageInfo^;
             Inc(LanguageInfo,4);
             LangComp^.ControlHeight:=LanguageInfo^;
             Inc(LanguageInfo,4);
        End;
        Inc(LanguageInfo);  //skip 0
   End;

Label loadit,Next,skip;
Begin
     OldInsideDesigner:=InsideDesigner;
     dummy:=Data;
     PropertyLinks:=Nil;
     MessageInfo:=NIL;
     LanguageInfo:=NIL;

     While dummy<>Nil Do
     Begin
          NameTable:=Pointer(dummy);
          Inc(NameTable,dummy^.NameTableOffset);
          ResourceTable:=Pointer(dummy);
          Inc(ResourceTable,dummy^.ResourceOffset);

          P:=Pointer(dummy);
          Inc(P,dummy^.ObjectOffset);

          S:=ClassName;
          UpcaseStr(S);
          If ((((InsideDesigner)Or(InsideLanguageDesigner)))And(S='TFORMEDITOR')) Then
          Begin
               //always Use the Class entry defined by dummy^.UseEntry !
               p1:=Pointer(dummy);
               Inc(p1,SizeOf(TSCUFileFormat));
               ObjectCount:=0;
               LanguageInfo:=Nil;
               MessageInfo:=Nil;
               While ObjectCount<>dummy^.UseEntry+1 Do
               Begin
                    Flags:=p1^ And 255;  //1- auto Create, 2- Language Info avail
                    Inc(p1);                  //skip flag
                    Inc(p1,(p1^ And 255)+1);  //skip Form Name
                    Inc(p1,(p1^ And 255)+1);  //skip Form Unit Name
                    Inc(p1,(p1^ And 255)+1);  //skip Form TypeName
                    //If Message information Is available For This Form (only For First) remember And skip it !
                    If (Flags And 8)<>0 Then
                    Begin
                         MessageInfo:=Pointer(p1);
                         Inc(p1,p1^);
                    End;
                    //If Language information Is available For This Form, remember And skip
                    LanguageInfo:=Pointer(p1);
                    If Flags And 2<>0 Then Inc(p1,p1^);  //skip Language Info
                    Inc(ObjectCount);
               End;

               If (Flags And 2)=0 Then LanguageInfo:=Nil;  //no languages avail
               If (Flags And 4)<>0 Then LanguageInfo:=Nil; //locked !!

               ObjectCount:=0;
               While ObjectCount<>dummy^.UseEntry Do
               Begin
                    Inc(P,{4+}P^);        //overread This entry
                    Inc(ObjectCount);
               End;

               ClassPointer:=P;
               Inc(P,4);              //Set ON Inspector Class Name
               Inc(P,(P^ And 255)+1); //overread Inspector Name
               Inc(P,(P^ And 255)+1); //overread runtime Class Name
               ps:=Pointer(P);        //Unit Name For This Form
               AssignStr(FUnitName,ps^);
               Goto loadit;
          End
          Else
          Begin
              //don't Read any Classes when inside designer !
              //If (InsideDesigner And (Not InsideCompLib)) Then Exit;
              If InsideCompLib Then InsideDesigner:=False;

              //Search For Class named S inside area P With dummy^.ObjectCount
              //entries And Set ClassPointer To Object Data Start
              //Use also ClassUnit For Reference
              ClassPointer:=SearchClassSCU(P,S,dummy^.ObjectCount,ClassUnit);
              If ClassPointer=Nil Then Goto Next;  //no Class found

              //look If Language Info Is avail
              p1:=Pointer(dummy);
              Inc(p1,SizeOf(TSCUFileFormat));
              For T:=1 To dummy^.ObjectCount Do
              Begin
                   Flags:=p1^ And 255;
                   Inc(p1);                  //skip flag
                   Inc(p1,(p1^ And 255)+1);  //skip Form Name
                   Inc(p1,(p1^ And 255)+1);  //skip Form Unit Name
                   If (Flags And 2)<>0 Then //Language Info avail ???
                   Begin
                        ps:=Pointer(p1);
                        Inc(p1,(p1^ And 255)+1);  //skip Form Type Name

                        //If Message information Is available For This Form (only For First) skip it !
                        If (Flags And 8)<>0 Then Inc(p1,p1^);

                        s1:=ps^;
                        UpcaseStr(s1);
                        If S=s1 Then //found !
                        Begin
                             LanguageInfo:=Pointer(p1);
                             If (Flags And 4)<>0 Then LanguageInfo:=Nil; //locked !!
                             Goto loadit;
                        End
                        Else Inc(p1,p1^); //only skip Info
                   End
                   Else
                   Begin
                        Inc(p1,(p1^ And 255)+1);  //skip Form Type Name
                        //If Message information Is available For This Form (only For First) skip it !
                        If (Flags And 8)<>0 Then Inc(p1,p1^);
                   End;
              End;
              LanguageInfo:=Nil; //Not found
loadit:
              Inc(ClassPointer,4);                         //Set ON Inspector Class Name
              Inc(ClassPointer,(ClassPointer^ And 255)+1); //overread Inspector Name
              Inc(ClassPointer,(ClassPointer^ And 255)+1); //overread runtime Class Name
              Inc(ClassPointer,(ClassPointer^ And 255)+1); //overread Unit Name

              ActComponentClass:=ClassType;
              RegisterClasses([ActComponentClass]);  //Form registrieren
              If ((InsideDesigner)Or(InsideLanguageDesigner)) Then
              Begin
                   FMethods:=Nil;  //no Methods defined
              End;

              LastSCUForm:=Self;

              LoadingFromSCU(Nil);

              //Build Message lists
              If MessageInfo<>Nil Then
              Begin
                   Inc(MessageInfo,4);  //skip Size

                   ps:=Pointer(MessageInfo);
                   AppLanguage:=ps^;
                   Inc(MessageInfo,Length(ps^)+1);

                   ps:=Pointer(MessageInfo);
                   While Length(ps^)<>0 Do
                   Begin

                        //look If the Language Is installed, skip If True
                        If LanguageMessages=Nil Then
                        Begin
                             New(LanguageMessages);
                             Msgs:=LanguageMessages;
                        End
                        Else
                        Begin
                             Msgs:=LanguageMessages;
                             While Msgs^.Next<>Nil Do
                             Begin
                                  If Msgs^.Name^=ps^ Then
                                  Begin
                                       Inc(MessageInfo,Length(ps^));
                                       MsgLen:=MessageInfo^;
                                       Inc(MessageInfo,4);
                                       Inc(MessageInfo,MsgLen);
                                       Goto skip;
                                  End;
                                  Msgs:=Msgs^.Next;
                             End;
                             If Msgs^.Name^=ps^ Then
                             Begin
                                  Inc(MessageInfo,Length(ps^)+1);
                                  MsgLen:=MessageInfo^;
                                  Inc(MessageInfo,4);
                                  Inc(MessageInfo,MsgLen);
                                  Goto skip;
                             End;
                             New(Msgs^.Next);
                             Msgs:=Msgs^.Next;
                        End;

                        GetMem(Msgs^.Name,Length(ps^)+1);
                        Msgs^.Name^:=ps^;
                        Inc(MessageInfo,Length(ps^)+1);
                        Msgs^.StringTableLen:=MessageInfo^;
                        Inc(MessageInfo,4);
                        GetMem(Msgs^.StringTable,Msgs^.StringTableLen);
                        Move(MessageInfo^,Msgs^.StringTable^,Msgs^.StringTableLen);
                        Inc(MessageInfo,Msgs^.StringTableLen);
skip:
                        ps:=Pointer(MessageInfo);
                   End;
              End;

              //Build Language lists
              If LanguageInfo<>Nil Then
              Begin
                   Inc(LanguageInfo,4);  //skip Size
                   GetMem(FLanguages,SizeOf(TLanguageInfo));
                   ps:=Pointer(LanguageInfo);
                   CurrentLanguage:=ps^;  //To determine Language !
                   Inc(LanguageInfo,Length(CurrentLanguage)+1);

                   While (LanguageInfo^ And 255)<>0 Do //Read All entries
                   Begin
                        Inc(LanguageInfo);  //skip 1

                        If PLanguageInfo(FLanguages)^.Items=Nil Then
                        Begin
                             New(LangItem);
                             PLanguageInfo(FLanguages)^.Items:=LangItem;
                        End
                        Else
                        Begin
                             LangItem:=PLanguageInfo(FLanguages)^.Items;
                             While LangItem^.Next<>Nil Do LangItem:=LangItem^.Next;
                             New(LangItem^.Next);
                             LangItem:=LangItem^.Next;
                        End;

                        LangItem^.Next:=Nil;

                        ps:=Pointer(LanguageInfo);
                        GetMem(LangItem^.Name,Length(ps^)+1);
                        LangItem^.Name^:=ps^;
                        Inc(LanguageInfo,Length(ps^)+1);

                        ReadLanguage(LangItem^.Components);
                        ReadLanguage(LangItem^.Menus);
                        ReadLanguage(LangItem^.StringTables);
                   End; //While
                   Inc(LanguageInfo); //skip 0

                   If PLanguageInfo(FLanguages)^.Items=Nil Then //no Items
                   Begin
                        FreeMem(FLanguages,SizeOf(TLanguageInfo));
                        FLanguages:=Nil;
                   End
                   Else
                   Begin
                       //Set Current Language into Form^.LanguageInfo
                       LangItem:=PLanguageInfo(FLanguages)^.Items;
                       While LangItem<>Nil Do
                       Begin
                            If LangItem^.Name^=CurrentLanguage Then //found
                            Begin
                             PLanguageInfo(FLanguages)^.CurrentLanguageName:=LangItem^.Name;
                             PLanguageInfo(FLanguages)^.CurrentLanguageComponents:=LangItem^.Components;
                             PLanguageInfo(FLanguages)^.CurrentLanguageMenus:=LangItem^.Menus;
                             PLanguageInfo(FLanguages)^.CurrentLanguageStringTables:=LangItem^.StringTables;
                             break;
                            End;
                            LangItem:=LangItem^.Next;
                       End;

                       If PLanguageInfo(FLanguages)^.CurrentLanguageName=Nil Then
                       Begin
                           //Not found - Use First available Language
                           LangItem:=PLanguageInfo(FLanguages)^.Items;
                           PLanguageInfo(FLanguages)^.CurrentLanguageName:=LangItem^.Name;
                           PLanguageInfo(FLanguages)^.CurrentLanguageComponents:=LangItem^.Components;
                           PLanguageInfo(FLanguages)^.CurrentLanguageMenus:=LangItem^.Menus;
                           PLanguageInfo(FLanguages)^.CurrentLanguageStringTables:=LangItem^.StringTables;
                       End;
                   End;
              End;

              If Not ReadPropertiesSCU(Self,NameTable,ResourceTable,ClassPointer) Then
              Begin
                   InsideDesigner:=OldInsideDesigner;
                   Raise ESCUError.Create('ReadPropertiesSCU error');
              End;

              SetDesigning(InsideDesigner Or InsideLanguageDesigner);

              //check For Child Components
              If Not ReadComponentsSCU(NameTable,ResourceTable,ClassPointer) Then
              Begin
                   InsideDesigner:=OldInsideDesigner;
                   Raise ESCUError.Create('ReadComponentsSCU error');
              End;

              //links For the Form
              HandlePropertyLinks(Self);

              ReadResourceSCU(ResourceTable,ClassPointer);

              If FLanguages<>Nil Then
                If PLanguageInfo(FLanguages)^.CurrentLanguageName<>Nil Then
                   SetLanguage(Self,PLanguageInfo(FLanguages)^.CurrentLanguageName^);

              //If there's only the Default Language Left, Erase it !
              If FLanguages<>Nil Then
                If PLanguageInfo(FLanguages)^.Items<>Nil Then
                  If PLanguageInfo(FLanguages)^.Items^.Next=Nil Then
                    If PLanguageInfo(FLanguages)^.Items^.Name^='Default' Then
              Begin
                   FreeLanguage(PLanguageInfo(FLanguages)^.Items^.Components);
                   FreeLanguage(PLanguageInfo(FLanguages)^.Items^.Menus);
                   FreeLanguage(PLanguageInfo(FLanguages)^.Items^.StringTables);
                   FreeMem(PLanguageInfo(FLanguages)^.Items^.Name,Length(PLanguageInfo(FLanguages)^.Items^.Name^)+1);
                   Dispose(PLanguageInfo(FLanguages)^.Items);
                   FreeMem(FLanguages,SizeOf(TLanguageInfo));
                   FLanguages:=Nil;
              End;

              {For the Form}
              LoadedFromSCU(Nil);
              Loaded;

              InsideDesigner:=OldInsideDesigner;
              Exit;
         End;
Next:
         dummy:=dummy^.NextEntry;
     End;

     InsideDesigner:=OldInsideDesigner;
End;


Procedure TComponent.ReadFromStream(SCUStream:TStream);
Var
    ClassMem,ClassPointer:^LongWord;
    OldPos:LongInt;
    OldInsideDesigner:Boolean;
    FileDesc:TSCUFileFormat;
    len:LongInt;
    NameTable:^LongWord;
    ResourceTable:^LongWord;
Begin
     Try
       ClassPointer:=Nil;
       OldInsideDesigner:=InsideDesigner;
       If InsideCompLib Then InsideDesigner:=False;

       OldPos:=SCUStream.Position;
       SCUStream.ReadBuffer(FileDesc,SizeOf(FileDesc));
       SCUStream.Position:=OldPos;

       len:=SizeOf(FileDesc)+FileDesc.ObjectLen+FileDesc.NameTableLen+FileDesc.ResourceLen;
       GetMem(ClassPointer,len);
       ClassMem:=ClassPointer;
       SCUStream.ReadBuffer(ClassPointer^,len);

       NameTable:=Pointer(ClassPointer);
       Inc(NameTable,FileDesc.NameTableOffset);
       ResourceTable:=Pointer(ClassPointer);
       Inc(ResourceTable,FileDesc.ResourceOffset);
       Inc(ClassPointer,FileDesc.ObjectOffset);

       LastSCUForm:=Owner;
       SetDesigning(InsideDesigner Or InsideLanguageDesigner);
       LoadingFromSCU(LastSCUForm);

       If Not ReadPropertiesSCU(LastSCUForm,NameTable,ResourceTable,ClassPointer) Then
         Raise ESCUError.Create('SCU error');
       If Not ReadComponentsSCU(NameTable,ResourceTable,ClassPointer) Then
         Raise ESCUError.Create('SCU error');
       ReadResourceSCU(ResourceTable,ClassPointer);

       LoadedFromSCU(LastSCUForm);
     Finally
       InsideDesigner:=OldInsideDesigner;
       If ClassMem<>Nil Then FreeMem(ClassMem,len);
     End;
End;


{$HINTS OFF}
Procedure TComponent.GetChildren(Proc:TGetChildProc);
Begin
End;
{$HINTS ON}


Function TComponent.HasParent:Boolean;
Begin
     Result := False;
End;

Function WritePropertiesToStream(FormList:TList):TMemoryStream;
Const Zero:LongInt=0;
      bt:Byte=1;
      bf:Byte=0;
Var  P,p1:^LongInt;
     pParent:^LongInt;
     S:String;
     tt,tt1,Pos1:LongInt;
     FormItem:PFormListItem;
     Stream:TMemoryStream;
     ResourceStream:TResourceStream;
     FileDesc:TSCUFileFormat;
     C:TComponent;
     D,N,E:String;
     bb:Byte;
     LangItem:PLanguageItem;
     LangPos,LangTemp:LongInt;
     dummy:PLanguageMessages;

     Function WriteLanguage(LangComp:PLanguageComponent):Boolean;
     Var Ende:Byte;
     Begin
          Result:=False;
          While LangComp<>Nil Do
          Begin
               If Stream.Write(bt,1)=0 Then Exit; //one more entry
               If Stream.Write(LangComp^.Name^,Length(LangComp^.Name^)+1)=0 Then Exit;
               If Stream.Write(LangComp^.ValueTyp,1)=0 Then Exit;
               If Stream.Write(LangComp^.ValueLen,4)=0 Then Exit;
               If Stream.Write(LangComp^.Value^,LangComp^.ValueLen)=0 Then Exit;

               If Stream.Write(LangComp^.ControlLeft,4)=0 Then Exit;
               If Stream.Write(LangComp^.ControlBottom,4)=0 Then Exit;
               If Stream.Write(LangComp^.ControlWidth,4)=0 Then Exit;
               If Stream.Write(LangComp^.ControlHeight,4)=0 Then Exit;

               LangComp:=LangComp^.Next;
          End;

          Ende:=0;
          If Stream.Write(Ende,1)=0 Then Exit; //no more entries
          Result:=True;
     End;

Label err;
Begin
     Result:=Nil;  //Some Error

     Stream.Create;
     Stream.Capacity:=32768;

     ResourceStream.Create;
     ResourceStream.Capacity:=32768;
     ResourceStream.SCUStream:=Stream;
     ResourceStream.FHeaderPos:=8;    {Initial Resource Header}

     NameTable.Create;

     FillChar(FileDesc,SizeOf(TSCUFileFormat),0);
     FileDesc.Version:=SCUVersion;
     If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then  //SCU Header
     Begin
err:
          Stream.Destroy;
          ResourceStream.Destroy;
          Result:=Nil;
          Exit;  //Some Error
     End;

     Try
        For tt:=0 To FormList.Count-1 Do
        Begin
             FormItem:=FormList.Items[tt];
             C:=Pointer(FormItem^.Form);
             If C = Nil Then Goto err; {need Form}

             bb:=0;

             If C.DesignerState*[dsAutoCreate]<>[] Then bb:=bb Or 1; //auto-created Form
             If C.FLanguages<>Nil Then bb:=bb Or 2;                  //Multi Language
             //!!!!!!!!!! 4 Is reserved For locking Language !!!!!!!!!!!!!!!!!!!

             //note: Messages are global To an Application, Not To A Form !!!!
             If ((tt=0)And(LanguageMessages<>Nil)) Then bb:=bb Or 8; //Messages avail

             If Stream.Write(bb,1)=0 Then Goto err;

             S:=FormItem^.FormName+#0;
             UpcaseStr(S);
             If Stream.Write(S,Length(S)+1)=0 Then Goto err;
             S:=FormItem^.UnitName;
             FSplit(S,D,N,E);
             N:=N+#0;
             UpcaseStr(N);
             If Stream.Write(N,Length(N)+1)=0 Then Goto err;
             If FormItem^.FormName<>'' Then S:='T'+FormItem^.FormName
             Else S:=FormItem^.Form.ClassName;
             If Stream.Write(S,Length(S)+1)=0 Then Goto err; //runtime Class Name

             //Language Messages are only evaluated by Application.Create by examining the SCU Pointer !!!
             If ((tt=0)And(LanguageMessages<>Nil)) Then
             Begin
                  //Write Language Message information
                  LangPos:=Stream.Position;  //save Position
                  If Stream.Write(LangPos,4)=0 Then Goto err; //Size: patched later

                  If Stream.Write(AppLanguage,Length(AppLanguage)+1)=0 Then Goto err;

                  dummy:=LanguageMessages;
                  While dummy<>Nil Do
                  Begin
                      If Stream.Write(dummy^.Name^,Length(dummy^.Name^)+1)=0 Then Goto err;
                      If Stream.Write(dummy^.StringTableLen,4)=0 Then Goto err;
                      If dummy^.StringTableLen>0 Then
                        If Stream.Write(dummy^.StringTable^,dummy^.StringTableLen)=0 Then Goto err;
                      dummy:=dummy^.Next;
                  End;
                  If Stream.Write(bf,1)=0 Then Goto err; //no more entries
                  LangTemp:=Stream.Position;
                  Stream.Position:=LangPos;  //patch Size
                  LangPos:=LangTemp-LangPos;
                  If Stream.Write(LangPos,4)=0 Then Goto err;
                  Stream.Position:=LangTemp; //restore old Position
             End;

             If C.FLanguages<>Nil Then
             Begin
                  //Write Language information
                  LangPos:=Stream.Position;  //save Position
                  If Stream.Write(LangPos,4)=0 Then Goto err; //Size: patched later

                  If PLanguageInfo(C.FLanguages)^.CurrentLanguageName<>Nil Then
                  Begin
                      If Stream.Write(PLanguageInfo(C.FLanguages)^.CurrentLanguageName^,
                                      Length(PLanguageInfo(C.FLanguages)^.CurrentLanguageName^)+1)=0 Then Goto err;
                  End
                  Else
                  Begin
                      S:='Default';
                      If Stream.Write(S,Length(S)+1)=0 Then Goto err;
                  End;

                  LangItem:=PLanguageInfo(C.FLanguages)^.Items;

                  While LangItem<>Nil Do
                  Begin
                       If Stream.Write(bt,1)=0 Then Goto err; //one more entry
                       If Stream.Write(LangItem^.Name^,Length(LangItem^.Name^)+1)=0 Then Goto err;

                       If Not WriteLanguage(LangItem^.Components) Then Goto err;
                       If Not WriteLanguage(LangItem^.Menus) Then Goto err;
                       If Not WriteLanguage(LangItem^.StringTables) Then Goto err;

                       LangItem:=LangItem^.Next;
                  End;

                  If Stream.Write(bf,1)=0 Then Goto err; //no more entries

                  LangTemp:=Stream.Position;
                  Stream.Position:=LangPos;  //patch Size
                  LangPos:=LangTemp-LangPos;
                  If Stream.Write(LangPos,4)=0 Then Goto err;
                  Stream.Position:=LangTemp; //restore old Position
             End;
        End;

        FileDesc.ObjectOffset:=Stream.Position;
        FileDesc.ObjectCount:=FormList.Count;    //Count Of Objects

        For tt:=0 To FormList.Count-1 Do
        Begin
             Pos1:=Stream.Position;

             tt1:=0;
             If Stream.Write(tt1,4)=0 Then Goto err;  //Length Of Object Info
                                                      //- patched later

             FormItem:=FormList.Items[tt];
             P:=Pointer(FormItem^.Form);
             P:=Pointer(P^);               //VMT Info

             Inc(P,4);
             P:=Pointer(P^);               //ClassInfo
             p1:=P;
             Inc(P,4);
             pParent:=Pointer(P^);         //parent Class VMT Or Nil
             Inc(P,8);
             P:=Pointer(P^);               //Property Pointer

             Inc(p1,16);                   //onto ClassName
             Move(p1^,S,(p1^ And 255)+1);  //Inspector Class Name
             If Stream.Write(S,Length(S)+1)=0 Then Goto err; //Inspector Class Name

             If FormItem^.FormName<>'' Then S:='T'+FormItem^.FormName
             Else S:=FormItem^.Form.ClassName;
             If Stream.Write(S,Length(S)+1)=0 Then Goto err; //runtime Class Name
             If Stream.Write(FormItem^.UnitName,Length(FormItem^.UnitName)+1)=0 Then Goto err;

             If Not WriteProperties(Stream,P,TComponent(FormItem^.Form),pParent) Then Goto err;

             //Write Components that are owned by the Object
             If Not WriteObjectComponents(Stream,ResourceStream,TComponent(FormItem^.Form)) Then Goto err;

             If Not FormItem^.Form.WriteSCUResource(ResourceStream) Then Goto err;
             If Stream.Write(Zero,4)=0 Then Goto err; {no more resources}


             tt1:=Stream.Position;
             Stream.Position:=Pos1;
             Pos1:=tt1-Pos1;
             Stream.Write(Pos1,4);  //patch len Of Object Info For This entry
             Stream.Position:=tt1;
        End; //For

        FileDesc.ObjectLen:=Stream.Position-FileDesc.ObjectOffset;

        //patch Name Table
        FileDesc.NameTableOffset:=Stream.Position;
        If Not WriteNameTable(Stream) Then Goto err;
        FileDesc.NameTableLen:=Stream.Position-FileDesc.NameTableOffset;

        FileDesc.ResourceOffset:=Stream.Position;
        {Write Resource information}
        If Not ResourceStream.WriteResourcesToStream(Stream) Then Goto err;
        ResourceStream.Destroy;
        FileDesc.ResourceLen:=Stream.Position-FileDesc.ResourceOffset;
        {ab hier nichts mehr schreiben, sonst System.AddSCUData ndern}

        tt:=Stream.Position;   //save Position
        Stream.Position:=0;    //patch Header
        If Stream.Write(FileDesc,SizeOf(TSCUFileFormat))=0 Then Goto err;
        Stream.Position:=tt;   //restore Position
     Except
         ON ex:Exception Do
         Begin
             ErrorBox2(ex.Message);
             Stream.Destroy;
             ResourceStream.Destroy;
             Stream:=Nil;
         End;
     End;
     Result:=Stream;
End;


Function WritePropertiesToFile(FileName:String;FormList:TList):Boolean;
Var Stream:TMemoryStream;
Begin
     Stream:=WritePropertiesToStream(FormList);
     If Stream=Nil Then
     Begin
          Result:=False;
          Exit;
     End;

     Result:=True;
     Try
        Stream.SaveToFile(FileName);
     Except
        ON ex:Exception Do
        Begin
             ErrorBox2(ex.Message);
             Result:=False;
        End;
     End;

     Stream.Destroy;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TStringItem Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TStringSelectList.SetupComponent;
Begin
     Inherited SetupComponent;
     FList.Create;
     FList.sorted:=True;
     Include(ComponentState, csDetail);
End;

Procedure TStringSelectList.SetStringItem(NewValue:String);
Begin
     FSelected:=NewValue;
End;

Destructor TStringSelectList.Destroy;
Begin
     FList.Destroy;
     FList := Nil;
     Inherited Destroy;
End;

Function TStringSelectList.GetItems:TStringList;
Begin
     Result:=FList;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBits Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Destructor TBits.Destroy;
Begin
  FreeMem(FBits, (FSize + 31) Shr 5);
  FBits := Nil;
  Inherited Destroy;
End;

Procedure TBits.Error;
Begin
  Raise EBitsError.Create(LoadNLSStr(SEBitsErrorText));
End;

Function TBits.GetBit(Index: LongInt): Boolean;
Var
  Place: Cardinal;
Begin
  If (Index < 0) Or (Index >= FSize) Then Error;
  Place := 1 Shl (Index And 31);
  Index := Index Shr 5;
  Result := (FBits^[Index] And Place) <> 0;
End;

Function TBits.OpenBit: LongInt;
Var
  I, J, K: LongInt;
  B: Cardinal;
Begin
  I := 0;
  J := (FSize + 31) Shr 5;
  While (I < J) And (FBits^[I] = 0) Do Inc(I);
  If I < J Then
  Begin
    K := 1;
    Result := I Shl 5;
    B := FBits^[I];
    While (B And K) = 0 Do
    Begin
      K := K Shl 1;
      Inc(Result);
    End;
    If Result >= FSize Then Result := -1;
  End
  Else Result := -1;
End;

Procedure TBits.SetBit(Index: LongInt; bit: Boolean);
Var
  Place: Cardinal;
Begin
  If (Index < 0) Or (Index >= FSize) Then Error;
  Place := 1 Shl (Index And 31);
  Index := Index Shr 5;
  If bit Then FBits^[Index] := FBits^[Index] Or Place
  Else FBits^[Index] := FBits^[Index] And Not Place;
End;

Procedure TBits.SetSize(NewSize: LongInt);
Begin
  If NewSize < 0 Then Error;
  If FSize = 0 Then FBits := AllocMem((NewSize + 31) Shr 3)
  Else FBits := ReAllocMem(FBits, (FSize + 31) Shr 3, (NewSize + 31) Shr 3);
  FSize := NewSize;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPropertyEditClassDialog Class Implementation               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    PPropertyEditClassItem=^TPropertyEditClassItem;
    TPropertyEditClassItem=Record
         ClassToEdit: TClass;                            //Editor Class (Class editors) Or parent Class (others)
         PropertyName:String[64];                        //Property Name For normal editors
         ClassPropertyEditor: TClassPropertyEditorClass; //<>Nil For Class Property editors
         PropertyEditor:TPropertyEditorClass;            //<>Nil For normal Property editors
    End;


{$HINTS OFF}
Function TClassPropertyEditor.Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Begin
     Result:=peCancel;  //Not Handled
End;
{$HINTS ON}

Procedure AddPropertyEditor(OwnerClass:TClass;PropertyName:String;PropertyEditor:TPropertyEditorClass);
Var T:LongInt;
    dummy:PPropertyEditClassItem;
Begin
     UpcaseStr(PropertyName);

     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
            If OwnerClass=dummy^.ClassToEdit Then
              If dummy^.PropertyName=PropertyName Then
              Begin
                  //replace existing
                  dummy^.PropertyEditor:=PropertyEditor;
                  Exit;
              End;
     End;

     New(dummy);
     dummy^.ClassToEdit:=OwnerClass;
     dummy^.PropertyName:=PropertyName;
     dummy^.PropertyEditor:=PropertyEditor;
     PropertyEditDialogs.Add(dummy);
End;

Function CallPropertyEditor(Owner:TComponent;PropertyName:String;Var Value;ValueLen:LongInt;
                            Var List:TStringList):TPropertyEditorReturn;
Var T:LongInt;
    dummy:PPropertyEditClassItem;
    Editor:TPropertyEditor;
    S:String;
Label go;
Begin
     Result:=edNoEditor;
     UpcaseStr(PropertyName);

     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
            If Owner.ClassType=dummy^.ClassToEdit Then
              If dummy^.PropertyName=PropertyName Then
              Begin
go:
                   Editor:=dummy^.PropertyEditor.Create(Nil);
                   Editor.FOwner:=Owner;
                   Editor.FPropertyName:=PropertyName;
                   List.Create;
                   Editor.FList:=List;
                   Try
                     If Editor Is TStringPropertyEditor Then
                     Begin
                          System.Move(Value,S,ValueLen);
                          Result:=TStringPropertyEditor(Editor).Execute(S,ValueLen);
                          System.Move(S,Value,ValueLen);
                     End
                     Else If Editor Is TShortIntPropertyEditor Then
                       Result:=TShortIntPropertyEditor(Editor).Execute(ShortInt(Value))
                     Else If Editor Is TIntegerPropertyEditor Then
                       Result:=TIntegerPropertyEditor(Editor).Execute(Integer(Value))
                     Else If Editor Is TLongIntPropertyEditor Then
                       Result:=TLongIntPropertyEditor(Editor).Execute(LongInt(Value))
                     Else Result:=Editor.Execute(Value,ValueLen);
                     List:=Editor.FList;
                     Editor.Destroy;
                   Except
                     Result:=edNoEditor;
                   End;

                   Exit;
              End;
     End;

     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
            If Owner Is dummy^.ClassToEdit Then
              If dummy^.PropertyName=PropertyName Then
              Begin
                   Goto go;
              End;
     End;

     {Search In registered Property editors Of the complib}
     If @CallCompLibPropertyEditor<>Nil
     Then Result := CallCompLibPropertyEditor(Owner,PropertyName,Value,ValueLen,List);
End;

Function PropertyEditorAvailable(OwnerClass:TClass;PropertyName:String):Boolean;
Var T:LongInt;
    dummy:PPropertyEditClassItem;
Begin
     Result:=False;
     UpcaseStr(PropertyName);

     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.PropertyEditor<>Nil Then //normal Property Editor ??
            If dummy^.PropertyName=PropertyName Then
              If OwnerClass Is dummy^.ClassToEdit Then
              Begin
                  Result:=True;
                  Exit;
              End;
     End;

     If @CallCompLibPropertyEditorAvailable<>Nil Then
        Result:=CallCompLibPropertyEditorAvailable(OwnerClass,PropertyName);
End;


Procedure AddClassPropertyEditor(ClassToEdit:TClass;PropertyEditor:TClassPropertyEditorClass);
Var T:LongInt;
    dummy:PPropertyEditClassItem;
Begin
     For T:=0 To PropertyEditDialogs.Count-1 Do
     Begin
          dummy:=PropertyEditDialogs.Items[T];

          If dummy^.ClassPropertyEditor<>Nil Then //Class Property Editor ??
            If dummy^.ClassToEdit=ClassToEdit Then
            Begin
                 //replace existing
                 dummy^.ClassPropertyEditor:=PropertyEditor;
                 Exit;
            End;
     End;

     New(dummy);
     dummy^.ClassToEdit:=ClassToEdit;
     dummy^.ClassPropertyEditor:=PropertyEditor;
     PropertyEditDialogs.Add(dummy);
End;

Function ClassPropertyEditorAvailable(ClassName:String):Boolean;
Var
    s1:String;
    AOwner:TClass;

    Function process(Const s1:String):Boolean;
    Var T:LongInt;
        dummy:PPropertyEditClassItem;
        S:String;
    Begin
         Result:=False;

         For T:=0 To PropertyEditDialogs.Count-1 Do
         Begin
              dummy:=PropertyEditDialogs.Items[T];

              If dummy^.ClassPropertyEditor<>Nil Then //Class Property Editor ???
              Begin
                   S:=dummy^.ClassToEdit.ClassName;
                   UpcaseStr(S);
                   If S=s1 Then
                   Begin
                        Result:=True;
                        Exit;
                   End;
              End;
         End;
    End;

Label L,ex;
Begin
     Result:=False;
     s1:=ClassName;
     UpcaseStr(s1);
     If process(s1) Then
     Begin
          Result:=True;
          Exit;
     End;

     //check If it Is Some derived Object
     AOwner:=SearchClassByName(ClassName);
     If AOwner=Nil Then goto ex;
L:
     AOwner:=AOwner.ClassParent;

     If AOwner<>Nil Then
     Begin
          s1:=AOwner.ClassName;
          UpcaseStr(s1);
          If process(s1) Then Result:=True
          Else Goto L;
     End;

ex:
     If @CallComplibClassPropertyEditorAvailable<>Nil Then
       Result:=Result Or CallCompLibClassPropertyEditorAvailable(ClassName);
End;

Function CallClassPropertyEditor(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Var
    s1:String;
    AOwner:TClass;
    res:TClassPropertyEditorReturn;

    Function process(Const s1:String):Boolean;
    Var T:LongInt;
        dummy:PPropertyEditClassItem;
        Editor:TClassPropertyEditor;
        S:String;
    Begin
         Result:=False;

         For T:=0 To PropertyEditDialogs.Count-1 Do
         Begin
              dummy:=PropertyEditDialogs.Items[T];

              If dummy^.ClassPropertyEditor<>Nil Then //Is it A Class Property Editor ??
              Begin
                   S:=dummy^.ClassToEdit.ClassName;
                   UpcaseStr(S);
                   If S=s1 Then
                   Begin
                       Editor:=dummy^.ClassPropertyEditor.Create(Nil);
                       res:=Editor.Execute(ClassToEdit);
                       Editor.Destroy;
                       Result:=True;
                       Exit;
                   End;
              End;
         End;
    End;
Begin
     Result:=peNoEditor;
     s1:=ClassToEdit.ClassName;

     UpcaseStr(s1);
     If process(s1) Then
     Begin
          Result:=res;
          Exit;
     End;

     {Search In registered Property editors Of the complib}
     If @CallCompLibClassPropertyEditor<>Nil
     Then Result := CallCompLibClassPropertyEditor(ClassToEdit);
     If Result<>peNoEditor Then exit;

     //check If it Is Some derived Object
     AOwner := ClassToEdit.ClassType;

     While AOwner.ClassParent <> Nil Do
     Begin
          AOwner:=AOwner.ClassParent;

          s1:=AOwner.ClassName;
          UpcaseStr(s1);
          If process(s1) Then
          Begin
               Result:=res;
               Exit;
          End;
     End;

     Result:=peNoEditor;
End;

///////////////////////////////////////////////////////////////////////////

Function GetExperts:TList;
Begin
     Result:=LibExperts;
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TThread Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TThread.SetSuspended(NewValue:Boolean);
Begin
     If NewValue Then Suspend
     Else Resume;
End;

Const
  {$IFDEF OS2}
  PArray:Array[TThreadPriority] Of LongWord=
         (PRTYC_IDLETIME,PRTYC_REGULAR,PRTYC_REGULAR,PRTYC_REGULAR,PRTYC_REGULAR,
          PRTYC_REGULAR,PRTYC_TIMECRITICAL);
  PDelta:Array[tpIdle..tpTimeCritical] Of LongWord=
         (0,-31,-16,0,16,31,0);
  {$ENDIF}
  {$IFDEF Win95}
  PArray:Array[TThreadPriority] Of LongWord=
         (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
          THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,THREAD_PRIORITY_HIGHEST,
          THREAD_PRIORITY_TIME_CRITICAL);
  {$ENDIF}

Procedure TThread.SetPriority(NewValue:TThreadPriority);
Begin
     FPriority:=NewValue;
     {$IFDEF OS2}
     If ThreadId<>0 Then DosSetPriority(2,PArray[NewValue],PDelta[NewValue],ThreadId);
     {$ENDIF}
     {$IFDEF Win95}
     SetThreadPriority(FHandle,PArray[NewValue]);
     {$ENDIF}
End;

Procedure TThread.SyncTerminate;
Begin
     FOnTerminate(Self);
End;

Procedure TThread.DoTerminate;
Begin
     If FOnTerminate<>Nil Then Synchronize(SyncTerminate);
End;

Function ThreadLayer(Param:TThread):LongInt;
{$IFDEF OS2}
Var  PAppHandle:LongWord;
     PAppQueueHandle:LongWord;
{$ENDIF}
Var FreeTerm:Boolean;
Begin
     {$IFDEF OS2}
     Param.FThreadId:=System.GetThreadId;
     If ApplicationType=1 Then
     Begin
          PAppHandle := WinInitializeAPI(0);
          PAppQueueHandle := WinCreateMsgQueueAPI(PAppHandle,0);
     End;
     {$ENDIF}

     Param.Priority:=Param.FPriority;
     Param.Execute;
     Result:=Param.ReturnValue;
     FreeTerm:=Param.FreeOnTerminate;
     Param.FFinished:=True;
     Param.DoTerminate;
     If FreeTerm Then Param.Destroy;

     {$IFDEF OS2}
     If ApplicationType=1 Then
     Begin
          WinDestroyMsgQueueAPI(PAppQueueHandle);
          WinTerminateAPI(PAppHandle);
     End;
     {$ENDIF}

     System.EndThread(Result);
End;


Const ThreadWindow:LongWord=0;
      WM_EXECUTEPROC=WM_USER+1;

Var ThreadDefWndProc:Function(Win,Msg,para1,para2:LongWord):LongWord;APIENTRY;
    MsgProc:Procedure;
    ProcessProc:Procedure;

Procedure TThread.MsgIdle;
Begin
     ProcessProc;
End;

Function ThreadWndProc(Win:LongWord;Msg,para1,para2:LongWord):LongWord;APIENTRY;
Var Thread:TThread;
Begin
     If Msg=WM_EXECUTEPROC Then
     Begin
          Thread:=TThread(para1);
          Thread.FMethod;
          Result:=0;
     End
     Else
     Begin
          If @ThreadDefWndProc<>Nil Then Result:=ThreadDefWndProc(Win,Msg,para1,para2)
          Else
          Begin
              {$IFDEF OS2}
              Result:=WinDefWindowProc(Win,Msg,para1,para2);
              {$ENDIF}
              {$IFDEF Win95}
              Result:=DefWindowProc(Win,Msg,para1,para2);
              {$ENDIF}
          End;
     End;
End;


Constructor TThread.ExtCreate(CreateSuspended:Boolean;StackSize:LongWord;Priority:TThreadPriority;
                              Param:Pointer);
Var Options:LongWord;
Begin
     If ((ApplicationType=1)And(ThreadWindow=0)) Then
     Begin
          ThreadDefWndProc:=Nil;
          {$IFDEF OS2}
          ThreadWindow:=WinCreateWCWindow(HWND_DESKTOP,
                                          WC_BUTTON,
                                          '',
                                          0,               //flStyle
                                          0,0,             //leave This ON 0 - Set by .Show
                                          0,0,             //Position And Size
                                          HWND_DESKTOP,    //parent
                                          HWND_TOP,        //Insert behind
                                          1,               //Window Id
                                          Nil,             //CtlData
                                          Nil);            //Presparams
          ThreadDefWndProc:=Pointer(WinSubClassWindow(ThreadWindow,@ThreadWndProc));
          {$ENDIF}
          {$IFDEF Win95}
          ThreadWindow:=CreateWindow('BUTTON',
                                     '',
                                     0,
                                     0,0,
                                     0,0,
                                     HWND_DESKTOP,
                                     1,
                                     DllModule,
                                     Nil);
          ThreadDefWndProc:=Pointer(SetWindowLong(ThreadWindow,GWL_WNDPROC,LongInt(@ThreadWndProc)));
          {$ENDIF}
     End;

     //Inherited Create;
     FSuspended:=CreateSuspended;
     Options:=0;
     If FSuspended Then Options:=Options Or THREAD_SUSPENDED;
     FPriority:=Priority;
     FParameter:=Param;
     FHandle:=BeginThread(Nil,StackSize,@ThreadLayer,Pointer(Self),Options,FThreadId);
End;

Constructor TThread.Create(CreateSuspended: Boolean);
Begin
     TThread.ExtCreate(CreateSuspended,65535,tpNormal,Nil);
End;

Destructor TThread.Destroy;
Begin
     If ((Not FFinished)And(Not FSuspended)) Then
     Begin
          Terminate;
          WaitFor;
     End
     Else If FSuspended Then
     Begin
          FFreeOnTerminate:=False;
          System.KillThread(FHandle);
     End;
     {$IFDEF Win95}
     If FHandle<>0 Then CloseHandle(FHandle);
     {$ENDIF}
     Inherited Destroy;
End;

Function TThread.WaitFor:LongInt;
Var FreeIt:Boolean;

Begin
     FreeIt:=FFreeOnTerminate;
     FFreeOnTerminate:=False;
     Repeat
           If ((ApplicationType=1)And(MsgProc<>Nil)) Then MsgProc
           Else Delay(50);
     Until FFinished;
     Result:=ReturnValue;
     If FreeIt Then Self.Destroy;
End;

Procedure TThread.Terminate;
Begin
     FTerminated:=True;
End;

Procedure TThread.Suspend;
Begin
     FSuspended:=True;
     {$IFDEF OS2}
     DosSuspendThread(FHandle);
     {$ENDIF}
     {$IFDEF Win95}
     SuspendThread(FHandle);
     {$ENDIF}
End;

Procedure TThread.Resume;
Begin
     {$IFDEF OS2}
     If DosResumeThread(FHandle)=0 Then FSuspended:=False;
     {$ENDIF}
     {$IFDEF Win95}
     If ResumeThread(FHandle) = 1 Then FSuspended:=False;
     {$ENDIF}
End;

//nach M”glichkeit nicht benutzen (statt dessen Terminate !), "abwrgen" des Threads
//falls keine M”glichkeit zur Abfrage von "Terminated" besteht
Procedure TThread.Kill;
Var FreeTerm:Boolean;
Begin
     Suspend;
     System.KillThread(FHandle);
     FreeTerm:=FreeOnTerminate;
     FFinished:=True;
     DoTerminate;
     If FreeTerm Then Self.Destroy;
End;

Procedure TThread.ProcessMsgs;
Begin
     If ProcessProc<>Nil Then Synchronize(MsgIdle);
End;

Procedure TThread.Synchronize(method:TThreadMethod);
Begin
     //If @method<>@MsgIdle Then ProcessMsgs;
     //MsgIdle;
     If ThreadWindow<>0 Then
     Begin
          FMethod:=method;
          {$IFDEF OS2}
          WinSendMsg(ThreadWindow,WM_EXECUTEPROC,LongWord(Self),0);
          {$ENDIF}
          {$IFDEF Win95}
          SendMessage(ThreadWindow,WM_EXECUTEPROC,LongWord(Self),0);
          {$ENDIF}
     End
     Else method;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCollectionItem Class Implementation                        บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TCollectionItem.GetIndex:LongInt;
Begin
     If FCollection=Nil Then Result:=-1
     Else Result:=FCollection.FItems.IndexOf(Self);
End;

Procedure TCollectionItem.SetCollection(NewValue:TCollection);
Begin
     If NewValue=FCollection Then Exit;

     If FCollection<>Nil Then FCollection.RemoveItem(Self);
     If NewValue<>Nil Then NewValue.InsertItem(Self);
End;

Procedure TCollectionItem.changed(AllItems:Boolean);
Begin
     If FCollection<>Nil Then If FCollection.FUpdateCount=0 Then
     Begin
          If AllItems Then FCollection.Update(Nil)
          Else FCollection.Update(Self);
     End;
End;

Procedure TCollectionItem.SetIndex(NewIndex:LongInt);
Begin
     If NewIndex=Index Then Exit
     Else If Index>=0 Then
     Begin
          FCollection.FItems.Move(Index,NewIndex);
          changed(True);
     End;
End;

Constructor TCollectionItem.Create(ACollection: TCollection);
Begin
     Inherited Create;
     collection:=ACollection;
End;

Destructor TCollectionItem.Destroy;
Begin
     collection:=Nil;
     Inherited Destroy;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCollection Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TCollection.GetCount:LongInt;
Begin
     Result:=FItems.Count;
End;

Procedure TCollection.InsertItem(Item:TCollectionItem);
Begin
     If Not (Item Is FItemClass) Then Raise EListError.Create(LoadNLSStr(SCollectionErrorText))
     Else
     Begin
          FItems.Add(Item);
          Item.FCollection:=Self;
          changed;
     End;
End;

Procedure TCollection.RemoveItem(Item:TCollectionItem);
Begin
     FItems.Remove(Item);
     Item.FCollection:=Nil;
     changed;
End;

Procedure TCollection.changed;
Begin
     If FUpdateCount=0 Then Update(Nil);
End;

Function TCollection.GetItem(Index:LongInt):TCollectionItem;
Begin
     Result:=TCollectionItem(FItems[Index]);
End;

Procedure TCollection.SetItem(Index:LongInt;Value:TCollectionItem);
Var dummy:TCollectionItem;
Begin
     dummy:=TCollectionItem(FItems[Index]);
     dummy.Assign(Value);
End;

{$HINTS OFF}
Procedure TCollection.Update(Item:TCollectionItem);
Begin
End;
{$HINTS ON}

Procedure TCollection.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Collection';
     FItemClass:=TCollectionItem;
     FItems.Create;
     Include(ComponentState,csDetail);
End;

Destructor TCollection.Destroy;
Begin
     FUpdateCount:=1;
     Clear;
     FItems.Destroy;

     Inherited Destroy;
End;

Function TCollection.Add:TCollectionItem;
Begin
     Result:=FItemClass.Create(Self);
End;

Function TCollection.Insert(Index:longint):TCollectionItem;
begin
     Result:=FItemClass.Create( nil ); // don't add to ourselves
     Result.FCollection := self; // don't assign thru property, would add it at the end of ourselves!!
     FItems.Insert( Index, Result );
     changed;
end;

Procedure TCollection.Swap(Index1,Index2:longint);
var
  Item: TCollectionItem;
begin
  Item := FItems[ Index1 ];
  FItems[ Index1 ] := FItems[ Index2 ];
  FItems[ Index2 ] := Item;
end;

Procedure TCollection.Assign(Source:TCollection);
Var dummy:TCollectionItem;
    T:LongInt;
Begin
     If ((Source=Nil)Or(Source=Self)) Then Exit;

     BeginUpdate;
     Try
        Clear;
        For T:=0 To Source.Count-1 Do
        Begin
             dummy:=Self.Add;
             dummy.Assign(Source.Items[T]);
        End;
     Finally
            EndUpdate;
     End;
End;

Procedure TCollection.BeginUpdate;
Begin
     Inc(FUpdateCount);
End;

Procedure TCollection.EndUpdate;
Begin
     Dec(FUpdateCount);
     changed;
End;

Procedure TCollection.Clear;
Var T:LongInt;
    dummy:TCollectionItem;
Begin
     If FItems.Count=0 Then Exit;

     BeginUpdate;
     Try
        For T:=FItems.Count-1 DownTo 0 Do
        Begin
             dummy:=FItems[T];
             dummy.Destroy;
        End;
        FItems.Clear;
     Finally
        EndUpdate;
     End;
End;

Begin
     LanguageMessages:=Nil;
     AppLanguage:='Default';
     MsgProc:=Nil;
     ProcessProc:=Nil;
     InsideCompLib:=False;
     InsideWriteSCU:=False;
     InsideWriteSCUAdr:=@InsideWriteSCU;
     InsideDesigner:=False;
     InsideLanguageDesigner:=False;

     RegisteredClasses.Create;
     PropertyEditDialogs.Create;
     LibExperts.Create;
     LibExpertInstances.Create;
End.