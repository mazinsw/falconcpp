unit UFrmPkgDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, ImgList, ExtCtrls, StdCtrls, ComCtrls,
  RichEdit, FileDownload, XMLDoc, XMLIntf, UPkgClasses, rbtree, Contnrs,
  ThreadFileDownload, FormEffect, PNGImage;

const
  {$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
  {$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER+10;

type
  TPkgFinishEvent = procedure(Sender: TObject; Sucess: Boolean) of object;
  TThreadInstallPkg = class(TThread)
  private
    FFileName: string;
    FOnStart: TNotifyEvent;
    FOnFinish: TPkgFinishEvent;
    FSucess: Boolean;
    FReparse: Boolean;
    procedure DoStart;
    procedure DoFinish;
  protected
    procedure Execute; override;
  public
    constructor Create(FileName: string);
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnFinish: TPkgFinishEvent read FOnFinish write FOnFinish;
  end;

  TInstallPkg = class
    FFileName: string;
    FOnStart: TNotifyEvent;
    FOnFinish: TPkgFinishEvent;
    FBusy: Boolean;
    procedure ThreadOnStart(Sender: TObject);
    procedure ThreadOnFinish(Sender: TObject; Sucess: Boolean);
  public
    property FileName: string read FFileName write FFileName;
    procedure Start(Reparse: Boolean = False);
    property Busy: Boolean read FBusy write FBusy;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnFinish: TPkgFinishEvent read FOnFinish write FOnFinish;
  end;

  TThreadUninstallPkg = class(TThreadInstallPkg)
  protected
    procedure Execute; override;
  end;

  TUninstallPkg = class
    FName: string;
    FOnStart: TNotifyEvent;
    FOnFinish: TPkgFinishEvent;
    FBusy: Boolean;
    procedure ThreadOnStart(Sender: TObject);
    procedure ThreadOnFinish(Sender: TObject; Sucess: Boolean);
  public
    property Name: string read FName write FName;
    procedure Start;
    property Busy: Boolean read FBusy write FBusy;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnFinish: TPkgFinishEvent read FOnFinish write FOnFinish;
  end;

  TFrmPkgDownload = class(TForm)
    ImageList16x16: TImageList;
    GroupBox1: TGroupBox;
    TreeViewPackages: TVirtualStringTree;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    BtnCancel: TButton;
    LabelProgresss: TLabel;
    GroupBox2: TGroupBox;
    Image1: TImage;
    TextDesc: TRichEdit;
    Label5: TLabel;
    LblSite: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    LabelName: TLabel;
    LabelVersion: TLabel;
    FileDownloadXML: TFileDownload;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    FileDownloadPkg: TFileDownload;
    Label6: TLabel;
    EditSearch: TEdit;
    Splitter1: TSplitter;
    procedure FormResize(Sender: TObject);
    procedure FileDownloadXMLProgress(Sender: TObject; ReceivedBytes,
      CalculatedFileSize: Cardinal);
    procedure FileDownloadXMLStart(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FileDownloadXMLFinish(Sender: TObject; State: TDownloadState;
      Canceled: Boolean);
    procedure TreeViewPackagesGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure TreeViewPackagesChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure BtnCancelClick(Sender: TObject);
    procedure TreeViewPackagesGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure LblSiteClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TreeViewPackagesChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FileDownloadPkgFinish(Sender: TObject; State: TDownloadState;
      Canceled: Boolean);
    procedure TreeViewPackagesChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure FileDownloadPkgStart(Sender: TObject);
    procedure FileDownloadPkgProgress(Sender: TObject; ReceivedBytes,
      CalculatedFileSize: Cardinal);
    procedure Button2Click(Sender: TObject);
    procedure EditSearchChange(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
  private
    { Private declarations }
    InstalledCount: Integer;
    Ms: TMemoryStream;
    CategoryList: TCategoryList;
    Canceled: Boolean;
    Marqueue, CloseOnFinish: Boolean;
    LoadingPkg: Integer;
    InstallList: TRBTree;
    UninstallList: TRBTree;
    InstallQueue: TQueue;
    InstallPkgQueue: TQueue;
    InstalingList: TPackageList;
    UninstallQueue: TQueue;
    UninstalingList: TPackageList;
    ConfigRoot, DownloadedPackagesRoot: string;
    InstallPkg: TInstallPkg;
    UninstallPkg: TUninstallPkg;
    PkgImg: TPngImage;
    procedure DownloadPackageList;
    procedure ReloadPackages;
    procedure SearchPackage(const S: string);
    procedure ChangePackageState(Sender: TObject; Pkg: TPackage);
    procedure UpdateButtonsCaption;
    function DownloadPackageFromQueue: Boolean;
    procedure InstallDownloadedPackages;
    function UninstallPackageFromQueue: Boolean;
    procedure UninstallPackages;
    procedure InstallPkgFinish(Sender: TObject; Sucess: Boolean);
    procedure InstallPkgStart(Sender: TObject);
    procedure UninstallPkgFinish(Sender: TObject; Sucess: Boolean);
    procedure UninstallPkgStart(Sender: TObject);
    procedure LoadInternetConfiguration;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure ApplyTranslation;
  end;

var
  FrmPkgDownload: TFrmPkgDownload;

function InstallPackages(ParentWindow: HWND): Integer;

implementation

uses UInstaller, UFrmPkgMan, ShlObj, UUninstaller, PkgUtils, ULanguages,
  IniFiles, SystemUtils, AppConst;

{$R *.dfm}

function InstallPackages(ParentWindow: HWND): Integer;
begin
  FrmPkgDownload := TFrmPkgDownload.CreateParented(ParentWindow);
  FrmPkgDownload.ShowModal;
  Result := FrmPkgDownload.InstalledCount;
  FrmPkgDownload.Free;
end;

procedure ProgressbarSetMarqueue(Progressbar: TProgressBar);
begin
  Progressbar.Position := 0;
  SetWindowLong(Progressbar.Handle, GWL_STYLE,
    GetWindowLong(Progressbar.Handle, GWL_STYLE) or PBS_MARQUEE);
  SendMessage(Progressbar.Handle, PBM_SETMARQUEE, 1, 0);
end;

procedure ProgressbarSetNormal(Progressbar: TProgressBar);
begin
  SetWindowLong(Progressbar.Handle, GWL_STYLE,
    GetWindowLong(Progressbar.Handle, GWL_STYLE) and not PBS_MARQUEE);
  SendMessage(Progressbar.Handle, PBM_SETMARQUEE, 0, 0);
end;

procedure TFrmPkgDownload.DownloadPackageList;
begin
  Ms.Clear;
  FileDownloadXML.Start(Ms);
end;

procedure TFrmPkgDownload.SearchPackage(const S: string);
var
  I, J, K, PkgCount, LibCount, CatCount: Integer;
  PCategory, PLibrary, PPackage: PVirtualNode;
  CategoryItem: TCategory;
  LibraryItem: TLibrary;
  PackageItem: TPackage;
begin
  Inc(LoadingPkg);
  TreeViewPackages.Clear;
  CatCount := 0;
  for I := 0 to CategoryList.Count - 1 do
  begin
    CategoryItem := CategoryList.Items[I];
    PCategory := TreeViewPackages.AddChild(nil, CategoryItem);
    TreeViewPackages.CheckType[PCategory] := ctTriStateCheckBox;
    LibCount := 0;
    for J := 0 to CategoryItem.Count - 1 do
    begin
      LibraryItem := CategoryItem.Items[J];
      PLibrary := TreeViewPackages.AddChild(PCategory, LibraryItem);
      TreeViewPackages.CheckType[PLibrary] := ctTriStateCheckBox;
      PkgCount := 0;
      for K := 0 to LibraryItem.Count - 1 do
      begin
        PackageItem := LibraryItem.Items[K];
        PackageItem.Data := nil;
        if (not CheckBox1.Checked and not PackageItem.Installed) or
          (not CheckBox2.Checked and PackageItem.Installed) or
          ((S <> '') and (Pos(S, UpperCase(PackageItem.Name)) = 0)) then
          Continue;
        Inc(PkgCount);
        PPackage := TreeViewPackages.AddChild(PLibrary, PackageItem);
        PackageItem.Data := PPackage;
        TreeViewPackages.CheckType[PPackage] := ctCheckBox;
        if PackageItem.Installed then
        begin
          if PackageItem.State = psUninstall then
            TreeViewPackages.CheckState[PPackage] := csUncheckedNormal
          else
            TreeViewPackages.CheckState[PPackage] := csCheckedNormal;
        end
        else if PackageItem.State = psInstall then
          TreeViewPackages.CheckState[PPackage] := csCheckedNormal
        else
          TreeViewPackages.CheckState[PPackage] := csUncheckedNormal;
      end;
      if PkgCount = 0 then
        TreeViewPackages.DeleteNode(PLibrary)
      else
        Inc(LibCount);
    end;
    if LibCount = 0 then
      TreeViewPackages.DeleteNode(PCategory)
    else
      Inc(CatCount);
  end;
  if (CatCount = 1) then
  begin
    PCategory := TreeViewPackages.GetFirst;
    TreeViewPackages.Expanded[PCategory] := True;
    LibCount := TreeViewPackages.ChildCount[PCategory];
    if LibCount < 3 then
    begin
      PLibrary := TreeViewPackages.GetFirstChild(PCategory);
      TreeViewPackages.Expanded[PLibrary] := True;
    end;
  end;
  Dec(LoadingPkg);
end;

procedure TFrmPkgDownload.ReloadPackages;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := Temp.Attributes[Attribute]
    else
      Result := '';
  end;

  function GetTagContent(Node: IXMLNode; Tag: string): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := Temp.Text
    else
      Result := '';
  end;

  procedure LoadDone;
  begin
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[13];
    BtnCancel.Enabled := False;
  end;

var
  XMLDoc: TXMLDocument;
  RootNode, CategoryNode, LibraryNode, PackageNode, DependencyNode: IXMLNode;
  CategoryItem: TCategory;
  LibraryItem: TLibrary;
  PackageItem, OtherPackageVersion: TPackage;
  DependencyItem: TDependency;
  BuildDependencyList: TList;
  I, J: Integer;
  fmt: TFormatSettings;
  pkgList: TRBTree;
begin
  fmt.ShortDateFormat:='yyyy-mm-dd';
  fmt.DateSeparator  :='-';
  fmt.LongTimeFormat :='hh:nn:ss';
  fmt.TimeSeparator  :=':';
  Ms.Position := 0;
  ProgressBar1.Position := 0;
  LabelProgresss.Caption := STR_FRM_PKG_DOWN[14];
  XMLDoc := TXMLDocument.Create(Self);
  try
    XMLDoc.LoadFromStream(Ms);
  except
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[15];
    BtnCancel.Caption := STR_FRM_PKG_DOWN[16];
    BtnCancel.Enabled := True;
    Exit;
  end;
  RootNode := XMLDoc.ChildNodes.FindNode('categories');
  if RootNode = nil then
  begin
    LoadDone;
    Exit;
  end;
  CategoryList.Clear;
  BuildDependencyList := TList.Create;
  pkgList := TRBTree.Create;
  CategoryNode := RootNode.ChildNodes.First;
  while (CategoryNode <> nil) do
  begin
    CategoryItem := TCategory.Create;
    CategoryList.Add(CategoryItem);
    CategoryItem.Name := CategoryNode.Attributes['name'];
    LibraryNode := CategoryNode.ChildNodes.First;
    while (LibraryNode <> nil) do
    begin
      LibraryItem := TLibrary.Create;
      CategoryItem.Add(LibraryItem);
      LibraryItem.Name := LibraryNode.Attributes['name'];
      LibraryItem.WebSite := LibraryNode.Attributes['website'];
      LibraryItem.Description := GetTagContent(LibraryNode, 'description');
      PackageNode := LibraryNode.ChildNodes.FindNode('packages');
      if PackageNode <> nil then
        PackageNode := PackageNode.ChildNodes.First;
      while (PackageNode <> nil) do
      begin
        PackageItem := TPackage.Create;
        LibraryItem.Add(PackageItem);
        PackageItem.Name := PackageNode.Attributes['name'];
        PackageItem.Version := PackageNode.Attributes['version'];
        PackageItem.Size := StrToInt(PackageNode.Attributes['size']);
        PackageItem.URL := PackageNode.Attributes['url'];
        PackageItem.LastModified := StrToDateTime(PackageNode.Attributes['lastmodified'], fmt);
        PackageItem.GCCVersion := PackageNode.Attributes['gccversion'];
        PackageItem.Description := GetTagContent(PackageNode, 'description');
        PackageItem.Installed := FrmPkgMan.PackageInstalled(PackageItem.Name, PackageItem.Version);
        pkgList.Items[PackageItem.Name + ' ' + PackageItem.Version] := PackageItem;
        DependencyNode := PackageNode.ChildNodes.FindNode('dependency');
        if DependencyNode <> nil then
          DependencyNode := DependencyNode.ChildNodes.First;
        while (DependencyNode <> nil) do
        begin
          DependencyItem := TDependency.Create;
          DependencyItem.Package := PackageItem;
          DependencyItem.Name := DependencyNode.Attributes['name'];
          DependencyItem.Version := DependencyNode.Attributes['version'];
          BuildDependencyList.Add(DependencyItem);
          DependencyNode := DependencyNode.NextSibling;
        end;
        PackageNode := PackageNode.NextSibling;
      end;
      LibraryNode := LibraryNode.NextSibling;
    end;
    CategoryNode := CategoryNode.NextSibling;
  end;
  for I := 0 to BuildDependencyList.Count - 1 do
  begin
    DependencyItem := TDependency(BuildDependencyList.Items[I]);
    PackageItem := TPackage(pkgList.Items[DependencyItem.Name + ' ' + DependencyItem.Version]);
    if PackageItem <> nil then
    begin
      DependencyItem.Package.Add(PackageItem);
      PackageItem.OwnerDependencyList.Add(DependencyItem.Package);
      for J := 0 to PackageItem.Owner.Count - 1 do
      begin
        if PackageItem.Owner.Items[J].Name <> PackageItem.Name then
          Continue;
        if PackageItem.Owner.Items[J].Version = PackageItem.Version then
          Continue;
        if TPackage.ComparePkgVersion(PackageItem.Owner.Items[J].Version,
          PackageItem.Version) >= 0 then
        begin
          OtherPackageVersion := PackageItem.Owner.Items[J];
          OtherPackageVersion.OwnerDependencyList.Add(DependencyItem.Package);
        end;
      end;
    end
    else
      raise Exception.CreateFmt(STR_FRM_PKG_DOWN[17],
        [DependencyItem.Name, DependencyItem.Version,
        DependencyItem.Package.Name, DependencyItem.Package.Version]);
    DependencyItem.Free;
  end;
  pkgList.Free;
  BuildDependencyList.Free;
  LoadDone;
  SearchPackage(UpperCase(Trim(EditSearch.Text)));
end;

procedure TFrmPkgDownload.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmPkgDownload.FormResize(Sender: TObject);
begin
  TreeViewPackages.Width := GroupBox1.Width - 2 * TreeViewPackages.Left;
  Button2.Top := GroupBox1.Height - Button2.Height - TreeViewPackages.Left;
  Button2.Left := GroupBox1.Width - Button2.Width - TreeViewPackages.Left;
  Button1.Top := Button2.Top - Button1.Height - TreeViewPackages.Left;
  Button1.Left := GroupBox1.Width - Button1.Width - TreeViewPackages.Left;
  CheckBox1.Top := Button1.Top;
  CheckBox2.Top := Button1.Top;
  Label3.Top := CheckBox1.Top + CheckBox1.Height - Label3.Height;
  TreeViewPackages.Height := Label3.Top - TreeViewPackages.Top - TreeViewPackages.Left;
  EditSearch.Top := Button2.Top + (Button2.Height -  EditSearch.Height) div 2;
  Label6.Top := EditSearch.Top + (EditSearch.Height -  Label6.Height) div 2;
  BtnCancel.Left := Panel2.Width - BtnCancel.Width - ProgressBar1.Left;
  TextDesc.Height := GroupBox2.ClientHeight - TextDesc.Top - TextDesc.Left;
  ProgressBar1.Width := BtnCancel.Left - 3 * ProgressBar1.Left;
  TextDesc.Width := GroupBox2.Width - TextDesc.Left * 2;
end;

procedure TFrmPkgDownload.FileDownloadXMLProgress(Sender: TObject;
  ReceivedBytes, CalculatedFileSize: Cardinal);
begin
  if CalculatedFileSize > 0 then
  begin
    if Marqueue then
    begin
      Marqueue := False;
      ProgressbarSetNormal(ProgressBar1);
    end;
    ProgressBar1.Position := Round((ReceivedBytes / CalculatedFileSize) * 100);
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[18],
      [(ReceivedBytes / CalculatedFileSize) * 100]);
  end
  else
  begin
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[19];
  end;
end;

procedure TFrmPkgDownload.FileDownloadXMLStart(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  if not Marqueue then
  begin
    Marqueue := True;
    ProgressbarSetMarqueue(ProgressBar1);
  end;
  Panel2.Visible := True;
  LabelProgresss.Caption := STR_FRM_PKG_DOWN[19];
  BtnCancel.Enabled := True;
  FormResize(Self);
end;

procedure TFrmPkgDownload.UpdateButtonsCaption;
begin
  if InstallList.Count = 0 then
    Button1.Caption := STR_FRM_PKG_DOWN[11]
  else if InstallList.Count = 1 then
    Button1.Caption := Format(STR_FRM_PKG_DOWN[20], [InstallList.Count])
  else
    Button1.Caption := Format(STR_FRM_PKG_DOWN[21], [InstallList.Count]);
  Button1.Enabled := (InstallList.Count > 0) and not FileDownloadPkg.IsBusy and
    not (InstallPkgQueue.Count > 0) and (UninstallList.Count = 0) and
      (UninstallQueue.Count = 0);
  if UninstallList.Count = 0 then
    Button2.Caption := STR_FRM_PKG_DOWN[12]
  else if UninstallList.Count = 1 then
    Button2.Caption := Format(STR_FRM_PKG_DOWN[22], [UninstallList.Count])
  else
    Button2.Caption := Format(STR_FRM_PKG_DOWN[23], [UninstallList.Count]);
  Button2.Enabled := (UninstallList.Count > 0) and (UninstallQueue.Count = 0);
end;

procedure TFrmPkgDownload.ChangePackageState(Sender: TObject; Pkg: TPackage);
var
  Node: PVirtualNode;
begin
  Inc(LoadingPkg);
  Node := Pkg.Data;
  if Pkg.Installed then
  begin
    if Pkg.State = psUninstall then
    begin
      if Node <> nil then
        TreeViewPackages.CheckState[Node] := csUncheckedNormal;
      UninstallList.Add(Pkg.Name + ' ' + Pkg.Version, Pkg);
      InstallList.Delete(Pkg.Name + ' ' + Pkg.Version);
    end
    else
    begin
      if Node <> nil then
        TreeViewPackages.CheckState[Node] := csCheckedNormal;
      UninstallList.Delete(Pkg.Name + ' ' + Pkg.Version);
      if Pkg.State = psInstall then
        InstallList.Add(Pkg.Name + ' ' + Pkg.Version, Pkg);
    end;
  end
  else
  begin
    if Pkg.State = psInstall then
    begin
      if Node <> nil then
        TreeViewPackages.CheckState[Node] := csCheckedNormal;
      InstallList.Add(Pkg.Name + ' ' + Pkg.Version, Pkg);
    end
    else
    begin
      if Node <> nil then
        TreeViewPackages.CheckState[Node] := csUncheckedNormal;
      InstallList.Delete(Pkg.Name + ' ' + Pkg.Version);
    end;
  end;
  UpdateButtonsCaption;
  Dec(LoadingPkg);
end;

procedure TFrmPkgDownload.LoadInternetConfiguration;
var
  FalconDir, AlterConfIni, ConfigPath: String;
  ini: TIniFile;
begin
  FalconDir := GetFalconDir;
  ConfigPath := GetConfigDir(FalconDir);
  ini := TIniFile.Create(ConfigPath + CONFIG_NAME);
  AlterConfIni := ini.ReadString('EnvironmentOptions', 'ConfigurationFile', '');
  if ini.ReadBool('EnvironmentOptions', 'AlternativeConfFile', False) and
    FileExists(AlterConfIni) then
  begin
    ini.Free;
    ini := TIniFile.Create(AlterConfIni);
  end;
  FileDownloadXML.Proxy := ini.ReadBool('Proxy', 'Enabled', False);
  FileDownloadXML.Server := ini.ReadString('Proxy', 'IP', 'localhost');
  FileDownloadXML.Port := ini.ReadInteger('Proxy', 'Port', 80);

  FileDownloadPkg.Proxy := FileDownloadXML.Proxy;
  FileDownloadPkg.Server := FileDownloadXML.Server;
  FileDownloadPkg.Port := FileDownloadXML.Port;
  ini.Free;
end;

procedure TFrmPkgDownload.FormCreate(Sender: TObject);
begin
  Canceled := False;
  LoadInternetConfiguration;
  ApplyTranslation;
  TreeViewPackages.NodeDataSize := SizeOf(Pointer);
  PkgImg := GetPNGResource('PKGIMG');
  AddImages(ImageList16x16, 'IMAGES_16x16');
  ConfigRoot := GetConfigDir(GetFalconDir);
  DownloadedPackagesRoot := ConfigRoot + 'Downloaded packages\';
  if not DirectoryExists(DownloadedPackagesRoot) then
    ForceDirectories(DownloadedPackagesRoot);
  Ms := TMemoryStream.Create;
  InstallList := TRBTree.Create;
  InstalingList := TPackageList.Create;
  InstallQueue := TQueue.Create;
  InstallPkgQueue := TQueue.Create;

  UninstallList := TRBTree.Create;
  UninstalingList := TPackageList.Create;
  UninstallQueue := TQueue.Create;
  CategoryList := TCategoryList.Create;
  CategoryList.OnChangeState := ChangePackageState;
  InstallPkg := TInstallPkg.Create;
  InstallPkg.OnStart := InstallPkgStart;
  InstallPkg.OnFinish := InstallPkgFinish;
  UninstallPkg := TUninstallPkg.Create;
  UninstallPkg.OnStart := UninstallPkgStart;
  UninstallPkg.OnFinish := UninstallPkgFinish;
  DownloadPackageList;
end;

procedure TFrmPkgDownload.FormDestroy(Sender: TObject);
begin
  PkgImg.Free;
  UninstallPkg.Free;
  InstallPkg.Free;
  CategoryList.Free;
  UninstallQueue.Free;
  UninstalingList.Free;
  UninstallList.Free;
  InstallPkgQueue.Free;
  InstallQueue.Free;
  InstalingList.Free;
  InstallList.Free;
  Ms.Free;
end;

procedure TFrmPkgDownload.FileDownloadXMLFinish(Sender: TObject;
   State: TDownloadState; Canceled: Boolean);
begin
  if CloseOnFinish then
  begin
    if not FileDownloadPkg.IsBusy then
      Close;
    Exit;
  end;
  if Marqueue then
  begin
    Marqueue := False;
    ProgressbarSetNormal(ProgressBar1);
  end;
  if not Canceled and (Ms.Size > 0) then
    ReloadPackages
  else if Canceled then
  begin
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[24];
    BtnCancel.Enabled := False;
  end
  else
  begin
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[25];
    BtnCancel.Enabled := False;
  end;
end;

procedure TFrmPkgDownload.TreeViewPackagesGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  Data: TObject;
begin
  Data := TObject(Sender.GetNodeData(Node)^);
  case Column of
    0:
    begin
      if Data is TCategory then
        CellText := TCategory(Data).Name
      else if Data is TLibrary then
        CellText := TLibrary(Data).Name
      else if Data is TPackage then
        CellText := TPackage(Data).Name + ' ' + TPackage(Data).Version;
    end;
    1:
    begin
      if Data is TPackage then
        CellText := TPackage(Data).Version
      else
        CellText := '';
    end;
    2:
    begin
      if Data is TPackage then
        CellText := HummanSize(TPackage(Data).Size)
      else
        CellText := '';
    end;
    3:
    begin
      if Data is TPackage then
      begin
        if TPackage(Data).Installed then
        begin
          if TPackage(Data).State = psUninstall then
            CellText := STR_FRM_PKG_DOWN[26]
          else
            CellText := STR_FRM_PKG_DOWN[27];
        end
        else
        begin
          if TPackage(Data).State = psInstall then
            CellText := STR_FRM_PKG_DOWN[28]
          else
            CellText := STR_FRM_PKG_DOWN[29];
        end;
      end
      else
        CellText := '';
    end;
  end;
end;

procedure TFrmPkgDownload.TreeViewPackagesChange(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: TObject;
begin
  if Node = nil then
    Exit;
  Data := TObject(Sender.GetNodeData(Node)^);
  if Data is TPackage then
  begin
    GroupBox2.Visible := True;
    Splitter1.Visible := True;
    Image1.Picture.Assign(PkgImg);
    FormResize(Self);
    LabelName.Caption := TPackage(Data).Name;
    LabelVersion.Caption := TPackage(Data).Version;
    LblSite.Caption := TPackage(Data).Owner.WebSite;
    LblSite.Hint := TPackage(Data).Owner.WebSite;
    if TPackage(Data).Description <> '' then
      TextDesc.Text := TPackage(Data).Description
    else
      TextDesc.Text := TPackage(Data).Owner.Description;
  end
  else
  begin
    GroupBox2.Visible := False;
    Splitter1.Visible := False;
    FormResize(Self);
  end;
end;

procedure TFrmPkgDownload.BtnCancelClick(Sender: TObject);
begin
  Canceled := True;
  BtnCancel.Enabled := False;
  if FileDownloadXML.IsBusy then
    FileDownloadXML.Stop;
  if FileDownloadPkg.IsBusy then
    FileDownloadPkg.Stop;
end;

procedure TFrmPkgDownload.TreeViewPackagesGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: TObject;
begin
  Data := TObject(Sender.GetNodeData(Node)^);
  if Column = 0 then
  begin
    if Data is TCategory then
      ImageIndex := 1
    else if Data is TLibrary then
      ImageIndex := 3
    else if Data is TPackage then
      ImageIndex := 2;
  end
  else if Column = 3 then
  begin
    if Data is TPackage then
    begin
      if TPackage(Data).Installed then
      begin
        if TPackage(Data).State = psInstall then
          ImageIndex := 5
        else if TPackage(Data).State = psUninstall then
          ImageIndex := 7
        else
          ImageIndex := 4;
      end
      else if TPackage(Data).State = psInstall then
        ImageIndex := 6;
    end;
  end;
end;

procedure TFrmPkgDownload.LblSiteClick(Sender: TObject);
var
  Data: TObject;
begin
  if TreeViewPackages.SelectedCount > 0 then
  begin
    Data := TObject(TreeViewPackages.GetNodeData(TreeViewPackages.GetFirstSelected)^);
    Execute(TPackage(Data).Owner.WebSite);
  end;
end;

procedure TFrmPkgDownload.CheckBox1Click(Sender: TObject);
begin
  SearchPackage('');
end;

procedure TFrmPkgDownload.TreeViewPackagesChecked(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: TObject;
  State: TCheckState;
begin
  if LoadingPkg > 0 then
    Exit;
  Data := TObject(Sender.GetNodeData(Node)^);
  State := Sender.CheckState[Node];
  if Data is TPackage then
  begin
    if TPackage(Data).Installed then
    begin
      if State = csUncheckedNormal then
        TPackage(Data).State := psUninstall
      else
        TPackage(Data).State := psNone;
    end
    else if State = csCheckedNormal then
      TPackage(Data).State := psInstall
    else
      TPackage(Data).State := psNone;
  end;
end;

procedure TFrmPkgDownload.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  I: Integer;
begin
  if CloseOnFinish and (FileDownloadXML.IsBusy or FileDownloadPkg.IsBusy) then
  begin
    Action := caNone;
    Exit;
  end;
  if FileDownloadXML.IsBusy or FileDownloadPkg.IsBusy then
  begin
    I := IDYES;
    if FileDownloadPkg.IsBusy then
     I := MessageBox(Handle, PChar(STR_FRM_PKG_DOWN[30]),
      PChar(STR_FRM_PKG_DOWN[1]), MB_YESNOCANCEL+MB_DEFBUTTON2);
    Action := caNone;
    if I = IDYES then
    begin
      CloseOnFinish := True;
      FileDownloadXML.Stop;
      FileDownloadPkg.Stop;
    end;
    Exit;
  end;
  Action := caFree;
end;

procedure TFrmPkgDownload.TreeViewPackagesChecking(
  Sender: TBaseVirtualTree; Node: PVirtualNode;
  var NewState: TCheckState; var Allowed: Boolean);
var
  Data: TObject;
begin
  if LoadingPkg > 0 then
    Exit;
  Data := TObject(Sender.GetNodeData(Node)^);
  if Data is TPackage then
  begin
    if TPackage(Data).InstaledPackage(TPackage(Data).Name) then
    begin
      Allowed := False;
      MessageBox(Handle, PChar(STR_FRM_PKG_DOWN[31]), PChar(STR_FRM_PKG_DOWN[1]), MB_ICONINFORMATION);
      Exit;
    end
    else if not TPackage(Data).CanInstall then
    begin
      Allowed := False;
      MessageBox(Handle, PChar(STR_FRM_PKG_DOWN[32]), PChar(STR_FRM_PKG_DOWN[1]), MB_ICONINFORMATION);
      Exit;
    end
    else if (NewState = csUncheckedNormal) and ((TPackage(Data).Installed and
      (TPackage(Data).State <> psUninstall)) or
      (TPackage(Data).State = psInstall)) and not TPackage(Data).CanUninstall then
    begin
      Allowed := False;
      MessageBox(Handle, PChar(STR_FRM_PKG_DOWN[33]), PChar(STR_FRM_PKG_DOWN[1]), MB_ICONINFORMATION);
      Exit;
    end;
  end;
end;

procedure TFrmPkgDownload.InstallDownloadedPackages;
var
  Package: TPackage;
  file_fpk: string;
begin
  if InstallPkgQueue.Count > 0 then
  begin
    Package := TPackage(InstallPkgQueue.Peek);
    file_fpk := DownloadedPackagesRoot + Package.Name + ' ' +
      Package.Version + '.fpk';
    if not FileExists(file_fpk) then
    begin
      MessageBox(Handle, PChar(Format(STR_FRM_PKG_DOWN[34], [file_fpk])),
        PChar(Caption), MB_ICONERROR);
      LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[34],
        [Package.Name + ' ' + Package.Version + '.fpk']);
      ProgressBar1.Position := 0;
      BtnCancel.Enabled := False;
      Button1.Enabled := True;
      while InstallPkgQueue.Count > 0 do InstallPkgQueue.Pop;
      InstalingList.Clear;
      Exit; // error
    end;
    ProgressBar1.Position := Round(50 * ((InstalingList.Count - InstallQueue.Count)
      / InstalingList.Count) + 50 * (InstalingList.Count - InstallPkgQueue.Count) / InstalingList.Count);
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[35],
      [Package.Name + ' ' + Package.Version]);
    InstallPkg.FileName := file_fpk;
    InstallPkg.Start(InstallPkgQueue.Count = 1);
  end
  else
  begin
    Inc(InstalledCount, InstalingList.Count);
    InstalingList.Clear;
    UpdateButtonsCaption;
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[36];
    ProgressBar1.Position := 0;
    BtnCancel.Enabled := False;
  end;
end;

function TFrmPkgDownload.DownloadPackageFromQueue: Boolean;
var
  Package: TPackage;
begin
  Result := InstallQueue.Count > 0;
  if not Result or FileDownloadPkg.IsBusy then
    Exit;
  Package := TPackage(InstallQueue.Peek);
  FileDownloadPkg.URL := Package.URL;
  FileDownloadPkg.FileName := DownloadedPackagesRoot + Package.Name + ' ' +
    Package.Version + '.fpk' + FileDownloadPkg.PartExt;
  FileDownloadPkg.Start;
end;

procedure TFrmPkgDownload.Button1Click(Sender: TObject);
var
  Node: PRBNode;
  TempList: TPackageList;
  Package: TPackage;
  Depends: Boolean;
  I, J, K: Integer;
begin
  Canceled := False;
  Node := InstallList.First;
  if Node = nil then
    Exit;
  TempList := TPackageList.Create;
  while Node <> InstallList.Last do
  begin
    TempList.Add(TPackage(Node^.Data));
    RBInc(Node);
  end;
  TempList.Add(TPackage(Node^.Data));
  I := TempList.Count - 1;
  while TempList.Count > 0 do
  begin
    Package := TempList.Items[I];
    K := I;
    Depends := False;
    for J := 0 to Package.Count - 1 do
    begin
      for K := 0 to TempList.Count - 1 do
      begin
        if K = I then
          Continue;
        if TempList.Items[K].Name = Package.Items[J].Name then
        begin
          Depends := True;
          Break;
        end;
      end;
      if Depends then
        Break;
    end;
    if not Depends then
    begin
      InstalingList.Add(Package);
      InstallQueue.Push(Package);
      TempList.Delete(I);
      Dec(I);
      if I < 0 then
        I := TempList.Count - 1;
    end
    else
      I := K;
  end;
  TempList.Free;
  Button1.Enabled := False;
  DownloadPackageFromQueue;
end;

procedure TFrmPkgDownload.UninstallPackages;
var
  Package: TPackage;
begin
  { TODO -oMazin -c : implements on thread 22/09/2012 17:00:06 }
  if UninstallQueue.Count > 0 then
  begin
    Package := TPackage(UninstallQueue.Peek);
    ProgressBar1.Position := Round(100 * ((UninstalingList.Count - UninstallQueue.Count)
      / UninstalingList.Count));
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[37],
      [Package.Name + ' ' + Package.Version]);
    UninstallPkg.Name := Package.Name;
    UninstallPkg.Start;
    Exit;
  end;
  UninstalingList.Clear;
  UpdateButtonsCaption;
  LabelProgresss.Caption := STR_FRM_PKG_DOWN[38];
  ProgressBar1.Position := 0;
  BtnCancel.Enabled := False;
end;

function TFrmPkgDownload.UninstallPackageFromQueue: Boolean;
begin
  Result := UninstallQueue.Count > 0;
  if not Result then
    Exit;
  UninstallPackages;
end;

procedure TFrmPkgDownload.Button2Click(Sender: TObject);
var
  Node: PRBNode;
  TempList: TPackageList;
  Package: TPackage;
  OthersDepends: Boolean;
  I, J, K: Integer;
begin
  Canceled := False;
  Node := UninstallList.First;
  if Node = nil then
    Exit;
  TempList := TPackageList.Create;
  while Node <> UninstallList.Last do
  begin
    TempList.Add(TPackage(Node^.Data));
    RBInc(Node);
  end;
  TempList.Add(TPackage(Node^.Data));
  I := 0;
  while TempList.Count > 0 do
  begin
    Package := TempList.Items[I];
    K := I;
    OthersDepends := False;
    for J := 0 to Package.OwnerDependencyList.Count - 1 do
    begin
      for K := 0 to TempList.Count - 1 do
      begin
        if K = I then
          Continue;
        if TempList.Items[K].Name = Package.OwnerDependencyList.Items[J].Name then
        begin
          OthersDepends := True;
          Break;
        end;
      end;
      if OthersDepends then
        Break;
    end;
    if not OthersDepends then
    begin
      UninstalingList.Add(Package);
      UninstallQueue.Push(Package);
      TempList.Delete(I);
      if I > TempList.Count - 1 then
        I := 0;
    end
    else
      I := K;
  end;
  TempList.Free;
  Button2.Enabled := False;
  UninstallPackageFromQueue;
end;

procedure TFrmPkgDownload.FileDownloadPkgStart(Sender: TObject);
var
  Package: TPackage;
begin
  BtnCancel.Enabled := True;
  if Marqueue then
    ProgressbarSetNormal(ProgressBar1);
  ProgressBar1.Position := Round(50 * ((InstalingList.Count - InstallQueue.Count)
    / InstalingList.Count));
  Package := TPackage(InstallQueue.Peek);
  LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[39],
    [Package.Name + ' ' + Package.Version]);
end;

procedure TFrmPkgDownload.FileDownloadPkgProgress(Sender: TObject;
  ReceivedBytes, CalculatedFileSize: Cardinal);
var
  Package: TPackage;
  StartPos: Double;
begin
  BtnCancel.Enabled := True;
  if Marqueue then
    ProgressbarSetNormal(ProgressBar1);
  StartPos := 50 * ((InstalingList.Count - InstallQueue.Count) / InstalingList.Count);
  if CalculatedFileSize > 0 then
    ProgressBar1.Position := Round(StartPos + (50 / InstalingList.Count) *
      (ReceivedBytes / CalculatedFileSize))
  else
    ProgressBar1.Position := Round(StartPos);
  Package := TPackage(InstallQueue.Peek);
  if CalculatedFileSize > 0 then
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[40],
      [Package.Name + ' ' + Package.Version,  100 * (ReceivedBytes / CalculatedFileSize)])
  else
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[39],
      [Package.Name + ' ' + Package.Version]);
