Unit Semaphores;

Interface

Uses
{$ifdef os2}
  BseDos;
{$else}
  Windows;
{$endif}

Type
{$ifdef win32}
  Hev = THandle;
  HMtx = THandle;
{$endif}

  TEventSemaphore = class
  protected
    _Handle: HEv;
    _Name: string;
    _AlreadyExisted: boolean;
  public
    Constructor Create;
    Constructor CreateNamed( const Name: string );
    Destructor Destroy; override;

    procedure Post;
    procedure Reset;
    function IsPosted: boolean;
    procedure Wait;

    property Handle: HEv read _Handle;
  end;

  TWaitType = ( wtAny, wtAll );

{$ifdef os2}
  TSemaphoreArray = Array[ 0..0 ] of SEMRECORD;
  TPSemaphoreArray = ^TSemaphoreArray;
{$else}
  TSemaphoreArray = Array[ 0..0 ] of TEventSemaphore;
  TPSemaphoreArray = ^TSemaphoreArray;
{$endif}

  TMultiWaitSemaphore = class
  protected
    _WaitType: TWaitType;
{$ifdef os2}
    _Handle: HMux;
    _PSemaphoreArray: TPSemaphoreArray;
{$else}
    _PSemaphoreHandleArray: PWOHandleArray;
    _PSemaphoreArray: TPSemaphoreArray;
{$endif}
    _SemaphoreCount: longint;
  public
    Constructor Create( WaitType: TWaitType;
                        Semaphores: array of TEventSemaphore );
    Destructor Destroy; Override;

    // Returns which event semaphore was posted
    Function Wait: TEventSemaphore;
  end;

  TMutex = class
  protected
    _Handle: HMtx;
  public
    constructor Create;
    constructor CreateNamed( const Name: string );
    destructor Destroy; override;

    procedure Get;
    procedure Release;
  end;

Implementation

// Turn off range checking since we are playing with dynamic arrays
{$R-}

Constructor TEventSemaphore.Create;
begin
{$ifdef os2}
  DosCreateEventSem( nil, // unnamed
                     _Handle,
                     0, // not shared
                     false );
{$else}
  _Handle:= CreateEvent( nil, // no security
                         true, // manual reset please
                         false, // initially cleared
                         nil ); // no name
{$endif}
end;

Constructor TEventSemaphore.CreateNamed( const Name: string );
{$ifdef os2}
var
  CName: Cstring;
{$endif}
begin
  _Name := Name;
{$ifdef os2}
  CName := Name;
  DosCreateEventSem( CName, // unnamed
                     _Handle,
                     DC_SEM_SHARED, // shared 
                     false );
{$else}
  _Handle:= CreateEvent( nil, // no security
                         true, // manual reset please
                         false, // initially cleared
                         PChar( name ) ); // no name
{$endif}
end;

Destructor TEventSemaphore.Destroy;
begin
{$ifdef os2}
  DosCloseEventSem( _Handle );
{$else}
  CloseHandle( _Handle );
{$endif}
end;

procedure TEventSemaphore.Post;
begin
{$ifdef os2}
  DosPostEventSem( _Handle );
{$else}
  SetEvent( _Handle );
{$endif}
end;

procedure TEventSemaphore.Reset;
{$ifdef os2}
var
  PostCount: Longword;
{$endif}
begin
{$ifdef os2}
  DosResetEventSem( _Handle, PostCount );
{$else}
  ResetEvent( _Handle);
{$endif}
end;

function TEventSemaphore.IsPosted: boolean;
{$ifdef os2}
var
  PostCount: Longword;
{$endif}
begin
{$ifdef os2}
  DosQueryEventSem( _Handle, PostCount );
  Result:= ( PostCount > 0 );
{$else}
  if WaitForSingleObject( _Handle,
                          0 ) // return immediately...
     = WAIT_OBJECT_0 then
    Result:= true
  else
    Result:= false;
  // ? doesn't seem to be possible...
{$endif}
end;

procedure TEventSemaphore.Wait;
begin
{$ifdef os2}
  DosWaitEventSem( Handle, SEM_INDEFINITE_WAIT );
{$else}
  WaitForSingleObject( _Handle,
                       INFINITE );
{$endif}
end;

