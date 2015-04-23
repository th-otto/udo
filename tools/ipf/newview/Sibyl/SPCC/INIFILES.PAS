
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit IniFiles;

{ TIniFile: Standard (binres) OS/2 Inifile
  TAsciiIniFile: Text-Inifile, lesbar, mit Editor zu bearbeiten.

  Beide benutzen exakt das gleiche Interface und sind bis
  auf Die neue Methode 'Erase' kompatibel zu den normalen
  Delphi-IniFiles. }

Interface

Uses Classes,SysUtils;

{$IFDEF OS2}
Uses PMSHL; { OS/2 profile FUNCTIONs }
{$ENDIF}
{$IFDEF Win95}
Uses WinBase;
{$ENDIF}

Type
  EIniFileError = Class(Exception);

Type
  TIniFile = Class(TObject)
  Private
    FFileName: PString;         // Physical Name Of File
    {$IFDEF OS2}
    FHandle: HINI;              // profile Handle
    {$ENDIF}
    Function GetFileName: String;

  Protected
    Procedure Error(Const Msg: String); Virtual;

  Public
    Constructor Create(Const FileName: String);Virtual;
    Destructor Destroy; Override;
    Procedure Erase(Const section, Ident: String); Virtual;
    Procedure EraseSection(Const section: String); Virtual;
    Function ReadString(Const section, Ident, Default: String): String; Virtual;
    Function ReadInteger(Const section, Ident: String; Default: LongInt): LongInt; Virtual;
    Function ReadBool(Const section, Ident: String; Default: Boolean): Boolean; Virtual;
    Procedure ReadSection(Const section: String; AStrings: TStrings); Virtual;
    {Procedure ReadSections(AStrings: TStrings); fehlt noch}
    Procedure ReadSectionValues(Const section: String; AStrings: TStrings); Virtual;
    Procedure WriteString(Const section, Ident, Value: String); Virtual;
    Procedure WriteInteger(Const section, Ident: String; Value: LongInt); Virtual;
    Procedure WriteBool(Const section, Ident: String; Value: Boolean); Virtual;

    Property FileName: String
      Read GetFileName;
  End;

Type
  {$HINTS OFF}
  TAsciiIniFile = Class(TIniFile)
  Private
    //FFileName: PString;         // Physical Name Of File
    FSections: TStringList;     // List Of Sections And their Names
    FName: PString;             // Name Of Last used section
    FList: TStringList;         // List Of Last used section
    FChanged: Boolean;          // has the Data been changed?
    Procedure WriteToSection(Const section: String);
    Function ReadFromSection(Const section: String): Boolean;
    //Function GetFileName: String;

  Protected
    TrueString: String[7];
    FalseString: String[7];
    SectionSort: Boolean;
    IdentSort: Boolean;
  Protected
    Procedure InitIniFile;Virtual;

  Public
    Constructor Create(Const FileName: String);Virtual;
    Destructor Destroy; Override;
    Procedure Erase(Const section, Ident: String); Override;
    Procedure EraseSection(Const section: String); Override;
    Function ReadString(Const section, Ident, Default: String): String; Override;
    Function ReadInteger(Const section, Ident: String; Default: LongInt): LongInt; Override;
    Function ReadBool(Const section, Ident: String; Default: Boolean): Boolean; Override;
    Procedure ReadSection(Const section: String; AStrings: TStrings); Override;
    Procedure ReadSections(AStrings: TStrings);
    Procedure ReadSectionValues(Const section: String; AStrings: TStrings); Override;
    Procedure Refresh;
    Procedure WriteString(Const section, Ident, Value: String); Override;
    Procedure WriteInteger(Const section, Ident: String; Value: LongInt); Override;
    Procedure WriteBool(Const section, Ident: String; Value: Boolean); Override;

    Property FileName: String
      Read GetFileName;
    Property changed: Boolean
      Read FChanged Write FChanged;
  End;
  {$HINTS ON}

Function GetDefaultINI: String;
  { Get Name Of INI-File that matches Program Path & Name With
    extension .INI instead Of .EXE }

Implementation

Uses
  SysUtils;

Const
  Null = 0;

