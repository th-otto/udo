unit ACLLibraryTestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ACLResourceUtility, ACLString;

type
  TACLLibraryTestForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    StartDelEdit: TEdit;
    LengthDelEdit: TEdit;
    NextValEdit: TEdit;
    SepEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StartExtractEdit: TEdit;
    Label4: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ACLLibraryTestForm: TACLLibraryTestForm;

implementation

uses
  Semaphores;

{$R *.DFM}

procedure TACLLibraryTestForm.Button1Click(Sender: TObject);
var
  AString: TAString;
  Start, Len: longint;
begin
  AString:= TAString.CreateFrom( Edit1.Text );
  Start:= StrToInt( StartDelEdit.Text );
  Len:= StrToInt( LengthDelEdit.Text );
  AString.Delete( Start, Len );
  Edit1.Text:= AString.AsString;
  AString.Destroy;
end;

procedure TACLLibraryTestForm.Button2Click(Sender: TObject);
var
  AString: TAString;
  NextVal: TAString;
  Start: longint;
  Sep: Char;
begin
  AString:= TAString.CreateFrom( Edit1.Text );
  NextVal:= TAString.Create;
  Start:= StrToInt( StartExtractEdit.Text );
  Sep:= SepEdit.Text[ 1 ];
  AString.ExtractNextValue( Start, NextVal, Sep );
  NextValEdit.Text:= NextVal.AsString;
  StartExtractEdit.Text:= IntToStr( Start );
  AString.Destroy;
  NextVal.Destroy;
end;

end.
