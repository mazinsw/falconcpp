unit CppParser;

interface

uses
  Classes, SysUtils, TokenList, CppTokenizer;

type
  TSetOfChars = set of AnsiChar;
  TSetOfTkxType = set of TTkxType;

  TLogTokenEvent = procedure(Sender: TObject; Msg: string; Current: Integer) of object;
  TParserProgressEvent = procedure(Sender: TObject; Current, Total: Integer) of object;

  TCppParser = class(TObject)
  private
    FCancel: Boolean;
    FBusy: Boolean;

    FStartPtr: PChar;
    FFirst: PToken;
    FCurrent: PToken;
    FLevel: Integer;
    FVarFunc: Boolean;
    FComment: string;
    FRightComment: string;
    FOpenCommentCount: Integer;
    //parsed items
    FTokenFile: Pointer;
    //stack manipulation
    FStack: TList;
    FLast: TTokenClass;
    FPrev: TTokenClass;
    function Pop: TTokenClass;
    function Top: TTokenClass;
    function Empty: Boolean;
    procedure Push(Item: TTokenClass);
    function StackLevel: Integer;
//    //count
//    function CountCharacters: Integer;
//    function CountElements(cStart, cEnd: Char): Integer;
//    //process
    procedure ProcessPreprocessor;
//    procedure ProcessTypedef(StartPos, StartLine: Integer; const S: string);
//    procedure ProcessParams(StartPos, StartLine: Integer);
//    procedure ProcessVariable(StartPos, StartLine: Integer; const S: string);
//    procedure ProcessStruct(Typedef: Boolean; StartPos, StartLine: Integer;
//      const S: string);
//    procedure ProcessUnion(Typedef: Boolean; StartPos, StartLine: Integer;
//      const S: string);
//    procedure ProcessEnum(Typedef: Boolean; StartPos, StartLine: Integer;
//      const S: string);
//    procedure ProcessClass(Typedef: Boolean; StartPos, StartLine: Integer;
//      const S: string);
//    procedure ProcessNamespace(Typedef: Boolean; StartPos,
//      StartLine: Integer; const S: string);
//    procedure ProcessFunction(StartPos, StartLine: Integer;
//      const S: string; IsDestructor: Boolean = False);
    //additional
//    function TrimAll(const S: string): string;
    function AddToken(const S, Flag: string; TkType: TTkType; Line, Start,
      Len, Level: Integer): TTokenClass;
    function SkipUntilFind(TypeSet: TSetOfTkxType): Boolean;
    function GetEOL(Line: Integer): string;
    procedure SkipEOL(Line: Integer);
    function ProcessStruct(Token: TTkType): TTokenClass;
    function GetInheritanceNoTemplate: string;
    function SkipTemplate: Boolean;
    procedure ProcessFields(StopLevel: Integer);
    procedure ProcessIdentifier(Fields: Boolean);
    function GetTypeNoTemplate(var TokenID, TokenDestr: PToken): string;
    procedure ProcessCloseBraces;
    procedure ProcessVariableOrFunction(Fields: Boolean);
    function GetPointerReference: string;
    function GetIdentifierNoTemplate(var TokenID, TokenDestr: PToken): string;
    function SkipPair: Boolean;
    function SkipAssign: Boolean;
    function Next: Boolean;
    procedure ProcessParams;
    procedure ProcessTypedef(StructToken: TTokenClass);
  public
    property Canceled: Boolean read fCancel;
    property Busy: Boolean read fBusy;
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

function TCppParser.SkipUntilFind(TypeSet: TSetOfTkxType): Boolean;
begin
  while (FCurrent <> nil) and not (FCurrent^.Token in TypeSet) do
    Next;
  Result := FCurrent <> nil;
end;

function TCppParser.GetEOL(Line: Integer): string;
var
  Space: string;
  Prev: PToken;
begin
  Result := '';
  Space := '';
  Prev := nil;
  while (FCurrent <> nil) do
  begin
    if (FCurrent^.Line > Line) and ((Prev = nil) or (Prev^.Token <> tkxBackslash)) then
      Exit;
    Line := FCurrent^.Line;
    Prev := FCurrent;
    Next;
    if Prev^.Token = tkxBackslash then
      Continue;
    Result := Result + Space + TokenString(FStartPtr, Prev);
    Space := ' ';
  end;
end;

function TCppParser.GetTypeNoTemplate(var TokenID, TokenDestr: PToken): string;
begin
  Result := '';
  TokenID := nil;
  while (FCurrent <> nil) do
  begin
    if FCurrent^.Token = tkxIdentifier then
    begin
      if TokenID <> nil then
        Break;
      TokenID := FCurrent;
    end
    else if FCurrent^.Token in [tkxLess, tkxShiftLeft] then
    begin
      SkipTemplate;
      Continue;
    end
    else if FCurrent^.Token = tkxGlobalScope then
    begin
      if TokenID <> nil then
        Result := Result + TokenString(FStartPtr, TokenID) + '::'
      else
        Result := Result + '::';
      TokenID := nil;
    end
    else if FCurrent^.Token = tkxBinNot then
    begin
      TokenDestr := FCurrent;
    end
    else
      Break;
    Next;
  end;
end;   

function TCppParser.GetIdentifierNoTemplate(var TokenID, TokenDestr: PToken): string;
begin
  Result := GetTypeNoTemplate(TokenID, TokenDestr);
end;

function TCppParser.Next: Boolean;
begin
  FCurrent := FCurrent^.Next;
  while (FCurrent <> nil) and (FCurrent^.Token = tkxComment) do
    FCurrent := FCurrent^.Next;
  Result := FCurrent = nil;
