Unit GenericThread;

Interface

uses
{$ifdef os2}
  os2def,
{$else}
  Controls,
{$endif}
  SysUtils, Classes, Messages,
  ACLUtility;

// Generic Thread Manager
// Simply place a TGenericThreadManager component on a form
//
// You can then call
//   StartJob( <function>, <parameterobject> );
// This will run <function> in the generic thread;
// You can pass parameters by passing an object reference
// (which can be cast to a pointer or longint or any object you like)
//  The job function must return an object (nil if you don't
//   have any data to return). This is passed to OnJobComplete
//
//   Note: the job function must be a method e.g. a function in a form.
//
//  Remember: once you call StartJob, you have *two* functions in
//  your code running at once! You should not use shared code
//  or variables; instead, call SendData and UpdateProgress (below).
//
// Use IsRunning to see if something is running in the thread
//
// Use Stop to ask the current job to stop
// - The job function you started, should check StopRequested
//   regularly to see if they should stop, and exit if so
// ForceStop asks the other thread to stop, like Stop,
//   but if the thread doesn't stop in the specified number
//   of seconds, it kills the thread. This will not free up memory
//   that the job function might have allocated
//
// If a job is running when the applicaiton shuts down,
//  (specifically, when the GenericThreadManager component is destroyed)
//  ForceStop is called with a 1 second timeout to make sure
//  the thread doesn't keep the app hanging around.
//  If you want to allow the job more time to stop, call ForceStop yourself
//  in a form close or similar.
//
// Your code can pass information from the job function to the main ithread
// by three events, which you can assign in the IDE:
//   OnJobComplete
//     This is called when a job function is finished.
//     Passes the result object that the job function returns.
//
//   OnProgressUpdate:
//     This is called whenever the job function calls UpdateProgress.
//     It allows you to conveniently pass a string message, and
//     and number out of a total (e.g. %, and 100)
//
//   OnDataFromThread:
//     This is a generalised way for the job function to send the main
//     thread any data it likes. The function should simply call SendData.
//     The first parameter is a string, the second is an object, which
//     can be cast to whatever you like. Pass nil if you just want to use the string.
//
//     Normally, you would allocate an object in the job function,
//     and free it in the handler for OnDataFromThread. You should not pass
//     any object that the job function destroys, because it might be destroyed
//     before the OnDataFromThread handler is called.
//
// Implementation Notes
//     In ForceStop we are not processing PM messages, so deadlock will result
//     if any callbacks are Synchronize'd. All callbacks are now protected
//     by checking to see if stop has been requested. However it is still possible
//     to deadlock if the callback happens at just the same time.

const
  WM_GENERICTHREADEVENT = WM_USER + 9721;
  
type
  TThreadJobProcedure = function( Parameters: TObject ): TObject of object;
  TJobCompleteEvent = procedure( Result: TObject ) of object;
  TThreadDataEvent = procedure( S: string; d: TObject ) of object;

type
  TThreadIdentifier =
{$ifdef os2}
    TID;
{$else}
    THandle;
{$endif}

  TGenericThreadManager = class;

  TGenericThread = class( TThread )
    FThreadManager: TGenericThreadManager;
    FJobProcedure: TThreadJobProcedure;
    FParameters: TObject;
    FResult: TObject;
    constructor Create( JobProcedure: TThreadJobProcedure;
                        Parameters: TObject );
    procedure Execute; override;
    function GetThreadIdentifier: TThreadIdentifier;
    property ThreadIdentifier: TThreadIdentifier read GetThreadIdentifier;
  end;

