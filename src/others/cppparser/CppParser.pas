unit CppParser;

interface

uses
  Classes, SysUtils, TokenList;

type
  TSetOfChars = set of Char;

  TLogTokenEvent = procedure(Sender: TObject; Msg: string; Current: Integer) of object;
  TParserProgressEvent = procedure(Sender: TObject; Current, Total: Integer) of object;

  TCppParser = class(TObject)
  private
    fCancel: Boolean;
    FBusy: Boolean;

    fSrc: string;
    fptr: PChar;
    fCurrLine: Integer;
    fCurrPos: Integer;

    fLength: Integer;
    fLevel: Integer;
    fVarFunc: Boolean;
    //parsed items
    fTokenFile: Pointer;
    //***************
    fProgress: TParserProgressEvent;
    fLogToken: TLogTokenEvent;
    //stack manipulation
    fStack: TList;
    fLast: TTokenClass;
    function Pop: TTokenClass;
    function Top: TTokenClass;
    function Empty: Boolean;
    procedure Push(Item: TTokenClass);
    function StackLevel: Integer;
    //set events
    procedure DoProgress;
    procedure DoTokenLog(const S: string);
    //skip
    procedure SkipUntilFind(Chars: TSetOfChars);
    procedure SkipSpaces;
    procedure SkipEOL;
    procedure SkipDoubleQuotes;
    procedure SkipSingleQuotes;
    procedure SkipMultLineComment;
    procedure SkipSingleComment;
    procedure SkipPair(cStart, cEnd: Char; BreakOn: TSetOfChars = []);
    //count
    function CountCharacters: Integer;
    function CountElements(cStart, cEnd: Char): Integer;
    //get
    function GetWordUntilFind(Chars: TSetOfChars): string;
    function GetWordPair(cStart, cEnd: Char): string;
    function GetWord(SpaceSepOnly: Boolean = False): string;
    function GetEOL: string;
    {function GetFirstWord(const S: String): String;
    function GetLastWord(const S: String): String;
    function GetPriorWord(const S: String): String;}
    function GetArguments: string;
    //process
    procedure ProcessPreprocessor;
    procedure ProcessTypedef(StartPos, StartLine: Integer; const S: string);
    procedure ProcessParams(StartPos, StartLine: Integer);
    procedure ProcessVariable(StartPos, StartLine: Integer; const S: string);
    procedure ProcessStruct(Typedef: Boolean; StartPos, StartLine: Integer;
      const S: string);
    procedure ProcessUnion(Typedef: Boolean; StartPos, StartLine: Integer;
      const S: string);
    procedure ProcessEnum(Typedef: Boolean; StartPos, StartLine: Integer;
      const S: string);
    procedure ProcessClass(Typedef: Boolean; StartPos, StartLine: Integer;
      const S: string);
    procedure ProcessNamespace(Typedef: Boolean; StartPos,
      StartLine: Integer; const S: string);
    procedure ProcessFunction(StartPos, StartLine: Integer;
      const S: string; IsDestructor: Boolean = False);
    //additional
    function TrimAll(const S: string): string;

    procedure NextValidChar;
    function AddToken(const S, Flag: string; TkType: TTkType; Line, Start,
      Count, Level: Integer): TTokenClass;
  public
    property Canceled: Boolean read fCancel;
    property Busy: Boolean read fBusy;
    property OnProgess: TParserProgressEvent read fProgress write fProgress;
    property OnLogToken: TLogTokenEvent read fLogToken write fLogToken;
    //******************************************
    constructor Create;
    destructor Destroy; override;
    procedure Cancel;
    procedure Clear;
    function Parse(const Src: string; TokenFile: Pointer): Boolean;
  end;

implementation

uses TokenFile, TokenUtils, TokenConst;

{TCppParser}

