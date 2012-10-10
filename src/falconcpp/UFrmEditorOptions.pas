unit UFrmEditorOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, SynEdit, SynMemo, Buttons,
  SynEditHighlighter, SynHighlighterCpp;

const
  FontStyleNames: array[TFontStyle] of string = (
    'Bold', 'Italic', 'Underline', 'StrikeOut'
    );

type
  TSintaxType = class;
  TSintax = class;

  TSintaxList = class(TObject)
  private
    FList: TList;
    FItemIndex: Integer;
    FHighlight: TSynCustomHighlighter;
    function Get(Index: Integer): TSintax;
    procedure Put(Index: Integer; Item: TSintax);
    procedure SetItemIndex(Value: Integer);
    procedure SetHighlight(Value: TSynCustomHighlighter);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TSintax): Integer;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property Highlight: TSynCustomHighlighter read FHighlight write SetHighlight;
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
    procedure UpdateEditor(Editor: TSynMemo; AttributeName: string = '');
    procedure UpdateHighlight(Highlight: TSynCustomHighlighter;
      AttributeName: string = '');
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

  TFrmEditorOptions = class(TForm)
    PageControl1: TPageControl;
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    TSGeneral: TTabSheet;
    TSDisplay: TTabSheet;
    TSSintax: TTabSheet;
    TSCodeResources: TTabSheet;
    GroupBox1: TGroupBox;
    ChbAutoIndt: TCheckBox;
    ChbUseTabChar: TCheckBox;
    ChbHighMatch: TCheckBox;
    GroupBoxHlMatchBP: TGroupBox;
    ClbN: TColorBox;
    Label1: TLabel;
    Label2: TLabel;
    ClbE: TColorBox;
    ClbB: TColorBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    ChbHighCurLn: TCheckBox;
    ClbCurLn: TColorBox;
    ChbTabUnOrIndt: TCheckBox;
    ChbInsMode: TCheckBox;
    ChbGrpUnd: TCheckBox;
    Label6: TLabel;
    CboMaxUnd: TComboBox;
    GroupBox5: TGroupBox;
    ChbShowgtt: TCheckBox;
    ChbShowRMrgn: TCheckBox;
    Label7: TLabel;
    CboRMrg: TComboBox;
    Label8: TLabel;
    CboGutterWdt: TComboBox;
    PanelTest: TPanel;
    Label9: TLabel;
    CboSize: TComboBox;
    CboEditFont: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox6: TGroupBox;
    ChbBold: TCheckBox;
    ChbItalic: TCheckBox;
    ChbUnderl: TCheckBox;
    Label12: TLabel;
    CbDefSin: TComboBox;
    BtnSave: TSpeedButton;
    BtnDel: TSpeedButton;
    SynPrev: TSynMemo;
    ListBoxType: TListBox;
    Label13: TLabel;
    Label14: TLabel;
    ClbFore: TColorBox;
    Label15: TLabel;
    ClbBack: TColorBox;
    SynCpp: TSynCppSyn;
    Label16: TLabel;
    CboTabWdt: TComboBox;
    ChbShowLnNumb: TCheckBox;
    ChbGrdGutt: TCheckBox;
    ChbSmartTabs: TCheckBox;
    ChbScrollHint: TCheckBox;
    GroupBox8: TGroupBox;
    ChbCodeCompletion: TCheckBox;
    ChbCodeParameters: TCheckBox;
    ChbTooltipSymbol: TCheckBox;
    ChbTooltopexev: TCheckBox;
    LblDelay: TLabel;
    TrackBarCodeRes: TTrackBar;
    LblSecStart: TLabel;
    LblSecEnd: TLabel;
    TimerNormalDelay: TTimer;
    GroupBox9: TGroupBox;
    ClbCompListConst: TColorBox;
    Label17: TLabel;
    Label18: TLabel;
    ClbCompListFunc: TColorBox;
    Label19: TLabel;
    ClbCompListVar: TColorBox;
    Label20: TLabel;
    ClbCompListType: TColorBox;
    ClbCompListPreproc: TColorBox;
    Label21: TLabel;
    Label22: TLabel;
    ClbCompListBg: TColorBox;
    ClbCompListSel: TColorBox;
    Label23: TLabel;
    Label24: TLabel;
    ClbCompListTypedef: TColorBox;
    GroupBox7: TGroupBox;
    EditCodeTemplate: TEdit;
    OpenDialog: TOpenDialog;
    Label25: TLabel;
    BtnEditCodeTemplate: TSpeedButton;
    BtnChooseCodeTemplate: TSpeedButton;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    ChbLinkClick: TCheckBox;
    ClbLinkColor: TColorBox;
    ChbEnhHomeKey: TCheckBox;
    ChbKeepTraiSpa: TCheckBox;
    ChbShowLineChars: TCheckBox;
    BtnRestDef: TButton;
    Button1: TButton;
    TSFormatter: TTabSheet;
    PageControl2: TPageControl;
    TSFormatterStyle: TTabSheet;
    TSFormatterIndentation: TTabSheet;
    TSFormatterFormatting: TTabSheet;
    GroupBoxFormatterSample: TGroupBox;
    RadioGroupFormatterStyles: TRadioGroup;
    BtnPrevStyle: TButton;
    SynMemoSample: TSynMemo;
    CheckBoxForceUsingTabs: TCheckBox;
    CheckBoxIndentClasses: TCheckBox;
    CheckBoxIndentSwitches: TCheckBox;
    CheckBoxIndentCase: TCheckBox;
    CheckBoxIndentBrackets: TCheckBox;
    CheckBoxIndentBlocks: TCheckBox;
    CheckBoxIndentNamespaces: TCheckBox;
    CheckBoxIndentLabels: TCheckBox;
    CheckBoxIndentMultLinePreprocessor: TCheckBox;
    LabelBracketsStyle: TLabel;
    ComboBoxBracketStyle: TComboBox;
    CheckBoxBreakClosingHeadersBrackets: TCheckBox;
    CheckBoxBreakElseIf: TCheckBox;
    CheckBoxDontBreakComplex: TCheckBox;
    CheckBoxDontBreakOneLineBlocks: TCheckBox;
    CheckBoxConvToSpaces: TCheckBox;
    CheckBoxIndentSingleLineComments: TCheckBox;
    CheckBoxAddBrackets: TCheckBox;
    CheckBoxAddOneLineBrackets: TCheckBox;
    TSFormatterPadding: TTabSheet;
    CheckBoxPadEmptyLines: TCheckBox;
    CheckBoxInsertSpacePaddingOperators: TCheckBox;
    CheckBoxInsertSpacePaddingParenthesisOutside: TCheckBox;
    CheckBoxInsertSpacePaddingParenthesisInside: TCheckBox;
    CheckBoxRemoveExtraSpace: TCheckBox;
    CheckBoxFillEmptyLines: TCheckBox;
    CheckBoxDeleteEmptyLines: TCheckBox;
    CheckBoxParenthesisHeaderPadding: TCheckBox;
    CheckBoxBreakClosingHeaderBlocks: TCheckBox;
    Label26: TLabel;
    ComboBoxPointerAlign: TComboBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SynPrevMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CbDefSinSelect(Sender: TObject);
    procedure ListBoxTypeClick(Sender: TObject);
    procedure StyleChangeClick(Sender: TObject);
    procedure ColorChange(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure CboEditFontSelect(Sender: TObject);
    procedure CboSizeChange(Sender: TObject);
    procedure SynPrevGutterClick(Sender: TObject; Button: TMouseButton; X,
      Y, Line: Integer; Mark: TSynEditMark);
    procedure SynPrevSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure EditorOptionsChanged(Sender: TObject);
    procedure TrackBarCodeResChange(Sender: TObject);
    procedure TimerNormalDelayTimer(Sender: TObject);
    procedure BtnChooseCodeTemplateClick(Sender: TObject);
    procedure BtnEditCodeTemplateClick(Sender: TObject);
    procedure GroupEnableBoxDisableControls(Sender: TObject);
    procedure EditCodeTemplateChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnRestDefClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioGroupFormatterStylesClick(Sender: TObject);
    procedure ComboBoxBracketStyleChange(Sender: TObject);
    procedure BtnPrevStyleClick(Sender: TObject);
    procedure ComboBoxPointerAlignChange(Sender: TObject);
  private
    { Private declarations }
    ActiveSintax: TSintax;
    Last: Integer;
    Loading: Boolean;
    procedure OptionsChange;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure UpdateLangNow;
    procedure Load;
  end;

var
  FrmEditorOptions: TFrmEditorOptions;

implementation

uses UFrmMain, UUtils, UConfig, TokenUtils, UFrmCodeTemplates, AStyle,
  ULanguages;

{$R *.dfm}

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
begin
  All := Trim('{', S, '}');
  All := StringReplace(All, ';', #13#10, [rfReplaceAll]);
  L := TStringList.Create;
  L.Text := All;
  Style := [];
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

procedure TSintax.UpdateHighlight(Highlight: TSynCustomHighlighter;
  AttributeName: string = '');
var
  I: Integer;
  st: TSintaxType;
begin
  if Length(AttributeName) > 0 then
  begin
    for I := 0 to Highlight.AttrCount - 1 do
      if Highlight.Attribute[I].Name = AttributeName then
        Break;
    if GetType(AttributeName, st) and (I >= 0) then
    begin
      Highlight.Attribute[I].Foreground := st.Foreground;
      Highlight.Attribute[I].Background := st.Background;
      Highlight.Attribute[I].Style := st.Style;
    end;
    Exit;
  end;

  for I := 0 to Highlight.AttrCount - 1 do
    if GetType(Highlight.Attribute[I].Name, st) then
    begin
      Highlight.Attribute[I].Foreground := st.Foreground;
      Highlight.Attribute[I].Background := st.Background;
      Highlight.Attribute[I].Style := st.Style;
    end;

end;

procedure TSintax.UpdateEditor(Editor: TSynMemo; AttributeName: string = '');
var
  I: Integer;
  st: TSintaxType;
begin
  if Length(AttributeName) > 0 then
  begin
    if GetType(AttributeName, st) then
    begin
      I := IndexOf(st);
      case I of
        13:
          begin
            Editor.Gutter.Color := st.Background;
            Editor.Gutter.GradientEndColor := st.Background;
            Editor.Gutter.Font.Color := st.Foreground;
            Editor.Gutter.Font.Style := st.Style;
          end;
        14:
          begin
            Editor.SelectedColor.Background := st.Background;
            Editor.SelectedColor.Foreground := st.Background;
          end;
      end;
    end;
    Exit;
  end;

  if GetType('Gutter', st) then
  begin
    Editor.Gutter.Color := st.Background;
    Editor.Gutter.GradientEndColor := st.Background;
    Editor.Gutter.Font.Color := st.Foreground;
    Editor.Gutter.Font.Style := st.Style;
  end;
  if GetType('Selection', st) then
  begin
    Editor.SelectedColor.Background := st.Background;
    Editor.SelectedColor.Foreground := st.Foreground;
  end;
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

procedure TSintaxList.SetHighlight(Value: TSynCustomHighlighter);
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
  Stx.AddSintaxType('Assembler', clNone);
  Stx.AddSintaxType('Character', clGray);
  Stx.AddSintaxType('Comment', clGreen);
  Stx.AddSintaxType('Float', $000080FF);
  Stx.AddSintaxType('Hexadecimal', $000080FF);
  Stx.AddSintaxType('Identifier', clNone);
  Stx.AddSintaxType('Number', $000080FF);
  Stx.AddSintaxType('Octal', $000080FF);
  Stx.AddSintaxType('Preprocessor', $00004080);
  Stx.AddSintaxType('Reserved Word', $00FF0080);
  Stx.AddSintaxType('Space', clNone);
  Stx.AddSintaxType('String', clGray);
  Stx.AddSintaxType('Symbol', clNavy, clNone, [fsBold]);
  Stx.AddSintaxType('Gutter', clGray, $00E4E4E4);
  Stx.AddSintaxType('Selection', clWindowText, clGray);
  FItemIndex := Add(Stx);

  //Borland
  Stx := TSintax.Create;
  Stx.Name := 'Borland';
  Stx.ReadOnly := True;
  Stx.AddSintaxType('Assembler', clGreen);
  Stx.AddSintaxType('Character', clYellow);
  Stx.AddSintaxType('Comment', clGray);
  Stx.AddSintaxType('Float', clYellow);
  Stx.AddSintaxType('Hexadecimal', clYellow);
  Stx.AddSintaxType('Identifier', clYellow);
  Stx.AddSintaxType('Number', clYellow);
  Stx.AddSintaxType('Octal', clYellow);
  Stx.AddSintaxType('Preprocessor', clYellow);
  Stx.AddSintaxType('Reserved Word', clWhite);
  Stx.AddSintaxType('Space', clNone, clNavy);
  Stx.AddSintaxType('String', clYellow);
  Stx.AddSintaxType('Symbol', clYellow);
  Stx.AddSintaxType('Gutter', clYellow, clNavy);
  Stx.AddSintaxType('Selection', clWindowText, clGray);
  Add(Stx);

  //Visual Studio
  Stx := TSintax.Create;
  Stx.Name := 'Visual Studio';
  Stx.ReadOnly := True;
  Stx.AddSintaxType('Assembler', clRed);
  Stx.AddSintaxType('Character', $001515A3);
  Stx.AddSintaxType('Comment', clGreen);
  Stx.AddSintaxType('Float', clNavy);
  Stx.AddSintaxType('Hexadecimal', clNavy);
  Stx.AddSintaxType('Identifier', clNone);
  Stx.AddSintaxType('Number', clNavy);
  Stx.AddSintaxType('Octal', clNavy);
  Stx.AddSintaxType('Preprocessor', clBlue);
  Stx.AddSintaxType('Reserved Word', clBlue);
  Stx.AddSintaxType('Space', clNone);
  Stx.AddSintaxType('String', $001515A3);
  Stx.AddSintaxType('Symbol', clNone);
  Stx.AddSintaxType('Gutter', clWindowText, clBtnFace);
  Stx.AddSintaxType('Selection', clHighlightText, clHighlight);
  Add(Stx);

  //default
  Stx := TSintax.Create;
  Stx.Name := 'Default';
  Stx.ReadOnly := True;
  Stx.AddSintaxType('Assembler', clNone);
  Stx.AddSintaxType('Character', clGray);
  Stx.AddSintaxType('Comment', clGreen);
  Stx.AddSintaxType('Float', $000080FF);
  Stx.AddSintaxType('Hexadecimal', $000080FF);
  Stx.AddSintaxType('Identifier', clNone);
  Stx.AddSintaxType('Number', $000080FF);
  Stx.AddSintaxType('Octal', $000080FF);
  Stx.AddSintaxType('Preprocessor', $00004080);
  Stx.AddSintaxType('Reserved Word', $00FF0080, clNone, [fsBold]);
  Stx.AddSintaxType('Space', clNone);
  Stx.AddSintaxType('String', clBlue);
  Stx.AddSintaxType('Symbol', clNavy, clNone, [fsBold]);
  Stx.AddSintaxType('Gutter', clGray, $00E4E4E4);
  Stx.AddSintaxType('Selection', clWindowText, clGray);
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
    if CompareText(S, Items[I].Name) = 0 then
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

{TFrmEditorOptions}

procedure TFrmEditorOptions.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmEditorOptions.FormCreate(Sender: TObject);
begin
  Loading := True;
  CboEditFont.Items.AddStrings(Screen.Fonts);
  ActiveSintax := TSintax.Create;
  UpdateLangNow;
  Loading := False;
end;

procedure TFrmEditorOptions.Load;
var
  I: Integer;
  Stx: TSintax;
begin
  Loading := True;
  CboEditFont.ItemIndex := CboEditFont.Items.IndexOf(Font.Name);
  LoadFontSize(Font.Name, CboSize.Items);

  CbDefSin.Clear;
  for I := 0 to FrmFalconMain.SintaxList.Count - 1 do
  begin
    Stx := FrmFalconMain.SintaxList.Items[I];
    CbDefSin.AddItem(Stx.Name, Stx);
  end;
  CbDefSin.ItemIndex := FrmFalconMain.SintaxList.ItemIndex;
  CbDefSinSelect(Self);

  with FrmFalconMain.Config.Editor do
  begin
    //--------------Gemneral---------------------//
    ChbAutoIndt.Checked := AutoIndent;
    ChbInsMode.Checked := InsertMode;
    ChbGrpUnd.Checked := GroupUndo;
    ChbKeepTraiSpa.Checked := KeepTrailingSpaces;

    ChbScrollHint.Checked := ScrollHint;
    ChbTabUnOrIndt.Checked := TabIndentUnindent;
    ChbSmartTabs.Checked := SmartTabs;
    ChbUseTabChar.Checked := UseTabChar;
    ChbEnhHomeKey.Checked := EnhancedHomeKey;
    ChbShowLineChars.Checked := ShowLineChars;

    CboMaxUnd.Text := IntToStr(MaxUndo);
    CboTabWdt.Text := IntToStr(TabWidth);

    ChbHighMatch.Checked := HighligthMatchBraceParentheses;
    ClbN.Selected := NormalColor;
    ClbE.Selected := ErrorColor;
    ClbB.Selected := BgColor;

    ChbHighCurLn.Checked := HighligthCurrentLine;
    ClbCurLn.Selected := CurrentLineColor;

    ChbLinkClick.Checked := LinkClick;
    ClbLinkColor.Selected := LinkColor;
    //---------------- Display -----------------//
    CboEditFont.Text := FontName;
    CboEditFontSelect(Self);
    CboSize.Text := IntToStr(FontSize);
    CboSizeChange(Self);
    ChbShowRMrgn.Checked := ShowRightMargin;
    CboRMrg.Text := IntToStr(RightMargin);
    CboGutterWdt.Text := IntToStr(GutterWidth);
    ChbShowgtt.Checked := ShowGutter;
    ChbShowLnNumb.Checked := ShowLineNumber;
    ChbGrdGutt.Checked := GradientGutter;
    //---------------- Colors ------------------//

    //Formatter
      //Style
    RadioGroupFormatterStyles.ItemIndex := StyleIndex;
    BtnPrevStyle.Visible := RadioGroupFormatterStyles.ItemIndex = 5;
    for I := 0 to TSFormatterIndentation.ControlCount - 1 do
    begin
      TSFormatterIndentation.Controls[I].Enabled := BtnPrevStyle.Visible;
    end;
    for I := 0 to TSFormatterPadding.ControlCount - 1 do
    begin
      TSFormatterPadding.Controls[I].Enabled := BtnPrevStyle.Visible;
    end;
    for I := 0 to TSFormatterFormatting.ControlCount - 1 do
    begin
      TSFormatterFormatting.Controls[I].Enabled := BtnPrevStyle.Visible;
    end;
      //Indentation
    CheckBoxForceUsingTabs.Checked := ForceUsingTabs;
    CheckBoxIndentClasses.Checked := IndentClasses;
    CheckBoxIndentSwitches.Checked := IndentSwitches;
    CheckBoxIndentCase.Checked := IndentCase;
    CheckBoxIndentBrackets.Checked := IndentBrackets;
    CheckBoxIndentBlocks.Checked := IndentBlocks;
    CheckBoxIndentNamespaces.Checked := IndentNamespaces;
    CheckBoxIndentLabels.Checked := IndentLabels;
    CheckBoxIndentMultLinePreprocessor.Checked := IndentMultLine;
    CheckBoxIndentSingleLineComments.Checked := IndentSingleLineComments;
      //Padding
    CheckBoxPadEmptyLines.Checked := PadEmptyLines;
    CheckBoxBreakClosingHeaderBlocks.Checked := BreakClosingHeaderBlocks;
    CheckBoxInsertSpacePaddingOperators.Checked := InsertSpacePaddingOperators;
    CheckBoxInsertSpacePaddingParenthesisOutside.Checked :=
      InsertSpacePaddingParenthesisOutside;
    CheckBoxInsertSpacePaddingParenthesisInside.Checked :=
      InsertSpacePaddingParenthesisInside;
    CheckBoxParenthesisHeaderPadding.Checked := ParenthesisHeaderPadding;
    CheckBoxRemoveExtraSpace.Checked := RemoveExtraSpace;
    CheckBoxDeleteEmptyLines.Checked := DeleteEmptyLines;
    CheckBoxFillEmptyLines.Checked := FillEmptyLines;
      //Formatting
    ComboBoxBracketStyle.ItemIndex := BracketStyle;
    ComboBoxBracketStyleChange(ComboBoxBracketStyle);
    CheckBoxBreakClosingHeadersBrackets.Checked := BreakClosingHeadersBrackets;
    CheckBoxBreakElseIf.Checked := BreakIfElse;
    CheckBoxAddBrackets.Checked := AddBrackets;
    CheckBoxAddOneLineBrackets.Checked := AddOneLineBrackets;
    CheckBoxDontBreakOneLineBlocks.Checked := DontBreakOnelineBlocks;
    CheckBoxDontBreakComplex.Checked := DontBreakComplex;
    CheckBoxConvToSpaces.Checked := ConvertTabToSpaces;
    ComboBoxPointerAlign.ItemIndex := PointerAlign;
    //---------------- Code Resources ------------------//
    ChbCodeCompletion.Checked := CodeCompletion;
    ChbCodeParameters.Checked := CodeParameters;
    ChbTooltopexev.Checked := TooltipExpEval;
    ChbTooltipSymbol.Checked := TooltipSymbol;
    TrackBarCodeRes.Position := CodeDelay - 1;

    ClbCompListConst.Selected := CompListConstant;
    ClbCompListFunc.Selected := CompListFunc;
    ClbCompListVar.Selected := CompListVar;
    ClbCompListType.Selected := CompListType;

    ClbCompListTypedef.Selected := CompListTypedef;
    ClbCompListPreproc.Selected := CompListPreproc;
    ClbCompListSel.Selected := CompListSel;
    ClbCompListBg.Selected := CompListBg;

    EditCodeTemplate.Text := CodeTemplateFile;
  end;
  Loading := False;
end;

procedure TFrmEditorOptions.BtnApplyClick(Sender: TObject);
begin
  BtnApply.Enabled := False;
  ActiveSintax.UpdateHighlight(FrmFalconMain.CppHighligher);
  with FrmFalconMain.Config.Editor do
  begin
    //------------- General ----------------------//
    AutoIndent := ChbAutoIndt.Checked;
    InsertMode := ChbInsMode.Checked;
    GroupUndo := ChbGrpUnd.Checked;
    KeepTrailingSpaces := ChbKeepTraiSpa.Checked;

    ScrollHint := ChbScrollHint.Checked;
    TabIndentUnindent := ChbTabUnOrIndt.Checked;
    SmartTabs := ChbSmartTabs.Checked;
    UseTabChar := ChbUseTabChar.Checked;
    EnhancedHomeKey := ChbEnhHomeKey.Checked;
    ShowLineChars := ChbShowLineChars.Checked;

    MaxUndo := StrToIntDef(CboMaxUnd.Text, 1024);
    TabWidth := StrToIntDef(CboTabWdt.Text, 4);

    HighligthMatchBraceParentheses := ChbHighMatch.Checked;
    NormalColor := ClbN.Selected;
    ErrorColor := ClbE.Selected;
    BgColor := ClbB.Selected;

    HighligthCurrentLine := ChbHighCurLn.Checked;
    CurrentLineColor := ClbCurLn.Selected;

    LinkClick := ChbLinkClick.Checked;
    LinkColor := ClbLinkColor.Selected;
    //---------------- Display -----------------//
    FontName := CboEditFont.Text;
    FontSize := StrToIntDef(CboSize.Text, 10);
    ShowRightMargin := ChbShowRMrgn.Checked;
    RightMargin := StrToIntDef(CboRMrg.Text, 80);
    GutterWidth := StrToIntDef(CboGutterWdt.Text, 30);
    ShowGutter := ChbShowgtt.Checked;
    ShowLineNumber := ChbShowLnNumb.Checked;
    GradientGutter := ChbGrdGutt.Checked;
    //---------------- Colors ------------------//
    if CbDefSin.Items.IndexOf(CbDefSin.Text) < 0 then
      BtnSave.Click;
    FrmFalconMain.SintaxList.ItemIndex := CbDefSin.ItemIndex;
    ActiveSintax := CbDefSin.Text;
    //--------------  formatter  ---------------//
    StyleIndex := RadioGroupFormatterStyles.ItemIndex;
    //Indentation
    ForceUsingTabs := CheckBoxForceUsingTabs.Checked;
    IndentClasses := CheckBoxIndentClasses.Checked;
    IndentSwitches := CheckBoxIndentSwitches.Checked;
    IndentCase := CheckBoxIndentCase.Checked;
    IndentBrackets := CheckBoxIndentBrackets.Checked;
    IndentBlocks := CheckBoxIndentBlocks.Checked;
    IndentNamespaces := CheckBoxIndentNamespaces.Checked;
    IndentLabels := CheckBoxIndentLabels.Checked;
    IndentMultLine := CheckBoxIndentMultLinePreprocessor.Checked;
    IndentSingleLineComments := CheckBoxIndentSingleLineComments.Checked;
    //Padding
    PadEmptyLines := CheckBoxPadEmptyLines.Checked;
    BreakClosingHeaderBlocks := CheckBoxBreakClosingHeaderBlocks.Checked;
    InsertSpacePaddingOperators := CheckBoxInsertSpacePaddingOperators.Checked;
    InsertSpacePaddingParenthesisOutside :=
      CheckBoxInsertSpacePaddingParenthesisOutside.Checked;
    InsertSpacePaddingParenthesisInside :=
      CheckBoxInsertSpacePaddingParenthesisInside.Checked;
    ParenthesisHeaderPadding := CheckBoxParenthesisHeaderPadding.Checked;
    RemoveExtraSpace := CheckBoxRemoveExtraSpace.Checked;
    DeleteEmptyLines := CheckBoxDeleteEmptyLines.Checked;
    FillEmptyLines := CheckBoxFillEmptyLines.Checked;
    //Formatting
    BracketStyle := ComboBoxBracketStyle.ItemIndex;
    BreakClosingHeadersBrackets := CheckBoxBreakClosingHeadersBrackets.Checked;
    BreakIfElse := CheckBoxBreakElseIf.Checked;
    AddBrackets := CheckBoxAddBrackets.Checked;
    AddOneLineBrackets := CheckBoxAddOneLineBrackets.Checked;
    DontBreakOnelineBlocks := CheckBoxDontBreakOneLineBlocks.Checked;
    DontBreakComplex := CheckBoxDontBreakComplex.Checked;
    ConvertTabToSpaces := CheckBoxConvToSpaces.Checked;
    PointerAlign := ComboBoxPointerAlign.ItemIndex;
    //--------------  Code Resources  ----------//
    CodeCompletion := ChbCodeCompletion.Checked;
    CodeParameters := ChbCodeParameters.Checked;
    TooltipExpEval := ChbTooltopexev.Checked;
    TooltipSymbol := ChbTooltipSymbol.Checked;
    CodeDelay := TrackBarCodeRes.Position + 1;

    CompListConstant := ClbCompListConst.Selected;
    CompListFunc := ClbCompListFunc.Selected;
    CompListVar := ClbCompListVar.Selected;
    CompListType := ClbCompListType.Selected;
    CompListTypedef := ClbCompListTypedef.Selected;
    CompListPreproc := ClbCompListPreproc.Selected;
    CompListSel := ClbCompListSel.Selected;
    CompListBg := ClbCompListBg.Selected;

    if FileExists(EditCodeTemplate.Text) then
      CodeTemplateFile := EditCodeTemplate.Text;
  end;
  FrmFalconMain.UpdateOpenedSheets;
end;

procedure TFrmEditorOptions.BtnOkClick(Sender: TObject);
begin
  if ActiveSintax.Changed then
    BtnSave.Click;
  if CbDefSin.ItemIndex >= 0 then
    FrmFalconMain.SintaxList.ItemIndex := CbDefSin.ItemIndex;
  BtnApply.Click;
  Close;
end;

procedure TFrmEditorOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrmEditorOptions.UpdateLangNow;
begin
  Caption := STR_FRM_EDITOR_OPT[1];
  BtnOk.Caption := STR_FRM_PROP[14];
  BtnCancel.Caption := STR_FRM_PROP[15];
  BtnApply.Caption := STR_FRM_PROP[16];
  //General
  TSGeneral.Caption := STR_FRM_EDITOR_OPT[2];
  GroupBox1.Caption := STR_FRM_EDITOR_OPT[3];
  ChbAutoIndt.Caption := STR_FRM_EDITOR_OPT[4];
  ChbInsMode.Caption := STR_FRM_EDITOR_OPT[6];
  ChbGrpUnd.Caption := STR_FRM_EDITOR_OPT[7];
  ChbKeepTraiSpa.Caption := STR_FRM_EDITOR_OPT[8];
  ChbShowLineChars.Caption := STR_FRM_EDITOR_OPT[9];
  ChbScrollHint.Caption := STR_FRM_EDITOR_OPT[10];
  ChbTabUnOrIndt.Caption := STR_FRM_EDITOR_OPT[11];
  ChbSmartTabs.Caption := STR_FRM_EDITOR_OPT[12];
  ChbUseTabChar.Caption := STR_FRM_EDITOR_OPT[13];
  ChbEnhHomeKey.Caption := STR_FRM_EDITOR_OPT[14];
  Label6.Caption := STR_FRM_EDITOR_OPT[15];
  Label16.Caption := STR_FRM_EDITOR_OPT[16];
  GroupBoxHlMatchBP.Caption := '      ' + STR_FRM_EDITOR_OPT[17];
  Label1.Caption := STR_FRM_EDITOR_OPT[18];
  Label2.Caption := STR_FRM_EDITOR_OPT[19];
  Label3.Caption := STR_FRM_EDITOR_OPT[20];
  GroupBox3.Caption := '      ' + STR_FRM_EDITOR_OPT[21];
  Label4.Caption := STR_FRM_EDITOR_OPT[22];
  GroupBox4.Caption := '      ' + STR_FRM_EDITOR_OPT[23];
  Label5.Caption := STR_FRM_EDITOR_OPT[22];
  BtnRestDef.Caption := STR_FRM_EDITOR_OPT[24];
  //Display
  TSDisplay.Caption := STR_FRM_EDITOR_OPT[25];
  Label11.Caption := STR_FRM_EDITOR_OPT[26];
  Label9.Caption := STR_FRM_EDITOR_OPT[27];
  Label10.Caption := STR_FRM_EDITOR_OPT[28];
  GroupBox5.Caption := STR_FRM_EDITOR_OPT[29];
  ChbShowRMrgn.Caption := STR_FRM_EDITOR_OPT[30];
  ChbShowgtt.Caption := STR_FRM_EDITOR_OPT[31];
  ChbShowLnNumb.Caption := STR_FRM_EDITOR_OPT[32];
  ChbGrdGutt.Caption := STR_FRM_EDITOR_OPT[33];
  Button1.Caption := STR_FRM_EDITOR_OPT[24];
  Label7.Caption := STR_FRM_EDITOR_OPT[34];
  Label8.Caption := STR_FRM_EDITOR_OPT[35];
  TSSintax.Caption := STR_FRM_EDITOR_OPT[36];
  Label13.Caption := STR_FRM_EDITOR_OPT[37];
  Label12.Caption := STR_FRM_EDITOR_OPT[38];
  BtnSave.Hint := STR_FRM_EDITOR_OPT[39];
  BtnDel.Hint := STR_FRM_EDITOR_OPT[40];
  Label14.Caption := STR_FRM_EDITOR_OPT[41];
  Label15.Caption := STR_FRM_EDITOR_OPT[42];
  GroupBox6.Caption := STR_FRM_EDITOR_OPT[43];
  ChbBold.Caption := STR_FRM_EDITOR_OPT[44];
  ChbItalic.Caption := STR_FRM_EDITOR_OPT[45];
  ChbUnderl.Caption := STR_FRM_EDITOR_OPT[46];
  //Formatter
  TSFormatter.Caption := STR_FRM_EDITOR_OPT[48];
  //Style
  TSFormatterStyle.Caption := STR_FRM_EDITOR_OPT[49];
  RadioGroupFormatterStyles.Caption := STR_FRM_EDITOR_OPT[43];
  RadioGroupFormatterStyles.Items.Strings[5] := STR_FRM_EDITOR_OPT[50];
  BtnPrevStyle.Caption := STR_FRM_EDITOR_OPT[51];
  GroupBoxFormatterSample.Caption := STR_FRM_EDITOR_OPT[52];
  //Indentation
  TSFormatterIndentation.Caption := STR_FRM_EDITOR_OPT[53];
  CheckBoxForceUsingTabs.Caption := STR_FRM_EDITOR_OPT[54];
  CheckBoxIndentClasses.Caption := STR_FRM_EDITOR_OPT[55];
  CheckBoxIndentSwitches.Caption := STR_FRM_EDITOR_OPT[56];
  CheckBoxIndentCase.Caption := STR_FRM_EDITOR_OPT[57];
  CheckBoxIndentBrackets.Caption := STR_FRM_EDITOR_OPT[58];
  CheckBoxIndentBlocks.Caption := STR_FRM_EDITOR_OPT[59];
  CheckBoxIndentNamespaces.Caption := STR_FRM_EDITOR_OPT[60];
  CheckBoxIndentLabels.Caption := STR_FRM_EDITOR_OPT[61];
  CheckBoxIndentMultLinePreprocessor.Caption := STR_FRM_EDITOR_OPT[62];
  CheckBoxIndentSingleLineComments.Caption := STR_FRM_EDITOR_OPT[63];
  CheckBoxForceUsingTabs.Hint := STR_FRM_EDITOR_OPT[64];
  CheckBoxIndentClasses.Hint := STR_FRM_EDITOR_OPT[65];
  CheckBoxIndentSwitches.Hint := STR_FRM_EDITOR_OPT[66];
  CheckBoxIndentCase.Hint := STR_FRM_EDITOR_OPT[67];
  CheckBoxIndentNamespaces.Hint := STR_FRM_EDITOR_OPT[68];
  CheckBoxIndentLabels.Hint := STR_FRM_EDITOR_OPT[69];
  CheckBoxIndentMultLinePreprocessor.Hint := STR_FRM_EDITOR_OPT[70];
  CheckBoxIndentSingleLineComments.Hint := STR_FRM_EDITOR_OPT[71];
  //Padding
  TSFormatterPadding.Caption := STR_FRM_EDITOR_OPT[72];
  CheckBoxPadEmptyLines.Caption := STR_FRM_EDITOR_OPT[73];
  CheckBoxBreakClosingHeaderBlocks.Caption := STR_FRM_EDITOR_OPT[74];
  CheckBoxInsertSpacePaddingOperators.Caption := STR_FRM_EDITOR_OPT[75];
  CheckBoxInsertSpacePaddingParenthesisOutside.Caption := STR_FRM_EDITOR_OPT[76];
  CheckBoxInsertSpacePaddingParenthesisInside.Caption := STR_FRM_EDITOR_OPT[77];
  CheckBoxParenthesisHeaderPadding.Caption := STR_FRM_EDITOR_OPT[78];
  CheckBoxRemoveExtraSpace.Caption := STR_FRM_EDITOR_OPT[79];
  CheckBoxDeleteEmptyLines.Caption := STR_FRM_EDITOR_OPT[80];
  CheckBoxFillEmptyLines.Caption := STR_FRM_EDITOR_OPT[81];
  CheckBoxPadEmptyLines.Hint := STR_FRM_EDITOR_OPT[82];
  CheckBoxBreakClosingHeaderBlocks.Hint := STR_FRM_EDITOR_OPT[83];
  CheckBoxInsertSpacePaddingOperators.Hint := STR_FRM_EDITOR_OPT[84];
  CheckBoxInsertSpacePaddingParenthesisOutside.Hint := STR_FRM_EDITOR_OPT[85];
  CheckBoxInsertSpacePaddingParenthesisInside.Hint := STR_FRM_EDITOR_OPT[86];
  CheckBoxParenthesisHeaderPadding.Hint := STR_FRM_EDITOR_OPT[87];
  CheckBoxRemoveExtraSpace.Hint := STR_FRM_EDITOR_OPT[88];
  CheckBoxDeleteEmptyLines.Hint := STR_FRM_EDITOR_OPT[89];
  CheckBoxFillEmptyLines.Hint := STR_FRM_EDITOR_OPT[90];
  //formatting
  TSFormatterFormatting.Caption := STR_FRM_EDITOR_OPT[91];
  LabelBracketsStyle.Caption := STR_FRM_EDITOR_OPT[92];
  ComboBoxBracketStyle.Items.Strings[0] := STR_FRM_EDITOR_OPT[93];
  ComboBoxBracketStyle.Items.Strings[1] := STR_FRM_EDITOR_OPT[94];
  ComboBoxBracketStyle.Items.Strings[2] := STR_FRM_EDITOR_OPT[95];
  ComboBoxBracketStyle.Items.Strings[3] := STR_FRM_EDITOR_OPT[96];
  CheckBoxBreakClosingHeadersBrackets.Caption := STR_FRM_EDITOR_OPT[97];
  CheckBoxBreakElseIf.Caption := STR_FRM_EDITOR_OPT[98];
  CheckBoxAddBrackets.Caption := STR_FRM_EDITOR_OPT[99];
  CheckBoxAddOneLineBrackets.Caption := STR_FRM_EDITOR_OPT[100];
  CheckBoxDontBreakOneLineBlocks.Caption := STR_FRM_EDITOR_OPT[101];
  CheckBoxDontBreakComplex.Caption := STR_FRM_EDITOR_OPT[102];
  CheckBoxConvToSpaces.Caption := STR_FRM_EDITOR_OPT[103];
  CheckBoxBreakClosingHeadersBrackets.Hint := STR_FRM_EDITOR_OPT[104];
  CheckBoxBreakElseIf.Hint := STR_FRM_EDITOR_OPT[105];
  CheckBoxAddBrackets.Hint := STR_FRM_EDITOR_OPT[106];
  CheckBoxAddOneLineBrackets.Hint := STR_FRM_EDITOR_OPT[107];
  CheckBoxDontBreakOneLineBlocks.Hint := STR_FRM_EDITOR_OPT[108];
  CheckBoxDontBreakComplex.Hint := STR_FRM_EDITOR_OPT[109];
  CheckBoxConvToSpaces.Hint := STR_FRM_EDITOR_OPT[110];
  Label26.Caption := STR_FRM_EDITOR_OPT[111];
  ComboBoxPointerAlign.Items.Strings[0] := STR_FRM_EDITOR_OPT[112];
  ComboBoxPointerAlign.Items.Strings[1] := STR_FRM_EDITOR_OPT[113];
  ComboBoxPointerAlign.Items.Strings[2] := STR_FRM_EDITOR_OPT[114];
  ComboBoxPointerAlign.Items.Strings[3] := STR_FRM_EDITOR_OPT[115];
  ComboBoxPointerAlign.Hint := STR_FRM_EDITOR_OPT[116];
  //Code Resources
  TSCodeResources.Caption := STR_FRM_EDITOR_OPT[117];
  GroupBox8.Caption := STR_FRM_EDITOR_OPT[118];
  ChbCodeCompletion.Caption := STR_FRM_EDITOR_OPT[119];
  ChbCodeParameters.Caption := STR_FRM_EDITOR_OPT[120];
  ChbTooltopexev.Caption := STR_FRM_EDITOR_OPT[121];
  ChbTooltipSymbol.Caption := STR_FRM_EDITOR_OPT[122];
  LblDelay.Caption := STR_FRM_EDITOR_OPT[123];
  GroupBox9.Caption := STR_FRM_EDITOR_OPT[125];
  Label17.Caption := STR_FRM_EDITOR_OPT[126];
  Label18.Caption := STR_FRM_EDITOR_OPT[127];
  Label19.Caption := STR_FRM_EDITOR_OPT[128];
  Label20.Caption := STR_FRM_EDITOR_OPT[129];
  Label24.Caption := STR_FRM_EDITOR_OPT[130];
  Label21.Caption := STR_FRM_EDITOR_OPT[131];
  Label23.Caption := STR_FRM_EDITOR_OPT[132];
  Label22.Caption := STR_FRM_EDITOR_OPT[133];
  GroupBox7.Caption := STR_FRM_EDITOR_OPT[134];
  Label25.Caption := STR_FRM_EDITOR_OPT[135];
  BtnChooseCodeTemplate.Hint := STR_FRM_EDITOR_OPT[136];
  BtnEditCodeTemplate.Hint := STR_FRM_EDITOR_OPT[137];
end;

procedure TFrmEditorOptions.SynPrevGutterClick(Sender: TObject;
  Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  st: TSintaxType;
  I: Integer;
begin
  if ActiveSintax.GetType('Gutter', st) then
  begin
    I := ActiveSintax.IndexOf(st);
    if I < 0 then
      Exit;
    ListBoxType.ItemIndex := I;
    ListBoxType.Selected[I] := True;
    ListBoxTypeClick(Self);
  end
end;

procedure TFrmEditorOptions.SynPrevMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  S, AttrName: string;
  bc: TBufferCoord;
  attr: TSynHighlighterAttributes;
  st: TSintaxType;
  I: Integer;
begin
  bc := SynPrev.DisplayToBufferPos(SynPrev.PixelsToRowColumn(X, Y));
  if X <= (SynPrev.Gutter.Width + SynPrev.Gutter.RightOffset -
    SynPrev.Gutter.LeftOffset) then
    Exit;
  if bc.Line = 10 then
  begin
    AttrName := 'Selection';
  end
  else
  begin
    if not SynPrev.GetHighlighterAttriAtRowCol(bc, S, attr) then
      AttrName := 'Space'
    else
      AttrName := attr.Name;
  end;

  if ActiveSintax.GetType(AttrName, st) then
  begin
    I := ActiveSintax.IndexOf(st);
    if I < 0 then
      Exit;
    //SynPrev.Cursor := crIBeam;
    ListBoxType.ItemIndex := I;
    ListBoxType.Selected[I] := True;
    ListBoxTypeClick(Self);
  end {
  else
    SynPrev.Cursor := crArrow};

end;

procedure TFrmEditorOptions.FormDestroy(Sender: TObject);
begin
  ActiveSintax.Free;
  FrmEditorOptions := nil;
end;

procedure TFrmEditorOptions.CbDefSinSelect(Sender: TObject);
var
  I: Integer;
  StxTpy: TSintaxType;
begin
  if CbDefSin.ItemIndex < 0 then
  begin
    BtnSave.Enabled := ActiveSintax.Changed;
    BtnDel.Enabled := False;
    Exit;
  end;
  ActiveSintax.Assign(FrmFalconMain.SintaxList.Items[CbDefSin.ItemIndex]);
  BtnDel.Enabled := not ActiveSintax.ReadOnly;
  BtnSave.Enabled := ActiveSintax.Changed;
  ListBoxType.Items.Clear;
  for I := 0 to ActiveSintax.Count - 1 do
    ListBoxType.Items.Add(ActiveSintax.Items[I].Name);
  if ActiveSintax.Count = 0 then
    Exit;
  if Last >= ActiveSintax.Count then
    Last := 0;

  StxTpy := ActiveSintax.Items[Last];
  ListBoxType.ItemIndex := Last;
  ListBoxType.Selected[Last] := True;
  ClbFore.Selected := StxTpy.Foreground;
  ClbBack.Selected := StxTpy.Background;
  ChbBold.Checked := (fsBold in StxTpy.Style);
  ChbItalic.Checked := (fsItalic in StxTpy.Style);
  ChbUnderl.Checked := (fsUnderline in StxTpy.Style);
  ActiveSintax.UpdateHighlight(SynPrev.Highlighter);
  ActiveSintax.UpdateEditor(SynPrev);
  OptionsChange;
end;

procedure TFrmEditorOptions.ListBoxTypeClick(Sender: TObject);
var
  StxTpy: TSintaxType;
begin
  if ListBoxType.ItemIndex = Last then
    Exit;
  Last := ListBoxType.ItemIndex;
  StxTpy := ActiveSintax.Items[Last];
  Loading := True;
  ListBoxType.ItemIndex := Last;
  ListBoxType.Selected[Last] := True;
  ClbFore.Selected := StxTpy.Foreground;
  ClbBack.Selected := StxTpy.Background;
  ChbBold.Checked := (fsBold in StxTpy.Style);
  ChbItalic.Checked := (fsItalic in StxTpy.Style);
  ChbUnderl.Checked := (fsUnderline in StxTpy.Style);
  Loading := False;
end;

procedure TFrmEditorOptions.StyleChangeClick(Sender: TObject);
var
  NewStyle: TFontStyles;
  AttrName, NewName: string;
  I: Integer;
  st: TSintaxType;
begin
  if Loading then
    Exit;
  NewStyle := [];
  if ChbBold.Checked then
    NewStyle := NewStyle + [fsBold];
  if ChbItalic.Checked then
    NewStyle := NewStyle + [fsItalic];
  if ChbUnderl.Checked then
    NewStyle := NewStyle + [fsUnderline];

  if (ListBoxType.ItemIndex < 0) then
    Exit;
  AttrName := ListBoxType.Items[ListBoxType.ItemIndex];

  if ActiveSintax.GetType(AttrName, st) then
  begin
    if st.Style = NewStyle then
      Exit;
    st.Style := NewStyle;
  end;
  BtnSave.Enabled := True;

  if (AttrName <> 'Gutter') and (AttrName <> 'Selection') then
  begin
    ActiveSintax.UpdateHighlight(SynPrev.Highlighter, AttrName);
  end
  else
    ActiveSintax.UpdateEditor(SynPrev, AttrName);

  if ActiveSintax.ReadOnly then
  begin
    if not ActiveSintax.Changed then
    begin
      ActiveSintax.Changed := True;
      CbDefSin.ItemIndex := -1;
      NewName := STR_FRM_EDITOR_OPT[47];
      I := 0;
      while CbDefSin.Items.IndexOf(NewName) >= 0 do
      begin
        Inc(I);
        NewName := STR_FRM_EDITOR_OPT[47] + IntToStr(I);
      end;
      CbDefSin.Text := NewName;
    end;
  end
  else
    ActiveSintax.Changed := True;
  OptionsChange;
end;

procedure TFrmEditorOptions.ColorChange(Sender: TObject);
var
  AttrName, NewName: string;
  I: Integer;
  st: TSintaxType;
begin
  if (ListBoxType.ItemIndex < 0) then
    Exit;
  AttrName := ListBoxType.Items[ListBoxType.ItemIndex];

  if ActiveSintax.GetType(AttrName, st) then
  begin
    if (st.Foreground = ClbFore.Selected) and
      (st.Background = ClbBack.Selected) then
      Exit;
    st.Foreground := ClbFore.Selected;
    st.Background := ClbBack.Selected;
  end;
  BtnSave.Enabled := True;
  if (AttrName <> 'Gutter') and (AttrName <> 'Selection') then
  begin
    ActiveSintax.UpdateHighlight(SynPrev.Highlighter, AttrName);
  end
  else
  begin
    ActiveSintax.UpdateEditor(SynPrev, AttrName);
    SynPrev.InvalidateLine(10);
  end;
  if ActiveSintax.ReadOnly then
  begin
    if not ActiveSintax.Changed then
    begin
      ActiveSintax.Changed := True;
      CbDefSin.ItemIndex := -1;
      NewName := STR_FRM_EDITOR_OPT[47];
      I := 0;
      while CbDefSin.Items.IndexOf(NewName) >= 0 do
      begin
        Inc(I);
        NewName := STR_FRM_EDITOR_OPT[47] + IntToStr(I);
      end;
      CbDefSin.Text := NewName;
    end;
  end
  else
    ActiveSintax.Changed := True;
  OptionsChange;
end;

procedure TFrmEditorOptions.BtnSaveClick(Sender: TObject);
var
  stx: TSintax;
  Index: Integer;
  S: string;
begin
  ActiveSintax.Changed := False;
  BtnSave.Enabled := False;
  S := CbDefSin.Text;
  Index := CbDefSin.Items.IndexOf(S);
  if Index >= 0 then
  begin
    stx := FrmFalconMain.SintaxList.Items[Index];
    if not stx.ReadOnly then
      stx.Assign(ActiveSintax);
    Exit;
  end;
  stx := TSintax.Create;
  stx.Assign(ActiveSintax);
  stx.ReadOnly := False;
  stx.Name := S;
  FrmFalconMain.SintaxList.Insert(0, stx);
  CbDefSin.Items.Insert(0, S);
  CbDefSin.ItemIndex := 0;
  CbDefSinSelect(CbDefSin);
end;

procedure TFrmEditorOptions.BtnDelClick(Sender: TObject);
var
  Index: Integer;
  Equals: Boolean;
begin
  Equals := False;
  Index := CbDefSin.ItemIndex;
  if (Index < 0) or ActiveSintax.ReadOnly then
    Exit;
  with FrmFalconMain do
  begin
    SintaxList.Delete(Index);
    if Index = SintaxList.ItemIndex then
    begin
      Equals := True;
      SintaxList.ItemIndex := SintaxList.Count - 1;
      Config.Editor.ActiveSintax := SintaxList.Selected.Name;
      UpdateOpenedSheets;
    end;
  end;

  CbDefSin.Items.Delete(Index);
  if CbDefSin.Items.Count > 0 then
  begin
    if Equals then
      CbDefSin.ItemIndex := CbDefSin.Items.Count - 1
    else
      CbDefSin.ItemIndex := 0;
    CbDefSinSelect(CbDefSin);
  end;
end;

procedure TFrmEditorOptions.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditorOptions.OptionsChange;
begin
  if Loading then
    Exit;
  //-----------------------------//
  BtnApply.Enabled := True;
end;

procedure TFrmEditorOptions.CboEditFontSelect(Sender: TObject);
var
  S: string;
begin
  if CboEditFont.ItemIndex < 0 then
    Exit;
  PanelTest.Font.Name := CboEditFont.Text;
  S := CboSize.Text;
  CboSize.Clear;
  LoadFontSize(Font.Name, CboSize.Items);
  CboSize.ItemIndex := CboSize.Items.IndexOf(S);
  if CboSize.ItemIndex < 0 then
    CboSize.Text := S;
  SynPrev.Font.Name := CboEditFont.Text;
  OptionsChange;
end;

procedure TFrmEditorOptions.CboSizeChange(Sender: TObject);
begin
  PanelTest.Font.Size := StrToIntDef(CboSize.Text, 10);
  SynPrev.Font.Size := PanelTest.Font.Size;
  OptionsChange;
end;

procedure TFrmEditorOptions.SynPrevSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  st: TSintaxType;
begin
  if Line = 10 then
  begin
    if not ActiveSintax.GetType('Selection', st) then
      Exit;
    Special := True;
    FG := st.Foreground;
    BG := st.Background;
  end;
end;

procedure TFrmEditorOptions.EditorOptionsChanged(Sender: TObject);
begin
  if Sender = ChbShowRMrgn then
  begin
    Label7.Enabled := ChbShowRMrgn.Checked;
    CboRMrg.Enabled := ChbShowRMrgn.Checked;
  end
  else if Sender = ChbShowgtt then
  begin
    Label8.Enabled := ChbShowgtt.Checked;
    CboGutterWdt.Enabled := ChbShowgtt.Checked;
    ChbShowLnNumb.Enabled := ChbShowgtt.Checked;
    ChbGrdGutt.Enabled := ChbShowgtt.Checked;
  end
  else if Sender = CheckBoxAddOneLineBrackets then
  begin
    CheckBoxDontBreakOneLineBlocks.Enabled :=
      not CheckBoxAddOneLineBrackets.Checked;
  end
  else if Sender = CheckBoxForceUsingTabs then
  begin
    CheckBoxConvToSpaces.Enabled := not CheckBoxForceUsingTabs.Checked;
    if not CheckBoxConvToSpaces.Enabled then
      CheckBoxConvToSpaces.Checked := False;
  end;
  OptionsChange;
end;

procedure TFrmEditorOptions.TrackBarCodeResChange(Sender: TObject);
var
  S: string;
begin
  S := Format(STR_FRM_EDITOR_OPT[123] + ' ' +
    STR_FRM_EDITOR_OPT[124], [(TrackBarCodeRes.Position + 1) / 10]);
  S := StringReplace(S, ',', '.', [rfReplaceAll]);
  TimerNormalDelay.Enabled := False;
  TimerNormalDelay.Enabled := True;
  LblDelay.Caption := S;
  OptionsChange;
end;

procedure TFrmEditorOptions.TimerNormalDelayTimer(Sender: TObject);
begin
  LblDelay.Caption := STR_FRM_EDITOR_OPT[123];
  TimerNormalDelay.Enabled := False;
end;

procedure TFrmEditorOptions.BtnChooseCodeTemplateClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    EditCodeTemplate.Text := OpenDialog.FileName;
  end;
end;

procedure TFrmEditorOptions.BtnEditCodeTemplateClick(Sender: TObject);
begin
  if not Assigned(FrmCodeTemplates) then
    FrmCodeTemplates := TFrmCodeTemplates.CreateParented(Handle);
  FrmCodeTemplates.ShowModal;
end;

procedure TFrmEditorOptions.GroupEnableBoxDisableControls(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TWinControl(Sender).Parent.ControlCount - 1 do
  begin
    if TWinControl(Sender).Parent.Controls[I] <> Sender then
      TWinControl(Sender).Parent.Controls[I].Enabled := TCheckBox(Sender).Checked;
  end;
  OptionsChange;
end;

procedure TFrmEditorOptions.EditCodeTemplateChange(Sender: TObject);
begin
  BtnEditCodeTemplate.Enabled := FileExists(EditCodeTemplate.Text);
  OptionsChange;
end;

procedure TFrmEditorOptions.Button1Click(Sender: TObject);
begin
  CboEditFont.ItemIndex := CboEditFont.Items.IndexOf('Courier New');
  CboEditFontSelect(Sender);
  CboSize.Text := '10';
  CboSizeChange(Sender);
  ChbShowRMrgn.Checked := True;
  ChbShowgtt.Checked := True;
  ChbShowLnNumb.Checked := True;
  ChbGrdGutt.Checked := False;
  CboRMrg.ItemIndex := 0;
  CboGutterWdt.ItemIndex := 0;
end;

procedure TFrmEditorOptions.BtnRestDefClick(Sender: TObject);
begin
//
  ChbAutoIndt.Checked := True;
  ChbInsMode.Checked := True;
  ChbGrpUnd.Checked := True;
  ChbKeepTraiSpa.Checked := True;
  //-------------------------
  ChbScrollHint.Checked := True;
  ChbTabUnOrIndt.Checked := True;
  ChbSmartTabs.Checked := True;
  ChbUseTabChar.Checked := False;
  ChbEnhHomeKey.Checked := False;
  ChbShowLineChars.Checked := False;
  CboMaxUnd.ItemIndex := 0;
  CboTabWdt.ItemIndex := 1;
  //-----------------------------
  ChbHighMatch.Checked := True;
  ClbN.Selected := clBlue;
  ClbE.Selected := clRed;
  ClbB.Selected := clSkyBlue;
  //---------------------------
  ChbHighCurLn.Checked := True;
  ClbCurLn.Selected := $FFE0C2;
  //---------------------------
  ChbLinkClick.Checked := True;
  ClbLinkColor.Selected := clBlue;
  OptionsChange;
end;

procedure TFrmEditorOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmEditorOptions.BtnPrevStyleClick(Sender: TObject);
var
  formatter: TAStyle;
  caret: TBufferCoord;
  topLine, I: Integer;
begin
  formatter := TAStyle.Create;
  formatter.MaxInstatementIndent := StrToIntDef(CboRMrg.Text, 80);
  BtnPrevStyle.Visible := RadioGroupFormatterStyles.ItemIndex = 5;
  for I := 0 to TSFormatterIndentation.ControlCount - 1 do
  begin
    TSFormatterIndentation.Controls[I].Enabled := BtnPrevStyle.Visible;
  end;
  for I := 0 to TSFormatterPadding.ControlCount - 1 do
  begin
    TSFormatterPadding.Controls[I].Enabled := BtnPrevStyle.Visible;
  end;
  for I := 0 to TSFormatterFormatting.ControlCount - 1 do
  begin
    TSFormatterFormatting.Controls[I].Enabled := BtnPrevStyle.Visible;
  end;
  case RadioGroupFormatterStyles.ItemIndex of
    0: // ansi
      begin
        formatter.Style := fsALLMAN;
        formatter.BracketFormat := bfBreakMode;
        formatter.Properties[aspIndentNamespace] := True;
        formatter.Properties[aspSingleStatements] := True;
        formatter.Properties[aspBreakOneLineBlocks] := True;
      end;
    1: // K&R
      begin
        formatter.Style := fsKR;
        formatter.BracketFormat := bfAtatch;
        formatter.Properties[aspIndentNamespace] := True;
        formatter.Properties[aspSingleStatements] := True;
        formatter.Properties[aspBreakOneLineBlocks] := True;
      end;
    2: //Linux
      begin
        formatter.Style := fsLINUX;
        formatter.TabWidth := 8;
        formatter.SpaceWidth := 8;
        formatter.BracketFormat := bfBDAC;
        formatter.Properties[aspIndentNamespace] := True;
        formatter.Properties[aspSingleStatements] := True;
        formatter.Properties[aspBreakOneLineBlocks] := True;
      end;
    3: //GNU
      begin
        formatter.Style := fsGNU;
        formatter.TabWidth := 2;
        formatter.SpaceWidth := 2;
        formatter.BracketFormat := bfBreakMode;
        formatter.Properties[aspIndentBlock] := True;
        formatter.Properties[aspIndentNamespace] := True;
        formatter.Properties[aspSingleStatements] := True;
        formatter.Properties[aspBreakOneLineBlocks] := True;
      end;
    4: //java
      begin
        formatter.Style := fsJAVA;
        formatter.BracketFormat := bfAtatch;
        formatter.Properties[aspSingleStatements] := True;
        formatter.Properties[aspBreakOneLineBlocks] := True;
      end;
    5: //custom
      begin
        formatter.Style := fsNONE;
        formatter.TabWidth := StrToIntDef(CboTabWdt.Text, 4);
        formatter.SpaceWidth := StrToIntDef(CboTabWdt.Text, 4);

      //Indentation
        formatter.ForceUsingTabs := CheckBoxForceUsingTabs.Checked;
        formatter.Properties[aspIndentClass] := CheckBoxIndentClasses.Checked;
        formatter.Properties[aspIndentSwitch] := CheckBoxIndentSwitches.Checked;
        formatter.Properties[aspIndentCase] := CheckBoxIndentCase.Checked;
        formatter.Properties[aspIndentBracket] := CheckBoxIndentBrackets.Checked;
        formatter.Properties[aspIndentBlock] := CheckBoxIndentBlocks.Checked;
        formatter.Properties[aspIndentNamespace] := CheckBoxIndentNamespaces.Checked;
        formatter.Properties[aspIndentLabels] := CheckBoxIndentLabels.Checked;
        formatter.Properties[aspIndentMultLinePreprocessor] := CheckBoxIndentMultLinePreprocessor.Checked;
        formatter.Properties[aspIndentCol1Comments] :=
          CheckBoxIndentSingleLineComments.Checked;

      //Padding
        formatter.Properties[aspBreakBlocks] := CheckBoxPadEmptyLines.Checked;
        formatter.Properties[aspBreakClosingHeaderBlocks] := CheckBoxBreakClosingHeaderBlocks.Checked;
        formatter.Properties[aspOperatorPadding] := CheckBoxInsertSpacePaddingOperators.Checked;
        formatter.Properties[aspParensOutsidePadding] := CheckBoxInsertSpacePaddingParenthesisOutside.Checked;
        formatter.Properties[aspParensInsidePadding] := CheckBoxInsertSpacePaddingParenthesisInside.Checked;
        formatter.Properties[aspParensHeaderPadding] := CheckBoxParenthesisHeaderPadding.Checked;
        formatter.Properties[aspParensUnPadding] := CheckBoxRemoveExtraSpace.Checked;
        formatter.Properties[aspDeleteEmptyLines] := CheckBoxDeleteEmptyLines.Checked;
        formatter.Properties[aspFillEmptyLines] := CheckBoxFillEmptyLines.Checked;

      //Formatting
        case ComboBoxBracketStyle.ItemIndex of
          1: formatter.BracketFormat := bfBreakMode; //Break
          2: formatter.BracketFormat := bfAtatch; //Attach
          3: formatter.BracketFormat := bfBDAC; //Linux
        { TODO -oMazin -c : formatter.BracketFormat := bfRunIn; 24/08/2012 22:23:50 }
        { TODO -oMazin -c : formatter.BracketFormat := bfStroustrup; 24/08/2012 22:24:27 }
        else
        //None
          formatter.BracketFormat := bfNone;
        end;
        if (ComboBoxBracketStyle.ItemIndex < 2) then //Does not work
          formatter.Properties[aspBreakClosingHeaderBrackets] := CheckBoxBreakClosingHeadersBrackets.Checked;
        formatter.Properties[aspBreakElseIfs] := CheckBoxBreakElseIf.Checked;
        formatter.Properties[aspAddBrackets] := CheckBoxAddBrackets.Checked;
        formatter.Properties[aspAddOneLineBrackets] := CheckBoxAddOneLineBrackets.Checked;
        formatter.Properties[aspBreakOneLineBlocks] := not CheckBoxDontBreakOneLineBlocks.Checked;
        formatter.Properties[aspSingleStatements] := CheckBoxDontBreakComplex.Checked;
        formatter.Properties[aspTabSpaceConversion] := CheckBoxConvToSpaces.Checked;
        case ComboBoxPointerAlign.ItemIndex of
          1: formatter.PointerAlign := paType;
          2: formatter.PointerAlign := paMiddle;
          3: formatter.PointerAlign := paName;
        else
          formatter.PointerAlign := paNone;
        end;
      end;
  end;
  caret := SynMemoSample.CaretXY;
  topLine := SynMemoSample.TopLine;
  SynMemoSample.SelectAll;
  SynMemoSample.SelText := formatter.Format(SynMemoSample.Text);
  SynMemoSample.CaretXY := caret;
  SynMemoSample.TopLine := topLine;
  formatter.Free;
end;

procedure TFrmEditorOptions.RadioGroupFormatterStylesClick(Sender: TObject);
begin
  OptionsChange;
  BtnPrevStyleClick(Sender);
end;

procedure TFrmEditorOptions.ComboBoxBracketStyleChange(Sender: TObject);
begin
  CheckBoxBreakClosingHeadersBrackets.Enabled := (ComboBoxBracketStyle.ItemIndex < 2)
    and (RadioGroupFormatterStyles.ItemIndex = 5);
  OptionsChange;
end;

procedure TFrmEditorOptions.ComboBoxPointerAlignChange(Sender: TObject);
begin
  OptionsChange;
end;

end.
