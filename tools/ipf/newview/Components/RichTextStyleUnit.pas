Unit RichTextStyleUnit;

Interface

uses
  Forms,
  Classes,
  Graphics,
  CanvasFontManager,
  RichTextDocumentUnit;

type
  TTextDrawStyle = record
    Font: TFontSpec;
    Color: TColor;
    BackgroundColor: TColor;
    Alignment: TTextAlignment;
    Wrap: boolean;
    LeftMargin: longint;
    RightMargin: longint;
  end;

  TMarginSizeStyle = ( msAverageCharWidth, msMaximumCharWidth, msSpecifiedChar );

  TRichTextSettings = class( TComponent )
  protected
    FHeading1Font: TFont;
    FHeading2Font: TFont;
    FHeading3Font: TFont;

    FFixedFont: TFont;
    FNormalFont: TFont;

    FDefaultBackgroundColor: TColor;
    FDefaultColor: TColor;

    FDefaultAlignment: TTextAlignment;
    FDefaultWrap: boolean;

    FAtLeastOneWordBeforeWrap: boolean;

    FMarginSizeStyle: TMarginSizeStyle;
    FMarginChar: longint;

    FOnChange: TNotifyEvent;

    FMargins: TRect;

    FUpdateCount: longint;
    FChangesPending: boolean;

    Procedure Change;

    Procedure SetNormalFont( NewFont: TFont );
    Procedure SetFixedFont( NewFont: TFont );
    Procedure SetHeading1Font( NewFont: TFont );
    Procedure SetHeading2Font( NewFont: TFont );
    Procedure SetHeading3Font( NewFont: TFont );

    Procedure SetDefaultColor( NewColor: TColor );
    Procedure SetDefaultBackgroundColor( NewColor: TColor );

    Procedure SetDefaultAlignment( Alignment: TTextAlignment );
    Procedure SetDefaultWrap( Wrap: boolean );
    Procedure SetAtLeastOneWordBeforeWrap( NewValue: boolean );

    Procedure SetMarginSizeStyle( NewValue: TMarginSizeStyle );
    Procedure SetMarginChar( NewValue: longint );

    Procedure SetMargins( const NewMargins: TRect );

    function GetMargin_Left: longint;
    Procedure SetMargin_Left( NewValue: longint );
    function GetMargin_Bottom: longint;
    Procedure SetMargin_Bottom( NewValue: longint );
    function GetMargin_Right: longint;
    Procedure SetMargin_Right( NewValue: longint );
    function GetMargin_Top: longint;
    Procedure SetMargin_Top( NewValue: longint );

    Procedure SetupComponent; override;
    destructor Destroy; override;

    Procedure AssignFont( Var Font: TFont;
                          NewFont: TFont );

    // Hide properties...
    property Name;

  public
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    procedure BeginUpdate;
    procedure EndUpdate;

    // Stream in/out
    Procedure ReadSCUResource( Const ResName: TResourceName;
                               Var Data;
                               DataLen: LongInt ); override;
    Function WriteSCUResource( Stream: TResourceStream ): boolean; override;

    property Margins: TRect read FMargins write SetMargins;

    property Heading1Font: TFont read FHeading1Font write SetHeading1Font;
    property Heading2Font: TFont read FHeading2Font write SetHeading2Font;
    property Heading3Font: TFont read FHeading3Font write SetHeading3Font;
    property FixedFont: TFont read FFixedFont write SetFixedFont;
    property NormalFont: TFont read FNormalFont write SetNormalFont;

  published

    property DefaultBackgroundColor: TColor read FDefaultBackgroundColor write SetDefaultBackgroundColor;
    property DefaultColor: TColor read FDefaultColor write SetDefaultColor;

    property DefaultAlignment: TTextAlignment read FDefaultAlignment write SetDefaultAlignment;
    property DefaultWrap: boolean read FDefaultWrap write SetDefaultWrap;
    property AtLeastOneWordBeforeWrap: boolean read FAtLeastOneWordBeforeWrap write SetAtLeastOneWordBeforeWrap;

    property MarginSizeStyle: TMarginSizeStyle read FMarginSizeStyle write SeTMarginSizeStyle;
    property MarginChar: longint read FMarginChar write SetMarginChar;

    // margins are exposed as individual properties here
    // since the Sibyl IDE cannot cope with editing a record property
    // within a class property (as in RichTextView)
    property Margin_Left: longint read GetMargin_Left write SetMargin_Left;
    property Margin_Bottom: longint read GetMargin_Bottom write SetMargin_Bottom;
    property Margin_Right: longint read GetMargin_Right write SetMargin_Right;
    property Margin_Top: longint read GetMargin_Top write SetMargin_Top;
  end;

