unit DebugReader;

interface

uses
  Windows, SysUtils, Classes, ShellAPI, regexp_tregexpr, Dialogs, ComCtrls,
  TokenList;

type
  TDebugCmd = (dcPrint, dcLocalize, dcNextLine, dcWatch, dcOnBreak,
    dcBreakpoint, dcTerminate, dcSegmentationFault, dcNewThread, dcNoSymbol,
    dcIdle, dcUnknow, dcLanguage, dcExternalStep, dcOnExiting, dcOnAddWatch,
    dcOnWatchPoint, dcDisplay);

const
  DebugCmdNames: array[TDebugCmd] of String = (
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
  TStartEvent = procedure(Sender: TObject) of Object;
  TCommandEvent = procedure(Sender: TObject; Command: TDebugCmd;
    const Name, Value: String; Line: Integer) of Object;
  TFinishEvent = procedure(Sender: TObject; ExitCode: Integer) of Object;

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
    FFileName: String;
    FParams: String;
    FDirectory: String;
    fptr: PChar;
    FOutput: String;
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
    FPriorFunction: String;
    FLastFunction: String;
    FPriorFileName: String;
    FLastFileName: String;
    Reader: TReaderConsole;
    regexp: TRegExpr;
    procedure DoStart;
    procedure DoOutputWriter;
    procedure DoFinish;
    //***********
    function GetLine: String;
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
      hErrorWrite : THandle): Boolean;
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
    function SendCommand(const Command: String;
      const Params: String = ''): Boolean;
    function FunctionChanged: Boolean;
  published
    { Published declarations }
    property OnStart: TStartEvent read FOnStart write FOnStart;
    property OnCommand: TCommandEvent read FOnCommandEvent write FOnCommandEvent;
    property OnFinish: TFinishEvent read FOnFinish write FOnFinish;
    property FileName: String read FFileName write FFileName;
    property Params: String read FParams write FParams;
    property Directory: String read FDirectory write FDirectory;
    property ExitCode: Integer read FExitCode write FExitCode default 1;
    property LastPrintID: Integer read FLastPrintID;
    property LastDisplayID: Integer read FLastDisplayID;
    property LastID: Integer read FLastID;
    property PriorFunction: String read FPriorFunction;
    property LastFunction: String read FLastFunction;
    property PriorFileName: String read FPriorFileName;
    property LastFileName: String read FLastFileName;
  end;

  TDebugParser = class
  private
    FText: String;
    fptr: PChar;
    FTreeView: TTreeView;
    function GetPair(openPair, closePair: Char): String;
    function GetString(commaChar: Char): String;
    function SearchVariable(const Name: String;
      Parent: TTreeNode): TTreeNode;
    procedure Parse(Parent: TTreeNode; Token: TTokenClass);
  public
    procedure Clear;
    procedure Fill(const S: String; token: TTokenClass);
    property TreeView: TTreeView read FTreeView write FTreeView;
  end;

implementation

uses DebugConsts, DebugWatch, StrUtils;

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
  Buffer: array[0..2048] of Char;
  Output: String;
  I, Offset: Integer;
begin
  Synchronize(FDebugReader.DoStart);
  Output := '';
  repeat
    bSucess := ReadFile(OutputRead, Buffer, SizeOf(Buffer) - 1, nRead, nil);
    if not bSucess or (nRead = 0) or (GetLastError() = ERROR_BROKEN_PIPE)  then
      Break;

    Buffer[nRead] := #0;
    Output := Output + StrPas(Buffer);
    Offset := Length(Output) - Length(GDB_PROMPT + ' ') + 1;
    if Offset < 1 then
      Offset := 1;
    I := PosEx(GDB_PROMPT + ' ', Output, Offset);
    if ((I > 0) and (I = Offset)) or (Pos('No symbol "', Output) > 0) then
    begin
      //OemToAnsi(Buffer, Buffer);
      FDebugReader.FOutput := Output;
      Output := '';
      Synchronize(FDebugReader.DoOutputWriter);
    end;
  until False;
end;

{TDebugReader}
constructor TDebugReader.Create;
begin
  inherited Create;
  regexp := TRegExpr.Create;
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

procedure TDebugReader.Execute;
var
  SecAttrib: TSecurityAttributes;
  hOutputReadTmp, hInputWriteTmp: THandle;
  hInputRead, hOutputWrite, hErrorWrite: THandle;
