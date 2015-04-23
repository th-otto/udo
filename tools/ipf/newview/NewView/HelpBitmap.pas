Unit HelpBitmap;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

// Encapsulates a bitmap as stored in a IPF file.
// Once created from file data they can be used as a normal bitmap.

uses
  BseDos,
  OS2Def,
  PMBitmap,
  Classes,
  Graphics,
  SysUtils,
  IPFFileFormatUnit;

type
  EHelpBitmapException = class( Exception )
  end;

  // Lead part of BITMAPARRAYFILEHEADER
  INFBITMAPARRAYHEADER = record
    usType: USHORT;    // 'BA', 16706
    cbSize: ULONG;     // Size of the BITMAPARRAYFILEHEADER structure in bytes.
    offNext: ULONG;    // Offset of the next BITMAPARRAYFILEHEADER structure from the start of the file.
    cxDisplay: USHORT; // Device width, in pels.
    cyDisplay: USHORT; // Device height, in pels.
  end;

  INFBITMAPHEADER = record
    // BITMAP FILE HEADER
    usType: USHORT; // = 'bM'
    cbSize: ULONG;
    xHotspot: USHORT;
    yHotspot: USHORT;
    offBits: ULONG; // =size(hdr)+size(palette)
    // BITMAP INFO HEADER
    cbFIx: ULONG; // =size(info_hdr) (usually = 12?)
    cx: USHORT; // x size
    cy: USHORT; // y size
    cPlanes: USHORT; // planes, =1
    cBitCount: USHORT;
  end;

  THelpBitmap = class( TBitmap )
  protected
    _Header: INFBITMAPHEADER;
    _PaletteColorCount: longint;
    _pPalette: ^RGB;
    _BitsSize: longint;
    _FileHandle: HFile;

    _UncompressedBlockSize: longint;

    function GetPaletteSize: longint;
    procedure ReadBitmapData( Blocks: TList;
                              TotalSize: longint );
  public
    constructor CreateFromHelpFile( FileHandle: HFile;
                                    Offset: longint );
    destructor Destroy; override;
  end;

var
  LZWDecompressBlock: function( pInput: PBYTE;
                               pOutput: PBYTE;
                               bytesIn: ULONG;
                               Var bytesOut: ULONG;
                               Var FinalCode: byte ): BOOL;
  APIENTRY;
//  'newview' index 1;

Implementation

uses
  ACLFileIOUtility,
  ACLUtility,
  ACLDialogs;

const
  BFT_bMAP =$4d62; // 'bM'
  BFT_BITMAP_ARRAY = $4142; // 'BA'

type
  INFBITMAPDATAHEADER = record
    ulTotalSize: ULONG;
    usUncompressedBlockSize: USHORT; // bytes per block, after decompression
  end;

  TBitmapBlock = class
    _Data: PBYTE;
    _Size: USHORT;
    _CompressionType: uint8;
    destructor Destroy; override;
  end;

destructor TBitmapBlock.Destroy;
begin
  DeallocateMemory( _Data );
  inherited Destroy;
end;

constructor THelpBitmap.CreateFromHelpFile( FileHandle: HFILE;
                                            Offset: longint );
var
  WordsPerLine: longint;
  LineSize: longint;
  DataHeader: INFBITMAPDATAHEADER;
  BytesRead: longint;

  Block: TBitmapBlock;
  Blocks: TList;
  BlockIndex: longint;
  ImageType: USHORT;
  BitmapArrayHeader: INFBITMAPARRAYHEADER;
begin
  MySeek( FileHandle, Offset );
  MyRead( FileHandle, Addr( ImageType ), sizeof( ImageType ) );

  if ImageType = BFT_BITMAP_ARRAY then
  begin
    // skip array header and read first bitmap only
    MySkip( FileHandle, Sizeof( BitmapArrayHeader ) - sizeof( ImageType ) );
  end
  else
  begin
    // skip back over imagetype bytes to read header.
    MySkip( FileHandle, - sizeof( ImageType ) );
  end;

  // Read bitmap header
  MyRead( FileHandle, Addr( _Header ), sizeof( _Header ) );

  // Check it's got a valid type
  if _Header.usType <> BFT_bMAP then
    raise EHelpBitmapException.Create( 'Invalid bitmap header' );

  _Header.usType := $4d42; // sibyl only accepts 'BM' not 'bM'

  // We can only parse bitmaps with 1 colour plane
  // (I can't be bothered and have never seen bitmaps
  //  with more than 1 color plane)
  if _Header.cPlanes <> 1 then
    exit;

  _PaletteColorCount := 0;
  if _Header.cBitCount < 24 then
    _PaletteColorCount := 1 shl _Header.cBitCount;

  // OS/2 always rounds bitmap rows up to a word:
  WordsPerLine := ( _Header.cBitCount * _Header.cx + 31 ) div 32;
  LineSize := WordsPerLine * 4;

  // Total size of the bitmap pixel data
  _BitsSize := LineSize * _Header.cy;

  // Correct header offset - it is wrong in the header (why?)
  _Header.OffBits := sizeof( _Header ) + GetPaletteSize;

  // Load palette
  _pPalette := AllocateMemory( GetPaletteSize );
  MyRead( FileHandle, _pPalette, GetPaletteSize );

  // Read data header
  MyRead( FileHandle, Addr( DataHeader ), sizeof( DataHeader ) );
  _UncompressedBlockSize := DataHeader.usUncompressedBlockSize;

  // For counting total size, we have already read some bytes:
  // the uncompressedblocksize field
  BytesRead := sizeof( DataHeader.usUncompressedBlockSize );
  Blocks := TList.Create;

  while BytesRead < DataHeader.ulTotalSize do
  begin
    Block := TBitmapBlock.Create;

    // Read the block size
    MyRead( FileHandle, Addr( Block._Size ), sizeof( Block._Size ) );
    inc( BytesRead, sizeof( Block._Size ) );

    // Read the compression type
    MyRead( FileHandle, Addr( Block._CompressionType ), sizeof( Block._CompressionType ) );
    inc( BytesRead, sizeof( Block._CompressionType ) );

    // since size in the file includes this compression type field, subtract it
    dec( Block._Size, sizeof( Block._CompressionType ) );

    // Now read the block
    Block._Data := AllocateMemory( Block._Size );
    MyRead( FileHandle, Block._Data, Block._Size );

    inc( BytesRead, Block._Size  );

    Blocks.Add( Block );

  end;
  ReadBitmapData( Blocks, sizeof( _Header ) + GetPaletteSize + _BitsSize );

  for BlockIndex := 0 to Blocks.Count - 1 do
  begin
    Block := Blocks[ BlockIndex ];
    Block.Destroy;
  end;

  Blocks.Destroy;
