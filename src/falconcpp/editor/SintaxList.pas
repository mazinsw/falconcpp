unit SintaxList;

interface

uses
  Classes, Highlighter, Graphics, UEditor;

const
  FontStyleNames: array[TFontStyle] of string = (
    'Bold', 'Italic', 'Underline', 'StrikeOut'
  );

  STY_PROP_DEFAULT = 'Default';
  STY_PROP_GUTTER = 'Gutter';
  STY_PROP_CARETLINE = 'Caret Line';
  STY_PROP_SELECTION = 'Selection';
  STY_PROP_BREAKPOINT = 'Breakpoint';
  STY_PROP_EXECPOINT = 'Execution Point';
  STY_PROP_CARETCOLOR = 'Caret Color';
  STY_PROP_BRACE = 'Brace';
  STY_PROP_BADBRACE = 'Bad Brace';
  STY_PROP_LINKCOLOR = 'Link Color';
  STY_PROP_SELWORD = 'Selected Word';

type
  TSintaxType = class;
  TSintax = class;

  TSintaxList = class(TObject)
  private
    FList: TList;
    FItemIndex: Integer;
    FHighlight: THighlighter;
    function Get(Index: Integer): TSintax;
    procedure Put(Index: Integer; Item: TSintax);
    procedure SetItemIndex(Value: Integer);
    procedure SetHighlight(Value: THighlighter);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TSintax): Integer;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property Highlight: THighlighter read FHighlight write SetHighlight;
    property Items[Index: Integer]: TSintax read Get write Put;
    procedure Delete(Index: Integer);
    function IndexOf(Item: TSintax): Integer;
    function IndexOfName(const S: string): Integer;
    procedure Insert(Index: Integer; Item: TSintax);
    function Selected: TSintax;
    procedure Clear;
    function Count: Integer;
  end;

  TSintax = class(TObject)
  private
    FName: string;
    FList: TList;
    FReadOnly: Boolean;
    FChanged: Boolean;
    function Get(Index: Integer): TSintaxType;
    procedure Put(Index: Integer; Item: TSintaxType);
    procedure AddSintaxType(Name: string; Foreground: TColor;
      Background: TColor = clNone; Style: TFontStyles = []);
  public
    constructor Create; overload;
    constructor Create(const AName, S: string); overload;
    destructor Destroy; override;
    procedure Assign(Source: TSintax);
    function Add(Item: TSintaxType): Integer;
    function GetType(Name: string; var Item: TSintaxType): Boolean;
    property Items[Index: Integer]: TSintaxType read Get write Put;
    procedure Delete(Index: Integer);
    function IndexOf(Item: TSintaxType): Integer;
    function GetSintaxString: string;
    procedure SetSintaxString(const S: string);
    procedure Insert(Index: Integer; Item: TSintaxType);
    procedure UpdateEditor(Editor: TEditor; StyleName: string = '');
    procedure UpdateHighlight(Highlight: THighlighter;
      StyleName: string = '');
    procedure Clear;
    function Count: Integer;
    property Name: string read FName write FName;
    property Changed: Boolean read FChanged write FChanged;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
  end;

  TSintaxType = class(TObject)
    Name: string;
    Foreground: TColor;
    Background: TColor;
    Style: TFontStyles;
  end;

implementation

uses
  TokenUtils, SysUtils, CustomColors;

{TSintax}

function TSintax.Get(Index: Integer): TSintaxType;
begin
  Result := TSintaxType(FList.Items[Index]);
end;

procedure TSintax.Put(Index: Integer; Item: TSintaxType);
begin
  if Item = Items[Index] then
    Exit;
  Items[Index].Free;
  FList.Items[Index] := Item;
end;

procedure TSintax.Insert(Index: Integer; Item: TSintaxType);
begin
  FList.Insert(Index, Item);
end;

constructor TSintax.Create;
begin
  inherited Create;
  FList := TList.Create;
  FReadOnly := False;
  FChanged := False;
end;

constructor TSintax.Create(const AName, S: string);
begin
  inherited Create;
  FList := TList.Create;
  FReadOnly := False;
  FChanged := False;
  FName := AName;
  SetSintaxString(S);
end;

