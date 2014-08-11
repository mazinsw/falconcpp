unit TokenFile;

interface

uses
  Windows, TokenList, Classes, TokenConst, Dialogs, rbtree, Contnrs;

type
  //forward
  TTokenFiles = class;
  TTokenFile = class;

  TTokenFile = class
  private
    FFileName: string;
    FParsedFileName: string;
    FStaticFile: Boolean;
    FFileDate: TDateTime;
    FParsedFileDate: TDateTime;
    FModified: Boolean;
    FOwner: TTokenFiles;
    FData: Pointer;
    FIncludeList: TTokenClass;
    FDefineList: TTokenClass;
    FVarConstList: TTokenClass;
    FTreeObjList: TTokenClass;
    FFuncObjList: TTokenClass;
    procedure SaveToFileRecurse(Handle: Integer; ItemList: TTokenClass);
    function LoadFromFileRecurse(Handle: Integer; ParentList: TTokenClass;
      Count: Integer; var Buffer: PChar; var BufferLen: Integer): Boolean;
  public
    constructor Create; overload;
    constructor Create(AOwner: TTokenFiles); overload;
    procedure CreateLists;
    destructor Destroy; override;
    function SaveToFile(const ParsedFileName: string): Boolean;
    function LoadFromFile(const FileName, ParsedFileName: string): Boolean;
    procedure Assign(AObject: TObject);
    procedure AssignProperty(AObject: TObject);
    procedure Clear;
    procedure GetUsingNames(List: TStrings; UntilPosition: Integer = 0);
    procedure GetFunctions(List: TStrings; const ScopeFlag: string;
      UseScope: Boolean = False; MakeCopy: Boolean = True;
      OnlyPrototype: Boolean = False);
    function GetPreviousFunction(var Token: TTokenClass;
      SelStart: Integer = 0): Boolean;
    function GetNextFunction(var Token: TTokenClass;
      SelStart: Integer = 0): Boolean;
    function GetBaseType(const S: string; var Item: TTokenClass;
      SelStart: Integer; ListAll: TStrings = nil;
      AllFunctions: Boolean = False): Boolean;

    function GetScopeAt(var scopeToken: TTokenClass;
      SelStart: Integer): Boolean;

    function GetTokenAt(var scopeToken: TTokenClass;
      SelStart: Integer; SelLine: Integer = 0): Boolean;

    function SearchToken(const S, ScopeFlag: string; var Item: TTokenClass;
      SelStart: Integer; AdvanceAfterSelStart: Boolean;
      Mode: TTokenSearchMode): Boolean;
    function SearchSource(const S: string; var Item: TTokenClass;
      NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean = False;
      ListAll: TStrings = nil; AllFunctions: Boolean = False): Boolean;
    function SearchTreeToken(const Fields: string; var Token: TTokenClass;
      Mode: TTokenSearchMode; SelStart: Integer): Boolean;

    function LoadHeader(const ParsedFileName: string;
      var Header: TSimpleFileToken): Boolean;
    property FileName: string read FFileName write FFileName;
    property StaticFile: Boolean read FStaticFile write FStaticFile;
    property Modified: Boolean read FModified;
    property Data: Pointer read FData write FData;
    property ParsedFileName: string read FParsedFileName write FParsedFileName;
    property ParsedFileDate: TDateTime read FParsedFileDate write FParsedFileDate;
    property FileDate: TDateTime read FFileDate write FFileDate;
    property Includes: TTokenClass read FIncludeList write FIncludeList;
    property Defines: TTokenClass read FDefineList write FDefineList;
    property VarConsts: TTokenClass read FVarConstList write FVarConstList;
    property TreeObjs: TTokenClass read FTreeObjList write FTreeObjList;
    property FuncObjs: TTokenClass read FFuncObjList write FFuncObjList;
    property Owner: TTokenFiles read FOwner write FOwner;
  end;

  TTokenFiles = class
  private
    FList: TRBTree;
    fPathList: TStrings;
    fIncludeList: TStrings;
    procedure Put(const FileName: string; Value: TTokenFile);
    function Get(const FileName: string): TTokenFile;
    procedure SetPathList(Value: TStrings);
    procedure SetIncludeList(Value: TStrings);

      //search
    function SearchSourceRecursive(const S: string;
      TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Item: TTokenClass;
      FindedList: TRBTree; SelStart: Integer = 0; ListAll: TStrings = nil;
      AllFunctions: Boolean = False): Boolean;
    function GetBaseTypeRecursive(const S: string;
      SelStart: Integer; TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
      var Token: TTokenClass; FindedList: TRBTree; ListAll: TStrings;
      AllFunctions: Boolean): Boolean;
    function SearchTokenRecursive(const S, ScopeFlag: string; TokenFile: TTokenFile;
      var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
      FindedList: TRBTree; SelStart: Integer): Boolean;
    function InvalidOrFinded(var FindedTokenFile: TTokenFile;
      const FilePath: string; IncludeToken: TTokenClass;
      FindedList: TRBTree): Boolean;
    procedure FillCompletionListRecursive(InsertList,
      ShowList: TStrings; TokenFile: TTokenFile; SelStart: Integer; FindedList: TRBTree;
      CompletionColors: TCompletionColors; Images: array of Integer);
    function SearchTreeTokenRecursive(const Fields: string;
      TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Token: TTokenClass;
      Mode: TTokenSearchMode; FindedList: TRBTree; SelStart: Integer): Boolean;

  public
    //list functions
    procedure GetAllFiles(List: TStrings);
    function Count: Integer;
    function Remove(Item: TTokenFile): Boolean;
    procedure Delete(const FileName: string);
    procedure Add(Item: TTokenFile);
    procedure Clear;
    property Items[const FileName: string]: TTokenFile read Get write Put;
    property PathList: TStrings read fPathList write SetPathList;
    property IncludeList: TStrings read fIncludeList write SetIncludeList;

    //search file and update
    function RemoveWithIncludes(const FileName: string): Integer;
    function ItemOfByFileName(const FileName: string): TTokenFile;

    //search token
    function GetAllTokensOfScope(SelStart: Integer; TokenFile: TTokenFile;
      List: TStrings; var thisToken: TTokenClass): Boolean;
    function SearchClassSource(const S: string; Token: TTokenClass;
      TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Item: TTokenClass;
      ListAll: TStrings = nil; AllFunctions: Boolean = False;
      AllowScope: TScopeClassState = []): Boolean;
    function SearchSource(const S: string; TokenFile: TTokenFile;
      var TokenFileItem: TTokenFile; var Item: TTokenClass;
      SelStart: Integer = 0; ListAll: TStrings = nil;
      AllFunctions: Boolean = False): Boolean;
    function GetFieldsBaseType(const S, Fields: string;
      SelStart: Integer; TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
      var Token: TTokenClass): Boolean;
    function GetBaseType(const S: string; SelStart: Integer;
      TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
      var Token: TTokenClass; ListAll: TStrings = nil;
      AllFunctions: Boolean = False): Boolean;
    function GetFieldsBaseParams(const S, Fields: string;
      SelStart: Integer; TokenFile: TTokenFile; ParamsList: TStrings): Boolean;
    function SearchToken(const S, ScopeFlag: string; TokenFile: TTokenFile;
      var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
      SelStart: Integer): Boolean;
    function SearchTreeToken(const Fields: string; TokenFile: TTokenFile;
      var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
      SelStart: Integer): Boolean;
    function FindDeclaration(const Input, Fields: string; TokenFile: TTokenFile;
      var TokenFileItem: TTokenFile; var Item: TTokenClass;
      SelStart, SelLine: Integer): Boolean;

     //fill list
    procedure FillCompletionList(InsertList, ShowList: TStrings;
      TokenFile: TTokenFile; SelStart: Integer;
      CompletionColors: TCompletionColors; Images: array of Integer);
    procedure FillCompletionClass(InsertList, ShowList: TStrings;
      CompletionColors: TCompletionColors; Images: array of Integer;
      TokenFile: TTokenFile; Item: TTokenClass;
      AllowScope: TScopeClassState = []; SkipFirst: Boolean = False);

    constructor Create;
    destructor Destroy; override;
  end;

procedure FillCompletion(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; Images: array of Integer;
  IncludeParams: Boolean = False);

implementation

uses SysUtils, TokenUtils;

{TTokenFile}

