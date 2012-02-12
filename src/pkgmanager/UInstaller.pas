unit UInstaller;

interface

uses
  Windows, Classes, Forms, BZip2, LibTar, CommCtrl, Consts, ImgList, Controls,
  IniFiles, Dialogs, ShellAPI, CompressUtils, Messages;

const
  CSIDL_PROGRAM_FILES = $0026;
  WM_RELOADFTM = WM_USER + $1008;
  WM_RELOADPKG  = WM_USER + $0112;

type
  TShortCuts = packed record
    Caption: TStringList;
    URL: TStringList;
  end;

  TProgressAction = (paRetry, paSkip, paAbort);

  TPackageType = (pktFalconCpp = 0, pktDevCpp = 1, pktOther = 2);
  TProgressEvent = procedure(Sender: TObject; Position, Size: Int64;
    Finished, Success: Boolean; Msg, FileName: String;
    var Action: TProgressAction) of Object;

  TInstaller = class
  private
    FName: String;
    FLargeName: String;
    FVersion: String;
    FWebSiteCaption: String;
    FWebSite: String;
    FDescription: String;
    FDependencies: String;
    FReadme: String;
    FLicense: String;
    FAbortAlert: Boolean;
    FAborted: Boolean;
    FFinishMsg: String;
    FSkipFileCount: Integer;
    FReboot: Boolean;
    FShowPkgManager: Boolean;
    FLocateUpdate: Boolean;
    FPicture: String;
    FLogo: String;
    FEndLogo: String;
    FPkgType: TPackageType;
    FOverridePackage: Boolean;
    FUseTemplateIcon: Boolean;
    FSilent: Boolean;

    FDestination: TStringList;
    FSource: TStringList;
    FInstalledFiles: TStringList;

    FShortCuts: TShortCuts;
    FTempDir: String;
    FTarFile: String;
    FFalconDir: String;
    FRootFolder: String;
    FIniFile: String;
    FPkgSize: Int64;
    FHandle: THandle;
  public
    constructor Create;
    destructor Destroy; override;
    function Open(FileName: String): Boolean;
    function VerifyDependencies(Dep: String; List: TStrings): Boolean;
    function GetFileSize: Int64;
    function TarFileExist(const FindName: String; OutFile: TStream): Boolean;
    function GetEntryFile(Ini: TMemIniFile): Boolean;
    function LoadConfigFile(PkgType: TPackageType): Boolean;
    function Install(PrgsEvent: TProgressEvent): Boolean;
    procedure SaveEntryFile;
    function Clear: Boolean;
    property Name: String read FName write FName;
    property LargeName: String read FLargeName write FLargeName;
    property Version: String read FVersion write FVersion;
    property WebSiteCaption: String read FWebSiteCaption write FWebSiteCaption;
    property WebSite: String read FWebSite write FWebSite;
    property Description: String read FDescription write FDescription;
    property Readme: String read FReadme write FReadme;
    property License: String read FLicense write FLicense;
    property AbortAlert: Boolean read FAbortAlert write FAbortAlert;
    property Aborted: Boolean read FAborted write FAborted;
    property SkipFileCount: Integer read FSkipFileCount write FSkipFileCount;
    property FinishMsg: String read FFinishMsg write FFinishMsg;
    property Reboot: Boolean read FReboot write FReboot;
    property Silent: Boolean read FSilent write FSilent;
    property ShowPkgManager: Boolean read FShowPkgManager write FShowPkgManager;
    property LocateUpdate: Boolean read FLocateUpdate write FLocateUpdate;
    property Picture: String read FPicture write FPicture;
    property Logo: String read FLogo write FLogo;
    property EndLogo: String read FEndLogo write FEndLogo;
    property OverridePackage: Boolean read FOverridePackage write FOverridePackage;
    property UseTemplateIcon: Boolean read FUseTemplateIcon write FUseTemplateIcon;
    property Dependencies: String read FDependencies;
    property ShortCuts: TShortCuts read FShortCuts;
    property PkgSize: Int64 read FPkgSize write FPkgSize;
    property TarFile: String read FTarFile write FTarFile;
    property Handle: THandle read FHandle write FHandle;
  end;

