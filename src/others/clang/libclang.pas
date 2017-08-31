unit libclang;

interface

const
  clang_name = 'libclang.dll';


const
  { CXTranslationUnit_Flags }
  CXTranslationUnit_None = $0;
  CXTranslationUnit_DetailedPreprocessingRecord = $01;
  CXTranslationUnit_Incomplete = $02;
  CXTranslationUnit_PrecompiledPreamble = $04;
  CXTranslationUnit_CacheCompletionResults = $08;
  CXTranslationUnit_ForSerialization = $10;
  CXTranslationUnit_CXXChainedPCH = $20;
  CXTranslationUnit_SkipFunctionBodies = $40;
  CXTranslationUnit_IncludeBriefCommentsInCodeCompletion = $80;
  CXTranslationUnit_CreatePreambleOnFirstParse = $100;
  CXTranslationUnit_KeepGoing = $200;

  { CXCursorKind }
  CXCursor_UnexposedDecl                 = 1;
  CXCursor_StructDecl                    = 2;
  CXCursor_UnionDecl                     = 3;
  CXCursor_ClassDecl                     = 4;
  CXCursor_EnumDecl                      = 5;
  CXCursor_FieldDecl                     = 6;
  CXCursor_EnumConstantDecl              = 7;
  CXCursor_FunctionDecl                  = 8;
  CXCursor_VarDecl                       = 9;
  CXCursor_ParmDecl                      = 10;
  CXCursor_ObjCInterfaceDecl             = 11;
  CXCursor_ObjCCategoryDecl              = 12;
  CXCursor_ObjCProtocolDecl              = 13;
  CXCursor_ObjCPropertyDecl              = 14;
  CXCursor_ObjCIvarDecl                  = 15;
  CXCursor_ObjCInstanceMethodDecl        = 16;
  CXCursor_ObjCClassMethodDecl           = 17;
  CXCursor_ObjCImplementationDecl        = 18;
  CXCursor_ObjCCategoryImplDecl          = 19;
  CXCursor_TypedefDecl                   = 20;
  CXCursor_CXXMethod                     = 21;
  CXCursor_Namespace                     = 22;
  CXCursor_LinkageSpec                   = 23;
  CXCursor_Constructor                   = 24;
  CXCursor_Destructor                    = 25;
  CXCursor_ConversionFunction            = 26;
  CXCursor_TemplateTypeParameter         = 27;
  CXCursor_NonTypeTemplateParameter      = 28;
  CXCursor_TemplateTemplateParameter     = 29;
  CXCursor_FunctionTemplate              = 30;
  CXCursor_ClassTemplate                 = 31;
  CXCursor_ClassTemplatePartialSpecialization = 32;
  CXCursor_NamespaceAlias                = 33;
  CXCursor_UsingDirective                = 34;
  CXCursor_UsingDeclaration              = 35;
  CXCursor_TypeAliasDecl                 = 36;
  CXCursor_ObjCSynthesizeDecl            = 37;
  CXCursor_ObjCDynamicDecl               = 38;
  CXCursor_CXXAccessSpecifier            = 39;
  CXCursor_FirstDecl                     = CXCursor_UnexposedDecl;
  CXCursor_LastDecl                      = CXCursor_CXXAccessSpecifier;
  CXCursor_FirstRef                      = 40;
  CXCursor_ObjCSuperClassRef             = 40;
  CXCursor_ObjCProtocolRef               = 41;
  CXCursor_ObjCClassRef                  = 42;
  CXCursor_TypeRef                       = 43;
  CXCursor_CXXBaseSpecifier              = 44;
  CXCursor_TemplateRef                   = 45;
  CXCursor_NamespaceRef                  = 46;
  CXCursor_MemberRef                     = 47;
  CXCursor_LabelRef                      = 48;
  CXCursor_OverloadedDeclRef             = 49;
  CXCursor_VariableRef                   = 50;
  CXCursor_LastRef                       = CXCursor_VariableRef;
  CXCursor_FirstInvalid                  = 70;
  CXCursor_InvalidFile                   = 70;
  CXCursor_NoDeclFound                   = 71;
  CXCursor_NotImplemented                = 72;
  CXCursor_InvalidCode                   = 73;
  CXCursor_LastInvalid                   = CXCursor_InvalidCode;
  CXCursor_FirstExpr                     = 100;
  CXCursor_UnexposedExpr                 = 100;
  CXCursor_DeclRefExpr                   = 101;
  CXCursor_MemberRefExpr                 = 102;
  CXCursor_CallExpr                      = 103;
  CXCursor_ObjCMessageExpr               = 104;
  CXCursor_BlockExpr                     = 105;
  CXCursor_IntegerLiteral                = 106;
  CXCursor_FloatingLiteral               = 107;
  CXCursor_ImaginaryLiteral              = 108;
  CXCursor_StringLiteral                 = 109;
  CXCursor_CharacterLiteral              = 110;
  CXCursor_ParenExpr                     = 111;
  CXCursor_UnaryOperator                 = 112;
  CXCursor_ArraySubscriptExpr            = 113;
  CXCursor_BinaryOperator                = 114;
  CXCursor_CompoundAssignOperator        = 115;
  CXCursor_ConditionalOperator           = 116;
  CXCursor_CStyleCastExpr                = 117;
  CXCursor_CompoundLiteralExpr           = 118;
  CXCursor_InitListExpr                  = 119;
  CXCursor_AddrLabelExpr                 = 120;
  CXCursor_StmtExpr                      = 121;
  CXCursor_GenericSelectionExpr          = 122;
  CXCursor_GNUNullExpr                   = 123;
  CXCursor_CXXStaticCastExpr             = 124;
  CXCursor_CXXDynamicCastExpr            = 125;
  CXCursor_CXXReinterpretCastExpr        = 126;
  CXCursor_CXXConstCastExpr              = 127;
  CXCursor_CXXFunctionalCastExpr         = 128;
  CXCursor_CXXTypeidExpr                 = 129;
  CXCursor_CXXBoolLiteralExpr            = 130;
  CXCursor_CXXNullPtrLiteralExpr         = 131;
  CXCursor_CXXThisExpr                   = 132;
  CXCursor_CXXThrowExpr                  = 133;
  CXCursor_CXXNewExpr                    = 134;
  CXCursor_CXXDeleteExpr                 = 135;
  CXCursor_UnaryExpr                     = 136;
  CXCursor_ObjCStringLiteral             = 137;
  CXCursor_ObjCEncodeExpr                = 138;
  CXCursor_ObjCSelectorExpr              = 139;
  CXCursor_ObjCProtocolExpr              = 140;
  CXCursor_ObjCBridgedCastExpr           = 141;
  CXCursor_PackExpansionExpr             = 142;
  CXCursor_SizeOfPackExpr                = 143;
  CXCursor_LambdaExpr                    = 144;
  CXCursor_ObjCBoolLiteralExpr           = 145;
  CXCursor_ObjCSelfExpr                  = 146;
  CXCursor_OMPArraySectionExpr           = 147;
  CXCursor_ObjCAvailabilityCheckExpr     = 148;
  CXCursor_LastExpr                      = CXCursor_ObjCAvailabilityCheckExpr;
  CXCursor_FirstStmt                     = 200;
  CXCursor_UnexposedStmt                 = 200;
  CXCursor_LabelStmt                     = 201;
  CXCursor_CompoundStmt                  = 202;
  CXCursor_CaseStmt                      = 203;
  CXCursor_DefaultStmt                   = 204;
  CXCursor_IfStmt                        = 205;
  CXCursor_SwitchStmt                    = 206;
  CXCursor_WhileStmt                     = 207;
  CXCursor_DoStmt                        = 208;
  CXCursor_ForStmt                       = 209;
  CXCursor_GotoStmt                      = 210;
  CXCursor_IndirectGotoStmt              = 211;
  CXCursor_ContinueStmt                  = 212;
  CXCursor_BreakStmt                     = 213;
  CXCursor_ReturnStmt                    = 214;
  CXCursor_GCCAsmStmt                    = 215;
  CXCursor_AsmStmt                       = CXCursor_GCCAsmStmt;
  CXCursor_ObjCAtTryStmt                 = 216;
  CXCursor_ObjCAtCatchStmt               = 217;
  CXCursor_ObjCAtFinallyStmt             = 218;
  CXCursor_ObjCAtThrowStmt               = 219;
  CXCursor_ObjCAtSynchronizedStmt        = 220;
  CXCursor_ObjCAutoreleasePoolStmt       = 221;
  CXCursor_ObjCForCollectionStmt         = 222;
  CXCursor_CXXCatchStmt                  = 223;
  CXCursor_CXXTryStmt                    = 224;
  CXCursor_CXXForRangeStmt               = 225;
  CXCursor_SEHTryStmt                    = 226;
  CXCursor_SEHExceptStmt                 = 227;
  CXCursor_SEHFinallyStmt                = 228;
  CXCursor_MSAsmStmt                     = 229;
  CXCursor_NullStmt                      = 230;
  CXCursor_DeclStmt                      = 231;
  CXCursor_OMPParallelDirective          = 232;
  CXCursor_OMPSimdDirective              = 233;
  CXCursor_OMPForDirective               = 234;
  CXCursor_OMPSectionsDirective          = 235;
  CXCursor_OMPSectionDirective           = 236;
  CXCursor_OMPSingleDirective            = 237;
  CXCursor_OMPParallelForDirective       = 238;
  CXCursor_OMPParallelSectionsDirective  = 239;
  CXCursor_OMPTaskDirective              = 240;
  CXCursor_OMPMasterDirective            = 241;
  CXCursor_OMPCriticalDirective          = 242;
  CXCursor_OMPTaskyieldDirective         = 243;
  CXCursor_OMPBarrierDirective           = 244;
  CXCursor_OMPTaskwaitDirective          = 245;
  CXCursor_OMPFlushDirective             = 246;
  CXCursor_SEHLeaveStmt                  = 247;
  CXCursor_OMPOrderedDirective           = 248;
  CXCursor_OMPAtomicDirective            = 249;
  CXCursor_OMPForSimdDirective           = 250;
  CXCursor_OMPParallelForSimdDirective   = 251;
  CXCursor_OMPTargetDirective            = 252;
  CXCursor_OMPTeamsDirective             = 253;
  CXCursor_OMPTaskgroupDirective         = 254;
  CXCursor_OMPCancellationPointDirective = 255;
  CXCursor_OMPCancelDirective            = 256;
  CXCursor_OMPTargetDataDirective        = 257;
  CXCursor_OMPTaskLoopDirective          = 258;
  CXCursor_OMPTaskLoopSimdDirective      = 259;
  CXCursor_OMPDistributeDirective        = 260;
  CXCursor_OMPTargetEnterDataDirective   = 261;
  CXCursor_OMPTargetExitDataDirective    = 262;
  CXCursor_OMPTargetParallelDirective    = 263;
  CXCursor_OMPTargetParallelForDirective = 264;
  CXCursor_OMPTargetUpdateDirective      = 265;
  CXCursor_OMPDistributeParallelForDirective = 266;
  CXCursor_OMPDistributeParallelForSimdDirective = 267;
  CXCursor_OMPDistributeSimdDirective = 268;
  CXCursor_OMPTargetParallelForSimdDirective = 269;
  CXCursor_LastStmt = CXCursor_OMPTargetParallelForSimdDirective;
  CXCursor_TranslationUnit               = 300;
  CXCursor_FirstAttr                     = 400;
  CXCursor_UnexposedAttr                 = 400;
  CXCursor_IBActionAttr                  = 401;
  CXCursor_IBOutletAttr                  = 402;
  CXCursor_IBOutletCollectionAttr        = 403;
  CXCursor_CXXFinalAttr                  = 404;
  CXCursor_CXXOverrideAttr               = 405;
  CXCursor_AnnotateAttr                  = 406;
  CXCursor_AsmLabelAttr                  = 407;
  CXCursor_PackedAttr                    = 408;
  CXCursor_PureAttr                      = 409;
  CXCursor_ConstAttr                     = 410;
  CXCursor_NoDuplicateAttr               = 411;
  CXCursor_CUDAConstantAttr              = 412;
  CXCursor_CUDADeviceAttr                = 413;
  CXCursor_CUDAGlobalAttr                = 414;
  CXCursor_CUDAHostAttr                  = 415;
  CXCursor_CUDASharedAttr                = 416;
  CXCursor_VisibilityAttr                = 417;
  CXCursor_DLLExport                     = 418;
  CXCursor_DLLImport                     = 419;
  CXCursor_LastAttr                      = CXCursor_DLLImport;
  CXCursor_PreprocessingDirective        = 500;
  CXCursor_MacroDefinition               = 501;
  CXCursor_MacroExpansion                = 502;
  CXCursor_MacroInstantiation            = CXCursor_MacroExpansion;
  CXCursor_InclusionDirective            = 503;
  CXCursor_FirstPreprocessing            = CXCursor_PreprocessingDirective;
  CXCursor_LastPreprocessing             = CXCursor_InclusionDirective;
  CXCursor_ModuleImportDecl              = 600;
  CXCursor_TypeAliasTemplateDecl         = 601;
  CXCursor_StaticAssert                  = 602;
  CXCursor_FirstExtraDecl                = CXCursor_ModuleImportDecl;
  CXCursor_LastExtraDecl                 = CXCursor_StaticAssert;
  CXCursor_OverloadCandidate             = 700;

  { CXCodeComplete_Flags }
  CXCodeComplete_IncludeMacros = $01;
  CXCodeComplete_IncludeCodePatterns = $02;
  CXCodeComplete_IncludeBriefComments = $04;

