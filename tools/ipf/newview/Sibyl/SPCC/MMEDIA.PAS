
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (c) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit MMedia;


Interface

{$r MMedia}

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmBitmap;
{$ENDIF}
{$IFDEF Win95}
Uses WinDef,WinBase,WinUser,MMSystem;
{$ENDIF}

Uses SysUtils,Messages,Classes,Forms,Graphics,StdCtrls,Dialogs,Buttons;


Type
    {$M+}
    TMCIStatus=(mciPaused,mciPlaying,mciRewind,mciStopped,mciRecording,
                mciNothing,mciError);

    TMCIDeviceMode=(dmNotReady,dmStopped,dmPlaying,dmSeeking,dmRecording,
                    dmPaused,dmOther,dmUnknown);

    TMCINotifyEvents=(mciNotifySuperseded,mciNotifyAborted,mciNotifySuccess,
                      mciNotifyError,mciNotifyPositionChange,mciNotifyCuePoint);

    TChannel=(chLeft,chRight,chBoth);

    TTimeFormat=(tfMilliseconds,tfMMTime,tfMSF,tfTMSF,tfFrames,tfHMS,tfHMSF,tfBytes,tfSamples,
                 tfSMPTE24,tfSMPTE25,tfSMPTE30,tfSP,tfUnknown);
    TTimeFormats=Set Of TTimeFormat;
    {$M-}

    TTimeInfo=Record
         Case Format:TTimeFormat Of
           tfMilliSeconds:(MilliSeconds:LONGWORD);
           tfMMTime:(MMTime:LONGWORD);
           tfMSF:(msf_Minutes,msf_Seconds,msf_Frames,msf_Reserved:BYTE);
           tfTMSF:(tmsf_Track,tmsf_Minutes,tmsf_Seconds,tmsf_Frames:BYTE);
           tfFrames:(Frames:LONGWORD);
           tfHMS:(hms_Hours,hms_Minutes,hms_Seconds,hms_reserved:BYTE);
           tfHMSF:(hmsf_Hours,hmsf_Minutes,hmsf_Seconds,hmsf_Frames:BYTE);
           tfBytes:(Bytes:LONGWORD);
           tfSamples:(Samples:LONGWORD);
           tfSMPTE24:(SMPTE24:LONGWORD);
           tfSMPTE25:(SMPTE25:LONGWORD);
           tfSMPTE30:(SMPTE30:LONGWORD);
           tfSP:(SongPointer:LONGWORD);
           tfUnknown:(Unknown:LONGWORD);
    End;

    {$M+}
    TMCIPositionChanged=Procedure(Sender:TObject;Const NewPosition:TTimeInfo) Of Object;
    TMCICuePointReached=Procedure(Sender:TObject;Const NewPosition:TTimeInfo;CuEPOintid:LONGWORD) Of Object;
    {$M-}


    TCueTypes=(cuOutput,cuInput);

    TMCIDevice=Class(TComponent)
      Private
         FDeviceOpen:BOOLEAN;
         FAliasName:PSTRING;
         FDeviceName:PSTRING;
         FStatus:TMCIStatus;
         FNotifyControl:TControl;
         FFileLoaded:BOOLEAN;
         FFileName:PString;
         FFileNameRequired:BOOLEAN;
         FLastMCIReturn:String;
         FTimeFormatsAvailable:TTimeFormats;
         FTimeFormat:TTimeFormat;
         FDefaultTimeFormat:TTimeFormat;
         FPositionAdvise:BOOLEAN;
         FPositionAdviseUnits:TTimeInfo;
         FCuePointCount:WORD;
         FOnPlayingCompleted:TNotifyEvent;
         FOnPlayingAborted:TNotifyEvent;
         FOnPositionChanged:TMCIPositionChanged;
         FOnCuePointReached:TMCICuePointReached;
      Private
         Procedure ShowMCIError(Code:LONGWORD);
         Procedure SetDeviceName(NewName:String);
         Function GetDeviceName:String;
         Procedure SetAliasName(NewName:String);
         Function GetAliasName:String;
         Procedure SetTimeFormat(NewFormat:TTimeFormat);
         Function TimeInfoStr(TimeInfo:TTimeInfo;SaveTime:TTimeFormat):String;

         Function GetMCIStatusNumber(Const option:String):LONGINT;
         Function GetMCIStatusBoolean(Const option:String):BOOLEAN;
         Function GetMCICapBoolean(Const Option:String):BOOLEAN;
         Function GetMCICapLong(Const Option:String):LONGWORD;
         Function GetMCITimeInfo(Const option:String):TTimeInfo;

         Function GetChannels:LONGINT;
         Function GetVolume(Channel:TChannel):LONGINT;
         Procedure SetVolume(Channel:TChannel;NewVolume:LONGINT);
         Function GetCurrentTrack:LONGINT;
         Function GetTrackLength(Track:LONGINT):TTimeInfo;
         Function GetTracks:LONGINT;
         Function GetMediaPresent:BOOLEAN;
         Function GetDeviceReady:BOOLEAN;
         Function GetPosition:TTimeInfo;
         Function GetLength:TTimeInfo;
         Function GetDeviceMode:TMCIDeviceMode;
         Function GetDeviceId:LONGWORD;
         Procedure SetPositionAdvise(NewValue:BOOLEAN);
         Procedure SetPositionAdviseUnits(NewUnits:TTimeInfo);
         Procedure SetFileName(Const NewValue:String);
         Function GetFileName:String;
         Function GetCanEject:BOOLEAN;
         Function GetCanPlay:BOOLEAN;
         Function GetCanRecord:BOOLEAN;
         Function GetCanSave:BOOLEAN;
         Function GetCanLockEject:BOOLEAN;
         Function GetCanSetVolume:BOOLEAN;
         Function GetHasAudio:BOOLEAN;
         Function GetHasVideo:BOOLEAN;
         Function GetUsesFiles:BOOLEAN;
      Protected
         Procedure SetupComponent;Override;
         Procedure HandleMCIError(Const ErrorStr:String);Virtual;
         Procedure MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUsErCode:LONGWORD);Virtual;
         Procedure PositionChanged(Const NewPosition:TTimeInfo);Virtual;
         Procedure CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);Virtual;
         Procedure PlayingCompleted;Virtual;
         Procedure PlayingAborted;Virtual;
      Protected
         Property FileNameRequired:BOOLEAN read FFileNameRequired write FFileNameRequired;
      Public
         Procedure GetDefaultFileMask(Var Ext,Description:String);Virtual;
         Procedure Load;Virtual;
         Procedure Play;Virtual;
         Procedure Pause;Virtual;
         Procedure Stop;Virtual;
         Procedure Resume;Virtual;
         Procedure StartRecording;Virtual;
         Procedure SeekToStart;Virtual;
         Procedure SeekToEnd;Virtual;
         Procedure Seek(NewPos:TTimeInfo);Virtual;
         Procedure OpenDevice;Virtual;
         Procedure CloseDevice;Virtual;
         Procedure NextTrack;Virtual;
         Procedure PreviousTrack;Virtual;
         Destructor Destroy;Override;
         Function AddCuePoint(Const CuePoint:TTimeInfo):LONGWORD;
         Function DeleteCuePoint(Const CuePoint:TTimeInfo):BOOLEAN;
         Function SendString(Const s:String;usUserParm:WORD):BOOLEAN;Virtual;
         Function WriteSCUResource(Stream:TResourceStream):BOOLEAN;Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LOngint);Override;
         Function Cue(CueFor:TCueTypes):BOOLEAN;
         Procedure Cut(StartPos,EndPos:TTimeInfo);
         Procedure Copy(StartPos,EndPos:TTimeInfo);
         Procedure Paste(StartPos,EndPos:TTimeInfo);
      Public
         Property Status:TMCIStatus read FStatus;
         Property Channels:LONGINT read GetChannels;
         Property Volume[Channel:TChannel]:LONGINT read GetVolume write SetVolume;
         Property CurrentTrack:LONGINT read GetCurrentTrack;
         Property TrackLength[Track:LONGINT]:TTimeInfo read GetTrackLength;
         Property Tracks:LONGINT read GetTracks;
         Property MediaPresent:BOOLEAN read GetMediaPresent;
         Property DeviceReady:BOOLEAN read GetDeviceReady;
         Property Position:TTimeInfo read GetPosition write Seek;
         Property Length:TTimeInfo read GetLength;
         Property DeviceMode:TMCIDeviceMode read GetDeviceMode;
         Property DeviceId:LONGWORD read GetDeviceId;
         Property PositionAdviseUnits:TTimeInfo read FPositionAdviseUnits write SeTpositiOnadviseUNits;
         Property LastMCIReturn:String read FLastMCIReturn;
         Property PositionAdvise:BOOLEAN read FPositionAdvise write SetPositionAdvIse;
         Property TimeFormatsAvailable:TTimeFormats read FTimeFormatsAvailable;
         Property DefaultTimeFormat:TTimeFormat read FDefaultTimeFormat;
         Property DeviceOpen:BOOLEAN read FDeviceOpen;
         Property CanEject:BOOLEAN read GetCanEject;
         Property CanPlay:BOOLEAN read GetCanPlay;
         Property CanRecord:BOOLEAN read GetCanRecord;
         Property CanSave:BOOLEAN read GetCanSave;
         Property CanLockEject:BOOLEAN read GetCanLockEject;
         Property CanSetVolume:BOOLEAN read GetCanSetVolume;
         Property HasAudio:BOOLEAN read GetHasAudio;
         Property HasVideo:BOOLEAN read GetHasVideo;
         Property UsesFiles:BOOLEAN read GetUsesFiles;
      Published
         Property OnPlayingAborted:TNotifyEvent read FOnPlayingAborted write FOnPlAyinGAbOrted;
         Property OnPlayingCompleted:TNotifyEvent read FOnPlayingCompleted write FOnplAyiNgcompLetEd;
         Property OnPositionChanged:TMCIPositionChanged read FOnPositionChanged wrIte FOnPositiOnCHanGed;
         Property OnCuePointReached:TMCICuePointReached read FOnCuePointReached wrIte FOnCuepoiNtREacHed;
         Property FileName:String read GetFileName write SetFileName;
         Property DeviceName:String read GetDeviceName write SetDeviceName;
         Property AliasName:String read GetAliasName write SetAliasName;
         Property TimeFormat:TTimeFormat read FTimeFormat write SetTimeFormat;
    End;

    TVideoDeviceCapabilities=Record
         CanDistort:BOOLEAN;
         CanProcessInternal:BOOLEAN;
         CanRecordInsert:BOOLEAN;
         CanStream:BOOLEAN;
         CanStretch:BOOLEAN;
         FastPlayRate:LONGWORD;
         HasTuner:BOOLEAN;
         HorizontalVideoExtent:LONGWORD;
         HorizontalImageExtent:LONGWORD;
         NormalPlayRate:LONGWORD;
         SlowPlayRate:LONGWORD;
         VerticalImageExtent:LONGWORD;
         VerticalVideoExtent:LONGWORD;
    End;


    TVideoDevice=Class(TMCIDevice)
      Private
         FVideoWindow:TControl;
      Private
         Function GetCapabilities:TVideoDeviceCapabilities;
         Function GetBitsPerSample:LONGINT;
         Function GetImageBitsPerPel:LONGINT;
         Function GetImagePelFormat:String;
         Function GetBrightness:LONGINT;
         Function GetContrast:LONGINT;
         Function GetHue:LONGINT;
         Function GetClipBoardDataAvail:BOOLEAN;
         Function GetSaturation:LONGINT;
         Function GetSamplesPerSec:LONGINT;
         Function GetTunerTVChannel:LONGINT;
         Function GetTunerFineTune:LONGINT;
         Function GetTunerFrequency:LONGINT;
         Function GetValidSignal:BOOLEAN;
         Procedure SetBrightness(NewValue:LONGINT);
         Procedure SetContrast(NewValue:LONGINT);
         Procedure SetHue(NewValue:LONGINT);
         Procedure SetSaturation(NewValue:LONGINT);
         Procedure SetSamplesPerSec(NewValue:LONGINT);
         Procedure SetTunerTVChannel(NewValue:LONGINT);
         Procedure SetTunerFineTune(NewValue:LONGINT);
         Procedure SetTunerFrequency(NewValue:LONGINT);
      Private
         Property DeviceName;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetDefaultFileMask(Var Ext,Description:String);Override;
      Public
         Procedure Seek(NewPos:TTimeInfo);Override;
         Procedure SeekToStart;Override;
         Procedure Load;Override;
         Property Capabilities:TVideoDeviceCapabilities read GetCapabilities;
         Property BitsPerSample:LONGINT read GetBitsPerSample;
         Property ImageBitsPerPel:LONGINT read GetImageBitsPerPel;
         Property ImagePelFormat:String read GetImagePelFormat;
         Property Brightness:LONGINT read GetBrightness write SetBrightness;
         Property Contrast:LONGINT read GetContrast write SetContrast;
         Property Hue:LONGINT read GetHue write SetHue;
         Property ClipBoardDataAvail:BOOLEAN read GetClipBoardDataAvail;
         Property Saturation:LONGINT read GetSaturation write SetSaturation;
         Property SamplesPerSec:LONGINT read GetSamplesPerSec write SetSamplesPerSEc;
         Property TunerTVChannel:LONGINT read GetTunerTVChannel write SetTunerTVChAnneL;
         Property TunerFineTune:LONGINT read GetTunerFineTune write SetTunerFineTuNe;
         Property TunerFrequency:LONGINT read GetTunerFrequency write SetTunerFreqUencY;
         Property ValidSignal:BOOLEAN read GetValidSignal;
      Public
         Property AliasName;
    End;

    TAudioDevice=Class(TMCIDevice)
      Private
         Function GetAlignment:LONGINT;
         Function GetBitsPerSample:LONGINT;
         Function GetBytesPerSec:LONGINT;
         Function GetSamplesPerSec:LONGINT;
         Procedure SetBitsPerSample(NewValue:LONGINT);
         Procedure SetBytesPerSec(NewValue:LONGINT);
         Procedure SetSamplesPerSec(NewValue:LONGINT);
      Private
         Property DeviceName;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetDefaultFileMask(Var Ext,Description:String);Override;
      Public
         Property Alignment:LONGINT read GetAlignment;
         Property BitsPerSample:LONGINT read GetBitsPerSample write SetBitsPerSampLe;
         Property BytesPerSec:LONGINT read GetBytesPerSec write SetBytesPerSec;
         Property SamplesPerSec:LONGINT read GetSamplesPerSec write SetSamplesPerSEc;
      Public
         Property AliasName;
    End;


    TCDMediaTypes=(mtAudio,mtData,mtOther,mtUnknown);

    TCDDeviceCapabilities=Record
         CanProcessInternal:BOOLEAN;
         CanStream:BOOLEAN;
    End;

    TCDDevice=Class(TMCIDevice)
      Private
         Function GetTrackChannels(Track:LONGINT):LONGINT;
         Function GetTrackPosition(Track:LONGINT):TTimeInfo;
         Function GetPositionInTrack:TTimeInfo;
         Function GetStartPosition:TTimeInfo;
         Function GetMediaType:TCDMediaTypes;
         Function GetTrackType(Track:LONGINT):TCDMediaTypes;
         Function GetCapabilities:TCDDeviceCapabilities;
      Private
         Property DeviceName;
         Property FileName;
      Protected
         Procedure SetupComponent;Override;
      Public
         Procedure Eject;Virtual;
         Procedure Close;Virtual;
         Procedure LockDoor;Virtual;
         Procedure UnlockDoor;Virtual;
         Procedure NextTrack;Override;
         Procedure PreviousTrack;Override;
      Public
         Property TrackChannels[Track:LONGINT]:LONGINT read GetTrackChannels;
         Property TrackPosition[Track:LONGINT]:TTimeInfo read GetTrackPosition;
         Property PositionInTrack:TTimeInfo read GetPositionInTrack;
         Property StartPosition:TTimeInfo read GetStartPosition;
         Property MediaType:TCDMediaTypes read GetMediaType;
         Property TrackType[Track:LONGINT]:TCDMediaTypes read GetTrackType;
         Property Capabilities:TCDDeviceCapabilities read GetCapabilities;
         Property AliasName;
    End;


    TVideoWindow=Class(TControl)
      Private
         FVideoDevice:TVideoDevice;
         hwndFrame:HWND;
         ulMovieWidth,ulMovieHeight,ulMovieLength:LONGWORD;
         FOnPlayingCompleted:TNotifyEvent;
         FOnPlayingAborted:TNotifyEvent;
         FOnPositionChanged:TMCIPositionChanged;
         FOnCuePointReached:TMCICuePointReached;
      Private
         Function DoesFileExist(pszFileName:String):BOOLEAN;
         Procedure SetVideoDevice(NewDevice:TVideoDevice);
      Protected
         Procedure SetupComponent;Override;
         Procedure PositionChanged(Const NewPosition:TTimeInfo);Virtual;
         Procedure CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);Virtual;
         Procedure PlayingCompleted;Virtual;
         Procedure PlayingAborted;Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUsErcode:LoNGword);Virtual;
      Public
         Procedure Redraw(Const rc:TRect);Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentShowHint;
         Property ShowHint;
         Property VideoDevice:TVideoDevice read FVideoDevice write SetVideoDeviCe;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnCuePointReached:TMCICuePointReached read FOnCuePointReached wrIte FonCuepoinTreached;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnPlayingAborted:TNotifyEvent read FOnPlayingAborted write FONplAyinGabOrted;
         Property OnPlayingCompleted:TNotifyEvent read FOnPlayingCompleted writE FOnPlAyiNgcomplEted;
         Property OnPositionChanged:TMCIPositionChanged read FOnPositionChanged wrIte FonPositioNchanGed;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

    TVolumeControl=Class(TControl)
      Private
         FPosition:BYTE;
         FTimerEndPos:LONGINT;
         FAngleTimer:TTimer;
         FHasCapture:BOOLEAN;
         FOnPositionChanged:TNotifyEvent;
         Procedure DrawSlider;
         Procedure DrawBoxes;
         Procedure SetPosition(NewPosition:BYTE);
         Procedure GetCircleParams(Var MiddleX,MiddleY,CircleRadius:LONGINT);
         Function InsideCircle(MiddleX,MiddleY,Radius:LONGINT;Const pt:TPoint;Var AnglE:LOnginT):BooLEaN;
         Procedure EvTimer(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGiNT);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGINt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LONGINT);Override;
         Procedure PositionChanged;Virtual;
         Property Cursor;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Destructor Destroy;Override;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentShowHint;
         Property Position:BYTE read FPosition write SetPosition;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnPositionChanged:TNotifyEvent read FOnPositionChanged write FonPOsitionchAnged;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

    {$M+}
    TMPBtnType=(btPlay, btPause, btStop, btNext, btPrev, btStep, btBack,
                btRecord, btEject, btRewind);
    TMPButtonSet=Set Of TMPBtnType;

    EMPNotify=Procedure(Sender:TObject;Button:TMPBtnType;Var DoDefault:BOOLEAN) of Object;

    TMPDeviceTypes=(dtAutoSelect,dtAVIVideo,dtCDAudio,dtDAT,dtDigitalVideo,
                    dtMMMovie,dtOther,dtOverlay,dtScanner,dtSequencer,
                    dtVCR,dtVideoDisc,dtWaveAudio);
    {$M-}

    TMediaPlayer=Class(TControl)
      Private
         FButtons:Array[TMPBtnType] Of TBitBtn;
         FFrames:LONGINT;
         FPlayButton:TAnimatedButton;
         FRecordButton:TAnimatedButton;
         FVisibleButtons:TMPButtonSet;
         FEnabledButtons:TMPButtonSet;
         FFileName:PString;
         FUseAnimation:BOOLEAN;
         FMCIDevice:TMCIDevice;
         FOpened:BOOLEAN;
         FOnClick:EMPNotify;
         FOnPlayingCompleted:TNotifyEvent;
         FOnPlayingAborted:TNotifyEvent;
         FOnPositionChanged:TMCIPositionChanged;
         FOnCuePointReached:TMCICuePointReached;
         FDestroyMCIDev:BOOLEAN;
         FDeviceType:TMPDeviceTypes;
         Procedure SetVisibleButtons(NewState:TMPButtonSet);
         Procedure SetEnabledButtons(NewState:TMPButtonSet);
         Function GetFileName:String;
         Procedure SetFileName(NewName:String);
         Procedure SetMCIDevice(NewDevice:TMCIDevice);
         Function GetButton(Index:TMPBtnType):TBitBtn;
         Procedure EvButtonClick(Sender:TObject);
         Procedure SetDeviceType(NewValue:TMPDeviceTypes);
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure RealignControls;Override;
         Procedure PositionChanged(Const NewPosition:TTimeInfo);Virtual;
         Procedure CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);Virtual;
         Procedure PlayingAborted;Virtual;
         Procedure PlayingCompleted;Virtual;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUsErcode:LoNGWORD);Virtual;
         Property Buttons[Index:TMPBtnType]:TBitBtn read GetButton;
         Property Hint;
         Property Cursor;
      Public
         Destructor Destroy;Override;
         Procedure Open;Virtual;
         Procedure Play;Virtual;
         Procedure StartRecording;Virtual;
         Procedure Stop;Virtual;
         Procedure Pause;Virtual;
         Procedure Close;Virtual;
         Procedure Rewind;Virtual;
         Procedure Next;Virtual;
         Procedure Previous;Virtual;
         Procedure Step;Virtual;
         Procedure Back;Virtual;
         Procedure Eject;Virtual;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property DeviceType:TMPDeviceTypes read FDeviceType write SetDeviceTypE;
         Property EnabledButtons:TMPButtonSet read FEnabledButtons write SetEnaBlEdbutTons;
         Property FileName:String read GetFileName write SetFileName;
         Property Frames:LONGINT read FFrames write FFrames;
         Property MCIDevice:TMCIDevice read FMCIDevice write SetMCIDevice;
         Property ParentShowHint;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property UseAnimation:BOOLEAN read FUseAnimation write FUseAnimation;
         Property Visible;
         Property VisibleButtons:TMPButtonSet read FVisibleButtons write SetVisIbLebutTons;
         Property ZOrder;

         Property OnCanDrag;
         Property OnClick:EMPNotify read FOnClick write FOnClick;
         Property OnCuePointReached:TMCICuePointReached read FOnCuePointReached wRite FonCuePoinTreached;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnPlayingAborted:TNotifyEvent read FOnPlayingAborted write FONPLayinGabortEd;
         Property OnPlayingCompleted:TNotifyEvent  read FOnPlayingCompleted wriTe fonPLayingCompLeted;
         Property OnPositionChanged:TMCIPositionChanged read FOnPositionChanged wRite FonPosItioNchangEd;
         Property OnResize;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


