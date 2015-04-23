{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit Graphics;

Interface

{$IFDEF OS2}
Uses PmWin,PmGpi,PmBitmap,PmDev,Os2Def,BseDos;
{$ENDIF}

{$IFDEF Win95}
Uses WinNt,WinDef,WinGDI,WinUser,WinBase;
{$ENDIF}

Uses Dos,SysUtils,Classes,Forms;


Type
    EInvalidBitmap=Class(Exception);
    EInvalidIcon=Class(Exception);
    EInvalidCursor=Class(Exception);
    EInvalidPictureFormat=Class(Exception);

Type
    TMetaFile=Class;

    TMetafileCanvas=Class(TCanvas)
      Protected
         FMetafile:TMetafile;
      Public
         Constructor Create(AMetafile: TMetafile);Virtual;
         Destructor Destroy;Override;
    End;

    TMetafile=Class(TGraphic)
      Protected
          FDeviceHandle:LongWord;
          FHandle:LongWord;
          FMetaFileCanvas:TMetaFileCanvas;
      Protected
          Procedure GetOriginalRect(Var Rect: RECTL);
          Function GetEmpty: Boolean;Override;
          Function GetHeight:LongInt;Override;
          Function GetWidth:LongInt;Override;
          Procedure SetHeight(Value:LongInt);Override;
          Procedure SetWidth(Value:LongInt);Override;
          Function GetHandle:LongWord;Override;
          Function GetCanvas:TCanvas;Override;
          Function GetSize:LongInt;Override;
          Procedure PaletteChanged;Override;
          Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Override;
      Public
          Function LoadFromClipBoard:Boolean;
          Procedure Assign(Source:TPersistent);Override;
          Function CreateMask(Color:TColor):TGraphic;Override;
          Procedure PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);Override;
          Procedure Draw(ACanvas: TCanvas;Const Rect: TRect);Override;
          Procedure SetupComponent;Override;
          Destructor Destroy;Override;
          Procedure LoadFromStream(Stream: TStream);Override;
          Procedure LoadFromFile(Const FileName:String);Override;
          Procedure SaveToFile(const Filename: String);Override;
          Procedure SaveToStream(Stream: TStream);Override;
          Function CopyGraphic:TGraphic;Override;
          Procedure LoadFromHandle(Handle:LongWord);Override;
      Public
          Property Device:LongWord read FDeviceHandle write FDeviceHandle;
    End;

    TBitmap=Class;

    TBitmapCanvas=Class(TCanvas)
       Protected
            FBitmap:TBitmap;
       Public
            Procedure CreateHandle;Override;
            Procedure DestroyHandle;Override;
    End;

    {$HINTS OFF}
    TBitmap=Class(TGraphic)
      Protected
         FHeight:LongInt;
         FWidth:LongInt;
         FEmpty:Boolean;
         FOrigin:TBitmap;
         FBitmapHandle:LongWord;
         FBitmapPS:LongWord;
         FBitmapDC:LongWord;
         FScalX,FScalY:LongWord;
         FBitmapPal:LongWord;
         FColorCount:LongInt;
         FOrigBitCount,FOrigPlanes:LongInt; //original BitCount, also used For Saving
         FOldBitmap:LongWord;
         FOldPalette:LongWord;
         FBitmapMem:Pointer;
         FBitmapMemLength:LongInt;
         FCanvas:TBitmapCanvas;
         FXHotSpot,FYHotSpot:LongInt;
         FIsInvalid:Boolean;
      Protected
         Procedure NewImage(BitmapData:Pointer;BitmapSize,OffsBits:LongWord;Mask:Boolean);
         Procedure SetupBitmapColors(Header:Pointer;Mask:Boolean);
         Function GetEmpty:Boolean;Override;
         Function GetHeight:LongInt;Override;
         Procedure SetHeight(NewHeight:LongInt);Override;
         Function GetWidth:LongInt;Override;
         Procedure SetWidth(NewWidth:LongInt);Override;
         Procedure ReadStream(Stream:TStream;Size:LongInt);Virtual;
         Procedure ReleaseBitmap;Virtual;
         Procedure SetupBitmap;Virtual;
         Function GetHandle:LongWord;Override;
         Function GetCanvas:TCanvas;Override;
         Function GetSize:LongInt;Override;
      Protected
         PermanentHandle:Boolean;
         Procedure SetupComponent;Override;
         Procedure Changed;Override;
         Procedure InvalidImage;Virtual;
         Procedure PaletteChanged;Override;
         Procedure Update;Virtual;
      Public
         Procedure CreateHandle;Virtual;
         Procedure DestroyHandle;Virtual;
         Procedure Assign(Source:TPersistent);Override;
         Procedure CopyToClipboard(Const Src:TRect);
         Function LoadFromClipBoard:Boolean;
         // create mask containing 0 in areas that are the transparent color
         Function CreateMask( Color: TColor ): TGraphic; Override;
         // create mask, using (0,0) for transparent color
         Function CreateAutoMask: TBitmap;
         // create a new copy, masking off the areas in the mask that are 0
         // this masked version can then be used with DrawMasked.
         Function CopyMasked( Mask: TBitmap ): TBitmap;
         // draw onto canvas, assuming this bitmap is premasked (e.g. came from CopyMasked)
         // and using the given Mask
         Procedure DrawMasked( DestCanvas: TCanvas;
                               Mask: TBitmap;
                               SrcRect: TRect;
                               X,Y: longint );
         // draw bitmap, masked and halftoned.
         Procedure DrawMaskedDisabled( DestCanvas: TCanvas;
                                       Mask: TBitmap;
                                       SrcRect: TRect;
                                       X,Y: longint );

         Destructor Destroy;Override;
         Procedure LoadFromStream(Stream:TStream);Override;
         Procedure SaveToStream(Stream:TStream);Override;
         Procedure LoadFromResourceId(Id:LongWord);Override;
         Procedure LoadFromResourceName(Const Name:String);Override;
         Procedure LoadFromMem(Var Buf;Size:LongInt);Override;
         Procedure LoadFromBitmap(Bitmap:TBitmap);
         Procedure LoadFromHandle(AHandle:LongWord);Override;
         Function CopyGraphic:TGraphic;Override;
         Function Copy:TBitmap;
         Procedure Draw(Canvas:TCanvas;Const Dest:TRect);Override;
         Procedure DrawBitmapBits(SrcRec: TRect;Canvas: TCanvas;DstRec: TRect);
         Procedure PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);Override;
         Procedure DrawDisabled(Canvas:TCanvas;Const Dest:TRect);Virtual;
         Procedure RealizePalette(Canvas:TCanvas);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Function WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceName):Boolean;Override;
         Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Override;
         Function IsEqual(Bitmap:TBitmap):Boolean;
         Property Device:LongWord Read FBitmapDC;
         Property ColorCount:LongInt Read FColorCount;
         Procedure ReleaseMemoryCopy; // releases the in-memory copy of the bitmap.
    End;
    {$HINTS ON}

    TBitmapClass=Class Of TBitmap;


    TIcon=Class(TBitmap)
      Protected
         FMaskHandle:LongWord;
         FMaskDC:LongWord;
         FMaskPS:LongWord;
         FMaskPal:LongWord;
         FMaskColorCount:LongWord;
         FMaskWidth,FMaskHeight:LongWord;
         FIconPointerHandle:LongWord;
         FMaskCanvas:TBitmapCanvas;
         FOldMaskBitmap:LongWord;
         FOldMaskPalette:LongWord;
         Procedure SetupBitmap;Override;
         Function GetHandle:LongWord;Override;
         Procedure ReleaseBitmap;Override;
         Function GetMaskCanvas:TCanvas;
      Protected
         Procedure SetupComponent;Override;
         Procedure InvalidImage;Override;
         Procedure CreateIconPointerHandle;
      Public
         Procedure Draw(Canvas:TCanvas;Const Dest:TRect);Override;
         Procedure CreateHandle;Override;
         Procedure DestroyHandle;Override;
         Procedure Update;Override;
         Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Override;
         Procedure LoadFromResourceName(Const Name:String);Override;
         Property MaskHandle:LongWord Read FMaskHandle;
         Property ColorHandle:LongWord Read FBitmapHandle;
         Property MaskPresentationSpaceHandle:LongWord Read FMaskPS;
         Property MaskDevice:LongWord Read FMaskDC;
         Property MaskWidth:LongWord Read FMaskWidth;
         Property MaskHeight:LongWord Read FMaskHeight;
         Property MaskPalette:LongWord Read FMaskPal;
         Property MaskCanvas:TCanvas Read GetMaskCanvas;
    End;


    TPointer=Class(TIcon)
      Protected
         Procedure SetupComponent;Override;
         Procedure InvalidImage;Override;
         Property XHotSpot:LongInt Read FXHotSpot Write FXHotSpot;
         Property YHotSpot:LongInt Read FYHotSpot Write FYHotSpot;
    End;

    TBitmapList=Class(TList)
      Protected
         FDuplicates:Boolean; {only For Add}
         FBitmapClass:TBitmapClass;
         Function CopyBitmap(original:TBitmap):TBitmap;
         Function GetBitmap(Index:LongInt):TBitmap;
         Procedure SetBitmap(Index:LongInt;Bitmap:TBitmap);
         Property Items;
      Protected
        Procedure FreeItem(Item:Pointer);Override;
      Public
         Function Add(Item:TBitmap):LongInt;
         Procedure Insert(Index:LongInt;Item:TBitmap);
         Function IndexOfOrigin(Item:TBitmap):LongInt;
         Function AddResourceId(BmpId:LongWord):LongInt;
         Function AddResourceName(Const Name:String):LongInt;
         Property Bitmaps[Index:LongInt]:TBitmap Read GetBitmap Write SetBitmap;
         Property Duplicates:Boolean Read FDuplicates Write FDuplicates;
         Property BitmapClass:TBitmapClass Read FBitmapClass Write FBitmapClass;
    End;

    TResType=(rtBitmap,rtCursor,rtIcon);

    TImageType=(itImage,itMask);

    TOverlay = 0..3;

    TLoadResource=(lrDefaultColor, lrDefaultSize, lrFromFile,
                   lrMap3DColors, lrTransparent, lrMonoChrome);

    TLoadResources=Set Of TLoadResource;

    //Item for BitmapList property of TImageList class
    PImageItem=^TImageItem;
    TImageItem=Record
                     Bitmap:TBitmap;
                     Mask:TBitmap;
                     Icon:TIcon;
    End;

    TImageList=Class;

    TImageItemList=Class(TList)
       ImageList:TImageList;
    END;

    TImageList=Class(TComponent)
        Protected
              FMasked:Boolean;
              FImageType:TImageType;
              FOnChange:TNotifyEvent;
              FList:TImageItemList;
        Protected
              Function GetCount:LongInt;
              Procedure SetList(Item:TImageItemList);
        Protected
              Procedure Change;Virtual;
              Procedure Initialize;
              Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
              Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
              Function NewItem:PImageItem;Virtual;
              Procedure DisposeItem(Item:PImageItem);Virtual;
        Public
              Procedure SetupComponent;Override;
              Destructor Destroy;Override;
              Function Add(Image,Mask:TBitmap):LongInt;
              Function AddIcon(Image:TIcon):LongInt;
              Procedure AddImages(Value:TImageList);
              Procedure Clear;
              Procedure Delete(Index:LongInt);
              Procedure Draw(Canvas:TCanvas;X,Y,Index:LongInt);
              Procedure GetBitmap(Index:LongInt;Image:TBitmap);

              // Gets a reference to the internal bitmap,
              // rather than making a copy.
              Function GetBitmapReference( Index:LongInt ): TBitmap;

              Procedure GetMask(Index:LongInt;Mask:TBitmap);
              Procedure GetIcon(Index: Integer;Icon:TIcon);
              Procedure Insert(Index:LongInt;Image,Mask:TBitmap);
              Procedure InsertIcon(Index:LongInt;Image:TIcon);
              Procedure Move(CurIndex,NewIndex:LongInt);
              Procedure Replace(Index:LongInt;Image,Mask:TBitmap);
              Procedure ReplaceIcon(Index:LongInt;Image:TIcon);
        Public
              Property Count:LongInt read GetCount;
        Published
              Property ImageType:TImageType read FImageType write FImageType;
              Property Masked:Boolean read FMasked write FMasked;
              Property OnChange: TNotifyEvent read FOnChange write FOnChange;
              Property BitmapList:TImageItemList read FList write SetList;stored False;
    End;

    TPicture=Class(TComponent)
       Protected
           FGraphic:TGraphic;
           FOnChange:TNotifyEvent;
       Protected
           Function GetBitmap:TBitmap;
           Function GetHeight:LongInt;
           Function GetIcon:TIcon;
           Function GetMetafile:TMetafile;
           Function GetWidth:LongInt;
           Procedure SetBitmap(Value: TBitmap);
           Procedure SetGraphic(Value: TGraphic);
           Procedure SetIcon(Value: TIcon);
           Procedure SetMetafile(Value: TMetafile);
           Function GetEmpty:Boolean;
       Protected
           Procedure Changed(Sender: TObject);
           Procedure AssignTo(Dest:TPersistent);Override;
       Public
           Destructor Destroy;Override;
           Procedure LoadFromFile(Const Filename:string);
           Procedure SaveToFile(Const Filename: string);
           Procedure ForceType(GraphicType:TGraphicClass);
       Public
           Function HasFormat(GraphicClass:TGraphicClass):Boolean;
           Procedure Assign(Source:TPersistent);Override;
       Public
           Property Empty:Boolean read GetEmpty;
           Property Bitmap:TBitmap read GetBitmap write SetBitmap;
           Property Graphic:TGraphic read FGraphic write SetGraphic;
           Property Height:LongInt read GetHeight;
           Property Icon:TIcon read GetIcon write SetIcon;
           Property Metafile:TMetafile read GetMetafile write SetMetafile;
           Property Width:LongInt read GetWidth;
           Property OnChange:TNotifyEvent read FOnChange write FOnChange;
    End;


Implementation


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBitmapCanvas Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TBitmapCanvas.CreateHandle;
Begin
    If FBitmap<>Nil Then FBitmap.CreateHandle;
End;

Procedure TBitmapCanvas.DestroyHandle;
Begin
     If FBitmap<>Nil Then FBitmap.DestroyHandle;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBitmap Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBitmap.CreateHandle;
Begin
     If FIsInvalid Then exit; //don't create handle for invalid objects (loop) !

     {$IFDEF WIN32}
     If FBitmapHandle=0 Then If FBitmapMem<>Nil Then
     Begin
          If FBitmapPS<>0 Then DestroyHandle;
          SetupBitmap;
     End;
     If FBitmapHandle=0 Then InvalidImage;
     If FBitmapPS=0 Then
     Begin
         FBitmapPS:=CreateCompatibleDC(0);
         FOldBitmap:=SelectObject(FBitmapPS,FBitmapHandle);
     End;
     If FCanvas = Nil Then
     Begin
          FCanvas.Create(Self);
          FCanvas.FBitmap:=Self;
          Include(FCanvas.ComponentState, csDetail);
     End;
     If FCanvas.Handle<>FBitmapPS Then
     Begin
        FCanvas.Handle:=FBitmapPS;
        FCanvas.Init;
        RealizePalette(Nil);
     End;
     {$ENDIF}
End;

Procedure TBitmap.DestroyHandle;
Begin
     If PermanentHandle Then exit;

     {$IFDEF WIN32}
     If FBitmapPal<>0 Then
       If FBitmapPS<>0 Then SelectObject(FBitmapPS,FOldPalette);
     FOldPalette:=0;
     If FBitmapPS<>0 Then
     Begin
          SelectObject(FBitmapPS,FOldBitmap);
          If not DeleteDC(FBitmapPS) Then InvalidImage;
     End;
     FBitmapPS:=0;
     If FCanvas<>Nil Then FCanvas.Handle:=0;
     FOldBitmap:=0;
     If FBitmapHandle<>0 Then If not DeleteObject(FBitmapHandle) Then InvalidImage;
     FBitmapHandle:=0;
     {$ENDIF}
End;

Procedure TBitmap.DrawBitmapBits(SrcRec: TRect;Canvas: TCanvas;DstRec: TRect);
{$IFDEF OS2}
Var
  DC:     HDC;
  PS:     HPS;
  BM:     HBITMAP;
  Size:   SIZEL;
  Points: array[0..1] of TRect;
{$ENDIF}
Begin
  {$IFDEF OS2}
  If Canvas = nil Then Exit;

  DC := 0;
  PS := 0;

  Try
    DC := DevOpenDC(AppHandle, OD_MEMORY, '*', 0,Nil, GpiQueryDevice(Canvas.Handle));

    Size.CX := 0;
    Size.CY := 0;

    PS := GpiCreatePS(AppHandle, DC, Size,PU_PELS or GPIT_MICRO or GPIA_ASSOC);

    BM := Handle;
    Try
      GpiSetBitmap(Self.Canvas.Handle, 0);
      GpiSetBitmap(PS, BM);

      Points[0] := DstRec;
      Points[1] := SrcRec;

      GpiBitBlt(Canvas.Handle,
                PS,
                4,
                Points[0].LeftBottom,
                ROP_SRCCOPY,
                BBO_IGNORE);

    Finally
      GpiSetBitmap(PS, 0);
      GpiSetBitmap(Self.Canvas.Handle, BM);
    End;

  Finally
    If PS <> 0 Then GpiDestroyPS(PS);
    If DC <> 0 Then DevCloseDC(DC);
  End;
  {$ENDIF}
End;

{$HINTS OFF}
Function TBitmap.CreateMask( Color:TColor ):TGraphic;
{$IFDEF OS2}
Var Mask: TBitmap;
    X,Y: longint;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Mask := TBitmap.Create;
     Mask.CreateNew( Width, Height, 2 );
//     Mask.Canvas.Palette.Colors[ 0 ] := clBlack;
//     Mask.Canvas.Palette.Colors[ 0 ] := clWhite;
     For Y := 0 to Height - 1 do
       For X := 0 to Width - 1 do
         if Canvas.Pixels[ X, Y ] = Color Then
           Mask.Canvas.Pixels[ X, Y ] := 0
         else
           Mask.Canvas.Pixels[ X, Y ] := 1;

     Result := Mask;
     {$ENDIF}
End;
{$HINTS ON}

Function TBitmap.CreateAutoMask:TBitmap;
Begin
  Result := TBitmap( CreateMask( Canvas.Pixels[ 0, 0 ] ) );
End;

Function TBitmap.CopyMasked( Mask:TBitmap ):TBitmap;
Var
  aRect: TRect;
Begin
  Result := self.Copy;
  aRect := Rect( 0, 0, Width, Height );

  // clear out areas of the new bitmap, where mask is 0
  Mask.Canvas.BitBlt( Result.Canvas,
                      aRect,
                      aRect,
                      cmSrcAnd,
                      bitFIgnore ); // scaling is irrelevant anyway
End;

Procedure TBitmap.DrawMasked( DestCanvas: TCanvas;
                              Mask: TBitmap;
                              SrcRect: TRect;
                              X,Y: longint );
Var
  DestRect: TRect;
  OldBrushColor: TColor;
  OldPenColor: TColor;
