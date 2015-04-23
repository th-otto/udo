Unit SystemIconUnit;

Interface

Uses
  Classes, Forms, Graphics, OS2Def;

{Declare new class}
Type
  TSystemIconID =
  (
    siArrow,           // Arrow pointer
    siText,            // Text I-beam pointer
    siWait,            // Hourglass pointer
    siSize,            // Size pointer
    siMove,            // Move pointer
    siSizeNWSE,        // Downward-sloping, double-headed arrow pointer
    siSizeNESW,        // Upward-sloping, double-headed arrow pointer
    siSizeWE,          // Horizontal, double-headed arrow pointer
    siSizeNS,          // Vertical, double-headed arrow pointer
    siAppIcon,         // Standard application icon pointer
    siIconInformation, // Information icon pointer
    siIconQuestion,    // Question mark icon pointer
    siIconError,       // Exclamation mark icon pointer
    siIconWarning,     // Warning icon pointer
    siIllegal,         // Illegal operation icon pointer
    siFile,            // Single file icon pointer
    siMultFile,        // Multiple files icon pointer
    siFolder,          //  Folder icon pointer
    siProgram          // Application program icon pointer
  );

  TSystemIcon = Class(TControl)
  Protected
    FHandle: HPOINTER;
    FID: TSystemIconID;
    Procedure SetupComponent; Override;
    Procedure Redraw( const rec: TRect ); Override;
    Procedure SetID( NewID: TSystemIconID );
  Public
    Destructor Destroy; Override;
  Published
    property ID: TSystemIconID read FID write SetID;
  End;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  TSystemIcon,'User','';

Implementation

Uses
  PmWin, PmBitmap, PmGpi;

const
  IDCode: array[ Low( TSystemIconID ) .. High( TSystemIconID ) ] of ULONG =
  (
    SPTR_ARROW,
    SPTR_TEXT,
    SPTR_WAIT,
    SPTR_SIZE,
    SPTR_MOVE,
    SPTR_SIZENWSE,
    SPTR_SIZENESW,
    SPTR_SIZEWE,
    SPTR_SIZENS,
    SPTR_APPICON,
    SPTR_ICONINFORMATION,
    SPTR_ICONQUESTION,
    SPTR_ICONERROR,
    SPTR_ICONWARNING,
    SPTR_ILLEGAL,
    SPTR_FILE,
    SPTR_MULTFILE,
    SPTR_FOLDER,
    SPTR_PROGRAM
  );

Procedure TSystemIcon.SetupComponent;
Begin
  Inherited SetupComponent;
  Width := 32;
  Height := 32;
  ID := siIconInformation;
  Name := 'SystemIcon';
  ParentColor := True;
  Exclude( ComponentState, csAcceptsControls );
End;

Destructor TSystemIcon.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TSystemIcon.SetID( NewID: TSystemIconID );
var
  Info: POINTERINFO;
  BMInfo: BITMAPINFOHEADER;
Begin
  if NewID = FID then
    exit;

  FID := NewID;

  FHandle := WinQuerySysPointer( HWND_DESKTOP,
                                 IDCode[ NewID ],
                                 false // don't copy
                                 );
  WinQueryPointerInfo( FHandle,
                       Info );
  if Info.hbmColor > 0 then
    // color bitmap
    GpiQueryBitmapParameters( Info.hbmColor,
                              BMInfo )
  else
    // b/w only
    GpiQueryBitmapParameters( Info.hbmPointer,
                              BMInfo );
  Width := BmInfo.cx;
  Height := BmInfo.cy;
  Refresh;
End;

Procedure TSystemIcon.Redraw( const rec: TRect );
Begin
  Canvas.ClipRect := rec;
  // clear background rectangle
  Canvas.FillRect( rec, Color );

  WinDrawPointer( Canvas.Handle, 0, 0, FHandle, DP_NORMAL );
End;

Initialization
  {Register classes}
  RegisterClasses([TSystemIcon]);
End.

