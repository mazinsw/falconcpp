unit ULanguages;

interface

uses
  Windows, SysUtils, Classes, IniFiles;

const
  MAX_FRM_LOADING = 2;
  CONST_STR_FRM_LOADING: array[1..MAX_FRM_LOADING] of string = (
    'Please wait while extract package...',
    'unpacking data: %d%%'
  );

  MAX_FRM_WIZARD = 26;
  CONST_STR_FRM_WIZARD: array[1..MAX_FRM_WIZARD] of string = (
    '%s Installation',
    '< Back',
    'Next >',
    'Cancel',
    'I &Agree',
    'Install',
    'Finish',
    'Want to restart the system?',
    'Falcon C++ Installation Wizard',
    'Are you sure you want to quit %s Installation?',
    'Error can''t open file "%s".',
    'Error can''t create file "%s".',
    'Error can''t decompress file "%s".',
    '%s has been installed sucessfull.',
    'Package entry not found!',
    'Dependencies:',
    'Creating directory:',
    'Error creating directory:',
    '%s has been installed with errors\n folder ''%s'' couldn''t be created.',
    '%s has been installed with errors\n%d couldn''t be installed.',
    'Installation of %s has been aborted:\nError couldn''t create directory: %s.',
    'Error opening file for writing:',
    '%s has been installed with errors\nfile ''%s'' couldn''t be installed.',
    'Installation of %s has been aborted:\nError couldn''t open file ''%s'' for writing.',
    'Error opening temp file:',
    'Removing temp files...'
  );

  MAX_FRM_WELCOME = 4;
  CONST_STR_FRM_WELCOME: array[1..MAX_FRM_WELCOME] of string = (
    'Welcome to the %s Package Installation Wizard',
    'This wizard will guide you through the instalation of %s.',
    'It is recommended that you close Falcon C++ application before starting ' +
      'Installation. This will make it possible to update all files on the compiler folder.',
    'Click Next to continue.'
  );

  MAX_FRM_STEPS = 1;
  CONST_STR_FRM_STEPS: array[1..MAX_FRM_STEPS] of string = (
    'Falcon C++ Install Package'
  );

  MAX_FRM_AGRMT = 4;
  CONST_STR_FRM_AGRMT: array[1..MAX_FRM_AGRMT] of string = (
    'If you accept the terms of the agreement, click I Agree to conti' +
      'nue. You must accept the agreement to install %s.',
    'License Agreement',
    'Please review the license terms before installing %s.',
    'Press Page Down to see the rest of the agreement.'
  );

  MAX_FRM_README = 4;
  CONST_STR_FRM_README: array[1..MAX_FRM_README] of string = (
    'Press Page Down to see the rest of the README.',
    'Click Next to continue.',
    'README',
    'Please read the following README.'
  );

  MAX_FRM_DESC = 10;
  CONST_STR_FRM_DESC: array[1..MAX_FRM_DESC] of string = (
    'Package description',
    'Package details of %s.',
    'Space required:',
    'Space available:',
    'Package description',
    'Name:',
    'Version:',
    'Website:',
    'Description:',
    'Click Install to start the installation.'
  );

  MAX_FRM_PROGRESS = 4;
  CONST_STR_FRM_PROGRESS: array[1..MAX_FRM_PROGRESS] of string = (
    'Show details',
    'Installing',
    'Please wait while %s Package is being installed.',
    'Click Abort to stop the instalation,\nRetry to try again, or\n' +
      'Ignore to skip this file.'
  );

  MAX_FRM_FINISH = 3;
  CONST_STR_FRM_FINISH: array[1..MAX_FRM_FINISH] of string = (
    'Completing the %s Installation Wizard',
    'Click Finish to close this wizard.',
    'Show Package Manager'
  );

  MAX_FRM_UNINSTALL = 5;
  CONST_STR_FRM_UNINSTALL: array[1..MAX_FRM_UNINSTALL] of string = (
    'Uninstalling package...',
    'Ok',
    'Complete.',
    'Package "%s" not found',
    'Others Depends:'
  );

  MAX_FRM_PKG_MAN = 32;
  CONST_STR_FRM_PKG_MAN: array[1..MAX_FRM_PKG_MAN] of string = (
    'Falcon C++ Package Manager',
    'Packages',
    'View',
    'Help',
    'Install',
    'Uninstall',
    '-',
    'Reload',
    'Check',
    '-',
    'Exit',
    'Toolbar',
    'Details',
    'Statusbar',
    'Help',
    '-',
    'About...',
    'Install',
    'Uninstall',
    'Reload',
    'Check',
    'Help',
    'About',
    'Exit',
    'Information',
    'Files',
    'Open Folder',
    'Copy FileName',
    '%d of %d Files not Found',
    'Intact package files!',
    'Remove "%s" - Version: %s ?',
    'Ok'
  );

  MAX_FRM_PKG_DOWN = 42;
  CONST_STR_FRM_PKG_DOWN: array[1..MAX_FRM_PKG_DOWN] of string = (
    'Install packages',
    'Packages',
    'Name',
    'Version',
    'Size',
    'Status',
    'Show',
    'Updates/New',
    'Installed',
    'Search package:',
    'Install packages...',
    'Delete packages...',
    'Done loading packages.',
    'Loading packages...',
    'Error parsing xml.',
    'Retry',
    'Dependency "%s %s" to "%s %s" not found',
    'Downloading packages list %.2f%%.',
    'Downloading packages list...',
    'Install %d package...',
    'Install %d packages...',
    'Delete %d package...',
    'Delete %d packages...',
    'Download canceled.',
    'Download error invalid xml file.',
    'Uninstall',
    'Installed',
    'Install',
    'Not installed',
    'Do you cancel package installation?',
    'Package already installed!',
    'Package cannot be installed, a lowest dependency version already installed!',
    'Package cannot be uninstalled, other packages depend on!',
    'Error file %s not found',
    'Installing package %s...',
    'Done packages installation.',
    'Uninstalling package %s...',
    'Done packages uninstalled.',
    'Downloading package %s...',
    'Downloading package %s - %.1f%%...',
    'Error on install %s package',
    'Error on uninstall %s package'
  );