begin
  //DoStart;

  SecAttrib.nLength := SizeOf(TSecurityAttributes);
  SecAttrib.lpSecurityDescriptor := nil;
  SecAttrib.bInheritHandle := True;

  // Create a pipe for the child process's STDOUT.
  if not CreatePipe(hOutputReadTmp, hOutputWrite, @SecAttrib, 0) then
  begin
    DoFinish;
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hOutputWrite,
    GetCurrentProcess(), @hErrorWrite, 0, true, DUPLICATE_SAME_ACCESS) then
  begin
    DoFinish;
    Exit;
  end;

  // Create a pipe for the child process's STDIN.
  if not CreatePipe(hInputRead, hInputWriteTmp, @SecAttrib, 0) then
  begin
    DoFinish;
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hOutputReadTmp,
    GetCurrentProcess(), @hOutputRead,  0, False, DUPLICATE_SAME_ACCESS) then
  begin
    DoFinish;
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hInputWriteTmp,
    GetCurrentProcess(), @hInputWrite, 0, False, DUPLICATE_SAME_ACCESS) then
  begin
    DoFinish;
    Exit;
  end;

  if not CloseHandle(hOutputReadTmp) or
     not CloseHandle(hInputWriteTmp) then
  begin
    DoFinish;
    Exit;
  end;

  FRunning := Launch(hInputRead, hOutputWrite, hErrorWrite);
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
  Reader.Resume;
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
  hErrorWrite : THandle): Boolean;
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

function TDebugReader.SendCommand(const Command, Params: String): Boolean;
var
  nWrited, nSize: Cardinal;
  Buffer: PChar;
  I, J: Integer;
begin
  Result := False;
  if not Running then
    Exit;
  nSize := Length(Command) + Length(Params) + 2;// \r\n
  if Length(Params) > 0 then
    nSize := nSize + 1;
  Buffer := AllocMem(nSize + 1);//\0
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

function TDebugReader.GetLine: String;
begin
  Result := '';
  if fptr^ in dbgLineChars + [#0] then
  begin
    while fptr^ in dbgLineChars do
      Inc(fptr);
    Exit;
  end;
  repeat
    Result := Result + fptr^;
    Inc(fptr);
  until fptr^ in dbgLineChars + [#0];
  while fptr^ in dbgLineChars do
    Inc(fptr);
end;

procedure TDebugReader.ProcessPrint;
var
  PrintID: Integer;
begin
  PrintID := StrToInt(regexp.Match[1]);
  if FLastPrintID < PrintID then
    FLastPrintID := PrintID;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcPrint, regexp.Match[1], regexp.Match[2], 0);
end;

procedure TDebugReader.ProcessLocalize;
var
  FileName: String;
begin
  FileName := regexp.Match[2];
  FileName := StringReplace(FileName, '/', '\', [rfReplaceAll]);
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  FPriorFileName := FLastFileName;
  FLastFileName := FileName;
  FPriorFunction := FLastFunction;
  FLastFunction := regexp.Match[1];
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcLocalize, FileName, regexp.Match[1],
      StrToInt(regexp.Match[3]));
end;

procedure TDebugReader.ProcessNextLine;
var
  FileName: String;
begin
  FileName := regexp.Match[1] + regexp.Match[2];
  FileName := StringReplace(FileName, '/', '\', [rfReplaceAll]);
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  FPriorFileName := FLastFileName;
  FLastFileName := FileName;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNextLine, FileName, regexp.Match[4],
      StrToInt(regexp.Match[3]));
end;

procedure TDebugReader.ProcessNewThread;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNewThread, '', regexp.Match[1], 0);
end;

{procedure TDebugReader.ProcessWatch;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcWatch, '', regexp.Match[0], 0);
end;}

procedure TDebugReader.ProcessOnBreak;
var
  ID: Integer;
  FileName: String;
begin
  ID := StrToInt(regexp.Match[1]);
  if FLastID < ID then
    FLastID := ID;
  FileName := regexp.Match[3];
  FileName := StringReplace(FileName, '/', '\', [rfReplaceAll]);
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  FPriorFileName := FLastFileName;
  FLastFileName := FileName;
  FPriorFunction := FLastFunction;
  FLastFunction := regexp.Match[2];
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnBreak, FileName, regexp.Match[1],
      StrToInt(regexp.Match[4]));
end;