procedure Execute(S: String);
function GetFalconDir: String;
function FindFiles(Search: String; Finded:TStrings): Boolean;
procedure ConvertTo32BitImageList(const ImageList: TImageList);
function LoadPackageFile(FileName: String; Silent: Boolean = False): Boolean;

implementation

uses UFrmLoad, SysUtils, ShlObj, UFrmWizard;

function LoadPackageFile(FileName: String; Silent: Boolean = False): Boolean;
begin
  Installer := TInstaller.Create;
  Installer.Silent := Silent;
  Result := Installer.Open(FileName);
  if not Result then
    Installer.Free
  else if Silent then
  begin
    Result := Installer.Install(nil);
    Installer.Clear;
    Installer.Free;
  end;
end;

function FindFiles(Search: String; Finded:TStrings): Boolean;
var
  searchResult : TSearchRec;
begin
  Result := false;
  if FindFirst(Search, faAnyFile, searchResult) = 0 then
  begin
    Result := True;
    repeat
        Finded.add(searchResult.Name);
    until FindNext(searchResult) <> 0;
    FindClose(searchResult);
  end;
end;

function GetUserTemp: String;
var
  Buf: PChar;
begin
  Buf := StrAlloc(MAX_PATH);
  GetTempPath(MAX_PATH, Buf);
  Result := StrPas(Buf);
  StrDispose(Buf);
end;

procedure ConvertTo32BitImageList(const ImageList: TImageList);
//CommCtrl, Classes, Consts;
const
  Mask: array[Boolean] of Longint = (0, ILC_MASK);
var
  TemporyImageList: TImageList;
begin
  if Assigned(ImageList) then
  begin
    TemporyImageList := TImageList.Create(nil);
    try
      TemporyImageList.Assign(ImageList);
      with ImageList do
      begin
        ImageList.Handle := ImageList_Create(Width, Height,
          ILC_COLOR32 or Mask[Masked], 0, AllocBy);
        if not ImageList.HandleAllocated then
          raise EInvalidOperation.Create(SInvalidImageList);
      end;
      ImageList.AddImages(TemporyImageList);
    finally
      TemporyImageList.Free;
    end;
  end;
end;

function diretorioVazio(diretorio: string): Boolean;
var
  search_rec: TSearchRec;
  i: Integer;
begin
  Result := False;
  FindFirst(IncludeTrailingPathDelimiter(diretorio) + '*', faAnyFile, search_rec);
  for i := 1 to 2 do
    if (search_rec.Name = '.') or (search_rec.Name = '..') then
      Result := FindNext(search_rec) <> 0;
  FindClose(search_rec);
end;

function GetSpecialFolder(ID: Integer): String;
var
  Buf: PChar;
begin
  Buf := StrAlloc(MAX_PATH);
  SHGetSpecialFolderPath(HInstance, Buf, ID, False);
  Result := StrPas(Buf);
  StrDispose(Buf);
end;

procedure Execute(S: String);
var
  ShellInfo: TShellExecuteInfo;
begin
  if Trim(S) <> '' then
  begin
    FillChar(ShellInfo, SizeOf(TShellExecuteInfo), 0);
    ShellInfo.cbSize := SizeOf(TShellExecuteInfo);
    ShellInfo.fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_NO_UI or
                       SEE_MASK_FLAG_DDEWAIT;
    ShellInfo.Wnd := HWND_DESKTOP;
    ShellInfo.lpVerb := 'Open';
    ShellInfo.lpFile := PChar(S);
    ShellInfo.lpParameters := nil;
    ShellInfo.lpDirectory := nil;
    ShellInfo.nShow := SW_SHOWNORMAL;
    ShellExecuteEx(@ShellInfo);
  end;
