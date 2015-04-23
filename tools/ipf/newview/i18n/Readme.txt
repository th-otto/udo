NewView
-------

NewView is Copyright 1999-2006 Aaron Lawrence.
It is also licensed under the GNU Public License, which means you have
the right to obtain the source code.

Since 2006 Ronald Brill maintains the product.
NewView is a Netlabs project.
There is a project page available at http://svn.netlabs.org/newview.
Please use this page for bug reports and feature request.


NewView is a free replacement for the original OS/2 or eComStation online help system.

Major enhancements are:

- New user interface (split window)
- Select and copy direct from window
- Easy to use global (all files) search
- Remembers size & position
- Most recently used files list
- Smooth scrolling display
- Current topic always highlighted in contents
- Can go forward as well as back in history
- Options for fonts, colors and more
- Annotate help files
- Bookmarks
- Fully resizeable
- Automatic web, ftp and email links (uses default WPS browser)
- Drop files to open
- Open additional files
- Automatic language selection
- Automatic index creation
- Enhanced file dialog with help file titles


For a version history, see the file Changes.txt


Installation
------------

I suggest that you use the install.exe that comes with NewView. This is the easiest way to
do a full install. The installer also gives you the option to install NewView as a standalone
application, or replace View only. With standalone installs you still have the option to
associate NewView with help files; but note that this will NOT result in NewView being used
for many of the help icons installed by various applications, because they are often program
objects referring directly to "View.exe".
To upgrade, just install over top of the existing version, but check changes.txt to see if
there are any special notes about the new version.

eComStation v1.1 shipped with a version of NewView (the viewer only, not the full replacement).
eCS Maintenance Tool does not update it, but the NewView install is smart enough to update the
eCS copy of newview properly.

A reboot will be needed for full replacement, even on an upgrade.

After full replacement, you still have access to the old View: use IBMVIEW <filename>.

Information about manual install is given below in the Technical section.


Uninstallation
--------------

Well, there isn't one yet. (I still can't quite swallow the idea of WarpIn for some reason.)

You need to copy the backup files (.bak if you used the Install.exe) to the original filenames,
you will need to use unlock/replmod to change HelpMgr.dll or boot to a command prompt.
Specifically you need to restore x:\os2\dll\helpmgr.dll, x:\os2\view.exe and x:\os2\viewdoc.exe.

Problems
--------

If you need to report a crash or other problem, then be as specific as possible about what files
were being used, what you were doing, etc. If one is available, PLEASE include the newview.log.
The log file will be EITHER
 - in the same directory as NewView itself
 - in the folder set by LOGFILES environment variable (typically eCS 1.1+)

It may also be helpful to run newview with the /profile parameter (undocumented) and send me
the newview.prf file this produces. Especially if there is no newview.log file!

- Install will not run

renmodul.dll must be accessible. Normally this should work if you are running install from
the same directory, and . is in the libpath.

- F1 crashes the application (full install)

Although it is still possible to be NewView (actually my replacement helpmgr.dll), there was/is
a problem with the XWorkPlace Widgets library, specifically rbutton.dll or rgauge.dll; disabling
the XCenter will avoid the problem. I don't know if a fix is available yet.

- Duplicate files warning

The install warns you if the NewView programs or help files are duplicated on your system. If
you know that the duplicates are OK (for example, that you have arranged the PATH to
cater for this) then you can ignore the warning.
The main reasons you might see this:
  - You already installed to a different directory.
  - You're doing a standalone install on eCS 1.1 *
You can either delete the duplicates, or install over top of them, as you see fit.
* This problem should not come up with a full install; in that case the installer
will update the files in eCS.

- ViewHelp hangs around indefinitely.

If you use the old viewhelp.exe, e.g. the TCP/IP help icons, then you might notice viewhelp hangs
around after you close the help window. This is because it uses features of helpmgr that NewView
doesn't support. However, it doesn't seem to provide any useful features itself, so:
Workaround: copy view.exe over top of viewhelp.exe.

- IBM service program (service.exe) does not work

This is fixed in v2.13.4.

- Changing application font

If you change the application font, either from Tools - Options - Fonts, or by dropping a
font onto the main window, then you must restart before all parts of the application will use
the new font. Note if you drop fonts onto the right-hand pane where help topics are displayed,
this changes the topic font which is separate from the application font. Hold down shift
while dropping the font, in order to change the fixed-width font.

- Fonts and colors not always consistent

Some help files specify their own fonts and/or colors, in which case the defaults you select
are ignored, either partially or completely.

- IBM BookManager Reader does not work

Yet another reinvention of the wheel from IBM, I can't figure out how it uses helpmgr so
cannot support it.

- Printer setup dialog looks strange

The printer dialog has white background and version number shows as ???. I have no clue
what this is caused by, and yes I have investigated it, so please don't tell me about it,
unless you have a specific suggestion. It doesn't seem to prevent things working properly,
so it is extremely low priority.

