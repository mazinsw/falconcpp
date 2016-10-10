unit ThreadTokenFiles;

interface

uses
  Windows, CppParser, TokenFile, Classes, SysUtils, Contnrs;

type
  TTokenParseMethod = (
    tpmParseAndLoad,
    tpmParseAndSave,
    tpmParseAndLoadRecursive,
    tpmLoadParsedRecursive
  );

  TProgressEvent = procedure(Sender: TObject; TokenFile: TTokenFile; const FileName: string; Current,
    Total: Integer; Parsed: Boolean; Method: TTokenParseMethod) of object;
  TFinishEvent = procedure(Sender: TObject; Canceled: Boolean) of object;
  TPeekItemFuc = function(var FileName: string; var Data: Pointer): Boolean of object;
  TFileObject = class
    ID: Pointer;
    FileName: string;
    Text: string;
  end;

  TThreadTokenFiles = class(TThread)
  private
    { Private declarations }
    fLock: TRTLCriticalSection;
    fRunEvent: THandle;
    fTokenFile: TTokenFile;
    fFileName: string;
    fCurrent: Integer;
    fTotal: Integer;
    fParsed: Boolean;
    fCancel: Boolean;

    fMethod: TTokenParseMethod;
    fOnStart: TNotifyEvent;
    fOnProgress: TProgressEvent;
    fOnFinish: TFinishEvent;
    fOnAllFinish: TNotifyEvent;
    fTokenFiles: TTokenFiles;
    fFileQueue: TQueue;
    fBaseDir: string;
    fDestBaseDir: string;
    fFromBaseDir: string;
    fExtension: string;
    FBusy: Boolean;
    
    fParser: TCppParser;
    function PeekItem(var FileName: string; var Data: Pointer): Boolean;
    procedure DoStart;
    procedure DoProgress;
    procedure DoFinish;
    procedure DoAllFinish;

    procedure ParserProgress(TokenFile: TTokenFile;
      const FileName: string; Current: Integer; Parsed: Boolean);

    procedure AddFiles(FileList: TStrings);
    procedure Shutdown;

    //parser
    function ParseRecursiveAux(const FileName: string; FilesParsed: Integer): Integer;
    function LoadRecursiveAux(const FileName: string; FilesParsed: Integer): Integer;

    procedure ParseAndSaveFilesA;
    function LoadRecursiveA(const FileName: string): Integer; overload;
    procedure ParseLoadA;
    function ParseRecursiveA(const FileName: string): Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(TokenFiles: TTokenFiles);
    destructor Destroy; override;
    procedure Start(FileList: TStrings; const BaseDir, DestBaseDir,
      Extension: string); overload;
    procedure ParseLoad(FileList: TStrings);
    procedure ParseRecursive(FileList: TStrings);
    procedure LoadRecursive(FileList: TStrings; const BaseDir, FromBaseDir,
      Extension: string);
    procedure Clear;
    procedure Cancel;
    property Busy: Boolean read FBusy;
    property OnStart: TNotifyEvent read fOnStart write fOnStart;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property OnFinish: TFinishEvent read fOnFinish write fOnFinish;
    property OnAllFinish: TNotifyEvent read fOnAllFinish write fOnAllFinish;
  end;

  TMethodInfo = class
  private
    FFileName: string;
    FData: Pointer;
  public
    constructor Create(FileName: string; Data: Pointer);
    property FileName: string read FFileName write FFileName;
    property Data: Pointer read FData write FData;
  end;

implementation

uses
  TokenUtils, TokenList, UnicodeUtils;

{ TThreadTokenFiles }

//parse functions

procedure TThreadTokenFiles.ParseLoadA;
var
  TokenFile: TTokenFile;
  Lines: TStringList;
  WithBOM, ParserOk: Boolean;
  FileObj: TFileObject;
  LineBreak, S: string;
  Data: Pointer;
  Encoding: TEncoding;
