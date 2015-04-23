Unit BookmarksFormUnit;

// NewView - a new OS/2 Help Viewer
// Copyright 2003 Aaron Lawrence (aaronl at consultant dot com)
// This software is released under the Gnu Public License - see readme.txt

Interface

Uses
  Classes,
  Forms,
  StdCtrls,
  Buttons,
  ACLLanguageUnit,
  MiscUnit;

Type
  TBookmarkCallback = procedure( Bookmark: TBookmark ) of object;

  TBookmarksForm = Class (TForm)
    BookmarksListBox: TListBox;
    GotoButton: TButton;
    DeleteButton: TButton;
    RenameButton: TButton;
    CloseButton: TButton;
    HelpButton: TButton;
    Procedure BookmarksFormOnSetupShow (Sender: TObject);
    Procedure BookmarksListBoxOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure CloseButtonOnClick (Sender: TObject);
    Procedure BookmarksListBoxOnDblClick (Sender: TObject);
    Procedure BookmarksFormOnCreate (Sender: TObject);
    Procedure BookmarksListBoxOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure DeleteButtonOnClick (Sender: TObject);
    Procedure RenameButtonOnClick (Sender: TObject);
    Procedure GotoButtonOnClick (Sender: TObject);
    Procedure BookmarksFormOnShow (Sender: TObject);
  protected
    function GetSelectedBookmark: TBookmark;
    procedure UpdateControls;
    procedure GotoSelectedBookmark;

  Protected
    Procedure OnLanguageEvent( Language: TLanguageFile;
                               const Apply: boolean );
    DeleteBookmarkTitle: string;
    DeleteBookmarkA: string;
    DeleteBookmarkB: string;
    RenameBookmarkTitle: string;
    RenameBookmark: string;

  Public
    // Input
    OpenBookmarkCallback: TBookmarkCallback;
    BookmarksChangedCallback: TNotifyEvent;
    // Input/Output parameter
    BookmarkList: TList;
    procedure RefreshList;
  End;

Var
  BookmarksForm: TBookmarksForm;

Implementation

uses
  PMWin,
  ControlsUtility,
  ACLDialogs,
  StringUtilsUnit,
  DebugUnit;

Procedure TBookmarksForm.BookmarksFormOnSetupShow (Sender: TObject);
Begin
  ScaleForm( self, 11, 16 );
  BookmarksListBox.XStretch := xsFrame;
  BookmarksListBox.YStretch := ysFrame;
  DeleteButton.Align := alFixedRightTop;
  RenameButton.Align := alFixedRightTop;
  GotoButton.Align := alFixedRightTop;
  HelpButton.Align := alFixedRightTop;
  CloseButton.Align := alFixedRightBottom;
End;

Procedure TBookmarksForm.OnLanguageEvent( Language: TLanguageFile;
                                          const Apply: boolean );
var
  tmpPrefix : String;
begin
  // LogEvent(LogI18n, 'TBookmarksForm.OnLanguageEvent apply: "' + BoolToStr(Apply) + '"');
  Language.LoadComponentLanguage( self, Apply );

  tmpPrefix := 'BookmarksForm' + LANGUAGE_LABEL_DELIMITER;

  Language.LL( Apply, DeleteBookmarkTitle, tmpPrefix + 'DeleteBookmarkTitle', 'Delete Bookmark' );
  Language.LL( Apply, DeleteBookmarkA, tmpPrefix + 'DeleteBookmarkA', 'Delete the bookmark named ' );
  Language.LL( Apply, DeleteBookmarkB, tmpPrefix + 'DeleteBookmarkB', '?' );
  Language.LL( Apply, RenameBookmarkTitle, tmpPrefix + 'RenameBookmarkTitle', 'Rename Bookmark' );
  Language.LL( Apply, RenameBookmark, tmpPrefix + 'RenameBookmark', 'Enter the new name of the bookmark' );
end;

Procedure TBookmarksForm.BookmarksListBoxOnScan (Sender: TObject;
  Var KeyCode: TKeyCode);
Begin
  if KeyCode = kb_VK + VK_NEWLINE then
    GotoSelectedBookmark;
