unit RCHighlighter;

interface

uses
  Classes, Highlighter;

type
  TRCHighlighter = class(THighlighter)
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
  RCKeyWords =

    // Type
    'ACCELERATORS ALT AUTO3STATE AUTOCHECKBOX AUTORADIOBUTTON BEGIN BITMAP BLOCK' +
    ' BUTTON CAPTION CHARACTERISTICS CHECKBOX CLASS COMBOBOX CONTROL CTEXT CURSOR' +
    ' DEFPUSHBUTTON DIALOG DIALOGEX DISCARDABLE EDITTEXT END EXSTYLE FONT GROUPBOX' +
    ' ICON LANGUAGE LISTBOX LTEXT MENU MENUEX MENUITEM MESSAGETABLE POPUP PUSHBUTTON' +
    ' RADIOBUTTON RCDATA RTEXT SCROLLBAR SEPARATOR SHIFT STATE3 STRINGTABLE STYLE' +
    ' TEXTINCLUDE VALUE VERSION VERSIONINFO VIRTKEY';


{ TRCHighlighter }

constructor TRCHighlighter.Create(AOwner: TComponent);
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
  Add(SCE_C_PREPROCESSORCOMMENT, HL_Style_PreprocessorComment, clGreen);
  Add(SCE_C_PREPROCESSORCOMMENTDOC, HL_Style_PreprocessorDocComment, clTeal);
  Add(SCE_C_DEFAULT, HL_Style_Space);
end;

function TRCHighlighter.GetID: Integer;
begin
  Result := SCLEX_CPP;
end;

function TRCHighlighter.GetLanguageName: String;
begin
  Result := 'Resources';
end;

function TRCHighlighter.IsComment(Style: THighlighStyle): Boolean;
begin
  Result := Style.ID in [SCE_C_COMMENT, SCE_C_COMMENTLINE, SCE_C_COMMENTLINEDOC,
    SCE_C_COMMENTDOCKEYWORD, SCE_C_COMMENTDOCKEYWORDERROR, SCE_C_PREPROCESSORCOMMENT,
    SCE_C_PREPROCESSORCOMMENTDOC];
end;

function TRCHighlighter.IsString(Style: THighlighStyle): Boolean;
begin
  Result := Style.ID in [SCE_C_STRING, SCE_C_CHARACTER, SCE_C_STRINGRAW,
    SCE_C_STRINGEOL];
end;

procedure TRCHighlighter.SetKeyWords(Callback: TSetKeyWords);
begin
  Callback(0, RCKeyWords);
end;

end.
