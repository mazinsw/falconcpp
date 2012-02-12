unit AStyle;

interface

uses
  Windows;

const
  astyledll = 'astyle.dll';

  //AStyle properties
  aspAddBrackets                = 'AddBrackets';
	aspAddOneLineBrackets         = 'AddOneLineBrackets';
	aspBreakClosingHeaderBrackets = 'BreakClosingHeaderBrackets';
	aspBreakBlocks                = 'BreakBlocks';
	aspBreakClosingHeaderBlocks   = 'BreakClosingHeaderBlocks';
	aspBreakElseIfs               = 'BreakElseIfs';
	aspBreakOneLineBlocks         = 'BreakOneLineBlocks';
	aspDeleteEmptyLines           = 'DeleteEmptyLines';
	aspIndentCol1Comments         = 'IndentCol1Comments';
	aspOperatorPadding            = 'OperatorPadding';
	aspParensOutsidePadding       = 'ParensOutsidePadding';
	aspParensInsidePadding        = 'ParensInsidePadding';
	aspParensHeaderPadding        = 'ParensHeaderPadding';
	aspParensUnPadding            = 'ParensUnPadding';
	aspSingleStatements           = 'SingleStatements';
	aspTabSpaceConversion         = 'TabSpaceConversion';
  aspBracketIndent              = 'BracketIndent';
  aspClassIndent                = 'ClassIndent';
  aspSwitchIndent               = 'SwitchIndent';
  aspNamespaceIndent            = 'NamespaceIndent';
  aspBlockIndent                = 'BlockIndent';

type
  TAStyleCreate = function: Pointer; cdecl;
  TAStyleSetStyle = procedure(astyle: Pointer; style: Integer); cdecl;
  TAStyleSetBracketFormat = procedure(astyle: Pointer; format: Integer); cdecl;
  TAStyleSetProperty = procedure(astyle: Pointer; prop: PChar; value: LongBool); cdecl;
  TAStyleUseTabChar = procedure(astyle: Pointer; value: LongBool); cdecl;
  TAStyleSetTabWidth = procedure(astyle: Pointer; value: Integer); cdecl;
  TAStyleSetSpaceWidth = procedure(astyle: Pointer; value: Integer); cdecl;
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

  TAStyle = class
  private
    astyle: Pointer;
    FStyle: TFormatterStyle;
    FBracketFormat: TBracketFormat;
    FUseTabChar: Boolean;
    FTabWidth: Integer;
    FSpaceWidth: Integer;
    procedure SetStyle(Value: TFormatterStyle);
    procedure SetBracketFormat(Value: TBracketFormat);
    procedure SetProperty(Index: String; Value: Boolean);
    procedure SetUseTabChar(Value: Boolean);
    procedure SetTabWidth(Value: Integer);
    procedure SetSpaceWidth(Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Format(const Source: String): String;
    property Style: TFormatterStyle read FStyle write SetStyle;
    property BracketFormat: TBracketFormat read FBracketFormat
                                           write SetBracketFormat;
    property Properties[Index: String]: Boolean write SetProperty;
    property UseTabChar: Boolean write SetUseTabChar;
    property TabWidth: Integer write SetTabWidth;
    property SpaceWidth: Integer write SetSpaceWidth;
  end;

  function AStyleLoaded: Boolean;

implementation

uses SysUtils;

var
  astyleModule: HMODULE = 0;
  AStyleCreate: TAStyleCreate = nil;
  AStyleSetStyle: TAStyleSetStyle = nil;
  AStyleSetBracketFormat: TAStyleSetBracketFormat = nil;
  AStyleSetProperty: TAStyleSetProperty = nil;
  AStyleUseTabChar: TAStyleUseTabChar = nil;
  AStyleSetTabWidth: TAStyleSetTabWidth = nil;
  AStyleSetSpaceWidth: TAStyleSetSpaceWidth = nil;
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
    UseTabChar := False;
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

procedure TAStyle.SetProperty(Index: String; Value: Boolean);
begin
    if not Assigned(astyle) or not Assigned(AStyleSetProperty) then Exit;
    AStyleSetProperty(astyle, PChar(Index), Value);
end;

procedure TAStyle.SetUseTabChar(Value: Boolean);
begin
    if (Value = FUseTabChar) or not Assigned(astyle)
        or not Assigned(AStyleUseTabChar) then Exit;
    AStyleUseTabChar(astyle, Value);
    FUseTabChar := Value;
end;

procedure TAStyle.SetTabWidth(Value: Integer);
begin
    if (Value = FTabWidth) or not Assigned(astyle)
        or not Assigned(AStyleSetTabWidth) or (Value < 1) then Exit;
    AStyleSetTabWidth(astyle, Value);
end;

procedure TAStyle.SetSpaceWidth(Value: Integer);
begin
    if (Value = FSpaceWidth) or not Assigned(astyle)
        or not Assigned(AStyleSetSpaceWidth) or (Value < 0) then Exit;
    AStyleSetSpaceWidth(astyle, Value);
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
  AStyleSetProperty := GetProcAddress(astyleModule, 'AStyleSetProperty');
  AStyleUseTabChar := GetProcAddress(astyleModule, 'AStyleUseTabChar');
  AStyleSetTabWidth := GetProcAddress(astyleModule, 'AStyleSetTabWidth');
  AStyleSetSpaceWidth := GetProcAddress(astyleModule, 'AStyleSetSpaceWidth');
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
  AStyleSetProperty := nil;
  AStyleUseTabChar := nil;
  AStyleSetTabWidth := nil;
  AStyleSetSpaceWidth := nil;
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