procedure TTokenFile.CreateLists;
begin
  inherited Create;
  FIncludeList := TTokenClass.Create;
  FIncludeList.Name := 'Includes';
  FIncludeList.Token := tkIncludeList;
  FIncludeList.Owner := Self;

  FDefineList := TTokenClass.Create;
  FDefineList.Name := 'Defines';
  FDefineList.Token := tkDefineList;
  FDefineList.Owner := Self;

  FVarConstList := TTokenClass.Create;
  FVarConstList.Name := 'Variables/Constants';
  FVarConstList.Token := tkVarConsList;
  FVarConstList.Owner := Self;

  FTreeObjList := TTokenClass.Create;
  FTreeObjList.Name := 'Types';
  FTreeObjList.Token := tkTreeObjList;
  FTreeObjList.Owner := Self;

  FFuncObjList := TTokenClass.Create;
  FFuncObjList.Name := 'Functions';
  FFuncObjList.Token := tkFuncProList;
  FFuncObjList.Owner := Self;
end;

constructor TTokenFile.Create;
begin
  inherited Create;
  CreateLists;
end;

constructor TTokenFile.Create(AOwner: TTokenFiles);
begin
  inherited Create;
  FOwner := AOwner;
  CreateLists;
end;

destructor TTokenFile.Destroy;
begin
  FIncludeList.Free;
  FDefineList.Free;
  FVarConstList.Free;
  FTreeObjList.Free;
  FFuncObjList.Free;
  inherited Destroy;
end;

procedure ReadToken(Handle: Integer; Item: TTokenClass; var Buffer: PChar;
  var BufferLen, ChildCount: Integer);
var
  TokenRec: TTokenRec;
begin
  FileRead(Handle, TokenRec.Token, SizeOf(TTkType));
  Item.Token := TokenRec.Token;
  FileRead(Handle, TokenRec.Count, SizeOf(Integer));
  ChildCount := TokenRec.Count;
  FileRead(Handle, TokenRec.Line, SizeOf(Integer));
  Item.SelLine := TokenRec.Line;
  FileRead(Handle, TokenRec.Start, SizeOf(Integer));
  Item.SelStart := TokenRec.Start;
  FileRead(Handle, TokenRec.SelLen, SizeOf(Integer));
  Item.SelLength := TokenRec.SelLen;
  FileRead(Handle, TokenRec.Level, SizeOf(Integer));
  Item.Level := TokenRec.Level;
  FileRead(Handle, TokenRec.LenName, SizeOf(Integer));
  FileRead(Handle, TokenRec.LenFlag, SizeOf(Integer));
  FileRead(Handle, TokenRec.LenComment, SizeOf(Integer));
  // read Name
  if TokenRec.LenName >= BufferLen then
  begin
    FreeMemory(Buffer);
    BufferLen := TokenRec.LenName + TokenRec.LenName div 2;
    Buffer := GetMemory(BufferLen);
  end;
  FileRead(Handle, Buffer^, TokenRec.LenName);
  Buffer[TokenRec.LenName div SizeOf(Char)] := #0;
  Item.Name := StrPas(Buffer);
  // read Flag
  if TokenRec.LenFlag >= BufferLen then
  begin
    FreeMemory(Buffer);
    BufferLen := TokenRec.LenFlag + TokenRec.LenFlag div 2;
    Buffer := GetMemory(BufferLen);
  end;
  FileRead(Handle, Buffer^, TokenRec.LenFlag);
  Buffer[TokenRec.LenFlag div SizeOf(Char)] := #0;
  Item.Flag := StrPas(Buffer);
  // read Comment
  if TokenRec.LenComment >= BufferLen then
  begin
    FreeMemory(Buffer);
    BufferLen := TokenRec.LenComment + TokenRec.LenComment div 2;
    Buffer := GetMemory(BufferLen);
  end;
  FileRead(Handle, Buffer^, TokenRec.LenComment);
  Buffer[TokenRec.LenComment div SizeOf(Char)] := #0;
  Item.Comment := StrPas(Buffer);
end;

function TTokenFile.LoadFromFileRecurse(Handle: Integer;
  ParentList: TTokenClass; Count: Integer; var Buffer: PChar;
  var BufferLen: Integer): Boolean;
var
  I, ChildCount: Integer;
  Item: TTokenClass;
begin
  for I := 0 to Count - 1 do
  begin
    Item := TTokenClass.Create(ParentList);
    Item.Owner := Self;
    ParentList.Add(Item);
    ReadToken(Handle, Item, Buffer, BufferLen, ChildCount);
    // load Child
    LoadFromFileRecurse(Handle, Item, ChildCount, Buffer, BufferLen);
  end;
  Result := True;
end;

function TTokenFile.LoadHeader(const ParsedFileName: string;
  var Header: TSimpleFileToken): Boolean;
var
  Handle: Integer;
begin
  Result := False;
  if not FileExists(ParsedFileName) then
    Exit;
  Handle := FileOpen(ParsedFileName, fmOpenRead);
  if Handle = 0 then
    Exit;

  FileRead(Handle, Header, SizeOf(TSimpleFileToken));
  if not CompareMem(Pointer(@Header.Sign), Pointer(@TokenList.Sign),
    SizeOf(Header.Sign)) then
  begin
    FileClose(Handle);
    Exit;
  end;
  FileClose(Handle);
  Result := True;
end;

function TTokenFile.LoadFromFile(const FileName, ParsedFileName: string): Boolean;
var
  Handle, I, ChildCount: Integer;
  Header: TSimpleFileToken;
  Buffer: PChar;
  BufferLen: Integer;
  TkList, Selected: TTokenClass;
begin
  Result := False;
  if not FileExists(ParsedFileName) then
    Exit;
  Handle := FileOpen(ParsedFileName, fmOpenRead);
  if Handle = 0 then
    Exit;
  if FileExists(FileName) then
    FileDate := FileDateTime(FileName);

  FileRead(Handle, Header, SizeOf(TSimpleFileToken));
  if not CompareMem(Pointer(@Header.Sign), Pointer(@TokenList.Sign),
    Sizeof(Header.Sign)) then
  begin
    FileClose(Handle);
    Exit;
  end;
  FStaticFile := True;
  FModified := FileDate <> Header.DateOfFile;
  Clear;
  FParsedFileDate := Header.DateOfFile;
  FFileName := FileName;
  FParsedFileName := ParsedFileName;
  TkList := TTokenClass.Create;
  BufferLen := 4096 * SizeOf(Char);
  Buffer := GetMemory(BufferLen);
  Result := True;
  Selected := nil;
  for I := 0 to Header.Count - 1 do
  begin
    ReadToken(Handle, TkList, Buffer, BufferLen, ChildCount);
    case TkList.Token of
      tkIncludeList: Selected := FIncludeList;
      tkDefineList: Selected := FDefineList;
      tkTreeObjList: Selected := FTreeObjList;
      tkVarConsList: Selected := FVarConstList;
      tkFuncProList: Selected := FFuncObjList;
    else
      Result := False;
      Break;
    end;
    LoadFromFileRecurse(Handle, Selected, ChildCount, Buffer, BufferLen);
  end;
  FreeMemory(Buffer);
  TkList.Free;
  FileClose(Handle);
end;

procedure TTokenFile.SaveToFileRecurse(Handle: Integer; ItemList: TTokenClass);
var
  I: Integer;
  TokenRec: TTokenRec;
begin
  TokenRec.Token := ItemList.Token;
  TokenRec.Count := ItemList.Count;
  TokenRec.Line := ItemList.SelLine;
  TokenRec.Start := ItemList.SelStart;
  TokenRec.SelLen := ItemList.SelLength;
  TokenRec.Level := ItemList.Level;
  TokenRec.LenName := Length(ItemList.Name) * SizeOf(Char);
  TokenRec.LenFlag := Length(ItemList.Flag) * SizeOf(Char);
  TokenRec.LenComment := Length(ItemList.Comment) * SizeOf(Char);
  FileWrite(Handle, TokenRec.Token, SizeOf(TTkType));
  FileWrite(Handle, TokenRec.Count, SizeOf(Integer));
  FileWrite(Handle, TokenRec.Line, SizeOf(Integer));
  FileWrite(Handle, TokenRec.Start, SizeOf(Integer));
  FileWrite(Handle, TokenRec.SelLen, SizeOf(Integer));
  FileWrite(Handle, TokenRec.Level, SizeOf(Integer));
  FileWrite(Handle, TokenRec.LenName, SizeOf(Integer));
  FileWrite(Handle, TokenRec.LenFlag, SizeOf(Integer));
  FileWrite(Handle, TokenRec.LenComment, SizeOf(Integer));
  FileWrite(Handle, PChar(ItemList.Name)^, TokenRec.LenName);
  FileWrite(Handle, PChar(ItemList.Flag)^, TokenRec.LenFlag);
  FileWrite(Handle, PChar(ItemList.Comment)^, TokenRec.LenComment);
  for I := 0 to ItemList.Count - 1 do
    SaveToFileRecurse(Handle, ItemList.Items[I]);
