unit UFraUpdate;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ComCtrls, StdCtrls,
  XMLDoc, XMLIntf, UUtils;

type
  TFraUpdate = class(TFrame)
    LblDesc: TLabel;
    PrgsUpdate: TProgressBar;
    MemoChanges: TMemo;
    LblChanges: TLabel;
    function Load(UpdateXML: String): Boolean;
  private
    { Private declarations }
  public
    SiteVersion: TVersion;
  end;

var
  FraUpdate: TFraUpdate;

implementation

uses UFrmUpdate;

{$R *.dfm}

function TFraUpdate.Load(UpdateXML: String): Boolean;

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
  Temp: String;
begin
  Result := False;
  XMLDoc := TXMLDocument.Create(Self);
  try
    XMLDoc.LoadFromFile(UpdateXML);
  except
    XMLDoc.Free;
    FrmUpdate.BtnCancel.Caption := STR_FRM_UPD[22];
    LblDesc.Caption := STR_FRM_UPD[16];
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := '    ';

  //tag FalconCPP
  FalconNode := XMLDoc.ChildNodes.FindNode('FalconCPP');
  Node := FalconNode.ChildNodes.FindNode('Core');
  SiteVersion := ParseVersion(Node.Attributes['Version']);
  I := CompareVersion(SiteVersion, FalconVersion);
  case I of
    -1:
    begin
      FrmUpdate.BtnCancel.Caption := STR_FRM_UPD[23];
      FrmUpdate.LblAction.Caption := STR_FRM_UPD[17];
      LblDesc.Caption := STR_FRM_UPD[18];
    end;
    0:
    begin
      FrmUpdate.BtnCancel.Caption := STR_FRM_UPD[23];
      FrmUpdate.LblAction.Caption := STR_FRM_UPD[17];
      LblDesc.Caption := STR_FRM_UPD[19];
    end;
    1:
    begin
      FrmUpdate.LblAction.Caption := STR_FRM_UPD[20];
      LblDesc.Caption := Format(STR_FRM_UPD[21], [
         VersionToStr(SiteVersion)]);
      NodeFiles := Node.ChildNodes.FindNode('File');
      FrmUpdate.FileName := NodeFiles.Attributes['Name'];
      FrmUpdate.FileDownload.URL := NodeFiles.Attributes['URL'];
      Temp := FrmUpdate.FileDownload.URL;
      Temp := ExtractFileName(ConvertSlashes(Temp));
      FrmUpdate.FileDownload.FileName := GetTempDirectory + Temp;
      Desc := TStringList.Create;
      Desc.Text := NodeFiles.Text;
      for X:= 0 to Pred(Desc.Count) do
        Desc.Strings[X] := Trim(Desc.Strings[X]);
      for X:= Pred(Desc.Count) downto 0 do
        if Length(Desc.Strings[X]) = 0 then Desc.Delete(X);

      MemoChanges.Text := Desc.Text;
      Desc.Free;

      LblChanges.Show;
      MemoChanges.Show;
      FrmUpdate.BtnCancel.Caption := STR_FRM_UPD[22];
      FrmUpdate.BtnUpdate.Caption := STR_FRM_UPD[3];
      FrmUpdate.BtnUpdate.Show;
      Result := True;
    end;
  end;
  XMLDoc.Free;
  DeleteFile(UpdateXML);
end;

end.
