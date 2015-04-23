Unit ClipBrd;

Interface

Uses Forms;

Type
     TFormsClipBoard=Class(TClipBoard);
     TClipBoard=Class(TFormsClipBoard)
     End;

Var ClipBoard:TClipBoard;

Implementation

Begin
    ClipBoard:=TClipBoard(Forms.ClipBoard);
End.