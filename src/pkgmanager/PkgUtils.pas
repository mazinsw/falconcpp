unit PkgUtils;

interface

uses
  Windows, Forms, Classes, SysUtils, ShlObj, CommCtrl, ImgList, Controls, ShellAPI,
  Consts;

const
  CSIDL_PROGRAM_FILES = $0026;
  CSIDL_COMMON_APPDATA = $0023;

function FindFiles(Search: String; Finded:TStrings): Boolean;
function GetSpecialFolderPath(nFolder: Integer = CSIDL_PERSONAL): String;
function GetUserTemp: String;
function GetSysDir: String;
function GetFalconDir: String;
function GetCompilerDir: String;
function EmptyDirectory(Dir: string): Boolean;
function ConvertSlashes(Path: String): String;
procedure ConvertTo32BitImageList(const ImageList: TImageList);
procedure Execute(S: String);



implementation

function FindFiles(Search: String; Finded: TStrings): Boolean;
var
  F : TSearchRec;
begin
  Result := false;
  if FindFirst(Search, faAnyFile, F) = 0 then
  begin
    Result := True;
    repeat
        Finded.add(F.Name);
    until FindNext(F) <> 0;
    FindClose(F);
  end;
end;

function EmptyDirectory(Dir: string): Boolean;
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

function GetUserTemp: String;
var
  Buf: PChar;
begin
  Buf := StrAlloc(MAX_PATH);
  GetTempPath(MAX_PATH, Buf);
  Result := StrPas(Buf);
  StrDispose(Buf);
end;

function GetSysDir: String;
var
  buffer: array[0..MAX_PATH - 1] of Char;
begin
  GetSystemDirectory(buffer, MAX_PATH);
  Result := StrPas(buffer);
end;

function GetFalconDir: String;
begin
  Result := ExtractFilePath(Application.ExeName);
  if not FileExists(Result + 'Falcon.exe') then
    Result := GetSpecialFolderPath(CSIDL_PROGRAM_FILES) + '\Falcon\';
end;

function GetCompilerDir: String;
begin
  Result := GetFalconDir;
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

end.