Function TimeFormatToString(tf:TTimeFormat):String;
Function DeviceModeToString(dm:TMCIDeviceMode):String;
Function MediaTypeToString(mt:TCDMediaTypes):String;
Function ConvertTimeInfo(Var TimeInfo:TTimeInfo;NewFormat:TTimeFormat):BOOLEAN;
Function CompareTimeInfos(TimeInfo1,TimeInfo2:TTimeInfo):LONGINT;
Function TimeInfoToString(Const TimeInfo:TTimeInfo):String;

Implementation

Type
    TMCINotifyControl=Class(TControl)
      Private
         FDevice:TMCIDevice;
         {$IFDEF WIN95}
         Procedure MMMCINotify(Var Msg:TMessage); Message $3B9; {MM_MCINOTIFY;}
         {PROCEDURE MMMCIPositionChange(VAR Msg:TMessage); message MM_MCIPOSITIONCHANGE; ???
         Procedure MMMCICuePoint(Var Msg:TMessage); Message MM_MCICUEPOINT; ???}
         {$ENDIF}
         {$IFDEF OS2}
         Procedure MMMCINotify(Var Msg:TMessage); Message $0500; {MM_MCINOTIFY;}
         Procedure MMMCIPositionChange(Var Msg:TMessage); Message $0502; {MM_MCIPOSITIONCHANGE;}
         Procedure MMMCICuePoint(Var Msg:TMessage); Message $0503; {MM_MCICUEPOINT;}
         {$ENDIF}
         Procedure CreateWnd;Override;
      Protected
         Procedure SetupComponent;Override;
    End;


Procedure TMCINotifyControl.CreateWnd; //dummy
Begin
    Inherited CreateWnd;
End;

Procedure TMCINotifyControl.SetupComponent;
Begin
     Inherited SetupComponent;
     Include (ComponentState, csDetail);
End;

Procedure TMCINotifyControl.MMMCINotify(Var Msg:TMessage);
Var usNotifyCode,usCommandMessage:WORD;
    Event:TMCINotifyEvents;
    usDeviceId:WORD;
    usUserCode:WORD;
{$IFDEF Win95}
Const
     MCI_NOTIFY_SUCCESSFUL  =$0001;
     MCI_NOTIFY_SUPERSEDED  =$0002;
     MCI_NOTIFY_ABORTED     =$0004;
{$ENDIF}
{$IFDEF OS2}
Const
      MCI_NOTIFY_SUCCESSFUL =$0000;
      MCI_NOTIFY_SUPERSEDED =$0001;
      MCI_NOTIFY_ABORTED    =$0002;
{$ENDIF}
Begin
     {$IFDEF OS2}
     usNotifyCode:=Msg.Param1Lo;
     usCommandMessage:=Msg.Param2Hi;
     usDeviceId:=Msg.Param2Lo;
     usUserCode:=Msg.Param1Hi;

     Case usNotifyCode Of
        MCI_NOTIFY_SUPERSEDED:Event:=mciNotifySuperseded;
        MCI_NOTIFY_ABORTED:Event:=mciNotifyAborted;
        MCI_NOTIFY_SUCCESSFUL:Event:=mciNotifySuccess;
        Else Event:=mciNotifyError;
     End; {case}
     {$ENDIF}
     {$IFDEF Win95}
     usNotifyCode:=0; {??}
     usDeviceId:=0;   {??}
     usUserCode:=0;   {??}

     Case Msg.Param1 Of
         MCI_NOTIFY_SUPERSEDED:Event:=mciNotifySuperseded;
         MCI_NOTIFY_ABORTED:Event:=mciNotifyAborted;
         MCI_NOTIFY_SUCCESSFUL:Event:=mciNotifySuccess;
         Else Event:=mciNotifyError;
     End; {case}
     {$ENDIF}
     FDevice.MCIEvent(Event,usDeviceid,usNotifyCode,usUserCode);
     Msg.Handled:=TRUE;
     Msg.Result:=0;
End;


{$IFDEF OS2}
Procedure TMCINotifyControl.MMMCIPositionChange(Var Msg:TMessage);
Var usDeviceId:WORD;
    usUserCode:WORD;
    ulmmTime:LONGWORD;
Begin
     {$IFDEF OS2}
     usDeviceId:=Msg.Param1Hi;
     usUserCode:=Msg.Param1Lo;
     ulmmTime:=Msg.Param2;
     {$ENDIF}
     {$IFDEF Win95}
     ???
     {$ENDIF}
     FDevice.MCIEvent(mciNotifyPositionChange,usDeviceid,ulmmTime,usUserCode);
     Msg.Handled:=TRUE;
     Msg.Result:=0;
End;


Procedure TMCINotifyControl.MMMCICuePoint(Var Msg:TMessage);
Var usDeviceId:WORD;
    ulmmTime:LONGWORD;
    usUserCode:WORD;
Begin
     {$IFDEF OS2}
     usDeviceId:=Msg.Param1Hi;
     ulmmTime:=Msg.Param2;
     usUserCode:=Msg.Param1Lo;
     {$ENDIF}
     {$IFDEF Win95}
     ???
     {$ENDIF}
     FDevice.MCIEvent(mciNotifyCuePoint,usDeviceid,ulmmTime,usUserCode);
     Msg.Handled:=TRUE;
     Msg.Result:=0;
End;
{$ENDIF}


{$IFDEF OS2}
Const
    MCIERR_SUCCESS=0;

Type
    PMMTRACKINFO=^MMTRACKINFO;
    MMTRACKINFO=Record
                      ulTrackID:LONGWORD;
                      ulMediaType:LONGWORD;
                      ulCountry:LONGWORD;
                      ulCodePage:LONGWORD;
                      ulReserved1:LONGWORD;
                      ulReserved2:LONGWORD;
    End;


    PMMMOVIEHEADER=^MMMOVIEHEADER;
    MMMOVIEHEADER=Record
                        ulStructLen:LONGWORD;
                        ulContentType:LONGWORD;
                        ulMediaType:LONGWORD;
                        ulMovieCapsFlags:LONGWORD;
                        ulMaxBytesPerSec:LONGWORD;
                        ulPaddingGranularity:LONGWORD;
                        ulSuggestedBufferSize:LONGWORD;
                        ulStart:LONGWORD;
                        ulLength:LONGWORD;
                        ulNextTrackID:LONGWORD;
                        ulNumEntries:LONGWORD;
                        pmmTrackInfoList:PMMTRACKINFO;
                        pszMovieTitle:PChar;
                        ulCountry:LONGWORD;
                        ulCodePage:LONGWORD;
                        ulAvgBytesPerSec:LONGWORD;
   End;

   PMMTIME=^MMTIME;
   MMTIME=LONGWORD;

   PGENPAL=^GENPAL;
   GENPAL=Record
                ulStartIndex:ULONG;
                ulNumColors:ULONG;
                prgb2Entries:PRGB2;
   End;

   XDIBHDR_PREFIX=Record
                         ulMemSize:LONGWORD;
                         ulPelFormat:LONGWORD;
                         usTransType:WORD;
                         ulTransVal:LONGWORD;
    End;

    PMMXDIBHEADER=^MMXDIBHEADER;
    MMXDIBHEADER=Record
                       XDIBHeaderPrefix:XDIBHDR_PREFIX;
                       BMPInfoHeader2:BITMAPINFOHEADER2;
    End;

   PMMVIDEOHEADER=^MMVIDEOHEADER;
   MMVIDEOHEADER=Record
                        ulStructLen:LONGWORD;
                        ulContentType:LONGWORD;
                        ulMediaType:LONGWORD;
                        ulVideoCapsFlags:LONGWORD;
                        ulWidth:LONGWORD;
                        ulHeight:LONGWORD;
                        ulScale:LONGWORD;
                        ulRate:LONGWORD;
                        ulStart:LONGWORD;
                        ulLength:LONGWORD;
                        ulTotalFrames:LONGWORD;
                        ulInitialFrames:LONGWORD;
                        mmtimePerFrame:MMTIME;
                        ulSuggestedBufferSize:LONGWORD;
                        genpalVideo:GENPAL;
                        pmmXDIBHeader:PMMXDIBHEADER;
    End;

