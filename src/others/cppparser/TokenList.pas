unit TokenList;

interface

uses
  Classes, Dialogs;

const
  Sign: array[0..6] of AnsiChar = ('F', 'C', 'P', ' ', '3', '.', '6');

type
  TTkType = (
    tkClass,
    tkFunction,
    tkPrototype,
    tkOperator,
    tkConstructor,
    tkDestructor,
    tkInclude,
    tkDefine,
    tkVariable,
    tkTypedef,
    tkTypedefProto,
    tkStruct,
    tkTypeStruct,
    tkEnum,
    tkTypeEnum,
    tkUnion,
    tkTypeUnion,
    tkNamespace,
    tkEnumItem,
    tkForward,
    tkFriend,
    tkUnknow,
    //********
    tkIncludeList,
    tkDefineList,
    tkTreeObjList,
    tkVarConsList,
    tkFuncProList,
    //*******
    tkRoot,
    tkParams,
    tkScope,
    tkScopeClass,
    tkUsing,
    tkValue,
    tkTemplate,
    tkCodeTemplate
    );

  TTokenSearchMode = set of TTkType;

type

  TRange = record
    Line: Integer;
    Start: Integer;
    Count: integer;
  end;

  TNodeObject = class
  public
    ImageIndex: Integer;
    Caption: string;
    Data: Pointer;
  end;

  PTokenRec = ^TTokenRec;
  PTokenRecList = ^PTokenRec;
  TTokenRec = packed record
    Token: TTkType; //Type of Object
    Count: Integer; //quantity of Child
    Line: Integer; //Line of word
    Start: Integer; //Start of word in file
    SelLen: Integer; //Length of Selection
    Level: Integer; // level of statement { {
    LenName: Integer; //Length of Name
    LenFlag: Integer; //Length of Flag
    LenComment: Integer; //Length of Comment
    Name: string; // name of token
    Flag: string; // flag of token
    Comment: string; // comment
    Items: PTokenRecList; //Child objects
  end;

  TSimpleFileToken = packed record
    Sign: array[0..6] of AnsiChar; //signature: FCP 1.0 -- Falcon C++ Parser version 1.0
    Count: Integer; //quantity files parsed (TTokenFile)
    DateOfFile: TDateTime;
  end;

  TTokenClass = class; //forward

  TTokenClass = class
  private
    FList: TList;
    FParent: TTokenClass;
    FOwner: Pointer;
    FSelLine: Integer;
    FSelLength: Integer;
    FSelStart: Integer;
    FToken: TTkType;
    FName: string;
    FFlag: string;
    FComment: string;
    FLevel: Integer;
    FData: Pointer;
    function Get(Index: Integer): TTokenClass;
    procedure Put(Index: Integer; Value: TTokenClass);
    procedure AssignRecursive(Ato, ACopy, Parent: TTokenClass);
    function GetTokenAtRecursive(var scopeToken: TTokenClass;
      SelStart, SelLine: Integer; Finded: Boolean): Boolean;
    function GetCount: Integer;
  public
    constructor Create(Parent: TTokenClass); overload;
    constructor Create; overload;
    procedure Assign(AObject: TObject);
    procedure AssignProperty(AObject: TObject);
    destructor Destroy; override;
    function Add(Item: TTokenClass): Integer;
    procedure Fill(SelLine: Integer; SelLength: Integer; SelStart: Integer;
      Level: Integer; Token: TTkType; Name: string; Flag: string;
      Comment: string);
    procedure Clear;
    procedure Delete(Index: Integer);
    function Remove(Item: TTokenClass): Integer;
    function IndexOf(Item: TTokenClass): Integer;
    function GetTokenAt(var scopeToken: TTokenClass;
      SelStart: Integer; SelLine: Integer): Boolean;
    function GetScopeAt(var scopeToken: TTokenClass;
      SelStart: Integer): Boolean;
    procedure GetUsingNames(List: TStrings; UntilPosition: Integer = 0);
    procedure GetFunctions(List: TStrings; const ScopeFlag: string;
      UseScope: Boolean = False; MakeCopy: Boolean = True;
      OnlyPrototype: Boolean =  False);
    function GetPreviousFunction(var Token: TTokenClass;
      SelStart: Integer = 0): Boolean;
    function GetNextFunction(var Token: TTokenClass;
      SelStart: Integer = 0): Boolean;
    function Copy: TTokenClass;
    function SearchToken(const S, ScopeFlag: string; var Item: TTokenClass;
      NotAtSelStart: Integer = 0; AdvanceAfterSelStart: Boolean = False;
      Mode: TTokenSearchMode = []): Boolean;
    function SearchSource(const S: string; var Item: TTokenClass;
      NotAtSelStart: Integer = 0; AdvanceAfterSelStart: Boolean = False;
      ListAll: TStrings = nil; AllFunctions: Boolean = False): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTokenClass read Get write Put;

    property Owner: Pointer read FOwner write FOwner;
    property Parent: TTokenClass read FParent write FParent;
    property SelLine: Integer read FSelLine write FSelLine;
    property SelLength: Integer read FSelLength write FSelLength;
    property SelStart: Integer read FSelStart write FSelStart;
    property Token: TTkType read FToken write FToken;
    property Name: string read FName write FName;
    property Flag: string read FFlag write FFlag;
    property Comment: string read FComment write FComment;
    property Level: Integer read FLevel write FLevel;
    property Data: Pointer read FData write FData;
  end;

  TTokenList = class
  private
    FList: TList;
  public
    function Add(Item: TTokenClass): Integer;
    function Exist(Item: TTokenClass): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses SysUtils, TokenUtils;

