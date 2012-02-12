unit UFrmNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, UFileProperty, UTemplates, SynMemo;

type
  TPageWizard = (pwProj, pwOpt);
  TFrmWizard = class(TForm)
    PainelFra: TPanel;
    PainelBtns: TPanel;
    BtnProx: TButton;
    BtnCan: TButton;
    BtnVoltar: TButton;
    BtnFnsh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnProxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCanClick(Sender: TObject);
    procedure BtnVoltarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnFnshClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Page: TPageWizard;
    ProjTemp: TTemplate;
  end;

var
  FrmWizard: TFrmWizard;

implementation

uses UFraProjs, UFraNewOpt, UFrmMain, UUtils, ULanguages;

{$R *.dfm}

procedure TFrmWizard.FormCreate(Sender: TObject);
var
  Item: TListItem;
  I: Integer;
begin
  FraProjs := TFraProjs.Create(Self);
  ConvertTo32BitImageList(FraProjs.ImageList);
  FraProjs.Parent := PainelFra;
  FraProjs.LastItemIndex := -1;
  for I:= 0 to Pred(FrmFalconMain.Templates.Count) do
  begin
    Item := FraProjs.GetListViewOfSheet(
            FrmFalconMain.Templates.Templates[I].Sheet).Items.Add;
    Item.Caption := FrmFalconMain.Templates.Templates[I].Caption;
    if Assigned(FrmFalconMain.Templates.Templates[I].ListImage) then
      Item.ImageIndex := FraProjs.ImageList.AddMasked(
        FrmFalconMain.Templates.Templates[I].ListImage, 0)
    else
      Item.ImageIndex := 0;
    Item.Data := FrmFalconMain.Templates.Templates[I];
  end;
  FraPrjOpt := TFraPrjOpt.Create(Self);
  Page := pwProj;
  FraProjs.PageControl.ActivePageIndex := 0;
  /////////////////
  Caption := CONST_STR_FRM_NEW_PROJ[1];
  BtnVoltar.Caption := STR_FRM_NEW_PROJ[2];
  BtnProx.Caption := STR_FRM_NEW_PROJ[3];
  BtnFnsh.Caption := STR_FRM_NEW_PROJ[4];
  BtnCan.Caption := STR_FRM_PROP[15];
  //FraProj
  FraProjs.GrBoxDesc.Caption := STR_FRM_NEW_PROJ[5];
  FraProjs.LblWidz.Caption :=  STR_FRM_NEW_PROJ[6];
  //FraPrjOpt
  FraPrjOpt.GrbApp.Caption := STR_FRM_PROP[1];
  FraPrjOpt.ImgIcon.Hint := STR_FRM_PROP[9];
  FraPrjOpt.LblDescIcon.Caption := STR_FRM_NEW_PROJ[8];
  FraPrjOpt.BtnChgIcon.Caption := STR_FRM_NEW_PROJ[7];
  FraPrjOpt.CHBInc.Caption := STR_FRM_PROP[17];
  FraPrjOpt.LblCompa.Caption := STR_FRM_NEW_PROJ[9];
  FraPrjOpt.LblVers.Caption := STR_FRM_NEW_PROJ[10];
  FraPrjOpt.LblDesc.Caption := STR_FRM_NEW_PROJ[5];
  FraPrjOpt.LblProdName.Caption := STR_FRM_NEW_PROJ[11];
  FraPrjOpt.GrbProj.Caption := STR_FRM_MAIN[23];
  FraPrjOpt.LblName.Caption := STR_FRM_NEW_PROJ[12];
  FraPrjOpt.GrbOptmz.Caption := STR_FRM_PROP[29];
  FraPrjOpt.CHBMinSize.Caption := STR_FRM_PROP[30];
  FraPrjOpt.CHBShowWar.Caption := STR_FRM_PROP[31];
  FraPrjOpt.CHBOptSpd.Caption := STR_FRM_PROP[32];
  FraPrjOpt.RGrpType.Caption := STR_FRM_PROP[28];
  FraPrjOpt.LblWidz.Caption := STR_FRM_NEW_PROJ[6];
  ///////////////
end;

procedure TFrmWizard.BtnProxClick(Sender: TObject);
var
  Template: TTemplate;
begin
  Page := pwOpt;
  Template := TProjectsSheet(
              FraProjs.PageControl.ActivePage).ListView.Selected.Data;
  FraPrjOpt.Parent := PainelFra;
  ProjTemp := Template;
  if Assigned(Template) then
  begin
    FraPrjOpt.ImgIcon.Center := False;
    FraPrjOpt.ImgIcon.Picture.Icon.Assign(Template.Icon);
    if not Assigned(FraPrjOpt.LoadedIcon) then
      FraPrjOpt.LoadedIcon := TIcon.Create;
    FraPrjOpt.LoadedIcon.Assign(Template.Icon);
    FraPrjOpt.EditDesc.Text := Template.Caption;
    FraPrjOpt.EditProjName.Text := Template.Caption + '1';
    FraPrjOpt.RGrpType.ItemIndex := Template.CompilerType;
  end;
  FraPrjOpt.EditComp.Text := GetCompanyName;
  FraProjs.Parent := nil;
  BtnVoltar.Show;
  BtnProx.Hide;
