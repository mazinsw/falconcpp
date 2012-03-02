unit AStyle;

interface

uses
  Windows;

const
  astyledll = 'astyle.dll';

  //AStyle properties
  //Indentation
  aspIndentClass                = 'IndentClass';
  aspIndentSwitch               = 'IndentSwitch';
  aspIndentCase                 = 'IndentCase';
  aspIndentBracket              = 'IndentBracket';
  aspIndentBlock                = 'IndentBlock';
  aspIndentNamespace            = 'IndentNamespace';
  aspIndentLabels               = 'IndentLabels';
  aspIndentMultLinePreprocessor = 'IndentMultLinePreprocessor';
  aspIndentCol1Comments         = 'IndentCol1Comments';

  //padding
  aspBreakBlocks                = 'BreakBlocks';
  aspBreakClosingHeaderBlocks   = 'BreakClosingHeaderBlocks';
  aspOperatorPadding            = 'OperatorPadding';
	aspParensOutsidePadding       = 'ParensOutsidePadding';
	aspParensInsidePadding        = 'ParensInsidePadding';
  aspParensHeaderPadding        = 'ParensHeaderPadding';
  aspParensUnPadding            = 'ParensUnPadding';
  aspDeleteEmptyLines           = 'DeleteEmptyLines';
  aspFillEmptyLines             = 'FillEmptyLines';

  //formatting
  aspBreakClosingHeaderBrackets = 'BreakClosingHeaderBrackets';
  aspBreakElseIfs               = 'BreakElseIfs';
  aspAddBrackets                = 'AddBrackets';
	aspAddOneLineBrackets         = 'AddOneLineBrackets';
	aspBreakOneLineBlocks         = 'BreakOneLineBlocks';
  aspSingleStatements           = 'SingleStatements';
	aspTabSpaceConversion         = 'TabSpaceConversion';

