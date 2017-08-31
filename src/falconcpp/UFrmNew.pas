unit UFrmNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, USourceFile, UTemplates, 
  FormEffect;

type
  TPageWizard = (pwProj, pwOpt);
  TFrmNewProj = class(TForm)
    PainelFra: TPanel;
    PainelBtns: TPanel;
    BtnProx: TButton;
    BtnCan: TButton;
    BtnVoltar: TButton;
    BtnFnsh: TButton;
    Panel1: TPanel;
    LblWidz: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure BtnProxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCanClick(Sender: TObject);
    procedure BtnVoltarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnFnshClick(Sender: TObject);
    procedure ReloadTemplates(Templates: TTemplates);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    Page: TPageWizard;
    ProjTemp: TTemplate;
  end;

var
  FrmNewProj: TFrmNewProj;

implementation

uses UFraProjs, UFraNewOpt, UFrmMain, UUtils, ULanguages,
  TokenUtils, icoformat, SystemUtils;

{$R *.dfm}

procedure TFrmNewProj.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmNewProj.ReloadTemplates(Templates: TTemplates);
var
  Item: TListItem;
  newitem, temp: TTemplate;
  I, J: Integer;
  List: TList;
  sheet: TProjectsSheet;
begin
  List := TList.Create;
  for I := FraProjs.PageControl.PageCount - 1 downto 0 do
  begin
    sheet := TProjectsSheet(FraProjs.PageControl.Pages[I]);
    for J := sheet.ListView.Items.Count - 1 downto 0 do
    begin
      Item := sheet.ListView.Items.Item[J];
      temp := TTemplate(Item.Data);
      newitem := Templates.Find(temp.Sheet, temp.Caption);
      //find
      if Assigned(newitem) then
      begin
        List.Add(newitem);
        if Assigned(temp.ListImage) then
        begin
          if Assigned(newitem.ListImage) then //replace image
          begin
            FraProjs.ImageList.ReplaceMasked(Item.ImageIndex,
              newitem.ListImage, 0);
          end;
        end
        else
        begin
          if Assigned(newitem.ListImage) then //replace image
          begin
            Item.ImageIndex := FraProjs.ImageList.AddMasked(newitem.ListImage,
              0);
          end;
        end;
        if ProjTemp = temp then
        begin
          ProjTemp := newitem;
        end;
        Item.Data := newitem;
      end
      else
      begin
        if ProjTemp = temp then
        begin
          if Page = pwOpt then
          begin
            Page := pwProj;
            FraProjs.Parent := PainelFra;
            FraPrjOpt.Parent := nil;
            BtnProx.Show;
            BtnVoltar.Hide;
            BtnFnsh.Enabled := False;
          end;
          ProjTemp := nil;
        end;
        sheet.ListView.Selected := nil;
        sheet.ListView.Items.Item[J].Delete;
      end;
    end;
    if sheet.ListView.Items.Count = 0 then
    begin
      if sheet.PageIndex = FraProjs.PageControl.ActivePageIndex then
      begin
        if sheet.PageIndex > 0 then
          FraProjs.PageControl.ActivePageIndex := sheet.PageIndex - 1
        else if FraProjs.PageControl.PageCount > (sheet.PageIndex + 1) then
          FraProjs.PageControl.ActivePageIndex := sheet.PageIndex + 1;
      end;
      sheet.Free;
    end;
  end;
  FraProjs.PageControl.LockAnimation;
  for I := Templates.Count - 1 downto 0 do
  begin
    if List.IndexOf(Templates.Templates[I]) >= 0 then
      Continue;
    Item := FraProjs.GetListViewOfSheet(
      Templates.Templates[I].Sheet).Items.Add;

    Item.Caption := Templates.Templates[I].Caption;
    if Assigned(Templates.Templates[I].ListImage) then
      Item.ImageIndex := FraProjs.ImageList.AddMasked(
        Templates.Templates[I].ListImage, 0)
    else
      Item.ImageIndex := 0;
    Item.Data := Templates.Templates[I];
  end;
  FraProjs.PageControl.UnlockAnimation;
  List.Free;
end;

procedure TFrmNewProj.FormCreate(Sender: TObject);
var
  Item: TListItem;
  I: Integer;
  Bitmap: TBitmap;
  AIcon: TIcon;
