unit AStringUtilityUnit;

// Utilities for TAString

interface

uses
  Classes,
  ACLString;

// Puts specified program command line parameter
// into AString
procedure AString_ParamStr( item: byte;
                            S: TAString );

// Splits up an AString at the given separator CHAR
// Puts the individual strings into List, truncating
// each string at 255 chars max.
procedure AStringToList( S: TAstring;
                         List: TStrings;
                         const Separator: char );

// Converts the given stringlist to an AString
// with the given separator between entries
procedure ListToAString( List: TStrings;
                         S: TAstring;
                         const Separator: char );

// Adds the given value to an AString containing
// a list with entries separated by separator
Procedure AddToListAString( S: TAString;
                            const NewValue: string;
                            const Separator: char );

// returns true if there appears to be a domain name
// in S starting at StartingAt
// must contain at least one period and
// some characters before and after it.
// ie. a.b
function IsDomainName( s: TAstring;
                       StartingAt: longint ): boolean;

// return true if S appears to be an email address
// a@b.c
function IsEmailAddress( s: TAstring ): boolean;

// Returns true if S contains a URL.
// MAY MODIFY CONTENTS OF S
function IsURL( s: TAstring ): boolean;

// Trims punctuation characters from start and end of s
// such as braces, periods, commas.
procedure TrimPunctuation( s: TAString );

implementation

uses
  ACLUtility;

procedure AString_ParamStr( item: byte;
                            S: TAString );
var
  p: pchar;
  l: longint;
begin
  GetCommandLineParameter( item, p, l );
  S.AssignPCharLen( p, l );
end;

procedure AStringToList( S: TAstring;
                         List: TStrings;
                         const Separator: char );
var
  Item: TAString;
  i: longint;
begin
  List.Clear;
  Item := TAString.Create;

  i := 0;
  while i < S.Length do
  begin
    S.ExtractNextValue( i, Item, Separator );
    List.Add( Item.AsString );
  end;

  Item.Destroy;
end;

Procedure AddToListAString( S: TAString;
                            const NewValue: string;
                            const Separator: char );
Begin
  if S.Length > 0 then
    S.AddString( Separator );
  S.AddString( NewValue );
End;

procedure ListToAString( List: TStrings;
                         S: TAstring;
                         const Separator: char );
Var
  i: longint;
Begin
  S.Clear;
  for i := 0 to List.Count - 1 do
    AddToListAString( S, List[ i ], Separator );
End;

function IsDomainName( s: TAstring;
                       StartingAt: longint ): boolean;
var
  DotPos: longint;
begin
  Result := false;

  // must be a dot in the domain...
  DotPos := s.CharPosition( StartingAt, '.' );
  if DotPos = -1 then
    // nope
    exit;

  // must be some text between start and dot,
  // and between dot and end
  // ie. a.b not .b or a.

  if DotPos = StartingAt then
    // no a
    exit;
  if DotPos = s.Length - 1 then
    // no b;
    exit;

  Result := true;
end;

function IsEmailAddress( s: TAstring ): boolean;
var
  AtPos: longint;
  SecondAtPos: longint;
begin
  result := false;
  // must be a @...
  AtPos := s.CharPosition( 0, '@' );
  if AtPos = -1 then
    // no @
    exit;
  if AtPos = 0 then
    // can't be the first char though
    exit;

  // there is; there must be only one though...
  SecondAtPos := s.CharPosition( AtPos + 1, '@' );
  if SecondAtPos <> -1 then
    // there's a second @
    exit;

  Result := IsDomainName( s, AtPos + 1 );
end;

// Returns true if S contains a URL.
// MAY MODIFY CONTENTS OF S
function IsURL( s: TAstring ): boolean;
begin
  if s.StartsWith( 'www.' ) then
  begin
    if not IsDomainName( s, 4 ) then
      exit;
    s.InsertString( 0, 'http://' );
    result := true;
    exit;
  end;

  if s.StartsWith( 'ftp.' ) then
  begin
    if not IsDomainName( s, 4 ) then
      exit;
    s.InsertString( 0, 'ftp://' );
    result := true;
    exit;
  end;

  if    S.StartsWith( 'http://' )
     or S.StartsWith( 'https://' )
     or S.StartsWith( 'ftp://' )
     or S.StartsWith( 'mailto:' )
     or S.StartsWith( 'news:' ) then
  begin
    result := true;
    exit;
  end;

  if IsEmailAddress( s ) then
  begin
    s.InsertString( 0, 'mailto:' );
    result := true;
    exit;
  end;

  result := false;
end;

const
  StartPunctuationChars: set of char =
    [ '(', '[', '{', '<', '''', '"' ];

  EndPunctuationChars: set of char =
    [ ')', ']', '}', '>', '''', '"', '.', ',', ':', ';', '!', '?' ];

procedure TrimPunctuation( s: TAString );
var
  ChangesMade: boolean;
begin
  while s.Length > 0 do
  begin
    ChangesMade := false;

    if s[ 0 ] in StartPunctuationChars then
    begin
      ChangesMade := true;
      s.Delete( 0, 1 );
    end;

    if s.Length = 0 then
      exit;

    if s[ s.Length - 1 ] in EndPunctuationChars then
    begin
      ChangesMade := true;
      s.Delete( s.Length - 1, 1 );
    end;

    if not ChangesMade then
      exit; // done
  end;
end;

end.