end;

function THelpBitmap.GetPaletteSize: longint;
begin
  Result := sizeof( RGB ) * _PaletteColorCount;
end;

destructor THelpBitmap.Destroy;
begin
  DeallocateMemory( _pPalette );
  inherited Destroy;
end;

procedure THelpBitmap.ReadBitmapData( Blocks: TList;
                                      TotalSize: longint );
var
  BytesWritten: longint;
  BytesWrittenFromBlock: longword;
  BytesRemainingInBlock: longword;
  BytesRemainingInBitmap: longword;
  FillerBytesRequired: longint;
  lastOutByte: byte;
  BitmapOutputPointer: PByte;
  Block: TBitmapBlock;
  BlockIndex: longint;
  BitmapData: PBYTE;
begin
  // Allocate memory to store the bitmap
  GetMem( BitmapData, TotalSize );

  // Copy header to bitmap
  MemCopy( Addr( _Header ),
           BitmapData,
           sizeof( _Header ) );

  // Copy palette into bitmap
  MemCopy( _pPalette,
           BitmapData + sizeof( _Header ),
           GetPaletteSize );

  BytesWritten := 0;

  // Point to start writing to bitmap bits.
  BitmapOutputPointer := BitmapData + sizeof( _Header ) + GetPaletteSize;

  for BlockIndex := 0 to Blocks.Count - 1 do
  begin
    Block := Blocks[ BlockIndex ];

    case Block._CompressionType of
      0,1: // uncompressed (I'm not sure about 1)
      begin
        MemCopy( Block._Data,
                 BitmapOutputPointer,
                 Block._Size );
        BytesWrittenFromBlock := Block._Size;
        inc( BytesWritten, BytesWrittenFromBlock );
      end;

      2: // LZW compression
      begin
        // decompress block
        if not Assigned( LZWDecompressBlock )then
          raise EHelpBitmapException.Create( 'Cannot decode bitmap - DLL not found' );

        LZWDecompressBlock( Block._Data,
                            BitmapOutputPointer,
                            Block._Size,
                            BytesWrittenFromBlock,
                            lastOutByte );

        inc( BytesWritten, BytesWrittenFromBlock );

        // If the uncompressed data stopped short then
        // copy the final code (byte) into remaining bytes
        if ( BytesWrittenFromBlock < _UncompressedBlockSize )
          and ( BytesWritten < _BitsSize ) then
        begin
          BytesRemainingInBlock := _UncompressedBlockSize - BytesWrittenFromBlock;
          BytesRemainingInBitmap := _BitsSize - BytesWritten;

          FillerBytesRequired := Min( BytesRemainingInBlock,
                                      BytesRemainingInBitmap );

          FillMem( BitmapOutputPointer + BytesWrittenFromBlock,
                   FillerBytesRequired,
                   LastOutByte );
          inc( BytesWritten, FillerBytesRequired );
          inc( BytesWrittenFromBlock, FillerBytesRequired );
        end;
      end;
      else
        raise EHelpBitmapException.Create( 'Unrecognised bitmap block type' );
    end; // case

    assert( BytesWrittenFromBlock <= _UncompressedBlockSize );
    assert( BytesWritten <= _BitsSize );

    if ( BitmapOutputPointer + BytesWrittenFromBlock
         > BitmapData + TotalSize ) then
      assert( false );

    inc( BitmapOutputPointer, BytesWrittenFromBlock );
  end;

  LoadFromMem( BitmapData^, TotalSize );
  FreeMem( BitmapData, TotalSize );
end;

Initialization
End.
