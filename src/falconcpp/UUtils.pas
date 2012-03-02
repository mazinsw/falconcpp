unit UUtils;

interface

uses
  Windows, SysUtils, Classes, Dialogs, ComCtrls, Controls, TLHelp32, PsAPI,
  UFileProperty, Registry, ImgList, SynEditKeyCmds, SynMemo, SynEdit, UTools,
  ShlObj, Graphics, Messages, XMLDoc, XMLIntf, CommCtrl, Consts, UParseMsgs,
  ShellAPI, Forms;

const
  MAKEFILE_MSG: array[0..3] of String = (
  'Can' + #39 +'t Build MakeFile',
  'Build sucess!',
  'Can' + #39 +'t Build MakeFile, Unknow Error',
  'Can' + #39 +'t Build MakeFile, Imposible save file');
  OSCurrentKey: array [Boolean] of String =
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
  PBM_SETMARQUEE = WM_USER+10;

type
  TLanguageItem = class
    ID: Cardinal;
    Name: String;
    ImageIndex: TImageIndex;
  end;

  TVersion = packed record
    Major: Word;
    Minor: Word;
    Release: Word;
    Build: Word;
  end;

  pRGBALine = ^TRGBALine;
	TRGBALine = Array[Word] of TRGBQuad;

type
  TExecuteFileOption = (
    eoHide,
    eoWait,
    eoElevate
  );
  TExecuteFileOptions = set of TExecuteFileOption;

function GetTickTime(ticks: Cardinal; fmt: String): String;
function ExecuteFile(Handle: HWND; const Filename, Paramaters,
  Directory: String; Options: TExecuteFileOptions): Integer;
procedure LoadFontNames(List: TStrings);
procedure LoadFontSize(FontName: String; List: TStrings);
procedure BitmapToAlpha(bmp: TBitmap; Color: TColor = clFuchsia);
function IconToBitmap(const Icon: TIcon):TBitmap;
Function GetFileVersionA(FileName: String): TVersion;
function ParseVersion(Version: String): TVersion;
function CompareVersion(Ver1, Ver2: TVersion): Integer;
function VersionToStr(Version: TVersion): String;
function CanUpdate(UpdateXML: String): Boolean;
function GetUserFolderPath(nFolder: Integer = CSIDL_PERSONAL): String;
function GetTempDirectory: String;
procedure SetProgsType(PrgsBar: TProgressBar; Infinity: Boolean);
function UserIsAdmin: Boolean;
function ForceForegroundWindow(hwnd: THandle): Boolean;
function GetCompiler(FileType: Integer): Integer;
function GetFileType(AFileName: String): Integer;
function Divide64(HEXText: String): String;
function Union64(HEXText: String): String;
function StreamToString(Value: TStream): String;
function StringToStream(Text: String; Value: TStream): Integer;
function FileDateTime(const FileName: string): TDateTime;
function CreateSourceFolder(const Name: String;
  Parent: TFileProperty): TFileProperty;
function NewFileProperty(FileType, Compiler: Integer; FirstName, BaseName,
  Ext, FileName: String; OwnerFile: TFileProperty; IsFileProp: Boolean = True;
  AutoExpand: Boolean = True): TFileProperty;
function BrowseDialog(Handle: HWND; const Title: string;
  var Directory: String): Boolean;
function HumanToBool(Resp: String): Boolean;
function BoolToHuman(Question: Boolean): String;
function GetFullFileName(Name: String): String;
function DoubleQuotedStr(const S: string): string;

function EditorGotoXY(Memo: TSynMemo; X, Y: Integer): Boolean;
function SearchFileProperty(FileName: String;
  var FileProp: TFileProperty): Boolean;
function OpenFile(FileName: String):TProjectProperty;
function RemoveOption(const S, Options: String): String;
function DeleteResourceFiles(List: TStrings): Boolean;
procedure ProjectPopupMenuItens(ItemNew, ItemNewPro, ItemNewC, ItemNewCPP,
  ItemNewH, ItemNewRC, ItemNewEmp, ItemNewFol, ItemEdit, ItemOpen, ItemDel,
  ItemRen, ItemProp: Boolean);
function IsNT: Boolean;
function GetAppTypeByName(AppType: String): Integer;
function GetCurrentUserName: String;
function GetCompanyName: String;
function GetLanguagesList: TStrings;
function GetLanguageName(LangID: Word): String;
function IsForeground(Handle: HWND): Boolean;
function IsSubMenu(Value: String): Boolean;
function GetSubMenu(Value: String): String;
function FindFiles(Search: String; Finded:TStrings): Boolean; overload;
function FindFiles(const PathName, FileName : String; List: TStrings): Boolean; overload;
procedure GetRowColFromCharIndex(SelStart: Integer; Lines: TStrings;
  var Line, Column: Integer);
function DOSFileName(FileName: String): String;
function NextFileName(FirstName, Ext: String; Node: TTreeNode): String;
function NextProjectName(FirstName, Ext: String; Nodes: TTreeNodes): String;
function RemoveFileExt(const FileName: String):String;
function ExtractName(const FileName: String):String;
function GetFilesByExt(Extension: String; List: TStrings): String;
procedure SelectFilesByExt(Extensions: array of String; List, OutList: TStrings);
function IsNumber(Str: String): Boolean;

implementation

uses UTemplates, UFrmMain, ULanguages, UConfig;

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
  result:= -1;
end;

// Fills combobox with font names.
// editor and gutter both use same fonts
procedure LoadFontNames(List: TStrings);
var
 DC: HDC;
begin
  DC:= GetDC(0);
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
  result:= 1;
  if FontType and RASTER_FONTTYPE = RASTER_FONTTYPE then
  begin
    Size:= inttostr(LogFont.elfLogFont.lfHeight *72 div LOGPIXELSY);
    if TStrings(LParam).IndexOf(Size) = -1 then
      TStrings(LParam).Add(Size);
  end
  else
  begin
    result:= 0;
  end;
end;

procedure LoadFontSize(FontName: String; List: TStrings);
var
 DC: HDC;
begin
  DC:= GetDC(0);
  EnumFontFamilies(DC, PChar(FontName), @EnumFontSizeProc, Integer(List));
  ReleaseDC(0, DC);
end;

function GetTickTime(ticks: Cardinal; fmt: String): String;
var
  milli, sec{, min, hou^}: Cardinal;
  S: String;
begin
  milli := ticks mod 1000;
  ticks := ticks div 1000;
  sec := ticks mod 60;
//  ticks := ticks div 60;
//  min := ticks mod 60;
//  ticks := ticks div 60;
//  hour := ticks mod 60;
  S := Format('%.3f', [milli/1000]);
  S := Copy(S, Pos(',', S) + 1, MaxInt);
  Result := Format('%d.%s', [sec, S]);
  //Result := Format(fmt, [hour, min, sec, milli]);
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
    for y := 0 to Pred(bmp.Height) do
    begin
      ColorSL := bmp.Scanline[y];
      for x := 0 to Pred(bmp.Width) do
      begin
        CurrCl := RGB(ColorSL^[x].rgbRed,
                      ColorSL^[x].rgbGreen,
                      ColorSL^[x].rgbBlue);
        if(CurrCl = Color) then
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

function IconToBitmap(const Icon: TIcon):TBitmap;

  function GetBitmap(const Icon: TIcon):TBitmap;
  var
    IcoInfo: TIconInfo;
  begin
    Result := nil;
    if NOT GetIconInfo(Icon.Handle, IcoInfo) then
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
      for y := 0 to Pred(Result.Height) do
      begin
        ColorSL := Result.Scanline[y];
        for x := 0 to Pred(Result.Width) do
            ColorSL^[x].rgbReserved := 0;
      end;
      Result.Canvas.Draw((48 - bmp.Width) div 2, (48 - bmp.Height) div 2, bmp);
      bmp.Free;
    end
    else
      Result := bmp;
  end;
end;

Function GetFileVersionA(FileName: String): TVersion;
type
  PFFI = ^vs_FixedFileInfo;
var
  F       : PFFI;
  Handle  : Dword;
  Len     : Longint;
  Data    : Pchar;
  Buffer  : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;
begin
  Result.Major:= 0;
  Result.Minor:= 0;
  Result.Release:= 0;
  Result.Build:= 0;
  Parquivo := StrAlloc(Length(FileName) + 1);
  StrPcopy(Parquivo, FileName);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  if Len > 0 then
  begin
    Data:=StrAlloc(Len+1);
    if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
    begin
      VerQueryValue(Data, '',Buffer,Tamanho);
      F := PFFI(Buffer);
      Result.Major:= HiWord(F^.dwFileVersionMs);
      Result.Minor:= LoWord(F^.dwFileVersionMs);
      Result.Release:= HiWord(F^.dwFileVersionLs);
      Result.Build:= Loword(F^.dwFileVersionLs);
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

function ParseVersion(Version: String): TVersion;
var
  v1, v2, v3, v4: Integer;
begin
  if sscanf('%d.%d.%d.%d', Version, [@v1, @v2, @v3, @v4]) then
  begin
    Result.Major := v1;
    Result.Minor := v2;
    Result.Release := v3;
    Result.Build := v4;
  end
  else
  begin
    Result.Major := 0;
    Result.Minor := 0;
    Result.Release := 0;
    Result.Build := 0;
  end;
end;

function VersionToStr(Version: TVersion): String;
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
    else
      if Ver1.Minor > Ver2.Minor then
        ExitFunction(1)
      else
      begin
        if Ver1.Minor < Ver2.Minor then
          ExitFunction(-1)
        else
          if Ver1.Release > Ver2.Release then
            ExitFunction(1)
          else
          begin
            if Ver1.Release < Ver2.Release then
              ExitFunction(-1)
            else
              if Ver1.Build > Ver2.Build then
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

function CanUpdate(UpdateXML: String): Boolean;
var
  XMLDoc: TXMLDocument;
  Node, FalconNode: IXMLNode;
  SiteVersion: TVersion;
begin
  Result := False;
  if not FileExists(UpdateXML) then Exit;
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  try
    XMLDoc.LoadFromFile(UpdateXML);
  except
    XMLDoc.Free;
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := '    ';

  //tag FalconCPP
  FalconNode := XMLDoc.ChildNodes.FindNode('FalconCPP');
  Node := FalconNode.ChildNodes.FindNode('Core');
  SiteVersion := ParseVersion(Node.Attributes['Version']);
  if (CompareVersion(SiteVersion, FrmFalconMain.FalconVersion) = 1) then
    Result := True;
  XMLDoc.Free;
end;

function GetUserFolderPath(nFolder: Integer = CSIDL_PERSONAL): String;
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

function IsNumber(Str: String): Boolean;
var
  I: Integer;
begin
  Result := Length(Str) > 0;
  for I:=1 to Length(Str) do
    if not(Str[I] in ['0'..'9', '.']) then
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
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then Result := True
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

function GetLanguageName(LangID: Word): String;
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
  for I:= 0 to Pred(Languages.Count) do
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

procedure ProjectPopupMenuItens(ItemNew, ItemNewPro, ItemNewC, ItemNewCPP,
  ItemNewH, ItemNewRC, ItemNewEmp, ItemNewFol, ItemEdit, ItemOpen, ItemDel,
  ItemRen, ItemProp: Boolean);
begin
  with FrmFalconMain do
  begin
    PopProjNew.Enabled := ItemNew;
    SubNNewFolder.Enabled := ItemNewFol;
    PopProjEdit.Enabled := ItemEdit;
    PopProjOpen.Enabled := ItemOpen;
    PopProjRemove.Enabled := ItemDel;
    PopProjDelFromDsk.Enabled := ItemDel;
    PopProjRename.Enabled := ItemRen;
    PopProjAdd.Enabled := ItemNewC and ItemRen;
    PopProjProp.Enabled := ItemProp;
    PopEditorProperties.Enabled := ItemProp;
    BtnProperties.Enabled := ItemProp;
    PopTabsClose.Enabled := FileClose.Enabled;
  end;
end;

function IsNT: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
end;

function GetAppTypeByName(AppType: String): Integer;
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

function GetCurrentUserName: String;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey(OSCurrentKey[IsNT], False);
  Result := reg.ReadString('RegisteredOwner');
  reg.free;
end;

function GetCompanyName: String;
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
  Directory: String; Options: TExecuteFileOptions): Integer;
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

