unit SystemUtils;

interface

{$I Falcon.inc}

uses
  Windows, Classes, ShlObj, ShellAPI, ImgList;

const
  CSIDL_PROGRAM_FILES = $0026;
  CSIDL_COMMON_APPDATA = $0023;


type
  TExecuteFileOption = (
    eoHide,
    eoWait,
    eoElevate
    );
  TExecuteFileOptions = set of TExecuteFileOption;

  TVersion = packed record
    Major: Word;
    Minor: Word;
    Release: Word;
    Build: Word;
  end;

function FindFiles(const Search: string; Finded: TStrings): Boolean; overload;
function FindFiles(const PathName, FileName: string; List: TStrings): Boolean; overload;
procedure ListDir(Dir, Regex: string; List: TStrings; IncludeSubDir: Boolean = False);
function GetSpecialFolderPath(nFolder: Integer = CSIDL_PERSONAL): String;
function GetTempDirectory: String;
function GetSysDir: String;
function ExpandRelativePath(const Base, Path: string): string;
function ExpandRelativeFileName(const Base, FileName: string): string;
function ExtractRelativePathOpt(const BaseName, DestName: string): string;
function GetLanguageName(LangID: Word): string;
function EmptyDirectory(const Dir: string): Boolean;
function ConvertSlashes(const Path: String): String;
function ConvertToUnixSlashes(const Path: string): string;
function OpenFolderAndSelectFile(const FileName: string): boolean;
function ExecuteFile(Handle: HWND; const Filename, Paramaters,
  Directory: string; Options: TExecuteFileOptions): Integer;
procedure Execute(const S: String);
function UserIsAdmin: Boolean;
function IsNT: Boolean;
function IsPortable: Boolean;
function IsForeground(Handle: HWND): Boolean;
function ForceForegroundWindow(hwnd: THandle): Boolean;
function BringUpApp(const ClassName: string): Boolean;
function GetFileVersionA(const FileName: string): TVersion;
function ParseVersion(const Version: string): TVersion;
function CompareVersion(Ver1, Ver2: TVersion): Integer;
function VersionToStr(Version: TVersion; const Separator: string = '.'): string;
function GetIconIndex(const FileName: string; ImageList: TCustomImageList;
  Size: Integer = SHGFI_LARGEICON): Integer;


{$EXTERNALSYM SwitchToThisWindow}
procedure SwitchToThisWindow(hWnd: HWND; fAltTab: BOOL); stdcall;


{$IFDEF UNICODE}
{$EXTERNALSYM ILCreateFromPath}
function ILCreateFromPath(pszPath: PChar): PItemIDList stdcall; external shell32
  name 'ILCreateFromPathW';
{$ELSE}
{$EXTERNALSYM ILCreateFromPath}
function ILCreateFromPath(pszPath: PChar): PItemIDList stdcall; external shell32
  name 'ILCreateFromPathA';
{$ENDIF}

procedure SwitchToThisWindow; external user32 name 'SwitchToThisWindow';
procedure ILFree(pidl: PItemIDList) stdcall; external shell32;
function SHOpenFolderAndSelectItems(pidlFolder: PItemIDList; cidl: Cardinal;
  apidl: pointer; dwFlags: DWORD): HRESULT; stdcall; external shell32;

implementation

uses
  Forms, CommCtrl, Controls, SysUtils, Registry,
  RegularExpressionsCore, Graphics;

function FindFiles(const Search: string; Finded: TStrings): Boolean;
var
  searchResult: TSearchRec;
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

function FindFiles(const PathName, FileName: string; List: TStrings): Boolean;
var
  SearchRec: TSearchRec;
  Path: string;
