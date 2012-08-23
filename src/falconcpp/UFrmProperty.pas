unit UFrmProperty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls, Mask, ImgList, Grids,
  ListGridView, ExtDlgs, UFileProperty, CheckLst, Buttons, IconDialog,
  FormEffect, EditAlign;

type

  TFrmProperty = class(TForm)
    PageCtrlProp: TPageControl;
    TSApp: TTabSheet;
    TSVersion: TTabSheet;
    TSCompiler: TTabSheet;
    GrpAppSet: TGroupBox;
    PanelIcon: TPanel;
    LblIcon: TLabel;
    LblProject: TLabel;
    EditProjName: TEdit;
    LblTarget: TLabel;
    EditTarget: TEdit;
    BtnLoadIcon: TButton;
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    ImgIcon: TImage;
    PUMIcon: TPopupMenu;
    ChangeIcon1: TMenuItem;
    RemoveIcon1: TMenuItem;
    GrbIncVer: TGroupBox;
    ChbIncVer: TCheckBox;
    GrpVersion: TGroupBox;
    ChbIncBuild: TCheckBox;
    LblMajor: TLabel;
    LblMinor: TLabel;
    LblRelease: TLabel;
    LblBuild: TLabel;
    GrpLang: TGroupBox;
    LblLocale: TLabel;
    LblLoc: TLabel;
    CbbLang: TComboBoxEx;
    ListValues: TListGridView;
    ImgLan: TImage;
    RGrpType: TRadioGroup;
    GrbOptm: TGroupBox;
    CHBMinSize: TCheckBox;
    CHBShowWar: TCheckBox;
    CHBOptSpd: TCheckBox;
    GrbClean: TGroupBox;
    CLBClean: TCheckListBox;
    TSRun: TTabSheet;
    GrbApprun: TGroupBox;
    LblParams: TLabel;
    EditParams: TEdit;
    RGAppTp: TRadioGroup;
    ChbEnbThm: TCheckBox;
    OpenIcon: TIconDialog;
    ChbReqAdmin: TCheckBox;
    PageControl1: TPageControl;
    GrbIncs: TTabSheet;
    GrbLibs: TTabSheet;
    CBLibs: TComboBox;
    SBtnAdd: TSpeedButton;
    SBtnRem: TSpeedButton;
    SBtnUp: TSpeedButton;
    SBtnDown: TSpeedButton;
    ChLbLibs: TCheckListBox;
    CBIncs: TComboBox;
    ListIncs: TListBox;
    SBtnAddInc: TSpeedButton;
    SBtnDelInc: TSpeedButton;
    SBtnUpInc: TSpeedButton;
    SBtnDownInc: TSpeedButton;
    GrbLibs1: TGroupBox;
    ChbCreateLL: TCheckBox;
    SBtnEditInc: TSpeedButton;
    SBtnEdit: TSpeedButton;
    EditMajor: TEditAlign;
    UpDownMajor: TUpDown;
    EditMinor: TEditAlign;
    UpDownMinor: TUpDown;
    EditRelease: TEditAlign;
    UpDownRelease: TUpDown;
    EditBuild: TEditAlign;
    UpDownBuild: TUpDown;
    procedure ListValuesEditColumn(Sender: TObject; ACol, ARow: Integer;
      var CanEdit: Boolean; var EditType: TEditType);
    procedure FormCreate(Sender: TObject);
    procedure SetProject(Project: TProjectProperty);
    procedure Save;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure ChbIncVerClick(Sender: TObject);
    procedure BtnLoadIconClick(Sender: TObject);
    procedure RemoveIcon1Click(Sender: TObject);
    procedure ProjectChange(Sender: TObject);
    procedure ListValuesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure VersionChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChLbLibsClick(Sender: TObject);
    procedure SBtnAddClick(Sender: TObject);
    procedure SBtnAddIncClick(Sender: TObject);
    procedure SBtnRemClick(Sender: TObject);
    procedure SBtnDelIncClick(Sender: TObject);
    procedure ListIncsClick(Sender: TObject);
    procedure ListIncsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChLbLibsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SBtnUpClick(Sender: TObject);
    procedure SBtnDownClick(Sender: TObject);
    procedure SBtnUpIncClick(Sender: TObject);
    procedure SBtnDownIncClick(Sender: TObject);
    procedure ChLbLibsSelect(Sender: TObject);
    procedure ListIncsSelect(Sender: TObject);
    procedure RGAppTpClick(Sender: TObject);
    procedure CbbLangChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CBLibsKeyPress(Sender: TObject; var Key: Char);
    procedure SBtnEditIncClick(Sender: TObject);
    procedure SBtnEditClick(Sender: TObject);
    procedure ChLbLibsDblClick(Sender: TObject);
    procedure ListIncsDblClick(Sender: TObject);
    procedure ChbCreateLLClick(Sender: TObject);
    procedure CBIncsKeyPress(Sender: TObject; var Key: Char);
    procedure VersionNumbersChange(Sender: TObject);
    procedure VersionNumbersKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownVersionClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    Project: TProjectProperty;
    IconChanged, IsLoading: Boolean;
    AppIcon: TIcon;
  end;