destructor TSintax.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TSintax.GetSintaxString: string;

  function GetFontStyle(Style: TFontStyles): string;
  var
    I: Integer;
  begin
    Result := '[';
    I := 0;
    if fsBold in Style then
    begin
      Inc(I);
      Result := Result + FontStyleNames[fsBold];
    end;
    if fsItalic in Style then
    begin
      if I > 0 then
        Result := Result + ',';
      Inc(I);
      Result := Result + FontStyleNames[fsItalic];
    end;
    if fsUnderline in Style then
    begin
      if I > 0 then
        Result := Result + ',';
      Result := Result + FontStyleNames[fsUnderline];
    end;
    Result := Result + ']';
  end;
var
  I: Integer;
begin
  Result := '';
  if Count > 0 then
    Result := '{' + Items[0].Name + '(' + ColorToString(Items[0].Foreground) +
      ',' + ColorToString(Items[0].Background) + ',' +
      GetFontStyle(Items[0].Style) + ')';
  for I := 1 to Count - 1 do
  begin
    Result := Result + ';' + Items[I].Name + '(' +
      ColorToString(Items[I].Foreground) + ',' +
      ColorToString(Items[I].Background) + ',' +
      GetFontStyle(Items[I].Style) + ')';
  end;
  if Count > 0 then
    Result := Result + '}';
end;

procedure TSintax.SetSintaxString(const S: string);

  function GetFontStyleFromString(const StyleString: string): TFontStyles;
  var
    Style: TFontStyles;
    SL: TStringList;
    I: Integer;
  begin
    Style := [];
    SL := TStringList.Create;
    SL.CommaText := Trim('[', StyleString, ']');
    for I := 0 to SL.Count - 1 do
    begin
      if SL.Strings[I] = FontStyleNames[fsBold] then
        Style := Style + [fsBold]
      else if SL.Strings[I] = FontStyleNames[fsItalic] then
        Style := Style + [fsItalic]
      else if SL.Strings[I] = FontStyleNames[fsUnderline] then
        Style := Style + [fsUnderline]
    end;
    SL.Free;
    Result := Style;
  end;

var
  Current, All, StxName: string;
  Style: TFontStyles;
  C1, C2: TColor;
  L: TStringList;
  I, J: Integer;
  Sxt: TSintaxType;
