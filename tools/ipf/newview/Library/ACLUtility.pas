Unit ACLUtility;

Interface

Uses
  Classes, SysUtils,
{$ifdef os2}
  Os2Def, IniFiles;
{$endif}
{$ifdef win32}
  Registry;
{$endif}

function GetACLLibraryVersion: string;

Type
  TPrintOutput = procedure( TheText: string ) of object;
  TTerminateCheck = function: boolean of object;
  TProgressCallback = procedure( n, outof: integer;
                                 Message: string ) of object;

const
   _MAX_PATH = 260;    // max. length of full pathname
   _MAX_DRIVE = 3;     // max. length of drive component
   _MAX_DIR = 256;     // max. length of path component
   _MAX_FNAME = 256;   // max. length of file name component
   _MAX_EXT = 256;     // max. length of extension component

   mrFailed = $c000 + 1;

{$ifdef win32}
Function GetAPIErrorString( ErrorCode: integer ): string;
Function GetLastAPIErrorString: string;
{$endif}

Type
  TMyIniFile =
{$ifdef os2}
    class( TAsciiIniFile )
{$else}
    class( TRegIniFile )
{$endif}
    constructor CreateMe( const Path: string );
    destructor Destroy; override;
  end;

{$ifdef os2}
function AllocateMemory( const Size: longint ): pointer;
procedure DeallocateMemory( Var P: pointer );
procedure Sleep( const milliseconds: longint );
{$endif}

// allocate a new copy of the given source memory
procedure AllocMemCopy( const Source: pointer;
                        var Dest: pointer;
                        const Size: longint );

procedure MemCopy( const Source: pointer;
                   const Dest: pointer;
                   const Size: longint );

procedure FillMem( Dest: pointer;
                   Size: longint;
                   Data: Byte );

// Returns A - B
function PtrDiff( A, B: pointer ): longword;

function Min( const a: longint;
              const b: longint ): longint;

function Max( const a: longint;
              const b: longint ): longint;

function Between( const Value: longint;
                  const Limit1: longint;
                  const Limit2: longint ): boolean;

function PtrBetween( const Value: pointer;
                     const Limit1: pointer;
                     const Limit2: pointer ): boolean;

Procedure AddList( Source, Dest: TList );

Procedure AssignList( Source, Dest: TList );

// Destroy the objects stored in List
// and clear the list.
Procedure ClearListAndObjects( List: TList );

// Destroy the objects stored in the list
// and then destroy the list itself
// And set the reference to nil
Procedure DestroyListAndObjects( Var List: TList );

// Destroy the objects stored in the list.
// You probably want to use one of the two functions above.
Procedure DestroyListObjects( List: TList );

// Returns the filename of the running app
// (including drive/directory)
Function GetApplicationFilename: string;

// Returns the starting directory of the app
Function GetApplicationDir: string;

{$ifdef win32}
type
  TDaylightSavingStatus =
  (
    dssDisabled,
    dssDaylightSaving,
    dssNormal
  );

function GetDaylightSavingStatus: TDaylightSavingStatus;
{$endif}

type
  TDataList = TList; // to help distinguish from TObjectList below
  
type
  TObjectListSortCompare = function ( Item1, Item2: TObject ): Integer;

  // TObjectList has exactly the same functionality as TList,
  // except that rather than using untyped pointers it expects
  // object references. This means that incorrect typecasts can
  // be detected when using the list
  TObjectList = class( TList )
  protected
    function Get( index: integer ): TObject;
    procedure Put( index: integer; Item: TObject );
  public
    function Add( item: TObject ): integer;
    function First: TObject;
    function IndexOf( item: TObject ): integer;
    procedure Insert( Index: Integer; Item: TObject );
    function Last: TObject;
    function Remove( Item: TObject ): Integer;
    procedure Sort( Compare: TObjectListSortCompare );
    property Items[ index: integer ]: TObject read Get write Put; default;

    // Additional:
    // Copy the given list to this one.
    procedure Assign( Source: TObjectList );
    // Add the objects in the given list to this one
    procedure AddList( Source: TObjectList );

  end;

