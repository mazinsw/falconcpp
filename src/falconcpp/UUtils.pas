unit UUtils;

interface

uses
  Windows, SysUtils, Classes, Dialogs, ComCtrls, Controls, 
  USourceFile, Registry, ImgList,
  ShlObj, Graphics, Messages, XMLDoc, XMLIntf, UParseMsgs,
  ShellAPI, Forms, UEditor;

const
  MAKEFILE_MSG: array[0..3] of string = (
    'Can' + #39 + 't Build MakeFile',
    'Build sucess!',
    'Can' + #39 + 't Build MakeFile, Unknow Error',
    'Can' + #39 + 't Build MakeFile, Imposible save file');
  OSCurrentKey: array[Boolean] of string =
  ('Software\Microsoft\Windows\CurrentVersion',
    'Software\Microsoft\Windows NT\CurrentVersion');
  Ident = #9#9;
  NewLine = #13 + #10;
  TwoParms = NewLine + Ident;
  FALCON_URL_UPDATE = 'https://downloads.sourceforge.net/project/falconcpp/' +
    'Update/Update.xml';
{$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
{$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER + 10;
  OFASI_EDIT = $0001;
  OFASI_OPENDESKTOP = $0002;

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

function GetTickTime(ticks: Cardinal; fmt: string): string;
procedure GetNameAndVersion(const S: string; var aName, aVersion: string);
procedure SearchCompilers(List: TStrings; var PathCompiler: string);
function TranslateSpecialChars(const S: string): string;
function CanDoubleQuotedStr(const S: string): Boolean;
procedure SplitParams(const S: string; List: TStrings);
procedure GetIncludeDirs(const ProjectDir, Flags: string; IncludeList: TStrings;
  Expand: Boolean = False);
procedure GetLibraryDirs(const ProjectDir, Libs: string; PathLibList: TStrings;
  Expand: Boolean = False);
procedure LoadFontNames(List: TStrings);
procedure LoadFontSize(FontName: string; List: TStrings);
procedure BitmapToAlpha(bmp: TBitmap; Color: TColor = clFuchsia);
function IconToBitmap(const Icon: TIcon; Width: Integer = 48;
  Height: Integer = 48): TBitmap;
function GetRGBAPointerFromImageIndex(ImageList: TCustomImageList;
  Index: Integer; var Width, Height: Integer): PAnsiChar;
function GetFileVersionA(FileName: string): TVersion;
function ParseVersion(Version: string): TVersion;
function CompareVersion(Ver1, Ver2: TVersion): Integer;
function VersionToStr(Version: TVersion): string;
function CanUpdate(UpdateXML: string): Boolean;
procedure SetProgsType(PrgsBar: TProgressBar; Infinity: Boolean);
function GetCompiler(FileType: Integer): Integer;
function GetFileType(AFileName: string): Integer;
function Divide64(HEXText: string): string;
function Union64(const HEXText: string): string;
function StreamToString(Value: TStream): string;
function StringToStream(Text: string; Value: TStream): Integer;
function FileDateTime(const FileName: string): TDateTime;
function ExtractRootPathName(const Path: string): string;
function ExcludeRootPathName(const Path: string): string;
function CreateSourceFolder(const Name: string;
  Parent: TSourceFile): TSourceFile;
function NewSourceFile(FileType, Compiler: Integer; FirstName, BaseName,
  Ext, FileName: string; OwnerFile: TSourceFile; UseFileName,
  Expand: Boolean): TSourceFile;
function FormatLibrary(const FileName: string): string;
function BrowseDialog(Handle: HWND; const Title: string;
  var Directory: string): Boolean;
function HumanToBool(Resp: string): Boolean;
function BoolToHuman(Question: Boolean): string;

function EditorGotoXY(Memo: TEditor; X, Y: Integer): Boolean;
function SearchSourceFile(FileName: string;
  var FileProp: TSourceFile): Boolean;
function OpenFile(FileName: string): TProjectFile;
function RemoveOption(const S, Options: string): string;
function DeleteResourceFiles(List: TStrings): Boolean;
function GetAppTypeByName(AppType: string): Integer;
function GetCurrentUserName: string;
function GetCompanyName: string;
function GetLanguagesList: TStrings;
function GetReverseArrowCursor: HCURSOR;
function IsSubMenu(Value: string): Boolean;
function GetSubMenu(Value: string): string;
procedure GetRowColFromCharIndex(SelStart: Integer; Lines: TStrings;
  var Line, Column: Integer);
function DOSFileName(FileName: string): string;
procedure AssignAppIcon(Picture: TPicture);
function NextFileName(FirstName, Ext: string; Node: TTreeNode): string;
function NextProjectName(FirstName, Ext: string; Nodes: TTreeNodes): string;
function RemoveFileExt(const FileName: string): string;
procedure SetExplorerTheme(Handle: HWND);
function ExtractName(const FileName: string): string;
function GetFilesByExt(Extension: string; List: TStrings): string;
procedure SelectFilesByExt(Extensions: array of string; List, OutList: TStrings);
function IsNumber(Str: string): Boolean;
function StartsWith(const S, Token: string): Boolean;

implementation

uses UFrmMain, ULanguages, UConfig, TokenUtils, StrUtils,
  UxTheme, icoformat, PerlRegEx, SystemUtils;

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
  milli, sec , min: Cardinal;
  S: string;
begin
  milli := ticks mod 1000;
  ticks := ticks div 1000;
  sec := ticks{ mod 60};
  //ticks := ticks div 60;
  min := 0{ticks};
  S := Format('%.3f', [milli / 1000]);
  S := Copy(S, Pos(',', S) + 1, MaxInt);
  if min > 0 then
    Result := Format('%d:%.*d.%s', [min, 2, sec, S])
  else
    Result := Format('%d.%s', [sec, S]);
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
  while not CharInSet(ptr^, [#0, #10]) do
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
  while (ptr >= init) and not CharInSet(ptr^, ['0'..'9']) do
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

  function findString(const S: string; aList: TStrings): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to aList.Count - 1 do
    begin
      if CompareText(aList.Strings[I], S) = 0 then
      begin
        Result := I;
        Break;
      end;
    end;
  end;

var
  BaseDir, ProgFiles, Path, Temp, Temp2: string;
  I, J, K: Integer;
begin
  List.Clear;
  //Falcon C++
  BaseDir := ExtractFilePath(Application.ExeName) + 'MinGW';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
  begin
    List.Add(BaseDir);
    PathCompiler := BaseDir;
  end
  else
    PathCompiler := '';

  ProgFiles := GetEnvironmentVariable('PROGRAMFILES');
  BaseDir := IncludeTrailingPathDelimiter(ProgFiles) + 'Falcon\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
  begin
    if (PathCompiler = '') and (Pos('FALCON', UpperCase(BaseDir)) <> 0) then
    begin
      List.Insert(0, BaseDir);
      PathCompiler := BaseDir;
    end
    else
      List.Add(BaseDir);
  end;

  //Code::Blocks
  BaseDir := ProgFiles + '\CodeBlocks\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
    List.Add(BaseDir);

  //MinGW
  BaseDir := ExtractFileDrive(ProgFiles) + '\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
    List.Add(BaseDir);

  Path := GetEnvironmentVariable('PATH');
  Temp := UpperCase(Path);
  I := Pos('MINGW', Temp);
  while I > 0 do
  begin
    J := I;
    while (J > 1) and (Temp[J] <> ';') do
      Dec(J);
    K := I;
    while (K < Length(Temp)) and (Temp[K] <> ';') do
      Inc(K);
    Temp2 := Copy(Path, J, K - J + 1);
    if Temp[J] = ';' then
    begin
      Delete(Temp, J + 1, K - J);
      Delete(Path, J + 1, K - J);
    end
    else if Temp[K] = ';' then
    begin
      Delete(Temp, J, K - J);
      Delete(Path, J, K - J);
    end
    else
    begin
      Delete(Temp, J, K - J + 1);
      Delete(Path, J, K - J + 1);
    end;
    I := I - j + 1;
    while (I < Length(Temp2)) and (Temp2[I] <> '\') do
      Inc(I);
    if Temp2[I] = '\' then
      Delete(Temp2, I, Length(Temp2) - I + 1);
    if Temp2[1] = ';' then
      Delete(Temp2, 1, 1);
    BaseDir := Temp2;
    if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
      (findString(BaseDir, List) < 0) then
    begin
      if (PathCompiler = '') and (Pos('FALCON', UpperCase(BaseDir)) <> 0) then
      begin
        List.Insert(0, BaseDir);
        PathCompiler := BaseDir;
      end
      else
        List.Add(BaseDir);
    end;
    I := Pos('MINGW', Temp);
  end;

  //Dev-C++
  BaseDir := ProgFiles + '\Dev-Cpp\MinGW';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
    List.Add(BaseDir);
  BaseDir := ProgFiles + '\Dev-Cpp\MinGW32';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
    List.Add(BaseDir);
  BaseDir := ProgFiles + '\Dev-Cpp\MinGW64';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
    List.Add(BaseDir);

  //Dev-C++ - Last option to choose (very old compiler)
  BaseDir := ExtractFileDrive(ProgFiles) + '\Dev-Cpp';
  if FileExists(IncludeTrailingPathDelimiter(BaseDir) + 'bin\gcc.exe') and
    (findString(BaseDir, List) < 0) then
    List.Add(BaseDir);
end;

function TranslateSpecialChars(const S: string): string;
begin
  Result := StringReplace(S, '\n', #13, [rfReplaceAll]);
end;

function CanDoubleQuotedStr(const S: string): Boolean;
var
  p: PChar;
  I: Integer;
begin
  Result := False;
  I := 0;
  p := PChar(Trim(S));
  if p <> nil then
    while p^ <> #0 do
    begin
      if p^ = '"' then
        Inc(I)
      else if (p^ = ' ') and (I mod 2 = 0) then
      begin
        Result := True;
        Exit;
      end;
      Inc(p);
    end;
end;

procedure SplitParams(const S: string; List: TStrings);
var
  p, ps, ap: PChar;
  Temp: string;
  I, K: Integer;
begin
  I := 0;
  K := 0;
  p := PChar(S);
  ap := p;
  ps := p;
  if p <> nil then
  begin
    while p^ <> #0 do
    begin
      if p^ = '"' then
        Inc(I)
      else if (p^ = ' ') and (I mod 2 = 0) then
      begin
        if K > 0 then
        begin
          Temp := Copy(S, ps - ap + 1, p - ps);
          List.Add(Temp);
        end;
        K := 0;
        while p^ = ' ' do
          Inc(p);
        ps := p;
        Continue;
      end
      else
        Inc(K);
      Inc(p);
    end;
    if K > 0 then
    begin
      Temp := Copy(S, ps - ap + 1, p - ps);
      List.Add(Temp);
    end;
  end;
end;

procedure GetFlagDirs(const ProjectDir, Flags, Token: string; OutList: TStrings;
  Expand: Boolean);
var
  I: Integer;
  List: TStringList;
  Temp: string;
begin
  List := TStringList.Create;
  SplitParams(Flags, List);
  for I := List.Count - 1 downto 0 do
  begin
    if Copy(List.Strings[I], 1, Length(Token)) = Token then
    begin
      Temp := StringReplace(Copy(List.Strings[I], 1 + Length(Token),
        Length(List.Strings[I]) - Length(Token)),
        '"', '', [rfReplaceAll]);
      if ExtractFileDrive(Temp) = '' then
        Temp := ProjectDir + Temp;
      if Expand then
        OutList.Add(ExpandFileName(IncludeTrailingPathDelimiter(Temp)))
      else
        OutList.Add(IncludeTrailingPathDelimiter(Temp));
    end;
  end;
  List.Free;
end;

procedure GetIncludeDirs(const ProjectDir, Flags: string; IncludeList: TStrings;
  Expand: Boolean);
begin
  GetFlagDirs(ProjectDir, Flags, '-I', IncludeList, Expand);
end;

procedure GetLibraryDirs(const ProjectDir, Libs: string; PathLibList: TStrings;
  Expand: Boolean);
begin
  GetFlagDirs(ProjectDir, Libs, '-L', PathLibList, Expand);
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

function IconToBitmap(const Icon: TIcon; Width, Height: Integer): TBitmap;

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
    if (Width > 0) and (Height > 0) and
      ((bmp.Width <> Width) or (bmp.Height <> Height)) then
    begin
      bmp.PixelFormat := pf32bit;
      Result := TBitmap.Create;
      Result.PixelFormat := pf32bit; 
      Result.Width := Width;
      Result.Height := Height;
      Result.Canvas.Brush.Color := clBlack;
      Result.Canvas.FillRect(Result.Canvas.ClipRect);
      for y := 0 to Result.Height - 1 do
      begin
        ColorSL := Result.Scanline[y];
        for x := 0 to Result.Width - 1 do
          ColorSL^[x].rgbReserved := 0;
      end;
      Result.Canvas.Draw((Width - bmp.Width) div 2, (Height - bmp.Height) div 2, bmp);
      bmp.Free;
    end
    else
      Result := bmp;
  end;
end;

function GetRGBAPointerFromImageIndex(ImageList: TCustomImageList;
  Index: Integer; var Width, Height: Integer): PAnsiChar;
var
  I, J: Integer;
  Icon: TIcon;  
  Image: TBitmap;
  ImgPtr, DestPtr, TmpPtr: PRGBQuad;
begin
  // breakpoint icon
  Icon := TIcon.Create;
  ImageList.GetIcon(Index, Icon);
  Image := IconToBitmap(Icon, 0, 0);
  Icon.Free;
  Width := Image.Width;
  Height := Image.Height;
  GetMem(DestPtr, Image.Width * Image.Height * 4);
  TmpPtr := DestPtr;
  for I := 0 to Image.Height - 1 do
  begin
    ImgPtr := Image.ScanLine[I];
    for J := 0 to Image.Width - 1 do
    begin
      TmpPtr^.rgbBlue := ImgPtr^.rgbRed;
      TmpPtr^.rgbGreen := ImgPtr^.rgbGreen;
      TmpPtr^.rgbRed := ImgPtr^.rgbBlue;
      TmpPtr^.rgbReserved := ImgPtr^.rgbReserved;
      Inc(ImgPtr);
      Inc(TmpPtr);
    end;
  end;
  Image.Free;
  Result := PAnsiChar(DestPtr);
end;


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
begin
  Version := StringReplace(Version, ',', '.', [rfReplaceAll]);
  Version := Trim('.', Only(Version, ['0'..'9', '.']), '.');
  case CountChar(Version, '.') of
    0: Version := Version + '.0.0.0';
    1: Version := Version + '.0.0';
    2: Version := Version + '.0';
  end;
  RegExp := TPerlRegEx.Create;
  RegExp.RegEx := '([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)';
  RegExp.Subject := UTF8Encode(Version);
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
    if not CharInSet(Str[I], ['0'..'9', '.']) then
    begin
      Result := False;
      Exit;
    end;
end;

function GetLanguagesList: TStrings;
var
  List: TStrings;
  LangItem: TLanguageItem;
  I: Integer;
begin
  List := TStringList.Create;
  for I := 0 to {$WARN SYMBOL_PLATFORM OFF} Languages.Count {$WARN SYMBOL_PLATFORM ON} - 1 do
  begin
    LangItem := TLanguageItem.Create;
    LangItem.ID := {$WARN SYMBOL_PLATFORM OFF} Languages.LocaleID[I] {$WARN SYMBOL_PLATFORM ON};
    LangItem.Name := {$WARN SYMBOL_PLATFORM OFF} Languages.Name[I] {$WARN SYMBOL_PLATFORM ON};
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

procedure FlipBitmap(bitmap: HBITMAP; width: Integer; height: Integer);
var
  ahdc: HDC;
  prevBmp: HGDIOBJ;
begin
	ahdc := CreateCompatibleDC(0);
	if ahdc <> 0 then
  begin
		prevBmp := SelectObject(ahdc, bitmap);
		StretchBlt(ahdc, width - 1, 0, -width, height, ahdc, 0, 0, width, height, SRCCOPY);
		SelectObject(ahdc, prevBmp);
		DeleteDC(ahdc);
	end;
end;

function GetReverseArrowCursor: HCURSOR;
var
  info: ICONINFO;
  crPlatformLock: TRTLCriticalSection;
  bmp: BITMAP;
  revArrow: HCURSOR;
begin
  InitializeCriticalSection(crPlatformLock);
  EnterCriticalSection(crPlatformLock);
	Result := LoadCursor(0, IDC_ARROW);
  if GetIconInfo(Result, info) then
  begin
			if GetObject(info.hbmMask, SizeOf(bmp), @bmp) <> 0 then
      begin
				FlipBitmap(info.hbmMask, bmp.bmWidth, bmp.bmHeight);
				if info.hbmColor <> 0 then
					FlipBitmap(info.hbmColor, bmp.bmWidth, bmp.bmHeight);
				info.xHotspot := Cardinal(bmp.bmWidth) - 1 - info.xHotspot;
				revArrow := CreateIconIndirect(info);
				if revArrow <> 0 then
					Result := revArrow;
			end;
			DeleteObject(info.hbmMask);
			if info.hbmColor <> 0 then
				DeleteObject(info.hbmColor);
		end;
	LeaveCriticalSection(crPlatformLock);
  DeleteCriticalSection(crPlatformLock);
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
    if not CharInSet(ptr^, [#13, #10, ' ', #9]) then
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
  Result := Ret + NewLine + #9;
end;

function FileDateTime(const FileName: string): TDateTime;
begin
  FileAge(FileName, Result);
end;

function ExtractRootPathName(const Path: string): string;
var
  pstr: PChar;
begin
  pstr := PChar(Path);
  while pstr^ <> #0 do
  begin
    if not CharInSet(pstr^, ['/', '\']) then
      Break;
    Inc(pstr);
  end;
  Result := '';
  while pstr^ <> #0 do
  begin
    if CharInSet(pstr^, ['/', '\']) then
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
    if not CharInSet(pstr^, ['/', '\']) then
      Break;
    Inc(pstr);
  end;
  while pstr^ <> #0 do
  begin
    if CharInSet(pstr^, ['/', '\']) then
      Break;
    Inc(pstr);
  end;
  if CharInSet(pstr^, ['/', '\']) then
    Inc(pstr);
  Result := StrPas(pstr);
end;

function CreateSourceFolder(const Name: string;
  Parent: TSourceFile): TSourceFile;
begin
  if not Assigned(Parent) or not
    (Parent.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]) then
  begin
    Result := nil;
    Exit;
  end;
  Result := FrmFalconMain.CreateSource(Parent.Node, Name);
  Result.FileType := FILE_TYPE_FOLDER;
  Result.FileName := Name;
  Parent.Node.Expanded := True;
end;

function NewSourceFile(FileType, Compiler: Integer; FirstName, BaseName,
  Ext, FileName: string; OwnerFile: TSourceFile; UseFileName,
  Expand: Boolean): TSourceFile;

  function NewProject: TProjectFile;
  var
    AName: string;
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
      Result := CreateProject(AName, FileType);
      Result.CompilerType := Compiler;
      if not UseFileName then
      begin
        Result.FileName := Config.Environment.ProjectsDir + AName;
        if (Result.FileType = FILE_TYPE_RC) then
          Result.Target := RemoveFileExt(AName) + '.res'
        else
          Result.Target := RemoveFileExt(AName) + '.exe';
        Result.CompilerOptions := '-Wall -s';
      end
      else
        Result.FileName := FileName;
    end;
  end;

var
  AName: string;
begin
  with FrmFalconMain do
  begin
    if Assigned(OwnerFile) then
    begin
      if (OwnerFile is TProjectFile) then
      begin
        if (TProjectFile(OwnerFile).FileType <> FILE_TYPE_PROJECT) then
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
        AName := NextFileName(BaseName, Ext, OwnerFile.Node);
      end;

      Result := CreateSource(OwnerFile.Node, AName);
      Result.FileName := AName;
      Result.FileType := FileType;
      if Expand or (OwnerFile.FileType = FILE_TYPE_PROJECT) then
        OwnerFile.Node.Expanded := True;
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

function FormatLibrary(const FileName: string): string;
var
  Name, Lib: string;
begin
  Name := ExtractFileName(FileName);
  Lib := 'lib';
  if Pos('lib', Name) = 1 then
    Lib := '';
  Result := Format(LD_DLL_STATIC_LIB,
        [ExtractFilePath(FileName), Lib, RemoveFileExt(Name) + '.dll.a']);
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
  if (CompareText(Resp, 'Yes') = 0) or (Resp = '1') then
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

function EditorGotoXY(Memo: TEditor; X, Y: Integer): Boolean;
var
  DisplayCoord: TDisplayCoord;
  BufferCoord: TBufferCoord;
begin
  DisplayCoord.Column := X;
  DisplayCoord.Row := Y;
  BufferCoord := Memo.DisplayToBufferPos(DisplayCoord);
  Memo.CaretXY := BufferCoord;
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
        ProjProp.CompilerOptions := '-Wall -s';
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

procedure AssignAppIcon(Picture: TPicture);
var
  FIcon: TIcon;
begin
  FIcon := LoadIconFromResource('MAINICON', 48);
  Picture.Icon := FIcon;
  FIcon.Free;
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

procedure SetExplorerTheme(Handle: HWND);
begin
  SetWindowTheme(Handle, 'Explorer', nil);
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

function StartsWith(const S, Token: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if Length(S) < Length(Token) then
    Exit;
  for I := 1 to Length(Token) do
  begin
    if Token[I] <> S[I] then
      Exit;
  end;
  Result := True;
end;

end.