begin
  All := Trim('{', S, '}');
  All := StringReplace(All, ';', #13#10, [rfReplaceAll]);
  L := TStringList.Create;
  L.Text := All;
  Clear;
  for I := 0 to L.Count - 1 do
  begin
    Current := L.Strings[I];
    J := Pos('(', Current);
    if J = 0 then
      Continue;
    StxName := Copy(Current, 1, J - 1); //Name
    Current := Trim('(', Copy(Current, J, Length(Current) - J), ')');
    J := Pos(',', Current);
    if J = 0 then
      Continue;
    C1 := StringToColor(Copy(Current, 1, J - 1)); //Foreground
    Current := Copy(Current, J + 1, Length(Current) - J);

    J := Pos(',', Current);
    if J = 0 then
      Continue;
    C2 := StringToColor(Copy(Current, 1, J - 1)); //Background
    Current := Copy(Current, J + 1, Length(Current) - J);
    Style := GetFontStyleFromString(Current);
    AddSintaxType(StxName, C1, C2, Style);
  end;
  L.Free;
  // Keep compatibilities
  if not GetType(HL_Style_TypeWord, Sxt) then
  begin
    if GetType('Reserved Word', Sxt) then
      AddSintaxType(HL_Style_TypeWord, Sxt.Foreground, Sxt.Background, Sxt.Style)
    else
      AddSintaxType(HL_Style_TypeWord, clViolet);
  end;
  if not GetType(HL_Style_InstructionWord, Sxt) then
  begin
    if GetType('Reserved Word', Sxt) then
      AddSintaxType(HL_Style_InstructionWord, Sxt.Foreground, Sxt.Background, Sxt.Style)
    else
      AddSintaxType(HL_Style_InstructionWord, clBlue);
  end;                                         
  if not GetType(HL_Style_LineComment, Sxt) then
    AddSintaxType(HL_Style_LineComment, clGreen);
  if not GetType(HL_Style_DocComment, Sxt) then
    AddSintaxType(HL_Style_DocComment, clTeal);  
  if not GetType(HL_Style_DocComment, Sxt) then
    AddSintaxType(HL_Style_LineDocComment, clGray);
  if not GetType(HL_Style_CommentKeyword, Sxt) then
    AddSintaxType(HL_Style_CommentKeyword, clBlue, clNone, [fsBold]);
  if not GetType(HL_Style_CommentKeywordError, Sxt) then
    AddSintaxType(HL_Style_CommentKeywordError, clRed);
  if not GetType(STY_PROP_CARETLINE, Sxt) then
    AddSintaxType(STY_PROP_CARETLINE, clWindow, $00FFE8E8);
  if not GetType(STY_PROP_CARETCOLOR, Sxt) then
    AddSintaxType(STY_PROP_CARETCOLOR, clBlack);
  if not GetType(STY_PROP_DEFAULT, Sxt) then
    AddSintaxType(STY_PROP_DEFAULT, clGray, clWhite); 
  if not GetType(STY_PROP_BREAKPOINT, Sxt) then
    AddSintaxType(STY_PROP_BREAKPOINT, clNone, clRed);
  if not GetType(STY_PROP_EXECPOINT, Sxt) then
    AddSintaxType(STY_PROP_EXECPOINT, clNone, clRed);
  if not GetType(STY_PROP_BRACE, Sxt) then
    AddSintaxType(STY_PROP_BRACE, clRed, clNone, [fsBold]);
  if not GetType(STY_PROP_BADBRACE, Sxt) then
    AddSintaxType(STY_PROP_BADBRACE, clRed);
end;

procedure TSintax.AddSintaxType(Name: string; Foreground: TColor;
  Background: TColor = clNone; Style: TFontStyles = []);
var
  StxTpy: TSintaxType;
begin
  StxTpy := TSintaxType.Create;
  StxTpy.Name := Name;
  StxTpy.Foreground := Foreground;
  StxTpy.Background := Background;
  StxTpy.Style := Style;
  Add(StxTpy);
end;

procedure TSintax.Assign(Source: TSintax);
var
  I: Integer;
begin
  if not Assigned(Source) then
    Exit;
  Name := Source.Name;
  ReadOnly := Source.ReadOnly;
  Changed := Source.Changed;
  Clear;
  for I := 0 to Source.Count - 1 do
    AddSintaxType(Source.Items[I].Name,
      Source.Items[I].Foreground,
      Source.Items[I].Background,
      Source.Items[I].Style);
end;

procedure TSintax.UpdateHighlight(Highlight: THighlighter;
  StyleName: string = '');
var
  I: Integer;
  st: TSintaxType;
begin
  if Length(StyleName) > 0 then
  begin
    for I := 0 to Highlight.StyleCount - 1 do
      if Highlight.Style[I].Name = StyleName then
        Break;
    if GetType(StyleName, st) and (I >= 0) then
    begin
      Highlight.Style[I].Foreground := st.Foreground;
      Highlight.Style[I].Background := st.Background;
      Highlight.Style[I].Style := st.Style;
    end;
    Exit;
  end;

  Highlight.BeginUpdate;
  for I := 0 to Highlight.StyleCount - 1 do
    if GetType(Highlight.Style[I].Name, st) then
    begin
      Highlight.Style[I].Foreground := st.Foreground;
      Highlight.Style[I].Background := st.Background;
      Highlight.Style[I].Style := st.Style;
    end;
  Highlight.EndUpdate;
end;

procedure TSintax.UpdateEditor(Editor: TEditor; StyleName: string = '');
var
  st: TSintaxType;
begin
  if Length(StyleName) > 0 then
  begin
    if GetType(StyleName, st) then
    begin
      Editor.BeginUpdate;
      if st.Name = STY_PROP_DEFAULT then
      begin
        Editor.DefaultHighlight.Background := st.Background;
        Editor.DefaultHighlight.Foreground := st.Foreground;
        Editor.DefaultHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_GUTTER then
      begin
        Editor.LineNumberHighlight.Background := st.Background;
        Editor.LineNumberHighlight.Foreground := st.Foreground;
        Editor.LineNumberHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_CARETLINE then
      begin
        Editor.CaretLineHighlight.Background := st.Background;
        Editor.CaretLineHighlight.Foreground := st.Background;
        Editor.CaretLineHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_SELECTION then
      begin
        Editor.SelectionHighlight.Background := st.Background;
        Editor.SelectionHighlight.Foreground := st.Background;
        Editor.SelectionHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_BREAKPOINT then
      begin
        Editor.BreakpointHighlight.Background := st.Background;
        Editor.BreakpointHighlight.Foreground := st.Foreground;
        Editor.BreakpointHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_EXECPOINT then
      begin
        Editor.ExecutionPointHighlight.Background := st.Background;
        Editor.ExecutionPointHighlight.Foreground := st.Foreground;
        Editor.ExecutionPointHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_CARETCOLOR then
      begin
        Editor.CaretColor := st.Foreground;
      end; 
      if st.Name = STY_PROP_BRACE then
      begin
        Editor.BracketHighlight.Foreground := st.Foreground;
        Editor.BracketHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_BADBRACE then
      begin
        Editor.BadBracketHighlight.Foreground := st.Foreground;
        Editor.BadBracketHighlight.Style := st.Style;
      end;
      if st.Name = STY_PROP_LINKCOLOR then
      begin
        Editor.LinkColor := st.Foreground;
      end;
      if st.Name = STY_PROP_SELWORD then
      begin
        Editor.MatchWordHighlight.Foreground := st.Foreground;
      end;
      Editor.EndUpdate;
    end;
    Exit;
  end;
  Editor.BeginUpdate;
  if GetType(STY_PROP_DEFAULT, st) then
  begin
    Editor.DefaultHighlight.Background := st.Background;
    Editor.DefaultHighlight.Foreground := st.Foreground;
    Editor.DefaultHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_GUTTER, st) then
  begin                 
    Editor.LineNumberHighlight.Background := st.Background;
    Editor.LineNumberHighlight.Foreground := st.Foreground;
    Editor.LineNumberHighlight.Style := st.Style;
  end;            
  if GetType(STY_PROP_CARETLINE, st) then
  begin
    Editor.CaretLineHighlight.Background := st.Background;
    Editor.CaretLineHighlight.Foreground := st.Background;
    Editor.CaretLineHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_SELECTION, st) then
  begin
    Editor.SelectionHighlight.Background := st.Background;
    Editor.SelectionHighlight.Foreground := st.Background;
    Editor.SelectionHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_BREAKPOINT, st) then
  begin
    Editor.BreakpointHighlight.Background := st.Background;
    Editor.BreakpointHighlight.Foreground := st.Foreground;
    Editor.BreakpointHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_EXECPOINT, st) then
  begin
    Editor.ExecutionPointHighlight.Background := st.Background;
    Editor.ExecutionPointHighlight.Foreground := st.Foreground;
    Editor.ExecutionPointHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_CARETCOLOR, st) then
  begin
    Editor.CaretColor := st.Foreground;
  end;  
  if GetType(STY_PROP_BRACE, st) then
  begin
    Editor.BracketHighlight.Foreground := st.Foreground;
    Editor.BracketHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_BADBRACE, st) then
  begin
    Editor.BadBracketHighlight.Foreground := st.Foreground;
    Editor.BadBracketHighlight.Style := st.Style;
  end;
  if GetType(STY_PROP_LINKCOLOR, st) then
  begin
    Editor.LinkColor := st.Foreground;
  end;
  if GetType(STY_PROP_SELWORD, st) then
  begin
    Editor.MatchWordHighlight.Foreground := st.Foreground;
  end;
  Editor.EndUpdate;