{$ifdef os2}
function GetCrc32( pData: pointer; size: longint ): longword;
{$endif}

function Pascal_GetCrc32( pData: pointer; size: longint ): longword;

// Raise an exception if the given Code is <> 0
procedure CheckSystemError( Code: longword;
                            Message: string );

{$ifdef os2}
// get pointer to start, and length, of specified parameter
procedure GetCommandLineParameter( item: byte;
                                   var pParam: pchar;
                                   var ParamLength: longint );

function GetUserProfileString( const AppName: string;
                               const KeyName: string;
                               const Default: string ): string;

Procedure SetUserProfileString( const AppName: string;
                                const KeyName: string;
                                const Value: string );

Procedure LoadDLLFunction( const DLLName: string;
                           const FunctionName: string;
                           var hDLL: HMODULE;
                           var F: pointer );

{$endif}

Implementation

// Implementation ------------------------------------------

Uses
{$ifdef os2}
  Dos, BseDos, BseTib, PmWin, PmGpi, PmDev, PmShl;
{$else}
  Windows, FileCtrl;
{$endif}

constructor TMyIniFile.CreateMe( const Path: string );
begin
{$ifdef os2}
  Inherited Create( Path );
{$else}
  Inherited Create( Path );
{$endif}
end;

destructor TMyIniFile.Destroy;
begin
{$ifdef os2}
  Refresh;
{$endif}
  inherited Destroy;
end;

{$ifdef os2}
function AllocateMemory( const Size: longint ): pointer;
begin
  GetMem( Result, size + sizeof( Size ) );
  pLong( Result )^ := Size;
  inc( Result, sizeof( Size ) );
end;

procedure DeallocateMemory( Var P: pointer );
var
  Size: longint;
begin
  if P = nil then
    exit;

  dec( P, sizeof( Size ) );
  Size := pLong( P )^;
  FreeMem( P, Size + sizeof( Size ) );
  P := nil;
end;
{$endif}

{$ifdef win32}
Function GetAPIErrorString( ErrorCode: integer ): string;
var
  buffer: array[ 0..1000 ] of char;
begin
  if FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM,
                    nil, // no special message source
                    ErrorCode,
                    0, // use default language
                    Buffer,
                    Sizeof( Buffer ),
                    nil ) > 0
  then // no arguments
    Result:= IntToStr( ErrorCode ) + ': ' + Buffer
  else
    Result:= '(Unknown error)';

end;

Function GetLastAPIErrorString: string;
begin
  Result := GetAPIErrorString( GetLastError );
end;
{$endif}

procedure AllocMemCopy( const Source: pointer;
                        var Dest: pointer;
                        const Size: longint );
begin
  GetMem( Dest, Size );
  MemCopy( Source, Dest, Size );
end;

procedure MemCopy( const Source: pointer;
                   const Dest: pointer;
                   const Size: longint );
begin
  Move( Source^, Dest^, Size );
end;

procedure FillMem( Dest: pointer;
                   Size: longint;
                   Data: Byte );
begin
  FillChar( Dest^, Size, Data );
end;

function PtrDiff( A, B: pointer ): longword;
begin
  result:= longword( A ) - longword( B );
end;

Procedure AddList( Source, Dest: TList );
var
  i: longint;
begin
  // expand the destination list
  // to what's required
  Dest.Capacity := Dest.Capacity
                   + Source.Capacity;
  for i:= 0 to Source.Count - 1 do
    Dest.Add( Source[ i ] );
end;

Procedure AssignList( Source, Dest: TList );
begin
  Dest.Clear;
  AddList( Source, Dest );
end;

{$ifdef win32}
function GetDaylightSavingStatus: TDaylightSavingStatus;
var
  TimeZoneInfo: TIME_ZONE_INFORMATION;
  ZoneID: DWORD;