End;

Procedure TBookmarksForm.CloseButtonOnClick (Sender: TObject);
Begin
  Close;
End;

Procedure TBookmarksForm.BookmarksListBoxOnDblClick (Sender: TObject);
Begin
  GotoSelectedBookmark;
End;

Procedure TBookmarksForm.BookmarksFormOnCreate (Sender: TObject);
Begin
  RegisterEventForLanguages( OnLanguageEvent );
End;

Procedure TBookmarksForm.BookmarksListBoxOnItemFocus (Sender: TObject;
  Index: LongInt);
Begin
  UpdateControls;
End;

Procedure TBookmarksForm.DeleteButtonOnClick (Sender: TObject);
Var
  Bookmark: TBookmark;
  BookmarkIndex: longint;
Begin
  Bookmark := GetSelectedBookmark;
  if Bookmark = nil then
    exit;

  if DoConfirmDlg( DeleteBookmarkTitle,
                   DeleteBookmarkA
                   + StrInDoubleQuotes(Bookmark.Name)
                   + DeleteBookmarkB ) then
  begin
    BookmarkIndex := BookmarkList.IndexOf( Bookmark );
    BookmarksListBox.Items.Delete( BookmarkIndex );
    BookmarkList.Delete( BookmarkIndex );

    if BookmarkIndex > BookmarkList.Count - 1 then
      BookmarkIndex := BookmarkList.Count - 1;

    BookmarksListBox.ItemIndex := BookmarkIndex;

    Bookmark.Destroy;
    BookmarksChangedCallback( self );

    UpdateControls;
  end;
End;

Procedure TBookmarksForm.RenameButtonOnClick (Sender: TObject);
Var
  Bookmark: TBookmark;
Begin
  Bookmark := GetSelectedBookmark;
  if Bookmark = nil then
    exit;
  if DoInputQuery( RenameBookmarkTitle,
                   RenameBookmark,
                   Bookmark.Name ) then
  begin
    BookmarksChangedCallback( self );

    // redisplay name in list
    BookmarksListBox.Items[ BookmarksListBox.ItemIndex ] := Bookmark.Name;

  end;
End;

function TBookmarksForm.GetSelectedBookmark: TBookmark;

begin
  if SelectedObject( BookmarksListBox ) = nil then
    result := nil
  else
    result := SelectedObject( BookmarksListBox ) as TBookmark;

end;

Procedure TBookmarksForm.GotoButtonOnClick (Sender: TObject);
Begin
  GotoSelectedBookmark;
End;

Procedure TBookmarksForm.GotoSelectedBookmark;
Begin
  if Assigned( OpenBookmarkCallback ) then
    if GetSelectedBookmark <> nil then
      OpenBookmarkCallback( GetSelectedBookmark );
End;

Procedure TBookmarksForm.BookmarksFormOnShow (Sender: TObject);
begin
  GoToButton.Default := true;
  RefreshList;
  BookmarksListBox.Focus;
end;

procedure TBookmarksForm.UpdateControls;
var
  Selected: Boolean;
begin
  Selected := GetSelectedBookmark <> nil;
  RenameButton.Enabled := Selected;
  DeleteButton.Enabled := Selected;
  GotoButton.Enabled := Selected;
  if not GotoButton.Enabled then
    GotoButton.Default := false;
end;

procedure TBookmarksForm.RefreshList;
var
  i: integer;
  Bookmark: TBookmark;
Begin
  BookmarksListBox.Items.BeginUpdate;

  BookmarksListBox.Clear;

  if not Assigned( BookmarkList ) then
    exit;

  for i := 0 to BookmarkList.Count - 1 do
  begin
    Bookmark := BookmarkList[ i ];
    BookmarksListBox.Items.AddObject( Bookmark.Name,
                                      Bookmark );
  end;

  if BookmarksListBox.Items.Count > 0 then
    BookmarksListBox.ItemIndex := 0;

  BookmarksListBox.Items.EndUpdate;
  UpdateControls;
End;

Initialization
  RegisterClasses ([TBookmarksForm
   , TListBox, TButton]);
End.