Begin
  DestRect := Rect( X, Y,
                    X + SrcRect.Right - SrcRect.Left,
                    Y + SrcRect.Top - SrcRect.Bottom );

  if ( Mask.Width <> Width )
    or ( Mask.Height <> Height ) then
    raise Exception.Create( 'TBitmap.DrawMasked: mask dimensions do not match bitmap' );

  OldBrushColor := DestCanvas.Brush.Color;
  OldPenColor := DestCanvas.Pen.Color;

  // set black and white since this is used
  // to translate mask before bitblt
  DestCanvas.Brush.Color := clWhite;
  DestCanvas.Pen.Color := clBlack;

  // clear areas to draw on in dest
  Mask.Canvas.BitBlt( DestCanvas,
                      DestRect,
                      SrcRect,
                      cmNotSrcAndDest,
                      bitFIgnore ); // scaling is irrelevant anyway

  // OR ourselves onto the dest
  Canvas.BitBlt( DestCanvas,
                 DestRect,
                 SrcRect,
                 cmSrcPaint,  // equivalent to OR
                 bitFIgnore ); // scaling is irrelevant anyway

  DestCanvas.Brush.Color := OldBrushColor;
  DestCanvas.Pen.Color := OldPenColor;

End;

Procedure TBitmap.DrawMaskedDisabled( DestCanvas: TCanvas;
                                      Mask: TBitmap;
                                      SrcRect: TRect;
                                      X,Y: longint );
Var
  DestRect: TRect;
  OldBrushColor: TColor;
  OldPenColor: TColor;
  OldBrushStyle: TBrushStyle;
Begin
  DestRect := Rect( X, Y,
                    X + SrcRect.Right - SrcRect.Left,
                    Y + SrcRect.Top - SrcRect.Bottom );

  if ( Mask.Width <> Width )
    or ( Mask.Height <> Height ) then
    raise Exception.Create( 'TBitmap.DrawMasked: mask dimensions do not match bitmap' );

  OldBrushColor := DestCanvas.Brush.Color;
  OldPenColor := DestCanvas.Pen.Color;
  OldBrushStyle := DestCanvas.Brush.Style;

  // set black and white since this is used
  // to translate mask before bitblt
  DestCanvas.Brush.Color := clWhite;
  DestCanvas.Pen.Color := clBlack;

  // set half tone pattern which we will combine with when drawing...
  DestCanvas.Brush.Style := bsHalfTone;

  // clear areas to draw on in dest
  // (which is areas where the mask is 1 and the pattern is 1)
  Mask.Canvas.BitBlt( DestCanvas,
                      DestRect,
                      SrcRect,
                      cmSrcAndPatErase,
                      bitFIgnore ); // scaling is irrelevant anyway

  // OR ourselves onto the dest
  Canvas.BitBlt( DestCanvas,
                 DestRect,
                 SrcRect,
                 cmSrcAndPatOrDest,
                 bitFIgnore ); // scaling is irrelevant anyway}

  DestCanvas.Brush.Color := OldBrushColor;
  DestCanvas.Pen.Color := OldPenColor;
  DestCanvas.Brush.Style := OldBrushStyle;
End;

Var LastcbInfo:LongWord;

Procedure TBitmap.LoadFromHandle(AHandle:LongWord);
Var
   TheBitmapMem:^LongInt;
   TheBitmapMemLength:LongInt;
{$IFDEF OS2}
Var
   hdcDst:LongInt;
   hpsDst:LongInt;
   bmpTemp:BITMAPINFOHEADER2;
   sizl:SIZEL;
   HPS:LongWord;
   rclTemp:TRect;
   ptlDst:POINTL;
Label ex;
{$ENDIF}
{$IFDEF Win95}
Var
    BI:BitmapCoreInfo;
    pbi:^BitmapCoreInfo;
    P,pp:Pointer;
    cbInfo,cbBuffer:LongWord;
    BI2:BitmapInfo;
    ADC,MemDC:LongWord;
{$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !
     ReleaseBitmap;

     {$IFDEF OS2}
     HPS:=WinGetPS(HWND_DESKTOP);

     bmpTemp.cbFix := SizeOf(BITMAPINFOHEADER2);
     GpiQueryBitmapInfoHeader(AHandle,bmpTemp);
     FBitmapHandle:=GpiCreateBitmap(HPS,bmpTemp,0,Nil,Nil);
     If FBitmapHandle=0 Then Exit;

     rclTemp.Left := 0;
     rclTemp.Right := bmpTemp.CX;
     rclTemp.Bottom := 0;
     rclTemp.Top := bmpTemp.CY;

     hdcDst := DevOpenDC(AppHandle,OD_MEMORY,'*',0,Nil,0);
     If hdcDst=0 Then
     Begin
          GpiDeleteBitmap(FBitmapHandle);
          Goto ex;  //Error
     End;

     sizl.CX := 1{bmpTemp.CX};
     sizl.CY := 1{bmpTemp.CY};
     hpsDst := GpiCreatePS(AppHandle, hdcDst, sizl,
                           PU_PELS Or GPIA_ASSOC Or GPIT_MICRO
                           {PU_PELS Or GPIF_DEFAULT Or GPIT_MICRO Or GPIA_ASSOC});
     If hpsDst=0 Then
     Begin
          GpiDeleteBitmap(FBitmapHandle);
          DevCloseDC(hdcDst);
          Goto ex; //Error
     End;

     //GpiSetBitmap(hpsSrc, hbmSrc);
     GpiSetBitmap(hpsDst, FBitmapHandle);
     FBitmapPS:=hpsDst;

     ptlDst.X:=0;
     ptlDst.Y:=0;
     WinDrawBitmap(hpsDst,AHandle,Nil,ptlDst,0,0,DBM_NORMAL Or DBM_IMAGEATTRS);
     Update;

     GpiSetBitmap(hpsDst,0);
     GpiDestroyPS(hpsDst);
     FBitmapPS:=0;
     DevCloseDC(hdcDst);
     GpiDeleteBitmap(FBitmapHandle);
     FBitmapHandle:=0;

     TheBitmapMem:=FBitmapMem;
     FBitmapMem:=Nil;
     TheBitmapMemLength:=FBitmapMemLength;
     FBitmapMemLength:=0;
     FBitmapHandle:=0;
     FBitmapPS:=0;
     If TheBitmapMemLength>0 Then
     Begin
          LoadFromMem(TheBitmapMem^,TheBitmapMemLength);
          FreeMem(TheBitmapMem,TheBitmapMemLength);
     End;
ex:
     WinReleasePS(HPS);
     {$ENDIF}
     {$IFDEF WIN32}
     ADC:=GetDC(0);
     MemDC:=CreateCompatibleDC(ADC);

     FillChar(BI,SizeOf(BI),0);

     FillChar(BI2,SizeOf(BI2),0);
     BI2.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(ADC,AHandle,0,0,Nil,BI2,0);
     If FOrigBitCount>0 Then BI2.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI2.bmiHeader.biPlanes:=FOrigPlanes;

     cbInfo:=SizeOf(BitmapCoreHeader)+SizeOf(RGBTriple)*(1 Shl BI2.bmiHeader.biBitCount);
     LastcbInfo:=cbInfo;
     GetMem(pbi,cbInfo);
     With pbi^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=BI2.bmiHeader.biWidth;
          bcHeight:=BI2.bmiHeader.biHeight;
          bcPlanes:=BI2.bmiHeader.biPlanes;
          bcBitCount:=BI2.bmiHeader.biBitCount;
     End;
     cbBuffer:=(((BI2.bmiHeader.biBitCount*BI2.bmiHeader.biWidth)+31) Div 32)
                *4*BI2.bmiHeader.biHeight*BI2.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(ADC,AHandle,0,BI2.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=cbInfo+cbBuffer;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);

     FreeMem(pbi,cbInfo);
     FreeMem(P,cbBuffer);

     If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
     If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;
     {$ENDIF}

     FBitmapHandle:=0;

     TheBitmapMem:=FBitmapMem;
     FBitmapMem:=Nil;
     TheBitmapMemLength:=FBitmapMemLength;
     FBitmapMemLength:=0;
     FBitmapHandle:=0;
     FBitmapPS:=0;
     If TheBitmapMemLength>0 Then
     Begin
          LoadFromMem(TheBitmapMem^,TheBitmapMemLength);
          FreeMem(TheBitmapMem,TheBitmapMemLength);
     End;
End;

Function TBitmap.LoadFromClipBoard:Boolean;
Var hbmClipbrd:LongWord;
Begin
     FIsInvalid:=False; //reset flag !

     Result:=False;
     Clipboard.Open(Handle);
     If Clipboard.IsFormatAvailable(cfBitmap) Then
     Begin
          hbmClipbrd:=Clipboard.GetData(cfBitmap);
          If hbmClipbrd<>0 Then
          Begin
               LoadFromHandle(hbmClipbrd);
               Result:=Not Empty;
          End;
     End;

     Clipboard.Close;
End;

Procedure TBitmap.Assign(Source:TPersistent);
Begin
     If Source Is TBitmap Then LoadFromBitmap(TBitmap(Source))
     Else Inherited Assign(Source);
End;

Procedure TBitmap.CopyToClipboard(Const Src:TRect);
{$IFDEF OS2}
Var HPS:LongWord;
    bmpClipbrd:BITMAPINFOHEADER2;
    rclClipbrd:TRect;
    hbmClipbrd:HBITMAP;
    hpsDst,hdcDst:LongWord;
    bmp:BITMAPINFOHEADER2;
    sizl:SIZEL;
    aptl:Array[0..3] Of POINTL;
{$ENDIF}
{$IFDEF WIN32}
Var
   hbmClipBrd,Temp:HBITMAP;
   ScreenDC:HDC;
   hdcDst,hdcSrc:HDC;
{$ENDIF}
Begin
{$IFDEF OS2}
     If Handle=0 Then Exit;

     HPS:=WinGetPS(HWND_DESKTOP);

     bmpClipbrd.cbFix := SizeOf(BITMAPINFOHEADER2);
     GpiQueryBitmapInfoHeader(Handle,bmpClipbrd);
     bmpClipbrd.CX:=Src.Right-Src.Left;
     bmpClipbrd.CY:=Src.Top-Src.Bottom;
     hbmClipbrd:=GpiCreateBitmap(HPS,bmpClipbrd,0,Nil,Nil);
     If hbmClipbrd=0 Then Exit;

     rclClipbrd.Left := 0;
     rclClipbrd.Right := bmpClipbrd.CX;
     rclClipbrd.Bottom := 0;
     rclClipbrd.Top := bmpClipbrd.CY;

     hdcDst := DevOpenDC(AppHandle,OD_MEMORY,'*',0,Nil,0);
     If hdcDst=0 Then
     Begin
          GpiDeleteBitmap(hbmClipbrd);
          WinReleasePS(HPS);
          exit;
     End;

     bmp.cbFix := SizeOf(BITMAPINFOHEADER2);
     GpiQueryBitmapInfoHeader(hbmClipbrd, bmp);
     sizl.CX := 1{bmp.CX};
     sizl.CY := 1{bmp.CY};
     hpsDst := GpiCreatePS(AppHandle, hdcDst, sizl,
                           PU_PELS Or GPIA_ASSOC Or GPIT_MICRO
                           {PU_PELS Or GPIF_DEFAULT Or GPIT_MICRO Or GPIA_ASSOC});
     If hpsDst=0 Then
     Begin
          GpiDeleteBitmap(hbmClipbrd);
          DevCloseDC(hdcDst);
          WinReleasePS(HPS);
          exit;
     End;

     //GpiSetBitmap(hpsSrc, hbmSrc);
     GpiSetBitmap(hpsDst, hbmClipbrd);

     aptl[0].X := rclClipbrd.Left;
     aptl[0].Y := rclClipbrd.Bottom;
     aptl[1].X := rclClipbrd.Right;
     aptl[1].Y := rclClipbrd.Top;
     aptl[2].X := Src.Left;
     aptl[2].Y := Src.Bottom;
     aptl[3].X := Src.Right;
     aptl[3].Y := Src.Top;

     If ((aptl[1].X-aptl[0].X=aptl[3].X-aptl[2].X)And
         (aptl[1].Y-aptl[0].Y=aptl[3].Y-aptl[2].Y)) Then
       GpiBitBlt(hpsDst,Canvas.Handle,3,aptl[0],ROP_SRCCOPY,BBO_IGNORE)
     Else
       GpiBitBlt(hpsDst,Canvas.Handle,4,aptl[0],ROP_SRCCOPY,BBO_IGNORE);

     GpiSetBitmap(hpsDst,0);
     GpiDestroyPS(hpsDst);
     DevCloseDC(hdcDst);
     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;
     ScreenDC:=GetDC(0);
     If ScreenDC=0 Then exit;
     hdcDst:=CreateCompatibleDC(ScreenDC);
     If hdcDst=0 Then
     Begin
         ReleaseDC(0,ScreenDC);
         exit;
     End;
     hbmClipBrd:=CreateCompatibleBitmap(ScreenDC,Width,Height);
     if hbmClipBrd=0 Then
     Begin
         ReleaseDC(0,ScreenDC);
         exit;
     End;
     SelectObject(hdcDst,hbmClipBrd);
     WinGDI.BitBlt(hdcDst,0,0,Width,Height,FBitmapPS,0,0,SRCCOPY);
     DeleteDC(hdcDst);
     ReleaseDC(0,ScreenDC);
     {$ENDIF}

     Clipboard.Open(0);
     Clipboard.Empty;
     Clipboard.SetData(hbmClipBrd,cfBitmap);
     Clipboard.Close;
End;

Procedure TBitmap.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Bitmap';
     FEmpty:=True;
     FBitmapHandle:=0;
     FBitmapPS:=0;
     FBitmapDC:=0;
End;

Procedure TBitmap.changed;
Begin
     Inherited changed;
     If Owner Is TControl Then TControl(Owner).Invalidate;
End;

Procedure TBitmap.PaletteChanged;
Begin
     {$IFDEF OS2}
     If FBitmapPal<>0 Then GpiDeletePalette(FBitmapPal);
     {$ENDIF}
     {$IFDEF Win95}
     If FBitmapPal<>0 Then DeleteObject(FBitmapPal);
     {$ENDIF}
     FBitmapPal:=Canvas.Palette.Handle;
End;

Procedure TBitmap.ReleaseBitmap;
Begin
     FEmpty:=True;

     If FCanvas<>Nil Then
     Begin
          FCanvas.Destroy;
          FCanvas:=Nil;
     End;

     {$IFDEF OS2}
     If FBitmapPal<>0 Then GpiDeletePalette(FBitmapPal);
     If FBitmapHandle<>0 Then
     Begin
        If FBitmapPS<>0 Then GpiSetBitmap(FBitmapPS,0);
        GpiDeleteBitmap(FBitmapHandle);
     End;
     If FBitmapPS<>0 Then GpiDestroyPS(FBitmapPS);
     If FBitmapDC<>0 Then DevCloseDC(FBitmapDC);
     {$ENDIF}
     {$IFDEF Win95}
     If FBitmapPS<>0 Then
     Begin
          If FBitmapHandle<>0 Then SelectObject(FBitmapPS,FOldBitmap);
          If FBitmapPal<>0 Then SelectObject(FBitmapPS,FOldPalette);
     End;
     If FBitmapPS<>0 Then If not DeleteDC(FBitmapPS) Then InvalidImage;
     If FBitmapPal<>0 Then If not DeleteObject(FBitmapPal) Then InvalidImage;
     If FBitmapHandle<>0 Then If not DeleteObject(FBitmapHandle) Then InvalidImage;
     {$ENDIF}
     FBitmapPS:=0;
     FBitmapPal:=0;
     FBitmapHandle:=0;
     FBitmapDC:=0;

     ReleaseMemoryCopy;
End;

Procedure TBitmap.ReleaseMemoryCopy; // releases the in-memory copy of the bitmap.
begin
     If FBitmapMemLength<>0 Then
       If FBitmapMem<>Nil Then
     Begin
          FreeMem(FBitmapMem,FBitmapMemLength);
          FBitmapMem:=Nil;
          FBitmapMemLength:=0;
     End;
end;

Destructor TBitmap.Destroy;
Begin
     ReleaseBitmap;

     Inherited Destroy;
End;

Function TBitmap.GetHandle:LongWord;
Begin
     If FBitmapHandle=0 Then If FBitmapMem<>Nil Then SetupBitmap;
     Result:=FBitmapHandle;
End;

Function TBitmap.GetSize;
Begin
     Result:=FBitmapMemLength;
End;

Function TBitmap.GetCanvas:TCanvas;
Begin
     If FBitmapPS=0 Then CreateHandle;

     If FCanvas = Nil Then
     Begin
          FCanvas.Create(Self);
          FCanvas.FBitmap:=Self;
          Include(FCanvas.ComponentState, csDetail);
          FCanvas.Handle := FBitmapPS;
          FCanvas.Init;
     End
     Else
     Begin
          If FCanvas.Handle<>FBitmapPS Then
          Begin
               FCanvas.Handle:=FBitmapPS;
               FCanvas.Init;
          End;
     End;
     Result := FCanvas;
End;

Procedure TBitmap.DrawDisabled(Canvas:TCanvas;Const Dest:TRect);
Var  OldLineWidth:LongInt;
     OldLineType:TPenStyle;
     OldBkMode:TBrushMode;
     OldColor:TColor;
     X:LongInt;
     {$IFDEF Win95}
     OldPal:LongWord;
     {$ENDIF}
Begin
     If Empty Then Exit;

     {$IFDEF OS2}
     {OldPal:=GpiQueryPalette(Canvas.Handle);
     If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,FBitmapPal);}
     {$ENDIF}
     {$IFDEF Win95}
     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);
     {$ENDIF}

     Draw(Canvas,Dest);

     OldLineWidth:=Canvas.Pen.Width;
     OldLineType:=Canvas.Pen.Style;
     OldBkMode:=Canvas.Brush.Mode;
     OldColor:=Canvas.Pen.color;

     If Canvas.Control<>Nil {typecast To have access To BackColor}
     Then Canvas.Pen.color:=TForm(Canvas.Control).color;
     Canvas.Pen.Width:=1;
     Canvas.Brush.Mode:=bmTransparent;
     Canvas.Pen.Style:=psInsideFrame; // single pixel dots.
     For X:=Dest.Left To Dest.Right Do
     Begin
          // draw alternate columns offset by 1 pixel
          // to create 50% half tone
          if ( X and 1 ) = 0 then
               Canvas.Line(X,Dest.Bottom,X,Dest.Top)
          else
               Canvas.Line(X,Dest.Bottom + 1,X,Dest.Top);
     End;

     Canvas.Pen.Width:=OldLineWidth;
     Canvas.Pen.Style:=OldLineType;
     Canvas.Brush.Mode:=OldBkMode;
     Canvas.Pen.color:=OldColor;

     {$IFDEF Win95}
     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);
     {$ENDIF}
     {$IFDEF OS2}
     {If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,OldPal);}
     {$ENDIF}
End;


Procedure TBitmap.Draw(Canvas:TCanvas;Const Dest:TRect);
Var  {$IFDEF Win95}
     _Dest:TRect;
     OldPal:LongWord;
     {$ENDIF}
     {$IFDEF OS2}
     Src:TRect;
     ptls:Array[0..3] Of TPoint;
     {$ENDIF}
Begin
     If Empty Then Exit;
     {$IFDEF OS2}
     If Canvas.NonDisplayDevice Then
     Begin
          Src.Left:=0;
          Src.Right:=Width;
          Src.Bottom:=0;
          Src.Top:=Height;
          DrawBitmapBits(Src,Canvas,Dest);
          exit;
     End;

     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=0;
     ptls[2].Y:=0;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight;
     {OldPal:=GpiQueryPalette(Canvas.Handle);
     If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,FBitmapPal);}
     GpiBitBlt(Canvas.Handle,FBitmapPS,4,ptls[0],ROP_SRCCOPY,BBO_IGNORE);
     {If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,OldPal);}
     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;
     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,Canvas.Control,Canvas.Graphic);

     If (_Dest.Right-_Dest.Left=FWidth) And (_Dest.Top-_Dest.Bottom=FHeight) Then
     Begin
          WinGDI.BitBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                        FWidth,FHeight,FBitmapPS,0,0,SRCCOPY);
     End
     Else
     Begin
          StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                    _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                     FBitmapPS, 0, 0, FWidth, FHeight,SRCCOPY);
     End;
     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);
     DestroyHandle;
     {$ENDIF}
