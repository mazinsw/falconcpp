unit UFrmPkgDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NativeTreeView, ImgList, ExtCtrls, StdCtrls, ComCtrls,
  RichEditViewer, FileDownload, XMLDoc, XMLIntf, UPkgClasses;

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
  private
    { Private declarations }
    InstalledCount: Integer;
    Ms: TMemoryStream;
    CategoryList: TCategoryList;
    procedure DownloadPackageList;
    procedure ReloadPackages;
    procedure SearchPackage(const S: string);
    procedure UpdateState;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FrmPkgDownload: TFrmPkgDownload;

function InstallPackages(ParentWindow: HWND): Integer;

implementation

{$R *.dfm}

function InstallPackages(ParentWindow: HWND): Integer;
begin
  FrmPkgDownload := TFrmPkgDownload.CreateParented(ParentWindow);
  FrmPkgDownload.ShowModal;
  Result := FrmPkgDownload.InstalledCount;
  FrmPkgDownload.Free;
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
  I, J, K: Integer;
  PCategory, PLibrary, PPackage: PNativeNode;
  CategoryItem: TCategory;
  LibraryItem: TLibrary;
  PackageItem: TPackage;
begin
  for I := 0 to CategoryList.Count - 1 do
  begin
    CategoryItem := CategoryList.Items[I];
    PCategory := TreeViewPackages.AddChild(nil, CategoryItem);
    TreeViewPackages.CheckType[PCategory] := ctTriStateCheckBox;
    for J := 0 to CategoryItem.Count - 1 do
    begin
      LibraryItem := CategoryItem.Items[J];
      PLibrary := TreeViewPackages.AddChild(PCategory, LibraryItem);
      TreeViewPackages.CheckType[PLibrary] := ctTriStateCheckBox;
      for K := 0 to LibraryItem.Count - 1 do
      begin
        PackageItem := LibraryItem.Items[K];
        PPackage := TreeViewPackages.AddChild(PLibrary, PackageItem);
        TreeViewPackages.CheckType[PPackage] := ctTriStateCheckBox;
      end;
    end;
  end;
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
  RootNode, CategoryNode, LibraryNode, PackageNode: IXMLNode;
  CategoryItem: TCategory;
  LibraryItem: TLibrary;
  PackageItem: TPackage;
  fmt: TFormatSettings;
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
        PackageItem.Version := PackageNode.Attributes['version'];
        PackageItem.Size := StrToInt(PackageNode.Attributes['size']);
        PackageItem.URL := PackageNode.Attributes['url'];
        PackageItem.LastModified := StrToDateTime(PackageNode.Attributes['lastmodified'], fmt);
        PackageItem.GCCVersion := PackageNode.Attributes['gccversion'];
        PackageItem.Name := LibraryItem.Name + ' ' + PackageItem.Version;
        PackageNode := PackageNode.NextSibling;
      end;
      LibraryNode := LibraryNode.NextSibling;
    end;
    CategoryNode := CategoryNode.NextSibling;
  end;
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
  TreeViewPackages.Height := GroupBox1.ClientHeight - TreeViewPackages.Top - TreeViewPackages.Left - 2 * GetSystemMetrics(SM_CYBORDER);
  BtnCancel.Left := Panel2.Width - BtnCancel.Width - ProgressBar1.Left;
  ProgressBar1.Width := BtnCancel.Left - 3 * ProgressBar1.Left;
end;

procedure TFrmPkgDownload.FileDownloadXMLProgress(Sender: TObject;
  ReceivedBytes, CalculatedFileSize: Cardinal);
begin
  ProgressBar1.Position := Round((ReceivedBytes / CalculatedFileSize) * 100);
  LabelProgresss.Caption := Format('Downloading packages list %.2f%%.',
    [(ReceivedBytes / CalculatedFileSize) * 100]);
end;

procedure TFrmPkgDownload.FileDownloadXMLStart(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  Panel2.Visible := True;
  LabelProgresss.Caption := 'Downloading packages list...';
  BtnCancel.Enabled := True;
  FormResize(Self);
end;

procedure TFrmPkgDownload.FormCreate(Sender: TObject);
begin
  Ms := TMemoryStream.Create;
  CategoryList := TCategoryList.Create;
  DownloadPackageList;
end;

procedure TFrmPkgDownload.FormDestroy(Sender: TObject);
begin
  CategoryList.Free;
  Ms.Free;
end;

procedure TFrmPkgDownload.FileDownloadXMLFinish(Sender: TObject;
  Canceled: Boolean);
begin
  if not Canceled and (Ms.Size > 0) then
    ReloadPackages;
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
        CellText := TPackage(Data).Name;
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
          CellText := 'Installed'
        else
          CellText := 'Not installed';
      end
      else
        CellText := '';
    end;
  end;
end;

procedure TFrmPkgDownload.TreeViewPackagesChange(
  Sender: TBaseNativeTreeView; Node: PNativeNode);
begin
  GroupBox2.Visible := True;
  Bevel1.Visible := True;
  FormResize(Self);
end;

end.