end;

function TCppParser.GetPointerReference: string;
var
  TokenReference: PToken;
begin
  Result := '';
  TokenReference := nil;
  while (FCurrent <> nil) do
  begin
    if FCurrent^.Token = tkxBinAnd then
    begin
      if TokenReference <> nil then
      begin
        // incorrect &&
        Next;
        Continue; // skip
      end;
      TokenReference := FCurrent;
      Result := Result + '&';
    end
    else if FCurrent^.Token = tkxMult then
    begin
      if TokenReference <> nil then
      begin
        // incorrect & *
        Next;
        Continue; // skip
      end;
      Result := Result + '*';
    end
    else
      Break;
    Next;
  end;
end;

function TCppParser.GetInheritanceNoTemplate: string;
var
  Space: string;
  TokenID, TokenDestr: PToken;
begin
  Result := '';
  Space := '';
  while (FCurrent <> nil) and not (FCurrent^.Token in [tkxSemicolon,
    tkxOpenBraces]) do
  begin
    if FCurrent^.Token = tkxIdentifier then
    begin
      if TokenMatch(FStartPtr, 'public', FCurrent) or
         TokenMatch(FStartPtr, 'protected', FCurrent) or
         TokenMatch(FStartPtr, 'private', FCurrent) then
      begin
        Result := Result + Space + TokenString(FStartPtr, FCurrent);
      end
      else
      begin
        Result := Result + Space + GetTypeNoTemplate(TokenID, TokenDestr);
        Result := Result + TokenString(FStartPtr, TokenID);
        Space := ' ';
        Continue;
      end;
      Space := ' ';
    end
    else if FCurrent^.Token = tkxComma then
    begin
      Result := Result + ',';
      Space := ' ';
    end
    else if FCurrent^.Token = tkxGlobalScope then
    begin
      Result := Result + Space + GetTypeNoTemplate(TokenID, TokenDestr);
      Result := Result + TokenString(FStartPtr, TokenID);
      Space := ' ';
      Continue;
    end;
    Next;
  end;
end;

procedure TCppParser.SkipEOL(Line: Integer);
var
  Prev: PToken;
begin
  Prev := nil;
  while (FCurrent <> nil) do
  begin
    if (FCurrent^.Line > Line) and ((Prev = nil) or (Prev^.Token <> tkxBackslash)) then
      Exit;
    Line := FCurrent^.Line;
    Prev := FCurrent;
    Next;
  end;
end;

function TCppParser.SkipTemplate: Boolean;
var
  OpenCount: Integer;
begin
  OpenCount := 0;
  repeat
    if FCurrent^.Token = tkxLess then
      Inc(OpenCount)
    else if FCurrent^.Token = tkxGreater then
      Dec(OpenCount)
    else if FCurrent^.Token = tkxShiftLeft then
      Inc(OpenCount, 2)
    else if FCurrent^.Token = tkxShiftRight then
      Dec(OpenCount, 2);
    Next;
  until (FCurrent = nil) or (OpenCount = 0);
  Result := OpenCount = 0;
end;

function TCppParser.SkipPair: Boolean;
var
  OpenCount: Integer;
  OpenToken, CloseToken: TTkxType;
begin
  OpenCount := 0;
  OpenToken := FCurrent^.Token;
  if OpenToken = tkxOpenBrackets then
    CloseToken := tkxCloseBrackets
  else if OpenToken = tkxOpenParentheses then
    CloseToken := tkxCloseParentheses
  else
    CloseToken := tkxCloseBraces;
  repeat
    if FCurrent^.Token = OpenToken then
      Inc(OpenCount)
    else if FCurrent^.Token = CloseToken then
      Dec(OpenCount);
    Next;
  until (FCurrent = nil) or (OpenCount = 0);
  Result := OpenCount = 0;
end;

function TCppParser.SkipAssign: Boolean;
begin
  repeat
    if FCurrent^.Token in [tkxOpenParentheses, tkxOpenBraces, tkxOpenBrackets] then
    begin
      SkipPair;
      Continue;
    end;
    Next;
  until (FCurrent = nil) or (FCurrent^.Token in [tkxSemicolon, tkxComma,
    tkxCloseParentheses, tkxCloseBraces, tkxCloseBrackets]);
  Result := (FCurrent <> nil);
end;


procedure TCppParser.ProcessPreprocessor;
var
  S, DefStr: string;
  NameToken: PToken;
begin
  if not SkipUntilFind([tkxIdentifier]) then
    Exit;
  if TokenMatch(FStartPtr, 'include', FCurrent) then
  begin
    if not SkipUntilFind([tkxString, tkxIncludePath]) then
      Exit;
    if TokenLength(FCurrent) < 2 then // "" or <>
      Exit;
    S := TokenString(FStartPtr, FCurrent);
    if S[1] = '"' then
    begin
      S := Trim('"', S, '"');
      AddToken(S, 'L', tkInclude, FCurrent^.Line,
        FCurrent^.StartPosition + 1, Length(S), FLevel);
    end
    else
    begin
      S := Trim('<', S, '>');
      AddToken(S, 'S', tkInclude, FCurrent^.Line,
        FCurrent^.StartPosition + 1, Length(S), FLevel);
    end;
    Next;
  end
  else if TokenMatch(FStartPtr, 'define', FCurrent) then
  begin
    Next;
    if not SkipUntilFind([tkxIdentifier]) then
      Exit;
    NameToken := FCurrent;
    S := TokenString(FStartPtr, NameToken);
    Next;
    DefStr := GetEOL(NameToken^.Line);
    if Length(DefStr) > 255 then
      DefStr := '{...}';
    AddToken(S, DefStr, tkDefine, NameToken^.Line,
      NameToken^.StartPosition, Length(S), FLevel);
  end
  else // ifdef, ifndef, if, else, endif, error, pragma
  begin
    SkipEOL(FCurrent^.Line);
  end;