Begin
  ZoneID:= GetTimeZoneInformation( TimeZoneInfo );
  if TimeZoneInfo.DaylightBias = 0 then
    Result:= dssDisabled
  else if ZoneID = TIME_ZONE_ID_DAYLIGHT then
    Result:= dssDaylightSaving
  else
    Result:= dssNormal;
end;
{$endif}

// Destroy the objects stored in List
// and clear the list.
Procedure ClearListAndObjects( List: TList );
begin
  DestroyListObjects( List );
  List.Clear;
end;

// Destroy the objects stored in the list
// and then destroy the list itself.
Procedure DestroyListAndObjects( Var List: TList );
begin
  if not Assigned( List ) then
    exit;

  DestroyListObjects( List );
  List.Destroy;
  List := nil;
end;

Procedure DestroyListObjects( List: TList );
var
  Index: longint;
begin
  for Index := 0 to List.Count - 1 do
  begin
    if List[ Index ] <> nil then
    begin
      TObject( List[ Index ] ).Destroy;
      List[ Index ] := nil;
    end;
  end;
end;

function Min( const a: longint;
              const b: longint ): longint;
begin
  if a<b then
   result:= a
  else
   result:= b;
end;

function Max( const a: longint;
              const b: longint ): longint;
begin
  if a>b then
   result:= a
  else
   result:= b;
end;

function Between( const Value: longint;
                  const Limit1: longint;
                  const Limit2: longint ): boolean;
begin
  if Limit1 < Limit2 then
    Result:= ( Value >= Limit1 ) and ( Value <= Limit2 )
  else
    Result:= ( Value >= Limit2 ) and ( Value <= Limit1 )
end;

function PtrBetween( const Value: pointer;
                     const Limit1: pointer;
                     const Limit2: pointer ): boolean;
var
  v, p1, p2: pchar;
begin
  v := Value;
  p1 := Limit1;
  p2 := Limit2;
  if p1 < p2 then
    Result:= ( V >= p1 ) and ( V <= p2 )
  else
    Result:= ( V >= p2 ) and ( V <= p1 )
end;

{$ifdef os2}
Function GetApplicationFilename: string;
var
  pThreadInfo: PTIB;
  pProcessInfo: PPIB;
  ProcessName: cstring[ _MAX_PATH ];
begin
  DosGetInfoBlocks( pThreadInfo,
                    pProcessInfo );
  DosQueryModuleName( pProcessInfo^.pib_hmte,
                      sizeof( ProcessName ),
                      ProcessName );
  Result := ProcessName;
end;
{$else}
Function GetApplicationFilename: string;
var
  ProcessName: array[ 0.._MAX_PATH ] of char;
begin
  GetModuleFileName( 0, // our own process
                     ProcessName,
                     sizeof( ProcessName ) );

  Result := ProcessName;
end;
{$endif}

Function GetApplicationDir: string;
begin
  Result := ExtractFilePath( GetApplicationFilename );
end;

{ TObjectList }

function TObjectList.Add( item: TObject ): integer;
begin
  result := inherited Add( item );
end;

function TObjectList.First: TObject;
begin
  result := inherited First;
end;

function TObjectList.Get( index: integer ): TObject;
begin
  result := Items[ Index ];
end;

function TObjectList.IndexOf( item: TObject ): integer;
begin
  result := inherited IndexOf( item );
end;

procedure TObjectList.Insert( Index: Integer; Item: TObject );
begin
  inherited Insert( Index, Item );
end;

function TObjectList.Last: TObject;
begin
  result := inherited Last;
end;

procedure TObjectList.Put( index: integer; Item: TObject );
begin
  Items[ Index ] := Item;
end;

function TObjectList.Remove( Item: TObject ): Integer;
begin
  result := inherited Remove( Item );
end;

