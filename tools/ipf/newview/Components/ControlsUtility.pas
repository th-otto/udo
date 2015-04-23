unit ControlsUtility;

interface

uses
  Classes, StdCtrls, SysUtils,
  ACLUtility,
{$ifdef win32}
  ExtCtrls, Forms, Controls, ComCtrls, Windows, Messages, Graphics;
{$else}
  OS2Def, Forms;
{$endif}

const
{$ifdef win32}
  Mnem = '&';
{$else}
  Mnem = '~';
{$endif}

function GetComponentsVersion: string;

function InvertRGB( Arg: TColor ): TColor;

function GetScreenColorDepth: longint;
function GetVideoDriverName: string;

procedure SmartGetWindowPos( Form: TForm;
                             Var X, Y, W, H: longint;
                             Var Maximised: boolean );

procedure SmartSetWindowPos( Form: TForm;
                             X, Y, W, H: longint;
                             Maximised: boolean );

// Load/save form to inifile
Procedure SaveFormSizePosition( Form: TForm;
                                IniFile: TMyIniFile );
Procedure LoadFormSizePosition( Form: TForm;
                                IniFile: TMyIniFile );

{$ifdef os2}
// Utility access to the link (hand) cursor
Function GetLinkCursor: TCursor;

// set a wait cursor. If already set, increments a count
procedure SetWaitCursor;

// clear wait cursor. Only actually clears it if the count is now 0.
procedure ClearWaitCursor;

function GetNiceDefaultFont: TFont;
{$endif}

procedure StartTimer( Timer: TTimer );
procedure StopTimer( Timer: TTimer );

// Listbox utility functions
Function SelectedObject( ListBox: TListBox ): TObject;
Procedure SetSelectedByObject( ListBox: TListBox;
                               SelectObject: TObject );
Function SelectedItem( ListBox: TListBox ): string;
Procedure GetSelectedItems( ListBox: TListBox;
                            Dest: TStrings );

{$ifdef win32}
procedure SetFocusTo( Control: TWinControl );
{$else}
procedure SetFocusTo( Control: TControl );
{$endif}

{$ifdef win32}
Procedure AddBoldedLine( RichEdit: TRichEdit;
                         BoldPart: string;
                         NormalPart: string );

Procedure GetExpandedNodes( TreeView: TTreeView;
                            ExpandedNodeList: TStrings );

{$endif}

{$ifdef os2}
Procedure ScaleForm( Form: TForm;
                     OriginalFontWidth: longint;
                     OriginalFontHeight: longint );

// Validate all known SPCC components
// Checks that their memory storage is valid
// (refers to valid parts of the heap)
procedure ValidateSPCCObjects;

Procedure LogException( E: Exception;
                        const LogFileName: string;
                        const Title: string;
                        const AppVersion: string;
                        var F: TextFile );

// Find topmost form window of specified class name
Function FindTopFormWindow( const WindowClassName: string ): HWND;

{$endif}


implementation

{$ifdef os2}
uses
  PMGpi, PMDev, PMShl, DOS, PMWin, BseDos,
  TabCtrls,
  MultiColumnListBox,
  Graphics;

{$R ControlsUtility}

Var
  TheLinkCursor: TCursor; // loaded on unit initialisation.
  TheLinkPointer: TPointer; // loaded on unit initialisation.

function GetNiceDefaultFont: TFont;
var
  OverrideAppFontName: string;
  OverrideAppFontSize: string;
