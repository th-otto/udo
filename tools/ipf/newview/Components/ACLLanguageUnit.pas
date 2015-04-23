Unit ACLLanguageUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003-2006 Aaron Lawrence
// Copyright 2006-2007 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// Helper functions for i18n

Interface

uses
  OS2Def,
  Classes,
  Forms,
  FileUtilsUnit;


const
  LANGUAGE_DELIMITER = '_';
  LANGUAGE_FILE_EXTENSION = FILE_EXTENSION_DELIMITER + 'lng';
  LANGUAGE_COMMENT_CHAR = '#';
  LANGUAGE_ENVIRONMENT_VAR_LANG = 'LANG';
  LANGUAGE_ENVIRONMENT_VAR_OSDIR = 'OSDIR';
  LANGUAGE_ENVIRONMENT_VAR_ULSPATH = 'ULSPATH';
  LANGUAGE_DEFAULT_LANGUAGE = 'EN_US';
  LANGUAGE_DEFAULT_MARKER = '***';
  LANGUAGE_LABEL_DELIMITER = '.';


type
  TLanguageItem = record
    pLabel: pString;
    pValue: pString;
    wasUsed: boolean;
    isDefault: boolean;
  end;
  TPLanguageItem = ^TLanguageItem;

  TLanguageItemList = class
  protected
    translationsList : TStringList;
    procedure setValueWithFlags(const aLabel : String; const aValue : String; const aDefaultFlag : boolean);
  public
    constructor Create;
    destructor Destroy; override;

    function getValue(const aLabel : String; const aDefaultValue : String) : String;
    procedure setValue(const aLabel : String; const aValue : String);
    procedure readFrom(aTextFile : TextFile);
    procedure saveTo(const aTextFile : TextFile);
  end;


  TLanguageFile = class
  protected
    languageItems : TLanguageItemList;
    fileName: string;

    procedure LoadComponentLanguageInternal(const aComponent: TComponent; const aPath: string; const aDoUpdates: boolean);

  public
    constructor Create(const aFileName : String);
    destructor Destroy; override;

    // if anApplyFlag is true, then the component and it's
    // owned components will be updated. If false, then
    // it will only be checked and missing items noted.

    // For convenience in loading strings manually, related to the component
    procedure LoadComponentLanguage(aComponent: TComponent; const anApplyFlag: boolean);


    // write the current transations to a file
    procedure writeToFile(const aFileName : String);

    // If anApplyFlag is true, then assign aValue the translation
    // for aLabel. Or, if not found, use aDefaultValue.
    // If anApplyFlag is false, just look it up but don't assign to
    // aValue
    procedure LL( const anApplyFlag: boolean;
                  Var aValue: string;
                  const aLabel: string;
                  const aDefaultValue: string );

  end;


  // callback for when language events occur
  // If apply is true, then the specified language has been loaded
  // If apply is false, then the specified language file is being
  // saved, so you should access any strings you need,
  // but not actually change anything
  TLanguageEvent = procedure(aLanguage: TLanguageFile; const anApplyFlag: boolean) of object;

  // non-object version
  TLanguageProc = procedure(aLanguage: TLanguageFile; const anApplyFlag: boolean);


var
  g_CurrentLanguageFile: TLanguageFile;

  // Register that you want to know when the current language changes
  // Will immediately call you back, if there is a current language
  procedure RegisterEventForLanguages(aCallbackEvent : TLanguageEvent);

  // Register a procedure callback (not-object)
  procedure RegisterProcForLanguages(aCallbackProc : TLanguageProc);


  // Register a procedure that will be called only when a language file
  // is being updated (use to load forms if needed)
  procedure RegisterUpdateProcForLanguages(aCallbackProc: TProcedure);


  // Change current language to given, and tell everybody who has registered
  procedure ApplyLanguage(aLanguage: TLanguageFile);

  // Tell everybody who has registered to access the given file,
  // but don't apply strings from it
  procedure UpdateLanguage(aLanguage: TLanguageFile);


  // Load and apply specified language file
  procedure LoadLanguage(const aFilePath: String);


  // load a language from the standard location.
  // anAppName is a short name for the app, e.g. 'newview'
  // language spec is e.g. 'es' or 'es_es'
  function LoadLanguageForSpec(const anAppName: string; const aLanguageSpec: string): boolean;


  // load default language based on LANG environment var
  procedure LoadDefaultLanguage(const anAppName: string);


