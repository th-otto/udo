Program NewViewInstall;

Uses
  Forms,
  MainFormUnit,
  ChooseFolderFormUnit;

{$r NewViewInstall.scu}

Begin
  Application.Create;
  Application.CreateForm (TMainForm, MainForm);
  Application.Run;
  Application.Destroy;
End.
