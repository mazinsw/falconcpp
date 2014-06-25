unit UUninstaller;

interface

uses
  Windows, Messages, Classes, Controls, IniFiles, UFrmUninstall, UInstaller;

const
    WM_RELOADPKG  = WM_USER + $0112;

type
  TUninstaller = class
  private
    FInstalledFiles: TStrings;
    FIniFileName: String;
    FPackageName: String;
    FFalconDir: String;
    FSilent: Boolean;
    FUnDeletedFiles: Integer;
    FVersion: String;
    function GetPackageInfo(const PkgName: String;
      var FileName, Version: String; FileList, PkgDepends: TStrings): Boolean;
    procedure FormUninstallShow(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function Uninstall(const PkgName: String; Parent: HWND;
      Silent: Boolean = False): Boolean;
    property PackageName: String read FPackageName write FPackageName;
    property Version: String read FVersion write FVersion;
  end;

  TThreadUninstall = class(TThread)
  private
    FList: TStrings;
    FMsg: String;
    FFileName: String;
    FFalconDir: String;
    FFinished: Boolean;
    FTotal: Integer;
    FSuccess: Boolean;
    FAction: TProgressAction;
    FPosition: Integer;
    FOnProgress: TProgressEvent;
    procedure DoProgress;
  protected
    procedure Execute; override;
  public
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    constructor Create;
    destructor Destroy; override;
    procedure StartUninstall(ListFiles: TStrings; FalconDir: String);
  end;

function UninstallPackage(const PkgName: String; Parent: HWND;
  Silent: Boolean = False): Boolean;

implementation

uses SysUtils, StrMatch, PkgUtils, ULanguages, SystemUtils;

function UninstallPackage(const PkgName: String; Parent: HWND;
  Silent: Boolean = False): Boolean;
var
  Uninstaller: TUninstaller;
begin
  Uninstaller := TUninstaller.Create;
  Uninstaller.FSilent := Silent;
  Result := Uninstaller.Uninstall(PkgName, Parent, Silent);
  Uninstaller.Free;
end;

{TThreadUninstall}
procedure TThreadUninstall.DoProgress;
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FPosition, FTotal, FFinished, FSuccess, FMsg,
      FFileName, FAction);
end;

constructor TThreadUninstall.Create;
begin
  inherited Create(True);
  FList := TStringList.Create;
  FreeOnTerminate := True;
end;

destructor TThreadUninstall.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TThreadUninstall.Execute;
var
  I: Integer;
  FilePath, NewFilePath, CurrentFolder: String;
begin
  FilePath := '';
  NewFilePath := '';
  for I := 0 to FList.Count - 1 do
  begin
    FMsg := FList.Strings[I];
    FFileName := FList.Strings[I];
    FPosition := I;
    Synchronize(DoProgress);
    DeleteFile(FList.Strings[I]);
    NewFilePath := ExtractFilePath(FList.Strings[I]);
    if FilePath <> NewFilePath then
    begin
      repeat
        CurrentFolder := ExtractRelativePath(FFalconDir, FilePath);
        CurrentFolder := ExcludeTrailingPathDelimiter(CurrentFolder);
        if not StringIn(CurrentFolder, ['Help', 'MinGW', 'Packages', 'Examples',
          'Templates', 'MinGW\bin', 'MinGW\include', 'MinGW\lib']) then
        begin
          if not RemoveDir(FilePath) then Break;
        end
        else
          Break;
        FilePath := ExcludeTrailingPathDelimiter(FilePath);
        FilePath := ExtractFilePath(FilePath);
      until False;
      FilePath := NewFilePath;
    end;
  end;
  repeat
    CurrentFolder := ExtractRelativePath(FFalconDir, NewFilePath);
    CurrentFolder := ExcludeTrailingPathDelimiter(CurrentFolder);
    if not StringIn(CurrentFolder, ['Help', 'MinGW', 'Packages', 'Templates',
      'Examples', 'MinGW\bin', 'MinGW\include', 'MinGW\lib']) then
    begin
      if not RemoveDir(NewFilePath) then Break;
    end
    else
      Break;
    NewFilePath := ExcludeTrailingPathDelimiter(NewFilePath);
    NewFilePath := ExtractFilePath(NewFilePath);
  until False;
  FFinished := True;
  FMsg := STR_FRM_UNINSTALL[3];
  Inc(FPosition);
  Synchronize(DoProgress);
end;

procedure TThreadUninstall.StartUninstall(ListFiles: TStrings;
  FalconDir: String);
begin
  FList.Assign(ListFiles);
  FFalconDir := FalconDir;
  FPosition := 0;
  FTotal := ListFiles.Count;
  FFinished := False;
  Start;
end;

{TUninstaller}
function TUninstaller.GetPackageInfo(const PkgName: String;
  var FileName, Version: String; FileList, PkgDepends: TStrings): Boolean;
var
  Files, PkgItemDepends: TStrings;
  Name, PkgDir, DriverLetter: String;
  I, J, Index: Integer;
  ini: TMemIniFile;
