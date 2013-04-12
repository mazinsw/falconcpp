unit TokenFile;

interface

uses
  CppParser, TokenList, Classes, TokenConst, Dialogs, rbtree;

type
  //forward
  TTokenFiles = class;
  TTokenFile = class;
  TTokenParseMethod = (
    tpmParseAndLoad,
    tpmParseAndSave,
    tpmParseAndLoadRecursive,
    tpmLoadParsedRecursive
    );

  TProgressEvent = procedure(Sender: TObject; TokenFile: TTokenFile; const FileName: string; Current,
    Total: Integer; Parsed: Boolean; Method: TTokenParseMethod) of object;

  TFileObject = class
    ID: Pointer;
    FileName: string;
    Text: string;
  end;

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
    function LoadFromFileRecurse(Handle: Integer;
      ParentList: TTokenClass; Count: Integer): Boolean;
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

    procedure GetFunctions(List: TStrings);
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

    function SearchToken(const S: string; var Item: TTokenClass;
      SelStart: Integer; AdvanceAfterSelStart: Boolean;
      Mode: TTokenSearchMode): Boolean;
    function SearchSource(const S: string; var Item: TTokenClass;
      NotAtSelStart: Integer; AdvanceAfterSelStart: Boolean = False;
      ListAll: TStrings = nil; AllFunctions: Boolean = False): Boolean;

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
    fParser: TCppParser;
    fCancel: Boolean;
    fBusy: Boolean;
    fMethod: TTokenParseMethod;
    fOnStart: TNotifyEvent;
    fOnProgress: TProgressEvent;
    fOnFinish: TNotifyEvent;
    fPathList: TStrings;
    fIncludeList: TStrings;
    procedure ParserProgress(Sender: TObject; Current, Total: Integer);
    procedure Put(const FileName: string; Value: TTokenFile);
    function Get(const FileName: string): TTokenFile;
    procedure SetPathList(Value: TStrings);
    procedure SetIncludeList(Value: TStrings);

    function ParseRecursiveAux(const FileName: string; FilesParsed: Integer;
      fProgressEvent: TProgressEvent): Integer;
    function LoadRecursiveAux(const FileName, BaseDir, FromBaseDir,
      Extension: string; FilesParsed: Integer; fProgressEvent: TProgressEvent): Integer;

      //search
    function SearchSourceRecursive(const S: string;
      TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Item: TTokenClass;
      FindedList: TRBTree; SelStart: Integer = 0; ListAll: TStrings = nil;
      AllFunctions: Boolean = False): Boolean;
    function GetBaseTypeRecursive(const S: string;
      SelStart: Integer; TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
      var Token: TTokenClass; FindedList: TRBTree; ListAll: TStrings;
      AllFunctions: Boolean): Boolean;
    function SearchTokenRecursive(const S: string; TokenFile: TTokenFile;
      var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
      FindedList: TRBTree; SelStart: Integer): Boolean;
    function InvalidOrFinded(var FindedTokenFile: TTokenFile;
      const FilePath: string; IncludeToken: TTokenClass;
      FindedList: TRBTree): Boolean;
    procedure FillCompletionListRecursive(InsertList,
      ShowList: TStrings; TokenFile: TTokenFile; FindedList: TRBTree;
      CompletionColors: TCompletionColors);
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

    //parser
    property OnStart: TNotifyEvent read fOnStart write fOnStart;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property OnFinish: TNotifyEvent read fOnFinish write fOnFinish;
    property Parser: TCppParser read fParser;

    property Busy: Boolean read fBusy;

    function ParseAndSaveFiles(FileList: TStrings;
      const BaseDir, DestBaseDir, Extension: string): Boolean; overload;

    function ParseAndSaveFiles(FileList: TStrings;
      const BaseDir, DestBaseDir, Extension: string; fStartEvent: TNotifyEvent;
      fProgressEvent: TProgressEvent; fFinishEvent: TNotifyEvent): Boolean; overload;

    function LoadRecursive(const FileName, BaseDir, FromBaseDir,
      Extension: string): Integer; overload;

    function LoadRecursive(const FileName, BaseDir, FromBaseDir,
      Extension: string; fStartEvent: TNotifyEvent; fProgressEvent: TProgressEvent;
      fFinishEvent: TNotifyEvent): Integer; overload;

    function ParseLoad(FileList: TStrings): Boolean; overload;

    function ParseLoad(FileList: TStrings; fStartEvent: TNotifyEvent;
      fProgressEvent: TProgressEvent; fFinishEvent: TNotifyEvent): Boolean; overload;

    function ParseRecursive(const FileName: string): Integer; overload;
    function ParseRecursive(const FileName: string; fStartEvent: TNotifyEvent;
      fProgressEvent: TProgressEvent; fFinishEvent: TNotifyEvent): Integer; overload;

    procedure Cancel;

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
    function SearchToken(const S: string; TokenFile: TTokenFile;
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
      CompletionColors: TCompletionColors);
    procedure FillCompletionClass(InsertList, ShowList: TStrings;
      CompletionColors: TCompletionColors; TokenFile: TTokenFile;
      Item: TTokenClass; AllowScope: TScopeClassState = []);

    constructor Create;
    destructor Destroy; override;
  end;