- Printer setup dialog doesn't work

Some printer setup dialogs don't work, but I have no idea why not. The OS/2 printing API
is not well designed, so it is very difficult to work with.

- After fully replacing help, the OS/2 Tutorial does not work.

This is unlikely to be fixed in the near future as it is not part of eCS 1.1, and
uses numerous obscure features.

- The Master Help Index and Online Info Overview - Glossary icons in the Assistance Center
do not work.

These are unlikely to ever be fully fixed, but they no longer crash the desktop. Personally,
I think global search is much more useful (Tools - Search all Help Files).

- EPM help may have problems.

This is fixed in NewView 2.7 or higher, because View.exe is now a stub that immediately exits,
like the original.
Note: If you do a standalone install of NewView, but want to use it for epmhelp, you need to
update the EPM .NDX files, which contain the name of the help program to run.

- Notes are not completely predictable.

They will not be in the right position when search highlights are showing or help file is updated.
They still seem useful, and this is rather difficult to fix, so I will probably leave them as is.

- Conflict with Styler/2 (SmartWindows):

This is fixed in Styler/2 1.6.5.1 or higher. Prior to this:
If you use the "maximised windows" control, then NewView's topic windows will also be maximised,
and may be too large to view. Workaround: add view.exe and/or newview.exe to
the "exceptions" list in Styler/2 preferences.

- Unable to open files with spaces in the name from desktop:

Make sure the program object for NewView has EITHER: blank parameters; OR the parameters
field says "%*" (with quotes) NOT just %* without quotes.

- Can't run old viewer.

I recommend you use the full install, but if you don't and things get messed up, to get old view running:
1) Get a copy of the original IBM view (hopefully from backup) and copy it to
   x:\os2\ibmview.exe (x: = boot drive).
2) Get a copy of renmodul from Hobbes and put somewhere in your path.
3) Change directory to x:\os2
4) Type "renmodul /i ibmview.exe helpmgr ibmhmgr" (quotes excluded).
(From Bertie Kemp)

License
-------

As of V1.27.9, NewView is open source software under the GNU Public License (GPL), which means
(see GPL.txt for details):

This program is free software; you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program;
if not, write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Should you wish to encourage me to continue developing NewView, then you could use
PayPal (http://www.paypal.com) or similar to send me a donation!


Multi-lingual Support
---------------------

NewView can now load different languages for it's user interface, and (from v2.14) language-specific help files.

NewView looks for a file which is called 'newview_XXX.lng, where XXX is based on the LANG environment variable.
For example, on US systems LANG=EN_US so it will look for newview_en_us.lng. If it cannot find that, it tries
looking for the major part of the LANG variable, for example newview_en.lng. If it cannot find that, the default
is US English (which is built into the .EXE - you have to restart to get it back).

Normally, translations are not for a particular region, so the files that come with NewView are
just (for example) newview_es.lng, not newview_es_es.lng.

You can override the default language with the /lang:<xx> parameter, where XX is the alternative language spec.

- Where Language Files Live

Language files are searched for in (in order):
  - %OSDIR%\lang  (eCS 1.1+)
  - %ULSPATH%
  - Application directory

- Creating a new translation

You can easily create a translation file for NewView. Use Tools - Save/Update Language to create a new .lng file.
This .lng file will contain all the text items that the program uses. Translate the text and save it.

You can call the .lng file whatever you like, but follow the rules above if you want it to be loaded automatically.

If you send me your translations, I'll include them with the next release. To save wasting your time, check with
me before starting a translation, in case someone has already done one.

Notes:
~ (tilde) in the text indicates that the next letter that should be underlined and used as a hot key.
(You may also see & (ampersand) which does the same thing, but does not work quite as well - please
tell me if you see one.)

\t in the text indicates a tab character, and is used to separate a menu item from it's "accelerator" or key
combination. However, you CANNOT change the accelerator e.g. F3 for Exit by this means (or any means).
Please leave the part after \t as it is.

- Updating an existing translation

If you already have a file, that needs some updates - perhaps for a new version - then just save to the
 SAME file again. The new items needing translation will be added, and items that are no longer required removed.

Unneeded items are left at the end of the file for you to check; remove them after you've done so, to save space.
Note that sometimes items might be renamed, in this case you need to copy the old value to the new name. (Sorry!)

New items needing translation will be marked with ***

Note: unfortunately any comments etc in the file will be discarded when you save.

Multi-lingual Help Files
------------------------

Using similar logic, NewView can load a language-specific version of it's own help file. It looks for
NewView_XX.hlp, where XX is derived from LANG as for .lng files above.

For a starting point, you can take the included NewView.ipf. Note that I do NOT use this as the source;
this file is generated by VyperHelp. This file is not installed, it's just included in the zip file.


Translation Credits
-------------------

Big thanks to the following people who have submitted and updated translations:

Swedish - Simon Gronlund
German - Christian Hennecke, Chris Hellwig
Russian - Yuri Prokushev
Spanish - David Mediavilla Ezquibela, Alfredo Fernandez Diaz
French - Guillaume Gay
Korean - Tomoarai (Kazuhiko Tani), KO Myung-Hun
Japanese - Tomoarai
Czech - Michal Pohorelsky
Dutch - Dutch eComStation Test and Translation Group
Esperanto - Jonathan Moylan
Finnish - Tapani Raikkonen
Italian - Alberto Gabrielli, Gabriele Gamba

I hope I didn't miss anyone, I have got a bit confused about translations sometimes!


Support NewView
---------------

If you find NewView helpful, please let me know: rbri at rbri dot de.

Other ways to contribute make donation to Netlabs http://www.mensys.nl


Acknowledgements
----------------

This has been an ongoing effort over several years. Many people have helped out. Some people
gave actual money (around US$600 so far) to help me buy that Porsche:

Henk Pol, Moby Disk, Frederick Giroux, Jerauld Prather, Keith Oswald, Daniel Caroll,
Sten Solberg, Jason Stefanovich, Alexander Newman, Andy Willis, Richard Tennis, Gregg Young,
John F Moore, Bill Richardson, Jan Magne Landsvik, Daniela Engert, Kris Steenhaut,
Pieter Kruger Jr, Timur Tabi, Peter Gegenheimer, Gordon Snider, Doug Fitzpatrick, Simon Wright,
Aidan Grey, Julian Thomas, Philip Mann, Robert S Stan, Lionel Abrahams, Howard Harris,
Teijo Kaakinen, Lon Hoker, Mark Henigan.

Also:

All those people who gave encouragement, testing, and suggestions.

Harald Pollack for DLL rename code.

Alessandro Cantatore for giving lots of specific advice on getting ViewStub going, and even
writing code to do it for me :)


