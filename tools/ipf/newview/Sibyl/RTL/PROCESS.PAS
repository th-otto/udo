UNIT Process;

{**************************************************************************
 *                 General Unit for Speed-Pascal/2                        *
 *                                                                        *
 *                                                                        *
 * Copyright (C) 1995..96 SpeedSoft                                       *
 *                                                                        *
 * Basic objects for process and thread handling                          *
 *                                                                        *
 **************************************************************************}


INTERFACE

USES Os2Def,BseDos,Dos;

TYPE
     PProcess=^TProcess;
     TProcess=OBJECT
                   TheExeName:STRING;
                   TheParams:STRING;
                   TheProcessID:ULONG;
                   TheProcessPID:PID;
                   TheStartData:STARTDATA;
                   ObjBuf:STRING;
                   CONSTRUCTOR Init(ExeName,Params:STRING);
                   FUNCTION Run:LONGWORD;
                   DESTRUCTOR Done;
              END;

     PThread=^TThread;
     TThread=OBJECT
                   TheThreadProc:PROCEDURE(Param:POINTER);
                   TheThreadData:POINTER;
                   TheStackSize:ULONG;
                   TheThreadTID:TID;
                   Suspended:BOOLEAN;
                   CONSTRUCTOR Init(ThreadProc,ThreadData:POINTER;
                                    ThreadStack:ULONG);
                   PROCEDURE Run;
                   PROCEDURE Kill;
                   PROCEDURE Suspend;
                   PROCEDURE Resume;
                   PROCEDURE ThreadProc;
                   PROCEDURE SetPriority(aClass,Delta:ULONG);
                   FUNCTION HasEnded:BOOLEAN;
                   DESTRUCTOR Done;
             END;


IMPLEMENTATION

{***************************************************************************
 *                                                                         *
 *                                                                         *
 *     Object TProcess                                                     *
 *                                                                         *
 ***************************************************************************}


CONSTRUCTOR TProcess.Init(ExeName,Params:STRING);
VAR s:STRING;
    rc:ULONG;
    AppType:ULONG;
BEGIN
     IF pos('\',ExeName)=0 THEN
     BEGIN
          GetDir(0,s);
          IF s[length(s)]='\' THEN dec(s[0]);
          ExeName:=s+'\'+ExeName;
     END;
     IF Pos('.',ExeName)=0 THEN ExeName:=ExeName+'.EXE';

     TheExeName:=ExeName;
     TheParams:=params;

     TheStartData.Length:=sizeof(STARTDATA);
     TheStartData.Related:=SSF_RELATED_CHILD;
     TheStartData.FgBg:=SSF_FGBG_BACK;
     TheStartData.TraceOpt:=SSF_TRACEOPT_NONE;
     TheStartData.PgmTitle:=@TheExeName;
     TheStartData.PgmName:=@TheExeName;
     TheStartData.PgmInputs:=@TheParams;
     TheStartData.TermQ:=NIL;
     TheStartData.Environment:=NIL;
     TheStartData.InheritOpt:=SSF_INHERTOPT_SHELL;

     rc:=DosQueryAppType(ExeName,AppType);

     IF rc<>0 THEN TheStartData.SessionType:=SSF_TYPE_DEFAULT
     ELSE
     BEGIN
          IF ((AppType AND 32=32)OR(AppType=3)) THEN {DOS}
             TheStartData.SessionType:=SSF_TYPE_VDM
          ELSE TheStartData.SessionType:=SSF_TYPE_DEFAULT;
     END;

     TheStartData.IconFile:=NIL;
     TheStartData.PgmHandle:=0;
     TheStartData.PgmControl:=SSF_CONTROL_VISIBLE;
     TheStartData.InitXPos:=30;
     TheStartData.InitYPos:=40;
     TheStartData.InitXSize:=200;
     TheStartData.InitYSize:=140;
     TheStartData.Reserved:=0;
     TheStartData.ObjectBuffer:=@ObjBuf;
     TheStartData.ObjectBuffLen:=256;

     TheProcessID:=0;
     TheProcessPID:=0;
END;

FUNCTION TProcess.Run:LONGWORD;
BEGIN
     Run:=DosStartSession(TheStartData,TheProcessId,TheProcessPID);
END;

DESTRUCTOR TProcess.Done;
BEGIN
END;

{***************************************************************************
 *                                                                         *
 *                                                                         *
 *     Object TThread                                                      *
 *                                                                         *
 ***************************************************************************}


CONSTRUCTOR TThread.Init(ThreadProc,ThreadData:POINTER;ThreadStack:ULONG);
BEGIN
     TheThreadProc:=ThreadProc;
     TheThreadData:=ThreadData;
     IF ThreadStack<16384 THEN ThreadStack:=16384;
     TheStackSize:=ThreadStack;
     TheThreadTID:=0;
     Suspended:=FALSE;
END;

PROCEDURE TThread.ThreadProc;CDECL;
VAR p:PROCEDURE(Param:POINTER);
BEGIN
     p:=TheThreadProc;
     p(TheThreadData);
     {Clear TID if Thread resumed}
     TheThreadTID:=0;
END;

PROCEDURE TThread.Run;
BEGIN
     DosCreateThread(TheThreadTID,@ThreadProc,POINTER(SELF),
                     STACK_COMMITTED,TheStackSize);
END;

PROCEDURE TThread.Kill;
VAR r:ULONG;
LABEL l;
BEGIN
     IF TheThreadTID<>0 THEN
     BEGIN
l:
          r:=DosKillThread(TheThreadTID);
          IF r=170 THEN  {Thread busy}
          BEGIN
               DosSleep(50);
               goto l;
          END;
     END;
     TheThreadTID:=0;
END;

PROCEDURE TThread.Suspend;
BEGIN
     IF TheThreadTID<>0 THEN IF not Suspended THEN
     BEGIN
          DosSuspendThread(TheThreadTID);
          Suspended:=TRUE;
     END;
END;

PROCEDURE TThread.Resume;
BEGIN
     IF TheThreadTID<>0 THEN IF Suspended THEN
     BEGIN
          DosResumeThread(TheThreadTID);
          Suspended:=FALSE;
     END;
END;

PROCEDURE TThread.SetPriority(aClass,Delta:ULONG);
BEGIN
     IF TheThreadTID<>0 THEN
       DosSetPriority(PRTYS_THREAD,aClass,Delta,TheThreadTID);
END;

FUNCTION TThread.HasEnded:BOOLEAN;
BEGIN
     HasEnded:=TheThreadTID=0;
END;

DESTRUCTOR TThread.Done;
BEGIN
     Kill;
END;

BEGIN
END.