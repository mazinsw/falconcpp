program Updater;

uses
  Forms,
  SysUtils,
  ShlObj,
  UFraGetVer in 'UFraGetVer.pas' {FraGetVer: TFrame},
  UFraUpdate in 'UFraUpdate.pas' {FraUpdate: TFrame},
  UFrmUpdate in 'UFrmUpdate.pas' {FrmUpdate},
  UUtils in 'UUtils.pas',
  ExecWait in 'ExecWait.pas',
  BZip2 in '..\others\bzip2\BZip2.pas',
  LibTar in '..\others\libtar\LibTar.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas',
  KAZip in '..\others\zip\KAZip.pas';

{$R resources.RES}

var
  UpdaterName: string;
begin
  AppRoot := GetFalconDir;
  UpdaterName := ExtractFileName(Application.ExeName);
  if CompareText(AppRoot + UpdaterName, Application.ExeName) = 0 then
  begin
    RunSecureUpdater;
    Exit;
  end;
  ConfigPath := GetUserFolderPath(CSIDL_APPDATA) + 'Falcon\';
  if FileExists(AppRoot + 'Falcon.exe') then
    FalconVersion := GetFileVersionA(AppRoot + 'Falcon.exe')
  else
    FalconVersion := ParseVersion('1.0.0.0');
  Application.Initialize;
  Application.Title := 'Application Update';
  Application.CreateForm(TFrmUpdate, FrmUpdate);
  Application.Run;
end.
