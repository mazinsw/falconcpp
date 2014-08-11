unit AStyle;

interface

uses
  Windows;

const
  astyledll = 'AStyle.dll';

  //AStyle properties

  // Bracket Modify Options
  aspAttachNamespaces = 'AttachNamespaces';
  aspAttachClasses = 'AttachClasses';
  aspAttachInlines = 'AttachInlines';
  aspAttachExternC = 'AttachExternC';
  // Indentation Options
  aspIndentClasses = 'IndentClasses';
  aspIndentModifiers = 'IndentModifiers';
  aspIndentSwitches = 'IndentSwitches';
  aspIndentCases = 'IndentCases';
  aspIndentNamespaces = 'IndentNamespaces';
  aspIndentLabels = 'IndentLabels';
  aspIndentPreprocDefine = 'IndentPreprocDefine';
  aspIndentPreprocCond = 'IndentPreprocCond';
  aspIndentCol1Comments = 'IndentCol1Comments';
  // Padding Options
  aspBreakBlocks = 'BreakBlocks';
  aspBreakBlocksAll = 'BreakBlocksAll';
  aspPaddingOperator = 'PaddingOperator';
  aspPaddingParens = 'PaddingParens';
  aspPaddingParensOutside = 'PaddingParensOutside';
  aspPaddingFirstParensOutside = 'PaddingFirstParensOutside';
  aspPaddingParensInside = 'PaddingParensInside';
  aspPaddingHeader = 'PaddingHeader';
  aspUnpaddingParens = 'UnpaddingParens';
  aspDeleteEmptyLines = 'DeleteEmptyLines';
  aspFillEmptyLines = 'FillEmptyLines';
  // Formatting Options
  aspBreakClosingBrackets = 'BreakClosingBrackets';
  aspBreakElseIfs = 'BreakElseIfs';
  aspAddBrackets = 'AddBrackets';
  aspAddOneLineBrackets = 'AddOneLineBrackets';
  aspRemoveBrackets = 'RemoveBrackets';
  aspKeepOneLineBlocks = 'KeepOneLineBlocks';
  aspKeepOneLineStatements = 'KeepOneLineStatements';
  aspConvertTabs = 'ConvertTabs';
  aspCloseTemplates = 'CloseTemplates';
  aspRemoveCommentPrefix = 'RemoveCommentPrefix';

