unit RunProgramUnit;

interface

Uses
{$ifdef os2}
  OS2Def, BseDos, Dos, BseErr,
{$endif}
{$ifdef win32}
  Windows,
{$endif}
  Forms,
  ACLUtility;

type
{$ifdef os2}
  TProgramHandle = ULONG;
{$endif}
{$ifdef win32}
  APIRET = DWORD;
  TProgramHandle = THandle;
{$endif}

// Runs a program in the given working directory.
// If PrintOutput is assigned,  StdOut (and StdErr) will be piped to it.

// If CheckTerminateCallback is assigned, it will be called regularly and if the
// process should be terminated, it should return true

// Function returns 0 if the program was started OK.
// Otherwise an OS error code.
// ResultCode is set to 1 if the program did not start, otherwise
// the exit code of the process
Function RunProgram( ProgramName: string;
                     Parameters: string;
                     WorkingDir: string;
                     Var ResultCode: APIRET;
                     TerminateCheck: TTerminateCheck;
                     PrintOutput: TPrintOutput
                   ): APIRET;

{$ifdef os2}
// Lauches given program and immediately returns.
// If successful in launching, returns 0 otherwise OS error code.
// If successful, ProgramHandle can be used to operate on the program.
Function LaunchProgram( ProgramName: string;
                        Parameters: string;
                        WorkingDir: string ): APIRET;
{$endif}

implementation

Uses
  SysUtils;

{$ifdef os2}
type
  TermQResults=record
    SessionID: WORD;
    ResultCode: WORD;
    end;
{$endif}

Function RunProgram( ProgramName: string;
                     Parameters: string;
                     WorkingDir: string;
                     Var ResultCode: APIRET;
                     TerminateCheck: TTerminateCheck;
                     PrintOutput: TPrintOutput
                   ): APIRET;
{$ifdef win32}
Const
  PipeBufferSize = 10000;
  PipeName = '\\.\pipe\myoutputpipe';
Var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  rc: DWORD;
  NameAndArgs: string;

  pipeServer: hFile;
  buffer: array[ 0..PipeBufferSize ] of char;
  bytesRead: DWORD;
  SecAttrs: TSecurityAttributes;
  pipeClient: hFile;