var
  FrmProperty: TFrmProperty;

implementation

uses UUtils, UFrmMain, ULanguages, UConfig;

{$R *.dfm}

procedure TFrmProperty.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmProperty.Save;
var
  Temp, OldFlags: string;
  I: Integer;
begin
  if (Project.FileType = FILE_TYPE_PROJECT) then
    Project.FileName := ExtractFilePath(Project.FileName) +
      ExtractName(EditProjName.Text) + '.fpj'
  else
    Project.FileName := ExtractFilePath(Project.FileName) +
      ExtractName(EditProjName.Text) +
      ExtractFileExt(Project.FileName);
  Project.Target := EditTarget.Text;
  if IconChanged then
    Project.Icon := AppIcon;
  IconChanged := False;
  Project.CmdLine := EditParams.Text;
  Project.CompilerType := RGrpType.ItemIndex;
  Temp := '';
  if CHBShowWar.Checked then
    Temp := '-Wall';
  if CHBMinSize.Checked then
    Temp := Temp + ' -s';
  if CHBOptSpd.Checked then
    Temp := Temp + ' -O2';
  Project.CompilerOptions := Trim(Temp);
  Temp := '';
  for I := 0 to Pred(ChLbLibs.Count) do
    if ChLbLibs.Checked[I] then
    begin
      if Pos(' ', ChLbLibs.Items.Strings[I]) > 0 then
        Temp := Temp + ' ' + ChLbLibs.Items.QuoteChar + ChLbLibs.Items.Strings[I]
          + ChLbLibs.Items.QuoteChar
      else
        Temp := Temp + ' ' + ChLbLibs.Items.Strings[I];
    end;
  Project.Libs := Trim(Temp);
  Temp := '';
  for I := 0 to Pred(ListIncs.Count) do
  begin
    if Pos(' ', ListIncs.Items.Strings[I]) > 0 then
      Temp := Temp + ' ' + ListIncs.Items.QuoteChar + ListIncs.Items.Strings[I]
        + ListIncs.Items.QuoteChar
    else
      Temp := Temp + ' ' + ListIncs.Items.Strings[I];
  end;
  OldFlags := Project.Flags;
  Project.Flags := Trim(Temp);
  Project.DeleteObjsBefore := CLBClean.Checked[0];
  Project.DeleteObjsAfter := CLBClean.Checked[1];
  Project.DeleteMakefileAfter := CLBClean.Checked[2];
  Project.DeleteResourcesAfter := CLBClean.Checked[3];
  Project.IncludeVersionInfo := ChbIncVer.Checked;
  Project.AppType := RGAppTp.ItemIndex;
  Project.EnableTheme := ChbEnbThm.Checked;
  Project.RequiresAdmin := ChbReqAdmin.Checked;
  Project.Version.Major := UpDownMajor.Position;
  Project.Version.Minor := UpDownMinor.Position;
  Project.Version.Release := UpDownRelease.Position;
  Project.Version.Build := UpDownBuild.Position;
  Project.AutoIncBuild := ChbIncBuild.Checked;
  Project.Version.LanguageID := TLanguageItem(
    CbbLang.ItemsEx.Items[CbbLang.ItemIndex].Data).ID;
  Project.Version.CompanyName := ListValues.Cells[1, 1];
  Project.Version.FileDescription := ListValues.Cells[1, 2];
  Project.Version.FileVersion := ListValues.Cells[1, 3];
  Project.Version.InternalName := ListValues.Cells[1, 4];
  Project.Version.ProductName := ListValues.Cells[1, 5];
  Project.Version.ProductVersion := ListValues.Cells[1, 6];
  Project.Version.LegalCopyright := ListValues.Cells[1, 7];
  Project.Version.LegalTrademarks := ListValues.Cells[1, 8];
  Project.Version.OriginalFilename := ListValues.Cells[1, 9];
  Project.PropertyChanged := True;
  Project.CompilePropertyChanged := True;
  if OldFlags <> Project.Flags then
    Project.ForceClean := True;
  FrmFalconMain.TreeViewProjectsChange(Self, Project.Node);