end;

function TTokenFile.SaveToFile(const ParsedFileName: string): Boolean;
var
  Handle: Integer;
  Header: TSimpleFileToken;
begin
  Result := False;
  Handle := FileCreate(ParsedFileName);
  if Handle = 0 then
    Exit;
  Move(TokenList.Sign, Header.Sign, SizeOf(Header.Sign));
  Header.Count := 5;
  Header.DateOfFile := FileDate;
  FileWrite(Handle, Header, SizeOf(TSimpleFileToken));
  SaveToFileRecurse(Handle, FIncludeList);
  SaveToFileRecurse(Handle, FDefineList);
  SaveToFileRecurse(Handle, FTreeObjList);
  SaveToFileRecurse(Handle, FVarConstList);
  SaveToFileRecurse(Handle, FFuncObjList);
  FileClose(Handle);
  FParsedFileName := ParsedFileName;
  Result := True;
end;

procedure TTokenFile.Assign(AObject: TObject);
var
  NewFile: TTokenFile;
begin
  if not Assigned(AObject) then
    Exit;
  if not (AObject is TTokenFile) then
    Exit;
  NewFile := TTokenFile(AObject);
  FData := NewFile.Data;
  FFileName := NewFile.FFileName;
  FParsedFileName := NewFile.FParsedFileName;
  FStaticFile := NewFile.FStaticFile;
  FFileDate := NewFile.FFileDate;
  FParsedFileDate := NewFile.FParsedFileDate;
  FModified := NewFile.FModified;
  FIncludeList.Assign(NewFile.FIncludeList);
  FDefineList.Assign(NewFile.FDefineList);
  FTreeObjList.Assign(NewFile.FTreeObjList);
  FVarConstList.Assign(NewFile.FVarConstList);
  FFuncObjList.Assign(NewFile.FFuncObjList);
  if Assigned(NewFile.FOwner) then
    FOwner := NewFile.FOwner;
end;

procedure TTokenFile.AssignProperty(AObject: TObject);
var
  NewFile: TTokenFile;
begin
  if not Assigned(AObject) then
    Exit;
  if not (AObject is TTokenFile) then
    Exit;
  NewFile := TTokenFile(AObject);
  FFileName := NewFile.FFileName;
  FParsedFileName := NewFile.FParsedFileName;
  FStaticFile := NewFile.FStaticFile;
  FFileDate := NewFile.FFileDate;
  FParsedFileDate := NewFile.FParsedFileDate;
  FModified := NewFile.FModified;
  if Assigned(NewFile.FOwner) then
    FOwner := NewFile.FOwner;
end;

procedure TTokenFile.Clear;
begin
  Includes.Clear;
  Defines.Clear;
  TreeObjs.Clear;
  FuncObjs.Clear;
  VarConsts.Clear;
end;

function TTokenFile.GetBaseType(const S: string; var Item: TTokenClass;
  SelStart: Integer; ListAll: TStrings; AllFunctions: Boolean): Boolean;
var
  Prior: TTokenClass;
  TypeName: string;
begin
  Result := True;
  //var.field.field
  if FDefineList.SearchSource(S, Item, SelStart) then
  begin
    TypeName := GetFirstWord(Item.Flag);
    if (TypeName = '') or (StringIn(TypeName, ReservedTypes)) then
      Exit;
    if GetBaseType(TypeName, Prior, Item.SelStart, ListAll, AllFunctions) then
      Item := Prior;
    Exit;
  end;
  if FVarConstList.SearchSource(S, Item, SelStart) then
  begin
    TypeName := GetFirstWord(Item.Flag);
    if (TypeName = '') or (StringIn(TypeName, ReservedTypes)) then
      Exit;
    if GetBaseType(TypeName, Prior, Item.SelStart, ListAll, AllFunctions) then
      Item := Prior;
    Exit;
  end;
  //var.function().blabla
  if FFuncObjList.SearchSource(S, Item, SelStart, False, ListAll, AllFunctions) then
    Exit;
  if FTreeObjList.SearchSource(S, Item, SelStart) then
    Exit;
  Result := False;
end;

function TTokenFile.SearchToken(const S, ScopeFlag: string; var Item: TTokenClass;
  SelStart: Integer; AdvanceAfterSelStart: Boolean; Mode: TTokenSearchMode): Boolean;

  function HasOneToken(aCheck, aMode: TTokenSearchMode): Boolean;
  begin
    Result := not ((aMode - aCheck) = aMode) or (aMode = []);
  end;

begin
  Result := True;
  if HasOneToken([tkClass, tkStruct, tkTypeStruct, tkTypedef,
    tkTypedefProto, tkEnum, tkUnion, tkNamespace], Mode) then
    if FTreeObjList.SearchToken(S, ScopeFlag, Item, SelStart,
      AdvanceAfterSelStart, Mode) then
      Exit;
  if HasOneToken([tkVariable, tkForward], Mode) then
    if FVarConstList.SearchToken(S, ScopeFlag, Item, SelStart,
      AdvanceAfterSelStart, Mode) then
      Exit;
  if HasOneToken([tkPrototype, tkFunction, tkConstructor, tkDestructor, tkOperator], Mode) then
    if FFuncObjList.SearchToken(S, ScopeFlag, Item, SelStart, AdvanceAfterSelStart,
      Mode) then
      Exit;
  if HasOneToken([tkInclude], Mode) then
    if FIncludeList.SearchToken(S, ScopeFlag, Item, SelStart, AdvanceAfterSelStart,
      Mode) then
      Exit;
  if HasOneToken([tkDefine], Mode) then
    if FDefineList.SearchToken(S, ScopeFlag, Item, SelStart, AdvanceAfterSelStart,
      Mode) then
      Exit;
  Result := False;
end;

function TTokenFile.SearchSource(const S: string; var Item: TTokenClass;
  NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean; ListAll: TStrings;
  AllFunctions: Boolean): Boolean;
begin
  Result := True;
  if FVarConstList.SearchSource(S, Item, NotAtSelStart, AdvanceAfterSelStart) then
    Exit;
  if FFuncObjList.SearchSource(S, Item, NotAtSelStart, AdvanceAfterSelStart,
    ListAll, AllFunctions) then
    Exit;
  if FTreeObjList.SearchSource(S, Item, NotAtSelStart, AdvanceAfterSelStart,
    ListAll, AllFunctions) then
    Exit;
  if FDefineList.SearchSource(S, Item, NotAtSelStart, AdvanceAfterSelStart) then
    Exit;
  //if FIncludeList.SearchSource(S, Item, NotAtSelStart, AdvanceAfterSelStart) then Exit;
  Result := False;
end;

function TTokenFile.SearchTreeToken(const Fields: string; var Token: TTokenClass;
  Mode: TTokenSearchMode; SelStart: Integer): Boolean;
var
  List: TStrings;
  I: Integer;
begin
  Result := False;
  List := TStringList.Create;
  GetStringsFields(Fields, List, False);
  if (List.Count > 0) and SearchToken(List.Strings[0], '', Token, SelStart, False, Mode) then
  begin
    Result := True;
    //direction ------>---->---->>>
    //fields = namespace1::namespace2::myclass
    for I := 1 to List.Count - 1 do
    begin
      if not Token.SearchToken(List.Strings[I], '', Token, SelStart, False,
        Mode+[tkTypedef]) then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
  List.Free;
end;

function TTokenFile.GetScopeAt(var scopeToken: TTokenClass;
  SelStart: Integer): Boolean;
begin
  Result := FuncObjs.GetScopeAt(scopeToken, SelStart);
  if Result then
    Exit;
  Result := TreeObjs.GetScopeAt(scopeToken, SelStart);
end;

function TTokenFile.GetTokenAt(var scopeToken: TTokenClass;
  SelStart, SelLine: Integer): Boolean;