procedure LoadTranslation;

var
  STR_FRM_LOADING: array[1..MAX_FRM_LOADING] of string;
  STR_FRM_WIZARD: array[1..MAX_FRM_WIZARD] of string;
  STR_FRM_WELCOME: array[1..MAX_FRM_WELCOME] of string;
  STR_FRM_STEPS: array[1..MAX_FRM_STEPS] of string;
  STR_FRM_AGRMT: array[1..MAX_FRM_AGRMT] of string;
  STR_FRM_README: array[1..MAX_FRM_README] of string;
  STR_FRM_DESC: array[1..MAX_FRM_DESC] of string;
  STR_FRM_PROGRESS: array[1..MAX_FRM_PROGRESS] of string;
  STR_FRM_FINISH: array[1..MAX_FRM_FINISH] of string;
  STR_FRM_UNINSTALL: array[1..MAX_FRM_UNINSTALL] of string;
  STR_FRM_PKG_MAN: array[1..MAX_FRM_PKG_MAN] of string;
  STR_FRM_PKG_DOWN: array[1..MAX_FRM_PKG_DOWN] of string;

implementation

uses PkgUtils, ShlObj, SystemUtils, UnicodeUtils, AppConst;

procedure UpdateLang(ini: TCustomIniFile);

  function ReadStr(const Ident: Integer; const Default: string): string;
  begin
    Result := ini.ReadString('FALCON', IntToStr(Ident), Default);
  end;

var
  I: Integer;
begin
  for I := 1 to MAX_FRM_LOADING do //7001
    STR_FRM_LOADING[I] := ReadStr(I + 7000, CONST_STR_FRM_LOADING[I]);
  for I := 1 to MAX_FRM_WIZARD do //7101
    STR_FRM_WIZARD[I] := ReadStr(I + 7100, CONST_STR_FRM_WIZARD[I]);
  for I := 1 to MAX_FRM_WELCOME do //7201
    STR_FRM_WELCOME[I] := ReadStr(I + 7200, CONST_STR_FRM_WELCOME[I]);
  for I := 1 to MAX_FRM_STEPS do //7301
    STR_FRM_STEPS[I] := ReadStr(I + 7300, CONST_STR_FRM_STEPS[I]);
  for I := 1 to MAX_FRM_AGRMT do //7401
    STR_FRM_AGRMT[I] := ReadStr(I + 7400, CONST_STR_FRM_AGRMT[I]);
  for I := 1 to MAX_FRM_README do //7501
    STR_FRM_README[I] := ReadStr(I + 7500, CONST_STR_FRM_README[I]);
  for I := 1 to MAX_FRM_DESC do //7601
    STR_FRM_DESC[I] := ReadStr(I + 7600, CONST_STR_FRM_DESC[I]);
  for I := 1 to MAX_FRM_PROGRESS do //7701
    STR_FRM_PROGRESS[I] := ReadStr(I + 7700, CONST_STR_FRM_PROGRESS[I]);
  for I := 1 to MAX_FRM_FINISH do //7801
    STR_FRM_FINISH[I] := ReadStr(I + 7800, CONST_STR_FRM_FINISH[I]);
  for I := 1 to MAX_FRM_UNINSTALL do //7901
    STR_FRM_UNINSTALL[I] := ReadStr(I + 7900, CONST_STR_FRM_UNINSTALL[I]);
  for I := 1 to MAX_FRM_PKG_MAN do //8001
    STR_FRM_PKG_MAN[I] := ReadStr(I + 8000, CONST_STR_FRM_PKG_MAN[I]);
  for I := 1 to MAX_FRM_PKG_DOWN do //8101
    STR_FRM_PKG_DOWN[I] := ReadStr(I + 8100, CONST_STR_FRM_PKG_DOWN[I]);
