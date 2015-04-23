UNIT SerialIO;

INTERFACE

{**************************************************************************
 *                                                                        *
 * Written for Speed Pascal/2                                             *
 * Interface to Async communications under OS/2                           *
 * Author:        Alex T. Vermeulen (a.vermeulen@ecn.nl, atverm@xs4all.nl)*
 * Date:                17-4-95                                           *
 **************************************************************************}



TYPE
  parityt = (par_none,par_odd,par_even,par_mark,par_space);



FUNCTION initport (port_num:integer;
                   parity:parityt;
                   databits,stopbits:byte;
                   RTS_CTS,XON_XOFF:BOOLEAN):INTEGER;

{ This function initializes the com buffer, setting up the interrupt,
  and com parameters, returns 0 ik ok else an error number}


PROCEDURE closeport;

{ This function closes the com port, removing the interrupt routine,
  etc. }


PROCEDURE outcomch (ch: char);

{ This function outputs one character to the com port }


FUNCTION peek1char:char;

{ return next char in receive buffer, or 0 for none available }


FUNCTION get1char:char;

{ This function returns one character from the com port, or a zero if
   no character is waiting }



FUNCTION comhit:boolean;

{ This returns a value telling if there is a character waiting in the com
   buffer. }


PROCEDURE dump;

{ This function clears the com buffer }


PROCEDURE set_baud (baud:longint);

{ This function sets the com speed to that passed }


PROCEDURE setdtr(i:boolean);

{ This function sets the DTR pin to the status given }


PROCEDURE setrts(i:boolean);

{ This function sets the RTS pin to the status given }


FUNCTION carrierdetect:boolean;

{ This returns the status of the carrier detect lead from the modem }


IMPLEMENTATION



USES crt,bsedev,bsedos,os2def;



CONST

  BAUD_RATE : WORD =38400;
  COMM_BUFFER_SIZE =16384;

VAR
  head,                                               { index to the last char in buffer }
  tail         : INTEGER;                             { index to first char in buffer }
  buffer       : ARRAY [0..COMM_BUFFER_SIZE] OF CHAR; { incoming character buffer }
  PortHandle   : HFILE;                               { OS/2 file handle for COM port }
  RecvThreadID : TID;                                 { Thread ID of receive-character thread }

{
 * our receive-character thread; all it does is wait for a
 * character to come in on the com port.  when one does, it
 * suspends the current process with DosEnterCritSec() and
 * places the character in the buffer.
 *
 * Purists will note that using DosEnterCritSec() instead of
 * semaphores is not "clean" or "true" multi-threading, but I chose
 * this method because it gave the largest performance boost.
}

PROCEDURE async_isr (ulThreadArg:ULONG); CDECL;
VAR
  BytesRead : ULONG;                { num. bytes read from last DosRead() call }
  ch        : CHAR;                 { char read in from last DosRead() call }
  res       : APIRET;
BEGIN
  { endless loop }
  while true do
  begin
      { read character; this will block until a char is available }
      res:=DosRead (PortHandle, ch, 1, BytesRead);

      { if a character was actually read in... }
      if (BytesRead=1) then
      begin
          { suspend all other processing }
          DosEnterCritSec;

          { put char in buffer and adjust indices }
          buffer[head] := ch;
          inc(head);
          if (head = COMM_BUFFER_SIZE) then head := 0;

          { release suspended processes }
          DosExitCritSec;
      end;
   end;
END;



{ This function outputs one character to the com port }

PROCEDURE outcomch (ch: char);

VAR

  rc : APIRET;
  BytesWritten : ULONG;                { unless but required parameter }
BEGIN
  rc:=DosWrite (PortHandle, ch, 1, BytesWritten);
END;



{ return next char in receive buffer, or 0 for none available }

FUNCTION peek1char:char;
begin
  if head<>tail then peek1char:=buffer[tail]
  else peek1char:=#0;
end;



{ This function returns one character from the com port, or a zero if

 * no character is waiting }

FUNCTION get1char:char;
var
  { temp var to hold char for returning if one is available }
  c1 : char;
begin
  if (head <>tail) then
  begin
    c1 := buffer[tail];
    inc(tail);
    if (tail = COMM_BUFFER_SIZE) then tail := 0;
    get1char:=c1;
  end
  else get1char:=#0;
end;



{ This returns a value telling if there is a character waiting in the com
 * buffer.
 }

FUNCTION comhit:boolean;
begin
  comhit:=(head<>tail);
end;



{ This function clears the com buffer }
PROCEDURE dump;
begin
  head:=0;tail:=0;
end;



CONST
  ASYNC_EXTSETBAUDRATE = $43;



{ This function sets the com speed to that passed }

PROCEDURE set_baud (baud:longint);
var
  par : RECORD
          rate     : ULONG;
          fraction : UCHAR;
        END;

  res : APIRET;