end;

procedure TFrmPkgDownload.FileDownloadPkgFinish(Sender: TObject;
   State: TDownloadState; Canceled: Boolean);
var
  Package: TPackage;
  file_fpk, file_part: string;
begin
  if CloseOnFinish then
  begin
    if not FileDownloadXML.IsBusy then
      Close;
    Exit;
  end;
  if Canceled or Self.Canceled then
  begin
    Button1.Enabled := True;
    LabelProgresss.Caption := STR_FRM_PKG_DOWN[24];
    ProgressBar1.Position := 0;
    Exit;
  end;
  Package := TPackage(InstallQueue.Peek);
  if State <> dsError then
  begin
    file_fpk := DownloadedPackagesRoot + Package.Name + ' ' +
      Package.Version + '.fpk';
    file_part := DownloadedPackagesRoot + Package.Name + ' ' +
      Package.Version + '.fpk' + FileDownloadPkg.PartExt;
    if (State = dsDownloaded) and FileExists(file_part) and FileExists(file_fpk) and (FileDownloadPkg.PartExt <> '') then
      DeleteFile(file_fpk); // delete old version
    if (State = dsAlreadyExist) or ((State = dsDownloaded) and (not FileExists(file_part) or RenameFile(file_part, file_fpk))) then
    begin
      InstallPkgQueue.Push(Package);
      InstallQueue.Pop;
    end;
  end;
  ProgressBar1.Position := Round(50 * ((InstalingList.Count - InstallQueue.Count)
    / InstalingList.Count));
  if not DownloadPackageFromQueue and (InstallPkgQueue.Count > 0) then
    InstallDownloadedPackages;
