unit UEditor;

interface

uses
  Windows, Messages, Classes, Graphics, DScintilla, DScintillaUtils,
  DScintillaTypes, Highlighter, Controls, Forms, ImgList, SearchEngine;

const
  MARGIN_BOOKMARK    = 0;
  MARGIN_LINE_NUMBER = 1;
  MARGIN_BREAKPOINT  = 2;
  MARGIN_FOLD        = 3;
  MARGIN_SPACE       = 4;


  MARK_BREAKPOINT = 1;
  MARK_CURRENTLINE = 2;
  MARK_BREAKICON = 3;
  MARK_BREAKCURR = 4;
  MARK_BOOKMARK: array[0..9] of Integer = (5, 6, 7, 8, 9, 10,
    11, 12, 13, 14);

  INDIC_MATCHSEL = 0;

  WM_HOTSPOTFIXCLICK = WM_USER + 1221;
type
  TBufferCoord = record
    Char: integer;
    Line: integer;
  end;

  TDisplayCoord = record
    Column: integer;
    Row: integer;
  end;

  TSearchDirection = (sdUp, sdDown);
  
  TEditor = class(TDScintilla)
  private
    FBraceAtCaret, FBraceOpposite: Integer;
    FBookmarks: array of Integer;
    FHighlighter: THighlighter;
    FBracketHighlight: THighlighStyle;
    FBadBracketHighlight: THighlighStyle;
    FLineNumberHighlight: THighlighStyle;
    FDefaultHighlight: THighlighStyle;
    FCaretLineHighlight: THighlighStyle;
    FSelectionHighlight: THighlighStyle;
    FBreakpointHighlight: THighlighStyle;
    FExecutionPointHighlight: THighlighStyle;
    FMatchWordHighlight: THighlighStyle;
    FOnScroll: TNotifyEvent;
    fOnMouseEnter: TMouseMoveEvent;
    fOnMouseLeave: TMouseMoveEvent;
    FCaretColor: TColor;
    FFolding: Boolean;
    FShowLineNumber: Boolean;
    FImageList: TCustomImageList;
    FShowIndentGuides: Boolean;
    FActiveLineColor: TColor;
    FLinkColor: TColor;
    FOnHotSpotFixClick: TDSciHotSpotClickEvent;
    FHotspotModifiers: Integer;
    FHotspotPosition: Integer;
    FLastSelectionCount: Integer;
    FSearchEngine: TSearchEngine;
    procedure BracketHighlightChanged(Sender: TObject);
    procedure HighlighterChanged(Sender: TObject);
    function GetModified: Boolean;
    function GetDisplayY: Integer;
    function GetDisplayX: Integer;
    function GetSelText: UnicodeString;
    procedure SetSelText(const Value: UnicodeString);
    function GetBlockEnd: TBufferCoord;
    procedure SetBlockEnd(const Value: TBufferCoord);
    function GetCaretXY: TBufferCoord;
    procedure SetCaretXY(const Value: TBufferCoord);
    function GetBlockBegin: TBufferCoord;
    procedure SetBlockBegin(const Value: TBufferCoord);
    function GetLineHeight: Integer;
    function GetSelStart: Integer;
    procedure SetSelStart(const Value: Integer);
    function GetSelLength: Integer;
    function GetCaretX: Integer;
    function GetCaretY: Integer;
    function GetWantTabs: Boolean;
    procedure SetWantTabs(const Value: Boolean);
    function GetTopLine: Integer;
    procedure SetTopLine(const Value: Integer);
    function GetLinesInWindow: Integer;
    procedure DoMarginClick(AModifiers: Integer; APosition: Integer; AMargin: Integer);
    procedure DoModified(APosition: Integer; AModificationType: Integer;
      ALength: Integer; ALinesAdded: Integer; ALine: Integer;
      AFoldLevelNow: Integer; AFoldLevelPrev: Integer);
    procedure DoUpdateUI(AUpdated: Integer);
    procedure SetZoomUpdate(const Value: Integer);
    procedure UpdateLineMargin;
    procedure SetSelLength(const Value: Integer);
    function GetReadOnly: Boolean;
    function GetTabWidth: Integer;
    function GetZoom: Integer;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetTabWidth(const Value: Integer);
    function GetInsertMode: Boolean;
    procedure SetInsertMode(const Value: Boolean);
    procedure SetHighlighter(const Value: THighlighter);
    procedure UpdateStyles;
    procedure ApplyStyle(Style: THighlighStyle);
    procedure DoBraceMatch;
    procedure FindMatchingBracePos(caretPos: Integer; var braceAtCaret, braceOpposite: Integer);
    function GetLineText: UnicodeString;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMHotSpotFixClick(var Message: TMessage); message WM_HOTSPOTFIXCLICK;
    procedure SetFolding(const Value: Boolean);
    procedure UpdateFolderMarker;
    function GetWordEnd: TBufferCoord;
    function GetDisplayXY: TDisplayCoord;
    function LeftSpacesEx(const Line: string; WantTabs: Boolean): Integer;
    function GetLeftSpacing(CharCount: Integer; WantTabs: Boolean): string;
    function GetFirstNonSpaceChar(const S: string): Char;
    function GetLastNonSpaceChar(const S: string): Char;
    procedure AdvanceSpaceBreakLine(aLine: Integer;
      var LeftOffset: Integer; var Unindent: Boolean);
    function RightSpacesEx(const Line: string; WantTabs: Boolean): Integer;
    procedure SetShowLineNumber(const Value: Boolean);
    procedure SetImageList(const Value: TCustomImageList);
    function GetFont: TFont;
    procedure SetFont(const Value: TFont);
    procedure SetShowIndentGuides(const Value: Boolean);
    procedure LineNumberHighlightChanged(Sender: TObject);
    procedure DefaultHighlightChanged(Sender: TObject);
    procedure CaretLineHighlightChanged(Sender: TObject);
    procedure SelectionHighlightChanged(Sender: TObject);
    procedure SetCaretColor(const Value: TColor);
    procedure BreakpointHighlightChanged(Sender: TObject);
    procedure ExecutionPointHighlightChanged(Sender: TObject);
    procedure MatchWordHighlightChanged(Sender: TObject);
    procedure UpdateMarginIcons;
    procedure SetLinkColor(const Value: TColor);
    procedure DoSelectionChanged;
    procedure ResetAllStyle;
    procedure ColouriseVisibleArea;
    function RelativePosition(APosition: Integer): Integer;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoScroll; virtual;
    function DoSCNotification(const ASCNotification: TDSciSCNotification): Boolean;
      override;
    procedure MouseEnter(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure InitDefaults; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetLineMakerWidth: Integer;
    procedure UncollapseLine(Line: Integer);
    procedure SetCaretAndSelection(const caret, b, c: TBufferCoord);
    procedure GotoLineAndCenter(Line: Integer);
    function PixelsToRowColumn(x, y: Integer): TDisplayCoord;
    function IsPointInSelection(const rowcol: TBufferCoord): Boolean;
    function GetWordAt(APosition: Integer): UnicodeString;
    function GetWordAtRowCol(const rowcol: TBufferCoord): UnicodeString;
    function PrevWordPos: TBufferCoord;
    function SearchTextEx(const Search: string; SearchFlags, StartPosition,
      EndPosition: Integer; Research: Boolean; Direction: TSearchDirection;
      var SelectionStart, SelectionEnd: Integer; var UsingResearch: Boolean;
      DocStartPosition: Integer = 0; DocEndPosition: Integer = -1): Integer;
    function SelAvail: Boolean;
    function RowColToCharIndex(const rowcol: TBufferCoord): Integer;
    function RowColumnToPixels(const Display: TDisplayCoord): TPoint;
    function BufferToDisplayPos(const rowcol: TBufferCoord): TDisplayCoord;
    function DisplayToBufferPos(const Display: TDisplayCoord): TBufferCoord;
    function CharIndexToRowCol(index: Integer): TBufferCoord;
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure PasteFromClipboard;
    procedure InvalidateLine(Line: Integer);
    function GetBookMark(I: Integer; var X, Y: Integer): Boolean;
    procedure SetBookMark(I, X, Y: Integer);
    procedure ClearBookMark(I: Integer);
    procedure GotoBookMark(I: Integer);
    function WordStart: TBufferCoord;
    procedure MoveSelectionUp;
    procedure MoveSelectionDown;
    procedure CollapseCurrent;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure CollapseAll;
    procedure UncollapseAll;
    procedure UncollapseRange(startLine, endLine: Integer);
    procedure SetLinkClick(Enabled: Boolean);
    function WordStartEx(const rowcol: TBufferCoord): TBufferCoord;
    function GetMatchingBracketEx(const rowcol: TBufferCoord): TBufferCoord;
    function GetBalancingBracketEx(const APoint: TBufferCoord;
      Bracket: WideChar): Integer;
    function GetHighlighterAttriAt(APosition: Integer; var S: UnicodeString;
      var Style: THighlighStyle): Boolean;
    function GetHighlighterAttriAtRowCol(const rowcol: TBufferCoord;
      var S: UnicodeString; var Style: THighlighStyle): Boolean;
    procedure ProcessCloseBracketChar;
    procedure ProcessBreakLine;
    procedure AddBreakpoint(Line: Integer);
    procedure DeleteBreakpoint(Line: Integer);
    procedure SetActiveLine(Line: Integer);
    procedure RemoveActiveLine(Line: Integer);

    property SearchEngine: TSearchEngine read FSearchEngine write FSearchEngine;
    property Font: TFont read GetFont write SetFont;
    property Zoom: Integer read GetZoom write SetZoomUpdate;
    property LinesInWindow: Integer read GetLinesInWindow;
    property TopLine: Integer read GetTopLine write SetTopLine;
    property WantTabs: Boolean read GetWantTabs write SetWantTabs;
    property TabWidth: Integer read GetTabWidth write SetTabWidth;
    property Modified: Boolean read GetModified;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property DisplayY: Integer read GetDisplayY;
    property DisplayX: Integer read GetDisplayX;
    property DisplayXY: TDisplayCoord read GetDisplayXY;
    property SelText: UnicodeString read GetSelText write SetSelText;
    property LineText: UnicodeString read GetLineText;
    property BlockBegin: TBufferCoord read GetBlockBegin write SetBlockBegin;
    property BlockEnd: TBufferCoord read GetBlockEnd write SetBlockEnd;
    property WordEnd: TBufferCoord read GetWordEnd;
    property CaretXY: TBufferCoord read GetCaretXY write SetCaretXY;
    property CaretY: Integer read GetCaretY;
    property CaretX: Integer read GetCaretX;
    property LineHeight: Integer read GetLineHeight;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property InsertMode: Boolean read GetInsertMode write SetInsertMode;
    property Highlighter: THighlighter read FHighlighter write SetHighlighter;
    property Folding: Boolean read FFolding write SetFolding;
    property ShowLineNumber: Boolean read FShowLineNumber write SetShowLineNumber;
    property ShowIndentGuides: Boolean read FShowIndentGuides write SetShowIndentGuides;
    property BracketHighlight: THighlighStyle read FBracketHighlight;
    property BadBracketHighlight: THighlighStyle read FBadBracketHighlight;
    property LineNumberHighlight: THighlighStyle read FLineNumberHighlight;
    property DefaultHighlight: THighlighStyle read FDefaultHighlight;
    property CaretLineHighlight: THighlighStyle read FCaretLineHighlight;
    property CaretColor: TColor read FCaretColor write SetCaretColor;
    property LinkColor: TColor read FLinkColor write SetLinkColor;
    property SelectionHighlight: THighlighStyle read FSelectionHighlight;
    property BreakpointHighlight: THighlighStyle read FBreakpointHighlight;
    property ExecutionPointHighlight: THighlighStyle read FExecutionPointHighlight;
    property MatchWordHighlight: THighlighStyle read FMatchWordHighlight;
    property ImageList: TCustomImageList read FImageList write SetImageList;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnMouseEnter: TMouseMoveEvent read fOnMouseEnter write fOnMouseEnter;
    property OnMouseLeave: TMouseMoveEvent read fOnMouseLeave write fOnMouseLeave;
    property OnHotSpotFixClick: TDSciHotSpotClickEvent read FOnHotSpotFixClick write FOnHotSpotFixClick;

  end;

function DisplayCoord(AColumn, ARow: Integer): TDisplayCoord;
function BufferCoord(AChar, ALine: Integer): TBufferCoord;

implementation

uses
  SysUtils, UnicodeUtils, CustomColors, Contnrs, UUtils, CppHighlighter,
  CppTokenizer, RegEx;

function DisplayCoord(AColumn, ARow: Integer): TDisplayCoord;
begin
  Result.Column := AColumn;
  Result.Row := ARow;
end;

function BufferCoord(AChar, ALine: Integer): TBufferCoord;
begin
  Result.Char := AChar;
  Result.Line := ALine;
end;

{ TEditor }

constructor TEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentFont := False;
  FActiveLineColor := clNone;
  FBracketHighlight := THighlighStyle.Create(STYLE_BRACELIGHT, 'Brace');
  FBracketHighlight.OnChange := BracketHighlightChanged;
  FBadBracketHighlight := THighlighStyle.Create(STYLE_BRACEBAD, 'Bad Brace');
  FBadBracketHighlight.OnChange := BracketHighlightChanged;
  FLineNumberHighlight := THighlighStyle.Create(STYLE_LINENUMBER, 'Line Number');
  FLineNumberHighlight.OnChange := LineNumberHighlightChanged;
  FDefaultHighlight := THighlighStyle.Create(STYLE_DEFAULT, 'Default');
  FDefaultHighlight.OnChange := DefaultHighlightChanged;
  FCaretLineHighlight := THighlighStyle.Create(0, 'Caret Line');
  FCaretLineHighlight.OnChange := CaretLineHighlightChanged;
  FSelectionHighlight := THighlighStyle.Create(0, 'Selection');
  FSelectionHighlight.OnChange := SelectionHighlightChanged;
  FBreakpointHighlight := THighlighStyle.Create(0, 'Breakpoint');
  FBreakpointHighlight.OnChange := BreakpointHighlightChanged;
  FExecutionPointHighlight := THighlighStyle.Create(0, 'Execution Point');
  FExecutionPointHighlight.OnChange := ExecutionPointHighlightChanged;
  FMatchWordHighlight := THighlighStyle.Create(0, 'Match Word');
  FMatchWordHighlight.OnChange := MatchWordHighlightChanged;
  SetLength(FBookmarks, 10);
end;              

destructor TEditor.Destroy;
begin
  SetHighlighter(nil); // remove hook from highlighter change list
  FMatchWordHighlight.Free;
  FExecutionPointHighlight.Free;
  FBreakpointHighlight.Free;
  FSelectionHighlight.Free;
  FCaretLineHighlight.Free;
  FDefaultHighlight.Free;
  FLineNumberHighlight.Free;
  FBadBracketHighlight.Free;
  FBracketHighlight.Free;
  inherited;
end;

procedure TEditor.InitDefaults;
var
  I, Mask: Integer;
begin
  inherited;
  for I := 0 to 255 do
  begin
    ClearCmdKey(I + (SCMOD_CTRL shl 16));
    ClearCmdKey(I + ((SCMOD_CTRL or SCMOD_SHIFT) shl 16));
  end;
  SetModEventMask(SC_MOD_INSERTTEXT or SC_MOD_DELETETEXT);
  SetMarginWidthN(MARGIN_BOOKMARK, 16);
  SetMarginWidthN(MARGIN_LINE_NUMBER, 0);
  SetMarginWidthN(MARGIN_BREAKPOINT, 14);
  SetMarginWidthN(MARGIN_SPACE, 1);

  SetMarginTypeN(MARGIN_BOOKMARK, SC_MARGIN_SYMBOL);
  SetMarginTypeN(MARGIN_LINE_NUMBER, SC_MARGIN_NUMBER);
  SetMarginTypeN(MARGIN_BREAKPOINT, SC_MARGIN_SYMBOL);
  SetMarginTypeN(MARGIN_FOLD, SC_MARGIN_SYMBOL);
  SetMarginTypeN(MARGIN_SPACE, SC_MARGIN_SYMBOL);

  Mask := 0;
  for I := 0 to 9 do
    Mask := Mask or (1 shl MARK_BOOKMARK[I]);
  SetMarginMaskN(MARGIN_BOOKMARK, Mask);
  SetMarginMaskN(MARGIN_LINE_NUMBER, 0);
  SetMarginMaskN(MARGIN_BREAKPOINT, (1 shl MARK_BREAKICON) or
    (1 shl MARK_BREAKCURR));
  SetMarginMaskN(MARGIN_FOLD, Integer(SC_MASK_FOLDERS)); 
  SetMarginMaskN(MARGIN_SPACE, 0);
  SetScrollWidthTracking(True);
  SetScrollWidth(1);

  MarkerDefine(SC_MARKNUM_FOLDER, SC_MARK_BOXPLUS);
  MarkerDefine(SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS);
  MarkerDefine(SC_MARKNUM_FOLDERTAIL, SC_MARK_LCORNER);
  MarkerDefine(SC_MARKNUM_FOLDERSUB, SC_MARK_VLINE);
  MarkerDefine(SC_MARKNUM_FOLDEREND, SC_MARK_BOXPLUSCONNECTED);
  MarkerDefine(SC_MARKNUM_FOLDEROPENMID, SC_MARK_BOXMINUSCONNECTED);
  MarkerDefine(SC_MARKNUM_FOLDERMIDTAIL, SC_MARK_TCORNER);
  // Indicator style
  IndicSetStyle(INDIC_MATCHSEL, INDIC_ROUNDBOX);
  // Breakpoint line
	MarkerDefine(MARK_BREAKPOINT, SC_MARK_BACKGROUND);
	MarkerSetAlpha(MARK_BREAKPOINT, 70);
  // current breakpoint line
	MarkerDefine(MARK_CURRENTLINE, SC_MARK_BACKGROUND);
	MarkerSetAlpha(MARK_CURRENTLINE, 70);
  MarkerEnableHighlight(True);
  SetMarginSensitiveN(MARGIN_BOOKMARK, True);
  SetMarginSensitiveN(MARGIN_LINE_NUMBER, True);
  SetMarginSensitiveN(MARGIN_BREAKPOINT, True);
  SetMarginSensitiveN(MARGIN_FOLD, True);
  SetFoldFlags(SC_FOLDFLAG_LINEAFTER_CONTRACTED); // 16  	Draw line below if not expanded
  SetShowIndentGuides(True);                                          
  SetCaretLineVisibleAlways(True);
  SetCaretColor(clBlack);
  SetCaretPeriod(500);
  Font.Name := 'Courier New';
  Font.Size := 10;
end;


procedure TEditor.UpdateMarginIcons;
var
  I: Integer;
  ImageWidth, ImageHeight: Integer;
  ImgPtr: PAnsiChar;
begin
  if FImageList = nil then
  begin                 
  // breakpoint icon
    MarkerDefine(MARK_BREAKICON, SC_MARK_CIRCLE);
    MarkerSetBack(MARK_BREAKICON, DSColor(clRed));
    MarkerSetFore(MARK_BREAKICON, DSColor(clBlack));
  // breakpoint arrow icon
    MarkerDefine(MARK_BREAKCURR, SC_MARK_SHORTARROW);
    MarkerSetBack(MARK_BREAKCURR, DSColor(clGreen));
    MarkerSetFore(MARK_BREAKCURR, DSColor(clBlack));
  end
  else
  begin
    // bookmark 0..9
    for I := 0 to 9 do
    begin
      FBookmarks[I] := 0;
      ImgPtr := GetRGBAPointerFromImageIndex(FImageList, 6 + I, ImageWidth, ImageHeight);
      RGBAImageSetWidth(ImageWidth);
      RGBAImageSetHeight(ImageHeight);
      MarkerDefineRGBAImage(MARK_BOOKMARK[I], ImgPtr);
      FreeMem(ImgPtr);
    end;
    // breakpoint icon
    ImgPtr := GetRGBAPointerFromImageIndex(FImageList, 2, ImageWidth, ImageHeight);
    RGBAImageSetWidth(ImageWidth);
    RGBAImageSetHeight(ImageHeight);
    MarkerDefineRGBAImage(MARK_BREAKICON, ImgPtr);
    FreeMem(ImgPtr);
    // breakpoint arrow icon
    ImgPtr := GetRGBAPointerFromImageIndex(FImageList, 4, ImageWidth, ImageHeight);
    RGBAImageSetWidth(ImageWidth);
    RGBAImageSetHeight(ImageHeight);
    MarkerDefineRGBAImage(MARK_BREAKCURR, ImgPtr);
    FreeMem(ImgPtr);
  end;
end;

procedure TEditor.UpdateFolderMarker;
const
  marker: array[0..6] of Integer = (SC_MARKNUM_FOLDER, SC_MARKNUM_FOLDEROPEN,
    SC_MARKNUM_FOLDERTAIL, SC_MARKNUM_FOLDERSUB, SC_MARKNUM_FOLDEREND,
    SC_MARKNUM_FOLDEROPENMID, SC_MARKNUM_FOLDERMIDTAIL);
var
  I: Integer;
begin
  for I := 0 to 6 do
  begin
    MarkerSetFore(marker[I], DSColor(FDefaultHighlight.Background));
    MarkerSetBack(marker[I], DSColor(FLineNumberHighlight.Foreground));
    MarkerSetBackSelected(marker[i], DSColor(FBracketHighlight.Foreground));
  end;
  StyleSetFore(STYLE_INDENTGUIDE, DSColor(FLineNumberHighlight.Foreground));
  StyleSetBack(STYLE_INDENTGUIDE, DSColor(FDefaultHighlight.Background));
end;

procedure TEditor.BeginUpdate;
begin
 //TODO:
end;

function TEditor.BufferToDisplayPos(
  const rowcol: TBufferCoord): TDisplayCoord;
var
  Position: Integer;
begin
  //TODO:
  Position := RowColToCharIndex(rowcol);
  Result.Row := rowcol.Line;
  Result.Column := GetColumn(PositionRelative(0, Position)) + 1;
end;

function TEditor.CharIndexToRowCol(Index: Integer): TBufferCoord;
begin
  Index := PositionRelative(0, Index);
  Result.Line := LineFromPosition(Index) + 1;
  Result.Char := CountCharacters(PositionFromLine(Result.Line - 1), Index) + 1;
end;

procedure TEditor.ClearBookMark(I: Integer);
var
  Line: Integer;
begin
  if FBookmarks[I] = 0 then
    Exit;
  Line := MarkerLineFromHandle(FBookmarks[I]);
  if Line < 0 then
    Exit;
  MarkerDelete(Line, MARK_BOOKMARK[0] + I);
  FBookmarks[I] := 0;
end;

procedure TEditor.CollapseAll;
begin
  FoldAll(SC_FOLDACTION_CONTRACT);
end;

procedure TEditor.CollapseCurrent;
begin
  FoldLine(CaretY - 1, SC_FOLDACTION_CONTRACT);
end;

procedure TEditor.ColouriseVisibleArea;
begin
  Colourise(PositionFromLine(GetFirstVisibleLine),
    GetLineEndPosition(GetFirstVisibleLine + LinesOnScreen));
end;

procedure TEditor.CopyToClipboard;
begin
  Copy;
end;

procedure TEditor.CutToClipboard;
begin
  Cut;
end;

function TEditor.DisplayToBufferPos(
  const Display: TDisplayCoord): TBufferCoord;
begin
  Result := CharIndexToRowCol(RelativePosition(FindColumn(Display.Row - 1, Display.Column - 1)));
end;

procedure TEditor.DoMarginClick(AModifiers, APosition, AMargin: Integer);
var
  line_number: Integer;
begin
  line_number := LineFromPosition(Aposition);
  case Amargin of
    MARGIN_FOLD: ToggleFold(line_number);
  end;
end;

procedure TEditor.DoModified(APosition: Integer; AModificationType: Integer;
  ALength: Integer; ALinesAdded: Integer; ALine: Integer;
  AFoldLevelNow: Integer; AFoldLevelPrev: Integer);
begin
  UpdateLineMargin;
  DoSelectionChanged;
end;

procedure TEditor.EndUpdate;
begin
  UpdateLineMargin;
end;

function TEditor.GetBlockBegin: TBufferCoord;
begin
  Result := CharIndexToRowCol(RelativePosition(GetSelectionStart));
end;

function TEditor.GetBlockEnd: TBufferCoord;
begin
  Result := CharIndexToRowCol(RelativePosition(GetSelectionEnd));
end;

function TEditor.GetBookMark(I: Integer; var X, Y: Integer): Boolean;
var
  Line: Integer;
begin
  Result := False;
  if (I < 1) or (I > 9) or (FBookmarks[I] = 0) then
    Exit;
  Line := MarkerLineFromHandle(FBookmarks[I]);
  if Line < 0 then
  begin
    FBookmarks[I] := 0;
    Exit;
  end;
  X := 1;
  Y := Line + 1;
end;

function TEditor.GetCaretX: Integer;
begin
  Result := GetCaretXY.Char;
end;

function TEditor.GetCaretXY: TBufferCoord;
var
  Position, LinePosition: Integer;
begin
  Position := GetCurrentPos;
  Result.Line := LineFromPosition(Position) + 1;
  LinePosition := PositionFromLine(Result.Line - 1);
  Result.Char := CountCharacters(LinePosition, Position) + 1;
end;

function TEditor.GetCaretY: Integer;
begin
  Result := LineFromPosition(GetCurrentPos) + 1;
end;

function TEditor.GetDisplayX: Integer;
begin
  Result := GetColumn(GetCurrentPos) + 1;
end;

function TEditor.GetDisplayY: Integer;
begin
  Result := LineFromPosition(GetCurrentPos) + 1;
end;

function TEditor.GetLineHeight: Integer;
begin
  Result := TextHeight(0);
end;

function TEditor.GetLineMakerWidth: Integer;
var
  num: UnicodeString;
  lineCount, px, mpx: Integer;
begin
  lineCount := GetLineCount;
  num := IntToStr(lineCount);
  px := TextWidth(STYLE_LINENUMBER, num);
  mpx := TextWidth(STYLE_LINENUMBER, '999');
  if (px < mpx) then
    px := mpx;
  result := px + 2;
end;

function TEditor.GetLinesInWindow: Integer;
begin
  Result := LinesOnScreen;
end;

function TEditor.GetModified: Boolean;
begin
  Result := GetModify;
end;

procedure TEditor.SetSelLength(const Value: Integer);
begin
  SetSelectionEnd(PositionRelative(0, GetSelStart + Value));
end;

function TEditor.GetSelStart: Integer;
begin
  Result := RelativePosition(GetSelectionStart);
end;

function TEditor.GetSelText: UnicodeString;
begin
  Result := inherited GetSelText;
end;

function TEditor.GetTopLine: Integer;
begin
  Result := GetFirstVisibleLine + 1;
end;

function TEditor.GetWantTabs: Boolean;
begin
  Result := GetUseTabs;
end;

function TEditor.GetWordAtRowCol(const rowcol: TBufferCoord): UnicodeString;
var
  I: Integer;
begin
  I := PositionFromLine(rowcol.Line - 1) + rowcol.Char - 1;
  Result := GetWordAt(I);
end;

function TEditor.GetWordAt(APosition: Integer): UnicodeString;
var
  StartPos, EndPos: Integer;
begin
  StartPos := WordStartPosition(APosition, True);
  EndPos := WordEndPosition(APosition, True);
  Result := GetTextRange(StartPos, EndPos);
end;

procedure TEditor.GotoBookMark(I: Integer);
var
  Line: Integer;
begin
  if FBookmarks[I] = 0 then
    Exit;
  Line := MarkerLineFromHandle(FBookmarks[I]);
  if Line < 0 then
    Exit;
  GotoLine(Line);
  EnsureVisible(Line);
end;

procedure TEditor.GotoLineAndCenter(Line: Integer);
begin
  SetCaretXY(BufferCoord(1, Line));
  EnsureVisible(Line);
  SetTopLine(Line - (LinesInWindow div 2));
end;

function TEditor.SearchTextEx(const Search: string; SearchFlags: Integer;
  StartPosition, EndPosition: Integer; Research: Boolean;
  Direction: TSearchDirection; var SelectionStart, SelectionEnd: Integer;
  var UsingResearch: Boolean; DocStartPosition, DocEndPosition: Integer): Integer;
var
  SearchResult, SearchResultEnd, ResearchResult,
  PrevSearchResult, PrevSearchResultEnd: Integer;
begin
  if FSearchEngine = nil then
    raise Exception.Create('Search engine not set');
  if DocEndPosition = -1 then
    DocEndPosition := GetLength;
  FSearchEngine.Editor := Self;
  FSearchEngine.SetSearchFlags(SearchFlags);
  if Direction = sdUp then // search first text before current position
  begin
    FSearchEngine.SetTargetStart(DocStartPosition);
    FSearchEngine.SetTargetEnd(StartPosition);
  end
  else
  begin // select next text after position end
    FSearchEngine.SetTargetStart(EndPosition);
    FSearchEngine.SetTargetEnd(DocEndPosition);
  end;
  SearchResult := FSearchEngine.SearchInTarget(Search);
  SearchResultEnd := FSearchEngine.GetTargetEnd;
  if Direction = sdUp then // search last text ocurrency from begining before current
  begin
    PrevSearchResult := SearchResult;
    PrevSearchResultEnd := SearchResultEnd;
    while SearchResult <> -1 do
    begin
      PrevSearchResult := SearchResult;
      PrevSearchResultEnd := SearchResultEnd;
      FSearchEngine.SetTargetStart(SearchResultEnd);
      FSearchEngine.SetTargetEnd(StartPosition);
      SearchResult := FSearchEngine.SearchInTarget(Search);
      SearchResultEnd := FSearchEngine.GetTargetEnd;
    end;
    SearchResult := PrevSearchResult;
    SearchResultEnd := PrevSearchResultEnd;
  end;
  ResearchResult := -1;
  if (SearchResult = -1) and Research then
  begin
    if Direction = sdUp then
    begin
      // try from end
      FSearchEngine.SetTargetStart(StartPosition);
      FSearchEngine.SetTargetEnd(DocEndPosition);
    end
    else
    begin
      // try from begining
      FSearchEngine.SetTargetStart(DocStartPosition);
      FSearchEngine.SetTargetEnd(EndPosition);
    end;
    SearchResult := FSearchEngine.SearchInTarget(Search);
    SearchResultEnd := FSearchEngine.GetTargetEnd;
    if Direction = sdUp then // search last text ocurrency after current position
    begin
      PrevSearchResult := SearchResult;
      PrevSearchResultEnd := SearchResultEnd;
      while SearchResult <> -1 do
      begin
        PrevSearchResult := SearchResult;
        PrevSearchResultEnd := SearchResultEnd;
        FSearchEngine.SetTargetStart(SearchResultEnd);
        FSearchEngine.SetTargetEnd(DocEndPosition);
        SearchResult := FSearchEngine.SearchInTarget(Search);
        SearchResultEnd := FSearchEngine.GetTargetEnd;
      end;
      SearchResult := PrevSearchResult;
      SearchResultEnd := PrevSearchResultEnd;
    end;
    ResearchResult := SearchResult;
  end;
  if SearchResult <> -1 then
  begin
    SelectionStart := SearchResult;
    SelectionEnd := SearchResultEnd;
    UsingResearch := ResearchResult <> -1;
    Result := 1;
  end
  else
    Result := 0;
end;

procedure TEditor.InvalidateLine(Line: Integer);
begin
  //TODO:
end;

function TEditor.IsPointInSelection(const rowcol: TBufferCoord): Boolean;
var
  Position: Integer;
begin
  Position := PositionRelative(0, RowColToCharIndex(rowcol));
  Result := (GetSelectionStart >= Position) and (Position <= GetSelectionEnd);
end;

procedure TEditor.MoveSelectionDown;
begin
  MoveSelectedLinesDown;
end;

procedure TEditor.MoveSelectionUp;
begin
  MoveSelectedLinesUp;
end;

procedure TEditor.PasteFromClipboard;
begin
  Paste;
end;

function TEditor.PixelsToRowColumn(x, y: Integer): TDisplayCoord;
var
  APos: Integer;
begin
  APos := PositionFromPoint(x, y);
  Result.Column := GetColumn(APos) + 1;
  Result.Row := LineFromPosition(APos) + 1;
end;

function TEditor.PrevWordPos: TBufferCoord;
begin
  //TODO:
end;

function TEditor.RowColToCharIndex(const rowcol: TBufferCoord): Integer;
var
  I, LineBreakLen: Integer;
begin
  Result := 0;
  LineBreakLen := 2;
  if GetEOLMode <> SC_EOL_CRLF then
    LineBreakLen := 1;
  for I := 0 to rowcol.Line - 2 do
    Inc(Result, Length(Lines[I]) + LineBreakLen);
  Inc(Result, rowcol.Char - 1);
end;

function TEditor.RelativePosition(APosition: Integer): Integer;
var
  I, Line, LineStartPosition, LineBreakLen: Integer;
begin
  Result := 0;
  LineBreakLen := 2;
  if GetEOLMode <> SC_EOL_CRLF then
    LineBreakLen := 1;
  Line := LineFromPosition(APosition);
  LineStartPosition := PositionFromLine(Line);
  for I := 0 to Line - 1 do
    Inc(Result, Length(Lines[I]) + LineBreakLen);
  Inc(Result, CountCharacters(LineStartPosition, APosition));
end;

function TEditor.RowColumnToPixels(const Display: TDisplayCoord): TPoint;
var
  Position: Integer;
begin
  // FIX: incompatible conversion on middle of tab character
  Position := FindColumn(Display.Row - 1, Display.Column - 1);
  Result.X := PointXFromPosition(Position);
  Result.Y := PointYFromPosition(Position);
end;

function TEditor.SelAvail: Boolean;
begin
  Result := not GetSelectionEmpty;
end;

procedure TEditor.SetBlockBegin(const Value: TBufferCoord);
begin
  SetSelectionStart(PositionRelative(0, RowColToCharIndex(Value)));
end;

procedure TEditor.SetBlockEnd(const Value: TBufferCoord);
begin
  SetSelectionEnd(PositionRelative(0, RowColToCharIndex(Value)));
end;

procedure TEditor.SetBookMark(I, X, Y: Integer);
var
  Line: Integer;
begin
  if (I < 1) or (I > 9) then
    Exit;
  if FBookmarks[I] > 0 then
  begin
    Line := MarkerLineFromHandle(FBookmarks[I]);
    if Line = Y - 1 then
      Exit;
    if Line >= 0 then
      MarkerDelete(Line, MARK_BOOKMARK[0] + I);
  end;
  FBookmarks[I] := MarkerAdd(Y - 1, MARK_BOOKMARK[0] + I);
end;

procedure TEditor.SetCaretAndSelection(const caret, b, c: TBufferCoord);
begin
  SetCaretXY(caret);
  SetBlockBegin(b);
  SetBlockEnd(c);
end;

procedure TEditor.SetCaretXY(const Value: TBufferCoord);
begin
  //TODO:
  SetEmptySelection(PositionRelative(0, RowColToCharIndex(Value)));
  ScrollCaret;
end;

function TEditor.GetSelLength: Integer;
begin
  // return -1 if it's multi-selection or rectangle selection
  if (GetSelections > 1) or SelectionIsRectangle then
  begin
    Result := 0;
    Exit;
  end;
  Result := Length(GetSelText);
end;

procedure TEditor.SetSelStart(const Value: Integer);
begin
  SetSelectionStart(PositionRelative(0, Value));
end;

procedure TEditor.SetSelText(const Value: UnicodeString);
begin
  ReplaceSel(Value);
end;

procedure TEditor.SetTopLine(const Value: Integer);
begin
  SetFirstVisibleLine(Value - 1);
end;

procedure TEditor.SetWantTabs(const Value: Boolean);
begin
  SetUseTabs(Value);
end;

procedure TEditor.UncollapseAll;
begin
  FoldAll(SC_FOLDACTION_EXPAND);
end;

procedure TEditor.UncollapseLine(Line: Integer);
begin
  FoldLine(Line, SC_FOLDACTION_EXPAND);
end;

procedure TEditor.UncollapseRange(startLine, endLine: Integer);
begin
  EnsureRangeVisible(startLine, endLine);
end;

function TEditor.WordStart: TBufferCoord;
begin
  //TODO:
  Result := WordStartEx(CaretXY)
end;

function TEditor.WordStartEx(const rowcol: TBufferCoord): TBufferCoord;
var
  I, StartPos: Integer;
begin
  I := PositionRelative(0, RowColToCharIndex(rowcol));
  StartPos := WordStartPosition(I, True);
  Result := CharIndexToRowCol(RelativePosition(StartPos));
end;

procedure TEditor.UpdateLineMargin;
begin
  if FShowLineNumber then
    SetMarginWidthN(MARGIN_LINE_NUMBER, GetLineMakerWidth());
end;

procedure TEditor.SetZoomUpdate(const Value: Integer);
begin
  SetZoom(Value);
  UpdateLineMargin;
end;

function TEditor.GetReadOnly: Boolean;
begin
  Result := inherited GetReadOnly;
end;

function TEditor.GetTabWidth: Integer;
begin
  Result := inherited GetTabWidth;
end;

function TEditor.GetZoom: Integer;
begin
  Result := inherited GetZoom;
end;

procedure TEditor.SetReadOnly(const Value: Boolean);
begin
  inherited SetReadOnly(Value);
end;

procedure TEditor.SetTabWidth(const Value: Integer);
begin
  inherited SetTabWidth(Value);
end;

function TEditor.GetInsertMode: Boolean;
begin
  Result := GetOvertype = False;
end;

procedure TEditor.SetInsertMode(const Value: Boolean);
begin
  SetOvertype(not Value);
end;

procedure TEditor.HighlighterChanged(Sender: TObject);
begin
  if Sender is THighlighStyle then
    ApplyStyle(THighlighStyle(Sender))
  else
    UpdateStyles;
end;

procedure TEditor.SetHighlighter(const Value: THighlighter);
begin
  if FHighlighter = Value then
    Exit;
  if (FHighlighter <> nil) then
    FHighlighter.RemoveHookChange(HighlighterChanged);
  FHighlighter := Value;
  if FHighlighter = nil then
    Exit;
  FHighlighter.AddHookChange(HighlighterChanged);
  SetLexer(FHighlighter.ID);
  SetProperty('fold.compact', '0');
  SetProperty('fold.comment', '1');
  SetProperty('fold.preprocessor', '1');
  SetProperty('lexer.cpp.track.preprocessor', '0');
  SetStyleBits(5);
  FHighlighter.SetKeyWords(SetKeyWords);
  ResetAllStyle;
end;

procedure TEditor.UpdateStyles;
var
  I: Integer;
begin
  if FHighlighter = nil then
    Exit;
  for I := 0 to FHighlighter.StyleCount - 1 do
    ApplyStyle(FHighlighter[I]);
  UpdateLineMargin;
end;

procedure TEditor.DoUpdateUI(AUpdated: Integer);
begin
  if ((AUpdated and SC_UPDATE_V_SCROLL) = SC_UPDATE_V_SCROLL) or
    ((AUpdated and SC_UPDATE_H_SCROLL) = SC_UPDATE_H_SCROLL) then
    DoScroll;
  DoBraceMatch;
  if (AUpdated and SC_UPDATE_SELECTION) = SC_UPDATE_SELECTION then
    DoSelectionChanged;
end;

procedure TEditor.DoSelectionChanged;
var
  SelWord: UnicodeString;
  TargetStart, TargetEnd, MatchLen: Integer;
  SaveLastSelectionCount: Integer;
begin
  MatchLen := GetSelLength;   
  TargetStart := 0;
  TargetEnd := GetTextLength;
  if FLastSelectionCount > 0 then
    IndicatorClearRange(TargetStart, TargetEnd);
  if MatchLen = 0 then
  begin
    if FLastSelectionCount > 0 then
      ColouriseVisibleArea;
    FLastSelectionCount := 0;
    Exit;
  end;
  SelWord := GetSelText;
  // check if selection match with valid words
  if not IsWordOrNumber(PChar(string(SelWord))) then
  begin
    if FLastSelectionCount > 0 then
      ColouriseVisibleArea;
    FLastSelectionCount := 0;
    Exit;
  end;
  SetSearchFlags(SCFIND_WHOLEWORD);
  SaveLastSelectionCount := FLastSelectionCount;
  FLastSelectionCount := 0;
  // match all words including selection
  while TargetStart <> -1 do
  begin
    SetTargetStart(TargetStart);
    SetTargetEnd(TargetEnd);
    TargetStart := SearchInTarget(SelWord);
    if TargetStart = -1 then
      Break;
    SetIndicatorCurrent(INDIC_MATCHSEL);
    IndicatorFillRange(TargetStart, MatchLen);
    //Colourise(TargetStart, TargetStart + MatchLen);
    Inc(TargetStart, MatchLen);
    Inc(FLastSelectionCount);
  end;
  if (FLastSelectionCount > 0) or (SaveLastSelectionCount > 0) then
    ColouriseVisibleArea;
end;

procedure TEditor.DoBraceMatch;
var
  BraceAtCaret, BraceOpposite: Integer;
  columnAtCaret, columnOpposite: Integer;
begin
  FindMatchingBracePos(GetCurrentPos, BraceAtCaret, BraceOpposite);
  if (FBraceAtCaret = BraceAtCaret) and (FBraceOpposite = BraceOpposite) then
    Exit;
  if (BraceAtCaret <> -1) and (BraceOpposite = -1) then
  begin
    FBraceAtCaret := BraceAtCaret;
    FBraceOpposite := -1;
    BraceBadLight(FBraceAtCaret);
    SetHighlightGuide(0);
  end
  else
  begin
    BraceHighlight(BraceAtCaret, BraceOpposite);
    if (FBraceAtCaret <> -1) and (FBraceAtCaret <> BraceAtCaret) then
      Colourise(FBraceAtCaret, FBraceAtCaret + 1); // invalidate previows brace highlight
    if (FBraceOpposite <> -1) and (FBraceOpposite <> BraceOpposite) then
      Colourise(FBraceOpposite, FBraceOpposite + 1); // invalidate previows brace highlight
    FBraceAtCaret := BraceAtCaret;
    FBraceOpposite := BraceOpposite;
    //if (FBraceAtCaret <> -1) then
    //  Colourise(FBraceAtCaret, FBraceAtCaret + 1); // invalidate new brace highlight
    if (FBraceOpposite <> -1) then
      Colourise(FBraceOpposite, FBraceOpposite + 1); // invalidate new brace highlight
    if FShowIndentGuides then
    begin
      columnAtCaret := GetColumn(FBraceAtCaret);
      columnOpposite := GetColumn(FBraceOpposite);
      if (columnAtCaret < columnOpposite) then
        SetHighlightGuide(columnAtCaret)
      else
        SetHighlightGuide(columnOpposite);
    end;
  end;
end;

procedure TEditor.FindMatchingBracePos(caretPos: Integer; var braceAtCaret,
  braceOpposite: Integer);
var
  lengthDoc: Integer;
  charBefore, charAfter: WideChar;
begin
  braceAtCaret := -1;
  braceOpposite := -1;
  charBefore := #0;
  lengthDoc := GetLength;
  if ((lengthDoc > 0) and (caretPos > 0)) then
  begin
    charBefore := WideChar(GetCharAt(caretPos - 1));
  end;
 // Priority goes to character before caret
  if ((charBefore <> #0) and IsIn(charBefore, '[](){}')) then
  begin
    braceAtCaret := caretPos - 1;
  end;
  if ((lengthDoc > 0) and (braceAtCaret < 0)) then
  begin
  // No brace found so check other side
    charAfter := WideChar(GetCharAt(caretPos));
    if ((charAfter <> #0) and IsIn(charAfter, '[](){}')) then
    begin
      braceAtCaret := caretPos;
    end;
  end;
  if (braceAtCaret >= 0) then
    braceOpposite := BraceMatch(braceAtCaret);
end;

function TEditor.GetBalancingBracketEx(
  const APoint: TBufferCoord; Bracket: WideChar): Integer;
const
  Brackets: array[0..7] of WideChar = ('(', ')', '[', ']', '{', '}', '<', '>');
var
  Line: UnicodeString;
  i, PosX, PosY, Len, RealY: integer;
  Test, BracketInc, BracketDec: WideChar;
  vDummy: UnicodeString;
  OpenCount, CloseCount: Integer;
  attr: THighlighStyle;
  p: TBufferCoord;
  isCommentOrString: boolean;
  Stack: TStack;
begin
  Test := Bracket;
  OpenCount := 0;
  CloseCount := 0;
  // is it one of the recognized brackets?
  for i := Low(Brackets) to High(Brackets) do
    if Test = Brackets[i] then
    begin
      // this is the bracket, get the matching one and the direction
      if i < (i xor 1) then
      begin
        BracketInc := Brackets[i];
        BracketDec := Brackets[i xor 1]; // 0 -> 1, 1 -> 0, ...
      end
      else
      begin
        BracketInc := Brackets[i xor 1]; // 0 -> 1, 1 -> 0, ...
        BracketDec := Brackets[i];
      end;
      // position of balancing
      PosX := APoint.Char;
      RealY := APoint.Line;
      PosY := RealY;
      if PosY >= Lines.Count then
        Break;
      Line := Lines[PosY - 1];
      // count the matching bracket
      Stack := TStack.Create;
      repeat
        // search until start of line
        while PosX > 1 do
        begin
          Dec(PosX);
          Test := Line[PosX];
          p.Char := PosX;
          p.Line := PosY;
          if (Test = BracketInc) or (Test = BracketDec) then
          begin
            if GetHighlighterAttriAtRowCol(p, vDummy, attr) then
            begin
              isCommentOrString := Highlighter.IsComment(attr) or Highlighter.IsString(attr);
            end
            else
              isCommentOrString := false;
            if (Test = BracketInc) and (not isCommentOrString) then
            begin
              if (Stack.Count > 0) and (WideChar(Stack.Peek) = BracketDec) then
                Stack.Pop
              else
                Inc(OpenCount);
            end
            else if (Test = BracketDec) and (not isCommentOrString) then
              Stack.Push(Pointer(BracketDec));
          end;
        end;
        // get previous line if possible
        Dec(PosY);
        if PosY = 0 then Break;
        Line := Lines[PosY - 1];
        PosX := Length(Line) + 1;
      until False;
      Stack.Free;

      // position of balancing
      PosX := APoint.Char - 1;
      PosY := RealY;
      Line := Lines[PosY - 1];
      Stack := TStack.Create;
      repeat
        // search until end of line
        Len := Length(Line);
        while PosX < Len do
        begin
          Inc(PosX);
          Test := Line[PosX];
          p.Char := PosX;
          p.Line := PosY;
          if (Test = BracketInc) or (Test = BracketDec) then
          begin
            if GetHighlighterAttriAtRowCol(p, vDummy, attr) then
            begin
              isCommentOrString := Highlighter.IsComment(attr) or Highlighter.IsString(attr);
            end
            else
              isCommentOrString := false;
            if (Test = BracketInc) and (not isCommentOrString) then
              Stack.Push(Pointer(BracketInc))
            else if (Test = BracketDec) and (not isCommentOrString) then
            begin
              if (Stack.Count > 0) and (WideChar(Stack.Peek) = BracketInc) then
                Stack.Pop
              else
                Inc(CloseCount);
            end;
          end;
        end;
        // get next line if possible
        if PosY >= Lines.Count then
          Break;
        Inc(PosY);
        Line := Lines[PosY - 1];
        PosX := 0;
      until False;
      Stack.Free;
      // don't test the other brackets, we're done
      Break;
    end;
  Result := CloseCount - OpenCount;
end;

procedure TEditor.ApplyStyle(Style: THighlighStyle);
begin
  StyleSetFore(Style.ID, DSColor(Style.Foreground, FDefaultHighlight.Foreground));
  StyleSetBack(Style.ID, DSColor(Style.Background, FDefaultHighlight.Background));
  StyleSetBold(Style.ID, fsBold in Style.Style);
  StyleSetItalic(Style.ID, fsItalic in Style.Style);
  StyleSetUnderline(Style.ID, fsUnderline in Style.Style);
  StyleSetHotSpot(Style.ID, Style.Hotspot);
  if Style.ID = STYLE_BRACELIGHT then
    StyleSetSize(Style.ID, Font.Size + 2);
end;

procedure TEditor.BracketHighlightChanged(Sender: TObject);
begin
  ApplyStyle(THighlighStyle(Sender));
  UpdateFolderMarker;
end;

procedure TEditor.LineNumberHighlightChanged(Sender: TObject);
begin
  ApplyStyle(THighlighStyle(Sender));
  UpdateFolderMarker;
end;

procedure TEditor.DefaultHighlightChanged(Sender: TObject);
begin
  ApplyStyle(THighlighStyle(Sender));
  StyleClearAll;
  UpdateStyles;
  UpdateFolderMarker;
end;

procedure TEditor.CaretLineHighlightChanged(Sender: TObject);
begin
  SetCaretLineBack(DSColor(FCaretLineHighlight.Background));
  SetCaretLineVisible(FCaretLineHighlight.Background <> clNone);
end;

procedure TEditor.SelectionHighlightChanged(Sender: TObject);
begin
  SetSelBack(FSelectionHighlight.Background <> clNone, DSColor(FSelectionHighlight.Background));
end;

procedure TEditor.BreakpointHighlightChanged(Sender: TObject);
begin
  MarkerSetFore(MARK_BREAKPOINT, DSColor(FBreakpointHighlight.Foreground));
  MarkerSetBack(MARK_BREAKPOINT, DSColor(FBreakpointHighlight.Background));
end;

procedure TEditor.ExecutionPointHighlightChanged(Sender: TObject);
begin
  MarkerSetFore(MARK_CURRENTLINE, DSColor(FExecutionPointHighlight.Foreground));
  MarkerSetBack(MARK_CURRENTLINE, DSColor(FExecutionPointHighlight.Background));
end;

procedure TEditor.MatchWordHighlightChanged(Sender: TObject);
begin
  IndicSetFore(INDIC_MATCHSEL, DSColor(FMatchWordHighlight.Foreground));
end;

procedure TEditor.SetLinkClick(Enabled: Boolean);
var
  Style: THighlighStyle;
begin
  if FHighlighter = nil then
    Exit;
  Style := FHighlighter.FindStyle(HL_Style_Identifier);
  if Style = nil then
    Exit;
  Style.Hotspot := Enabled;
  Style := FHighlighter.FindStyle(HL_Style_Preprocessor);
  if Style <> nil then
    Style.Hotspot := Enabled;
  // Colourise(0, -1);
  ColouriseVisibleArea;
end;

function TEditor.GetLineText: UnicodeString;
var
  Line: Integer;
begin
  Line := CaretY;
  Result := GetTextRange(PositionFromLine(Line - 1), GetLineEndPosition(Line - 1));
end;

procedure TEditor.DoScroll;
begin
  if Assigned(FOnScroll) then
    FOnScroll(Self);
end;

function TEditor.DoSCNotification(
  const ASCNotification: TDSciSCNotification): Boolean;
begin
  Result := inherited DoSCNotification(ASCNotification);
  case ASCNotification.NotifyHeader.code of
    SCN_UPDATEUI: DoUpdateUI(ASCNotification.updated);
    SCN_MODIFIED: DoModified(ASCNotification.position, ASCNotification.modificationType,
        ASCNotification.length, ASCNotification.linesAdded, ASCNotification.line,
        ASCNotification.foldLevelNow, ASCNotification.foldLevelPrev);
    SCN_MARGINCLICK: DoMarginClick(ASCNotification.modifiers,
        ASCNotification.position, ASCNotification.margin);
    SCN_HOTSPOTCLICK:
    begin
      FHotspotModifiers := ASCNotification.modifiers;
      FHotspotPosition := ASCNotification.position;
    end;
  end;
end;

procedure TEditor.CMMouseEnter(var Message: TMessage);
var
  P: TPoint;
  Shift: TShiftState;
begin
  Shift := KeyboardStateToShiftState;
  P := Point(TWMMouse(Message).XPos, TWMMouse(Message).YPos);
  P := ScreenToClient(P);
  MouseEnter(Self, Shift, P.X, P.Y);
end;

procedure TEditor.MouseEnter(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if assigned(fOnMouseEnter) then
    fOnMouseEnter(Sender, Shift, X, Y);
end;

procedure TEditor.CMMouseLeave(var Message: TMessage);
var
  P: TPoint;
  Shift: TShiftState;
begin
  Shift := KeyboardStateToShiftState;
  P := Point(TWMMouse(Message).XPos, TWMMouse(Message).YPos);
  P := ScreenToClient(P);
  MouseLeave(Self, Shift, P.X, P.Y);
end;

procedure TEditor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FHighlighter then
      SetHighlighter(nil)
    else if AComponent = FImageList then
      SetImageList(nil);
  end;
end;       

procedure TEditor.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResetAllStyle;
end;

procedure TEditor.ResetAllStyle;
begin
  StyleSetFont(STYLE_DEFAULT, Font.Name);
  StyleSetSize(STYLE_DEFAULT, Font.Size);
  StyleClearAll;
  ApplyStyle(FBracketHighlight);
  UpdateStyles;
end;


procedure TEditor.MouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if assigned(fOnMouseLeave) then
    fOnMouseLeave(Sender, Shift, X, Y);
end;

function TEditor.GetMatchingBracketEx(
  const rowcol: TBufferCoord): TBufferCoord;
var
  braceAtCaret, braceOpposite: Integer;
begin
  braceAtCaret := -1;
  braceOpposite := -1;
  FindMatchingBracePos(PositionRelative(0, RowColToCharIndex(rowcol)), braceAtCaret, braceOpposite);

  if ((braceAtCaret <> -1) and (braceOpposite = -1)) then
  begin
    Result.Char := 0;
    Result.Line := 0;
  end
  else
    Result := CharIndexToRowCol(RelativePosition(braceOpposite));
end;

function TEditor.GetHighlighterAttriAtRowCol(const rowcol: TBufferCoord;
  var S: UnicodeString; var Style: THighlighStyle): Boolean;
var
  APosition: Integer;
begin
  APosition := PositionRelative(0, RowColToCharIndex(rowcol));
  Result := GetHighlighterAttriAt(APosition, S, Style);
end;

function TEditor.GetHighlighterAttriAt(APosition: Integer;
  var S: UnicodeString; var Style: THighlighStyle): Boolean;
var
  StyleID: Integer;
  AStyle: THighlighStyle;
begin
  Result := False;
  StyleID := GetStyleAt(APosition);
  if (StyleID = 0) or (Highlighter = nil) then
    Exit;
  AStyle := Highlighter.FindStyleByID(StyleID);
  Result := AStyle <> nil;
  if Result then
  begin
    Style := AStyle;
    S := GetWordAt(APosition);
  end;
end;

procedure TEditor.SetFolding(const Value: Boolean);
begin
  if FFolding = Value then
    Exit;
  FFolding := Value;
  SetProperty('fold', IntToStr(Integer(FFolding)));
  if  FFolding then
    SetMarginWidthN(MARGIN_FOLD, 14)
  else
    SetMarginWidthN(MARGIN_FOLD, 0);
end;

function TEditor.GetWordEnd: TBufferCoord;
begin
  Result := CharIndexToRowCol(RelativePosition(WordEndPosition(GetCurrentPos, True)));
end;

function TEditor.GetDisplayXY: TDisplayCoord;
begin
  Result.Row := LineFromPosition(GetCurrentPos) + 1;
  Result.Column := GetColumn(GetCurrentPos) + 1;
end;

procedure TEditor.ProcessCloseBracketChar;
var
  c, CaretNew, StartOfBlock, EndOfBlock: TBufferCoord;
  LineStr, StrPrevBracket, StrBracket, Temp: string;
  SpaceCount: Integer;
begin
  if ReadOnly then
    Exit;
  c := CaretXY;
  LineStr := LineText;
  StrPrevBracket := System.Copy(LineStr, 1, c.Char - 2);
  StrBracket := System.Copy(LineStr, c.Char - 1, Length(LineStr) - c.Char + 2);
  CaretNew := GetMatchingBracketEx(BufferCoord(C.Char - 1, C.Line));
  if (CaretNew.Char > 0) and (CaretNew.Line > 0) and
     (Length(Trim(StrPrevBracket)) = 0) then
  begin
    SpaceCount := LeftSpacesEx(Lines[CaretNew.Line - 1], True);
    Temp := GetLeftSpacing(SpaceCount, WantTabs);
    StartOfBlock := BufferCoord(1, c.Line);
    EndOfBlock := BufferCoord(c.Char, c.Line);
    SetCaretAndSelection(EndOfBlock, StartOfBlock, EndOfBlock);
    ReplaceSel(Temp + StrBracket[1]);
  end;
end;

// Indentation enhancement

procedure TEditor.ProcessBreakLine;
var
  c, bCaret: TBufferCoord;
  LineStr, PrevLineStr, StrPrevCaret, StrPosCaret, TmpStr,
    CommentStr, NextLineStr: string;
  token: UnicodeString;
  LeftOffset, SpaceCount, I, RL: Integer;
  lstch, fstch: Char;
  attri: THighlighStyle;
  Unindent, caretChanged, IsCommentLine: Boolean;
begin
  if ReadOnly then
    Exit;
  caretChanged:= False;
  c := CaretXY;
  RL := c.Line;
  PrevLineStr := Lines[RL - 2];
  LineStr := LineText;
  StrPrevCaret := System.Copy(LineStr, 1, c.Char - 1);
  StrPosCaret := System.Copy(LineStr, c.Char, Length(LineStr) - c.Char + 1);
  lstch := GetLastNonSpaceChar(PrevLineStr);
  fstch := GetFirstNonSpaceChar(StrPosCaret);
  AdvanceSpaceBreakLine(c.Line - 1, LeftOffset, Unindent);
  BeginUndoAction;
  if (lstch = '{') and (fstch = '}') then
  begin
    caretChanged := True;
    bCaret := CaretXY;
    TmpStr := GetLeftSpacing(LeftOffset, WantTabs);
    bCaret.Char := Length(TmpStr) + 1;
    Lines.Insert(CaretY - 1, TmpStr);
    CaretXY := BufferCoord(1, bCaret.Line + 1);
    Dec(LeftOffset, TabWidth);
  end
  else if ((fstch = '{') or (fstch <> #0)) and
    ((LeftOffset >= TabWidth) or (fstch = '{'))then
  begin
    if (LeftOffset >= TabWidth) then
      Dec(LeftOffset, TabWidth);
    caretChanged := True;
    bCaret := CaretXY;
    if fstch = '{' then
      Inc(bCaret.Char, 2);
  end;
  I := RightSpacesEx(StrPrevCaret, True);
  SpaceCount := LeftOffset - I;
  CommentStr := '';
  TmpStr := Trim(PrevLineStr);
  IsCommentLine := False;
  if GetHighlighterAttriAtRowCol(BufferCoord(Length(PrevLineStr), c.Line - 1), token, attri)
    and (attri.Name = 'Documentation Comment') then
    IsCommentLine := True;
  NextLineStr := '';
  // ( is /** or * blabla ) and not /** bla bla */
  if ((System.Copy(TmpStr, 1, 3) = '/**') or ((System.Copy(TmpStr, 1, 1) = '*') and IsCommentLine))
    and (System.Copy(TmpStr, Length(TmpStr) - 1, 2) <> '*/') then
  begin
    // get next line after /**
    if RL < Lines.Count then
      NextLineStr := Trim(Lines[RL]);
    // check next line if is */ or * insert * else insert */
    if (System.Copy(NextLineStr, 1, 2) = '*/') or (System.Copy(NextLineStr, 1, 1) = '*') then
      NextLineStr := '* '
    else
      NextLineStr := '*/';
    CommentStr := '* ';
    if Unindent then
      Dec(SpaceCount)
    else if System.Copy(TmpStr, 1, 3) = '/**' then
      Inc(SpaceCount);
  end;
  if (TmpStr = '*/') and (SpaceCount < 0) then
    Unindent := True;
  if Unindent then
  begin
    SpaceCount := 0;
    I := 1;
    while I <= Length(LineStr) do
    begin
      Inc(SpaceCount, RightSpacesEx(LineStr[I], True));
      if SpaceCount > LeftOffset then
      begin
        Dec(SpaceCount, RightSpacesEx(LineStr[I], True));
        Break;
      end;
      Inc(I);
    end;
    if I <= Length(LineStr) then
      Dec(I);
    if SpaceCount <> LeftOffset then
      CommentStr := GetLeftSpacing(LeftOffset - SpaceCount, WantTabs) + CommentStr;
    if I <= CaretX then
    begin
      SetCaretAndSelection(CaretXY, BufferCoord(I + 1, CaretY), CaretXY);
      ReplaceSel(CommentStr);
    end;
  end
  else
  begin
    TmpStr := GetLeftSpacing(SpaceCount, WantTabs);
    SelText := TmpStr + CommentStr;
  end;
  if not caretChanged then
    bCaret := CaretXY;
  if NextLineStr = '*/' then
  begin
    TmpStr := GetLeftSpacing(LeftOffset + 1, WantTabs);
    SelText := #13 + TmpStr + '*/';
  end;
  CaretXY := bCaret;
  EndUndoAction;
end;

function TEditor.RightSpacesEx(const Line: string; WantTabs: Boolean): Integer;
var
  p, pend: PChar;
begin
  p := pointer(Line);
  pend := p + Length(Line) - 1;
  if Assigned(p) then
  begin
    Result := 0;
    while (pend >= p) and CharInSet(pend^, [#1..#32]) do
    begin
      if (pend^ = #9) and WantTabs then
        Inc(Result, TabWidth)
      else
        Inc(Result);
      Dec(pend);
    end;
  end
  else
    Result := 0;
end;

procedure TEditor.AdvanceSpaceBreakLine(aLine: Integer;
  var LeftOffset: Integer; var Unindent: Boolean);
var
  wStart: TBufferCoord;
  PrevLine: String;
  token: UnicodeString;
  p, pt, sp, pend: PChar;
  j, i, k, tokenstart: Integer;
  CheckPrevLines, HasBreak, SkipComment: Boolean;
  attri: THighlighStyle;
begin
  Unindent := False;
  LeftOffset := 0;
  i := 0;
  k := 0;
  SkipComment := False;
  while aLine > 0 do
  begin
    PrevLine := Lines[aLine - 1];
    i := 0;
    k := 0;
    p := PChar(PrevLine);
    if p^ <> #0 then
      repeat
        if not CharInSet(p^, [#9, #32]) then Break;
        if p^ = #9 then
          Inc(k, TabWidth)
        else
          Inc(k);
        Inc(i);
        Inc(p);
      until p^ = #0;
    pt := PChar(PrevLine);
    Inc(pt, Length(PrevLine) - 1);
    if (p^ <> #0) and not SkipComment then
    begin
      p := PChar(PrevLine);
      pt := p + Length(PrevLine) - 1;
      while pt >= p do
      begin
        if not CharInSet(pt^, [#9, #32]) then Break;
        Dec(pt);
      end;
      if (pt - 1 >= p) and (pt^ = '/') and ((pt - 1)^ = '*') then
        SkipComment := True
      else
        Break;
      Dec(pt, 2);
    end;
    if SkipComment then
    begin
      p := PChar(PrevLine);
      while pt > p do
      begin
        if (pt^ = '*') and ((pt - 1)^ = '/') then Break;
        Dec(pt);
      end;
      if (pt > p) then
      begin
        //SkipComment := False;
        Break;
      end;
    end;
    Dec(aLine);
  end;
  if aLine = 0 then
    Exit;
  PrevLine := Lines[aLine - 1];
  p := PChar(PrevLine);
  pend := p + Length(PrevLine);
  if pend > p then
  begin
    repeat
      Dec(pend);
      if not CharInSet(pend^, [#9, #32]) then break;
    until pend <= p;
  end;
  if pend^ = '{' then
  begin
    Inc(k, TabWidth);
    LeftOffset := k;
    Exit;
  end;
  CheckPrevLines := False;
  HasBreak := False;
  wStart := BufferCoord(i + 1, aLine);
  if GetHighlighterAttriAtRowCol(wStart, token, attri) then
  begin
    if ((attri.name = HL_Style_InstructionWord) and
       ((token = 'if') or (token = 'case') or (token = 'while')
       or (token = 'else') or (token = 'for') or (token = 'default'))) or
       ((attri.name = HL_Style_TypeWord) and
       ((token = 'public') or (token = 'private') or (token = 'protected'))) or
       ((attri.name = 'Symbol') and (token = '{')) then
    begin
      if pend^ <> ';' then
        Inc(k, TabWidth);
      LeftOffset := k;
      Exit;
    end
    else
    begin
      CheckPrevLines := True;
      HasBreak := (attri.name = HL_Style_InstructionWord) and (token = 'break');
    end;
  end;
  // dont indent when single line statement block
  aLine := aLine - 1;
  while CheckPrevLines and (aLine > 0) do
  begin
    PrevLine := Lines[aLine - 1];
    if (Length(PrevLine) >= 1) then
    begin
      p := @PrevLine[1];
      j := 0;
      repeat
        if not CharInSet(p^, [#9, #32]) then break;
        Inc(j);
        Inc(p);
      until p^ = #0;
      if (p^ = '{') then
        Break;
      if p^ <> #0 then
      begin
        sp := @PrevLine[1];
        p := sp + Length(PrevLine) - 1;
        repeat
          if not CharInSet(p^, [#9, #32]) then break;
          Dec(p);
        until p < sp;
        if (p >= sp) and (p^ = '{') then
          Break;
        wStart := BufferCoord(j + 1, aLine); // TODO use collapsed line
        if GetHighlighterAttriAtRowCol(wStart, token, attri) then
        begin
          tokenstart := WordStartPosition(PositionRelative(0, RowColToCharIndex(wStart)), True);
          if ((attri.name = HL_Style_InstructionWord) and
            ((token = 'if') or (token = 'while') or (token = 'else')
            or (token = 'for'))) or HasBreak then
          begin
            if (tokenstart - 1 >= 0) then
            begin
              Unindent := True;
              LeftOffset := k - TabWidth;
              Exit;
            end;
          end;
        end;
        Break;
      end;
    end;
    Dec(aLine);
  end;
  LeftOffset := k;
end;

function TEditor.GetLastNonSpaceChar(const S: string): Char;
var
  p, pend: PChar;
begin
  Result := #0;
  p := Pointer(S);
  pend := p + Length(S) - 1;
  if Assigned(p) then
  begin
    while pend >= p do
    begin
      if not CharInSet(pend^, [#32, #9]) then
      begin
        Result := pend^;
        Break;
      end;
      Dec(pend);
    end;
  end;
end;

function TEditor.GetFirstNonSpaceChar(const S: string): Char;
var
  p: PChar;
begin
  Result := #0;
  p := Pointer(S);
  if Assigned(p) then
  begin
    while p^ <> #0 do
    begin
      if not CharInSet(p^, [#32, #9]) then
      begin
        Result := p^;
        Break;
      end;
      Inc(p);
    end;
  end;
end;

function TEditor.LeftSpacesEx(const Line: string; WantTabs: Boolean): Integer;
var
  p: PChar;
begin
  p := pointer(Line);
  if Assigned(p) then
  begin
    Result := 0;
    while CharInSet(p^, [#1..#32]) do
    begin
      if (p^ = #9) and (WantTabs) then
        Inc(Result, TabWidth)
      else
        Inc(Result);
      Inc(p);
    end;
  end
  else
    Result := 0;
end;

function TEditor.GetLeftSpacing(CharCount: Integer; WantTabs: Boolean): string;
begin
  if WantTabs and (CharCount >= TabWidth) then
    Result := StringOfChar(#9, CharCount div TabWidth) + StringOfChar(#32, CharCount mod TabWidth)
  else Result := StringOfChar(#32, CharCount);
end;

procedure TEditor.AddBreakpoint(Line: Integer);
begin
  MarkerAdd(Line - 1, MARK_BREAKPOINT);
  MarkerAdd(Line - 1, MARK_BREAKICON);
  Colourise(PositionFromLine(Line - 1), GetLineEndPosition(Line - 1));
end;

procedure TEditor.DeleteBreakpoint(Line: Integer);
begin
  MarkerDelete(Line - 1, MARK_BREAKPOINT);
  MarkerDelete(Line - 1, MARK_BREAKICON);
  Colourise(PositionFromLine(Line - 1), GetLineEndPosition(Line - 1));
end;

procedure TEditor.SetShowLineNumber(const Value: Boolean);
begin
  if FShowLineNumber = Value then
    Exit;
  FShowLineNumber := Value;
  if FShowLineNumber then
    SetMarginWidthN(MARGIN_LINE_NUMBER, GetLineMakerWidth)
  else
    SetMarginWidthN(MARGIN_LINE_NUMBER, 0);
  ApplyStyle(FLineNumberHighlight);
  UpdateFolderMarker;
end;    

procedure TEditor.SetActiveLine(Line: Integer);
begin
  MarkerAdd(Line - 1, MARK_CURRENTLINE);
  MarkerAdd(Line - 1, MARK_BREAKCURR);
  Colourise(PositionFromLine(Line - 1), GetLineEndPosition(Line - 1));
end;

procedure TEditor.RemoveActiveLine(Line: Integer);
begin
  MarkerDelete(Line - 1, MARK_CURRENTLINE);
  MarkerDelete(Line - 1, MARK_BREAKCURR);
  Colourise(PositionFromLine(Line - 1), GetLineEndPosition(Line - 1));
end;

procedure TEditor.SetImageList(const Value: TCustomImageList);
begin
  if FImageList = Value then
    Exit;
  FImageList := Value;
  UpdateMarginIcons;
end;

function TEditor.GetFont: TFont;
begin
  Result := inherited Font;
end;

procedure TEditor.SetFont(const Value: TFont);
begin
  inherited Font := Value;
end;

procedure TEditor.SetShowIndentGuides(const Value: Boolean);
begin
  if FShowIndentGuides = Value then
    Exit;
  FShowIndentGuides := Value;
  if FShowIndentGuides then
    SetIndentationGuides(SC_IV_LOOKFORWARD)
  else
    SetIndentationGuides(SC_IV_NONE);
end;

procedure TEditor.SetCaretColor(const Value: TColor);
begin
  if FCaretColor = Value then
    Exit;
  FCaretColor := Value;
  SetCaretFore(DSColor(FCaretColor));
end;

procedure TEditor.SetLinkColor(const Value: TColor);
begin
  if FLinkColor = Value then
    Exit;
  FLinkColor := Value;
  // set link color
  SetHotspotActiveFore(LinkColor <> clNone, DSColor(LinkColor));
end;

procedure TEditor.WMHotSpotFixClick(var Message: TMessage);
begin
  if Assigned(FOnHotSpotFixClick) then
    FOnHotSpotFixClick(Self, Message.WParam, Message.LParam);
end;

procedure TEditor.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if FHotspotModifiers <> 0 then
  begin
    PostMessage(Handle, WM_HOTSPOTFIXCLICK, FHotspotModifiers,
      FHotspotPosition);
    FHotspotModifiers := 0;
  end;
end;

end.

