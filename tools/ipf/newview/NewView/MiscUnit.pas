Unit MiscUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt


// Miscellaneous objects...

Interface

uses
  HelpTopic,
  ACLString,
  NavigatePointUnit,
  HelpFile;

// Help Notes
// -----------------------------------------------------------

type
  THelpNote = class
    Text: TAString;
    Topic: TTopic;
    InsertPoint: longint;

    // calculated
    InsertText: TAString;

    constructor Create;
    destructor Destroy; override;
  end;

// Bookmarks
// -----------------------------------------------------------

type
  TBookmark = class( TNavigatePoint )
    Name: string;
    procedure Save( Var F: TextFile );
    constructor Load( Var F: TextFile; HelpFile: THelpFile );
  end;

Implementation

// Help Notes
// -----------------------------------------------------------
constructor THelpNote.Create;
begin
  Text := TAString.Create;
  InsertText := TAString.Create;
  Topic := nil;
  InsertPoint := -1;
end;

destructor THelpNote.Destroy;
begin
  Text.Destroy;
  InsertText.Destroy;
end;

// Bookmarks
// -----------------------------------------------------------

procedure TBookmark.Save( Var F: TextFile );
begin
  WriteLn( F, Name );
  inherited Save( F );
end;

constructor TBookmark.Load( Var F: TextFile; HelpFile: THelpFile );
begin
  ReadLn( F, Name );
  inherited Load( F, HelpFile );
end;

Initialization
End.
