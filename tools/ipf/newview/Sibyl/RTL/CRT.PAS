UNIT CRT;

{***************************************************************************
 *  Speed-Pascal/2 V 2.0                                                   *
 *                                                                         *
 *  CRT Standard Unit                                                      *
 *                                                                         *
 *  (C) 1995 SpeedSoft. All rights reserved.                               *
 *                                                                         *
 *  Note: Some constants/variables moved to SYSTEM                         *
 *                                                                         *
 ***************************************************************************}

INTERFACE

CONST
  {Foreground and background color constants}
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

  {Foreground color constants}
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

  {Add-in for blinking}
  Blink         = 128;

VAR
  CheckBreak: BOOLEAN;          { Ctrl-Break check }
  CheckEOF: BOOLEAN;            { Ctrl-Z for EOF?  }
  NormAttr:WORD;                { Normal text attribute}

PROCEDURE ClrScr;
PROCEDURE GotoXY(X,Y:BYTE);
PROCEDURE Window(X1,Y1,X2,Y2:BYTE);
PROCEDURE TextColor(Color:BYTE);
PROCEDURE TextBackground(Color:BYTE);
FUNCTION WhereX: Byte;
FUNCTION WhereY: WORD;
PROCEDURE ClrEol;
PROCEDURE InsLine;
PROCEDURE DelLine;
PROCEDURE LowVideo;
PROCEDURE NormVideo;
PROCEDURE HighVideo;
FUNCTION KeyPressed: BOOLEAN;
FUNCTION ReadKey: CHAR;
PROCEDURE TextMode(Mode: Integer);
PROCEDURE Delay(ms:LONGWORD);
{Sound/NoSound are not implemented, they are replaced by beep in SYSTEM}

IMPLEMENTATION

{$IFDEF OS2}
USES PmWin;
{$ENDIF}

{$IFDEF Win95}
USES WinCon,WinBase,WinUser;
{$ENDIF}

PROCEDURE CrtError;
VAR
   cs:CSTRING;
   cTitle:CSTRING;
BEGIN
     ctitle:='Wrong linker target';
     cs:='PM Linker mode does not support text screen IO.'+#13+
         'Use the unit WinCrt if you wish to use text'+#13+
         'screen IO inside PM applications.';
     {$IFDEF OS2}
     WinMessageBox(1,1,cs,ctitle,0,$4000 OR $0010);
     {$ENDIF}
     {$IFDEF Win95}
     MessageBox(0,cs,ctitle,0);
     {$ENDIF}
     Halt(0);
END;


{$IFDEF OS2}
{Internal structures from BSESUB}
TYPE
    VIOMODEINFO=RECORD {pack 1}
                     cb:WORD;
                     fbType:BYTE;
                     color:BYTE;
                     col:WORD;
                     row:WORD;
                     hres:WORD;
                     vres:WORD;
                     fmt_ID:BYTE;
                     attrib:BYTE;
                     buf_addr:LONGWORD;
                     buf_length:LONGWORD;
                     full_length:LONGWORD;
                     partial_length:LONGWORD;
                     ext_data_addr:POINTER;
                END;

    VIOCONFIGINFO=RECORD {pack 2}
                      cb:WORD;
                      adapter:WORD;
                      display:WORD;
                      cbMemory:LONGWORD;
                      Configuration:WORD;
                      VDHVersion:WORD;
                      Flags:WORD;
                      HWBufferSize:LONGWORD;
                      FullSaveSize:LONGWORD;
                      PartSaveSize:LONGWORD;
                      EMAdaptersOFF:WORD;
                      EMDisplaysOFF:WORD;
                 END;
{$ENDIF}

{Define a text window}
PROCEDURE Window(X1,Y1,X2,Y2: BYTE);
VAR MWindMax:WORD;
begin
  ASM
     MOV AX,SYSTEM.MaxWindMax
     MOV MWindMax,AX
  END;
  IF X1<=X2 THEN IF Y1<=Y2 THEN
  BEGIN
      Dec(X1);
      Dec(Y1);
      IF X1>=0 THEN IF Y1>=0 THEN
      BEGIN
           Dec(Y2);
           Dec(X2);
           IF X2<lo(MWindMax)+1 THEN IF Y2<Hi(MWindMax)+1 THEN
           BEGIN
               WindMin := X1 + WORD(Y1) SHL 8;
               WindMax := X2 + WORD(Y2) SHL 8;
               GotoXY(1,1);
           END;
      END;
  END;
END;

{Set cursor location}
PROCEDURE GotoXY(X,Y: BYTE);
BEGIN
     ScreenInOut.GotoXY(X,Y);
END;

{internal ANSI color set routine}
PROCEDURE SetColors;
VAR ColorString:STRING;
    Tmp:BYTE;
    Actual:LONGWORD;
    Handle:LONGWORD;
    ff:^FileRec;
    redirected:BOOLEAN;