{  TCopyableObject = class( TObject )
    procedure CreateCopy( Source: TCopyableObject ); virtual; abstract;
  end;

  TGenericThreadEventMessage = packed record
    Msg: Cardinal;
    ThreadID: TThreadIdentifier;
    Data: TObject;
    Result: Longint;
  end;

  TGenericThreadWindow = class( TWinControl )
    procedure WMEvent( Var Message: TGenericThreadEventMessage );
      message WM_GENERICTHREADEVENT;
  end;}

  TGenericThreadManager = class( TComponent )
  protected
    FThread: TGenericThread;
    FStopRequested: boolean;

    // Notifications
    FOnJobComplete: TJobCompleteEvent;
    FOnProgressUpdate: TProgressCallback;
    FOnDataFromThread: TThreadDataEvent;

    // Thread notification variables
    FProgressN: longint;
    FProgressOutOf: longint;
    FProgressMessage: string;

    FDataString: string;
    FDataObject: TObject;

    FException: Exception;

    procedure OnThreadTerminate;
    procedure DoProgressUpdate;
    procedure DoSendData;
    procedure DoUnhandledException;
  public
{$ifdef os2}
    procedure SetupComponent; override;
{$else}
    constructor Create( Owner: TComponent ); override;
{$endif}
    destructor Destroy; override;

    procedure StartJob( JobProcedure: TThreadJobProcedure;
                        Parameters: TObject );
    function IsRunning: boolean;

    // Requests that the current thread (if any) should stop.
    procedure Stop;

    // Stops the current thread, kills it if it doesn't stop by
    // itself after TimeLimit
    procedure ForceStop( TimeLimit: longint );

    // Procedures running in the thread should check this regularly to see
    // if they should stop;
    function StopRequested: boolean;

    // Sends a progress update to the main thread; OnProgressUpdate is fired
    procedure UpdateProgress( n, outof: integer;
                              Message: string );
    // Sends a string and object to the main thread; OnDataFromThread is fired
    procedure SendData( s: string; d: TObject );

{    // Sends a string and object to the main thread;
    // returns immediately without waiting for the data to be processed.
    // OnDataFromThread is fired
    procedure PostData( s: string; d: TCopyableObject );}
  published
    property OnJobComplete: TJobCompleteEvent read FOnJobComplete write FOnJobComplete;
    property OnProgressUpdate: TProgressCallback read FOnProgressUpdate write FOnProgressUpdate;
    property OnDataFromThread: TThreadDataEvent read FOnDataFromThread write FOnDataFromThread;

  end;

{$ifdef win32}
procedure Register;
{$endif}

Implementation

uses
  Forms,
{$ifdef os2}
  Os2Def, BseDos, BseErr;
{$else}
  Windows;
{$endif}

{$ifdef win32}
type
  APIRET = DWORD;
{$endif}
   
constructor TGenericThread.Create( JobProcedure: TThreadJobProcedure;
                                   Parameters: TObject );
begin
  FJobProcedure := JobProcedure;
  FParameters := Parameters;
  inherited Create( true ); // create suspended
end;

procedure TGenericThread.Execute;
begin
  try
    FResult := FJobProcedure( FParameters );
  except
    on E: Exception do
    begin
      FThreadManager.FException := E;
      Synchronize( FThreadManager.DoUnhandledException );
    end;
  end;

  if FThreadManager.FStopRequested then
    // to prevent deadlock when stopping, dont try and call back (could be in forcestop)
    FThreadManager.FThread := nil // so threadmanager knows job is done
  else
    Synchronize( FThreadManager.OnThreadTerminate );

end;

function TGenericThread.GetThreadIdentifier: TThreadIdentifier;
begin
{$ifdef os2}
  Result := ThreadID;
{$else}
  Result := Handle;
{$endif}
end;

{// Generic Thread Window ------------------------
procedure TGenericThreadWindow.WMEvent( Var Message: TGenericThreadEventMessage );
begin
end;
}
// Thread Manager ------------------------

{$ifdef os2}
procedure TGenericThreadManager.SetupComponent;
begin
  inherited SetupComponent;
{$else}
constructor TGenericThreadManager.Create( Owner: TComponent );
begin
  inherited Create( Owner );
{$endif}

  FThread := nil;
  FStopRequested := false;

  FOnJobComplete := nil;
  FOnProgressUpdate := nil;
  FOnDataFromThread := nil;
end;

