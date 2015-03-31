unit DebugReader;

interface

uses
  Windows, SysUtils, Classes, Dialogs, VirtualTrees,
  TokenList, TokenUtils, RegularExpressionsCore;

type
  TDebugCmd = (dcPrint, dcLocalize, dcNextLine, dcWatch, dcOnBreak,
    dcBreakpoint, dcTerminate, dcSegmentationFault, dcNewThread, dcNoSymbol,
    dcIdle, dcUnknow, dcLanguage, dcExternalStep, dcOnExiting, dcOnAddWatch,
    dcOnWatchPoint, dcDisplay);

const
  DebugCmdNames: array[TDebugCmd] of string = (
    'dcPrint',
    'dcLocalize',
    'dcNextLine',
    'dcWatch',
    'dcOnBreak',
    'dcBreakpoint',
    'dcTerminate',
    'dcSegmentationFault',
    'dcNewThread',
    'dcNoSymbol',
    'dcIdle',
    'dcUnknow',
    'dcLanguage',
    'dcExternalStep',
    'dcOnExiting',
    'dcOnAddWatch',
    'dcOnWatchPoint',
    'dcDisplay'
    );

type
  TStartEvent = procedure(Sender: TObject) of object;
  TCommandEvent = procedure(Sender: TObject; Command: TDebugCmd;
    const Name, Value: string; Line: Integer) of object;
  TFinishEvent = procedure(Sender: TObject; ExitCode: Integer) of object;

  TDebugReader = class;

  TReaderConsole = class(TThread)
  private
    { Private declarations }
    hOutputRead: THandle;
    FDebugReader: TDebugReader;
  public
    constructor Create(DebugReader: TDebugReader);
    procedure Execute; override;
    property OutputRead: THandle read hOutputRead write hOutputRead;
  end;

  TDebugReader = class
  private
    { Private declarations }
    FExitCode: Integer;
    FFileName: string;
    FParams: string;
    FDirectory: string;
    fptr: PChar;
    FOutput: string;
    FeCode: Integer;
    FOnStart: TStartEvent;
    FOnCommandEvent: TCommandEvent;
    FOnFinish: TFinishEvent;
    hOutputRead, hInputWrite: THandle;
    FProcessInfo: TProcessInformation;
    FRunning: Boolean;
    FLastPrintID: Integer;
    FLastID: Integer;
    FLastDisplayID: Integer;
    FPriorFunction: string;
    FLastFunction: string;
    FPriorFileName: string;
    FLastFileName: string;
    Reader: TReaderConsole;
    regexp: TPerlRegEx;
    function ExecuteRegEx(const RegEx, Subject: string): Boolean;
    //
    procedure DoStart;
    procedure DoOutputWriter;
    procedure DoFinish;
    //***********
    function GetLine: string;
    //***********
    procedure ProcessPrint;
    procedure ProcessLocalize;
    procedure ProcessNextLine;
    procedure ProcessNewThread;
//    procedure ProcessWatch;
    procedure ProcessOnBreak;
    procedure ProcessNoSymbol;
    procedure ProcessBreakpoint;
    procedure ProcessTerminate;
    procedure ProcessTerminateCode;