begin
  // For Marco!
  OverrideAppFontName := GetEnv( 'ACL_OVERRIDE_FONT_NAME' );
  OverrideAppFontSize := GetEnv( 'ACL_OVERRIDE_FONT_SIZE' );

  try
    if OverrideAppFontName <> '' then
    begin
      Result := Screen.GetFontFromPointSize( OverrideAppFontName,
                                             StrToInt( OverrideAppFontSize ) );
      if Result <> nil then
        exit;
    end;
  except
  end;

  if Application.DBCSSystem then
  begin
    // try Warpsans Combined
    Result := Screen.GetFontFromPointSize( 'WarpSans Combined', 9 );
    if Result <> nil then
     // ok use warpsans
      exit;
  end;
  // try warpsans.9
  Result := Screen.GetFontFromPointSize( 'WarpSans', 9 );
  if Result <> nil then
    // ok use warpsans
    exit;

  // try Helv.8
  Result := Screen.GetFontFromPointSize( 'Helv', 8 );
  if Result <> nil then
    // ok use helv
    exit;

  // Ok, system default
  Result := Screen.DefaultFont;
end;
{$endif}

var
  g_WaitCursorCount: longint;

procedure SetWaitCursor;
begin
  if g_WaitCursorCount = 0 then
    Screen.Cursor := crHourGlass;

  inc( g_WaitCursorCount );
end;

procedure ClearWaitCursor;
begin
  if g_WaitCursorCount > 0 then
  begin
    dec( g_WaitCursorCount );
    if g_WaitCursorCount = 0 then
    begin
      Screen.Cursor := crDefault;
    end;
  end;

end;

procedure StartTimer( Timer: TTimer );
begin
{$ifdef win32}
  Timer.Enabled := true;
{$else}
  Timer.Start;
{$endif}
end;

procedure StopTimer( Timer: TTimer );
begin
{$ifdef win32}
  Timer.Enabled := false;
{$else}
  Timer.Stop;
{$endif}
end;

{$ifdef win32}
procedure SetFocusTo( Control: TWinControl );
begin
   Control.SetFocus;
end;
{$else}
procedure SetFocusTo( Control: TControl );
begin
   Control.Focus;
end;
{$endif}

{$ifdef win32}
const
  EndLineStr = #13 +#10;
  
Procedure AddBoldedLine( RichEdit: TRichEdit;
                         BoldPart: string;
                         NormalPart: string );
var
  LineStart: integer;
  Dummy: integer;
begin
  with RichEdit do
  begin
    SendMessage( Handle,
                 EM_GETSEL,
                 Longint( Addr( LineStart ) ),
                 Longint( Addr( Dummy ) ) );

    SendMessage( Handle,
                 EM_REPLACESEL,
                 0,
                 Longint(PChar( BoldPart)));

    SelStart:= LineStart;
    SelLength:= Length( BoldPart );
    SelAttributes.Style:= [ fsBold ];

    SelStart:= LineStart + Length( BoldPart );
    SelLength:= 0;
    SendMessage( Handle,
                 EM_REPLACESEL,
                 0,
                 Longint(PChar( NormalPart)));
    SelStart:= LineStart + Length( BoldPart );
    SelLength:= Length( NormalPart );
    SelAttributes.Style:= [];
    SelStart:= LineStart + Length( BoldPart )
               + Length( NormalPart );
    SelLength:= 0;
    SendMessage( Handle,
                 EM_REPLACESEL,
                 0,
                 Longint(PChar( EndLineStr )));

  end;

end;

Procedure GetExpandedNodesCumulative( Node: TTreeNode;
                                      ExpandedNodeList: TStrings;
                                      const Path: string );
var
  SubNode: TTreeNode;
