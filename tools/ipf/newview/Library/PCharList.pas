Unit PCharList;

Interface

Uses
  Classes;

Type

  // PCHar list class. It only stores the pointers; it does not copy or
  // dispose the strings themselves.
  TPCharList=class
   protected
    List: TList;
   public
    constructor Create;
    destructor Destroy; override;
    // Adds s to the list. Returns index of new item
    Function Add( S: PChar ): longint;
    // Returns string at index
    Function Get( index: longint ): PChar;
    Procedure Delete( index: longint );

    Procedure Put( index: longint; S: PChar );

    property Strings[ index: longint ]: PChar read Get write Put; default;

    Function Count: longint;

    procedure Clear;
    procedure Assign( NewText: TPCharList );

    Function IndexOf( SearchText: PChar ): longint;
  end;

Implementation

Uses
  SysUtils;

constructor TPCharList.Create;
Begin
  List:= TList.Create;
End;

procedure TPCharList.Clear;
begin
  while list.count>0 do
    Delete( 0 );
end;

destructor TPCharList.Destroy;
Begin
  Clear;
  List.Destroy
End;

Function TPCharList.Add( S: PChar ): longint;
Begin
  Result:= List.Add( S );
End;

Function TPCharList.Get( index: longint ): PChar;
Begin
  Result:=List[ index ];
End;

Procedure TPCharList.Delete( index: longint );
Begin
  List.Delete( index )
End;

Procedure TPCharList.Put( index: longint; S: PChar );
Begin
  List[ index ]:=S;
End;

Function TPCharList.Count: longint;
Begin
  Result:=List.Count;
End;

procedure TPCharList.Assign( NewText: TPCharList );
var
  i: longint;
begin
  Clear;
  for i:= 0 to NewText.Count - 1 do
    Add( StrNew( NewText[ i ] ) );
end;

Function TPCharList.IndexOf( SearchText: PChar ): longint;
var
  i: longint;
begin
  for i:= 0 to List.Count - 1 do
    if StrIComp( Strings[ i ], SearchText ) = 0 then
    begin
      // found
      Result:= i;
      exit
    end;

  Result:= -1;
end;

Initialization
End.
