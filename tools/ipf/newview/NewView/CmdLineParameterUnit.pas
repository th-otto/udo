Unit CmdLineParameterUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// Helper functions to address the command line parameters newview
// is started with

Interface

uses
  Os2Def,
  BseTib,
  BseDos,
  SysUtils,
  Classes,
  PMWIN,
  StringUtilsUnit,
  DebugUnit;

CONST
  ENV_DEBUG = 'NEWVIEW_DEBUG';


 TYPE EParsingFailed=CLASS(Exception);

 TYPE
     TWindowPosition = record
         left: longint;
         bottom: longint;
         width: longint;
         height: longint;
     end;
 TYPE
     TCmdLineParameters = class
     private
       commandLine : AnsiString;
       showUsageFlag : boolean;
       searchFlag : boolean;
       globalSearchFlag : boolean;
       language : string;
       showIndexFlag : boolean;
       helpManagerFlag : boolean;
       helpManagerWindow : HWND;
       windowPositionFlag: boolean;
       windowPosition: TWindowPosition;
       ownerWindow : integer;
       windowTitle : AnsiString;
       parsedFileNames : AnsiString;
       parsedRawFileNames : AnsiString;
       fileNames : AnsiString;
       parsedSearchText : AnsiString;
       searchText : AnsiString;
       debugEnabled : boolean;
       nhmDebugMessages : TStringList;  // for better debugging strange situations

       FUNCTION handleSwitchWithValue(const aSwitchString : String; const aSwitch : String; var aValue : String) : Boolean;
       PROCEDURE parseSwitch(const aSwitchString : String);
       PROPERTY getParsedFileNames : AnsiString read parsedFileNames;
       PROPERTY getParsedSearchText : AnsiString read parsedSearchText;

     public
       PROPERTY isDebugEnabled : boolean read debugEnabled;
       PROPERTY getShowUsageFlag : boolean read showUsageFlag;
       PROPERTY getSearchFlag : boolean read searchFlag;
       PROPERTY getGlobalSearchFlag : boolean read globalSearchFlag;
       PROPERTY getLanguage : string read language;
       PROPERTY getShowIndexFlag : boolean read showIndexFlag;
       PROPERTY getHelpManagerFlag : boolean read helpManagerFlag;
       FUNCTION setHelpManagerFlag(const aNewValue : boolean) : boolean;
       PROPERTY getHelpManagerWindow : HWND read helpManagerWindow;
       PROPERTY getWindowPositionFlag : boolean read windowPositionFlag;
       PROPERTY getWindowPosition : TWindowPosition read windowPosition;
       PROPERTY getOwnerWindow : integer read ownerWindow;
       PROPERTY getWindowTitle : AnsiString read windowTitle;
       PROPERTY getSearchText : AnsiString read searchText;

       FUNCTION getFileNames(const aShowNewViewHelpIfNoFileSpecifiedFlag : Boolean) : AnsiString;

       PROCEDURE writeDetailsTo(aStrings : TStrings);
       PROCEDURE logDetails;
       PROCEDURE parseCmdLine(const aCmdLineString : AnsiString);
       FUNCTION getOwnHelpFileName: String;
       PROCEDURE addNhmDebugMessage(const aString : String);
  end;


  // add all file name parts of aFileNameString to the result
  // check for containing environment vars
  // and include all help files if the environment var points
  // to a directory
  PROCEDURE ParseAndExpandFileNames(const aFileNameString: String; aResult: TStrings );


  // returns a string containing the whole
  // command line parametes
  FUNCTION nativeOS2GetCmdLineParameter : AnsiString;


