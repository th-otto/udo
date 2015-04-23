Unit ACLLibraryTestForm;

Interface

Uses
  Classes, Forms, Graphics, Buttons,
  StdCtrls,
  ACLFileIOUtility,
  ACLUtility,
  PCharList,
  ACLResourceUtility,
  ACLVersionUtilityUnit,
  Semaphores,
  SharedMemoryUnit,

  FileUtilsUnit,
  StringUtilsUnit,
  CharUtilsUnit,
  DebugUnit;

Type
  TACLLibraryTestForm = Class (TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    FindButton: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Procedure FindButtonOnClick (Sender: TObject);
    Procedure Button4OnClick (Sender: TObject);
    Procedure Button3OnClick (Sender: TObject);
    Procedure Button2OnClick (Sender: TObject);
    Procedure ACLLibraryTestFormOnCreate (Sender: TObject);
    Procedure ACLLibraryTestFormOnDestroy (Sender: TObject);
    Procedure ACLLibraryTestFormOnDismissDlg (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
  Private
    {Insert private declarations here}
  Public
    {Insert public declarations here}
  End;

Var
  ACLLibraryTestForm: TACLLibraryTestForm;

Implementation

uses
  SysUtils,
  ACLString, AStringUtilityUnit,
  RunProgramUnit;

Procedure TACLLibraryTestForm.FindButtonOnClick (Sender: TObject);
var
  i: integer;
Begin
  i := CaseInsensitivePos( Edit1.Text,
                           Edit2.Text );
  Memo1.Lines.Add( 'Result: ' + intToStr( i ) );
End;

Procedure TACLLibraryTestForm.Button4OnClick (Sender: TObject);
var
  a: TAString;
Begin
  a := TAString.CreateFromPCharWithDispose( Memo1.Lines.GetText );
  a.InsertString( 5,  Edit1.Text );
  Memo1.Lines.SetText( a.AsPChar );
  a.Destroy;
End;

Procedure TACLLibraryTestForm.Button3OnClick (Sender: TObject);
Begin
End;

const
  test: string = 'This is the string I want to test the CRC with. Ha ha haa';
  test2: string = 'HERES ANOTHER #&*#^*& STRING';
  test3: string = #234#221#014;

Procedure TACLLibraryTestForm.Button2OnClick (Sender: TObject);
var
  crc: longword;
Begin
  crc := GetCRC32( Addr( test ), Length( test ) + 1 );
  Memo1.Lines.Add( 'Asm Crc =    ' + IntToStr( crc ) );
  crc := Pascal_GetCRC32( Addr( test ), Length( test ) + 1 );
  Memo1.Lines.Add( 'Pascal Crc = ' + IntToStr( crc ) );

  crc := GetCRC32( Addr( test2 ), Length( test2 ) + 1 );
  Memo1.Lines.Add( 'Asm Crc =    ' + IntToStr( crc ) );
  crc := Pascal_GetCRC32( Addr( test2 ), Length( test2 ) + 1 );
  Memo1.Lines.Add( 'Pascal Crc = ' + IntToStr( crc ) );

  crc := GetCRC32( Addr( test3 ), Length( test3 ) + 1 );
  Memo1.Lines.Add( 'Asm Crc =    ' + IntToStr( crc ) );
  crc := Pascal_GetCRC32( Addr( test3 ), Length( test3 ) + 1 );
  Memo1.Lines.Add( 'Pascal Crc = ' + IntToStr( crc ) );

End;

type
  TTestSharedMemObject = record
    Cake: longint;
    Sausage: string;
  end;
  TPTestSharedMemObject = ^TTestSharedMemObject;

Procedure TACLLibraryTestForm.ACLLibraryTestFormOnCreate (Sender: TObject);
var
  SharedMem1, SharedMem2: TSuballocatedSharedMemory;
  a,b: TPTestSharedMemObject;
Begin
  Memo1.Lines.Add( GetApplicationDir );
//  Memo1.Lines.Add( 'Color depth: ' + IntToStr( GetScreenColorDepth ) );
//  Memo1.Lines.Add( 'Video driver: ' + GetVideoDriverName );

  SharedMem1 := TSuballocatedSharedMemory.Create( 'TEST_SHARED_MEM', 4096, sizeof( TTestSharedMemObject ) );
  SharedMem2 := TSuballocatedSharedMemory.Create( 'TEST_SHARED_MEM', 4096, sizeof( TTestSharedMemObject ) );

  a := SharedMem1.Data;
  b := SharedMem2.Data;

  a^.Cake := 7;
  a^.Sausage := 'The Seventh Sausage';

  SharedMem1.Allocate( a, sizeof( TTestSharedMemObject ) );
  a^.Cake := 12;
  a^.Sausage := 'Four Times Fifty Living Men';

  SharedMem1.Destroy;

  Memo1.Lines.Add( 'Shared Mem: ' + IntToStr( b^.Cake ) );
  Memo1.Lines.Add( 'Shared Mem: ' + b^.Sausage );

  Memo1.Lines.Add( 'Suballoced: ' + IntToStr( a^.Cake ) );
  Memo1.Lines.Add( 'Suballoced: ' + a^.Sausage );

  SharedMem2.Free( a );

  SharedMem2.Destroy;
End;

Procedure TACLLibraryTestForm.ACLLibraryTestFormOnDestroy (Sender: TObject);
Begin
  CheckAllAStringsDestroyed;
End;

Procedure TACLLibraryTestForm.ACLLibraryTestFormOnDismissDlg (Sender: TObject);
Begin

End;

Procedure TACLLibraryTestForm.Button1OnClick (Sender: TObject);
var
  VersionsModule: TVersionsModule;
  Version: string;
begin
  if OpenModuleForVersions( GetApplicationFilename,
                            VersionsModule ) then
  begin
    while GetVersionFromModule( VersionsModule,
                                Version ) do
      Memo1.Lines.Add( Version );
  end;

End;

Initialization
  RegisterClasses ([TACLLibraryTestForm, TMemo, TEdit, TButton]);
End.