end;

function TSintax.Add(Item: TSintaxType): Integer;
begin
  Result := FList.Add(Item);
end;

function TSintax.GetType(Name: string; var Item: TSintaxType): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Count - 1 downto 0 do
    if Items[I].Name = Name then
    begin
      Result := True;
      Item := Items[I];
    end;
end;

procedure TSintax.Delete(Index: Integer);
begin
  TSintaxType(FList.Items[Index]).Free;
  FList.Delete(Index);
end;

function TSintax.IndexOf(Item: TSintaxType): Integer;
begin
  Result := FList.IndexOf(Item);
end;

function TSintax.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TSintax.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Delete(I);
end;

{TSintaxList}

function TSintaxList.Get(Index: Integer): TSintax;
begin
  Result := TSintax(FList.Items[Index]);
end;

procedure TSintaxList.Put(Index: Integer; Item: TSintax);
begin
  if Item = Items[Index] then
    Exit;
  Items[Index].Free;
  FList.Items[Index] := Item;
end;

procedure TSintaxList.Insert(Index: Integer; Item: TSintax);
begin
  FList.Insert(Index, Item);
  if Index <= ItemIndex then
    ItemIndex := ItemIndex + 1;
end;

procedure TSintaxList.SetItemIndex(Value: Integer);
begin
  if Value <> FItemIndex then
  begin
    FItemIndex := Value;
    Selected.UpdateHighlight(Highlight);
  end;