end;

procedure TFrmPkgDownload.InstallPkgStart(Sender: TObject);
begin
end;

procedure TFrmPkgDownload.InstallPkgFinish(Sender: TObject; Sucess: Boolean);
var
  Package: TPackage;
begin
  if Canceled then
  begin
    ProgressBar1.Position := 0;
    BtnCancel.Enabled := False;
    Button1.Enabled := True;
    Exit;
  end;
  Package := TPackage(InstallPkgQueue.Peek);
  if not Sucess then
  begin
    MessageBox(Handle, PChar(Format(STR_FRM_PKG_DOWN[41],
      [Package.Name + ' ' + Package.Version])), PChar(Caption), MB_ICONERROR);
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[41],
      [Package.Name + ' ' + Package.Version]);
    ProgressBar1.Position := 0;
    BtnCancel.Enabled := False;
    Button1.Enabled := True;
    while InstallPkgQueue.Count > 0 do InstallPkgQueue.Pop;
    InstalingList.Clear;
    Exit; // install error
  end;
  InstallList.Delete(Package.Name + ' ' + Package.Version);
  Package.Installed := True;
  Package.State := psNone;
  if Package.Data <> nil then
    TreeViewPackages.InvalidateNode(Package.Data);
  InstallPkgQueue.Pop;
  UpdateButtonsCaption;
  InstallDownloadedPackages;