end;

procedure TFrmProperty.SetProject(Project: TProjectProperty);
var
  List: TStrings;
  I: Integer;
begin
  if (self.Project <> Project) then
  begin
    Self.Project := Project;
    EditProjName.Text := Project.Name;
    EditTarget.Text := Project.Target;
    ImgIcon.Picture.Icon := Project.Icon;
    IconChanged := False;
    RGAppTp.ItemIndex := Project.AppType;
    RGAppTpClick(Self);
    ChbEnbThm.Checked := Project.EnableTheme;
    ChbCreateLL.Checked := Pos('--out-implib,', Project.Libs) > 0;
    ChbReqAdmin.Checked := Project.RequiresAdmin;
    EditParams.Text := Project.CmdLine;
    RGrpType.ItemIndex := Project.CompilerType;
    CLBClean.Checked[0] := Project.DeleteObjsBefore;
    CLBClean.Checked[1] := Project.DeleteObjsAfter;
    CLBClean.Checked[2] := Project.DeleteMakefileAfter;
    CLBClean.Checked[3] := Project.DeleteResourcesAfter;
    CHBShowWar.Checked := (Pos('-Wall', Project.CompilerOptions) > 0);
    CHBMinSize.Checked := (Pos('-s', Project.CompilerOptions) > 0);
    CHBOptSpd.Checked := (Pos('-O2', Project.CompilerOptions) > 0);
    List := TStringList.Create;
    List.Delimiter := ' ';
    List.DelimitedText := Trim(Project.Libs);

    for I := 0 to Pred(List.Count) do
      ChLbLibs.Checked[ChLbLibs.Items.Add(List.Strings[I])] := True;

    List.DelimitedText := Trim(Project.Flags);
    for I := 0 to Pred(List.Count) do
      ListIncs.Items.Add(List.Strings[I]);
    List.Free;
    ChbIncVer.Checked := Project.IncludeVersionInfo;
    ChbIncVerClick(ChbIncVer);
    UpDownMajor.Position := Project.Version.Major;
    UpDownMinor.Position := Project.Version.Minor;
    UpDownRelease.Position := Project.Version.Release;
    UpDownBuild.Position := Project.Version.Build;
    ChbIncBuild.Checked := Project.AutoIncBuild;
    ListValues.Cells[1, 1] := Project.Version.CompanyName;
    ListValues.Cells[1, 2] := Project.Version.FileDescription;
    ListValues.Cells[1, 3] := Project.Version.FileVersion;
    ListValues.Cells[1, 4] := Project.Version.InternalName;
    ListValues.Cells[1, 5] := Project.Version.ProductName;
    ListValues.Cells[1, 6] := Project.Version.ProductVersion;
    ListValues.Cells[1, 7] := Project.Version.LegalCopyright;
    ListValues.Cells[1, 8] := Project.Version.LegalTrademarks;
    ListValues.Cells[1, 9] := Project.Version.OriginalFilename;
  end;
  IsLoading := False;
end;

procedure TFrmProperty.ListValuesEditColumn(Sender: TObject; ACol,
  ARow: Integer; var CanEdit: Boolean; var EditType: TEditType);
begin
  if (ACol = 0) then
    CanEdit := False;
end;

procedure TFrmProperty.FormCreate(Sender: TObject);
  function SetLangImg(LCID: Cardinal): Integer;
  var
    Index, I: Integer;
  begin
    Result := -1;
    Index := -1;
    for I := 0 to Pred(CbbLang.ItemsEx.Count) do
      if (TLanguageItem(CbbLang.ItemsEx.Items[I].Data).ID = LCID) then
      begin
        Result := CbbLang.ItemsEx.Items[I].Index;
        Index := CbbLang.ItemsEx.Items[I].ImageIndex;
        Break;
      end;
    FrmFalconMain.ImgListCountry.GetBitmap(Index, ImgLan.Picture.Bitmap);
  end;
var
  LangItem: TLanguageItem;
  Item: TComboExItem;
  I, ActIdx: Integer;
  List: TStrings;
  LibPath: string;