//    procedure ProcessSegmentationFault;
    procedure ProcessIdle;
    procedure ProcessLanguage;
    procedure ProcessExternalStep;
    procedure ProcessOnExiting;
    procedure ProcessOnAddWatch;
    procedure ProcessOnWatchPoint;
    procedure ProcessDisplay;
    //***********
    procedure Execute;
    function Launch(hInputRead, hOutputWrite,
      hErrorWrite: THandle): Boolean;
    procedure CloseDebugger(Sender: Tobject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property Running: Boolean read FRunning;
    function SendCommand(const ACommand: string;
      const AParams: string = ''): Boolean;
    function FunctionChanged: Boolean;
  public
    { Published declarations }
    property OnStart: TStartEvent read FOnStart write FOnStart;
    property OnCommand: TCommandEvent read FOnCommandEvent write FOnCommandEvent;
    property OnFinish: TFinishEvent read FOnFinish write FOnFinish;
    property FileName: string read FFileName write FFileName;
    property Params: string read FParams write FParams;
    property Directory: string read FDirectory write FDirectory;
    property ExitCode: Integer read FExitCode write FExitCode default 1;
    property LastPrintID: Integer read FLastPrintID;
    property LastDisplayID: Integer read FLastDisplayID;
    property LastID: Integer read FLastID;
    property PriorFunction: string read FPriorFunction;
    property LastFunction: string read FLastFunction;
    property PriorFileName: string read FPriorFileName;
    property LastFileName: string read FLastFileName;
  end;

  TDebugParser = class
  private
    FText: string;
    fptr: PChar;
    FTreeView: TVirtualStringTree;
    procedure SkipPair(openPair, closePair: Char);
    procedure SkipString(commaChar: Char);
    function SearchVariable(const Name: string;
      Parent: PVirtualNode; Index: Integer): PVirtualNode;
    procedure Parse(Parent: PVirtualNode; Token: TTokenClass);
  public
    procedure Clear;
    procedure Fill(const S: string; token: TTokenClass);
    property TreeView: TVirtualStringTree read FTreeView write FTreeView;
  end;

implementation

uses DebugConsts, DebugWatch;

{TReaderConsole}

constructor TReaderConsole.Create(DebugReader: TDebugReader);
begin
  inherited Create(True);
  FDebugReader := DebugReader;
end;

procedure TReaderConsole.Execute;
var
  nRead: DWORD;
  bSucess: Boolean;
  Buffer: array[0..2048] of AnsiChar;
  Output: string;
  CRLFFound: Boolean;
  ptr, ptrStart: PAnsiChar;
  SaveChar: AnsiChar;
begin
  Synchronize(FDebugReader.DoStart);
  Output := '';
  repeat
    bSucess := ReadFile(OutputRead, Buffer, SizeOf(Buffer) - SizeOf(AnsiChar),
      nRead, nil);
    if not bSucess or (nRead = 0) or (GetLastError() = ERROR_BROKEN_PIPE) then
      Break;
    Buffer[nRead] := #0;
    ptr := PAnsiChar(@Buffer);
    ptrStart := ptr;
    repeat
      while not CharInSet(ptr^, [#0, CR, LF]) do
        Inc(ptr);
      CRLFFound := ptr^ <> #0;
      if (ptr^ = CR) then
        Inc(ptr);
      if (ptr^ = LF) then
        Inc(ptr);
      SaveChar := ptr^;
      ptr^ := #0;
      Output := Output + string(StrPas(ptrStart));
      ptr^ := SaveChar;
      ptrStart := ptr;
      if CRLFFound then
      begin
        FDebugReader.FOutput := Output;
        Output := '';
        Synchronize(FDebugReader.DoOutputWriter);
      end;
    until not CRLFFound;
  until False;
end;

{TDebugReader}

constructor TDebugReader.Create;
begin
  inherited Create;
  regexp := TPerlRegEx.Create;
  FExitCode := 1;
  FLastPrintID := 0;
  FLastID := 0;
  FLastDisplayID := 0;
end;

destructor TDebugReader.Destroy;
begin
  regexp.Free;
  inherited Destroy;
end;

procedure TDebugReader.Start;
begin
  if Running then
    Stop;
  Execute;
end;

function TDebugReader.ExecuteRegEx(const RegEx, Subject: string): Boolean;
begin
  regexp.RegEx := UTF8Encode(RegEx);
  regexp.Subject := UTF8Encode(Subject);
  Result := regexp.Match;
end;

procedure TDebugReader.Execute;
var
  SecAttrib: TSecurityAttributes;
  hOutputReadTmp, hInputWriteTmp: THandle;
  hInputRead, hOutputWrite, hErrorWrite: THandle;
begin
  SecAttrib.nLength := SizeOf(TSecurityAttributes);
  SecAttrib.lpSecurityDescriptor := nil;
  SecAttrib.bInheritHandle := True;

  // Create a pipe for the child process's STDOUT.
  if not CreatePipe(hOutputReadTmp, hOutputWrite, @SecAttrib, 0) then
  begin
    DoStart;
    DoFinish;
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hOutputWrite,
    GetCurrentProcess(), @hErrorWrite, 0, true, DUPLICATE_SAME_ACCESS) then
  begin
    DoStart;
    DoFinish;
    Exit;
  end;

  // Create a pipe for the child process's STDIN.
  if not CreatePipe(hInputRead, hInputWriteTmp, @SecAttrib, 0) then
  begin
    DoStart;
    DoFinish;
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hOutputReadTmp,
    GetCurrentProcess(), @hOutputRead, 0, False, DUPLICATE_SAME_ACCESS) then
  begin
    DoStart;
    DoFinish;
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hInputWriteTmp,
    GetCurrentProcess(), @hInputWrite, 0, False, DUPLICATE_SAME_ACCESS) then
  begin
    DoStart;
    DoFinish;
    Exit;
  end;

  if not CloseHandle(hOutputReadTmp) or
    not CloseHandle(hInputWriteTmp) then
  begin
    DoStart;
    DoFinish;
    Exit;
  end;

  FRunning := Launch(hInputRead, hOutputWrite, hErrorWrite);
  DoStart;
  if not FRunning then
  begin
    FeCode := GetLastError;
    CloseHandle(hOutputWrite);
    CloseHandle(hInputRead);
    CloseHandle(hErrorWrite);
    DoFinish;
    Exit;
  end;

  if not CloseHandle(hInputRead) or
    not CloseHandle(hOutputWrite) or
    not CloseHandle(hErrorWrite) then
  begin
    TerminateProcess(FProcessInfo.hProcess, GetLastError);
    CloseHandle(FProcessInfo.hProcess);
    DoFinish;
    Exit;
  end;

  Reader := TReaderConsole.Create(Self);
  Reader.OutputRead := hOutputRead;
  Reader.OnTerminate := CloseDebugger;
  Reader.FreeOnTerminate := True;
  Reader.Start;