end;

function ConvertSlashes(Path: String): String;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
      if Result[i] = '/' then
          Result[i] := '\';
end;

function GetFalconDir: String;
begin
  Result := ExtractFilePath(Application.ExeName);
  if not FileExists(Result + 'Falcon.exe') then
    Result := GetSpecialFolder(CSIDL_PROGRAM_FILES) + '\Falcon\';
end;

function GetSysDir: String;
var
  buffer: array[0..MAX_PATH - 1] of Char;
begin
  GetSystemDirectory(buffer, MAX_PATH);
  Result := StrPas(buffer);
end;

function TInstaller.Clear: Boolean;
begin
  Result := True;
  if FileExists(TarFile) then
    Result := DeleteFile(TarFile);
  if Result then
    Result := RemoveDir(FTempDir);
end;

procedure TInstaller.SaveEntryFile;
var
  ini: TMemIniFile;
  lst: TStrings;
  //I: Integer;
begin
  if not DirectoryExists(FFalconDir + 'Packages\') then
    CreateDir(FFalconDir + 'Packages\');
  lst := TStringList.Create;
  ini := TMemIniFile.Create(FFalconDir + 'Packages\' + Name + '.ini');
  ini.Clear;
  ini.WriteString('Package', 'Name', Name);
  ini.WriteString('Package', 'LargeName', LargeName);
  ini.WriteString('Package', 'Version', FVersion);
  ini.WriteString('Package', 'Description', FDescription);
  ini.WriteString('Package', 'FWebSiteCaption', FWebSiteCaption);
  ini.WriteString('Package', 'WebSite', FWebSite);
  ini.WriteString('Package', 'Dependencies', FDependencies);
  ini.GetStrings(lst);
  lst.Add('[Files]');
  lst.AddStrings(FInstalledFiles);
  ini.SetStrings(lst);
  lst.Free;
  ini.UpdateFile;
  ini.Free;
end;

function ConvertDevTMToFTM(const DevTMPath, Dest: String): Integer;
begin
  Result := 0;
  //ShowMessage(DevTMPath + ' = ' + Dest);
end;

function IsRoot(const Path: String; var S, E: String ;
  const Args: array of string): Boolean;
var
  I: Integer;
  R: String;
begin
  Result := False;
  I := Pos('\', Path);
  if I > 0 then
  begin
    R := Copy(Path,  1, I - 1);
    E := CopY(Path, I, Length(Path));
    for I:= 0 to Pred(Length(Args)) do
      if Args[I] = R then
        Result := True;
  end;
end;

function IsRootFolder(const Folder, Path: String; var OutStr: String): Boolean;
begin
  Result := False;
  if (Pos(Folder, Path) = 1) then
  begin
    OutStr := Copy(Path,  Length(Folder) + 1, Length(Path));
    if Pos('\', OutStr) = 1 then
      OutStr := Copy(OutStr, 2, Length(OutStr));
    Result := True;
  end;
end;

function ExtractBzip2File(const ASource, ADest: String; var Error: String;
  PrgsEvent: TProgressEvent; var Size: Int64): Boolean;
const
  BufferSize = 65536;
var
  Count: Integer;
  Decomp: TBZDecompressionStream;
  Buffer: array[0..BufferSize - 1] of Byte;
  Source, Dest: TStream;
  Action: TProgressAction;
begin
  Result := False;
  try
    Source := TFileStream.Create(ASource, fmOpenRead + fmShareDenyWrite);
  except
    Error := 'Error can' + #39 +'t open file "' + ASource +'".';
    Exit;
  end;

  try
    Dest := TFileStream.Create(ADest, fmCreate);
  except
    Source.Free;
    Error := 'Error can' + #39 +'t create file "' + ADest + '".';
    Exit;
  end;

  Decomp := nil;
  try
    Size := Source.Size;
    Decomp := TBZDecompressionStream.Create(Source);
    while True do
    begin
      Count := Decomp.Read(Buffer, BufferSize);
      if Assigned(PrgsEvent) then
        PrgsEvent(nil, Source.Position, Size, False, True, '', '', Action);
      if Count <> 0 then Dest.WriteBuffer(Buffer, Count) else Break;
    end;
    Decomp.Free;
    Dest.Free;
    Source.Free;
  except
    if Assigned(Decomp) then
      Decomp.Free;
    Dest.Free;
    Source.Free;
    Error := 'Error can' + #39 +'t decompress file "' + ASource + '".';
    if FileExists(ADest) then
      DeleteFile(ADest);
    Exit;
  end;
  Result := True;
end;

constructor TInstaller.Create;
begin
  inherited;
  FRootFolder := '';
  FDestination := TStringList.Create;
  FSource := TStringList.Create;
  FInstalledFiles := TStringList.Create;
  FShortCuts.Caption := TStringList.Create;
  FShortCuts.URL := TStringList.Create;
  FFalconDir := GetFalconDir;
  FFinishMsg := '%s has been installed sucessfull.';
end;

destructor TInstaller.Destroy;
begin
  FShortCuts.Caption.Free;
  FShortCuts.URL.Free;
  FDestination.Free;
  FSource.Free;
  FInstalledFiles.Free;
  inherited;
end;

function TInstaller.Open(FileName: String): Boolean;
var
  I: Integer;
  Error, Ext: String;
  List: TStrings;
begin
  //progress form
  if not Silent then
  begin
    FrmLoad := TFrmLoad.Create(nil);
    FrmLoad.Show;
  end;
  I := 0;
  //creating temp directory
  repeat
    FTempDir := GetUserTemp + 'PkgMng_232' + IntToStr(I) + '\';
    Inc(I);
  until(not DirectoryExists(FTempDir));
  CreateDir(FTempDir);
  FTarFile := FTempDir + ChangeFileExt(ExtractFileName(FileName), '.tar');
  //extract bzip2 file
  if not Silent then
    Result := ExtractBzip2File(FileName, FTarFile, Error, FrmLoad.SetProgress, FPkgSize)
  else
    Result := ExtractBzip2File(FileName, FTarFile, Error, nil, FPkgSize);
  if not Result then
  begin
    if not Silent then
    begin
      FrmLoad.Close;
      FrmLoad.Free;
    end;
    Clear;
    if not Silent then
      MessageBox(0, PChar(Error), 'Falcon C++ Installation Wizard', MB_ICONERROR);
    Exit;
  end;
  Ext := UpperCase(ExtractFileExt(FileName));
  if (Ext = '.FPK') then
    FPkgType := pktFalconCpp
  else if (Ext = '.DEVPAK') then
    FPkgType := pktDevCpp
  else
    FPkgType := pktOther;
  Result := LoadConfigFile(FPkgType);
  if not Result then
  begin
    if not Silent then
    begin
      FrmLoad.Close;
      FrmLoad.Free;
    end;
    Clear;
    if not Silent then
      MessageBox(0, 'Package entry not found!', 'Falcon C++ Installation Wizard', MB_ICONERROR);
    Exit;
  end;
  
  if not Silent then
    FPkgSize := GetFileSize;
  
  if not Silent then
  begin
    FrmLoad.Close;
    FrmLoad.Free;
  end;
  List := TStringList.Create;
  Result := VerifyDependencies(Dependencies, List);
  if not Result then
  begin
    Clear;
    if not Silent then
      MessageBox(0, PChar('Dependencies: '#13 + List.Text),
        'Falcon C++ Installation Wizard', MB_ICONEXCLAMATION);
  end;
  List.Free;
end;

function TInstaller.VerifyDependencies(Dep: String; List: TStrings): Boolean;
var
  Pkgs, NameList, VerList, DepList: TStrings;
  PkgDir, DepItem: String;
  I, J: Integer;
  Finded: Boolean;
  ini: TIniFile;
begin
  Result := True;
  if Length(Trim(Dep)) = 0 then Exit;
  Pkgs := TStringList.Create;
  NameList := TStringList.Create;
  VerList := TStringList.Create;
  DepList := TStringList.Create;
  DepList.Delimiter := ',';
  DepList.CommaText := Dep;
  PkgDir := FFalconDir + 'Packages\';
  FindFiles(PkgDir + '*.ini', Pkgs);
  //loading packages
  for I := 0 to Pred(Pkgs.Count) do
  begin
    ini := TIniFile.Create(PkgDir + Pkgs.Strings[I]);
    NameList.Add(ini.ReadString('Package', 'Name', ''));
    VerList.Add(ini.ReadString('Package', 'Version', ''));
    ini.Free;
  end;
  //checking
  for I := 0 to Pred(DepList.Count) do
  begin
    Finded := False;
    DepItem := UpperCase(Trim(DepList.Strings[I]));
    for J := 0 to Pred(Pkgs.Count) do
    begin
      if (DepItem = UpperCase(NameList.Strings[J])) or
         (DepItem = UpperCase(NameList.Strings[J] + ' ' + VerList.Strings[J]))
      then
      begin
        Finded := True;
        Break;
      end;
    end;
    if not Finded then
      List.Add(DepItem);
  end;
  DepList.Free;
  VerList.Free;
  NameList.Free;
  Pkgs.Free;
  Result := (List.Count = 0);
end;

function TInstaller.TarFileExist(const FindName: String; OutFile: TStream): Boolean;
begin
  Result := FindTarFile(FindName, FTarFile, OutFile);
end;

function TInstaller.GetFileSize: Int64;
var
  TA        : TTarArchive;
  DirRec    : TTarDirRec;
begin
  Result := 0;
  try
    TA := TTarArchive.Create(FTarFile);
    TA.Reset;
    while TA.FindNext(DirRec) do
    begin
      if DirRec.FileType = ftDirectory then Continue;
      Result := Result + DirRec.Size;
    end;
    TA.Free;
  except
    Result := -1;
  end;
end;

function TInstaller.GetEntryFile(Ini: TMemIniFile): Boolean;
const
  EntryExt: array[TPackageType] of String = ('.INI', '.DEVPACKAGE', '.INI');
var
  TA        : TTarArchive;
  DirRec    : TTarDirRec;
  FileName, Ext: String;
  S: TStrings;
  Ms: TMemoryStream;
begin
  Result := False;
  try
    TA := TTarArchive.Create(FTarFile);
    TA.Reset;
    while TA.FindNext(DirRec) do
    begin
      if (DirRec.FileType <> ftDirectory) then
      begin
        FileName := ConvertSlashes(DirRec.Name);
        Ext := ExtractFileExt(FileName);
        if (UpperCase(Ext) = EntryExt[FPkgType]) then
        begin
          Ms := TMemoryStream.Create;
          TA.ReadFile(Ms);
          Ms.Position := 0;
          S := TStringList.Create;
          S.LoadFromStream(Ms);
          Ms.Free;
          Ini.SetStrings(S);
          S.Free;
          TA.Free;
          Result := True;
          FIniFile := FileName;
          FRootFolder := ExtractFilePath(FileName);
          Exit;
        end;
      end;
    end;
    TA.Free;
  finally
  end;
end;

function TInstaller.LoadConfigFile(PkgType: TPackageType): Boolean;
var
  Ini: TMemIniFile;
  Temp, NewDest: String;
  I: Integer;
begin
  Result := False;
  Ini := TMemIniFile.Create('');
  if not GetEntryFile(Ini) then
  begin
    Ini.Free;
    Exit;
  end;
  case PkgType of
    pktFalconCpp, pktOther:
    begin
      FName := ini.ReadString('Package', 'Name', 'Unknown');
      FLargeName := ini.ReadString('Package', 'LargeName', FName);
      FVersion := ini.ReadString('Package', 'Version', '1.0');
      FDescription := ini.ReadString('Package', 'Description', '');
      FWebSiteCaption := ini.ReadString('Package', 'WebsiteCaption', '');
      FWebSite := ini.ReadString('Package', 'Website', '');
      FDependencies := ini.ReadString('Package', 'Dependencies', '');
      FReadme := ini.ReadString('Package', 'Readme', '');
      FLicense := ini.ReadString('Package', 'License', '');
      if (Pos('USE{', UpperCase(FLicense)) = 0) then
        FLicense := FLicense;
      FAbortAlert := ini.ReadBool('Package', 'AbortAlert', False);
      FReboot := ini.ReadBool('Package', 'Reboot', False);
      FShowPkgManager := ini.ReadBool('Package', 'ShowPkgManager', True);
      FLocateUpdate := ini.ReadBool('Package', 'LocateUpdate', False);
      FPicture := ini.ReadString('Package', 'Picture', '');
      FLogo := ini.ReadString('Package', 'Logo', '');
      FEndLogo := ini.ReadString('Package', 'EndLogo', '');
      FOverridePackage := ini.ReadBool('Package', 'OverridePackage', True);
      FUseTemplateIcon := ini.ReadBool('Package', 'UseTemplateIcon', False);
      ini.ReadSection('Files', FSource);
      for I:= 0 to Pred(FSource.Count) do
      begin
        Temp := ini.ReadString('Files', FSource.Strings[I], '');
        Temp := StringReplace(Temp, '$(FALCON)',
          Copy(FFalconDir, 1, Length(FFalconDir) - 1), [rfReplaceAll]);
        FDestination.Add(Temp);
      end;
      //FDestination.Text := StringReplace(FDestination.Text, '$(WINDOWS)',
      //  GetSystemDir, [rfReplaceAll]);
      //FDestination.Text := StringReplace(FDestination.Text, '$(SYSTEM32)',
      //  GetSystem32Dir, [rfReplaceAll]);
      //FDestination.Text := StringReplace(FDestination.Text, '$(DESKTOP)',
      //  GetSpecialFolder(?), [rfReplaceAll]);
    end;
    pktDevCpp:
    begin
      FName := ini.ReadString('Setup', 'MenuName', ini.ReadString('Setup',
        'AppName', 'Unknown'));
      FLargeName := ini.ReadString('Setup', 'AppName', FName);
      FVersion := ini.ReadString('Setup', 'AppVersion', '1.0');
      FDescription := ini.ReadString('Setup', 'Description', '');
      FWebSite := ini.ReadString('Setup', 'Url', '');
      FDependencies := ini.ReadString('Setup', 'Dependencies', '');
      FReadme := ini.ReadString('Setup', 'Readme', '');
      FLicense := ini.ReadString('Setup', 'License', '');
      FReboot := ini.ReadBool('Setup', 'Reboot', False);
      FShowPkgManager := True;
      FLogo := ini.ReadString('Setup', 'Picture', '');
      FOverridePackage := True;
      ini.ReadSection('Files', FSource);
      for I:= 0 to Pred(FSource.Count) do
      begin
        Temp := ini.ReadString('Files', FSource.Strings[I], '');
        NewDest := Temp;
        Temp := LowerCase(Temp);
        FSource.Strings[I] := FRootFolder + FSource.Strings[I];
        if (Pos('<app>\doc', Temp) > 0) then
          Temp := StringReplace(Temp, '<app>\doc', '<app>\Help', [])
        else if (Pos('<app>\docs', Temp) > 0) then
          Temp := StringReplace(Temp, '<app>\docs', '<app>\Help', [])
        else if (Pos('<app>\helps', Temp) > 0) then
          Temp := StringReplace(Temp, '<app>\helps', '<app>\Help', [])
        else if (Pos('<app>\bin', Temp) > 0) then
          Temp := StringReplace(Temp, '<app>\bin', '<app>\MinGW\bin', [])
        else if (Pos('<app>\include', Temp) > 0) then
          Temp := StringReplace(Temp, '<app>\include', '<app>\MinGW\include', [])
        else if (Pos('<app>\lib', Temp) > 0) then
          Temp := StringReplace(Temp, '<app>\lib', '<app>\MinGW\lib', []);
        Temp := StringReplace(Temp, '<app>', Copy(FFalconDir, 1, Length(FFalconDir) - 1), []);
        Temp := StringReplace(Temp, '<sys>', GetSysDir, []);
        FDestination.Add(Temp);
      end;
      //FDestination.Text := StringReplace(FDestination.Text, '$(WINDOWS)',
      //  GetSystemDir, [rfReplaceAll]);
      //FDestination.Text := StringReplace(FDestination.Text, '$(SYSTEM32)',
      //  GetSystem32Dir, [rfReplaceAll]);
      //FDestination.Text := StringReplace(FDestination.Text, '$(DESKTOP)',
      //  GetSpecialFolder(?), [rfReplaceAll]);
    end;
  end;
  Ini.Free;
  Result := True;
end;

function TInstaller.Install(PrgsEvent: TProgressEvent): Boolean;
var
  TA        : TTarArchive;
  DirRec    : TTarDirRec;
  Curr, Size : Int64;
  FileName, Rs, Ps, ConfigRoot, Tmp: String;
  I, Overrided, PkgIni: Integer;
  ExtractedFile: TFileStream;
  ini: TIniFile;
  FalconHandle, PkgHandle: THandle;
  Action: TProgressAction;
  dir_created, file_created: Boolean;
begin
  Result := False;
  FAborted := False;
  FSkipFileCount := 0;
  try
    TA := TTarArchive.Create(FTarFile);
    TA.Reset;
    Overrided := 0;
    while TA.FindNext(DirRec) do
    begin
      FileName := ConvertSlashes(DirRec.Name);
      for I := 0 to Pred(FSource.Count) do
      begin
        TA.GetFilePos(Curr, Size);
        if FIniFile = FileName then Break;
        if IsRootFolder(FSource.Strings[I], FileName, FileName) then
        begin
          if Length(FileName) = 0 then Continue;
          if IsRoot(FileName, Rs, Ps, ['bin', 'include', 'lib']) then
          begin
            Tmp := ExcludeTrailingPathDelimiter(FDestination.Strings[I]);
            Tmp := ExtractFileName(Tmp);
            if CompareText(Tmp, 'MinGW') <> 0 then
              FileName := 'MinGW\' + FileName;
          end
          else if IsRoot(FileName, Rs, Ps, ['helps', 'doc', 'docs']) then
          begin
            Tmp := ExcludeTrailingPathDelimiter(FDestination.Strings[I]);
            Tmp := ExtractFileName(Tmp);
            if CompareText(Tmp, 'Help') <> 0 then
              FileName := 'Help' + Ps;
          end;
          FileName := FDestination.Strings[I] + FileName;
          if (DirRec.FileType = ftDirectory) then
          begin
            repeat
              dir_created := ForceDirectories(FileName);
              if dir_created then
              begin
                if Assigned(PrgsEvent) then
                  PrgsEvent(Self, Curr, Size, False, True,
                    'Creating directory:', FileName, Action);
              end
              else
              begin
                if Assigned(PrgsEvent) then
                begin
                  Action := paSkip;
                  PrgsEvent(Self, Curr, Size, False, False,
                    'Error creating directory:', FileName, Action);
                  case Action of
                    paRetry:;
                    paSkip:
                    begin
                      dir_created := True;
                      Inc(FSkipFileCount);
                      if FSkipFileCount = 1 then
                        FFinishMsg := '%s has been installed with errors'#10 +
                          ' folder ''' + FileName + ''' couldn''t be created.'
                      else
                        FFinishMsg := '%s has been installed with errors'#10 +
                          IntToStr(FSkipFileCount) + ' couldn''t be installed.';
                    end;
                    paAbort:
                    begin
                      FFinishMsg := 'Installation of %s has been aborted:'#10 +
                        'Error couldn''t create directory: ' +  FileName + '.';
                      FAborted := True;
                      Break;
                    end;
                  end;
                end
                else
                  dir_created := True;
              end;
            until dir_created;
            Break;
          end;
          if not DirectoryExists(ExtractFilePath(FileName)) then
            ForceDirectories(ExtractFilePath(FileName));
          if FileExists(FileName) then
            Inc(Overrided);
          repeat
            try
              ExtractedFile := TFileStream.Create(FileName, fmCreate);
              TA.ReadFile(ExtractedFile);
              ExtractedFile.Free;
              if Assigned(PrgsEvent) then
                PrgsEvent(Self, Curr, Size, False, True, '', FileName, Action);
              FInstalledFiles.Add(StringReplace(FileName, FFalconDir, '', []));
              file_created := True;
            except
              if Assigned(PrgsEvent) then
              begin
                file_created := False;
                Action := paSkip;
                PrgsEvent(Self, Curr, Size, False, False,
                  'Error opening file for writing:', FileName, Action);
                case Action of
                  paRetry:;
                  paSkip:
                  begin
                    file_created := True;
                    Inc(FSkipFileCount);
                    if FSkipFileCount = 1 then
                      FFinishMsg := '%s has been installed with errors'#10 +
                        ' file ''' + FileName + ''' couldn''t be installed.'
                    else
                      FFinishMsg := '%s has been installed with errors'#10 +
                        IntToStr(FSkipFileCount) + ' couldn''t be installed.';
                  end;
                  paAbort:
                  begin
                    FFinishMsg := 'Installation of %s has been aborted:'#10 +
                        'Error couldn''t open file ''' +  FileName +
                        ''' for writing.';
                    FAborted := True;
                    Break;
                  end;
                end;
              end
              else
                file_created := True;
            end;
          until file_created;
          TA.GetFilePos(Curr, Size);
        end;
      end;
      if FAborted then
        Break;
    end;
    TA.Free;
  except
    Clear;
    if Assigned(PrgsEvent) then
      PrgsEvent(Self, Curr, Size, True, False, 'Error opening temp file:',
        FTarFile, Action);
    Exit;
  end;
  if Assigned(PrgsEvent) then
    PrgsEvent(Self, Curr, Size, False, True, 'Removing temp files...',
      FTarFile, Action);
  Clear;
  SaveEntryFile;
  if Assigned(PrgsEvent) then
    PrgsEvent(Self, Curr, Size, True, not FAborted, '', '', Action);

  ConfigRoot := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA))
                     + 'Falcon\';
  ini := TIniFile.Create(ConfigRoot + 'Config.ini');
  PkgIni := ini.ReadInteger('Packages', 'NewInstalled', 0);
  if PkgIni < 0 then PkgIni := 0;
  ini.WriteInteger('Packages', 'NewInstalled', PkgIni + 1);
  ini.Free;

  //reload all falcon templates
  FalconHandle := FindWindow('TFrmFalconMain', nil);
  if FalconHandle <> 0 then
    PostMessage(FalconHandle, WM_RELOADFTM, 0, 0);
  //reload all falcon packages
  PkgHandle := FindWindow('TFrmPkgMan', nil);
  if PkgHandle <> 0 then
    PostMessage(PkgHandle, WM_RELOADPKG, 0, 0);
  Result := not FAborted;
end;

end.