Implementation

uses
  Dos, SysUtils,
  StdCtrls,
  Buttons,
  ExtCtrls,
  TabCtrls,
  Dialogs,
  Coolbar2,
  Multicolumnlistbox,
  ACLUtility,
  FileUtilsUnit,
  StringUtilsUnit,
  DebugUnit;

var
  g_LanguageCallbacks: TList;
  g_LanguageUpdateCallbacks: TList;


  // -----------------
  // TLanguageItemList
  // -----------------

  constructor TLanguageItemList.Create;
  begin
    // LogEvent(LogI18n, 'TLanguageItemList.Create');
    // setup our memory
    translationsList := TStringList.Create;
    translationsList.Sorted := true; // for lookup speed
    translationsList.CaseSensitive := true; // also for speed. We manually convert to uppercase.
    translationsList.Duplicates := dupAccept;
  end;


  destructor TLanguageItemList.Destroy;
  var
    i: longint;
    tmpPLanguageItem: TPLanguageItem;
  begin
    // LogEvent(LogI18n, 'TLanguageItemList.Destroy');
    for i := 0 to translationsList.Count - 1 do
    begin
      tmpPLanguageItem := TPLanguageItem(translationsList.Objects[i]);

      // free the parts of the item
      DisposeStr(tmpPLanguageItem^.pLabel);
      DisposeStr(tmpPLanguageItem^.pValue);
      Dispose(tmpPLanguageItem);
    end;

    translationsList.Destroy;
  end;


  function TLanguageItemList.getValue(const aLabel : String; const aDefaultValue : String) : String;
  var
    tmpPosition : LongInt;
    tmpFound : Boolean;
    tmpPLanguageItem : TPLanguageItem;
  begin
    tmpFound := translationsList.Find(UpperCase(aLabel), tmpPosition);

    if not tmpFound then
    begin
      setValueWithFlags(aLabel, aDefaultValue, true);
      result := '';

      // LogEvent(LogI18n, 'TLanguageItemList.getValue(' + aLabel + ') [' + aDefaultValue + ']->' + result);
      exit;
    end;

    tmpPLanguageItem := TPLanguageItem(translationsList.Objects[tmpPosition]);

    // mark as used
    tmpPLanguageItem^.wasUsed := true;

    if tmpPLanguageItem^.isDefault then
    begin
      result := '';

      // LogEvent(LogI18n, 'TLanguageItemList.getValue(' + aLabel + ')->' + result);
      exit;
    end;

    result := tmpPLanguageItem^.pValue^;
    // LogEvent(LogI18n, 'TLanguageItemList.getValue(' + aLabel + ')->' + result);
  end;


  procedure TLanguageItemList.setValue(const aLabel : String; const aValue : String);
  begin
    setValueWithFlags(aLabel, aValue, false);
  end;


  procedure TLanguageItemList.setValueWithFlags(const aLabel : String; const aValue : String; const aDefaultFlag : boolean);
  var
    tmpPLanguageItem: TPLanguageItem;
  begin
    // LogEvent(LogI18n, 'TLanguageItemList.setValueWithFlags(' + aLabel + ')->' + aValue + '[' + BoolToStr(aDefaultFlag) + ']');

    New(tmpPLanguageItem);
    tmpPLanguageItem^.pLabel := NewStr(aLabel);
    tmpPLanguageItem^.pValue := NewStr(aValue);
    tmpPLanguageItem^.wasUsed := false;
    tmpPLanguageItem^.isDefault := aDefaultFlag;

    translationsList.AddObject(UpperCase(aLabel), TObject(tmpPLanguageItem));
  end;


  procedure TLanguageItemList.readFrom(aTextFile : TextFile);
  var
    tmpLine : string;
    tmpLabel : string;
    tmpValue : string;
    tmpLineParts : TStringList;
  begin
    tmpLineParts := TStringList.Create;

    while not Eof(aTextFile) do
    begin
      ReadLn(aTextFile, tmpLine);

      tmpLineParts.clear;
      StrExtractStringsQuoted(tmpLineParts, tmpLine);

      if tmpLineParts.count > 0 then
      begin
        tmpLabel := tmpLineParts[0];

        // TODO trim leading blanks
        if tmpLabel[1] <> LANGUAGE_COMMENT_CHAR then
        begin
          // Got a name, read the value and store.
          tmpValue := '';
          if tmpLineParts.count > 0 then
          begin
            tmpValue := tmpLineParts[1];
          end;

          setValue(tmpLabel, tmpValue);
        end;
      end;
    end;

    tmpLineParts.Destroy;
  end;


  procedure TLanguageItemList.saveTo(const aTextFile : TextFile);
  var
    i : integer;
    tmpPLanguageItem: TPLanguageItem;
    tmpLabel : String;
    tmpQuotedValue : String;
    tmpUnusedHeaderFlag : boolean;
  begin
    // used first
    for i := 0 to translationsList.Count - 1 do
    begin
      tmpPLanguageItem := TPLanguageItem(translationsList.Objects[i]);
      if tmpPLanguageItem^.wasUsed then
      begin
        tmpLabel := tmpPLanguageItem^.pLabel^;

        tmpQuotedValue := tmpPLanguageItem^.pValue^;
        tmpQuotedValue := StrEscapeAllCharsBy(tmpQuotedValue, [], '"');
        tmpQuotedValue := StrInDoubleQuotes(tmpQuotedValue);

        if tmpPLanguageItem^.isDefault then
        begin
          WriteLn(aTextFile, tmpLabel + ' ' + tmpQuotedValue + ' ' + LANGUAGE_DEFAULT_MARKER);
        end
        else
        begin
          WriteLn(aTextFile, tmpLabel + ' ' + tmpQuotedValue);
        end;
      end;
    end;


    // unused at the end
    tmpUnusedHeaderFlag := false;
    for i := 0 to translationsList.Count - 1 do
    begin
      tmpPLanguageItem := TPLanguageItem(translationsList.Objects[i]);
      if not tmpPLanguageItem^.wasUsed then
      begin
        if not tmpUnusedHeaderFlag then
        begin
          tmpUnusedHeaderFlag := true;

          Writeln(aTextFile, '# **********************************************************');
          Writeln(aTextFile, '# * The following items are no longer needed.              *');
          Writeln(aTextFile, '# * You can delete them after checking they are of no use. *');
          Writeln(aTextFile, '# **********************************************************');
        end;

        tmpLabel := tmpPLanguageItem^.pLabel^;

        tmpQuotedValue := tmpPLanguageItem^.pValue^;
        tmpQuotedValue := StrEscapeAllCharsBy(tmpQuotedValue, [], '"');
        tmpQuotedValue := StrInDoubleQuotes(tmpQuotedValue);

        if tmpPLanguageItem^.isDefault then
        begin
          WriteLn(aTextFile, tmpLabel + ' ' + tmpQuotedValue + ' ' + LANGUAGE_DEFAULT_MARKER);
        end
        else
        begin
          WriteLn(aTextFile, tmpLabel + ' ' + tmpQuotedValue);
        end;
      end;
    end;
  end;


  // -----------------
  // TLanguageCallback
  // -----------------