procedure QuickSortObjectList( SortList: PPointerList;
                               L, R: Integer;
                               CompareFunction: TObjectListSortCompare );
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while CompareFunction( TObject( SortList^[I] ), P ) < 0 do
        Inc(I);
      while CompareFunction( TObject( SortList^[J] ), P) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortObjectList( SortList, L, J, CompareFunction );
    L := I;
  until I >= R;
end;

procedure TObjectList.Sort( Compare: TObjectListSortCompare );
begin
  if ( List <> nil ) and ( Count > 0 ) then
    QuickSortObjectList( List, 0, Count - 1, Compare );
end;

procedure TObjectList.Assign( Source: TObjectList );
begin
  Clear;
  AddList( Source );
end;

procedure TObjectList.AddList( Source: TObjectList );
var
  i: integer;
begin
  for i := 0 to Source.Count - 1 do
    Add( Source[ i ] );
end;

{$ifdef os2}
procedure Sleep( const milliseconds: longint );
begin
  DosSleep( milliseconds );
end;
{$endif}

const
  Crc32Table: array[ 0..255 ] of longword =
  (
    $00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D
  );

function Pascal_GetCrc32( pData: pointer; size: longint ): longword;
var
  i: longint;
  p: pbyte;
begin
  Result := $ffffffff;
  p := pData;
  for i := 0 to size - 1 do
  begin
    Result :=     ( Result shr 8 )
              xor Crc32Table[ ( Result xor p^ ) and $000000FF ];
    inc( p );
  end;
end;

{$ifdef os2}
function GetCrc32( pData: pointer; size: longint ): longword;
begin
  asm
    mov  esi, pData                  {esi: Points to Buffer}
    mov  edx, $ffffffff              {edx: Result}
    mov  ecx, Size
    xor  eax, eax                    {clear EAX: top bits must remain 0}
    cld

  @@Loop:
    mov  ebx, edx                    {Save Result in ebx}
    shr  edx, 8
    lodsb                            {Load next Buffer entry}
    xor  ebx, eax
    and  ebx, $ff

// should be able to use
// xor  edx, dword ptr [edi+4*ebx]
// Sibyl Assembler doesn't support it!

    mov  edi, ebx                    {Get lookup index}
    shl  edi, 2                      {x4 to get address for longword}
    xor  edx, Crc32Table[edi]        {lookup in table, XOR with edx}

    dec  ecx                         {Dec Count}
    jnz  @@Loop                      {if Count<>0 goto @@Loop}

    mov  Result, edx                 {Save Result}
  end;
end;
{$endif}

// Raise an exception if the given Code is <> 0
procedure CheckSystemError( Code: longword;
                            Message: string );
begin
  if Code <> 0 then
    raise Exception.Create( Message
                            + ': ['
                            + IntToStr( Code )
                            + '] '
                            + SysErrorMessage( Code ) );
end;

{$ifdef os2}
procedure GetCommandLineParameter( item: byte;
                                   var pParam: pchar;
                                   var ParamLength: longint );

Begin
  ParamLength := 0;
  ASM
    MOV CL, item                // Load item to CL
    MOV AL, 2
    MOV ESI, SYSTEM.ArgStart    // Get start of parameters
    CALLN32 SYSTEM.!ParaInfo    // Get start of this parameter

    LEA EDI, pParam             // Address of pParam
    MOV EDI, [EDI]              // Address of what pParam references
    MOV [EDI], ESI              // store start of param

    CMP ESI, 0                  // Parameter invalid ?
    JE gclp_End                 // leave if invalid

    CLD
    MOV ECX, 0                  // Len is 0
    MOV DL, 0                   // we are not in quote state

gclp_Loop:
    LODSB                       // load byte of parameter

    CMP AL, '"'                 // Check for quote char
    JNE gclp_NotQuote
    NOT DL                      // toggle quote flag

gclp_NotQuote:
    CMP AL, ' '                 // check for space - end of parameter
    JNE gclp_NotEnd
                                // parameter has ended, unless in quote
    CMP DL, 0                   // check quote flag
    JE  gclp_Done               // if off, then we're finished

