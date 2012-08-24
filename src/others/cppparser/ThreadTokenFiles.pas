unit ThreadTokenFiles;

interface

uses
  Windows, TokenFile, Classes, SysUtils;

type
  TThreadTokenFiles = class(TThread)
  private
    { Private declarations }
    fLock: TRTLCriticalSection;
    fTokenFile: TTokenFile;
    fProgsFileName: string;
    fCurrent: Integer;
    fTotal: Integer;
    fParsed: Boolean;

    fMethod: TTokenParseMethod;
    fOnStart: TNotifyEvent;
    fOnProgress: TProgressEvent;
    fOnFinish: TNotifyEvent;
    fCancel: Boolean;
    fTokenFiles: TTokenFiles;
    fFileList: TStrings;
    fFileName: string;
    fBaseDir: string;
    fDestBaseDir: string;
    fFromBaseDir: string;
    fExtension: string;
    FBusy: Boolean;
    procedure DoStart;
    procedure DoProgress;
    procedure DoFinish;
    procedure ParserStart(Sender: TObject);
    procedure ParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: string; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure ParserFinish(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start(TokenFiles: TTokenFiles; FileList: TStrings;
      const BaseDir, DestBaseDir, Extension: string);
    procedure ParseLoad(TokenFiles: TTokenFiles; FileList: TStrings);
    procedure ParseRecursive(TokenFiles: TTokenFiles; const FileName: string);
    procedure LoadRecursive(TokenFiles: TTokenFiles; const FileName, BaseDir,
      FromBaseDir, Extension: string);
    procedure Cancel;
    function AddFiles(FileList: TStrings): Boolean;
    property Busy: Boolean read FBusy;
    property Canceled: Boolean read fCancel;
    property OnStart: TNotifyEvent read fOnStart write fOnStart;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property OnFinish: TNotifyEvent read fOnFinish write fOnFinish;
  end;

implementation

{ TThreadTokenFiles }

procedure TThreadTokenFiles.Execute;
begin
  FBusy := True;
  case fMethod of
    tpmLoadParsedRecursive:
      begin
        fTokenFiles.LoadRecursive(fFileName, fBaseDir, fFromBaseDir, fExtension,
          ParserStart, ParserProgress, ParserFinish);
        fFileList.Clear;
      end;
    tpmParseAndSave:
      begin
        fTokenFiles.ParseAndSaveFiles(fFileList, fBaseDir, fDestBaseDir, fExtension,
          ParserStart, ParserProgress, ParserFinish);
        fFileList.Clear;
      end;
    tpmParseAndLoad:
      begin
        fTokenFiles.ParseLoad(fFileList,
          ParserStart, ParserProgress, ParserFinish);
        fFileList.Clear;
      end;
    tpmParseAndLoadRecursive:
      begin
        fTokenFiles.ParseRecursive(fFileName,
          ParserStart, ParserProgress, ParserFinish);
        fFileList.Clear;
      end;
  else
    DoFinish;
  end;
end;

constructor TThreadTokenFiles.Create;
begin
  inherited Create(True);
  fFileList := TStringList.Create;
end;

destructor TThreadTokenFiles.Destroy;
begin
  fFileList.Free;
  inherited Destroy;
end;

procedure TThreadTokenFiles.Start(TokenFiles: TTokenFiles; FileList: TStrings;
  const BaseDir, DestBaseDir, Extension: string);
begin
  fTokenFiles := TokenFiles;
  fFileList.Assign(FileList);
  fBaseDir := BaseDir;
  fDestBaseDir := DestBaseDir;
  fExtension := Extension;
  fMethod := tpmParseAndSave;
  Resume;
end;

procedure TThreadTokenFiles.ParseLoad(TokenFiles: TTokenFiles; FileList: TStrings);
begin
  fTokenFiles := TokenFiles;
  fFileList.Assign(FileList);
  fMethod := tpmParseAndLoad;
  Resume;
end;

procedure TThreadTokenFiles.ParseRecursive(TokenFiles: TTokenFiles;
  const FileName: string);
begin
  fTokenFiles := TokenFiles;
  fFileName := FileName;
  fMethod := tpmParseAndLoadRecursive;
  Resume;
end;

procedure TThreadTokenFiles.LoadRecursive(TokenFiles: TTokenFiles;
  const FileName, BaseDir, FromBaseDir, Extension: string);
begin
  fTokenFiles := TokenFiles;
  fFileName := FileName;
  fBaseDir := BaseDir;
  fFromBaseDir := FromBaseDir;
  fExtension := Extension;
  fMethod := tpmLoadParsedRecursive;
  Resume;
end;

function TThreadTokenFiles.AddFiles(FileList: TStrings): Boolean;
begin
  Result := False;
  if not Busy then
    Exit;
  InitializeCriticalSection(flock);
  fFileList.AddStrings(FileList);
  DeleteCriticalSection(flock);
  Result := True;
end;

procedure TThreadTokenFiles.Cancel;
begin
  fCancel := True;
  fTokenFiles.Cancel;
  if Busy then
    WaitFor;
end;

procedure TThreadTokenFiles.DoStart;
begin
  if Assigned(fOnStart) then
    fOnStart(Self);
end;

procedure TThreadTokenFiles.DoProgress;
begin
  if Assigned(fOnProgress) then
    fOnProgress(Self, fTokenFile, fProgsFileName, fCurrent, fTotal, fParsed,
      fMethod);
end;

procedure TThreadTokenFiles.DoFinish;
begin
  FBusy := False;
  if Assigned(fOnFinish) then
    fOnFinish(Self);
end;

procedure TThreadTokenFiles.ParserStart(Sender: TObject);
begin
  Synchronize(DoStart);
end;

procedure TThreadTokenFiles.ParserProgress(Sender: TObject; TokenFile: TTokenFile;
  const FileName: string; Current, Total: Integer; Parsed: Boolean;
  Method: TTokenParseMethod);
begin
  fTokenFile := TokenFile;
  fProgsFileName := FileName;
  fCurrent := Current;
  fTotal := Total;
  fParsed := Parsed;
  fMethod := Method;
  Synchronize(DoProgress);
end;

procedure TThreadTokenFiles.ParserFinish(Sender: TObject);
begin
  Synchronize(DoFinish);
end;

end.