procedure FillCompletion(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors;
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

function TTokenFile.LoadFromFileRecurse(Handle: Integer;
  ParentList: TTokenClass; Count: Integer): Boolean;
var
  I: Integer;
  TokenRec: TTokenRec;
  Buffer: array[0..4095] of Char;
  Item: TTokenClass;
begin
  for I := 0 to Count - 1 do
  begin
    Item := TTokenClass.Create(ParentList);
    Item.Owner := Self;
    ParentList.Add(Item);
    FileRead(Handle, TokenRec.Count, SizeOf(Word));
    FileRead(Handle, TokenRec.Line, SizeOf(Integer));
    Item.SelLine := TokenRec.Line;
    FileRead(Handle, TokenRec.Start, SizeOf(Integer));
    Item.SelStart := TokenRec.Start;
    FileRead(Handle, TokenRec.SelLen, SizeOf(Word));
    Item.SelLength := TokenRec.SelLen;
    FileRead(Handle, TokenRec.Level, SizeOf(Word));
    Item.Level := TokenRec.Level;
    FileRead(Handle, TokenRec.Token, SizeOf(TTkType));
    Item.Token := TokenRec.Token;
    FileRead(Handle, TokenRec.Len1, SizeOf(Word));
    FileRead(Handle, Buffer, TokenRec.Len1);
    Buffer[TokenRec.Len1] := #0;
    Item.Name := StrPas(Buffer);
    FileRead(Handle, TokenRec.Len2, SizeOf(Word));
    FileRead(Handle, Buffer, TokenRec.Len2);
    Buffer[TokenRec.Len2] := #0;
    Item.Flag := StrPas(Buffer);
    LoadFromFileRecurse(Handle, Item, TokenRec.Count);
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
  if not CompareMem(Pointer(@Header.Sign), PChar(TokenList.Sign),
    Sizeof(Header.Sign)) then
  begin
    FileClose(Handle);
    Exit;
  end;
  FileClose(Handle);
  Result := True;
end;

function TTokenFile.LoadFromFile(const FileName, ParsedFileName: string): Boolean;
var
  Handle, I: Integer;
  Header: TSimpleFileToken;
  Buffer: array[0..4095] of Char;
  TokenRec: TTokenRec;
  TkList: TTokenClass;
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
  if not CompareMem(Pointer(@Header.Sign), PChar(TokenList.Sign),
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
  TkList := nil;
  for I := 0 to Header.Count - 1 do
  begin
    FileRead(Handle, TokenRec.Count, SizeOf(Word));
    FileRead(Handle, TokenRec.Line, SizeOf(Integer));
    FileRead(Handle, TokenRec.Start, SizeOf(Integer));
    FileRead(Handle, TokenRec.SelLen, SizeOf(Word));
    FileRead(Handle, TokenRec.Level, SizeOf(Word));
    FileRead(Handle, TokenRec.Token, SizeOf(TTkType));
    FileRead(Handle, TokenRec.Len1, SizeOf(Word));
    FileRead(Handle, Buffer, TokenRec.Len1);
    Buffer[TokenRec.Len1] := #0;
    TokenRec.Name := StrPas(Buffer);
    FileRead(Handle, TokenRec.Len2, SizeOf(Word));
    FileRead(Handle, Buffer, TokenRec.Len2);
    Buffer[TokenRec.Len2] := #0;
    TokenRec.Flag := StrPas(Buffer);

    case TokenRec.Token of
      tkIncludeList: TkList := FIncludeList;
      tkDefineList: TkList := FDefineList;
      tkTreeObjList: TkList := FTreeObjList;
      tkVarConsList: TkList := FVarConstList;
      tkFuncProList: TkList := FFuncObjList;
    else
      FileClose(Handle);
      Result := True;
      Exit;
    end;
    LoadFromFileRecurse(Handle, TkList, TokenRec.Count);
  end;
  FileClose(Handle);
  Result := True;
end;

procedure TTokenFile.SaveToFileRecurse(Handle: Integer; ItemList: TTokenClass);
var
  I: Integer;
  TokenRec: TTokenRec;
begin
  TokenRec.Count := ItemList.Count;
  FileWrite(Handle, TokenRec.Count, SizeOf(Word));
  TokenRec.Line := ItemList.SelLine;
  FileWrite(Handle, TokenRec.Line, SizeOf(Integer));
  TokenRec.Start := ItemList.SelStart;
  FileWrite(Handle, TokenRec.Start, SizeOf(Integer));
  TokenRec.SelLen := ItemList.SelLength;
  FileWrite(Handle, TokenRec.SelLen, SizeOf(Word));
  TokenRec.Level := ItemList.Level;
  FileWrite(Handle, TokenRec.Level, SizeOf(Word));
  TokenRec.Token := ItemList.Token;
  FileWrite(Handle, TokenRec.Token, SizeOf(TTkType));
  TokenRec.Len1 := Length(ItemList.Name);
  FileWrite(Handle, TokenRec.Len1, SizeOf(Word));
  FileWrite(Handle, PChar(ItemList.Name)^, TokenRec.Len1);
  TokenRec.Len2 := Length(ItemList.Flag);
  FileWrite(Handle, TokenRec.Len2, SizeOf(Word));
  FileWrite(Handle, PChar(ItemList.Flag)^, TokenRec.Len2);
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
  Move(TokenList.Sign, Header.Sign, Sizeof(Header.Sign));
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

function TTokenFile.SearchToken(const S: string; var Item: TTokenClass;
  SelStart: Integer; AdvanceAfterSelStart: Boolean; Mode: TTokenSearchMode): Boolean;

  function HasOneToken(aCheck, aMode: TTokenSearchMode): Boolean;
  begin
    Result := not ((aCheck - aMode) = aMode) or (aMode = []);
  end;

begin
  Result := True;
  if HasOneToken([tkClass, tkStruct, tkTypeStruct, tkTypedef,
    tkTypedefProto, tkEnum, tkUnion, tkNamespace], Mode) then
    if FTreeObjList.SearchToken(S, Item, SelStart,
      AdvanceAfterSelStart, Mode) then
      Exit;
  if HasOneToken([tkVariable, tkForward], Mode) then
    if FVarConstList.SearchToken(S, Item, SelStart,
      AdvanceAfterSelStart, Mode) then
      Exit;
  if HasOneToken([tkPrototype, tkFunction], Mode) then
    if FFuncObjList.SearchToken(S, Item, SelStart, AdvanceAfterSelStart,
      Mode) then
      Exit;
  if HasOneToken([tkInclude], Mode) then
    if FIncludeList.SearchToken(S, Item, SelStart, AdvanceAfterSelStart,
      Mode) then
      Exit;
  if HasOneToken([tkDefine], Mode) then
    if FDefineList.SearchToken(S, Item, SelStart, AdvanceAfterSelStart,
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

procedure TTokenFile.GetFunctions(List: TStrings);
begin
  FuncObjs.GetFunctions(List);
  TreeObjs.GetFunctions(List);
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
  fParser := TCppParser.Create;
  fParser.OnProgess := ParserProgress;
end;

destructor TTokenFiles.Destroy;
begin
  Clear;         
  fIncludeList.Free;
  fPathList.Free;
  fParser.Free;
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

//parse functions

function TTokenFiles.ParseLoad(FileList: TStrings): Boolean;
begin
  Result := ParseLoad(FileList, fOnStart, fOnProgress, fOnFinish);
end;

function TTokenFiles.ParseLoad(FileList: TStrings; fStartEvent: TNotifyEvent;
  fProgressEvent: TProgressEvent; fFinishEvent: TNotifyEvent): Boolean;
var
  I: Integer;
  TokenFile: TTokenFile;
  Text: TStringList;
  ParserOk: Boolean;
  FileObj: TFileObject;
  S: string;
begin
  fCancel := False;
  fBusy := True;
  fMethod := tpmParseAndLoad;
  if Assigned(fStartEvent) then
    fStartEvent(Self);
  Text := TStringList.Create;
  I := 0;
  while FileList.Count > 0 do
  begin
    ParserOk := False;
    if fCancel then
      Break;
    S := FileList.Strings[0];
    TokenFile := nil;
    FileObj := TFileObject(FileList.Objects[0]);
    if S <> '-' then
    begin
      S := FileObj.FileName;
      if FileExists(S) and (ItemOfByFileName(S) = nil) then
      begin
        TokenFile := TTokenFile.Create(Self);
        TokenFile.FileName := S;
        TokenFile.Data := FileObj.ID;
        Text.LoadFromFile(S);
        fParser.Parse(Text.Text, TokenFile);
        if fCancel then
        begin
          TokenFile.Free;
          Break;
        end;
        Add(TokenFile);
        ParserOk := True;
      end;
    end
    else
    begin
      S := FileObj.FileName;
      if ItemOfByFileName(S) = nil then
      begin
        TokenFile := TTokenFile.Create(Self);
        TokenFile.FileName := S;
        TokenFile.Data := FileObj.ID;
        fParser.Parse(FileObj.Text, TokenFile);
        if fCancel then
        begin
          TokenFile.Free;
          FileObj.Free;
          Break;
        end;
        Add(TokenFile);
        ParserOk := True;
      end
      else
        FileObj.Free;
    end;
    if Assigned(fProgressEvent) then
      fProgressEvent(Self, TokenFile, S, I + 1, FileList.Count, ParserOk,
        fMethod);
    FileList.Delete(0);
    Inc(I);
  end;
  Text.Free;
  if Assigned(fFinishEvent) then
    fFinishEvent(Self);
  Result := not fCancel;
  fBusy := False;
end;

function TTokenFiles.ParseRecursiveAux(const FileName: string;
  FilesParsed: Integer; fProgressEvent: TProgressEvent): Integer;
var
  I, J: Integer;
  TokenFile: TTokenFile;
  Text: TStringList;
  PathOnly, IncludeFileName, IncludeName: string;
begin
  Result := FilesParsed;
  if not FileExists(FileName) then
    Exit;
  if ItemOfByFileName(FileName) <> nil then
    Exit;
  if fCancel then
    Exit;
  Text := TStringList.Create;
  TokenFile := TTokenFile.Create(Self);
  TokenFile.FileName := FileName;
  Text.LoadFromFile(FileName);
  fParser.Parse(Text.Text, TokenFile);
  Text.Free;
  if fCancel then
  begin
    TokenFile.Free;
    Exit;
  end;
  Add(TokenFile);
  Inc(Result);
  if Assigned(fProgressEvent) then
    fProgressEvent(Self, TokenFile, FileName, Result, Result, True, fMethod);
  PathOnly := ExtractFilePath(FileName);
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    IncludeName := ConvertSlashes(TokenFile.Includes.Items[I].Name);
    if TokenFile.Includes.Items[I].Flag = 'S' then
    begin
      for J := 0 to PathList.Count - 1 do
      begin
        IncludeFileName := ExpandFileName(PathList.Strings[J] + IncludeName);
        if FileExists(IncludeFileName) then
          Break;
      end;
    end
    else
    begin
      IncludeFileName := ExpandFileName(PathOnly + IncludeName);
      if not FileExists(IncludeFileName) then
      begin
        for J := 0 to PathList.Count - 1 do
        begin
          IncludeFileName := ExpandFileName(PathList.Strings[J] + IncludeName);
          if FileExists(IncludeFileName) then
            Break;
        end;
      end;
    end;
    if ItemOfByFileName(IncludeFileName) <> nil then
      Continue;
    if fCancel then
      Exit;
    Result := ParseRecursiveAux(IncludeFileName, Result, fProgressEvent);
  end;
end;

function TTokenFiles.ParseRecursive(const FileName: string): Integer;
begin
  Result := ParseRecursive(FileName, fOnStart, fOnProgress, fOnFinish);
end;

function TTokenFiles.ParseRecursive(const FileName: string;
  fStartEvent: TNotifyEvent; fProgressEvent: TProgressEvent;
  fFinishEvent: TNotifyEvent): Integer;
begin
  fCancel := False;
  fBusy := True;
  fMethod := tpmParseAndLoadRecursive;
  if Assigned(fStartEvent) then
    fStartEvent(Self);
  Result := ParseRecursiveAux(FileName, 0, fProgressEvent);
  if Assigned(fFinishEvent) then
    fFinishEvent(Self);
  fBusy := False;
end;

function TTokenFiles.LoadRecursiveAux(const FileName, BaseDir, FromBaseDir,
  Extension: string; FilesParsed: Integer; fProgressEvent: TProgressEvent): Integer;
var
  I, J: Integer;
  TokenFile: TTokenFile;
  FromName, DirFrom, DirBase, IncludeName, IncludeFileName: string;
begin
  Result := FilesParsed;
  if ItemOfByFileName(FileName) <> nil then
    Exit;
  if fCancel then
    Exit;
  DirFrom := IncludeTrailingPathDelimiter(FromBaseDir);
  DirFrom := DirFrom + ExtractRelativePath(BaseDir, ExtractFilePath(FileName));
  DirFrom := IncludeTrailingPathDelimiter(DirFrom);
  FromName := DirFrom + ExtractFileName(FileName);
  FromName := ChangeFileExt(FromName, Extension);
  if not FileExists(FromName) or not FileExists(FileName) then
    Exit;
  TokenFile := TTokenFile.Create(Self);
  if not TokenFile.LoadFromFile(FileName, FromName) then
  begin
    TokenFile.Free;
    Exit;
  end;
  if fCancel then
  begin
    TokenFile.Free;
    Exit;
  end;
  Add(TokenFile);
  Inc(Result);
  if Assigned(fProgressEvent) then
    fProgressEvent(Self, TokenFile, FileName, Result, Result, True, fMethod);
  DirBase := ExtractFilePath(FileName);
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    IncludeName := ConvertSlashes(TokenFile.Includes.Items[I].Name);
    if TokenFile.Includes.Items[I].Flag = 'S' then
    begin
      for J := 0 to PathList.Count - 1 do
      begin
        IncludeFileName := PathList.Strings[J] + IncludeName;
        if FileExists(IncludeFileName) then
          Break;
      end;
    end
    else
    begin
      IncludeFileName := DirBase + IncludeName;
      if not FileExists(IncludeFileName) then
      begin
        for J := 0 to PathList.Count - 1 do
        begin
          IncludeFileName := PathList.Strings[J] + IncludeName;
          if FileExists(IncludeFileName) then
            Break;
        end;
      end;
    end;
    if ItemOfByFileName(IncludeFileName) <> nil then
      Continue;
    if fCancel then
      Exit;
    Result := LoadRecursiveAux(IncludeFileName, BaseDir, FromBaseDir, Extension,
      Result, fProgressEvent);
    if fCancel then
      Exit;
  end;
end;

function TTokenFiles.LoadRecursive(const FileName, BaseDir, FromBaseDir,
  Extension: string): Integer;
begin
  Result := LoadRecursive(FileName, BaseDir, FromBaseDir, Extension, fOnStart,
    fOnProgress, fOnFinish);
end;

function TTokenFiles.LoadRecursive(const FileName, BaseDir, FromBaseDir,
  Extension: string; fStartEvent: TNotifyEvent; fProgressEvent: TProgressEvent;
  fFinishEvent: TNotifyEvent): Integer;
begin
  fCancel := False;
  fBusy := True;
  fMethod := tpmLoadParsedRecursive;
  if Assigned(fStartEvent) then
    fStartEvent(Self);
  Result := LoadRecursiveAux(FileName, BaseDir, FromBaseDir, Extension, 0,
    fProgressEvent);
  if Assigned(fFinishEvent) then
    fFinishEvent(Self);
  fBusy := False;
end;

function TTokenFiles.ParseAndSaveFiles(FileList: TStrings;
  const BaseDir, DestBaseDir, Extension: string): Boolean;
begin
  Result := ParseAndSaveFiles(FileList, BaseDir, DestBaseDir, Extension,
    fOnStart, fOnProgress, fOnFinish);
end;

function TTokenFiles.ParseAndSaveFiles(FileList: TStrings; const BaseDir, DestBaseDir,
  Extension: string; fStartEvent: TNotifyEvent; fProgressEvent: TProgressEvent;
  fFinishEvent: TNotifyEvent): Boolean;
var
  I: Integer;
  TokenFile: TTokenFile;
  Text: TStringList;
  ParserOk, CanParse: Boolean;
  DestName, DirDest: string;
  Header: TSimpleFileToken;
begin
  fCancel := False;
  fBusy := True;
  fMethod := tpmParseAndSave;
  if Assigned(fStartEvent) then
    fStartEvent(Self);
  Text := TStringList.Create;
  for I := 0 to FileList.Count - 1 do
  begin
    ParserOk := False;
    if fCancel then
      Break;
    DestName := FileList.Strings[I];
    if FileExists(FileList.Strings[I]) then
    begin
      DirDest := IncludeTrailingPathDelimiter(DestBaseDir);
      DirDest := DirDest + ExtractRelativePath(BaseDir, ExtractFilePath(FileList.Strings[I]));
      DirDest := IncludeTrailingPathDelimiter(DirDest);
      DestName := DirDest + ExtractFileName(FileList.Strings[I]);
      DestName := ChangeFileExt(DestName, Extension);
      CanParse := True;
      TokenFile := TTokenFile.Create(Self);
      TokenFile.FileDate := FileDateTime(FileList.Strings[I]);
      if FileExists(DestName) then
      begin
        if TokenFile.LoadHeader(DestName, Header) then
        begin
          CanParse := TokenFile.FileDate <> Header.DateOfFile;
        end;
      end;
      if CanParse then
      begin
        TokenFile.FileName := FileList.Strings[I];
        Text.LoadFromFile(FileList.Strings[I]);
        fParser.Parse(Text.Text, TokenFile);
        if fCancel then
        begin
          TokenFile.Free;
          Break;
        end;
        ForceDirectories(DirDest);
        TokenFile.SaveToFile(DestName);
      end;
      TokenFile.Free;
      ParserOk := True;
    end;
    if Assigned(fProgressEvent) then
      fProgressEvent(Self, nil, FileList.Strings[I], I + 1, FileList.Count, ParserOk, fMethod);
  end;
  Text.Free;
  if Assigned(fFinishEvent) then
    fFinishEvent(Self);
  Result := not fCancel;
  fBusy := False;
end;

procedure TTokenFiles.Cancel;
begin
  fCancel := True;
  fParser.Cancel;
end;

procedure TTokenFiles.ParserProgress(Sender: TObject; Current, Total: Integer);
begin
  if fCancel then
    fParser.Cancel;
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
    (Token.Parent.Token in [tkClass, tkStruct, tkScopeClass]) then
  begin
    Token := Token.Parent;
    AllScope := True;
  end;
  //tree parent object?
  if Assigned(Token.Parent) and
    (Token.Parent.Token in [tkClass, tkStruct]) then
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
      TokenFile, Token, [tkClass, tkNamespace], Token.SelStart);
  end;
  if AllScope then
  begin
    if Token.Token = tkClass then
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
      if SearchToken(SearchClass, TokenItem,
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
      if SearchToken(SearchClass, TokenItem,
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
      if SearchToken(SearchClass, TokenItem,
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
  //get current object in location
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
      (Token.Parent.Token in [tkClass, tkStruct, tkScopeClass]) then
    begin
      Token := Token.Parent;
      AllScope := True;
    end;
    //tree parent object?
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkClass, tkStruct]) then
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
        Fields := Token.Name + '::' + Fields;
      end;
      AllScope := SearchTreeToken(Fields, TokenFile,
        TokenFileItem, Token, [tkClass, tkNamespace], Token.SelStart);
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

function TTokenFiles.SearchTokenRecursive(const S: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
  FindedList: TRBTree; SelStart: Integer): Boolean;
var
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  Result := TokenFile.SearchToken(S, Token, SelStart, False, Mode);
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
    Result := SearchTokenRecursive(S, FindedTokenFile, TokenFileItem, Token, Mode, FindedList, 0);
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

function TTokenFiles.SearchToken(const S: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Token: TTokenClass; Mode: TTokenSearchMode;
  SelStart: Integer): Boolean;
var
  FindedList: TRBTree;
begin
  FindedList := TRBTree.Create;
  Result := SearchTokenRecursive(S, TokenFile, TokenFileItem, Token,
    Mode, FindedList, SelStart);
  FindedList.Free;
end;

function TTokenFiles.SearchTreeTokenRecursive(const Fields: string;
  TokenFile: TTokenFile; var TokenFileItem: TTokenFile; var Token: TTokenClass;
  Mode: TTokenSearchMode; FindedList: TRBTree; SelStart: Integer): Boolean;
var
  List: TStrings;
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  Result := False;
  List := TStringList.Create;
  GetStringsFields(Fields, List, False);
  if TokenFile.SearchToken(List.Strings[0], Token, SelStart, False, Mode) then
  begin
    Result := True;
    //direction ------>---->---->>>
    //fields = namespace1::namespace2::myclass
    for I := 1 to List.Count - 1 do
    begin
      if not Token.SearchToken(List.Strings[I], Token, SelStart, False, Mode) then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
  List.Free;
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
  FindedList.Free;
end;

function TTokenFiles.FindDeclaration(const Input, Fields: string; TokenFile: TTokenFile;
  var TokenFileItem: TTokenFile; var Item: TTokenClass;
  SelStart, SelLine: Integer): Boolean;
var
  S, AllFields, FirstInput: string;
  AllowScope: TScopeClassState;
  Scope, SaveScope, saveItem: TTokenClass;
  saveTokenFileItem: TTokenFile;
  AllScope: Boolean;
begin
  AllFields := Fields;
  if TokenFile.GetScopeAt(Item, SelStart) then
  begin
    if (Item.Token in [tkNamespace]) then
    begin
      AllFields := Item.Name + '::' + AllFields;
      while Assigned(Item.Parent) and (Item.Parent.Token in [tkNamespace]) do
      begin
        Item := Item.Parent;
        AllFields := Item.Name + '::' + AllFields;
      end;
    end;
    if (AllFields <> '') and SearchTreeToken(AllFields, TokenFile,
      TokenFileItem, Item, [tkClass, tkNamespace], Item.SelStart) then
    begin
      if (Input <> '') and Item.SearchSource(Input, Item) then
      begin
        //finded
        Result := True;
        Exit;
      end;
    end;
  end;

  S := AllFields;
  //AllFields := AllFields + Input;
  FirstInput := GetFirstWord(AllFields); //enum fields and functions class
    //search base type and list fields and functions of struct, union or class

  if (S <> '') and GetFieldsBaseType(FirstInput, AllFields,
    SelStart, TokenFile, TokenFileItem, Item) then
  begin

    AllowScope := [];
    if TokenFile.GetScopeAt(Scope, SelStart) then
    begin
      SaveScope := Scope;
      Scope := GetTokenByName(Scope, 'Scope', tkScope);
      AllScope := Assigned(Scope) and (Scope.Flag = Item.Name);
      if not AllScope then
      begin
        SaveScope := SaveScope.Parent;
        if Assigned(SaveScope) and (SaveScope.Token = tkScopeClass) then
          SaveScope := SaveScope.Parent;
        if Assigned(SaveScope) and (SaveScope.Name = Item.Name) then
          AllScope := True;
      end;
    end
    else
      AllScope := Pos('::', Fields) > 0;
    if not AllScope then
      AllowScope := AllowScope + [scPublic];
    saveItem := Item;
    saveTokenFileItem := TokenFileItem;
    Result := SearchClassSource(Input, saveItem, saveTokenFileItem, TokenFileItem, Item, nil,
      False, AllowScope);
    Exit;
  end
  else if (S = '') and SearchSource(GetFirstWord(AllFields + Input), TokenFile,
    TokenFileItem, Item, SelStart) then
  begin
    //finded
    Result := True;
    Exit;
  end;
  Result := False;
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
      LastWord := GetVarType(Token.Flag);
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
    tkTypedef, tkPrototype, tkFunction]) then
    Exit;

  //searched filepath
  FilePath := ExtractFilePath(TokenFile.FileName);
  //search in all include files
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    if InvalidOrFinded(FindedTokenFile, FilePath, TokenFile.Includes.Items[I],
      FindedList) then
      Continue;
    LastWord := GetVarType(Token.Flag);
    if GetBaseTypeRecursive(LastWord, 0, FindedTokenFile, TokenFileItem, Token,
      FindedList, ListAll, AllFunctions) then
    begin
      Result := True;
      if not (Token.Token in [tkDefine, tkVariable, tkTypeStruct, tkTypeUnion,
        tkTypedef, tkPrototype, tkFunction]) then
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
    [tkClass, tkNamespace], SelStart) then
  begin
    if Token.Name = GetLastWord(S) then
    begin
      Result := True;
      Exit;
    end;
  end;
  FindedList := TRBTree.Create;
  Result := GetBaseTypeRecursive(S, SelStart, TokenFile, TokenFileItem,
    Token, FindedList, ListAll, AllFunctions);
  FindedList.Free;