begin
  fCancel := False;
  fBusy := True;
  Synchronize(DoStart);
  Lines := TStringList.Create;
  while PeekItem(S, Data) do
  begin
    ParserOk := False;
    if fCancel then
      Break;
    TokenFile := nil;
    FileObj := TFileObject(Data);
    if S <> '-' then
    begin
      S := FileObj.FileName;
      if FileExists(S) and (fTokenFiles.Find(S) = nil) then
      begin
        TokenFile := TTokenFile.Create(fTokenFiles);
        TokenFile.FileName := S;
        TokenFile.Data := FileObj.ID;
        FileObj.Free;
        LoadFileEx(S, Lines, WithBOM, Encoding, LineBreak);
        Lines.LineBreak := LineBreak;
        fParser.Run(Lines.Text, TokenFile);
        if fCancel then
        begin
          TokenFile.Free;
          Break;
        end;
        fTokenFiles.Add(TokenFile);
        ParserOk := True;
      end
      else
        FileObj.Free;
    end
    else
    begin
      S := FileObj.FileName;
      if fTokenFiles.Find(S) = nil then
      begin
        TokenFile := TTokenFile.Create(fTokenFiles);
        TokenFile.FileName := S;
        TokenFile.Data := FileObj.ID;
        fParser.Run(FileObj.Text, TokenFile);
        FileObj.Free;
        if fCancel then
        begin
          TokenFile.Free;
          Break;
        end;
        fTokenFiles.Add(TokenFile);
        ParserOk := True;
      end
      else
        FileObj.Free;
    end;
    ParserProgress(TokenFile, S, 1, ParserOk);
  end;
  Lines.Free;
  fBusy := False;
  Synchronize(DoFinish);
end;

function TThreadTokenFiles.ParseRecursiveAux(const FileName: string;
  FilesParsed: Integer): Integer;
var
  I, J: Integer;
  TokenFile: TTokenFile;
  Lines: TStringList;
  PathOnly, IncludeFileName, IncludeName: string;
  WithBOM: Boolean;
  LineBreak: string;
  Encoding: TEncoding;
begin
  Result := FilesParsed;
  if not FileExists(FileName) then
    Exit;
  if fTokenFiles.Find(FileName) <> nil then
    Exit;
  if fCancel then
    Exit;
  Lines := TStringList.Create;
  TokenFile := TTokenFile.Create(fTokenFiles);
  TokenFile.FileName := FileName;
  LoadFileEx(FileName, Lines, WithBOM, Encoding, LineBreak);
  Lines.LineBreak := LineBreak;
  fParser.Run(Lines.Text, TokenFile);
  Lines.Free;
  if fCancel then
  begin
    TokenFile.Free;
    Exit;
  end;
  fTokenFiles.Add(TokenFile);
  Inc(Result);
  ParserProgress(TokenFile, FileName, Result, True);
  PathOnly := ExtractFilePath(FileName);
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    IncludeName := ConvertSlashes(TokenFile.Includes.Items[I].Name);
    if TokenFile.Includes.Items[I].Flag = 'S' then
    begin
      for J := 0 to fTokenFiles.PathList.Count - 1 do
      begin
        IncludeFileName := ExpandFileName(fTokenFiles.PathList.Strings[J] + IncludeName);
        if FileExists(IncludeFileName) then
          Break;
      end;
    end
    else
    begin
      IncludeFileName := ExpandFileName(PathOnly + IncludeName);
      if not FileExists(IncludeFileName) then
      begin
        for J := 0 to fTokenFiles.PathList.Count - 1 do
        begin
          IncludeFileName := ExpandFileName(fTokenFiles.PathList.Strings[J] + IncludeName);
          if FileExists(IncludeFileName) then
            Break;
        end;
      end;
    end;
    if fTokenFiles.Find(IncludeFileName) <> nil then
      Continue;
    if fCancel then
      Exit;
    Result := ParseRecursiveAux(IncludeFileName, Result);
  end;
end;

function TThreadTokenFiles.ParseRecursiveA(const FileName: string): Integer;
begin
  fCancel := False;
  fBusy := True;
  Synchronize(DoStart);
  Result := ParseRecursiveAux(FileName, 0);
  Synchronize(DoFinish);
  fBusy := False;
end;

function TThreadTokenFiles.LoadRecursiveAux(const FileName: string;
  FilesParsed: Integer): Integer;
var
  I, J: Integer;
  TokenFile: TTokenFile;
  FromName, DirFrom, DirBase, IncludeName, IncludeFileName: string;
begin
  Result := FilesParsed;
  if fTokenFiles.Find(FileName) <> nil then
    Exit;
  if fCancel then
    Exit;
  DirFrom := IncludeTrailingPathDelimiter(fFromBaseDir);
  DirFrom := DirFrom + ExtractRelativePath(fBaseDir, ExtractFilePath(FileName));
  DirFrom := IncludeTrailingPathDelimiter(DirFrom);
  FromName := DirFrom + ExtractFileName(FileName);
  FromName := FromName + fExtension;
  if not FileExists(FromName) or not FileExists(FileName) then
    Exit;
  TokenFile := TTokenFile.Create(fTokenFiles);
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
  fTokenFiles.Add(TokenFile);
  Inc(Result);
  if Result > 1 then
    Inc(fTotal);
  ParserProgress(TokenFile, FileName, Result, True);
  DirBase := ExtractFilePath(FileName);
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    IncludeName := ConvertSlashes(TokenFile.Includes.Items[I].Name);
    if TokenFile.Includes.Items[I].Flag = 'S' then
    begin
      for J := 0 to fTokenFiles.PathList.Count - 1 do
      begin
        IncludeFileName := fTokenFiles.PathList.Strings[J] + IncludeName;
        if FileExists(IncludeFileName) then
          Break;
      end;
    end
    else
    begin
      IncludeFileName := DirBase + IncludeName;
      if not FileExists(IncludeFileName) then
      begin
        for J := 0 to fTokenFiles.PathList.Count - 1 do
        begin
          IncludeFileName := fTokenFiles.PathList.Strings[J] + IncludeName;
          if FileExists(IncludeFileName) then
            Break;
        end;
      end;
    end;
    if fTokenFiles.Find(IncludeFileName) <> nil then
      Continue;
    if fCancel then
      Exit;
    Result := LoadRecursiveAux(IncludeFileName, Result);
    if fCancel then
      Exit;
  end;