begin
  Result := False;
  Path := IncludeTrailingPathDelimiter(PathName);
  if FindFirst(Path + FileName, faAnyFile - faDirectory, SearchRec) = 0 then
  begin
    repeat
      Result := True;
      List.add(Path + SearchRec.Name);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
  if FindFirst(Path + '*', faDirectory, SearchRec) = 0 then
  begin
    repeat
      if ((SearchRec.Attr and faDirectory) <> 0) and
        (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then
      begin
        Result := FindFiles(Path + SearchRec.Name, FileName, List) or Result;
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

function EmptyDirectory(const Dir: string): Boolean;
var
  F: TSearchRec;
  i: Integer;
begin
  Result := False;
  FindFirst(IncludeTrailingPathDelimiter(Dir) + '*', faAnyFile, F);
  for i := 1 to 2 do
    if (F.Name = '.') or (F.Name = '..') then
      Result := FindNext(F) <> 0;
  FindClose(F);
end;

function GetSpecialFolderPath(nFolder: Integer): string;
var
  Buf: PChar;
begin
  Result := '';
  Buf := StrAlloc(MAX_PATH);
  SHGetSpecialFolderPath(HInstance, Buf, nFolder, False);
  Result := StrPas(Buf);
  StrDispose(Buf);
  if Result <> '' then
    Result := IncludeTrailingPathDelimiter(Result);
end;

function GetTempDirectory: String;
var
  Buf: PChar;
begin
  Buf := StrAlloc(MAX_PATH);
  GetTempPath(MAX_PATH, Buf);
  Result := IncludeTrailingPathDelimiter(StrPas(Buf));
  StrDispose(Buf);
end;

function GetSysDir: String;
var
  buffer: array[0..MAX_PATH - 1] of Char;
begin
  GetSystemDirectory(buffer, MAX_PATH);
  Result := StrPas(buffer);
end;

function ExpandRelativePath(const Base, Path: string): string;
begin
  if IsPortable then
  begin
    if (ExtractFileDrive(Path) = '') and DirectoryExists(Base + Path) then
      Result := ExpandFileName(Base + Path)
    else
      Result := ExpandFileName(ExtractRelativePath(Base, Path));
  end
  else
    Result := Path;
end;

function ExpandRelativeFileName(const Base, FileName: string): string;
begin
  if FileName = '' then
    Result := ''
  else if IsPortable then
    Result := ExpandRelativePath(base, ExtractFilePath(FileName)) + ExtractFileName(FileName)
  else
    Result := FileName;
end;

function ExtractRelativePathOpt(const BaseName, DestName: string): string;
begin
  if IsPortable then
    Result := ExtractRelativePath(BaseName, DestName)
  else
    Result := DestName;
end;

function ConvertSlashes(const Path: String): String;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
      if Result[i] = '/' then
          Result[i] := '\';
end;

function ConvertToUnixSlashes(const Path: string): string;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
    if Result[i] = '\' then
      Result[i] := '/';
end;

function OpenFolderAndSelectFile(const FileName: string): boolean;
var
  IIDL: PItemIDList;
begin
  result := false;
  IIDL := ILCreateFromPath(PChar(FileName));
  if IIDL <> nil then
    try
      result := SHOpenFolderAndSelectItems(IIDL, 0, nil, 0) = S_OK;
    finally
      ILFree(IIDL);
    end;
end;

procedure Execute(const S: String);
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

function UserIsAdmin: Boolean;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
  (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
  end;
  if bSuccess then
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
      ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
{$R-}
      for x := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
{$R+}
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then
    ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then
    Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

function GetLanguageName(LangID: Word): string;
var
  Name: array[0..255] of char;
begin
  if (LangID = 0) then
    VerLanguageName(GetSystemDefaultLangID, Name, 255)
  else
    VerLanguageName(LangID, Name, 255);
  Result := Name;
end;

function IsNT: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
end;

function IsUACActive: Boolean;
var
  Reg: TRegistry;
begin
  Result := FALSE;

  // There's a chance it's active as we're on Vista or Windows 7. Now check the registry
  if CheckWin32Version(6, 0) then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;

      if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System') then
      begin
        if (Reg.ValueExists('EnableLUA')) and (Reg.ReadBool('EnableLUA')) then
          Result := TRUE;
      end;
    finally
      Reg.Free;
    end;
  end;
end;

function ExecuteFile(Handle: HWND; const Filename, Paramaters,
  Directory: string; Options: TExecuteFileOptions): Integer;
var
  ShellExecuteInfo: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  Result := -1;

  ZeroMemory(@ShellExecuteInfo, SizeOf(ShellExecuteInfo));
  ShellExecuteInfo.cbSize := SizeOf(TShellExecuteInfo);
  ShellExecuteInfo.Wnd := Handle;
  ShellExecuteInfo.fMask := SEE_MASK_NOCLOSEPROCESS;

  if (eoElevate in Options) and (IsUACActive) then
    ShellExecuteInfo.lpVerb := PChar('runas');

  ShellExecuteInfo.lpFile := PChar(Filename);

  if Paramaters <> '' then
    ShellExecuteInfo.lpParameters := PChar(Paramaters);

  if Directory <> '' then
    ShellExecuteInfo.lpDirectory := PChar(Directory);

  // Show or hide the window
  if eoHide in Options then
    ShellExecuteInfo.nShow := SW_HIDE
  else
    ShellExecuteInfo.nShow := SW_SHOWNORMAL;

  if ShellExecuteEx(@ShellExecuteInfo) then
    Result := 0;

  if (Result = 0) and (eoWait in Options) then
  begin
    GetExitCodeProcess(ShellExecuteInfo.hProcess, ExitCode);

    while (ExitCode = STILL_ACTIVE) and
      (not Application.Terminated) do
    begin
      sleep(50);

      GetExitCodeProcess(ShellExecuteInfo.hProcess, ExitCode);
    end;

    Result := ExitCode;
  end;
end;

function IsPortable: Boolean;
begin
  Result := FileExists(ChangeFileExt(Application.ExeName, '.portable.txt'));
end;

function IsForeground(Handle: HWND): Boolean;
begin
  Result := GetForegroundWindow = Handle;
end;

function BringUpApp(const ClassName: string): Boolean;
var
  Handle, AppHandle: HWND;
begin
  Result := False;
  AppHandle := FindWindow(PChar(ClassName), nil);
  if AppHandle <> 0 then
  begin
    Handle := GetWindowLong(AppHandle, GWL_HWNDPARENT);
    ForceForegroundWindow(AppHandle);
    if IsIconic(Handle) then
      ShowWindow(Handle, SW_RESTORE);
    Result := True;
  end;
end;

procedure ListDir(Dir, Regex: string; List: TStrings; IncludeSubDir: Boolean);
var
  F: TSearchRec;
  NormalDir: string;
begin
  NormalDir := IncludeTrailingPathDelimiter(Dir);
  if FindFirst(NormalDir + Regex, faAnyFile, F) = 0 then
  begin
    repeat
      if (F.Attr and faDirectory) = 0 then
        List.Add(NormalDir + F.Name);
    until FindNext(F) <> 0;
    FindClose(F);
  end;
  if not IncludeSubDir then
    Exit;
  if FindFirst(NormalDir + '*.*', faAnyFile, F) = 0 then
  begin
    repeat
      if ((F.Attr and faDirectory) <> 0) and (F.Name <> '.') and (F.Name <> '..') then
      begin
        ListDir(NormalDir + F.Name + '\', Regex, List, IncludeSubDir);
      end;
    until FindNext(F) <> 0;
    FindClose(F);
  end;
end;


function GetFileVersionA(const FileName: string): TVersion;
type
  PFFI = ^vs_FixedFileInfo;
var
  F: PFFI;
  Handle: Dword;
  Len: Longint;
  Data: Pchar;
  Buffer: Pointer;
  Tamanho: Dword;
  Parquivo: Pchar;
begin
  Result.Major := 0;
  Result.Minor := 0;
  Result.Release := 0;
  Result.Build := 0;
  Parquivo := StrAlloc(Length(FileName) + 1);
  StrPcopy(Parquivo, FileName);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  if Len > 0 then
  begin
    Data := StrAlloc(Len + 1);
    if GetFileVersionInfo(Parquivo, Handle, Len, Data) then
    begin
      VerQueryValue(Data, '', Buffer, Tamanho);
      F := PFFI(Buffer);
      Result.Major := HiWord(F^.dwFileVersionMs);
      Result.Minor := LoWord(F^.dwFileVersionMs);
      Result.Release := HiWord(F^.dwFileVersionLs);
      Result.Build := Loword(F^.dwFileVersionLs);
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

function Trim(Left: Char; const S: string; Rigth: Char): string; overload;
var
  Len: Integer;
begin
  Result := Trim(S);
  Len := Length(Result);
  while (Len > 0) and (Result[1] = Left) do
  begin
    Delete(Result, 1, 1);
    Dec(Len);
  end;
  while (Len > 0) and (Result[Len] = Rigth) do
  begin
    Delete(Result, Len, 1);
    Dec(Len);
  end;
end;

function CountChar(const S: string; ch: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = ch then
      Inc(Result);
end;

function ParseVersion(const Version: string): TVersion;

type
  TCharSet = set of AnsiChar;

  function Only(str: string; Chars: TCharSet): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Length(str) do
    begin
      if CharInSet(str[I], Chars) then
        Result := Result + str[I];
    end;
  end;

var
  RegExp: TPerlRegEx;
  Temp: string;
begin
  Temp := StringReplace(Version, ',', '.', [rfReplaceAll]);
  Temp := Trim('.', Only(Temp, ['0'..'9', '.']), '.');
  case CountChar(Temp, '.') of
    0: Temp := Temp + '.0.0.0';
    1: Temp := Temp + '.0.0';
    2: Temp := Temp + '.0';
  end;
  RegExp := TPerlRegEx.Create;
  RegExp.RegEx := '([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)';
  RegExp.Subject := UTF8Encode(Temp);
  if RegExp.Match then
  begin
    Result.Major := StrToInt(UTF8ToString(RegExp.Groups[1]));
    Result.Minor := StrToInt(UTF8ToString(RegExp.Groups[2]));
    Result.Release := StrToInt(UTF8ToString(RegExp.Groups[3]));
    Result.Build := StrToInt(UTF8ToString(RegExp.Groups[4]));
  end
  else
  begin
    Result.Major := 0;
    Result.Minor := 0;
    Result.Release := 0;
    Result.Build := 0;
  end;
  RegExp.Free;
end;

function VersionToStr(Version: TVersion; const Separator: string): string;
begin
  Result := Format('%d%s%d%s%d%s%d', [
    Version.Major, Separator,
    Version.Minor, Separator,
    Version.Release, Separator,
    Version.Build
  ]);
end;

function CompareVersion(Ver1, Ver2: TVersion): Integer;
begin
  if Ver1.Major > Ver2.Major then
    Result := 1
  else if Ver1.Major < Ver2.Major then
    Result := -1
  else if Ver1.Minor > Ver2.Minor then
    Result := 1
  else if Ver1.Minor < Ver2.Minor then
    Result := -1
  else if Ver1.Release > Ver2.Release then
    Result := 1
  else if Ver1.Release < Ver2.Release then
    Result := -1
  else if Ver1.Build > Ver2.Build then
    Result := 1
  else if Ver1.Build < Ver2.Build then
    Result := -1
  else
    Result := 0;
end;

function GetIconIndex(const FileName: string; ImageList: TCustomImageList;
  Size: Integer): Integer;
var
  FileInfo: TSHFileInfo;
  ImageListHandle: THandle;
  aIcon: TIcon;
begin
  // clear the memory
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  // get a handle to the ImageList for the file selected
  ImageListHandle := SHGetFileInfo(
    PChar(FileName), 0, FileInfo, SizeOf(FileInfo),
    // we want an icon in LARGE
    SHGFI_ICON or Size
  );
  try
    // create a icon class
    aIcon := TIcon.Create;
    try
      // assign the handle of the icon returned
      aIcon.Handle := FileInfo.hIcon;
      // lets paint it transparent
      aIcon.Transparent := True;
      Result := ImageList.AddIcon(aIcon);
    finally
      // free our icon class
      FreeAndNil(aIcon);
    end;
  finally
    // !!! FREE THE ICON PROVIDED BY THE SHELL
    DestroyIcon(FileInfo.hIcon);
    // free the image list handle
    ImageList_Destroy(ImageListHandle);
  end;
end;

end.
