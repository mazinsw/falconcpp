program PkgManager;
{$I Falcon.inc}
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  FastMM4 in '..\others\fastmm\FastMM4.pas',
  FastMM4Messages in '..\others\fastmm\FastMM4Messages.pas',
  Windows,
  SysUtils,
  Forms,
  UFraFnsh in 'UFraFnsh.pas' {FraFnsh: TFrame},
  UFraReadMe in 'UFraReadMe.pas' {FraReadMe: TFrame},
  UFraPrgs in 'UFraPrgs.pas' {FraPrgs: TFrame},
  UFraSteps in 'UFraSteps.pas' {FraSteps: TFrame},
  UFraWelcome in 'UFraWelcome.pas' {FraWelc: TFrame},
  UFrmWizard in 'UFrmWizard.pas' {FrmWizard},
  UFraDesc in 'UFraDesc.pas' {FraDesc: TFrame},
  UFraAgrmt in 'UFraAgrmt.pas' {FraAgrmt: TFrame},
  UInstaller in 'UInstaller.pas',
  UFrmLoad in 'UFrmLoad.pas' {FrmLoad},
  UFrmPkgMan in 'UFrmPkgMan.pas' {FrmPkgMan},
  LoadImage in 'LoadImage.pas',
  UFrmUninstall in 'UFrmUninstall.pas' {FrmUninstall},
  UUninstaller in 'UUninstaller.pas',
  LibTar in '..\others\libtar\LibTar.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas',
  UFrmPkgDownload in 'UFrmPkgDownload.pas' {FrmPkgDownload},
  UPkgClasses in 'UPkgClasses.pas',
  UFrmHelp in 'UFrmHelp.pas' {FrmHelp},
  rbtree in '..\falconcpp\rbtree.pas',
  ULanguages in 'ULanguages.pas',
  PkgUtils in 'PkgUtils.pas',
  KAZip in '..\others\zip\KAZip.pas',
  SystemUtils in '..\others\utils\SystemUtils.pas',
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

{.$DEFINE PKGMAN_RUNAS}
{$IFDEF FALCON_PORTABLE}
{$R resources_portable.RES}
{$ELSE}
{$IFDEF PKGMAN_RUNAS}
{$R resources_runas.RES}
{$ELSE}
{$R resources.RES}
{$ENDIF}
{$ENDIF}

var
  Silent: Boolean;
  Install: Boolean;
  InstallFileName: string;
  I: Integer;

begin
  Install := True;
  Silent := False;
  InstallFileName := '';

  for I := 1 to ParamCount do
  begin
    if StringIn(ParamStr(I), ['/S', '/silent', '-S', '--silent']) then
      Silent := True
    else if StringIn(ParamStr(I), ['/I', '/install', '-I', '--install']) then
      Install := True
    else if StringIn(ParamStr(I), ['/U', '/uninstall', '-U', '--uninstall'])
      then
      Install := False
    else
      InstallFileName := ParamStr(I);
  end;
  if not Silent then
    LoadTranslation;
  if Install and FileExists(InstallFileName) then
  begin
    if LoadPackageFile(0, InstallFileName, Silent) then
    begin
      if Silent then
        Exit;
      Application.Initialize;
      Application.Title := 'Falcon C++ Install Wizard';
      Application.CreateForm(TFrmWizard, FrmWizard);
  Application.Run;
    end
    else
      ExitCode := 1;
  end
  else if not Install then
  begin
    if not UninstallPackage(InstallFileName, 0, Silent) then
      ExitCode := 1;
  end
  else
  begin
    Application.Initialize;
    Application.Title := 'Package Manager';
    Application.CreateForm(TFrmPkgMan, FrmPkgMan);
    Application.Run;
  end;

end.
