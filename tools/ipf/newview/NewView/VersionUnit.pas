Unit VersionUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003-2006 Aaron Lawrence (aaronl at consultant dot com)
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the Gnu Public License - see readme.txt

Interface

// This file contains the version number and history.

function GetAppVersion: string;

Implementation

const
  Version =        'V2.20.beta3'; // $SS_REQUIRE_NEW_VERSION$
  BldLevelVersion = '2.20.beta3'; // Embedded for IBM BLDLEVEL tool

// RELEASE PROCESS
// - notify translators
// - Record library versions
// - DISABLE PROFILE
// - TURN OFF DEBUG INFO
// - Package: distr NewViewX_Y_Z
// - Upload to Hobbes
// - Test download [Yeah right]
// - Update webpage: index, NewView news, history, download [Down]
// - Notify eCS apps NG, OS/2 Apps NG
//
// HelpMgr: V1.9.0
// ViewStub: V1.1.1
// Install: V1.10.0
// Components: V1.11.23
// Library: V1.5.12
// SPCC: V2.1.11.13
// RTL: V2.0.4.2
// Addon: V2.0.4

{ Todo list

Emphasis:
  major bugs
  missing features that original IPF had.
  major performance issues [none really remaining?]
    - decoding images/text on older machines
    - startup

- os2dbcs.inf, html40 - veit

- MAJOR keyboard navigation of links
    - next: done
    - previous: done
    - enter to activate:

- MINOR: Way to identify new helpmgr.
  A special entry point? Special value in ...? Special Window ULONG? Global mem?
  HM_QUERY with a new value...
  or HM_SET_USERDATA with a magic number, which returns a magic number
- MODERATE: For Maul Publisher (Peter Koller): ability to get active help panel
- MODERATE [ENH] Use separate programs for mail, ftp etc.

- MINOR Link control - custom cursors for default controls
 - default cursor for rich text view
   - don't call default window proc for wm_mousemove
   - need to override .wmmousemove...

- MODERATE [PERF]: New art decoder from Sergei
- MINOR [DEBUG]: Continue removing units to keep debugger
  e.g. Remove file dialog and color wheel to dll?
    - problem is, my newview.dll is C-only :/

- MINOR [ENH] Option to turn off internet links. (or a warning/popup/question)
- MINOR [ENH] Customise link colors (separately for native links vs urls)
- MINOR [PERF] Optimise tree (global search) to not redraw if nodes not visible

Help
- MINOR [ENH] [INST] select language to install
- MINOR [INST] check for FAT 8.3 before installing, fail gracefully (ie. only nls files)

- MINOR hide language stuff except on param?
- MINOR [INST] kill off viewhelp?


Search enhancements/completion
- Make AND the default
- Skip thru search matches...
- Case sensitive
- Whole word only match
- Highlight when searching All Help Files

Keyboard
- navigation of search results

Printing
- MEDIUM [ENH] selectable topics - requires support for multi-select in tree
- MEDIUM [ENH] improve printing of topic to use printing control bits etc
- MAJOR [ENH] Complete
  - Contents
  - Index
  - Page/Topic numbers
  - Optional hidden topics?

International
- MODERATE DBCS
  - cursor
  - find
- Codepage support
  - file
  - codepages in font specifications

User interface tweaks
- Coloured tabs?
- Topic menu: "copy link location", back, forward, previous, next
- Open related windows when a search result is shown
  e.g. vacpp topic ... need to parse entire file
  do only when window is not 100%??

- Button to toggle left panel
- Hint (popup tooltip) for links
- Better handling of windows
  - problem with CPPUG toc pane
  - leaving windows smaller than screen...
- Option: Sort top level contents, would be nice

Bugs/Compatibility
- [eCS compat] move ini file to appropriate place. (see AE)
- Run old hmgr...... is this possible??
  - Additional association for *hlp;*.inf to ibmview.exe

New features
- View all images
- Tools - Mark Start Topic
  (special bookmark?)
- Help File Manager
  - Show all found help files...
- Show History (by date/time only - not a tree)
- Uninstall
- Mouse wheel
- Free-standing notes
- Font lib from Innotek

Rich Text View
- Select/copy and save support, for images.
- if it wraps during a word that has tags within it,
  then the tags may not be applied at the correct point.
  ... need to remember the style at start of word as well.
- should not lose cursor if just resizing,
  only if text changed
- Linked images
    e.g. Export.hlp

Performance
- helpmgr.dll use global filelist instead of running view.exe first
- profiler (GpProfile)
- Speed up bitmap decoding.
  sledit.inf
  slowdown is definitely in  ReadBitmapData

  10x stress test sledit
    original: 15 secs
    decode_string asm: 14.5 secs
    LZW -> C DLL: 13.3 secs

    without any decoding: 10 seconds
    so - c decode time: 3.3 secs.
         Pas decode time: 5 secs.

    loading from file, not adding to images list: 9 s
    loading from file, adding to images list [removed after]: 9.2 s
    without getting any images at all (THelpFile.GetImages)
    8.5 s.

    Therefore, we have:
    decoding: 3.3s (c) or 5s (pascal)
    using: 1s
    reading file: 0.5s
    other loading stuff: 8.5

    Observationally, original view is much faster than
    even the C version. It must be in assembler or something.
    I could not see any major optimisations to make in the C
    version.
    Scott from IBM suggested using the original functions
    in helpmgr.dll.

- Make navigation back and forth
  detect differences in windows and make minimum changes 1/2 day
  zorder

Minor
- Iconedit help for product information doesn't work
  Something weird goin on with resource IDs.
  Note: old view really does work.
}

function GetAppVersion: string;
begin
  Result:= Version;
end;

const
  Vendor = 'Aaron Lawrence';
  Description = 'NewView';

  // BLDLevel - compatible - mostly
  EmbeddedVersion: string =
      '@#'
    + Vendor
    + ':'
    + BldLevelVersion
    + '#@'
    + Description
    + #0;

Initialization
End.
