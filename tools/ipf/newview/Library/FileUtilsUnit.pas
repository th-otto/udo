Unit FileUtilsUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003-2006 Aaron Lawrence
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// Helper functions for file handling

Interface

uses
  Classes,
  ACLUtility;


const
  DIRECTORY_SEPARATOR = '\';
  PATH_SEPARATOR = ';';
  CURRENT_DIRECTORY = '.';
  PARENT_DIRECTORY = '..';
  FILE_EXTENSION_DELIMITER = '.';

  // Drive numbers are one based
  MinDriveNumber = 1;
  MaxDriveNumber = 26;


  // TODO
  HelpPathEnvironmentVar = 'HELP';
  BookshelfEnvironmentVar = 'BOOKSHELF';
  LanguageEnvironmentVar = 'LANG';
  DEFAULT_LANGUAGE = 'EN_US';
  HELP_FILE_DELIMITER = '+';
  HELP_FILE_EXTENSION = FILE_EXTENSION_DELIMITER + 'hlp';
  INF_FILE_EXTENSION = FILE_EXTENSION_DELIMITER + 'inf';


type
  TDriveType =
  (
    dtNone,
    dtFloppy,
    dtHard,
    dtCD,
    dtNetwork,
    dtRemovable
  );


  // Adds a slash to the end of dir if not present
  // if aDir is empty this returns '\'
  Function AddDirectorySeparator(aDirectory : String) : String;

  // Adds a slash to the end of dir if not present
  // if aDir is empty this returns ''
  Function AddDirectorySeparatorIfNotEmpty(aDirectory: String) : String;

  // Removes a directory seperator from the end of aDirectory
  // (if present)
  Function RemoveRightDirectorySeparator(aDirectory : String) : String;

  // Expands the path given, relative to aBaseDirectory
  // Handles leading \ for root dir,
  // .. for parent, . (ignored),
  // drive spec at start,
  // ignores repeated \ e.g. \\
  Function ExpandPath(aBaseDirectory : String; aPath : String): String;

  Function GetLogFilesDir: String;

  Function SearchPath(const aPathEnvVar: String; const aFilename: String; var aResultFilename: String) : boolean;

  Function SearchHelpPaths(const aFilename: String; var aResultFilename: String; const anIncludeAppDir: boolean) : boolean;

  // Find the help file for the current app based on LANG
  Function FindDefaultLanguageHelpFile(const anApplicationName: String; const aLanguage : String) : String;

  // Breaks up specified Env var path
  // this always clears the list at the beginning
  Procedure GetDirsInPath(const aPathEnvVar: String; var aList: TStrings);

  // Breaks up specified Env var path
  // then adds all matching files to the list
  Procedure GetFilesInPath(     const aPathEnvVar: String;
                                const aFilter: String;
                                var aList: TStrings );

  // searches for all files in aDirectory matching aFilter and add
  // them to aList
  // it is possible to define different filter if you separate them by semicolon
  Procedure ListFilesInDirectory(       const aDirectory : String;
                                        const aFilter : String;
                                        const aWithDirectoryFlag : boolean;
                                        var aList : TStrings);

  // searches for all directories in aDirectory and add them to aList
  Procedure ListSubDirectories(const aDirectory: String; const anIncludeSystemAndHiddenFlag: boolean; var aList: TStrings);

  Procedure ListFilesInDirectoryRecursiveWithTermination(const aDirectory : String;
                                                         const aFilter : String;
                                                         const aWithDirectoryFlag : boolean;
                                                         const anIncludeSystemAndHiddenFlag: boolean;
                                                         var aList : TStrings;
                                                         const aTerminateCheck : TTerminateCheck;
                                                         const aUseTerminateCheck : boolean);

  Function ParentDir(const aDirectory : String) : String;

  // In the directory startpath, create directory and subdirectories
  // specified in DirsString
  // e.g. bob\bill\fred will make bob, then bill in bob, then fred in bob
  // returns path to lowest dir created
  Function MakeDirs(const aFullDirectoryPath: String) : String;


  // Checks if a directory exists
  Function DirectoryExists(const aDirectory : String) : boolean;

  Function DriveLetterToDriveNumber(const aDriveLetter : char) : longint;
  Function DriveNumberToDriveLetter(const aDriveNumber : longint) : char;

  Function GetVolumeLabel(aDrive: char) : String;

  Function GetBootDriveLetter: char;

  // Returns true if file exists and is read only
  Function FileIsReadOnly(const aFilename : String) : boolean;


  // TODO
  Function IsFloppyDrive( DriveNumber: longint ): Boolean;
  Function GetLocalDriveType( DriveNumber: longint ): TDriveType;
  Function GetDriveType( DriveNumber: longint ): TDriveType;
  Function GetNetworkDriveRemotePath( DriveNumber: longint ): String;


