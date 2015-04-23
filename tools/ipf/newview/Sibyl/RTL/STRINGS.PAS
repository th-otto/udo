{**************************************************************************
 *                 General Unit for Speed-Pascal/2                        *
 *                                                                        *
 *                                                                        *
 * Copyright (C) 1995..96 SpeedSoft                                       *
 * Partial Copyright (C) 1995 Uwe Chalas (Thanks a lot !)                 *
 *                                                                        *
 * All REP MOVSB changed to 32 Bit                                        *
 *                                                                        *
 **************************************************************************}


UNIT Strings;


INTERFACE

USES Os2Def;

FUNCTION StrNew(Str: PChar): PChar;
PROCEDURE StrDispose(Str: PChar);
FUNCTION StrEnd(Str:PChar):PChar;
FUNCTION StrMove(Dest, Source: PChar; Count: ULONG): PChar;
FUNCTION StrCat(Dest,Source:PChar):PChar;
FUNCTION StrCopy(Dest,Source:PChar):PChar;
FUNCTION StrECopy(Dest,Source:PChar):PChar;
FUNCTION StrLCopy(Dest,Source:PChar;Len:LONGINT):PChar;
FUNCTION StrLen(pszStr:PChar):ULONG;
FUNCTION StrPos(MainStr,SubStr:PChar):Pchar;
FUNCTION StrPosN(MainStr,SubStr:PChar):LONGINT;
FUNCTION StrScan(Str:PChar; Chr : Char):PChar;
FUNCTION StrScanN(Str:PChar; Chr : Char):LONGINT;
FUNCTION StrRScan(Str:PChar; Chr : Char):PChar;
FUNCTION StrRScanN(Str:PChar; Chr : Char):LONGINT;
FUNCTION StrUpper(Str:PChar):PChar;
FUNCTION StrLower(Str:PChar):PChar;
FUNCTION StrPCopy(Dest: PChar;CONST Source: String): PChar;
FUNCTION StrPas(Str:PChar):String;
FUNCTION StrComp(Str1,Str2:PChar):Integer;
FUNCTION StriComp(Str1,Str2:PChar):Integer;
FUNCTION StrLComp(Str1, Str2: PChar; MaxLen: LongWord): Integer;
FUNCTION StrLIComp(Str1,Str2:PChar;MaxLen:LONGWORD):Integer;

IMPLEMENTATION

IMPORTS
FUNCTION WinUpper(ahab:HAB;idcp,idcc:LONGWORD;apsz:PSZ):LONGWORD;
                    APIENTRY;             'PMWIN' index 893;
FUNCTION WinCompareStrings(ahab:HAB;idcp,idcc:LONGWORD;psz1,psz2:PSZ;
                           reserved:LONGWORD):LONGWORD;
                    APIENTRY;             'PMWIN' index 708;
END;

CONST
     WCS_ERROR                  =0;
     WCS_EQ                     =1;
     WCS_LT                     =2;
     WCS_GT                     =3;

ASSEMBLER

STRINGS.!StrEnd PROC NEAR32
//get pointer to end of string into EAX
//changes EAX,EBX,ECX und EDI
    MOV      EBX,ESP
    MOV      EDI,[EBX+4]
    XOR      EAX,EAX
    CMP      EDI,0
    JE       !Out!StrEnd    //String is NIL
    MOV      ECX,$0FFFFFFFF
    CLD
    REPNE
    SCASB
    DEC      EDI
    MOV      EAX,EDI
!Out!StrEnd:
    RETN32 4
STRINGS.!StrEnd ENDP

STRINGS.!StrLen PROC NEAR32
//get length of string
//changes EAX,EBX,ECX und EDI
    MOV EBX,ESP
    MOV EDI,[EBX+4]
    XOR EAX,EAX
    CMP EDI,0
    JE  !Out!StrLen    //String is NIL
    MOV ECX,$0FFFFFFFF
    CLD
    REPNE
    SCASB
    NOT ECX
    DEC ECX
    MOV EAX,ECX
!Out!StrLen:
    RETN32 4
STRINGS.!StrLen ENDP

END;  {Assembler}

{Allocate copy of Str}
FUNCTION StrNew(Str: PChar): PChar;
VAR
  L: LONGWORD;
  result:PChar;
BEGIN
     result := NIL;
     L := StrLen(Str);
     IF L > 0 THEN
     BEGIN
         Inc(L);
         GetMem(Result, L);
         StrMove(Result,Str,L);
     END;
     StrNew:=Result;
END;

{Dispose Str}
PROCEDURE StrDispose(Str: PChar);
BEGIN
     IF Str <> NIL THEN FreeMem(Str, StrLen(Str) + 1);
END;