begin
  FraProjs := TFraProjs.Create(Self);
  FraProjs.Align := alClient;
  ConvertTo32BitImageList(FraProjs.ImageList);
  AIcon := LoadIconFromResource('MAINICON', 48);
  Bitmap := IconToBitmap(AIcon);
  AIcon.Free;
  FraProjs.ImageList.AddMasked(Bitmap, 0);
  Bitmap.Free;
  FraProjs.Parent := PainelFra;
  FraProjs.LastItemIndex := -1;
  //ReloadTemplates(FrmFalconMain.Templates);
  FraProjs.PageControl.LockAnimation;
  for I := 0 to FrmFalconMain.Templates.Count - 1 do
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
  FraProjs.PageControl.UnlockAnimation;
  FraPrjOpt := TFraPrjOpt.Create(Self);
  FraPrjOpt.Align := alClient;
  Page := pwProj;
  FraProjs.PageControl.ActivePageIndex := 0;
  /////////////////
  Caption := STR_FRM_NEW_PROJ[1];
  BtnVoltar.Caption := STR_FRM_NEW_PROJ[2];
  BtnProx.Caption := STR_FRM_NEW_PROJ[3];
  BtnFnsh.Caption := STR_FRM_NEW_PROJ[4];
  BtnCan.Caption := STR_FRM_PROP[15];
  LblWidz.Caption := STR_FRM_NEW_PROJ[6];
  //FraProj
  FraProjs.GrBoxDesc.Caption := STR_FRM_NEW_PROJ[5];
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
  ///////////////
end;

procedure TFrmNewProj.BtnProxClick(Sender: TObject);
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
    if Assigned(Template.Icon) then
    begin
      if not Assigned(FraPrjOpt.LoadedIcon) then
        FraPrjOpt.LoadedIcon := TIcon.Create;
      FraPrjOpt.LoadedIcon.Assign(Template.Icon);
    end;
    FraPrjOpt.EditDesc.Text := Template.Caption;
    FraPrjOpt.EditProjName.Text := Template.Caption + '1';
    if Template.CompilerType = USER_DEFINED then
    begin
      FraPrjOpt.RGrpType.ItemIndex := COMPILER_CPP;
      if not FrmFalconMain.Config.Environment.DefaultCppNewFile then
        FraPrjOpt.RGrpType.ItemIndex := COMPILER_C;
    end
    else
      FraPrjOpt.RGrpType.ItemIndex := Template.CompilerType;
    FraPrjOpt.PanelIcon.Visible := not (Template.AppType in [APPTYPE_DLL, APPTYPE_LIB]);
    FraPrjOpt.LblDescIcon.Visible := not (Template.AppType in [APPTYPE_DLL, APPTYPE_LIB]);
    FraPrjOpt.BtnChgIcon.Visible := not (Template.AppType in [APPTYPE_DLL, APPTYPE_LIB]);
    FraPrjOpt.GrbApp.Visible := not (Template.AppType in [APPTYPE_LIB]);
    if FraPrjOpt.GrbApp.Visible then
      FraPrjOpt.GrbProj.Top := 168
    else
      FraPrjOpt.GrbProj.Top := FraPrjOpt.GrbApp.Top;
    FraPrjOpt.RGrpType.Enabled := Template.CompilerType = USER_DEFINED;
  end;
  FraPrjOpt.EditComp.Text := GetCompanyName;
  FraProjs.Parent := nil;
  BtnVoltar.Show;
  BtnProx.Hide;
end;

procedure TFrmNewProj.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FrmNewProj := nil;
end;

procedure TFrmNewProj.BtnCanClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmNewProj.BtnVoltarClick(Sender: TObject);
begin
  Page := pwProj;
  FraProjs.Parent := PainelFra;
  FraPrjOpt.Parent := nil;
  BtnProx.Show;
  BtnVoltar.Hide;
  BtnFnsh.Enabled := False;
  ProjTemp := nil;
end;

procedure TFrmNewProj.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrmNewProj.BtnFnshClick(Sender: TObject);
var
  Node: TTreeNode;
  NewPrj: TProjectFile;
  OwnerFile: TSourceBase;
  NewFile: TSourceBase;
  FileName, SrcFileName, SrcDir, FolderName: string;
  Optmz: string;
  Template: TTemplate;
  Version: TVersionInfo;
  Ver: TVersion;
  I: Integer;
  FileText: TStrings;
  FileType: Integer;
  AddLibs: string;
  TemFiles: TTemplateFiles;
  DoOverr: Boolean;
  sheet: TProjectsSheet;
