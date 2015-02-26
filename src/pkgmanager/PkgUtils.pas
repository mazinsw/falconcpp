unit PkgUtils;

interface

{$I Falcon.inc}

uses
  Windows, ImgList;

function GetFalconDir: String;
function GetConfigDir(const FalconDir: string): String;
function GetCompilerDir: String;
procedure SetExplorerTheme(Handle: HWND);
procedure ConvertTo32BitImageList(const ImageList: TCustomImageList);


implementation

uses
  Forms, Classes, SysUtils, ShlObj, CommCtrl, Controls, Consts, UxTheme,
  SystemUtils, Registry;

procedure SetExplorerTheme(Handle: HWND);
begin
  SetWindowTheme(Handle, 'Explorer', nil);
end;

function GetFalconDir: String;
begin
  Result := ExtractFilePath(Application.ExeName);
{$IFDEF FALCON_PORTABLE}
{$ELSE}
  with TRegistry.Create do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly('Software\Falcon') then
      Result := IncludeTrailingPathDelimiter(ReadString(''));
    Free;
  end;
  if not FileExists(Result + 'Falcon.exe') then
    Result := GetSpecialFolderPath(CSIDL_PROGRAM_FILES) + '\Falcon\';
  if not FileExists(Result + 'Falcon.exe') then
    Result := ExtractFilePath(Application.ExeName);
{$ENDIF}
end;

function GetConfigDir(const FalconDir: string): String;
begin
{$IFDEF FALCON_PORTABLE}
  Result := FalconDir + 'Config\';
{$ELSE}
  Result := GetSpecialFolderPath(CSIDL_APPDATA) + 'Falcon\';
{$ENDIF}
end;

function GetCompilerDir: String;
begin
  Result := GetFalconDir;
end;

procedure ConvertTo32BitImageList(const ImageList: TCustomImageList);
//CommCtrl, Classes, Consts;
const
  Mask: array[Boolean] of Longint = (0, ILC_MASK);
var
  TemporyImageList: TCustomImageList;
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

end.