gclp_NotEnd:
    CMP AL, 0                   // check for zero terminator at end of last parameter
    JE  gclp_Done               // if found, we're finished

    INC ECX                     // OK we have one more byte
    JMP gclp_Loop               // next please

gclp_Done:
    // now to remove quotes at start/end
    CMP ECX, 0
    JE  gclp_NoQuotes           // length is zero, can't be quotes

    LEA EDI, pParam             // Address of pParam
    MOV EDI, [EDI]              // Address of what pParam references
    MOV ESI, [EDI]              // get start of param

    MOV AL, [ESI+ECX-1]         // get last char
    CMP AL, '"'                 // check if quote
    JNE gclp_EndQuoteDone
    DEC ECX                     // decrease length
    CMP ECX, 0
    JE  gclp_StartQuoteDone     // length is zero, can't be another quote
gclp_EndQuoteDone:

    LODSB                       // load first byte, inc ESI
    CMP AL, '"'                 // check if quote
    JNE gclp_StartQuoteDone
    DEC ECX                     // quote, so decrease length
    MOV [EDI], ESI              // store new start of param
gclp_StartQuoteDone:

gclp_NoQuotes:
    LEA EDI,ParamLength         // address of ParamLength
    MOV EDI, [EDI]              // dereference
    MOV [EDI],ECX               // store length
gclp_End:
  END;
END;

function GetUserProfileString( const AppName: string;
                               const KeyName: string;
                               const Default: string ): string;
var
  Buffer: array[ 0..255 ] of char;
  Len: longint;
  i: longint;
  szDefault: cstring;
begin
  szDefault := Default;
  Len := PrfQueryProfileString( HINI_USERPROFILE, // user profile
                                AppName, // application
                                KeyName, // key
                                szDefault,
                                Buffer,
                                sizeof( Buffer ) );

  // remove null terminator, if present
  if Len > 0 then
    if Buffer[ Len - 1 ] = #0 then
      dec( Len );
  Result := '';
  for i := 0 to Len - 1 do
    Result := Result + Buffer[ i ];
end;

Procedure SetUserProfileString( const AppName: string;
                                const KeyName: string;
                                const Value: string );
begin
  if not PrfWriteProfileString( HINI_USERPROFILE, // user profile
                                AppName, // application
                                KeyName, // key
                                Value ) then
    raise Exception.Create(
                'Error writing INI ['
                + AppName
                + '/'
                + KeyName
                + '] rc = '
                + IntToHex( WinGetLastError( AppHandle ), 8 ) );
end;

procedure LoadDLLFunction( const DLLName: string;
                           const FunctionName: string;
                           var hDLL: HMODULE;
                           var F: pointer );
var
  ActualDLLName: string;
  csErrorObject: cstring;
  csFunctionName: cstring;
  rc: APIRET;
begin
  F := nil;

  if hDLL = NullHandle then
  begin
    ActualDLLName := GetApplicationDir + DLLName;
    if not FileExists( ActualDLLName ) then
      ActualDLLName := DLLName;

    rc := DosLoadModule( csErrorObject,
                         sizeof( csErrorObject ),
                         ActualDLLName,
                         hDLL );
    if rc <> 0 then
      raise Exception.Create( DLLName
                              + ' could not be loaded: '
                              + SysErrorMessage( rc ) );

  end;

  csFunctionName := FunctionName;
  rc := DosQueryProcAddr( hDLL,
                          0, // using by name
                          csFunctionName,
                          F );
  if rc <> 0 then
    raise Exception.Create( FunctionName
                            + ' in '
                            + DLLName
                            + ': '
                            + SysErrorMessage( rc ) );
end;

{$endif}

const
  LibVersion = 'V1.5.14'; // $SS_REQUIRE_NEW_VERSION$

function GetACLLibraryVersion: string;
begin
  Result := LibVersion;
end;

Initialization
End.

