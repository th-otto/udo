Program ACLLibrary;

Uses
  Forms, Graphics, ACLLibraryTestForm;

{$r ACLLibrary.scu}

Begin
  Application.Create;
  Application.CreateForm (TACLLibraryTestForm, ACLLibraryTestForm);
  Application.Run;
  Application.Destroy;
End.
