
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{************************************************}
{                                                }
{ Speed-Pascal 2.0 Printer support Unit          }
{                                                }
{ Copyright (C) 1996-1997 Joerg Pleumann         }
{                                                }
{ Please mail All bugs And suggestions To:       }
{                                                }
{ Internet: pleumann @ uni-duisburg.de           }
{ FidoNet:  Joerg Pleumann @ 2:2448/136.6        }
{                                                }
{************************************************}

Unit Printers;

Interface

{$IFDEF OS2}
Uses
  Os2Def, PmSpl;
{$ENDIF}

Uses SysUtils, Classes, Forms, Graphics;

Type
  EPrinter = Class(Exception);
    { raised In Case Of Printer errors. }

  TPrinterOrientation = (poPortrait, poLandscape);
    { used For Orientation Property. }

  TPrinterState = (psNoHandle, psHandleIC, psHandleDC);
    { internal. }

  {$IFDEF OS2}
  TQueueInfo = Array[0..1023] Of PRQINFO3;
  PQueueInfo = ^TQueueInfo;
    { internal. }

  TDeviceInfo = Array[0..1023] Of PRDINFO3;
  PDeviceInfo = ^TDeviceInfo;
    { internal. }
  {$ENDIF}

  TPrinter = Class
  Private
  Public // temporary only
    {$IFDEF OS2}
    FQueues: PQueueInfo;       // Pointer To Queue Info Buffer
    {$ENDIF}
    FQueueCount: LongInt;      // Number Of queues available
    FQueueIndex: LongInt;      // Currently Selected Queue
    FQueueSize:  LongInt;      // Size Of Queue Info Buffer

    {$IFDEF OS2}
    FDevices: PDeviceInfo;     // Pointer To Device Info Buffer
    {$ENDIF}
    FDeviceCount: LongInt;     // Number Of Devices available
    FDeviceIndex: LongInt;     // Currently Selected Device
    FDeviceSize:  LongInt;     // Size Of Device Info Buffer

    FDeviceName: cstring[32];  // Name Of Currently Selected Device
    {$IFDEF OS2}
    FDeviceData: DEVOPENSTRUC; // Data Needed To Open Device contect
    {$ENDIF}

    FPrintToFile: Boolean;     // Print To File instead Of printer?
    FFileName: AnsiString;     // Name Of Output File

    FPrinters: TStrings;       // Printer Names Visible To End user

    FHandle: HDC;              // Printer Device context
    FCanvas: TCanvas;          // Printer Canvas

    FState: TPrinterState;     // Current State Of Printer Object

    FTitle: AnsiString;        // Document Title
    FCopies: LongInt;          // Number Of copies To be printed
    FAborted: Boolean;         // True when Last job was aborted
    FPageNumber: LongInt;      // Number Of Current page

    Procedure Error(Id: Word);
    Procedure FmtError(Id: Word; Args: Array Of Const);
    Function GetOrientation: TPrinterOrientation;
    Function GetPageHeight: LongInt;
    Function GetPageWidth: LongInt;
    Procedure GetPrinterInfo;
    Function GetPrinting: Boolean;
    Procedure SetFileName(Value: AnsiString);
    Procedure SetPrinterIndex(Value: LongInt);
    Procedure SetPrinterState(Value: TPrinterState);
    Procedure SetPrintToFile(Value: Boolean);

  Public
    Constructor Create;
      { Create Printer Object. one Printer Object
        Is automatically created And stored In the
        Printer variable. no need To Create more
        Printer Objects. }
    Destructor Destroy; Override;
      { Destroy Printer Object. the Instance stored
        In the Printer variable Is automatically
        destroyed In the unit's Finalization Code. }

    Procedure Abort;
      { Abort Current Document. only available inside
        Document. }
    Procedure BeginDoc;
      { Begin New Document. only available when Last
        job has either been completed Or aborted. }
    Procedure EndDoc;
      { End Document. only available inside Document. }
    Procedure NewPage;
      { Start A New, blank page. only available inside
        Document. }
    Procedure OptionsDlg;
      { display job properties Dialog For Currently
        Selected Printer. allow the user To Change
        job properties. only available While Not In
        Document. }
    procedure PrintBitmap(Bitmap: TBitmap; SrcRec, DstRec: TRect);
      { Prints a bitmap. SrcRec and DstRec specify
        the source and destination rectangles.

        You should always use this method to display
        bitmaps on the printer. Never use the blitting
        operations provided by the canvas or graphics
        objects, since they can't cooperate with a
        printer canvas. }
    procedure PrintForm(Form: TForm; DstRec: TRect);
      { Prints the contents of a form. DstRec
        specifies the destination rectangle on
        the page.

        Please note the following differences from
        form printing under Borland Delphi:

        (a) A print job must already be initiated.
        (b) Only the currently visible part of the
            the form can be printed. This is due to
            an OS/2 limitation. }
    Property Aborted: Boolean Read FAborted;
      { True If Last job has been aborted. }
    Property Canvas: TCanvas Read FCanvas;
      { Printer Canvas. only available inside
        Document. }
    Property Copies: LongInt Read FCopies Write FCopies;
      { Number Of copies To be printed Of Next
        Document. MUST be Set before BeginDoc,
        Otherwise ignored. }
    Property FileName: AnsiString Read FFileName Write SetFileName;
      { destination when printing To A File. }
    Property Handle: HDC Read FHandle;
      { Printer Device context. }
    Property Orientation: TPrinterOrientation Read GetOrientation;
      { page Orientation. }
    Property PageHeight: LongInt Read GetPageHeight;
      { page Height In Pixels. }
    Property PageNumber: LongInt Read FPageNumber;
      { Current page Number. }
    Property PageWidth: LongInt Read GetPageWidth;
      { page Width In Pixels. }
    Property PrinterIndex: LongInt Read FQueueIndex Write SetPrinterIndex;
      { Currently Selected Printer. Change only While Not
        In Document. Set PrinterIndex To -1 For System
        Default Printer. }
    Property Printers: TStrings Read FPrinters;
      { Names Of Printers (aka queues) available. If
        Printers.Count Is 0, the System doesn't have
        any Printers installed. }
    Property Printing: Boolean Read GetPrinting;
      { True when inside Document. }
    Property PrintToFile: Boolean Read FPrintToFile Write SetPrintToFile;
      { when True, Output Is sent To File specified
        In the FileName Property. }
    Property Title: AnsiString Read FTitle Write FTitle;
      { Title Of Next Document. MUST be Set before
        BeginDoc, Otherwise ignored. }
  End;

Var
  Printer: TPrinter;

Implementation

{$IFDEF OS2}
Uses
  PmWin, PmDev, PMSHL, PmGpi;
{$ENDIF}

{$IFDEF WIN32}
Uses WinDef,WinNT,WinBase,WinUser,WinGDI;
{$ENDIF}


{$ifdef os2}
{ --- OS/2 DevEscape Network printer fix in NETAPI.DLL (12 October 2004, M. Vieregg, A. Laurence) }
{for more information about this problem, visit:
"Stack requirements of API functions" in comp.os.os2.programmer.misc, Date:2003-06-16
 But the mentioned stack size of 512 bytes is not sufficient!
 1024 did not work with my application, 2048 did it, but 4096 is more secure.}

const
  NETAPIwants16bitStackMin = 4096;
FUNCTION DevEscape_extrastack(ahdc:HDC;lCode,lInCount:LONG;VAR pbInData;
                         VAR plOutCount:LONG;VAR pbOutData):LONG;
var
  Dummy2EatStack: array[0..NETAPIwants16bitStackMin] of char;
begin
  Dummy2EatStack[0] := #0;{omit compiler warning}
  result := DevEscape (ahdc,lCode,lInCount,pbInData,plOutCount,pbOutData);
end;

FUNCTION DevEscape_fixed(ahdc:HDC;lCode,lInCount:LONG;VAR pbInData;
                         VAR plOutCount:LONG;VAR pbOutData):LONG;
var
  Dummy: longword;
begin
  Dummy := 0;{omit compiler warning}
  if ( longword( Addr( dummy ) ) and $ffff ) < NETAPIwants16bitStackMin then
    result := DevEscape_extrastack (ahdc,lCode,lInCount,pbInData,plOutCount,pbOutData)
  else
    result := DevEscape (ahdc,lCode,lInCount,pbInData,plOutCount,pbOutData);
end;
{$endif}

const
  Null: long = 0;

{ --- For debugging purposes only --- }

Procedure DisplayPrinterInfo;
Var
  C: cstring;
  I: LongInt;
Begin
  {$IFDEF OS2}
  PrfQueryProfileString(HINI_PROFILE,
                        'PM_SPOOLER',
                        'QUEUE',
                        Nil,
                        C,
                        SizeOf(C));

  I := 0;
  While (C[I] <> #0) And (C[I] <> ';') Do Inc(I);
  C[I] := #0;

  WriteLn(Printer.FQueueCount, ' queues, ',
          Printer.FDeviceCount, ' devices, ',
          'default queue is ', C);

  For I := 0 To Printer.FQueueCount - 1 Do
  Begin
    WriteLn('--- Queue #', I, ': ---');
    With Printer.FQueues^[I] Do
    Begin
      WriteLn('pszName:        ', pszName);
      WriteLn('pszPrinters:    ', pszPrinters);
      WriteLn('pszDriverName:  ', pszDriverName);
    End;
  End;

  For I := 0 To Printer.FDeviceCount - 1 Do
  Begin
    WriteLn('--- Device #', I, ': ---');
    With Printer.FDevices^[I] Do
    Begin
      WriteLn('pszPrinterName: ', pszPrinterName);
      WriteLn('pszLogAddr      ', pszLogAddr);
      WriteLn('pszDrivers:     ', pszDrivers);
    End;
  End;
  {$ENDIF}
End;

{ --- TPrinter --- }

Constructor TPrinter.Create;
Begin
  Inherited Create;
  FPrinters := TStringList.Create;
  FCanvas := TCanvas.Create(Nil);
  FCanvas.NonDisplayDevice:=True;
  FPrintToFile := false;
  FFileName := 'print.txt';
  Try
    GetPrinterInfo;
    If Printers.Count <> 0 Then SetPrinterIndex(-1);
  Except
    ON E: EPrinter Do
      ErrorBox2(LoadNLSStr(SPrinterInit1)
              + #13#13
              + E.Message
              + #13#13
              + LoadNLSStr(SPrinterInit2));
  End;
End;

Destructor TPrinter.Destroy;
Begin
  SetPrinterState(psNoHandle);
  {$IFDEF OS2}
  If FQueueSize <> 0 Then FreeMem(FQueues, FQueueSize);
  If FDeviceSize <> 0 Then FreeMem(FDevices, FDeviceSize);
  {$ENDIF}

  FPrinters.Free;
  FCanvas.Free;
  Inherited Destroy;
End;

Procedure TPrinter.Abort;
Begin
  If Not printing Then FmtError(SPrinterIdle, ['Abort']);

  {$IFDEF OS2}
  DevEscape_fixed(FHandle,
                  DEVESC_ABORTDOC,
                  0,
                  Null,
                  Null,
                  Null);
  {$ENDIF}
  {$IFDEF WIN32}
  WinGDI.AbortDocAPI(FHandle);
  {$ENDIF}

  SetPrinterState(psNoHandle);
  FAborted := True;
End;

Procedure TPrinter.BeginDoc;
{$IFDEF WIN32}
Var DI:DOCINFO;
{$ENDIF}
var
  DefFnt: TFont;
Begin
  If printing Then FmtError(SPrinterBusy, ['BeginDoc']);

  SetPrinterState(psHandleDC);

  {$IFDEF OS2}
  DevEscape_fixed(FHandle,
                  DEVESC_STARTDOC,
                  Length(FTitle) + 1,
                  PChar(FTitle)^,
                  Null,
                  Null);
  {$ENDIF}
  {$IFDEF WIN32}
  DI.cbSize:=SizeOf(DOCINFO);
  DI.lpszDocName:=PChar(FTitle);
  DI.lpszOutput:=Nil;
  DI.lpszDatatype:=Nil;
  DI.fwType:=0;
  StartDocAPI(FHandle,DI);
  {$ENDIF}

  with FCanvas do
  begin
    {$IFDEF OS2}
    GpiCreateLogColorTable(Handle, LCOL_RESET, LCOLF_RGB, 0, 0, nil);
    {$ENDIF}

    with Pen do
    begin
      Color := clBlack;
      Mode  := pmCopy;
      Style := psSolid;
    end;

    with Brush do
    begin
      Color := clWhite;
      Mode  := bmOpaque;
      Style := bsSolid;
    end;

    DefFnt := Screen.GetFontFromPointSize('Courier New', 10);

    if DefFnt = nil then
      DefFnt := Screen.GetFontFromPointSize('Courier', 10);

    Font := DefFnt;
  end;

  FAborted := False;
  FPageNumber := 1;
End;

Procedure TPrinter.EndDoc;
Begin
  If Not printing Then FmtError(SPrinterIdle, ['EndDoc']);

  try
    NewPage;
  except
    // swallow exception if it occurs to allow tidyup
  end;

  {$IFDEF OS2}
  DevEscape_fixed(FHandle,  
                  DEVESC_ENDDOC,
                  0,
                  Null,
                  Null,
                  Null);
  {$ENDIF}
  {$IFDEF WIN32}
  WinGDI.EndDocAPI(FHandle);
  {$ENDIF}

  SetPrinterState(psHandleIC);
End;

Procedure TPrinter.Error;
Begin
  Raise EPrinter.Create(LoadNLSStr(Id));
End;

Procedure TPrinter.FmtError;
Begin
  Raise EPrinter.Create(FmtLoadNLSStr(Id, Args));
End;

Function TPrinter.GetOrientation;
Begin
  If PageHeight >= PageWidth Then Result := poPortrait
  Else Result := poLandscape;
End;

Function TPrinter.GetPageHeight;
Begin
  {$IFDEF OS2}
  DevQueryCaps(FHandle, CAPS_HEIGHT, 1, Result);
  {$ENDIF}
  {$IFDEF WIN32}
  Result := GetDeviceCaps(FHandle, VertRes);
  {$ENDIF}
End;

Function TPrinter.GetPageWidth;
Begin
  {$IFDEF OS2}
  DevQueryCaps(FHandle, CAPS_WIDTH, 1, Result);
  {$ENDIF}
  {$IFDEF WIN32}
  Result := GetDeviceCaps(FHandle, HorzRes);
  {$ENDIF}
End;

Procedure TPrinter.GetPrinterInfo;
{$IFDEF OS2}
Var
  dummy, I, J, QueueTotal, DeviceTotal: LongInt;
  S: String;
{$ENDIF}
Begin
  {$IFDEF OS2}
  SplEnumQueue('',
               3,
               dummy,
               0,
               LongWord(FQueueCount),
               LongWord(QueueTotal),
               LongWord(FQueueSize),
               Nil);

  GetMem(FQueues, FQueueSize);

  SplEnumQueue('',
               3,
               FQueues^,
               FQueueSize,
               LongWord(FQueueCount),
               LongWord(QueueTotal),
               LongWord(FQueueSize),
               Nil);

  SplEnumDevice('',
                3,
                dummy,
                0,
                LongWord(FDeviceCount),
                LongWord(DeviceTotal),
                LongWord(FDeviceSize),
                Nil);

  GetMem(FDevices, FDeviceSize);

  SplEnumDevice('',
                3,
                FDevices^,
                FDeviceSize,
                LongWord(FDeviceCount),
                LongWord(DeviceTotal),
                LongWord(FDeviceSize),
                Nil);

  For I := 0 To FQueueCount - 1 Do
  Begin
    S := FQueues^[I].pszComment^;
    J := 1;
    While J <= Length(S) Do
    Begin
      Case S[J] Of
        #10: Delete(S, J, 1);
        #13: S[J] := ' ';
      End;
      Inc(J);
    End;
    FPrinters.Add(S);
  End;
  {$ENDIF}
End;

Function TPrinter.GetPrinting;
Begin
  Result := (FState = psHandleDC);
End;

Procedure TPrinter.NewPage;
var
  rc: LONG;
Begin
  If Not printing Then FmtError(SPrinterIdle, ['NewPage']);

  {$IFDEF OS2}
  rc := DevEscape_fixed( FHandle,
                         DEVESC_NEWFRAME,
                         0,
                         Null,
                         Null,
                         Null );
  if rc <> DEV_OK then
    raise EPrinter.Create( 'Error doing New Page: '
                           + IntToStr( rc )
                           + ' WinGetLastError: '
                           + IntToHex( WinGetLastError( AppHandle ), 8 ) );
  {$ENDIF}
  {$IFDEF WIN32}
  StartPage(FHandle);
  {$ENDIF}

  Inc(FPageNumber);
End;

Procedure TPrinter.OptionsDlg;
Var
  I: LongInt;
Begin
  If printing Then FmtError(SPrinterBusy, ['OptionsDlg']);

  {$IFDEF OS2}
  With FDeviceData Do
  Begin
    I := DevPostDeviceModes(AppHandle,
                            Nil,
                            pszDriverName^,
                            pDriv^.szDeviceName,
                            Nil,
                            DPDM_POSTJOBPROP);

    If I > pDriv^.cb Then FmtError(SJobProperties, [I, pDriv^.cb]);

    DevPostDeviceModes(AppHandle,
                       pDriv^,
                       pszDriverName^,
                       pDriv^.szDeviceName,
                       Nil,
                       DPDM_POSTJOBPROP);
  End;
  {$ENDIF}
  SetPrinterState(FState);
End;

procedure TPrinter.PrintBitmap;
{$IFDEF OS2}
var
  DC: HDC;
  PS: HPS;
  BM: HBITMAP;
  Size: SIZEL;
  Points: array[0..1] of TRect;
{$ENDIF}
begin
  {$IFDEF OS2}
  If not Printing Then FmtError(SPrinterIdle, ['PrintBitmap']);

  if Bitmap = nil then Exit;

  DC := 0;
  PS := 0;

  try
    DC := DevOpenDC(AppHandle, OD_MEMORY, '*', 0,
                    nil, Handle);

    Size.CX := 0;
    Size.CY := 0;

    PS := GpiCreatePS(AppHandle, DC, Size,
                      PU_PELS or GPIT_MICRO or GPIA_ASSOC);

    BM := Bitmap.Handle;
    try
      GpiSetBitmap(Bitmap.Canvas.Handle, 0);
      GpiSetBitmap(PS, BM);

      Points[0] := DstRec;
      Points[1] := SrcRec;

      GpiBitBlt(Canvas.Handle,
                PS,
                4,
                Points[0].LeftBottom,
                ROP_SRCCOPY,
                BBO_IGNORE);

    finally
      GpiSetBitmap(PS, 0);
      GpiSetBitmap(Bitmap.Canvas.Handle, BM);
    end;

  finally
    if PS <> 0 then GpiDestroyPS(PS);
    if DC <> 0 then DevCloseDC(DC);
  end;
  {$ENDIF}
end;

procedure TPrinter.PrintForm;
var
  Image: TBitmap;
begin
  If not Printing Then FmtError(SPrinterIdle, ['PrintForm']);

  Image := TBitmap(Form.GetFormImage);
  try
    PrintBitmap(Image,
                Forms.Rect(0, 0, Image.Width, Image.Height),
                DstRec);
  finally
    Image.Free;
  end;
end;

Procedure TPrinter.SetPrinterIndex;
{$IFDEF OS2}
Var
  C: cstring;
  P: PChar;
  I: LongInt;
{$ENDIF}
Begin
  If printing Then FmtError(SPrinterBusy, ['SetPrinterIndex']);

  {$IFDEF OS2}
  If Value = -1 Then
  Begin
    // Query Default Queue Name
    PrfQueryProfileString(HINI_PROFILE,
                          'PM_SPOOLER',
                          'QUEUE',
                          Nil,
                          C,
                          SizeOf(C));

    // Remove useless semicolon At End
    I := 0;
    While (C[I] <> #0) And (C[I] <> ';') Do
      Inc(I);
    C[I] := #0;

    // Find Index Of Default Queue
    I := 0;
    While (I < FQueueCount) And (C <> FQueues^[I].pszName^) Do
      Inc(I);

    If I < FQueueCount Then Value := I Else Value := 0;
  End;

  // Change Current Queue If Value Is legal
  If (Value < 0) Or (Value >= FQueueCount) Then FmtError(SInvalidIndex, [Value, Printers.Count]);
  FQueueIndex := Value;

  // Get Printer Name Of Selected Queue, Find matching Device
  P := FQueues^[FQueueIndex].pszPrinters;

  I := 0;
  While (I < FDeviceCount) And (P^ <> FDevices^[I].pszPrinterName^) Do
    Inc(I);

  If I = FDeviceCount Then FmtError(SDeviceNotFound, [P]);

  FDeviceIndex := I;

  // Set Device Name
  C := FQueues^[FQueueIndex].pszDriverName^;
  I := 0;
  While (C[I] <> #0) And (C[I] <> '.') Do Inc(I);
  C[I] := #0;
  FDeviceName := C;

  // Fill Device Open structure
  With FDeviceData Do
  Begin
    If FPrintToFile Then pszLogAddress := PChar(FileName)
    Else pszLogAddress := FQueues^[FQueueIndex].pszName;

    pszDriverName := @FDeviceName;
    pszDataType := 'PM_Q_STD';
    pDriv := FQueues^[FQueueIndex].pDriverData;
  End;
  {$ENDIF}

  // Get Info context
  SetPrinterState(psHandleIC);
End;

Procedure TPrinter.SetPrinterState;
{$IFDEF OS2}
Var
  C: cstring[16];
  S: SIZEL;
  D, E: LongInt;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If FCanvas.Handle <> 0 Then
  Begin
    GpiDestroyPS(FCanvas.Handle);
    FCanvas.Handle := 0;
  End;

  If FHandle <> 0 Then
  Begin
    DevCloseDC(FHandle);
    FHandle := 0;
  End;

  If FCopies > 1 Then
  Begin
    C := 'COP=' + tostr(FCopies);
    FDeviceData.pszQueueProcParams := @C;
  End;

  Case Value Of
    psHandleIC:
    Begin
      FHandle := DevOpenDC(AppHandle,
                           OD_INFO,
                           '*',
                           4,
                           FDeviceData,
                           0);

      If FHandle = 0 Then
      Begin
        E := WinGetLastError(AppHandle);
        FmtError(SNoHandleIC, [E]);
      End;
    End;

    psHandleDC:
    Begin
      If FPrintToFile Then D := OD_DIRECT Else D := OD_QUEUED;

      FHandle := DevOpenDC(AppHandle,
                           D,
                           '*',
                           9,
                           FDeviceData,
                           0);

      If FHandle = 0 Then
      Begin
        E := WinGetLastError(AppHandle);
        FmtError(SNoHandleDC, [E]);
      End;

      S.CX := 0;
      S.CY := 0;

      FCanvas.Handle := GpiCreatePS(AppHandle,
                                    FHandle,
                                    S,
                                    //PU_ARBITRARY Or GPIF_DEFAULT Or GPIT_MICRO Or GPIA_ASSOC
                                    PU_PELS or GPIT_MICRO or GPIA_ASSOC
                                   );

      If FCanvas.Handle = 0 Then
      Begin
        E := WinGetLastError(AppHandle);
        DevCloseDC(FHandle);
        FHandle := 0;
        FmtError(SNoHandlePS, [E]);
      End;
    End;
  End;
  {$ENDIF}

  FState := Value;
End;

Procedure TPrinter.SetPrintToFile;
Begin
  FPrintToFile := Value;
  {$IFDEF OS2}
  With FDeviceData Do
  Begin
    If FPrintToFile Then pszLogAddress := PChar(FileName)
    Else pszLogAddress := FDevices^[FDeviceIndex].pszLogAddr;
  End;
  {$ENDIF}
End;

Procedure TPrinter.SetFileName;
Begin
  FFileName := Value;
  SetPrintToFile(FPrintToFile);
End;

Initialization
  Try //just To Make sure <G>
    Printer := TPrinter.Create; { cannot Fail anymore }
  Except
    Printer:=Nil;
  End;

Finalization
  Printer.Free;

End.

{ -- date -- - changes ------------------------------------------

  22-Dec-97   Initial Release.
  28-Jan-97   printing To File didn't work when FileName was
              specified With PrintToFile already being True.
  08-Feb-97   Device Name now 32 characters. Problems With
              systems where several Printer Objects Use the same
              Device. results In 'No queue for device'. don't
              know how To fix This.
  27-Feb-97   removed Some debugging stuff.
  05-Mar-97   FIXED bug that resulted In 'No queue for device'.
              moved Error Messages To Resource Id 65300.
  13-Mar-97   Some changes by Rene Nrnberger
  04-Apr-97   GetPrinterInfo now replaces #13#10 by A space
              If the Printer Name Is Multi-Line.
  15-Apr-97   additional diagnostic information when DevOpenDC
              Or GpiCreatePS Fail. New Error Handling For
              startup sequence. Existence Of Printer Instance
              guaranteed.
  16-Apr-97   Rene: Saved Initialization part With Try..Except.
              This Is only For safety If For Instance A GPF
              occurs within the Constructor.
  05-Aug-97   J”rg: Fixed bug reported by Alex Vermeulen.
              Printer had no palette, which resulted in
              empty pages when trying to use RGB colors.
              Some other initialization also done on
              every BeginDoc: Pen, Brush and Font set to
              default values.
  06-Aug-97   J”rg: Default printer font is now either
              "Courier New" or "Courier", depending on
              which one is available. Changes to BeginDoc
              and SetPrinterState.
  16-Aug-97   J”rg: Added methods PrintBitmap and PrintForm.

  --------------------------------------------------------------- }