IBM Engineers:
- Aaron Reed for his help getting the Help Manager working, and especially with 16/32 bit coding.
- Scott Garfinkle, also for technical help on helpmgr.
- Michael Kaply (Warpzilla). Thanks heaps!
- And all those other engineers who made a pretty fine kernel and desktop

Christian Hennecke for pointing out the problems with multi-lingual, so it is now complete.

Andreas Schnellbacher and Henk Kelder for information on associating files.

Michal Necasek, Kendall Bennett and the rest of the Open Watcom team for Watcom C/C++.
Michal was extremely helpful in answering my dumb questions and did a lot of work to figure
out my 16-bit problems.
Great video drivers too. http://www.scitechsoft.com.
Go help Michal out with OpenWatcom on OS/2. http://www.openwatcom.org

Mark Vollmer for pointing out WM_QUERYHELPINFO/WM_SETHELPINFO and thereby getting SmartSuite working...

Hakan Gadler for persisting with testing.

Nicky Morrow for lots of constructive suggestions about user interface.

Keith Oswald, for the installation suggestions and contributions.
(so anyway... looks like I did an installer, but it's not WarpIn :).

Everyone in the comp.os.os2.programmer.misc newsgroup for listening to my long winded questions!

The eCS Developers Group for lots of interesting discussions.

Serenity Systems International (SSI): Kim Cheung and Bob St John for giving it a crack where
IBM gave up years ago, and being very tolerant of some wacky people. http://www.ecomstation.com

John Bijnens, A favourable review in OS/2 E-zine which encouraged me to continue! http://www.os2ezine.com

Cristiano Guadagnino, Author of WarpHelp - hope I haven't annoyed you by doing my own thing,
I wanted to see something happen. Cheers for the inspiration to get started!

Peter Fitzsimmons, for the original INF bitmap decompression code (LZW) used in Inf2HTML.
Thanks Peter! I managed to port it without fully understanding it... :-)

Ulrich Moeller, Author of Inf2HTML
  http://www.xworkplace.org/projects.html
And OF COURSE! XWorkplace/eWorkPlace etc etc. What a legend!

Carl Hauser. Original author of INF01.DOC, the description of the INF Binary format.
Wonder what you're up to these days Carl ;) We finally got there.

Marcus Groeber, Added additional information to INF2A.TXT

Peter Childs, Further updates to INF03.TXT

Speedsoft http://www.speedsoft-online.de
Makers of Sibyl, the awesome Delphi clone for OS/2, Linux and Win32 - Good luck guys.
Seems they are working on music software now.

Mat Kramer http://www.vyperhelp.com/
Author of VyperHelp - thanks for some suggestions on rich text controls,
plus a handy help authoring tool.

Erik Hueslmann, Author of Sibyl HelperThread components and maintainer of
Sibyl mail list archive http://www.sibyl-archive.org/