end;

procedure TTokenFiles.FillCompletionClass(InsertList, ShowList: TStrings;
  CompletionColors: TCompletionColors; TokenFile: TTokenFile; Item: TTokenClass;
  AllowScope: TScopeClassState);

  procedure FillCompletionClassRecursive(TokenItem: TTokenFile;
    Token: TTokenClass; aAllowScope, DenyScope: TScopeClassState;
    TokenList: TTokenList);
  var
    SearchClass: string;
    List: TStrings;
    I: Integer;
  begin
    //show all objects from class, struct or scope
    FillCompletionTreeNoRepeat(InsertList, ShowList, Token, -1,
      CompletionColors, TokenList, aAllowScope, False, True);
    List := TStringList.Create;
    GetDescendants(Token.Flag, List, scPublic);
    for I := 0 to List.Count - 1 do
    begin
      SearchClass := List.Strings[I];
      aAllowScope := [scProtected, scPublic] - DenyScope;
      if SearchToken(SearchClass, TokenItem,
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
      if SearchToken(SearchClass, TokenItem,
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
      if SearchToken(SearchClass, TokenItem,
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
    DenyScope := [scPrivate, scProtected];
  FillCompletionClassRecursive(TokenFile, Item, AllowScope, DenyScope, TokenList);
  TokenList.Free;
end;

function TTokenFiles.GetFieldsBaseType(const S, Fields: string;
  SelStart: Integer; TokenFile: TTokenFile; var TokenFileItem: TTokenFile;
  var Token: TTokenClass): Boolean;
var
  List: TStrings;
  I: Integer;
begin
  //search var->
  Result := SearchSource(S, TokenFile, TokenFileItem, Token, SelStart);
  if not Result then
    Exit;
  List := TStringList.Create;
  GetStringsFields(Fields, List);
  if (S <> 'this') then
  begin //'prototype var()->' or var.bla or func()->bla
    if (Token.Token in [tkVariable, tkFunction, tkPrototype, tkDefine]) then
    begin
      if not GetBaseType(GetVarType(Token.Flag), Token.SelStart,
        TokenFileItem, TokenFileItem, Token) then
      begin
        Result := List.Count = 0;
        List.Free;
        Exit;
      end;
    end;
  end;
  if (Token.Token in [tkTypedef]) and (Pos('struct', Token.Flag) > 0) then
  begin
    GetBaseType(GetVarType(Token.Flag), 0,
      TokenFile, TokenFileItem, Token);
  end;
  for I := 0 to List.Count - 1 do
  begin
    if Token.Token in [tkClass, tkTypeStruct, tkStruct, tkUnion,
      tkTypeUnion] then
    begin
      //get var.field    note: field can be an function
      Result := SearchClassSource(List.Strings[I], Token, TokenFileItem,
        TokenFileItem, Token, nil, False, [scPublic]);
      if not Result then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
      //last parameter and get tree for completion
      // var.field()->
      if (I = List.Count - 1) and
        (not StringIn(GetVarType(Token.Flag), ReservedTypes) and
        not GetBaseType(GetVarType(Token.Flag), 0, TokenFileItem,
        TokenFileItem, Token)) then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
    end
    else if Token.Token in [tkFunction, tkPrototype, tkVariable] then
    begin
      //get var.field    note: field can be an function
      if StringIn(GetVarType(Token.Flag), ReservedTypes) or
        not GetBaseType(GetVarType(Token.Flag), 0, TokenFileItem,
        TokenFileItem, Token) then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
      //get var.field    field is an tree object variable
      if Token.Token in [tkClass, tkTypeStruct, tkStruct, tkUnion,
        tkTypeUnion] then
        Result := SearchClassSource(List.Strings[I], Token, TokenFileItem,
          TokenFileItem, Token)
      else
        Result := False;
      if not Result then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
      //last parameter and get tree for completion
      // var.field()->
      if (I = List.Count - 1) and
        (not StringIn(GetVarType(Token.Flag), ReservedTypes) and
        not GetBaseType(GetVarType(Token.Flag), 0, TokenFileItem,
        TokenFileItem, Token)) then
      begin
        Result := False;
        List.Free;
        Exit;
      end;
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

function TTokenFiles.GetFieldsBaseParams(const S, Fields: string;
  SelStart: Integer; TokenFile: TTokenFile; ParamsList: TStrings): Boolean;
var
  List: TStrings;
  I: Integer;
  TokenFileItem: TTokenFile;
  Token: TTokenClass;
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
      //search for variable or return type
      if not GetBaseType(GetVarType(Token.Flag), Token.SelStart,
        TokenFileItem, TokenFileItem, Token, ParamsList, List.Count = 0) then
      begin
        List.Free;
        Exit;
      end
      else if (List.Count = 0) and (Token.Token in [tkTypedefProto]) then
        ParamsList.AddObject('', Token);
    end;
  end;
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
        if StringIn(GetVarType(Token.Flag), ReservedTypes) then
        begin
          Result := False;
          List.Free;
          Exit;
        end
        //class var, prototype var;
        else if not GetBaseType(GetVarType(Token.Flag), 0, TokenFileItem,
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
    else if (Token.Token in [tkFunction, tkPrototype, tkVariable]) then
    begin
      //int a, char b, ...
      if StringIn(GetVarType(Token.Flag), ReservedTypes) then
      begin
        Result := False;
        List.Free;
        Exit;
      end
      //class var, struct var, class function, struct function
      else if not GetBaseType(GetVarType(Token.Flag), 0, TokenFileItem,
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
  ShowList: TStrings; TokenFile: TTokenFile;
  FindedList: TRBTree; CompletionColors: TCompletionColors);
var
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin
  FillCompletion(InsertList, ShowList, TokenFile.VarConsts, -1, CompletionColors);
  FillCompletion(InsertList, ShowList, TokenFile.FuncObjs, -1, CompletionColors);
  FillCompletion(InsertList, ShowList, TokenFile.TreeObjs, -1, CompletionColors);
  FillCompletion(InsertList, ShowList, TokenFile.Defines, -1, CompletionColors);

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
    FillCompletionListRecursive(InsertList, ShowList, FindedTokenFile,
      FindedList, CompletionColors);
  end;
end;

procedure TTokenFiles.FillCompletionList(InsertList,
  ShowList: TStrings; TokenFile: TTokenFile; SelStart: Integer;
  CompletionColors: TCompletionColors);
var
  FindedList: TRBTree;
  I: Integer;
  FilePath: string;
  FindedTokenFile: TTokenFile;
begin

  FindedList := TRBTree.Create;
  FillCompletion(InsertList, ShowList, TokenFile.VarConsts, SelStart, CompletionColors);
  FillCompletion(InsertList, ShowList, TokenFile.FuncObjs, SelStart, CompletionColors);
  FillCompletion(InsertList, ShowList, TokenFile.TreeObjs, SelStart, CompletionColors);
  FillCompletion(InsertList, ShowList, TokenFile.Defines, SelStart, CompletionColors);

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
    FillCompletionListRecursive(InsertList, ShowList, FindedTokenFile,
      FindedList, CompletionColors);
  end;

  FindedList.Free;
end;

procedure FillCompletion(InsertList, ShowList: TStrings; Token: TTokenClass;
  SelStart: Integer; CompletionColors: TCompletionColors; IncludeParams: Boolean);
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
      if (Token.Items[I].Token in [tkScope, tkUsing]) or
        ((Token.Items[I].Level > 0) and not IncludeParams) then
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
      NewToken := TTokenClass.Create;
      NewToken.Assign(Token.Items[I]); //copy
      if Assigned(InsertList) then
        InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      if Assigned(ShowList) then
        ShowList.AddObject(CompletionShowItem(NewToken, CompletionColors), NewToken);
      if Token.Items[I].Token in
        [tkStruct, tkTypedef, tkClass, tkUnion, tkScopeClass] then
        Continue;
    end
    else if not IncludeParams then
      Continue;
    case Token.Items[I].Token of
      {tkClass, }tkFunction {, tkStruct}, tkParams, tkEnum, tkTypeEnum:
        FillCompletion(InsertList, ShowList, Token.Items[I], SelStart,
          CompletionColors, IncludeParams);
    end;
  end;
end;

end.
