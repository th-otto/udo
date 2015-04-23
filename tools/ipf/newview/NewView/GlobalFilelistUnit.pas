unit GlobalFilelistUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

interface

// Maintains a linked list in shared memory
// Mapping files (full path) to newview windows (frames)

uses
  OS2Def,
  SharedMemoryUnit,
  Semaphores;

const
  // size of shared mem used for storing global filelist
  GLOBAL_FILELIST_SIZE = 64000;

type
  TOpenFileEntry = record
    Next: ^TOpenFileEntry;
    Window: HWND;
    FilePath: array[ 0..255] of char;
  end;
  TPOpenFileEntry = ^ TOpenFileEntry;

  TGlobalFilelist = class
  protected
    FMem: TSuballocatedSharedMemory;
    FMutex: TMutex;
    function GetHead: TPOpenFileEntry;
    procedure SetHead( pEntry: TPOpenFileEntry );

    function FindEntry( const FilePath: string ): TPOpenFileEntry;
  public
    constructor Create;
    destructor Destroy; override;
    function FindFile( const FilePath: string ): HWND;
    procedure AddFile( const FilePath: string;
                       Window: HWND );

    procedure RemoveFile( Window: HWND;
                          const FilePath: string );
    procedure RemoveWindowFiles( Window: HWND );
  end;

implementation

uses
  StringUtilsUnit,
  DebugUnit,
  SysUtils;

constructor TGlobalFilelist.Create;
begin
  LogEvent(LogObjConstDest, '+ TGlobalFilelist.Create');

  FMem := TSuballocatedSharedMemory.Create( 'NEWVIEW_GLOBAL_FILELIST',
                                            GLOBAL_FILELIST_SIZE,
                                            4 ); // space for head pointer
  FMutex := TMutex.CreateNamed( 'NEWVIEW_FILELIST' );

  // hm. What about initialising the head pointer?
   // well I have changed suballocatedsharedmemory constructor
   // so that the first instance accessing the memory will clear the
   // reserved space to null...
end;

destructor TGlobalFilelist.Destroy;
begin
  LogEvent(LogObjConstDest, '- TGlobalFilelist.Destroy');

  FMem.Destroy;
  FMutex.Destroy;
end;

function TGlobalFilelist.GetHead: TPOpenFileEntry;
begin
  Result := TPOpenFileEntry( FMem.Data ^ );
end;

procedure TGlobalFilelist.SetHead( pEntry: TPOpenFileEntry );
begin
  TPOpenFileEntry( FMem.Data ^ ) := pEntry;
end;

procedure TGlobalFilelist.AddFile( const FilePath: string;
                                   Window: HWND );
var
  pEntry: TPOpenFileEntry;
begin
  FMutex.Get;

  try
    FMem.Allocate( pEntry,
                   sizeof( TPOpenFileEntry )
                   + sizeof( HWND )
                   + 1  // string length byte
                   + Length( FilePath ) );
  except
    begin
      // didn't fit: discard
      FMutex.Release;
      exit;
    end;
  end;

  // store handle, filename
  pEntry ^. Window := Window;
  StrPCopy( pEntry ^. FilePath, FilePath );
  
  // link into list at head
  pEntry ^. Next := GetHead;
  SetHead( pEntry );

  FMutex.Release;
end;

function TGlobalFilelist.FindEntry( const FilePath: string ): TPOpenFileEntry;
begin
  Result := GetHead;
  while ( Result <> nil ) do
  begin
    if ( StrEqualIgnoringCase( StrPas( Result ^. FilePath ), FilePath ) ) then
    begin
      // found
      exit;
    end;
    Result := Result ^. Next;
  end;
  // not found
end;

function TGlobalFilelist.FindFile( const FilePath: string ): HWND;
var
  pEntry: TPOpenFileEntry;
begin
  FMutex.Get;
  pEntry := FindEntry( FilePath );

  if pEntry <> nil then
    Result := pEntry ^. Window
  else
    Result := NULLHANDLE;

  FMutex.Release;
end;

// Remove specified file from list
procedure TGlobalFilelist.RemoveFile( Window: HWND;
                                      const FilePath: string );
var
  pEntry: TPOpenFileEntry;
  pPrevious: TPOpenFileEntry;
begin
  FMutex.Get;

  pEntry := GetHead;
  pPrevious := nil;
  while ( pEntry <> nil ) do
  begin
    if ( pEntry ^. Window = Window ) then
    begin
      if ( StrEqualIgnoringCase( StrPas( pEntry ^. FilePath ), FilePath ) ) then
      begin
        // found
        // remove node from list
        if pPrevious = nil then
          // head node has changed
          SetHead( pEntry ^.Next )
        else
          // point previous node to next node
          pPrevious ^.Next := pEntry ^.Next;

        FMem.Free( pEntry );

        // done
        FMutex.Release;
        exit;
      end;
    end;
    pPrevious := pEntry;
    pEntry := pEntry ^. Next;
  end;

  // not found! Bad programmer event
  FMutex.Release;

  raise Exception.Create( 'GlobalFilelist: File cannot be removed, since not added: ' + FilePath );
end;

procedure TGlobalFilelist.RemoveWindowFiles( Window: HWND );
var
  pEntry: TPOpenFileEntry;
  pPrevious: TPOpenFileEntry;
begin
  FMutex.Get;

  pEntry := GetHead;
  pPrevious := nil;
  while ( pEntry <> nil ) do
  begin
    if ( pEntry ^. Window = Window ) then
    begin
      // found
      // remove node from list
      if pPrevious = nil then
        // head node has changed
        SetHead( pEntry ^.Next )
      else
        // point previous node to next node
        pPrevious ^.Next := pEntry ^.Next;

      FMem.Free( pEntry );
      // continue looking - there could be more for this window
    end;
    pPrevious := pEntry;
    pEntry := pEntry ^. Next;
  end;
  FMutex.Release;
end;

begin
end.