Implementation
uses
  DOS,
  FileUtilsUnit,
  VersionUnit;

  PROCEDURE TCmdLineParameters.writeDetailsTo(aStrings : TStrings);
  var
    tmpWindowPosition : TWindowPosition;
    i : integer;
  begin
    aStrings.Add('---- Version ----');
    aStrings.Add('  ' + GetAppVersion);
    aStrings.Add('');

    aStrings.Add('---- Command Line ----');
    aStrings.Add('''' + commandLine + '''');
    aStrings.Add('isDebugEnabled: ' + boolToStr(isDebugEnabled));

    aStrings.Add('parsed infos:');
    aStrings.Add('  showUsageFlag: ' + boolToStr(getShowUsageFlag));
    aStrings.Add('  searchFlag: ' + boolToStr(getSearchFlag));
    aStrings.Add('  fileNames(true): ' + getFileNames(true));
    aStrings.Add('  fileNames(false): ' + getFileNames(false));
    aStrings.Add('  parsedFileNames: ' + getParsedFileNames);
    aStrings.Add('  searchText: ' + getSearchText);
    aStrings.Add('  parsedSearchText: ' + getParsedSearchText);
    aStrings.Add('  globalSearchFlag: ' + boolToStr(getGlobalSearchFlag));
    aStrings.Add('  language: ' + getLanguage);
    aStrings.Add('  showIndexFlag: ' + boolToStr(getShowIndexFlag));
    aStrings.Add('  helpManagerFlag: ' + boolToStr(getHelpManagerFlag));
    aStrings.Add('  helpManagerWindow: ' + LongWordToStr(getHelpManagerWindow));
    aStrings.Add('  windowPositionFlag: ' + boolToStr(getWindowPositionFlag));

    tmpWindowPosition := getWindowPosition;
    aStrings.Add('  windowPosition: '
                        + intToStr(tmpWindowPosition.left) + ', '
                        + intToStr(tmpWindowPosition.bottom) + ', '
                        + intToStr(tmpWindowPosition.width) + ', '
                        + intToStr(tmpWindowPosition.height)
                );
    aStrings.Add('  ownerWindow: ' + intToStr(getOwnerWindow));
    aStrings.Add('  windowTitle: ' + getWindowTitle);

    if nil <> nhmDebugMessages then
    begin
      aStrings.Add('');
      aStrings.Add('---- NHM DebugMessages ----');
      for i := 0 to nhmDebugMessages.count-1 do
      begin
        aStrings.Add('  ' + nhmDebugMessages[i]);
      end;
    end;

  end;


  PROCEDURE TCmdLineParameters.LogDetails;
  var
    tmpWindowPosition : TWindowPosition;
    i : integer;
  begin
    LogEvent(LogStartup, '''' + commandLine + '''');
    LogEvent(LogStartup, 'isDebugEnabled: ' + boolToStr(isDebugEnabled));
    LogEvent(LogStartup, 'parsed infos:');

    LogEvent(LogStartup, '  showUsageFlag: ' + boolToStr(getShowUsageFlag));
    LogEvent(LogStartup, '  searchFlag: ' + boolToStr(getSearchFlag));
    LogEvent(LogStartup, '  fileNames(true): ' + getFileNames(true));
    LogEvent(LogStartup, '  fileNames(false): ' + getFileNames(false));
    LogEvent(LogStartup, '  parsedFileNames: ' + getParsedFileNames);
    LogEvent(LogStartup, '  searchText: ' + getSearchText);
    LogEvent(LogStartup, '  parsedSearchText: ' + getParsedSearchText);
    LogEvent(LogStartup, '  globalSearchFlag: ' + boolToStr(getGlobalSearchFlag));
    LogEvent(LogStartup, '  language: ' + getLanguage);
    LogEvent(LogStartup, '  showIndexFlag: ' + boolToStr(getShowIndexFlag));
    LogEvent(LogStartup, '  helpManagerFlag: ' + boolToStr(getHelpManagerFlag));
    LogEvent(LogStartup, '  helpManagerWindow: ' + LongWordToStr(getHelpManagerWindow));
    LogEvent(LogStartup, '  windowPositionFlag: ' + boolToStr(getWindowPositionFlag));

    tmpWindowPosition := getWindowPosition;
    LogEvent(LogStartup, '  windowPosition: '
                        + intToStr(tmpWindowPosition.left) + ', '
                        + intToStr(tmpWindowPosition.bottom) + ', '
                        + intToStr(tmpWindowPosition.width) + ', '
                        + intToStr(tmpWindowPosition.height)
                );
    LogEvent(LogStartup, '  ownerWindow: ' + intToStr(getOwnerWindow));
    LogEvent(LogStartup, '  windowTitle: ' + getWindowTitle);

    if nil <> nhmDebugMessages then
    begin
      LogEvent(LogStartup, '');
      LogEvent(LogStartup, '---- NHM DebugMessages ----');
      for i := 0 to nhmDebugMessages.count-1 do
      begin
        LogEvent(LogStartup, '  ' + nhmDebugMessages[i]);
      end;
    end;

  end;


  Function TCmdLineParameters.setHelpManagerFlag(const aNewValue : boolean) : boolean;
  begin
       helpManagerFlag := aNewValue;
       result := helpManagerFlag;
  end;


  Procedure TCmdLineParameters.parseCmdLine(const aCmdLineString : AnsiString);
  var
    tmpState : (WHITESPACE, QUOTE, SWITCH, FILENAME, TEXT);
    tmpCurrentParsePosition : integer;
    tmpQuoted : boolean;
    tmpCurrentChar : char;
    tmpWhitespace : AnsiString;
    tmpQuote : AnsiString;
    tmpSwitch : AnsiString;
    tmpEnvDebug : String;
  begin
    // first adjust logging
    debugEnabled := false;
    tmpEnvDebug := GetEnv(ENV_DEBUG);

    if tmpEnvDebug <> '' then
    begin
      debugEnabled := true;
      SetLogAspects(tmpEnvDebug);
    end;

    LogEvent(LogStartup, 'ParseCommandLine: "' + aCmdLineString + '"');

    // store the original string for debugging
    commandLine := aCmdLineString;

    // reset the whole object
    showUsageFlag := false;
    searchFlag := false;
    globalSearchFlag := false;
    language := '';
    showIndexFlag := false;
    helpManagerFlag := false;
    helpManagerWindow := 0;
    windowPositionFlag := false;
    ownerWindow := 0;
    windowTitle := '';
    parsedSearchText := '';
    parsedFileNames := '';
    parsedRawFileNames := '';

    try
      // start parsing
      tmpState := WHITESPACE;
      tmpWhitespace := '';
      tmpSwitch := '';
      tmpQuote := '';
      tmpQuoted := false;
      tmpCurrentParsePosition := 1;
      while tmpCurrentParsePosition <= length(aCmdLineString) do
      begin
        tmpCurrentChar := aCmdLineString[tmpCurrentParsePosition];

        Case tmpCurrentChar of
          ' ' :
          begin
            Case tmpState of

              WHITESPACE :
              begin
                tmpWhitespace := tmpWhitespace + tmpCurrentChar;
              end;

              QUOTE :
              begin
                tmpQuote := tmpQuote + tmpCurrentChar;
              end;

              SWITCH :
              begin
                if tmpQuoted then
                begin
                  tmpSwitch := tmpSwitch + tmpCurrentChar;
                end
                else
                begin
                  parseSwitch(tmpSwitch);
                  tmpState := WHITESPACE;
                  tmpWhitespace := tmpCurrentChar;
                end
              end;

              FILENAME :
              begin
                if tmpQuoted then
                begin
                  parsedFileNames := parsedFileNames + tmpCurrentChar;
                  parsedRawFileNames := parsedRawFileNames + tmpCurrentChar;
                end
                else
                begin
                  tmpState := WHITESPACE;
                  tmpWhitespace := tmpCurrentChar;
                end
              end;

              TEXT :
              begin
                if tmpQuoted then
                begin
                  parsedSearchText := parsedSearchText + tmpCurrentChar;
                end
                else
                begin
                  tmpState := WHITESPACE;
                  tmpWhitespace := tmpCurrentChar;
                end
              end;
            end;
          end;

          '/', '-' :
          begin
            Case tmpState of
              WHITESPACE :
              begin
                tmpState := SWITCH;
                tmpSwitch := '';
              end;

              QUOTE :
              begin
                tmpState := SWITCH;
                tmpSwitch := '';
              end;

              SWITCH :
              begin
                parseSwitch(tmpSwitch);
                tmpSwitch := '';
              end;

              FILENAME :
              begin
                parsedFileNames := parsedFileNames + tmpCurrentChar;
                parsedRawFileNames := parsedRawFileNames + tmpCurrentChar;
              end;

              TEXT :
              begin
                parsedSearchText := parsedSearchText + tmpCurrentChar;
              end;
            end;
          end;

          '"' :
          begin
            if tmpQuoted then
            begin
              tmpQuoted := false;
              Case tmpState of
                FILENAME :
                begin
                  parsedRawFileNames := parsedRawFileNames + tmpCurrentChar;
                end;
                TEXT :
                begin
                  parsedSearchText := parsedSearchText + tmpCurrentChar;
                end;
              end;
            end
            else
            begin
              tmpQuoted := true;
              Case tmpState of
                WHITESPACE :
                begin
                  tmpState := QUOTE;
                  tmpQuote := tmpCurrentChar;
                end;
                FILENAME :
                begin
                  parsedRawFileNames := parsedRawFileNames + tmpCurrentChar;
                end;
              end;
            end;
          end;

          // any other char
          else
          begin
            Case tmpState of

              WHITESPACE :
              begin
                if length(parsedFileNames) > 0 then
                begin
                  tmpState := TEXT;
                  parsedSearchText := parsedSearchText + tmpWhitespace + tmpCurrentChar;
                end
                else
                begin
                  tmpState := FILENAME;
                  parsedFileNames := parsedFileNames + tmpCurrentChar;
                  parsedRawFileNames := parsedRawFileNames + tmpCurrentChar;
                end;
              end;

              QUOTE :
              begin
                if length(parsedFileNames) > 0 then
                begin
                  tmpState := TEXT;
                  parsedSearchText := parsedSearchText + tmpQuote + tmpCurrentChar;
                end
                else
                begin
                  tmpState := FILENAME;
                  parsedFileNames := parsedFileNames + tmpCurrentChar;
                  parsedRawFileNames := parsedRawFileNames + tmpQuote + tmpCurrentChar;
                end;
              end;

              SWITCH :
              begin
                tmpSwitch := tmpSwitch + tmpCurrentChar;
              end;

              FILENAME :
              begin
                parsedFileNames := parsedFileNames + tmpCurrentChar;
                parsedRawFileNames := parsedRawFileNames + tmpCurrentChar;
              end;

              TEXT :
              begin
                parsedSearchText := parsedSearchText + tmpCurrentChar;
              end;
            end;
          end;
        end;
        inc(tmpCurrentParsePosition);
      end;

      // ok all chars are processed, but maybe we have something to do
      Case tmpState of
        SWITCH :
        begin
          parseSwitch(tmpSwitch);
        end;
      end;
    except
        on e:EParsingFailed do
        begin
          showUsageFlag := true;
        end;
    end;

    // remove blanks
    fileNames := AnsiStrTrim(getParsedFileNames);
    searchText := AnsiStrTrim(getParsedSearchText);

    if getGlobalSearchFlag
       AND (getParsedSearchText = '')
    then
    begin
      fileNames := '';
      searchText := parsedRawFileNames;
    end;

    // to be compatible with the old one we have to ignore
    // the quotes
    if not getGlobalSearchFlag
       AND (not getSearchFlag)
    then
    begin
      searchText := AnsiStrTrimChars(searchText, ['"']);
    end;

    LogEvent(LogStartup, 'Parameters parsed');
    LogDetails;
  end;


  Function TCmdLineParameters.handleSwitchWithValue(const aSwitchString : String; const aSwitch : String; var aValue : String) : Boolean;
  var
    tmpText : String;
    tmpValueStartPos : integer;
    tmpSwitchLength : integer;
  begin
    tmpSwitchLength := Length(aSwitch);
    tmpText := copy(aSwitchString, 1, tmpSwitchLength);
    tmpText := lowercase(tmpText);

    if (lowercase(aSwitch) = tmpText) then
    begin
      tmpValueStartPos := tmpSwitchLength;
      inc(tmpValueStartPos);
      if aSwitchString[tmpValueStartPos] = ':' then
      begin
        inc(tmpValueStartPos);
      end;

      aValue := copy(aSwitchString, tmpValueStartPos, Length(aSwitchString) - tmpValueStartPos+ 1);
      result := true;
      exit;
    end;
    result := false;
  end;


  Function ParseWindowPositionPart(const aPart: String; const aScreenDimension: longint): longint;
  Var
    tmpPart : String;
  Begin
    if aPart = '' then
      raise EParsingFailed.Create('Missing position element');

    if StrEndsWithIgnoringCase(aPart, 'P') then
    begin
      tmpPart := copy(aPart, 1, length(aPart)-1);
      if tmpPart = '' then
        raise EParsingFailed.Create('Missing position element');

      Result := StrToInt(tmpPart);
      if Result < 0 then
        Result := 0;
      if Result > 100 then
        Result := 100;
      Result := Round(Result / 100 * aScreenDimension);
    end
    else
    begin
      Result := StrToInt(aPart);
    end;
  end;

  Function ParseWindowPosition(const aParamValue: String): TWindowPosition;
  Var
    tmpParts : TStringList;
    tmpScreenWidth : longint;
    tmpScreenHeight : longint;
  Begin
    tmpParts := TStringList.Create;
    StrExtractStrings(tmpParts, aParamValue, [','], '\');

    tmpScreenWidth := WinQuerySysValue(HWND_DESKTOP, SV_CXSCREEN);
    tmpScreenHeight := WinQuerySysValue(HWND_DESKTOP, SV_CYSCREEN);

    result.Left := ParseWindowPositionPart(tmpParts[0], tmpScreenWidth);
    result.Bottom := ParseWindowPositionPart(tmpParts[1], tmpScreenHeight);

    result.Width := ParseWindowPositionPart(tmpParts[2], tmpScreenWidth);
    if result.Width < 50 then
      result.Width := 50;

    result.Height := ParseWindowPositionPart(tmpParts[3], tmpScreenHeight);
    if result.Height < 50 then
      result.Height := 50;

    tmpParts.Destroy;
  end;


  Procedure TCmdLineParameters.parseSwitch(const aSwitchString : String);
  var
    tmpCurrentChar : char;
    tmpValue : String;
  begin
    // lang
    if handleSwitchWithValue(aSwitchString, 'lang', tmpValue) then
    begin
      language := tmpValue;
      exit;
    end;

    // title
    if handleSwitchWithValue(aSwitchString, 'title', tmpValue) then
    begin
      windowTitle := tmpValue;
      exit;
    end;

    // HM
    if handleSwitchWithValue(aSwitchString, 'hm', tmpValue) then
    begin
      try
        helpManagerWindow := StrToInt(tmpValue);
        helpManagerFlag := true;
      except
        on e:Exception do
        begin
          showUsageFlag := true;
        end;
      end;
      exit;
    end;

    // owner
    if handleSwitchWithValue(aSwitchString, 'owner', tmpValue) then
    begin
      try
        ownerWindow := StrToInt(tmpValue);
      except
        on e:Exception do
        begin
          showUsageFlag := true;
        end;
      end;
      exit;
    end;

    // pos
    if handleSwitchWithValue(aSwitchString, 'pos', tmpValue) then
    begin
      windowPosition := ParseWindowPosition(tmpValue);
      windowPositionFlag := true;
      exit;
    end;

    // check the next char
    // TODO check for other invalid chars
    tmpCurrentChar := aSwitchString[1];
    Case tmpCurrentChar of
      'h', 'H', '?' :
        begin
          showUsageFlag := true;
        end;

      's', 'S' :
        begin
          searchFlag := true;
        end;

      'i', 'I' :
        begin
          showIndexFlag := true;
        end;

      'g', 'G' :
        begin
          globalSearchFlag := true;
        end;

      else
        begin
          raise EParsingFailed.Create('Unsupported switch');
        end;
      end;
  end;


  FUNCTION TCmdLineParameters.getFileNames(const aShowNewViewHelpIfNoFileSpecifiedFlag : Boolean) : AnsiString;
  var
    tmpOwnHelpFileName : String;
  begin
    // user hasn't requested any particular file
    // at startup, so if the option is set,
    // load the NewView help file
    if aShowNewViewHelpIfNoFileSpecifiedFlag
       AND (fileNames = '')
       AND not getGlobalSearchFlag then
    begin
      tmpOwnHelpFileName := getOwnHelpFileName;
      if FileExists(tmpOwnHelpFileName) then
      begin
        result := tmpOwnHelpFileName;
      end;
    end
    else
    begin
      result := fileNames;
    end;
  end;


  FUNCTION TCmdLineParameters.getOwnHelpFileName: String;
  var
    tmpLanguage : String;
  begin
    tmpLanguage := getLanguage;
    if tmpLanguage = '' then
    begin
      tmpLanguage := GetEnv(LanguageEnvironmentVar)
    end;

    result := FindDefaultLanguageHelpFile('NewView', tmpLanguage);
  end;


  PROCEDURE TCmdLineParameters.addNhmDebugMessage(const aString : String);
  begin
    if nil = nhmDebugMessages then
    begin
      nhmDebugMessages := TStringList.Create;
    end;

    nhmDebugMessages.add(aString);
  end;


  PROCEDURE ParseAndExpandFileNames(const aFileNameString : String; aResult: TStrings);
  var
    i : longint;
    tmpFileNamesList: TStringList;
    tmpItem: String;
    tmpEnvironmentVarValue: string;
  begin
    LogEvent(LogDebug, 'ParseAndExpandFileNames "' + aFileNameString + '"');

    tmpFileNamesList := TStringList.Create;

    StrExtractStrings(tmpFileNamesList, aFileNameString, [HELP_FILE_DELIMITER, PATH_SEPARATOR], #0);
    for i := 0 to tmpFileNamesList.Count - 1 do
    begin
      tmpItem := tmpFileNamesList[i];

      // is this a environment var
      tmpEnvironmentVarValue := GetEnv(tmpItem);
      if DosError = 0 then
      begin
        // environment var exists
        LogEvent(LogStartup, '    Environment var found; translated to: "' + tmpEnvironmentVarValue + '"');
        ParseAndExpandFileNames(tmpEnvironmentVarValue, aResult);
      end
      else if DirectoryExists(tmpItem) then
      begin
        ListFilesInDirectory(tmpItem, '*' + HELP_FILE_EXTENSION, true, aResult);
      end
      else
      begin
        aResult.Add(tmpItem);
      end;
    end;

    tmpFileNamesList.Destroy;
  end;


  FUNCTION nativeOS2GetCmdLineParameter : AnsiString;
  VAR
    tmpPtib : PTIB;       // thread information block
    tmpPpib : PPIB;       // process information block
    tmpCmd  : PCHAR;
    tmpParams : PCHAR;

  BEGIN
    // ask the system
    DosGetInfoBlocks(tmpPtib, tmpPpib);
    tmpCmd := tmpPpib^.pib_pchcmd;
    // the fist element (null terminated) is the
    // called command itself
    // skip to the next null terminated string
    // these are the parameters
    tmpParams := tmpCmd + StrLen(tmpCmd) + 1;

    result := '';
    AnsiSetString(result, tmpParams, StrLen(tmpParams));
  END;


END.