{TTokenClass}

constructor TTokenClass.Create(Parent: TTokenClass);
begin
  inherited Create;
  FParent := Parent;
  if Assigned(Parent) then
    FOwner := Parent.FOwner;
  FList := TList.Create;
  Token := tkUnknow;
end;

constructor TTokenClass.Create;
begin
  inherited Create;
  FParent := nil;
  FData := nil;
  FList := TList.Create;
  Token := tkUnknow;
end;

destructor TTokenClass.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTokenClass.AssignRecursive(Ato, ACopy, Parent: TTokenClass);
var
  NewObj: TTokenClass;
  I: Integer;
begin
  NewObj := TTokenClass.Create(Parent);
  NewObj.FSelLine := ACopy.FSelLine;
  NewObj.FSelLength := ACopy.FSelLength;
  NewObj.FSelStart := ACopy.FSelStart;
  NewObj.FToken := ACopy.FToken;
  NewObj.FName := ACopy.FName;
  NewObj.FFlag := ACopy.FFlag;
  NewObj.FComment := ACopy.FComment;
  NewObj.FLevel := ACopy.FLevel;
  NewObj.FData := ACopy.FData;
  NewObj.FOwner := ACopy.FOwner;
  Ato.Add(NewObj);
  for I := 0 to ACopy.Count - 1 do
    AssignRecursive(NewObj, ACopy.Items[I], NewObj);
end;

procedure TTokenClass.Assign(AObject: TObject);
var
  NewObj: TTokenClass;
  I: Integer;
begin
  NewObj := TTokenClass(AObject);
  if not Assigned(NewObj) then
    Exit;
  if not (NewObj is TTokenClass) then
    Exit;
  Clear;
  FParent := NewObj.FParent;
  AssignProperty(AObject);
  for I := 0 to NewObj.Count - 1 do
    AssignRecursive(Self, NewObj.Items[I], Self);
end;

procedure TTokenClass.AssignProperty(AObject: TObject);
var
  NewObj: TTokenClass;
begin
  NewObj := TTokenClass(AObject);
  if not Assigned(NewObj) then
    Exit;
  if not (NewObj is TTokenClass) then
    Exit;
  FOwner := NewObj.FOwner;
  FSelLine := NewObj.FSelLine;
  FSelLength := NewObj.FSelLength;
  FSelStart := NewObj.FSelStart;
  FToken := NewObj.FToken;
  FName := NewObj.FName;
  FFlag := NewObj.FFlag;
  FComment := NewObj.FComment;
  FLevel := NewObj.FLevel;
  FData := NewObj.FData;
end;

