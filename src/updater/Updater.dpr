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
  SciZipFile in '..\others\scizipfile\SciZipFile.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas';

{$R *.res}
{$R resources.RES}

begin
  AppRoot := GetFalconDir;
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
