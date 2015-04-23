Unit MainForm;

// NewView - a new OS/2 Help Viewer
// Copyright 2003-2006 Aaron Lawrence (aaronl at consultant dot com)
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
// system is a good unit to be able to open ;)
// the above line is here so you can use right-mouse open file on "system"
  OS2Def,
  SysUtils,
  Classes,
  Forms,
  Graphics,
  Messages,
  Buttons,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  TabCtrls,
  Dialogs,

// library
  ACLString,
  SharedMemoryUnit,
  ACLLanguageUnit,
  GenericThread,
  CmdLineParameterUnit,

// custom components
  SplitBar,
  Outline2,
  RichTextView,
  Coolbar2,
  CustomListBox,

// local
  HelpFile,
  HelpTopic,
  HelpWindowUnit,
  HelpWindowDimensions,
  NavigatePointUnit,
  MiscUnit,
  HelpManagerUnit,
  TextSearchQuery,
  IPFFileFormatUnit,
  Tabset2Unit;

const
  // Custom window messages for this form
  // NOTE! Sibyl uses WM_USER+1 and +2!
  WM_OPENED             = WM_USER + 10;
  WM_FOLLOWLINK         = WM_USER + 11;
  WM_FOLLOWEXTERNALLINK = WM_USER + 12;

  MAIN_WINDOW_CLASS_NAME = 'NewViewMainForm';

