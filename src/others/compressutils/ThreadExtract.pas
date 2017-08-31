unit ThreadExtract;

interface

uses
  Classes;

type
  TThreadExtract = class(TThread)
  private
    FFileName: string;
    FPath: string;
    FOnTermEvent: TNotifyEvent;
    procedure Extract;
    procedure TerminateEvent(Sender: TObject);
  public
    procedure Execute; override;
  public
    property FileName: string read FFileName write FFileName;
    property Path: string read FPath write FPath;
    property OnTermEvent: TNotifyEvent read FOnTermEvent write FOnTermEvent;
  end;

procedure ExtractAndWatch(const FileName, Path: string; OnStartEvent,
  OnTermEvent: TNotifyEvent);

implementation

uses KAZip, SysUtils;

{ TThreadExtract }

procedure TThreadExtract.Execute;
begin
  inherited;
  Extract;
end;

procedure TThreadExtract.Extract;
var
  Zp: TKAZip;
begin
  Zp := TKAZip.Create(nil);
  try
    Zp.Open(FFileName);
    Zp.OverwriteAction := oaOverwriteAll;
    Zp.Entries.ExtractAll(FPath);
  finally
    Zp.Free;
  end;
end;

procedure TThreadExtract.TerminateEvent(Sender: TObject);
begin
  if Assigned(fOnTermEvent) then
    fOnTermEvent(Self);
end;

procedure ExtractAndWatch(const FileName, Path: string; OnStartEvent,
  OnTermEvent: TNotifyEvent);
var
  ThreadExtract: TThreadExtract;
begin
  ThreadExtract := TThreadExtract.Create(True);
  if Assigned(OnStartEvent) then
    OnStartEvent(ThreadExtract);
  ThreadExtract.OnTermEvent := OnTermEvent;
  ThreadExtract.FileName := FileName;
  ThreadExtract.Path := Path;
  ThreadExtract.OnTerminate := ThreadExtract.TerminateEvent;
  ThreadExtract.FreeOnTerminate := True;
  ThreadExtract.Start;
end;

end.