begin
  if Node.Expanded then
  begin
    ExpandedNodeList.Add( Path + Node.Text );
    
    SubNode := Node.getFirstChild;
    while SubNode <> nil do
    begin
      GetExpandedNodesCumulative( SubNode,
                                  ExpandedNodeList,
                                  Path + Node.Text + '\' );
      SubNode := SubNode.getNextSibling;
    end;
  end;
end;

Procedure GetExpandedNodes( TreeView: TTreeView;
                            ExpandedNodeList: TStrings );
begin
  ExpandedNodeList.Clear;
  if TreeView.Items.GetFirstNode = nil then
    exit;
  GetExpandedNodesCumulative( TreeView.Items.GetFirstNode,
                              ExpandedNodeList,
                              '' );
end;

{$endif}

function InvertRGB( Arg: TColor ): TColor;
begin
{$ifdef os2}
  Result:= SysColorToRGB( Arg ); // in case it's a system color e.g. button face
{$endif}
{$ifdef win32}
  Result := ColorToRGB( Arg );
{$endif}
  Result:= Result xor $ffffff; // now invert the RGB components
end;

function GetScreenColorDepth: longint;
var
  DeviceContext: HDC;
begin
{$ifdef os2}
  // OS/2
  DeviceContext := GpiQueryDevice( Screen.Canvas.Handle );
  DevQueryCaps( DeviceContext,
                CAPS_COLOR_BITCOUNT,
                1,
                Result );
{$endif}
{$ifdef win32}
  // Windows
  DeviceContext := CreateCompatibleDC( 0 ); // get screen dc
  Result := GetDeviceCaps( DeviceContext,
                           BITSPIXEL );
  DeleteDC( DeviceContext );
{$endif}
end;

function GetVideoDriverName: string;
{$ifdef os2}
var
  BaseDisplayDriverName: cstring;
  GraddChains: string;
  GraddDriverName: string;
{$endif}
begin
{$ifdef os2}
  // Get the PM display driver name from OS2.ini (strangely, NOT os2sys.ini).
  PrfQueryProfileString( HINI_USERPROFILE, // OS2 INI
                         'PM_DISPLAYDRIVERS', // app
                         'CURRENTDRIVER', // key
                         'Unknown Display Driver', // default
                         BaseDisplayDriverName,
                         sizeof( BaseDisplayDriverName ) );

  if BaseDisplayDriverName <> 'GRE2VMAN' then
  begin
    // non-gradd (old style) driver.
    Result := BaseDisplayDriverName;
    exit;
  end;

  // it's a GRADD driver
  // Get the GRADD_CHAINS environment variable, this tells us
  // where to look for more info...
  GraddChains := GetEnv( 'GRADD_CHAINS' );
  if GraddChains = '' then
  begin
    Result := 'Unknown GRADD driver (GRADD_CHAINS not set)';
    exit;
  end;

  // OK, now get the environment variable GRADD_CHAINS refers to...
  GraddDriverName := GetEnv( GraddChains );
  if GraddDriverName = '' then
  begin
    Result := 'Unknown GRADD driver (GRADD_CHAINS: '
              +  GraddChains
              + ' returns blank)';
    exit;
  end;

  // Normal GRADD case
  Result := 'GRADD: '
            + GraddDriverName;

  // if sddgradd then ...?
{$endif}
end;

procedure SmartSetWindowPos( Form: TForm;
                             X, Y, W, H: longint;
                             Maximised: boolean );
begin
{$ifdef os2}
  if Form.Handle = 0 then
  begin
    // window not yet created, set the position for restore then maximize
    Form.SetWindowPos( X, Y, W, H );
    if Maximised then
      Form.WindowState := wsMaximized;
    exit;
  end;

  // window already created

  if Form.WindowState = wsMaximized then
  begin
    // window already maximized, so set the restore position in window USHORTs
    WinSetWindowUShort( Form.Frame.Handle, QWS_XRESTORE, X );
    WinSetWindowUShort( Form.Frame.Handle, QWS_YRESTORE, Y );
    WinSetWindowUShort( Form.Frame.Handle, QWS_CXRESTORE, W );
    WinSetWindowUShort( Form.Frame.Handle, QWS_CYRESTORE, H );

    // And reposition in maximized state
    X := 0;
    Y := 0;

    if Form.Parent = nil then
    begin
      W := Screen.Width;
      H := Screen.Height;
    end
    else
    begin
      W := Form.Parent.ClientWidth;
      H := Form.Parent.ClientHeight;
    end;

    // We enlarge the area used so that the border is off screen.
    if Form.BorderStyle <> bsNone then
    begin
      dec( X, GetBorderWidth( Form ) );
      dec( Y, GetBorderHeight( Form ) );
      inc( W, GetBorderWidth( Form ) * 2 );
      inc( H, GetBorderHeight( Form ) * 2 );
    end;
    Form.SetWindowPos( X, Y, W, H );
  end
  else
  begin
    // Window not currently maximized
    Form.SetWindowPos( X, Y, W, H );
    if Maximised then
      Form.WindowState := wsMaximized;
  end;
{$else}
  // set the position for restore then maximize
  Form.Left := X;
  Form.Top := Y;
  Form.Width := W;
  Form.Height := H;
  if Maximised then
    Form.WindowState := wsMaximized;
{$endif}
end;

procedure SmartGetWindowPos( Form: TForm;
                             Var X, Y, W, H: longint;
                             Var Maximised: boolean );
{$ifdef win32}
var
  Placement: WINDOWPLACEMENT;
{$endif}
begin
  X := Form.Left;
{$ifdef os2}
  Y := Form.Bottom;
{$else}
  Y := Form.Top;
{$endif}
  W := Form.Width;
  H := Form.Height;
  Maximised := Form.WindowState = wsMaximized;
  if Form.Handle = 0 then
  begin
    // window not yet created, so we are done.
    exit;
  end;

  // window already created

{$ifdef os2}
  if Form.WindowState in [ wsMaximized, wsMinimized ] then
  begin
    // window already maximized, so get the restore position from window USHORTs
    X := WinQueryWindowUShort( Form.Frame.Handle, QWS_XRESTORE );
    Y := WinQueryWindowUShort( Form.Frame.Handle, QWS_YRESTORE );
    W := WinQueryWindowUShort( Form.Frame.Handle, QWS_CXRESTORE );
    H := WinQueryWindowUShort( Form.Frame.Handle, QWS_CYRESTORE );
  end;
{$endif}
{$ifdef win32}
  // get normal position
  Placement.length := sizeof( Placement );
  GetWindowPlacement( Form.Handle, @Placement );
  X := Placement.rcNormalPosition.Left;
  Y := Placement.rcNormalPosition.Top;
  W := Placement.rcNormalPosition.Right - Placement.rcNormalPosition.Left;
  H := Placement.rcNormalPosition.Bottom - Placement.rcNormalPosition.Top;
{$endif}
end;

Procedure SaveFormSizePosition( Form: TForm;
                                IniFile: TMyIniFile );
Var
  Maximised: boolean;
  X: longint;
  Y: longint;
  W: longint;
  H: longint;
  Section: string;
Begin
  Section := Form.Name;

  SmartGetWindowPos( Form, X, Y, W, H, Maximised );

  IniFile.WriteInteger( Section,
                        'X',
                        X );
  IniFile.WriteInteger( Section,
                        'Y',
                        Y );
  IniFile.WriteInteger( Section,
                        'Width',
                        W );
  IniFile.WriteInteger( Section,
                        'Height',
                        H );

  IniFile.WriteBool( Section,
                     'Maximised',
                     Maximised );
End;

Procedure LoadFormSizePosition( Form: TForm;
                                IniFile: TMyIniFile );
Var
  Maximised: boolean;
  X: longint;
  Y: longint;
  W: longint;
  H: longint;
  Section: string;
Begin
  Section := Form.Name;

  X := IniFile.ReadInteger( Section,
                            'X',
                            Form.Left );
  Y := IniFile.ReadInteger( Section,
                            'Y',
{$ifdef os2}
                            Form.Bottom );
{$else}
                            Form.Top );
{$endif}
  W := IniFile.ReadInteger( Section,
                            'Width',
                            Form.Width );
  H := IniFile.ReadInteger( Section,
                            'Height',
                            Form.Height );

  Maximised := IniFile.ReadBool( Section,
                                 'Maximised',
                                 Form.WindowState = wsMaximized );
  SmartSetWindowPos( Form, X, Y, W, H, Maximised );

