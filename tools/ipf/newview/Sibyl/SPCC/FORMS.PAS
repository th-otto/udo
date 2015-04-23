
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Portable Component Classes                                     บ
 บ                                                                          บ
 บ     Copyright (C) 1995,97 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}
                             
Unit Forms;

{$B-}

Interface

{$IFDEF OS2}
Uses Os2Def,BseDos,PmWin,PmGpi,PmDev,PmStdDlg,PmBitmap,PmHelp;
{$ENDIF}

{$IFDEF Win32}
Uses WinDef,WinBase,WinNt,WinUser,WinGDI,CommCtrl;
{$ENDIF}

Uses Messages,Dos,SysUtils,Classes;


Type
{$M+}
    TCommand           = LongWord;

Const
    {predefined Command Ids}
    cmNull             = TCommand(0);
    cmBase             = $8000;

    cmFile             = TCommand(cmBase+1);
    cmOpen             = TCommand(cmBase+2);
    cmNew              = TCommand(cmBase+3);
    cmSave             = TCommand(cmBase+5);
    cmSaveAs           = TCommand(cmBase+6);
    cmSaveAll          = TCommand(cmBase+7);
    cmPrint            = TCommand(cmBase+8);
    cmExit             = TCommand(cmBase+9);
    cmAbout            = TCommand(cmBase+10);
    cmUndo             = TCommand(cmBase+11);
    cmRedo             = TCommand(cmBase+12);
    cmCut              = TCommand(cmBase+13);
    cmCopy             = TCommand(cmBase+14);
    cmPaste            = TCommand(cmBase+15);
    cmTile             = TCommand(cmBase+16);
    cmCascade          = TCommand(cmBase+17);
    cmCloseAll         = TCommand(cmBase+18);
    cmNext             = TCommand(cmBase+19);
    cmPrevious         = TCommand(cmBase+20);
    cmCloseTop         = TCommand(cmBase+21);
    cmMaximize         = TCommand(cmBase+22);
    cmMinimize         = TCommand(cmBase+23);
    cmRestore          = TCommand(cmBase+24);
    cmFind             = TCommand(cmBase+25);
    cmReplace          = TCommand(cmBase+26);
    cmHelpIndex        = TCommand(cmBase+27);
    cmHelpContents     = TCommand(cmBase+28);
    cmHelpOnHelp       = TCommand(cmBase+29);
    cmKeysHelp         = TCommand(cmBase+30);
    cmTopicSearch      = TCommand(cmBase+31);
    cmChangeDir        = TCommand(cmBase+32);
    cmSearchAgain      = TCommand(cmBase+33);
    cmSelectAll        = TCommand(cmBase+34);
    cmDeselectAll      = TCommand(cmBase+35);
    cmBack             = TCommand(cmBase+36);
    cmForward          = TCommand(cmBase+37);
    cmDelete           = TCommand(cmBase+38);
    cmCreateDir        = TCommand(cmBase+39);

    cmOk               = TCommand(cmBase+50);
    cmCancel           = TCommand(cmBase+51);
    cmHelp             = TCommand(cmBase+52);
    cmYes              = TCommand(cmBase+53);
    cmNo               = TCommand(cmBase+54);
    cmClose            = TCommand(cmBase+55);
    cmAbort            = TCommand(cmBase+56);
    cmRetry            = TCommand(cmBase+57);
    cmIgnore           = TCommand(cmBase+58);
    cmAll              = TCommand(cmBase+59);
    cmAccept           = TCommand(cmBase+60);
    cmDiscard          = TCommand(cmBase+61);
    cmDefault          = TCommand(cmBase+62);

    cmUser             = TCommand(cmBase+$1000);
{$M-}

Const
    WM_CAPTUREFOCUS           = WM_USER+1;
    WM_DDE_DESTROY            = WM_USER+2;
    WM_FOCUSSING              = WM_USER+3;

    CM_COMMAND                = WM_COMMAND;
    CM_PARENTPENCOLORCHANGED  = cmBase+110;
    CM_PARENTCOLORCHANGED     = cmBase+111;
    CM_PARENTFONTCHANGED      = cmBase+112;
    CM_BUTTONPRESSED          = cmBase+120;
    CM_RELEASE                = cmBase+125;
    CM_TEXTCHANGED            = cmBase+126;
    CM_UPDATEBUTTONS          = cmBase+127;
    CM_ENDMODALSTATE          = cmBase+128;


Const
    {Caret Timer values for use with BlinkTime}
{$M+}
    ctNormal           = 500;
    ctFast             = 100;
{$M-}

Type
    {General KeyCode Type. KeyCode constants apply to ScanEvent Methods}
{$M+}
    TKeyCode           = LongWord;

Const
    {predefined Keyboars codes. To determine If Ctrl,Shift Or Alt was
     Pressed together With the key you may Use Boolean operations}
    kbNull             = TKeyCode(0);
    kb_VK              = 256;
    kb_Ctrl            = 512;
    kb_Shift           = 1024;
    kb_Alt             = 2048;
    kb_Char            = 4096;

    kbF1               = TKeyCode(kb_VK + VK_F1);
    kbF2               = TKeyCode(kb_VK + VK_F2);
    kbF3               = TKeyCode(kb_VK + VK_F3);
    kbF4               = TKeyCode(kb_VK + VK_F4);
    kbF5               = TKeyCode(kb_VK + VK_F5);
    kbF6               = TKeyCode(kb_VK + VK_F6);
    kbF7               = TKeyCode(kb_VK + VK_F7);
    kbF8               = TKeyCode(kb_VK + VK_F8);
    kbF9               = TKeyCode(kb_VK + VK_F9);
    kbF10              = TKeyCode(kb_VK + VK_F10);
    kbF11              = TKeyCode(kb_VK + VK_F11);
    kbF12              = TKeyCode(kb_VK + VK_F12);
    kbCLeft            = TKeyCode(kb_VK + VK_LEFT);
    kbCRight           = TKeyCode(kb_VK + VK_RIGHT);
    kbCUp              = TKeyCode(kb_VK + VK_UP);
    kbCDown            = TKeyCode(kb_VK + VK_DOWN);
    kbDel              = TKeyCode(kb_VK + VK_DELETE);
    kbIns              = TKeyCode(kb_VK + VK_INSERT);
    kbEnd              = TKeyCode(kb_VK + VK_END);
    kbHome             = TKeyCode(kb_VK + VK_HOME);
    {$IFDEF OS2}
    kbPageDown         = TKeyCode(kb_VK + VK_PAGEDOWN);
    kbPageUp           = TKeyCode(kb_VK + VK_PAGEUP);
    kbBkSp             = TKeyCode(kb_VK + VK_BACKSPACE);
    kbCR               = TKeyCode(kb_VK + VK_NEWLINE);
    kbEsc              = TKeyCode(kb_VK + VK_ESC);
    kbCapsLock         = TKeyCode(kb_VK + VK_CAPSLOCK);
    kbScrollLock       = TKeyCode(kb_VK + VK_SCRLLOCK);
    kbEnter            = TKeyCode(kb_VK + VK_ENTER);
    kbPrintScrn        = TKeyCode(kb_VK + VK_PRINTSCRN);
    kbCtrl             = TKeyCode(kb_VK + VK_CTRL + kb_Ctrl);
    kbAlt              = TKeyCode(kb_VK + VK_ALT + kb_Alt);
    kbAltGraf          = TKeyCode(kb_VK + VK_ALTGRAF);
    kbBackTab          = TKeyCode(kb_VK + VK_BACKTAB);
    kbBreak            = TKeyCode(kb_VK + VK_BREAK);
    {$ENDIF}
    {$IFDEF Win32}
    kbPageDown         = TKeyCode(kb_VK + VK_NEXT);
    kbPageUp           = TKeyCode(kb_VK + VK_PRIOR);
    kbBkSp             = TKeyCode(kb_VK + VK_BACK);
    kbCR               = TKeyCode(kb_VK + VK_RETURN);
    kbEsc              = TKeyCode(kb_VK + VK_ESCAPE);
    kbCapsLock         = TKeyCode(kb_VK + VK_CAPITAL);
    kbScrollLock       = TKeyCode(kb_VK + VK_SCROLL);
    kbEnter            = TKeyCode(kb_VK + VK_RETURN);
    kbPrintScrn        = TKeyCode(kb_VK + VK_PRINT);
    kbCtrl             = TKeyCode(kb_VK + VK_CONTROL + kb_Ctrl);
    kbAlt              = TKeyCode(kb_VK + VK_MENU + kb_Alt);
    kbAltGraf          = TKeyCode(kb_VK + VK_MENU + kb_Alt + kb_Ctrl);
    kbBackTab          = TKeyCode(kb_VK + VK_TAB);
    kbBreak            = TKeyCode(kb_VK + VK_ESCAPE);    {?}
    {$ENDIF}
    kbTab              = TKeyCode(kb_VK + VK_TAB);
    kbNumLock          = TKeyCode(kb_VK + VK_NUMLOCK);
    kbSpace            = TKeyCode(kb_VK + VK_SPACE);
    kbPause            = TKeyCode(kb_VK + VK_PAUSE);
    kbShift            = TKeyCode(kb_VK + VK_SHIFT + kb_Shift);

    {Shift codes are basic codes + kb_Shift}
    kbShiftF1          = TKeyCode(kb_Shift + kbF1);
    kbShiftF2          = TKeyCode(kb_Shift + kbF2);
    kbShiftF3          = TKeyCode(kb_Shift + kbF3);
    kbShiftF4          = TKeyCode(kb_Shift + kbF4);
    kbShiftF5          = TKeyCode(kb_Shift + kbF5);
    kbShiftF6          = TKeyCode(kb_Shift + kbF6);
    kbShiftF7          = TKeyCode(kb_Shift + kbF7);
    kbShiftF8          = TKeyCode(kb_Shift + kbF8);
    kbShiftF9          = TKeyCode(kb_Shift + kbF9);
    kbShiftF10         = TKeyCode(kb_Shift + kbF10);
    kbShiftF11         = TKeyCode(kb_Shift + kbF11);
    kbShiftF12         = TKeyCode(kb_Shift + kbF12);
    kbShiftCLeft       = TKeyCode(kb_Shift + kbCLeft);
    kbShiftCRight      = TKeyCode(kb_Shift + kbCRight);
    kbShiftCUp         = TKeyCode(kb_Shift + kbCUp);
    kbShiftCDown       = TKeyCode(kb_Shift + kbCDown);
    kbShiftDel         = TKeyCode(kb_Shift + kbDel);
    kbShiftIns         = TKeyCode(kb_Shift + kbIns);
    kbShiftEnd         = TKeyCode(kb_Shift + kbEnd);
    kbShiftHome        = TKeyCode(kb_Shift + kbHome);
    kbShiftPageDown    = TKeyCode(kb_Shift + kbPageDown);
    kbShiftPageUp      = TKeyCode(kb_Shift + kbPageUp);
    kbShiftBkSp        = TKeyCode(kb_Shift + kbBkSp);
    kbShiftCR          = TKeyCode(kb_Shift + kbCR);
    kbShiftSpace       = TKeyCode(kb_Shift + kbSpace);
    kbShiftTab         = TKeyCode(kb_Shift + kbBackTab);
    kbShiftEnter       = TKeyCode(kb_Shift + kbEnter);
    kbShiftPause       = TKeyCode(kb_Shift + kbPause);
    kbShiftBreak       = TKeyCode(kb_Shift + kbBreak);

    {$IFDEF OS2}
    kbScanBase=TKeyCode(97);
    {$ENDIF}
    {$IFDEF WIN32}
    kbScanBase=TKeyCode(65);
    {$ENDIF}

    kbA                = TKeyCode(kbScanBase+0);
    kbB                = TKeyCode(kbScanBase+1);
    kbC                = TKeyCode(kbScanBase+2);
    kbD                = TKeyCode(kbScanBase+3);
    kbE                = TKeyCode(kbScanBase+4);
    kbF                = TKeyCode(kbScanBase+5);
    kbG                = TKeyCode(kbScanBase+6);
    kbH                = TKeyCode(kbScanBase+7);
    kbI                = TKeyCode(kbScanBase+8);
    kbJ                = TKeyCode(kbScanBase+9);
    kbK                = TKeyCode(kbScanBase+10);
    kbL                = TKeyCode(kbScanBase+11);
    kbM                = TKeyCode(kbScanBase+12);
    kbN                = TKeyCode(kbScanBase+13);
    kbO                = TKeyCode(kbScanBase+14);
    kbP                = TKeyCode(kbScanBase+15);
    kbQ                = TKeyCode(kbScanBase+16);
    kbR                = TKeyCode(kbScanBase+17);
    kbS                = TKeyCode(kbScanBase+18);
    kbT                = TKeyCode(kbScanBase+19);
    kbU                = TKeyCode(kbScanBase+20);
    kbV                = TKeyCode(kbScanBase+21);
    kbW                = TKeyCode(kbScanBase+22);
    kbX                = TKeyCode(kbScanBase+23);
    kbY                = TKeyCode(kbScanBase+24);
    kbZ                = TKeyCode(kbScanBase+25);

    kb0                = TKeyCode(48);
    kb1                = TKeyCode(49);
    kb2                = TKeyCode(50);
    kb3                = TKeyCode(51);
    kb4                = TKeyCode(52);
    kb5                = TKeyCode(53);
    kb6                = TKeyCode(54);
    kb7                = TKeyCode(55);
    kb8                = TKeyCode(56);
    kb9                = TKeyCode(57);

    {Ctrl codes are basic codes + kbCtrl}
    kbCtrl0            = TKeyCode(kb_Ctrl + kb_Char + kb1);
    kbCtrl1            = TKeyCode(kb_Ctrl + kb_Char + kb1);
    kbCtrl2            = TKeyCode(kb_Ctrl + kb_Char + kb2);
    kbCtrl3            = TKeyCode(kb_Ctrl + kb_Char + kb3);
    kbCtrl4            = TKeyCode(kb_Ctrl + kb_Char + kb4);
    kbCtrl5            = TKeyCode(kb_Ctrl + kb_Char + kb5);
    kbCtrl6            = TKeyCode(kb_Ctrl + kb_Char + kb6);
    kbCtrl7            = TKeyCode(kb_Ctrl + kb_Char + kb7);
    kbCtrl8            = TKeyCode(kb_Ctrl + kb_Char + kb8);
    kbCtrl9            = TKeyCode(kb_Ctrl + kb_Char + kb9);

    kbCtrlA             = TKeyCode(kb_Ctrl + kb_Char + kbA);
    kbCtrlB             = TKeyCode(kb_Ctrl + kb_Char + kbB);
    kbCtrlC             = TKeyCode(kb_Ctrl + kb_Char + kbC);
    kbCtrlD             = TKeyCode(kb_Ctrl + kb_Char + kbD);
    kbCtrlE             = TKeyCode(kb_Ctrl + kb_Char + kbE);
    kbCtrlF             = TKeyCode(kb_Ctrl + kb_Char + kbF);
    kbCtrlG             = TKeyCode(kb_Ctrl + kb_Char + kbG);
    kbCtrlH             = TKeyCode(kb_Ctrl + kb_Char + kbH);
    kbCtrlI             = TKeyCode(kb_Ctrl + kb_Char + kbI);
    kbCtrlJ             = TKeyCode(kb_Ctrl + kb_Char + kbJ);
    kbCtrlK             = TKeyCode(kb_Ctrl + kb_Char + kbK);
    kbCtrlL             = TKeyCode(kb_Ctrl + kb_Char + kbL);
    kbCtrlM             = TKeyCode(kb_Ctrl + kb_Char + kbM);
    kbCtrlN             = TKeyCode(kb_Ctrl + kb_Char + kbN);
    kbCtrlO             = TKeyCode(kb_Ctrl + kb_Char + kbO);
    kbCtrlP             = TKeyCode(kb_Ctrl + kb_Char + kbP);
    kbCtrlQ             = TKeyCode(kb_Ctrl + kb_Char + kbQ);
    kbCtrlR             = TKeyCode(kb_Ctrl + kb_Char + kbR);
    kbCtrlS             = TKeyCode(kb_Ctrl + kb_Char + kbS);
    kbCtrlT             = TKeyCode(kb_Ctrl + kb_Char + kbT);
    kbCtrlU             = TKeyCode(kb_Ctrl + kb_Char + kbU);
    kbCtrlV             = TKeyCode(kb_Ctrl + kb_Char + kbV);
    kbCtrlW             = TKeyCode(kb_Ctrl + kb_Char + kbW);
    kbCtrlX             = TKeyCode(kb_Ctrl + kb_Char + kbX);
    kbCtrlY             = TKeyCode(kb_Ctrl + kb_Char + kbY);
    kbCtrlZ             = TKeyCode(kb_Ctrl + kb_Char + kbZ);

    kbCtrlF1           = TKeyCode(kb_Ctrl + kbF1);
    kbCtrlF2           = TKeyCode(kb_Ctrl + kbF2);
    kbCtrlF3           = TKeyCode(kb_Ctrl + kbF3);
    kbCtrlF4           = TKeyCode(kb_Ctrl + kbF4);
    kbCtrlF5           = TKeyCode(kb_Ctrl + kbF5);
    kbCtrlF6           = TKeyCode(kb_Ctrl + kbF6);
    kbCtrlF7           = TKeyCode(kb_Ctrl + kbF7);
    kbCtrlF8           = TKeyCode(kb_Ctrl + kbF8);
    kbCtrlF9           = TKeyCode(kb_Ctrl + kbF9);
    kbCtrlF10          = TKeyCode(kb_Ctrl + kbF10);
    kbCtrlF11          = TKeyCode(kb_Ctrl + kbF11);
    kbCtrlF12          = TKeyCode(kb_Ctrl + kbF12);
    kbCtrlCLeft        = TKeyCode(kb_Ctrl + kbCLeft);
    kbCtrlCRight       = TKeyCode(kb_Ctrl + kbCRight);
    kbCtrlCUp          = TKeyCode(kb_Ctrl + kbCUp);
    kbCtrlCDown        = TKeyCode(kb_Ctrl + kbCDown);
    kbCtrlDel          = TKeyCode(kb_Ctrl + kbDel);
    kbCtrlIns          = TKeyCode(kb_Ctrl + kbIns);
    kbCtrlEnd          = TKeyCode(kb_Ctrl + kbEnd);
    kbCtrlHome         = TKeyCode(kb_Ctrl + kbHome);
    kbCtrlPageDown     = TKeyCode(kb_Ctrl + kbPageDown);
    kbCtrlPageUp       = TKeyCode(kb_Ctrl + kbPageUp);
    kbCtrlBkSp         = TKeyCode(kb_Ctrl + kbBkSp);
    kbCtrlCR           = TKeyCode(kb_Ctrl + kbCR);
    kbCtrlSpace        = TKeyCode(kb_Ctrl + kbSpace);
    kbCtrlTab          = TKeyCode(kb_Ctrl + kbTab);
    kbCtrlEnter        = TKeyCode(kb_Ctrl + kbEnter);
    kbCtrlPause        = TKeyCode(kb_Ctrl + kbPause);
    kbCtrlBreak        = TKeyCode(kb_Ctrl + kbBreak);

    {Alt codes are basic codes + kbAlt}
    kbAlt0             = TKeyCode(kb_Alt + kb_Char + 48);
    kbAlt1             = TKeyCode(kb_Alt + kb_Char + 49);
    kbAlt2             = TKeyCode(kb_Alt + kb_Char + 50);
    kbAlt3             = TKeyCode(kb_Alt + kb_Char + 51);
    kbAlt4             = TKeyCode(kb_Alt + kb_Char + 52);
    kbAlt5             = TKeyCode(kb_Alt + kb_Char + 53);
    kbAlt6             = TKeyCode(kb_Alt + kb_Char + 54);
    kbAlt7             = TKeyCode(kb_Alt + kb_Char + 55);
    kbAlt8             = TKeyCode(kb_Alt + kb_Char + 56);
    kbAlt9             = TKeyCode(kb_Alt + kb_Char + 57);

    kbAltA             = TKeyCode(kb_Alt + kb_Char + kbA);
    kbAltB             = TKeyCode(kb_Alt + kb_Char + kbB);
    kbAltC             = TKeyCode(kb_Alt + kb_Char + kbC);
    kbAltD             = TKeyCode(kb_Alt + kb_Char + kbD);
    kbAltE             = TKeyCode(kb_Alt + kb_Char + kbE);
    kbAltF             = TKeyCode(kb_Alt + kb_Char + kbF);
    kbAltG             = TKeyCode(kb_Alt + kb_Char + kbG);
    kbAltH             = TKeyCode(kb_Alt + kb_Char + kbH);
    kbAltI             = TKeyCode(kb_Alt + kb_Char + kbI);
    kbAltJ             = TKeyCode(kb_Alt + kb_Char + kbJ);
    kbAltK             = TKeyCode(kb_Alt + kb_Char + kbK);
    kbAltL             = TKeyCode(kb_Alt + kb_Char + kbL);
    kbAltM             = TKeyCode(kb_Alt + kb_Char + kbM);
    kbAltN             = TKeyCode(kb_Alt + kb_Char + kbN);
    kbAltO             = TKeyCode(kb_Alt + kb_Char + kbO);
    kbAltP             = TKeyCode(kb_Alt + kb_Char + kbP);
    kbAltQ             = TKeyCode(kb_Alt + kb_Char + kbQ);
    kbAltR             = TKeyCode(kb_Alt + kb_Char + kbR);
    kbAltS             = TKeyCode(kb_Alt + kb_Char + kbS);
    kbAltT             = TKeyCode(kb_Alt + kb_Char + kbT);
    kbAltU             = TKeyCode(kb_Alt + kb_Char + kbU);
    kbAltV             = TKeyCode(kb_Alt + kb_Char + kbV);
    kbAltW             = TKeyCode(kb_Alt + kb_Char + kbW);
    kbAltX             = TKeyCode(kb_Alt + kb_Char + kbX);
    kbAltY             = TKeyCode(kb_Alt + kb_Char + kbY);
    kbAltZ             = TKeyCode(kb_Alt + kb_Char + kbZ);

    kbAltF1            = TKeyCode(kb_Alt + kbF1);
    kbAltF2            = TKeyCode(kb_Alt + kbF2);
    kbAltF3            = TKeyCode(kb_Alt + kbF3);
    kbAltF4            = TKeyCode(kb_Alt + kbF4);
    kbAltF5            = TKeyCode(kb_Alt + kbF5);
    kbAltF6            = TKeyCode(kb_Alt + kbF6);
    kbAltF7            = TKeyCode(kb_Alt + kbF7);
    kbAltF8            = TKeyCode(kb_Alt + kbF8);
    kbAltF9            = TKeyCode(kb_Alt + kbF9);
    kbAltF10           = TKeyCode(kb_Alt + kbF10);
    kbAltF11           = TKeyCode(kb_Alt + kbF11);
    kbAltF12           = TKeyCode(kb_Alt + kbF12);
    kbAltCLeft         = TKeyCode(kb_Alt + kbCLeft);
    kbAltCRight        = TKeyCode(kb_Alt + kbCRight);
    kbAltCUp           = TKeyCode(kb_Alt + kbCUp);
    kbAltCDown         = TKeyCode(kb_Alt + kbCDown);
    kbAltDel           = TKeyCode(kb_Alt + kbDel);
    kbAltIns           = TKeyCode(kb_Alt + kbIns);
    kbAltEnd           = TKeyCode(kb_Alt + kbEnd);
    kbAltHome          = TKeyCode(kb_Alt + kbHome);
    kbAltPageDown      = TKeyCode(kb_Alt + kbPageDown);
    kbAltPageUp        = TKeyCode(kb_Alt + kbPageUp);
    kbAltBkSp          = TKeyCode(kb_Alt + kbBkSp);
    kbAltCR            = TKeyCode(kb_Alt + kbCR);
    kbAltSpace         = TKeyCode(kb_Alt + kbSpace);
    kbAltTab           = TKeyCode(kb_Alt + kbTab);
    kbAltEnter         = TKeyCode(kb_Alt + kbEnter);
    kbAltPause         = TKeyCode(kb_Alt + kbPause);
    kbAltBreak         = TKeyCode(kb_Alt + kbBreak);
{$M-}


Type
    {General System Type. System constants apply To SystemMetrics method}
{$M+}
    TSystemMetrics     = LongInt;

Const
    {System Value indices For TScreen.SystemMetrics()}
    {$IFDEF OS2}
    smCyTitlebar       = TSystemMetrics(SV_CYTITLEBAR);
    smCyMenu           = TSystemMetrics(SV_CYMENU);
    smCxMinMaxButton   = TSystemMetrics(SV_CXMINMAXBUTTON);
    smCyMinMaxButton   = TSystemMetrics(SV_CYMINMAXBUTTON);
    smCxSizeBorder     = TSystemMetrics(SV_CXSIZEBORDER);
    smCySizeBorder     = TSystemMetrics(SV_CYSIZEBORDER);
    smCxDlgBorder      = TSystemMetrics(SV_CXDLGFRAME);
    smCyDlgBorder      = TSystemMetrics(SV_CYDLGFRAME);
    smCxBorder         = TSystemMetrics(SV_CXBORDER);
    smCyBorder         = TSystemMetrics(SV_CYBORDER);
    smCxIcon           = TSystemMetrics(SV_CXICON);
    smCyIcon           = TSystemMetrics(SV_CYICON);
    smCxPointer        = TSystemMetrics(SV_CXPOINTER);
    smCyPointer        = TSystemMetrics(SV_CYPOINTER);
    smCxScreen         = TSystemMetrics(SV_CXSCREEN);
    smCyScreen         = TSystemMetrics(SV_CYSCREEN);
    smCxFullScreen     = TSystemMetrics(SV_CXFULLSCREEN);
    smCyFullScreen     = TSystemMetrics(SV_CYFULLSCREEN);
    smCxVScroll        = TSystemMetrics(SV_CXVSCROLL);
    smCyHScroll        = TSystemMetrics(SV_CYHSCROLL);
    smCxHScrollArrow   = TSystemMetrics(SV_CXHSCROLLARROW);
    smCyHScrollArrow   = TSystemMetrics(SV_CYHSCROLL);
    smCxVScrollArrow   = TSystemMetrics(SV_CXVSCROLL);
    smCyVScrollArrow   = TSystemMetrics(SV_CYVSCROLLARROW);
    smCxHSlider        = TSystemMetrics(SV_CXHSLIDER);
    smCyVSlider        = TSystemMetrics(SV_CYVSLIDER);
    smCMouseButtons    = TSystemMetrics(SV_CMOUSEBUTTONS);
    smMousePresent     = TSystemMetrics(SV_MOUSEPRESENT);
    smSwapButton       = TSystemMetrics(SV_SWAPBUTTON);
    smCxDoubleClick    = TSystemMetrics(SV_CXDBLCLK);
    smCyDoubleClick    = TSystemMetrics(SV_CYDBLCLK);
    smDebug            = TSystemMetrics(SV_DEBUG);
    {$ENDIF}
    {$IFDEF Win32}
    smCyTitlebar       = TSystemMetrics(SM_CYCAPTION);
    smCyMenu           = TSystemMetrics(SM_CYMENU);
    smCxMinMaxButton   = TSystemMetrics(SM_CXSIZE);
    smCyMinMaxButton   = TSystemMetrics(SM_CYSIZE);
    smCxSizeBorder     = TSystemMetrics(SM_CXFRAME);
    smCySizeBorder     = TSystemMetrics(SM_CYFRAME);
    smCxDlgBorder      = TSystemMetrics(SM_CXDLGFRAME);
    smCyDlgBorder      = TSystemMetrics(SM_CYDLGFRAME);
    smCxBorder         = TSystemMetrics(SM_CXBORDER);
    smCyBorder         = TSystemMetrics(SM_CYBORDER);
    smCxIcon           = TSystemMetrics(SM_CXICON);
    smCyIcon           = TSystemMetrics(SM_CYICON);
    smCxPointer        = TSystemMetrics(SM_CXCURSOR);
    smCyPointer        = TSystemMetrics(SM_CYCURSOR);
    smCxScreen         = TSystemMetrics(SM_CXSCREEN);
    smCyScreen         = TSystemMetrics(SM_CYSCREEN);
    smCxFullScreen     = TSystemMetrics(SM_CXFULLSCREEN);
    smCyFullScreen     = TSystemMetrics(SM_CYFULLSCREEN);
    smCxVScroll        = TSystemMetrics(SM_CXVSCROLL);
    smCyHScroll        = TSystemMetrics(SM_CYHSCROLL);
    smCxHScrollArrow   = TSystemMetrics(SM_CXHSCROLL);
    smCyHScrollArrow   = TSystemMetrics(SM_CYHSCROLL);
    smCxVScrollArrow   = TSystemMetrics(SM_CXVSCROLL);
    smCyVScrollArrow   = TSystemMetrics(SM_CYVSCROLL);
    smCxHSlider        = TSystemMetrics(SM_CXHTHUMB);
    smCyVSlider        = TSystemMetrics(SM_CYVTHUMB);
    smCMouseButtons    = TSystemMetrics(SM_CMOUSEBUTTONS);
    smMousePresent     = TSystemMetrics(SM_MOUSEPRESENT);
    smSwapButton       = TSystemMetrics(SM_SWAPBUTTON);
    smCxDoubleClick    = TSystemMetrics(SM_CXDOUBLECLK);
    smCyDoubleClick    = TSystemMetrics(SM_CYDOUBLECLK);
    smDebug            = TSystemMetrics(SM_DEBUG);
    {$ENDIF}
{$M-}


Const
    {Standard Clipboard formats For Use within the SetData method In
     TClipBoard}
    {$IFDEF OS2}
    cfText             = CF_TEXT;
    cfBitmap           = CF_BITMAP;
    cfMetaFile         = CF_METAFILE;
    cfPalette          = CF_PALETTE;
    cfDspText          = CF_DSPTEXT;
    cfDspBitmap        = CF_DSPBITMAP;
    cfDspMetaFile      = CF_DSPMETAFILE;
    {$ENDIF}
    {$IFDEF Win32}
    cfText             = CF_TEXT;
    cfBitmap           = CF_BITMAP;
    cfMetaFile         = CF_METAFILEPICT;
    cfPalette          = CF_PALETTE;
    cfDspText          = CF_DSPTEXT;
    cfDspBitmap        = CF_DSPBITMAP;
    cfDspMetaFile      = CF_DSPMETAFILEPICT;
    {$ENDIF}

Type
    TClipBoard=Class(TComponent)
      protected
         FOpenWin: HWindow;
         Function GetOwner:HWindow;
         Function GetViewer:HWindow;
         Procedure SetViewer(Viewer:HWindow);
         Function GetFormatCount:LongInt;
         Function GetFormats(Index:LongInt):LongWord;
         Function GetAsText:AnsiString;
         Procedure SetAsText(NewValue:AnsiString);
      Public
         Function Open(ahwnd:HWindow):Boolean;
         Function Close:Boolean;
         Function Empty:Boolean;
         Function SetData(Data,format:LongWord):Boolean;
         Function GetData(format:LongWord):LongWord;
         Function CountFormats:LongInt;
         Function EnumFormats(FormatIndex:LongWord):LongWord;
         Function IsFormatAvailable(Format:LongWord):Boolean;
         Function RegisterFormat(Const S:String):LongWord;
         Function GetFormatName(format:LongWord):String;
         Procedure SetTextBuf(Buffer:PChar);
         Function HasFormat(Format:LongWord):Boolean;
         Procedure Clear;
         Property Parent:HWindow Read GetOwner;
         Property Viewer:HWindow Read GetViewer Write SetViewer;
         Property AsText:AnsiString read GetAsText write SetAsText;
         Property FormatCount:LongInt read GetFormatCount;
         Property Formats[Index:LongInt]:LongWord read GetFormats;
    End;


Type
    {predefined mouse Cursor constants}
{$M+}
    TCursor       = LongInt;

Const
    crDefault     = TCursor(0);
    crNone        = TCursor(-1);
    crArrow       = TCursor(-2);
    crCross       = TCursor(-3);
    crIBeam       = TCursor(-4);
    crSize        = TCursor(-5);
    crSizeNESW    = TCursor(-6);
    crSizeNS      = TCursor(-7);
    crSizeNWSE    = TCursor(-8);
    crSizeWE      = TCursor(-9);
    crUpArrow     = TCursor(-10);
    crHourGlass   = TCursor(-11);
    crDrag        = TCursor(-12);
    crNoDrop      = TCursor(-13);
    crHSplit      = TCursor(-14);
    crVSplit      = TCursor(-15);
    crMultiDrag   = TCursor(-16);
    crSQLWait     = TCursor(-17);
    crNo          = TCursor(-18);
    crAppStart    = TCursor(-19);
    crHelp        = TCursor(-20);


Type
    {Standard Font types}
    TFontType=(ftBitmap,ftOutline);

    {Standard Font Attributes}
    TFontAttributes=Set Of(faItalic,faUnderScore,faOutline,faStrikeOut,faBold);

    {Standard Font pitches}
    TFontPitch=(fpFixed,fpProportional);

    {Standard Font character Set}
    TFontCharSet=(fcsSBCS,fcsDBCS,fcsMBCS);  {Single,Double,mixed Byte}
{$M-}


////////////////////////////////////////////////////////////////////////////
//  Change Font Attributes only If you have created A Font Copy using
//  CreateCompatibleFont Or created A New Font using GetFontFromPointSize
//  Changing predefined Fonts As returned from GetSystemSmallFont Or
//  GetSystemFixedFont will have global effects !
////////////////////////////////////////////////////////////////////////////

    TFont=Class(TComponent)
      protected
         FInternalPointSize:LongWord;   {internal Point.Name Value Or Nil}
         {$IFDEF OS2}
         FFontInfo:FONTMETRICS;
         {$ENDIF}
         {$IFDEF Win32}
         FFontInfo:LOGFONT;
         FHandle:HWindow;
         FRefCount:LongWord;
         {$ENDIF}
         FUseCount:LongWord;
         FCustom:Boolean;
         FDefault:Boolean;
         FAutoDestroy:Boolean;
         FFontType:TFontType;
         FAlternateName:PString; //Alternate name for SCU Win<->OS2
         Function GetName:String;
         Function GetFamily:String;
         Function GetPitch:TFontPitch;
         Function GetHeight:LongInt;
         Function GetWidth:LongInt;
         Function GetAttributes:TFontAttributes;
         Procedure SetHeight(NewHeight:LongInt);
         Procedure SetWidth(NewWidth:LongInt);
         Procedure SetAttributes(NewAttr:TFontAttributes);
         Function GetInternalLeading:LongInt;
         Function GetNominalPointSize:LongInt;
         Function GetMinimumPointSize:LongInt;
         Function GetMaximumPointSize:LongInt;
         Function GetCharSet:TFontCharSet;
         Function GetDescenderHeight:LongInt;
      Protected
         Procedure SetupComponent;Override;
      Public
         Constructor Create(AOwner:TComponent);Override;
         Destructor Destroy;Override;
         Function WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceName):Boolean;
         //If This Is Set To True, the Font Is automatically freed when the Control that owns
         //the Font Is destroyed And no other Control owns the Font
         //This option Is only Valid For Fonts created With "CreateCompatibleFont"
         Property IsDefault:Boolean Read FDefault; //undocumented !
         Property AutoDestroy:Boolean Read FAutoDestroy Write FAutoDestroy;
         Property FaceName:String Read GetName;
         Property Family:String Read GetFamily;
         Property Height:LongInt Read GetHeight Write SetHeight;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property InternalLeading:LongInt Read GetInternalLeading;
         Property NominalPointSize:LongInt Read GetNominalPointSize;
         Property MinimumPointSize:LongInt Read GetMinimumPointSize;
         Property MaximumPointSize:LongInt Read GetMaximumPointSize;
         Property Attributes:TFontAttributes Read GetAttributes Write SetAttributes;
         Property Pitch:TFontPitch Read GetPitch;
         Property CharSet:TFontCharSet Read GetCharSet;
         Property FontType:TFontType Read FFontType;
         Property PointSize:LongWord Read FInternalPointSize Write FInternalPointSize;
         Property DescenderHeight:LongInt Read GetDescenderHeight;

    End;

    {Canvas Forward}
    TCanvas=Class;

    {Standard Class styles}
    TClassStyles=Set Of (wcsSizeRedraw,wcsHitTest,
                         wcsFrame,wcsClipChildren,wcsClipSiblings,
                         wcsParentClip,wcsSaveBits,wcsSyncPaint,wcsOwnDC);

    {Window Class Record}
    TClassData=Record
         StandardClass:Boolean;
         ClassName:Cstring;
         WindowProc:Pointer;
         ClassStyle:TClassStyles;
         DataCount:LongWord;
         ClassULong:LongWord; {only used For OS/2}
    End;


    {internal Window Procedure format}
    {$IFDEF OS2}
    TWndProc=Function(Win,Msg,para1,para2:LongWord):LongWord;CDECL;
    {$ENDIF}
    {$IFDEF Win32}
    TWndProc=Function(Win,Msg,para1,para2:LongWord):LongWord;APIENTRY;
    {$ENDIF}

{$M+}
    {Toolbar alignments}
    TToolbarAlign=(tbLeft,tbRight,tbTop,tbBottom);

    TToolbarAlignments=Set Of TToolbarAlign;

    TToolBarBevel=(tbRaised,tbLowered,tbNone);
{$M-}

    {Toolbar Forward}
    TToolbar=Class;
    TToolBarClass=Class Of TToolbar;

    {Control Forward}
    TControl=Class;
    TControlClass=Class Of TControl;

    {Form Forward}
    TForm=Class;
    TFormClass=Class Of TForm;

    {Timer Forward}
    TTimer=Class;
    TTimerClass=Class Of TTimer;

    {Graphic Forward}
    TGraphic=Class;

    {Standard help context Type}
    THelpContext=LongWord;


    TTimer=Class(TComponent)
      protected
         FId:LongInt;
         FRunning:Boolean;
         FTime:LongInt;
         FInterval:LongInt;
         FOnTimer:TNotifyEvent;
      Protected
         Procedure SetupComponent;Override;
         Procedure Timer;Virtual;
      Public
         Destructor Destroy;Override;
         Procedure Start;
         Procedure Stop;
         Property Id:LongInt Read FId;
         Property Running:Boolean Read FRunning;
         Property Time:LongInt Read FTime Write FTime;
      Published
         Property Interval:LongInt Read FInterval Write FInterval;
         Property OnTimer:TNotifyEvent Read FOnTimer Write FOnTimer;
    End;


    {Standard Menu entry styles}
    TMenuItemStyles=Set Of (misText,misBitmap,misOwnerDraw,
         misSubmenu,misMultMenu,misSysCommand,misHelp,misStatic,
         misButtonSeparator,misBreak,misBreakSeparator,misGroup,misSingle);

    {Standard Menu entry Flags}
    TMenuItemFlags=Set Of (mifNoDismiss,mifFramed,mifChecked,mifDisabled,
         mifHilited);

{$M+}
    TMenuBreak=(mbNone,mbBreak,mbBarBreak,mbSeparator);
{$M-}

    {Menu Forward}
    TMenu=Class;

    TMenuItem=Class(TComponent)
      protected
         FParent:TMenuItem;
         FMenu:TMenu;
         FMenuOwner:TControl; {Form}
         FHandle:HWindow;
         FItems:TList;
         FInitItems:TList;   {FItems Or Nil}
         FCaption:PString;
         FStyles:TMenuItemStyles;
         FFlags:TMenuItemFlags;
         FGlyph:TGraphic;
         FCommand:TCommand;
         FInternalCommand:TCommand;
         FCreated:Boolean;
         FDefWndProc:TWndProc;
         FHelpContext:THelpContext;
         FShortCut:TKeyCode;
         FHint:PString;
         FOnClick:TNotifyEvent;
         {$IFDEF OS2}
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMHelp(Var Msg:TMessage); Message WM_HELP;
         {$ENDIF}
         Procedure SetShortCut(NewAccel:TKeyCode);
         Function GetCaption:String;
         Procedure SetCaption(NewCaption:String);
         Procedure SetStyles(NewStyles:TMenuItemStyles);
         Procedure SetFlags(NewFlags:TMenuItemFlags);
         Function GetULongFromStyle:LongWord;
         Function GetULongFromFlags:LongWord;
         Procedure SetGlyph(NewGlyph:TGraphic);
         Procedure SetHint(Const NewText:String);
         Function GetHint:String;
         Function GetChecked:Boolean;
         Procedure SetChecked(Value:Boolean);
         Function GetEnabled:Boolean;
         Procedure SetEnabled(Value:Boolean);
         Function GetBreak:TMenuBreak;
         Procedure SetBreak(Value:TMenuBreak);
         Function GetSubMenu:Boolean;
         Procedure SetSubMenu(Value:Boolean);
         Function GetCount:LongInt;
         Function GetItem(Index:LongInt):TMenuItem;
         Function GetMenuIndex:LongInt;
         Function GetIsEditMenuItem:Boolean;
         {$IFDEF Win32}
         Procedure RedrawMenuBar;
         {$ENDIF}
      Protected
         Procedure SetupComponent;Override;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure CreateWnd;Virtual;
         Property Flags:TMenuItemFlags Read FFlags Write SetFlags;
         Property Styles:TMenuItemStyles Read FStyles Write SetStyles;
      Public
         Destructor Destroy;Override;
         Procedure Add(Item:TMenuItem);
         Procedure Insert(Index:LongInt;Item:TMenuItem);
         Function IndexOf(Item:TMenuItem):LongInt;
         Procedure Click;Virtual;
         Property IsEditMenuItem:Boolean Read GetIsEditMenuItem; {raus}
         Property Handle:HWindow Read FHandle;
         Property Count:LongInt Read GetCount;
         Property Items[Index:LongInt]:TMenuItem Read GetItem; Default;
         Property MenuIndex:LongInt Read GetMenuIndex; {Write SetMenuIndex;}
         Property Parent:TMenuItem Read FParent;
         Property Glyph:TGraphic Read FGlyph Write SetGlyph;
      Published
         Property Caption:String Read GetCaption Write SetCaption;
         Property Command:TCommand Read FCommand Write FCommand;
         Property HelpContext:THelpContext Read FHelpContext Write FHelpContext;
         Property ShortCut:TKeyCode Read FShortCut Write SetShortCut;
         Property Hint:String Read GetHint Write SetHint;
         Property Checked:Boolean Read GetChecked Write SetChecked;
         Property Enabled:Boolean Read GetEnabled Write SetEnabled;
         Property Break:TMenuBreak Read GetBreak Write SetBreak;
         Property Submenu:Boolean Read GetSubMenu Write SetSubMenu;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
    End;
    TMenuItemClass=Class Of TMenuItem;


    TMenu=Class(TComponent)
      protected
         FParent:TControl;      {Frame}
         FItems:TMenuItem;
         FInitItems:TMenuItem;  {FItems Or Nil}
         FHandle:HWindow;
         FResourceId:LongWord;
         {$IFDEF OS2}
         FDefWndProc:TWndProc;
         {$ENDIF}
         FFont:TFont;
         FAlternateFontName:PString;
         {$IFDEF OS2}
         Procedure WMHelp(Var Msg:TMessage); Message WM_HELP;
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         {$ENDIF}
         Function ItemFromCommand(Command:TCommand):TMenuItem;
         Function ItemFromInternalCommand(Command:TCommand):TMenuItem;
         Function GetSelectedMenuItem:TMenuItem;
         Function GetWidth:LongInt;
         Function GetHeight:LongInt;
         Procedure SetFont(NewFont:TFont);
      Protected
         Procedure SetupComponent;Override;
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure LoadResource;
         Procedure CharEvent(entry:TMenuItem;Var key:Char;REP:Byte);Virtual;
         Procedure ScanEvent(entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);Virtual;
         Procedure CreateMenu;Virtual;
         Procedure Show;Virtual;
         Property Width:LongInt Read GetWidth;
         Property Height:LongInt Read GetHeight;
      Public
         Destructor Destroy;Override;
         Procedure DisableCommands(Cmds:Array Of TCommand);
         Procedure EnableCommands(Cmds:Array Of TCommand);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Handle:HWindow Read FHandle;
         Property Items:TMenuItem Read FItems;
         Property MenuItems[Command:TCommand]:TMenuItem Read ItemFromCommand;
      Published
         Property ResourceId:LongWord Read FResourceId Write FResourceId;
         Property Font:TFont Read FFont Write SetFont;
    End;
    TMenuClass=Class Of TMenu;


    {MainMenu Class}
    TMainMenu=Class(TMenu)
      Protected
         Procedure SetupComponent;Override;
         Procedure Show;Override;
      Public
         Property Height;
    End;
    TMainMenuClass=Class Of TMainMenu;


    {$M+}
    TPopupAlignment=(paLeft,paCenter,paRight);
    {$M-}

    {PopupMenu Class}
    TPopupMenu=Class(TMenu)
      protected
         FAutoPopup:Boolean;
         FPopupComponent:TComponent;
         FAlignment:TPopupAlignment;
         FOnPopup:TNotifyEvent;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateMenu;Override;
      Public
         Procedure Popup(X,Y:LongInt);Virtual;
         Property Width;
         Property Height;
         Property PopupComponent:TComponent Read FPopupComponent Write FPopupComPonent;
      Published
         Property AutoPopup:Boolean Read FAutoPopup Write FAutoPopup;
         Property Alignment:TPopupAlignment Read FAlignment Write FAlignment;
         Property OnPopup:TNotifyEvent Read FOnPopup Write FOnPopup;
    End;
    TPopupMenuClass=Class Of TPopupMenu;


    TCaret=Class
      protected
         FLeft,FBottom,FWidth,FHeight:LongInt;
         FCreated:Boolean;
         FBlinkTime:LongInt;
         FOldBlinkTime:LongInt;
         FControl:TControl;
         Procedure SetBlinkTime(ms:LongInt);
      Public
         Constructor Create(Owner:TControl);Virtual;
         Procedure SetPos(Left,Bottom:LongInt);
         Procedure SetSize(Width,Height:LongInt);
         Procedure Show;
         Procedure Hide;
         Procedure Remove;
         Property Left:LongInt Read FLeft Write FLeft;
         Property Bottom:LongInt Read FBottom Write FBottom;
         Property Width:LongInt Read FWidth Write FWidth;
         Property Height:LongInt Read FHeight Write FHeight;
         Property Created:Boolean Read FCreated Write FCreated;
         Property BlinkTime:LongInt Read FBlinkTime Write SetBlinkTime;
    End;


{$M+}
    TScrollCode=(scLineUp,scLineDown,scPageUp,scPageDown,
                 scColumnLeft,scColumnRight,scPageLeft,scPageRight,
                 scHorzTrack,scVertTrack,scHorzPosition,scVertPosition,
                 scHorzEndScroll,scVertEndScroll);

    TDragMode=(dmManual,dmAutomatic);
    TDragState=(dsDragEnter,dsDragMove,dsDragLeave);

    TDragDropSourceType=(drtSibyl,drtSibylObject,drtText,drtBinData,drtString);
    TDragDropRenderType=(drmSibyl,drmSibylObject,drmPrint,drmFile,drmString);
    TDragDropOperation=(doDefault,doCopy,doMove,doLink,doUnknown);
    TDragDropSupportedOps=Set Of(doCopyable,doMoveable,doLinkable);

    PDragDropData=^TDragDropData;
    {$M+}
    TDragDropData=Record
    {$M-}
         SourceWindow:HWindow;
         SourceType:TDragDropSourceType;
         RenderType:TDragDropRenderType;
         SourceString:String;
         RenderString:String;
         ContainerName:String;
         SourceFileName:String;
         TargetFileName:String;
         SupportedOps:TDragDropSupportedOps;
         DragOperation:TDragDropOperation;
         ItemId:LongWord;
    End;

    TExternalDragDropObject=Class(TComponent)
      protected
         FDragDropData:TDragDropData;
      Public
         Property SourceWindow:HWindow Read FDragDropData.SourceWindow;
         Property SourceType:TDragDropSourceType Read FDragDropData.SourceType;
         Property RenderType:TDragDropRenderType Read FDragDropData.RenderType;
         Property SourceString:String Read FDragDropData.SourceString;
         Property RenderString:String Read FDragDropData.RenderString;
         Property ContainerName:String Read FDragDropData.ContainerName;
         Property SourceFileName:String Read FDragDropData.SourceFileName;
         Property TargetFileName:String Read FDragDropData.TargetFileName;
         Property SupportedOps:TDragDropSupportedOps Read FDragDropData.SupporteDops;
         Property DragOperation:TDragDropOperation Read FDragDropData.DragOperatIon;
         Property ItemId:LongWord Read FDragDropData.ItemId;
         Property DragDropData:TDragDropData read FDragDropData write FDragDropData;
    End;
{$M-}

    {ScrollbarControl Forward}
    TScrollBar=Class;
    TScrollBarClass=Class Of TScrollBar;

{$M+}
    {Standard mouse Button states}
    TMouseButton=(mbRight,mbLeft,mbMiddle);

    TShiftState=Set Of (ssShift,ssAlt,ssCtrl,ssRight,ssLeft,ssMiddle,ssDouble);


    {TControl event types}
    TCommandEvent=Procedure(Sender:TObject;Var Command:TCommand) Of Object;
    TKeyPressEvent=Procedure(Sender:TObject;Var key:Char) Of Object;
    TScanEvent=Procedure(Sender:TObject;Var KeyCode:TKeyCode) Of Object;
    TMouseEvent=Procedure(Sender:TObject;Button:TMouseButton;
         Shift:TShiftState;X,Y:LongInt) Of Object;
    TMouseMoveEvent=Procedure(Sender:TObject;Shift:TShiftState;
         X,Y:LongInt) Of Object;
    TPaintEvent=Procedure(Sender:TObject;Const rec:TRect) Of Object;

    TCanDragEvent=Procedure(Sender:TObject;X,Y:LongInt;Var Accept:Boolean) Of Object;
    TStartDragEvent=Procedure(Sender:TObject;Var DragData:TDragDropData) Of Object;
    TEndDragEvent=Procedure(Sender:TObject;target:TObject;X,Y:LongInt) Of Object;
    TDragOverEvent=Procedure(Sender:TObject;Source:TObject;X,Y:LongInt;
         State:TDragState;Var Accept:Boolean) Of Object;
    TDragDropEvent=Procedure(Sender:TObject;Source:TObject;X,Y:LongInt) Of Object;

    TMenuEvent=Procedure(Sender:TObject;AMenu:TMenu;entry:TMenuItem) Of Object;


    TScrollStyle=(ssNone,ssHorizontal,ssVertical,ssBoth);

    {Text Alignment constants}
    TAlignment=(taLeftJustify,taRightJustify,taCenter);

    {Alignment constants}
    TAlign=(alNone,alTop,alBottom,alLeft,alRight,alClient,alFrame,alScale,
         alCenter,alCenterX,alCenterY,
         alFixedLeftTop,alFixedLeftBottom,alFixedRightTop,alFixedRightBottom);

    {X Alignment constants}
    TXAlign=(xaNone,xaParent,xaLeft,xaRight,xaCenter);

    {Y Alignment constants}
    TYAlign=(yaNone,yaParent,yaBottom,yaTop,yaCenter);

    {X stretching constants}
    TXStretch=(xsNone,xsParent,xsFrame,xsScale,xsFixed);

    {Y stretching constants}
    TYStretch=(ysNone,ysParent,ysFrame,ysScale,ysFixed);

    TZOrder=(zoNone,zoBottom,zoTop);
{$M-}

    TMouseParam=Record
         pt:TPoint;
         Button:TMouseButton;
         ShiftState:TShiftState;
    End;

    TKeyParam=Record
         KeyCode:TKeyCode;
         RepeatCount:Byte;
    End;

    TDesignerNotifyCode=(dncMouseDown,dncMouseUp,dncMouseClick,
                         dncMouseDblClk,dncMouseMove,dncChar,dncScan,
                         dncPaint,dncSCUModified,dncNewMenuItem,
                         dncPropertyUpdate);

    TDesignerNotifyStruct=Record
         Sender:TComponent;
         Code:TDesignerNotifyCode;
         return:LongInt;
         Case TDesignerNotifyCode Of
             dncMouseDown,
             dncMouseUp,
             dncMouseClick,
             dncMouseDblClk,
             dncMouseMove:        (mouseparam:TMouseParam);
             dncChar,dncScan:     (keyparam:TKeyParam);
             dncPaint:            (rec:TRect);
    End;


    TCreateParams=Record
         Style:LongInt;
         ExStyle:LongInt;
         FrameStyle:LongInt;
    End;


    PScaleInfo=^TScaleInfo;
    TScaleInfo=Record
         Left,Right,Bottom,Top:Extended;
    End;

    PFrameInfo=^TFrameInfo;
    TFrameInfo=Record
         Left,Right,Bottom,Top:LongInt;
    End;


    TLastMsg=Class
      protected
         FControl:TControl;
         Function GetHandled:LongBool;
         Procedure SetHandled(Value:LongBool);
         Function GetResult:LongWord;
         Procedure SetResult(Value:LongWord);
      Public
         Procedure CallDefaultHandler;
         Property Handled:LongBool Read GetHandled Write SetHandled;
         Property Result:LongWord Read GetResult Write SetResult;
    End;

    {$M+}
    TControlState = Set Of (csLButtonDown, csClicked, csPalette,
                            csReadingState, csAlignmentNeeded, csFocusing, csCreating,
                            csPaintCopy,csWindowDestroying);

    TControlStyle = Set Of (csCaptureMouse,csFramed,csFixedWidth,csFixedHeight,
                            csDisplayDragImage,csHintWindow);
    {$M-}

    TCloseQueryEvent=Procedure(Sender:TObject;Var CanClose:Boolean) Of Object;

    TControl=Class(TComponent)
      Protected
//         FAlwaysFocusChild:TControl;
         FControlState:TControlState;
         FControlStyle:TControlStyle;
         FParent:TControl;
         FControls:TList;
         FWindowId:LongWord;
         FDefWndProc:TWndProc;
         FCursor:TCursor;
         FHandle:HWindow;
         FCanvas:TCanvas;
         FInitCanvas:Boolean;
         FCaption:PString;
         FFrame:TControl;
         FLeft,FBottom,FWidth,FHeight:LongInt;
         FXAlign:TXAlign;
         FYAlign:TYAlign;
         FXStretch:TXStretch;
         FYStretch:TYStretch;
         FZOrder:TZOrder;
         FPenColor:TColor;
         FColor:TColor;
         FHasFocus:Boolean;
         FIsToolBar:Boolean;
         {$IFDEF Win32}
         FClickTime:LongInt;
         FLastLButtonDownTime:LongInt;
         FLastRButtonDownTime:LongInt;
         FDefFontHandle:LongWord;
         FCtlBrush:LongWord;
         {$ENDIF}
         FFont:TFont;
         FEnabled:Boolean;
         FVisible:Boolean;
         FCursorTabStop:Boolean;
         FTabStop:Boolean;
         FTabOrder:LongInt;
         FTabList:TList;
         FForm:TForm;
         FHint:PString;
         FShowHint:Boolean;
         FParentShowHint:Boolean;
         FParentFont:Boolean;
         FParentPenColor:Boolean;
         FParentColor:Boolean;
         FUpdateEnabled:Boolean;
         FOldEnabledState:Boolean;
         FHelpContext:THelpContext;
         FAutoScale:PScaleInfo;
         FAutoFrame:PFrameInfo;
         FLastDeadKey:Word;
         FInitControls:Boolean;
         FFirstShow:Boolean;
         FOwnerDraw:Boolean;
         FHandlesDesignMouse:Boolean;
         FHandlesDesignKey:Boolean;
         FCommand:TCommand;
         FUpdatingPP:Boolean;
         FDragMode:TDragMode;
         FDragState:TDragState;
         FDragControl:TControl;
         FDragging:Boolean;
         FDragCursor:TCursor;
         FLastDragOperation:TDragDropOperation;
         {$IFDEF OS2}
         FDragInfo:PDRAGINFO;
         FDragCanvas:TCanvas;
         {$ENDIF}
         FAlternateFontName:PString;
         FCtl3d:Boolean;
         FMouseCapture:Boolean;
         FLastMsg:TLastMsg;
         FLastMsgAdr:PMessage;
         IsFontChangeEnabled:Boolean;
         IsStandardControl:Boolean;
         IsEditControl:Boolean;
         FPopupMenu:TPopupMenu;
         FOnEnter:TNotifyEvent;
         FOnExit:TNotifyEvent;
         FOnKeyPress:TKeyPressEvent;
         FOnScan:TScanEvent;
         FOnMouseDown:TMouseEvent;
         FOnMouseMove:TMouseMoveEvent;
         FOnMouseUp:TMouseEvent;
         FOnMouseClick:TMouseEvent;
         FOnMouseDblClick:TMouseEvent;
         FOnResize:TNotifyEvent;
         FOnMove:TNotifyEvent;
         FOnPaint:TPaintEvent;
         FOnBeforePaint,FOnAfterPaint:TPaintEvent;
         FOnCommand:TCommandEvent;
         FOnSetupShow:TNotifyEvent;
         FOnShow:TNotifyEvent;
         FOnHide:TNotifyEvent;
         FOnCanDrag:TCanDragEvent;
         FOnStartDrag:TStartDragEvent;
         FOnEndDrag:TEndDragEvent;
         FOnDragOver:TDragOverEvent;
         FOnDragDrop:TDragDropEvent;
         FOnFontChange:TNotifyEvent;
         FOnClick:TNotifyEvent;
         FOnDblClick:TNotifyEvent;
         FOnCloseQuery:TCloseQueryEvent;
      protected
         {$IFDEF OS2}
         Procedure WMBeginDrag(Var Msg:TMessage); Message WM_BEGINDRAG;
         Procedure WMEndDrag(Var Msg:TMessage); Message WM_ENDDRAG;
         Procedure DMDragOver(Var Msg:TMessage); Message DM_DRAGOVER;
         Procedure DMDragLeave(Var Msg:TMessage); Message DM_DRAGLEAVE;
         Procedure DMDrop(Var Msg:TMessage); Message DM_DROP;
         Procedure WMControl(Var Msg:TMessage); Message WM_CONTROL;
         Procedure WMButton1Down(Var Msg:TWMButton1Down); Message WM_BUTTON1DOWN;
         Procedure WMButton2Down(Var Msg:TWMButton2Down); Message WM_BUTTON2DOWN;
         Procedure WMSize(Var Msg:TWMSize); Message WM_SIZE;
         Procedure WMMove(Var Msg:TWMMove); Message WM_MOVE;
         Procedure WMPaint(Var Msg:TMessage); Message WM_PAINT;
         Procedure WMEraseBackGround(Var Msg:TMessage); Message WM_ERASEBACKGROUND;
         Procedure WMPresParamChanged(Var Msg:TMessage); Message WM_PRESPARAMCHANGED;
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMQueryConvertPos(Var Msg:TMessage); Message WM_QUERYCONVERTPOS;
         Procedure WMCommand(Var Msg:TWMCommand); Message WM_COMMAND;
         Procedure WMSetFocus(Var Msg:TWMSetFocus); Message WM_SETFOCUS;
         Procedure WMButton1Up(Var Msg:TWMButton1Up); Message WM_BUTTON1UP;
         Procedure WMButton2Up(Var Msg:TWMButton2Up); Message WM_BUTTON2UP;
         Procedure WMButton1Click(Var Msg:TWMButton1Click); Message WM_BUTTON1CLICK;
         Procedure WMButton1DblClk(Var Msg:TWMButton1DblClk); Message WM_BUTTON1DBLCLK;
         Procedure WMButton2Click(Var Msg:TWMButton2Click); Message WM_BUTTON2CLICK;
         Procedure WMButton2DblClk(Var Msg:TWMButton2DblClk); Message WM_BUTTON2DBLCLK;
         Procedure WMMouseMove(Var Msg:TWMMouseMove); Message WM_MOUSEMOVE;
         Procedure WMHScroll(Var Msg:TWMScroll); Message WM_HSCROLL;
         Procedure WMVScroll(Var Msg:TWMScroll); Message WM_VSCROLL;
         Procedure WMDestroy(Var Msg:TWMDestroy); Message WM_DESTROY;
         Procedure WMCaptureFocus(Var Msg:TMessage); Message WM_CAPTUREFOCUS;
         Procedure WMHelp(Var Msg:TMessage); Message WM_HELP;
         {$ENDIF}
         {$IFDEF Win32}
         Procedure WMButton1Down(Var Msg:TWMButton1Down); Message WM_LBUTTONDOWN;
         Procedure WMButton2Down(Var Msg:TWMButton2Down); Message WM_RBUTTONDOWN;
         Procedure WMSize(Var Msg:TWMSize); Message WM_SIZE;
         Procedure WMMove(Var Msg:TWMMove); Message WM_MOVE;
         Procedure WMPaint(Var Msg:TMessage); Message WM_PAINT;
         Procedure WMEraseBackGround(Var Msg:TMessage); Message WM_ERASEBKGND;
         Procedure WMCommand(Var Msg:TWMCommand); Message WM_COMMAND;
         Procedure WMChar(Var Msg:TWMChar); Message WM_CHAR;
         Procedure WMKillFocus(Var Msg:TMessage); Message WM_KILLFOCUS;
         Procedure WMSetFocus(Var Msg:TWMSetFocus); Message WM_SETFOCUS;
         Procedure WMButton1Up(Var Msg:TWMButton1Up); Message WM_LBUTTONUP;
         Procedure WMButton2Up(Var Msg:TWMButton2Up); Message WM_RBUTTONUP;
         Procedure WMButton1DblClk(Var Msg:TWMButton1DblClk); Message WM_LBUTTONDBLCLK;
         Procedure WMButton2DblClk(Var Msg:TWMButton2DblClk); Message WM_RBUTTONDBLCLK;
         Procedure WMKeyDown(Var Msg:TMessage); Message WM_KEYDOWN;
         Procedure WMSysKeyDown(Var Msg:TMessage); Message WM_SYSKEYDOWN;
         Procedure WMMouseMove(Var Msg:TWMMouseMove); Message WM_MOUSEMOVE;
         Procedure WMSetCursor(Var Msg:TMessage); Message WM_SETCURSOR;
         Procedure WMHScroll(Var Msg:TWMScroll); Message WM_HSCROLL;
         Procedure WMVScroll(Var Msg:TWMScroll); Message WM_VSCROLL;
         Procedure WMCtlColorBtn(Var Msg:TMessage); Message WM_CTLCOLORBTN;
         Procedure WMCtlColorStatic(Var Msg:TMessage); Message WM_CTLCOLORSTATIC;
         Procedure WMCtlColorDlg(Var Msg:TMessage); Message WM_CTLCOLORDLG;
         Procedure WMCtlColorScrollBar(Var Msg:TMessage); Message WM_CTLCOLORSCROLLBAR;
         Procedure WMCtlColorEdit(Var Msg:TMessage); Message WM_CTLCOLOREDIT;
         Procedure WMCtlColorListBox(Var Msg:TMessage); Message WM_CTLCOLORLISTBOX;
         Procedure WMDestroy(Var Msg:TWMDestroy); Message WM_DESTROY;
         Procedure WMNCDestroy(Var Msg:TMessage); Message WM_NCDESTROY;
         Procedure WMCaptureFocus(Var Msg:TMessage); Message WM_CAPTUREFOCUS;
         Procedure WMNotify(Var Msg:TMessage); Message WM_NOTIFY;
         {$ENDIF}
         Procedure WMMeasureItem(Var Msg:TMessage); Message WM_MEASUREITEM;
         Procedure WMDrawItem(Var Msg:TMessage); Message WM_DRAWITEM;

         Function GetControlState:TControlState;
         Function GetControlStyle:TControlStyle;
         Procedure SetControlState(NewValue:TControlState);
         Procedure SetControlStyle(NewValue:TControlStyle);
         Procedure SendScanMessage(Var Msg:TWMChar;Var KeyCode:TKeyCode;RepeatCount:Byte);
         Procedure SendCharMessage(Var Msg:TWMChar;Var CH:Char;RepeatCount:Byte);
         Function GetDesignerCoordinates(Var pt:TPoint):TControl;
         Procedure SetText(Const NewCaption:String);
         Function GetText:String;
         Function GetControlCount:LongInt;
         Function GetControl(AIndex:LongInt):TControl;
         Procedure SetColor(NewColor:TColor);Virtual;
         Procedure SetPenColor(NewColor:TColor);Virtual;
         Procedure SetParentFont(Value:Boolean);
         Procedure SetParentPenColor(Value:Boolean);
         Procedure SetParentColor(Value:Boolean);
         Procedure ParentFontChanged(Var Msg:TMessage); Message CM_PARENTFONTCHANGED;
         Procedure ParentPenColorChanged(Var Msg:TMessage); Message CM_PARENTPENCOLORCHANGEd;
         Procedure ParentColorChanged(Var Msg:TMessage); Message CM_PARENTCOLORCHANGED;
         Procedure SetCursor(Index:TCursor);
         Function GetWindowRect:TRect;
         Procedure SetWindowRect(Const rec:TRect);
         Function GetBoundsRect:TRect;
         Procedure SetBoundsRect(Const rec:TRect);
         Function GetClientRect:TRect;Virtual;
         Function GetClientWidth:LongInt;
         Function GetClientHeight:LongInt;
         Procedure SetClientWidth(NewWidth:LongInt);Virtual;
         Procedure SetClientHeight(NewHeight:LongInt);Virtual;
         Function GetClientOrigin:TPoint;Virtual;
         Function GetParentClientWidth:LongInt;
         Function GetParentClientHeight:LongInt;
         Procedure SetWidth(NewWidth:LongInt);
         Function GetWidth:LongInt;
         Procedure SetHeight(NewHeight:LongInt);Virtual;
         Function GetHeight:LongInt;
         Procedure SetLeft(NewLeft:LongInt);Virtual;
         Function GetLeft:LongInt;Virtual;
         Procedure SetBottom(NewBottom:LongInt);Virtual;
         Function GetBottom:LongInt;Virtual;
         Procedure SetTop(NewTop:LongInt);Virtual;
         Function GetTop:LongInt;
         Procedure SetRight(NewRight:LongInt);Virtual;
         Function GetRight:LongInt;
         Procedure SetAlign(NewAlign:TAlign);
         Function GetAlign:TAlign;
         Procedure SetXAlign(NewAlign:TXAlign);
         Function GetXAlign:TXAlign;
         Procedure SetYAlign(NewAlign:TYAlign);
         Function GetYAlign:TYAlign;
         Procedure SetXStretch(NewStretch:TXStretch);
         Function GetXStretch:TXStretch;
         Procedure SetYStretch(NewStretch:TYStretch);
         Function GetYStretch:TYStretch;
         Procedure SetZOrder(zo:TZOrder);
         Procedure UpdateFont;
         Procedure Enable;
         Procedure Disable;
         Function GetEnabled:Boolean;
         Procedure SetEnabled(NewState:Boolean);
         Function IsWindowVisible:Boolean;
         Function GetShowing:Boolean;
         Function GetVisible:Boolean;
         Procedure SetVisible(NewState:Boolean);
         Function GetTabOrder:LongInt;Virtual;
         Procedure SetTabOrder(Value:LongInt);
         Function GetWindowFlags:LongWord;
         Procedure SetHint(Const NewText:String);
         Function GetHint:String;
         Procedure SetShowHint(Value:Boolean);
         Function GetShowHint:Boolean;
         Procedure SetMouseCapture(captive:Boolean);
         Procedure SetUpdateEnabled(Value:Boolean);
         Procedure SetParent(AParent:TControl);
         {$IFDEF Win32}
         Procedure SetCtlColor(Var Msg:TMessage);
         {$ENDIF}
         Procedure InsertChild(AChild:TControl);
         Procedure Remove(AChild:TControl);
         Function GetFirstTabControl( StartAfter:TControl;
                                      AllowSelf: boolean ):TControl;
         Function GetLastTabControl( StartBefore:TControl;
                                     AllowSelf: boolean ):TControl;
         Function GetNextTabControl(StartAfter:TControl):TControl;
         Function GetPrevTabControl:TControl;
         Procedure FocusTabControl(Next:Boolean);
         Procedure FocusKeyControl(KeyCode:TKeyCode);
         Function GetLastMsg:TLastMsg;
         {$IFDEF OS2}
         Function SetPPFontNameSize(Const FNS:String):Boolean;
         Function SetPPForeGroundColor(AColor:TColor):Boolean;
         Function SetPPBackGroundColor(AColor:TColor):Boolean;
         {$ENDIF}
         Procedure DragFinished(target:TObject; X,Y:LongInt; Accepted:Boolean);
         Procedure DragFree;
         Procedure SetPopupMenu(NewMenu:TPopupMenu);
      Protected
         Procedure SetFont(NewFont:TFont);Virtual;
         Procedure DefaultHandler(Var Msg);Override;
         Procedure WndProc(Var Msg:TMessage);Virtual;
         Procedure UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Virtual;
         Procedure Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:Longint);Virtual;
         Function QueryConvertPos(Var Pos:TPoint):Boolean;Virtual;
         Procedure CharEvent(Var key:Char;RepeatCount:Byte);Virtual;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Virtual;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongINt);Virtual;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Virtual;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Virtual;
         Procedure MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInT);Virtual;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInT);Virtual;
         Procedure CheckMenuPopup(pt:TPoint);Virtual;
         Procedure Resize;Virtual;
         Procedure Move;Virtual;
         Procedure SetFocus;Virtual;
         Procedure KillFocus;Virtual;
         Procedure Paint(Const rec:TRect);Virtual;
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Virtual;
         Procedure GetClassData(Var ClassData:TClassData);Virtual;
         {$IFDEF Win32}
         Procedure CreateSubClass(Var ClassData:TClassData;Const ControlClassName:Cstring);
         {$ENDIF}
         Procedure RegisterClass;Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
         Procedure SetupShow;Virtual;
         Procedure CreateError;Virtual;
         Procedure CreateWnd;Virtual;
         Procedure RecreateWnd;Virtual;
         Procedure CreateControls;Virtual;
         Procedure DisposeWnd;Virtual;
         Procedure DestroyWnd;Virtual;
         Procedure DestroyHandle;
         Procedure RealignControls;Virtual;
         Procedure CommandEvent(Var Command:TCommand);Virtual;
         Procedure ParentNotification(Var Msg:TMessage);Virtual;
         Function EvaluateShortCut(KeyCode:TKeyCode):Boolean;Virtual;
         Procedure CanDrag(X,Y:LongInt;Var Accept:Boolean);Virtual;
         Procedure DoStartDrag(Var DragData:TDragDropData);Virtual;
         Procedure DoEndDrag(target:TObject; X,Y:LongInt);Virtual;
         Procedure DragCanceled;Virtual;
         Procedure DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:Boolean);Virtual;
         Procedure FontChange;Virtual;
         Procedure NotifyControls(MsgId:ULONG);
         Procedure GetChildren(Proc:TGetChildProc);Override;
         Function HasParent:Boolean;Override;
      Public
         Procedure DesignerNotification(Var DNS:TDesignerNotifyStruct);Virtual;
         Procedure ScaleBy(CX,CY:LongInt);
         Procedure ScrollBy(DeltaX,DeltaY:LongInt);
         Function ContainsControl(Control: TControl):Boolean;
         Function ControlAtPos(Const Pos:TPoint;AllowDisabled:Boolean):TControl;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure BeginDrag(Immediate:Boolean); {dummy Parameter}
         Procedure DragDrop(Source:TObject;X,Y:LongInt);Virtual;
         Procedure CreateDragCanvas;
         Procedure DeleteDragCanvas;
         Destructor Destroy;Override;
         Procedure Show;Virtual;
         Procedure Hide;Virtual;
         Procedure BringToFront;Virtual;
         Procedure SendToBack;Virtual;
         Procedure InsertControl(AChild:TControl);Virtual;
         Procedure RemoveControl(AChild:TControl);Virtual;
         Procedure DestroyControls;
         Function CreateCanvas:TCanvas;Virtual;
         Procedure Redraw(Const rec:TRect);Virtual;
         Procedure Refresh;
         Procedure Repaint;
         Procedure Update;Virtual;
         Procedure Invalidate;Virtual;
         Procedure InvalidateRect(Const rec:TRect);
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Virtual;
         Procedure SetBounds(NewLeft,NewTop,NewWidth,NewHeight:LongInt);Virtual; {VCL}
         Procedure Focus;
         Procedure CaptureFocus;
         Function Focused:Boolean;
         Function Perform(MsgId:ULONG;mp1,mp2:LONG):LONG;
         Procedure BroadCast(Var Msg:TMessage);
         Function GetControlFromPoint(pt:TPoint):TControl;
         Function ClientToScreen(Const Point:TPoint):TPoint;
         Function ScreenToClient(Const Point:TPoint):TPoint;
         Procedure MapPoints(target:TControl;Var pts:Array Of TPoint);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInT);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Protected
         Property DragState:TDragState read FDragState write FDragState;
         Property CursorTabStop:Boolean Read FCursorTabStop Write FCursorTabStop;
         Property DefWndProc:TWndProc Read FDefWndProc Write FDefWndProc;
         Property Form:TForm Read FForm;
         Property HandlesDesignKey:Boolean Read FHandlesDesignKey Write FHandlesDesignKey;
         Property HandlesDesignMouse:Boolean Read FHandlesDesignMouse Write FHandlesDeSignMouse;
         Property LastDragOperation:TDragDropOperation Read FLastDragOperation;
         Property LastMsg:TLastMsg Read GetLastMsg;
         Property Ownerdraw:Boolean Read FOwnerDraw Write FOwnerDraw;

         Property Color:TColor Read FColor Write SetColor;
         Property Caption:String Read GetText Write SetText;
         Property Command:TCommand Read FCommand Write FCommand;
         Property DragCursor:TCursor Read FDragCursor Write FDragCursor;
         Property DragMode:TDragMode Read FDragMode Write FDragMode;
         Property Font:TFont Read FFont Write SetFont;
         Property ParentColor:Boolean Read FParentColor Write SetParentColor;
         Property ParentFont:Boolean Read FParentFont Write SetParentFont;
         Property ParentPenColor:Boolean Read FParentPenColor Write SetParentPenColor;
         Property ParentShowHint:Boolean Read FParentShowHint Write FParentShowHint;
         Property PenColor:TColor Read FPenColor Write SetPenColor;
         Property PopupMenu:TPopupMenu Read FPopupMenu Write SetPopupMenu;
         Property ShowHint:Boolean Read FShowHint Write SetShowHint;
         Property Text:String Read GetText Write SetText;
         Property ZOrder:TZOrder Read FZOrder Write SetZOrder;

         Property OnCanDrag:TCanDragEvent Read FOnCanDrag Write FOnCanDrag;
         Property OnKeyPress:TKeyPressEvent Read FOnKeyPress Write FOnKeyPress;
         Property OnCommand:TCommandEvent Read FOnCommand Write FOnCommand;
         Property OnClick:TNotifyEvent Read FOnClick Write FOnClick;
         Property OnDblClick:TNotifyEvent Read FOnDblClick Write FOnDblClick;
         Property OnDragDrop:TDragDropEvent Read FOnDragDrop Write FOnDragDrop;
         Property OnDragOver:TDragOverEvent Read FOnDragOver Write FOnDragOver;
         Property OnEndDrag:TEndDragEvent Read FOnEndDrag Write FOnEndDrag;
         Property OnEnter:TNotifyEvent Read FOnEnter Write FOnEnter;
         Property OnExit:TNotifyEvent Read FOnExit Write FOnExit;
         Property OnFontChange:TNotifyEvent Read FOnFontChange Write FOnFontChange;
         Property OnHide:TNotifyEvent Read FOnHide Write FOnHide;
         Property OnMouseClick:TMouseEvent Read FOnMouseClick Write FOnMouseClick;
         Property OnMouseDblClick:TMouseEvent Read FOnMouseDblClick Write FOnMouseDblCLick;
         Property OnMouseDown:TMouseEvent Read FOnMouseDown Write FOnMouseDown;
         Property OnMouseMove:TMouseMoveEvent Read FOnMouseMove Write FOnMouseMove;
         Property OnMouseUp:TMouseEvent Read FOnMouseUp Write FOnMouseUp;
         Property OnMove:TNotifyEvent Read FOnMove Write FOnMove;
         Property OnPaint:TPaintEvent Read FOnPaint Write FOnPaint;
         Property OnResize:TNotifyEvent Read FOnResize Write FOnResize;
         Property OnScan:TScanEvent Read FOnScan Write FOnScan;
         Property OnSetupShow:TNotifyEvent Read FOnSetupShow Write FOnSetupShow;
         Property OnShow:TNotifyEvent Read FOnShow Write FOnShow;
         Property OnStartDrag:TStartDragEvent Read FOnStartDrag Write FOnStartDrag;
      Public
         Property Align:TAlign Read GetAlign Write SetAlign;
         Property BoundsRect:TRect Read GetBoundsRect write SetBoundsRect;
         Property Canvas:TCanvas Read FCanvas;
         Property ClientHeight:LongInt Read GetClientHeight Write SetClientHeight;
         Property ClientOrigin:TPoint Read GetClientOrigin;
         Property ClientRect:TRect Read GetClientRect;
         Property ClientWidth:LongInt Read GetClientWidth Write SetClientWidth;
         Property ControlCount:LongInt Read GetControlCount;
         Property Controls[Index:LongInt]:TControl Read GetControl;
         Property Dragging:Boolean Read FDragging;
         Property Enabled:Boolean Read GetEnabled Write SetEnabled;
         Property Handle:HWindow Read FHandle;
         Property WindowId:LongWord read FWindowId;
         Property HasFocus:Boolean Read FHasFocus;
         Property MouseCapture:Boolean Read FMouseCapture Write SetMouseCapture;
         Property OnBeforePaint:TPaintEvent Read FOnBeforePaint Write FOnBeforePaint;
         Property OnAfterPaint:TPaintEvent Read FOnAfterPaint Write FOnAfterPaint;
         Property Parent:TControl Read FParent Write SetParent;
         Property Showing:Boolean Read GetShowing;
         Property TabOrder:LongInt Read GetTabOrder Write SetTabOrder;
         Property TabStop:Boolean Read FTabStop Write FTabStop;
         Property UpdateEnabled:Boolean Read FUpdateEnabled Write SetUpdateEnabled;
         Property Visible:Boolean Read GetVisible Write SetVisible;
         Property WindowRect:TRect Read GetWindowRect write SetWindowRect;
         Property XAlign:TXAlign Read GetXAlign Write SetXAlign;
         Property XStretch:TXStretch Read GetXStretch Write SetXStretch;
         Property YAlign:TYAlign Read GetYAlign Write SetYAlign;
         Property YStretch:TYStretch Read GetYStretch Write SetYStretch;
         Property ControlState: TControlState read GetControlState write SetControlState;
         Property ControlStyle: TControlStyle read GetControlStyle write SetControlStyle;
      Published
         Property Bottom:LongInt Read GetBottom Write SetBottom;
         Property Height:LongInt Read GetHeight Write SetHeight;
         Property HelpContext:THelpContext Read FHelpContext Write FHelpContext;
         Property Hint:String Read GetHint Write SetHint;
         Property Left:LongInt Read GetLeft Write SetLeft;
         Property Cursor:TCursor Read FCursor Write SetCursor;
         Property Right:LongInt Read GetRight Write SetRight; Stored False;
         Property Top:LongInt Read GetTop Write SetTop; Stored False;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property OnCloseQuery:TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
         Property Ctl3d:Boolean Read FCtl3d Write FCtl3d;
    End;

    TGraphicControl=Class(TControl)
      Protected
         Property Canvas;
    End;

    TBitBltMode=(cmSrcCopy, cmSrcPaint, cmSrcAnd, cmSrcInvert,
                 cmSrcErase, cmNotSrcCopy, cmNotSrcErase,
                 cmMergeCopy, cmMergePaint, cmPatCopy, cmPatPaint,
                 cmPatInvert, cmDstInvert, cmBlackness, cmWhiteness,
                 cmNotSrcAndDest,   // keep dest, where src is 0
                 cmSrcAndPatErase,  // clear dest, where src and pattern are 1
                 cmSrcAndPatOrDest ); // draw src, where pattern is 1, keep dest

    TBitBltFlags=(bitfOr,bitfAnd,bitfIgnore);


    {$M+}
    TPenStyle = (psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear,
                 psInsideFrame);
    TPenMode = (pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot,
                pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge,
                pmMask, pmNotMask, pmXor, pmNotXor);
    {$M-}

    TPen=Class(TComponent)
      protected
         FCanvas:TCanvas;
         FColor:TColor;
         FStyle:TPenStyle;
         FMode:TPenMode;
         FWidth:LongInt;
         Procedure SetColor(NewColor:TColor);
         Procedure SetMode(NewMode:TPenMode);
         Procedure SetStyle(NewStyle:TPenStyle);
         Procedure SetWidth(NewWidth:LongInt);
      Public
         Procedure SetupComponent;Override;
         Procedure Assign(Source:TPersistent);Override;
      Published
         Property Color:TColor Read FColor Write SetColor;
         Property Mode:TPenMode Read FMode Write SetMode;
         Property Style:TPenStyle Read FStyle Write SetStyle;
         Property Width:LongInt Read FWidth Write SetWidth;
    End;

    {$M+}
    TBrushStyle = (bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal,
                   bsBDiagonal, bsCross, bsDiagCross, bsHalfTone);
    TBrushMode  = (bmTransparent,bmOpaque);
    {$M-}

    TBrush=Class(TComponent)
      protected
         FCanvas:TCanvas;
         FBitmap:TGraphic;
         FColor:TColor;
         FStyle:TBrushStyle;
         FMode:TBrushMode;
         Procedure SetColor(NewColor:TColor);
         Procedure SetStyle(NewStyle:TBrushStyle);
         Procedure SetBitmap(NewBitmap:TGraphic);
         Procedure SetMode(NewMode:TBrushMode);
      Public
         Procedure SetupComponent;Override;
         Destructor Destroy;Override;
         Property Bitmap:TGraphic Read FBitmap Write SetBitmap;
         Procedure Assign(Source:TPersistent);Override;
      Published
         Property Color:TColor Read FColor Write SetColor;
         Property Style:TBrushStyle Read FStyle Write SetStyle;
         Property Mode:TBrushMode Read FMode Write SetMode;
    End;


    {$M+}
    TSizeBorderEvent=Procedure(Sender:TObject;Var SizeDelta:LongInt) Of Object;
    TSizeBorderAlign=(baVertical,baHorizontal,baTop,baBottom,baLeft,baRight,
                      baParentWidth,baParentHeight);
    {$M-}

    TSizeBorder=Class(TControl)
      protected
         FBorderAlign:TSizeBorderAlign;
         FSizing:Boolean;
         FOffs:LongInt;
         FDelta:LongInt;
         OldFgMode:TPenMode;
         OldLineWidth:LongInt;
         OldLineType:TPenStyle;
         FOnSizing:TSizeBorderEvent;
         FOnSized:TSizeBorderEvent;
         Procedure SetBorderAlign(Value:TSizeBorderAlign);
         Procedure DrawSizeLine;
      Protected
         Procedure SetupComponent;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Property Hint;
         Property Cursor;
      Public
         Procedure Redraw(Const rec:TRect);Override;
      Published
         Property BorderAlign:TSizeBorderAlign Read FBorderAlign Write SetBorderAliGn;
         Property OnSized:TSizeBorderEvent Read FOnSized Write FOnSized;
         Property OnSizing:TSizeBorderEvent Read FOnSizing Write FOnSizing;
    End;


    TToolbar=Class(TControl)
      protected
         FAlignment:TToolbarAlign;
         FBevelStyle:TToolBarBevel;
         FSizeable:Boolean;
         FOrder:LongInt;
         SizeBorderCtrl:TSizeBorder;
         Procedure SetAlignment(NewAlign:TToolbarAlign);
         Procedure SetBevelStyle(NewStyle:TToolBarBevel);
         Procedure SetSize(NewSize:LongInt);
         Function GetSize:LongInt;
         Function GetLeft:LongInt;Override;
         Function GetBottom:LongInt;Override;
         Procedure SetLeft(NewLeft:LongInt);Override;
         Procedure SetBottom(NewBottom:LongInt);Override;
         Procedure SetTop(NewTop:LongInt);Override;
         Procedure SetRight(NewRight:LongInt);Override;
         Procedure SetSizeable(Value:Boolean);
         Procedure SetOrder(Value:LongInt);
         Function GetOrder:LongInt;
         Procedure EvBorderSizing(Sender:TObject;Var SizeDelta:LongInt);
         Procedure EvBorderSized(Sender:TObject;Var SizeDelta:LongInt);
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure SetupShow;Override;
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Procedure EnableCommands(Cmds:Array Of TCommand);   {raus}
         Procedure DisableCommands(Cmds:Array Of TCommand);  {raus}
         Procedure Hide;Override;
         Procedure Show;Override;
         Property Bottom;
         Property Height;
         Property Left;
         Property Right;
         Property Top;
         Property Width;
      Published
         Property Alignment:TToolbarAlign Read FAlignment Write SetAlignment;
         Property Color;
         Property BevelStyle:TToolBarBevel Read FBevelStyle Write SetBevelStyle;
         Property Enabled;
         Property PenColor;
         Property Font;
         Property HelpContext;
         Property Order:LongInt Read GetOrder Write SetOrder; Stored False;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property Size:LongInt Read GetSize Write SetSize;
         Property Sizeable:Boolean Read FSizeable Write SetSizeable;

         Property OnClick;
         Property OnDblClick;
         Property OnCommand;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnResize;
         Property OnSetupShow;
    End;


{$M+}
    TScrollBarKind=(sbHorizontal,sbVertical);

    TScrollEvent=Procedure(Sender:TObject;ScrollCode:TScrollCode;
                             Var ScrollPos:LongInt) Of Object;
{$M-}
    TScrollBarInc=1..32767;

    TScrollingWinControl=Class;

    TScrollBar=Class(TControl)
      protected
         lastpos:LongInt;
         FMin:LongInt;
         FMax:LongInt;
         FSliderSize:LongInt;
         FCalcRange:LongInt;
         FPosition:LongInt;
         FScale:Extended;
         FSmallChange:TScrollBarInc;
         FLargeChange:TScrollBarInc;
         FKind:TScrollBarKind;
         FOnScroll:TScrollEvent;
         FOnChange:TNotifyEvent;
         FControl:TScrollingWinControl;
         Procedure SetPosition(NewPosition:LongInt);
         Procedure SetMin(NewMin:LongInt);
         Procedure SetMax(NewMax:LongInt);
         Procedure SetSliderSize(NewSliderSize:LongInt);
         Procedure SetKind(NewKind:TScrollBarKind);
         Procedure SetPenColor(NewColor:TColor);Override;
         Procedure SetColor(NewColor:TColor);Override;
      Protected
         Procedure SetupComponent;Override;
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure SetupShow;Override;
      Public
         Procedure SetScrollRange(aMin,aMax,aSliderSize:LongInt);
         Procedure SetParams(aPosition,aMin,aMax:LongInt);
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Kind:TScrollBarKind Read FKind Write SetKind;
         Property LargeChange:TScrollBarInc Read FLargeChange Write FLargeChange;
         Property Max:LongInt Read FMax Write SetMax;
         Property Min:LongInt Read FMin Write SetMin;
         Property ParentShowHint;
         Property PopupMenu;
         Property Position:LongInt Read FPosition Write SetPosition;
         Property ShowHint;
         Property SliderSize:LongInt Read FSliderSize Write SetSliderSize;
         Property SmallChange:TScrollBarInc Read FSmallChange Write FSmallChange;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnClick;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnScan;
         Property OnScroll:TScrollEvent Read FOnScroll Write FOnScroll;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TControlScrollBar=Class(TScrollBar)
      Public
         Procedure SetupComponent;Override;
      Public
         Property Align;
         Property Bottom;
         Property Cursor;
         Property Left;
         Property Right;
         Property Top;
         Property HelpContext;
         Property Name;
         Property Tag;
         Property Width;
         Property Height;
         Property Hint;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property Kind;
         Property ParentShowHint;
         Property PopupMenu;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnMouseMove;
         Property OnScan;
         Property OnScroll;
         Property OnSetupShow;
         Property OnStartDrag;
    End;


    TScrollingWinControl=Class(TControl)
      protected
         FScrollBars:TScrollStyle;
         FHorzScrollBar:TControlScrollBar;
         FVertScrollBar:TControlScrollBar;
         FAutoScroll:Boolean;
         FHMin,FVMin:LongInt;
         FHMax,FVMax:LongInt;
         FHPos,FVPos:LongInt;
         FHLargeChange,FVLargeChange:LongInt;
         FHSmallChange,FVSmallChange:LongInt;
         FHColor,FVColor:LongInt;
         FHSliderSize,FVSliderSize:LongInt;
         FIgnoreAdjust:Boolean;
         Procedure SetScrollBars(NewValue:TScrollStyle);
         Procedure SetAutoScroll(NewValue:Boolean);
         Procedure AlignScrollbars;
         Procedure AdjustScrollbars;
      Protected
         Procedure Resize;Override;
         Procedure Paint(Const rec:TRect);Override;
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
         Procedure Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:Longint);Override;
         Procedure Loaded;Override;
      Public
         Destructor Destroy;Override;
         Procedure ScrollInView(AControl:TControl);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Procedure InsertControl(AChild:TControl);Override;
         Procedure RemoveControl(AChild:TControl);Override;
      Public
         Property AutoScroll:Boolean read FAutoScroll write SetAutoScroll;
         Property HorzScrollBar:TControlScrollBar Read FHorzScrollBar;
         Property VertScrollBar:TControlScrollBar Read FVertScrollBar;
         Property ScrollBars:TScrollStyle Read FScrollBars Write SetScrollBars;
    End;


    {$M+}
    TFormBorderStyle=(bsNone,bsSingle,bsSizeable,bsDialog,bsToolWindow,
                      bsSizeToolWin);
    TBorderStyle=bsNone..bsSingle;
    {$M-}

    TScrollBox=Class(TScrollingWinControl)
      protected
        FBorderStyle:TBorderStyle;
        Procedure SetBorderStyle(NewValue:TBorderStyle);
      Protected
        Procedure SetupComponent;Override;
      Public
        Procedure Redraw(Const rec:TRect);Override;
      Published
        Property Align;
        Property Cursor;
        Property Tag;
        Property AutoScroll;
        Property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle;
        Property DragCursor;
        Property DragMode;
        Property Enabled;
        Property Color;
        Property Font;
        Property HorzScrollBar; stored False;
        Property VertScrollBar; stored False;
        Property ParentColor;
        Property ParentFont;
        Property ParentShowHint;
        Property PopupMenu;
        Property ShowHint;
        Property TabOrder;
        Property TabStop;
        Property Visible;
        Property ZOrder;
        Property OnClick;
        Property OnCanDrag;
        Property OnKeyPress;
        Property OnDblClick;
        Property OnDragDrop;
        Property OnDragOver;
        Property OnEndDrag;
        Property OnEnter;
        Property OnExit;
        Property OnMouseDown;
        Property OnMouseMove;
        Property OnMouseUp;
        Property OnResize;
        Property OnPaint;
        Property OnScan;
        Property OnShow;
    End;


{$M+}
    TCloseAction=(caNone,caHide,caFree,caMinimize,caFreeHandle);

    TWindowState=(wsNormal,wsMinimized,wsMaximized);

    TBorderIcons=Set Of (biSystemMenu,biMinimize,biMaximize,biHelp);

    TFormStyle=(fsNormal,fsMDIChild,fsMDIForm);

    TTileMode=(tbHorizontal,tbVertical,tbNormal);

    TCloseEvent=Procedure(Sender:TObject;Var Action:TCloseAction) Of Object;
    TMDIActivateEvent=Procedure(Sender:TObject;Child:TForm) Of Object;
    TMDIDeactivateEvent=Procedure(Sender:TObject;Child:TForm) Of Object;
    TTranslateShortCutEvent=Procedure(Sender:TObject;KeyCode:TKeyCode;Var ReceiveR:TforM) Of object;
{$M-}

    {FAccelList Item}
    PAccelItem=^AccelItem;
    AccelItem=Record
         KeyCode:TKeyCode;
         Command:TCommand;
    End;


    TPosition=(poDesigned,poDefault,poDefaultPosOnly,poDefaultSizeOnly,poScreenCenter);

    TModalResult=TCommand;

    TFormOptions = record
      TitleBar: boolean;
      TaskListEntry: boolean;
    end;

    TForm=Class(TScrollingWinControl)
      protected
         FModalOwner:TControl;
         FMainMenu:TMainMenu;
         FLastMenu:TMenu;
         FLastEntry:TMenuItem;
         FMenuHandleList:TList;
         FAccelList:TList;
         FAccel:LongWord;
         FShortCutsEnabled:Boolean;
         FTopMDIChild:TForm;
         FIsModal:Boolean;
         FModalShowing:Boolean;
         FModalResult:TModalResult;
         FLocked:Boolean;
         FWindowState:TWindowState;
         FBorderIcons:TBorderIcons;
         FBorderStyle:TFormBorderStyle;
         FFormStyle:TFormStyle;
         FTileMode:TTileMode;
         FMinTrackWidth:LongInt;
         FMinTrackHeight:LongInt;
         FMaxTrackWidth:LongInt;
         FMaxTrackHeight:LongInt;
         FEnableDocking:TToolbarAlignments;
         FMoveable:Boolean;
         FSizeable:Boolean;
         FActiveControl:TControl;
         FMDIChildren:TList;
         FToolBarLists:Array[TToolbarAlign] Of TList;
         FIcon:TGraphic;
         FInternalWindowIdCount:LongWord;
         FDBCSStatusLine:Boolean;
         DefaultButton:TControl;
         CancelButton:TControl;
         FPosition:TPosition;
         FOptions:TFormOptions;
         FOnActivate:TNotifyEvent;
         FOnDeactivate:TNotifyEvent;
         FOnMDIActivate:TMDIActivateEvent;
         FOnMDIDeactivate:TMDIDeactivateEvent;
         FOnClose:TCloseEvent;
         FOnDismissDlg:TNotifyEvent;
         FOnMenuInit:TMenuEvent;
         FOnMenuEnd:TMenuEvent;
         FOnMenuItemFocus:TMenuEvent;
         FOnTranslateShortCut:TTranslateShortCutEvent;
         FOnMinimize:TNotifyEvent;
         FOnMaximize:TNotifyEvent;
         FOnRestore:TNotifyEvent;
         FOnCreate:TNotifyEvent;
         FOnDestroy:TNotifyEvent;
         Procedure CMRelease(Var Msg:TMessage); Message CM_RELEASE;
         Procedure CMEndModalState(Var Msg:TMessage); Message CM_ENDMODALSTATE;
         Procedure CMUpdateButtons(Var Msg:TMessage); Message CM_UPDATEBUTTONS;
         Procedure WMActivate(Var Msg:TWMActivate); Message WM_ACTIVATE;
         {$IFDEF OS2}
         Procedure WMClose(Var Msg:TWMClose); Message WM_CLOSE;
         Procedure WMInitMenu(Var Msg:TMessage); Message WM_INITMENU;
         Procedure WMMenuEnd(Var Msg:TMessage); Message WM_MENUEND;
         Procedure WMMenuSelect(Var Msg:TMessage); Message WM_MENUSELECT;
         Procedure WMTranslateAccel(Var Msg:TMessage); Message WM_TRANSLATEACCEL;
         Procedure WMDDEInitiate(Var Msg:TMessage); Message WM_DDE_INITIATE;
         Procedure WMDDEDestroy(Var Msg:TMessage); Message WM_DDE_DESTROY;
         {$ENDIF}
         Procedure AlignToolBars;
         Function GetFrameFlags:LongWord;
         Function GetMDIChildCount:LongInt;
         Function GetMDIChild(AIndex:LongInt):TForm;
         Procedure SetWindowState(NewState:TWindowState);
         Function GetWindowState:TWindowState;
         Procedure SetBorderIcons(NewIcons:TBorderIcons);
         Procedure SetBorderStyle(NewStyle:TFormBorderStyle);
         Function GetTabOrder:LongInt;Override;
         Function GetAddWidth:LongInt;
         Function GetAddHeight:LongInt;
         Function GetClientRect:TRect;Override;
         Procedure SetClientWidth(NewWidth:LongInt);Override;
         Procedure SetClientHeight(NewHeight:LongInt);Override;
         Function GetClientOrigin:TPoint;Override;
         Procedure SetDBCSStatusLine(Value:Boolean);
         Procedure SetActiveControl(AControl:TControl);
         Procedure ForwardShortCut(Var Msg:TMessage);
         Procedure SetIcon(NewIcon:TGraphic);
         Function GetIcon:TGraphic;
         Procedure IconChanged(Sender:TObject);
         Procedure SetMainMenu(AMenu:TMainMenu);
         Procedure SetShortCutsEnabled(Value:Boolean);
         Procedure SetFormStyle(Value:TFormStyle);
         Procedure InsertMDIChild(Child:TForm);
         Procedure RemoveMDIChild(Child:TForm);
         Procedure CreateUniqueWindowId(AChild:TControl);
         Function GetLanguage:String;
         Procedure SetLanguage(Const NewLanguage:String);
         Procedure SetPosition(NewValue:TPosition);
         Constructor CreateIntern(AOwner:TComponent; Var AReference:TForm);
      Protected
         Procedure CreateControls;Override;
         Procedure RealignControls;Override;
         Procedure Activate;Virtual;
         Procedure Deactivate;Virtual;
         Procedure MDIActivate(Child:TForm);Virtual;
         Procedure MDIDeactivate(Child:TForm);Virtual;
         Function GetTileCascadeRect:TRect;Virtual;
         Procedure ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);Override;
         Procedure CommandEvent(Var Command:TCommand);Override;
         Procedure TranslateShortCut(KeyCode:TKeyCode;Var Receiver:TForm);Virtual;
         Function CloseQuery:Boolean;Virtual;
         Procedure EndModalState;Virtual;
         Procedure SetupComponent;Override;
         Procedure CreateWnd;Override;
         Procedure SetupShow;Override;
         Procedure SetFocus;Override;
         Procedure Resize;Override;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MenuInit(AMenu:TMenu;entry:TMenuItem);Virtual;
         Procedure MenuEnd(AMenu:TMenu;entry:TMenuItem);Virtual;
         Procedure MenuItemFocus(AMenu:TMenu;entry:TMenuItem);Virtual;
         Procedure MenuCharEvent(AMenu:TMenu;entry:TMenuItem;Var key:Char;REP:ByTe);Virtual;
         Procedure MenuScanEvent(AMenu:TMenu;entry:TMenuItem;Var KeyCode:TKeyCodE;REP:Byte);Virtual;
         Procedure LoadedFromSCU(SCUParent:TComponent);Override;
      Public
         Constructor Create(AOwner:TComponent);Override;
         Constructor CreateNew(AOwner:TComponent);
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInT);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Destructor Destroy;Override;
         Procedure Release;
         Function ShowModal:LongWord;Virtual;
         Function ShowModal2(Owner:TForm):LongWord;
         Procedure DismissDlg(Result:TCommand);Virtual;
         Procedure Close;Virtual;
         Procedure RemoveComponent(AComponent:TComponent);Override;
         Procedure InsertControl(AChild:TControl);Override;
         Procedure RemoveControl(AChild:TControl);Override;
         Procedure SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);Override;
         Procedure BringToFront;Override;
         Procedure Tile;Virtual;
         Procedure Cascade;Virtual;
         Procedure Next;Virtual;
         Function GetFormImage:TGraphic;
         Procedure Print(Canvas:TCanvas;Dest:TRect);
         Procedure Previous;Virtual;
         Procedure CloseAll;Virtual;
         Procedure AddShortCut(KeyCode:TKeyCode;Command:TCommand);
         Procedure DeleteShortCut(KeyCode:TKeyCode);
      Public
         Property Moveable:Boolean Read FMoveable Write FMoveable; {only OS2}
         Property Sizeable:Boolean Read FSizeable Write FSizeable; {only OS2}
         Property ModalResult:TModalResult Read FModalResult Write FModalResult;
         Property IsModal:Boolean Read FIsModal;
         Property TileMode:TTileMode Read FTileMode Write FTileMode;
         Property MDIChildren[Index:LongInt]:TForm Read GetMDIChild;
         Property MDIChildCount:LongInt Read GetMDIChildCount;
         Property ActiveMDIChild:TForm Read FTopMDIChild;
         Property ActiveControl:TControl Read FActiveControl Write SetActiveContRol;
         Property Frame:TControl Read FFrame;
         Property DBCSStatusLine:Boolean Read FDBCSStatusLine Write SetDBCSStatuSlinE;
         Property ShortCutsEnabled:Boolean Read FShortCutsEnabled Write SetShortCutsEnablEd;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property AutoScroll;
         Property Color;
         Property BorderIcons:TBorderIcons Read FBorderIcons Write SetBorderIcons;
         Property BorderStyle:TFormBorderStyle Read FBorderStyle Write SetBorderStYlE;
         Property Caption;
         Property ClientWidth;
         Property ClientHeight;
         Property Language:String Read GetLanguage Write SetLanguage;
         Property Menu:TMainMenu Read FMainMenu Write SetMainMenu;
         Property MaxTrackWidth:LongInt Read FMaxTrackWidth Write FMaxTrackWidth;
         Property MaxTrackHeight:LongInt Read FMaxTrackHeight Write FMaxTrackHeighT;
         Property MinTrackWidth:LongInt Read FMinTrackWidth Write FMinTrackWidth;
         Property MinTrackHeight:LongInt Read FMinTrackHeight Write FMinTrackHeighT;
         Property PenColor;
         Property PopupMenu;
         Property Position:TPosition Read FPosition Write SetPosition;
         Property Enabled;
         Property EnableDocking:TToolbarAlignments Read FEnableDocking Write FEnabLeDockiNg;
         Property Font;
         Property FormStyle:TFormStyle Read FFormStyle Write SetFormStyle;
         Property Icon:TGraphic Read GetIcon Write SetIcon;
         Property ScrollBars;
         Property HorzScrollBar;
         Property VertScrollBar;
         Property ShowHint;
         Property Visible;
         Property WindowState:TWindowState Read GetWindowState Write SetWindowStatE;
         Property Options: TFormOptions read FOptions Write FOptions;

         Property OnActivate:TNotifyEvent Read FOnActivate Write FOnActivate;
         Property OnClick;
         Property OnClose:TCloseEvent Read FOnClose Write FOnClose;
         Property OnCommand;
         Property OnCreate:TNotifyEvent Read FOnCreate Write FOnCreate;
         Property OnDblClick;
         Property OnDeactivate:TNotifyEvent Read FOnDeactivate Write FOnDeactivate;
         Property OnDestroy:TNotifyEvent Read FOnDestroy Write FOnDestroy;
         Property OnDismissDlg:TNotifyEvent Read FOnDismissDlg Write FOnDismissDlg;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnFontChange;
         Property OnHide;
         Property OnKeyPress;
         Property OnMaximize:TNotifyEvent Read FOnMaximize Write FOnMaximize;
         Property OnMDIActivate:TMDIActivateEvent Read FOnMDIActivate Write FOnMDIAcTivatE;
         Property OnMDIDeactivate:TMDIDeactivateEvent Read FOnMDIDeactivate Write FONMDIDEacTivate;
         Property OnMenuEnd:TMenuEvent Read FOnMenuEnd Write FOnMenuEnd;
         Property OnMenuInit:TMenuEvent Read FOnMenuInit Write FOnMenuInit;
         Property OnMenuItemFocus:TMenuEvent Read FOnMenuItemFocus Write FOnMenuItemFocus;
         Property OnMinimize:TNotifyEvent Read FOnMinimize Write FOnMinimize;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnMove;
         Property OnPaint;
         Property OnResize;
         Property OnRestore:TNotifyEvent Read FOnRestore Write FOnRestore;
         Property OnScan;
         Property OnSetupShow;
         Property OnShow;
         Property OnTranslateShortCut:TTranslateShortCutEvent Read FOnTranslateShortCut WritE fonTranslateShortCut;
    End;


    HCursor=LongWord;

    PCursorRec=^TCursorRec;
    TCursorRec=Record
         Index:TCursor;
         Handle:HCursor;
         Next:PCursorRec;
    End;


    TScreen=Class(TComponent)
      protected
         FFonts:TList;                      //Font List available (TFont)
         FCursor:TCursor;
         FCursorList:PCursorRec;  //mouse Cursor List available
         FDefaultCursor:HCursor;
         FForms:TList;                      //Forms on the DeskTop (TForm)
         FActiveForm:TForm;                 //Active DeskTop Form
         FActiveControl:TControl;
         FLastActiveForm:TForm;
         FLastActiveControl:TControl;
         FCanvas:TCanvas;
         FMenuFont:TFont;
         FSystemFont:TFont;
         FDefaultFont:TFont;
         FDefaultFrameFont:TFont;
         FFontWindow:TControl;              //FontWindow For OS/2
         FHiddenWindow:TControl;             //Window For PopupMenus & Timers
         FOnActiveFormChange:TNotifyEvent;
         FOnActiveControlChange:TNotifyEvent;
         Procedure CreateCursors;
         Procedure DestroyCursors;
         Procedure InsertCursor(Index:TCursor;Handle:HCursor);
         Procedure DeleteCursor(Index:TCursor);
         Function GetCursors(Index:TCursor):HCursor;
         Procedure SetCursors(Index:TCursor;Handle:HCursor);
         Procedure SetCursor(Index:TCursor);
         Function GetHeight:LongInt;
         Function GetWidth:LongInt;
         Function GetFormCount:LongInt;
         Function GetForm(Index:LongInt):TForm;
         Function GetFontCount:LongInt;
         Function GetFont(Index:LongInt):TFont;
         Function GetMousePos:TPoint;
         Procedure SetMousePos(NewPos:TPoint);
         Function GetSystemDefaultFont:TFont;
         Function GetSystemFixedFont:TFont;
         Function GetSystemSmallFont:TFont;
         Procedure UpdateLastActive;
         Function GetCanvas:TCanvas;
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Function CreateCompatibleFont(Src:TFont):TFont;
         Function GetFontFromName(FaceName:String;Height,Width:LongInt):TFont;
         Function GetFontFromPointSize(FaceName:String;PointSize:LongWord):TFont;
         Function GetControlFromPoint(pt:TPoint):TControl;
         Function SystemMetrics(sm:TSystemMetrics):LongInt;
         Function SystemColors(sc:TColor):TColor;
         Procedure Update;
         Procedure MapPoints(Target:TControl;Var pts:Array Of TPoint);
         Function AddCursor(Handle:HCursor):TCursor;
      Public
         Property Width:LongInt Read GetWidth;
         Property Height:LongInt Read GetHeight;
         Property Forms[Index:LongInt]:TForm Read GetForm;
         Property FormCount:LongInt Read GetFormCount;
         Property ActiveForm:TForm Read FActiveForm;
         Property ActiveControl:TControl Read FActiveControl;
         Property MousePos:TPoint Read GetMousePos Write SetMousePos;
         Property Cursor:TCursor Read FCursor Write SetCursor;
         Property Cursors[Index:TCursor]:HCursor Read GetCursors Write SetCursors;
         Property Fonts[Index:LongInt]:TFont Read GetFont;
         Property FontCount:LongInt Read GetFontCount;
         Property DefaultFrameFont:TFont Read FDefaultFrameFont;
         Property DefaultFont:TFont Read GetSystemDefaultFont;
         Property FixedFont:TFont Read GetSystemFixedFont;
         Property SmallFont:TFont Read GetSystemSmallFont;
         Property Canvas:TCanvas Read GetCanvas;
         Property MenuFont:TFont Read FMenuFont;
         Property OnActiveFormChange:TNotifyEvent Read FOnActiveFormChange Write FOnActiveFormChange;
         Property OnActiveControlChange:TNotifyEvent Read FOnActiveControlChange Write FOnActiveControlChange;
    End;


    {$HINTS OFF}
    TGraphic=Class(TComponent)
      protected
         FIsLocalCopy:Boolean;
         FOnChangedNotify:TNotifyEvent;
         FOnChange:TNotifyEvent;
         FCreatePalette:Boolean;
      Public
         Procedure Draw(Canvas:TCanvas;Const Dest:TRect);Virtual;Abstract;
         Procedure PartialDraw(Canvas:TCanvas;Const Src,Dest:TRect);Virtual;Abstract;
         Procedure LoadFromFile(Const FileName:String);Virtual;
         Procedure SaveToFile(Const FileName:String);Virtual;
         Procedure LoadFromStream(Stream:TStream);Virtual;Abstract;
         Procedure SaveToStream(Stream:TStream);Virtual;Abstract;
         Function CopyGraphic:TGraphic;Virtual;Abstract;
         Procedure Changed;Virtual;
         Function CreateMask(Color:TColor):TGraphic;Virtual;Abstract;
         Constructor Create;Virtual;
         Procedure LoadFromHandle(Handle:LongWord);Virtual;Abstract;
         Procedure LoadFromResourceId(Id:LongWord);Virtual;Abstract;
         Procedure LoadFromResourceName(Const Name:String);Virtual;Abstract;
         Procedure LoadFromMem(Var Buf;Size:LongInt);Virtual;Abstract;
      Protected
         Function GetEmpty:Boolean;Virtual;Abstract;
         Function GetHeight:LongInt;Virtual;Abstract;
         Procedure SetHeight(NewHeight:LongInt);Virtual;Abstract;
         Function GetWidth:LongInt;Virtual;Abstract;
         Procedure SetWidth(NewWidth:LongInt);Virtual;Abstract;
         Function GetHandle:LongWord;Virtual;Abstract;
         Function GetCanvas:TCanvas;Virtual;Abstract;
         Function GetSize:LongInt;Virtual;Abstract;
         Function WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceNAme):Boolean;Virtual;Abstract;
         Procedure PaletteChanged;Virtual;Abstract;
         Procedure CreateNew(NewWidth,NewHeight:LongWord;Colors:LongWord);Virtual;Abstract;
      Public
         Property Empty:Boolean Read GetEmpty;
         Property Height:LongInt Read GetHeight Write SetHeight;
         Property Width:LongInt Read GetWidth Write SetWidth;
         Property Handle:LongWord Read GetHandle;
         Property Canvas:TCanvas Read GetCanvas;
         Property Size:LongInt Read GetSize;
         Property CreatePalette:Boolean Read FCreatePalette Write FCreatePalette;
         Property OnChange:TNotifyEvent read FOnChange write FOnChange;
    End;
    {$HINTS ON}
    TGraphicClass=Class Of TGraphic;


    TPalette=Class(TComponent)
      protected
         FHandle:LongWord;
         FCanvas:TCanvas;
      protected
         Function GetColor(Index:LongWord):TColor;
         Procedure SetColor(Index:LongWord;NewColor:TColor);
         Function GetColorCount:LongWord;
         Function GetHandle:LongWord;
      Protected
         Procedure SetupComponent;Override;
      Public
         Function GetColorArray(StartIndex:LongWord;Var ResultArray:Array Of TCoLor):LongWord;
         Procedure SetColorArray(StartIndex:LongWord;Const SourceArray:Array Of Tcolor);
         Procedure CreateNew(Var Colors:Array Of TColor);
         Procedure RealizePalette;
      Public
         Property ColorCount:LongWord Read GetColorCount;
         Property Handle:LongWord Read GetHandle Write FHandle;
         Property Colors[Index:LongWord]:TColor Read GetColor Write SetColor;
         Property Canvas:TCanvas Read FCanvas;
    End;

    TPathClipMode=(paAdd,paSubtract,paReplace,paDiff,paIntersect);

    {$IFDEF OS2}
    {
    Matrix of

    ฺ           ฟ
    ณM11 M12 M13ณ
    ณM21 M22 M23ณ
    ณM31 M32 M33ณ
    ภ           ู

    used for Canvas.Transform.
    }

    TMatrix=Object
       protected
          FMatrix:MATRIXLF;
       protected
          Function GetM11:Extended;
          Procedure SetM11(Const NewValue:Extended);
          Function GetM12:Extended;
          Procedure SetM12(Const NewValue:Extended);
          Function GetM21:Extended;
          Procedure SetM21(Const NewValue:Extended);
          Function GetM22:Extended;
          Procedure SetM22(Const NewValue:Extended);
          Constructor CreateIntern;
       Public
          Constructor CreateEmpty;
          Constructor Create(Const aM11,aM12:Extended;aM13:LongInt;
                             Const aM21,aM22:Extended;aM23:LongInt;
                             Const aM31,aM32,aM33:LongInt);
          Constructor CreateLike(m:TMatrix);
          Constructor CreateTranslation(DeltaX,DeltaY:LongInt);
          Constructor CreateScaling(Const ScalePercentX,ScalePercentY:Extended);
          Constructor CreateVertReflection;
          Constructor CreateHorzReflection;
          Constructor CreateYShear(Const Shear:Extended);
          Constructor CreateXShear(Const Shear:Extended);
          Constructor CreateRotation(Const Degree:Extended);
          Constructor CreateDefault;
          Destructor Destroy;
          Procedure Assign(m:TMatrix);
          Procedure TransformPoint(Var pt:TPoint);
       Public
          Property M11:Extended read GetM11 write SetM11;
          Property M12:Extended read GetM12 write SetM12;
          Property M13:Longint read FMatrix.lM13 write FMatrix.lM13;
          Property M21:Extended read GetM21 write SetM21;
          Property M22:Extended read GetM22 write SetM22;
          Property M23:LongInt read FMatrix.lM23 write FMatrix.lM23;
          Property M31:LongInt read FMatrix.lM31 write FMatrix.lM31;
          Property M32:LongInt read FMatrix.lM32 write FMatrix.lM32;
          Property M33:LongInt read FMatrix.lM33 write FMatrix.lM33;
    End;

    {$M+}
    TTransformMode=(trReplace,trAdd,trPreEmpt);
    TAreaMode=(arNoBoundary,arBoundary,arAlternate,arWinding,
               arNoBoundaryAlternate,arNoBoundaryWinding,
               arBoundaryWinding,arBoundaryAlternate);
    {$M-}
    {$ENDIF}

    TCanvas=Class(TComponent)
      protected
// Uncomment FFontSet in order to trace GPI resources more accurately.
// This is not functionally needed but prevents unnecessary GpiDeleteSetId calls
// which fail and therefore make it more difficult to test for real problems.
// Probably not safe to leave in due to incompatibility between components 
// and IDE  - AaronL
//         FFontSet:boolean;
         FControl:TControl;
         FGraphic:TGraphic;
         {$IFDEF OS2}
         FUsePath:Boolean;
         {$ENDIF}
         {$IFDEF Win32}
         FPenHandle:LongWord;
         FBrushHandle:LongWord;
         FInPath:Boolean;
         {$ENDIF}
         FFont:TFont;
         FFontHandle:LongWord;
         FFontWidth,FFontHeight:LongInt;
         FFontAttr:TFontAttributes;
         FLineWidth:LongInt;
         FLineType:TPenStyle;
         FBackMix:TBrushMode;
         FForeMix:TPenMode;
         FClipRGN:LongWord;
         FClipRect:TRect;
         FHandle:LongWord;
         FPalette:TPalette;
         FBrush:TBrush;
         FPen:TPen;
         FCopyMode:TBitBltMode;
         FNonDisplayDevice:Boolean;
         FOwnerDraw:Boolean;
         Function GetPenPosition:TPoint;
         Procedure SetPenPosition(NewPosition:TPoint);
         Procedure CreateFont(NewFont:TFont;ModifyControlFont:Boolean);
         Procedure SetFont(NewFont:TFont);
         Procedure SetFontHeight(NewHeight:LongInt);
         Function GetFontHeight:LongInt;
         Procedure SetFontWidth(NewWidth:LongInt);
         Function GetFontWidth:LongInt;
         Procedure SetFontAttr(NewAttr:TFontAttributes);
         Function GetFontAttr:TFontAttributes;
         Procedure SetClipRect(Const rec:TRect);
         Function GetPixel(X,Y:LongInt):TColor;
         Procedure SetPixel(X,Y:LongInt;Value:TColor);
         Function GetVerticalRes:LongInt;
         Function GetHorizontalRes:LongInt;
         Procedure SetPen(NewPen:TPen);
         Procedure SetBrush(NewBrush:TBrush);
         Procedure SetPalette(NewPalette:TPalette);
         Function GetPageViewPort:TRect;
         Procedure SetPageViewPort(NewValue:TRect);
         {$IFDEF OS2}
         Procedure SetTransformMatrix(Const m:TMatrix);
         Function GetTransformMatrix:TMatrix;
         Function GetLineColor:TColor;
         Function GetCharColor:TColor;
         Function GetAreaColor:TColor;
         Procedure SetLineColor(NewValue:TColor);
         Procedure SetCharColor(NewValue:TColor);
         Procedure SetAreaColor(NewValue:TColor);
         {$ENDIF}
      Protected
         Procedure SetupComponent;Override;
      Public
         Destructor Destroy;Override;
         Procedure EraseBackGround;Virtual;
         Procedure Init;Virtual;

         {$IFDEF OS2}
         Procedure Transform(m:TMatrix;Mode:TTransformMode);
         Procedure ResetTransform;
         Procedure BeginArea(Mode:TAreaMode);
         Procedure EndArea;
         Procedure PolySpline(aptl:Array Of TPoint);
         {$ENDIF}
         Procedure CreateHandle;Virtual;
         Procedure DestroyHandle;Virtual;
         Procedure FillRect(Const rec:TRect;FillColor:TColor);Virtual;
         Procedure MoveTo(X,Y:LongInt);Virtual;
         Procedure LineTo(X,Y:LongInt);Virtual;
         Procedure Line(X,Y,X1,y1:LongInt);Virtual;
         Procedure PolyLine(Points:Array Of TPoint);Virtual;
         Procedure Polygon(Points:Array Of TPoint);Virtual;
         Procedure ShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
         Procedure RoundShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
         Procedure DrawFocusRect(Const rec:TRect);
         Procedure Rectangle(Const rec:TRect);
         Procedure RoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
         Procedure FilledRoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
         Procedure DrawInvertRect(Const rec:TRect);
         Procedure Box(Const rec:TRect);
         Procedure OutlineBox(Const rec:TRect);
         Procedure Circle(X,Y:LongInt;Radius:LongInt);
         Procedure Arc(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
         Procedure BrushCopy(Const Dest:TRect;Bitmap:TGraphic;
                             Const Source:TRect;Color:TColor);
         Procedure Chord(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAnglE:Extended);
         Procedure Pie(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
         Procedure CopyRect(Const Dest:TRect;Canvas:TCanvas;Const Source:TRect);
         Procedure BezierSpline(X,Y:LongInt;Points:Array Of TPoint);
         Procedure FilledCircle(X,Y:LongInt;Radius:LongInt);
         Procedure Ellipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
         Procedure FilledEllipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
         Procedure DrawString(Const S:String);
         Procedure TextOut(X,Y:LongInt;Const S:String);
         Procedure MnemoTextOut(X,Y:LongInt;Const S:String);
         Procedure Draw(X,Y:LongInt;Graphic:TGraphic);
         Procedure PartialDraw(X,Y:LongInt;Const SourceRec:TRect;Graphic:TGraphic);
         Procedure StretchDraw(X,Y,Width,Height:LongInt;Graphic:TGraphic);
         Procedure StretchPartialDraw(X,Y,Width,Height:LongInt;Const SourceRec:TRect;Graphic:TGraphic);
         Function TextHeight(Const Text:String):LongInt;
         Function TextWidth(Const Text:String):LongInt;
         Procedure TextRect(Const rc:TRect;X,Y:LongInt;Const Text:String);
         Procedure FloodFill(X,Y:LongInt;BorderColor:TColor;FillSurface:Boolean);
         Procedure GetTextExtent(Const S:String;Var Width,Height:LongInt);
         Procedure SetClipRegion(Rects:Array Of TRect);
         Procedure DeleteClipRegion;
         Procedure ExcludeClipRect(Const rec:TRect);
         Procedure BitBlt(DestCanvas:TCanvas;Const Dest,Source:TRect;
                          Mode:TBitBltMode;Flags:TBitBltFlags);
         Procedure BeginPath;
         Procedure EndPath;
         Procedure FillPath;
         Procedure StrokePath;
         Procedure OutlinePath;
         Procedure CloseFigure;
         Procedure PathToClipRegion(Mode:TPathClipMode);
      Public
         Property NonDisplayDevice:Boolean read FNonDisplayDevice write FNonDisplayDevice;
         Property Handle:LongWord Read FHandle Write FHandle;
         Property OwnerDraw:Boolean read FOwnerDraw write FOwnerDraw;
         Property Graphic:TGraphic Read FGraphic;
         Property Control:TControl Read FControl;
         Property PenPos:TPoint Read GetPenPosition Write SetPenPosition;
         Property Font:TFont Read FFont Write SetFont;
         Property FontHeight:LongInt Read GetFontHeight Write SetFontHeight;
         Property FontWidth:LongInt Read GetFontWidth Write SetFontWidth;
         Property FontAttributes:TFontAttributes Read GetFontAttr Write SetFontAttr;
         Property ClipRect:TRect Read FClipRect Write SetClipRect;
         Property Pixels[X,Y:LongInt]:TColor Read GetPixel Write SetPixel;
         Property Palette:TPalette Read FPalette Write SetPalette;
         Property VerticalResolution:LongInt Read GetVerticalRes;
         Property HorizontalResolution:LongInt Read GetHorizontalRes;
         Property Pen:TPen Read FPen Write SetPen;
         Property Brush:TBrush Read FBrush Write SetBrush;
         Property CopyMode:TBitBltMode Read FCopyMode Write FCopyMode;
         Property PageViewPort:TRect read GetPageViewPort write SetPageViewPort;
         {$IFDEF OS2}
         Property TransformMatrix:TMatrix read GetTransformMatrix write SetTransformMatrix;
         Property LineColor:TColor read GetLineColor write SetLineColor;
         Property AreaColor:TColor read GetAreaColor write SetAreaColor;
         Property CharColor:TColor read GetCharColor write SetCharColor;
         {$ENDIF}
    End;


Type
    TPlatform=(OS2Ver20, OS2Ver30, OS2Ver40, Win32);

    THintInfo=Record
         HintControl:TControl;
         HintPos:TPoint;
         HintMaxWidth:LongInt;
         HintColor:TColor;
         HintPenColor:TColor;
         CursorRect:TRect;
         CursorPos:TPoint;
    End;

{$M+}
    TMessageEvent=Procedure(Var Msg:TMessage;Var Handled:Boolean) Of Object;
    TIdleEvent=Procedure(Sender:TObject;Var Done:Boolean) Of Object;
    TExceptionEvent=Procedure(Sender:TObject;E:Exception) Of Object;
    THelpEvent=Procedure(context:THelpContext;Var Result:Boolean) Of Object;
    TShowHintEvent=Procedure(Var HintStr:String;Var CanShow:Boolean;Var HintInfo:THintInfo) Of object;
{$M-}

{$M+}
    THintOrigin=(hiTop,hiBottom);
{$M-}

    THintWindow=Class(TControl)
      Protected
         Procedure SetupComponent;Override;
         {$IFDEF WIN32}
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
         {$ENDIF}
      Public
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ActivateHint(Rect:TRect; Const AHint:String);Virtual;
         Procedure DeactivateHint;Virtual;
         Property Caption;
         Property Color;
         Property PenColor;
    End;

    THintWindowClass=Class Of THintWindow;


Const
    HintWindowClass:THintWindowClass=THintWindow;

Const
    // Change this to specify a form icon resource id
    // If set, overrides Application or Form icon property
    FormIconResourceID: Integer = 0;

Type
    {$HINTS OFF}
    TApplication=Class(TComponent)
      protected
         FMainForm:TForm;
         FShowMainForm:Boolean;
         FIcon:TGraphic;
         FHelpFile:PString;
         FHelpWindowTitle:PString;
         FHelpWindow:HWindow;
         FHintTimer:TTimer;
         FHintControl:TControl;
         FHintParent:TControl;
         FHintOwner:TControl;
         FHintWindow:THintWindow;
         FHint:String;
         FShowHint:Boolean;
         FHintPause:LongInt;
         FHintPenColor:TColor;
         FHintColor:TColor;
         FHintOrigin:THintOrigin;
         FMenuItemList:TList;
         FFont:TFont;
         FPlatform:TPlatform;
         FDBCSSystem:Boolean;
         FHasFocus:Boolean;
         FTerminate:Boolean;
         ExceptObject:Exception;
         FKeysHelpContext:THelpContext;
         FOnHint:TNotifyEvent;
         FOnIdle:TIdleEvent;
         FOnMessage:TMessageEvent;
         FOnMsgEvent:TMessageEvent;
         FOnException:TExceptionEvent;
         FOnHelp:THelpEvent;
         FOnShowHint:TShowHintEvent;
      protected
         Function GetHelpFile:String;
         Procedure SetHelpFile(NewName:String);
         Function GetHelpWindowTitle:String;
         Procedure SetHelpWindowTitle(NewTitle:String);
         Procedure SetHint(Const NewText:String);
         Procedure HintTimerExpired;
         Procedure DestroyHintWindow;
         Function NewMenuItem(entry:TMenuItem):TCommand;
         Procedure DeleteMenuItem(entry:TMenuItem);
         Function GetMenuItem(Command:TCommand):TMenuItem;
         Procedure SetFont(NewFont:TFont);
         Function ProcessMessage:Boolean;
         Procedure Idle;
         Function GetIcon:TGraphic;
         Procedure SetIcon(NewIcon:TGraphic);
         Function GetLanguage:String;
         Procedure SetLanguage(Const NewLanguage:String);
         Function GetExeName:String;
      Protected
         Procedure SetupComponent;Override;
      Public
         Constructor Create;Virtual;
         Destructor Destroy;Override;
         Procedure CreateForm(InstanceClass:TFormClass;Var Reference:TForm);
         Procedure Run;
         Procedure RunFailed;Virtual;
         Procedure ProcessMessages;
         Procedure HandleMessage;
         Procedure Terminate;
         Procedure HandleException(Sender:TObject);
         Procedure ShowException(E:Exception);
         Procedure HelpIndex;
         Procedure HelpOnHelp;
         Procedure HelpContents;
         Procedure KeysHelp;
         Function HelpJump(Const JumpId:String):Boolean;
         Function HelpContext(context:THelpContext):Boolean;
         Function Help(context:THelpContext):Boolean;Virtual;
      Public
         Property Language:String Read GetLanguage Write SetLanguage;
         Property MainForm:TForm Read FMainForm;
         Property HelpFile:String Read GetHelpFile Write SetHelpFile;
         Property HelpWindowTitle:String Read GetHelpWindowTitle Write SetHelpWindowTitle;
         Property HelpWindow:HWindow Read FHelpWindow;
         Property Platform:TPlatform Read FPlatform;
         Property DBCSSystem:Boolean Read FDBCSSystem;
         Property Terminated:Boolean Read FTerminate;
         Property HasFocus:Boolean Read FHasFocus;
         Property ExeName:String Read GetExeName;
         Property Hint:String Read FHint Write SetHint;
         Property ShowHint:Boolean Read FShowHint Write FShowHint;
         Property ShowMainForm:Boolean Read FShowMainForm Write FShowMainForm;
         Property HintPause:LongInt Read FHintPause Write FHintPause;
         Property HintPenColor:TColor Read FHintPenColor Write FHintPenColor;
         Property HintColor:TColor Read FHintColor Write FHintColor;
         Property HintOrigin:THintOrigin Read FHintOrigin Write FHintOrigin;
         Property Font:TFont Read FFont Write SetFont;
         Property Icon:TGraphic Read GetIcon Write SetIcon;
         Property KeysHelpContext:THelpContext read FKeysHelpContext write FKeysHelpContext;
         Property OnHint:TNotifyEvent Read FOnHint Write FOnHint;
         Property OnIdle:TIdleEvent Read FOnIdle Write FOnIdle;
         Property OnMessage:TMessageEvent Read FOnMessage Write FOnMessage;
         Property OnMsgEvent:TMessageEvent read FOnMsgEvent Write FOnMsgEvent;
         Property OnException:TExceptionEvent Read FOnException Write FOnException;
         Property OnHelp:THelpEvent Read FOnHelp Write FOnHelp;
         Property OnShowHint:TShowHintEvent Read FOnShowHint Write FOnShowHint;
    End;
    {$HINTS ON}

Type
    TCompLibData=Record
         NewHeapOrg,NewHeapEnd,NewHeapPtr:Pointer;
         NewHeapSize:LongWord;
         NewLastHeapPage,NewLastHeapPageAdr:Pointer;
         NewHeapMutex:LongWord;
         InsideWriteSCUAdr:Pointer;
         Screen:TScreen;
         Application:TApplication;
         Clipboard:TClipBoard;
         ToolsAPI:TObject;
         ToolsAPIRequired:Boolean;
         NullStr:PString;
    End;


Function Point(X,Y:LongInt):TPoint;
Function Rect(Left,Bottom,Right,Top:LongInt):TRect;
Function PointInRect(pt:TPoint; rec:TRect):Boolean;
Function RectInRect(Const childrec,parentrec:TRect):Boolean;
Procedure InflateRect(Var rec:TRect; X,Y:LongInt);
Procedure OffsetRect(Var rec:TRect; X,Y:LongInt);
Function IntersectRect(Const rec1,rec2:TRect):TRect;
Function UnionRect(Const rec1,rec2:TRect):TRect;
Function IsRectEmpty(Const rec:TRect):Boolean;

Function SendMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):LONG;
Function PostMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):BOOL;
Function HandleToControl(ahwnd:HWindow):TControl;
Function OppositeRGB(color:TColor):TColor;
Function ValuesToRGB(Red,Green,Blue:Byte):TColor;
Function RGBToValues(color:TColor;Var Red,Green,Blue:Byte):TColor;
Function SysColorToRGB(color:TColor):TColor;
Function WinColorToRGB(color:TColor):TColor;
Function RGBToWinColor(color:TColor):TColor;
Function GetShortHint(Const Hint:String):String;
Function GetLongHint(Const Hint:String):String;
Function IsControlLocked(Control:TControl):Boolean;
Function GetParentForm(Control:TControl):TForm;

Function ReadSCUFont(Var Data;DataLen:LongInt):TFont;
Procedure DereferenceFont( Var FFont:TFont );
Procedure ReferenceFont( Var FFont:TFont );

Procedure DrawSystemBorder(Control:TControl;Var rec:TRect;Style:TBorderStyle);
Procedure DrawSystemFrame(Control:TControl;Var rec:TRect;LightColor,DarkColor:TCoLor);


Procedure TransformPointToOS2(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Procedure TransformRectToOS2(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Procedure TransformPointToWin32(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Procedure TransformRectToWin32(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Procedure TransformClientPoint(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Procedure TransformClientRect(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Procedure MapDialogPoints(SourceWindow:HWindow;Var ptl:TPoint);
Procedure RectToWin32Rect(Var rec:TRect);
Procedure Win32RectToRect(Var rec:TRect);
Function ptInRect(Const rc:TRect;Const pt:TPoint):Boolean;

Function GetBorderWidth(Form:TForm):LongInt;
Function GetBorderHeight(Form:TForm):LongInt;

{$IFDEF OS2}
Function IsDBCSFirstByte(CH:Char):Boolean;
{$ENDIF}

Var
   Screen:TScreen;
   Clipboard:TClipBoard;
   Application:TApplication;

Const
   {$IFDEF OS2}
   MnemoChar:Char='~';
   {$ENDIF}
   {$IFDEF Win32}
   MnemoChar:Char='&';
   {$ENDIF}

Function ReplaceMnemo(Const MnemoString:String):String;

Const
   RegisterToolsAPIProc:Procedure(ToolServ:TObject)=Nil;

{internal}
Procedure SetupCompLib(Var Data:TCompLibData);
Procedure RegisterAutomaticForm(FormClass:TFormClass;address:Pointer);
Procedure SetControlHandle(Control:TControl;Handle:HWND);
Procedure SetDefWndProc(Control:TControl;Proc:Pointer);
{$IFDEF OS2}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
{$ENDIF}
{$IFDEF Win32}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;APIENTRY;
{$ENDIF}

{$IFDEF OS2}
//operator overloads for TMatrix
Function MulMatrix(Const a,b:TMatrix):TMatrix; operator *;
Function AddMatrix(Const a,b:TMatrix):TMatrix; operator +;
Function SubMatrix(Const a,b:TMatrix):TMatrix; operator -;
Function MulMatrixInt1(Const a:TMatrix;b:LongInt):TMatrix; operator *;
Function MulMatrixExt1(Const a:TMatrix;Const b:Extended):TMatrix; operator *;
Function MulMatrixInt2(b:LongInt;Const a:TMatrix):TMatrix; operator *;
Function MulMatrixExt2(Const b:Extended;Const a:TMatrix):TMatrix; operator *;
{$ENDIF}

Var
  NewStyleControls: Boolean;

Const
  InsideDesigner: Boolean = false;

Implementation

{$R Cursors}
{$I SPCC.Inc}

{$IFDEF OS2}

Uses  PmShl;

Const
     // This prefix is used when registering window classes
     // the final window class name is this plus the Sibyl class name
     WindowClassPrefix = 'Sibyl ';

     // handle to global form icon - AaronL
     hFormIcon: HPOINTER = NULLHANDLE;
     TriedLoadingFormIcon: boolean = false;

Function MulMatrix(Const a,b:TMatrix):TMatrix; //operator *;
Begin
     Result.CreateIntern;
     Result.M11:=a.M11*b.M11+a.M12*b.M21+a.M13*b.M31;
     Result.M21:=a.M21*b.M11+a.M22*b.M21+a.M23*b.M31;
     Result.M31:=Round(a.M31*b.M11+a.M32*b.M21+a.M33*b.M31);

     Result.M12:=a.M11*b.M12+a.M12*b.M22+a.M13*b.M32;
     Result.M22:=a.M21*b.M12+a.M22*b.M22+a.M23*b.M32;
     Result.M32:=Round(a.M31*b.M12+a.M32*b.M22+a.M33*b.M32);

     Result.M13:=Round(a.M11*b.M13+a.M12*b.M23+a.M13*b.M33);
     Result.M23:=Round(a.M21*b.M13+a.M22*b.M23+a.M23*b.M33);
     Result.M33:=Round(a.M31*b.M13+a.M32*b.M23+a.M33*b.M33);
End;

Function AddMatrix(Const a,b:TMatrix):TMatrix; //operator +;
Begin
     Result.CreateIntern;
     Result.M11:=a.M11+b.M11;
     Result.M12:=a.M12+b.M12;
     Result.M13:=a.M13+b.M13;
     Result.M21:=a.M21+b.M21;
     Result.M22:=a.M22+b.M22;
     Result.M23:=a.M23+b.M23;
     Result.M31:=a.M31+b.M31;
     Result.M32:=a.M32+b.M32;
     Result.M33:=a.M33+b.M33;
End;

Function SubMatrix(Const a,b:TMatrix):TMatrix; //operator -;
Begin
     Result.CreateIntern;
     Result.M11:=a.M11-b.M11;
     Result.M12:=a.M12-b.M12;
     Result.M13:=a.M13-b.M13;
     Result.M21:=a.M21-b.M21;
     Result.M22:=a.M22-b.M22;
     Result.M23:=a.M23-b.M23;
     Result.M31:=a.M31-b.M31;
     Result.M32:=a.M32-b.M32;
     Result.M33:=a.M33-b.M33;
End;

Function MulMatrixInt1(Const a:TMatrix;b:LongInt):TMatrix; //operator *;
Begin
     Result:=MulMatrixExt1(a,b);
End;

Function MulMatrixExt1(Const a:TMatrix;Const b:Extended):TMatrix; //operator *;
Begin
     Result.CreateIntern;
     Result.M11:=a.M11*b;
     Result.M12:=a.M12*b;
     Result.M13:=Round(a.M13*b);
     Result.M21:=a.M21*b;
     Result.M22:=a.M22*b;
     Result.M23:=Round(a.M23*b);
     Result.M31:=Round(a.M31*b);
     Result.M32:=Round(a.M32*b);
     Result.M33:=Round(a.M33*b);
End;

Function MulMatrixInt2(b:LongInt;Const a:TMatrix):TMatrix; //operator *;
Begin
     Result:=MulMatrixExt1(a,b);
End;

Function MulMatrixExt2(Const b:Extended;Const a:TMatrix):TMatrix; //operator *;
Begin
     Result:=MulMatrixExt1(a,b);
End;
{$ENDIF}

Function GetTopBottomHeight(Form:TForm):LongInt;
Var T:LongInt;
    List:TList;
    Toolbar:TToolbar;
Begin
     Result:=0;

     List:=Form.FToolBarLists[tbTop];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;

     List:=Form.FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;
End;

Function GetLeftRightWidth(Form:TForm):LongInt;
Var T:LongInt;
    List:TList;
    Toolbar:TToolbar;
Begin
     Result:=0;

     List:=Form.FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;

     List:=Form.FToolBarLists[tbRight];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
     End;
End;


Type
    TFrameControl=Class(TControl)
      protected
         FResourceId:LongWord;
         FResourceModule:LongWord;
         FChild:TForm;
         {$IFDEF OS2}
         Procedure WMActivate(Var Msg:TWMActivate); Message WM_ACTIVATE;
         Procedure WMFormatFrame(Var Msg:TMessage); Message WM_FORMATFRAME;
         Procedure WMQueryFrameCtlCount(Var Msg:TMessage); Message WM_QUERYFRAMECTlcOUNt;
         Procedure WMCalcFrameRect(Var Msg:TMessage); Message WM_CALCFRAMERECT;
         Procedure WMQueryTrackInfo(Var Msg:TMessage); Message WM_QUERYTRACKINFO;
         Procedure WMMinMaxFrame(Var Msg:TMessage); Message WM_MINMAXFRAME;
         {$ENDIF}
         {$IFDEF Win32}
         Procedure WMClose(Var Msg:TWMClose); Message WM_CLOSE;
         Procedure WMChildActivate(Var Msg:TMessage); Message WM_CHILDACTIVATE;
         Procedure WMInitMenuPopup(Var Msg:TMessage); Message WM_INITMENUPOPUP;
         Procedure WMMenuSelect(Var Msg:TMessage); Message WM_MENUSELECT;
         Procedure WMMenuChar(Var Msg:TMessage); Message WM_MENUCHAR;
         Procedure WMGetMinMaxInfo(Var Msg:TMessage); Message WM_GETMINMAXINFO;
         Procedure WMSysCommand(Var Msg:TMessage); Message WM_SYSCOMMAND;
         {$ENDIF}
         Procedure SetResourceId(NewId:LongWord);
         Procedure GetClassData(Var ClassData:TClassData);Override;
         Function GetClientRect:TRect;Override;
      Protected
         Procedure SetupComponent;Override;
         Procedure CreateParams(Var Params:TCreateParams);Override;
         Procedure CreateWnd;Override;
      Public
         Destructor Destroy;Override;
         Property ResourceId:LongWord Read FResourceId Write SetResourceId; {?}
         Property Child:TForm Read FChild;
    End;

////////////////////////////////////////////////////////////////////////////

Const
     {$IFDEF OS2}
     widClient = FID_CLIENT;
     {$ENDIF}
     {$IFDEF Win32}
     widClient = 1;
     {$ENDIF}

     cmInternalControlBase   = $9000;
     cmInternalMenuItemBase  = $1000;

     DBCSStatusLineHeight:LongInt = 0;
     ExternalDragDropObject:TExternalDragDropObject = Nil;


Function GetBorderWidth(Form:TForm):LongInt;
Begin
     Result := 0;
     If Form = Nil Then exit;
     If Not Form.Designed Then
     Begin
          Case Form.FBorderStyle Of
            bsSingle:   Result := Screen.SystemMetrics(smCxBorder);
            bsSizeable: Result := Screen.SystemMetrics(smCxSizeBorder);
            bsDialog:   Result := Screen.SystemMetrics(smCxDlgBorder);
          End;
     End
     Else Result := Screen.SystemMetrics(smCxSizeBorder);
End;


Function GetBorderHeight(Form:TForm):LongInt;
Begin
     Result := 0;
     If Form = Nil Then exit;
     If Not Form.Designed Then
     Begin
          Case Form.FBorderStyle Of
            bsSingle:   Result := Screen.SystemMetrics(smCyBorder);
            bsSizeable: Result := Screen.SystemMetrics(smCySizeBorder);
            bsDialog:   Result := Screen.SystemMetrics(smCyDlgBorder);
          End;
     End
     Else Result := Screen.SystemMetrics(smCySizeBorder);
End;



{$HINTS OFF}
Procedure TransformPointToOS2(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
     {$IFDEF Win32}
     If Control <> Nil Then
     Begin
          OwnerHeight := Control.FHeight;
          If Control Is TFrameControl Then
          Begin
               Dec(OwnerHeight, Screen.SystemMetrics(smCyTitlebar));
               Dec(OwnerHeight, GetBorderHeight(Control.FForm));
               Inc(pt.Y, GetBorderWidth(Control.FForm));
//               Dec(OwnerHeight, GetBorderHeight(Control.FForm));
          End;
     End
     Else If Graphic <> Nil Then OwnerHeight := Graphic.Height
     Else OwnerHeight := Screen.Height;
     pt.Y := (OwnerHeight-pt.Y);
     {$ENDIF}
End;


Procedure TransformRectToOS2(Var rec:TRect;Control:TControl;Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
     {$IFDEF Win32}
     If Control <> Nil Then
     Begin
          OwnerHeight := Control.FHeight;
          If Control Is TFrameControl Then
          Begin
               Dec(OwnerHeight, Screen.SystemMetrics(smCyTitlebar));
               Dec(OwnerHeight, GetBorderHeight(Control.FForm));
               Inc(rec.Left, GetBorderWidth(Control.FForm));
               Inc(rec.Right, GetBorderWidth(Control.FForm));
               {???}
               Dec(OwnerHeight, GetBorderHeight(Control.FForm));
          End;
     End
     Else If Graphic <> Nil Then OwnerHeight := Graphic.Height
     Else OwnerHeight := Screen.Height;
     rec.Bottom := (OwnerHeight-rec.Bottom);
     rec.Top := (OwnerHeight-rec.Top);
     {$ENDIF}
End;


Procedure TransformPointToWin32(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
Begin
     {$IFDEF Win32}
     TransformPointToOS2(pt,Control,Graphic);
     {$ENDIF}
End;

Procedure TransformRectToWin32(Var rec:TRect;Control:TControl;Graphic:TGraphic);
Begin
     {$IFDEF Win32}
     TransformRectToOS2(rec,Control,Graphic);
     {$ENDIF}
End;

Procedure TransformClientPoint(Var pt:TPoint;Control:TControl;Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
     {$IFDEF Win32}
     If Control <> Nil Then OwnerHeight := Control.FHeight
     Else If Graphic<>Nil Then OwnerHeight:=Graphic.Height
     Else OwnerHeight := Screen.Height;
     Dec(OwnerHeight);              {!}
     pt.Y:=(OwnerHeight-pt.Y);
     {$ENDIF}
End;

Procedure TransformClientRect(Var rec:TRect;Control:TControl;Graphic:TGraphic);
{$IFDEF Win32}
Var  OwnerHeight:LongInt;
{$ENDIF}
Begin
     {$IFDEF Win32}
     If Control <> Nil Then OwnerHeight := Control.FHeight
     Else If Graphic<>Nil Then OwnerHeight:=Graphic.Height
     Else OwnerHeight := Screen.Height;
     Dec(OwnerHeight);              {!}
     rec.Bottom:=(OwnerHeight-rec.Bottom);
     rec.Top:=(OwnerHeight-rec.Top);
     {$ENDIF}
End;


Procedure MapDialogPoints(SourceWindow:HWindow;Var ptl:TPoint);
Begin
     {$IFDEF OS2}
     WinMapDlgPoints(SourceWindow,POINTL(ptl),1,False);
     {$ENDIF}
End;

Function ptInRect(Const rc:TRect;Const pt:TPoint):Boolean;
Begin
     Result:=((pt.X>=rc.Left)And(pt.X<=rc.Top)And(pt.Y>=rc.Bottom)And(pt.Y<=rc.Top));
End;

Procedure RectToWin32Rect(Var rec:TRect);
{$IFDEF Win32}
Var  L:LongInt;
{$ENDIF}
Begin
     {$IFDEF Win32}
     L := rec.Top;
     rec.Top := rec.Bottom;
     rec.Bottom := L;
     {$ENDIF}
End;

Procedure Win32RectToRect(Var rec:TRect);
Begin
     {$IFDEF Win32}
     RectToWin32Rect(rec);
     {$ENDIF}
End;
{$HINTS ON}


Function SendMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):LONG;
Begin
     {$IFDEF OS2}
     Result := WinSendMsg(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
     {$IFDEF Win32}
     Result := SendMessage(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
End;

Function PostMsg(ahwnd:HWindow;Msg:ULONG;mp1,mp2:LONG):BOOL;
Begin
     {$IFDEF OS2}
     Result := WinPostMsg(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
     {$IFDEF Win32}
     Result := PostMessage(ahwnd,Msg,mp1,mp2);
     {$ENDIF}
End;


Function HandleToControl(ahwnd:HWindow):TControl;
{$IFDEF WIN32}
Var p:Pointer;
{$ENDIF}
Begin
     Result := Nil;
     {$IFDEF OS2}
     If ahwnd <> 0 Then Result := Pointer(WinQueryWindowULong(ahwnd,QWL_USER));
     {$ENDIF}
     {$IFDEF Win32}
     P:=Pointer(GetWindowLong(ahwnd,GWL_WNDPROC));
     If P<>@SubclassedWndProc Then Exit; //no Sibyl Window
     If ahwnd <> 0 Then Result := Pointer(GetWindowLong(ahwnd,GWL_USERDATA));
     {$ENDIF}
End;


Function GetParentForm(Control:TControl):TForm;
Begin
     Result := TForm(Control);
     While Result <> Nil Do
     Begin
          If Result Is TForm Then Exit;
          Result := TForm(Result.Parent);

          If TControl(Result) Is TFrameControl
          Then Result := TFrameControl(Result).FChild;
     End;
     Result := Nil;
End;


Procedure ListAdd(Var List:TList; Item:Pointer);
Begin
     If List = Nil Then List.Create;
     If List.IndexOf(Item) < 0 Then List.Add(Item);
End;


Procedure ListInsert(Var List:TList; Index:LongInt; Item:Pointer);
Begin
     If List = Nil Then List.Create;
     If List.IndexOf(Item) < 0 Then List.Insert(Index,Item);
End;


Procedure ListRemove(Var List:TList; Item:Pointer);
Begin
     If List <> Nil Then
     Begin
          List.Remove(Item);
          If List.Count = 0 Then
          Begin
               List.Destroy;
               List := Nil;
          End;
     End;
End;


Function ListFind(List:TList; Item:Pointer):LongInt;
Begin
     Result := -1;
     If List = Nil Then Exit;
     Result := List.IndexOf(Item);
End;

{$IFDEF OS2}
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMatrix Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TMatrix.GetM11:Extended;
Begin
     Result:=FMatrix.fxM11/65536.0;
End;

Procedure TMatrix.SetM11(Const NewValue:Extended);
Begin
     FMatrix.fxM11:=Round(65536*NewValue);
End;

Function TMatrix.GetM12:Extended;
Begin
     Result:=FMatrix.fxM12/65536.0;
End;

Procedure TMatrix.SetM12(Const NewValue:Extended);
Begin
     FMatrix.fxM12:=Round(65536*NewValue);
End;

Function TMatrix.GetM21:Extended;
Begin
     Result:=FMatrix.fxM21/65536.0;
End;

Procedure TMatrix.SetM21(Const NewValue:Extended);
Begin
     FMatrix.fxM21:=Round(65536*NewValue);
End;

Function TMatrix.GetM22:Extended;
Begin
     Result:=FMatrix.fxM22/65536.0;
End;

Procedure TMatrix.SetM22(Const NewValue:Extended);
Begin
     FMatrix.fxM22:=Round(65536*NewValue);
End;

Constructor TMatrix.Create(Const aM11,aM12:Extended;aM13:LongInt;
                           Const aM21,aM22:Extended;aM23:LongInt;
                           Const aM31,aM32,aM33:LongInt);
Begin
     M11:=aM11;
     M12:=aM12;
     M13:=aM13;
     M21:=aM21;
     M22:=aM22;
     M23:=aM23;
     M31:=aM31;
     M32:=aM32;
     M33:=aM33;
End;

Constructor TMatrix.CreateIntern;
Begin
End;

Constructor TMatrix.CreateEmpty;
Begin
     M11:=0.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=0.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=0;
End;

Constructor TMatrix.CreateDefault;
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=0;
End;

Constructor TMatrix.CreateLike(m:TMatrix);
Begin
     Assign(m);
End;

Constructor TMatrix.CreateTranslation(DeltaX,DeltaY:LongInt);
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=DeltaX;
     M32:=DeltaY;
     M33:=1;
End;

Constructor TMatrix.CreateScaling(Const ScalePercentX,ScalePercentY:Extended);
Begin
     M11:=ScalePercentX/100;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=ScalePercentY/100;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateVertReflection;
Begin
     M11:=-1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateHorzReflection;
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=0.0;
     M22:=-1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateYShear(Const Shear:Extended);
Begin
     M11:=1.0;
     M12:=Shear;
     M13:=0;
     M21:=0.0;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateXShear(Const Shear:Extended);
Begin
     M11:=1.0;
     M12:=0.0;
     M13:=0;
     M21:=Shear;
     M22:=1.0;
     M23:=0;
     M31:=0;
     M32:=0;
     M33:=1;
End;

Constructor TMatrix.CreateRotation(Const Degree:Extended);
Begin
     SetTrigMode(Deg);
     M11:=Cos(Degree);
     M12:=Sin(Degree);
     M13:=0;
     M21:=-Sin(Degree);
     M22:=Cos(Degree);
     M23:=0;
     m31:=0;
     m32:=0;
     m33:=1;
End;

Destructor TMatrix.Destroy;
Begin
End;

Procedure TMatrix.Assign(m:TMatrix);
Begin
     FMatrix:=m.FMatrix;
End;

Procedure TMatrix.TransformPoint(Var pt:TPoint);
Var Result:TPoint;
Begin
     Result.X:=Round(M11*pt.X+M21*pt.Y+M31);
     Result.Y:=Round(M12*pt.X+M22*pt.Y+M32);
     pt:=Result;
End;
{$ENDIF}

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TLastMsg Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function GetLastMsgAdr(Control:TControl):PMessage;
Begin
     Result:=Control.FLastMsgAdr;
End;

Function TLastMsg.GetHandled:LongBool;
Begin
     If FControl.FLastMsgAdr <> Nil Then Result := FControl.FLastMsgAdr^.Handled
     Else Result := False;
End;

Procedure TLastMsg.SetHandled(Value:LongBool);
Begin
     If FControl.FLastMsgAdr <> Nil Then FControl.FLastMsgAdr^.Handled := Value;
End;

Function TLastMsg.GetResult:LongWord;
Begin
     If FControl.FLastMsgAdr <> Nil Then Result := FControl.FLastMsgAdr^.Result
     Else Result := 0;
End;

Procedure TLastMsg.SetResult(Value:LongWord);
Begin
     If FControl.FLastMsgAdr <> Nil Then FControl.FLastMsgAdr^.Result := Value;
End;

Procedure TLastMsg.CallDefaultHandler;
Begin
     If FControl.FLastMsgAdr <> Nil
     Then FControl.DefaultHandler(FControl.FLastMsgAdr^);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TClipBoard Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function TClipBoard.GetOwner:HWindow;
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdOwner(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetClipboardOwner;
     {$ENDIF}
End;

Function TClipBoard.GetViewer:HWindow;
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdViewer(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetClipboardViewer;
     {$ENDIF}
End;

Procedure TClipBoard.SetViewer(Viewer:HWindow);
Begin
     {$IFDEF OS2}
     WinSetClipbrdViewer(AppHandle,Viewer);
     {$ENDIF}
     {$IFDEF Win32}
     SetClipboardViewer(Viewer);
     {$ENDIF}
End;


Function TClipBoard.Open(ahwnd:HWindow):Boolean;
Begin
     FOpenWin := ahwnd;
     {$IFDEF OS2}
     Result := WinOpenClipbrd(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := OpenClipboard(FOpenWin);
     {$ENDIF}
End;


Function TClipBoard.Close:Boolean;
Begin
     {$IFDEF OS2}
     Result := WinCloseClipbrd(AppHandle);
     {$ENDIF}
     {$IFDEF Win32}
     Result := CloseClipboard;
     {$ENDIF}
End;


Function TClipBoard.Empty:Boolean;
Begin
     {$IFDEF OS2}
     Result := WinEmptyClipbrd(AppHandle);
     If FOpenWin<>0 Then WinSetClipbrdOwner(AppHandle,FOpenWin);
     {$ENDIF}
     {$IFDEF Win32}
     Result := EmptyClipboard;
     {$ENDIF}
End;

Function TClipBoard.GetFormatCount:LongInt;
Begin
     Result:=CountFormats;
End;

Function TClipBoard.GetFormats(Index:LongInt):LongWord;
Begin
     Result:=EnumFormats(Index);
End;

Function TClipBoard.GetAsText:AnsiString;
Var p:PChar;
Begin
     p:=Pointer(GetData(cfText));
     If p=Nil Then Result:=''
     Else Result:=p^;
End;

Procedure TClipBoard.SetAsText(NewValue:AnsiString);
Begin
     SetTextBuf(PChar(NewValue));
End;

Procedure TClipBoard.SetTextBuf(Buffer:PChar);
Var Temp:PChar;
Begin
     If Buffer=Nil Then Empty
     Else
     Begin
          {$IFDEF OS2}
          DosAllocSharedMem(Temp,Nil,length(Buffer^)+1,PAG_COMMIT Or PAG_READ Or
                            PAG_WRITE Or OBJ_TILE Or OBJ_GIVEABLE);
          {$ENDIF}
          {$IFDEF WIN32}
          GetMem(Temp,length(Buffer^)+1);
          {$ENDIF}
          System.Move(Buffer^,Temp^,length(Buffer^)+1);
          SetData(LongWord(Temp),cfText);
     End;
End;

Function TClipBoard.HasFormat(Format:LongWord):Boolean;
Begin
     Result:=IsFormatAvailable(Format);
End;

Procedure TClipBoard.Clear;
Begin
     Empty;
End;

Function TClipBoard.SetData(Data,format:LongWord):Boolean;
{$IFDEF OS2}
Var  formatinfo:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If format In [cfBitmap,cfMetaFile,cfPalette,cfDspBitmap,cfDspMetaFile]
     Then formatinfo := CFI_HANDLE
     Else formatinfo := CFI_POINTER;
     Result := WinSetClipbrdData(AppHandle,Data,format,formatinfo);
     {$ENDIF}
     {$IFDEF Win32}
     Result := SetClipboardData(format,Data) <> 0;
     {$ENDIF}
End;


Function TClipBoard.GetData(format:LongWord):LongWord;
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdData(AppHandle,format);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetClipboardData(format);
     {$ENDIF}
End;


Function TClipBoard.CountFormats:LongInt;
{$IFDEF OS2}
Var  ulNext:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result := 0;
     ulNext := WinEnumClipbrdFmts(AppHandle,0);
     While ulNext <> 0 Do
     Begin
          Inc(Result);
          ulNext := WinEnumClipbrdFmts(AppHandle,ulNext);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Result := CountClipboardFormats;
     {$ENDIF}
End;


Function TClipBoard.EnumFormats(FormatIndex:LongWord):LongWord;
Begin
     {$IFDEF OS2}
     Result := WinEnumClipbrdFmts(AppHandle,FormatIndex);
     {$ENDIF}
     {$IFDEF Win32}
     Result := EnumClipboardFormats(FormatIndex);
     {$ENDIF}
End;


Function TClipBoard.IsFormatAvailable(format:LongWord):Boolean;
{$IFDEF OS2}
Var  formatinfo:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result := WinQueryClipbrdFmtInfo(AppHandle,format,formatinfo);
     {$ENDIF}
     {$IFDEF Win32}
     Result := IsClipboardFormatAvailable(format);
     {$ENDIF}
End;


Function TClipBoard.RegisterFormat(Const S:String):LongWord;
Var  CS:Cstring;
Begin
     CS := S;
     {$IFDEF OS2}
     Result := WinAddAtom(WinQuerySystemAtomTable,CS);
     {$ENDIF}
     {$IFDEF Win32}
     Result := RegisterClipboardFormat(CS);
     {$ENDIF}
End;


Function TClipBoard.GetFormatName(format:LongWord):String;
Var  L:LongInt;
     CS:Cstring;
Begin
     {$IFDEF OS2}
     L := WinQueryAtomName(WinQuerySystemAtomTable,format,CS,SizeOf(CS));
     {$ENDIF}
     {$IFDEF Win32}
     L := GetClipboardFormatName(format,CS,SizeOf(CS));
     {$ENDIF}
     If L = 0 Then
       If IsFormatAvailable(format) Then CS := '#'+tostr(format);
     Result := CS;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TTimer Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type PTimerArray=^TTimerArray;
     TTimerArray=Array[1..4000] Of Boolean;

Var TimerList:TList;
    TimerArray:PTimerArray;
    TimerMutex:LongWord;
    TimerWindow:HWindow;


Procedure TTimer.SetupComponent;
Var  Id:LongInt;
Begin
     Inherited SetupComponent;

     {$IFDEF OS2}
     DosRequestMutexSem(TimerMutex,-1);
     {$ENDIF}
     {$IFDEF Win32}
     WaitForSingleObject(TimerMutex,$FFFFFFFF);
     {$ENDIF}

     TimerList.Add(Self);
     Asm
        MOV ECX,3999
        STD
        MOV EDI,Forms.TimerArray
        ADD EDI,ECX
        MOV AL,0
        REPNE
        SCASB
        ADD ECX,2
        MOV Id,ECX
     End;
     If Id=0 Then Raise EProcessTerm.Create(LoadNLSStr(SNoMoreTimers));

     FId:=Id;
     TimerArray^[Id]:=True;

     {$IFDEF Win32}
     ReleaseMutex(TimerMutex);
     {$ENDIF}
     {$IFDEF OS2}
     DosReleaseMutexSem(TimerMutex);
     {$ENDIF}

     FRunning:=False;
     FInterval:=100;
     FTime:=0;
     Name:='Timer';
End;


Destructor TTimer.Destroy;
Begin
     Stop;

     {$IFDEF OS2}
     DosRequestMutexSem(TimerMutex,-1);
     {$ENDIF}
     {$IFDEF Win32}
     WaitForSingleObject(TimerMutex,$FFFFFFFF);
     {$ENDIF}

     TimerList.Remove(Self);
     If TimerArray^[FId]<>True
     Then Raise EProcessTerm.Create(LoadNLSStr(SCouldNotRemoveTimer)+':'+tostr(FID));
     TimerArray^[FId]:=False;

     {$IFDEF Win32}
     ReleaseMutex(TimerMutex);
     {$ENDIF}
     {$IFDEF OS2}
     DosReleaseMutexSem(TimerMutex);
     {$ENDIF}

     Inherited Destroy;
End;


Procedure TTimer.Stop;
Begin
     If Not FRunning Then Exit;

     {$IFDEF OS2}
     WinStopTimer(AppHandle,TimerWindow,FId);
     {$ENDIF}
     {$IFDEF Win32}
     KillTimer(TimerWindow,FId);
     {$ENDIF}

     FRunning := False;
End;


Procedure TTimer.Start;
Begin
     If FRunning Then Exit;

     FTime := 0;

     {$IFDEF OS2}
     WinStartTimer(AppHandle,TimerWindow,FId,FInterval);
     {$ENDIF}
     {$IFDEF Win32}
     SetTimer(TimerWindow,FId,FInterval,Nil);
     {$ENDIF}

     FRunning := True;
End;


Procedure TTimer.Timer;
Begin
     If OnTimer<>Nil Then OnTimer(Self);
End;



{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCaret Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TCaret.Create(Owner:TControl);
Begin
     Inherited Create;
     FControl := Owner;
End;


Procedure TCaret.SetPos(Left,Bottom:LongInt);
{$IFDEF Win32}
Var pt:WinDef.Point;
{$ENDIF}
Begin
     Hide;
     {$IFDEF OS2}
     If FControl.Handle <> 0
     Then WinCreateCursor(FControl.Handle,Left,Bottom,FWidth,FHeight,
                          CURSOR_SETPOS Or CURSOR_FLASH,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     pt.X := Left;
     pt.Y := Bottom;
     TransformClientPoint(pt,FControl,Nil);
     Dec(pt.Y,FHeight-1);
     SetCaretPos(pt.X,pt.Y);
     {$ENDIF}
     FLeft := Left;
     FBottom := Bottom;
     Show;
End;


Procedure TCaret.SetSize(Width,Height:LongInt);
Begin
     If FControl.Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinCreateCursor(FControl.Handle,FLeft,FBottom,Width,Height,
                          CURSOR_SOLID Or CURSOR_FLASH,Nil);
          {$ENDIF}
          {$IFDEF Win32}
          CreateCaret(FControl.Handle,0,Width,Height);
          {$ENDIF}
     End;
     FCreated := True;
     FWidth := Width;
     FHeight := Height;
End;


Procedure TCaret.Show;
Begin
     If FControl.Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinShowCursor(FControl.Handle,True);
     {$ENDIF}
     {$IFDEF Win32}
     ShowCaret(FControl.Handle);
     {$ENDIF}
End;


Procedure TCaret.Hide;
Begin
     If FControl.Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinShowCursor(FControl.Handle,False);
     {$ENDIF}
     {$IFDEF Win32}
     HideCaret(FControl.Handle);
     {$ENDIF}
End;


Procedure TCaret.Remove;
Begin
     Hide;
     {$IFDEF OS2}
     If FCreated Then
       If FControl.Handle <> 0 Then WinDestroyCursor(FControl.Handle);
     {$ENDIF}
     {$IFDEF Win32}
     If FCreated Then DestroyCaret;
     {$ENDIF}
     FCreated := False;
End;


Procedure TCaret.SetBlinkTime(ms:LongInt);
Begin
     If ms <= 0 Then {restore original BlinkTime}
     Begin
          {$IFDEF Win32}
          If FOldBlinkTime <> 0 Then SetCaretBlinkTime(FOldBlinkTime);
          FOldBlinkTime := 0;
          {$ENDIF}
          Exit;
     End;

     FBlinkTime := ms;
     {$IFDEF OS2}
     If FControl.Handle <> 0
     Then WinStartTimer(AppHandle,FControl.Handle,TID_CURSOR,FBlinkTime);
     {$ENDIF}
     {$IFDEF Win32}
     If FOldBlinkTime = 0 Then FOldBlinkTime := GetCaretBlinkTime;
     SetCaretBlinkTime(FBlinkTime);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMenuItem Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Const
    MenuIDEEditStr     = '..........';


{$IFDEF OS2}
Function SubclassedMenuItemWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
Var  Menu:TMenuItem;
     aMsg:TMessage;
     Handled:Boolean;
Begin
     Menu:=Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}
     If Menu=Nil Then Exit;
     aMsg.Receiver:=Win;
     aMsg.ReceiverClass:=Menu;
     aMsg.Msg:=Msg;
     aMsg.Param1:=para1;
     aMsg.Param2:=para2;
     aMsg.Handled:=False;

     If ((Application<>Nil)And(Application.FOnMsgEvent<>Nil)) Then
     Begin
          Handled:=False;
          Application.FOnMsgEvent(aMsg,Handled);
          aMsg.Handled:=aMsg.Handled Or Handled;
     End;

     If not aMsg.Handled Then Menu.Dispatch(aMsg);
     If Not aMsg.Handled
     Then aMsg.Result:=Menu.FDefWndProc(aMsg.Receiver,aMsg.Msg,
                                        aMsg.Param1,aMsg.Param2);
     Result:=aMsg.Result;
End;
{$ENDIF}

{$IFDEF Win32}
Type
    PMenuHandleItem=^TMenuHandleItem;
    TMenuHandleItem=Record
         FObject:TComponent;
         FHandle:HWindow;
    End;


Procedure NewMenuHandleItem(AOwner:TForm;AHandle:LongWord;AObject:TComponent);
Var  pmhi:PMenuHandleItem;
     FOwner:TFrameControl;
Begin
     If AHandle = 0 Then Exit;
     If AObject = Nil Then Exit;
     FOwner := TFrameControl(AOwner);
     If FOwner Is TFrameControl Then AOwner := FOwner.Child;
     If Not (AOwner Is TForm) Then Exit;
     If AOwner.FMenuHandleList = Nil Then AOwner.FMenuHandleList.Create;

     GetMem(pmhi, SizeOf(TMenuHandleItem));
     pmhi^.FObject := AObject;
     pmhi^.FHandle := AHandle;
     AOwner.FMenuHandleList.Add(pmhi);
End;


Procedure DisposeMenuHandleItem(AOwner:TForm;AHandle:LongWord;AObject:TComponent);
Var  pmhi:PMenuHandleItem;
     I:LongInt;
     FOwner:TFrameControl;
Begin
     If AHandle = 0 Then Exit;
     If AObject = Nil Then Exit;
     FOwner := TFrameControl(AOwner);
     If FOwner Is TFrameControl Then AOwner := FOwner.Child;
     If Not (AOwner Is TForm) Then Exit;
     If AOwner.FMenuHandleList = Nil Then Exit;

     For I := AOwner.FMenuHandleList.Count-1 Downto 0 Do
     Begin
          pmhi := PMenuHandleItem(AOwner.FMenuHandleList.Items[I]);
          If (pmhi^.FObject = AObject) And (pmhi^.FHandle = AHandle) Then
          Begin
               FreeMem(pmhi, SizeOf(TMenuHandleItem));
               AOwner.FMenuHandleList.Delete(I);
          End;
     End;
     If AOwner.FMenuHandleList.Count = 0 Then
     Begin
          AOwner.FMenuHandleList.Destroy;
          AOwner.FMenuHandleList := Nil;
     End;
End;


Function GetMenuHandleItem(AOwner:TForm;AHandle:LongWord):TComponent;
Var  pmhi:PMenuHandleItem;
     I:LongInt;
     FOwner:TFrameControl;
Begin
     Result := Nil;
     If AHandle = 0 Then Exit;
     FOwner := TFrameControl(AOwner);
     If FOwner Is TFrameControl Then AOwner := FOwner.Child;
     If Not (AOwner Is TForm) Then Exit;
     If AOwner.FMenuHandleList = Nil Then Exit;

     For I := 0 To AOwner.FMenuHandleList.Count-1 Do
     Begin
          pmhi := PMenuHandleItem(AOwner.FMenuHandleList.Items[I]);
          If pmhi^.FHandle = AHandle Then
          Begin
               Result := pmhi^.FObject;
               Exit;
          End;
     End;
End;


Procedure TMenuItem.RedrawMenuBar;
Var  Frame:TControl;
Begin
     If FMenuOwner <> Nil Then
     Begin
          Frame := FMenuOwner;
          If Not (FMenuOwner Is TFrameControl) Then
            If FMenuOwner.FFrame <> Nil Then Frame := FMenuOwner.FFrame;
          DrawMenuBar(Frame.Handle);
     End;
End;
{$ENDIF}


{$IFDEF OS2}
Function GetKeyRepeat(Var M:TMessage):Byte;
Var  Queue:QMSG;
Begin
     Result := 1;

     // Fix by Average from Japan for repeated DBCS chars not working:
     IF M.param2LoByteHi>0 THEN Exit; // DBCS char.

     // I don't understand what the purpose of this function is.
     // OS/2 already tracks key repeats for us ... - AaronL

     While WinPeekMsg(AppHandle,Queue,0,WM_CHAR,WM_CHAR,0) Do
     Begin
          If (LongWord(Queue.mp1) = M.Param1) And
             (LongWord(Queue.mp2) = M.Param2) Then
          Begin
               WinGetMsg(AppHandle,Queue,0,WM_CHAR,WM_CHAR);
               Inc(Result);
          End
          Else Exit;
     End;
End;


Procedure TMenuItem.WMChar(Var Msg:TWMChar);
Var fsFlags:Word;
    REP:Byte;
    Menu:TMenu;
    Current:TMenuItem;
    CH:Char;
    {$IFDEF OS2}
    Param:TKeyCode;
    scan:Byte;
    ascii:Byte;
    virtkey:Word;
    {$ENDIF}
Label lsc;
Begin
     If Not (Self Is TMenuItem) Then Exit;

     Menu:=FMenu;
     If Menu=Nil Then Exit;

     Current:=Menu.GetSelectedMenuItem;
     If Current=Nil Then Exit;

     fsFlags := Msg.KeyData;
     REP := GetKeyRepeat(TMessage(Msg));
     scan := Msg.ScanCode;
     ascii := Lo(Msg.CharCode);
     virtkey := Msg.VirtualKeyCode;

     If fsFlags And KC_KEYUP <> 0 Then
     Begin
          If ((fsFlags And KC_VIRTUALKEY <> 0)And(ascii=32)And(Designed)) Then
          Begin
               //Special Handling For whitespace
               fsFlags := fsFlags Or KC_CHAR;
          End
          Else Exit;
     End;

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or  (fsFlags And KC_CTRL <> 0) Then Goto lsc;
          If (fsFlags And KC_VIRTUALKEY<>0) And (fsFlags And KC_SHIFT<>0)
          Then Goto lsc; {numerical block}
          CH := Chr(ascii);
          Menu.CharEvent(Current,CH,REP);

          If CH = #0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else Param := ascii Or kb_Char;       {E.G. Ctrl-J}

          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;
          Menu.ScanEvent(Current,Param,REP);

          If Param = kbNull Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;
{$ENDIF}


Function GetMenuHandle(Item:TMenuItem):LongWord;
Begin
     Result := 0;
     Repeat
       If Item Is TMenuItem Then
       Begin
            If Item.Handle <> 0 Then
            Begin
                 Result := Item.Handle;
                 Exit;
            End;
            If Item.FParent = Nil Then   {Item Is root}
            Begin
                 Result := Item.FMenu.Handle;
                 Exit;
            End;
            Item := Item.FParent;
       End;
     Until Item = Nil;
End;


Function ReplaceMnemo(Const MnemoString:String):String;
Begin
     Result := MnemoString;
     {$IFDEF OS2}
     If Pos('&',Result) > Pos('~',Result) Then Result[Pos('&',Result)] := '~';
     {$ENDIF}
     {$IFDEF Win32}
     If Pos('~',Result) > Pos('&',Result) Then Result[Pos('~',Result)] := '&';
     {$ENDIF}
End;


Procedure InsertMenuEntry(AParent,Item:TMenuItem; Index:LongInt);
Var  HMen:LongWord;
     CS:Cstring;
     Child:TForm;
     {$IFDEF OS2}
     mi:MENUITEM;
     p1,p2:LongWord;
     {$ENDIF}
     {$IFDEF Win32}
     cmd:TCommand;
     {$ENDIF}
Begin
     If AParent = Nil Then Exit;
     If Item = Nil Then Exit;

     {AParent ist bereits created}
     Item.FMenu := AParent.FMenu;
     If Item.FMenu Is TMenu Then
     Begin
          Item.SetDesigning(AParent.Designed);
          Item.FMenuOwner := TForm(Item.FMenu.Owner);
     End;

     HMen := GetMenuHandle(AParent);
     {$IFDEF OS2}
     mi.afStyle := Item.GetULongFromStyle;
     mi.iPosition := Index;
     mi.afAttribute := Item.GetULongFromFlags;
     If Item.Handle = 0 Then Item.CreateWnd;
     mi.hwndSubMenu := Item.Handle;
     If Item.Glyph <> Nil Then mi.hItem := Item.Glyph.Handle
     Else mi.hItem := 0;
     mi.Id := Item.FInternalCommand;
     If Item.FCaption <> Nil Then CS := ReplaceMnemo(Item.FCaption^)
     Else CS := '';
     p1 := LongWord(@mi);
     p2 := LongWord(@CS);
     WinSendMsg(HMen,MM_INSERTITEM,p1,p2);
     {$ENDIF}
     {$IFDEF Win32}
     cmd := Item.FInternalCommand;
     If Item.FCaption <> Nil Then CS := ReplaceMnemo(Item.FCaption^)
     Else CS := '';
     If Item.Handle = 0 Then Item.CreateWnd;
     If Item.Handle <> 0 Then cmd := Item.Handle;
     InsertMenu(HMen,Index,MF_BYPOSITION Or Item.GetULongFromStyle Or
                           Item.GetULongFromFlags,cmd,CS);
     {$ENDIF}
     Item.FCreated := True;

     {Assign ShortCut}
     If Not Item.Designed Then
       If Item.FShortCut <> kbNull Then
         If Item.FMenuOwner Is TForm Then
         Begin
              Child := TForm(Item.FMenuOwner);
              Child.AddShortCut(Item.FShortCut, Item.FInternalCommand);
         End;
End;


Procedure TMenuItem.SetGlyph(NewGlyph:TGraphic);
Var  HMen:LongWord;
     {$IFDEF OS2}
     mi:MENUITEM;
     cmd:TCommand;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     If NewGlyph<>Nil Then
     Begin
          Include(FStyles,misBitmap);
          Exclude(FStyles,misText);
     End
     Else
     Begin
          Include(FStyles,misText);
          Exclude(FStyles,misBitmap);
     End;

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(Self);
          {$IFDEF OS2}
          cmd:=FInternalCommand;
          WinSendMsg(HMen,MM_QUERYITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          mi.afStyle:=GetULongFromStyle;
          If NewGlyph<>Nil Then mi.hItem:=NewGlyph.Handle;
          WinSendMsg(HMen,MM_SETITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          {$ENDIF}
          {$IFDEF Win32}
          {...?}
          {$ENDIF}
     End;

     FGlyph:=NewGlyph;
End;


Function TMenuItem.GetULongFromStyle:LongWord;
Begin
     Result:=0;
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {$IFDEF OS2}
     If FStyles*[misText]<>[] Then Result:=Result Or MIS_TEXT;
     If FStyles*[misBitmap]<>[] Then Result:=Result Or MIS_BITMAP;
     If FStyles*[misOwnerDraw]<>[] Then Result:=Result Or MIS_OWNERDRAW;
     If FStyles*[misSubmenu]<>[] Then Result:=Result Or MIS_SUBMENU;
     If Caption='-' Then
       If Not Designed Then Result:=(Result Or MIS_SEPARATOR) And (Not MIS_TEXT);
     If FStyles*[misStatic]<>[] Then
       If Not Designed Then Result:=Result Or MIS_STATIC;
     If FStyles*[misBreak]<>[] Then Result:=Result Or MIS_BREAK;
     If FStyles*[misBreakSeparator]<>[] Then Result:=Result Or MIS_BREAKSEPARATOR;
     If FStyles*[misGroup]<>[] Then Result:=Result Or MIS_GROUP;
     If FStyles*[misSingle]<>[] Then Result:=Result Or MIS_SINGLE;
     If FStyles*[misButtonSeparator]<>[] Then Result:=Result Or MIS_BUTTONSEPARATOR;
     If FStyles*[misMultMenu]<>[] Then Result:=Result Or MIS_MULTMENU;
     If FStyles*[misSysCommand]<>[] Then Result:=Result Or MIS_SYSCOMMAND;
     If FStyles*[misHelp]<>[] Then Result:=Result Or MIS_HELP;
     {$ENDIF}
     {$IFDEF Win32}
     If FStyles*[misText]<>[] Then Result:=Result Or MF_STRING;
     If FStyles*[misBitmap]<>[] Then Result:=Result Or MF_BITMAP;
     If FStyles*[misOwnerDraw]<>[] Then Result:=Result Or MF_OWNERDRAW;
     If FStyles*[misSubmenu]<>[] Then Result:=Result Or MF_POPUP;
     If Caption='-' Then
       If Not Designed Then Result:=(Result Or MF_SEPARATOR) And (Not MF_STRING);
     If FStyles*[misStatic]<>[] Then
       If Not Designed Then Result:=Result Or MF_GRAYED;
     If FStyles*[misBreak]<>[] Then Result:=Result Or MF_MENUBREAK;
     If FStyles*[misBreakSeparator]<>[] Then Result:=Result Or MF_MENUBARBREAK;
    {If FStyles*[misMultMenu]<>[] Then Result:=Result Or MIS_MULTMENU;
     If FStyles*[misSysCommand]<>[] Then Result:=Result Or MIS_SYSCOMMAND;
     If FStyles*[misHelp]<>[] Then Result:=Result Or MIS_HELP;
     If FStyles*[misGroup]<>[] Then Result:=Result Or MIS_GROUP;
     If FStyles*[misSingle]<>[] Then Result:=Result Or MIS_SINGLE;
     If FStyles*[misButtonSeparator]<>[] Then Result:=Result Or MF_MENUBARBREAK;}
     {$ENDIF}
End;


{$IFDEF OS2}
Procedure TMenuItem.WMHelp(Var Msg:TMessage);
Var  mi:TMenuItem;
     hctx:THelpContext;
Begin
     hctx := HelpContext;

     mi := FMenu.GetSelectedMenuItem;
     If mi <> Nil Then
       If mi.HelpContext <> 0 Then hctx := mi.HelpContext;

     If hctx <> 0 Then Application.Help(hctx);
     Msg.Handled := True;
End;
{$ENDIF}


Function TMenuItem.GetULongFromFlags:LongWord;
Begin
     Result:=0;
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {$IFDEF OS2}
     If FFlags*[mifNoDismiss]<>[] Then Result:=Result Or MIA_NODISMISS;
     If FFlags*[mifFramed]<>[] Then Result:=Result Or MIA_FRAMED;
     If FFlags*[mifChecked]<>[] Then Result:=Result Or MIA_CHECKED;
     If FFlags*[mifDisabled]<>[] Then Result:=Result Or MIA_DISABLED;
     If FFlags*[mifHilited]<>[] Then Result:=Result Or MIA_HILITED;
     If Designed Then Result:=Result Or MIA_NODISMISS;
     {$ENDIF}
     {$IFDEF Win32}
     {If FFlags*[mifNoDismiss]<>[] Then Result:=Result Or MIA_NODISMISS;}
     {If FFlags*[mifFramed]<>[] Then Result:=Result Or MIA_FRAMED;}
     If FFlags*[mifChecked]<>[] Then Result:=Result Or MF_CHECKED;
     If FFlags*[mifDisabled]<>[] Then Result:=Result Or MF_DISABLED Or MF_GRAYED;
     {If FFlags*[mifHilited]<>[] Then Result:=Result Or MIA_HILITED;}
     {If Designed Then Result:=Result Or MIA_NODISMISS;}
     {$ENDIF}
End;


Procedure TMenuItem.SetStyles(NewStyles:TMenuItemStyles);
Var  HMen:LongWord;
     CS:Cstring;
     entry:TMenuItem;
     T:LongInt;
     cmd:TCommand;
     {$IFDEF OS2}
     mi:MENUITEM;
     p1,p2:LongWord;
     {$ENDIF}
     {$IFDEF Win32}
     mp:LongInt;
     NewCaption:String;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     FStyles:=NewStyles;

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(FParent);
          cmd:=FInternalCommand;
          {$IFDEF OS2}
          WinSendMsg(HMen,MM_QUERYITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          {$ENDIF}

          If (FStyles*[misSubmenu]<>[]) Xor (FHandle<>0) Then
          Begin
               {$IFDEF OS2}
               WinSendMsg(HMen,MM_DELETEITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
               {$ENDIF}

               {$IFDEF Win32}
               mp:=GetMenuIndex;
               DeleteMenu(HMen,mp,MF_BYPOSITION);
               DisposeMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
               {$ENDIF}

               If FHandle=0 Then {misSubmenu Set}
               Begin
                    {$IFDEF OS2}
                    HMen := GetMenuHandle(FParent);
                    FHandle := WinCreateMenu(HMen,Nil);
                    WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
                    FDefWndProc:=Pointer(WinSubClassWindow(FHandle,@SubclassedMenuItemWndProc));
                    {$ENDIF}

                    {$IFDEF Win32}
                    FHandle:=WinUser.CreateMenu;
                    NewMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
                    {$ENDIF}
               End
               Else              {misSubmenu cleared}
               Begin
                    FHandle:=0;
                    {Clear All Submenu entries}
                    {Destroy subitems}
                    If FItems <> Nil Then
                    Begin
                         For T := FItems.Count-1 Downto 0
                            Do TMenuItem(FItems[T]).Destroy;
                         FItems.Destroy;
                         FItems := Nil;
                    End;
               End;

               {$IFDEF OS2}
               mi.afStyle:=GetULongFromStyle;
               mi.hwndSubMenu:=FHandle;
               If FCaption<>Nil Then CS:=FCaption^
               Else CS:='';
               p1:=LongWord(@mi);
               p2:=LongWord(@CS);
               WinSendMsg(HMen,MM_INSERTITEM,p1,p2);
               {$ENDIF}

               {$IFDEF Win32}
               If FHandle<>0 Then cmd:=FHandle;
               {CS:=ReplaceMnemo(Caption);}
               NewCaption:=Caption;
               T:=Pos('\t',NewCaption);
               If T>0 Then
               Begin
                  Delete(NewCaption,T,1);
                  NewCaption[T]:=#9;

                  {Test whether Self Is A main entry Of the MainMenu}
                  If FMenu Is TMainMenu Then
                    If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
               End;
               CS:=NewCaption;
               InsertMenu(HMen,mp,MF_BYPOSITION Or GetULongFromStyle Or
                                  GetULongFromFlags,cmd,CS);
               RedrawMenuBar;
               {$ENDIF}

               If Designed Then
                 If FHandle<>0 Then
                   If Not IsEditMenuItem Then
               Begin
                    {Insert New Empty Item To edit the New Submenu Items}
                    entry.Create(FMenu.Owner);
                    entry.Caption:=MenuIDEEditStr;
                    Add(entry);
               End;
          End
          Else
          Begin
               {$IFDEF OS2}
               mi.afStyle:=GetULongFromStyle;
               mi.hwndSubMenu:=FHandle;
               WinSendMsg(HMen,MM_SETITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
               {$ENDIF}

               {$IFDEF Win32}
               If FHandle<>0 Then cmd:=FHandle;
               {CS:=ReplaceMnemo(Caption);}
               NewCaption:=Caption;
               T:=Pos('\t',NewCaption);
               If T>0 Then
               Begin
                  Delete(NewCaption,T,1);
                  NewCaption[T]:=#9;

                  {Test whether Self Is A main entry Of the MainMenu}
                  If FMenu Is TMainMenu Then
                    If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
               End;
               CS:=NewCaption;
               ModifyMenu(HMen,GetMenuIndex,MF_BYPOSITION Or GetULongFromStyle Or
                          GetULongFromFlags,cmd,CS);
               RedrawMenuBar;
               {$ENDIF}
          End;
     End;
End;


Procedure TMenuItem.SetFlags(NewFlags:TMenuItemFlags);
Var  HMen:LongWord;
     OldFlags:TMenuItemFlags;
     cmd:TCommand;
     {$IFDEF Win32}
     CS:Cstring;
     NewCaption:String;
     t:LongInt;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     OldFlags:=FFlags;
     FFlags:=NewFlags;

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(Self);
          cmd:=FInternalCommand;
          {$IFDEF OS2}
          If FFlags*[mifNoDismiss]<>OldFlags*[mifNoDismiss] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_NODISMISS,GetULongFromFlags And MIA_NODISMISS));
          If FFlags*[mifFramed]<>OldFlags*[mifFramed] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_FRAMED,GetULongFromFlags And MIA_FRAMED));
          If FFlags*[mifChecked]<>OldFlags*[mifChecked] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_CHECKED,GetULongFromFlags And MIA_CHECKED));
          If FFlags*[mifDisabled]<>OldFlags*[mifDisabled] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_DISABLED,GetULongFromFlags And MIA_DISABLED));
          If FFlags*[mifHilited]<>OldFlags*[mifHilited] Then
              WinSendMsg(HMen,MM_SETITEMATTR,MPFROM2SHORT(cmd,1),
                         MPFROM2SHORT(MIA_HILITED,GetULongFromFlags And MIA_HILITED));
          {$ENDIF}
          {$IFDEF Win32}
          If FHandle<>0 Then cmd:=FHandle;
          {CS:=ReplaceMnemo(Caption);}
          NewCaption:=Caption;
          T:=Pos('\t',NewCaption);
          If T>0 Then
          Begin
             Delete(NewCaption,T,1);
             NewCaption[T]:=#9;

             {Test whether Self Is A main entry Of the MainMenu}
             If FMenu Is TMainMenu Then
                If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
          End;
          CS:=NewCaption;
          ModifyMenu(HMen,GetMenuIndex,MF_BYPOSITION Or GetULongFromStyle Or
                     GetULongFromFlags,cmd,CS);
          RedrawMenuBar;
          {$ENDIF}
     End;
End;


Procedure TMenuItem.CreateWnd;
Var  T:LongInt;
     Item:TMenuItem;
     {$IFDEF OS2}
     HMen:LongWord;
     {$ENDIF}
Begin
     If FMenu = Nil Then Exit;
     If FMenu.FItems <> Self Then  {Not the root Item}
     Begin
          If Handle<>0 Then Exit;
          If FInitItems=Nil Then Exit;

          {$IFDEF OS2}
          HMen := GetMenuHandle(FParent);
          FHandle := WinCreateMenu(HMen,Nil);
          WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
          FDefWndProc:=Pointer(WinSubClassWindow(FHandle,@SubclassedMenuItemWndPRoc));
          {$ENDIF}
          {$IFDEF Win32}
          FHandle:=WinUser.CreateMenu;
          NewMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
          {$ENDIF}
     End;

     If FInitItems<>Nil Then
     Begin
          For T:=0 To FInitItems.Count-1 Do
          Begin
               Item:=FInitItems.Items[T];
               InsertMenuEntry(Self,Item,-1);
          End;
          FInitItems:=Nil;
     End;
End;


Function TMenuItem.GetCaption:String;
Var  T:Byte;
     {$IFDEF WIN32}
     CS:CString;
     {$ENDIF}
Begin
     Result:='';
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     If FCaption<>Nil Then Result:=FCaption^;
     If Result=MenuIDEEditStr Then Result:='';
     T:=Pos(#9,Result);
     If T<>0 Then
     Begin
          System.Insert('\',Result,T);
          Result[T+1]:='t';
     End;

     Result := ReplaceMnemo(Result);
End;


Procedure TMenuItem.SetCaption(NewCaption:String);
Var  C:Cstring;
     HMen:LongWord;
     Own:TMenuItem;
     entry:TMenuItem;
     T:Byte;
     cmd:TCommand;
     DNS:TDesignerNotifyStruct;
     {$IFDEF OS2}
     mi:MENUITEM;
     {$ENDIF}
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {$IFDEF WIN32}
     StrOemToAnsi(NewCaption);
     {$ENDIF}

     T:=Pos('\t',NewCaption);
     If T>0 Then
     Begin
          Delete(NewCaption,T,1);
          NewCaption[T]:=#9;

          {Test whether Self Is A main entry Of the MainMenu}
          If FMenu Is TMainMenu Then
            If FMenu.FItems = FParent Then SetLength(NewCaption,T-1);
     End;

     If FCaption<>Nil Then
     Begin
          If Designed Then
            If FCreated Then
              If FParent <> Nil Then
                If IsEditMenuItem Then
                  If NewCaption<>MenuIDEEditStr Then
                  Begin
                       If (FParent.FParent = Nil) And
                          (FMenu Is TMainMenu) Then
                       Begin
                            {New main Menu entry}
                            entry.Create(FMenu.Owner);
                            entry.Caption:=MenuIDEEditStr;
                            FMenu.Items.Add(entry);

                            Own:=Self;
                       End
                       Else Own:=FParent;

                       {New SUB Menu entry}
                       entry.Create(FMenu.Owner);
                       entry.Caption:=MenuIDEEditStr;
                       Own.Add(entry);

                       If FMenu.Owner Is TForm Then
                       Begin
                            {GenNewComponent}
                            DNS.Sender := Self;
                            DNS.Code := dncNewMenuItem;
                            DNS.return := 0;
                            TForm(FMenu.Owner).DesignerNotification(DNS);
                       End;
                  End;

          DisposeStr(FCaption);
          FCaption:=Nil;
     End;

     If NewCaption <> '' Then AssignStr(FCaption,NewCaption);

     If FCreated Then
     Begin
          HMen:=GetMenuHandle(FParent);
          cmd:=FInternalCommand;

          {$IFDEF OS2}
          C := ReplaceMnemo(NewCaption);
          If (NewCaption = '-') And Not Designed Then
          Begin
               WinSendMsg(HMen,MM_QUERYITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
               mi.afStyle:=GetULongFromStyle;
               WinSendMsg(HMen,MM_SETITEM,MPFROM2SHORT(cmd,1),LongWord(@mi));
          End
          Else WinSendMsg(HMen,MM_SETITEMTEXT,cmd,LongWord(@C));
          {$ENDIF}
          {$IFDEF Win32}
          If FHandle<>0 Then cmd:=FHandle;
          C := ReplaceMnemo(NewCaption);
          ModifyMenu(HMen,GetMenuIndex,MF_BYPOSITION Or GetULongFromFlags Or
                     GetULongFromStyle,cmd,C);
          RedrawMenuBar;
          {$ENDIF}
     End;
End;

Function IsControl(Control:TControl):Boolean;
Var RegionSize,Flags:LongWord;
    p:^Pointer;
    p1:^Pointer;
{$IFDEF WIN32}
Var MemInfo:MEMORY_BASIC_INFORMATION;
{$ENDIF}
Begin
     //check smallest/largest possible address (64KB And 1GB)
     {$IFDEF OS2}
     If ((LongWord(Control)<$10000)Or(LongWord(Control)>$40000000)) Then
     Begin
          Result:=False;
          Exit;
     End;

     Result:=True;

     RegionSize:=4;
     Flags:=0;
     If DosQueryMem(Pointer(Control),RegionSize,Flags)<>0 Then Result:=False
     Else If (Flags And PAG_COMMIT)=0 Then Result:=False
     Else If (Flags And PAG_READ)=0 Then Result:=False
     Else
     Begin
         p1:=Pointer(Control);
         p:=p1^;
         RegionSize:=4;
         Flags:=0;
         If DosQueryMem(p,RegionSize,Flags)<>0 Then Result:=False
         Else If (Flags And PAG_COMMIT)=0 Then Result:=False
         Else If (Flags And PAG_READ)=0 Then Result:=False
         Else
         Begin
              p1 := p;
              p := p1^;
              If DosQueryMem(p,RegionSize,Flags)<>0 Then Result:=False
              Else If (Flags And PAG_EXECUTE)=0 Then Result:=False
              Else If (Flags And PAG_READ)=0 Then Result:=False
              Else If not (Control Is TControl) Then Result:=False;
         End;
     End;
     {$ENDIF}
     {$IFDEF WIN32}
     If ((LongWord(Control)<$410000)Or(LongWord(Control)>$f0000000)) Then
     Begin
          Result:=False;
          Exit;
     End;

     Result:=True;

     Try
        If IsBadReadPtr(Pointer(Control),4) Then Result:=False
        Else
        Begin
            p1:=Pointer(Control);
            p:=p1^;
            If IsBadReadPtr(p,4) Then Result:=False
            Else
            Begin
                 p1 := p;
                 p := p1^;
                 If IsBadReadPtr(p,4) Then Result:=False
                 Else If IsBadCodePtr(p) Then Result:=False
                 Else If not (Control Is TControl) Then Result:=False;
            End;
        End;
     Except
        Result:=False;
     End;
     {$ENDIF}
End;


Procedure TMenuItem.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='MenuItem';
     Caption:=Name;
     FStyles:=[misText];
     FFlags:=[];
     FCommand:=cmNull;
     If IsControl(TControl(Owner)) Then FMenuOwner:=TControl(Owner);

     If Application <> Nil Then FInternalCommand := Application.NewMenuItem(Self);
End;


Procedure TMenuItem.Add(Item:TMenuItem);
Begin
     Insert(-1,Item);
End;


Procedure TMenuItem.Insert(Index:LongInt;Item:TMenuItem);
Begin
     If Item = Nil Then Exit;
     Item.FParent := Self;

     If FItems = Nil Then FItems.Create;
     If Index > FItems.Count Then Index := FItems.Count;
     If Index < 0 Then Index := FItems.Add(Item)
     Else FItems.Insert(Index,Item);

     styles := styles + [misSubmenu];

     If FCreated Then InsertMenuEntry(Self,Item,Index)
     Else FInitItems := FItems;
End;


Function AccelToString(kbValue:TKeyCode):String;
Var  Mask:TKeyCode;
Begin
     Result := '';
     If kbValue And kb_Ctrl <> 0 Then Result := Result + 'Ctrl+';
     If kbValue And kb_Shift <> 0 Then Result := Result + 'Shift+';
     If kbValue And kb_Alt <> 0 Then Result := Result + 'Alt+';
     If kbValue And kb_Char <> 0
     Then Result := Result + UpCase(Chr(kbValue And 255));
     If kbValue And kb_VK <> 0 Then
     Begin
          Mask := kb_Ctrl Or kb_Shift Or kb_Alt Or kb_Char;
          Case kbValue And Not Mask Of
            kbF1:        Result := Result + 'F1';
            kbF2:        Result := Result + 'F2';
            kbF3:        Result := Result + 'F3';
            kbF4:        Result := Result + 'F4';
            kbF5:        Result := Result + 'F5';
            kbF6:        Result := Result + 'F6';
            kbF7:        Result := Result + 'F7';
            kbF8:        Result := Result + 'F8';
            kbF9:        Result := Result + 'F9';
            kbF10:       Result := Result + 'F10';
            kbF11:       Result := Result + 'F11';
            kbF12:       Result := Result + 'F12';
            kbCLeft:     Result := Result + 'Left';
            kbCRight:    Result := Result + 'Right';
            kbCUp:       Result := Result + 'Up';
            kbCDown:     Result := Result + 'Down';
            kbDel:       Result := Result + 'Del';
            kbIns:       Result := Result + 'Ins';
            kbEnd:       Result := Result + 'End';
            kbHome:      Result := Result + 'Home';
            kbPageDown:  Result := Result + 'PageDown';
            kbPageUp:    Result := Result + 'PageUp';
            kbBkSp:      Result := Result + 'BkSp';
            kbCR:        Result := Result + 'CR';
            kbEsc:       Result := Result + 'Esc';
            {$IFDEF OS2}
            kbEnter:     Result := Result + 'Enter';
            {$ENDIF}
            kbPrintScrn: Result := Result + 'PrintScrn';
            {$IFDEF OS2}
            kbBackTab:   Result := Result + 'BackTab';
            {$ENDIF}
            kbTab:       Result := Result + 'Tab';
            kbSpace:     Result := Result + 'Space';
            kbPause:     Result := Result + 'Pause';
            kbCapsLock:  Result := Result + 'CapsLock';
            kbScrollLock:Result := Result + 'ScrollLock';
            kbNumLock:   Result := Result + 'NumLock';
          End;
     End;

     If Result <> '' Then
       If Result[Length(Result)] = '+' Then Result := '';
End;


Procedure TMenuItem.SetShortCut(NewAccel:TKeyCode);
Var Child:TForm;
    OldAccel:LongWord;
    S:String;
    acl:String;
    P:Integer;
Begin
     If (FParent = Nil) And (FMenu <> Nil) Then Exit;  {the root Item}

     {Test whether Self Is A main entry Of the MainMenu}
     If FMenu Is TMainMenu Then
       If FMenu.FItems = FParent Then Exit;

     OldAccel:=FShortCut;
     FShortCut:=NewAccel;
     If Not Designed Then
       If FShortCut<>kbNull Then
         If FMenuOwner Is TForm Then
         Begin
              Child:=TForm(FMenuOwner);
              If OldAccel<>kbNull Then Child.DeleteShortCut(OldAccel);
              Child.AddShortCut(FShortCut,FInternalCommand);
         End;

     {auto Add ShortCut String}
     If Designed Then
     Begin
          S := Caption;
          P := Pos('\t',S);
          If P > 0 Then Delete(S,P,255);
          If NewAccel <> kbNull Then
          Begin
               acl := AccelToString(NewAccel);
               If acl <> '' Then S := S + '\t' + acl;
          End;
          Caption := S;
     End;
End;


Destructor TMenuItem.Destroy;
Var  HMen:LongWord;
     Child:TForm;
     idx,T:LongInt;
     {$IFDEF OS2}
     Id:Word;
     {$ENDIF}
Begin
     idx := GetMenuIndex;
     Try
        If FParent Is TMenuItem Then FParent.FItems.Remove(Self); {entferne aus Liste}
     Except
        //ErrorBox2('Menu item not found in Parent menu (Destroy)');
     End;

     HMen := GetMenuHandle(FParent);
     If HMen <> 0 Then
       If idx >= 0 Then
     Begin
          {$IFDEF OS2}
          Id := FInternalCommand;
          If WinSendMsg(HMen,MM_ITEMIDFROMPOSITION,idx,0) = Id
          Then WinSendMsg(HMen,MM_DELETEITEMBYPOS,idx,0)
          Else WinSendMsg(HMen,MM_DELETEITEM,MPFROM2SHORT(Id,1),0);
          {$ENDIF}
          {$IFDEF Win32}
          DeleteMenu(HMen,idx,MF_BYPOSITION);
          DisposeMenuHandleItem(TForm(FMenuOwner),FHandle,TComponent(Self));
          RedrawMenuBar;
          {$ENDIF}
     End;

     If Not Designed Then
       If FShortCut <> 0 Then
         If FMenuOwner Is TForm Then
     Begin
          Child := TForm(FMenuOwner);
          Child.DeleteShortCut(FShortCut);
          FShortCut := 0;
     End;

     If FHandle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSubClassWindow(FHandle,@FDefWndProc);
          WinDestroyWindow(FHandle);
          {$ENDIF}
          {$IFDEF Win32}
          DestroyMenu(FHandle);   //war DestroyWindow(FHandle);
          {$ENDIF}
          FHandle := 0;
     End;

     {Destroy subitems}
     If FItems <> Nil Then
     Begin
          For T := FItems.Count-1 Downto 0 Do TMenuItem(FItems[T]).Destroy;
          FItems.Destroy;
          FItems := Nil;
     End;

     DisposeStr(FCaption);
     FCaption := Nil;

     DisposeStr(FHint);
     FHint := Nil;

     Application.DeleteMenuItem(Self);

     Inherited Destroy;
End;


Function TMenuItem.IndexOf(Item:TMenuItem):LongInt;
Begin
     If FItems <> Nil Then Result := FItems.IndexOf(Item)
     Else Result := -1;
End;


Procedure TMenuItem.LoadedFromSCU(SCUParent:TComponent);
Begin
     Inherited LoadedFromSCU(SCUParent);

     If SCUParent Is TMenuItem Then TMenuItem(SCUParent).Add(Self);
     If SCUParent Is TMenu Then TMenu(SCUParent).FItems.Add(Self);
End;


Procedure TMenuItem.GetChildren(Proc:TGetChildProc);
Var  T:LongInt;
     Item:TMenuItem;
Begin
     If Count > 0 Then
     Begin
          For T := 0 To Count-1 Do
          Begin
               Item := Items[T];
               If Item.Designed Then
                 If Not Item.IsEditMenuItem Then Proc(Item);
          End;
     End;
End;


Procedure TMenuItem.SetHint(Const NewText:String);
Begin
     DisposeStr(FHint);
     FHint := Nil;
     If NewText = '' Then Exit;
     AssignStr(FHint,NewText);
End;


Function TMenuItem.GetHint:String;
Begin
     If FHint = Nil Then Result := ''
     Else Result := FHint^;
End;


Function TMenuItem.GetChecked:Boolean;
Begin
     Result := Flags * [mifChecked] <> [];
End;


Procedure TMenuItem.SetChecked(Value:Boolean);
Begin
     If GetChecked = Value Then Exit;

     If Value Then Flags := Flags + [mifChecked]
     Else Flags := Flags - [mifChecked];
End;


Function TMenuItem.GetEnabled:Boolean;
Begin
     Result := Flags * [mifDisabled] = [];
End;


Procedure TMenuItem.SetEnabled(Value:Boolean);
Begin
     If GetEnabled = Value Then Exit;

     If Value Then Flags := Flags - [mifDisabled]
     Else Flags := Flags + [mifDisabled];
End;


Function TMenuItem.GetBreak:TMenuBreak;
Begin
     If Caption = '-' Then Result := mbSeparator
     Else If FStyles * [misBreakSeparator] <> [] Then Result := mbBarBreak
     Else If FStyles * [misBreak] <> [] Then Result := mbBreak
          Else Result := mbNone;
End;


Procedure TMenuItem.SetBreak(Value:TMenuBreak);
Begin
     Case Value Of
       mbNone:
       Begin
            Exclude(FStyles,misBreak);
            Exclude(FStyles,misBreakSeparator);
            If Caption = '-' Then Caption := '';
       End;
       mbBreak:
       Begin
            Include(FStyles,misBreak);
            Exclude(FStyles,misBreakSeparator);
            If Caption = '-' Then Caption := '';
       End;
       mbBarBreak:
       Begin
            Exclude(FStyles,misBreak);
            Include(FStyles,misBreakSeparator);
            If Caption = '-' Then Caption := '';
       End;
       mbSeparator:
       Begin
            Exclude(FStyles,misBreak);
            Exclude(FStyles,misBreakSeparator);
            Caption := '-';
       End;
     End;
     SetStyles(FStyles); {Update the Menu}
End;


Function TMenuItem.GetSubMenu:Boolean;
Begin
     Result := styles * [misSubmenu] <> [];
End;


Procedure TMenuItem.SetSubMenu(Value:Boolean);
Begin
     If GetSubMenu = Value Then Exit;

     If Value Then styles := styles + [misSubmenu]
     Else styles := styles + [misSubmenu];
End;


Function TMenuItem.GetCount:LongInt;
Begin
     If FItems <> Nil Then Result := FItems.Count
     Else Result := 0;
End;


Function TMenuItem.GetItem(Index:LongInt):TMenuItem;
Begin
     If FItems <> Nil Then Result := TMenuItem(FItems[Index])
     Else Result := Nil;
End;


Function TMenuItem.GetMenuIndex:LongInt;
Begin
     If FParent <> Nil Then Result := FParent.IndexOf(Self)
     Else Result := -1;
End;


Function TMenuItem.GetIsEditMenuItem:Boolean;
Begin
     Result := False;
     If Designed Then
       If FCaption <> Nil Then
         If FCaption^ = MenuIDEEditStr Then Result := True;
End;


Procedure TMenuItem.Click;
Begin
     If FOnClick <> Nil Then FOnClick(Self);

     If IsControl(FMenuOwner) Then SendMsg(FMenuOwner.Handle,WM_COMMAND,FCommand,0);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMenu Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function SubclassedMenuWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
Var  Menu:TMenu;
     aMsg:TMessage;
     Handled:Boolean;
Begin
     Menu:=Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}
     If Menu=Nil Then Exit;
     aMsg.Receiver:=Win;
     aMsg.ReceiverClass:=Menu;
     aMsg.Msg:=Msg;
     aMsg.Param1:=para1;
     aMsg.Param2:=para2;
     aMsg.Handled:=False;

     If ((Application<>Nil)And(Application.FOnMsgEvent<>Nil)) Then
     Begin
          Handled:=False;
          Application.FOnMsgEvent(aMsg,Handled);
          aMsg.Handled:=aMsg.Handled Or Handled;
     End;

     If Not aMsg.Handled Then Menu.Dispatch(aMsg);
     If Not aMsg.Handled
     Then aMsg.Result:=Menu.FDefWndProc(aMsg.Receiver,aMsg.Msg,
                                        aMsg.Param1,aMsg.Param2);
     Result:=aMsg.Result;
End;
{$ENDIF}


Procedure DereferenceFont( Var FFont:TFont );
Begin
     If FFont<>Nil Then
     Begin
          {$IFDEF Win32}
          If FFont.FHandle<>0 Then
          Begin
               If FFont.FRefCount>1 Then Dec(FFont.FRefCount)
               Else
               Begin
                    DeleteObject(FFont.FHandle);
                    FFont.FHandle:=0;
               End;
          End;
          {$ENDIF}
          If FFont.FUseCount>0 Then Dec(FFont.FUseCount);
          If ( FFont.FCustom
               And FFont.AutoDestroy
               And ( FFont.FUseCount = 0 )) Then
          Begin
               FFont.Destroy;
               FFont := nil; // AaronL - need to set ffont to nil 
          End;
     End;
End;

Procedure ReferenceFont( Var FFont:TFont );
Begin
     If FFont <> nil Then Inc( FFont.FUseCount );
End;

Procedure TMenu.SetFont(NewFont:TFont);
Var  {$IFDEF OS2}
     S:String;
     C:Cstring;
     CS:Cstring;
     {$ENDIF}
     {$IFDEF Win32}
     aFontInfo:LOGFONT;
     FDefFontHandle:LongWord;
     {$ENDIF}
Begin
     If FFont<>NewFont Then
     Begin
          DereferenceFont(FFont);
          FFont:=NewFont;
          ReferenceFont(FFont);
     End;

     {$IFDEF Win32}
     If FFont<>Nil Then
     Begin
          If FFont.FHandle<>0 Then
          Begin
               If FDefFontHandle<>FFont.FHandle Then
               Begin
                    FDefFontHandle:=FFont.FHandle;
                    Inc(FFont.FRefCount);
               End;
          End
          Else
          Begin
               aFontInfo:=FFont.FFontInfo;
               aFontInfo.lfHeight:=FFont.FFontInfo.lfHeight;
               aFontInfo.lfWidth:=FFont.FFontInfo.lfWidth;
               aFontInfo.lfQuality:=DRAFT_QUALITY;
               aFontInfo.lfItalic:=0;
               aFontInfo.lfUnderline:=0;
               aFontInfo.lfStrikeOut:=0;
               aFontInfo.lfWeight:=FW_NORMAL;
               FDefFontHandle:=CreateFontIndirect(aFontInfo);
               FFont.FHandle:=FDefFontHandle;
               FFont.FRefCount:=1;
          End;
     End;
     {$ENDIF}

     If Handle <> 0 Then If FFont<>Nil Then
     Begin
          {$IFDEF OS2}
          If FFont.FInternalPointSize<>0 Then
          Begin
               S:=tostr(FFont.FInternalPointSize)+'.';
               C:=FFont.FaceName;
          End
          Else
          Begin
               S:=tostr((FFont.FFontInfo.sNominalPointSize) Div 10)+'.';
               C:=FFont.FFontInfo.szFaceName;
          End;

          CS:=S+C;
          WinSetPresParam(Handle,PP_FONTNAMESIZE,Length(CS)+1,CS);
          {$ENDIF}
          {$IFDEF Win32}
          SendMessage(Handle,WM_SETFONT,FDefFontHandle,1);
          {$ENDIF}
     End;
End;


Procedure TMenu.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Begin
     If ResName = rnFont Then
     Begin
          If DataLen <> 0 Then
          Begin
               Font := ReadSCUFont(Data,DataLen);
               If ((Font<>Nil)And(Font.FAlternateName<>Nil)) Then
               Begin
                   AssignStr(FAlternateFontName,Font.FAlternateName^);
                   DisposeStr(Font.FAlternateName);
                   Font.FAlternateName:=Nil;
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TMenu.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FFont = Nil Then
     Begin
          Result := True;
          Exit;
     End;

     DisposeStr(FFont.FAlternateName);
     FFont.FAlternateName:=FAlternateFontName;
     Result := FFont.WriteSCUResourceName(Stream,rnFont);
     FFont.FAlternateName:=Nil;
End;


Procedure TMenu.DisableCommands(Cmds:Array Of TCommand);
Var  T:LongInt;
     entry:TMenuItem;
Begin
     For T := Low(Cmds) To High(Cmds) Do
     Begin
          entry := ItemFromCommand(Cmds[T]);
          If entry <> Nil Then entry.Enabled := False;
     End;
End;


Procedure TMenu.EnableCommands(Cmds:Array Of TCommand);
Var  T:LongInt;
     entry:TMenuItem;
Begin
     For T := Low(Cmds) To High(Cmds) Do
     Begin
          entry := ItemFromCommand(Cmds[T]);
          If entry <> Nil Then entry.Enabled := True;
     End;
End;


{$IFDEF OS2}
Procedure TMenu.WMHelp(Var Msg:TMessage);
Var  mi:TMenuItem;
Begin
     mi := GetSelectedMenuItem;
     If mi <> Nil Then
       If mi.HelpContext <> 0 Then Application.Help(mi.HelpContext);

     Msg.Handled := True;
End;


Procedure TMenu.WMChar(Var Msg:TWMChar);
Var fsFlags:Word;
    REP:Byte;
    scan:Byte;
    ascii:Byte;
    virtkey:Word;
    Current:TMenuItem;
    CH:Char;
    Param:TKeyCode;
    SelItem:Word;
Label lsc;
Begin
     fsFlags := Msg.KeyData;
     REP := GetKeyRepeat(TMessage(Msg));
     scan := Msg.ScanCode;
     ascii := Lo(Msg.CharCode);
     virtkey := Msg.VirtualKeyCode;

     If fsFlags And KC_KEYUP <> 0 Then Exit;
     If Not (Self Is TMenu) Then Exit;

     SelItem:=WinSendMsg(Handle,MM_QUERYSELITEMID,MPFROM2SHORT(0,1),0);
     Current:=ItemFromInternalCommand(SelItem);
     If Current=Nil Then Exit;

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or  (fsFlags And KC_CTRL <> 0) Then Goto lsc;
          If (fsFlags And KC_VIRTUALKEY <> 0) And (fsFlags And KC_SHIFT <> 0)
          Then Goto lsc;    {numerical block}
          CH := Chr(ascii);
          CharEvent(Current,CH,REP);

          If CH = #0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else Param := ascii Or kb_Char;       {E.G. Ctrl-J}

          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;
          ScanEvent(Current,Param,REP);

          If Param = kbNull Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;
{$ENDIF}


Procedure TMenu.CharEvent(entry:TMenuItem;Var key:Char;REP:Byte);
Var  Child:TForm;
Begin
     If Owner Is TForm Then
     Begin
          Child:=TForm(Owner);
          Child.MenuCharEvent(Self,entry,key,REP);

          If Designed Then key := #0;
     End;
End;


Procedure TMenu.ScanEvent(entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);
Var  Child:TForm;
Begin
     If Owner Is TForm Then
     Begin
          Child:=TForm(Owner);
          Child.MenuScanEvent(Self,entry,KeyCode,REP);

          If Designed Then
            If Not (KeyCode In [kbEsc,kbCLeft,kbCRight])
            Then KeyCode := kbNull;
     End;
End;


Procedure TMenu.LoadedFromSCU(SCUParent:TComponent);
  Procedure ProcessSubMenus(ParentItem:TMenuItem);
  Var  T:LongInt;
       entry:TMenuItem;
  Begin
       {Append pseudo Menus}
       For T := 0 To ParentItem.Count-1 Do
       Begin
            entry := ParentItem.Items[T];
            If entry Is TMenuItem Then
            Begin
                 If ((Self Is TMainMenu) And (ParentItem = Items)) Or
                     (entry.Count > 0) Then ProcessSubMenus(entry);
            End;
       End;

       {New Submenu entry}
       entry.Create(Owner{Self});
       entry.Caption := MenuIDEEditStr;
       ParentItem.Add(entry);
  End;
Begin
     Inherited LoadedFromSCU(SCUParent);

     If Designed Then ProcessSubMenus(Items);
End;


Procedure TMenu.GetChildren(Proc:TGetChildProc);
Begin
     FItems.GetChildren(Proc);
End;


Function SearchSubEntry(Menu:TMenu;AParent:TMenuItem;Command:TCommand;
                        internal:Boolean):TMenuItem;
Var  T:LongInt;
     cmd:TCommand;
     entry:TMenuItem;
Begin
     Result := Nil;
     For T := 0 To AParent.Count-1 Do
     Begin
          entry := AParent.Items[T];
          If internal Then cmd := entry.FInternalCommand
          Else cmd := entry.FCommand;

          If cmd = Command Then
          Begin
               Result := entry;
               Exit;
          End;
          If entry.Count > 0 Then
          Begin
               Result := SearchSubEntry(Menu,entry,Command,internal);
               If Result <> Nil Then Exit;
          End;
     End;
End;


Function TMenu.ItemFromCommand(Command:TCommand):TMenuItem;
Begin
     Result := SearchSubEntry(Self,Items,Command,False);
End;


Function TMenu.ItemFromInternalCommand(Command:TCommand):TMenuItem;
Begin
     Result := Application.GetMenuItem(Command);
End;

Function TMenu.GetSelectedMenuItem:TMenuItem;
{$IFDEF OS2}
Var  SelItemId:Word;
{$ENDIF}
Begin
     {$IFDEF OS2}
     SelItemId := WinSendMsg(Handle,MM_QUERYSELITEMID,MPFROM2SHORT(0,1),0);
     Result := ItemFromInternalCommand(SelItemId);
     {$ENDIF}
     {$IFDEF Win32}
     Result:=Nil;
     {...?}
     {$ENDIF}
End;


Function TMenu.GetWidth:LongInt;
Var  rc:RECTL;
Begin
     Result := 0;
     {$IFDEF OS2}
     If FHandle <> 0 Then
       If WinQueryWindowRect(FHandle,rc) Then Result := rc.xRight;
     {$ENDIF}
     {$IFDEF Win32}
     If FHandle <> 0 Then
       If Items.Count > 0 Then
     Begin
          {rightmost MENUITEM}
          WinUser.GetMenuItemRect(FParent.Handle,FHandle,Items.Count-1,rc);
          Result := rc.Right;
          {leftmost MENUITEM}
          WinUser.GetMenuItemRect(FParent.Handle,FHandle,0,rc);
          Dec(Result,rc.Left);
     End;
     {$ENDIF}
End;


Function TMenu.GetHeight:LongInt;
Var  rc:RECTL;
Begin
     Result := 0;
     {$IFDEF OS2}
     If FHandle <> 0 Then
       If WinQueryWindowRect(FHandle,rc) Then Result := rc.yTop;
     {$ENDIF}
     {$IFDEF Win32}
     If FHandle <> 0 Then
       If Items.Count > 0 Then
     Begin
          {rightmost MENUITEM}
          WinUser.GetMenuItemRect(FParent.Handle,FHandle,Items.Count-1,rc);
          Result := rc.Bottom;
          {leftmost MENUITEM}
          WinUser.GetMenuItemRect(FParent.Handle,FHandle,0,rc);
          Dec(Result,rc.Top);
     End;
     {$ENDIF}
End;


Destructor TMenu.Destroy;
Var  HMen:LongWord;
Begin
     If FHandle<>0 Then
     Begin
          HMen:=FHandle;
          FHandle:=0;

          {maybe FParent Is already destroyed}
          If Not (IsControl(FParent)) Then FParent := Nil;

          {$IFDEF OS2}
          WinSubClassWindow(HMen,@FDefWndProc);
          WinDestroyWindow(HMen);
          If FParent <> Nil Then
          Begin
               WinSendMsg(FParent.Handle,WM_UPDATEFRAME,FCF_MENU,0);
          End;
          {$ENDIF}

          {$IFDEF Win32}
          DestroyMenu(HMen);
          If FParent <> Nil Then
          Begin
               DisposeMenuHandleItem(TForm(FParent),HMen,TComponent(Self));
               SetMenu(FParent.Handle,0);
          End;
          {$ENDIF}
     End;

     FItems.Destroy;
     FItems := Nil;
     If FAlternateFontName<>Nil Then DisposeStr(FAlternateFontName);
     FAlternateFontName:=Nil;

     Inherited Destroy;
End;


Const
   TMenuItemRegistered:Boolean=False;

Procedure TMenu.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Menu';

     FFont:=Screen.MenuFont;
     FParent := TControl(Owner);
     If Owner <> Nil Then SetDesigning(Owner.Designed);

     FItems.Create(Nil);
     FItems.FParent := Nil;
     FItems.FMenu := Self;
     FItems.SetDesigning(Designed);
     Include(FItems.ComponentState, csDetail);

     If Not TMenuItemRegistered Then
     Begin
          RegisterClasses([TMenuItem]); {RuntimeSCU}
          TMenuItemRegistered := True;
     End;
End;


Procedure TMenu.LoadResource;
Begin
     {$IFDEF OS2}
     WinLoadMenu(FParent.Handle,0,FResourceId);
     {$ENDIF}
     {$IFDEF Win32}
     SetMenu(FParent.Handle,LoadMenu(DllModule,MAKEINTRESOURCE(FResourceId)^));
     {$ENDIF}
End;


Procedure TMenu.CreateMenu;
Begin
     {$IFDEF OS2}
     FHandle:=WinCreateMenu(FParent.Handle,Nil);  {Empty Menu}
     If FHandle=0 Then
     Begin
          //ErrorBox2('Error creating menu');
          Exit;
     End;
     WinSetWindowULong(FHandle,QWL_USER,LongWord(Self));    {VMT Pointer}
     FDefWndProc:=Pointer(WinSubClassWindow(FHandle,@SubclassedMenuWndProc));
     {$ENDIF}

     {$IFDEF Win32}
     FHandle:=WinUser.CreateMenu;
     If FHandle=0 Then
     Begin
          //ErrorBox2('Error creating menu');
          Exit;
     End;
     NewMenuHandleItem(TForm(FParent){Parent},FHandle,TComponent(Self));
     {$ENDIF}

     If FFont<>Nil Then SetFont(FFont);
End;


Procedure TMenu.Show;
Begin
     If Not (IsControl(TControl(Owner))) Then Exit;
     If FParent = Nil Then Exit;
     If FParent.Handle = 0 Then Exit;

     If FResourceId<>0 Then
     Begin
          LoadResource;
          Exit;
     End;

     If FHandle=0 Then
     Begin
          CreateMenu;
          If FHandle = 0 Then Exit;

          FItems.CreateWnd;
          FItems.FCreated := True;
     End;

     If Not ((Self Is TMainMenu) Or (Self Is TPopupMenu)) Then
     Begin {?}
          {$IFDEF OS2}
          WinShowWindow(FHandle,True);
          {$ENDIF}
          {$IFDEF Win32}
          DrawMenuBar(FParent.Handle);
          {$ENDIF}
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPopupMenu Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPopupMenu.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'PopupMenu';
     FAutoPopup := True;
     FAlignment := paCenter;
     Include(ComponentState, csHandleLinks);
End;


Procedure TPopupMenu.CreateMenu;
Begin
     {$IFDEF OS2}
     Inherited CreateMenu;
     {$ENDIF}

     {$IFDEF Win32}
     FHandle:=WinUser.CreatePopupMenu;
     If FHandle=0 Then
     Begin
          //ErrorBox2('Error creating menu');
          Exit;
     End;
     NewMenuHandleItem(TForm(FParent),FHandle,TComponent(Self));
     {$ENDIF}
End;


Procedure TPopupMenu.Popup(X,Y:LongInt);
Var  {$IFDEF OS2}
     iditem:LongWord;
     AL:LongInt;
     {$ENDIF}
     {$IFDEF Win32}
     pt:TPoint;
     AL:Word;
     {$ENDIF}
Begin
     If Handle = 0 Then Show;
     If Handle = 0 Then Exit;

     If FOnPopup <> Nil Then FOnPopup(Self);

     {$IFDEF OS2}
     If (Width = 0) And (FAlignment = paRight) Then
     Begin //Create the Window outside Of the Screen To Get the Real Width
          WinPopupMenu(HWND_DESKTOP,Screen.FHiddenWindow.Handle,Handle,
                       Screen.Width,Screen.Height, 0, 0);
     End;

     If FItems.Count > 0 Then iditem := FItems.Items[0].FInternalCommand
     Else iditem := 0;

     AL := PU_HCONSTRAIN Or PU_VCONSTRAIN;
     Case FAlignment Of
       paCenter: AL := AL Or PU_POSITIONONITEM;
       paRight: Dec(X, Width);
     End;
     WinPopupMenu(HWND_DESKTOP,Screen.FHiddenWindow.Handle,Handle,X,Y,iditem,
                  AL Or PU_KEYBOARD Or PU_MOUSEBUTTON1);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.SetCursor(Screen.Cursors[crArrow]); {force Cursor}
     pt := Point(X,Y);
     TransformPointToWin32(pt,Nil,Nil);

     Case FAlignment Of
       paLeft: AL := TPM_LEFTALIGN;
       paCenter: AL := TPM_CENTERALIGN;
       paRight: AL := TPM_RIGHTALIGN;
     End;

     TrackPopupMenu(Handle,AL, pt.X,pt.Y,0,Screen.FHiddenWindow.Handle,Nil);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TMainMenu Class Implementation                              บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TMainMenu.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'MainMenu';
     Include(ComponentState, csHandleLinks);
End;


Procedure TMainMenu.Show;
{$IFDEF OS2}
Var  HMen:LongWord;
     ulStyle:LongWord;
{$ENDIF}
Begin
     If FParent Is TForm Then
       If TForm(FParent).Frame <> Nil
       Then FParent := TForm(FParent).Frame;

     Inherited Show;

     If FHandle=0 Then Exit;

     {$IFDEF OS2}
     HMen:=WinWindowFromID(FParent.Handle,FID_MENU);

     If HMen<>0 Then
     Begin
          WinSetParent(HMen,WinQueryObjectWindow(HWND_DESKTOP),False);
          WinSetOwner(HMen,WinQueryObjectWindow(HWND_DESKTOP));
     End;

     ulStyle:=WinQueryWindowULong(FHandle,QWL_STYLE);
     ulStyle:=ulStyle Or {MS_ROOT Or} MS_ACTIONBAR Or WS_CLIPSIBLINGS;
     ulStyle:=ulStyle And Not WS_SAVEBITS;
     WinSetWindowULong(FHandle,QWL_STYLE,ulStyle);
     WinSetWindowUShort(FHandle,QWS_ID,FID_MENU);

     WinSetParent(FHandle,FParent.Handle,False);
     WinSetOwner(FHandle,FParent.Handle);

     WinSendMsg(FParent.Handle,WM_UPDATEFRAME,FCF_MENU,0);
     {$ENDIF}

     {$IFDEF Win32}
     SetMenu(FParent.Handle,FHandle);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TForm Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
{$ENDIF}
{$IFDEF Win32}
Function SubclassedWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;APIENTRY;
{$ENDIF}
Var Control:TControl;
Const LastWnd:HWND=0;
      LastControl:TControl=Nil;
Begin
     {$IFDEF OS2}
     // AaronL - this is redundant given correctly written components
     // and must have a chunk of performance impact...
     If not WinIsWindow(AppHandle,Win) Then exit;
     {$ENDIF}

     If Win=LastWnd Then Control:=LastControl
     Else
     Begin
         If ((Msg>=WM_USER+1000)And(Msg<=WM_USER+1013)) Then //Web Messages
         Begin
             Control := HandleToControl(para1);
             If ((Control=Nil)Or(not (IsControl(Control)))) Then Control := HandleToControl(Win);
         End
         Else Control := HandleToControl(Win);                      {Get VMT Pointer}
         If Control=Nil Then exit; //do not handle
         LastWnd:=Win;
         LastControl:=Control;
     End;

     Asm
        PUSHL 0                 //Message.Result
        PUSHL para2             //Message.para2
        PUSHL para1             //Message.para1
        PUSHL 0                 //Message.Handled
        PUSHL Win               //Message.Receiver
        PUSHL Control           //Message.ReceiverClass
        PUSHL Msg               //Message.Message
        MOV   EDX,ESP
        PUSH  EDX               //Var Message
        PUSHL Control           //Self
        CALLN32 TControl.WndProc
        ADD   ESP,24
        POP   EAX               //Result
        MOV   Result,EAX
     End;
End;


{$IFDEF WIN32}
Var ModalArray:Array[1..50] Of TControl;

Const
     ModalCount:Byte=0;

Procedure LockDesktopWindows(Lock:Boolean;Exclude:TControl);
Var  T:LongInt;
     actual:TForm;
Begin
     For T := 0 To Screen.FForms.Count-1 Do
     Begin
          actual := Screen.FForms.Items[T];
          If Actual <> Exclude Then
          Begin
               If Lock Then
               Begin
                    //If ModalCount = 0 Then
                    If not Actual.FLocked Then
                    Begin
                         Actual.FOldEnabledState := Actual.FEnabled;
                         If Actual.FFrame <> Nil Then Actual.FFrame.Disable;
                    End;
                    Actual.Disable;
                    Actual.FLocked := True;
               End
               Else
               Begin
                    If ((ModalCount = 1)Or(Actual = ModalArray[ModalCount-1])) Then
                    Begin
                         Actual.FLocked := False;
                         If Actual.FOldEnabledState Or Actual.Designed
                         Then
                         Begin
                             If Actual.FFrame <> Nil Then Actual.FFrame.Enable;
                             Actual.Enable;
                         End;
                    End;
               End;
          End
          Else
          Begin
               If not Lock Then
               Begin
                  Actual.FLocked := False;
                  If Actual.FFrame <> Nil Then Actual.FFrame.Enable;
                  Actual.Enable;
               End;
          End;
     End;

     If Lock Then
     Begin
          Inc(ModalCount);
          ModalArray[ModalCount] := Exclude;
     End
     Else If ModalCount > 0 Then Dec(ModalCount);
End;
{$ENDIF}

{$IFDEF OS2}
Const
   CurrentModalForm:TControl=NIL;
   CurrentModalFrame:HWND=0;
   DesktopHWND:HWND=0;
   ModalList:TList=NIL;   

{$HINTS OFF}
// This message queue input hook swallows input to windows
// other than the current modal one.
// For mouse clicks, it also activates the modal window.
Function InputHook(ahab:HAB;VAR apqmsg:QMSG;fs:ULONG):Bool;CDecl;
Var  aHwnd,aHwnd1:HWND;
Begin
     Result := False;

     If DesktopHWND = 0 Then DesktopHWND := WinQueryDesktopWindow(AppHandle, 0);
     aHwnd := apqmsg.hwnd;

     // Let everything through except kb/mouse input...
     If not (apqmsg.msg IN [WM_CHAR,WM_VIOCHAR,WM_TRANSLATEACCEL,WM_SYSCOMMAND,
                            WM_MOUSEFIRST..WM_MOUSELAST]) Then exit;

     If (aHwnd = DesktopHWND) Or (aHwnd = 0) Then exit;

     While (aHwnd <> DesktopHWND) And (aHwnd <> 0) Do
     Begin
          // check if it is in the modal form
          If aHwnd = CurrentModalFrame Then exit;

          // check if it is a popup menu
          If aHwnd = Screen.FHiddenWindow.Handle Then exit;

          aHwnd1:=aHwnd;
          aHwnd := WinQueryWindow(aHwnd, QW_OWNER);

          If ((aHwnd=DesktopHWND)Or(aHwnd=0)) Then
          Begin
              //test Non SPCC form
              If aHwnd1<>0 Then
              Begin
                   //check if this is a memory pointer
                   If not IsControl(HandleToControl(aHwnd1)) Then exit;
              End;
          End;
     End;

     If apqmsg.msg in [ WM_BUTTON1DOWN, WM_BUTTON2DOWN, WM_BUTTON3DOWN ] Then
       If CurrentModalForm <> Nil Then
         CurrentModalForm.BringToFront;

     Result := True;
End;
{$HINTS ON}

// Hide or show existing task list entries - AaronL
Procedure ShowTaskListEntries( Show: Boolean;
                               Exclude: TControl );
var
     pSwitchListInfo : PSWBLOCK;
     SwitchListCount : longint;
     BufferSize : longint;
     i : longint;
     MyPID: longword;
Begin
     MyPID := GetCurrentProcessID;
     
     // Get the count of switch list items
     SwitchListCount := WinQuerySwitchList( AppHandle, nil, 0 );
     BufferSize := SwitchListCount * sizeof( SWENTRY ) + sizeof( ULONG );

     // Allocate buffer
     GetMem( pSwitchListInfo, BufferSize );
     
     // Call WinQuerySwitchList again to get the switch list items
     WinQuerySwitchList( AppHandle, pSwitchListInfo^, BufferSize );
     
     for i := 0 to SwitchListCount - 1 do
     begin
          with pSwitchListinfo^.swentry[ i ] do
          begin
               if swctl.idProcess = MyPID then
               begin
                    // This switch entry is for this application
                    if swctl.hwnd = Exclude.FFrame.Handle then
                         continue;                    
                    // so show/hide it
                    if Show then
                         swctl.uchVisibility := SWL_VISIBLE
                    else
                         swctl.uchVisibility := SWL_INVISIBLE;
                    WinChangeSwitchEntry( hswitch,
                                          swctl );
                                         
               end;
          end;
     end;

     // Free buffer
     FreeMem( pSwitchListInfo, BufferSize );
End;

// Show or hide a single form in the tasklist
Procedure ShowTaskListEntry( Show: Boolean;
                             Form: TControl );
var
  SwitchHandle: HSWITCH;
  SwitchEntry: SWCNTRL;
begin
  SwitchHandle := WinQuerySwitchHandle( Form.FFrame.Handle, 0 );
  if SwitchHandle = NULLHANDLE then
       // Form isn't in task list...
       exit;
  WinQuerySwitchEntry( SwitchHandle, SwitchEntry );
  if Show then
       SwitchEntry.uchVisibility := SWL_VISIBLE
  else
       SwitchEntry.uchVisibility := SWL_INVISIBLE;
  WinChangeSwitchEntry( SwitchHandle, SwitchEntry );
end;

Procedure LockDesktopWindows(Lock:Boolean;Exclude:TControl);
Var  t:LongInt;
     aForm:TForm;
     EnableForm: boolean;
Begin
     If Lock Then
     Begin
          If ModalList = Nil Then ModalList.Create;
          If ModalList.Count = 0 Then
               // Hide main window(s) from tasklist
               ShowTaskListEntries( false, Exclude )
          else
               // Hide current modal form from tasklist
               ShowTaskListEntry( false, CurrentModalForm );

          ModalList.Insert(0, Exclude);
          CurrentModalForm := Exclude;
          CurrentModalFrame := Exclude.FFrame.Handle;

          If ModalList.Count = 1 Then
          Begin
               WinSetHook(
                  AppHandle,
                  HMQ_CURRENT,
                  HK_INPUT,
                  @InputHook,
                  0);
          End
     End
     Else
     Begin
          ModalList.Remove(Exclude);

          If ModalList.Count = 0 Then
          Begin
               CurrentModalForm := Nil;
               CurrentModalFrame := 0;

               // Show main window(s) in tasklist
               ShowTaskListEntries( true, Exclude );

               WinReleaseHook(
                 AppHandle,
                 HMQ_CURRENT,
                 HK_INPUT,
                 @InputHook,
                 0);

               ModalList.Destroy;
               ModalList := Nil;
          End
          Else
          Begin
               CurrentModalForm := TControl(ModalList[0]);
               CurrentModalFrame := CurrentModalForm.FFrame.Handle;

               // Show previous dialog in tasklist
               ShowTaskListEntry( true, CurrentModalForm );
          End;
     End;

     For t := 0 To Screen.FForms.Count-1 Do
     Begin
          aForm := Screen.FForms.Items[t];
          EnableForm := true;
          If CurrentModalForm <> Nil Then
               If aForm.Visible Then
                    if aForm <> CurrentModalForm then
                         EnableForm := false;
          aForm.FLocked := not EnableForm;
     End;
End;
{$ENDIF}

Procedure TForm.SetPosition(NewValue:TPosition);
Begin
    If NewValue<>FPosition Then
    Begin
         FPosition:=NewValue;
         If Not (csDesigning In ComponentState) Then RecreateWnd;
    End;
End;


Function TForm.GetLanguage:String;
Var S:String;
Begin
    Asm
       PUSH DWord Ptr Self
       LEA EAX,s
       PUSH EAX
       CALLN32 Classes.GetLanguage
    End;
    Result:=S;
End;


Procedure TForm.SetLanguage(Const NewLanguage:String);
Begin
     Asm
        PUSH DWord Ptr Self
        PUSH DWord Ptr NewLanguage
        CALLN32 Classes.SetLanguage
     End
End;

Const DdeMan_WMDDEDestroy:Procedure(Var Msg:TMessage)=Nil;
      DdeMan_WMDdeInitiate:Procedure(Self:TForm;Var Msg:TMessage)=Nil;
      DdeMan_OpenClientLinks:Procedure(Form:TForm)=Nil;
      DdeMan_CloseClientLinks:Procedure(Form:TForm)=Nil;
      DdeMan_CloseAllLinks:Procedure=Nil;

{$IFDEF OS2}
Procedure TForm.WMDDEDestroy(Var Msg:TMessage);
Begin
     If DdeMan_WMDdeDestroy<>Nil Then DdeMan_WMDdeDestroy(Msg);
End;
{$ENDIF}

{$IFDEF OS2}
Procedure TForm.WMDDEInitiate(Var Msg:TMessage);
Begin
     If DdeMan_WMDdeInitiate<>Nil Then DdeMan_WMDdeInitiate(Self,Msg);
End;
{$ENDIF}


{$HINTS OFF}
Procedure TForm.MenuInit(AMenu:TMenu;entry:TMenuItem);
Begin
     If FOnMenuInit <> Nil Then FOnMenuInit(Self,AMenu,entry);
End;

Procedure TForm.MenuEnd(AMenu:TMenu;entry:TMenuItem);
Begin
     If FOnMenuEnd <> Nil Then FOnMenuEnd(Self,AMenu,entry);
End;

Procedure TForm.MenuItemFocus(AMenu:TMenu;entry:TMenuItem);
Begin
     If OnMenuItemFocus <> Nil Then OnMenuItemFocus(Self,AMenu,entry);
End;

Procedure TForm.MenuCharEvent(AMenu:TMenu;entry:TMenuItem;Var key:Char;REP:Byte);
Begin
End;

Procedure TForm.MenuScanEvent(AMenu:TMenu;entry:TMenuItem;Var KeyCode:TKeyCode;REP:Byte);
Begin
End;
{$HINTS ON}


Procedure TForm.Activate;
Begin
     If OnActivate <> Nil Then OnActivate(Self);
End;


Procedure TForm.Deactivate;
Begin
     If OnDeactivate <> Nil Then OnDeactivate(Self);
End;


Procedure TForm.WMActivate(Var Msg:TWMActivate);
Begin
     If Application <> Nil Then Application.DestroyHintWindow;

     {$IFDEF OS2}
     If Msg.Active Then
     {$ENDIF}
     {$IFDEF Win32}
     If Msg.Active <> WA_INACTIVE Then
     {$ENDIF}
     Begin
          {
          If FLocked Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
               Exit;
          End;
          }

          If Parent = Nil Then Screen.FActiveForm := Self;
          Activate;
     End
     Else Deactivate;

     Screen.UpdateLastActive;
End;


Procedure TForm.Release;
Begin
     {$IFDEF OS2}
     If Handle <> 0 Then PostMsg(Handle,CM_RELEASE,0,0)
     Else Self.Destroy;
     {$ENDIF}
     {$IFDEF WIN32}
     Self.Destroy;
     {$ENDIF}
End;


Procedure TForm.CMRelease(Var Msg:TMessage);
Begin
     Self.Destroy;
     Msg.Handled := True;
End;


{$IFDEF OS2}
Procedure TForm.WMClose(Var Msg:TWMClose);
Begin
     Close;

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TForm.WMInitMenu(Var Msg:TMessage);
Var  Win:LongWord;
     AMenu:TMenu;
     entry:TMenuItem;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     Win := Msg.Param2;
     entry := Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then AMenu := entry.FMenu
     Else
     Begin
          AMenu := TMenu(entry);
          If Not (AMenu Is TMenu) Then AMenu := Nil;
          entry := Nil;
     End;

     MenuInit(AMenu,entry);
End;


Procedure TForm.WMMenuEnd(Var Msg:TMessage);
Var  Win:LongWord;
     AMenu:TMenu;
     entry:TMenuItem;
Begin
     Win := Msg.Param2;
     entry := Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then AMenu := entry.FMenu
     Else
     Begin
          AMenu := TMenu(entry);
          If Not (AMenu Is TMenu) Then AMenu := Nil;
          entry := Nil;
     End;

     MenuEnd(AMenu,entry);

     Application.Hint := '';
End;


Procedure TForm.WMMenuSelect(Var Msg:TMessage);
Var  Win:LongWord;
     AMenu:TMenu;
     entry:TMenuItem;
Begin
     Win := Msg.Param2;
     entry := Pointer(WinQueryWindowULong(Win,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then
     Begin
          AMenu := entry.FMenu;
          If AMenu = Nil Then Exit;
     End
     Else
     Begin
          AMenu := TMenu(entry);
          If Not (AMenu Is TMenu) Then Exit;
     End;

     entry := Menu.ItemFromInternalCommand(Msg.Param1Lo);

     MenuItemFocus(AMenu,entry);

     If entry <> Nil Then Application.Hint := GetLongHint(entry.Hint)
     Else Application.Hint := '';
End;
{$ENDIF}


Procedure TForm.CMUpdateButtons(Var Msg:TMessage);
Begin
     Case Msg.Param1 Of
       1: DefaultButton := TControl(Msg.Param2);
       2: CancelButton := TControl(Msg.Param2);
       3: Msg.Result := LongWord(DefaultButton);
       4: Msg.Result := LongWord(CancelButton);
     End;
     Msg.Handled := True;
End;


Procedure TForm.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Var  aMsg:TMessage;
Begin
     Inherited ScanEvent(KeyCode,RepeatCount);

     Case KeyCode Of
       {$IFDEF OS2}
       kbEnter,
       {$ENDIF}
       kbCR:
       Begin
            Try
               If Not (IsControl(DefaultButton)) Then DefaultButton := Nil;
            Except
               DefaultButton := Nil;
            End;

            If DefaultButton <> Nil Then
              If DefaultButton.Enabled Then
                If DefaultButton.Visible Then
            Begin
                 FillChar(aMsg,SizeOf(aMsg),0);
                 {ReceiverClass = 0 -> no Default handler Is called}
                 {$IFDEF OS2}
                 aMsg.Msg := WM_CONTROL;
                 {$ENDIF}
                 {$IFDEF Win32}
                 aMsg.Msg := WM_COMMAND;
                 {$ENDIF}
                 aMsg.Param1Lo := DefaultButton.FWindowId;
                 aMsg.Param1Hi := BN_CLICKED;
                 DefaultButton.ParentNotification(aMsg); {causes Click}
                 If aMsg.Handled Then KeyCode := kbNull;
            End;
       End; {Case}
       kbEsc:
       Begin
            Try
               If Not (IsControl(CancelButton)) Then CancelButton := Nil;
            Except
               CancelButton := Nil;
            End;

            If CancelButton <> Nil Then
             If CancelButton.Enabled Then
                If CancelButton.Visible Then
            Begin
                 FillChar(aMsg,SizeOf(aMsg),0);
                 {ReceiverClass = 0 -> no Default handler Is called}
                 {$IFDEF OS2}
                 aMsg.Msg := WM_CONTROL;
                 {$ENDIF}
                 {$IFDEF Win32}
                 aMsg.Msg := WM_COMMAND;
                 {$ENDIF}
                 aMsg.Param1Lo := CancelButton.FWindowId;
                 aMsg.Param1Hi := BN_CLICKED;
                 CancelButton.ParentNotification(aMsg); {causes Click}
            End;
            KeyCode := kbNull; {!}
       End;
     End;
End;


{$IFDEF OS2}
Procedure TForm.WMTranslateAccel(Var Msg:TMessage);
Var  fsFlags:Word;
     ascii:Word;
     virtkey:Word;
     scan:TKeyCode;
     Param:TKeyCode;
     apqmsg:^QMSG;
     Receiver:TForm;
Label lsc;
Begin
     If FLocked Then Exit;

     apqmsg:=Pointer(Msg.Param1);

     fsFlags := Lo(apqmsg^.mp1);
     virtkey := Hi(apqmsg^.mp2); {Valid If KC_VIRTKEY}
     scan := Hi(apqmsg^.mp1);    {Valid If KC_SCANCODE}
     ascii := Lo(apqmsg^.mp2);   {Valid If KC_CHAR}

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or  (fsFlags And KC_CTRL <> 0) Then Goto lsc;
          If (fsFlags And KC_VIRTUALKEY <> 0) And (fsFlags And KC_SHIFT <> 0)
          Then Goto lsc;    {numerical block}
          Param := ascii;
     End
     Else
     Begin
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else If fsFlags And KC_KEYUP <> 0 Then Exit {!}
               Else Param := ascii Or kb_Char;  {E.G. Ctrl-J}

          If virtkey = VK_ALT Then Param := Param Or kb_Alt;
          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;
     End;

     Receiver := Nil;
     TranslateShortCut(Param, Receiver);
     If Receiver Is TForm Then Receiver.ForwardShortCut(Msg);
End;
{$ENDIF}


{$HINTS OFF}
Procedure TForm.TranslateShortCut(KeyCode:TKeyCode;Var Receiver:TForm);
Begin
     If OnTranslateShortCut <> Nil Then OnTranslateShortCut(Self,KeyCode,Receiver);
End;
{$HINTS ON}


{als Reaktion auf eine TranslateShortCut event}
{$HINTS OFF}
Procedure TForm.ForwardShortCut(Var Msg:TMessage);
{$IFDEF OS2}
Var  apqmsg:^QMSG;
{$ENDIF}
Begin
     {$IFDEF OS2}
     apqmsg := Pointer(Msg.Param1);
     If apqmsg^.HWND = Handle Then Exit;     {prevent recursion}
     apqmsg^.HWND := Handle;
     WinSendMsg(Handle,WM_TRANSLATEACCEL,Msg.Param1,Msg.Param2);
     Msg.Handled := True;
     Msg.Result := 1;
     {$ENDIF}
End;
{$HINTS ON}

Var IconClass:TGraphicClass;
    BitmapClass:TGraphicClass;

Function TForm.GetFormImage:TGraphic;
Var
    FDC,FPS,FHandle,ScreenPS:LongWord;
    {$IFDEF WIN95}
    rec:TRect;
    {$ENDIF}
    {$IFDEF OS2}
    sizl:SIZEL;
    bmp2:BITMAPINFOHEADER2;
    aptl:ARRAY[0..2] OF TPoint;
    {$ENDIF}
Begin
     Result:=Nil;

     {$IFDEF OS2}
     FDC:=DevOpenDC(AppHandle,OD_MEMORY,'*',0,NIL,0) ;
     sizl.cx:=0;
     sizl.cy:=0;
     FPS:=GpiCreatePS(AppHandle,FDC,sizl,
                      PU_PELS OR GPIF_DEFAULT OR GPIT_MICRO OR GPIA_ASSOC);
     FillChar(bmp2,sizeof(BITMAPINFOHEADER2),0);
     bmp2.cbFix:=sizeof(BITMAPINFOHEADER2);
     bmp2.cx:=Width;
     bmp2.cy:=Height;
     bmp2.cPlanes:=1;
     bmp2.cBitCount:=8;
     FHandle:=GpiCreateBitmap (FPS,bmp2,0,NIL,NIL);
     {$ENDIF}
     {$IFDEF Win95}
     FDC:=CreateDC('DISPLAY',NIL,NIL,NIL);
     FPS:=CreateCompatibleDC(FDC);
     FHandle:=CreateCompatibleBitmap(FDC,Width,Height);
     SelectObject(FPS,FHandle);
     {$ENDIF}

     {$IFDEF Win95}
     ScreenPS:=FDC;

     rec:=WindowRect;
     RectToWin32Rect(rec);
     TransformRectToWin32(rec,NIL,NIL);

     WinGDI.BitBlt(FPS,0,0,Width,Height,ScreenPS,
                   rec.Left,rec.Bottom,SRCCOPY);

     DeleteObject(SelectObject(ScreenPS,0));
     {$ENDIF}
     {$IFDEF OS2}
     ScreenPS:=WinGetScreenPS(HWND_DESKTOP);
     GpiCreateLogColorTable(ScreenPS,LCOL_RESET,LCOLF_RGB,0,0,NIL);

     GpiSetBitmap (FPS,FHandle);
     aptl[0].x:=0;
     aptl[0].y:=0;
     aptl[1].x:=Width;
     aptl[1].y:=Height;
     aptl[2].x:=Left;
     aptl[2].y:=Bottom;
     GpiBitBlt (FPS,ScreenPS,3,aptl[0],ROP_SRCCOPY,BBO_IGNORE) ;

     // GpiDeleteSetId (ScreenPS,LCID_DEFAULT) ; aaronl
     WinReleasePS(ScreenPS);
     {$ENDIF}

     If BitmapClass=Nil Then exit;
     Result:=TGraphic(BitmapClass.Create);
     Result.CreatePalette:=True;
     Result.LoadFromHandle(FHandle);

     {$IFDEF Win95}
     DeleteObject(SelectObject(FPS,0));
     DeleteDC(FPS);
     DeleteDC(FDC);
     {$ENDIF}
     {$IFDEF OS2}
     GpiSetBitmap(FPS,0);
     GpiSelectPalette(FPS,0);
     GpiDeleteBitmap(FHandle);
     WinReleasePS(FPS);
     DevCloseDC(FDC);
     {$ENDIF}
End;

Procedure TForm.Print(Canvas:TCanvas;Dest:TRect);
Var FormImage:TGraphic;
Begin
     FormImage:=GetFormImage;
     FormImage.Draw(Canvas,Dest);
     FormImage.Destroy;
End;

Procedure TForm.SetIcon(NewIcon:TGraphic);
Begin
     If ((FIcon<>Nil)And(FIcon<>NewIcon)And(FIcon.FIsLocalCopy)) Then
     Begin
          FIcon.Destroy;
          FIcon:=Nil;
     End;

     If ((NewIcon<>Nil)And(NewIcon<>FIcon)And(NewIcon.FIsLocalCopy)And(IconClass<>Nil)) Then
     Begin
          //Create A Copy !!
          Try
             NewIcon:=NewIcon.CopyGraphic;
             NewIcon.FIsLocalCopy:=True;
          Except
             NewIcon:=Nil;
          End;
     End;

     FIcon := NewIcon;

     If ((FIcon<>Nil)And(FIcon.FIsLocalCopy)) Then FIcon.FOnChangedNotify:=IconChanged;

     If ((Frame<>Nil)And(Handle<>0)And(Frame.Handle<>0)) Then
     Begin
          {$IFDEF OS2}
          If ((FIcon=Nil)Or(FIcon.Empty)) Then WinSendMsg(Frame.Handle,WM_SETICON,0,0)
          Else WinSendMsg(Frame.Handle,WM_SETICON,FIcon.Handle,0);
          {$ENDIF}
          {$IFDEF Win95}
          //SendMessage(Frame.Handle,WM_SETICON,ICON_BIG,FIcon);
          If ((FIcon=Nil)Or(FIcon.Empty)) Then SendMessage(Frame.Handle,WM_SETICON,ICON_SmalL,0)
          Else SendMessage(Frame.Handle,WM_SETICON,ICON_SMALL,FIcon.Handle);
          {$ENDIF}
     End;
End;


Procedure TForm.IconChanged(Sender:TObject);
Begin
     If TGraphic(Sender)=FIcon Then Icon:=TGraphic(Sender)
     Else TGraphic(Sender).FOnChangedNotify:=Nil;
End;


Function TForm.GetIcon:TGraphic;
Begin
     If FIcon = Nil Then
       If IconClass <> Nil Then
     Begin //Create Empty
          FIcon := TGraphic(IconClass.Create);
          FIcon.FIsLocalCopy := True;
     End;
     Result := FIcon;
End;


Procedure TForm.SetMainMenu(AMenu:TMainMenu);
{$IFDEF OS2}
Var  HMen:LongWord;
{$ENDIF}
Begin
     FMainMenu := AMenu;

     If FMainMenu <> Nil Then
     Begin
          //FMainMenu.ComponentIndex := 0;   {the First MainMenu Is Visible}
          If Handle <> 0 Then FMainMenu.Show
          Else FInitControls := True;
     End
     Else
     If FFrame <> Nil Then {Clear the main Menu}
     Begin
          {$IFDEF OS2}
          HMen := WinWindowFromID(FFrame.Handle,FID_MENU);

          If HMen <> 0 Then
          Begin
               WinSetParent(HMen,WinQueryObjectWindow(HWND_DESKTOP),False);
               WinSetOwner(HMen,WinQueryObjectWindow(HWND_DESKTOP));
               WinSendMsg(FFrame.Handle,WM_UPDATEFRAME,FCF_MENU,0);
          End;
          {$ENDIF}
          {$IFDEF Win32}
          SetMenu(FFrame.Handle,0);
          {$ENDIF}
     End;
End;

Procedure TForm.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     BringToFront;
End;


Procedure TForm.SetFocus;
Begin
     Inherited SetFocus;
     If FFormStyle = fsMDIChild Then
        If Parent Is TForm Then TForm(Parent).FTopMDIChild := Self;
End;


Procedure TForm.Resize;
Begin
     Inherited Resize;

     {Make sure, that the Toolbars Do Not Draw over the Frame border}
     If IsWindowVisible Then
     Begin
          If ClientWidth < 1 Then  ClientWidth := 1;
          If ClientHeight < 1 Then ClientHeight := 1;
     End;
End;


Function TForm.GetFrameFlags:LongWord;
Type
    {Standard Frame Window styles}
    TFrameStyle=(wbsTitleBar, wbsSysMenu, wbsMenu, wbsTaskList,
                 wbsMinButton, wbsMaxButton, wbsHideButton,
                 wbsSizeBorder, wbsDlgBorder, wbsBorder,
                 wbsShellPosition, wbsNoMoveWithOwner,
                 wbsAutoIcon, wbsIcon, wbsAccelTable, wbsSysModal,
                 wbsNoByteAlign, wbsScreenAlign, wbsMouseAlign,wbsHelp);
    TFrameStyles=Set Of TFrameStyle;
Const
     {$IFDEF OS2}
     FrameFlags:Array[Low(TFrameStyle)..High(TFrameStyle)] Of LongWord=
             (FCF_TITLEBAR, FCF_SYSMENU, FCF_MENU, FCF_TASKLIST,
              FCF_MINBUTTON, FCF_MAXBUTTON, FCF_HIDEBUTTON,
              FCF_SIZEBORDER, FCF_DLGBORDER, FCF_BORDER,
              FCF_SHELLPOSITION, FCF_NOMOVEWITHOWNER{WS_EX_ABSPOSITION},
              FCF_AUTOICON, FCF_ICON, FCF_ACCELTABLE, FCF_SYSMODAL,
              FCF_NOBYTEALIGN, FCF_SCREENALIGN, FCF_MOUSEALIGN,0);
     {$ENDIF}
     {$IFDEF Win32}
     FrameFlags:Array[Low(TFrameStyle)..High(TFrameStyle)] Of LongWord=
             (WS_CAPTION, WS_SYSMENU, 0, 0,
              WS_MINIMIZEBOX, WS_MAXIMIZEBOX, 0,
              WS_THICKFRAME, WS_DLGFRAME OR DS_MODALFRAME, WS_BORDER,
              0,0,0,0,0,0,0,0,0,0);
     {$ENDIF}
Var  T:TFrameStyle;
     Flags:TFrameStyles;
Begin
     Result := 0;
     Flags := [wbsNoByteAlign];
     If Designed Then
     Begin
          Flags := Flags + [wbsTitleBar,wbsTaskList,wbsSizeBorder,wbsSysMenu];
     End
     Else
     Begin
          // Runtime flags are defined by various settings.
          Case FBorderStyle Of
            bsNone: ;
            bsSingle:   Include(Flags,wbsBorder);
            bsSizeable: Include(Flags,wbsSizeBorder);
            bsDialog: Include(Flags,wbsDlgBorder);
          End;

          if FOptions.TitleBar then
          begin
            Include( Flags, wbsTitleBar );

            If biSystemMenu In FBorderIcons Then Include(Flags,wbsSysMenu);
            If biMinimize In FBorderIcons Then Include(Flags,wbsMinButton);
            If biMaximize In FBorderIcons Then Include(Flags,wbsMaxButton);
            if biHelp in FBorderIcons then Include(Flags,wbsHelp);
          end;

          if     FOptions.TaskListEntry
             and ( FParent = nil ) then
            Include( Flags, wbsTaskList );

     End;

     For T := Low(TFrameStyle) To High(TFrameStyle) Do
        If Flags * [T] <> [] Then Result := Result Or FrameFlags[T];

     {$IFDEF OS2}
     If FDBCSStatusLine Then Result := Result Or FCF_DBE_APPSTAT;
     {$ENDIF}
End;


Procedure TForm.SetWindowState(NewState:TWindowState);
Var  Win:LongWord;
     WinStyle:LongWord;
     {$IFDEF Win32}
     Placement:WINDOWPLACEMENT;
     {$ENDIF}
Begin
     FWindowState := NewState;
     If Designed Then Exit;

     If Frame = Nil Then Exit;
     Win := Frame.Handle;
     If Win = 0 Then Exit;

     {$IFDEF OS2}
     Case NewState Of
        wsNormal:    WinStyle := SWP_RESTORE;
        wsMinimized: WinStyle := SWP_MINIMIZE;
        wsMaximized: WinStyle := SWP_MAXIMIZE;
     End;
     WinSetWindowPos(Win,HWND_TOP,0,0,0,0,WinStyle);
     {$ENDIF}

     {$IFDEF Win32}
     Case NewState Of
        wsNormal:    WinStyle := SW_NORMAL;
        wsMinimized: WinStyle := SW_SHOWMINIMIZED;
        wsMaximized: WinStyle := SW_SHOWMAXIMIZED;
     End;
     FillChar(Placement,SizeOf(Placement),0);
     Placement.Length := SizeOf(WINDOWPLACEMENT);
     GetWindowPlacement(Win,Placement);
     Placement.ShowCmd := WinStyle;        {alten l”schen?}
     SetWindowPlacement(Win,Placement);
     {$ENDIF}
End;


Function TForm.GetWindowState:TWindowState;
Var  Win:LongWord;
     WinStyle:LongWord;
     {$IFDEF Win32}
     Placement:WINDOWPLACEMENT;
     {$ENDIF}
Begin
     Result := FWindowState;
     If Designed Then Exit;

     If Frame = Nil Then Exit;
     Win := Frame.Handle;
     If Win = 0 Then Exit;

     {$IFDEF OS2}
     WinStyle := WinQueryWindowULong(Win,QWL_STYLE);
     If WinStyle And WS_MAXIMIZED <> 0 Then Result := wsMaximized
     Else
     If WinStyle And WS_MINIMIZED <> 0 Then Result := wsMinimized
     Else Result := wsNormal;
     {$ENDIF}

     {$IFDEF Win32}
     FillChar(Placement,SizeOf(Placement),0);
     Placement.Length := SizeOf(WINDOWPLACEMENT);
     GetWindowPlacement(Win,Placement);
     WinStyle := Placement.ShowCmd;
     If WinStyle = SW_SHOWMAXIMIZED Then Result := wsMaximized
     Else
     If WinStyle = SW_SHOWMINIMIZED Then Result := wsMinimized
     Else Result := wsNormal;
     {$ENDIF}
End;


Procedure TForm.SetBorderIcons(NewIcons:TBorderIcons);
Begin
     If (Handle = 0) Or Designed Then FBorderIcons := NewIcons;
End;


Procedure TForm.SetBorderStyle(NewStyle:TFormBorderStyle);
Begin
     If (Handle = 0) Or Designed Then FBorderStyle := NewStyle;
End;


Function TForm.GetTabOrder:LongInt;
Begin
     Result := -1;
End;

Procedure TForm.SetDBCSStatusLine(Value:Boolean);
Begin
     If Handle = 0 Then FDBCSStatusLine := Value;
End;


Function TForm.GetAddWidth:LongInt;
Begin
     Result := GetBorderWidth(Self);

     Inc(Result,Result);

     Inc(Result,GetLeftRightWidth(Self));
End;


Function TForm.GetAddHeight:LongInt;
Begin
     Result := GetBorderHeight(Self);

     Inc(Result,Result);

     If FMainMenu <> Nil Then
     Begin
          If FMainMenu.Handle <> 0 Then Inc(Result,FMainMenu.Height)
          Else Inc(Result,Screen.SystemMetrics(smCyMenu));
     End
     Else If ComponentState*[csHasMainMenu]<>[] Then
     Begin
          Inc(Result,Screen.SystemMetrics(smCyMenu));
     End;

     Inc(Result,Screen.SystemMetrics(smCyTitlebar));

     Inc(Result,GetTopBottomHeight(Self));

     If FDBCSStatusLine Then Inc(Result,DBCSStatusLineHeight);
End;


Function _GetAddWidth_(Form:TForm):LongInt;
Begin
     Result:=Form.GetAddWidth;
End;

Function _GetAddHeight_(Form:TForm):LongInt;
Begin
     Result:=Form.GetAddHeight;
End;


Function TForm.GetClientRect:TRect;
Begin
     Result := Inherited GetClientRect;

     If ( Handle = 0 ) Then
     Begin
          Dec(Result.Right, GetAddWidth);
          Dec(Result.Top, GetAddHeight);
     End;
End;


Procedure TForm.SetClientWidth(NewWidth:LongInt);
Begin
     Inc(NewWidth, GetAddWidth);

     Inherited SetClientWidth(NewWidth);
End;


Procedure TForm.SetClientHeight(NewHeight:LongInt);
Begin
     Inc(NewHeight, GetAddHeight);

     Inherited SetClientHeight(NewHeight);
End;


Function TForm.GetClientOrigin:TPoint;
Var List:TList;
    T:LongInt;
    Toolbar:TToolbar;
Begin
     Result := Inherited GetClientOrigin;

     Case FBorderStyle Of
       bsSingle:
       Begin
            Inc(Result.X, Screen.SystemMetrics(smCxBorder));
            Inc(Result.Y, Screen.SystemMetrics(smCyBorder));
       End;
       bsSizeable:
       Begin
            Inc(Result.X, Screen.SystemMetrics(smCxSizeBorder));
            Inc(Result.Y, Screen.SystemMetrics(smCySizeBorder));
       End;
       bsDialog:
       Begin
            Inc(Result.X, Screen.SystemMetrics(smCxDlgBorder));
            Inc(Result.Y, Screen.SystemMetrics(smCyDlgBorder));
       End;
     End;

     List:=FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result.X,Toolbar.Size);
     End;

     List:=FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(Result.Y,Toolbar.Size);
     End;

     If FDBCSStatusLine Then Inc(Result.Y,DBCSStatusLineHeight);
End;


Procedure TForm.RealignControls;
Var  Control:TControl;
     T,I:LongInt;
     LastFocus:TForm;
Begin
     Inherited RealignControls;

     {Align MDI Child windows again}
     If FMDIChildren = Nil Then Exit;

     LastFocus := FTopMDIChild;
     If LastFocus <> Nil Then
     Begin
          I := FMDIChildren.Remove(LastFocus);
          FMDIChildren.Add(LastFocus);
     End;

     If FMDIChildren <> Nil Then
     For T := 0 To FMDIChildren.Count-1 Do
     Begin
          Control := FMDIChildren.Items[T];
          If IsControl(Control) Then
            If (Control.XAlign In [xaLeft,xaRight,xaCenter]) Or
               (Control.YAlign In [yaBottom,yaTop,yaCenter]) Or
               (Control.XStretch In [xsParent,xsFrame,xsScale]) Or
               (Control.YStretch In [ysParent,ysFrame,ysScale]) Then
          Begin
               Control.SetWindowPos(Control.Left,Control.Bottom,
                                    Control.Width,Control.Height);
          End;
     End;

     If LastFocus <> Nil Then      {back To original Position}
       If I >= 0 Then FMDIChildren.Move(FMDIChildren.Count-1,I);
End;


Procedure TForm.AlignToolBars;
{$IFDEF Win32}
Var  T:TToolbarAlign;
     ToolBar:TToolBar;
     t1,t2:LongInt;
     List:TList;
     rc,rc1:TRect;
     _Left,_Bottom,_Width,_Height:LongInt;
     TheBottom,TheLeft,TheTop,TheRight:LongInt;
     MaxLeft,MaxRight,MaxBottom,MaxTop:LongInt;

     Procedure AlignToolBar(ToolBar:TToolBar);
     Begin
        If Toolbar.FVisible Then
        Begin
             Case t Of
                tbTop:
                Begin
                     Toolbar.FLeft:=rc.Left-MaxLeft;
                     Toolbar.FBottom:=TheTop;
                     Toolbar.FWidth:=(rc.Right+1-rc.Left)+MaxLeft+MaxRight;
                     Toolbar.FHeight:=Toolbar.Size;
                     Inc(TheTop,Toolbar.Size);
               End;
               tbBottom:
               Begin
                    Toolbar.FLeft:=rc.Left-MaxLeft;
                    Toolbar.FBottom:=TheBottom;
                    Toolbar.FWidth:=(rc.Right+1-rc.Left)+MaxLeft+MaxRight;
                    Toolbar.FHeight:=Toolbar.Size;
                    inc(TheBottom,Toolbar.Size);
               End;
               tbLeft:
               Begin
                    Toolbar.FLeft:=rc.Left-MaxLeft+TheLeft;
                    Toolbar.FBottom:=MaxTop;
                    Toolbar.FWidth:=Toolbar.Size;
                    Toolbar.FHeight:=(rc.Top+1-rc.Bottom);
                    Inc(TheLeft,Toolbar.Size);
               End;
               tbRight:
               Begin
                    Toolbar.FLeft:=rc.Right+1+TheRight-Toolbar.Size;
                    Toolbar.FBottom:=MaxTop;
                    Toolbar.FWidth:=Toolbar.Size;
                    Toolbar.FHeight:=(rc.Top+1-rc.Bottom);
                    Dec(TheRight,Toolbar.Size);
               End;
             End; {Case}

             If Toolbar.Handle <> 0
             Then WinUser.SetWindowPos(Toolbar.Handle,0,
                                       Toolbar.FLeft,
                                       Toolbar.FBottom,
                                       Toolbar.FWidth,
                                       Toolbar.FHeight,
                                       SWP_SHOWWINDOW);
        End; //If Toolbar.FVisible

     End;
{$ENDIF}
Begin
     If Frame = Nil Then Exit;
     If Frame.Handle = 0 Then Exit;

     {$IFDEF Win32}
     rc := Frame.GetClientRect;

     MaxLeft:=0;
     List:=FToolBarLists[tbLeft];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
     End;

     MaxRight:=0;
     List:=FToolBarLists[tbRight];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
     End;

     MaxBottom:=0;
     List:=FToolBarLists[tbBottom];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxBottom,Toolbar.Size);
     End;

     MaxTop:=0;
     List:=FToolBarLists[tbTop];
     If List<>Nil Then For t1:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[t1]);
          If Toolbar.FVisible Then Inc(MaxTop,Toolbar.Size);
     End;

     //windows coordinates Grow from Top To Bottom !
     TheBottom:=(rc.Top+1-rc.Bottom)+MaxTop;
     TheTop:=0;
     TheLeft:=0;
     TheRight:=MaxRight;

     //zuerst Top und Bottom !
     For t := High(TToolbarAlign) Downto Low(TToolbarAlign) Do
     Begin
          List:=FToolBarLists[t];

          If List=Nil Then continue;

          If t=tbBottom Then
          Begin
               For t2:=List.Count-1 DownTo 0 Do AlignToolBar(TToolBar(List[t2]));
          End
          Else
          Begin
               For t2:=0 To List.Count-1 Do AlignToolBar(TToolBar(List[t2]));
          End;
     End;

     {ClientBereich}
     If Handle = 0 Then Exit;
     WinUser.GetClientRect(Frame.Handle,RECTL(rc1));
     rc := Frame.GetClientRect;
     _Width := rc.Right-rc.Left+1;
     _Height := rc.Top-rc.Bottom+1;
     _Left := rc.Left;
     _Bottom := ((rc1.Top-rc1.Bottom)-_Height)-rc.Bottom;
     WinUser.SetWindowPos(Handle,0,_Left,_Bottom,_Width,_Height, SWP_SHOWWINDOW);
     {$ENDIF}

     {$IFDEF OS2}
     WinSendMsg(Frame.Handle, WM_UPDATEFRAME, GetFrameFlags, 0);
     {$ENDIF}
End;


Procedure TForm.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Begin
     If FFrame <> Nil Then
     Begin
          FFrame.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
          {$IFDEF OS2}
          FLeft := Frame.FLeft;
          FBottom := Frame.FBottom;
          FWidth := Frame.FWidth;
          FHeight := Frame.FHeight;
          {$ENDIF}
          Exit;
     End;
     Inherited SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
End;


{$HINTS OFF}
Procedure TForm.MDIActivate(Child:TForm);
Begin
     If OnMDIActivate <> Nil Then OnMDIActivate(Self,Child);
End;


Procedure TForm.MDIDeactivate(Child:TForm);
Begin
     If OnMDIDeactivate <> Nil Then OnMDIDeactivate(Self,Child);
End;
{$HINTS ON}


Function TForm.GetMDIChildCount:LongInt;
Begin
     If FMDIChildren = Nil Then Result := 0
     Else Result := FMDIChildren.Count;
End;


Function TForm.GetMDIChild(AIndex:LongInt):TForm;
Begin
     Result := Nil;
     If FMDIChildren = Nil Then Exit;
     If (AIndex < 0) Or (AIndex > FMDIChildren.Count-1) Then Exit;
     Result := FMDIChildren.Items[AIndex];
End;


Procedure TForm.InsertMDIChild(Child:TForm);
Var  rc:TRect;
Begin
     Child.FParent := Self;
     ListAdd(FMDIChildren, Child);
     If FMDIChildren.Count = 1 Then FTopMDIChild := Child;

     If (Child.FWidth = 0) Or (Child.FHeight = 0) Then
     Begin
          rc := GetTileCascadeRect;
          Child.FLeft := rc.Left;
          Child.FBottom := rc.Bottom;
          Child.FWidth := rc.Right - rc.Left;
          Child.FHeight := rc.Top - rc.Bottom;
     End;

     If Handle <> 0 Then
     Begin
          Child.CreateWnd;
          If Child.FVisible Or Child.Designed Then Child.Show;
     End
     Else FInitControls := True;
End;


Procedure TForm.RemoveMDIChild(Child:TForm);
Begin
     ListRemove(FMDIChildren, Child);

     If FTopMDIChild = Child Then FTopMDIChild := Nil;
End;


Procedure TForm.CreateUniqueWindowId(AChild:TControl);
Begin
     If AChild <> Nil Then
     Begin
          AChild.FWindowId := FInternalWindowIdCount;
          Inc(FInternalWindowIdCount);
     End;
End;


Procedure TForm.CreateControls;
Var  AForm:TForm;
     I:LongInt;
Begin
     If Not FInitControls Then Exit;

     Inherited CreateControls;

     If FMainMenu <> Nil Then
       If FFrame <> Nil Then FMainMenu.Show;

     For I := 0 To MDIChildCount-1 Do
     Begin
          AForm := MDIChildren[I];
          AForm.CreateWnd;
          If AForm.FVisible Or AForm.Designed Then AForm.Show;
     End;
End;


Procedure TForm.SetFormStyle(Value:TFormStyle);
Var  OldStyle:TFormStyle;
     P:LongInt;
Begin
     If Value <> FFormStyle Then
     Begin
          If ComponentState * [csReading] = [] Then
          Case Value Of
            fsMDIForm: color := clAppWorkSpace;
            fsMDIChild: color := clWindow;
            fsNormal: ;
          End;

          If (Value = fsMDIChild) And (Position = poDesigned)
          Then Position := poDefault;

          OldStyle := FFormStyle;
          If (OldStyle = fsMDIChild) Or (Value = fsMDIChild) Then
            If Parent Is TForm Then  {Update contents Of the lists}
            Begin {but only If already in a List}
                 If OldStyle = fsMDIChild
                 Then P := ListFind(TForm(Parent).FMDIChildren,Self)
                 Else P := ListFind(Parent.FControls,Self);

                 If P >= 0 Then {was already inserted}
                 Begin
                      Parent.RemoveControl(Self);
                      FFormStyle := Value;
                      Parent.InsertControl(Self);
                 End;
            End;
          FFormStyle := Value;
     End;
End;


Procedure TForm.BringToFront;
Var  Flags:LongWord;
Begin
     If FLocked Then Exit;

     {$IFDEF OS2}
     If Frame <> Nil Then
     Begin
          If {F}Visible Then Flags := SWP_SHOW
          Else Flags := 0;
          WinSetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,
                          Flags Or SWP_ZORDER Or SWP_ACTIVATE); {? NoFocus}
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If Frame <> Nil Then
     Begin
          If Parent <> Nil Then SendMessage(GetTopWindow(Parent.Handle),
                                            WM_NCACTIVATE,0,0);
          If {F}Visible Then Flags := SWP_SHOWWINDOW
          Else Flags := 0;
          WinUser.SetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,
                               Flags Or SWP_NOMOVE Or SWP_NOSIZE);
          SendMessage(Frame.Handle,WM_NCACTIVATE,1,0);  {? NoFocus}
          SetForeGroundWindow(Handle);
     End;
     {$ENDIF}
End;



Procedure TForm.RemoveComponent(AComponent:TComponent);
Begin
     Inherited RemoveComponent(AComponent);

     If AComponent = FMainMenu Then FMainMenu := Nil;
End;


Procedure TForm.InsertControl(AChild:TControl);
Var  Toolbar:TToolbar;
Begin
     If AChild Is TForm Then
       If TForm(AChild).FormStyle = fsMDIChild Then
         If FormStyle = fsMDIForm Then
         Begin
              InsertMDIChild(TForm(AChild));
              Exit;
         End;

     Inherited InsertControl(AChild);

     If AChild.FIsToolBar Then
     Begin
          Toolbar := TToolbar(AChild);

          ListAdd(FToolBarLists[Toolbar.Alignment], Toolbar);

          If Handle <> 0 Then
          Begin
               Toolbar.CreateWnd;
               Toolbar.Show;
               AlignToolBars;
          End;
     End;
End;


Procedure TForm.RemoveControl(AChild:TControl);
Var  Toolbar:TToolbar;
Begin
     If FFormStyle = fsMDIForm Then
       If AChild Is TForm Then
         If TForm(AChild).FFormStyle = fsMDIChild
           Then RemoveMDIChild(TForm(AChild));

     Inherited RemoveControl(AChild);    {Destroy the Handle}

     If AChild.FIsToolBar Then
     Begin
          Toolbar := TToolbar(AChild);

          ListRemove(FToolBarLists[Toolbar.Alignment], Toolbar);
          AlignToolBars;
     End;
End;

const
  CONTROL_SYSKEY = AF_SYSCOMMAND + AF_VIRTUALKEY + AF_CONTROL;

  ChildWindowAccelerators : array[ 0 .. 6 ] of ACCEL =
  (
    ( fs: CONTROL_SYSKEY; key: VK_F4; cmd: SC_CLOSE ),
    ( fs: CONTROL_SYSKEY; key: VK_F5; cmd: SC_RESTORE ),
    ( fs: CONTROL_SYSKEY; key: VK_F7; cmd: SC_MOVE ),
    ( fs: CONTROL_SYSKEY; key: VK_F8; cmd: SC_SIZE ),
    ( fs: CONTROL_SYSKEY; key: VK_F9; cmd: SC_MINIMIZE ),
    ( fs: CONTROL_SYSKEY; key: VK_F10; cmd: SC_MAXIMIZE ),
    ( fs: CONTROL_SYSKEY; key: VK_SPACE; cmd: SC_SYSMENU )
  );

var
  g_pStandardAcceleratorTable: PACCELTABLE;

Procedure GenerateShortCuts(AForm:TForm);
{$IFDEF OS2}
Var
     T,t1:LongInt;
     dummy,dummy1:PAccelItem;
     Temp:LongWord;
     CH:Char;
     aAccel:PAccelTable;
Const
     _CHAR_=$0001;
     _VIRTUALKEY_=$0002;
     _SCANCODE_=$0004;
     _SHIFT_=$0008;
     _CONTROL_=$0010;
     _ALT_=$0020;
     _LONEKEY_=$0040;
     _SYSCOMMAND_=$0100;
     _HELP_=$0200;
Type PCharAccels=^TCharAccels;
     TCharAccels=Record
                       dummy:PAccelItem;
                       Next:PCharAccels;
                 End;
Var  CharAccels,TempCharAccel:PCharAccels;
     TableSize:longint;
     NumCustomAccelerators:longint;
     NumSystemMenuAccelerators:longint;
Const
     hStandardAcceleratorTable:HACCEL=NULLHANDLE; // handle to standard (msg queue) accel table
Label weiter;
{$ENDIF}
Begin
     If AForm.Frame=Nil Then Exit;
     If AForm.Frame.Handle=0 Then Exit;

     {$IFDEF OS2}
     If AForm.FAccel<>0 Then
     Begin
          WinSetAccelTable(AppHandle,0,AForm.Frame.Handle);  //Erase old
          WinDestroyAccelTable(AForm.FAccel);
          AForm.FAccel:=0;
     End;

     If AForm.FAccelList <> Nil Then
     Begin
          CharAccels:=Nil;
          For T:=0 To AForm.FAccelList.Count-1 Do
          Begin
               dummy:=AForm.FAccelList.Items[T];
               If dummy^.KeyCode And kb_Char<>0 Then
               Begin
                    Temp:=dummy^.KeyCode And 255;
                    CH:=Chr(Temp);
                    If UpCase(CH) In ['A'..'Z'] Then  //Add also uppercase/lowercase Version Of accel
                    Begin
                        If CH=UpCase(CH) Then
                        Begin
                            //check lowercase Version
                            CH:=Chr(Ord(CH)+32);
                        End
                        Else
                        Begin
                            //Insert uppercase Version
                            CH:=Chr(Ord(CH)-32);
                        End;

                        //look If the ShortCut Is already present
                        For t1:=0 To AForm.FAccelList.Count-1 Do
                        Begin
                             dummy1:=AForm.FAccelList.Items[t1];
                             If dummy1^.KeyCode And kb_Char<>0 Then
                               If (dummy1^.KeyCode And Not 255)=(dummy^.KeyCode And Not 255) Then
                                 If (dummy1^.KeyCode And 255)=Ord(CH) Then Goto weiter;
                        End;

                        If CharAccels=Nil Then
                        Begin
                             New(CharAccels);
                             TempCharAccel:=CharAccels;
                             TempCharAccel^.Next:=Nil;
                        End
                        Else
                        Begin
                             New(TempCharAccel);
                             TempCharAccel^.Next:=CharAccels;
                             CharAccels:=TempCharAccel;
                        End;
                        TempCharAccel^.dummy:=dummy;
                    End;
weiter:
               End;
          End;

          While CharAccels<>Nil Do
          Begin
               New(dummy);
               dummy^:=CharAccels^.dummy^;
               CH:=Chr(dummy^.KeyCode And 255);
               dummy^.KeyCode:=dummy^.KeyCode And Not 255;
               If CH=UpCase(CH) Then
               Begin
                    //Insert lowercase Version
                    dummy^.KeyCode:=dummy^.KeyCode Or (Ord(CH)+32);
               End
               Else
               Begin
                    //Insert uppercase Version
                    dummy^.KeyCode:=dummy^.KeyCode Or(Ord(CH)-32);
               End;
               AForm.FAccelList.Add(dummy);
               TempCharAccel:=CharAccels^.Next;
               Dispose(CharAccels);
               CharAccels:=TempCharAccel;
          End;
          NumCustomAccelerators := AForm.FAccelList.Count;
     End
     Else
     Begin
          // only system menu accelerators needed
          NumCustomAccelerators := 0;
     End;

     if hStandardAcceleratorTable = NULLHANDLE then
     begin
          hStandardAcceleratorTable := WinQueryAccelTable( AppHandle, 0 );
          // remove msg queue accelerator table
          WinSetAccelTable( AppHandle, 0, 0 );

          TableSize := WinCopyAccelTable( hStandardAcceleratorTable, nil, 0 );
          GetMem( g_pStandardAcceleratorTable, TableSize );

          WinCopyAccelTable( hStandardAcceleratorTable,
                             g_pStandardAcceleratorTable^,
                             TableSize );
     end;

     If AForm.FormStyle = fsMDIChild then
          NumSystemMenuAccelerators := High( ChildWindowAccelerators ) + 1
     Else
          NumSystemMenuAccelerators := g_pStandardAcceleratorTable^.cAccel;

     TableSize:= ( NumCustomAccelerators + NumSystemMenuAccelerators )
                   * SizeOf( accel )
                 + 4;
     GetMem( aAccel, TableSize );
     aAccel^.cAccel := NumCustomAccelerators + NumSystemMenuAccelerators;
     aAccel^.codepage := 0;

     If AForm.FAccelList <> Nil Then
     Begin
          For T:=0 To AForm.FAccelList.Count-1 Do
          Begin
               dummy:=AForm.FAccelList.Items[T];
               With aAccel^.aAccel[T] Do
               Begin
                    fs:=0;
                    Temp:=dummy^.KeyCode And 255;
                    If dummy^.KeyCode And kb_VK<>0 Then fs:=fs Or _VIRTUALKEY_;
                    If dummy^.KeyCode And kb_Ctrl<>0 Then fs:=fs Or _CONTROL_;
                    If dummy^.KeyCode And kb_Shift<>0 Then fs:=fs Or _SHIFT_;
                    If dummy^.KeyCode And kb_Alt<>0 Then fs:=fs Or _ALT_;
                    If dummy^.KeyCode And kb_Char<>0 Then fs:=fs Or _CHAR_;
                    If fs=0 Then fs:=_CHAR_;
                    key:=Temp;
                    cmd:=dummy^.Command;
               End;
          End;
     End;

     // Append system menu accelerators (Alt, or Ctrl for MDI children)
     For T := 0 To NumSystemMenuAccelerators - 1 do
     Begin
          If AForm.FormStyle = fsMDIChild then
          Begin
               aAccel^.aAccel[ NumCustomAccelerators + T ] :=
                    ChildWindowAccelerators[ T ]
          End
          Else
          Begin
               // copy from standard accelerators
               aAccel^.aAccel[ NumCustomAccelerators + T ] :=
                    g_pStandardAcceleratorTable^.aaccel[ T ];
          End;
     End;

     AForm.FAccel:=WinCreateAccelTable(AppHandle,aAccel^);
     If AForm.FAccel<>0
     Then WinSetAccelTable(AppHandle,AForm.FAccel,AForm.Frame.Handle); //Set New

     FreeMem(aAccel,TableSize);
     {$ENDIF}
End;


Procedure TForm.AddShortCut(KeyCode:TKeyCode;Command:TCommand);
Var  dummy:PAccelItem;
     T:LongInt;
Begin
     If Command=cmNull Then Exit;

     If FAccelList<>Nil Then
     Begin
          For T:=0 To FAccelList.Count-1 Do
          Begin
               dummy:=FAccelList.Items[T];
               If dummy^.KeyCode=KeyCode Then Exit;  //no Duplicates !
          End;
     End
     Else FAccelList.Create;

     New(dummy);
     dummy^.KeyCode:=KeyCode;
     dummy^.Command:=Command;

     FAccelList.Add(dummy);

     If Frame<>Nil Then
       If Frame.Handle<>0 Then
         If FShortCutsEnabled Then GenerateShortCuts(Self);
End;


Procedure TForm.DeleteShortCut(KeyCode:TKeyCode);
Var  dummy:PAccelItem;
     T:LongInt;;
     ACommand:TCommand;
Begin
     If FAccelList = Nil Then Exit;

     ACommand := -1;
     For T := FAccelList.Count-1 Downto 0 Do
     Begin
          dummy := FAccelList.Items[T];
          If (dummy^.KeyCode=KeyCode) Or (dummy^.Command=ACommand) Then
          Begin
               ACommand := dummy^.Command;
               FAccelList.Remove(dummy);
               Dispose(dummy);
          End;
     End;

     If FAccelList.Count = 0 Then
     Begin
          FAccelList.Destroy;
          FAccelList := Nil;
     End;

     If Frame <> Nil Then
       If Frame.Handle <> 0 Then
         If FShortCutsEnabled Then GenerateShortCuts(Self);
End;


Procedure TForm.SetShortCutsEnabled(Value:Boolean);
Begin
     If Not FShortCutsEnabled Then
       If Value Then GenerateShortCuts(Self);
     FShortCutsEnabled := Value;
End;

Procedure TForm.DismissDlg(Result:TCommand);
Begin
     If FModalShowing Then
     Begin
          FModalResult := Result;
          If OnDismissDlg <> Nil Then OnDismissDlg(Self);
          If FModalResult <> cmNull Then EndModalState;
     End;
End;


Procedure TForm.CMEndModalState(Var Msg:TMessage);
Begin
     DestroyHandle;

     FModalShowing := False;
     Msg.Handled := True;
End;

Procedure TForm.EndModalState;
Begin
     PostMsg(Handle,CM_ENDMODALSTATE,0,0);
End;


Procedure TForm.Close;
Var  Action:TCloseAction;
     i:LongInt;
Begin
     If CloseQuery Then
     Begin
          {If FFormStyle = fsMDIChild Then Action := caMinimize
          Else} Action := caFree; {!! caHide?}

          If dsAutoCreate In DesignerState Then Action := caFreeHandle;

          If FOnClose <> Nil Then FOnClose(Self, Action);

          If Action = caNone Then Exit;

          If FModalShowing Then
          Begin
               DismissDlg(cmCancel);
               Exit;
          End;

          If Application.MainForm = Self Then
          Begin
               {$IFDEF OS2}
               If ModalList <> Nil Then
                 For i := 0 To ModalList.Count-1
                  Do TForm(ModalList[i]).EndModalState;
               {$ENDIF}

               Application.FTerminate:=True;
               {$IFDEF WIN32}
               Application.Terminate;
               {$ENDIF}
               Release;
               Exit;
          End;

          Case Action Of
            caHide: Hide;
            caFree: Release;  {Post Destroy}
            caMinimize: WindowState := wsMinimized;
            caFreeHandle: DestroyHandle;
          End;
     End;
End;


Function TForm.CloseQuery:Boolean;
Var  T:LongInt;
     Form:TForm;
Begin
     Result := False;

     For T := 0 To ControlCount-1 Do
     Begin
          Form := TForm(Controls[T]);
          If Form Is TForm Then
          Begin
            If Not Form.CloseQuery Then Exit;
          End
          Else
          Begin
            If Form.OnCloseQuery<>Nil Then
            Begin
                 Form.OnCloseQuery(Form,Result);
                 If not Result Then exit;
            End;
          End;
     End;

     If FMDIChildren <> Nil Then
     Begin
          For T := 0 To FMDIChildren.Count-1 Do
          Begin
               Form := FMDIChildren.Items[T];
               If Form Is TForm Then
                 If Not Form.CloseQuery Then Exit;
          End;
     End;
     Result := True;

     If OnCloseQuery <> Nil Then OnCloseQuery(Self,Result);
End;


Destructor TForm.Destroy;
Var  dummy:PAccelItem;
     T:LongInt;
Begin
     If FOnDestroy <> Nil Then FOnDestroy(Self);

     If FAccel<>0 Then
       // Free accelerator table - AaronL
       WinDestroyAccelTable(FAccel);

     If Application<>Nil Then
       If Application.MainForm = Self Then Application.Terminate; {End MsgLoop}

     If Screen.FActiveForm = Self Then Screen.FActiveForm := Nil;

     Screen.FForms.Remove(Self);

     If FModalShowing Then DismissDlg(cmCancel);

     If FIcon<>Nil Then If FIcon.FIsLocalCopy Then FIcon.Destroy;
     FIcon:=Nil;

     If FAccelList <> Nil Then
     Begin
          For T := 0 To FAccelList.Count-1 Do
          Begin
               dummy := FAccelList.Items[T];
               Dispose(dummy);
          End;

          FAccelList.Destroy;
          FAccelList := Nil;
     End;

     FTopMDIChild := Nil;

     Inherited Destroy;

     If FFrame <> Nil Then
     Begin
          TFrameControl(FFrame).FChild := Nil;
          FFrame.Destroy;
          FFrame := Nil;
     End;

     If Application<>Nil Then
       If Application.MainForm = Self Then Application.FMainForm := Nil;

     Screen.UpdateLastActive;
End;


Procedure TForm.SetupComponent;
Begin
     Inherited SetupComponent;

     If Designed Then Include(ComponentState, csReference);
     Name := 'Form';
     Caption := Name;
     AutoScroll:=False;
     FParentPenColor := False;
     FParentColor := False;
     FColor := clDlgWindow;
     FShowHint := True;
     FWindowState := wsNormal;
     FBorderIcons := [biSystemMenu,biMinimize,biMaximize];
     FBorderStyle := bsSizeable;
     FFormStyle := fsNormal;
     FTileMode := tbNormal;
     FMinTrackWidth := 0;
     FMinTrackHeight := 0;
     FMaxTrackWidth := MaxInt;
     FMaxTrackHeight := MaxInt;
     FEnableDocking := [];
     FMoveable := True;
     FSizeable := True;
     FTabStop := False;
     FCursorTabStop := False;
     FActiveControl := Nil;
     FFrame := Nil;
     FForm := Self;
     Include(ComponentState, csForm); {To decide SetupSCU}
     Include(ComponentState, csAcceptsControls);
     FShortCutsEnabled := True;
     FPosition := poDesigned;
     FInternalWindowIdCount := cmInternalControlBase;

     If Application.FMainForm = Self Then
          FParentFont := false; // use SCU font

     FOptions.TitleBar := true;
     FOptions.TaskListEntry := true;
End;


Constructor TForm.CreateIntern(AOwner:TComponent; Var AReference:TForm);
Begin
     AReference := Self;
     If Application <> Nil Then
       If Application.FMainForm = Nil Then Application.FMainForm := Self;

     TForm.Create(AOwner);
End;


Constructor TForm.Create(AOwner:TComponent);
Begin
     Include(ComponentState, csForm); {To decide SetupSCU}

     Inherited Create(AOwner);

     Asm
        PUSH DWord Ptr Self
        CALLN32 Classes.SetupFormSCU
     End;
     If FOnCreate <> Nil Then FOnCreate(Self);

     If Not (csReference In ComponentState) Then
       If Screen.FForms.IndexOf(Self) < 0 Then Screen.FForms.Add(Self);
End;


Constructor TForm.CreateNew(AOwner:TComponent);
Begin
     Include(ComponentState, csForm); {To decide SetupSCU}

     Inherited Create(AOwner);

     If FOnCreate <> Nil Then FOnCreate(Self);

     If Not (csReference In ComponentState) Then
       If Screen.FForms.IndexOf(Self) < 0 Then Screen.FForms.Add(Self);
End;


Procedure TForm.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LonGInt);
Begin
     If ResName = rnIcon Then
     Begin
          If DataLen <> 0 Then If ((FIcon=Nil)Or(FIcon.Empty)) Then
          Begin
               If IconClass<>Nil Then
               Begin
                    If FIcon=Nil Then
                    Begin
                         FIcon:=TGraphic(IconClass.Create);
                         FIcon.FIsLocalCopy:=True;
                    End;
                    Try
                       FIcon.ReadSCUResource(rnBitmap,Data,DataLen);
                    Except
                       FIcon.Destroy;
                       FIcon:=Nil;
                    End;
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TForm.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If FIcon <> Nil Then
       If Not FIcon.Empty Then
         If FIcon<>Application.FIcon Then Result := FIcon.WriteSCUResourceName(Stream,rnIcoN);
End;


{$HINTS OFF}
Procedure TForm.LoadedFromSCU(SCUParent:TComponent);
Begin
     Exclude(ComponentState,csHasMainMenu);

     {SCUParent Is Nil; because Form Is ON DeskTop Or Is Reference}
     Inherited LoadedFromSCU(Nil);
End;
{$HINTS ON}

procedure AddMenuItem( hMenu: HWND;
                       const Text: string
                       const Command: USHORT );

var
  NewMenuItem: MENUITEM;
  ItemText: cstring;
begin
  NewMenuItem.iPosition := MIT_END;

  if Text <> '-' then
  begin
    NewMenuItem.afStyle := MIS_TEXT + MIS_SYSCOMMAND;
    ItemText := Text;
  end
  else
  begin
    NewMenuItem.afStyle := MIS_SEPARATOR;
    ItemText := '';
  end;
  NewMenuItem.afAttribute := 0;
  NewMenuItem.id := Command;
  NewMenuItem.hwndSubMenu := 0;
  NewMenuItem.hItem := 0;

  WinSendMsg( hMenu,
              MM_INSERTITEM,
              MPARAM( Addr( NewMenuItem ) ),
              MPARAM( Addr( ItemText ) ) );
end;

Procedure SetChildSysteMenu( Form: TForm );
var
  hSystemMenu: HWND;
  Top: MENUITEM;
  i : longint;
  MenuItemCount : longint;
  ItemID: SHORT;
begin
  hSystemMenu := WinWindowFromID( Form.Frame.Handle,
                                  FID_SYSMENU );

  // read the root (top) menu item.
  WinSendMsg( hSystemMenu,
              MM_QUERYITEM,
              SC_SYSMENU,
              MPARAM( Addr( Top ) ) );

  // read the submenu (which is what contains the real items)
  hSystemMenu := Top.hwndSubMenu;

  // Delete the existing system menu items
  MenuItemCount := WinSendMsg( hSystemMenu,
                               MM_QUERYITEMCOUNT,
                               0,
                               0 );
  for i := 0 to MenuItemCount - 1 do
  begin
    // delete first item each time
    ItemID := WinSendMsg( hSystemMenu,
                          MM_ITEMIDFROMPOSITION,
                          0,
                          0 );

    WinSendMsg( hSystemMenu,
                MM_DELETEITEM,
                MPFROM2SHORT( ItemID, 1 ),
                0 );
  end;

  // Now add in new items with the correct shortcut text
  AddMenuItem( hSystemMenu,
               '~Restore' + #9 + 'Ctrl+F5',
               SC_RESTORE );
  AddMenuItem( hSystemMenu,
               '~Move' + #9 + 'Ctrl+F7',
               SC_MOVE );
  AddMenuItem( hSystemMenu,
               '~Size' + #9 + 'Ctrl+F8',
               SC_SIZE );
  AddMenuItem( hSystemMenu,
               'Mi~nimize' + #9 + 'Ctrl+F9',
               SC_MINIMIZE );
  AddMenuItem( hSystemMenu,
               'Ma~ximize' + #9 + 'Ctrl+F10',
               SC_MAXIMIZE );

  AddMenuItem( hSystemMenu,
               '-', // separator
               100 );

  AddMenuItem( hSystemMenu,
               '~Close' + #9 + 'Ctrl+F4',
               SC_CLOSE );
end;

Procedure TForm.CreateWnd;
Var  TopMDI:TForm;
     dist:LONGINT;
     {$IFDEF WIN32}
     SysMenu:LongWord;
     {$ENDIF}
Begin
     If Not Designed Then
       If FFormStyle = fsMDIChild Then
         If Application.MainForm <> Nil Then
           If Application.MainForm.FormStyle = fsMDIForm Then
             If Parent = Nil Then
             Begin
                  TopMDI := Application.MainForm.ActiveMDIChild;

                  Parent := Application.MainForm;

                  If FPosition = poDefault Then
                  Begin
                       If TopMDI = Self Then TopMDI := Nil;
                       If TopMDI <> Nil Then
                       Begin
                            dist := Screen.SystemMetrics(smCySizeBorder);
                            inc(dist, Screen.SystemMetrics(smCyTitlebar));

                            SetBounds(TopMDI.Left+dist, TopMDI.Top+dist,
                                      TopMDI.Width, TopMDI.Height);
                       End
                       Else
                       Begin
                            SetBounds(0,0, (Application.MainForm.Width Div 3)*2,
                                      (Application.MainForm.Height Div 3)*2);
                       End;
                  End;
             End;


     ShortCutsEnabled := False;

     Inherited CreateWnd;

     {$IFDEF WIN32}
     If Frame<>Nil Then
       If ((FBorderStyle<>bsNone)And(biSystemMenu In FBorderIcons)And
           (FormStyle <> fsMDIChild)) then
     Begin
          SysMenu := GetSystemMenu(Frame.Handle, False);

          If SysMenu<>0 Then
          Begin
               If FBorderStyle=bsDialog Then
               Begin
                    DeleteMenu(SysMenu, SC_TASKLIST, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, 7, MF_BYPOSITION);
                    DeleteMenu(SysMenu, 5, MF_BYPOSITION);
                    DeleteMenu(SysMenu, SC_MAXIMIZE, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, SC_MINIMIZE, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, SC_SIZE, MF_BYCOMMAND);
                    DeleteMenu(SysMenu, SC_RESTORE, MF_BYCOMMAND);
               End
               Else
               Begin
                    If not (biMinimize In FBorderIcons) Then
                       EnableMenuItem(SysMenu, SC_MINIMIZE, MF_BYCOMMAND or MF_GRAYED);
                    If not (biMaximize in FBorderIcons) Then
                       EnableMenuItem(SysMenu, SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED);
               End;
          End;
     End;
     {$ENDIF}

     ShortCutsEnabled := True;

     If Not Designed Then
       If DDEMan_OpenClientLinks<>Nil Then DDEMan_OpenClientLinks(Self); //Open DDE clients

     {$IFDEF OS2}

     If Not Designed Then
     begin
       If FFormStyle = fsMDIChild Then
       begin
         // Child window: change system menu
         SetChildSysteMenu( self );
       end;

       // Make sure accelerators generated, even if the
       // form doesn't contain any shortcuts, since
       // we need the system menu accelerators
       GenerateShortCuts( self );
     end;

     {$ENDIF}

End;

Procedure TForm.SetupShow;
Begin
     Inherited SetupShow;

     if FormIconResourceID <> 0 then
     begin
          // hack to get properly scaled form icons- Aaronl
          if not TriedLoadingFormIcon then
          begin
               // first time, try to load icon
               TriedLoadingFormIcon := true;
               hFormIcon := WinLoadPointer(HWND_DESKTOP,0,FormIconResourceID);
          end;
          if hFormIcon <> NULLHANDLE then
               WinSendMsg(Frame.Handle,WM_SETICON,hFormIcon,0);
     end
     else If     ((Application<>Nil)
             And (Application.Icon<>Nil)
             And (Not Application.Icon.Empty)
             And (IconClass<>Nil)) then
     Begin
          Icon:=Application.Icon;
     End
     Else If FIcon<>Nil Then
     Begin
          Icon:=FIcon;
     End;
End;

Function TForm.ShowModal:LongWord;
Begin
     Result:=ShowModal2(nil);
End;

Function TForm.ShowModal2(Owner:TForm):LongWord;
Var  LastActiveForm:TForm;
     OldFParent:TControl;
     {$IFDEF OS2}
     Queue:QMSG;
     {$ENDIF}
     {$IFDEF Win32}
     aMsg:WinUser.Msg;
     {$ENDIF}
     ex:Boolean;
Label again;
Begin
     If Designed Then
     Begin
          Show;
          Exit;
     End;

     FIsModal := True;
     FModalResult := cmNull;
     FWindowState := wsNormal;
     LastActiveForm := Screen.ActiveForm;

     FModalShowing := True;

     OldFParent := FParent;
     FModalOwner := Owner;

     If Handle = 0 Then CreateWnd;
     If Handle <> 0 Then LockDesktopWindows(True, Self);
     Show;
     BringToFront;

again:
     ex:=False;
     Try
        Repeat
              If Application = Nil Then
              Begin
                   {$IFDEF OS2}
                   If WinPeekMsg(AppHandle,Queue,0,0,0,PM_REMOVE) Then
                   Begin
                       If Queue.Msg <> WM_QUIT Then
                         WinDispatchMsg(AppHandle,Queue);
                   End;
                   {$ENDIF}

                   {$IFDEF Win32}
                   If PeekMessage(aMsg,0,0,0,PM_REMOVE) Then
                   Begin
                       If aMsg.Message <> WM_QUIT Then
                       Begin
                            TranslateMessage(aMsg);
                            DispatchMessage(aMsg);
                       End;
                   End;
                   {$ENDIF}
              End
              Else Application.HandleMessage;
        Until Not FModalShowing;
        ex:=False;
     Except
        On E:Exception Do
        Begin
             If Application<>Nil Then
             Begin
                Application.ExceptObject := E;
                Application.HandleException(Self);
                Application.ExceptObject := Nil;
             End
             Else Raise;
        End;
        ex:=True;
     End;
     If ex Then goto again; //don't terminate dialog on exception

     Result := FModalResult;

     LockDesktopWindows(False,Self);
     {$IFDEF WIN32}
     DestroyHandle; //done in DismissDlg for OS/2
     {$ENDIF}
     FParent := OldFParent;

     Try
        {LastActiveForm destroyed?}
        If Not (LastActiveForm Is TForm) Then LastActiveForm := Nil;
     Except
        LastActiveForm := Nil;
     End;
End;


Procedure TForm.SetActiveControl(AControl:TControl);
Begin
     If IsControl(AControl) Then AControl.Focus
     Else Focus;
End;


Function TForm.GetTileCascadeRect:TRect;
Begin
     Result := GetClientRect;
End;


Procedure TForm.CommandEvent(Var Command:TCommand);
Var  MsgHandled:Boolean;
Begin
     Inherited CommandEvent(Command);

     MsgHandled := True;
     Case Command Of
        cmExit: Application.MainForm.Close;
        cmClose: Close;
        cmTile: Tile;
        cmCascade: Cascade;
        cmNext: Next;
        cmPrevious: previous;
        cmCloseAll: CloseAll;
        cmMaximize: If FTopMDIChild <> Nil Then FTopMDIChild.WindowState := wsMaXimIzed;
        cmMinimize: If FTopMDIChild <> Nil Then FTopMDIChild.WindowState := wsMiNimIzed;
        cmRestore: If FTopMDIChild <> Nil Then FTopMDIChild.WindowState := wsNorMal;
        cmCloseTop: If FTopMDIChild <> Nil Then FTopMDIChild.Close;
        cmHelpIndex: Application.HelpIndex;
        cmHelpContents: Application.HelpContents;
        cmHelpOnHelp: Application.HelpOnHelp;
        cmKeysHelp: Application.KeysHelp;
        cmHelp: Application.Help(HelpContext);
        Else MsgHandled := False;
     End; {Case}

     If MsgHandled Then Command := cmNull;
End;


Procedure TForm.Tile;
Var  ChildCnt:LongInt;
     Rows,Columns,ExtraCols,CurRow,CurCol:LongWord;
     Square:LongWord;
     aLeft,aBottom,aHeight,aWidth:LongInt;
     rec:TRect;
     Child:TForm;
     LastFocus:TForm;
     I:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren=Nil Then Exit;
     ChildCnt:=FMDIChildren.Count;
     If ChildCnt=0 Then Exit;

     LastFocus := FTopMDIChild;
     If LastFocus <> Nil Then
     Begin
          FMDIChildren.Remove(LastFocus);
          FMDIChildren.Add(LastFocus);
     End;

     Case FTileMode Of
       tbHorizontal:
       Begin
            rec := GetTileCascadeRect;
            aLeft := rec.Left;
            aBottom := rec.Bottom;
            aHeight := (rec.Top - rec.Bottom) Div ChildCnt;
            aWidth := rec.Right - rec.Left;
            For I := 0 To ChildCnt-1 Do
            Begin
                 Child := FMDIChildren.Items[I];
                 If Child.WindowState <> wsNormal
                   Then Child.WindowState := wsNormal;

                 aBottom := rec.Bottom + I*aHeight;
                 If I = ChildCnt-1 Then aHeight := rec.Top - aBottom;

                 Child.SetWindowPos(aLeft, aBottom, aWidth, aHeight);
            End;
       End;
       tbVertical:
       Begin
            rec := GetTileCascadeRect;
            aLeft := rec.Left;
            aBottom := rec.Bottom;
            aHeight := rec.Top - rec.Bottom;
            aWidth := (rec.Right - rec.Left) Div ChildCnt;
            For I := 0 To ChildCnt-1 Do
            Begin
                 Child := FMDIChildren.Items[I];
                 If Child.WindowState <> wsNormal
                   Then Child.WindowState := wsNormal;

                 aLeft := rec.Left + I*aWidth;
                 If I = ChildCnt-1 Then aWidth := rec.Right - aLeft;

                 Child.SetWindowPos(aLeft, aBottom, aWidth, aHeight);
            End;
       End;
       tbNormal:
       Begin
            Square:=2;
            While Square*2<=ChildCnt Do Inc(Square);
            If ChildCnt=3 Then Square:=3;

            Columns:=Square-1;
            Rows:=ChildCnt Div Columns;
            ExtraCols:=ChildCnt Mod Columns;
            rec:=GetTileCascadeRect;

            aHeight:=(rec.Top-rec.Bottom) Div Rows;
            ChildCnt:=0;

            For CurRow:=0 To Rows-1 Do
            Begin
                 If Rows-CurRow<=ExtraCols Then Inc(Columns);
                 For CurCol:=0 To Columns-1 Do
                 Begin
                      aWidth:=rec.Right Div Columns;

                      If ChildCnt<FMDIChildren.Count Then
                      Begin
                           Child:=FMDIChildren.Items[ChildCnt];
                           Inc(ChildCnt);

                           If Child.WindowState<>wsNormal
                           Then Child.WindowState:=wsNormal;

                           Child.SetWindowPos(aWidth*CurCol,
                                              rec.Top-(aHeight*(CurRow+1)),
                                              aWidth,
                                              aHeight);
                      End;
                 End;
                 If Rows-CurRow<=ExtraCols Then
                 Begin
                      Dec(Columns);
                      Dec(ExtraCols);
                 End;
            End;
       End;
     End;

     If ActiveMDIChild <> Nil Then ActiveMDIChild.BringToFront;
End;


Procedure TForm.Cascade;
Var  xloc,yloc,xlen,ylen:LongInt;
     XDiv,YDiv:LongWord;
     rec:TRect;
     T:LongInt;
     Child:TForm;
     LastFocus:TForm;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren=Nil Then Exit;

     LastFocus := FTopMDIChild;
     If LastFocus <> Nil Then
     Begin
          FMDIChildren.Remove(LastFocus);
          FMDIChildren.Add(LastFocus);
     End;

     XDiv:=Screen.SystemMetrics(smCxSizeBorder);
     Inc(XDiv,Screen.SystemMetrics(smCyTitlebar));

     YDiv:=Screen.SystemMetrics(smCySizeBorder);
     Inc(YDiv,Screen.SystemMetrics(smCyTitlebar));

     rec:=GetTileCascadeRect;
     xloc:=rec.Left;
     xlen:=rec.Right-rec.Left;
     yloc:=rec.Bottom;
     ylen:=rec.Top-rec.Bottom;
     For T:=0 To FMDIChildren.Count-1 Do
     Begin
          Child:=FMDIChildren.Items[T];
          If Child.WindowState<>wsNormal Then Child.WindowState:=wsNormal;
          Child.SetWindowPos(xloc,yloc,xlen,ylen);
          Child.BringToFront;
          Inc(xloc,XDiv);
          Dec(xlen,XDiv);
          Dec(ylen,YDiv);
     End;
End;

(*
Procedure TForm.ArrangeIcons;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     {$IFDEF OS2}
     {...}
     {$ENDIF}
     {$IFDEF Win32}
     If (FFormStyle = fsMDIForm) And (Handle <> 0)
     Then SendMessage(Handle,WM_MDIICONARRANGE,0,0);
     {$ENDIF}
End;
*)

Procedure TForm.Next;
Var Child:TForm;
    L:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren=Nil Then Exit;
     If FMDIChildren.Count<2 Then Exit;

     Child:=FTopMDIChild;
     L:=FMDIChildren.IndexOf(Child);
     If L >= 0 Then
     Begin
        If L >= FMDIChildren.Count-1 Then L:=0
        Else Inc(L);
     End
     Else L := 0;
     Child:=FMDIChildren.Items[L];
     Child.BringToFront;
End;


Procedure TForm.Previous;
Var Child:TForm;
    L:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     If FMDIChildren=Nil Then Exit;
     If FMDIChildren.Count<2 Then Exit;

     Child:=FTopMDIChild;
     L:=FMDIChildren.IndexOf(Child);
     If L >= 0 Then
     Begin
       If L=0 Then L:=FMDIChildren.Count-1
       Else Dec(L);
     End
     Else L := 0;
     Child:=FMDIChildren.Items[L];
     Child.BringToFront;
End;


Procedure TForm.CloseAll;
Var  Child:TForm;
     L:LongInt;
Begin
     If FFormStyle <> fsMDIForm Then Exit;

     For L := MDIChildCount-1 Downto 0 Do
     Begin
          Child := MDIChildren[L];
          Child.Close;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TApplication Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure MsgProc;
Begin
     Application.HandleMessage;
End;


Procedure ProcessProc;
Begin
     Application.ProcessMessage;
End;


Constructor TApplication.Create;
Begin
     Asm
        MOV EAX,@Forms.MsgProc
        MOV Classes.MsgProc,EAX
        MOV EAX,@Forms.ProcessProc
        MOV Classes.ProcessProc,EAX
     End;
     FShowMainForm:=True;
     Inherited Create(Nil);
End;


Function TApplication.GetLanguage:String;
Var S:String;
Begin
     Asm
        LEA EAX,s
        PUSH EAX
        CALLN32 Classes.GetAppLanguage
     End;
     Result:=S;
End;


Function TApplication.GetExeName:String;
Begin
    Result:=ParamStr(0);
End;


Procedure TApplication.SetLanguage(Const NewLanguage:String);
Var Form:TForm;
    T:LongInt;
Begin
     Asm
        PUSH DWord Ptr NewLanguage
        CALLN32 Classes.SetAppLanguage
     End;

     For T:=0 To Screen.FormCount-1 Do
     Begin
         Form:=Screen.Forms[T];
         Form.Language:=NewLanguage;
     End;
End;


Function TApplication.GetIcon:TGraphic;
Begin
     If FIcon = Nil Then
       If IconClass <> Nil Then
     Begin //Create Empty
          FIcon := TGraphic(IconClass.Create);
          FIcon.FIsLocalCopy := True;
     End;
     Result := FIcon;
End;

Procedure TApplication.SetIcon(NewIcon:TGraphic);
Begin
     If ((FIcon<>Nil)And(FIcon<>NewIcon)And(FIcon.FIsLocalCopy)) Then FIcon.Destroy;
     FIcon:=Nil;

     If ((NewIcon<>Nil)And(NewIcon<>FIcon)And(NewIcon.FIsLocalCopy)And(IconClass<>Nil)) Then
     Begin
          //Create A Copy !!
          Try
             NewIcon:=NewIcon.CopyGraphic;
             NewIcon.FIsLocalCopy:=True;
          Except
             NewIcon:=Nil;
          End;
     End;

     FIcon:=NewIcon;
End;


Procedure TApplication.SetupComponent;
{$IFDEF OS2}
Var  Version_Major:LongInt;
     Version_Minor:LongInt;
     MemBuf:Array[0..11] Of Byte;
     cc:COUNTRYCODE;
{$ENDIF}
Begin
     Inherited SetupComponent;

     Application := Self;
     FHint := '';
     FShowHint := True;
     FHintPause := 1000;
     FHintPenColor := clInfoText;
     FHintColor := clInfo;
     FHintControl := Nil;
     FHintParent := Nil;
     FHintOwner := Nil;
     FHintOrigin := hiBottom;
     FMenuItemList.Create;
     FFont := Screen.DefaultFont;
     FTerminate := False;

     {$IFDEF OS2}
     FPlatform := OS2Ver40;
     If DosQuerySysInfo(11,11,Version_Major,4) = 0 Then
       If DosQuerySysInfo(12,12,Version_Minor,4) = 0 Then
         If Version_Major = 20 Then
           Case Version_Minor Of
             0,10,11: FPlatform := OS2Ver20;
             30:      FPlatform := OS2Ver30;
           End;
     FDBCSSystem := False;
     cc.country := 0;
     cc.codepage := 0;
     If DosQueryDBCSEnv(12,cc,MemBuf) = 0 Then
       If (MemBuf[0] <> 0) And (MemBuf[1] <> 0) Then FDBCSSystem := True;
     {$ENDIF}
     {$IFDEF Win32}
     FPlatform := Win32;
     FDBCSSystem := False;
     {$ENDIF}
End;


Procedure TApplication.CreateForm(InstanceClass:TFormClass;Var Reference:TForm);
Var  OldMainForm:TForm;
Begin
     OldMainForm := FMainForm;

     Try
        Reference := InstanceClass.CreateIntern(Nil,Reference);
     Except
        On E:Exception Do
        Begin
             Reference := Nil;
             FMainForm := OldMainForm;
             If Application <> Nil Then
             Begin
                Application.ExceptObject := E;
                Application.HandleException(Self);
                Application.ExceptObject := Nil;
             End
             Else Raise;
        End;
     End;
End;


Type
     PForm=^TForm;
     PAutomaticRec=^TAutomaticRec;
     TAutomaticRec=Record
                         Form:PForm;
                         FormClass:TFormClass;
                   End;

Const AutomaticForms:TList=Nil;

Procedure RegisterAutomaticForm(FormClass:TFormClass;address:Pointer);
Var dummy:PAutomaticRec;
Begin
     If AutomaticForms=Nil Then AutomaticForms.Create;
     New(dummy);
     dummy^.Form:=address;
     dummy^.FormClass:=FormClass;
     AutomaticForms.Add(dummy);
End;

Procedure CreateAutomaticForms;
Var T:LongInt;
    Item:PAutomaticRec;
Begin
     If AutomaticForms<>Nil Then
     Begin
          For T:=0 To AutomaticForms.Count-1 Do
          Begin
               Item:=AutomaticForms[T];
               //main Form Is already created !!
               If Item^.Form^<>Application.FMainForm Then
                  Application.CreateForm(Item^.FormClass,Item^.Form^);
               Dispose(Item);
          End;
          AutomaticForms.Destroy;
     End;
End;


Procedure TApplication.Run;
Var i:LongInt;
    AForm:TForm;
    {$IFDEF OS2}
    aHelpInit:HELPINIT;
    C,c1:Cstring;
    rec:TRect;
    {$ENDIF}
    ex:Boolean;
    AIcon:TGraphic;
Label again;
Begin
     ex:=False;
     Try
        If FMainForm <> Nil Then
             // get default font before creating auto forms.
             Application.Font:=MainForm.Font;

        CreateAutomaticForms;

        If FMainForm = Nil Then Exit;

        If IconClass<>Nil Then //Try to load default icon
        Begin
             AIcon:=IconClass.Create;
             Try
                //First try if we have an application icon from Sibyl
                AIcon.LoadFromResourceId(1);
             Except
                //Try default icon in Cursors.rc
                Try
                   AIcon.LoadFromResourceId(2);
                Except
                   AIcon.Destroy;
                   AIcon:=Nil;
                End;
             End;

             FIcon:=AIcon;
        End;

        FMainForm.CreateWnd;
        If FMainForm.Handle = 0 Then RunFailed;
        If HelpFile <> '' Then
        Begin
             {$IFDEF OS2}
             C := HelpWindowTitle;
             aHelpInit.pszHelpWindowTitle := @C;
             c1 := HelpFile;
             aHelpInit.pszHelpLibraryName := @c1;
             aHelpInit.cb := SizeOf(HELPINIT);
             aHelpInit.ulReturnCode := 0;
             aHelpInit.pszTutorialname := Nil;
             aHelpInit.phtHelptable := Nil{Pointer($FFFF0000 Or Attr.ResourceId)};
             aHelpInit.hmodHelptableModule := 0{Attr.ResourceModule};
             aHelpInit.hmodAccelActionBarModule := 0;
             aHelpInit.idAcceltable := 0;
             aHelpInit.idActionBar := 0;
             aHelpInit.fShowPanelID := 0;
             FHelpWindow := WinCreateHelpInstance(AppHandle,aHelpInit);

             If FHelpWindow <> 0 Then
             Begin
                  WinAssociateHelpInstance(HelpWindow,FMainForm.Frame.Handle);

                  rec.Left := 0;
                  rec.Right := Screen.Width Div 2;
                  rec.Bottom := 0;
                  rec.Top := Screen.Height;
                  WinSendMsg(FHelpWindow,HM_SET_COVERPAGE_SIZE,LongWord(@rec),0);
             End
             Else ErrorBox2(LoadNLSStr(SAppHelpFailed));
             {$ENDIF}
        End;
        If FShowMainForm Then FMainForm.Show;

        // show all visible MDI Forms
        If FMainForm.FormStyle = fsMDIForm Then
          For i := 0 To Screen.FormCount-1 Do
          Begin
               AForm := Screen.Forms[i];
               If AForm <> FMainForm Then
                 If AForm.FormStyle = fsMDIChild Then
                   If AForm.Visible Then AForm.Show;
          End;


again:
        ex:=False;
        Try
           Repeat
              HandleMessage;
           Until Terminated;
        Except
           On E:Exception Do
           Begin
               ex:=True;
               ExceptObject := E;
               HandleException(Self);
               ExceptObject := Nil;
           End;
        End;
        If ex Then goto again; //don't terminate on exception
     Except
        On E:Exception Do
        Begin
             If ex Then raise; //don't show msg twice
             ExceptObject := E;
             HandleException(Self);
             ExceptObject := Nil;
        End;
     End;

     Try
        If DDEMan_CloseAllLinks<>Nil Then DDEMan_CloseAllLinks;
     Except
     End;
End;

Function TApplication.ProcessMessage:Boolean;
Var  Msg:TMessage;
     Handled:Boolean;
     {$IFDEF OS2}
     Queue:QMSG;
     {$ENDIF}
     {$IFDEF Win32}
     aMsg:WinUser.Msg;
     {$ENDIF}
Begin
     Result := False;
     {$IFDEF OS2}
     If WinPeekMsg(AppHandle,Queue,0,0,0,PM_REMOVE) Then
     Begin
          Result := True;
          If Queue.Msg <> WM_QUIT Then
          Begin
               Handled := False;
               If FOnMessage <> Nil Then
               Begin
                    FillChar(Msg,SizeOf(Msg),0);
                    Msg.Receiver := Queue.HWND;
                    Msg.ReceiverClass := HandleToControl(Queue.HWND);
                    Msg.Msg := Queue.Msg;
                    Msg.Param1 := Queue.mp1;
                    Msg.Param2 := Queue.mp2;
                    FOnMessage(Msg, Handled);
               End;
               If Not Handled Then WinDispatchMsg(AppHandle,Queue);
          End
          Else
          Begin
               Try
                  If FMainForm <> Nil Then
                    If FMainForm.FFrame <> Nil Then
                      If Queue.hwnd = FMainForm.FFrame.Handle
                      Then FMainForm.Close;
               Finally
                  FTerminate := True;
               End;
          End;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     If PeekMessage(aMsg,0,0,0,PM_REMOVE) Then
     Begin
          Result := True;
          If aMsg.Message <> WM_QUIT Then
          Begin
               Handled := False;
               If FOnMessage <> Nil Then
               Begin
                    FillChar(Msg,SizeOf(Msg),0);
                    Msg.Receiver := aMsg.HWND;
                    Msg.ReceiverClass := HandleToControl(aMsg.HWND);
                    Msg.Msg := aMsg.Message;
                    Msg.Param1 := aMsg.WParam;
                    Msg.Param2 := aMsg.LParam;
                    FOnMessage(Msg, Handled);
               End;
               If Not Handled Then
               Begin
                    TranslateMessage(aMsg);
                    DispatchMessage(aMsg);
               End;
          End
          Else
          Begin
               Try
                  If FMainForm <> Nil Then FMainForm.Close;
               Finally
                  FTerminate := True;
               End;
          End;
     End;
     {$ENDIF}
End;

Procedure TApplication.ProcessMessages;
Begin
     While ProcessMessage Do ;
End;


Procedure TApplication.HandleMessage;
Begin
     If Not ProcessMessage Then Idle;
End;


Procedure TApplication.Idle;
Var  Done:Boolean;
Begin
     Done := True;
     If FOnIdle <> Nil Then FOnIdle(Self, Done);
     {$IFDEF OS2}
     If Done Then WinWaitMsg(AppHandle,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     If Done Then WaitMessage;
     {$ENDIF}
End;


Procedure TApplication.Terminate;
{$IFDEF OS2}
Var  Msg:TMessage;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If MainForm <> Nil Then
     Begin
          FillChar(Msg,SizeOf(Msg),0);
          Msg.Receiver := MainForm.Handle;
          Msg.ReceiverClass := MainForm;
          Msg.Msg := WM_CLOSE;
          MainForm.DefaultHandler(Msg);
          {DefaultHandler posts WM_QUIT To Queue}
     End;
     {$ENDIF}
     {$IFDEF Win32}
     PostQuitMessage(0);
     {$ENDIF}
End;


Procedure TApplication.HandleException(Sender:TObject);
Begin
     If FOnException <> Nil Then FOnException(Sender,ExceptObject)
     Else ShowException(ExceptObject);
End;


Procedure TApplication.ShowException(E:Exception);
Begin
     If MessageBox2(E.Message+' at '+tohex(LONGWORD(E.ExcptAddr))+' !'#13#10+
        LoadNLSStr(STerminateProgram),mtCritical,mbYesNo)=mrYes Then Raise E;
End;


Procedure TApplication.HelpIndex;
Begin
     If FHelpWindow<>0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(FHelpWindow,HM_HELP_INDEX,0,0);
          {$ENDIF}
     End;
End;


Procedure TApplication.KeysHelp;
Begin
     If FHelpWindow<>0 Then
     Begin
          If FKeysHelpContext <> 0 Then
          Begin
               HelpContext(FKeysHelpContext);
               exit;
          End;
          {$IFDEF OS2}
          WinSendMsg(FHelpWindow,HM_KEYS_HELP,0,0);
          {$ENDIF}
     End;
End;


Procedure TApplication.HelpOnHelp;
Begin
     If FHelpWindow<>0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(FHelpWindow,HM_DISPLAY_HELP,0,0);
          {$ENDIF}
     End;
End;


Procedure TApplication.HelpContents;
Begin
     If FHelpWindow<>0 Then
     Begin
          {$IFDEF OS2}
          WinSendMsg(FHelpWindow,HM_HELP_CONTENTS,0,0);
          {$ENDIF}
     End;
End;


Function TApplication.HelpJump(Const JumpId:String):Boolean;
{$IFDEF OS2}
Var  CS:Cstring;
{$ENDIF}
Begin
     Result := False;
     If FHelpWindow <> 0 Then
     Begin
          {$IFDEF OS2}
          CS := JumpId;
          Result := (WinSendMsg(FHelpWindow,HM_DISPLAY_HELP,
                                LongWord(@CS),HM_PANELNAME) = 0);
          {$ENDIF}
     End;
End;


Function TApplication.Help(context:THelpContext):Boolean;
Begin
     If FOnHelp<>Nil Then FOnHelp(context,Result)
     Else Result:=HelpContext(context);
End;


Function TApplication.HelpContext(context:THelpContext):Boolean;
Begin
     If context=0 Then
     Begin
          HelpContents;
          Result:=True;
     End
     Else
     Begin
          Result := False;
          If FHelpWindow <> 0 Then
          Begin
               {$IFDEF OS2}
               Result := (WinSendMsg(FHelpWindow,HM_DISPLAY_HELP,
                          LongWord(context),HM_RESOURCEID) = 0);
               {$ENDIF}
          End;
     End;
End;


Procedure TApplication.RunFailed;
Begin
     ErrorBox2(LoadNLSStr(SMainWindowFailed)+'. '+LoadNLSStr(SProgramAborted)+'.');
     Halt(0);
End;


Destructor TApplication.Destroy;
Var  AForm:TForm;
Begin
     Inherited Destroy;
     {FMainForm.Destroy;}

     //Destroy All DeskTop Forms
     While Screen.FForms.Count > 0 Do
     Begin
          AForm:=Screen.FForms[0];
          AForm.Destroy;
     End;

     if Assigned( FIcon ) then
          FIcon.Destroy;

     FMenuItemList.Destroy;
     FMenuItemList := Nil;;

     if self = Application then
          // So that (Forms) Finalization code doesn't try to refer to application...
          Application := nil;

End;


Function TApplication.GetHelpFile:String;
Begin
     Result := '';
     If FHelpFile <> Nil Then Result := FHelpFile^;
End;


Procedure TApplication.SetHelpFile(NewName:String);
Begin
     If FMainForm <> Nil Then
       If FMainForm.Handle <> 0 Then Exit;

     AssignStr(FHelpFile,NewName);
End;


Function TApplication.GetHelpWindowTitle:String;
Begin
     Result := '';
     If FHelpWindowTitle <> Nil Then Result := FHelpWindowTitle^;
End;


Procedure TApplication.SetHelpWindowTitle(NewTitle:String);
Begin
     If FMainForm <> Nil Then
       If FMainForm.Handle <> 0 Then Exit;

     AssignStr(FHelpWindowTitle,NewTitle);
End;


Procedure TApplication.SetHint(Const NewText:String);
Begin
     If FHint <> NewText Then
     Begin
          FHint := NewText;
          If FOnHint <> Nil Then FOnHint(Self);
     End;
End;


Procedure TApplication.HintTimerExpired;
Var  HintInfo:THintInfo;
     CanShow:Boolean;
     MousePos:TPoint;
     BubbleSizeX,BubbleSizey:LongInt;
     BubbleText:String;
     HintRect:TRect;
Begin
     If FHintTimer <> Nil Then FHintTimer.Destroy;
     FHintTimer := Nil;
     If FHintControl = Nil Then Exit;
     If FHintControl.Designed Then Exit;
     If Not FHintControl.Enabled Then Exit;

     If Not FHasFocus Then exit;

     If FHintWindow = Nil Then
     Begin
          FHintWindow := HintWindowClass.Create(Nil);
          FHintWindow.CreateWnd;
     End
     Else
     Begin
         {$IFDEF WIN32}
         FHintWindow.Left:=-1000;
         ShowWindow(FHintWindow.Handle,SW_SHOWNA);
         {$ENDIF}
     End;

     MousePos := Screen.MousePos;

     If Screen.GetControlFromPoint(MousePos) = Nil Then exit;

     BubbleText := GetShortHint(FHintControl.FHint^);
     If BubbleText = '' Then Exit;

     FHintWindow.Canvas.GetTextExtent(BubbleText,BubbleSizeX,BubbleSizeY);

     inc(BubbleSizeX,6);
     inc(BubbleSizeY,4);

     {Position der Bubble anpassen}
     HintRect.Left := MousePos.X;
     If FHintOrigin = hiBottom Then HintRect.Bottom := MousePos.Y - 15 - BubbleSizeY
     Else HintRect.Bottom := MousePos.Y;

     HintInfo.HintControl := FHintControl;
     HintInfo.HintPos := Point(HintRect.Left,HintRect.Bottom);
     HintInfo.HintMaxWidth := Screen.Width;
     HintInfo.HintColor := FHintColor;
     HintInfo.HintPenColor := FHintPenColor;
     HintInfo.CursorRect := FHintControl.WindowRect;
     HintInfo.CursorPos := MousePos;

     CanShow := True;
     If FOnShowHint <> Nil Then FOnShowHint(BubbleText,CanShow,HintInfo);
     If Not CanShow Then Exit;

     FHintWindow.Color := HintInfo.HintColor;
     FHintWindow.PenColor := HintInfo.HintPenColor;

     HintRect.Left := HintInfo.HintPos.X;
     HintRect.Bottom := HintInfo.HintPos.Y;
     HintRect.Right := HintRect.Left + BubbleSizeX;
     HintRect.Top := HintRect.Bottom + BubbleSizeY;

     //hier evtl. Word Wrap
     If HintInfo.HintMaxWidth < BubbleSizeX Then
     Begin
          HintRect.Right := HintRect.Left + HintInfo.HintMaxWidth;
     End;

     FHintWindow.ActivateHint(HintRect, BubbleText);

     FHintOwner := FHintControl;
     FHintParent := FHintControl.Parent;
End;


Procedure TApplication.DestroyHintWindow;
Begin
     If FHintOwner = Nil Then Exit; {no Hint Is Showing}
     FHintOwner := Nil;
     FHintParent := Nil;

     FHintWindow.DeactivateHint;
End;


Function TApplication.NewMenuItem(entry:TMenuItem):TCommand;
var idx:LongInt;
Begin
     // First look for a blank slot to re-use
     For Idx := 0 to FMenuItemList.Count - 1 Do
     Begin
          If FMenuItemList[ Idx ] = Nil Then
          Begin
               // found blank slot
               FMenuItemList[ Idx ] := entry;
               Result := idx + cmInternalMenuItemBase;
               Exit;
          End;
     End;

     // No blank slots, add to list.
     Result := FMenuItemList.Count + cmInternalMenuItemBase;
     FMenuItemList.Add(entry);
End;


Procedure TApplication.DeleteMenuItem(entry:TMenuItem);
Var  idx:LongInt;
Begin
     idx := FMenuItemList.IndexOf(entry);
     If idx >= 0 Then FMenuItemList.Items[idx] := Nil;
End;


Function TApplication.GetMenuItem(Command:TCommand):TMenuItem;
Var  idx:LongInt;
Begin
     idx := Command - cmInternalMenuItemBase;
     If (idx >= 0) And (idx < FMenuItemList.Count) Then
     Begin
          Result := TMenuItem(FMenuItemList.Items[idx]);
          If Not (Result Is TMenuItem) Then Result := Nil;
     End
     Else Result := Nil;
End;


Procedure TApplication.SetFont(NewFont:TFont);
Var  Form:TForm;
     I:LongInt;
Begin
     If FFont <> NewFont Then
     Begin
          DereferenceFont(FFont);
          FFont := NewFont;
          ReferenceFont(FFont);
     End;

     For I := 0 To Screen.FormCount-1 Do
     Begin
          Form := Screen.Forms[I];
          If Not Form.Designed Then
            If Form.ParentFont Then
            Begin
                 Form.SetFont(FFont);
                 Form.FParentFont := True;
            End;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: THintWindow Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure THintWindow.SetupComponent;
Begin
     Inherited SetupComponent;

     Font := Screen.SmallFont;
     {$IFDEF WIN32}
     Ownerdraw := True;
     {$ENDIF}
     Include(ControlStyle,csHintWindow);
End;

{$IFDEF WIN32}

Procedure THintWindow.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     CreateSubClass(ClassData,'BUTTON');
End;

Procedure THintWindow.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     Params.Style := Params.Style Or BS_USERBUTTON Or WS_DISABLED Or WS_POPUP;
End;

Procedure THintWindow.CreateWnd;
Var Style:LongWord;
    cCaption:CString;
    rc:TRect;
    OldWndProc:Pointer;
Begin
     {$IFDEF WIN32}
     FLeft:=-1000;
     {$ENDIF}

     Inherited CreateWnd;

     {$IFDEF WIN32}
     ShowWindow(Handle,SW_SHOWNA);
     {$ENDIF}
End;
{$ENDIF}


Procedure THintWindow.Redraw(Const rec:TRect);
Var  rc:TRect;
Begin
     If Canvas = Nil Then exit;

     Canvas.Pen.Color := PenColor;
     Canvas.Brush.Color := Color;

     Inherited Redraw(rec);

     rc := ClientRect;
     Canvas.TextOut(3,2, Caption);
     Canvas.ShadowedBorder(rc,clWhite,clBlack);
     InflateRect(rc,-1,-1);
     Canvas.ShadowedBorder(rc,Color,clDkGray);
End;

Procedure THintWindow.ActivateHint(Rect:TRect; Const AHint:String);
Begin
     Caption := AHint;
     WindowRect := Rect;

     If Rect.Left + Width > Screen.Width Then Rect.Left := Screen.Width - Width;
     If Rect.Left < 0 Then Rect.Left := 0;
     If Rect.Bottom + Height > Screen.Height Then Rect.Bottom := Screen.Height - HeIght;
     If Rect.Bottom < 0 Then Rect.Bottom := 0;

     SetWindowPos(Rect.Left, Rect.Bottom, Width, Height);
     Show;
End;


Procedure THintWindow.DeactivateHint;
Begin
     Hide;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TFont Class Implementation                                  บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TFont.Create(AOwner:TComponent);
Begin
     If AOwner<>Screen Then AOwner:=Screen; //!!
     Inherited Create(AOwner);
End;

Procedure TFont.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Font';
End;

Destructor TFont.Destroy;
Begin
     Inherited Destroy;

     If FAlternateName<>Nil Then DisposeStr(FAlternateName);
     FAlternateName:=Nil;
End;

Procedure TFont.SetHeight(NewHeight:LongInt);
Begin
     {If Font Is changed FInternalPointSize Is no longer Valid}
     FInternalPointSize:=0;
     {$IFDEF OS2}
     FFontInfo.lMaxbaseLineExt:=NewHeight;
     {$ENDIF}
     {$IFDEF Win32}
     FFontInfo.lfHeight:=NewHeight;
     {$ENDIF}
End;

Procedure TFont.SetWidth(NewWidth:LongInt);
Begin
     {If Font Is changed FInternalPointSize Is no longer Valid}
     FInternalPointSize:=0;
     {$IFDEF OS2}
     FFontInfo.LMaxCharInc:=NewWidth;
     {$ENDIF}
     {$IFDEF Win32}
     FFontInfo.lfWidth:=NewWidth;
     {$ENDIF}
End;

Procedure TFont.SetAttributes(NewAttr:TFontAttributes);
Begin
     {$IFDEF OS2}
     FFontInfo.fsSelection:=FFontInfo.fsSelection And Not
                  (FM_SEL_BOLD Or FM_SEL_ITALIC Or FM_SEL_UNDERSCORE Or
                   FM_SEL_STRIKEOUT Or FM_SEL_OUTLINE);
     If NewAttr*[faBold]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_BOLD;
     If NewAttr*[faItalic]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_ITALIC;
     If NewAttr*[faUnderScore]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_UNDERSCORE;
     If NewAttr*[faStrikeOut]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_STRIKEOUT;
     If NewAttr*[faOutline]<>[] Then
        FFontInfo.fsSelection:=FFontInfo.fsSelection Or FM_SEL_OUTLINE;
     {$ENDIF}
     {$IFDEF Win32}
     If NewAttr*[faBold]<>[] Then FFontInfo.lfWeight:=FW_BOLD
     Else If FFontInfo.lfWeight=FW_BOLD Then FFontInfo.lfWeight:=0;
     If NewAttr*[faItalic]<>[] Then FFontInfo.lfItalic:=1
     Else FFontInfo.lfItalic:=0;
     If NewAttr*[faUnderScore]<>[] Then FFontInfo.lfUnderline:=1
     Else FFontInfo.lfUnderline:=0;
     If NewAttr*[faStrikeOut]<>[] Then FFontInfo.lfStrikeOut:=1
     Else FFontInfo.lfStrikeOut:=0;
     {$ENDIF}
End;

Function TFont.GetAttributes:TFontAttributes;
Begin
     Result:=[];
     {$IFDEF OS2}
     If FFontInfo.fsSelection And FM_SEL_BOLD<>0 Then Include(Result,faBold);
     If FFontInfo.fsSelection And FM_SEL_ITALIC<>0 Then Include(Result,faItalic);
     If FFontInfo.fsSelection And FM_SEL_UNDERSCORE<>0 Then Include(Result,faUnderSCore);
     If FFontInfo.fsSelection And FM_SEL_STRIKEOUT<>0 Then Include(Result,faStrikeOUt);
     If FFontInfo.fsSelection And FM_SEL_OUTLINE<>0 Then Include(Result,faOutline);
     {$ENDIF}
     {$IFDEF Win32}
     If FFontInfo.lfWeight=FW_BOLD Then Include(Result,faBold);
     If FFontInfo.lfItalic<>0 Then Include(Result,faItalic);
     If FFontInfo.lfUnderline<>0 Then Include(Result,faUnderScore);
     If FFontInfo.lfStrikeOut<>0 Then Include(Result,faStrikeOut);
     {$ENDIF}
End;

Function TFont.GetMinimumPointSize:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.sMinimumPointSize Div 10;
     {$ENDIF}
     {$IFDEF Win32}
     {.?.}
     Result:=PointSize;
     {$ENDIF}
End;

Function TFont.GetMaximumPointSize:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.sMaximumPointSize Div 10;
     {$ENDIF}
     {$IFDEF Win32}
     {.?.}
     Result:=PointSize;
     {$ENDIF}
End;

Function TFont.GetNominalPointSize:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.sNominalPointSize Div 10;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=PointSize;
     {$ENDIF}
End;

Function TFont.GetInternalLeading:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.lInternalLeading;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=0;
     {$ENDIF}
End;

// AaronL - returns (max) descender height of font.
Function TFont.GetDescenderHeight:LongInt;
Begin
     {$IFDEF OS2}
     Result := FFontInfo.lMaxDescender;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=0; // todo win32
     {$ENDIF}
End;

Function TFont.GetHeight:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.lMaxbaseLineExt;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=FFontInfo.lfHeight;
     {$ENDIF}
End;

Function TFont.GetWidth:LongInt;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.lAveCharWidth;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=FFontInfo.lfWidth;
     {$ENDIF}
End;

Function TFont.GetPitch:TFontPitch;
Begin
     {$IFDEF OS2}
     If FFontInfo.fsType And FM_TYPE_FIXED<>0 Then Result:=fpFixed
     Else Result:=fpProportional;
     {$ENDIF}
     {$IFDEF Win32}
     If FFontInfo.lfPitchAndFamily And 3=1 Then Result:=fpFixed
     Else Result:=fpProportional;
     {$ENDIF}
End;

Function TFont.GetCharSet:TFontCharSet;
Begin
     {$IFDEF OS2}
     If FFontInfo.fsType And FM_TYPE_MBCS <> 0 Then Result := fcsMBCS
     Else If FFontInfo.fsType And FM_TYPE_DBCS <> 0 Then Result := fcsDBCS
          Else Result := fcsSBCS;
     {$ENDIF}
     {$IFDEF Win32}
     Result := fcsSBCS;
     {$ENDIF}
End;

Function TFont.GetName:String;
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.szFaceName;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=FFontInfo.lfFaceName;
     {$ENDIF}
End;

Function TFont.GetFamily:String;
{$IFDEF Win32}
Var Family:Byte;
{$ENDIF}
Begin
     {$IFDEF OS2}
     Result:=FFontInfo.szFamilyName;
     {$ENDIF}
     {$IFDEF Win32}
     If FFontType=ftBitmap Then Result:='Bitmap'
     Else Result:='TrueType';
     Family:=FFontInfo.lfPitchAndFamily And 240;
     If Family=FF_ROMAN Then Result:='Roman';
     If Family=FF_SWISS Then Result:='Swiss';
     If Family=FF_MODERN Then Result:='Modern';
     If Family=FF_SCRIPT Then Result:='Script';
     If Family=FF_DECORATIVE Then Result:='Decorative';
     {$ENDIF}
End;


Type
    PFontRes=^TFontRes;
    TFontRes=Array[0..512] Of Char;


Function TFont.WriteSCUResourceName(Stream:TResourceStream;ResName:TResourceName):BOolean;
Var  Data:PFontRes;
     T:Byte;
     S,s1:String;
     Attrs:TFontAttributes;
     t1:LongInt;
Begin
     If FAlternateName=Nil Then
       If ((Self=Screen.DefaultFont)Or(FDefault)) Then {dont Write it}
       Begin
            Result := True;
            Exit;
       End;

     S:=FaceName;
     If FDefault Then S:='System Default Font';

     s1:=S;
     UpcaseStr(s1);
     Attrs:=Attributes;
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',s1)=0 Then S:=S+'!BOLD!';
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',s1)=0 Then S:=S+'!ITALIC!';
     If Attrs*[faOutline]<>[] Then S:=S+'!OUTLINE!';
     If Attrs*[faStrikeOut]<>[] Then S:=S+'!STRIKEOUT!';
     If Attrs*[faUnderScore]<>[] Then S:=S+'!UNDERSCORE!';

     GetMem(Data,512);
     For T := 0 To Length(S) Do Data^[T] := S[T];

     T := Length(S)+1;

     If FAlternateName<>Nil Then
     Begin
          //AlternateName starts with #2
          For t1:=1 To length(FAlternateName^) Do
            Data^[(t+t1)-1]:=FAlternateName^[t1];
          inc(t,length(FAlternateName^));
     End;

     If FInternalPointSize <> 0 Then
     Begin
          Data^[T] := #1;
          Data^[T+1] := Chr(FInternalPointSize);
          Data^[T+2] := #0;
     End
     Else
     Begin
          Data^[T] := #0;
          Data^[T+1] := Chr(Width);
          Data^[T+2] := Chr(Height);
     End;

     inc(t,3);
     Result := Stream.NewResourceEntry(ResName,Data^,t);
     FreeMem(Data,512);
End;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
     Result:=FontName;
     UpcaseStr(FontName);
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',FontName)=0 Then Result:=Result+'.Italic';
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',FontName)=0 Then Result:=Result+'.Bold';
     If Attrs*[faOutline]<>[] Then Result:=Result+'.Outline';
     If Attrs*[faStrikeOut]<>[] Then Result:=Result+'.Strikeout';
     If Attrs*[faUnderScore]<>[] Then Result:=Result+'.Underscore';
End;

{$HINTS OFF}
Function ReadSCUFont(Var Data;DataLen:LongInt):TFont;
Var  Data1:PFontRes;
     T,T1:Byte;
     PointSize,W,H:Byte;
     Face,FaceName:String;
     Attrs,AlternateAttrs:TFontAttributes;
     AlternateFace,AlternateFaceName:String;
     AlternatePointSize:Byte;
     AlternateW,AlternateH:Byte;
Label go;
Begin
     AlternateFaceName:='';
     AlternateFace:='';
     AlternatePointSize:=0;
     AlternateW:=0;
     AlternateH:=0;
     PointSize:=0;
     W:=0;
     H:=0;

     Data1 := @Data;
     For T := 0 To Ord(Data1^[0]) Do FaceName[T] := Data1^[T];
     Face:=FaceName;

     Attrs:=[];
     T:=Pos('!',FaceName);
     If T<>0 Then
     Begin
          If Pos('!BOLD!',FaceName)<>0 Then Attrs:=Attrs+[faBold];
          If Pos('!ITALIC!',FaceName)<>0 Then Attrs:=Attrs+[faItalic];
          If Pos('!OUTLINE!',FaceName)<>0 Then Attrs:=Attrs+[faOutline];
          If Pos('!STRIKEOUT!',FaceName)<>0 Then Attrs:=Attrs+[faStrikeOut];
          If Pos('!UNDERSCORE!',FaceName)<>0 Then Attrs:=Attrs+[faUnderScore];
          If Attrs<>[] Then FaceName[0]:=Chr(T-1);
     End;

     If FaceName='System Default Font' Then
     Begin
          Result:=Screen.DefaultFont;
          //ignore alternate facename here, the user wants default fonts !
     End
     Else
     Begin
          T := Ord(Data1^[0])+1;
go:
          If Data1^[T] = #1 Then
          Begin
               PointSize := Ord(Data1^[T+1]);
               FaceName:=ModifyFontName(FaceName,Attrs);
               Result := Screen.GetFontFromPointSize(FaceName,PointSize);
          End
          Else If Data1^[t] = #2 Then //Alternate Facename follows, new SCU
          Begin
               inc(t);
               For t1:=t To t+Ord(Data1^[t]) Do AlternateFaceName[t1-t]:=Data1^[t1];
               inc(t,ord(Data1^[t])+1);
               AlternateFace:=AlternateFaceName;

               AlternateAttrs:=[];
               T1:=Pos('!',AlternateFaceName);
               If T1<>0 Then
               Begin
                  If Pos('!BOLD!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faBold];
                  If Pos('!ITALIC!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faItalic];
                  If Pos('!OUTLINE!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faOutline];
                  If Pos('!STRIKEOUT!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faStrikeOut];
                  If Pos('!UNDERSCORE!',AlternateFaceName)<>0 Then AlternateAttrs:=AlternateAttrs+[faUnderScore];
                  If AlternateAttrs<>[] Then AlternateFaceName[0]:=Chr(T1-1);
               End;

               If Data1^[T] = #1 Then
               Begin
                    AlternatePointSize := Ord(Data1^[T+1]);
                    AlternateFaceName:=ModifyFontName(AlternateFaceName,AlternateAttrs);
                    inc(t,3); //skip also dummy #0
                    goto go;
               End
               Else
               Begin
                   AlternateW := Ord(Data1^[T+1]);
                   AlternateH := Ord(Data1^[T+2]);
                   AlternateFaceName:=ModifyFontName(AlternateFaceName,AlternateAttrs);
                   inc(t,3);
                   goto go;
               End;
          End
          Else //old style SCU format
          Begin
               W := Ord(Data1^[T+1]);
               H := Ord(Data1^[T+2]);
               FaceName:=ModifyFontName(FaceName,Attrs);
               Result := Screen.GetFontFromName(FaceName,H,W);
          End;

          If Result=Nil Then //Font could not be created,maybe its OS/2 or Win Font
          Begin
               //Try alternate facename if present
               If AlternateFaceName<>'' Then
               Begin
                    Attrs:=AlternateAttrs;

                    If AlternateFace='System Default Font' Then Result:=Screen.DefaultFont
                    Else
                    Begin
                       If AlternatePointSize<>0 Then
                         Result := Screen.GetFontFromPointSize(AlternateFaceName,AlternatePointSize)
                       Else
                         Result := Screen.GetFontFromName(AlternateFaceName,AlternateH,AlternateW);
                    End;
               End;

               //if neither normal nor alternate font work, set a default
               If Result=Nil Then Result:=Screen.SmallFont;

               //set alternate facename (the one that did not work)
               If Face<>'' Then
               Begin
                   FaceName:=#2+Face[0]+Face;
                   If PointSize<>0 Then
                       FaceName:=FaceName+#1+chr(PointSize)+#0
                   Else
                       FaceName:=FaceName+#0+chr(W)+chr(H);
               End
               Else FaceName:='';

               If FaceName<>'' Then
                If Result<>Nil Then AssignStr(Result.FAlternateName,FaceName);
          End
          Else
          Begin
               //Font is ok, set alternate facename if present
               If AlternateFace<>'' Then
               Begin
                   AlternateFaceName:=#2+AlternateFace[0]+AlternateFace;
                   If AlternatePointSize<>0 Then
                      AlternateFaceName:=AlternateFaceName+#1+chr(AlternatePointSize)+#0
                   Else
                      AlternateFaceName:=AlternateFaceName+#0+chr(AlternateW)+chr(AlternateH);
               End
               Else AlternateFaceName:='';

               If AlternateFaceName<>'' Then
                 If Result<>Nil Then AssignStr(Result.FAlternateName,AlternateFaceName);
          End;

          If Result<>Nil Then If Result.Attributes*Attrs<>Attrs Then
          Begin
               Result:=Screen.CreateCompatibleFont(Result);
               Result.Attributes:=Attrs;
               Result.AutoDestroy:=True;
          End;
     End;
End;
{$HINTS ON}

///////////////////////////////////////////////////////////////////////

Type
    THiddenWindow=Class(TControl)
      protected
         {$IFDEF OS2}
         Procedure WMInitMenu(Var Msg:TMessage); Message WM_INITMENU;
         Procedure WMMenuEnd(Var Msg:TMessage); Message WM_MENUEND;
         Procedure WMMenuSelect(Var Msg:TMessage); Message WM_MENUSELECT;
         Function GetData(Handle:LongWord;Var Menu:TPopupMenu;Var entry:TMenuItem):TForm;
         {$ENDIF}
         Procedure WMTimer(Var Msg:TWMTimer); Message WM_TIMER;
    End;

{$IFDEF OS2}
Function THiddenWindow.GetData(Handle:LongWord;Var Menu:TPopupMenu;Var entry:TMenuItem):TForm;
Begin
     entry := Pointer(WinQueryWindowULong(Handle,QWL_USER));  {Get VMT Pointer}

     If entry Is TMenuItem Then Menu := TPopupMenu(entry.FMenu)
     Else
     Begin
          Menu := TPopupMenu(entry);
          entry := Nil;
     End;

     If Not (Menu Is TPopupMenu) Then Menu:=Nil;

     //determine Form !
     If Menu<>Nil Then
     Begin
          If Menu.FPopupComponent Is TForm Then Result:=TForm(Menu.FPopupComponent)
          Else If Menu.Owner Is TForm Then Result:=TForm(Menu.Owner)
          Else Result:=Nil;
     End
     Else Result:=Nil;
End;

Procedure THiddenWindow.WMInitMenu(Var Msg:TMessage);
Var Form:TForm;
    entry:TMenuItem;
    Menu:TPopupMenu;
Begin
     Form:=GetData(Msg.Param2,Menu,entry);
     If Form<>Nil Then Form.MenuInit(Menu,entry);
End;

Procedure THiddenWindow.WMMenuEnd(Var Msg:TMessage);
Var Form:TForm;
    entry:TMenuItem;
    Menu:TPopupMenu;
Begin
     Form:=GetData(Msg.Param2,Menu,entry);
     If Form<>Nil Then Form.MenuEnd(Menu,entry);
End;

Procedure THiddenWindow.WMMenuSelect(Var Msg:TMessage);
Var Form:TForm;
    entry:TMenuItem;
    Menu:TPopupMenu;
Begin
     Form:=GetData(Msg.Param2,Menu,entry);
     If Menu<>Nil Then entry := Menu.ItemFromInternalCommand(Msg.Param1Lo);
     If Form<>Nil Then Form.MenuItemFocus(Menu,entry);
End;
{$ENDIF}


//////////// Handle Timer Messages

Procedure THiddenWindow.WMTimer(Var Msg:TWMTimer);
Var  TID:LongWord;
     Timer:TTimer;
     T:LongInt;
Begin
     TID := Msg.TimerId;

     {Search If the Timer Is Valid For us}
     T := 0;
     While T < TimerList.Count Do
     Begin
          Timer := TimerList.Items[T];

          If Timer <> Nil Then
            If Timer.FId = TID Then
              //If Timer.FControl = Self Then {found}
              Begin
                   If Timer = Application.FHintTimer Then
                   Begin
                        If Application.ShowHint Then
                          If Application.FHintControl <> Nil Then
                            If Application.FHintControl.FHint <> Nil Then
                              If Application.FHintControl.GetShowHint
                              Then Application.HintTimerExpired;
                   End
                   Else
                   Begin
                        Inc(Timer.FTime,Timer.FInterval);
                        Timer.Timer;
                   End;

                   Msg.Handled := True;
                   Msg.Result := 0;
                   break;
              End;
          Inc(T);
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TScreen Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF Win32}
{$HINTS OFF}
Function EnumFontCallBack(Var lplf:LOGFONT;Var lptm:TEXTMETRIC;
                          nFontType:LongInt;Data:Pointer):LongInt;APIENTRY;
Var Font,Temp:TFont;
Begin
     Font.Create(Screen);
     Font.FFontInfo:=lplf;
     Font.FFontType:=ftBitmap;
     If nFontType And 4=4 Then Font.FFontType:=ftOutline;
     Screen.FFonts.Add(Font);

     If Font.FaceName='Times New Roman' Then
     Begin
          Temp:=Screen.CreateCompatibleFont(Font);
          Temp.FCustom:=False;
          FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
          Temp.FFontInfo.lfFaceName:='Times New Roman';
          Temp.FFontInfo.lfHeight:=16;
          Temp.FFontInfo.lfWidth:=6;
          Screen.FFonts.Add(Temp);
     End;

     If Font.FaceName='Arial' Then
     Begin
          Temp:=Screen.CreateCompatibleFont(Font);
          Temp.FCustom:=False;
          FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
          Temp.FFontInfo.lfFaceName:='Arial';
          Temp.FFontInfo.lfHeight:=14;
          Temp.FFontInfo.lfWidth:=5;
          Screen.FFonts.Add(Temp);

          Temp:=Screen.CreateCompatibleFont(Font);
          Temp.FCustom:=False;
          FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
          Temp.FFontInfo.lfFaceName:='Arial';
          Temp.FFontInfo.lfHeight:=16;
          Temp.FFontInfo.lfWidth:=6;
          Screen.FFonts.Add(Temp);
     End;
     If Font.FaceName='MS Sans Serif' Then
     Begin
          Temp:=Screen.CreateCompatibleFont(Font);
          Temp.FCustom:=False;
          FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
          Temp.FFontInfo.lfFaceName:='MS Sans Serif';
          Temp.FFontInfo.lfHeight:=15;
          Temp.FFontInfo.lfWidth:=5;
          Temp.FInternalPointSize:=8;
          Screen.FFonts.Add(Temp);

          Temp:=Screen.CreateCompatibleFont(Font);
          Temp.FCustom:=False;
          FillChar(Temp.FFontInfo,SizeOf(Temp.FFontInfo),0);
          Temp.FFontInfo.lfFaceName:='MS Sans Serif';
          Temp.FFontInfo.lfHeight:=16;
          Temp.FFontInfo.lfWidth:=7;
          Temp.FInternalPointSize:=10;
          Screen.FFonts.Add(Temp);
     End;
     Result:=1;
End;
{$HINTS ON}
{$ENDIF}


Function TScreen.GetCanvas:TCanvas;
Begin
     Result:=FCanvas;
     {$IFDEF WIN32}
     If FCanvas<>Nil Then If FCanvas.FHandle=0 Then
     Begin
          FCanvas.FHandle:=CreateDC('DISPLAY',Nil,Nil,Nil);
          FCanvas.Brush.Color:=FCanvas.Brush.FColor;
          FCanvas.Brush.Mode:=FCanvas.Brush.FMode;
          FCanvas.Brush.Style:=FCanvas.Brush.FStyle;
          FCanvas.Pen.Color:=FCanvas.Pen.FColor;
          FCanvas.Pen.Mode:=FCanvas.Pen.FMode;
          FCanvas.Pen.Style:=FCanvas.Pen.FStyle;
          FCanvas.Pen.Width:=FCanvas.Pen.FWidth;
          FCanvas.Font:=FCanvas.FFont;
     End;
     {$ENDIF}
End;

Procedure TScreen.MapPoints(target:TControl;Var pts:Array Of TPoint);
Begin
     If ((target=Nil)Or(target.Handle=0)) Then Exit;

     {$IFDEF OS2}
     WinMapWindowPoints(HWND_DESKTOP,target.Handle,pts[0],High(pts)+1);
     {$ENDIF}
     {$IFDEF Win32}
     {!!!!!!!!!!!!!!!! evtl umrechnen}
     MapWindowPoints(HWND_DESKTOP,target.Handle,pts[0],High(pts)+1);
     {$ENDIF}
End;


Procedure TScreen.Update;
Begin
     {$IFDEF OS2}
     WinUpdateWindow(HWND_DESKTOP);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.UpdateWindow(HWND_DESKTOP);
     {$ENDIF}
End;


Procedure TScreen.SetupComponent;
{$IFDEF OS2}
Var Count:LongInt;
    aPS:HPS;
    T:LongInt;
    Font:TFont;
Type
   PMyFontMetrics=^TMyFontMetrics;
   TMyFontMetrics=Array[0..1] Of FONTMETRICS;
Var
   pfm:PMyFontMetrics;
   fcd:FRAMECDATA;
   FHandle,Menu:LongWord;
   Titlebar:LongWord;
   cFNS:Cstring;
   FaceName,Temp:String;
   PointSize:LongInt;
   C:Integer;
   fm:FONTMETRICS;
{$ENDIF}
{$IFDEF Win95}
Var
   aHDC:HDC;
{$ENDIF}
Begin
     Inherited SetupComponent;

     FFonts.Create;

     {$IFDEF OS2}
     aPS:=WinGetPS(HWND_DESKTOP);
     Count:=0;
     Count:=GpiQueryFonts(aPS,QF_PUBLIC,Nil,Count,0,Nil);
     If Count>0 Then
     Begin
          GetMem(pfm,Count*SizeOf(FONTMETRICS));
          GpiQueryFonts(aPS,QF_PUBLIC,Nil,Count,
                        SizeOf(FONTMETRICS),pfm^[0]);

          For T:=0 To Count-1 Do
          Begin
               Font.Create(Screen);
               Font.FFontInfo:=pfm^[T];
               Font.FFontType:=ftBitmap;
               If Font.FFontInfo.fsDefn And FM_DEFN_OUTLINE<>0
               Then Font.FFontType:=ftOutline;
               {Else Font.FInternalPointSize:=Font.FFontInfo.sNominalPointSize Div 10;}
               FFonts.Add(Font);
          End;
     End;
     FreeMem(pfm,Count*SizeOf(FONTMETRICS));
     WinReleasePS(aPS);
     {$ENDIF}
     {$IFDEF Win95}
     aHDC:=GetDC(HWND_DESKTOP);
     EnumFonts(aHDC,Nil,Pointer(@EnumFontCallBack),Nil);
     ReleaseDC(HWND_DESKTOP,aHDC);
     {$ENDIF}

     FFontWindow.Create(Nil);
     FFontWindow.FOwnerDraw:=True;
     FFontWindow.CreateWnd;

     FHiddenWindow:=THiddenWindow.Create(Nil);
     FHiddenWindow.CreateWnd;

     // target Window For WM_TIMER Messages
     TimerWindow := FHiddenWindow.Handle;


     {$IFDEF OS2}
     //determine Default Font
     aPS:=WinGetPS(HWND_DESKTOP);
     If GpiQueryFontMetrics(aPS,SizeOf(FONTMETRICS),fm) Then
     Begin
          If fm.sNominalPointSize<>0 Then
            FDefaultFont:=Screen.GetFontFromPointSize(fm.szFaceName,fm.sNominalPointSize Div 10);
          If FDefaultFont=Nil Then FDefaultFont:=GetFontFromPointSize(fm.szFaceName,10);
     End;
     WinReleasePS(aPS);
     If DefaultFont<>Nil Then If FSystemFont=Nil Then
     Begin
          FSystemFont:=Screen.CreateCompatibleFont(DefaultFont);
          FSystemFont.FDefault:=True;
     End;

     //determine Default System Menu Font
     fcd.cb:=SizeOf(FRAMECDATA);
     fcd.flCreateFlags:=FCF_TITLEBAR Or FCF_SYSMENU;
     fcd.hModResources:=0;
     fcd.idResources:=0;

     cFNS:='';
     FHandle:=WinCreateWCWindow(HWND_DESKTOP,WC_FRAME,cFNS,
                                0,               //flStyle
                                0,0,             //leave This ON 0 - Set by .Show
                                0,0,             //Position And Size
                                HWND_DESKTOP,    //Parent
                                HWND_TOP,        //Insert behind
                                1,               //Window Id
                                @fcd,            //CtlData
                                Nil);            //Presparams
     Menu:=WinWindowFromID(FHandle,FID_SYSMENU);
     If WinQueryPresParam(Menu,PP_FONTNAMESIZE,0,Nil,SizeOf(cFNS),cFNS,QPF_NOINHERIT)<>0 Then
     Begin
          FaceName:=cFNS;
          If Pos('.',FaceName)<>0 Then
          Begin
               Temp:=Copy(FaceName,1,Pos('.',FaceName)-1);
               Delete(FaceName,1,Pos('.',FaceName));
               Val(Temp,PointSize,C);
               If C=0 Then FMenuFont:=GetFontFromPointSize(FaceName,PointSize)
               Else FMenuFont:=DefaultFont;
          End;
     End
     Else FMenuFont:=DefaultFont;

     Titlebar:=WinWindowFromID(FHandle,FID_TITLEBAR);
     If WinQueryPresParam(Titlebar,PP_FONTNAMESIZE,0,Nil,SizeOf(cFNS),cFNS,QPF_NOINHERIT)<>0 then
     Begin
          FaceName:=cFNS;
          If Pos('.',FaceName)<>0 Then
          Begin
               Temp:=Copy(FaceName,1,Pos('.',FaceName)-1);
               Delete(FaceName,1,Pos('.',FaceName));
               Val(Temp,PointSize,C);
               If C=0 Then FDefaultFrameFont:=GetFontFromPointSize(FaceName,PointSize)
               Else FDefaultFrameFont:=DefaultFont;
          End;
     End
     Else FDefaultFrameFont:=DefaultFont;

     WinDestroyWindow(FHandle);
     {$ENDIF}
     {$IFDEF Win95}
     FMenuFont:=DefaultFont;
     FDefaultFrameFont:=DefaultFont;
     {$ENDIF}

     FForms.Create;
     FActiveForm:=Nil;
     CreateCursors;
     FCursor:=crDefault;
     Name:='Screen';
     FCanvas.Create(Nil);
     FCanvas.FOwnerDraw:=True;

     {$IFDEF OS2}
     FCanvas.Handle:=WinGetScreenPS(HWND_DESKTOP);
     GpiCreateLogColorTable(FCanvas.Handle,LCOL_RESET,LCOLF_RGB,0,0,Nil);
     {$ENDIF}
     {$IFDEF Win95}
     FCanvas.FHandle:=CreateDC('DISPLAY',Nil,Nil,Nil);
     FCanvas.FPenHandle:=CreatePen(PS_SOLID,0,0);  //Black solid Pen
     FCanvas.FBrushHandle:=CreateSolidBrush(0);    //Black Brush
     {$ENDIF}
     FCanvas.Init;
     FCanvas.Font:=DefaultFont; {small}
End;


Function TScreen.CreateCompatibleFont(Src:TFont):TFont;
Begin
     if Src = nil then
       Src := DefaultFont;
     Result.Create(Screen);
     Result.FFontInfo:=Src.FFontInfo;
     Result.FFontType:=Src.FFontType;
     Result.FInternalPointSize:=Src.FInternalPointSize;
     Result.FCustom:=True;
End;


Function TScreen.GetFontFromPointSize(FaceName:String;PointSize:LongWord):TFont;
Var  T:LongInt;
     Font:TFont;
     {$IFDEF OS2}
     S,s1:String;
     _hps:LongWord;
Label l;
     {$ENDIF}
     {$IFDEF WIN32}
Var
     s,s1:String;
     b:Byte;
     aFontInfo:LOGFONT;
     tm:TEXTMETRIC;
     TempHandle:LongWord;
     {$ENDIF}
Var
     Attrs:TFontAttributes;
Label BoldItalic;
Begin
     Attrs:=[];
     {$IFDEF OS2}
     S:=FaceName;
     UpcaseStr(S);
L:
     For T:=Length(S) Downto 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    FaceName[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
               End;
          End;
     End;
     {$ENDIF}

     If FaceName='System Default Font' Then
     Begin
          Result:=DefaultFont;
          Exit;
     End;

     //don't allow To Set "Helv Bold.Bold" Or "Helv Italic.Italic" !
     S:=FaceName+' ';
     UpcaseStr(S);
     If Pos(' BOLD',S)<>0 Then Attrs:=Attrs-[faBold];
     If Pos(' ITALIC',S)<>0 Then Attrs:=Attrs-[faItalic];

     {$IFDEF WIN32}
     s1:=FaceName;
     UpcaseStr(s1);
     b:=pos('.BOLD',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faBold];
          Delete(s1,b,length('.BOLD'));
          Delete(FaceName,b,length('.BOLD'));
     End;
     b:=pos('.ITALIC',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faItalic];
          Delete(s1,b,length('.ITALIC'));
          Delete(FaceName,b,length('.ITALIC'));
     End;
     b:=pos('.OUTLINE',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faOutLine];
          Delete(s1,b,length('.OUTLINE'));
          Delete(FaceName,b,length('.OUTLINE'));
     End;
     b:=pos('.STRIKEOUT',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faStrikeOut];
          Delete(s1,b,length('.STRIKEOUT'));
          Delete(FaceName,b,length('.STRIKEOUT'));
     End;
     b:=pos('.UNDERSCORE',s1);
     If b<>0 Then
     Begin
          Attrs:=Attrs+[faUnderScore];
          Delete(s1,b,length('.UNDERSCORE'));
          Delete(FaceName,b,length('.UNDERSCORE'));
     End;
     {$ENDIF}

     If Attrs*[faBold,faItalic]=[faBold,faItalic] Then
     Begin
          //look If we Find A Bold Italic Font With the same Name !
BoldItalic:
          For T:=0 To Screen.FontCount-1 Do
          Begin
               s1:=Screen.Fonts[T].FaceName;
               UpcaseStr(s1);
               If Pos(S,s1)=1 Then If Pos(' BOLD ITALIC',s1)<>0 Then
               Begin
                    Attrs:=Attrs-[faBold,faItalic];
                    FaceName:=Screen.Fonts[T].FaceName;
                    break;
               End;
          End;
     End
     Else If Attrs*[faBold]<>[] Then
     Begin
          //look If we Find A Bold Font With the same Name !
          T:=Pos(' ITALIC',S);
          If T<>0 Then
          Begin
               Delete(S,T,7);
               Goto BoldItalic;
          End;

          For T:=0 To Screen.FontCount-1 Do
          Begin
               s1:=Screen.Fonts[T].FaceName;
               UpcaseStr(s1);
               If Pos(S,s1)=1 Then If Pos(' BOLD',s1)<>0 Then
                If ((Pos(' ITALIC',s1)=0)Or(Pos(' ITALIC',S)<>0)) Then
               Begin
                    Attrs:=Attrs-[faBold];
                    FaceName:=Screen.Fonts[T].FaceName;
                    break;
               End;
          End;
     End
     Else If Attrs*[faItalic]<>[] Then
     Begin
          //look If we Find an Italic Font With the same Name !
          For T:=0 To Screen.FontCount-1 Do
          Begin
               s1:=Screen.Fonts[T].FaceName;
               UpcaseStr(s1);
               If Pos(S,s1)=1 Then If Pos(' ITALIC',s1)<>0 Then
                 If ((Pos(' BOLD',s1)=0)Or(Pos(' BOLD',S)<>0)) Then
               Begin
                    Attrs:=Attrs-[faItalic];
                    FaceName:=Screen.Fonts[T].FaceName;
                    break;
               End;
          End;
     End;

     {look If the Font Is already registered}
     Result:=Nil;

     For T:=0 To Screen.FontCount-1 Do
     Begin
          Font:=Screen.Fonts[T];
          If Font.FaceName=FaceName Then
            If Font.FInternalPointSize=PointSize Then
              If Font.Attributes=Attrs Then
            Begin
                 Result:=Font;
                 If Screen<>Nil Then
                 Begin
                      //don't return DefaultFont here, create a copy instead
                      If Result<>Screen.FDefaultFont Then exit;
                 End
                 Else Exit;
            End;
     End;

     If Result<>Nil Then //A defaultfont was previously found
     Begin
          Result:=CreateCompatibleFont(Result);
          Result.FCustom:=False;
          Result.FInternalPointSize:=PointSize;
          exit;
     End;

     Result:=Nil;
     {look If there Is A Font registered called FaceName}
     If FFonts<>Nil Then For T:=0 To FFonts.Count-1 Do
     Begin
          Font:=FFonts[T];
          If Font.FaceName=FaceName Then
          Begin
               Result:=CreateCompatibleFont(Font);
               Result.FCustom:=False;
               Result.FInternalPointSize:=PointSize;

               {$IFDEF OS2}
               S:=tostr(PointSize)+'.'+FaceName;

               S:=ModifyFontName(S,Attrs);
               If Not Screen.FFontWindow.SetPPFontNameSize(S) Then
               Begin
                    //Some Error occured
                    //ErrorBox2('Font could not be created:'+S);
                    Result.Destroy;
                    Result:=Nil;
                    Exit;
               End;

               _hps:=WinGetPS(Screen.FFontWindow.Handle{HWND_DESKTOP});
               If Not GpiQueryFontMetrics(_hps,SizeOf(FONTMETRICS),Result.FFontInfO) Then
               Begin
                    //Some Error occured
                    Result.Destroy;
                    Result:=Nil;
                    WinReleasePS(_hps);
                    Exit;
               End;
               WinReleasePS(_hps);
               Result.FFontType:=ftBitmap;
               If Result.FFontInfo.fsDefn And FM_DEFN_OUTLINE<>0 Then Result.FFontTypE:=FtOuTline;

               //don't allow To Set "Helv Bold.Bold" Or "Helv Italic.Italic" !
               If Attrs*[faBold]<>[] Then
               Begin
                    S:=Result.FaceName;
                    UpcaseStr(S);
                    If Pos(' BOLD',S)=0 Then Result.FFontInfo.fsSelection:=Result.FFoNtINfo.FsseleCtioN or fm_SEL_BOLD
                    Else Result.FFontInfo.fsSelection:=Result.FFontInfo.fsSelectioN And Not Fm_SeL_BOLD;
               End;
               If Attrs*[faItalic]<>[] Then
               Begin
                    S:=Result.FaceName;
                    UpcaseStr(S);
                    If Pos(' ITALIC',S)=0 Then Result.FFontInfo.fsSelection:=ResulT.FfonTinfO.fSselEctIoN or FM_SEL_ITALIC
                    Else Result.FFontInfo.fsSelection:=Result.FFontInfo.fsSelectioN And Not FM_SeL_ITALIC
               End;

               If Attrs*[faUnderScore]<>[] Then
                  Result.FFontInfo.fsSelection:=Result.FFontInfo.fsSelection Or FM_SEl_UNdeRSCORe;
               If Attrs*[faStrikeOut]<>[] Then
                  Result.FFontInfo.fsSelection:=Result.FFontInfo.fsSelection Or FM_SEl_STriKEOUT;
               If Attrs*[faOutline]<>[] Then
                  Result.FFontInfo.fsSelection:=Result.FFontInfo.fsSelection Or FM_SEl_OUtlINE;
               {$ENDIF}
               {$IFDEF Win95}
               Result.Attributes:=Attrs;
               Result.FFontInfo.lfHeight:=PointSize;
               Result.FFontInfo.lfWidth:=0;

               aFontInfo:=Result.FFontInfo;
               aFontInfo.lfHeight:=Result.FFontInfo.lfHeight;
               aFontInfo.lfWidth:=Result.FFontInfo.lfWidth;
               aFontInfo.lfQuality:=DRAFT_QUALITY;
               aFontInfo.lfItalic:=0;
               aFontInfo.lfUnderline:=0;
               aFontInfo.lfStrikeOut:=0;
               aFontInfo.lfWeight:=FW_NORMAL;
               TempHandle:=CreateFontIndirect(aFontInfo);
               SelectObject(FFontWindow.Canvas.Handle,TempHandle);
               FillChar(tm,sizeof(tm),0);
               GetTextMetrics(FFontWindow.Canvas.Handle,tm);
               //ErrorBox2('Height for FaceName='+FaceName+'='+tostr(tm.tmHeight)+' Width='+tostr(tm.tmMaxCharWidth));
               If tm.tmHeight<>0 Then Result.FFontInfo.lfHeight:=tm.tmHeight;
               Result.FFontInfo.lfWidth:=tm.tmMaxCharWidth;
               DeleteObject(TempHandle);
               {$ENDIF}
               FFonts.Add(Result);
               Exit;
          End;
     End;
End;

Function TScreen.GetControlFromPoint(pt:TPoint):TControl;
Var  ahwnd:LongWord;
     MyPID:PID;
     MyTID:TID;
Begin
     {$IFDEF OS2}
     ahwnd := WinWindowFromPoint(HWND_DESKTOP,pt,True);
     Result := Nil;
     If Not WinQueryWindowProcess(ahwnd,MyPID,MyTID) Then
          Exit;
     If MyPID <> GetCurrentProcessID Then
          // Not our process, don't try and access it!
          Exit;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,Nil,Nil);
     ahwnd := WindowFromPoint(POINTL(pt));
     {$ENDIF}
     Result := HandleToControl(ahwnd);

     If not IsControl(Result) Then Result:=Nil;
End;


Function TScreen.SystemMetrics(sm:TSystemMetrics):LongInt;
Begin
     {$IFDEF OS2}
     Result := WinQuerySysValue(HWND_DESKTOP,sm);
     If sm = smCxMinMaxButton Then Result := Result Div 2;
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetSystemMetrics(sm);
     {$ENDIF}
End;

Function TScreen.SystemColors(sc:TColor):TColor;
Begin
     Result := SysColorToRGB(sc);
End;


Function TScreen.GetFontFromName(FaceName:String;Height,Width:LongInt):TFont;
Var T:LongInt;
    DifY,DifX:Word;
    tx,ty:Word;
    Font:TFont;
    Attrs:TFontAttributes;
{$IFDEF OS2}
    S,s1:String;
Label L;
{$ENDIF}
Begin
     If FaceName='System Default Font' Then
     Begin
          Result:=DefaultFont;
          Exit;
     End;

     Attrs:=[];
     {$IFDEF OS2}
     S:=FaceName;
     UpcaseStr(S);
L:
     For T:=Length(S) Downto 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    FaceName[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
                    Goto L;
               End;
          End;
     End;
     {$ENDIF}

     //Attrs mit einbeziehen

     Result:=Nil;
     DifY:=65535;
     DifX:=65535;
     For T:=0 To FFonts.Count-1 Do
     Begin
          Font:=Fonts[T];
          {$IFDEF OS2}
          If Font.FFontInfo.szFaceName=FaceName Then
          Begin
               ty:=Abs(Font.FFontInfo.lMaxbaseLineExt-Height);
               tx:=Abs(Font.FFontInfo.LMaxCharInc-Width);

               If ty<=DifY Then If tx<=DifX Then
               Begin
                   Result:=Font;
                   DifY:=ty;
                   DifX:=tx;
               End;
          End;
          {$ENDIF}
          {$IFDEF Win95}
          If Font.FFontInfo.lfFaceName=FaceName Then
          Begin
               ty:=Abs(Font.FFontInfo.lfHeight-Height);
               If Font.FFontInfo.lfHeight=0 Then ty:=0;
               tx:=Abs(Font.FFontInfo.lfWidth-Width);
               If Font.FFontInfo.lfWidth=0 Then tx:=0;

               If ty<=DifY Then If tx<=DifX Then
               Begin
                   Result:=Font;
                   DifY:=ty;
                   DifX:=tx;
               End
               Else
               Begin
                    If ty<=DifY Then
                    Begin
                         {tx greater}
                         If tx-DifX<DifY-ty Then
                         Begin
                              Result:=Font;
                              DifY:=ty;
                              DifX:=tx;
                         End;
                    End
                    Else If tx<=DifX Then
                    Begin
                         {ty greater}
                         If ty-DifY<DifX-tx Then
                         Begin
                              Result:=Font;
                              DifY:=ty;
                              DifX:=tx;
                         End;
                    End;
               End;
          End;
          {$ENDIF}
     End;
End;


Function TScreen.GetSystemFixedFont:TFont;
Var  I:LongInt;
     F:TFont;
Begin
     {$IFDEF OS2}
     Result := GetFontFromName('Courier',16,9);
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetFontFromName('Fixedsys',15,8);
     {$ENDIF}

     If Result = Nil Then
     For I := 0 To Screen.FontCount-1 Do
     Begin
          F := Screen.Fonts[I];
          If F.Pitch = fpFixed Then
            If F.FontType = ftBitmap Then
            Begin
                 Result := F;
                 Exit;
            End;
     End;
     If Result = Nil Then Result := GetSystemDefaultFont; {never return Nil}
End;


Function TScreen.GetSystemDefaultFont:TFont;
Begin
     If FSystemFont<>Nil Then
     Begin
          Result:=FSystemFont;
          Exit;
     End;

     {$IFDEF OS2}
     If FDefaultFont<>Nil Then Result:=FDefaultFont
     Else
     Begin
          Result:=GetFontFromPointSize('System Proportional',10);
          If Result=Nil Then Result := GetFontFromName('System Proportional',20,16);
     End;
     //If Result <> Nil Then Result.FFontInfo.usCodePage := 850;
     {$ENDIF}
     {$IFDEF Win95}
     If FDefaultFont<>Nil Then Result:=FDefaultFont
     Else
     Begin
          Result := GetFontFromName('MS Sans Serif',15,5);
          If Result=Nil Then Result := GetFontFromName('Fixedsys',15,8);
     End;
     {$ENDIF}
End;

Function TScreen.GetSystemSmallFont:TFont;
Begin
     If Width > 800 Then  //big Fonts
     Begin
          {$IFDEF OS2}
          Result := GetFontFromPointSize('Helv',8);
          {$ENDIF}
          {$IFDEF Win32}
          Result := GetFontFromName('MS Sans Serif',15,5);
          If Result = Nil Then Result := GetFontFromName('Arial',16,6);
          {$ENDIF}
     End
     Else
     Begin
          {$IFDEF OS2}
          Result := GetFontFromPointSize('Helv',8);
          {$ENDIF}
          {$IFDEF Win32}
          Result := GetFontFromName('MS Sans Serif',15,5);
          If Result = Nil Then Result := GetFontFromName('Arial',14,5);
          {$ENDIF}
     End;
     If Result = Nil Then Result := GetSystemDefaultFont;
End;


Function TScreen.GetFormCount:LongInt;
Begin
     Result := FForms.Count;
End;


Function TScreen.GetForm(Index:LongInt):TForm;
Begin
     Result := FForms.Items[Index];
End;


Function TScreen.GetFontCount:LongInt;
Begin
     Result:=FFonts.Count;
End;

Function TScreen.GetFont(Index:LongInt):TFont;
Begin
     Result:=FFonts.Items[Index];
End;

Function TScreen.GetMousePos:TPoint;
Begin
     {$IFDEF OS2}
     WinQueryPointerPos(HWND_DESKTOP,Result);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.GetCursorPos(Result);
     TransformClientPoint(Result,Nil,Nil);
     {$ENDIF}
End;

Procedure TScreen.SetMousePos(NewPos:TPoint);
Begin
     {$IFDEF OS2}
     WinSetPointerPos(HWND_DESKTOP,NewPos.X,NewPos.Y);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(NewPos,Nil,Nil);
     WinUser.SetCursorPos(NewPos.X,NewPos.Y);
     {$ENDIF}
End;

Destructor TScreen.Destroy;
Begin
     // free global form icon - AaronL
     if hFormIcon <> NULLHANDLE then
          WinDestroyPointer( hFormIcon );
     FFonts.Destroy;
     FFonts := Nil;
     FForms.Destroy;
     FForms := Nil;
     FFontWindow.Destroy;
     FFontWindow := Nil;
     FHiddenWindow.Destroy;
     FHiddenWindow := Nil;
     DestroyCursors;

     Inherited Destroy;  //Destroys All owned Components As well

     If Self=Screen Then Screen:=Nil;
End;

Procedure TScreen.CreateCursors;
Begin
     DestroyCursors;

     {$IFDEF OS2}
     InsertCursor(crDefault,WinQuerySysPointer(HWND_DESKTOP,SPTR_ARROW,False));
     InsertCursor(crArrow,WinQuerySysPointer(HWND_DESKTOP,SPTR_ARROW,False));
     InsertCursor(crCross,WinLoadPointer(HWND_DESKTOP,0,21));
     InsertCursor(crIBeam,WinQuerySysPointer(HWND_DESKTOP,SPTR_TEXT,False));
     InsertCursor(crSize,WinQuerySysPointer(HWND_DESKTOP,SPTR_MOVE,False));
     InsertCursor(crSizeNESW,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENESW,False));
     InsertCursor(crSizeNS,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENS,False));
     InsertCursor(crSizeNWSE,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZENWSE,False));
     InsertCursor(crSizeWE,WinQuerySysPointer(HWND_DESKTOP,SPTR_SIZEWE,False));
     InsertCursor(crUpArrow,WinLoadPointer(HWND_DESKTOP,0,Abs(crUpArrow)));
     InsertCursor(crHourGlass,WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,False));
     InsertCursor(crDrag,WinQuerySysPointer(HWND_DESKTOP,SPTR_FILE,False));
     InsertCursor(crNoDrop,WinQuerySysPointer(HWND_DESKTOP,SPTR_ILLEGAL,False));
     InsertCursor(crHSplit,WinLoadPointer(HWND_DESKTOP,0,Abs(crHSplit)));
     InsertCursor(crVSplit,WinLoadPointer(HWND_DESKTOP,0,Abs(crVSplit)));
     InsertCursor(crMultiDrag,WinQuerySysPointer(HWND_DESKTOP,SPTR_MULTFILE,False));
     InsertCursor(crSQLWait,WinLoadPointer(HWND_DESKTOP,0,Abs(crSQLWait)));
     InsertCursor(crNo,WinQuerySysPointer(HWND_DESKTOP,SPTR_ICONERROR,False));
     InsertCursor(crAppStart,WinLoadPointer(HWND_DESKTOP,0,Abs(crAppStart)));
     InsertCursor(crHelp,WinLoadPointer(HWND_DESKTOP,0,Abs(crHelp)));
     {$ENDIF}

     {$IFDEF Win32}
     InsertCursor(crDefault,LoadCursor(0,IDC_ARROW));
     InsertCursor(crArrow,LoadCursor(0,IDC_ARROW));
     InsertCursor(crCross,LoadCursor(DllModule,MAKEINTRESOURCE(21)));
     InsertCursor(crIBeam,LoadCursor(0,IDC_IBEAM));
     InsertCursor(crSize,LoadCursor(0,IDC_SIZE));
     InsertCursor(crSizeNESW,LoadCursor(0,IDC_SIZENESW));
     InsertCursor(crSizeNS,LoadCursor(0,IDC_SIZENS));
     InsertCursor(crSizeNWSE,LoadCursor(0,IDC_SIZENWSE));
     InsertCursor(crSizeWE,LoadCursor(0,IDC_SIZEWE));
     InsertCursor(crUpArrow,LoadCursor(0,IDC_UPARROW));
     InsertCursor(crHourGlass,LoadCursor(0,IDC_WAIT));
     InsertCursor(crDrag,LoadCursor(DllModule,MAKEINTRESOURCE(12)));
     InsertCursor(crNoDrop,LoadCursor(0,IDC_NO));
     InsertCursor(crHSplit,LoadCursor(DllModule,IDC_HSPLIT));
     InsertCursor(crVSplit,LoadCursor(DllModule,IDC_VSPLIT));
     InsertCursor(crMultiDrag,LoadCursor(0,IDC_MULTIDRAG));
     InsertCursor(crSQLWait,LoadCursor(DllModule,MAKEINTRESOURCE(17)));
     InsertCursor(crNo,LoadCursor(0,IDC_NO));
     InsertCursor(crAppStart,LoadCursor(0,IDC_APPSTARTING));
     InsertCursor(crHelp,LoadCursor(DllModule,IDC_HELP));
     {$ENDIF}
End;


Procedure TScreen.DestroyCursors;
Var  dummy:PCursorRec;
Begin
     While FCursorList <> Nil Do
     Begin
          {$IFDEF Win32}
          DestroyCursor(FCursorList^.Handle);
          {$ENDIF}
          {$IFDEF OS2}
          // Destroy loaded cursors - AaronL
          // others are queried from system without copying, so don't
          // need to be freed.
          If FCursorList^.Index in
             [ crCross,
               crUpArrow,
               crHSplit,
               crVSplit,
               crSQLWait,
               crAppStart,
               crHelp ] then
               WinDestroyPointer( FCursorList^.Handle );
          {$ENDIF}
          dummy := FCursorList^.Next;
          Dispose(FCursorList);
          FCursorList := dummy;
     End;
     FDefaultCursor := 0;
End;


Procedure TScreen.SetCursors(Index:TCursor;Handle:HCursor);
Begin
     If Index = crNone Then Exit;

     DeleteCursor(Index);
     If Handle <> 0 Then
     Begin
          InsertCursor(Index, Handle);
          If Index = crDefault Then FDefaultCursor := Handle;
     End;
End;


Function TScreen.GetCursors(Index:TCursor):HCursor;
Var  dummy:PCursorRec;
Begin
     Result := 0;
     If Index = crNone Then Exit;

     dummy := FCursorList;
     While dummy <> Nil Do
     Begin
          If dummy^.Index = Index Then
          Begin
               Result := dummy^.Handle;
               Exit;
          End;
          dummy := dummy^.Next;
     End;
     Result := FDefaultCursor;
End;


Procedure TScreen.InsertCursor(Index:TCursor;Handle:HCursor);
Var  dummy:PCursorRec;
Begin
     New(dummy);
     dummy^.Next := FCursorList;
     dummy^.Index := Index;
     dummy^.Handle := Handle;
     FCursorList := dummy;
End;


Function TScreen.AddCursor(Handle:HCursor):TCursor;
Var dummy:PCursorRec;
Begin
     //look For the Next Free TCursor Handle
     Result:=TCursor(crDefault+1);
     While True Do
     Begin
          //look If the TCursor Handle Is used by another user...
          dummy:=FCursorList;
          While dummy<>Nil Do
          Begin
               If dummy^.Index=Result Then break;
               dummy:=dummy^.Next;
          End;

          If dummy=Nil Then break; //the Item Is available
          Inc(Result);
     End;

     InsertCursor(Result,Handle);
End;


Procedure TScreen.DeleteCursor(Index:TCursor);
Var  dummy,Prev:PCursorRec;
Begin
     Prev := Nil;
     dummy := FCursorList;
     While dummy <> Nil Do
     Begin
          If dummy^.Index = Index Then
          Begin
               If Prev = Nil Then FCursorList := dummy^.Next
               Else Prev^.Next := dummy^.Next;
               {$IFDEF Win32}
               DestroyCursor(dummy^.Handle);
               {$ENDIF}
               Dispose(dummy);
               Exit;
          End;
          dummy := dummy^.Next;
     End;
End;


Procedure TScreen.SetCursor(Index:TCursor);
Var  Control:TControl;
Begin
     FCursor := Index;
     Control := GetControlFromPoint(MousePos);
     If Control <> Nil Then Control.Cursor := Control.Cursor;
End;


Function TScreen.GetHeight:LongInt;
Begin
     Result := SystemMetrics(smCyScreen);
End;


Function TScreen.GetWidth:LongInt;
Begin
     Result := SystemMetrics(smCxScreen);
End;


Procedure TScreen.UpdateLastActive;
Begin
     If FLastActiveForm <> FActiveForm Then
     Begin
          FLastActiveForm := FActiveForm;
          If FOnActiveFormChange <> Nil Then FOnActiveFormChange(Self);
     End;

     If FLastActiveControl <> FActiveControl Then
     Begin
          FLastActiveControl := FActiveControl;
          If FOnActiveControlChange <> Nil Then FOnActiveControlChange(Self);
     End;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TGraphic Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TGraphic.Create;
Begin
     Inherited Create(Nil);
End;

Procedure TGraphic.LoadFromFile(Const FileName:String);
Var
   FileStream:TStream;
Begin
     FileStream:=TFileStream.Create(FileName, Stream_OpenRead);
     Try
         LoadFromStream(FileStream);
     Finally
         FileStream.Destroy;
     End;
End;

Procedure TGraphic.SaveToFile(Const FileName:String);
Var
   FileStream:TStream;
Begin
     FileStream:=TFileStream.Create(FileName,Stream_Create);
     Try
         SaveToStream(FileStream);
     Finally
         FileStream.Destroy;
     End;
End;

Procedure TGraphic.changed;
Begin
     If FOnChangedNotify<>Nil Then FOnChangedNotify(Self);
     If FOnChange<>Nil Then FOnChange(Self);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPalette Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF WIN32}
Type PPaletteEntryArray=^TPaletteEntryArray;
     TPaletteEntryArray=Array[0..1] Of PALETTEENTRY;
{$ENDIF}
{$IFDEF OS2}
Type PPaletteEntryArray=^TPaletteEntryArray;
     TPaletteEntryArray=Array[0..1] Of RGB2;
{$ENDIF}

Procedure TPalette.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='Palette';

     If Owner Is TCanvas Then FCanvas:=TCanvas(Owner);
End;

Function TPalette.GetHandle:LongWord;
{$IFDEF WIN32}
Var lp:LOGPALETTE;
    Temp:LongWord;
{$ENDIF}
Begin
     If FHandle<>0 Then Result:=FHandle
     Else If FCanvas<>Nil Then
     Begin
          FCanvas:=TCanvas(Owner);

          {$IFDEF OS2}
          Result:=GpiQueryPalette(FCanvas.Handle);
          {$ENDIF}
          {$IFDEF WIN32}
          lp.palVersion:=$300;
          lp.palNumEntries:=1;
          Temp:=CreatePalette(lp);
          Result:=SelectPalette(FCanvas.Handle,Temp,False);
          SelectPalette(FCanvas.Handle,Result,False);
          DeleteObject(Temp);
          {$ENDIF}

          FHandle:=Result;
     End
End;

Procedure TPalette.CreateNew(Var Colors:Array Of TColor);
Var
    {$IFDEF OS2}
    Entries:PPaletteEntryArray;
    {$ENDIF}
    {$IFDEF WIN32}
    Entries:^LOGPALETTE;
    {$ENDIF}
    Count:LongWord;
    t:LongInt;
Begin
     Count:=High(Colors)+1;
     {$IFDEF OS2}
     GetMem(Entries,Count*sizeof(RGB2));
     For t:=0 To Count-1 Do
     Begin
          Entries^[t].bRed:=TRGB(Colors[t]).Red;
          Entries^[t].bGreen:=TRGB(Colors[t]).Green;
          Entries^[t].bBlue:=TRGB(Colors[t]).Blue;
          Entries^[t].fcOptions:=0;
     End;
     FHandle:=GpiCreatePalette(AppHandle,
                               0{LCOL_OVERRIDE_DEFAULT_COLORS},
                               LCOLF_CONSECRGB,
                               Count,
                               Entries^);
     FreeMem(Entries,Count*sizeof(RGB2));
     {$ENDIF}
     {$IFDEF WIN32}
     GetMem(Entries,sizeof(LOGPALETTE)+Count*sizeof(PALETTEENTRY));
     Entries^.palVersion:=$300;
     Entries^.palNumEntries:=Count;
     For t:=0 To Count-1 Do
     Begin
          Entries^.palPalEntry[t].peRed:=TRGB(Colors[t]).Red;
          Entries^.palPalEntry[t].peGreen:=TRGB(Colors[t]).Green;
          Entries^.palPalEntry[t].peBlue:=TRGB(Colors[t]).Blue;
          Entries^.palPalEntry[t].peFlags:=0;
     End;
     FHandle:=CreatePalette(Entries^);
     GetMem(Entries,sizeof(LOGPALETTE)+Count*sizeof(PALETTEENTRY));
     {$ENDIF}
End;

Procedure TPalette.RealizePalette;
Begin
     If FCanvas=Nil Then exit;

     {$IFDEF OS2}
     GpiSelectPalette(FCanvas.Handle,Handle);
     {$ENDIF}
     {$IFDEF WIN32}
     SelectPalette(FCanvas.Handle,Handle,False);
     WinGDI.RealizePalette(FCanvas.Handle);
     {$ENDIF}
End;

Function TPalette.GetColor(Index:LongWord):TColor;
Var CArray:Array[1..1] Of TColor;
Begin
     GetColorArray(Index,CArray);
     Result:=CArray[1];
End;

Procedure TPalette.SetColor(Index:LongWord;NewColor:TColor);
Var CArray:Array[1..1] Of TColor;
Begin
     CArray[1]:=NewColor;
     SetColorArray(Index,CArray);
End;

Function TPalette.GetColorArray(StartIndex:LongWord;Var ResultArray:Array Of TColor):Longword;
Var Count:LongWord;
    {$IFDEF WIN32}
    Entries:PPaletteEntryArray;
    t:LongInt;
    {$ENDIF}
Begin
     Count:=High(ResultArray)+1;
     {$IFDEF OS2}
     Result:=GpiQueryPaletteInfo(Handle,Canvas.Handle,0,StartIndex,Count,ResultArray);
     {$ENDIF}
     {$IFDEF Win32}
     GetMem(Entries,Count*sizeof(PALETTEENTRY));
     Result:=GetPaletteEntries(Handle,StartIndex,Count,Entries^[0]);
     If Result<>0 Then
     Begin
          For t:=0 To Count-1 Do
            ResultArray[t]:=ValuesToRGB(Entries^[t].peRed,Entries^[t].peGreen,Entries^[t].peBlue);
     End;
     FreeMem(Entries,Count*sizeof(PALETTEENTRY));
     {$ENDIF}
End;

Procedure TPalette.SetColorArray(StartIndex:LongWord;Const SourceArray:Array Of TColor);
Var
   Count:LongInt;
   {$IFDEF WIN32}
   Entries:PPaletteEntryArray;
   t:LongInt;
   {$ENDIF}
Begin
     Count:=High(SourceArray)+1;
     {$IFDEF OS2}
     GpiSetPaletteEntries(Handle,LCOLF_CONSECRGB,StartIndex,Count,SourceARray);
     {$ENDIF}
     {$IFDEF Win32}
     GetMem(Entries,Count*sizeof(PALETTEENTRY));
     For t:=0 To Count-1 Do
     Begin
          Entries^[t].peRed:=TRGB(SourceArray[t]).Red;
          Entries^[t].peGreen:=TRGB(SourceArray[t]).Green;
          Entries^[t].peBlue:=TRGB(SourceArray[t]).Blue;
          Entries^[t].peFlags:=0;
     End;
     SetPaletteEntries(Handle,StartIndex,Count,Entries^[0]);
     FreeMem(Entries,Count*sizeof(PALETTEENTRY));
     {$ENDIF}
End;

Function TPalette.GetColorCount:LongWord;
Begin
     {$IFDEF OS2}
     Result:=GpiQueryPaletteInfo(Handle,Canvas.Handle,0,0,0,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     Result:=0;
     GetObject(Handle,4,Result);
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TPen Class Implementation                                   บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TPen.SetupComponent;
Begin
     Inherited SetupComponent;
     Name:='Pen';
     If Owner Is TCanvas Then
       If not (csWriting IN ComponentState) Then FCanvas:=TCanvas(Owner);
     Include(DesignerState, dsStored);
     Width:=1;
     color:=clBlack;
     Mode:=pmCopy;
     Style:=psSolid;
End;

Procedure TPen.Assign(Source:TPersistent);
Begin
     If not (Source Is TPen) Then Inherited Assign(Source)
     Else
     Begin
          Color:=TPen(Source).Color;
          Mode:=TPen(Source).Mode;
          Style:=TPen(Source).Style;
          Width:=TPen(Source).Width;
     End;
End;

{$IFDEF WIN32}
Procedure CreateWin32Pen(Canvas:TCanvas);
Begin
     If Canvas.FPenHandle<>0 Then exit;
     Canvas.FPenHandle:=GetStockObject(BLACK_PEN); //CreatePen(PS_SOLID,0,0);
     If Canvas.FHandle<>0 Then SelectObject(Canvas.FHandle,Canvas.FPenHandle);
End;

Procedure CreateWin32Brush(Canvas:TCanvas);
Begin
     If Canvas.FBrushHandle<>0 Then exit;
     Canvas.FBrushHandle:=GetStockObject(WHITE_BRUSH); //CreateSolidBrush(0);
     If Canvas.FHandle<>0 Then SelectObject(Canvas.FHandle,Canvas.FBrushHandle);
End;
{$ENDIF}

Procedure TPen.SetColor(NewColor:TColor);
{$IFDEF Win32}
Var lp:LOGPEN;
    lb:LOGBRUSH;
    NewPen:LongWord;
    NewBrush:LongWord;
{$ENDIF}
Begin
     FColor := NewColor;   {Store original Value, Not the Modified one}

     If FCanvas <> Nil Then
     Begin
          {$IFDEF WIN32}
          If not (FCanvas.FOwnerDraw) Then exit; //not ownerdraw
          {$ENDIF}

          NewColor := SysColorToRGB(NewColor);
          {$IFDEF OS2}
          GpiSetColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
          {$IFDEF Win32}
          NewColor := RGBToWinColor(NewColor);

          CreateWin32Pen(FCanvas);
          GetObject(FCanvas.FPenHandle,SizeOf(LOGPEN),lp);
          lp.lopnColor:=NewColor;
          NewPen:=CreatePenIndirect(lp);
          If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewPen);
          If FCanvas.FPenHandle<>0 Then DeleteObject(FCanvas.FPenHandle);
          FCanvas.FPenHandle:=NewPen;

          CreateWin32Brush(FCanvas);
          GetObject(FCanvas.FBrushHandle,SizeOf(LOGBRUSH),lb);
          lb.lbColor:=NewColor;
          NewBrush:=CreateBrushIndirect(lb);
          If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewBrush);
          If FCanvas.FBrushHandle<>0 Then DeleteObject(FCanvas.FBrushHandle);
          FCanvas.FBrushHandle:=NewBrush;
          WinGDI.SetTextColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
     End;
End;


Procedure TPen.SetMode(NewMode:TPenMode);
{$IFDEF OS2}
Const FgModes:Array[pmBlack..pmNotXor] Of LongWord=
                (FM_ZERO,FM_ONE,FM_LEAVEALONE,FM_INVERT,
                 FM_OVERPAINT,FM_NOTCOPYSRC,FM_MERGESRCNOT,FM_MASKSRCNOT,FM_MERGENOTSRC,
                 FM_SUBTRACT,FM_OR,FM_NOTMERGESRC,FM_AND,FM_NOTMASKSRC,
                 FM_XOR,FM_NOTXORSRC);
{$ENDIF}
{$IFDEF Win32}
Const FgModes:Array[pmBlack..pmNotXor] Of LongWord=
                (R2_BLACK,R2_WHITE,R2_NOP,R2_NOT,
                 R2_COPYPEN,R2_NOTCOPYPEN,R2_MERGEPENNOT,R2_MASKPENNOT,R2_MERGENOTPEN,
                 R2_MASKNOTPEN,R2_MERGEPEN,R2_NOTMERGEPEN,R2_MASKPEN,R2_NOTMASKPEN,
                 R2_XORPEN,R2_NOTXORPEN);
{$ENDIF}
Var NewMode1:LongWord;
Begin
     FMode:=NewMode;
     If FCanvas = Nil Then Exit;
     FCanvas.FForeMix:=NewMode;
     NewMode1:=FgModes[NewMode];
     {$IFDEF Win32}
     SetROP2(FCanvas.FHandle,NewMode1);
     {$ENDIF}
     {$IFDEF OS2}
     GpiSetMix(FCanvas.FHandle,NewMode1);
     {$ENDIF}
End;


Procedure TPen.SetStyle(NewStyle:TPenStyle);
{$IFDEF Win32}
Const LineStyles:Array[psSolid..psInsideFrame] Of LongWord=
                   (PS_SOLID,PS_DASH,PS_DOT,PS_DASHDOT,PS_DASHDOTDOT,
                    PS_NULL,PS_INSIDEFRAME);
{$ENDIF}
{$IFDEF OS2}
Const LineStyles:Array[psSolid..psInsideFrame] Of LongWord=
                   (LINETYPE_SOLID,LINETYPE_LONGDASH,LINETYPE_DOT,
                    LINETYPE_DASHDOT,LINETYPE_DASHDOUBLEDOT,
                    LINETYPE_INVISIBLE,LINETYPE_ALTERNATE);
{$ENDIF}
{$IFDEF Win32}
Var PenData:LOGPEN;
    NewPen:LongWord;
{$ENDIF}
Var NewStyle1:LongWord;
Begin
     FStyle:=NewStyle;
     If FCanvas = Nil Then Exit;

     {$IFDEF WIN32}
     If not (FCanvas.FOwnerDraw) Then exit; //not ownerdraw
     {$ENDIF}

     FCanvas.FLineType:=NewStyle;
     NewStyle1:=LineStyles[NewStyle];
     {$IFDEF Win32}
     CreateWin32Pen(FCanvas);
     GetObject(FCanvas.FPenHandle,SizeOf(LOGPEN),PenData);
     PenData.lopnStyle:=NewStyle1;
     NewPen:=CreatePenIndirect(PenData);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewPen);
     If FCanvas.FPenHandle<>0 Then DeleteObject(FCanvas.FPenHandle);
     FCanvas.FPenHandle:=NewPen;
     {$ENDIF}
     {$IFDEF OS2}
     GpiSetLineType(FCanvas.FHandle,NewStyle1);
     {$ENDIF}
End;


Procedure TPen.SetWidth(NewWidth:LongInt);
{$IFDEF Win32}
Var PenData:LOGPEN;
    NewPen:LongWord;
{$ENDIF}
Begin
     FWidth:=NewWidth;
     If FCanvas = Nil Then Exit;

     {$IFDEF WIN32}
     If not (FCanvas.FOwnerDraw) Then exit; //not ownerdraw
     {$ENDIF}

     FCanvas.FLineWidth:=NewWidth;
     {$IFDEF Win32}
     CreateWin32Pen(FCanvas);
     GetObject(FCanvas.FPenHandle,SizeOf(LOGPEN),PenData);
     PenData.lopnWidth:=Point(NewWidth,0);
     NewPen:=CreatePenIndirect(PenData);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewPen);
     If FCanvas.FPenHandle<>0 Then DeleteObject(FCanvas.FPenHandle);
     FCanvas.FPenHandle:=NewPen;
     {$ENDIF}
     {$IFDEF OS2}
     If NewWidth>2 Then
     Begin
          GpiSetLineWidthGeom(FCanvas.FHandle,NewWidth);
          GpiSetLineWidth(FCanvas.FHandle,MAKEFIXED(1,0));
          FCanvas.FUsePath:=True;
     End
     Else
     Begin
          GpiSetLineWidth(FCanvas.FHandle,MAKEFIXED(NewWidth,0));
          FCanvas.FUsePath:=False;
     End;
     {$ENDIF}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TBrush Class Implementation                                 บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TBrush.SetupComponent;
Begin
     Inherited SetupComponent;
     Name:='Brush';
     If Owner Is TCanvas Then
       If not (csWriting IN ComponentState) Then FCanvas:=TCanvas(Owner);
     Include(DesignerState, dsStored);
     Mode:=bmOpaque;
     Style:=bsSolid;
     color:=clWhite;
End;

Procedure TBrush.Assign(Source:TPersistent);
Begin
     If not (Source Is TBrush) Then Inherited Assign(Source)
     Else
     Begin
          Color:=TBrush(Source).Color;
          Mode:=TBrush(Source).Mode;
          Style:=TBrush(Source).Style;
     End;
End;

Destructor TBrush.Destroy;
Begin
     If FBitmap<>Nil Then
     Begin
          FBitmap.Destroy;
          FBitmap:=Nil;
     End;
     Inherited Destroy;
End;

Procedure TBrush.SetColor(NewColor:TColor);
Begin
     FColor := NewColor; {Store original Value}
     If FCanvas <> Nil Then
     Begin
          NewColor := SysColorToRGB(NewColor);
          {$IFDEF OS2}
          GPISetBackColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
          {$IFDEF Win32}
          NewColor := RGBToWinColor(NewColor);
          SetBkColor(FCanvas.FHandle,NewColor);
          {$ENDIF}
     End;
End;

Procedure TBrush.SetStyle(NewStyle:TBrushStyle);
Var
   {$IFDEF OS2}
   Temp:LongWord;
   {$ENDIF}
   {$IFDEF Win32}
   lb:LOGBRUSH;
   NewBrush:LongWord;
   {$ENDIF}
Begin
     If FBitmap<>Nil Then Exit;  //Function illegal If A Bitmap Is Selected As Brush

     FStyle:=NewStyle;
     If FCanvas = Nil Then Exit;

     If NewStyle=bsClear Then color:=clWhite; {??}

     {$IFDEF OS2}
     Case NewStyle Of
         bsSolid:Temp:=PATSYM_SOLID;
         bsHorizontal:Temp:=PATSYM_HORIZ;
         bsVertical:Temp:=PATSYM_VERT;
         bsFDiagonal:Temp:=PATSYM_DIAG3;
         bsBDiagonal:Temp:=PATSYM_DIAG1;
         bsCross:Temp:=PATSYM_DENSE7;
         bsDiagCross:Temp:=PATSYM_DENSE5;
         bsClear:Temp:=PATSYM_BLANK;
         bsHalfTone:Temp:=PATSYM_HALFTONE;
         Else Temp:=PATSYM_SOLID;
     End; {Case}
     GPISetPattern(FCanvas.FHandle,Temp);
     {$ENDIF}
     {$IFDEF Win32}
     If not FCanvas.FOwnerDraw Then exit;

     CreateWin32Brush(FCanvas);
     GetObject(FCanvas.FBrushHandle,SizeOf(LOGBRUSH),lb);

     If NewStyle=bsSolid Then
     Begin
         //WinGDI.SetBkMode(FCanvas.FHandle,OPAQUE);
         lb.lbColor:=RGBToWinColor(SysColorToRGB(color));
     End
     Else
     Begin
          //WinGDI.SetBkMode(FCanvas.FHandle,TRANSPARENT);
          {windows specific: Win95 does Not Draw Brush hatches If bkcolor=Brush color}
          lb.lbColor:=Not RGBToWinColor(SysColorToRGB(color));
     End;

     Case NewStyle Of
         bsSolid:lb.lbStyle:=BS_SOLID;
         bsClear:lb.lbStyle:=BS_HOLLOW;
         bsHorizontal:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_HORIZONTAL;
         End;
         bsVertical:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_VERTICAL;
         End;
         bsFDiagonal:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_FDIAGONAL;
         End;
         bsBDiagonal:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_BDIAGONAL;
         End;
         bsCross:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_CROSS;
         End;
         bsDiagCross:
         Begin
              lb.lbStyle:=BS_HATCHED;
              lb.lbHatch:=HS_DIAGCROSS;
         End;
     End; {Case}
     NewBrush:=CreateBrushIndirect(lb);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewBrush);
     If FCanvas.FBrushHandle<>0 Then DeleteObject(FCanvas.FBrushHandle);
     FCanvas.FBrushHandle:=NewBrush;
     {$ENDIF}
End;


Procedure TBrush.SetMode(NewMode:TBrushMode);
Begin
     FMode:=NewMode;
     If FCanvas = Nil Then Exit;

     FCanvas.FBackMix:=NewMode;
     {$IFDEF OS2}
     Case NewMode Of
        bmTransparent:GpiSetBackMix(FCanvas.FHandle,BM_LEAVEALONE);
        bmOpaque:GpiSetBackMix(FCanvas.FHandle,BM_OVERPAINT);
     End; {Case}
     {$ENDIF}
     {$IFDEF Win32}
     Case Mode Of
        bmTransparent:WinGDI.SetBkMode(FCanvas.FHandle,TRANSPARENT);
        bmOpaque:WinGDI.SetBkMode(FCanvas.FHandle,OPAQUE);
     End; {Case}
     {$ENDIF}
End;

Procedure TBrush.SetBitmap(NewBitmap:TGraphic);
Var  Stream:TMemoryStream;
     {$IFDEF Win32}
     lb:LOGBRUSH;
     NewBrush:LongWord;
     {$ENDIF}
     {$IFDEF OS2}
     BmpClass:Class Of TGraphic;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     If FBitmap<>Nil Then
     Begin
          GpiSetPatternSet(FCanvas.FHandle,LCID_DEFAULT);
          GpiDeleteSetId(FCanvas.FHandle,2);
          FBitmap.Destroy;
     End;

     If NewBitmap<>Nil Then
     Begin
          BmpClass:=NewBitmap.ClassType;
          FBitmap:=BmpClass.Create;
          Stream.Create;
          NewBitmap.SaveToStream(Stream);
          Stream.Position:=0;
          FBitmap.LoadFromStream(Stream);
          Stream.Destroy;
          GpiSetBitmap(FBitmap.Canvas.Handle,0);
     End
     Else FBitmap:=Nil;
     If FBitmap<>Nil Then
     Begin
          GpiSetBitmapId(FCanvas.FHandle,FBitmap.Handle,2);
          GpiSetPatternSet(FCanvas.FHandle,2);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If FBitmap<>Nil Then FBitmap.Destroy;
     FBitmap:=NewBitmap;
     If not (FCanvas.FOwnerDraw) Then exit;

     CreateWin32Brush(FCanvas);
     GetObject(FCanvas.FBrushHandle,SizeOf(LOGBRUSH),lb);
     If FBitmap<>Nil Then
     Begin
          lb.lbStyle:=BS_PATTERN;
          lb.lbHatch:=FBitmap.Handle;
          {windows specific: Win95 does Not Draw Brush hatches If bkcolor=Brush color}
          lb.lbColor:=Not RGBToWinColor(SysColorToRGB(color));
     End
     Else
     Begin
          lb.lbHatch:=0;
          lb.lbStyle:=BS_SOLID;
     End;
     NewBrush:=CreateBrushIndirect(lb);
     If FCanvas.FHandle<>0 Then SelectObject(FCanvas.FHandle,NewBrush);
     If FCanvas.FBrushHandle<>0 Then DeleteObject(FCanvas.FBrushHandle);
     FCanvas.FBrushHandle:=NewBrush;
     {$ENDIF}
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCanvas Class Implementation                                บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCanvas.CreateHandle;
Begin
End;

Procedure TCanvas.DestroyHandle;
Begin
End;

{$IFDEF OS2}
Function TCanvas.GetLineColor:TColor;
Begin
     GpiQueryAttrs(Handle,PRIM_LINE,LBB_COLOR,Result);
End;
Function TCanvas.GetCharColor:TColor;
Begin
     GpiQueryAttrs(Handle,PRIM_CHAR,CBB_COLOR,Result);
End;

Function TCanvas.GetAreaColor:TColor;
Begin
     GpiQueryAttrs(Handle,PRIM_AREA,ABB_COLOR,Result);
End;

Procedure TCanvas.SetLineColor(NewValue:TColor);
Begin
     GpiSetAttrs(Handle,PRIM_LINE,LBB_COLOR,0,NewValue);
End;

Procedure TCanvas.SetCharColor(NewValue:TColor);
Begin
     GpiSetAttrs(Handle,PRIM_CHAR,CBB_COLOR,0,NewValue);
End;

Procedure TCanvas.SetAreaColor(NewValue:TColor);
Begin
     GpiSetAttrs(Handle,PRIM_AREA,ABB_COLOR,0,NewValue);
End;

Procedure TCanvas.BeginArea(Mode:TAreaMode);
Var Flag:LongWord;
Begin
     Case Mode Of
       arNoBoundary:Flag:=BA_NOBOUNDARY;
       arBoundary:Flag:=BA_BOUNDARY;
       arAlternate:Flag:=BA_ALTERNATE;
       arNoBoundaryAlternate:Flag:=BA_NOBOUNDARY OR BA_ALTERNATE;
       arNoBoundaryWinding:Flag:=BA_NOBOUNDARY OR BA_WINDING;
       arBoundaryWinding:Flag:=BA_BOUNDARY OR BA_WINDING;
       arBoundaryAlternate:Flag:=BA_BOUNDARY OR BA_ALTERNATE;
       Else Flag:=BA_WINDING;
     End;
     GpiBeginArea(Handle,Flag);
End;

Procedure TCanvas.EndArea;
Begin
     GpiEndArea(Handle);
End;

Procedure TCanvas.PolySpline(aptl:Array Of TPoint);
Begin
     GpiMove(Handle,aptl[0]);
     GpiPolySpline(Handle,High(aptl),aptl[1]);
End;

Procedure TCanvas.Transform(m:TMatrix;Mode:TTransformMode);
Var Flags:LongWord;
Begin
     Case Mode Of
       trReplace:Flags:=TRANSFORM_REPLACE;
       trAdd:Flags:=TRANSFORM_ADD;
       Else Flags:=TRANSFORM_PREEMPT;
     End;

     GpiSetModelTransformMatrix(Handle,9,m.FMatrix,Flags);
End;

Procedure TCanvas.ResetTransform;
Var m:TMatrix;
Begin
     m.CreateDefault;
     Transform(m,trReplace);
     m.Destroy;
End;

Procedure TCanvas.SetTransformMatrix(Const m:TMatrix);
Begin
     Transform(m,trReplace);
End;

Function TCanvas.GetTransformMatrix:TMatrix;
Begin
     Result.CreateIntern;
     GpiQueryModelTransformMatrix(Handle,9,Result.FMatrix);
End;
{$ENDIF}

Procedure TCanvas.SetPalette(NewPalette:TPalette);
Var OldHandle:LongWord;
Begin
     If NewPalette=Nil Then Exit;
     OldHandle:=Palette.Handle;
     Palette.Handle:=NewPalette.Handle;
     {$IFDEF OS2}
     GpiSelectPalette(Handle,Palette.Handle);
     GpiCreateLogColorTable(Handle,0,LCOLF_RGB,0,0,Nil);
     {$ENDIF}
     {$IFDEF Win95}
     SelectPalette(Handle,Palette.Handle,True);
     {$ENDIF}

     If Owner Is TGraphic Then TGraphic(Owner).PaletteChanged
     Else
     Begin
          {$IFDEF OS2}
          GpiDeletePalette(OldHandle);
          {$ENDIF}
          {$IFDEF Win95}
          DeleteObject(OldHandle);
          {$ENDIF}
     End;
End;

Function TCanvas.GetPageViewPort:TRect;
Begin
     {$IFDEF OS2}
     GpiQueryPageViewPort(Handle,RECTL(Result));
     {$ENDIF}
End;

Procedure TCanvas.SetPageViewPort(NewValue:TRect);
Begin
     {$IFDEF OS2}
     GpiSetPageViewPort(Handle,RECTL(NewValue));
     {$ENDIF}
End;

Procedure TCanvas.SetPen(NewPen:TPen);
Begin
     If ((NewPen=Nil)Or(FPen=Nil)) Then Exit;

     FPen.color:=NewPen.color;
     FPen.Style:=NewPen.Style;
     FPen.Mode:=NewPen.Mode;
     FPen.Width:=NewPen.Width;
End;

Procedure TCanvas.SetBrush(NewBrush:TBrush);
Begin
     If ((NewBrush=Nil)Or(FBrush=Nil)) Then Exit;

     FBrush.color:=NewBrush.color;
     FBrush.Mode:=NewBrush.Mode;
     FBrush.Style:=NewBrush.Style;
     FBrush.Bitmap:=NewBrush.Bitmap;
End;

Procedure TCanvas.CopyRect(Const Dest:TRect;Canvas:TCanvas;Const Source:TRect);
Begin
     BitBlt(Canvas,Dest,Source,CopyMode,bitfIgnore);
End;


Procedure TCanvas.BitBlt(DestCanvas:TCanvas;Const Dest,Source:TRect;
                         Mode:TBitBltMode;Flags:TBitBltFlags);
{$IFDEF OS2}
Const BitBltModes:Array[TBitBltMode] Of LongWord=
          (ROP_SRCCOPY,ROP_SRCPAINT,ROP_SRCAND,ROP_SRCINVERT,
           ROP_SRCERASE,ROP_NOTSRCCOPY,ROP_NOTSRCERASE,ROP_MERGECOPY,
           ROP_MERGEPAINT,ROP_PATCOPY,ROP_PATPAINT,ROP_PATINVERT,
           ROP_DSTINVERT,ROP_ZERO,ROP_ONE,
           $22,  // cmNotSrcAndDest      (not src) and dst
           $2A,  // cmSrcAndPatErase     ( not (src and pat) ) and dest
           $EA); // cmSrcAndPatOrDest    (src and pat) or dest
Const BitBltOptions:Array[TBitBltFlags] Of LongWord=
          (BBO_OR,BBO_AND,BBO_IGNORE);
{$ENDIF}
{$IFDEF Win32}
Const BitBltModes:Array[TBitBltMode] Of LongWord=
          (SRCCOPY,SRCPAINT,SRCAND,SRCINVERT,
           SRCERASE,NOTSRCCOPY,NOTSRCERASE,MERGECOPY,
           MERGEPAINT,PATCOPY,PATPAINT,PATINVERT,
           DSTINVERT,BLACKNESS,WHITENESS);
{$ENDIF}
Var  aptl:Array[0..3] Of POINTL;
     {$IFDEF Win32}
     _Source,_Dest:TRect;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     aptl[0].X:=Dest.Left;
     aptl[0].Y:=Dest.Bottom;
     aptl[1].X:=Dest.Right;
     aptl[1].Y:=Dest.Top;
     aptl[2].X:=Source.Left;
     aptl[2].Y:=Source.Bottom;
     aptl[3].X:=Source.Right;
     aptl[3].Y:=Source.Top;
     GpiBitBlt(DestCanvas.Handle,Handle,4,aptl[0],BitBltModes[Mode],BitBltOptions[Flags]);
     {$ENDIF}
     {$IFDEF Win32}
     CreateHandle;
     DestCanvas.CreateHandle;

     _Dest := Dest;
     RectToWin32Rect(_Dest);
     TransformRectToWin32(_Dest,DestCanvas.Control,DestCanvas.Graphic);
     _Source := Source;
     RectToWin32Rect(_Source);
     TransformRectToWin32(_Source,FControl,FGraphic);
     StretchBlt(DestCanvas.Handle, _Dest.Left,_Dest.Bottom,
                _Dest.Right-_Dest.Left, _Dest.Top-_Dest.Bottom,
                Handle, _Source.Left, _Source.Bottom,
                _Source.Right-_Source.Left, _Source.Top-_Source.Bottom,
                BitBltModes[Mode]);

     DestCanvas.DestroyHandle;
     DestroyHandle;
     {$ENDIF}
End;



Procedure TCanvas.SetClipRegion(Rects:Array Of TRect);
Var  T:LongInt;
     {$IFDEF Win32}
     FClip1:LongWord;
     {$ENDIF}
Begin
     If FClipRGN <> 0 Then DeleteClipRegion;

     FClipRect := Rects[0];
     {FClipRect > Rectangle that covers All clip rectangles}
     For T := 1 To High(Rects) Do FClipRect := UnionRect(FClipRect,Rects[T]);

     {$IFDEF OS2}
     For T := 0 To High(Rects) Do
     Begin
          Inc(Rects[T].Right);
          Inc(Rects[T].Top);
     End;

     FClipRGN := GpiCreateRegion(FHandle,High(Rects)+1,RECTL(Rects[0]));
     GpiSetClipRegion(FHandle,FClipRGN,Nil);
     {$ENDIF}
     {$IFDEF Win32}
     For T := 0 To High(Rects) Do
     Begin
          TransformClientRect(Rects[T],FControl,FGraphic);
          Inc(Rects[T].Right);
          Inc(Rects[T].Bottom);
     End;

     FClipRGN := CreateRectRgnIndirect(RECTL(Rects[0]));
     SelectClipRgn(FHandle,FClipRGN);
     For T := 1 To High(Rects) Do
     Begin
          FClip1 := CreateRectRgnIndirect(RECTL(Rects[T]));
          ExtSelectClipRgn(FHandle,FClip1,RGN_OR);
          DeleteObject(FClip1);
     End;
     {$ENDIF}
End;


Procedure TCanvas.DeleteClipRegion;
Begin
     If FClipRGN = 0 Then Exit;
     {$IFDEF OS2}
     GpiSetClipRegion(FHandle,0,Nil);
     GpiDestroyRegion(FHandle,FClipRGN);
     {$ENDIF}
     {$IFDEF Win32}
     SelectClipRgn(FHandle,0);
     DeleteObject(FClipRGN);
     {$ENDIF}
     FClipRGN := 0;
     FillChar(FClipRect,SizeOf(TRect),0);
End;


Procedure TCanvas.ExcludeClipRect(Const rec:TRect);
{$IFDEF Win32}
Var  FClip1:LongWord;
     rc:TRect;
{$ENDIF}
Begin
     If FClipRGN=0 Then Exit;
     If IsRectEmpty(rec) Then Exit;
     {$IFDEF OS2}
     GpiExcludeClipRectangle(FHandle,RECTL(rec));
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     {??}
     //Dec(rc.Right); //!!
     //Dec(rc.Top);   //!!
     dec(rc.Bottom); //!!
     TransformClientRect(rc,FControl,FGraphic);
     FClip1:=CreateRectRgnIndirect(RECTL(rc));
     ExtSelectClipRgn(FHandle,FClip1,RGN_XOR);
     DeleteObject(FClip1);
     {$ENDIF}
End;


Procedure TCanvas.SetClipRect(Const rec:TRect);
Begin
     SetClipRegion([rec]);
End;


Function TCanvas.GetPixel(X,Y:LongInt):TColor;
Var  P:TPoint;
Begin
     P := Point(X,Y);
     {$IFDEF OS2}
     Result := GpiQueryPel(FHandle,P);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(P,FControl,FGraphic);
     Result := WinGDI.GetPixel(FHandle, P.X, P.Y);
     Result := WinColorToRGB(Result);
     {$ENDIF}
End;


Procedure TCanvas.SetPixel(X,Y:LongInt;Value:TColor);
Var  P:TPoint;
     {$IFDEF OS2}
     OldColor:TColor;
     {$ENDIF}
Begin
     P := Point(X,Y);
     {$IFDEF OS2}
     OldColor := Pen.color;
     Pen.color := Value;
     GpiSetPel(FHandle,P);
     Pen.color := OldColor;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(P,FControl,FGraphic);
     WinGDI.SetPixel(FHandle, P.X, P.Y, RGBToWinColor(SysColorToRGB(Value)));
     {$ENDIF}
End;


Function TCanvas.TextHeight(Const Text:String):LongInt;
Var CX:LongInt;
Begin
     GetTextExtent(Text,CX,Result);
End;


Function TCanvas.TextWidth(Const Text:String):LongInt;
Var CY:LongInt;
Begin
     GetTextExtent(Text,Result,CY);
End;


Procedure TCanvas.TextRect(Const rc:TRect;X,Y:LongInt;Const Text:String);
Var SaveClip:TRect;
Begin
     SaveClip:=ClipRect;
     ClipRect:=rc;
     TextOut(X,Y,Text);
     ClipRect:=SaveClip;
End;


Procedure TCanvas.GetTextExtent(Const S:String;Var Width,Height:LongInt);
Var  aPS:PString;
     {$IFDEF OS2}
     Extent:Array[0..TXTBOX_COUNT] Of POINTL;
     {$ENDIF}
     {$IFDEF Win32}
     Extent:Size;
     s1:String;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     aPS:=@S;
     GpiQueryTextBox(FHandle,Length(aPS^),aPS^[1],TXTBOX_COUNT,Extent[0]);
     Width:=(Extent[TXTBOX_TOPRIGHT].X-Extent[TXTBOX_BOTTOMLEFT].X);
     Height:=(Extent[TXTBOX_TOPLEFT].Y-Extent[TXTBOX_BOTTOMLEFT].Y);
     {$ENDIF}
     {$IFDEF Win32}
     s1:=s;
     StrOemToAnsi(s1);
     aPS:=@s1;
     GetTextExtentPoint32(FHandle,aPS^[1],Length(aPS^),Extent);
     Width:=Extent.CX;
     Height:=Extent.CY;
     {$ENDIF}
End;

Procedure TCanvas.SetFont(NewFont:TFont);
Var xRes:LongInt;
    S:String;
    TheFont:TFont;
Begin
     If NewFont=FFont Then Exit; //!!!

     xRes:=HorizontalResolution;
     If NewFont<>Nil Then
      If ((Screen<>Nil)And(Screen.Canvas<>Nil)) Then
       If xRes>Screen.Canvas.HorizontalResolution Then //Canvas Is Not A Screen Canvas
     Begin
          //Workaround For Printer Devices
          S:=NewFont.FaceName;
          UpcaseStr(S);
          If Pos(' ITALIC',S)=0 Then
          Begin
               S:=NewFont.FaceName+' Italic';
               If NewFont.PointSize<>0 Then
                 TheFont:=Screen.GetFontFromPointSize(S,NewFont.PointSize)
               Else
                 TheFont:=Screen.GetFontFromName(S,NewFont.Width,NewFont.Height);

               If TheFont=Nil Then
               Begin
                    S:=NewFont.FaceName+'.Italic';
                    If NewFont.PointSize<>0 Then
                      TheFont:=Screen.GetFontFromPointSize(S,NewFont.PointSize)
                    Else
                      TheFont:=Screen.GetFontFromName(S,NewFont.Width,NewFont.Height);
               End;

               If TheFont<>Nil Then
               Begin
                    FFontWidth:=0;
                    FFontHeight:=0;
                    FFontAttr:=[];
                    {der ControlFont darf nicht verndert werden !!!}
                    {Siehe auch TControl.SetFont !!}
                    CreateFont(TheFont,False);
               End;
          End;
     End;

     {Set values To Default}
     FFontWidth:=0;
     FFontHeight:=0;
     FFontAttr:=[];
     {der ControlFont darf nicht verndert werden !!!}
     {Siehe auch TControl.SetFont !!}
     CreateFont(NewFont,False);
End;

Procedure TCanvas.CreateFont(NewFont:TFont;ModifyControlFont:Boolean);
{$IFDEF OS2}
Var fa:FATTRS;
    aSizeF:SIZEF;
    fsSelection:LongInt;
    aptl:Array[0..1] Of POINTL;
    S:String;
    C:Cstring;
    Metrics:FONTMETRICS;
    xRes,yRes:LongInt;
    aHDC:HDC;
    res:LongInt;
    SafeTry,SafeTry1:Boolean;
    f1,f2:String;
    rc: ERRORID;
Label TryAgain;
{$ENDIF}
{$IFDEF Win32}
Var ahFont:HFONT;
    aFontInfo:LOGFONT;
{$ENDIF}
Var aWidth,aHeight:LongInt;
    aFontAttr:TFontAttributes;
    otherfont:Boolean;
Label L;
Begin
     otherfont:=False;
     If NewFont=Nil Then NewFont:=Screen.DefaultFont; {small}

     If FFontWidth=0 Then aWidth:=NewFont.Width     //Default
     Else
     Begin
          aWidth:=FFontWidth;
          otherfont:=True;
     End;
     If FFontHeight=0 Then aHeight:=NewFont.Height  //Default
     Else
     Begin
          aHeight:=FFontHeight;
          otherfont:=True;
     End;
     If FFontAttr=[] Then aFontAttr:=NewFont.Attributes
     Else
     Begin
          aFontAttr:=FFontAttr;
          otherfont:=True;
     End;

     {$IFDEF Win32}
L:
     aFontInfo:=NewFont.FFontInfo;
     aFontInfo.lfHeight:=aHeight;
     aFontInfo.lfWidth:=aWidth;
     aFontInfo.lfQuality:=DRAFT_QUALITY;
     If aFontAttr*[faItalic]<>[] Then aFontInfo.lfItalic:=1
     Else aFontInfo.lfItalic:=0;
     If aFontAttr*[faUnderScore]<>[] Then aFontInfo.lfUnderline:=1
     Else aFontInfo.lfUnderline:=0;
     If aFontAttr*[faStrikeOut]<>[] Then aFontInfo.lfStrikeOut:=1
     Else aFontInfo.lfStrikeOut:=0;
     If aFontAttr*[faBold]<>[] Then aFontInfo.lfWeight:=FW_BOLD
     Else aFontInfo.lfWeight:=FW_NORMAL;

     If Not otherfont Then
     Begin
          If NewFont.FHandle<>0 Then
          Begin
               If ahFont<>NewFont.FHandle Then
               Begin
                    ahFont:=NewFont.FHandle;
                    Inc(NewFont.FRefCount);
               End;
          End
          Else
          Begin
               ahFont:=CreateFontIndirect(aFontInfo);
               NewFont.FHandle:=ahFont;
               NewFont.FRefCount:=1;
          End;
     End
     Else ahFont:=CreateFontIndirect(aFontInfo);

     If ahFont<>0 Then
     Begin
          If FHandle<>0 Then SelectObject(FHandle,ahFont);
          If FFontHandle<>0 Then
          Begin
               If FFontHandle=FFont.FHandle Then
               Begin
                    If FFont.FRefCount>1 Then Dec(FFont.FRefCount)
                    Else
                    Begin
                         DeleteObject(FFontHandle);
                         FFont.FRefCount:=0;
                         FFont.FHandle:=0;
                    End;
               End
               Else If FFontHandle<>0 Then DeleteObject(FFontHandle)
          End;

          If FFont<>NewFont Then
          Begin
               DereferenceFont(FFont);
               FFont:=NewFont;
               ReferenceFont(FFont);
          End;
          FFontHandle:=ahFont;
     End
     Else If FFont<>Nil Then //restore old Font
     Begin
          Beep(10,10);
          NewFont:=FFont;
          Goto L;
     End;
     If FControl<>Nil Then
     Begin
          If ModifyControlFont Then
          Begin
               SendMessage(FControl.Handle,WM_SETFONT,ahFont,1);
               If FControl.IsFontChangeEnabled Then FControl.FontChange;
          End;
     End;
     {$ENDIF}

     {$IFDEF OS2}
L:
//     if FFontSet then
//     begin
       GpiSetCharSet(FHandle,LCID_DEFAULT);
       if not GpiDeleteSetId(FHandle,1) then
         rc := WinGetLastError( APpHandle ); // aaronl
//     end;
//     FFontSet := true;

     FillChar(fa,SizeOf(FATTRS),0);
     fa.szFaceName:=NewFont.FFontInfo.szFaceName;
     fa.usRecordLength:=SizeOf(FATTRS);

     fsSelection:=0;
     If aFontAttr*[faItalic]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_ITALIC;
     If aFontAttr*[faUnderScore]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_UNDERSCORE;
     If aFontAttr*[faOutline]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_OUTLINE;
     If aFontAttr*[faStrikeOut]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_STRIKEOUT;
     If aFontAttr*[faBold]<>[] Then
       fsSelection:=fsSelection Or FATTR_SEL_BOLD;
     fa.fsSelection:=fsSelection;

     fa.lMatch:=0;
     fa.idRegistry:=NewFont.FFontInfo.idRegistry;
     fa.usCodePage:=NewFont.FFontInfo.usCodePage;
     fa.lMaxbaseLineExt:=NewFont.FFontInfo.lMaxbaseLineExt;
     If NewFont.FFontType=ftOutline Then fa.lMaxbaseLineExt:=0;
     fa.lAveCharWidth:=NewFont.FFontInfo.lAveCharWidth;
     If NewFont.FFontType=ftOutline Then fa.lAveCharWidth:=0;

     fa.fsType:=0;
     If NewFont.FFontInfo.fsType And FM_TYPE_KERNING<>0 Then
       fa.fsType:=fa.fsType Or FATTR_TYPE_KERNING;
     If NewFont.FFontInfo.fsType And FM_TYPE_MBCS<>0 Then
       fa.fsType:=fa.fsType Or FATTR_TYPE_MBCS;
     If NewFont.FFontInfo.fsType And FM_TYPE_DBCS<>0 Then
       fa.fsType:=fa.fsType Or FATTR_TYPE_DBCS;

     fa.fsFontUse:=0;

     xRes:=HorizontalResolution;
     If ((Screen<>Nil)And(Screen.Canvas<>Nil)) Then
      If xRes>Screen.Canvas.HorizontalResolution Then //Canvas Is Not A Screen Canvas
         fa.fsFontUse:=FATTR_FONTUSE_TRANSFORMABLE;

     If NewFont.FFontType=ftOutline Then
       fa.fsFontUse:=FATTR_FONTUSE_OUTLINE Or FATTR_FONTUSE_TRANSFORMABLE;

     SafeTry:=False;
     SafeTry1:=False;
TryAgain:
     {the System Default Font results FONT_DEFAULT !!!}
     res:=GpiCreateLogFont(FHandle,Nil,1,fa);
     If res = FONT_DEFAULT Then {Test, If it Is really the Default Font}
     Begin
          // exact font not found; default font returned - Aaronl
          If (Screen <> Nil) And (Screen.FDefaultFont <> Nil) Then
            If NewFont <> Nil Then
            Begin
              f1 := NewFont.FaceName;
              f2 := Screen.FDefaultFont.FaceName;
              UpcaseStr(f1);
              UpcaseStr(f2);
              If f1 = f2 Then res := FONT_MATCH; {Font Is Ok}
            End;
     End;
     If ((res<>GPI_ERROR)And(res<>FONT_DEFAULT)) Then
     Begin
         // OK got match font
          If FFont<>NewFont Then
          Begin
               DereferenceFont(FFont);
               FFont:=NewFont;
               ReferenceFont(FFont);
          End;
          GpiSetCharSet(FHandle,1);
     End
     Else
     Begin
          // error or no match
          If res=FONT_DEFAULT Then
          Begin
               // default font given
               If Not SafeTry Then
               Begin
                    //Try If we can Create the Font If we don't Use Special Flags
                    SafeTry:=True;
                    fa.usCodePage:=0;
                    Goto TryAgain;
               End
               Else If Not SafeTry1 Then
               Begin
                    SafeTry1:=True;
                    fa.fsSelection:=0;
                    fa.idRegistry:=0;
                    fa.fsType:=0;
                    Goto TryAgain;
               End;
          End;

          If FFont<>Nil Then //restore old Font
          Begin
               If FFont=NewFont Then FFont:=Screen.DefaultFont;
               NewFont:=FFont;
               Goto L;
          End;
     End;

     If NewFont.FFontType=ftOutline Then
     Begin
          //Set character Box
          If NewFont.FInternalPointSize<>0 Then
          Begin
               aHDC:=GpiQueryDevice(FHandle);
               DevQueryCaps(aHDC,CAPS_HORIZONTAL_FONT_RES,1,xRes);
               DevQueryCaps(aHDC,CAPS_VERTICAL_FONT_RES,1,yRes);

               aSizeF.CX:=65536*xRes*NewFont.FInternalPointSize Div 72;
               aSizeF.CY:=65536*yRes*NewFont.FInternalPointSize Div 72;
          End
          Else
          Begin
               aptl[0].X:=0;
               aptl[0].Y:=0;
               aptl[1].X:=aWidth*13;   {Font Width In Pixels}
               aptl[1].Y:=aHeight*13;  {Font Height In Pixels}
               //Convert To page coordinates
               GpiConvert(FHandle,CVTC_DEVICE,CVTC_PAGE,2,aptl[0]);
               aSizeF.CX:=(aptl[1].X-aptl[0].X) Shl 12;
               aSizeF.CY:=(aptl[1].Y-aptl[0].Y) Shl 12;
          End;

          If aSizeF.CX<aSizeF.CY Then aSizeF.CY:=aSizeF.CX
          Else aSizeF.CX:=aSizeF.CY;

          GpiSetCharBox(FHandle,aSizeF);
     End;

     If FControl <> Nil Then
       If FControl.Handle <> 0 Then
         If ModifyControlFont Then
     Begin
          If NewFont.FInternalPointSize<>0 Then
          Begin
               S:=tostr(NewFont.FInternalPointSize)+'.';
               C:=NewFont.FaceName;
          End
          Else
          Begin
               GpiQueryFontMetrics(FHandle,SizeOf(FONTMETRICS),Metrics);
               S:=tostr((Metrics.sNominalPointSize) Div 10)+'.';
               C:=Metrics.szFaceName;
          End;

          S:=S+C;
          S:=ModifyFontName(S,aFontAttr);
          FControl.SetPPFontNameSize(S);
     End;
     {$ENDIF}
End;

Procedure TCanvas.SetFontAttr(NewAttr:TFontAttributes);
Begin
     If GetFontAttr <> NewAttr Then
     Begin
          FFontAttr:=NewAttr;
          {der ControlFont darf nicht verndert werden !!!}
          CreateFont(FFont,False);
     End;
End;

Function TCanvas.GetFontAttr:TFontAttributes;
Begin
     If FFontAttr=[] Then Result:=FFont.Attributes
     Else Result:=FFontAttr;
End;

Procedure TCanvas.SetFontHeight(NewHeight:LongInt);
Begin
     If GetFontHeight <> NewHeight Then
     Begin
          FFontHeight:=NewHeight;
          {der ControlFont darf nicht verndert werden !!!}
          CreateFont(FFont,False);
     End;
End;

Function TCanvas.GetFontHeight:LongInt;
Begin
     If FFontHeight=0 Then Result:=FFont.Height
     Else Result:=FFontHeight;
End;

Procedure TCanvas.SetFontWidth(NewWidth:LongInt);
Begin
     If GetFontWidth <> NewWidth Then
     Begin
          FFontWidth:=NewWidth;
          {der ControlFont darf nicht verndert werden !!!}
          CreateFont(FFont,False);
     End;
End;

Function TCanvas.GetFontWidth:LongInt;
Begin
     If FFontWidth=0 Then Result:=FFont.Width
     Else Result:=FFontWidth;
End;


Procedure TCanvas.SetupComponent;
Begin
     Inherited SetupComponent;

//     FFontSet:= false;
     //If Owner = Nil Then Exit;
     Include(ComponentState, csDetail);
     FControl:=Nil;
     FGraphic:=Nil;
     If IsControl(TControl(Owner)) Then FControl := TControl(Owner)
     Else If Owner Is TGraphic Then FGraphic := TGraphic(Owner);

     Name:='Canvas';
     FPen.Create(Self);
     FBrush.Create(Self);
     FLineWidth:=1;
     FLineType:=psSolid;
     FCopyMode:=cmSrcCopy;
     FFontAttr:=[];
End;

Procedure TCanvas.Init;
Begin
     If (FControl <> Nil) And (FControl.Handle <> 0) Then
     Begin
          FOwnerDraw:=FControl.FOwnerDraw;
          {$IFDEF OS2}
          FHandle:=WinGetPS(FControl.Handle);
          GpiCreateLogColorTable(FHandle,LCOL_RESET,LCOLF_RGB,0,0,Nil);
          {$ENDIF}
          {$IFDEF Win32}
          If FOwnerDraw Then
          Begin
               If FHandle=0 Then FHandle:=GetDC(FControl.Handle);
               SetTextAlign(FHandle,TA_LEFT Or TA_BOTTOM);
               {
               If FPenHandle=0 Then FPenHandle:=CreatePen(PS_SOLID,0,0);  //Black solid Pen
               If FBrushHandle=0 Then FBrushHandle:=CreateSolidBrush(0);  //Black Brush
               }
          End;
          {$ENDIF}

          If FControl.FFont <> Nil Then Font := FControl.FFont
          Else Font := Screen.DefaultFont; {small}
     End
     Else If FGraphic<>Nil Then
     Begin
          FOwnerDraw:=True;
          {$IFDEF Win32}
          {
          FPenHandle:=CreatePen(PS_SOLID,0,0);  //Black solid Pen
          FBrushHandle:=CreateSolidBrush(0);    //Black Brush
          }

          {$ENDIF}
          Font:=Screen.DefaultFont; {small}
     End;

     Pen.color:=clBlack;
     Brush.color:=clWhite;
     Brush.Mode:=bmOpaque;
     Brush.Style:=bsSolid;
     Pen.Mode:=pmCopy;
     Pen.Style:=psSolid;

     FPalette.Create(Self);

     {$IFDEF WIN32}
     If FPenHandle<>0 Then
     Begin
         If FHandle<>0 Then
           SelectObject(FHandle,GetStockObject(BLACK_PEN));
         DeleteObject(FPenHandle);
         FPenHandle:=0;
     End;
     If FBrushHandle<>0 Then
     Begin
          If FHandle<>0 Then
            SelectObject(FHandle,GetStockObject(WHITE_BRUSH));
          DeleteObject(FBrushHandle);
          FBrushHandle:=0;
     End;
     {$ENDIF}

End;

Destructor TCanvas.Destroy;
var
  rc: ERRORID;
Begin
     {$IFDEF OS2}
     If FHandle<>0 Then
     Begin
//          if FFontSet then
//          begin
               // aaronl - delete logical font
               GpiSetCharSet(FHandle,LCID_DEFAULT);
               if not GpiDeleteSetId(FHandle,1) then
                   rc := WinGetLastError(AppHandle);
//               FFontSet := false;
//          end;

          // free clip region...
          DeleteClipRegion;

          If (FControl <> Nil) Then
          Begin
               // release control PS
               if not WinReleasePS(FHandle) then
                    rc := WinGetLastError(AppHandle);
          End;


     End;
     DereferenceFont(FFont);
     {$ENDIF}
     {$IFDEF Win32}
     If FHandle<>0 Then
     Begin
          SelectObject(FHandle,GetStockObject(BLACK_PEN));
          SelectObject(FHandle,GetStockObject(WHITE_BRUSH));
          If FControl <> Nil Then ReleaseDC(FControl.Handle,FHandle);
          SelectClipRgn(FHandle,0);
          FHandle:=0;
     End;
     If FPenHandle<>0 Then DeleteObject(FPenHandle);
     FPenHandle:=0;
     If FBrushHandle<>0 Then DeleteObject(FBrushHandle);
     FBrushHandle:=0;
     If FFontHandle<>0 Then
     Begin
          If FFontHandle=FFont.FHandle Then
          Begin
              If FFont.FRefCount>1 Then Dec(FFont.FRefCount)
              Else
              Begin
                   If FFontHandle<>0 Then DeleteObject(FFontHandle);
                   FFont.FRefCount:=0;
                   FFont.FHandle:=0;
              End;
          End
          Else
          If FFontHandle<>0 Then DeleteObject(FFontHandle);
     End;
     If FClipRGN<>0 Then DeleteObject(FClipRGN);
     FFontHandle:=0;
     DereferenceFont(FFont);
     {$ENDIF}

     If FPalette <> Nil Then FPalette.Destroy;   {DragCanvas has no Palette}
     FPalette := Nil;
     If FPen <> Nil Then FPen.Destroy;
     FPen := Nil;
     If FBrush <> Nil Then FBrush.Destroy;
     FBrush := Nil;

     Inherited Destroy;   {erst hier weil Palette In ComponentListe steht}
End;


Function TCanvas.GetPenPosition:TPoint;
Begin
     {$IFDEF OS2}
     GPIQueryCurrentPosition(FHandle,Result);
     {$ENDIF}
     {$IFDEF Win32}
     GetCurrentPositionEx(FHandle,Result);
     TransformClientPoint(Result,FControl,FGraphic);
     {$ENDIF}
End;

Procedure TCanvas.SetPenPosition(NewPosition:TPoint);
Begin
     {$IFDEF OS2}
     GPIMove(FHandle,NewPosition);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(NewPosition,FControl,FGraphic);
     MoveToEx(FHandle,NewPosition.X,NewPosition.Y,NewPosition);
     {$ENDIF}
End;

Procedure TCanvas.EraseBackGround;
Begin
     If FControl = Nil Then Exit;
     FillRect(FControl.GetClientRect,FControl.color);
End;


{wenn Systemfarbe eingestellt ist, dann versuchen Die Standardfarbtabelle
  verwenden und nicht RGB}
Procedure TCanvas.FillRect(Const rec:TRect; FillColor:TColor);
Var  rc:TRect;
     {$IFDEF Win32}
     TempBrush:HBRUSH;
     {$ENDIF}
Begin
     rc := rec;
     Inc(rc.Right);
     Inc(rc.Top);

     FillColor := SysColorToRGB(FillColor);
     {$IFDEF OS2}
     WinFillRect(FHandle,RECTL(rc),FillColor);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientRect(rc,FControl,FGraphic);
     Inc(rc.Bottom);
     Inc(rc.Top);

     FillColor:=RGBToWinColor(FillColor);
     TempBrush:=CreateSolidBrush(FillColor);
     If FHandle<>0 Then SelectObject(FHandle,TempBrush);
     WinUser.FillRect(FHandle,RECTL(rc),TempBrush);
     If FBrushHandle<>0 Then SelectObject(FHandle,FBrushHandle)
     Else SelectObject(FHandle,GetStockObject(WHITE_BRUSH));
     If TempBrush<>0 Then DeleteObject(TempBrush);
     {$ENDIF}
End;


{$IFDEF Win32}
Function ExtendLastPoint(Src,Dest:TPoint):TPoint;
Var  X,Y,DX,dy:LongInt;
Begin
     Result := Dest;
     DX := Dest.X - Src.X;
     dy := Dest.Y - Src.Y;
     If (DX = 0) And (dy = 0) Then Exit;
     If Abs(DX) >= Abs(dy) Then
     Begin
          If Dest.X > Src.X Then Result.X := Dest.X + 1
          Else Result.X := Dest.X - 1;
          X := Result.X - Src.X;
          If dy <> 0 Then Result.Y := Round(((X * dy) / DX) + Src.Y)
     End
     Else
     Begin
          If Dest.Y > Src.Y Then Result.Y := Dest.Y + 1
          Else Result.Y := Dest.Y - 1;
          Y := Result.Y - Src.Y;
          If DX <> 0 Then Result.X := Round(((Y * DX) / dy) + Src.X)
     End;
End;
{$ENDIF}


Procedure TCanvas.MoveTo(X,Y:LongInt);
Begin
     PenPos:=Point(X,Y);
End;


Function TCanvas.GetVerticalRes:LongInt;
{$IFDEF OS2}
Var HDC:LongWord;
{$ENDIF}
Begin
     Result:=0;
     {$IFDEF OS2}
     If FControl=Nil Then
     Begin
          HDC:=GpiQueryDevice(FHandle);
          DevQueryCaps(HDC,CAPS_VERTICAL_RESOLUTION,1,Result);
     End
     Else
     Begin
          HDC:=WinOpenWindowDC(FControl.Handle);
          DevQueryCaps(HDC,CAPS_VERTICAL_RESOLUTION,1,Result);
          // DevCloseDC(HDC);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=GetDeviceCaps(FHandle,LOGPIXELSY);
     {$ENDIF}
End;

Function TCanvas.GetHorizontalRes:LongInt;
{$IFDEF OS2}
Var HDC:LongWord;
{$ENDIF}
Begin
     Result:=0;
     {$IFDEF OS2}
     If FControl=Nil Then
     Begin
          HDC:=GpiQueryDevice(FHandle);
          DevQueryCaps(HDC,CAPS_HORIZONTAL_RESOLUTION,1,Result);
     End
     Else
     Begin
          HDC:=WinOpenWindowDC(FControl.Handle);
          DevQueryCaps(HDC,CAPS_HORIZONTAL_RESOLUTION,1,Result);
          //DevCloseDC(HDC);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Result:=GetDeviceCaps(FHandle,LOGPIXELSX);
     {$ENDIF}
End;

Procedure TCanvas.BeginPath;
Begin
     {$IFDEF OS2}
     GpiBeginPath(FHandle,1);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.BeginPath(FHandle);
     FInPath := True;
     {$ENDIF}
End;

Procedure TCanvas.EndPath;
Begin
     {$IFDEF OS2}
     GpiEndPath(FHandle);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.EndPath(FHandle);
     FInPath := False;
     {$ENDIF}
End;

Procedure TCanvas.CloseFigure;
Begin
     {$IFDEF OS2}
     GpiCloseFigure(FHandle);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.CloseFigure(FHandle);
     {$ENDIF}
End;

Procedure TCanvas.FillPath;
Begin
     {$IFDEF OS2}
     GpiFillPath(FHandle,1,FPATH_ALTERNATE);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.FillPath(FHandle);
     {$ENDIF}
End;

Procedure TCanvas.StrokePath;
Begin
     {$IFDEF OS2}
     GpiStrokePath(FHandle,1,0);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.StrokePath(FHandle);
     {$ENDIF}
End;

Procedure TCanvas.OutlinePath;
Begin
     {$IFDEF OS2}
     GpiOutlinePath(FHandle,1,0);
     {$ENDIF}
     {$IFDEF Win32}
     WinGDI.StrokePath(FHandle); {.?.}
     {$ENDIF}
End;

Procedure TCanvas.PathToClipRegion(Mode:TPathClipMode);
{$IFDEF OS2}
Var  reg1,reg2,regnew,regold:HRGN;
{$ENDIF}
{$IFDEF Win32}
Var  iMode:LongWord;
{$ENDIF}
Begin
     {$IFDEF OS2}
     reg2:=GpiPathToRegion(FHandle,1,FPATH_ALTERNATE);

     If Mode<>paReplace Then
     Begin
          GpiSetClipRegion(FHandle,0,reg1);
          regnew:=GpiCreateRegion(FHandle,0,Nil);
          GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_DIFF);
     End
     Else
     Begin
          regnew:=reg2;
          reg1:=0;
          reg2:=0;
     End;

     Case Mode Of
        paSubtract:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_XOR);
        paAdd:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_OR);
        paDiff:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_DIFF);
        paIntersect:GpiCombineRegion(FHandle,regnew,reg1,reg2,CRGN_AND);
        paReplace:;
     End;

     GpiSetClipRegion(FHandle,regnew,regold);
     If regold<>0 Then GpiDestroyRegion(FHandle,regold);
     If reg1<>0 Then GpiDestroyRegion(FHandle,reg1);
     If reg2<>0 Then GpiDestroyRegion(FHandle,reg2);
     If FClipRGN<>0 Then GpiDestroyRegion(FHandle,FClipRGN);
     FClipRGN:=regnew;
     {$ENDIF}
     {$IFDEF Win32}
     Case Mode Of
        paSubtract:iMode:=RGN_XOR;
        paAdd:iMode:=RGN_OR;
        paDiff:iMode:=RGN_DIFF;
        paIntersect:iMode:=RGN_AND;
        paReplace:iMode:=RGN_COPY;
     End;
     WinGDI.SelectClipPath(FHandle,iMode);
     {$ENDIF}
End;


Procedure TCanvas.LineTo(X,Y:LongInt);
Var  Dest:TPoint;
Begin
     Dest := Point(X,Y);
     {$IFDEF OS2}
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiLine(FHandle,Dest);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     Dest := ExtendLastPoint(GetPenPosition,Dest);
     TransformClientPoint(Dest,FControl,FGraphic);
     WinGDI.LineTo(FHandle,Dest.X,Dest.Y);
     {$ENDIF}
End;

Procedure TCanvas.Line(X,Y,X1,y1:LongInt);
Begin
     MoveTo(X,Y);
     LineTo(X1,y1);
End;

Procedure TCanvas.PolyLine(Points:Array Of TPoint);
{$IFDEF Win32}
Var  T:LongInt;
     P:TPoint;
     Q:TPoint;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FUsePath Then GpiBeginPath(FHandle,1);
     GPIMove(FHandle,Points[0]);
     GpiPolyLine(FHandle,High(Points)+1,Points[0]);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If High(Points) > 1 Then
     Begin
          P:=Points[High(Points)-1];
          Points[High(Points)]:=ExtendLastPoint(P,Points[High(Points)]);
     End;

     If FInPath Then
     Begin
          For T:=1 To High(Points) Do
          Begin
               Q := Points[T-1];
               P := Points[T];
               If (Q.X < P.X) And (Q.Y > P.Y) Then
               Begin
                    P.X := P.X + 1;
                    P.Y := P.Y - 1;
                    Points[T] := P;
               End;
          End;
     End;

     For T:=0 To High(Points)
        Do TransformClientPoint(Points[T],FControl,FGraphic);
     WinGDI.PolyLine(FHandle,WinDef.Point(Points[0]),High(Points)+1);
     PenPos:=Points[High(Points)];
     {$ENDIF}
End;

Procedure TCanvas.Polygon(Points:Array Of TPoint);
{$IFDEF OS2}
Var  ThePolygon:PmGpi.Polygon;
{$ENDIF}
{$IFDEF Win32}
Var  T:LongInt;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If FUsePath Then GpiBeginPath(FHandle,1);
     GPIMove(FHandle,Points[0]);
     ThePolygon.ulPoints:=High(Points)+1;
     ThePolygon.POINTL:=@Points[0];
     GpiPolygons(FHandle,1,ThePolygon,0,0);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     For T:=0 To High(Points)
        Do TransformClientPoint(Points[T],FControl,FGraphic);
     WinGDI.Polygon(FHandle,WinDef.Point(Points[0]),High(Points)+1);
     PenPos:=Points[High(Points)];
     {$ENDIF}
End;

Procedure TCanvas.ShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
{$IFDEF Win32}
Var  Pen:HPEN;
     Pen1:HPEN;
{$ENDIF}
{$IFDEF OS2}
Var  OldPenColor:TColor;
     OldPenWidth:LongInt;
{$ENDIF}
Begin
     If FHandle = 0 Then Exit;
     ColorHi := SysColorToRGB(ColorHi);
     ColorLo := SysColorToRGB(ColorLo);

     {$IFDEF OS2}
     OldPenColor := Pen.color;
     OldPenWidth := Pen.Width;
     Pen.color := ColorHi;
     Line(rec.Left,rec.Top,rec.Right,rec.Top);
     Pen.color := ColorLo;
     Line(rec.Left,rec.Bottom,rec.Right,rec.Bottom);
     Pen.color := ColorHi;
     Line(rec.Left,rec.Bottom,rec.Left,rec.Top);
     Pen.color := ColorLo;
     Line(rec.Right,rec.Bottom,rec.Right,rec.Top);
     Pen.color := OldPenColor;
     Pen.Width := OldPenWidth;
     {$ENDIF}

     {$IFDEF Win32}
     ColorLo := RGBToWinColor(ColorLo);
     ColorHi := RGBToWinColor(ColorHi);
     Pen1 := CreatePen(PS_SOLID,1,ColorHi);
     SelectObject(FHandle,Pen1);
     Line(rec.Left,rec.Bottom,rec.Left,rec.Top);
     Line(rec.Left,rec.Top,rec.Right,rec.Top);
     Pen:=CreatePen(PS_SOLID,1,ColorLo);
     DeleteObject(SelectObject(FHandle,Pen));
     Line(rec.Right,rec.Bottom,rec.Right,rec.Top);
     Line(rec.Left,rec.Bottom,rec.Right,rec.Bottom);
     If FPenHandle<>0 Then DeleteObject(SelectObject(FHandle,FPenHandle))
     Else DeleteObject(SelectObject(FHandle,GetStockObject(BLACK_PEN)));
     If Pen <> 0 Then DeleteObject(Pen);
     {$ENDIF}
End;

Procedure TCanvas.RoundShadowedBorder(Const rec:TRect;ColorHi,ColorLo:TColor);
Var  I:LongInt;
     {$IFDEF Win32}
     Pen:HPEN;
     Pen1:HPEN;
     {$ENDIF}
     {$IFDEF OS2}
     OldPenColor:TColor;
     OldPenWidth:LongInt;
     {$ENDIF}
Begin
     If FHandle = 0 Then Exit;
     ColorHi := SysColorToRGB(ColorHi);
     ColorLo := SysColorToRGB(ColorLo);
     I := 2;
     {$IFDEF OS2}
     OldPenColor := Pen.color;
     OldPenWidth := Pen.Width;
     Pen.color := ColorHi;
     Line(rec.Left+I,rec.Bottom,rec.Left,rec.Bottom+I);
     Line(rec.Left,rec.Bottom+I,rec.Left,rec.Top-I);
     Pen.color := ColorLo;
     Line(rec.Right-I,rec.Top,rec.Right,rec.Top-2);
     Line(rec.Right,rec.Top-I,rec.Right,rec.Bottom+2);
     Pen.color := ColorHi;
     Line(rec.Left,rec.Top-I,rec.Left+I,rec.Top);
     Line(rec.Left+I,rec.Top,rec.Right-I,rec.Top);
     Pen.color := ColorLo;
     Line(rec.Right,rec.Bottom+I,rec.Right-I,rec.Bottom);
     Line(rec.Right-I,rec.Bottom,rec.Left+I,rec.Bottom);
     Pen.color := OldPenColor;
     Pen.Width := OldPenWidth;
     {$ENDIF}

     {$IFDEF Win32}
     ColorLo := RGBToWinColor(ColorLo);
     ColorHi := RGBToWinColor(ColorHi);
     Pen1 := CreatePen(PS_SOLID,1,ColorHi);
     SelectObject(FHandle,Pen1);
     Line(rec.Left+I,rec.Bottom,rec.Left,rec.Bottom+I);
     Line(rec.Left,rec.Bottom+I,rec.Left,rec.Top-I);
     Line(rec.Left,rec.Top-I,rec.Left+I,rec.Top);
     Line(rec.Left+I,rec.Top,rec.Right-I,rec.Top);
     Pen:=CreatePen(PS_SOLID,1,ColorLo);
     DeleteObject(SelectObject(FHandle,Pen));
     Line(rec.Right-I,rec.Top,rec.Right,rec.Top-I);
     Line(rec.Right,rec.Top-I,rec.Right,rec.Bottom+I);
     Line(rec.Right,rec.Bottom+I,rec.Right-I,rec.Bottom);
     Line(rec.Right-I,rec.Bottom,rec.Left+I,rec.Bottom);
     If FPenHandle<>0 Then DeleteObject(SelectObject(FHandle,FPenHandle))
     Else DeleteObject(SelectObject(FHandle,GetStockObject(BLACK_PEN)));
     If Pen <> 0 Then DeleteObject(Pen);
     {$ENDIF}
End;


Procedure TCanvas.Rectangle(Const rec:TRect);
{$IFDEF OS2}
Var  CurrentPoint,DiagPoint:TPoint;
{$ENDIF}
{$IFDEF Win32}
Var  rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     CurrentPoint.X:=rec.Left;
     CurrentPoint.Y:=rec.Bottom;
     DiagPoint.X:=CurrentPoint.X+(rec.Right-rec.Left);
     DiagPoint.Y:=CurrentPoint.Y+(rec.Top-rec.Bottom);
     GPIMove(FHandle,CurrentPoint);
     GPIBox(FHandle,DRO_OUTLINE,DiagPoint,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     If Not FInPath Then
     Begin
          rc := rec;
          Dec(rc.Bottom);
          Inc(rc.Right);
          RectToWin32Rect(rc);
          TransformClientRect(rc,FControl,FGraphic);
          FrameRect(FHandle,RECTL(rc),FBrushHandle);
     End
     Else
     Begin
          PolyLine([Point(rec.Left,rec.Bottom-1),Point(rec.Right+1,rec.Bottom-1),
                    Point(rec.Right+1,rec.Top),Point(rec.Left,rec.Top),
                    Point(rec.Left,rec.Bottom-1)]);
     End;
     {$ENDIF}
End;

Procedure TCanvas.FilledRoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
Begin
    BeginPath;
    RoundRect(rec,RoundWidth,RoundHeight);
    EndPath;
    FillPath;
End;

Procedure TCanvas.RoundRect(Const rec:TRect;RoundWidth,RoundHeight:LongInt);
{$IFDEF Win32}
Var rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     If RoundWidth>rec.Right-rec.Left Then RoundWidth:=(rec.Right-rec.Left) Div 2;
     If RoundHeight>rec.Top-rec.Bottom Then RoundHeight:=(rec.Top-rec.Bottom) Div 2;

     PenPos:=Point(rec.Left+RoundWidth,rec.Bottom);
     LineTo(rec.Right-RoundWidth,rec.Bottom);
     Arc(rec.Right-RoundWidth,rec.Bottom+RoundHeight,RoundWidth,RoundHeight,270,90);

     LineTo(rec.Right,rec.Top-RoundHeight);
     Arc(rec.Right-RoundWidth,rec.Top-RoundHeight,RoundWidth,RoundHeight,0,90);

     LineTo(rec.Left+RoundWidth,rec.Top);
     Arc(rec.Left+RoundWidth,rec.Top-RoundHeight,RoundWidth,RoundHeight,90,90);

     LineTo(rec.Left,rec.Bottom+RoundHeight);
     Arc(rec.Left+RoundWidth,rec.Bottom+RoundHeight,RoundWidth,RoundHeight,180,90);
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     Dec(rc.Bottom);
     Inc(rc.Right);
     RectToWin32Rect(rc);
     WinGDI.RoundRect(FHandle, rc.Left, rc.Top, rc.Right, rc.Bottom, RoundWidth, RoundHeight);
     {$ENDIF}
End;

Procedure TCanvas.DrawInvertRect(Const rec:TRect);
Var  rc:TRect;
     {$IFDEF OS2}
     SaveLineType:TPenStyle;
     {$ENDIF}
Begin
     rc := rec;
     {$IFDEF OS2}
     Inc(rc.Right);
     Inc(rc.Top);
     SaveLineType:=Pen.Style;
     Pen.Style:=psInsideFrame;
     WinDrawBorder(FHandle,RECTL(rc),1,1,clBlack,clBlack,DB_DESTINVERT);
     Pen.Style:=SaveLineType;
     {$ENDIF}
     {$IFDEF Win32}
     Dec(rc.Bottom);
     Inc(rc.Right);
     RectToWin32Rect(rc);
     TransformClientRect(rc,FControl,FGraphic);
     WinUser.DrawFocusRect(FHandle,RECTL(rc));
     {$ENDIF}
End;

Procedure TCanvas.Circle(X,Y:LongInt;Radius:LongInt);
Begin
     Ellipse(X,Y,Radius,Radius);
End;

Procedure TCanvas.BrushCopy(Const Dest:TRect;Bitmap:TGraphic;Const Source:TRect;Color:TColor);
Var Mask:TGraphic;
Begin
     Mask:=Bitmap.CreateMask(Color);
     Mask.Canvas.BitBlt(Self,Dest,Source,cmSrcAnd,bitfIgnore);
     Bitmap.Canvas.BitBlt(Self,Dest,Source,cmSrcPaint,bitfIgnore);
     Mask.Destroy;
End;

Procedure ChordPie(Canvas:TCanvas;X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:ExtEndeD;
                   Var StartPoint:TPoint);
Var  pt:TPoint;
     {$IFDEF OS2}
     arcp:ARCPARAMS;
     sa,swa:FIXED;
     save:TPenStyle;
     {$ENDIF}
Begin
     pt:=Point(X,Y);
     Canvas.PenPos:=pt;
     {$IFDEF OS2}
     arcp.lp:=RadiusX;
     arcp.lQ:=RadiusY;
     arcp.lr:=0;
     arcp.lS:=0;
     GpiSetArcParams(Canvas.FHandle,arcp);
     sa:=MAKEFIXED(Trunc(StartAngle),Round(Frac(StartAngle)*100));
     swa:=MAKEFIXED(0,0);
     save:=Canvas.Pen.Style;
     Canvas.Pen.Style:=psClear;
     GpiPartialArc(Canvas.FHandle,pt,MAKEFIXED(1,0),sa,swa);
     Canvas.Pen.Style:=save;
     StartPoint:=Canvas.PenPos;
     Canvas.BeginPath;
     swa:=MAKEFIXED(Trunc(SweepAngle),Round(Frac(SweepAngle)*100));
     GpiPartialArc(Canvas.FHandle,pt,MAKEFIXED(1,0),sa,swa);
     {$ENDIF}
     {$IFDEF Win32}
     AngleArc(Canvas.FHandle,pt.X,pt.Y,RadiusX,StartAngle,0);
     StartPoint:=Canvas.PenPos;
     Canvas.PenPos:=pt;
     Canvas.BeginPath;
     AngleArc(Canvas.FHandle,pt.X,pt.Y,RadiusX,StartAngle,SweepAngle);
     {$ENDIF}
End;

Procedure TCanvas.Chord(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
Var StartPoint:TPoint;
    SaveColor:TColor;
Begin
     SaveColor:=Pen.color;
     If Brush.Style=bsSolid Then Pen.color:=Brush.color;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     FillPath;

     Pen.color:=SaveColor;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     OutlinePath;
End;

Procedure TCanvas.Pie(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
Var StartPoint:TPoint;
    SaveColor:TColor;
Begin
     SaveColor:=Pen.color;
     If Brush.Style=bsSolid Then Pen.color:=Brush.color;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     LineTo(X,Y);
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     FillPath;

     Pen.color:=SaveColor;
     ChordPie(Self,X,Y,RadiusX,RadiusY,StartAngle,SweepAngle,StartPoint);
     LineTo(X,Y);
     LineTo(StartPoint.X,StartPoint.Y);
     EndPath;
     OutlinePath;
End;

Procedure TCanvas.Arc(X,Y:LongInt;RadiusX,RadiusY:LongInt;StartAngle,SweepAngle:Extended);
Var  pt:TPoint;
     {$IFDEF OS2}
     arcp:ARCPARAMS;
     sa,swa:FIXED;
     save:TPenStyle;
     {$ENDIF}
Begin
     pt:=Point(X,Y);
     {$IFDEF OS2}
     If SweepAngle>=0 Then //counterclockwise
     Begin
         arcp.lp:=RadiusX;
         arcp.lQ:=RadiusY;
         arcp.lr:=0;
         arcp.lS:=0;
     End
     Else
     Begin
         arcp.lr:=RadiusX;
         arcp.lS:=RadiusY;
         arcp.lp:=0;
         arcp.lQ:=0;
         If SweepAngle<0 Then SweepAngle:=-SweepAngle;
     End;
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiSetArcParams(FHandle,arcp);
     sa:=MAKEFIXED(Trunc(StartAngle),Round(Frac(StartAngle)*100));
     swa:=MAKEFIXED(0,0);
     save:=Pen.Style;
     Pen.Style:=psClear;
     GpiPartialArc(FHandle,pt,MAKEFIXED(1,0),sa,swa);
     Pen.Style:=save;
     swa:=MAKEFIXED(Trunc(SweepAngle),Round(Frac(SweepAngle)*100));
     GpiPartialArc(FHandle,pt,MAKEFIXED(1,0),sa,swa);
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If SweepAngle<0 Then
     Begin
          SetArcDirection(FHandle,AD_CLOCKWISE);
          SweepAngle:=-SweepAngle;
     End
     Else SetArcDirection(FHandle,AD_COUNTERCLOCKWISE);
     PenPos:=pt;
     AngleArc(FHandle,pt.X,pt.Y,RadiusX,StartAngle,SweepAngle);
     SetArcDirection(FHandle,AD_COUNTERCLOCKWISE);
     {$ENDIF}
End;

Procedure TCanvas.FilledCircle(X,Y:LongInt;Radius:LongInt);
Begin
     FilledEllipse(X,Y,Radius,Radius);
End;

Procedure TCanvas.Ellipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
Var  pt:TPoint;
     {$IFDEF OS2}
     arcp:ARCPARAMS;
     {$ENDIF}
Begin
     pt:=Point(X,Y);
     {$IFDEF OS2}
     arcp.lp:=RadiusX;
     arcp.lQ:=RadiusY;
     arcp.lr:=0;
     arcp.lS:=0;
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiSetArcParams(FHandle,arcp);
     GPIMove(FHandle,pt);
     GpiFullArc(FHandle,DRO_OUTLINE,MAKEFIXED(1,0));
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,FControl,FGraphic);
     WinGDI.Arc(FHandle,pt.X-RadiusX,pt.Y+RadiusY,pt.X+RadiusX,pt.Y-RadiusY,
                pt.X-RadiusX,pt.Y-RadiusY,pt.X-RadiusX,pt.Y-RadiusY);
     {$ENDIF}
End;

Procedure TCanvas.FilledEllipse(X,Y:LongInt;RadiusX,RadiusY:LongInt);
Var  pt:TPoint;
     {$IFDEF OS2}
     arcp:ARCPARAMS;
     {$ENDIF}
Begin
     pt:=Point(X,Y);
     {$IFDEF OS2}
     arcp.lp:=RadiusX;
     arcp.lQ:=RadiusY;
     arcp.lr:=0;
     arcp.lS:=0;
     If FUsePath Then GpiBeginPath(FHandle,1);
     GpiSetArcParams(FHandle,arcp);
     GPIMove(FHandle,pt);
     GpiFullArc(FHandle,DRO_FILL,MAKEFIXED(1,0));
     If FUsePath Then
     Begin
          GpiEndPath(FHandle);
          GpiStrokePath(FHandle,1,0);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,FControl,FGraphic);
     WinGDI.Ellipse(FHandle,pt.X-RadiusX,pt.Y+RadiusY,pt.X+RadiusX,pt.Y-RadiusY);
     {$ENDIF}
End;

Procedure TCanvas.BezierSpline(X,Y:LongInt;Points:Array Of TPoint);
{$IFDEF Win32}
Var  T:LongInt;
{$ENDIF}
Begin
     MoveTo(X,Y);
     {$IFDEF OS2}
     GpiPolySpline(FHandle,High(Points)+1,Points[0]);
     {$ENDIF}
     {$IFDEF Win32}
     For T:=0 To High(Points)
        Do TransformClientPoint(Points[T],FControl,FGraphic);
     PolyBezierTo(FHandle,Points[0],High(Points)+1);
     {$ENDIF}
End;

Procedure TCanvas.Box(Const rec:TRect);
{$IFDEF OS2}
Var  CurrentPoint,DiagPoint:TPoint;
{$ENDIF}
{$IFDEF Win32}
Var  Pen:HPEN;
     rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     CurrentPoint.X:=rec.Left;
     CurrentPoint.Y:=rec.Bottom;
     DiagPoint.X:=CurrentPoint.X+(rec.Right-rec.Left);
     DiagPoint.Y:=CurrentPoint.Y+(rec.Top-rec.Bottom);
     GPIMove(FHandle,CurrentPoint);
     GPIBox(FHandle,DRO_FILL,DiagPoint,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     Pen:=GetStockObject(NULL_PEN);
     If FHandle<>0 Then SelectObject(FHandle,Pen);
     TransformClientRect(rc,FControl,FGraphic);
     Inc(rc.Bottom,2);
     Inc(rc.Right,2);
     WinGDI.Rectangle(FHandle,rc.Left,rc.Bottom,rc.Right,rc.Top);
     If FHandle<>0 Then
     Begin
          If FPenHandle<>0 Then SelectObject(FHandle,FPenHandle)
          Else SelectObject(FHandle,GetStockObject(BLACK_PEN));
     End;
     If Pen<>0 Then DeleteObject(Pen);
     {$ENDIF}
End;

Procedure TCanvas.OutlineBox(Const rec:TRect);
{$IFDEF OS2}
Var  CurrentPoint,DiagPoint:TPoint;
{$ENDIF}
{$IFDEF Win32}
Var  rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     CurrentPoint.X:=rec.Left;
     CurrentPoint.Y:=rec.Bottom;
     DiagPoint.X:=CurrentPoint.X+(rec.Right-rec.Left);
     DiagPoint.Y:=CurrentPoint.Y+(rec.Top-rec.Bottom);
     GPIMove(FHandle,CurrentPoint);
     GPIBox(FHandle,DRO_OUTLINEFILL,DiagPoint,0,0);
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     TransformClientRect(rc,FControl,FGraphic);
     Inc(rc.Bottom);
     Inc(rc.Right);
     WinGDI.Rectangle(FHandle,rc.Left,rc.Bottom,rc.Right,rc.Top);
     {$ENDIF}
End;

Procedure TCanvas.DrawFocusRect(Const rec:TRect);
{$IFDEF OS2}
Var  SaveLineType:TPenStyle;
{$ENDIF}
{$IFDEF Win32}
Var  rc:TRect;
{$ENDIF}
Begin
     {$IFDEF OS2}
     SaveLineType:=Pen.Style;
     Pen.Style:=psInsideFrame;
     Rectangle(rec);
     Pen.Style:=SaveLineType;
     {$ENDIF}
     {$IFDEF Win32}
     rc := rec;
     Inc(rc.Right);
     Dec(rc.Bottom);
     RectToWin32Rect(rc);
     TransformClientRect(rc,FControl,FGraphic);
     WinUser.DrawFocusRect(FHandle,RECTL(rc));
     {$ENDIF}
End;


Procedure TCanvas.FloodFill(X,Y:LongInt;BorderColor:TColor;FillSurface:Boolean);
Var  RefPoint:TPoint;
     Options:LongWord;
Begin
     RefPoint := Point(X,Y);
     BorderColor := SysColorToRGB(BorderColor);
     {$IFDEF OS2}
     GPIMove(FHandle,RefPoint);
     If FillSurface Then Options:=FF_SURFACE
     Else Options:=FF_BOUNDARY;
     GPIFloodFill(FHandle,Options,BorderColor);
     {$ENDIF}
     {$IFDEF Win32}
     BorderColor:=RGBToWinColor(BorderColor);
     TransformClientPoint(RefPoint,FControl,FGraphic);
     If FillSurface Then Options:=FLOODFILLSURFACE
     Else Options:=FLOODFILLBORDER;
     WinGDI.ExtFloodFill(FHandle,RefPoint.X,RefPoint.Y,BorderColor,Options);
     {$ENDIF}
End;


Procedure TCanvas.DrawString(Const S:String);
Var  pp:TPoint;
     {$IFDEF OS2}
     CX,CY:LongInt;
     rc:TRect;
     {$ENDIF}
     {$IFDEF Win32}
     Align:LongWord;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     {Some Fonts don't overpaint the the background}
     If Font.Attributes <> [] Then
       If Brush.Mode = bmOpaque Then
     Begin
          pp := PenPos;
          GetTextExtent(S,CX,CY);
          rc.Left := pp.X;
          rc.Bottom := pp.Y;
          rc.Right := rc.Left + CX -1;
          rc.Top := rc.Bottom + CY -1;
          FillRect(rc,Brush.color);
     End;
     GpiCharString(FHandle,Length(S),S[1]);
     {$ENDIF}
     {$IFDEF Win32}
     pp:=PenPos;
     Align:=GetTextAlign(FHandle);
     SetTextAlign(FHandle,Align Or TA_UPDATECP);
     WinGDI.TextOut(FHandle,pp.X,pp.Y,S[1],Length(S));
     SetTextAlign(FHandle,Align);
     {$ENDIF}
End;

Procedure TCanvas.TextOut(X,Y:LongInt;Const S:String);
Var  pt:TPoint;
     {$IFDEF OS2}
     CX,CY:LongInt;
     rc:TRect;
     {$ENDIF}
     {$IFDEF Win32}
     Align:LongWord;
     S1:String;
     {$ENDIF}
Begin
     pt := Point(X,Y);
     {$IFDEF OS2}
     {Some Fonts don't overpaint the the background}
     If Font.Attributes <> [] Then
       If Brush.Mode = bmOpaque Then
     Begin
          GetTextExtent(S,CX,CY);
          rc.Left := X;
          rc.Bottom := Y;
          rc.Right := rc.Left + CX -1;
          rc.Top := rc.Bottom + CY -1;
          FillRect(rc,Brush.color);
     End;
     Inc(pt.Y,FFont.FFontInfo.lMaxDescender);
     GpiCharStringAt(FHandle,pt,Length(S),S[1]);
     {$ENDIF}
     {$IFDEF Win32}
     Dec(pt.Y);
     PenPos:= pt;
     Align := GetTextAlign(FHandle);
     SetTextAlign(FHandle,Align Or TA_UPDATECP);
     TransformClientPoint(pt,FControl,FGraphic);
     S1:=S;
     StrOemToAnsi(S1);
     WinGDI.TextOut(FHandle,pt.X,pt.Y,S1[1],Length(S1));
     SetTextAlign(FHandle,Align);
     {$ENDIF}
End;

// Draw a string with mnemo char handling. If the mnemo
// char is found, the following char is underlined.
// Now draws the underline as a line, rather than using underscore
// font attribute: it looks better and is simpler.
Procedure TCanvas.MnemoTextOut(X,Y:LongInt;Const S:String);
Var  CX,CY:LongInt;
     TextBeforeMnemo:String;
     MnemoPos:Integer;
     DrawText: String;
     CharToUnderline: char;
     UnderlineLen: longint;
     Descender: longint;
Begin
     MnemoPos := Pos( MnemoChar, S );

     If MnemoPos = 0 Then
     Begin
          // No mnemo char, draw as is.
          TextOut( X, Y, S );
          exit;
     end;

     // Found Mnemo char
     DrawText:= S;
     Delete( DrawText, MnemoPos, 1 ); // delete mnemo char from text to display
     TextOut( X, Y, DrawText ); // draw text

     // Find point to start underline...
     TextBeforeMnemo := Copy( S, 1, MnemoPos-1 );
     {$IFDEF WIN32}
     StrOemToAnsi( TextBeforeMnemo );
     {$ENDIF}
     GetTextExtent( TextBeforeMnemo, CX ,CY );
     Inc( X, CX );

     // Find width of char to underline
     CharToUnderline:= S[ MnemoPos+1 ];
     {$IFDEF WIN32}
     StrOemToAnsi( CharToUnderline );
     {$ENDIF}
     GetTextExtent( CharToUnderline, UnderlineLen, CY );

     // Find height from bottom of text to underline
     Descender := Font.DescenderHeight;

     // Draw underline
     Line( X, Y + Descender - 3,
           X + UnderlineLen - 1, Y + Descender - 3 );
End;

Procedure TCanvas.Draw(X,Y:LongInt;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Graphic.Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Graphic.Height;
     Graphic.Draw(Self,rec);
End;

Procedure TCanvas.PartialDraw(X,Y:LongInt;Const SourceRec:TRect;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Graphic.Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Graphic.Height;
     Graphic.PartialDraw(Self,SourceRec,rec);
End;

Procedure TCanvas.StretchDraw(X,Y,Width,Height:LongInt;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Height;
     Graphic.Draw(Self,rec);
End;

Procedure TCanvas.StretchPartialDraw(X,Y,Width,Height:LongInt;
                                     Const SourceRec:TRect;Graphic:TGraphic);
Var  rec:TRect;
Begin
     If Graphic = Nil Then Exit;
     If Graphic.Empty Then Exit;  {Nothing To Draw}

     rec.Left:=X;
     rec.Right:=X+Width;
     rec.Bottom:=Y;
     rec.Top:=Y+Height;
     Graphic.PartialDraw(Self,SourceRec,rec);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: General FUNCTIONs Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Function OppositeRGB(color:TColor):TColor;
Var  R,G,B:Byte;
Begin
     RGBToValues(color,R,G,B);
     If R > $80 Then R := 0 Else R := $FF;
     If G > $80 Then G := 0 Else G := $FF;
     If B > $80 Then B := 0 Else B := $FF;
     Result := ValuesToRGB(R,G,B);
End;


Function ValuesToRGB(Red,Green,Blue:Byte):TColor;
Var  R,G,B:LongInt;
Begin
     R := Red;
     G := Green;
     B := Blue;
     Result := R Shl 16 + (G Shl 8) + B;
End;


Function RGBToValues(color:TColor;Var Red,Green,Blue:Byte):TColor;
Begin
     Result := SysColorToRGB(color);
     Red := (Result And $FFFFFF) Shr 16;
     Green := (Result And $FFFF) Shr 8;
     Blue := (Result And $FF);
End;


Const
    SysColors:Array[0..28] Of TColor = (
       {$IFDEF OS2}
       SYSCLR_SCROLLBAR, {clScrollbar}
       SYSCLR_BACKGROUND, {clBackGround}
       SYSCLR_ACTIVETITLE, {clActiveCaption}
       SYSCLR_INACTIVETITLE, {clInactiveCaption}
       SYSCLR_MENU, {clMenu}
       SYSCLR_WINDOW, {clWindow}
       SYSCLR_WINDOWFRAME, {clWindowFrame}
       SYSCLR_MENUTEXT, {clMenuText}
       SYSCLR_WINDOWTEXT, {clWindowText}
       SYSCLR_ACTIVETITLETEXT, {clCaptionText}
       SYSCLR_ACTIVEBORDER, {clActiveBorder}
       SYSCLR_INACTIVEBORDER, {clInactiveBorder}
       SYSCLR_APPWORKSPACE, {clAppWorkSpace}
       SYSCLR_HILITEBACKGROUND, {clHighlight}
       SYSCLR_HILITEFOREGROUND, {clHighlightText}
       SYSCLR_BUTTONMIDDLE, {clBtnFace}
       SYSCLR_BUTTONDARK, {clBtnShadow}
       clDkGray, {clGrayText}
       SYSCLR_MENUTEXT, {clBtnText}
       SYSCLR_INACTIVETITLETEXT, {clInactiveCaptionText}
       SYSCLR_BUTTONLIGHT, {clBtnHighlight}
       clBlack, {cl3DDkShadow}
       clWhite, {cl3DLight}
       clBlack, {clInfoText}
       clYellow,{clInfo}
       SYSCLR_BUTTONDEFAULT, {clBtnDefault}
       SYSCLR_DIALOGBACKGROUND, {clDlgWindow}
       SYSCLR_ENTRYFIELD, {clEntryField}
       SYSCLR_WINDOWSTATICTEXT {clStaticText}
       {$ENDIF}
       {$IFDEF Win95}
       COLOR_SCROLLBAR Or $80000000, {clScrollbar}
       COLOR_BACKGROUND Or $80000000, {clBackGround}
       COLOR_ACTIVECAPTION Or $80000000, {clActiveCaption}
       COLOR_INACTIVECAPTION Or $80000000, {clInactiveCaption}
       COLOR_MENU Or $80000000, {clMenu}
       COLOR_WINDOW Or $80000000, {clWindow}
       COLOR_WINDOWFRAME Or $80000000, {clWindowFrame}
       COLOR_MENUTEXT Or $80000000, {clMenuText}
       COLOR_WINDOWTEXT Or $80000000, {clWindowText}
       COLOR_CAPTIONTEXT Or $80000000, {clCaptionText}
       COLOR_ACTIVEBORDER Or $80000000, {clActiveBorder}
       COLOR_INACTIVEBORDER Or $80000000, {clInactiveBorder}
       COLOR_APPWORKSPACE Or $80000000, {clAppWorkSpace}
       COLOR_HIGHLIGHT Or $80000000, {clHighlight}
       COLOR_HIGHLIGHTTEXT Or $80000000, {clHighlightText}
       COLOR_BTNFACE Or $80000000, {clBtnFace}
       COLOR_BTNSHADOW Or $80000000, {clBtnShadow}
       COLOR_GRAYTEXT Or $80000000, {clGrayText}
       COLOR_BTNTEXT Or $80000000, {clBtnText}
       COLOR_INACTIVECAPTIONTEXT Or $80000000, {clInactiveCaptionText}
       COLOR_BTNHIGHLIGHT Or $80000000, {clBtnHighlight}
       COLOR_3DDKSHADOW Or $80000000, {cl3DDkShadow}
       COLOR_3DLIGHT Or $80000000, {cl3DLight}
       COLOR_INFOTEXT Or $80000000, {clInfoText}
       COLOR_INFOBK Or $80000000, {clInfo}
       clBlack, {clBtnDefault}
       clLtGray, {clDlgWindow}
       COLOR_WINDOW Or $80000000, {clEntryField}
       COLOR_WINDOWTEXT Or $80000000 {clStaticText}
       {$ENDIF}
    );


Function SysColorToRGB(color:TColor):TColor;
Var  Col:LongInt;
Begin
     If color < 0 Then {SPCC Portable System color}
     Begin
          Col := Color And $000000FF;
          If Col In [0..28] Then Color := SysColors[Col];

          If Color < 0 Then
          Begin
               {$IFDEF OS2}
               Result := WinQuerySysColor(HWND_DESKTOP,Color,0) {OS/2 System color -> SPCC RGB}
               {$ENDIF}
               {$IFDEF Win32}
               color := color And $000000FF;
               color := GetSysColor(Color);     {Win32 System color -> Win32 RGB}
               Result := WinColorToRGB(Color);  {SPCC RGB}
               {$ENDIF}
          End
          Else Result := Color; {normal RGB color}
     End
     Else Result := Color;
End;


{$HINTS OFF}
Function WinColorToRGB(color:TColor):TColor;Assembler;
     Asm
        //Swap Red And Blue values
        MOV AL,color     //Red Value
        MOV BL,color+2   //Blue Value
        MOV color+2,AL
        MOV color,BL
        MOV EAX,color
        CMP EAX,$00C0C0C0
        JNE !ex
        MOV EAX,$00CCCCCC
!ex:
        leave
        RETN32 4
     End;


Function RGBToWinColor(color:TColor):TColor;Assembler;
     Asm
        //Swap Red And Blue values
        MOV AL,color     //Red Value
        MOV BL,color+2   //Blue Value
        MOV color+2,AL
        MOV color,BL
        MOV EAX,color
        CMP EAX,$00CCCCCC
        JNE !ex2
        MOV EAX,$00C0C0C0
!ex2:
        leave
        RETN32 4
     End;
{$HINTS ON}


Function GetShortHint(Const Hint:String):String;
Var  I:Integer;
Begin
     I := Pos('|',Hint);
     If I = 0 Then Result := Hint
     Else Result := Copy(Hint, 1, I-1);
End;

Function GetLongHint(Const Hint:String):String;
Var  I:Integer;
Begin
     I := Pos('|',Hint);
     If I = 0 Then Result := Hint
     Else Result := Copy(Hint, I+1, MaxInt);
End;


Function Point(X,Y:LongInt):TPoint;
Begin
     Result.X := X;
     Result.Y := Y;
End;


Function Rect(Left,Bottom,Right,Top:LongInt):TRect;
Begin
     Result.Left := Left;
     Result.Bottom := Bottom;
     Result.Right := Right;
     Result.Top := Top;
End;


Function PointInRect(pt:TPoint; rec:TRect):Boolean;
Begin
     Result := False;
     If pt.X < rec.Left Then Exit;
     If pt.X > rec.Right Then Exit;
     If pt.Y < rec.Bottom Then Exit;
     If pt.Y > rec.Top Then Exit;
     Result := True;
End;


Function RectInRect(Const childrec,parentrec:TRect):Boolean;
Begin
     Result := False;
     If childrec.Left <= parentrec.Left Then Exit;
     If childrec.Right >= parentrec.Right Then Exit;
     If childrec.Bottom <= parentrec.Bottom Then Exit;
     If childrec.Top >= parentrec.Top Then Exit;
     Result := True;
End;


Procedure InflateRect(Var rec:TRect; X,Y:LongInt);
Begin
     Dec(rec.Left, X);
     Dec(rec.Bottom, Y);
     Inc(rec.Right, X);
     Inc(rec.Top, Y);
End;


Procedure OffsetRect(Var rec:TRect; X,Y:LongInt);
Begin
     Inc(rec.Left, X);
     Inc(rec.Bottom, Y);
     Inc(rec.Right, X);
     Inc(rec.Top, Y);
End;


Procedure CheckEmpty(Var rec:TRect);
Begin
     If (rec.Left > rec.Right) Or (rec.Bottom > rec.Top) Then
       FillChar(rec,SizeOf(TRect),0);
End;

{returns Rectangle that Is owned by both rectangles Or Empty rec}
Function IntersectRect(Const rec1,rec2:TRect):TRect;
Begin
     Result:=rec1;
     Asm
        MOV ESI,rec2
        MOV EDI,rec1
        MOV EBX,[EBP-4]
        CLD

        //process TRect.Left And yBottom
        LODSD
        SCASD
        JLE     !l11
        MOV [EBX].TRect.Left,EAX
!l11:
        LODSD
        SCASD
        JLE     !l12
        MOV [EBX].TRect.Bottom,EAX
!l12:
        //process TRect.Right,yBottom
        LODSD
        SCASD
        JGE     !l13
        MOV [EBX].TRect.Right,EAX
!l13:
        LODSD
        SCASD
        JGE     !l14
        MOV [EBX].TRect.Top,EAX
!l14:
        PUSH DWord Ptr [EBP-4]
        CALLN32 Forms.CheckEmpty
     End;
End;


{returns Rectangle that covers both rectangles}
Function UnionRect(Const rec1,rec2:TRect):TRect;
Begin
     Result:=rec1;
     Asm
        MOV ESI,rec2
        MOV EDI,rec1
        MOV EBX,[EBP-4]
        CLD

        //process TRect.Left,yBottom
        LODSD
        SCASD
        JGE     !l21
        MOV [EBX].TRect.Left,EAX
!l21:
        LODSD
        SCASD
        JGE     !l22
        MOV [EBX].TRect.Bottom,EAX
!l22:
        //process TRect.Right,yTop
        LODSD
        SCASD
        JLE     !l23
        MOV [EBX].TRect.Right,EAX
!l23:
        LODSD
        SCASD
        JLE     !l24
        MOV [EBX].TRect.Top,EAX
!l24:
     End;
End;


Function IsRectEmpty(Const rec:TRect):Boolean;
Begin
     Result := (rec.Left=0)And(rec.Right=0)And(rec.Bottom=0)And(rec.Top=0);
End;


Function IsControlLocked(Control:TControl):Boolean;
Var  AForm:TForm;
Begin
     Result := False;
     If Control <> Nil Then
     Begin
          AForm := Control.Form;
          If AForm Is TForm Then Result := AForm.FLocked;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Some drawing elements                                                     บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{looks like TEdit}
Procedure DrawSystemBorder(Control:TControl;Var rec:TRect;Style:TBorderStyle);
Var  rc:TRect;
     OldColor:TColor;
Begin
     If Control = Nil Then Exit;

     If Style In [bsSingle] Then
     Case Application.Platform Of
       Win32,OS2Ver40:
       Begin
            Control.Canvas.ShadowedBorder(rec,clDkGray,clWhite);
            InflateRect(rec,-1,-1);
            Control.Canvas.ShadowedBorder(rec,clBlack,clLtGray);
            InflateRect(rec,-1,-1);
       End;
       Else
       Begin
            rc := rec;
            OldColor := Control.Canvas.Pen.color;
            Control.Canvas.Pen.color := clBtnHighlight;
            Inc(rc.Left);
            Dec(rc.Top);
            Control.Canvas.Rectangle(rc);

            Control.Canvas.Pen.color := clWindowFrame;
            OffsetRect(rc,-1,1);
            Control.Canvas.Rectangle(rc);

            If Control.Parent <> Nil
            Then Control.Canvas.Pen.color := Control.Parent.color
            Else Control.Canvas.Pen.color := clBackGround;
            Control.Canvas.SetPixel(rec.Left,rec.Bottom,Control.Canvas.Pen.color);
            Control.Canvas.SetPixel(rec.Right,rec.Top,Control.Canvas.Pen.color);

            Control.Canvas.Pen.color := OldColor;
            InflateRect(rec,-1,-1);
            InflateRect(rec,-1,-1);
       End;
     End;
End;


{looks like TGroupBox}
Procedure DrawSystemFrame(Control:TControl;Var rec:TRect;LightColor,DarkColor:TColor);
Var  rc1:TRect;
Begin
     If Control = Nil Then Exit;
     rc1 := rec;
     Control.Canvas.Pen.color := LightColor;
     Inc(rc1.Left);
     Dec(rc1.Top);
     Control.Canvas.Rectangle(rc1);
     Control.Canvas.Pen.color := DarkColor;
     OffsetRect(rc1,-1,1);
     Control.Canvas.Rectangle(rc1);
     Control.Canvas.Pen.color := Control.color;
     Control.Canvas.SetPixel(rec.Left,rec.Bottom,Control.Canvas.Pen.color);
     Control.Canvas.SetPixel(rec.Right,rec.Top,Control.Canvas.Pen.color);
     InflateRect(rec,-1,-1);
     InflateRect(rec,-1,-1);
End;


Function StandardFont(Control:TControl):TFont;
Begin
     Result := Screen.DefaultFont;
     If Control.Designed Then Exit;
     If Control.ComponentState * [csWriting] <> [] Then Exit;
     If Application = Nil Then Exit;
     IF Application.Font <> Nil Then Result := Application.Font;    {small}
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TFrameControl Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

{$IFDEF OS2}
Function StartWndProc(Win:HWND;Msg,para1,para2:ULONG):ULONG;CDECL;
Begin
     Result:=WinDefWindowProc(Win,Msg,para1,para2);
End;
{$ENDIF}

{$IFDEF Win32}
Function StartWndProc(Win:HWND;Msg:ULONG;para1:WParam;para2:LParam):LRESULT;APIENTRY;
Begin
     Result:=DefWindowProc(Win,Msg,para1,para2);
End;
{$ENDIF}

{$IFDEF OS2}
Type
    PStructureArray=^TStructureArray;
    TStructureArray=Array[0..65000] Of SWP;

    TFmtFrameMessage=Record
         Message: LongWord;
         ReceiverClass: TObject;
         Receiver: HWindow;
         Handled: LongBool;  {True If the Message was Handled}
         structure: PStructureArray;
         Rect: ^RECTL;
         Count: LongWord;     {Count Of elements In structure}
    End;

    TCalcFRectMessage=Record
         Message: LongWord;
         ReceiverClass: TObject;
         Receiver: HWindow;
         Handled: LongBool;  {True If the Message was Handled}
         Rect: ^RECTL;
         Frame: LongWord;     {Frame indicator}
         Result: LongBool;    {Rect calculated indicator}
    End;
{$ENDIF}


{$IFDEF OS2}
Procedure TFrameControl.WMActivate(Var Msg:TWMActivate);
Var  Win:HWND;
     AOwner:TForm;
Begin
     // Deactivate A MDIChild Is Not Handled
     If Not Msg.Active Then Exit;

     If Not (FChild Is TForm) Then Exit;

     {
     If FChild.FLocked Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End;
     }

     If FChild.FFormStyle <> fsMDIChild Then Exit;

     Win := Msg.Receiver;
     If Msg.Active Then WinSetFocus(HWND_DESKTOP,FChild.Handle);

     If Parent = Nil Then Exit;
     AOwner := TForm(Parent);
     If Not (AOwner Is TForm) Then Exit;

     If AOwner.FTopMDIChild <> Nil
       Then AOwner.MDIDeactivate(AOwner.FTopMDIChild);

     AOwner.FTopMDIChild := FChild;

     AOwner.MDIActivate(FChild);
End;
{$ENDIF}


{$IFDEF Win32}
Procedure TFrameControl.WMClose(Var Msg:TWMClose);
Begin
     If FChild <> Nil Then FChild.Close;

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TFrameControl.WMChildActivate(Var Msg:TMessage);
Var Win:HWND;
    AOwner:TForm;
    TopChild:TForm;
Begin
     If Not (FChild Is TForm) Then Exit;
     If FChild.FFormStyle <> fsMDIChild Then Exit;

     If Parent = Nil Then Exit;
     AOwner := TForm(Parent);
     If Not (AOwner Is TForm) Then Exit;

     Win := GetTopWindow(AOwner.Handle);
     TopChild := TForm(HandleToControl(Win));    {Frame}
     If TControl(TopChild) Is TFrameControl
     Then TopChild := TFrameControl(TopChild).FChild;

     If AOwner.FTopMDIChild = TopChild Then
     Begin
          WinUser.SetFocus(Win);
          Exit;
     End;

     If AOwner.FTopMDIChild <> Nil Then
     Begin
          TopChild := AOwner.FTopMDIChild;
          SendMessage(TopChild.Frame.Handle,WM_NCACTIVATE,0,0);
          TopChild.Deactivate;

          AOwner.MDIDeactivate(TopChild);
     End;

     SendMessage(Win,WM_NCACTIVATE,1,0);
     WinUser.SetFocus(Win);
     TopChild := TForm(HandleToControl(Win));  {Frame}
     If TControl(TopChild) Is TFrameControl
     Then TopChild := TFrameControl(TopChild).FChild;
     AOwner.FTopMDIChild := TopChild;

     FChild.Activate;

     AOwner.MDIActivate(TopChild);

     Msg.Handled:=True;
     Msg.Result:=0;
End;
{$ENDIF}


{$IFDEF Win32}
Procedure TFrameControl.WMInitMenuPopup(Var Msg:TMessage);
Var  Win:LongWord;
     Menu:TMenu;
     entry:TMenuItem;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If Not (FChild Is TForm) Then Exit;

     Win := Msg.Param1;
     entry := TMenuItem(GetMenuHandleItem(FChild,Win));

     If entry Is TMenuItem Then Menu := entry.FMenu
     Else
     Begin
          Menu:=TMenu(entry);
          If Not (Menu Is TMenu) Then Menu := Nil;
          entry := Nil;
     End;
     FChild.FLastMenu := Menu;
     FChild.FLastEntry := entry;

     FChild.MenuInit(Menu,entry);
End;


Procedure TFrameControl.WMMenuSelect(Var Msg:TMessage);
Var  Win:LongWord;
     Menu:TMenu;
     entry:TMenuItem;
     AParent:TMenuItem;
     Flags:Word;
     Id:Word;
Begin
     If Not (FChild Is TForm) Then Exit;

     Id := Msg.Param1Lo;
     Flags := Msg.Param1Hi;
     Win := Msg.Param2;                          //Parent-Menu-Handle
     If (Flags = $0FFFF) And (Win = 0) Then
     Begin
          FChild.MenuEnd(FChild.FLastMenu,FChild.FLastEntry);

          Application.Hint := '';
          Exit;
     End;

     entry := TMenuItem(GetMenuHandleItem(FChild,Win));
     AParent := entry;

     If entry Is TMenuItem Then
     Begin
          Menu := entry.FMenu;
          If Menu = Nil Then Exit;
     End
     Else
     Begin
          Menu:=TMenu(entry);
          If Not (Menu Is TMenu) Then Exit;
     End;
     FChild.FLastMenu := Menu;

     If Flags And MF_POPUP = 0 Then  {Id Is Command}
     Begin
          entry := Menu.ItemFromInternalCommand(Id);
     End
     Else                            {Id Is Popup-Handle}
     Begin
          If AParent Is TMenuItem Then entry := TMenuItem(AParent.Items[Id])
          Else Exit;
     End;
     FChild.FLastEntry := entry;

     FChild.MenuItemFocus(Menu,entry);

     If entry <> Nil Then Application.Hint := GetLongHint(entry.Hint)
     Else Application.Hint := '';
End;


Procedure TFrameControl.WMMenuChar(Var Msg:TMessage);
Var  Win:LongWord;
     CH:Char;
     REP:Byte;
     Menu:TMenu;
     entry:TMenuItem;
Begin
     If Not (FChild Is TForm) Then Exit;

     Win := Msg.Param2;
     CH := Chr(Lo(Msg.Param1));
     REP := 1;
     entry := TMenuItem(GetMenuHandleItem(FChild,Win));

     If entry Is TMenuItem Then Menu := entry.FMenu
     Else
     Begin
          Menu:=TMenu(entry);
          If Not (Menu Is TMenu) Then Exit;
     End;
     entry := Menu.GetSelectedMenuItem;

     FChild.MenuCharEvent(Menu,entry,CH,REP);

     If CH = #0 Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
     End;
End;
{$ENDIF}


{$IFDEF OS2}
{wird nicht aufgerufen}
Procedure TFrameControl.WMCalcFrameRect(Var Msg:TMessage);
Var aMsg:TCalcFRectMessage Absolute Msg;
    List:TList;
    T:LongInt;
    Toolbar:TToolbar;
Begin
     DefaultHandler(Msg);  {Do Default Action}

     If aMsg.Result Then
       If aMsg.Frame<>0 Then
     Begin
          List:=FChild.FToolBarLists[tbBottom];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Inc(aMsg.Rect^.yBottom,Toolbar.Size);
          End;

          List:=FChild.FToolBarLists[tbTop];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Dec(aMsg.Rect^.yTop,Toolbar.Size);
          End;

          List:=FChild.FToolBarLists[tbLeft];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Inc(aMsg.Rect^.XLeft,Toolbar.Size);
          End;

          List:=FChild.FToolBarLists[tbRight];
          If List<>Nil Then For T:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[T]);
               If Toolbar.FVisible Then Dec(aMsg.Rect^.xRight,Toolbar.Size);
          End;
     End;
End;


Procedure TFrameControl.WMFormatFrame(Var Msg:TMessage);
Var aMsg:TFmtFrameMessage Absolute Msg;
    ClientIndex:Word;
    T:Word;
    TempSWP:SWP;
    t1:TToolbarAlign;
    ClientWin:HWND;
    List:TList;
    t2:LongInt;
    Toolbar:TToolbar;
    MaxLeft,MaxRight,MaxBottom,MaxTop:LongInt;
Begin
     DefaultHandler(Msg);  {Do Default Action}

     ClientIndex := 65535;
     // Locate SWP For client Window
     If FChild = Nil Then Exit;
     ClientWin := FChild.Handle;
     For T := 0 To aMsg.Count Do
     Begin
          If aMsg.structure^[T].HWND=ClientWin Then
          Begin
               ClientIndex:=T;
               break;
          End;
     End;
     If ClientIndex=65535 Then Exit;  {something Is wrong here}

     MaxLeft:=0;
     List:=FChild.FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
     End;

     MaxRight:=0;
     List:=FChild.FToolBarLists[tbRight];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
     End;

     MaxBottom:=0;
     List:=FChild.FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxBottom,Toolbar.Size);
     End;

     MaxTop:=0;
     List:=FChild.FToolBarLists[tbTop];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxTop,Toolbar.Size);
     End;

     {Set up TopToolBar SWP}
     //zuerst Top und Bottom !
     For t1 := High(TToolbarAlign) Downto Low(TToolbarAlign) Do
     Begin
          List:=FChild.FToolBarLists[t1];

          If List<>Nil Then For t2:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[t2]);
               If Toolbar.FVisible Then
               Begin
                    aMsg.structure^[aMsg.Count]:=aMsg.structure^[ClientIndex];
                    If t1 In [tbTop,tbBottom] Then aMsg.structure^[aMsg.Count].CY:=Toolbar.Size
                    Else aMsg.structure^[aMsg.Count].CX:=Toolbar.Size;

                    Case t1 Of
                        tbTop:
                        Begin
                             aMsg.structure^[aMsg.Count].Y:=aMsg.structure^[ClientIndex].Y+
                                                        (aMsg.structure^[ClientIndex].CY-Toolbar.SiZe);
                        End;
                        tbBottom:;
                        tbLeft:;
                        tbRight:
                        Begin
                             aMsg.structure^[aMsg.Count].X:=aMsg.structure^[ClientIndex].X+
                                                           (aMsg.structure^[ClientIndex].CX-Toolbar.Size);
                        End;
                    End; {Case}

                    aMsg.structure^[aMsg.Count].HWND:=Toolbar.Handle;

                    WinSendMsg(aMsg.structure^[aMsg.Count].HWND,
                               WM_ADJUSTWINDOWPOS,
                               LongWord(@aMsg.structure^[aMsg.Count]),
                               0);

                    Inc(aMsg.Count);

                    {Actualize client SWP}
                    Case t1 Of
                        tbTop:Dec(aMsg.structure^[ClientIndex].CY,Toolbar.Size);
                        tbLeft:
                        Begin
                             Dec(aMsg.structure^[ClientIndex].CX,Toolbar.Size);
                             Inc(aMsg.structure^[ClientIndex].X,Toolbar.Size);
                        End;
                        tbRight:Dec(aMsg.structure^[ClientIndex].CX,Toolbar.Size);
                        tbBottom:
                        Begin
                             Dec(aMsg.structure^[ClientIndex].CY,Toolbar.Size);
                             Inc(aMsg.structure^[ClientIndex].Y,Toolbar.Size);
                        End;
                    End; {Case}
               End; //If Visible
          End; //For
     End; {For}

     {Copy client To End Of List - For Speed}
     If aMsg.Count>0 Then
     Begin
          TempSWP:=aMsg.structure^[aMsg.Count-1];
          aMsg.structure^[aMsg.Count-1]:=aMsg.structure^[ClientIndex];
          aMsg.structure^[ClientIndex]:=TempSWP;
          ClientIndex:=aMsg.Count-1;
     End;

     {Set up client RECTL}
     If aMsg.Rect<>Nil Then
     Begin
          Dec(aMsg.Rect^.yTop,(aMsg.Rect^.yTop-aMsg.Rect^.yBottom)-
                               aMsg.structure^[ClientIndex].CY);
          Dec(aMsg.Rect^.xRight,(aMsg.Rect^.xRight-aMsg.Rect^.XLeft)-
                                 aMsg.structure^[ClientIndex].CX);
     End;
     Msg.Handled:=True;
End;


Procedure TFrameControl.WMQueryFrameCtlCount(Var Msg:TMessage);
Var T:TToolbarAlign;
    t1:LongInt;
    List:TList;
    Toolbar:TToolbar;
Begin
     DefaultHandler(Msg);  {Query Default Control Count In aMsg.Result}

     For T := Low(TToolbarAlign) To High(TToolbarAlign) Do
     Begin
          List:=FChild.FToolBarLists[T];
          If List<>Nil Then For t1:=0 To List.Count-1 Do
          Begin
               Toolbar:=TToolbar(List[t1]);
               If Toolbar.FVisible Then Inc(Msg.Result);
          End;
     End;
End;


Procedure TFrameControl.WMQueryTrackInfo(Var Msg:TMessage);
Var  pInfo:PTRACKINFO;
     Flags:Word;
     Bound:TRect;
     WinRect:TRect;
Begin
     If FChild = Nil Then Exit;
     pInfo := PTRACKINFO(Msg.Param2);
     Flags := Msg.Param1Lo;

     If Flags = TF_MOVE Then
     Begin
          Msg.Handled := Not FChild.Moveable;
     End
     Else
     If Flags And (TF_BOTTOM Or TF_LEFT) <> 0 Then
     Begin
          Msg.Handled := Not (FChild.Moveable And FChild.Sizeable);
     End
     Else
     If Flags And (TF_TOP Or TF_RIGHT) <> 0 Then
     Begin
          Msg.Handled := Not FChild.Sizeable;
     End;

     If Not Msg.Handled Then
     Begin
          Bound.Left := MinInt;
          Bound.Right := MaxInt;
          Bound.Bottom := MinInt;
          Bound.Top := MaxInt;

          WinRect := GetWindowRect;
          Inc(WinRect.Right);
          Inc(WinRect.Top);

          pInfo^.cxBorder := Screen.SystemMetrics(smCxSizeBorder);
          pInfo^.cyBorder := Screen.SystemMetrics(smCySizeBorder);
          pInfo^.cxGrid := 1;
          pInfo^.cyGrid := 1;
          pInfo^.cxKeyboard := 6;
          pInfo^.cyKeyboard := 16;
          pInfo^.rclTrack := RECTL(WinRect);
          pInfo^.rclBoundary := RECTL(Bound);
          pInfo^.ptlMinTrackSize := Point(FChild.FMinTrackWidth,FChild.FMinTrackHeight);
          pInfo^.ptlMaxTrackSize := Point(FChild.FMaxTrackWidth,FChild.FMaxTrackHeight);
          pInfo^.fs := Flags Or TF_ALLINBOUNDARY;

          Msg.Handled := True;
          Msg.Result := 1;
     End
     Else Msg.Result := 0;     {Disable Dragging}
End;


Procedure TFrameControl.WMMinMaxFrame(Var Msg:TMessage);
Var  pswp:^SWP;
     Flags:LongWord;
Begin
     pswp := Pointer(Msg.Param1);
     If pswp = Nil Then Exit;

     Flags := pswp^.fl And (SWP_RESTORE Or SWP_MINIMIZE Or SWP_MAXIMIZE);
     Case Flags Of
       SWP_RESTORE:
          If FChild.OnRestore <> Nil Then FChild.OnRestore(FChild);
       SWP_MINIMIZE:
          If FChild.OnMinimize <> Nil Then FChild.OnMinimize(FChild);
       SWP_MAXIMIZE:
          If FChild.OnMaximize <> Nil Then FChild.OnMaximize(FChild);
     End;
End;
{$ENDIF}


{$IFDEF Win32}
Procedure TFrameControl.WMGetMinMaxInfo(Var Msg:TMessage);
Var  pInfo:PMINMAXINFO;
Begin
     pInfo := PMINMAXINFO(Msg.Param2);

     pInfo^.ptMinTrackSize := Point(FChild.FMinTrackWidth,FChild.FMinTrackHeight);
     pInfo^.ptMaxTrackSize := Point(FChild.FMaxTrackWidth,FChild.FMaxTrackHeight);
     {Min/Max
     pInfo^.ptMaxPosition :=
     pInfo^.ptMaxSize :=}

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TFrameControl.WMSysCommand(Var Msg:TMessage); {untested}
Var  WParam,Flags:LongWord;
Begin
     WParam := Msg.Param1 And $FFF0;

     Flags := WParam;
     Case Flags Of
       SC_RESTORE:
          If FChild.OnRestore <> Nil Then FChild.OnRestore(FChild);
       SC_MINIMIZE:
          If FChild.OnMinimize <> Nil Then FChild.OnMinimize(FChild);
       SC_MAXIMIZE:
          If FChild.OnMaximize <> Nil Then FChild.OnMaximize(FChild);
     End;
End;
{$ENDIF}


Procedure TFrameControl.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FrameControl';
     FResourceModule := 0;
     FResourceId := 0;
     FWindowId := FResourceId;
     FOwnerDraw := False;
     FParentPenColor := False;
     FParentColor := False;
     Font := Screen.DefaultFrameFont;
End;


Procedure TFrameControl.SetResourceId(NewId:LongWord);
Begin
     If Handle <> 0 Then Exit;

     FResourceId := NewId;
     FWindowId := NewId; {!!}
End;


Procedure TFrameControl.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     If FChild Is TForm Then
     Begin
          {$IFDEF Win32}
          If FChild.Parent <> Nil Then Params.Style := Params.Style Or WS_CHILD;

          If Not FChild.Designed Then
            If FChild.BorderStyle = bsDialog Then
              Params.ExStyle := WS_EX_DLGMODALFRAME Or WS_EX_WINDOWEDGE;

          If not FChild.Designed Then
            If FChild.FBorderIcons*[biHelp]<>[] Then
              Params.ExStyle:=Params.ExStyle Or WS_EX_CONTEXTHELP;
          {$ENDIF}
          Params.FrameStyle := FChild.GetFrameFlags;
     End;
End;

Function GetPPFontString( Font: TFont ): string;
begin
  Result := IntToStr( Font.PointSize )
            + '.'
            + Font.Facename;
end;

Procedure TFrameControl.CreateWnd;
Var Params:TCreateParams;
    FrameFlags:ULONG;
    WindowFlags:ULONG;
    WFlags:ULONG;
    {$IFDEF Win32}
    ExtendedFlags:ULONG;
    {$ENDIF}
    cCaption:Cstring;
    ParentWin:HWND;
    OwnerWin:HWND;
    ClassData:TClassData;
    rc:TRect;
    ShellPos:Boolean;
    {$IFDEF OS2}
    fcd:FRAMECDATA;
    hSystemMenu: HWND;
    FontString: CString;
    {$ENDIF}
    {$IFDEF Win32}
    rc1:TRect;
    OldWndProc:Pointer;
    {$ENDIF}
Begin
     If Handle<>0 Then Exit;

     RegisterClass;
     GetClassData(ClassData);

     If FCaption=Nil Then cCaption:=''
     Else cCaption:=FCaption^;

     If ((FForm<>Nil)And(Not FForm.Designed)) Then
     Begin
          ShellPos := FForm.Position In [poDefault,poDefaultPosOnly,poDefaultSizeOnly];

          If (FForm.FormStyle = fsMDIChild) And (FForm.Position = poDefault)
          Then ShellPos := False;

          If FForm.Position=poScreenCenter Then
          Begin
               FLeft:=(Screen.Width-FWidth) Div 2;
               If FLeft<0 Then FLeft:=0;
               FBottom:=(Screen.Height-FHeight) Div 2;
               If FBottom<0 Then FBottom:=0;
               FForm.FLeft:=FLeft;
               FForm.FBottom:=FBottom;
          End;
     End
     Else ShellPos:=False;

     If (FWidth=0) Or (FHeight=0) Then
     Begin
          If (Parent<>Nil) And (Parent.Handle<>0) Then
          Begin
               rc:=Parent.GetClientRect;
               FWidth:=rc.Right-rc.Left+1;
               FHeight:=rc.Top-rc.Bottom+1;
               FLeft:=rc.Left;
               {$IFDEF OS2}
               FBottom:=rc.Bottom;
               {$ENDIF}
               {$IFDEF Win32}
               WinUser.GetClientRect(Parent.Handle,RECTL(rc1));
               FBottom:=((rc1.Bottom-rc1.Top)-FHeight)-rc.Bottom;
               {$ENDIF}
          End
          Else
          Begin
               ShellPos := True;
               FLeft:=0;
               FBottom:=0;
               FWidth:=0;
               FHeight:=0;
          End;
     End
     Else
     Begin
          {$IFDEF Win32}
          If Parent<>Nil Then FBottom:=Parent.FHeight-FBottom-FHeight
          Else FBottom:=Screen.Height-FBottom-FHeight;
          {$ENDIF}
     End;

     If Parent<>Nil Then
     Begin
          If Parent.Handle=0 Then ParentWin:=HWND_DESKTOP
          Else ParentWin:=Parent.Handle;
     End
     Else ParentWin:=HWND_DESKTOP;

     If     FForm.FIsModal
        And ( FForm.FModalOwner <> Nil ) Then
     Begin
          // Modal form using ShowModal2, so we
          // know the owner and can set it properly.
          OwnerWin:=FForm.FModalOwner.Handle
     End
     Else
     Begin
          OwnerWin:=ParentWin;
     End;

     CreateParams(Params);

     WindowFlags := Params.Style;
     FrameFlags := Params.FrameStyle;

     {Create Frame Window}
     {$IFDEF OS2}
     If ShellPos Then FrameFlags := FrameFlags Or FCF_SHELLPOSITION;

     fcd.cb:=SizeOf(FRAMECDATA);
     fcd.flCreateFlags:=FrameFlags;
     fcd.hModResources:=FResourceModule;
     fcd.idResources:=FResourceId;

     FHandle:=WinCreateWCWindow(ParentWin,       //Parent
                                WC_FRAME,
                                cCaption,
                                WindowFlags,     //flStyle
                                0,0,             //leave This ON 0 - Set by .Show
                                0,0,             //Position And Size
                                OwnerWin,        //Owner
                                {OwnerWin,       //Owner erst unten setzen !}
                                // WTF? - AaronL
                                HWND_TOP,        //Insert behind
                                FResourceId,     //Window Id
                                @fcd,            //CtlData
                                Nil);            //Presparams

     WinSetOwner(FHandle,OwnerWin);
     {$ENDIF}

     {$IFDEF Win32}
     If ClassData.ClassStyle * [wcsClipChildren] <> [] Then
       If Not Designed Then FrameFlags := FrameFlags Or WS_CLIPCHILDREN;

     If ClassData.ClassStyle * [wcsClipSiblings] <> []
     Then FrameFlags := FrameFlags Or WS_CLIPSIBLINGS;

     If ShellPos Then
     Begin
          If ((FForm<>Nil)And(Not FForm.Designed)) Then
          Begin
              If FForm.Position<>poDefaultSizeOnly Then
              Begin
                   FLeft := CW_USEDEFAULT;
                   FBottom := CW_USEDEFAULT;
              End;
              If FForm.Position<>poDefaultPosOnly Then
              Begin
                   FWidth := CW_USEDEFAULT;
                   FHeight := CW_USEDEFAULT;
              End;
          End
          Else
          Begin
              FLeft := CW_USEDEFAULT;
              FBottom := CW_USEDEFAULT;
              FWidth := CW_USEDEFAULT;
              FHeight := CW_USEDEFAULT;
          End;
     End;

     WindowFlags := WindowFlags Or FrameFlags;
     ExtendedFlags := Params.ExStyle;

     If ExtendedFlags=0
     Then FHandle:=CreateWindow(ClassData.ClassName,
                                cCaption,
                                WindowFlags,
                                FLeft,FBottom,
                                FWidth,FHeight,
                                OwnerWin,
                                FResourceId,
                                DllModule,
                                Nil)
     Else FHandle:=CreateWindowEx(ExtendedFlags,
                                  ClassData.ClassName,
                                  cCaption,
                                  WindowFlags,
                                  FLeft,FBottom,
                                  FWidth,FHeight,
                                  OwnerWin,
                                  FResourceId,
                                  DllModule,
                                  Nil);
     {$ENDIF}

     If FHandle=0 Then CreateError;

     {$IFDEF Win32}
     rc:=GetWindowRect;
     FLeft:=rc.Left;
     FBottom:=rc.Bottom;
     FWidth:=rc.Right-rc.Left +1;
     FHeight:=rc.Top-rc.Bottom +1;
     {$ENDIF}

     {$IFDEF OS2}
     If FForm<>Nil Then If Not FForm.Designed Then
       If FForm.Position In [poDefault,poDefaultPosOnly,poDefaultSizeOnly] Then
     Begin
          If FForm.Position In [poDefaultPosOnly,poDefaultSizeOnly] Then
          Begin
              WFlags:=SWP_ZORDER Or SWP_SHOW Or SWP_NOREDRAW;
              WinSetWindowPos(FHandle,HWND_TOP,0,0,0,0,WFlags);
          End;

          rc:=GetWindowRect;
          If FForm.Position In [poDefault,poDefaultPosOnly] Then
          Begin
               FLeft:=rc.Left;
               FBottom:=rc.Bottom;
               FForm.FLeft:=FLeft;
               FForm.FBottom:=FBottom;
          End;

          If FForm.Position In [poDefault,poDefaultSizeOnly] Then
          Begin
               FWidth:=rc.Right-rc.Left;
               FHeight:=rc.Top-rc.Bottom;
               FForm.FWidth:=FWidth;
               FForm.FHeight:=FHeight;
          End;

          If FForm.Position In [poDefaultPosOnly,poDefaultSizeOnly] Then
          Begin
              WinSetWindowPos(FHandle,HWND_TOP,FLeft,FBottom,FWidth,FHeight,SWP_SIZE Or SWP_MOVE Or
                              SWP_ZORDER Or SWP_HIDE);
          End;
     End;
     {$ENDIF}

     {FCanvas := CreateCanvas;}

     {$IFDEF OS2}
     WinSetWindowULong(Handle,QWL_USER,LongWord(Self));    {VMT Pointer}
     FDefWndProc:=Pointer(WinSubClassWindow(Handle,@SubclassedWndProc));
     {$ENDIF}
     {$IFDEF Win32}
     SetWindowLong(Handle,GWL_USERDATA,LongWord(Self));    {VMT Pointer}
     OldWndProc:=Pointer(SetWindowLong(Handle,GWL_WNDPROC,LongInt(@SubclassedWndProc)));
     If @FDefWndProc = Nil Then FDefWndProc := OldWndProc;    {WinNt !!!}
     {$ENDIF}

     FFirstShow := True;

     If (Not FEnabled) And (Not FForm.Designed) Then Disable;
     If (Not FVisible) And (Not FForm.Designed) Then Hide;

     If FFont = Nil Then FFont := StandardFont(Self);
     UpdateFont;

     // restore the system menu font, grr
     if Screen.MenuFont <> nil then
     begin
       hSystemMenu := WinWindowFromID( Handle, FID_SYSMENU );
       FontString := GetPPFontString( Screen.MenuFont );
       WinSetPresParam( hSystemMenu,
                        PP_FONTNAMESIZE,
                        Length( FontString ) + 1,
                        FontString );
     end;

     SetupShow;
     If OnSetupShow<>Nil Then OnSetupShow(Self);
End;

Procedure TFrameControl.GetClassData(Var ClassData:TClassData);
Begin
     inherited GetClassData( ClassData );

     ClassData.ClassStyle:=[wcsSizeRedraw,{wcsClipChildren,}wcsClipSiblings{,wcsSaveBits}];
End;


Function TFrameControl.GetClientRect:TRect;
Var MaxLeft,MaxBottom,MaxRight,MaxTop:LongInt;
    List:TList;
    T:LongInt;
    Toolbar:TToolbar;
Begin
     Result := Inherited GetClientRect;

     If FChild=Nil Then Exit;

     MaxLeft:=0;
     List:=FChild.FToolBarLists[tbLeft];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
     End;

     MaxRight:=0;
     List:=FChild.FToolBarLists[tbRight];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
     End;

     MaxBottom:=0;
     List:=FChild.FToolBarLists[tbBottom];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxBottom,Toolbar.Size);
     End;

     MaxTop:=0;
     List:=FChild.FToolBarLists[tbTop];
     If List<>Nil Then For T:=0 To List.Count-1 Do
     Begin
          Toolbar:=TToolbar(List[T]);
          If Toolbar.FVisible Then Inc(MaxTop,Toolbar.Size);
     End;

     Inc(Result.Left,MaxLeft);
     Inc(Result.Bottom,MaxBottom);
     Dec(Result.Right,MaxRight);
     Dec(Result.Top,MaxTop);
End;


Destructor TFrameControl.Destroy;
Begin
     Inherited Destroy;

     If FChild <> Nil Then
     Begin
          FChild.FFrame := Nil;
          FChild.Destroy;
     End;
     FChild := Nil;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TSizeBorder Class Implementation                            บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TSizeBorder.SetupComponent;
Begin
     Inherited SetupComponent;

     FZOrder := zoTop;
     ParentColor := True;
     FOwnerDraw:=True;
     FTabStop := False;
     FCursorTabStop := False;
     BorderAlign := baHorizontal;
     FSizing := False;
     Name:='SizeBorder';
     FWidth:=100;
     FHeight:=5;
     YStretch:=ysFixed;
End;


Procedure TSizeBorder.SetBorderAlign(Value:TSizeBorderAlign);
Var OldValue:TSizeBorderAlign;
Begin
     If Value = FBorderAlign Then Exit;

     OldValue:=FBorderAlign;
     FBorderAlign := Value;
     Case FBorderAlign Of
       baHorizontal:
       Begin
            If OldValue In [baVertical,baParentHeight,baLeft,baRight] Then
              FWidth:=FHeight;
            FHeight := 5;
            Align:=alNone;
            YStretch:=ysFixed;
            Visible:=True;
       End;
       baVertical:
       Begin
            If OldValue In [baHorizontal,baParentWidth,baBottom,baTop] Then
              FHeight:=FWidth;
            FWidth := 5;
            Align:=alNone;
            XStretch:=xsFixed;
            Visible:=True;
       End;
       baParentWidth:
       Begin
            FWidth := 0;
            FHeight := 5;
            FLeft:=0;
            Align:=alNone;
            XAlign:=xaLeft;
            XStretch:=xsParent;
            YStretch:=ysFixed;
            Visible:=True;
       End;
       baParentHeight:
       Begin
            FWidth := 5;
            FHeight := 0;
            FBottom:=0;
            Align:=alNone;
            YAlign:=yaBottom;
            YStretch:=ysParent;
            XStretch:=xsFixed;
            Visible:=True;
       End;
       baTop:
       Begin
            FWidth := 0;
            FHeight := 5;
            FCursor := crVSplit;
            Align := alTop;
            YStretch:=ysFixed;
            Visible := True;
       End;
       baBottom:
       Begin
            FWidth := 0;
            FHeight := 5;
            FCursor := crVSplit;
            Align := alBottom;
            YStretch:=ysFixed;
            Visible := True;
       End;
       baLeft:
       Begin
            FWidth := 5;
            FHeight := 0;
            FCursor := crHSplit;
            Align := alLeft;
            XStretch:=xsFixed;
            Visible := True;
       End;
       baRight:
       Begin
            FWidth := 5;
            FHeight := 0;
            FCursor := crHSplit;
            Align := alRight;
            XStretch:=xsFixed;
            Visible := True;
       End;
     End;
End;

{$HINTS OFF}
Procedure TSizeBorder.Redraw(Const rec:TRect);
Var  rc1:TRect;
Begin
     rc1 := ClientRect;
     Canvas.ShadowedBorder(rc1,clWhite,clBlack);
     InflateRect(rc1,-1,-1);
     Canvas.ShadowedBorder(rc1,clLtGray,clDkGray);
     InflateRect(rc1,-1,-1);
     Canvas.Pen.color := color;
     Canvas.Line(rc1.Left,rc1.Bottom,rc1.Right,rc1.Top);
End;
{$HINTS ON}


Procedure TSizeBorder.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseDown(Button,ShiftState,X,Y);

     If Parent = Nil Then Exit;

     Case FBorderAlign Of
       baLeft,baRight: FOffs := X;
       baBottom,baTop: FOffs := Y;
       Else Exit;
     End;
     FDelta := 0;

     OldFgMode := Screen.Canvas.Pen.Mode;
     OldLineWidth := Screen.Canvas.Pen.Width;
     OldLineType := Screen.Canvas.Pen.Style;

     Screen.Canvas.Pen.Mode := pmNot;
     Screen.Canvas.Pen.Width := 5;
     Screen.Canvas.Pen.Style := psSolid;

     DrawSizeLine;
     MouseCapture := True;
     FSizing := True;
End;

Procedure TSizeBorder.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseMove(ShiftState,X,Y);

     If FSizing Then
     Begin
          DrawSizeLine;
          Case FBorderAlign Of
            baLeft,baRight: FDelta := X - FOffs;
            baBottom,baTop: FDelta := Y - FOffs;
            Else Exit;
          End;
          If FOnSizing <> Nil Then FOnSizing(Self,FDelta);
          DrawSizeLine;
     End;
End;

Procedure TSizeBorder.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Begin
     Inherited MouseUp(Button,ShiftState,X,Y);

     If FSizing Then
     Begin
          DrawSizeLine;
          MouseCapture := False;
          FSizing := False;

          Screen.Canvas.Pen.Mode := OldFgMode;
          Screen.Canvas.Pen.Width := OldLineWidth;
          Screen.Canvas.Pen.Style := OldLineType;

          Case FBorderAlign Of
            baLeft,baRight: FDelta := X - FOffs;
            baBottom,baTop: FDelta := Y - FOffs;
            Else Exit;
          End;
          If FOnSized <> Nil Then FOnSized(Self,FDelta);
     End;
End;

Procedure TSizeBorder.DrawSizeLine;
Var  pt:TPoint;
Begin
     Case FBorderAlign Of
       baLeft,baRight:
       Begin
            pt.X := FDelta + 2;
            pt.Y := 0;
            pt := ClientToScreen(pt);
            Screen.Canvas.Line(pt.X,pt.Y,pt.X,pt.Y+Height);
       End;
       baBottom,baTop:
       Begin
            pt.X := 0;
            pt.Y := FDelta + 2;
            pt := ClientToScreen(pt);
            Screen.Canvas.Line(pt.X,pt.Y,pt.X+Width,pt.Y);
       End;
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TToolbar Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}


Procedure TToolbar.Hide;
Begin
     Inherited Hide;
     If (Owner Is TForm) Then TForm(Owner).AlignToolBars;
End;


Procedure TToolbar.Show;
Begin
     If Not FVisible Then
     Begin
         Inherited Show;
         If (Owner Is TForm) Then TForm(Owner).AlignToolBars;
     End
     Else Inherited Show;
End;

Procedure TToolbar.EnableCommands(Cmds:Array Of TCommand);
Var  T,t1:LongInt;
     Control:TControl;
Begin
     For T:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[T];
          If Control.FCommand<>0 Then
          Begin
               For t1:=Low(Cmds) To High(Cmds) Do
                 If Control.FCommand=Cmds[t1] Then
                 Begin
                      Control.Enabled:=True;
                      break;
                 End;
          End;
     End;
End;

Procedure TToolbar.DisableCommands(Cmds:Array Of TCommand);
Var  T,t1:LongInt;
     Control:TControl;
Begin
     For T:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[T];
          If Control.FCommand<>0 Then
          Begin
               For t1:=Low(Cmds) To High(Cmds) Do
                 If Control.FCommand=Cmds[t1] Then
                 Begin
                      Control.Enabled:=False;
                      break;
                 End;
          End;
     End;
End;

Procedure TToolbar.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='ToolBar';
     FHeight:=50;
     FWidth:=50;
     color:=clLtGray;
     FParentPenColor:=True;
     ParentColor:=False;
     CursorTabStop:=False;
     TabStop:=False;
     FAlignment:=tbTop;
     FBevelStyle:=tbRaised;
     Include(ComponentState, csAcceptsControls);
     FSizeable:=False;
     FIsToolBar:=True;
     FOrder:=-1;
     SizeBorderCtrl:=Nil;
End;


Procedure TToolbar.CreateWnd;
Begin
     SetOrder(FOrder);

     If FParent Is TForm Then FParent := FParent.FFrame;  {Frame}
     Inherited CreateWnd;
     FParent := TControl(Owner);         {Form}
End;


Procedure TToolbar.SetupShow;
Var  rc:TRect;
Begin
     rc := Parent.GetClientRect;
     Case FAlignment Of
         tbTop:
         Begin
              FLeft := 0;
              {$IFDEF OS2}
              FBottom := rc.Top-FHeight+1;
              {$ENDIF}
              {$IFDEF Win32}
              FBottom := 0;
              {$ENDIF}
              FWidth := rc.Right-rc.Left+1;
         End;
         tbBottom:
         Begin
              FLeft := 0;
              {$IFDEF OS2}
              FBottom := 0;
              {$ENDIF}
              {$IFDEF Win32}
              FBottom := rc.Top-rc.Bottom+1;
              {$ENDIF}
              FWidth := rc.Right-rc.Left+1;
         End;
         tbLeft:
         Begin
              FBottom := 0;
              FLeft := rc.Left-FWidth;
              FHeight := rc.Top-rc.Bottom+1;
         End;
         tbRight:
         Begin
              FBottom := 0;
              FLeft := rc.Right+1;
              FHeight := rc.Top-rc.Bottom+1;
         End;
     End; {Case}
End;


Procedure TToolbar.Redraw(Const rec:TRect);
Var  rc:TRect;
Begin
     If FCanvas = Nil Then Exit;
     FCanvas.FillRect(rec,color);

     If FBevelStyle <> tbNone Then
     Begin
          rc := GetClientRect;
          If FBevelStyle = tbRaised Then FCanvas.ShadowedBorder(rc,clWhite,clDkGray)
          Else FCanvas.ShadowedBorder(rc,clDkGray,clWhite);
     End;
End;


Procedure TToolbar.SetSize(NewSize:LongInt);
Begin
     If FAlignment In [tbTop,tbBottom] Then Height := NewSize
     Else Width := NewSize;
End;


Function TToolbar.GetSize:LongInt;
Begin
     If FAlignment In [tbTop,tbBottom] Then Result := Height
     Else Result := Width;
End;


Procedure TToolbar.SetAlignment(NewAlign:TToolbarAlign);
Var  Own:TForm;
     OldSize:LongInt;
     OldAlign:TToolbarAlign;
Begin
     If FAlignment = NewAlign Then Exit;

     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     OldSize := Size;
     OldAlign := FAlignment;

     {++++++++++++++++++++++}
     ListRemove(Own.FToolBarLists[FAlignment], Self);
     ListAdd(Own.FToolBarLists[NewAlign], Self);
     {Move the Toolbar To the End Of the Controls List
      To guarantee To correct SCU order}
     If ListFind(Own.FControls, Self) >= 0 Then
     Begin
          ListRemove(Own.FControls, Self);
          ListAdd(Own.FControls, Self);
     End;

     FAlignment := NewAlign;

     {Update the sizeborder}
     If SizeBorderCtrl <> Nil Then
     Case FAlignment Of
       tbLeft: SizeBorderCtrl.BorderAlign := baRight;
       tbRight: SizeBorderCtrl.BorderAlign := baLeft;
       tbTop: SizeBorderCtrl.BorderAlign := baBottom;
       tbBottom:SizeBorderCtrl.BorderAlign := baTop;
     End;

     If Handle = 0 Then Exit;

     SetWindowPos(Left,Bottom,OldSize,OldSize);
End;


Procedure TToolbar.SetOrder(Value:LongInt);
Var  Own:TForm;
     List:TList;
     AToolbar:TToolbar;
     I:LongInt;
Begin
     FOrder := Value;
     If FOrder < 0 Then Exit; {auto Append}

     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     List := Own.FToolBarLists[FAlignment];

     If ListFind(List, Self) < 0 Then Exit;  {noch nicht In der Liste}
     If List.Count = 1 Then Exit;            {nur Self In Liste}

     ListRemove(List, Self);
     If FOrder > List.Count Then FOrder := List.Count;
     ListInsert(List, FOrder, Self);

     {reorder the Own.Controls List}
     For I := 0 To List.Count-1 Do
     Begin
          AToolbar := TToolbar(List.Items[I]);
          If ListFind(Own.FControls, AToolbar) >= 0 Then
          Begin
               ListRemove(Own.FControls, AToolbar);
               ListAdd(Own.FControls, AToolbar);
          End;
     End;

     Own.AlignToolBars;
End;


Function TToolbar.GetOrder:LongInt;
Var  Own:TForm;
Begin
     Own := TForm(Owner);
     If Own Is TForm Then
     Begin
          Result := ListFind(Own.FToolBarLists[FAlignment], Self);
     End
     Else Result := -1;
End;


Procedure TToolbar.SetBevelStyle(NewStyle:TToolBarBevel);
Begin
     FBevelStyle := NewStyle;
     If Handle <> 0 Then Invalidate;
End;


Function TToolbar.GetLeft:LongInt;
Var  Own:TForm;
     List:TList;
     T:LongInt;
     Toolbar:TToolbar;
     MaxLeft,MaxRight:LongInt;
Label ex;
Begin
     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     Case Alignment Of
        tbLeft:
        Begin
             MaxLeft:=0;
             List:=Own.FToolBarLists[tbLeft];
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Inc(MaxLeft,Toolbar.Size);
             End;
             Result:=-MaxLeft;
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar=Self Then Goto ex;
                  If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
             End;
        End;
        tbRight:
        Begin
             MaxRight:=0;
             List:=Own.FToolBarLists[tbRight];
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Inc(MaxRight,Toolbar.Size);
             End;
             Result:=Own.GetClientWidth+MaxRight;
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Dec(Result,Toolbar.Size);
                  If Toolbar=Self Then Goto ex;
             End;
        End;
        tbBottom,tbTop:
        Begin
             Result:=0;
             List:=Own.FToolBarLists[tbLeft];
             If List<>Nil Then For T:=0 To List.Count-1 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Dec(Result,Toolbar.Size);
             End;
        End;
     End;
ex:
     FLeft := Result;
End;


Function TToolbar.GetBottom:LongInt;
Var  Own:TForm;
     List:TList;
     T:LongInt;
     Toolbar:TToolbar;
Label ex;
Begin
     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     Case Alignment Of
        tbLeft,tbRight:Result:=0;
        tbBottom:
        Begin
             Result:=0;
             List:=Own.FToolBarLists[tbBottom];
             If List<>Nil Then For T:=List.Count-1 Downto 0 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar.FVisible Then Dec(Result,Toolbar.Size);
                  If Toolbar=Self Then Goto ex;;
             End;
        End;
        tbTop:
        Begin
             Result := Own.GetClientHeight;

             List:=Own.FToolBarLists[tbTop];
             If List<>Nil Then For T:=List.Count-1 Downto 0 Do
             Begin
                  Toolbar:=TToolbar(List[T]);
                  If Toolbar=Self Then Goto ex;
                  If Toolbar.FVisible Then Inc(Result,Toolbar.Size);
             End;
        End;
     End;
ex:
     FBottom := Result;
End;


{$HINTS OFF}
Procedure TToolbar.SetLeft(NewLeft:LongInt);
Begin
End;

Procedure TToolbar.SetBottom(NewBottom:LongInt);
Begin
End;

Procedure TToolbar.SetTop(NewTop:LongInt);
Begin
End;

Procedure TToolbar.SetRight(NewRight:LongInt);
Begin
End;

Procedure TToolbar.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var  Own:TForm;
Begin
     Own := TForm(Owner);
     If Not (Own Is TForm) Then Exit;

     If Alignment In [tbLeft,tbRight] Then FWidth := NewWidth
     Else FHeight := NewHeight;

     If DesignerState * [dsNoRealSizing] <> [] Then Exit;
     Own.AlignToolBars;

     Resize; {because Of no WMSize}
End;
{$HINTS ON}


Procedure TToolbar.SetSizeable(Value:Boolean);
Begin
     If Value = FSizeable Then Exit;

     FSizeable := Value;
     If FSizeable Then
     Begin
          SizeBorderCtrl.Create(Self);
          Include(SizeBorderCtrl.ComponentState,csDetail);
          SizeBorderCtrl.OnSizing := EvBorderSizing;
          SizeBorderCtrl.OnSized := EvBorderSized;
          InsertControl(SizeBorderCtrl);

          Case FAlignment Of
            tbLeft: SizeBorderCtrl.BorderAlign := baRight;
            tbRight: SizeBorderCtrl.BorderAlign := baLeft;
            tbTop: SizeBorderCtrl.BorderAlign := baBottom;
            tbBottom: SizeBorderCtrl.BorderAlign := baTop;
          End;
     End
     Else
     Begin
          SizeBorderCtrl.Destroy;
          SizeBorderCtrl := Nil;
     End;
End;


{$HINTS OFF}
Procedure TToolbar.EvBorderSizing(Sender:TObject;Var SizeDelta:LongInt);
Begin
     Case FAlignment Of
       tbLeft:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientWidth Then SizeDelta := FForm.ClientWidth;
       End;
       tbBottom:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientHeight Then SizeDelta := FForm.ClientHeight;
       End;
       tbRight:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientWidth Then SizeDelta := -FForm.ClientWidth;
       End;
       tbTop:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientHeight Then SizeDelta := -FForm.ClientHeight;
       End;
     End;
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TToolbar.EvBorderSized(Sender:TObject;Var SizeDelta:LongInt);
Begin
     Case FAlignment Of
       tbLeft:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientWidth Then SizeDelta := FForm.ClientWidth;
            Size := Size + SizeDelta;
       End;
       tbBottom:
       Begin
            If Size + SizeDelta < 5 Then SizeDelta := 5 - Size;
            If SizeDelta > FForm.ClientHeight Then SizeDelta := FForm.ClientHeight;
            Size := Size + SizeDelta;
       End;
       tbRight:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientWidth Then SizeDelta := -FForm.ClientWidth;
            Size := Size - SizeDelta;
       End;
       tbTop:
       Begin
            If Size - SizeDelta < 5 Then SizeDelta := Size - 5;
            If -SizeDelta > FForm.ClientHeight Then SizeDelta := -FForm.ClientHeight;
            Size := Size - SizeDelta;
       End;
     End;
End;
{$HINTS ON}


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TControl Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure SetControlHandle(Control:TControl;Handle:HWND);
Begin
     Control.FHandle:=Handle;
End;

Procedure SetDefWndProc(Control:TControl;Proc:Pointer);
Begin
     Control.FDefWndProc:=Proc;
End;

Function TControl.ContainsControl(Control: TControl):Boolean;
Begin
    While ((Control<>Nil)And(Control<>Self)) Do Control := Control.Parent;
    Result:=Control<>Nil;
End;

Function TControl.ControlAtPos(Const Pos:TPoint;AllowDisabled:Boolean):TControl;
Var t:LongInt;
    Control:TControl;
    p:TPoint;
Begin
    Result:=Nil;
    p:=Point(Pos.X-Left,Pos.Y-Bottom);
    For t:=0 To ControlCount-1 Do
    Begin
         Control:=Controls[t];
         If ((Pos.X>=Control.Left)And(Pos.X<=Control.Right)And
             (Pos.Y>=Control.Bottom)And(Pos.Y<=Control.Top)) Then
         Begin
              If not AllowDisabled Then If Control.Enabled=False Then Continue;
              Result:=Control;
              exit;
         End;
    End;
End;

Procedure TControl.ScrollBy(DeltaX, DeltaY:LongInt);
Var t:LongInt;
    Control:TControl;
    {$IFDEF OS2}
    aswp:SWP;
    {$ENDIF}
Begin
     If Handle=0 Then exit;
     {$IFDEF OS2}
     WinScrollWindow(Handle,DeltaX,DeltaY,Nil,Nil,0,Nil,SW_SCROLLCHILDREN);
     For t:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[t];
          If Control.Handle<>0 Then
          Begin
             WinQueryWindowPos(Control.Handle,aswp);
             Control.FLeft:=aswp.x;
             Control.FBottom:=aswp.y;
             Control.Move;
          End
          Else
          Begin
             inc(Control.FLeft,DeltaX);
             inc(Control.FBottom,DeltaY);
          End;
     End;
     {$ENDIF}

     Invalidate;
End;

Procedure TControl.ScaleBy(CX,CY:LongInt);
Var t:LongInt;
Begin
     {$IFDEF OS2}
     WinEnableWindowUpdate(Handle,False);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_SETREDRAW,0,0);
     {$ENDIF}

     For t:=0 To ControlCount-1 Do Controls[t].ScaleBy(CX,CY);

     Width:=Width+CX;
     Height:=Height+CY;

     {$IFDEF OS2}
     WinEnableWindowUpdate(Handle,True);
     {$ENDIF}
     {$IFDEF Win95}
     SendMessage(Handle,WM_SETREDRAW,1,0);
     {$ENDIF}
End;

Function TControl.GetControlState:TControlState;
Begin
     Result:=FControlState;
     If ComponentState*[csReading]<>[] Then Include(Result,csReadingState);
End;

Function TControl.GetControlStyle:TControlStyle;
Begin
     Result:=FControlStyle;
     If MouseCapture Then Include(Result,csCaptureMouse);
     If Self Is TForm Then Include(Result,csFramed);
End;

Procedure TControl.SetControlState(NewValue:TControlState);
Begin
     If NewValue*[csReadingState]<>[] Then
     Begin
          Include(ComponentState,csReading);
          Exclude(NewValue,csReadingState);
     End
     Else Exclude(ComponentState,csReading);
     FControlState:=NewValue;
End;

Procedure TControl.SetControlStyle(NewValue:TControlStyle);
Begin
     If NewValue*[csCaptureMouse]<>[] Then
     Begin
          MouseCapture:=True;
          Exclude(NewValue,csCaptureMouse);
     End
     Else MouseCapture:=False;
     Exclude(NewValue,csFramed);
     FControlStyle:=NewValue;
End;

Procedure TControl.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FPopupMenu Then FPopupMenu := Nil;
End;


Procedure TControl.MapPoints(target:TControl;Var pt:Array Of TPoint);
Begin
     If ((target=Nil)Or(target.Handle=0)) Then Exit;

     {$IFDEF OS2}
     WinMapWindowPoints(Handle,target.Handle,pts[0],High(pts)+1);
     {$ENDIF}
     {$IFDEF Win32}
     {!!!!!!!!!!!!!!!!!!!11 evtl umrechnen}
     MapWindowPoints(Handle,target.Handle,pts[0],High(pts)+1);
     {$ENDIF}
End;

Procedure TControl.WMMeasureItem(Var Msg:TMessage);
Var
     Control:TControl;
     {$IFDEF OS2}
     Win:HWND;
     {$ENDIF}
     {$IFDEF Win32}
     MeasureItem:^MEASUREITEMSTRUCT;

     Function GetControlFromId(AParent:TControl;Id:LongWord):TControl;
     Var  I:LongInt;
     Begin
          If AParent <> Nil Then
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Result := AParent.Controls[I];
                 If Result.FWindowId = Id Then Exit;
                 Result := GetControlFromId(Result,Id);
                 If Result <> Nil Then Exit;
            End;
          Result := Nil;
     End;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.Param1Lo);
     If Win = 0 Then Exit;
     Control := HandleToControl(Win);
     {$ENDIF}
     {$IFDEF Win32}
     MeasureItem := Pointer(Msg.Param2);
     If MeasureItem = Nil Then Exit;
     {Win:=GetDlgItem(Handle,MeasureItem^.CtlId);
     If Win=0 Then Exit;
     Control:=HandleToControl(Win);}
     {GWL_USERDATA Is Not Set here - Search In Component List}
     Control := GetControlFromId(Self, MeasureItem^.CtlId);
     If Control = Nil Then {define Some defaults}
     Begin
          MeasureItem^.ItemHeight := 32;
          Msg.Handled := True;
          Msg.Result := 1;
          Exit;
     End;
     {$ENDIF}

     If not IsControl(Control) Then Control:=Nil;
     If Control <> Nil Then Control.ParentNotification(Msg);
End;


Procedure TControl.WMDrawItem(Var Msg:TMessage);
Var  Win:HWND;
     Control:TControl;
     {$IFDEF Win32}
     ItemStruct:^DRAWITEMSTRUCT;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.Param1Lo);
     {$ENDIF}
     {$IFDEF Win32}
     ItemStruct := Pointer(Msg.Param2);
     If ItemStruct = Nil Then Exit;
     Win := ItemStruct^.hwndItem;
     {$ENDIF}
     If Win = 0 Then Exit;
     Control := HandleToControl(Win);

     If not IsControl(Control) Then Control:=Nil;
     If Control <> Nil Then Control.ParentNotification(Msg);
End;


Procedure TControl.ParentNotification(Var Msg:TMessage);
Begin
     DefaultHandler(Msg);
End;


Procedure TControl.SetupComponent;
Begin
     Inherited SetupComponent;

     If Designed Then Exclude(ComponentState, csReference);
     Name:='Control';
     FParent:=Nil;
     FFrame:=Nil;
     FCtl3d:=True;
     FControlState:=[];
     FControlStyle:=[];
     FCaption:=Nil;
     FCursor:=crDefault;
     FOwnerDraw:=True;
     FHandlesDesignMouse:=False;
     FHandlesDesignKey:=False;
     PenColor:=clWindowText;
     color:=clWindow;
     FEnabled:=True;
     FVisible:=True;
     {$IFDEF Win32}
     FClickTime:=GetDoubleClickTime Div 2;
     {$ENDIF}
     FXAlign:=xaNone;
     FYAlign:=yaNone;
     FXStretch:=xsNone;
     FYStretch:=ysNone;
     IsFontChangeEnabled:=True;
     FFont:=StandardFont(Self);
     FHint:=Nil;
     FShowHint:=False;
     FParentShowHint:=True;
     FParentFont:=True;
     FParentPenColor:=False;
     FParentColor:=False;
     FCursorTabStop:=True;
     FTabStop:=True;
     FTabOrder:=-1;
     FZOrder:=zoTop;
     FDragMode:=dmManual;
     FDragCursor:=crDrag;
     FDragState:=dsDragEnter;
     FUpdateEnabled:=True;
     Include(ComponentState, csHandleLinks);
//     FAlwaysFocusChild:=nil;
End;


Function TControl.GetAlign:TAlign;
Begin
     If FFrame = Nil Then
     Begin
          If (FXAlign=xaLeft) And (FYAlign=yaTop) And
             (FXStretch=xsParent) And (FYStretch=ysNone) Then Result := alTop
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsParent) And (FYStretch=ysNone) Then Result := alBottom
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysParent) Then Result := alLeft
          Else
          If (FXAlign=xaRight) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysParent) Then Result := alRight
          Else
          If (FXAlign=xaParent) And (FYAlign=yaParent) And
             (FXStretch=xsParent) And (FYStretch=ysParent) Then Result := alClient
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsFrame) And (FYStretch=ysFrame) Then Result := alFrame
          Else
          If (FXAlign=xaNone) And (FYAlign=yaNone) And
             (FXStretch=xsScale) And (FYStretch=ysScale) Then Result := alScale
          Else
          If (FXAlign=xaCenter) And (FYAlign=yaCenter) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alCenter
          Else
          If (FXAlign=xaCenter) And (FYAlign=yaNone) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alCenterX
          Else
          If (FXAlign=xaNone) And (FYAlign=yaCenter) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alCenterY
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaTop) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedLeftTop
          Else
          If (FXAlign=xaLeft) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedLeftBottom
          Else
          If (FXAlign=xaRight) And (FYAlign=yaTop) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedRightTop
          Else
          If (FXAlign=xaRight) And (FYAlign=yaBottom) And
             (FXStretch=xsNone) And (FYStretch=ysNone) Then Result := alFixedRightBottom
          Else Result := alNone;
     End
     Else Result := FFrame.GetAlign;
End;


Function TControl.GetXAlign:TXAlign;
Begin
     If FFrame = Nil Then Result := FXAlign
     Else Result := FFrame.FXAlign;
End;


Function TControl.GetYAlign:TYAlign;
Begin
     If FFrame = Nil Then Result := FYAlign
     Else Result := FFrame.FYAlign;
End;


Function TControl.GetXStretch:TXStretch;
Begin
     If FFrame = Nil Then Result := FXStretch
     Else Result := FFrame.FXStretch;
End;


Function TControl.GetYStretch:TYStretch;
Begin
     If FFrame = Nil Then Result := FYStretch
     Else Result := FFrame.FYStretch;
End;


Procedure TControl.SetAlign(NewAlign:TAlign);
Var  cw,CH:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          Case NewAlign Of
            alNone:
            Begin
                 FXAlign := xaNone;
                 FYAlign := yaNone;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alLeft:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysParent;
                 FLeft := 0;
                 FBottom := 0;
            End;
            alRight:
            Begin
                 FXAlign := xaRight;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysParent;
                 FBottom := 0;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 FAutoFrame^.Right := 0;
            End;
            alBottom:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsParent;
                 FYStretch := ysNone;
                 FLeft := 0;
                 FBottom := 0;
            End;
            alTop:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaTop;
                 FXStretch := xsParent;
                 FYStretch := ysNone;
                 FLeft := 0;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 FAutoFrame^.Top := 0;
            End;
            alCenter:
            Begin
                 FXAlign := xaCenter;
                 FYAlign := yaCenter;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alCenterX:
            Begin
                 FXAlign := xaCenter;
                 FYAlign := yaNone;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alCenterY:
            Begin
                 FXAlign := xaNone;
                 FYAlign := yaCenter;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alFixedLeftTop:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaTop;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If Parent = Nil Then CH:=Screen.Height
                 Else CH := GetParentClientHeight;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
            End;
            alFixedLeftBottom:
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
            End;
            alFixedRightTop:
            Begin
                 FXAlign := xaRight;
                 FYAlign := yaTop;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If Parent = Nil Then CH:=Screen.Height
                 Else CH := GetParentClientHeight;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
                 If Parent = Nil Then cw:=Screen.Width
                 Else cw := GetParentClientWidth;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
            End;
            alFixedRightBottom:
            Begin
                 FXAlign := xaRight;
                 FYAlign := yaBottom;
                 FXStretch := xsNone;
                 FYStretch := ysNone;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If Parent = Nil Then cw:=Screen.Width
                 Else cw := GetParentClientWidth;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
            End;
            alClient:
            Begin
                 FXAlign := xaParent;
                 FYAlign := yaParent;
                 FXStretch := xsParent;
                 FYStretch := ysParent;
            End;
            alFrame: {Parent necessary}
            Begin
                 FXAlign := xaLeft;
                 FYAlign := yaBottom;
                 FXStretch := xsFrame;
                 FYStretch := ysFrame;
                 If Parent = Nil Then Exit;
                 If FAutoFrame = Nil Then New(FAutoFrame);
                 cw := GetParentClientWidth;
                 CH := GetParentClientHeight;
                 If cw <> 0 Then FAutoFrame^.Left := FLeft
                 Else FAutoFrame^.Left := 0;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
                 If CH <> 0 Then FAutoFrame^.Bottom := FBottom
                 Else FAutoFrame^.Bottom := 0;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
            End;
            alScale: {Parent necessary}
            Begin
                 FXAlign := xaNone;
                 FYAlign := yaNone;
                 FXStretch := xsScale;
                 FYStretch := ysScale;
                 If Parent = Nil Then Exit;
                 If FAutoScale = Nil Then New(FAutoScale);
                 cw := GetParentClientWidth;
                 CH := GetParentClientHeight;
                 If cw <> 0 Then FAutoScale^.Left := FLeft / cw
                 Else FAutoScale^.Left := 0;
                 If cw <> 0 Then FAutoScale^.Right := (FLeft+FWidth) / cw
                 Else FAutoScale^.Right := 1;
                 If CH <> 0 Then FAutoScale^.Bottom := FBottom / CH
                 Else FAutoScale^.Bottom := 0;
                 If CH <> 0 Then FAutoScale^.Top := (FBottom+FHeight) / CH
                 Else FAutoScale^.Top := 1;
            End;
          End;
          If Handle <> 0 Then SetWindowPos(Left,Bottom,Width,Height);
     End
     Else FFrame.SetAlign(NewAlign);
End;


Procedure TControl.SetXAlign(NewAlign:TXAlign);
Var  cw:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FXAlign := NewAlign;
          If FXAlign=xaRight Then
          Begin
               If Parent = Nil Then
               Begin
                    If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                       Then cw := Screen.Width
                    Else Exit;
               End
               Else cw := GetParentClientWidth;

               If FAutoFrame = Nil Then New(FAutoFrame);
               If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
               Else FAutoFrame^.Right := 0;
          End;
          If Handle <> 0 Then Left := Left;
     End
     Else FFrame.SetXAlign(NewAlign);
End;


Procedure TControl.SetYAlign(NewAlign:TYAlign);
Var  CH:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FYAlign := NewAlign;
          If FYAlign=yaTop Then
          Begin
               If Parent = Nil Then
               Begin
                    If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                      Then CH := Screen.Height
                    Else Exit;
               End
               Else CH := GetParentClientHeight;

               If FAutoFrame = Nil Then New(FAutoFrame);
               If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
               Else FAutoFrame^.Top := 0;
          End;
          If Handle <> 0 Then Bottom := Bottom;
     End
     Else FFrame.SetYAlign(NewAlign);
End;


Procedure TControl.SetXStretch(NewStretch:TXStretch);
Var  cw:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FXStretch := NewStretch;
          Case FXStretch Of
            xsFrame:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then cw := Screen.Width
                      Else Exit;
                 End
                 Else cw := GetParentClientWidth;

                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If cw <> 0 Then FAutoFrame^.Left := FLeft
                 Else FAutoFrame^.Left := 0;
                 If cw <> 0 Then FAutoFrame^.Right := cw - FLeft - FWidth
                 Else FAutoFrame^.Right := 0;
            End;
            xsScale:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then cw := Screen.Width
                      Else Exit;
                 End
                 Else cw := GetParentClientWidth;

                 If FAutoScale = Nil Then New(FAutoScale);
                 If cw <> 0 Then FAutoScale^.Left := FLeft / cw
                 Else FAutoScale^.Left := 0;
                 If cw <> 0 Then FAutoScale^.Right := (FLeft+FWidth) / cw
                 Else FAutoScale^.Right := 1;
            End;
          End;
          If Handle <> 0 Then Width := Width;
     End
     Else FFrame.SetXStretch(NewStretch);
End;


Procedure TControl.SetYStretch(NewStretch:TYStretch);
Var  CH:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          FYStretch := NewStretch;
          Case FYStretch Of
            ysFrame:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then CH := Screen.Height
                      Else Exit;
                 End
                 Else CH := GetParentClientHeight;

                 If FAutoFrame = Nil Then New(FAutoFrame);
                 If CH <> 0 Then FAutoFrame^.Bottom := FBottom
                 Else FAutoFrame^.Bottom := 0;
                 If CH <> 0 Then FAutoFrame^.Top := CH - FBottom - FHeight
                 Else FAutoFrame^.Top := 0;
            End;
            ysScale:
            Begin
                 If Parent = Nil Then
                 Begin
                      If ((Self Is TFrameControl) And
                        (TFrameControl(Self).Child<>Nil)And
                        (TFrameControl(Self).Child.FormStyle <> fsMDIChild))
                          Then CH := Screen.Height
                      Else Exit;
                 End
                 Else CH := GetParentClientHeight;

                 If FAutoScale = Nil Then New(FAutoScale);
                 If CH <> 0 Then FAutoScale^.Bottom := FBottom / CH
                 Else FAutoScale^.Bottom := 0;
                 If CH <> 0 Then FAutoScale^.Top := (FBottom+FHeight) / CH
                 Else FAutoScale^.Top := 1;
            End;
          End;
          If Handle <> 0 Then Height := Height;
     End
     Else FFrame.SetYStretch(NewStretch);
End;


Function TControl.GetControlCount:LongInt;
Begin
     If FControls = Nil Then Result := 0
     Else Result := FControls.Count;
End;


Function TControl.GetControl(AIndex:LongInt):TControl;
Begin
     If (FControls = Nil) Or (AIndex < 0) Or (AIndex >= FControls.Count)
     Then Result := Nil
     Else Result := FControls.Items[AIndex];
End;


Procedure TControl.SetPenColor(NewColor:TColor);
Begin
     FPenColor := NewColor;
     If ComponentState * [csReading] = [] Then FParentPenColor := False;
     {$IFDEF OS2}
     If Handle <> 0 Then SetPPForeGroundColor(NewColor);
     {$ENDIF}
     If Handle <> 0 Then Invalidate;
     NotifyControls(CM_PARENTPENCOLORCHANGED);
End;


Procedure TControl.SetColor(NewColor:TColor);
Begin
     FColor := NewColor;
     If ComponentState * [csReading] = [] Then FParentColor := False;
     {$IFDEF OS2}
     If Handle <> 0 Then SetPPBackGroundColor(NewColor);
     {$ENDIF}
     {$IFDEF Win32}
     If FCtlBrush <> 0 Then DeleteObject(FCtlBrush);

     If Not FOwnerDraw Then
     Begin
          NewColor := RGBToWinColor(SysColorToRGB(NewColor));
          FCtlBrush := CreateSolidBrush(NewColor);
     End
     Else FCtlBrush := 0;
     {$ENDIF}
     If Handle <> 0 Then Invalidate;
     NotifyControls(CM_PARENTCOLORCHANGED);
End;


{$HINTS OFF}
Procedure TControl.ParentFontChanged(Var Msg:TMessage);
Begin
     If FParentFont Then
       If FParent <> Nil Then
       Begin
            SetFont(FParent.FFont);
            FParentFont := True;
       End;
End;


Procedure TControl.ParentPenColorChanged(Var Msg:TMessage);
Begin
     If FParentPenColor Then
       If FParent <> Nil Then
       Begin
            SetPenColor(FParent.FPenColor);
            FParentPenColor := True;
       End;
End;


Procedure TControl.ParentColorChanged(Var Msg:TMessage);
Begin
     If FParentColor Then
       If FParent <> Nil Then
       Begin
            SetColor(FParent.FColor);
            FParentColor := True;
       End;
End;
{$HINTS ON}


Procedure TControl.SetParentFont(Value:Boolean);
Begin
     If FParentFont <> Value Then
     Begin
          If Value Then
            If FParent <> Nil Then Font := FParent.FFont;
          FParentFont := Value;
     End;
End;


Procedure TControl.SetParentPenColor(Value:Boolean);
Begin
     If FParentPenColor <> Value Then
     Begin
          If Value Then
            If FParent <> Nil Then PenColor := FParent.FPenColor;
          FParentPenColor := Value;
     End;
End;


Procedure TControl.SetParentColor(Value:Boolean);
Begin
     If FParentColor <> Value Then
     Begin
          If Value Then
            If FParent <> Nil Then color := FParent.FColor;
          FParentColor := Value;
     End;
End;


Procedure TControl.SetText(Const NewCaption:String);
Var  CS:Cstring;
     {$IFDEF WIN32}
     s:String;
     {$ENDIF}
Begin
     AssignStr(FCaption, NewCaption);
     If FFrame = Nil Then
     Begin
          If (Handle <> 0) And
             (IsStandardControl Or (Self Is TFrameControl)) Then
          Begin
               {$IFDEF OS2}
               If (Self Is TFrameControl) Then
               Begin
                    If NewCaption = '' Then CS := ' '
                    Else CS := NewCaption;
                    // don't replace mnemo - AaronL
               End
               Else
               Begin
                    CS := ReplaceMnemo(NewCaption);
               End;
               WinSetWindowText(Handle,CS);
               {$ENDIF}
               {$IFDEF Win32}
               If Not FOwnerDraw Then CS := ReplaceMnemo(NewCaption)
               Else CS := NewCaption;
               S:=CS;
               StrOemToAnsi(S);
               CS:=S;
               SetWindowText(Handle,CS);
               {$ENDIF}
          End;
          Perform(CM_TEXTCHANGED,0,0);
     End
     Else FFrame.SetText(NewCaption);
End;


Function TControl.GetText:String;
Var  CS:Cstring;
     len:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          If (Handle <> 0) And IsEditControl Then
          Begin
               {$IFDEF OS2}
               len := WinQueryWindowText(Handle,SizeOf(CS),CS);
               {$ENDIF}
               {$IFDEF Win32}
               len := GetWindowText(Handle,CS,SizeOf(CS));
               AnsiToOEM(CS,CS);
               {$ENDIF}
               Result := CS;
               SetLength(Result,len);
          End
          Else
          Begin
               If FCaption = Nil Then Result := ''
               Else Result := FCaption^;
          End;
     End
     Else Result := FFrame.GetText;
End;


Procedure TControl.SetZOrder(zo:TZOrder);
Begin
     If zo <> FZOrder Then
     Begin
          FZOrder := zo;
          If FZOrder <> zoNone Then
            If Handle <> 0 Then UpdateWindowPos(FLeft,FBottom,FWidth,FHeight);
     End;
End;


Procedure TControl.GetClassData(Var ClassData:TClassData);
Begin
     ClassData.StandardClass:=False;
     ClassData.ClassName:=WindowClassPrefix + ClassName;
     ClassData.WindowProc:=@StartWndProc;
     {!!!!!!!!!!!!!!!!!!!!!!!!!!}
     ClassData.ClassStyle:=[wcsSizeRedraw,{wcsClipChildren,}
                            wcsClipSiblings,wcsOwnDC{,wcsSaveBits}];
     ClassData.DataCount:=4;
     ClassData.ClassULong:=0;
End;


{$IFDEF Win32}
Procedure TControl.CreateSubClass(Var ClassData:TClassData;
                                  Const ControlClassName:Cstring);
Var  WindowClass:WNDCLASS;
Begin
     ClassData.ClassName := ControlClassName;
     ClassData.ClassStyle := ClassData.ClassStyle + [wcsSizeRedraw]
                             - [wcsOwnDC];
     ClassData.StandardClass := True;
     If @FDefWndProc = Nil Then
     Begin
          If Not WinUser.GetClassInfo(DllModule, ControlClassName, WindowClass)
          Then WinUser.GetClassInfo(0, ControlClassName, WindowClass);

          FDefWndProc := @WindowClass.lpfnWndProc; {Get original WindowProc}
     End;

     IsEditControl := ControlClassName = 'EDIT';
End;
{$ENDIF}


Procedure TControl.RegisterClass;
Var  ClassData:TClassData;
     ClassStyle:LongWord;
     {$IFDEF OS2}
     aClass:PmWin.ClassInfo;
     {$ENDIF}
     {$IFDEF Win32}
     aClass:WNDCLASS;
     {$ENDIF}
Begin
     GetClassData(ClassData);
     {$IFDEF OS2}
     IsStandardControl := ClassData.ClassULong <> 0;
     IsEditControl := ClassData.ClassULong = WC_ENTRYFIELD;
     {$ENDIF}
     {$IFDEF Win32}
     IsStandardControl := ClassData.StandardClass;  {Set In CreateSubClass}
     {$ENDIF}

     {$IFDEF OS2}
     If Not WinQueryClassInfo(AppHandle,ClassData.ClassName,aClass) Then
     Begin
          ClassStyle:=0;
          If ClassData.ClassStyle*[wcsSizeRedraw]<>[]
            Then ClassStyle:=ClassStyle Or CS_SIZEREDRAW;
          If ClassData.ClassStyle*[wcsHitTest]<>[]
            Then ClassStyle:=ClassStyle Or CS_HITTEST;
          If ClassData.ClassStyle*[wcsFrame]<>[]
            Then ClassStyle:=ClassStyle Or CS_FRAME;
          If ClassData.ClassStyle*[wcsClipChildren]<>[] Then
            If Not Designed Then ClassStyle:=ClassStyle Or CS_CLIPCHILDREN;
          If ClassData.ClassStyle*[wcsClipSiblings]<>[]
            Then ClassStyle:=ClassStyle Or CS_CLIPSIBLINGS;
          If ClassData.ClassStyle*[wcsParentClip]<>[]
            Then ClassStyle:=ClassStyle Or CS_PARENTCLIP;
          If ClassData.ClassStyle*[wcsSaveBits]<>[]
            Then ClassStyle:=ClassStyle Or CS_SAVEBITS;
          If ClassData.ClassStyle*[wcsSyncPaint]<>[]
            Then ClassStyle:=ClassStyle Or CS_SYNCPAINT;
          ClassStyle:=ClassStyle Or CS_MOVENOTIFY;

          WinRegisterClass(AppHandle,
                           ClassData.ClassName,
                           ClassData.WindowProc,
                           ClassStyle,
                           ClassData.DataCount);
     End;
     {$ENDIF}
     {$IFDEF Win32}
     If Not ClassData.StandardClass Then
       If Not WinUser.GetClassInfo(DllModule,ClassData.ClassName,aClass) Then
     Begin
          ClassStyle:=CS_DBLCLKS;
          If ClassData.ClassStyle*[wcsSizeRedraw]<>[]
            Then ClassStyle:=ClassStyle Or CS_HREDRAW Or CS_VREDRAW;
          If ClassData.ClassStyle*[wcsSaveBits]<>[]
            Then ClassStyle:=ClassStyle Or CS_SAVEBITS;
          If ClassData.ClassStyle*[wcsOwnDC]<>[]
            Then ClassStyle:=ClassStyle Or CS_OWNDC;
          //others ignored

          aClass.Style         := ClassStyle;
          aClass.lpfnWndProc   := ClassData.WindowProc;
          aClass.cbClsExtra    := ClassData.DataCount;
          aClass.cbWndExtra    := 0;
          aClass.hInstance     := DllModule;
          aClass.hIcon         := 0;
          aClass.HCursor       := LoadCursor(0,IDC_ARROW);
          aClass.hbrBackground := 0;
          aClass.lpszMenuName  := Nil;
          aClass.lpszClassName := @ClassData.ClassName;

          WinUser.RegisterClass(aClass);
     End;
     {$ENDIF}
End;


Procedure TControl.UpdateFont;
Var  {$IFDEF OS2}
     S:String;
     C:Cstring;
     {$ENDIF}
     {$IFDEF Win32}
     aFontInfo:LOGFONT;
     aFontAttr:TFontAttributes;
     {$ENDIF}
Begin
     If FFont = Nil Then Exit;
     {$IFDEF OS2}
     If FFont.FInternalPointSize<>0 Then
     Begin
          S:=tostr(FFont.FInternalPointSize)+'.';
          C:=FFont.FaceName;
     End
     Else
     Begin
          S:=tostr((FFont.FFontInfo.sNominalPointSize) Div 10)+'.';
          C:=FFont.FFontInfo.szFaceName;
     End;

     S:=S+C;
     S:=ModifyFontName(S,FFont.Attributes);
     SetPPFontNameSize(S);
     {$ENDIF}

     {$IFDEF Win32}
     If FFont.FHandle<>0 Then
     Begin
          If FDefFontHandle<>FFont.FHandle Then
          Begin
               FDefFontHandle:=FFont.FHandle;
               Inc(FFont.FRefCount);
          End;
     End
     Else
     Begin
          aFontInfo:=FFont.FFontInfo;
          aFontInfo.lfHeight:=FFont.FFontInfo.lfHeight;
          aFontInfo.lfWidth:=FFont.FFontInfo.lfWidth;
          aFontInfo.lfQuality:=DRAFT_QUALITY;
          aFontAttr:=FFont.Attributes;
          If aFontAttr*[faItalic]<>[] Then aFontInfo.lfItalic:=1
          Else aFontInfo.lfItalic:=0;
          If aFontAttr*[faUnderScore]<>[] Then aFontInfo.lfUnderline:=1
          Else aFontInfo.lfUnderline:=0;
          If aFontAttr*[faStrikeOut]<>[] Then aFontInfo.lfStrikeOut:=1
          Else aFontInfo.lfStrikeOut:=0;
          If aFontAttr*[faBold]<>[] Then aFontInfo.lfWeight:=FW_BOLD
          Else aFontInfo.lfWeight:=FW_NORMAL;
          FDefFontHandle:=CreateFontIndirect(aFontInfo);
          FFont.FHandle:=FDefFontHandle;
          FFont.FRefCount:=1;
     End;
     SendMessage(Handle,WM_SETFONT,FDefFontHandle,1);
     If IsFontChangeEnabled Then FontChange;
     {$ENDIF}
End;


Procedure TControl.SetFont(NewFont:TFont);
Begin
     If NewFont = FFont Then Exit;

     If NewFont=Nil Then NewFont:=StandardFont(Self);
     If ComponentState * [csReading] = [] Then
          // not reading the component, so setting the font
          // turns off parentfont
          FParentFont := False;

     If FParentFont Then
          Exit;

     If FFont<>NewFont Then
     Begin
          DereferenceFont(FFont);
          FFont:=NewFont;
          ReferenceFont(FFont);
     End;

     If Handle <> 0 Then
     Begin
          If FCanvas <> Nil Then
          Begin
               //FCanvas.Font := NewFont; //MIST da dies den ControlFont nicht ndert !!
               FCanvas.FFontWidth:=0;
               FCanvas.FFontHeight:=0;
               FCanvas.FFontAttr:=[];
               {!!!! der ControlFont wird verndert !!!}
               FCanvas.CreateFont(NewFont,True); //!!
          End
          Else UpdateFont;
     End;

//     If FFrame <> Nil Then FFrame.Font := NewFont;
     NotifyControls(CM_PARENTFONTCHANGED);
End;


Function TControl.GetWindowFlags:LongWord;
Begin
     Result := WS_CLIPSIBLINGS;     {Win: + WS_CHILD .?.}

     If Not Designed Then
       If Not FEnabled Then Result := Result Or WS_DISABLED;

     If ComponentState * [csAcceptsControls] <> []
     Then Result := Result Or WS_CLIPCHILDREN;

     If Designed Then Result := Result And Not WS_CLIPCHILDREN;
End;


Procedure TControl.CreateParams(Var Params:TCreateParams);
Begin
     FillChar(Params, SizeOf(Params), 0);
     Params.Style := GetWindowFlags;
End;


Function TControl.CreateCanvas:TCanvas;
Begin
     If FCanvas = Nil Then
     Begin
          FCanvas.Create(Self);
          FInitCanvas := True;
     End;
     If (Handle <> 0) And FInitCanvas Then
     Begin
          FCanvas.Init;
          FInitCanvas := False; {Init only 1 Time}
     End;
     Result := FCanvas;
End;


Procedure TControl.CreateWnd;
Var  OwnerHandle:LongWord;
     ParentHandle:LongWord;
     Params:TCreateParams;
     WindowFlags:LongWord;
     ClassData:TClassData;
     cCaption:Cstring;
     sCaption:String;
     aLeft,aBottom,aWidth,aHeight:LongInt;
     {$IFDEF Win32}
     ExtendedFlags:LongWord;
     OldWndProc:Pointer;
     rc,rc1:TRect;
     P:Integer;
     {$ENDIF}
Begin
     If Handle <> 0 Then Exit;

     FForm := GetParentForm(Self);
     If FForm <> Nil Then FForm.CreateUniqueWindowId(Self);

     FFirstShow := True;

     RegisterClass;
     GetClassData(ClassData);

     If FCaption = Nil Then sCaption := ' '
     Else sCaption := FCaption^;

     aLeft := FLeft;
     aBottom := FBottom;
     aWidth := FWidth;
     aHeight := FHeight;

     If Self Is TForm Then  {Create Frame Class}
     Begin
          If FFrame = Nil Then
          Begin
               FFrame := TFrameControl.Create(Nil);
               FFrame.SetWindowPos(aLeft,aBottom,aWidth,aHeight);
          End;
          If FCaption <> Nil Then FFrame.Caption := sCaption;     {!}
          FFrame.FParent:=FParent;
          FFrame.FForm:=TForm(Self);
          FFrame.FZOrder:=FZOrder;
          {FFrame.FFont:=FFont; wegen DBCSStatusLine}
          FFrame.SetDesigning(Designed);
          FFrame.FVisible:=FVisible;
          FFrame.FEnabled:=FEnabled;
          FFrame.FXAlign:=FXAlign;
          FFrame.FYAlign:=FYAlign;
          FFrame.FXStretch:=FXStretch;
          FFrame.FYStretch:=FYStretch;
          FYAlign:=yaNone;
          FXAlign:=xaNone;
          FXStretch:=xsNone;
          FYStretch:=ysNone;
          TFrameControl(FFrame).FChild:=TForm(Self);
          FFrame.CreateWnd;

          FWindowId:=widClient; {!!!}

          {$IFDEF OS2}
          {shrink Size Of client because Of Frame}
          Dec(aWidth,TForm(Self).GetAddWidth);
          Dec(aHeight,TForm(Self).GetAddHeight);
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.GetClientRect(FFrame.Handle,RECTL(rc1));
          rc:=FFrame.GetClientRect;
          aWidth:=rc.Right-rc.Left+1;
          aHeight:=rc.Top-rc.Bottom+1;
          aLeft:=rc.Left;
          aBottom:=((rc1.Top-rc1.Bottom)-aHeight)-rc.Bottom;
          {$ENDIF}
          ParentHandle:=FFrame.Handle;
          OwnerHandle:=ParentHandle;
     End
     Else
     Begin
          If Parent<>Nil Then ParentHandle:=Parent.Handle
          Else ParentHandle:=HWND_DESKTOP;
          OwnerHandle:=ParentHandle;
          {$IFDEF Win32}
          If Parent<>Nil Then aBottom:=Parent.FHeight-aBottom-aHeight
          Else aBottom:=Screen.Height-aBottom-aHeight;
          {$ENDIF}
     End;

     CreateParams(Params);

     WindowFlags := Params.Style;

     {$IFDEF OS2}
     {probably STD Control - replace Mnemo Char}
     If Not FOwnerDraw Then cCaption := ReplaceMnemo(sCaption)
     Else cCaption := sCaption;

     If ClassData.ClassULong<>0
     Then FHandle:=WinCreateWCWindow(ParentHandle,
                                     ClassData.ClassULong,
                                     cCaption,       //Caption
                                     WindowFlags,    //flStyle
                                     aLeft,aBottom,
                                     aWidth,aHeight, //Position And Size
                                     OwnerHandle,    //Owner
                                     HWND_TOP,       //Insert behind
                                     FWindowId,
                                     Nil,            //CtlData
                                     Nil)            //Presparams
     Else FHandle:=WinCreateWindow(ParentHandle,     //Parent
                                   ClassData.ClassName,
                                   cCaption,       //Caption
                                   WindowFlags,    //flStyle
                                   aLeft,aBottom,
                                   aWidth,aHeight, //Position And Size
                                   OwnerHandle,    //Owner
                                   HWND_TOP,       //Insert behind
                                   FWindowId,
                                   Nil,            //CtlData
                                   Nil);           //Presparams

     {$ENDIF}

     {$IFDEF Win32}
     If ParentHandle <> HWND_DESKTOP Then WindowFlags := WindowFlags Or WS_CHILD;

     ExtendedFlags := Params.ExStyle;

     {probably STD Control - replace Mnemo Char}
     If Not FOwnerDraw Then cCaption := ReplaceMnemo(sCaption)
     Else cCaption := sCaption;
     sCaption:=cCaption;
     StrOemToAnsi(sCaption);
     cCaption:=sCaption;

     If ExtendedFlags=0
     Then FHandle:=CreateWindow(ClassData.ClassName,
                                cCaption,
                                WindowFlags,
                                aLeft,aBottom,
                                aWidth,aHeight,
                                ParentHandle,
                                FWindowId,
                                DllModule,
                                Nil)
     Else FHandle:=CreateWindowEx(ExtendedFlags,
                                  ClassData.ClassName,
                                  cCaption,
                                  WindowFlags,
                                  aLeft,aBottom,
                                  aWidth,aHeight,
                                  ParentHandle,
                                  FWindowId,
                                  DllModule,
                                  Nil);
     {$ENDIF}

     If FHandle = 0 Then CreateError;

     If FFont = Nil Then FFont := StandardFont(Self);

     If FOwnerDraw Or FInitCanvas Then FCanvas := CreateCanvas;
     UpdateFont; //!! wird In Canvas.SetFont nicht mehr verndert !!

     {$IFDEF Win32}
     If Not FOwnerDraw
     Then FCtlBrush:=CreateSolidBrush(RGBToWinColor(SysColorToRGB(color)));
     {$ENDIF}

     {$IFDEF OS2}
     WinSetWindowULong(Handle,QWL_USER,LongWord(Self));    {VMT Pointer}
     FDefWndProc:=Pointer(WinSubClassWindow(Handle,@SubclassedWndProc));
     {$ENDIF}
     {$IFDEF Win32}
     SetWindowLong(Handle,GWL_USERDATA,LongWord(Self));    {VMT Pointer}
     OldWndProc:=Pointer(SetWindowLong(Handle,GWL_WNDPROC,LongInt(@SubclassedWndProc)));
     If @FDefWndProc = Nil Then FDefWndProc := OldWndProc;   {WinNt !!!}
     {$ENDIF}


     CreateControls;
     FInitControls:=False;

     If (Not FEnabled) And (Not Designed) Then Disable;
     If (Not FVisible) And (Not Designed) Then Hide;

     {$IFDEF Win32}
     rc:=GetWindowRect;
     FLeft:=rc.Left;
     FBottom:=rc.Bottom;
     FWidth:=rc.Right-rc.Left +1;
     FHeight:=rc.Top-rc.Bottom +1;
     {$ENDIF}

     SetupShow;
     If OnSetupShow<>Nil Then OnSetupShow(Self);
End;


Procedure TControl.CreateError;
Begin
     ErrorBox2(LoadNLSStr(SCouldNotCreateWindow)+'. '+LoadNLSStr(SProgramAborted)+'.');
     Halt(253);
End;


Procedure TControl.CreateControls;
Var  T:LongInt;
     Control:TControl;
Begin
     If Not FInitControls Then Exit;

     For T := 0 To ControlCount-1 Do
     Begin
          Control := Controls[T];
          If Control.ComponentState * [csReference] = [] Then
          Begin
               Control.CreateWnd;
               {$IFDEF Win32}
               If Control.FVisible Or Control.Designed Then Control.Show;
               {$ENDIF}
          End;
     End;
End;


Procedure TControl.Hide;
Var  WHandle:LongWord;
Begin
     If Not Designed Then FVisible := False;
     If Handle = 0 Then Exit;

     If FOnHide <> Nil Then FOnHide(Self);

     If FFrame <> Nil Then WHandle := FFrame.Handle
     Else WHandle := Handle;
     {$IFDEF OS2}
     WinShowWindow(WHandle,False);
     {$ENDIF}
     {$IFDEF Win32}
     ShowWindow(WHandle,SW_HIDE);
     {$ENDIF}
End;


Procedure TControl.Show;
Var  T:LongInt;
     Control:TControl;
     WHandle:LongWord;
     {$IFDEF OS2}
     Flags: ULONG;
     X,Y,W,H:longint;
     {$ENDIF}
     {$IFDEF Win32}
     TempMsg:TMessage;
     {$ENDIF}
Begin
     If Handle = 0 Then CreateWnd;
     If Handle = 0 Then Exit;

     If FOnShow <> Nil Then FOnShow(Self);

     If Not Designed Then FVisible := True;

     If FFirstShow Then
     Begin
          FFirstShow := False;

          {Show Controls}
          For T := 0 To ControlCount-1 Do
          Begin
               Control := Controls[T];
               If Control.ComponentState * [csReference] = [] Then {!}
                 If Control.FVisible Or Control.Designed Then Control.Show;
          End;

          If FFrame <> Nil Then
          Begin
               {$IFDEF Win32}
               If Parent <> Nil
               Then SendMessage(GetTopWindow(Parent.Handle),WM_NCACTIVATE,0,0);
               {$ENDIF}

               Move;
               Resize;

               {$IFDEF OS2}
               FFrame.FFirstShow := false;
//               FFrame.Show;
               FFrame.Move;
               FFrame.Resize;

               If Self Is TForm Then
               begin
                  // We may want to maximize/minimize
                  // which must be done at the same time as the show
                  // to avoid flickering
                  Flags := SWP_SHOW;
                  case TForm( self ).FWindowState of
                    wsNormal:
                      Flags := Flags or SWP_MOVE or SWP_SIZE;
                    wsMaximized:
                      Flags := Flags or SWP_MAXIMIZE;
                    wsMinimized:
                      Flags := Flags or SWP_MINIMIZE;
                  end;

                  // Remember frame restore dimensions
                  X := FFrame.FLeft;
                  Y := FFrame.FBottom;
                  W := FFrame.FWidth;
                  H := FFrame.FHeight;

                  WinSetWindowPos( FFrame.FHandle,
                                   0,  // not changing Z-order
                                   FFrame.FLeft,
                                   FFrame.FBottom,
                                   FFrame.FWidth,
                                   FFrame.FHeight,
                                   Flags );
                  if    TForm( self ).FWindowState
                     in [ wsMaximized, wsMinimized ] then
                  begin
                    // set restore position
                    WinSetWindowUShort( FFrame.FHandle, QWS_XRESTORE, X );
                    WinSetWindowUShort( FFrame.FHandle, QWS_YRESTORE, Y );
                    WinSetWindowUShort( FFrame.FHandle, QWS_CXRESTORE, W );
                    WinSetWindowUShort( FFrame.FHandle, QWS_CYRESTORE, H );
                  end;
                  // focus first tab control...
                  TForm(self).FActiveControl := GetFirstTabControl( nil, false );
                  if TForm(self).FActiveControl <> nil Then
                       TForm(self).FActiveControl.Focus;
               end;
               //WinShowWindow( Handle, True );

               {$ENDIF}

               {$IFDEF Win32}
               // doesn't do maximize/minimise yet.
               FFrame.Show;

               {$ENDIF}
               Update;
               FFrame.Update;

               {$IFDEF Win32}
               If Parent <> Nil Then SendMessage(FFrame.Handle,WM_NCACTIVATE,1,0);
               ShowWindow(Handle,SW_SHOW);
               {$ENDIF}

               Exit;
          End;

          SetWindowPos(FLeft,FBottom,FWidth,FHeight);
     End;

     If FFrame <> Nil Then WHandle := FFrame.Handle
     Else WHandle := Handle;
     {$IFDEF OS2}
     WinShowWindow(WHandle,True);
     {$ENDIF}
     {$IFDEF Win32}
     If ControlStyle*[csHintWindow]<>[] Then ShowWindow(WHandle,SW_SHOWNA)
     Else ShowWindow(WHandle,SW_SHOW);
     {$ENDIF}

     If Not (Self Is TFrameControl) Then Update;
End;


Function TControl.GetControlFromPoint(pt:TPoint):TControl;
Var  ahwnd:LongWord;
Begin
     Result := Nil;
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     ahwnd := WinWindowFromPoint(Handle,pt,True);
     {$ENDIF}
     {$IFDEF Win32}
     TransformClientPoint(pt,Self,Nil);
     ahwnd := ChildWindowFromPoint(Handle,POINTL(pt));
     {$ENDIF}
     Result := HandleToControl(ahwnd);
End;


Function TControl.GetWindowRect:TRect;
{$IFDEF OS2}
Var  aswp:SWP;
{$ENDIF}
Begin
     If (Handle = 0) {$IFDEF OS2} Or FFirstShow {$ENDIF} Then
     Begin                       {OS2: Window With 0 created}
          Result.Left := FLeft;
          Result.Bottom := FBottom;
          Result.Right := FLeft + FWidth -1;
          Result.Top := FBottom + FHeight -1;
          Exit;
     End;

     {$IFDEF OS2}
     If FFrame <> Nil Then
     Begin
          Result := FFrame.GetWindowRect;
          Exit;
     End;

     WinQueryWindowPos(Handle,aswp);
     Result.Left := aswp.X;
     Result.Right := Result.Left + aswp.CX -1;
     Result.Bottom := aswp.Y;
     Result.Top := aswp.Y + aswp.CY -1;
     {$ENDIF}

     {$IFDEF Win32}
     WinUser.GetWindowRect(Handle,RECTL(Result));
     If FParent <> Nil Then
     Begin
          MapWindowPoints(HWND_DESKTOP,FParent.Handle,
                          WinDef.Point(Result.Left),2);
     End;
     TransformRectToOS2(Result,FParent,Nil);
     Win32RectToRect(Result);
     Dec(Result.Right);
     Dec(Result.Top);
     {$ENDIF}
End;


Procedure TControl.SetWindowRect(Const rec:TRect);
Begin
     SetWindowPos(rec.Left,rec.Bottom,rec.Right-rec.Left+1,rec.Top-rec.Bottom+1);
End;


Function TControl.GetBoundsRect:TRect;
Begin
     Result.Left := Left;
     Result.Right := Left + Width -1;
     Result.Bottom := Top + Height -1;
     Result.Top := Top;
End;


Procedure TControl.SetBoundsRect(Const rec:TRect);
Begin
     SetBounds(rec.Left,rec.Top,rec.Right-rec.Left+1,rec.Bottom-rec.Top+1);
End;


Function TControl.GetClientRect:TRect;
Begin
     If (Handle = 0)
       {$IFDEF OS2}
        // Or FFirstShow // why? AaronL
        {$ENDIF} Then
     Begin                       {OS2: Window With 0 created}
          Result.Left := 0;
          Result.Bottom := 0;
          Result.Right := FWidth;
          Result.Top := FHeight;
     End
     Else
     Begin
          {$IFDEF OS2}
          WinQueryWindowRect(Handle,RECTL(Result));
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.GetClientRect(Handle,RECTL(Result));
          {$ENDIF}
     End;

     Dec(Result.Right);
     Dec(Result.Top);
End;


Function TControl.GetClientWidth:LongInt;
Var  rc:TRect;
Begin
     rc := GetClientRect;
     Result := rc.Right - rc.Left +1;
End;


Function TControl.GetClientHeight:LongInt;
Var  rc:TRect;
Begin
     rc := GetClientRect;
     Result := rc.Top - rc.Bottom +1;
End;


Procedure TControl.SetClientWidth(NewWidth:LongInt);
Begin
     Width := NewWidth;     {no border In TControl}
End;


Procedure TControl.SetClientHeight(NewHeight:LongInt);
Begin
     Height := NewHeight;   {no border In TControl}
End;


Function TControl.GetClientOrigin:TPoint;
Begin
     If IsControl(Parent) Then Result := Parent.ClientOrigin
     Else Result := Point(0,0);
     Inc(Result.X, Left);
     Inc(Result.Y, Bottom);
End;


Function TControl.GetParentClientWidth:LongInt;
Begin
     Result := 0;
     If IsControl(Parent) Then Result := Parent.ClientWidth
     Else If Self Is TFrameControl Then Result := Screen.Width
     Else If (Self Is TForm) And (TForm(Self).FormStyle <> fsMDIChild)
          Then Result := Screen.Width;
End;


Function TControl.GetParentClientHeight:LongInt;
Begin
     Result := 0;
     If IsControl(Parent) Then Result := Parent.ClientHeight
     Else If Self Is TFrameControl Then Result := Screen.Height
     Else If (Self Is TForm) And (TForm(Self).FormStyle <> fsMDIChild)
          Then Result := Screen.Height;
End;


Function TControl.ClientToScreen(Const Point:TPoint):TPoint;
Var  Origin:TPoint;
Begin
     Origin := ClientOrigin;
     Result.X := Point.X + Origin.X;
     Result.Y := Point.Y + Origin.Y;
End;


Function TControl.ScreenToClient(Const Point:TPoint):TPoint;
Var  Origin:TPoint;
Begin
     Origin := ClientOrigin;
     Result.X := Point.X - Origin.X;
     Result.Y := Point.Y - Origin.Y;
End;


Procedure TControl.WndProc(Var Msg:TMessage);
Var  OldLastMsgAdr:PMessage;
     Handled:Boolean;
Begin
     If ((Application<>Nil)And(Application.FOnMsgEvent<>Nil)) Then
     Begin
          Handled:=False;
          Application.FOnMsgEvent(Msg,Handled);
          Msg.Handled:=Msg.Handled Or Handled;
     End;

     {$IFDEF OS2}
     If Msg.Receiver<>Handle Then exit;
     {$ENDIF}

     {Store Last LastMsgAdr To Handle nested calls}
     OldLastMsgAdr := FLastMsgAdr;
     {Store the address Of the Current Msg To be able To Set Handled & Result
     Parameter In Some Methods, where This Parameter Is Not available}
     FLastMsgAdr := @Msg;

     If not Msg.Handled Then Dispatch(Msg);     {send Messages To Object}
     If Not Msg.Handled Then DefaultHandler(Msg);

     {Reset Last LastMsgAdr To Handle nested calls}
     {$IFDEF OS2}
     If Msg.Msg <> CM_RELEASE Then
       If IsControl(Self) Then FLastMsgAdr := OldLastMsgAdr;
     {$ENDIF}
     {$IFDEF WIN32}

     If Screen<>Nil Then If Screen.FCanvas.FHandle<>0 Then
     Begin
          SelectObject(Screen.FCanvas.FHandle,GetStockObject(BLACK_PEN));
          SelectObject(Screen.FCanvas.FHandle,GetStockObject(WHITE_BRUSH));
          DeleteObject(Screen.FCanvas.FPenHandle);
          Screen.FCanvas.FPenHandle:=0;
          DeleteObject(Screen.FCanvas.FBrushHandle);
          Screen.FCanvas.FBrushHandle:=0;
          DeleteDC(Screen.FCanvas.FHandle);
          Screen.FCanvas.FHandle:=0;
     End;

     If Msg.Msg <> CM_RELEASE Then
      If Msg.Msg<>WM_CLOSE Then
        If Msg.Msg<>WM_NCLBUTTONDOWN Then
          If not ((Msg.Msg=WM_SYSCOMMAND)And(Msg.Param1=SC_CLOSE)) Then
     Begin
           Try
              If IsControl(Self) Then
              Begin
                   FLastMsgAdr := OldLastMsgAdr;
                   If FCanvas<>Nil Then
                   Begin
                        If FCanvas.FPenHandle<>0 Then
                        Begin
                            If FCanvas.FHandle<>0 Then
                              SelectObject(FCanvas.FHandle,GetStockObject(BLACK_PEN));
                            DeleteObject(FCanvas.FPenHandle);
                            FCanvas.FPenHandle:=0;
                        End;
                        If FCanvas.FBrushHandle<>0 Then
                        Begin
                             If FCanvas.FHandle<>0 Then
                               SelectObject(FCanvas.FHandle,GetStockObject(WHITE_BRUSH));
                             DeleteObject(FCanvas.FBrushHandle);
                             FCanvas.FBrushHandle:=0;
                        End;
                   End;
              End;
           Except
           End;
     End;
     {$ENDIF}
End;


Function TControl.GetLastMsg:TLastMsg;
Begin
     If FLastMsg = Nil Then
     Begin
          FLastMsg.Create;
          FLastMsg.FControl := Self;
     End;
     Result := FLastMsg;
End;


Procedure TControl.RecreateWnd;
Var  SaveOnSetupShow:TNotifyEvent;
     WasVisible:Boolean;
Begin
     If Handle <> 0 Then
     Begin
          SaveOnSetupShow := FOnSetupShow;
          FOnSetupShow := Nil;              {don't call it again}

          WasVisible := Visible;
          DestroyHandle;
          CreateWnd;
          If WasVisible Then Show;

          FOnSetupShow := SaveOnSetupShow;
     End;
End;


Procedure TControl.DisposeWnd;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSubClassWindow(Handle,@FDefWndProc);
          WinSetWindowULong(Handle,QWL_USER,0);
          {$ENDIF}
          {$IFDEF Win32}
          SetWindowLong(Handle,GWL_WNDPROC,LongInt(@FDefWndProc));
          SetWindowLong(Handle,GWL_USERDATA,0);
          {$ENDIF}
     End;

     If FCanvas <> Nil Then FCanvas.Destroy;
     FCanvas := Nil;

     If Application<>Nil Then
     Begin
       If Application.FHintOwner = Self Then Application.DestroyHintWindow;

       If Application.FHintControl = Self Then
       Begin
          If Application.FHintTimer <> Nil Then Application.FHintTimer.Destroy;
          Application.FHintTimer := Nil;
          Application.FHintControl := Nil;
          Application.FHintParent := Nil;
       End;
     End;

     {$IFDEF OS2}
     DereferenceFont(FFont);
     {$ENDIF}
     {$IFDEF Win32}
     If FDefFontHandle <> 0 Then
     Begin
          If FDefFontHandle = FFont.FHandle Then
          Begin
              If FFont.FRefCount > 1 Then Dec(FFont.FRefCount)
              Else
              Begin
                   If FDefFontHandle <> 0 Then DeleteObject(FDefFontHandle);
                   FFont.FRefCount := 0;
                   FFont.FHandle := 0;
              End;
          End
          Else
          If FDefFontHandle <> 0 Then DeleteObject(FDefFontHandle);
     End;
     FDefFontHandle := 0;
     DereferenceFont(FFont);

     If FCtlBrush <> 0 Then DeleteObject(FCtlBrush);
     FCtlBrush := 0;
     {$ENDIF}
End;


Procedure TControl.DestroyWnd;
Var
     ErrorCode: ERRORID;
Begin
     AssignStr(FCaption, Caption);

//     If FFrame <> Nil Then
//     Begin
//          // destroying frame window will destroy our window as well,
//          // as an owned window
//          FFrame.DestroyWnd;
//     End
//     Else
     Begin
          // No frame - destroy ourselves if needed
          If Handle <> 0 Then
          Begin
               {$IFDEF OS2}
               if not WinDestroyWindow(Handle) then
                 ErrorCode := WinGetLastError( AppHandle )
                              and $ffff;
               {$ENDIF}
               {$IFDEF Win32}
               DestroyWindow(Handle);
               {$ENDIF}
          End;
     End;

     If FFrame <> Nil Then
          FFrame.DestroyWnd;

     FHandle := 0;

     FInitControls := True;       {For [re]CreateWnd}
     FLeft := Left;                 {Get Value from Frame}
     FBottom := Bottom;
     FWidth := Width;
     FHeight := Height;
End;


Procedure TControl.DestroyHandle;
Var  I:LongInt;
     Control:TControl;
Begin
     If FHandle = 0 Then Exit;

     Include(ControlState,csWindowDestroying);

     If Self Is TForm Then
     Begin
          Hide;
          Screen.Update;
          If DDEMan_CloseClientLinks<>Nil Then DDEMan_CloseClientLinks(TForm(Self));
     End;

     DisposeWnd;
     For I := 0 To ControlCount-1 Do     {WinControls}
     Begin
          Control := Controls[I];
          Control.DestroyHandle;
     End;
     DestroyWnd;

     Exclude(ControlState,csWindowDestroying);
End;


Destructor TControl.Destroy;
Begin
     Include(ComponentState,csDestroying);

     If FHasFocus Then
       If FForm <> Nil Then
         If FForm.ComponentState*[csDestroying]=[] Then FForm.CaptureFocus;

     {Destroys the Window}
     If Parent <> Nil Then SetParent(Nil)
     Else DestroyHandle;  {no phys. Parent -> only Destroy the Handle}

     DestroyControls; {Destroy All Child Controls}

     DisposeStr(FHint);
     FHint := Nil;

     DisposeStr(FCaption);
     FCaption := Nil;

     If FAutoScale <> Nil Then Dispose(FAutoScale);
     FAutoScale := Nil;
     If FAutoFrame <> Nil Then Dispose(FAutoFrame);
     FAutoFrame := Nil;

     If FForm Is TForm Then
       If FForm.FActiveControl = Self Then FForm.FActiveControl := Nil;
     If Screen.FActiveControl = Self Then Screen.FActiveControl := Nil;

     If FLastMsg <> Nil Then FLastMsg.Destroy;
     FLastMsg := Nil;
     If FAlternateFontName<>Nil Then DisposeStr(FAlternateFontName);
     FAlternateFontName:=Nil;

     Inherited Destroy;

     Screen.UpdateLastActive;
End;


Procedure TControl.DestroyControls;
Var  I:LongInt;
     Control:TControl;
Begin
     If FControls <> Nil Then
     Begin
          I := ControlCount;
          While I > 0 Do
          Begin
               Control := Controls[I-1];
               RemoveControl(Control);
               Control.Destroy;
               I := ControlCount;
          End;
     End;
End;


Procedure TControl.WMDestroy(Var Msg:TWMDestroy);
Begin
     DisposeWnd;

     FHandle := 0;
     Msg.Handled := True;
     Msg.Result := 0;
End;


{$IFDEF Win32}
Procedure TControl.WMNCDestroy(Var Msg:TMessage);
Begin
     FHandle := 0;
     Msg.Handled := True;
     Msg.Result := 0;
End;
{$ENDIF}


Procedure TControl.DefaultHandler(Var Msg);
Var
     pt: TPoint;
Begin
     If Handle = 0 Then Exit; {because Of Perform}
     If TMessage(Msg).ReceiverClass <> Self Then Exit; {don't call it For other handles!}
     If TMessage(Msg).Receiver <> Handle Then Exit; {don't call it For other handles!}
     {$IFDEF OS2}
     If TMessage(Msg).Msg = WM_CONTEXTMENU Then
     Begin
       // Handled here because we can't safely change the TControl interface
       // due to IDE mismatches - AaronL
       If TMessage(Msg).Param2Hi = 0 Then
       Begin
         // context menu from mouse
         pt.X := TMessage(Msg).Param1Lo;
         pt.Y := TMessage(Msg).Param1Hi;
         CheckMenuPopup( pt );
       End
       Else
       Begin
         // context menu from keyboard. Popup in middle
         pt.X := Width div 2;
         pt.Y := Height div 2;
         Screen.ActiveControl.CheckMenuPopup( pt );
       End;

     End
     else if TMessage(msg).Msg = WM_FOCUSSING Then
     Begin
       // sent when a window is about to be focussed (By .Focus)
       // by default the window itself is focussed.
       // A control can handle this to focus a particular child instead. - AaronL
       TMessage(msg).Result := 0;
       exit;
     End;
     TMessage(Msg).Result := FDefWndProc(TMessage(Msg).Receiver,
                                         TMessage(Msg).Msg,
                                         TMessage(Msg).Param1,
                                         TMessage(Msg).Param2);
     {$ENDIF}
     {$IFDEF Win32}
     TMessage(Msg).Result := CallWindowProc(@FDefWndProc,TMessage(Msg).Receiver,
                                            TMessage(Msg).Msg,
                                            TMessage(Msg).Param1,
                                            TMessage(Msg).Param2);
     {$ENDIF}
     If TMessage(Msg).Msg <> WM_COMMAND Then TMessage(Msg).Handled := True; {!!}
End;


Procedure TControl.RealignControls;
Var  Control:TControl;
     T:LongInt;
Begin
     {Align Controls again}
     For T := 0 To ControlCount-1 Do
     Begin
          Control := Controls[T];
          {$IFDEF OS2}
          If (Control.XAlign In [xaParent,xaLeft,xaRight,xaCenter]) Or
             (Control.YAlign In [yaParent,yaBottom,yaTop,yaCenter]) Or
             (Control.XStretch In [xsParent,xsFrame,xsScale]) Or
             (Control.YStretch In [ysParent,ysFrame,ysScale]) Or
             (Control.FIsToolBar) Then
          Begin
               Control.SetWindowPos(Control.Left,Control.Bottom,
                                    Control.Width,Control.Height);
          End;
          {$ENDIF}
          {$IFDEF WIN32}
          Control.SetWindowPos(Control.Left,Control.Bottom,
                               Control.Width,Control.Height);
          {$ENDIF}
     End;
End;


Procedure TControl.SetLeft(NewLeft:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FLeft := NewLeft
          Else SetWindowPos(NewLeft,Bottom,Width,Height);
     End
     Else FFrame.SetLeft(NewLeft);
End;


Function TControl.GetLeft:LongInt;
Begin
     If FFrame = Nil Then Result := FLeft
     Else Result := FFrame.GetLeft;
End;


Procedure TControl.SetBottom(NewBottom:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FBottom := NewBottom
          Else SetWindowPos(Left,NewBottom,Width,Height);
     End
     Else FFrame.SetBottom(NewBottom);
End;


Function TControl.GetBottom:LongInt;
Begin
     If FFrame = Nil Then Result := FBottom
     Else Result := FFrame.GetBottom;
End;


Procedure TControl.SetWidth(NewWidth:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FWidth := NewWidth
          Else SetWindowPos(Left,Bottom,NewWidth,Height);
     End
     Else FFrame.SetWidth(NewWidth);
End;


Function TControl.GetWidth:LongInt;
Begin
     If FFrame = Nil Then Result := FWidth
     Else Result := FFrame.GetWidth;
End;


Procedure TControl.SetHeight(NewHeight:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          If csReading In ComponentState Then FHeight := NewHeight
          Else SetWindowPos(Left,Bottom,Width,NewHeight);
     End
     Else FFrame.SetHeight(NewHeight);
End;


Function TControl.GetHeight:LongInt;
Begin
     If FFrame = Nil Then Result := FHeight
     Else Result := FFrame.GetHeight;
End;


Procedure TControl.SetRight(NewRight:LongInt);
Var  _Width:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          _Width := GetParentClientWidth;
          SetWindowPos(_Width-Width-NewRight,Bottom,Width,Height);
     End
     Else FFrame.SetRight(NewRight);
End;


Function TControl.GetRight:LongInt;
Var  _Width:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          _Width := GetParentClientWidth;
          Result := _Width - FLeft - FWidth;
     End
     Else Result := FFrame.GetRight;
End;


Procedure TControl.SetTop(NewTop:LongInt);
Begin
     If FFrame = Nil Then
     Begin
          SetBounds(Left,NewTop,Width,Height);
     End
     Else FFrame.SetTop(NewTop);
End;


Function TControl.GetTop:LongInt;
Var  _Height:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          _Height := GetParentClientHeight;
          Result := _Height - FBottom - FHeight;
     End
     Else Result := FFrame.GetTop;
End;


Procedure TControl.SetBounds(NewLeft,NewTop,NewWidth,NewHeight:LongInt);
Var  NewBottom:LongInt;
Begin
     If FFrame = Nil Then
     Begin
          NewBottom := GetParentClientHeight - NewHeight - NewTop;
          SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight);
     End
     Else FFrame.SetBounds(NewLeft,NewTop,NewWidth,NewHeight);
End;


Procedure TControl.SetWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var  rc:TRect;
     cw,CH:LongInt;
     oldwidth,oldheight:LongInt;
Begin
     oldwidth := FWidth;
     oldheight := FHeight;

     Case FXStretch Of
       xsParent:
       Begin
            NewWidth := GetParentClientWidth;
       End;
       xsFrame:
       Begin {only relevant from A Parent WMSize call}
            If FAutoFrame <> Nil Then
            Begin
                 NewLeft := FAutoFrame^.Left;
                 NewWidth := GetParentClientWidth
                             - FAutoFrame^.Right - NewLeft;
            End;
       End;
       xsScale:
       Begin {only relevant from A Parent WMSize call}
            If FAutoScale <> Nil Then
            Begin
                 cw := GetParentClientWidth;
                 NewLeft := FAutoScale^.Left * cw;
                 NewWidth := FAutoScale^.Right * cw - NewLeft;
            End;
       End;
       xsFixed:
       Begin
            If Handle <> 0 Then NewWidth := Width;
       End;
     End;

     Case FYStretch Of
       ysParent:
       Begin
            NewHeight := GetParentClientHeight;
       End;
       ysFrame:
       Begin {only relevant from A Parent WMSize call}
            If FAutoFrame <> Nil Then
            Begin
                 NewBottom := FAutoFrame^.Bottom;
                 NewHeight := GetParentClientHeight
                              - FAutoFrame^.Top - NewBottom;
            End;
       End;
       ysScale:
       Begin {only relevant from A Parent WMSize call}
            If FAutoScale <> Nil Then
            Begin
                 CH := GetParentClientHeight;
                 NewBottom := FAutoScale^.Bottom * CH;
                 NewHeight := FAutoScale^.Top * CH - NewBottom;
            End;
       End;
       ysFixed:
       Begin
            If Handle <> 0 Then NewHeight := Height;
       End;
     End;

     Case FXAlign Of
       xaParent:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.ClientRect;
                 NewLeft := rc.Left;
            End
            Else NewLeft := 0;
       End;
       xaLeft:
       Begin
            NewLeft := Left;
       End;
       xaRight:
       Begin
            If FAutoFrame <> Nil Then
            Begin
                 cw := GetParentClientWidth;
                 NewLeft := cw - FAutoFrame^.Right - NewWidth;
            End;
       End;
       xaCenter:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.GetClientRect;
                 NewLeft := rc.Left+(rc.Right+1-rc.Left-NewWidth) Div 2;
            End
            Else NewLeft := (Screen.Width-NewWidth) Div 2;
       End;
     End;

     Case FYAlign Of
       yaParent:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.ClientRect;
                 NewBottom := rc.Bottom;
            End
            Else NewBottom := 0;
       End;
       yaBottom:
       Begin
            NewBottom := Bottom;
       End;
       yaTop:
       Begin
            If FAutoFrame <> Nil Then
            Begin
                 CH := GetParentClientHeight;
                 NewBottom := CH - FAutoFrame^.Top - NewHeight;
            End;
       End;
       yaCenter:
       Begin
            If Parent <> Nil Then
            Begin
                 rc := Parent.GetClientRect;
                 NewBottom := rc.Bottom+(rc.Top+1-rc.Bottom-NewHeight) Div 2;
            End
            Else NewBottom := (Screen.Height-NewHeight) Div 2;
       End;
     End;

     FLeft := NewLeft;
     FBottom := NewBottom;
     FWidth := NewWidth;
     FHeight := NewHeight;

     If DesignerState * [dsNoRealSizing] <> [] Then Exit;

     If Handle <> 0 Then UpdateWindowPos(FLeft,FBottom,FWidth,FHeight);

     If Not (Self Is TForm) Then
     Begin
          If IsStandardControl Then
            If (oldwidth <> FWidth) Or (oldheight <> FHeight) Or Designed
            Then Resize; {because Of no WMSize}
     End;


     If Parent Is TScrollingWinControl Then
     Begin
          TScrollingwinControl(Parent).AdjustScrollbars;
          TScrollingwinControl(Parent).AlignScrollbars;
     End;
End;


{assume the Parameters are Dialog coordinates, transform it}
{Test only}
Procedure TransformToDialog(Var Left,Bottom,Width,Height:LongInt);
Var  DLGAspectX,DLGAspectY:Extended;
     CX:LongInt;
Begin
     CX := Screen.SystemMetrics(smCxScreen);

     If (CX = 640) Or (CX = 800) Then
     Begin
          {640x480 & 800x600}
          DLGAspectX := 1.5;
          DLGAspectY := 2;
     End
     Else
     Begin
          {1024x768 & 1280x1024}
          DLGAspectX := 2;
          DLGAspectY := 2.5;
     End;

     Left := Left * DLGAspectX;
     Bottom := Bottom * DLGAspectY;
     Width := Width * DLGAspectX;
     Height := Height * DLGAspectY;
End;


Procedure TControl.UpdateWindowPos(NewLeft,NewBottom,NewWidth,NewHeight:LongInt);
Var  Flags:LongInt;
     ZWin:HWND;
     {$IFDEF Win32}
     rc,rc1:TRect;
     NewTop:LongInt;
     {$ENDIF}
Begin
     ZWin := 0;
     Flags := 0;
(* Change
     If FForm Is TForm Then
       If FForm.FInternalId = iiDialog
       Then TransformToDialog(_Left,_Bottom,_Width,_Height);
*)
     {$IFDEF OS2}
     If Visible Then Flags := Flags Or SWP_SHOW;
     {Show flag nur setzen, wenn das Fenster schon sichtbar ist}
     Case FZOrder Of
       zoBottom: ZWin := HWND_BOTTOM;
       zoTop:    ZWin := HWND_TOP;
     End;
     If FZOrder <> zoNone Then Flags := Flags Or SWP_ZORDER;

     Flags := Flags Or SWP_SIZE Or SWP_MOVE;

     WinSetWindowPos(Handle,ZWin,NewLeft,NewBottom,NewWidth,NewHeight,Flags);
     {$ENDIF}

     {$IFDEF Win32}
     If Parent <> Nil Then
     Begin
          NewTop := Parent.FHeight - FBottom - FHeight;
          If Parent Is TFrameControl Then
          Begin
               // the origin of the frame is equal to the client origin of the form
               Dec(NewTop, Screen.SystemMetrics(smCyTitlebar));
               Dec(NewTop, GetBorderHeight(FForm));
               Dec(NewLeft, GetBorderWidth(FForm));
               {???}
               Dec(NewTop, GetBorderHeight(FForm));
          End;
     End
     Else NewTop := Screen.Height - FBottom - FHeight;
     If ControlStyle*[csHintWindow]<>[] Then Flags:=Flags Or SWP_NOACTIVATE;
     If Visible Then Flags := Flags Or SWP_SHOWWINDOW;

     Case FZOrder Of
       zoNone:   Flags := Flags Or SWP_NOZORDER;
       zoBottom: ZWin := HWND_BOTTOM;
       zoTop:    ZWin := HWND_TOP;
     End;

     WinUser.SetWindowPos(Handle,ZWin,NewLeft,NewTop,NewWidth,NewHeight,Flags);

     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil Then
     Begin
          WinUser.GetClientRect(Handle,RECTL(rc1));
          rc := GetClientRect;
          NewWidth := rc.Right-rc.Left +1;
          NewHeight := rc.Top-rc.Bottom +1;
          NewLeft := rc.Left;
          NewTop := ((rc1.Top-rc1.Bottom)-NewHeight)-rc.Bottom;
          Flags := 0;
          ZWin := 0;
          If TFrameControl(Self).FChild.Visible
          Then Flags := Flags Or SWP_SHOWWINDOW;
          Case FZOrder Of
            zoNone:   Flags := Flags Or SWP_NOZORDER;
            zoBottom: ZWin := HWND_BOTTOM;
            zoTop:    ZWin := HWND_TOP;
          End;

          WinUser.SetWindowPos(TFrameControl(Self).FChild.Handle,ZWin,
                               NewLeft,NewTop,NewWidth,NewHeight, Flags);
     End;
     {$ENDIF}
End;


Procedure TControl.SetupShow;
Begin
     {$IFDEF OS2}
     SetPPForeGroundColor(FPenColor);
     SetPPBackGroundColor(FColor);
     {$ENDIF}
End;


Procedure TControl.BringToFront;
Var  Win:LongWord;
     Flags:LongWord;
Begin
     If IsControlLocked(Self) Then Exit;

     If FFrame <> Nil Then Win := FFrame.Handle
     Else Win := Handle;
     {$IFDEF OS2}
     If Visible Then Flags := SWP_SHOW
     Else Flags := 0;
     WinSetWindowPos(Win,HWND_TOP,0,0,0,0,
                     Flags Or SWP_ZORDER {Or SWP_ACTIVATE});
     {$ENDIF}
     {$IFDEF Win32}
     If Visible Then Flags := SWP_SHOWWINDOW
     Else Flags := 0;
     WinUser.SetWindowPos(Win,HWND_TOP,0,0,0,0,
                          Flags Or SWP_NOMOVE Or SWP_NOSIZE);
     {$ENDIF}
End;


Procedure TControl.SendToBack;
Var  Win:LongWord;
     Flags:LongWord;
Begin
     If IsControlLocked(Self) Then Exit;

     If FFrame <> Nil Then Win := FFrame.Handle
     Else Win := Handle;
     {$IFDEF OS2}
     If Visible Then Flags := SWP_SHOW
     Else Flags := 0;
     WinSetWindowPos(Win,HWND_BOTTOM,0,0,0,0,
                     Flags Or SWP_ZORDER {Or SWP_ACTIVATE});
     {$ENDIF}
     {$IFDEF Win32}
     If Visible Then Flags := SWP_SHOWWINDOW
     Else Flags := 0;
     WinUser.SetWindowPos(Win,HWND_BOTTOM,0,0,0,0,
                          Flags Or SWP_NOMOVE Or SWP_NOSIZE);
     {$ENDIF}
End;


Procedure TControl.KillFocus;
Begin
     FHasFocus := False;
     If OnExit <> Nil Then OnExit(Self);
End;


Procedure TControl.SetFocus;
Var
     F: TForm;
Begin
     F := FForm;
     While F <> nil Do
     Begin
          F.FActiveControl := self;
          // up to next form
          If F.FParent <> nil Then
               F := F.FParent.FForm
          Else
               F := nil;
     End;

     Screen.FActiveControl := Self;

     FHasFocus := True;
     If OnEnter <> Nil Then OnEnter(Self);

     Screen.UpdateLastActive;
End;


{$IFDEF Win32}
Procedure TControl.WMKillFocus(Var Msg:TMessage);
Begin
     If IsStandardControl Then DefaultHandler(Msg);

     If Not Designed Or (Self Is TForm) Then Msg.Handled := True;

     If Application <> Nil Then Application.FHasFocus := FALSE;

     KillFocus;

     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          TFrameControl(Self).FChild.KillFocus;
     End;
End;


Procedure TControl.WMSetFocus(Var Msg:TWMSetFocus);
Begin
     If IsStandardControl Then DefaultHandler(Msg);

     If (Not Designed) Or (Self Is TForm) Then Msg.Handled := True;

     If Application <> Nil Then Application.FHasFocus := TRUE;

     SetFocus;

     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          TFrameControl(Self).FChild.SetFocus;
     End;
End;
{$ENDIF}


{$IFDEF OS2}
Procedure TControl.WMSetFocus(Var Msg:TWMSetFocus);
Begin
     If IsStandardControl Then DefaultHandler(TMessage(Msg));

     If Msg.Focus=False Then {Window Is loosing Focus}
     Begin
          If Application <> Nil Then Application.FHasFocus := FALSE;

          KillFocus;

          If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
          Begin
               TFrameControl(Self).FChild.KillFocus;
          End;
     End
     Else  {Window Is getting Focus}
     Begin
          If Application <> Nil Then Application.FHasFocus := TRUE;

          SetFocus;

          If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
          Begin
               TFrameControl(Self).FChild.SetFocus;
          End;
     End;
     Msg.Handled := True;
End;
{$ENDIF}


Procedure TControl.Paint(Const rec:TRect);
Begin
     If FCanvas<>Nil Then FCanvas.ClipRect := rec;
     If OnBeforePaint<>Nil Then OnBeforePaint(Self,rec);

     If OnPaint <> Nil Then OnPaint(Self,rec)
     Else Redraw(rec);

     If OnAfterPaint<>Nil Then OnAfterPaint(Self,rec);
     If FCanvas<>Nil Then If FCanvas.ClipRect = rec Then FCanvas.DeleteClipRegion;
End;


Procedure TControl.SetUpdateEnabled(Value:Boolean);
Begin
     FUpdateEnabled := Value;
     If Handle = 0 Then Exit;
     If FUpdateEnabled Then
     Begin
          {$IFDEF OS2}
          WinLockWindowUpdate(HWND_DESKTOP,0);
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.LockWindowUpdate(0);
          {$ENDIF}
          Invalidate;
     End
     Else
     Begin
          {$IFDEF OS2}
          WinLockWindowUpdate(HWND_DESKTOP,Handle);
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.LockWindowUpdate(Handle);
          {$ENDIF}
     End;
End;


Function TControl.GetDesignerCoordinates(Var pt:TPoint):TControl;
Begin
     Result := Self;
     While (Result.Designed) And (Result.Parent <> Nil) Do
     Begin
          Inc(pt.X, Result.Left);
          Inc(pt.Y, Result.Bottom);
          Result := Result.Parent;
     End;
End;


Procedure TControl.DesignerNotification(Var DNS:TDesignerNotifyStruct);
Var  AForm:TForm;
Begin
     AForm := TForm(Parent);
     If AForm <> Nil Then
     Begin
          While (AForm.Designed) And (AForm.Parent <> Nil) Do
          Begin
               AForm := TForm(AForm.Parent);
          End;
     End;
     If AForm <> Nil Then AForm.DesignerNotification(DNS);
End;


Procedure TControl.WMPaint(Var Msg:TMessage);
Var  rec:TRect;
     relpt:TPoint;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     {$IFDEF OS2}
     FHPS:HPS;
     {$ENDIF}
     {$IFDEF Win32}
     FPS:PAINTSTRUCT;
     {$ENDIF}
Begin
     If Not IsWindowVisible Then Exit;

     If FOwnerDraw Then
       If FCanvas = Nil Then Exit;

     If Not FUpdateEnabled Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End;

     If FOwnerDraw Then
     Begin
          {$IFDEF OS2}
          FHPS := WinBeginPaint(Handle,0,RECTL(rec));
          {$ENDIF}
          {$IFDEF Win32}
          BeginPaint(Msg.Receiver,FPS);
          rec := TRect(FPS.rcPaint);
          rec:=ClientRect;
          Win32RectToRect(rec);
          TransformRectToOS2(rec,Self,Nil);   {TransformClientRect?}
          Dec(rec.Bottom);
          Inc(rec.Top);
          {$ENDIF}

          If (rec.Top > rec.Bottom) Or (rec.Right > rec.Left) Then
          Begin
               Paint(rec);
               {$IFDEF Win32}
               FCanvas.DeleteClipRegion; {because FPS.rcPaint will be clipped}
               {$ENDIF}
          End;

          {$IFDEF OS2}
          WinEndPaint(FHPS);
          {$ENDIF}
          {$IFDEF Win32}
          EndPaint(Msg.Receiver,FPS);
          {$ENDIF}
     End
     Else
     Begin
          DefaultHandler(Msg);       {Do Default Action}
          rec := TControl.GetClientRect;
     End;

     If Designed Then
     Begin
          relpt.X := 0;
          relpt.Y := 0;
          Control := GetDesignerCoordinates(relpt);
          If Control <> Nil Then
          Begin
               Inc(rec.Left,relpt.X);
               Inc(rec.Right,relpt.X);
               Inc(rec.Bottom,relpt.Y);
               Inc(rec.Top,relpt.Y);

               DNS.Sender := Self;
               DNS.Code := dncPaint;
               DNS.return := 0;
               DNS.rec := rec;
               Control.DesignerNotification(DNS);
          End;
     End;

     Msg.Handled := True;
     Msg.Result := 0;
End;


Procedure TControl.SetPopupMenu(NewMenu:TPopupMenu);
Begin
     If NewMenu=FPopupMenu Then Exit;

     If FPopupMenu<>Nil Then FPopupMenu.Notification(Self,opRemove);
     FPopupMenu := NewMenu;
     If FPopupMenu <> Nil Then FPopupMenu.FreeNotification(Self);
End;


Procedure TControl.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  Control:TControl;
Begin
     If FForm <> Nil Then FForm.BringToFront;
     If Button=mbLeft Then Include(ControlState,csLButtonDown);

     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseDown = Nil) And
             (Control.ComponentState * [csDetail] <> []) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then Exit;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control.FOnMouseDown <> Nil
     Then Control.FOnMouseDown(Control,Button,ShiftState,X,Y);
End;


Procedure TControl.MouseUp(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInT);
Var  Control:TControl;
Begin
{
     // Now done by handling WM_CONTEXTMENU
     If Button = mbRight Then
       If Not Designed Then
         If [ ssLeft, ssMiddle ] * ShiftState = [] then
           // only do popup if other buttons not pressed. AaronL
           CheckMenuPopup(Point(X,Y));
}

     Control := Self;
     If Button=mbLeft Then
     Begin
          Exclude(ControlState,csLButtonDown);
          Exclude(ControlState,csClicked);
     End;

     While True Do
     Begin
          If (Control.FOnMouseUp = Nil) And
             (Control.ComponentState * [csDetail] <> []) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then Exit;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control.FOnMouseUp <> Nil
     Then Control.FOnMouseUp(Control,Button,ShiftState,X,Y);
End;


Procedure TControl.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var  Control:TControl;
Begin
     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseMove = Nil) And
             (Control.ComponentState * [csDetail] <> []) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then Exit;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control.FOnMouseMove <> Nil
     Then Control.FOnMouseMove(Control,ShiftState,X,Y);
End;


Procedure TControl.MouseClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LonGInt);
Var  Control:TControl;
Begin
{
     // Now done correctly by handling WM_CONTEXTMENU - AaronL
     If Button = mbRight Then
       If Not Designed Then CheckMenuPopup(Point(X,Y));
}

     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseClick = Nil) And
             (csDetail In Control.ComponentState) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then break;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control <> Nil Then
       If Control.FOnMouseClick <> Nil
       Then Control.FOnMouseClick(Control,Button,ShiftState,X,Y);


     If Button = mbLeft Then
     Begin
          Control := Self;
          While True Do
          Begin
               If (Control.FOnClick = Nil) And
                  (csDetail In Control.ComponentState) Then
               Begin
                    Control := Control.Parent;
                    If Control = Nil Then break;
               End
               Else break;
          End;

          If Control <> Nil Then
            If Control.FOnClick <> Nil Then Control.FOnClick(Control);
     End;
End;


Procedure TControl.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var  Control:TControl;
Begin
     Control := Self;
     While True Do
     Begin
          If (Control.FOnMouseDblClick = Nil) And
             (csDetail In Control.ComponentState) Then
          Begin
               Control := Control.Parent;
               If Control = Nil Then break;
               Inc(X, Control.Left);
               Inc(Y, Control.Bottom);
          End
          Else break;
     End;

     If Control <> Nil Then
       If Control.FOnMouseDblClick <> Nil
       Then Control.FOnMouseDblClick(Control,Button,ShiftState,X,Y);


     If Button = mbLeft Then
     Begin
          Control := Self;
          While True Do
          Begin
               If (Control.FOnDblClick = Nil) And
                  (csDetail In Control.ComponentState) Then
               Begin
                    Control := Control.Parent;
                    If Control = Nil Then break;
               End
               Else break;
          End;

          If Control <> Nil Then
            If FOnDblClick <> Nil Then FOnDblClick(Control);
     End;
End;


Function MausPosFromParam(msgparam:LongWord):TPoint;
Var  X,Y:Integer;
Begin
     X := Lo(msgparam);
     Y := Hi(msgparam);
     Result.X := X;
     Result.Y := Y;
End;


{$HINTS OFF}
Function ShiftStateFromParam(msgparam:LongWord):TShiftState;
Begin
     Result := [];
     {$IFDEF OS2}
     If WinGetKeyState(HWND_DESKTOP,VK_ALT) And $8000 <> 0
       Then Include(Result,ssAlt);
     If WinGetKeyState(HWND_DESKTOP,VK_SHIFT) And $8000 <> 0
       Then Include(Result,ssShift);
     If WinGetKeyState(HWND_DESKTOP,VK_CTRL) And $8000 <> 0
       Then Include(Result,ssCtrl);
     If WinGetKeyState(HWND_DESKTOP,VK_BUTTON1) And $8000 <> 0
       Then Include(Result,ssLeft);
     If WinGetKeyState(HWND_DESKTOP,VK_BUTTON2) And $8000 <> 0
       Then Include(Result,ssRight);
     If WinGetKeyState(HWND_DESKTOP,VK_BUTTON3) And $8000 <> 0
       Then Include(Result,ssMiddle);
     {$ENDIF}
     {$IFDEF Win32}
     If GetKeyState(VK_MENU) < 0 Then Include(Result,ssAlt);
     If msgparam And MK_SHIFT <> 0 Then Include(Result,ssShift);
     If msgparam And MK_CONTROL <> 0 Then Include(Result,ssCtrl);
     If msgparam And MK_LBUTTON <> 0 Then Include(Result,ssLeft);
     If msgparam And MK_RBUTTON <> 0 Then Include(Result,ssRight);
     If msgparam And MK_MBUTTON <> 0 Then Include(Result,ssMiddle);
     {$ENDIF}
End;
{$HINTS ON}


{$IFDEF OS2}
Procedure TControl.WMButton1Click(Var Msg:TWMButton1Click);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseClick;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
     End;
End;


Procedure TControl.WMButton2Click(Var Msg:TWMButton2Click);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseClick(mbRight,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseClick;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseClick(mbRight,ShiftState,pt.X,pt.Y);
     End;
End;
{$ENDIF}


{$IFDEF Win32}
Const
    WinDragControl:TControl=Nil;
    WinLastDrag:TControl=Nil;
Var
    WinDragDropData:TDragDropData;

Function GetDragControl(Const pt:TPoint):TControl;
Var Win:HWND;
    P:Pointer;
Begin
     Result:=Nil;
     Win:=WinUser.WindowFromPoint(pt);
     If Win<>0 Then
     Begin
          P:=Pointer(GetWindowLong(Win,GWL_WNDPROC));
          If P<>@SubclassedWndProc Then Exit; //no Sibyl Window
          Result:=Pointer(GetWindowLong(Win,GWL_USERDATA));
     End;
End;
{$ENDIF}


{+++ Left Button ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

Procedure TControl.WMButton1Down(Var Msg:TWMButton1Down);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     FLastLButtonDownTime := GetMessageTime;
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDown(mbLeft,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDown;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF Win32}
          If WinDragControl<>Nil Then DragFinished(Nil,pt.X,pt.Y,False);
          {$ENDIF}
          MouseDown(mbLeft,ShiftState,pt.X,pt.Y);
     End;

     If Not (IsStandardControl Or (Self Is TFrameControl)) Then
     Begin
          Msg.Handled := True; {!!}
          Msg.Result := 0;
     End;
End;


Procedure TControl.WMButton1Up(Var Msg:TWMButton1Up);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     {$IFDEF Win32}
     Success:Boolean;
     DragObject:TObject;
     DragControl:TControl;
     pt1:TPoint;
     {$ENDIF}
Begin
     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     If GetMessageTime - FLastLButtonDownTime < FClickTime Then  {Click}
     Begin
          If Designed Then
          Begin
               If FHandlesDesignMouse Then
               Begin
                    MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
                    If Msg.Handled Then Exit;  {Do Not send To Form Window}
               End;

               Control := GetDesignerCoordinates(pt);
               If Control <> Nil Then
               Begin
                    DNS.Sender := Self;
                    DNS.Code := dncMouseClick;
                    DNS.return := 0;
                    DNS.mouseparam.pt := pt;
                    DNS.mouseparam.Button := mbLeft;
                    DNS.mouseparam.ShiftState := ShiftState;
                    Control.DesignerNotification(DNS);
                    If DNS.return <> 0 Then
                    Begin
                         Msg.Handled := True;
                         Msg.Result := 0;
                    End;
               End;
          End
          Else
          Begin
               MouseClick(mbLeft,ShiftState,pt.X,pt.Y);
          End;
     End;
     {$ENDIF}

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseUp(mbLeft,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseUp;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF OS2}
          MouseUp(mbLeft,ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF Win32}
          If WinDragControl<>Nil Then
          Begin
               Success:=False;
               If WinDragDropData.RenderType=drmSibylObject Then
               Begin
                    DragObject:=TObject(WinDragDropData.ItemId);
               End
               Else DragObject:=Nil;
               pt1:=Point(Msg.XPos,Msg.YPos);
               WinUser.ClientToScreen(Handle,pt1);
               DragControl:=GetDragControl(pt1);
               Success:=False;
               If DragControl<>Nil Then
                 If WinDragControl<>DragControl Then
                 Begin
                      pt:=pt1;
                      MapWindowPoints(HWND_DESKTOP,DragControl.Handle,pt,1);
                      DragControl.DragDrop(DragObject,pt.X,pt.Y);
                      Success:=True;
                 End;
               DragFinished(DragControl,pt.X,pt.Y, Success);
          End
          Else MouseUp(mbLeft,ShiftState,pt.X,pt.Y);
          {$ENDIF}
     End;
End;


Procedure TControl.WMButton1DblClk(Var Msg:TWMButton1DblClk);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDblClick(mbLeft,ShiftState+[ssDouble],pt.X,pt.Y);
//Buttons?               MouseDown(mbLeft,ShiftState+[ssDouble],pt.X,pt.Y); {VCL!}
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDblClk;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbLeft;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseDblClick(mbLeft,ShiftState+[ssDouble],pt.X,pt.Y);
//Buttons?          MouseDown(mbLeft,ShiftState+[ssDouble],pt.X,pt.Y); {VCL!}
     End;
End;


{+++ Right Button +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{initiate Dragging Of A non detail Control}
Function DragInit(Control:TControl; pt:TPoint):Boolean;
Var  Ok:Boolean;
Begin
     Result := False;

     While Control.ComponentState * [csDetail] <> [] Do
     Begin
          Inc(pt.X, Control.Left);
          Inc(pt.Y, Control.Bottom);
          Control := Control.Parent;
          If Control = Nil Then Exit;
     End;

     If Control.FDragMode=dmAutomatic Then
     Begin
          Ok := True;
          Control.CanDrag(pt.X,pt.Y,Ok);
          If Ok Then Control.BeginDrag(True);
          Result := True;
     End;
End;


Procedure TControl.WMButton2Down(Var Msg:TWMButton2Down);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     IsForm:Boolean;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     IsForm := Self Is TForm;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     FLastRButtonDownTime := GetMessageTime;
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDown(mbRight,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDown;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF OS2}
          MouseDown(mbRight,ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF Win32}
          If WinDragControl=Nil Then
          Begin
               If DragInit(Self,pt) Then
               Begin
                    Msg.Handled:=True;
                    Msg.Result:=0;
               End
               Else MouseDown(mbRight,ShiftState,pt.X,pt.Y);
          End
          Else
          Begin
               If WinDragControl<>Nil Then DragFinished(Nil,pt.X,pt.Y,False);
               MouseDown(mbRight,ShiftState,pt.X,pt.Y);
          End;
          {$ENDIF}
     End;

     //If IsForm Then
     If Not (IsStandardControl Or (Self Is TFrameControl)) Then
     Begin
          Msg.Handled := True; {!!}
          Msg.Result := 0;
     End;
End;


Procedure TControl.WMButton2Up(Var Msg:TWMButton2Up);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     {$IFDEF Win32}
     Success:Boolean;
     DragObject:TObject;
     DragControl:TControl;
     pt1:TPoint;
     {$ENDIF}
Begin
     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     If GetMessageTime - FLastRButtonDownTime < FClickTime Then  {Click}
     Begin
          If Designed Then
          Begin
               If FHandlesDesignMouse Then
               Begin
                    MouseClick(mbRight,ShiftState,pt.X,pt.Y);
                    If Msg.Handled Then Exit;  {Do Not send To Form Window}
               End;

               Control := GetDesignerCoordinates(pt);
               If Control <> Nil Then
               Begin
                    DNS.Sender := Self;
                    DNS.Code := dncMouseClick;
                    DNS.return := 0;
                    DNS.mouseparam.pt := pt;
                    DNS.mouseparam.Button := mbRight;
                    DNS.mouseparam.ShiftState := ShiftState;
                    Control.DesignerNotification(DNS);
                    If DNS.return <> 0 Then
                    Begin
                         Msg.Handled := True;
                         Msg.Result := 0;
                    End;
               End;
          End
          Else
          Begin
               MouseClick(mbRight,ShiftState,pt.X,pt.Y);
          End;
     End;
     {$ENDIF}

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseUp(mbRight,ShiftState,pt.X,pt.Y);
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseUp;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF OS2}
          MouseUp(mbRight,ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF Win32}
          If WinDragControl<>Nil Then
          Begin
               Success:=False;
               If WinDragDropData.RenderType=drmSibylObject Then
               Begin
                    DragObject:=TObject(WinDragDropData.ItemId);
               End
               Else DragObject:=Nil;
               pt1:=Point(Msg.XPos,Msg.YPos);
               WinUser.ClientToScreen(Handle,pt1);
               DragControl:=GetDragControl(pt1);
               Success:=False;
               If ((DragControl<>Nil)And(WinDragControl<>DragControl)) Then
               Begin
                    pt:=pt1;
                    MapWindowPoints(HWND_DESKTOP,DragControl.Handle,pt,1);
                    TransformPointToOS2(pt,DragControl,Nil);
                    DragControl.DragDrop(DragObject,pt.X,pt.Y);
                    Success:=True;
               End;
               DragFinished(DragControl,pt.X,pt.Y, Success);
          End
          Else MouseUp(mbRight,ShiftState,pt.X,pt.Y);
          {$ENDIF}
     End;
End;


Procedure TControl.WMButton2DblClk(Var Msg:TWMButton2DblClk);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If ((IsControlLocked(Self))Or(ControlState*[csWindowDestroying]<>[])) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     {$ENDIF}
     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               MouseDblClick(mbRight,ShiftState+[ssDouble],pt.X,pt.Y);
//Buttons?               MouseDown(mbRight,ShiftState+[ssDouble],pt.X,pt.Y); {VCL!}
               If Msg.Handled Then Exit;  {Do Not send To Form Window}
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseDblClk;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.Button := mbRight;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          MouseDblClick(mbRight,ShiftState+[ssDouble],pt.X,pt.Y);
//Buttons?          MouseDown(mbRight,ShiftState+[ssDouble],pt.X,pt.Y); {VCL!}
     End;
End;


{Query the actually Visible mouse Cursor Handle}
Function CurrentMouseHandle(Control:TControl):HCursor;
Begin
     If Screen.Cursor <> crDefault
     Then Result := Screen.Cursors[Screen.FCursor]
     Else Result := Screen.Cursors[Control.FCursor];
End;


Procedure TControl.WMMouseMove(Var Msg:TWMMouseMove);
Var  pt:TPoint;
     ShiftState:TShiftState;
     Control:TControl;
     DNS:TDesignerNotifyStruct;
     OldHandled:Boolean;
     CanHint:Boolean;
     HintParent:TControl;
     HintOwner:TControl;
     {$IFDEF Win32}
     Accept:Boolean;
     DragControl:TControl;
     pt1:TPoint;
     DragObject:TObject;
     Win:HWND;
     {$ENDIF}
Begin
     {$IFDEF OS2}
     ShiftState := ShiftStateFromParam(Msg.keys);
     pt := Point(Msg.XPos,Msg.YPos);
     If IsControlLocked(Self) Then
     Begin
          WinSetPointer(HWND_DESKTOP,Screen.Cursors[FCursor]);
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End
     Else
     Begin
          If FCursor <> crDefault Then
          Begin
               If WinQueryPointer(HWND_DESKTOP) <> CurrentMouseHandle(Self)
               Then SetCursor(FCursor);
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
     {$ENDIF}
     {$IFDEF Win32}
     pt := Point(Msg.XPos,Msg.YPos);
     If FCanvas <> Nil Then DPToLP(FCanvas.FHandle,pt,1);
     TransformPointToOS2(pt,Self,Nil);
     ShiftState := ShiftStateFromParam(Msg.keys);
     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Msg.Result := 0;
          Exit;
     End
     Else
     Begin
          If FCursor <> crDefault Then
          Begin
               If WinUser.GetCursor <> CurrentMouseHandle(Self)
               Then SetCursor(FCursor);
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
     {$ENDIF}

     If Designed Then
     Begin
          If FHandlesDesignMouse Then
          Begin
               OldHandled := Msg.Handled;
               Msg.Handled := False;

               MouseMove(ShiftState,pt.X,pt.Y);

               If Msg.Handled Then Exit;  {Do Not send To Form Window}
               Msg.Handled := OldHandled;
          End;

          Control := GetDesignerCoordinates(pt);
          If Control <> Nil Then
          Begin
               DNS.Sender := Self;
               DNS.Code := dncMouseMove;
               DNS.return := 0;
               DNS.mouseparam.pt := pt;
               DNS.mouseparam.ShiftState := ShiftState;
               Control.DesignerNotification(DNS);
               If DNS.return <> 0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
     End
     Else
     Begin
          {$IFDEF Win32}
          If WinDragControl<>Nil Then //we are Dragging
          Begin
               pt1:=Point(Msg.XPos,Msg.YPos);
               WinUser.ClientToScreen(Handle,pt1);
               DragControl:=GetDragControl(pt1);
               Accept:=False;

               If WinDragDropData.RenderType=drmSibylObject Then
               Begin
                    DragObject:=TObject(WinDragDropData.ItemId);
               End
               Else DragObject:=Nil;

               If DragControl<>WinDragControl Then
               Begin
                    If DragControl<>WinLastDrag Then
                    Begin
                         If WinLastDrag<>Nil Then
                         Begin
                              WinLastDrag.FDragState:=dsDragEnter;
                              TransformPointToOS2(pt,WinLastDrag,Nil);
                              WinLastDrag.DragOver(DragObject,
                                                   pt.X,pt.Y,
                                                   dsDragLeave,
                                                   Accept);
                         End;
                         WinLastDrag:=DragControl;
                         If DragControl<>Nil
                         Then DragControl.FDragState:=dsDragEnter;
                    End
                    Else If DragControl<>Nil
                         Then DragControl.FDragState:=dsDragMove;

                    If DragControl<>Nil Then
                    Begin
                         pt:=pt1;
                         MapWindowPoints(HWND_DESKTOP,DragControl.Handle,pt,1);
                         TransformPointToOS2(pt,DragControl,Nil);
                         DragControl.DragOver(DragObject,pt.X,pt.Y,FDragState,
                                              Accept);
                    End;
               End;
               If Accept
               Then WinUser.SetCursor(Screen.Cursors[WinDragControl.FDragCursor])
               Else WinUser.SetCursor(Screen.Cursors[crNo]);
          End
          Else MouseMove(ShiftState,pt.X,pt.Y);
          {$ENDIF}
          {$IFDEF OS2}
          MouseMove(ShiftState,pt.X,pt.Y);
          {$ENDIF}
     End;

     {Bubble}
     If Application = Nil Then Exit;

     If Application.FHintWindow = Self Then Exit;
     If Application.FHintOwner = Self Then Exit;

     {Destroy Bubble If Not from Self}
     If Application.FHintOwner <> Nil Then
       If Application.FHintOwner <> Self Then
       Begin
            HintOwner := Application.FHintOwner;
            HintParent := Application.FHintParent;
            Application.DestroyHintWindow;
            Application.FHintParent := HintParent;  {Enable Immediate Showing}

            While HintOwner <> Nil Do
            Begin
               HintOwner.Update;
               HintOwner := HintOwner.Parent;
            End;
       End;

     CanHint := (FHint <> Nil) And GetShowHint And (Not Designed);

     {If Timer Is Running, Stop it Or Destroy it}
     If Application.FHintTimer <> Nil Then
     Begin
          Application.FHintTimer.Stop;
          If (Application.FHintControl <> Self) Or (Not CanHint) Then
          Begin
               Application.FHintTimer.Destroy;
               Application.FHintTimer := Nil;
               Application.FHintParent := Nil;
          End;
     End;

     {Show Own Bubble Or Start Timer}
     Application.FHintControl := Self;

     If CanHint Then
     Begin
          If (Application.FHintParent = Parent) And (Parent <> Nil) Then
          Begin {Immediate Showing}
               If Application.FHintOwner = Nil
               Then Application.HintTimerExpired;
          End
          Else
          Begin {Start Timer}
               If Application.FHintTimer = Nil
               Then Application.FHintTimer.Create(Nil);
               Include(Application.FHintTimer.ComponentState, csDetail);
               Application.FHintTimer.Interval := Application.FHintPause;
               Application.FHintTimer.Start;
          End;
     End;

     If (Application.FHintParent <> Parent) And
        (Application.FHintParent <> Self) Then Application.FHintParent := Nil;
End;


Procedure TControl.CheckMenuPopup(pt:TPoint);
Var  AControl:TControl;
     APopup:TPopupMenu;
Begin
     If Designed Then Exit;

     AControl := Self;
     While AControl <> Nil Do
     Begin
          APopup := AControl.PopupMenu;
          If APopup <> Nil Then
            If APopup.AutoPopup Then //Popup found
            Begin
                 APopup.PopupComponent := AControl;
                 pt := ClientToScreen(pt);
                 APopup.Popup(pt.X,pt.Y);
                 Exit;
            End;
          AControl := AControl.Parent;
     End;
End;


{$IFDEF Win32}
Procedure TControl.WMSetCursor(Var Msg:TMessage);
Begin
     If Self Is TFrameControl Then Exit;

     If WinUser.GetCursor <> CurrentMouseHandle(Self)
     Then SetCursor(FCursor);

     Msg.Handled := True;
     Msg.Result := 0;
End;
{$ENDIF}


Procedure TControl.SetCursor(Index:TCursor);
Begin
     FCursor := Index;
     If Designed Then Exit;
     {$IFDEF OS2}
     WinSetPointer(HWND_DESKTOP, CurrentMouseHandle(Self));
     {$ENDIF}
     {$IFDEF Win32}
     SetClassLong(Handle,GCL_HCURSOR,0);
     WinUser.SetCursor(CurrentMouseHandle(Self));
     {$ENDIF}
End;


Procedure TControl.Resize;
Begin
     RealignControls;

     If OnResize <> Nil Then OnResize(Self);
End;


Procedure TControl.Move;
Begin
     If OnMove<>Nil Then OnMove(Self);
End;


{unter Win95 nicht Die Msg.Parameter verwenden}
{$HINTS OFF}
Procedure TControl.WMMove(Var Msg:TWMMove);
Var  rc:TRect;
     {$IFDEF Win32}
     Child:TControl;
     {$ENDIF}
Begin
     If Self Is TForm Then
       If TForm(Self).WindowState = wsMinimized Then
         If Not TForm(Self).Designed Then Exit;

     rc := GetWindowRect;
     FLeft := rc.Left;
     FBottom := rc.Bottom;
     Move;

     {$IFDEF Win32}
     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          Child := TFrameControl(Self).FChild;
          Child.Move;
     End;
     {$ENDIF}
End;
{$HINTS ON}

{unter Win95 nicht Die Msg.Parameter verwenden}
Procedure TControl.WMSize(Var Msg:TWMSize);
Var  rc:TRect;
     {$IFDEF Win32}
     rc1:TRect;
     _Left,_Bottom,_Width,_Height:LongInt;
     T:LongInt;
     Control:TControl;
     {$ENDIF}
Begin
     If Self Is TForm Then
       If TForm(Self).WindowState = wsMinimized Then
         If Not TForm(Self).Designed Then Exit;

     {$IFDEF Win32}
     For T:=0 To ControlCount-1 Do
     Begin
          Control:=Controls[T];
          If Not (Control.FIsToolBar) Then
            If Control.FFirstShow Then
              If Control.FVisible Or Control.Designed Then Control.Show;
     End;
     {$ENDIF}

     {$IFDEF OS2}
     rc:=GetWindowRect;
     FLeft:=rc.Left;
     FBottom:=rc.Bottom;
     FWidth:=Msg.Width;
     FHeight:=Msg.Height;
//FWidth:=rc.Right-rc.Left +1;
//FHeight:=rc.Top-rc.Bottom +1;
     If FFrame<>Nil Then
     Begin
          rc:=FFrame.GetWindowRect;
          FFrame.FLeft:=rc.Left;
          FFrame.FBottom:=rc.Bottom;
          FFrame.FWidth:=rc.Right-rc.Left +1;
          FFrame.FHeight:=rc.Top-rc.Bottom +1;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     {CX:=Lo(Msg.Param2);
     CY:=Hi(Msg.Param2);}
     rc:=GetWindowRect;
     FWidth:=rc.Right-rc.Left +1;
     FHeight:=rc.Top-rc.Bottom +1;

     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil) Then
     Begin
          WinUser.GetClientRect(Handle,RECTL(rc1));
          rc:=GetClientRect;
          _Width:=rc.Right-rc.Left+1;
          _Height:=rc.Top-rc.Bottom+1;
          _Left:=rc.Left;
          _Bottom:=((rc1.Top-rc1.Bottom)-_Height)-rc.Bottom;

          WinUser.SetWindowPos(TFrameControl(Self).FChild.Handle,0,
                               _Left,_Bottom,_Width,_Height, SWP_SHOWWINDOW);

          TFrameControl(Self).FChild.RealignControls;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     {If..?} WMMove(TWMMove(Msg));   {track Bottom Frame border}
     {$ENDIF}

     Resize;
End;


Procedure TControl.WMEraseBackGround(Var Msg:TMessage);
Begin
     If Not FOwnerDraw Then Exit;
     {$IFDEF OS2}
     Msg.Result:=0;          {don't Do any Action}
     Msg.Handled:=True;
     {$ENDIF}
     {$IFDEF Win32}
     Msg.Result:=1;
     Msg.Handled:=True;
     {$ENDIF}
End;


Procedure TControl.FontChange;
Begin
     If FOnFontChange <> Nil Then FOnFontChange(Self)
     Else If (Handle <> 0) And IsWindowVisible Then Invalidate;
End;


{$IFDEF OS2}
Function TControl.SetPPFontNameSize(Const FNS:String):Boolean;
Var  CS:Cstring;
Begin
     FUpdatingPP := True;
     CS := FNS;

     Result := WinSetPresParam(Handle,PP_FONTNAMESIZE,Length(CS)+1,CS);
     FUpdatingPP := False;

     If IsFontChangeEnabled Then FontChange;
End;


Function TControl.SetPPForeGroundColor(AColor:TColor):Boolean;
Begin
     FUpdatingPP := True;
     AColor := SysColorToRGB(AColor);
     Result := WinSetPresParam(Handle,PP_FOREGROUNDCOLOR,4,AColor);
     FUpdatingPP := False;
End;


Function TControl.SetPPBackGroundColor(AColor:TColor):Boolean;
Begin
     FUpdatingPP := True;
     AColor := SysColorToRGB(AColor);
     Result := WinSetPresParam(Handle,PP_BACKGROUNDCOLOR,4,AColor);
     WinSetPresParam(Handle,PP_DISABLEDBACKGROUNDCOLOR,4,AColor);
     FUpdatingPP := False;
End;


Procedure TControl.WMPresParamChanged(Var Msg:TMessage);
Var  PPid:LongWord;
     cFNS:Cstring;
     FNS:String;
     Size,P:Byte;
     C:Integer;
     aFont:TFont;
     NewColor:TColor;
Begin
     If (Self = Screen.FFontWindow) Or FUpdatingPP Then Exit;

     {drag & drop von der SystemPalette auf Details weiterleiten an Parent}
     If ComponentState * [csDetail] <> [] Then
       If Parent <> Nil Then
       Begin
            Parent.WMPresParamChanged(Msg);
            Exit;
       End;

     PPid := Msg.Param1;
     Case PPid Of
       PP_FONTNAMESIZE:
       Begin
            {wichtig: verwende Msg.Receiver wegen umgeleiteten Nachrichten!}
            if WinQueryPresParam(Msg.Receiver{Handle},
                              PPid,
                              0,
                              Nil,
                              SizeOf(cFNS),
                              cFNS,
                              QPF_NOINHERIT) > 0 then
            begin
              FNS := cFNS;
              P := Pos('.',FNS);
              If P = 0 Then Exit;
              Val(Copy(FNS,1,P-1),Size,C);
              If C <> 0 Then Exit;
              Delete(FNS,1,P);

              aFont := Screen.GetFontFromPointSize(FNS,Size);
              If aFont <> Nil Then Font := aFont;
            end;
       End;
       PP_FOREGROUNDCOLOR:
       Begin
            {wichtig: verwende Msg.Receiver wegen umgeleiteten Nachrichten!}
            if WinQueryPresParam(Msg.Receiver{Handle},
                              PPid,
                              0,
                              Nil,
                              4,
                              NewColor,
                              QPF_NOINHERIT) > 0 then
              PenColor := NewColor;
       End;
       PP_BACKGROUNDCOLOR:
       Begin
            {wichtig: verwende Msg.Receiver wegen umgeleiteten Nachrichten!}
            if WinQueryPresParam(Msg.Receiver{Handle},
                              PPid,
                              0,
                              Nil,
                              4,
                              NewColor,
                              QPF_NOINHERIT) > 0 then
              color := NewColor;
       End;
     End;
End;
{$ENDIF}


Procedure TControl.WMCommand(Var Msg:TWMCommand);
Var  cmd:TCommand;
     Control:TControl;
     Button:TControl;
     FrameChild:TForm;
     entry:TMenuItem;
     aMsg:TMessage;
     Win:HWindow;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     {$IFDEF Win32}
     Control := HandleToControl(Msg.Ctl);
     Try
        If Not (IsControl(Control)) Then Control := Nil;
     Except
        Exit;
     End;
     If Control <> Nil Then Control.ParentNotification(TMessage(Msg));
     If Msg.Handled Then Exit;
     {$ENDIF}

     If (Self Is TFrameControl) And (TFrameControl(Self).FChild <> Nil)
     Then Control := TFrameControl(Self).FChild
     Else Control := Self;
     FrameChild := TForm(Control);

     cmd := Msg.ItemId;

     {$IFDEF OS2}
     Case Msg.NotifyCode Of
       CMDSRC_PUSHBUTTON: {internal Button Command = FWindowId}
       Begin
            Win := WinWindowFromID(Handle,cmd);
            Button := HandleToControl(Win);
            If not IsControl(Button) Then Button:=Nil;
            If Button <> Nil Then
            Begin
                 FillChar(aMsg,SizeOf(aMsg),0);
                 {ReceiverClass = 0 -> no Default handler Is called}
                 aMsg.Msg := WM_CONTROL;
                 aMsg.Param1Lo := cmd;
                 aMsg.Param1Hi := BN_CLICKED;
                 Button.ParentNotification(aMsg);    {causes Click!}
                 If aMsg.Handled Then
                 Begin
                      Msg.Handled := True;
                      Exit;
                 End;
            End;
            Exit; {! because kbEsc destroyes the client Window}
       End;
       CMDSRC_MENU: {internal Menu Command}
       Begin
            entry := Application.GetMenuItem(cmd);
            If entry <> Nil Then
            Begin
                 If Not entry.Designed Then entry.Click;
                 Msg.Handled := True;
                 Exit;
            End;
       End;
       CMDSRC_ACCELERATOR: {internal Menu Command Or Real user Command}
       Begin
            entry := Application.GetMenuItem(cmd);
            If entry <> Nil Then
            Begin
                 If Not entry.Designed Then entry.Click;
                 Msg.Handled := True;
                 Exit;
            End;
            {Else - no Special Handling Of user Commands}
       End;
     End;
     {$ENDIF}

     {$IFDEF Win32}
     If (cmd >= cmInternalMenuItemBase) And (cmd < cmUser) Then
     Begin {probably an internal Menu Command}
          entry := Application.GetMenuItem(cmd);
          If entry <> Nil Then
          Begin
               Entry.Click;
               Msg.Handled := True;
               Exit;
          End;
     End;
     {$ENDIF}


     If Not Msg.Handled Then
     Begin
          If FrameChild.OnCommand <> Nil Then FrameChild.OnCommand(FrameChild,cmd);
          If cmd <> cmNull Then FrameChild.CommandEvent(cmd);
          If cmd <> cmNull Then FrameChild.DispatchCommand(Msg,cmd);

          If Not Msg.Handled Then
            If FrameChild Is TForm Then
              If FrameChild.FIsModal
                Then FrameChild.DismissDlg(FrameChild.ModalResult);

          If cmd = cmNull Then Msg.Handled := True;

          If FrameChild <> Self Then Msg.Handled := True; {!!}
     End;
End;


{$HINTS OFF}
Procedure TControl.CommandEvent(Var Command:TCommand);
Begin
     Update;
End;
{$HINTS ON}


{$IFDEF Win32}
Procedure TControl.WMNotify(Var Msg:TMessage);
Var Header:^NMHDR;
    Control:TControl;
Begin
     Header:=Pointer(Msg.Param2);
     If Header=Nil Then Exit;
     Control := HandleToControl(Header^.hwndFrom);
     If not IsControl(Control) Then Control:=Nil;
     If Control<>Nil Then Control.ParentNotification(Msg);
End;
{$ENDIF}

{$IFDEF OS2}
Procedure TControl.WMControl(Var Msg:TMessage);
Var  Win:LongWord;
     Control:TControl;
Begin
     Win := WinWindowFromID(Handle,Msg.Param1Lo);
     Control := HandleToControl(Win);
     If not IsControl(Control) Then Control:=Nil;
     If Control <> Nil Then Control.ParentNotification(Msg);
End;
{$ENDIF}

// Tab navigation
//
// Tab movement is a left-to-right traversal of an N-tree of
// controls. The children of a node are those in it's tablist
// (not all child controls are in the tablist).
// The parent is considered first in order, then the children.
//
// Some modifications:
// A control that is invisible or disabled, cannot be a tab stop,
// nor can any of it's children;
// A control that has TabStop set to false, cannot be a tab stop,
// but it's children CAN (this is normally the case for containers
// e.g. notebooks)
//
// There can conceptually be multiple trees, since controls that are not
// in their parent's tablist can still be focussed by other means,
// and can still have a tablist of their own.
//
// Traversal can start from any node (the focus control) in any tree.
// If a control finds that it is itself not in the tablist of it's parent,
// then the search continues from the parent as if the child did not exist,
// but there is still an implied order that the parent is "before" the child.
//
// At the final node, traversal loops back to the first available tab stop.
//
// It's possible (maybe even common) that NO control is marked
// as a tab stop.
//
// This implementation is recursive, but never repeats.

Function TControl.GetFirstTabControl( StartAfter:TControl;
                                      AllowSelf: boolean ):TControl;
Var  idx:LongInt;
Begin
     If    ( not Enabled )
        or ( not Visible ) then
     Begin
          // we can't be a tab stop, nor our children
          Result := nil;
          exit;
     End;

     if     FTabStop // we are a tab stop
        and AllowSelf // and this search includes us
        and ( WinSendMsg(Handle,WM_FOCUSSING,0,0) = 0 ) // and we don't focus a child instead
       then
     Begin
          // we are the first tab stop
          Result := self;
          exit;
     End;

     If FTabList = nil Then
     Begin
          // no tablist children
          result := nil;
          exit;
     End;

     idx := 0;
     if StartAfter <> nil then
     Begin
          idx := FTabList.IndexOf(StartAfter) + 1;
          // -1 (not in list) turns into 0, start from first.
     End;

     // look through children
     while idx < FTabList.Count do
     Begin
          Result := FTabList[ idx ];
          Result := Result.GetFirstTabControl( nil, true );
          if Result <> nil then
          Begin
               // found.
               exit;
          End;

          inc( idx );
     End;

     // we are not a tab stop, nor are any of our children.
     Result := nil;
End;

Function TControl.GetNextTabControl( StartAfter:TControl ):TControl;
Begin
     Result := GetFirstTabControl( StartAfter, false ); // get first child tab stop.
     if Result <> nil then
     Begin
          exit; // OK, a child is tab stop
     End;
     // no child tab stop.

     If FParent = Nil Then
     Begin
          // No parent. We are the top of the tree.
          // need to go back to first.
          Result := GetFirstTabControl( nil, true ); // including ourselves.
          exit;
     End;

     Result := nil;

     // Look for next sibling etc in parent, after self.
     Result := FParent.GetNextTabControl( self );
End;

Function TControl.GetLastTabControl( StartBefore:TControl;
                                     AllowSelf: boolean ):TControl;
Var  idx:LongInt;
Begin
     If    ( not Enabled )
        or ( not Visible ) then
     Begin
          // we can't be a tab stop, nor our children
          Result := nil;
          exit;
     End;

     If FTabList <> nil Then
     Begin
          // look thru children, from last.
          idx := FTabList.Count - 1;
          if StartBefore <> nil then
          Begin
               idx := FTabList.IndexOf(StartBefore) - 1;
               if idx = -2 then
               Begin
                    // not in list, start from last.
                    idx := FTabList.Count - 1;
               End;
          End;

          while idx >= 0 do
          Begin
               Result := FTabList[ idx ];

               Result := Result.GetLastTabControl( nil, true );
               if Result <> nil then
               Begin
                    // found.
                    exit;
               End;

               dec( idx );
          End;
     End;

     if     FTabStop
        and AllowSelf
        and ( WinSendMsg(Handle,WM_FOCUSSING,0,0) = 0 ) then
     Begin
          // we are the last tab stop (none of the kids wanted to be last)
          Result := self;
          exit;
     End;

     // we are not a tab stop, nor are any of our children.
     Result := nil;
End;

Function TControl.GetPrevTabControl:TControl;
Begin
     If FParent = Nil Then
     Begin
          // No parent. We are the top of the tree.
          // need to go all the way to last.
          Result := GetLastTabControl( nil, true ); // including ourselves.
          exit;
     End;

     Result := FParent.GetLastTabControl( self, true ); // parent can be it.
     if Result <> nil then
     Begin
          exit; // ok one of our siblings or our parent was it.
     End;

     // not a sibling.
     Result := FParent.GetPrevTabControl;
End;

Procedure TControl.FocusTabControl(Next:Boolean);
Var  Control:TControl;
Begin
     If Next Then
        Control := GetNextTabControl( nil ) // include all children
     Else
        Control := GetPrevTabControl;
     If Control = nil Then
        Exit;

     If Control = Self Then
        Exit; // still us.
     Control.Focus;
End;


Procedure TControl.FocusKeyControl(KeyCode:TKeyCode);
Var  Comp:TControl;
     ASelf:TControl;
     AParent:TControl;
     Nearest:TControl;
     I:LongInt;
Begin
     ASelf := Self;
// hmm.... no... why? AaronL
// e.g. TRadioGroup we certainly want to be able to navigate by cursor.
//     While ASelf.ComponentState * [csDetail] <> [] Do
//     Begin
//          If ASelf.Parent = Nil Then Exit;
//          ASelf := ASelf.Parent;
//     End;
     AParent := ASelf.Parent;
     If AParent = Nil Then Exit;

     Nearest := Nil;
     Case KeyCode Of
       kbCUp:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Left < ASelf.Left + ASelf.Width Then
                           If Comp.Left + Comp.Width > ASelf.Left Then
                             If Comp.Bottom > ASelf.Bottom Then
                               If Nearest <> Nil Then
                               Begin
                                    If Comp.Bottom < Nearest.Bottom
                                    Then Nearest := Comp;
                               End
                               Else Nearest := Comp;
            End;
       End;
       kbCDown:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Left < ASelf.Left + ASelf.Width Then
                           If Comp.Left + Comp.Width > ASelf.Left Then
                             If Comp.Bottom + Comp.Height < ASelf.Bottom + ASelf.Height Then
                               If Nearest <> Nil Then
                               Begin
                                    If Comp.Bottom + Comp.Height >
                                       Nearest.Bottom + Nearest.Height
                                    Then Nearest := Comp;
                               End
                               Else Nearest := Comp;
            End;
       End;
       kbCLeft:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Bottom < ASelf.Bottom + ASelf.Height Then
                           If Comp.Bottom + Comp.Height > ASelf.Bottom Then
                             If Comp.Left + Comp.Width < ASelf.Left + ASelf.Width Then
                               If Nearest <> Nil Then
                               Begin
                                    If Comp.Left + Comp.Width >
                                       Nearest.Left + Nearest.Width
                                    Then Nearest := Comp;
                               End
                               Else Nearest := Comp;
            End;
       End;
       kbCRight:
       Begin
            For I := 0 To AParent.ControlCount-1 Do
            Begin
                 Comp := AParent.Controls[I];
                 If Comp.Enabled Then
                   If Comp.FTabStop Then
                     If Comp.FCursorTabStop Then
                       If Comp.Visible Then
                         If Comp.Bottom < ASelf.Bottom + ASelf.Height Then
                           If Comp.Bottom + Comp.Height > ASelf.Bottom Then
                             If Comp.Left > ASelf.Left Then
                               If Nearest <> Nil Then
                               Begin
                                    If Comp.Left < Nearest.Left
                                    Then Nearest := Comp;
                               End
                               Else Nearest := Comp;
            End;
       End;
       Else Exit;
     End;
     If Nearest <> Nil Then Nearest.CaptureFocus;
End;


Function TControl.EvaluateShortCut(KeyCode:TKeyCode):Boolean;
Var  Control:TControl;
     I:LongInt;
Begin
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          If Control.Enabled Then
            If Control.Visible Then
            Begin
                 Result := Control.EvaluateShortCut(KeyCode);
                 If Result Then Exit; {found}
            End;
     End;
     Result := False;
End;


{$HINTS OFF}
Procedure TControl.ScanEvent(Var KeyCode:TKeyCode;RepeatCount:Byte);
Begin
     Case KeyCode Of
       kbTab:
       Begin
            FocusTabControl(True);
            KeyCode := kbNull;
       End;
       kbShiftTab:
       Begin
            FocusTabControl(False);
            KeyCode := kbNull;
       End;
       kbCLeft,kbCRight,kbCUp,kbCDown:
       Begin
            FocusKeyControl(KeyCode);
            KeyCode := kbNull;
       End;
     End;

     {Mnemo}
     If KeyCode And kb_Alt <> 0 Then
       If KeyCode <> kbAlt Then
         If FForm Is TForm Then
           If FForm.EvaluateShortCut(KeyCode) Then KeyCode := kbNull;
End;


Procedure TControl.CharEvent(Var key:Char;RepeatCount:Byte);
Var  KeyCode:TKeyCode;
Begin
     If key = #0 Then Exit;

     {Mnemo}
     If FForm Is TForm Then
     Begin
          KeyCode := Ord(key) + kb_Char + kb_Alt;
          If FForm.EvaluateShortCut(KeyCode) Then key := #0;
     End;
End;
{$HINTS ON}


{$IFDEF OS2}
Procedure TControl.WMHelp(Var Msg:TMessage);
Var  HelpControl:TControl;
Begin
     Msg.Handled := True;

     HelpControl := Self;
     While HelpControl <> Nil Do
     Begin
          If HelpControl.HelpContext <> 0 Then
          Begin
               Application.Help(HelpControl.HelpContext);
               exit;
          End;
          HelpControl := HelpControl.Parent;
     End;

     Application.HelpContents;
End;
{$ENDIF}


Procedure TControl.SendScanMessage(Var Msg:TWMChar;Var KeyCode:TKeyCode;RepeatCounT:Byte);
Var  DNS:TDesignerNotifyStruct;
Begin
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil Then
       Begin
            TFrameControl(Self).FChild.SendScanMessage(Msg,KeyCode,RepeatCount);
            Exit;
       End;

     If Designed Then
     Begin
          If FHandlesDesignKey Then
          Begin
               ScanEvent(KeyCode,RepeatCount);

               If KeyCode = kbNull Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
                    Exit;  {Do Not send To Form Window}
               End;
          End;

          DNS.Sender := Self;
          DNS.Code := dncScan;
          DNS.return := 0;
          DNS.keyparam.KeyCode := KeyCode;
          DNS.keyparam.RepeatCount := RepeatCount;
          DesignerNotification(DNS);
          If DNS.return <> 0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
          If OnScan <> Nil Then OnScan(Self,KeyCode);
          If KeyCode <> kbNull Then ScanEvent(KeyCode,RepeatCount);

          If KeyCode = kbNull Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;


Procedure TControl.SendCharMessage(Var Msg:TWMChar;Var CH:Char;RepeatCount:Byte);
Var  DNS:TDesignerNotifyStruct;
     {$IFDEF OS2}
     dbcs:Byte;
     {$ENDIF}
Begin
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil Then
       Begin
            TFrameControl(Self).FChild.SendCharMessage(Msg,CH,RepeatCount);
            Exit;
       End;

     If Designed Then
     Begin
          If FHandlesDesignKey Then
          Begin
               CharEvent(CH,RepeatCount);
               {$IFDEF OS2}
               dbcs := Hi(Msg.CharCode);
               If dbcs > 0 Then CharEvent(Char(dbcs),RepeatCount);
               {$ENDIF}

               If CH = #0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
                    Exit;  {Do Not send To Form Window}
               End;
          End;

          DNS.Sender := Self;
          DNS.Code := dncChar;
          DNS.return := 0;
          DNS.keyparam.KeyCode := Ord(CH);
          DNS.keyparam.RepeatCount := RepeatCount;
          DesignerNotification(DNS);
          If DNS.return <> 0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End
     Else
     Begin
          If OnKeyPress <> Nil Then OnKeyPress(Self,CH);
          If CH <> #0 Then CharEvent(CH,RepeatCount);
          {$IFDEF OS2}
          dbcs := Hi(Msg.CharCode);
          If dbcs > 0 Then {Insert the 2nd Byte of the dbcs Char}
          Begin
               If OnKeyPress <> Nil Then OnKeyPress(Self,Char(dbcs));
               If Char(dbcs) <> #0 Then CharEvent(Char(dbcs),RepeatCount);

               If Char(dbcs) = #0 Then
               Begin
                    Msg.Handled := True;
                    Msg.Result := 0;
               End;
          End;
          {$ENDIF}

          If CH = #0 Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;
     End;
End;


{$IFDEF Win32}
Procedure TControl.WMKeyDown(Var Msg:TMessage);
Var KeyCode:TKeyCode;
    RepeatCount:LongInt;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     KeyCode := Msg.Param1;
     RepeatCount := Msg.Param2 And 15;

     If KeyCode In [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_DELETE,VK_INSERT,
                    VK_END,VK_HOME,VK_NEXT,VK_PRIOR,VK_BACK,VK_RETURN,
                    VK_ESCAPE,VK_CAPITAL,VK_SCROLL,VK_PRINT,VK_CONTROL,
                    VK_MENU,VK_TAB,VK_NUMLOCK,VK_PAUSE,VK_SHIFT,
                    VK_F1..VK_F24] Then
     Begin
          {Real Virtual Code}
          Inc(KeyCode,kb_VK);

          If GetKeyState(VK_CONTROL) < 0 Then Inc(KeyCode,kb_Ctrl);
          If GetKeyState(VK_SHIFT) < 0 Then Inc(KeyCode,kb_Shift);
          If GetKeyState(VK_MENU) < 0 Then Inc(KeyCode,kb_Alt);

          SendScanMessage(TWMChar(Msg),KeyCode,RepeatCount);

          {Send Clicks for dialog buttons}
          If not Msg.Handled Then
            If not (Self Is TForm) Then
              If Form<>Nil Then If KeyCode In [kbEsc,kbCR] Then
                Form.ScanEvent(KeyCode,RepeatCount);

          If KeyCode = kbEsc Then
          Begin
               Msg.Handled := True;
               Msg.Result := 0;
          End;

          Exit; {!!}
     End;

     {normal key}
     Inc(KeyCode,kb_Char);

     {check whether Control was Pressed}
     If GetKeyState(VK_CONTROL) < 0 Then
     Begin
          Inc(KeyCode,kb_Ctrl);
          If GetKeyState(VK_SHIFT) < 0 Then Inc(KeyCode,kb_Shift);

          SendScanMessage(TWMChar(Msg),KeyCode,RepeatCount);
     End;
End;


Procedure TControl.WMSysKeyDown(Var Msg:TMessage);
Var KeyCode:TKeyCode;
    RepeatCount:LongInt;
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     KeyCode := Msg.Param1;
     RepeatCount := Msg.Param2 And 15;

     If KeyCode In [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_DELETE,VK_INSERT,
                    VK_END,VK_HOME,VK_NEXT,VK_PRIOR,VK_BACK,VK_RETURN,
                    VK_ESCAPE,VK_CAPITAL,VK_SCROLL,VK_PRINT,VK_CONTROL,
                    VK_MENU,VK_TAB,VK_NUMLOCK,VK_PAUSE,VK_SHIFT,
                    VK_F1..VK_F24] Then
     Begin
          {Real Virtual Code}
          Inc(KeyCode,kb_VK);

          If GetKeyState(VK_CONTROL) < 0 Then Inc(KeyCode,kb_Ctrl);
          If GetKeyState(VK_SHIFT) < 0 Then Inc(KeyCode,kb_Shift);
          If GetKeyState(VK_MENU) < 0 Then Inc(KeyCode,kb_Alt);

          SendScanMessage(TWMChar(Msg),KeyCode,RepeatCount);
     End;
End;
{$ENDIF}


Procedure TControl.WMChar(Var Msg:TWMChar);
Var  CH:Char;
     fsFlags:Word;
     ascii:Word;
     virtkey:Word;
     REP:Byte;
     scan:TKeyCode;
     Param:TKeyCode;
     s:STRING;
{$IFDEF OS2}
Label lsc;
{$ENDIF}
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     If IsControlLocked(Self) Then
     Begin
          Msg.Handled := True;
          Exit;
     End;

     {$IFDEF OS2}
     fsFlags := Msg.KeyData;
     REP := GetKeyRepeat(TMessage(Msg));
     scan := Msg.ScanCode;
     ascii := Lo(Msg.CharCode);
     virtkey := Msg.VirtualKeyCode;

     If Self Is TFrameControl Then Exit;  {send To client by DefWindowProc}

     If fsFlags And KC_KEYUP <> 0 Then Exit;

     If fsFlags And KC_DEADKEY <> 0 Then  {wait For composite}
     Begin
          FLastDeadKey := ascii;
          Exit;
     End;

     If fsFlags And KC_INVALIDCOMP <> 0 Then
     Begin {invalid composite after deadkey}
          CH := Chr(FLastDeadKey);
          SendCharMessage(Msg,CH,1);
          If fsFlags And KC_CHAR = 0 Then Exit;  {ignore scan Or Virtual key}
     End;

     If fsFlags And KC_CHAR <> 0 Then
     Begin
          If (ascii < 32) Or (fsFlags And KC_CTRL <> 0) Then Goto lsc;

          If (fsFlags And KC_VIRTUALKEY <> 0) And (fsFlags And KC_SHIFT <> 0)
          Then Goto lsc;    {numerical block}

          CH := Chr(ascii);
          SendCharMessage(Msg,CH,REP);
          Msg.CharCode := Ord(CH)+256*(Msg.CharCode Shr 8);
     End
     Else
     Begin
          // test AltGr+BkSp
          If (fsFlags And KC_VIRTUALKEY <> 0) And
             (fsFlags And KC_SCANCODE <> 0) And
             (virtkey = VK_BACKSPACE) Then fsFlags := fsFlags Or KC_ALT;
lsc:
          Param := 0;
          If fsFlags And KC_VIRTUALKEY <> 0 Then Param := virtkey Or kb_VK
          Else Param := ascii Or kb_Char;       {E.G. Ctrl-J}

          If fsFlags And KC_ALT <> 0 Then Param := Param Or kb_Alt;
          If fsFlags And KC_SHIFT <> 0 Then Param := Param Or kb_Shift;
          If fsFlags And KC_CTRL <> 0 Then Param := Param Or kb_Ctrl;

          SendScanMessage(Msg,Param,REP);
     End;
     {$ENDIF}

     {$IFDEF Win32}
     CH := Chr(Msg.CharCode);

     // Ansi to OEM conversion for ,”,,แ,,,
     s := CH;
     StrAnsiToOem(s);
     CH := s[1];

     REP := Msg.KeyData And 15;

     If CH < #32 Then Exit;  {Not printable}

     SendCharMessage(Msg,CH,REP);
     Msg.CharCode := Ord(CH);
     {$ENDIF}

     {$IFDEF LINUX}
     CH := Chr(Msg.CharCode);

     // Ansi to OEM conversion for ,”,,แ,,,
     s := CH;
     StrAnsiToOem(s);
     CH := s[1];

     REP:=1;

     If CH < #32 Then Exit;  {Not printable}

     SendCharMessage(Msg,CH,REP);
     Msg.CharCode := Ord(CH);
     {$ENDIF}

     Try {maybe Self Is destroyed}
        If Self Is TForm Then Msg.Handled := True; {don't Dispatch it further}
     Except
        Msg.Handled := True;
     End;
End;


{$IFDEF OS2}
Procedure TControl.WMQueryConvertPos(Var Msg:TMessage);
Var  prec:PRect;
     pt:TPoint;
Begin
     If IsStandardControl Then Exit;

     {Param1 Points To A Rectangle}
     prec := PRect(Msg.Param1);

     pt.X := -1;
     pt.Y := -1;
     If QueryConvertPos(pt) Then
     Begin
          prec^.Left := pt.X;
          prec^.Bottom := pt.Y;
          prec^.Right := 0;
          prec^.Top := 0;
          Msg.Result := QCP_CONVERT;
     End
     Else Msg.Result := QCP_NOCONVERT;
     Msg.Handled := True;
End;
{$ENDIF}


{$HINTS OFF}
Function TControl.QueryConvertPos(Var Pos:TPoint):Boolean;
Begin
     Result := True; {Use Standard Position}
End;
{$HINTS ON}


{$HINTS OFF}
Procedure TControl.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LOnGint);
Begin
End;
{$HINTS ON}


Procedure TControl.WMHScroll(Var Msg:TWMScroll);
Var  target:TControl;
     ScrollBar:TScrollBar;
     ScrollCode:TScrollCode;
     ScrollPos:LongInt;
     {$IFDEF OS2}
     Win:LongWord;
     {$ENDIF}
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     target := Self;
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil
       Then target := TFrameControl(Self).FChild;

     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.ScrollBarId);
     ScrollBar := TScrollBar(HandleToControl(Win));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINERIGHT:
         Begin
              ScrollCode := scColumnRight;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_LINELEFT:
         Begin
              ScrollCode := scColumnLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_PAGERIGHT:
         Begin
              ScrollCode := scPageRight;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_PAGELEFT:
         Begin
              ScrollCode := scPageLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_SLIDERTRACK:
         Begin
              ScrollCode := scHorzTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_SLIDERPOSITION:
         Begin
              ScrollCode := scHorzPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scHorzEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
     End; {Case}
     {$ENDIF}

     {$IFDEF Win32}
     ScrollBar := TScrollBar(HandleToControl(Msg.ScrollBar));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINERIGHT:
         Begin
              ScrollCode := scColumnRight;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_LINELEFT:
         Begin
              ScrollCode := scColumnLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_PAGERIGHT:
         Begin
              ScrollCode := scPageRight;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_PAGELEFT:
         Begin
              ScrollCode := scPageLeft;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_THUMBTRACK:
         Begin
              ScrollCode := scHorzTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_THUMBPOSITION:
         Begin
              ScrollCode := scHorzPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scHorzEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
         SB_BOTTOM: Exit;
         SB_TOP: Exit;
     End;
     {$ENDIF}

     If ScrollPos < ScrollBar.Min Then ScrollPos := ScrollBar.Min;
     If ScrollPos > ScrollBar.FCalcRange Then ScrollPos := ScrollBar.FCalcRange;

     If ScrollCode <> scHorzEndScroll Then
       If ScrollCode <> scHorzPosition Then
         If ScrollPos = ScrollBar.Position Then Exit;

     target.Scroll(ScrollBar,ScrollCode,ScrollPos);
     If ScrollBar.OnScroll <> Nil
     Then ScrollBar.OnScroll(ScrollBar,ScrollCode,ScrollPos);

     ScrollBar.Position := ScrollPos; {Set the final Position}

     If ScrollBar.FOnChange<>Nil Then ScrollBar.FOnChange(Self);

     Msg.Handled := True; {!!}
     Msg.Result := 0;
End;


Procedure TControl.WMVScroll(Var Msg:TWMScroll);
Var  target:TControl;
     ScrollBar:TScrollBar;
     ScrollCode:TScrollCode;
     ScrollPos:LongInt;
     {$IFDEF OS2}
     Win:LongWord;
     {$ENDIF}
Begin
     If Application<>Nil Then Application.DestroyHintWindow;

     target := Self;
     If Self Is TFrameControl Then
       If TFrameControl(Self).FChild <> Nil
       Then target := TFrameControl(Self).FChild;

     {$IFDEF OS2}
     Win := WinWindowFromID(Handle,Msg.ScrollBarId);
     ScrollBar := TScrollBar(HandleToControl(Win));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINEUP:
         Begin
              ScrollCode := scLineUp;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_LINEDOWN:
         Begin
              ScrollCode := scLineDown;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_PAGEUP:
         Begin
              ScrollCode := scPageUp;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_PAGEDOWN:
         Begin
              ScrollCode := scPageDown;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_SLIDERTRACK:
         Begin
              ScrollCode := scVertTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_SLIDERPOSITION:
         Begin
              ScrollCode := scVertPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scVertEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
     End; {Case}
     {$ENDIF}

     {$IFDEF Win32}
     ScrollBar := TScrollBar(HandleToControl(Msg.ScrollBar));
     If Not (ScrollBar Is TScrollBar) Then Exit;

     Case Msg.ScrollCode Of
         SB_LINEUP:
         Begin
              ScrollCode := scLineUp;
              ScrollPos := ScrollBar.Position - ScrollBar.SmallChange;
         End;
         SB_LINEDOWN:
         Begin
              ScrollCode := scLineDown;
              ScrollPos := ScrollBar.Position + ScrollBar.SmallChange;
         End;
         SB_PAGEUP:
         Begin
              ScrollCode := scPageUp;
              ScrollPos := ScrollBar.Position - ScrollBar.LargeChange;
         End;
         SB_PAGEDOWN:
         Begin
              ScrollCode := scPageDown;
              ScrollPos := ScrollBar.Position + ScrollBar.LargeChange;
         End;
         SB_THUMBTRACK:
         Begin
              ScrollCode := scVertTrack;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_THUMBPOSITION:
         Begin
              ScrollCode := scVertPosition;
              ScrollPos := Msg.Pos;
              {transform}
              ScrollPos := Round(ScrollPos * ScrollBar.FScale);
              ScrollPos := ScrollPos + ScrollBar.Min;
         End;
         SB_ENDSCROLL:
         Begin
              ScrollCode := scVertEndScroll;
              ScrollPos := ScrollBar.Position;
         End;
         SB_BOTTOM: Exit;
         SB_TOP: Exit;
     End;
     {$ENDIF}

     If ScrollPos < ScrollBar.Min Then ScrollPos := ScrollBar.Min;
     If ScrollPos > ScrollBar.FCalcRange Then ScrollPos := ScrollBar.FCalcRange;

     If ScrollCode <> scVertEndScroll Then
       If ScrollCode <> scVertPosition Then
         If ScrollPos = ScrollBar.Position Then Exit;

     target.Scroll(ScrollBar,ScrollCode,ScrollPos);
     If ScrollBar.OnScroll <> Nil
     Then ScrollBar.OnScroll(ScrollBar,ScrollCode,ScrollPos);

     ScrollBar.Position := ScrollPos; {Set the final Position}

     If ScrollBar.FOnChange<>Nil Then ScrollBar.FOnChange(Self);

     Msg.Handled := True; {!!}
     Msg.Result := 0;
End;


{$IFDEF Win32}
Procedure TControl.SetCtlColor(Var Msg:TMessage);
Var  Control:TControl;
Begin
     Control := HandleToControl(Msg.Param2); {Get VMT Pointer}
     If IsControl(Control) Then
     Begin
          WinGDI.SetTextColor(Msg.Param1,
                              RGBToWinColor(SysColorToRGB(Control.PenColor)));
          WinGDI.SetBkColor(Msg.Param1,
                            RGBToWinColor(SysColorToRGB(Control.color)));
          Msg.Result := Control.FCtlBrush;
     End
     Else {Set Standard}
     Begin
          WinGDI.SetTextColor(Msg.Param1,
                              RGBToWinColor(SysColorToRGB(PenColor)));
          WinGDI.SetBkColor(Msg.Param1,
                            RGBToWinColor(SysColorToRGB(color)));
          Msg.Result := FCtlBrush;
     End;
     Msg.Handled := True;
End;


Procedure TControl.WMCtlColorBtn(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorEdit(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorListBox(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorStatic(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorDlg(Var Msg:TMessage);
Begin
     SetCtlColor(Msg);
End;

Procedure TControl.WMCtlColorScrollBar(Var Msg:TMessage);
Var  Control:TControl;
Begin
     Control := HandleToControl(Msg.Param2); {VMT Pointer}
     If IsControl(Control) Then
       If Control.color = clScrollbar Then Exit;      {DefWndProc!}
       {dont Change Default brush! (Pattern will Get lost)}

     SetCtlColor(Msg);
End;
{$ENDIF}


{captive = True -> Capture ON}
Procedure TControl.SetMouseCapture(captive:Boolean);
Begin
     If Handle = 0 Then Exit;
     FMouseCapture := captive;
     {$IFDEF OS2}
     If captive Then WinSetCapture(HWND_DESKTOP,Handle)
     Else WinSetCapture(HWND_DESKTOP,0);
     {$ENDIF}
     {$IFDEF Win32}
     If captive Then SetCapture(Handle)
     Else ReleaseCapture;
     {$ENDIF}
End;


{$HINTS OFF}
Procedure TControl.WMCaptureFocus(Var Msg:TMessage);
Begin
     Focus;
End;
{$HINTS ON}


Procedure TControl.Focus;
var
     ALternativeFocusControl: TControl;
Begin
     If IsControlLocked(Self) Then Exit;

     ALternativeFocusControl := TControl( WinSendMsg(Handle,WM_FOCUSSING,0,0) );
     if ALternativeFocusControl <> nil then
     Begin
          AlternativeFocusControl.Focus;
          exit;
     End;
//     If FAlwaysFocusChild <> nil Then
//     Begin
//          FAlwaysFocusChild.Focus;
//          exit;
//     End;

     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          WinSetFocus(HWND_DESKTOP,Handle);
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.SetFocus(Handle);
          {$ENDIF}
     End;

     If FForm Is TForm Then FForm.FActiveControl := Self;
     Screen.FActiveControl := Self;

     Screen.UpdateLastActive;
End;


{Use This Function within SetFocus notify method To redirect the Focus}
{Otherwise Is it Not possible To Change the Focus}
Procedure TControl.CaptureFocus;
Begin
     If Handle <> 0 Then
     Begin
          {$IFDEF OS2}
          PostMsg(Handle,WM_CAPTUREFOCUS,0,0);
          {$ENDIF}
          {$IFDEF Win32}
          WinUser.SetFocus(Handle);
          {$ENDIF}
     End
     Else Focus;
End;


Function TControl.Focused:Boolean;
Begin
     Result := FHasFocus;
End;


Function TControl.GetEnabled:Boolean;
Begin
     {$IFDEF OS2}
     If (Handle = 0) Or Designed Then Result := FEnabled
     Else Result := WinIsWindowEnabled(Handle);
     {$ENDIF}
     {$IFDEF Win32}
     If (Handle = 0) Or Designed Then Result := FEnabled
     Else Result := IsWindowEnabled(Handle);
     {$ENDIF}
End;


Procedure TControl.SetEnabled(NewState:Boolean);
Var  i:LongInt;
Begin
     FEnabled := NewState;
     If (Handle = 0) Or Designed Then
     Begin
          If Handle<>0 Then Invalidate;
          Exit;
     End;

     If FEnabled Then Enable
     Else Disable;

     For i := 0 To ControlCount-1 Do
     Begin
          Controls[i].Enabled := FEnabled;
     End;
End;


Procedure TControl.Enable;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinEnableWindow(Handle,True);
     {$ENDIF}
     {$IFDEF Win32}
     EnableWindow(Handle,True);
     If not ((Self Is TForm)Or(Self Is TFrameControl)) Then Invalidate;
     {$ENDIF}
End;


Procedure TControl.Disable;
Begin
     If Handle = 0 Then Exit;
     {$IFDEF OS2}
     WinEnableWindow(Handle,False);
     {$ENDIF}
     {$IFDEF Win32}
     EnableWindow(Handle,False);
     If not ((Self Is TForm)Or(Self Is TFrameControl)) Then Invalidate;
     {$ENDIF}
End;


Function TControl.IsWindowVisible:Boolean;
Begin
     {$IFDEF OS2}
     If FFrame <> Nil Then Result := WinIsWindowVisible(FFrame.Handle)
     Else Result := WinIsWindowVisible(Handle);
     {$ENDIF}
     {$IFDEF Win32}
     If FFrame <> Nil Then Result := WinUser.IsWindowVisible(FFrame.Handle)
     Else Result := WinUser.IsWindowVisible(Handle);
     {$ENDIF}
End;


Function TControl.GetShowing;
Begin
     If Handle=0 Then Result:=False
     Else Result:=GetVisible;
End;


Function TControl.GetVisible:Boolean;
Begin
     If (Handle = 0) Or Designed Then Result := FVisible
     Else Result := IsWindowVisible;
End;


Procedure TControl.SetVisible(NewState:Boolean);
Begin
     If NewState Then
     Begin
          FVisible := True;
          If (Handle = 0) Or Designed Then Exit;
          Show;
     End
     Else
     Begin
          FVisible := False;
          If (Handle = 0) Or Designed Then Exit;
          Hide;
     End;
End;


Function TControl.GetTabOrder:LongInt;
Begin
     Result := -1;
     If FParent <> Nil Then
       If FParent.FTabList <> Nil
       Then Result := FParent.FTabList.IndexOf(Self);
End;


Procedure TControl.SetTabOrder(Value:LongInt);
Var  idx:LongInt;
     ACount:LongInt;
Begin
     If Value < 0 Then Exit;

     If ComponentState * [csReading] <> [] Then
     Begin
          FTabOrder := Value;
          Exit;
     End;

     If FParent <> Nil Then
       If FParent.FTabList <> Nil Then
       Begin
            ACount := FParent.FTabList.Count;
            If Value >= ACount Then Value := ACount - 1;
            idx := FParent.FTabList.IndexOf(Self);
            If idx >= 0 Then FParent.FTabList.Move(idx,Value);
       End;
End;

Procedure TControl.LoadedFromSCU(SCUParent:TComponent);
Var  Control:TControl;
     NewList:TList;
     I:LongInt;
     ControlTabOrder:LongInt;
Begin
     Inherited LoadedFromSCU(SCUParent);

     If IsControl(TControl(SCUParent)) Then SetParent(TControl(SCUParent));

     {Update Special Alignment, Parent Is Valid now}
     If Align In [alFrame,alScale,alFixedRightBottom,
                  alFixedRightTop,alFixedLeftTop] Then SetAlign(Align);

     {reorder the tablist}
     If FTabList = Nil Then Exit;
     If FTabList.Count < 2 Then Exit; {Nothing To Do}

     NewList.Create;
     NewList.Count := FTabList.Count; {Fill With Nil}
     For I := 0 To FTabList.Count-1 Do
     Begin
          Control := FTabList.Items[I];
          If Not (IsControl(Control)) Then continue;
          If Control.ComponentState * [csLoaded] <> []
          Then ControlTabOrder := Control.FTabOrder
          Else ControlTabOrder := I;

          If ControlTabOrder < 0 Then continue; {was Not In the list?}
          If ControlTabOrder >= FTabList.Count Then continue;

          NewList.Items[ControlTabOrder] := Control;
     End;

     NewList.Pack; {Remove NILs}
     FTabList.Destroy;
     FTabList := NewList;
End;


Procedure TControl.Redraw(Const rec:TRect);
Begin
     If FCanvas = Nil Then Exit;
     FCanvas.FillRect(rec,color);
End;


Procedure TControl.Refresh;
Begin
     Invalidate;
     Update;
End;


Procedure TControl.Repaint;
Begin
     Refresh;
End;


Procedure TControl.Update;
Begin
     If Handle = 0 Then Exit;
     If Not FUpdateEnabled Then Exit;
     {$IFDEF OS2}
     WinUpdateWindow(Handle);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.UpdateWindow(Handle);
     {$ENDIF}
End;


Procedure TControl.Invalidate;
{$IFDEF WIN32}
Var
    t:LongInt;
{$ENDIF}
Begin
     If Handle = 0 Then Exit;
     If Not FUpdateEnabled Then Exit;
     If FCanvas <> Nil Then FCanvas.DeleteClipRegion;
     If Application<>Nil Then Application.DestroyHintWindow;

     {$IFDEF OS2}
     WinInvalidateRect(Handle,Nil,True);
     {$ENDIF}
     {$IFDEF Win32}
     WinUser.InvalidateRect(Handle,Nil,True);
     For t:=0 To ControlCount-1 Do Controls[t].Invalidate;
     {$ENDIF}
End;


Procedure TControl.InvalidateRect(Const rec:TRect);
Var  rc:TRect;
Begin
     If Handle = 0 Then Exit;
     If Not FUpdateEnabled Then Exit;
     If Application<>Nil Then Application.DestroyHintWindow;

     rc := rec;
     {$IFDEF OS2}
     WinInvalidateRect(Handle,RECTL(rc),True);
     {$ENDIF}
     {$IFDEF Win32}
     RectToWin32Rect(rc);
     TransformClientRect(rc,Self,Nil);
     WinUser.InvalidateRect(Handle,RECTL(rc),True);
     {$ENDIF}
End;


Function TControl.Perform(MsgId:ULONG;mp1,mp2:LONG):LONG;
Var  Msg:TMessage;
Begin
     FillChar(Msg,SizeOf(Msg),0);
     Msg.Msg := MsgId;
     Msg.ReceiverClass := Self;
     Msg.Receiver := Handle;
     Msg.Handled := False;
     Msg.Param1 := mp1;
     Msg.Param2 := mp2;
     Msg.Result := 0;
     If Self <> Nil Then WndProc(Msg);
     Result := Msg.Result;
End;


Procedure TControl.NotifyControls(MsgId:ULONG);
Var  Msg:TMessage;
Begin
     Msg.Msg := MsgId;
     Msg.ReceiverClass := Self;
     Msg.Receiver := Handle;
     Msg.Handled := False;
     Msg.Param1 := 0;
     Msg.Param1 := 0;
     Msg.Result := 0;
     BroadCast(Msg);
End;


Procedure TControl.BroadCast(Var Msg:TMessage);
Var  I:LongInt;
     Control:TControl;
Begin
     For I := 0 To ControlCount-1 Do
     Begin
          Control := Controls[I];
          Msg.Receiver := Control.Handle;  //!!!
          Control.WndProc(Msg);
          If Msg.Result <> 0 Then Exit;
     End;
End;


Procedure TControl.GetChildren(Proc:TGetChildProc);
Var  T:LongInt;
     Child:TComponent;
     Control:TControl;
Begin
     Inherited GetChildren(Proc);

     If ComponentState * [csReference] = [] Then
     Begin
          For T := 0 To ControlCount-1 Do
          Begin
               Control := Controls[T];
               If Control.Designed Then
                 If Control.ComponentState * [csDetail,csReference] = [] Then
                 Begin
                      Proc(Control);
                 End;
          End;

          For T := 0 To ComponentCount-1 Do
          Begin
               Child := Components[T];
               If Child.Designed Then
                 If (Not Child.HasParent) Then
                   If Child.ComponentState *
                      [csDetail,csReference,csReferenceControl] = [] Then
                   Begin
                        Proc(Child);
                   End;
          End;
     End;
End;


Function TControl.HasParent:Boolean;
Begin
     Result := Parent <> Nil;
End;


Procedure TControl.SetHint(Const NewText:String);
Begin
     AssignStr(FHint,NewText);
End;


Function TControl.GetHint:String;
Begin
     If FHint = Nil Then Result := ''
     Else Result := FHint^;
End;


Procedure TControl.SetShowHint(Value:Boolean);
Begin
     If FShowHint <> Value Then
     Begin
          FShowHint := Value;
          If ComponentState * [csReading] = [] Then FParentShowHint := False;
     End;
End;


Function TControl.GetShowHint:Boolean; {internal used}
Begin
     If FParentShowHint Then
     Begin
          If Parent <> Nil Then Result := Parent.GetShowHint
          Else Result := FShowHint;
     End
     Else Result := FShowHint;
End;


Procedure TControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LoNgInt);
Begin
     If ResName = rnFont Then
     Begin
          If DataLen <> 0 Then
          Begin
               Font := ReadSCUFont(Data,DataLen);
               If ((Font<>Nil)And(Font.FAlternateName<>Nil)) Then
               Begin
                   AssignStr(FAlternateFontName,Font.FAlternateName^);
                   DisposeStr(Font.FAlternateName);
                   Font.FAlternateName:=Nil;
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If (Font <> Nil) And (ComponentState * [csDetail] = [])
     Then
     Begin
          DisposeStr(Font.FAlternateName);
          Font.FAlternateName:=FAlternateFontName;
          Result := Font.WriteSCUResourceName(Stream,rnFont);
          Font.FAlternateName:=Nil;
     End;
End;


Procedure TControl.DoStartDrag(Var DragData:TDragDropData);
Begin
     With DragData Do
     Begin
          SourceWindow := Handle;
          SourceType := drtSibylObject;
          SourceString:='';
          RenderType := drmSibylObject;
          RenderString:='';
          SourceFileName := '';
          TargetFileName := '';
          ContainerName := '';
          SupportedOps := [doCopyable,doMoveable,doLinkable];
          DragOperation := doDefault;
          ItemId := LongWord(Self);
     End;

     If FOnStartDrag <> Nil Then FOnStartDrag(Self,DragData);
End;


{$IFDEF OS2}
Function FlagsFromDragSupport(SupportedOps:TDragDropSupportedOps):LongWord;
Begin
     Result := 0;
     If SupportedOps * [doCopyable] <> [] Then Result := Result Or DO_COPYABLE;
     If SupportedOps * [doMoveable] <> [] Then Result := Result Or DO_MOVEABLE;
     If SupportedOps * [doLinkable] <> [] Then Result := Result Or DO_LINKABLE;
End;


Function DragSupportFromFlags(Flags:LongWord):TDragDropSupportedOps;
Begin
     Result := [];
     If Flags And DO_COPYABLE <> 0 Then Include(Result, doCopyable);
     If Flags And DO_MOVEABLE <> 0 Then Include(Result, doMoveable);
     If Flags And DO_LINKABLE <> 0 Then Include(Result, doLinkable);
End;


Function FlagFromDragOperation(Operation:TDragDropOperation):LongWord;
Const
    DragOps:Array[TDragDropOperation] Of LongWord=
        (DO_DEFAULT,DO_COPY,DO_MOVE,DO_LINK,DO_UNKNOWN);
Begin
     Result := DragOps[Operation];
End;


Function DragOperationFromFlag(flag:LongWord):TDragDropOperation;
Begin
     Case flag Of
       DO_DEFAULT: Result := doDefault;
       DO_COPY: Result := doCopy;
       DO_MOVE: Result := doMove;
       DO_LINK: Result := doLink;
       Else Result := doUnknown;
     End;
End;
{$ENDIF}

{$HINTS OFF}
Procedure TControl.BeginDrag(Immediate:Boolean); {zZ dummy Parameter}
{$IFDEF OS2}
Var DItem:DRAGITEM;
    DImg:DRAGIMAGE;
    apsz:Cstring;
    hwndDrop:HWND;
    DrgData:TDragDropData;
    RMF:Cstring;
    Typ:Cstring;
    ContainerName,SourceName,TargetName:LongWord;
    DragControl:TControl;
    Accepted:Boolean;
    pt:TPoint;
    apid,adrgpid:PID;
    atid,adrgtid:TID;
{$ENDIF}
Begin
     {$IFDEF OS2}
     {Do Not allow drag inside Of drag}
     If ((Form.FDragControl<>Nil)Or(Form.FDragInfo<>Nil)) Then Exit;
     Form.FDragControl:=Self;
     Form.FDragControl.FDragging:=True;

     //allocate drag Info With one DRAGITEM
     Form.FDragInfo:=DrgAllocDragInfo(1);

     DoStartDrag(DrgData);

     Form.FDragInfo^.usOperation := FlagFromDragOperation(DrgData.DragOperation);

     Case DrgData.RenderType Of
        drmSibylObject:
        Begin
             Typ:='DRT_SIBYLOBJECT'+tohex(AppHandle);
             RMF:='<DRM_SIBYLOBJECT'+tohex(AppHandle)+',DRF_SIBYLOBJECT'+tohex(AppHaNdle)+'>';
        End;
        drmFile,drmPrint,drmSibyl,drmString:
        Begin
             If DrgData.SourceType=drtString Then Typ:=DrgData.SourceString
             Else If DrgData.SourceType=drtText Then Typ:='DRT_TEXT'
             Else If DrgData.SourceType=drtSibyl Then Typ:='DRT_SIBYL'
             Else Typ:='DRT_BINDATA';

             If DrgData.RenderType=drmString Then RMF:='<'+DrgData.RenderString+','
             Else If DrgData.RenderType=drmPrint Then RMF:='<DRM_PRINT,'
             Else If DrgData.RenderType=drmSibyl Then RMF:='<DRM_SIBYL,'
             Else RMF:='<DRM_OS2FILE,';
             If DrgData.SourceType=drtText Then RMF:=RMF+'DRF_TEXT>'
             Else RMF:=RMF+'DRF_UNKNOWN>';
        End;
     End;

     If DrgData.ContainerName<>'' Then
     Begin
          apsz:=DrgData.ContainerName;
          ContainerName:=DrgAddStrHandle(apsz);
     End
     Else ContainerName:=0;
     If DrgData.SourceFileName<>'' Then
     Begin
          apsz:=DrgData.SourceFileName;
          SourceName:=DrgAddStrHandle(apsz);
     End
     Else SourceName:=0;
     If DrgData.TargetFileName<>'' Then
     Begin
          apsz:=DrgData.TargetFileName;
          TargetName:=DrgAddStrHandle(apsz);
     End
     Else TargetName:=0;

     //Setup DRAGITEM structure
     DItem.hwndItem:=Handle;
     DItem.ulItemID:=DrgData.ItemId;
     DItem.hstrType:=DrgAddStrHandle(Typ);
     DItem.hstrRMF:=DrgAddStrHandle(RMF);
     DItem.hstrContainerName:=ContainerName;
     DItem.hstrSourceName:=SourceName;
     DItem.hstrTargetName:=TargetName;
     DItem.cxOffset:=0;
     DItem.cyOffset:=0;
     DItem.fsControl:=0;
     DItem.fsSupportedOps:=FlagsFromDragSupport(DrgData.SupportedOps);

     //Set First drag Item (Index 0)
     DrgSetDragItem(Form.FDragInfo^,DItem,SizeOf(DRAGITEM),0);

      //initialize DRAGIMAGE structure
     DImg.cb:=SizeOf(DRAGIMAGE);
     DImg.cptl:=0;
     DImg.hImage:=Screen.Cursors[DragCursor];
     DImg.sizlStretch.CX:=20;
     DImg.sizlStretch.CY:=20;
     DImg.fl:=DRG_ICON {Or DRG_STRETCH};
     DImg.cxOffset:=0;
     DImg.cyOffset:=0;

     //Perform drag Operation
     hwndDrop:=DrgDrag(Handle,Form.FDragInfo^,DImg,1,VK_ENDDRAG,Nil);
     {DrgDrag returns If drag Operation Is completed}

     (* Store final drag Operation *)
     FLastDragOperation:=DragOperationFromFlag(Form.FDragInfo^.usOperation);

     WinQueryWindowProcess(Handle,apid,atid);
     WinQueryWindowProcess(hwndDrop,adrgpid,adrgtid);
     If apid=adrgpid Then //the same Application
        DragControl:=HandleToControl(hwndDrop)
     Else
        DragControl:=Nil;  //other Application

     pt:=Screen.MousePos;
     Accepted:=hwndDrop<>0;

     If Not Accepted Then
     Begin
          FLastDragOperation:=doUnknown;
          DragControl:=Nil;
     End
     Else If DragControl=Nil Then DragControl:=TControl(ExternalDragDropObject);

     DragFinished(DragControl, pt.X,pt.Y, Accepted);
     {$ENDIF}

     {$IFDEF Win32}
     DoStartDrag(WinDragDropData);
     Case WinDragDropData.RenderType Of
        drmSibylObject,drmSibyl:
        Begin
             WinDragControl:=Self;
             FDragState:=dsDragEnter;
             WinLastDrag:=Nil;
             MouseCapture:=True;
             WinUser.SetCursor(Screen.Cursors[crNoDrop{DragCursor}]);
        End;
        Else WinDragControl:=Nil;
     End; //Case
     {$ENDIF}
End;
{$HINTS ON}

Procedure TControl.DragFree;
Begin
     {$IFDEF Win32}
     WinDragControl:=Nil;
     MouseCapture:=False;
     WinUser.SetCursor(Screen.Cursors[Cursor]);
     {$ENDIF}
     {$IFDEF OS2}
     If Form.FDragControl=Nil Then Exit;  //no previous drag
     Form.FDragControl.FDragging:=False;
     Form.FDragControl.FDragState:=dsDragEnter;

     //Free DragInfo structure
     DrgDeleteDragInfoStrHandles(Form.FDragInfo^);
     DrgFreeDragInfo(Form.FDragInfo);
     Form.FDragInfo:=Nil;
     {$ENDIF}
     Form.FDragControl:=Nil;
End;


Procedure TControl.DragFinished(target:TObject; X,Y:LongInt; Accepted:Boolean);
Begin
     If Not Accepted Then DragCanceled;
     DoEndDrag(target, X,Y);

     DragFree;
End;


Procedure TControl.CanDrag(X,Y:LongInt;Var Accept:Boolean);
Begin
     If OnCanDrag <> Nil Then OnCanDrag(Self,X,Y,Accept);
End;


Procedure TControl.DoEndDrag(target:TObject; X,Y:LongInt);
Begin
     {target Koord. aufbereiten}
     If FOnEndDrag <> Nil Then FOnEndDrag(Self, target, X,Y);
End;


Procedure TControl.DragOver(Source:TObject;X,Y:LongInt;State:TDragState;Var Accept:BOolean);
Begin
     Accept := True;
     If OnDragOver <> Nil Then OnDragOver(Self,Source,X,Y,State,Accept)
     Else Accept := False;
End;


Procedure TControl.DragDrop(Source:TObject;X,Y:LongInt);
Begin
     If OnDragDrop <> Nil Then OnDragDrop(Self,Source,X,Y);
End;


Procedure TControl.DragCanceled;
Begin
End;


Procedure TControl.CreateDragCanvas;
Begin
     {$IFDEF OS2}
     FDragCanvas:=FCanvas;
     FCanvas.Create(Self);
     FCanvas.FHandle:=DrgGetPS(Handle);
     GpiCreateLogColorTable(FCanvas.FHandle,LCOL_RESET,LCOLF_RGB,0,0,Nil);

     //FCanvas.Font := FDragCanvas.Font; !!

     FCanvas.Pen.color:=clBlack;
     FCanvas.Brush.color:=clWhite;
     FCanvas.Brush.Mode:=bmOpaque;
     FCanvas.Pen.Mode:=pmCopy;
     {$ENDIF}
End;


Procedure TControl.DeleteDragCanvas;
Begin
     {$IFDEF OS2}
     DrgReleasePS(FCanvas.FHandle);
     FCanvas.FHandle:=0;
     FCanvas.Destroy;
     FCanvas:=FDragCanvas;
     {$ENDIF}
End;


{$IFDEF OS2}
Procedure TControl.WMBeginDrag(Var Msg:TMessage);
Begin
     DragInit(Self, MausPosFromParam(Msg.Param1));

     Msg.Handled:=True;
     Msg.Result:=1;
End;

Procedure TControl.WMEndDrag(Var Msg:TMessage);
Var  pt:TPoint;
Begin
     If FDragMode=dmAutomatic Then
     Begin
          pt:=Screen.MousePos;
          DragFinished(Nil,pt.X,pt.Y,False);
     End;
     Msg.Handled:=True;
     Msg.Result:=1;
End;

Function GetDragSource(Var Msg:TMessage;Var DragInfo:PDRAGINFO;
                       Var DragDropData:TDragDropData;Var DragSource:TObject;
                       ItemIndex:LongInt):Boolean;
Var
   DRAGITEM:PDragItem;
   apsz:Cstring;
   flResult:Boolean;
Label ex;
Begin
     Result:=False;
     DragSource:=Nil;
     DragInfo:=Pointer(Msg.Param1);
     If Not DrgAccessDragInfo(DragInfo) Then Exit;
     If DragInfo^.cdItem=0 Then Goto ex;
     DRAGITEM:=DrgQueryDragitemPtr(DragInfo^,ItemIndex);
     If DRAGITEM=Nil Then Goto ex;

     FillChar(DragDropData,SizeOf(DragDropData),0);
     DragDropData.SourceWindow:=DragInfo^.HwndSource;
     apsz:='DRT_SIBYLOBJECT'+tohex(AppHandle);
     flResult:=DrgVerifyTrueType(DRAGITEM^,apsz);
     If flResult Then
     Begin
          DragSource:=TObject(DRAGITEM^.ulItemID);
          With DragDropData Do
          Begin
               SourceType:=drtSibylObject;
               RenderType:=drmSibylObject;
               DragSource:=TControl(DRAGITEM^.ulItemID);
          End;
     End
     Else
     Begin
          apsz:='DRT_SIBYL';
          DragDropData.SourceString:=apsz;
          flResult:=DrgVerifyTrueType(DRAGITEM^,apsz);
          If flResult Then
          Begin
               With DragDropData Do
               Begin
                   SourceType:=drtSibyl;
                   RenderType:=drmSibyl;
                   DragDropData.RenderString:='DRM_SIBYL';
               End;
          End
          Else
          Begin
               flResult:=DrgQueryNativeRMF(DRAGITEM^,255,apsz);
               DragDropData.RenderString:=apsz;
               If ((flResult)And(Pos('DRM_OS2FILE',apsz) <> 0)) Then
               Begin
                    DragDropData.RenderType:=drmFile;
                    apsz:='DRT_TEXT'; {oder Plain Text, ...}
                    If DrgVerifyTrueType(DRAGITEM^,apsz) Then
                    Begin
                         DragDropData.SourceType:=drtText;
                         DragDropData.SourceString:=apsz;
                    End
                    Else DragDropData.SourceType:=drtBinData;
               End
               Else If ((flResult)And(Pos('DRM_OS2FILE',apsz) <> 0)) Then
               Begin
                    DragDropData.RenderType:=drmPrint;
                    apsz:='DRT_TEXT';
                    If DrgVerifyTrueType(DRAGITEM^,apsz) Then
                    Begin
                         DragDropData.SourceType:=drtText;
                         DragDropData.SourceString:=apsz;
                    End
                    Else DragDropData.SourceType:=drtBinData;
               End
               Else If flResult Then
               Begin
                    With DragDropData Do
                    Begin
                         RenderType:=drmString;
                         DragDropData.RenderString:=apsz;
                         If DrgQueryTrueType(DRAGITEM^,255,apsz) Then
                         Begin
                              SourceType:=drtString;
                              SourceString:=apsz;
                         End
                         Else flResult:=False;
                    End;
               End;
          End;
     End;

     Result:=flResult;

     If Result Then With DragDropData Do
     Begin
          DrgQueryStrName(DRAGITEM^.hstrContainerName,255,apsz);
          ContainerName:=apsz;
          DrgQueryStrName(DRAGITEM^.hstrSourceName,255,apsz);
          SourceFileName:=apsz;
          DrgQueryStrName(DRAGITEM^.hstrTargetName,255,apsz);
          TargetFileName:=apsz;
          SupportedOps:=DragSupportFromFlags(DRAGITEM^.fsSupportedOps);
          DragOperation:=DragOperationFromFlag(DragInfo^.usOperation);
          ItemId:=DRAGITEM^.ulItemID;
     End;
ex:
     DrgFreeDragInfo(DragInfo);
End;

Procedure TControl.DMDragOver(Var Msg:TMessage);
Var
   Accept:Boolean;
   DragSource:TObject;
   pt:TPoint;
   DragInfo:PDRAGINFO;
   DragDropData:TDragDropData;
   Ok:Boolean;
Begin
     Ok:=GetDragSource(Msg,DragInfo,DragDropData,DragSource,0);
     pt:=MausPosFromParam(Msg.Param2);
     WinMapWindowPoints(HWND_DESKTOP,Handle,pt,1);

     Msg.Handled:=True;
     Accept:=False;

     If Ok Then  //Rendering Type Accepted
     Begin
          If DragSource=Nil Then
          Begin
               ExternalDragDropObject.FDragDropData:=DragDropData;
               DragSource:=TObject(ExternalDragDropObject);
          End;
          DragOver(DragSource,pt.X,pt.Y,FDragState,Accept);
          FDragState:=dsDragMove;
     End;

     If Accept Then Msg.Result:=MRFROM2SHORT(DOR_DROP,DO_UNKNOWN)
     Else Msg.Result:=MPFROM2SHORT(DOR_NODROP,DO_UNKNOWN);
     //If we return DOR_NEVERDROP, the Window will Not Get DragOver Messages anymore
End;

Procedure TControl.DMDragLeave(Var Msg:TMessage);
Var
   Accept:Boolean;
   DragSource:TObject;
   pt:TPoint;
   DragInfo:PDRAGINFO;
   DragDropData:TDragDropData;
   Ok:Boolean;
Begin
     Ok:=GetDragSource(Msg,DragInfo,DragDropData,DragSource,0);
     pt:=Screen.MousePos;
     WinMapWindowPoints(HWND_DESKTOP,Handle,pt,1);

     Msg.Handled:=True;
     Accept:=False;

     If Ok Then  //Rendering Type Accepted
     Begin
          If DragSource=Nil Then
          Begin
               ExternalDragDropObject.FDragDropData:=DragDropData;
               DragSource:=TObject(ExternalDragDropObject);
          End;

          FDragState:=dsDragEnter;
          DragOver(DragSource,pt.X,pt.Y,dsDragLeave,Accept);
     End;

     If Accept Then Msg.Result:=MRFROM2SHORT(DOR_DROP,DO_COPY)
     Else Msg.Result:=MPFROM2SHORT(DOR_NEVERDROP,DO_UNKNOWN);
End;

Procedure TControl.DMDrop(Var Msg:TMessage);
Var
   DragSource:TObject;
   pt:TPoint;
   DragInfo:PDRAGINFO;
   DRAGITEM:PDragItem;
   DragDropData:TDragDropData;
   Ok:Boolean;
   hwndItem:HWND;
   ulItemID:LongWord;
   ItemCount,T:LongWord;
Begin
     Ok:=GetDragSource(Msg,DragInfo,DragDropData,DragSource,0);
     pt:=Screen.MousePos;
     WinMapWindowPoints(HWND_DESKTOP,Handle,pt,1);

     Msg.Handled:=True;

     If DragInfo<>Nil Then
     Begin
          If DrgAccessDragInfo(DragInfo) Then
          Begin
               If DragInfo^.cdItem>0 Then
               Begin
                    ItemCount:=DragInfo^.cdItem;
                    DRAGITEM:=DrgQueryDragitemPtr(DragInfo^,0);
                    hwndItem:=DRAGITEM^.hwndItem;
                    ulItemID:=DRAGITEM^.ulItemID;
               End
               Else DRAGITEM:=Nil;
               DrgFreeDragInfo(DragInfo);
          End
          Else DRAGITEM:=Nil;
     End
     Else DRAGITEM:=Nil;
     If DRAGITEM=Nil Then Exit;

     If Ok Then  {Rendering Type Accepted}
     Begin
          FDragState:=dsDragEnter;
          For T:=1 To ItemCount Do
          Begin
               If GetDragSource(Msg,DragInfo,DragDropData,DragSource,T-1) Then
               Begin
                    If DragSource=Nil Then
                    Begin
                         ExternalDragDropObject.FDragDropData:=DragDropData;
                         DragSource:=TObject(ExternalDragDropObject);
                    End;

                    DragDrop(DragSource,pt.X,pt.Y);

                    If DrgAccessDragInfo(DragInfo) Then
                    Begin
                         DRAGITEM:=DrgQueryDragitemPtr(DragInfo^,T-1);
                         If DRAGITEM<>Nil Then
                         Begin
                              hwndItem:=DRAGITEM^.hwndItem;
                              {If Ok Then}
                              DrgSendTransferMsg(hwndItem,
                                                 DM_ENDCONVERSATION,
                                                 MPFROMLONG(ulItemID),
                                                 MPFROMLONG(DMFL_TARGETSUCCESSFUL));
                              {Else
                              DrgSendTransferMsg(hwndItem,
                                                 DM_ENDCONVERSATION,
                                                 MPFROMLONG(ulItemID),
                                                 MPFROMLONG(DMFL_TARGETFAIL));}
                         End;
                         DrgFreeDragInfo(DragInfo);
                    End;
               End;
          End;
     End
     Else
     Begin
          DrgSendTransferMsg(hwndItem,
                             DM_ENDCONVERSATION,
                             MPFROMLONG(ulItemID),
                             MPFROMLONG(DMFL_TARGETFAIL));
     End;
End;
{$ENDIF}


{creates AChild Window If its phys. Parent Is created}
Procedure TControl.InsertControl(AChild:TControl);
Begin
     InsertChild(AChild); {Insert AChild In Some lists}

     AChild.Perform(CM_PARENTFONTCHANGED,0,0);
     AChild.Perform(CM_PARENTPENCOLORCHANGED,0,0);
     AChild.Perform(CM_PARENTCOLORCHANGED,0,0);

     If Handle <> 0 Then
     Begin
          If Not (AChild.FIsToolBar) Then
          Begin
               AChild.CreateWnd;
               If AChild.FVisible Or AChild.Designed Then AChild.Show;
          End;
     End
     Else FInitControls := True;
End;


Procedure TControl.InsertChild(AChild:TControl);
Begin
     ListAdd(FControls, AChild);
     If Not (csReferenceControl In AChild.ComponentState) Then ListAdd(FTabList, AChild);
     AChild.FParent := Self;

     AChild.FForm := GetParentForm(Self);  {allows fast access To the Form}
End;


Procedure TControl.RemoveControl(AChild:TControl);  {call by SetParent(Nil)}
Begin
     {removefocus}
     AChild.DestroyHandle;

     Remove(AChild);  {Delete AChild from Some lists}
End;


Procedure TControl.Remove(AChild:TControl);
Begin
     ListRemove(FTabList, AChild);
     ListRemove(FControls, AChild);
     AChild.FParent := Nil;
End;


Procedure TControl.SetParent(AParent:TControl);
Begin
     If FParent <> AParent Then
     Begin
          If AParent = Self Then Exit;
          If FParent <> Nil Then FParent.RemoveControl(Self);
          If AParent <> Nil Then AParent.InsertControl(Self);
     End;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TScrollBar Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TScrollBar.GetClassData(Var ClassData:TClassData);
Begin
     Inherited GetClassData(ClassData);

     {$IFDEF Win32}
     CreateSubClass(ClassData,'SCROLLBAR');
     {$ENDIF}
     {$IFDEF OS2}
     ClassData.ClassULong := WC_SCROLLBAR;
     {$ENDIF}
End;

Procedure TScrollBar.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'ScrollBar';
     Height := Screen.SystemMetrics(smCyHScroll);
     Width := 100;
     FOwnerDraw := False;
     color := clScrollbar;
     ParentFont := False;
     ParentPenColor := False;
     ParentColor := False;

     FKind := sbHorizontal;
     FSmallChange := 1;
     FLargeChange := 1;
     FMin := 0;
     FMax := 100;
     FSliderSize := 1;
     FPosition := 0;
     FCalcRange := FMax - FSliderSize + 1;
     FTabStop := false;
End;


Procedure TScrollBar.CreateParams(Var Params:TCreateParams);
Begin
     Inherited CreateParams(Params);

     If FKind = sbHorizontal
     Then Params.Style := Params.Style Or SBS_HORZ
     Else Params.Style := Params.Style Or SBS_VERT;
End;

Procedure TScrollBar.SetupShow;
Begin
     Inherited SetupShow;

     SetScrollRange(FMin,FMax,FSliderSize);
End;

Procedure TScrollBar.SetPenColor(NewColor:TColor);
Begin
     TControl.SetPenColor(NewColor);
     TControl.SetColor(NewColor);
End;

Procedure TScrollBar.SetColor(NewColor:TColor);
Begin
     TControl.SetPenColor(NewColor);
     TControl.SetColor(NewColor);
End;

Procedure TScrollBar.SetKind(NewKind:TScrollBarKind);
Begin
     If FKind <> NewKind Then
     Begin
          If NewKind = sbHorizontal Then
          Begin
               FWidth := FHeight;
               FHeight := Screen.SystemMetrics(smCyHScroll)
          End
          Else
          Begin
               FHeight := FWidth;
               FWidth := Screen.SystemMetrics(smCxVScroll);
          End;
          FKind := NewKind;
          RecreateWnd;
     End;
End;

Procedure TScrollBar.SetPosition(NewPosition:LongInt);
Begin
     If NewPosition < FMin Then NewPosition := FMin;
     If NewPosition > FCalcRange Then NewPosition := FCalcRange;

     FPosition := NewPosition;

     If Handle = 0 Then Exit;
     {transform}
     NewPosition := Round((NewPosition - FMin) / FScale);

     If FScale > 1 Then  {Handle Special cases}
     Begin
          If FPosition = FMin Then NewPosition := 0
          Else
          If NewPosition = 0 Then NewPosition := 1  {still Enable Left Scroll}
          Else
          If FPosition = FCalcRange Then NewPosition := lastpos
          Else
          If NewPosition = lastpos Then NewPosition := lastpos - 1;
     End;

     {$IFDEF OS2}
     If WinSendMsg(Handle,SBM_QUERYPOS,0,0) <> NewPosition
     Then WinSendMsg(Handle,SBM_SETPOS,NewPosition,0);
     {$ENDIF}
     {$IFDEF Win32}
     If WinUser.GetScrollPos(Handle,SB_CTL) <> NewPosition
     Then  WinUser.SetScrollPos(Handle,SB_CTL,NewPosition,True);
     {$ENDIF}
End;

Procedure TScrollBar.SetMin(NewMin:LongInt);
Begin
     If NewMin > FMax Then Exit;
     SetScrollRange(NewMin,FMax,FSliderSize);
     If FControl<>Nil Then
       If FControl.AutoScroll Then
       Begin
            If Min<0 Then
              If FHandle<>0 Then Show;
       End;
End;

Procedure TScrollBar.SetMax(NewMax:LongInt);
Begin
     If NewMax < FMin Then Exit;
     SetScrollRange(FMin,NewMax,FSliderSize);
     If FControl<>Nil Then
       If FControl.AutoScroll Then
       Begin
            If Kind=sbHorizontal Then
            Begin
                 If Max>FControl.ClientWidth Then
                   If FHandle<>0 Then Show;
            End
            Else
            Begin
                 If Max>FControl.ClientHeight Then
                   If FHandle<>0 Then Show;
            End;
       End;
End;

Procedure TScrollBar.SetSliderSize(NewSliderSize:LongInt);
Begin
     If NewSliderSize < 1 Then Exit;
     SetScrollRange(FMin,FMax,NewSliderSize);
End;

Procedure TScrollBar.SetScrollRange(aMin,aMax,aSliderSize:LongInt);
Var  APos:LongInt;
     {$IFDEF Win32}
     ScrollInfo:TScrollInfo;
     {$ENDIF}
Begin
     If aMin > aMax Then Exit;
     If aSliderSize < 1 Then Exit;

     FMin := aMin;
     FMax := aMax;
     FSliderSize := aSliderSize;
     FCalcRange := FMax - FSliderSize + 1;
     If FCalcRange < 0 Then FCalcRange := 0;
     FScale := 1;

     If Handle = 0 Then Exit;
     {transform}
     If FMax - FMin > MaxInt Then FScale := (FMax - FMin) / (MaxInt - 1);
     APos := Round((FPosition - FMin) / FScale);
     aMin := Round((FMin - FMin) / FScale);
     aMax := Trunc((FMax - FMin) / FScale);
     aSliderSize := Round(FSliderSize / FScale);

     lastpos := aMax - aSliderSize + 1;
     {$IFDEF OS2}
     WinSendMsg(Handle,SBM_SETSCROLLBAR, APos, MAKELONG(aMin,lastpos));
     WinSendMsg(Handle,SBM_SETTHUMBSIZE, MAKELONG(aSliderSize,aMax-aMin+1), 0);
     {$ENDIF}
     {$IFDEF Win32}
     ScrollInfo.cbSize := SizeOf(ScrollInfo);
     ScrollInfo.fMask := SIF_ALL;
     ScrollInfo.nMin := aMin;
     ScrollInfo.nMax := aMax;
     ScrollInfo.nPage := aSliderSize;
     ScrollInfo.nPos := APos;
     ScrollInfo.nTrackPos := APos;
     SetScrollInfo(Handle, SB_CTL, ScrollInfo, True);
     {$ENDIF}

     SetPosition(FPosition);
End;

Procedure TScrollBar.SetParams(aPosition,aMin,aMax:LongInt);
Begin
     SetScrollRange(aMin,aMax,FSliderSize);
     SetPosition(aPosition);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TControlScrollBar Class Implementation                      บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TControlScrollBar.SetupComponent;
Begin
    Inherited SetupComponent;
    Exclude(ComponentState,csHandleLinks);
    SmallChange:=5;
    LargeChange:=10;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TScrollingWinControl Class Implementation                   บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TScrollingWinControl.SetupComponent;
Begin
     Inherited SetupComponent;

     FScrollBars := ssNone;
     FAutoScroll := True;
     FHorzScrollBar := Nil;
     FVertScrollBar := Nil;
     FHMin:=0;
     FHMax:=Width;
     FHPos:=0;
     FHLargeChange:=10;
     FHSmallChange:=5;
     FHColor:=clScrollBar;
     FHSliderSize:=1;
     FVMin:=0;
     FVMax:=Height;
     FVPos:=0;
     FVLargeChange:=10;
     FVSmallChange:=5;
     FVColor:=clScrollBar;
     FVSliderSize:=1;
End;


Procedure TScrollingWinControl.SetupShow;
Begin
     Inherited SetupShow;

     SetScrollBars(FScrollBars);
End;


Procedure TScrollingWinControl.ScrollInView(AControl:TControl);
Var rc:TRect;
Begin
     If ((AControl=Nil)Or(AControl.Parent<>Self)) Then exit;
     rc:=AControl.ClientRect;

     If rc.Left<0 Then
     Begin
          If FHorzScrollBar<>Nil Then
            FHorzScrollBar.Position:=FHorzScrollBar.Position-rc.Left;
          AControl.Left:=0;
     End
     Else If rc.Right>ClientWidth Then
     Begin
          If FHorzScrollBar<>Nil Then
            FHorzScrollBar.Position:=FHorzScrollBar.Position-(ClientWidth-rc.Right);
          rc.Left:=rc.Left-(ClientWidth-rc.Right);
     End;

     If rc.Bottom<0 Then
     Begin
          If FVertScrollBar<>Nil Then
            FVertScrollBar.Position:=FVertScrollBar.Position-rc.Bottom;
          AControl.Bottom:=0;
     End
     Else If rc.Top>ClientHeight Then
     Begin
          If FVertScrollBar<>Nil Then
            FVertScrollBar.Position:=FVertScrollBar.Position-(ClientHeight-rc.Top);
          rc.Bottom:=rc.Bottom-(ClientHeight-rc.Top);
     End;
End;


Procedure TScrollingWinControl.Resize;
Begin
     Inherited Resize;

     AdjustScrollbars;
     AlignScrollbars;
End;


Destructor TScrollingWinControl.Destroy;
Begin
     If FHorzScrollBar <> Nil Then
     Begin
          FHorzScrollBar.Destroy;
          FHorzScrollBar := Nil;
     End;
     If FVertScrollBar <> Nil Then
     Begin
          FVertScrollBar.Destroy;
          FVertScrollBar := Nil;
     End;

     Inherited Destroy;
End;


Procedure TScrollingWinControl.Paint(Const rec:TRect);
Var  rc:TRect;
Begin
     Inherited Paint(rec);

     If (FHorzScrollBar <> Nil) And (FVertScrollBar <> Nil) Then
       If ((FHorzScrollBar.Visible)And(FVertScrollBar.Visible)) Then
     Begin
          rc := GetClientRect;
          rc.Left := rc.Right - FVertScrollBar.Width +1;
          rc.Top := rc.Bottom + FHorzScrollBar.Height -1;
          FCanvas.FillRect(rc, clLtGray);
     End;
End;


Procedure TScrollingWinControl.SetAutoScroll(NewValue:Boolean);
Begin
     If FAutoScroll <> NewValue Then
     Begin
          FAutoScroll := NewValue;
          If Not FAutoScroll Then
          Begin
               AlignScrollbars;
               If FHorzScrollbar <> Nil Then FHorzScrollbar.Show;
               If FVertScrollbar <> Nil Then FVertScrollbar.Show;
          End
          Else SetScrollBars(ssBoth);
     End;
End;


Procedure TScrollingWinControl.SetScrollBars(NewValue:TScrollStyle);
Var  t:LongInt;
     Control:TControl;
Begin
     If FAutoScroll Then NewValue := ssBoth;

     FScrollBars := NewValue;
     If Handle = 0 Then Exit;

     {Delete}
     If NewValue In [ssNone,ssHorizontal] Then
     Begin
          If FVertScrollBar <> Nil Then
          Begin
               FVertScrollBar.Destroy;
               FVertScrollBar := Nil;
          End;
     End;

     If NewValue In [ssNone,ssVertical] Then
     Begin
          If FHorzScrollBar <> Nil Then
          Begin
               FHorzScrollBar.Destroy;
               FHorzScrollBar := Nil;
          End;
     End;

     If NewValue <> ssNone Then
     Begin
          For t:=0 To ControlCount-1 Do
          Begin
               Control:=Controls[t];
               If Control<>FVertScrollBar Then
                 If Control<>FHorzScrollBar Then Control.ZOrder:=zoBottom;
          End;
     End;

     {Create}
     If NewValue In [ssHorizontal,ssBoth] Then
       If FHorzScrollBar = Nil Then
       Begin
            FHorzScrollBar.Create(Self);
            FHorzScrollBar.FControl:=Self;
            Exclude(FHorzScrollBar.ComponentState, csHandleLinks);
            FHorzScrollBar.HandlesDesignMouse:=True;
            FHorzScrollBar.Min:=FHMin;
            FHorzScrollBar.Max:=FHMax;
            FHorzScrollBar.Position:=FHPos;
            FHorzScrollBar.LargeChange:=FHLargeChange;
            FHorzScrollBar.SmallChange:=FHSmallChange;
            FHorzScrollBar.Color:=FHColor;
            FHorzScrollBar.SliderSize:=FHSliderSize;
            FHorzScrollBar.Kind := sbHorizontal;
            Include(FHorzScrollBar.ComponentState, csDetail);
            FHorzScrollBar.SetDesigning(False); {!}
            If AutoScroll Then FHorzScrollBar.Hide;
            //FHorzScrollBar.SetDesigning(Designed);
            FHorzScrollBar.Parent := Self;
       End;

     If NewValue In [ssVertical,ssBoth] Then
       If FVertScrollBar = Nil Then
       Begin
            FVertScrollBar.Create(Self);
            FVertScrollBar.FControl:=Self;
            FVertScrollBar.HandlesDesignMouse:=True;
            FVertScrollBar.Min:=FVMin;
            FVertScrollBar.Max:=FVMax;
            FVertScrollBar.Position:=FVPos;
            FVertScrollBar.LargeChange:=FVLargeChange;
            FVertScrollBar.SmallChange:=FVSmallChange;
            FVertScrollBar.Color:=FVColor;
            FVertScrollBar.SliderSize:=FVSliderSize;
            FVertScrollBar.Kind := sbVertical;
            Include(FVertScrollBar.ComponentState, csDetail);
            FVertScrollBar.SetDesigning(False); {!}
            If AutoScroll Then FVertScrollBar.Hide;
            //FVertScrollBar.SetDesigning(Designed);
            FVertScrollBar.Parent := Self;
       End;

     AdjustScrollbars;
     AlignScrollbars;

     {Update Children}
     If Not FFirstShow Then RealignControls;
End;


{$HINTS OFF}
Procedure TScrollingWinControl.Scroll(Sender:TScrollBar;ScrollCode:TScrollCode;Var ScrollPos:LongInt);
Var  Control:TControl;
     t:Longint;
Begin
     If (Sender = FVertScrollBar) Or (Sender = FHorzScrollBar) Then
       If ScrollCode In [scHorzEndScroll,scVertEndScroll,scHorzPosition,scVertPosition] Then
     Begin
          If FAutoScroll Then
          Begin
               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,False);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,0,0);
               {$ENDIF}

               FIgnoreAdjust := True;
               If Sender=FVertScrollBar Then
               Begin
                    For t:=0 To ControlCount-1 Do
                    Begin
                        Control:=Controls[t];
                        If Control<>FVertScrollBar Then
                          If Control<>FHorzScrollBar Then
                          Begin
                               Control.ZOrder:=zoBottom;
                               Control.Bottom:=Control.Bottom+(ScrollPos-FVPos);
                          End;
                    End;
                    FVPos:=ScrollPos;
               End;

               If Sender=FHorzScrollBar Then
               Begin
                    For t:=0 To ControlCount-1 Do
                    Begin
                        Control:=Controls[t];
                        If Control<>FVertScrollBar Then
                          If Control<>FHorzScrollBar Then
                          Begin
                               Control.ZOrder:=zoBottom;
                               Control.Left:=Control.Left-(ScrollPos-FHPos);
                          End;
                    End;
                    FHPos:=ScrollPos;
               End;
               FIgnoreAdjust := False;

               {$IFDEF OS2}
               WinEnableWindowUpdate(Handle,True);
               {$ENDIF}
               {$IFDEF Win95}
               SendMessage(Handle,WM_SETREDRAW,1,0);
               {$ENDIF}
               Invalidate;

               If Designed Then Form.Invalidate;
          End;

          CaptureFocus;
     End;
End;
{$HINTS ON}


Procedure TScrollingWinControl.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Type TScrollExtents=Record
                         VMin,VMax:LongInt;
                         HMin,HMax:LongInt;
                         VPos,HPos:LongInt;
                         VLargeChange,VSmallChange:LongInt;
                         HLargeChange,HSmallChange:LongInt;
                         VColor,HColor:TColor;
                         VSliderSize,HSliderSize:LongInt;
                   End;
     PScrollExtents=^TScrollExtents;
Var ScrollExtents:PScrollExtents;
Begin
     If ResName = rnScrollExtents Then
     Begin
          If DataLen <> 0 Then
          Begin
               ScrollExtents:=@Data;
               If FVertScrollBar<>Nil Then
               Begin
                    FVertScrollBar.Min:=ScrollExtents^.VMin;
                    FVertScrollBar.Max:=ScrollExtents^.VMax;
                    FVertScrollBar.Position:=ScrollExtents^.VPos;
                    FVertScrollBar.LargeChange:=ScrollExtents^.VLargeChange;
                    FVertScrollBar.SmallChange:=ScrollExtents^.VSmallChange;
                    FVertScrollBar.Color:=ScrollExtents^.VColor;
                    FVertScrollBar.SliderSize:=ScrollExtents^.VSliderSize;
               End
               Else
               Begin
                    FVMin:=ScrollExtents^.VMin;
                    FVMax:=ScrollExtents^.VMax;
                    FVPos:=ScrollExtents^.VPos;
                    FVLargeChange:=ScrollExtents^.VLargeChange;
                    FVSmallChange:=ScrollExtents^.VSmallChange;
                    FVColor:=ScrollExtents^.VColor;
                    FVSliderSize:=ScrollExtents^.VSliderSize;
               End;
               If FHorzScrollBar<>Nil Then
               Begin
                    FHorzScrollBar.Min:=ScrollExtents^.HMin;
                    FHorzScrollBar.Max:=ScrollExtents^.HMax;
                    FHorzScrollBar.Position:=ScrollExtents^.HPos;
                    FHorzScrollBar.LargeChange:=ScrollExtents^.HLargeChange;
                    FHorzScrollBar.SmallChange:=ScrollExtents^.HSmallChange;
                    FHorzScrollBar.Color:=ScrollExtents^.HColor;
                    FHorzScrollBar.SliderSize:=ScrollExtents^.HSliderSize;
               End
               Else
               Begin
                    FHMin:=ScrollExtents^.HMin;
                    FHMax:=ScrollExtents^.HMax;
                    FHPos:=ScrollExtents^.HPos;
                    FHLargeChange:=ScrollExtents^.HLargeChange;
                    FHSmallChange:=ScrollExtents^.HSmallChange;
                    FHColor:=ScrollExtents^.HColor;
                    FHSliderSize:=ScrollExtents^.HSliderSize;
               End;
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen)
End;


Function TScrollingWinControl.WriteSCUResource(Stream:TResourceStream):Boolean;
Var ScrollExtents:Record
                         VMin,VMax:LongInt;
                         HMin,HMax:LongInt;
                         VPos,HPos:LongInt;
                         VLargeChange,VSmallChange:LongInt;
                         HLargeChange,HSmallChange:LongInt;
                         VColor,HColor:TColor;
                         VSliderSize,HSliderSize:LongInt;
                  End;
Begin
     Result := Inherited WriteSCUResource(Stream);

     If Not Result Then Exit;
     If ((FVertScrollBar=Nil)And(FHorzScrollBar=Nil)) Then exit;

     If FVertScrollBar<>Nil Then
     Begin
          ScrollExtents.VMin:=FVertScrollBar.Min;
          ScrollExtents.VMax:=FVertScrollBar.Max;
          ScrollExtents.VPos:=FVertScrollBar.Position;
          ScrollExtents.VLargeChange:=FVertScrollBar.LargeChange;
          ScrollExtents.VSmallChange:=FVertScrollBar.SmallChange;
          ScrollExtents.VColor:=FVertScrollBar.Color;
          ScrollExtents.VSliderSize:=FVertScrollBar.SliderSize;
     End
     Else
     Begin
          ScrollExtents.VMin:=0;
          ScrollExtents.VMax:=100;
          ScrollExtents.VPos:=0;
          ScrollExtents.VLargeChange:=10;
          ScrollExtents.VSmallChange:=5;
          ScrollExtents.VColor:=clScrollBar;
          ScrollExtents.VSliderSize:=1;
     End;

     If FHorzScrollBar<>Nil Then
     Begin
          ScrollExtents.HMin:=FHorzScrollBar.Min;
          ScrollExtents.HMax:=FHorzScrollBar.Max;
          ScrollExtents.HPos:=FHorzScrollBar.Position;
          ScrollExtents.HLargeChange:=FHorzScrollBar.LargeChange;
          ScrollExtents.HSmallChange:=FHorzScrollBar.SmallChange;
          ScrollExtents.HColor:=FHorzScrollBar.Color;
          ScrollExtents.HSliderSize:=FHorzScrollBar.SliderSize;
     End
     Else
     Begin
          ScrollExtents.HMin:=0;
          ScrollExtents.HMax:=100;
          ScrollExtents.HPos:=0;
          ScrollExtents.HLargeChange:=10;
          ScrollExtents.HSmallChange:=5;
          ScrollExtents.HColor:=clScrollBar;
          ScrollExtents.HSliderSize:=1;
     End;

     Result := Stream.NewResourceEntry(rnScrollExtents,ScrollExtents,sizeof(ScrollExtents));
End;


Procedure TScrollingWinControl.RemoveControl(AChild:TControl);
Begin
     Inherited RemoveControl(AChild);

     If AChild <> FHorzScrollbar Then
       If AChild <> FVertScrollbar Then
       Begin
            AdjustScrollbars;
            AlignScrollbars;
       End;
End;


Procedure TScrollingWinControl.InsertControl(AChild:TControl);
Begin
     Inherited InsertControl(AChild);

     If AChild <> FHorzScrollbar Then
       If AChild <> FVertScrollbar Then
       Begin
            AdjustScrollbars;
            AlignScrollbars;
       End;
End;


Procedure TScrollingWinControl.AdjustScrollbars;
Var  i,horzmax,vertmax:Longint;
     Control:TControl;
     OldIgnoreAdjust:Boolean;
     HorzIsVisible,VertIsVisible:Boolean;
     hpos,vpos:Longint;
Begin
     If FIgnoreAdjust Then exit;

     OldIgnoreAdjust := FIgnoreAdjust;
     FIgnoreAdjust := True;

     If FAutoScroll And
       (FHorzScrollBar <> Nil) And (FVertScrollBar <> Nil) Then
     Begin
          horzmax := 0;
          vertmax := ClientHeight;

          hpos := FHorzScrollbar.Position;
          vpos := FVertScrollbar.Position;

          For i := 0 To ControlCount-1 Do
          Begin
               Control := Controls[i];
               If Control <> FHorzScrollBar Then
                 If Control <> FVertScrollBar Then
                 Begin
                      If Control.Left + Control.Width + hpos > horzmax
                        Then horzmax := Control.Left + Control.Width + hpos;
                      If Control.Bottom - vpos < vertmax
                        Then vertmax := Control.Bottom - vpos;
                 End;
          End;

          If vertmax < 0 Then // vertscroll is visible
          Begin
               inc(horzmax, FVertScrollbar.Width);
               If horzmax > ClientWidth Then dec(vertmax, FHorzScrollbar.Height);
          End
          Else
          Begin
               If horzmax > ClientWidth Then // horzscroll is visible
               Begin
                    dec(vertmax, FHorzScrollbar.Height);
                    If vertmax < 0 Then inc(horzmax, FVertScrollbar.Width);
               End;
          End;


          //show or hide Scrollbars
          FHorzScrollBar.SetScrollRange(0,horzmax,ClientWidth);
          //FHPos := FHorzScrollBar.Position;

          HorzIsVisible := horzmax > ClientWidth;
          If HorzIsVisible Then FHorzScrollBar.Show
          Else FHorzScrollBar.Hide;


          FVertScrollBar.SetScrollRange(0,ClientHeight-vertmax,ClientHeight);
          //FVPos := FVertScrollBar.Position;

          VertIsVisible := vertmax < 0;
          If VertIsVisible Then FVertScrollBar.Show
          Else FVertScrollBar.Hide;


          If horzmax - hpos < ClientWidth Then
          Begin
               hpos := FHorzScrollBar.Position;
               Scroll(FHorzScrollbar, scHorzPosition, hpos);
          End;

          If vertmax + vpos > 0 Then
          Begin
               vpos := FVertScrollBar.Position;
               Scroll(FVertScrollbar, scVertPosition, vpos);
          End;
     End;

     FIgnoreAdjust := OldIgnoreAdjust;
End;


Procedure TScrollingWinControl.AlignScrollbars;
Var  HorzIsVisible,VertIsVisible:Boolean;
     OldIgnoreAdjust:Boolean;
     rc:TRect;
Begin
     If FIgnoreAdjust Then exit;

     OldIgnoreAdjust := FIgnoreAdjust;
     FIgnoreAdjust := True;

     If FAutoScroll Then
     Begin
          If FHorzScrollBar = Nil Then HorzIsVisible := False
          Else HorzIsVisible := FHorzScrollBar.Max > ClientWidth;

          If FVertScrollBar = Nil Then VertIsVisible := False
          Else VertIsVisible := FVertScrollBar.Max > ClientHeight;
     End
     Else
     Begin
          HorzIsVisible := FHorzScrollBar <> Nil;
          VertIsVisible := FVertScrollBar <> Nil;
     End;

     If FHorzScrollBar <> Nil Then
     Begin
          rc := GetClientRect;

          If VertIsVisible Then dec(rc.Right,FVertScrollBar.Width-1);

          FHorzScrollBar.SetWindowPos(rc.Left,rc.Bottom,
                            rc.Right-rc.Left+1,FHorzScrollBar.Height);
          FHorzScrollBar.FFirstShow := False;
     End;

     If FVertScrollBar <> Nil Then
     Begin
          rc := GetClientRect;

          If HorzIsVisible Then inc(rc.Bottom,FHorzScrollBar.Height);

          FVertScrollBar.SetWindowPos(rc.Right+1-FVertScrollBar.Width,rc.Bottom,
                            FVertScrollBar.Width,rc.Top-rc.Bottom+1);
          FVertScrollBar.FFirstShow := False;
     End;

     FIgnoreAdjust := OldIgnoreAdjust;
End;


Procedure TScrollingWinControl.Loaded;
Begin
     Inherited Loaded;

     If FHorzScrollbar <> Nil Then FHPos := FHorzScrollbar.Position;
     If FVertScrollbar <> Nil Then FVPos := FVertScrollbar.Position;
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TScrollBox Class Implementation                             บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TScrollBox.SetBorderStyle(NewValue:TBorderStyle);
Begin
     If NewValue=FBorderStyle Then exit;
     FBorderStyle:=NewValue;
     Invalidate;
End;

{$HINTS OFF}
Procedure TScrollBox.Redraw(Const rec:TRect);
Var rc:TRect;
Begin
     rc:=ClientRect;
     If FHorzScrollBar<>Nil Then
       If FHorzScrollBar.Visible Then inc(rc.Bottom,FHorzScrollBar.Height);
     If FVertScrollBar<>Nil Then
       If FVertScrollBar.Visible Then dec(rc.Right,FVertScrollBar.Width);
     If BorderStyle=bsSingle Then
     Begin
          FCanvas.ShadowedBorder(rc,clDkGray,clWhite);
          InflateRect(rc,-1,-1);
     End;
     Inherited Redraw(rc);
End;
{$HINTS ON}


Procedure TScrollBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name:='ScrollBox';
     AutoScroll:=True;
     Color:=clLtGray;
     FBorderStyle:=bsSingle;
     Width:=300;
     Height:=300;
     ScrollBars:=ssBoth;
     Include(ComponentState, csAcceptsControls);
End;


{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure SetupCompLib(Var Data:TCompLibData);
Begin
     Asm
        MOVB System.InheritsSoftMode,1  {!!! wegen complib.dll !!!}
        MOVB Classes.InsideDesigner,1
        MOVB Classes.InsideCompLib,1
        MOV EDI,Data
        MOV EAX,[EDI].TCompLibData.InsideWriteSCUAdr
        MOV Classes.InsideWriteSCUAdr,EAX
     End;
     HeapOrg:=Data.NewHeapOrg;
     HeapEnd:=Data.NewHeapEnd;
     HeapPtr:=Data.NewHeapPtr;
     System.HeapSize:=Data.NewHeapSize;
     {$IFDEF OS2}
     Asm
        MOV EDI,Data
        MOV EAX,[EDI].TCompLibData.NewLastHeapPage
        MOV System.LastHeapPage,EAX
        MOV EAX,[EDI].TCompLibData.NewLastHeapPageAdr
        MOV System.LastHeapPageAdr,EAX
        MOV EAX,[EDI].TCompLibData.NewHeapMutex;
        MOV System.HeapMutex,EAX
     End;
     {$ENDIF}

     // remember so we don't free PM stuff on shutdown
     InsideDesigner := true;

     // copy IDE stuff
     Screen:=Data.Screen;
     Clipboard:=Data.Clipboard;
     Application:=Data.Application;
     NullStr:=Data.NullStr;
     If RegisterToolsAPIProc<>Nil Then
     Begin
          RegisterToolsAPIProc(Data.ToolsAPI);
          Data.ToolsAPIRequired:=True;
     End
     Else Data.ToolsAPIRequired:=False;
End;


{$IFDEF OS2}
Var
    DBCSFirstBytes:Array[0..255] Of Boolean;

Function IsDBCSFirstByte(CH:Char):Boolean;
Begin
     Result := DBCSFirstBytes[Ord(CH)];
End;


Procedure InitDBCSHandling;
Var  MemBuf:Array[0..11] Of Byte;
     cc:COUNTRYCODE;
     I,First,Second:Byte;
     Font:TFont;
     dbcs:Boolean;
Begin
     dbcs := False;
     FillChar(DBCSFirstBytes[0], SizeOf(DBCSFirstBytes), 0);
     cc.country := 0;
     cc.codepage := 0;
     If DosQueryDBCSEnv(12,cc,MemBuf) = 0 Then
     Begin
          For I := 0 To 5 Do
          Begin
               First := MemBuf[2*I];
               Second := MemBuf[(2*I)+1];
               If (First = 0) And (Second = 0) Then break;
               FillChar(DBCSFirstBytes[First], Second-First+1, 1);
               dbcs := True;
          End;
     End;

     If Not dbcs Then Exit;

     {initialize DBCSStatusLineHeight}
     Font := Screen.DefaultFrameFont;
     If Font <> Nil
     Then DBCSStatusLineHeight := Font.FFontInfo.lMaxbaseLineExt +2;
End;
{$ENDIF}

{$IFDEF WIN32}
Var SA:SECURITY_ATTRIBUTES;
{$ENDIF}

Initialization
     {$IFDEF OS2}
     NewStyleControls:=False;

     {$ENDIF}
     {$IFDEF WIN32}
     NewStyleControls:=Lo(GetVersion)>=4;
     {$ENDIF}

     RegisterClasses([TControl]);

     @DdeMan_WMDDEDestroy:=Nil;
     @DdeMan_WMDdeInitiate:=Nil;
     @DdeMan_OpenClientLinks:=Nil;
     @DdeMan_CloseClientLinks:=Nil;
     @DdeMan_CloseAllLinks:=Nil;

     IconClass:=Nil;
     If ApplicationType=1 Then
     Begin
         Screen.Create(Nil);
         Clipboard.Create(Nil);
         TimerList.Create;
         New(TimerArray);
         ExternalDragDropObject.Create(Nil);
     End
     Else
     Begin
         Screen:=Nil;
         Clipboard:=Nil;
         TimerList:=Nil;
         TimerArray:=Nil;
         ExternalDragDropObject:=Nil;
     End;

     {$IFDEF OS2}
     DosCreateMutexSem(Nil,TimerMutex,DC_SEM_SHARED,False);
     InitDBCSHandling;
     {$ENDIF}
     {$IFDEF Win32}
     SA.nLength:=sizeof(SA);
     SA.lpSecurityDescriptor:=Nil;
     SA.bInheritHandle:=True;
     TimerMutex:=CreateMutex(SA,False,Nil);
     InitCommonControls;
     {$ENDIF}

Finalization
     // no need to clean up when running in IDE
     if not InsideDesigner then
     begin
          // Shutdown nicely. Some PM resources
          // will NOT be automatically freed. Eventually,
          // they would become an issue (e.g. if a PM
          // app was being repeatedly started then exited) - AaronL

          If ApplicationType=1 Then
          Begin
               // free PM resources
               Screen.Destroy;
               Clipboard.Destroy;
               TimerList.Destroy;
               Dispose(TimerArray);
               ExternalDragDropObject.Destroy;
          End;
          {$IFDEF OS2}
          DosCloseMutexSem(TimerMutex);
          {$ENDIF}
     End;
End.
