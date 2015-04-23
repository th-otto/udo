Program ViewStub;

// Small stub program that uses the GlobalFilelist to decide
// whether to launch a new instance of newview.exe, or activate
// an existing one.

// Becomes view.exe.

Uses
  OS2def,
  PMShl,
  PmWin,
  SysUtils,
  Classes,
  DebugUnit,
  GlobalFilelistUnit,
  CmdLineParameterUnit,
  HelpManagerUnit,
  StringUtilsUnit,
  StartupUnit;

var
  Details: PROGDETAILS;
  Parameters: pchar;

Const
  Vendor = 'Aaron Lawrence, Ronald Brill';
  BldLevelVersion = '1.1.2';
  Description = 'NewView Stub';

  // BLDLevel - compatible - mostly
  EmbeddedVersion: string =
      '@#'
    + Vendor
    + ':'
    + BldLevelVersion
    + '#@'
    + Description
    + #0;

imports
  // Alternative declaration of WinStartApp with a more useful type for pszParams
  FUNCTION _WinStartApp(hwndNotify:HWND;VAR pDetails:PROGDETAILS;pszParams:pchar;
                     Reserved:POINTER;fbOptions:ULONG):HAPP;
                    APIENTRY;         'PMSHAPI' index 119;
end;

var
  tmpCmdLine : String;
  tmpPCharCmdLine : PChar;
  tmpCmdLineParameters: TCmdLineParameters;
  tmpExistingWindow: HWND;


  // If another instance already has the files open
  // activate it and return true.
  Function FindExistingWindow(aCmdLineParameters : TCmdLineParameters) : HWND;
  var
    tmpFilenames: TStringList;
    tmpFullFilePath: string;
    i: longint;
    tmpFileWindow: HWND;

  begin
    result := NULLHANDLE;

    if aCmdLineParameters.getFileNames(true) = '' then
    begin
      // not loading files; nothing to check
      exit;
    end;

    tmpFilenames := TStringList.Create;

    ParseAndExpandFileNames(aCmdLineParameters.getFileNames(true), tmpFilenames);

    for i := 0 to tmpFileNames.Count - 1 do
    begin
      LogEvent(LogStartup, 'Search in GlobalFileList for ''' + tmpFilenames[i] + '''');

      tmpFullFilePath := FindHelpFile( tmpFilenames[i] );
      if tmpFullFilePath <> '' then
      begin
        tmpFileWindow := GlobalFilelist.FindFile(tmpFullFilePath);

        if tmpFileWindow = NULLHANDLE then
        begin
          // not found - stop searching.
          Result := NULLHANDLE; // no match
          break;
        end;

        // found it
        LogEvent(LogStartup, 'Found in GlobalFileList for ''' + tmpFullFilePath + '''');

        // is it the same as any previous match?
        if Result <> NULLHANDLE then
        begin
          if tmpFileWindow <> Result then
          begin
            // no, so we don't have a match.
            // NOTE: We just excluded something: if the same file is
            // open in multiple windows then we may not check all combinations
            Result := NULLHANDLE; // no match
            break;
          end;
        end
        else
        begin
          // no match yet - store this one
          result := tmpFileWindow;
        end;
      end;
    end;

    tmpFilenames.Destroy;
  end;



Begin
  LogEvent(LogViewStub, 'Starting' );

  // open shared memory
  SharedMemory := AccessSharedMemory;

  // get access to the system-global filelist
  GlobalFilelist := TGlobalFilelist.Create;

  // parse parameters into Parameters object
  tmpCmdLine := nativeOS2GetCmdLineParameter;

  tmpCmdLineParameters := TCmdLineParameters.Create;
  tmpCmdLineParameters.parseCmdLine(tmpCmdLine);

  tmpExistingWindow := FindExistingWindow(tmpCmdLineParameters);

  if tmpExistingWindow = NULLHANDLE then
  begin
    // Want a new instance.
    LogEvent(LogViewStub, 'Starting a new NewView instance');

    tmpPCharCmdLine := StrAlloc(length(tmpCmdLine) + 1);
    StrPCopy(tmpPCharCmdLine, tmpCmdLine);

    LogEvent(LogViewStub, 'CmdLine for NewView exe: ' + tmpCmdLine);
    // set up details for launching newview
    With Details do
    begin
      Length := Sizeof( Details );
      progt.progc := PROG_PM;
      progt.fbVisible := SHE_VISIBLE;
      pszTitle := 'Help Viewer';
      pszExecutable := 'newview.exe';
      pszParameters := nil; // Parameters; // copy our parameters
      pszStartupDir := ''; // current dir
      pszIcon := nil; // default
      pszEnvironment := nil; // default
      swpInitial.fl := SWP_ACTIVATE;
      swpInitial.hwndInsertBehind := HWND_TOP;
    end;

    _WinStartApp( NULLHANDLE, // no notify window
                  Details,
                  tmpPCharCmdLine, // use these rather than Details parameters,
                              // cause PM was swallowing /? the other way!!
                  nil, // reserved
                  0 );

    StrDispose(tmpPCharCmdLine);
  end
  else
  begin
    // the file is already opend in a running instance
    LogEvent(LogViewStub, 'Adequate running NewView instance found');

    WinSetFocus( HWND_DESKTOP, tmpExistingWindow );

    // search and topic search
    // topic search is also handled this way
    // at the moment there is no support for a
    // seperate window message
    if not tmpCmdLineParameters.getGlobalSearchFlag
       AND (tmpCmdLineParameters.getSearchText <> '')
    then
    begin
      PostNewViewTextMessage( tmpExistingWindow,
                              NHM_SEARCH,
                              tmpCmdLineParameters.getSearchText);
    end;

    if tmpCmdLineParameters.getGlobalSearchFlag then
    begin
      PostNewViewTextMessage( tmpExistingWindow,
                              NHM_GLOBAL_SEARCH,
                              tmpCmdLineParameters.getSearchText);
    end;

    if tmpCmdLineParameters.getShowUsageFlag then
    begin
      WinPostMsg( tmpExistingWindow,
               NHM_SHOW_USAGE,
               0,
               0 );
    end;

    if tmpCmdLineParameters.getHelpManagerFlag then
    begin
      // tell the new help manager instance to talk to the
      // other viewer
      WinPostMsg( tmpCmdLineParameters.getHelpManagerWindow,
               NHM_VIEWER_READY,
               tmpExistingWindow,
               0 );
    end;

  end;

  // destroy global list
  GlobalFilelist.Destroy;

  tmpCmdLineParameters.Destroy;
  LogEvent(LogViewStub, 'Finished' );
End.
