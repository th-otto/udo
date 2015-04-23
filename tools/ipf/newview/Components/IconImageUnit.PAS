Unit IconImageUnit;

Interface

Uses
  Classes, Forms, Graphics;

{Declare new class}
Type
  TIconImage=Class(TControl)
  Protected
    FIcon: TIcon;
    Procedure SetupComponent; Override;
    Procedure SetIcon( NewIcon: TIcon );
    Procedure Redraw( const rec: TRect ); Override;
  Public
    Destructor Destroy; Override;
  Published
    property Icon: TIcon read FIcon write SetIcon;
  End;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  TIconImage,'User','';

Implementation

Uses
  PmWin;

Procedure TIconImage.SetupComponent;
Begin
  Inherited SetupComponent;
  FIcon := TIcon.Create;
  Width := 32;
  Height := 32;
  Name := 'IconImage';
  ParentColor := True;
  Exclude( ComponentState, csAcceptsControls );
End;

Destructor TIconImage.Destroy;
Begin
  Inherited Destroy;
  FIcon.Destroy;
End;

Procedure TIconImage.SetIcon( NewIcon: TIcon );
Begin
  FIcon.Assign( NewIcon );
  Width := FIcon.Width;
  Height := FIcon.Height;
End;

Procedure TIconImage.Redraw( const rec: TRect );
Begin
  Canvas.ClipRect := rec;
  // clear background rectangle
  Canvas.FillRect( rec, Color );

  Canvas.Draw( 0, 0, FIcon );
End;

Initialization
  {Register classes}
  RegisterClasses([TIconImage]);
End.