end;

function TThreadTokenFiles.LoadRecursiveA(const FileName: string): Integer;
begin
  fCancel := False;
  fBusy := True;
  Synchronize(DoStart);
  Result := LoadRecursiveAux(FileName, 0);
  Synchronize(DoFinish);
  fBusy := False;
end;

procedure TThreadTokenFiles.ParseAndSaveFilesA;
var
  TokenFile: TTokenFile;
  Lines: TStringList;
  ParserOk, CanParse: Boolean;
  DestName, DirDest, FileName: string;
  Header: TSimpleFileToken;
  Data: Pointer;
  WithBOM: Boolean;
  LineBreak: string;
  Encoding: TEncoding;
begin
  fCancel := False;
  fBusy := True;
  Synchronize(DoStart);
  Lines := TStringList.Create;
  while PeekItem(FileName, Data) do
  begin
    ParserOk := False;
    if fCancel then
      Break;
    DestName := FileName;
    if FileExists(FileName) then
    begin
      DirDest := IncludeTrailingPathDelimiter(fDestBaseDir);
      DirDest := DirDest + ExtractRelativePath(fBaseDir, ExtractFilePath(FileName));
      DirDest := IncludeTrailingPathDelimiter(DirDest);
      DestName := DirDest + ExtractFileName(FileName);
      DestName := DestName + fExtension;
      CanParse := True;
      TokenFile := TTokenFile.Create(fTokenFiles);
      TokenFile.FileDate := FileDateTime(FileName);
      if FileExists(DestName) then
      begin
        if TokenFile.LoadHeader(DestName, Header) then
        begin
          CanParse := TokenFile.FileDate <> Header.DateOfFile;
        end;
      end;
      if CanParse then
      begin
        TokenFile.FileName := FileName;
        LoadFileEx(FileName, Lines, WithBOM, Encoding, LineBreak);
        Lines.LineBreak := LineBreak;
        fParser.Run(Lines.Text, TokenFile);
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
    ParserProgress(nil, FileName, 1, ParserOk);
  end;
  Lines.Free;
  Synchronize(DoFinish);
  fBusy := False;
end;

procedure TThreadTokenFiles.Execute;
var
  Temp: string;
  Data: Pointer;
begin
  while not Terminated do
  begin
    WaitForSingleObject(fRunEvent, INFINITE);
    repeat
      if Terminated then
        Break;
      // make sure the event is reset when we are still in the repeat loop
      ResetEvent(fRunEvent);
      if Terminated then
        Break;
      case fMethod of
        tpmLoadParsedRecursive:
          begin
            if not PeekItem(Temp, Data) then
              Continue;
            LoadRecursiveA(Temp);
          end;
        tpmParseAndSave:
          begin
            ParseAndSaveFilesA;
          end;
        tpmParseAndLoad:
          begin
            ParseLoadA;
          end;
      else // tpmParseAndLoadRecursive
        if not PeekItem(Temp, Data) then
          Continue;
        ParseRecursiveA(Temp);
      end;
    until (fFileQueue.Count = 0) or fCancel;
    if Terminated then
      Break;
    if fCancel then
      Clear;
    Synchronize(DoAllFinish);
    fBusy := False;
    fCancel := False;
  end;
end;

constructor TThreadTokenFiles.Create(TokenFiles: TTokenFiles);
begin
  inherited Create(True);
  InitializeCriticalSection(flock);
  fTokenFiles := TokenFiles;
  fParser := TCppParser.Create;
  fFileQueue := TQueue.Create;
  fRunEvent := CreateEvent(nil, FALSE, FALSE, nil);
  if (fRunEvent = 0) or (fRunEvent = INVALID_HANDLE_VALUE) then
    raise EOutOfResources.Create('Couldn''t create WIN32 event object');