End;

Function SelectedObject( ListBox: TListBox ): TObject;
begin
  if ( ListBox.ItemIndex >= 0 )
     and ( ListBox.ItemIndex < ListBox.Items.Count ) then
    Result:= ListBox.Items.Objects[ ListBox.ItemIndex ]
  else
    Result:= nil;
end;

Procedure SetSelectedByObject( ListBox: TListBox;
                               SelectObject: TObject );
var
  Index: integer;
begin
  Index := ListBox.Items.IndexOfObject( SelectObject );
  ListBox.ItemIndex := Index;
end;

Function SelectedItem( ListBox: TListBox ): string;
begin
  if ( ListBox.ItemIndex >= 0 )
     and ( ListBox.ItemIndex < ListBox.Items.Count ) then
    Result:= ListBox.Items[ ListBox.ItemIndex ]
  else
    Result:= '';
end;

Procedure GetSelectedItems( ListBox: TListBox;
                            Dest: TStrings );
var
  i: integer;
begin
  for i:= 0 to ListBox.Items.Count - 1 do
    if ListBox.Selected[ i ] then
      Dest.AddObject( ListBox.Items[ i ],
                      ListBox.Items.Objects[ i ] );
end;

{$ifdef os2}

procedure ScaleChildren( Control: TControl;
                         ScalePosition: boolean;
                         XFactor: double;
                         YFactor: double );
  forward;