type
  TfpError = procedure(Code: Integer; const Msg: PUTF8String); stdcall; // pointer to callback error handler
  TfpAlloc = function(Size: Cardinal): PUTF8String; stdcall;		        // pointer to callback memory allocation
  TAStyleMain = function(const pSourceIn: PUTF8String; // the source to be formatted
                         const pOptions : PUTF8String; // AStyle options
                         fpErrorHandler : TfpError ; // error handler function
                         fpMemoryAlloc  : TfpAlloc): // memory allocation function
                         PUTF8String; stdcall;

  TBracketStyle = (
    stNONE,
    stALLMAN,
    stJAVA,
    stKR,
    stSTROUSTRUP,
    stWHITESMITH,
    stBANNER,
    stGNU,
    stLINUX,
    stHORSTMANN,
    st1TBS,
    stGOOGLE,
    stPICO,
    stLISP
  );

  TTabOptions = (
    toSpaces,
    toTab,
    toForceTab
  );

  TAlignPointer = (
    apNone,
    apType,
    apMiddle,
    apName
  );

  TAlignReference = (
    arNone,
    arType,
    arMiddle,
    arName
  );

  TAStyle = class
  private
    FLastAlloc: PUTF8String;
    FBracketStyle: TBracketStyle;
    FTabOptions: TTabOptions;
    FAlignPointer: TAlignPointer;
    FAlignReference: TAlignReference;
    FTabWidth: Integer;
    FTabXWidth: Integer;
    FMaxInstatementIndent: Integer;
    FMinConditionalIndent: Integer;
    FMaxCodeLength: Integer;

    //AStyle properties
    // Bracket Modify Options
    FAttachNamespaces: Boolean;
    FAttachClasses: Boolean;
    FAttachInlines: Boolean;
    FAttachExternC: Boolean;
    // Indentation Options
    FIndentClasses: Boolean;
    FIndentModifiers: Boolean;
    FIndentSwitches: Boolean;
    FIndentCases: Boolean;
    FIndentNamespaces: Boolean;
    FIndentLabels: Boolean;
    FIndentPreprocDefine: Boolean;
    FIndentPreprocCond: Boolean;
    FIndentCol1Comments: Boolean;
    // Padding Options
    FBreakBlocks: Boolean;
    FBreakBlocksAll: Boolean;
    FPaddingOperator: Boolean;
    FPaddingParens: Boolean;
    FPaddingParensOutside: Boolean;
    FPaddingFirstParensOutside: Boolean;
    FPaddingParensInside: Boolean;
    FPaddingHeader: Boolean;
    FUnpaddingParens: Boolean;
    FDeleteEmptyLines: Boolean;
    FFillEmptyLines: Boolean;
    // Formatting Options
    FBreakClosingBrackets: Boolean;
    FBreakElseIfs: Boolean;
    FAddBrackets: Boolean;
    FAddOneLineBrackets: Boolean;
    FRemoveBrackets: Boolean;
    FKeepOneLineBlocks: Boolean;
    FKeepOneLineStatements: Boolean;
    FConvertTabs: Boolean;
    FCloseTemplates: Boolean;
    FRemoveCommentPrefix: Boolean;
    procedure SetAlignPointer(const Value: TAlignPointer);
    procedure SetAlignReference(const Value: TAlignReference);
    procedure SetBracketStyle(Value: TBracketStyle);
    procedure SetMaxInstatementIndent(Value: Integer);
    procedure SetProperty(Index: string; Value: Boolean);
    procedure SetTabOptions(const Value: TTabOptions);
    procedure SetTabWidth(Value: Integer);
    procedure SetTabXWidth(const Value: Integer);
    procedure SetMinConditionalIndent(const Value: Integer);
    procedure SetMaxCodeLength(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Format(const Source: PUTF8String): PUTF8String;
    property BracketStyle: TBracketStyle read FBracketStyle write SetBracketStyle;
    property TabOptions: TTabOptions read FTabOptions
      write SetTabOptions;
    property AlignPointer: TAlignPointer read FAlignPointer
      write SetAlignPointer;
    property AlignReference: TAlignReference read FAlignReference
      write SetAlignReference;
    property Properties[Index: string]: Boolean write SetProperty;
    property TabWidth: Integer read FTabWidth write SetTabWidth;
    property TabXWidth: Integer read FTabXWidth write SetTabXWidth;
    property MaxCodeLength: Integer read FMaxCodeLength write SetMaxCodeLength;
    property MaxInstatementIndent: Integer read FMaxInstatementIndent write SetMaxInstatementIndent;
    property MinConditionalIndent: Integer read FMinConditionalIndent write SetMinConditionalIndent;
  end;

function AStyleLoaded: Boolean;

implementation

uses SysUtils;

var
  astyleModule: HMODULE = 0;
  AStyleMain: TAStyleMain = nil;

constructor TAStyle.Create;
begin
  inherited Create;
  FBracketStyle := stALLMAN;
  FTabWidth := 4;
  FTabOptions := toTab;
  FAlignPointer := apName;
  FMaxCodeLength := 80;
  FLastAlloc := nil;
end;

destructor TAStyle.Destroy;
begin
  if FLastAlloc <> nil then
    FreeMem(FLastAlloc);
  inherited Destroy;
end;

procedure TAStyle.SetBracketStyle(Value: TBracketStyle);
begin
  if Value <> FBracketStyle then
  begin
    FBracketStyle := Value;
  end;
end;

procedure TAStyle.SetAlignPointer(const Value: TAlignPointer);
begin
  FAlignPointer := Value;
end;

procedure TAStyle.SetAlignReference(const Value: TAlignReference);
begin
  FAlignReference := Value;
end;

procedure TAStyle.SetProperty(Index: string; Value: Boolean);
begin
  // Bracket Modify Options
  if Index = aspAttachNamespaces then
    FAttachNamespaces := Value
  else if Index = aspAttachClasses then
    FAttachClasses := Value
  else if Index = aspAttachInlines then
    FAttachInlines := Value
  else if Index = aspAttachExternC then
    FAttachExternC := Value
  // Indentation Options
  else if Index = aspIndentClasses then
    FIndentClasses := Value
  else if Index = aspIndentModifiers then
    FIndentModifiers := Value
  else if Index = aspIndentSwitches then
    FIndentSwitches := Value
  else if Index = aspIndentCases then
    FIndentCases := Value
  else if Index = aspIndentNamespaces then
    FIndentNamespaces := Value
  else if Index = aspIndentLabels then
    FIndentLabels := Value
  else if Index = aspIndentPreprocDefine then
    FIndentPreprocDefine := Value
  else if Index = aspIndentPreprocCond then
    FIndentPreprocCond := Value
  else if Index = aspIndentCol1Comments then
    FIndentCol1Comments := Value
  // Padding Options
  else if Index = aspBreakBlocks then
    FBreakBlocks := Value
  else if Index = aspBreakBlocksAll then
    FBreakBlocksAll := Value
  else if Index = aspPaddingOperator then
    FPaddingOperator := Value
  else if Index = aspPaddingParens then
    FPaddingParens := Value
  else if Index = aspPaddingParensOutside then
    FPaddingParensOutside := Value
  else if Index = aspPaddingFirstParensOutside then
    FPaddingFirstParensOutside := Value
  else if Index = aspPaddingParensInside then
    FPaddingParensInside := Value
  else if Index = aspPaddingHeader then
    FPaddingHeader := Value
  else if Index = aspUnpaddingParens then
    FUnpaddingParens := Value
  else if Index = aspDeleteEmptyLines then
    FDeleteEmptyLines := Value
  else if Index = aspFillEmptyLines then
    FFillEmptyLines := Value
  // Formatting Options
  else if Index = aspBreakClosingBrackets then
    FBreakClosingBrackets := Value
  else if Index = aspBreakElseIfs then
    FBreakElseIfs := Value
  else if Index = aspAddBrackets then
    FAddBrackets := Value
  else if Index = aspAddOneLineBrackets then
    FAddOneLineBrackets := Value
  else if Index = aspRemoveBrackets then
    FRemoveBrackets := Value
  else if Index = aspKeepOneLineBlocks then
    FKeepOneLineBlocks := Value
  else if Index = aspKeepOneLineStatements then
    FKeepOneLineStatements := Value
  else if Index = aspConvertTabs then
    FConvertTabs := Value
  else if Index = aspCloseTemplates then
    FCloseTemplates := Value
  else if Index = aspRemoveCommentPrefix then
    FRemoveCommentPrefix := Value;
end;

procedure TAStyle.SetTabOptions(const Value: TTabOptions);
begin
  FTabOptions := Value;
end;

procedure TAStyle.SetTabWidth(Value: Integer);
begin
  if (Value = FTabWidth) or (Value < 1) then
    Exit;
  FTabWidth := Value;
end;

procedure TAStyle.SetTabXWidth(const Value: Integer);
begin
  FTabXWidth := Value;
end;

procedure TAStyle.SetMaxCodeLength(const Value: Integer);
begin
  FMaxCodeLength := Value;
end;

procedure TAStyle.SetMaxInstatementIndent(Value: Integer);
begin
  if (Value = FMaxInstatementIndent) or (Value < 0) then
    Exit;
  FMaxInstatementIndent := Value;
end;

procedure TAStyle.SetMinConditionalIndent(const Value: Integer);
begin
  FMinConditionalIndent := Value;
end;

procedure fpError(Code: Integer; const Msg: PUTF8String); stdcall;
begin
  // nop
end;

function fpAlloc(Size: Cardinal): PUTF8String; stdcall;
begin
  Result := PUTF8String(GetMemory(Size));
end;

function TAStyle.Format(const Source: PUTF8String): PUTF8String;
var
  UTF8Options: UTF8String;
  Options: string;
begin
  Options := '--mode=c';
  // Bracket Style Options
  case FBracketStyle of
    stNONE:;
    stALLMAN: Options := Options + ' --style=allman';
    stJAVA: Options := Options + ' --style=java';
    stKR: Options := Options + ' --style=kr';
    stSTROUSTRUP: Options := Options + ' --style=stroustrup';
    stWHITESMITH: Options := Options + ' --style=whitesmith';
    stBANNER: Options := Options + ' --style=banner';
    stGNU: Options := Options + ' --style=gnu';
    stLINUX: Options := Options + ' --style=linux';
    stHORSTMANN: Options := Options + ' --style=horstmann';
    st1TBS: Options := Options + ' --style=1tbs';
    stGOOGLE: Options := Options + ' --style=google';
    stPICO: Options := Options + ' --style=pico';
    stLISP: Options := Options + ' --style=lisp';
  end;
  // Tab Options
  case FTabOptions of
    toForceTab: Options := Options + SysUtils.Format(' --indent=force-tab=%d', [FTabWidth]);
    toSpaces: Options := Options + SysUtils.Format(' --indent=spaces=%d', [FTabWidth]);
    toTab: Options := Options + SysUtils.Format(' --indent=tab=%d', [FTabWidth]);
  end;
  if FTabXWidth > 0 then
    Options := Options + SysUtils.Format(' --indent=force-tab-x=%d', [FTabXWidth]);
  // Bracket Modify Options
  if FAttachNamespaces then
    Options := Options + ' --attach-namespaces';
  if FAttachClasses then
    Options := Options + ' --attach-classes';
  if FAttachInlines then
    Options := Options + ' --attach-inlines';
  if FAttachExternC then
    Options := Options + ' --attach-extern-c';
  // Indentation Options
  if FIndentClasses then
    Options := Options + ' --indent-classes';
  if FIndentModifiers then
    Options := Options + ' --indent-modifiers';
  if FIndentSwitches then
    Options := Options + ' --indent-switches';
  if FIndentCases then
    Options := Options + ' --indent-cases';
  if FIndentNamespaces then
    Options := Options + ' --indent-namespaces';
  if FIndentLabels then
    Options := Options + ' --indent-labels';
  if FIndentPreprocDefine then
    Options := Options + ' --indent-preproc-define';
  if FIndentPreprocCond then
    Options := Options + ' --indent-preproc-cond';
  if FIndentCol1Comments then
    Options := Options + ' --indent-col1-comments';
  Options := Options + SysUtils.Format(' --min-conditional-indent=%d', [FMinConditionalIndent]);
  Options := Options + SysUtils.Format(' --max-instatement-indent=%d', [FMaxInstatementIndent]);
  // Padding Options
  if FBreakBlocks then
    Options := Options + ' --break-blocks';
  if FBreakBlocksAll then
    Options := Options + ' --break-blocks=all';
  if FPaddingOperator then
    Options := Options + ' --pad-oper';
  if FPaddingParens then
    Options := Options + ' --pad-paren';
  if FPaddingParensOutside then
    Options := Options + ' --pad-paren-out';
  if FPaddingFirstParensOutside then
    Options := Options + ' --pad-first-paren-out';
  if FPaddingParensInside then
    Options := Options + ' --pad-paren-in';
  if FPaddingHeader then
    Options := Options + ' --pad-header';
  if FUnpaddingParens then
    Options := Options + ' --unpad-paren';
  if FDeleteEmptyLines then
    Options := Options + ' --delete-empty-lines';
  if FFillEmptyLines then
    Options := Options + ' --fill-empty-lines';
  case FAlignPointer of
    apNone: ;
    apType: Options := Options + ' --align-pointer=type';
    apMiddle: Options := Options + ' --align-pointer=middle';
    apName: Options := Options + ' --align-pointer=name';
  end;
  case FAlignReference of
    arNone: Options := Options + ' --align-reference=none';
    arType: Options := Options + ' --align-reference=type';
    arMiddle: Options := Options + ' --align-reference=middle';
    arName: Options := Options + ' --align-reference=name';
  end;
  // Formatting Options
  if FBreakClosingBrackets then
    Options := Options + ' --break-closing-brackets';
  if FBreakElseIfs then
    Options := Options + ' --break-elseifs';
  if FAddBrackets then
    Options := Options + ' --add-brackets';
  if FAddOneLineBrackets then
    Options := Options + ' --add-one-line-brackets';
  if FRemoveBrackets then
    Options := Options + ' --remove-brackets';
  if FKeepOneLineBlocks then
    Options := Options + ' --keep-one-line-blocks';
  if FKeepOneLineStatements then
    Options := Options + ' --keep-one-line-statements';
  if FConvertTabs then
    Options := Options + ' --convert-tabs';
  if FCloseTemplates then
    Options := Options + ' --close-templates';
  if FRemoveCommentPrefix then
    Options := Options + ' --remove-comment-prefix';
  if FMaxCodeLength > 0 then
    Options := Options + SysUtils.Format(' --max-code-length=%d', [FMaxCodeLength]);
  UTF8Options := UTF8Encode(Options);
  Result := AStyleMain(PUTF8String(Source), PUTF8String(UTF8Options), fpError, fpAlloc);
  if FLastAlloc <> nil then
    FreeMem(FLastAlloc);
  FLastAlloc := Result;
  if Result = nil then
    Result := Source;
end;

function AStyleLoaded: Boolean;
begin
  Result := astyleModule <> 0;
end;

procedure AStyleLoadLibrary;
begin
  astyleModule := LoadLibrary(astyledll);
  if astyleModule = 0 then
    Exit;
  AStyleMain := GetProcAddress(astyleModule, 'AStyleMain');
end;

procedure AStyleFreeLibrary;
begin
  if not AStyleLoaded then
    Exit;
  FreeLibrary(astyleModule);
  astyleModule := 0;
  AStyleMain := nil;
end;

initialization
  AStyleLoadLibrary;
finalization
  AStyleFreeLibrary;
end.
