unit TokenUtils;

interface

uses
  TokenList, SysUtils, Classes, TokenConst, TokenFile, Dialogs;

function GetFuncScope(Token: TTokenClass; AddSeparator: Boolean = True): string;
function GetFuncProto(Token: TTokenClass; GenName: Boolean = False): string;
function GetStructProto(Token: TTokenClass; GenName: Boolean = False): string;
function GetFuncProtoTypes(Token: TTokenClass): string;
procedure GetStringsFields(const S: string; List: TStrings;
  IgnoreFirst: Boolean = True);
function GetTreeHierarchy(Token: TTokenClass; AddScope: Boolean = True;
  Recursive: Boolean = False): string;
//make hint
function MakeTokenHint(Token: TTokenClass; const FileName: string): string;
function MakeTokenParamsHint(Token: TTokenClass): string;
//completion list
procedure FillCompletionTree(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; Images: array of Integer;
  ScopeClass: TScopeClassState = []; IncludeParams: Boolean = False);
procedure FillCompletionTreeNoRepeat(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; Images: array of Integer;
  TokenList: TTokenList; ScopeClass: TScopeClassState = [];
  IncludeParams: Boolean = False; UseList: Boolean = False);
function CompletionShowItem(Token: TTokenClass; CompletionColors: TCompletionColors;
  Images: array of Integer): string;
function CompletionInsertItem(Token: TTokenClass): string;

//params
function CommaCountAt(const S: string; Init: Integer): Integer;
function CountCommas(const S: string): Integer;
function CountChar(const S: string; ch: Char): Integer;
function GetParamsBefore(const S: string; Index: Integer): string;
function GetActiveParams(const S: string; Index: Integer): string;
function GetParamsAfter(const S: string; Index: Integer): string;

//strings
function GetLeftSpacing(CharCount, TabWidth: Integer; WantTabs: Boolean): string;
function GetFirstWord(const S: string): string;
function GetAfterWord(const S: string): string;
procedure GetDescendants(const S: string; List: TStrings; scope: TScopeClass);
function GetLastWord(const S: string; AllowScope: Boolean = False): string;
function GetPriorWord(const S: string): string;
function GetLastChar(const S: string): Char;
function GetOperator(const S: string): string;
function SkipTemplateParams(const ret: string): string;
function GetVarType(Token: TTokenClass): string;
function Trim(Left: Char; const S: string; Rigth: Char): string; overload;
function StringToScopeClass(const S: string): TScopeClass;
function StringIn(const S: string; List: array of string): Boolean;
function CountWords(const S: string): Integer;

function GetTokenByName(Token: TTokenClass; const Name: string;
  tokenType: TTkType): TTokenClass;

//others
function HasTODO(const S: string): Boolean;
procedure GetDiffFunction(const ClassFuncList, FuncList: TStrings;
  DiffFuncList: TStrings);
function GeneratePrototype(func: TTokenClass; TabWidth: Integer; WantTabs,
  JavaStyle: Boolean; OverrideLevel: Integer = -1): string;
procedure InsertFunction(func: TTokenClass; Source: TStrings;
  var StartLine: Integer; TabWidth: Integer; WantTabs, JavaStyle: Boolean;
  Prototype: Boolean = False; OverrideLevel: Integer = -1;
  ExcludeScope: Boolean = False);
procedure GenerateFunctions(TokenFile: TTokenFile; Source: TStrings;
  StartLine, TabWidth: Integer; WantTabs, JavaStyle: Boolean);
procedure GenerateFunctionPrototype(TokenFile: TTokenFile; Source: TStrings;
  StartLine: Integer; AddNameParams: Boolean = True);
function GetTokenImageIndex(Token: TTokenClass; Images: array of Integer): Integer;
function FileDateTime(const FileName: string): TDateTime;
function IsNumber(const S: string): Boolean;
function ScopeInState(const S: string; ScopeClass: TScopeClassState): Boolean;
function ConvertSlashes(const Path: string): string;
function ConvertToUnixSlashes(const Path: string): string;
function GetFirstOpenParentheses(const S: string; QuoteChar: Char;
  var SelStart: Integer): Boolean;
function GetFirstOpenBracket(const S: string; QuoteChar: Char;
  var BracketStart, VarEnd: Integer; var StructParams: string): Boolean;
function ParseFields(const Text: string; SelStart: Integer;
  var S, Fields: string; var InputError: Boolean): Boolean;
function GetNextValidChar(const Text: string; SelStart: Integer): Char;

implementation

function FileDateTime(const FileName: string): TDateTime;
begin
  FileAge(FileName, Result);
end;

function GeneratePrototype(func: TTokenClass; TabWidth: Integer; WantTabs,
  JavaStyle: Boolean; OverrideLevel: Integer): string;
var
  S: TStrings;
  StartLine: Integer;
begin
  S := TStringList.Create;
  StartLine := 0;
  InsertFunction(func, S, StartLine, TabWidth, WantTabs, JavaStyle, True,
    OverrideLevel, True);
  Result := S.Strings[0];
  S.Free;
end;

procedure InsertFunction(func: TTokenClass; Source: TStrings;
  var StartLine: Integer; TabWidth: Integer; WantTabs, JavaStyle,
  Prototype: Boolean; OverrideLevel: Integer; ExcludeScope: Boolean);
var
  S, FuncImp, IndentStr, Scope, RetValue, FuncRet: string;
  Level: Integer;
begin
  if not (func.Token in [tkFunction, tkPrototype, tkConstructor,
    tkDestructor, tkOperator]) then
    Exit;
  Scope := '';
  S := func.Name + '(' + GetFuncProto(func, True) + ')';
  if OverrideLevel >= 0 then
    Level := OverrideLevel
  else
    Level := func.Level;
  IndentStr := GetLeftSpacing(TabWidth * Level, TabWidth, WantTabs);
  if Assigned(func.Parent) and Assigned(func.Parent.Parent) and
    (func.Parent.Parent.Token = tkClass) and not ExcludeScope then
  begin
    IndentStr := GetLeftSpacing(TabWidth * (Level - 1), TabWidth, WantTabs);
    if func.Token in [tkDestructor] then
      Scope := func.Parent.Parent.Name + '::~'
    else
      Scope := func.Parent.Parent.Name + '::';
    FuncRet := func.Flag;
    if (Pos('virtual', FuncRet) = 1) then
      FuncRet := Trim(Copy(FuncRet, 8, Length(FuncRet) - 7))
    else if Pos('static', FuncRet) = 1 then
      FuncRet := Trim(Copy(FuncRet, 7, Length(FuncRet) - 6));
  end
  else
    FuncRet := func.Flag;
  if func.Token = tkOperator then
    Scope := Scope + 'operator ';
  FuncImp := IndentStr + Trim(FuncRet + ' ' + Scope + S);
  if Prototype then
  begin
    Source.Insert(StartLine, FuncImp + ';');
    Inc(StartLine);
    Exit;
  end;
  if JavaStyle then
    Source.Insert(StartLine, FuncImp + ' {')
  else
  begin
    Source.Insert(StartLine, FuncImp);
    Inc(StartLine);
    Source.Insert(StartLine, IndentStr + '{');
  end;
  Inc(StartLine);
  Source.Insert(StartLine, IndentStr + GetLeftSpacing(TabWidth, TabWidth, WantTabs) +
    '//TODO Generated function');
  Inc(StartLine);
  S := GetVarType(func);
  if (S <> '') and ((S <> 'void') or (Pos('*', func.Flag) > 0)) then
  begin
    RetValue := '0';
    if Pos('*', func.Flag) > 0 then
      RetValue := 'NULL'
    else if S = 'bool' then
      RetValue := 'false'
    else if S = 'string' then
      RetValue := '""';
    Source.Insert(StartLine, IndentStr + GetLeftSpacing(TabWidth, TabWidth, WantTabs) +
      'return ' + RetValue + ';');
    Inc(StartLine);
  end;
  Source.Insert(StartLine, IndentStr + '}');
  Inc(StartLine);
end;

procedure GetDiffFunction(const ClassFuncList, FuncList: TStrings;
  DiffFuncList: TStrings);

var
  TempFuncList: TStrings;
  I, J: Integer;
  TkFunc1, TkFunc2: TTokenClass;
  tkp1, tkp2: TTokenClass;