End;


Procedure TBitmap.PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);
Var  {$IFDEF Win95}
     OldPal:LongWord;
     _Src,_Dest:TRect;
     {$ENDIF}
     {$IFDEF OS2}
     ptls:Array[0..3] Of TPoint;
     {$ENDIF}
  {$IFDEF Win95}
  Procedure SourceRectToWin32(Var rec:TRect;OwnerHeight:LongInt);
  Begin
       rec.Bottom:=(OwnerHeight-rec.Bottom);
       rec.Top:=(OwnerHeight-rec.Top);
  End;
  {$ENDIF}
Begin
     If Empty Then Exit;
     {$IFDEF OS2}
     If Canvas.NonDisplayDevice Then
     Begin
          DrawBitmapBits(Src,Canvas,Dest);
          exit;
     End;
     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=Src.Left;
     ptls[2].Y:=Src.Bottom;
     ptls[3].X:=Src.Right;
     ptls[3].Y:=Src.Top;
     {OldPal:=GpiQueryPalette(Canvas.Handle);
     If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,FBitmapPal);}
     GpiBitBlt(Canvas.Handle,FBitmapPS,4,ptls[0],ROP_SRCCOPY,BBO_IGNORE);
     {If OldPal<>FBitmapPal Then GpiSelectPalette(Canvas.Handle,OldPal);}
     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;
     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,Canvas.Control,Canvas.Graphic);

     _Src := Src;
     RectToWin32Rect(_Src);
     SourceRectToWin32(_Src,FHeight);
     StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                FBitmapPS,_Src.Left,_Src.Bottom,
                _Src.Right-_Src.Left,_Src.Top-_Src.Bottom,SRCCOPY);

     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);
     DestroyHandle;
     {$ENDIF}
End;

Function TBitmap.GetEmpty:Boolean;
Begin
     GetEmpty:=FEmpty;
End;

Function TBitmap.GetHeight:LongInt;
Begin
     GetHeight:=FHeight;
End;

Procedure TBitmap.SetHeight(NewHeight:LongInt);
Begin
     FHeight:=NewHeight;
End;

Function TBitmap.GetWidth:LongInt;
Begin
     GetWidth:=FWidth;
End;

Procedure TBitmap.SetWidth(NewWidth:LongInt);
Begin
     FWidth:=NewWidth;
End;