{Get Pointer to End of String}
FUNCTION StrEnd(Str:PChar):PChar;
BEGIN
    ASM
       PUSH DWORD PTR Str
       CALLN32 STRINGS.!StrEnd
       MOV Result,EAX
    END;
END;

{Copy one string into another}
FUNCTION StrMove(Dest, Source: PChar; Count: ULONG): PChar;
VAR result:PChar;
LABEL l;
BEGIN
     result:=NIL;
     IF Source=NIL THEN goto l;
     IF Dest=NIL THEN goto l;
     IF Count=0 THEN goto l;
     Move(Source^,Dest^,Count);
     result:=Dest;
l:
     StrMove := result;
END;

{Concat two strings}
FUNCTION StrCat(Dest,Source:PChar):PChar;
BEGIN
  ASM
    MOV ESI,Source  //Source to ESI
    XOR EAX,EAX     //EAX := 0
    CMP ESI,0       //If Source = NIL..,
    JE !OUTStrCat   //... get out here !

    PUSH DWORD PTR Dest  //Dest auf den Stack
    CALLN32 STRINGS.!StrEnd //StrEnd-Proc aufrufen
    CMP EAX,0       //StrEnd returns 0 ?
    JE !OutStrCat   //if yes get out

    PUSH EDI        //StrEnd (Dest)

    XOR EAX,EAX
    MOV EDI,Source
    MOV ECX,$0FFFFFFFF
    CLD
    REPNE
    SCASB
    NOT ECX

    POP EDI        //StrEnd (Dest)
    MOV ESI,Source

    MOV EDX,ECX
    SHR ECX,2
    REP
    MOVSD
    MOV ECX,EDX
    AND ECX,3
    REP
    MOVSB

    MOV  EAX,Dest
!OutStrCat:
    MOV Result,EAX
  END;
END;

{Copy String into another}
FUNCTION StrCopy(Dest,Source:PChar):PChar;
BEGIN
  ASM
    MOV EDI,Source
    MOV ESI,Dest
    XOR EAX,EAX
    CMP EDI,0
    JE  !OUTStrCopy
    CMP ESI,0
    JE !OUTStrCopy
    MOV ECX,$0FFFFFFFF
    CLD
    REPNE
    SCASB
    NOT ECX

    MOV ESI,Source
    MOV EDI,Dest
    MOV EDX,ECX
    SHR ECX,2
    REP
    MOVSD
    MOV ECX,EDX
    AND ECX,3
    REP
    MOVSB

    MOV EAX,Dest
!OUTStrCopy:
    MOV Result,EAX
  END;
END;

FUNCTION StrECopy(Dest,Source:PChar):PChar;
BEGIN
     result:=StrCopy(Dest,Source);
     result:=StrEnd(result);
END;

FUNCTION StrLCopy(Dest,Source:PChar;Len:LONGINT):PChar;
BEGIN
    ASM
      MOV EDI,Source
      MOV ESI,Dest
      XOR EAX,EAX
      CMP EDI,0
      JE  !OUTStrCopy_xx
      CMP ESI,0
      JE !OUTStrCopy_xx
      MOV ECX,$0FFFFFFFF
      CLD
      REPNE
      SCASB
      NOT ECX

      CMP ECX,Len
      JBE !strxxxx2
      MOV ECX,Len
!strxxxx2:
      MOV ESI,Source
      MOV EDI,Dest
      MOV EDX,ECX
      SHR ECX,2
      REP
      MOVSD
      MOV ECX,EDX
      AND ECX,3
      REP
      MOVSB

      MOV EAX,Dest
!OUTStrCopy_xx:
      MOV Result,EAX
  END;
END;

{Get length of string}
FUNCTION StrLen(pszStr:PChar):ULONG;
BEGIN
  ASM
    PUSH DWORD PTR pszStr
    CALLN32 STRINGS.!StrLen
    MOV Result,EAX
  END;
END;

{Get pos-pointer to substring from string}
FUNCTION StrPos(MainStr,SubStr:PChar):PChar;
BEGIN
  ASM
    PUSH DWORD PTR SubStr    //SubStr
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE  !ErrOutStrPos

    MOV EDX,EAX          //L„nge von SubStr in EDX
    PUSH DWORD PTR MainStr
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE !ErrOutStrPos
    SUB EAX,EDX
    JB !ErrOutStrPos
    MOV EDI,MainStr
!1:
    MOV ESI,SubStr
    LODSB
    REPNE
    SCASB
    JNE !ErrOutStrPos;
    MOV EAX,ECX
    PUSH EDI
    MOV ECX,EDX  //L„nge SubStr nach ECX
    DEC ECX
    REPE
    CMPSB
    MOV ECX,EAX
    POP EDI
    JNE !1
    MOV EAX,EDI
    DEC EAX
    JMP !out
