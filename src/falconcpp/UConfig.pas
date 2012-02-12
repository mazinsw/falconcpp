unit UConfig;

interface

uses
  Windows, SysUtils, IniFiles, Forms, Graphics, Classes, Dialogs,
  Menus, RzCommon, RzTabs, ComCtrls, Controls, Registry, ShellApi,
  SynMemo, SynEdit, XMLDoc, XMLIntf, TBX, ULanguages;

type

  TEditorOptions = class
    //General
    AutoIndent: Boolean;
    FindTextAtCursor: Boolean;
    InsMode: Boolean;
    GrpUndo: Boolean;
    KeepTrailingSpaces: Boolean;

    ScrollHint: Boolean;
    TabIndtUnind: Boolean;
    SmartTabs: Boolean;
    UseTabChar: Boolean;
    EnhancedHomeKey: Boolean;
    ShowLineChars: Boolean;

    MaxUndo: Integer;
    TabWidth: Integer;
    //------------------------------//
    HigtMatch: Boolean;
    NColor: TColor;
    EColor: TColor;
    BColor: TColor;

    HigtCurLine: Boolean;
    CurLnColor: TColor;

    LinkClick: Boolean;
    LinkColor: TColor;
    
    //display
    FontName: String;
    FontSize: Integer;
    ShowRMargin: Boolean;
    Rmargin: Integer;
    ShowGutter: Boolean;
    GutterWdth: Integer;
    ShowLnNumb: Boolean;
    GrdGutter: Boolean;
    //sintax
    ActiveSintax: String;

    //Formatter
      //Style
    StyleIndex: Integer;
      //Indentation
    ForceUsingTabs: Boolean;
    IndentClasses: Boolean;
    IndentSwitches: Boolean;
    IndentCase: Boolean;
    IndentBrackets: Boolean;
    IndentBlocks: Boolean;
    IndentNamespaces: Boolean;
    IndentLabels: Boolean;
    IndentMultLine: Boolean;
      //Formatting
    BracketStyle: Integer;
    BreakClosingHeaders: Boolean;
    PadEmptyLines: Boolean;
    BreakIfElse: Boolean;
    InsertSpacePaddingOperators: Boolean;
    InsertSpacePaddingParenthesisOutside: Boolean;
    InsertSpacePaddingParenthesisInside: Boolean;
    RemoveExtraSpace: Boolean;
    DontBreakComplex: Boolean;
    DontBreakOnelineBlocks: Boolean;
    ConvertTabToSpaces: Boolean;
    FillEmptyLines: Boolean;
    //Code Resources
    CodeCompletion: Boolean;
    CodeParameters: Boolean;
    TooltipExpEval: Boolean;
    TooltipSymbol : Boolean;
    CodeDelay: Integer;

    CompListConstructor: TColor;
    CompListDestructor: TColor;
    CompListNamespace: TColor;
    CompListConstant: TColor;
    CompListFunc: TColor;
    CompListVar: TColor;
    CompListType: TColor;
    CompListTypedef: TColor;
    CompListPreproc: TColor;
    CompListSel: TColor;
    CompListBg: TColor;
    CodeTemplateFile: String;
  end;

  TEnvironmentOptions = class
  public
    //general
    DefaultCppNewFile: Boolean;
    ShowToolbarsInFullscreen: Boolean;
    RemoveFileOnClose: Boolean;
    OneClickOpenFile: Boolean;
    CheckForUpdates: Boolean;
    CreateBackupFiles: Boolean;
    BackupFilesExt: String;
    AutoOpen: Integer;
    AutoReloadExternalModFiles: Boolean;
    AutoReloadDelay: Integer;
    //Interface
    MaxFileInReopen: Integer;
    Langs: TFalconLanguages;
    ShowSplashScreen: Boolean;
    LanguageID: Cardinal;
    Theme: String;
    //Files and Directories
    AlternativeConfFile: Boolean;
    ConfigurationFile: String;
    UsersDefDir: String;
    ProjectsDir: String;
    TemplatesDir: String;
    LanguageDir: String;
    constructor Create;
    destructor Destroy; override;
  end;

  TConfig = class
  public
    Editor: TEditorOptions;
    Environment: TEnvironmentOptions;
    constructor Create;
    destructor Destroy; override;
    function LoadTemplates(TemplateDir: String): TStrings;
    procedure Load(const FileName:string; Form: TForm);
    procedure Save(const FileName:string; Form: TForm);
  end;

procedure WriteIniFile(Const Section, Ident, Value: String);
function ReadIniFile(Section, Ident, Default: String): String;

implementation

