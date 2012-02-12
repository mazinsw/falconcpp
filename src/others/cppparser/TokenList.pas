unit TokenList;

interface

uses
  Classes, Dialogs;

const
  Sign = 'FCP 2.2';

type
  TTkType = (
    tkClass,
    tkFunction,
    tkPrototype,
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
    tkUsing
  );

  TTokenSearchMode = set of TTkType;

type

  TRange = record
    Line: Integer;
    Start: Integer;
    Count: integer;
  end;

  PTokenRec = ^TTokenRec;
  PTokenRecList = ^PTokenRec;
  TTokenRec = packed record
    Count: Word; //quantity of Child
    Line:  Integer; //Line of word
    Start: Integer; //Start of word in file
    SelLen: Word; //Length of Selection
    Level: Word;
    ScopeStart: Integer;
    ScopeEnd: Integer;
    Token: TTkType; //Type of Object
    Len1 : Word; //Length of Name
    Name : String;
    Len2 : Word; //Length of Flag
    Flag : String;
    Items: PTokenRecList; //Child objects
  end;

  TSimpleFileToken = packed record
    Sign: array[0..6] of Char;//signature: FCP 1.0 -- Falcon C++ Parser version 1.0
    Count: Word;      //quantity files parsed (TTokenFile)
    DateOfFile: TDateTime;
  end;

  TTokenClass = class;//forward

  TTokenClass = class
  private
    FList: TList;
    FParent: TTokenClass;
    FOwner: Pointer;
    FSelLine: Integer;
    FSelLength: Integer;
    FSelStart: Integer;
    FToken: TTkType;
    FName: String;
    FFlag: String;
    FLevel: Integer;
    FData: Pointer;
    function Get(Index: Integer): TTokenClass;
    procedure Put(Index: Integer; Value: TTokenClass);
    procedure AssignRecursive(Ato, ACopy, Parent: TTokenClass);
    {procedure ConvertToTokenRecRecursive(TokenRec: PTokenRec; ACopy: TTokenClass);
    procedure LoadFromTokenRecRecursive(TokenRec: PTokenRec; Parent: TTokenClass);}
    function GetTokenAtRecursive(var scopeToken: TTokenClass;
      SelStart, SelLine: Integer; Finded: Boolean): Boolean;
  public
    constructor Create(Parent: TTokenClass); overload;
    constructor Create; overload;
    procedure Assign(AObject: TObject);
    procedure AssignProperty(AObject: TObject);
    //function ConvertToTokenRec: PTokenRec;
    //procedure LoadFromTokenRec(TokenRec: PTokenRec);
    destructor Destroy; override;
    function Add(Item: TTokenClass): Integer;
    procedure Fill( SelLine: Integer;
                    SelLength: Integer;
                    SelStart: Integer;
                    Level: Integer;
                    Token: TTkType;
                    Name: String;
                    Flag: String
                   );
    procedure Clear;
    function Count: Integer;
    procedure Delete(Index: Integer);
    function Remove(Item: TTokenClass): Integer;
    function IndexOf(Item: TTokenClass): Integer;
    function GetTokenAt(var scopeToken: TTokenClass;
      SelStart: Integer; SelLine: Integer): Boolean;
    function GetScopeAt(var scopeToken: TTokenClass;
      SelStart: Integer): Boolean;
    procedure GetFunctions(List: TStrings);
    function GetPreviousFunction(var Token: TTokenClass;
      SelStart: Integer = 0): Boolean;
    function GetNextFunction(var Token: TTokenClass;
      SelStart: Integer = 0): Boolean;
    function Copy: TTokenClass;
    function SearchToken(const S: String; var Item: TTokenClass;
      NotAtSelStart: Integer = 0; AdvanceAfterSelStart: Boolean = False;
      Mode: TTokenSearchMode = []): Boolean;
    function SearchSource(const S: String; var Item: TTokenClass;
      NotAtSelStart: Integer = 0; AdvanceAfterSelStart: Boolean = False;
      ListAll: TStrings = nil; AllFunctions: Boolean = False): Boolean;
    property Items[Index: Integer]: TTokenClass read Get write Put;
    {*** manipulate ***}
    property Owner: Pointer read FOwner write FOwner;
    property Parent: TTokenClass read FParent write FParent;
    property SelLine: Integer read FSelLine write FSelLine;
    property SelLength: Integer read FSelLength write FSelLength;
    property SelStart: Integer read FSelStart write FSelStart;
    property Token: TTkType read FToken write FToken;
    property Name: String read FName write FName;
    property Flag: String read FFlag write FFlag;
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