end;

procedure TFrmPkgDownload.UninstallPkgStart(Sender: TObject);
begin
end;

procedure TFrmPkgDownload.UninstallPkgFinish(Sender: TObject;
  Sucess: Boolean);
var
  Package: TPackage;
begin
  if Canceled then
  begin
    BtnCancel.Enabled := False;
    Button2.Enabled := True;
    ProgressBar1.Position := 0;
    Exit;
  end;
  Package := TPackage(UninstallQueue.Peek);
  if not Sucess then
  begin
    MessageBox(Handle, PChar(Format(STR_FRM_PKG_DOWN[42],
      [Package.Name + ' ' + Package.Version])), PChar(Caption), MB_ICONERROR);
    LabelProgresss.Caption := Format(STR_FRM_PKG_DOWN[42],
      [Package.Name + ' ' + Package.Version]);
    BtnCancel.Enabled := False;
    Button2.Enabled := True;
    ProgressBar1.Position := 0;
    while UninstallQueue.Count > 0 do UninstallQueue.Pop;
    UninstalingList.Clear;
    Exit; // uninstall error
  end;
  UninstallList.Delete(Package.Name + ' ' + Package.Version);
  Package.Installed := False;
  Package.State := psNone;
  if Package.Data <> nil then
    TreeViewPackages.InvalidateNode(Package.Data);
  UninstallQueue.Pop;
  UpdateButtonsCaption;
  UninstallPackages;