uses UFrmMain, UUtils, ExecWait, UTemplates;

procedure WriteIniFile(Const Section, Ident, Value: String);
var
  ini:TIniFile;
begin
  ini := TIniFile.Create(FrmFalconMain.ConfigRoot + 'Config.ini');
  ini.WriteString(Section, Ident, Value);
  ini.Free;
end;

function ReadIniFile(Section, Ident, Default: String): String;
var
  ini:TIniFile;
begin
  ini := TIniFile.Create(FrmFalconMain.ConfigRoot + 'Config.ini');
  Result := ini.ReadString(Section, Ident, Default);
  ini.Free;
end;

function ExecuteBatch(Command: String): Boolean;
var
  batchfile: TStrings;
begin
  batchfile := TStringList.Create;
  batchfile.Text := Command;
  batchfile.Add('del "' + GetTempDirectory + 'ExecBatch.bat"');
  batchfile.SaveToFile(GetTempDirectory + 'ExecBatch.bat');
  batchfile.Free;
  WinExec(Pchar(GetTempDirectory + 'ExecBatch.bat'), SW_HIDE);
  Result := True;
end;

constructor TEnvironmentOptions.Create;
begin
  inherited Create;
  Langs := TFalconLanguages.Create;
end;

destructor TEnvironmentOptions.Destroy;
begin
  Langs.Free;
  inherited Destroy;
end;

constructor TConfig.Create;
begin
  inherited Create;
  Editor := TEditorOptions.Create;
  Environment := TEnvironmentOptions.Create;
end;

destructor TConfig.Destroy;
begin
  Environment.Free;
  Editor.Free;
  inherited Destroy;
end;

function TConfig.LoadTemplates(TemplateDir: String): TStrings;
var
  List: TStrings;
begin
  List := TStringList.Create;
  FindFiles(TemplateDir + '*.ftm', List);
  Result := List;
end;

procedure TConfig.Load(const FileName:string; Form: TForm);

  procedure SetDock(const CurrDock: Integer; Toolbar: TTBXToolbar;
    const pt: TPoint);
  begin
    with TFrmFalconMain(Form) do
    begin
      case CurrDock of
        1: Toolbar.CurrentDock := DockTop;
        2: Toolbar.CurrentDock := DockBottom;
        3: Toolbar.CurrentDock := DockRight;
        4: Toolbar.CurrentDock := DockLeft;
      else
        Toolbar.CurrentDock := nil;
        Toolbar.FloatingPosition := pt;
        Toolbar.Floating := True;
      end;
    end;
  end;

var
  ini:TIniFile;
  pt: TPoint;
  Temp, TabOri: String;
