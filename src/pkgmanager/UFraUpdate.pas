unit UFraUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, XMLDoc, XMLIntf, UUtils;

type
  TFraUpdate = class(TFrame)
    LblDesc: TLabel;
    PrgsUpdate: TProgressBar;
    MemoChanges: TMemo;
    LblChanges: TLabel;
    procedure Load(UpdateXML: String);
  private
    { Private declarations }
  public
    SiteVersion: TVersion;
  end;

var
  FraUpdate: TFraUpdate;

implementation

uses UFrmUpdate, UFrmMain, ULanguages;

{$R *.dfm}

procedure TFraUpdate.Load(UpdateXML: String);

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: String): String;
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
  I, X: Integer;
begin
  XMLDoc := TXMLDocument.Create(Self);
  try
    XMLDoc.LoadFromFile(UpdateXML);
  except
    XMLDoc.Free;
    FrmUpdate.BtnCancel.Caption := STR_POPUP_EDITOR[1];
    LblDesc.Caption := STR_FRM_UPD[16];
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := '    ';

  //tag FalconCPP
  FalconNode := XMLDoc.ChildNodes.FindNode('FalconCPP');
  Node := FalconNode.ChildNodes.FindNode('Core');
  SiteVersion := ParseVersion(Node.Attributes['Version']);
  I := CompareVersion(SiteVersion, FrmFalconMain.Vers);
  case I of
    -1:
    begin
      FrmUpdate.BtnCancel.Caption := STR_FRM_PROP[14];
      FrmUpdate.LblAction.Caption := STR_FRM_UPD[17];
      LblDesc.Caption := STR_FRM_UPD[18];
    end;
    0:
    begin
      FrmUpdate.BtnCancel.Caption := STR_FRM_PROP[14];
      FrmUpdate.LblAction.Caption := STR_FRM_UPD[17];
      LblDesc.Caption := STR_FRM_UPD[19];
    end;
    1:
    begin
      FrmUpdate.LblAction.Caption := STR_FRM_UPD[20];
      LblDesc.Caption := Format(STR_FRM_UPD[21], [
         VersionToStr(SiteVersion)]);
      NodeFiles := Node.ChildNodes.FindNode('File');
      if (NodeFiles.Attributes['Name'] = 'Falcon.exe') then
      begin
        FrmUpdate.FileDownload.URL := NodeFiles.Attributes['URL'];
        FrmUpdate.FileDownload.FileName := GetTempDirectory + 'Falcon.zip';
        Desc := TStringList.Create;
        Desc.Text := NodeFiles.Text;
        for X:= 0 to Pred(Desc.Count) do
          Desc.Strings[X] := Trim(Desc.Strings[X]);
        for X:= Pred(Desc.Count) downto 0 do
          if Length(Desc.Strings[X]) = 0 then Desc.Delete(X);
        MemoChanges.Text := Desc.Text;
        Desc.Free;
      end;
      LblChanges.Show;
      MemoChanges.Show;
      FrmUpdate.BtnCancel.Caption := STR_POPUP_EDITOR[1];
      FrmUpdate.BtnUpdate.Caption := STR_FRM_UPD[3];
      FrmUpdate.BtnUpdate.Show;
    end;
  end;
  XMLDoc.Free;
  DeleteFile(UpdateXML);
  //...
end;

end.
