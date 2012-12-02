unit TokenUtils;

interface

uses
  TokenList, SysUtils, Classes, TokenConst, TokenFile, Dialogs;

//make hint
function GetFuncScope(Token: TTokenClass): string;
function GetFuncProto(Token: TTokenClass; GenName: Boolean = False): string;
function GetFuncProtoTypes(Token: TTokenClass): string;
procedure GetStringsFields(const S: string; List: TStrings;
  IgnoreFirst: Boolean = True);
function GetTreeHierarchy(Token: TTokenClass): string;
function MakeTokenHint(Token: TTokenClass; const FileName: string): string;
function MakeTokenParamsHint(Token: TTokenClass): string;
//completion list
procedure FillCompletionTree(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors;
  ScopeClass: TScopeClassState = []; IncludeParams: Boolean = False);
procedure FillCompletionTreeNoRepeat(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; TokenList: TTokenList;
  ScopeClass: TScopeClassState = []; IncludeParams: Boolean = False;
  UseList: Boolean = False);
function CompletionShowItem(Token: TTokenClass; CompletionColors: TCompletionColors): string;
function CompletionInsertItem(Token: TTokenClass): string;

//params
function CommaCountAt(const S: string; Init: Integer): Integer;
function CountCommas(const S: string): Integer;
function GetParamsBefore(const S: string; Index: Integer): string;
function GetActiveParams(const S: string; Index: Integer): string;
function GetParamsAfter(const S: string; Index: Integer): string;

//strings
function GetFirstWord(const S: string): string;
function GetAfterWord(const S: string): string;
procedure GetDescendants(const S: string; List: TStrings; scope: TScopeClass);
function GetLastWord(const S: string; AllowScope: Boolean = False): string;
function GetPriorWord(const S: string): string;
function GetVarType(const S: string): string;
function Trim(Left: Char; const S: string; Rigth: Char): string; overload;
function StringToScopeClass(const S: string): TScopeClass;
function StringIn(const S: string; List: array of string): Boolean;
function CountWords(const S: string): Integer;

function GetTokenByName(Token: TTokenClass; const Name: string;
  tokenType: TTkType): TTokenClass;

//others
function HasTODO(const S: string): Boolean;
procedure GenerateFunctions(TokenFile: TTokenFile; Source: TStrings;
  StartLine: Integer);
procedure GenerateFunctionPrototype(TokenFile: TTokenFile; Source: TStrings;
  StartLine: Integer; AddNameParams: Boolean = True);
function GetTokenImageIndex(Token: TTokenClass; Images: array of Integer): Integer;
function FileDateTime(const FileName: string): TDateTime;
function IsNumber(const S: string): Boolean;
function ScopeInState(const S: string; ScopeClass: TScopeClassState): Boolean;
function ConvertSlashes(const Path: string): string;
function GetFirstOpenBrace(const S: string; QuoteChar: Char;
  var SelStart: Integer): Boolean;
function ParseFields(const Text: string; SelStart: Integer;
  var S, Fields: string; var InputError: Boolean): Boolean;
function GetNextValidChar(const Text: string; SelStart: Integer): Char;

implementation

function FileDateTime(const FileName: string): TDateTime;
begin
  Result := FileDateToDateTime(FileAge(FileName));
end;

procedure InsertFunction(func: TTokenClass; Source: TStrings;
  var StartLine: Integer; Indentation: Integer; JavaStyle: Boolean);
var
  S, FuncImp, IndentStr, Scope, RetValue: string;
