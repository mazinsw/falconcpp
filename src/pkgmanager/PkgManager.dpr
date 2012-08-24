program PkgManager;

uses
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
  BZip2 in '..\others\bzip2\BZip2.pas',
  LibTar in '..\others\libtar\LibTar.pas',
  SciZipFile in '..\others\scizipfile\SciZipFile.pas',
  CompressUtils in '..\others\compressutils\CompressUtils.pas',
  StrMatch in '..\others\compressutils\StrMatch.pas';

var
  Silent: Boolean;
  Install: Boolean;
  InstallFileName: String;
  I: Integer;
begin
  Install := True;
  Silent := False;
  InstallFileName := '';

  for I := 1 to ParamCount do
  begin
    if StringIn(ParamStr(I), ['/S', '/silent', '-S', '--silent']) then
      Silent := True
    else
    if StringIn(ParamStr(I), ['/I', '/install', '-I', '--install']) then
      Install := True
    else
    if StringIn(ParamStr(I), ['/U', '/uninstall', '-U', '--uninstall']) then
      Install := False
    else
      InstallFileName := ParamStr(I);
  end;

  if Install and FileExists(InstallFileName) then
  begin
    if LoadPackageFile(InstallFileName, Silent) then
    begin
      if Silent then Exit;
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
    if not UninstallPackage(InstallFileName, 0, Silent) then ExitCode := 1;
  end
  else
  begin
    Application.Initialize;
	  Application.Title := 'Package Manager';
    Application.CreateForm(TFrmPkgMan, FrmPkgMan);
	  Application.Run;
  end;
end.