Const
      CODEC_INFO_SIZE    =8;
      CODEC_HW_NAME_SIZE =32;
      DLLNAME_SIZE       =CCHMAXPATH;
      PROCNAME_SIZE      =32;
      MAX_EXTENSION_NAME =4;
      MMIO_SUCCESS                   = 0;
      MMIO_WARNING                   = 2;
      MMIO_ERROR                     =-1;
      MMIOERR_UNSUPPORTED_MESSAGE    =-2;
      MMIO_TRANSLATEHEADER     =$00000002; /* Translation */
      MMIO_TRACK                =$00000001;
      MMIO_NORMAL_READ          =$00000002;
      MMIO_SCAN_READ            =$00000004;
      MMIO_REVERSE_READ         =$00000008;
      MMIO_CODEC_ASSOC          =$00000100;
      MMIO_READ       =$00000004;       /* Open */
      MMIO_SET_EXTENDEDINFO                   =$0001;
      MMIO_RESETTRACKS          =-1;

Type
    MMIOPROC=Function(Var pmmioInfo;wMsg:LONGWORD;lParam1,lParam2:LONG):LONG;APIENTRY;
    PMMIOPROC=^MMIOPROC;
    PCODECPROC=^MMIOPROC;
    HMMIO=LONGWORD;
    HMMCF=LONGWORD;
    FOURCC=LONGWORD;
    PFOURCC=^FOURCC;

Type
    PCODECINIFILEINFO=^CODECINIFILEINFO;
    CODECINIFILEINFO=Record
                           ulStructLen:LONGWORD;
                           fcc:FOURCC;
                           szDLLName:Cstring[DLLNAME_SIZE-1];
                           szProcName:Cstring[PROCNAME_SIZE-1];
                           ulCompressType:LONGWORD;
                           ulCompressSubType:LONGWORD;
                           ulMediaType:LONGWORD;
                           ulCapsFlags:LONGWORD;
                           ulFlags:LONGWORD;
                           szHWID:Cstring[CODEC_HW_NAME_SIZE-1];
                           ulMaxSrcBufLen:LONGWORD;
                           ulSyncMethod:LONGWORD;
                           fccPreferredFormat:LONGWORD;
                           ulXalignment:LONGWORD;
                           ulYalignment:LONGWORD;
                           ulSpecInfo:Cstring[CODEC_INFO_SIZE-1];
    End;

    PCODECASSOC=^CODECASSOC;
    CODECASSOC=Record
                     pCodecOpen:POINTER;
                     pCodecIniFileInfo:PCODECINIFILEINFO;
    End;

    PMMEXTENDINFO=^MMEXTENDINFO;
    MMEXTENDINFO=Record
                       ulStructLen:LONGWORD;
                       ulBufSize:LONGWORD;
                       ulFlags:LONGWORD;
                       ulTrackID:LONGWORD;
                       ulNumCODECs:LONGWORD;
                       pCODECAssoc:PCODECASSOC;
    End;

    PMMIOINFO=^MMIOINFO;
    MMIOINFO=Record
                   dwFlags:LONGWORD;
                   fccIOProc:FOURCC;
                   pIOProc:PMMIOPROC;
                   dwErrorRet:LONGWORD;
                   cchBuffer:LONG;
                   pchBuffer:PChar;
                   pchNext:PChar;
                   pchEndRead:PChar;
                   pchEndWrite:PChar;
                   lBufOffset:LONG;
                   lDiskOffset:LONG;
                   adwInfo:Array[0..3] Of LONGWORD;
                   lLogicalFilePos:LONG;
                   ulTranslate:LONGWORD;
                   fccChildIOProc:FOURCC;
                   pExtraInfoStruct:POINTER;
                   hmmio:HMMIO;
    End;

Var mciGetDeviceIdAddr:Function(AliasName:Cstring):LONGWORD;APIENTRY; {MDM index 16;}
    mciGetErrorStringAddr:Function(ulError:LONGWORD;
                                   Var pszBuffer:Cstring;
                                   usLength:LONGWORD):LONGWORD;APIENTRY; {MDM index 3;}
    mciSendStringAddr:Function(s:Cstring;Var ret:Cstring;retlen:LONGWORD;
                             ahwnd:HWND;userParam:LONGWORD):LONGWORD;APIENTRY; {MDM index 2;}
    mmioOpenAddr:Function( pszFileName:Cstring;Var apmmioinfo:MMIOINFO;
                         dwOpenFlags:LONGWORD ):HMMIO;APIENTRY;  {MMIO index 27;}
    mmioCloseAddr:Function( ahmmio:HMMIO;wFlags:LONGWORD ):WORD;APIENTRY;  {MMIO index 32;}
    mmioGetHeaderAddr:Function( ahmmio:HMMIO;Var pHeader;lHeaderLength:LONG;
                       Var plBytesRead:LONG;dwReserved:ULONG;dwFlags:ULONG ):LONGWORD;APIENTRY;  {MMIO index 77;}
    mmioSetAddr:Function(ahmmio:HMMIO;Var pUserExtendmminfo:MMEXTENDINFO;
                     ulFlags:ULONG):ULONG;APIENTRY;  {MMIO index 101;}
    mmioQueryHeaderLengthAddr:Function( ahmmio:HMMIO;Var plHeaderLength:LONG;
                               dwReserved:LONGWORD;dwFlags:LONGWORD ):LONGWORD;APIENTRY;  {MMIO index 76;}

Const MMPM2Initialized:BOOLEAN=FALSE;

Type EProcAddrError=Class(Exception);

Function InitMMPM2:BOOLEAN;
Var c:Cstring;
    MdmModHandle:LONGWORD;
    ok:BOOLEAN;
    Function GetProcaddr(Index:LONGWORD):POINTER;
    Begin
         result:=Nil;
         If DosQueryProcAddr(MdmModHandle,Index,Nil,result)<>0 Then
         Begin
              ErrorBox2(LoadNLSStr(SMMAccessError));
              Raise EProcAddrError.Create(tostr(Index));
         End;
    End;
Begin
     result:=MMPM2Initialized;
     If result Then exit;

     If DosLoadModule(c,255,'MDM',MdmModHandle)<>0 Then
     Begin
          ErrorBox2(LoadNLSStr(SMDMNotFound));
          exit;
     End;

     ok:=TRUE;
     Try
        mciGetDeviceIdAddr:=Pointer(GetProcAddr(16));
        mciGetErrorStringAddr:=Pointer(GetProcAddr(3));
        mciSendStringAddr:=Pointer(GetProcAddr(2));
     Except
          ok:=FALSE;
     End;

     If Not ok Then exit;

     If DosLoadModule(c,255,'MMIO',MdmModHandle)<>0 Then
     Begin
          ErrorBox2(LoadNLSStr(SMMIONotFound));
          exit;
     End;

     ok:=TRUE;
     Try
        mmioOpenAddr:=Pointer(GetProcAddr(27));
        mmioCloseAddr:=Pointer(GetProcAddr(32));
        mmioGetHeaderAddr:=Pointer(GetProcAddr(77));
        mmioSetAddr:=Pointer(GetProcAddr(101));
        mmioQueryHeaderLengthAddr:=Pointer(GetProcAddr(76));
     Except
        ok:=FALSE;
     End;
     MMPM2Initialized:=ok;
     result:=ok;
End;