function TTokenClass.Get(Index: Integer): TTokenClass;
begin
  Result := TTokenClass(FList.Items[Index]);
end;

procedure TTokenClass.Put(Index: Integer; Value: TTokenClass);
begin
  Items[Index].Free;
  FList.Insert(Index, Value);
end;

function TTokenClass.Add(Item: TTokenClass): Integer;
begin
  Item.FOwner := FOwner;
  Item.Parent := Self;
  Result := FList.Add(Item);
end;

procedure TTokenClass.Fill(SelLine: Integer; SelLength: Integer;
  SelStart: Integer; Level: Integer; Token: TTkType; Name: string;
  Flag: string; Comment: string);
begin
  FSelLine := SelLine;
  FSelLength := SelLength;
  FSelStart := SelStart;
  FToken := Token;
  FName := Name;
  FFlag := Flag;
  FLevel := Level;
  FComment := Comment;
end;

procedure TTokenClass.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TTokenClass(FList.Items[I]).Free;
  FList.Clear;
end;

function TTokenClass.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TTokenClass.Delete(Index: Integer);
begin
  Items[Index].Free;
  FList.Delete(Index);
end;

function TTokenClass.Remove(Item: TTokenClass): Integer;
begin
  Result := IndexOf(Item);
  if Result >= 0 then
    Delete(Result);
end;

function TTokenClass.IndexOf(Item: TTokenClass): Integer;
begin
  Result := FList.IndexOf(Item);
end;

function TTokenClass.GetScopeAt(var scopeToken: TTokenClass;
  SelStart: Integer): Boolean;
var
  I: Integer;
  scope: TTokenClass;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    //don't search at bottom, no found
    if (Items[I].SelStart > SelStart) and not (Items[I].Token in [tkTypeStruct,
      tkTypeUnion, tkTypeEnum]) then
      Exit;
    if (Items[I].Token in [tkClass, tkStruct, tkFunction, tkOperator, tkConstructor,
      tkDestructor, tkNamespace, tkUnion, tkEnum, tkTypeEnum, tkTypeStruct,
        tkTypeUnion]) then
    begin
      scope := GetTokenByName(Items[I], 'Scope', tkScope);
      if assigned(scope) and (SelStart >= scope.SelStart) and
        (SelStart <= (scope.SelStart + scope.SelLength)) then
      begin
        scopeToken := Items[I];
        Result := True;
        //Depth aproximate
        Items[I].GetScopeAt(scopeToken, SelStart);
        Exit;
      end;
    end;
    //not have Scope token
    if (Items[I].Token in [tkScopeClass]) then
    begin
      if Items[I].GetScopeAt(scopeToken, SelStart) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TTokenClass.GetTokenAtRecursive(var scopeToken: TTokenClass;
  SelStart, SelLine: Integer; Finded: Boolean): Boolean;
var
  I: Integer;