end;

function TCppParser.ProcessStruct(Token: TTkType): TTokenClass;
var
  NameToken, SaveCurrent: PToken;
  Flag, Name: string;
  Scope: TTokenClass;
begin
  Result := nil;
  NameToken := FCurrent; // struct or class
  Next;
  SaveCurrent := FCurrent;
  while (FCurrent <> nil) and (FCurrent^.Token = tkxIdentifier) do
  begin
    Next;
    if (FCurrent = nil) then
    begin
      FCurrent := SaveCurrent;
      Break;
    end;
    if FCurrent^.Token = tkxOpenParentheses then
    begin
      SkipPair;
    end
    else if FCurrent^.Token = tkxIdentifier then
    begin
      SaveCurrent := FCurrent;
    end
    else
    begin
      FCurrent := SaveCurrent;
      Break;
    end;
  end;
  if FCurrent = nil then
    Exit;
  Flag := '';
  if FCurrent^.Token = tkxIdentifier then // name or export flag
  begin
    NameToken := FCurrent;
    Next;
    if FCurrent = nil then
      Exit;
    if FCurrent^.Token = tkxColon then
    begin
      Next;
      Flag := GetInheritanceNoTemplate;
    end
    else if FCurrent^.Token in [tkxLess, tkxShiftLeft] then
    begin
      SkipTemplate;
    end;
    Name := TokenString(FStartPtr, NameToken);
  end
  else
    Name := '';
  if (FCurrent = nil) or (FCurrent^.Token <> tkxOpenBraces) then
    Exit;
  Result := AddToken(Name, Flag, Token, NameToken^.Line,
    NameToken^.StartPosition, NameToken^.EndPosition - NameToken^.StartPosition,
    FLevel);
  // store { } range
  AddToken('Scope', '', tkScope, FCurrent^.Line, FCurrent^.StartPosition, 0, 
    FLevel);
  // store fields correctly into scope
  Scope := AddToken('private', '', tkScopeClass, 0, 0, 0, FLevel);
  AddToken('protected', '', tkScopeClass, 0, 0, 0, FLevel);
  if Token <> tkClass then
    Scope := AddToken('public', '', tkScopeClass, 0, 0, 0, FLevel)
  else
    AddToken('public', '', tkScopeClass, 0, 0, 0, FLevel);
  Push(Scope);
  ProcessFields(FLevel);
end;

procedure TCppParser.ProcessParams;
var
  TokenID, TokenIdType, TokenOption, TokenPtrRef, TokenDestr: PToken;
  TypeStr, PtrRefStr, VarName, VectorStr, OptionsStr: string;
begin
  PtrRefStr := '';
  OptionsStr := '';
  VectorStr := ''; // TODO
  TokenID := nil;
  TokenOption := nil;
  TokenPtrRef := nil;
  TokenIdType := nil;
  while (FCurrent <> nil) do
  begin
    case FCurrent^.Token of
      tkxGlobalScope,
      tkxIdentifier:
        begin
          if TokenIdType = nil then
          begin
            TypeStr := GetTypeNoTemplate(TokenIdType, TokenDestr);
            TypeStr := TypeStr + TokenString(FStartPtr, TokenIdType);
            PtrRefStr := '';
            OptionsStr := '';
            VectorStr := ''; // TODO
            TokenID := nil;
            TokenOption := nil;
            TokenPtrRef := nil;
            Continue;
          end;
          if TokenID <> nil then
          begin
            if TokenOption = nil then
            begin
              TokenOption := TokenID;
              OptionsStr := VarName;
            end
            else
              OptionsStr := OptionsStr + ' ' + VarName;
          end;
          VarName := GetIdentifierNoTemplate(TokenID, TokenDestr);
          VarName := VarName + TokenString(FStartPtr, TokenID);
          TokenPtrRef := nil;
          Continue;
        end;
      tkxComma,
      tkxCloseParentheses,
      tkxAssign:
        begin
          if TokenOption <> nil then
            OptionsStr := ' ' + OptionsStr;
          if (TokenID <> nil) and (TokenPtrRef = nil) and not
            ((VarName = 'const') or
             (VarName = 'int') or
             (VarName = 'char') or
             (VarName = 'long') or
             (VarName = 'short') or
             (VarName = 'unsigned')) then
          begin
            AddToken(VarName, TypeStr + OptionsStr + PtrRefStr + VectorStr,
              tkVariable, TokenID^.Line, TokenID^.StartPosition,
              TokenID^.EndPosition - TokenID^.StartPosition, FLevel);
          end
          else
          begin
            VarName := ' ' + VarName;
            if (TokenID = nil) and (TokenPtrRef <> nil) then
                TokenID := TokenPtrRef
            else if (TokenID = nil) and (TokenPtrRef <> nil) then
                TokenID := TokenIdType;
            AddToken('', TypeStr + OptionsStr + VarName + PtrRefStr + VectorStr,
              tkVariable, FCurrent^.Line, FCurrent^.StartPosition, 0, FLevel);
          end;
          PtrRefStr := '';
          OptionsStr := '';
          VectorStr := '';
          TokenID := nil;
          TokenOption := nil;
          TokenPtrRef := nil;
          TokenIdType := nil; // indepedent type
          if FCurrent^.Token = tkxCloseParentheses then
            Break;
          if FCurrent^.Token = tkxAssign then
          begin
            SkipAssign;
            Continue;
          end;
        end;
      tkxInterval:
        begin
          TypeStr := '';
          TokenID := FCurrent;
          VarName := '...';
        end;
      tkxOpenParentheses:
        begin
          if not SkipPair then
            Exit;
          Continue;
        end;
      tkxOpenBrackets:
        begin
          if SkipPair then
            VectorStr := VectorStr + '[]';
          Continue;
        end;
      tkxOpenBraces:
        begin
          //if HasAssign then
            SkipPair;
          //else
            // error
          Continue;
        end;
      tkxMult,
      tkxBinAnd:
        begin
          TokenPtrRef := FCurrent;
          PtrRefStr := GetPointerReference;
          Continue;
        end;
    else
      Break; // error ID not found
    end;
    Next;
  end;