begin
  FrmFalconMain.IncLoading;
  NewPrj := TProjectFile(FrmFalconMain.CreateProject('', FILE_TYPE_PROJECT));
  Node := NewPrj.Node;
  if (Page = pwProj) then
  begin
    sheet := TProjectsSheet(FraProjs.PageControl.ActivePage);
    if not Assigned(sheet) then
      Exit;
    if not Assigned(sheet.ListView.Selected) then
      Exit;
    Template := TTemplate(sheet.ListView.Selected.Data);
  end
  else
    Template := ProjTemp;
  AddLibs := '';
  if not Assigned(Template) then
    Exit;
  //set resources
  if Template.Resources.Count > 0 then
    NewPrj.TemplateResources := Template.Resources.CreateTemplateID;
  //select compiler
  if (Page = pwProj) then
  begin
    if Template.CompilerType = USER_DEFINED then
    begin
      NewPrj.CompilerType := COMPILER_CPP;
      if not FrmFalconMain.Config.Environment.DefaultCppNewFile then
        NewPrj.CompilerType := COMPILER_C;
    end
    else
      NewPrj.CompilerType := Template.CompilerType;
  end
  else
    NewPrj.CompilerType := FraPrjOpt.RGrpType.ItemIndex;
  NewPrj.AppType := Template.AppType;
  case Template.AppType of
    APPTYPE_GUI:
      begin
        AddLibs := '-mwindows ';
        NewPrj.EnableTheme := True;
      end;
    APPTYPE_DLL: AddLibs := '-shared ' + LD_COMMAND + ',' + LD_OPTION_KILL_AT;
  end;
  NewPrj.Libs := AddLibs + Template.Libs;
  NewPrj.Flags := Template.Flags;
  NewPrj.CmdLine := Template.Params;
  NewPrj.Icon := Template.Icon;

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
      Version.Version.Major := Ver.Major;
      Version.Version.Minor := Ver.Minor;
      Version.Version.Release := Ver.Release;
      Version.Version.Build := Ver.Build;
      Version.FileDescription := FraPrjOpt.EditDesc.Text;
      Version.ProductName := FraPrjOpt.EditProdName.Text;
    end;
    FileName := FrmFalconMain.Config.Environment.ProjectsDir +
      ExtractName(FraPrjOpt.EditProjName.Text) + '.fpj';
    Optmz := '';
    if FraPrjOpt.CHBShowWar.Checked then
      Optmz := '-Wall';
    if FraPrjOpt.CHBMinSize.Checked then
      Optmz := Optmz + ' -s';
    if FraPrjOpt.CHBOptSpd.Checked then
      Optmz := Optmz + ' -O2';
    NewPrj.CompilerOptions := Trim(Optmz);
  end
  else
  begin
    NewPrj.CompilerOptions := '-Wall -s';
    FileName := NextProjectName(STR_FRM_MAIN[23], '.fpj', FrmFalconMain.TreeViewProjects.Items);
    FileName := FrmFalconMain.Config.Environment.ProjectsDir + FileName;
  end;
  NewPrj.FileName := FileName;
  if Assigned(Template) then
  begin
    DoOverr := False;
    TemFiles := Template.SourceFiles;
    if NewPrj.CompilerType = COMPILER_CPP then
    begin
      DoOverr := True;
      if Template.CppSourceFiles.Count > 0 then
        TemFiles := Template.CppSourceFiles;
    end;
    for I := 0 to TemFiles.Count - 1 do
    begin
      SrcFileName := ConvertSlashes(TemFiles.FileName[I]);
      FileType := GetFileType(SrcFileName);
      if (FileType = FILE_TYPE_C) and (NewPrj.CompilerType = COMPILER_CPP)
        and DoOverr then
      begin
        SrcFileName := ChangeFileExt(SrcFileName, '.cpp');
        FileType := FILE_TYPE_CPP;
      end
      else if (FileType = FILE_TYPE_CPP) and (NewPrj.CompilerType = COMPILER_C) then
      begin
        SrcFileName := ChangeFileExt(SrcFileName, '.c');
        FileType := FILE_TYPE_C;
      end;
      OwnerFile := NewPrj;
      SrcDir := ExtractFilePath(SrcFileName);
      SrcFileName := ExtractFileName(SrcFileName);
      //create folder
      while SrcDir <> '' do
      begin
        SrcDir := ExcludeTrailingPathDelimiter(SrcDir);
        FolderName := ExtractFileName(SrcDir);
        if not OwnerFile.SearchSource(FolderName, NewFile) then
          OwnerFile := CreateSourceFolder(FolderName, TSourceBase(OwnerFile))
        else
          OwnerFile := TSourceFolder(NewFile);
        SrcDir := ExtractFilePath(SrcDir);
      end;
      //add file
      NewFile := NewSourceFile(FileType,
        GetCompiler(FileType),
        SrcFileName,
        ExtractName(SrcFileName),
        ExtractFileExt(SrcFileName),
        '',
        TSourceBase(OwnerFile),
        False, False);
      FileText := TemFiles.SourceFile[I];
      if NewFile is TSourceFile then
      begin
        TSourceFile(NewFile).Edit.Editor.Lines.Assign(FileText);
        TSourceFile(NewFile).Edit.Editor.EmptyUndoBuffer;
      end;
      NewFile.IsNew := True;
      FileText.Free;
    end;
  end;
  case NewPrj.AppType of
    APPTYPE_DLL: NewPrj.Target := ExtractName(FileName) + '.dll';
    APPTYPE_LIB: NewPrj.Target := 'lib' + ExtractName(FileName) + '.a';
  else
    NewPrj.Target := ExtractName(FileName) + '.exe';
  end;
  Node.Text := NewPrj.Name;
  Node.Selected := True;
  Node.Focused := True;
  FrmFalconMain.DecLoading;
  FrmFalconMain.ParseProjectFiles(NewPrj);
  Close;
end;

end.