end;

procedure LoadDefaultLang;
var
  I: Integer;
begin
  for I := 1 to MAX_FRM_LOADING do
    STR_FRM_LOADING[I] := CONST_STR_FRM_LOADING[I];
  for I := 1 to MAX_FRM_WIZARD do
    STR_FRM_WIZARD[I] := CONST_STR_FRM_WIZARD[I];
  for I := 1 to MAX_FRM_WELCOME do
    STR_FRM_WELCOME[I] := CONST_STR_FRM_WELCOME[I];
  for I := 1 to MAX_FRM_STEPS do
    STR_FRM_STEPS[I] := CONST_STR_FRM_STEPS[I];
  for I := 1 to MAX_FRM_AGRMT do
    STR_FRM_AGRMT[I] := CONST_STR_FRM_AGRMT[I];
  for I := 1 to MAX_FRM_README do
    STR_FRM_README[I] := CONST_STR_FRM_README[I];
  for I := 1 to MAX_FRM_DESC do
    STR_FRM_DESC[I] := CONST_STR_FRM_DESC[I];
  for I := 1 to MAX_FRM_PROGRESS do
    STR_FRM_PROGRESS[I] := CONST_STR_FRM_PROGRESS[I];
  for I := 1 to MAX_FRM_FINISH do
    STR_FRM_FINISH[I] := CONST_STR_FRM_FINISH[I];
  for I := 1 to MAX_FRM_UNINSTALL do
    STR_FRM_UNINSTALL[I] := CONST_STR_FRM_UNINSTALL[I];
  for I := 1 to MAX_FRM_PKG_MAN do
    STR_FRM_PKG_MAN[I] := CONST_STR_FRM_PKG_MAN[I];
  for I := 1 to MAX_FRM_PKG_DOWN do
    STR_FRM_PKG_DOWN[I] := CONST_STR_FRM_PKG_DOWN[I];
end;

procedure LoadTranslation;
var
  Files: TStrings;
  FalconDir, LangFileName, AlterConfIni, LangDir, ConfigPath,
    UsersDefDir: String;
  I: Integer;
  LangID, FileLangID: Cardinal;
  ini: TCustomIniFile;
  Lines: TStrings;
begin
  LoadDefaultLang;
  FalconDir := GetFalconDir;
  ConfigPath := GetConfigDir(FalconDir);
  ini := TIniFile.Create(ConfigPath + CONFIG_NAME);
  AlterConfIni := ini.ReadString('EnvironmentOptions', 'ConfigurationFile', '');
  AlterConfIni := ExpandRelativeFileName(FalconDir, AlterConfIni);
  if ini.ReadBool('EnvironmentOptions', 'AlternativeConfFile', False) and
    FileExists(AlterConfIni) then
  begin
    ini.Free;
    ini := TIniFile.Create(AlterConfIni);
  end;
  LangID := ini.ReadInteger('EnvironmentOptions', 'LanguageID', GetSystemDefaultLangID);
  UsersDefDir := ini.ReadString('EnvironmentOptions', 'UsersDefDir',
    FalconDir);
  UsersDefDir := ExpandRelativePath(FalconDir, UsersDefDir);
  if not DirectoryExists(UsersDefDir) then
    UsersDefDir := FalconDir;
  LangDir := ini.ReadString('EnvironmentOptions', 'LanguageDir', UsersDefDir + 'Lang\');
  LangDir := ExpandRelativePath(UsersDefDir, LangDir);
  if not DirectoryExists(LangDir) then
    LangDir := UsersDefDir + 'Lang\';
  ini.Free;
  Files := TStringList.Create;
  FindFiles(LangDir + '*.lng', Files);
  Lines := TStringList.Create;
  for I := 0 to Files.Count - 1 do
  begin
    LangFileName := LangDir + Files.Strings[I];
    ini := TMemIniFile.Create('');
    try
      LoadFileEx(LangFileName, Lines);
      TMemIniFile(ini).SetStrings(Lines);
    except
    end;
    FileLangID := ini.ReadInteger('FALCON', 'LangID', 0);
    if FileLangID = LangID then
    begin
      UpdateLang(ini);
      ini.Free;
      Break;
    end;
    ini.Free;
  end;
  Lines.Free;
  Files.Free;
end;

end.