procedure TCppParser.SkipEOL;
begin
  repeat
    if fptr^ in LineChars then
      Exit;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '\': if (fptr + 1)^ = #10 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          if fptr^ = #10 then
            Inc(fCurrLine);
          Inc(fCurrLine);
        end
        else if (fptr + 1)^ = #13 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          if fptr^ = #10 then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            if fptr^ = #10 then
              Inc(fCurrLine);
            Inc(fCurrLine);
          end;
        end;
    end;
    if fCancel then
      Exit;
  until fptr^ in LineChars + [#0];
end;

procedure TCppParser.SkipDoubleQuotes;
begin
  repeat
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '\': if (fptr + 1)^ = '"' then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
        end;
    end;
    if (fptr^ = #10) and ((fptr - 1)^ <> '\') then
      Break;
    if fCancel then
      Exit;
  until fptr^ in ['"', #0, #10];
end;

procedure TCppParser.SkipSingleQuotes;
begin
  repeat
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '\': if (fptr + 1)^ = '''' then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
        end;
    end;
    if (fptr^ = #10) and ((fptr - 1)^ <> '\') then
      Break;
    if fCancel then
      Exit;
  until fptr^ in ['''', #0];
end;

procedure TCppParser.SkipMultLineComment;
begin
  repeat
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
    end;
    if fCancel then
      Exit;
  until (fptr^ = #0) or ((fptr^ = '*') and ((fptr + 1)^ = '/'));

  if fptr^ <> #0 then
  begin
    Inc(fptr);
    Inc(fCurrPos);
  end;
end;

procedure TCppParser.SkipSpaces;
begin
  repeat
    if fptr^ <> #0 then
    begin
      if not (fptr^ in SpaceChars) and
        not ((fptr^ = '\') and ((fptr + 1)^ in [#10, #13])) then
        Exit;
    end;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '\': if (fptr + 1)^ = #10 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          Inc(fCurrLine);
        end
        else if (fptr + 1)^ = #13 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          if fptr^ = #10 then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            Inc(fCurrLine);
          end;
        end;
    end;
    if fCancel then
      Exit;
  until not (fptr^ in SpaceChars) or (fptr^ = #0);
end;

procedure TCppParser.SkipSingleComment;
begin
  SkipEOL;
end;

function TCppParser.CountCharacters: Integer;
var
  CanExit: Boolean;
begin
  Result := 1;
  CanExit := False;
  repeat
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '\': if (fptr + 1)^ in ['\', 'n', 'r', 't', 'b', '0', '"', ''''] then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          Inc(Result);
        end
        else if (fptr + 1)^ = 'x' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          Inc(Result);
          while (fptr + 1)^ in HexChars + DigitChars do
          begin
            Inc(fptr);
            Inc(fCurrPos);
          end;
        end;
      '"': CanExit := True; //skip
    else
      Inc(Result);
    end;
    if fCancel then
      Exit;
  until (fptr^ = #0) or CanExit;
end;

function TCppParser.CountElements(cStart, cEnd: Char): Integer;
var
  PairCount, Count: Integer;
begin
  Result := 0;
  Count := 0;
  PairCount := 0;
  repeat
    if fptr^ = cStart then
      Inc(PairCount)
    else if fptr^ = cEnd then
      Dec(PairCount);
    if PairCount = 0 then
      Break;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '"':
        begin
          SkipDoubleQuotes;
          Inc(Result);
        end;
      '''':
        begin
          SkipSingleQuotes;
          Inc(Result);
        end;
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '(':
        begin
          Inc(Result);
          SkipPair('(', ')');
          if cEnd = ')' then
          begin
            Inc(fptr);
            Inc(fCurrPos);
          end;
        end;
      '{':
        begin
          Inc(Result);
          SkipPair('{', '}');
          if cEnd = '}' then
          begin
            Inc(fptr);
            Inc(fCurrPos);
          end;
        end;
      '}': ;
      ',': Inc(Count);
    else
      if not (fptr^ in SpaceChars + LineChars) and (Result = 0) then
        Inc(Result);
    end;
    if fCancel then
      Exit;
  until (PairCount = 0) or (fptr^ = #0);
  if (Result <> 0) and (Count > 0) then
    Result := Count + 1;
end;

function TCppParser.GetWordPair(cStart, cEnd: Char): string;
var
  PairCount: Integer;
begin
  Result := '';
  PairCount := 0;
  repeat
    if fptr^ = cStart then
      Inc(PairCount)
    else if fptr^ = cEnd then
      Dec(PairCount);
    if PairCount = 0 then
      Break;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '"': SkipDoubleQuotes;
      '''': SkipSingleQuotes;
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      ';':
        begin
          Result := '';
          Exit;
        end;
      '(': Result := Result + '(' + GetWordPair('(', ')') + ')';
    else
      if fptr^ in SpaceChars + LineChars then
        Result := Trim(Result) + ' '
      else if not (fptr^ in [cStart, cEnd]) then
        Result := Result + fptr^;
    end;
    if fCancel then
      Exit;
  until (PairCount = 0) or (fptr^ = #0);
  Result := Trim(Result);
end;

procedure TCppParser.SkipPair(cStart, cEnd: Char; BreakOn: TSetOfChars);
var
  PairCount: Integer;
begin
  PairCount := 0;
  repeat
    if fptr^ = cStart then
      Inc(PairCount)
    else if fptr^ = cEnd then
      Dec(PairCount);
    if (PairCount = 0) or (fptr^ in BreakOn) then
      Break;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '"': SkipDoubleQuotes;
      '''': SkipSingleQuotes;
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
    end;
    if fCancel then
      Exit;
  until (PairCount = 0) or (fptr^ = #0);
end;

procedure TCppParser.ProcessPreprocessor;
var
  TokenName, TempWord, DefStr: string;
  Len, I, Line: Integer;
  IncludeChar: Char;
begin
  TokenName := '';
  if fptr^ = '#' then
  begin
    Inc(fptr);
    Inc(fCurrPos);
  end;
  SkipSpaces;
  repeat
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '\': Break;
    else
      if not (fptr^ in SpaceChars + LineChars) then
        TokenName := TokenName + fptr^;
    end;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    if fCancel then
      Exit;
  until fptr^ in SpaceChars + LineChars + [#0, '"', '<'];

  if TokenName = 'include' then
  begin
    SkipSpaces;
    IncludeChar := fptr^;
    if not (fptr^ in ['"', '<']) then
    begin
      SkipEOL;
      Exit;
    end;
    Inc(fptr);
    Inc(fCurrPos);
    SkipSpaces;
    Line := fCurrLine;
    I := fCurrPos - 1;
    TempWord := GetWordUntilFind([#10, #13, ' ', '"', '>']);
    SkipSpaces;
    if not (fptr^ in ['"', '>']) or
      ((IncludeChar = '<') and (fptr^ <> '>')) or
      ((IncludeChar = '"') and (fptr^ <> '"')) then
    begin
      SkipEOL;
      Exit;
    end;
    Len := Length(TempWord);
    if Len > 0 then
    begin
      Inc(I);
      if IncludeChar = '"' then
        AddToken(TempWord, 'L', tkInclude, Line, I, Len, fLevel)
      else if IncludeChar = '<' then
        AddToken(TempWord, 'S', tkInclude, Line, I, Len, fLevel)
    end;
  end
  else if TokenName = 'define' then
  begin
    SkipSpaces;
    Line := fCurrLine;
    I := fCurrPos;
    TempWord := Trim(GetWord);
    Len := Length(TempWord);
    if Len > 0 then
    begin
      if not (fptr^ in LineChars + SpaceChars) then
        DefStr := fptr^;
      DefStr := DefStr + GetEOL;
      if Length(DefStr) > 255 then
        DefStr := '{...}';
      DefStr := Trim(DefStr);
      AddToken(TempWord, DefStr, tkDefine, Line, I, Len, fLevel);
      if not (fptr^ in LineChars) then
        SkipEOL;
    end;
  end
  else //#ifndef #endif #ifdef ...
  begin
    SkipEOL;
  end;
end;

procedure TCppParser.ProcessTypedef(StartPos, StartLine: Integer; const S: string);
var
  RetType, RetTypeFunc, Asterisk, AstrkFunc, TempWord, TypeName: string;
  I, Len: Integer;
  CanGetName, ChangedCurrPos: Boolean;
  typeProto, aParams: TTokenClass;
begin
  Len := Length(S);
  TempWord := Trim(Copy(S, 8, Len - 7)); //typedef struct name -->> struct name
  RetType := TempWord;
  if fptr^ <> '(' then
  begin
    RetType := GetPriorWord(TempWord); //struct , int ...
    if RetType = '' then
      RetType := TempWord;
  end;
  if fptr^ in ['{', ':'] then
  begin
    if RetType = 'struct' then
      ProcessStruct(True, StartPos, StartLine, TempWord)
    else if RetType = 'union' then
      ProcessUnion(True, StartPos, StartLine, TempWord)
    else if RetType = 'enum' then
      ProcessEnum(True, StartPos, StartLine, TempWord)
    else if RetType = 'class' then
      ProcessClass(True, StartPos, StartLine, TempWord);
    Exit;
  end;
  CanGetName := True;
  ChangedCurrPos := False;
  Asterisk := '';
  I := Pos('*', RetType);
  if I > 0 then
  begin
    Asterisk := Copy(RetType, I, Length(RetType) - I + 1); //copy ** from int **
    RetType := Copy(RetType, 1, I - 1); //copy type only ex: int
  end;
  Asterisk := TrimAll(Asterisk);
  RetTypeFunc := RetType;
  AstrkFunc := Asterisk;
  if fptr^ <> '(' then
    TypeName := GetLastWord(TempWord);
  repeat
    case fptr^ of
      #10: Inc(fCurrLine);
      '"': SkipDoubleQuotes;
      '''': SkipSingleQuotes;
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '(':
        begin
          if not CanGetName then //params
          begin
            TypeName := Trim(TypeName);
            TempWord := '(' + GetPriorWord(TypeName) + Asterisk + '): ' +
              RetTypeFunc + AstrkFunc;
            TypeName := GetLastWord(TypeName);
            Len := Length(TypeName);
            if Len > 0 then
            begin
              typeProto := AddToken(TypeName, Trim(TempWord), tkTypedefProto, StartLine,
                StartPos, Len, fLevel);
              Push(typeProto);

              aParams := AddToken('Params', '', tkParams, fCurrLine, fCurrPos + 1,
                1, fLevel);
              Inc(fptr);
              Inc(fCurrPos);
              Inc(StartPos);

              ProcessParams(StartPos, StartLine);
              Pop; //pop Params
              if fptr^ = ')' then
              begin
                aParams.SelLength := fCurrPos - aParams.SelStart;
                Inc(fptr);
                Inc(fCurrPos);
                NextValidChar;
              end;
              Pop; //typedefproto
            end;
            Exit;
          end
          else
          begin //(*PROTONAME)
            RetTypeFunc := RetType + ' ' + TypeName;
            AstrkFunc := Asterisk;
            Asterisk := '';
            TypeName := '';
            ChangedCurrPos := True;
          end;
        end;
      ')':
        begin
          if CanGetName then
            CanGetName := False;
        end;
      ',', ';':
        begin
          TypeName := Trim(TypeName);
          if not CanGetName then //invalid or preprocessed typedef prototype
          begin
            Exit;
          end
          else //make a new rettype to add
            TempWord := RetType + Asterisk;
          Len := Length(TypeName);
          if Len > 0 then
            AddToken(TypeName, TempWord, tkTypedef, StartLine, StartPos,
              Len, fLevel);
          if fptr^ = ';' then
            Break;
          TypeName := '';
          Asterisk := '';
          AstrkFunc := '';
          RetTypeFunc := RetType;
          ChangedCurrPos := True;
          CanGetName := True;
        end;
    else
      if (fptr^ in LetterChars + DigitChars) and CanGetName then
      begin
        if ChangedCurrPos then
        begin
          StartPos := fCurrPos;
          StartLine := fCurrLine;
          ChangedCurrPos := False;
        end;
        TypeName := TypeName + fptr^;
      end
      else if fptr^ in SpaceChars + LineChars + ['*'] then
      begin
        if fptr^ = '*' then
          Asterisk := Asterisk + '*';
        TypeName := Trim(TypeName) + ' ';
        ChangedCurrPos := True;
      end;
    end;
    Inc(fptr);
    Inc(fCurrPos);
  until fptr^ = #0;
end;

procedure TCppParser.ProcessVariable(StartPos, StartLine: Integer; const S: string);
var
  RetType, Asterisk, VarName, Vector, TempWord: string;
  HasEqual, HasVector, ChangeCurrPos: Boolean;
  I, Len: Integer;
begin
  HasEqual := False;
  VarName := GetLastWord(S); //var name
  RetType := GetPriorWord(S); //var type
  Asterisk := '';
  I := Pos('*', RetType);
  if I > 0 then
  begin
    Asterisk := Copy(RetType, I, Length(RetType) - I + 1);
    RetType := Copy(RetType, 1, I - 1);
  end;
  Vector := '';
  HasVector := False;
  ChangeCurrPos := False;
  repeat
    case fptr^ of
      #10: Inc(fCurrLine);
      '"': //char name[] = "asdadadada";
        begin
          if HasEqual then
          begin
            if Vector = '[]' then
            begin
              Vector := '[' + IntToStr(CountCharacters) + ']';
            end
            else
              SkipDoubleQuotes; //user determined, skip
          end
          else
            SkipDoubleQuotes; //error, skip ""
        end;
      '''': SkipSingleQuotes;
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment //
        else if (fptr + 1)^ = '*' then //   /*  dsadsads  */
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '[': // int a[]
        begin
          Vector := Vector + '[' + GetWordPair('[', ']') + ']';
          HasVector := True;
        end;
      '{': // struct point pt[?] = {{1, 2}, {3, 4}}; ? is 2
        begin
          if HasEqual then //count elements
          begin
            if Vector = '[]' then
            begin
              Vector := '[' + IntToStr(CountElements('{', '}')) + ']';
            end
            else
              SkipPair('{', '}'); //user determined, skip
          end
          else
            SkipPair('{', '}'); //error, skip
        end;
      '=': HasEqual := True; //int a = 3;
      ',', ';', ':', '}', ')': //} is a error
        begin
          TempWord := GetFirstWord(RetType); //check for return case
          if (CountWords(RetType + Asterisk + ' ' + VarName) > 1) and
            not StringIn(TempWord, ['return', 'case', 'else']) then
          begin
            Len := Length(Vector);
            if (Len > 48) then
              Vector := '[]';
            Len := Length(VarName);
            if StringIn(RetType, ['class', 'struct']) then
            begin
              AddToken(VarName, RetType + Asterisk + Vector, tkForward,
                StartLine, StartPos, Len, fLevel);
            end
            else if StringIn(GetFirstWord(RetType), ['using']) then
            begin
              AddToken(VarName, RetType + Asterisk + Vector, tkUsing,
                StartLine, StartPos, Len, fLevel);
            end
            else if (Len > 0) and not IsNumber(Trim(VarName)) then
            begin
              AddToken(VarName, RetType + Asterisk + Vector, tkVariable,
                StartLine, StartPos, Len, fLevel);
            end;
          end;
          HasEqual := False;
          HasVector := False;
          ChangeCurrPos := True;
          if fptr^ = ':' then
            HasVector := True; //struct bit separated
          Asterisk := '';
          VarName := '';
          Vector := '';
          if fptr^ in [';', '}', ')'] then
          begin
            if fptr^ in ['}'] then
            begin
              Dec(fptr);
              Dec(fCurrPos);
            end;
            Break;
          end;
        end;
    else
      if not HasEqual and not HasVector then
      begin
        if (fptr^ in LetterChars + DigitChars) then
        begin
          if ChangeCurrPos then
          begin
            ChangeCurrPos := False;
            StartPos := fCurrPos;
            StartLine := fCurrLine;
          end;
          VarName := VarName + fptr^;
        end
        else if fptr^ = '*' then
        begin
          Asterisk := Asterisk + '*';
          ChangeCurrPos := True;
        end;
      end;
    end;
    Inc(fptr);
    Inc(fCurrPos);
  until fptr^ in [#0];
end;

procedure TCppParser.ProcessStruct(Typedef: Boolean; StartPos,
  StartLine: Integer; const S: string);
var
  RetType, StructName, Asterisk, CurrStr, TempWord,
    LastName, Ancestor: string;
  I, PairCount: Integer;
  scope: TTokenClass;
  CanExit, ChangedCurrPos: Boolean;
begin
  CanExit := False;
  ChangedCurrPos := True;
  StructName := S;
  CurrStr := '';
  Asterisk := '';
  RetType := '';
  PairCount := 0;
  Ancestor := '';
  if fptr^ = ':' then
  begin
    Inc(fptr);
    Inc(fCurrPos);
    Ancestor := GetWordUntilFind(['{', ';', '}', '(', ')', '[', ']']);
    if fptr^ in ['}', '(', ')', '[', ']'] then
      Exit;
  end;
  I := Pos('struct', StructName);
  if I > 0 then
    Delete(StructName, I, 6);
  StructName := Trim(StructName);
  LastName := Trim(StructName);
  repeat
    case fptr^ of
      #10:
        begin
          Inc(fCurrLine);
          ChangedCurrPos := True;
        end;
      '"':
        begin
          SkipDoubleQuotes;
          ChangedCurrPos := True;
        end;
      '''':
        begin
          SkipSingleQuotes;
          ChangedCurrPos := True;
        end;
      '<':
        begin
          TempWord := GetFirstWord(CurrStr);
          if TempWord = 'template' then
          begin
            SkipPair('<', '>');
            CurrStr := '';
            ChangedCurrPos := True;
          end;
        end;
      '/':
        begin
          if (fptr + 1)^ = '/' then
            SkipSingleComment
          else if (fptr + 1)^ = '*' then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            SkipMultLineComment;
          end;
          ChangedCurrPos := True;
        end;
      '{':
        begin
          ChangedCurrPos := True;
          if PairCount = 0 then
          begin
            I := Length(StructName);
            if I = 0 then
              StructName := '{unnamed}';
            AddToken(StructName, Ancestor, tkStruct, StartLine, StartPos, I, fLevel);
            AddToken('Scope', '', tkScope, fCurrLine, fCurrPos + 1, 0, fLevel);
            Inc(fLevel);
            Inc(PairCount);
          end
          else
          begin
            TempWord := GetFirstWord(RetType);
            if TempWord = 'struct' then
              ProcessStruct(False, StartPos, StartLine, RetType)
            else if TempWord = 'union' then
              ProcessUnion(False, StartPos, StartLine, CurrStr)
            else
            begin
              SkipPair('{', '}');
            end;
          end;
        end;
      '}':
        begin
          if fLevel > 0 then
            Dec(fLevel);
          if PairCount > 0 then
            Dec(PairCount);
          if not Empty then
          begin
            if (Top.Token in [tkStruct, tkUnion, tkEnum, tkFunction, tkClass,
              tkScopeClass]) then
            begin
              scope := GetTokenByName(Top, 'Scope', tkScope);
              if Assigned(scope) then
                scope.SelLength := fCurrPos - scope.SelStart;
            //DoTokenLog('SelStart: ' + IntToStr(scope.SelStart) + ' - ' +
            //  'SelLength: ' + IntToStr(scope.SelLength) + ' - ' +
            //  'SelLine: ' + IntToStr(scope.SelLine));
            end;
            I := Top.Level;
            if fLevel = I then
              Pop;
          end;
          CurrStr := '';
          ChangedCurrPos := True;
        end;
      '#': ProcessPreprocessor;
      ',', '[', ':':
        begin
          ChangedCurrPos := True;
          CurrStr := Trim(CurrStr);
          if PairCount = 0 then
          begin
            if Typedef then
            begin
              I := Length(CurrStr);
              if I > 0 then
              begin
                if Assigned(fLast) then
                begin
                  if fLast.Name = '{unnamed}' then
                  begin
                    fLast.Name := CurrStr;
                    fLast.SelLine := StartLine;
                    fLast.SelStart := StartPos;
                    fLast.SelLength := I;
                    fLast.Flag := fLast.Flag + Asterisk;
                    fLast.Token := tkTypeStruct;
                  end
                  else
                    AddToken(CurrStr, LastName + Asterisk, tkTypeStruct, StartLine, StartPos, I, fLevel);
                end
                else
                begin
                  AddToken(CurrStr, '', tkTypeStruct, StartLine, StartPos, I, fLevel);
                end;
              end;
            end
            else
            begin
              if Length(CurrStr) > 0 then
                ProcessVariable(StartPos, StartLine, 'struct ' + StructName +
                  Asterisk + ' ' + CurrStr);
              CanExit := True;
            end;
          end
          else
          begin
            ProcessVariable(StartPos, StartLine, RetType + Asterisk + ' ' +
              CurrStr);
          end;
          CurrStr := '';
          RetType := '';
          Asterisk := '';
        end;
      '(': ProcessFunction(StartPos, StartLine, RetType + Asterisk + ' ' +
          CurrStr);
      ';':
        begin
          ChangedCurrPos := True;
          CurrStr := Trim(CurrStr);
          if PairCount = 0 then
          begin
            if Typedef then
            begin
              I := Length(CurrStr);
              if I > 0 then
              begin
                if Assigned(fLast) then
                begin
                  if fLast.Name = '{unnamed}' then
                  begin
                    fLast.Name := CurrStr;
                    fLast.SelLine := StartLine;
                    fLast.SelStart := StartPos;
                    fLast.SelLength := I;
                    fLast.Flag := Asterisk;
                    fLast.Token := tkTypeStruct;
                  end
                  else
                    AddToken(CurrStr, 'struct ' + fLast.Name + Asterisk, tkTypeStruct, StartLine, StartPos, I, fLevel);
                end
                else
                  AddToken(CurrStr, '', tkTypeStruct, StartLine, StartPos, I, fLevel);
              end;
            end
            else
            begin
              if Length(CurrStr) > 0 then //variable with struct type
                ProcessVariable(StartPos, StartLine, 'struct ' + StructName +
                  Asterisk + ' ' + CurrStr);
            end;
            CanExit := True;
          end
          else
          begin
            ProcessVariable(StartPos, StartLine, RetType + Asterisk + ' ' +
              CurrStr);
          end;
          CurrStr := '';
          RetType := '';
          Asterisk := '';
        end;
    else
      if fptr^ in LetterChars + DigitChars then
      begin
        if ChangedCurrPos then
        begin
          ChangedCurrPos := False;
          StartPos := fCurrPos;
          StartLine := fCurrLine;
        end;
        CurrStr := CurrStr + fptr^;
      end
      else if fptr^ = '*' then
      begin
        Asterisk := Asterisk + '*';
        ChangedCurrPos := True;
      end
      else if fptr^ in SpaceChars + LineChars then
      begin
        if PairCount <> 0 then //if is a variable  { int a;
        begin
          RetType := Trim(RetType + CurrStr) + ' ';
          CurrStr := '';
        end
        else //} BLA, BLA;
          CurrStr := Trim(CurrStr) + ' ';
        ChangedCurrPos := True;
      end;
    end;
    Inc(fptr);
    Inc(fCurrPos);
  until (fptr^ = #0) or CanExit;
end;

procedure TCppParser.ProcessUnion(Typedef: Boolean; StartPos,
  StartLine: Integer; const S: string);
var
  RetType, StructName, Asterisk, CurrStr, TempWord,
    LastName, Ancestor: string;
  I, PairCount: Integer;
  CanExit, ChangedCurrPos: Boolean;
  scope: TTokenClass;
begin
  CanExit := False;
  ChangedCurrPos := True;
  StructName := S;
  CurrStr := '';
  Asterisk := '';
  RetType := '';
  PairCount := 0;
  Ancestor := '';
  if fptr^ = ':' then
  begin
    Inc(fptr);
    Inc(fCurrPos);
    Ancestor := GetWordUntilFind(['{', ';', '}', '(', ')', '[', ']']);
    if fptr^ in ['}', '(', ')', '[', ']'] then
      Exit;
  end;
  I := Pos('union', StructName);
  if I > 0 then
    Delete(StructName, I, 6);
  StructName := Trim(StructName);
  LastName := Trim(StructName);
  repeat
    case fptr^ of
      #10:
        begin
          Inc(fCurrLine);
          ChangedCurrPos := True;
        end;
      '"':
        begin
          SkipDoubleQuotes;
          ChangedCurrPos := True;
        end;
      '''':
        begin
          SkipSingleQuotes;
          ChangedCurrPos := True;
        end;
      '/':
        begin
          if (fptr + 1)^ = '/' then
            SkipSingleComment
          else if (fptr + 1)^ = '*' then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            SkipMultLineComment;
          end;
          ChangedCurrPos := True;
        end;
      '{':
        begin
          ChangedCurrPos := True;
          if PairCount = 0 then
          begin
            I := Length(StructName);
            if I = 0 then
              StructName := '{unnamed}';
            AddToken(StructName, Ancestor, tkUnion, StartLine, StartPos, I, fLevel);
            AddToken('Scope', '', tkScope, fCurrLine, fCurrPos + 1, 0, fLevel);
            Inc(fLevel);
            Inc(PairCount);
          end
          else
          begin
            TempWord := GetFirstWord(CurrStr);
            if TempWord = 'struct' then
              ProcessStruct(False, StartPos, StartLine, CurrStr)
            else if TempWord = 'union' then
              ProcessUnion(False, StartPos, StartLine, CurrStr)
            else
            begin
              SkipPair('{', '}');
            end;
          end;
        end;
      '}':
        begin
          if fLevel > 0 then
            Dec(fLevel);
          if PairCount > 0 then
            Dec(PairCount);
          if not Empty then
          begin
            if (Top.Token in [tkStruct, tkUnion, tkEnum, tkFunction, tkClass,
              tkScopeClass]) then
            begin
              scope := GetTokenByName(Top, 'Scope', tkScope);
              if Assigned(scope) then
                scope.SelLength := fCurrPos - scope.SelStart;
            end;
            I := Top.Level;
            if fLevel = I then
              Pop;
          end;
          CurrStr := '';
          ChangedCurrPos := True;
        end;
      '#': ProcessPreprocessor;
      ',', '[', ':':
        begin
          ChangedCurrPos := True;
          CurrStr := Trim(CurrStr);
          if PairCount = 0 then
          begin
            if Typedef then
            begin
              I := Length(CurrStr);
              if I > 0 then
              begin
                if Assigned(fLast) then
                begin
                  if fLast.Name = '{unnamed}' then
                  begin
                    fLast.Name := CurrStr;
                    fLast.SelLine := StartLine;
                    fLast.SelStart := StartPos;
                    fLast.SelLength := I;
                    fLast.Flag := fLast.Flag + Asterisk;
                    fLast.Token := tkTypeUnion;
                  end
                  else
                    AddToken(CurrStr, LastName + Asterisk, tkTypeUnion, StartLine, StartPos, I, fLevel);
                end
                else
                begin
                  AddToken(CurrStr, '', tkTypeUnion, StartLine, StartPos, I, fLevel);
                end;
              end;
            end
            else
            begin
              if Length(CurrStr) > 0 then
                ProcessVariable(StartPos, StartLine, 'union ' + StructName +
                  Asterisk + ' ' + CurrStr);
              CanExit := True;
            end;
          end
          else
          begin
            ProcessVariable(StartPos, StartLine, RetType + Asterisk + ' ' +
              CurrStr);
          end;
          CurrStr := '';
          RetType := '';
          Asterisk := '';
        end;
      '(': ProcessFunction(StartPos, StartLine, RetType + Asterisk + ' ' +
          CurrStr);
      ';':
        begin
          ChangedCurrPos := True;
          CurrStr := Trim(CurrStr);
          if PairCount = 0 then
          begin
            if Typedef then
            begin
              I := Length(CurrStr);
              if I > 0 then
              begin
                if Assigned(fLast) then
                begin
                  if fLast.Name = '{unnamed}' then
                  begin
                    fLast.Name := CurrStr;
                    fLast.SelLine := StartLine;
                    fLast.SelStart := StartPos;
                    fLast.SelLength := I;
                    fLast.Flag := Asterisk;
                    fLast.Token := tkTypeUnion;
                  end
                  else
                    AddToken(CurrStr, 'union ' + fLast.Name + Asterisk, tkTypeUnion, StartLine, StartPos, I, fLevel);
                end
                else
                  AddToken(CurrStr, '', tkTypeUnion, StartLine, StartPos, I, fLevel);
              end;
            end
            else
            begin
              if Length(CurrStr) > 0 then //variable with struct type
                ProcessVariable(StartPos, StartLine, 'union ' + StructName +
                  Asterisk + ' ' + CurrStr);
            end;
            CanExit := True;
          end
          else
          begin
            ProcessVariable(StartPos, StartLine, RetType + Asterisk + ' ' +
              CurrStr);
          end;
          CurrStr := '';
          RetType := '';
          Asterisk := '';
        end;
    else
      if fptr^ in LetterChars + DigitChars then
      begin
        if ChangedCurrPos then
        begin
          ChangedCurrPos := False;
          StartPos := fCurrPos;
          StartLine := fCurrLine;
        end;
        CurrStr := CurrStr + fptr^;
      end
      else if fptr^ = '*' then
      begin
        Asterisk := Asterisk + '*';
        ChangedCurrPos := True;
      end
      else if fptr^ in SpaceChars + LineChars then
      begin
        if PairCount <> 0 then //if is a variable  { int a;
        begin
          RetType := RetType + CurrStr + ' ';
          CurrStr := '';
        end
        else //} BLA, BLA;
          CurrStr := Trim(CurrStr) + ' ';
        ChangedCurrPos := True;
      end;
    end;
    Inc(fptr);
    Inc(fCurrPos);
  until (fptr^ = #0) or CanExit;
end;

procedure TCppParser.ProcessEnum(Typedef: Boolean; StartPos,
  StartLine: Integer; const S: string);
var
  RetType, StructName, Asterisk, CurrStr, EnumValue,
    LastName, Ancestor: string;
  I, PairCount: Integer;
  CanExit, ChangedCurrPos, HasEqual: Boolean;
  scope: TTokenClass;
begin
  CanExit := False;
  ChangedCurrPos := True;
  StructName := S;
  CurrStr := '';
  RetType := '';
  EnumValue := '';
  PairCount := 0;
  HasEqual := False;
  I := Pos('enum', StructName);
  if I > 0 then
    Delete(StructName, I, 4);
  StructName := Trim(StructName);
  LastName := Trim(StructName);
  repeat
    case fptr^ of
      #10:
        begin
          Inc(fCurrLine);
          ChangedCurrPos := True;
        end;
      '"':
        begin
          SkipDoubleQuotes;
          ChangedCurrPos := True;
        end;
      '''':
        begin
          SkipSingleQuotes;
          ChangedCurrPos := True;
        end;
      '/':
        begin
          if (fptr + 1)^ = '/' then
            SkipSingleComment
          else if (fptr + 1)^ = '*' then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            SkipMultLineComment;
          end;
          ChangedCurrPos := True;
        end;
      '{':
        begin
          ChangedCurrPos := True;
          I := Length(StructName);
          if I = 0 then
            StructName := '{unnamed}';
          AddToken(StructName, Ancestor, tkEnum, StartLine, StartPos, I, fLevel);
          AddToken('Scope', '', tkScope, fCurrLine, fCurrPos + 1, 0, fLevel);
          Inc(fLevel);
          Inc(PairCount);
        end;
      '}':
        begin
          CurrStr := Trim(CurrStr);
          I := Length(CurrStr);
          if I > 0 then
            AddToken(CurrStr, EnumValue, tkEnumItem, StartLine, StartPos, I, fLevel);
          if fLevel > 0 then
            Dec(fLevel);
          if PairCount > 0 then
            Dec(PairCount);
          if not Empty then
          begin
            if (Top.Token in [tkStruct, tkUnion, tkEnum, tkFunction, tkClass,
              tkScopeClass]) then
            begin
              scope := GetTokenByName(Top, 'Scope', tkScope);
              if Assigned(scope) then
                scope.SelLength := fCurrPos - scope.SelStart;
            //DoTokenLog('SelStart: ' + IntToStr(scope.SelStart) + ' - ' +
            //  'SelLength: ' + IntToStr(scope.SelLength) + ' - ' +
            //  'SelLine: ' + IntToStr(scope.SelLine));
            end;
            I := Top.Level;
            if fLevel = I then
              Pop;
          end;
          CurrStr := '';
          ChangedCurrPos := True;
          HasEqual := False;
        end;
      '#': ProcessPreprocessor;
      '=':
        begin
          HasEqual := True;
          EnumValue := '';
        end;
      ',', '[':
        begin
          ChangedCurrPos := True;
          CurrStr := Trim(CurrStr);
          I := Length(CurrStr);
          if PairCount = 0 then
          begin
            if Typedef then
            begin
              if I > 0 then
              begin
                if Assigned(fLast) then
                begin
                  if fLast.Name = '{unnamed}' then
                  begin
                    fLast.Name := CurrStr;
                    fLast.SelLine := StartLine;
                    fLast.SelStart := StartPos;
                    fLast.SelLength := I;
                    fLast.Flag := fLast.Flag;
                    fLast.Token := tkTypeEnum;
                  end
                  else
                    AddToken(CurrStr, '', tkTypeEnum, StartLine, StartPos, I, fLevel);
                end
                else
                begin
                  AddToken(CurrStr, '', tkTypeEnum, StartLine, StartPos, I, fLevel);
                end;
              end;
            end
            else
            begin
              if Length(CurrStr) > 0 then
                ProcessVariable(StartPos, StartLine, 'enum ' + StructName +
                  Asterisk + ' ' + CurrStr);
              CanExit := True;
            end;
          end
          else
          begin
            if I > 0 then
              AddToken(CurrStr, EnumValue, tkEnumItem, StartLine, StartPos, I, fLevel);
          end;
          CurrStr := '';
          RetType := '';
          EnumValue := '';
          Asterisk := '';
          HasEqual := False;
        end;
      ';':
        begin
          ChangedCurrPos := True;
          CurrStr := Trim(CurrStr);
          if Typedef then
          begin
            I := Length(CurrStr);
            if I > 0 then
            begin
              if Assigned(fLast) then
              begin
                if fLast.Name = '{unnamed}' then
                begin
                  fLast.Name := CurrStr;
                  fLast.SelLine := StartLine;
                  fLast.SelStart := StartPos;
                  fLast.SelLength := I;
                  fLast.Flag := Asterisk;
                  fLast.Token := tkTypeEnum;
                end
                else
                  AddToken(CurrStr, 'enum ' + fLast.Name + Asterisk, tkTypeEnum,
                    StartLine, StartPos, I, fLevel);
              end
              else
                AddToken(CurrStr, '', tkTypeEnum, StartLine, StartPos, I, fLevel);
            end;
          end
          else
          begin
            if Length(CurrStr) > 0 then //variable with enum type
              ProcessVariable(StartPos, StartLine, 'enum ' + StructName +
                Asterisk + ' ' + CurrStr);
          end;
          CanExit := True;
          CurrStr := '';
          RetType := '';
          Asterisk := '';
        end;
    else
      if not HasEqual then
      begin
        if fptr^ in LetterChars + DigitChars then
        begin
          if ChangedCurrPos then
          begin
            ChangedCurrPos := False;
            StartPos := fCurrPos;
            StartLine := fCurrLine;
          end;
          CurrStr := CurrStr + fptr^;
        end
        else if fptr^ = '*' then
        begin
          Asterisk := Asterisk + '*';
          ChangedCurrPos := True;
        end
        else if fptr^ in SpaceChars + LineChars then
        begin
          CurrStr := Trim(CurrStr) + ' ';
          ChangedCurrPos := True;
        end;
      end
      else if fptr^ in LetterChars + DigitChars + ['-'] then
      begin
        EnumValue := EnumValue + fptr^;
      end
    end;
    Inc(fptr);
    Inc(fCurrPos);
  until (fptr^ = #0) or CanExit;
end;

procedure TCppParser.ProcessNamespace(Typedef: Boolean; StartPos,
  StartLine: Integer; const S: string);
var
  fNamespace: string;
begin
  fNamespace := GetLastWord(S);
  //DoTokenLog('ProcessNamespace' + fNamespace);
  AddToken(fNamespace, '', tkNamespace, StartLine, StartPos,
    Length(fNamespace), fLevel);
  AddToken('Scope', '', tkScope, fCurrLine, fCurrPos + 1, 0, fLevel);
  Inc(fLevel);
//  Inc(fCurrPos);
//  Inc(fptr);
end;

procedure TCppParser.ProcessClass(Typedef: Boolean; StartPos,
  StartLine: Integer; const S: string);
var
  fClassName, Ancestor: string;
  Scope: TTokenClass;
begin
  fClassName := GetLastWord(S);
  Ancestor := '';
  if fptr^ = ':' then
  begin
    Inc(fptr);
    Inc(fCurrPos);
    Ancestor := GetWordUntilFind(['{', ';', '}', '(', ')', '[', ']']);
    if fptr^ in ['}', '(', ')', '[', ']'] then
      Exit;
  end;
  //if not Empty then
  //  DoTokenLog('ProcessClass - stack not empty ' + Top.Name);
  AddToken(fClassName, Ancestor, tkClass, StartLine, StartPos,
    Length(fClassName), fLevel);
  AddToken('Scope', '', tkScope, fCurrLine, fCurrPos + 1, 0, fLevel);

  Inc(fLevel);
  Scope := AddToken('private', '', tkScopeClass, 0, 0, 0, fLevel);
  AddToken('protected', '', tkScopeClass, 0, 0, 0, fLevel);
  AddToken('public', '', tkScopeClass, 0, 0, 0, fLevel);
  Push(Scope);
  Inc(fCurrPos);
  Inc(fptr);
end;

procedure TCppParser.ProcessParams(StartPos, StartLine: Integer);
var
  RetType, ParamName, Vector: string;
  lastLine, lastPos, I: Integer;
  Reposition, HasEqual: Boolean;
begin
  RetType := '';
  Vector := '';
  if fptr^ = ')' then
    Exit;
  lastLine := fCurrLine;
  lastPos := fCurrPos;
  Reposition := True;
  HasEqual := False;
  repeat
    case fptr^ of
      #10:
        begin
          Inc(fCurrLine);
          Reposition := True;
        end;
      '"': //char name[] = "asdadadada"
        begin
          if HasEqual then
          begin
            if Vector = '[]' then
            begin
              Vector := '[' + IntToStr(CountCharacters) + ']';
            end
            else
              SkipDoubleQuotes; //user determined, skip
          end
          else
            SkipDoubleQuotes; //error, skip ""
        //Reposition := True;
        end;
      '[': // int a[]
        begin
          Vector := Vector + '[' + GetWordPair('[', ']') + ']';
        end;
      '{': // struct point pt[?] = {{1, 2}, {3, 4}}; ? is 2
        begin
          if HasEqual then //count elements
          begin
            if Vector = '[]' then
            begin
              Vector := '[' + IntToStr(CountElements('{', '}')) + ']';
            end
            else
              SkipPair('{', '}'); //user determined, skip
          end
          else
            SkipPair('{', '}'); //error, skip
        end;
      '''':
        begin
          SkipSingleQuotes;
          Reposition := True;
        end;
      '/':
        if (fptr + 1)^ = '/' then
        begin
          SkipSingleComment;
          Reposition := True;
        end
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
          Reposition := True;
        end;
      ',':
        begin
          RetType := Trim(RetType);
          ParamName := GetLastWord(RetType);
          I := Length(RetType);
          if (I > 0) and (not (RetType[I] in LetterChars + DigitChars) or
            (CountWords(RetType) = 1) or (StringIn(RetType, ReservedTypes))) then
          begin
            ParamName := '';
          end
          else
            RetType := GetPriorWord(RetType);
          AddToken(ParamName, RetType + Vector, tkVariable,
            lastLine, lastPos, Length(ParamName), fLevel);
          RetType := '';
          Vector := '';
          HasEqual := False;
          Reposition := True;
        end;
    else //std::vector<int*>    ...
      if fptr^ in LetterChars + DigitChars + [':', '<', '>', '*', '.'] then
      begin
        if fptr^ in [':', '<', '>', '*'] then
          RetType := Trim(RetType) + fptr^
        else
          RetType := RetType + fptr^;
        if Reposition or (fptr^ in ['*']) then
        begin
          lastLine := fCurrLine;
          lastPos := fCurrPos;
          Reposition := False;
        end;
      end
      else if fptr^ in LineChars + SpaceChars then
      begin
        RetType := RetType + ' ';
        Reposition := True;
      end;
    end;
    DoProgress;
    Inc(fptr);
    Inc(fCurrPos);
  until fptr^ in [#0, ')'];
  if (fptr^ = #0) or (Trim(RetType) = '') then
    Exit;
  RetType := Trim(RetType);
  ParamName := GetLastWord(RetType);
  I := Length(RetType);
  if (I > 0) and (not (RetType[I] in LetterChars + DigitChars) or
    (CountWords(RetType) = 1) or (StringIn(RetType, ReservedTypes))) then
  begin
    ParamName := '';
  end
  else
    RetType := GetPriorWord(RetType);
  if (ParamName <> '') or ((ParamName = '') and (RetType <> 'void')) then
    AddToken(ParamName, RetType + Vector, tkVariable,
      lastLine, lastPos, Length(ParamName), fLevel);
end;

function TCppParser.GetWordUntilFind(Chars: TSetOfChars): string;
begin
  Result := '';
  repeat
    if fptr^ in Chars then
      Exit;
    case fptr^ of
      #10: Inc(fCurrLine);
      '"': SkipDoubleQuotes;
      '''': SkipSingleQuotes;
      '/':
        if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end
        else
          Result := Result + fptr^;
      '(': SkipPair('(', ')');
      '{': SkipPair('{', '}');
      '[': SkipPair('[', ']');
    else
      if fptr^ in LetterChars + DigitChars + ['*', ',', '.', '-', ':', '\'] then
        Result := Result + fptr^
      else if fptr^ in LineChars + SpaceChars then
        Result := Result + ' ';
    end;
    DoProgress;
    Inc(fptr);
    Inc(fCurrPos);
  until fptr^ in [#0] + Chars;
end;

procedure TCppParser.SkipUntilFind(Chars: TSetOfChars);
begin
  repeat
    if fptr^ in Chars then
      Exit;
    case fptr^ of
      #10: Inc(fCurrLine);
      '"': SkipDoubleQuotes;
      '''': SkipSingleQuotes;
      '/':
        if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '(': SkipPair('(', ')');
      '{': SkipPair('{', '}');
      '[': SkipPair('[', ']');
    end;
    Inc(fptr);
    Inc(fCurrPos);
  until fptr^ in [#0] + Chars;
end;

procedure TCppParser.ProcessFunction(StartPos, StartLine: Integer;
  const S: string; IsDestructor: Boolean);
var
  RetType, FuncName, TreeName, ScopeName: string;
  Len, I: Integer;
  FuncToken, Params: TTokenClass;
  TokenType: TTkType;
begin
  //DoTokenLog('ProcessFunction - ' + S);
  TokenType := tkFunction;
  FuncName := GetLastWord(S);
  RetType := GetPriorWord(S);
  ScopeName := GetLastWord(RetType);
  I := Pos('::', RetType);
  if I > 0 then
  begin
    if '::' = Copy(RetType, Length(RetType) - 1, 2) then
      RetType := GetPriorWord(RetType)
    else
      ScopeName := '';
  end
  else
    ScopeName := '';
  // and not HasEqual (PairCount = 0) and
  if not Empty and (RetType = '') and (Top.Token in [tkScopeClass, tkStruct]) then
  begin
    TreeName := Top.Name;
    if Top.Token = tkScopeClass then
      TreeName := Top.Parent.Name;
    if TreeName <> FuncName then
    begin
      //DoTokenLog('skip ProcessFunction - function ' + FuncName + ': ' + RetType + ' - Invalid');
      SkipPair('(', ')');
      Exit;
    end;
    if (fptr - (Length(FuncName) + 1))^ = '~' then
      TokenType := tkDestructor
    else
      TokenType := tkConstructor;
  end
  else if (RetType = '') and (ScopeName = '') then
  begin
    //DoTokenLog('skip ProcessFunction - function <' + ScopeName + '> ' +
    //  FuncName + ': ' + RetType);
    Inc(fptr);
    Inc(fCurrPos);
    SkipUntilFind([';', '}', ')']);
    Exit;
  end;
  //DoTokenLog('skip ProcessFunction - function <' + ScopeName + '> ' +
  //    FuncName + ': ' + RetType);
  if not StringIn(FuncName, ReservedBraceWords) and
    not StringIn(RetType, ['return', 'else']) then
  begin
    Len := Length(FuncName);
    if RetType = '' then
    begin
      RetType := GetPriorWord(ScopeName);
      ScopeName := GetLastWord(ScopeName);
      if FuncName = ScopeName then
      begin
        if IsDestructor then
          TokenType := tkDestructor
        else
          TokenType := tkConstructor;
      end;
    end;
    FuncToken := AddToken(FuncName, RetType, TokenType, StartLine, StartPos,
      Len, fLevel);
    Params := AddToken('Params', '', tkParams, fCurrLine, fCurrPos + 1,
      1, fLevel);
    Inc(fptr);
    Inc(fCurrPos);
    Inc(StartPos);

    ProcessParams(StartPos, StartLine);
    Pop; //pop Params

    if fptr^ = ')' then
    begin
      Params.SelLength := fCurrPos - Params.SelStart;
      Inc(fptr);
      Inc(fCurrPos);
    end;

    SkipUntilFind(['{', ';']);

    if fptr^ = ';' then
    begin
      Pop; //pop function
      if Assigned(FuncToken.Parent) and (FuncToken.Parent.Token in
        [tkFunction, tkConstructor, tkDestructor]) and (RetType <> '') then
      begin
        FuncToken.Clear;
        FuncToken.Token := tkVariable;
        //DoTokenLog(FuncToken.Name + ' is really a funtcion?: ' + FuncToken.Flag);
      end
      else
      begin
        if FuncToken.Token = tkFunction then
          FuncToken.Token := tkPrototype;
      end;
    end
    else if (fptr^ = '{') then
    begin
      AddToken('Scope', ScopeName, tkScope, fCurrLine, fCurrPos + 1, 0, fLevel);
      Inc(fLevel);
      if not fVarFunc then
      begin
        SkipPair('{', '}');
        Dec(fLevel);
      end;
    end;
    //else
      //DoTokenLog('ProcessFunction - error end function');
  end;
end;

function TCppParser.GetEOL: string;
begin
  repeat
    if fptr^ in LineChars then
      Exit;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '\': if (fptr + 1)^ = #10 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          if fptr^ = #10 then
            Inc(fCurrLine);
          Inc(fCurrLine);
        end
        else if (fptr + 1)^ = #13 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          if fptr^ = #10 then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            if fptr^ = #10 then
              Inc(fCurrLine);
            Inc(fCurrLine);
          end;
        end;
    else
      if not (fptr^ in SpaceChars + LineChars) then
        Result := Result + fptr^
      else
        Result := Trim(Result) + ' ';
    end;
    if fCancel then
      Exit;
  until fptr^ in LineChars + [#0];
end;

function TCppParser.GetWord(SpaceSepOnly: Boolean = False): string;
var
  TokenName: string;
begin
  TokenName := '';
  SkipSpaces;
  repeat
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      #13: ; //skip
    else
      if (fptr^ in LetterChars + DigitChars) or (SpaceSepOnly and not (fptr^ in SpaceChars)) then
        TokenName := TokenName + fptr^
      else if fptr^ in SpaceChars + ['(', ')', ','] then
        Break;
    end;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    if fCancel then
      Exit;
  until fptr^ in [#0, #10];
  if fptr^ = #10 then
    Inc(fCurrLine);
  Result := TokenName;
end;

function TCppParser.TrimAll(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  I := Length(Result);
  while I > 0 do
  begin
    if Result[I] in SpaceChars + LineChars then
      Delete(Result, I, 1);
    Dec(I);
  end;
end;

procedure TCppParser.NextValidChar;
begin
  if not (fptr^ in SpaceChars + LineChars) then
    Exit;
  repeat
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    case fptr^ of
      #10: Inc(fCurrLine); //LF
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      '\': if (fptr + 1)^ = #10 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          Inc(fCurrLine);
        end
        else if (fptr + 1)^ = #13 then
        begin
          Inc(fptr, 2);
          Inc(fCurrPos, 2);
          if fptr^ = #10 then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            Inc(fCurrLine);
          end;
        end;
    end;
    if fCancel then
      Exit;
  until not (fptr^ in SpaceChars + LineChars) or (fptr^ = #0);
end;

function TCppParser.GetArguments: string;
var
  PairCount: Integer;
begin
  PairCount := 0;
  if fptr^ = '(' then
  begin
    Inc(fptr);
    Inc(fCurrPos);
    Inc(PairCount);
  end;
  Result := '';
  repeat
    case fptr^ of
      '(':
        begin
          Inc(PairCount);
          GetArguments;
          Dec(PairCount);
          Continue;
        end;
      ')': Dec(PairCount);
      #10: Inc(fCurrLine); //LF
      '"': SkipDoubleQuotes;
      '''': SkipSingleQuotes;
      '/': if (fptr + 1)^ = '/' then
          SkipSingleComment
        else if (fptr + 1)^ = '*' then
        begin
          Inc(fptr);
          Inc(fCurrPos);
          SkipMultLineComment;
        end;
      ' ', #9:
        begin
          Result := Trim(Result) + ' ';
          SkipSpaces;
          Continue;
        end;
    else
      if (fptr^ in LetterChars + DigitChars + ArithmChars + [',', '[', ']']) then
        Result := Result + fptr^;
    end;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    if fCancel then
      Exit;
  until (PairCount = 0) or (fptr^ = #0);
end;

function TCppParser.Parse(const Src: string; TokenFile: Pointer): Boolean;
var
  CurrStr, TempWord, Scope: string;
  ChangedCurrPos, IsDestructor: Boolean;
  PairCount, StartPos, StartLine: Integer;
  lastFunc, scopeClass: TTokenClass;
begin
  fBusy := True;
  fTokenFile := TokenFile;
  Clear;
  fSrc := Src;
  Result := False;
  fptr := PChar(fSrc);
  fLength := StrLen(fptr);
  if fptr^ <> #0 then
    fCurrLine := 1;
  DoProgress;
  CurrStr := '';
  PairCount := 0;
  StartPos := 0;
  StartLine := fCurrLine;
  ChangedCurrPos := True;
  IsDestructor := False;
  Scope := '';
  repeat
    case fptr^ of
      #10:
        begin
          Inc(fCurrLine); //LF
          ChangedCurrPos := True;
        end;
      '#':
        begin
          ProcessPreprocessor;
          CurrStr := '';
          IsDestructor := False;
        end;
      '''': SkipSingleQuotes;
      '"': SkipDoubleQuotes;
      '/':
        begin
          if (fptr + 1)^ = '/' then
            SkipSingleComment
          else if (fptr + 1)^ = '*' then
          begin
            Inc(fptr);
            Inc(fCurrPos);
            SkipMultLineComment;
          end;
          ChangedCurrPos := True;
        end;
      '(': //int main( ..., typedef int (...
        begin
          TempWord := GetFirstWord(CurrStr);
          if TempWord = 'typedef' then
            ProcessTypedef(StartPos, StartLine, CurrStr)
          else if TempWord = 'extern' then
          begin
            TempWord := GetLastWord(CurrStr);
            if not StringIn(TempWord, ReservedTypes) and
              (TempWord <> 'extern') then
            begin
              ProcessFunction(StartPos, StartLine, GetAfterWord(CurrStr),
                IsDestructor);
            end
            else
            begin
              StartPos := fCurrPos + 1;
              TempWord := Copy(CurrStr, 7, Length(CurrStr) - 7);
              CurrStr := GetWordPair('(', ')');
              if fptr^ = ')' then
              begin
                Inc(fptr);
                Inc(fCurrPos);
              end;
              NextValidChar;
              Inc(StartPos, Pos('*', CurrStr));
              TempWord := Trim(TempWord + ' ' + CurrStr);
              if fptr^ in [';', '['] then //?
                ProcessVariable(StartPos, StartLine, TempWord)
              else if fptr^ = '(' then
              begin
                ProcessFunction(StartPos, StartLine, TempWord, IsDestructor);
              end;
            end;
          end
          else if PairCount = 0 then
          begin
            ProcessFunction(StartPos, StartLine, CurrStr, IsDestructor);
          end
          else
            SkipPair('(', ')', [';', '{', '}']);
          CurrStr := '';
          ChangedCurrPos := True;
          IsDestructor := False;
        end;
      ')':
        begin
          CurrStr := '';
          ChangedCurrPos := True;
          IsDestructor := False;
        end;
      '~': IsDestructor := True;
      '.':
        begin
          CurrStr := '';
          IsDestructor := False;
        end;
      '=':
        begin
          ProcessVariable(StartPos, StartLine, CurrStr);
          CurrStr := '';
          IsDestructor := False;
        end;
      '{':
        begin //struct{, typedef ...{, switch(){, int main(){
          TempWord := GetFirstWord(CurrStr);
          if TempWord = 'typedef' then
            ProcessTypedef(StartPos, StartLine, CurrStr)
          else if TempWord = 'struct' then
            ProcessStruct(False, StartPos, StartLine, CurrStr)
          else if TempWord = 'union' then
            ProcessUnion(False, StartPos, StartLine, CurrStr)
          else if TempWord = 'enum' then
            ProcessEnum(False, StartPos, StartLine, CurrStr)
          else if TempWord = 'namespace' then
            ProcessNamespace(False, StartPos, StartLine, CurrStr)
          else if TempWord = 'extern' then //extern "?" {
            SkipEOL
          else
          begin
            if TempWord = 'class' then
              ProcessClass(False, StartPos, StartLine, CurrStr)
            else
              Inc(PairCount); //function, switch, for, while, do
            Inc(fLevel); //Level ->>
          end;
          CurrStr := '';
          IsDestructor := False;
        end;
      '}':
        begin
          if fLevel > 0 then
            Dec(fLevel); //Level <<-
          if PairCount > 0 then
            Dec(PairCount);
          if StackLevel = fLevel then
          begin
            lastFunc := Pop; //remove top item
            if Assigned(lastFunc) then
            begin
              if (lastFunc.Token in [tkFunction, tkConstructor, tkNamespace,
                tkDestructor]) and (lastFunc.Count > 1) then
              begin
                scopeClass := GetTokenByName(lastFunc, 'Scope', tkScope);
                if Assigned(scopeClass) then
                  scopeClass.SelLength := fCurrPos - scopeClass.SelStart;
              end;
              if not Empty and (lastFunc.Token = tkScopeClass) then
              begin
                lastFunc := Pop;
                if lastFunc.Token = tkClass then
                begin
                  scopeClass := GetTokenByName(lastFunc, 'private', tkScopeClass);
                  if Assigned(scopeClass) and (scopeClass.Count = 0) then
                    lastFunc.Remove(scopeClass);
                  scopeClass := GetTokenByName(lastFunc, 'protected', tkScopeClass);
                  if Assigned(scopeClass) and (scopeClass.Count = 0) then
                  begin
                    lastFunc.Remove(scopeClass);
                  //DoTokenLog('Parse - ' + scopeClass.Name + ' ' + TokenNames[scopeClass.Token]);
                  end;
                  scopeClass := GetTokenByName(lastFunc, 'public', tkScopeClass);
                  if Assigned(scopeClass) and (scopeClass.Count = 0) then
                    lastFunc.Remove(scopeClass);
                  scopeClass := GetTokenByName(lastFunc, 'Scope', tkScope);
                  if Assigned(scopeClass) then
                    scopeClass.SelLength := fCurrPos - scopeClass.SelStart;
                end;
                if fLevel > 0 then
                  Dec(fLevel);
              end;
            end;
          end;
          CurrStr := '';
          ChangedCurrPos := True;
          IsDestructor := False;
        end;
      ',', '[', ';': //int a; int a, b; int a[];
        begin
          TempWord := GetFirstWord(CurrStr);
          if TempWord = 'typedef' then
            ProcessTypedef(StartPos, StartLine, CurrStr)
          else
          begin
            ProcessVariable(StartPos, StartLine, CurrStr);
          end;
          CurrStr := '';
          ChangedCurrPos := True;
          IsDestructor := False;
        end;
      '<':
        begin
          TempWord := GetFirstWord(CurrStr);
          if TempWord = 'template' then
          begin
          //DoTokenLog('Skip template' + TempWord);
            SkipPair('<', '>');
            CurrStr := '';
            ChangedCurrPos := True;
          end;
        end;
      ':':
        begin
          TempWord := GetFirstWord(CurrStr);
          if TempWord = 'struct' then
          begin
            ProcessStruct(False, StartPos, StartLine, CurrStr);
            CurrStr := '';
          end
          else if TempWord = 'union' then
          begin
            ProcessUnion(False, StartPos, StartLine, CurrStr);
            CurrStr := '';
          end
          else if TempWord = 'typedef' then
          begin
            ProcessTypedef(StartPos, StartLine, CurrStr);
            CurrStr := '';
          end
          else if TempWord = 'class' then
          begin
            ProcessClass(False, StartPos, StartLine, CurrStr);
            Inc(fLevel);
            CurrStr := '';
          end
          else if StringIn(GetLastWord(CurrStr), ScopeNames) and not Empty then
          begin
            Scope := GetLastWord(CurrStr);
            lastFunc := nil;
            if Assigned(Top.Parent) and (Top.Parent.Token = tkClass) then
              lastFunc := GetTokenByName(Top.Parent, Scope, tkScopeClass)
            else if (Top.Token = tkClass) then
              lastFunc := GetTokenByName(Top, Scope, tkScopeClass);
            if Assigned(lastFunc) and (Top <> lastFunc) then
            begin
            //swap scope
              Pop;
              Push(lastFunc);
            end;
            CurrStr := '';
          end
          else
            CurrStr := CurrStr + ':';
        //DoTokenLog('Parse - is function: ' + CurrStr);
          if ((fptr + 1)^ = ':') and ((fptr + 2)^ = '~') then
            IsDestructor := True;
          ChangedCurrPos := True;
        end;
      #0: Break;
    else
      if fptr^ in SpaceChars + LineChars then
      begin
        CurrStr := Trim(CurrStr) + ' ';
        ChangedCurrPos := True;
      end
      else if fptr^ in LetterChars + DigitChars + ['*'] then
      begin
        CurrStr := CurrStr + fptr^;
        if ChangedCurrPos then
        begin
          StartPos := fCurrPos;
          StartLine := fCurrLine;
          ChangedCurrPos := False;
        end;
        if fptr^ = '*' then
          ChangedCurrPos := True;
      end
    end;
    Inc(fptr);
    Inc(fCurrPos);
    DoProgress;
    if fCancel then
    begin
      fBusy := False;
      Exit;
    end;
  until (fptr^ = #0);
  Result := not fCancel;
  fBusy := False;
end;

function TCppParser.AddToken(const S, Flag: string; TkType: TTkType; Line, Start,
  Count, Level: Integer): TTokenClass;
var
  TokenClass: TTokenClass;
begin
  if not Empty and not (TkType in [tkInclude, tkDefine]) then
  begin
    TokenClass := Top;
    Result := TTokenClass.Create(TokenClass);
    Result.Fill(Line, Count, Start, Level, TkType, S, Flag);
    if TokenClass <> nil then
    begin
      TokenClass.Add(Result);
    end;
    if TkType in [tkStruct, tkUnion, tkEnum, tkFunction, tkConstructor, tkParams,
      tkDestructor, tkNamespace, tkClass] then
    begin
      Push(Result);
    end;
  end
  else
  begin
    TokenClass := nil;
    case TkType of
      tkInclude: TokenClass := TTokenFile(fTokenFile).Includes;
      tkDefine: TokenClass := TTokenFile(fTokenFile).Defines;
      tkTypedef, tkTypedefProto, tkClass, tkStruct, tkTypeStruct, tkEnum,
        tkTypeEnum, tkUnion, tkTypeUnion, tkScopeClass, tkNamespace:
        TokenClass := TTokenFile(fTokenFile).TreeObjs;
      tkVariable, tkUnknow, tkForward, tkUsing, tkEnumItem:
        TokenClass := TTokenFile(fTokenFile).VarConsts;
      tkPrototype, tkFunction, tkConstructor, tkDestructor:
        TokenClass := TTokenFile(fTokenFile).FuncObjs;
    end;
    Result := TTokenClass.Create(TokenClass);
    Result.Fill(Line, Count, Start, Level, TkType, S, Flag);
    if TokenClass <> nil then
    begin
      TokenClass.Add(Result);
    end;
    if TkType in [tkStruct, tkUnion, tkEnum, tkFunction, tkConstructor,
      tkDestructor, tkParams, tkClass, tkNamespace] then
    begin
      Push(Result);
    end;
  end;

end;

constructor TCppParser.Create;
begin
  inherited Create;
  fVarFunc := True;
  fStack := TList.Create;
end;

destructor TCppParser.Destroy;
begin
  fStack.Free;
  inherited Destroy;
end;

procedure TCppParser.Cancel;
begin
  fCancel := True;
end;

procedure TCppParser.Clear;
begin
  TTokenFile(fTokenFile).FuncObjs.Clear;
  TTokenFile(fTokenFile).TreeObjs.Clear;
  TTokenFile(fTokenFile).VarConsts.Clear;
  TTokenFile(fTokenFile).Defines.Clear;
  TTokenFile(fTokenFile).Includes.Clear;
  fStack.Clear;
  fLast := nil;
  fCurrLine := 0;
  fCurrPos := 0;
  fLength := 0;
  fLevel := 0;
  fCancel := False;
  fptr := '';
  fSrc := '';
end;

procedure TCppParser.DoTokenLog(const S: string);
begin
  if Assigned(fLogToken) then
    fLogToken(Self, S, fCurrLine);
end;

procedure TCppParser.DoProgress;
begin
  if Assigned(fProgress) then
    fProgress(Self, fCurrPos, fLength);
end;

function TCppParser.Pop: TTokenClass;
begin
  if not Empty then
  begin
    Result := TTokenClass(fStack.Last);
    fLast := Result;
    fStack.Delete(fStack.Count - 1);
    //if Empty then fLast := nil;
  end
  else
  begin
    Result := nil;
    fLast := nil;
  end;
end;

function TCppParser.Top: TTokenClass;
begin
  if not Empty then
    Result := TTokenClass(fStack.Last)
  else
    Result := nil;
end;

function TCppParser.Empty: Boolean;
begin
  Result := (fStack.Count = 0);
end;

procedure TCppParser.Push(Item: TTokenClass);
begin
  fLast := Item;
  fStack.Add(Item);
end;

function TCppParser.StackLevel: Integer;
begin
  Result := 0;
  if Empty then
    Exit;
  Result := TTokenClass(fStack.Last).Level;
end;

end.