begin
  Result := False;
  Files := TStringList.Create;
  FFalconDir := GetFalconDir;
  PkgDir := FFalconDir + 'Packages\';
  FindFiles(PkgDir + '*.ini', Files);
  PkgItemDepends := TStringList.Create;
  Index := -1;
  //get depends packages
  for I := 0 to Pred(Files.Count) do
  begin
    ini := TMemIniFile.Create(PkgDir + Files.Strings[I]);
    Name := ini.ReadString('Package', 'Name', '');
    if CompareText(Name, PkgName) = 0 then
    begin
      Index := I;
      FileName := PkgDir + Files.Strings[I];
      Version := ini.ReadString('Package', 'Version', '');
      ini.ReadSectionValues('Files', FileList);
      ini.Free;
      for J := 0 to FileList.Count - 1 do
      begin
        DriverLetter := ExtractFileDrive(FileList.Strings[J]);
        if Length(DriverLetter) = 0 then
          FileList.Strings[J] := FFalconDir + FileList.Strings[J];
      end;
      Continue;
    end;
    PkgItemDepends.CommaText := ini.ReadString('Package', 'Dependencies', '');
    for J := 0 to PkgItemDepends.Count - 1 do
    begin
      if CompareText(PkgName, PkgItemDepends.Strings[J]) = 0 then
      begin
        PkgDepends.Add(Name);
        Break;
      end;
    end;
    ini.Free;
  end;
  PkgItemDepends.Free;
  Files.Free;
  if Index < 0 then Exit;
  Result := True;
end;

constructor TUninstaller.Create;
begin
  inherited Create;
  FInstalledFiles := TStringList.Create;
end;

destructor TUninstaller.Destroy;
begin
  FInstalledFiles.Free;
  inherited Destroy;
end;

procedure TUninstaller.FormUninstallShow(Sender: TObject);
var
  ThreadUninstall: TThreadUninstall;
begin
  ThreadUninstall := TThreadUninstall.Create;
  ThreadUninstall.OnProgress := FrmUninstall.Progress;
  ThreadUninstall.StartUninstall(FInstalledFiles, FFalconDir);
end;

function TUninstaller.Uninstall(const PkgName: String; Parent: HWND;
  Silent: Boolean = False): Boolean;
var
  PkgDepends: TStrings;
  I: Integer;
  FilePath, NewFilePath, CurrentFolder: String;
  FalconHandle, PkgHandle: THandle;
begin
  Result := False;
  FUnDeletedFiles := 0;
  if not Silent then
  begin
    FrmUninstall := TFrmUninstall.CreateParented(Parent);
    //FrmUninstall.ParentWindow := Parent;
    FrmUninstall.OnShow := FormUninstallShow;
  end;
  PkgDepends := TStringList.Create;
  if not GetPackageInfo(PkgName, FIniFileName, FVersion, FInstalledFiles,
    PkgDepends) then
  begin
    if not Silent then
      MessageBox(Parent, PChar(Format(STR_FRM_UNINSTALL[4], [PkgName])), PChar(STR_FRM_PKG_MAN[1]), MB_ICONERROR);
    PkgDepends.Free;
    Exit;
  end;
  //others packages depends this
  if PkgDepends.Count > 0 then
  begin
    if not Silent then
      MessageBox(Parent, PChar(STR_FRM_UNINSTALL[5] + ' '#10 + PkgDepends.Text),
        PChar(STR_FRM_PKG_MAN[1]), MB_ICONWARNING);
    PkgDepends.Free;
    Exit;
  end;

  FilePath := '';
  NewFilePath := '';
  CurrentFolder := '';
  FInstalledFiles.Add(FIniFileName);
  if not Silent then
  begin
    FrmUninstall.LblName.Caption := PkgName;
    FrmUninstall.LblVer.Caption := FVersion;
    FrmUninstall.ShowModal;
  end
  else
  begin
    for I := 0 to FInstalledFiles.Count - 1 do
    begin
      if not DeleteFile(FInstalledFiles.Strings[I]) then Inc(FUnDeletedFiles);
      NewFilePath := ExtractFilePath(FInstalledFiles.Strings[I]);
      if FilePath <> NewFilePath then
      begin
        repeat
          CurrentFolder := ExtractRelativePath(FFalconDir, FilePath);
          CurrentFolder := ExcludeTrailingPathDelimiter(CurrentFolder);
          if not StringIn(CurrentFolder, ['Help', 'MinGW', 'Packages', 'Examples',
            'Templates', 'MinGW\bin', 'MinGW\include', 'MinGW\lib']) then
          begin
            if not RemoveDir(FilePath) then Break;
          end
          else
            Break;
          FilePath := ExcludeTrailingPathDelimiter(FilePath);
          FilePath := ExtractFilePath(FilePath);
        until False;
        FilePath := NewFilePath;
      end;
    end;
    repeat
      CurrentFolder := ExtractRelativePath(FFalconDir, NewFilePath);
      CurrentFolder := ExcludeTrailingPathDelimiter(CurrentFolder);
      if not StringIn(CurrentFolder, ['Help', 'MinGW', 'Packages', 'Templates',
        'Examples', 'MinGW\bin', 'MinGW\include', 'MinGW\lib']) then
      begin
        if not RemoveDir(NewFilePath) then Break;
      end
      else
        Break;
      NewFilePath := ExcludeTrailingPathDelimiter(NewFilePath);
      NewFilePath := ExtractFilePath(NewFilePath);
    until False;
    //reload all falcon templates
    FalconHandle := FindWindow('TFrmFalconMain', nil);
    if FalconHandle <> 0 then
      PostMessage(FalconHandle, WM_RELOADFTM, 0, 0);
    //reload all falcon packages
    PkgHandle := FindWindow('TFrmPkgMan', nil);
    if PkgHandle <> 0 then
      PostMessage(PkgHandle, WM_RELOADPKG, 0, 0);
  end;
  PkgDepends.Free;
  Result := True;
end;

end.