Procedure ScaleControl( Control: TControl;
                        ScalePosition: boolean;
                        XFactor: double;
                        YFactor: double );
var
  SizeX: boolean;
  SizeY: boolean;
begin
  SizeX := true;
  SizeY := true;

  if Control is TEdit then
    if TEdit( Control ).AutoSize then
      SizeY := false;

  if Control is TLabel then
  begin
    if TLabel( Control ).AutoSize then
    begin
      SizeX := false;
      SizeY := false;
    end;
  end;

  if SizeX then
    Control.ClientWidth := Round( Control.ClientWidth * XFactor );

  if SizeY then
    Control.ClientHeight := Round( Control.ClientHeight * YFactor );

  if ScalePosition then
  begin
    Control.Left := Round( Control.Left * XFactor );
    Control.Bottom := Round( Control.Bottom * YFactor );
  end;

  if Control is TTabbedNotebook then
    // size the tabset to match
    TTabbedNotebook( Control ).TabHeight :=
      Round( TTabbedNotebook( Control ).TabHeight * YFactor );

  if Control is TMultiColumnListBox then
    TMultiColumnListBox( Control ).HeaderHeight :=
      Round( TMultiColumnListBox( Control ).HeaderHeight * YFactor );

  if csDetail in Control.ComponentState then
    exit;
  if not ( csAcceptsControls in Control.ComponentState ) then
    exit;

  ScaleChildren( Control,
                 ScalePosition,
                 XFactor,
                 YFactor );
end;

procedure ScaleChildren( Control: TControl;
                         ScalePosition: boolean;
                         XFactor: double;
                         YFactor: double );
var
  i: longint;
  Child: TControl;
begin
  for i := 0 to Control.ControlCount do
  begin
    Child := Control.Controls[ i ];
    if Child = nil then
      continue;

    if Control is TTabbedNotebook then
    begin
      if Child is TTabSet then
        // tabset sized elsewhere
        continue;

      if Child is TNotebook then
      begin
        // notebook has been sized as part of TTabbedNotebook
        ScaleChildren( Child, true, XFactor, YFactor );
        continue;
      end;

    end;

    if Child is TPage then
    begin
      // Only size children, notebook has sized page
      ScaleChildren( Child, true, XFactor, YFactor );
      continue;
    end;

    ScaleControl( Child,
                  true,
                  XFactor,
                  YFactor );
  end;
end;