Procedure TBitmap.LoadFromBitmap(Bitmap:TBitmap);
Begin
     FIsInvalid:=False; //reset flag !
     ReleaseBitmap;
     If Bitmap = Nil Then Exit;

     // make sure bitmap is updated
     Bitmap.Update;

     If Bitmap.FBitmapMem = Nil Then Exit;
     If Bitmap.FBitmapMemLength = 0 Then Exit;
{
evtll wieder ndern (falsch wenn Bitmap modifiziert durch Canvas
     BitmapStream.Create;
     BitmapStream.SetSize(Bitmap.FBitmapMemLength);
     Bitmap.SaveToStream(BitmapStream);
     BitmapStream.Position := 0;
     LoadFromStream(BitmapStream);
     BitmapStream.Destroy;
     FOrigin := Bitmap;
}
     LoadFromMem(Bitmap.FBitmapMem^,Bitmap.FBitmapMemLength);
End;


Function TBitmap.Copy:TBitmap;
Var  locClass:TBitmapClass;
Begin
     locClass := ClassType;
     Result := locClass.Create;
     If Owner<>Nil Then
     Begin
         Result.Owner:=Owner;
         Owner.InsertComponent(Result);
     End;
     Result.LoadFromBitmap(Self);
End;

Function TBitmap.CopyGraphic:TGraphic;
Begin
     Result:=Self.Copy
End;

{$IFDEF OS2}
{$HINTS OFF}
Procedure TBitmap.RealizePalette(Canvas:TCanvas);
Begin
End;
{$HINTS ON}

Procedure TBitmap.SetupBitmapColors(Header:Pointer;Mask:Boolean);
Type MyPRGB2=^PMyRGB2;
     PMyRGB2=Array[0..0] Of RGB2;
Var
   pbi2:PBITMAPINFO2;
   bIs1xFormat,bIs24BitColor:Boolean;
   pbi:PBITMAPINFO;
   lColorCount:LongInt;
   apRGB2:MyPRGB2;
   aNewRGB:MyPRGB2;
   I:LongInt;
   pal:LongWord;
Begin
     pbi2:=Header;
     bIs1xFormat := pbi2^.cbFix=SizeOf(BITMAPINFOHEADER);

     {Get Colors Of Bitmap}
     If bIs1xFormat Then
     Begin
           pbi := Pointer(pbi2);
           lColorCount:= pbi^.cPlanes * (LongWord(1) Shl pbi^.cBitCount);
           bIs24BitColor:=pbi^.cBitCount=24;
           If Not Mask Then
           Begin
               FOrigPlanes:=pbi^.cPlanes;
               FOrigBitCount:=pbi^.cBitCount;
           End;
     End
     Else
     Begin
           If ((pbi2^.cbFix>64)And(pbi2^.cclrUsed>0)) Then lColorCount:=pbi2^.cclrUsed
           Else lColorCount:=pbi2^.cPlanes * (LongWord(1) Shl pbi2^.cBitCount);
           bIs24BitColor:=pbi2^.cBitCount=24;
           If Not Mask Then
           Begin
              FOrigPlanes:=pbi2^.cPlanes;
              FOrigBitCount:=pbi2^.cBitCount;
           End;
     End;

     If Mask Then TIcon(Self).FMaskColorCount:=lColorCount
     Else FColorCount:=lColorCount;

     (*
     If lColorCount<=16 Then
     Begin
          If Mask Then TIcon(Self).FMaskPal:=0
          Else FBitmapPal:=0;
          Exit; {??} {Create no Palette !}
     End;
     *)

     If Not CreatePalette Then
     Begin
          If Mask Then TIcon(Self).FMaskPal:=0
          Else FBitmapPal:=0;
          Exit;
     End;

     {Convert 1X color Table (RGB) To 2X format (RGB2)}
     If bIs1xFormat Then
     Begin
          GetMem(apRGB2,lColorCount*SizeOf(RGB2));
          pbi:=Pointer(pbi2);
          For I:=0 To lColorCount-1 Do
          Begin
               apRGB2^[I].bRed := pbi^.argbColor[I].bRed ;
               apRGB2^[I].bGreen := pbi^.argbColor[I].bGreen ;
               apRGB2^[I].bBlue := pbi^.argbColor[I].bBlue ;
               apRGB2^[I].fcOptions := 0 ;
          End;
          GetMem(aNewRGB,(lColorCount)*SizeOf(RGB2));
          Move(apRGB2^,aNewRGB^[0],lColorCount*SizeOf(RGB2));
          FreeMem(apRGB2,lColorCount*SizeOf(RGB2));
          apRGB2:=aNewRGB;
     End
     Else
     Begin
         apRGB2:=Pointer(pbi2);
         Inc(apRGB2,pbi2^.cbFix);
         GetMem(aNewRGB,(lColorCount)*SizeOf(RGB2));
         Move(apRGB2^,aNewRGB^[0],lColorCount*SizeOf(RGB2));
         apRGB2:=aNewRGB;
     End;

     {Create A custom color Palette from color Info}
     pal := GpiCreatePalette(AppHandle,
                             0{LCOL_OVERRIDE_DEFAULT_COLORS},
                             LCOLF_CONSECRGB,
                             lColorCount,
                             apRGB2^);

     If Mask Then TIcon(Self).FMaskColorCount:=lColorCount
     Else FColorCount:=lColorCount;

     If Mask Then TIcon(Self).FMaskPal:=pal
     Else FBitmapPal:=pal;

     {Set the Palette into ps before Bitmap creation}
     If Mask Then
     Begin
          If GpiSelectPalette(TIcon(Self).FMaskPS,TIcon(Self).FMaskPal) = PAL_ERROR Then InvalidImage;
     End
     Else
     Begin
          {GpiCreateLogColorTable(FBitmapPS,0,LCOLF_RGB,0,FColorCount,apRGB2^);}
          If GpiSelectPalette(FBitmapPS,FBitmapPal) = PAL_ERROR Then InvalidImage;
          GpiCreateLogColorTable(FBitmapPS,0,LCOLF_RGB,0,0,Nil);
     End;

     FreeMem(apRGB2,lColorCount*SizeOf(RGB2));
End;
{$ENDIF}

{$IFDEF Win95}
Procedure TBitmap.RealizePalette(Canvas:TCanvas);
Begin
     If FBitmapHandle=0 Then CreateHandle;
     If FBitmapPal<>0 Then
     Begin
          If Canvas=Nil Then
          Begin
               FOldPalette:=SelectPalette(FBitmapPS,FBitmapPal,True);
               WinGDI.RealizePalette(FBitmapPS);
          End
          Else
          Begin
               SelectPalette(Canvas.Handle,FBitmapPal,True);
               WinGDI.RealizePalette(Canvas.Handle);
          End;
     End;
End;

Procedure TBitmap.SetupBitmapColors(Header:Pointer;Mask:Boolean);
Var Size,Size0,Size1:LongWord;
    PBC:^BitmapCoreHeader;
    pbi:^BITMAPINFOHEADER;
    BitmapInfo:PBitmapCoreInfo;
    P:^Byte;
    Colors,T:LongInt;
    DestPal:PLogPalette;
    BitmapInfo1:PBITMAPINFO;
    Focus:HWND;
    ADC,MemDC:HDC;
    SysPalSize:LongInt;
    I:LongInt;
    FTempBmp,FOldTempBmp:LongWord;
Label Win;
Begin
     If Not (Self Is TIcon) Then
     Begin
          PBC:=Header;
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then
          Begin
               {OS2 Bitmap}
               Size:=(1 Shl PBC^.bcBitCount) * SizeOf(RGBTriple);
               Size0:=Size + SizeOf(BitmapCoreInfo);
               GetMem(BitmapInfo,Size0);
               BitmapInfo^.bmciHeader:=PBC^;
               P:=Header;
               Inc(P,SizeOf(BitmapCoreHeader));
               Move(P^,BitmapInfo^.bmciColors,Size);
               Colors:=1 Shl PBC^.bcBitCount;
               FColorCount:=Colors;
               If Not Mask Then
               Begin
                  FOrigBitCount:=PBC^.bcBitCount;
                  FOrigPlanes:=PBC^.bcPlanes;
               End;

               If Colors<=2 Then
               Begin
                    If Mask Then TIcon(Self).FMaskPal:=0
                    Else FBitmapPal:=0;
                    Exit;
               End;

               Size1 := SizeOf(LogPalette) + ((Colors - 1) * SizeOf(PaletteEntry));
               GetMem(DestPal,Size1);
               FillChar(DestPal^,Size1,0);
               With DestPal^ Do
               Begin
                    palVersion := $300;
                    palNumEntries := Colors;

                    For T:=0 To Colors - 1 Do
                    Begin
                         If BitmapInfo^.bmciColors[T].rgbtRed=204 Then
                           If BitmapInfo^.bmciColors[T].rgbtGreen=204 Then
                            If BitmapInfo^.bmciColors[T].rgbtBlue=204 Then
                            Begin
                                 BitmapInfo^.bmciColors[T].rgbtRed:=192;
                                 BitmapInfo^.bmciColors[T].rgbtGreen:=192;
                                 BitmapInfo^.bmciColors[T].rgbtBlue:=192;
                            End;

                            palPalEntry[T].peRed := BitmapInfo^.bmciColors[T].rgbtRed;
                            palPalEntry[T].peGreen := BitmapInfo^.bmciColors[T].rgbtGreen;
                            palPalEntry[T].peBlue := BitmapInfo^.bmciColors[T].rgbtBlue;
                            palPalEntry[T].peFlags := 0;
                    End;
               End;
               Move(BitmapInfo^.bmciColors,P^,Size);
               If Mask Then TIcon(Self).FMaskPal:=WinGDI.CreatePalette(DestPal^)
               Else FBitmapPal:=WinGDI.CreatePalette(DestPal^);

               FreeMem(DestPal,Size1);
               FreeMem(BitmapInfo,Size0);
          End
          Else If PBC^.bcSize=SizeOf(BITMAPINFOHEADER) Then
          Begin
               {Win Bitmap}
               pbi:=Pointer(PBC);
Win:
               Size:=(1 Shl pbi^.biBitCount) * SizeOf(RGBQuad);
               Size0:=Size+SizeOf(BITMAPINFOHEADER);
               GetMem(BitmapInfo1,Size0);
               BitmapInfo1^.bmiHeader:=pbi^;
               P:=Header;
               Inc(P,SizeOf(BITMAPINFOHEADER));
               Move(P^,BitmapInfo1^.bmiColors,Size);
               Colors:=1 Shl pbi^.biBitCount;
               FColorCount:=Colors;
               If Not Mask Then
               Begin
                   FOrigPlanes:=pbi^.biPlanes;
                   FOrigBitCount:=pbi^.biBitCount;
               End;

               If Colors<=2 Then
               Begin
                    If Mask Then TIcon(Self).FMaskPal:=0
                    Else FBitmapPal:=0;
                    Exit;
               End;

               Size1:=SizeOf(LogPalette)+((Colors-1)*SizeOf(PaletteEntry));
               GetMem(DestPal,Size1);
               FillChar(DestPal^,Size1,0);

               With DestPal^ Do
               Begin
                    palVersion := $300;
                    palNumEntries := Colors;

                    ADC:=GetDC(0);
                    MemDC:=CreateCompatibleDC(ADC);
                    FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
                    FOldTempBmp:=SelectObject(MemDC,FTempBmp);

                    SysPalSize := GetDeviceCaps(MemDC, SIZEPALETTE);
                    If ((Colors=16)And(SysPalSize>=16)) Then
                    Begin
                         GetSystemPaletteEntries(MemDC,0,8,palPalEntry[0]);
                         I := 8;
                         GetSystemPaletteEntries(MemDC,SysPalSize-I,I,palPalEntry[I]);
                         For T:=0 To 7 Do
                         Begin
                              If palPalEntry[T].peRed=204 Then
                              If palPalEntry[T].peGreen=204 Then
                                If palPalEntry[T].peBlue=204 Then
                                Begin
                                     palPalEntry[T].peRed:=192;
                                     palPalEntry[T].peGreen:=192;
                                     palPalEntry[T].peBlue:=192;
                                End;
                         End;
                    End
                    Else
                    Begin
                         For T:=0 To Colors-1 Do
                         Begin
                             If BitmapInfo1^.bmiColors[T].rgbRed=204 Then
                               If BitmapInfo1^.bmiColors[T].rgbGreen=204 Then
                                 If BitmapInfo1^.bmiColors[T].rgbBlue=204 Then
                               Begin
                                    BitmapInfo1^.bmiColors[T].rgbRed:=192;
                                    BitmapInfo1^.bmiColors[T].rgbGreen:=192;
                                    BitmapInfo1^.bmiColors[T].rgbBlue:=192;
                               End;

                               palPalEntry[T].peRed:=BitmapInfo1^.bmiColors[T].rgbRed;
                               palPalEntry[T].peGreen:=BitmapInfo1^.bmiColors[T].rgbGreen;
                               palPalEntry[T].peBlue:=BitmapInfo1^.bmiColors[T].rgbBlue;
                               palPalEntry[T].peFlags := 0;
                         End;
                    End;

                    SelectObject(MemDC,FOldTempBmp);
                    If not DeleteObject(FTempBmp) Then InvalidImage;
                    If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
                    If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;
               End;
               Move(BitmapInfo1^.bmiColors,P^,Size);
               If Mask Then TIcon(Self).FMaskPal:=WinGDI.CreatePalette(DestPal^)
               Else FBitmapPal:= WinGDI.CreatePalette(DestPal^);

               FreeMem(DestPal,Size1);
               FreeMem(BitmapInfo1,Size0);
          End
          Else InvalidImage;
     End
     Else //Icon Or Pointer
     Begin
          pbi:=Header;
          Goto Win;
     End;
End;
{$ENDIF}

// Turn a specified set of data into an OS bitmap
{$HINTS OFF}
Procedure TBitmap.NewImage(BitmapData:Pointer;BitmapSize,OffsBits:LongWord;Mask:Boolean);
{$IFDEF OS2}
Var
   pbih:PBITMAPINFOHEADER;
   pbih2:PBITMAPINFOHEADER2;
   bih2:BITMAPINFOHEADER2;
   pbi2:PBITMAPINFO2;
   sizl:SIZEL;
   dop:DEVOPENSTRUC;
   pc:cstring;
   cScans,cScansRet,CX,CY:ULONG;
   Temp:^Byte;
   DC:LongWord;
   ps:LongWord;
   H:LongWord;
{$ENDIF}
{$IFDEF Win95}
Var
   PBC:^BitmapCoreHeader;
   pbi:^BITMAPINFOHEADER;
   BitmapInfo:PBitmapCoreInfo;
   BitmapInfo1:PBITMAPINFO;
   Size,Size0:LongWord;
   P:^Byte;
   Bits:Pointer;
   Focus:HWND;
   ADC,aDC1,MemDC,MemDC1:HDC;
   OldPal:LongWord;
   FTempBmp,FTempBmp1:LongWord;
   FOldTempBmp,FOldTempBmp1:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     DC := DevOpenDC(AppHandle,OD_MEMORY,'*',3,dop,0);
     If DC=0 Then InvalidImage;

     If Mask Then TIcon(Self).FMaskDC:=DC
     Else FBitmapDC:=DC;

     sizl.CX := 1;
     sizl.CY := 1;
     ps := GpiCreatePS(AppHandle,DC,sizl,PU_PELS Or GPIA_ASSOC Or GPIT_MICRO);
     If ps = GPI_ERROR Then InvalidImage;

     If Mask Then TIcon(Self).FMaskPS:=ps
     Else FBitmapPS:=ps;

     {If Not Mask Then} GpiCreateLogColorTable(ps,LCOL_RESET,LCOLF_RGB,0,0,Nil);

     pbih2:=BitmapData;

     If pbih2^.cbFix = SizeOf(BITMAPINFOHEADER) Then
     Begin
          { old format }
          pbih := Pointer(pbih2);
          cScans := pbih^.CY;
          CX := pbih^.CX;
          CY := pbih^.CY;
     End
     Else
     Begin
          { New PM format, windows, Or other }
          cScans := pbih2^.CY;
          CX := pbih2^.CX;
          CY := pbih2^.CY;
     End;

     {If Not Mask Then} SetupBitmapColors(BitmapData,Mask);

     Move(pbih2^, bih2, pbih2^.cbFix);  { Copy Info into global structure }

     H:=GpiCreateBitmap(ps,bih2,0,Nil,Nil);
     If H=0 Then InvalidImage;

     If Mask Then TIcon(Self).FMaskHandle:=H
     Else FBitmapHandle:=H;

     If GpiSetBitmap(ps,H) = BMB_ERROR Then InvalidImage;

     If ((BitmapData<>Nil) And (CX>0) And (CY>0)) Then
     Begin
          pbih:=BitmapData;
          Temp:=Pointer(pbih);
          Inc(Temp,OffsBits);
          pbi2:=Pointer(pbih);
          cScansRet := GpiSetBitmapBits(ps,0,cScans,Temp^,pbi2^);
          If cScansRet <> cScans Then InvalidImage; { original # Of scans? }
          FEmpty:=False;
     End
     Else InvalidImage;
     {$ENDIF}
     {$IFDEF Win95}
     If Not (Self Is TIcon) Then
     Begin
          PBC:=BitmapData;
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then
          Begin
               {OS2 Bitmap}
               If PBC^.bcPlanes<>1 Then InvalidImage;
               If FBitmapPal=0 Then
                 SetupBitmapColors(BitmapData,Mask);

               Size:=(1 Shl PBC^.bcBitCount) * SizeOf(RGBTriple);
               Size0:=Size + SizeOf(BitmapCoreInfo);
               GetMem(BitmapInfo,Size0);
               BitmapInfo^.bmciHeader:=PBC^;
               P:=BitmapData;
               Inc(P,SizeOf(BitmapCoreHeader));
               Move(P^,BitmapInfo^.bmciColors,Size);

               P:=BitmapData;
               Inc(P,SizeOf(BitmapCoreHeader));
               Inc(P,FColorCount*SizeOf(RGBTriple));
               Size:=((((FWidth*PBC^.bcBitCount)+31) Div 32)*4)*FHeight;
               GetMem(Bits,Size);
               Move(P^,Bits^,Size);

               ADC:=GetDC(0);
               MemDC:=CreateCompatibleDC(ADC);
               FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
               FOldTempBmp:=SelectObject(MemDC,FTempBmp);

               If FBitmapPal<> 0 Then
               Begin
                   OldPal := SelectPalette(MemDC,FBitmapPal,False);
                   WinGDI.RealizePalette(MemDC);
               End
               Else OldPal:=0;

               FBitmapHandle:=CreateDIBitmap(MemDC,PBITMAPINFOHEADER(PBC)^,
                                             CBM_INIT,Bits^,PBITMAPINFO(BitmapInfo)^,
                                             DIB_RGB_COLORS);
               If FBitmapHandle=0 Then InvalidImage;

               If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
               SelectObject(MemDC,FOldTempBmp);
               If not DeleteObject(FTempBmp) Then InvalidImage;
               if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
               If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

               FreeMem(BitmapInfo,Size0);
               FreeMem(Bits,Size);
          End
          Else If PBC^.bcSize=SizeOf(BITMAPINFOHEADER) Then
          Begin
               {Win Bitmap}
               pbi:=BitmapData;
               If pbi^.biPlanes<>1 Then InvalidImage;
               If FBitmapPal=0 Then
                 SetupBitmapColors(BitmapData,Mask);

               Size:=(1 Shl pbi^.biBitCount) * SizeOf(RGBQuad);
               Size0:=Size+SizeOf(BITMAPINFOHEADER);
               GetMem(BitmapInfo1,Size0);
               BitmapInfo1^.bmiHeader:=pbi^;
               P:=BitmapData;
               Inc(P,SizeOf(BITMAPINFOHEADER));
               Move(P^,BitmapInfo1^.bmiColors,Size);

               P:=BitmapData;
               Inc(P,SizeOf(BITMAPINFOHEADER));
               Inc(P,FColorCount*SizeOf(RGBQuad));
               Size:=pbi^.biSizeImage;
               GetMem(Bits,Size);
               Move(P^,Bits^,Size);

               ADC:=GetDC(0);
               MemDC:=CreateCompatibleDC(ADC);
               FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
               FOldTempBmp:=SelectObject(MemDC,FTempBmp);

               If FBitmapPal<>0 Then
               Begin
                   OldPal:=SelectPalette(MemDC,FBitmapPal,False);
                   WinGDI.RealizePalette(MemDC);
               End
               Else OldPal := 0;

               FBitmapHandle:=CreateDIBitmap(MemDC,pbi^,CBM_INIT,Bits^,
                                             BitmapInfo1^,DIB_RGB_COLORS);
               If FBitmapHandle=0 Then InvalidImage;

               If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
               SelectObject(MemDC,FOldTempBmp);
               If not DeleteObject(FTempBmp) Then InvalidImage;
               if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
               If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

               FreeMem(BitmapInfo1,Size0);
               FreeMem(Bits,Size);
          End
          Else InvalidImage;

          FEmpty:=False;
     End
     Else //Icon Or Pointer
     Begin
          PBC:=BitmapData;
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then //OS2 Icon
          Begin
               If PBC^.bcPlanes<>1 Then InvalidImage;
               {OS2 Icon}
               If Mask Then
               Begin
                    //Create Xor Mask
                    If FBitmapPal=0 Then SetupBitmapColors(BitmapData,Mask);

                    P:=BitmapData;
                    Inc(P,OffsBits);

                    Size:=2 * SizeOf(RGBTriple);
                    Size0:=Size+SizeOf(BitmapCoreInfo);
                    GetMem(BitmapInfo,Size0);
                    BitmapInfo^.bmciHeader:=PBC^;

                    BitmapInfo^.bmciHeader.bcBitCount:=1;
                    BitmapInfo^.bmciHeader.bcPlanes:=1;
                    BitmapInfo^.bmciColors[0].rgbtBlue:=0;
                    BitmapInfo^.bmciColors[0].rgbtGreen:=0;
                    BitmapInfo^.bmciColors[0].rgbtRed:=0;
                    BitmapInfo^.bmciColors[1].rgbtBlue:=255;
                    BitmapInfo^.bmciColors[1].rgbtGreen:=255;
                    BitmapInfo^.bmciColors[1].rgbtRed:=255;

                    ADC:=GetDC(0);
                    MemDC:=CreateCompatibleDC(ADC);
                    FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
                    FOldTempBmp:=SelectObject(MemDC,FTempBmp);

                    If TIcon(Self).FMaskPal<> 0 Then
                    Begin
                        OldPal := SelectPalette(MemDC,TIcon(Self).FMaskPal,False);
                        WinGDI.RealizePalette(MemDC);
                    End
                    Else OldPal:=0;

                    TIcon(Self).FMaskHandle:=CreateDIBitmap(MemDC,PBITMAPINFOHEADER(PBC)^,
                                         CBM_INIT,P^,PBITMAPINFO(BitmapInfo)^,
                                         DIB_RGB_COLORS);
                    If TIcon(Self).FMaskHandle=0 Then InvalidImage;

                    If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
                    SelectObject(MemDC,FOldTempBmp);
                    If not DeleteObject(FTempBmp) Then InvalidImage;
                    if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
                    If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

                    FreeMem(BitmapInfo,Size0);

                    TIcon(Self).FMaskPS:=CreateCompatibleDC(0);
                    TIcon(Self).FOldMaskBitmap:=SelectObject(TIcon(Self).FMaskPS,TIcon(Self).FMaskHandle);
               End
               Else
               Begin
                    If FBitmapPal=0 Then SetupBitmapColors(BitmapData,Mask);

                    Size:=(1 Shl PBC^.bcBitCount) * SizeOf(RGBTriple);
                    Size0:=Size + SizeOf(BitmapCoreInfo);
                    GetMem(BitmapInfo,Size0);
                    BitmapInfo^.bmciHeader:=PBC^;
                    P:=BitmapData;
                    Inc(P,SizeOf(BitmapCoreHeader));
                    Move(P^,BitmapInfo^.bmciColors,Size);

                    P:=BitmapData;
                    Inc(P,OffsBits);
                    Size:=((((FWidth*PBC^.bcBitCount)+31) Div 32)*4)*FHeight;
                    GetMem(Bits,Size);
                    Move(P^,Bits^,Size);

                    ADC:=GetDC(0);
                    MemDC:=CreateCompatibleDC(ADC);
                    FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
                    FOldTempBmp:=SelectObject(MemDC,FTempBmp);

                    If FBitmapPal<> 0 Then
                    Begin
                        OldPal := SelectPalette(MemDC,FBitmapPal,False);
                        WinGDI.RealizePalette(MemDC);
                    End
                    Else OldPal:=0;

                    FBitmapHandle:=CreateDIBitmap(MemDC,PBITMAPINFOHEADER(PBC)^,
                                       CBM_INIT,Bits^,PBITMAPINFO(BitmapInfo)^,
                                       DIB_RGB_COLORS);
                    If FBitmapHandle=0 Then InvalidImage;

                    If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
                    SelectObject(MemDC,FOldTempBmp);
                    If not DeleteObject(FTempBmp) Then InvalidImage;
                    if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
                    If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

                    FreeMem(BitmapInfo,Size0);
                    FreeMem(Bits,Size);

                    FEmpty:=False;
               End;
          End
          Else //Win Icon
          Begin
              pbi:=BitmapData;

              If pbi^.biPlanes<>1 Then InvalidImage;
              If FBitmapPal=0 Then SetupBitmapColors(BitmapData,Mask);

              Size:=(1 Shl pbi^.biBitCount) * SizeOf(RGBQuad);
              Size0:=Size+SizeOf(BITMAPINFOHEADER);
              GetMem(BitmapInfo1,Size0);
              BitmapInfo1^.bmiHeader:=pbi^;

              BitmapInfo1^.bmiHeader.biHeight:=BitmapInfo1^.bmiHeader.biHeight Div 2;
              BitmapInfo1^.bmiHeader.biSizeImage:=
                 (((BitmapInfo1^.bmiHeader.biBitCount*BitmapInfo1^.bmiHeader.biWidth)+31) Div 32)*4*
                    BitmapInfo1^.bmiHeader.biHeight*BitmapInfo1^.bmiHeader.biPlanes;

              P:=BitmapData;
              Inc(P,SizeOf(BITMAPINFOHEADER));
              Move(P^,BitmapInfo1^.bmiColors,Size);

              P:=BitmapData;
              Inc(P,SizeOf(BITMAPINFOHEADER));
              Inc(P,FColorCount*SizeOf(RGBQuad));
              Size:=BitmapInfo1^.bmiHeader.biSizeImage;
              GetMem(Bits,Size);
              Move(P^,Bits^,Size);

              ADC:=GetDC(0);
              MemDC:=CreateCompatibleDC(ADC);
              FTempBmp:=CreateCompatibleBitmap(ADC,1,1);
              FOldTempBmp:=SelectObject(MemDC,FTempBmp);

              If FBitmapPal<>0 Then
              Begin
                   OldPal:=SelectPalette(MemDC,FBitmapPal,False);
                   WinGDI.RealizePalette(MemDC);
              End
              Else OldPal := 0;

              //Create Xor Mask
              FBitmapHandle:=CreateDIBitmap(MemDC,BitmapInfo1^.bmiHeader,CBM_INIT,Bits^,
                                            BitmapInfo1^,DIB_RGB_COLORS);
              If FBitmapHandle=0 Then InvalidImage;

              //Create And Mask
              Inc(P,Size);
              //Move(P^,Bits^,Size);
              BitmapInfo1^.bmiHeader.biBitCount:=1;
              BitmapInfo1^.bmiHeader.biPlanes:=1;
              BitmapInfo1^.bmiHeader.biSizeImage:=
                 (((BitmapInfo1^.bmiHeader.biBitCount*BitmapInfo1^.bmiHeader.biWidth)+31) Div 32)*4*
                    BitmapInfo1^.bmiHeader.biHeight*BitmapInfo1^.bmiHeader.biPlanes;
              BitmapInfo1^.bmiColors[1].rgbBlue:=255;
              BitmapInfo1^.bmiColors[1].rgbGreen:=255;
              BitmapInfo1^.bmiColors[1].rgbRed:=255;

              ADC1:=GetDC(0);
              MemDC1:=CreateCompatibleDC(ADC1);
              FTempBmp1:=CreateCompatibleBitmap(ADC1,1,1);
              FOldTempBmp1:=SelectObject(MemDC1,FTempBmp1);

              TIcon(Self).FMaskHandle:=CreateDIBitmap(MemDC1,BitmapInfo1^.bmiHeader,CBM_INIT,P^,
                                       BitmapInfo1^,DIB_RGB_COLORS);
              If TIcon(Self).FMaskHandle=0 Then InvalidImage;

              If OldPal<>0 Then SelectPalette(MemDC,OldPal,True);
              SelectObject(MemDC,FOldTempBmp);
              If not DeleteObject(FTempBmp) Then InvalidImage;
              if MemDC <> 0 then If not DeleteDC(MemDC) Then InvalidImage;
              If ADC<>0 Then If ReleaseDC(0,ADC)=0 Then InvalidImage;

              SelectObject(MemDC1,FOldTempBmp1);
              If not DeleteObject(FTempBmp1) Then InvalidImage;
              if MemDC1 <> 0 then If not DeleteDC(MemDC1) Then InvalidImage;
              If ADC1<>0 Then If ReleaseDC(0,ADC1)=0 Then InvalidImage;

              FreeMem(BitmapInfo1,Size0);
              FreeMem(Bits,Size);

              TIcon(Self).FMaskPS:=CreateCompatibleDC(0);
              TIcon(Self).FOldMaskBitmap:=SelectObject(TIcon(Self).FMaskPS,TIcon(Self).FMaskHandle);
          End;
          FEmpty:=False;
     End;
     {$ENDIF}
End;
{$HINTS ON}

Procedure TBitmap.InvalidImage;
Begin
     FIsInvalid:=True;
     ReleaseBitmap;
     Raise EInvalidBitmap.Create(LoadNLSStr(SInvalidBitmap));
End;

Type
     ICONDIRENTRY=Record
                        bWidth:Byte;
                        bHeight:Byte;
                        bColorCount:Byte;
                        bReserved:Byte;
                        wPlanes:Word;
                        wBitCount:Word;
                        dwBytesInRes:LongWord;
                        dwImageOffset:LongWord;
     End;

Type PICONDIR=^TICONDIR;
     TICONDIR=Record
                    idReserved:Word;
                    idType:Word;
                    idCount:Word;
                    idEntries:ICONDIRENTRY;
     End;

// Converts the data in memory (FBitmapMem) into an OS bitmap
// or two if a mask (icon) is involved. Calls NewImage to create the OS bitmaps
Procedure TBitmap.SetupBitmap;
{$IFDEF OS2}
Var
   pbBuffer:Pointer;
   pbafh2 : PBITMAPARRAYFILEHEADER2;
   pbfh2  : PBITMAPFILEHEADER2;
   pbih   : PBITMAPINFOHEADER;
   pbih2  : PBITMAPINFOHEADER2;
   I,J,Bitmap2 : Word;
   BitmapOffset:LongWord;
   BitmapData:Pointer;
   BitmapSize,OffsBits:LongWord;
   Size:LongWord;
   MaskHeader:PBITMAPFILEHEADER2;
//   ID:PIconDir;
Label LL;
{$ENDIF}
{$IFDEF Win95}
Var
   pbBuffer:Pointer;
   PBC:^BitmapCoreHeader;
   pbi:^BITMAPINFOHEADER;
   BitmapOffset,OffsBits,BitmapSize:LongWord;
   BitmapData:Pointer;
   ResHandle:LongWord;
   Size:LongWord;
   iDir:PICONDIR;
   bfh:PBITMAPFILEHEADER;
   MaskHeader:PBITMAPFILEHEADER;
   I,J,Bitmap2 : Word;
   WithFileHeader:Boolean;
Const
   BFT_COLORICON      =$4943;   { 'CI' }
   BFT_COLORPOINTER   =$5043;   { 'CP' }
   BFT_BITMAP         =$4d42;   { 'BM' }
Label check,ProcessIcon;
{$ENDIF}
Begin
     {$IFDEF OS2}
     pbBuffer:=FBitmapMem;
     Size:=FBitmapMemLength;
     MaskHeader:=Nil;

     pbfh2 := pbBuffer;
     pbih2 := Nil;     { only Set This when we validate Type }

     If pbfh2^.usType = BFT_BITMAPARRAY Then
     Begin
          If Not (Self Is TBitmap) Then InvalidImage;
          pbafh2 := @pbBuffer^;
          pbfh2 := @pbafh2^.bfh2;
     End;

     FXHotSpot:=pbfh2^.XHotSpot;
     FYHotSpot:=pbfh2^.YHotSpot;

     Case pbfh2^.usType Of
               BFT_BMAP:
               Begin
                    If Not (Self Is TBitmap) Then InvalidImage;
                    pbih2 := @pbfh2^.bmp2;
               End;
               {
               0: //Win 3.1 icon ?
               Begin
                    ID:=Pointer(pbfh2);
                    If ID.idType<>1 Then InvalidImage;

                    //Win 3.1 Icon found
                    inc(ID,$16); //Offset to BITMAPINFOHEADER
                    pbih2:=Pointer(ID);
                    Icon hat doppelte H”he (64)
               End;
               }
               {
               BFT_ICON:
               Begin
                    If Not (Self Is TIcon) Then InvalidImage;
                    pbih2 := @pbfh2^.bmp2;
               End;
               BFT_POINTER:
               Begin
                    If Not (Self Is TPointer) Then InvalidImage;
                    pbih2 := @pbfh2^.bmp2;
               End;
               }
               BFT_COLORICON,
               BFT_COLORPOINTER :
               Begin
                     If Not (Self Is TPointer) Then
                        If Not (Self Is TIcon) Then InvalidImage;

                    MaskHeader:=pbfh2;
                    If pbfh2^.cbSize = SizeOf(BITMAPFILEHEADER) Then
                    Begin
                         pbih := @pbfh2^.bmp2;      {only BITMAPINFOHEADER}
                         J := 1;
                         For I := 1 To (pbih^.cPlanes*pbih^.cBitCount) Do J := 2*J;
                         Bitmap2 := SizeOf(RGB)*J;  {Size Of color Table}
                    End
                    Else
                    Begin
                         pbih2 := @pbfh2^.bmp2;     {BITMAPINFOHEADER2}
                         J := 1;
                         For I := 1 To (pbih2^.cPlanes*pbih2^.cBitCount) Do J := 2*J;
                         Bitmap2 := SizeOf(RGB2)*J; {Size Of color Table}
                    End;
                    Inc(Bitmap2,pbfh2^.cbSize);     {+ Size Of BITMAPFILEHEADER[2]}
                    Inc(pbfh2,Bitmap2);             {Select the Second Bitmap}
                    pbih2 := @pbfh2^.bmp2;
               End;
     End; {Case}

     If pbih2 = Nil Then
     Begin
LL:
          InvalidImage;
     End;

     BitmapOffset:=LongWord(pbih2)-LongWord(@pbBuffer^);
     BitmapSize:=Size-BitmapOffset;

     BitmapData:=pbih2;

     If pbih2^.cbFix=SizeOf(BITMAPINFOHEADER) Then
     Begin
          {old format}
          FWidth:=PBITMAPINFOHEADER(pbih2)^.CX;
          FHeight:=PBITMAPINFOHEADER(pbih2)^.CY;
     End
     Else
     Begin
          {New PM format Or other}
          FWidth:=pbih2^.CX;
          FHeight:=pbih2^.CY;
     End;

     OffsBits:=pbfh2^.offBits-BitmapOffset;

     NewImage(BitmapData,BitmapSize,OffsBits,False);

     If Self Is TIcon Then If MaskHeader<>Nil Then
     Begin
          pbfh2:=MaskHeader;
          pbih2:=@pbfh2^.bmp2;

          BitmapOffset:=LongWord(pbih2)-LongWord(@pbBuffer^);
          BitmapSize:=Size-BitmapOffset;

          BitmapData:=pbih2;

          If pbih2^.cbFix=SizeOf(BITMAPINFOHEADER) Then
          Begin
               {old format}
               TIcon(Self).FMaskWidth:=PBITMAPINFOHEADER(pbih2)^.CX;
               TIcon(Self).FMaskHeight:=PBITMAPINFOHEADER(pbih2)^.CY;
          End
          Else
          Begin
              {New PM format Or other}
              TIcon(Self).FMaskWidth:=pbih2^.CX;
              TIcon(Self).FMaskHeight:=pbih2^.CY;
          End;

          OffsBits:=pbfh2^.offBits-BitmapOffset;

          NewImage(BitmapData,BitmapSize,OffsBits,True);
     End;
     {$ENDIF}
     {$IFDEF Win95}
     pbBuffer:=FBitmapMem;

     If Not (Self Is TIcon) Then
     Begin
          PBC:=pbBuffer;
check:
          If PBC^.bcSize=SizeOf(BitmapCoreHeader) Then
          Begin
               FWidth:=PBC^.bcWidth;
               FHeight:=PBC^.bcHeight;
          End
          Else If PBC^.bcSize=SizeOf(BITMAPINFOHEADER) Then
          Begin
               pbi:=Pointer(PBC);
               FWidth:=pbi^.biWidth;
               FHeight:=pbi^.biHeight;
          End
          Else
          Begin
              bfh:=pbBuffer;
              If bfh^.bfType=BFT_BITMAP Then
              Begin
                   PBC:=pbBuffer;
                   inc(PBC,sizeof(BITMAPFILEHEADER));
                   goto check;
              End
              Else InvalidImage;
          End;

          BitmapOffset:=0;
          OffsBits:=0;{PBmf^.bfOffBits-BitmapOffset;} //Not used For Win
          BitmapSize:=FBitmapMemLength;
          BitmapData:=PBC;
          NewImage(BitmapData,BitmapSize,OffsBits,False);
     End
     Else //Icon Or Pointer
     Begin
          bfh:=pbBuffer;

          If ((bfh^.bfType=BFT_COLORICON)Or
              (bfh^.bfType=BFT_COLORPOINTER)) Then //OS/2 Icon
          Begin
               {
               FXHotSpot:=pbfh^.XHotSpot;
               FYHotSpot:=pbfh^.YHotSpot;}
               WithFileHeader:=True;
ProcessIcon:
               MaskHeader:=bfh;
               PBC:=pbBuffer;
               If WithFileHeader Then Inc(PBC,SizeOf(BITMAPFILEHEADER));
               If PBC^.bcSize<>SizeOf(BitmapCoreHeader) Then InvalidImage;
               J := 1;
               For I := 1 To (PBC^.bcPlanes*PBC^.bcBitCount) Do J := 2*J;
               Bitmap2 := SizeOf(RGBTriple)*J;          {Size Of color Table}
               Inc(Bitmap2,SizeOf(BITMAPFILEHEADER));   {+ Size Of BITMAPFILEHEADER[2]}
               Inc(Bitmap2,SizeOf(BitmapCoreHeader));

               Inc(bfh,Bitmap2);
               PBC := Pointer(bfh);                     {Select the Second Bitmap}
               If WithFileHeader Then Inc(PBC,SizeOf(BITMAPFILEHEADER));
               If PBC^.bcSize<>SizeOf(BitmapCoreHeader) Then InvalidImage;
               FWidth:=PBC^.bcWidth;
               FHeight:=PBC^.bcHeight;
               TIcon(Self).FMaskWidth:=FWidth;
               TIcon(Self).FMaskHeight:=FHeight;

               //Generate color Bitmap
               Size:=FBitmapMemLength;
               BitmapOffset:=LongWord(PBC)-LongWord(@pbBuffer^);
               BitmapSize:=Size-BitmapOffset;
               //let it Point To BitmapCoreHeader
               BitmapData:=Pointer(PBC);
               OffsBits:=bfh^.bfOffBits-BitmapOffset;
               NewImage(BitmapData,BitmapSize,OffsBits,False);

               //Generate Mask Bitmap
               bfh:=MaskHeader;
               PBC:=Pointer(bfh);
               If WithFileHeader Then Inc(PBC,SizeOf(BITMAPFILEHEADER));
               If PBC^.bcSize<>SizeOf(BitmapCoreHeader) Then InvalidImage;

               BitmapOffset:=LongWord(PBC)-LongWord(@pbBuffer^);
               BitmapSize:=Size-BitmapOffset;
               //let it Point To BitmapCoreHeader
               BitmapData:=Pointer(PBC);
               OffsBits:=bfh^.bfOffBits-BitmapOffset;
               NewImage(BitmapData,BitmapSize,OffsBits,True);
          End
          Else //Win Icon
          Begin
               iDir:=pbBuffer;
                  
               If iDir^.idReserved<>0 Then
               Begin
                    pbi:=pbBuffer;
                    If pbi^.biSize<>sizeof(BITMAPINFOHEADER) Then
                    Begin
                        PBC:=pbBuffer;
                        If PBC^.bcSize<>sizeof(BITMAPCOREHEADER) Then InvalidImage;

                        {
                        FWidth:=PBC^.bcWidth;
                        FHeight:=PBC^.bcHeight;

                        TIcon(Self).FMaskWidth:=FWidth;
                        TIcon(Self).FMaskHeight:=FHeight;

                        BitmapSize:=FBitmapMemLength;
                        OffsBits:=0;
                        BitmapData:=pbBuffer;
                        NewImage(BitmapData,BitmapSize,OffsBits,False);
                        }
                        WithFileHeader:=False;
                        goto ProcessIcon;
                    End
                    Else
                    Begin
                         FWidth:=pbi^.biWidth;
                         FHeight:=pbi^.biHeight;
                         TIcon(Self).FMaskWidth:=FWidth;
                         TIcon(Self).FMaskHeight:=FHeight;

                         BitmapSize:=FBitmapMemLength;
                         OffsBits:=0;
                         BitmapData:=pbBuffer;
                         NewImage(BitmapData,BitmapSize,OffsBits,False);
                    End;
               End
               Else
               Begin
                  If ((iDir^.idType<>1)And(iDir^.idType<>2)) Then InvalidImage;
                  If iDir^.idCount<>1 Then InvalidImage;

                  FWidth:=iDir^.idEntries.bWidth;
                  FHeight:=iDir^.idEntries.bHeight;
                  TIcon(Self).FMaskWidth:=FWidth;
                  TIcon(Self).FMaskHeight:=FHeight;

                  BitmapSize:=iDir^.idEntries.dwBytesInRes;
                  OffsBits:=0;
                  BitmapData:=pbBuffer;
                  //let it Point To BITMAPINFOHEADER
                  Inc(BitmapData,SizeOf(TICONDIR){iDir^.idEntries.dwImageOffset});
                  NewImage(BitmapData,BitmapSize,OffsBits,False);
               End;
          End;
     End;

     If not (Self Is TIcon) Then CreateHandle;
     {$ENDIF}
End;

Procedure TBitmap.LoadFromResourceId(Id:LongWord);
Var pbBuffer:Pointer;
    Size:LongWord;
    {$IFDEF Win95}
    C:cstring;
    ResHandle:LongWord;
    {$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !

     {$IFDEF OS2}
     If ((Self Is TPointer)Or(Self Is TIcon)) Then
     Begin
        If DosQueryResourceSize(DllModule,RT_POINTER,Id,Size)<>0 Then InvalidImage;
        If DosGetResource(DllModule,RT_POINTER,Id,pbBuffer)<>0 Then InvalidImage;
     End
     Else
     Begin
        If DosQueryResourceSize(DllModule,RT_BITMAP,Id,Size)<>0 Then InvalidImage;
        If DosGetResource(DllModule,RT_BITMAP,Id,pbBuffer)<>0 Then InvalidImage;
     End;
     If pbBuffer=Nil Then InvalidImage;

     ReleaseBitmap;
     FBitmapMemLength:=Size;
     GetMem(FBitmapMem,FBitmapMemLength);
     Move(pbBuffer^,FBitmapMem^,FBitmapMemLength);
     If DosFreeResource(pbBuffer)<>0 Then InvalidImage;
     {$ENDIF}
     {$IFDEF Win95}
     C:='#'+tostr(Id);
     If Self Is TPointer Then ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_CURSOR)^)
     Else If Self Is TIcon Then ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_GROUP_ICON)^)
     Else ResHandle:=FindResource(DllModule,C,MAKEINTRESOURCE(RT_BITMAP)^);
     If ResHandle=0 Then InvalidImage;
     pbBuffer:=Pointer(LoadResource(DllModule,ResHandle));
     If pbBuffer=Nil Then InvalidImage;
     Size:=SizeOfResource(DllModule,ResHandle);

     ReleaseBitmap;
     FBitmapMemLength:=Size;
     GetMem(FBitmapMem,FBitmapMemLength);
     Move(pbBuffer^,FBitmapMem^,FBitmapMemLength);
     {$ENDIF}

     SetupBitmap;
     changed;
     {$IFDEF WIN32}
     DestroyHandle;
     {$ENDIF}