function IsSubMenu(Value: String): Boolean;
begin
  Result := (Pos('SubMenu(', Value) > 0);
end;

function GetSubMenu(Value: String): String;
var
  I: Integer;
begin
  Value := Trim(Value);
  I := Pos('SubMenu(', Value) + Length('SubMenu(');
  Result := Copy(Value, I, Pos(')', Value) - I);
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

function FindFiles(const PathName, FileName : String; List: TStrings): Boolean;
var
  SearchRec : TSearchRec;
  Path : string;
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

function InStrCmp(const S: String; Strings: array of String;
  const UseCase: Boolean = False): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I:= Low(Strings) to High(Strings) do
  begin
    if UseCase then
    begin
      if CompareStr(S, Strings[I]) = 0 then Exit;
    end
    else if CompareText(S, Strings[I]) = 0 then Exit;
  end;
  Result := False;
end;

function GetFileType(AFileName: String): Integer;
var
  Ext: String;
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

function StringToStream(Text: String; Value: TStream): Integer;
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

function StreamToString(Value: TStream): String;
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

function Union64(HEXText: String): String;
var
  Res: String;
begin
  Res := HEXText;
  if Pos(NewLine, Res) > 0 Then
    Res := StringReplace(Res, NewLine, '', [rfReplaceAll]);
  if Pos(#10, Res) > 0 Then
    Res := StringReplace(Res, #10, '', [rfReplaceAll]);
  if Pos(Ident, Res) > 0 Then
    Res := StringReplace(Res, Ident, '', [rfReplaceAll]);
  if Pos(' ', Res) > 0 Then
    Res := StringReplace(Res, ' ', '', [rfReplaceAll]);
  Result := Res;
end;

function Divide64(HEXText: String): String;
var
  I, C, Rest: Integer;
  Ret: String;
begin
  Ret := '';
  C := Length(HEXText) div 64;
  Rest := Length(HEXText) mod 64;
  for I:= 0 to Pred(C) do
  begin
    Ret := Ret + TwoParms + Copy(HEXText, I*64 + 1, 64);
   end;
  if (Rest > 0) then
    Ret := Ret + TwoParms + Copy(HEXText, Length(HEXText) - Rest + 1, Rest);
  Result := Ret + NewLine + '    ';
end;

function FileDateTime(const FileName: string): TDateTime;
begin 
  Result := FileDateToDateTime(FileAge(FileName));
end;

function CreateSourceFolder(const Name: String;
  Parent: TFileProperty): TFileProperty;
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
  Result := TFileProperty.Create(FrmFalconMain.PageControlEditor, Node);
  Node.Data := Result;
  Result.FileType := FILE_TYPE_FOLDER;
  Result.Project := Parent.Project;
  Result.FileName := Name;
  Parent.Project.Modified := True;
  Parent.Node.Expanded := True;
end;

function NewFileProperty(FileType, Compiler: Integer; FirstName, BaseName,
  Ext, FileName: String; OwnerFile: TFileProperty; IsFileProp: Boolean;
  AutoExpand: Boolean): TFileProperty;
var
  Node: TTreeNode;
  NewPrj, Proj: TProjectProperty;
  NewFile: TFileProperty;
  AName: String;

  function NewProject: TFileProperty;
  begin
    with FrmFalconMain do
    begin
      if IsFileProp then
      begin
        if FileType = FILE_TYPE_PROJECT then
          AName := NextProjectName(STR_FRM_MAIN[23], Ext, TreeViewProjects.Items)
        else
          AName := NextProjectName(BaseName, Ext, TreeViewProjects.Items);
      end
      else
        AName := ExtractFileName(FileName);
      Node := TreeViewProjects.Items.Add(nil, AName);
      NewPrj := TProjectProperty.Create(PageControlEditor, Node);
      NewPrj.Project := NewPrj;
      NewPrj.FileType := FileType;
      NewPrj.CompilerType := Compiler;
      if IsFileProp then
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
    if Assigned(OwnerFile) and IsFileProp then
    begin
      if (OwnerFile is TProjectProperty) then
      begin
        Proj := TProjectProperty(OwnerFile);
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
        if (OwnerFile.FileType <> FILE_TYPE_FOLDER ) then
        begin
          if not Assigned(OwnerFile.Node.Parent) then
          begin
            Result := NewProject;
            Exit;
          end;
          OwnerFile := TFileProperty(OwnerFile.Node.Parent.Data);
        end;
        Proj := OwnerFile.Project;
        AName := NextFileName(BaseName, Ext, OwnerFile.Node);
      end;
      Node := TreeViewProjects.Items.AddChild(OwnerFile.Node, AName);
      NewFile := TFileProperty.Create(PageControlEditor, Node);
      NewFile.Project := Proj;
      Proj.Modified := True;
      NewFile.FileName := AName;
      NewFile.FileType := FileType;
      Node.Data := NewFile;
      if AutoExpand or (OwnerFile.FileType = FILE_TYPE_PROJECT) then
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
  var Directory: String): Boolean;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result := False;
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  with BrowseInfo do begin

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

function HumanToBool(Resp: String): Boolean;
begin
  if (CompareText(Resp, 'YES') = 0) or (Resp = '1') then
    Result := True
  else
    Result := False;
end;

function BoolToHuman(Question: Boolean): String;
begin
  if Question then
    Result := 'Yes'
  else
    Result := 'No';
end;

function GetFullFileName(Name: String): String;
var
  MinGWPath: String;
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

function SearchFileProperty(FileName: String;
  var FileProp: TFileProperty): Boolean;
var
  ActFile: TFileProperty;
  I: Integer;
  Node: TTreeNode;
begin
  Result := False;
  for I:= 0 to Pred(FrmFalconMain.TreeViewProjects.Items.Count) do
  begin
    Node := FrmFalconMain.TreeViewProjects.Items.Item[I];
    ActFile := TFileProperty(Node.Data);
    if CompareText(ActFile.GetCompleteFileName, FileName) = 0 then
    begin
      Result := True;
      FileProp := ActFile;
      Exit;
    end;
  end;
end;

function OpenFile(FileName: String):TProjectProperty;
var
  ProjProp: TProjectProperty;
  FileType: Integer;
begin
  FileType := GetFileType(FileName);
  ProjProp := TProjectProperty(NewFileProperty(FileType,
    GetCompiler(FileType),'','','',FileName, nil, False));
  ProjProp.Saved := True;
  ProjProp.DateOfFile :=  FileDateTime(ProjProp.FileName);

  if (ProjProp.FileType <> FILE_TYPE_PROJECT) then
  begin
    if (FileType = FILE_TYPE_RC) then
      ProjProp.Target := RemoveFileExt(ProjProp.Caption) + '.res'
    else
    begin
      if (ProjProp.FileType <> FILE_TYPE_PROJECT) then
      begin
        ProjProp.Target := RemoveFileExt(ProjProp.Caption) + '.exe';
        ProjProp.AppType := APPTYPE_CONSOLE;
        ProjProp.CompilerOptions := '-Wall -s -O2';
      end;
    end;
    ProjProp.Text.LoadFromFile(ProjProp.FileName);
  end
  else
    ProjProp.LoadFromFile(ProjProp.GetCompleteFileName);
  ProjProp.Modified := False;
  ProjProp.IsNew := False;
  if ProjProp.FileType = FILE_TYPE_PROJECT then
    ProjProp.LoadLayout;
  Result := ProjProp;
end;

function RemoveOption(const S, Options: String): String;
begin
  Result := StringReplace(Options, S, '', [rfReplaceAll]);
end;

function DeleteResourceFiles(List: TStrings): Boolean;
var
  I: Integer;
  Ext: String;
begin
  Result := False;
  for I:= Pred(List.Count) downto 0 do
  begin
    Ext := ExtractFileExt(List.Strings[I]);
    if CompareText(Ext, '.RC') = 0 then
    begin
      Result := True;
      List.Delete(I);
    end;
  end;
end;

function NextProjectName(FirstName, Ext: String; Nodes: TTreeNodes): String;

  function ExistName(FileName: String): Boolean;
  var
    Caption: String;
    Node: TTreeNode;
  begin
    Result := False;
    Node := Nodes.GetFirstNode;
    while Node <> nil do
    begin
      Caption := ExtractFileName(TFileProperty(Node.Data).FileName);
      if CompareText(Caption, FileName) = 0 then
      begin
        Result := True;
        Exit;
      end;
      Node := Node.getNextSibling;
    end;
  end;

var
  FileName: String;
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

function NextFileName(FirstName, Ext: String; Node: TTreeNode): String;

  function ExistName(FileName: String): Boolean;
  var
    I: Integer;
    Caption: String;
  begin
    Result := False;
    for I:= 0 to Pred(Node.Count) do
    begin
      Caption := TFileProperty(Node[I].Data).Caption;
      if (Caption = FileName) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

var
  FileName: String;
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

function DOSFileName(FileName: String): String;
begin
  if Pos(' ', FileName) > 0 then
    Result := ExtractShortPathName(FileName)
  else
    Result := FileName;
end;

function RemoveFileExt(const FileName: String):String;
begin
  Result := ChangeFileExt(FileName, '');
end;

function ExtractName(const FileName: String):String;
begin
  Result := ExtractFileName(RemoveFileExt(FileName));
end;

procedure TransformToRelativePath(BaseName: String; Files: TStrings);
var
  I: Integer;
begin
  for I:= 0 to Pred(Files.Count) do
  begin
    Files.Strings[I] := ExtractRelativePath(BaseName, Files.Strings[I]);
  end;
end;

function GetFilesByExt(Extension: String; List: TStrings): String;
var
  OutList: TStrings;
begin
  OutList := TStringList.Create;
  SelectFilesByExt([Extension], List, OutList);
  Result := OutList.Text;
  OutList.Free;
end;

function ConvertAnsiToOem(const S: String): String;
begin
  Result := '';
  if Length(s) = 0 then Exit;
  SetLength(Result, Length(S));
  AnsiToOem(PChar(S), PChar(Result));
end;

function LinuxSpace(const S: String): String;
begin
  Result := StringReplace(S, ' ', '\ ', [rfReplaceAll]);
end;

function DoubleQuotedStr(const S: string): string;
begin
  Result := S;
  if Pos(' ', Trim(S)) > 0 then
    Result := '"' + Result + '"';
end;

procedure SelectFilesByExt(Extensions: array of String; List, OutList: TStrings);
var
  I, X: Integer;
begin
  for I:= 0 to Pred(List.Count) do
  begin
    for X:= 0 to Pred(Length(Extensions)) do
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