Function AdjustFactor( Factor: double ): double;
begin
  if Factor <= 1.0 then
    result := Factor
  else if ( Factor > 1.0 ) and ( Factor < 1.2 ) then
    result := 1.0
  else
    result := Factor - 0.2;

end;

var
  ScaledForms: TList;

Procedure ScaleForm( Form: TForm;
                     OriginalFontWidth: longint;
                     OriginalFontHeight: longint );
var
  XFactor: double;
  YFactor: double;
  UseWidth: double;
  UseHeight: double;
begin
  if ScaledForms.IndexOf( Form ) <> -1 then
    // already scaled this form.
    exit;
  ScaledForms.Add( Form );

  UseWidth := Form.Canvas.TextWidth( 'M' );
  UseHeight := Form.Canvas.TextHeight( 'M' );

  XFactor := AdjustFactor( UseWidth / OriginalFontWidth );
  YFactor := AdjustFactor( UseHeight / OriginalFontHeight );

  if    ( XFactor = 1.0 )
    and ( YFactor = 1.0 ) then
    // no scaling to do, skip it for efficiency
    exit;

  ScaleControl( Form,
                false,
                XFactor,
                YFactor );

end;

// Validate component memory and it's owned components
procedure ValidateComponent( Component: TComponent );
var
  i: longint;
begin
  CheckMem( Component );
  for i := 0 to Component.ComponentCount - 1 do
    ValidateComponent( Component.Components[ i ] );
end;

// Validate all known SPCC components
procedure ValidateSPCCObjects;
var
  i: longint;
  Form: TForm;
begin
  CheckHeap;

  ValidateComponent( Screen );
  ValidateComponent( ClipBoard );
  for i := 0 to Screen.FormCount - 1 do
  begin
    Form := Screen.Forms[ i ];
    ValidateComponent( Form );
  end;
end;

Function GetSystemInfoItem( Item: ULONG ): ULONG;
begin
  DosQuerySysInfo( Item,
                   Item,
                   Result,
                   sizeof( Result ) );
end;

Procedure LogException( E: Exception;
                        const LogFileName: string;
                        const Title: string;
                        const AppVersion: string;
                        var F: TextFile );
var
  i: integer;
  OSMajorVersion: ULONG;
  OSMinorVersion: ULONG;
  OSRevision: ULONG;
  RamMB: ULONG;
  BootDrive: ULONG;
begin
  AssignFile( F, LogFilename );
  FileMode := fmInOut;

  try
    if FileExists( LogFilename ) then
      Append( F )
    else
      Rewrite( F );
  except
    exit;
  end;

  try
    WriteLn( F, '' );
    WriteLn( F, '---- ' + Title + ' crash log ----' );
    WriteLn( F, 'App Version: ' +  AppVersion );
    WriteLn( F, 'Components Version: ' +  GetComponentsVersion );
    WriteLn( F, 'Library Version: ' +  GetACLLibraryVersion );
    WriteLn( F, '' );
    WriteLn( F, 'Running as process: ' + GetApplicationFilename );
    WriteLn( F, FormatDateTime( 'd mmmm yyyy, hh:mm:ss', now ) );
    WriteLn( F, 'Exception type: ' + E.ClassName );
    WriteLn( F, 'Description: ' + E.Message );
    WriteLn( F, 'Location: $'
                 + IntToHex( longword( E.ExcptAddr ), 8 ) );

    WriteLn( F, 'Callstack:' );

    for i := 0 to GetExceptionCallCount - 1 do
    begin
      WriteLn( F, ' $' + IntToHex( GetExceptionCallstackEntry( i ), 8 ) );
    end;

    OSMajorVersion := GetSystemInfoItem( QSV_VERSION_MAJOR );
    OSMinorVersion := GetSystemInfoItem( QSV_VERSION_MINOR );
    OSRevision :=     GetSystemInfoItem( QSV_VERSION_REVISION );

    WriteLn( F, 'System version:'
                 + IntToStr( OSMajorVersion )
                 + '.'
                 + IntToStr( OSMinorVersion )
                 + '.'
                 + IntToStr( OSRevision ) );
    if OSMajorVersion = 20 then
    begin
      case OSMinorVersion of
        00: WriteLn( F, '  OS/2 2.0' );
        10: WriteLn( F, '  OS/2 2.1' );
        11: WriteLn( F, '  OS/2 2.11' );
        30: WriteLn( F, '  OS/2 3.0' );
        40: WriteLn( F, '  OS/2 4.0' );
        45: WriteLn( F, '  OS/2 4.5' ); // I guess
      end;
    end;

    RamMB := GetSystemInfoItem( QSV_TOTPHYSMEM )
             div ( 1024 * 1024 );
    WriteLn( F, 'RAM: '
                + IntToStr( RamMB )
                + ' MB' );

    BootDrive := GetSystemInfoItem( QSV_BOOT_DRIVE ); // nA = 1
    WriteLn( F, 'Boot drive: '
                + Chr( Ord( 'A' )
                + BootDrive - 1 ) );

    // Video information
    WriteLn( F, 'Video resolution: '
                + IntToStr( Screen.Width )
                + 'x'
                + IntToStr( Screen.Height ) );
    WriteLn( F, 'Color depth: '
                + IntToStr( GetScreenColorDepth )
                + ' bits' );
    WriteLn( F, 'Video driver: '
                + GetVideoDriverName );
  except
  end;