end;

procedure TDebugReader.CloseDebugger(Sender: Tobject);
var
  eCode: Cardinal;
begin
  Reader := nil;
  GetExitCodeProcess(FProcessInfo.hProcess, eCode);
  FeCode := eCode;
  CloseHandle(hOutputRead);
  CloseHandle(hInputWrite);
  CloseHandle(FProcessInfo.hProcess);
  DoFinish;
end;

function TDebugReader.Launch(hInputRead, hOutputWrite,
  hErrorWrite: THandle): Boolean;
var
  StartInfo: TStartupInfo;
begin
  Result := True;

  FillChar(StartInfo, SizeOf(TStartupInfo), 0);
  StartInfo.cb := SizeOf(TStartupInfo);
  StartInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  StartInfo.hStdInput := hInputRead;
  StartInfo.hStdOutput := hOutputWrite;
  StartInfo.hStdError := hErrorWrite;
  if not CreateProcess(nil, PChar(FFileName + ' ' + FParams), nil,
    nil, True, CREATE_NEW_CONSOLE, nil, PChar(FDirectory), StartInfo,
    FProcessInfo) then
  begin
    Result := False;
    Exit;
  end;
  CloseHandle(FProcessInfo.hThread);
end;

function TDebugReader.SendCommand(const ACommand, AParams: string): Boolean;
var
  nWrited, nSize: Cardinal;
  Buffer: PAnsiChar;
  I, J: Integer;
  Command, Params: AnsiString;
begin
  Command := AnsiString(ACommand);
  Params := AnsiString(AParams);
  Result := False;
  if not Running then
    Exit;
  nSize := (Length(Command) + Length(Params) + 2) * SizeOf(AnsiChar); // \r\n
  if Length(Params) > 0 then
    nSize := nSize + SizeOf(AnsiChar);
  Buffer := AllocMem(nSize + SizeOf(AnsiChar)); //\0
  I := 0;
  while I < Length(Command) do
  begin
    Buffer[I] := Command[I + 1];
    I := I + 1;
  end;
  if Length(Params) > 0 then
  begin
    Buffer[I] := ' ';
    I := I + 1;
  end;
  J := 0;
  while J < Length(Params) do
  begin
    Buffer[I] := Params[J + 1];
    I := I + 1;
    J := J + 1;
  end;
  Buffer[I] := CR;
  I := I + 1;
  Buffer[I] := LF;
  I := I + 1;
  Buffer[I] := #0;
  Result := WriteFile(hInputWrite, Buffer[0], nSize, nWrited, nil);
  FreeMem(Buffer);