Type
  {$HINTS OFF}
  TIniSection = Class(TStringList)
    Private
        Function GetValue(Const Name: String): String;
        Procedure SetValue(Const Name, Value: String);
        Function FindValue(Const Name: String; Var Value: String): LongInt;
        Procedure FreeItem(AObject:TObject);Override;
        Property values[Const Name: String]: String Read GetValue Write SetValue;
  End;
  {$HINTS ON}

Function CutStr(Var S: String; C: Char): String;
Var
  P: Integer;
Begin
  P := Pos(C, S);
  If P = 0 Then
  Begin
    Result := S;
    SetLength(S, 0);
  End
  Else
  Begin
    Result := Copy(S, 1, P - 1);
    Delete(S, 1, P);
  End;
End;

Function TrimStr(Const S: String): String;
Var
  L, R: Integer;
Begin
  R := Length(S);
  While (R > 0) And (S[R] = ' ') Do Dec(R);
  L := 1;
  While (L <= R) And (S[L] = ' ') Do Inc(L);
  Result := Copy(S, L, R - L + 1);
End;

Function GetDefaultINI: String;
Begin
  Result := ExpandFileName(ChangeFileExt(ParamStr(0), '.INI'));
End;

{ TIniSection }

Procedure TIniSection.FreeItem(AObject:TObject);
Var
  P: PString;
Begin
  P := PString(AObject);
  DisposeStr(P);
  Inherited FreeItem(AObject);
End;

{Procedure TIniSection.Put(Index: LongInt; Const S: String);
Var
  Ident, Value: String;
Begin
  Value := S;
  Ident := CutStr(Value, '=');
  SetValue(Ident, Value);
End;}

Function TIniSection.GetValue(Const Name: String): String;
Var
  I: LongInt;
Begin
  If Find(Name, I) Then Result := PString(Objects[I])^
  Else Result := '';
End;

Function TIniSection.FindValue(Const Name: String; Var Value: String): LongInt;
Begin
  If Find(Name, Result) Then Value := PString(Objects[Result])^
  Else
  Begin
    Value := '';
    Result := -1;
  End;
End;

Procedure TIniSection.SetValue(Const Name, Value: String);
Var
  I: LongInt;
  P: PString;
  OldSorted: Boolean;
Begin
  If Find(Name, I) Then
  Begin
    P := PString(Objects[I]);
    DisposeStr(P);
    PutObject(I, TObject(NewStr(Value)));
  End
  Else
  Begin
    OldSorted := sorted;
    sorted := False;
    InsertObject(I, Name, TObject(NewStr(Value)));
    sorted := OldSorted;
  End;
End;

{ TIniFile }

Constructor TIniFile.Create(Const FileName: String);
Begin
  {$IFDEF OS2}
  FHandle := PrfOpenProfile(AppHandle, FileName);
  If FHandle = Null Then Error(LoadNLSStr(SCannotOpenIniFile)+'.');
  {$ENDIF}
  FFileName := NewStr(FileName);
End;

Destructor TIniFile.Destroy;
Begin
  {$IFDEF OS2}
  PrfCloseProfile(FHandle);
  {$ENDIF}
  DisposeStr(FFileName);

  Inherited Destroy;
End;

Procedure TIniFile.Erase(Const section, Ident: String);
Begin
  {$IFDEF OS2}
  PrfWriteProfileString(FHandle, section, Ident, Nil);
  {$ENDIF}
  {$IFDEF Win95}
  WritePrivateProfileString(section,Ident,Nil,FileName);
  {$ENDIF}
End;

Procedure TIniFile.EraseSection(Const section: String);
Begin
  {$IFDEF OS2}
  PrfWriteProfileString(FHandle, section, Nil, Nil);
  {$ENDIF}
  {$IFDEF Win95}
  WritePrivateProfileString(section,Nil,Nil,FileName);
  {$ENDIF}
End;

Procedure TIniFile.Error(Const Msg: String);
Begin
  Raise EIniFileError.Create(Msg);
End;

Function TIniFile.GetFileName: String;
Begin
  Result := FFileName^;
End;

Function TIniFile.ReadString(Const section, Ident, Default: String): String;
Var
  OutBuf: cstring;