procedure TDebugReader.ProcessNoSymbol;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNoSymbol, regexp.Match[1], regexp.Match[0], 0);
end;

procedure TDebugReader.ProcessBreakpoint;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcBreakpoint, regexp.Match[2], regexp.Match[1],
      StrToInt(regexp.Match[3]));
end;

procedure TDebugReader.ProcessTerminate;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcTerminate, '', '0', 0);
end;

procedure TDebugReader.ProcessTerminateCode;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcTerminate, '', regexp.Match[1], 0);
end;

{procedure TDebugReader.ProcessSegmentationFault;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcSegmentationFault, '', regexp.Match[0], 0);
end;}

procedure TDebugReader.ProcessIdle;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcIdle, '', '', 0);
end;

procedure TDebugReader.ProcessLanguage;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcLanguage, regexp.Match[1], regexp.Match[2], 0);
end;


procedure TDebugReader.ProcessExternalStep;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcExternalStep, regexp.Match[1], regexp.Match[2], 0);
end;

procedure TDebugReader.ProcessOnExiting;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnExiting, regexp.Match[2], regexp.Match[1], 0);
end;

procedure TDebugReader.ProcessOnAddWatch;
var
  ID: Integer;
begin
  ID := StrToInt(regexp.Match[1]);
  if FLastID < ID then
    FLastID := ID;
//  ShowMessage(FOutput);
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnAddWatch, regexp.Match[2], regexp.Match[1], 0);
end;

procedure TDebugReader.ProcessOnWatchPoint;
var
  ID: Integer;
begin
  ID := StrToInt(regexp.Match[1]);
  if FLastID < ID then
    FLastID := ID;
//  ShowMessage(FOutput);
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnWatchPoint, regexp.Match[2], regexp.Match[1], 0);
end;

procedure TDebugReader.ProcessDisplay;
var
  DisplayID: Integer;
begin
  DisplayID := StrToInt(regexp.Match[1]);
  if FLastDisplayID < DisplayID then
    FLastDisplayID := DisplayID;
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcDisplay, regexp.Match[2], regexp.Match[3], DisplayID);
end;

procedure TDebugReader.DoOutputWriter;
var
  S: String;
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
        Length(GDB_PROMPT+ ' '));
      S := Trim(S);
      ProcessIdle;
      I := Pos(GDB_PROMPT + ' ', S);
    end;
    if S = '' then
      Continue;
    if regexp.Exec(REGEXP_PRINT, S) then
      ProcessPrint
    else if regexp.Exec(REGEXP_NOSYMBOL, S) then
      ProcessNoSymbol
    else if regexp.Exec(REGEXP_NEXTLINE, S) then
      ProcessNextLine
    else if regexp.Exec(REGEXP_BREAKPOINT, S) then
      ProcessBreakpoint
    else if regexp.Exec(REGEXP_DISPLAY, S) then
      ProcessDisplay
    else if regexp.Exec(REGEXP_ONBREAK, S) then
      ProcessOnBreak
    else if regexp.Exec(REGEXP_ONADDWATCH, S) then
      ProcessOnAddWatch
    else if regexp.Exec(REGEXP_ONWATCHPOINT, S) then
      ProcessOnWatchPoint
    else if regexp.Exec(REGEXP_LANGUAGE, S) then
      ProcessLanguage
    else if regexp.Exec(REGEXP_EXTERNALSTEP, S) then
      ProcessExternalStep
    else if regexp.Exec(REGEXP_LOCALIZE, S) then
      ProcessLocalize
    else if regexp.Exec(REGEXP_NEWTHREAD, S) then
      ProcessNewThread
    else if regexp.Exec(REGEXP_TERMINATE, S) then
      ProcessTerminate
    else if regexp.Exec(REGEXP_TERMINATECODE, S) then
      ProcessTerminateCode
    else if regexp.Exec(REGEXP_EXITING, S) then
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