begin
  Result := FuncObjs.GetTokenAt(scopeToken, SelStart, SelLine);
  if Result then
    Exit;
  Result := TreeObjs.GetTokenAt(scopeToken, SelStart, SelLine);
  if Result then
    Exit;
  Result := VarConsts.GetTokenAt(scopeToken, SelStart, SelLine);
  if Result then
    Exit;
  Result := Defines.GetTokenAt(scopeToken, SelStart, SelLine);
  if Result then
    Exit;
  Result := Includes.GetTokenAt(scopeToken, SelStart, SelLine);
end;

procedure TTokenFile.GetUsingNames(List: TStrings; UntilPosition: Integer);
begin
  VarConsts.GetUsingNames(List, UntilPosition);
end;

procedure TTokenFile.GetFunctions(List: TStrings; const ScopeFlag: string;
  UseScope, MakeCopy, OnlyPrototype: Boolean);
begin
  FuncObjs.GetFunctions(List, ScopeFlag, UseScope, MakeCopy, OnlyPrototype);
  TreeObjs.GetFunctions(List, ScopeFlag, UseScope, MakeCopy, OnlyPrototype);
end;

function TTokenFile.GetNextFunction(var Token: TTokenClass;
  SelStart: Integer): Boolean;
var
  temp: TTokenClass;
begin
  Result := FuncObjs.GetNextFunction(Token, SelStart);
  if not Result then
    Result := TreeObjs.GetNextFunction(Token, SelStart)
  else
  begin
    if TreeObjs.GetNextFunction(temp, SelStart) then
    begin
      if Token.SelStart > temp.SelStart then
        Token := temp;
    end;
  end;
end;

function TTokenFile.GetPreviousFunction(var Token: TTokenClass;
  SelStart: Integer): Boolean;
var
  temp: TTokenClass;
begin
  Result := FuncObjs.GetPreviousFunction(Token, SelStart);
  if not Result then
    Result := TreeObjs.GetPreviousFunction(Token, SelStart)
  else
  begin
    if TreeObjs.GetPreviousFunction(temp, SelStart) then
    begin
      if Token.SelStart < temp.SelStart then
        Token := temp;
    end;
  end;
end;

{TTokenFiles}

constructor TTokenFiles.Create;
begin
  inherited Create;
  FList := TRBTree.Create;
  fPathList := TStringList.Create;
  fIncludeList := TStringList.Create;
end;

destructor TTokenFiles.Destroy;
begin
  Clear;
  fIncludeList.Free;
  fPathList.Free;
  FList.Free;
  inherited Destroy;
end;

procedure TTokenFiles.SetPathList(Value: TStrings);
begin
  if Assigned(Value) then
    fIncludeList.Assign(Value);
end;

procedure TTokenFiles.SetIncludeList(Value: TStrings);
begin
  if Assigned(Value) then
    fPathList.Assign(Value);
end;

procedure TTokenFiles.Put(const FileName: string; Value: TTokenFile);
begin
  FList.Items[FileName] := Value;
end;

function TTokenFiles.Get(const FileName: string): TTokenFile;
begin
  Result := TTokenFile(FList.Items[FileName]);
end;

//List manipulation

function TTokenFiles.Count: Integer;
begin
  Result := FList.Count;
end;

function TTokenFiles.Remove(Item: TTokenFile): Boolean;
var
  Node: PRBNode;
begin
  Node := FList.Find(Item.FileName);
  Result := False;
  if Node <> nil then
  begin
    TTokenFile(Node^.Data).Free;
    FList.Delete(Node);
    Result := True;
  end;
end;

procedure TTokenFiles.Delete(const FileName: string);
var
  Node: PRBNode;
begin
  Node := FList.Find(FileName);
  if Node <> nil then
  begin
    TTokenFile(Node^.Data).Free;
    FList.Delete(Node);
  end;
end;

procedure TTokenFiles.Clear;
var
  Node: PRBNode;
begin
  Node := FList.First;
  if Node = nil then
    Exit;
  while Node <> FList.Last do
  begin
    TTokenFile(Node^.Data).Free;
    RBInc(Node);
  end;
  TTokenFile(Node^.Data).Free;
  FList.Clear;
end;

procedure TTokenFiles.GetAllFiles(List: TStrings);
var
  Node: PRBNode;
begin
  Node := FList.First;
  if Node = nil then
    Exit;
  while Node <> FList.Last do
  begin
    List.AddObject(TTokenFile(Node^.Data).FileName, TTokenFile(Node^.Data));
    RBInc(Node);
  end;
  List.AddObject(TTokenFile(Node^.Data).FileName, TTokenFile(Node^.Data));
end;

procedure TTokenFiles.Add(Item: TTokenFile);
begin
  FList.Items[Item.FileName]:= Item;
  Item.Owner := Self;
end;

function TTokenFiles.ItemOfByFileName(const FileName: string): TTokenFile;
begin
  Result := Items[FileName];
end;

function TTokenFiles.RemoveWithIncludes(const FileName: string): Integer;
begin
  Result := 0;
  //....

  //...
end;

function TTokenFiles.GetAllTokensOfScope(SelStart: Integer;
  TokenFile: TTokenFile; List: TStrings; var thisToken: TTokenClass): Boolean;
var
  token, Scope: TTokenClass;
  AllScope: Boolean;
  Fields: string;
begin
  Result := False;
  thisToken := nil;
  if not TokenFile.GetScopeAt(token, SelStart) then
    Exit;
  List.AddObject('', token);
  AllScope := False;
  { TODO -oMazin -c : while parent is not nil fill objects 24/08/2012 22:32:19 }
  //get parent of Token
  if Assigned(Token.Parent) and
    (Token.Parent.Token in [tkClass, tkStruct, tkUnion, tkScopeClass]) then
  begin
    Token := Token.Parent;
    AllScope := True;
  end;
  //tree parent object?
  if Assigned(Token.Parent) and
    (Token.Parent.Token in [tkClass, tkStruct, tkUnion]) then
  begin
    Token := Token.Parent;
  end;
  //Get class of scope
  Scope := GetTokenByName(Token, 'Scope', tkScope);
  if not AllScope and Assigned(Scope) and (Scope.Flag <> '') then
  begin
    Fields := Scope.Flag;
    while Assigned(Token.Parent) and (Token.Parent.Token in [tkNamespace]) do
    begin
      Token := Token.Parent;
      List.AddObject('', token);
      Fields := Token.Name + '::' + Fields;
    end;
    AllScope := SearchTreeToken(Fields, TokenFile,
      TokenFile, Token, [tkClass, tkStruct, tkUnion, tkNamespace], Token.SelStart);
  end;
  if AllScope then
  begin
    if Token.Token in [tkClass, tkStruct, tkUnion] then
      thisToken := Token;
    //List.AddObject('', token);
  end;
  Result := True;
end;

function TTokenFiles.SearchSourceRecursive(const S: string;
  TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Item: TTokenClass;
  FindedList: TRBTree; SelStart: Integer; ListAll: TStrings;
  AllFunctions: Boolean): Boolean;
var
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  //search in this file
  Result := TokenFile.SearchSource(S, Item, SelStart, False, ListAll, AllFunctions);
  if Result then
  begin
    TokenFileItem := TokenFile;
    if not AllFunctions then
      Exit;
  end;
  //don't search again
  FindedList.Add(TokenFile.FileName, TokenFile);
  //searched filepath
  FilePath := ExtractFilePath(TokenFile.FileName);
  //search in all include files
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    if InvalidOrFinded(FindedTokenFile, FilePath, TokenFile.Includes.Items[I], FindedList) then
      Continue;
    if SearchSourceRecursive(S, FindedTokenFile, TokenFileItem,
      Item, FindedList, 0, ListAll, AllFunctions) then
      Result := True;
    if Result and not AllFunctions then
      Break;
  end;
end;