begin
  IsLoading := True;
  LblLoc.Caption := GetLanguageName(0);
  List := GetLanguagesList;
  for I := 0 to Pred(List.Count) do
  begin
    LangItem := TLanguageItem(List.Objects[I]);
    Item := CbbLang.ItemsEx.Add;
    Item.Caption := LangItem.Name;
    Item.Data := LangItem;
    Item.ImageIndex := LangItem.ImageIndex;
  end;
  ActIdx := SetLangImg(GetSystemDefaultLangID);
  CbbLang.ItemIndex := ActIdx;

  LibPath := FrmFalconMain.Config.Compiler.Path + '\lib\';
  if DirectoryExists(LibPath) then
  begin
    List.Clear;
    FindFiles(LibPath + '*.a', List);
    for I := 0 to Pred(List.Count) do
    begin
      CBLibs.Items.Add(
        StringReplace(
        ChangeFileExt(List.Strings[I], ''), 'lib', '-l', []));
    end;
    List.Clear;
    FindFiles(LibPath + '*.lib', List);
    for I := 0 to Pred(List.Count) do
      CBLibs.Items.Add('-l' + ChangeFileExt(List.Strings[I], ''));
  end;
  List.Free;
  ListValues.ColWidths[0] := 100;
  ListValues.ColWidths[1] := 278;
  ListValues.Col := 1;
  ListValues.AllowTitleClick := False;
  ListValues.Cells[0, 0] := STR_FRM_PROP[26];
  ListValues.Cells[1, 0] := STR_FRM_PROP[27];
  ListValues.Cells[0, 1] := 'CompanyName';
  ListValues.Cells[0, 2] := 'FileDescription';
  ListValues.Cells[0, 3] := 'FileVersion';
  ListValues.Cells[0, 4] := 'InternalName';
  ListValues.Cells[0, 5] := 'ProductName';
  ListValues.Cells[0, 6] := 'ProductVersion';
  ListValues.Cells[0, 7] := 'LegalCopyright';
  ListValues.Cells[0, 8] := 'LegalTrademarks';
  ListValues.Cells[0, 9] := 'OriginalFilename';
  ////////////////////
  Caption := STR_FRM_PROP[46];
  //Tabs
  TSApp.Caption := STR_FRM_PROP[1];
  TSVersion.Caption := STR_FRM_PROP[2];
  TSCompiler.Caption := STR_FRM_PROP[3];
  TSRun.Caption := STR_FRM_PROP[4];

  //Sheet Application
  GrpAppSet.Caption := STR_FRM_PROP[5];
  LblProject.Caption := STR_FRM_PROP[6];
  LblTarget.Caption := STR_FRM_PROP[7];
  LblIcon.Caption := STR_FRM_PROP[8];
  ImgIcon.Hint := STR_FRM_PROP[9];
  BtnLoadIcon.Caption := STR_FRM_PROP[10];

  RGAppTp.Caption := STR_FRM_PROP[47];
  RGAppTp.Items.Strings[0] := STR_FRM_PROP[48];
  RGAppTp.Items.Strings[1] := STR_FRM_PROP[49];
  RGAppTp.Items.Strings[2] := STR_FRM_PROP[50];
  RGAppTp.Items.Strings[3] := STR_FRM_PROP[51];
  ChbEnbThm.Caption := STR_FRM_PROP[52];
  ChbReqAdmin.Caption := STR_FRM_PROP[53];
  ChbCreateLL.Caption := STR_FRM_PROP[54];

  //Btns
  BtnOk.Caption := STR_FRM_PROP[14];
  BtnCancel.Caption := STR_FRM_PROP[15];
  BtnApply.Caption := STR_FRM_PROP[16];

  //Sheet Version Info
  GrbIncVer.Caption := '     ' + STR_FRM_PROP[17];
  GrpVersion.Caption := STR_FRM_PROP[18];
  LblMajor.Caption := STR_FRM_PROP[19];
  LblMinor.Caption := STR_FRM_PROP[20];
  LblRelease.Caption := STR_FRM_PROP[21];
  LblBuild.Caption := STR_FRM_PROP[22];
  ChbIncBuild.Caption := STR_FRM_PROP[23];
  GrpLang.Caption := STR_FRM_PROP[24];
  LblLocale.Caption := STR_FRM_PROP[25];

  //Sheet Compiler
  RGrpType.Caption := STR_FRM_PROP[28];
  GrbOptm.Caption := STR_FRM_PROP[29];
  CHBMinSize.Caption := STR_FRM_PROP[30];
  CHBShowWar.Caption := STR_FRM_PROP[31];
  CHBOptSpd.Caption := STR_FRM_PROP[32];
  GrbLibs.Caption := STR_FRM_PROP[33];
  SBtnAdd.Hint := STR_FRM_PROP[34];
  SBtnAddInc.Hint := STR_FRM_PROP[34];
  SBtnRem.Hint := STR_FRM_PROP[35];
  SBtnEdit.Hint := STR_FRM_PROP[70];
  SBtnDelInc.Hint := STR_FRM_PROP[35];
  SBtnUp.Hint := STR_FRM_PROP[36];
  SBtnUpInc.Hint := STR_FRM_PROP[36];
  SBtnDown.Hint := STR_FRM_PROP[37];
  SBtnDownInc.Hint := STR_FRM_PROP[37];
  SBtnEditInc.Hint := STR_FRM_PROP[70];
  GrbIncs.Caption := STR_FRM_PROP[38];
  GrbClean.Caption := STR_FRM_PROP[39];
  CLBClean.Items.Strings[0] := STR_FRM_PROP[40];
  CLBClean.Items.Strings[1] := STR_FRM_PROP[41];
  CLBClean.Items.Strings[2] := STR_FRM_PROP[42];
  CLBClean.Items.Strings[3] := STR_FRM_PROP[43];

  //Sheet Run
  GrbApprun.Caption := STR_FRM_PROP[44];
  LblParams.Caption := STR_FRM_PROP[45];
