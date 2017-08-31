unit UTemplates;

interface

uses
  Windows, SysUtils, IniFiles, Graphics, Classes, SpTBXItem,
  Controls, Dialogs, CompressUtils, PNGImage, FormEffect;

const
  pngSign: array[0..3] of Byte = ($89, $50, $4E, $47);
  bmpSign: array[0..1] of Byte = ($42, $4D);
  zipSign: array[0..1] of Byte = ($50, $4B);
  bzpSign: array[0..1] of Byte = ($42, $5A);

type
  TTemplate = class;

  TTemplateID = class
  private
    FSheet: string;
    FCaption: string;
  public
    property Sheet: string read FSheet write FSheet;
    property Caption: string read FCaption write FCaption;
  end;

  TTemplateFiles = class
  private
    FList: TStrings;
    FDefFile: Integer;
    FTemplate: TTemplate;
    function GetFile(Index: Integer): TStrings;
    function GetFileName(Index: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
    function Insert(Name: string): Integer;
    function Count: Integer;
    property SourceFile[Index: Integer]: TStrings read GetFile;
    property FileName[Index: Integer]: string read GetFileName;
  public
    property DefaultFile: Integer read FDefFile;
  end;

  TTemplateResources = class
  private
    FList: TStrings;
    FTemplate: TTemplate;
    function GetResourceName(Index: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure Insert(const FileName: string);
    function CreateTemplateID: TTemplateID;
    function SaveToFile(const FileName: string;
      Index: Integer): Boolean;
    function GetResource(Index: Integer; Stream: TStream): Boolean;
    property ResourceName[Index: Integer]: string read GetResourceName;
  end;

  TDataMenuItem = class(TSpTBXItem)
  private
    FHelpFile: string;
  public
    property HelpFile: string read FHelpFile write FHelpFile;
  end;

  TDataSubMenuItem = class(TSpTBXSubmenuItem)
  private
    FHelpFile: string;
  public
    property HelpFile: string read FHelpFile write FHelpFile;
  end;

  TTemplate = class
  private
    FFileName: string;
    FSheet: string;
    FCaption: string;
    FDescription: string;
    FIcon: TIcon;
    FBitmap: TBitmap;
    FFlags: string;
    FLibs: string;
    FParams: string;
    FAppType: Integer;
    FCompilerType: Integer;
    FSrcFiles: TTemplateFiles;
    FCppSrcFiles: TTemplateFiles;
    FResources: TTemplateResources;
    FHelpMenu: TDataSubMenuItem;
    function FindMenu(const S: string; FalconHelp: TSpTBXSubmenuItem;
      var aHelpMenu: TDataSubMenuItem): Boolean;
  public
    function Load(Template: string; FalconHelp: TSpTBXSubmenuItem): Boolean;
    function GetFile(aFileName: string; Stream: TStream): Boolean;
    constructor Create;
    destructor Destroy; override;
  public
    property SourceFiles: TTemplateFiles read FSrcFiles;
    property CppSourceFiles: TTemplateFiles read FCppSrcFiles;
    property Resources: TTemplateResources read FResources;
    property Sheet: string read FSheet write FSheet;
    property Caption: string read FCaption write FCaption;
    property Description: string read FDescription write FDescription;
    property Icon: TIcon read FIcon;
    property ListImage: TBitmap read FBitmap;
    property AppType: Integer read FAppType write FAppType;
    property CompilerType: Integer read FCompilerType write FCompilerType;
    property Flags: string read FFlags write FFlags;
    property Libs: string read FLibs write FLibs;
    property Params: string read FParams write FParams;
    property HelpMenu: TDataSubMenuItem read FHelpMenu write FHelpMenu;
  end;

  TTemplates = class
  private
    FList: TList;
    function GetTemplate(Index: Integer): TTemplate;
    procedure SetTemplate(Index: Integer; Value: TTemplate);
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    function Find(const Sheet, Caption: string): TTemplate; overload;
    function Find(TemplateID: TTemplateID): TTemplate; overload;
    function Insert(Template: TTemplate): Integer;
    function Delete(Index: Integer): Boolean;
    procedure Clear;
    property Templates[Index: Integer]: TTemplate read GetTemplate write SetTemplate; default;
  end;

implementation

uses
  UUtils, USourceFile, KAZip;

{TTemplateResources}

function TTemplateResources.GetResourceName(Index: Integer): string;
begin
  Result := FList.Strings[Index];
end;

constructor TTemplateResources.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

destructor TTemplateResources.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TTemplateResources.Insert(const FileName: string);
begin
  //if FList.IndexOf(FileName) < 0 then
  FList.Add(FileName);
end;

function TTemplateResources.Count: Integer;
begin
  Result := FList.Count;
end;

function TTemplateResources.CreateTemplateID: TTemplateID;
begin
  Result := TTemplateID.Create;
  Result.Sheet := FTemplate.Sheet;
  Result.Caption := FTemplate.Caption;
end;

function TTemplateResources.GetResource(Index: Integer;
  Stream: TStream): Boolean;
var
  FileName: string;
begin
  Result := False;
  if (Index < 0) or (Index >= Count) then
    Exit;
  FileName := FList.Strings[Index];
  Result := FTemplate.GetFile(FileName, Stream);
end;

function TTemplateResources.SaveToFile(const FileName: string;
  Index: Integer): Boolean;
var
  S, Path: string;
  Test: Boolean;
  fs: TFileStream;
begin
  Result := False;
  if (Index < 0) or (Index >= Count) then
    Exit;
  S := FList.Strings[Index];
  Path := ExtractFilePath(FileName);
  Test := DirectoryExists(Path);
  if not Test then
    Test := ForceDirectories(Path);
  if not Test then //can't create directory
    Exit;
  try
    if FileExists(FileName) then
      fs := TFileStream.Create(FileName, fmOpenReadWrite)
    else
      fs := TFileStream.Create(FileName, fmCreate);
  except
    Exit;
  end;
  try
    Result := FTemplate.GetFile(S, fs);
    fs.Free;
  except
    fs.Free;
    Exit;
  end;
  Result := True;
end;

{TTemplateFiles}

constructor TTemplateFiles.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

destructor TTemplateFiles.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TTemplateFiles.GetFile(Index: Integer): TStrings;
var
  aFileName: string;
  Ms: TMemoryStream;
begin
  aFileName := FList.Strings[Index];
  Ms := TMemoryStream.Create;
  Result := TStringList.Create;
  if FTemplate.GetFile(aFileName, Ms) then
  begin
    Ms.Position := 0;
    Result.LoadFromStream(Ms);
  end;
  Ms.Free;
end;

function TTemplateFiles.GetFileName(Index: Integer): string;
begin
  Result := FList.Strings[Index];
end;

function TTemplateFiles.Count: Integer;
begin
  Result := FList.Count;
end;

function TTemplateFiles.Insert(Name: string): Integer;
begin
  //if FList.IndexOf(Name) < 0 then
  Result := FList.Add(Name);
end;

{ TTemplate }

constructor TTemplate.Create;
begin
  inherited Create;
  FSrcFiles := TTemplateFiles.Create;
  FSrcFiles.FTemplate := Self;
  FCppSrcFiles := TTemplateFiles.Create;
  FCppSrcFiles.FTemplate := Self;
  FResources := TTemplateResources.Create;
  FResources.FTemplate := Self;
end;

destructor TTemplate.Destroy;
begin
  FResources.Free;
  FSrcFiles.Free;
  FCppSrcFiles.Free;
  if FIcon <> nil then
    FIcon.Free;
  if FBitmap <> nil then
    FBitmap.Free;
  inherited Destroy;
end;

function TTemplate.GetFile(aFileName: string; Stream: TStream): Boolean;
var
  FileType: Integer;
  Fs: TFileStream;
  Zp: TKAZip;
  Ts: TMemoryStream;
  sign: array[0..1] of Byte;
begin
  Result := False;
  try
    Fs := TFileStream.Create(FFileName, fmOpenRead + fmShareDenyWrite);
  except
    Exit;
  end;
  Fs.Read(sign, SizeOf(sign));
  Fs.Position := 0;
  if CompareMem(@sign, @bzpSign, Sizeof(bzpSign)) then
    FileType := FILE_TYPE_BZIP2
  else if CompareMem(@sign, @zipSign, Sizeof(zipSign)) then
    FileType := FILE_TYPE_ZIP
  else
  begin
    Fs.Free;
    Exit;
  end;
  case FileType of
    FILE_TYPE_BZIP2:
      begin
        Ts := TMemoryStream.Create;
        try
          if ExtractBzip2File(Fs, Ts) then
            Result := FindTarFile(aFileName, Ts, Stream);
        finally
          Ts.Free;
        end;
      end;
    FILE_TYPE_ZIP:
      begin
        Zp := TKAZip.Create(nil);
        try
          Zp.Open(Fs);
          Result := FindZipFile(aFileName, Zp, Stream);
        finally
          Zp.Free;
        end;
      end;
  end;
  Fs.Free;
end;

function TTemplate.FindMenu(const S: string; FalconHelp: TSpTBXSubmenuItem;
  var aHelpMenu: TDataSubMenuItem): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to FalconHelp.Count - 1 do
  begin
    if SameText(S, FalconHelp.Items[I].Caption) then
    begin
      if FalconHelp.Items[I] is TDataSubMenuItem then
      begin
        aHelpMenu := TDataSubMenuItem(FalconHelp.Items[I]);
        Exit;
      end;
    end;
  end;
  if Assigned(aHelpMenu) then
  begin
    for I := 1 to aHelpMenu.Count - 1 do
    begin
      if SameText(S, aHelpMenu.Items[I].Caption) then
      begin
        if aHelpMenu.Items[I] is TDataSubMenuItem then
        begin
          aHelpMenu := TDataSubMenuItem(aHelpMenu.Items[I]);
          Exit;
        end;
      end;
    end;
  end;
  Result := False;
end;

function TTemplate.Load(Template: string; FalconHelp: TSpTBXSubmenuItem): Boolean;
var
  I, FileType: Integer;
  ini: TMemIniFile;
  SubMCap, ExtStr, ImageName, IconName, Temp, SrcName: string;
  compiler: string;
  List: TStrings;
  SubMenu: TDataMenuItem;
  ActualMenu: TSpTBXSubmenuItem;
  IsSubMn: Boolean;
  AIcon: TIcon;
  APng: TPngImage;

  Tp: Integer;
  Fs: TFileStream;
  Zp: TKAZip;
  Ts, Ms: TMemoryStream;
  Ft: array[0..2] of AnsiChar;
  imgSign: array[0..3] of Byte;

  procedure SetIniFile;
  begin
    Ms.Position := 0;
    List.LoadFromStream(Ms);
    Ms.Clear;
    ini.SetStrings(List);
  end;

  procedure SetListImage;
  begin
    Ms.Position := 0;
    Ms.Read(imgSign, SizeOf(pngSign));
    Ms.Position := 0;
    //Check for png image
    if CompareMem(@imgSign, @pngSign, SizeOf(pngSign)) then
    begin
      try
        APng := TPngImage.Create;
        APng.LoadFromStream(Ms);
        FBitmap := PNGToBMP32(APng);
      except
        FBitmap.Free;
        FBitmap := nil
      end;
      APng.Free;
      Exit;
    end;
    Ms.Read(imgSign, SizeOf(bmpSign));
    Ms.Position := 0;
    //check for bmp image
    if CompareMem(@imgSign, @bmpSign, SizeOf(bmpSign)) then
    begin
      FBitmap := TBitmap.Create;
      try
        FBitmap.LoadFromStream(Ms);
        if not (FBitmap.PixelFormat = pf32bit) then
          BitmapToAlpha(FBitmap, clFuchsia);
      except
        FBitmap.Free;
        FBitmap := nil
      end;
      Exit;
    end;
    //check for icon image with the extension
    if SameText(ExtractFileExt(ImageName), '.ico') then
    begin
      AIcon := TIcon.Create;
      try
        AIcon.LoadFromStream(Ms);
        FBitmap := IconToBitmap(AIcon);
      finally
        AIcon.Free;
      end;
    end;
  end;

  procedure SetIconImage;
  begin
    { TODO -oMazin -c : add suport for png and bmp image, convert to icon 24/08/2012 22:30:27 }
    Ms.Position := 0;
    FIcon := TIcon.Create;
    try
      FIcon.LoadFromStream(Ms);
    except
      FIcon.Free;
      FIcon := nil;
    end;
  end;

  function MsFileExist: Boolean;
  begin
    Result := False;
    case Tp of
      FILE_TYPE_BZIP2: Result := FindedTarFile(SrcName, Ts);
      FILE_TYPE_ZIP: Result := FindedZipFile(SrcName, Zp);
    end;
  end;

  procedure AddSourcesFiles;
  var
    X: Integer;
  begin
    // C Files
    if ini.SectionExists('Files') then
    begin
      ini.ReadSection('Files', List);
      for X := 0 to List.Count - 1 do
      begin
        if SameText(List.Strings[X], 'Default') then
        begin
          Temp := ini.ReadString('Files', List.Strings[X], '');
          Temp := ini.ReadString('Files', Temp, '');
        end
        else
        begin
          SrcName := ini.ReadString('Files', List.Strings[X], '');
          if MsFileExist then
            SourceFiles.Insert(SrcName);
        end;
      end;
      SourceFiles.FDefFile := SourceFiles.FList.IndexOf(Temp);
    end;

    //C++ Files
    if ini.SectionExists('FilesCpp') then
    begin
      ini.ReadSection('FilesCpp', List);
      for X := 0 to List.Count - 1 do
      begin
        if SameText(List.Strings[X], 'Default') then
        begin
          Temp := ini.ReadString('FilesCpp', List.Strings[X], '');
          Temp := ini.ReadString('FilesCpp', Temp, '');
        end
        else
        begin
          SrcName := ini.ReadString('FilesCpp', List.Strings[X], '');
          if MsFileExist then
            CppSourceFiles.Insert(SrcName);
        end;
      end;
      CppSourceFiles.FDefFile := CppSourceFiles.FList.IndexOf(Temp);
    end;
  end;

  procedure AddResourcesFiles;
  var
    X: Integer;
  begin
    if ini.SectionExists('Resources') then
    begin
      ini.ReadSectionValues('Resources', List);
      for X := 0 to List.Count - 1 do
      begin
        SrcName := List.Strings[X];
        if MsFileExist then
          Resources.Insert(SrcName);
      end;
    end;
  end;

begin
  Result := False;
  try
    Fs := TFileStream.Create(Template, fmOpenRead + fmShareDenyWrite);
  except
    Exit;
  end;
  Ft[2] := #0;
  Fs.Read(Ft, 2 * SizeOf(AnsiChar));
  if string(Ft) = 'BZ' then
  begin
    Tp := FILE_TYPE_BZIP2;
  end
  else if string(Ft) = 'PK' then
  begin
    Tp := FILE_TYPE_ZIP;
  end
  else
  begin
    Fs.Free;
    Exit;
  end;

  Fs.Position := 0;
  Ms := TMemoryStream.Create;
  List := TStringList.Create;
  ini := TMemIniFile.Create('');

  case Tp of
    FILE_TYPE_BZIP2:
      begin
        Ts := TMemoryStream.Create;
        if ExtractBzip2File(Fs, Ts) then
        begin
          if FindTarFile('*.ini', Ts, Ms) then
          begin
            SetIniFile;
            ImageName := ini.ReadString('Falcon', 'ListImage', '');
            if FindTarFile(ImageName, Ts, Ms) then
              SetListImage;
            IconName := ini.ReadString('Falcon', 'AppIcon', '');
            if FindTarFile(IconName, Ts, Ms) then
              SetIconImage;
            AddSourcesFiles;
            AddResourcesFiles;
          end
          else
          begin
            Ms.Free;
            Fs.Free;
            Ts.Free;
            ini.Free;
            List.Free;
            Exit;
          end;
        end;
        Ts.Free;
      end;
    FILE_TYPE_ZIP:
      begin
        Zp := TKAZip.Create(nil);
        Zp.Open(Fs);
        if FindZipFile('*.ini', Zp, Ms) then
        begin
          SetIniFile;
          ImageName := ini.ReadString('Falcon', 'ListImage', '');
          if FindZipFile(ImageName, Zp, Ms) then
            SetListImage;
          IconName := ini.ReadString('Falcon', 'AppIcon', '');
          if FindZipFile(IconName, Zp, Ms) then
            SetIconImage;
          AddSourcesFiles;
          AddResourcesFiles;
        end
        else
        begin
          Ms.Free;
          Fs.Free;
          Zp.Free;
          ini.Free;
          List.Free;
          Exit;
        end;
        Zp.Free;
      end;
  end;
  Ms.Free;
  Fs.Free;

  FDescription := ini.ReadString('Falcon', 'Description', '');
  FCaption := ini.ReadString('Falcon', 'Caption', '');
  compiler := ini.ReadString('Falcon', 'Type', 'C');
  if SameText(compiler, 'C') or SameText(compiler, 'CC') then
    FCompilerType := COMPILER_C
  else if SameText(compiler, 'CPP') or
    SameText(compiler, 'C++') or
    SameText(compiler, 'CXX') then
    FCompilerType := COMPILER_CPP
  else if SameText(compiler, 'RC') then
    FCompilerType := COMPILER_RC
  else if SameText(compiler, 'USER_DEFINED') or
    SameText(compiler, 'USER') or
    SameText(compiler, 'DEFINED') then
    FCompilerType := USER_DEFINED
  else
    FCompilerType := NO_COMPILER;
  Temp := ini.ReadString('Falcon', 'AppType', 'Console');
  FAppType := GetAppTypeByName(Temp);

  FSheet := ini.ReadString('Falcon', 'Sheet', 'Basic');
  FFlags := ini.ReadString('Falcon', 'Flags', '');
  FLibs := ini.ReadString('Falcon', 'Libs', '');
  FParams := ini.ReadString('Falcon', 'Params', '');

  ActualMenu := FalconHelp;
  if ini.SectionExists('Help') then
  begin
    ini.ReadSection('Help', List);
    IsSubMn := False;
    if (List.Count > 0) then
    begin
      for I := 0 to List.Count - 1 do
      begin
        if IsSubMenu(ini.ReadString('Help', List.Strings[I], '')) then
        begin
          IsSubMn := True;
          if not findMenu(List.Strings[I], ActualMenu, FHelpMenu) then
          begin
            FHelpMenu := TDataSubMenuItem.Create(FalconHelp.Owner);
            FHelpMenu.HelpFile := '(None)';
            FHelpMenu.Caption := List.Strings[I];
            FHelpMenu.ImageIndex := 21;
            ActualMenu.Add(FHelpMenu);
          end;
          ActualMenu := FHelpMenu;
          SubMCap := GetSubMenu(ini.ReadString('Help', List.Strings[I], ''));
        end
        else
        begin
          if IsSubMn then
          begin
            IsSubMn := False;
            SubMenu := TDataMenuItem.Create(FalconHelp.Owner);
            SubMenu.HelpFile := ini.ReadString('Help', List.Strings[I], '');
            SubMenu.Caption := SubMCap;
            ExtStr := UpperCase(ExtractFileExt(SubMenu.HelpFile));
            if (ExtStr = '.HTML') or (ExtStr = '.HTM') then
              SubMenu.ImageIndex := 31
            else if (ExtStr = '.CHM') then
              SubMenu.ImageIndex := 49
            else
            begin
              FileType := GetFileType(SubMenu.HelpFile);
              case FileType of
                FILE_TYPE_PROJECT..FILE_TYPE_RC:
                  SubMenu.ImageIndex := FileType;
              else
                SubMenu.ImageIndex := 30;
              end;
            end;
            SubMenu.OnClick := FalconHelp.Items[0].OnClick;
            FHelpMenu.Add(SubMenu);
          end
          else
          begin
            SubMenu := TDataMenuItem.Create(FalconHelp.Owner);
            SubMenu.HelpFile := ini.ReadString('Help', List.Strings[I], '');
            SubMenu.Caption := List.Strings[I];
            ExtStr := UpperCase(ExtractFileExt(SubMenu.HelpFile));
            if (ExtStr = '.HTML') or (ExtStr = '.HTM') then
              SubMenu.ImageIndex := 31
            else if (ExtStr = '.CHM') then
              SubMenu.ImageIndex := 49
            else
            begin
              FileType := GetFileType(SubMenu.HelpFile);
              case FileType of
                FILE_TYPE_PROJECT..FILE_TYPE_RC:
                  SubMenu.ImageIndex := FileType;
              else
                SubMenu.ImageIndex := 30;
              end;
            end;
            SubMenu.OnClick := FalconHelp.Items[0].OnClick;
            if Assigned(FHelpMenu) then
              FHelpMenu.Add(SubMenu)
            else
              ActualMenu.Add(SubMenu);
          end;
        end;
      end;
    end;
  end;
  List.Free;
  ini.Free;
  FFileName := Template;
  Result := True;
end;

constructor TTemplates.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTemplates.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TTemplates.GetTemplate(Index: Integer): TTemplate;
begin
  Result := nil;
  if (Index >= 0) and (Index < FList.Count) then
    Result := TTemplate(FList.Items[Index]);
end;

procedure TTemplates.SetTemplate(Index: Integer; Value: TTemplate);
begin
  if (Index >= 0) and (Index < FList.Count) then
  begin
    TTemplate(FList.Items[Index]).Free;
    FList.Items[Index] := Value;
  end;
end;

function TTemplates.Count: Integer;
begin
  Result := FList.Count;
end;

function TTemplates.Insert(Template: TTemplate): Integer;
begin
  Result := FList.Add(Template);
end;

function TTemplates.Delete(Index: Integer): Boolean;
begin
  Result := False;
  if (Index >= 0) and (Index < FList.Count) then
  begin
    TTemplate(FList.Items[Index]).Free;
    FList.Delete(Index);
  end;
end;

function TTemplates.Find(TemplateID: TTemplateID): TTemplate;
begin
  Result := Find(TemplateID.Sheet, TemplateID.Caption);
end;

function TTemplates.Find(const Sheet, Caption: string): TTemplate;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if SameText(Sheet, Templates[I].Sheet) and
       SameText(Caption, Templates[I].Caption) then
    begin
      Result := Templates[I];
      Exit;
    end;
  end;
end;

procedure TTemplates.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

end.