function TTokenFiles.SearchClassSource(const S: string; Token: TTokenClass;
  TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Item: TTokenClass;
  ListAll: TStrings; AllFunctions: Boolean;
  AllowScope: TScopeClassState): Boolean;

  function SearchClassSourceRecursive(TokenItem: TTokenFile;
    aToken: TTokenClass; aAllowScope, DenyScope: TScopeClassState): Boolean;
  var
    SearchClass: string;
    scopeToken: TTokenClass;
    fromScope: TScopeClass;
    List: TStrings;
    I: Integer;
  begin
    Result := aToken.SearchSource(S, Item, 0, True, ListAll, AllFunctions);
    if Result then
    begin
      scopeToken := Item.Parent;
      if Assigned(scopeToken) and (scopeToken.Token = tkScopeClass) then
      begin
        fromScope := StringToScopeClass(scopeToken.Name);
        if not (aAllowScope = []) and not (fromScope in aAllowScope) then
        begin
          Result := False;
          Exit;
        end;
      end;
      TokenFileItem := TokenItem;
      Exit;
    end;
    List := TStringList.Create;
    GetDescendants(aToken.Flag, List, scPublic);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, '', TokenItem,
        TokenItem, aToken, [tkClass, tkStruct, tkUnion], Token.SelStart) then
      begin
        //fill all decendent class
        Result := SearchClassSourceRecursive(TokenItem, aToken, aAllowScope, DenyScope);
        if Result then
          Exit;
      end;
    end;
    if not (aAllowScope = []) then
    begin
      List.Free;
      Exit;
    end;
    GetDescendants(aToken.Flag, List, scPrivate);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, '', TokenItem,
        TokenItem, aToken, [tkClass, tkStruct, tkUnion], Token.SelStart) then
      begin
        //fill all decendent class
        Result := SearchClassSourceRecursive(TokenItem, aToken, aAllowScope, DenyScope);
        if Result then
          Exit;
      end;
    end;
    GetDescendants(aToken.Flag, List, scProtected);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, '', TokenItem,
        TokenItem, aToken, [tkClass, tkStruct, tkUnion], Token.SelStart) then
      begin
        //fill all decendent class
        Result := SearchClassSourceRecursive(TokenItem, aToken, aAllowScope, DenyScope);
        if Result then
          Exit;
      end;
    end;
    List.Free;
  end;

var
  DenyScope: TScopeClassState;
begin
  DenyScope := [];
  if not (AllowScope = []) then
    DenyScope := [scPrivate, scProtected];
  Result := SearchClassSourceRecursive(TokenFile, Token, AllowScope, DenyScope);
end;

function TTokenFiles.SearchSource(const S: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Item: TTokenClass; SelStart: Integer;
  ListAll: TStrings; AllFunctions: Boolean): Boolean;
var
  FindedList: TRBTree;
  AllScope: Boolean;
  Fields: string;
  Scope, Token: TTokenClass;
begin
  //get current object in current location
  if TokenFile.GetScopeAt(Token, SelStart) then
  begin
    TokenFileItem := TokenFile;
    if (S <> 'this') and Token.SearchSource(S, Item, SelStart, False, ListAll,
      AllFunctions) then
    begin
      Result := True;
      Exit;
    end;
    AllScope := False;
    { TODO -oMazin -c : while parent is not nil fill objects 24/08/2012 22:32:35 }
    //get parent of Token
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkClass, tkStruct, tkUnion, tkScopeClass]) then
    begin
      Token := Token.Parent;
      AllScope := True;
    end;
    //tree parent object?
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkClass, tkStruct, tkUnion]) then
    begin
      Token := Token.Parent;
    end;
    //Get scope of class
    Scope := GetTokenByName(Token, 'Scope', tkScope);
    if not AllScope and Assigned(Scope) and (Scope.Flag <> '') then
    begin
      Fields := Scope.Flag;
      while Assigned(Token.Parent) and (Token.Parent.Token in [tkNamespace, tkClass, tkStruct, tkUnion]) do
      begin
        Token := Token.Parent;
        Fields := Token.Name + '::' + Fields;
      end;
      AllScope := SearchTreeToken(Fields, TokenFile,
        TokenFileItem, Token, [tkClass, tkStruct, tkUnion, tkNamespace], Token.SelStart);
    end;
    //search on class, struct
    if AllScope then
    begin
      if (S = 'this') then
      begin
        Item := Token;
        Result := True;
        Exit;
      end
      else if Token.SearchSource(S, Item, 0, True, ListAll, AllFunctions) then
      begin
        Result := True;
        Exit;
      end
      else if SearchClassSource(S, Token, TokenFileItem,
        TokenFileItem, Item, ListAll, AllFunctions) then
      begin
        Result := True;
        Exit;
      end
      else
      begin
        //Result := False;
        //Exit;
      end;
    end;
  end;

  FindedList := TRBTree.Create;
  Result := SearchSourceRecursive(S, TokenFile, TokenFileItem, Item,
    FindedList, SelStart, ListAll, AllFunctions);
  FindedList.Free;
end;

function TTokenFiles.SearchTokenRecursive(const S, ScopeFlag: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
  FindedList: TRBTree; SelStart: Integer): Boolean;
var
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  Result := TokenFile.SearchToken(S, ScopeFlag, Token, SelStart, False, Mode);
  if Result then
  begin
    TokenFileItem := TokenFile;
    Exit;
  end;
  //don't search again
  FindedList.Add(TokenFile.FileName, TokenFile);
  //searched filepath
  FilePath := ExtractFilePath(TokenFile.FileName);
  //search in all include files
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    if InvalidOrFinded(FindedTokenFile, FilePath, TokenFile.Includes.Items[I], FindedList) then
      Continue;
    Result := SearchTokenRecursive(S, ScopeFlag, FindedTokenFile, TokenFileItem, Token, Mode, FindedList, 0);
    if Result then
      Break;
  end;
end;

function TTokenFiles.InvalidOrFinded(var FindedTokenFile: TTokenFile;
  const FilePath: string; IncludeToken: TTokenClass;
  FindedList: TRBTree): Boolean;
var
  FindName: string;
  I: Integer;
begin
  //file environment #include <stdio.h>
  if IncludeToken.Flag = 'S' then
  begin
    for I := 0 to PathList.Count - 1 do
    begin
      FindName := ExpandFileName(PathList.Strings[I] +
        ConvertSlashes(IncludeToken.Name));
      FindedTokenFile := ItemOfByFileName(FindName);
      if FindedTokenFile <> nil then
        Break;
    end;
  end
  else
  begin
    //file environment #include "main.h"
    FindName := ExpandFileName(FilePath +
      ConvertSlashes(IncludeToken.Name));
    FindedTokenFile := ItemOfByFileName(FindName);
    //if not found try file environment #include <stdio.h>
    if FindedTokenFile = nil then
    begin
      for I := 0 to PathList.Count - 1 do
      begin
        FindName := ExpandFileName(PathList.Strings[I] +
          ConvertSlashes(IncludeToken.Name));
        FindedTokenFile := ItemOfByFileName(FindName);
        if FindedTokenFile <> nil then
          Break;
      end;
    end;
  end;
  if FindedTokenFile = nil then
  begin
    for I := 0 to IncludeList.Count - 1 do
    begin
      FindName := ExpandFileName(IncludeList.Strings[I] +
        ConvertSlashes(IncludeToken.Name));
      FindedTokenFile := ItemOfByFileName(FindName);
      if FindedTokenFile <> nil then
        Break;
    end;
  end;
  //file not parsed or already searched
  Result := (FindedTokenFile = nil) or (FindedList.Find(FindedTokenFile.FileName) <> nil);
end;

function TTokenFiles.SearchToken(const S, ScopeFlag: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
  SelStart: Integer): Boolean;
var
  FindedList: TRBTree;
begin
  FindedList := TRBTree.Create;
  Result := SearchTokenRecursive(S, ScopeFlag, TokenFile, TokenFileItem, Token,
    Mode, FindedList, SelStart);
  FindedList.Free;
end;

function TTokenFiles.SearchTreeTokenRecursive(const Fields: string;
  TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Token: TTokenClass;
  Mode: TTokenSearchMode; FindedList: TRBTree; SelStart: Integer): Boolean;
var
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  Result := TokenFile.SearchTreeToken(Fields, Token, Mode, SelStart);
  if Result then
  begin
    TokenFileItem := TokenFile;
    Exit;
  end;

  //don't search again
  FindedList.Add(TokenFile.FileName, TokenFile);
  //searched filepath
  FilePath := ExtractFilePath(TokenFile.FileName);
  //search in all include files
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    if InvalidOrFinded(FindedTokenFile, FilePath, TokenFile.Includes.Items[I],
      FindedList) then
      Continue;
    Result := SearchTreeTokenRecursive(Fields, FindedTokenFile, TokenFileItem,
      Token, Mode, FindedList, 0);
    if Result then
      Break;
  end;
end;

function TTokenFiles.SearchTreeToken(const Fields: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
  SelStart: Integer): Boolean;
var
  FindedList: TRBTree;
