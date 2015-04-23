Unit NavigatePointUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

uses
  Classes,
  HelpFile,
  HelpTopic,
  HelpWindowDimensions;

type
  // Navigate point: a saved history position specifiying
  // a set of windows that were displayed.
  TNavigatePoint = class
    ContentsTopic: TTopic;
    Windows: TList;
    constructor Create;
    destructor Destroy; Override;
    procedure Save( Var F: TextFile );
    constructor Load( Var F: TextFile; HelpFile: THelpFile );
  end;

  // A help window definition as saved in a navigate point
  TSavedHelpWindow = class
    Topic: TTopic;
    Group: longint;

    ChildWindows: TList;
    Parent: TSavedHelpWindow;

    Rect: THelpWindowRect;

    TopCharIndex: longint; // used when saving for navigation

    constructor Create;
    destructor Destroy; override;
    procedure Save( Var F: TextFile; Prefix: string; );
    constructor Load( Var F: TextFile; HelpFile: THelpFile );
  end;

Implementation

uses
  SysUtils,
  ACLUtility,
  StringUtilsUnit,
  DebugUnit;

procedure SaveWindowList( Var F: TextFile;
                          Windows: TList;
                          Prefix: string );
var
  i: integer;
  Window: TSavedHelpWindow;
  S: string;
begin
  S := Prefix + IntToStr( Windows.Count );
  WriteLn( F, S );
  for i := 0 to Windows.Count - 1 do
  begin
    Window := Windows[ i ];
    Window.Save( F, Prefix + ' ' );
  end;
end;

procedure LoadWindowList( Var F: TextFile;
                          Windows: TList;
                          HelpFile: THelpFile );
var
  i: integer;
  Window: TSavedHelpWindow;
  WindowCount: integer;
  S: string;
begin
  ReadLn( F, S );
  try
    WindowCount := StrToInt( S );
  except
    WindowCount := 0;
  end;
  for i := 0 to WindowCount - 1 do
  begin
    Window := TSavedHelpWindow.Load( F, HelpFile );
    Windows.Add( Window );
  end;
end;

// --- TNavigatePoint ---------------------------------

constructor TNavigatePoint.Create;
begin
  inherited Create;
  ContentsTopic:= nil;
  Windows:= TList.Create;
end;

destructor TNavigatePoint.Destroy;
begin
  inherited Destroy;
  DestroyListObjects( Windows );
  Windows.Destroy;
end;

procedure TNavigatePoint.Save( Var F: TextFile );
begin
  WriteLn( F, IntToStr( ContentsTopic.Index ) );
  SaveWindowList( F, Windows, '' );
end;

constructor TNavigatePoint.Load( Var F: Text;
                                 HelpFile: THelpFile );
Var
  s: string;
  ContentsTopicIndex: integer;
begin
  inherited Create;
  ReadLn( F, S );
  ContentsTopicIndex := StrToInt( S );
  ContentsTopic:= HelpFile.Topics[ ContentsTopicIndex ];

  Windows:= TList.Create;
  LoadWindowList( F, Windows, HelpFile );
end;

// --- TSavedHelpWindow ---------------------------------

constructor TSavedHelpWindow.Create;
begin
  inherited Create;
  ChildWindows:= TList.Create;
  Rect:= THelpWindowRect.Create;
end;

destructor TSavedHelpWindow.Destroy;
begin
  DestroyListObjects( ChildWindows );
  ChildWindows.Destroy;
  Rect.Destroy;
  inherited Destroy;
end;

procedure TSavedHelpWindow.Save( Var F: TextFile;
                                 Prefix: string );
begin
  WriteLn( F,
           Prefix
           + IntToStr( Topic.Index )
           + ', '
           + IntToStr( Group )
           + ', '
           + IntToStr( Rect.Left )
           + ', '
           + IntToStr( Rect.Bottom )
           + ', '
           + IntToStr( Rect.Width )
           + ', '
           + IntToStr( Rect.Height )
           + ', '
           + IntToStr( TopCharIndex )
         );
  SaveWindowList( F, ChildWindows, Prefix );
end;

constructor TSavedHelpWindow.Load( Var F: TextFile );
var
  tmpString : string;
  TopicIndex: integer;
  tmpParts : TStringList;
begin
  inherited Create;
  ChildWindows:= TList.Create;
  Rect:= THelpWindowRect.Create;

  ReadLn( F, tmpString);
  tmpParts := TStringList.Create;
  StrExtractStrings(tmpParts, tmpString, [','], #0);

  TopicIndex   := StrToInt(tmpParts[0]);
  Topic := HelpFile.Topics[ TopicIndex ];
  Group        := StrToInt(tmpParts[1]);
  Rect.Left    := StrToInt(tmpParts[2]);
  Rect.Bottom  := StrToInt(tmpParts[3]);
  Rect.Width   := StrToInt(tmpParts[4]);
  Rect.Height  := StrToInt(tmpParts[5]);
  TopCharIndex := StrToInt(tmpParts[6]);

  tmpParts.Destroy;

  LoadWindowList( F, ChildWindows, HelpFile );
end;

Initialization
End.
