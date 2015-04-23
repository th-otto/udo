Unit DebugUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// Helper functions for debugging

Interface


uses
  Classes,
  OS2Def,
  PMWin,
  SysUtils;


  // -- Logging --
  Type
    LogAspect = (       LogStartup,
                        LogShutdown,
                        LogSettings,
                        LogI18n,
                        LogParse,
                        LogDisplay,
                        LogSearch,
                        LogNHM,
                        LogViewStub,
                        LogObjConstDest,
                        LogDebug
    );
    LogAspects = SET OF LogAspect;

  Procedure LogEvent(const aLogAspect: LogAspect; const anEventDescription: String);


  // -- Profiling --

  // Starts the timer
  Procedure PrfStartTimer;

  // Stops the timer
  Procedure PrfStopTimer;

  // Writes the eventDesctiption together with
  // the time since timer start to PMPrintF
  // Procedure PrfTraceEvent(const anEventDescription: String);

  Procedure SetLogAspects(const aCommaSeparatedListOfAspectNames : String);

  Procedure writeDebugSetupDetailsTo(aStrings : TStrings);


var
  startTime : ULONG;
  lastTime : ULONG;
  PMPrintfModuleHandle : HMODULE;
  PMPrintfString : Function(aString : PChar) : ULONG; APIENTRY;
  activeLogAspects : LogAspects;
  infoMessage1 : String;
  infoMessage2 : String;



Implementation

uses
  BseDos,
  StringUtilsUnit;

  Procedure writeDebugSetupDetailsTo(aStrings : TStrings);
  begin
    aStrings.Add('---- Debug ----');
    aStrings.Add('  ' + infoMessage1);
    aStrings.Add('  ' + infoMessage2);
  end;


  FUNCTION LoadPMPrinfFLib : integer;
  Var
    tmpDllName : CString;
    tmpErrorInfo : CString;
    tmpProcedureName : CSTRING;
    tmpProcedureAddress : POINTER;
    tmpRC : APIRET;

  begin
    PMPrintfString := nil;

    tmpDllName:='PMPRINTF';
    tmpRC := DosLoadModule(tmpErrorInfo, 255, tmpDllName, PMPrintfModuleHandle);
    infoMessage1 := 'DosLoadModule ' + tmpDllName + ' rc: ' + IntToStr(tmpRC);
    if tmpRC <> 0 then
    begin
        PMPrintfModuleHandle := 0;
        result := 0;
        exit;
    end;

    tmpProcedureName := 'PmPrintfString';
    tmpRC := DosQueryProcAddr(PMPrintfModuleHandle, 0, tmpProcedureName, tmpProcedureAddress);
    infoMessage2 := 'DosQueryProcAddr ' + tmpProcedureName + ' rc: ' + IntToStr(tmpRC);
    if tmpRC <> 0 then
    begin
      DosFreeModule(PMPrintfModuleHandle);
      PMPrintfModuleHandle := 0;
      result := 0;
      exit;
    end;

    PMPrintfString := tmpProcedureAddress;
    result := 0;
  end;


  Procedure PMPrintf(const aString : String);
  Var
    tmpPCharMessage : PChar;
  Begin
    if (0 <> PMPrintfModuleHandle) then
    begin
      tmpPCharMessage := StrAlloc(length(aString) + 1);
      StrPCopy(tmpPCharMessage, aString);

      PmPrintfString(tmpPCharMessage);

      StrDispose(tmpPCharMessage);
    end;
  end;


  Function GetAspectPrefix(const aLogAspect: LogAspect): String;
  Begin
    Case aLogAspect of
      LogStartup      : result := 'Startup';
      LogShutdown     : result := 'Start';
      LogSettings     : result := 'Settings';
      LogI18n         : result := 'I18n';
      LogParse        : result := 'Parse';
      LogDisplay      : result := 'Display';
      LogSearch       : result := 'Search';
      LogNHM          : result := 'NewHelpManager';
      LogViewStub     : result := 'ViewStub';
      LogObjConstDest : result := 'ObjConstDest';
      LogDebug        : result := 'Debug';
      else              result := 'Unknown';
      end;
  End;


  Procedure SetLogAspects(const aCommaSeparatedListOfAspectNames : String);
  Var
    tmpAspects : TStringList;
    i : Integer;
  Begin
    tmpAspects := TStringList.Create;
    StrExtractStrings(tmpAspects, aCommaSeparatedListOfAspectNames, [','], #0);

    for i:=0 to tmpAspects.count-1 do
    begin
      if tmpAspects[i] = 'LogStartup'      then activeLogAspects := activeLogAspects + [ LogStartup ];
      if tmpAspects[i] = 'LogShutdown'     then activeLogAspects := activeLogAspects + [ LogShutdown ];
      if tmpAspects[i] = 'LogSettings'     then activeLogAspects := activeLogAspects + [ LogSettings ];
      if tmpAspects[i] = 'LogI18n'         then activeLogAspects := activeLogAspects + [ LogI18n ];
      if tmpAspects[i] = 'LogParse'        then activeLogAspects := activeLogAspects + [ LogParse ];
      if tmpAspects[i] = 'LogDisplay'      then activeLogAspects := activeLogAspects + [ LogDisplay ];
      if tmpAspects[i] = 'LogSearch'       then activeLogAspects := activeLogAspects + [ LogSearch ];
      if tmpAspects[i] = 'LogNHM'          then activeLogAspects := activeLogAspects + [ LogNHM ];
      if tmpAspects[i] = 'LogViewStub'     then activeLogAspects := activeLogAspects + [ LogViewStub ];
      if tmpAspects[i] = 'LogObjConstDest' then activeLogAspects := activeLogAspects + [ LogObjConstDest ];
      if tmpAspects[i] = 'LogDebug'        then activeLogAspects := activeLogAspects + [ LogDebug ];
    end;

    tmpAspects.Destroy;
  End;


  Procedure LogEvent(const aLogAspect: LogAspect; const anEventDescription: String);
  Var
    tmpMessage : String;
  Begin
    if (aLogAspect IN activeLogAspects) then
    begin
      tmpMessage := 'Log[' + GetAspectPrefix(aLogAspect) + ']  ' + anEventDescription;
      PmPrintf(tmpMessage);
    end;
  end;


  Function GetSystemMSCount: ULONG;
  Begin
    result:= WinGetCurrentTime(AppHandle);
  End;


  Procedure PrfStartTimer;
  Begin
    startTime := GetSystemMSCount;
    lastTime := startTime;
  End;


  Procedure PrfStopTimer;
  Begin
  End;


  Procedure PrfTraceEvent(const anEventDescription: String);
  Var
    tmpTime : ULONG;
    tmpMessage : String;
  Begin
    tmpTime := GetSystemMSCount;
    tmpMessage := 'Prf: ' + IntToStr(tmpTime - lastTime) + 'ms ' + anEventDescription + IntToStr(tmpTime - startTime) + 'ms since start';

    PMPrintf(tmpMessage);

    lastTime := GetSystemMSCount;
  end;


  Initialization
    LoadPMPrinfFLib;
END.