begin
  Result := False;
  if Trim(Fields) = '' then
    Exit;
  FindedList := TRBTree.Create;
  Result := SearchTreeTokenRecursive(Fields, TokenFile, TokenFileItem, Token,
    Mode, FindedList, SelStart);
  { TODO -oMazin -c : Search when scope is Scope::Function() 04/05/2013 21:28:56 }
  FindedList.Free;
end;

function TTokenFiles.FindDeclaration(const Input, Fields: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Item: TTokenClass;
  SelStart, SelLine: Integer): Boolean;

  function SearchTreeTokenClass(ParentScope, Scope: TTokenClass;
    const AllFields: string; CurrentTokenFile: TTokenFile;
    ScopeSelStart: Integer; FindedList: TRBTree): Boolean;
  var
    AllScope: Boolean;
    AllowScope: TScopeClassState;
    FilePath: string;
    FindedTokenFile: TTokenFile;
    ClassToken: TTokenClass;
    I: Integer;
  begin
    Result := False;
    if CurrentTokenFile.SearchTreeToken(AllFields, ClassToken,
      [tkClass, tkStruct, tkUnion, tkNamespace], ScopeSelStart) then
    begin
      AllowScope := [];
      // for implementation out of class, ret_type my_class::function
      // teste if class my_class is equal to my_class::
      AllScope := Assigned(Scope) and (Scope.Flag = ClassToken.Name);
      // test if in same scope
      if not AllScope and Assigned(ParentScope) and (ParentScope.Name = ClassToken.Name) then
          AllScope := True;
      // allow only public statement
      if not AllScope then
        AllowScope := AllowScope + [scPublic];
      // search function, field or variable
      if SearchClassSource(Input, ClassToken, CurrentTokenFile,
        TokenFileItem, Item, nil, False, AllowScope) then
      begin
        //finded
        Result := True;
        Exit;
      end;
    end;
    //don't search again
    FindedList.Add(CurrentTokenFile.FileName, CurrentTokenFile);
    //searched filepath
    FilePath := ExtractFilePath(CurrentTokenFile.FileName);
    //search in all include files
    for I := 0 to CurrentTokenFile.Includes.Count - 1 do
    begin
      if InvalidOrFinded(FindedTokenFile, FilePath, CurrentTokenFile.Includes.Items[I],
        FindedList) then
        Continue;

      Result := SearchTreeTokenClass(ParentScope, Scope, AllFields,
        FindedTokenFile, 0, FindedList);
      if Result then
        Break;
    end;

  end;

var
  AllFields, FirstInput, ScopeFlag, UsingAllFields: string;
  Scope, ParentScope, SaveScope: TTokenClass;
  ClassToken: TTokenClass;
  FindedTokenFile: TTokenFile;
  AllScope: Boolean;
  AllowScope: TScopeClassState;
  FindedList: TRBTree;
  ScopeSelStart, I: Integer;
  UsingList: TStrings;
begin
  Result := False;
  AllFields := Fields;
  UsingList := TStringList.Create;
  TStringList(UsingList).Duplicates := dupIgnore;
  TStringList(UsingList).CaseSensitive := True;
  UsingList.Add('');
  TokenFile.GetUsingNames(UsingList);

  if TokenFile.GetScopeAt(SaveScope, SelStart) then
  begin
    Scope := SaveScope;
    if (Scope.Token in [tkNamespace]) then
    begin
      AllFields := Scope.Name + '::' + AllFields;
      while Assigned(Scope.Parent) and (Scope.Parent.Token in [tkNamespace]) do
      begin
        Scope := Scope.Parent; // first level
        AllFields := Scope.Name + '::' + AllFields;
      end;
      ScopeFlag := Fields;
      // remove :: at ent of fields
      if (Length(Fields) > 1) and (Fields[Length(Fields)] = ':') and
        (Fields[Length(Fields) - 1] = ':') then
          ScopeFlag := Copy(ScopeFlag, 1, Length(Fields) - 2);
      // input is an class function into namespace
      if SaveScope.SearchToken(Input, ScopeFlag, Scope, 0, True, [tkFunction,
        tkConstructor, tkDestructor, tkOperator]) then
        SaveScope := Scope;
    end;
    ScopeSelStart := Scope.SelStart;
    ParentScope := Scope.Parent;
    Scope := GetTokenByName(Scope, 'Scope', tkScope);
    // get parent class, struct or union
    if Assigned(ParentScope) and (ParentScope.Token = tkScopeClass) then
      ParentScope := ParentScope.Parent;
    if not (ParentScope.Token in [tkClass, tkStruct, tkUnion]) then
      ParentScope := nil;
    for I := 0 to UsingList.Count - 1 do
    begin
      if UsingList[I] = '' then
        UsingAllFields := AllFields
      else
        UsingAllFields := UsingList[I] + '::' + AllFields;
      // only scope, ex: std::string
      if (UsingAllFields <> '') and (Input <> '') and (Pos('.', UsingAllFields) = 0) then
      begin
        FindedList := TRBTree.Create;
        Result := SearchTreeTokenClass(ParentScope, Scope, UsingAllFields, TokenFile,
          ScopeSelStart, FindedList);
        FindedList.Free;
        if Result then
        begin
          UsingList.Free;
          Exit;
        end;
      end;
    end;
  end
  else
    SaveScope := nil;
  //search base type and list fields and functions of struct, union or class
  if (AllFields <> '') then
  begin
    for I := 0 to UsingList.Count - 1 do
    begin
      if UsingList[I] = '' then
        UsingAllFields := AllFields
      else
        UsingAllFields := UsingList[I] + '::' + AllFields;
      FirstInput := GetFirstWord(UsingAllFields); //enum fields and functions class
      if GetFieldsBaseType(FirstInput, UsingAllFields, SelStart, TokenFile,
        FindedTokenFile, ClassToken) then
      begin
        AllowScope := [];
        if SaveScope <> nil then
        begin
          Scope := SaveScope; // current level
          ParentScope := Scope.Parent;
          Scope := GetTokenByName(Scope, 'Scope', tkScope);
          // get parent class, struct or union
          if Assigned(ParentScope) and (ParentScope.Token = tkScopeClass) then
            ParentScope := ParentScope.Parent;
          if not (ParentScope.Token in [tkClass, tkStruct, tkUnion]) then
            ParentScope := nil;
          // for implementation out of class, ret_type my_class::function
          // teste if class my_class is equal to my_class::
          AllScope := Assigned(Scope) and (Scope.Flag = ClassToken.Name);
          // test if in same scope
          if not AllScope and Assigned(ParentScope) and (ParentScope.Name = ClassToken.Name) then
              AllScope := True;
        end
        else
          AllScope := Pos('::', Fields) > 0;
        // allow only public statement
        if not AllScope then
          AllowScope := AllowScope + [scPublic];
        Result := SearchClassSource(Input, ClassToken, FindedTokenFile,
          TokenFileItem, Item, nil, False, AllowScope);
        if Result then
          Break;
      end;
    end;
  end
  // search global declaration
  else if AllFields = '' then
    Result := SearchSource(GetFirstWord(Input), TokenFile, TokenFileItem, Item, SelStart);
  UsingList.Free;
end;

function TTokenFiles.GetBaseTypeRecursive(const S: string;
  SelStart: Integer; TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
  var Token: TTokenClass; FindedList: TRBTree; ListAll: TStrings;
  AllFunctions: Boolean): Boolean;
var
  I: Integer;
  FilePath: string;
  LastWord: string;
  FindedTokenFile: TTokenFile;
begin
  LastWord := S;
  Result := False;
  while True do
  begin
    if TokenFile.GetBaseType(LastWord, Token, SelStart, ListAll, AllFunctions) then
    begin
      Result := True;
      TokenFileItem := TokenFile;
      if (Token.Token in [tkClass, tkStruct, tkUnion]) then
        Exit;
      LastWord := GetVarType(Token);
      if (Token.Token = tkDefine) then
        if IsNumber(LastWord) then
          Exit;
      if SelStart = Token.SelStart then
        Break;
      SelStart := Token.SelStart;
    end
    else
      Break;
  end;
  //don't search again
  FindedList.Add(TokenFile.FileName, TokenFile);

  //Skip token haven't a Ancestor type
  if not (Token.Token in [tkDefine, tkVariable, tkTypeStruct, tkTypeUnion,
    tkTypedef, tkPrototype, tkFunction, tkOperator]) then
    Exit;

  //searched filepath
  FilePath := ExtractFilePath(TokenFile.FileName);
  //search in all include files
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    if InvalidOrFinded(FindedTokenFile, FilePath, TokenFile.Includes.Items[I],
      FindedList) then
      Continue;
    LastWord := GetVarType(Token);
    if GetBaseTypeRecursive(LastWord, 0, FindedTokenFile, TokenFileItem, Token,
      FindedList, ListAll, AllFunctions) then
    begin
      Result := True;
      if not (Token.Token in [tkDefine, tkVariable, tkTypeStruct, tkTypeUnion,
        tkTypedef, tkPrototype, tkFunction, tkOperator]) then
        Break;
    end;
  end;