end;

{ TThreadInstallPkg }

constructor TThreadInstallPkg.Create(FileName: string);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FFileName := FileName;
end;

procedure TThreadInstallPkg.DoFinish;
begin
  if Assigned(FOnFinish) then
    FOnFinish(Self, FSucess);
end;

procedure TThreadInstallPkg.DoStart;
begin
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TThreadInstallPkg.Execute;
begin
  Synchronize(DoStart);
  FSucess := LoadPackageFile(0, FFileName, True, FReparse);
  Synchronize(DoFinish);
end;

{ TThreadUninstallPkg }

procedure TThreadUninstallPkg.Execute;
begin
  Synchronize(DoStart);
  FSucess := UninstallPackage(FFileName, 0, True);
  Synchronize(DoFinish);
end;

{ TInstallPkg }

procedure TInstallPkg.Start(Reparse: Boolean = False);
var
  ThreadInstall: TThreadInstallPkg;
begin
  ThreadInstall := TThreadInstallPkg.Create(FFileName);
  ThreadInstall.OnStart := ThreadOnStart;
  ThreadInstall.OnFinish := ThreadOnFinish;
  ThreadInstall.FReparse := Reparse;
  ThreadInstall.Start;
end;

procedure TInstallPkg.ThreadOnFinish(Sender: TObject; Sucess: Boolean);
begin
  FBusy := False;
  if Assigned(FOnFinish) then
    FOnFinish(Self, Sucess);
