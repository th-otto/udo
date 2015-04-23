Sibyl Library - Aaron Lawrence modifications
---------------------------

Use Makeall.cmd to build all the units (including resource files)


Details
---------------------------
Compiled files are put to Lib directory.

Makeall.pas is a dummy program file that includes all the Sibyl units.

Compiler.txt
IDE.txt
Libraries.txt

These are bug lists.


Changes:
----------------------

RTL
v2.0.3.3
- SYSTEM.PAS
Turned IO checking (IO exceptions) on again. Grr.

v2.0.3.2
- PMWIN.PAS
Added some missing constants to do with frame flags, plus the mouseenter and mouseleave messages which were added for Open32...

v2.0.3.1
- Dos.pas
Added GetCurrentProcessID function.

- PMSHL.PAS
Corrected declaration of SWBLOCK (tasklist data structure) to be an array of SWENTRYs not just a single one.

SPCC
v2.1.1.1
- Printers.pas
Implemented an exception for when new page fails on a printer.

v2.1.0.3
- STDCTRLS.PAS
Fixed a bug in combo edit - not correctly checking for maximum when doing a cursor down

v2.1.0.1
- FILECTRL.PAS
Fixed a bunch of inverted {$I+} {$I-} pairs. These previously disabled I/O checking as soon as they were run. I'm not really happy about this whole I/O checking implementation it's plainly too fragile.

v2.1.0.0
- STDCTRLS.PAS
Combo box can now be owner drawn by setting OwnerDraw to true and handling the OnDrawItem event. In addition, it now behaves more like the native OS/2 combo box.

Note: If a combo box is set to owner draw, but not to csDropDownList, then only the listbox items are owner drawn; the edit part is not (since it can be directly edited).

v2.0.7.0
- CLASSES.PAS
Add Insert and Swap methods to TCollection. (Used for TCoolBar2 sections property editor, to allow move up and down)

- COMCTRLS.PAS
Changed private to protected (Specifically, so TCoolBar2 can access the FSections object of THeaderControl).

- FORMS.PAS
Tab key did not respect csDetail in componentstate, hence you could e.g. focus the scrollbar in a grid

- STDCTRLS.PAS
Improve the behaviour of TComboBox:
- allow form shortcut keys to work when combobox focussed: removed code that deliberately throws away any virtual keys besides tab/backtab/enter.
- allow typing keys to jump to entries in the list, even when list is not dropped down.

v2.0.6.0
- GRAPHICS.PAS
Added GetBitmapReference function to TImageList - much more efficient than using GetBitmap which makes a copy
Changed private to protected

- STDCTRLS.PAS
Listbox.sorted was being ignored if set before the window created

v2.0.5.1
- DIALOGS.PAS
Declare ExpandPath (I did this for assisting with IDE code...)

- FORMS.PAS
Some changes to how windows are shown so that if the window is set to maximized or minimised before being shown, it does actually show in the correct state. Previously it would ignore the state, though there was code to try and make it work.

This is not done for Win32.

I had to change it quite a bit to make this work including how the frame is shown, I'm not 100% confident it works in all cases. (FFrame.Show call used previously would seem to confuse things...)

v2.0.5.0
- FORMS.PAS
Added an options property to TForm, containing two flags: TitleBar and TaskListEntry. These only take effect if done before the form's window is created (e.g. when parent is set)...

v2.0.4.0
- FORMS.PAS
Changed all Private declarations to Protected; this should make it easier in future to build custom components.
This lead to renaming TControl.Insert to InsertChild since Insert is a string utility function.

- SYSUTILS.PAS
StrIComp function was wrong; it did not work properly if Str1 was shorter than Str2. So I rewrote the StringICompare it was using.

v2.0.3.7
- EXTCTRLS.PAS
Fixed TRadioGroup so that the item index can be set before the control is visible (eg. on a notebook page that isn't initially visible).
Problem was the code assumed that the control was already visible and that the list of radio buttons had already been created, which is not true until setupshow is run.

v2.0.3.6
- GRAPHICS.PAS
Improved TBitmap.DrawDisabled. Now should properly generate a 50%, pixel by pixel cross hatch, instead of ugly lines.

v2.0.3.5
- FORMS.PAS
Rewrote TCanvas.MnemoTextOut to do the underline of the shortcut char with a line, instead of changing font. It's simpler and looks better. This fixes up many controls such as bitmap button (TBitBtn), tab notebook etc.

Slightly tidied LockDesktopWIndows and InputHook
Also removed a few unused vars

v2.0.3.4
- STDCTRLS.PAS
Fixed libraries bug 14, Combo box does not drop down when edit box clicked on. Picked up the code from FP4, minus the Linux bits; also added DblClick handler, so that double click acts like two seperate clicks (this bit was  not in Fp4).

v2.0.3.3
- STDCTRLS.PAS
Speeded up loading of many items into listbox. This applies to both setup time (when the 'initial items' are put into the actual PM listbox) and if the list is reassigned while being displayed.

v2.0.3.2
- FORMS.PAS
Properly fixed tasklist handling for modal dialogs.
Now the existing entries are hidden and restored after the dialog finishes. So, while a modal dialog is showing, there is only one tasklist entry, which correctly refers to the dialog window.

Note this solution is quite different to the "fix" in Speedsoft Fixpack 4. That fix prevented modal dialogs from showing in the tasklist, but the existing entries were left and selecting them still incorrectly focussed the form in question, not the dialog.

Also, the hook that detects clicks on other windows while a modal dialog is showing, now detects mouse button 2 and 3 clicks as well.

v2.0.3.1
- FORMS.PAS
Fixed font dereferencing problem, causing crash after second activation of Font dialog (and probably other problems too).

- SYSUTILS.PAS
Fixed bug 2, additional zero byte written when copying zero terminated strings.





