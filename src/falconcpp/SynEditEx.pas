unit SynEditEx;

interface

uses
  Windows, Forms, Controls, Messages, Classes, SynEdit, SynEditHighlighter, Graphics,
  SynEditTypes;

const
  DirectivesNames: array[0..10] of String = (
    'include', 'defined', 'if', 'ifndef', 'else', 'pragma', 'endif', 'elif',
    'ifdef', 'define', 'undef'
  );

type
  TLinkClickEvent = procedure(Sender: TObject; Word, Attri, FirstWord: String)
    of object;

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
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function ProcessLinkClick(X, Y: Integer): Boolean;
    procedure ProcessHighlighterLink;
    procedure PaintBracket(Sender: TObject; Canvas: TCanvas;
      TransientType: TTransientType);
    procedure DoLinkClick(Word, Attri, FirstWord: String);
    procedure PaintLink(TransientType: TTransientType);
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
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
  end;

implementation


uses
  SysUtils;

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

constructor TSynEditEx.Create(AOwner: TComponent);
begin
  inherited;
  fBracketHighlighting := False;
  fBracketHighlight := TSynBracketHighlight.Create;
  OnPaintTransient := PaintBracket;
  fLinkOptions := TSynLinkOptions.Create;
  fLinkEnable := True;
  fLinkOptions.AttributeList.Add('Preprocessor');
  fLinkOptions.AttributeList.Add('Identifier');
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
    S: String;
    I, FontSize: Integer;
    Attri: TSynHighlighterAttributes;
    start: Integer;
    TmpCharA, TmpCharB: Char;
    ftStyle: TFontStyles;
begin
  if SelAvail then Exit;
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

  Start := SelStart;

  if (Start > 0) and (Start <= length(Text)) then
    TmpCharA := Text[Start]
  else TmpCharA := #0;

  if (Start < length(Text)) then
    TmpCharB := Text[Start + 1]
  else TmpCharB := #0;

  if not(TmpCharA in AllBrackets) and not(TmpCharB in AllBrackets) then exit;
  S := TmpCharA;
  if not(TmpCharA in AllBrackets) then
    S := TmpCharB
  else
    P.Char := P.Char - 1;
  GetHighlighterAttriAtRowCol(P, S, Attri);
  if not Assigned(Highlighter) or not Assigned(Attri) then Exit;
  if (Highlighter.SymbolAttribute = Attri) then
  begin
    for i := low(OpenChars) to High(OpenChars) do
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
            Canvas.TextOut(Pix.X, Pix.Y, ' ');
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

end.
