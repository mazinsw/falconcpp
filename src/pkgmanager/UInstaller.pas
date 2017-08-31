unit UInstaller;

interface

uses
  Windows, Classes, Forms, Compress.BZip2, LibTar, Consts,
  IniFiles, Dialogs, CompressUtils, Messages, PkgUtils;

const
  WM_RELOADFTM = WM_USER + $1008;
  WM_RELOADPKG  = WM_USER + $0112;
  WM_REPARSEFILES = WM_RELOADFTM + 1;
  
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
    FVersion: String;
    FWebSiteCaption: String;
    FParentWindow: HWND;
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
    FReparse: Boolean;

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
    //FHandle: THandle;
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
    property Reparse: Boolean read FReparse write FReparse;
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
    property ParentWindow: HWND read FParentWindow write FParentWindow;
  end;

function LoadPackageFile(ParentWindow: HWND; FileName: String; Silent: Boolean = False;
  Reparse: Boolean = True): Boolean;

implementation

uses UFrmLoad, SysUtils, UFrmWizard, ShlObj, Controls, ULanguages, SystemUtils,
  AppConst;

function LoadPackageFile(ParentWindow: HWND; FileName: String; Silent, Reparse: Boolean): Boolean;
begin
  Installer := TInstaller.Create;
  Installer.ParentWindow := ParentWindow;
  Installer.Reparse := Reparse;
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
  ini.WriteString('Package', 'Version', FVersion);
  ini.WriteString('Package', 'Description', FDescription);
  ini.WriteString('Package', 'WebSiteCaption', FWebSiteCaption);
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
    Error := Format(STR_FRM_WIZARD[11], [ASource]);
    Exit;
  end;

  try
    Dest := TFileStream.Create(ADest, fmCreate);
  except
    Source.Free;
    Error := Format(STR_FRM_WIZARD[12], [ADest]);
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
    Error := Format(STR_FRM_WIZARD[13], [ASource]);
    if FileExists(ADest) then
      DeleteFile(ADest);
    Exit;
  end;
  Result := True;
end;

constructor TInstaller.Create;
begin
  inherited;
  FReparse := True; 
  FRootFolder := '';
  FDestination := TStringList.Create;
  FSource := TStringList.Create;
  FInstalledFiles := TStringList.Create;
  FShortCuts.Caption := TStringList.Create;
  FShortCuts.URL := TStringList.Create;
  FFalconDir := GetFalconDir;
  FFinishMsg := STR_FRM_WIZARD[14];
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
    FrmLoad := TFrmLoad.CreateParented(ParentWindow);
    FrmLoad.Show;
  end;
  I := 0;
  //creating temp directory
  repeat
    FTempDir := GetTempDirectory + 'PkgMng_232' + IntToStr(I) + '\';
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
      MessageBox(ParentWindow, PChar(Error), PChar(STR_FRM_WIZARD[9]), MB_ICONERROR);
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
      MessageBox(ParentWindow, PChar(STR_FRM_WIZARD[15]),
        PChar(STR_FRM_WIZARD[9]), MB_ICONERROR);
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
      MessageBox(ParentWindow, PChar(STR_FRM_WIZARD[16] + ' '#13 + List.Text),
        PChar(STR_FRM_WIZARD[9]), MB_ICONEXCLAMATION);
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
        FileName := ConvertSlashes(string(DirRec.Name));
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
  except
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
  I, PkgIni: Integer;
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
    while TA.FindNext(DirRec) do
    begin
      FileName := ConvertSlashes(string(DirRec.Name));
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
                    STR_FRM_WIZARD[17], FileName, Action);
              end
              else
              begin
                if Assigned(PrgsEvent) then
                begin
                  Action := paSkip;
                  PrgsEvent(Self, Curr, Size, False, False,
                    STR_FRM_WIZARD[18], FileName, Action);
                  case Action of
                    paRetry:;
                    paSkip:
                    begin
                      dir_created := True;
                      Inc(FSkipFileCount);
                      if FSkipFileCount = 1 then
                        FFinishMsg := Format(StringReplace(STR_FRM_WIZARD[19],
                          '\n', #10, [rfReplaceAll]), ['%s', FileName])
                      else
                        FFinishMsg := Format(StringReplace(STR_FRM_WIZARD[20],
                          '\n', #10, [rfReplaceAll]), ['%s', FSkipFileCount]);
                    end;
                    paAbort:
                    begin
                      FFinishMsg := Format(StringReplace(STR_FRM_WIZARD[21],
                        '\n', #10, [rfReplaceAll]), ['%s', FileName]);
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
                PrgsEvent(Self, Curr, Size, False, False, STR_FRM_WIZARD[22],
                  FileName, Action);
                case Action of
                  paRetry:;
                  paSkip:
                  begin
                    file_created := True;
                    Inc(FSkipFileCount);
                    if FSkipFileCount = 1 then
                      FFinishMsg := Format(StringReplace(STR_FRM_WIZARD[23],
                          '\n', #10, [rfReplaceAll]), ['%s', FileName])
                    else
                      FFinishMsg := Format(StringReplace(STR_FRM_WIZARD[20],
                          '\n', #10, [rfReplaceAll]), ['%s', FSkipFileCount]);
                  end;
                  paAbort:
                  begin
                    FFinishMsg := Format(StringReplace(STR_FRM_WIZARD[24],
                          '\n', #10, [rfReplaceAll]), ['%s', FileName]);
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
      PrgsEvent(Self, Curr, Size, True, False, STR_FRM_WIZARD[25],
        FTarFile, Action);
    Exit;
  end;
  if Assigned(PrgsEvent) then
    PrgsEvent(Self, Curr, Size, False, True, STR_FRM_WIZARD[26],
      FTarFile, Action);
  Clear;
  SaveEntryFile;
  if Assigned(PrgsEvent) then
    PrgsEvent(Self, Curr, Size, True, not FAborted, '', '', Action);

  ConfigRoot := GetConfigDir(FFalconDir);
  ini := TIniFile.Create(ConfigRoot + CONFIG_NAME);
  PkgIni := ini.ReadInteger('Packages', 'NewInstalled', 0);
  if PkgIni < 0 then PkgIni := 0;
  ini.WriteInteger('Packages', 'NewInstalled', PkgIni + 1);
  ini.Free;

  //reload all falcon templates
  FalconHandle := FindWindow('TFrmFalconMain', nil);
  if FalconHandle <> 0 then
    PostMessage(FalconHandle, WM_RELOADFTM, 0, 0);
  //reparse all installed header files
  if (FalconHandle <> 0) and Reparse then
    PostMessage(FalconHandle, WM_REPARSEFILES, 0, 0);
  //reload all falcon packages
  PkgHandle := FindWindow('TFrmPkgMan', nil);
  if PkgHandle <> 0 then
    PostMessage(PkgHandle, WM_RELOADPKG, 0, 0);
  Result := not FAborted;
end;

end.