End;

Procedure TBitmap.LoadFromResourceName(Const Name:String);
Var P:Pointer;
    len:LongWord;
Begin
     FIsInvalid:=False; //reset flag !

     P:=FindBitmapRes(Name,len);
     If ((P=Nil)Or(len=0)) Then InvalidImage;

     ReleaseBitmap;
     FBitmapMemLength:=len;
     GetMem(FBitmapMem,FBitmapMemLength);
     Move(P^,FBitmapMem^,FBitmapMemLength);
     SetupBitmap;
     changed;
     {$IFDEF WIN32}
     DestroyHandle;
     {$ENDIF}
End;

Procedure TBitmap.LoadFromMem (Var Buf;Size:LongInt);
Begin
     FIsInvalid:=False; //reset flag !

     ReleaseBitmap;
     FBitmapMemLength:=Size;
     GetMem(FBitmapMem,FBitmapMemLength);
     Move(Buf,FBitmapMem^,FBitmapMemLength);
     SetupBitmap;
     changed;
     {$IFDEF WIN32}
     DestroyHandle;
     {$ENDIF}
End;

Procedure TBitmap.ReadStream(Stream:TStream;Size:LongInt);
{$IFDEF Win95}
Var PBmf:^BITMAPFILEHEADER;
    P,p1:Pointer;
{$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !

     If Size>0 Then
     Begin
          ReleaseBitmap;
          FBitmapMemLength:=Size;
          GetMem(FBitmapMem,FBitmapMemLength);
          Stream.ReadBuffer(FBitmapMem^,Size);
          {$IFDEF Win95}
          PBmf:=Pointer(FBitmapMem);
          If PBmf^.bfType=$4D42 Then //Delete File Header
          Begin
               GetMem(P,Size-SizeOf(BITMAPFILEHEADER));
               p1:=FBitmapMem;
               Inc(p1,SizeOf(BITMAPFILEHEADER));
               Move(p1^,P^,Size-SizeOf(BITMAPFILEHEADER));
               FreeMem(FBitmapMem,Size);
               Dec(FBitmapMemLength,SizeOf(BITMAPFILEHEADER));
               FBitmapMem:=P;
          End;
          {$ENDIF}
          SetupBitmap;
          changed;
          {$IFDEF WIN32}
          DestroyHandle;
          {$ENDIF}
     End  {Size > 0}
     Else
     Begin
          {Setup Bitmap Info structure pbmp2BitmapFile}
          InvalidImage;
     End;
End;

Procedure TBitmap.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     FIsInvalid:=False; //reset flag !

     If ResName = rnBitmap Then
     Begin
          If DataLen>0 Then
          Begin
               If FBitmapMem=Nil Then
               Begin
                    FBitmapMemLength:=DataLen;
                    GetMem(FBitmapMem,FBitmapMemLength);
                    Move(Data,FBitmapMem^,FBitmapMemLength);
                    SetupBitmap;
                    changed;
                    {$IFDEF WIN32}
                    DestroyHandle;
                    {$ENDIF}
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TBitmap.WriteSCUResourceName(Stream:TResourceStream;
                                      ResName:TResourceName):Boolean;
Begin
     If (FBitmapMemLength>0) And (FBitmapMem<>Nil) Then
     Begin
          Result:=Stream.NewResourceEntry(ResName,FBitmapMem^,FBitmapMemLength);
     End
     Else Result:=True;
End;

Function TBitmap.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := WriteSCUResourceName(Stream,rnBitmap);
End;

Procedure TBitmap.LoadFromStream(Stream:TStream);
Begin
     FIsInvalid:=False; //reset flag !
     ReadStream(Stream,Stream.Size-Stream.Position);
     changed;
End;

// Retrieves data from OS bitmap into memory,
// laid out as in a BMP file. For OS/2:
// Fileheader
//   InfoHeader
// Palette (if 256 colors or less)
// Bits
Procedure TBitmap.Update;
{$IFDEF OS2}
Var
    PaletteSize: longint;
    BitsSize: longint;
    InfoHeader: BITMAPINFOHEADER;
    pInfoHeader: PBITMAPINFOHEADER;
    pFileHeader: ^BITMAPFILEHEADER;
    pBitmapBits: pbyte;
{$ENDIF}
{$IFDEF Win95}
Var
    BI:BitmapCoreInfo;
    pbi:^BitmapCoreInfo;
    P,pp:Pointer;
    cbInfo,cbBuffer:LongWord;

    BI2:BitmapInfo;
{$ENDIF}
Begin
     {$IFDEF OS2}
     //fr PM 2.X format Bitmap*2 statt Bitmap* und RGB2 statt RGB

     // Get bitmap information header
     InfoHeader.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FBitmapHandle,InfoHeader) Then Exit;

     // If paletted image (256 colours, 8 bpp, or less) then
     // calculate palette size
     if InfoHeader.cBitCount <= 8 then
       PaletteSize := SizeOf(RGB)*(1 Shl InfoHeader.cBitCount)
     else
       // not a paletted image, no palette
       PaletteSize := 0;

     // Calculate size of bitmap bits
     // Round row size up to nearest 32bit boundary
     BitsSize:= (((InfoHeader.cBitCount*InfoHeader.CX)+31) Div 32)*4
                * InfoHeader.CY
                * InfoHeader.cPlanes;

     // Free up previous memory, if any
     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);

     // calculate total bitmap memory required and allocate
     FBitmapMemLength:= sizeof(BITMAPFILEHEADER)
                        + PaletteSize
                        + BitsSize;
     GetMem(FBitmapMem,FBitmapMemLength);

     // create pointers into memory for the info header and the bits
     pInfoHeader := PBITMAPINFOHEADER( FBitmapMem
                                       + SizeOf(BITMAPFILEHEADER)
                                       - SizeOf(BITMAPINFOHEADER) );
     pBitmapBits := FBitmapMem
                    + SizeOf(BITMAPFILEHEADER)
                    + PaletteSize;

     // Copt info header
     pInfoHeader^ := InfoHeader;

     // Query all bitmap bits & info+palette
     GpiQueryBitmapBits( FBitmapPS,
                         0, // start scanline
                         InfoHeader.CY, // scanline count (all)
                         pBitmapBits^, // bits
                         pInfoHeader^); // info header and palette

     // setup bitmap file header
     pFileHeader := FBitmapMem;
     pFileHeader^.usType:=BFT_BMAP;
     pFileHeader^.cbSize:=SizeOf(BITMAPFILEHEADER);
     pFileHeader^.XHotSpot:=FXHotSpot;
     pFileHeader^.YHotSpot:=FYHotSpot;
     pFileHeader^.offBits:=SizeOf(BITMAPFILEHEADER)+PaletteSize;

     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;
     SelectObject(FBitmapPS,FOldBitmap);

     FillChar(BI,SizeOf(BI),0);

     FillChar(BI2,SizeOf(BI2),0);
     BI2.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FBitmapPS,FBitmapHandle,0,0,Nil,BI2,0);
     If FOrigBitCount>0 Then BI2.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI2.bmiHeader.biPlanes:=FOrigPlanes;

     cbInfo:=SizeOf(BitmapCoreHeader)+SizeOf(RGBTriple)*(1 Shl BI2.bmiHeader.biBitCount);
     LastcbInfo:=cbInfo;
     GetMem(pbi,cbInfo);
     With pbi^.bmciHeader Do
     Begin
          bcSize:=SizeOf(BitmapCoreHeader);
          bcWidth:=BI2.bmiHeader.biWidth;
          bcHeight:=BI2.bmiHeader.biHeight;
          bcPlanes:=BI2.bmiHeader.biPlanes;
          bcBitCount:=BI2.bmiHeader.biBitCount;
     End;
     cbBuffer:=(((BI2.bmiHeader.biBitCount*BI2.bmiHeader.biWidth)+31) Div 32)
                *4*BI2.bmiHeader.biHeight*BI2.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(FBitmapPS,FBitmapHandle,0,BI2.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     If FBitmapMem<>Nil Then FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=cbInfo+cbBuffer;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);

     FreeMem(pbi,cbInfo);
     FreeMem(P,cbBuffer);
     SelectObject(FBitmapPS,FBitmapHandle);
     DestroyHandle;
     {$ENDIF}
End;

Procedure TBitmap.SaveToStream(Stream:TStream);
{$IFDEF Win95}
Var FH:BITMAPFILEHEADER;
Const BFT_BMAP           =$4D42;   { 'BM' }
{$ENDIF}
Begin
     {$IFDEF WIN32}
     CreateHandle;
     {$ENDIF}

     Update;

     If ((FBitmapHandle=0)Or(FBitmapMem=Nil)Or(FBitmapMemLength=0)) Then
     Begin
          {$IFDEF WIN32}
          DestroyHandle;
          {$ENDIF}
          Exit;
     End;
     {warum?, die Aktion wandelt mein Windows Bitmap (15478 Byte)
     aus einer Datenbank in etwas anderes (15194 Byte) um, daแ auch noch
     falsche Farben beim Wiedereinlesen aus der DB anzeigt}

     If FBitmapMem<>Nil Then
       If FBitmapMemLength>0 Then
     Begin
         {$IFDEF Win95}
         If Not (Self Is TIcon) Then
         Begin
              Update;
              FH.bfType:=BFT_BMAP;
              FH.bfSize:=SizeOf(BITMAPFILEHEADER)+SizeOf(BitmapCoreHeader);
              FH.bfReserved1:=0;
              FH.bfReserved2:=0;
              FH.bfOffBits:=SizeOf(BITMAPFILEHEADER)+LastcbInfo;
              Stream.WriteBuffer(FH,SizeOf(BITMAPFILEHEADER));
         End
         Else Update;
         {$ENDIF}
         Stream.WriteBuffer(FBitmapMem^,FBitmapMemLength);
     End;

     {$IFDEF WIN32}
     DestroyHandle;
     {$ENDIF}
End;

{$IFDEF OS2}
Procedure TBitmap.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
Var
   BitCount: LongWord;
   DeviceContextData:DEVOPENSTRUC;
   DriverName:cstring;
   PresentationPageSize: SIZEL;
   BitmapInformationHeader: BITMAPINFOHEADER;

   PaletteColors: array[ 0..255 ] of longword;

   OldBitmap: HBITMAP;
   Palette: HPALETTE;
   OldPalette: HPALETTE;
   pDefaultColors: PLONG;
   rc: ERRORID;