type
  {$Z4}
  {$EXTERNALSYM CXCompletionChunkKind}
  CXCompletionChunkKind = (
    CXCompletionChunk_Optional,
    CXCompletionChunk_TypedText,
    CXCompletionChunk_Text,
    CXCompletionChunk_Placeholder,
    CXCompletionChunk_Informative,
    CXCompletionChunk_CurrentParameter,
    CXCompletionChunk_LeftParen,
    CXCompletionChunk_RightParen,
    CXCompletionChunk_LeftBracket,
    CXCompletionChunk_RightBracket,
    CXCompletionChunk_LeftBrace,
    CXCompletionChunk_RightBrace,
    CXCompletionChunk_LeftAngle,
    CXCompletionChunk_RightAngle,
    CXCompletionChunk_Comma,
    CXCompletionChunk_ResultType,
    CXCompletionChunk_Colon,
    CXCompletionChunk_SemiColon,
    CXCompletionChunk_Equal,
    CXCompletionChunk_HorizontalSpace,
    CXCompletionChunk_VerticalSpace
  );
  {$Z1}

  {$Z4}
  CXChildVisitResult = (
    CXChildVisit_Break,
    CXChildVisit_Continue,
    CXChildVisit_Recurse
  );
  {$Z1}

  {$Z4}
  CXErrorCode = (
    CXError_Success = 0,
    CXError_Failure = 1,
    CXError_Crashed = 2,
    CXError_InvalidArguments = 3,
    CXError_ASTReadError = 4
  );
  {$Z1}

