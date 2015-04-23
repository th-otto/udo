unit ACLResourceUtility;

interface

uses
{$ifdef win32}
  Windows,
{$endif}
  Graphics; // must preserve this order!
            // There is a TBitmap in both units :(

Procedure LoadBitmapResource( Bitmap: TBitmap;
                              Name: string );

// Loads the first format of icon
// from the named icon (group) resource
procedure LoadIconResource( Icon: TIcon;
                            Name: string );

implementation

uses
{$ifdef win32}
  Types,
{$endif}
  Classes,
  SysUtils;

procedure LoadIconResource( Icon: TIcon;
                            Name: string );
begin
{$ifdef os2}
  Icon.LoadFromResourceName( Name );
{$else}
  Icon.Handle := LoadIcon( HInstance,
                           PChar( Name ) );
{$endif}
end;

Procedure LoadBitmapResource( Bitmap: TBitmap;
                              Name: string );
begin
  Bitmap.LoadFromResourceName(
{$ifdef win32}
    HInstance,
{$endif}
    Uppercase( Name ) );
end;

end.