end;

destructor TThreadTokenFiles.Destroy;
begin
  Shutdown;
  if (fRunEvent <> 0) and (fRunEvent <> INVALID_HANDLE_VALUE) then
    CloseHandle(fRunEvent);
  Clear;
  fFileQueue.Free;
  DeleteCriticalSection(flock);
  fParser.Free;
  inherited Destroy;
end;

procedure TThreadTokenFiles.Shutdown;
begin
  Terminate;
  Cancel;
  if (fRunEvent <> 0) and (fRunEvent <> INVALID_HANDLE_VALUE) then
    SetEvent(fRunEvent);
  WaitFor;
end;

procedure TThreadTokenFiles.Cancel;
begin
  if FBusy and not fCancel then
  begin
    fCancel := True;
    fParser.Cancel;
  end;
end;

procedure TThreadTokenFiles.Clear;
var
  Item: TMethodInfo;
begin
  EnterCriticalSection(flock);
  while fFileQueue.Count > 0 do
  begin
    Item := TMethodInfo(fFileQueue.Pop);
    if Item.Data <> nil then
      TFileObject(Item.Data).Free;
    Item.Free;
  end;
  fTotal := 0;
  fCurrent := 0;
  LeaveCriticalSection(flock);
end;

procedure TThreadTokenFiles.Start(FileList: TStrings; const BaseDir,
  DestBaseDir, Extension: string);
begin
  AddFiles(FileList);
  fBaseDir := BaseDir;
  fDestBaseDir := DestBaseDir;
  fExtension := Extension;
  fMethod := tpmParseAndSave;
  SetEvent(fRunEvent);
end;

procedure TThreadTokenFiles.ParseLoad(FileList: TStrings);
begin
  AddFiles(FileList);
  fMethod := tpmParseAndLoad;
  SetEvent(fRunEvent);
end;

procedure TThreadTokenFiles.ParseRecursive(FileList: TStrings);
begin
  AddFiles(FileList);
  fMethod := tpmParseAndLoadRecursive;
  SetEvent(fRunEvent);
end;

procedure TThreadTokenFiles.LoadRecursive(FileList: TStrings; const BaseDir,
  FromBaseDir, Extension: string);
begin
  AddFiles(FileList);
  fBaseDir := BaseDir;
  fFromBaseDir := FromBaseDir;
  fExtension := Extension;
  fMethod := tpmLoadParsedRecursive;
  SetEvent(fRunEvent);
end;

procedure TThreadTokenFiles.AddFiles(FileList: TStrings);
var
  I: Integer;
  Pair: TMethodInfo;
begin
  EnterCriticalSection(flock);
  for I := 0 to FileList.Count - 1 do
  begin
    Pair := TMethodInfo.Create(FileList.Strings[I], FileList.Objects[I]);
    fFileQueue.Push(Pair);
  end;                        
  Inc(fTotal, FileList.Count);
  LeaveCriticalSection(flock);
end;

procedure TThreadTokenFiles.DoStart;
begin
  if Assigned(fOnStart) and not Terminated then
    fOnStart(Self);
end;

procedure TThreadTokenFiles.DoProgress;
begin
  if Assigned(fOnProgress) and not Terminated then
    fOnProgress(Self, fTokenFile, fFileName, fCurrent, fTotal, fParsed,
      fMethod);
end;

procedure TThreadTokenFiles.DoFinish;
begin
  if Assigned(fOnFinish) and not Terminated then
    fOnFinish(Self, fCancel);
end;

procedure TThreadTokenFiles.DoAllFinish;
begin
  if fCurrent <= fTotal then
  begin
    fTotal := fTotal - fCurrent;
    fCurrent := 0;
    if Assigned(fOnAllFinish) and not Terminated then
      fOnAllFinish(Self);
  end;
end;

procedure TThreadTokenFiles.ParserProgress(TokenFile: TTokenFile;
  const FileName: string; Current: Integer; Parsed: Boolean);
begin
  fTokenFile := TokenFile;
  fFileName := FileName;
  Inc(fCurrent);
  fParsed := Parsed;
  Synchronize(DoProgress);
end;

function TThreadTokenFiles.PeekItem(var FileName: string;
  var Data: Pointer): Boolean;
var
  Pair: TMethodInfo;
begin
  Result := fFileQueue.Count > 0;
  if Result then
  begin
    Pair := TMethodInfo(fFileQueue.Pop);
    FileName := Pair.FileName;
    Data := Pair.Data;
    Pair.Free;
  end;
end;

{ TMethodInfo }

constructor TMethodInfo.Create(FileName: string; Data: Pointer);
begin
  FFileName := FileName;
  FData := Data;
end;

end.
