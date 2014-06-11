unit CppHighlighter;

interface

uses
  Classes, Highlighter;

type
  TCppHighlighter = class(THighlighter)
  protected
    function GetID: Integer; override;
    function GetLanguageName: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetKeyWords(Callback: TSetKeyWords); override;
    function IsComment(Style: THighlighStyle): Boolean; override;
    function IsString(Style: THighlighStyle): Boolean; override;
  end;

implementation

uses
  DScintillaTypes, Graphics, CustomColors;

const
// C++ keywords
  CppKeyWords =

    // Type
    'asm auto bool char class const double enum explicit extern float friend ' +
    'inline int long mutable private protected public register short signed ' +
    'static struct template typename union unsigned virtual void volatile wchar_t ' +


    // Extended
    '__asm __asume __based __box __cdecl __declspec __delegate __event ' +
    '__fastcall __forceinline __int128 __int16 __int32 __int64 __int8 __leave ' +
    '__noop __stdcall __unaligned __uuidof __virtual_inheritance delegate ' +
    'depreciated dllexport dllimport event naked noinline noreturn nothrow ' +
    'novtable nullptr safecast uuid';


  CppKeyWords2 =
  // Instruction
  '__except __finally __interface __try break case catch const_cast continue ' +
  'default delete do dynamic_cast else false finally for goto if interface ' +
  'namespace new operator reinterpret_cast return sizeof static_cast switch ' +
  'this throw true try typedef typeid using while';

{ TCppHighlighter }

constructor TCppHighlighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Add(SCE_C_COMMENT, HL_Style_Comment, clGreen);
  Add(SCE_C_COMMENTLINE, HL_Style_LineComment, clGreen);
  Add(SCE_C_COMMENTDOC, HL_Style_DocComment, clTeal);
  Add(SCE_C_NUMBER, HL_Style_Number, clOrange);
  Add(SCE_C_WORD, HL_Style_TypeWord, clViolet);
  Add(SCE_C_STRING, HL_Style_String, clBlue);
  Add(SCE_C_CHARACTER, HL_Style_Character, clGray);
  //Add(SCE_C_UUID, '');
  Add(SCE_C_PREPROCESSOR, HL_Style_Preprocessor, clMaroon);
  Add(SCE_C_OPERATOR, HL_Style_Symbol, clNavy, [fsBold]);
  Add(SCE_C_IDENTIFIER, HL_Style_Identifier, clWindowText);
  Add(SCE_C_STRINGEOL, HL_Style_UnterminatedString, clBlue);
  //Add(SCE_C_VERBATIM, '');
  //Add(SCE_C_REGEX, '');
  Add(SCE_C_COMMENTLINEDOC, HL_Style_LineDocComment, clGrayText);
  Add(SCE_C_WORD2, HL_Style_InstructionWord, clBlue, [fsBold]);
  Add(SCE_C_COMMENTDOCKEYWORD, HL_Style_CommentKeyword, clViolet);
  Add(SCE_C_COMMENTDOCKEYWORDERROR, HL_Style_CommentKeywordError, clRed);
  //Add(SCE_C_GLOBALCLASS, '');
  //Add(SCE_C_STRINGRAW, '');
  //Add(SCE_C_TRIPLEVERBATIM, '');
  //Add(SCE_C_HASHQUOTEDSTRING, '');
  Add(SCE_C_PREPROCESSORCOMMENT, HL_Style_PreprocessorComment, clGreen);
  Add(SCE_C_PREPROCESSORCOMMENTDOC, HL_Style_PreprocessorDocComment, clTeal);
  Add(SCE_C_DEFAULT, HL_Style_Space);
end;

function TCppHighlighter.GetID: Integer;
begin
  Result := SCLEX_CPP;
end;

function TCppHighlighter.GetLanguageName: String;
begin
  Result := 'C/C++';
end;

function TCppHighlighter.IsComment(Style: THighlighStyle): Boolean;
begin
  Result := Style.ID in [SCE_C_COMMENT, SCE_C_COMMENTLINE, SCE_C_COMMENTLINEDOC,
    SCE_C_COMMENTDOCKEYWORD, SCE_C_COMMENTDOCKEYWORDERROR, SCE_C_PREPROCESSORCOMMENT,
    SCE_C_PREPROCESSORCOMMENTDOC];
end;

function TCppHighlighter.IsString(Style: THighlighStyle): Boolean;
begin
  Result := Style.ID in [SCE_C_STRING, SCE_C_CHARACTER, SCE_C_STRINGRAW,
    SCE_C_STRINGEOL];
end;

procedure TCppHighlighter.SetKeyWords(Callback: TSetKeyWords);
begin
  Callback(0, CppKeyWords);
  Callback(1, CppKeyWords2);
end;

end.