Constructor TMultiWaitSemaphore.Create( WaitType: TWaitType;
                                        Semaphores: array of TEventSemaphore );
var
  i: longint;
  SemIndex: longint;

{$ifdef os2}
  flAttr: Longword;
{$endif}

begin
  _WaitType:= WaitType;

  _SemaphoreCount:= High( Semaphores ) - Low( Semaphores ) + 1;
{$ifdef os2}
  GetMem( _PSemaphoreArray, Sizeof( SEMRECORD ) * _SemaphoreCount );
{$else}
  GetMem( _PSemaphoreHandleArray, Sizeof( THandle ) * _SemaphoreCount );
  GetMem( _PSemaphoreArray, Sizeof( TEventSemaphore ) * _SemaphoreCount );
{$endif}

  for i:= 0 to _SemaphoreCount - 1 do
  begin
    SemIndex:= i + Low( Semaphores );
{$ifdef os2}
    _PSemaphoreArray^[ i ].hSemCur:= Semaphores[ SemIndex ].Handle;
    _PSemaphoreArray^[ i ].ulUser:= longword( Semaphores[ SemIndex ] );
{$else}
    _PSemaphoreHandleArray^[ i ]:= Semaphores[ SemIndex ].Handle;
    _PSemaphoreArray^[ i ]:= Semaphores[ SemIndex ];
{$endif}
  end;

{$ifdef os2}
  case _WaitType of
  wtAll:
    flAttr:= DCMW_WAIT_ALL;
  wtAny:
    flAttr:= DCMW_WAIT_ANY;
  end;

  DosCreateMuxWaitSem( nil,
                       _Handle,
                       _SemaphoreCount,
                       _PSemaphoreArray^,
                       flAttr );
{$endif}
// nothing to do for Win32...

end;

Destructor TMultiWaitSemaphore.Destroy;
begin
{$ifdef os2}
  DosCloseMuxWaitSem( _Handle );
  FreeMem( _PSemaphoreArray, Sizeof( SEMRECORD ) * _SemaphoreCount );
{$else}
  FreeMem( _PSemaphoreArray, Sizeof( THandle ) * _SemaphoreCount );
{$endif}
end;

Function TMultiWaitSemaphore.Wait: TEventSemaphore;
var
  WhichSem: LongWord;
{$ifdef win32}
  WaitAll: BOOL;
{$endif}
begin
{$ifdef os2}
  DosWaitMuxWaitSem( _Handle, SEM_INDEFINITE_WAIT, WhichSem );
  Result:= TEventSemaphore( WhichSem );
{$else}
  WaitAll:= ( _WaitType = wtAll );

  WhichSem:=
    WaitForMultipleObjects( _SemaphoreCount,
                            _PSemaphoreHandleArray,
                            WaitAll,
                            INFINITE )
    - WAIT_OBJECT_0;
  Result:= _PSemaphoreArray^[ WhichSem ];
{$endif}

end;

constructor TMutex.Create;
begin
{$ifdef os2}
  DosCreateMutexSem( nil, _Handle, 0, false );
{$else}
  _Handle:= CreateMutex( nil, false, nil );
{$endif}
end;

constructor TMutex.CreateNamed( const Name: string );
{$ifdef os2}
var
  CName: Cstring;
{$endif}
begin
{$ifdef os2}
  CName := Name;
  DosCreateMutexSem( CName, _Handle, 0, false );
{$else}
  _Handle:= CreateMutex( nil, false, PChar( Name ) );
{$endif}
end;

destructor TMutex.Destroy;
begin
{$ifdef os2}
  DosCloseMutexSem( _Handle );
{$else}
  CloseHandle( _Handle );
{$endif}
  inherited Destroy;
end;

procedure TMutex.Get;
begin
{$ifdef os2}
  DosRequestMutexSem( _Handle, SEM_INDEFINITE_WAIT );
{$else}
  WaitForSingleObject( _Handle, INFINITE );
{$endif}
end;

procedure TMutex.Release;
begin
{$ifdef os2}
  DosReleaseMutexSem( _Handle );
{$else}
  ReleaseMutex( _Handle );
{$endif}
end;

Initialization
End.

