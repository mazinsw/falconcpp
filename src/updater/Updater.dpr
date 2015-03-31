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
  LibTar in '..\others\libtar\LibTar.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas',
  KAZip in '..\others\zip\KAZip.pas',
  SystemUtils in '..\others\utils\SystemUtils.pas',
  ThreadExtract in '..\others\compressutils\ThreadExtract.pas',
  UnicodeUtils in '..\falconcpp\editor\UnicodeUtils.pas',
  Big5Freq in '..\others\encoding\chsdet\src\Big5Freq.pas',
  CharDistribution in '..\others\encoding\chsdet\src\CharDistribution.pas',
  chsdIntf in '..\others\encoding\chsdet\src\chsdIntf.pas',
  CustomDetector in '..\others\encoding\chsdet\src\CustomDetector.pas',
  Dump in '..\others\encoding\chsdet\src\Dump.pas',
  EUCKRFreq in '..\others\encoding\chsdet\src\EUCKRFreq.pas',
  EUCSampler in '..\others\encoding\chsdet\src\EUCSampler.pas',
  EUCTWFreq in '..\others\encoding\chsdet\src\EUCTWFreq.pas',
  GB2312Freq in '..\others\encoding\chsdet\src\GB2312Freq.pas',
  JISFreq in '..\others\encoding\chsdet\src\JISFreq.pas',
  JpCntx in '..\others\encoding\chsdet\src\JpCntx.pas',
  MBUnicodeMultiProber in '..\others\encoding\chsdet\src\MBUnicodeMultiProber.pas',
  MultiModelProber in '..\others\encoding\chsdet\src\MultiModelProber.pas',
  nsCodingStateMachine in '..\others\encoding\chsdet\src\nsCodingStateMachine.pas',
  nsCore in '..\others\encoding\chsdet\src\nsCore.pas',
  nsEscCharsetProber in '..\others\encoding\chsdet\src\nsEscCharsetProber.pas',
  nsGroupProber in '..\others\encoding\chsdet\src\nsGroupProber.pas',
  nsHebrewProber in '..\others\encoding\chsdet\src\nsHebrewProber.pas',
  nsLatin1Prober in '..\others\encoding\chsdet\src\nsLatin1Prober.pas',
  nsMBCSMultiProber in '..\others\encoding\chsdet\src\nsMBCSMultiProber.pas',
  nsPkg in '..\others\encoding\chsdet\src\nsPkg.pas',
  nsSBCharSetProber in '..\others\encoding\chsdet\src\nsSBCharSetProber.pas',
  nsSBCSGroupProber in '..\others\encoding\chsdet\src\nsSBCSGroupProber.pas',
  nsUniversalDetector in '..\others\encoding\chsdet\src\nsUniversalDetector.pas',
  vi in '..\others\encoding\chsdet\src\vi.pas',
  LangBulgarianModel in '..\others\encoding\chsdet\src\sbseq\LangBulgarianModel.pas',
  LangCyrillicModel in '..\others\encoding\chsdet\src\sbseq\LangCyrillicModel.pas',
  LangGreekModel in '..\others\encoding\chsdet\src\sbseq\LangGreekModel.pas',
  LangHebrewModel in '..\others\encoding\chsdet\src\sbseq\LangHebrewModel.pas',
  AppConst in '..\falconcpp\AppConst.pas';

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