type
  {$EXTERNALSYM CXIndex}
  CXIndex = Pointer;
  PCXTranslationUnit = ^CXTranslationUnit;
  {$EXTERNALSYM CXTranslationUnit}
  CXTranslationUnit = Pointer;
  {$EXTERNALSYM CXCompletionString}
  CXCompletionString = Pointer;
  {$EXTERNALSYM CXClientData}
  CXClientData = Pointer;

  PCXString = ^CXString;
  {$EXTERNALSYM CXString}
  CXString = record
    data: Pointer;
    private_flags: Cardinal;
  end;
{$IFDEF WIN32}
  _CXString = Int64;
{$ELSE}
  _CXString = CXString;
{$ENDIF}

  PCXUnsavedFile = ^CXUnsavedFile;
  {$EXTERNALSYM CXUnsavedFile}
  CXUnsavedFile = record
    Filename: PAnsiChar;
    Contents: PAnsiChar;
    Length: Cardinal;
  end;

  PCXCompletionResult = ^CXCompletionResult;
  {$EXTERNALSYM CXCompletionResult}
  CXCompletionResult = record
    CursorKind: Integer;
    CompletionString: CXCompletionString;
  end;
  CXCompletionResultList = array[0..$00FFFFFF] of CXCompletionResult;
  PCXCompletionResultList = ^CXCompletionResultList;

  PCXCodeCompleteResults = ^CXCodeCompleteResults;
  {$EXTERNALSYM CXCodeCompleteResults}
  CXCodeCompleteResults = record
    Results: PCXCompletionResultList;
    NumResults: Cardinal;
  end;

  PCXCursor = ^CXCursor;
  {$EXTERNALSYM CXCursor}
  CXCursor = record
    kind: Integer;
    xdata: Integer;
    data: array[0..2] of Pointer;
  end;
{$IFDEF WIN32}
  _CXCursor = Int64;
{$ELSE}
  _CXCursor = CXCursor;
{$ENDIF}

  {$EXTERNALSYM CXCursorVisitor}
  CXCursorVisitor = function(cursor, parent: CXCursor;
    client_data: CXClientData): CXChildVisitResult; cdecl;

  {$EXTERNALSYM CXCursorVisitorBlock}
  CXCursorVisitorBlock = function(cursor, parent: CXCursor): CXChildVisitResult; cdecl;

