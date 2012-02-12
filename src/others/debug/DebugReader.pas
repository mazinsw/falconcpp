unit DebugReader;

interface

uses
  Windows, SysUtils, Classes, ShellAPI, regexp_tregexpr, Dialogs;

type
  TDebugCmd = (dcPrint, dcLocalize, dcNextLine, dcWatch, dcOnBreak,
    dcBreakpoint, dcTerminate, dcSegmentationFault, dcNewThread, dcNoSymbol,
    dcIdle, dcUnknow, dcLanguage, dcExternalStep);

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
    'dcExternalStep'
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
    Reader: TReaderConsole;
    regexp: TRegExpr;
    procedure DoStart;
    procedure DoOutputWriter;
    procedure DoFinish;
    //***********
    function IsNumber(const S: String): Boolean;
    function GetLine: String;
    //***********
    procedure ProcessPrint;
    procedure ProcessLocalize;
    procedure ProcessNextLine;
    procedure ProcessNewThread;
    procedure ProcessWatch;
    procedure ProcessOnBreak;
    procedure ProcessNoSymbol;
    procedure ProcessBreakpoint;
    procedure ProcessTerminate;
    procedure ProcessTerminateCode;
    procedure ProcessSegmentationFault;
    procedure ProcessIdle;
    procedure ProcessLanguage;
    procedure ProcessExternalStep;
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
  end;

implementation

uses DebugConsts;

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
begin
  Synchronize(FDebugReader.DoStart);
  Output := '';
  repeat
    bSucess := ReadFile(OutputRead, Buffer, SizeOf(Buffer) - 1, nRead, nil);
    if not bSucess or (nRead = 0) or (GetLastError() = ERROR_BROKEN_PIPE)  then
      Break;

    Buffer[nRead] := #0;
    Output := Output + StrPas(Buffer);
    if Pos(GDB_PROMPT, Output) > 0 then
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

function TDebugReader.IsNumber(const S: String): Boolean;
var
  ptr: PChar;
begin
  ptr := PChar(S);
  Result := False;
  if not (ptr^ in  dbgDigitChars + ['b']) then Exit;
  Inc(ptr);
  if ptr^ in ['x', 'X'] then Inc(ptr);
  while (ptr^ <> #0) and (ptr^ in dbgDigitChars + dbgHexChars + ['L']) do
  begin
    Result := True;
    Inc(ptr);
  end;
  if ptr^ <> #0 then Result := False;
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
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNextLine, FileName, regexp.Match[4],
      StrToInt(regexp.Match[3]));
end;

procedure TDebugReader.ProcessNewThread;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNewThread, '', regexp.Match[1], 0);
end;

procedure TDebugReader.ProcessWatch;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcWatch, '', regexp.Match[0], 0);
end;

procedure TDebugReader.ProcessOnBreak;
var
  FileName: String;
begin
  FileName := regexp.Match[2];
  FileName := StringReplace(FileName, '/', '\', [rfReplaceAll]);
  if Pos(':', FileName) = 0 then
    FileName := FDirectory + FileName;
  FileName := ExpandFileName(FileName);
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcOnBreak, FileName, regexp.Match[1],
      StrToInt(regexp.Match[3]));
end;

procedure TDebugReader.ProcessNoSymbol;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcNoSymbol, '', regexp.Match[0], 0);
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

procedure TDebugReader.ProcessSegmentationFault;
begin
  if Assigned(FOnCommandEvent) then
    FOnCommandEvent(Self, dcSegmentationFault, '', regexp.Match[0], 0);
end;

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
    I := Pos(GDB_PROMPT, S);
    while I = 1 do
    begin
      S := Copy(S, I + Length(GDB_PROMPT), Length(S) - Length(GDB_PROMPT));
      S := Trim(S);
      ProcessIdle;
      I := Pos(GDB_PROMPT, S);
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
    else if regexp.Exec(REGEXP_ONBREAK, S) then
      ProcessOnBreak
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
  if Assigned(FOnFinish) then
    FOnFinish(Self, FeCode);
end;

end.
 