destructor TGenericThreadManager.Destroy;
begin
  inherited Destroy;
  if IsRunning then
    ForceStop( 1 );
end;

procedure TGenericThreadManager.StartJob( JobProcedure: TThreadJobProcedure;
                                          Parameters: TObject );
begin
  if FThread <> nil then
    exit;
  FStopRequested := false;
  FThread := TGenericThread.Create( JobProcedure, Parameters );
  FThread.OnTerminate := nil; // OnThreadTerminate; deadlockable
  FThread.FreeOnTerminate := true;
  FThread.FThreadManager := self;
  FThread.Resume;
end;

procedure TGenericThreadManager.OnThreadTerminate;
begin
  if Assigned( FOnJobComplete ) then
    FOnJobComplete( FThread.FResult );
  FThread := nil;
end;

function TGenericThreadManager.IsRunning: boolean;
begin
  Result := FThread <> nil;
end;

procedure TGenericThreadManager.Stop;
begin
  if IsRunning then
    FStopRequested := true;
end;

procedure TGenericThreadManager.ForceStop( TimeLimit: longint );
var
  ThreadID: TThreadIdentifier;
  rc: APIRET;
  TimeoutCount: longint;
begin
  if not IsRunning then
    exit;
  Stop;
  ThreadID := FThread.ThreadIdentifier;

  for TimeoutCount := 0 to TimeLimit * 10 do
  begin
{$ifdef os2}
    rc := DosWaitThread( ThreadID, DCWW_NOWAIT );
    if ( rc = 0 ) then
      exit; // thread has finished
    if ( rc <> ERROR_THREAD_NOT_TERMINATED ) then
      exit; // some other error
    // thread is still running
    DosSleep( 100 );
  end;
  // Thread still running after timeout, kill it
  DosKillThread( ThreadID );
{$else}
    rc := WaitForSingleObject( ThreadID, 0 );
    if ( rc = WAIT_OBJECT_0 ) then
      exit; // thread has finished
    if ( rc <> WAIT_TIMEOUT ) then
      exit; // some other error
    // thread is still running
    Sleep( 100 );
  end;
  // Thread still running after timeout, kill it
  TerminateThread( ThreadID, 1 );
{$endif}
end;

function TGenericThreadManager.StopRequested: boolean;
begin
  if FThread = nil then
  begin
    result := true; // shouldn't be here!
    exit;
  end;
  result := FStopRequested;

end;

procedure TGenericThreadManager.UpdateProgress( n, outof: integer;
                                                Message: string );
begin
  if FThread = nil then
    exit;
  if FStopRequested then
    // to prevent deadlock when stopping
    exit;
  FProgressN := N;
  FProgressOutOf := OutOf;
  FProgressMessage := Message;
  FThread.Synchronize( DoProgressUpdate );
end;

procedure TGenericThreadManager.DoProgressUpdate;
begin
  if not Assigned( FOnProgressUpdate ) then
    exit;

  FOnProgressUpdate( FProgressN,
                     FProgressOutOf,
                     FProgressMessage );
end;

procedure TGenericThreadManager.SendData( s: string; d: TObject );
begin
  if FThread = nil then
    exit;
  if FStopRequested then
    // to prevent deadlock when stopping
    exit;
  FDataString := S;
  FDataObject := d;
  FThread.Synchronize( DoSendData );
end;

procedure TGenericThreadManager.DoSendData;
begin
  if not Assigned( FOnDataFromThread ) then
    exit;

  FOnDataFromThread( FDataString,
                     FDataObject );
end;

procedure TGenericThreadManager.DoUnhandledException;
begin
  Application.OnException( self, FException );
end;

{procedure TGenericThreadManager.PostData( s: string; d: TCopyableObject );
begin
  if not ( Owner is TForm ) then
    raise Exception.Create( 'TGenericThreadManager.PostData: '
                            + 'Owner is not form, cannot post' );
end;
}

{$ifdef win32}
procedure Register;
begin
  RegisterComponents( 'ACL', [TGenericThreadManager] );
end;
{$endif}

End.