{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMCIDevice Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TMCIDevice.GetCanEject:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('can eject');
End;

Function TMCIDevice.GetCanPlay:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('can play');
End;

Function TMCIDevice.GetCanRecord:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('can record');
End;

Function TMCIDevice.GetCanSave:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('can save');
End;

Function TMCIDevice.GetCanLockEject:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('can lockeject');
End;

Function TMCIDevice.GetCanSetVolume:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('can setvolume');
End;

Function TMCIDevice.GetHasAudio:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('has audio');
End;

Function TMCIDevice.GetHasVideo:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('has video');
End;

Function TMCIDevice.GetUsesFiles:BOOLEAN;
Begin
     If Not FDeviceOpen Then OpenDevice;
     result:=GetMCICapBoolean('uses files');
End;

Procedure TMCIDevice.SetFileName(Const NewValue:String);
Begin
     Stop;
     CloseDevice;
     If FFileName<>Nil Then FreeMem(FFileName,System.length(FFileName^)+1);
     GetMem(FFileName,System.length(NewValue)+1);
     FFileName^:=NewValue;
     FFileLoaded:=False;
     Load;
End;

Function TMCIDevice.GetFileName:String;
Begin
     If FFileName<>Nil Then result:=FFileName^
     Else result:='';
End;

Procedure TMCIDevice.GetDefaultFileMask(Var Ext,Description:String);
Begin
     Ext:='*.*';
     Description:=LoadNLSStr(SAllFiles);
End;

Function TMCIDevice.GetMCIStatusNumber(Const option:String):LONGINT;
Var c:INTEGER;
Begin
     result:=-1;
     OpenDevice;
     If Not SendString('status '+AliasName+' '+option+' wait',0) Then exit;
     VAL(FLastMCIReturn,result,c);
     If c<>0 Then result:=-1;
End;

Function TMCIDevice.GetMCIStatusBoolean(Const option:String):BOOLEAN;
Var temp:LONGINT;
Begin
     temp:=GetMCIStatusNumber(option);
     result:=FLastMCIReturn='TRUE';
End;

Function TMCIDevice.GetMCICapBoolean(Const Option:String):BOOLEAN;
Begin
     result:=FALSE;
     If Not SendString('capability '+AliasName+' '+Option+' wait',0) Then exit;
     result:=FLastMCIReturn='TRUE';
End;

Function TMCIDevice.GetMCICapLong(Const Option:String):LONGWORD;
Var c:INTEGER;
Begin
     result:=0;
     If Not SendString('capability '+AliasName+' '+Option+' wait',0) Then exit;
     VAL(FLastMCIReturn,result,c);
     If c<>0 Then result:=0;
End;

Function TMCIDevice.GetDeviceReady:BOOLEAN;
Begin
     result:=GetMCIStatusBoolean('ready');
End;

Const DeviceModesArray:Array[dmNotReady..dmUnknown] Of String[15]=
            (
             'not ready',
             'stopped',
             'playing',
             'seeking',
             'recording',
             'paused',
             'other',
             'unknown'
            );

Function DeviceModeToString(dm:TMCIDeviceMode):String;
Begin
     result:=DeviceModesArray[dm];
End;

Function TMCIDevice.Cue(CueFor:TCueTypes):BOOLEAN;
Var s:String[10];
Begin
     result:=FALSE;
     If CueFor=cuOutput Then s:=' output'
     Else s:=' input';
     OpenDevice;
     If Not SendString('cue '+AliasName+s+' wait',0) Then exit;
     result:=TRUE;
End;


Procedure TMCIDevice.SetPositionAdvise(NewValue:BOOLEAN);
Var SaveFormat:TTimeFormat;
Begin
     OpenDevice;
     If FNotifyControl<>Nil Then
       If FFileLoaded Then
     Begin
          If NewValue Then
          Begin
              If Not FPositionAdvise Then
              Begin
                   {$IFDEF OS2}
                   SaveFormat:=TimeFormat;
                   If SendString('setpositionadvise '+AliasName+' on every '
                                 +TimeInfoStr(FPositionAdviseUnits,SaveFormat)+' wait',0) Then
                     FPositionAdvise:=TRUE;
                   TimeFormat:=SaveFormat;
                   {$ENDIF}
                   {$IFDEF WIN95}
                   FPositionAdvise:=TRUE;
                   {$ENDIF}
              End;
          End
          Else If FPositionAdvise Then
          Begin
               {$IFDEF OS2}
               If SendString('setpositionadvise '+AliasName+' off wait',0) Then
               {$ENDIF}
               FPositionAdvise:=FALSE;
          End;
     End;
End;

Function TMCIDevice.GetDeviceId:LONGWORD;
Begin
     {$IFDEF OS2}
     result:=0;
     If Not InitMMPM2 Then exit;
     result:=mciGetDeviceIdAddr(AliasName);
     {$ENDIF}
     {$IFDEF Win95}
     result:=mciGetDeviceId(AliasName);
     {$ENDIF}
End;

Function TMCIDevice.GetDeviceMode:TMCIDeviceMode;
Var t:TMCIDeviceMode;
Begin
     result:=dmUnknown;
     OpenDevice;
     If Not SendString('status '+AliasName+' mode wait',0) Then exit;
     For t:=dmNotReady To dmOther Do
       If FLastMCIReturn=DeviceModesArray[t] Then
       Begin
            result:=t;
            exit;
       End;

End;

Function TMCIDevice.GetMediaPresent:BOOLEAN;
Begin
     result:=GetMCIStatusBoolean('media present');
End;

Function TMCIDevice.GetChannels:LONGINT;
Begin
     result:=GetMCIStatusNumber('channels');
End;

Function TMCIDevice.GetCurrentTrack:LONGINT;
Begin
     result:=GetMCIStatusNumber('current track');
End;

Procedure TMCIDevice.NextTrack;
Begin
End;

Procedure TMCIDevice.PreviousTrack;
Begin
End;


Function TMCIDevice.GetTrackLength(Track:LONGINT):TTimeInfo;
Begin
     If Track=0 Then Track:=CurrentTrack;
     result:=GetMCITimeInfo('length track '+tostr(track));
End;

Function TMCIDevice.GetMCITimeInfo(Const option:String):TTimeInfo;
Var s:String;
    OldTimeFormat:TTimeFormat;

    Procedure GetNextNumber(Var res:BYTE);
    Var b:BYTE;
        s1:String;
        c:INTEGER;
    Begin
         If s='' Then res:=0 //default
         Else
         Begin
              b:=pos(':',s);
              If b<>0 Then
              Begin
                   s1:=System.Copy(s,1,b-1);
                   delete(s,1,b);
              End
              Else
              Begin
                   s1:=s;
                   s:='';
              End;
              VAL(s1,res,c);
              If c<>0 Then res:=0;
         End;
    End;

Begin
     OldTimeFormat:=TimeFormat;
     Case OldTimeFormat Of
        tfTMSF:
        Begin
             //we must process strings :-(
             GetMCIStatusNumber(option);
             s:=FLastMCIReturn;
             {lock for tracks}
             result.Format:=tfTMSF;
             GetNextNumber(result.tmsf_Track);
             GetNextNumber(result.tmsf_Minutes);
             GetNextNumber(result.tmsf_Seconds);
             GetNextNumber(result.tmsf_Frames);
        End;
        tfBytes,tfSamples,tfSP,tfFrames:
        Begin
             result.Bytes:=GetMCIStatusNumber(option);
             If result.Bytes=-1 Then result.Format:=tfUnknown
             Else result.Format:=OldTimeFormat;
        End;
        Else
        Begin //we can convert to mmtime and vice versa
             TimeFormat:=tfMMTime;
             result.mmTime:=GetMCIStatusNumber(option);
             If result.mmTime=-1 Then result.Format:=tfUnknown
             Else
             Begin
                 {$IFDEF OS2}
                 result.Format:=tfMMTime;
                 {$ENDIF}
                 {$IFDEF Win95}
                 result.Format:=tfMilliseconds;
                 {$ENDIF}
                 ConvertTimeInfo(result,OldTimeFormat);
             End;
             TimeFormat:=OldTimeFormat;
             exit;
        End;
     End;
End;

Function TMCIDevice.GetPosition:TTimeInfo;
Begin
     result:=GetMCITimeInfo('position');
End;

Function TMCIDevice.GetLength:TTimeInfo;
Begin
     result:=GetMCITimeInfo('length');
End;

Function TMCIDevice.GetVolume(Channel:TChannel):LONGINT;
Var s,s1:String;
    b:BYTE;
    c:INTEGER;
    Temp,Temp1:LONGINT;
Begin
     result:=-1;
     OpenDevice;
     If Not SendString('status '+AliasName+' volume wait',0) Then exit;
     s:=LastMCIReturn;
     b:=pos(':',s);
     If b=0 Then exit;
     Case Channel Of
         chLeft:s[0]:=chr(b-1);
         chRight:delete(s,1,b);
         chBoth:
         Begin
              s1:=s;
              s[0]:=chr(b-1);
              VAL(s,temp,c);
              If c<>0 Then exit;
              delete(s1,1,b);
              VAL(s1,temp1,c);
              If c<>0 Then exit;
              result:=(temp+temp1) Div 2;
              exit;
         End;
     End; {case}
     VAL(s,result,c);
     If c<>0 Then result:=-1;
End;

Procedure TMCIDevice.SetVolume(Channel:TChannel;NewVolume:LONGINT);
Var s:String;
Begin
     OpenDevice;
     Case Channel Of
        chLeft:s:='left';
        chRight:s:='right';
        chBoth:s:='all';
     End; {Case}
     SendString('set '+AliasName+' audio '+s+' volume '+tostr(NewVolume)+' wait',0);
End;

Function CompareTimeInfos(TimeInfo1,TimeInfo2:TTimeInfo):LONGINT;
Label process;
Begin
     result:=-2; {cannot compare}
     Case TimeInfo1.Format Of
         tfTMSF,tfBytes,tfSamples,tfSP,tfFrames:
         Begin
              If TimeInfo2.Format=TimeInfo1.Format Then Goto process
              Else exit; {cannot compare}
         End;
         Else
         Begin
              {we can convert to mmtime}
              ConvertTimeInfo(TimeInfo1,tfMMTime);
              Case TimeInfo1.Format Of
                  tfTMSF,tfBytes,tfSamples,tfSP,tfFrames:exit; {cannot compare}
                  Else
                  Begin
                       {we can convert to mmtime}
                       {$IFDEF OS2}
                       ConvertTimeInfo(TimeInfo2,tfMMTime);
                       {$ENDIF}
                       {$IFDEF Win95}
                       ConvertTimeInfo(TimeInfo2,tfMilliseconds);
                       {$ENDIF}
process:
                       If TimeInfo1.mmTime>TimeInfo2.mmTime Then result:=1        {first greater}
                       Else If TimeInfo1.mmTime<TimeInfo2.mmTime Then result:=-1  {second greater}
                       Else result:=0;                                            {equal}
                  End;
               End; {case}
         End;
     End; {case}
End;

Function ConvertTimeInfo(Var TimeInfo:TTimeInfo;NewFormat:TTimeFormat):BOOLEAN;
Var OldFormat:LONGWORD;
Begin
     result:=TRUE;
     Case TimeInfo.Format Of
        tfMSF:TimeInfo.msf_Reserved:=0;
        tfHMS:TimeInfo.hms_reserved:=0;
     End;
     If TimeInfo.Format=NewFormat Then exit;

     OldFormat:=TimeInfo.Unknown;
     {Convert format to MMTime, all conversions convert from MMTime format}
     Case TimeInfo.Format Of
         tfMilliSeconds:
         Begin
              If OldFormat>$FFFFFFFF Div 3 Then OldFormat:=0
              Else OldFormat:=OldFormat*3;
         End;
         tfMMTime:;
         tfMSF:
         Begin
              OldFormat:=(OldFormat And $000000FF)*60*3000;
              OldFormat:=(OldFormat And $0000FF00) Div $100 * 3000;
              OldFormat:=(OldFormat And $00FF0000) Div $10000*3000 Div 75;
         End;
         tfHMS:
         Begin
              OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
              OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
              OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
         End;
         tfHMSF:
         Begin
              OldFormat:=(OldFormat And $000000FF)*60*3000;
              OldFormat:=(OldFormat And $0000FF00) Div $100 * 3000;
              OldFormat:=(OldFormat And $00FF0000) Div $10000*3000 Div 75;
              OldFormat:=(OldFormat And $FF000000) Div $1000000 Div 60*3000;
         End;
         tfSMPTE24:
         Begin
              OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
              OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
              OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
              OldFormat:=(OldFormat And $FF000000) Div $1000000 * 3000 Div 24;
         End;
         tfSMPTE25:
         Begin
              OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
              OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
              OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
              OldFormat:=(OldFormat And $FF000000) Div $1000000 * 3000 Div 25;
         End;
         tfSMPTE30:
         Begin
              OldFormat:=(OldFormat And $000000FF) * 60 * 60 * 3000;
              OldFormat:=(OldFormat And $0000FF00) Div $100 * 60 * 3000;
              OldFormat:=(OldFormat And $00FF0000) Div $10000 * 3000;
              OldFormat:=(OldFormat And $FF000000) Div $1000000 * 3000 Div 30;
         End;
         Else
         Begin
              //we cannot convert the format (for example tfTMSF) to MMTime
              result:=FALSE;
              exit;
         End;
     End; {case}

     {Convert Format to result}
     Case NewFormat Of
         tfMilliSeconds:
         Begin
              TimeInfo.Unknown:=(OldFormat+1) Div 3;
         End;
         tfMMTime:;
         tfMSF:
         Begin
              If (OldFormat+20)>=$100*60*3000 Then TimeInfo.Unknown:=0
              Else TimeInfo.Unknown:=((((OldFormat)+20) Div (60*3000)) +
                                      (((OldFormat)+20) Mod (60*3000) Div 3000 Shl 8) +
                                      (((OldFormat)+20) Div (3000 Div 75) Mod 75 shl 16));
         End;
         tfHMS:
         Begin
              If (OldFormat+50)>=$100*60*60*3000 Then TimeInfo.Unknown:=0
              Else TimeInfo.Unknown:=(((((((OldFormat)+50) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                      (((((((OldFormat)+50) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                      ((((((OldFormat)+50) Div 3000) Div 60) Div 60)  and $000000FF));
         End;
         tfHMSF:
         Begin
              If (OldFormat+20)>=$100*60*3000 Then TimeInfo.Unknown:=0
              Else TimeInfo.Unknown:=(((OldFormat)+20) Mod (60*3000) Div 3000*60) +
                                      ((((OldFormat)+20) Div (60*3000) Shl 8) +
                                      (((OldFormat)+20) Mod (60*3000) Div 3000 Shl 16) +
                                      (((OldFormat)+20) Div (3000 Div 75) Mod 75 shl 24));
         End;
         tfSMPTE24:
         Begin
              If (OldFormat+63)>=$100*60*60*3000 Then TimeInfo.Unknown:=0
              Else TimeInfo.Unknown:=(((((((OldFormat)+63) Mod 3000)Div(3000 Div 24)) Shl 24) And $FF000000) or
                                      ((((((OldFormat)+63) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                      (((((((OldFormat)+63) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                   ((((((OldFormat)+63) Div 3000) Div 60) Div 60)  And $000000FF));
         End;
         tfSMPTE25:
         Begin
              If (OldFormat+63)>=$100*60*60*3000 Then TimeInfo.Unknown:=0
              Else TimeInfo.Unknown:=(((((((OldFormat)+63) Mod 3000)Div(3000 Div 25)) shl 24) And $FF000000) or
                                      ((((((OldFormat)+63) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                      (((((((OldFormat)+63) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                      ((((((OldFormat)+63) Div 3000) Div 60) Div 60)  and $000000FF));
         End;
         tfSMPTE30:
         Begin
              If (OldFormat+63)>=$100*60*60*3000 Then TimeInfo.Unknown:=0
              Else TimeInfo.Unknown:=(((((((OldFormat)+63) Mod 3000)Div(3000 Div 30)) shl 24) And $FF000000) or
                                      ((((((OldFormat)+63) Div 3000) Mod 60) Shl 16) And $00FF0000) Or
                                      (((((((OldFormat)+63) Div 3000) Div 60) Mod 60) shl 8) And $0000FF00) Or
                                      ((((((OldFormat)+63) Div 3000) Div 60) Div 60)  and $000000FF));
         End;
         Else
         Begin
              result:=FALSE;
              exit;
         End;
     End;

     TimeInfo.Format:=NewFormat;
     Case TimeInfo.Format Of
        tfMSF:TimeInfo.msf_Reserved:=0;
        tfHMS:TimeInfo.hms_reserved:=0;
     End;
     result:=TRUE;
End;

Const TimeFormatsArray:Array[tfMilliSeconds..tfUnknown] Of String[30]=
         (
          'milliseconds',
          'mmtime',
          'msf',
          'tmsf',
          'frames',
          'hms',
          'hmsf',
          'bytes',
          'samples',
          'smpte 24',
          'smpte 25',
          'smpte 30',
          'song pointer',
          'unknown'
         );

Function TimeFormatToString(tf:TTimeFormat):String;
Begin
     result:=TimeFormatsArray[tf];
End;

Function TimeInfoToString(Const TimeInfo:TTimeInfo):String;
   Function ToStr(i:LONGINT):String;
   Begin
        result:=System.Tostr(i);
        If System.length(result)<2 Then result:='0'+result;
   End;

Begin
     With TimeInfo Do
     Case Format Of
           tfMilliSeconds:result:=tostr(MilliSeconds);
           tfMMTime:result:=tostr(MMTime);
           tfMSF:result:=tostr(msf_Minutes)+':'+tostr(msf_Seconds)+':'+tostr(msF_FramEs);
           tfTMSF:result:=tostr(tmsf_Track)+':'+tostr(tmsf_Minutes)+':'+tostr(tMsf_SeConds)+':'+tostr(tmsf_FRames);
           tfFrames:result:=System.tostr(Frames);
           tfHMS:result:=tostr(hms_Hours)+':'+tostr(hms_Minutes)+':'+tostr(hms_SecondS);
           tfHMSF:result:=tostr(hmsf_Hours)+':'+tostr(hmsf_Minutes)+':'+tostr(hMsf_SeConds)+':'+tostr(hmsf_FRames);
           tfBytes:result:=System.tostr(Bytes);
           tfSamples:result:=System.tostr(Samples);
           tfSMPTE24:result:=System.tostr(SMPTE24);
           tfSMPTE25:result:=System.tostr(SMPTE25);
           tfSMPTE30:result:=System.tostr(SMPTE30);
           tfSP:result:=System.tostr(SongPointer);
           tfUnknown:result:='???';
     End; {case}
End;

Procedure TMCIDevice.SetTimeFormat(NewFormat:TTimeFormat);
Begin
     If NewFormat=FTimeFormat Then exit;
     {$IFDEF Win95}
     If NewFormat=tfMMTime Then NewFormat:=tfMilliseconds;
     {$ENDIF}
     If Not (NewFormat In FTimeFormatsAvailable) Then exit;
     FTimeFormat:=NewFormat;
     If FDeviceOpen Then
     Begin
       SendString('set '+AliasName+' time format '+TimeFormatsArray[NewFormat]+' wait',0);
     End;
End;

Function TMCIDevice.GetTracks:LONGINT;
Begin
     result:=GetMCIStatusNumber('number of tracks');
End;

Procedure TMCIDevice.HandleMCIError(Const ErrorStr:String);
Begin
     ErrorBox(ErrorStr);
     If FDeviceOpen Then //clear error condition
     Begin
          CloseDevice;
          OpenDevice;
     End;
End;

Procedure TMCIDevice.ShowMCIError(Code:LONGWORD);
Var
    ErrBuff:Cstring;
    s:String;
    ret:LONGWORD;
Begin
     {$IFDEF OS2}
     If Not InitMMPM2 Then exit;
     ret:=mciGetErrorStringAddr( Code, ErrBuff,255);
     Case ret Of
         MCIERR_SUCCESS:
         Begin
               s:=ErrBuff;
               HandleMCIError(s);
         End;
         Else HandleMCIError(LoadNLSStr(SUnknownMCIError));
     End; {case}
     {$ENDIF}
     {$IFDEF Win95}
     If mciGetErrorString( Code, ErrBuff,255) Then
     Begin
          s:=ErrBuff;
          HandleMCIError(s);
     End
     Else HandleMCIError(LoadNLSStr(SUnknownMCIError));
     {$ENDIF}
End;

Procedure TMCIDevice.SeekToStart;
Begin
     Load;
     Stop;
     SendString('seek '+AliasName+' to start wait',0);
     PositionChanged(Position);
End;

Procedure TMCIDevice.SeekToEnd;
Begin
      Load;
      Stop;
      SendString('seek '+AliasName+' to End wait',0);
      PositionChanged(Position);
End;

Function TMCIDevice.TimeInfoStr(TimeInfo:TTimeInfo;SaveTime:TTimeFormat):String;
Begin
     If SaveTime<>TimeInfo.Format Then
     Begin
          TimeFormat:=TimeInfo.Format;
          SaveTime:=TimeInfo.Format;
     End;

     Case SaveTime Of
        tfTMSF,tfHMSF:
        Begin
             result:=tostr(TimeInfo.tmsf_Track)+':'+
                     tostr(TimeInfo.tmsf_Minutes)+':'+
                     tostr(TimeInfo.tmsf_Seconds)+':'+
                     tostr(TimeInfo.tmsf_Frames);
        End;
        tfBytes,tfSamples,tfSP,tfFrames,tfMilliSeconds,tfMMTime,
        tfSMPTE24,tfSMPTE25,tfSMPTE30:
        Begin
             result:=tostr(TimeInfo.Bytes);
        End;
        tfMSF,tfHMS:
        Begin
             result:=tostr(TimeInfo.msf_Minutes)+':'+
                     tostr(TimeInfo.msf_Seconds)+':'+
                     tostr(TimeInfo.msf_Frames);
        End;
     End; {case}
End;

Procedure TMCIDevice.Seek(NewPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='seek '+AliasName+' to '+TimeInfoStr(NewPos,SaveTime)+' wait';
     TimeFormat:=SaveTime;
     SendString(s,0);
     PositionChanged(Position);
End;

Procedure TMCIDevice.Cut(StartPos,EndPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='copy '+AliasName+' from '+TimeInfoStr(StartPos,SaveTime)+
                          ' to '+TimeInfoStr(EndPos,SaveTime);
     TimeFormat:=SaveTime;
     SendString(s,0);
End;


Procedure TMCIDevice.Copy(StartPos,EndPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='copy '+AliasName+' from '+TimeInfoStr(StartPos,SaveTime)+
                          ' to '+TimeInfoStr(EndPos,SaveTime);
     TimeFormat:=SaveTime;
     SendString(s,0);
End;

Procedure TMCIDevice.Paste(StartPos,EndPos:TTimeInfo);
Var s:String;
    SaveTime:TTimeFormat;
Begin
     Load;
     Stop;
     SaveTime:=TimeFormat;
     s:='paste '+AliasName+' from '+TimeInfoStr(StartPos,SaveTime)+
                          ' to '+TimeInfoStr(EndPos,SaveTime);
     TimeFormat:=SaveTime;
     SendString(s,0);
End;


Procedure TMCIDevice.StartRecording;
Begin
     OpenDevice;
     Stop;
     PositionAdvise:=TRUE;
     If SendString('record '+AliasName+' overwrite notify',0) Then FStatus:=mciRecording
     Else
     Begin
          PositionAdvise:=FALSE;
          FStatus:=mciError;
     End;
End;

Procedure TMCIDevice.Play;
Begin
     OpenDevice;
     Case FStatus Of
       mciStopped,mciNothing:
       Begin
            Load;
            PositionAdvise:=TRUE;
            If SendString('play '+AliasName+' notify',0)
            Then FStatus:=mciPlaying
            Else
            Begin
                 PositionAdvise:=FALSE;
                 FStatus:=mciError;
            End;
       End;
       mciPaused:Resume;
       mciPlaying:;
     End;
End;

Procedure TMCIDevice.SetPositionAdviseUnits(NewUnits:TTimeInfo);
Begin
     If Not (NewUnits.Format In FTimeFormatsAvailable) Then exit;
     FPositionAdviseUnits:=NewUnits;
     If FPositionAdvise Then
     Begin
          PositionAdvise:=FALSE;
          PositionAdvise:=TRUE;
     End;
End;

Procedure TMCIDevice.Resume;
Begin
     If FStatus<>mciPaused Then exit;
     {$IFDEF Win95}
     If Self Is TCDDevice Then //resume not supported for MCICDA Win95
     Begin
          FStatus:=mciStopped;  //prevent recursion
          Play;
          exit;
     End;
     {$ENDIF}
     If SendString('resume '+AliasName+' wait',0) Then FStatus:=mciPlaying
     Else FStatus:=mciError;
End;

Procedure TMCIDevice.Pause;
Begin
     If FStatus=mciPaused Then
     Begin
          Resume;
          exit;
     End;
     If FStatus<>mciPlaying Then exit;
     If SendString('pause '+AliasName+' wait',0) Then FStatus:=mciPaused
     Else FStatus:=mciError;
End;

Procedure TMCIDevice.Stop;
Begin
     If Not FDeviceOpen Then exit;
     PositionAdvise:=FALSE;
     If Not (FStatus In [mciPlaying,mciPaused,mciRewind]) Then exit;
     If SendString('stop '+AliasName+' wait',0) Then
     Begin
          Repeat
              Application.HandleMessage;
          Until Not (FStatus In [mciPlaying,mciPaused,mciRewind]);
     End
     Else FStatus:=mciError;
End;

Function TMCIDevice.SendString(Const s:String;usUserParm:WORD):BOOLEAN;
Var
   lmciSendStringRC:LONG;    /* return value fromm mciSendString    */
   szReturn:Cstring;
   c:Cstring;
   Handle:LONGWORD;
Begin
   c:=s;

   If FNotifyControl<>Nil Then Handle:=FNotifyControl.Handle
   Else Handle:=0;

   szReturn:='';
   {$IFDEF OS2}
   result:=FALSE;
   If Not InitMMPM2 Then exit;
   lmciSendStringRC:=mciSendStringAddr(c,szReturn,255,Handle,usUserParm);
   {$ENDIF}
   {$IFDEF Win95}
   lmciSendStringRC :=
       mciSendString( c,
                      szReturn,
                      255,
                      Handle);
   {$ENDIF}

   FLastMCIReturn:=szReturn;
   If lmciSendStringRC <> 0 Then
   Begin
       ShowMCIError(lmciSendStringRC);
       FStatus:=mciError;
       result:=FALSE;
   End
   Else result:=TRUE;
End;


Function TMCIDevice.AddCuePoint(Const CuePoint:TTimeInfo):LONGWORD;
Var SaveFormat:TTimeFormat;
Begin
     OpenDevice;
     SaveFormat:=TimeFormat;
     If SendString('setcuepoint '+AliasName+' on at '+TimeInfoStr(CuePoint,SaveFormat)+
                   ' return '+tostr(FCuePointCount+1)+' wait',0) Then
     Begin
         inc(FCuePointCount);
         result:=FCuePointCount;
     End
     Else result:=0; {error}
     TimeFormat:=SaveFormat;
End;

Function TMCIDevice.DeleteCuePoint(Const CuePoint:TTimeInfo):BOOLEAN;
Var SaveFormat:TTimeFormat;
Begin
     OpenDevice;
     SaveFormat:=TimeFormat;
     If SendString('setcuepoint '+AliasName+' off at '+TimeInfoStr(CuePoint,SaveFormat)+
                   ' wait',0) Then result:=TRUE
     Else result:=FALSE; {error}
     TimeFormat:=SaveFormat;
End;

Procedure TMCIDevice.CloseDevice;
Begin
     If Not FDeviceOpen Then exit;
     If FFileLoaded Then Stop;
     PositionAdvise:=FALSE;
     If SendString('close '+AliasName+' wait',0) Then
     Begin
          FStatus:=mciNothing;
          FDeviceOpen:=FALSE;
          FFileLoaded:=FALSE;
     End
     Else
     Begin
          HandleMCIError('Cannot close mci device '+DeviceName);
          FStatus:=mciError;
     End;
     FFileLoaded:=False;
End;

Procedure TMCIDevice.OpenDevice;
Var tf:TTimeFormat;
Begin
     If FDeviceOpen Then exit;

     If SendString(  'open '+DeviceName+' alias '+AliasName+' shareable wait', 0 ) Then
     Begin
          /* Open success, set the flag and return true */
          fDeviceOpen := TRUE;
          tf:=FTimeFormat;
          FTimeFormat:=tfUnknown;
          TimeFormat:=tf;
          If FTimeFormat=tfUnknown Then FTimeFormat:=DefaultTimeFormat;
     End
     Else
     Begin
          HandleMCIError('Error opening mci device '+DeviceName);
          FStatus:=mciError;
     End;
End;


Procedure TMCIDevice.SetupComponent;
Var PosAdviseUnits:TTimeInfo;
Begin
     Inherited SetupComponent;

     Name:='MCIDevice';
     DeviceName:='Unknown';
     AliasName:='Unknown';

     FNotifyControl:=TMCINotifyControl.Create(Self);
     TMCINotifyControl(FNotifyControl).FDevice:=Self;
     TMCINotifyControl(FNotifyControl).CreateWnd;

     FStatus:=mciNothing;
     FFileNameRequired:=TRUE;
     FTimeFormatsAvailable:=[tfMilliseconds,tfMMTime];
     FDefaultTimeFormat:=tfMilliseconds;
     FTimeFormat:=FDefaultTimeFormat;
     Include(ComponentState, csHandleLinks);
     PosAdviseUnits.Format:=tfMilliseconds;
     PosAdviseUnits.Milliseconds:=1000;
     PositionAdviseUnits:=PosAdviseUnits;
End;

Procedure TMCIDevice.Load;
Var  mciStr:String;
Begin
     If FileName='' Then
     Begin
          If FFileNameRequired Then
          Begin
               HandleMCIError(LoadNLSStr(SNoFileName));
               FStatus:=mciError;
          End
          Else FFileLoaded:=TRUE;
          exit; //no file loaded
     End
     Else If Not FFileNameRequired Then exit;

     Screen.Cursor := crHourglass;

     OpenDevice;

     If Not FFileLoaded Then
     Begin
          mciStr:='load '+AliasName+' '+FileName+' wait';
          If Not SendString(mciStr,0) Then
          Begin
               Screen.Cursor := crDefault;
               FStatus:=mciError;
               exit;
          End;

          FFileLoaded:=TRUE;
     End;

     Screen.Cursor := crDefault;
End;

Procedure TMCIDevice.SetDeviceName(NewName:String);
Begin
     If FDeviceName<>Nil Then FreeMem(FDeviceName,System.length(FDeviceName^)+1);
     getmem(FDeviceName,System.length(NewName)+1);
     FDeviceName^:=NewName;
End;

Function TMCIDevice.GetDeviceName:String;
Begin
     If FDeviceName<>Nil Then result:=FDeviceName^
     Else result:='';
End;

Procedure TMCIDevice.SetAliasName(NewName:String);
Begin
     If FAliasName<>Nil Then FreeMem(FAliasName,System.length(FAliasName^)+1);
     getmem(FAliasName,System.length(NewName)+1);
     FAliasName^:=NewName;
End;

Function TMCIDevice.GetAliasName:String;
Begin
     If FAliasName<>Nil Then result:=FAliasName^
     Else result:='';
End;

Destructor TMCIDevice.Destroy;
Begin
     Stop;
     CloseDevice;
     FNotifyControl.Destroy;
     FNotifyControl:=Nil;
     If FFileName<>Nil Then FreeMem(FFileName,System.length(FFileName^)+1);
     FFileName:=Nil;

     Inherited Destroy;
End;

Function TMCIDevice.WriteSCUResource(Stream:TResourceStream):BOOLEAN;
Var s:String;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then exit;

     s:=FileName;
     If s<>'' Then result:=Stream.NewResourceEntry(rnFileName,s,System.length(s)+1);
End;

Procedure TMCIDevice.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LONgiNT);
Var s:String;
Begin
     If ResName = rnFileName Then
     Begin
          If DataLen<>0 Then
          Begin
               move(Data,s,DataLen);
               FileName:=s;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Procedure TMCIDevice.PlayingCompleted;
Begin
     If FOnPlayingCompleted<>Nil Then FOnPlayingCompleted(Self);
End;

Procedure TMCIDevice.PlayingAborted;
Begin
     If FOnPlayingAborted<>Nil Then FOnPlayingAborted(Self);
End;

{$HINTS OFF}
Procedure TMCIDevice.CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);
Begin
     If OnCuePointReached<>Nil Then OnCuePointReached(Self,CuePoint,CuePointId);
End;

Procedure TMCIDevice.PositionChanged(Const NewPosition:TTimeInfo);
Begin
     If OnPositionChanged<>Nil Then OnPositionChanged(Self,NewPosition);
End;
{$HINTS ON}

Procedure TMCIDevice.MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUserCOde:LONGWORD);
Var TimeInfo:TTimeInfo;
    LinkList:TList;
    t:LONGINT;
    Component:TComponent;
Begin
     Case Event Of
         mciNotifySuperseded:;
         mciNotifyAborted:
         Begin
              FStatus:=mciStopped;
              PlayingAborted;
              PositionAdvise:=FALSE;
         End;
         mciNotifyError:
         Begin
              FStatus:=mciError;
              If ulNotifyCode<>0 Then ShowMCIError(ulNotifyCode)
              Else ErrorBox(LoadNLSStr(SFatalMCIError));
              PositionAdvise:=FALSE;
         End;
         mciNotifySuccess:
         Begin
              FStatus:=mciStopped;
              PlayingCompleted;
              PositionAdvise:=FALSE;
         End;
         mciNotifyPositionChange:
         Begin
              If TimeFormat=tfTMSF Then TimeInfo:=Position
              Else
              Begin
                  TimeInfo.Format:=tfMMTime;
                  TimeInfo.mmTime:=ulNotifyCode;
                  ConvertTimeInfo(TimeInfo,TimeFormat);
              End;
              PositionChanged(TimeInfo);
         End;
         mciNotifyCuePoint:
         Begin
              TimeInfo.Format:=tfMMTime;
              TimeInfo.mmTime:=ulNotifyCode;
              ConvertTimeInfo(TimeInfo,TimeFormat);
              CuePointReached(TimeInfo,ulUserCode);
         End;
     End; {case}

     LinkList:=FreeNotifyList;
     ulDeviceId:=DeviceId;
     If LinkList<>Nil Then For t:=0 To LinkList.Count-1 Do
     Begin
          Component:=LinkList[t];
          If Component Is TVideoWindow Then
            TVideoWindow(Component).MCIEvent(Event,ulDeviceId,ulNotifyCode,ulUserCodE)
          Else If Component Is TMediaPlayer Then
            TMediaPlayer(Component).MCIEvent(Event,ulDeviceId,ulNotifyCode,ulUserCodE);
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TVideoDevice Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TVideoDevice.GetCapabilities:TVideoDeviceCapabilities;
Begin
     OpenDevice;
     result.CanDistort:=GetMCICapBoolean('can distort');
     result.CanProcessInternal:=GetMCICapBoolean('can process internal');
     result.CanRecordInsert:=GetMCICapBoolean('can record insert');
     result.CanStream:=GetMCICapBoolean('can stream');
     result.CanStretch:=GetMCICapBoolean('can stretch');
     result.FastPlayRate:=GetMCICapLong('fast play rate');
     result.HasTuner:=GetMCICapBoolean('has tuner');
     result.HorizontalVideoExtent:=GetMCICapLong('horizontal video extent');
     result.HorizontalImageExtent:=GetMCICapLong('horizontal image extent');
     result.NormalPlayRate:=GetMCICapLong('normal play rate');
     result.SlowPlayRate:=GetMCICapLong('slow play rate');
     result.VerticalImageExtent:=GetMCICapLong('vertical image extent');
     result.VerticalVideoExtent:=GetMCICapLong('vertical video extent');
End;

Procedure TVideoDevice.Seek(NewPos:TTimeInfo);
Begin
     OpenDevice;
     Inherited Seek(NewPos);

     {$IFDEF OS2}
     {SendString('step '+AliasName+' wait',0);
     SendString('step '+AliasName+' reverse wait',0);}
     {$ENDIF}
End;

Procedure TVideoDevice.SeekToStart;
Begin
     OpenDevice;
     Inherited SeekToStart;

     {$IFDEF OS2}
     {SendString('step '+AliasName+' wait',0);
     SendString('step '+AliasName+' reverse wait',0);}
     {$ENDIF}
End;

Procedure TVideoDevice.SetupComponent;
Var PosAdviseUnits:TTimeInfo;
Begin
     Inherited SetupComponent;
     AliasName:='Sibyl_movie';
     {$IFDEF OS2}
     DeviceName:='digitalvideo';
     {$ENDIF}
     {$IFDEF Win95}
     DeviceName:='avivideo';
     {$ENDIF}
     Name:='VideoDevice';
     FTimeFormatsAvailable:=[tfMilliseconds,tfMMtime,tfFrames,tfHMS,tfHMSF];
     FDefaultTimeFormat:=tfFrames;
     FTimeFormat:=FDefaultTimeFormat;
     PosAdviseUnits.Format:=tfFrames;
     PosAdviseUnits.Frames:=1;
     PositionAdviseUnits:=PosAdviseUnits;
End;

Procedure TVideoDevice.GetDefaultFileMask(Var Ext,Description:String);
Begin
     Ext:='*.AVI';
     Description:=LoadNLSStr(SVideoFiles);
End;

Procedure TVideoDevice.Load;
Var
   szHandle:Cstring[10];
   szx:Cstring[5];
   szy:Cstring[5];
   szcx:Cstring[5];
   szcy:Cstring[5];
   szWindowString:Cstring;
   szPutString:Cstring;
   {$IFDEF OS2}
   swpAppFrame:SWP;
   {$ENDIF}
   {$IFDEF Win95}
   ret:LONG;
   hwndMovie:HWND;
   s:String;
   c:INTEGER;
   rc:TRect;
   {$ENDIF}
Begin
   If FileName='' Then
   Begin
        ErrorBox(LoadNLSStr(SNoFilename));
        FStatus:=mciError;
        exit; //no movie loaded
   End;

   Screen.Cursor := crHourglass;

   OpenDevice;
   {$IFDEF OS2}
   szWindowString:='window '+AliasName+' handle ';
   If FVideoWindow<>Nil Then
   Begin
        szHandle:=tostr(FVideoWindow.Handle);
        szWindowString:=szWindowString+szHandle+' wait';
   End
   Else szWindowString:=szWindowString+'default';

   If Not SendString(szWindowString, 0) Then
   Begin
        Screen.Cursor := crDefault;
        FStatus:=mciError;
        exit;
   End;
   {$ENDIF}

   {$IFDEF Win95}
   If Not FFileLoaded Then
   Begin
        szWindowString:='open '+FileName+
                        ' alias '+AliasName+' style child parent ';
        If FVideoWindow<>Nil Then szHandle:=tostr(FVideoWindow.Handle)
        Else szHandle:='default';
        szWindowString:=szWindowString+szHandle;
        If Not SendString(szWindowString, 0) Then
        Begin
             Screen.Cursor := crDefault;
             FStatus:=mciError;
             exit;
        End;
   End;
   {$ENDIF}

   {$IFDEF OS2}
   If Not FFileLoaded Then
   Begin
       If SendString('load '+AliasName+' '+FileName+' wait', 0)
           Then FFileLoaded := TRUE
       Else
       Begin
            Screen.Cursor := crDefault;
            FStatus:=mciError;
            exit;
       End;
       SeekToStart;
   End;
   {$ENDIF}

   If Not FFileLoaded Then
   Begin
        {$IFDEF OS2}
        If FVideoWindow<>Nil Then
        Begin
             WinQueryWindowPos (FNotifyControl.Handle, swpAppFrame);

             swpAppFrame.x := 0;
             swpAppFrame.y := 0;

             szx:=tostr(swpAppFrame.x);
             szy:=tostr(swpAppFrame.y);
             szcx:=tostr(swpAppFrame.cx);
             szcy:=tostr(swpAppFrame.cy);

             szPutString:='put '+AliasName+' destination at ';
             szPutString:=szPutString+szx+' '+szy+' '+szcx+' '+szcy+' '+'wait';

             If Not SendString( szPutString, 0 ) Then
             Begin
                  Screen.Cursor := crDefault;
                  FStatus:=mciError;
                  exit;
             End;
        End;

        {$ENDIF}
        {$IFDEF Win95}
        ret:=mciSendString('status '+AliasName+' window handle',
                           szPutString,255,0);
        If ret<>0 Then
        Begin
             Screen.Cursor := crDefault;
             FStatus:=mciError;
             ShowMCIError(ret);
             exit;
        End;

        s:=szPutString;
        VAL(s,hwndMovie,c);
        If c<>0 Then
        Begin
             Screen.Cursor := crDefault;
             FStatus:=mciError;
             ErrorBox(LoadNLSStr(SWrongMovieHandle));
             exit;
        End;

        If FVideoWindow<>Nil Then
        Begin
             rc:=FVideoWindow.ClientRect;
             {???????+-1}
             inc(rc.Right);
             inc(rc.Top);
             {wo Konverierung ?}
             MoveWindow(hwndMovie,rc.Left,rc.Bottom,
                        rc.Right,rc.Top,TRUE);
        End;
        {$ENDIF}
   End;

   {$IFDEF Win95}
   If Not FFileLoaded Then
     If Not SendString('window '+AliasName+' state show',0) Then
   Begin
        Screen.Cursor := crDefault;
        FStatus:=mciError;
        exit;
   End;
   FFileLoaded:=TRUE;
   {$ENDIF}

   Screen.Cursor := crDefault;
End;

Function TVideoDevice.GetBitsPerSample:LONGINT;
Begin
     result:=GetMCIStatusNumber('bitspersample');
End;

Function TVideoDevice.GetImageBitsPerPel:LONGINT;
Begin
     result:=GetMCIStatusNumber('image bitsperpel');
End;

Function TVideoDevice.GetImagePelFormat:String;
Begin
     GetMCIStatusNumber('image pelformat');
     result:=FLastMCIReturn;
End;

Function TVideoDevice.GetBrightness:LONGINT;
Begin
     result:=GetMCIStatusNumber('brightness');
End;

Function TVideoDevice.GetContrast:LONGINT;
Begin
     result:=GetMCIStatusNumber('contrast');
End;

Function TVideoDevice.GetHue:LONGINT;
Begin
     result:=GetMCIStatusNumber('hue');
End;

Function TVideoDevice.GetClipBoardDataAvail:BOOLEAN;
Begin
     result:=GetMCIStatusBoolean('clipboard');
End;

Function TVideoDevice.GetSaturation:LONGINT;
Begin
     result:=GetMCIStatusNumber('saturation');
End;

Function TVideoDevice.GetSamplesPerSec:LONGINT;
Begin
     result:=GetMCIStatusNumber('samplespersec');
End;

Function TVideoDevice.GetTunerTVChannel:LONGINT;
Begin
     result:=GetMCIStatusNumber('tuner tv channel');
End;

Function TVideoDevice.GetTunerFineTune:LONGINT;
Begin
     result:=GetMCIStatusNumber('tuner finetune');
End;

Function TVideoDevice.GetTunerFrequency:LONGINT;
Begin
     result:=GetMCIStatusNumber('tuner frequency');
End;

Function TVideoDevice.GetValidSignal:BOOLEAN;
Begin
     result:=GetMCIStatusBoolean('valid signal');
End;

Procedure TVideoDevice.SetBrightness(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' brightness '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetContrast(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' contrast '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetHue(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' hue '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetSaturation(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' saturation '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetSamplesPerSec(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' samplespersec '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetTunerTVChannel(NewValue:LONGINT);
Begin
     SendString('settuner '+AliasName+' tv channel '+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetTunerFineTune(NewValue:LONGINT);
Var Temp:LONGINT;
    s:String[10];
Begin
     Temp:=TunerFineTune;
     If NewValue=Temp Then exit;
     If NewValue<Temp Then s:='minus '
     Else s:='plus ';
     SendString('settuner '+AliasName+' finetune '+s+tostr(NewValue)+' wait',0);
End;

Procedure TVideoDevice.SetTunerFrequency(NewValue:LONGINT);
Begin
     SendString('settuner '+AliasName+' frequency '+tostr(NewValue)+' wait',0);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TAudioDevice Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TAudioDevice.SetBitsPerSample(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' bitspersample '+tostr(NewValue)+' wait',0);
End;

Procedure TAudioDevice.SetBytesPerSec(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' bytespersec '+tostr(NewValue)+' wait',0);
End;

Procedure TAudioDevice.SetSamplesPerSec(NewValue:LONGINT);
Begin
     SendString('set '+AliasName+' samplespersec '+tostr(NewValue)+' wait',0);
End;

Function TAudioDevice.GetAlignment:LONGINT;
Begin
     result:=GetMCIStatusNumber('alignment');
End;

Function TAudioDevice.GetBitsPerSample:LONGINT;
Begin
     result:=GetMCIStatusNumber('bitspersample');
End;

Function TAudioDevice.GetBytesPerSec:LONGINT;
Begin
     result:=GetMCIStatusNumber('bytespersec');
End;

Function TAudioDevice.GetSamplesPerSec:LONGINT;
Begin
     result:=GetMCIStatusNumber('samplespersec');
End;

Procedure TAudioDevice.SetupComponent;
Begin
     Inherited SetupComponent;
     AliasName:='Sibyl_audio';
     DeviceName:='waveaudio';
     Name:='AudioDevice';
     FTimeFormatsAvailable:=[tfMilliseconds,tfMMtime,tfBytes,tfSamples];
End;

Procedure TAudioDevice.GetDefaultFileMask(Var Ext,Description:String);
Begin
     Ext:='*.WAV';
     Description:=LoadNLSStr(SWaveFiles);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCDDevice Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TCDDevice.NextTrack;
Var OldStatus:TMCIStatus;
    trk:LONGINT;
Begin
     OpenDevice;
     Trk:=CurrentTrack;
     If Trk+1>Tracks Then exit;
     OldStatus:=FStatus;
     Stop;
     Seek(TrackPosition[trk+1]);
     If OldStatus=mciPlaying Then Play;
End;

Procedure TCDDevice.PreviousTrack;
Var OldStatus:TMCIStatus;
    trk:LONGINT;
    ti:TTimeInfo;
Begin
     OpenDevice;
     Trk:=CurrentTrack;
     OldStatus:=FStatus;
     Stop;
     ti:=PositionInTrack;
     ConvertTimeInfo(ti,tfHMS);
     If ((ti.Format=tfHMS)And(ti.hms_Seconds<1)) Then dec(trk);
     If trk=0 Then trk:=1;
     Seek(TrackPosition[trk]);
     If OldStatus=mciPlaying Then Play;
End;

Procedure TCDDevice.SetupComponent;
Begin
     Inherited SetupComponent;
     AliasName:='Sibyl_CD';
     DeviceName:='cdaudio';
     Name:='CDDevice';
     FFileNameRequired:=FALSE;
     FTimeFormatsAvailable:=[tfMilliseconds,tfMMtime,tfMSF,tfTMSF];
     FDefaultTimeFormat:=tfTMSF;
     FTimeFormat:=FDefaultTimeFormat;
End;


Function TCDDevice.GetTrackChannels(Track:LONGINT):LONGINT;
Begin
     If Track=0 Then Track:=CurrentTrack;
     result:=GetMCIStatusNumber('channels track '+tostr(Track));
End;


Function TCDDevice.GetTrackPosition(Track:LONGINT):TTimeInfo;
Begin
     If Track=0 Then Track:=CurrentTrack;
     result:=GetMCITimeInfo('position track '+tostr(track));
End;

Function TCDDevice.GetPositionInTrack:TTimeInfo;
Begin
     result:=GetMCITimeInfo('position in track');
End;

Function TCDDevice.GetStartPosition:TTimeInfo;
Begin
     result:=GetMCITimeInfo('start position');
End;

Const MediaTypesArray:Array[mtAudio..mtUnknown] Of String[8]=
                 (
                  'audio',
                  'data',
                  'other',
                  'unknown'
                 );

Function MediaTypeToString(mt:TCDMediaTypes):String;
Begin
     result:=MediaTypesArray[mt];
End;

Function TCDDevice.GetMediaType:TCDMediaTypes;
Var t:TCDMediaTypes;
Begin
     result:=mtUnknown;
     If Not FDeviceOpen Then OpenDevice;
     If Not SendString('status '+AliasName+' type wait',0) Then exit;
     For t:=mtAudio To mtOther Do
       If FLastMCIReturn=MediaTypesArray[t] Then
       Begin
            result:=t;
            exit;
       End;
End;

Function TCDDevice.GetTrackType(Track:LONGINT):TCDMediaTypes;
Var t:TCDMediaTypes;
Begin
     result:=mtUnknown;
     If Track=0 Then Track:=CurrentTrack;
     If Not FDeviceOpen Then OpenDevice;
     If Not SendString('status '+AliasName+' type track '+tostr(track)+' wait',0) Then exit;
     For t:=mtAudio To mtOther Do
       If FLastMCIReturn=MediaTypesArray[t] Then
       Begin
            result:=t;
            exit;
       End;
End;

Function TCDDevice.GetCapabilities:TCDDeviceCapabilities;
Begin
     FillChar(result,sizeof(TCDDeviceCapabilities),0);
     If Not FDeviceOpen Then OpenDevice;
     result.CanProcessInternal:=GetMCICapBoolean('can process internal');
     result.CanStream:=GetMCICapBoolean('can stream');
End;

Procedure TCDDevice.Eject;
Begin
     If Not FDeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door open wait',0);
End;

Procedure TCDDevice.Close;
Begin
     If Not FDeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door closed wait',0);
End;

Procedure TCDDevice.LockDoor;
Begin
     If Not FDeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door locked wait',0);
End;

Procedure TCDDevice.UnlockDoor;
Begin
     If Not FDeviceOpen Then OpenDevice;
     SendString('set '+AliasName+' door unlocked wait',0);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TVideoWindow Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TVideoWindow.PlayingCompleted;
Begin
     If FOnPlayingCompleted<>Nil Then FOnPlayingCompleted(Self);
End;

Procedure TVideoWindow.PlayingAborted;
Begin
     If FOnPlayingAborted<>Nil Then FOnPlayingAborted(Self);
End;

{$HINTS OFF}
Procedure TVideoWindow.CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);
Begin
     If OnCuePointReached<>Nil Then OnCuePointReached(Self,CuePoint,CuePointId);
End;

Procedure TVideoWindow.PositionChanged(Const NewPosition:TTimeInfo);
Begin
     If OnPositionChanged<>Nil Then OnPositionChanged(Self,NewPosition);
End;
{$HINTS ON}

Procedure TVideoWindow.MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUSerCode:LONGWORD);
Var TimeInfo:TTimeInfo;
Begin
     Case Event Of
         mciNotifySuperseded:;
         mciNotifyAborted:
         Begin
              VideoDevice.FStatus:=mciStopped;
              PlayingAborted;
              VideoDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyError:
         Begin
              VideoDevice.FStatus:=mciError;
              If ulNotifyCode<>0 Then VideoDevice.ShowMCIError(ulNotifyCode)
              Else ErrorBox(LoadNLSStr(SFatalMCIError));
              VideoDevice.PositionAdvise:=FALSE;
         End;
         mciNotifySuccess:
         Begin
              VideoDevice.FStatus:=mciStopped;
              PlayingCompleted;
              VideoDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyPositionChange:
         Begin
              If ulDeviceId=VideoDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,VideoDevice.TimeFormat);
                   PositionChanged(TimeInfo);
              End;
         End;
         mciNotifyCuePoint:
         Begin
              If ulDeviceId=VideoDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,VideoDevice.TimeFormat);
                   CuePointReached(TimeInfo,ulUserCode);
              End;
         End;
     End; {case}
End;

Procedure TVideoWindow.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='VideoWindow';
     Caption:=Name;
     Height:=200;
     Width:=200;
     ParentPenColor:=FALSE;
     ParentColor:=TRUE;
End;

Procedure TVideoWindow.Redraw(Const rc:TRect);
Var rec:TRect;
Begin
     If Canvas = Nil Then exit;
     If ((VideoDevice=Nil)Or(Not VideoDevice.DeviceOpen)) Then
     Begin
          Inherited Redraw(rc);
          If Designed Then
          Begin
              Canvas.Brush.Color:=Color;
              Canvas.Pen.Color:=clBlack;
              Canvas.TextOut(20,20,'Video Window');
              rec:=ClientRect;
              Canvas.Pen.Style := psDash;
              Canvas.Brush.Style := bsClear;
              Canvas.Rectangle(rec);
          End;
     End;
End;

Function TVideoWindow.DoesFileExist(pszFileName:String):BOOLEAN;
{$IFDEF OS2}
Const
   bReturn:ULONG=0;
   rc:ULONG=MMIO_SUCCESS;
Var
   hFile:LONGWORD;
   lHeaderLengthMovie:LONG;
   lHeaderLengthVideo:LONG;
   lBytes:LONG;
   apmmMovieHeader:PMMMOVIEHEADER;
   ammVideoHeader:MMVIDEOHEADER;
   ammExtendInfo:MMEXTENDINFO;
   ammioinfo:MMIOINFO;
{$ENDIF}
Begin
     {$IFDEF OS2}
     fillchar(ammioinfo, sizeof(MMIOINFO),0);
     fillchar(ammExtendinfo,sizeof(MMEXTENDINFO),0);
     fillchar(ammVideoHeader,sizeof(MMVIDEOHEADER),0);

     ammioinfo.ulTranslate :=  MMIO_TRANSLATEHEADER;

     ammExtendinfo.ulFlags := MMIO_TRACK;

     result:=FALSE;
     If Not InitMMPM2 Then exit;

     hFile := mmioOpenAddr( pszFileName, ammioinfo, MMIO_READ );

     If hFile <> 0 Then
     Begin
        ammExtendinfo.ulTrackID := -1;

        bReturn := mmioSetAddr(hFile, ammExtendinfo, MMIO_SET_EXTENDEDINFO);
        bReturn := mmioQueryHeaderLengthAddr(hFile, lHeaderLengthMovie,0, 0);

        If bReturn=0 Then
            getmem(apmmMovieHeader,lHeaderLengthMovie);

        bReturn := mmioGetHeaderAddr(hFile,
                                 apmmMovieHeader^,
                                 lHeaderLengthMovie,
                                 lBytes,
                                 0,
                                 0);
        If bReturn=0 Then
        Begin
            ammExtendinfo.ulTrackID := apmmMovieHeader^.ulNextTrackID;
            bReturn := mmioSetAddr(hFile, ammExtendinfo, MMIO_SET_EXTENDEDINFO);
            lHeaderLengthVideo := sizeof(MMVIDEOHEADER);
            bReturn := mmioGetHeaderAddr(hFile,
                                    ammVideoHeader,
                                    lHeaderLengthVideo,
                                    lBytes,
                                    0,
                                    0);

            ulMovieWidth  := ammVideoHeader.ulWidth;

            ulMovieHeight := ammVideoHeader.ulHeight;

            ulMovieLength := ammVideoHeader.ulLength;

            ammExtendinfo.ulTrackID := MMIO_RESETTRACKS;

            bReturn := mmioSetAddr(hFile, ammExtendinfo,MMIO_SET_EXTENDEDINFO);

            mmioCloseAddr( hFile, 0);

            freemem(apmmMovieHeader,lHeaderLengthMovie);
            result:=TRUE;
            exit;
         End;
     End;
     result:=FALSE;
     {$ENDIF}
     {$IFDEF Win95}
     result:=TRUE;
     {$ENDIF}
End;

Procedure TVideoWindow.SetVideoDevice(NewDevice:TVideoDevice);
Begin
     If FVideoDevice<>Nil Then FVideoDevice.Notification(Self,opRemove);
     FVideoDevice := NewDevice;
     If FVideoDevice <> Nil Then
     Begin
          FVideoDevice.FreeNotification(Self);
          FVideoDevice.FVideoWindow:=Self;
     End;
End;

Procedure TVideoWindow.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FVideoDevice Then
       Begin
            FVideoDevice.Stop;
            FVideoDevice.FVideoWindow:=Nil;
            FVideoDevice := Nil;
       End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMediaPlayer Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMediaPlayer.SetMCIDevice(NewDevice:TMCIDevice);
Begin
     If FMCIDevice=NewDevice Then exit;
     If FMCIDevice<>Nil Then
     Begin
          If FDestroyMCIDev Then FMCIDevice.Destroy
          Else FMCIDevice.Notification(Self,opRemove);
     End;
     FDestroyMCIDev:=FALSE;
     FMCIDevice := NewDevice;
     If FMCIDevice <> Nil Then FMCIDevice.FreeNotification(Self);
End;


Procedure TMediaPlayer.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FMCIDevice Then FMCIDevice := Nil;
End;


Procedure TMediaPlayer.PlayingAborted;
Begin
     EnabledButtons:=EnabledButtons-[btPause,btStop];
     If FOnPlayingAborted<>Nil Then FOnPlayingAborted(Self);
End;

Procedure TMediaPlayer.PlayingCompleted;
Begin
     EnabledButtons:=EnabledButtons-[btPause,btStop];
     If FOnPlayingCompleted<>Nil Then FOnPlayingCompleted(Self);
End;

{$HINTS OFF}
Procedure TMediaPlayer.PositionChanged(Const NewPosition:TTimeInfo);
Begin
     If OnPositionChanged<>Nil Then OnPositionChanged(Self,NewPosition);
End;

Procedure TMediaPlayer.CuePointReached(Const CuePoint:TTimeInfo;CuePointId:LONGWORD);
Begin
     If OnCuePointReached<>Nil Then OnCuePointReached(Self,CuePoint,CuePointId);
End;

Procedure TMediaPlayer.MCIEvent(Event:TMCINotifyEvents;ulDeviceId,ulNotifyCode,ulUSerCode:LONGWORD);
Var TimeInfo:TTimeInfo;
Begin
      Case Event Of
         mciNotifySuperseded:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;
         End;
         mciNotifyAborted:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;

              MCIDevice.FStatus:=mciStopped;
              PlayingAborted;
              MCIDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyError:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;

              MCIDevice.FStatus:=mciError;
              MCIDevice.PositionAdvise:=FALSE;
         End;
         mciNotifySuccess:
         Begin
              FPlayButton.StopAnimation;
              FRecordButton.StopAnimation;
              FPlayButton.ResetAnimation;
              FRecordButton.ResetAnimation;

              MCIDevice.FStatus:=mciStopped;
              PlayingCompleted;
              MCIDevice.PositionAdvise:=FALSE;
         End;
         mciNotifyPositionChange:
         Begin
              If ulDeviceId=MCIDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,MCIDevice.TimeFormat);
                   PositionChanged(TimeInfo);
              End;
         End;
         mciNotifyCuePoint:
         Begin
              If ulDeviceId=MCIDevice.DeviceId Then
              Begin
                   TimeInfo.Format:=tfMMTime;
                   TimeInfo.mmTime:=ulNotifyCode;
                   ConvertTimeInfo(TimeInfo,MCIDevice.TimeFormat);
                   CuePointReached(TimeInfo,ulUserCode);
              End;
         End;
      End;
End;
{$HINTS ON}


Procedure TMediaPlayer.EvButtonClick(Sender:TObject);
Var DoDefault:BOOLEAN;
    BtnType:TMPBtnType;
Begin
     DoDefault:=TRUE;
     BtnType:=TMPBtnType(TComponent(Sender).Tag);
     If OnClick <> Nil Then OnClick(Self,BtnType,DoDefault);
     If DoDefault Then
     Begin
          Case BtnType Of
              btPlay: Play;
              btStop: Stop;
              btPause: Pause;
              btBack: Back;
              btStep: Step;
              btEject: Eject;
              btRecord: StartRecording;
              btNext: Next;
              btPrev: Previous;
              btRewind:Rewind;
          End;
     End;
End;


Function TMediaPlayer.GetButton(Index:TMPBtnType):TBitBtn;
Begin
     Result := FButtons[Index];
End;


Procedure TMediaPlayer.CreateWnd;
Begin
     Inherited CreateWnd;

     RealignControls;
End;


Procedure TMediaPlayer.SetupComponent;
  Procedure InitBtn(Btn:TBitBtn;BtnTag:TMPBtnType;Const BtnBmp:String);
  Begin
       FButtons[BtnTag] := Btn;
       If BtnBmp <> '' Then Btn.Glyph.LoadFromResourceName(BtnBmp);
       Btn.YAlign := yaBottom;
       Btn.YStretch := ysParent;
       Btn.Visible := FALSE;
       Include(Btn.ComponentState, csDetail);
       Btn.SetDesigning(Designed);

       If Not Designed Then
       Begin
            Btn.Tag := LONGINT(BtnTag);
            Btn.OnClick := EvButtonClick;
       End;
  End;
Var  FNextTrkButton:TBitBtn;
     FPrevTrkButton:TBitBtn;
     FPauseButton:TBitBtn;
     FRewindButton:TBitBtn;
     FStopButton:TBitBtn;
     FBackTrkButton:TBitBtn;
     FStepTrkButton:TBitBtn;
     FEjectButton:TBitBtn;
Begin
     Inherited SetupComponent;
     Name:='MediaPlayer';
     Caption:='';
     Width:=32*4;
     Height:=32;
     ParentColor:=TRUE;
     FFrames:=1;
     DeviceType:=dtAutoSelect;

     FPlayButton:=InsertAnimatedButtonName(Self,0,0,32,32,'StdBmpPlay','',LoadNLSStr(SPlAyHInt));
     InitBtn(FPlayButton,btPlay,'');
     FPlayButton.Interval:=200;
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay');
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay1');
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay2');
     FPlayButton.BitmapList.AddResourceName('StdBmpPlay3');

     FPauseButton:=InsertBitBtn(Self,32,0,32,32, bkCustom,'',LoadNLSStr(SPauseHint));
     InitBtn(FPauseButton,btPause,'StdBmpPause');

     FStopButton:=InsertBitBtn(Self,64,0,32,32, bkCustom,'',LoadNLSStr(SStopHint));
     InitBtn(FStopButton,btStop,'StdBmpStop');

     FNextTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SNextTraCkHInt));
     InitBtn(FNextTrkButton,btNext,'StdBmpNextTrk');

     FPrevTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SPreviouSTrAckHint));
     InitBtn(FPrevTrkButton,btPrev,'StdBmpPrevTrk');

     FStepTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SStepTrackHint));
     InitBtn(FStepTrkButton,btStep,'StdBmpStepTrk');

     FBackTrkButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SBackTrackHint));
     InitBtn(FBackTrkButton,btBack,'StdBmpBackTrk');

     FRecordButton:=InsertAnimatedButtonName(Self,96,0,32,32,'StdBmpRecord','',LoadNLSStR(SRecordHint));
     InitBtn(FRecordButton,btRecord,'');
     FRecordButton.Interval:=200;
     FRecordButton.BitmapList.AddResourceName('StdBmpRecord');
     FRecordButton.BitmapList.AddResourceName('StdBmpRecord1');

     FEjectButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SEjectHint));
     InitBtn(FEjectButton,btEject,'StdBmpEject');

     FRewindButton:=InsertBitBtn(Self,96,0,32,32, bkCustom,'',LoadNLSStr(SRewindHint));
     InitBtn(FRewindButton,btRewind,'StdBmpRewind');

     VisibleButtons:=[btPlay,btPause,btRewind,btStop];
     EnabledButtons:=[btPlay,btRecord,btNext,btPrev];
     FUseAnimation:=TRUE;
End;


Destructor TMediaPlayer.Destroy;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.CloseDevice;
          If FDestroyMCIDev Then FMCIDevice.Destroy;
     End;
     FPlayButton.StopAnimation;
     FRecordButton.StopAnimation;
     If FFileName<>Nil Then FreeMem(FFileName,System.length(FFileName^)+1);
     FFileName := Nil;

     Inherited Destroy;
End;


Function TMediaPlayer.GetFileName:String;
Begin
     If MCIDevice<>Nil Then result:=MCIDevice.FileName
     Else If FFileName<>Nil Then result:=FFileName^
     Else Result:='';
End;


Procedure TMediaPlayer.SetFileName(NewName:String);
Begin
     If MCIDevice<>Nil Then MCIDevice.FileName:=NewName
     Else
     Begin
          If FFileName<>Nil Then FreeMem(FFileName,System.length(FFileName^)+1);
          GetMem(FFileName,System.length(NewName)+1);
          FFileName^:=NewName;
     End;
End;


Procedure TMediaPlayer.SetVisibleButtons(NewState:TMPButtonSet);
Var  idx:TMPBtnType;
Begin
     FVisibleButtons := NewState;
     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FButtons[idx]<>Nil Then
            FButtons[idx].Visible := FVisibleButtons * [idx] <> [];
     End;
     RealignControls;
End;


Procedure TMediaPlayer.SetEnabledButtons(NewState:TMPButtonSet);
Var  idx:TMPBtnType;
Begin
     FEnabledButtons := NewState;
     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FButtons[idx]<>Nil Then
            FButtons[idx].Enabled := FEnabledButtons * [idx] <> [];
     End;
     If Handle <> 0 Then Invalidate;
End;


Procedure TMediaPlayer.RealignControls;
Var  x:LONGINT;
     count,w:LONGINT;
     idx:TMPBtnType;
Begin
     If Handle = 0 Then exit;

     count := 0;
     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FVisibleButtons * [idx] <> [] Then inc(count);
     End;
     If count = 0 Then exit;

     x := 0;
     w := Width Div count;

     For idx := Low(TMPBtnType) To High(TMPBtnType) Do
     Begin
          If FButtons[idx]<>Nil Then
          Begin
              If FVisibleButtons * [idx] <> [] Then
              Begin
                   FButtons[idx].SetWindowPos(x,0,w,Height);
                   inc(x, w);
              End
              Else
              If Designed Then FButtons[idx].SetWindowPos(x,Height,w,Height);
          End;
     End;
End;

Procedure TMediaPlayer.Open;
Var s:String;
    DevType:TMPDeviceTypes;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.OpenDevice;
          FOpened:=MCIDevice.FDeviceOpen;
     End
     Else
     Begin
          FDestroyMCIDev:=TRUE;

          If DeviceType=dtAutoSelect Then
          Begin
               DevType:=dtOther;
               s:=FileName;
               UpcaseStr(s);
               If pos('.WAV',s)<>0 Then DevType:=dtWaveAudio
               Else If pos('.AVI',s)<>0 Then DevType:=dtAVIVideo;
          End
          Else DevType:=DeviceType;

          Case DevType Of
            dtAVIVideo:FMCIDevice:=TVideoDevice.Create(Nil);
            dtCDAudio:FMCIDevice:=TCDDevice.Create(Nil);
            dtDAT:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='DAT';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtDigitalVideo:FMCIDevice:=TVideoDevice.Create(Nil);
            dtMMMovie:FMCIDevice:=TVideoDevice.Create(Nil);
            dtOther:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Other';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtOverlay:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Overlay';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtScanner:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Scanner';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtSequencer:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Sequencer';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtVCR:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='VCR';
                 MCIDevice.AliasName:='Sibyl_'+FMCIDevice.DeviceName;
            End;
            dtVideoDisc:
            Begin
                 FMCIDevice:=TMCIDevice.Create(Nil);
                 MCIDevice.DeviceName:='Videodisc';
                 MCIDevice.AliasName:='Sibyl_'+MCIDevice.DeviceName;
            End;
            dtWaveAudio:FMCIDevice:=TAudioDevice.Create(Nil);
          End; //case

          MCIDevice.FileName:=FileName;
          MCIDevice.OpenDevice;
          FOpened:=MCIDevice.FDeviceOpen;
     End;
End;


Procedure TMediaPlayer.Play;
Begin
     If Not FOpened Then Open;
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.Play;
          If MCIDevice.Status=mciPlaying Then
          Begin
               EnabledButtons:=EnabledButtons-[btRecord];
               EnabledButtons:=EnabledButtons+[btPause,btStop,btRewind];
               If UseAnimation Then FPlayButton.StartAnimation;
          End;
     End;
End;


Procedure TMediaPlayer.StartRecording;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.StartRecording;
          If MCIDevice.Status=mciRecording Then
          Begin
               EnabledButtons:=EnabledButtons-[btPlay];
               EnabledButtons:=EnabledButtons+[btPause,btStop,btRewind];
               If UseAnimation Then FRecordButton.StartAnimation;
          End;
     End;
End;


Procedure TMediaPlayer.Stop;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.Stop;
          EnabledButtons:=EnabledButtons-[btStop,btPause];
          EnabledButtons:=EnabledButtons+[btPlay,btRecord];
          FPlayButton.ResetAnimation;
          FRecordButton.ResetAnimation;
     End;
End;


Procedure TMediaPlayer.Next;
Var WasPlaying:Boolean;
Begin
     If MCIDevice<>Nil Then
     Begin
          WasPlaying:=MCIDevice.Status=mciPlaying;
          Stop;
          MCIDevice.NextTrack;
          If WasPlaying Then Play;
     End;
End;


Procedure TMediaPlayer.Previous;
Var WasPlaying:Boolean;
Begin
     If MCIDevice<>Nil Then
     Begin
          WasPlaying:=MCIDevice.Status=mciPlaying;
          Stop;
          MCIDevice.PreviousTrack;
          If WasPlaying Then Play;
     End;
End;


Procedure TMediaPlayer.Pause;
Begin
     If MCIDevice<>Nil Then
     Begin
          If MCIDevice.Status<>mciPlaying Then
          Begin
               EnabledButtons:=EnabledButtons+[btStop];
               MCIDevice.Pause;
               If MCIDevice.Status=mciPlaying Then
                 If UseAnimation Then FPlayButton.StartAnimation;
          End
          Else
          Begin
               EnabledButtons:=EnabledButtons+[btPlay,btRecord];
               EnabledButtons:=EnabledButtons-[btStop];
               MCIDevice.Pause;
               FPlayButton.StopAnimation;
               FRecordButton.StopAnimation;
          End;
     End;
End;


Procedure TMediaPlayer.Rewind;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.SeekToStart;
          EnabledButtons:=EnabledButtons+[btPlay,btRecord];
          EnabledButtons:=EnabledButtons-[btStop,btPause,btRewind];
          FPlayButton.ResetAnimation;
          FRecordButton.ResetAnimation;
     End;
End;


Procedure TMediaPlayer.Close;
Begin
     If MCIDevice<>Nil Then
     Begin
          MCIDevice.CloseDevice;
          FOpened:=FALSE;
          EnabledButtons:=[btPlay,btRecord,btNext,btPrev];
          FPlayButton.ResetAnimation;
          FRecordButton.ResetAnimation;
     End;
End;

Procedure TMediaPlayer.Step;
Var ti:TTimeInfo;
Begin
     If MCIDevice<>Nil Then
     Begin
         ti:=MCIDevice.Position;
         ti.Unknown:=ti.Unknown+Frames;
         MCIDevice.Seek(ti);
     End;
End;

Procedure TMediaPlayer.Back;
Var ti:TTimeInfo;
Begin
     If MCIDevice<>Nil Then
     Begin
         ti:=MCIDevice.Position;
         ti.Unknown:=ti.Unknown-Frames;
         MCIDevice.Seek(ti);
     End;
End;

Procedure TMediaPlayer.Eject;
Begin
     If MCIDevice Is TCDDevice Then
     Begin
          TCDDevice(MCIDevice).Eject;
     End;
End;

Procedure TMediaPlayer.SetDeviceType(NewValue:TMPDeviceTypes);
Var WasOpened:BOOLEAN;
Begin
     If NewValue<>DeviceType Then
     Begin
          WasOpened:=FOpened;
          Close;
          FDeviceType:=NewValue;
          If WasOpened Then Open;
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TVolumeControl Class Implementation                         บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TVolumeControl.InsideCircle(MiddleX,MiddleY,Radius:LONGINT;Const pt:TPoint;Var Angle:LONGINT):BOOLEAn;
Var
    a,b:LONGINT;
    temp:Extended;
    OldRad:BOOLEAN;
    OldToRad:EXTENDED;
    OldFromRad:EXTENDED;
Begin
     result:=FALSE;
     If pt.X=MiddleX Then
     Begin
          If abs(pt.y-MiddleY)<=Radius Then result:=TRUE;
          Angle:=90;
     End
     Else If pt.Y=MiddleY Then
     Begin
          If abs(pt.x-MiddleX)<=Radius Then result:=TRUE;
          If pt.x<MiddleX Then Angle:=180
          Else Angle:=0;
     End
     Else
     Begin
          {Zwischenpunkt fr rechtwinkliges Dreieck}
          a:=pt.Y-MiddleY;
          b:=pt.X-MiddleX;
          temp:=sqrt(sqr(a)+sqr(b));
          If round(temp)<=Radius Then result:=TRUE;

          {Save old trigmode}
          OldRad:=IsNotRad;
          OldToRad:=ToRad;
          OldFromRad:=FromRad;

          {Set trigmode to degrees}
          ToRad:=0.01745329262;
          FromRad:=57.29577951;
          IsNotRad:=TRUE;
          Angle:=round(arcsin(abs(b)/temp));
          If pt.X>MiddleX Then Angle:=90-Angle
          Else inc(Angle,90);

          {Restore old trigmode}
          ToRad:=OldToRad;
          FromRad:=OldFromRad;
          IsNotRad:=OldRad;

          If ((FPosition<50)And(pt.x<MiddleX)And(pt.y<MiddleY)) Then Angle:=180
          Else If ((FPosition>50)And(pt.x>MiddleX)And(pt.y<MiddleY)) Then Angle:=0;
     End;
End;

{$HINTS OFF}
Procedure TVolumeControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONgiNT);
Var MiddleX,MiddleY,CircleRadius:LONGINT;
    Angle:LONGINT;
    rec:TRect;
Label found;
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Button <> mbLeft Then exit;

     GetCircleParams(MiddleX,MiddleY,CircleRadius);

     If InsideCircle(MiddleX,MiddleY,CircleRadius Div 2,Point(X,Y),Angle) Then
     Begin
found:
          MouseCapture:=TRUE;
          FHasCapture:=TRUE;
          FTimerEndPos:=100-round((Angle*100) / 180);
          FAngleTimer.Create(Self);
          Include(FAngleTimer.ComponentState, csDetail);
          FAngleTimer.OnTimer:=EvTimer;
          FAngleTimer.Interval:=30;
          FAngleTimer.Start;
     End
     Else
     Begin
          If Y>=MiddleY Then
           If InsideCircle(MiddleX,MiddleY,(CircleRadius+30) Div 2,Point(X,Y),Angle) then
             Goto found;

          If ((Y>=5)And(Y<=20)) Then //test boxes
          Begin
               If ((X>=1)And(X<=16)And(FPosition>0)) Then {minus}
               Begin
                    rec.Left:=1;
                    rec.Right:=16;
                    FTimerEndPos:=0;
                    Position:=Position-1;
               End
               Else If ((X>=Width-16)And(X<=Width-1)And(FPosition<100)) Then {plus}
               Begin
                    rec.Left:=Width-16;
                    rec.Right:=Width-1;
                    FTimerEndPos:=100;
                    Position:=Position+1;
               End
               Else exit;

               PositionChanged;
               rec.Bottom:=5;
               rec.Top:=20;
               Canvas.ShadowedBorder(rec,clBlack,clWhite);
               MouseCapture:=TRUE;
               FHasCapture:=FALSE;
               FAngleTimer.Create(Self);
               Include(FAngleTimer.ComponentState, csDetail);
               FAngleTimer.OnTimer:=EvTimer;
               FAngleTimer.Interval:=250;
               FAngleTimer.Start;
          End;
     End;
End;

Procedure TVolumeControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LONGInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If Button <> mbLeft Then exit;

     If MouseCapture Then If FAngleTimer<>Nil Then
     Begin
          FAngleTimer.Stop;
          FAngleTimer.Destroy;
          FAngleTimer:=Nil;
          MouseCapture:=FALSE;
          FHasCapture:=FALSE;
          DrawBoxes;
     End;
End;


Procedure TVolumeControl.MouseMove(ShiftState:TShiftState;X,Y:LONGINT);
Var MiddleX,MiddleY,CircleRadius:LONGINT;
    Angle:LONGINT;
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FHasCapture Then
     Begin
          GetCircleParams(MiddleX,MiddleY,CircleRadius);

          InsideCircle(MiddleX,MiddleY,CircleRadius Div 2,Point(X,Y),Angle);
          FAngleTimer.Stop;
          FTimerEndPos:=100-round((Angle*100) Div 180);
          If FTimerEndPos<FPosition Then Position:=Position-1
          Else If FTimerEndPos>FPosition Then Position:=Position+1;
          PositionChanged;
          FAngleTimer.Start;
     End;
End;
{$HINTS ON}

Procedure TVolumeControl.EvTimer(Sender:TObject);
Var t,Ende:LONGINT;
Begin
     If Sender=FAngleTimer Then
     Begin
          If FTimerEndPos=FPosition Then
          Begin
               FAngleTimer.Stop;
               exit;
          End;

          If MouseCapture Then Ende:=6  //not boxes
          Else Ende:=1;

          For t:=1 To Ende Do
          Begin
               If FTimerEndPos<FPosition Then Position:=Position-1
               Else If FTimerEndPos>FPosition Then Position:=Position+1;
               PositionChanged;
          End;
     End;
End;

Procedure TVolumeControl.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='VolumeControl';
     Width:=75;
     Height:=75;
     ParentPenColor:=TRUE;
     ParentColor:=TRUE;
     FPosition:=100;
     FHasCapture:=FALSE;
End;

Procedure TVolumeControl.GetCircleParams(Var MiddleX,MiddleY,CircleRadius:LONGINT);
Begin
     MiddleX:=Width Div 2;
     MiddleY:=Height Div 2;
     If Height>Width Then CircleRadius:=Width-30
     Else CircleRadius:=Height-30;
     If CircleRadius And 1<>0 Then inc(CircleRadius);
End;

Procedure TVolumeControl.DrawSlider;
Var  MiddleX,MiddleY:LONGINT;
     CircleRadius:LONGINT;
     Angle:EXTENDED;
Begin
     GetCircleParams(MiddleX,MiddleY,CircleRadius);
     Angle:=((100-FPosition)*180) / 100;
     Canvas.Pen.Style:=psClear;
     Canvas.Arc(MiddleX,MiddleY,(CircleRadius-6) Div 2,(CircleRadius-6) Div 2,Angle,0);
     Canvas.Pen.Style:=psSolid;
     Canvas.LineTo(MiddleX,MiddleY);
End;

Procedure TVolumeControl.SetPosition(NewPosition:BYTE);
Begin
     If NewPosition=FPosition Then exit;
     If NewPosition>100 Then NewPosition:=100;
     If Handle<>0 Then
     Begin
          Canvas.Pen.Color:=Color;
          DrawSlider; {erase old slider}
          FPosition:=NewPosition;
          Canvas.Pen.Color:=clBlack;
          DrawSlider; {draw new slider}
     End
     Else FPosition:=NewPosition;
End;

Procedure TVolumeControl.DrawBoxes;
Var rec:TRect;
Begin
     rec.Left:=1;
     rec.Right:=16;
     rec.Bottom:=5;
     rec.Top:=20;
     Canvas.ShadowedBorder(rec,clWhite,clBlack);
     rec.Left:=Width-16;
     rec.Right:=Width-1;
     Canvas.ShadowedBorder(rec,clWhite,clBlack);

     Canvas.Line(4,12,13,12);
     Canvas.Line(Width-13,12,Width-4,12);
     Canvas.Line(Width-8,8,Width-8,17);
End;

Procedure TVolumeControl.Redraw(Const rec:TRect);
Var MiddleX,MiddleY:LONGINT;
    CircleRadius:LONGINT;

    Procedure DrawLines(Radius:LONGINT);
    Var t:LONGINT;
        ptStart:TPoint;
        Angle:EXTENDED;
    Begin
         Angle:=0;
         For t:=1 To 34 Do
         Begin
              Canvas.Pen.Style:=psClear;
              Canvas.Arc(MiddleX,MiddleY,Radius Div 2,Radius Div 2,Angle,0);
              ptStart:=Canvas.PenPos;
              Canvas.Arc(MiddleX,MiddleY,(Radius+15) Div 2,(Radius+15) Div 2,Angle,0);
              Canvas.Pen.Style:=psSolid;
              Canvas.LineTo(ptStart.X,ptStart.Y);
              Angle:=Angle + 180/33;
         End;
    End;

Begin
     Canvas.FillRect(rec,Color);

     GetCircleParams(MiddleX,MiddleY,CircleRadius);
     Canvas.Pen.Width:=2;
     Canvas.Pen.Color:=clBlack;
     Canvas.Circle(MiddleX,MiddleY,CircleRadius Div 2);
     Canvas.Pen.Color:=clWhite;
     Canvas.Arc(MiddleX,MiddleY,(CircleRadius-2) Div 2,(CircleRadius-2) Div 2,30,180);
     Canvas.Pen.Color:=clDkGray;
     Canvas.Arc(MiddleX,MiddleY,(CircleRadius-2) Div 2,(CircleRadius-2) Div 2,240,130);

     Canvas.Pen.Width:=1;
     Canvas.Pen.Color:=PenColor;
     Canvas.Brush.Color:=Color;
     DrawLines(CircleRadius+10);
     DrawSlider;
     DrawBoxes;
End;

Destructor TVolumeControl.Destroy;
Begin
     If FAngleTimer<>Nil Then FAngleTimer.Destroy;
     FAngleTimer:=Nil;
     Inherited Destroy;
End;

Procedure TVolumeControl.PositionChanged;
Begin
     If OnPositionChanged<>Nil Then OnPositionChanged(Self);
End;


Begin
End.