{  procedure AddTokenChild(Token, Child: PTokenRec);
  procedure FillToken(Token: PTokenRec;
                      Line: Integer; //Line of word in file
                      Start: Integer; //Start of word in file
                      SelLen: Word; //Length of Selection
                      Level: Word; //Level of block
                      TkType: TTkType; //Type of Object
                      Name : String;
                      Flag : String
                    );
  function NewToken: PTokenRec;
  procedure FreeToken(Token: PTokenRec);
  procedure SaveToken(const FileName: String; Token: PTokenRec);
  function LoadToken(const FileName: String): PTokenRec;


  procedure SaveFileParsedToken(const FileName: String;
                                FileDate: TDateTime;
                                Token: array of PTokenRec);
  function LoadFileParsed(const FileName: String; var Token: PTokenRec): Boolean;}
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
  NewObj.FLevel := ACopy.FLevel;
  NewObj.FData := ACopy.FData;
  NewObj.FOwner := ACopy.FOwner;
  Ato.Add(NewObj);
  for I:= 0 to ACopy.Count - 1 do
    AssignRecursive(NewObj, ACopy.Items[I], NewObj);
end;

procedure TTokenClass.Assign(AObject: TObject);
var
  NewObj: TTokenClass;
  I: Integer;
begin
  NewObj := TTokenClass(AObject);
  if not Assigned(NewObj) then Exit;
  if not (NewObj is TTokenClass) then Exit;
  Clear;
  FParent := NewObj.FParent;
  FOwner := NewObj.FOwner;
  FSelLine := NewObj.FSelLine;
  FSelLength := NewObj.FSelLength;
  FSelStart := NewObj.FSelStart;
  FToken := NewObj.FToken;
  FName := NewObj.FName;
  FFlag := NewObj.FFlag;
  FLevel := NewObj.FLevel;
  FData := NewObj.FData;
  for I:= 0 to NewObj.Count - 1 do
    AssignRecursive(Self, NewObj.Items[I], Self);
end;

procedure TTokenClass.AssignProperty(AObject: TObject);
var
  NewObj: TTokenClass;
begin
  NewObj := TTokenClass(AObject);
  if not Assigned(NewObj) then Exit;
  if not (NewObj is TTokenClass) then Exit;
  FOwner := NewObj.FOwner;
  FSelLine := NewObj.FSelLine;
  FSelLength := NewObj.FSelLength;
  FSelStart := NewObj.FSelStart;
  FToken := NewObj.FToken;
  FName := NewObj.FName;
  FFlag := NewObj.FFlag;
  FLevel := NewObj.FLevel;
  FData := NewObj.FData;
end;