Begin

  pipeServer := 0;
  pipeClient := 0;
  try
    NameAndArgs := ProgramName+' '+Parameters;

    // Initialize some variables to create a process
    ZeroMemory( @StartupInfo, SizeOf( StartupInfo ) );

    StartupInfo.cb := SizeOf( StartupInfo );
    StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_HIDE;

    if Assigned( PrintOutput ) then
    begin
      // Allow the started process to inherit our handles
      FillChar( SecAttrs, SizeOf( SecAttrs ), #0);
      SecAttrs.nLength              := SizeOf(SecAttrs);
      SecAttrs.lpSecurityDescriptor := nil;
      SecAttrs.bInheritHandle       := TRUE;

      // Create a pipe
      pipeServer := CreateNamedPipe( PipeName,
                                     PIPE_ACCESS_DUPLEX,
                                     PIPE_TYPE_BYTE or PIPE_NOWAIT,
                                     PIPE_UNLIMITED_INSTANCES,
                                     PipeBufferSize, //out buffer
                                     PipeBufferSize, // in buffer
                                     100, // default timeout (ms)
                                     Addr( SecAttrs ) );

      // Get a handle to the other (client) end of the pipe
      pipeClient := CreateFile( PipeName,
                                GENERIC_READ or GENERIC_WRITE,
                                FILE_SHARE_READ or FILE_SHARE_WRITE,
                                Addr( SecAttrs ),
                                OPEN_EXISTING,
                                FILE_ATTRIBUTE_NORMAL,
                                0 );

      // setup the process to write into the other end
      StartupInfo.hStdOutput := pipeClient;
      StartupInfo.hStdError := pipeClient;
    end;

    // Create the process
    if not CreateProcess( Nil, // use next param for exe name
                          PChar( NameAndArgs ), // command line
                          Nil, // no security attributes
                          Nil, // no thread security attributes
                          True, // do inherit handles
                          CREATE_NEW_PROCESS_GROUP, // so we can send
                          // it Ctrl signals
                          Nil, // no new environment
                          PChar( WorkingDir ), // directory
                          StartupInfo,
                          ProcessInfo ) then
    begin
      Result := GetLastError;
      PrintOutput( 'Could not run '+NameAndArgs );
      PrintOutput( 'Windows error text: ' + GetAPIErrorString( Result ) );
      ResultCode := 1;
      exit;
    end;

    while true do
    begin
      if Assigned( TerminateCheck ) then
        if TerminateCheck then
        begin
          GenerateConsoleCtrlEvent( CTRL_BREAK_EVENT, ProcessInfo.dwProcessID );
          ResultCode := 1;
          Result := 0;
          exit;
        end;

      // Wait 1 second to see if it finishes...
      rc := WaitForSingleObject( ProcessInfo.hProcess, 1000 );

      if Assigned( PrintOutput ) then
      begin
        repeat
          // Read the output from our end of the pipe
          ReadFile( pipeServer,
                    buffer,
                    PipeBufferSize,
                    bytesRead,
                    nil );
          buffer[ bytesRead ] := #0; // null terminate
          if bytesRead > 0 then
            PrintOutput( buffer );

        until bytesRead = 0;

      end;

      if rc <> WAIT_TIMEOUT then
      begin
        // finished
        GetExitCodeProcess( ProcessInfo.hProcess,
                            ResultCode );
        Result := 0;
        // terminate loop
        exit;
      end;
    end;
  finally
    if pipeClient <> 0 then
      CloseHandle( pipeClient );
    if pipeServer <> 0 then
      CloseHandle( pipeServer );
  end;

end;
{$endif}

{$ifdef os2}
Var
  psd: STARTDATA;
  SessID: LONGWORD;
  apid: LONGWORD;
  PgmName: CSTRING;
  ObjBuf: CSTRING;
  rc: Integer;

  Args: CSTRING;

  TerminationQueue:HQueue;
  QueueName: CSTRING;
  QueueRequest: REQUESTDATA;
  DataLength: ULONG;
  DataAddress: ^TermQResults;
  ElementCode: ULONG;
  NoWait: BOOL;
  ElemPriority: BYTE;
  SemName: CString;
  SemHandle: HEV;

  SemPostCount: ULONG;
Begin
  QueueName := '\QUEUES\SIBYL_EXECUTE_TERMQ'
               + IntToStr( GetCurrentProcessID );
  rc := DosCreateQueue( TerminationQueue,
                        QUE_FIFO, // normal queue
                        QueueName );
  if rc <> 0 then
  begin
    Result := rc;
    exit;
  end;

  psd.Length := SizeOf( psd );
  psd.Related := SSF_RELATED_CHILD; // yes we want to know about it
  psd.FgBg := SSF_FGBG_FORE; // run in foreground
  psd.TraceOpt := SSF_TRACEOPT_NONE; // no tracing!

  PgmName := ProgramName; // copy to a cstring
  psd.PgmName := @PgmName; // program
  psd.PgmTitle := @PgmName; // window title

  Args :=parameters; // copy to a cstring
  psd.PgmInputs := @Args;  //arguments
  psd.TermQ := @QueueName; // Termination Queue name
  psd.Environment := NIL; // no special environment to pass
  psd.InheritOpt := SSF_INHERTOPT_PARENT;
    // use parent file handles
    // AND (more importantly) parent's current drive and dir
  psd.SessionType := SSF_TYPE_DEFAULT; // whatever the exe says
  psd.IconFile := NIL; // no icon file
  psd.PgmHandle := 0; // no program handle
  psd.PgmControl := 0; // SSF_CONTROL_MINIMIZE; // run minimized
  psd.InitXPos := 0; // position x
  psd.InitYPos := 0; // position y
  psd.Reserved := 0; // blah
  psd.ObjectBuffer := @ObjBuf; // put errors here
  psd.ObjectBuffLen := 100; // up to 100 chars

  rc := DosStartSession(  psd, SessID, apid );

  if     ( rc <> 0 )
     // but we don't care if it just started in the background!
     and ( rc <> ERROR_SMG_START_IN_BACKGROUND )
     then
  begin
    Result := rc;
    DosCloseQueue( TerminationQueue );
    exit;
  end;

  // DosCloseQueue( TerminationQueue );
  // exit;

  // create a semaphore so we can check the queue!!
  SemName := '\SEM32\SIBYL_EXECUTE_TERMQ'
             + IntToStr( GetCurrentProcessID );
  rc := DosCreateEventSem( SemName,
                           SemHandle,
                           0,
                           FALSE );
  if ( rc <> 0 ) then
  begin
    Result := rc;
    DosCloseQueue( TerminationQueue );
    exit;
  end;

  // OK, we started it
  Result := 0;

  ElementCode := 0; // get element at front of queue
  NoWait := True; // don't wait for data: so we supply semaphore instead

  // assocaite the semaphore with the queue, don't remove item if it's already there
  rc := DosPeekQueue( TerminationQueue,
                      QueueRequest,
                      DataLength,
                      DataAddress,
                      ElementCode,
                      NoWait,
                      ElemPriority,
                      SemHandle );

  repeat
    rc := DosQueryEventSem( SemHandle, SemPostCount );

    // Handle PM messages (including to our own app!)
    Application.ProcessMessages;

    // Give up CPU briefly so we don't appear too greedy when idle.
    DosSleep( 1 );

  until SemPostCount > 0; // until semaphore is posted, indicating an item in the TermQ

  // The program has terminated.
  // Now read the item
  rc := DosReadQueue( TerminationQueue,
                      QueueRequest,
                      DataLength,
                      DataAddress,
                      ElementCode,
                      NoWait,
                      ElemPriority,
                      SemHandle );

  ResultCode := DataAddress^.ResultCode;
  DosCloseQueue( TerminationQueue );
  // Free the memory used by the queue element
  DosFreeMem( DataAddress );

  // Close semaphore
  DosCloseEventSem( SemHandle );

End;

{$endif}

{$ifdef os2}
Function LaunchProgram( ProgramName: string;
                        Parameters: string;
                        WorkingDir: string ): APIRET;
Var
  psd: STARTDATA;
  apid: LONGWORD;
  PgmName: CSTRING;
  ObjBuf: CSTRING;
  rc: Integer;

  Args: CSTRING;
  ProgramHandle: TProgramHandle;
Begin
  psd.Length := SizeOf( psd );
  psd.Related := SSF_RELATED_INDEPENDENT; // don't want to know about it or own it
  psd.FgBg := SSF_FGBG_FORE; // run in foreground
  psd.TraceOpt := SSF_TRACEOPT_NONE; // no tracing!

  PgmName := ProgramName; // copy to a cstring
  psd.PgmName := @PgmName; // program
  psd.PgmTitle := @PgmName; // window title

  Args := parameters; // copy to a cstring
  psd.PgmInputs := @Args;  //arguments
  psd.TermQ := nil; // Termination Queue name
  psd.Environment := NIL; // no special environment to pass
  psd.InheritOpt := SSF_INHERTOPT_PARENT;
    // use parent file handles
    // AND (more importantly) parent's current drive and dir
  psd.SessionType := SSF_TYPE_DEFAULT; // whatever the exe says
  psd.IconFile := NIL; // no icon file
  psd.PgmHandle := 0; // no program handle
  psd.PgmControl := 0; // SSF_CONTROL_MINIMIZE; // run minimized
  psd.InitXPos := 0; // position x
  psd.InitYPos := 0; // position y
  psd.Reserved := 0; // blah
  psd.ObjectBuffer := @ObjBuf; // put errors here
  psd.ObjectBuffLen := 100; // up to 100 chars

  rc := DosStartSession(  psd, ProgramHandle, apid );

  // we don't care if it just started in the background!
  if rc = ERROR_SMG_START_IN_BACKGROUND then
    rc := 0;
end;
{$endif}

end.