begin
  ini := TIniFile.Create(FileName);
  with Environment do
  begin
    //Files and Directories
    AlternativeConfFile := ini.ReadBool('EnvironmentOptions',
      'AlternativeConfFile', False);
    ConfigurationFile := ini.ReadString('EnvironmentOptions',
      'ConfigurationFile', '');
    if AlternativeConfFile and FileExists(ConfigurationFile) then
    begin
      ini.Free;
      ini := TIniFile.Create(ConfigurationFile);
    end;
    //general
    DefaultCppNewFile := ini.ReadBool('EnvironmentOptions', 'DefaultCppNewFile', True);
    ShowToolbarsInFullscreen := ini.ReadBool('EnvironmentOptions',
      'ShowToolbarsInFullscreen', True);
    RemoveFileOnClose := ini.ReadBool('EnvironmentOptions', 'RemoveFileOnClose', True);
    OneClickOpenFile := ini.ReadBool('EnvironmentOptions', 'OneClickOpenFile', False);
    CheckForUpdates := ini.ReadBool('EnvironmentOptions', 'CheckForUpdates', True);
    CreateBackupFiles := ini.ReadBool('EnvironmentOptions', 'CreateBackupFiles', False);
    BackupFilesExt := ini.ReadString('EnvironmentOptions', 'BackupFilesExt', '.bkp');
    AutoOpen := ini.ReadInteger('EnvironmentOptions', 'AutoOpen', 4);
    AutoReloadExternalModFiles := ini.ReadBool('EnvironmentOptions',
      'AutoReloadExternalModFiles', False);
    AutoReloadDelay := ini.ReadInteger('EnvironmentOptions', 'AutoReloadDelay',
      1);
    //Interface
    MaxFileInReopen := ini.ReadInteger('EnvironmentOptions', 'MaxFileInReopen',
      10);
    ShowSplashScreen := ini.ReadBool('EnvironmentOptions', 'ShowSplashScreen',
      True);
    LanguageID := ini.ReadInteger('EnvironmentOptions', 'LanguageID',
      GetSystemDefaultLangID);
    Theme := ini.ReadString('EnvironmentOptions', 'Theme', 'OfficeXP');
    //Files and Directories
    UsersDefDir := ini.ReadString('EnvironmentOptions', 'UsersDefDir',
      TFrmFalconMain(Form).AppRoot);
    ProjectsDir := ini.ReadString('EnvironmentOptions', 'ProjectsDir',
      GetUserFolderPath + 'Projects\');
    TemplatesDir := ini.ReadString('EnvironmentOptions', 'TemplatesDir',
      UsersDefDir + 'Templates\');
    TemplatesDir := ExpandFileName(TemplatesDir);
    LanguageDir := ini.ReadString('EnvironmentOptions', 'LanguageDir',
      UsersDefDir + 'Lang\');
    LanguageDir := ExpandFileName(LanguageDir);
  end;
  with Editor do
  begin
    //General
    AutoIndent := ini.ReadBool('EditorOptions', 'AutoIndent', True);
    FindTextAtCursor := ini.ReadBool('EditorOptions', 'FindTextAtCursor', True);
    InsMode := ini.ReadBool('EditorOptions', 'InsMode', True);
    GrpUndo := ini.ReadBool('EditorOptions', 'GrpUndo', True);
    KeepTrailingSpaces := ini.ReadBool('EditorOptions', 'KeepTrailingSpaces', True);

    ScrollHint := ini.ReadBool('EditorOptions', 'ScrollHint', True);
    SmartTabs := ini.ReadBool('EditorOptions', 'SmartTabs', False);
    TabIndtUnind := ini.ReadBool('EditorOptions', 'TabIndtUnind', True);
    UseTabChar := ini.ReadBool('EditorOptions', 'UseTabChar', False);
    EnhancedHomeKey := ini.ReadBool('EditorOptions', 'EnhancedHomeKey', False);
    ShowLineChars := ini.ReadBool('EditorOptions', 'ShowLineChars', False);

    
    MaxUndo := ini.ReadInteger('EditorOptions', 'MaxUndo', 1024);
    TabWidth := ini.ReadInteger('EditorOptions', 'TabWidth', 4);
    //------------------------------//
    HigtMatch := ini.ReadBool('EditorOptions', 'HigtMatch', True);
    NColor := StringToColor(ini.ReadString('EditorOptions', 'NColor', 'clBlue'));
    EColor := StringToColor(ini.ReadString('EditorOptions', 'EColor', 'clRed'));
    BColor := StringToColor(ini.ReadString('EditorOptions', 'BColor', 'clSkyBlue'));

    HigtCurLine := ini.ReadBool('EditorOptions', 'HigtCurLine', True);
    CurLnColor := StringToColor(ini.ReadString('EditorOptions', 'CurLnColor', '$AAD5D5'));

    LinkClick := ini.ReadBool('EditorOptions', 'LinkClick', True);
    LinkColor := StringToColor(ini.ReadString('EditorOptions', 'LinkColor', 'clBlue'));
    //display
    FontName := ini.ReadString('EditorOptions', 'FontName', 'Courier New');
    FontSize := ini.ReadInteger('EditorOptions', 'FontSize', 12);
    ShowRMargin := ini.ReadBool('EditorOptions', 'ShowRMargin', True);
    Rmargin := ini.ReadInteger('EditorOptions', 'Rmargin', 80);
    ShowGutter := ini.ReadBool('EditorOptions', 'ShowGutter', True);
    GutterWdth := ini.ReadInteger('EditorOptions', 'GutterWdth', 30);
    ShowLnNumb := ini.ReadBool('EditorOptions', 'ShowLnNumb', True);
    GrdGutter := ini.ReadBool('EditorOptions', 'GrdGutter', False);
    //sintax
    ActiveSintax := ini.ReadString('EditorOptions', 'ActiveSyntax', 'Default');
    //Formatter
      //Style
    StyleIndex := ini.ReadInteger('EditorOptions', 'StyleIndex', 0);
      //Indentation
    ForceUsingTabs := ini.ReadBool('EditorOptions', 'ForceUsingTabs', False);
    IndentClasses := ini.ReadBool('EditorOptions', 'IndentClasses', False);
    IndentSwitches := ini.ReadBool('EditorOptions', 'IndentSwitches', False);
    IndentCase := ini.ReadBool('EditorOptions', 'IndentCase', False);
    IndentBrackets := ini.ReadBool('EditorOptions', 'IndentBrackets', False);
    IndentBlocks := ini.ReadBool('EditorOptions', 'IndentBlocks', False);
    IndentNamespaces := ini.ReadBool('EditorOptions', 'IndentNamespaces', False);
    IndentLabels := ini.ReadBool('EditorOptions', 'IndentLabels', False);
    IndentMultLine := ini.ReadBool('EditorOptions', 'IndentMultLine', False);
      //Formatting
    BracketStyle := ini.ReadInteger('EditorOptions', 'BracketStyle', 0);
    BreakClosingHeaders := ini.ReadBool('EditorOptions', 'BreakClosingHeaders',
      False);
    PadEmptyLines := ini.ReadBool('EditorOptions', 'PadEmptyLines', False);
    BreakIfElse := ini.ReadBool('EditorOptions', 'BreakIfElse', False);
    InsertSpacePaddingOperators := ini.ReadBool('EditorOptions',
      'InsertSpacePaddingOperators', False);
    InsertSpacePaddingParenthesisOutside := ini.ReadBool('EditorOptions',
      'InsertSpacePaddingParenthesisOutside', False);
    InsertSpacePaddingParenthesisInside := ini.ReadBool('EditorOptions',
      'InsertSpacePaddingParenthesisInside', False);
    RemoveExtraSpace := ini.ReadBool('EditorOptions', 'RemoveExtraSpace', False);
    DontBreakComplex := ini.ReadBool('EditorOptions', 'DontBreakComplex', False);
    DontBreakOnelineBlocks := ini.ReadBool('EditorOptions',
      'DontBreakOnelineBlocks', False);
    ConvertTabToSpaces := ini.ReadBool('EditorOptions', 'ConvertTabToSpaces',
      False);
    FillEmptyLines := ini.ReadBool('EditorOptions', 'FillEmptyLines', False);
    //Code Resources
    CodeCompletion := ini.ReadBool('EditorOptions', 'CodeCompletion', True);
    CodeParameters := ini.ReadBool('EditorOptions', 'CodeParameters', True);
    TooltipExpEval := ini.ReadBool('EditorOptions', 'TooltipExpEval', True);
    TooltipSymbol  := ini.ReadBool('EditorOptions', 'TooltipSymbol', True);
    CodeDelay := ini.ReadInteger('EditorOptions', 'CodeDelay', 3);

    CompListConstructor := StringToColor(ini.ReadString('EditorOptions', 'CompListConstructor', 'clGreen'));
    CompListDestructor := StringToColor(ini.ReadString('EditorOptions', 'CompListDestructor', 'clGray'));
    CompListNamespace := StringToColor(ini.ReadString('EditorOptions', 'CompListNamespace', '$004399CC'));
    CompListConstant := StringToColor(ini.ReadString('EditorOptions', 'CompListConstant', 'clGreen'));
    CompListFunc := StringToColor(ini.ReadString('EditorOptions', 'CompListFunc', 'clBlue'));
    CompListVar := StringToColor(ini.ReadString('EditorOptions', 'CompListVar', 'clMaroon'));
    CompListType := StringToColor(ini.ReadString('EditorOptions', 'CompListType', 'clOlive'));
    CompListTypedef := StringToColor(ini.ReadString('EditorOptions', 'CompListTypedef', 'clMaroon'));
    CompListPreproc := StringToColor(ini.ReadString('EditorOptions', 'CompListPreproc', 'clGreen'));
    CompListSel := StringToColor(ini.ReadString('EditorOptions', 'CompListSel', 'clHighlight'));
    CompListBg := StringToColor(ini.ReadString('EditorOptions', 'CompListBg', 'clWindow'));

    CodeTemplateFile  := ini.ReadString('EditorOptions', 'CodeTemplateFile',
      TFrmFalconMain(Form).ConfigRoot + 'CustomAutoComplete.txt');
  end;

  with TFrmFalconMain(Form) do
  begin
    RSPExplorer.Width := ini.ReadInteger('CONFIG','SizePanelPW',260);
    RSPOLine.Width := ini.ReadInteger('CONFIG','SizePanelOLW',160);
    RSPCmd.Height := ini.ReadInteger('CONFIG','SizePanelCH',160);
    //** toolbars
    DefaultBar.Visible := ini.ReadBool('TOOLBAR_DEFAULT','Visible', True);
    ToolbarCheck(0, DefaultBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_DEFAULT','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_DEFAULT','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_DEFAULT','Dock', 1), DefaultBar, pt);
    DefaultBar.DockPos := ini.ReadInteger('TOOLBAR_DEFAULT','Pos', 0);
    DefaultBar.DockRow := ini.ReadInteger('TOOLBAR_DEFAULT','Row', 1);

    EditBar.Visible := ini.ReadBool('TOOLBAR_EDIT','Visible', True);
    ToolbarCheck(1, EditBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_EDIT','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_EDIT','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_EDIT','Dock', 1), EditBar, pt);
    EditBar.DockPos := ini.ReadInteger('TOOLBAR_EDIT','Pos', 143);
    EditBar.DockRow := ini.ReadInteger('TOOLBAR_EDIT','Row', 1);

    SearchBar.Visible := ini.ReadBool('TOOLBAR_SEARCH','Visible', True);
    ToolbarCheck(2, SearchBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_SEARCH','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_SEARCH','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_SEARCH','Dock', 1), SearchBar, pt);
    SearchBar.DockPos := ini.ReadInteger('TOOLBAR_SEARCH','Pos', 179);
    SearchBar.DockRow := ini.ReadInteger('TOOLBAR_SEARCH','Row', 1);

    CompilerBar.Visible := ini.ReadBool('TOOLBAR_COMPILER','Visible', True);
    ToolbarCheck(3, CompilerBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_COMPILER','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_COMPILER','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_COMPILER','Dock', 1), CompilerBar, pt);
    CompilerBar.DockPos := ini.ReadInteger('TOOLBAR_COMPILER','Pos', 179);
    CompilerBar.DockRow := ini.ReadInteger('TOOLBAR_COMPILER','Row', 1);

    NavigatorBar.Visible := ini.ReadBool('TOOLBAR_NAVIGATOR','Visible', True);
    ToolbarCheck(4, NavigatorBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_NAVIGATOR','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_NAVIGATOR','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_NAVIGATOR','Dock', 1), NavigatorBar, pt);
    NavigatorBar.DockPos := ini.ReadInteger('TOOLBAR_NAVIGATOR','Pos', 179);
    NavigatorBar.DockRow := ini.ReadInteger('TOOLBAR_NAVIGATOR','Row', 1);

    ProjectBar.Visible := ini.ReadBool('TOOLBAR_PROJECT','Visible', True);
    ToolbarCheck(5, ProjectBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_PROJECT','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_PROJECT','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_PROJECT','Dock', 1), ProjectBar, pt);
    ProjectBar.DockPos := ini.ReadInteger('TOOLBAR_PROJECT','Pos', 395);
    ProjectBar.DockRow := ini.ReadInteger('TOOLBAR_PROJECT','Row', 1);

    HelpBar.Visible := ini.ReadBool('TOOLBAR_HELP','Visible', True);
    ToolbarCheck(6, HelpBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_HELP','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_HELP','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_HELP','Dock', 1), HelpBar, pt);
    HelpBar.DockPos := ini.ReadInteger('TOOLBAR_HELP','Pos', 447);
    HelpBar.DockRow := ini.ReadInteger('TOOLBAR_HELP','Row', 1);

    DebugBar.Visible := ini.ReadBool('TOOLBAR_DEBUG','Visible', True);
    ToolbarCheck(7, DebugBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_DEBUG','X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_DEBUG','Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_DEBUG','Dock', 1), DebugBar, pt);
    DebugBar.DockPos := ini.ReadInteger('TOOLBAR_DEBUG','Pos', 467);
    DebugBar.DockRow := ini.ReadInteger('TOOLBAR_DEBUG','Row', 1);

    //Tab Orientation
    TabOri := ini.ReadString('TABS','Orientation', 'Top');
    if CompareText(TabOri, 'bottom') = 0 then
    begin
      PageControlEditor.TabOrientation := toBottom;
      PopTabsTabsAtTop.Enabled := True;
      PopTabsTabsAtBottom.Enabled := False;
    end
    else
    begin
      PageControlEditor.TabOrientation := toTop;
      PopTabsTabsAtTop.Enabled := False;
      PopTabsTabsAtBottom.Enabled := True;
    end;
  end;
  ini.Free;
  TFrmFalconMain(Form).SelectTheme(Environment.Theme);
  Environment.Langs.LangDir := Environment.LanguageDir;
  if Environment.Langs.Load then
  begin
    Temp := Environment.Langs.GetLangByID(Environment.LanguageID);
    if Temp = '' then
      Temp := 'English';
    Environment.Langs.UpdateLang(Temp);
  end;
end;

procedure TConfig.Save(const FileName:string; Form: TForm);
var
  ini:TIniFile;

  function GetDock(Toolbar: TTBXToolbar): Integer;
  begin
    Result := 0;
    with TFrmFalconMain(Form) do
    begin
      if Toolbar.CurrentDock = DockTop then
        Result := 1
      else if Toolbar.CurrentDock = DockBottom then
        Result := 2
      else if Toolbar.CurrentDock = DockRight then
        Result := 3
      else if Toolbar.CurrentDock = DockLeft then
        Result := 4;
    end;
  end;

begin
  ini := TIniFile.Create(FileName);
  with TFrmFalconMain(Form) do
  begin
    ini.WriteInteger('CONFIG','SizePanelPW', RSPExplorer.Width);
    ini.WriteInteger('CONFIG','SizePanelOLW', RSPOLine.Width);
    ini.WriteInteger('CONFIG','SizePanelCH', RSPCmd.Height);

    //** toolbars
    ini.WriteBool('TOOLBAR_DEFAULT','Visible', DefaultBar.Visible);
    ini.WriteInteger('TOOLBAR_DEFAULT','Dock', GetDock(DefaultBar));
    ini.WriteInteger('TOOLBAR_DEFAULT','X', DefaultBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_DEFAULT','Y', DefaultBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_DEFAULT','Pos', DefaultBar.DockPos);
    ini.WriteInteger('TOOLBAR_DEFAULT','Row', DefaultBar.DockRow);

    ini.WriteBool('TOOLBAR_EDIT','Visible', EditBar.Visible);
    ini.WriteInteger('TOOLBAR_EDIT','Dock', GetDock(EditBar));
    ini.WriteInteger('TOOLBAR_EDIT','X', EditBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_EDIT','Y', EditBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_EDIT','Pos', EditBar.DockPos);
    ini.WriteInteger('TOOLBAR_EDIT','Row', EditBar.DockRow);

    ini.WriteBool('TOOLBAR_SEARCH','Visible', SearchBar.Visible);
    ini.WriteInteger('TOOLBAR_SEARCH','Dock', GetDock(SearchBar));
    ini.WriteInteger('TOOLBAR_SEARCH','X', SearchBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_SEARCH','Y', SearchBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_SEARCH','Pos', SearchBar.DockPos);
    ini.WriteInteger('TOOLBAR_SEARCH','Row', SearchBar.DockRow);

    ini.WriteBool('TOOLBAR_COMPILER','Visible', CompilerBar.Visible);
    ini.WriteInteger('TOOLBAR_COMPILER','Dock', GetDock(CompilerBar));
    ini.WriteInteger('TOOLBAR_COMPILER','X', CompilerBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_COMPILER','Y', CompilerBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_COMPILER','Pos', CompilerBar.DockPos);
    ini.WriteInteger('TOOLBAR_COMPILER','Row', CompilerBar.DockRow);

    ini.WriteBool('TOOLBAR_NAVIGATOR','Visible', NavigatorBar.Visible);
    ini.WriteInteger('TOOLBAR_NAVIGATOR','Dock', GetDock(NavigatorBar));
    ini.WriteInteger('TOOLBAR_NAVIGATOR','X', NavigatorBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_NAVIGATOR','Y', NavigatorBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_NAVIGATOR','Pos', NavigatorBar.DockPos);
    ini.WriteInteger('TOOLBAR_NAVIGATOR','Row', NavigatorBar.DockRow);

    ini.WriteBool('TOOLBAR_PROJECT','Visible', ProjectBar.Visible);
    ini.WriteInteger('TOOLBAR_PROJECT','Dock', GetDock(ProjectBar));
    ini.WriteInteger('TOOLBAR_PROJECT','X', ProjectBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_PROJECT','Y', ProjectBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_PROJECT','Pos', ProjectBar.DockPos);
    ini.WriteInteger('TOOLBAR_PROJECT','Row', ProjectBar.DockRow);

    ini.WriteBool('TOOLBAR_HELP','Visible', HelpBar.Visible);
    ini.WriteInteger('TOOLBAR_HELP','Dock', GetDock(HelpBar));
    ini.WriteInteger('TOOLBAR_HELP','X', HelpBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_HELP','Y', HelpBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_HELP','Pos', HelpBar.DockPos);
    ini.WriteInteger('TOOLBAR_HELP','Row', HelpBar.DockRow);

    ini.WriteBool('TOOLBAR_DEBUG','Visible', DebugBar.Visible);
    ini.WriteInteger('TOOLBAR_DEBUG','Dock', GetDock(DebugBar));
    ini.WriteInteger('TOOLBAR_DEBUG','X', DebugBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_DEBUG','Y', DebugBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_DEBUG','Pos', DebugBar.DockPos);
    ini.WriteInteger('TOOLBAR_DEBUG','Row', DebugBar.DockRow);

    //Tab Orientation
    if PageControlEditor.TabOrientation = toTop then
      ini.WriteString('TABS','Orientation', 'Top')
    else
      ini.WriteString('TABS','Orientation', 'Bottom');
  end;
  with Editor do
  begin
    //General
    ini.WriteBool('EditorOptions', 'AutoIndent', AutoIndent);
    ini.WriteBool('EditorOptions', 'FindTextAtCursor', FindTextAtCursor);
    ini.WriteBool('EditorOptions', 'InsMode', InsMode);
    ini.WriteBool('EditorOptions', 'GrpUndo', GrpUndo);
    ini.WriteBool('EditorOptions', 'KeepTrailingSpaces', KeepTrailingSpaces);

    ini.WriteBool('EditorOptions', 'ScrollHint', ScrollHint);
    ini.WriteBool('EditorOptions', 'TabIndtUnind', TabIndtUnind);
    ini.WriteBool('EditorOptions', 'SmartTabs', SmartTabs);
    ini.WriteBool('EditorOptions', 'UseTabChar', UseTabChar);
    ini.WriteBool('EditorOptions', 'EnhancedHomeKey', EnhancedHomeKey);
    ini.WriteBool('EditorOptions', 'ShowLineChars', ShowLineChars);

    ini.WriteInteger('EditorOptions', 'MaxUndo', MaxUndo);
    ini.WriteInteger('EditorOptions', 'TabWidth', TabWidth);
    //------------------------------//
    ini.WriteBool('EditorOptions', 'HigtMatch', HigtMatch);
    ini.WriteString('EditorOptions', 'NColor', ColorToString(NColor));
    ini.WriteString('EditorOptions', 'EColor', ColorToString(EColor));
    ini.WriteString('EditorOptions', 'BColor', ColorToString(BColor));

    ini.WriteBool('EditorOptions', 'HigtCurLine', HigtCurLine);
    ini.WriteString('EditorOptions', 'CurLnColor', ColorToString(CurLnColor));

    ini.WriteBool('EditorOptions', 'LinkClick', LinkClick);
    ini.WriteString('EditorOptions', 'LinkColor', ColorToString(LinkColor));
    //display
    ini.WriteString('EditorOptions', 'FontName', FontName);
    ini.WriteInteger('EditorOptions', 'FontSize', FontSize);
    ini.WriteBool('EditorOptions', 'ShowRMargin', ShowRMargin);
    ini.WriteInteger('EditorOptions', 'Rmargin', Rmargin);
    ini.WriteBool('EditorOptions', 'ShowGutter', ShowGutter);
    ini.WriteInteger('EditorOptions', 'GutterWdth', GutterWdth);
    ini.WriteBool('EditorOptions', 'ShowLnNumb', ShowLnNumb);
    ini.WriteBool('EditorOptions', 'GrdGutter', GrdGutter);
    //sintax
    ini.WriteString('EditorOptions', 'ActiveSyntax', ActiveSintax);
    //Formatter
      //Style
    ini.WriteInteger('EditorOptions', 'StyleIndex', StyleIndex);
      //Indentation
    ini.WriteBool('EditorOptions', 'ForceUsingTabs', ForceUsingTabs);
    ini.WriteBool('EditorOptions', 'IndentClasses', IndentClasses);
    ini.WriteBool('EditorOptions', 'IndentSwitches', IndentSwitches);
    ini.WriteBool('EditorOptions', 'IndentCase', IndentCase);
    ini.WriteBool('EditorOptions', 'IndentBrackets', IndentBrackets);
    ini.WriteBool('EditorOptions', 'IndentBlocks', IndentBlocks);
    ini.WriteBool('EditorOptions', 'IndentNamespaces', IndentNamespaces);
    ini.WriteBool('EditorOptions', 'IndentLabels', IndentLabels);
    ini.WriteBool('EditorOptions', 'IndentMultLine', IndentMultLine);
      //Formatting
    ini.WriteInteger('EditorOptions', 'BracketStyle', BracketStyle);
    ini.WriteBool('EditorOptions', 'BreakClosingHeaders', BreakClosingHeaders);
    ini.WriteBool('EditorOptions', 'PadEmptyLines', PadEmptyLines);
    ini.WriteBool('EditorOptions', 'BreakIfElse', BreakIfElse);
    ini.WriteBool('EditorOptions', 'InsertSpacePaddingOperators',
      InsertSpacePaddingOperators);
    ini.WriteBool('EditorOptions', 'InsertSpacePaddingParenthesisOutside',
      InsertSpacePaddingParenthesisOutside);
    ini.WriteBool('EditorOptions', 'InsertSpacePaddingParenthesisInside',
      InsertSpacePaddingParenthesisInside);
    ini.WriteBool('EditorOptions', 'RemoveExtraSpace', RemoveExtraSpace);
    ini.WriteBool('EditorOptions', 'DontBreakComplex', DontBreakComplex);
    ini.WriteBool('EditorOptions', 'DontBreakOnelineBlocks',
      DontBreakOnelineBlocks);
    ini.WriteBool('EditorOptions', 'ConvertTabToSpaces', ConvertTabToSpaces);
    ini.WriteBool('EditorOptions', 'FillEmptyLines', FillEmptyLines);
    //Code Resources
    ini.WriteBool('EditorOptions', 'CodeCompletion', CodeCompletion);
    ini.WriteBool('EditorOptions', 'CodeParameters', CodeParameters);
    ini.WriteBool('EditorOptions', 'TooltipExpEval', TooltipExpEval);
    ini.WriteBool('EditorOptions', 'TooltipSymbol', TooltipSymbol);
    ini.WriteInteger('EditorOptions', 'CodeDelay', CodeDelay);

    ini.WriteString('EditorOptions', 'CompListConstructor', ColorToString(CompListConstructor));
    ini.WriteString('EditorOptions', 'CompListDestructor', ColorToString(CompListDestructor));
    ini.WriteString('EditorOptions', 'CompListNamespace', ColorToString(CompListNamespace));
    ini.WriteString('EditorOptions', 'CompListConstant', ColorToString(CompListConstant));
    ini.WriteString('EditorOptions', 'CompListFunc', ColorToString(CompListFunc));
    ini.WriteString('EditorOptions', 'CompListVar', ColorToString(CompListVar));
    ini.WriteString('EditorOptions', 'CompListType', ColorToString(CompListType));
    ini.WriteString('EditorOptions', 'CompListTypedef', ColorToString(CompListTypedef));
    ini.WriteString('EditorOptions', 'CompListPreproc', ColorToString(CompListPreproc));
    ini.WriteString('EditorOptions', 'CompListSel', ColorToString(CompListSel));
    ini.WriteString('EditorOptions', 'CompListBg', ColorToString(CompListBg));

    ini.WriteString('EditorOptions', 'CodeTemplateFile', CodeTemplateFile);
  end;
  with Environment do
  begin
    //general
    ini.WriteBool('EnvironmentOptions', 'DefaultCppNewFile', DefaultCppNewFile);
    ini.WriteBool('EnvironmentOptions', 'ShowToolbarsInFullscreen',
      ShowToolbarsInFullscreen);
    ini.WriteBool('EnvironmentOptions', 'RemoveFileOnClose', RemoveFileOnClose);
    ini.WriteBool('EnvironmentOptions', 'OneClickOpenFile', OneClickOpenFile);
    ini.WriteBool('EnvironmentOptions', 'CheckForUpdates', CheckForUpdates);
    ini.WriteBool('EnvironmentOptions', 'CreateBackupFiles', CreateBackupFiles);
    ini.WriteString('EnvironmentOptions', 'BackupFilesExt', BackupFilesExt);
    ini.WriteInteger('EnvironmentOptions', 'AutoOpen', AutoOpen);
    ini.WriteBool('EnvironmentOptions', 'AutoReloadExternalModFiles',
      AutoReloadExternalModFiles);
    ini.WriteInteger('EnvironmentOptions', 'AutoReloadDelay', AutoReloadDelay);
    //Interface
    ini.WriteInteger('EnvironmentOptions', 'MaxFileInReopen', MaxFileInReopen);
    ini.WriteBool('EnvironmentOptions', 'ShowSplashScreen', ShowSplashScreen);
    ini.WriteInteger('EnvironmentOptions', 'LanguageID', LanguageID);
    ini.WriteString('EnvironmentOptions', 'Theme', Theme);
    //Files and Directories
    ini.WriteBool('EnvironmentOptions', 'AlternativeConfFile', AlternativeConfFile);
    ini.WriteString('EnvironmentOptions', 'ConfigurationFile', ConfigurationFile);
    ini.WriteString('EnvironmentOptions', 'UsersDefDir', UsersDefDir);
    ini.WriteString('EnvironmentOptions', 'ProjectsDir', ProjectsDir);
    ini.WriteString('EnvironmentOptions', 'TemplatesDir', TemplatesDir);
    ini.WriteString('EnvironmentOptions', 'LanguageDir', LanguageDir);
  end;
  ini.Free;
end;

end.