begin
  for I := 0 to ClassFuncList.Count - 1 do
    DiffFuncList.AddObject('class', ClassFuncList.Objects[I]);
  TempFuncList := TStringList.Create;
  TempFuncList.AddStrings(FuncList);
  for I := DiffFuncList.Count - 1 downto 0 do
  begin
    TkFunc1 := TTokenClass(DiffFuncList.Objects[I]);
    for J := TempFuncList.Count - 1 downto 0 do
    begin
      TkFunc2 := TTokenClass(TempFuncList.Objects[J]);
      if (TkFunc1.Name = TkFunc2.Name) then
      begin
        tkp1 := GetTokenByName(TkFunc1, 'Params', tkParams);
        tkp2 := GetTokenByName(TkFunc2, 'Params', tkParams);
        if tkp1.Count = tkp2.Count then
        begin
          DiffFuncList.Delete(I);
          TempFuncList.Delete(J);
          Break;
        end;
      end;
    end;
  end;
  for I := 0 to TempFuncList.Count - 1 do
    DiffFuncList.AddObject('func', TempFuncList.Objects[I]);
  TempFuncList.Free;
end;

procedure GenerateFunctions(TokenFile: TTokenFile; Source: TStrings;
  StartLine, TabWidth: Integer; WantTabs, JavaStyle: Boolean);

  procedure GenerateGroup(Item: TTokenClass; var InsertLine: Integer);
  var
    IndentStr: string;
    I: Integer;
    FuncValue: TTokenClass;
  begin
    IndentStr := GetLeftSpacing(TabWidth * Item.Level, TabWidth, WantTabs);
    if Item.Token = tkNamespace then
    begin
      Source.Insert(InsertLine, IndentStr + 'namespace ' + Item.Name);
      Inc(InsertLine);
      Source.Insert(InsertLine, IndentStr + '{');
      Inc(InsertLine);
    end;
    for I := 0 to Item.Count - 1 do
    begin
      if not (Item.Items[I].Token in [tkClass, tkNamespace, tkScopeClass]) then
      begin
        if Item.Items[I].Token in [tkPrototype, tkConstructor, tkDestructor] then
        begin
          if Pos('virtual', Item.Items[I].Flag) > 0 then
          begin
            FuncValue := GetTokenByName(Item.Items[I], 'Value', tkValue);
            if FuncValue <> nil then
              Continue;
          end;
          InsertFunction(Item.Items[I], Source, InsertLine, TabWidth,
            WantTabs, JavaStyle);
          if I < Item.Count - 1 then
          begin
            Source.Insert(InsertLine, '');
            Inc(InsertLine);
          end;
        end;
        Continue;
      end;
      GenerateGroup(Item.Items[I], InsertLine);
    end;
    if Item.Token = tkNamespace then
    begin
      Source.Insert(InsertLine, IndentStr + '}');
      Inc(InsertLine);
    end;
  end;

var
  I: Integer;
  Item: TTokenClass;
  InsertLine: Integer;
begin
  InsertLine := StartLine;
  Item := TokenFile.FuncObjs;
  for I := 0 to Item.Count - 1 do
  begin
    if not (Item.Items[I].Token in [tkPrototype]) then
      Continue;
    InsertFunction(Item.Items[I], Source, InsertLine, TabWidth, WantTabs, JavaStyle);
    Source.Insert(InsertLine, '');
    Inc(InsertLine);
  end;
  Item := TokenFile.TreeObjs;
  for I := 0 to Item.Count - 1 do
  begin
    if not (Item.Items[I].Token in [tkClass, tkNamespace]) then
      Continue;
    GenerateGroup(Item.Items[I], InsertLine);
  end;
end;

procedure GenerateFunctionPrototype(TokenFile: TTokenFile; Source: TStrings;
  StartLine: Integer; AddNameParams: Boolean);
var
  I: Integer;
  Scope, SearchItem, Item: TTokenClass;
  S, FuncImp, Indentation, LastClass, Tilde: string;
  InsertLine: Integer;
  PrototypeList: TStrings;
  HasClass: Boolean;
begin
  PrototypeList := TStringList.Create;
  InsertLine := StartLine;
  Item := TokenFile.FuncObjs;
  Indentation := '';
  LastClass := '';
  Tilde := '';
  HasClass := False;
  for I := 0 to Item.Count - 1 do
  begin
    if (Item.Items[I].Token in [tkPrototype, tkOperator]) or
      ((Item.Items[I].Token in [tkFunction]) and
      (Pos('static', Item.Items[I].Flag) > 0)) then
    begin
      S := Item.Items[I].Name + GetFuncProtoTypes(Item.Items[I]);
      if Item.Items[I].Token = tkOperator then
        S := 'operator ' + S;
      PrototypeList.AddObject(S, Item.Items[I]);
      Continue;
    end;
    if ((Item.Items[I].Token in [tkFunction, tkConstructor, tkDestructor, tkOperator]) and
      (Pos('static', Item.Items[I].Flag) = 0)) then
    begin
      S := GetFuncProtoTypes(Item.Items[I]);
      if PrototypeList.IndexOf(S) >= 0 then
        Continue;
      Scope := GetTokenByName(Item.Items[I], 'Scope', tkScope);
      //if not Assigned(Scope) then
      //  Continue;
      if (Scope.Flag <> '') and not
        TokenFile.SearchToken(Scope.Flag, '', SearchItem, Scope.SelStart,
        False, [tkClass]) then
      begin
        if HasClass and (LastClass <> Scope.Flag) then
        begin
          Source.Insert(InsertLine, '};');
          Inc(InsertLine);
          Source.Insert(InsertLine, '');
          Inc(InsertLine);
        end;
        if LastClass <> Scope.Flag then
        begin
          Source.Insert(InsertLine, 'class ' + Scope.Flag);
          Inc(InsertLine);
          Source.Insert(InsertLine, '{');
          Inc(InsertLine);
          Source.Insert(InsertLine, '');
        end;
        LastClass := Scope.Flag;
        HasClass := True;
        Indentation := '    ';
        Tilde := '';
        if Item.Items[I].Token = tkDestructor then
        begin
          Tilde := '~';
          S := Tilde + S;
        end;
      end
      else
      begin
        if HasClass then
        begin
          Source.Insert(InsertLine, '};');
          Inc(InsertLine);
          Source.Insert(InsertLine, '');
          Inc(InsertLine);
          HasClass := False;
          Indentation := '';
        end;
        Tilde := '';
      end;
      if AddNameParams then
        S := Tilde + Item.Items[I].Name + '(' + GetFuncProto(Item.Items[I]) + ')';
      FuncImp := Indentation + Trim(Item.Items[I].Flag + ' ' + S) + ';';
      Source.Insert(InsertLine, FuncImp);
      Inc(InsertLine);
    end;
  end;
  if HasClass then
  begin
    Source.Insert(InsertLine, '};');
    Inc(InsertLine);
    Source.Insert(InsertLine, '');
  end;
  PrototypeList.Free;
end;

function GetTokenImageIndex(Token: TTokenClass; Images: array of Integer): Integer;
begin
  case Token.Token of
    tkIncludeList: Result := 0;
    tkDefineList: Result := 2;
    tkTreeObjList: Result := 13;
    tkVarConsList: Result := 4;
    tkFuncProList: Result := 8;
    tkClass:
      begin
        Result := 14;
      end;
    tkFunction:
      begin
        if Assigned(Token.Parent) and (Token.Parent.Token = tkScopeClass) then
        begin
          if Token.Parent.Name = 'private' then
            Result := 10
          else if Token.Parent.Name = 'protected' then
            Result := 11
          else
            Result := 9;
        end
        else
          Result := 9;
      end;
    tkPrototype:
      begin
        if Assigned(Token.Parent) and (Token.Parent.Token = tkScopeClass) then
        begin
          if Token.Parent.Name = 'private' then
            Result := 10
          else if Token.Parent.Name = 'protected' then
            Result := 11
          else
            Result := 12;
        end
        else
          Result := 12;
      end;
    tkOperator:
      begin
        if GetTokenByName(Token, 'Scope', tkScope) <> nil then
          Result := 9
        else
          Result := 12;
      end;
    tkInclude:
      begin
        Result := 1;
      end;
    tkDefine:
      begin
        Result := 3;
      end;
    tkVariable:
      begin
        if Assigned(Token.Parent) and (Token.Parent.Token = tkScopeClass) then
        begin
          if Token.Parent.Name = 'private' then
            Result := 6
          else if Token.Parent.Name = 'protected' then
            Result := 7
          else
            Result := 5;
        end
        else
          Result := 5;
      end;
    tkTypedef:
      begin
        Result := 19;
      end;
    tkTypedefProto:
      begin
        Result := 24;
      end;
    tkStruct:
      begin
        Result := 15;
      end;
    tkTypeStruct:
      begin
        Result := 20;
      end;
    tkEnum:
      begin
        Result := 17;
      end;
    tkTypeEnum:
      begin
        Result := 22;
      end;
    tkEnumItem:
      begin
        Result := 23;
      end;
    tkUnion:
      begin
        Result := 16;
      end;
    tkTypeUnion:
      begin
        Result := 21;
      end;
    tkNamespace:
      begin
        Result := 18;
      end;
    tkConstructor:
      begin
        Result := 25;
      end;
    tkDestructor:
      begin
        Result := 26;
      end;
    tkCodeTemplate:
      begin
        if Token.Flag = '' then
          Result := 28
        else
          Result := 27;
      end;
  else
    Result := 0;
  end;
  if (Result >= Low(Images)) and (Result <= High(Images)) and
    (Length(Images) > 0) then
    Result := Images[Result];