IBM... Sometimes they rocked.

Joachim Benjamins (Mensys Netherlands) - for the Bugtracker. Good work dude.

"Elwood" Composer of "Unknown Phuture" (unk.xm) - That song rocks...

"Mr Stewe" Composer of "Static Universe" (pb_static.xm) - you should be in business man

30 Seconds To Mars - What an incredible debut album, I love it. Played incessantly @ v2.
"You know enough to know the way...". A year later: Hrm, now I can't stand it! LOL.

--------------------------------------------------
TECHNICAL INFORMATION
--------------------------------------------------

Manual Installation
-------------------

For standalone use, you can simply unzip the files (mainly NewView.exe) into a directory.
This directory can be in the path if you want.

Doing full install manually takes a lot of steps and requires other utilities for
manipulating EXE/DLL files. All the following procedures are done in the installer.
I would rather you used the installer and complained if there are problems,
than try and do things manually.

A. Replacing View.exe

1. Go to C:\os2
2. Copy the existing View.exe to ibmView.exe
   This makes a backup. Do NOT rename View.exe or OS/2 will
   detect the change and make help files use ibmView.exe!
3. Copy new file ViewStub.exe to c:\os2\View.exe
4. Copy new file NewView.exe to somewhere in the path.
5. Copy new file newview.dll to the same place as Newview.exe, or somewhere in libpath

Now all your existing help file icons will load NewView.

Modifying file associations for .inf or .hlp files may not do the full job, because many help
file icons are actually program objects for "View.exe".

B. Replacing HelpMgr.dll

1. Replacing the file
Replacing HelpMgr.dll is more tricky because it is always in use by the WorkPlace Shell (WPS) desktop. You must either:
- reboot to a command prompt
or
- use a tool such as unlock or replmod to unlock the DLL
Back up the old DLL by copying it to a different filename such as helpmgr.bak.

2. Dependency on old helpmgr.
You ALSO need to make a copy of the old helpmgr.dll, called ibmhmgr.dll. This also needs to be
renamed internally, using e.g. DLLRNAME or RENMODUL (now on Hobbes - by me).

C. Getting Original View to Work

Once helpmgr.dll has been replaced by the new one, the old View will no longer work because
it relies on the old helpmgr.

1. Use a tool such as DLLRNAME or RENMODUL to rename the HELPMGR references in your copy
of old View to IBMHMGR.
2. Use the tool to rename the HELPMGR references in viewdoc.exe to IBMHMGR
You probably want to backup viewdoc.exe before doing this.

dllrname ibmview.exe helpmgr=ibmhmgr
dllrname ibmhmgr.dll helpmgr=ibmhmgr
  dllrname doesn't like to do this; I used a binary editor.
  This might be because the file has already been renamed.
  Perhaps renmodul will work better; haven't tried it.
dllrname viewdoc.exe helpmgr=ibmhmgr

Note that there is no easy way to get access to the old helpmgr for online help. That will
require a lot of tedious work by me in the new helpmgr to dynamically decide to pass functions
on (joy), and actually is impossible in many cases because I cannot intercept what I don't know about.

For Developers
--------------

I've uploaded the source to Hobbes, somewhat haphazardly.

It is written using two tools:

- The GUI application is done with Speedsoft Sibyl (an Object-Pascal system like Delphi)
  Site was at http://www.speedsoft-online.de but is gone.
  If you ask nicely I might send you my key.

- The new HelpMgr.dll is written using Open Watcom C++
  http://openwatcom.org

Download the source to get more design information.

Brief Summary of operation
--------------------------

This can be useful if you want to do manual installs or uninstall.

Files in the ZIP:
NewView.exe is the main application that views help files.
ViewStub.exe either activates an existing NewView window, or launches a new copy of NewView if
there is no window with all the specified files open. (This is done with a list in shared memory).
HelpMgr.dll is the DLL that apps load to access help. It launches NewView when needed.

When standalone, these files are copied as is to the install directory (helpmgr is obviously not
included since there is no use for it).

When replacing:
- ViewStub replaces View.exe
- HelpMgr.dll replaces the HelpMgr.dll
- NewView is installed as NewView.exe
  and serves an equivalent function to the ViewDoc.exe.
  It either goes in x:\os2 (OS/2)
  or x:\ecs\bin (eCS 1.1+)
Note - in versions before 2.7, NewView.exe replaced View.exe.
- newview.dll has some support functions for newview.exe. (C for speed)

- Old helpmgr.dll is now renamed to ibmhmgr.dll
- New helpmgr.dll now uses ibmhmgr.dll to implement some unknown functions
- Old view.exe is copied to ibmview.exe
  and changed to refer to ibmhmgr.dll
- ViewDoc.exe is backed up and then changed
  to refer to ibmhmgr.dll



-- end --