//  pRichTextSettings = ^TRichTextSettings;
  Procedure ApplyStyle( const Style: TTextDrawStyle;
                        FontManager: TCanvasFontManager );

  Procedure ApplyStyleTag( const Tag: TTag;
                           Var Style: TTextDrawStyle;
                           FontManager: TCanvasFontManager;
                           const Settings: TRichTextSettings;
                           const X: longint );

  function GetDefaultStyle( const Settings: TRichTextSettings ): TTextDrawStyle;

Exports
  TRichTextSettings,'User','';

Implementation

uses
  SysUtils,
  StringUtilsUnit;

Procedure ApplyStyle( const Style: TTextDrawStyle;
                      FontManager: TCanvasFontManager );
begin
  FontManager.SetFont( Style.Font );
  FontManager.Canvas.Pen.Color := Style.Color;
end;

Procedure ApplyStyleTag( Const Tag: TTag;
                         Var Style: TTextDrawStyle;
                         FontManager: TCanvasFontManager;
                         const Settings: TRichTextSettings;
                         const X: longint );
var
  MarginParam1: string;
  MarginParam2: string;
  NewMargin: longint;
  FontFaceName: string;
  FontSizeString: string;
  NewStyle: TTextDrawStyle;
  ParseIndex: longint;
  XSizeStr: string;
  YSizeStr: string;
  tmpFontParts : TStringList;

  MarginSize: longint;
  ParsePoint: longint;