end;

procedure TInstallPkg.ThreadOnStart(Sender: TObject);
begin
  FBusy := True;
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

{ TUninstallPkg }

procedure TUninstallPkg.Start;
var
  ThreadUninstall: TThreadUninstallPkg;
begin
  ThreadUninstall := TThreadUninstallPkg.Create(FName);
  ThreadUninstall.OnStart := ThreadOnStart;
  ThreadUninstall.OnFinish := ThreadOnFinish;
  ThreadUninstall.Start;
end;

procedure TUninstallPkg.ThreadOnFinish(Sender: TObject; Sucess: Boolean);
begin
  FBusy := False;
  if Assigned(FOnFinish) then
    FOnFinish(Self, Sucess);
end;

procedure TUninstallPkg.ThreadOnStart(Sender: TObject);
begin
  FBusy := True;
  if Assigned(FOnStart) then
    FOnStart(Self);
end;

procedure TFrmPkgDownload.EditSearchChange(Sender: TObject);
begin
  SearchPackage(UpperCase(Trim(EditSearch.Text)));
end;

procedure TFrmPkgDownload.Splitter1Moved(Sender: TObject);
begin
  FormResize(Sender);
end;

procedure TFrmPkgDownload.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := (NewSize > 219) and (ClientWidth - NewSize > 530);
end;