function TDebugParser.GetString(commaChar: Char): String;
begin
  Result := '';
  if fptr^ = commaChar then
  begin
    Result := fptr^;
    Inc(fptr);
  end;
  if fptr^ = #0 then
    Exit;
  repeat
    Result := Result + fptr^;
    Inc(fptr);
  until (fptr^ = #0) or ((fptr^ = commaChar) and ((fptr - 1)^ <> '\'));
  if fptr^ <> #0 then
    Result := Result + fptr^;
end;

function TDebugParser.GetPair(openPair, closePair: Char): String;
var
  pairCount: Integer;
begin
  pairCount := 0;
  Result := '';
  if fptr^ = openPair then
  begin
    Result := fptr^;
    Inc(fptr);
    Inc(pairCount);
  end;
  if fptr^ = #0 then
    Exit;
  repeat
    if (fptr^ in [openPair, closePair]) and ((fptr - 1)^ <> '\') then
    begin
      if fptr^ = openPair then
        Inc(pairCount)
      else if fptr^ = closePair then
        Dec(pairCount);
      if (pairCount = 0) then
        Break;
    end;
    Result := Result + fptr^;
    Inc(fptr);
  until fptr^ = #0;
  if fptr^ <> #0 then
    Result := Result + fptr^;
end;

function TDebugParser.SearchVariable(const Name: String;
  Parent: TTreeNode): TTreeNode;
var
  I: Integer;
  Item: TWatchVariable;
  Node: TTreeNode;
begin
  Result := nil;
  if Assigned(Parent) then
  begin
    for I := 0 to Parent.Count - 1 do
    begin
      Item := TWatchVariable(Parent.Item[I].Data);
      if Name = Item.Name then
      begin
        Result := Parent.Item[I];
        Exit;
      end;
    end;
  end
  else
  begin//level 0
    Node := TreeView.Items.GetFirstNode;
    while Node <> nil do
    begin
      Item := TWatchVariable(Node.Data);
      if Name = Item.Name then
      begin
        Result := Node;
        Exit;
      end;
      Node := Node.getNextSibling;
    end;
  end;
end;

procedure TDebugParser.Parse(Parent: TTreeNode; Token: TTokenClass);

  function AddVar(Name, Value: String; var childToken: TTokenClass): TTreeNode;
  var
    tempToken: TTokenClass;
    watchVar: TWatchVariable;
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
    Result := SearchVariable(Name, Parent);
    if not Assigned(Result) then
    begin
      if Value = '' then
        Result := FTreeView.Items.AddChild(Parent, Name)
      else
        Result := FTreeView.Items.AddChild(Parent, Name + ' = ' + Value);
      watchVar := TWatchVariable.Create;
    end
    else
    begin
      if Value = '' then
        Result.Text := Name
      else
        Result.Text := Name + ' = ' + Value;
      watchVar := TWatchVariable(Result.Data);
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
    Result.ImageIndex := 0;
    Result.SelectedIndex := Result.ImageIndex;
    Result.Data := watchVar;
  end;

var
  VarName, VarValue: String;
  EqFind: Boolean;
  closePair: Char;
  Item: TTreeNode;
  childToken: TTokenClass;
begin
  VarName := '';
  VarValue := '';
  EqFind := False;
  repeat
    case fptr^ of
      '=':
      begin
        EqFind := True;
        VarValue := '';
      end;
      #0 : Break;
      '"', '''':
      begin
        if EqFind then
          VarValue := VarValue + GetString(fptr^)
        else
          VarName := VarName + GetString(fptr^);
      end;
      '(', '<', '[':
      begin
        case fptr^ of
          '(': closePair := ')';
          '<': closePair := '>';
          '[': closePair := ']';
        else
          closePair := #0;
        end;
        if EqFind then
          VarValue := VarValue + GetPair(fptr^, closePair)
        else
          VarName := VarName + GetPair(fptr^, closePair);
      end;
      '{', ',', '}':
      begin
        VarName := Trim(VarName);
        VarValue := Trim(VarValue);
        Item := AddVar(VarName, VarValue, childToken);
        VarName := '';
        VarValue := '';
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
      end;
    else
      if EqFind then
        VarValue := VarValue + fptr^
      else
        VarName := VarName + fptr^;
    end;
    Inc(fptr);
  until fptr^ = #0;
  VarName := Trim(VarName);
  VarValue := Trim(VarValue);
  if (VarName = '') or (VarValue = '') then
    Exit;
  AddVar(VarName, VarValue, childToken);
end;

procedure TDebugParser.Clear;
var
  I: Integer;
begin
  for I := 0 to FTreeView.Items.Count - 1 do
    TWatchVariable(FTreeView.Items.Item[I].Data).Free;
  TreeView.Items.Clear;
end;

procedure TDebugParser.Fill(const S: String; token: TTokenClass);
begin
  FText := S;
  fptr := PChar(FText);
  Parse(nil, token);
end;

end.
 