end;

procedure TCppParser.ProcessVariableOrFunction(Fields: Boolean);
var
  TokenID, TokenIdType, TokenOption, TokenPtrRef, TokenScope,
  SaveCurrent, TokenDestr, SaveSkip: PToken;
  VarToken, FuncToken: TTokenClass;
  TokenType: TTkType;
  TypeStr, PtrRefStr, VarName, VectorStr, OptionsStr, ScopeStr,
  SaveTypeStr, TypeNameStr: string;
  ParensCount: Integer;
begin
  TokenDestr := nil;
  TypeStr := GetTypeNoTemplate(TokenIdType, TokenDestr);
  SaveTypeStr := TypeStr;
  TypeNameStr := TokenString(FStartPtr, TokenIdType);
  TypeStr := TypeStr + TypeNameStr;
  PtrRefStr := '';
  OptionsStr := '';
  VectorStr := ''; // TODO
  ScopeStr := '';
  TokenID := nil;
  TokenOption := nil;
  TokenPtrRef := nil;
  TokenScope := nil;
  while (FCurrent <> nil) do
  begin
    case FCurrent^.Token of
      tkxGlobalScope,
      tkxIdentifier:
        begin
          if TokenID <> nil then
          begin
            if TokenOption = nil then
            begin
              TokenOption := TokenID;
              OptionsStr := ScopeStr + VarName;
            end
            else
              OptionsStr := OptionsStr + ' ' + ScopeStr + VarName;
          end;
          TokenScope := FCurrent;
          ScopeStr := GetIdentifierNoTemplate(TokenID, TokenDestr);
          VarName := TokenString(FStartPtr, TokenID);
          TokenPtrRef := nil;
          Continue;
        end;
      tkxColon: // label:
        begin
          Next;
          if not Fields or (FCurrent = nil) or (FCurrent^.Token <> tkxNumber) then
            Exit;
        end;
      tkxComma,
      tkxSemicolon,
      tkxAssign:
        begin
          if TokenID = nil then
            Exit; // error identifier not found
          if TokenPtrRef <> nil then
            Exit; // error: example: int a *;
          if TokenOption <> nil then
            OptionsStr := ' ' + OptionsStr;
          VarToken := AddToken(VarName, TypeStr + OptionsStr + PtrRefStr + VectorStr, 
            tkVariable, TokenID^.Line, TokenID^.StartPosition,
            TokenID^.EndPosition - TokenID^.StartPosition, FLevel);
          if (Length(ScopeStr) > 0) and (TokenScope <> nil) then
          begin
            Push(VarToken);
            AddToken('Scope', Trim(#0, ScopeStr, ':'), tkScope, TokenScope^.Line,
              TokenScope^.StartPosition, 0, FLevel);
            Pop;
          end;
          PtrRefStr := '';
          OptionsStr := '';
          VectorStr := '';
          ScopeStr := '';
          TokenID := nil;
          TokenOption := nil;
          TokenPtrRef := nil; 
          TokenScope := nil;
          TokenDestr := nil;
          if FCurrent^.Token = tkxSemicolon then
          begin
            Next;
            Break;
          end;
          if FCurrent^.Token = tkxAssign then
          begin
            SkipAssign;
            Continue;
          end;
        end;
      tkxOpenParentheses:
        begin
          SaveCurrent := FCurrent;
          if not SkipPair then
            Exit;
          SaveSkip := FCurrent;
          if (FCurrent <> nil) and (FCurrent^.Token = tkxIdentifier) then
            Next; // skip const or attribute
          if (FCurrent = nil) or not
             (FCurrent^.Token in [tkxColon, tkxOpenBraces, tkxSemicolon, tkxAssign,
              tkxOpenParentheses, tkxOpenBrackets]) then
          begin
            FCurrent := SaveSkip;
            Exit;
          end;
          if FCurrent^.Token in [tkxOpenParentheses, tkxOpenBrackets] then // int((main))(...)
          begin
            ParensCount := 0;
            FCurrent := SaveCurrent;
            while (FCurrent <> nil) and (FCurrent^.Token = tkxOpenParentheses) do
            begin
              Inc(ParensCount);
              Next;
            end;
            if (FCurrent <> nil) and (FCurrent^.Token in [tkxMult, tkxBinAnd]) then
            begin
              TokenPtrRef := FCurrent;
              PtrRefStr := GetPointerReference;
            end;
            if (FCurrent <> nil) and (FCurrent^.Token in [tkxIdentifier, tkxGlobalScope]) then
            begin
              if TokenID <> nil then
              begin
                if TokenOption = nil then
                begin
                  TokenOption := TokenID;
                  OptionsStr := ScopeStr + VarName;
                end
                else
                  OptionsStr := OptionsStr + ' ' + ScopeStr + VarName;
              end;
              TokenScope := FCurrent;
              ScopeStr := GetIdentifierNoTemplate(TokenID, TokenDestr);
              VarName := TokenString(FStartPtr, TokenID);
              TokenPtrRef := nil;
            end;
            while (FCurrent <> nil) and (FCurrent^.Token = tkxCloseParentheses) do
            begin
              Dec(ParensCount);
              Next;
            end;
            if ParensCount <> 0 then
            begin
              FCurrent := SaveCurrent; // DEF(foo, bar)()?
              Exit;
            end;
            Continue;
          end;
          if (TokenID = nil) and ((Top = nil) or (Top.Token <> tkScopeClass) or
             (Top.Parent.Name <> TypeNameStr)) and (GetLastWord(SaveTypeStr) <> TypeNameStr) then
            Continue;
          if (FCurrent^.Token = tkxSemicolon) and (Top <> nil) and
             (Top.Token in [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
             Continue;
          if (TokenID = nil) or ((Top <> nil) and (Top.Token = tkScopeClass) and
            (Top.Parent.Name = VarName)) or (GetLastWord(ScopeStr) = VarName) then
          begin
            if TokenDestr = nil then
              TokenType := tkConstructor
            else
              TokenType := tkDestructor;
          end
          else if (FCurrent^.Token in [tkxColon, tkxOpenBraces]) then
            TokenType := tkFunction
          else
            TokenType := tkPrototype;
          if TokenID <> nil then
          begin
            if OptionsStr <> '' then
              OptionsStr := ' ' + OptionsStr;
            FuncToken := AddToken(VarName, TypeStr + OptionsStr + PtrRefStr + VectorStr,
              tkFunction, TokenID^.Line, TokenID^.StartPosition,
              TokenID^.EndPosition - TokenID^.StartPosition, FLevel);
          end
          else // constructor | destructor
          begin
            FuncToken := AddToken(TypeNameStr, OptionsStr + PtrRefStr + VectorStr,
              tkFunction, TokenIdType^.Line, TokenIdType^.StartPosition,
              TokenIdType^.EndPosition - TokenIdType^.StartPosition, FLevel);
            ScopeStr := SaveTypeStr;
          end;
          AddToken('Params', '', tkParams, SaveCurrent^.Line,
            SaveCurrent^.StartPosition + 1, 0, FLevel);
          FCurrent := SaveCurrent;
          Next; // skip (
          ProcessParams;
          Pop;
          Next; // skip )
          if (FCurrent^.Token = tkxIdentifier) and
              TokenMatch(FStartPtr, 'const', FCurrent) then
            Next; // skip const
          FuncToken.Token := TokenType;
          if (FCurrent^.Token = tkxAssign) then
          begin
            Next; // skip =
            if (FCurrent = nil) or (FCurrent^.Token <> tkxNumber) then
              Exit;
            AddToken('Value', '0', tkValue, FCurrent^.Line, FCurrent^.StartPosition,
              FCurrent^.EndPosition - FCurrent^.StartPosition, FLevel);
            Pop; // pop prototype
          end
          else if (FCurrent^.Token <> tkxSemicolon) then
          begin
            while (FCurrent <> nil) and (FCurrent^.Token <> tkxOpenBraces) do
            begin
              if (FCurrent^.Token in [tkxOpenParentheses, tkxOpenBrackets]) then
              begin
                SkipPair;
                Continue;
              end;
              Next;
            end;
            if (FCurrent = nil) then
              Exit;
            AddToken('Scope', Trim(#0, ScopeStr, ':'), tkScope, FCurrent^.Line,
              FCurrent^.StartPosition + 1, 0, FLevel);
          end
          else
            Pop; // pop prototype
          Exit;
        end;
      tkxOpenBrackets:
        begin
          if SkipPair then
            VectorStr := VectorStr + '[]';
          Continue;
        end;
      tkxOpenBraces:
        begin
          //if HasAssign then
            SkipPair;
          //else
            // error
          Continue;
        end;
      tkxMult,
      tkxBinAnd:
        begin
          TokenPtrRef := FCurrent;
          PtrRefStr := GetPointerReference;
          Continue;
        end;
      tkxBinNot:
        begin
          TokenDestr := FCurrent;
        end
    else
      Break; // error ID not found
    end;
    Next;
  end;
end;

procedure TCppParser.ProcessTypedef(StructToken: TTokenClass);
var
  TokenID, TokenOption, TokenPtrRef, TokenFuncPtr,
  SaveCurrent, TokenDestr: PToken;
  ProtoTypeToken: TTokenClass;
  TokenType: TTkType;
  TypeStr, PtrRefStr, FuncPtrStr, TypedefId, VectorStr, OptionsStr,
  CallStr: string;
begin
  TokenDestr := nil;
  PtrRefStr := '';
  OptionsStr := '';
  VectorStr := '';
  TokenID := nil;
  TokenOption := nil;
  TokenPtrRef := nil;
  if StructToken <> nil then
  begin
    TypeStr := StructToken.Name;
    case StructToken.Token of
      tkClass: TypeStr := 'class ' + TypeStr;
      tkEnum: TypeStr := 'enum ' + TypeStr;
      tkUnion: TypeStr := 'union ' + TypeStr;
      tkStruct: TypeStr := 'struct ' + TypeStr;
    end;
  end;
  while (FCurrent <> nil) do
  begin
    case FCurrent^.Token of
      tkxGlobalScope,
      tkxIdentifier:
        begin
          if TokenID <> nil then
          begin
            if TokenOption = nil then
            begin
              TokenOption := TokenID;
              OptionsStr := TypedefId;
            end
            else
              OptionsStr := OptionsStr + ' ' + TypedefId;
          end;
          TypedefId := GetIdentifierNoTemplate(TokenID, TokenDestr);
          TypedefId := TypedefId + TokenString(FStartPtr, TokenID);
          TokenPtrRef := nil;
          Continue;
        end;
      tkxComma,
      tkxSemicolon:
        begin
          if (TokenID = nil) then
            Exit; // error typedef ID not found
          if (TokenOption = nil) and (StructToken = nil) then // type or ID not found
            Exit;
          if TokenPtrRef <> nil then
            Exit; // error: example: int a *;
          if (TokenOption <> nil) and (TypeStr <> '') then
            OptionsStr := ' ' + OptionsStr;
          if StructToken <> nil then
          begin
            case StructToken.Token of
              tkClass: TokenType := tkTypeStruct; // TODO: TypeClass?
              tkEnum: TokenType := tkTypeEnum;
              tkUnion: TokenType := tkTypeUnion;
            else
              TokenType := tkTypeStruct;
            end;
          end
          else
            TokenType := tkTypedef;
          AddToken(TypedefId, TypeStr + OptionsStr + PtrRefStr + VectorStr,
            TokenType, TokenID^.Line, TokenID^.StartPosition,
            TokenID^.EndPosition - TokenID^.StartPosition, FLevel);
          PtrRefStr := '';
          OptionsStr := '';
          VectorStr := '';
          TokenID := nil;
          TokenOption := nil;
          TokenPtrRef := nil;
          TokenDestr := nil;
          if FCurrent^.Token = tkxSemicolon then
          begin
            Next;
            Break;
          end;
        end;
      tkxOpenParentheses: // typedef callback example: typedef int (*a)(int);
        begin
          if (TokenID = nil) then
            Exit; // error: typedef prototype return type not found
          if TokenOption = nil then
            OptionsStr := TypedefId
          else
            OptionsStr := OptionsStr + ' ' + TypedefId;
          TypedefId := '';
          Next;
          if (FCurrent = nil) or not (FCurrent^.Token in [tkxIdentifier, tkxMult]) then
            Exit; // expected (* or (ID
          TokenID := nil;
          if FCurrent^.Token = tkxIdentifier then
          begin
            TypedefId := GetIdentifierNoTemplate(TokenID, TokenDestr);
            TypedefId := TypedefId + TokenString(FStartPtr, TokenID);
            if (FCurrent = nil) then
              Exit;
          end;
          FuncPtrStr := '';
          TokenFuncPtr := nil;
          if FCurrent^.Token = tkxMult then
          begin
            TokenFuncPtr := FCurrent;
            FuncPtrStr := GetPointerReference;
          end;
          if (FCurrent = nil) or ((TokenFuncPtr <> nil) and
              (FCurrent^.Token <> tkxIdentifier)) then
            Exit; // error: (call*)
          CallStr := '';
          if FCurrent^.Token = tkxIdentifier then
          begin
            CallStr := TypedefId;
            TypedefId := GetIdentifierNoTemplate(TokenID, TokenDestr);
            TypedefId := TypedefId + TokenString(FStartPtr, TokenID);
            if (FCurrent = nil) then
              Exit;
          end;
          if FCurrent^.Token <> tkxCloseParentheses then
            Exit;
          Next;
          SaveCurrent := FCurrent;
          if (FCurrent = nil) or (FCurrent^.Token <> tkxOpenParentheses) then
            Exit;
          if not SkipPair then // params: (int, char)
            Exit;
          if (FCurrent = nil) or (FCurrent^.Token <> tkxSemicolon) then
            Exit;
          ProtoTypeToken := AddToken(TypedefId, '(' + CallStr + FuncPtrStr + '): ' +
            OptionsStr + PtrRefStr + VectorStr,
            tkTypedefProto, TokenID^.Line, TokenID^.StartPosition,
            TokenID^.EndPosition - TokenID^.StartPosition, FLevel);
          Push(ProtoTypeToken);
          AddToken('Params', '', tkParams, SaveCurrent^.Line,
            SaveCurrent^.StartPosition + 1, 0, FLevel);
          FCurrent := SaveCurrent;
          Next; // skip (
          ProcessParams;
          Pop; // pop params
          Next; // skip )
          Pop; // pop prototype
          if (FCurrent <> nil) and (FCurrent^.Token = tkxSemicolon) then
            Next;
          Exit;
        end;
      tkxOpenBrackets:
        begin
          if SkipPair then
            VectorStr := VectorStr + '[]';
          Continue;
        end;
      tkxOpenBraces:
        begin
          Break; // sintax error
        end;
      tkxMult,
      tkxBinAnd:
        begin
          TokenPtrRef := FCurrent;
          PtrRefStr := GetPointerReference;
          Continue;
        end;
    else
      Break; // error ID not found
    end;
    Next;
  end;
end;

procedure TCppParser.ProcessFields(StopLevel: Integer);
begin
  repeat
    case FCurrent^.Token of
      tkxGlobalScope,
      tkxIdentifier:
      begin
        ProcessIdentifier(True);
        Continue;
      end;
      tkxPreprocessor:
      begin
        ProcessPreprocessor;
        Continue;
      end;
      tkxOpenBraces:
      begin
        Inc(FLevel);
      end;
      tkxCloseBraces:
      begin
        ProcessCloseBraces;
      end;
    end;
    Next;
  until (FCurrent = nil) or (StopLevel = FLevel);
end;

procedure TCppParser.ProcessIdentifier(Fields: Boolean);
var
  TokenName, TokenScope, TokenDestr: PToken;
  ScopeToken, UsingToken, StructToken: TTokenClass;
  UsingName, ScopeStr: string;
begin
  if (FCurrent^.Token = tkxGlobalScope)  then
    ProcessVariableOrFunction(Fields)
  else if TokenMatch(FStartPtr, 'while', FCurrent) or 
     TokenMatch(FStartPtr, 'if', FCurrent) or 
     TokenMatch(FStartPtr, 'switch', FCurrent) then
  begin
    Next; // skip current
    if (FCurrent = nil) or (FCurrent^.Token <> tkxOpenParentheses) then
      Exit;
    SkipPair;
  end
  else if TokenMatch(FStartPtr, 'for', FCurrent) then
  begin
    Next; // skip for
    if (FCurrent = nil) or (FCurrent^.Token <> tkxOpenParentheses) then
      Exit;       
    Next; // skip (
    if (FCurrent = nil) then
      Exit;
  end
  else if TokenMatch(FStartPtr, 'else', FCurrent) then
  begin
    Next; // skip else
  end
  else if TokenMatch(FStartPtr, 'case', FCurrent) then
  begin
    Next; // skip ;
  end 
  else if TokenMatch(FStartPtr, 'default', FCurrent) then
  begin
    Next; // skip ;
  end
  else if TokenMatch(FStartPtr, 'private', FCurrent) or 
          TokenMatch(FStartPtr, 'public', FCurrent) or 
          TokenMatch(FStartPtr, 'protected', FCurrent) then
  begin       
    ScopeStr := TokenString(FStartPtr, FCurrent);
    Next;
    // get scope from parent struct
    ScopeToken := nil;
    if (Top <> nil) and Assigned(Top.Parent) and (Top.Parent.Token in [tkClass, tkStruct, tkUnion]) then
      ScopeToken := GetTokenByName(Top.Parent, ScopeStr, tkScopeClass)
    else if (Top <> nil) and (Top.Token in [tkClass, tkStruct, tkUnion]) then
      ScopeToken := GetTokenByName(Top, ScopeStr, tkScopeClass);
                                { already on stack }
    if Assigned(ScopeToken) and (Top <> ScopeToken) then
    begin
      // swap scope
      Pop;
      Push(ScopeToken);
    end;
    if (FCurrent <> nil) or (FCurrent^.Token = tkxColon) then
      Next; // skip :
  end
  else if TokenMatch(FStartPtr, 'struct', FCurrent) then
  begin
    ProcessStruct(tkStruct);
    if (FCurrent = nil) or (FCurrent^.Token <> tkxSemicolon) then
      Exit;
    Next; // skip ;
  end
  else if TokenMatch(FStartPtr, 'class', FCurrent) then
  begin
    ProcessStruct(tkClass);
    if (FCurrent = nil) or (FCurrent^.Token <> tkxSemicolon) then
      Exit;
    Next; // skip ;
  end
  else if TokenMatch(FStartPtr, 'union', FCurrent) then
  begin
    ProcessStruct(tkUnion);
    if (FCurrent = nil) or (FCurrent^.Token <> tkxSemicolon) then
      Exit;
    Next; // skip ;
  end
  else if TokenMatch(FStartPtr, 'enum', FCurrent) then
  begin

    Next; // skip
  end
  else if TokenMatch(FStartPtr, 'typedef', FCurrent) then
  begin
    Next; // skip typedef
    if FCurrent = nil then
      Exit;
    StructToken := nil;
    if TokenMatch(FStartPtr, 'struct', FCurrent) then
      StructToken := ProcessStruct(tkStruct)
    else if TokenMatch(FStartPtr, 'class', FCurrent) then
      StructToken := ProcessStruct(tkClass)
    else if TokenMatch(FStartPtr, 'union', FCurrent) then
      StructToken := ProcessStruct(tkUnion);
    ProcessTypedef(StructToken);
  end
  else if TokenMatch(FStartPtr, 'template', FCurrent) then
  begin
    Next; // skip template
    SkipTemplate;
  end
  else if not Fields and TokenMatch(FStartPtr, 'namespace', FCurrent) then
  begin
    Next; //< skip namespace
    if (FCurrent <> nil) and (FCurrent^.Token <> tkxIdentifier) then
      Exit;
    TokenName := FCurrent;
    Next; //< skip identifier
    while (FCurrent <> nil) and (FCurrent^.Token <> tkxOpenBraces) do
    begin
      if (FCurrent^.Token in [tkxOpenParentheses, tkxOpenBrackets]) then
      begin
        SkipPair;
        Continue;
      end;
      Next;
    end;
    if (FCurrent = nil) then
      Exit;
    AddToken(TokenString(FStartPtr, TokenName), '', tkNamespace, TokenName^.Line,
      TokenName^.StartPosition, TokenName^.EndPosition - TokenName^.StartPosition, FLevel);
    AddToken('Scope', '', tkScope, FCurrent^.Line, FCurrent^.StartPosition + 1, 0, FLevel);
  end
  else if not Fields and TokenMatch(FStartPtr, 'extern', FCurrent) then
  begin

    Next; // skip
  end 
  else if not Fields and TokenMatch(FStartPtr, 'delete', FCurrent) then
  begin

    Next; // skip
  end 
  else if not Fields and TokenMatch(FStartPtr, 'new', FCurrent) then
  begin

    Next; // skip
  end
  else if TokenMatch(FStartPtr, 'using', FCurrent) then
  begin                                     
    Next; // skip
    TokenScope := FCurrent;
    ScopeStr := GetIdentifierNoTemplate(TokenName, TokenDestr);
    UsingName := TokenString(FStartPtr, TokenName);
    if TokenName = nil then
      Exit;
    UsingToken := AddToken(UsingName, '', 
      tkUsing, TokenName^.Line, TokenName^.StartPosition,
      TokenName^.EndPosition - TokenName^.StartPosition, FLevel);
    if (Length(ScopeStr) > 0) and (TokenScope <> nil) then
    begin
      Push(UsingToken);
      AddToken('Scope', Trim(#0, ScopeStr, ':'), tkScope, TokenScope^.Line,
        TokenScope^.StartPosition, 0, FLevel);
      Pop;
    end;
    if (FCurrent <> nil) or (FCurrent^.Token = tkxSemicolon) then
      Next; // skip ;
  end
  else
  begin
    ProcessVariableOrFunction(Fields);
  end;
end;

procedure TCppParser.ProcessCloseBraces;
var
  lastFunc, scopeClass: TTokenClass;
begin
  if FLevel > 0 then
    Dec(FLevel);
  if StackLevel <> FLevel then
    Exit;
  lastFunc := Pop; //remove top item
  if not Assigned(lastFunc) then
    Exit;
  if (lastFunc.Token in [tkFunction, tkConstructor, tkNamespace,
    tkDestructor, tkOperator]) and (lastFunc.Count > 1) then
  begin
    scopeClass := GetTokenByName(lastFunc, 'Scope', tkScope);
    if Assigned(scopeClass) then
      scopeClass.SelLength := FCurrent^.StartPosition - scopeClass.SelStart;
  end;
  if Empty or (lastFunc.Token <> tkScopeClass) then
    Exit;
  lastFunc := Pop;
  if not (lastFunc.Token in [tkClass, tkStruct, tkUnion]) then
    Exit;
  scopeClass := GetTokenByName(lastFunc, 'private', tkScopeClass);
  if Assigned(scopeClass) and (scopeClass.Count = 0) then
    lastFunc.Remove(scopeClass);
  scopeClass := GetTokenByName(lastFunc, 'protected', tkScopeClass);
  if Assigned(scopeClass) and (scopeClass.Count = 0) then
  begin
    lastFunc.Remove(scopeClass);
  end;
  scopeClass := GetTokenByName(lastFunc, 'public', tkScopeClass);
  if Assigned(scopeClass) and (scopeClass.Count = 0) then
    lastFunc.Remove(scopeClass);
  scopeClass := GetTokenByName(lastFunc, 'Scope', tkScope);
  if Assigned(scopeClass) then
    scopeClass.SelLength := FCurrent^.StartPosition - scopeClass.SelStart;
end;

function TCppParser.Parse(const Src: string; TokenFile: Pointer): Boolean;
begin
  fBusy := True;
  fTokenFile := TokenFile;
  Clear;
  FStartPtr := PChar(Src);
  FFirst := StartTokenizer(FStartPtr);
  FCurrent := FFirst;
  if FCurrent <> nil then
  begin
    repeat
      case FCurrent^.Token of
        tkxPreprocessor:
          begin
            ProcessPreprocessor;
            Continue;
          end;       
        tkxGlobalScope,
        tkxIdentifier:
          begin
            ProcessIdentifier(False);
            Continue;
          end;
        tkxOpenBraces:
        begin
          Inc(FLevel);
        end;
        tkxCloseBraces:
        begin
          ProcessCloseBraces;
        end;
      end;
      Next;
    until (FCurrent = nil) or fCancel;
  end;
  FreeTokens(FFirst);
  Result := not fCancel;
  fBusy := False;
end;

function TCppParser.AddToken(const S, Flag: string; TkType: TTkType; Line, Start,
  Len, Level: Integer): TTokenClass;
var
  TokenClass: TTokenClass;
begin
  if not Empty and not (TkType in [tkInclude, tkDefine]) then
  begin
    TokenClass := Top;
  end
  else
  begin
    TokenClass := nil;
    case TkType of
      tkInclude: 
        TokenClass := TTokenFile(fTokenFile).Includes;
      tkDefine: 
        TokenClass := TTokenFile(fTokenFile).Defines;
      tkTypedef, 
      tkTypedefProto, 
      tkClass, 
      tkStruct, 
      tkTypeStruct, 
      tkEnum,
      tkTypeEnum, 
      tkUnion, 
      tkTypeUnion, 
      tkScopeClass, 
      tkNamespace:
        TokenClass := TTokenFile(fTokenFile).TreeObjs;
      tkVariable, 
      tkUnknow, 
      tkForward, 
      tkUsing, 
      tkEnumItem:
        TokenClass := TTokenFile(fTokenFile).VarConsts;
      tkPrototype, 
      tkFunction, 
      tkConstructor, 
      tkDestructor, 
      tkOperator:
        TokenClass := TTokenFile(fTokenFile).FuncObjs;
    end;
  end;     
  Result := TTokenClass.Create(TokenClass);
  Result.Fill(Line, Len, Start, Level, TkType, S, Flag, FComment);
  if TkType = tkDefine then
    fPrev := Result; 
  if (fRightComment <> '') and Assigned(fPrev) then
  begin
    if fPrev.Comment = '' then
      fPrev.Comment := fRightComment
    else if (fOpenCommentCount > 0) then
      fPrev.Comment := fPrev.Comment + #13 + fRightComment;
    fRightComment := '';
  end;
  fPrev := Result;
  if fOpenCommentCount = 0 then
    FComment := '';
  if TokenClass <> nil then
    TokenClass.Add(Result);
  if TkType in [tkStruct, tkUnion, tkEnum, tkFunction, tkConstructor, tkParams,
    tkDestructor, tkOperator, tkNamespace, tkClass, tkOperator] then
  begin
    Push(Result);
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
  fPrev := nil;
  FLevel := 0;
  fCancel := False;
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
