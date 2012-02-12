unit UFrmEnvOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, RzEdit, RzSpnEdt, Buttons,
  ShellAPI;

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
    GroupBoxCreateBkpFiles: TGroupBox;
    CheckBoxCreateBkpFiles: TCheckBox;
    LabelExtCreateBkp: TLabel;
    EditExtension: TEdit;
    CheckBoxShowToolbars: TCheckBox;
    CheckBoxOneClickFile: TCheckBox;
    CheckBoxCheckForUpdate: TCheckBox;
    GroupBoxAutoReloadExterModFiles: TGroupBox;
    CheckBoxAutoReloadExterModFiles: TCheckBox;
    LblDelay: TLabel;
    TrackBarReloadDelay: TTrackBar;
    LblSecStart: TLabel;
    LblSecEnd: TLabel;
    LabelMaxFileReopenMenu: TLabel;
    EditmaxFilesInReopen: TRzSpinEdit;
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
    TimerNormalDelay: TTimer;
    LabelProjDir: TLabel;
    EditProjDir: TEdit;
    BtnChooseProjDir: TSpeedButton;
    CheckBoxRemoveFileOnClose: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnChooseDirClick(Sender: TObject);
    procedure BtnViewDirClick(Sender: TObject);
    procedure CheckBoxEnableGroupClick(Sender: TObject);
    procedure TimerNormalDelayTimer(Sender: TObject);
    procedure TrackBarReloadDelayChange(Sender: TObject);
    procedure EditorOptionsChanged(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    { Private declarations }
    Loading: Boolean;
    procedure OptionsChange;
  public
    { Public declarations }
    procedure ReloadLanguages;
    procedure Load;
    procedure UpdateLangNow;
  end;

var
  FrmEnvOptions: TFrmEnvOptions;

implementation

uses UFrmMain, ULanguages, UConfig, UUtils, UTemplates, UFileProperty;

{$R *.dfm}

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
  if Loading then Exit;
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
    CheckBoxCreateBkpFiles.Checked := CreateBackupFiles;
    CheckBoxEnableGroupClick(CheckBoxCreateBkpFiles);
    EditExtension.Text := BackupFilesExt;
    RadioGroupAutoOpen.ItemIndex := AutoOpen;
    CheckBoxAutoReloadExterModFiles.Checked := AutoReloadExternalModFiles;
    CheckBoxEnableGroupClick(CheckBoxAutoReloadExterModFiles);
    TrackBarReloadDelay.Position := AutoReloadDelay;
    //Interface
    EditmaxFilesInReopen.IntValue := MaxFileInReopen;
    ReloadLanguages;
    CheckBoxShowSplashScreen.Checked := ShowSplashScreen;
    if Theme = 'Default' then
      RadioGroupTheme.ItemIndex := 0
    else if Theme = 'Office11Adaptive' then
      RadioGroupTheme.ItemIndex := 1
    else if Theme = 'OfficeXP' then
      RadioGroupTheme.ItemIndex := 2
    else
      RadioGroupTheme.ItemIndex := 2;
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
//
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
  Dir, Title, Base: String;
begin
  Base := EditUsersDefDir.Text;
  case TComponent(Sender).Tag of
    0: Title := 'Select ' + LowerCase(LabelUserDefDir.Caption);
    1: Title := 'Select ' + LowerCase(LabelTemplatesDir.Caption);
    2: Title := 'Select ' + LowerCase(LabelLangDir.Caption);
    3: Title := 'Select ' + LowerCase(LabelProjDir.Caption);
  else
    Title := 'Select directory';
  end;
  case TComponent(Sender).Tag of
    0: Dir := Base;//EditUsersDefDir.Text;
    1: Dir := Base + EditTemplatesDir.Text;
    2: Dir := Base + EditLangDir.Text;
    3: Dir := EditProjDir.Text;
  else
    Dir := Base;
  end;
  if not DirectoryExists(Dir) then
    Dir := Base;
  if not BrowseDialog(Handle, Title, Dir) then
    Exit;
  Dir := IncludeTrailingPathDelimiter(Dir);
  case TComponent(Sender).Tag of
    0:
    begin
      EditUsersDefDir.Text := Dir;
      BtnViewHelpDir.Enabled := DirectoryExists(EditUsersDefDir.Text + 'Help\');
      BtnViewExamplesDir.Enabled := DirectoryExists(EditUsersDefDir.Text + 'Examples\');
    end;
    1: EditTemplatesDir.Text := ExtractRelativePath(Base, Dir);
    2: EditLangDir.Text := ExtractRelativePath(Base, Dir);
    3: EditProjDir.Text := Dir;
  end;
end;

procedure TFrmEnvOptions.BtnViewDirClick(Sender: TObject);
var
  Dir, Base: String;
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

procedure TFrmEnvOptions.TimerNormalDelayTimer(Sender: TObject);
begin
  LblDelay.Caption := '&Delay:';
  TimerNormalDelay.Enabled := False;
end;

procedure TFrmEnvOptions.TrackBarReloadDelayChange(Sender: TObject);
var
 S: String;
begin
  S := Format('%d', [TrackBarReloadDelay.Position]);
  LblDelay.Caption := Format('&Delay: %s sec',[S]);
  TimerNormalDelay.Enabled := False;
  TimerNormalDelay.Enabled := True;
  OptionsChange;
end;

procedure TFrmEnvOptions.EditorOptionsChanged(Sender: TObject);
begin
  OptionsChange;
end;

procedure TFrmEnvOptions.BtnApplyClick(Sender: TObject);
var
  Lang: TLanguageItem;
  OldTheme, OldTemplatesDir, OldLanguageDir: String;
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
    CreateBackupFiles := CheckBoxCreateBkpFiles.Checked;
    if CreateBackupFiles and (EditExtension.Text <> '') then
      BackupFilesExt := EditExtension.Text;
    AutoOpen := RadioGroupAutoOpen.ItemIndex;
    AutoReloadExternalModFiles := CheckBoxAutoReloadExterModFiles.Checked;
    AutoReloadDelay := TrackBarReloadDelay.Position;
    //Interface
    MaxFileInReopen := EditmaxFilesInReopen.IntValue;
    //get basic template before change language
    EmptyTemplate := FrmFalconMain.Templates.Find('Basic', STR_FRM_MAIN[9]);
    ShowSplashScreen := CheckBoxShowSplashScreen.Checked;
    OldTheme := Theme;
    case RadioGroupTheme.ItemIndex of
      0: Theme := 'Default';
      1: Theme := 'Office11Adaptive';
      2: Theme := 'OfficeXP';
    end;
    if OldTheme <> Theme then
      FrmFalconMain.SelectTheme(Theme);
    //Files and Directories
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
    if CompareText(OldLanguageDir, LanguageDir) <> 0 then
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
    //reload templates
    if CompareText(OldTemplatesDir, TemplatesDir) <> 0 then
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

end.