end;

procedure TFrmProperty.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmProperty.BtnApplyClick(Sender: TObject);
begin
  Save;
  BtnApply.Enabled := False;
end;

procedure TFrmProperty.BtnOkClick(Sender: TObject);
begin
  if BtnApply.Enabled then
    Save;
  Close;
end;

procedure TFrmProperty.ChbIncVerClick(Sender: TObject);
var
  I, X: Integer;
begin
  ProjectChange(Sender);
  for I := 0 to Pred(GrbIncVer.ControlCount) do
  begin
    if not (GrbIncVer.Controls[I] = ChbIncVer) then
    begin
      if (GrbIncVer.Controls[I] is TGroupBox) then
        for X := 0 to Pred(TGroupBox(GrbIncVer.Controls[I]).ControlCount) do
          TGroupBox(GrbIncVer.Controls[I]).Controls[X].Enabled := ChbIncVer.Checked;
      GrbIncVer.Controls[I].Enabled := ChbIncVer.Checked;
    end;
  end;
end;

procedure TFrmProperty.BtnLoadIconClick(Sender: TObject);
begin
  if OpenIcon.Execute then
  begin
    if not Assigned(AppIcon) then
      AppIcon := TIcon.Create;
    if UpperCase(ExtractFileExt(OpenIcon.FileName)) = '.ICO' then
      AppIcon.LoadFromFile(OpenIcon.FileName)
    else
      AppIcon.Assign(OpenIcon.Icon);
    ImgIcon.Picture.Icon := AppIcon;
    IconChanged := True;
    ProjectChange(Sender);
  end;
end;

procedure TFrmProperty.RemoveIcon1Click(Sender: TObject);
begin
  if Assigned(AppIcon) then
  begin
    AppIcon.Free;
    AppIcon := nil;
  end;
  IconChanged := True;
  ImgIcon.Picture.Icon := nil;
  ProjectChange(Sender);
end;

procedure TFrmProperty.ProjectChange(Sender: TObject);
begin
  if not IsLoading then
    BtnApply.Enabled := True;
end;

procedure TFrmProperty.ListValuesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  ProjectChange(Sender);
end;

procedure TFrmProperty.VersionChange(Sender: TObject);
begin
  ListValues.Cells[1, 3] := Format('%d.%d.%d.%d', [UpDownMajor.Position,
    UpDownMinor.Position, UpDownRelease.Position, UpDownBuild.Position]);
  ProjectChange(Sender);
end;

procedure TFrmProperty.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TFrmProperty.ChLbLibsClick(Sender: TObject);
var
  CPos: TPoint;
begin
  GetCursorPos(CPos);
  if (ChLbLibs.ItemAtPos(ChLbLibs.ScreenToClient(CPos), True) < 0) then
    ChLbLibs.ItemIndex := -1;
  ChLbLibsSelect(Sender);
end;

procedure TFrmProperty.SBtnAddClick(Sender: TObject);
var
  I: Integer;
