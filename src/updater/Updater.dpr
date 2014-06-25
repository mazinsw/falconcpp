program Updater;

{$I Falcon.inc}
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  FastMM4 in '..\others\fastmm\FastMM4.pas',
  FastMM4Messages in '..\others\fastmm\FastMM4Messages.pas',
  Forms,
  SysUtils,
  ShlObj,
  UFraGetVer in 'UFraGetVer.pas' {FraGetVer: TFrame},
  UFraUpdate in 'UFraUpdate.pas' {FraUpdate: TFrame},
  UFrmUpdate in 'UFrmUpdate.pas' {FrmUpdate},
  UUtils in 'UUtils.pas',
  ExecWait in '..\others\utils\ExecWait.pas',
  BZip2 in '..\others\bzip2\BZip2.pas',
  LibTar in '..\others\libtar\LibTar.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas',
  KAZip in '..\others\zip\KAZip.pas',
  SystemUtils in '..\others\utils\SystemUtils.pas',
  ThreadExtract in '..\others\compressutils\ThreadExtract.pas';

{$IFDEF FALCON_PORTABLE}
  {$R resources_portable.RES}
{$ELSE}
  {$R resources.RES}
{$ENDIF}

begin
  AppRoot := GetFalconDir;
  if not IsSecureUpdate then
  begin
    RunSecureUpdater;
    Exit;
  end;
{$IFDEF FALCON_PORTABLE}
  ConfigPath := AppRoot + 'Config\';
{$ELSE}
  ConfigPath := GetSpecialFolderPath(CSIDL_APPDATA) + 'Falcon\';
{$ENDIF}
  if not DirectoryExists(ConfigPath) then
    CreateDir(ConfigPath);
  if FileExists(AppRoot + 'Falcon.exe') then
    FalconVersion := GetFileVersionA(AppRoot + 'Falcon.exe')
  else
    FalconVersion := ParseVersion('1.0.0.0');
  Application.Initialize;
  Application.Title := 'Application Update';
  Application.CreateForm(TFrmUpdate, FrmUpdate);
  Application.Run;
end.