begin
  case Tag.TagType of
    ttBold:
      Include( Style.Font.Attributes, faBold );
    ttBoldOff:
      Exclude( Style.Font.Attributes, faBold );
    ttItalic:
      Include( Style.Font.Attributes, faItalic );
    ttItalicOff:
      Exclude( Style.Font.Attributes, faItalic );
    ttUnderline:
      Include( Style.Font.Attributes, faUnderscore );
    ttUnderlineOff:
      Exclude( Style.Font.Attributes, faUnderscore );

    ttFixedWidthOn:
      SibylFontToFontSpec( Settings.FFixedFont, Style.Font );
    ttFixedWidthOff:
      SibylFontToFontSpec( Settings.FNormalFont, Style.Font );

    ttHeading1:
      SibylFontToFontSpec( Settings.FHeading1Font, Style.Font );
    ttHeading2:
      SibylFontToFontSpec( Settings.FHeading2Font, Style.Font );
    ttHeading3:
      SibylFontToFontSpec( Settings.FHeading3Font, Style.Font );
    ttHeadingOff:
      SibylFontToFontSpec( Settings.FNormalFont, Style.Font );

    ttFont:
    begin
      tmpFontParts := TStringList.Create;
      StrExtractStringsQuoted(tmpFontParts, Tag.Arguments);
      FontFaceName := tmpFontParts[0];
      FontSizeString := tmpFontParts[1];
      tmpFontParts.Destroy;

      NewStyle := Style;
      try
        NewStyle.Font.FaceName := FontFaceName;

        if Pos( 'x', FontSizeString ) > 0 then
        begin
          tmpFontParts := TStringList.Create;
          StrExtractStrings(tmpFontParts, FontSizeString, ['x'], #0);
          XSizeStr := tmpFontParts[0];
          YSizeStr := tmpFontParts[1];
          tmpFontParts.Destroy;

          NewStyle.Font.XSize := StrToInt( XSizeStr );
          NewStyle.Font.YSize := StrToInt( YSizeStr );
          NewStyle.Font.PointSize := 0;
        end
        else
        begin
          NewStyle.Font.PointSize := StrToInt( FontSizeString );
        end;

        if     ( NewStyle.Font.FaceName <> '' )
           and ( NewStyle.Font.PointSize >= 1 ) then
        begin
          Style := NewStyle;
        end;

      except
      end;
    end;

    ttFontOff:
      // restore default
      SibylFontToFontSpec( Settings.FNormalFont, Style.Font );

    ttColor:
      GetTagColor( Tag.Arguments, Style.Color );
    ttColorOff:
      Style.Color := Settings.FDefaultColor;
    ttBackgroundColor:
      GetTagColor( Tag.Arguments, Style.BackgroundColor );
    ttBackgroundColorOff:
      Style.BackgroundColor := Settings.FDefaultBackgroundColor;

    ttRed:
      Style.Color := clRed;
    ttBlue:
      Style.Color := clBlue;
    ttGreen:
      Style.Color := clGreen;
    ttBlack:
      Style.Color := clBlack;

    ttAlign:
      Style.Alignment := GetTagTextAlignment( Tag.Arguments,
                                              Settings.FDefaultAlignment );

    ttWrap:
      Style.Wrap := GetTagTextWrap( Tag.Arguments );

    ttSetLeftMargin,
    ttSetRightMargin:
    begin
      tmpFontParts := TStringList.Create;
      StrExtractStrings(tmpFontParts, Tag.Arguments, [' '], #0);
      MarginParam1 := tmpFontParts[0];
      tmpFontParts.Destroy;

      ParsePoint := 1;
      if     ( Tag.TagType = ttSetLeftMargin )
         and ( MarginParam1 = 'here' ) then
      begin
        Style.LeftMargin := X div FontWidthPrecisionFactor;
      end
      else
      begin
        try
          MarginSize := StrToInt( MarginParam1 );
          MarginParam2 := tmpFontParts[1];
          if MarginParam2 = 'pixels' then
            NewMargin := MarginSize

          else if MarginParam2 = 'deffont' then
            NewMargin := MarginSize
                         * Settings.NormalFont.Width

          else
          begin
            case Settings.MarginSizeStyle of
              msAverageCharWidth:
                NewMargin := MarginSize * FontManager.AverageCharWidth;
              msMaximumCharWidth:
                NewMargin := MarginSize * FontManager.MaximumCharWidth;
              msSpecifiedChar:
                NewMargin := MarginSize
                             * FontManager.CharWidth( Chr( Settings.MarginChar ) )
                             div FontWidthPrecisionFactor;
            end;
          end;
        except
          NewMargin := 0;
        end;

        if Tag.TagType = ttSetLeftMargin then
          Style.LeftMargin := Settings.Margins.Left
                              + NewMargin
        else
          Style.RightMargin := Settings.Margins.Right
                               + NewMargin;
      end;
    end;

  end;

  ApplyStyle( Style, FontManager );

end;

function GetDefaultStyle( const Settings: TRichTextSettings ): TTextDrawStyle;
begin
  SibylFontToFontSpec( Settings.FNormalFont, Result.Font );
  Result.Alignment := Settings.FDefaultAlignment;
  Result.Wrap := Settings.FDefaultWrap;
  Result.Color := Settings.FDefaultColor;
  Result.BackgroundColor := Settings.FDefaultBackgroundColor;
  Result.LeftMargin := Settings.Margins.Left;
  Result.RightMargin := Settings.Margins.Right;
end;

Procedure GetStartupFont( Var Font: TFont;
                          Const Face: string;
                          Const Size: longint );
begin
  Font := Screen.CreateCompatibleFont( Screen.GetFontFromPointSize( Face, Size ) );
  ReferenceFont( Font );
  Font.AutoDestroy := true;
end;

Procedure TRichTextSettings.SetupComponent;
begin
  inherited SetupComponent;

  Name := 'RichTextSettings';

  GetStartupFont( FNormalFont, 'Helv', 8 );
  GetStartupFont( FFixedFont, 'Courier', 8 );
  GetStartupFont( FHeading1Font, 'Helv', 18 );
  GetStartupFont( FHeading2Font, 'Helv', 12 );
  GetStartupFont( FHeading3Font, 'Helv', 8 );
  FHeading3Font.Attributes := [ faBold ];

  FDefaultColor := clBlack;
  FDefaultBackgroundColor := clWhite;

  FDefaultAlignment := taLeft;
  FDefaultWrap := true;
  FAtLeastOneWordBeforeWrap := false;

  FMarginSizeStyle := msMaximumCharWidth;
  FMarginChar := Ord( ' ' );

  FMargins.Left := 0;
  FMargins.Right := 0;
  FMargins.Top := 0;
  FMargins.Bottom := 0;

  FUpdateCount := 0;
  FChangesPending := false;
end;

destructor TRichTextSettings.Destroy;
begin
  DereferenceFont( FNormalFont );
  DereferenceFont( FFixedFont );
  DereferenceFont( FHeading1Font );
  DereferenceFont( FHeading2Font );
  DereferenceFont( FHeading3Font );

  Inherited Destroy;
end;

// Font read/write from SCU. I have NO IDEA why I have to do this manually. But
// this way works and everything else I tried doesn't
Procedure TRichTextSettings.ReadSCUResource( Const ResName: TResourceName;
                                             Var Data;
                                             DataLen: LongInt );
Begin
  If ResName = 'Heading1Font' Then
  Begin
    If DataLen <> 0 Then
      FHeading1Font := ReadSCUFont( Data, DataLen );
  End
  Else If ResName = 'Heading2Font' Then
  Begin
    If DataLen <> 0 Then
      FHeading2Font := ReadSCUFont( Data, DataLen );
  End
  Else If ResName = 'Heading3Font' Then
  Begin
    If DataLen <> 0 Then
      FHeading3Font := ReadSCUFont( Data, DataLen );
  End
  Else If ResName = 'FixedFont' Then
  Begin
    If DataLen <> 0 Then
      FFixedFont := ReadSCUFont( Data, DataLen );
  End
  Else if ResName = 'NormalFont' then
  Begin
    If DataLen <> 0 Then
      FNormalFont := ReadSCUFont( Data, DataLen );
  End
  Else
    Inherited ReadSCUResource( ResName, Data, DataLen );
End;

Function TRichTextSettings.WriteSCUResource( Stream: TResourceStream ): boolean;
begin
  Result := Inherited WriteSCUResource( Stream );
  If Not Result Then
    Exit;

  If FHeading1Font <> Nil then
    Result := FHeading1Font.WriteSCUResourceName( Stream, 'Heading1Font' );
  If FHeading2Font <> Nil then
    Result := FHeading2Font.WriteSCUResourceName( Stream, 'Heading2Font' );
  If FHeading3Font <> Nil then
    Result := FHeading3Font.WriteSCUResourceName( Stream, 'Heading3Font' );
  If FFixedFont <> Nil then
    Result := FFixedFont.WriteSCUResourceName( Stream, 'FixedFont' );
  If FNormalFont <> Nil then
    Result := FNormalFont.WriteSCUResourceName( Stream, 'NormalFont' );

end;

Procedure TRichTextSettings.Change;
begin
  if FUpdateCount > 0 then
  begin
     FChangesPending := true;
     exit;
  end;

  if FOnChange <> nil then
    FOnChange( self );
end;

Procedure TRichTextSettings.SetDefaultAlignment( Alignment: TTextAlignment );
begin
  if Alignment = FDefaultAlignment then
    exit; // no change

  FDefaultAlignment := Alignment;
  Change;
end;

Procedure TRichTextSettings.SetDefaultWrap( Wrap: boolean );
begin
  if Wrap = FDefaultWrap then
    exit; // no change

  FDefaultWrap := Wrap;
  Change;
end;

Procedure TRichTextSettings.SetAtLeastOneWordBeforeWrap( NewValue: boolean );
begin
  if NewValue = FAtLeastOneWordBeforeWrap then
    exit; // no change

  FAtLeastOneWordBeforeWrap := NewValue;
  Change;
end;

Procedure TRichTextSettings.SetMarginChar( NewValue: longint );
begin
  if NewValue = FMarginChar then
    exit; // no change

  FMarginChar := NewValue;

  if FMarginSizeStyle <> msSpecifiedChar then
    // doesn't matter, will be ignored
    exit;
  Change;
end;

Procedure TRichTextSettings.SetMarginSizeStyle( NewValue: TMarginSizeStyle );
begin
  if NewValue = FMarginSizeStyle then
    exit; // no change

  FMarginSizeStyle := NewValue;
  Change;
end;

Function FontSame( FontA: TFont; FontB: TFont ): boolean;
begin
  if    ( FontA = nil )
     or ( FontB = nil ) then
  begin
    Result := FontA = FontB;
    exit;
  end;

  Result :=     ( FontA.FaceName = FontB.FaceName )
            and ( FontA.PointSize = FontB.PointSize )
            and ( FontA.Attributes = FontB.Attributes );
end;

Procedure TRichTextSettings.AssignFont( Var Font: TFont;
                                        NewFont: TFont );
begin
  If NewFont = Nil Then
    NewFont := Screen.DefaultFont;

  if FontSame( NewFont, Font ) then
    exit; // no change

  DereferenceFont( Font );
  Font := NewFont;
  ReferenceFont( Font );

  Change;
End;

Procedure TRichTextSettings.SetHeading1Font( NewFont: TFont );
begin
//  ProfileEvent( 'TRichTextSettings.SetHeading1Font' );
  AssignFont( FHeading1Font, NewFont );

//  if FHeading1FOnt = nil then
//    ProfileEvent( '  Set to nil' );

end;

Procedure TRichTextSettings.SetHeading2Font( NewFont: TFont );
begin
  AssignFont( FHeading2Font, NewFont );
End;

Procedure TRichTextSettings.SetHeading3Font( NewFont: TFont );
begin
  AssignFont( FHeading3Font, NewFont );
End;

Procedure TRichTextSettings.SetFixedFont( NewFont: TFont );
begin
  AssignFont( FFixedFont, NewFont );
end;

Procedure TRichTextSettings.SetNormalFont( NewFont: TFont );
begin
  AssignFont( FNormalFont, NewFont );
end;

Procedure TRichTextSettings.SetMargins( const NewMargins: TRect );
begin
  if NewMargins = FMargins then
    exit; // no change
  FMargins := NewMargins;
  Change;
end;

function TRichTextSettings.GetMargin_Left: longint;
begin
  Result := FMargins.Left;
end;

Procedure TRichTextSettings.SetMargin_Left( NewValue: longint );
begin
  Margins.Left := NewValue;
end;

function TRichTextSettings.GetMargin_Bottom: longint;
begin
  Result := FMargins.Bottom;
end;

Procedure TRichTextSettings.SetMargin_Bottom( NewValue: longint );
begin
  Margins.Bottom := NewValue;
end;

function TRichTextSettings.GetMargin_Right: longint;
begin
  Result := FMargins.Right;
end;

Procedure TRichTextSettings.SetMargin_Right( NewValue: longint );
begin
  Margins.Right := NewValue;
end;

function TRichTextSettings.GetMargin_Top: longint;
begin
  Result := FMargins.Top;
end;

Procedure TRichTextSettings.SetMargin_Top( NewValue: longint );
begin
  Margins.Top := NewValue;
end;

Procedure TRichTextSettings.SetDefaultColor( NewColor: TColor );
begin
  if NewColor = FDefaultColor then
    exit;
  FDefaultColor := NewColor;
  Change;
end;

Procedure TRichTextSettings.SetDefaultBackgroundColor( NewColor: TColor );
begin
  if NewColor = FDefaultBackgroundColor then
    exit;
  FDefaultBackgroundColor := NewColor;
  Change;
end;

procedure TRichTextSettings.BeginUpdate;
begin
  inc( FUpdateCount );
end;

procedure TRichTextSettings.EndUpdate;
begin
  if FUpdateCount = 0 then
    exit;

  dec( FUpdateCount );
  if FUpdateCount = 0 then
  begin
    if FChangesPending then
    begin
      Change;
      FChangesPending := false;
    end;
  end;
end;

Initialization
  RegisterClasses( [ TRichTextSettings ] );
End.