end;

procedure TSintaxList.SetHighlight(Value: THighlighter);
begin
  if Value <> FHighlight then
  begin
    FHighlight := Value;
    Selected.UpdateHighlight(Highlight);
  end;
end;

constructor TSintaxList.Create;
var
  Stx: TSintax;
begin
  inherited Create;
  FList := TList.Create;

  //Notepad++
  Stx := TSintax.Create;
  Stx.Name := 'Notepad++';
  Stx.ReadOnly := True;                     
  Stx.AddSintaxType(STY_PROP_DEFAULT, clGray, clWhite);
  Stx.AddSintaxType(HL_Style_Character, clGray);
  Stx.AddSintaxType(HL_Style_LineComment, clGreen);
  Stx.AddSintaxType(HL_Style_Comment, clGreen);
  Stx.AddSintaxType(HL_Style_DocComment, clTeal);
  Stx.AddSintaxType(HL_Style_LineDocComment, clGray); 
  Stx.AddSintaxType(HL_Style_CommentKeyword, clBlue, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_CommentKeywordError, clRed);
  Stx.AddSintaxType(HL_Style_Identifier, clBlack);
  Stx.AddSintaxType(HL_Style_Number, clOrange);
  Stx.AddSintaxType(HL_Style_Preprocessor, clMaroon);
  Stx.AddSintaxType(HL_Style_TypeWord, clViolet);
  Stx.AddSintaxType(HL_Style_InstructionWord, clBlue, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_Space, clNone);
  Stx.AddSintaxType(HL_Style_String, clGray);
  Stx.AddSintaxType(HL_Style_Symbol, clNavy, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_GUTTER, clGray, $00E4E4E4);
  Stx.AddSintaxType(STY_PROP_CARETLINE, clWindow, $00FFE8E8);
  Stx.AddSintaxType(STY_PROP_SELECTION, clBlack, clSilver);
  Stx.AddSintaxType(STY_PROP_BREAKPOINT, clNone, clRed);
  Stx.AddSintaxType(STY_PROP_EXECPOINT, clNone, clNavy);
  Stx.AddSintaxType(STY_PROP_CARETCOLOR, clViolet);  
  Stx.AddSintaxType(STY_PROP_BRACE, clRed, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_BADBRACE, clRed);
  Stx.AddSintaxType(STY_PROP_LINKCOLOR, clBlue);
  Stx.AddSintaxType(STY_PROP_SELWORD, clLime);
  FItemIndex := Add(Stx);

  //Borland
  Stx := TSintax.Create;
  Stx.Name := 'Borland';
  Stx.ReadOnly := True;
  Stx.AddSintaxType(STY_PROP_DEFAULT, clGray, clNavy);
  Stx.AddSintaxType(HL_Style_Character, clYellow);
  Stx.AddSintaxType(HL_Style_LineComment, clGray);
  Stx.AddSintaxType(HL_Style_Comment, clGray);
  Stx.AddSintaxType(HL_Style_DocComment, clGray); 
  Stx.AddSintaxType(HL_Style_LineDocComment, clGreen); 
  Stx.AddSintaxType(HL_Style_CommentKeyword, clOlive, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_CommentKeywordError, clRed);
  Stx.AddSintaxType(HL_Style_Identifier, clYellow);
  Stx.AddSintaxType(HL_Style_Number, clYellow);
  Stx.AddSintaxType(HL_Style_Preprocessor, clYellow);
  Stx.AddSintaxType(HL_Style_TypeWord, clWhite);
  Stx.AddSintaxType(HL_Style_InstructionWord, clWhite);
  Stx.AddSintaxType(HL_Style_Space, clNone, clNavy);
  Stx.AddSintaxType(HL_Style_String, clYellow);
  Stx.AddSintaxType(HL_Style_Symbol, clYellow);
  Stx.AddSintaxType(STY_PROP_GUTTER, clYellow, clNavy);
  Stx.AddSintaxType(STY_PROP_CARETLINE, clNone, clNone);
  Stx.AddSintaxType(STY_PROP_SELECTION, clBlack, clGray);
  Stx.AddSintaxType(STY_PROP_BREAKPOINT, clNone, clRed);
  Stx.AddSintaxType(STY_PROP_EXECPOINT, clNone, clSkyBlue);
  Stx.AddSintaxType(STY_PROP_CARETCOLOR, clWhite);
  Stx.AddSintaxType(STY_PROP_BRACE, clRed, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_BADBRACE, clRed);
  Stx.AddSintaxType(STY_PROP_LINKCOLOR, clOrange);
  Stx.AddSintaxType(STY_PROP_SELWORD, clWhite);
  Add(Stx);

  //Visual Studio
  Stx := TSintax.Create;
  Stx.Name := 'Visual Studio';
  Stx.ReadOnly := True;                         
  Stx.AddSintaxType(STY_PROP_DEFAULT, clGray, clWhite);
  Stx.AddSintaxType(HL_Style_Character, $001515A3);  
  Stx.AddSintaxType(HL_Style_LineComment, clGreen);
  Stx.AddSintaxType(HL_Style_Comment, clGreen);
  Stx.AddSintaxType(HL_Style_DocComment, clGreen);  
  Stx.AddSintaxType(HL_Style_LineDocComment, clGray);
  Stx.AddSintaxType(HL_Style_CommentKeyword, clBlue, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_CommentKeywordError, clRed);
  Stx.AddSintaxType(HL_Style_Identifier, clBlack);
  Stx.AddSintaxType(HL_Style_Number, clNavy);
  Stx.AddSintaxType(HL_Style_Preprocessor, clBlue);
  Stx.AddSintaxType(HL_Style_TypeWord, clBlue);
  Stx.AddSintaxType(HL_Style_InstructionWord, clBlue);
  Stx.AddSintaxType(HL_Style_Space, clNone);
  Stx.AddSintaxType(HL_Style_String, $001515A3);
  Stx.AddSintaxType(HL_Style_Symbol, clBlack);
  Stx.AddSintaxType(STY_PROP_GUTTER, clWindowText, clBtnFace);
  Stx.AddSintaxType(STY_PROP_CARETLINE, clNone);
  Stx.AddSintaxType(STY_PROP_SELECTION, clBlack, clSilver);
  Stx.AddSintaxType(STY_PROP_BREAKPOINT, clNone, clRed);   
  Stx.AddSintaxType(STY_PROP_EXECPOINT, clNone, clNavy);
  Stx.AddSintaxType(STY_PROP_CARETCOLOR, clBlack);   
  Stx.AddSintaxType(STY_PROP_BRACE, clRed, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_BADBRACE, clRed); 
  Stx.AddSintaxType(STY_PROP_LINKCOLOR, clBlue);
  Stx.AddSintaxType(STY_PROP_SELWORD, clBlue);
  Add(Stx);

  //Obsidian
  Stx := TSintax.Create;
  Stx.Name := 'Obsidian';
  Stx.ReadOnly := True;                            
  Stx.AddSintaxType(STY_PROP_DEFAULT, $02343129, $00343129);
  Stx.AddSintaxType(HL_Style_Character, $000984FF); 
  Stx.AddSintaxType(HL_Style_LineComment, $007B7466);
  Stx.AddSintaxType(HL_Style_Comment, $007B7466);
  Stx.AddSintaxType(HL_Style_DocComment, $02BF5F3F); 
  Stx.AddSintaxType(HL_Style_LineDocComment, $02BF5F3F);
  Stx.AddSintaxType(HL_Style_CommentKeyword, clBlue, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_CommentKeywordError, clRed);
  Stx.AddSintaxType(HL_Style_Identifier, $00E4E2E0);
  Stx.AddSintaxType(HL_Style_Number, $0022CDFF);
  Stx.AddSintaxType(HL_Style_Preprocessor, $00BD82A0);
  Stx.AddSintaxType(HL_Style_TypeWord, $00B18C67);
  Stx.AddSintaxType(HL_Style_InstructionWord, $00C17C57);
  Stx.AddSintaxType(HL_Style_Space, $02343129, $00343129);
  Stx.AddSintaxType(HL_Style_String, $000076EC);
  Stx.AddSintaxType(HL_Style_Symbol, $00B7E2E8);
  Stx.AddSintaxType(STY_PROP_GUTTER, $0088806A, $003C382F);
  Stx.AddSintaxType(STY_PROP_CARETLINE, clWhite, clBlack);
  Stx.AddSintaxType(STY_PROP_SELECTION, clWhite, $00514E40);
  Stx.AddSintaxType(STY_PROP_BREAKPOINT, clNone, clRed);   
  Stx.AddSintaxType(STY_PROP_EXECPOINT, clNone, clOlive);
  Stx.AddSintaxType(STY_PROP_CARETCOLOR, clWhite); 
  Stx.AddSintaxType(STY_PROP_BRACE, clRed, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_BADBRACE, clRed); 
  Stx.AddSintaxType(STY_PROP_LINKCOLOR, clBlue);
  Stx.AddSintaxType(STY_PROP_SELWORD, clAqua);
  Add(Stx);

  //default
  Stx := TSintax.Create;
  Stx.Name := 'Default';
  Stx.ReadOnly := True;                       
  Stx.AddSintaxType(STY_PROP_DEFAULT, clGray, clWhite);
  Stx.AddSintaxType(HL_Style_Character, clGray); 
  Stx.AddSintaxType(HL_Style_LineComment, clGreen);
  Stx.AddSintaxType(HL_Style_Comment, clGreen);
  Stx.AddSintaxType(HL_Style_DocComment, clTeal); 
  Stx.AddSintaxType(HL_Style_LineDocComment, clGray);
  Stx.AddSintaxType(HL_Style_CommentKeyword, clBlue, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_CommentKeywordError, clRed);
  Stx.AddSintaxType(HL_Style_Identifier, clBlack);
  Stx.AddSintaxType(HL_Style_Number, clOrange);
  Stx.AddSintaxType(HL_Style_Preprocessor, clMaroon);
  Stx.AddSintaxType(HL_Style_TypeWord, clViolet);
  Stx.AddSintaxType(HL_Style_InstructionWord, clBlue, clNone, [fsBold]);
  Stx.AddSintaxType(HL_Style_Space, clNone);
  Stx.AddSintaxType(HL_Style_String, clBlue);
  Stx.AddSintaxType(HL_Style_Symbol, clNavy, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_GUTTER, clGrayText, clBtnFace);
  Stx.AddSintaxType(STY_PROP_CARETLINE, clWhite, $00FFE8E8);
  Stx.AddSintaxType(STY_PROP_SELECTION, clBlack, clSilver);
  Stx.AddSintaxType(STY_PROP_BREAKPOINT, clNone, clRed);
  Stx.AddSintaxType(STY_PROP_EXECPOINT, clNone, clNavy);
  Stx.AddSintaxType(STY_PROP_CARETCOLOR, clBlack);
  Stx.AddSintaxType(STY_PROP_BRACE, clRed, clNone, [fsBold]);
  Stx.AddSintaxType(STY_PROP_BADBRACE, clRed);
  Stx.AddSintaxType(STY_PROP_LINKCOLOR, clBlue);
  Stx.AddSintaxType(STY_PROP_SELWORD, clBlue);
  FItemIndex := Add(Stx);
end;

destructor TSintaxList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TSintaxList.Add(Item: TSintax): Integer;
begin
  Result := FList.Add(Item);
end;

procedure TSintaxList.Delete(Index: Integer);
begin
  TSintax(FList.Items[Index]).Free;
  FList.Delete(Index);
end;

function TSintaxList.IndexOf(Item: TSintax): Integer;
begin
  Result := FList.IndexOf(Item);
end;

function TSintaxList.IndexOfName(const S: string): Integer;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if SameText(S, Items[I].Name) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TSintaxList.Selected: TSintax;
begin
  Result := nil;
  if Count > ItemIndex then
    Result := TSintax(FList.Items[ItemIndex]);
end;

procedure TSintaxList.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Delete(I);
end;

function TSintaxList.Count: Integer;
begin
  Result := FList.Count;
end;


end.
