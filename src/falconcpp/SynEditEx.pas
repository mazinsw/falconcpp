unit SynEditEx;

interface

uses
  Windows, Forms, Controls, Messages, Classes, SynEdit, SynEditHighlighter, Graphics,
  SynEditTypes, SynEditStrConst,SynEditTextBuffer;

const
  DirectivesNames: array[0..10] of String = (
    'include', 'defined', 'if', 'ifndef', 'else', 'pragma', 'endif', 'elif',
    'ifdef', 'define', 'undef'
  );

type
  TLinkClickEvent = procedure(Sender: TObject; Word, Attri, FirstWord: String)
    of object;

  TSynBracketHighlight = class(TPersistent)
  private
    fBackground: TColor;
    fForeground: TColor;
    fAloneBackground: TColor;
    fAloneForeground: TColor;
    fStyle: TFontStyles;
    fAloneStyle: TFontStyles;
    procedure SetStyle(Value: TFontStyles);
    procedure SetAloneStyle(Value: TFontStyles);
  public
    constructor Create;
  published
    property Background: TColor read fBackground write fBackground;
    property Foreground: TColor read fForeground write fForeground;
    property AloneBackground: TColor read fAloneBackground write fAloneBackground;
    property AloneForeground: TColor read fAloneForeground write fAloneForeground;
    property Style: TFontStyles read fStyle write SetStyle;
    property AloneStyle: TFontStyles read fAloneStyle write SetAloneStyle;
  end;

  TSynLinkOptions = class(TPersistent)
  private
    fColor: TColor;
    fAttributeList: TStrings;
    procedure SetAttriList(Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Color: TColor read fColor write fColor;
    property AttributeList: TStrings read fAttributeList write SetAttriList;
  end;

  TSynEditEx = class(TSynEdit)
  private
    fBracketHighlight: TSynBracketHighlight;
    fBracketHighlighting: Boolean;
    fOnLinkClick: TLinkClickEvent;
    fLinkOptions: TSynLinkOptions;
    fLinkEnable: Boolean;
    fLinkCount: Integer;
    fLastLinkLine: Integer;
    LWS, LWE: TBufferCoord;
    fCurrShiftState: TShiftState;
    fOnMouseEnter: TMouseMoveEvent;
    fOnMouseLeave: TMouseMoveEvent;
    fLastKeyPressed: Char;
    fCurrentKeyPressed: Char;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function ProcessLinkClick(X, Y: Integer): Boolean;
    procedure ProcessHighlighterLink;
    procedure PaintBracket(Sender: TObject; Canvas: TCanvas;
      TransientType: TTransientType);
    procedure DoLinkClick(Word, Attri, FirstWord: String);
    procedure PaintLink(TransientType: TTransientType);
    procedure AdvanceSpaceBreakLine(aLine: Integer; var LeftOffset: Integer;
      var Unindent: Boolean);
    procedure ProcessBreakLine;
    procedure ProcessCloseBracketChar;
    function GetLeftSpacing(CharCount: Integer; WantTabs: Boolean): String;
    function LeftSpacesEx(const Line: string; WantTabs: Boolean): Integer;
    function RightSpacesEx(const Line: string; WantTabs: Boolean): Integer;
    procedure ReplaceText(const S: string; aBlockBegin,
      aBlockEnd: TBufferCoord);
    function GetLastNonSpaceChar(const S: string): Char;
    function GetFirstNonSpaceChar(const S: string): Char;
  protected
    procedure DoDeleteLastCharBeforeCaret(SpaceLen: Integer;
      var SpaceCount: Integer); override;
    procedure DoTabKeyIndent(MinLen: Integer; var I: Integer); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
      Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseEnter(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoExit; override;
    procedure DoEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ToggleLineComment;
    function GetBalancingBracketEx(const APoint: TBufferCoord;
      Bracket: Char): Integer;
    property LinkEnable: Boolean read fLinkEnable write fLinkEnable;
    property LinkOptions: TSynLinkOptions
      read fLinkOptions write fLinkOptions;
    property BracketHighlighting: Boolean read fBracketHighlighting
      write fBracketHighlighting;
    property BracketHighlight: TSynBracketHighlight
      read fBracketHighlight write fBracketHighlight;
    property OnMouseEnter: TMouseMoveEvent read fOnMouseEnter write fOnMouseEnter;
    property OnMouseLeave: TMouseMoveEvent read fOnMouseLeave write fOnMouseLeave;
    property OnLinkClick: TLinkClickEvent read fOnLinkClick write fOnLinkClick;
		property OnContextPopup;
    property LastKeyPressed: Char read fLastKeyPressed;
  end;

implementation


uses
  SysUtils, Contnrs;

function GetFirstWord(const S: String): String;
const
  LetterChars: set of Char = ['A'..'Z', 'a'..'z', '_'];
  DigitChars:  set of Char = ['0'..'9'];
var
  Len, RLen, I: Integer;
begin
  Result := '';
  RLen := 0;
  I := 1;
  Len := Length(S);
  while(I <= Len) do
  begin
    if(RLen > 0) and not (S[I] in LetterChars+DigitChars) then
       Break
    else if (S[I] in LetterChars+DigitChars) then
    begin
       Result := Result + S[I];
       Inc(RLen);
    end;
    Inc(I);
  end;
end;

function WordIn(const S: String; List: Array of String): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I:= Low(List) to High(List) do
    if S = List[I] then
      Exit;
  Result := False;
end;

function CharExtreme(const S1, S2: String; C1, C2: Char): Boolean;
var
  p, pend: PChar;
begin
  p := Pchar(S1);
  pend := p + Length(S1);
  if pend > p then
  begin
    repeat
      Dec(pend);
      if not (pend^ in [#9, #32]) then break;
    until pend <= p;
  end;
  if pend^ <> C1 then
  begin
    Result := False;
    Exit;
  end;
  p := Pchar(S2);
  if p^ <> #0 then
  begin
    repeat
      if not (p^ in [#9, #32]) then break;
      Inc(p);
    until p^ = #0;
  end;
  if p^ <> C2 then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
end;

{TSynBracketHighlight}

procedure TSynBracketHighlight.SetStyle(Value: TFontStyles);
begin
  if fStyle <> Value then begin
    fStyle := Value;
  end;
end;

procedure TSynBracketHighlight.SetAloneStyle(Value: TFontStyles);
begin
  if fAloneStyle <> Value then begin
    fAloneStyle := Value;
  end;
end;

constructor TSynBracketHighlight.Create;
begin
  inherited Create;
  fBackground := clSkyBlue;
  fForeground := clBlue;
  fAloneBackground := clNone;
  fAloneForeground := clRed;
  fAloneStyle := [fsBold];
  fStyle := [fsBold];
end;

{TSynLinkOptions}

constructor TSynLinkOptions.Create;
begin
  inherited Create;
  fColor := clBlue;
  fAttributeList := TStringList.Create;
end;

destructor TSynLinkOptions.Destroy;
begin
  fAttributeList.Free;
  inherited Create;
end;

procedure TSynLinkOptions.SetAttriList(Value: TStrings);
begin
  if Assigned(Value) then
    fAttributeList.Assign(Value);
end;

{TSynEditEx}

constructor TSynEditEx.Create(AOwner: TComponent);
begin
  inherited;
  fBracketHighlighting := False;
  fBracketHighlight := TSynBracketHighlight.Create;
  OnPaintTransient := PaintBracket;
  fLinkOptions := TSynLinkOptions.Create;
  fLinkEnable := True;
  fLinkOptions.AttributeList.Add(SYNS_AttrPreprocessor);
  fLinkOptions.AttributeList.Add(SYNS_AttrIdentifier);
  fCurrShiftState := [];
end;

destructor TSynEditEx.Destroy;
begin
  fBracketHighlight.Free;
  fLinkOptions.Free;
  inherited;
end;

procedure TSynEditEx.KeyUp(var Key: Word; Shift: TShiftState);
begin
  fCurrShiftState := Shift;
  if not (ssCtrl in fCurrShiftState) then
  begin
    Cursor := crIBeam;
    if fLinkCount > 0 then
    begin
      LWS := BufferCoord(0, 0);
      LWE := BufferCoord(0, 0);
      fLinkCount := 0;
      InvalidateLine(fLastLinkLine);
    end;
  end;
  inherited;
end;

procedure TSynEditEx.KeyDown(var Key: Word; Shift: TShiftState);
begin
  fCurrShiftState := Shift;
  inherited;
  if fLinkEnable then
    ProcessHighlighterLink;
end;

procedure TSynEditEx.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  fCurrShiftState := Shift;
  inherited;
end;

procedure TSynEditEx.KeyPress(var Key: Char);
begin
  fLastKeyPressed := fCurrentKeyPressed;
  fCurrentKeyPressed := Key;
  inherited;
  if Key = '}' then
    ProcessCloseBracketChar
  else if Key = #13 then
    ProcessBreakLine;
end;

procedure TSynEditEx.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  fCurrShiftState := Shift;
  inherited;
  if fLinkEnable then
    ProcessHighlighterLink;
end;

procedure TSynEditEx.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  fCurrShiftState := Shift;
  inherited;
  if (ssCtrl in fCurrShiftState) and fLinkEnable then
  begin
    if Button = mbLeft then
      if ProcessLinkClick(X, Y) then Exit;
  end;
end;

procedure TSynEditEx.AdvanceSpaceBreakLine(aLine: Integer;
  var LeftOffset: Integer; var Unindent: Boolean);
var
  wStart: TBufferCoord;
  token, PrevLine: String;
  p, pt, sp, pend: PChar;
  j, i, k, tokentype, tokenstart: Integer;
  CheckPrevLines, HasBreak, SkipComment: Boolean;
  attri: TSynHighlighterAttributes;
begin
  Unindent := False;
  LeftOffset := 0;
  i := 0;
  k := 0;
  SkipComment := False;
  while aLine >= 0 do
  begin
    PrevLine := Lines[aLine];
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
  if aLine < 0 then
    Exit;
  PrevLine := Lines[aLine];
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
  wStart := BufferCoord(i + 1, aLine + 1);
  if GetHighlighterAttriAtRowCol(wStart, token, attri) then
  begin
    if ((attri.name = SYNS_AttrInstructionWord) and
       ((token = 'if') or (token = 'case') or (token = 'while')
       or (token = 'else') or (token = 'for') or (token = 'default'))) or
       ((attri.name = SYNS_AttrTypeWord) and
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
      HasBreak := (attri.name = SYNS_AttrInstructionWord) and (token = 'break');
    end;
  end;
  // dont indent when single line statement block
  aLine := aLine - 1;
  while CheckPrevLines and (aLine >= 0) do
  begin
    PrevLine := Lines[aLine];
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
        wStart := BufferCoord(j + 1, aLine + 1);
        if GetHighlighterAttriAtRowColEx(wStart, token, tokentype, tokenstart,
            attri) then
        begin
          if ((attri.name = SYNS_AttrInstructionWord) and
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

procedure TSynEditEx.DoLinkClick(Word, Attri, FirstWord: String);
begin
  if Assigned(fOnLinkClick) then
    fOnLinkClick(Self, Word, Attri, FirstWord);
end;

function TSynEditEx.ProcessLinkClick(X, Y: Integer): Boolean;
var
  P: TBufferCoord;
  MousePos: TPoint;
  S, Word, FirstWord: String;
  Attri: TSynHighlighterAttributes;
  I: integer;
begin
  Result := False;
  if not (ssCtrl in fCurrShiftState) then Exit;
  MousePos := ScreenToClient(Mouse.CursorPos);
  P := DisplayToBufferPos(PixelsToRowColumn(MousePos.X, MousePos.Y));
  if IsPointInSelection(P) then
  begin
    fLinkCount := 0;
    fLastLinkLine := 0;
    LWS.Char := 0;
    LWS.Line := 0;
    LWE.Char := 0;
    LWE.Line := 0;
    Exit;
  end;

  if not GetHighlighterAttriAtRowCol(P, S, Attri) then Exit;
  if fLinkOptions.AttributeList.IndexOf(Attri.Name) < 0 then Exit;
  Word := GetWordAtRowCol(P);
  if Length(Word) = 0 then Exit;
  if WordIn(Word, DirectivesNames) and (Pos('#', S) > 0) then Exit;
  if (Pos('#', S) > 0) and (Pos('include', S) > 0) then
  begin
    I := Pos('<', S);
    if I = 0 then I := Pos('"', S);
    if I = 0 then Exit;
    Word := Copy(S, I + 1, Length(S) - I);
    I := Pos('>', Word);
    if I = 0 then I := Pos('"', Word);
    if I = 0 then Exit;
    Word := Copy(Word, 1, I - 1);
    Word := Trim(Word);
  end;
  FirstWord := GetFirstWord(S);
  DoLinkClick(Word, Attri.Name, FirstWord);
  Result := Assigned(fOnLinkClick);
end;

procedure TSynEditEx.PaintLink(TransientType: TTransientType);

  function CharToPixels(P: TBufferCoord): TPoint;
  begin
    Result:= RowColumnToPixels(BufferToDisplayPos(P));
  end;

var
  P, WS, WE, MouseBuffer: TBufferCoord;
  MousePos, Pt: TPoint;
  S, Word: String;
  ptr: PChar;
  I, rgbVal: Integer;
  Attri: TSynHighlighterAttributes;
begin
  if not (ssCtrl in fCurrShiftState) then Exit;
  MousePos := ScreenToClient(Mouse.CursorPos);
  P := DisplayToBufferPos(PixelsToRowColumn(MousePos.X, MousePos.Y));
  MouseBuffer := P;
  if IsPointInSelection(P) then
  begin
    fLinkCount := 0;
    LWS.Char := 0;
    LWS.Line := 0;
    LWE.Char := 0;
    LWE.Line := 0;
    Exit;
  end;
  if not GetHighlighterAttriAtRowCol(P, S, Attri) then Exit;
  if fLinkOptions.AttributeList.IndexOf(Attri.Name) < 0 then Exit;
  Word := GetWordAtRowCol(P);
  if Length(Word) = 0 then Exit;
  if WordIn(Word, DirectivesNames) and (Pos('#', S) > 0) then Exit;
  WS := WordStartEx(P);
  WE := WordEndEx(P);
  if (Pos('#', S) > 0) and (Pos('include', S) > 0) then
  begin
    I := Pos('<', S);
    if I = 0 then I := Pos('"', S);
    if I = 0 then Exit;
    WS.Char := I + 1;
    Word := Copy(S, I + 1, Length(S) - I);
    I := Pos('>', Word);
    if I = 0 then I := Pos('"', Word);
    if I = 0 then Exit;
    Word := Copy(Word, 1, I - 1);
    ptr :=  PChar(Word);
    while (ptr^ <> #0) and (ptr^ in [' ', #9]) do
    begin
      Inc(WS.Char);
      Inc(ptr);
    end;
    Word := Trim(Word);
    WE.Char := WS.Char + Length(Word);
  end;

  if (WS.Char = LWS.Char) and (WS.Line = LWS.Line) and
     (WE.CHar = LWE.Char) and (WE.Line = LWE.Line) then
  begin
     fLinkCount := 0;
     Exit;
  end;

  LWS.Char := WS.Char;
  LWS.Line := WS.Line;
  LWE.Char := WE.Char;
  LWE.Line := WE.Line;
  Inc(fLinkCount);
  fLastLinkLine := WS.Line;
  Pt := CharToPixels(WS);

  //Canvas.Brush.Color := Brush.Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.Font.Color := fLinkOptions.Color;
  if (WE.Line = MouseBuffer.Line) and (ActiveLineColor <> clNone) and
     (WE.Line = CaretY) then
    Canvas.Brush.Color := ActiveLineColor
  else
  begin
    Canvas.Brush.Color := Color;
    if Assigned(Highlighter) then
      if Highlighter.WhitespaceAttribute.Background <> clNone then
        Canvas.Brush.Color := Highlighter.WhitespaceAttribute.Background;
    rgbVal := ColorToRGB(Canvas.Brush.Color);
    if (GetRValue(rgbVal) + GetRValue(rgbVal) + GetRValue(rgbVal)) < 256 then
      Canvas.Font.Color := clWhite;
  end;
  Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
  if (TransientType = ttAfter) then
  begin
    Canvas.TextOut(Pt.X, Pt.Y, Word);
  end;
  Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
end;

procedure TSynEditEx.ProcessHighlighterLink;

  function  LinkDrawStatus: Integer;
  var
    P, WS, WE: TBufferCoord;
    MousePos: TPoint;
    S, Word: String;
    ptr: PChar;
    Attri: TSynHighlighterAttributes;
    I: Integer;
  begin
    if fLinkCount = 0 then
      Result := 2
    else
      Result := 1;
    if not (ssCtrl in fCurrShiftState) then Exit;
    MousePos := ScreenToClient(Mouse.CursorPos);
    if (MousePos.X < 0) or (MousePos.Y < 0) then
      Exit;
    P := DisplayToBufferPos(PixelsToRowColumn(MousePos.X, MousePos.Y));
    if IsPointInSelection(P) then
    begin
      if fLinkCount = 0 then
      begin
        fLastLinkLine := 0;
        Result := 3
      end
      else
        Result := 0;
      LWS.Char := 0;
      LWS.Line := 0;
      LWE.Char := 0;
      LWE.Line := 0;
      Exit;
    end;
    GetHighlighterAttriAtRowCol(P, S, Attri);
    if not Assigned(Attri) then Exit;
    if fLinkOptions.AttributeList.IndexOf(Attri.Name) < 0 then Exit;
    Word := GetWordAtRowCol(P);
    if Length(Word) = 0 then Exit;
    if WordIn(Word, DirectivesNames) and (Pos('#', S) > 0) then Exit;
    WS := WordStartEx(P);
    WE := WordEndEx(P);
    if (Pos('#', S) > 0) and (Pos('include', S) > 0) then
    begin
      I := Pos('<', S);
      if I = 0 then I := Pos('"', S);
      if I = 0 then Exit;
      WS.Char := I + 1;
      Word := Copy(S, I + 1, Length(S) - I);
      I := Pos('>', Word);
      if I = 0 then I := Pos('"', Word);
      if I = 0 then Exit;
      Word := Copy(Word, 1, I - 1);
      ptr :=  PChar(Word);
      while (ptr^ <> #0) and (ptr^ in [' ', #9]) do
      begin
        Inc(WS.Char);
        Inc(ptr);
      end;
      Word := Trim(Word);
      WE.Char := WS.Char + Length(Word);
    end;

    if (WS.Char = LWS.Char) and (WS.Line = LWS.Line) and
       (WE.CHar = LWE.Char) and (WE.Line = LWE.Line) then
    begin
      if fLinkCount > 0 then
        Result := 3
      else
        Result := 0;
      Exit;
    end;
    Result := 0;
  end;

var
  InvStatus: Integer;
begin
  if ssCtrl in fCurrShiftState then
  begin
    InvStatus := LinkDrawStatus;
    case InvStatus of
      0://paint
      begin
        Cursor := crHandPoint;
        if fLinkCount > 0 then
        begin
          fLinkCount := 0;
          InvalidateLine(fLastLinkLine);
        end
        else
          PaintLink(ttAfter);
      end;//invalidate
      1:
      begin
        fLinkCount := 0;
        InvalidateLine(fLastLinkLine);
      end;//cancel, mouse over non link item
      2:
      begin
         Cursor := crIBeam;
        LWS.Char := 0;
        LWS.Line := 0;
        LWE.Char := 0;
        LWE.Line := 0;
      end;
    end;//case
  end
  else if fLinkCount > 0 then
  begin
    Cursor := crIBeam;
    fLinkCount := 0;
    LWS.Char := 0;
    LWS.Line := 0;
    LWE.Char := 0;
    LWE.Line := 0;
    InvalidateLine(fLastLinkLine);
  end;
end;

procedure TSynEditEx.DoExit;
begin
  inherited;
  Cursor := crIBeam;
  fCurrShiftState := [];
end;

procedure TSynEditEx.DoEnter;
begin
  inherited;
  Cursor := crIBeam;
  fCurrShiftState := [];
end;

procedure TSynEditEx.CMMouseEnter(var Message: TMessage);
var
  P: TPoint;
  Shift: TShiftState;
begin
  Shift := KeyboardStateToShiftState;
  P := Point(TWMMouse(Message).XPos, TWMMouse(Message).YPos);
  P := ScreenToClient(P);
  MouseEnter(Self, Shift, P.X, P.Y);
end;

procedure TSynEditEx.MouseEnter(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if assigned(fOnMouseEnter) then
    fOnMouseEnter(Sender, Shift, X, Y);
end;

procedure TSynEditEx.CMMouseLeave(var Message: TMessage);
var
  P: TPoint;
  Shift: TShiftState;
begin
  Shift := KeyboardStateToShiftState;
  P := Point(TWMMouse(Message).XPos, TWMMouse(Message).YPos);
  P := ScreenToClient(P);
  MouseLeave(Self, Shift, P.X, P.Y);
end;

procedure TSynEditEx.MouseLeave(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if assigned(fOnMouseLeave) then
    fOnMouseLeave(Sender, Shift, X, Y);
end;

procedure TSynEditEx.PaintBracket(Sender: TObject; Canvas: TCanvas;
    TransientType: TTransientType);
const AllBrackets = ['{','[','(','<','}',']',')','>'];
var
    OpenChars: array[0..3] of Char;
    CloseChars: array[0..3] of Char;

  function CharToPixels(P: TBufferCoord): TPoint;
  begin
    Result:= RowColumnToPixels(BufferToDisplayPos(P));
  end;

var P, Pa: TBufferCoord;
    Pix, PixB: TPoint;
    Alone: Boolean;
    D     : TDisplayCoord;
    SkipClear: Boolean;
    S, LineStr: string;
    I, FontSize: Integer;
    Attri: TSynHighlighterAttributes;
    start, LineLen: Integer;
    TmpCharA, TmpCharB: Char;
    ftStyle: TFontStyles;
begin
  if SelAvail or not BracketHighlighting then
    Exit;
//if you had a highlighter that used a markup language, like html or xml, then you would want to highlight
//the greater and less than signs as well as illustrated below

//  if (Editor.Highlighter = shHTML) or (Editor.Highlighter = shXML) then
//    inc(ArrayLength);

  for i := Low(OpenChars) to High(OpenChars) do
    case i of
      0: begin OpenChars[i] := '('; CloseChars[i] := ')'; end;
      1: begin OpenChars[i] := '{'; CloseChars[i] := '}'; end;
      2: begin OpenChars[i] := '['; CloseChars[i] := ']'; end;
      3: begin OpenChars[i] := '<'; CloseChars[i] := '>'; end;
    end;
  P := CaretXY;
  D := DisplayXY;
  Start := P.Char - 1;
  LineStr := LineText;
  LineLen := Length(LineStr);
  if (Start > 0) and (Start <= LineLen) then
    TmpCharA := LineStr[Start]
  else TmpCharA := #0;
  if (Start < LineLen) then
    TmpCharB := LineStr[Start + 1]
  else
    TmpCharB := #0;
  if not(TmpCharA in AllBrackets) and not(TmpCharB in AllBrackets) then
    Exit;
  S := TmpCharA;
  if not(TmpCharA in AllBrackets) then
    S := TmpCharB
  else
    P.Char := P.Char - 1;
  GetHighlighterAttriAtRowCol(P, S, Attri);
  if not Assigned(Highlighter) or not Assigned(Attri) then Exit;
  if (Highlighter.SymbolAttribute = Attri) then
  begin
    for i := Low(OpenChars) to High(OpenChars) do
    begin
      if (S = OpenChars[i]) or (S = CloseChars[i]) then
      begin
        Pix := CharToPixels(P);
        Pa := P;
        P := GetMatchingBracketEx(P);
        Alone := False;
        if (P.Char > 0) and (P.Line > 0) then
          PixB := CharToPixels(P)
        else
          Alone := True;
        Canvas.Brush.Style := bsSolid;//Clear;
        ftStyle := Canvas.Font.Style;
        Canvas.Font.Assign(Font);
        Canvas.Font.Style := Attri.Style;
        FontSize := Canvas.Font.Size;
        if (TransientType = ttAfter) then
        begin
          if (Pix.X > GutterWidth) and not Alone then
          begin
            Canvas.Font.Color := BracketHighlight.Foreground;
            Canvas.Brush.Color := BracketHighlight.Background;
            Canvas.Font.Style := BracketHighlight.Style;
          end
          else
          begin
            Canvas.Font.Color := BracketHighlight.AloneForeground;
            Canvas.Brush.Color := BracketHighlight.AloneBackground;
            Canvas.Font.Style := BracketHighlight.AloneStyle;
          end;
          if (ActiveLineColor <> clNone) and (CaretY = Pa.Line) and
            (Canvas.Brush.Color = clNone) then
            Canvas.Brush.Color := ActiveLineColor;
        end
        else
        begin
          Canvas.Font.Color := Attri.Foreground;
          if (ActiveLineColor <> clNone) and (CaretY = Pa.Line) then
            Canvas.Brush.Color := ActiveLineColor
          else
            Canvas.Brush.Color := Highlighter.WhitespaceAttribute.Background;
        end;
        if Canvas.Font.Color = clNone then
          Canvas.Font.Color := Font.Color;
        if Canvas.Brush.Color = clNone then
          Canvas.Brush.Color := Highlighter.WhitespaceAttribute.Background;
        if Canvas.Brush.Color = clNone then
          Canvas.Brush.Color := clWhite;
        SkipClear := False;
        if Pix.X > GutterWidth then
        begin
          if Alone or (TransientType <> ttAfter) then
          begin
            if Alone and (TransientType = ttAfter) then
              Canvas.Font.Style := Canvas.Font.Style - [fsBold];
            Canvas.TextOut(Pix.X, Pix.Y, S);
          end
          else
          begin
            if (TransientType = ttAfter) and (Pa.Line = P.Line) and (Pa.Char + 1 = P.Char) and
              (PixB.X > GutterWidth) then
            begin
              SkipClear := True;
              Canvas.TextOut(Pix.X, Pix.Y, '  ');
            end
            else
            begin
              Canvas.TextOut(Pix.X, Pix.Y, ' ');
            end;
            Canvas.Brush.Style := bsClear;
            Canvas.Font.Size := FontSize + 2;
            Canvas.TextOut(Pix.X, Pix.Y - (Canvas.TextHeight(S) - LineHeight) div 2, S);
            Canvas.Brush.Style := bsSolid;
          end;
        end;
        if not Alone and (PixB.X > GutterWidth) then
        begin
          if (TransientType <> ttAfter) then
          begin
            if (ActiveLineColor <> clNone) and (CaretY = P.Line) then
              Canvas.Brush.Color := ActiveLineColor
            else
              Canvas.Brush.Color := Highlighter.WhitespaceAttribute.Background;
            if Canvas.Brush.Color = clNone then
              Canvas.Brush.Color := clWhite;
          end
          else
          begin
            if (ActiveLineColor <> clNone) and (CaretY = P.Line) then
              Canvas.Brush.Color := ActiveLineColor
            else
              Canvas.Brush.Color := Highlighter.WhitespaceAttribute.Background;
            if Canvas.Brush.Color = clNone then
              Canvas.Brush.Color := clWhite;
          end;
          Canvas.Font.Size := FontSize;
          if (TransientType <> ttAfter) then
          begin
            if S = OpenChars[i] then
              Canvas.TextOut(PixB.X, PixB.Y, CloseChars[i])
            else
              Canvas.TextOut(PixB.X, PixB.Y, OpenChars[i]);
          end
          else
          begin
            if not SkipClear then
              Canvas.TextOut(PixB.X, PixB.Y, ' ');
            Canvas.Brush.Style := bsClear;
            Canvas.Font.Size := FontSize + 2;
            if S = OpenChars[i] then
              Canvas.TextOut(PixB.X, PixB.Y - (Canvas.TextHeight(CloseChars[i]) - LineHeight) div 2, CloseChars[i])
            else
              Canvas.TextOut(PixB.X, PixB.Y - (Canvas.TextHeight(OpenChars[i]) - LineHeight) div 2, OpenChars[i]);
            Canvas.Brush.Style := bsSolid;
          end;
        end;
        Canvas.Font.Style := ftStyle;
        Canvas.Font.Size := FontSize;
      end; //if
    end;//for i :=
    Canvas.Brush.Style := bsSolid;
  end;
end;

function TSynEditEx.GetLeftSpacing(CharCount: Integer; WantTabs: Boolean): String;
begin
  if (WantTabs) and (not (eoTabsToSpaces in Options)) and (CharCount>=TabWidth) then
      Result:=StringOfChar(#9,CharCount div TabWidth)+StringOfChar(#32,CharCount mod TabWidth)
  else Result:=StringOfChar(#32,CharCount);
end;

function TSynEditEx.LeftSpacesEx(const Line: string; WantTabs: Boolean): Integer;
var
  p: PChar;
begin
  p := pointer(Line);
  if Assigned(p) and (eoAutoIndent in Options) then
  begin
    Result := 0;
    while p^ in [#1..#32] do
    begin
      if (p^ = #9) and WantTabs then
        Inc(Result, TabWidth)
      else
        Inc(Result);
      Inc(p);
    end;
  end
  else
    Result := 0;
end;

function TSynEditEx.RightSpacesEx(const Line: string; WantTabs: Boolean): Integer;
var
  p, pend: PChar;
begin
  p := pointer(Line);
  pend := p + Length(Line) - 1;
  if Assigned(p) and (eoAutoIndent in Options) then
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

procedure TSynEditEx.ReplaceText(const S: string; aBlockBegin, aBlockEnd: TBufferCoord);
var
  TmpStr: string;
begin
  BeginUndoBlock;
  SetCaretAndSelection(aBlockBegin, aBlockBegin, aBlockEnd);
  TmpStr := SelText;
  SetSelTextPrimitive(S);
  UndoList.AddChange(crReplace, aBlockBegin, aBlockEnd, TmpStr, smNormal);
  EndUndoBlock;
end;

function TSynEditEx.GetLastNonSpaceChar(const S: string): Char;
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

function TSynEditEx.GetFirstNonSpaceChar(const S: string): Char;
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

// Indentation enhancement

procedure TSynEditEx.ProcessBreakLine;
var
  c, bCaret: TBufferCoord;
  LineStr, PrevLineStr, StrPrevCaret, StrPosCaret, TmpStr,
    CommentStr, NextLineStr, token: string;
  LeftOffset, SpaceCount, I: Integer;
  lstch, fstch: Char;
  attri: TSynHighlighterAttributes;
  Unindent, caretChanged, IsCommentLine: Boolean;
begin
  if not (eoAutoIndent in Options) or ReadOnly then
    Exit;
  caretChanged:= False;
  c := CaretXY;
  PrevLineStr := Lines[c.Line - 2];
  LineStr := LineText;
  StrPrevCaret := Copy(LineStr, 1, c.Char - 1);
  StrPosCaret := Copy(LineStr, c.Char, Length(LineStr) - c.Char + 1);
  lstch := GetLastNonSpaceChar(PrevLineStr);
  fstch := GetFirstNonSpaceChar(StrPosCaret);
  AdvanceSpaceBreakLine(c.Line - 2, LeftOffset, Unindent);
  if (lstch = '{') and (fstch = '}') then
  begin
    caretChanged := True;
    bCaret := CaretXY;
    bCaret.Char := LeftOffset + 1;
    BeginUndoBlock;
    TmpStr := GetLeftSpacing(LeftOffset, WantTabs and not (eoTabsToSpaces in Options));
    Lines.Insert(CaretY - 1, TmpStr);
    UndoList.AddChange(crLineBreak, CaretXY, CaretXY, '', smNormal);
    EndUndoBlock;
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
      Inc(bCaret.Char);
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
  if ((Copy(TmpStr, 1, 3) = '/**') or ((Copy(TmpStr, 1, 1) = '*') and IsCommentLine))
    and (Copy(TmpStr, Length(TmpStr) - 1, 2) <> '*/') then
  begin
    // get next line after /**
    if c.Line < Lines.Count then
      NextLineStr := Trim(Lines[c.Line]);
    // check next line if is */ or * insert * else insert */
    if (Copy(NextLineStr, 1, 2) = '*/') or (Copy(NextLineStr, 1, 1) = '*') then
      NextLineStr := '* '
    else
      NextLineStr := '*/';
    CommentStr := '* ';
    if Unindent then
      Dec(SpaceCount)
    else if Copy(TmpStr, 1, 3) = '/**' then
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
      CommentStr := GetLeftSpacing(LeftOffset - SpaceCount, WantTabs and not (eoTabsToSpaces in Options)) + CommentStr;
    if I <= CaretX then
      ReplaceText(CommentStr, BufferCoord(I + 1, CaretY), CaretXY);
  end
  else
  begin
    TmpStr := GetLeftSpacing(SpaceCount, WantTabs and not (eoTabsToSpaces in Options));
    SelText := TmpStr + CommentStr;
  end;
  if not caretChanged then
    bCaret := CaretXY;
  if NextLineStr = '*/' then
  begin
    TmpStr := GetLeftSpacing(LeftOffset + 1, WantTabs and not (eoTabsToSpaces in Options));
    SelText := #13 + TmpStr + '*/';
  end;
  InternalCaretXY := bCaret;
end;

procedure TSynEditEx.ProcessCloseBracketChar;
var
  c, CaretNew, StartOfBlock, EndOfBlock: TBufferCoord;
  LineStr, StrPrevBracket, StrBracket, Temp: string;
  SpaceCount: Integer;
begin
  if ReadOnly then
    Exit;
  c := CaretXY;
  LineStr := LineText;
  StrPrevBracket := Copy(LineStr, 1, c.Char - 2);
  StrBracket := Copy(LineStr, c.Char - 1, Length(LineStr) - c.Char + 2);
  CaretNew := GetMatchingBracketEx(BufferCoord(C.Char - 1, C.Line));
  if (CaretNew.Char > 0) and (CaretNew.Line > 0) and
     (Length(Trim(StrPrevBracket)) = 0) then
  begin
    SpaceCount := LeftSpacesEx(Lines[CaretNew.Line - 1], True);
    Temp := GetLeftSpacing(SpaceCount, WantTabs and not (eoTabsToSpaces in Options));
    StartOfBlock := BufferCoord(1, c.Line);
    EndOfBlock := BufferCoord(c.Char, c.Line);
    ReplaceText(Temp + StrBracket[1], StartOfBlock, EndOfBlock);
  end;
end;

procedure TSynEditEx.DoDeleteLastCharBeforeCaret(SpaceLen: Integer;
  var SpaceCount: Integer);
var
  Unindent: Boolean;
begin
  inherited;
  Unindent := False;
  SpaceCount := 0;
  if SpaceLen > 0 then
  begin
    AdvanceSpaceBreakLine(CaretY - 1, SpaceCount, Unindent);
    if (SpaceCount = SpaceLen) and not Unindent then
      SpaceCount := 0
    else
      SpaceCount := Length(GetLeftSpacing(SpaceCount, WantTabs and not (eoTabsToSpaces in Options)));
    if SpaceCount > SpaceLen then
      SpaceCount := 0;
  end;
  if SpaceCount = SpaceLen then
  begin
    if Unindent and (SpaceCount > TabWidth) then
      Dec(SpaceCount, TabWidth)
    else
      SpaceCount := 0;
  end;
end;

procedure TSynEditEx.DoTabKeyIndent(MinLen: Integer; var I: Integer);
var
  Unindent: Boolean;
  J, iLine: Integer;
begin
  inherited;
  iLine := CaretY - 1;
  AdvanceSpaceBreakLine(iLine, I, Unindent);
  J := LeftSpacesEx(Copy(Lines[iLine], 1, MinLen - 1), True);
  if I > J then
    Dec(I, J)
  else if I <= J then
    I := TabWidth;
end;

function TSynEditEx.GetBalancingBracketEx(
  const APoint: TBufferCoord; Bracket: Char): Integer;
const
  Brackets: array[0..7] of char = ('(', ')', '[', ']', '{', '}', '<', '>');    
var
  Line: string;
  i, PosX, PosY, Len: integer;
  Test, BracketInc, BracketDec: char;
  vDummy: string;
  OpenCount, CloseCount: Integer;
  attr:TSynHighlighterAttributes;
  p: TBufferCoord;
  isCommentOrString:boolean;
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
      PosY := APoint.Line;
      Line := Lines[PosY - 1];
      // count the matching bracket
      Stack := TStack.Create;
      repeat
        // search until start of line
        while PosX > 1 do
        begin
          Dec(PosX);
          Test := Line[PosX];
{$IFDEF SYN_MBCSSUPPORT}
          if (Test in LeadBytes) then
          begin
            Dec(PosX);
            Continue;
          end;
{$ENDIF}
          p.Char := PosX;
          p.Line := PosY;
          if (Test = BracketInc) or (Test = BracketDec) then
          begin
            if GetHighlighterAttriAtRowCol( p, vDummy, attr ) then
              isCommentOrString:=
               (attr = Highlighter.StringAttribute) or (attr=Highlighter.CommentAttribute) or
               (attr.Name = SYNS_AttrDocComment) or (attr.Name = SYNS_AttrCharacter)
            else isCommentOrString:=false;
            if (Test = BracketInc) and (not isCommentOrString) then
            begin
              if (Stack.Count > 0) and (Char(Stack.Peek) = BracketDec) then
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
      PosY := APoint.Line;
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
            if GetHighlighterAttriAtRowCol( p, vDummy, attr ) then
              isCommentOrString:=
                (attr=Highlighter.StringAttribute) or (attr=Highlighter.CommentAttribute) or
                (attr.Name = SYNS_AttrDocComment) or (attr.Name = SYNS_AttrCharacter)
            else isCommentOrString:=false;
            if (Test = BracketInc) and (not isCommentOrString) then
              Stack.Push(Pointer(BracketInc))
            else if (Test = BracketDec)and (not isCommentOrString) then
            begin
              if (Stack.Count > 0) and (Char(Stack.Peek) = BracketInc) then
                Stack.Pop
              else
                Inc(CloseCount);
            end;
          end;
        end;
        // get next line if possible
        if PosY = Lines.Count then
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

procedure TSynEditEx.ToggleLineComment;
var
  I, J, MinStart, cmmLines: Integer;
  s: string;
  ptr: PChar;
  BS, BE, BC, p, p2: TBufferCoord;
begin
  cmmLines := 0;
  if SelAvail then
  begin
    BS := BlockBegin;
    BE := BlockEnd;
    BC := CaretXY;
  end
  else
  begin
    BS := CaretXY;
    BE := CaretXY;
    BC := CaretXY;
  end;
  MinStart := -1;
  // detect if is commented
  for I := BS.Line to BE.Line do
  begin
    s := Lines[I - 1];
    J := 0;
    // get start of comment
    ptr := PChar(s);
    if ptr^ <> #0 then
      repeat
        if not (ptr^ in [#9, #32]) then
          Break;
        Inc(J);
        Inc(ptr);
      until ptr^ = #0;
    if (ptr^ = '/') and ((ptr + 1)^ = '/') then
    begin
      Inc(cmmLines);
    end
    else if (ptr^ <> #0) and ((MinStart < 0) or (J < MinStart)) then
      MinStart := J;
  end;
  Inc(MinStart);
  if MinStart = 0 then
    Inc(MinStart);
  // little lines commented. comment!
  if cmmLines <= (BE.Line - BS.Line + 1) div 2 then
  begin
    for I := BS.Line to BE.Line do
    begin
      // skip already commented lines
      if cmmLines > 0 then
      begin
        s := Lines[I - 1];
        Dec(cmmLines);
        // get start of comment
        ptr := PChar(s);
        if ptr^ <> #0 then
          repeat
            if not (ptr^ in [#9, #32]) then
              Break;
            Inc(ptr);
          until ptr^ = #0;
        if (ptr^ = '/') and ((ptr + 1)^ = '/') then
          Continue;
      end;
      p.Line := I;
      p.Char := MinStart;
      CaretXY := p;
      SelText := '// ';
      if (p.Line = BS.Line) and (p.Char < BS.Char) then
        Inc(BS.Char, 3);
      if (p.Line = BE.Line) and (p.Char < BE.Char)  then
        Inc(BE.Char, 3);
    end;
  end
  else // uncomment
  begin
    for I := BS.Line to BE.Line do
    begin
      // skip uncommented lines
      s := Lines[I - 1];
      J := 0;
      // get start of comment
      ptr := PChar(s);
      if ptr^ <> #0 then
        repeat
          if not (ptr^ in [#9, #32]) then
            Break;
          Inc(J);
          Inc(ptr);
        until ptr^ = #0;
      if (ptr^ = '/') and ((ptr + 1)^ = '/') then
      begin
        Dec(cmmLines);
        Inc(J);
        p.Line := I;
        p.Char := J;
        p2.Line := I;
        p2.Char := J + 2;
        if (ptr + 2)^ = ' ' then
          Inc(p2.Char);
        SetCaretAndSelection(p2, p, p2);
        SelText := '';
        if (p.Line = BS.Line) and (p.Char <= BS.Char) then
        begin
          Dec(BS.Char, p2.Char - p.Char);
          if BS.Char <= 0 then
            BS.Char := 1;
        end;
        if (p.Line = BE.Line) and (p.Char <= BE.Char)  then
        begin
          Dec(BE.Char, p2.Char - p.Char);
          if BE.Char <= 0 then
            BE.Char := 1;
        end;
        if cmmLines = 0 then
          Break;
      end;
    end;
  end;
  if BC.Line = BS.Line then
    BC.Char := BS.Char
  else
    BC.Char := BE.Char;
  SetCaretAndSelection(BC, BS, BE);
end;

end.