Begin
  {$IFDEF OS2}
  Fillchar(OutBuf, 255, 0); {sometimes the #0 character is not copied (cdp.ini)}
  PrfQueryProfileString(FHandle, Section, Ident, Default, OutBuf, 255);
  Result := OutBuf;
  {$ENDIF}
  {$IFDEF Win95}
  SetLength(Result,GetPrivateProfileString(
    Section,Ident,Default,cstring(Result[1]),255,FileName));
  {$ENDIF}
End;

Function TIniFile.ReadInteger(Const section, Ident: String; Default: LongInt): LongInt;
Begin
  {$IFDEF OS2}
  Result := PrfQueryProfileInt(FHandle, section, Ident, Default);
  {$ENDIF}
  {$IFDEF Win95}
  Result := GetPrivateProfileInt(section,Ident,Default,FileName);
  {$ENDIF}
End;

Function TIniFile.ReadBool(Const section, Ident: String; Default: Boolean): Boolean;
Var
  L: LongInt;
Begin
  If Default Then L := 1 Else L := 0;
  {$IFDEF OS2}
  Result := (PrfQueryProfileInt(FHandle, section, Ident, L) <> 0);
  {$ENDIF}
  {$IFDEF Win95}
  Result := (GetPrivateProfileInt(section,Ident,L,FileName) <> 0);
  {$ENDIF}
End;

Procedure TIniFile.ReadSection(Const section: String; AStrings: TStrings);
Var
  Size, RealSize: LongWord;
  Buffer, Pos: PChar;
  S: String;
Begin
  {$IFDEF OS2}
  If Not PrfQueryProfileSize(FHandle, section, Nil, Size) Then Exit;
  If Size=0 Then exit;
  {$ENDIF}
  {$IFDEF Win95}
  //??????????????????????????????????????????????????????????
  Size:=8192;
  {$ENDIF}
  GetMem(Buffer, Size);
  Try
    {$IFDEF OS2}
    PrfQueryProfileString(FHandle, section, Nil, Nil, Buffer^, Size);
    Buffer[Size - 1] := #0;
    {$ENDIF}
    {$IFDEF Win95}
    Buffer[GetPrivateProfileString(section,Nil,Nil,Buffer^,Size,FileName)-1] := #0;
    {$ENDIF}
    Pos := Buffer;
    While Pos[0] <> #0 Do
    Begin
      S := StrPas(Pos);
      Inc(Pos, Length(S) + 1);
      Dec(RealSize, Length(S) + 1);
      AStrings.Add(S);
    End;
  Finally
    FreeMem(Buffer, Size);
  End;
End;

Procedure TIniFile.ReadSectionValues(Const section: String; AStrings: TStrings);
Var
  Temp: TIniSection;
  I: LongInt;
Begin
  Temp := TIniSection.Create;
  Temp.sorted := True;
  Temp.Duplicates := dupIgnore;
  Try
    ReadSection(section, Temp);
    For I := 0 To Temp.Count - 1 Do
      AStrings.values[Temp.Strings[I]]:=ReadString(section, Temp.Strings[I], '');
  Finally
    Temp.Destroy;
  End;
End;

Procedure TIniFile.WriteString(Const section, Ident, Value: String);
Var
  CSection, CIdent, CValue: cstring[256];
Begin
  CSection := section;
  CIdent := Ident;
  CValue := Value;
  {$IFDEF OS2}
  If Not PrfWriteProfileString(FHandle, CSection, CIdent, CValue) Then
    Error(LoadNLSStr(SWriteError)+'.');
  {$ENDIF}
  {$IFDEF Win95}
  If Not WritePrivateProfileString(CSection,CIdent,CValue,FileName) Then
    Error(LoadNLSStr(SWriteError)+'.');
  {$ENDIF}
End;

Procedure TIniFile.WriteInteger(Const section, Ident: String; Value: LongInt);
Begin
  WriteString(section, Ident, IntToStr(Value));
End;

Procedure TIniFile.WriteBool(Const section, Ident: String; Value: Boolean);
Var
  C: Char;
Begin
  If Value Then C := '1' Else C := '0';
  WriteString(section, Ident, C);
End;

{ TAsciiIniFile }

Constructor TAsciiIniFile.Create(Const FileName: String);
Var
  Source: Text;
  S, T: String;
Begin
  SectionSort := False;
  IdentSort := False;

  InitIniFile;

  FSections := TStringList.Create;
  FSections.Duplicates := dupIgnore;
  FSections.sorted := SectionSort;
  TrueString := 'True';
  FalseString := 'False';

  FFileName := NewStr(FileName);
  FName := NullStr;

  If FFileName <> NullStr Then
  Begin
    Assign(Source, FileName);
    {$I-}
    Reset(Source);
    {$I+}
    If IOResult = 0 Then
    Begin
      While Not Eof(Source) Do
      Begin
        ReadLn(Source, S);
        If Length(S) <> 0 Then
        Begin
          If S[1] = '[' Then
          Begin
            { New section }
            Delete(S, 1, 1);
            WriteToSection(CutStr(S, ']'));
          End
          Else
          If Not (S[1] In [';', '#', '%']) Then
          Begin
            { New entry }
            If FList = Nil Then WriteToSection('');
            T := CutStr(S, '=');
            FList.AddObject(TrimStr(T), TObject(NewStr(TrimStr(S))));
          End;
        End;
      End;
      Close(Source);
    End;
    // else - unable to open file. That's OK,
    // we will create it later - AaronL
  End;
End;

{To Setup the Sort Value Of section And Ident}
Procedure TAsciiIniFile.InitIniFile;
Begin
End;

Destructor TAsciiIniFile.Destroy;
Var
  I: LongInt;
Begin
  Refresh;
  DisposeStr(FName);
  DisposeStr(FFileName);
  For I := 0 To FSections.Count - 1 Do
  Begin
    FList := TIniSection(FSections.Objects[I]);
    FList.Destroy;
  End;
  FSections.Destroy;
End;

Procedure TAsciiIniFile.Erase(Const section, Ident: String);
Var
  I: LongInt;
Begin
  If ReadFromSection(section) Then
  Begin
    If FList.Find(Ident, I) Then
    Begin
      FList.Delete(I);
      FChanged := True;
    End;
  End;
End;

Procedure TAsciiIniFile.EraseSection(Const section: String);
Var
  I: LongInt;
  S: TIniSection;
Begin
  If FSections.Find(section, I) Then
  Begin
    S := TIniSection(FSections.Objects[I]);
    S.Destroy;
    FSections.Delete(I);
    If S = FList Then
    Begin
      AssignStr(FName, '');
      FList := Nil;
    End;
    FChanged := True;
  End;
End;

Procedure TAsciiIniFile.WriteToSection(Const section: String);
Var
  I: LongInt;
Begin
  If CompareText(section, FName^) <> 0 Then
  Begin
    If FSections.Find(section, I) Then
    Begin
      AssignStr(FName, section);
      FList := TIniSection(FSections.Objects[I]);
    End
    Else
    Begin
      FList := TIniSection.Create;
      FList.Duplicates := dupAccept;
      FList.sorted := IdentSort;
      FList.CaseSensitive := False;
      FSections.AddObject(section, FList);
      AssignStr(FName, section);
    End;
  End;
End;

Function TAsciiIniFile.ReadFromSection(Const section: String): Boolean;
Var
  I: LongInt;
Begin
  Result := True; {!}
  If CompareText(section, FName^) <> 0 Then
  Begin
    If FSections.Find(section, I) Then
    Begin
      AssignStr(FName, section);
      FList := TIniSection(FSections.Objects[I]);
    End
    Else Result := False; {!}
  End;
//  Result := (FList <> Nil);
  {liefert sonst Die Letzte zurck, wenn section unbekannt}
End;

{Function TAsciiIniFile.GetFileName: String;
Begin
  Result := FFileName^;
End;}

Function TAsciiIniFile.ReadBool(Const section, Ident: String; Default: Boolean): Boolean;
Var
  S: String;
Begin
  If ReadFromSection(section) Then
  With TIniSection(FList) { As TIniSection} Do
  Begin
    If FindValue(Ident, S) = -1 Then Result := Default
    Else
    Begin
      If CompareText(S, TrueString) = 0 Then Result := True
      Else If CompareText(S, FalseString) = 0 Then Result := False
      Else Result := Default;
    End;
  End
  Else Result := Default;
End;

Function TAsciiIniFile.ReadInteger(Const section, Ident: String; Default: LongInt): LongInt;
Var
  S: String;
Begin
  If ReadFromSection(section) Then
  With TIniSection(FList) { As TIniSection} Do
  Begin
    If FindValue(Ident, S) = -1 Then Result := Default
    Else Result := StrToIntDef(S, Default);
  End
  Else Result := Default;
End;

Function TAsciiIniFile.ReadString(Const section, Ident, Default: String): String;
Begin
  If ReadFromSection(section) Then
  With TIniSection(FList) { As TIniSection} Do
  Begin
    If FindValue(Ident, Result) = -1 Then Result := Default;
  End
  Else Result := Default;
End;

Procedure TAsciiIniFile.ReadSection(Const section: String; AStrings: TStrings);
Var
  N: LongInt;
Begin
  If ReadFromSection(section) Then
  Begin
    For N := 0 To FList.Count - 1 Do AStrings.Add(FList.Strings[N]);
  End;
End;

Procedure TAsciiIniFile.ReadSections(AStrings: TStrings);
Var
  N: LongInt;
Begin
  For N := 0 To FSections.Count - 1 Do AStrings.Add(FSections.Strings[N]);
End;

Procedure TAsciiIniFile.ReadSectionValues(Const section: String; AStrings: TStrings);
Var
  N: LongInt;
Begin
  If ReadFromSection(section) Then
  Begin
    For N := 0 To FList.Count - 1 Do
      AStrings.Add(FList.Strings[N] + '=' + PString(FList.Objects[N])^);
  End;
End;

// Save the ini file from memory to the file.
Procedure TAsciiIniFile.Refresh;
Var
  Dest: Text;
  N, I: LongInt;
  L: TIniSection;
  S: String;
Begin
  If FChanged And (FFileName <> NullStr) Then
  Begin
    Assign(Dest, FileName);
    Rewrite(Dest);
    For N := 0 To FSections.Count - 1 Do
    Begin
      S := FSections.Strings[N];
      If Length(S) <> 0 Then
      Begin
        WriteLn(Dest, '[' + S + ']');
        WriteLn(Dest);
      End;
      L := TIniSection(FSections.Objects[N]);
      For I := 0 To L.Count - 1 Do
        WriteLn(Dest, L.Strings[I], '=', PString(L.Objects[I])^);
      If N < FSections.Count Then WriteLn(Dest);
      FChanged := False;
    End;
    Close(Dest);
  End;
End;

Procedure TAsciiIniFile.WriteBool(Const section, Ident: String; Value: Boolean);
Begin
  FChanged := True;
  WriteToSection(section);
  If Value Then TIniSection(FList).values[Ident]:=TrueString
  Else TIniSection(FList).values[Ident]:=FalseString;
End;

Procedure TAsciiIniFile.WriteInteger(Const section, Ident: String; Value: LongInt);
Begin
  FChanged := True;
  WriteToSection(section);
  TIniSection(FList).values[Ident]:=IntToStr(Value);
End;

Procedure TAsciiIniFile.WriteString(Const section, Ident, Value: String);
Begin
  FChanged := True;
  WriteToSection(section);
  TIniSection(FList).values[Ident]:=Value;
End;

End.

{ nderungen: 26.11.95  Sections werden sortiert, Eintrge aber nicht
              28.11.95  alles wird sortiert, schneller durch Trennung
                        von Ident und Value (TIniSection).
              30.11.95  Fehler In TIniSection korrigiert, ES
                        fehlten Get/Put
              16.12.95  neue Funktion GetDefaultINI()
              16-Aug-97   J”rg: Bugfix for TIniFile.ReadString.

  To-Do: - Eventuell ReadData / WriteData einbauen
         - Eventuell ReadSectionNames einbauen = ReadSections
         - wenn String -> cstring Fehler In SP/2 behoben,
           Workaround entfernen.
}