{procedure TTokenClass.ConvertToTokenRecRecursive(TokenRec: PTokenRec; ACopy: TTokenClass);
var
  I: Integer;
  NewItems: PTokenRecList;
begin
  NewItems := nil;
  FillToken(TokenRec, ACopy.FSelLine, ACopy.FSelStart, ACopy.FSelLength,
    ACopy.FLevel, ACopy.FToken, ACopy.FName, ACopy.FFlag);
  TokenRec^.Count := ACopy.Count;
  if TokenRec^.Count > 0 then
  begin
    GetMem(NewItems, TokenRec^.Count*Sizeof(PTokenRec));
    TokenRec^.Items := NewItems;
  end;

  for I:= 0 to TokenRec^.Count - 1 do
  begin
    NewItems^ := NewToken;
    ConvertToTokenRecRecursive(NewItems^, ACopy.Items[I]);
    Inc(NewItems);
  end;
end;

function TTokenClass.ConvertToTokenRec: PTokenRec;
var
  I: Integer;
  NewItems: PTokenRecList;
begin
  Result := NewToken;
  NewItems := nil;
  FillToken(Result, FSelLine, FSelStart, FSelLength, FLevel, FToken,
    FName, FFlag);
  Result^.Count := Count;
  if Result^.Count > 0 then
  begin
    GetMem(NewItems, Result^.Count*Sizeof(PTokenRec));
    Result^.Items := NewItems;
  end;

  for I:= 0 to Result^.Count - 1 do
  begin
    NewItems^ := NewToken;
    ConvertToTokenRecRecursive(NewItems^, Items[I]);
    Inc(NewItems);
  end;
end;

procedure TTokenClass.LoadFromTokenRecRecursive(TokenRec: PTokenRec; Parent: TTokenClass);
var
  NewObj: TTokenClass;
  I: Integer;
  Items: PTokenRecList;
begin
  NewObj := TTokenClass.Create(Parent);
  NewObj.FSelLine := TokenRec^.Line;
  NewObj.FSelLength := TokenRec^.SelLen;
  NewObj.FSelStart := TokenRec^.Start;
  NewObj.FToken := TokenRec^.Token;
  NewObj.FName := TokenRec^.Name;
  NewObj.FFlag := TokenRec^.Flag;
  NewObj.FLevel := TokenRec^.Level;
  Parent.Add(NewObj);
  Items := TokenRec^.Items;
  for I:= 0 to TokenRec^.Count - 1 do
  begin
    LoadFromTokenRecRecursive(Items^, NewObj);
    Inc(Items);
  end;
end;

procedure TTokenClass.LoadFromTokenRec(TokenRec: PTokenRec);
var
  I: Integer;
  Items: PTokenRecList;
begin
  if not Assigned(TokenRec) then Exit;
  Clear;
  FParent := nil;
  FSelLine := TokenRec^.Line;
  FSelLength := TokenRec^.SelLen;
  FSelStart := TokenRec^.Start;
  FToken := TokenRec^.Token;
  FName := TokenRec^.Name;
  FFlag := TokenRec^.Flag;
  FLevel := TokenRec^.Level;
  Items := TokenRec^.Items;
  for I:= 0 to TokenRec^.Count - 1 do
  begin
    LoadFromTokenRecRecursive(Items^, Self);
    Inc(Items);
  end;
end;}

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

procedure TTokenClass.Fill( SelLine: Integer;
                            SelLength: Integer;
                            SelStart: Integer;
                            Level: Integer;
                            Token: TTkType;
                            Name: String;
                            Flag: String
                           );
begin
   FSelLine := SelLine;
   FSelLength := SelLength;
   FSelStart := SelStart;
   FToken := Token;
   FName := Name;
   FFlag := Flag;
   FLevel := Level;
end;

procedure TTokenClass.Clear;
var
  I: Integer;
begin
  for I:= 0 to FList.Count - 1 do
    TTokenClass(FList.Items[I]).Free;
  FList.Clear;
end;

