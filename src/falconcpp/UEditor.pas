unit UEditor;

interface

uses
  Windows, Messages, Classes, Graphics, DScintilla, SynEdit, SynEditMiscClasses,
  SynEditTypes, DScintillaUtils, DScintillaTypes, Highlighter, Controls, Forms,
  ImgList;

const
  MARGIN_BOOKMARK = 1;
  MARGIN_LINE_NUMBER = 2;
  MARGIN_BREAKPOINT = 3;
  MARGIN_FOLD = 4;
  MARGIN_SPACE = 5;
  MARGIN_SPACE_END = 6;


  MARK_BREAKPOINT = 1;
  MARK_CURRENTLINE = 2;
  MARK_BREAKICON = 3;
  MARK_BREAKCURR = 4;
  MARK_BOOKMARK: array[0..9] of Integer = (5, 6, 7, 8, 9, 10,
    11, 12, 13, 14);
  
type
  TEditor = class(TDScintilla)
  private
    FActiveLineColor: TColor;
    FBookmarks: array of Integer;
    FHighlighter: THighlighter;
    FBracketHighlight: THighlighStyle;
    FBadBracketHighlight: THighlighStyle;
    FBracketHighlighting: Boolean;
    FOnScroll: TNotifyEvent;
    FSearchEngine: TSynEditSearchCustom;
    fOnMouseEnter: TMouseMoveEvent;
    fOnMouseLeave: TMouseMoveEvent;
    FFolding: Boolean;
    FShowLineNumber: Boolean;
    FImageList: TCustomImageList;
    procedure BracketHighlightChanged(Sender: TObject);
    procedure HighlighterChanged(Sender: TObject);
    function GetModified: Boolean;
    function GetDisplayY: Integer;
    function GetDisplayX: Integer;
    function GetSelText: UnicodeString;
    procedure SetSelText(const Value: UnicodeString);
    function GetSearchEngine: TSynEditSearchCustom;
    procedure SetSearchEngine(const Value: TSynEditSearchCustom);
    function GetBlockEnd: TBufferCoord;
    procedure SetBlockEnd(const Value: TBufferCoord);
    function GetCaretXY: TBufferCoord;
    procedure SetCaretXY(const Value: TBufferCoord);
    function GetBlockBegin: TBufferCoord;
    procedure SetBlockBegin(const Value: TBufferCoord);
    function GetLineHeight: Integer;
    procedure SetLineHeight(const Value: Integer);
    function GetSelStart: Integer;
    procedure SetSelStart(const Value: Integer);
    function GetSelLength: Integer;
    function GetCaretX: Integer;
    function GetCaretY: Integer;
    procedure SetCaretX(const Value: Integer);
    procedure SetCaretY(const Value: Integer);
    procedure SetActiveLineColor(const Value: TColor);
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
    procedure SetBracketHighlighting(const Value: Boolean);
    procedure DoBraceMatch;
    procedure FindMatchingBracePos(caretPos: Integer; var braceAtCaret, braceOpposite: Integer);
    function GetLineText: UnicodeString;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetFolding(const Value: Boolean);
    procedure UpdateFolderMarker(Style: THighlighStyle);
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
  protected
    procedure DoScroll; virtual;
    function DoSCNotification(const ASCNotification: TDSciSCNotification): Boolean;
      override;
    procedure MouseEnter(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LockFoldUpdate;
    procedure Init;
    procedure UnlockFoldUpdate;
    function GetLineMakerWidth: Integer;
    procedure UncollapseLine(Line: Integer);
    procedure SetCaretAndSelection(const caret, b, c: TBufferCoord);
    procedure GotoLineAndCenter(Line: Integer);
    function PixelsToRowColumn(x, y: Integer): TDisplayCoord;
    function IsPointInSelection(const rowcol: TBufferCoord): Boolean;
    function GetWordAtRowCol(const rowcol: TBufferCoord): UnicodeString;
    function PrevWordPos: TBufferCoord;
    function SelAvail: Boolean;
    function RowColToCharIndex(const rowcol: TBufferCoord): Integer;
    function RowColumnToPixels(const Display: TDisplayCoord): TPoint;
    function BufferToDisplayPos(const rowcol: TBufferCoord): TDisplayCoord;
    function DisplayToBufferPos(const Display: TDisplayCoord): TBufferCoord;
    function SearchReplace(const s, r: UnicodeString; const options: TSynSearchOptions): Integer;
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
    function GetHighlighterAttriAtRowCol(const rowcol: TBufferCoord;
      var S: UnicodeString; var Style: THighlighStyle): Boolean;
    procedure ProcessCloseBracketChar;
    procedure ProcessBreakLine;
    procedure AddBreakpoint(Line: Integer);
    procedure DeleteBreakpoint(Line: Integer); 
    procedure SetActiveLine(Line: Integer);
    procedure RemoveActiveLine(Line: Integer);

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
    property SearchEngine: TSynEditSearchCustom read GetSearchEngine write SetSearchEngine;
    property BlockBegin: TBufferCoord read GetBlockBegin write SetBlockBegin;
    property BlockEnd: TBufferCoord read GetBlockEnd write SetBlockEnd;
    property WordEnd: TBufferCoord read GetWordEnd;
    property CaretXY: TBufferCoord read GetCaretXY write SetCaretXY;
    property CaretY: Integer read GetCaretY write SetCaretY;
    property CaretX: Integer read GetCaretX write SetCaretX;
    property LineHeight: Integer read GetLineHeight write SetLineHeight;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property ActiveLineColor: TColor read FActiveLineColor write SetActiveLineColor;
    property InsertMode: Boolean read GetInsertMode write SetInsertMode;
    property Highlighter: THighlighter read FHighlighter write SetHighlighter;
    property Folding: Boolean read FFolding write SetFolding;
    property BracketHighlighting: Boolean read FBracketHighlighting write SetBracketHighlighting;
    property ShowLineNumber: Boolean read FShowLineNumber write SetShowLineNumber;
    property BracketHighlight: THighlighStyle read FBracketHighlight;
    property BadBracketHighlight: THighlighStyle read FBadBracketHighlight;   
    property ImageList: TCustomImageList read FImageList write SetImageList;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnMouseEnter: TMouseMoveEvent read fOnMouseEnter write fOnMouseEnter;
    property OnMouseLeave: TMouseMoveEvent read fOnMouseLeave write fOnMouseLeave;
  end;

implementation

uses
  SysUtils, UnicodeUtils, CustomColors, Contnrs, UUtils;

{ TEditor }

constructor TEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActiveLineColor := clNone;
  FBracketHighlight := THighlighStyle.Create(STYLE_BRACELIGHT, 'Brace Highlighting');
  FBracketHighlight.OnChange := BracketHighlightChanged;
  FBadBracketHighlight := THighlighStyle.Create(STYLE_BRACEBAD, 'Bad Brace Highlighting');
  FBadBracketHighlight.OnChange := BracketHighlightChanged;
  SetLength(FBookmarks, 10);
end;

procedure TEditor.Init;
const
  marker: array[0..6] of Integer = (SC_MARKNUM_FOLDER, SC_MARKNUM_FOLDEROPEN,
    SC_MARKNUM_FOLDERTAIL, SC_MARKNUM_FOLDERSUB, SC_MARKNUM_FOLDEREND,
    SC_MARKNUM_FOLDEROPENMID, SC_MARKNUM_FOLDERMIDTAIL);
var
  I, Mask: Integer;
  ImageWidth, ImageHeight: Integer;
  ImgPtr: PAnsiChar;
begin
  SetProperty('fold.compact', '0');
  SetProperty('fold.comment', '1');
  SetProperty('fold.preprocessor', '1');
  SetProperty('lexer.cpp.track.preprocessor', '0');

  SetMarginWidthN(MARGIN_BOOKMARK, 16);
  SetMarginWidthN(MARGIN_LINE_NUMBER, GetLineMakerWidth);
  SetMarginWidthN(MARGIN_BREAKPOINT, 14);
  SetMarginWidthN(MARGIN_FOLD, 14);
  SetMarginWidthN(MARGIN_SPACE, 1);
  SetMarginWidthN(MARGIN_SPACE_END, 1);
                                                       
  SetMarginTypeN(MARGIN_BOOKMARK, SC_MARGIN_SYMBOL);
  SetMarginTypeN(MARGIN_LINE_NUMBER, SC_MARGIN_NUMBER);
  SetMarginTypeN(MARGIN_BREAKPOINT, SC_MARGIN_SYMBOL);
  SetMarginTypeN(MARGIN_FOLD, SC_MARGIN_SYMBOL);
  SetMarginTypeN(MARGIN_SPACE, SC_MARGIN_BACK);
  SetMarginTypeN(MARGIN_SPACE_END, SC_MARGIN_BACK);

  Mask := 0;
  for I := 0 to 9 do
    Mask := Mask or (1 shl MARK_BOOKMARK[I]);
  SetMarginMaskN(MARGIN_BOOKMARK, Mask);  
  SetMarginMaskN(MARGIN_LINE_NUMBER, 0);
  SetMarginMaskN(MARGIN_BREAKPOINT, (1 shl MARK_BREAKICON) or
    (1 shl MARK_BREAKCURR));
  SetMarginMaskN(MARGIN_FOLD, Integer(SC_MASK_FOLDERS));
  SetMarginMaskN(MARGIN_SPACE, 0);
  SetMarginMaskN(MARGIN_SPACE_END, 0);
  SetScrollWidthTracking(True);
  SetScrollWidth(1);

  MarkerDefine(SC_MARKNUM_FOLDER, SC_MARK_BOXPLUS);
  MarkerDefine(SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS);
  MarkerDefine(SC_MARKNUM_FOLDERTAIL, SC_MARK_LCORNER);
  MarkerDefine(SC_MARKNUM_FOLDERSUB, SC_MARK_VLINE);
  MarkerDefine(SC_MARKNUM_FOLDEREND, SC_MARK_BOXPLUSCONNECTED);
  MarkerDefine(SC_MARKNUM_FOLDEROPENMID, SC_MARK_BOXMINUSCONNECTED);
  MarkerDefine(SC_MARKNUM_FOLDERMIDTAIL, SC_MARK_TCORNER);

  for I := 0 to 6 do
  begin
    MarkerSetFore(marker[I], RGB($FF, $FF, $FF));
    MarkerSetBack(marker[I], RGB($80, $80, $80));
    MarkerSetBackSelected(marker[i], RGB(255, 0, 0));
  end;
  // Breakpoint line
	MarkerDefine(MARK_BREAKPOINT, SC_MARK_BACKGROUND);
	MarkerSetBack(MARK_BREAKPOINT, DSColor(clRed));
  MarkerSetFore(MARK_BREAKPOINT, DSColor(clWhite));
  MarkerSetAlpha(MARK_BREAKPOINT, 70);
  // current breakpoint line
	MarkerDefine(MARK_CURRENTLINE, SC_MARK_BACKGROUND);
	MarkerSetBack(MARK_CURRENTLINE, DSColor(clNavy));
  MarkerSetFore(MARK_CURRENTLINE, DSColor(clWhite));
  MarkerSetAlpha(MARK_CURRENTLINE, 70);
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
  MarkerEnableHighlight(True);                 
  SetMarginSensitiveN(MARGIN_BOOKMARK, True);
  SetMarginSensitiveN(MARGIN_LINE_NUMBER, True);
  SetMarginSensitiveN(MARGIN_BREAKPOINT, True);
  SetMarginSensitiveN(MARGIN_FOLD, True);
  SetFoldFlags(SC_FOLDFLAG_LINEAFTER_CONTRACTED); // 16  	Draw line below if not expanded
  SetIndentationGuides(SC_IV_LOOKFORWARD);
end;

procedure TEditor.UpdateFolderMarker(Style: THighlighStyle);
begin
  MarkerSetFore(MARGIN_FOLD, DSColor(Style.Background));
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
  Result.Column := GetColumn(Position) + 1;
end;

function TEditor.CharIndexToRowCol(index: Integer): TBufferCoord;
begin
  Result.Line := LineFromPosition(index) + 1;
  Result.Char := index - PositionFromLine(Result.Line - 1) + 1;
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
  FoldLine(CaretY, SC_FOLDACTION_CONTRACT);
end;

procedure TEditor.CopyToClipboard;
begin
  Copy;
end;

procedure TEditor.CutToClipboard;
begin
  Cut;
end;

destructor TEditor.Destroy;
begin
  SetHighlighter(nil); // remove hook from highlighter change list
  FBadBracketHighlight.Free;
  FBracketHighlight.Free;
  inherited;
end;

function TEditor.DisplayToBufferPos(
  const Display: TDisplayCoord): TBufferCoord;
begin
  Result := CharIndexToRowCol(FindColumn(Display.Row - 1, Display.Column - 1));
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
end;

procedure TEditor.EndUpdate;
begin
  UpdateLineMargin;
end;

function TEditor.GetBlockBegin: TBufferCoord;
begin
  Result := CharIndexToRowCol(GetSelectionStart);
end;

function TEditor.GetBlockEnd: TBufferCoord;
begin
  Result := CharIndexToRowCol(GetSelectionEnd);
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
begin
  Result := CharIndexToRowCol(GetCurrentPos);
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

function TEditor.GetSearchEngine: TSynEditSearchCustom;
begin
  Result := FSearchEngine;
end;

procedure TEditor.SetSelLength(const Value: Integer);
begin
  SetSelectionEnd(GetSelectionStart + Value);
end;

function TEditor.GetSelStart: Integer;
begin
  Result := GetSelectionStart;
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
  I, StartPos, EndPos: Integer;
begin
  I := PositionFromLine(rowcol.Line - 1) + rowcol.Char - 1;
  StartPos := WordStartPosition(I, True);
  EndPos := WordEndPosition(I, True);
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
  CaretXY := CharIndexToRowCol(PositionFromLine(Line));
end;

procedure TEditor.GotoLineAndCenter(Line: Integer);
begin
  //TODO:
  SetCaretY(Line);
  SetTopLine(Line - (LinesInWindow div 2));
end;

procedure TEditor.InvalidateLine(Line: Integer);
begin
  //TODO:
end;

function TEditor.IsPointInSelection(const rowcol: TBufferCoord): Boolean;
var
  Position: Integer;
begin
  Position := RowColToCharIndex(rowcol);
  Result := (GetSelectionStart >= Position) and (Position <= GetSelectionEnd);
end;

procedure TEditor.LockFoldUpdate;
begin
  //TODO:
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
  LineEndPos: Integer;
begin
  Result := PositionFromLine(rowcol.Line - 1);
  LineEndPos := GetLineEndPosition(rowcol.Line - 1);
  if rowcol.Char - 1 > LineEndPos - Result then
    Result := LineEndPos
  else
    Result := Result + rowcol.Char - 1;
end;

function TEditor.RowColumnToPixels(const Display: TDisplayCoord): TPoint;
var
  Position: Integer;
begin
  // FIX: incompatible conversion on middle of tab character
  Position := RowColToCharIndex(DisplayToBufferPos(Display));
  Result.X := PointXFromPosition(Position);
  Result.Y := PointYFromPosition(Position);
end;

function TEditor.SearchReplace(const s, r: UnicodeString;
  const options: TSynSearchOptions): Integer;
begin
  //TODO:
  Result := 0;
end;

function TEditor.SelAvail: Boolean;
begin
  Result := not GetSelectionEmpty;
end;

procedure TEditor.SetActiveLineColor(const Value: TColor);
begin
  if FActiveLineColor = Value then
    Exit;
  FActiveLineColor := Value;
  SetCaretLineBack(DSColor(Value));
  SetCaretLineVisible(FActiveLineColor <> clNone);
end;

procedure TEditor.SetBlockBegin(const Value: TBufferCoord);
begin
  SetSelectionStart(RowColToCharIndex(Value));
end;

procedure TEditor.SetBlockEnd(const Value: TBufferCoord);
begin
  SetSelectionEnd(RowColToCharIndex(Value));
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

procedure TEditor.SetCaretX(const Value: Integer);
begin
  SetCaretXY(BufferCoord(Value, CaretY));
end;

procedure TEditor.SetCaretXY(const Value: TBufferCoord);
begin
  //TODO:
  SetEmptySelection(RowColToCharIndex(Value));
  ScrollCaret;
end;

procedure TEditor.SetCaretY(const Value: Integer);
begin
  // FIX: possible invalid char position
  SetCaretXY(BufferCoord(CaretX, Value));
end;

procedure TEditor.SetLineHeight(const Value: Integer);
begin
  //TODO:
end;

procedure TEditor.SetSearchEngine(const Value: TSynEditSearchCustom);
begin
  if FSearchEngine = Value then
    Exit;
  FSearchEngine := Value;
end;

function TEditor.GetSelLength: Integer;
begin
  // FIX: problem with multi selection
  Result := GetSelectionEnd - GetSelectionStart;
end;

procedure TEditor.SetSelStart(const Value: Integer);
begin
  SetSelectionStart(Value);
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
  ShowLines(startLine, endLine);
end;

procedure TEditor.UnlockFoldUpdate;
begin
  //TODO:
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
  I := RowColToCharIndex(rowcol);
  StartPos := WordStartPosition(I, True);
  Result := CharIndexToRowCol(StartPos);
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
  SetStyleBits(5);
  FHighlighter.SetKeyWords(SetKeyWords);
  UpdateStyles;
end;

procedure TEditor.UpdateStyles;
var
  I: Integer;
begin
  for I := 0 to FHighlighter.StyleCount - 1 do
    ApplyStyle(FHighlighter[I]);
  UpdateLineMargin;
end;

procedure TEditor.SetBracketHighlighting(const Value: Boolean);
begin
  if Value = FBracketHighlighting then
    Exit;
  FBracketHighlighting := Value;
  ApplyStyle(FBracketHighlight);
  ApplyStyle(FBadBracketHighlight);
end;

procedure TEditor.DoUpdateUI(AUpdated: Integer);
begin
  if ((AUpdated and SC_UPDATE_V_SCROLL) = SC_UPDATE_V_SCROLL) or
    ((AUpdated and SC_UPDATE_H_SCROLL) = SC_UPDATE_H_SCROLL) then
    DoScroll;
  DoBraceMatch;
end;

procedure TEditor.DoBraceMatch;
var
  braceAtCaret, braceOpposite: Integer;
  columnAtCaret, columnOpposite: Integer;
begin
  braceAtCaret := -1;
  braceOpposite := -1;
  FindMatchingBracePos(GetCurrentPos, braceAtCaret, braceOpposite);

  if ((braceAtCaret <> -1) and (braceOpposite = -1)) then
  begin
    BraceBadLight(braceAtCaret);
    SetHighlightGuide(0);
  end
  else
  begin
    BraceHighlight(braceAtCaret, braceOpposite);

    if (True {isShownIndentGuide()}) then
    begin
      columnAtCaret := GetColumn(braceAtCaret);
      columnOpposite := GetColumn(braceOpposite);
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
{$IFDEF SYN_MBCSSUPPORT}
          if (Test in LeadBytes) then
          begin
            Inc(PosX);
            Continue;
          end;
{$ENDIF}
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
var
  DefStyle: THighlighStyle;
  DefBack: TColor;
begin
  DefBack := clWhite;
  DefStyle := FHighlighter.FindStyleByID(SCE_C_DEFAULT);
  if (DefStyle <> nil) and (DefStyle.Background <> clNone) then
    DefBack := DefStyle.Background;
  StyleSetSize(Style.ID, DefStyle.FontSize);
  StyleSetFont(Style.ID, DefStyle.FontName);
  StyleSetFore(Style.ID, DSColor(Style.Foreground, clBlack));
  StyleSetBack(Style.ID, DSColor(Style.Background, DefBack));
  StyleSetBold(Style.ID, fsBold in Style.Style);
  StyleSetItalic(Style.ID, fsItalic in Style.Style);
  StyleSetUnderline(Style.ID, fsUnderline in Style.Style);
  StyleSetHotSpot(Style.ID, Style.Hotspot);
  if Style.ID = STYLE_DEFAULT then
  begin
    BracketHighlight.FontName := DefStyle.FontName;
    BracketHighlight.FontSize := DefStyle.FontSize + 2;
    BadBracketHighlight.FontName := DefStyle.FontName;
    BadBracketHighlight.FontSize := DefStyle.FontSize;
  end
  else
    if Style.ID = SCE_C_DEFAULT then
    begin
      DefStyle := FHighlighter.FindStyleByID(STYLE_DEFAULT);
      if DefStyle <> nil then
      begin
        DefStyle.Background := Style.Background;
        DefStyle.FontSize := Style.FontSize;
        DefStyle.FontName := Style.FontName;
      end;
      UpdateFolderMarker(Style);
    end;
end;

procedure TEditor.BracketHighlightChanged(Sender: TObject);
begin
  if not FBracketHighlighting then
    Exit;
  ApplyStyle(THighlighStyle(Sender));
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
  Colourise(0, -1);
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
  FindMatchingBracePos(RowColToCharIndex(rowcol), braceAtCaret, braceOpposite);

  if ((braceAtCaret <> -1) and (braceOpposite = -1)) then
  begin
    Result.Char := 0;
    Result.Line := 0;
  end
  else
    Result := CharIndexToRowCol(braceOpposite);
end;

function TEditor.GetHighlighterAttriAtRowCol(const rowcol: TBufferCoord;
  var S: UnicodeString; var Style: THighlighStyle): Boolean;
var
  APosition, StyleID: Integer;
  AStyle: THighlighStyle;
begin
  Result := False;
  APosition := RowColToCharIndex(rowcol);
  StyleID := GetStyleAt(APosition);
  if (StyleID = 0) or (Highlighter = nil) then
    Exit;
  AStyle := Highlighter.FindStyleByID(StyleID);
  Result := AStyle <> nil;
  if Result then
  begin
    Style := AStyle;
    S := GetWordAtRowCol(rowcol);
  end;
end;

procedure TEditor.SetFolding(const Value: Boolean);
begin
  if FFolding = Value then
    Exit;
  FFolding := Value;
  SetProperty('fold', IntToStr(Integer(FFolding)));
end;

function TEditor.GetWordEnd: TBufferCoord;
begin
  Result := CharIndexToRowCol(WordEndPosition(GetCurrentPos, True));
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
    bCaret.Char := LeftOffset + 1;
    TmpStr := GetLeftSpacing(LeftOffset, WantTabs);
    Lines.Insert(CaretY - 1, TmpStr);
    CaretY := bCaret.Line + 1;
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
    while (pend >= p) and (pend^ in [#1..#32]) do
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
        if not (p^ in [#9, #32]) then Break;
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
        if not (pt^ in [#9, #32]) then Break;
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
      if not (pend^ in [#9, #32]) then break;
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
        if not (p^ in [#9, #32]) then break;
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
          if not (p^ in [#9, #32]) then break;
          Dec(p);
        until p < sp;
        if (p >= sp) and (p^ = '{') then
          Break;
        wStart := BufferCoord(j + 1, aLine); // TODO use collapsed line
        if GetHighlighterAttriAtRowCol(wStart, token, attri) then
        begin
          tokenstart := WordStartPosition(RowColToCharIndex(wStart), True); 
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
      if not (pend^ in [#32, #9]) then
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
      if not (p^ in [#32, #9]) then
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
    while p^ in [#1..#32] do
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
  Colourise(0, -1);
end;

procedure TEditor.DeleteBreakpoint(Line: Integer);
begin
  MarkerDelete(Line - 1, MARK_BREAKPOINT);
  MarkerDelete(Line - 1, MARK_BREAKICON);
  Colourise(0, -1);
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
end;    

procedure TEditor.SetActiveLine(Line: Integer);
begin
  MarkerAdd(Line - 1, MARK_CURRENTLINE);
  MarkerAdd(Line - 1, MARK_BREAKCURR);
  Colourise(0, -1);
end;

procedure TEditor.RemoveActiveLine(Line: Integer);
begin
  MarkerDelete(Line - 1, MARK_CURRENTLINE);
  MarkerDelete(Line - 1, MARK_BREAKCURR);
  Colourise(0, -1);
end;

procedure TEditor.SetImageList(const Value: TCustomImageList);
begin
  if FImageList = Value then
    Exit;
  FImageList := Value;
end;

end.