begin
  {
   * OS/2 2.11+ standard COM drivers support up to 345600 bps !
   }

  par.rate:=baud;
  par.fraction:=0;
  if ((par.rate <= 345600) and (par.rate >= 10)) then
    res:=DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_EXTSETBAUDRATE,
                      par, sizeof (par), NIL, NIL, 0, NIL);
end;



{ This function sets the DTR pin to the status given }

PROCEDURE setdtr(i:boolean);
var
  ms   : MODEMSTATUS;
  data : UINT;
  res  : APIRET;
begin
  ms.fbModemOn:=0;ms.fbModemOff:=0;

  if i then ms.fbModemOn := DTR_ON
  else ms.fbModemOff := DTR_OFF;

  res:=DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETMODEMCTRL, ms,
                    sizeof (ms), NIL, data, sizeof (data), NIL);
end;


{ This function sets the RTS pin to the status given }

PROCEDURE setrts(i:boolean);
var
  ms    : MODEMSTATUS;
  data  : UINT;
  res   : APIRET;
begin
  ms.fbModemOn:=0;ms.fbModemOff:=0;
  if i then ms.fbModemOn := RTS_ON
  else ms.fbModemOff := RTS_OFF;

  res:=DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETMODEMCTRL, ms,
                    sizeof (ms), NIL, data, sizeof (data), NIL);
end;



{ This function initializes the com buffer, setting up the interrupt,
 * and com parameters }

FUNCTION initport (port_num:integer;
                   parity:parityt;
                   databits,stopbits:byte;
                   RTS_CTS,XON_XOFF:BOOLEAN):integer;
var
  rc            : APIRET;
  action        : ULONG;
  lctl          : LINECONTROL;
  dcb           : DCBINFO;
  portname      : Cstring;
begin
  { open com port }
  initport:=0;

  portname:= 'COM'+CHR(port_num + ORD('0'));

  if DosOpen (portname, PortHandle, action, 0, 0, 1, $42, NIL)<>0 then
  begin
    initport:=1;
    Exit;
  end;

  { set line }
  lctl.bParity := ord(parity);
  lctl.bDataBits := databits;
  if stopbits=1 then lctl.bStopBits := 0 else lctl.bStopBits:=2;
  lctl.fTransBreak := 0;
  if DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETLINECTRL,
                  lctl, sizeof (LINECONTROL), NIL, NIL, 0, NIL)<>0 then
  begin
    DosClose (PortHandle);
    initport:=2;
    exit;
  end;

  { set device control block info }
  dcb.usWriteTimeout := 0;
  dcb.usReadTimeout := 0;
  dcb.fbCtlHndShake := MODE_DTR_CONTROL;

  IF RTS_CTS THEN
  BEGIN
    dcb.fbFlowReplace := MODE_RTS_HANDSHAKE;
    dcb.fbCtlHndShake := dcb.fbCtlHndShake + MODE_CTS_HANDSHAKE;
  END
  ELSE dcb.fbFlowReplace := MODE_RTS_CONTROL;

  IF XON_XOFF THEN
    dcb.fbFlowReplace := dcb.fbFlowReplace + MODE_AUTO_RECEIVE + MODE_AUTO_TRANSMIT;

  dcb.fbTimeout := MODE_NO_WRITE_TIMEOUT + MODE_WAIT_READ_TIMEOUT;
  dcb.bErrorReplacementChar := 0;
  dcb.bBreakReplacementChar := 0;
  dcb.bXONChar := $11;
  dcb.bXOFFChar := $13;
  if DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_SETDCBINFO, dcb,
                  sizeof (DCBINFO), NIL, NIL, 0, NIL)<>0 then
  begin
    initport:=3;
    DosClose (PortHandle);
    exit;
  end;

  { indicate receive buffer is currently empty }

  head :=0; tail := 0;

  { spawn receive thread }
  if DosCreateThread (RecvThreadID, @async_isr, NIL, 0, 4096)<>0 then
  begin
    initport:=4;
    DosClose (PortHandle);
    exit
  end;

  setdtr(true);
end;



{ This function closes out the com port, removing the interrupt routine,

 * etc. }

PROCEDURE closeport;
begin
  { kill receive thread and wait for it to close }
  DosKillThread (RecvThreadID);

  DosWaitThread (RecvThreadID, DCWW_WAIT);

  { close COM port handle }
  DosClose (PortHandle);
end;



{ This returns the status of the carrier detect lead from the modem }
FUNCTION carrierdetect:boolean;
var
  instat : BYTE;
begin
  { if DosDevIOCtl() returns an error, return 0 }
  if DosDevIOCtl (PortHandle, IOCTL_ASYNC, ASYNC_GETMODEMINPUT,
                   NIL, 0, NIL, instat, sizeof (instat), NIL)<>0 then
  begin
    carrierdetect:=false;
    exit;
  end;

  { otherwise return carrier detect status }
  carrierdetect:=(instat and DCD_ON)<>0;
end;


end.