function TTokenClass.Count: Integer;
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
    if (Items[I].Token in [tkClass, tkStruct, tkFunction, tkConstructor,
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
    if Items[I].Token in [tkFunction, tkPrototype, tkParams, tkScopeClass,
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

function TTokenClass.GetTokenAt(var scopeToken: TTokenClass;
  SelStart: Integer; SelLine: Integer): Boolean;
begin
  Result := GetTokenAtRecursive(scopeToken, SelStart, SelLine, False);
end;

procedure TTokenClass.GetFunctions(List: TStrings);
var
  I: Integer;
  scope: TTokenClass;
begin
  for I := 0 to Count - 1 do
  begin
    if (Items[I].Token in [tkDestructor, tkConstructor, tkFunction]) then
    begin
      if (Items[I].Token in [tkDestructor, tkConstructor]) then
      begin
        scope := GetTokenByName(Items[I], 'Scope', tkScope);
        if Assigned(scope) then
          List.AddObject('', Items[I].Copy);
      end
      else
        List.AddObject('', Items[I].Copy);
    end;
    if Items[I].Token in [tkNamespace, tkClass, tkScopeClass] then
      Items[I].GetFunctions(List);
  end;
end;

function TTokenClass.Copy: TTokenClass;
begin
  Result := TTokenClass.Create(Parent);
  Result.Assign(Self);
end;

function TTokenClass.SearchToken(const S: String; var Item: TTokenClass;
  NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean;
  Mode: TTokenSearchMode): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I:= 0 to Count - 1 do
  begin
    if (NotAtSelStart > 0) and (NotAtSelStart >= Items[I].FSelStart) and
      (NotAtSelStart <= (Items[I].FSelStart + Items[I].FSelLength)) then
    begin
      if not AdvanceAfterSelStart then
        Exit;
      Continue;
    end;
    if (S = Items[I].Name) and (Items[I].Token in Mode) then
    begin
      Item := Items[I];
      Result := True;
      Exit;
    end;
    if Items[I].Token in [tkEnum, tkTypeEnum, tkParams, tkScopeClass] then
    begin
      if Items[I].SearchToken(S, Item, NotAtSelStart, AdvanceAfterSelStart, Mode) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TTokenClass.SearchSource(const S: String; var Item: TTokenClass;
  NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean; ListAll: TStrings;
  AllFunctions: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I:= 0 to Count - 1 do
  begin
    if (NotAtSelStart > 0) and (NotAtSelStart >= Items[I].FSelStart) and
      (NotAtSelStart <= (Items[I].FSelStart + Items[I].FSelLength)) then
    begin
      if not AdvanceAfterSelStart and (Items[I].Token <> tkScope)  then
        Exit;
      Continue;
    end;
    if (S = Items[I].Name) and (not (Items[I].Token in
        [tkConstructor, tkDestructor]) or (Assigned(Items[I].Parent) and
        (Items[I].Parent.Token = tkScopeClass))) then
    begin
      Item := Items[I];
      Result := True;
      if not AllFunctions then
        Exit
      else if (Items[I].Token in [tkConstructor, tkFunction, tkPrototype,
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
    if (Items[I].Token in [tkDestructor, tkConstructor, tkFunction]) then
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
    if (Items[I].Token in [tkDestructor, tkConstructor, tkFunction]) then
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
  S1, S2: String;
begin
  Result := True;
  if Item.Token in [tkFunction, tkPrototype, tkConstructor, tkDestructor] then
  begin
    S1 := GetFuncProtoTypes(Item);
    for I := 0 to FList.Count - 1 do
    begin
      Token := TTokenClass(FList.Items[I]);
      if not (Item.Token in [tkFunction, tkPrototype, tkConstructor,
        tkDestructor]) then
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

{File Parsed Functions}

{procedure AddTokenChild(Token, Child: PTokenRec);
var
  NewItems: PTokenRecList;
begin
  GetMem(NewItems, (Token^.Count + 1)*Sizeof(PTokenRec));
  if Token^.Count > 0 then
  begin
    Move(Token^.Items^, NewItems^, Token^.Count*Sizeof(PTokenRec));
    FreeMem(Token^.Items);
  end;
  Token^.Items := NewItems;
  Inc(NewItems, Token^.Count);
  NewItems^ := Child;
  Inc(Token^.Count);
end;

procedure FillToken(Token: PTokenRec;
                    Line: Integer; //Line of word in file
                    Start: Integer; //Start of word in file
                    SelLen: Word; //Length of Selection
                    Level: Word; //block level
                    TkType: TTkType; //Type of Object
                    Name : String;
                    Flag : String
                    );
begin
  Token^.Line := Line;
  Token^.Start := Start;
  Token^.SelLen := SelLen;
  Token^.Level := Level;
  Token^.Token := TkType;
  Token^.Len1 := Length(Name);
  Token^.Name := Name;
  Token^.Len2 := Length(Flag);
  Token^.Flag := Flag;
end;

function NewToken: PTokenRec;
begin
  GetMem(Result, Sizeof(TTokenRec));
  FillChar(Result^, Sizeof(TTokenRec), 0);
end;

procedure FreeToken(Token: PTokenRec);
var
  I: Integer;
  Items: PTokenRecList;
begin
  Items := Token^.Items;
  for I:= 0 to Token^.Count - 1 do
  begin
    FreeToken(Items^);
    Inc(Items);
  end;
  if Token^.Count > 0 then
    FreeMem(Token^.Items);
  FreeMem(Token);
end;

procedure SaveTokenRecursive(Handle: Integer; Token: PTokenRec);
var
  I: Integer;
  Items: PTokenRecList;
begin
  FileWrite(Handle, Token^.Count, SizeOf(Word));
  FileWrite(Handle, Token^.Line, SizeOf(Integer));
  FileWrite(Handle, Token^.Start, SizeOf(Integer));
  FileWrite(Handle, Token^.SelLen, SizeOf(Word));
  FileWrite(Handle, Token^.Level, SizeOf(Word));
  FileWrite(Handle, Token^.Token, SizeOf(TTkType));
  FileWrite(Handle, Token^.Len1, SizeOf(Word));
  FileWrite(Handle, PChar(Token^.Name)^, Token^.Len1);
  FileWrite(Handle, Token^.Len2, SizeOf(Word));
  FileWrite(Handle, PChar(Token^.Flag)^, Token^.Len2);
  Items := Token^.Items;
  for I:= 0 to Token^.Count - 1 do
  begin
    SaveTokenRecursive(Handle, Items^);
    Inc(Items);
  end;
end;

procedure SaveToken(const FileName: String; Token: PTokenRec); 
var
  Handle: Integer;
  Count: Word;
begin
  Handle := FileCreate(FileName);
  if Handle = 0 then Exit;
  Count := 1;
  FileWrite(Handle, Count, SizeOf(Word));
  SaveTokenRecursive(Handle, Token);
  FileClose(Handle);
end;

procedure SaveFileParsedToken(const FileName: String;
                    FileDate: TDateTime;
                    Token: array of PTokenRec);
var
  Handle, I: Integer;
  Header: TSimpleFileToken;
begin
  Handle := FileCreate(FileName);
  if Handle = 0 then Exit;
  Move(Sign, Header.Sign, Sizeof(Header.Sign));
  Header.DateOfFile := FileDate;
  Header.Count := Length(Token);
  FileWrite(Handle, Header, SizeOf(TSimpleFileToken));
  for I:= 0 to Header.Count - 1 do
    SaveTokenRecursive(Handle, Token[I]);
  FileClose(Handle);
end;

procedure LoadTokenRecursive(Handle: Integer; Token: PTokenRec);
var
  I: Integer;
  Buffer: array[0..4095] of Char;
  NewItems: PTokenRecList;
begin
  NewItems := nil;
  FileRead(Handle, Token^.Count, SizeOf(Word));
  FileRead(Handle, Token^.Line, SizeOf(Integer));
  FileRead(Handle, Token^.Start, SizeOf(Integer));
  FileRead(Handle, Token^.SelLen, SizeOf(Word));
  FileRead(Handle, Token^.Level, SizeOf(Word));
  FileRead(Handle, Token^.Token, SizeOf(TTkType));
  FileRead(Handle, Token^.Len1, SizeOf(Word));
  Buffer[Token^.Len1] := #0;
  FileRead(Handle, Buffer, Token^.Len1);
  Token^.Name := StrPas(Buffer);
  FileRead(Handle, Token^.Len2, SizeOf(Word));
  Buffer[Token^.Len2] := #0;
  FileRead(Handle, Buffer, Token^.Len2);
  Token^.Flag := StrPas(Buffer);
  if Token^.Count > 0 then
  begin
    GetMem(NewItems, Token^.Count*Sizeof(PTokenRec));
    Token^.Items := NewItems;
  end;

  for I:= 0 to Token^.Count - 1 do
  begin
    NewItems^ := NewToken;
    LoadTokenRecursive(Handle, NewItems^);
    Inc(NewItems);
  end;
end;

function LoadToken(const FileName: String): PTokenRec; overload;
var
  Handle, I: Integer;
  Count: Word;
  Token: PTokenRec;
begin
  Result := nil;
  Token := nil;
  Count := 0;
  if not FileExists(FileName) then Exit;
  Handle := FileOpen(FileName, fmOpenRead);
  if Handle = 0 then Exit;
  FileRead(Handle, Count, SizeOf(Word));
  for I:= 0 to Count - 1 do
  begin
    Token := NewToken;
    LoadTokenRecursive(Handle, Token);
  end;
  FileClose(Handle);
  Result := Token;
end;

function LoadFileParsed(const FileName: String; var Token: PTokenRec): Boolean;
var
  Handle, I: Integer;
  Header: TSimpleFileToken;
  NewItems: PTokenRecList;
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  Handle := FileOpen(FileName, fmOpenRead);
  if Handle = 0 then Exit;
  FileRead(Handle, Header, SizeOf(TSimpleFileToken));
  if not CompareMem(Pointer(@Header.Sign), PChar(Sign), Sizeof(Header.Sign)) then
  begin
    FileClose(Handle);
    Exit;
  end;
  Token := NewToken;
  Token^.Count := Header.Count;
  FillToken(Token, 0, 0, 0, 0, tkRoot, 'Root', '');
  NewItems := nil;
  if Token^.Count > 0 then
  begin
    GetMem(NewItems, Token^.Count*Sizeof(PTokenRec));
    Token^.Items := NewItems;
  end;
  for I:= 0 to Token^.Count - 1 do
  begin
    NewItems^ := NewToken;
    LoadTokenRecursive(Handle, NewItems^);
    Inc(NewItems);
  end;
  FileClose(Handle);
  Result := True;
end; }

end.