end;

function GetFuncScope(Token: TTokenClass; AddSeparator: Boolean): string;
var
  Scope: TTokenClass;
begin
  Result := '';
  if not (Token.Token in [tkFunction, tkPrototype, tkConstructor, tkDestructor,
    tkOperator])
    or (Assigned(Token.Parent) and (Token.Token in [tkFuncProList])) then
    Exit;
  Scope := GetTokenByName(Token, 'Scope', tkScope);
  if not Assigned(Scope) then
    Exit;
  Result := Scope.Flag;
  if (Length(Result) > 0) and AddSeparator then
    Result := Result + '::';
  Result := Result;
end;

function GetFuncProto(Token: TTokenClass; GenName: Boolean): string;
var
  I, X, VarNum, Len: Integer;
  Params: TTokenClass;
  TypeName, Vector, Sep, ParamName, BraceOpen, BraceClose: string;
begin
  Result := '';
  Sep := '';
  VarNum := 1;
  if not (Token.Token in [tkTypedefProto, tkFunction, tkPrototype,
    tkConstructor, tkDestructor, tkOperator]) then
    Exit;
  Params := GetTokenByName(Token, 'Params', tkParams);
  if not Assigned(Params) then
    Exit;
  for I := 0 to Params.Count - 1 do
  begin
    TypeName := Params.Items[I].Flag;
    X := Pos('[', TypeName);
    Len := Length(TypeName);
    Vector := '';
    if X > 0 then
    begin
      Vector := Copy(TypeName, X, Len - X + 1);
      TypeName := Copy(TypeName, 1, X - 1);
    end;
    ParamName := Params.Items[I].Name;
    BraceOpen := '';
    BraceClose := '';
    if (ParamName = '') and GenName then
    begin
      ParamName := 'var' + IntToStr(VarNum);
      Inc(VarNum);
    end
    else if Params.Items[I].Count = 1 then
    begin
      BraceOpen := '[';
      BraceClose := ']';
    end;
    Result := Result + Sep + BraceOpen + Trim(TypeName + ' ' + ParamName + Vector) + BraceClose;
    Sep := ', ';
  end;
  Result := Trim(Result);
end;

function GetStructProto(Token: TTokenClass; GenName: Boolean): string;
var
  I, X, VarNum, Len: Integer;
  Params: TTokenClass;
  TypeName, Vector, Sep, ParamName, BraceOpen, BraceClose: string;
begin
  Result := '';
  Sep := '';
  VarNum := 1;
  if not (Token.Token in StructTokens) or (Token.Count < 2) then
    Exit;
  Params := Token.Items[1];
  for I := 0 to Params.Count - 1 do
  begin
    if Params.Items[I].Token <> tkVariable then
      Continue;
    TypeName := Params.Items[I].Flag;
    X := Pos('[', TypeName);
    Len := Length(TypeName);
    Vector := '';
    if X > 0 then
    begin
      Vector := Copy(TypeName, X, Len - X + 1);
      TypeName := Copy(TypeName, 1, X - 1);
    end;
    ParamName := Params.Items[I].Name;
    BraceOpen := '';
    BraceClose := '';
    if (ParamName = '') and GenName then
    begin
      ParamName := 'var' + IntToStr(VarNum);
      Inc(VarNum);
    end
    else if Params.Items[I].Count = 1 then
    begin
      BraceOpen := '[';
      BraceClose := ']';
    end;
    Result := Result + Sep + BraceOpen + Trim(TypeName + ' ' + ParamName + Vector) + BraceClose;
    Sep := ', ';
  end;
  Result := Trim(Result);
end;

function HasTODO(const S: string): Boolean;
const
  TodoStr = 'TODO';
var
  ptr: PChar;
  I: Integer;
