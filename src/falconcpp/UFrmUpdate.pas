unit UFrmUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI, XMLDoc,
  XMLIntf, UUtils;

type

  TFrmUpdate = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel3: TPanel;
    LblAction: TLabel;
    BtnCancel: TButton;
    BtnUpdate: TButton;
    PnlFra: TPanel;
    MemoChanges: TMemo;
    LblChanges: TLabel;
    LblDesc: TLabel;
    procedure UpdateLangNow;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnUpdateClick(Sender: TObject);
    procedure Load(UpdateXML: string);
  private
    { Private declarations }
  public
    { Public declarations }
    XMLFile: string;
  end;

var
  FrmUpdate: TFrmUpdate;

implementation

uses UFrmMain, ULanguages, SystemUtils;

{$R *.dfm}

procedure TFrmUpdate.UpdateLangNow;
begin
  Caption := STR_FRM_UPD[1];
  LblAction.Caption := STR_FRM_UPD[2];
  BtnUpdate.Caption := STR_FRM_UPD[3];
end;

procedure TFrmUpdate.Load(UpdateXML: string);

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

var
  XMLDoc: TXMLDocument;
  Node, NodeFiles, FalconNode: IXMLNode;
  Desc: TStrings;
  I: Integer;
  SiteVersion: TVersion;
begin
  XMLDoc := TXMLDocument.Create(Self);
  try
    XMLDoc.LoadFromFile(UpdateXML);
  except
    //XMLDoc.Free;
    BtnCancel.Caption := STR_POPUP_EDITOR[1];
    LblDesc.Caption := STR_FRM_UPD[16];
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := '    ';

  //tag FalconCPP
  FalconNode := XMLDoc.ChildNodes.FindNode('FalconCPP');
  Node := FalconNode.ChildNodes.FindNode('Core');
  SiteVersion := ParseVersion(Node.Attributes['Version']);
  LblAction.Caption := STR_FRM_UPD[20];
  LblDesc.Caption := Format(STR_FRM_UPD[21], [
    VersionToStr(SiteVersion)]);
  NodeFiles := Node.ChildNodes.FindNode('File');
  if (NodeFiles.Attributes['Name'] = 'Falcon.exe') then
  begin
    Desc := TStringList.Create;
    Desc.Text := NodeFiles.Text;
    for I := 0 to Desc.Count - 1 do
      Desc.Strings[I] := Trim(Desc.Strings[I]);
    for I := Desc.Count - 1 downto 0 do
      if Length(Desc.Strings[I]) = 0 then
        Desc.Delete(I);
    MemoChanges.Text := Desc.Text;
    Desc.Free;
    LblChanges.Show;
    MemoChanges.Show;
    BtnCancel.Caption := STR_POPUP_TABS[1];
    BtnUpdate.Caption := STR_FRM_UPD[3];
    BtnUpdate.Show;
  end;
  //XMLDoc.Free;
  XMLFile := UpdateXML;
end;

procedure TFrmUpdate.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE,
    GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  UpdateLangNow;
end;

procedure TFrmUpdate.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    BtnCancelClick(Sender);
  end;
end;

procedure TFrmUpdate.BtnCancelClick(Sender: TObject);
begin
  if FileExists(XMLFile) then
    DeleteFile(XMLFile);
  Close;
end;

procedure TFrmUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FreeOnRelease;
  FrmUpdate := nil;
end;

procedure TFrmUpdate.BtnUpdateClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(FrmFalconMain.AppRoot + 'Updater.exe'),
    PChar('"' + XMLFile + '"'), PChar(FrmFalconMain.AppRoot), SW_SHOW);
  Close;
end;

end.