end;

function TTokenFiles.GetBaseType(const S: string; SelStart: Integer;
  TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
  var Token: TTokenClass; ListAll: TStrings; AllFunctions: Boolean): Boolean;
var
  FindedList: TRBTree;
begin
  if SearchTreeToken(S, TokenFile, TokenFileItem, Token,
    [tkClass, tkStruct, tkUnion, tkNamespace], SelStart) then
  begin
    if Token.Name = GetLastWord(S) then
    begin
      Result := True;
      Exit;
    end;
  end;
  FindedList := TRBTree.Create;
  { TODO -oMazin -c : Use Scope, Ex: Scope::Function() 04/05/2013 21:33:01 }
  Result := GetBaseTypeRecursive(S, SelStart, TokenFile, TokenFileItem,
    Token, FindedList, ListAll, AllFunctions);
  FindedList.Free;
end;

procedure TTokenFiles.FillCompletionClass(InsertList, ShowList: TStrings;
  CompletionColors: TCompletionColors; Images: array of Integer;
  TokenFile: TTokenFile; Item: TTokenClass; AllowScope: TScopeClassState;
  SkipFirst: Boolean);

  procedure FillCompletionClassRecursive(TokenItem: TTokenFile;
    Token: TTokenClass; aAllowScope, DenyScope: TScopeClassState;
    TokenList: TTokenList);
  var
    SearchClass: string;
    List: TStrings;
    I: Integer;
  begin
    //show all objects from class, struct or scope
    if not SkipFirst then
    begin
      FillCompletionTreeNoRepeat(InsertList, ShowList, Token, -1,
        CompletionColors, Images, TokenList, aAllowScope, False, True);
    end
    else
      SkipFirst := False;
    List := TStringList.Create;
    GetDescendants(Token.Flag, List, scPublic);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, '', TokenItem,
        TokenItem, Token, [tkClass, tkStruct, tkUnion], Token.SelStart) then
      begin
        //fill all decendent class
        FillCompletionClassRecursive(TokenItem, Token, aAllowScope, DenyScope,
          TokenList);
      end;
    end;
    if not (aAllowScope = []) then
    begin
      List.Free;
      Exit;
    end;
    GetDescendants(Token.Flag, List, scPrivate);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, '', TokenItem,
        TokenItem, Token, [tkClass, tkStruct, tkUnion], Token.SelStart) then
      begin
        //fill all decendent class
        FillCompletionClassRecursive(TokenItem, Token, aAllowScope, DenyScope,
          TokenList);
      end;
    end;
    GetDescendants(Token.Flag, List, scProtected);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, '', TokenItem,
        TokenItem, Token, [tkClass, tkStruct, tkUnion], Token.SelStart) then
      begin
        //fill all decendent class
        FillCompletionClassRecursive(TokenItem, Token, aAllowScope, DenyScope,
          TokenList);
      end;
    end;
    List.Free;
  end;

var
  TokenList: TTokenList;
  DenyScope: TScopeClassState;
begin
  TokenList := TTokenList.Create;
  DenyScope := [];
  if not (AllowScope = []) then
    DenyScope := [scPublic, scPrivate, scProtected] - AllowScope;
  FillCompletionClassRecursive(TokenFile, Item, AllowScope, DenyScope, TokenList);
  TokenList.Free;
end;

function TTokenFiles.GetFieldsBaseType(const S, Fields: string;
  SelStart: Integer; TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
  var Token: TTokenClass): Boolean;
var
  List: TStrings;
  I: Integer;
  Temp, AllFields, UsingAllFields: string;
  ScopeClass: TScopeClassState;
  UsingList: TStrings;
  SaveTokenFileItem: TTokenFile;
  SaveToken: TTokenClass;
  Finded: Boolean;
begin
  //search var->
  Result := SearchSource(S, TokenFile, TokenFileItem, Token, SelStart);
  if not Result then
    Exit;
  List := TStringList.Create;
  GetStringsFields(Fields, List);
  if (S <> 'this') then
  begin //'prototype var()->' or var.bla or func()->bla
    if (Token.Token in RetTypeTokens + [tkDefine]) then
    begin
      UsingList := TStringList.Create;
      TStringList(UsingList).Duplicates := dupIgnore;
      TStringList(UsingList).CaseSensitive := True;
      UsingList.Add('');
      TokenFileItem.GetUsingNames(UsingList, Token.SelStart);
      AllFields := GetVarType(Token);
      Finded := False;
      for I := 0 to UsingList.Count - 1 do
      begin
        if UsingList[I] = '' then
          UsingAllFields := AllFields
        else
          UsingAllFields := UsingList[I] + '::' + AllFields;
        SaveTokenFileItem := TokenFileItem;
        SaveToken := Token;
        if GetBaseType(UsingAllFields, Token.SelStart,
          TokenFileItem, TokenFileItem, Token) then
        begin
          Finded := True;
          Break;
        end;
        TokenFileItem := SaveTokenFileItem;
        Token := SaveToken;
      end;
      UsingList.Free;
      if not Finded then
      begin
        Result := List.Count = 0;
        List.Free;
        Exit;
      end;
    end;
  end;
  if (Token.Token in [tkTypedef]) then
    GetBaseType(GetVarType(Token), 0, TokenFile, TokenFileItem, Token);
  { TODO -oMazin -c : Consider Scope::Function() 04/05/2013 21:33:01 }
  for I := 0 to List.Count - 1 do
  begin
    ScopeClass := [scPublic];
    if Token.Token in RetTypeTokens then
    begin
      Temp := GetVarType(Token);
      //get var.field    note: field can be an function
      if StringIn(Temp, ReservedTypes) or not
        GetBaseType(Temp, 0, TokenFileItem, TokenFileItem, Token) then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
      ScopeClass := [];
    end
    else if Token.Token in [tkNamespace] then
    begin
      //get var.field    note: field can be an function
      Result := Token.SearchSource(List.Strings[I], Token);
      if not Result then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
    end
    else if not (Token.Token in TreeTokens) then
    begin
      Result := False;
      List.Free;
      Exit;
    end;
    if Token.Token in TreeTokens then
    begin
      //get var.field    note: field can be an function
      Result := SearchClassSource(List.Strings[I], Token, TokenFileItem,
        TokenFileItem, Token, nil, False, ScopeClass);
    end;
    if not Result then
    begin
      Result := False;
      List.Free;
      Exit;
    end;
    Temp := GetVarType(Token);
    //last parameter and get tree for completion
    // var.function()->
    if (Token.Token in RetTypeTokens) and not StringIn(Temp, ReservedTypes)
      and not GetBaseType(Temp, 0, TokenFileItem, TokenFileItem, Token) then
    begin
      Result := False;
      List.Free;
      Exit;
    end;
    // for linked lists
    if (Token.Token in [tkTypedef]) and (Pos('struct', Token.Flag) > 0) then
      GetBaseType(GetVarType(Token), 0, TokenFile, TokenFileItem, Token);
  end;
  List.Free;
  Result := True;
end;

function TTokenFiles.GetFieldsBaseParams(const S, Fields: string;
  SelStart: Integer; TokenFile: TTokenFile; ParamsList: TStrings): Boolean;
var
  List: TStrings;
  I: Integer;
  TokenFileItem: TTokenFile;
  Token: TTokenClass;
  AllFields, UsingAllFields: string;
  UsingList: TStrings;
  SaveTokenFileItem: TTokenFile;
  SaveToken: TTokenClass;
  Finded: Boolean;