begin
  Result := False;
  ptr := PChar(S);
  while CharInSet(ptr^, SpaceChars) do
    Inc(ptr);
  if (ptr^ = '/') and ((ptr + 1)^ = '/') then
  begin
    Inc(ptr, 2);
    while CharInSet(ptr^, SpaceChars) do
      Inc(ptr);
    I := 1;
    while (ptr^ <> #0) and (I < 5) and (ptr^ = TodoStr[I]) do
    begin
      Inc(I);
      Inc(ptr);
    end;
    Result := (I = 5);
  end;
end;

function GetFuncProtoTypes(Token: TTokenClass): string;
var
  I, X, Len: Integer;
  Params: TTokenClass;
  TypeName, Vector, Sep: string;
begin
  Result := '';
  Sep := '';
  if not (Token.Token in [tkFunction, tkPrototype, tkOperator, tkConstructor,
    tkDestructor]) then
    Exit;
  Params := GetTokenByName(Token, 'Params', tkParams);
  if not Assigned(Params) then
    Exit;
  for I := 0 to Params.Count - 1 do
  begin
    TypeName := Params.Items[I].Flag;
    X := Pos('[', TypeName);
    Len := Length(TypeName);
    Vector := '';
    if X > 0 then
      Vector := Copy(TypeName, X, Len - X + 1);
    if TypeName = '' then
      TypeName := Params.Items[I].Name;
    Result := Result + Sep + TypeName;
    Sep := ', ';
  end;
  Result := '(' + Trim(Result) + ')';
end;

function ScopeInState(const S: string; ScopeClass: TScopeClassState): Boolean;
begin
  Result := False;
  if S = 'private' then
    Result := scPrivate in ScopeClass
  else if S = 'protected' then
    Result := scProtected in ScopeClass
  else if S = 'public' then
    Result := scPublic in ScopeClass;
end;

procedure FillCompletionTree(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; Images: array of Integer;
  ScopeClass: TScopeClassState; IncludeParams: Boolean);
begin
  FillCompletionTreeNoRepeat(InsertList, ShowList, Token, SelStart,
    CompletionColors, Images, nil, ScopeClass, IncludeParams, False);
end;

procedure FillCompletionTreeNoRepeat(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; Images: array of Integer;
  TokenList: TTokenList; ScopeClass: TScopeClassState; IncludeParams: Boolean;
  UseList: Boolean);
var
  I: Integer;
  NewToken: TTokenClass;
begin
  for I := 0 to Token.Count - 1 do
  begin
    if (SelStart >= 0) and (Token.Items[I].SelStart > SelStart) then
      Exit;
    if (Token.Items[I].Name = '') or (Token.Items[I].Token in [tkScope, tkUsing,
      tkFriend, tkForward]) or ((Token.Items[I].Token in [tkParams]) and
      not IncludeParams) then
    begin
      Continue;
    end;
    if not (Token.Items[I].Token in [tkParams, tkScopeClass]) then
    begin
      if UseList and Assigned(TokenList) then
      begin
        if TokenList.Exist(Token.Items[I]) then
          Continue;
      end;
      NewToken := Token.Items[I];
      if UseList and Assigned(TokenList) then
        TokenList.Add(NewToken);
      if Assigned(InsertList) then
        InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      if Assigned(ShowList) then
        ShowList.AddObject(CompletionShowItem(NewToken, CompletionColors, Images), NewToken);
    end;
    if not IncludeParams and not (Token.Items[I].Token in [tkScopeClass]) then
      Continue;
    if Token.Items[I].Token = tkScopeClass then
    begin
      if not ScopeInState(Token.Items[I].Name, ScopeClass) and
        not (ScopeClass = []) then
        Continue;
    end;
    case Token.Items[I].Token of
      tkClass, tkFunction, tkOperator, tkConstructor, tkDestructor, tkStruct, tkUnion,
        tkEnum, tkTypeStruct, tkTypeUnion, tkTypeEnum, tkParams,
        tkScopeClass, tkNamespace:
        FillCompletionTreeNoRepeat(InsertList, ShowList,
          Token.Items[I], SelStart, CompletionColors, Images, TokenList,
          ScopeClass, False, UseList);
    end;
  end;
end;

function CompletionShowItem(Token: TTokenClass;
  CompletionColors: TCompletionColors; Images: array of Integer): string;
var
  TypeName, Params, S: string;
  I, IEnd, Len: Integer;
begin
  Result := '';
  case Token.Token of
    tkClass:
      begin
        if Length(Token.Flag) > 0 then
          Result := CompletionColors[Token.Token] + Token.Name +
            '\style{-B} : class(' + GetLastWord(Token.Flag) + ')'
        else
          Result := CompletionColors[Token.Token] + Token.Name +
            '\style{-B} : class';
      end;
    tkFunction, tkPrototype, tkOperator:
      begin
        S := GetFuncProto(Token);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '(\color{clBlack}' + S + ') : \color{clBlack}' + Token.Flag;
      end;
    tkConstructor:
      begin
        S := GetFuncProto(Token);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '(\color{clBlack}' + S + ')';
      end;
    tkDestructor:
      begin
        S := GetFuncProto(Token);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '(\color{clBlack}' + S + ')';
      end;
    tkDefine:
      begin
        if Length(Token.Flag) > 0 then
          Result := CompletionColors[Token.Token] + Token.Name +
            '\style{-B} : ' + Trim(Token.Flag)
        else
          Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}';
      end;
    tkInclude:
      begin
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}';
      end;
    tkVariable:
      begin
        I := Pos('[', Token.Flag);
        Len := Length(Token.Flag);
        TypeName := Token.Flag;
        Params := '';
        if I > 0 then
        begin
          Params := Copy(Token.Flag, I, Len - I + 1);
          TypeName := Copy(Token.Flag, 1, I - 1);
          I := Length(Params);
          if Length(Params) > 2 then
          begin
            Params := Copy(Params, 2, I - 2);
            Params := '[\color{clBlack}' + Params + ']\color{clBlack}';
          end;
        end;

        S := CompletionColors[Token.Token];
        if GetFirstWord(TypeName) = 'const' then
        begin
          S := CompletionColors[TTkType(17)];
          TypeName := GetAfterWord(TypeName);
        end;
        Result := S + Token.Name + '\style{-B}' + Params + ' : ' + TypeName;
      end;
    tkTypedef, tkTypeStruct, tkTypeUnion, tkTypeEnum:
      begin
        S := ';';
        if Length(Token.Flag) > 0 then
          S := ' : ' + Token.Flag;
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' + S;
      end;
    tkTypedefProto:
      begin
        S := GetFuncProto(Token);
        I := Pos('(', Token.Flag);
        IEnd := Pos(')', Token.Flag);
        Len := IEnd - I - 1;
        Params := Copy(Token.Flag, I + 1, Len);
        I := Pos(':', Token.Flag);
        TypeName := Copy(Token.Flag, I + 1, Length(Token.Flag) - I);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '(\color{clBlack}' + Params + ')(\color{clBlack}' + S +
          ') : \color{clBlack}' + TypeName;
      end;
    tkStruct:
      begin
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B} : struct';
      end;
    tkEnum:
      begin
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B} : enum';
      end;
    tkUnion:
      begin
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B} : union';
      end;
    tkNamespace:
      begin
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}';
      end;
    tkEnumItem:
      begin
        S := '';
        if Length(Token.Flag) > 0 then
          S := ' : ' + Token.Flag;
        Result := CompletionColors[TTkType(17)] + Token.Name + '\style{-B}' + S;
      end;
    tkUnknow: Result := CompletionColors[Token.Token] +
      Token.Name + '\style{-B}' + ' : ' + Token.Flag;
    tkForward:
      begin
        if Token.Flag = 'struct' then
          Result := CompletionColors[tkStruct] + Token.Name + '\style{-B} : struct'
        else
          Result := CompletionColors[tkClass] + Token.Name + '\style{-B} : class';
      end;
    tkCodeTemplate:
      begin
        if Token.Flag = '' then
          Result := CompletionColors[tkCodeTemplate] + '\color{clBlack}' +
            Token.Name + '\style{-B}'
        else
          Result := CompletionColors[tkCodeTemplate] + Token.Name + '\style{-B}';
      end;
  end;
  Result := '\image{' + IntToStr(GetTokenImageIndex(Token, Images)) + '}' + Result;
  S := GetTreeHierarchy(Token, False);
  if S <> '' then
    Result := Result + '\color{clGray} - ' + S;
end;

function CompletionInsertItem(Token: TTokenClass): string;
begin
  Result := Token.Name;
  case Token.Token of
    tkFunction, tkConstructor, tkDestructor, tkPrototype, tkVariable, tkClass,
      tkDefine, tkTypedefProto, tkTypedef,
      tkTypeStruct, tkTypeUnion, tkStruct, tkEnum, tkNamespace,
      tkUnion, tkUnknow, tkOperator: Result := Token.Name;
  end;
end;

function GetTreeHierarchy(Token: TTokenClass; AddScope, Recursive: Boolean): string;
var
  Next: TTokenClass;
  Separator: string;
  Entered: Boolean;
begin
  Result := '';
  Separator := '';
  if AddScope then
    Separator := '.';
  Next := Token;
  Entered := False;
  if (Next.Token = tkClass) and AddScope then
      Separator := '::';
  while Assigned(Next.Parent) and not (Next.Parent.Token in [tkIncludeList,
    tkDefineList, tkTreeObjList,
      tkVarConsList, tkFuncProList,
      tkFunction, tkConstructor, tkDestructor, tkOperator,
      tkRoot, tkParams, tkScope {?}]) do
  begin
    Next := Next.Parent;
    if (Next.Token = tkScopeClass) and Assigned(Next.Parent) then
    begin
      if AddScope then
        Separator := '::';
      Next := Next.Parent;
    end
    else if (Next.Token = tkNamespace) and AddScope then
      Separator := '::';
    Result := Next.Name + Separator + Result;
    Entered := True;
    if not Recursive then
      Break;
  end;
  if not Entered and (Token.Token = tkCodeTemplate) and not AddScope then
    Result := Token.Flag;
end;

procedure GetStringsFields(const S: string; List: TStrings;
  IgnoreFirst: Boolean = True);
var
  Field: string;
  ptr: PChar;