type
  TAStyleCreate = function: Pointer; cdecl;
  TAStyleSetStyle = procedure(astyle: Pointer; style: Integer); cdecl;
  TAStyleSetBracketFormat = procedure(astyle: Pointer; format: Integer); cdecl;
  TAStyleSetPointerAlign = procedure(astyle: Pointer; align: Integer); cdecl;
  TAStyleSetProperty = procedure(astyle: Pointer; prop: PChar; value: LongBool); cdecl;
  TAStyleForceUsingTabs = procedure(astyle: Pointer; value: LongBool); cdecl;
  TAStyleSetTabWidth = procedure(astyle: Pointer; value: Integer); cdecl;
  TAStyleSetSpaceWidth = procedure(astyle: Pointer; value: Integer); cdecl;
  TAStyleSetMaxInstatementIndent = procedure(astyle: Pointer; value: Integer); cdecl;
  TAStyleFormatText = function(astyle: Pointer; const src: PChar): Integer; cdecl;
  TAStyleText = function(astyle: Pointer): PChar; cdecl;
  TAStyleFree = procedure(astyle: Pointer); cdecl;

  TFormatterStyle = (fsNONE,
                     fsALLMAN, //ANSI
                     fsJAVA,
                     fsKR,
                     fsSTROUSTRUP,
                     fsWHITESMITH,
                     fsBANNER,
                     fsGNU,
                     fsLINUX,
                     fsHORSTMANN,
                     fs1TBS,
                     fsPICO,
                     fsLISP);
                     
  TBracketFormat = (bfNone,
                    bfAtatch,
                    bfBreakMode,
                    bfBDAC,
                    bfStroustrup,
                    bfRunIn);
  TPointerAlign = (paNone,
                   paType,
                   paMiddle,
                   paName);

  TAStyle = class
  private
    astyle: Pointer;
    FStyle: TFormatterStyle;
    FPointerAlign: TPointerAlign;
    FBracketFormat: TBracketFormat;
    FForceUsingTabs: Boolean;
    FTabWidth: Integer;
    FSpaceWidth: Integer;
    FMaxInstatementIndent: Integer;
    procedure SetStyle(Value: TFormatterStyle);
    procedure SetBracketFormat(Value: TBracketFormat);
    procedure SetPointerAlign(Value: TPointerAlign);
    procedure SetProperty(Index: String; Value: Boolean);
    procedure SetForceUsingTabs(Value: Boolean);
    procedure SetTabWidth(Value: Integer);
    procedure SetSpaceWidth(Value: Integer);
    procedure SetMaxInstatementIndent(Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Format(const Source: String): String;
    property Style: TFormatterStyle read FStyle write SetStyle;
    property BracketFormat: TBracketFormat read FBracketFormat
      write SetBracketFormat;
    property PointerAlign: TPointerAlign read FPointerAlign
      write SetPointerAlign;
    property Properties[Index: String]: Boolean write SetProperty;
    property ForceUsingTabs: Boolean write SetForceUsingTabs;
    property TabWidth: Integer write SetTabWidth;
    property SpaceWidth: Integer write SetSpaceWidth;
    property MaxInstatementIndent: Integer write SetMaxInstatementIndent;
  end;

  function AStyleLoaded: Boolean;

implementation

uses SysUtils;

var
  astyleModule: HMODULE = 0;
  AStyleCreate: TAStyleCreate = nil;
  AStyleSetStyle: TAStyleSetStyle = nil;
  AStyleSetBracketFormat: TAStyleSetBracketFormat = nil;
  AStyleSetPointerAlign: TAStyleSetPointerAlign = nil;
  AStyleSetProperty: TAStyleSetProperty = nil;
  AStyleForceUsingTabs: TAStyleForceUsingTabs = nil;
  AStyleSetTabWidth: TAStyleSetTabWidth = nil;
  AStyleSetSpaceWidth: TAStyleSetSpaceWidth = nil;
  AStyleSetMaxInstatementIndent: TAStyleSetMaxInstatementIndent=  nil;
  AStyleFormatText: TAStyleFormatText = nil;
  AStyleText: TAStyleText = nil;
  AStyleFree: TAStyleFree = nil;

constructor TAStyle.Create;
begin
  inherited Create;
  if Assigned(AStyleCreate) then
  begin
    astyle := AStyleCreate();
    Style := fsALLMAN;
    ForceUsingTabs := False;
    TabWidth := 4;
  end;
end;

destructor TAStyle.Destroy;
begin
  if Assigned(AStyleFree) and Assigned(astyle) then
    AStyleFree(astyle);
  inherited Destroy;
end;

procedure TAStyle.SetStyle(Value: TFormatterStyle);
begin
  if Value <> FStyle then
  begin
    if not Assigned(astyle) or not Assigned(AStyleSetStyle) then Exit;
    AStyleSetStyle(astyle, Integer(Value));
    FStyle := Value;
  end;
end;

procedure TAStyle.SetBracketFormat(Value: TBracketFormat);
begin
  if Value <> FBracketFormat then
  begin
    if not Assigned(astyle) or not Assigned(AStyleSetBracketFormat) then Exit;
    AStyleSetBracketFormat(astyle, Integer(Value));
    FBracketFormat := Value;
  end;
end;

procedure TAStyle.SetPointerAlign(Value: TPointerAlign);
begin
  if Value <> FPointerAlign then
  begin
    if not Assigned(astyle) or not Assigned(AStyleSetPointerAlign) then Exit;
    AStyleSetPointerAlign(astyle, Integer(Value));
    FPointerAlign := Value;
  end;
end;

procedure TAStyle.SetProperty(Index: String; Value: Boolean);
begin
  if not Assigned(astyle) or not Assigned(AStyleSetProperty) then
    Exit;
  AStyleSetProperty(astyle, PChar(Index), Value);
end;

procedure TAStyle.SetForceUsingTabs(Value: Boolean);
begin
  if (Value = FForceUsingTabs) or not Assigned(astyle)
      or not Assigned(AStyleForceUsingTabs) then
    Exit;
  AStyleForceUsingTabs(astyle, Value);
  FForceUsingTabs := Value;
end;

procedure TAStyle.SetTabWidth(Value: Integer);
begin
  if (Value = FTabWidth) or not Assigned(astyle)
      or not Assigned(AStyleSetTabWidth) or (Value < 1) then Exit;
  FTabWidth := Value;
  AStyleSetTabWidth(astyle, Value);
end;

procedure TAStyle.SetSpaceWidth(Value: Integer);
begin
  if (Value = FSpaceWidth) or not Assigned(astyle)
      or not Assigned(AStyleSetSpaceWidth) or (Value < 0) then Exit;
  FSpaceWidth := Value;
  AStyleSetSpaceWidth(astyle, Value);
end;

procedure TAStyle.SetMaxInstatementIndent(Value: Integer);
begin
  if (Value = FMaxInstatementIndent) or not Assigned(astyle)
      or not Assigned(AStyleSetMaxInstatementIndent) or (Value < 0) then Exit;
  FMaxInstatementIndent := Value;
  AStyleSetMaxInstatementIndent(astyle, Value);
end;

function TAStyle.Format(const Source: String): String;
begin
  if not Assigned(astyle) or not Assigned(AStyleFormatText) or
     not Assigned(AStyleText) then
  begin
    Result := Source;
    Exit;
  end;
  if AStyleFormatText(astyle, PChar(Source)) <> 0 then
  begin
    Result := Source;
    Exit;
  end;
  Result := StrPas(AStyleText(astyle));
end;

procedure AStyleLoadLibrary;
begin
  astyleModule := LoadLibrary(astyledll);
  if astyleModule = 0 then Exit;
  AStyleCreate := GetProcAddress(astyleModule, 'AStyleCreate');
  AStyleSetStyle := GetProcAddress(astyleModule, 'AStyleSetStyle');
  AStyleSetBracketFormat := GetProcAddress(astyleModule, 'AStyleSetBracketFormat');
  AStyleSetPointerAlign := GetProcAddress(astyleModule, 'AStyleSetPointerAlign');
  AStyleSetProperty := GetProcAddress(astyleModule, 'AStyleSetProperty');
  AStyleForceUsingTabs := GetProcAddress(astyleModule, 'AStyleForceUsingTabs');
  AStyleSetSpaceWidth := GetProcAddress(astyleModule, 'AStyleSetSpaceWidth');
  AStyleSetMaxInstatementIndent :=
    GetProcAddress(astyleModule, 'AStyleSetMaxInstatementIndent');
  AStyleFormatText := GetProcAddress(astyleModule, 'AStyleFormatText');
  AStyleText := GetProcAddress(astyleModule, 'AStyleText');
  AStyleFree := GetProcAddress(astyleModule, 'AStyleFree');
end;

procedure AStyleFreeLibrary;
begin
  if astyleModule <> 0 then
    FreeLibrary(astyleModule);
  astyleModule := 0;
  AStyleCreate := nil;
  AStyleSetStyle := nil;
  AStyleSetBracketFormat := nil;
  AStyleSetPointerAlign := nil;
  AStyleSetProperty := nil;
  AStyleForceUsingTabs := nil;
  AStyleSetTabWidth := nil;
  AStyleSetSpaceWidth := nil;
  AStyleSetMaxInstatementIndent := nil;
  AStyleFormatText := nil;
  AStyleText := nil;
  AStyleFree := nil;
end;

function AStyleLoaded: Boolean;
begin
  Result := astyleModule <> 0;
end;

initialization
  AStyleLoadLibrary;
finalization
  AStyleFreeLibrary;
end.