begin
  if (Length(Trim(CBLibs.Text)) = 0) then
  begin
    with TOpenDialog.Create(Self) do
    begin
      Options := Options + [ofFileMustExist];
      Filter := 'Library File (*.a, *.lib)|*.a;*.lib';
      FilterIndex := 0;
      InitialDir := FrmFalconMain.Config.Compiler.Path + '\lib\';
      if Execute then
      begin
        if CompareText(ExtractFileExt(FileName), '.a') = 0 then
        begin
          CBLibs.Text := StringReplace(ExtractName(FileName),
            'lib', '-l', []);
        end
        else
          CBLibs.Text := '-l' + ChangeFileExt(FileName, '');
        SBtnAdd.Click;
      end;
      Free;
    end;
  end
  else
  begin
    if not ChLbLibs.Enabled then
    begin
      ChLbLibs.Enabled := True;
      ChLbLibs.Items.Strings[ChLbLibs.ItemIndex] := CBLibs.Text;
      CBLibs.Text := '';
      ChLbLibsSelect(Sender);
      ProjectChange(Sender);
      Exit;
    end;
    I := ChLbLibs.Items.IndexOf(CBLibs.Text);
    if (I < 0) then
      ChLbLibs.Checked[ChLbLibs.Items.Add(CBLibs.Text)] := True
    else
    begin
      if ChLbLibs.Checked[I] then
      begin
        CBLibs.Text := '';
        Exit;
      end
      else
        ChLbLibs.Checked[I] := True;
    end;
    CBLibs.Text := '';
    ChLbLibsSelect(Sender);
    ProjectChange(Sender);
  end;
end;

procedure TFrmProperty.ChLbLibsSelect(Sender: TObject);
begin
  SBtnRem.Enabled := (ChLbLibs.ItemIndex > -1);
  SBtnUp.Enabled := (ChLbLibs.ItemIndex > 0);
  SBtnDown.Enabled := (ChLbLibs.ItemIndex < Pred(ChLbLibs.Count))
    and (ChLbLibs.ItemIndex > -1);
  SBtnEdit.Enabled := (ChLbLibs.ItemIndex > -1);
end;

procedure TFrmProperty.SBtnRemClick(Sender: TObject);
begin
  if (ChLbLibs.ItemIndex > -1) then
    ChLbLibs.DeleteSelected;
  ChLbLibsSelect(Sender);
  ProjectChange(Sender);
end;

procedure TFrmProperty.ChLbLibsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ChLbLibs.ItemIndex >= 0) and (Key = VK_DELETE) then
    SBtnRem.Click;
  ChLbLibsSelect(Sender);
end;

procedure TFrmProperty.SBtnUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ChLbLibs.ItemIndex - 1;
  ChLbLibs.Items.Move(ChLbLibs.ItemIndex, ChLbLibs.ItemIndex - 1);
  ChLbLibs.Selected[Index] := True;
  ChLbLibsSelect(Sender);
  ProjectChange(Sender);
end;

procedure TFrmProperty.SBtnDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ChLbLibs.ItemIndex + 1;
  ChLbLibs.Items.Move(ChLbLibs.ItemIndex, ChLbLibs.ItemIndex + 1);
  ChLbLibs.Selected[Index] := True;
  ChLbLibsSelect(Sender);
  ProjectChange(Sender);
end;

procedure TFrmProperty.ListIncsSelect(Sender: TObject);
begin
  SBtnDelInc.Enabled := (ListIncs.ItemIndex > -1);
  SBtnUpInc.Enabled := (ListIncs.ItemIndex > 0);
  SBtnDownInc.Enabled := (ListIncs.ItemIndex < Pred(ListIncs.Count))
    and (ListIncs.ItemIndex > -1);
  SBtnEditInc.Enabled := (ListIncs.ItemIndex > -1);
end;

procedure TFrmProperty.SBtnAddIncClick(Sender: TObject);
var
  Direct, ProjDir: string;
  I: Integer;