Implementation

uses
  Dos,
  BseDos,
  BseErr,
  BseDev,
  Os2Def,
  SysUtils,
  StringUtilsUnit,
  CharUtilsUnit;

imports
  FUNCTION _DosQueryFSAttach( VAR pszDeviceName: CSTRING;
                              ulOrdinal: ULONG;
                              ulFSAInfoLevel:ULONG;
                              pfsqb: PFSQBUFFER2;
                              VAR pcbBuffLength: ULONG ): APIRET; APIENTRY;
  'DOSCALLS' index 277;
end;


type
  TWord = Record                    // Bytes of a Word
    LoByte, HiByte : Byte;
  End;

  TBPB = Array[0..30] Of Byte;    // Puffer fuer BPB-Struktur

  TDeviceParameters = Record
    BPB: TBPB;
    Cylinders: word;
    DeviceType: Byte;
    Attributes: Word;
  End;



  Function AddDirectorySeparator(aDirectory : String) : String;
  begin
    if aDirectory = '' then
    begin
      Result:= DIRECTORY_SEPARATOR;
      exit;
    end;

    if aDirectory[length(aDirectory)] <> DIRECTORY_SEPARATOR then
    begin
      Result := aDirectory + DIRECTORY_SEPARATOR;
      exit;
    end;

    Result := aDirectory;
  end;


  Function AddDirectorySeparatorIfNotEmpty(aDirectory: String): String;
  begin
    if aDirectory = '' then
    begin
      Result := '';
      exit;
    end;
    Result := AddDirectorySeparator(aDirectory);
  end;


  Function RemoveRightDirectorySeparator(aDirectory : String) : String;
  begin
    Result := StrTrimRightChars(aDirectory, [DIRECTORY_SEPARATOR]);
  end;


  Function ExpandPath(aBaseDirectory : String; aPath : String): String;
  var
    tmpDirectory: String;
    tmpDirectories : TStringList;
    i : integer;
  begin
    Result:= aBaseDirectory;

    if aPath = '' then
    begin
      Result := StrTrimRightChars(Result, [DIRECTORY_SEPARATOR]);
      exit;
    end;

    aPath := trim(aPath);
    if Length(aPath) > 1 then
    begin
      // check for drive spec
      if aPath[2] = ':' then
      begin
        Result := AddDirectorySeparator(aPath);
        if Length(aPath) > 3 then
        begin
          Result := StrTrimRightChars(Result, [DIRECTORY_SEPARATOR]);
        end;
        exit;
      end
    end;

    if Length(aPath) > 0 then
    begin
      // check for root dir spec
      if aPath[1] = DIRECTORY_SEPARATOR then
      begin
        // take just the drive from the basedir
        if aBaseDirectory[2] = ':' then
        begin
          Result := StrLeft(aBaseDirectory, 2);
        end
        else
        begin
          Result := DIRECTORY_SEPARATOR;
        end;
          aPath := StrTrimLeftChars(aPath, [DIRECTORY_SEPARATOR]);
      end;
    end;

    tmpDirectories := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpDirectories, aPath, [DIRECTORY_SEPARATOR], #0);
    for i := 0 to tmpDirectories.count-1 do
    begin
      tmpDirectory := tmpDirectories[i];
      if tmpDirectory = PARENT_DIREcTORY then
      begin
        if NOT ((Length(Result) = 2) AND (Result[2] = ':')) then
        begin
          Result := ParentDir(Result);
        end;
      end
      else if tmpDirectory = CURRENT_DIRECTORY then
      begin
        ; // nothing to do
      end
      else
      begin
        Result := AddDirectorySeparator(Result) + tmpDirectory;
      end;

      // strip any extra leading slashes
      aPath := StrTrimLeftChars(aPath, [DIRECTORY_SEPARATOR]);
    end;
    tmpDirectories.Destroy;

    if Length(Result) = 2 then
    begin
      if Result[2] = ':' then
      begin
        // just a drive spec X:, so add a slash
        Result := Result + DIRECTORY_SEPARATOR;
      end;
    end;
  end;

  Function GetLogFilesDir: String;
  begin
    // ecomstation 1.1 compat
    Result := GetEnv('LOGFILES');
    if Result <> '' then
    begin
      Result := AddDirectorySeparator(Result);
      exit;
    end;
    // TODO
    Result := AddDirectorySeparator(GetApplicationDir);
  end;


  Function SearchPath(const aPathEnvVar: String;
                      const aFilename: String;
                      var   aResultFilename: String) : boolean;
  var
    tmpSzEnvVar : CString;
    tmpSzFilename : CString;
    tmpSzFilenameFound : CString;
    tmpRC: APIRET;
  begin
    Result := false;
    aResultFilename := '';

    tmpSzEnvVar := aPathEnvVar;
    tmpSzFilename := aFilename;
    tmpRC := DosSearchPath( SEARCH_IGNORENETERRS
                            + SEARCH_ENVIRONMENT
                            + SEARCH_CUR_DIRECTORY,
                            tmpSzEnvVar,
                            tmpSzFilename,
                            tmpSzFilenameFound,
                            sizeof(tmpSzFilenameFound));
    if tmpRC = 0 then
    begin
      Result := true;
      aResultFilename := tmpSzFilenameFound;
    end;
  end;


  Function SearchHelpPaths(const aFilename: String;
                           var   aResultFilename: String;
                           const anIncludeAppDir: boolean) : boolean;
  begin
    Result := SearchPath(HelpPathEnvironmentVar, aFileName, aResultFilename);
    if not Result then
    begin
      Result := SearchPath(BookshelfEnvironmentVar, aFileName, aResultFilename);
    end;

    if (not Result) and anIncludeAppDir then
    begin
      aResultFilename := AddDirectorySeparator(GetApplicationDir) + aFilename;
      Result := FileExists(aResultFilename);
      if not Result then
      begin
        aResultFilename := '';
      end;
    end;
  end;


  Function FindDefaultLanguageHelpFile(const anApplicationName: String; const aLanguage : String) : String;
  var
    tmpLanguage : String;
    tmpLanguageParts : TStringList;
    tmpMajorLanguage : String;
    tmpMinorLanguage : String;
  begin
    Result := '';

    tmpLanguage := aLanguage;
    if aLanguage = '' then
    begin
      tmpLanguage := DEFAULT_LANGUAGE;
    end;

    tmpLanguageParts := TStringList.Create;
    StrExtractStrings(tmpLanguageParts, tmpLanguage, ['_'], #0);

    tmpMajorLanguage := '';
    if tmpLanguageParts.count > 0 then
    begin
      tmpMajorLanguage := tmpLanguageParts[0];
    end;

    tmpMinorLanguage := '';
    if tmpLanguageParts.count > 1 then
    begin
      tmpMinorLanguage := tmpMinorLanguage[1];
    end;

    tmpLanguageParts.Destroy;

    // note there might be some other stuff on the end of LANG
    // such as ES_ES_EURO...
    if tmpMinorLanguage <> '' then
    begin
      if SearchHelpPaths( anApplicationName
                          + '_' + tmpMajorLanguage
                          + '_' + tmpMinorLanguage
                          + HELP_FILE_EXTENSION,
                          Result,
                          true ) then
      begin
        // found a specifc language
        exit;
      end;
    end;

    // try generic language?
    if SearchHelpPaths( anApplicationName
                        + '_' + tmpMajorLanguage
                        + HELP_FILE_EXTENSION,
                        Result,
                        true ) then
    begin
      exit;
    end;

    // nothing specific, search for default
    SearchHelpPaths(anApplicationName + HELP_FILE_EXTENSION, Result, true);
  end;


  Procedure GetDirsInPath(const aPathEnvVar: String; var aList: TStrings);
  var
    tmpRC : APIRET;
    tmpPszPathEnvVar : PChar;
    tmpSzEnvVar : CString;
  begin
    // do this in any case also if there is an error
    // to garantie a defined behavior
    aList.Clear;

    tmpSzEnvVar := aPathEnvVar;
    tmpRC := DosScanEnv(tmpSzEnvVar, tmpPszPathEnvVar);

    if tmpRC <> 0 then
    begin
      exit;
    end;

    StrExtractStringsIgnoreEmpty(aList, StrPas(tmpPszPathEnvVar), [PATH_SEPARATOR], #0);
  end;


  Procedure GetFilesInPath(     const aPathEnvVar: String;
                                const aFilter: String;
                                var aList: TStrings );
  var
    tmpDirectories : TStringList;
    i : integer;
  begin
    tmpDirectories := TStringList.Create;
    GetDirsInPath(aPathEnvVar, tmpDirectories);

    for i:=0 to tmpDirectories.count-1 do
    begin
      ListFilesInDirectory(tmpDirectories[i], aFilter, false, aList);
    end;

    tmpDirectories.Destroy;
  end;


  Procedure ListFilesInDirectory(       const aDirectory: String;
                                        const aFilter: String;
                                        const aWithDirectoryFlag: boolean;
                                        var aList: TStrings);
  var
    tmpRC : APIRET;
    tmpSearchResults: TSearchRec;
    tmpMask: String;
    tmpFilterParts : TStringList;
    tmpDirectory : String;
    i : integer;
  begin
    tmpFilterParts := TStringList.Create;
    StrExtractStrings(tmpFilterParts, aFilter, [PATH_SEPARATOR], #0);

    for i:=0 to tmpFilterParts.count-1 do
    begin
      tmpMask := tmpFilterParts[i];
      tmpDirectory := AddDirectorySeparator(aDirectory);
      tmpRC := FindFirst(tmpDirectory + tmpMask, faAnyFile, tmpSearchResults);

      while tmpRC = 0 do
      begin
        if tmpSearchResults.Attr And faDirectory = 0 then
        begin
          if (aWithDirectoryFlag) then
          begin
            aList.Add(tmpDirectory + tmpSearchResults.Name);
          end
          else
          begin
            aList.Add(tmpSearchResults.Name);
          end;
        end;

        tmpRC := FindNext(tmpSearchResults);
      end;

      FindClose(tmpSearchResults);
    end;
    tmpFilterParts.Destroy;
  end;


  Procedure ListSubDirectories(const aDirectory: String; const anIncludeSystemAndHiddenFlag: boolean; var aList: TStrings);
  var
    tmpRC : APIRET;
    tmpSearchResults: TSearchRec;
    tmpName : String;
    tmpFileAttributes : ULONG;
  begin

    if anIncludeSystemAndHiddenFlag then
    begin
      tmpFileAttributes := faArchive or faReadonly or faHidden or faSysFile or faDirectory or faMustDirectory;
    end
    else
    begin
      tmpFileAttributes := faArchive or faReadonly or faDirectory or faMustDirectory;
    end;

    tmpRC := FindFirst(AddDirectorySeparator(aDirectory) + '*', tmpFileAttributes, tmpSearchResults);
    if (tmpRC <> 0) then
    begin
      exit;
    end;

    while tmpRC = 0 do
    begin
      tmpName := tmpSearchResults.Name;
      if (tmpName <> CURRENT_DIRECTORY) AND (tmpName <> PARENT_DIRECTORY) then
      begin
        aList.Add(AddDirectorySeparatorIfNotEmpty(aDirectory) + tmpSearchResults.Name );
      end;
      tmpRC := FindNext(tmpSearchResults);
    end;
    FindClose(tmpSearchResults);
  end;


  Procedure ListFilesInDirectoryRecursiveWithTermination(const aDirectory : String;
                                                         const aFilter : String;
                                                         const aWithDirectoryFlag : boolean;
                                                         const anIncludeSystemAndHiddenFlag: boolean;
                                                         var aList : TStrings;
                                                         const aTerminateCheck : TTerminateCheck;
                                                         const aUseTerminateCheck : boolean);
  var
    i : integer;
    tmpSubDirectories : TStringList;
    tmpSubDirectory : String;
  begin
    // at first add all files from the directory itself
    ListFilesInDirectory(aDirectory, aFilter, aWithDirectoryFlag, aList);

    // now determine all subdirectories
    tmpSubDirectories := TStringList.Create;
    ListSubDirectories(aDirectory, anIncludeSystemAndHiddenFlag, tmpSubDirectories);

    for i := 0 to tmpSubDirectories.Count - 1 do
    begin
      // if Assigned( TerminateCheck ) then - doesn't work in sibyl
      if aUseTerminateCheck then
        if aTerminateCheck then
          break;

      tmpSubDirectory := tmpSubDirectories[i];

      ListFilesInDirectoryRecursiveWithTermination(     tmpSubDirectory,
                                                        aFilter,
                                                        aWithDirectoryFlag,
                                                        anIncludeSystemAndHiddenFlag,
                                                        aList,
                                                        aTerminateCheck,
                                                        aUseTerminateCheck);
    end;
    tmpSubDirectories.Destroy;
  end;


  Function ParentDir(const aDirectory : String) : String;
  var
    tmpPos: integer;
  begin
    tmpPos := Length(aDirectory);

    // ends with slash
    while (aDirectory[tmpPos] = DIRECTORY_SEPARATOR) AND (tmpPos > 0) do
    begin
      dec(tmpPos);
    end;

    // find slash
    while (aDirectory[tmpPos] <> DIRECTORY_SEPARATOR) AND (tmpPos > 0) do
    begin
      dec(tmpPos);
    end;

    result:= StrLeft(aDirectory, tmpPos-1);
  end;


  Function MakeDirs(const aFullDirectoryPath: String) : String;
  Var
    tmpDirectoryParts : TStringList;
    tmpDirectoryPart : String;
    tmpCompletePart : String;
    i : integer;
  begin
    tmpDirectoryParts := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpDirectoryParts, aFullDirectoryPath, [DIRECTORY_SEPARATOR], #0);

    tmpCompletePart := '';
    for i:=0 to tmpDirectoryParts.count-1 do
    begin
      tmpDirectoryPart := trim(tmpDirectoryParts[i]);

      if tmpDirectoryPart <> '' then
      begin
        tmpCompletePart := AddDirectorySeparatorIfNotEmpty(tmpCompletePart) + tmpDirectoryPart;

        if not DirectoryExists(tmpCompletePart) then
        begin
          MkDir(tmpCompletePart);
        end;
      end;
    end;

    Result := tmpCompletePart;
  end;


  Function DirectoryExists(const aDirectory : String) : boolean;
  Var
    tmpRC : APIRET;
    tmpSearchResults : TSearchRec;
    tmpDriveMap : ULONG;
    tmpActualDrive : ULONG;
    tmpDrive : Char;
    tmpDriveNum : integer;
    tmpDriveBit : longword;
    tmpDirectory : String;
  Begin
    Result := false;
    tmpDirectory := RemoveRightDirectorySeparator(aDirectory);
    if tmpDirectory = '' then
    begin
      Result := true;
      exit;
    end;

    if Length(tmpDirectory) = 2 then
    begin
      if tmpDirectory[2] = ':' then
      begin
        // a drive only has been specified
        tmpDrive := UpCase(tmpDirectory[1] );
        if (tmpDrive < 'A') or (tmpDrive > 'Z') then
        begin
          // invalid drive; return false;
          exit;
        end;

        DosQueryCurrentDisk(tmpActualDrive, tmpDriveMap);
        tmpDriveNum := Ord(tmpDrive) - Ord('A') + 1; // A -> 1, B -> 2...
        tmpDriveBit := 1 shl (tmpDriveNum-1); // 2^DriveNum

        Result := tmpDriveMap and (tmpDriveBit) > 0;
        exit;
      end;
    end;

    tmpRC := FindFirst( tmpDirectory,
                        faArchive or faReadonly or faHidden or faSysFile or faDirectory or faMustDirectory,
                        tmpSearchResults);
    if tmpRC = 0 then
    begin
      Result:= true;
      FindClose(tmpSearchResults);
    end;
  end;


  Function DriveLetterToDriveNumber(const aDriveLetter : char) : longint;
  begin
    if     (aDriveLetter >= 'a')
       and (aDriveLetter <= 'z') then
    begin
      Result := Ord(aDriveLetter) - Ord('a') + 1;
      exit;
    end;

    if     (aDriveLetter >= 'A')
       and (aDriveLetter <= 'Z') then
    begin
      Result := Ord(aDriveLetter) - Ord('A') + 1;
      exit;
    end;

    // not a valid drive letter
    Result := 0;
  end;


  Function DriveNumberToDriveLetter(const aDriveNumber: longint) : char;
  begin
    Result := Chr(aDriveNumber - 1 + Ord('A'));
  end;


  Function GetVolumeLabel(aDrive: char) : String;
  var
    tmpRC : APIRET;
    tmpFileSystemInfo : FSINFO;
    e : EInOutError;
  begin
    DosErrorAPI( FERR_DISABLEHARDERR );
    Result := '';
    tmpRC := DosQueryFSInfo( DriveLetterToDriveNumber(aDrive),
                             FSIL_VOLSER,
                             tmpFileSystemInfo,
                             sizeof(tmpFileSystemInfo));
    if tmpRC = 0 then
    begin
      Result := StrPasWithLength(Addr(tmpFileSystemInfo.vol.szVolLabel), tmpFileSystemInfo.vol.cch);
      Result := LowerCase(Result);
    end;
    DosErrorAPI( FERR_ENABLEHARDERR );

    if tmpRC <> 0 then
    begin
      e := EInOutError.Create( 'Cannot read drive ' + aDrive + ':');
      e.ErrorCode := tmpRC;
      raise e;
    end;
  end;


  Function GetBootDriveLetter: char;
  var
    tmpBuffer: longword;
  begin
    DosQuerySysInfo( QSV_BOOT_DRIVE, QSV_BOOT_DRIVE, tmpBuffer, sizeof(tmpBuffer));
    Result := Chr(ord('A') + tmpBuffer - 1);
  end;


  Function FileIsReadOnly(const aFilename : String ) : boolean;
  begin
    Result :=(FileGetAttr(aFilename) AND faReadonly) > 0;
  end;




  // TODO


Function IsFloppyDrive( DriveNumber: longint ): Boolean;
Var
  bResult : Byte;
Begin
  DosDevConfig( bResult, DEVINFO_FLOPPY );
  Result := ( Abs( DriveNumber ) <= bResult);
End;

// -------------------------------------------------------------------------
// Funktion/Function: QueryCDRoms()
//
// Beschreibung:
//   Die Funktion QueryCDRom ermittelt ueber eine nicht dokumentierte
//   Schnittstelle die Anzahl der CDRom-Laufwerke und den ersten, fuer
//   ein CDRom-Laufwerk, vergebenen UnitIdentifier.
//   Der Treiber OS2CDROM.DMD stellt dem System zwei Devices (CD-ROM1$
//   und CD-ROM2$) zur Verfuegung. Die beiden Devices unterscheiden sich
//   durch DeviceAttribute. Beide Devices unterstuetzen (zumindest unter
//   Warp) den undokumentierten Generic IOCtl 0x82/0x60, welcher Infor-
//   mationen ueber die angeschlossenen CDRom-Laufwerke liefert.
//
// Description:
//   This Functions finds out how many CD-Rom Drives are present in System
//   and which Drive Letter is the first occupied by a CD-Rom. It uses an
//   undocumented Interface to OS2CDROM.DMD.
//   OS2CDROM.DMD presents two Devices (CD-ROM1$ and CD-ROM2$). These De-
//   vices are distinguished by their Device-Attributes. Both Devices sup-
//   port (under Warp) the undocumented generic IOCtl-Call 0x82/0x60 which
//   deliver some Information about the connected CD-Rom Drives.
//
// Parameter:
//   Var ulCDRomCount        ULONG     Anzahl CD-Rom Laufwerke im System
//                                     Number of CD-Rom Drives in System
//
//   Var ulFirstCDRomDiskNo  ULONG     erste Laufwerksnummer, die an ein
//                                     CD-Rom vergeben ist
//                                     first Drive-Letter occupied by a
//                                     CD-Rom Drive
//
// Rueckgabe/Returnvalue:  keine/none
// -------------------------------------------------------------------------
Procedure QueryCDRoms(Var ulCDRomCount, ulFirstCDRomDiskNo: ULONG);

Const cszDriverName : CSTRING = 'CD-ROM?$';

Var cCurDriver : Char;                    // Indexvariable fuer aktuell bearbeites Device (1 oder 2)
                                          // Index for current Device (1 or 2)

    hDevHandle : HFILE;                   // Handle fuer Device
                                          // Device handle

    ulAction   : ULONG;                   // Aktionscode (DosOpen())
                                          // Actioncode (DosOpen())

    ulParams   : ULONG;                   // Anzahl Bytes von IOCtl gelieferter Parameterdaten
                                          // Number of Bytes for delivered Parameterdata

    ulData     : ULONG;                   // Anzahl Bytes von IOCtl gelieferter Daten
                                          // Number of Bytes delivered by IOCtl

    rCDInfo    : Record                   // Ergebnisstruktur der IOCtl-Funktion (s.o.)
                                          // Record for Results of IOCtl-Call (see above)
                   usCDRomCount : USHORT; // Anzahl CD-Roms                   / Number of CD-Rom Drives
                   usFirstUnitNo: USHORT; // erste vergebene Laufwerksnummer  / first Driver Letter
                 End;

Begin (* uQueryCDRom *)
                                       /************************************
                                        * Vorbelegungen
                                        *
                                        * initial assignments
                                        ************************************/
  ulCDRomCount := 0;
  ulFirstCDRomDiskNo := 0;

  ulParams := 0;

                                       /************************************
                                        * die beiden Devices abarbeiten
                                        *
                                        * accessing both Devices
                                        ************************************/
  For cCurDriver := '1' To '2' Do
    Begin
                                       /************************************
                                        * Device oeffnen
                                        *
                                        * open Device
                                        ************************************/
      cszDriverName[6] := cCurDriver;
      If (DosOpen(cszDriverName,              // Devicename
                  hDevHandle,                 // Handle
                  ulAction,                   // Aktionscode
                  0,                          // Dateigr”áe
                  FILE_NORMAL,                // Attribute: read/write
                  OPEN_ACTION_OPEN_IF_EXISTS, // OpenFlag: ”ffnen, wenn vorhanden
                  OPEN_FLAGS_FAIL_ON_ERROR Or // Modus: Fehlermeldung per Returncode
                    OPEN_SHARE_DENYNONE Or    //        keine Einschr„nkungen fr Dritte
                    OPEN_ACCESS_READONLY,     //        nur lesender Zugriff
                  NIL)=NO_ERROR) Then         // keine EA
        Begin
                                       /************************************
                                        * IOCtl-Funktion aufrufen
                                        *
                                        * Call to IOCtl
                                        ************************************/
          If (DosDevIOCtl(hDevHandle,             // Handle                 / Handle
                          $82,                    // Kategorie              / Category
                          $60,                    // Funktion               / Function
                          NIL,                    // keine Parameterliste   / No Parameterlist
                          0,                      // Laenge Parameterliste  / Length of Parameterlist
                          ulParams,               // Groesse der gelieferten Parameterdaten
                                                  //                        / Number of Bytes for Parameterdata
                          rCDInfo,                // Puffer fuer gelieferte Daten
                                                  //                        / Buffer for returned Data
                          SizeOf(rCDInfo),        // Groesse des Datenpuffers
                                                  //                        / Size of Databuffer
                          ulData)=NO_ERROR) Then  // Groesse der gelieferten Daten
                                                  //                        / Number of Bytes for returned Data
            Begin
              ulCDRomCount := rCDInfo.usCDRomCount;
              ulFirstCDRomDiskNo := Succ(rCDInfo.usFirstUnitNo);
            End;

          DosClose(hDevHandle);
        End;

   End; (* For *)

End; (* uQueryCDRom *)


Function GetLocalDriveType( DriveNumber: longint ): TDriveType;
var
  IOCtlParameters: Word;
  rc: APIRET;
  ParameterLength: longWord;
  DataLength: longword;
  DeviceData: TDeviceParameters;
  Fixed: boolean;
  FirstCDDrive: ULONG;
  NumCDDrives: ULONG;
begin

  TWord( IOCtlParameters ).LoByte := 0;  // BPB of physical Device
  TWord( IOCtlParameters ).HiByte := DriveNumber - 1; // drive number, zero base

  ParameterLength := SizeOf( IOCtlParameters ); // input length of parameters
  DataLength := 0;                              // input length of data (none)

  rc := DosDevIOCTL( HFILE(-1),                 // Open Device (not a file)
                     IOCTL_DISK,                // Category
                     DSK_GETDEVICEPARAMS,       // Function
                     IOCtlParameters,           // Parameters
                     SizeOf( IOCtlParameters ), // (max) size of parameters
                     ParameterLength,           // parameters length
                     DeviceData,                // results
                     SizeOf( DeviceData ),      // (max) size of data block
                     DataLength );              // data block length

  Fixed := ( DeviceData.Attributes and 1 ) > 0;    // bit 0 indicates fixed (1) or removable (0)
  if not Fixed then
  begin
    result := dtRemovable;

    QueryCDRoms( FirstCDDrive,
                 NumCDDrives );

    if     ( DriveNumber >= FirstCDDrive )
       and ( DriveNumber < FirstCDDrive + NumCDDrives ) then
      result := dtCD;

    exit;
  end;

  result := dtHard;
end;

// Takes a one-based drive number
Function GetDriveType( DriveNumber: longint ): TDriveType;
var
  szDrive: CString;

  FSData: array[ 0..sizeof( FSQBuffer) + 3*_MAX_PATH ] of char;
  pBuffer: PFSQBUFFER2;
  FSDataLength: ULONG;

  rc: APIRET;
begin
  assert( DriveNumber >= 1 );
  assert( DriveNumber <= 26 );

  if ( DriveNumber >=1 ) and ( DriveNumber <= 2 ) then
  begin
    if IsFloppyDrive( DriveNumber ) then
    begin
      result := dtFloppy;
      exit;
    end;

    result := dtNone; // don't let OS/2 try a fake B: drive
    exit;
  end;

  DosErrorAPI( FERR_DISABLEHARDERR );

  szDrive := DriveNumberToDriveLetter( DriveNumber ) + ':';
  FSDataLength := sizeof( FSData );
  pBuffer := Addr( FSData );
  rc := _DosQueryFSAttach( szDrive,
                           0, // ignored
                           FSAIL_QUERYNAME,
                           pBuffer,
                           FSDataLength );

  if rc = 0 then
  begin
    case pBuffer^.iType of
      FSAT_REMOTEDRV:
        result := dtNetwork;

      FSAT_LOCALDRV:
        // Figure out what kind of local drive it is...
        result := GetLocalDriveType( DriveNumber );

      else
      begin
        // should never happen
        result := dtNone;
        exit;
      end;
    end;
  end
  else if rc = ERROR_NOT_READY then
  begin
    // No media?
    // Have a look for a local disk anyway.
    result := GetLocalDriveType( DriveNumber );
  end
  else
  begin
    result := dtNone;
  end;

  DosErrorAPI( FERR_ENABLEHARDERR );
end;

const
  DEVLEN = 8;
  CNLEN  = 15;               // Computer name length
  UNCLEN = (CNLEN+2);        // UNC computer name length
  NNLEN  = 12;               // 8.3 Net name length  (share name length)
  RMLEN  = (UNCLEN+1+NNLEN); // Maximum remote name length

type
  use_info_0 = record
    ui0_local: cstring[ DEVLEN ]; // note this is of size DEVLEN + 1
    ui0_pad_1: char;
    ui0_remote: pchar;
    space: array[ 0..RMLEN ] of char; // remote path is written to somewhere in here
  end;

  use_info_1 = record
    ui0_local: cstring[ DEVLEN ];
    ui0_pad_1: char;
    ui0_remote: pchar; // address of a buffer to hold remote path
    ui1_password: pchar; //
    ui1_status: USHORT;
    ui1_asg_type: SHORT;
    ui1_refcount: USHORT;
    ui1_usecount: USHORT;
    space: array[ 0..RMLEN ] of char; // remote path is written to somewhere in here
  end;

  TNet32UseGetInfo = Function( pszServer: pchar;
                               pszUseName: pchar; // e.g. drive x:
                               ulLevel: ULONG;
                               pbBuffer: pointer; // pointer to output buffer
                               ulBuffer: ULONG; // size of output in buffer
                               Var pulTotalAvail: ULONG )
                               : word; CDecl;

Var
  Net32UseGetInfo: TNet32UseGetInfo;
  hNetAPI32DLL: HMODULE;
  TriedLoading: boolean;

//   129 Net32UseGetInfo
Function GetNetworkDriveRemotePath( DriveNumber: longint ): string;
var
  ErrorName: array[ 0..255 ] of char;
  dummy: cstring;
  rc: word;
  UseName: array[ 0..255 ] of char;
  UseInfo: use_info_0;
  pUseInfo: pointer;
  TotalBytesNeeded: ULONG;
  RemotePath: array[ 0..255 ] of char;
  Dummy2: array[ 0..4096 ] of char; // try to fix stack probs
begin
  Result := '';

  if not TriedLoading then
  begin
    TriedLoading := true;
    rc := DosLoadModule( ErrorName,
                         sizeof( ErrorName ),
                         'NETAPI32',
                         hNetAPI32DLL );
    if rc = NO_ERROR then
    begin
      // NetAPI32.DLL loaded OK
      rc := DosQueryProcAddr( hNetAPI32DLL,
                              129,
                              dummy,
                              pointer( Net32UseGetInfo ) );
      if rc <> 0 then
        Net32UseGetInfo := nil;
    end;
  end;

  if Assigned( Net32UseGetInfo ) then
  begin
    UseName[ 0 ] := DriveNumberToDriveLetter( DriveNumber );
    UseName[ 1 ] := ':';
    UseName[ 2 ] := #0;

    RemotePath[ 0 ] := #0;
//    UseInfo.ui0_remote := Addr( RemotePath );

    pUseInfo := Addr( UseInfo );
    rc := Net32UseGetInfo( nil, // server - always nil
                           Addr( UseName ),
                           0, // info level 0
                           pUseInfo,
                           sizeof( UseInfo ),
                           TotalBytesNeeded );

    if rc = 0 then
      Result := StrPas( UseInfo.ui0_remote );

  end;
end;


Initialization
End.
