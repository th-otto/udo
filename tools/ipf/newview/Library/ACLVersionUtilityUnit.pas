Unit ACLVersionUtilityUnit;

Interface

Uses
  BseDos;

type
  TVersionsModule = HFILE;

function OpenModuleForVersions( const Path: string;
                                var Module: TVersionsModule ): boolean;

function GetVersionFromModule( Module: TVersionsModule;
                               var Version: string ): boolean;

procedure CloseModuleForVersions( Module: TVersionsModule );

Implementation

uses
  OS2Def;

function OpenModuleForVersions( const Path: string;
                                var Module: TVersionsModule ): boolean;
var
  ulAction: ULONG;
begin
  Result := DosOpen( Path,
                     Module,
                     ulAction,
                     0,
                     0,
                     OPEN_ACTION_FAIL_IF_NEW
                     + OPEN_ACTION_OPEN_IF_EXISTS,
                     OPEN_SHARE_DENYNONE
                     + OPEN_ACCESS_READONLY,
                     nil ) = 0;
end;

type
  TMatchState =
  (
    msStart1,
    msStart2,
    msRead,
    msEnd1
  );

function GetVersionFromModule( Module: TVersionsModule;
                               var Version: string ): boolean;
var
  cbActual: ULONG;
  rc: APIRET;
  c: char;
  State: TMatchState;
  MatchCount: longint;
  Match: boolean;
begin
  Result := false;
  Version := '';
  MatchCount := 0;
  while true do
  begin
    rc := DosRead( Module,
                   c,
                   1,
                   cbActual );
    if cbActual = 0 then
      exit; // end of file

    Match := false;
    case State of
      msStart1:
        if c = '@' then
        begin
          Match := true;
          inc( State );
        end;

      msStart2:
        if c = '$' then
        begin
          Match := true;
          inc( State );
        end;

      msRead:
      begin
        Match := true;
        if c = '$' then
          inc( State )
        else
          Version := Version + c;
        if Length( Version ) >= 100 then
          Match := false;
      end;

      msEnd1:
        if c = '@' then
        begin
          Result := true;
          exit;
        end;
    end;

    if Match then
    begin
      inc( MatchCount )
    end
    else
    begin
      State := msStart1;
      if MatchCount > 0 then
        DosSetFilePtr( Module,
                       - ( MatchCount - 1 ),
                       FILE_CURRENT,
                       cbActual );
      MatchCount := 0;
      Version := '';
    end;
  end;

  Version := '';
end;

procedure CloseModuleForVersions( Module: TVersionsModule );
begin
  DosClose( Module );
end;

Initialization
End.