!ErrOutStrPos:
    XOR EAX,EAX
!Out:
    MOV Result,EAX
  END;
END;


{returns -1 if subStr is not inside of MainStr, otherwise position }
FUNCTION StrPosN(MainStr,SubStr:PChar):LONGINT;
BEGIN
  ASM
    PUSH DWORD PTR SubStr
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE !ErrOutPos

    MOV EDX,EAX          //L„nge von SubStr in EDX
    PUSH DWORD PTR MainStr
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE !ErrOutPos
    SUB EAX,EDX
    JB !ErrOutPos
    MOV EDI,MainStr
!1_1:
    MOV ESI,SubStr
    LODSB
    REPNE
    SCASB
    JNE !ErrOutPos
    MOV EAX,ECX

    PUSH EDI
    MOV ECX,EDX  //L„nge SubStr nach ECX
    DEC ECX
    REPE
    CMPSB
    MOV ECX,EAX
    POP EDI
    JNE !1_1

    SUB EDI,MainStr
    MOV EAX,EDI
    DEC EAX
    JMP !out_1
!ErrOutPos:
    MOV EAX,$0FFFFFFFF
!Out_1:
    MOV Result,EAX
  END;
END;

{Scan for char inside of string and return pointer to it}
FUNCTION StrScan(Str:PChar; Chr : Char):PChar;
BEGIN
  ASM
    PUSH DWORD PTR Str
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE !OutStrScan
    MOV AL,Chr
    MOV EDI,Str
    CLD
    REPNE
    SCASB
    MOV EAX,0
    CWD
    JNE !OutStrScan
    MOV EAX,EDI
    DEC EAX
!OutStrScan:
    MOV Result,EAX
  END;
END;

{returns -1 IF Chr is not inside of Str, Otherwise position}
FUNCTION StrScanN(Str:PChar; Chr : Char):LONGINT;
BEGIN
  ASM
    PUSH DWORD PTR Str
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE !ErrStrScanN
    MOV AL,Chr
    MOV EDI,Str
    CLD
    REPNE
    SCASB
    CWD
    JNE !ErrStrScanN
    SUB EDI,Str
    MOV EAX,EDI
    DEC EAX
    JMP !OutStrScanN
!ErrStrScanN:
    MOV EAX,$0FFFFFFFF
!OutStrScann:
    MOV Result,EAX
  END;
END;

{Get pointer to last appearance of character}
FUNCTION StrRScan(Str:PChar; Chr : Char):PChar;
BEGIN
    ASM
        PUSH DWORD PTR Str
        CALLN32 STRINGS.!StrLen
        CMP EAX,0
        JE !OutStrRScan
        MOV AL,Chr
        DEC EDI         //returned from !StrLen
        MOV ECX,EAX
        STD
        REPNE
        SCASB
        MOV EAX,0
        CWD
        JNE !OutStrRScan
        MOV EAX,EDI
        INC EAX
!OutStrRScan:
        CLD
        MOV Result,EAX
    END;
END;

{returns -1 if chr is not inside of Str, otherwise pos of last appearance}
FUNCTION StrRScanN(Str:PChar; Chr : Char):LONGINT;
BEGIN
  ASM
    PUSH DWORD PTR Str
    CALLN32 STRINGS.!StrLen
    CMP EAX,0
    JE !ErrStrRScanN
    MOV AL,Chr
    DEC EDI
    MOV ECX,EAX
    STD
    REPNE
    SCASB
    CWD
    JNE !ErrStrRScanN
    SUB EDI,Str
    MOV EAX,EDI
    INC EAX
    JMP !OutStrRScanN
!ErrStrRScanN:
    MOV EAX,$0FFFFFFFF
!OutStrRScanN:
    CLD
    MOV Result,EAX
  END;
END;

{Convert string to upper}
FUNCTION StrUpper(Str:PChar):PChar;
BEGIN
     WinUpper(0,0,0,Str^);
     StrUpper := Str;
END;

{Convert string to lower}
FUNCTION StrLower(Str:PChar):PChar;
BEGIN
  ASM
       CLD
       MOV ESI,Str
!SL1:
       LODSB
       OR AL,AL
       JE !OutStrLower

       CMP AL,'Ž'
       JNE !SLUE
       MOV AL,'„'
       JMP !SetChar
!SLUE:
       CMP AL,'š'
       JNE !SLOE
       MOV AL,''
       JMP !SetChar
!SLOE:
       CMP AL,'™'
       JNE !SL2
       MOV AL,'”'
       JMP !SetChar
!SL2:
       CMP AL, 'A'
       JB !SL1
       CMP AL,'Z'
       JA !SL1
       ADD AL,$20
!SetChar:
       MOV [ESI-1],AL
       JMP !SL1
