unit UFrmEnvOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, ShellAPI, EditAlign;

type
  TFrmEnvOptions = class(TForm)
    PageControl1: TPageControl;
    BtnOk: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    TSGeneral: TTabSheet;
    TSInterface: TTabSheet;
    TSFilesandDir: TTabSheet;
    RadioGroupAutoOpen: TRadioGroup;
    CheckBoxDefCpp: TCheckBox;
    CheckBoxShowToolbars: TCheckBox;
    CheckBoxOneClickFile: TCheckBox;
    CheckBoxCheckForUpdate: TCheckBox;
    LabelMaxFileReopenMenu: TLabel;
    LabelLang: TLabel;
    ComboBoxLanguage: TComboBoxEx;
    CheckBoxShowSplashScreen: TCheckBox;
    RadioGroupTheme: TRadioGroup;
    LabelTemplatesDir: TLabel;
    EditTemplatesDir: TEdit;
    BtnChooseTemplatesDir: TSpeedButton;
    LabelLangDir: TLabel;
    EditLangDir: TEdit;
    BtnChooseLangDir: TSpeedButton;
    LabelHelpDocDir: TLabel;
    EditHelpDocDir: TEdit;
    BtnViewHelpDir: TSpeedButton;
    LabelExamplesDir: TLabel;
    EditExamplesDir: TEdit;
    BtnViewExamplesDir: TSpeedButton;
    LabelUserDefDir: TLabel;
    EditUsersDefDir: TEdit;
    BtnChooseUsersDefDir: TSpeedButton;
    GroupBoxUseAltConfFile: TGroupBox;
    CheckBoxUseAltConfFile: TCheckBox;
    LabelConfFile: TLabel;
    EditAltConfFile: TEdit;
    BtnChooseConfFile: TSpeedButton;
    LabelProjDir: TLabel;
    EditProjDir: TEdit;
    BtnChooseProjDir: TSpeedButton;
    CheckBoxRemoveFileOnClose: TCheckBox;
    CheckBoxCreateLayoutFiles: TCheckBox;
    CheckBoxAskDeleteFile: TCheckBox;
    CheckBoxRunConsoleRunner: TCheckBox;
    EditmaxFilesInReopen: TEditAlign;
    UpDownMaxFiles: TUpDown;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnChooseDirClick(Sender: TObject);
    procedure BtnViewDirClick(Sender: TObject);
    procedure CheckBoxEnableGroupClick(Sender: TObject);
    procedure EditorOptionsChanged(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure EditmaxFilesInReopenKeyPress(Sender: TObject; var Key: Char);
    procedure EditmaxFilesInReopenChange(Sender: TObject);
    procedure BtnChooseConfFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    Loading: Boolean;
    procedure OptionsChange;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure ReloadLanguages;
    procedure Load;
    procedure UpdateLangNow;
  end;

var
  FrmEnvOptions: TFrmEnvOptions;

implementation

uses UFrmMain, ULanguages, UConfig, UUtils, UTemplates, SpTBXSkins;

{$R *.dfm}

procedure TFrmEnvOptions.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

procedure TFrmEnvOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrmEnvOptions.OptionsChange;
begin
  if Loading then
    Exit;
  BtnApply.Enabled := True;
end;

procedure TFrmEnvOptions.ReloadLanguages;
var
  I: Integer;
  Item: TComboExItem;
begin
  ComboBoxLanguage.Clear;
  with FrmFalconMain.Config.Environment do
  begin
    for I := 0 to Langs.Count - 1 do
    begin
      Item := ComboBoxLanguage.ItemsEx.Add;
      Item.Caption := Langs.Items[I].Name;
      Item.Data := Langs.Items[I];
      Item.ImageIndex := Langs.Items[I].ImageIndex;
      Item.SelectedImageIndex := Langs.Items[I].ImageIndex;
      if Langs.Current.ID = Langs.Items[I].ID then
        ComboBoxLanguage.ItemIndex := Item.Index;
    end;
  end;
end;

procedure TFrmEnvOptions.Load;
var
  Index: Integer;
begin
  Loading := True;
  with FrmFalconMain.Config.Environment do
  begin
    //General
    CheckBoxDefCpp.Checked := DefaultCppNewFile;
    CheckBoxShowToolbars.Checked := ShowToolbarsInFullscreen;
    CheckBoxRemoveFileOnClose.Checked := RemoveFileOnClose;
    CheckBoxOneClickFile.Checked := OneClickOpenFile;
    CheckBoxCheckForUpdate.Checked := CheckForUpdates;
    RadioGroupAutoOpen.ItemIndex := AutoOpen;
    CheckBoxCreateLayoutFiles.Checked := CreateLayoutFiles;
    CheckBoxAskDeleteFile.Checked := AskForDeleteFile;
    CheckBoxRunConsoleRunner.Checked := RunConsoleRunner;
    CheckBoxRunConsoleRunner.Enabled :=
      FileExists(FrmFalconMain.AppRoot + 'ConsoleRunner.exe');
    //Interface
    UpDownMaxFiles.Position := MaxFileInReopen;
    ReloadLanguages;
    CheckBoxShowSplashScreen.Checked := ShowSplashScreen;
    RadioGroupTheme.Items.Clear;
    SkinManager.SkinsList.GetSkinNames(RadioGroupTheme.Items);
    Index := RadioGroupTheme.Items.IndexOf(SkinManager.CurrentSkinName);
    RadioGroupTheme.ItemIndex := Index;
    RadioGroupTheme.Height := (RadioGroupTheme.Height - RadioGroupTheme.ClientHeight) +
      CheckBoxDefCpp.Height * SkinManager.SkinsList.Count +
      ((CheckBoxDefCpp.Height div 3) * (SkinManager.SkinsList.Count - 1));
    //Files and Directories
    CheckBoxUseAltConfFile.Checked := AlternativeConfFile;
    CheckBoxEnableGroupClick(CheckBoxUseAltConfFile);
    EditAltConfFile.Text := ConfigurationFile;
    EditUsersDefDir.Text := UsersDefDir;
    EditProjDir.Text := ProjectsDir;
    EditTemplatesDir.Text := ExtractRelativePath(UsersDefDir, TemplatesDir);
    EditLangDir.Text := ExtractRelativePath(UsersDefDir, LanguageDir);
    BtnViewHelpDir.Enabled := DirectoryExists(UsersDefDir + 'Help\');
    BtnViewExamplesDir.Enabled := DirectoryExists(UsersDefDir + 'Examples\');
  end;
  Loading := False;
end;

procedure TFrmEnvOptions.UpdateLangNow;
begin
  Caption := STR_FRM_ENV_OPT[1];
  BtnOk.Caption := STR_FRM_PROP[14];
  BtnCancel.Caption := STR_FRM_PROP[15];
  BtnApply.Caption := STR_FRM_PROP[16];
  //General
  TSGeneral.Caption := STR_FRM_ENV_OPT[2];
  CheckBoxDefCpp.Caption := STR_FRM_ENV_OPT[3];
  CheckBoxShowToolbars.Caption := STR_FRM_ENV_OPT[4];
  CheckBoxRemoveFileOnClose.Caption := STR_FRM_ENV_OPT[5];
  CheckBoxOneClickFile.Caption := STR_FRM_ENV_OPT[6];
  CheckBoxCheckForUpdate.Caption := STR_FRM_ENV_OPT[7];
  CheckBoxCreateLayoutFiles.Caption := STR_FRM_ENV_OPT[8];
  CheckBoxAskDeleteFile.Caption := STR_FRM_ENV_OPT[9];
  CheckBoxRunConsoleRunner.Caption := STR_FRM_ENV_OPT[10];
  RadioGroupAutoOpen.Caption := STR_FRM_ENV_OPT[11];
  RadioGroupAutoOpen.Items.Strings[0] := STR_FRM_ENV_OPT[12];
  RadioGroupAutoOpen.Items.Strings[1] := STR_FRM_ENV_OPT[13];
  RadioGroupAutoOpen.Items.Strings[2] := STR_FRM_ENV_OPT[14];
  RadioGroupAutoOpen.Items.Strings[3] := STR_FRM_ENV_OPT[15];
  RadioGroupAutoOpen.Items.Strings[4] := STR_FRM_ENV_OPT[16];
  //Interface
  TSInterface.Caption := STR_FRM_ENV_OPT[17];
  LabelMaxFileReopenMenu.Caption := STR_FRM_ENV_OPT[18];
  LabelLang.Caption := STR_FRM_ENV_OPT[19];
  CheckBoxShowSplashScreen.Caption := STR_FRM_ENV_OPT[20];
  RadioGroupTheme.Caption := STR_FRM_ENV_OPT[21];
  //Files and Directories
  TSFilesandDir.Caption := STR_FRM_ENV_OPT[22];
  GroupBoxUseAltConfFile.Caption := '      ' + STR_FRM_ENV_OPT[23];
  LabelConfFile.Caption := STR_FRM_ENV_OPT[24];
  LabelUserDefDir.Caption := STR_FRM_ENV_OPT[25];
  LabelTemplatesDir.Caption := STR_FRM_ENV_OPT[26];
  LabelLangDir.Caption := STR_FRM_ENV_OPT[27];
  LabelProjDir.Caption := STR_FRM_ENV_OPT[28];
  LabelHelpDocDir.Caption := STR_FRM_ENV_OPT[29];
  LabelExamplesDir.Caption := STR_FRM_ENV_OPT[30];
  BtnChooseConfFile.Hint := STR_FRM_ENV_OPT[31];
  BtnChooseUsersDefDir.Hint := STR_FRM_ENV_OPT[31];
  BtnChooseTemplatesDir.Hint := STR_FRM_ENV_OPT[31];
  BtnChooseLangDir.Hint := STR_FRM_ENV_OPT[31];
  BtnChooseProjDir.Hint := STR_FRM_ENV_OPT[31];
  BtnViewHelpDir.Hint := STR_FRM_ENV_OPT[32];
  BtnViewExamplesDir.Hint := STR_FRM_ENV_OPT[32];
end;

procedure TFrmEnvOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmEnvOptions.FormDestroy(Sender: TObject);
begin
  FrmEnvOptions := nil;
end;

procedure TFrmEnvOptions.BtnChooseDirClick(Sender: TObject);
var
  Dir, Title, Base: string;
begin
  Base := EditUsersDefDir.Text;
  case TComponent(Sender).Tag of
    0: Title := STR_FRM_ENV_OPT[33] + ' ' + LowerCase(LabelUserDefDir.Caption);
    1: Title := STR_FRM_ENV_OPT[33] + ' ' + LowerCase(LabelTemplatesDir.Caption);
    2: Title := STR_FRM_ENV_OPT[33] + ' ' + LowerCase(LabelLangDir.Caption);
    3: Title := STR_FRM_ENV_OPT[33] + ' ' + LowerCase(LabelProjDir.Caption);
  else
    Title := STR_FRM_ENV_OPT[34];
  end;
  case TComponent(Sender).Tag of
    0: Dir := Base; //EditUsersDefDir.Text;
    1: Dir := Base + EditTemplatesDir.Text;
    2: Dir := Base + EditLangDir.Text;
    3: Dir := EditProjDir.Text;
  else
    Dir := Base;
  end;
  if not DirectoryExists(Dir) then
    Dir := Base;
  if not BrowseDialog(Handle, Title, Dir, True) then
    Exit;
  Dir := IncludeTrailingPathDelimiter(Dir);
  case TComponent(Sender).Tag of
    0:
      begin
        EditUsersDefDir.Text := Dir;
        BtnViewHelpDir.Enabled := DirectoryExists(EditUsersDefDir.Text + 'Help\');
        BtnViewExamplesDir.Enabled := DirectoryExists(EditUsersDefDir.Text +
          'Examples\');
      end;
    1: EditTemplatesDir.Text := ExtractRelativePath(Base, Dir);
    2: EditLangDir.Text := ExtractRelativePath(Base, Dir);
    3: EditProjDir.Text := Dir;
  end;
end;

procedure TFrmEnvOptions.BtnViewDirClick(Sender: TObject);
var
  Dir, Base: string;
begin
  Base := EditUsersDefDir.Text;
  case TComponent(Sender).Tag of
    0: Dir := Base + EditHelpDocDir.Text;
    1: Dir := Base + EditExamplesDir.Text;
  else
    Dir := Base;
  end;
  if not DirectoryExists(Dir) then
    Exit;
  ShellExecute(0, 'open', PChar(Dir), nil, nil, SW_SHOW);
end;

procedure TFrmEnvOptions.CheckBoxEnableGroupClick(Sender: TObject);
var
  I: Integer;
  GroupParent: TGroupBox;
begin
  GroupParent := TGroupBox(TCheckBox(Sender).Parent);
  for I := 0 to GroupParent.ControlCount - 1 do
  begin
    if GroupParent.Controls[I] <> Sender then
      GroupParent.Controls[I].Enabled := TCheckBox(Sender).Checked;
  end;
  OptionsChange;
end;

procedure TFrmEnvOptions.EditorOptionsChanged(Sender: TObject);
begin
  OptionsChange;
end;

procedure TFrmEnvOptions.BtnApplyClick(Sender: TObject);
var
  Lang: TLanguageItem;
  OldTheme, OldTemplatesDir, OldLanguageDir: string;
  OldLangID: Cardinal;
  EmptyTemplate: TTemplate;
  msg: TMessage;
  ForceUpdateLang: Boolean;
begin
  BtnApply.Enabled := False;
  ForceUpdateLang := False;
  with FrmFalconMain.Config.Environment do
  begin
    //General
    DefaultCppNewFile := CheckBoxDefCpp.Checked;
    ShowToolbarsInFullscreen := CheckBoxShowToolbars.Checked;
    RemoveFileOnClose := CheckBoxRemoveFileOnClose.Checked;
    OneClickOpenFile := CheckBoxOneClickFile.Checked;
    FrmFalconMain.TreeViewProjects.HotTrack := OneClickOpenFile;
    CheckForUpdates := CheckBoxCheckForUpdate.Checked;
    AutoOpen := RadioGroupAutoOpen.ItemIndex;
    CreateLayoutFiles := CheckBoxCreateLayoutFiles.Checked;
    AskForDeleteFile := CheckBoxAskDeleteFile.Checked;
    RunConsoleRunner := CheckBoxRunConsoleRunner.Checked;
    //Interface
    MaxFileInReopen := UpDownMaxFiles.Position;
    //get basic template before change language
    EmptyTemplate := FrmFalconMain.Templates.Find('Basic', STR_FRM_MAIN[9]);
    ShowSplashScreen := CheckBoxShowSplashScreen.Checked;
    OldTheme := Theme;
    if RadioGroupTheme.ItemIndex >= 0 then
      Theme := RadioGroupTheme.Items[RadioGroupTheme.ItemIndex];
    if OldTheme <> Theme then
      FrmFalconMain.SelectTheme(Theme);
    //Files and Directories
    //Alternative configuration file
    if (AlternativeConfFile <> CheckBoxUseAltConfFile.Checked) or
      ((AlternativeConfFile = CheckBoxUseAltConfFile.Checked) and
      FileExists(EditAltConfFile.Text) and AlternativeConfFile and
      not SameText(ConfigurationFile, EditAltConfFile.Text)) then
    begin
      MessageBox(Handle, PChar(STR_FRM_ENV_OPT[35]), 'Falcon C++',
        MB_ICONINFORMATION);
    end;
    AlternativeConfFile := CheckBoxUseAltConfFile.Checked;
    if FileExists(EditAltConfFile.Text) then
      ConfigurationFile := EditAltConfFile.Text;
    if DirectoryExists(EditUsersDefDir.Text) then
      UsersDefDir := IncludeTrailingPathDelimiter(EditUsersDefDir.Text);
    BtnViewHelpDir.Enabled := DirectoryExists(UsersDefDir + 'Help\');
    BtnViewExamplesDir.Enabled := DirectoryExists(UsersDefDir + 'Examples\');
    if DirectoryExists(EditProjDir.Text) then
      ProjectsDir := IncludeTrailingPathDelimiter(EditProjDir.Text);
    OldTemplatesDir := TemplatesDir;
    if DirectoryExists(EditTemplatesDir.Text) or
      DirectoryExists(UsersDefDir + EditTemplatesDir.Text) then
    begin
      if (ExtractFileDrive(EditTemplatesDir.Text) = '') and
        DirectoryExists(UsersDefDir + EditTemplatesDir.Text) then
        TemplatesDir := UsersDefDir + EditTemplatesDir.Text
      else
        TemplatesDir := ExtractRelativePath(UsersDefDir, EditTemplatesDir.Text);
    end;
    TemplatesDir := IncludeTrailingPathDelimiter(TemplatesDir);
    OldLanguageDir := LanguageDir;
    if DirectoryExists(EditLangDir.Text) or
      DirectoryExists(UsersDefDir + EditLangDir.Text) then
    begin
      if (ExtractFileDrive(EditLangDir.Text) = '') and
        DirectoryExists(UsersDefDir + EditLangDir.Text) then
        LanguageDir := UsersDefDir + EditLangDir.Text
      else
        LanguageDir := ExtractRelativePath(UsersDefDir, EditLangDir.Text);
    end;
    LanguageDir := IncludeTrailingPathDelimiter(LanguageDir);
    //reload languages
    if not SameText(OldLanguageDir, LanguageDir) then
    begin
      FrmFalconMain.Config.Environment.Langs.LangDir := LanguageDir;
      FrmFalconMain.Config.Environment.Langs.Load;
      ReloadLanguages;
      ForceUpdateLang := True;
    end;
    if ComboBoxLanguage.ItemIndex >= 0 then
    begin
      Lang := TLanguageItem(ComboBoxLanguage.ItemsEx.Items[
        ComboBoxLanguage.ItemIndex].Data);
      OldLangID := LanguageID;
      LanguageID := Lang.ID;
      if (OldLangID <> LanguageID) or ForceUpdateLang then
        Langs.UpdateLang(Lang.Name);
    end
    else
    begin
      Langs.LangDefault := True;
      if ($0409 <> LanguageID) then
        Langs.UpdateLang(Langs.Current.Name);
      if ComboBoxLanguage.ItemsEx.Count > 0 then
        ComboBoxLanguage.ItemIndex := 0;
    end;
    FrmFalconMain.Config.Save(FrmFalconMain.IniConfigFile, FrmFalconMain);
    //reload templates
    if not SameText(OldTemplatesDir, TemplatesDir) then
    begin
      FrmFalconMain.ReloadTemplates(msg);
      Exit;
    end;
    //update language template file why templates can't reloaded
    if Assigned(EmptyTemplate) then
    begin
      EmptyTemplate.Description := STR_FRM_MAIN[9];
      EmptyTemplate.Caption := STR_FRM_MAIN[9];
    end;
  end;
end;

procedure TFrmEnvOptions.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEnvOptions.BtnOkClick(Sender: TObject);
begin
  if BtnApply.Enabled then
    BtnApply.Click;
  Close;
end;

procedure TFrmEnvOptions.EditmaxFilesInReopenKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8, #27]) then
    Key := #0;
end;

procedure TFrmEnvOptions.EditmaxFilesInReopenChange(Sender: TObject);
begin
  if Length(EditmaxFilesInReopen.Text) > 0 then
    UpDownMaxFiles.Position := StrToInt(EditmaxFilesInReopen.Text);
end;

procedure TFrmEnvOptions.BtnChooseConfFileClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    Options := Options + [ofFileMustExist];
    Filter := STR_FRM_ENV_OPT[36] + '(*.ini, *.conf, *.cfg)|' +
      '*.ini; *.conf; *.cfg';
    if Execute(Self.Handle) then
    begin
      EditAltConfFile.Text := FileName;
    end;
    Free;
  end;
end;

procedure TFrmEnvOptions.FormCreate(Sender: TObject);
begin
  UpdateLangNow;
end;

procedure TFrmEnvOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close
  else if (Key = VK_RETURN) and (Shift = [ssCtrl]) then
    BtnOk.Click;
end;

end.
