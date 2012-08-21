unit ThreadLoadTokenFiles;

interface

uses
  TokenFile, Classes, SysUtils;

type
  TTokenFileInfo = class
    TokenFiles: TTokenFiles;
    FileName: String;
    BaseDir: String;
    FromBaseDir: String;
    Extension: String;
  end;

  TThreadLoadTokenFiles = class(TThread)
  private
    fTokenFile: TTokenFile;
    fProgsFileName: String;
    fCurrent: Integer;
    fTotal: Integer;
    fParsed: Boolean;

    fMethod: TTokenParseMethod;
    fOnStart: TNotifyEvent;
    fOnProgress: TProgressEvent;
    fOnFinish: TNotifyEvent;
    
    fCancel: Boolean;
    fTokenFiles: TTokenFiles;
    fFileList: TList;
    FBusy: Boolean;

    procedure DoStart;
    procedure DoProgress;
    procedure DoFinish;

    procedure ParserStart(Sender: TObject);
    procedure ParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: String; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure ParserFinish(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start(TokenFiles: TTokenFiles;
      const FileName, BaseDir, FromBaseDir, Extension: String);
    procedure Cancel;
    procedure AddFile(TokenFiles: TTokenFiles; const FileName, BaseDir,
      FromBaseDir, Extension: String);
    property Busy: Boolean read FBusy;
    property OnStart: TNotifyEvent read fOnStart write fOnStart;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property OnFinish: TNotifyEvent read fOnFinish write fOnFinish;
  end;

implementation

//uses
//  UFrmMain;

{ ThreadLoadTokenFiles }

procedure TThreadLoadTokenFiles.Execute;
var
  tkinfo: TTokenFileInfo;
  I: Integer;
begin
  while (fFileList.Count > 0) and not fCancel do
  begin
    tkinfo := TTokenFileInfo(fFileList.Items[0]);
    fTokenFiles := tkinfo.TokenFiles;
    fTokenFiles.LoadRecursive(tkinfo.FileName,
      tkinfo.BaseDir, tkinfo.FromBaseDir, tkinfo.Extension, ParserStart,
        ParserProgress, ParserFinish);
    tkinfo.Free;
    fFileList.Delete(0);
  end;
  if fCancel then
  begin
    for I := 0 to fFileList.Count - 1 do
    begin
      tkinfo := TTokenFileInfo(fFileList.Items[I]);
      tkinfo.Free;
    end;
    fFileList.Clear;
  end;
  fTokenFiles := nil;
  FBusy := False;
end;

constructor TThreadLoadTokenFiles.Create;
begin
  inherited Create(True);
  fFileList := TList.Create;
end;

destructor TThreadLoadTokenFiles.Destroy;
begin
  fFileList.Free;
  inherited Destroy;
end;

procedure TThreadLoadTokenFiles.Start(TokenFiles: TTokenFiles;
  const FileName, BaseDir, FromBaseDir, Extension: String);
var
  tkinfo: TTokenFileInfo;
begin
  fCancel := False;
  tkinfo := TTokenFileInfo.Create;
  tkinfo.TokenFiles := TokenFiles;
  tkinfo.FileName := FileName;
  tkinfo.BaseDir := BaseDir;
  tkinfo.FromBaseDir := FromBaseDir;
  tkinfo.Extension := Extension;
  fFileList.Insert(fFileList.Count, tkinfo);
  if FBusy then Exit;
  FBusy := True;
  Resume;
end;

procedure TThreadLoadTokenFiles.AddFile(TokenFiles: TTokenFiles; const FileName,
  BaseDir, FromBaseDir, Extension: String);
var
  tkinfo: TTokenFileInfo;
begin
  if not Busy then
  begin
    Start(TokenFiles, FileName, BaseDir, FromBaseDir, Extension);
    Exit;
  end;

  tkinfo := TTokenFileInfo.Create;
  tkinfo.TokenFiles := TokenFiles;
  tkinfo.FileName := FileName;
  tkinfo.BaseDir := BaseDir;
  tkinfo.FromBaseDir := FromBaseDir;
  tkinfo.Extension := Extension;
  fFileList.Insert(fFileList.Count, tkinfo);
end;

procedure TThreadLoadTokenFiles.Cancel;
begin
  fCancel := True;
  if Assigned(fTokenFiles) then
    fTokenFiles.Cancel;
end;

procedure TThreadLoadTokenFiles.ParserStart(Sender: TObject);
begin
  Synchronize(DoStart);
end;

procedure TThreadLoadTokenFiles.ParserProgress(Sender: TObject;
  TokenFile: TTokenFile; const FileName: String; Current, Total: Integer;
  Parsed: Boolean; Method: TTokenParseMethod);
begin
  fTokenFile := TokenFile;
  fProgsFileName := FileName;
  fCurrent := Current;
  fTotal := Total;
  fParsed := Parsed;
  fMethod := Method;
  Synchronize(DoProgress);
end;

procedure TThreadLoadTokenFiles.ParserFinish(Sender: TObject);
begin
  Synchronize(DoFinish);
end;

procedure TThreadLoadTokenFiles.DoFinish;
begin
  if Assigned(fOnFinish) then
    fOnFinish(Self);
end;

procedure TThreadLoadTokenFiles.DoProgress;
begin
  if Assigned(fOnProgress) then
    fOnProgress(Self, fTokenFile, fProgsFileName, fCurrent, fTotal, fParsed,
      fMethod);
end;

procedure TThreadLoadTokenFiles.DoStart;
begin
  if Assigned(fOnStart) then
    fOnStart(Self);
end;

end.