end;

procedure TDebugReader.Stop;
begin
  if Running then
    TerminateProcess(FProcessInfo.hProcess, FExitCode);
end;

procedure TDebugReader.DoStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

function TDebugReader.GetLine: string;
begin
  Result := '';
  if CharInSet(fptr^, dbgLineChars + [#0]) then
  begin
    while CharInSet(fptr^, dbgLineChars) do
      Inc(fptr);
    Exit;
  end;
  repeat
    Result := Result + fptr^;
    Inc(fptr);
  until CharInSet(fptr^, dbgLineChars + [#0]);
  while CharInSet(fptr^, dbgLineChars) do
    Inc(fptr);
end;

procedure TDebugReader.ProcessPrint;
var
  PrintID: Integer;
begin
  PrintID := StrToInt(UTF8ToString(regexp.Groups[1]));
  if FLastPrintID < PrintID then
    FLastPrintID := PrintID;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcPrint, UTF8ToString(regexp.Groups[1]), UTF8ToString(regexp.Groups[2]), 0);
end;

procedure TDebugReader.ProcessLocalize;
var
  FileName: string;
begin
  FileName := ConvertSlashes(UTF8ToString(regexp.Groups[2]));
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  FPriorFileName := FLastFileName;
  FLastFileName := FileName;
  FPriorFunction := FLastFunction;
  FLastFunction := UTF8ToString(regexp.Groups[1]);
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcLocalize, FileName, UTF8ToString(regexp.Groups[1]),
      StrToInt(UTF8ToString(regexp.Groups[3])));
end;

procedure TDebugReader.ProcessNextLine;
var
  FileName: string;
begin
  FileName := ConvertSlashes(UTF8ToString(regexp.Groups[1] + regexp.Groups[2]));
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  FPriorFileName := FLastFileName;
  FLastFileName := FileName;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNextLine, FileName, UTF8ToString(regexp.Groups[4]),
      StrToInt(UTF8ToString(regexp.Groups[3])));
end;

procedure TDebugReader.ProcessNewThread;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNewThread, '', UTF8ToString(regexp.Groups[1]), 0);
end;

{procedure TDebugReader.ProcessWatch;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcWatch, '', regexp.Groups[0], 0);
end;}

procedure TDebugReader.ProcessOnBreak;
var
  ID: Integer;
  FileName: string;
begin
  ID := StrToInt(UTF8ToString(regexp.Groups[1]));
  if FLastID < ID then
    FLastID := ID;
  FileName := ConvertSlashes(UTF8ToString(regexp.Groups[3]));
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  FPriorFileName := FLastFileName;
  FLastFileName := FileName;
  FPriorFunction := FLastFunction;
  FLastFunction := UTF8ToString(regexp.Groups[2]);
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnBreak, FileName, UTF8ToString(regexp.Groups[1]),
      StrToInt(UTF8ToString(regexp.Groups[4])));
end;

procedure TDebugReader.ProcessNoSymbol;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNoSymbol, UTF8ToString(regexp.Groups[1]),
      UTF8ToString(regexp.Groups[0]), 0);
end;

procedure TDebugReader.ProcessBreakpoint;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcBreakpoint, UTF8ToString(regexp.Groups[2]),
      UTF8ToString(regexp.Groups[1]),
      StrToInt(UTF8ToString(regexp.Groups[3])));
end;

procedure TDebugReader.ProcessTerminate;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcTerminate, '', '0', 0);
end;

function OctStrToInt(const Value: string): Integer;
var
  i: Integer;
begin
  if (Length(Value) > 0) and (Value[1] <> '0') then
  begin
    Result := StrToInt(Value);
    Exit;
  end;
  Result := 0;
  for i := 1 to Length(Value) do
  begin
    Result := Result * 8 + StrToInt(Copy(Value, i, 1));
  end;
end;

procedure TDebugReader.ProcessTerminateCode;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcTerminate, '', IntToStr(OctStrToInt(UTF8ToString(regexp.Groups[1]))), 0);
end;

{procedure TDebugReader.ProcessSegmentationFault;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcSegmentationFault, '', regexp.Groups[0], 0);
end;}