begin
  List := TStringList.Create;
  GetStringsFields(Fields, List);
  if List.Count = 0 then
  begin
    //search function() or class() or prototype()
    Result := SearchSource(S, TokenFile, TokenFileItem, Token, SelStart,
      ParamsList, True);
    if ParamsList.Count > 0 then
    begin
      List.Free;
      Exit;
    end;
    //Search for constructor
    if Result and (Token.Token in [tkClass, tkTypeStruct, tkStruct, tkUnion,
      tkTypeUnion]) then
    begin
      if not SearchClassSource(S, Token, TokenFileItem,
        TokenFileItem, Token, ParamsList, True) then
      begin
        //add void contructor to paramlist
        Exit;
      end;
    end;
  end
  else
  begin
    //search var->
    Result := SearchSource(S, TokenFile, TokenFileItem, Token, SelStart);
  end;
  if not Result then
  begin
    List.Free;
    Exit;
  end;
  if (S <> 'this') then
  begin //prototype var(); or var.bla or func()->bla
    if ((Token.Token in [tkVariable, tkFunction, tkDefine]) and (List.Count > 0))
      or ((Token.Token in [tkVariable, tkDefine]) and (List.Count = 0)) then
    begin
      UsingList := TStringList.Create;
      TStringList(UsingList).Duplicates := dupIgnore;
      TStringList(UsingList).CaseSensitive := True;
      UsingList.Add('');
      TokenFileItem.GetUsingNames(UsingList, Token.SelStart);
      AllFields := GetVarType(Token);
      Finded := False;
      for I := 0 to UsingList.Count - 1 do
      begin
        if UsingList[I] = '' then
          UsingAllFields := AllFields
        else
          UsingAllFields := UsingList[I] + '::' + AllFields;
        SaveTokenFileItem := TokenFileItem;
        SaveToken := Token;
        //search for variable or return type
        if GetBaseType(UsingAllFields, Token.SelStart,
          TokenFileItem, TokenFileItem, Token, ParamsList, List.Count = 0) then
        begin
          Finded := True;
          Break;
        end;
        TokenFileItem := SaveTokenFileItem;
        Token := SaveToken;
      end;
      UsingList.Free;
      if not Finded then
      begin
        List.Free;
        Exit;
      end;
      if (List.Count = 0) and (Token.Token in [tkTypedefProto]) then
        ParamsList.AddObject('', Token);
    end;
  end;
  if (Token.Token in [tkTypedef]) then
    GetBaseType(GetVarType(Token), 0, TokenFile, TokenFileItem, Token);
  { TODO -oMazin -c : Consider Scope::Function() 04/05/2013 21:33:01 }
  for I := 0 to List.Count - 1 do
  begin
    if (Token.Token in [tkClass, tkTypeStruct, tkStruct, tkUnion,
      tkTypeUnion]) then
    begin
      if (I = List.Count - 1) then
      begin
        //class->var_of_ancestor or class->function_of_ancestor
        if not SearchClassSource(List.Strings[I], Token, TokenFileItem,
          TokenFileItem, Token, ParamsList, True) then
        begin
          Result := False;
          List.Free;
          Exit;
        end;
      end
      else
      begin
        //class->var_of_ancestor-> or class->function_of_ancestor->
        //don't add
        if not SearchClassSource(List.Strings[I], Token, TokenFileItem,
          TokenFileItem, Token) then
        begin
          Result := False;
          List.Free;
          Exit;
        end;
      end;
      //variable is an prototype?
      if (Token.Token in [tkVariable]) then
      begin
        // int a, char b, ...
        if StringIn(GetVarType(Token), ReservedTypes) then
        begin
          Result := False;
          List.Free;
          Exit;
        end
        //class var, prototype var;
        else if not GetBaseType(GetVarType(Token), 0, TokenFileItem,
          TokenFileItem, Token) then
        begin
          Result := False;
          List.Free;
          Exit;
        end
        //base of type of var is an prototype and last fild
        else if (Token.Token in [tkTypedefProto]) and (I = List.Count - 1) then
          ParamsList.AddObject('', Token)
        else
          Result := False;
        if not Result then
        begin
          Result := False;
          List.Free;
          Exit;
        end;
      end;
    end
    //'type var->' or function()->
    else if (Token.Token in [tkFunction, tkPrototype, tkOperator, tkVariable]) then
    begin
      //int a, char b, ...
      if StringIn(GetVarType(Token), ReservedTypes) then
      begin
        Result := False;
        List.Free;
        Exit;
      end
      //class var, struct var, class function, struct function
      else if not GetBaseType(GetVarType(Token), 0, TokenFileItem,
        TokenFileItem, Token) then
      begin
        Result := False;
        List.Free;
        Exit;
      end
      //base of type of var or function is an prototype and last field
      else if (Token.Token in [tkTypedefProto]) and (I = List.Count - 1) then
        ParamsList.AddObject('', Token)
      //base of type of var is class, struct or union
      else if Token.Token in [tkClass, tkTypeStruct, tkStruct, tkUnion,
        tkTypeUnion] then
        Result := SearchClassSource(List.Strings[I], Token, TokenFileItem,
          TokenFileItem, Token)
      else
        Result := False;
      //int var, char function
      if not Result then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
    end
    else
    begin
      Result := False;
      List.Free;
      Exit;
    end;
  end;
  List.Free;
  Result := True;
end;

procedure TTokenFiles.FillCompletionListRecursive(InsertList,
  ShowList: TStrings; TokenFile: TTokenFile; SelStart: Integer;
  FindedList: TRBTree; CompletionColors: TCompletionColors;
  Images: array of Integer);
var
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  FillCompletion(InsertList, ShowList, TokenFile.VarConsts, SelStart, CompletionColors, Images);
  FillCompletion(InsertList, ShowList, TokenFile.FuncObjs, SelStart, CompletionColors, Images);
  FillCompletion(InsertList, ShowList, TokenFile.TreeObjs, SelStart, CompletionColors, Images);
  FillCompletion(InsertList, ShowList, TokenFile.Defines, SelStart, CompletionColors, Images);

  //don't search again
  FindedList.Add(TokenFile.FileName, TokenFile);
  //searched filepath
  FilePath := ExtractFilePath(TokenFile.FileName);
  //search in all include files
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    if InvalidOrFinded(FindedTokenFile, FilePath, TokenFile.Includes.Items[I],
      FindedList) then
      Continue;
    FillCompletionListRecursive(InsertList, ShowList, FindedTokenFile, -1,
      FindedList, CompletionColors, Images);
  end;
end;

procedure TTokenFiles.FillCompletionList(InsertList,
  ShowList: TStrings; TokenFile: TTokenFile; SelStart: Integer;
  CompletionColors: TCompletionColors; Images: array of Integer);
var
  FindedList: TRBTree;
begin
  FindedList := TRBTree.Create;
  FillCompletionListRecursive(InsertList, ShowList, TokenFile,
      SelStart, FindedList, CompletionColors, Images);
  FindedList.Free;
end;

procedure FillCompletion(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; Images: array of Integer;
  IncludeParams: Boolean);
var
  I: Integer;
  NewToken, Scope: TTokenClass;
  ShowClassFunction: Boolean;
begin
  for I := 0 to Token.Count - 1 do
  begin
    if (SelStart >= 0) and (Token.Items[I].SelStart > SelStart) then
      Exit;
    ShowClassFunction := True;
    if not (Token.Items[I].Token in [tkEnumItem, tkEnum, tkTypeEnum]) then
    begin
      if (Token.Items[I].Token in [tkScope, tkUsing, tkOperator]) or
        ((Token.Items[I].Level > 0) and (Token.Token <> tkFuncProList) and not IncludeParams) then
        Continue;
      if Token.Items[I].Token in [tkFunction, tkConstructor, tkDestructor] then
      begin
        Scope := GetTokenByName(Token.Items[I], 'Scope', tkScope);
        if Assigned(Scope) and (Scope.Flag <> '') then
          ShowClassFunction := False;
      end;
    end
    else
      ShowClassFunction := True;
    if not (Token.Items[I].Token in [tkParams]) and ShowClassFunction then
    begin
      NewToken := Token.Items[I];//TTokenClass.Create;
      //NewToken.Assign(Token.Items[I]); //copy
      if Assigned(InsertList) then
        InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      if Assigned(ShowList) then
        ShowList.AddObject(CompletionShowItem(NewToken, CompletionColors, Images), NewToken);
      if Token.Items[I].Token in
        [tkStruct, tkTypedef, tkClass, tkUnion, tkScopeClass] then
        Continue;
    end
    else if not IncludeParams then
      Continue;
    case Token.Items[I].Token of
      {tkClass, }tkFunction {, tkStruct}, tkParams, tkEnum, tkTypeEnum:
        FillCompletion(InsertList, ShowList, Token.Items[I], SelStart,
          CompletionColors, Images, IncludeParams);
    end;
  end;
end;

end.