!OutStrLower:
       MOV EAX,Str
       MOV Result,EAX
  END;
END;

{Convert Pascal String to pointer}
FUNCTION StrPCopy(Dest: PChar;CONST Source: String): PChar;
BEGIN
  ASM
    MOV ESI,Source
    MOV EDI,Dest
    MOV CL,[ESI+0]
    INC ESI
    MOVZX ECX,CL

    CLD
    MOV EDX,ECX
    SHR ECX,2
    REP
    MOVSD
    MOV ECX,EDX
    AND ECX,3
    REP
    MOVSB
!OutStrPCopy:
    MOVB [EDI+0],0   //terminate with zero
    MOV EAX,Dest
    MOV Result,EAX
  END;
END;

{Convert PChar to Pascal String}
FUNCTION StrPas(Str:PChar):String;
BEGIN
  ASM
    PUSH DWORD PTR Str    //Get Str
    CALLN32 STRINGS.!StrLen
    POP EBX
    CMP EAX,0
    JE !ErrStrPas
    MOV EDI,Result        //DestString
    MOV ESI,Str           //SourceStr
    MOVZX ECX,AL
    STOSB

    MOV EDX,ECX
    SHR ECX,2
    REP
    MOVSD
    MOV ECX,EDX
    AND ECX,3
    REP
    MOVSB

    JMP !OutStrPas
!ErrStrPas:
    MOV EDI,Result      //get result string
    MOVB [EDI+0],0      //terminate with zero
!OutStrPas:
  END;
END;

{Compare strings without upper and lower case}
FUNCTION StrIComp(Str1,Str2:PChar):Integer;
VAR Res : LONGWORD;
BEGIN
  Res := WinCompareStrings(0,0,0,Str1^,Str2^,0);
  case Res of
     WCS_EQ    : StrIComp := 0;
     WCS_LT    : StrIComp := -1;
     WCS_GT    : StrIComp := 1;
     WCS_ERROR : StrIComp := $FF;
  end;
END;

FUNCTION StrLIComp(Str1,Str2:PChar;MaxLen:LONGWORD):Integer;
VAR Res : LONGWORD;
    c1,c2:Char;
BEGIN
  IF StrLen(Str1) > MaxLen then
  BEGIN
      c1 := PString(Str1)^[MaxLen];
      PString(Str1)^[MaxLen] := #0;
  END
  ELSE c1 := #0;

  IF StrLen(Str2) > MaxLen then
  BEGIN
      c2 := PString(Str2)^[MaxLen];
      PString(Str2)^[MaxLen] := #0;
  END
  ELSE c2 := #0;

  Res := WinCompareStrings(0,0,0,Str1^,Str2^,0);
  CASE Res OF
     WCS_EQ    : StrLIComp := 0;
     WCS_LT    : StrLIComp := -1;
     WCS_GT    : StrLIComp := 1;
     WCS_ERROR : StrLIComp := $FF;
  END;
  IF c1 <> #0 THEN PString(Str1)^[MaxLen] := c1;
  IF c2 <> #0 THEN PString(Str2)^[MaxLen] := c2;
END;


{Compare strings}
FUNCTION StrComp(Str1,Str2:PChar):Integer;
BEGIN
  ASM
    CLD
    MOV EDI,Str2
    MOV ECX,$0FFFFFFFF
    XOR EAX,EAX
    CWD
    REPNE
    SCASB
    NOT ECX
    MOV ESI,Str1
    MOV EDI,Str2
    XOR EAX,EAX
    CMP ESI,0
    JE !OutStrComp
    CMP EDI,0
    JE !OutStrComp
    REPE
    CMPSB
    XOR AX,AX
    XOR DX,DX
    MOV AL,[ESI-1]
    MOV DL,[EDI-1]
    SUB AX,DX
!OutStrComp:
    MOV Result,EAX
  END;
END;

FUNCTION StrLComp(Str1, Str2: PChar; MaxLen: LongWord): Integer;
BEGIN
  ASM
    CLD
    MOV EDI,Str2
    MOV EAX,MaxLen
    CMP EAX,0
    JE !ErrStrLComp
    MOV ECX,EAX
    PUSH EBX
    XCHG EAX,EBX
    XOR EAX,EAX
    CWD
    REPNE
    SCASB
    SUB EBX,ECX
    MOV ECX,EBX
    POP EBX
    MOV EDI,Str2
    MOV ESI,Str1
    REPE
    CMPSB
    XOR AX,AX
    XOR DX,DX
    MOV AL,[ESI-1]
    MOV DL,[EDI-1]
    SUB AX,DX
    JMP !OutStrLComp
!ErrStrLComp:
    MOV EAX,42
!OutStrLComp:
    MOV Result,EAX
  END;
END;



END.


