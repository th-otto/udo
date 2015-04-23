Unit SharedMemoryUnit;

Interface

uses
  BseDos,
  Semaphores;

type
  // Encapsulates a basic shared memory block. After creating,
  // the Data pointer can be used to read or write the data
  // in the memory.
  TSharedMemory = class
  protected
    FPointer: pointer;
    FFirst: boolean; // true if this object created the shared mem block

  public
    constructor Create( const Name: string;
                        const Size: longword );
    destructor Destroy; override;

    property Data: pointer read FPointer;
  end;

  // Encapsulates a shared memory block which can be suballocated
  // into smaller areas.
  // Allocate and Free are used to allocate these areas.
  // A space can be reserved for using as a normal shared mem block.
  // Otherwise the Data property should not be used.
  TSuballocatedSharedMemory = class( TSharedMemory )
  protected
    FAllocationArea: pointer;
  public
    constructor Create( const Name: string;
                        const Size: longint;
                        const ReserveSize: longword ); // size to reserve at start of memory
                                                       // for direct access using Data

    // suballocate space of the given size
    procedure Allocate( Var p: pointer;
                        const Size: longword );

    // free the given space.
    procedure Free( Var p: pointer );

    destructor Destroy; override;
  end;

Implementation

uses
  OS2Def, BseErr,
  SysUtils,
  ACLUtility;

constructor TSharedMemory.Create( const Name: string;
                                  const Size: longword );
var
  rc: APIRET;
  szName: cstring;
begin
  inherited Create;

  FFirst := true;

  Assert( Size > 0 );

  szName := '\SHAREMEM\' + Name;
  rc := DosAllocSharedMem( FPointer,
                           szName,
                           Size,
                           PAG_READ + PAG_WRITE + PAG_COMMIT );

  if rc <> 0 then
  begin
    if rc = ERROR_ALREADY_EXISTS then
    begin
      // memory already exists, just get it
      FFirst := false;
      rc := DosGetNamedSharedMem( FPointer,
                                  szName,
                                  PAG_READ + PAG_WRITE );
    end;

    CheckSystemError( rc, 'Error getting shared mem' );
  end;

end;

destructor TSharedMemory.Destroy;
begin
  DosFreeMem( FPointer ); // will free the shared mem once nobody has a ref.
  inherited Destroy;
end;

constructor TSuballocatedSharedMemory.Create( const Name: string;
                                              const Size: longint;
                                              const ReserveSize: longword );
var
  rc: APIRET;
  ActualSize: longword;
  ActualReserveSize: longword;
  Flags: ULONG;
  StartupSemaphore: TMutex;
begin
  ActualSize := Size;
  if ActualSize < 256 then
    ActualSize := 256; // make sure the suballoc info will fit.

  // Ensure that only one process inits the suballocation
  StartupSemaphore := TMutex.CreateNamed( Name );
  StartupSemaphore.Get;

  inherited Create( Name, ActualSize );

  // round reserve size up to nearest 8 bytes
  ActualReserveSize := ( ( ReserveSize + 7 ) div 8 ) * 8;

  Assert( ActualReserveSize < ActualSize );

  if FFirst then
  begin
    // initialise reserved memory
    FillMem( FPointer, ActualReserveSize, 0 );
  end;

  FAllocationArea := FPointer + ActualReserveSize;

  Flags := DOSSUB_SERIALIZE;
  if FFirst then
    Flags := Flags + DOSSUB_INIT;
    // otherwise just attach

  // set up suballocation, with serialisation for multi-process access
  rc := DosSubSetMem( FAllocationArea,
                      Flags,
                      ActualSize - ReserveSize );

  CheckSystemError( rc, 'Error initialising suballocation' );

  StartupSemaphore.Release;
  StartupSemaphore.Destroy;

end;

destructor TSuballocatedSharedMemory.Destroy;
begin
//  DosSubUnsetMem( FAllocationArea );
// to do this requires manual reference counting
// it's easy just to not worry and the suballoc stuff
// will be freed when the shared memory is freed

  inherited Destroy;
end;

procedure TSuballocatedSharedMemory.Allocate( Var p: pointer;
                                              const Size: longword );
var
  rc: APIRET;
begin
  rc := DosSubAllocMem( FAllocationArea,
                        p,
                        Size + sizeof( longword ) );

  CheckSystemError( rc, 'Error suballocating memory' );

  // Store size at start of block
  PULONG( p )^ := Size;
  inc( p, sizeof( longword ) );
end;

procedure TSuballocatedSharedMemory.Free( Var p: pointer );
var
  rc: APIRET;
  Size: longword;
begin
  // retrieve size from start of block
  dec( p, sizeof( longword ) );
  Size := PULONG( p )^;

  rc := DosSubFreeMem( FAllocationArea,
                       p,
                       Size );

  CheckSystemError( rc, 'Error freeing suballocated memory' );
end;

Initialization
End.