begin
  if not (func.Token in [tkFunction, tkPrototype, tkConstructor,
    tkDestructor]) then
    Exit;
  Scope := '';
  S := func.Name + '(' + GetFuncProto(func, True) + ')';
  IndentStr := StringOfChar(' ', Indentation * func.Level);
  if Assigned(func.Parent) and Assigned(func.Parent.Parent) and
    (func.Parent.Parent.Token = tkClass) then
  begin
    IndentStr := StringOfChar(' ', Indentation * (func.Level - 2));
    if func.Token in [tkDestructor] then
      Scope := func.Parent.Parent.Name + '::~'
    else
      Scope := func.Parent.Parent.Name + '::';
  end;
  FuncImp := IndentStr + Trim(func.Flag + ' ' + Scope + S);
  if JavaStyle then
    Source.Insert(StartLine, FuncImp + ' {')
  else
  begin
    Source.Insert(StartLine, FuncImp);
    Inc(StartLine);
    Source.Insert(StartLine, IndentStr + '{');
  end;
  Inc(StartLine);
  Source.Insert(StartLine, IndentStr + StringOfChar(' ', Indentation) +
    '//TODO Generated function');
  Inc(StartLine);
  S := GetVarType(func.Flag);
  if (S <> '') and ((S <> 'void') or (Pos('*', func.Flag) > 0)) then
  begin
    RetValue := '0';
    if Pos('*', func.Flag) > 0 then
      RetValue := 'NULL'
    else if S = 'bool' then
      RetValue := 'false'
    else if S = 'string' then
      RetValue := '""';
    Source.Insert(StartLine, IndentStr + StringOfChar(' ', Indentation) +
      'return ' + RetValue + ';');
    Inc(StartLine);
  end;
  Source.Insert(StartLine, IndentStr + '}');
  Inc(StartLine);
end;

procedure GenerateFunctions(TokenFile: TTokenFile; Source: TStrings;
  StartLine: Integer);

  procedure GenerateGroup(Item: TTokenClass; var InsertLine: Integer;
    Indentation: Integer);
  var
    IndentStr: string;
    I: Integer;
  begin
    IndentStr := StringOfChar(' ', Indentation * Item.Level);
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
            Continue;
          InsertFunction(Item.Items[I], Source, InsertLine, Indentation, False);
          if I < Item.Count - 1 then
          begin
            Source.Insert(InsertLine, '');
            Inc(InsertLine);
          end;
        end;
        Continue;
      end;
      GenerateGroup(Item.Items[I], InsertLine, 4);
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
    InsertFunction(Item.Items[I], Source, InsertLine, 4, False);
    Source.Insert(InsertLine, '');
    Inc(InsertLine);
  end;
  Item := TokenFile.TreeObjs;
  for I := 0 to Item.Count - 1 do
  begin
    if not (Item.Items[I].Token in [tkClass, tkNamespace]) then
      Continue;
    GenerateGroup(Item.Items[I], InsertLine, 4);
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
    if (Item.Items[I].Token in [tkPrototype]) or
      ((Item.Items[I].Token in [tkFunction]) and
      (Pos('static', Item.Items[I].Flag) > 0)) then
    begin
      S := Item.Items[I].Name + GetFuncProtoTypes(Item.Items[I]);
      PrototypeList.AddObject(S, Item.Items[I]);
      Continue;
    end;
    if ((Item.Items[I].Token in [tkFunction, tkConstructor, tkDestructor]) and
      (Pos('static', Item.Items[I].Flag) = 0)) then
    begin
      S := GetFuncProtoTypes(Item.Items[I]);
      if PrototypeList.IndexOf(S) >= 0 then
        Continue;
      Scope := GetTokenByName(Item.Items[I], 'Scope', tkScope);
      //if not Assigned(Scope) then
      //  Continue;
      if (Scope.Flag <> '') and not
        TokenFile.SearchToken(Scope.Flag, SearchItem, Scope.SelStart,
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
  else
    Result := 0;
  end;
  if (Result >= Low(Images)) and (Result <= High(Images)) and
    (Length(Images) > 0) then
    Result := Images[Result];
end;

function GetFuncScope(Token: TTokenClass): string;
var
  Scope: TTokenClass;
begin
  Result := '';
  if not (Token.Token in [tkFunction, tkPrototype, tkConstructor, tkDestructor])
    or (Assigned(Token.Parent) and (Token.Token in [tkFuncProList])) then
    Exit;
  Scope := GetTokenByName(Token, 'Scope', tkScope);
  if not Assigned(Scope) then
    Exit;
  Result := Scope.Flag;
  if Length(Result) > 0 then
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
    tkConstructor, tkDestructor]) then
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

