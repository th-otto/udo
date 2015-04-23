UNIT PortIO;

{**************************************************************************
 *                 General Unit for Speed-Pascal/2                        *
 *                                                                        *
 *    PORT Input/Output Operations (Hope it works)                        *
 *                                                                        *
 *                                                                        *
 * Suggested by Ralf Brandt @ 2:2410/104.3 (28.10.94)                     *
 *                                                                        *
 **************************************************************************}

{ 04-Mar-96: Adapted to Speed-Pascal 1.5, added pseudo-arrays Port[]
             and PortW[] which behave like the ones in Borland Pascal.
             Implemented using classes and default properties.

             Caution: Untested! :-) }

INTERFACE

FUNCTION ReadBytePort(PortAdress:WORD;VAR value:BYTE):BOOLEAN;
FUNCTION ReadWordPort(PortAdress:WORD;VAR value:WORD):BOOLEAN;
FUNCTION WriteBytePort(PortAdress:WORD;value:BYTE):BOOLEAN;
FUNCTION WriteWordPort(PortAdress:WORD;value:Word):BOOLEAN;
FUNCTION ReadPhysMemory(Address:LONGWORD;VAR Buf;Count:LONGWORD):BOOLEAN;

TYPE
  { Pseudo-array for byte-wise I/O. Don't create
    instances of this class. The unit already
    creates one for you. }

  TBytePorts = class
  private
    function GetByte(PortAddr: Word): Byte;
    procedure SetByte(PortAddr:Word; Value: Byte);
  public
    property IO[PortAddr: Word]: Byte
      read GetByte write SetByte; default;
  end;

  { Pseudo-array for word-wise I/O. Don't create
    instances of this class. The unit already
    creates one for you. }

  TWordPorts = class
  private
    function GetWord(PortAddr: Word): Word;
    procedure SetWord(PortAddr:Word; Value: Word);
  public
    property IO[PortAddr: Word]: Word
      read GetWord write SetWord; default;
  end;

VAR
  { Use this for byte-wise I/O, just like
    array PORT[] in Borland Pascal. }

  Port: TBytePorts;

  { Use this for word-wise I/O, just like
    array PORTW[] in Borland Pascal. }

  PortW: TWordPorts;

IMPLEMENTATION

USES
  OS2DEF, BSEDOS;

CONST
     TSTCFG_CAT         =$80;
     TSTCFG_FCN_PHYS    =$40;
     TSTCFG_FCN_INPUT   =$41;
     TSTCFG_FCN_OUTPUT  =$42;

CONST
     IODriverName:STRING='TESTCFG$'; {Driver name for Port I/O}

VAR
     IODriverHandle:LONGWORD;
     IOAction:LONGWORD;
     IOOldExit:POINTER;

TYPE
    TPortAddr=RECORD
                    ioaddr:WORD;
                    iowidth:WORD;
                    iovalue:WORD;
              END;

    TPhysAddr=RECORD
                    Command:LONGWORD;
                    address:LONGWORD;
                    Bytes:LONGWORD;
              END;

FUNCTION ReadBytePort(PortAdress:WORD;VAR value:BYTE):BOOLEAN;
VAR
   PortAddr:TPortAddr;
BEGIN
     PortAddr.IoAddr:=PortAdress;
     PortAddr.IoWidth:=1;
     IF DosDevIoCtl(IODriverHandle,TSTCFG_CAT,TSTCFG_FCN_INPUT,PortAddr,
                     SizeOf(TPortAddr),NIL,Value,1,NIL)<>0 THEN
     ReadBytePort:=FALSE
     ELSE ReadBytePort:=TRUE;
END;

FUNCTION ReadWordPort(PortAdress:WORD;VAR value:WORD):BOOLEAN;
VAR
   PortAddr:TPortAddr;
BEGIN
     PortAddr.IoAddr:=PortAdress;
     PortAddr.IoWidth:=2;
     IF DosDevIoCtl(IODriverHandle,TSTCFG_CAT,TSTCFG_FCN_INPUT,PortAddr,
                     SizeOf(TPortAddr),NIL,Value,2,NIL)<>0 THEN
     ReadWordPort:=FALSE
     ELSE ReadWordPort:=TRUE;
END;

FUNCTION WriteBytePort(PortAdress:WORD;value:BYTE):BOOLEAN;
VAR
   PortAddr:TPortAddr;
BEGIN
     PortAddr.IoAddr:=PortAdress;
     PortAddr.IoWidth:=1;
     PortAddr.IoValue:=value;
     IF DosDevIoCtl(IoDriverHandle,TSTCFG_CAT,TSTCFG_FCN_OUTPUT,PortAddr,
                 SizeOf(TPortAddr),NIL,Value,1,NIL)<>0 THEN
     WriteBytePort:=FALSE
     ELSE WriteBytePort:=TRUE;
END;

FUNCTION WriteWordPort(PortAdress:WORD;value:Word):BOOLEAN;
VAR
   PortAddr:TPortAddr;
BEGIN
     PortAddr.IoAddr:=PortAdress;
     PortAddr.IoWidth:=2;
     PortAddr.IoValue:=value;
     IF DosDevIoCtl(IoDriverHandle,TSTCFG_CAT,TSTCFG_FCN_OUTPUT,PortAddr,
                 SizeOf(TPortAddr),NIL,Value,2,NIL)<>0 THEN
     WriteWordPort:=FALSE
     ELSE WriteWordPort:=TRUE;
END;


FUNCTION ReadPhysMemory(Address:LONGWORD;VAR Buf;Count:LONGWORD):BOOLEAN;
VAR
   PhysAddr:TPhysAddr;
BEGIN
     PhysAddr.Command:=0;
     PhysAddr.Address:=Address;
     PhysAddr.Bytes:=Count;
     IF DosDevIoCtl(IODriverHandle,TSTCFG_CAT,TSTCFG_FCN_PHYS,PhysAddr,
                 sizeof(TPhysAddr),NIL,Buf,Count,NIL)<>0 THEN
     ReadPhysMemory:=FALSE
     ELSE ReadPhysMemory:=TRUE;
END;

FUNCTION GetBytePort(PortAddress : Word) : Byte; {Substitute for Port[]}
VAR
   PortValue:BYTE;
BEGIN
     ReadBytePort(PortAddress,PortValue);
     GetBytePort:=PortValue;
END;

FUNCTION GetWordPort(PortAddress : Word) : Word; {Substitute for PortW[]}
VAR
   PortValue:WORD;
BEGIN
     ReadWordPort(PortAddress,PortValue);
     GetWordPort:=PortValue;
END;


PROCEDURE IOExit;
BEGIN
     ExitProc:=IOOldExit;
     IF IoDriverHandle<>0 THEN DosClose(IoDriverHandle);
     Port.Destroy;
     PortW.Destroy;
END;

function TBytePorts.GetByte(PortAddr: Word): Byte;
begin
  ReadBytePort(PortAddr, Result);
end;

procedure TBytePorts.SetByte(PortAddr:Word; Value: Byte);
begin
  WriteBytePort(PortAddr, Value);
end;

function TWordPorts.GetWord(PortAddr: Word): Word;
begin
  ReadWordPort(PortAddr, Result);
end;

procedure TWordPorts.SetWord(PortAddr:Word; Value: Word);
begin
  WriteWordPort(PortAddr, Value);
end;

BEGIN
     IOOldExit:=ExitProc;
     ExitProc:=@IOExit;
     DosOpen(IODriverName,IoDriverHandle,IoAction,0,0,1,$40,NIL);

     Port.Create;
     PortW.Create;
END.