Type

  TMainForm = Class (TForm)
    VSplitBar: TSplitBar;
    Notebook: TNoteBook;
    IndexSearchEdit: TEdit;
    SearchTextEdit: TEdit;
    SearchResultsListBox: TListBox;
    NotesListBox: TListBox;
    CoolBar: TCoolBar2;
    MenuItem21: TMenuItem;
    SaveAsIPFMI: TMenuItem;
    MenuItem20: TMenuItem;
    DebugFindBinaryMI: TMenuItem;
    TopicByNameMI: TMenuItem;
    DebugTopicByResourceIDMI: TMenuItem;
    ToolsDebugSep: TMenuItem;
    DebugSaveLanguageFileMI: TMenuItem;
    DebugLoadLanguageMI: TMenuItem;
    TabSet: TTabSet2;
    NavigateNextMI: TMenuItem;
    ShowLeftPanelMI: TMenuItem;
    MenuItem18: TMenuItem;
    AddNoteButton: TButton;
    EditNoteButton: TButton;
    DeleteNoteButton: TButton;
    GotoNoteButton: TButton;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    DebugHelpManagerVersionMI: TMenuItem;
    MenuItem19: TMenuItem;
    ViewHighlightSearchWordsMI: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem15: TMenuItem;
    FileNewWindowMI: TMenuItem;
    OpenSpecialMI: TMenuItem;
    MenuItem14: TMenuItem;
    SearchPMI: TMenuItem;
    ViewSourceMI: TMenuItem;
    FileCloseMI: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    StatusPanel: TPanel;
    ProgressPanel: TPanel;
    ProgressBar: TProgressBar;
    DebugShowWordSeparatorsMI: TMenuItem;
    DebugStressTestMI: TMenuItem;
    TopicPropertiesPMI: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem8: TMenuItem;
    ToolsOptionsMI: TMenuItem;
    MenuItem9: TMenuItem;
    ToolsDebugMenu: TMenuItem;
    DebugShowParamsMI: TMenuItem;
    DebugShowCodesMI: TMenuItem;
    EditGlobalSearchMI: TMenuItem;
    ViewExpandAllMI: TMenuItem;
    EditBookmarksMI: TMenuItem;
    AddBookmarkMI: TMenuItem;
    ViewPopupMenu: TPopupMenu;
    SelectAllPMI: TMenuItem;
    CopyPMI: TMenuItem;
    ContentsOutline: TOutline2;
    IndexListBox: TCustomListBox;
    ViewCollapseAllMI: TMenuItem;
    MenuItem7: TMenuItem;
    SystemOpenDialog: TSystemOpenDialog;
    SearchButton: TButton;
    MenuItem1: TMenuItem;
    ViewIndexMI: TMenuItem;
    ViewContentsMI: TMenuItem;
    ViewSearchMI: TMenuItem;
    ViewNotesMI: TMenuItem;
    ViewRefreshMI: TMenuItem;
    MenuItem11: TMenuItem;
    DisplayPanel: TPanel;
    ButtonImages: TImageList;
    BookmarksMenu: TMenuItem;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    OpenMI: TMenuItem;
    FileSaveAsMI: TMenuItem;
    PrintMI: TMenuItem;
    FileInformationMI: TMenuItem;
    MenuItem4: TMenuItem;
    ExitMI: TMenuItem;
    EditMenu: TMenuItem;
    SelectAllMI: TMenuItem;
    CopyMI: TMenuItem;
    MenuItem5: TMenuItem;
    FindMI: TMenuItem;
    FindNextMI: TMenuItem;
    NavigateMenu: TMenuItem;
    NavigateBackMI: TMenuItem;
    NavigateForwardMI: TMenuItem;
    MenuItem6: TMenuItem;
    NavigatePreviousMI: TMenuItem;
    ToolsMenu: TMenuItem;
    GlobalSearchMI: TMenuItem;
    HelpMenu: TMenuItem;
    HelpMI: TMenuItem;
    HelpProductInformationMI: TMenuItem;
    AddNoteMI: TMenuItem;

    Procedure SaveAsIPFMIOnClick (Sender: TObject);
    Procedure DebugFindBinaryMIOnClick (Sender: TObject);
    Procedure TopicByNameMIOnClick (Sender: TObject);
    Procedure CopyLinkLocationPMIOnClick (Sender: TObject);
    Procedure HelpKeysMIOnClick (Sender: TObject);
    Procedure MainFormOnCommand (Sender: TObject; Var Command: TCommand);
    Procedure MainFormOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure ShowLeftPanelMIOnClick (Sender: TObject);
    Procedure CoolBarOnFontChange (Sender: TObject);
    Procedure NotebookOnFontChange (Sender: TObject);
    Procedure TabSetOnFontChange (Sender: TObject);
    Procedure IndexListBoxOnFontChange (Sender: TObject);
    Procedure NotesListBoxOnFontChange (Sender: TObject);
    Procedure DisplayPanelOnFontChange (Sender: TObject);
    Procedure ContentsOutlineOnFontChange (Sender: TObject);
    Procedure SearchResultsListBoxOnFontChange (Sender: TObject);
    Procedure DisplayPanelOnDragOver (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure NotesListBoxOnDragOver (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure DisplayPanelOnDragDrop (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt);
    Procedure NotesListBoxOnDragDrop (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt);
    Procedure SearchResultsListBoxOnDragDrop (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt);
    Procedure SearchResultsListBoxOnDragOver (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure IndexListBoxOnDragDrop (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt);
    Procedure IndexListBoxOnDragOver (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure ContentsOutlineOnDragOver (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure ContentsOutlineOnDragDrop (Sender: TObject; Source: TObject;
      X: LongInt; Y: LongInt);
    Procedure MainFormOnDragOver (Sender: TObject; Source: TObject; X: LongInt;
      Y: LongInt; State: TDragState; Var Accept: Boolean);
    Procedure MainFormOnDragDrop (Sender: TObject; Source: TObject; X: LongInt;
      Y: LongInt);
    Procedure ContentsOutlineOnItemClick (Node: TNode);
    Procedure DebugLoadLanguageMIOnClick (Sender: TObject);
    Procedure DebugSaveLanguageFileMIOnClick (Sender: TObject);
    Procedure SearchResultsListBoxOnClick (Sender: TObject);
    Procedure VSplitBarOnDblClick (Sender: TObject);
    Procedure DebugHelpManagerVersionMIOnClick (Sender: TObject);
    Procedure DebugTopicByResourceIDMIOnClick (Sender: TObject);
    Procedure ViewHighlightSearchWordsMIOnClick (Sender: TObject);
    Procedure FileNewWindowMIOnClick (Sender: TObject);
    Procedure OpenSpecialMIOnClick (Sender: TObject);
    Procedure NotesListBoxOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure ViewPopupMenuOnPopup (Sender: TObject);
    Procedure SearchPMIOnClick (Sender: TObject);
    Procedure ViewSourceMIOnClick (Sender: TObject);
    Procedure PrintMIOnClick (Sender: TObject);
    Procedure DebugShowWordSeparatorsMIOnClick (Sender: TObject);
    Procedure DebugStressTestMIOnClick (Sender: TObject);
    Procedure TopicPropertiesPMIOnClick (Sender: TObject);
    Procedure NavigateForwardMIOnClick (Sender: TObject);
    Procedure IndexListBoxOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure SearchResultsListBoxOnScan (Sender: TObject;
      Var KeyCode: TKeyCode);
    Procedure ContentsOutlineOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure ToolsOptionsMIOnClick (Sender: TObject);
    Procedure EditGlobalSearchMIOnClick (Sender: TObject);
    Procedure DebugShowParamsMIOnClick (Sender: TObject);
    Procedure ViewExpandAllMIOnClick (Sender: TObject);
    Procedure EditBookmarksMIOnClick (Sender: TObject);
    Procedure CopyPMIOnClick (Sender: TObject);
    Procedure SelectAllPMIOnClick (Sender: TObject);
    Procedure AddNoteButtonOnClick (Sender: TObject);
    Procedure SearchTextEditOnChange (Sender: TObject);
    Procedure IndexListBoxOnClick (Sender: TObject);
    Procedure ViewCollapseAllMIOnClick (Sender: TObject);
    Procedure NotesListBoxOnDblClick (Sender: TObject);
    Procedure HelpMIOnClick (Sender: TObject);
    Procedure NotebookOnPageChanged (Sender: TObject);
    Procedure ViewRefreshMIOnClick (Sender: TObject);
    Procedure ViewNotesMIOnClick (Sender: TObject);
    Procedure ViewSearchMIOnClick (Sender: TObject);
    Procedure ViewIndexMIOnClick (Sender: TObject);
    Procedure ViewContentsMIOnClick (Sender: TObject);
    Procedure MainFormOnCloseQuery (Sender: TObject; Var CanClose: Boolean);
    Procedure GlobalSearchMIOnClick (Sender: TObject);
    Procedure GotoNoteButtonOnClick (Sender: TObject);
    Procedure EditNoteButtonOnClick (Sender: TObject);
    Procedure NotesListBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure DeleteNoteButtonOnClick (Sender: TObject);
    Procedure AddBookmarkMIOnClick (Sender: TObject);
    Procedure AddNoteMIOnClick (Sender: TObject);
    Procedure FileCloseMIOnClick (Sender: TObject);
    Procedure CoolBarOnSectionResize (HeaderControl: THeaderControl;
      section: THeaderSection);
    Procedure CoolBarOnSectionClick (HeaderControl: THeaderControl;
      section: THeaderSection);
    Procedure MainFormOnDestroy (Sender: TObject);
    Procedure MainFormOnSetupShow (Sender: TObject);
    Procedure MainFormOnCreate (Sender: TObject);
    Procedure MainFormOnShow (Sender: TObject);
    Procedure FindNextMIOnClick (Sender: TObject);
    Procedure FindMIOnClick (Sender: TObject);
    Procedure IndexSearchEditOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure IndexSearchEditOnChange (Sender: TObject);
    Procedure FileInformationMIOnClick (Sender: TObject);
    Procedure SearchTextEditOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure SearchButtonOnClick (Sender: TObject);
    Procedure FileSaveAsMIOnClick (Sender: TObject);
    Procedure OptionsMIOnClick (Sender: TObject);
    Procedure TabSetOnChange (Sender: TObject; NewTab: LongInt;
      Var AllowChange: Boolean);
    Procedure NotebookOnSetupShow (Sender: TObject);
    Procedure NavigateBackMIOnClick (Sender: TObject);
    Procedure NavigatePreviousMIOnClick (Sender: TObject);
    Procedure NavigateNextMIOnClick (Sender: TObject);
    Procedure CopyMIOnClick (Sender: TObject);
    Procedure SelectAllMIOnClick (Sender: TObject);
    Procedure DebugShowCodesMIOnClick (Sender: TObject);
    Procedure HelpProductInformationMIOnClick (Sender: TObject);
    Procedure OnOverLink ( Sender: TRichTextView; LinkString: String);
    Procedure OnNotOverLink ( Sender: TRichTextView; LinkString: String);
    Procedure OnClickLink ( Sender: TRichTextView; LinkString: String);
    Procedure BackButtonOnClick (Sender: TObject);
    Procedure RTViewOnSetupShow (Sender: TObject);
    Procedure OpenMIOnClick (Sender: TObject);
    Procedure ExitMIOnClick (Sender: TObject);

    Procedure MainFormOnResize (Sender: TObject);
    Procedure VSplitBarOnChange (NewSplit: LongInt);
  Protected
    // Custom window messages ----------------------------------

    // Handle our own WM_OPENED message
    Procedure WMOpened( Var Msg: TMessage ); Message WM_OPENED;
    Procedure WMFollowLink( Var Msg: TMessage ); Message WM_FOLLOWLINK;
    Procedure WMFollowExternalLink( Var Msg: TMessage ); Message WM_FOLLOWEXTERNALLINK;

    // Messages from new help manager OR other instances
    Procedure NHMDisplayIndex( Var Msg: TMessage ); Message NHM_HELP_INDEX;
    Procedure NHMDisplayContents( Var Msg: TMessage ); Message NHM_HELP_CONTENTS;
    Procedure NHMTopicByResourceID( Var Msg: TMessage ); Message NHM_TOPIC_BY_RESOURCE_ID;
    Procedure NHMTopicByPanelName( Var Msg: TMessage ); Message NHM_TOPIC_BY_PANEL_NAME;

    Procedure NHMTest( Var Msg: TMessage ); Message NHM_TEST;

    Procedure NHMSearch( Var Msg: TMessage ); Message NHM_SEARCH;
    Procedure NHMGlobalSearch( Var Msg: TMessage ); Message NHM_GLOBAL_SEARCH;
    Procedure NHMShowUsage( Var Msg: TMessage ); Message NHM_SHOW_USAGE;

    Procedure NHMSetFiles( Var Msg: TMessage ); Message NHM_SET_FILES;
    Procedure NHMSetTitle( Var Msg: TMessage ); Message NHM_SET_TITLE;

  Protected
    // GUI events set by code ----------------------------------

    Procedure OnHint( Sender: TObject );
    Procedure OnWindowClose( Window: THelpWindow );
    Procedure OnWindowAboutToClose( Window: THelpWindow;
                                    var CanClose: boolean );
    Procedure OnNavigateToMenuItemClick( Sender: TObject );
    Procedure OnDragOverWindow( Sender: TObject;
                                Source: TObject;
                                X: LongInt;
                                Y: LongInt;
                                State: TDragState;
                                Var Accept: Boolean );
    Procedure OnDragDropToWindow( Sender: TObject;
                                  Source: TObject;
                                  X: LongInt;
                                  Y: LongInt );
    Procedure OnWindowFontChange( Sender: TObject );
    Procedure OnWindowTab( Sender: TObject );
    Procedure OnWindowBackTab( Sender: TObject );

    Procedure OnException( Sender: TObject;
                           E: Exception );
    Procedure OnHelp( context: THelpContext;
                      var Result: Boolean );


    FShowLeftPanel: boolean;

    Function GetShowLeftPanel: boolean;
    Procedure SetShowLeftPanel( Value: boolean );
    Property ShowLeftPanel: boolean read GetShowLeftPanel write SetShowLeftPanel;

    Procedure ShowTab( TabIndex: longint );

    procedure GetClassData(var ClassData: TClassData); override;
  Public

    // Open the file or list of files in FileNames
    // Set the window title if given, otherwise get it from first file
    Function OpenFiles( const FileNames: TStrings;
                        const WindowTitle: string;
                        const DisplayFirstTopic: boolean ): boolean;

    // Open a single file
    Function OpenFile( const FileName: string;
                       const WindowTitle: string;
                       const DisplayFirstTopic: boolean ): boolean;

    Function OpenAdditionalFiles( const FileNames: TStrings;
                                  const DisplayFirstTopic: boolean ): boolean;

    Function OpenAdditionalFile( const FileName: string;
                                 const DisplayFirstTopic: boolean ): boolean;

    // open from original helpmgr style file1+file2+file3. ..
    Function OpenFilesFromTextList( const TextList: string;
                                    const DisplayFirstTopic: boolean ): boolean;

    Procedure CloseFile;
    Function OKToCloseFile: boolean;

    Procedure AddCurrentToMRUFiles;

    Function LoadFiles(const aFileNames: TStrings; aHelpFiles: TList) : boolean;
    Procedure DisplayFiles( NewFiles: TList;
                            Var FirstContentsNode: TNode );

    Procedure OpenDroppedFile( Source: TObject );

    Function OpenWindowsHelp( const Filename: string ): boolean;

    function DisplayTopicByResourceID( ID: uint16 ): boolean;
    function DisplayTopicByName( const TopicName: string ): boolean;
    function DisplayTopicByGlobalName( const TopicName: string ): boolean;

    Procedure DisplayIndex;
    Procedure DisplayContents;
    Procedure DisplaySearch;

  Protected
    // Startup functions ----------------------------------

    Function pSharedStruct: TPNewHelpMgrSharedStruct;
    Procedure PositionWindow;
    Procedure RestoreWindow;

    Procedure CheckEnvironmentVars;
    Procedure ShowUsage;

    // Loading functions ----------------------------------

    // Most recently used files list
    Procedure CreateMRUMenuItems;
    Procedure OnMRUMenuItemClick( Sender: TObject );

    Procedure OnHelpFileLoadProgress( n, outof: integer;
                                      message: string );

    // Returns nil if file is not open
    Function FindOpenHelpFile( FileName: string ): THelpFile;

    // Navigation -------------------------------------------------

    Procedure SaveNavigatePoint;
    Procedure SaveWindows( SourceList: TList;
                           DestList: TList;
                           Parent: TSavedHelpWindow );

    Procedure UpdateCurrentNavigatePoint;
    Procedure ClearPageHistory;

    Procedure NavigateToPoint( NavPoint: TNavigatePoint );
    Procedure NavigateToHistoryIndex( Index: longint );

    Procedure DisplayWindows( WindowList: TList;
                              Parent: THelpWindow );
    Procedure ShowWindows;
    Procedure ShowWindowList( WindowList: TList );
    Procedure CloseWindows;

    Procedure FocusFirstHelpWindow;

    Procedure NavigateBack;
    Procedure NavigateForward;
    Procedure NavigatePreviousInContents;
    Procedure NavigateNextInContents;

    Procedure CreateNavigateToMenuItems;

    // GUI status updates ---------------------------------

    Procedure EnableControls;
    Procedure EnableSearchButton;
    Procedure SetStatus( Text: String );
    Procedure SetProgress( n, outof: integer;
                           message: string );
    Procedure ResetProgress;
    Procedure RefreshWindows( WindowList: TList );

    // language stuff
    // called by callback
    Procedure OnLanguageEvent(Language: TLanguageFile; const Apply: boolean );

    function ShowCodes: boolean;
    function ShowWordIndices: boolean;

    // Loading views --------------------------------------

    // Used in loading contents
    Procedure AddChildNodes( HelpFile: THelpFile;
                             ParentNode: TNode;
                             Level: longint;
                             Var TopicIndex: longint );
    Procedure LoadContents( Files: TList;
                            Var FirstNode: TNode );
    Procedure LoadIndex;

    // Note manipulations --------------------------------

    procedure AddNote;
    Procedure EditNote( NoteIndex: longint );
    procedure DeleteNote( NoteIndex: longint );
    Procedure SaveNotes;
    Procedure SaveNotesForFile( HelpFile: THelpFile );
    Procedure LoadNotes( HelpFile: THelpFile );
    Procedure GotoCurrentNote;

    // make sure that note insert positions are not in
    // the middle of tags due to help file or newview updates.
    Procedure CorrectNotesPositions( Topic: TTopic;
                                     Text: pchar );

    Procedure InsertNotesIntoTopicText( Topic: TTopic;
                                        Text: TAString );
    function FindOriginalNoteCharIndex( NoteCharIndex: longword;
                                        Topic: TTopic ): longword;
    function FindActualNoteCharIndex( NoteCharIndex: longword;
                                      MaxNoteIndex: longword;
                                      Topic: TTopic ): longword;
    procedure RefreshNoteInsertInfo( NoteIndex: longword );
    procedure ClearNotes;

    Procedure EnableNotesControls;
    Procedure UpdateNotesDisplay;

    Procedure RefreshFontSubstitutions;

    // GUI actions ------------------------------------------

    procedure FileOpen;

    Procedure PrintTopics;
    function DoPrinting( Parameters: TObject ): TObject;
    Procedure StopPrinting;

    Procedure DoFind( FindOrigin: TFindOrigin );

    // Bookmarks ------------------------------------------

    Procedure NavigateToBookmark( Bookmark: TBookmark );
    Procedure BuildBookmarksMenu;
    Procedure UpdateBookmarksForm;
    Procedure BookmarksMenuItemClick( Sender: TObject );
    procedure AddBookmark;
    procedure ClearBookmarks;
    procedure SaveBookmarks;
    procedure SaveBookmarksForFile( HelpFile: THelpFile );
    procedure LoadBookmarks( HelpFile: THelpFile );
    procedure OnBookmarksChanged( Sender: TObject );

    // Global search -------------------------------------

    procedure DoGlobalSearch( const SearchText: string );
    // Called when viewing topics from global search
    Procedure OnViewGlobalSearchTopic( FileName: string;
                                       TopicIndex: longint );

    // Options and appearance -----------------------------

    procedure DoOptions;

    procedure ApplySettings;

    // changes normal or fixed font depending on shift state
    Procedure SetTopicFont( NewFont: TFont );

    Procedure SetApplicationFont( NewFont: TFont );

    // Retrieve control colours (in case drag'n'drop used to change)
    Procedure GetColors;
    // Set the layout of the main form
    Procedure SetLayout;
    // Lay out the specified list of help windows
    Procedure LayoutWindowList( WindowList: TList );
    // Setup the rich text views in the specified windows (e.g for changing global settings)
    Procedure SetupViews( WindowList: TList );

    // Topic display -------------------------------------

    // Major display topic function.
    procedure DisplayTopic( Topic: TTopic );

    Procedure DisplaySelectedIndexTopic;
    Procedure DisplaySelectedSearchResultTopic;
    Procedure DisplaySelectedContentsTopic;

    Procedure DisplayTopicInWindow( Window: THelpWindow;
                                    FollowAutoLinks: boolean;
                                    KeepPosition: boolean );

    function OpenWindow( Topic: TTopic;
                         Group: longint;
                         Parent: THelpWindow;
                         Rect: THelpWindowRect;
                         FollowAutoLinks: boolean ): THelpWindow;

    Procedure RemoveHelpWindowFromParent( Window: THelpWindow );

    Procedure FollowLink( Link: THelpLink;
                          SourceWindow: THelpWindow );

    Function FindTopicByResourceID( ID: uint16 ): TTopic;
    Function FindTopicByName( const Name: string ): TTopic;
    Function FindTopicByGlobalName( const Name: string ): TTopic;

    Function FindTopicForLink( Link: THelpLink ): TTopic;

    Function FindWindowFromView( View: TRichTextView; WindowList: TList ): THelpWindow;
    Function FindWindowFromGroup( Group: longint; WindowList: TList ): THelpWindow;
    Function FindWindowFromTopic( Topic: TTopic; WindowList: TList ): THelpWindow;
    Function GetActiveWindow: THelpWindow;

    Procedure DoSearch;
    Procedure SearchFor( const SearchText: string );
    Procedure StartupTopicSearch( const SearchText: string );

    // clear search match sequences
    Procedure ClearAllWordSequences;

    Procedure SetMainCaption;

    // cancel help manager mode
    Procedure ClearHelpManager;
    Procedure PostHelpManagerMessage( MessageType: ULONG;
                                      Param1: long;
                                      Param2: long );

    HelpManagerWindows: TList; // of HWND

    function OwnHelpMode: boolean;
    CurrentOpenFiles: TList; // current open help files.
    MRUMenuItems: TList; // most recently used file list
    NavigateToMenuItems: TList;
    MainTitle: string;

    // Current topic has the vague meaning that it was the last
    // topic selected by the user... (?)
    CurrentTopic: TTopic;

    AllFilesWordSequences: TList; // of lists; one per open file; of possible word sequences

    // use during decode...
    TopicText: TAString;

    Windows: TList; // top level help windows

    PageHistory: TStringList; // history
    CurrentHistoryIndex: longint; // where we are in history

    Navigating: boolean; // true while going to a particular history point

    DisplayedIndex: TStringList; // duplicate of index listbox,
                                 // for fast case insensitive searching
    InIndexSearch: boolean; // true while searching index
    IndexLoaded: boolean;

    ContentsLoaded: boolean;

    StartingUp: boolean; // true while starting
    SettingFont: boolean;
    DisplayingTopicWindow: boolean;

    FindText: string; // last text found (Ctrl-F)

    Notes: TList; // Notes in current files.

    Bookmarks: TList;
    BookmarksMenuItems: TList;

    // while loading... so owe can display progress
    LoadingFilenameList: TStringList;
    LoadingFileIndex: integer;

    PrintThread: TGenericThreadManager;
    procedure OnPrintProgress( n, outof: integer;
                               Message: string );
    procedure OnPrintComplete( Dummy: TObject );
  protected
    // language stuff
    FileOpenTitle: string;
    LoadingFileMsg: string;
    HelpFileError: string;
    LoadingStatusDisplaying: string;
    LoadingStatusNotesAndBookmarks: string;
    LoadingStatusContents: string;
    LoadingStatusIndex: string;
    LoadingStatusDone: string;

    AllFilesDesc: string;
    HelpFilesDesc: string;
    LanguageFilesDesc: string;

    SaveLanguageTitle: string;
    OpenLanguageTitle: string;
    SaveLanguageError: string;

    HelpManagerVersionTitle: string;

    FindResourceIDTitle: string;
    FindResourceIDPrompt: string;
    InvalidResourceIDError: string;
    ResourceIDNotFoundError: string;

    OpenSpecialTitle: string;
    OpenSpecialPrompt: string;

    PrintTopicTitle: string;
    NoPrinterError: string;
    SelectWindowToPrintError: string;
    PrintingComplete : string;
    PrintingError: string;
    StoppingPrintMsg: string;
    PrintStoppedMsg: string;
    CheckStopPrintTitle: string;
    CheckStopPrintMsg: string;

    TopicInfoTitle: string;
    TopicInfoTopicTitle: string;
    TopicInfoIndex: string;
    TopicInfoFile: string;
    TopicInfoResourceIDs: string;
    TopicInfoNoResourceIDs: string;

    ParameterCountLabel: string;

    NewViewHelpTitle: string;
    AlreadyNewviewHelp: string;
    NewViewHelpNotFound: string;

    InvalidLinkErrorTitle: string;
    InvalidLinkError: string;
    InvalidResourceIDLinkErrorA: string;
    InvalidResourceIDLinkErrorB: string;

    OpenedTopicMsg: string;

    AddNoteTitle: string;
    AddNoteCursorError: string;
    NoteWithinNoteError: string;
    LoadNotesTitle: string;
    LoadNotesError: string;
    SaveNotesTitle: string;
    SaveNotesError: string;

    UntitledBookmarkName: string;
    LoadBookmarksTitle: string;
    LoadBookmarksError: string;
    SaveBookmarksTitle: string;
    SaveBookmarksError: string;

    ApplicationErrorTitle: string;
    ApplicationErrorA: string;
    ApplicationErrorB: string;
    ApplicationErrorC: string;

    EnvironmentVarErrorTitle: string;
    EnvironmentVarError: string;
    EnvironmentVarUndefined: string;

    FindTitle: string;
    FindSelectWindowError: string;
    FindPrompt: string;
    TextNotFoundMsg: string;

    FilesInfoTitle: string;
    FilesInfoOverallTitle: string;
    FilesInfoFilename: string;
    FilesInfoFileTitle: string;
    FilesInfoTopicCount: string;
    FilesInfoIndexCount: string;
    FilesInfoDictionaryCount: string;
    FilesInfoFileSize: string;
    FilesInfoTotalTopicCount: string;
    FilesInfoTotalIndexCount: string;
    FilesInfoTotalFileSize: string;

    SearchTitle: string;
    SearchSyntaxError: string;
    SearchingMsg: string;
    NoSearchMatchesMsg: string;
    SearchFoundMsgA: string;
    SearchFoundMsgB: string;

    FileSaveTitle: string;
    FileSaveSelectWindowError: string;
    DefaultSaveTopicFilename: string;
    ReplaceFilePromptA: string;
    ReplaceFilePromptB: string;
    UnableToSaveError: string;

    UsageTitle: string;
    UsageText1: string;
    UsageText2: string;
    UsageText3: string;
    UsageText4: string;
    UsageText5: string;
    UsageText6: string;
    UsageText7: string;
    UsageText8: string;

    GoBackHint: string;

    SelectAllTitle: string;
    SelectAllWindowError: string;

    EditNoteMsg: string;
    ExternalLinkMsg: string;
    LinkMsg: string;
    UnknownLinkMsg: string;
    FootnoteMsg: string;

    ExternalLinkTitle: string;
    ExternalLinkError: string;

    MRUMultipleFilesHint: string;

    HelpProgramTitle: string;
    WindowsHelpTitle: string;
    WindowsHelpPrompt: string;

    ErrorTitle: string;

    FindTopicNameTitle: string;
    FindTopicNamePrompt: string;
    TopicNameNotFoundError: string;

    SplitBarDblClickToShow: string;
    SplitBarDblClickToHide: string;

  End;

Var
  MainForm: TMainForm;
  CmdLineParameters : TCmdLineParameters;

Implementation

uses
  BseDos,
  BseErr,
  PMWin,
  PmShl,
  Dos,
  Printers,

  // Library
  ACLFileIOUtility,
  ACLUtility,
  ACLDialogs,
  RunProgramUnit,
  StringUtilsUnit,
  CharUtilsUnit,
  DebugUnit,

  FileUtilsUnit,

  // Components
  RichTextPrintUnit,
  RichTextStyleUnit,
  RichTextDocumentUnit,
  ControlsUtility,

  // local: forms
  InformationFormUnit,
  OptionsForm,
  ProductInformationFormUnit,
  NoteForm,
  GlobalSearchForm,
  FileDialogForm,
  BookmarksFormUnit,
  PrintDialogUnit,

  // local: others
  NewViewConstantsUnit,
  SettingsUnit,
  VersionUnit,
  SearchUnit,
  StartupUnit,
  GlobalFilelistUnit,
  WebBrowserUnit,
  HelpBitmap;

{$R Images}

const
  // Coolbar button indexes
  ciOpen = 0;
  ciPrint = 1;
  ciNavigator = 2;
  ciBack = 3;
  ciForward = 4;
  ciAddNote = 5;
  ciAddBookmark = 6;
  ciPrevious = 7;
  ciNext = 8;
  ciGlobalSearch = 9;

  // Page indexes.
  piContents = 0;
  piIndex = 1;
  piSearch = 2;
  piNotes = 3;

  CrashLogFileName = 'NewView.log';

  _MAX_PATH = 260;

var
  hNewViewDLL: HMODULE;

  StartMem: longword;
  LastMem: longword;

  g_ExternalLinkFilename: string;
  g_ExternalLinkTopic: string;
  g_ExternalLinkSourceFilename: string;
  g_ExternalLinkKeepCurrent: boolean; // whether to keep current files open

//
// ----------------------------------------------------------------------------------------
//  TMainForm implementation
// ----------------------------------------------------------------------------------------
//

Procedure TMainForm.SaveAsIPFMIOnClick (Sender: TObject);
var
  FileName: string;
  F: TextFile;
  H: THelpFile;
  i: longint;
  T: TTopic;
  ResourceIDs: TList;
  ImageOffsets: TList;
  ImageOffset: longint;
  Image: THelpBitmap;
Begin
  H := CurrentOpenFiles[ 0 ];

  FileName := ChangeFileExt( ExtractFileName( H.Filename ), '.ipf' );
  if not DoSaveFileDialog( FileSaveTitle,
                       'IPF' + '|*.ipf',
                       Filename,
                       Settings.LastSaveDirectory,
                       Filename ) then
    exit;
  if FileExists( Filename ) then
    if not DoConfirmDlg( FileSaveTitle,
                         ReplaceFilePromptA
                         + Filename
                         + ReplaceFilePromptB ) then
      exit;

  ImageOffsets := TList.Create;

  AssignFile( F, FileName );
  Rewrite( F );
  WriteLn( F, ':userdoc.' );

  // We can't tell if some levels of the contents were
  // merged into the text of topics. So we just assume all are visible
  WriteLn( F, ':docprof toc=123456.' );

  ResourceIDs := TList.Create;

  WriteLn( F, ':title.' + H.Title );

  for i := 0 to H.TopicCount - 1 do
  begin
    T := H.Topics[ i ];

    SetProgress( i div 2, H.TopicCount , 'Saving text...' );

    WriteLn( F, '' );


    if T.ContentsLevel = 0 then
    begin
      // perhaps it means footnote?
      //      Level := 1;
      Write( F, ':fn id=fn' + IntToStr( i ) + '.' ); // use index as id

      T.SaveToIPF( F, ImageOffsets );

      WriteLn( F, '' );
      WriteLn( F, ':efn.' );
    end
    else
    begin
      Write( F, ':h' + IntToStr( T.ContentsLevel ) );
      Write( F, ' id=' + IntToStr( i ) ); // use index as id

      H.FindResourceIDsForTopic( T, ResourceIDs );
      if ResourceIDs.Count > 0 then
      begin
        Write( F, ' res=' + IntToStr( longint( ResourceIDs[ 0 ] ) ) );
      end;

      if not T.ShowInContents then
        Write( F, ' hide' );

      if T.ContentsGroupIndex > 0 then
        Write( F, ' group=' + IntToStr( T.ContentsGroupIndex ) );

      Write( F, '.' ); // end of header
      WriteLn( F, T.Title );

      T.SaveToIPF( F, ImageOffsets );
    end;



  end;

  ResourceIDs.Destroy;

  WriteLn( F, ':euserdoc.' );
  System.Close( F );

  // Now write images

  for i := 0 to ImageOffsets.Count - 1 do
  begin
    ImageOffset := longint( ImageOffsets[ i ] );

    SetProgress( i div 2 + ImageOffsets.Count div 2,
                 ImageOffsets.Count ,
                 'Saving images...' );

    Image := H.GetImage( ImageOffset );

    if Image <> nil then
    begin
      Image.SaveToFile( ExtractFilePath( Filename )
                        + 'img'
                        + IntToStr( i )
                        + '.bmp' );
      Image.Destroy;
    end;

  end;

  ResetProgress;
  SetStatus( 'Save complete' );
  ImageOffsets.Destroy;
End;

Procedure TMainForm.DebugFindBinaryMIOnClick (Sender: TObject);
Var
  DataStr: string;
  data: array[ 0.. 255 ] of byte;
  DataLen: longint;
  FileIndex: longint;
  HelpFile: THelpFile;
  i: longint;
  Topic: TTopic;

  tmpParts : TStringList;
Begin
  if not DoInputQuery( 'Binary Find',
                       'Enter data to find (decimal, separate with spaces)',
                       DataStr ) then
    exit;

  tmpParts := TStringList.Create;
  StrExtractStringsIgnoreEmpty(tmpParts, DataStr, [' '], #0);
  for i := 0 to tmpParts.count-1 do
  begin
    Data[i] := StrToInt(tmpParts[i]);
  end;
  DataLen := tmpParts.count;
  tmpParts.Destroy;

  ShowTab( piSearch );
  SearchResultsListBox.Clear;

  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];
    for i := 0 to HelpFile.TopicCount -1 do
    begin
      Topic := HelpFile.Topics[ i ];
      if Topic.SearchForData( Addr(Data), DataLen) then
      begin
        SearchResultsListBox.Items.AddObject( Topic.Title, Topic );
      end;

    end;

  end;

End;

Procedure TMainForm.TopicByNameMIOnClick (Sender: TObject);
var
  TopicNameString: string;
Begin
  if not DoInputQuery( FindTopicNameTitle,
                       FindTopicNamePrompt,
                       TopicNameString ) then
    exit;

  if not DisplayTopicByName( TopicNameString ) then
    if not DisplayTopicByGlobalName( TopicNameString ) then
      DoErrorDlg( FindTopicNameTitle,
                  TopicNameNotFoundError );
End;

Function TMainForm.pSharedStruct: TPNewHelpMgrSharedStruct;
begin
  Result := TPNewHelpMgrSharedStruct( SharedMemory.Data );
end;

Procedure TMainForm.CopyLinkLocationPMIOnClick (Sender: TObject);
Begin

End;

Procedure TMainForm.HelpKeysMIOnClick (Sender: TObject);
Begin
//  Application.Help( 10 );
End;

Procedure TMainForm.MainFormOnCommand (Sender: TObject; Var Command: TCommand);
Begin
  case Command of
    kbF11:
      NavigatePreviousInContents;

    kbF12:
      NavigateNextInContents;

    kbF7,
    kbCtrlCLeft:
      NavigateBack;

    kbF8:
      NavigateForward;
  end;
End;

Procedure TMainForm.MainFormOnScan (Sender: TObject; Var KeyCode: TKeyCode);
Begin
End;

Procedure TMainForm.ShowLeftPanelMIOnClick (Sender: TObject);
Begin
  ShowLeftPanel := not ShowLeftPanel;
End;

Procedure TMainForm.CoolBarOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( Coolbar.Font );
End;

Procedure TMainForm.NotebookOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( Notebook.Font );
End;

Procedure TMainForm.TabSetOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( TabSet.Font );
End;

Procedure TMainForm.IndexListBoxOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( IndexListBox.Font );
End;

Procedure TMainForm.NotesListBoxOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( NotesListBox.Font );
End;

Procedure TMainForm.DisplayPanelOnFontChange (Sender: TObject);
Begin
  SetTopicFont( DisplayPanel.Font );
End;

Procedure TMainForm.SetTopicFont( NewFont: TFont );
var
  ShiftPressed: boolean;
Begin
  if SettingFont or StartingUp then
    exit;
  LogEvent(LogSettings, 'SetTopicFont');

  SettingFont := true;

  ShiftPressed := ( WinGetKeyState( HWND_DESKTOP,
                       VK_SHIFT ) and $8000 ) > 0;
  if ShiftPressed then
    Settings.FixedFont := NewFont
  else
    Settings.NormalFont := NewFont;

  LogEvent(LogSettings, 'Saving settings');

  SaveSettings;
  LogEvent(LogSettings, 'Applying settings');
  ApplySettings;

  SettingFont := false;
  LogEvent(LogSettings, 'SetTopicFont done');
End;

Procedure TMainForm.ContentsOutlineOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( ContentsOutline.Font );
End;

Procedure TMainForm.SetApplicationFont( NewFont: TFont );
Begin
  if ( not SettingFont ) and ( not StartingUp ) then
  begin
    Settings.Fonts[ ApplicationFontIndex ] := NewFont;
    SaveSettings;
    ApplySettings;
    SetLayout;
  end;
End;

Procedure TMainForm.SearchResultsListBoxOnFontChange (Sender: TObject);
Begin
  SetApplicationFont( SearchResultsListBox.Font );
End;

Procedure TMainForm.OnDragOverWindow(Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
Begin
  if Source is TExternalDragDropObject then
    Accept := true;

End;

Procedure TMainForm.OnDragDropToWindow(Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt);
Begin
  OpenDroppedFile( Source );
End;

Procedure TMainForm.OnWindowTab( Sender: TObject );
Begin
  OnWindowBackTab( Sender ); // for now
End;

Procedure TMainForm.OnWindowBackTab( Sender: TObject );
Begin
  case NoteBook.PageIndex of
    piContents:
      ContentsOutline.Focus;
    piIndex:
      IndexListBox.Focus;
    piSearch:
      SearchResultsListBox.Focus;
    piNotes:
      NotesListBox.Focus;
  end;
End;

Procedure TMainForm.OnWindowFontChange( Sender: TObject );
begin
  if not DisplayingTopicWindow then
    SetTopicFont( TControl(Sender).Font );
end;

Procedure TMainForm.DisplayPanelOnDragOver (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
Begin
  if Source is TExternalDragDropObject then
    Accept := true;
End;

Procedure TMainForm.NotesListBoxOnDragOver (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
Begin
  if Source is TExternalDragDropObject then
    Accept := true;
End;

Procedure TMainForm.DisplayPanelOnDragDrop (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt);
Begin
  OpenDroppedFile( Source );
End;

Procedure TMainForm.NotesListBoxOnDragDrop (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt);
Begin
  OpenDroppedFile( Source );
End;

Procedure TMainForm.SearchResultsListBoxOnDragDrop (Sender: TObject;
  Source: TObject; X: LongInt; Y: LongInt);
Begin
  OpenDroppedFile( Source );
End;

Procedure TMainForm.SearchResultsListBoxOnDragOver (Sender: TObject;
  Source: TObject; X: LongInt; Y: LongInt; State: TDragState;
  Var Accept: Boolean);
Begin
  if Source is TExternalDragDropObject then
    Accept := true;
End;

Procedure TMainForm.IndexListBoxOnDragDrop (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt);
Begin
  OpenDroppedFile( Source );
End;

Procedure TMainForm.IndexListBoxOnDragOver (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
Begin
  if Source is TExternalDragDropObject then
    Accept := true;
End;

Procedure TMainForm.ContentsOutlineOnDragOver (Sender: TObject;
  Source: TObject; X: LongInt; Y: LongInt; State: TDragState;
  Var Accept: Boolean);
Begin
  if Source is TExternalDragDropObject then
    Accept := true;
End;

Procedure TMainForm.ContentsOutlineOnDragDrop (Sender: TObject;
  Source: TObject; X: LongInt; Y: LongInt);
Begin
  OpenDroppedFile( Source );
End;

Procedure TMainForm.OpenDroppedFile( Source: TObject );
var
  DropObject: TExternalDragDropObject;
Begin
  if not ( Source is TExternalDragDropObject ) then
    // probably not needed, but crashes during drag drop completely
    // screw PM, so best to be sure!
    exit;

  DropObject := Source as TExternalDragDropObject;

  g_ExternalLinkFileName := AddDirectorySeparator( DropObject.ContainerName )
                            + DropObject.SourceFilename;
  g_ExternalLinkTopic := '';
  g_ExternalLinkSourceFilename := ''; // don't care

  g_ExternalLinkKeepCurrent := ( WinGetKeyState( HWND_DESKTOP,
                                                 VK_SHIFT ) and $8000 ) > 0;
  PostMsg( Self.Handle,
           WM_FOLLOWEXTERNALLINK,
           0,
           0 );

End;

Procedure TMainForm.MainFormOnDragOver (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt; State: TDragState; Var Accept: Boolean);
Begin
  Accept := true;
End;

Procedure TMainForm.MainFormOnDragDrop (Sender: TObject; Source: TObject;
  X: LongInt; Y: LongInt);
Begin
End;

Procedure TMainForm.ContentsOutlineOnItemClick (Node: TNode);
Begin
  DisplaySelectedContentsTopic;
End;

Procedure TMainForm.SetMainCaption;
begin
  if    ( Trim( MainTitle ) = '' )
     or ( StrEqualIgnoringCase( Trim( MainTitle ), HelpProgramTitle ) ) then
    // supress "Help - " or "Help - Help"
    Caption := HelpProgramTitle
  else
    Caption := HelpProgramTitle + ' - ' + MainTitle
end;

Procedure TMainForm.OnLanguageEvent(Language: TLanguageFile; const Apply: boolean);
var
  tmpPrefix : String;
Begin
  // get rid of mru menu items
  DestroyListObjects( MRUMenuItems );
  MRUMenuItems.Clear;

  Language.LoadComponentLanguage( self, Apply );

  if Apply then
  begin
    // copy menu hints to toolbar hints
    Coolbar.Sections[ ciOpen ].Hint := OpenMI.Hint;
    Coolbar.Sections[ ciPrint ].Hint := PrintMI.Hint;
    Coolbar.Sections[ ciNavigator ].Hint := ShowLeftPanelMI.Hint;
    Coolbar.Sections[ ciBack ].Hint := NavigateBackMI.Hint;
    Coolbar.Sections[ ciForward ].Hint := NavigateForwardMI.Hint;
    Coolbar.Sections[ ciAddNote ].Hint := AddNoteMI.Hint;
    Coolbar.Sections[ ciAddBookmark ].Hint := AddBookmarkMI.Hint;
    Coolbar.Sections[ ciPrevious ].Hint := NavigatePreviousMI.Hint;
    Coolbar.Sections[ ciNext ].Hint := NavigateNextMI.Hint;
    Coolbar.Sections[ ciGlobalSearch ].Hint := GlobalSearchMI.Hint;
  end;

  // Load strings referred to by code...
  // ----------------------------------------------------------
  tmpPrefix := 'MainForm' + LANGUAGE_LABEL_DELIMITER;

  Language.LL( Apply, FileOpenTitle, tmpPrefix + 'FileOpenTitle', 'Open Help Files' );
  Language.LL( Apply, LoadingFileMsg, tmpPrefix + 'LoadingFileMsg', 'Loading file ' );
  Language.LL( Apply, HelpFileError, tmpPrefix + 'HelpFileError', 'Could not open ' );
  Language.LL( Apply, LoadingStatusDisplaying, tmpPrefix + 'LoadingStatusDisplaying', 'Displaying...' );
  Language.LL( Apply, LoadingStatusNotesAndBookmarks, tmpPrefix + 'LoadingStatusNotesAndBookmarks', 'Loading notes/bookmarks...' );
  Language.LL( Apply, LoadingStatusContents, tmpPrefix + 'LoadingStatusContents', 'Display contents... ' );
  Language.LL( Apply, LoadingStatusIndex, tmpPrefix + 'LoadingStatusIndex', 'Display index... ' );
  Language.LL( Apply, LoadingStatusDone, tmpPrefix + 'LoadingStatusDone', 'Done' );

  Language.LL( Apply, HelpFilesDesc, tmpPrefix + 'HelpFilesDesc', 'Help Files (*.inf,*.hlp)' );
  Language.LL( Apply, AllFilesDesc, tmpPrefix + 'AllFilesDesc', 'All Files (*)' );
  Language.LL( Apply, LanguageFilesDesc, tmpPrefix + 'LanguageFilesDesc', 'NewView Language Files (*.lng)' );

  Language.LL( Apply, SaveLanguageTitle, tmpPrefix + 'SaveLanguageTitle', 'Save/Update Language File' );
  Language.LL( Apply, OpenLanguageTitle, tmpPrefix + 'OpenLanguageTitle', 'Open Language File' );
  Language.LL( Apply, SaveLanguageError, tmpPrefix + 'SaveLanguageError', 'Error saving language file: ' );

  Language.LL( Apply, HelpManagerVersionTitle, tmpPrefix + 'HelpManagerVersionTitle', 'Help Manager Version' );

  Language.LL( Apply, FindResourceIDTitle, tmpPrefix + 'FindResourceIDTitle', 'Find Resource ID' );
  Language.LL( Apply, FindResourceIDPrompt, tmpPrefix + 'FindResourceIDPrompt', 'Enter the resource ID to find' );
  Language.LL( Apply, InvalidResourceIDError, tmpPrefix + 'InvalidResourceIDError', 'Invalid resource ID entered' );
  Language.LL( Apply, ResourceIDNotFoundError, tmpPrefix + 'ResourceIDNotFoundError', 'Resource ID not found' );

  Language.LL( Apply, OpenSpecialTitle, tmpPrefix + 'OpenSpecialTitle', 'Open Special' );
  Language.LL( Apply, OpenSpecialPrompt, tmpPrefix + 'OpenSpecialPrompt', 'Enter help filename/environment variable name' );

  Language.LL( Apply, PrintTopicTitle, tmpPrefix + 'PrintTopicTitle', 'Print Topic' );
  Language.LL( Apply, NoPrinterError, tmpPrefix + 'NoPrinterError', 'You don''t have a printer configured.' );
  Language.LL( Apply, SelectWindowToPrintError, tmpPrefix + 'SelectWindowToPrintError', 'You must select the window you want to print.' );
  Language.LL( Apply, PrintingComplete, tmpPrefix + 'PrintingComplete', 'Printing complete' );
  Language.LL( Apply, PrintingError, tmpPrefix + 'PrintingError', 'Error while printing: ' );
  Language.LL( Apply, StoppingPrintMsg, tmpPrefix + 'StoppingPrintMsg', 'Stopping print...' );
  Language.LL( Apply, PrintStoppedMsg, tmpPrefix + 'PrintStoppedMsg', 'Printing stopped' );
  Language.LL( Apply, CheckStopPrintTitle, tmpPrefix + 'CheckStopPrintTitle', 'Stop Print?' );
  Language.LL( Apply, CheckStopPrintMsg, tmpPrefix + 'CheckStopPrintMsg', 'Printing is still in progress. It will be stopped if you close.' );

  Language.LL( Apply, TopicInfoTitle, tmpPrefix + 'TopicInfo.Title', 'Topic Information' );
  Language.LL( Apply, TopicInfoTopicTitle, tmpPrefix + 'TopicInfo.TopicTitle',   'Title: ' );
  Language.LL( Apply, TopicInfoIndex, tmpPrefix + 'TopicInfo.Index',             'Index: ' );
  Language.LL( Apply, TopicInfoFile, tmpPrefix + 'TopicInfo.File',               'File:  ' );
  Language.LL( Apply, TopicInfoResourceIDs, tmpPrefix + 'TopicInfo.ResourceIDs', 'Resource IDs:' );
  Language.LL( Apply, TopicInfoNoResourceIDs, tmpPrefix + 'TopicInfo.NoResourceIDs', '  (None)' );

  Language.LL( Apply, ParameterCountLabel, tmpPrefix + 'ParameterCountLabel', 'Parameter Count: ' );

  Language.LL( Apply, NewViewHelpTitle, tmpPrefix + 'NewViewHelpTitle', 'NewView Help' );
  Language.LL( Apply, AlreadyNewviewHelp, tmpPrefix + 'AlreadyNewviewHelp', 'You are already viewing the NewView help file' );
  Language.LL( Apply, NewViewHelpNotFound, tmpPrefix + 'NewViewHelpNotFound', 'Couldn''t find the NewView helpfile: ' );

  Language.LL( Apply, InvalidLinkErrorTitle, tmpPrefix + 'InvalidLinkErrorTitle', 'Invalid Link' );
  Language.LL( Apply, InvalidLinkError, tmpPrefix + 'InvalidLinkError', 'Cannot follow link to nonexistent topic' );
  Language.LL( Apply, InvalidResourceIDLinkErrorA, tmpPrefix + 'InvalidResourceIDLinkErrorA', 'Could not find linked topic (Resource #' );
  Language.LL( Apply, InvalidResourceIDLinkErrorB, tmpPrefix + 'InvalidResourceIDLinkErrorB', '). This may be from another file.' );

  Language.LL( Apply, OpenedTopicMsg, tmpPrefix + 'OpenedTopicMsg', 'Opened topic #' );

  Language.LL( Apply, AddNoteTitle, tmpPrefix + 'AddNoteTitle', 'Add Note' );
  Language.LL( Apply, AddNoteCursorError, tmpPrefix + 'AddNoteCursorError', 'Before adding a note, position the cursor where you want the note to be placed.' );
  Language.LL( Apply, NoteWithinNoteError, tmpPrefix + 'NoteWithinNoteError', 'You can''t add a note within a link or another note' );
  Language.LL( Apply, LoadNotesTitle, tmpPrefix + 'LoadNotesTitle', 'Load Notes' );
  Language.LL( Apply, LoadNotesError, tmpPrefix + 'LoadNotesError', 'Error loading notes from ' );
  Language.LL( Apply, SaveNotesTitle, tmpPrefix + 'SaveNotesTitle', 'Save Notes' );
  Language.LL( Apply, SaveNotesError, tmpPrefix + 'SaveNotesError', 'Error saving notes to ' );

  Language.LL( Apply, UntitledBookmarkName, tmpPrefix + 'UntitledBookmarkName', '(Untitled)' );
  Language.LL( Apply, LoadBookmarksTitle, tmpPrefix + 'LoadBookmarksTitle', 'Load Bookmarks' );
  Language.LL( Apply, LoadBookmarksError, tmpPrefix + 'LoadBookmarksError', 'Could not load bookmarks: ' );
  Language.LL( Apply, SaveBookmarksTitle, tmpPrefix + 'SaveBookmarksTitle', 'Save Bookmarks' );
  Language.LL( Apply, SaveBookmarksError, tmpPrefix + 'SaveBookmarksError', 'Could not save bookmarks: ' );

  Language.LL( Apply, ApplicationErrorTitle, tmpPrefix + 'ApplicationErrorTitle', 'Application Error - Close?' );
  Language.LL( Apply, ApplicationErrorA, tmpPrefix + 'ApplicationErrorA', 'This application has crashed. ' );
  Language.LL( Apply, ApplicationErrorB, tmpPrefix + 'ApplicationErrorB', '(Details logged to ' );
  Language.LL( Apply, ApplicationErrorC, tmpPrefix + 'ApplicationErrorC', 'Close application? ' );

  Language.LL( Apply, EnvironmentVarErrorTitle, tmpPrefix + 'EnvironmentVarErrorTitle', 'Environment Variable Warning' );
  Language.LL( Apply, EnvironmentVarError,
      tmpPrefix + 'EnvironmentVarError',
      'NewView found a problem with environment variables. '
      + 'These are used when finding help files. '
      + 'You may have problems launching help.' );
  Language.LL( Apply, EnvironmentVarUndefined, tmpPrefix + 'EnvironmentVarUndefined', 'Undefined: ' );

  Language.LL( Apply, FindTitle, tmpPrefix + 'FindTitle', 'Find' );
  Language.LL( Apply, FindSelectWindowError, tmpPrefix + 'FindSelectWindowError', 'Click in a window first' );
  Language.LL( Apply, FindPrompt, tmpPrefix + 'FindPrompt', 'Enter the text to find' );
  Language.LL( Apply, TextNotFoundMsg, tmpPrefix + 'TextNotFoundMsg', 'Text not found' );

  Language.LL( Apply, FilesInfoTitle, tmpPrefix + 'FilesInfoTitle', 'Open Files Information' );
  Language.LL( Apply, FilesInfoOverallTitle, tmpPrefix + 'FilesInfoOverallTitle', 'Title: ' );
  Language.LL( Apply, FilesInfoFilename, tmpPrefix + 'FilesInfoFilename', 'Filename: ' );
  Language.LL( Apply, FilesInfoFileTitle, tmpPrefix + 'FilesInfoFileTitle', '  Title: ' );
  Language.LL( Apply, FilesInfoTopicCount, tmpPrefix + 'FilesInfoTopicCount', '  Topic Count: ' );
  Language.LL( Apply, FilesInfoIndexCount, tmpPrefix + 'FilesInfoIndexCount', '  Index Count: ' );
  Language.LL( Apply, FilesInfoDictionaryCount, tmpPrefix + 'FilesInfoDictionaryCount', '  Dictionary Count: ' );
  Language.LL( Apply, FilesInfoFileSize, tmpPrefix + 'FilesInfoFileSize', '  Size: ' );
  Language.LL( Apply, FilesInfoTotalTopicCount, tmpPrefix + 'FilesInfoTotalTopicCount', 'Total Topic Count: ' );
  Language.LL( Apply, FilesInfoTotalIndexCount, tmpPrefix + 'FilesInfoTotalIndexCount', 'Total Index Count: ' );
  Language.LL( Apply, FilesInfoTotalFileSize, tmpPrefix + 'FilesInfoTotalFileSize', 'Total File Size: ' );

  Language.LL( Apply, SearchTitle, tmpPrefix + 'SearchTitle', 'Search' );
  Language.LL( Apply, SearchSyntaxError, tmpPrefix + 'SearchSyntaxError', 'Error in search syntax: ' );
  Language.LL( Apply, SearchingMsg, tmpPrefix + 'SearchingMsg', 'Searching...' );
  Language.LL( Apply, NoSearchMatchesMsg, tmpPrefix + 'NoSearchMatchesMsg', 'No matches found for ' );
  Language.LL( Apply, SearchFoundMsgA, tmpPrefix + 'SearchFoundMsgA', 'Found ' );
  Language.LL( Apply, SearchFoundMsgB, tmpPrefix + 'SearchFoundMsgB', ' matches for ' );

  Language.LL( Apply, FileSaveTitle, tmpPrefix + 'FileSaveTitle', 'Save Topic' );
  Language.LL( Apply, FileSaveSelectWindowError, tmpPrefix + 'FileSaveSelectWindowError', 'Before saving, click in the window you want to save.' );
  Language.LL( Apply, DefaultSaveTopicFilename, tmpPrefix + 'DefaultSaveTopicFilename', 'topic.txt' );

  Language.LL( Apply, ReplaceFilePromptA, tmpPrefix + 'ReplaceFilePromptA', 'Replace existing file ' );
  Language.LL( Apply, ReplaceFilePromptB, tmpPrefix + 'ReplaceFilePromptB', '?' );
  Language.LL( Apply, UnableToSaveError, tmpPrefix + 'UnableToSaveError', 'Unable to save file: ' );

  Language.LL( Apply, UsageTitle, tmpPrefix + 'UsageTitle', 'NewView Command Line' );
  Language.LL( Apply, UsageText1, tmpPrefix + 'UsageText1', 'Usage: ' );
  Language.LL( Apply, UsageText2, tmpPrefix + 'UsageText2', 'NewView <filename> [<topic>]' );
  Language.LL( Apply, UsageText3, tmpPrefix + 'UsageText3', ' /s Do search for <topic>' );
  Language.LL( Apply, UsageText4, tmpPrefix + 'UsageText4', ' /g Do global search for <topic>' );
  Language.LL( Apply, UsageText5, tmpPrefix + 'UsageText5', ' /pos:l,b,w,h Set window position' );
  Language.LL( Apply, UsageText6, tmpPrefix + 'UsageText6', ' /lang:<lang> Load UI language' );
  Language.LL( Apply, UsageText7, tmpPrefix + 'UsageText7', ' /title:<title> Set window title' );
  Language.LL( Apply, UsageText8, tmpPrefix + 'UsageText8', 'See help for details' );

  Language.LL( Apply, GoBackHint, tmpPrefix + 'GoBackHint', 'Go back to ' );

  Language.LL( Apply, SelectAllTitle, tmpPrefix + 'SelectAllTitle', 'Select All' );
  Language.LL( Apply, SelectAllWindowError, tmpPrefix + 'SelectAllWindowError', 'Click in a text window first' );

  Language.LL( Apply, EditNoteMsg, tmpPrefix + 'EditNoteMsg', 'Click to edit note' );
  Language.LL( Apply, ExternalLinkMsg, tmpPrefix + 'ExternalLinkMsg', 'Link to another file' );
  Language.LL( Apply, LinkMsg, tmpPrefix + 'LinkMsg', 'Link to' );
  Language.LL( Apply, UnknownLinkMsg, tmpPrefix + 'UnknownLinkMsg', 'Unknown link' );
  Language.LL( Apply, FootnoteMsg, tmpPrefix + 'FootnoteMsg', 'Footnote' );

  Language.LL( Apply, ExternalLinkTitle, tmpPrefix + 'ExternalLinkTitle', 'File Link' );
  Language.LL( Apply, ExternalLinkError, tmpPrefix + 'ExternalLinkError', 'Sorry, this is a link to another file, which is not currently implemented in NewView' );

  Language.LL( Apply, MRUMultipleFilesHint, tmpPrefix + 'MRUMultipleFilesHint', 'files' );
  Language.LL( Apply, HelpProgramTitle, tmpPrefix + 'HelpProgramTitle', 'Help' );

  Language.LL( Apply, WindowsHelpTitle, tmpPrefix + 'WindowsHelpTitle', 'Windows Help' );
// TODO
  Language.LL( Apply,
               WindowsHelpPrompt,
               tmpPrefix + 'WindowsHelpPrompt',
               'This file is a Windows help file. '
               + 'Would you like to start Windows Help viewer?' );

  Language.LL( Apply, ErrorTitle, tmpPrefix + 'ErrorTitle', 'Error' );

  Language.LL( Apply, FindTopicNameTitle, tmpPrefix + 'FindTopicNameTitle', 'Find Topic By Name' );
  Language.LL( Apply, FindTopicNamePrompt, tmpPrefix + 'FindTopicNamePrompt', 'Enter the topic name to search for' );
  Language.LL( Apply, TopicNameNotFoundError, tmpPrefix + 'TopicNameNotFoundError', 'Topic name not found' );
  Language.LL( Apply, SplitBarDblClickToShow, tmpPrefix + 'SplitBarDblClickToShow', 'Double-click to show left panel' );
  Language.LL( Apply, SplitBarDblClickToHide, tmpPrefix + 'SplitBarDblClickToHide', 'Double-click to hide left panel' );

  SetMainCaption;
  CreateMRUMenuItems;

  // ----------------------------------------------------------
end;

Procedure TMainForm.DebugLoadLanguageMIOnClick (Sender: TObject);
Var
  Dir: string;
  Filename: string;
Begin
  Dir := GetApplicationDir;
  if not DoOpenFileDialog( OpenLanguageTitle,
                           LanguageFilesDesc
                           + '|*.lng|'
                           + AllFilesDesc
                           + '|*',
                           '*.lng',
                           Dir,
                           Filename ) then
    exit;

  LoadLanguage( Filename );
End;

Procedure TMainForm.DebugSaveLanguageFileMIOnClick (Sender: TObject);
Var
  // LanguageFile: TLanguageFile;
  Dir: string;
  Filename: string;
Begin
  Dir := GetApplicationDir;
  if not DoSaveFileDialog( SaveLanguageTitle,
                           LanguageFilesDesc
                           + '|*.lng|'
                           + AllFilesDesc
                           + '|*',
                           '*.lng',
                           Dir,
                           Filename ) then
    exit;

  // get rid of mru menu items so they don't clutter the language file
  DestroyListObjects( MRUMenuItems );
  MRUMenuItems.Clear;

  try
    // first touch all
    UpdateLanguage(g_CurrentLanguageFile);
    // then save
    g_CurrentLanguageFile.writeToFile(Filename);
  except
    on E: Exception do
    begin
      DoErrorDlg( SaveLanguageTitle,
                  SaveLanguageError + E.Message );
      exit;
    end;
  end;

  CreateMRUMenuItems;
End;

Procedure TMainForm.SearchResultsListBoxOnClick (Sender: TObject);
Begin
  DisplaySelectedSearchResultTopic;
End;

Procedure TMainForm.VSplitBarOnDblClick (Sender: TObject);
Begin
  ShowLeftPanel := not ShowLeftPanel;
End;

Procedure TMainForm.DebugHelpManagerVersionMIOnClick (Sender: TObject);
Begin
  DoMessageDlg( HelpManagerVersionTitle,
                HelpManagerVersion );
End;

Procedure TMainForm.DebugTopicByResourceIDMIOnClick (Sender: TObject);
var
  ResourceIDString: string;
  ResourceID: USHORT;
Begin
  if not DoInputQuery( FindResourceIDTitle,
                       FindResourceIDPrompt,
                       ResourceIDString ) then
    exit;
  try
    ResourceID := StrToInt( ResourceIDString );
  except
    DoErrorDlg( FindResourceIDTitle,
                InvalidResourceIDError );
    exit;
  end;

  if not DisplayTopicByResourceID( ResourceID ) then
    DoErrorDlg( FindResourceIDTitle,
                ResourceIDNotFoundError );
End;

Procedure TMainForm.ViewHighlightSearchWordsMIOnClick (Sender: TObject);
Begin
  ViewHighlightSearchWordsMI.Checked := not ViewHighlightSearchWordsMI.Checked;
  RefreshWindows( Windows );
End;

Procedure TMainForm.FileNewWindowMIOnClick (Sender: TObject);
Begin
  Exec( GetApplicationFilename, '' );
End;

Function TMainForm.OpenFilesFromTextList( const TextList: string;
                                          const DisplayFirstTopic: boolean ): boolean;
var
  tmpFileNames: TStringList;
begin
  tmpFileNames := TStringList.Create;

  ParseAndExpandFileNames(TextList, tmpFileNames);
  if tmpFileNames.Count > 0 then
  begin
    result := OpenFiles(tmpFileNames, '', DisplayFirstTopic);
  end
  else
  begin
    CloseFile;
  end;
  tmpFileNames.Destroy;
end;

Procedure TMainForm.OpenSpecialMIOnClick (Sender: TObject);
var
  Parameter: string;
Begin
  if not OKToCloseFile then
    exit;

  if DoInputQuery( OpenSpecialTitle,
                   OpenSpecialPrompt,
                   Parameter ) then
  begin
    if OpenFilesFromTextList( Parameter, true ) then
    begin
      ClearHelpManager;
    end;
  end;
End;

Procedure TMainForm.NotesListBoxOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  if KeyCode in [ kbDel, kbBkSp ] then
    if NotesListBox.ItemIndex <> -1 then
      DeleteNote( NotesListBox.ItemIndex );
End;

Procedure TMainForm.ViewPopupMenuOnPopup (Sender: TObject);
var
  Window: THelpWindow;
Begin
  Window := GetActiveWindow;
  if Window = nil then
  begin
    SearchPMI.Enabled := false;
    exit;
  end;
  SearchPMI.Enabled := Window.View.SelectionLength > 0;
End;

Procedure TMainForm.SearchPMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
Begin
  Window := GetActiveWindow;
  if Window = nil then
    exit;

  SearchFor( Window.View.GetSelectionAsString );
end;

function TMainForm.DisplayTopicByGlobalName( const TopicName: string ): boolean;
var
  Topic: TTopic;
begin
  Topic := FindTopicByGlobalName( TopicName );
  if Topic = nil then
  begin
    Result := false;
    exit;
  end;

  result := true;

  DisplayTopic( Topic );
end;

function TMainForm.DisplayTopicByName( const TopicName: string ): boolean;
var
  Topic: TTopic;
begin
  Topic := FindTopicByName( TopicName );
  if Topic = nil then
  begin
    Result := false;
    exit;
  end;

  result := true;

  DisplayTopic( Topic );
end;

function TMainForm.DisplayTopicByResourceID( ID: uint16 ): boolean;
var
  Topic: TTopic;
begin
  LogEvent(LogDebug, 'DisplayTopicByResourceID id:' + IntToStr(ID));
  Topic := FindTopicByResourceID( ID );
  if Topic = nil then
  begin
    LogEvent(LogDebug, 'DisplayTopicByResourceID - topic not found');
    Result := false;
    exit;
  end;

  result := true;

  LogEvent(LogDebug, 'DisplayTopicByResourceID topic: "' + Topic.Title + '"');
  DisplayTopic( Topic );
end;

Procedure TMainForm.ViewSourceMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
Begin
  Window := GetActiveWindow;
  if Window = nil then
    exit;
  InformationForm.FText := Window.View.Text;
  InformationForm.ShowModal;
End;

Procedure TMainForm.PrintMIOnClick (Sender: TObject);
Begin
  PrintTopics;
End;

type
  TPrintSingle = class
    Topic: TTopic;
  end;

  TPrintList = class
    Topics: TList;
    constructor Create;
    destructor Destroy; override;
  end;

  TPrintAll = class
  end;

constructor TPrintList.Create;
begin
  Topics := TList.Create;
end;

destructor TPrintList.Destroy;
begin
  Topics.Destroy;
end;

// Recursive
Procedure GetTopicsInWindows( Windows: TList;
                              Topics: TList );
var
  Window: THelpWindow;
  i: longint;
begin
  for i := 0 to Windows.Count - 1 do
  begin
    Window := Windows[ i ];
    Topics.Add( Window.Topic );
    GetTopicsInWindows( Window.ChildWindows, Topics );
  end;
end;

Procedure TMainForm.PrintTopics;
var
  Window: THelpWindow;
  PrintParameters: TObject;
Begin
  if Printer.Printers.Count = 0 then
  begin
    DoErrorDlg( PrintTopicTitle,
                NoPrinterError );
    exit;
  end;

  if NewViewPrintDialog.ShowModal <> mrOK then
    exit;

  if PrintThread = nil then
  begin
     PrintThread := TGenericThreadManager.Create( self );
     PrintThread.OnProgressUpdate := OnPrintProgress;
     PrintThread.OnJobComplete := OnPrintComplete;

  end;

  case NewViewPrintDialog.WhatToPrintRadioGroup.ItemIndex of
    0:
    begin
      PrintParameters := TPrintSingle.Create;
      Window := GetActiveWindow;
      TPrintSingle( PrintParameters ).Topic := Window.Topic;
    end;

    1:
    begin
      PrintParameters := TPrintList.Create;
      GetTopicsInWindows( Windows,
                          TPrintList( PrintParameters ).Topics );
    end;

    2:
    begin
      PrintParameters := TPrintAll.Create;
    end;
  end;

  PrintThread.StartJob( DoPrinting, PrintParameters );

  SetStatus( 'Printing...' );
end;

procedure PrintTopic( Topic: TTopic;
                      RichTextSettings: TRichTextSettings;
                      Var PageY: longint );
var
  TopicText: TAstring;
  TitleText: TAString;
  ImageOffsets: TList;
  Images: TImageList;
begin
  TopicText := TAstring.Create;
  Images := TImageList.Create( nil );
  TitleText := TAString.Create;
  ImageOffsets := TList.Create;

  TitleText.AddString( '<leftmargin 1><h1>'
                       + Topic.Title
                       + '</h>'
                       + #10
                       + #10 );
  PrintRichText( TitleText.AsPChar,
                 Images,
                 RichTextSettings,
                 PageY );

  Topic.GetText( nil, // no highlights
                 false, // no codes
                 false, // no word separators
                 TopicText, // text to print
                 ImageOffsets, // image offsets
                 nil ); // no highlight matches required

  THelpFile( Topic.HelpFile ).GetImages( ImageOffsets,
                                         Images );

  PrintRichText( TopicText.AsPChar,
                 Images,
                 RichTextSettings,
                 PageY );

  TitleText.Clear;
  TitleText.AddString(   #10
                       + '<leftmargin 1><align center>'
                       + '--------------------------------------------'
                       + #10
                       + #10 );
  PrintRichText( TitleText.AsPChar,
                 Images,
                 RichTextSettings,
                 PageY );

  ImageOffsets.Destroy;
  TitleText.Destroy;
  Images.Destroy;
  TopicText.Destroy;
end;

function TMainForm.DoPrinting( Parameters: TObject ): TObject;
var
  PrintSingle: TPrintSingle;
  PrintList: TPrintList;
  PageY: longint;
  RichTextSettings: TRichTextSettings;
  PrinterResolution: longint;
  MarginSize: longint;

  HelpFile: THelpFile;

  FileIndex: longint;
  TopicIndex: longint;

  TotalTopics: longint;
  TotalTopicIndex: longint;
begin
  PrintSingle := nil;
  PrintList := nil;

  if Parameters is TPrintSingle then
    PrintSingle := Parameters as TPrintSingle
  else if Parameters is TPrintList then
    PrintList := Parameters as TPrintList;

  if Parameters is TPrintSingle then
    Printer.Title := PrintSingle.Topic.Title
  else
    Printer.Title := MainTitle;

  Printer.BeginDoc;

  PageY := Printer.PageHeight - 1;

  RichTextSettings := TRichTextSettings.Create( nil );
  RichTextSettings.NormalFont := Settings.NormalFont;
  RichTextSettings.FixedFont := Settings.FixedFont;

  // set half inch margins
  PrinterResolution := Printer.Canvas.HorizontalResolution; // pixels per meter!
  MarginSize := Round( PrinterResolution * 0.0125 ); // 12.5 mm = 0.5 inch
  RichTextSettings.Margins := Rect( MarginSize,
                                    MarginSize,
                                    MarginSize,
                                    MarginSize );

  try
    if Parameters is TPrintSingle then
    begin
      PrintTopic( PrintSingle.Topic, RichTextSettings, PageY );
    end

    else if Parameters is TPrintList then
    begin
      for TopicIndex := 0 to PrintList.Topics.Count -1 do
      begin
        PrintThread.UpdateProgress( TopicIndex, PrintList.Topics.Count, 'Printing' );

        PrintTopic( PrintList.Topics[ TopicIndex ] , RichTextSettings, PageY );

        if PrintThread.StopRequested then
          break;
      end
    end

    else if Parameters is TPrintAll then
    begin
      // first count up total number of topics.
      TotalTopics := 0;
      for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
      begin
        HelpFile := CurrentOpenFiles[ FileIndex ];
        inc( TotalTopics, HelpFile.TopicCount );
      end;

      TotalTopicIndex := 0;
      for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
      begin
        HelpFile := CurrentOpenFiles[ FileIndex ];
        for TopicIndex := 0 to HelpFile.TopicCount - 1 do
        begin
          PrintThread.UpdateProgress( TotalTopicIndex, TotalTopics, 'Printing' );
          PrintTopic( HelpFile.Topics[ TopicIndex ], RichTextSettings, PageY );
          if PrintThread.StopRequested then
            break;
          inc( TotalTopicIndex );
        end;
      end;
    end;
  except
    on E: EPrinter do
    begin
      DoErrorDlg( PrintTopicTitle,
                  PrintingError + E.Message );
    end;
  end;

  Printer.EndDoc;
  result := nil;
End;

procedure TMainForm.OnPrintProgress( n, outof: integer;
                                     Message: string );
begin
  SetProgress( n, outof, message );
end;

procedure TMainForm.OnPrintComplete( Dummy: TObject );
begin
  SetStatus(PrintingComplete);
  ResetProgress;
end;

// --------------------------------------------------

Procedure TMainForm.DebugShowWordSeparatorsMIOnClick (Sender: TObject);
Begin
  DebugShowWordSeparatorsMI.Checked := not DebugShowWordSeparatorsMI.Checked;
  RefreshWindows( Windows );
End;

Procedure TMainForm.DebugStressTestMIOnClick (Sender: TObject);
var
  i: longint;
  NString: string;
  N: longint;
Begin
  if not DoInputQuery( 'Stress Test',
                       'Repititions?',
                       NString ) then
    exit;
  N := StrToIntDef( NString, 1 );
  for i := 0 to N - 1 do
  begin
    ContentsOutline.GotoFirstNode;
    repeat
      DisplaySelectedContentsTopic;
      Application.ProcessMessages;
    until not ContentsOutline.GotoNextNodeDown;
  end;
End;

// Find topic specified by global name, in all open files
Function TMainForm.FindTopicByGlobalName( const Name: string ): TTopic;
var
  FileIndex: longint;
  HelpFile: THelpFile;
begin
  Result := nil;

  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];
    Result := HelpFile.FindTopicByGlobalName( Name );
    if Result <> nil then
      // found
      exit;
  end;

  // not found.
  Result := nil;
end;

// Find topic specified by numeric resource ID, in all open files
Function TMainForm.FindTopicByResourceID( ID: uint16 ): TTopic;
var
  FileIndex: longint;
  HelpFile: THelpFile;
begin
  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];

    Result := HelpFile.FindTopicByResourceID( ID );
    if Result <> nil then
      // found
      exit;
  end;

  // not found.
  Result := nil;
end;

// Find topic specified by text name, in all open files
Function TMainForm.FindTopicByName( const Name: string ): TTopic;
var
  FileIndex: longint;
  HelpFile: THelpFile;
begin
  Result := nil;

  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];
    Result := HelpFile.FindTopicByLocalName( Name );
    if Result <> nil then
      // found
      exit;
  end;

  // not found.
  Result := nil;
end;

// Find the target topic for the given link
Function TMainForm.FindTopicForLink( Link: THelpLink ): TTopic;
var
  HelpFile: THelpFile;
begin
  HelpFile := Link.HelpFile as THelpFile;
  if Link is TFootnoteHelpLink then
  begin
    Result := HelpFile.Topics[ TFootnoteHelpLink( Link ).TopicIndex ];
  end
  else if Link is TInternalHelpLink then
  begin
    Result := HelpFile.Topics[ TInternalHelpLink( Link ).TopicIndex ];
  end
  else if Link is THelpLinkByResourceID then
  begin
    Result := FindTopicByResourceID( THelpLinkByResourceID( Link ).ResourceID );
  end
end;

Procedure TMainForm.TopicPropertiesPMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
  Topic: TTopic;
  HelpFile: THelpFile;
  ResourceIDs: TList;
  i: longint;
Begin
  Window := GetActiveWindow;
  if Window = nil then
    exit;
  Topic := Window.Topic;
  HelpFile := Topic.HelpFile as THelpFile;

  ResourceIDs := TList.Create;
  HelpFile.FindResourceIDsForTopic( Topic,
                                    ResourceIDs );

  with InformationForm.InformationMemo do
  begin
    Lines.Clear;
    Lines.Add( TopicInfoTitle );
    Lines.Add( TopicInfoTopicTitle + Topic.Title );
    Lines.Add( TopicInfoIndex + IntToStr( Topic.Index ) );
    Lines.Add( TopicInfoFile + HelpFile.Filename );
    Lines.Add( TopicInfoResourceIDs );
    for i := 0 to ResourceIDs.Count - 1 do
      Lines.Add( '  ' + IntToStr( longint( ResourceIDs[ i ] ) ) );
    if ResourceIDs.Count = 0 then
      Lines.Add( TopicInfoNoResourceIDs );
  end;
  ResourceIDs.Destroy;

  InformationForm.ShowModal;
End;
Procedure TMainForm.NavigateForwardMIOnClick (Sender: TObject);
Begin
  NavigateForward;
End;

Procedure TMainForm.FocusFirstHelpWindow;
begin
  if Windows.Count > 0 then
    THelpWindow( Windows[ 0 ] ).View.Focus;
end;

Procedure TMainForm.IndexListBoxOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  case KeyCode of
    kbTab:
    begin
      FocusFirstHelpWindow;
      KeyCode := kbNull;
    end;
    kb_VK + VK_NEWLINE:
      DisplaySelectedIndexTopic;
  end;
End;

Procedure TMainForm.SearchResultsListBoxOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  case KeyCode of
    kbTab:
    begin
      FocusFirstHelpWindow;
      KeyCode := kbNull;
    end;

    kb_VK + VK_NEWLINE:
      DisplaySelectedSearchResultTopic;
  end;
End;

Procedure TMainForm.ContentsOutlineOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  case KeyCode of
    kbTab:
    begin
      FocusFirstHelpWindow;
      KeyCode := kbNull;
    end;
    kb_VK + VK_NEWLINE:
      DisplaySelectedContentsTopic;
  end;
End;

Procedure TMainForm.ToolsOptionsMIOnClick (Sender: TObject);
Begin
  DoOptions;
End;

Procedure TMainForm.EditGlobalSearchMIOnClick (Sender: TObject);
Begin
  DoGlobalSearch( '' );
End;

Procedure TMainForm.ViewExpandAllMIOnClick (Sender: TObject);
Begin
  DisplayContents;
  ContentsOutline.ExpandAll;
End;

Procedure TMainForm.DebugShowParamsMIOnClick (Sender: TObject);
Begin
  with InformationForm.InformationMemo do
  begin
    Lines.Clear;
    Lines.Add('');

    CmdLineParameters.writeDetailsTo(Lines);
    writeSettingsDetailsTo(Lines);
    writeDebugSetupDetailsTo(Lines);
  end;

  InformationForm.ShowModal;
End;

Procedure TMainForm.EditBookmarksMIOnClick (Sender: TObject);
Begin
  BookmarksForm.BookmarkList := Bookmarks;
  BookmarksForm.OpenBookmarkCallback := NavigateToBookmark;
  BookmarksForm.BookmarksChangedCallback := OnBookmarksChanged;
  BookmarksForm.Show;

  // Since we are showing a nonmodal dialog, set the PM owner window
  // so that the bookmarks form remains on top.
  WinSetOwner( BookmarksForm.Frame.Handle,
               Frame.Handle );
End;

Procedure TMainForm.CopyPMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
Begin
  Window := GetActiveWindow;
  if Window = nil then
    exit;
  Window.View.CopySelectionToClipboard;
End;

Procedure TMainForm.SelectAllPMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
Begin
  Window := GetActiveWindow;
  if Window = nil then
    exit;
  Window.View.SelectAll;
End;

Procedure TMainForm.AddNoteButtonOnClick (Sender: TObject);
Begin
  AddNote;
End;

Procedure TMainForm.EnableSearchButton;
var
  CanSearch: boolean;
begin
  CanSearch := false;
  if CurrentOpenFiles.Count > 0 then
    if trim( SearchTextEdit.Text ) > '' then
      CanSearch := true;
  SearchButton.Enabled := CanSearch;
end;

Procedure TMainForm.SearchTextEditOnChange (Sender: TObject);
Begin
  EnableSearchButton;
End;

Procedure TMainForm.OnHint( Sender: TObject );
begin
  SetStatus( Application.Hint );
end;

Procedure TMainForm.DisplaySelectedIndexTopic;
var
  Topic: TTopic;
Begin
  if IndexListBox.ItemIndex = -1 then
    exit;
  Topic := DisplayedIndex.Objects[ IndexListBox.ItemIndex ] as TTopic;
  DisplayTopic( Topic );
End;

Procedure TMainForm.IndexListBoxOnClick (Sender: TObject);
Begin
  DisplaySelectedIndexTopic;
End;

Procedure TMainForm.ViewCollapseAllMIOnClick (Sender: TObject);
Begin
  DisplayContents;
  ContentsOutline.CollapseAll;
  DisplaySelectedContentsTopic;
End;

Procedure TMainForm.NotesListBoxOnDblClick (Sender: TObject);
Begin
  GotoCurrentNote;
End;

function TMainForm.OwnHelpMode: boolean;
var
  Filename: string;
  NamePart: string;
begin
  result := false;
  if CurrentOpenFiles.Count <> 1 then
    exit;

  Filename := THelpFile( CurrentOpenFiles[ 0 ] ).Filename;
  NamePart := ExtractFileName( Filename );
  Result := StrStartsWithIgnoringCase(NamePart, 'newview');
end;

Procedure TMainForm.HelpMIOnClick (Sender: TObject);
Begin
  if OwnHelpMode then
  begin
    DoErrorDlg( NewViewHelpTitle,
                AlreadyNewviewHelp );
    exit;
  end;
  Application.HelpContents;
End;

Procedure TMainForm.NotebookOnPageChanged (Sender: TObject);
var
  FileIndex: longint;
  HelpFile: THelpFile;
Begin
  EnableControls;
  case Notebook.PageIndex of
    piContents:
    begin
      // not really feasible to load contents here, as we rely
      // on it for many things
      ContentsOutline.Focus;
    end;

    piIndex:
    begin
      if not IndexLoaded then
      begin
        LoadIndex;
      end;
      IndexSearchEdit.Focus;
    end;

    piSearch:
    begin
      SearchButton.Focus;
      SearchTextEdit.Focus;
    end;

    piNotes:
    begin
      for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
      begin
        HelpFile := CurrentOpenFiles[ FileIndex ];
        if not HelpFile.NotesLoaded then
          LoadNotes( HelpFile );
      end;
      NotesListBox.Focus;
      UpdateNotesDisplay;
    end;
  end;

End;

Procedure TMainForm.ViewRefreshMIOnClick (Sender: TObject);
Begin
  RefreshWindows( Windows );
End;

Procedure TMainForm.ViewNotesMIOnClick (Sender: TObject);
Begin
  ShowLeftPanel := true;
  TabSet.TabIndex := piNotes;
End;

Procedure TMainForm.ViewSearchMIOnClick (Sender: TObject);
Begin
  DisplaySearch;
End;

Procedure TMainForm.ShowTab( TabIndex: longint );
Begin
  ShowLeftPanel := true;
  TabSet.TabIndex := TabIndex;
  NotebookOnPageChanged( self );// focus control etc
End;

Procedure TMainForm.DisplaySearch;
Begin
  ShowTab( piSearch );
End;

Procedure TMainForm.ViewIndexMIOnClick (Sender: TObject);
Begin
  DisplayIndex;
End;

Procedure TMainForm.DisplayIndex;
Begin
  ShowTab( piIndex );
End;

Procedure TMainForm.ViewContentsMIOnClick (Sender: TObject);
Begin
  DisplayContents;
End;

Procedure TMainForm.DisplayContents;
Begin
  ShowTab( piContents );
End;

function TMainForm.OpenWindow( Topic: TTopic;
                               Group: longint;
                               Parent: THelpWindow;
                               Rect: THelpWindowRect;
                               FollowAutoLinks: boolean ): THelpWindow;
var
  Window: THelpWindow;
  DisplayTopicRequired: boolean;
begin
  Window := nil;

  if ( Group <> DefaultGroupIndex ) and ( Parent = nil ) then
  begin
    // Normal window (not a split window) and a specific group is desired.
    // So see if we can find one with that group number
    Window := FindWindowFromGroup( Group, Windows );

  end
  else
  begin
    // only reuse window if it has the same topic.
    Window := FindWindowFromTopic( Topic, Windows );
  end;

  if Window = nil then
  begin
    DisplayingTopicWindow := true;

    // not found, or want a new one
    Window := THelpWindow.Create( Parent = nil );

    // add to parent
    if Parent = nil then
    begin
      Window.Parent := DisplayPanel;
      Windows.Add( Window );
    end
    else
    begin
      Window.Parent := Parent.View;
      Parent.ChildWindows.Add( Window );
    end;

    Window.ParentHelpWindow := Parent;

    DisplayingTopicWindow := false;

  end
  else
  begin
    // reusing an existing window. Don't change parent
  end;

  Window.Group := Group;

  Window.View.PopupMenu := ViewPopupMenu;

  Window.View.Images := Window.Images;

  Window.View.OnClickLink := OnClickLink;
  Window.View.OnOverLink := OnOverLink;
  Window.View.OnNotOverLink := OnNotOverLink;

  Window.OnClose := OnWindowClose;
  Window.OnCloseQuery := OnWindowAboutToClose;
  Window.OnDragOver := OnDragOverWindow;
  Window.OnDragDrop := OnDragDropToWindow;
  Window.OnFontChange := OnWindowFontChange;
  Window.OnTab := OnWindowTab;
  Window.OnBackTab := OnWindowBackTab;

  // Use the contents rect by default...
  Topic.GetContentsWindowRect( Window.Rect );
  if Rect <> nil then
  begin
    // the rect is being overridden, so use it instead
    if Rect.Left <> -1 then
      Window.Rect.Left := Rect.Left;
    if Rect.Bottom <> -1 then
      Window.Rect.Bottom := Rect.Bottom;
    if Rect.Width <> -1 then
      Window.Rect.Width := Rect.Width;
    if Rect.Height <> -1 then
      Window.Rect.Height := Rect.Height;
  end;

  if Window.ChildWindows.Count > 0 then
  begin
    // close existing child windows
    DestroyListObjects( Window.ChildWindows );
    Window.ChildWindows.Clear;
    Window.View.Show; // show the view again
  end;

  DisplayTopicRequired := Window.Topic <> Topic;
  Window.Topic := Topic; // set this now so that SetLayout can log meaninful stuff

  // Adjust the window size to it's specified Rect
  // Must do this before displaying child windows (DisplayTopicInWindow,
  // split window autolinks),
  // otherwise they will not size themselves correctly
  Window.SetLayout;

  if DisplayTopicRequired then
  begin
    DisplayTopicInWindow( Window, FollowAutoLinks, false );
  end;

  // Bring this window to the front
  Window.BringToFront;

  Result := Window;
end;

// Find an existing help window containing the given richtext view control
Function TMainForm.FindWindowFromView( View: TRichTextView;
                                       WindowList: TList ): THelpWindow;
var
  WindowIndex: longint;
begin
  for WindowIndex:= 0 to WindowList.Count - 1 do
  begin
    Result:= WindowList[ WindowIndex ];
    if Result.View = View then
      exit;
    Result:= FindWindowFromView( View, Result.ChildWindows );
    if Result <> nil then
      exit;
  end;
  Result:= nil;
end;

// Find an existing help window with the given group number (if any)
Function TMainForm.FindWindowFromGroup( Group: longint; WindowList: TList ): THelpWindow;
var
  WindowIndex: longint;
begin
  for WindowIndex:= 0 to WindowList.Count - 1 do
  begin
    Result:= WindowList[ WindowIndex ];
    if Result.Group = Group then
      exit;
    Result:= FindWindowFromGroup( Group, Result.ChildWindows );
    if Result <> nil then
      exit;
  end;
  Result:= nil;
end;

// Find an existing help window alreadying displaying the given topic
Function TMainForm.FindWindowFromTopic( Topic: TTopic; WindowList: TList ): THelpWindow;
var
  WindowIndex: longint;
begin
  for WindowIndex:= 0 to WindowList.Count - 1 do
  begin
    Result:= WindowList[ WindowIndex ];
    if Result.Topic = Topic then
      exit;
    Result:= FindWindowFromTopic( Topic, Result.ChildWindows );
    if Result <> nil then
      exit;
  end;
  Result:= nil;
end;

Procedure TMainForm.RefreshFontSubstitutions;
var
  FileIndex: longint;
  HelpFile: THelpFile;
begin
  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];

    if Settings.FixedFontSubstitution then
      HelpFile.SetupFontSubstitutes( Settings.FixedFontSubstitutes )
    else
      HelpFile.SetupFontSubstitutes( '' );
  end;
end;

// Redisplay topics in all windows
Procedure TMainForm.RefreshWindows( WindowList: TList );
var
  WindowIndex: longint;
  Window: THelpWindow;
begin
  for WindowIndex:= 0 to WindowList.Count - 1 do
  begin
    Window:= WindowList[ WindowIndex ];
    DisplayTopicInWindow( Window,
                          false, // don't follow links!
                          true ); // keep position
    RefreshWindows( Window.ChildWindows );
  end;
end;

Procedure TMainForm.WMFollowExternalLink( Var Msg: TMessage );
var
  FilePath: string;
  Topic: TTopic;
begin
  // try in same dir as source file
  FilePath := AddDirectorySeparator( ExtractFilePath( g_ExternalLinkSourceFilename ) )
              + g_ExternalLinkFilename;

  if not StrEqualIgnoringCase( FilePath, g_ExternalLinkSourceFilename ) then
  begin
    // different file - try and open it
    if not FileExists( FilePath ) then
      // not in same directory, find in help paths
      FilePath := FindHelpFile( g_ExternalLinkFilename );

    if not FileExists( FilePath ) then
    begin
      DoErrorDlg( 'Link Error',
                  'Cannot find linked file '
                  + g_ExternalLinkFilename );
      exit;
    end;

    if g_ExternalLinkKeepCurrent then
    begin
      if not OpenAdditionalFile( FilePath, false ) then
        exit;
    end
    else
    begin
      if not OpenFile( FilePath, '', false ) then
        exit;
    end;

  end;

  if g_ExternalLinkTopic = '' then
  begin
    // specific topic not required.
    DisplaySelectedContentsTopic;
    exit;
  end;

  Topic := FindTopicByGlobalName( g_ExternalLinkTopic );
  if Topic = nil then
  begin
    DoErrorDlg( 'Link Error',
                'Unable to find topic with global name '
                + g_ExternalLinkTopic );
    exit;
  end;

  DisplayTopic( Topic );
end;

// We are following a link, specified as param1 in msg
Procedure TMainForm.WMFollowLink( Var Msg: TMessage );
var
  NewTopic: TTopic;
  Link: THelpLink;
  SourceWindow: THelpWindow;
begin
  Link:= THelpLink( Msg.Param1 );
  SourceWindow:= THelpWindow( Msg.Param2 );
  NewTopic:= FindTopicForLink( Link );

  // remove the link target info from status
  SetStatus( '' );

  if NewTopic = nil then
  begin
    // Linked topic not found, this is an error... which kind?

    if Link is THelpLinkByResourceID then
    begin
      // may happen if e.g. PM4.INF is loaded by itself,
      // and a link references a resource ID from e.g PM2.INF
      DoErrorDlg( InvalidLinkErrorTitle,
                  InvalidResourceIDLinkErrorA
                  + IntToStr( THelpLinkByResourceID( Link ).ResourceID )
                  + InvalidResourceIDLinkErrorB );
    end
    else
    begin
      // should never happen, given valid help files
      DoErrorDlg( InvalidLinkErrorTitle,
                  InvalidLinkError );
    end;

    exit;
  end;

  UpdateCurrentNavigatePoint;

  FollowLink( Link, SourceWindow );

  if NewTopic.ShowInContents then
  begin
    Navigating:= true;
    if ContentsOutline.SelectedNode = nil then
      ContentsOutline.SetSelectedObject( NewTopic )
    else if ContentsOutline.SelectedNode.Data <> NewTopic then
      ContentsOutline.SetSelectedObject( NewTopic );
    Navigating:= false;
  end;
  SaveNavigatePoint;
  EnableControls;
  ShowWindows;

end;

// Follow the given link from the given window.
// ie. open the topic or footnote it points to
Procedure TMainForm.FollowLink( Link: THelpLink;
                                SourceWindow: THelpWindow );
var
  LinkedTopic: TTopic;
  ParentWindow: THelpWindow;
  WindowedLink: TWindowedHelpLink;
  NewWindow: THelpWIndow;
begin
  LinkedTopic := FindTopicForLink( Link );

  if LinkedTopic = nil then
  begin
    exit;
  end;

  if Link is TFootnoteHelpLink then
  begin
    NewWindow := OpenWindow( LinkedTopic,
                DefaultGroupIndex,
                nil, // no parent
                FootnoteRect,
                true );
    NewWindow.Caption := TFootnoteHelpLink( Link ).Title;
    exit;
  end;

  WindowedLink := Link as TWindowedHelpLink;

  ParentWindow:= nil;
  if WindowedLink.Split then
    ParentWindow:= SourceWindow;

  if WindowedLink.ViewPort then
    // link always wants a new window
    OpenWindow( LinkedTopic,
                DefaultGroupIndex,
                ParentWindow,
                WindowedLink.Rect,
                true )

  else if WindowedLink.GroupIndex <> DefaultGroupIndex then
    // link overrides group index
    OpenWindow( LinkedTopic,
                WindowedLink.GroupIndex,
                ParentWindow,
                WindowedLink.Rect,
                true )
  else
    // no special case
    OpenWindow( LinkedTopic,
                LinkedTopic.ContentsGroupIndex,
                ParentWindow,
                WindowedLink.Rect,
                true );
end;

function TMainForm.ShowCodes: boolean;
begin
  if DebugShowCodesMI = nil then
    result := false
  else
    result := DebugShowCodesMI.Checked;
end;

function TMainForm.ShowWordIndices: boolean;
begin
  if DebugShowWordSeparatorsMI = nil then
    result := false
  else
    result := DebugShowWordSeparatorsMI.Checked;
end;

// Decode and display the topic for the given window.
Procedure TMainForm.DisplayTopicInWindow( Window: THelpWindow;
                                          FollowAutoLinks: boolean;
                                          KeepPosition: boolean );
var
  ImageIndices: TList;
  LinkIndex: longint;
  Link: THelpLink;
  WindowedHelpLink: TWindowedHelpLink;
  InternalHelpLink: TInternalHelpLink;
  HelpFile: THelpFile;
  LinkedTopic: TTopic;
  SourceTopic: TTopic;
  TopCharIndex: longint;
  i: longint;
  HighlightWordSequences: TList;
  FileIndex: longint;
Begin
  LogEvent(LogDisplay, 'DisplayTopicInWindow');

  SetWaitCursor;

  TopCharIndex := Window.View.TopCharIndex;

  Window.View.Hide;
  Window.View.Clear;
  ImageIndices := TList.Create;

  HelpFile := TopicFile( Window.Topic );

  if     ( AllFilesWordSequences.Count > 0 ) // ie we have done a search...
     and ViewHighlightSearchWordsMI.Checked then
  begin
    FileIndex := CurrentOpenFiles.IndexOf( HelpFile );
    HighlightWordSequences := AllFilesWordSequences[ FileIndex ];
  end
  else
  begin
    HighlightWordSequences :=  nil;
  end;
  TopicText.Clear;
  Window.Topic.GetText( HighlightWordSequences,
                        ShowCodes,
                        ShowWordIndices,
                        TopicText,
                        ImageIndices,
                        Window.Highlights );

  HelpFile.GetImages( ImageIndices, Window.Images );

  if not HelpFile.NotesLoaded then
    LoadNotes( HelpFile );
  InsertNotesIntoTopicText( Window.Topic, TopicText );

  Window.View.AddText( TopicText.AsPChar );

  if KeepPosition then
    Window.View.TopCharIndex := TopCharIndex;

  Window.View.Show;

  if not KeepPosition then
    if Window.Highlights.Count > 0 then
      // ensure first search match is visible
      Window.View.MakeCharVisible( longint( Window.Highlights[ 0 ] ) );

  Window.Caption := Window.Topic.Title;
  Window.BringToFront;
  Window.View.Focus;

  // Take a copy of the topic, because the window in question could be changing
  // due to recursion!
  SourceTopic := Window.Topic;

  if FollowAutoLinks then
  begin
    i := 0;
    for LinkIndex:= 0 to SourceTopic.Links.Count - 1 do
    begin
      Link:= SourceTopic.Links[ LinkIndex ];
      if Link is TWindowedHelpLink then
      begin
        WindowedHelpLink := Link as TWindowedHelpLink;
        if WindowedHelpLink.Automatic then
        begin
          if Link is TInternalHelpLink then
          begin
            InternalHelpLink := TInternalHelpLink( Link );
            LinkedTopic :=
              THelpFile( InternalHelpLink.HelpFile ).
                Topics[ InternalHelpLink.TopicIndex ];
            if LinkedTopic.Index = SourceTopic.Index then
              // what the - ? The link wants to open the same topic again
              continue;
          end;

          FollowLink( Link, Window );
          Window := Window;

          inc( i );
          // Note 1: it is possible to crash here if
          // e.g. window1 auto-opens window2 which auto-opens window1 with a different topic..
          // I can't think of a nice, easy way to detect this
          //
          // Note 2: If there is no group number specified
          // (ie. group = default = 0 ) then behaves as if viewport is set:
          // always opens another window.
        end;
      end;
    end;
  end;

  ClearWaitCursor;

  ImageIndices.Destroy;
End;

Procedure TMainForm.MainFormOnCloseQuery (Sender: TObject;
  Var CanClose: Boolean);
Begin
  LogEvent(LogShutdown, '-------- Shutdown ----------');


  if OKToCloseFile then
     CloseFile
  else
     CanClose := false;
End;

procedure TMainForm.DisplayTopic( Topic: TTopic );
begin
  if Navigating then
    exit;

  UpdateCurrentNavigatePoint;

  CloseWindows;

  CurrentTopic:= Topic;

  OpenWindow( CurrentTopic,
              CurrentTopic.ContentsGroupIndex,
              nil,
              nil,
              true );
  SetStatus( OpenedTopicMsg + IntToStr( Topic.Index ) );

  Navigating:= true;

  if ContentsOutline.SelectedNode = nil then
    ContentsOutline.SetSelectedObject( Topic )
  else if ContentsOutline.SelectedNode.Data <> Topic then
    ContentsOutline.SetSelectedObject( Topic );

  SaveNavigatePoint;

  Navigating:= false;
  // find in index...
  // find in search results...

  EnableControls;

  ShowWindows;

//  if Windows.Count > 0 then
//    THelpWindow( Windows[ 0 ] ).View.Focus;

end;

// Make the all current help windows visible
Procedure TMainForm.ShowWindows;
begin
  ShowWindowList( Windows );
end;

// Make the specified windows visible
Procedure TMainForm.ShowWindowList( WindowList: TList );
var
  i: integer;
  Window: THelpWindow;
begin
  for i := 0 to WindowList.Count - 1 do
  begin
    Window:= WindowList[ i ];
    Window.Show;
    ShowWindowList( Window.ChildWindows );
  end;
end;

// Global search -----------------------------------------------------------

Procedure TMainForm.GlobalSearchMIOnClick (Sender: TObject);
begin
  DoGlobalSearch( '' );
end;

Procedure TMainForm.DoGlobalSearch( const SearchText: string );
Begin
  EnsureGlobalSearchFormLoaded;

  GlobalSearchForm.ViewTopicCallback:= OnViewGlobalSearchTopic;
  GlobalSearchForm.Show;
  WinSetOwner( GlobalSearchForm.Frame.Handle, Frame.Handle );

  if SearchText <> '' then
  begin
    GlobalSearchForm.SearchTextEdit.Text := SearchText;
    GlobalSearchForm.DoSearch;
  end;
End;

Procedure TMainForm.OnViewGlobalSearchTopic( FileName: string;
                                             TopicIndex: longint );
var
  HelpFile: THelpFile;
begin
  HelpFile:= FindOpenHelpFile( FileName );

  if HelpFile = nil then
  begin
    if OpenFile( Filename, '', false ) then
    begin
      HelpFile := CurrentOpenFiles[ 0 ];
      ClearHelpManager;
    end;
  end;

  if HelpFile <> nil then
    if TopicIndex <> -1 then
      DisplayTopic( HelpFile.Topics[ TopicIndex ] );

end;

// Notes -----------------------------------------------------------

Procedure TMainForm.GotoNoteButtonOnClick (Sender: TObject);
begin
  GotoCurrentNote;
end;

Procedure TMainForm.EditNoteButtonOnClick (Sender: TObject);
Begin
  if NotesListBox.ItemIndex = -1 then
    exit;
  EditNote( NotesListBox.ItemIndex );
End;

Procedure TMainForm.NotesListBoxOnItemFocus (Sender: TObject; Index: LongInt);
var
  Note: THelpNote;
Begin
  Note:= NotesListBox.Items.Objects[ NotesListBox.ItemIndex ] as THelpNote;
  EnableNotesControls;
End;

Procedure TMainForm.DeleteNoteButtonOnClick (Sender: TObject);
Begin
  if NotesListBox.ItemIndex = -1 then
    exit;
  DeleteNote( NotesListBox.ItemIndex );
End;

Procedure TMainForm.AddBookmarkMIOnClick (Sender: TObject);
Begin
  AddBookmark;
End;

Procedure TMainForm.AddNoteMIOnClick (Sender: TObject);
Begin
  AddNote;
End;

// -----------------------------------------------------------

Procedure TMainForm.FileCloseMIOnClick (Sender: TObject);
Begin
  if not OKToCloseFile then
    exit;

  CloseFile;
End;

Procedure TMainForm.SetStatus( Text: String );
begin
  StatusPanel.Caption:= Text;
  StatusPanel.Refresh;
end;

Procedure TMainForm.ResetProgress;
begin
  ProgressBar.Position:= 0;
  ProgressBar.Hide;
end;

Procedure TMainForm.CoolBarOnSectionResize (HeaderControl: THeaderControl;
  section: THeaderSection);
Begin

End;

Procedure TMainForm.CoolBarOnSectionClick (HeaderControl: THeaderControl;
  section: THeaderSection);
Begin
  case Section.Index of
    ciOpen:
      FileOpen;
    ciPrint:
      PrintTopics;
    ciNavigator:
      ShowLeftPanel := not ShowLeftPanel;
    ciBack:
      NavigateBack;
    ciForward:
      NavigateForward;
    ciAddNote:
      AddNote;
    ciAddBookmark:
      AddBookmark;
    ciPrevious:
      NavigatePreviousInContents;
    ciNext:
      NavigateNextInContents;
    ciGlobalSearch:
      DoGlobalSearch( '' );
  end;

End;

// ---------------- Notes ----------------------

function TMainForm.FindOriginalNoteCharIndex( NoteCharIndex: longword;
                                              Topic: TTopic ): longword;
var
  NoteIndex: longint;
  Note: THelpNote;
begin
  Result := NoteCharIndex;
  for NoteIndex := 0 to Notes.Count - 1 do
  begin
    Note := Notes[ NoteIndex ];
    if Note.Topic = Topic then
      if Note.InsertPoint < NoteCharIndex then
        dec( Result, Note.InsertText.Length );
  end;
end;

function TMainForm.FindActualNoteCharIndex( NoteCharIndex: longword;
                                            MaxNoteIndex: longword;
                                            Topic: TTopic ): longword;
var
  NoteIndex: longint;
  Note: THelpNote;
begin
  NoteIndex:= 0;
  Result:= NoteCharIndex;
  for NoteIndex:= 0 to MaxNoteIndex - 1 do
  begin
    Note:= Notes[ NoteIndex ];
    if Note.Topic = Topic then
      if Note.InsertPoint < NoteCharIndex then
        inc( Result, Note.InsertText.Length );
  end;
end;

procedure TMainForm.RefreshNoteInsertInfo( NoteIndex: longword );
var
  Note: THelpNote;
begin
  Note:= Notes[ NoteIndex ];

  if Note.Topic = nil then
    exit;
  with Note do
  begin
    InsertText.AssignString( '<color #'
                             + IntToHex( Settings.Colors[ NotesTextColorIndex ], 6 )
                             + '><link note'
                             + IntToStr( NoteIndex )
                             + '>' );
    InsertText.Add( Text );
    InsertText.AddString( '</color></link>' );
  end;
end;

procedure TMainForm.ClearNotes;
begin
  DestroyListObjects( Notes );
  Notes.Clear;
end;

procedure TMainForm.AddNote;
var
  Note: THelpNote;
  Window: THelpWindow;
begin
  Window := GetActiveWindow;
  if Window = nil then
  begin
    DoErrorDlg( AddNoteTitle,
                AddNoteCursorError );
    exit;
  end;

  if Window.View.CursorIndex = -1 then
  begin
    DoErrorDlg( AddNoteTitle,
                AddNoteCursorError );
    exit;
  end;

  // check that the note position isn't
  // within a note already
  if Window.View.LinkFromIndex( Window.View.CursorIndex ) <> '' then
  begin
    DoErrorDlg( AddNoteTitle,
                NoteWithinNoteError );
    exit;
  end;

  // ask for note text
  NoteForm.DeleteNoteButton.Enabled := false; // can't delete it while creating!
  NoteForm.Text.Clear;
  if NoteForm.ShowModal <> mrOK then
    exit;

  // store note data
  Note := THelpNote.Create;
  Note.Text.Assign( NoteForm.Text );

  // compensate for existing notes
  if Window.View.CursorIndex <> -1 then
    Note.InsertPoint := FindOriginalNoteCharIndex( Window.View.CursorIndex, Window.Topic )
  else
    Note.InsertPoint := 0;

  Note.Topic := Window.Topic;

  Notes.Add( Note );

  // redisplay topic
  DisplayTopicInWindow( Window,
                        false, // don't follow links!
                        true ); // keep position
  Window.View.SelectionStart := FindActualNoteCharIndex( Note.InsertPoint,
                                                         Notes.Count - 1,
                                                         Window.Topic );
  UpdateNotesDisplay;

  SaveNotes;

end;

procedure TMainForm.DeleteNote( NoteIndex: longint );
var
  Note: THelpNote;
begin
  Note := Notes[ NoteIndex ];
  Notes.Delete( NoteIndex );

  RefreshWindows( Windows );

  Note.Destroy;

  UpdateNotesDisplay;

  SaveNotes;
end;

Procedure TMainForm.EditNote( NoteIndex: longint );
var
  Note: THelpNote;
begin
  Note:= Notes[ NoteIndex ];

  NoteForm.Text.Assign( Note.Text );

  NoteForm.DeleteNoteButton.Enabled:= true;

  if NoteForm.ShowModal = mrCancel then
    exit;

  if NoteForm.ModalResult = cmDiscard then
  begin
    DeleteNote( NoteIndex );
    exit;
  end;

  Note.Text.Assign( NoteForm.Text );

  RefreshWindows( Windows );

  UpdateNotesDisplay;

  SaveNotes;
end;

Procedure TMainForm.GotoCurrentNote;
var
  Note: THelpNote;
Begin
  if NotesListBox.ItemIndex = -1 then
    exit;
  Note:= NotesListBox.Items.Objects[ NotesListBox.ItemIndex ] as THelpNote;
  DisplayTopic( Note.Topic );
End;

// ---------------- Bookmarks ----------------------

procedure TMainForm.OnBookmarksChanged( Sender: TObject );
begin
  BuildBookmarksMenu;
  UpdateBookmarksForm;
  SaveBookmarks;
end;

procedure TMainForm.AddBookmark;
var
  Bookmark: TBookmark;
begin
  if Windows.Count = 0 then
    exit;

  Bookmark := TBookmark.Create;
  SaveWindows( Windows, Bookmark.Windows, nil );

  if ContentsOutline.SelectedNode <> nil then
  begin
    Bookmark.ContentsTopic:=
      ContentsOutline.SelectedNode.Data as TTopic;
    Bookmark.Name := Bookmark.ContentsTopic.Title;
  end
  else
  begin
    Bookmark.ContentsTopic:= nil;
    // Bookmark.Name := THelpWindow( Windows[ 0 ] ).Title;
  end;

  Bookmarks.Add( Bookmark );
  OnBookmarksChanged( self );
end;

Procedure TMainForm.BookmarksMenuItemClick( Sender: TObject );
var
  Tag: longint;
  MenuItem: TMenuItem;
  Bookmark: TBookmark;
begin
  MenuItem:= Sender as TMenuItem;
  Tag:= MenuItem.Tag;
  Bookmark := Bookmarks[ Tag ];

  NavigateToBookmark( Bookmark );
end;

Procedure TMainForm.NavigateToBookmark( Bookmark: TBookmark );
Begin
  UpdateCurrentNavigatePoint;
  NavigateToPoint( Bookmark );
  SaveNavigatePoint;
End;

Procedure TMainForm.BuildBookmarksMenu;
var
  i: integer;
  Bookmark: TBookmark;
  MenuItem: TMenuItem;
begin
  DestroyListObjects( BookmarksMenuItems );
  BookmarksMenuItems.Clear;

  if Bookmarks.Count > 0 then
  begin
    MenuItem:= TMenuItem.Create( self );
    MenuItem.Caption:= '-';
    BookmarksMenu.Add( MenuItem );
    BookmarksMenuItems.Add( MenuItem );
  end;

  for i:= 0 to Bookmarks.Count -1 do
  begin
    Bookmark := Bookmarks[ i ];
    MenuItem:= TMenuItem.Create( self );

    MenuItem.Caption:= Bookmark.Name;
    MenuItem.OnClick:= BookmarksMenuItemClick;
    MenuItem.Tag:= i;
    BookmarksMenu.Add( MenuItem );
    BookmarksMenuItems.Add( MenuItem );
  end;
end;

Procedure TMainForm.UpdateBookmarksForm;
begin
  if Assigned( BookmarksForm ) then
    BookmarksForm.RefreshList;
end;

Procedure TMainForm.ClearBookmarks;
begin
  ClearListAndObjects( Bookmarks );
  BuildBookmarksMenu;
  if Assigned( BookmarksForm ) then
  begin
    UpdateBookmarksForm; // clear bookmarks for next show
    BookmarksForm.Hide;
  end;

end;

procedure TMainForm.LoadBookmarks( HelpFile: THelpFile );
var
  Bookmark: TBookmark;
  BookmarksFile: TextFile;
  BookmarksFileName: string;
  S: string;
begin
  LogEvent(LogSettings, 'Load bookmarks for ' + HelpFile.Filename);

  BookmarksFileName:= ChangeFileExt( HelpFile.FileName, '.bmk' );

  if not FileExists( BookmarksFileName ) then
    exit;

  FileMode := fmInput;
  AssignFile( BookmarksFile, BookmarksFileName );
  try
    Reset( BookmarksFile );
    try
      while not Eof( BookmarksFile ) do
      begin
        ReadLn( BookmarksFile, s );
        if trim( Uppercase( s ) ) = '[BOOKMARK]' then
        begin
          Bookmark:= TBookmark.Load( BookmarksFile, HelpFile );
          Bookmarks.Add( Bookmark );
        end;
      end;
    finally
      System.Close( BookmarksFile );
    end;
  except
    on e: exception do
      DoErrorDlg( LoadBookmarksTitle,
                  LoadBookmarksError
                  + e.message );
  end;
end;

procedure TMainForm.SaveBookmarks;
var
  FileIndex: integer;
  HelpFile: THelpFile;
begin
  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];
    SaveBookmarksForFile( HelpFile );
  end;
end;

procedure TMainForm.SaveNotes;
var
  FileIndex: integer;
  HelpFile: THelpFile;
begin
  LogEvent(LogSettings, 'Save notes');

  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];
    SaveNotesForFile( HelpFile );
  end;
end;

procedure TMainForm.SaveBookmarksForFile( HelpFile: THelpFile );
var
  i: integer;
  Bookmark: TBookmark;
  BookmarksFile: TextFile;
  BookmarksFileName: string;
  BookmarkCount: integer;
begin
  LogEvent(LogSettings, 'Save bookmarks for ' + HelpFile.Filename);

  BookmarksFileName:= ChangeFileExt( HelpFile.FileName, '.bmk' );

  BookmarkCount:= 0;
  for i:= 0 to Bookmarks.Count - 1 do
  begin
    Bookmark := Bookmarks[ i ];

    if Bookmark.ContentsTopic.HelpFile = HelpFile then
      inc( BookmarkCount );
  end;

  if BookmarkCount = 0 then
  begin
    if FileExists( BookmarksFileName ) then
      DeleteFile( BookmarksFileName );
    exit;
  end;

  AssignFile( BookmarksFile, BookmarksFileName );
  try
    Rewrite( BookmarksFile );
    try
      for i := 0 to Bookmarks.Count - 1 do
      begin
        Bookmark:= Bookmarks[ i ];
        if Bookmark.ContentsTopic.HelpFile = HelpFile then
        begin
          WriteLn( BookmarksFile, '[Bookmark]' );
          Bookmark.Save( BookmarksFile );
        end;
      end;
    finally
      System.Close( BookmarksFile );
    end;
  except
    on e: exception do
      DoErrorDlg( SaveBookmarksTitle,
                  SaveBookmarksError
                  + e.message );
  end;
end;

// Reads colors back from controls, in case they have changed by
// drag and drop
Procedure TMainForm.GetColors;
begin
  with Settings do
  begin
    Colors[ ContentsBackgroundColorIndex ] := ContentsOutline.Color;
    Colors[ ContentsTextColorIndex ] := ContentsOutline.PenColor;
    Colors[ IndexBackgroundColorIndex ] := IndexListBox.Color;
    Colors[ IndexTextColorIndex ] := IndexListBox.PenColor;
    Colors[ SearchBackgroundColorIndex ] := SearchResultsListBox.Color;
    Colors[ SearchTextColorIndex ] := SearchResultsListBox.PenColor;
    Colors[ NotesListBackgroundColorIndex ] := NotesListBox.Color;
    Colors[ NotesListTextColorIndex ] := NotesListBox.PenColor;
  end;
end;

Procedure TMainForm.MainFormOnDestroy (Sender: TObject);
Begin
  LogEvent(LogShutdown, 'MainFormOnDestroy');

  LogEvent(LogSettings, 'Write window position');
  WriteWindowPos( self );

  LogEvent(LogSettings, 'Update colors');
  GetColors;

  LogEvent(LogSettings, 'Save settings');
  SaveSettings;
  LogEvent(LogSettings, 'Save settings done');

  // else- don't save position/size if doing own help

  TopicText.Destroy;

  LogEvent(LogShutdown, 'Destroy MRU menu items');
  MRUMenuItems.Destroy;

  LogEvent(LogShutdown, 'Destroy navigate to menu items');
  NavigateToMenuItems.Destroy;

  LogEvent(LogShutdown, 'Destroy pagehistory');
  PageHistory.Destroy;

  LogEvent(LogShutdown, 'Clear/destroy notes');
  ClearNotes;
  Notes.Destroy;

  LogEvent(LogShutdown, 'Clear/destroy bookmarks');
  ClearBookmarks;
  Bookmarks.Destroy;

  LogEvent(LogShutdown, 'Destroy bookmark menu items');
  BookmarksMenuItems.Destroy;

  LogEvent(LogShutdown, 'Destroy files/index/windows');
  CurrentOpenFiles.Destroy;
  DisplayedIndex.Destroy;
  Windows.Destroy;

  // tell help manager(s) we are stopping.
  PostHelpManagerMessage( NHM_FORGET_VIEWER, 0, 0 );

  HelpManagerWindows.Destroy;

  DestroyListObjects( Settings.MRUList );
  Settings.MRUList.Destroy;

  // TODO rbri maybe we have to do this
  // Parameters.FilenamesParam.Destroy;

  if g_CurrentLanguageFile <> nil then
    g_CurrentLanguageFile.Destroy;

  LogEvent(LogShutdown, 'Close global filelist');
  GlobalFilelist.Destroy;

  LogEvent(LogShutdown, 'Close shared memory');
  SharedMemory.Destroy;

  AllFilesWordSequences.Destroy;

  LogEvent(LogShutdown, 'MainFormOnDestroy done');
End;

Procedure TMainForm.MainFormOnSetupShow (Sender: TObject);
Begin
  LogEvent(LogSettings, 'OnSetupShow');
  TabSet.TabIndex := 0;
  Notebook.PageIndex := 0;
End;

Procedure TMainForm.OnException( Sender: TObject;
                                 E: Exception );
var
  TheText : string;
  F: TextFile;
  i: integer;
  HelpFile: THelpFile;
  LogFilename: string;

begin
  LogFilename := GetLogFilesDir + CrashLogFileName;

  LogException( E,
                LogFileName,
                'NewView',
                GetAppVersion,
                F );

  if CurrentOpenFiles <> nil then
  begin
    WriteLn( F, 'Loaded files ('
                + IntToStr( CurrentOpenFiles.Count )
                + '):' );
    try
      for i := 0 to CurrentOpenFiles.Count - 1 do
      begin
        HelpFile := CurrentOpenFiles[ i ];
        WriteLn( F, HelpFile.Filename );
      end;
    except
    end;
  end;
  try
    if CurrentTopic <> nil then
      WriteLn( F, 'Last major topic index: ' + IntToStr( CurrentTopic.Index ) );
  except
    // ignore exceptions if there isn't a valid current topic
  end;
  if Windows <> nil then
  begin
    WriteLn( F, 'Top-level open windows: '
                + IntToStr( Windows.Count ) );
  end;

  System.Close( F );

  TheText := ApplicationErrorA + StrCRLF
             + StrCRLF
             + E.Message + StrCRLF
             + ApplicationErrorB
             + LogFilename
             + ')' + StrCRLF
             + StrCRLF
             + ApplicationErrorC
             + StrCRLF;

  if DoYesNoDlg( ApplicationErrorTitle,
                 TheText ) then
  begin
    // exit a bit more nicely - remove ourselves from the global filelist.
    GlobalFilelist.RemoveWindowFiles( Frame.Handle );
    Application.Terminate;
  end;
end;

// give our main window a unique class name we can find
procedure TMainForm.GetClassData(var ClassData: TClassData);
Begin
  inherited GetClassData( ClassData );
  ClassData.ClassName := MAIN_WINDOW_CLASS_NAME;
End;

// Position the window offset from existing top help window (if any)
Procedure TMainForm.PositionWindow;
var
  hTopWindow: HWND;
  TopHelpWindowPos: SWP;
  Offset: longint;
Begin
  hTopWindow := FindTopFormWindow( MAIN_WINDOW_CLASS_NAME );

  if hTopWindow <> NULLHANDLE then
  begin
    // found an existing help window, find it's location
    if WinQueryWindowPos(
         hTopWindow,
         TopHelpWindowPos ) then
    begin
      if ( TopHelpWindowPos.FL and ( SWP_MINIMIZE or SWP_MINIMIZE ) ) > 0 then
      Begin
        // window is maximized or minimised, so get the restore position from window USHORTs
        TopHelpWindowPos.x := WinQueryWindowUShort( hTopWindow, QWS_XRESTORE );
        TopHelpWindowPos.Y := WinQueryWindowUShort( hTopWindow, QWS_YRESTORE );
      end;

      // offset new window by height of title bar + border
      Offset := Screen.SystemMetrics( smCyTitleBar )
                + Screen.SystemMetrics( smCySizeBorder );
      Left := TopHelpWindowPos.x + Offset;
      Bottom := TopHelpWindowPos.y - Offset;

      // I guess I am leaving width/height out for compatibility...?
    end;
  end;
end;

Procedure TMainForm.OnHelp( context: THelpContext;
                            var Result: Boolean );
begin
  if OwnHelpMode then
  begin
    // we are viewing the help file now - display our own help!
    PostMsg( Handle, NHM_TOPIC_BY_RESOURCE_ID, context, 0 );
    exit;
  end;

  Application.HelpContext( context );
end;

Procedure TMainForm.MainFormOnCreate (Sender: TObject);
var
  tmpCmdLine: AnsiString;
Begin
  LogEvent(LogStartup, 'MainFormOnCreate');

  StartingUp := true;

  SharedMemory := AccessSharedMemory;
  GlobalFilelist := TGlobalFilelist.Create;

  // parse parameters into Parameters object
  tmpCmdLine := nativeOS2GetCmdLineParameter;
  CmdLineParameters := TCmdLineParameters.Create;
  CmdLineParameters.parseCmdLine(tmpCmdLine);

  Application.HelpFile := CmdLineParameters.GetOwnHelpFilename; // OWN_HELP_MARKER;
  Application.OnHelp := OnHelp;

  RegisterEventForLanguages( OnLanguageEvent );

  // if debug is not enabled, get rid of the debug menu and separator.
  if not CmdLineParameters.isDebugEnabled then
  begin
    ToolsDebugSep.Destroy;
    ToolsDebugMenu.Destroy;
    DebugShowCodesMI := nil;
    DebugShowWordSeparatorsMI := nil;
  end;

  // set up globals for Exec
  ExecViaSession := true;
  AsynchExec := true;

  // set up form icons
  Forms.FormIconResourceID := 1;

  Application.OnException := OnException;

  ContentsOutline.SmoothScroll := false;

  LogEvent(LogStartup, 'Choosing default font: Trying WarpSans');

  Font := GetNiceDefaultFont;

  // Set the menu fonts, because they remember their own specific one
  MainMenu.Font := Screen.MenuFont;
  ViewPopupMenu.Font := Screen.MenuFont;

  // NOTE: SPCC will copy this font to TApplication
  // in TApplication.Run

  LogEvent(LogStartup, 'Starting NewView: MainFormOnCreate');

  Application.OnHint := OnHint;

  StartMem := MemAvailBytes;

  DisplayedIndex := TStringList.Create;

  HelpManagerWindows := TList.Create;

  AllFilesWordSequences := TList.Create;

  CurrentOpenFiles := TList.Create;
  Notes := TList.Create;
  Bookmarks := TList.Create;
  BookmarksMenuItems := TList.Create;
  Windows := TList.Create;

  TopicText := TAString.Create;

  Navigating := false;
  InIndexSearch := false;
  SettingFont := false;

  PageHistory := TStringList.Create;
  CurrentHistoryIndex := -1;

  Settings.MRUList := TList.Create;

  MRUMenuItems := TList.Create;
  NavigateToMenuItems := TList.Create;

  LogEvent(LogSettings, 'Loading settings');

  LoadSettings;
  SetShowLeftPanel( ShowLeftPanel ); // update menu

  // load default strings
  LogEvent(LogSettings, 'Loading language');

  // the user likes to have english
  // the normal automatic will fall back to
  // the environment setting but in the special
  // case we have to start the default
  if CmdLineParameters.getLanguage = 'en' then
  begin
    LoadLanguage('');
  end
  else
  begin
    if CmdLineParameters.getLanguage <> '' then
    begin
      if not LoadLanguageForSpec('newview', CmdLineParameters.getLanguage) then
      begin
        LoadDefaultLanguage('newview');
      end
    end
    else
    begin
      LoadDefaultLanguage('newview');
    end;
  end;

  LogEvent(LogSettings, 'Applying settings');
  ApplySettings;

  // default position is centered..
  LogEvent(LogSettings, 'Set default position');
  if Width > Screen.Width then
    Width := Screen.Width;
  if Height > Screen.Height then
    Height := Screen.Height;
  Left := ( Screen.Width - Width ) div 2;
  Bottom := ( Screen.Height - Height ) div 2;

  LogEvent(LogSettings, 'ReadWindowPos');
  ReadWindowPos( Self );

  PositionWindow;

  LogEvent(LogSettings, 'Creating MRU list');

  CreateMRUMenuItems;

  CloseFile;

  LogEvent(LogStartup, 'OnCreate done');

  if CmdLineParameters.getWindowPositionFlag then
  begin
    SmartSetWindowPos( self,
                       CmdLineParameters.getWindowPosition.Left,
                       CmdLineParameters.getWindowPosition.Bottom,
                       CmdLineParameters.getWindowPosition.Width,
                       CmdLineParameters.getWindowPosition.Height,
                       false );
  end;

  LogEvent(LogStartup, 'MainFormOnCreate Done');
End;

Procedure TMainForm.ApplySettings;
var
  ToolbarBitmap: TBitmap;
begin
  ContentsOutline.Color:= Settings.Colors[ ContentsBackgroundColorIndex ];
  ContentsOutline.PenColor:= Settings.Colors[ ContentsTextColorIndex ];
  ContentsOutline.TreeLineColor:= Settings.Colors[ ContentsLinesColorIndex ];
  IndexListBox.Color:= Settings.Colors[ IndexBackgroundColorIndex ];
  IndexListBox.PenColor:= Settings.Colors[ IndexTextColorIndex ];
  SearchResultsListBox.Color:= Settings.Colors[ SearchBackgroundColorIndex ];
  SearchResultsListBox.PenColor:= Settings.Colors[ SearchTextColorIndex ];
  NotesListBox.Color:= Settings.Colors[ NotesListBackgroundColorIndex ];
  NotesListBox.PenColor:= Settings.Colors[ NotesListTextColorIndex ];

  SettingFont := true;
  Notebook.ParentFont := true;
  ContentsOutline.ParentFont := true;
  IndexListBox.ParentFont := true;
  SearchResultsListBox.ParentFont := true;
  NotesListBox.ParentFont := true;
  TabSet.ParentFont := true;
  Coolbar.ParentFont := true;
  if Settings.Fonts[ ApplicationFontIndex ] <> nil then
    Font := Settings.Fonts[ ApplicationFontIndex ]
  else
    Font := GetNiceDefaultFont;
  SettingFont := false;

  Coolbar.BackgroundBitmap := nil;
  if FileExists( Settings.ToolbarBackgroundImageFilename ) then
  begin
    ToolbarBitmap:= TBitmap.Create;
    try
      ToolbarBitmap.LoadFromFIle( Settings.ToolbarBackgroundImageFilename );
      Coolbar.BackgroundBitmap := ToolbarBitmap;
    except
    end;
    ToolbarBitmap.Destroy;
  end;

  CoolBar.ShowImages := Settings.ToolbarStyle in [ tsImages, tsImagesAndText ];
  CoolBar.ShowText := Settings.ToolbarStyle in [ tsText, tsImagesAndText ];

  CoolBar.SetMinConstButtonWidth;

  DisplayPanel.Color := Settings.Colors[ TopicBackgroundColorIndex ];

  SetupViews( Windows );
end;

// Setup the rich text views in the specified windows (e.g for changing global settings)
Procedure TMainForm.SetupViews( WindowList: TList );
var
  WindowIndex: longint;
  Window: THelpWindow;
begin
  for WindowIndex := 0 to WindowList.Count - 1 do
  begin
    Window := WindowList[ WindowIndex ];
    Window.SetupRTView;
    SetupViews( Window.ChildWindows );
  end;
end;

Procedure TMainForm.PostHelpManagerMessage( MessageType: ULONG;
                                            Param1: long;
                                            Param2: long );
var
  i: longint;
begin
  for i := 0 to HelpManagerWindows.Count - 1 do
    PostMsg( HWND( HelpManagerWindows[ i ] ),
             MessageType,
             Param1,
             Param2 );
end;

Procedure TMainForm.ClearHelpManager;
Begin
  if not CmdLineParameters.getHelpManagerFlag then
    exit;

  // tell the help manager(s) we are no longer playing with them
  PostHelpManagerMessage( NHM_FORGET_VIEWER, 0, 0 );

  CmdLineParameters.setHelpManagerFlag(false);

  HelpManagerWindows.Clear;
End;

Procedure TMainForm.MainFormOnShow (Sender: TObject);
Begin
  EnableCallstackLogging( true );

  LogEvent(LogStartup, 'MainFormOnShow');

  if CmdLineParameters.getOwnerWindow <> NULLHANDLE then
  begin
    LogEvent(LogStartup, 'Setting owner: ' + IntToStr( CmdLineParameters.getOwnerWindow));
    WinSetOwner( Frame.Handle, CmdLineParameters.getOwnerWindow );
  end;

  if CmdLineParameters.getHelpManagerFlag then
  begin
    LogEvent(LogStartup, '  Help Manager Title: '
                  + StrPasWithLength( pSharedStruct ^. Title,
                             SHARED_STRUCT_TITLE_SIZE ) );
    HelpManagerVersion := StrPasWithLength( pSharedStruct ^. Version,
                                   SHARED_STRUCT_VERSION_SIZE );
    LogEvent(LogStartup, '  Help Manager Version: ' + HelpManagerVersion );

  end;

  CoolBar.SetMinConstButtonWidth;

  ResetProgress;

  AddShortcut( kbF11, kbF11 ); // prev in contents
  AddShortcut( kbF12, kbF12 ); // next in contents
  AddShortcut( kbF7, kbF7 ); // back
  AddShortcut( kbF8, kbF8 ); // forward
  AddShortcut( kbCtrlCLeft, kbCtrlCLeft ); // back

  LogEvent(LogStartup, 'Post WM_OPENED');
  PostMsg( Handle, WM_OPENED, 0, 0 );
End;

Procedure TMainForm.DisplaySelectedContentsTopic;
var
  Topic: TTopic;
Begin
  if ContentsOutline.SelectedNode = nil then
    exit;
  Topic := ContentsOutline.SelectedNode.Data as TTopic;
  DisplayTopic( Topic );
End;

// Check that the HELP and BOOKSHELF environment variables
// are defined (as they should be on any working OS/2 system).
// Show a warning message if not.
Procedure TMainForm.CheckEnvironmentVars;
var
  HelpOK: boolean;
  BookshelfOK: boolean;
  ErrorText: string;
begin
  HelpOK := GetEnv( HelpPathEnvironmentVar ) <> '';
  BookshelfOK := GetEnv( BookshelfEnvironmentVar ) <> '';
  if HelpOK and BookshelfOK then
    // all ok.
    exit;

  // One or both missing

  ErrorText := '';
  if not BookshelfOK then
    ErrorText := ErrorText
                 + EnvironmentVarUndefined
                 + BookshelfEnvironmentVar
                 + StrCRLF;

  if not HelpOK then
    ErrorText := ErrorText
                 + EnvironmentVarUndefined
                 + HelpPathEnvironmentVar
                 + StrCRLF;

  DoWarningDlg( EnvironmentVarErrorTitle,
                EnvironmentVarError
                + StrCRLF
                + StrCRLF
                + ErrorText );

end;

Procedure LoadSupportDLL;
begin
  try
    LoadDLLFunction( 'newview.dll',
                     'LZWDECOMPRESSBLOCK',
                     hNewViewDLL,
                     pointer( LZWDecompressBlock ) );
  except
    on E: Exception do
    begin
      DoErrorDlg( 'DLL Error',
                  E.Message );
      LZWDecompressBlock := nil;
    end;
  end;
end;

Procedure TMainForm.WMOpened( Var Msg: TMessage );
var
  Filenames: TStringList;
  M1: longword;
  OpenFirstTopic: boolean;
  tmpFileNames : AnsiString;
begin
  if Application.HelpFile = '' then
    DoErrorDlg( 'NewView Help', 'NewView help file not found' );

  LoadSupportDLL;

  LogEvent(LogStartup, 'WMOpened: SetLayout');

  // direct access the field to suppress updates done by the setter
  if CmdLineParameters.getHelpManagerFlag then
    FShowLeftPanel := Settings.ShowLeftPanel_Help
  else
    FShowLeftPanel := Settings.ShowLeftPanel_Standalone;

  SetLayout;

//  ProfileEvent( 'Apply settings' );
//  ApplySettings;

  LogEvent(LogStartup, 'Enable controls');
  EnableControls;

//  ProfileEvent( 'ReadWindowPos' );
//  ReadWindowPos( Self );

  LogEvent(LogStartup, 'Finish paint');
  Update;
  LogEvent(LogStartup, 'BringToFront');
  MainForm.BringToFront;

  if not CmdLineParameters.getHelpManagerFlag then
  begin
    LogEvent(LogStartup, 'Check environment vars');
    CheckEnvironmentVars;

    if CmdLineParameters.getShowUsageFlag then
    begin
      LogEvent(LogStartup, 'Showing usage');
      ShowUsage;
    end;
  end;

  HelpManagerWindows.Add( pointer( CmdLineParameters.getHelpManagerWindow ) );

  if CmdLineParameters.getShowIndexFlag then
  begin
    DisplayIndex;
  end;

  tmpFileNames := CmdLineParameters.getFileNames(Settings.StartupHelp);
  if tmpFileNames <> '' then
  begin
    // open specified files
    Filenames := TStringList.Create;

    ParseAndExpandFileNames(tmpFileNames, Filenames);
    LogEvent(LogStartup, 'Call OpenFiles');

    OpenFirstTopic := true;

    if ( CmdLineParameters.getSearchText <> '' )
       OR CmdLineParameters.getSearchFlag
       OR CmdLineParameters.getHelpManagerFlag
    then
      // if we're going to search, don't open first topic
      // don't open first topic if we're online help
      // in case we are wanting to show a specific topic
      // - saves time/flicker
      OpenFirstTopic := false;

    OpenFiles( Filenames,
               CmdLineParameters.getWindowTitle,
               OpenFirstTopic );

    Filenames.Destroy;

    if not CmdLineParameters.getSearchFlag
       and not CmdLineParameters.getGlobalSearchFlag
       and (CmdLineParameters.getSearchText <> '') then
    begin
      // search in contents only!
      LogEvent(LogStartup, 'Do startup topic search for: "' + CmdLineParameters.getSearchText + '"');

      StartupTopicSearch( CmdLineParameters.getSearchText );
    end
    else if CmdLineParameters.getSearchFlag then
    begin
      // search in specified files
      LogEvent(LogStartup, 'Do search for topic');
      DisplaySearch;

      SearchFor( CmdLineParameters.getSearchText );
    end;
  end;

  if NOT CmdLineParameters.getShowUsageFlag
     AND CmdLineParameters.getGlobalSearchFlag then
  begin
    // Global search
    LogEvent(LogStartup, 'Do global search: ' + CmdLineParameters.getSearchText);
    DoGlobalSearch( CmdLineParameters.getSearchText );
  end;

  LogEvent(LogStartup, 'Open finished');

  if CmdLineParameters.getHelpManagerFlag then
  begin
    // Tell helpmanager(s) our window handle
    PostHelpManagerMessage( NHM_VIEWER_READY,
                            Handle,
                            0 );
  end;

  M1:= MemAvail;

  StartingUp := false;

  LogEvent(LogStartup, 'RUN PROGRAM');
end;


Procedure TMainForm.MainFormOnResize (Sender: TObject);
Begin
  if not Visible then
    exit;
  if Handle = 0 then
    exit;

  SetLayout;

End;

Function TMainForm.GetShowLeftPanel: boolean;
begin
  Result := FShowLeftPanel;
end;

Procedure TMainForm.SetShowLeftPanel( Value: boolean );
begin
  ShowLeftPanelMI.Checked := Value;
  if Value = FShowLeftPanel then
    exit;
  FShowLeftPanel := Value;
  if FShowLeftPanel then
    NotebookOnPageChanged( self ) // make sure page is updated
  else
    FocusFirstHelpWindow;
  EnableControls;
  SetLayout;
end;

Procedure TMainForm.VSplitBarOnChange (NewSplit: LongInt);
Begin
  if VSplitBar.Left < 30 then
  begin
    ShowLeftPanel := false
  end
  else
  begin
    Settings.LeftPanelWidth := VSplitBar.Left;
    ShowLeftPanel := true;
  end;
  SetLayout;
End;

// Set the layout of the main form
Procedure TMainForm.SetLayout;
var
  RealClientHeight : longint;
  CoolbarSpace: longint;
  TextHeight: longint;
Begin
  TextHeight := Canvas.TextHeight( 'S' );
  Tabset.Height := TextHeight + 5;

  Coolbar.Visible := Settings.ToolbarStyle <> tsNone;

  case Settings.ToolbarStyle of
    tsImages:
      Coolbar.Height := Coolbar.Sections[ 0 ].Width;
    tsText:
      Coolbar.Height := TextHeight + 5;
    tsImagesAndText:
      CoolBar.Height := ButtonImages.GetBitmapReference(0).Width + TextHeight + 10;
  end;

  CoolbarSpace := Coolbar.Height;
  if not Coolbar.Visible then
    CoolbarSpace := 0;

  StatusPanel.Left:= 0;
  StatusPanel.Width:= ClientWidth div 2 - 2;
  StatusPanel.Height := TextHeight + 2;

  ProgressPanel.Left:= ClientWidth div 2 + 2;
  ProgressPanel.Width:= ClientWidth - ProgressPanel.Left;
  ProgressPanel.Height := TextHeight + 2;

  Notebook.Bottom := StatusPanel.Height + 3;
  VSplitBar.Bottom := Notebook.Bottom;
  DisplayPanel.Bottom := Notebook.Bottom;

  RealClientHeight := ClientHeight
                      - CoolbarSpace
                      - Notebook.Bottom;

  LogEvent(LogStartup, 'TMainForm.SetLayout');
  LogEvent(LogStartup, '  RealClientHeight: '  + IntToStr( RealClientHeight ));

  LogEvent(LogStartup, '  Form Width: '  + IntToStr( Width ));
  LogEvent(LogStartup, '  Form Height: '  + IntToStr( Height ) );
  LogEvent(LogStartup, '  Form ClientWidth: '  + IntToStr( ClientWidth ) );
  LogEvent(LogStartup, '  Form ClientHeight: '  + IntToStr( ClientHeight ) );
  LogEvent(LogStartup, '  CoolBar.Height: '  + IntToStr( CoolBar.Height ) );
  LogEvent(LogStartup, '  CoolBar.Bottom: '  + IntToStr( CoolBar.Bottom ) );

  if CurrentOpenFiles.Count > 0 then
    VSplitBar.Width := Max( 5, Canvas.TextWidth( ' ' ) )
  else
    VSplitBar.Width := 0;

  VSplitBar.Height := RealClientHeight;

  if Settings.LeftPanelWidth > ClientWidth - 50 then
    Settings.LeftPanelWidth := ClientWidth - 50;
  if Settings.LeftPanelWidth < 50 then
    Settings.LeftPanelWidth := 50;

  if ShowLeftPanel then
  begin
    VSplitBar.Left := Settings.LeftPanelWidth;
    VSplitBar.Hint := SplitBarDblClickToHide;
  end
  else
  begin
    VSplitBar.Left := 0;
    VSplitBar.Hint := SplitBarDblClickToShow;
  end;

  Tabset.Left := 0;
  Tabset.Width := VSplitBar.Left;
  Tabset.Bottom := ClientHeight
                   - CoolbarSpace
                   - Tabset.Height;

  Notebook.Left := 0;
  Notebook.Width := VSplitBar.Left;
  Notebook.Height := RealClientHeight
                     - Tabset.Height
                     - 3;

  DisplayPanel.Left:= VSplitBar.Left + VSplitBar.Width;
  DisplayPanel.Width:= ClientWidth - DisplayPanel.Left;
  DisplayPanel.Height := RealClientHeight;
  LogEvent(LogStartup, '  DisplayPanel.Width: '  + IntToStr( DisplayPanel.Width ) );
  LogEvent(LogStartup, '  DisplayPanel.Height: '  + IntToStr( DisplayPanel.Height ) );
  LogEvent(LogStartup, '  DisplayPanel.Bottom: '  + IntToStr( DisplayPanel.Bottom ) );

  ProgressBar.Left:= 1;
  ProgressBar.Bottom:= 1;
  ProgressBar.Width:= ProgressPanel.Width - 2;
  ProgressBar.Height:= ProgressPanel.Height - 2;

  // Layout the visible help windows also
  LayoutWindowList( Windows );
End;

// Lay out the specified list of help windows
Procedure TMainForm.LayoutWindowList( WindowList: TList );
var
  Window: THelpWindow;
  WindowIndex: longint;
begin
  for WindowIndex:= 0 to WindowList.Count - 1 do
  begin
    Window:= WindowList[ WindowIndex ];
    Window.SetLayout;
  end;
end;

Procedure TMainForm.FindNextMIOnClick (Sender: TObject);
begin
  if FindText = '' then
  begin
    FindMIOnClick( sender );
    exit;
  end;

  if GetActiveWindow = nil then
  begin
    DoErrorDlg( FindTitle,
                FindSelectWindowError );
    exit;
  end;

  DoFind( foFromCurrent );
end;

Procedure TMainForm.DoFind( FindOrigin: TFindOrigin );
var
  Window: THelpWindow;
begin
  SetWaitCursor;
  Window := GetActiveWindow;
  if not Window.View.Find( FindOrigin, FindText ) then
  begin
    SetStatus( TextNotFoundMsg );
    Beep( 1000, 100 );
  end;
  ClearWaitCursor;
End;

Procedure TMainForm.FindMIOnClick (Sender: TObject);
begin
  if GetActiveWindow = nil then
  begin
    DoErrorDlg( FindTitle,
                FindSelectWindowError );
    exit;
  end;
  if not DoInputQuery( FindTitle,
                       FindPrompt,
                       FindText ) then
    exit;

  DoFind( foFromStart );
End;

Procedure TMainForm.IndexSearchEditOnScan (Sender: TObject; Var KeyCode: TKeyCode);
Begin
  case KeyCode of
    kbCUp:
    begin
      if IndexListBox.ItemIndex > 0 then
        IndexListBox.ItemIndex:= IndexListBox.ItemIndex - 1;
      KeyCode:= kbNull;
    end;

    kbCDown:
    begin
      if IndexListBox.ItemIndex < IndexListBox.Items.Count - 1 then
        IndexListBox.ItemIndex:= IndexListBox.ItemIndex + 1;
      KeyCode:= kbNull;
    end;

    kb_VK + VK_NEWLINE:
    begin
      DisplaySelectedIndexTopic;
    end;
  end;

End;

Procedure TMainForm.IndexSearchEditOnChange (Sender: TObject);
var
  tmpMatchIndex : longint;
  tmpSearchText: string;
  i : longint;
Begin
  if InIndexSearch then
    exit;

  tmpMatchIndex := -1;
  tmpSearchText := trim(IndexSearchEdit.Text);

  for i := 0 to DisplayedIndex.Count - 1 do
  begin
    if StrStartsWithIgnoringCase(DisplayedIndex[i], tmpSearchText) then
    begin
      tmpMatchIndex := i;
      break;
    end;
  end;

  if tmpMatchIndex = -1 then
    exit;

  InIndexSearch:= true;

  if IndexListBox.ItemIndex <> tmpMatchIndex then
    IndexListBox.ItemIndex:= tmpMatchIndex;

  InIndexSearch:= false;
End;

Procedure TMainForm.FileInformationMIOnClick (Sender: TObject);
var
  FileIndex: longint;
  HelpFile: THelpFile;

  TotalTopicCount: longint;
  TotalIndexCount: longint;
  TotalFileSize: longint;

Begin
  TotalTopicCount := 0;
  TotalIndexCount := 0;
  TotalFileSize := 0;

  with InformationForm.InformationMemo do
  begin
    BeginUpdate;
    Lines.Clear;
    Lines.Add( FilesInfoTitle );
    for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
    begin
      HelpFile := CurrentOpenFiles[ FileIndex ];

      Lines.Add( FilesInfoFilename + HelpFile.FileName );
      Lines.Add( FilesInfoFileTitle
                 + HelpFile.Title );
      Lines.Add( FilesInfoTopicCount
                 + IntToStr( HelpFile.TopicCount ) );
      Lines.Add( FilesInfoIndexCount
                 + IntToStr( HelpFile.Index.Count ) );
      Lines.Add( FilesInfoDictionaryCount
                 + IntToStr( HelpFile.DictionaryCount ) );
      Lines.Add( FilesInfoFileSize
                 + IntToStr( HelpFile.FileSize ) );

      inc( TotalTopicCount, HelpFile.TopicCount );
      inc( TotalIndexCount, HelpFile.Index.Count );
      inc( TotalFileSize, HelpFile.FileSize );

    end;

    Lines.Add( '' );
    Lines.Add( FilesInfoTotalTopicCount
               + IntToStr( TotalTopicCount ) );
    Lines.Add( FilesInfoTotalIndexCount
               + IntToStr( TotalIndexCount ) );
    Lines.Add( FilesInfoTotalFileSize
               + IntToStr( TotalFileSize ) );
    Lines.Add( '' );

    EndUpdate;
  end;
  InformationForm.ShowModal;
End;

Procedure TMainForm.DisplaySelectedSearchResultTopic;
var
  Topic: TTopic;
Begin
  if SearchResultsListBox.ItemIndex = -1 then
    exit;
  if SelectedObject( SearchResultsListBox ) = nil then
    // the "no results" place holder
    exit;
  Topic := SelectedObject( SearchResultsListBox ) as TTopic;
  DisplayTopic( Topic );
End;

Procedure TMainForm.SearchTextEditOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  case KeyCode of
    kbCUp:
    begin
      if SearchResultsListBox.ItemIndex > 0 then
        SearchResultsListBox.ItemIndex := SearchResultsListBox.ItemIndex - 1;
      KeyCode := kbNull;
      SearchResultsListBox.Focus;
    end;

    kbCDown:
    begin
      if SearchResultsListBox.ItemIndex < SearchResultsListBox.Items.Count - 1 then
        SearchResultsListBox.ItemIndex := SearchResultsListBox.ItemIndex + 1;
      KeyCode := kbNull;
      SearchResultsListBox.Focus;
    end;
  end;
End;

Procedure TMainForm.SearchButtonOnClick (Sender: TObject);
Begin
  DoSearch;
End;

// Matches old stupid View algorithm
Procedure TMainForm.StartupTopicSearch( const SearchText: string );
var
  i: longint;
  HelpFile: THelpFile;
  Topic: TTopic;
  // s: string;
begin
  // search files in order they are open
  for i := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := THelpFile( CurrentOpenFiles[ i ] );

    // look for a topic whose title starts with the searchtext
    Topic := HelpFile.FindTopicByTitleStartsWith( SearchText );

    if Topic = nil then
      // look for an index entry that starts with the searchtext
      Topic := HelpFile.FindTopicByIndexStartsWith( SearchText );

    if Topic = nil then
      // look for a topic whose title contains the searchtext
      Topic := HelpFile.FindTopicByTitleContains( SearchText );

    if Topic = nil then
      // look for an index entry that contains the searchtext
      Topic := HelpFile.FindTopicByIndexContains( SearchText );

    if Topic <> nil then
    begin
      // found something, display it (don't keep searching files)
      DisplayTopic( Topic );
      exit;
    end;
  end;
  DoErrorDlg( SearchTitle, TextNotFoundMsg );
end;

Procedure TMainForm.SearchFor( const SearchText: string );
begin
  SearchTextEdit.Text := SearchText;
  DisplaySearch;
  SearchResultsListBox.Focus;

  // force repaint of everything before we start searching.
  Update;

  DoSearch;
end;

Procedure TMainForm.ClearAllWordSequences;
var
  i: longint;
  FileWordSequences: TList;
  HelpFile: THelpFile;
begin
  if AllFilesWordSequences = nil then
    exit;

  for i := 0 to AllFilesWordSequences.Count - 1 do
  begin
    FileWordSequences := AllFilesWordSequences[ i ];
    HelpFile := CurrentOpenFiles[ i ];
    ClearWordSequences( FileWordSequences, HelpFile.DictionaryCount );
    FileWordSequences.Destroy;
  end;
  AllFilesWordSequences.Clear;
end;

// Perform search for text in searchedit.
Procedure TMainForm.DoSearch;
var
  SearchResults: TList;
  SearchText: string;
  FileIndex: longint;
  HelpFile: THelpFile;
  TopicIndex: longint;
  Topic: TTopic;
  FileWordSequences: TList;
  Query: TTextSearchQuery;
begin
  SearchText := Trim( SearchTextEdit.Text );

  SearchResultsListBox.Clear;

  if SearchText = '' then
    exit;

  SearchResultsListBox.Items.Add( SearchingMsg );
  SetStatus( SearchingMsg );

  try
    Query := TTextSearchQuery.Create( SearchText );
  except
    on e: ESearchSyntaxError do
    begin
      DoErrorDlg( SearchTitle,
                  SearchSyntaxError
                  + e.Message );
      exit;
    end;
  end;

  ClearAllWordSequences;

  SetWaitCursor;

  SearchResults := TList.Create;

  // Search open help file
  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];

    FileWordSequences := TList.Create;

    try
      SearchHelpFile( HelpFile,
                      Query,
                      SearchResults,
                      FileWordSequences );
    except
      on E: EHelpFileException do
      begin
        DoErrorDlg( ErrorTitle, E.Message );
        Query.Destroy;
        ClearWaitCursor;
        exit;
      end;
    end;

    AllFilesWordSequences.Add( FileWordSequences );

  end;

  // Sort results across all files by relevance
  SearchResults.Sort( TopicRelevanceCompare );

  // Load topics into search results list.
  SearchResultsListBox.BeginUpdate;
  SearchResultsListBox.Clear;

  for TopicIndex := 0 to SearchResults.Count - 1 do
  begin
    Topic := SearchResults[ TopicIndex ];
    SearchResultsListBox.Items.AddObject( Topic.Title
                                          + ' ['
                                          + IntToStr( Topic.SearchRelevance )
                                          + ']',
                                          Topic );
  end;

  EnableControls;
  if SearchResultsListBox.Items.Count > 0 then
    // there are some search matches, so highlight words
    ViewHighlightSearchWordsMI.Checked := true;

  SearchResultsListBox.ItemIndex := -1;
  SearchResultsListBox.EndUpdate;

  Query.Destroy;
  SearchResults.Destroy;

  if SearchResultsListBox.Items.Count > 0 then
  begin
    SearchResultsListBox.ItemIndex := 0;
  end
  else
  begin
    SearchResultsListBox.Items.Add(   NoSearchMatchesMsg
                                    + ': '
                                    + SearchText );
    RefreshWindows( Windows ); // update to remove old highlights
  end;
  SetStatus( SearchFoundMsgA
             + IntToStr( SearchResultsListBox.Items.Count )
             + SearchFoundMsgB
             + StrInDoubleQuotes(SearchText)
             );

  ClearWaitCursor;

  DisplaySelectedSearchResultTopic;

End;

Procedure TMainForm.FileSaveAsMIOnClick (Sender: TObject);
var
  F: File;
  EntryText: PChar;
  TextLength: longint;
  Window: THelpWindow;
  Filename: string;
Begin
  Window := GetActiveWindow;
  if Window = nil then
  begin
    DoErrorDlg( FileSaveTitle,
                FileSaveSelectWindowError );
    exit;
  end;

  if DoSaveFileDialog( FileSaveTitle,
                       AllFilesDesc + '|*',
                       DefaultSaveTopicFilename,
                       Settings.LastSaveDirectory,
                       Filename ) then
  begin
    if FileExists( Filename ) then
      if not DoConfirmDlg( FileSaveTitle,
                           ReplaceFilePromptA
                           + Filename
                           + ReplaceFilePromptB ) then
        exit;
    System.Assign( F, Filename );

    try
      Rewrite( F );
    except
      on E: Exception do
      begin
        DoErrorDlg( FileSaveTitle,
                    UnableToSaveError
                    + Filename
                    + ': '
                    + E.Message );
        exit;
      end;
    end;

    // find out length of (plain) text
    TextLength := Window.View.CopyTextToBuffer( nil, -1 );

    // allocate space
    EntryText:= StrAlloc( TextLength );

    // get the plain text
    Window.View.CopyTextToBuffer( EntryText, TextLength );

    // save to file
    System.BlockWrite( F, EntryText^, TextLength );

    // free space
    StrDispose( EntryText );

    System.Close( F );
  end;
End;

Procedure TMainForm.OptionsMIOnClick (Sender: TObject);
begin
  DoOptions;
end;

Procedure TMainForm.DoOptions;
Begin
  EnsureOptionsFormLoaded;

  GetColors; // in case changed by drag drop

  if OptionsForm.ShowModal = mrOK then
  begin
    ApplySettings;
    SetLayout;
    RefreshFontSubstitutions;
    RefreshWindows( Windows );
  end;
End;

Procedure TMainForm.ShowUsage;
begin
  DoMessageDlg( UsageTitle,
                  UsageText1 + StrCRLF
                + UsageText2 + StrCRLF
                + UsageText3 + StrCRLF
                + UsageText4 + StrCRLF
                + UsageText5 + StrCRLF
                + UsageText6 + StrCRLF
                + UsageText7 + StrCRLF
                + UsageText8 );
end;

Procedure TMainForm.TabSetOnChange (Sender: TObject; NewTab: LongInt;
  Var AllowChange: Boolean);
Begin
  NoteBook.PageIndex := NewTab;
End;

Procedure TMainForm.NotebookOnSetupShow (Sender: TObject);
Begin
  ContentsOutline.xStretch := xsFrame;
  ContentsOutline.yStretch := ysFrame;

  IndexSearchEdit.yAlign := yaTop;
  IndexSearchEdit.xStretch := xsFrame;
  IndexListBox.yStretch := ysFrame;
  IndexListBox.xStretch := xsFrame;

  SearchTextEdit.yAlign := yaTop;
  SearchTextEdit.xStretch := xsFrame;
  SearchButton.yAlign := yaTop;
  SearchButton.xAlign := xaRight;
  SearchResultsListBox.xStretch := xsFrame;
  SearchResultsListBox.yStretch := ysFrame;

  NotesListBox.xStretch := xsFrame;
  NotesListBox.yStretch := ysFrame;
End;

Procedure TMainForm.EnableControls;
var
  BackEnabled: boolean;
  ForwardEnabled: boolean;
  FileOpen: boolean;
  WindowOpen: boolean;
  AtTop: boolean;
  AtBottom: boolean;
begin
  ViewContentsMI.Checked := ShowLeftPanel and ( Notebook.PageIndex = piContents );
  ViewIndexMI.Checked := ShowLeftPanel and ( Notebook.PageIndex = piIndex );
  ViewSearchMI.Checked := ShowLeftPanel and ( Notebook.PageIndex = piSearch );
  ViewNotesMI.Checked := ShowLeftPanel and ( Notebook.PageIndex = piNotes );

  BackEnabled := CurrentHistoryIndex > 0;
  ForwardEnabled := CurrentHistoryIndex < PageHistory.Count - 1;

  FileOpen := CurrentOpenFiles.Count > 0;
  WindowOpen := Windows.Count > 0;

  ViewContentsMI.Enabled := FileOpen;
  ViewIndexMI.Enabled := FileOpen;
  ViewSearchMI.Enabled := FileOpen;
  ViewNotesMI.Enabled := FileOpen;

  ShowLeftPanelMI.Enabled := FileOpen;

  Coolbar.Sections[ ciBack ].Disabled := not BackEnabled;
  NavigateBackMI.Enabled := BackEnabled;
  Coolbar.Sections[ ciForward ].Disabled := not ForwardEnabled;
  NavigateForwardMI.Enabled := ForwardEnabled;

  FileSaveAsMI.Enabled := FileOpen;

  Coolbar.Sections[ ciPrint ].Disabled := not FileOpen;
  PrintMI.Enabled := FileOpen;
  FileInformationMI.Enabled := FileOpen;

  Coolbar.Sections[ ciAddBookmark ].Disabled := not FileOpen;
  AddBookmarkMI.Enabled := FileOpen;
  EditBookmarksMI.Enabled := FileOpen;
  Coolbar.Sections[ ciAddNote ].Disabled := not FileOpen;
  AddNoteMI.Enabled := FileOpen;

  if ContentsOutline.SelectedNode <> nil then
  begin
    AtTop := ContentsOutline.NextNodeUp( ContentsOutline.SelectedNode, false ) = nil;
    AtBottom := ContentsOutline.NextNodeDown( ContentsOutline.SelectedNode, false ) = nil;
  end;

  NavigateNextMI.Enabled := FileOpen
                            and ( ContentsOutline.SelectedNode <> nil )
                            and ( not AtBottom );
  Coolbar.Sections[ ciNext ].Disabled := not NavigateNextMI.Enabled;
  NavigatePreviousMI.Enabled := FileOpen
                                and ( ContentsOutline.SelectedNode <> nil )
                                and ( not AtTop );
  Coolbar.Sections[ ciPrevious ].Disabled := not NavigatePreviousMI.Enabled;

  FileCloseMI.Enabled := FileOpen;

  FindMI.Enabled := WindowOpen;
  FindNextMI.Enabled := WindowOpen;
  CopyMI.Enabled := WindowOpen;
  SelectAllMI.Enabled := WindowOpen;

  ViewExpandAllMI.Enabled := ContentsOutline.ChildCount > 0;
  ViewCollapseAllMI.Enabled := ContentsOutline.ChildCount > 0;

  DebugTopicByResourceIDMI.Enabled := FileOpen;
  TopicByNameMI.Enabled := FileOpen;

  ViewHighlightSearchWordsMI.Enabled := SearchResultsListBox.Items.Count > 0;
  if not ViewHighlightSearchWordsMI.Enabled then
    ViewHighlightSearchWordsMI.Checked := false;

  ViewRefreshMI.Enabled := WindowOpen;

  EnableSearchButton;
  EnableNotesControls;

  VSplitBar.Visible := FileOpen;
  if not FileOpen then
  begin
    SetShowLeftPanel( false );
  end;


end;

Procedure TMainForm.NavigateBackMIOnClick (Sender: TObject);
begin
  NavigateBack;
end;

Procedure TMainForm.SaveNavigatePoint;
var
  NavPoint: TNavigatePoint;
begin
  // delete rest of history.
  while CurrentHistoryIndex < PageHistory.Count - 1 do
  begin
    NavPoint:= PageHistory.Objects[ CurrentHistoryIndex + 1 ] as TNavigatePoint;
    NavPoint.Destroy;
    PageHistory.Delete( CurrentHistoryIndex + 1 );
  end;

  NavPoint:= TNavigatePoint.Create;
  SaveWindows( Windows, NavPoint.Windows, nil );

  if ContentsOutline.SelectedNode <> nil then
    NavPoint.ContentsTopic:= ContentsOutline.SelectedNode.Data as TTopic
  else
    NavPoint.ContentsTopic:= nil;

  if CurrentTopic <> nil then
    PageHistory.AddObject( CurrentTopic.Title, NavPoint )
  else
    PageHistory.AddObject( '', NavPoint );

  inc( CurrentHistoryIndex );

  CreateNavigateToMenuItems;
end;

Procedure TMainForm.UpdateCurrentNavigatePoint;
var
  NavPoint: TNavigatePoint;
begin
  if CurrentHistoryIndex = -1 then
    exit;

  NavPoint:= PageHistory.Objects[ CurrentHistoryIndex ] as TNavigatePoint;

  DestroyListObjects( NavPoint.Windows );
  NavPoint.Windows.Clear;

  SaveWindows( Windows, NavPoint.Windows, nil );
end;

Procedure TMainForm.ClearPageHistory;
var
  i: longint;
  NavPoint: TNavigatePoint;
begin
  for i := 0 to PageHistory.Count - 1 do
  begin
    NavPoint := PageHistory.Objects[ i ] as TNavigatePoint;
    NavPoint.Destroy;
  end;
  PageHistory.Clear;
  CurrentHistoryIndex := -1;
  CreateNavigateToMenuItems;
  EnableControls;
end;

Procedure TMainForm.SaveWindows( SourceList: TList;
                                 DestList: TList;
                                 Parent: TSavedHelpWindow );

var
  WindowIndex: longint;
  Window: THelpWindow;
  WindowCopy: TSavedHelpWindow;
begin
  // limit storage to only what's need since list will be static.
  DestList.Capacity := SourceList.Count;
  for WindowIndex := 0 to SourceList.Count - 1 do
  begin
    Window := SourceList[ WindowIndex ];
    WindowCopy := TSavedHelpWindow.Create;
    WindowCopy.Parent := Parent;
    WindowCopy.Rect.Assign( Window.Rect );
    WindowCopy.Topic := Window.Topic;
    WindowCopy.Group := Window.Group;
    WindowCopy.TopCharIndex := Window.View.TopCharIndex;
    SaveWindows( Window.ChildWindows, WindowCopy.ChildWindows, WindowCopy );
    DestList.Add( WindowCopy );
  end;
end;

Procedure TMainForm.DisplayWindows( WindowList: TList;
                                    Parent: THelpWindow );
var
  WindowIndex: longint;
  WindowCopy: TSavedHelpWindow;
  NewWindow: THelpWindow;
begin
  for WindowIndex := 0 to WindowList.Count - 1 do
  begin
    WindowCopy := WindowList[ WindowIndex ];
    NewWindow := OpenWindow( WindowCopy.Topic,
                             WindowCopy.Group,
                             Parent,
                             WindowCopy.Rect,
                             false ); // don't follow links
    NewWindow.View.TopCharIndex := WindowCopy.TopCharIndex;
    DisplayWindows( WindowCopy.ChildWindows, NewWindow );
  end;
end;

Procedure TMainForm.CreateNavigateToMenuItems;
var
  MenuItem: TMenuItem;
  i: integer;
begin
  // clear existing items
  DestroyListObjects( NavigateToMenuItems );
  NavigateToMenuItems.Clear;

  if CurrentHistoryIndex > 0 then
  begin
    // We are going to add some items, so
    // add a seperator from the rest of the menu first
    MenuItem := TMenuItem.Create( self );
    MenuItem.Caption:= '-';
    NavigateMenu.Add( MenuItem );
    NavigateToMenuItems.Add( MenuItem );
  end;

  i := CurrentHistoryIndex - 1; // don't include the current history item
  while (     ( i >= 0 )
          and ( i > CurrentHistoryIndex - 10 ) ) do
  begin
    MenuItem := TMenuItem.Create( self );
    MenuItem.Caption := PageHistory[ i ];
    MenuItem.Hint := GoBackHint
                     + StrInDoubleQuotes( PageHistory[ i ] );
    MenuItem.OnClick := OnNavigateToMenuItemClick;
    MenuItem.Tag := i;

    NavigateMenu.Add( MenuItem );
    NavigateToMenuItems.Add( MenuItem );
    dec( i );
  end;
end;

Procedure TMainForm.NavigateToPoint( NavPoint: TNavigatePoint );
begin
  Navigating := true;

  // close current windows
  CloseWindows;

  // Display windows for the navigate point
  DisplayWindows( NavPoint.Windows, nil );

  // Select the contents topic
  ContentsOutline.SetSelectedObject( NavPoint.ContentsTopic );

  // Update the navigate menu (since a different set of
  // back-points are now available)
  CreateNavigateToMenuItems;

  // Make the topic windows visible
  ShowWindows;

  // Update back buttons etc...
  EnableControls;

  Navigating := false;
end;

Procedure TMainForm.NavigateToHistoryIndex( Index: longint );
var
  NavPoint: TNavigatePoint;
begin
  UpdateCurrentNavigatePoint;
  CurrentHistoryIndex := Index;
  NavPoint := PageHistory.Objects[ CurrentHistoryIndex ] as TNavigatePoint;
  NavigateToPoint( NavPoint );
end;

Procedure TMainForm.NavigateForward;
Begin
  if CurrentHistoryIndex < PageHistory.Count - 1 then
  begin
    NavigateToHistoryIndex( CurrentHistoryIndex + 1 );
  end;
End;

Procedure TMainForm.NavigateBack;
Begin
  if CurrentHistoryIndex > 0 then
  begin
    NavigateToHistoryIndex( CurrentHistoryIndex - 1 );
  end;
End;

Procedure TMainForm.NavigatePreviousInContents;
begin
  ContentsOutline.GotoNextNodeUp;
  DisplaySelectedContentsTopic;
end;

Procedure TMainForm.NavigateNextInContents;
begin
  ContentsOutline.GotoNextNodeDown;
  DisplaySelectedContentsTopic;
end;

Procedure TMainForm.CorrectNotesPositions( Topic: TTopic;
                                           Text: pchar );
var
  NoteIndex: longint;
  Note: THelpNote;
  p: pchar;
  NextP: pchar;
  Element: TTextElement;
  TextIndex: longint;
begin
  NoteIndex := 0;
  for NoteIndex := 0 to Notes.Count - 1 do
  begin
    Note := Notes[ NoteIndex ];
    if Note.Topic = Topic then
    begin
      // this note belongs the the specified topic.
      p := Text;

      while true do
      begin
        Element := ExtractNextTextElement( p, NextP );
        if Element.ElementType = teTextEnd then
          break;
        TextIndex := PCharPointerDiff( p, Text );
        if TextIndex >= Note.InsertPoint then
        begin
          // found a safe point to insert
          if TextIndex <> Note.InsertPoint then
          begin
            // correct it.
            Note.InsertPoint := TextIndex;
          end;
          break;
        end;

        p := NextP;
      end;
    end;
  end;
end;

Procedure TMainForm.InsertNotesIntoTopicText( Topic: TTopic;
                                              Text: TAString );
var
  NoteIndex: longint;
  Note: THelpNote;
  ActualInsertPoint: longword;
begin
  CorrectNotesPositions( Topic, Text.AsPChar );

  for NoteIndex := 0 to Notes.Count - 1 do
  begin
    Note := Notes[ NoteIndex ];
    if Note.Topic = Topic then
    begin
         // Adjust insert point for any notes we have already inserted.
      ActualInsertPoint := FindActualNoteCharIndex( Note.InsertPoint,
                                                    NoteIndex,
                                                    Topic );
      RefreshNoteInsertInfo( NoteIndex );
      Text.Insert( ActualInsertPoint, Note.InsertText );
    end;
  end;
end;

Procedure TMainForm.NavigatePreviousMIOnClick (Sender: TObject);
Begin
  NavigatePreviousInContents;
End;

Procedure TMainForm.NavigateNextMIOnClick (Sender: TObject);
Begin
  NavigateNextInContents;
End;

Function TMainForm.GetActiveWindow: THelpWindow;
var
  View: TRichTextView;
  FirstWindow: THelpWindow;
begin
  Result := nil;
  if Screen.ActiveControl is TRichTextView then
  begin
    View := Screen.ActiveControl as TRichTextView;
    Result := FindWindowFromView( View, Windows );
  end
  else if Windows.Count = 1 then
  begin
    FirstWindow := Windows[ 0 ];
    if FirstWindow.ChildWindows.Count = 0 then
      Result := FirstWindow;
  end;
end;

Procedure TMainForm.CopyMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
begin
  if ActiveControl = nil then
    exit;

  if ActiveControl is TEdit then
  begin
    // this is for the edit controls in the left panel
    TEdit( ActiveControl ).CopyToClipboard;
    exit;
  end;

  // else copy from rtv in active help window

  Window := GetActiveWindow;
  if Window = nil then
    exit;

  Window.View.CopySelectionToClipboard;
End;

Procedure TMainForm.SelectAllMIOnClick (Sender: TObject);
var
  Window: THelpWindow;
begin
  Window:= GetActiveWindow;
  if Window = nil then
  begin
    DoErrorDlg( SelectAllTitle,
                SelectAllWindowError );
    exit;
  end;
  Window.View.SelectAll;
End;

Procedure TMainForm.DebugShowCodesMIOnClick (Sender: TObject);
Begin
  DebugShowCodesMI.Checked:= not DebugShowCodesMI.Checked;
  RefreshWindows( Windows );
End;

Procedure TMainForm.HelpProductInformationMIOnClick (Sender: TObject);
Begin
  EnsureProductInformationFormLoaded;
  ProductInformationForm.ShowModal;
End;

Procedure TMainForm.OnOverLink ( Sender: TRichTextView; LinkString: String);
var
  Link: THelpLink;
  LinkIndex: longint;
  Window: THelpWindow;
  LinkedTopic: TTopic;
  Filename: string;
  SourceFile: THelpFile;
  URL: string;
  LinkDetails: string;
  tmpLinkDetails : TStringList;
  ProgramInfo : TSerializableStringList;
  ProgramPath, ProgramLink : string;
Begin
  LogEvent(LogDebug, 'OnOverLink: "' + LinkString + '"');

  if StrStartsWith(LinkString, PARAM_LINK_NOTE) then
  begin
    SetStatus( EditNoteMsg )
  end
  else if StrStartsWith(LinkString, PARAM_LINK_PROGRAM) then
  begin
    ProgramInfo := TSerializableStringList.create;
// TODO check param here

    ProgramInfo.readValuesFromSerializedString(StrSubstringFrom(LinkString, Length(PARAM_LINK_PROGRAM) + 2));
    ProgramPath := ProgramInfo.get(0);
    ProgramLink := ProgramInfo.get(1);
    TSerializableStringList.destroy;

    // call LaunchProgram here to inherit the environment
    SetStatus( LinkMsg + ' ' + ProgramPath + ' ' + ProgramLink);
  end
  else if StrStartsWith(LinkString, PARAM_LINK_URL) then
  begin
    URL := StrSubstringFrom(LinkString, Length(PARAM_LINK_URL) + 2); //

    SetStatus( LinkMsg + URL );
  end
  else if StrStartsWith(LinkString, PARAM_LINK_EXTERNAL) then
  begin
    LinkDetails := StrSubstringFrom(LinkString, Length(PARAM_LINK_EXTERNAL) + 2);

    tmpLinkDetails := TStringList.Create;
    StrExtractStrings(tmpLinkDetails, LinkDetails, [' '], #0);
    LinkIndex := StrToInt(tmpLinkDetails[0]);
    tmpLinkDetails.Destroy;

    Window := FindWindowFromView( Sender, Windows );
    SourceFile := Window.Topic.HelpFile as THelpFile;
    Filename := SourceFile.ReferencedFiles[ LinkIndex ];
    SetStatus( LinkMsg
               + StrInDoubleQuotes( Filename ) );
  end
  else
  begin
    Window := FindWindowFromView( Sender, Windows );
    LinkIndex := StrToInt( LinkString );
    Link := Window.Topic.Links[ LinkIndex ];

    if Link is TFootnoteHelpLink then
    begin
      SetStatus( FootnoteMsg );
    end
    else
    begin
      LinkedTopic := FindTopicForLink( Link );

      if LinkedTopic <> nil then
      begin
        SetStatus( LinkMsg
                   + StrInDoubleQuotes( Trim( LinkedTopic.Title ) ) );
      end
      else
      begin
        SetStatus( UnknownLinkMsg );
      end;
    end;
  end;
End;

Procedure TMainForm.OnNotOverLink ( Sender: TRichTextView; LinkString: String);
Begin
  SetStatus( '' );
end;

Procedure TMainForm.OnClickLink ( Sender: TRichTextView; LinkString: String);
var
  Link: THelpLink;
  LinkIndex: longint;
  SourceWindow: THelpWindow;
  NoteIndex: longint;
  Window: THelpWindow;
  SourceFile: THelpFile;
  ProgramLink: string;
  ProgramPath: string;
  URL: string;
  LinkDetails: string;
  tmpLinkDetails : TStringList;
  ProgramInfo : TSerializableStringList;
Begin
  LogEvent(LogDebug, 'OnClickLink: "' + LinkString + '"');

  if StrStartsWith(LinkString, PARAM_LINK_NOTE) then
  begin
    NoteIndex := StrToInt(StrSubstringFrom(LinkString, Length(PARAM_LINK_NOTE) + 2) );
    NotesListBox.ItemIndex := NoteIndex;
    EditNote( NoteIndex );
  end
  else if StrStartsWith(LinkString, PARAM_LINK_PROGRAM) then
  begin
    ProgramInfo := TSerializableStringList.create;
    ProgramInfo.readValuesFromSerializedString(StrSubstringFrom(LinkString, 9));
    ProgramPath := ProgramInfo.get(0);
    ProgramLink := ProgramInfo.get(1);
    TSerializableStringList.destroy;

    // call LaunchProgram here to inherit the environment
    LogEvent(LogDisplay, 'LaunchProgram: "' + ProgramPath + '" "' + ProgramLink + '"');
    LaunchProgram(ProgramPath, ProgramLink, '');
    // TODO i18n
    SetStatus( 'Launched ' + ProgramPath );
  end
  else if StrLeft( LinkString, 3 ) = PARAM_LINK_URL then
  begin
    URL := StrSubstringFrom(LinkString, Length(PARAM_LINK_URL) + 2);

    try
      LaunchURL(URL);
    except
      on E:Exception do
      begin
        DoErrorDlg('Error', E.Message);
      end;
      else raise;
    end;

    // TODO i18n
    SetStatus('Opened ' + URL );
  end
  else if StrLeft( LinkString, 8 ) = PARAM_LINK_EXTERNAL then
  begin
    LinkDetails := StrSubstringFrom(LinkString, Length(PARAM_LINK_EXTERNAL) + 2);

    tmpLinkDetails := TStringList.Create;
    StrExtractStrings(tmpLinkDetails, LinkDetails, [' '], #0);
    LinkIndex := StrToInt(tmpLinkDetails[0]);
    tmpLinkDetails.Destroy;

    Window := FindWindowFromView( Sender, Windows );
    SourceFile := Window.Topic.HelpFile as THelpFile;

    g_ExternalLinkFileName := SourceFile.ReferencedFiles[ LinkIndex ];
    g_ExternalLinkTopic := LinkDetails;
    g_ExternalLinkSourceFilename := SourceFile.Filename;
    g_ExternalLinkKeepCurrent := true; // hm... what would be nice?

    PostMsg( Self.Handle,
             WM_FOLLOWEXTERNALLINK,
             0,
             0 );
  end
  else
  begin
    SourceWindow := FindWindowFromView( Sender, Windows );
    LinkIndex := StrToInt( LinkString );
    Link := SourceWindow.Topic.Links[ LinkIndex ];

    PostMsg( Self.Handle,
             WM_FOLLOWLINK,
             longint( Link ),
             longint( SourceWindow ) );

  end;
End;

Procedure TMainForm.OnWindowAboutToClose( Window: THelpWindow;
                                          var CanClose: boolean );
begin
  if Navigating then
    exit;

  UpdateCurrentNavigatePoint; // Save it before close...

  CanClose := true;
end;

Procedure TMainForm.RemoveHelpWindowFromParent( Window: THelpWindow );
var
  ParentWindow: THelpWindow;
  WindowIndex: longint;
Begin
  if Navigating then
    exit;

  if Window.ParentHelpWindow = nil then
  begin
    WindowIndex := Windows.IndexOf( Window );
    Windows.Delete( WindowIndex );
  end
  else
  begin
    ParentWindow := Window.ParentHelpWindow;
    WindowIndex := ParentWindow.ChildWindows.IndexOf( Window );
    ParentWindow.ChildWindows.Delete( WindowIndex );
  end;
end;

Procedure TMainForm.OnWindowClose( Window: THelpWindow );
Begin
  if Navigating then
    exit;

  RemoveHelpWindowFromParent( Window );

  SaveNavigatePoint;
  EnableControls;
End;

Procedure TMainForm.BackButtonOnClick (Sender: TObject);
Begin
  NavigateBack;
End;

Procedure TMainForm.RTViewOnSetupShow (Sender: TObject);
Begin
End;

Procedure TMainForm.ExitMIOnClick (Sender: TObject);
Begin
  Close;
End;

Procedure TMainForm.CreateMRUMenuItems;
var
  MenuItem: TMenuItem;
  i: integer;
  FileName: string;
  FileNameIndex: longint;
  MRUText: string;
  MRUItem: TMRUItem;
begin
  DestroyListObjects( MRUMenuItems );
  MRUMenuItems.Clear;

  // if there are Most Recently Used files
  if Settings.MRUList.Count > 0 then
  begin
    // create a seperator after Exit
    MenuItem:= TMenuItem.Create( self );
    MenuItem.Name := 'MRUSeparatorMI';
    MenuItem.Caption:= '-';
    FileMenu.Add( MenuItem );
    MRUMenuItems.Add( MenuItem );
  end;

  // Add items for the MRU files
  for i:= 0 to Settings.MRUList.Count -1 do
  begin
    MRUItem := Settings.MRUList[ i ];

    MenuItem := TMenuItem.Create( self );

    MenuItem.Name := 'MRUItem' + IntToStr( i ) + 'MI';
    MRUText := MRUItem.Title;
    if Trim( MRUText ) = '' then
    begin
      // Take the filenames, less path, as caption...
      MRUText := '';
      for FileNameIndex := 0 to MRUItem.Filenames.Count - 1 do
      begin
        FileName := MRUItem.Filenames[ FileNameIndex ];
        FileName := ExtractFileName( FileName );
        FileName := ChangeFileExt( FileName, '' );// remove extension

        if FileNameIndex > 0 then
        begin
          MRUText := MRUText + HELP_FILE_DELIMITER;
        end;
        MRUText := MRUText + FileName;

        // stop after 50 chars
        if Length( MRUText ) > 50 then
        begin
          MRUText := MRUText + HELP_FILE_DELIMITER + ' ...';
          break;
        end;
      end;
    end;

    MenuItem.Caption:= '~'
                       + IntToStr( i + 1 )
                       + '. '
                       + MRUText;
    if MRUItem.Filenames.Count = 1 then
      MenuItem.Hint := MRUItem.Filenames[ 0 ]
    else
      MenuItem.Hint := MRUItem.Title
                       + ' ('
                       + IntToStr( MRUItem.Filenames.Count )
                       + ' '
                       + MRUMultipleFilesHint
                       + ')';

    MenuItem.OnClick:= OnMRUMenuItemClick;
    MenuItem.Tag:= i;
    FileMenu.Add( MenuItem );
    MRUMenuItems.Add( MenuItem );
  end;
end;

procedure TMainForm.OnMRUMenuItemClick( Sender: TObject );
var
  Tag: longint;
  MenuItem: TMenuItem;
  MRUItem: TMRUItem;
begin
  MenuItem:= Sender as TMenuItem;
  Tag:= MenuItem.Tag;
  MRUItem := Settings.MRUList[ Tag ];
// RBRi woher kommt die liste?
  if OpenFiles( MRUItem.FileNames, '', true ) then
  begin
    ClearHelpManager;
  end;
end;

Procedure TMainForm.OnNavigateToMenuItemClick( Sender: TObject );
var
  MenuItem: TMenuItem;
  Tag: longint;
begin
  MenuItem:= Sender as TMenuItem;
  Tag:= MenuItem.Tag;
  NavigateToHistoryIndex( Tag );
end;

Procedure TMainForm.AddChildNodes( HelpFile: THelpFile;
                                   ParentNode: TNode;
                                   Level: longint;
                                   Var TopicIndex: longint );
var
  Topic: TTopic;
  Node: TNode;
begin
  assert( ParentNode <> nil );
  Node := nil;
  while TopicIndex < HelpFile.TopicCount do
  begin
    Topic:= HelpFile.Topics[ TopicIndex ];

    if Topic.ShowInContents then
    begin
      if Topic.ContentsLevel < Level then
        break;

      if Topic.ContentsLevel = Level then
      begin
        Node:= ParentNode.AddChild( Topic.Title,
                                    Topic );
        inc( TopicIndex );
      end
      else
      begin
        assert( Node <> nil );
        AddChildNodes( HelpFile,
                       Node,
                       Topic.ContentsLevel,
                       TopicIndex );
        Node := nil;
      end
    end
    else
    begin
      inc( TopicIndex );
    end;
  end;

end;

Procedure TMainForm.LoadContents( Files: TList;
                                  Var FirstNode: TNode );
var
  TopicIndex: longint;
  Topic: TTopic;
  Node: TNode;
  FileIndex: longint;
  HelpFile: THelpFile;
begin
  ContentsOutline.BeginUpdate;
  LogEvent(LogStartup, 'Load contents outline');

  // we don't clear it first, to allow adding additional files
  // into the contents tree

  LogEvent(LogStartup, 'Loop files');

  FirstNode := nil;

  Node := nil;

  for FileIndex:= 0 to Files.Count - 1 do
  begin
    HelpFile := Files[ FileIndex ];
    LogEvent(LogStartup, 'File ' + IntToStr( FileIndex ) );
    TopicIndex := 0;
    while TopicIndex < HelpFile.TopicCount do
    begin
      Topic := HelpFile.Topics[ TopicIndex ];
      assert( Topic.ContentsLevel >= 0,
              'Topic contents level is ' + IntToStr( Topic.ContentsLevel ) );
      if Topic.ShowInContents then
      begin
        if Topic.ContentsLevel = 1 then
        begin
          Node := ContentsOutline.AddChild( Topic.Title,
                                            Topic );
          if FirstNode = nil then
            FirstNode := node;

          inc( TopicIndex );
        end
        else
        begin
          // subnodes
          assert( Node <> nil, 'No level 1 topic for subnodes!' );
          AddChildNodes( HelpFile,
                         Node,
                         Topic.ContentsLevel,
                         TopicIndex );
          Node := nil;
        end;
      end
      else
      begin
        inc( TopicIndex );
      end;
    end;
  end;
  LogEvent(LogStartup, '  EndUpdate' );
  ContentsOutline.EndUpdate;

  if Settings.OpenWithExpandedContents then
  begin
    LogEvent(LogStartup, '  Expand all contents' );
    ContentsOutline.ExpandAll
  end
  else if ContentsOutline.ChildCount = 1 then
  begin
    LogEvent(LogStartup, '  Expand first node' );
    // Contents has only one top level node... expand it
    FirstNode.Expand;
  end;

  ContentsLoaded := true;
  LogEvent(LogStartup, '  Contents loaded' );

end;

Procedure TMainForm.SaveNotesForFile( HelpFile: THelpFile );
var
  NotesFileName: string;
  TopicIndex: longword;
  Note: THelpNote;
  NoteIndex: longint;

  NotesFile: HFile;
  OpenAction: ULong;
  rc: APIRET;
  CName: Cstring;
  FileNoteCount: integer;

begin
  LogEvent(LogStartup, 'Save notes for ' + HelpFile.Filename );

  if not HelpFile.NotesLoaded then
    // we never loaded the notes/displayed a topic from this file
    // so don't do anything.
    exit;

  LogEvent(LogStartup, 'Really saving' );

  NotesFileName := ChangeFileExt( HelpFile.FileName, '.nte' );

  FileNoteCount := 0;
  for  NoteIndex := 0 to Notes.Count - 1 do
  begin
    Note := Notes[ NoteIndex ];

    if Note.Topic.HelpFile = HelpFile then
      inc( FileNoteCount );
  end;

  if FileNoteCount = 0 then
  begin
    // no notes. delete notes file if it already exists.
    if FileExists( NotesFileName ) then
      DeleteFile( NotesFileName );
    exit;
  end;

  CName:= NotesFileName;
  rc:= DosOpen( CName,
                NotesFile,
                OpenAction,
                0, // file size
                0, // attrs
                OPEN_ACTION_CREATE_IF_NEW + OPEN_ACTION_REPLACE_IF_EXISTS,
                OPEN_SHARE_DENYREADWRITE + OPEN_ACCESS_WRITEONLY,
                nil ); // no eas
  if rc <> 0 then
  begin
    DoErrorDlg( SaveNotesTitle,
                SaveNotesError
                + StrCRLF
                + NotesFileName
                + StrCRLF
                + SysErrorMessage( rc ) );
    exit;
  end;

  for  NoteIndex:= 0 to Notes.Count - 1 do
  begin
    Note:= Notes[ NoteIndex ];

    if Note.Topic.HelpFile <> HelpFile then
      continue;

    TopicIndex:= HelpFile.IndexOfTopic( Note.Topic );

    MyWriteLn( NotesFile,
               IntToStr( TopicIndex ));
    MyWriteLn( NotesFile,
               IntToStr( Note.InsertPoint ) );

    MyWrite( NotesFile,
             Note.Text.AsPChar,
             Note.Text.Length );

    MyWriteLn( NotesFile,
               '' );
    MyWriteLn( NotesFile,
               '#ENDNOTE#' );

  end;

  DosClose( NotesFile );
end;

Procedure TMainForm.LoadNotes( HelpFile: THelpFile );
var
  NotesFileName: string;
  TopicIndex: longint;
  InsertPoint: longint;
  Note: THelpNote;

  NotesFile: HFile;
  OpenAction: ULong;
  rc: APIRET;
  CName: Cstring;

  Paragraph: TAString;
  NotEOF: boolean;
  NoteText: TAString;

begin
  LogEvent(LogStartup, 'Load notes for ' + HelpFile.Filename );

  if HelpFile.NotesLoaded then
    exit;

  HelpFile.NotesLoaded := true;
  NotesFileName := ChangeFileExt( HelpFile.FileName, '.nte' );

  if not FileExists( NotesFileName ) then
    // no notes
    exit;

  CName := NotesFileName;
  rc := DosOpen( CName,
                 NotesFile,
                 OpenAction,
                 0, // file size - irrelevant, not creating,
                 0, // attrs - ''
                 OPEN_ACTION_OPEN_IF_EXISTS,
                 OPEN_SHARE_DENYREADWRITE + OPEN_ACCESS_READONLY,
                 nil ); // no eas
  if rc <> 0 then
  begin
    DoErrorDlg( LoadNotesTitle,
                LoadNotesError
                + StrCRLF
                + NotesFileName
                + StrCRLF
                + SysErrorMessage( rc ) );
    exit;
  end;

  Paragraph := TAString.Create;
  NoteText := TAString.Create;

  NotEOF := true;

  while NotEOF do
  begin
    // Read contents index
    NotEOF := Paragraph.ReadParagraph( NotesFile );
    if not NotEOF then
      continue;
    try
      TopicIndex := StrToInt( Paragraph.AsString );
    except
      TopicIndex := -1;
    end;

    // Read insert point
    NotEOF := Paragraph.ReadParagraph( NotesFile );
    if not NotEOF then
      continue;
    try
      InsertPoint := StrToInt( Paragraph.AsString );
    except
      InsertPoint := -1;
    end;

    NoteText.Clear;

    while NotEOF do
    begin
      NotEOF := Paragraph.ReadParagraph( NotesFile );
      if Paragraph.SameAs( '#ENDNOTE#' ) then
      begin
        // found end of note
        if     ( TopicIndex >= 0 )
           and ( InsertPoint >= 0 ) then
        begin
          Note := THelpNote.Create;
          Note.Topic := HelpFile.Topics[ TopicIndex ];
          Note.InsertPoint := InsertPoint;

          // Remove the last end line
          Note.Text.Assign( NoteText );
          if Note.Text.Length > 2 then
            Note.Text.Delete( Note.Text.Length - 2, 2 );

          Notes.Add( Note );
        end;
        break;
      end;
      NoteText.Add( Paragraph );
      NoteText.AddString( #13 + #10 );
    end;

  end;
  DosClose( NotesFile );

  Paragraph.Destroy;
  NoteText.Destroy;

end;

Procedure TMainForm.UpdateNotesDisplay;
var
  NoteIndex: longint;
  Note: THelpNote;
  NoteTitle: string;
begin
  NotesListBox.Clear;
  for NoteIndex := 0 to Notes.Count - 1 do
  begin
    Note := Notes[ NoteIndex ];

    if Note.Topic > nil then
      NoteTitle := Note.Topic.Title
    else
      NoteTitle := StrLeft( Note.Text.AsString, 100 );
    NotesListBox.Items.AddObject( NoteTitle,
                                  Note );
  end;
  EnableNotesControls;
end;

Procedure TMainForm.EnableNotesControls;
var
  NoteSelected: boolean;
begin
  NoteSelected:= NotesListBox.ItemIndex <> -1;
  EditNoteButton.Enabled:= NoteSelected;
  GotoNoteButton.Enabled:= NoteSelected;
  DeleteNoteButton.Enabled:= NoteSelected;
  AddNoteButton.Enabled := CurrentOpenFiles.Count > 0;
end;

Function TMainForm.OKToCloseFile: boolean;
begin
  Result := true;

  if PrintThread = nil then
    // haven't used print thread yet
    exit;

  if not PrintThread.IsRunning then
    // not currently running
    exit;

  Result := DoConfirmDlg( CheckStopPrintTitle,
                          CheckStopPrintMsg );

end;

Procedure TMainForm.StopPrinting;
begin
  if PrintThread <> nil then
  begin
    if PrintThread.IsRunning then
    begin
      SetStatus( StoppingPrintMsg );
      PrintThread.ForceStop( 5 );  // wait up to 5 seconds then terminate
      SetStatus( PrintStoppedMsg );
      ResetProgress;
    end;
  end;
end;

Procedure TMainForm.CloseFile;
var
  FileIndex: longint;
  HelpFile: THelpFile;
  M1: longint;
begin
  StopPrinting;

  LogEvent(LogShutdown, 'Set Caption' );
  MainTitle := '';
  SetMainCaption;

  LogEvent(LogShutdown, 'Close Windows' );
  CloseWindows;

  LogEvent(LogShutdown, 'Set selected node to nil' );
  ContentsOutline.SelectedNode:= Nil;

  M1:= MemAvail;

  LogEvent(LogShutdown, 'Clear contents outline' );
  ContentsOutline.Clear;

  LogEvent(LogShutdown, 'Free contents: ' + IntToStr( MemAvail - M1 ) );
  M1:= MemAvail;

  DisplayedIndex.Clear;
  IndexListBox.Clear;
  LogEvent(LogShutdown, 'Clear index ' + IntToStr( MemAvail - M1 ) );
  M1:= MemAvail;

  NotesListBox.Clear;
  SearchResultsListBox.Clear;

  LogEvent(LogShutdown, 'Notes, search etc ' + IntToStr( MemAvail - M1 ) );
  M1:= MemAvail;

  // First save notes and bookmarks.
  // It's important we do this first
  // since we scan all notes each time to find the ones
  // belonging to this file.
  SaveBookmarks;

  SaveNotes;

  ClearAllWordSequences;

  LogEvent(LogShutdown, 'Destroy helpfile objects' );

  // Now destroy help files
  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    HelpFile := CurrentOpenFiles[ FileIndex ];
    GlobalFilelist.RemoveFile( Frame.Handle,
                               HelpFile.Filename );
    HelpFile.Free;
  end;

  CurrentOpenFiles.Clear;

  LogEvent(LogShutdown, 'Destroy helpfiles ' + IntToStr( MemAvail - M1 ) );
  M1 := MemAvail;

  LogEvent(LogShutdown, 'Clear notes' );
  ClearNotes;

  LogEvent(LogShutdown, 'Clear bookmarks' );
  ClearBookmarks;

  ClearPageHistory;

  LogEvent(LogShutdown, 'Enable controls' );
  EnableControls;

  LogEvent(LogShutdown, 'CloseFile done' );

end;

Function TMainForm.FindOpenHelpFile( FileName: string ): THelpFile;
var
  FileIndex: longint;
begin
  for FileIndex:= 0 to CurrentOpenFiles.Count - 1 do
  begin
    Result:= CurrentOpenFiles[ FileIndex ];
    if StrEqualIgnoringCase( Result.Filename, FileName ) then
      // found
      exit;
  end;
  Result:= nil;
end;

// This rather horrendous looking bit of code simply:

// Gets the contents from each file
// Sorts it alphabetically.
// Merges all the sorted contents and indexes together,
// alphabetically.
type
  TListType = ( ltContents, ltIndex );

procedure TMainForm.LoadIndex;
var
  tmpHelpFile: THelpFile;
  tmpTextCompareResult: integer;

  FileIndex: longint;

  Contents: TList;
  ContentsLists: TList; // of tlist
  tmpIndexLists: TList; // of tstringlist
  ContentsNextIndex: array[ 0..255 ] of longint;
  IndexNextIndex: array[ 0..255 ] of longint;
  Topic: TTopic;

  pListEntry: pstring;
  pLowestEntry: pstring;
  pLastEntry: pstring;

  tmpLowestEntryListIndex: longint;
  tmpLowestEntryListType: TListType;
  tmpLowestEntryTopic: TTopic;

  tmpIndex: TStringList;

  i : longint;
begin
  LogEvent(LogStartup, 'Create index' );

  SetWaitCursor;

  LogEvent(LogStartup, '  Get/sort lists' );

  ProgressBar.Position := 70;
  SetStatus( 'Building index... ' );

  ContentsLists := TList.Create;
  tmpIndexLists := TList.Create;

  // collect the contents and index lists from the files
  for FileIndex := 0 to CurrentOpenFiles.Count - 1 do
  begin
    tmpHelpFile := CurrentOpenFiles[ FileIndex ];
    ProgressBar.Position := 70 + 10 * FileIndex div CurrentOpenFiles.Count;

    if Settings.IndexStyle in [ isAlphabetical, isFull ] then
    begin
      Contents := TList.Create;
      Contents.Capacity := tmpHelpFile.TopicCount;

      // copy [contents] topic list
      for i := 0 to tmpHelpFile.TopicCount - 1 do
      begin
        Topic := tmpHelpFile.Topics[ i ];
        if Topic.ShowInContents then
          Contents.Add( Topic );
      end;

      // sort by title
      Contents.Sort( TopicTitleCompare );

      ContentsLists.Add( Contents );

      // initialise list index
      ContentsNextIndex[ ContentsLists.Count - 1 ] := 0;
    end;

    if Settings.IndexStyle in [ isFileOnly, isFull ] then
    begin
      tmpIndexLists.Add(tmpHelpFile.Index.GetLabels);
      IndexNextIndex[ tmpIndexLists.Count - 1 ] := 0;
    end;
  end;

  // Unlike contents, we do clear the index
  // (even if we are adding more files) because we need
  // to re-merge the whole thing
  DisplayedIndex.Clear;
  ProgressBar.Position := 80;

  LogEvent(LogStartup, '  Merge lists' );

  pLastEntry := NullStr;
  while true do
  begin
    pLowestEntry := NullStr;
    tmpLowestEntryListIndex := -1;

    // Find alphabetically lowest (remaining) topic

    // first, look in contents lists
    LogEvent(LogDebug, '  Merge contents' );
    for i := 0 to ContentsLists.Count - 1 do
    begin
      Contents := ContentsLists[i];
      if ContentsNextIndex[i] < Contents.Count then
      begin
        // list is not yet finished, get next entry
        Topic := Contents[ ContentsNextIndex[i] ];
        pListEntry := Topic.TitlePtr;

        if pLowestEntry^ <> '' then
          tmpTextCompareResult := CompareText( pListEntry^, pLowestEntry^ )
        else
          tmpTextCompareResult := -1;

        if tmpTextCompareResult < 0 then
        begin
          // this index entry comes before the lowest one so far
          pLowestEntry := pListEntry;
          tmpLowestEntryListIndex := i;
          tmpLowestEntryListType := ltContents;
          tmpLowestEntryTopic := Topic;
        end;
      end;
    end;

    // look in indices
    LogEvent(LogDebug, '  Merge indices' );
    for i := 0 to tmpIndexLists.Count - 1 do
    begin
      LogEvent(LogDebug, '  Merge indices ' + IntToStr(i) );
      tmpIndex := tmpIndexLists[i];
      if IndexNextIndex[i] < tmpIndex.Count then
      begin
        // list is not yet finished, get next entry
        pListEntry := tmpIndex.ValuePtrs[ IndexNextIndex[i] ];

        if pLowestEntry^ <> '' then
          tmpTextCompareResult := CompareText( pListEntry^, pLowestEntry^ )
        else
          tmpTextCompareResult := -1;

        if tmpTextCompareResult < 0 then
        begin
          // this index entry comes before the lowest one so far
          pLowestEntry := pListEntry;
          tmpLowestEntryListIndex := i;
          tmpLowestEntryListType := ltIndex;

          LogEvent(LogDebug, '  Merge indices ' + tmpIndex.Objects[ IndexNextIndex[i] ].ClassName);
          tmpLowestEntryTopic := TIndexEntry( tmpIndex.Objects[ IndexNextIndex[i] ] ).getTopic;
        end;
      end;
    end;

    if tmpLowestEntryListIndex = -1 then
      // we're out
      break;

    if ( pLowestEntry^ ) <> ( pLastEntry^ ) then
      // add, if different from last
      DisplayedIndex.AddObject( pLowestEntry^, tmpLowestEntryTopic );
    pLastEntry := pLowestEntry;

    if tmpLowestEntryListType = ltContents then
    begin
      inc( ContentsNextIndex[ tmpLowestEntryListIndex ] );
    end
    else
    begin
      // found in one of indices.
      // Check for subsequent indented strings
      tmpIndex := tmpIndexLists[ tmpLowestEntryListIndex ];

      i := IndexNextIndex[ tmpLowestEntryListIndex ] + 1;
      while i < tmpIndex.Count do
      begin
        pListEntry := tmpIndex.ValuePtrs[ i ];
        if pListEntry^ = '' then
          break;

        if pListEntry^[ 1 ] <> ' ' then
          // not indented, stop looking
          break;

        // found one,
        Topic := TIndexEntry(tmpIndex.Objects[ i ]).getTopic;
        DisplayedIndex.AddObject( pListEntry^,
                                  Topic );
        inc( i );
      end;
      IndexNextIndex[ tmpLowestEntryListIndex ] := i;
    end;
  end;

  ProgressBar.Position := 95;
  LogEvent(LogStartup, '  Display index (count = '
                + IntToStr( DisplayedIndex.Count )
                + ')' );

  // Now display the final index list
  IndexListBox.Items.Assign( DisplayedIndex );

  LogEvent(LogStartup, '  Tidy up' );

  tmpIndexLists.Destroy;

  DestroyListAndObjects( ContentsLists );

  IndexLoaded := true;

  ClearWaitCursor;

  SetStatus( 'Index loaded' );
  LogEvent(LogStartup, '  Done' );
end;

Procedure TMainForm.OnHelpFileLoadProgress( n, outof: integer;
                                            message: string );
var
  ProgressOnFiles: longint;
  Filename: string;
  ProgressOnThisFile: longint;

begin
  Filename := LoadingFilenameList[ LoadingFileIndex ];

  ProgressOnFiles := round( 100 * LoadingFileIndex / LoadingFilenameList.Count );
  ProgressOnThisFile := round( 100 * n / outof / LoadingFilenameList.Count );

  SetProgress( ( ProgressOnFiles + ProgressOnThisFile ) div 2,
               100,
               LoadingFileMsg
               + ExtractFileName( Filename )
               + ': '
               + message );
end;

Procedure TMainForm.SetProgress( n, outof: integer;
                                 message: string );
begin
  ProgressBar.Position := n * 100 div outof;
  SetStatus( message );
  ProgressBar.Show;
end;

// Load a single file.
Function TMainForm.OpenFile( const FileName: string;
                             const WindowTitle: string;
                             const SelectFirstContentsNode: boolean ): boolean;
var
  tmpFileNames: TStringList;
begin
  tmpFileNames := TStringList.Create;
  ParseAndExpandFileNames(FileName, tmpFileNames);
  Result := OpenFiles( tmpFileNames,
                       WindowTitle,
                       DisplayFirstTopic );
  tmpFileNames.Destroy;
end;

Function TMainForm.OpenAdditionalFile( const FileName: string;
                                       const DisplayFirstTopic: boolean ): boolean;
var
  tmpFileNames: TStringList;
begin
  tmpFileNames := TStringList.Create;
  ParseAndExpandFileNames(FileName, tmpFileNames);
  Result := OpenAdditionalFiles(tmpFileNames, DisplayFirstTopic );
  tmpFileNames.Destroy;
end;

Function TMainForm.OpenWindowsHelp( const Filename: string ): boolean;
var
  WinHelpDetails: PROGDETAILS;
  szFilename: cstring;
begin

  result := true;
  if Settings.ConfirmWinHelp then
    result := DoYesNoDlg( WindowsHelpTitle,
                          WindowsHelpPrompt
                          + StrCRLF
                          + FileName );
  if not result then
    exit;

  szFilename := FileName;
  with WinHelpDetails do
  begin
    Length := sizeof( WinHelpDetails );
    progt.progc := PROG_31_ENHSEAMLESSCOMMON ;
    progt.fbVisible := SHE_VISIBLE;
    pszTitle := ''; // not used?
    pszExecutable := 'winhelp.exe';
    pszParameters := Addr( szFilename );
    pszStartupDir := nil;
    pszIcon := nil;
    pszEnvironment := nil;
    swpInitial.fl := SWP_ACTIVATE or SWP_SHOW;
  end;

  result := WinStartApp( NULLHANDLE,
                         WinHelpDetails,
                         '',
                         nil,
                         SAF_INSTALLEDCMDLINE ) <> 0;

  // Doesn't work for Dos/Win programs
  // RunProgram( 'winhelp.exe', FileName );
end;

// Load the specified set of help files
Function TMainForm.LoadFiles(const aFileNames: TStrings; aHelpFiles: TList) : boolean;
var
  HelpFile: THelpFile;
  FileIndex, i: longint;
  FileName: string;
  FullFilePath: string;

  FileHandlesAdjustNum: LONG;
  CurrentMaxFileHandles: ULONG;
  RequiredFileHandles: LONG;
begin
  LogEvent(LogStartup, 'LoadFiles' );

  LoadingFilenameList := TStringList.Create;

// RBRi  TranslateIPFEnvironmentVars( FileNames, LoadingFilenameList );
  for i := 0 to aFileNames.Count - 1 do
  begin
    LoadingFilenameList.Add(aFileNames[i]);
  end;

  LogEvent(LogStartup, 'Finding files' );

  ProgressBar.Show;

  // now find full file paths,
  // and also the total file size for progress display
  for FileIndex := 0 to LoadingFilenameList.Count - 1 do
  begin
    FileName := LoadingFilenameList[ FileIndex ];
    LogEvent(LogStartup, '  File: ' + FileName );

    // Find the help file, if possible
    if Filename = OWN_HELP_MARKER then
    begin
      FullFilePath := CmdLineParameters.GetOwnHelpFileName;
    end
    else
    begin
      FullFilePath := FindHelpFile( Filename );
    end;

    if FullFilePath <> '' then
    begin
      LogEvent(LogStartup, '    Full path: ' + FullFilePath );
    end
    else
    begin
      LogEvent(LogStartup, '    File not found' );
      FullFilePath := FileName; // we'll complain later.
    end;
    LoadingFilenameList[ FileIndex ] := FullFilePath;
  end;

  // Make sure we have enough file handles

  FileHandlesAdjustNum := 0;
  DosSetRelMaxFH( FileHandlesAdjustNum, // 0 queries current
                  CurrentMaxFileHandles );

  RequiredFileHandles := CurrentOpenFiles.Count // already opened
                         + LoadingFilenameList.Count // new ones
                         + 40; // some spares.
  if CurrentMaxFileHandles < RequiredFileHandles then
  begin
    // need some more
    FileHandlesAdjustNum := RequiredFileHandles - CurrentMaxFileHandles;
    DosSetRelMaxFH( FileHandlesAdjustNum,
                    CurrentMaxFileHandles );
  end;

  // Now actually load the files
  for FileIndex := 0 to LoadingFilenameList.Count - 1 do
  begin
    Filename := LoadingFilenameList[ FileIndex ];
    LogEvent(LogStartup, '  Loading: ' + Filename );
    try
      LoadingFileIndex := FileIndex;

      // load the file
      HelpFile := THelpFile.Create( FileName );
      if Settings.FixedFontSubstitution then
         HelpFile.SetupFontSubstitutes( Settings.FixedFontSubstitutes );

      aHelpFiles.Add( HelpFile );

    except
      on E: Exception do
      begin

        if E is EWindowsHelpFormatException then
        begin
          OpenWindowsHelp( Filename );
        end
        else
        begin
          DoErrorDlg( FileOpenTitle,
                      HelpFileError
                      + FileName
                      + ': '
                      + E.Message );
        end;

        // back out of the load process
        Result := false;

        DestroyListObjects( aHelpFiles );

        LoadingFilenameList.Destroy;
        ResetProgress;
        exit;
      end
    end;
  end;

  LoadingFilenameList.Destroy;

  Result := true;

end;

// Add the current list of open files as
// a Most Recently Used entry
Procedure TMainForm.AddCurrentToMRUFiles;
var
  tmpFilenames: TStringList;
  i: longint;
  tmpHelpFile: THelpFile;
begin
  tmpFilenames := TStringList.Create;

  if CurrentOpenFiles.Count > 0 then
  begin
    for i := 0 to CurrentOpenFiles.Count - 1 do
    begin
      tmpHelpFile := CurrentOpenFiles[ i ];
      tmpFilenames.Add(tmpHelpFile.Filename);
    end;

    // update most-recently-used file list
    tmpHelpFile := CurrentOpenFiles[ 0 ];
    AddToMRUList(tmpHelpFile.Title, tmpFilenames);
  end;

  // recreate menu
  CreateMRUMenuItems;

  tmpFilenames.Destroy;
end;

// Display the specified set of files
Procedure TMainForm.DisplayFiles( NewFiles: TList;
                                  Var FirstContentsNode: TNode );
var
  HelpFile: THelpFile;
  FileIndex: longint;
begin
  LogEvent(LogStartup, 'DisplayFiles' );
  // Now load the various parts of the file(s)
  // into the user interface
  ProgressBar.Position := 50;
  SetStatus( LoadingStatusDisplaying );

  // Add our open files in the global filelist
  for FileIndex := 0 to NewFiles.Count - 1 do
  begin
    HelpFile := NewFiles[ FileIndex ];
    GlobalFilelist.AddFile( HelpFile.Filename, Frame.Handle );
    // LoadNotes( HelpFile );
    LoadBookmarks( HelpFile );
  end;

  UpdateNotesDisplay;

  BuildBookmarksMenu;
  UpdateBookmarksForm;

  ProgressBar.Position := 55;

  ContentsLoaded := false;
  IndexLoaded := false;

  LoadContents( NewFiles, FirstContentsNode );

  ProgressBar.Position := 75;

  // LoadIndex;

  ProgressBar.Position := 100;
  SetStatus( LoadingStatusDone );

  LogEvent(LogStartup, 'DisplayFiles Done' );

end;

Function TMainForm.OpenFiles( const FileNames: TStrings;
                              const WindowTitle: string;
                              const DisplayFirstTopic: boolean ): boolean;
var
  tmpHelpFiles: TList;
  FirstContentsNode: TNode;
begin
  LogEvent(LogStartup, 'OpenFiles' );

  if not OKToCloseFile then
    exit;

  SetWaitCursor;

  tmpHelpFiles := TList.Create;

// RBRi Translate
  if not LoadFiles(FileNames, tmpHelpFiles) then
  begin
    ClearWaitCursor;
    tmpHelpFiles.Destroy;
    exit;
  end;

  Result := true;

  SearchResultsListBox.Clear;
  PageHistory.Clear;
  CurrentHistoryIndex := -1;

  // Now that we have successfully loaded the new help file(s)
  // close the existing one.
  CloseFile;

  AssignList(tmpHelpFiles, CurrentOpenFiles );

  ProgressBar.Position := 50;
  SetStatus( LoadingStatusDisplaying );

  AddCurrentToMRUFiles;

  if WindowTitle = '' then
    MainTitle := THelpFile( CurrentOpenFiles[ 0 ] ).Title
  else
    MainTitle := WindowTitle;

  SetMainCaption;

  // Now load the various parts of the file(s)
  // into the user interface

  ContentsOutline.Clear;

  DisplayFiles( tmpHelpFiles,
                FirstContentsNode );

  if CmdLineParameters.getHelpManagerFlag then
    ShowLeftPanel := Settings.ShowLeftPanel_Help
  else
    ShowLeftPanel := Settings.ShowLeftPanel_Standalone;

  // Select first contents node if there is one
  if FirstContentsNode <> nil then
  begin
    LogEvent(LogStartup, '  Select first node' );
    ContentsOutline.SelectedNode := FirstContentsNode;
  end;

  ClearWaitCursor;

  ResetProgress;

  NotebookOnPageChanged( self ); // ensure e.g. index loaded

  EnableControls;

  if DisplayFirstTopic then
  begin
    LogEvent(LogStartup, 'Display first topic' );
    DisplaySelectedContentsTopic;
  end;

  LogEvent(LogStartup, 'OpenFiles complete' );
end;

Function TMainForm.OpenAdditionalFiles( const FileNames: TStrings;
                                        const DisplayFirstTopic: boolean ): boolean;
var
  HelpFiles: TList;
  FirstNewContentsNode: TNode;
begin
  LogEvent(LogStartup, 'OpenAdditionalFiles' );

  if not OKToCloseFile then
    exit;

  SetWaitCursor;

  HelpFiles := TList.Create;

  if not LoadFiles( FileNames,
                    HelpFiles ) then
  begin
    ClearWaitCursor;
    HelpFiles.Destroy;
    exit;
  end;

  Result := true;

  AddList( HelpFiles, CurrentOpenFiles );

  AddCurrentToMRUFiles;

  DisplayFiles( HelpFiles,
                FirstNewContentsNode );

  // Select first contents node of new file
  if FirstNewContentsNode <> nil then
    ContentsOutline.SelectedNode := FirstNewContentsNode;

  HelpFiles.Destroy;

  ClearWaitCursor;

  ResetProgress;

  EnableControls;

  if DisplayFirstTopic then
    DisplaySelectedContentsTopic;

  LogEvent(LogStartup, 'OpenAdditionalFiles complete' );
end;

Procedure TMainForm.OpenMIOnClick (Sender: TObject);
Begin
  FileOpen;
end;

procedure TMainForm.FileOpen;
var
  Filenames: TStringList;
  KeepCurrentFiles: boolean;
  OpenedOK: boolean;
begin
  if not OKToCloseFile then
    exit;

  if Settings.UseOriginalDialogs then
  begin
    SystemOpenDialog.Filename := AddDirectorySeparator( Settings.LastOpenDirectory ) + '*.hlp;*.inf';
    if not SystemOpenDialog.Execute then
      exit;

    Settings.LastOpenDirectory := ExtractFilePath( SystemOpenDialog.Filename );
    // note - sibyl's encapsulation doesn't allow multi-select
    OpenedOK := OpenFile( SystemOpenDialog.FileName, '', true );
  end
  else
  begin
    Filenames := TStringList.Create;
    KeepCurrentFiles := false;
    if not DoOpenMultiFileDialog( FileOpenTitle,
                                  HelpFilesDesc
                                  + '|*.inf;*.hlp|'
                                  + AllFilesDesc
                                  + '|*.*',
                                  '*.hlp;*.inf',
                                  Settings.LastOpenDirectory,
                                  KeepCurrentFiles,
                                  Filenames ) then
      exit;

    // no ParseAndExpandFileNames call required here
    // this is the result of a file dialog
    // no environment vars here
    if KeepCurrentFiles then
      OpenedOK := OpenAdditionalFiles( FileNames, true )
    else
      OpenedOK := OpenFiles( FileNames, '', true );
    Filenames.Destroy;
  end;

  if OpenedOK  then
    ClearHelpManager;
End;

Procedure TMainForm.CloseWindows;
Begin
  DestroyListObjects( Windows );
  Windows.Clear;
end;

// Help manager mode

// if window is minimised then restore it
// (ideally should go back to maximized - don't know how)
Procedure TMainForm.RestoreWindow;
Begin
  If WindowState = wsMinimized then
    WindowState := wsNormal;
end;


Procedure TMainForm.NHMDisplayIndex( Var Msg: TMessage );
begin
  LogEvent(LogNHM, 'NHMDisplayIndex');
  CmdLineParameters.addNhmDebugMessage('NHMDisplayIndex');
  RestoreWindow;
  DisplayIndex;
  // if nothing is being display already...
  if Windows.Count = 0 then
    // display first topic
    DisplaySelectedContentsTopic;
end;

Procedure TMainForm.NHMDisplayContents( Var Msg: TMessage );
begin
  LogEvent(LogNHM, 'NHMDisplayContents');
  CmdLineParameters.addNhmDebugMessage('NHMDisplayContents');
  RestoreWindow;
  DisplayContents;
  // if nothing is being display already...
  if Windows.Count = 0 then
  begin
    // display first topic
    DisplaySelectedContentsTopic;
  end;
end;

Procedure TMainForm.NHMTopicByResourceID( Var Msg: TMessage );
begin
  LogEvent(LogNHM, 'NHMTopicByResourceID');
  RestoreWindow;
  if ShowLeftPanel then
  begin
    DisplayContents;
  end;
  CmdLineParameters.addNhmDebugMessage('NHMTopicByResourceID ' + IntToStr(Msg.Param1));
  DisplayTopicByResourceID( Msg.Param1 );
end;

Procedure TMainForm.NHMTopicByPanelName( Var Msg: TMessage );
var
  pMessageMem: pchar;
  PanelName: string;
  Topic: TTopic;
begin
  LogEvent(LogNHM, 'NHMTopicByPanelName');
  RestoreWindow;
  if ShowLeftPanel then
    DisplayContents;

  pMessageMem := pchar( Msg.Param1 );
  PanelName := StrPas( pMessageMem );
  SharedMemory.Free( pMessageMem );

  LogEvent(LogNHM, '....NHMTopicByPanelName panel:' + PanelName);
  CmdLineParameters.addNhmDebugMessage('NHMTopicByPanelName ' + PanelName);
  Topic := FindTopicByName( PanelName );
  if Topic = nil then
    Topic := FindTopicByGlobalName( PanelName );

  if Topic <> nil then
    DisplayTopic( Topic )
  else
    SearchFor( PanelName );
end;

// Sent from other instances starting up (and exiting immediately)

Procedure TMainForm.NHMSearch( Var Msg: TMessage );
var
  pSearchText: pchar;
  tmpSearchText : String;
begin
  LogEvent(LogNHM, 'NHMSearch');
  RestoreWindow;

  pSearchText := pstring( Msg.Param1 );
  tmpSearchText := StrPas(pSearchText);
  CmdLineParameters.addNhmDebugMessage('NHMSearch ' + tmpSearchText);
  SearchFor(tmpSearchText);
  SharedMemory.Free( pSearchText );
end;

Procedure TMainForm.NHMGlobalSearch( Var Msg: TMessage );
var
  pSearchText: pchar;
  tmpSearchText : String;
begin
  LogEvent(LogNHM, 'NHMGlobalSearch');
  RestoreWindow;

  pSearchText := pstring( Msg.Param1 );
  tmpSearchText := StrPas(pSearchText);
  CmdLineParameters.addNhmDebugMessage('NHMGlobalSearch ' + tmpSearchText);
  DoGlobalSearch(tmpSearchText);
  SharedMemory.Free( pSearchText );
end;

Procedure TMainForm.NHMShowUsage( Var Msg: TMessage );
begin
  LogEvent(LogNHM, 'NHMShowUsage');
  CmdLineParameters.addNhmDebugMessage('NHMShowUsage');
  RestoreWindow;
  ShowUsage;
end;

Procedure TMainForm.NHMSetFiles( Var Msg: TMessage );
var
  pFileNames: pchar;
  tmpFileNames : String;
begin
  LogEvent(LogNHM, 'NHMSetFiles');

  // NOT restoring window here because this is not something the user should see...
  pFileNames := pstring( Msg.Param1 );
  tmpFileNames := StrPas(pFileNames);
  CmdLineParameters.addNhmDebugMessage('NHMSetFiles ' + tmpFileNames);
  OpenFilesFromTextList(tmpFileNames, false);
  SharedMemory.Free( pFileNames );
end;

Procedure TMainForm.NHMSetTitle( Var Msg: TMessage );
var
  pTitle: pchar;
begin
  LogEvent(LogNHM, 'NHMSetTitle');

  pTitle := pstring( Msg.Param1 );
  MainTitle := StrPas( pTitle );
  SharedMemory.Free( pTitle );
  CmdLineParameters.addNhmDebugMessage('NHMSetTitle ' + MainTitle);
  SetMainCaption;
end;

Procedure TMainForm.NHMTest( Var Msg: TMessage );
var
  ps: pstring;
begin
  LogEvent(LogNHM, 'NHMTest');
  ps := PString( Msg.Param1 );
  ShowMessage( 'Got test message: ' + ps^ );
  SharedMemory.Free( ps );
end;

Initialization
  RegisterClasses ([TMainForm, TSplitBar,
    TNoteBook,
    TEdit, TListBox,
    TRichTextView, TCoolBar2, TMainMenu, TMenuItem,
    TImageList, TPanel, TButton,
    TSystemOpenDialog, TOutline2, TCustomListBox, TPopupMenu, TSpeedButton
   , TProgressBar, TTabSet2]);
End.