Type
  TLanguageCallback = class
    FCallbackMethod: TLanguageEvent;
    FCallbackProc: TLanguageProc;
    constructor CreateMethod( CallbackMethod: TLanguageEvent );
    constructor CreateProc( CallbackProc: TLanguageProc );
  end;


  constructor TLanguageCallback.CreateMethod(CallbackMethod: TLanguageEvent);
  begin
    FCallbackMethod := CallbackMethod;
    FCallbackProc := nil;
  end;


  constructor TLanguageCallback.CreateProc(aCallbackProc: TLanguageProc);
  begin
    FCallbackProc := CallbackProc;
    FCallbackMethod := nil;
  end;


  procedure AddLanguageCallback(aCallbackObject: TLanguageCallback);
  begin
    if g_LanguageCallbacks = nil then
    begin
      g_LanguageCallbacks := TList.Create;
    end;

    g_LanguageCallbacks.Add(aCallbackObject);
  end;


  procedure RegisterEventForLanguages(aCallbackEvent : TLanguageEvent);
  begin
    AddLanguageCallback( TLanguageCallback.CreateMethod(aCallbackEvent) );

    if g_CurrentLanguageFile <> nil then
    begin
      aCallbackEvent(g_CurrentLanguageFile, true);
    end;
  end;


  procedure RegisterProcForLanguages(aCallbackProc : TLanguageProc);
  begin
    AddLanguageCallback( TLanguageCallback.CreateProc(aCallbackProc) );

    if g_CurrentLanguageFile <> nil then
    begin
      aCallbackProc(g_CurrentLanguageFile, true);
    end;
  end;


  procedure RegisterUpdateProcForLanguages(aCallbackProc: TProcedure);
  begin
    if g_LanguageUpdateCallbacks = nil then
    begin
      g_LanguageUpdateCallbacks := TList.Create;
    end;

    g_LanguageUpdateCallbacks.Add(TObject(aCallbackProc));
    // since this is for when updating a language only, we don't immediately call it
  end;


  procedure ApplyLanguage(aLanguage: TLanguageFile);
  var
    i: longint;
    tmpCallback: TLanguageCallback;
  begin
    if g_CurrentLanguageFile <> nil then
    begin
      g_CurrentLanguageFile.Destroy;
    end;

    g_CurrentLanguageFile := aLanguage;

    // do language callbacks to everyone
    for i := 0 to g_LanguageCallbacks.Count - 1 do
    begin
      tmpCallback := g_LanguageCallbacks[i];

      if Assigned(tmpCallback.FCallbackMethod) then
      begin
        tmpCallback.FCallbackMethod(g_CurrentLanguageFile, true);
      end;

      if Assigned(tmpCallback.FCallbackProc) then
      begin
        tmpCallback.FCallbackProc(g_CurrentLanguageFile, true);
      end;
    end;
  end;


  procedure UpdateLanguage(aLanguage: TLanguageFile);
  var
    i: longint;
    tmpCallback : TLanguageCallback;
    tmpUpdateProc : TProcedure;
  begin
    if g_LanguageUpdateCallbacks <> nil then
    begin
      // first call all update callbacks so dynamically created
      // things can be loaded (i.e. forms)
      // Note: this will cause them to load their strings from
      // the current language if any. This is fine, necessary even.
      for i := 0 to g_LanguageUpdateCallbacks.Count - 1 do
      begin
        tmpUpdateProc := TProcedure(g_LanguageUpdateCallbacks[i]);
        tmpUpdateProc;
      end;
    end;

    if g_LanguageCallbacks <> nil then
    begin
      // now call the language events
      for i := 0 to g_LanguageCallbacks.Count - 1 do
      begin
        tmpCallback := g_LanguageCallbacks[i];
        if Assigned(tmpCallback.FCallbackMethod) then
        begin
          tmpCallback.FCallbackMethod(aLanguage, false);
        end;
        if Assigned(tmpCallback.FCallbackProc) then
        begin
          tmpCallback.FCallbackProc(aLanguage, false);
        end;
      end;
    end;
  end;


  constructor TLanguageFile.Create( const aFileName : String);
  var
    tmpTextFile : TextFile;
  begin
    filename := aFileName;

    languageItems := TLanguageItemList.Create;

    if not FileExists(aFileName) then
    begin
      exit;
    end;

    // read the file
    FileMode := fmInput;
    AssignFile(tmpTextFile, aFileName);
    Reset(tmpTextFile);

    languageItems.readFrom(tmpTextFile);

    CloseFile(tmpTextFile);
  end;


  destructor TLanguageFile.Destroy;
  begin
    languageItems.Destroy;
  end;


  procedure TLanguageFile.LL( const anApplyFlag: boolean;
                              Var aValue: string;
                              const aLabel: string;
                              const aDefaultValue: string );
  begin
    // LogEvent(LogI18n, 'TLanguageFile.LL(' + BoolToStr(anApplyFlag) + ' "' + aLabel + '" "' + aDefaultValue +'")');

    if anApplyFlag then
    begin
      aValue := languageItems.getValue(aLabel, aDefaultValue);
      if '' = aValue then
      begin
        aValue := aDefaultValue;
      end
    end
    else
    begin
      languageItems.getValue(aLabel, aDefaultValue)
    end
  end;


  procedure TLanguageFile.LoadComponentLanguage(aComponent: TComponent; const anApplyFlag: boolean);
  begin
    LoadComponentLanguageInternal(aComponent, '', anApplyFlag);
  end;


  procedure TLanguageFile.writeToFile(const aFileName : String);
  var
    tmpBackupFilename: string;
    tmpFile: TextFile;
  begin
    tmpBackupFilename := ChangeFileExt(aFileName, '.bak' );
    if FileExists(tmpBackupFilename) then
    begin
      if not DeleteFile(tmpBackupFilename) then
      begin
        raise Exception.Create( 'Unable to delete backup language file: ' + tmpBackupFilename);
      end;
    end;

    if FileExists(aFileName) then
      begin
      if not CopyFile(aFileName, tmpBackupFilename ) then
      begin
        raise Exception.Create( 'Unable to copy to backup language file: ' + tmpBackupFilename);
      end;
    end;

    AssignFile(tmpFile, aFileName);
    ReWrite(tmpFile);

    languageItems.saveTo(tmpFile);

    CloseFile(tmpFile);
  end;

  procedure TLanguageFile.LoadComponentLanguageInternal(const aComponent: TComponent; const aPath: string; const aDoUpdates: boolean);
  var
    i : longint;
    tmpComponentPath: string;
    tmpValue: string;

    tmpMenuItem: TMenuItem;
    tmpButton: TButton;
    tmpLabel: TLabel;
    tmpRadioGroup: TRadioGroup;
    tmpTabSet: TTabSet;
    tmpTabbedNotebook: TTabbedNotebook;
    tmpForm: TForm;
    tmpRadioButton: TRadioButton;
    tmpCheckBox: TCheckBox;
    tmpCoolBar2: TCoolBar2;
    tmpGroupBox: TGroupBox;
    tmpMultiColumnListBox: TMultiColumnListBox;
    tmpSystemOpenDialog: TSystemOpenDialog;
    tmpSystemSaveDialog: TSystemSaveDialog;
  Begin
    tmpComponentPath := aPath + aComponent.Name + LANGUAGE_LABEL_DELIMITER;

    // Components sorted with most common at top, ish...
    if aComponent is TMenuItem then
    begin
      tmpMenuItem := TMenuItem(aComponent);

      // skip separators
      if tmpMenuItem.Caption <> '-' then
      begin
        tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpMenuItem.Caption);
        if '' <> tmpValue then tmpMenuItem.Caption := tmpValue;

        tmpValue := languageItems.getValue(tmpComponentPath + 'Hint', tmpMenuItem.Hint);
        if '' <> tmpValue then tmpMenuItem.Hint := tmpValue;
      end;
    end

    else if aComponent is TButton then
    begin
      tmpButton := TButton(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpButton.Caption);
      if '' <> tmpValue then tmpButton.Caption := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Hint', tmpButton.Hint);
      if '' <> tmpValue then tmpButton.Hint := tmpValue;
    end

    else if aComponent is TLabel then
    begin
      tmpLabel := TLabel(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpLabel.Caption);
      if '' <> tmpValue then tmpLabel.Caption := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Hint', tmpLabel.Hint);
      if '' <> tmpValue then tmpLabel.Hint := tmpValue;
    end

    else if aComponent is TRadioGroup then
    begin
      tmpRadioGroup := TRadioGroup(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpRadioGroup.Caption);
      if '' <> tmpValue then tmpRadioGroup.Caption := tmpValue;

      for i := 0 to tmpRadioGroup.Items.Count - 1 do
      begin
        tmpValue := languageItems.getValue(tmpComponentPath + 'Item' + IntToStr(i), tmpRadioGroup.Items[i]);
        if '' <> tmpValue then tmpRadioGroup.Items[i] := tmpValue;
      end;
    end

    else if aComponent is TTabSet then
    begin
      tmpTabSet := TTabSet(aComponent);

      for i := 0 to tmpTabSet.Tabs.Count - 1 do
      begin
        tmpValue := languageItems.getValue(tmpComponentPath + 'Tab' + IntToStr(i), tmpTabSet.Tabs[i]);
        if '' <> tmpValue then tmpTabSet.Tabs[i] := tmpValue;
      end;
    end

    else if aComponent is TTabbedNotebook then
    begin
      tmpTabbedNotebook := TTabbedNotebook(aComponent);
      for i := 0 to tmpTabbedNotebook.Pages.Count - 1 do
      begin
        tmpValue := languageItems.getValue(tmpComponentPath + 'Tab' + IntToStr(i) + '.Caption', tmpTabbedNotebook.Pages[i]);
        if '' <> tmpValue then tmpTabbedNotebook.Pages[i] := tmpValue;

        tmpValue := languageItems.getValue(tmpComponentPath + 'Tab' + IntToStr(i) + '.Hint', tmpTabbedNotebook.Pages.Pages[i].Hint);
        if '' <> tmpValue then tmpTabbedNotebook.Pages.Pages[i].Hint := tmpValue;
      end;
    end

    else if aComponent is TForm then
    begin
      tmpForm := TForm(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpForm.Caption);
      if '' <> tmpValue then tmpForm.Caption := tmpValue;

      // load owned controls
      for i := 0 to aComponent.ComponentCount - 1 do
      begin
        LoadComponentLanguageInternal(aComponent.Components[i], tmpComponentPath, aDoUpdates );
      end;
    end

    else if aComponent is TRadioButton then
    begin
      tmpRadioButton := TRadioButton(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpRadioButton.Caption);
      if '' <> tmpValue then tmpRadioButton.Caption := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Hint', tmpRadioButton.Hint);
      if '' <> tmpValue then tmpRadioButton.Hint := tmpValue;
    end

    else if aComponent is TCheckBox then
    begin
      tmpCheckBox := TCheckBox(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpCheckBox.Caption);
      if '' <> tmpValue then tmpCheckBox.Caption := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Hint', tmpCheckBox.Hint);
      if '' <> tmpValue then tmpCheckBox.Hint := tmpValue;
    end

    else if aComponent is TCoolBar2 then
    begin
      tmpCoolBar2 := TCoolBar2(aComponent);
      for i := 0 to tmpCoolBar2.Sections.Count - 1 do
      begin
        tmpValue := languageItems.getValue(tmpComponentPath + 'Item' + IntToStr(i), tmpCoolBar2.Sections[i].Text);
        if '' <> tmpValue then tmpCoolBar2.Sections[i].Text := tmpValue;
      end;
    end

    else if aComponent is TGroupBox then
    begin
      tmpGroupBox := TGroupBox(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'Caption', tmpGroupBox.Caption);
      if '' <> tmpValue then tmpGroupBox.Caption := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Hint', tmpGroupBox.Hint);
      if '' <> tmpValue then tmpGroupBox.Hint := tmpValue;
    end

    else if aComponent is TMultiColumnListBox then
    begin
      tmpMultiColumnListBox := TMultiColumnListBox(aComponent);

      for i := 0 to tmpMultiColumnListBox.HeaderColumns.Count - 1 do
      begin
        tmpValue := languageItems.getValue(tmpComponentPath + 'Column' + IntToStr(i), tmpMultiColumnListBox.HeaderColumns[i].Text);
        if '' <> tmpValue then tmpMultiColumnListBox.HeaderColumns[i].Text := tmpValue;
      end;
    end

    else if aComponent is TSystemOpenDialog then
    begin
      tmpSystemOpenDialog := TSystemOpenDialog(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'OKName', tmpSystemOpenDialog.OKName);
      if '' <> tmpValue then tmpSystemOpenDialog.OKName := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Title', tmpSystemOpenDialog.Title);
      if '' <> tmpValue then tmpSystemOpenDialog.Title := tmpValue;
    end

    else if aComponent is TSystemSaveDialog then
    begin
      tmpSystemSaveDialog := TSystemSaveDialog(aComponent);

      tmpValue := languageItems.getValue(tmpComponentPath + 'OKName', tmpSystemSaveDialog.OKName);
      if '' <> tmpValue then tmpSystemSaveDialog.OKName := tmpValue;

      tmpValue := languageItems.getValue(tmpComponentPath + 'Title', tmpSystemSaveDialog.Title);
      if '' <> tmpValue then tmpSystemSaveDialog.Title := tmpValue;
    end;
  end;


  procedure LoadLanguage(const aFilePath: String);
  var
    tmpNewLanguage: TLanguageFile;
  begin
    LogEvent(LogI18n, 'LoadLanguage(' + aFilePath + ')');
    try
      tmpNewLanguage := TLanguageFile.Create(aFilePath);
    except
      // TODO more log output
      exit;
    end;

    ApplyLanguage(tmpNewLanguage);
  end;


  function LoadLanguageForSpec(const anAppName: string; const aLanguageSpec: string) : boolean;
  var
    tmpFilePath: string;
    tmpFileName: string;
    tmpOSDir: string;
  begin
    // Filenames loaded will be <AppName>.<Language>.lng
    tmpFilename := anAppName + LANGUAGE_DELIMITER + aLanguageSpec + LANGUAGE_FILE_EXTENSION;

    // eCS 1.1+ look in x:\ecs\lang
    tmpOSDir := GetEnv(LANGUAGE_ENVIRONMENT_VAR_OSDIR);
    if tmpOSDir <> '' then
    begin
      tmpFilePath := AddDirectorySeparator(tmpOSDir) + 'lang\' + tmpFileName;
      if FileExists(tmpFilePath) then
      begin
        LoadLanguage(tmpFilePath);
        result := true;
        exit;
      end;
    end;

    // something or rather, maybe: look in %ULSPATH%
    if SearchPath(LANGUAGE_ENVIRONMENT_VAR_ULSPATH, tmpFilename, tmpFilepath ) then
    begin
      LoadLanguage(tmpFilePath);
      result := true;
      exit;
    end;

    // Standalone/compatibility: look in own dir
    tmpFilePath := GetApplicationDir + tmpFileName;

    if FileExists(tmpFilePath) then
    begin
      LoadLanguage(tmpFilePath);
      result := true;
      exit;
    end;

    result := false;
  end;


  Procedure LoadDefaultLanguage(const anAppName: string);
  var
    tmpLanguageVar: string;
    tmpMajorLanguage: string;
    tmpMinorLanguage: string;
    tmpParts : TStringList;

  begin
    tmpLanguageVar := GetEnv(LANGUAGE_ENVIRONMENT_VAR_LANG);
    LogEvent(LogI18n, LANGUAGE_ENVIRONMENT_VAR_LANG + '=' + tmpLanguageVar);

    if tmpLanguageVar = '' then
    begin
      tmpLanguageVar := DEFAULT_LANGUAGE;
    end;

    tmpParts := TStringList.Create;
    StrExtractStrings(tmpParts, tmpLanguageVar, ['_'], #0);

    tmpMajorLanguage := '';
    if tmpParts.count > 0 then
    begin
      tmpMajorLanguage := tmpParts[0];
    end;

    // note there might be some other stuff on the end of LANG
    // such as ES_ES_EURO...

    if tmpParts.count > 1 then
    begin
      tmpMinorLanguage := tmpParts[1];

      LogEvent(LogI18n, 'try loading ' + tmpMajorLanguage + '_' + tmpMinorLanguage);
      if LoadLanguageForSpec(anAppName, tmpMajorLanguage + '_' + tmpMinorLanguage) then
      begin
        // found a specifc language
        LogEvent(LogI18n, ' translation for ' + tmpMajorLanguage + '_' + tmpMinorLanguage + ' sucessfully loaded');
        tmpParts.Destroy;
        exit;
      end;
    end;

    // try generic language?
    LogEvent(LogI18n, 'try loading (major only) ' + tmpMajorLanguage);
    if LoadLanguageForSpec(anAppName, tmpMajorLanguage) then
    begin
      LogEvent(LogI18n, 'translation for ''' + tmpMajorLanguage + ''' sucessfully loaded');
      tmpParts.Destroy;
      exit;
    end;

    LogEvent(LogI18n, 'No language found, using default ' + tmpMajorLanguage);
    LoadLanguage('');

    tmpParts.Destroy;
  end;


  Initialization
    g_LanguageCallbacks := nil;
    g_CurrentLanguageFile := nil;
    g_LanguageUpdateCallbacks := nil;


  Finalization
    DestroyListAndObjects(g_LanguageUpdateCallbacks);
    DestroyListAndObjects(g_LanguageCallbacks);
    if nil <> g_CurrentLanguageFile then g_CurrentLanguageFile.Destroy;

End.