begin
  if (Length(Trim(CBIncs.Text)) = 0) then
  begin
    ProjDir := ExtractFilePath(Project.FileName);
    Direct := ProjDir;
    if BrowseDialog(Handle, STR_FRM_PROP[69], Direct) then
    begin
      Direct := ExtractRelativePath(ProjDir, Direct);
      if (Pos('\', Direct) > 0) then
        CBIncs.Text := '-I"' + Direct + '"'
      else
        CBIncs.Text := '-I' + Direct;
      SBtnAddInc.Click;
    end;
  end
  else
  begin
    if not ListIncs.Enabled then
    begin
      ListIncs.Enabled := True;
      ListIncs.Items.Strings[ListIncs.ItemIndex] := CBIncs.Text;
      CBIncs.Text := '';
      ListIncsSelect(Sender);
      ProjectChange(Sender);
      Exit;
    end;
    I := ListIncs.Items.IndexOf(CBIncs.Text);
    if (I < 0) then
      ListIncs.Items.Add(CBIncs.Text)
    else
    begin
      CBIncs.Text := '';
      Exit;
    end;
    CBIncs.Text := '';
    ListIncsSelect(Sender);
    ProjectChange(Sender);
  end;
end;

procedure TFrmProperty.SBtnUpIncClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListIncs.ItemIndex - 1;
  ListIncs.Items.Move(ListIncs.ItemIndex, ListIncs.ItemIndex - 1);
  ListIncs.Selected[Index] := True;
  ListIncsSelect(Sender);
  ProjectChange(Sender);
end;

procedure TFrmProperty.SBtnDownIncClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListIncs.ItemIndex + 1;
  ListIncs.Items.Move(ListIncs.ItemIndex, ListIncs.ItemIndex + 1);
  ListIncs.Selected[Index] := True;
  ListIncsSelect(Sender);
  ProjectChange(Sender);
end;

procedure TFrmProperty.SBtnDelIncClick(Sender: TObject);
begin
  if (ListIncs.ItemIndex > -1) then
    ListIncs.DeleteSelected;
  ListIncsSelect(Sender);
  ProjectChange(Sender);
end;

procedure TFrmProperty.ListIncsClick(Sender: TObject);
var
  CPos: TPoint;
begin
  GetCursorPos(CPos);
  if (ListIncs.ItemAtPos(ListIncs.ScreenToClient(CPos), True) < 0) then
    ListIncs.ItemIndex := -1;
  ListIncsSelect(Sender);
end;

procedure TFrmProperty.ListIncsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ListIncs.ItemIndex >= 0) and (Key = VK_DELETE) then
    SBtnDelInc.Click;
  ListIncsSelect(Sender);
end;

procedure TFrmProperty.RGAppTpClick(Sender: TObject);
var
  I, Idx, Idx2: Integer;
begin
  ChbEnbThm.Visible := RGAppTp.ItemIndex = 1;
  LblIcon.Visible := RGAppTp.ItemIndex <> 3;
  PanelIcon.Visible := RGAppTp.ItemIndex <> 3;
  BtnLoadIcon.Visible := RGAppTp.ItemIndex <> 3;
  ChbReqAdmin.Visible := RGAppTp.ItemIndex < 2;
  ChbCreateLL.Visible := RGAppTp.ItemIndex = 2;
  Idx := -1;
  Idx2 := -1;
  if not IsLoading then
  begin
    case RGAppTp.ItemIndex of
      0:
        begin
          for I := Pred(ChLbLibs.Items.Count) downto 0 do
          begin
            if ChLbLibs.Items.Strings[I] = '-mwindows' then
              ChLbLibs.Items.Delete(I)
            else if ChLbLibs.Items.Strings[I] = '-shared' then
              ChLbLibs.Items.Delete(I)
            else if Pos('-Wl,--add-stdcall-alias', ChLbLibs.Items.Strings[I]) > 0 then
              ChLbLibs.Items.Delete(I);
          end;
        end;
      1:
        begin
          for I := Pred(ChLbLibs.Items.Count) downto 0 do
          begin
            if ChLbLibs.Items.Strings[I] = '-mwindows' then
            begin
              Idx := I;
              ChLbLibs.Checked[I] := True;
              if I <> 0 then
                ChLbLibs.Items.Move(I, 0);
            end
            else if ChLbLibs.Items.Strings[I] = '-shared' then
              ChLbLibs.Items.Delete(I)
            else if Pos('-Wl,--add-stdcall-alias', ChLbLibs.Items.Strings[I]) > 0 then
              ChLbLibs.Items.Delete(I);
          end;
          if Idx < 0 then
          begin
            ChLbLibs.Items.Insert(0, '-mwindows');
            ChLbLibs.Checked[0] := True;
          end;
        end;
      2:
        begin
          for I := Pred(ChLbLibs.Items.Count) downto 0 do
          begin
            if ChLbLibs.Items.Strings[I] = '-mwindows' then
              ChLbLibs.Items.Delete(I)
            else if ChLbLibs.Items.Strings[I] = '-shared' then
            begin
              Idx := I;
              ChLbLibs.Checked[I] := True;
              if I <> 0 then
                ChLbLibs.Items.Move(I, 0);
            end
            else if Pos('-Wl,--add-stdcall-alias', ChLbLibs.Items.Strings[I]) > 0 then
            begin
              Idx2 := I;
              ChLbLibs.Checked[I] := True;
              if I <> 1 then
                if ChLbLibs.Items.Count >= 2 then
                  ChLbLibs.Items.Move(I, 1);
            end;
          end;
          if Idx < 0 then
          begin
            ChLbLibs.Items.Insert(0, '-shared');
            ChLbLibs.Checked[0] := True;
          end;
          if Idx2 < 0 then
          begin
            if ChbCreateLL.Checked then
              ChLbLibs.Items.Insert(1, '-Wl,--add-stdcall-alias,--out-implib,lib'
                + ChangeFileExt(Project.Target, '.dll.a'))
            else
              ChLbLibs.Items.Insert(1, '-Wl,--add-stdcall-alias');
            ChLbLibs.Checked[1] := True;
          end;
        end;
      3:
        begin
          for I := Pred(ChLbLibs.Items.Count) downto 0 do
          begin
            if ChLbLibs.Items.Strings[I] = '-mwindows' then
              ChLbLibs.Items.Delete(I)
            else if ChLbLibs.Items.Strings[I] = '-shared' then
              ChLbLibs.Items.Delete(I)
            else if ChLbLibs.Items.Strings[I] = '-Wl,--add-stdcall-alias' then
              ChLbLibs.Items.Delete(I);
          end;
        end;
    end;
  end;
  ProjectChange(Sender);
end;

procedure TFrmProperty.CbbLangChange(Sender: TObject);
begin
  if CbbLang.ItemIndex < 0 then
    Exit;
  ProjectChange(Sender);
end;

procedure TFrmProperty.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(CbbLang.ItemsEx.Count) do
    TLanguageItem(CbbLang.ItemsEx.Items[I].Data).Free;
end;

procedure TFrmProperty.CBLibsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SBtnAdd.Click;
  end;
end;

procedure TFrmProperty.SBtnEditIncClick(Sender: TObject);
begin
  ListIncs.Enabled := False;
  SBtnEditInc.Enabled := False;
  CBIncs.Text := ListIncs.Items.Strings[ListIncs.ItemIndex];
end;

procedure TFrmProperty.SBtnEditClick(Sender: TObject);
begin
  ChLbLibs.Enabled := False;
  SBtnEdit.Enabled := False;
  CBLibs.Text := ChLbLibs.Items.Strings[ChLbLibs.ItemIndex];
end;

procedure TFrmProperty.ChLbLibsDblClick(Sender: TObject);
begin
  if SBtnEdit.Enabled then
    SBtnEditClick(Sender);
end;

procedure TFrmProperty.ListIncsDblClick(Sender: TObject);
begin
  if SBtnEditInc.Enabled then
    SBtnEditIncClick(Sender);
end;

procedure TFrmProperty.ChbCreateLLClick(Sender: TObject);
var
  I, J: Integer;
begin
  J := -1;
  for I := 0 to Pred(ChLbLibs.Items.Count) do
  begin
    if Pos('-Wl,--add-stdcall-alias', ChLbLibs.Items.Strings[I]) > 0 then
    begin
      J := I;
      Break;
    end;
  end;
  if J >= 0 then
  begin
    if ChbCreateLL.Checked and (Pos(',--out-implib,', ChLbLibs.Items.Strings[J]) = 0) then
    begin
      ChLbLibs.Items.Strings[J] := ChLbLibs.Items.Strings[J] +
        ',--out-implib,lib' + ChangeFileExt(Project.Target, '.dll.a');
    end
    else if not ChbCreateLL.Checked then
      ChLbLibs.Items.Strings[J] := '-Wl,--add-stdcall-alias';
  end;
  ProjectChange(Sender);
end;

procedure TFrmProperty.CBIncsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SBtnAddInc.Click;
  end;
end;

procedure TFrmProperty.VersionNumbersChange(Sender: TObject);
begin
  if Length(TEditAlign(Sender).Text) > 0 then
  begin
    case TEditAlign(Sender).Tag of
      0: UpDownMajor.Position := StrToInt(TEditAlign(Sender).Text);
      1: UpDownMinor.Position := StrToInt(TEditAlign(Sender).Text);
      2: UpDownRelease.Position := StrToInt(TEditAlign(Sender).Text);
      3: UpDownBuild.Position := StrToInt(TEditAlign(Sender).Text);
    end;
  end;
  VersionChange(Sender);
end;

procedure TFrmProperty.VersionNumbersKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, #27]) then
    Key := #0;
end;

procedure TFrmProperty.UpDownVersionClick(Sender: TObject;
  Button: TUDBtnType);
begin
  VersionChange(Sender);
end;

end.
