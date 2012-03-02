unit UFraNewOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls, ExtDlgs,
  Menus, Mask, IconDialog;

type
  TFraPrjOpt = class(TFrame)
    PanelControls: TPanel;
    GrbProj: TGroupBox;
    LblWidz: TLabel;
    Bevel1: TBevel;
    GrbApp: TGroupBox;
    PanelIcon: TPanel;
    LblDescIcon: TLabel;
    BtnChgIcon: TButton;
    CHBInc: TCheckBox;
    GrBInfo: TGroupBox;
    LblCompa: TLabel;
    LblDesc: TLabel;
    LblVers: TLabel;
    LblProdName: TLabel;
    PUMIcon: TPopupMenu;
    ChangeIcon1: TMenuItem;
    RemoveIcon1: TMenuItem;
    ImgIcon: TImage;
    RGrpType: TRadioGroup;
    EditProjName: TEdit;
    LblName: TLabel;
    GrbOptmz: TGroupBox;
    CHBMinSize: TCheckBox;
    CHBShowWar: TCheckBox;
    CHBOptSpd: TCheckBox;
    Panel1: TPanel;
    Panel2: TPanel;
    OpenIcon: TIconDialog;
    EditComp: TEdit;
    Bevel2: TBevel;
    EditDesc: TEdit;
    EditVer: TEdit;
    EditProdName: TEdit;
    procedure BtnChgIconClick(Sender: TObject);
    procedure RemoveIcon1Click(Sender: TObject);
    procedure CHBIncClick(Sender: TObject);
    procedure EditProjNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditProjNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LoadedIcon: TIcon;
  end;

var
  FraPrjOpt: TFraPrjOpt;

implementation

uses UFrmNew;

{$R *.dfm}

procedure TFraPrjOpt.BtnChgIconClick(Sender: TObject);
begin
  OpenIcon.Handle := Handle;
  if OpenIcon.Execute then
  begin
    if not Assigned(LoadedIcon) then
      LoadedIcon := TIcon.Create;
    if UpperCase(ExtractFileExt(OpenIcon.FileName)) = '.ICO' then
      LoadedIcon.LoadFromFile(OpenIcon.FileName)
    else
      LoadedIcon.Assign(OpenIcon.Icon);
    ImgIcon.Picture.Icon := LoadedIcon;
  end;
end;

procedure TFraPrjOpt.RemoveIcon1Click(Sender: TObject);
begin
  if Assigned(LoadedIcon) then
  begin
    LoadedIcon.Free;
    LoadedIcon := nil;
  end;
  ImgIcon.Picture.Icon := nil;
end;

procedure TFraPrjOpt.CHBIncClick(Sender: TObject);
var
  I: Integer;
begin
  for I:= 0 to Pred(GrBInfo.ControlCount) do
    GrBInfo.Controls[I].Enabled := CHBInc.Checked;
end;

procedure TFraPrjOpt.EditProjNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in['\', '/', ':', '*', '?', '"', '<', '>', '|'] then
    Key := #0;
end;

procedure TFraPrjOpt.EditProjNameChange(Sender: TObject);
begin
  FrmNewProj.BtnFnsh.Enabled := Length(Trim(EditProjName.Text)) > 0;
end;

end.