procedure TDebugReader.ProcessIdle;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcIdle, '', '', 0);
end;

procedure TDebugReader.ProcessLanguage;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcLanguage, UTF8ToString(regexp.Groups[1]),
      UTF8ToString(regexp.Groups[2]), 0);
end;

procedure TDebugReader.ProcessExternalStep;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcExternalStep, UTF8ToString(regexp.Groups[1]),
      UTF8ToString(regexp.Groups[2]), 0);
end;

procedure TDebugReader.ProcessOnExiting;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnExiting, UTF8ToString(regexp.Groups[2]),
      UTF8ToString(regexp.Groups[1]), 0);
end;

procedure TDebugReader.ProcessOnAddWatch;
var
  ID: Integer;
begin
  ID := StrToInt(UTF8ToString(regexp.Groups[1]));
  if FLastID < ID then
    FLastID := ID;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnAddWatch, UTF8ToString(regexp.Groups[2]),
      UTF8ToString(regexp.Groups[1]), 0);
end;

procedure TDebugReader.ProcessOnWatchPoint;
var
  ID: Integer;
begin
  ID := StrToInt(UTF8ToString(regexp.Groups[1]));
  if FLastID < ID then
    FLastID := ID;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnWatchPoint, UTF8ToString(regexp.Groups[2]),
      UTF8ToString(regexp.Groups[1]), 0);
end;

procedure TDebugReader.ProcessDisplay;
var
  DisplayID: Integer;
begin
  DisplayID := StrToInt(UTF8ToString(regexp.Groups[1]));
  if FLastDisplayID < DisplayID then
    FLastDisplayID := DisplayID;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcDisplay, UTF8ToString(regexp.Groups[2]),
      UTF8ToString(regexp.Groups[3]), DisplayID);
end;

procedure TDebugReader.DoOutputWriter;
var
  S: string;
  I: Integer;
begin
  fptr := PChar(FOutput);
  S := FOutput;
  repeat
    S := GetLine;
    if Pos('Single stepping until exit from function', S) > 0 then
      S := S + GetLine;
    I := Pos(GDB_PROMPT + ' ', S);
    while I = 1 do
    begin
      S := Copy(S, I + Length(GDB_PROMPT + ' '), Length(S) -
        Length(GDB_PROMPT + ' '));
      ProcessIdle;
      I := Pos(GDB_PROMPT + ' ', S);
    end;
    if S = '' then
      Continue;
    if ExecuteRegEx(REGEXP_PRINT, S) then
      ProcessPrint
    else if ExecuteRegEx(REGEXP_NOSYMBOL, S) then
      ProcessNoSymbol
    else if ExecuteRegEx(REGEXP_NEXTLINE, S) then
      ProcessNextLine
    else if ExecuteRegEx(REGEXP_BREAKPOINT, S) then
      ProcessBreakpoint
    else if ExecuteRegEx(REGEXP_DISPLAY, S) then
      ProcessDisplay
    else if ExecuteRegEx(REGEXP_ONBREAK, S) then
      ProcessOnBreak
    else if ExecuteRegEx(REGEXP_ONADDWATCH, S) then
      ProcessOnAddWatch
    else if ExecuteRegEx(REGEXP_ONWATCHPOINT, S) then
      ProcessOnWatchPoint
    else if ExecuteRegEx(REGEXP_LANGUAGE, S) then
      ProcessLanguage
    else if ExecuteRegEx(REGEXP_EXTERNALSTEP, S) then
      ProcessExternalStep
    else if ExecuteRegEx(REGEXP_LOCALIZE, S) then
      ProcessLocalize
    else if ExecuteRegEx(REGEXP_NEWTHREAD, S) then
      ProcessNewThread
    else if ExecuteRegEx(REGEXP_TERMINATE, S) then
      ProcessTerminate
    else if ExecuteRegEx(REGEXP_TERMINATENORM, S) then
      ProcessTerminate
    else if ExecuteRegEx(REGEXP_TERMINATECODE, S) then
      ProcessTerminateCode
    else if ExecuteRegEx(REGEXP_PROCESSEXITED, S) then
      ProcessTerminateCode
    else if ExecuteRegEx(REGEXP_EXITING, S) then
      ProcessOnExiting
    else
    begin
      if Assigned(FOnCommandEvent) then
        FOnCommandEvent(Self, dcUnknow, '', S, 0);
    end;
  until fptr^ = #0;
  FOutput := '';