function HasTODO(const S: string): Boolean;
const
  TodoStr = 'TODO';
var
  ptr: PChar;
  I: Integer;
begin
  Result := False;
  ptr := PChar(S);
  while ptr^ in SpaceChars do
    Inc(ptr);
  if (ptr^ = '/') and ((ptr + 1)^ = '/') then
  begin
    Inc(ptr, 2);
    while ptr^ in SpaceChars do
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
  if not (Token.Token in [tkFunction, tkPrototype, tkConstructor,
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
  SelStart: Integer; CompletionColors: TCompletionColors;
  ScopeClass: TScopeClassState; IncludeParams: Boolean);
begin
  FillCompletionTreeNoRepeat(InsertList, ShowList, Token, SelStart,
    CompletionColors, nil, ScopeClass, IncludeParams, False);
end;

procedure FillCompletionTreeNoRepeat(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; TokenList: TTokenList;
  ScopeClass: TScopeClassState; IncludeParams: Boolean; UseList: Boolean);
var
  I: Integer;
  NewToken: TTokenClass;
begin
  for I := 0 to Token.Count - 1 do
  begin
    if (SelStart >= 0) and (Token.Items[I].SelStart > SelStart) then
      Exit;
    if (Token.Items[I].Token in [tkScope]) or
      ((Token.Items[I].Token in [tkParams]) and not IncludeParams) then
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
      NewToken := TTokenClass.Create;
      NewToken.Assign(Token.Items[I]); //copy
      if UseList and Assigned(TokenList) then
        TokenList.Add(NewToken);
      if Assigned(InsertList) then
        InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      if Assigned(ShowList) then
        ShowList.AddObject(CompletionShowItem(NewToken, CompletionColors), NewToken);
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
      tkClass, tkFunction, tkConstructor, tkDestructor, tkStruct, tkUnion,
        tkEnum, tkTypeStruct, tkTypeUnion, tkTypeEnum, tkParams,
        tkScopeClass, tkNamespace:
        FillCompletionTreeNoRepeat(InsertList, ShowList,
          Token.Items[I], SelStart, CompletionColors, TokenList,
          ScopeClass, False, UseList);
    end;
  end;
end;

function CompletionShowItem(Token: TTokenClass;
  CompletionColors: TCompletionColors): string;
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
            '\style{-B} : class(' + GetLastWord(Token.Flag) + ');'
        else
          Result := CompletionColors[Token.Token] + Token.Name +
            '\style{-B} : class;';
      end;
    tkFunction, tkPrototype:
      begin
        S := GetFuncProto(Token);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '\color{clMaroon}(\color{clBlack}' + S +
          '\color{clMaroon})\color{clBlue} : \color{clBlack}' + Token.Flag + ';';
      end;
    tkConstructor:
      begin
        S := GetFuncProto(Token);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '\color{clMaroon}(\color{clBlack}' + S +
          '\color{clMaroon});';
      end;
    tkDestructor:
      begin
        S := GetFuncProto(Token);
        Result := CompletionColors[Token.Token] + Token.Name + '\style{-B}' +
          '\color{clMaroon}(\color{clBlack}' + S +
          '\color{clMaroon});';
      end;
    tkDefine:
      begin
        if Length(Token.Flag) > 0 then
          Result := CompletionColors[Token.Token] + Token.Name +
            '\style{-B} : ' + Trim(Token.Flag) + ';'
        else
          Result := CompletionColors[Token.Token] + Token.Name + '\style{-B};';
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
            Params := '\color{clMaroon}[\color{clGreen}' + Params + '\color{clMaroon}]\color{clBlack}';
          end;
        end;

        S := CompletionColors[Token.Token];
        if GetFirstWord(TypeName) = 'const' then
        begin
          S := CompletionColors[TTkType(17)];
          TypeName := GetAfterWord(TypeName);
        end;
        Result := S + Token.Name + '\style{-B}' + Params + ' : ' + TypeName + ';';
      end;
    tkTypedef, tkTypeStruct, tkTypeUnion, tkTypeEnum:
      begin
        S := ';';
        if Length(Token.Flag) > 0 then
          S := ' : ' + Token.Flag + ';';
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
          '\color{clMaroon}(\color{clBlack}' + Params +
          '\color{clMaroon})(\color{clBlack}' + S +
          '\color{clMaroon})\color{clBlue} : \color{clBlack}' + TypeName + ';';
      end;
    tkStruct:
      begin
        Result := CompletionColors[Token.Token] + Token.Name +
          '\style{-B} : struct;';
      end;
    tkEnum:
      begin
        Result := CompletionColors[Token.Token] + Token.Name +
          '\style{-B} : enum;';
      end;
    tkUnion:
      begin
        Result := CompletionColors[Token.Token] + Token.Name +
          '\style{-B} : union;';
      end;
    tkNamespace:
      begin
        Result := CompletionColors[Token.Token] + Token.Name +
          '\style{-B};';
      end;
    tkEnumItem:
      begin
        S := ';';
        if Length(Token.Flag) > 0 then
          S := ' : ' + Token.Flag + ';';
        Result := CompletionColors[TTkType(17)] + Token.Name + '\style{-B}' + S;
      end;
    tkUnknow: Result := CompletionColors[Token.Token] +
      Token.Name + '\style{-B}' + ' : ' + Token.Flag + ';';
    tkForward:
      begin
        if Token.Flag = 'struct' then
          Result := CompletionColors[tkStruct] + Token.Name + '\style{-B} : struct;'
        else
          Result := CompletionColors[tkClass] + Token.Name + '\style{-B} : class;';
      end;
  end;
end;

function CompletionInsertItem(Token: TTokenClass): string;
begin
  Result := Token.Name;
  case Token.Token of
    tkFunction, tkConstructor, tkDestructor, tkPrototype, tkVariable, tkClass,
      tkDefine, tkTypedefProto, tkTypedef,
      tkTypeStruct, tkTypeUnion, tkStruct, tkEnum, tkNamespace,
      tkUnion, tkUnknow: Result := Token.Name;
  end;
end;

function GetTreeHierarchy(Token: TTokenClass): string;
var
  Next: TTokenClass;
  Separator: string;
begin
  Result := '';
  Separator := '.';
  Next := Token;
  if (Next.Token = tkClass) then
      Separator := '::';
  {while}if Assigned(Next.Parent) and not (Next.Parent.Token in [tkIncludeList,
    tkDefineList, tkTreeObjList,
      tkVarConsList, tkFuncProList,
      tkFunction, tkConstructor, tkDestructor,
      tkRoot, tkParams, tkScope {?}]) {do} then
  begin
    Next := Next.Parent;
    if (Next.Token = tkScopeClass) and Assigned(Next.Parent) then
    begin
      Separator := '::';
      Next := Next.Parent;
    end
    else if (Next.Token = tkNamespace) then
      Separator := '::';
    Result := Next.Name + Separator + Result;
  end;
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
    while not (ptr^ in [#0, '.', '-', '>', ':']) do
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
    if (ptr^ in ['.', '~', '-']) or (ptr^ = ':') and ((ptr + 1)^ = ':') then
    begin
      if Length(Field) > 0 then
        List.Add(Field);
      if ptr^ in ['.', '~'] then
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
    tkFunction, tkPrototype, tkConstructor, tkDestructor:
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
    tkFunction, tkPrototype, tkConstructor, tkTypedefProto:
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
            until (ptr^ in [#0, #10]) or (Current >= Init);
          end;
        end;
      '"':
        begin
          repeat
            Inc(ptr);
            Inc(Current);
          until (ptr^ = #0) or (Current >= Init) or (ptr^ = '"');
          if ptr^ = #0 then
            Break;
        end;
      '''':
        begin
          repeat
            Inc(ptr);
            Inc(Current);
          until (ptr^ = #0) or (Current >= Init) or (ptr^ = '''');
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
    if (RLen > 0) and not (S[I] in LetterChars + DigitChars) then
      Break
    else if (S[I] in LetterChars + DigitChars) then
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
    if (RLen > 0) and not (S[I] in LetterChars + DigitChars) then
      Break
    else if (S[I] in LetterChars + DigitChars) then
      Inc(RLen);
    Inc(I);
  end;
  Result := Trim(Copy(S, I, Len - I + 1));
end;

procedure GetDescendants(const S: string; List: TStrings; scope: TScopeClass);
var
  sc, Temp, ancs: string;
begin
  List.Clear;
  Temp := S;
  sc := GetFirstWord(S);
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
  Chars: set of Char;
begin
  Result := '';
  RLen := 0;
  Len := Length(S);
  Chars := LetterChars + DigitChars;
  if AllowScope then
    Chars := Chars + [':'];
  while (Len > 0) do
  begin
    if (RLen > 0) and not (S[Len] in Chars) then
      Break
    else if (S[Len] in Chars) then
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
    if (RLen > 0) and not (S[Len] in LetterChars + DigitChars) then
      Break
    else if (S[Len] in LetterChars + DigitChars) then
      Inc(RLen);
    Dec(Len);
  end;
  Result := Trim(Copy(S, 1, Len));
end;

function GetVarType(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  I := Pos('[', Result);
  if I > 0 then
    Result := Copy(Result, 1, I - 1);
  Result := GetLastWord(Result, True);
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
    if (RLen > 0) and not (S[I] in LetterChars + DigitChars) then
    begin
      RLen := 0;
      Inc(Result);
    end
    else if (S[I] in LetterChars + DigitChars) then
    begin
      Inc(RLen);
    end;
    Inc(I);
  end;
  if (Len > 0) and (S[Len] in LetterChars + DigitChars) then
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
  if not (ptr^ in DigitChars + ['b']) then
    Exit;
  Inc(ptr);
  if ptr^ in ['x', 'X'] then
    Inc(ptr);
  while (ptr^ <> #0) and (ptr^ in DigitChars + HexChars + ['L']) do
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
  if not (ptr^ in LetterChars) then
    Exit;
  while (ptr^ <> #0) and (ptr^ in LetterChars + DigitChars) do
    Inc(ptr);
  Result := ptr^ = #0;
end;

function SkipStringInv(const init: PChar; var ptr: PChar): Boolean;
begin
  if ptr^ = '"' then
    Dec(ptr);
  while (ptr >= init) and (ptr^ <> #10) and ((ptr^ <> '"') or
    (((ptr - 1)^ = '\') and (ptr^ = '"'))) do
    Dec(ptr);
  Result := (ptr^ = '"');
end;

function SkipSingleQuotesInv(const init: PChar; var ptr: PChar): Boolean;
begin
  if ptr^ = '''' then
    Dec(ptr);
  while (ptr >= init) and ((ptr^ <> '''') or (((ptr - 1)^ = '\') and
    (ptr^ = ''''))) do
    Dec(ptr);
  Result := (ptr^ = '''');
end;

function SkipMultlineCommentInv(const init: PChar; var ptr: PChar): Boolean;
begin
  if (ptr - 1)^ = '*' then
    Dec(ptr);
  repeat
    Dec(ptr);
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
      end;
    end;
    Dec(ptr);
  until (ptr < init) or (pair_count = 0);
  Result := pair_count = 0;
end;

function GetNextValidChar(const Text: string; SelStart: Integer): Char;
var
  ptr, init: PChar;
begin
  init := PChar(Text);
  ptr := init + SelStart;
  while (ptr^ <> #0) and (ptr^ in LetterChars + DigitChars) do
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
          while not (ptr^ in [#0] + LineChars) do
            Inc(ptr);
        end
        else
          Break;
    else
      if not (ptr^ in LineChars + SpaceChars) then
        Break;
    end;
    Inc(ptr);
  until (ptr^ = #0) or not (ptr^ in ['/'] + LineChars + SpaceChars);
  Result := ptr^;
end;

function ParseFields(const Text: string; SelStart: Integer;
  var S, Fields: string; var InputError: Boolean): Boolean;
var
  ptr, init: PChar;
  skipSpace: Boolean;
  str, field, sep, _fields: string;
begin
  Result := False;
  InputError := False;
  init := PChar(Text);
  ptr := init + SelStart;
  str := '';
  skipSpace := False;
  if (ptr^ in LetterChars + DigitChars) then
  begin
    skipSpace := True;
    //get string after selstart
    repeat
      str := str + ptr^;
      Inc(ptr);
    until (ptr^ = #0) or not (ptr^ in LetterChars + DigitChars);
  end;
  ptr := init + SelStart - 1;
  //get string before selstart
  while not skipSpace and (ptr >= init) and (ptr^ in LineChars + SpaceChars) do
    Dec(ptr); //comment
  if (ptr^ in LetterChars + DigitChars) then
  begin
    repeat
      str := ptr^ + str;
      Dec(ptr);
    until (ptr < init) or not (ptr^ in LetterChars + DigitChars);
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
  repeat
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
            SkipMultlineCommentInv(init, ptr);
      else
        if not (ptr^ in LineChars + SpaceChars) then
          Break;
      end;
      Dec(ptr);
    until ptr < init;
    if (ptr < init) or ((sep = '') {and (str <> '')}) or
      ((field <> '') and (sep = '')) then
      Break;
    //skipspace
    while (ptr >= init) and (ptr^ in LineChars + SpaceChars) do
      Dec(ptr); //comment
    if not (ptr^ in LetterChars + DigitChars + [')', ']', '/']) then
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
    field := '';
    repeat
      case ptr^ of
        ')': SkipInvPair(init, ptr, '(', ')');
        ']': SkipInvPair(init, ptr, '[', ']');
        '/':
          if (ptr = init) or ((ptr - 1)^ <> '*') then
            SkipMultlineCommentInv(init, ptr)
          else
          begin
            if sep <> '::' then
              InputError := True; //;.blabla
            Exit; //syntax error     /->blabla /.blabla /::blabla
          end
        else
          field := ptr^ + field;
      end;
      Dec(ptr);
    until (ptr < init) or not (ptr^ in LetterChars + DigitChars);
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

function GetFirstOpenBrace(const S: string; QuoteChar: Char;
  var SelStart: Integer): Boolean;
var
  init, ptr, skip: PChar;
begin
  Result := False;
  init := PChar(S);
  ptr := init + SelStart;
  if (ptr^ in ['(', ')', ';', '{', '}']) and (QuoteChar = #0) then
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
    while (ptr^ <> '(') and (ptr >= init) do
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
        ;
      end;
      Dec(ptr);
    end;
    skip := ptr;
    if ptr^ <> '(' then
      Exit;
    Dec(skip);
    while (skip >= init) and (skip^ in LineChars + SpaceChars) do
    begin
      Dec(skip);
      case skip^ of
        '/':
          if (ptr > init) and ((ptr - 1)^ = '*') then
            SkipMultlineCommentInv(init, skip);
      end;
    end;
    if skip^ in LetterChars + DigitChars then
      Break;
    ptr := skip;
  until ptr <= init;
  if ptr^ <> '(' then
    Exit;
  SelStart := ptr - init;
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

end.
