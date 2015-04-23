Unit ACLFileIOUtility;
// Functions for working with OS/2 HFILE

Interface

uses
  BseDos;

// skips over Length bytes
Procedure MySkip( F: HFile; Length: longword );

Procedure MySeek( F: HFile; NewPos: longword );

function MyRead( F: HFile; Buffer: pointer; Length: LongWord ): boolean;

function MyReadLn( F: HFile; Var S: String ): boolean;

// Note: Buffer will be resized as needed.
function MyReadParagraph( F: HFile; Buffer: PChar ): boolean;

Procedure MyWrite( F: HFile; Buffer: pointer; Length: LongWord );

Procedure MyWriteLn( F: HFile; S: String );

Procedure WriteStringToFile( TheString: PChar; FileName: string );

Procedure ReadStringFromFile( TheString: PChar; FileName: string );

// Read the specified block of F, allocating enough memory in Dest if needed.
// Uses AllocateMemory, so use DeallocateMemory to free.
function ReadFileBlock( F: HFile;
                        Var Dest: pointer;
                        const StartPosition: longint;
                        const Length: longint ): boolean;

Implementation

uses
  OS2Def,
  SysUtils,
  ACLUtility,
  StringUtilsUnit,
  CharUtilsUnit;

// skips over Length bytes
Procedure MySkip( F: HFile; Length: longword );
var
  Actual: ULong;
  rc: APIRET;
begin
  rc := DosSetFilePtr( F, Length, FILE_CURRENT, Actual );
  if rc <> 0 then
    raise EInOutError.Create( 'Error seeking: ' + SysErrorMessage( rc ) );
end;

Procedure MySeek( F: HFile; NewPos: longword );
var
  Actual: ULong;
  rc: APIRET;
begin
  rc := DosSetFilePtr( F, NewPos, FILE_BEGIN, Actual );
  if rc <> 0 then
    raise EInOutError.Create( 'Error seeking: ' + SysErrorMessage( rc ) );
  if Actual <> NewPos then
    raise EInOutError.Create( 'Cannot seek to position ' + IntToStr( NewPos ) );
end;

function MyRead( F: HFile; Buffer: pointer; Length: LongWord ): boolean;
var
  Actual: ULong;
  rc: APIRET;
begin
  rc := DosRead( F, Buffer^, Length, Actual );
  if rc <> 0 then
    raise EInOutError.Create( 'Error reading file: ' + SysErrorMessage( rc ) );

  Result:= rc = 0;
  if Actual = 0 then
    Result:= false;
end;

function MyReadLn( F: HFile; Var S: String ): boolean;
var
  C: Char;
begin
  Result:= MyRead( F, Addr( C ), 1 );
  while ( C <> #13 )
        and Result do
  begin
    S:= S + C;
    Result:= MyRead( F, Addr( C ), 1 );
  end;
  // see if there is a #10 to skip after the #13
  Result:= MyRead( F, Addr( C ), 1 );
  if Result then
    if C <> #10 then
      MySkip( F, -1 );
end;

function MyReadParagraph( F: HFile; Buffer: PChar ): boolean;
var
  CharBuffer: array[ 0..1 ] of Char;
begin
  StrCopy( Buffer, '' );
  CharBuffer[ 1 ]:= #0;
  Result:= MyRead( F, Addr( CharBuffer ), 1 );
  while ( CharBuffer[ 0 ] <> #13 )
        and Result do
  begin
    AddAndResize( Buffer, CharBuffer );
    Result:= MyRead( F, Addr( CharBuffer ), 1 );
  end;

  if not Result then
    exit;

  // skip #10 if found
  Result:= MyRead( F, Addr( CharBuffer ), 1 );
  if Result then
    if CharBuffer[ 0 ] <> #10 then
      MySkip( F, -1 );
end;

Procedure MyWrite( F: HFile; Buffer: pointer; Length: LongWord );
var
  Actual: ULong;
  rc: APIRET;
begin
  rc := DosWrite( F, Buffer^, Length, Actual );
  if rc <> 0 then
    raise EInOutError.Create( 'Error reading file: ' + SysErrorMessage( rc ) );
end;

Procedure MyWriteLn( F: HFile; S: String );
var
  Buffer: PChar;
begin
  Buffer:= StrAlloc( Length( S ) + 3 );
  StrPCopy( Buffer, S );
  StrCat( Buffer, #13 );
  StrCat( Buffer, #10 );
  MyWrite( F, Buffer, StrLen( Buffer ) );
  StrDispose( Buffer );
end;

Procedure WriteStringToFile( TheString: PChar; FileName: string );
Var
  TheFile: File;
Begin
  Assign( TheFile, FileName );
  Rewrite( TheFile );
  BlockWrite( TheFile, TheString^, strlen( TheString ) );
  Close( TheFile );
End;

Procedure ReadStringFromFile( TheString: PChar; FileName: string );
Var
  TheFile: File;
Begin
  Assign( TheFile, FileName );
  FileMode := fmInput;
  Reset( TheFile );
  BlockRead( TheFile, TheString^, FileSize( TheFile ) );
  TheString[ FileSize( TheFile ) ]:=Chr( 0 );
  Close( TheFile );
End;

function ReadFileBlock( F: HFile;
                        Var Dest: pointer;
                        const StartPosition: longint;
                        const Length: longint ): boolean;
begin
  result := true;

  if Length = 0 then
    // thar's nowt to be done.
    exit;

  MySeek( F, StartPosition );

  if Dest = nil then
    Dest := AllocateMemory( Length );

  result := MyRead( F,
                    Dest,
                    Length );
end;

Initialization
End.
