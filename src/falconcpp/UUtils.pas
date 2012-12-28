unit UUtils;

interface

uses
  Windows, SysUtils, Classes, Dialogs, ComCtrls, Controls, 
  USourceFile, Registry, ImgList, SynEditKeyCmds, SynMemo, SynEdit, 
  ShlObj, Graphics, Messages, XMLDoc, XMLIntf, UParseMsgs,
  ShellAPI, Forms;

const
  MAKEFILE_MSG: array[0..3] of string = (
    'Can' + #39 + 't Build MakeFile',
    'Build sucess!',
    'Can' + #39 + 't Build MakeFile, Unknow Error',
    'Can' + #39 + 't Build MakeFile, Imposible save file');
  OSCurrentKey: array[Boolean] of string =
  ('Software\Microsoft\Windows\CurrentVersion',
    'Software\Microsoft\Windows NT\CurrentVersion');
  CSIDL_COMMON_APPDATA = $0023;
  Ident = '        ';
  NewLine = #13 + #10;
  TwoParms = NewLine + Ident;
  FALCON_URL_UPDATE = 'https://downloads.sourceforge.net/project/falconcpp/' +
    'Update/Update.xml';
{$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
{$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER + 10;

type
  TLanguageItem = class
    ID: Cardinal;
      Name: string;
    ImageIndex: TImageIndex;
  end;

  TVersion = packed record
    Major: Word;
    Minor: Word;
    Release: Word;
    Build: Word;
  end;

  pRGBALine = ^TRGBALine;
  TRGBALine = array[Word] of TRGBQuad;

type
  TExecuteFileOption = (
    eoHide,
    eoWait,
    eoElevate
    );
  TExecuteFileOptions = set of TExecuteFileOption;

{$EXTERNALSYM SwitchToThisWindow}
procedure SwitchToThisWindow(hWnd: HWND; fAltTab: BOOL); stdcall;

function GetTickTime(ticks: Cardinal; fmt: string): string;
procedure GetNameAndVersion(const S: string; var aName, aVersion: string);
procedure SearchCompilers(List: TStrings; var PathCompiler: string);
function TranslateSpecialChars(const S: string): string;
function GetLeftSpacing(CharCount, TabWidth: Integer; WantTabs: Boolean): string;
function ExecuteFile(Handle: HWND; const Filename, Paramaters,
  Directory: string; Options: TExecuteFileOptions): Integer;
procedure LoadFontNames(List: TStrings);
procedure LoadFontSize(FontName: string; List: TStrings);
procedure BitmapToAlpha(bmp: TBitmap; Color: TColor = clFuchsia);
function IconToBitmap(const Icon: TIcon): TBitmap;
function GetFileVersionA(FileName: string): TVersion;
function ParseVersion(Version: string): TVersion;
function CompareVersion(Ver1, Ver2: TVersion): Integer;
function VersionToStr(Version: TVersion): string;
function CanUpdate(UpdateXML: string): Boolean;
function GetUserFolderPath(nFolder: Integer = CSIDL_PERSONAL): string;
function GetTempDirectory: string;
procedure SetProgsType(PrgsBar: TProgressBar; Infinity: Boolean);
function UserIsAdmin: Boolean;
function ForceForegroundWindow(hwnd: THandle): Boolean;
function GetCompiler(FileType: Integer): Integer;
function GetFileType(AFileName: string): Integer;
function Divide64(HEXText: string): string;
function Union64(const HEXText: string): string;
function StreamToString(Value: TStream): string;
function StringToStream(Text: string; Value: TStream): Integer;
function FileDateTime(const FileName: string): TDateTime;
function ExtractRootPathName(const Path: string): string;
function ExcludeRootPathName(const Path: string): string;
procedure ListDir(Dir, Regex: string; List: TStrings; IncludeSubDir: Boolean = False);
function CreateSourceFolder(const Name: string;
  Parent: TSourceFile): TSourceFile;
function NewSourceFile(FileType, Compiler: Integer; FirstName, BaseName,
  Ext, FileName: string; OwnerFile: TSourceFile; UseFileName,
  Expand: Boolean): TSourceFile;
function BrowseDialog(Handle: HWND; const Title: string;
  var Directory: string): Boolean;
function HumanToBool(Resp: string): Boolean;
function BoolToHuman(Question: Boolean): string;
function GetFullFileName(Name: string): string;
function LinuxSpace(const S: string): string;
function DoubleQuotedStr(const S: string): string;

function EditorGotoXY(Memo: TSynMemo; X, Y: Integer): Boolean;
function SearchSourceFile(FileName: string;
  var FileProp: TSourceFile): Boolean;
function OpenFile(FileName: string): TProjectFile;
function RemoveOption(const S, Options: string): string;
function DeleteResourceFiles(List: TStrings): Boolean;
function IsNT: Boolean;
function GetAppTypeByName(AppType: string): Integer;
function GetCurrentUserName: string;
function GetCompanyName: string;
function GetLanguagesList: TStrings;
function GetLanguageName(LangID: Word): string;
function IsForeground(Handle: HWND): Boolean;
function BringUpApp(const ClassName: string): Boolean;
function IsSubMenu(Value: string): Boolean;
function GetSubMenu(Value: string): string;
function FindFiles(Search: string; Finded: TStrings): Boolean; overload;
function FindFiles(const PathName, FileName: string; List: TStrings): Boolean; overload;
procedure GetRowColFromCharIndex(SelStart: Integer; Lines: TStrings;
  var Line, Column: Integer);
function DOSFileName(FileName: string): string;
function NextFileName(FirstName, Ext: string; Node: TTreeNode): string;
function NextProjectName(FirstName, Ext: string; Nodes: TTreeNodes): string;
function RemoveFileExt(const FileName: string): string;
function ExtractName(const FileName: string): string;
function GetFilesByExt(Extension: string; List: TStrings): string;
procedure SelectFilesByExt(Extensions: array of string; List, OutList: TStrings);
function IsNumber(Str: string): Boolean;

implementation

uses UFrmMain, ULanguages, UConfig, SynRegExpr;

{ ---------- Font Methods ---------- }

(*
  enum font families callback function
   adds a font to the list if it is of the Modern font family
   i.e. any font that is monospaced (same as delphi)
*)

function EnumFontFamilyProc(LogFont: PEnumLogFont; var TextMetric: PNewTextMetric;
  FontType: integer; LParam: integer): integer; stdcall;
begin
  if LogFont.elfLogFont.lfPitchAndFamily and FF_MODERN = FF_MODERN then
    TStrings(LParam).Add(LogFont.elfLogFont.lfFaceName);
  result := -1;
end;

// Fills combobox with font names.
// editor and gutter both use same fonts

procedure LoadFontNames(List: TStrings);
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFontFamilies(DC, nil, @EnumFontFamilyProc, Integer(List));
  ReleaseDC(0, DC);
end;

(*
  enum font families callback function for font sizes
  adds font sizes to list.  if font is not a RASTER then
  uses default font sizes (7..30)
*)

function EnumFontSizeProc(LogFont: PEnumLogFont; var TextMetric: PNewTextMetric;
  FontType: integer; LParam: integer): integer; stdcall;
var
  size: string;
begin
  result := 1;
  if FontType and RASTER_FONTTYPE = RASTER_FONTTYPE then
  begin
    Size := inttostr(LogFont.elfLogFont.lfHeight * 72 div LOGPIXELSY);
    if TStrings(LParam).IndexOf(Size) = -1 then
      TStrings(LParam).Add(Size);
  end
  else
  begin
    result := 0;
  end;
end;

procedure LoadFontSize(FontName: string; List: TStrings);
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFontFamilies(DC, PChar(FontName), @EnumFontSizeProc, Integer(List));
  ReleaseDC(0, DC);
end;

function GetTickTime(ticks: Cardinal; fmt: string): string;
var
  milli, sec {, min, hou^}: Cardinal;
  S: string;
begin
  milli := ticks mod 1000;
  ticks := ticks div 1000;
  sec := ticks mod 60;
//  ticks := ticks div 60;
//  min := ticks mod 60;
//  ticks := ticks div 60;
//  hour := ticks mod 60;
  S := Format('%.3f', [milli / 1000]);
  S := Copy(S, Pos(',', S) + 1, MaxInt);
  Result := Format('%d.%s', [sec, S]);
  //Result := Format(fmt, [hour, min, sec, milli]);
end;

procedure GetNameAndVersion(const S: string; var aName, aVersion: string);
var
  ptr, init: PChar;
  line: string;
begin
  ptr := PChar(S);
  aName := '';
  aVersion := '';
  line := '';
  while not (ptr^ in [#0, #10]) do
  begin
    line := line + ptr^;
    Inc(ptr);
  end;
  if line = '' then
    Exit;
  init := PChar(line);
  ptr := PChar(line) + Length(line);
  if (ptr >= init) and (ptr^ = ')') then
  begin
    while (ptr >= init) and (ptr^ <> '(') do
      Dec(ptr);
  end;
  while (ptr >= init) and not (ptr^ in ['0'..'9']) do
    Dec(ptr);
  while (ptr >= init) and (ptr^ <> ' ') do
  begin
    aVersion := ptr^ + aVersion;
    Dec(ptr);
  end;
  while (ptr >= init) and (ptr^ = ' ') do
    Dec(ptr);
  while (ptr >= init) do
  begin
    aName := ptr^ + aName;
    Dec(ptr);
  end;
end;

procedure SearchCompilers(List: TStrings; var PathCompiler: string);
var
  path, ProgFiles: string;
begin
  List.Clear;
  //find compilers
  path := ExcludeTrailingPathDelimiter(GetEnvironmentVariable('MINGW_PATH'));
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') then
  begin
    List.Add(path);
    PathCompiler := path;
  end
  else
    PathCompiler := '';
  //Falcon C++
  path := ExtractFilePath(Application.ExeName) + 'MinGW';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);

  ProgFiles := GetEnvironmentVariable('PROGRAMFILES');
  path := IncludeTrailingPathDelimiter(ProgFiles) + 'Falcon\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);

  //Code::Blocks
  path := ProgFiles + '\CodeBlocks\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);

  path := ProgFiles + '\CodeBlocks 8.02\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);

  //MinGW
  path := ExtractFileDrive(ProgFiles) + '\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);

  //Dev-C++
  path := ExtractFileDrive(ProgFiles) + '\Dev-Cpp';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);

  path := ProgFiles + '\Dev-Cpp\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);
  path := ProgFiles + '\Dev-Cpp\MinGW32';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);
  path := ProgFiles + '\Dev-Cpp\MinGW64';
  if FileExists(IncludeTrailingPathDelimiter(path) + 'bin\gcc.exe') and
    (List.IndexOf(path) < 0) then
    List.Add(path);
end;

function TranslateSpecialChars(const S: string): string;
begin
  Result := StringReplace(S, '\n', #13, [rfReplaceAll]);
end;

function GetLeftSpacing(CharCount, TabWidth: Integer; WantTabs: Boolean): string;
begin
  if (WantTabs) and (CharCount>=TabWidth) then
      Result:=StringOfChar(#9,CharCount div TabWidth)+StringOfChar(#32,CharCount mod TabWidth)
  else Result:=StringOfChar(#32,CharCount);
end;

procedure BitmapToAlpha(bmp: TBitmap; Color: TColor = clFuchsia);
var
  ColorSL: pRGBALine;
  CurrCl: TColor;
  x, y: word;
begin
  if Assigned(bmp) then
  begin
    bmp.PixelFormat := pf32bit;
    for y := 0 to bmp.Height - 1 do
    begin
      ColorSL := bmp.Scanline[y];
      for x := 0 to bmp.Width - 1 do
      begin
        CurrCl := RGB(ColorSL^[x].rgbRed,
          ColorSL^[x].rgbGreen,
          ColorSL^[x].rgbBlue);
        if (CurrCl = Color) then
        begin
          ColorSL^[x].rgbRed := 0;
          ColorSL^[x].rgbGreen := 0;
          ColorSL^[x].rgbBlue := 0;
          ColorSL^[x].rgbReserved := 0;
        end
        else
          ColorSL^[x].rgbReserved := 255;
      end;
    end;
  end;
end;

function IconToBitmap(const Icon: TIcon): TBitmap;

  function GetBitmap(const Icon: TIcon): TBitmap;
  var
    IcoInfo: TIconInfo;
  begin
    Result := nil;
    if not GetIconInfo(Icon.Handle, IcoInfo) then
      Exit;
    Result := TBitmap.Create;
    Result.Handle := IcoInfo.hbmColor;
  end;

var
  bmp: TBitmap;
  ColorSL: pRGBALine;
  x, y: word;
begin
  Result := nil;
  bmp := GetBitmap(Icon);
  if Assigned(bmp) then
  begin
    if (bmp.Width <> 48) then
    begin
      bmp.PixelFormat := pf32bit;
      Result := TBitmap.Create;
      Result.PixelFormat := pf32bit;
      Result.Height := 48;
      Result.Width := 48;
      Result.Canvas.Brush.Color := clBlack;
      Result.Canvas.FillRect(Result.Canvas.ClipRect);
      for y := 0 to Result.Height - 1 do
      begin
        ColorSL := Result.Scanline[y];
        for x := 0 to Result.Width - 1 do
          ColorSL^[x].rgbReserved := 0;
      end;
      Result.Canvas.Draw((48 - bmp.Width) div 2, (48 - bmp.Height) div 2, bmp);
      bmp.Free;
    end
    else
      Result := bmp;
  end;
end;

procedure SwitchToThisWindow; external user32 name 'SwitchToThisWindow';

function GetFileVersionA(FileName: string): TVersion;
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

function ParseVersion(Version: string): TVersion;
var
  RegExp: TRegExpr;
begin
  RegExp := TRegExpr.Create;
  if RegExp.Exec('([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)', Version) then
  begin
    Result.Major := StrToInt(RegExp.Match[1]);
    Result.Minor := StrToInt(RegExp.Match[2]);
    Result.Release := StrToInt(RegExp.Match[3]);
    Result.Build := StrToInt(RegExp.Match[4]);
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

function VersionToStr(Version: TVersion): string;
begin
  Result := Format('%d.%d.%d.%d', [
    Version.Major,
      Version.Minor,
      Version.Release,
      Version.Build
      ]);
end;

function CompareVersion(Ver1, Ver2: TVersion): Integer;

  procedure ExitFunction(Value: Integer);
  begin
    Result := Value;
    Exit;
  end;

begin
  if Ver1.Major > Ver2.Major then
    ExitFunction(1)
  else
  begin
    if Ver1.Major < Ver2.Major then
      ExitFunction(-1)
    else if Ver1.Minor > Ver2.Minor then
      ExitFunction(1)
    else
    begin
      if Ver1.Minor < Ver2.Minor then
        ExitFunction(-1)
      else if Ver1.Release > Ver2.Release then
        ExitFunction(1)
      else
      begin
        if Ver1.Release < Ver2.Release then
          ExitFunction(-1)
        else if Ver1.Build > Ver2.Build then
          ExitFunction(1)
        else
        begin
          if Ver1.Build < Ver2.Build then
            ExitFunction(-1)
          else
            ExitFunction(0);
        end;
      end;
    end;
  end;
end;

function CanUpdate(UpdateXML: string): Boolean;
var
  XMLDoc: IXMLDocument;
  Node, FalconNode: IXMLNode;
  SiteVersion: TVersion;
begin
  Result := False;
  if not FileExists(UpdateXML) then
    Exit;
  try
    XMLDoc := LoadXMLDocument(UpdateXML);
  except
    Exit;
  end;
  //tag FalconCPP
  FalconNode := XMLDoc.ChildNodes.FindNode('FalconCPP');
  Node := FalconNode.ChildNodes.FindNode('Core');
  SiteVersion := ParseVersion(Node.Attributes['Version']);
  if (CompareVersion(SiteVersion, FrmFalconMain.FalconVersion) = 1) then
    Result := True;
end;

function GetUserFolderPath(nFolder: Integer = CSIDL_PERSONAL): string;
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

function GetTempDirectory: string;
var
  TempDir: array[0..255] of Char;
begin
  GetTempPath(255, @TempDir);
  Result := StrPas(TempDir);
end;

procedure SetProgsType(PrgsBar: TProgressBar; Infinity: Boolean);
begin
  if Infinity then
  begin
    SetWindowLong(PrgsBar.Handle, GWL_STYLE,
      GetWindowLong(PrgsBar.Handle, GWL_STYLE) or PBS_MARQUEE);
    SendMessage(PrgsBar.Handle, PBM_SETMARQUEE, 1, 0);
  end
  else
  begin
    SetWindowLong(PrgsBar.Handle, GWL_STYLE,
      GetWindowLong(PrgsBar.Handle, GWL_STYLE) and not PBS_MARQUEE);
    SendMessage(PrgsBar.Handle, PBM_SETMARQUEE, 0, 0);
  end;
end;

function IsNumber(Str: string): Boolean;
var
  I: Integer;
begin
  Result := Length(Str) > 0;
  for I := 1 to Length(Str) do
    if not (Str[I] in ['0'..'9', '.']) then
    begin
      Result := False;
      Exit;
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

function GetLanguagesList: TStrings;
var
  List: TStrings;
  LangItem: TLanguageItem;
  I: Integer;
begin
  List := TStringList.Create;
  for I := 0 to Languages.Count - 1 do
  begin
    LangItem := TLanguageItem.Create;
    LangItem.ID := Languages.LocaleID[I];
    LangItem.Name := Languages.Name[I];
    List.AddObject(LangItem.Name, LangItem);
    case LangItem.ID of
      $0409: LangItem.ImageIndex := 220;
    else
      LangItem.ImageIndex :=
        FrmFalconMain.Config.Environment.Langs.GetImageIndexByID(LangItem.ID);
    end;
  end;
  TStringList(List).Sort;
  Result := List;
end;

function IsNT: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
end;

function GetAppTypeByName(AppType: string): Integer;
begin
  AppType := UpperCase(AppType);
  if (AppType = 'CONSOLE') then
    Result := APPTYPE_CONSOLE
  else if (AppType = 'GUI') then
    Result := APPTYPE_GUI
  else if (AppType = 'DLL') then
    Result := APPTYPE_DLL
  else if (AppType = 'LIB') then
    Result := APPTYPE_LIB
  else if (AppType = 'TEMPLATE') then
    Result := APPTYPE_FTM
  else if (AppType = 'PACKAGE') then
    Result := APPTYPE_FPK
  else
    Result := APPTYPE_CONSOLE;
end;

function GetCurrentUserName: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey(OSCurrentKey[IsNT], False);
  Result := reg.ReadString('RegisteredOwner');
  reg.free;
end;

function GetCompanyName: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey(OSCurrentKey[IsNT], False);
  Result := reg.ReadString('RegisteredOrganization');
  reg.free;
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
      FreeAndNil(Reg);
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

function IsSubMenu(Value: string): Boolean;
begin
  Result := (Pos('SubMenu(', Value) > 0);
end;

function GetSubMenu(Value: string): string;
var
  I: Integer;
begin
  Value := Trim(Value);
  I := Pos('SubMenu(', Value) + Length('SubMenu(');
  Result := Copy(Value, I, Pos(')', Value) - I);
end;

function FindFiles(Search: string; Finded: TStrings): Boolean;
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

function InStrCmp(const S: string; Strings: array of string;
  const UseCase: Boolean = False): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := Low(Strings) to High(Strings) do
  begin
    if UseCase then
    begin
      if CompareStr(S, Strings[I]) = 0 then
        Exit;
    end
    else if CompareText(S, Strings[I]) = 0 then
      Exit;
  end;
  Result := False;
end;

function GetFileType(AFileName: string): Integer;
var
  Ext: string;
begin
  Result := FILE_TYPE_UNKNOW;
  Ext := ExtractFileExt(AFileName);
  if CompareText(Ext, '.fpj') = 0 then
    Result := FILE_TYPE_PROJECT
  else if CompareText(Ext, '.c') = 0 then
    Result := FILE_TYPE_C
  else if InStrCmp(Ext, ['.cpp', '.cc', '.cxx', '.c++', '.cp']) then
    Result := FILE_TYPE_CPP
  else if InStrCmp(Ext, ['.h', '.hpp', '.rh', '.hh']) then
    Result := FILE_TYPE_H
  else if CompareText(Ext, '.rc') = 0 then
    Result := FILE_TYPE_RC;
end;

function GetCompiler(FileType: Integer): Integer;
begin
  case FileType of
    FILE_TYPE_PROJECT, FILE_TYPE_CPP, FILE_TYPE_UNKNOW:
      Result := COMPILER_CPP;
    FILE_TYPE_C: Result := COMPILER_C;
    FILE_TYPE_RC: Result := COMPILER_RC;
  else
    Result := NO_COMPILER;
  end;
end;

function StringToStream(Text: string; Value: TStream): Integer;
var
  Stream: TMemoryStream;
  Pos: Integer;
begin
  if Text <> '' then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;

    try
      Pos := Stream.Position;
      Stream.SetSize(Stream.Size + Length(Text) div 2);
      HexToBin(PChar(Text), PChar(Integer(Stream.Memory) + Stream.Position), Length(Text) div 2);
      Stream.Position := Pos;
      if Value <> Stream then
        Value.CopyFrom(Stream, Length(Text) div 2);
      Result := Stream.Size - Pos;
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end
  else
    Result := 0;
end;

function StreamToString(Value: TStream): string;
var
  Text: string;
  Stream: TMemoryStream;
begin
  SetLength(Text, (Value.Size - Value.Position) * 2);
  if Length(Text) > 0 then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;

    try
      if Stream <> Value then
      begin
        Stream.CopyFrom(Value, Value.Size - Value.Position);
        Stream.Position := 0;
      end;
      BinToHex(PChar(Integer(Stream.Memory) + Stream.Position), PChar(Text),
        Stream.Size - Stream.Position);
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end;
  Result := Text;
end;

function Union64(const HEXText: string): string;
var
  ptr, pres: PChar;
begin
  Result := HEXText;
  pres := PChar(Result);
  ptr := PChar(HEXText);
  while ptr^ <> #0 do
  begin
    if not (ptr^ in [#13, #10, ' ', #9]) then
    begin
      pres^ := ptr^;
      Inc(pres);
    end;
    Inc(ptr);
  end;
  if pres^ <> #0 then
    pres^ := #0;
  Result := StrPas(PChar(Result));
end;

function Divide64(HEXText: string): string;
var
  I, C, Rest: Integer;
  Ret: string;
begin
  Ret := '';
  C := Length(HEXText) div 64;
  Rest := Length(HEXText) mod 64;
  for I := 0 to C - 1 do
  begin
    Ret := Ret + TwoParms + Copy(HEXText, I * 64 + 1, 64);
  end;
  if (Rest > 0) then
    Ret := Ret + TwoParms + Copy(HEXText, Length(HEXText) - Rest + 1, Rest);
  Result := Ret + NewLine + '    ';
end;

function FileDateTime(const FileName: string): TDateTime;
begin
  Result := FileDateToDateTime(FileAge(FileName));
end;

function ExtractRootPathName(const Path: string): string;
var
  pstr: PChar;
begin
  pstr := PChar(Path);
  while pstr^ <> #0 do
  begin
    if not (pstr^ in ['/', '\']) then
      Break;
    Inc(pstr);
  end;
  Result := '';
  while pstr^ <> #0 do
  begin
    if (pstr^ in ['/', '\']) then
      Break;
    Result := Result + pstr^;
    Inc(pstr);
  end;
end;

function ExcludeRootPathName(const Path: string): string;
var
  pstr: PChar;
begin
  pstr := PChar(Path);
  while pstr^ <> #0 do
  begin
    if not (pstr^ in ['/', '\']) then
      Break;
    Inc(pstr);
  end;
  while pstr^ <> #0 do
  begin
    if (pstr^ in ['/', '\']) then
      Break;
    Inc(pstr);
  end;
  if (pstr^ in ['/', '\']) then
    Inc(pstr);
  Result := StrPas(pstr);
end;

function CreateSourceFolder(const Name: string;
  Parent: TSourceFile): TSourceFile;
var
  Node: TTreeNode;
begin
  if not Assigned(Parent) or not
    (Parent.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]) then
  begin
    Result := nil;
    Exit;
  end;
  Node := FrmFalconMain.TreeViewProjects.Items.AddChild(Parent.Node, Name);
  Result := TSourceFile.Create(Node);
  Node.Data := Result;
  Result.FileType := FILE_TYPE_FOLDER;
  Result.Project := Parent.Project;
  Result.FileName := Name;
  Parent.Node.Expanded := True;
end;

procedure ListDir(Dir, Regex: string; List: TStrings; IncludeSubDir: Boolean);
var
  F: TSearchRec;
  NormalDir: string;
begin
  NormalDir := IncludeTrailingPathDelimiter(Dir);
  if FindFirst(NormalDir + Regex, faAnyFile, F) = 0 then
  repeat
    if (F.Attr and faDirectory) = 0 then
      List.Add(NormalDir + F.Name);
  until FindNext(F) <> 0;
  FindClose(F);
  if not IncludeSubDir then
    Exit;
  if FindFirst(NormalDir + '*.*', faAnyFile, F) = 0 then
  repeat
    if ((F.Attr and faDirectory) <> 0) and (F.Name <> '.') and (F.Name <> '..') then
    begin
      ListDir(NormalDir + F.Name + '\', Regex, List, IncludeSubDir);
    end;
  until FindNext(F) <> 0;
  FindClose(F);
end;

function NewSourceFile(FileType, Compiler: Integer; FirstName, BaseName,
  Ext, FileName: string; OwnerFile: TSourceFile; UseFileName,
  Expand: Boolean): TSourceFile;
var
  Node: TTreeNode;
  NewPrj, Proj: TProjectFile;
  NewFile: TSourceFile;
  AName: string;

  function NewProject: TSourceFile;
  begin
    with FrmFalconMain do
    begin
      if not UseFileName then
      begin
        if FileType = FILE_TYPE_PROJECT then
          AName := NextProjectName(STR_FRM_MAIN[23], Ext, TreeViewProjects.Items)
        else
          AName := NextProjectName(BaseName, Ext, TreeViewProjects.Items);
      end
      else
        AName := ExtractFileName(FileName);
      Node := TreeViewProjects.Items.Add(nil, AName);
      NewPrj := TProjectFile.Create(Node);
      NewPrj.Project := NewPrj;
      NewPrj.FileType := FileType;
      NewPrj.CompilerType := Compiler;
      if not UseFileName then
      begin
        NewPrj.FileName := Config.Environment.ProjectsDir + AName;
        if (NewPrj.FileType = FILE_TYPE_RC) then
          NewPrj.Target := RemoveFileExt(AName) + '.res'
        else
          NewPrj.Target := RemoveFileExt(AName) + '.exe';
        NewPrj.CompilerOptions := '-Wall -s -O2';
      end
      else
        NewPrj.FileName := FileName;
      Node.Data := NewPrj;
      Result := NewPrj;
    end;
  end;

begin
  with FrmFalconMain do
  begin
    if Assigned(OwnerFile) then
    begin
      if (OwnerFile is TProjectFile) then
      begin
        Proj := TProjectFile(OwnerFile);
        if (Proj.FileType <> FILE_TYPE_PROJECT) then
        begin
          Result := NewProject;
          Exit;
        end;
        if (OwnerFile.Node.Count = 0) then
          AName := FirstName
        else
          AName := NextFileName(BaseName, Ext, OwnerFile.Node);
      end
      else
      begin
        if (OwnerFile.FileType <> FILE_TYPE_FOLDER) then
        begin
          if not Assigned(OwnerFile.Node.Parent) then
          begin
            Result := NewProject;
            Exit;
          end;
          OwnerFile := TSourceFile(OwnerFile.Node.Parent.Data);
        end;
        Proj := OwnerFile.Project;
        AName := NextFileName(BaseName, Ext, OwnerFile.Node);
      end;
      Node := TreeViewProjects.Items.AddChild(OwnerFile.Node, AName);
      NewFile := TSourceFile.Create(Node);
      NewFile.Project := Proj;
      NewFile.FileName := AName;
      NewFile.FileType := FileType;
      Node.Data := NewFile;
      if Expand or (OwnerFile.FileType = FILE_TYPE_PROJECT) then
        OwnerFile.Node.Expanded := True;
      Result := NewFile;
    end
    else
      Result := NewProject;
  end;
end;

function SelectDirProc(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  result := 0;
end;

function BrowseDialog(Handle: HWND; const Title: string;
  var Directory: string): Boolean;
var
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array[0..MAX_PATH] of char;
  TempPath: array[0..MAX_PATH] of char;
begin
  Result := False;
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  with BrowseInfo do
  begin

    hwndOwner := Handle;
    pszDisplayName := @DisplayName;
    lpszTitle := PChar(Title);
    ulFlags := BIF_RETURNONLYFSDIRS;
    if Directory <> '' then
    begin
      lpfn := SelectDirProc;
      lParam := Integer(PChar(Directory));
    end;
  end;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Directory := TempPath;
    GlobalFreePtr(lpItemID);
    Result := True;
  end;
end;

function HumanToBool(Resp: string): Boolean;
begin
  if (CompareText(Resp, 'YES') = 0) or (Resp = '1') then
    Result := True
  else
    Result := False;
end;

function BoolToHuman(Question: Boolean): string;
begin
  if Question then
    Result := 'Yes'
  else
    Result := 'No';
end;

function GetFullFileName(Name: string): string;
var
  MinGWPath: string;
begin
  MinGWPath := GetEnvironmentVariable('MINGW_PATH');
  Result := MinGWPath + '\bin\' + Name;
end;

function EditorGotoXY(Memo: TSynMemo; X, Y: Integer): Boolean;
var
  DisplayCoord: TDisplayCoord;
  BufferCoord: TBufferCoord;
begin
  DisplayCoord.Column := X;
  DisplayCoord.Row := Y;
  BufferCoord := Memo.DisplayToBufferPos(DisplayCoord);
  Memo.ExecuteCommand(ecGotoXY, #0, @BufferCoord);
  Result := (Memo.DisplayX = X) and (Memo.DisplayY = Y);
end;

function SearchSourceFile(FileName: string;
  var FileProp: TSourceFile): Boolean;
var
  ActFile: TSourceFile;
  I: Integer;
  Node: TTreeNode;
begin
  Result := False;
  for I := 0 to FrmFalconMain.TreeViewProjects.Items.Count - 1 do
  begin
    Node := FrmFalconMain.TreeViewProjects.Items.Item[I];
    ActFile := TSourceFile(Node.Data);
    if CompareText(ActFile.FileName, FileName) = 0 then
    begin
      Result := True;
      FileProp := ActFile;
      Exit;
    end;
  end;
end;

function OpenFile(FileName: string): TProjectFile;
var
  ProjProp: TProjectFile;
  FileType: Integer;
begin
  FileType := GetFileType(FileName);
  ProjProp := TProjectFile(NewSourceFile(FileType,
    GetCompiler(FileType), '', '', '', FileName, nil, True, False));
  ProjProp.Saved := True;
  ProjProp.IsNew := False;
  ProjProp.DateOfFile := FileDateTime(ProjProp.FileName);

  if (ProjProp.FileType <> FILE_TYPE_PROJECT) then
  begin
    if (FileType = FILE_TYPE_RC) then
      ProjProp.Target := RemoveFileExt(ProjProp.Name) + '.res'
    else
    begin
      if (ProjProp.FileType <> FILE_TYPE_PROJECT) then
      begin
        ProjProp.Target := RemoveFileExt(ProjProp.Name) + '.exe';
        ProjProp.AppType := APPTYPE_CONSOLE;
        ProjProp.CompilerOptions := '-Wall -s -O2';
      end;
    end;
  end
  else
    ProjProp.LoadFromFile(ProjProp.FileName);
  if ProjProp.FileType = FILE_TYPE_PROJECT then
    ProjProp.LoadLayout;
  Result := ProjProp;
end;

function RemoveOption(const S, Options: string): string;
begin
  Result := StringReplace(Options, S, '', [rfReplaceAll]);
end;

function DeleteResourceFiles(List: TStrings): Boolean;
var
  I: Integer;
  Ext: string;
begin
  Result := False;
  for I := List.Count - 1 downto 0 do
  begin
    Ext := ExtractFileExt(List.Strings[I]);
    if CompareText(Ext, '.RC') = 0 then
    begin
      Result := True;
      List.Delete(I);
    end;
  end;
end;

function NextProjectName(FirstName, Ext: string; Nodes: TTreeNodes): string;

  function ExistName(FileName: string): Boolean;
  var
    Caption: string;
    Node: TTreeNode;
  begin
    Result := False;
    Node := Nodes.GetFirstNode;
    while Node <> nil do
    begin
      Caption := ExtractFileName(TSourceFile(Node.Data).FileName);
      if CompareText(Caption, FileName) = 0 then
      begin
        Result := True;
        Exit;
      end;
      Node := Node.getNextSibling;
    end;
  end;

var
  FileName: string;
  X: Integer;
begin
  if not ExistName(FirstName + Ext) then
  begin
    Result := FirstName + Ext;
    Exit;
  end;
  X := 1;
  FileName := FirstName + Ext;
  while ExistName(FileName) do
  begin
    FileName := FirstName + IntToStr(X) + Ext;
    Inc(X);
  end;
  Result := FileName;
end;

function NextFileName(FirstName, Ext: string; Node: TTreeNode): string;

  function ExistName(FileName: string): Boolean;
  var
    I: Integer;
    Caption: string;
  begin
    Result := False;
    for I := 0 to Node.Count - 1 do
    begin
      Caption := TSourceFile(Node[I].Data).Name;
      if (Caption = FileName) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

var
  FileName: string;
  X: Integer;
begin
  if not ExistName(FirstName + Ext) then
  begin
    Result := FirstName + Ext;
    Exit;
  end;
  X := 1;
  FileName := FirstName + Ext;
  while ExistName(FileName) do
  begin
    FileName := FirstName + IntToStr(X) + Ext;
    Inc(X);
  end;
  Result := FileName;
end;

procedure GetRowColFromCharIndex(SelStart: Integer; Lines: TStrings;
  var Line, Column: Integer);
var
  x, y, Chars: integer;
begin
  x := 0;
  y := 0;
  Chars := 0;
  while y < Lines.Count do
  begin
    x := Length(Lines[y]);
    if Chars + x + 2 > SelStart then
    begin
      x := SelStart - Chars;
      break;
    end;
    Inc(Chars, x + 2);
    x := 0;
    Inc(y);
  end;
  Column := x + 1;
  Line := y + 1;
end;

function DOSFileName(FileName: string): string;
begin
  if Pos(' ', FileName) > 0 then
    Result := ExtractShortPathName(FileName)
  else
    Result := FileName;
end;

function RemoveFileExt(const FileName: string): string;
begin
  Result := ChangeFileExt(FileName, '');
end;

function ExtractName(const FileName: string): string;
begin
  Result := ExtractFileName(RemoveFileExt(FileName));
end;

procedure TransformToRelativePath(BaseName: string; Files: TStrings);
var
  I: Integer;
begin
  for I := 0 to Files.Count - 1 do
  begin
    Files.Strings[I] := ExtractRelativePath(BaseName, Files.Strings[I]);
  end;
end;

function GetFilesByExt(Extension: string; List: TStrings): string;
var
  OutList: TStrings;
begin
  OutList := TStringList.Create;
  SelectFilesByExt([Extension], List, OutList);
  Result := OutList.Text;
  OutList.Free;
end;

function ConvertAnsiToOem(const S: string): string;
begin
  Result := '';
  if Length(s) = 0 then
    Exit;
  SetLength(Result, Length(S));
  AnsiToOem(PChar(S), PChar(Result));
end;

function LinuxSpace(const S: string): string;
begin
  Result := StringReplace(S, ' ', '\ ', [rfReplaceAll]);
end;

function DoubleQuotedStr(const S: string): string;
begin
  Result := S;
  if Pos(' ', Trim(S)) > 0 then
    Result := '"' + Result + '"';
end;

procedure SelectFilesByExt(Extensions: array of string; List, OutList: TStrings);
var
  I, X: Integer;
begin
  for I := 0 to List.Count - 1 do
  begin
    for X := 0 to Length(Extensions) - 1 do
    begin
      if (UpperCase(ExtractFileExt(List.Strings[I])) =
        UpperCase(Extensions[X])) then
      begin
        OutList.Add(List.Strings[I]);
      end;
    end;
  end;
end;

end.