begin
  ptr := PChar(S);
  Field := '';
  if IgnoreFirst then
  begin
    while not CharInSet(ptr^, [#0, '.', '-', '>', ':']) do
    begin
      Field := Field + ptr^;
      Inc(ptr);
    end;
    if ptr^ = '.' then
      Inc(ptr)
    else if (ptr^ = '-') and ((ptr + 1)^ = '>') then
      Inc(ptr, 2)
    else if (ptr^ = ':') and ((ptr + 1)^ = ':') then
      Inc(ptr, 2);
    if ptr^ = '~' then
      Inc(ptr);
  end;
  Field := '';
  while ptr^ <> #0 do
  begin
    if CharInSet(ptr^, ['.', '~', '-']) or (ptr^ = ':') and ((ptr + 1)^ = ':') then
    begin
      if Length(Field) > 0 then
        List.Add(Field);
      if CharInSet(ptr^, ['.', '~']) then
        Inc(ptr)
      else if ((ptr^ = '-') and ((ptr + 1)^ = '>')) or
        ((ptr^ = ':') and ((ptr + 1)^ = ':')) then
        Inc(ptr, 2)
      else
        Break;
      Field := '';
      Continue;
    end
    else
      Field := Field + ptr^;
    Inc(ptr);
  end;
  if Length(Field) > 0 then
    List.Add(Field);
end;

function MakeTokenHint(Token: TTokenClass; const FileName: string): string;
var
  NameOnly, TypeName, Params, S, Hierarchy: string;
  I, IEnd, Len: Integer;
begin
  Result := '';
  case Token.Token of
    tkClass:
      begin
        if Length(Token.Flag) > 0 then
          Result := TokenHintPrev[Token.Token] + ' ' + Token.Name + ' : ' + Token.Flag //get ancestor
        else
          Result := TokenHintPrev[Token.Token] + ' ' + Token.Name; //get ancestor
      end;
    tkFunction, tkPrototype, tkConstructor, tkDestructor, tkOperator:
      begin
        S := GetFuncProto(Token);
        Hierarchy := GetTreeHierarchy(Token);
        Result := TokenHintPrev[Token.Token] + ' ' + Hierarchy + Token.Name + '(' + S + '): ' + Token.Flag;
      end;
    tkDefine:
      begin
        if Length(Token.Flag) > 0 then
          Result := TokenHintPrev[Token.Token] + ' ' + Token.Name + ': ' + Token.Flag
        else
          Result := TokenHintPrev[Token.Token] + ' ' + Token.Name;
      end;
    tkVariable:
      begin
        I := Pos('[', Token.Flag);
        Len := Length(Token.Flag);
        TypeName := Token.Flag;
        Params := '';
        if I > 0 then
        begin
          Params := Copy(Token.Flag, I, Len - I + 1);
          TypeName := Copy(Token.Flag, 1, I - 1);
        end;
        Hierarchy := GetTreeHierarchy(Token);
        Result := TokenHintPrev[Token.Token] + ' ' + TypeName + ' ' + Hierarchy +
          Token.Name + Params;
      end;
    tkEnum, tkEnumItem,
      tkStruct, tkUnion, tkTypeStruct, tkTypeUnion,
      tkTypeEnum:
      begin
        Hierarchy := GetTreeHierarchy(Token);
        Params := '';
        if Length(Token.Flag) > 0 then
          Params := ': ' + Token.Flag;
        Result := TokenHintPrev[Token.Token] + ' ' + Hierarchy + Token.Name + Params;
      end;
    tkTypedef, tkNamespace:
      Result := TokenHintPrev[Token.Token] + ' ' + Token.Name;
    tkTypedefProto:
      begin
        S := GetFuncProto(Token);
        Hierarchy := GetTreeHierarchy(Token);
        I := Pos('(', Token.Flag);
        IEnd := Pos(')', Token.Flag);
        Len := IEnd - I - 1;
        Params := Copy(Token.Flag, I + 1, Len);
        I := Pos(':', Token.Flag);
        TypeName := Copy(Token.Flag, I + 1, Length(Token.Flag) - I);
        Result := TokenHintPrev[Token.Token] + ' ' + Hierarchy + Token.Name + '('
          + Params + ')(' + S + '): ' + TypeName;
      end;
    tkUnknow: ;
    tkForward:
      begin
        if Token.Flag = 'struct' then
          Result := TokenHintPrev[tkStruct] + ' ' + Token.Name
        else
          Result := TokenHintPrev[tkClass] + ' ' + Token.Name;
      end;
  end;
  NameOnly := ExtractFileName(FileName);
  Result := Result + ' - ' + NameOnly + '(' + IntToStr(Token.SelLine) + ')';
end;

function MakeTokenParamsHint(Token: TTokenClass): string;
var
  Params: string;
  I, IEnd, Len: Integer;
begin
  Result := '';
  case Token.Token of
    tkFunction, tkPrototype, tkConstructor, tkTypedefProto, tkOperator:
      begin
        Result := GetFuncProto(Token);
      end;
    tkDefine:
      begin
        I := Pos('(', Token.Flag);
        if I = 0 then
          Exit;
        IEnd := Pos(')', Token.Flag);
        if IEnd = 0 then
          Exit;
        Len := IEnd - I - 1;
        Params := Copy(Token.Flag, I + 1, Len);
        Result := Params;
      end;
  end;
end;

function GetLeftSpacing(CharCount, TabWidth: Integer; WantTabs: Boolean): string;
begin
  if (WantTabs) and (CharCount>=TabWidth) then
      Result:=StringOfChar(#9,CharCount div TabWidth)+StringOfChar(#32,CharCount mod TabWidth)
  else Result:=StringOfChar(#32,CharCount);
end;

function CommaCountAt(const S: string; Init: Integer): Integer;
var
  ptr: PChar;
  Current, PairCount: Integer;
begin
  Result := 0;
  Current := 0;
  PairCount := 0;
  ptr := PChar(S);
  while (ptr^ <> #0) and (Current < Init) do
  begin
    case ptr^ of
      '(': Inc(PairCount);
      ')': Dec(PairCount);
      ',': if PairCount = 0 then
          Inc(Result);
      '/':
        begin
          if (ptr + 1)^ = '*' then
          begin
            Inc(ptr);
            Inc(Current);
            repeat
              Inc(ptr);
              Inc(Current);
            until (ptr^ = #0) or ((ptr^ = '*') and ((ptr + 1)^ = '/')) or (Current >= Init);
            if ptr^ = '*' then
            begin
              Inc(ptr);
              Inc(Current);
              if ptr^ = #0 then
                Break;
            end;
          end
          else if (ptr + 1)^ = '/' then
          begin
            repeat
              Inc(ptr);
              Inc(Current);
            until CharInSet(ptr^, [#0, #10]) or (Current >= Init);
          end;
        end;
      '"':
        begin
          repeat
            Inc(ptr);
            Inc(Current);
          until (ptr^ = #0) or (Current >= Init) or
            ((ptr^ = '"') and ((ptr - 1)^ <> '\'));
          if ptr^ = #0 then
            Break;
        end;
      '''':
        begin
          repeat
            Inc(ptr);
            Inc(Current);
          until (ptr^ = #0) or (Current >= Init) or
            ((ptr^ = '''') and ((ptr - 1)^ <> '\'));
          if ptr^ = #0 then
            Break;
        end;
    end;
    Inc(ptr);
    Inc(Current);
  end;
end;

function CountCommas(const S: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = ',' then
      Inc(Result);
end;

function CountChar(const S: string; ch: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = ch then
      Inc(Result);
end;

function GetParamsBefore(const S: string; Index: Integer): string;
var
  I, Current, Len: Integer;
begin
  Result := '';
  Current := 0;
  Len := Length(S);
  for I := 1 to Len do
  begin
    if Current = Index then
      Break;
    if S[I] = ',' then
      Inc(Current);
  end;
  Result := Copy(S, 1, I - 1);
end;

function GetActiveParams(const S: string; Index: Integer): string;
var
  I, Current, Len: Integer;
begin
  Result := '';
  Current := 0;
  Len := Length(S);
  for I := 1 to Len do
  begin
    if Current = Index then
      Break;
    if S[I] = ',' then
      Inc(Current);
  end;
  Result := Copy(S, I, Len - I + 1);
  Len := Pos(',', Result);
  if Len > 0 then
    Result := Copy(S, I, Len);
end;

function GetParamsAfter(const S: string; Index: Integer): string;
var
  I, Current, Len: Integer;
begin
  Result := '';
  Current := 0;
  Len := Length(S);
  for I := 1 to Len do
  begin
    if S[I] = ',' then
      Inc(Current);
    if Current > Index then
      Break;
  end;
  if I < Len then
    Result := Copy(S, I + 1, Len - I);
end;

function GetFirstWord(const S: string): string;
var
  Len, RLen, I: Integer;
begin
  Result := '';
  RLen := 0;
  I := 1;
  Len := Length(S);
  while (I <= Len) do
  begin
    if (RLen > 0) and not CharInSet(S[I], LetterChars + DigitChars) then
      Break
    else if CharInSet(S[I], LetterChars + DigitChars) then
    begin
      Result := Result + S[I];
      Inc(RLen);
    end;
    Inc(I);
  end;
end;

function GetAfterWord(const S: string): string;
var
  Len, RLen, I: Integer;
begin
  Result := '';
  RLen := 0;
  I := 1;
  Len := Length(S);
  while (I <= Len) do
  begin
    if (RLen > 0) and not CharInSet(S[I], LetterChars + DigitChars) then
      Break
    else if CharInSet(S[I], LetterChars + DigitChars) then
      Inc(RLen);
    Inc(I);
  end;
  Result := Trim(Copy(S, I, Len - I + 1));
end;

procedure GetDescendants(const S: string; List: TStrings; scope: TScopeClass);
var
  sc, Temp, ancs: string;
begin
  Temp := S;
  sc := GetFirstWord(Temp);
  if sc = 'virtual' then
  begin
    Temp := GetAfterWord(Temp);
    sc := GetFirstWord(Temp);
  end;
  if not StringIn(sc, ScopeNames) then
  begin
    if scope <> scPrivate then
      Exit;
  end
  else
  begin
    Temp := GetAfterWord(S);
    if (sc = 'public') and (scope <> scPublic) then
      Exit;
    if (sc = 'private') and (scope <> scPrivate) then
      Exit;
    if (sc = 'protected') and (scope <> scProtected) then
      Exit;
  end;
  while Temp <> '' do
  begin
    ancs := GetFirstWord(Temp);
    List.Add(ancs);
    Temp := GetAfterWord(Temp);
  end;

end;

//strings

function GetLastWord(const S: string; AllowScope: Boolean): string;
var
  Len, RLen: Integer;
  Chars: set of AnsiChar;
begin
  Result := '';
  RLen := 0;
  Len := Length(S);
  Chars := LetterChars + DigitChars;
  if AllowScope then
    Chars := Chars + [':'];
  while (Len > 0) do
  begin
    if (RLen > 0) and not CharInSet(S[Len], Chars) then
      Break
    else if CharInSet(S[Len], Chars) then
    begin
      Result := S[Len] + Result;
      Inc(RLen);
    end;
    Dec(Len);
  end;
end;

function Trim(Left: Char; const S: string; Rigth: Char): string; overload;
var
  Len: Integer;
begin
  Result := Trim(S);
  Len := Length(Result);
  while (Len > 0) and (Result[1] = Left) do
  begin
    Delete(Result, 1, 1);
    Dec(Len);
  end;
  while (Len > 0) and (Result[Len] = Rigth) do
  begin
    Delete(Result, Len, 1);
    Dec(Len);
  end;
end;

function GetPriorWord(const S: string): string;
var
  Len, RLen: Integer;
begin
  RLen := 0;
  Len := Length(S);
  while (Len > 0) do
  begin
    if (RLen > 0) and not CharInSet(S[Len], LetterChars + DigitChars) then
      Break
    else if CharInSet(S[Len], LetterChars + DigitChars) then
      Inc(RLen);
    Dec(Len);
  end;
  Result := Trim(Copy(S, 1, Len));
end;

function GetLastChar(const S: string): Char;
var
  Len: Integer;
begin
  Result := #0;
  Len := Length(S);
  while (Len > 0) do
  begin
    if not CharInSet(S[Len], SpaceChars + LineChars) then
    begin
      Result := S[Len];
      Break;
    end;
    Dec(Len);
  end;
end;

function GetOperator(const S: string): string;
var
  Len: Integer;
begin
  Result := '';
  Len := Length(S);
  while (Len > 0) do
  begin
    if (Result <> '') and (S[Len] = 'r') then
      Break
    else if not CharInSet(S[Len], SpaceChars + LineChars) then
      Result := S[Len] + Result;
    Dec(Len);
  end;
end;

function SkipTemplateParams(const ret: string): string;
var
  ptr, init: PChar;
  pairCount: Integer;
begin
  init := PChar(ret);
  ptr := init + Length(ret) - 1;
  while(ptr >= init) do
  begin
    if CharInSet(ptr^, LetterChars+DigitChars) then
      Break;
    // skip params
    if ptr^ = '>' then
    begin
      pairCount := 1;
      Dec(ptr);
      while (ptr >= init) and (pairCount <> 0) do
      begin
        if ptr^ = '>' then
          Inc(pairCount)
        else if ptr^ = '<' then
          Dec(pairCount);
        Dec(ptr);
      end;
      if (ptr < init) then
        Break;
      Continue;
    end;
    Dec(ptr);
  end;
  if (ptr < init) then
  begin
    Result := '';
    Exit;
  end;
  SetLength(Result, ptr - init + 1);
  StrMove(PChar(Result), init, ptr - init + 1);
end;

function GetVarType(Token: TTokenClass): string;
var
  I: Integer;
  Temp, lower: string;
  ContinueFlag: Boolean;
begin
  Temp := token.Flag;
  I := Pos('[', Temp);
  if I > 0 then
    Temp := Copy(Temp, 1, I - 1);
  Result := '';
  while Temp <> '' do
  begin
    Temp := SkipTemplateParams(Temp);
    Result := GetLastWord(Temp, True);
    Temp := GetPriorWord(Temp);
    lower := LowerCase(Result);
    ContinueFlag := (lower = 'inline') or (lower = 'static') or
      (lower = 'extern') or (lower = 'virtual');
    if not ContinueFlag then
    begin
      I := Pos('call', lower);
      ContinueFlag := (I = Length(lower) - Length('call') + 1) and (I > 0);
    end;
    if not ContinueFlag then
    begin
      I := Pos('api', lower);
      ContinueFlag := (I = Length(lower) - Length('api') + 1) and (I > 0);
    end;
    if not ContinueFlag then
    begin
      I := Pos('export', lower);
      ContinueFlag := (I = Length(lower) - Length('export') + 1) and (I > 0);
    end;
    if ContinueFlag then
    begin
      if Temp <> '' then
        Continue;
    end;
    Break;
  end;
end;

function StringToScopeClass(const S: string): TScopeClass;
begin
  Result := scPrivate;
  if S = 'protected' then
    Result := scProtected
  else if S = 'public' then
    Result := scPublic;
end;

function StringIn(const S: string; List: array of string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := Low(List) to High(List) do
    if List[I] = S then
      Exit;
  Result := False;
end;

function CountWords(const S: string): Integer;
var
  Len, RLen, I: Integer;
begin
  Result := 0;
  RLen := 0;
  I := 1;
  Len := Length(S);
  while (I <= Len) do
  begin
    if (RLen > 0) and not CharInSet(S[I], LetterChars + DigitChars) then
    begin
      RLen := 0;
      Inc(Result);
    end
    else if CharInSet(S[I], LetterChars + DigitChars) then
    begin
      Inc(RLen);
    end;
    Inc(I);
  end;
  if (Len > 0) and CharInSet(S[Len], LetterChars + DigitChars) then
    Inc(Result);
end;

function GetTokenByName(Token: TTokenClass; const Name: string;
  tokenType: TTkType): TTokenClass;
var
  I: integer;
begin
  Result := nil;
  for I := 0 to Token.Count - 1 do
  begin
    if (Token.Items[I].Token = tokenType) and (Token.Items[I].Name = Name) then
    begin
      Result := Token.Items[I];
      Exit;
    end;
  end;
end;

function IsNumber(const S: string): Boolean;
var
  ptr: PChar;
begin
  ptr := PChar(S);
  Result := False;
  if not CharInSet(ptr^, DigitChars + ['b']) then
    Exit;
  Result := CharInSet(ptr^, DigitChars);
  Inc(ptr);
  if CharInSet(ptr^, ['x', 'X']) then
    Inc(ptr);
  while (ptr^ <> #0) and CharInSet(ptr^, DigitChars + HexChars + ['L']) do
  begin
    Result := True;
    Inc(ptr);
  end;
  if ptr^ <> #0 then
    Result := False;
end;

function IsValidName(const S: string): Boolean;
var
  ptr: PChar;
begin
  ptr := PChar(S);
  Result := False;
  if not CharInSet(ptr^, LetterChars) then
    Exit;
  while (ptr^ <> #0) and CharInSet(ptr^, LetterChars + DigitChars) do
    Inc(ptr);
  Result := ptr^ = #0;
end;


function StartOfCommentInv(const init, ptr: PChar): PChar;
var
  cmmptr: PChar;
begin
  Result := ptr;
  cmmptr := ptr - 1;
  // back one line
  while (cmmptr >= init) and not CharInSet(cmmptr^, LineChars) do
    Dec(cmmptr);
  // check for line comment
  while (cmmptr < ptr) do
  begin
    case cmmptr^ of
      '/':
      begin
        if (cmmptr + 1)^ = '/' then Break;
        // skip /* */ comment
        if (cmmptr + 1)^ = '*' then
        begin
          Inc(cmmptr, 2);
          while (cmmptr < ptr) and ((cmmptr^ <> '*') or ((cmmptr + 1)^ <> '/')) do
            Inc(cmmptr);
        end;
      end;
      '''': // skip single quote '?'
      begin
        Inc(cmmptr);
        while (cmmptr < ptr) and ((cmmptr^ <> '''') or ((cmmptr - 1)^ = '\')) do
          Inc(cmmptr);
      end;
      '"': // skip string
      begin
        Inc(cmmptr);
        while (cmmptr < ptr) and ((cmmptr^ <> '"') or ((cmmptr - 1)^ = '\')) do
          Inc(cmmptr);
      end;
    end;
    Inc(cmmptr);
  end;
  // jump to start of comment
  if (cmmptr^ = '/') and ((cmmptr + 1)^ = '/') then
    Result := cmmptr - 1;
end;

function SkipStringInv(const init: PChar; var ptr: PChar): Boolean;
begin
  if ptr^ = '"' then
    Dec(ptr);
  while (ptr >= init) and (ptr^ <> #10) and ((ptr^ <> '"') or ((ptr - 1)^ = '\')) do
  begin
    // jump sigle line comment
    if CharInSet(ptr^, LineChars) then
    begin
      if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
        Dec(ptr);
      ptr := StartOfCommentInv(init, ptr);
    end;
    Dec(ptr);
  end;
  Result := (ptr^ = '"');
end;

function SkipSingleQuotesInv(const init: PChar; var ptr: PChar): Boolean;
begin
  if ptr^ = '''' then
    Dec(ptr);
  while (ptr >= init) and ((ptr^ <> '''') or ((ptr - 1)^ = '\')) do
  begin
    // jump sigle line comment
    if CharInSet(ptr^, LineChars) then
    begin
      if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
        Dec(ptr);
      ptr := StartOfCommentInv(init, ptr);
    end;
    Dec(ptr);
  end;
  Result := (ptr^ = '''');
end;

function SkipMultlineCommentInv(const init: PChar; var ptr: PChar): Boolean;
begin
  if (ptr - 1)^ = '*' then
    Dec(ptr);
  repeat
    Dec(ptr);
    // jump sigle line comment
    if CharInSet(ptr^, LineChars) then
    begin
      if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
        Dec(ptr);
      ptr := StartOfCommentInv(init, ptr);
    end;
  until (ptr < init) or ((ptr^ = '/') and ((ptr + 1)^ = '*'));
  Result := (ptr >= init) and (ptr^ = '/') and ((ptr + 1)^ = '*');
end;

function SkipInvPair(const init: PChar; var ptr: PChar; cs, ce: Char): Boolean;
var
  pair_count: Integer;
begin
  Result := False;
  pair_count := 1;
  if ptr^ = ce then
    Dec(ptr);
  if ptr < init then
    Exit;
  repeat
    case ptr^ of
      '''': SkipSingleQuotesInv(init, ptr);
      '"': SkipStringInv(init, ptr);
      '/':
        if (ptr > init) and ((ptr - 1)^ = '*') then
        begin
          if not SkipMultlineCommentInv(init, ptr) then
            Exit;
        end;
    else
      if ptr^ = ce then
        Inc(pair_count)
      else if ptr^ = cs then
      begin
        Dec(pair_count);
        if pair_count = 0 then
          Break;
      end
      // jump sigle line comment
      else if CharInSet(ptr^, LineChars) then
      begin
        if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
          Dec(ptr);
        ptr := StartOfCommentInv(init, ptr);
      end;
    end;
    Dec(ptr);
  until (ptr < init) or (pair_count = 0);
  Result := pair_count = 0;
end;

function SkipInvPairGetCast(const init: PChar; var ptr: PChar; cs, ce: Char;
  var Cast: string): Boolean;
var
  pair_count: Integer;
begin
  Result := False;
  pair_count := 1;
  if ptr^ = ce then
  begin
    Cast := '';
    Dec(ptr);
  end;
  if ptr < init then
    Exit;
  repeat
    case ptr^ of
      '''': SkipSingleQuotesInv(init, ptr);
      '"': SkipStringInv(init, ptr);
      '/':
        if (ptr > init) and ((ptr - 1)^ = '*') then
        begin
          if not SkipMultlineCommentInv(init, ptr) then
            Exit;
        end;
    else
      if ptr^ = ce then
      begin
        Cast := '';
        Inc(pair_count);
      end
      else if ptr^ = cs then
      begin
        Dec(pair_count);
        if pair_count = 0 then
          Break;
      end
      else if CharInSet(ptr^, LetterChars + DigitChars) then
        Cast := ptr^ + Cast
      // jump sigle line comment
      else if CharInSet(ptr^, LineChars) then
      begin
        if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
          Dec(ptr);
        ptr := StartOfCommentInv(init, ptr);
      end;
    end;
    Dec(ptr);
  until (ptr < init) or (pair_count = 0);
  Result := pair_count = 0;
end;

{ TODO -oMazin -c : Convert to Lines 04/05/2013 22:12:39 }
function GetNextValidChar(const Text: string; SelStart: Integer): Char;
var
  ptr, init: PChar;
begin
  init := PChar(Text);
  ptr := init + SelStart;
  while (ptr^ <> #0) and CharInSet(ptr^, LetterChars + DigitChars) do
    Inc(ptr);
  repeat
    case ptr^ of
      '/':
        if ((ptr + 1)^ = '*') then
        begin
          Inc(ptr, 2);
          while (ptr^ <> #0) and not ((ptr^ = '*') and ((ptr + 1)^ = '/')) do
            Inc(ptr);
          if ptr^ = '*' then
            Inc(ptr);
        end
        else if ((ptr + 1)^ = '/') then
        begin
          while not CharInSet(ptr^, [#0] + LineChars) do
            Inc(ptr);
        end
        else
          Break;
    else
      if not CharInSet(ptr^, LineChars + SpaceChars) then
        Break;
    end;
    Inc(ptr);
  until (ptr^ = #0) or not CharInSet(ptr^, ['/'] + LineChars + SpaceChars);
  Result := ptr^;
end;

{ TODO -oMazin -c : Convert to Lines 04/05/2013 22:09:11 }
function ParseFields(const Text: string; SelStart: Integer;
  var S, Fields: string; var InputError: Boolean): Boolean;
var
  ptr, init: PChar;
  skipSpace, HasSpace: Boolean;
  str, field, _sep, sep, _fields, cast: string;
begin
  Result := False;
  InputError := False;
  init := PChar(Text);
  ptr := init + SelStart;
  str := '';
  cast := '';
  skipSpace := False;
  if CharInSet(ptr^, LetterChars + DigitChars) then
  begin
    skipSpace := True;
    //get string after selstart
    repeat
      str := str + ptr^;
      Inc(ptr);
    until (ptr^ = #0) or not CharInSet(ptr^, LetterChars + DigitChars);
  end;
  ptr := init + SelStart - 1;
  HasSpace := (ptr >= init) and CharInSet(ptr^, LineChars + SpaceChars);
  //get string before selstart
  while not skipSpace and (ptr >= init) and CharInSet(ptr^, LineChars + SpaceChars) do
  begin
    // jump sigle line comment
    if CharInSet(ptr^, LineChars) then
    begin
      if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
        Dec(ptr);
      ptr := StartOfCommentInv(init, ptr);
    end;
    Dec(ptr);
  end;
  if CharInSet(ptr^, LetterChars + DigitChars) then
  begin
    if HasSpace then // no completion at:  var.field |
      Exit;
    repeat
      str := ptr^ + str;
      Dec(ptr);
    until (ptr < init) or not CharInSet(ptr^, LetterChars + DigitChars);
  end;
  if (ptr < init) then
  begin
    if IsValidName(str) then
    begin
      Result := True;
      S := str;
      Fields := '';
    end;
    Exit;
  end;
  if not IsValidName(str) and (str <> '') then
    Exit;
  _fields := '';
  sep := '';
  repeat
    _sep := sep;
    sep := '';
    //get separator
    repeat
      case ptr^ of
        '.':
          begin
            sep := ptr^ + sep;
            Dec(ptr);
            Break;
          end;
        ':':
          if (ptr = init) or ((ptr - 1)^ <> ':') then
            Break
          else
          begin
            sep := ':' + ptr^ + sep;
            Dec(ptr, 2);
            Break;
          end;
        '~':
          if (sep <> '') or (_fields <> '') then
            Break
          else
            sep := ptr^ + sep;
        '>':
          if (ptr = init) or ((ptr - 1)^ <> '-') then
            Break
          else
          begin
            sep := '-' + ptr^ + sep;
            Dec(ptr, 2);
            Break;
          end;
        '/':
          if (ptr > init) and ((ptr - 1)^ = '*') then
            SkipMultlineCommentInv(init, ptr)
          else
            Exit; // syntax error ex:  blabla./ or bla.bla/
      else
        if not CharInSet(ptr^, LineChars + SpaceChars) then
          Break
        // jump sigle line comment
        else if CharInSet(ptr^, LineChars) then
        begin
          if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
            Dec(ptr);
          ptr := StartOfCommentInv(init, ptr);
        end;
      end;
      Dec(ptr);
    until ptr < init;
    if (ptr < init) or (sep = '') then
    begin
      if (sep = '') and (field = '') and (_sep <> '') and (cast <> '') then
        _fields := cast + _sep + _fields;
      Break;
    end;
    while True do
    begin
      //skipspace
      while (ptr >= init) and CharInSet(ptr^, LineChars + SpaceChars) do
      begin
        // jump sigle line comment
        if CharInSet(ptr^, LineChars) then
        begin
          if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
            Dec(ptr);
          ptr := StartOfCommentInv(init, ptr);
        end;
        Dec(ptr);
      end;
      if ptr^ = '>' then
      begin
        SkipInvPair(init, ptr, '<', '>');
        if (ptr >= init) and (ptr^ = '<') then
          Dec(ptr);
      end
      else
        Break;
    end;
    if not CharInSet(ptr^, LetterChars + DigitChars + [')', ']', '/']) then
    begin
      if sep <> '' then
      begin
        if sep <> '::' then
          InputError := True; //;.blabla
        Exit; //error ?->blabla
      end
      else
        Break;
    end;
    cast := '';
    field := '';
    skipSpace := False;
    repeat
      case ptr^ of
        ')':
        begin
          if field <> '' then
            Break;
          SkipInvPairGetCast(init, ptr, '(', ')', cast);
          skipSpace := True;
        end;
        ']':
        begin
          SkipInvPair(init, ptr, '[', ']');
          skipSpace := True;
        end;
        '/':
          if (ptr = init) or ((ptr - 1)^ <> '*') then
          begin
            SkipMultlineCommentInv(init, ptr);
            skipSpace := True;
          end
          else
          begin
            if sep <> '::' then
              InputError := True; //;.blabla
            Exit; //syntax error     /->blabla /.blabla /::blabla
          end;
      else
        // jump sigle line comment
        if CharInSet(ptr^, LineChars) then
        begin
          if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
            Dec(ptr);
          ptr := StartOfCommentInv(init, ptr);
        end
        else
          field := ptr^ + field;
      end;
      Dec(ptr);
      if skipSpace then
      begin
        skipSpace := False;
        //skipspace
        while (ptr >= init) and CharInSet(ptr^, LineChars + SpaceChars) do
        begin
          // jump sigle line comment
          if CharInSet(ptr^, LineChars) then
          begin
            if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
              Dec(ptr);
            ptr := StartOfCommentInv(init, ptr);
          end;
          Dec(ptr);
        end;
      end;
    until (ptr < init) or not CharInSet(ptr^, LetterChars + DigitChars + [')', ']', '/']);
    if field <> '' then
      _fields := field + sep + _fields;
  until false;
  if (_fields <> '') or (str <> '') then
  begin
    Result := True;
    S := str;
    Fields := _fields;
  end;
end;

{ TODO -oMazin -c : Convert to Lines 04/05/2013 22:08:19 }
function GetFirstOpenParentheses(const S: string; QuoteChar: Char;
  var SelStart: Integer): Boolean;
var
  init, ptr, skip: PChar;
begin
  Result := False;
  init := PChar(S);
  ptr := init + SelStart;
  if CharInSet(ptr^, ['(', ')', ';', '{', '}']) and (QuoteChar = #0) then
    Dec(ptr);
  if QuoteChar = '"' then
  begin
    if SkipStringInv(init, ptr) then
      Dec(ptr);
  end
  else if QuoteChar = '''' then
  begin
    if SkipSingleQuotesInv(init, ptr) then
      Dec(ptr);
  end;
  repeat
    while (ptr >= init) and (ptr^ <> '(') do
    begin
      case ptr^ of
        ')': SkipInvPair(init, ptr, '(', ')');
        '/':
          if (ptr > init) and ((ptr - 1)^ = '*') then
            SkipMultlineCommentInv(init, ptr);
        '"': SkipStringInv(init, ptr);
        '''': SkipSingleQuotesInv(init, ptr);
        ';', '{', '}': Exit;
      else
        // jump sigle line comment
        if CharInSet(ptr^, LineChars) then
        begin
          if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
            Dec(ptr);
          ptr := StartOfCommentInv(init, ptr);
        end;
      end;
      Dec(ptr);
    end;
    skip := ptr;
    if ptr^ <> '(' then
      Exit;
    Dec(skip);
    while (skip >= init) and CharInSet(skip^, LineChars + SpaceChars) do
    begin
      case skip^ of
        '/':
          if (skip > init) and ((skip - 1)^ = '*') then
            SkipMultlineCommentInv(init, skip);
        '"': SkipStringInv(init, skip);
        '''': SkipSingleQuotesInv(init, skip);
      else
        // jump sigle line comment
        if CharInSet(skip^, LineChars) then
        begin
          if (skip > init) and CharInSet((skip - 1)^, LineChars) then
            Dec(skip);
          skip := StartOfCommentInv(init, skip);
        end;
      end;
      Dec(skip);
    end;
    if CharInSet(skip^, LetterChars + DigitChars) then
      Break;
    ptr := skip;
  until ptr <= init;
  if ptr^ <> '(' then
    Exit;
  SelStart := ptr - init;
  Result := True;
end;

{ TODO -oMazin -c : Convert to Lines 04/05/2013 22:08:19 }
function GetFirstOpenBracket(const S: string; QuoteChar: Char;
  var BracketStart, VarEnd: Integer; var StructParams: string): Boolean;
var
  init, ptr, last, first: PChar;
  params: string;
begin
  Result := False;
  init := PChar(S);
  ptr := init + BracketStart;
  last := nil;
  first := nil;
  params := '';
  if CharInSet(ptr^, ['{', '}', ';', '(', ')', ',']) and (QuoteChar = #0) then
    Dec(ptr);
  if QuoteChar = '"' then
  begin
    if SkipStringInv(init, ptr) then
      Dec(ptr);
  end
  else if QuoteChar = '''' then
  begin
    if SkipSingleQuotesInv(init, ptr) then
      Dec(ptr);
  end;
  while (ptr >= init) and ((ptr^ <> '=') or (last = nil))  do
  begin
    case ptr^ of
      '{':
      begin
        if first = nil then
          first := ptr;
        params := '.' + params;
        last := ptr;
      end;
      '}': SkipInvPair(init, ptr, '{', '}');
      ',':
      begin
        last := nil;
        params := ',' + params;
      end;
      '/':
        if (ptr > init) and ((ptr - 1)^ = '*') then
          SkipMultlineCommentInv(init, ptr);
      '"': SkipStringInv(init, ptr);
      '''': SkipSingleQuotesInv(init, ptr);
      ';': Exit;
      ')': SkipInvPair(init, ptr, '(', ')');
    else
      // jump sigle line comment
      if CharInSet(ptr^, LineChars) then
      begin
        if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
          Dec(ptr);
        ptr := StartOfCommentInv(init, ptr);
      end
      else if not CharInSet(ptr^, SpaceChars) and (last <> nil) then
        last := nil;
    end;
    Dec(ptr);
  end;
  if (ptr^ <> '=') or (last = nil) then
    Exit;
  Dec(ptr);
  // get end of variable
  while (ptr >= init) and CharInSet(ptr^, SpaceChars + LineChars + [']']) do
  begin
    case ptr^ of
      '/':
        if (ptr > init) and ((ptr - 1)^ = '*') then
          SkipMultlineCommentInv(init, ptr);
      '"': SkipStringInv(init, ptr);
      '''': SkipSingleQuotesInv(init, ptr);
      ']': SkipInvPair(init, ptr, '[', ']');
    else
      // jump sigle line comment
      if CharInSet(ptr^, LineChars) then
      begin
        if (ptr > init) and CharInSet((ptr - 1)^, LineChars) then
          Dec(ptr);
        ptr := StartOfCommentInv(init, ptr);
      end;
    end;
    Dec(ptr);
  end;
  if (ptr < init) then
    Exit;
  // start of {
  BracketStart := first - init;
  VarEnd := ptr - init;
  StructParams := params;
  Result := True;
end;

function ConvertSlashes(const Path: string): string;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
    if Result[i] = '/' then
      Result[i] := '\';
end;

function ConvertToUnixSlashes(const Path: string): string;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
    if Result[i] = '\' then
      Result[i] := '/';
end;

end.