procedure TFrmPkgDownload.ApplyTranslation;
begin
  Caption := STR_FRM_PKG_DOWN[1];
  GroupBox1.Caption := STR_FRM_PKG_DOWN[2];
  TreeViewPackages.Header.Columns.Items[0].Text := STR_FRM_PKG_DOWN[3];
  TreeViewPackages.Header.Columns.Items[1].Text := STR_FRM_PKG_DOWN[4];
  TreeViewPackages.Header.Columns.Items[2].Text := STR_FRM_PKG_DOWN[5];
  TreeViewPackages.Header.Columns.Items[3].Text := STR_FRM_PKG_DOWN[6];
  Label3.Caption := STR_FRM_PKG_DOWN[7];
  CheckBox1.Left := Label3.Left + Label3.Width + 15;
  CheckBox1.Caption := STR_FRM_PKG_DOWN[8];
  CheckBox1.Width := Canvas.TextWidth(CheckBox1.Caption) + 30;
  CheckBox2.Left := CheckBox1.Left + CheckBox1.Width + 30;
  CheckBox2.Caption := STR_FRM_PKG_DOWN[9];
  CheckBox2.Width := Canvas.TextWidth(CheckBox2.Caption) + 30;
  Label6.Caption := STR_FRM_PKG_DOWN[10];
  EditSearch.Left := Label6.Left + Label6.Width + 10;
  Button1.Caption := STR_FRM_PKG_DOWN[11];
  Button2.Caption := STR_FRM_PKG_DOWN[12];
  LabelProgresss.Caption := STR_FRM_PKG_DOWN[13];
  GroupBox2.Caption := STR_FRM_PKG_MAN[25];
  Label1.Caption := STR_FRM_DESC[6];
  LabelName.Left := Label1.Left + Label1.Width + 5;
  Label4.Caption := STR_FRM_DESC[7];
  LabelVersion.Left := Label4.Left + Label4.Width + 5;
  Label2.Caption := STR_FRM_DESC[8];
  LblSite.Left := Label2.Left + Label2.Width + 5;
  Label5.Caption := STR_FRM_DESC[9];
  BtnCancel.Caption := STR_FRM_WIZARD[4];
end;

end.
