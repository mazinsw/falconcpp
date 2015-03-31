{
    This file is part of Dev-C++
    Copyright (c) 2004 Bloodshed Software

    Dev-C++ is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Dev-C++ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dev-C++; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit ExecWait;

interface

uses
{$IFDEF LINUX}
  Classes;
{$ELSE}
  Windows, Classes;
{$ENDIF}

type
  TExecThread = class(TThread)
  private
    fFile: string;
    fPath: string;
    fParams: string;
    fTimeOut: Cardinal;
    fProcess: Cardinal;
    fProcessID: Cardinal;
    fVisible: boolean;
    procedure ExecAndWait;
  public
    procedure Execute; override;
  public
    property FileName: string read fFile write fFile;
    property Path: string read fPath write fPath;
    property Params: string read fParams write fParams;
    property TimeOut: Cardinal read fTimeOut write fTimeOut;
    property Visible: boolean read fVisible write fVisible;
    property Process: Cardinal read fProcess;
    property ProcessID: Cardinal read fProcessID;
  end;

  TExecWait = class(TPersistent)
  private
    fExec: TExecThread;
    fIsRunning: boolean;
    fOnTermEvent: TNotifyEvent;
    fFileName: string;
    procedure TerminateEvent(Sender: TObject);
  public
    class function Exec: TExecWait;
    procedure Reset;
    procedure ResetAll;
    procedure ExecuteAndWatch(sFileName, sParams, sPath: string; bVisible: boolean; iTimeOut: Cardinal; OnStartEvent, OnTermEvent: TNotifyEvent);
  published
    property FileName: string read fFileName write fFileName;
    property Running: boolean read fIsRunning;
  end;

  TExecWaitGetStdOut = class
  private
    FFileName: string;
    FParams: string;
    FDirectory: string;
    FOutput: string;
    hOutputRead, hInputWrite: THandle;
    FProcessInfo: TProcessInformation;
    function Launch(hInputRead, hOutputWrite,
      hErrorWrite: THandle): Boolean;
    procedure GetStdOut;
  public
    function ExecWait(sFileName, sParams, sPath: string;
      var StdOut: string): Integer;
  end;

function Executor: TExecWait;
function ExecutorGetStdOut: TExecWaitGetStdOut;
procedure FreeExecResources;

implementation

uses SysUtils, tlhelp32;

{ TExecThread }

procedure TExecThread.Execute;
begin
  inherited;
  ExecAndWait;
end;

procedure TExecThread.ExecAndWait;
// Author    : Francis Parlant.
// Update    : Bill Rinko-Gay
// Adaptation: Yiannis Mandravellos
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    if fVisible then
      wShowWindow := SW_SHOW
    else
      wShowWindow := SW_HIDE;
  end;
  if CreateProcess(nil, PChar('"' + fFile + '" ' + fParams), nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, PChar(fPath),
    StartupInfo, ProcessInfo) then
  begin
    fProcess := ProcessInfo.hProcess;
    fProcessID := ProcessInfo.dwProcessId;
    WaitForSingleObject(ProcessInfo.hProcess, fTimeOut);
  end;
  CloseHandle(ProcessInfo.hProcess);
  CloseHandle(ProcessInfo.hThread);
end;

var
  fExecWait: TExecWait = nil;

function Executor: TExecWait;
begin
  if not Assigned(fExecWait) then
  begin
    try
      fExecWait := TExecWait.Create;
    finally
    end;
  end;
  Result := fExecWait;
end;

{ TExecWait }

class function TExecWait.Exec: TExecWait;
begin
  Result := Executor.Exec;
end;

procedure TExecWait.ExecuteAndWatch(sFileName, sParams, sPath: string;
  bVisible: boolean; iTimeOut: Cardinal; OnStartEvent, OnTermEvent: TNotifyEvent);
begin
  fIsRunning := True;
  fOnTermEvent := OnTermEvent;
  if Assigned(OnStartEvent) then
    OnStartEvent(Self);
  fExec := TExecThread.Create(True);
  FileName := sFileName;
  with fExec do
  begin
    FileName := sFileName;
    Params := sParams;
    Path := sPath;
    TimeOut := iTimeOut;
    Visible := bVisible;
    OnTerminate := TerminateEvent;
    FreeOnTerminate := True;
    Start;
  end;
end;

procedure TExecWait.Reset;
begin
  if Assigned(fExec) then
    TerminateProcess(fExec.Process, 0);
  fIsRunning := False;
end;

procedure TExecWait.ResetAll;
var
  bContinue: Boolean;
  hSnap: Cardinal;
  pe: PROCESSENTRY32;
  myprocID, hChildProc: Cardinal;
begin
  if Assigned(fExec) then
  begin
    //TerminateProcess(fExec.Process, 0);
    myprocID := fExec.ProcessID; // your main process id
    ZeroMemory(@pe, SizeOf(PROCESSENTRY32));
    pe.dwSize := sizeof(PROCESSENTRY32);
    hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if Process32First(hSnap, pe) then
    begin
      bContinue := TRUE;
      // kill child processes
      while bContinue do
      begin
        // only kill child processes
        if (pe.th32ParentProcessID = myprocID) then
        begin
          hChildProc := OpenProcess(PROCESS_ALL_ACCESS, FALSE, pe.th32ProcessID);
          if hChildProc <> 0 then
          begin
              TerminateProcess(hChildProc, 1);
              CloseHandle(hChildProc);
          end;
        end;
        bContinue := Process32Next(hSnap, pe);
      end;
      TerminateProcess(fExec.Process, 0);
    end;
  end;
  fIsRunning := False;
end;

procedure TExecWait.TerminateEvent(Sender: TObject);
begin
  fIsRunning := False;
  if Assigned(fOnTermEvent) then
    fOnTermEvent(Self);
end;

{TExecWaitGetStdOut}

var
  fExecWaitGetStdOut: TExecWaitGetStdOut = nil;

function ExecutorGetStdOut: TExecWaitGetStdOut;
begin
  if not Assigned(fExecWaitGetStdOut) then
  begin
    try
      fExecWaitGetStdOut := TExecWaitGetStdOut.Create;
    finally
    end;
  end;
  Result := fExecWaitGetStdOut;
end;

function TExecWaitGetStdOut.ExecWait(sFileName, sParams, sPath: string;
  var StdOut: string): Integer;
var
  SecAttrib: TSecurityAttributes;
  hOutputReadTmp, hInputWriteTmp: THandle;
  hInputRead, hOutputWrite, hErrorWrite: THandle;
  fRunning: Boolean;
  eCode: Cardinal;
begin
  Result := -1;
  FFileName := sFileName;
  FParams := sParams;
  FDirectory := sPath;
  StdOut := '';
  SecAttrib.nLength := SizeOf(TSecurityAttributes);
  SecAttrib.lpSecurityDescriptor := nil;
  SecAttrib.bInheritHandle := True;

  // Create a pipe for the child process's STDOUT.
  if not CreatePipe(hOutputReadTmp, hOutputWrite, @SecAttrib, 0) then
  begin
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hOutputWrite,
    GetCurrentProcess(), @hErrorWrite, 0, true, DUPLICATE_SAME_ACCESS) then
  begin
    Exit;
  end;

  // Create a pipe for the child process's STDIN.
  if not CreatePipe(hInputRead, hInputWriteTmp, @SecAttrib, 0) then
  begin
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hOutputReadTmp,
    GetCurrentProcess(), @hOutputRead, 0, False, DUPLICATE_SAME_ACCESS) then
  begin
    Exit;
  end;

  if not DuplicateHandle(GetCurrentProcess(), hInputWriteTmp,
    GetCurrentProcess(), @hInputWrite, 0, False, DUPLICATE_SAME_ACCESS) then
  begin
    Exit;
  end;

  if not CloseHandle(hOutputReadTmp) or
    not CloseHandle(hInputWriteTmp) then
  begin
    Exit;
  end;

  FRunning := Launch(hInputRead, hOutputWrite, hErrorWrite);
  if not FRunning then
  begin
    Result := GetLastError;
    CloseHandle(hOutputWrite);
    CloseHandle(hInputRead);
    CloseHandle(hErrorWrite);
    Exit;
  end;

  if not CloseHandle(hInputRead) or
    not CloseHandle(hOutputWrite) or
    not CloseHandle(hErrorWrite) then
  begin
    Result := GetLastError;
    TerminateProcess(FProcessInfo.hProcess, Result);
    CloseHandle(FProcessInfo.hProcess);
    Exit;
  end;
  GetStdOut;
  GetExitCodeProcess(FProcessInfo.hProcess, eCode);
  Result := eCode;
  CloseHandle(hOutputRead);
  CloseHandle(hInputWrite);
  CloseHandle(FProcessInfo.hProcess);
  StdOut := FOutput;
end;

function TExecWaitGetStdOut.Launch(hInputRead, hOutputWrite,
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
end;

procedure TExecWaitGetStdOut.GetStdOut;
var
  nRead: DWORD;
  bSucess: Boolean;
  Buffer: array[0..2048] of AnsiChar;
begin
  FOutput := '';
  repeat
    bSucess := ReadFile(hOutputRead, Buffer, SizeOf(Buffer) - SizeOf(AnsiChar),
      nRead, nil);
    if not bSucess or (nRead = 0) or (GetLastError() = ERROR_BROKEN_PIPE) then
      Break;
    Buffer[nRead] := #0;
    FOutput := FOutput + string(StrPas(Buffer));
  until False;
end;

procedure FreeExecResources;
begin
  if fExecWait <> nil then
    fExecWait.Free;
  fExecWait := nil;
  if fExecWaitGetStdOut <> nil then
    fExecWaitGetStdOut.Free;
  fExecWaitGetStdOut := nil;
end;

end.