Begin
     FIsInvalid:= False; //reset flag !

     ReleaseBitmap;

     If Colors <= 2 Then
       BitCount := 1
     Else If Colors <= 16 Then
       BitCount := 4
     Else If Colors <= 256 Then
       BitCount := 8
     Else If Colors <= 65536 Then
       BitCount := 16
     Else
       BitCount := 32;

     FWidth := NewWidth;
     FHeight := NewHeight;
     FOrigBitCount := BitCount;
     FOrigPlanes := 1;
     FColorCount := Colors;

     // Create a memory device context
     FillChar( DeviceContextData,
               SizeOf( DeviceContextData ),
               0 );

     DriverName:='DISPLAY'; // set to display driver
     DeviceContextData.pszDriverName:= @DriverName;

     FBitmapDC := DevOpenDC( AppHandle, // app anchor block
                             OD_MEMORY, // DC type = memory
                             '*',       // no device information
                             2,         // number of items in dop
                             DeviceContextData, // device open structure
                             0 );       // compatibility with screen
     If FBitmapDC = 0 Then
       InvalidImage;             // failed to create DC

     // Create a presentation space
     PresentationPageSize.CX := 1;
     PresentationPageSize.CY := 1; // huh?

     FBitmapPS := GpiCreatePS( AppHandle,       // app anchor block
                               FBitmapDC,       // device context
                               PresentationPageSize, // size
                               PU_PELS          // use pixels
                               Or GPIA_ASSOC    // associate with DC
                               Or GPIT_MICRO ); // micro PS
     If FBitmapPS = GPI_ERROR Then
       InvalidImage;

     // Create the bitmap

     FillChar( BitmapInformationHeader,
               sizeof( BitmapInformationHeader ),
               0 );
     BitmapInformationHeader.cbFix := sizeof( BitmapInformationHeader );
     BitmapInformationHeader.cx := Width;
     BitmapInformationHeader.cy := Height;
     BitmapInformationHeader.cPlanes := 1;
     BitmapInformationHeader.cBitCount := BitCount;
     FBitmapHandle:= GpiCreateBitmap( FBitmapPS,
                                      BitmapInformationHeader,
                                      0, // don't initialise
                                      nil,
                                      nil );

     // set the bitmap into the presentation space so we can draw on it
     OldBitmap := GpiSetBitmap( FBitmapPS,
                                FBitmapHandle );
     if OldBitmap = HBM_ERROR then
       InvalidImage;

     if BitCount < 16 then
     begin
       // create and initialise the palette

       // blank out palette
       FillChar( PaletteColors, sizeof( PaletteColors ), 0 );

       // retrieve default colors (first 16)
       pDefaultColors := PLONG( @PaletteColors );
       GpiQueryLogColorTable( FBitmapPS,
                              0, // flags
                              0, // first color
                              15, // last color
                              pDefaultColors^ );

       // Create a palette
       Palette := GpiCreatePalette( AppHandle, // application anchor block
                                    0,         // options - none
                                    LCOLF_CONSECRGB, // format (standard)
                                    ColorCount,
                                    PaletteColors );
       if Palette = GPI_ERROR Then
       begin
         rc := WinGetLastError( AppHandle );
         InvalidImage;
       end;

       OldPalette := GpiSelectPalette( FBitmapPS,
                                       Palette );
       if OldPalette = PAL_ERROR Then
         InvalidImage;
     end
     else
     begin
       // set into non-palettised mode (I think?)
       GpiCreateLogColorTable(FBitmapPS,LCOL_RESET,LCOLF_RGB,0,0,NIL);
     end;

     FEmpty:=False;
End;
{$ENDIF}

Function TBitmap.IsEqual(Bitmap:TBitmap):Boolean;
Begin
     Result := False;
     If Bitmap <> Nil Then
       If Bitmap.FBitmapMemLength = FBitmapMemLength Then
       Begin
         If FBitmapMemLength = 0 Then Result := True
         Else If CompareMem(Bitmap.FBitmapMem^,FBitmapMem^,FBitmapMemLength)
              Then Result := True;
       End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TIcon Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TIcon.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Icon';
End;

Function TIcon.GetMaskCanvas:TCanvas;
Begin
     If FBitmapPS=0 Then CreateHandle;

     If FMaskCanvas = Nil Then
     Begin
          FMaskCanvas.Create(Self);
          FMaskCanvas.FBitmap:=Self;
          Include(FMaskCanvas.ComponentState, csDetail);
          FMaskCanvas.Handle := FMaskPS;
          FMaskCanvas.Init;
     End
     Else
     Begin
          If FMaskCanvas.Handle<>FMaskPS Then
          Begin
               FMaskCanvas.Handle:=FMaskPS;
               FMaskCanvas.Init;
          End;
     End;
     Result := FMaskCanvas;
End;


Procedure TIcon.CreateHandle;
Begin
     Inherited CreateHandle;
     If FIsInvalid Then exit; //don't create handle for invalid objects (loop) !

     {$IFDEF WIN32}
     If FMaskHandle=0 Then InvalidImage;
     If FMaskPS=0 Then
     Begin
          FMaskPS:=CreateCompatibleDC(0);
          FOldMaskBitmap:=SelectObject(FMaskPS,FMaskHandle);
     End;

     If FMaskCanvas = Nil Then
     Begin
          FMaskCanvas.Create(Self);
          FMaskCanvas.FBitmap:=Self;
          Include(FMaskCanvas.ComponentState, csDetail);
     End;

     If FMaskCanvas.Handle<>FMaskPS Then
     Begin
        MaskCanvas.Handle:=FMaskPS;
        MaskCanvas.Init;
     End;
     {$ENDIF}
End;


Procedure TIcon.DestroyHandle;
Begin
     Inherited DestroyHandle;

     If PermanentHandle Then exit;

     {$IFDEF WIN32}
     If FMaskPal<>0 Then
       If FMaskPS<>0 Then SelectObject(FMaskPS,FOldMaskPalette);
     FOldMaskPalette:=0;
     If FMaskPS<>0 Then
     Begin
          SelectObject(FMaskPS,FOldMaskBitmap);
          If not DeleteDC(FMaskPS) Then InvalidImage;
     End;
     FMaskPS:=0;
     If FMaskCanvas<>Nil Then FMaskCanvas.Handle:=0;
     FOldMaskBitmap:=0;
     If FMaskHandle<>0 Then If not DeleteObject(FMaskHandle) Then InvalidImage;
     FMaskHandle:=0;
     //FIconPointerHandle remains !
     {$ENDIF}
End;


Procedure TIcon.InvalidImage;
Begin
     FIsInvalid:=True;
     ReleaseBitmap;
     Raise EInvalidIcon.Create(LoadNLSStr(SInvalidIcon));
End;

Function TIcon.GetHandle:LongWord;
Begin
     Result:=FIconPointerHandle;
End;

Procedure TIcon.SetupBitmap;
Begin
     Inherited SetupBitmap;

     CreateIconPointerHandle;

     If FMaskCanvas=Nil Then FMaskCanvas.Create(Self);
     FMaskCanvas.Handle:=FMaskPS;
     FMaskCanvas.Init;
     CreateHandle;
End;

Procedure TIcon.Draw(Canvas:TCanvas;Const Dest:TRect);
{$IFDEF OS2}
Var ptls,maskptls:Array[0..3] Of TPoint;
{$ENDIF}
{$IFDEF Win95}
Var _Dest:TRect;
    OldPal:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     //temporary invert Mask
     maskptls[0].X:=0;
     maskptls[0].Y:=FHeight;
     maskptls[1].X:=FWidth;
     maskptls[1].Y:=FHeight*2;
     maskptls[2].X:=0;
     maskptls[2].Y:=FHeight;
     maskptls[3].X:=FWidth;
     maskptls[3].Y:=FHeight*2;
     GpiBitBlt(FMaskPS,FMaskPS,4,maskptls[0],ROP_NOTSRCCOPY,BBO_IGNORE);

     //Copy Mask Bitmap With logical And (TRANSPARENT areas are now White In the Mask, others Black)
     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=0;
     ptls[2].Y:=FHeight;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight*2;
     GpiBitBlt(Canvas.Handle,FMaskPS,4,ptls[0],ROP_SRCAND,BBO_IGNORE);

     GpiBitBlt(FMaskPS,FMaskPS,4,maskptls[0],ROP_NOTSRCCOPY,BBO_IGNORE);

     //Copy color Bitmap With logical Or
     ptls[0].X:=Dest.Left;
     ptls[0].Y:=Dest.Bottom;
     ptls[1].X:=Dest.Right;
     ptls[1].Y:=Dest.Top;
     ptls[2].X:=0;
     ptls[2].Y:=0;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight;
     GpiBitBlt(Canvas.Handle,FBitmapPS,4,ptls[0],ROP_SRCPAINT,BBO_IGNORE);
     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;

     OldPal:=SelectPalette(Canvas.Handle,FBitmapPal,True);

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,Canvas.Control,Canvas.Graphic);

     //Copy Mask Bitmap With logical And (TRANSPARENT areas are Black In the Mask, others White)
     If (_Dest.Right-_Dest.Left=FWidth) And (_Dest.Top-_Dest.Bottom=FHeight) Then
     Begin
          WinGDI.BitBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                        FWidth,FHeight,FMaskPS,0,0,SRCAND);
     End
     Else
     Begin
          StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                     _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                     FMaskPS, 0, 0, FWidth, FHeight,SRCAND);
     End;

     //Copy color Bitmap With logical Xor
     If (_Dest.Right-_Dest.Left=FWidth) And (_Dest.Top-_Dest.Bottom=FHeight) Then
     Begin
          WinGDI.BitBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                        FWidth,FHeight,FBitmapPS,0,0,SRCINVERT);
     End
     Else
     Begin
          StretchBlt(Canvas.Handle,_Dest.Left,_Dest.Bottom,
                     _Dest.Right-_Dest.Left,_Dest.Top-_Dest.Bottom,
                     FBitmapPS, 0, 0, FWidth, FHeight,SRCINVERT);
     End;

     If OldPal<>FBitmapPal Then SelectPalette(Canvas.Handle,OldPal,True);

     DestroyHandle;
     {$ENDIF}
End;

Procedure TIcon.ReleaseBitmap;
Begin
     If FMaskCanvas<>Nil Then
     Begin
         FMaskCanvas.Destroy;
         FMaskCanvas:=nil;
     End;

     {$IFDEF OS2}
     GpiSetBitmap(FMaskPS,0);// unselect mask bitmap
     If FMaskPal<>0 Then GpiDeletePalette(FMaskPal);
     If FMaskHandle<>0 Then GpiDeleteBitmap(FMaskHandle);
     If FMaskPS<>0 Then GpiDestroyPS(FMaskPS);
     If FMaskDC<>0 Then DevCloseDC(FMaskDC);
     If FIconPointerHandle<>0 Then WinDestroyPointer(FIconPointerHandle);
     {$ENDIF}
     {$IFDEF Win95}
     If FMaskPS<>0 Then
     Begin
          If FMaskHandle<>0 Then SelectObject(FMaskPS,FOldMaskBitmap);
          If FMaskPal<>0 Then SelectObject(FMaskPS,FOldMaskPalette);
     End;
     If FMaskPS<>0 Then If not DeleteDC(FMaskPS) Then InvalidImage;
     If FMaskPal<>0 Then If not DeleteObject(FMaskPal) Then InvalidImage;
     If FMaskHandle<>0 Then If not DeleteObject(FMaskHandle) Then InvalidImage;
     If FIconPointerHandle<>0 Then If not DestroyIcon(FIconPointerHandle) Then InvalidImage;
     {$ENDIF}
     FMaskPS:=0;
     FMaskPal:=0;
     FMaskHandle:=0;
     FMaskDC:=0;
     FIconPointerHandle:=0;

     Inherited ReleaseBitmap;
End;

Procedure TIcon.CreateIconPointerHandle;
{$IFDEF OS2}
Var I:POINTERINFO;
{$ENDIF}
{$IFDEF Win95}
Var I:ICONINFO;
    ADC,MemDC:HDC;
    H,OldBmp:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     GpiSetBitmap(FBitmapPS,0);
     GpiSetBitmap(FMaskPS,0);

     If Self Is TPointer Then I.fPointer:=1
     Else I.fPointer:=0;
     I.XHotSpot:=FXHotSpot;
     I.YHotSpot:=FYHotSpot;
     I.hbmPointer:=FMaskHandle;
     I.hbmColor:=FBitmapHandle;
     I.hbmMiniPointer:=0;
     I.hbmMiniColor:=0;
     FIconPointerHandle:=WinCreatePointerIndirect(HWND_DESKTOP,I);

     GpiSetBitmap(FBitmapPS,FBitmapHandle);
     GpiSetBitmap(FMaskPS,FMaskHandle);
     {$ENDIF}
     {$IFDEF Win95}
     If FIconPointerHandle=0 Then
     Begin
       If Self Is TPointer Then I.FIcon:=False
       Else I.FIcon:=True;

       ADC:=GetDC(0);
       MemDC:=CreateCompatibleDC(ADC);

       //supply both And and Xor Mask For pointers
       If I.FIcon Then H:=CreateBitmap(FWidth,FHeight,1,1,Nil)
       Else H:=CreateBitmap(FWidth,FHeight*2,1,1,Nil);
       OldBmp:=SelectObject(MemDC,H);
       If not I.FIcon Then
       Begin
            WinGDI.BitBlt(MemDC,0,0,FWidth,FHeight*2,MemDC,0,0,WHITENESS);
            WinGDI.BitBlt(MemDC,0,0,FWidth,FHeight,FMaskPS,0,0,SRCCOPY);
       End
       Else WinGDI.BitBlt(MemDC,0,0,FWidth,FHeight,FMaskPS,0,0,SRCCOPY);

       I.XHotSpot:=FXHotSpot;
       I.YHotSpot:=FYHotSpot;
       I.hbmMask:=H;
       I.hbmColor:=FBitmapHandle;
       FIconPointerHandle:=CreateIconIndirect(I);

       SelectObject(MemDC,OldBmp);
       If MemDC<>0 Then If not DeleteDC(MemDC) Then InvalidImage;
       If ReleaseDC(0,ADC)=0 Then InvalidImage;
       If not DeleteObject(H) Then InvalidImage;
     End;
     {$ENDIF}
End;

