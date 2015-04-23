Unit WebBrowserUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the Gnu Public License - see readme.txt

Interface

  // Code for running the default browser.
  // Doesn't implement DDE!
  Procedure LaunchURL(const aURL: String);


Implementation

uses
  PMSHL,
  OS2Def,
  ACLUtility,
  SysUtils,
  RunProgramUnit,
  FileUtilsUnit;

const
  PROFILE_KEY_WPURLDEFAULTSETTINGS = 'WPURLDEFAULTSETTINGS';


  Function GetDefaultBrowserPath : String;
  begin
    Result := GetUserProfileString(PROFILE_KEY_WPURLDEFAULTSETTINGS, 'DefaultBrowserExe', '');
    if Result = '' then
    begin
      // try Web Explorer
      SearchPath('PATH', 'explore.exe', Result);
    end;
  end;


  Function GetDefaultBrowserWorkingDir : String;
  begin
    Result := GetUserProfileString(PROFILE_KEY_WPURLDEFAULTSETTINGS, 'DefaultWorkingDir', '');
    if Result = '' then
    begin
      Result := ExtractFilePath(GetDefaultBrowserPath);
    end;
  end;


  Function GetDefaultParameters : String;
  begin
    Result := GetUserProfileString(PROFILE_KEY_WPURLDEFAULTSETTINGS, 'DefaultParameters', '');
  end;



  Procedure LaunchURL(const aURL: String);
  var
    tmpBrowserPath : String;
    tmpBrowserWorkingDir : String;
    tmpBrowserParameters : String;
  begin
    tmpBrowserPath := GetDefaultBrowserPath;
    tmpBrowserWorkingDir := GetDefaultBrowserWorkingDir;
    tmpBrowserParameters := GetDefaultParameters;

    if tmpBrowserPath = '' then
    begin
      raise Exception.Create('You don''t have a default browser configured.');
    end;

    if not FileExists(tmpBrowserPath) then
    begin
      raise Exception.Create('Browser program doesn''t exist: ' + tmpBrowserPath);
    end;

    ChDir(RemoveRightDirectorySeparator(tmpBrowserWorkingDir));

    LaunchProgram(tmpBrowserPath, tmpBrowserParameters + ' ' + aURL, tmpBrowserWorkingDir);
  end;

Initialization
End.