end;

procedure TDebugReader.DoFinish;
begin
  FRunning := False;
  FLastPrintID := 0;
  FLastDisplayID := 0;
  FLastID := 0;
  FLastFunction := '';
  FPriorFunction := '';
  FLastFileName := '';
  FPriorFileName := '';
  if Assigned(FOnFinish) then
    FOnFinish(Self, FeCode);
end;

function TDebugReader.FunctionChanged: Boolean;
begin
  Result := (FPriorFunction <> FLastFunction) or
    (FPriorFileName <> FLastFileName);
end;

//*************************** debug functions ******************************//

{TDebugParser}

procedure TDebugParser.SkipString(commaChar: Char);
begin
  if fptr^ = commaChar then
    Inc(fptr);
  if fptr^ = #0 then
    Exit;
  while (fptr^ <> #0) and ((fptr^ <> commaChar) or ((fptr - 1)^ = '\')) do
    Inc(fptr);
end;

procedure TDebugParser.SkipPair(openPair, closePair: Char);
var
  pairCount: Integer;
begin
  pairCount := 0;
  if fptr^ = openPair then
  begin
    Inc(fptr);
    Inc(pairCount);
  end;
  if fptr^ = #0 then
    Exit;
  repeat
    if CharInSet(fptr^, [openPair, closePair]) and ((fptr - 1)^ <> '\') then
    begin
      if fptr^ = openPair then
        Inc(pairCount)
      else if fptr^ = closePair then
        Dec(pairCount);
      if (pairCount = 0) then
        Break;
    end;
    Inc(fptr);
  until fptr^ = #0;
end;

function TDebugParser.SearchVariable(const Name: string;
  Parent: PVirtualNode; Index: Integer): PVirtualNode;

  function GetChild(Node: PVirtualNode; Index: Integer): PVirtualNode;
  var
    Child: PVirtualNode;
    I: Integer;
  begin
    Child := TreeView.GetFirstChild(Node);
    for I := 0 to TreeView.ChildCount[Node] - 1 do
    begin
      if I = Index then
        Break;
      Child := TreeView.GetNextSibling(Child);
    end;
    Result := Child;
  end;

var
  Item: TWatchVariable;
  Node, Child: PVirtualNode;
begin
  Result := nil;
  if Assigned(Parent) then
  begin
    if (Index < Integer(TreeView.ChildCount[Parent])) and (Index >= 0) then
    begin
      Child := GetChild(Parent, Index);
      Item := TWatchVariable(TNodeObject(TreeView.GetNodeData(Child)^).Data);
      if Name = Item.Name then
      begin
        Result := Child;
        Exit;
      end;
    end;
  end
  else
  begin //level 0
    Node := TreeView.GetFirst;
    while Node <> nil do
    begin
      Item := TWatchVariable(TNodeObject(TreeView.GetNodeData(Node)^).Data);
      if Name = Item.Name then
      begin
        Result := Node;
        Exit;
      end;
      Node := TreeView.GetNextSibling(Node);
    end;
  end;
end;

procedure TDebugParser.Parse(Parent: PVirtualNode; Token: TTokenClass);

  function AddVar(const Name, Value: string; var childToken: TTokenClass;
    Index: Integer): PVirtualNode;
  var
    tempToken: TTokenClass;
    watchVar: TWatchVariable;
    NodeObject: TNodeObject;
  begin
    tempToken := nil;
    childToken := Token;
    if Assigned(childToken) then
    begin
      if Assigned(Parent) then
      begin
        if childToken.SearchSource(Name, childToken) then
          tempToken := childToken;
      end
      else
        tempToken := childToken;
    end;
    Result := SearchVariable(Name, Parent, Index);
    if not Assigned(Result) then
    begin
      NodeObject := TNodeObject.Create;
      Result := FTreeView.AddChild(Parent, NodeObject);
      if Value = '' then
        NodeObject.Caption := Name
      else
        NodeObject.Caption := Name + ' = ' + Value;
      watchVar := TWatchVariable.Create;
    end
    else
    begin
      NodeObject := TNodeObject(TreeView.GetNodeData(Result)^);
      if Value = '' then
        NodeObject.Caption := Name
      else
        NodeObject.Caption := Name + ' = ' + Value;
      watchVar := TWatchVariable(NodeObject.Data);
    end;
    watchVar.Name := Name;
    watchVar.Value := Value;
    watchVar.Token := tempToken;
    watchVar.Initialized := False;
    if Assigned(tempToken) then
    begin
      watchVar.SelLine := TTokenClass(tempToken).SelLine;
      watchVar.SelStart := TTokenClass(tempToken).SelStart;
      watchVar.SelLength := TTokenClass(tempToken).SelLength;
    end;
    NodeObject.ImageIndex := 0;
    NodeObject.Data := watchVar;
  end;

var
  VarName, VarValue: string;
  EqFind: Boolean;
  closePair: Char;
  Item: PVirtualNode;
  childToken: TTokenClass;
  IVector, Len, Index: Integer;
  ptrB, ptrE: PChar;
begin
  VarName := '';
  VarValue := '';
  EqFind := False;
  IVector := 0;
  ptrB := fptr;
  ptrE := ptrB;
  Index := 0;
  repeat
    case fptr^ of
      '=':
        begin
          EqFind := True;
          Len := ptrE - ptrB;
          SetLength(VarName, Len);
          if Len > 0 then
            StrLCopy(PChar(VarName), ptrB, Len);
          //PChar(VarName)[Len] := #0;
          Inc(fptr);
          while CharInSet(fptr^, [' ', #10, #13]) do
            Inc(fptr);
          ptrB := fptr;
          ptrE := ptrB;
          Continue;
        end;
      #0: Break;
      '"', '''':
      begin
        SkipString(fptr^);
        ptrE := fptr + 1;
      end;
      '(', '<', '[':
        begin
          case fptr^ of
            '(': closePair := ')';
            '<': closePair := '>';
          else
            closePair := ']';
          end;
          SkipPair(fptr^, closePair);
          ptrE := fptr + 1;
        end;
      '{', ',', '}':
        begin
          Len := ptrE - ptrB;
          SetLength(VarValue, Len);
          if Len > 0 then
            StrLCopy(PChar(VarValue), ptrB, Len);
          //PChar(VarValue)[ptrE - ptrB] := #0;
          if not EqFind then
          begin
            VarName := '[' + IntToStr(IVector) + ']';
            Inc(IVector);
          end;
          Item := AddVar(VarName, VarValue, childToken, Index);
          Inc(Index);
          EqFind := False;
          if fptr^ = '{' then
          begin
            Inc(fptr);
            Parse(Item, childToken);
          end;
          if fptr^ = '}' then
          begin
            Inc(fptr);
            Break;
          end;
          if fptr^ = #0 then
            Break;
          // ,
          Inc(fptr);
          while CharInSet(fptr^, [' ', #10, #13]) do
            Inc(fptr);
          ptrB := fptr;
          ptrE := ptrB;
          Continue;
        end;
    else
      if fptr^ <> ' ' then
        ptrE := fptr + 1;
    end;
    Inc(fptr);
  until fptr^ = #0;
  if not EqFind then
    Exit;
  SetLength(VarValue, ptrE - ptrB);
  StrLCopy(PChar(VarValue), ptrB, ptrE - ptrB);
  PChar(VarValue)[ptrE - ptrB] := #0;
  AddVar(VarName, VarValue, childToken, Index);
end;

procedure TDebugParser.Clear;
var
  Node: PVirtualNode;
begin
  Node := TreeView.GetFirst;
  while Node <> nil do
  begin
    TWatchVariable(TNodeObject(TreeView.GetNodeData(Node)^).Data).Free;
    Node := TreeView.GetNext(Node);
  end;
  TreeView.Clear;
end;

procedure TDebugParser.Fill(const S: string; token: TTokenClass);
begin
  FText := S;
  fptr := PChar(FText);
  TreeView.BeginUpdate;
  Parse(nil, token);
  TreeView.EndUpdate;
end;

end.