end;

procedure TFrmWizard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FrmNewProj := nil;
end;

procedure TFrmWizard.BtnCanClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmWizard.BtnVoltarClick(Sender: TObject);
begin
  Page := pwProj;
  FraProjs.Parent := PainelFra;
  FraPrjOpt.Parent := nil;
  BtnProx.Show;
  BtnVoltar.Hide;
  BtnFnsh.Enabled := False;
end;

procedure TFrmWizard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrmWizard.BtnFnshClick(Sender: TObject);
var
  Node: TTreeNode;
  NewPrj: TProjectProperty;
  NewFile: TFileProperty;
  FileName: String;
  Optmz: String;
  Template: TTemplate;
  Version: TVersionInfo;
  Ver: TVersion;
  I: Integer;
  FileText: TStrings;
  FileType: Integer;
  AddLibs: String;
begin
  Node := FrmFalconMain.TVProject.Items.AddChild(nil, '');
  NewPrj := TProjectProperty.Create(FrmFalconMain.RPCEditor, Node);
  NewPrj.Project := NewPrj;
  NewPrj.FileType := FILE_TYPE_PROJECT;
  Node.Data := NewPrj;
  if (Page = pwProj) then
    Template := TTemplate(TProjectsSheet(FraProjs.PageControl.ActivePage).
                ListView.Selected.Data)
  else
    Template := ProjTemp;
  AddLibs := '';
  if Assigned(Template) then
  begin
    NewPrj.AppType := Template.AppType;
    case Template.AppType of
      APPTYPE_GUI: AddLibs := '-mwindows ';
      APPTYPE_DLL: AddLibs := '-shared -Wl,--add-stdcall-alias ';
    end;
    NewPrj.Libs := AddLibs + Template.Libs;
    NewPrj.Flags := Template.Flags;
    NewPrj.Icon := Template.Icon;
    for I:= 0 to Pred(Template.SourceFiles.Count) do
    begin
      FileType := GetFileType(Template.SourceFiles.FileName[I]);
      NewFile := GetFileProperty(
                                 FileType,
                                 GetCompiler(FileType),
                                 Template.SourceFiles.FileName[I],
                                 ExtractFileNameNoExt(
                                   Template.SourceFiles.FileName[I]),
                                 ExtractFileExt(
                                   Template.SourceFiles.FileName[I]),
                                 '',
                                 NewPrj);
      FileText := Template.SourceFiles.SourceFile[I];
      NewFile.SetText(FileText);
      NewFile.Modified := False;
      if (Template.SourceFiles.DefaultFile = I) or
         (Template.SourceFiles.Count = 1) then
        NewFile.Edit;
    end;
  end;

  if (Page = pwOpt) then
  begin
    NewPrj.CompilerType := FraPrjOpt.RGrpType.ItemIndex;
    if Assigned(FraPrjOpt.LoadedIcon) then
      NewPrj.Icon := FraPrjOpt.LoadedIcon
    else
      NewPrj.Icon := nil;
    if FraPrjOpt.CHBInc.Checked then
    begin
      NewPrj.IncludeVersionInfo := True;
      Version := NewPrj.Version;
      Version.CompanyName := FraPrjOpt.EditComp.Text;
      Version.FileVersion := FraPrjOpt.EditVer.Text;
      Version.ProductVersion := FraPrjOpt.EditVer.Text;
      Ver := ParseVersion(FraPrjOpt.EditVer.Text);
      Version.Major := Ver.Major;
      Version.Minor := Ver.Minor;;
      Version.Release := Ver.Release;
      Version.Build := Ver.Build;
      Version.FileDescription := FraPrjOpt.EditDesc.Text;
      Version.ProductName := FraPrjOpt.EditProdName.Text;
    end;
    FileName := FrmFalconMain.ProjectsRoot +
      ExtractFileNameNoExt(FraPrjOpt.EditProjName.Text) + '.fpj';
    Optmz := '';
    if FraPrjOpt.CHBShowWar.Checked then Optmz := '-Wall';
    if FraPrjOpt.CHBMinSize.Checked then Optmz := Optmz + ' -s';
    if FraPrjOpt.CHBMinSize.Checked then Optmz := Optmz + ' -O2';
    NewPrj.CompilerOptions := Trim(Optmz);
  end
  else
  begin
    NewPrj.CompilerOptions := '-Wall -s -O2';
    FileName := NextProjectName(STR_FRM_MAIN[23], '.fpj', FrmFalconMain.TVProject.Items);
    FileName := FrmFalconMain.ProjectsRoot + FileName;
  end;
  NewPrj.FileName := FileName;
  case NewPrj.AppType of
    APPTYPE_DLL: NewPrj.Target := ExtractFileNameNoExt(FileName) + '.dll';
    APPTYPE_LIB: NewPrj.Target := 'lib' + ExtractFileNameNoExt(FileName) + '.a';
  else
    NewPrj.Target := ExtractFileNameNoExt(FileName) + '.exe';
  end;
  NewPrj.Modified := False;
  Node.Text := NewPrj.Caption;
  Node.Selected := True;
  Node.Focused := True;
  Close;
end;

end.