BEGIN
     ASM
        MOV AL,SYSTEM.Redirect
        MOV redirected,AL
     END;

     IF Redirected THEN exit;

     ff:=@Output;
     Handle:=ff^.Handle;

     Colorstring:=#27+'[0';    {Reset colors and attributes to black/white}
     IF TextAttr>127 THEN      {IF bit 7 set (blink}
         Colorstring:=ColorString+';5'; {blink}

     {Set background colors}
     Tmp:=TextAttr AND 112 ;   {Clear bits 7,0 to 3 }
     Tmp:=Tmp SHR 4;           {Adjust position to reflect bgcolor}
     Tmp:=Tmp AND 7;
     CASE Tmp OF
        Black    : Tmp:=40;       {Values differ from CLR_ constants!}
        Blue     : Tmp:=44;
        Green    : Tmp:=42;
        Cyan     : Tmp:=46;
        Red      : Tmp:=41;
        Magenta  : Tmp:=45;
        Brown    : Tmp:=43;       {Yellow with in lower set!}
        Lightgray: Tmp:=47;
     END;
     Colorstring:=Colorstring+';'+tostr(Tmp);

     {Now set forefround...}
     Tmp:=TextAttr AND 15 ;    {Clear bits 4 to 7 }
     IF Tmp>7 THEN             {Is bold character}
     BEGIN
          Colorstring:=Colorstring+';1';  {High colors}
          DEC(Tmp,8);
     END;

     Tmp:=Tmp AND 7;
     CASE Tmp OF
         Black    : Tmp:=30;
         Blue     : Tmp:=34;
         Green    : Tmp:=32;
         Cyan     : Tmp:=36;
         Red      : Tmp:=31;
         Magenta  : Tmp:=35;
         Brown    : Tmp:=33; {yellow with in lower set!}
         Lightgray: Tmp:=37;
     END;

     Colorstring:=Colorstring+';'+tostr(Tmp)+'m';

     {$IFDEF OS2}
     ASM
        LEA EAX,Actual
        PUSH EAX                //pcbActual
        LEA EDI,ColorString
        MOVZXB EAX,[EDI]
        PUSH EAX               //cbWrite
        INC EDI
        PUSH EDI               //pBuffer
        PUSH DWORD PTR Handle  //FileHandle
        MOV AL,4
        CALLDLL DosCalls,282   //DosWrite
        ADD ESP,16
     END;
     {$ENDIF}
     {$IFDEF Win95}
     WriteFile(ff^.Handle,ColorString[1],length(ColorString),actual,NIL);
     {$ENDIF}
END;

{Set foreground color}
PROCEDURE TextColor(Color:BYTE);
BEGIN
  IF ApplicationType=1 THEN CrtError;

  IF Color > White THEN Color := (Color AND 15) OR 128; {Blink}
  TextAttr := (TextAttr AND 112) OR Color;
  SetColors;
END;

{Set background color}
PROCEDURE TextBackground(Color:BYTE);
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := (TextAttr AND $8F) OR ((Color AND $07) SHL 4);
  SetColors;
END;

{Clear screen or window}
PROCEDURE ClrScr;
VAR
  Fill: Word;
  {$IFDEF Win95}
  ff:^FileRec;
  co:COORD;
  Actual:LONGWORD;
  {$ENDIF}
BEGIN
  IF ApplicationType=1 THEN CrtError;
  {$IFDEF OS2}
  Fill:= 32 + WORD(TextAttr) SHL 8;
  VioScrollUpProc(Hi(WindMin),Lo(WindMin),
                  Hi(WindMax),Lo(WindMax),
                  Hi(WindMax)-Hi(WindMin)+1,Fill,0);
  {$ENDIF}
  {$IFDEF Win95}
  Fill:= TextAttr;
  ff:=@Output;
  co.x:=Lo(WindMin);
  co.y:=Hi(WindMin);
  FillConsoleOutputAttribute(ff^.Handle,Fill,
                             (Hi(WindMax)-Hi(WindMin))*(Lo(WindMax)-Lo(WindMin)),
                             LONGWORD(co),Actual);
  FillConsoleOutputCharacter(ff^.Handle,' ',
                             (Hi(WindMax)-Hi(WindMin))*(Lo(WindMax)-Lo(WindMin)),
                             LONGWORD(co),Actual);
  {$ENDIF}
  GotoXY(1,1);
END;

{returns current cursor X position}
FUNCTION WhereX: Byte;
{$IFDEF Win95}
VAR csbi:CONSOLE_SCREEN_BUFFER_INFO;
    ff:^FileRec;
{$ENDIF}
BEGIN
  IF ApplicationType=1 THEN CrtError;
  {$IFDEF OS2}
  WhereX := VioWhereXProc - Lo(WindMin);
  {$ENDIF}
  {$IFDEF Win95}
  ff:=@Output;
  GetConsoleScreenBufferInfo(ff^.Handle,csbi);
  WhereX:=csbi.dwCursorPosition.X+1-Lo(WindMin);
  {$ENDIF}
END;

{returns current cursor Y position}
FUNCTION WhereY: WORD;
{$IFDEF Win95}
VAR csbi:CONSOLE_SCREEN_BUFFER_INFO;
    ff:^FileRec;
{$ENDIF}
BEGIN
  IF ApplicationType=1 THEN CrtError;
  {$IFDEF OS2}
  WhereY:= VioWhereYProc - Hi(WindMin);
  {$ENDIF}
  {$IFDEF Win95}
  ff:=@Output;
  GetConsoleScreenBufferInfo(ff^.Handle,csbi);
  WhereY:=csbi.dwCursorPosition.Y+1-Hi(WindMin);
  {$ENDIF}
END;

{Deletes til end of line}
PROCEDURE ClrEol;
VAR
  Value:WORD;
  Y: BYTE;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  Value := Ord(' ') + WORD(TextAttr) SHL 8;
  {$IFDEF OS2}
  Y:=VioWhereYProc-1;
  VioScrollUpProc(Y,VioWhereXProc-1,Y,Lo(WindMax),1,Value,0);
  {$ENDIF}
END;

{Insert empty line}
PROCEDURE InsLine;
VAR
   value:WORD;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  value := Ord(' ') + WORD(TextAttr) SHL 8;
  {$IFDEF OS2}
  VioScrollDnProc(VioWhereYProc-1,Lo(WindMin),Hi(WindMax),Lo(WindMax),1,Value,0);
  {$ENDIF}
END;

{Delete the current line}
PROCEDURE DelLine;
VAR
   value:WORD;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  Value := Ord(' ') + WORD(TextAttr) SHL 8;
  {$IFDEF OS2}
  VioScrollUpProc(VioWhereYProc-1,Lo(WindMin),Hi(WindMax),Lo(WindMax),1,Value,0);
  {$ENDIF}
END;

{sets low intensity}
PROCEDURE LowVideo;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := TextAttr AND $F7;
  SetColors;
END;

{sets normal intensity}
PROCEDURE NormVideo;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := NormAttr;
  SetColors;
END;

{sets high intensity}
PROCEDURE HighVideo;
BEGIN
  IF ApplicationType=1 THEN CrtError;
  TextAttr := TextAttr OR $08;
  SetColors;
END;


PROCEDURE InitCrt;
VAR Size:WORD;
    Value:WORD;
    {$IFDEF Win95}
    co:COORD;
    ff:^FileRec;
    Actual:LONGWORD;
    {$ENDIF}
BEGIN
     Size := 2;
     {$IFDEF OS2}
     VioReadCellStrProc(Value, Size, WhereY-1, WhereX-1, 0);
     {$ENDIF}
     {$IFDEF Win95}
     co.X:=1;
     co.Y:=1;
     ff:=@Output;
     ReadConsoleOutputAttribute(ff^.Handle,Value,2,LONGWORD(co),Actual);
     {$ENDIF}
     NormAttr := Hi(Value) AND $7F;
     TextAttr:=NormAttr;
     {NormVideo;}
     CheckBreak:=TRUE;
     CheckEOF:=TRUE;
END;

{checks if a key was pressed}
FUNCTION KeyPressed: BOOLEAN;
{$IFDEF Win95}
VAR ff:^FileRec;
    ir:INPUT_RECORD;
    Actual:LONGWORD;
{$ENDIF}
BEGIN
     IF ApplicationType=1 THEN CrtError;
     {$IFDEF OS2}
     KeyPressed:=KeyPressedProc;
     {$ENDIF}
     {$IFDEF Win95}
     ff:=@Input;

     SetConsoleMode(ff^.Handle,ENABLE_WINDOW_INPUT);

     result:=FALSE;
     PeekConsoleInput(ff^.Handle,ir,1,Actual);
     IF ir.EventType=KEY_EVENT THEN
        IF ir.Event.KeyEvent.bKeyDown THEN result:=TRUE;

     SetConsoleMode(ff^.Handle,ENABLE_PROCESSED_INPUT OR ENABLE_LINE_INPUT OR
       ENABLE_ECHO_INPUT OR ENABLE_WINDOW_INPUT OR ENABLE_MOUSE_INPUT OR
       ENABLE_PROCESSED_OUTPUT OR ENABLE_WRAP_AT_EOL_OUTPUT);
     {$ENDIF}
END;

{Reads a character}
FUNCTION ReadKey: CHAR;
{$IFDEF Win95}
VAR ff:^FileRec;
    ir:INPUT_RECORD;
    Actual:LONGWORD;
LABEL l;
{$ENDIF}
BEGIN
     IF ApplicationType=1 THEN CrtError;
     {$IFDEF OS2}
     ReadKey:=ReadKeyProc;
     {$ENDIF}
     {$IFDEF Win95}
     ff:=@Input;

     SetConsoleMode(ff^.Handle,ENABLE_WINDOW_INPUT);

     REPEAT
           ReadConsoleInput(ff^.Handle,ir,1,Actual);
           IF ir.EventType=KEY_EVENT THEN
             IF ir.Event.KeyEvent.bKeyDown THEN goto l;
     UNTIL FALSE;
l:
     ReadKey:=ir.Event.KeyEvent.uChar.AsciiChar;
     SetConsoleMode(ff^.Handle,ENABLE_PROCESSED_INPUT OR ENABLE_LINE_INPUT OR
       ENABLE_ECHO_INPUT OR ENABLE_WINDOW_INPUT OR ENABLE_MOUSE_INPUT OR
       ENABLE_PROCESSED_OUTPUT OR ENABLE_WRAP_AT_EOL_OUTPUT);
     {$ENDIF}
END;

{ Set a text mode. (BW40,CO40,BW80,CO80,Mono,Font8x8}
PROCEDURE TextMode(Mode: Integer);
VAR
   Bios: BYTE;
   Value: Word;
   {$IFDEF OS2}
   VioMode:VIOMODEINFO;
   VioConfig:VIOCONFIGINFO;
   {$ENDIF}
BEGIN
  IF ApplicationType=1 THEN CrtError;
  {$IFDEF OS2}
  {Get current video mode}
  VioMode.cb := SizeOf(VioModeInfo);
  VioGetModeProc(VioMode, 0);

  {update LastMode}
  WITH VioMode DO
  BEGIN
       IF Col = 40 THEN LastMode := BW40
       ELSE LastMode := BW80;
       IF (fbType AND 4) = 0 THEN
          IF LastMode = BW40 THEN LastMode := CO40
       ELSE LastMode := CO80;
       IF Color = 0 THEN LastMode := Mono;
       IF Row > 25 THEN Inc(LastMode,Font8x8);
  END;

  TextAttr := LightGray;
  Bios := Lo(Mode);
  VioConfig.cb := SizeOf(VioConfigInfo);

  {Get adapter info}
  VioGetConfigProc(0, VioConfig, 0);

  WITH VioMode DO
  BEGIN
      VRes := 400;
      HRes := 720;
      cb := SizeOf(VioModeInfo);
      Row := 25;
      Col := 80;
      fbType := 1;
      Color := 4;      { 16 Colors }

      IF ((Bios=BW40)OR(Bios=CO40)) THEN
      BEGIN
           Col := 40;
           HRes := 360;
      END;
  END;

  IF (Mode AND Font8x8) <> 0 THEN
  BEGIN
       IF VioConfig.Adapter<3 THEN {Mono, CGA, EGA}
       BEGIN
            VioMode.VRes := 350;
            VioMode.HRes := 640;
            VioMode.Row := 43;
       END
       ELSE
       BEGIN
            VioMode.VRes := 400;
            VioMode.HRes := 720;
            VioMode.Row := 50;
       END;
  END;

  CASE Bios of
      BW40,BW80: VioMode.fbType := 5;
      MONO:
      BEGIN
           VioMode.HRes := 720;
           VioMode.VRes := 350;
           VioMode.Color := 0;
           VioMode.fbType := 0;  {no colors}
      END;
  END; {case}

  {try to set mode}
  VioSetModeProc(VioMode, 0);
  {See what mode is set}
  VioGetModeProc(VioMode, 0);
  NormVideo;

  {Set window dimensions}
  WindMin := 0;
  WindMax := VioMode.Col - 1 + (VioMode.Row - 1) SHL 8;

  {Clear screen}
  Value := 32 + WORD(TextAttr) SHL 8;    { Clear screen }
  VioScrollUpProc(0,0,65535,65535,65535,Value,0);
  {$ENDIF}
END;

PROCEDURE Delay(ms:LONGWORD);
BEGIN
     {$IFDEF OS2}
     IF ApplicationType<>1 THEN
     ASM
        PUSH DWORD PTR ms
        MOV AL,1
        CALLDLL DosCalls,229  //DosSleep
        ADD ESP,4
     END;
     {$ENDIF}
     {$IFDEF Win95}
     ASM
        PUSH DWORD PTR ms
        CALLDLL Kernel32,'Sleep'
     END;
     {$ENDIF}
END;

BEGIN
     IF ApplicationType<>1 THEN InitCrt;
END.