end;

Function FindTopFormWindow( const WindowClassName: string ): HWND;
var
  EnumHandle: HENUM;
  ChildEnumHandle: HENUM;
  Child: HWND;

  Buffer: array[ 0..31 ] of char;
  FrameClassName: array[ 0..31 ] of char;
  MyClassName: array[ 0..31 ] of char;
  Len: longint;
  FrameClassConst: longint;
  Found: boolean;
begin
  FrameClassConst := WC_FRAME;
  StrPCopy( FrameClassName, '#' + IntToStr( USHORT( FrameClassConst ) ) );
  StrPCopy( MyClassName, WindowClassName );

  // first enum desktop children to find Frame windows
  EnumHandle := WinBeginEnumWindows( HWND_DESKTOP );
  while true do
  begin
    result := WinGetNextWindow( EnumHandle );
    if result = NULLHANDLE then
      // ran out
      break;

    Len := WinQueryClassName( result, sizeof( Buffer ), Buffer );
    Buffer[ Len ] := #0;
    if StrLComp( Buffer, FrameClassName, sizeof( Buffer ) ) = 0 then
    begin
      // this is a WC_FRAME window
      // look thru it's children for the form name we want...

      ChildEnumHandle := WinBeginEnumWindows( result );

      Found := false;
      while true do
      begin
        Child := WinGetNextWindow( ChildEnumHandle );
        if Child = NULLHANDLE then
          break;

        Len := WinQueryClassName( Child, sizeof( Buffer ), Buffer );
        if StrLComp( Buffer, MyClassName, sizeof( Buffer ) ) = 0 then
        begin
          // found
          Found := true;
          break;
        end;
      end;
      WinEndEnumWindows( ChildEnumHandle );
      if Found then
        break;
    end;
  end;
  WinEndEnumWindows( EnumHandle );
end;

Function GetLinkCursor: TCursor;
begin
  Result := TheLinkCursor;
end;
{$endif}

const
  LibVersion = 'v1.11.26'; // // $SS_REQUIRE_NEW_VERSION$

function GetComponentsVersion: string;
begin
  Result := LibVersion;
end;

{$ifdef os2}
Initialization
  ScaledForms := TList.Create;

  TheLinkPointer := TPointer.Create;
  TheLinkPointer.LoadFromResourceName( 'LinkPointer' );
  TheLinkCursor := Screen.AddCursor( TheLinkPointer.Handle );

Finalization
  ScaledForms.Destroy;
  TheLinkPointer.Destroy;
{$endif}
end.