{$EXTERNALSYM clang_createIndex}
function clang_createIndex(excludeDeclarationsFromPCH,
  displayDiagnostics: Integer): CXIndex; cdecl; external clang_name;

{$EXTERNALSYM clang_disposeIndex}
procedure clang_disposeIndex(index: CXIndex); cdecl; external clang_name;

{$EXTERNALSYM clang_parseTranslationUnit}
function clang_parseTranslationUnit(CIdx: CXIndex;
  const source_filename: PAnsiChar; const command_line_args: PPAnsiChar;
  num_command_line_args: Integer; unsaved_files: PCXUnsavedFile;
  num_unsaved_files: Cardinal; options: Cardinal): CXTranslationUnit; cdecl; external clang_name;

{$EXTERNALSYM clang_parseTranslationUnit2}
function clang_parseTranslationUnit2(CIdx: CXIndex;
  const source_filename: PAnsiChar; const command_line_args: PPAnsiChar;
  num_command_line_args: Integer; unsaved_files: PCXUnsavedFile;
  num_unsaved_files: Cardinal; options: Cardinal;
  TU: PCXTranslationUnit): CXErrorCode; cdecl; external clang_name;

{$EXTERNALSYM clang_reparseTranslationUnit}
function clang_reparseTranslationUnit(TU: CXTranslationUnit;
  num_unsaved_files: Cardinal; unsaved_files: PCXUnsavedFile;
  options: Cardinal): Integer; cdecl; external clang_name;

