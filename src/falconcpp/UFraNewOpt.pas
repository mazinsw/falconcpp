unit UFraNewOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, 
  Menus, IconDialog;

type
  TFraPrjOpt = class(TFrame)
    PUMIcon: TPopupMenu;
    ChangeIcon1: TMenuItem;
    RemoveIcon1: TMenuItem;
    OpenIcon: TIconDialog;
    GrbApp: TGroupBox;
    LblDescIcon: TLabel;
    PanelIcon: TPanel;
    ImgIcon: TImage;
    BtnChgIcon: TButton;
    CHBInc: TCheckBox;
    GrBInfo: TGroupBox;
    LblCompa: TLabel;
    LblDesc: TLabel;
    LblVers: TLabel;
    LblProdName: TLabel;
    Bevel2: TBevel;
    EditComp: TEdit;
    EditDesc: TEdit;
    EditVer: TEdit;
    EditProdName: TEdit;
    GrbProj: TGroupBox;
    LblName: TLabel;
    RGrpType: TRadioGroup;
    EditProjName: TEdit;
    GrbOptmz: TGroupBox;
    CHBMinSize: TCheckBox;
    CHBShowWar: TCheckBox;
    CHBOptSpd: TCheckBox;
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
  if OpenIcon.Execute(Handle) then
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
  for I := 0 to GrBInfo.ControlCount - 1 do
    GrBInfo.Controls[I].Enabled := CHBInc.Checked;
end;

procedure TFraPrjOpt.EditProjNameKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['\', '/', ':', '*', '?', '"', '<', '>', '|']) then
    Key := #0;
end;

procedure TFraPrjOpt.EditProjNameChange(Sender: TObject);
begin
  FrmNewProj.BtnFnsh.Enabled := Length(Trim(EditProjName.Text)) > 0;
end;

end.