Procedure TIcon.Update;
{$IFDEF OS2}
Var
    cbBuffer,cbBufferMask:LongWord;
    cbInfo,cbInfoMask:LongWord;
    Buf,BufMask:Pointer;
    BI,BIMask:PBITMAPINFO;
    FH,FHMask:BITMAPFILEHEADER;
    BIH,BIHMask:BITMAPINFOHEADER;
    P:Pointer;
{$ENDIF}
{$IFDEF Win95}
Var
    iDir:TICONDIR;
    iEntry:ICONDIRENTRY;
    BI,BIMask:BitmapInfo;
    pbi,PBIMask:^BitmapInfo;
    P,pMask,pp:Pointer;
    cbInfo,cbInfoMask,cbBuffer,cbBufferMask:LongWord;
{$ENDIF}
Begin
     If ((FBitmapMem=Nil)Or(FBitmapMemLength=0)Or(FBitmapHandle=0)) Then Exit;

     {$IFDEF OS2}
     If FIconPointerHandle<>0 Then WinDestroyPointer(FIconPointerHandle);
     CreateIconPointerHandle;
     {$ENDIF}

     {$IFDEF Win95}
     CreateHandle;
     If FIconPointerHandle<>0 Then DestroyIcon(FIconPointerHandle);
     CreateIconPointerHandle;
     {$ENDIF}

     {$IFDEF OS2}
     BIHMask.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FMaskHandle,BIHMask) Then Exit;
     cbBufferMask:=(((BIHMask.cBitCount*BIHMask.CX)+31) Div 32)*4*BIHMask.CY*BIHMask.cPlanes;
     GetMem(BufMask,cbBufferMask);
     cbInfoMask:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGB)*(1 Shl BIHMask.cBitCount);
     GetMem(BIMask,cbInfoMask);
     Move(BIHMask,BIMask^,SizeOf(BITMAPINFOHEADER));
     GpiQueryBitmapBits(FMaskPS,0,BIHMask.CY,BufMask^,BIMask^);

     If Self Is TPointer Then FHMask.usType:=BFT_COLORPOINTER
     Else FHMask.usType:=BFT_COLORICON;
     FHMask.cbSize:=SizeOf(BITMAPFILEHEADER);
     FHMask.XHotSpot:=FXHotSpot;
     FHMask.YHotSpot:=FYHotSpot;
     FHMask.offBits:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfoMask;

     BIH.cbFix:=SizeOf(BITMAPINFOHEADER);
     If Not GpiQueryBitmapInfoHeader(FBitmapHandle,BIH) Then Exit;
     cbBuffer:=(((BIH.cBitCount*BIH.CX)+31) Div 32)*4*BIH.CY*BIH.cPlanes;
     GetMem(Buf,cbBuffer);
     cbInfo:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGB)*(1 Shl BIH.cBitCount);
     GetMem(BI,cbInfo);
     Move(BIH,BI^,SizeOf(BITMAPINFOHEADER));
     GpiQueryBitmapBits(FBitmapPS,0,BIH.CY,Buf^,BI^);

     If Self Is TPointer Then FH.usType:=BFT_COLORPOINTER
     Else FH.usType:=BFT_COLORICON;
     FH.cbSize:=SizeOf(BITMAPFILEHEADER);
     FH.XHotSpot:=FXHotSpot;
     FH.YHotSpot:=FYHotSpot;
     FH.offBits:=(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfo;
     Inc(FH.offBits,(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfoMask+cbBufferMask);

     Inc(FHMask.offBits,(SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER))+cbInfo);

     FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER)+cbInfo+cbBuffer;
     Inc(FBitmapMemLength,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER)+cbInfoMask+cbBufferMask);
     GetMem(FBitmapMem,FBitmapMemLength);
     P:=FBitmapMem;
     Move(FHMask,P^,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Inc(P,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Move(BIMask^,P^,cbInfoMask);
     Inc(P,cbInfoMask);
     Move(FH,P^,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Inc(P,SizeOf(BITMAPFILEHEADER)-SizeOf(BITMAPINFOHEADER));
     Move(BI^,P^,cbInfo);
     Inc(P,cbInfo);
     Move(BufMask^,P^,cbBufferMask);
     Inc(P,cbBufferMask);
     Move(Buf^,P^,cbBuffer);

     FreeMem(Buf,cbBuffer);
     FreeMem(BI,cbInfo);
     FreeMem(BufMask,cbBufferMask);
     FreeMem(BIMask,cbInfoMask);
     {$ENDIF}
     {$IFDEF Win95}
     CreateHandle;

     SelectObject(FBitmapPS,FOldBitmap);
     SelectObject(FMaskPS,FOldMaskBitmap);

     FillChar(BI,SizeOf(BI),0);
     FillChar(BIMask,SizeOf(BIMask),0);

     BI.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FBitmapPS,FBitmapHandle,0,0,Nil,BI,0);
     If FOrigBitCount>0 Then BI.bmiHeader.biBitCount:=FOrigBitCount;
     If FOrigPlanes>0 Then BI.bmiHeader.biPlanes:=FOrigPlanes;

     BIMask.bmiHeader.biSize:=SizeOf(BITMAPINFOHEADER);
     GetDIBits(FMaskPS,FMaskHandle,0,0,Nil,BIMask,0);

     iDir.idReserved:=0;
     If Self Is TPointer Then iDir.idType:=2
     Else iDir.idType:=1;
     iDir.idCount:=1;
     iDir.idEntries.bWidth:=FWidth;
     iDir.idEntries.bHeight:=FHeight;
     iDir.idEntries.bColorCount:=BI.bmiHeader.biPlanes * (LongWord(1) Shl BI.bmiHeader.biBitCount);
     iDir.idEntries.bReserved:=0;
     iDir.idEntries.wPlanes:=0;
     iDir.idEntries.wBitCount:=0;
     iDir.idEntries.dwBytesInRes:=0{Size Of image};
     iDir.idEntries.dwImageOffset:=SizeOf(TICONDIR);

     cbInfo:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGBQuad)*(1 Shl BI.bmiHeader.biBitCount);
     GetMem(pbi,cbInfo);
     pbi^.bmiHeader:=BI.bmiHeader;
     cbBuffer:=(((BI.bmiHeader.biBitCount*BI.bmiHeader.biWidth)+31) Div 32)
                *4*BI.bmiHeader.biHeight*BI.bmiHeader.biPlanes;
     GetMem(P,cbBuffer);
     GetDIBits(FBitmapPS,FBitmapHandle,0,BI.bmiHeader.biHeight,P^,pbi^,DIB_RGB_COLORS);

     cbInfoMask:=SizeOf(BITMAPINFOHEADER)+SizeOf(RGBQuad)*2;
     GetMem(PBIMask,cbInfoMask);
     With PBIMask^.bmiHeader Do
     Begin
          biSize:=SizeOf(BITMAPINFOHEADER);
          biWidth:=FWidth;
          biHeight:=FHeight;
          biPlanes:=1;
          biBitCount:=1;
     End;
     cbBufferMask:=(((1*BI.bmiHeader.biWidth)+31) Div 32)
                      *4*BI.bmiHeader.biHeight*1;
     GetMem(pMask,cbBufferMask);
     GetDIBits(FMaskPS,FMaskHandle,0,BI.bmiHeader.biHeight,pMask^,PBIMask^,DIB_RGB_COLORS);

     iDir.idEntries.dwBytesInRes:=cbInfo+cbBuffer+cbBufferMask;

     FreeMem(FBitmapMem,FBitmapMemLength);
     FBitmapMemLength:=SizeOf(TICONDIR)+iDir.idEntries.dwBytesInRes;
     GetMem(FBitmapMem,FBitmapMemLength);
     pp:=FBitmapMem;
     Move(iDir,pp^,SizeOf(TICONDIR));
     Inc(pp,SizeOf(TICONDIR));
     pbi^.bmiHeader.biHeight:=FHeight*2;
     pbi^.bmiHeader.biSizeImage:=cbBuffer+cbBufferMask;
     Move(pbi^,pp^,cbInfo);
     Inc(pp,cbInfo);
     Move(P^,pp^,cbBuffer);
     Inc(pp,cbBuffer);
     Move(pMask^,pp^,cbBufferMask);

     FreeMem(pbi,cbInfo);
     FreeMem(PBIMask,cbInfoMask);
     FreeMem(P,cbBuffer);
     FreeMem(pMask,cbBufferMask);
     SelectObject(FBitmapPS,FBitmapHandle);
     SelectObject(FMaskPS,FMaskHandle);

     DestroyHandle;
     {$ENDIF}
End;


Procedure TIcon.LoadFromResourceName(Const Name:String);
Var P:Pointer;
    len:LongWord;
Begin
     FIsInvalid:=False; //reset flag !

     P:=FindIconRes(Name,len);
     If ((P=Nil)Or(len=0)) Then InvalidImage;

     ReleaseBitmap;
     FBitmapMemLength:=len;
     GetMem(FBitmapMem,FBitmapMemLength);
     Move(P^,FBitmapMem^,FBitmapMemLength);
     SetupBitmap;
     changed;
     {$IFDEF WIN32}
     DestroyHandle;
     {$ENDIF}
End;

Procedure TIcon.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
{$IFDEF OS2}
Var dop:DEVOPENSTRUC;
    pc:cstring;
    sizl:SIZEL;
    BIH:BITMAPINFOHEADER;
    ps,DC:LongWord;
    ptls:Array[0..3] Of TPoint;
{$ENDIF}
Begin
     FIsInvalid:=False; //reset flag !

     If ((Colors<>2)And(Colors<>16)) Then Colors:=16;
     If ((NewWidth<>16)And(NewWidth<>32)And(NewWidth<>64)) Then NewWidth:=32;
     If ((NewHeight<>16)And(NewHeight<>32)And(NewHeight<>64)) Then NewHeight:=32;
     Inherited CreateNew(NewWidth,NewHeight,Colors);

     {$IFDEF Win95}
     FMaskWidth:=FWidth;
     FMaskHeight:=FHeight;
     FMaskHandle:=CreateBitmap(FWidth,FHeight,1,1,Nil);
     If FMaskHandle=0 Then InvalidImage;
     FMaskPS:=CreateCompatibleDC(0);
     FOldMaskPalette:=SelectPalette(FMaskPS,FBitmapPal,True);
     FOldMaskBitmap:=SelectObject(FMaskPS,FMaskHandle);
     WinGDI.BitBlt(FMaskPS,0,0,FWidth,FHeight,FMaskPS,0,0,WHITENESS);
     {$ENDIF}
     {$IFDEF OS2}
     FMaskWidth:=FWidth;
     FMaskHeight:=FHeight*2;

     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     DC := DevOpenDC(AppHandle,OD_MEMORY,'*',3,dop,0);
     If DC=0 Then InvalidImage;
     FMaskDC:=DC;

     sizl.CX := 1;
     sizl.CY := 1;
     ps := GpiCreatePS(AppHandle,DC,sizl,PU_PELS Or GPIA_ASSOC Or GPIT_MICRO);
     If ps = GPI_ERROR Then InvalidImage;
     GpiCreateLogColorTable(ps,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     FMaskPS:=ps;

     With BIH Do
     Begin
          cbFix:=SizeOf(BITMAPINFOHEADER);
          CX:=FMaskWidth;
          CY:=FMaskHeight;
          cPlanes:=1;
          cBitCount:=1;
     End;
     FMaskHandle:=GpiCreateBitmap(FMaskPS,BIH,0,Nil,Nil);
     If FMaskHandle=0 Then InvalidImage;

     FOldMaskBitmap:=GpiSetBitmap(FMaskPS,FMaskHandle);
     If FOldMaskBitmap = HBM_ERROR Then InvalidImage;

     ptls[0].X:=0;
     ptls[0].Y:=0;
     ptls[1].X:=FWidth;
     ptls[1].Y:=FHeight;
     ptls[2].X:=0;
     ptls[2].Y:=0;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight;
     GpiBitBlt(FMaskPS,FMaskPS,4,ptls[0],ROP_ZERO,BBO_IGNORE);

     ptls[0].X:=0;
     ptls[0].Y:=FHeight;
     ptls[1].X:=FWidth;
     ptls[1].Y:=FHeight*2;
     ptls[2].X:=0;
     ptls[2].Y:=FHeight;
     ptls[3].X:=FWidth;
     ptls[3].Y:=FHeight*2;
     GpiBitBlt(FMaskPS,FMaskPS,4,ptls[0],ROP_ONE,BBO_IGNORE);
     {$ENDIF}

     FMaskCanvas.Create(Self);
     FMaskCanvas.Handle:=FMaskPS;
     FMaskCanvas.Init;

     Update;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPointer Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TPointer.InvalidImage;
Begin
     FIsInvalid:=True;
     ReleaseBitmap;
     Raise EInvalidCursor.Create(LoadNLSStr(SInvalidCursor));
End;

Procedure TPointer.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Pointer';
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBitmapList Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TBitmapList.CopyBitmap(original:TBitmap):TBitmap;
Var  locClass:TBitmapClass;
Begin
     If original Is TBitmap Then
     Begin
          {Create local Bitmap}
          If FBitmapClass <> Nil Then locClass := BitmapClass
          Else locClass := original.ClassType;
          Result := locClass.Create;
          If Original.Owner<>Nil Then
          Begin
              Result.Owner:=Original.Owner;
              Original.Owner.InsertComponent(Result);
          End;
          Result.LoadFromBitmap(original);
     End
     Else Result := Nil;
End;


Function TBitmapList.GetBitmap(Index:LongInt):TBitmap;
Begin
     Result := Items[Index];
End;


Procedure TBitmapList.SetBitmap(Index:LongInt;Bitmap:TBitmap);
Var  Item:TBitmap;
Begin
     Item := Items[Index];
     FreeItem(Item);
     Items[Index] := CopyBitmap(Bitmap);
End;


Procedure TBitmapList.FreeItem(Item:Pointer);
Var  bmp:TBitmap;
Begin
     {Destroy local Bitmap}
     bmp := Item;
     If bmp Is TBitmap Then bmp.Destroy;
End;


Function TBitmapList.Add(Item:TBitmap):LongInt;
Begin
     If Not FDuplicates Then
     Begin
          Result := IndexOfOrigin(Item);
          If Result >= 0 Then Exit;     {original found}
     End;

     Result := TList.Add(CopyBitmap(Item));
End;


Function TBitmapList.AddResourceId(BmpId:LongWord):LongInt;
Var  bmp:TBitmap;
Begin
     bmp.Create;
     bmp.LoadFromResourceId(BmpId);
     Result := Add(bmp);   {creates A local Copy}
     bmp.Destroy; {#}
End;


Function TBitmapList.AddResourceName(Const Name:String):LongInt;
Var  bmp:TBitmap;
Begin
     bmp.Create;
     bmp.LoadFromResourceName(Name);
     Result := Add(bmp);   {creates A local Copy}
     bmp.Destroy; {#}
End;


Procedure TBitmapList.Insert(Index:LongInt;Item:TBitmap);
Begin
     TList.Insert(Index,CopyBitmap(Item));
End;


Function TBitmapList.IndexOfOrigin(Item:TBitmap):LongInt;
Var  locBitmap:TBitmap;
Begin
     For Result := 0 To Count-1 Do
     Begin
          locBitmap := Items[Result];
          If locBitmap <> Nil Then
            If locBitmap.IsEqual(Item) Then Exit;
     End;
     Result := -1;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TImageList Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Function TImageList.NewItem:PImageItem;
Begin
    New(Result);
End;

Function TImageList.Add(Image,Mask:TBitmap):LongInt;
Var Item:PImageItem;
Begin
    Item:=NewItem;
    Item^.Bitmap:=Image.Copy;
    If Mask<>Nil Then Item^.Mask:=Mask.Copy;
    Result:=FList.Add(Item);
    Change;
End;

Function TImageList.AddIcon(Image:TIcon):LongInt;
Var Item:PImageItem;
Begin
    Item:=NewItem;
    Item^.Icon:=TIcon(Image.Copy);
    Result:=FList.Add(Item);
    Change;
End;

Procedure TImageList.AddImages(Value:TImageList);
Var t:LongInt;
    Item,Item1:PImageItem;
Begin
    If Value<>Nil Then For t:=0 To Value.Count-1 Do
    Begin
        Item:=Value.FList[t];
        Item1:=NewItem;
        If Item^.Bitmap<>Nil Then Item1^.Bitmap:=Item^.Bitmap.Copy;
        If Item^.Mask<>Nil Then Item1^.Mask:=Item^.Mask.Copy;
        If Item^.Icon<>Nil Then Item1^.Icon:=TIcon(Item^.Icon.Copy);

        FList.Add(Item1);
    End;
    Change;
End;

Procedure TImageList.Initialize;
Begin
    FImageType:=itImage;
    FMasked:=False;

    FList.Create;
    FList.ImageList:=Self;
End;

Procedure TImageList.SetupComponent;
Begin
    Inherited SetupComponent;
    Name:='ImageList';

    Include(ComponentState, csHandleLinks);
    Initialize;
End;

Procedure TImageList.DisposeItem(Item:PImageItem);
Begin
    Dispose(Item);
End;

Procedure TImageList.Clear;
Var t:LongInt;
    Item:PImageItem;
Begin
    For t:=0 To FList.Count-1 Do
    Begin
        Item:=FList[t];
        If Item^.Bitmap<>Nil Then Item^.Bitmap.Destroy;
        If Item^.Mask<>Nil Then Item^.Mask.Destroy;
        If Item^.Icon<>Nil Then Item^.Icon.Destroy;
        DisposeItem(Item);
    End;
    FList.Clear;
    Change;
End;

Destructor TImageList.Destroy;
Begin
    Clear;
    FList.Destroy;
    Inherited Destroy;
End;

Procedure TImageList.Change;
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;

Function TImageList.GetCount:LongInt;
Begin
     Result:=FList.Count;
End;

Procedure TImageList.Delete(Index:LongInt);
Var Item:PImageItem;
Begin
     Item:=FList[Index];
     FList.Delete(Index);
     If Item^.Bitmap<>Nil Then Item^.Bitmap.Destroy;
     If Item^.Mask<>Nil Then Item^.Mask.Destroy;
     If Item^.Icon<>Nil Then Item^.Icon.Destroy;
     DisposeItem(Item);
End;

Procedure TImageList.Replace(Index:LongInt;Image,Mask:TBitmap);
Var Item:PImageItem;
Begin
   Item:=FList[Index];
   If Item^.Bitmap<>Nil Then Item^.Bitmap.Destroy;
   If Item^.Mask<>Nil Then Item^.Mask.Destroy;
   Item^.Bitmap:=Image.Copy;
   If Mask<>Nil Then Item^.Mask:=Mask.Copy
   Else Item^.Mask:=Nil;
End;

Procedure TImageList.ReplaceIcon(Index:LongInt;Image:TIcon);
Var Item:PImageItem;
Begin
    Item:=FList[Index];
    If Item^.Icon<>Nil Then Item^.Icon.Destroy;
    Item^.Icon:=TIcon(Image.Copy);
End;

Procedure TImageList.Insert(Index:LongInt;Image,Mask:TBitmap);
Var Item:PImageItem;
Begin
     Item:=NewItem;
     Item^.Bitmap:=Image.Copy;
     If Mask<>Nil Then Item^.Mask:=Mask.Copy;
     FList.Insert(Index,Item);
End;

Procedure TImageList.InsertIcon(Index:LongInt;Image:TIcon);
Var Item:PImageItem;
Begin
     Item:=NewItem;
     Item^.Icon:=TIcon(Image.Copy);
     FList.Insert(Index,Item);
End;

Procedure TImageList.GetBitmap(Index:LongInt;Image:TBitmap);
Begin
     Image.LoadFromBitmap(PImageItem(FList[Index])^.Bitmap);
End;

Function TImageList.GetBitmapReference( Index:LongInt ): TBitmap;
Begin
     Result := PImageItem( FList[ Index ] )^.Bitmap;
End;

Procedure TImageList.GetIcon(Index: Integer;Icon:TIcon);
Begin
     Icon.LoadFromBitmap(PImageItem(FList[Index])^.Icon);
End;

Procedure TImageList.GetMask(Index:LongInt;Mask:TBitmap);
Begin
     Mask.LoadFromBitmap(PImageItem(FList[Index])^.Mask);
End;

Procedure TImageList.Move(CurIndex,NewIndex:LongInt);
Begin
     FList.Move(CurIndex,NewIndex);
End;

Procedure TImageList.Draw(Canvas:TCanvas;X,Y,Index:LongInt);
Var Bitmap,Mask:TBitmap;
    Source,Dest:TRect;
Begin
    Bitmap.Create;
    Try
      If ImageType=itImage Then GetBitmap(Index,Bitmap)
      Else GetMask(Index,Bitmap);
    Except
      Bitmap.Destroy;
      Bitmap:=Nil;
    End;
    If Bitmap=Nil Then exit;
    If Bitmap.Empty Then
    Begin
        Bitmap.Destroy;
        exit;
    End;

    Dest.Left:=X;
    Dest.Bottom:=Y;
    Dest.Right:=Dest.Left+Bitmap.Width;
    Dest.Top:=Dest.Bottom+Bitmap.Height;
    If ImageType=itImage Then
    Begin
         If Masked Then
         Begin
            Mask.Create;
            Try
              GetMask(Index,Mask)
            Except
              Mask.Destroy;
              Mask:=Nil;
            End;
            If Mask=Nil Then
            Begin
                 Bitmap.Destroy;
                 exit;
            End;
            If Mask.Empty Then
            Begin
                Mask.Destroy;
                Bitmap.Draw(Canvas,Dest);
                Bitmap.Destroy;
                exit;
            End;

            Source.Left:=0;
            Source.Right:=Mask.Width;
            Source.Bottom:=0;
            Source.Top:=Mask.Height;
            Mask.Canvas.BitBlt(Canvas,Dest,Source,cmSrcAnd,bitfIgnore);
            Source.Right:=Bitmap.Width;
            Source.Top:=Bitmap.Height;
            Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcPaint,bitfIgnore);
            Mask.Destroy;
         End
         Else Bitmap.Draw(Canvas,Dest);
    End
    Else Bitmap.Draw(Canvas,Dest);
    Bitmap.Destroy;
End;

Procedure TImageList.SetList(Item:TImageItemList);
Begin
    If Item<>Nil Then If FList<>Item Then
    Begin
        FList.Destroy;
        FList:=Item;
    End;
End;

Procedure TImageList.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var Count,t,l:LongInt;
    pl:^LONGINT;
    p:Pointer;
    Item:PImageItem;

    Procedure ReadImage(Var Bitmap:TBitmap;IsIcon:Boolean);
    Begin
         l:=pl^;
         inc(pl,4);
         If l<>0 Then
         Begin
              GetMem(p,l);
              System.Move(pl^,p^,l);
              inc(pl,l);
              If IsIcon Then Bitmap:=TIcon.Create
              Else Bitmap:=TBitmap.Create;
              Bitmap.LoadFromMem(p^,l);
              FreeMem(p,l);
         End;
    End;

Begin
    If ResName=rnBitmapList Then
    Begin
         pl:=@Data;
         Count:=pl^;
         inc(pl,4);
         For t:=0 To Count-1 Do
         Begin
              Item:=NewItem;

              ReadImage(Item^.Bitmap,False);
              ReadImage(Item^.Mask,False);
              ReadImage(Item^.Icon,True);

              FList.Add(Item);
         End;
    End
    Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;

Function TImageList.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    t:LONGINT;
    Item:PImageItem;

    Procedure WriteImage(Bitmap:TBitmap);
    Var tt:Longint;
        BStream:TMemoryStream;
    Begin
        tt:=0;
        If Bitmap=Nil Then MemStream.Write(tt,4)
        Else
        Begin
            BStream.Create;
            Try
              Bitmap.SaveToStream(BStream);
              tt:=BStream.Size;
              MemStream.Write(tt,4);
              MemStream.Write(BStream.Memory^,BStream.Size);
            Finally
              BStream.Destroy;
            End;
        End;
    End;

Begin
     result:=Inherited WriteSCUResource(Stream);
     If not result Then exit;

     MemStream.Create;

     t:=FList.Count;
     MemStream.Write(t,4);

     For t:=0 To FList.Count-1 Do
     Begin
          Item:=FList[t];
          Try
            WriteImage(Item^.Bitmap);
            WriteImage(Item^.Mask);
            WriteImage(Item^.Icon);
          Except
            MemStream.Destroy;
            MemStream:=Nil;
            t:=FList.Count-1;
          End;
     End;

     If MemStream<>Nil Then
     Begin
       result:=Stream.NewResourceEntry(rnBitmapList,MemStream.Memory^,MemStream.Size);
       MemStream.Destroy;
     End
     Else Result:=False;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMetaFileCanvas Class Implementation                        บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ completed by Martin Vieregg www.hypermake.de (3/2004)                     บ                                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TMetaFileCanvas.Create(AMetafile: TMetafile);
{$IFDEF OS2}
Var sizlPage:SIZEL;
{$ENDIF}
Begin
     If ((AMetaFile=Nil)Or(AMetaFile.FMetaFileCanvas<>Nil)) Then Fail;

     Inherited Create(AMetaFile);
     Include(ComponentState, csDetail);
     {$IFDEF OS2}
     sizlPage.CX:=0;
     sizlPage.CY:=0;
     Handle := GpiCreatePS(AppHandle,AMetaFile.FDeviceHandle,sizlPage,
                           PU_PELS OR GPIA_ASSOC);
     GpiCreateLogColorTable(Handle,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     {$ENDIF}
     Init;
     FMetaFile:=AMetaFile;
     FMetaFile.FMetaFileCanvas:=Self;
End;

Destructor TMetaFileCanvas.Destroy;
Begin
     {$IFDEF OS2}
     If Handle<>0 Then
     Begin
          GpiAssociate(Handle,0);
          GpiDestroyPS(Handle);
          Handle:=0;
     End;
     {$ENDIF}
     FMetaFile.FMetaFileCanvas:=Nil;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMetaFile Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TMetaFile.GetEmpty: Boolean;
Begin
     //not implemented yet
     Result:=False;
End;

const
  co : longword = 22;

Function TMetaFile.GetHeight:LongInt;
  var
    Size : PSIZEL;
    P : Pointer;
    len : longint;
Begin
   Len:=GpiQueryMetaFileLength(FHandle);
   GetMem(p,Len);
   GpiQueryMetaFileBits(FHandle,0,Len,p^);
   size := p+co;
   result := size^.cy;
   //result := 200;
   FreeMem(p,Len);

End;

Function TMetaFile.GetWidth:LongInt;
  var
    Size : PSIZEL;
    P : Pointer;
    len : longint;
Begin
   Len:=GpiQueryMetaFileLength(FHandle);
   GetMem(p,Len);
   GpiQueryMetaFileBits(FHandle,0,Len,p^);
   size := p+co;
   result := size^.cx;
   //result := 200;
   FreeMem(p,Len);

End;

Procedure TMetaFile.Assign(Source:TPersistent);
Begin
     If Source Is TMetaFile Then
     Begin
          If FMetaFileCanvas<>Nil Then FMetaFileCanvas.Destroy;
          {$IFDEF OS2}
          If FDeviceHandle<>0 Then DevCloseDC(FDeviceHandle);
          FDeviceHandle:=0;
          If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
          FHandle:=0;
          If TMetaFile(Source).FHandle<>0 Then
            FHandle:=GpiCopyMetaFile(TMetaFile(Source).FHandle);
          {$ENDIF}
     End
     Else Inherited Assign(Source);
End;

(*

alOpt[PMF_SEGBASE] = 0; /* Reserved */
alOpt[PMF_LOADTYPE] = LT_DEFAULT; /* Default transformations */
alOpt[PMF_RESOLVE] = 0; /* Reserved */
alOpt[PMF_LCIDS] = LC_DEFAULT; /* Uses default lcids */
alOpt[PMF_RESET] = RES_DEFAULT; /* Uses default */
alOpt[PMF_SUPPRESS] = SUP_DEFAULT; /* Uses default */
alOpt[PMF_COLORTABLES] = CTAB_DEFAULT; /* Uses default */
alOpt[PMF_COLORREALIZABLE] = CREA_DEFAULT; /* Uses default */

GpiPlayMetaFile(hps, /* Plays metafile onto screen */
hmf, 8L, alOpt, (PLONG) NULL, 0L, (PSZ) NULL);
} /* fncMETA02 */


*)

{Martin: a lot of stuff was missing here}
{$HINTS OFF}

Procedure TMetaFile.GetOriginalRect(Var Rect: RECTL);
{$IFDEF OS2}
Var alOpt:Array[0..8] Of LongInt;
  L : Long;
  xyRect : RECTL;
  Boundary: RECTL;
  Size : SIZEL;
  flOptions : ULONG;
  dc: HDC;
  ps: HPS;
  lSegCount: LONG;
{$ENDIF}
Begin
{$IFDEF OS2}
  PS := WinGetScreenPS( HWND_DESKTOP );
     alOpt[PMF_SEGBASE]:=0;
     alOpt[PMF_LOADTYPE]:=LT_NOMODIFY; // current (default) transform
     alOpt[PMF_RESOLVE]:=0;
     alOpt[PMF_LCIDS]:=LC_LOADDISC ; // load bitmaps and fonts  was LC_DEFAULT; // don't load bitmaps & fonts (??)
     alOpt[PMF_RESET]:=RES_NORESET; // don't reset Pres space
     alOpt[PMF_SUPPRESS]:=SUP_NOSUPPRESS; // really draw
     alOpt[PMF_COLORTABLES]:=(*CTAB_DEFAULT*)CTAB_REPLACE; // load color table
     alOpt[PMF_COLORREALIZABLE]:=CREA_DEFAULT; // irrelevant in 32 bit land
     alOpt[PMF_DEFAULTS]:= DDEF_LOADDISC;

     // reset boundaries
     GpiResetBoundaryData ( ps );

     // note boundary returned in MODEL coordinates
     GpiSetDrawControl ( ps, DCTL_BOUNDARY, DCTL_ON ); // accumulate boundary data
     GpiSetDrawControl ( ps, DCTL_DISPLAY, DCTL_OFF ); // turn display off

     l := GpiQueryDrawControl ( ps, DCTL_BOUNDARY ); // accumulate boundary data

     GpiPlayMetaFile(ps, FHandle,9,alOpt[0],lSegCount,0,Nil);

     l := GpiQueryDrawControl ( ps, DCTL_BOUNDARY ); // accumulate boundary data

     GpiQueryBoundaryData( ps, Boundary );

     GpiSetDrawControl ( ps, DCTL_BOUNDARY, DCTL_OFF ); // stop accumulating boundary data
     GpiSetDrawControl ( ps, DCTL_DISPLAY, DCTL_ON ); // turn display on

     WinReleasePS( ps );
     {$ENDIF}
End;
{$HINTS ON}

Procedure TMetaFile.Draw(ACanvas: TCanvas;Const Rect: TRect);
{$IFDEF OS2}
Var alOpt:Array[0..8] Of LongInt;
  L : Long;
  xyRect : RECTL;
  Boundary: RECTL;
  Size : SIZEL;
  flOptions : ULONG;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FHandle=0 Then
     Begin
          FHandle:=DevCloseDC(FDeviceHandle);
          FDeviceHandle:=0;
     End;

     GetOriginalRect( xyRect );
     GpiResetPS (ACanvas.Handle, GRES_ALL ); // GRES_ATTRS);

     alOpt[PMF_SEGBASE]:=0;
     alOpt[PMF_LOADTYPE]:=LT_ORIGINALVIEW; // Use original transform
     alOpt[PMF_RESOLVE]:=0;
     alOpt[PMF_LCIDS]:=LC_LOADDISC ; // load bitmaps and fonts  was LC_DEFAULT; // don't load bitmaps & fonts (??)
     alOpt[PMF_RESET]:=RES_RESET; // reset Pres space
     alOpt[PMF_SUPPRESS]:=SUP_SUPPRESS; // don't really draw yet!
     alOpt[PMF_COLORTABLES]:=(*CTAB_DEFAULT*)CTAB_REPLACE; // load color table
     alOpt[PMF_COLORREALIZABLE]:=CREA_DEFAULT; // irrelevant in 32 bit land
     alOpt[PMF_DEFAULTS]:= DDEF_LOADDISC;

     // "play" - just reset PS values to original defaults
     L := GpiPlayMetaFile(ACanvas.Handle,FHandle,9,alOpt[0],Nil,0,Nil);

     // reset boundary calculations.
     if not GpiResetBoundaryData ( ACanvas.Handle ) then
       L := WInGetLastError( AppHandle );

     ACanvas.Line( 0, 0, 500, 500 );
     // note boundary returned in MODEL coordinates
     if not GpiSetDrawControl ( ACanvas.Handle, DCTL_BOUNDARY, DCTL_ON ) // accumulate boundary data
       then
       L := WInGetLastError( AppHandle );
     if not GpiSetDrawControl ( ACanvas.Handle, DCTL_DISPLAY, DCTL_OFF ) // turn display off
       then
       L := WInGetLastError( AppHandle );

     // Now adjust the page viewport

     // pmgpi
//     xyRect := RECTL (Rect);
     (*GpiSetViewingLimits*)
//     if not GpiSetPageViewport (ACanvas.Handle, xyRect) then
//       L := WinGetLastError( AppHandle );

     // now draw
     alOpt[PMF_SUPPRESS]:=SUP_NOSUPPRESS; // don't really draw yet!
     alOpt[PMF_RESET]:=RES_NORESET; // don't reset PS again
     L := GpiPlayMetaFile(ACanvas.Handle,FHandle,9,alOpt[0],Nil,0,Nil);
     If L = GPI_ERROR then
       L := WinGetLastError( AppHandle );

     if not GpiQueryBoundaryData( ACanvas.Handle,Boundary) then
       L := WInGetLastError( AppHandle );

     if not GpiSetDrawControl ( ACanvas.Handle, DCTL_BOUNDARY, DCTL_OFF )// stop accumulating boundary data
       then
       L := WInGetLastError( AppHandle );

     if not GpiSetDrawControl ( ACanvas.Handle, DCTL_DISPLAY, DCTL_ON ) // turn display on
     then
       L := WInGetLastError( AppHandle );

     (*xyRect.xLeft := 0;
     xyRect.yBottom := 0;
     //if (FWidth = 0) or (FHeight = 0) then Beep (100, 100);
     xyRect.xRight := FWidth;
     xyRect.yTop:= FHeight;*)
     //if you do not use this function, the Metafile is drawn in original size
//     GpiSetPageViewport (ACanvas.Handle, xyRect);

     (*
     flOptions := PU_ARBITRARY OR  /* arbitrary units. */
                  GPIF_DEFAULT;    /* normal ps format. */
     Size.cx := 100;
     Size.cy := 100;
     if GpiSetPS (ACanvas.Handle, Size, flOptions) then Beep (1000, 100) else Beep (50, 100);*)

//     alOpt[PMF_RESET]:=RES_DEFAULT;
//     alOpt[PMF_SUPPRESS]:=SUP_DEFAULT;
     //alOpt[PMF_DEFAULTS]:= DDEF_LOADDISC;
//     L := GpiPlayMetaFile(ACanvas.Handle,FHandle,8,alOpt[0],Nil,0,Nil);
     (*if L = GPI_ERROR then Beep (50, 200)
     else if L = GPI_HITS then Beep (400, 200)
     else if L = GPI_OK then Beep (2000, 200);*)
     {$ENDIF}
End;
{$HINTS ON}

{$HINTS OFF}
Procedure TMetaFile.SetHeight(Value:LongInt);
Begin
  //not implemented yet
  //FHeight := Value;
End;

Procedure TMetaFile.SetWidth(Value:LongInt);
Begin
  //not implemented yet
  //FWidth := Value;
End;
{$HINTS ON}

Procedure TMetaFile.SetupComponent;
{$IFDEF OS2}
Var dop:DEVOPENSTRUC;
    pc:CString;
{$ENDIF}
Begin
     Inherited SetupComponent;

     {$IFDEF OS2}
     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     FDeviceHandle:=DevOpenDC(AppHandle,OD_METAFILE,'*',2,dop,0);
     {$ENDIF}
End;

Destructor TMetaFile.Destroy;
Begin
     If FMetaFileCanvas<>Nil Then FMetaFileCanvas.Destroy;
     {$IFDEF OS2}
     If FDeviceHandle<>0 Then DevCloseDC(FDeviceHandle);
     FDeviceHandle:=0;
     If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
     FHandle:=0;
     {$ENDIF}
End;

Function TMetaFile.GetHandle:LongWord;
Begin
     Result:=FHandle;
End;

Procedure TMetaFile.LoadFromFile(Const FileName:String);
Begin
     {$IFDEF OS2}
     FHandle:=GpiLoadMetaFile(AppHandle,FileName);
     {$ENDIF}
End;

Procedure TMetaFile.SaveToFile(Const Filename: String);
Begin
     {$IFDEF OS2}
     If FHandle=0 Then
     Begin
         If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
         FHandle:=DevCloseDC(FDeviceHandle);
         FDeviceHandle:=0;
     End;
     GpiSaveMetaFile(FHandle,FileName);
     {$ENDIF}
End;

Procedure TMetaFile.LoadFromStream(Stream: TStream);
Var p:Pointer;
    Len:LongInt;
Begin
    {$IFDEF OS2}
    Len:=Stream.Size-Stream.Position;
    GetMem(p,Len);
    Stream.Read(p^,Stream.Size-Stream.Position);
    If FHandle=0 Then
    Begin
        If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
        FHandle:=DevCloseDC(FDeviceHandle);
        FDeviceHandle:=0;
    End;
    GpiSetMetaFileBits(FHandle,0,Len,p^);
    FreeMem(p,Len);
    {$ENDIF}
End;

Procedure TMetaFile.SaveToStream(Stream: TStream);
Var p:Pointer;
    Len:LongInt;
Begin
   {$IFDEF OS2}
   If FHandle=0 Then
   Begin
        If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
        FHandle:=DevCloseDC(FDeviceHandle);
        FDeviceHandle:=0;
   End;
   Len:=GpiQueryMetaFileLength(FHandle);
   GetMem(p,Len);
   GpiQueryMetaFileBits(FHandle,0,Len,p^);
   Stream.Write(p^,Len);
   FreeMem(p,Len);
   {$ENDIF}
End;

Function TMetaFile.CopyGraphic:TGraphic;
Begin
     Result:=TMetaFile.Create;
     {$IFDEF OS2}
     If FHandle=0 Then
     Begin
         If FMetaFileCanvas<>Nil Then GpiAssociate(FMetaFileCanvas.Handle,0);
         FHandle:=DevCloseDC(FDeviceHandle);
         FDeviceHandle:=0;
     End;
     TMetaFile(Result).FHandle:=GpiCopyMetaFile(FHandle);
     {$ENDIF}
End;

Procedure TMetaFile.LoadFromHandle(Handle:LongWord);
Begin
     {$IFDEF OS2}
     If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
     FHandle:=GpiCopyMetaFile(Handle);
     {$ENDIF}
End;

{Martin}
Function TMetaFile.LoadFromClipBoard:Boolean;
Var hbmClipbrd:LongWord;
Begin
     //FIsInvalid:=False; //reset flag !

{
  // requires FP4? - AaronL
     Result:=False;
     Clipboard.Open(Handle);
     If Clipboard.IsFormatAvailable(cfMetafile) Then
     Begin
          hbmClipbrd:=Clipboard.GetAsHandle(cfMetafile);
          If hbmClipbrd<>0 Then
          Begin
               LoadFromHandle(hbmClipbrd);
               Result:=Not Empty;
          End;
     End;

     Clipboard.Close;
}

End;



Function TMetaFile.GetCanvas:TCanvas;
Begin
     Result:=TCanvas(FMetaFileCanvas);
End;

Function TMetaFile.GetSize:LongInt;
Begin
     {$IFDEF OS2}
     If FHandle<>0 Then Result:=GpiQueryMetaFileLength(FHandle)
     Else Result:=0;
     {$ENDIF}
End;

{$HINTS OFF}
Procedure TMetaFile.PaletteChanged;
Begin
     //not implemented yet
End;
{$HINTS ON}

{$HINTS OFF}
Procedure TMetaFile.CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);
{$IFDEF OS2}
Var dop:DEVOPENSTRUC;
    pc:CString;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FMetaFileCanvas<>Nil Then FMetaFileCanvas.Destroy;
     If FDeviceHandle<>0 Then DevCloseDC(FDeviceHandle);
     FDeviceHandle:=0;
     If FHandle<>0 Then GpiDeleteMetaFile(FHandle);
     FHandle:=0;
     FillChar(dop,SizeOf(DEVOPENSTRUC),0);
     pc:='DISPLAY';
     dop.pszDriverName:=@pc;
     FDeviceHandle:=DevOpenDC(AppHandle,OD_METAFILE,'*',2,dop,0);
     {$ENDIF}
End;
{$HINTS ON}

{$HINTS OFF}
Function TMetaFile.CreateMask(Color:TColor):TGraphic;
Begin
     //not supported yet
     Result:=Nil;
End;
{$HINTS ON}

{$HINTS OFF}
Procedure TMetaFile.PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);
Begin
     //not supported yet
End;
{$HINTS ON}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPicture Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TPicture.GetBitmap:TBitmap;
Begin
     ForceType(TBitmap);
     Result:=TBitmap(FGraphic);
End;

Function TPicture.GetEmpty:Boolean;
Begin
     Result:=FGraphic=Nil;
End;

Function TPicture.HasFormat(GraphicClass:TGraphicClass):Boolean;
Begin
     Result:=FGraphic Is GraphicClass;
End;

Function TPicture.GetHeight:LongInt;
Begin
    If FGraphic<>Nil Then Result:=FGraphic.Height
    Else Result:=0;
End;

Procedure TPicture.AssignTo(Dest:TPersistent);
Begin
     If FGraphic Is Dest.ClassType Then Dest.Assign(FGraphic)
     Else Inherited AssignTo(Dest);
End;

Procedure TPicture.Assign(Source:TPersistent);
Begin
    If Source=Nil then Graphic:=Nil
    Else If Source Is TGraphic Then Graphic:=TGraphic(Source)
    Else If Source Is TPicture Then Graphic:=TPicture(Source).Graphic
    Else Inherited Assign(Source);
End;

Function TPicture.GetIcon:TIcon;
Begin
     ForceType(TIcon);
     Result:=TIcon(FGraphic);
End;

Function TPicture.GetMetafile:TMetafile;
Begin
     ForceType(TMetaFile);
     Result:=TMetaFile(FGraphic);
End;

Function TPicture.GetWidth:LongInt;
Begin
     If FGraphic<>Nil Then Result:=FGraphic.Width
     Else Result:=0;
End;

Procedure TPicture.SetBitmap(Value: TBitmap);
Begin
     SetGraphic(Value);
End;

Procedure TPicture.SetIcon(Value: TIcon);
Begin
     SetGraphic(Value);
End;

Procedure TPicture.SetMetafile(Value: TMetafile);
Begin
     SetGraphic(Value);
End;

Procedure TPicture.SetGraphic(Value: TGraphic);
Var  NewGraphic:TGraphic;
Begin
     // do not destroy the graphic object changed by the inspector
     If FGraphic <> Value Then
     Begin
          If Value <> Nil Then
          Begin
               NewGraphic := Value.CopyGraphic;
               NewGraphic.OnChange := Changed;
          End
          Else NewGraphic := Nil;

          If FGraphic <> Nil Then FGraphic.Destroy;
          FGraphic := NewGraphic;
          Changed(Self);
     End;
End;

Procedure TPicture.Changed(Sender: TObject);
Begin
     If FOnChange<>Nil Then FOnChange(Self);
End;


Destructor TPicture.Destroy;
Begin
     If FGraphic<>Nil Then FGraphic.Destroy;
     Inherited Destroy;
End;

Procedure TPicture.LoadFromFile(Const Filename:String);
Var  Ext:String;
     aClass:TGraphicClass;
     NewGraphic:TGraphic;
Begin
     Ext := ExtractFileExt(FileName);
     UpcaseStr(Ext);
     aClass:=Nil;
     If Ext='.BMP' Then aClass:=TBitmap
     Else If Ext='.ICO' Then aClass:=TIcon
     Else If Ext='.MET' Then aClass:=TMetaFile;
     If aClass=Nil Then Raise EInvalidPictureFormat.Create('Unknown extension');

     NewGraphic := aClass.Create;
     NewGraphic.LoadFromFile(FileName);

     If FGraphic <> Nil Then FGraphic.Destroy;
     FGraphic := NewGraphic;
     FGraphic.OnChange := Changed;
     Changed(Self);
End;


Procedure TPicture.SaveToFile(Const Filename:String);
Begin
     If FGraphic<>Nil Then FGraphic.SaveToFile(FileName);
End;


Procedure TPicture.ForceType(GraphicType:TGraphicClass);
Begin
     If not (FGraphic Is GraphicType) Then
     Begin
          If FGraphic <> Nil Then FGraphic.Destroy;
          FGraphic := GraphicType.Create;
          FGraphic.OnChange := Changed;
          Changed(Self);
     End;
End;


//unit initalization

Type TIconClass=Class Of TIcon;

Var IconClass:TIconClass;
    BitmapClass:TBitmapClass;

Begin
     IconClass:=TIcon;
     Asm
        MOV EAX,IconClass
        MOV Forms.IconClass,EAX
     End;
     BitmapClass:=TBitmap;
     Asm
        MOV EAX,BitmapClass
        MOV Forms.BitmapClass,EAX
     End;
End.


