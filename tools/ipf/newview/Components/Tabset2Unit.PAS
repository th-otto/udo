Unit Tabset2Unit;

Interface

Uses
  Classes, Forms, TabCtrls;

{Declare new class}
Type
  TTabSet2=Class(TTabSet)
  Protected
    Procedure SetupComponent; Override;
  Public
    Destructor Destroy; Override;
  published
    Property TabOrder; // that's the whole point!
  End;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  TTabSet2,'User','Tabset2.bmp';

Implementation

Procedure TTabSet2.SetupComponent;
Begin
  Inherited SetupComponent;
End;

Destructor TTabSet2.Destroy;
Begin
  Inherited Destroy;
End;

Initialization
  {Register classes}
  RegisterClasses([TTabSet2]);
End.

