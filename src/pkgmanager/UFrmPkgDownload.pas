unit UFrmPkgDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NativeTreeView, ImgList, ExtCtrls, StdCtrls, ComCtrls,
  RichEditViewer, FileDownload, XMLDoc, XMLIntf, UPkgClasses, rbtree;

const
  {$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
  {$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER+10;

type
  TFrmPkgDownload = class(TForm)
    ImageList16x16: TImageList;
    GroupBox1: TGroupBox;
    TreeViewPackages: TNativeTreeView;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    BtnCancel: TButton;
    LabelProgresss: TLabel;
    Bevel1: TBevel;
    GroupBox2: TGroupBox;
    Image1: TImage;
    TextDesc: TRichEditViewer;
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
    procedure FormResize(Sender: TObject);
    procedure FileDownloadXMLProgress(Sender: TObject; ReceivedBytes,
      CalculatedFileSize: Cardinal);
    procedure FileDownloadXMLStart(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FileDownloadXMLFinish(Sender: TObject; Canceled: Boolean);
    procedure TreeViewPackagesGetText(Sender: TBaseNativeTreeView;
      Node: PNativeNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TreeViewPackagesChange(Sender: TBaseNativeTreeView;
      Node: PNativeNode);
    procedure BtnCancelClick(Sender: TObject);
    procedure TreeViewPackagesGetImageIndex(Sender: TBaseNativeTreeView;
      Node: PNativeNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure LblSiteClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TreeViewPackagesChecked(Sender: TBaseNativeTreeView;
      Node: PNativeNode);
  private
    { Private declarations }
    InstalledCount: Integer;
    Ms: TMemoryStream;
    CategoryList: TCategoryList;
    marquee: Boolean;
    LoadingPkg: Integer;
    InstallList: TRBTree;
    UninstallList: TRBTree;
    procedure DownloadPackageList;
    procedure ReloadPackages;
    procedure SearchPackage(const S: string);
    procedure UpdateState;
    procedure ChangePackageState(Sender: TObject; Pkg: TPackage);
    procedure UpdateButtonsCaption;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmPkgDownload: TFrmPkgDownload;

function InstallPackages(ParentWindow: HWND): Integer;

implementation

uses UInstaller, UFrmPkgMan;

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

procedure TFrmPkgDownload.UpdateState;
begin

end;

procedure TFrmPkgDownload.SearchPackage(const S: string);
var
  I, J, K, PkgCount, LibCount: Integer;
  PCategory, PLibrary, PPackage: PNativeNode;
  CategoryItem: TCategory;
  LibraryItem: TLibrary;
  PackageItem: TPackage;
begin
  Inc(LoadingPkg);
  TreeViewPackages.Clear;
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
          (not CheckBox2.Checked and PackageItem.Installed) then
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
      TreeViewPackages.DeleteNode(PCategory);
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
    LabelProgresss.Caption := 'Done loading packages.';
    BtnCancel.Enabled := False;
  end;

var
  XMLDoc: TXMLDocument;
  RootNode, CategoryNode, LibraryNode, PackageNode, DependencyNode: IXMLNode;
  CategoryItem: TCategory;
  LibraryItem: TLibrary;
  PackageItem: TPackage;
  DependencyItem: TDependency;
  BuildDependencyList: TList;
  I: Integer;
  fmt: TFormatSettings;
  pkgList: TRBTree;
begin
  fmt.ShortDateFormat:='yyyy-mm-dd';
  fmt.DateSeparator  :='-';
  fmt.LongTimeFormat :='hh:nn:ss';
  fmt.TimeSeparator  :=':';
  Ms.Position := 0;
  ProgressBar1.Position := 0;
  LabelProgresss.Caption := 'Loading packages...';
  XMLDoc := TXMLDocument.Create(Self);
  try
    XMLDoc.LoadFromStream(Ms);
  except
    XMLDoc.Free;
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := 'Error parsing xml.';
    BtnCancel.Caption := 'Retry';
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
        { TODO -oMazin -c : loop dependency 20/09/2012 16:01:27 }
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
      DependencyItem.Package.Add(PackageItem)
    else
      raise Exception.CreateFmt('Dependency "%s %s" to "%s %s" not found',
        [DependencyItem.Name, DependencyItem.Version,
        DependencyItem.Package.Name, DependencyItem.Package.Version]);
  end;
  pkgList.Free;
  BuildDependencyList.Free;
  XMLDoc.Free;
  LoadDone;
  UpdateState;
  SearchPackage('');
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
  BtnCancel.Left := Panel2.Width - BtnCancel.Width - ProgressBar1.Left;
  ProgressBar1.Width := BtnCancel.Left - 3 * ProgressBar1.Left;
end;

procedure TFrmPkgDownload.FileDownloadXMLProgress(Sender: TObject;
  ReceivedBytes, CalculatedFileSize: Cardinal);
begin
  if CalculatedFileSize > 0 then
  begin
    if marquee then
    begin
      marquee := False;
      ProgressbarSetNormal(ProgressBar1);
    end;
    ProgressBar1.Position := Round((ReceivedBytes / CalculatedFileSize) * 100);
    LabelProgresss.Caption := Format('Downloading packages list %.2f%%.',
      [(ReceivedBytes / CalculatedFileSize) * 100]);
  end
  else
  begin
    LabelProgresss.Caption := 'Downloading packages list...';
  end;
end;

procedure TFrmPkgDownload.FileDownloadXMLStart(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  if not marquee then
  begin
    marquee := True;
    ProgressbarSetMarqueue(ProgressBar1);
  end;
  Panel2.Visible := True;
  LabelProgresss.Caption := 'Downloading packages list...';
  BtnCancel.Enabled := True;
  FormResize(Self);
end;

procedure TFrmPkgDownload.UpdateButtonsCaption;
begin
  if InstallList.Count = 0 then
    Button1.Caption := 'Install packages...'
  else if InstallList.Count = 1 then
    Button1.Caption := Format('Install %d package...', [InstallList.Count])
  else
    Button1.Caption := Format('Install %d packages...', [InstallList.Count]);
  Button1.Enabled := InstallList.Count > 0;
  if UninstallList.Count = 0 then
    Button2.Caption := 'Delete packages...'
  else if UninstallList.Count = 1 then
    Button2.Caption := Format('Delete %d package...', [UninstallList.Count])
  else
    Button2.Caption := Format('Delete %d packages...', [UninstallList.Count]);
  Button2.Enabled := UninstallList.Count > 0;
end;

procedure TFrmPkgDownload.ChangePackageState(Sender: TObject; Pkg: TPackage);
var
  Node: PNativeNode;
begin
  if Pkg.Data = nil then
    Exit;
  Inc(LoadingPkg);
  Node := Pkg.Data;
  if Pkg.Installed then
  begin
    if Pkg.State = psUninstall then
    begin
      TreeViewPackages.CheckState[Node] := csUncheckedNormal;
      UninstallList.Add(Pkg.Name + ' ' + Pkg.Version, Pkg);
      InstallList.Delete(Pkg.Name + ' ' + Pkg.Version);
    end
    else
    begin
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
      TreeViewPackages.CheckState[Node] := csCheckedNormal;
      InstallList.Add(Pkg.Name + ' ' + Pkg.Version, Pkg);
    end
    else
    begin
      TreeViewPackages.CheckState[Node] := csUncheckedNormal;
      InstallList.Delete(Pkg.Name + ' ' + Pkg.Version);
    end;
  end;
  UpdateButtonsCaption;
  Dec(LoadingPkg);
end;

procedure TFrmPkgDownload.FormCreate(Sender: TObject);
begin
  Ms := TMemoryStream.Create;
  InstallList := TRBTree.Create;
  UninstallList := TRBTree.Create;
  CategoryList := TCategoryList.Create;
  CategoryList.OnChangeState := ChangePackageState;
  DownloadPackageList;
end;

procedure TFrmPkgDownload.FormDestroy(Sender: TObject);
begin
  CategoryList.Free;
  UninstallList.Free;
  InstallList.Free;
  Ms.Free;
end;

procedure TFrmPkgDownload.FileDownloadXMLFinish(Sender: TObject;
  Canceled: Boolean);
begin
  if marquee then
  begin
    marquee := False;
    ProgressbarSetNormal(ProgressBar1);
  end;
  if not Canceled and (Ms.Size > 0) then
    ReloadPackages
  else if Canceled then
  begin
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := 'Download canceled.';
    BtnCancel.Enabled := False;
  end
  else
  begin
    ProgressBar1.Position := 0;
    LabelProgresss.Caption := 'Download error invalid xml file.';
    BtnCancel.Enabled := False;
  end;
end;

procedure TFrmPkgDownload.TreeViewPackagesGetText(
  Sender: TBaseNativeTreeView; Node: PNativeNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
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
            CellText := 'Uninstall'
          else
            CellText := 'Installed';
        end
        else
        begin
          if TPackage(Data).State = psInstall then
            CellText := 'Install'
          else
            CellText := 'Not installed';
        end;
      end
      else
        CellText := '';
    end;
  end;
end;

procedure TFrmPkgDownload.TreeViewPackagesChange(
  Sender: TBaseNativeTreeView; Node: PNativeNode);
var
  Data: TObject;
begin
  if Node = nil then
    Exit;
  Data := TObject(Sender.GetNodeData(Node)^);
  if Data is TPackage then
  begin
    GroupBox2.Visible := True;
    Bevel1.Visible := True;
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
    Bevel1.Visible := False;
    FormResize(Self);
  end;
end;

procedure TFrmPkgDownload.BtnCancelClick(Sender: TObject);
begin
  if FileDownloadXML.IsBusy then
    FileDownloadXML.Stop;
end;

procedure TFrmPkgDownload.TreeViewPackagesGetImageIndex(
  Sender: TBaseNativeTreeView; Node: PNativeNode; Kind: TVTImageKind;
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
  Sender: TBaseNativeTreeView; Node: PNativeNode);
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

end.