begin
  Result := Finded;
  for I := 0 to Count - 1 do
  begin
    //don't search at bottom, no found
    if (SelLine > 0) and (Items[I].SelLine > SelLine) and
      not (Items[I].Token in [tkTypeStruct, tkTypeUnion, tkTypeEnum]) then
      Exit;
    if not (Items[I].Token in [tkScopeClass, tkScope]) then
    begin
      if ((SelStart >= Items[I].SelStart) and
        (SelStart <= (Items[I].SelStart + Items[I].SelLength))) or
        ((SelLine > 0) and (Items[I].SelLine = SelLine) and not Result) then
      begin
        scopeToken := Items[I];
        Result := True;
      end;
    end;
    if Items[I].Token in [tkFunction, tkPrototype, tkOperator, tkParams, tkScopeClass,
      tkClass, tkStruct, tkUnion, tkEnum, tkConstructor, tkDestructor,
      tkNamespace, tkTypeStruct, tkTypeUnion, tkTypeEnum] then
    begin
      if Items[I].GetTokenAtRecursive(scopeToken, SelStart, SelLine, Result) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TTokenClass.GetUsingNames(List: TStrings; UntilPosition: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if (UntilPosition > 0) and (UntilPosition >= Items[I].FSelStart) and
      (UntilPosition <= (Items[I].FSelStart + Items[I].FSelLength)) then
    begin
      if (Items[I].Token <> tkScope) then
        Exit;
      Continue;
    end;
    if (Items[I].Token = tkUsing) then
      List.Add(Items[I].Name)
    else if Items[I].Token in [tkFunction, tkOperator, tkScopeClass,
      tkClass, tkStruct, tkUnion, tkConstructor, tkDestructor,
      tkNamespace, tkTypeStruct, tkTypeUnion] then
    begin
      Items[I].GetUsingNames(List, UntilPosition);
    end;
  end;
end;

function TTokenClass.GetTokenAt(var scopeToken: TTokenClass;
  SelStart: Integer; SelLine: Integer): Boolean;
begin
  Result := GetTokenAtRecursive(scopeToken, SelStart, SelLine, False);
end;

procedure TTokenClass.GetFunctions(List: TStrings; const ScopeFlag: string;
  UseScope, MakeCopy, OnlyPrototype: Boolean);
var
  I: Integer;
  scope: TTokenClass;
  Mode: TTokenSearchMode;
begin
  Mode := [tkDestructor, tkConstructor, tkOperator];
  if OnlyPrototype then
    Mode := Mode + [tkPrototype]
  else
    Mode := Mode + [tkFunction];
  for I := 0 to Count - 1 do
  begin
    if (Items[I].Token in Mode) then
    begin
      if (Items[I].Token in [tkDestructor, tkConstructor]) then
      begin
        scope := GetTokenByName(Items[I], 'Scope', tkScope);
        if OnlyPrototype then
        begin
          if Assigned(scope) then
            Continue;
        end
        else if not Assigned(scope) or (UseScope and (Scope.Flag <> ScopeFlag)) then
          Continue;
      end
      else
      begin
        if UseScope and not OnlyPrototype then
        begin
          scope := GetTokenByName(Items[I], 'Scope', tkScope);
          if not Assigned(scope) or (UseScope and (Scope.Flag <> ScopeFlag)) then
            Continue;
        end;
      end;
      if MakeCopy then
        List.AddObject('', Items[I].Copy)
      else
        List.AddObject('', Items[I]);
    end
    else if Items[I].Token in [tkNamespace, tkClass, tkScopeClass] then
      Items[I].GetFunctions(List, ScopeFlag, UseScope, MakeCopy, OnlyPrototype);
  end;
end;

function TTokenClass.Copy: TTokenClass;
begin
  Result := TTokenClass.Create(Parent);
  Result.Assign(Self);
end;

function TTokenClass.SearchToken(const S, ScopeFlag: string; var Item: TTokenClass;
  NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean;
  Mode: TTokenSearchMode): Boolean;
var
  I: Integer;
  Scope: TTokenClass;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if (NotAtSelStart > 0) and (NotAtSelStart >= Items[I].FSelStart) and
      (NotAtSelStart <= (Items[I].FSelStart + Items[I].FSelLength)) then
    begin
      if not AdvanceAfterSelStart and (Items[I].Token <> tkScope) then
        Exit;
      Continue;
    end;
    if (S = Items[I].Name) and (Items[I].Token in Mode) then
    begin
      if ScopeFlag <> '' then
      begin
        Scope := GetTokenByName(Items[I], 'Scope', tkScope);
        if Assigned(Scope) and (Scope.Flag = ScopeFlag) then
        begin
          Item := Items[I];
          Result := True;
          Exit;
        end;
      end
      else
      begin
        Item := Items[I];
        Result := True;
        Exit;
      end;
    end;
    if Items[I].Token in [tkEnum, tkTypeEnum, tkParams, tkScopeClass] then
    begin
      if Items[I].SearchToken(S, ScopeFlag, Item, NotAtSelStart, AdvanceAfterSelStart, Mode) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TTokenClass.SearchSource(const S: string; var Item: TTokenClass;
  NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean; ListAll: TStrings;
  AllFunctions: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if (NotAtSelStart > 0) and (NotAtSelStart >= Items[I].FSelStart) and
      (NotAtSelStart <= (Items[I].FSelStart + Items[I].FSelLength)) then
    begin
      if not AdvanceAfterSelStart and not
        (Items[I].Token in [tkScope, tkTypedef, tkForward, tkFriend]) then
        Exit;
      Continue;
    end;
    if (S = Items[I].Name) and (not (Items[I].Token in
      [tkConstructor, tkDestructor, tkForward, tkUsing, tkFriend]) or (Assigned(Items[I].Parent) and
      (Items[I].Parent.Token = tkScopeClass))) then
    begin
      Item := Items[I];
      Result := True;
      if not AllFunctions then
        Exit
      else if (Items[I].Token in [tkConstructor, tkFunction, tkPrototype, tkOperator,
        tkTypedefProto]) then
        ListAll.AddObject('', Item);
    end;
    if Items[I].Token in [tkEnum, tkTypeEnum, tkParams, tkScopeClass] then
    begin
      if Items[I].SearchSource(S, Item, NotAtSelStart, AdvanceAfterSelStart,
        ListAll, AllFunctions) then
      begin
        Result := True;
        if not AllFunctions then
          Exit;
      end;
    end;
  end;
end;

function TTokenClass.GetPreviousFunction(var Token: TTokenClass;
  SelStart: Integer): Boolean;
var
  I: Integer;
  PrevFunc: TTokenClass;
  scope: TTokenClass;
begin
  PrevFunc := nil;
  for I := 0 to Count - 1 do
  begin
    if (Items[I].Token in [tkDestructor, tkConstructor, tkFunction, tkOperator]) then
    begin
      scope := GetTokenByName(Items[I], 'Scope', tkScope);
      if Assigned(scope) then
      begin
        if ((scope.SelStart <= SelStart) and
          (scope.SelStart + scope.SelLength >= SelStart)) or
          (scope.SelStart + scope.SelLength > SelStart) then
          Break;
        PrevFunc := Items[I];
      end;
    end;
    if Items[I].Token in [tkNamespace, tkClass, tkScopeClass] then
    begin
      if Items[I].GetPreviousFunction(Token, SelStart) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  if PrevFunc <> nil then
  begin
    Token := PrevFunc;
    Result := True;
  end
  else
    Result := False;
end;

function TTokenClass.GetNextFunction(var Token: TTokenClass;
  SelStart: Integer): Boolean;
var
  I: Integer;
  scope: TTokenClass;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if (Items[I].Token in [tkDestructor, tkConstructor, tkFunction, tkOperator]) then
    begin
      scope := GetTokenByName(Items[I], 'Scope', tkScope);
      if Assigned(scope) and (SelStart < scope.SelStart) then
      begin
        Token := Items[I];
        Result := True;
        Break;
      end;
    end;
    if Items[I].Token in [tkNamespace, tkClass, tkScopeClass] then
    begin
      if Items[I].GetNextFunction(Token, SelStart) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

{TTokenList}

function TTokenList.Add(Item: TTokenClass): Integer;
begin
  Result := FList.Add(Item);
end;

function TTokenList.Exist(Item: TTokenClass): Boolean;
var
  I: Integer;
  Token: TTokenClass;
  S1, S2: string;
begin
  Result := True;
  if Item.Token in [tkFunction, tkPrototype, tkConstructor, tkDestructor, tkOperator] then
  begin
    S1 := GetFuncProtoTypes(Item);
    for I := 0 to FList.Count - 1 do
    begin
      Token := TTokenClass(FList.Items[I]);
      if not (Item.Token in [tkFunction, tkPrototype, tkConstructor,
        tkDestructor, tkOperator]) then
        Continue;
      if (Token.Name <> Item.Name) or (Token.Flag <> Item.Flag) then
        Continue;
      S2 := GetFuncProtoTypes(Token);
      if S2 = S1 then
        Exit;
    end;
  end
  else
  begin
    for I := 0 to FList.Count - 1 do
    begin
      Token := TTokenClass(FList.Items[I]);
      if (Token.Name = Item.Name) and (Token.Flag = Item.Flag) then
        Exit;
    end;
  end;
  Result := False;
end;

constructor TTokenList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTokenList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

end.