{$EXTERNALSYM clang_disposeTranslationUnit}
procedure clang_disposeTranslationUnit(TU: CXTranslationUnit); cdecl; external clang_name;

{$EXTERNALSYM clang_codeCompleteAt}
function clang_codeCompleteAt(TU: CXTranslationUnit;
  complete_filename: PAnsiChar; complete_line: Cardinal;
  complete_column: Cardinal; unsaved_files: PCXUnsavedFile;
  num_unsaved_files: Cardinal; options: Cardinal): PCXCodeCompleteResults; cdecl; external clang_name;

{$EXTERNALSYM clang_getNumCompletionChunks}
function clang_getNumCompletionChunks(completion_string: CXCompletionString): Cardinal; cdecl; external clang_name;

{$EXTERNALSYM clang_getCompletionChunkKind}
function clang_getCompletionChunkKind(completion_string: CXCompletionString;
  chunk_number: Cardinal): CXCompletionChunkKind; cdecl; external clang_name;

function _clang_getCompletionChunkText(completion_string: CXCompletionString;
  chunk_number: Cardinal): _CXString; cdecl; external clang_name name 'clang_getCompletionChunkText';

function clang_getCompletionChunkText(completion_string: CXCompletionString;
  chunk_number: Cardinal): CXString;

{$EXTERNALSYM clang_getCString}
function clang_getCString(str: CXString): PAnsiChar; cdecl; external clang_name;

{$EXTERNALSYM clang_disposeString}
procedure clang_disposeString(str: CXString); cdecl; external clang_name;

{$EXTERNALSYM clang_disposeCodeCompleteResults}
procedure clang_disposeCodeCompleteResults(Results: PCXCodeCompleteResults); cdecl; external clang_name;

{$EXTERNALSYM clang_visitChildren}
function clang_visitChildren(parent: CXCursor; visitor: CXCursorVisitor;
  client_data: CXClientData): Cardinal; cdecl; external clang_name;

{$EXTERNALSYM clang_visitChildrenWithBlock}
function clang_visitChildrenWithBlock(parent: CXCursor;
  block: CXCursorVisitorBlock): Cardinal; cdecl; external clang_name;

function _clang_getTranslationUnitCursor(TU: CXTranslationUnit): _CXCursor; cdecl;
  external clang_name name 'clang_getTranslationUnitCursor';

function clang_getTranslationUnitCursor(TU: CXTranslationUnit): CXCursor;

implementation

function clang_getCompletionChunkText(completion_string: CXCompletionString;
  chunk_number: Cardinal): CXString;
begin
  Result := CXString(_clang_getCompletionChunkText(completion_string, chunk_number));
end;

function clang_getTranslationUnitCursor(TU: CXTranslationUnit): CXCursor;
begin
{$IFDEF WIN32}
  Result := PCXCursor(_clang_getTranslationUnitCursor(TU))^;
{$ELSE}
  Result := CXCursor(_clang_getTranslationUnitCursor(TU));
{$ENDIF}
end;

end.
