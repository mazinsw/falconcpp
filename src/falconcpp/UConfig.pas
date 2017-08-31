unit UConfig;

interface

{$I Falcon.inc}

uses
  Forms, Graphics, Classes, ULanguages;

const
  OFFICE_XP_THEME = 'Office XP';

type

  TEditorOptions = class
    //General
    AutoIndent: Boolean;
    InsertMode: Boolean;
    GroupUndo: Boolean;
    ShowSpaceChars: Boolean;
    AutoCloseBrackets: Boolean;

    TabIndentUnindent: Boolean;
    SmartTabs: Boolean;
    UseTabChar: Boolean;
    EnhancedHomeKey: Boolean;

    TabWidth: Integer;
    DefaultEncoding: Integer;
    EncodingWithBOM: Boolean;
    DefaultLineEnding: Integer;

    //display
    FontName: string;
    FontSize: Integer;
    ShowRightMargin: Boolean;
    RightMargin: Integer;
    ShowGutter: Boolean;
    ShowLineNumber: Boolean;
    //sintax
    ActiveSintax: string;

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
    IndentSingleLineComments: Boolean;
      //Padding
    PadEmptyLines: Boolean;
    BreakClosingHeaderBlocks: Boolean;
    InsertSpacePaddingOperators: Boolean;
    InsertSpacePaddingParenthesisOutside: Boolean;
    InsertSpacePaddingParenthesisInside: Boolean;
    ParenthesisHeaderPadding: Boolean;
    RemoveExtraSpace: Boolean;
    DeleteEmptyLines: Boolean;
    FillEmptyLines: Boolean;
      //Formatting
    BreakClosingHeadersBrackets: Boolean;
    BreakIfElse: Boolean;
    AddBrackets: Boolean;
    AddOneLineBrackets: Boolean;
    DontBreakOnelineBlocks: Boolean;
    DontBreakComplex: Boolean;
    ConvertTabToSpaces: Boolean;
    PointerAlign: Integer;
    //Code Resources
    CodeCompletion: Boolean;
    CodeParameters: Boolean;
    TooltipExpEval: Boolean;
    TooltipSymbol: Boolean;
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
    CodeTemplateFile: string;
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
    BackupFilesExt: string;
    AutoOpen: Integer;
    CreateLayoutFiles: Boolean;
    AskForDeleteFile: Boolean;
    RunConsoleRunner: Boolean;
    //Interface
    MaxFileInReopen: Integer;
    Langs: TFalconLanguages;
    ShowSplashScreen: Boolean;
    LanguageID: Cardinal;
    Theme: string;
    //Files and Directories
    AlternativeConfFileLoaded: Boolean;
    //**********************
    AlternativeConfFile: Boolean;
    ConfigurationFile: string;
    UsersDefDir: string;
    ProjectsDir: string;
    TemplatesDir: string;
    LanguageDir: string;
    constructor Create;
    destructor Destroy; override;
  end;

  TCompilerOptions = class
  public
    Path: string; //path of compiler
    Name: string;
    Version: string; //version of used compiler
    ActiveConfiguration: string;
    ReverseDebugging: Boolean;
  end;

  TConfig = class
  public
    Editor: TEditorOptions;
    Environment: TEnvironmentOptions;
    Compiler: TCompilerOptions;
    constructor Create;
    destructor Destroy; override;
    function LoadTemplates(TemplateDir: string): TStrings;
    procedure Load(const FileName: string; Form: TForm);
    procedure Save(const FileName: string; Form: TForm);
  end;

procedure WriteIniFile(const Section, Ident, Value: string);
function ReadIniFile(Section, Ident, Default: string): string;

implementation

uses UFrmMain, UUtils, SystemUtils, Windows, SysUtils, IniFiles, Dialogs,
  Menus, Controls, SpTBXItem, ModernTabs, AppConst;

procedure WriteIniFile(const Section, Ident, Value: string);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FrmFalconMain.IniConfigFile);
  ini.WriteString(Section, Ident, Value);
  ini.Free;
end;

function ReadIniFile(Section, Ident, Default: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FrmFalconMain.IniConfigFile);
  Result := ini.ReadString(Section, Ident, Default);
  ini.Free;
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
  Compiler := TCompilerOptions.Create;
end;

destructor TConfig.Destroy;
begin
  Compiler.Free;
  Environment.Free;
  Editor.Free;
  inherited Destroy;
end;

function TConfig.LoadTemplates(TemplateDir: string): TStrings;
var
  List: TStrings;
begin
  List := TStringList.Create;
  FindFiles(TemplateDir + '*.ftm', List);
  Result := List;
end;

procedure TConfig.Load(const FileName: string; Form: TForm);

  procedure SetDock(const CurrDock: Integer; Toolbar: TSpTBXToolbar;
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
  ini: TIniFile;
  pt: TPoint;
  Temp, TabOri: string;
begin
  ini := TIniFile.Create(FileName);
  with Environment do
  begin
    //Files and Directories
    AlternativeConfFile := ini.ReadBool('EnvironmentOptions',
      'AlternativeConfFile', False);
    ConfigurationFile := ini.ReadString('EnvironmentOptions',
      'ConfigurationFile', '');
    ConfigurationFile := ExpandRelativeFileName(TFrmFalconMain(Form).AppRoot, ConfigurationFile);
    if not AlternativeConfFileLoaded and AlternativeConfFile and
      FileExists(ConfigurationFile) then
    begin
      ini.Free;
      AlternativeConfFileLoaded := True;
      ini := TIniFile.Create(ConfigurationFile);
    end;
    //general
    DefaultCppNewFile := ini.ReadBool('EnvironmentOptions', 'DefaultCppNewFile', True);
    ShowToolbarsInFullscreen := ini.ReadBool('EnvironmentOptions',
      'ShowToolbarsInFullscreen', True);
    RemoveFileOnClose := ini.ReadBool('EnvironmentOptions', 'RemoveFileOnClose', True);
    OneClickOpenFile := ini.ReadBool('EnvironmentOptions', 'OneClickOpenFile', True);
    CheckForUpdates := ini.ReadBool('EnvironmentOptions', 'CheckForUpdates', True);
    CreateBackupFiles := ini.ReadBool('EnvironmentOptions', 'CreateBackupFiles', False);
    BackupFilesExt := ini.ReadString('EnvironmentOptions', 'BackupFilesExt', '.bkp');
    AutoOpen := ini.ReadInteger('EnvironmentOptions', 'AutoOpen', 4);
    CreateLayoutFiles := ini.ReadBool('EnvironmentOptions',
      'CreateLayoutFiles', True);
    AskForDeleteFile := ini.ReadBool('EnvironmentOptions',
      'AskForDeleteFile', True);
    RunConsoleRunner := ini.ReadBool('EnvironmentOptions',
      'RunConsoleRunner', True);
    //Interface
    MaxFileInReopen := ini.ReadInteger('EnvironmentOptions', 'MaxFileInReopen',
      10);
    ShowSplashScreen := ini.ReadBool('EnvironmentOptions', 'ShowSplashScreen',
      True);
    LanguageID := ini.ReadInteger('EnvironmentOptions', 'LanguageID',
      GetSystemDefaultLangID);
    Theme := ini.ReadString('EnvironmentOptions', 'Theme', OFFICE_XP_THEME);
    //Files and Directories
    UsersDefDir := ini.ReadString('EnvironmentOptions', 'UsersDefDir',
      TFrmFalconMain(Form).AppRoot);
    UsersDefDir := ExpandRelativePath(TFrmFalconMain(Form).AppRoot, UsersDefDir);
    if not DirectoryExists(UsersDefDir) then
      UsersDefDir := TFrmFalconMain(Form).AppRoot;
    if IsPortable then
    begin
      ProjectsDir := ini.ReadString('EnvironmentOptions', 'ProjectsDir',
         TFrmFalconMain(Form).AppRoot + 'Projects\');
    end
    else
    begin
      ProjectsDir := ini.ReadString('EnvironmentOptions', 'ProjectsDir',
         GetSpecialFolderPath + 'Projects\');
    end;
    ProjectsDir := ExpandRelativePath(TFrmFalconMain(Form).AppRoot, ProjectsDir);
    if not DirectoryExists(ProjectsDir) then
    begin
      if IsPortable then
        ProjectsDir := TFrmFalconMain(Form).AppRoot + 'Projects\'
      else
        ProjectsDir := GetSpecialFolderPath + 'Projects\';
    end;
    TemplatesDir := ini.ReadString('EnvironmentOptions', 'TemplatesDir',
      UsersDefDir + 'Templates\');
    TemplatesDir := ExpandRelativePath(UsersDefDir, TemplatesDir);
    if not DirectoryExists(TemplatesDir) then
      TemplatesDir := UsersDefDir + 'Templates\';
    LanguageDir := ini.ReadString('EnvironmentOptions', 'LanguageDir',
      UsersDefDir + 'Lang\');
    LanguageDir := ExpandRelativePath(UsersDefDir, LanguageDir);
    if not DirectoryExists(LanguageDir) then
      LanguageDir := UsersDefDir + 'Lang\';
  end;
  with Editor do
  begin
    //General
    AutoIndent := ini.ReadBool('EditorOptions', 'AutoIndent', True);
    InsertMode := ini.ReadBool('EditorOptions', 'InsertMode', True);
    GroupUndo := ini.ReadBool('EditorOptions', 'GroupUndo', True);

    SmartTabs := ini.ReadBool('EditorOptions', 'SmartTabs', True);
    TabIndentUnindent := ini.ReadBool('EditorOptions', 'TabIndentUnindent', True);
    UseTabChar := ini.ReadBool('EditorOptions', 'UseTabChar', True);
    EnhancedHomeKey := ini.ReadBool('EditorOptions', 'EnhancedHomeKey', False);
    ShowSpaceChars := ini.ReadBool('EditorOptions', 'ShowSpaceChars', False);
    AutoCloseBrackets := ini.ReadBool('EditorOptions', 'AutoCloseBrackets', True);

    TabWidth := ini.ReadInteger('EditorOptions', 'TabWidth', 4);
    DefaultEncoding := ini.ReadInteger('EditorOptions', 'DefaultEncoding', 0);
    EncodingWithBOM := ini.ReadBool('EditorOptions', 'EncodingWithBOM', False);
    DefaultLineEnding := ini.ReadInteger('EditorOptions', 'DefaultLineEnding', 0);
    //display
    FontName := ini.ReadString('EditorOptions', 'FontName', 'Courier New');
    FontSize := ini.ReadInteger('EditorOptions', 'FontSize', 10);
    ShowRightMargin := ini.ReadBool('EditorOptions', 'ShowRightMargin', True);
    RightMargin := ini.ReadInteger('EditorOptions', 'RightMargin', 80);
    ShowGutter := ini.ReadBool('EditorOptions', 'ShowGutter', True);
    ShowLineNumber := ini.ReadBool('EditorOptions', 'ShowLineNumber', True);
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
    IndentSingleLineComments := ini.ReadBool('EditorOptions',
      'IndentSingleLineComments', False);
      //Padding
    PadEmptyLines := ini.ReadBool('EditorOptions', 'PadEmptyLines', False);
    BreakClosingHeaderBlocks := ini.ReadBool('EditorOptions',
      'BreakClosingHeaderBlocks', False);
    InsertSpacePaddingOperators := ini.ReadBool('EditorOptions',
      'InsertSpacePaddingOperators', False);
    InsertSpacePaddingParenthesisOutside := ini.ReadBool('EditorOptions',
      'InsertSpacePaddingParenthesisOutside', False);
    InsertSpacePaddingParenthesisInside := ini.ReadBool('EditorOptions',
      'InsertSpacePaddingParenthesisInside', False);
    ParenthesisHeaderPadding := ini.ReadBool('EditorOptions',
      'ParenthesisHeaderPadding', False);
    RemoveExtraSpace := ini.ReadBool('EditorOptions', 'RemoveExtraSpace', False);
    DeleteEmptyLines := ini.ReadBool('EditorOptions', 'DeleteEmptyLines', False);
    FillEmptyLines := ini.ReadBool('EditorOptions', 'FillEmptyLines', False);
      //Formatting
    BreakClosingHeadersBrackets := ini.ReadBool('EditorOptions', 'BreakClosingHeadersBrackets',
      False);
    BreakIfElse := ini.ReadBool('EditorOptions', 'BreakIfElse', False);
    AddBrackets := ini.ReadBool('EditorOptions', 'AddBrackets', False);
    AddOneLineBrackets := ini.ReadBool('EditorOptions',
      'AddOneLineBrackets', False);
    DontBreakOnelineBlocks := ini.ReadBool('EditorOptions',
      'DontBreakOnelineBlocks', False);
    DontBreakComplex := ini.ReadBool('EditorOptions', 'DontBreakComplex', False);
    ConvertTabToSpaces := ini.ReadBool('EditorOptions', 'ConvertTabToSpaces',
      False);
    PointerAlign := ini.ReadInteger('EditorOptions', 'PointerAlign', 0);
    //Code Resources
    CodeCompletion := ini.ReadBool('EditorOptions', 'CodeCompletion', True);
    CodeParameters := ini.ReadBool('EditorOptions', 'CodeParameters', True);
    TooltipExpEval := ini.ReadBool('EditorOptions', 'TooltipExpEval', True);
    TooltipSymbol := ini.ReadBool('EditorOptions', 'TooltipSymbol', True);
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

    CodeTemplateFile := ini.ReadString('EditorOptions', 'CodeTemplateFile',
      TFrmFalconMain(Form).ConfigRoot + 'CustomAutoComplete.txt');
    CodeTemplateFile := ExpandRelativeFileName(TFrmFalconMain(Form).AppRoot, CodeTemplateFile);
    if not FileExists(CodeTemplateFile) then
      CodeTemplateFile := TFrmFalconMain(Form).ConfigRoot + 'CustomAutoComplete.txt';
  end;

  with Compiler do
  begin
    Path := ini.ReadString('CompilerOptions', 'Path', TFrmFalconMain(Form).AppRoot + 'MinGW');
    Path := ExpandRelativePath(TFrmFalconMain(Form).AppRoot, Path);
    if not DirectoryExists(Path) then
      Path := TFrmFalconMain(Form).AppRoot + 'MinGW';
    Path := ExcludeTrailingPathDelimiter(Path);
    Name := ini.ReadString('CompilerOptions', 'Name', '');
    Version := ini.ReadString('CompilerOptions', 'Version', '');
    ReverseDebugging := ini.ReadBool('CompilerOptions', 'ReverseDebugging', False);
  end;

  with TFrmFalconMain(Form) do
  begin
    ProjectPanel.Width := ini.ReadInteger('CONFIG', 'SizePanelPW', 260);
    PanelOutline.Width := ini.ReadInteger('CONFIG', 'SizePanelOLW', 160);
    PageControlMessages.Height := ini.ReadInteger('CONFIG', 'SizePanelCH', 160);
    //** toolbars
    DefaultBar.Visible := ini.ReadBool('TOOLBAR_DEFAULT', 'Visible', True);
    ToolbarCheck(0, DefaultBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_DEFAULT', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_DEFAULT', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_DEFAULT', 'Dock', 1), DefaultBar, pt);
    DefaultBar.DockPos := ini.ReadInteger('TOOLBAR_DEFAULT', 'Pos', 0);
    DefaultBar.DockRow := ini.ReadInteger('TOOLBAR_DEFAULT', 'Row', 1);

    EditBar.Visible := ini.ReadBool('TOOLBAR_EDIT', 'Visible', True);
    ToolbarCheck(1, EditBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_EDIT', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_EDIT', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_EDIT', 'Dock', 1), EditBar, pt);
    EditBar.DockPos := ini.ReadInteger('TOOLBAR_EDIT', 'Pos', 143);
    EditBar.DockRow := ini.ReadInteger('TOOLBAR_EDIT', 'Row', 1);

    SearchBar.Visible := ini.ReadBool('TOOLBAR_SEARCH', 'Visible', True);
    ToolbarCheck(2, SearchBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_SEARCH', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_SEARCH', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_SEARCH', 'Dock', 1), SearchBar, pt);
    SearchBar.DockPos := ini.ReadInteger('TOOLBAR_SEARCH', 'Pos', 179);
    SearchBar.DockRow := ini.ReadInteger('TOOLBAR_SEARCH', 'Row', 1);

    CompilerBar.Visible := ini.ReadBool('TOOLBAR_COMPILER', 'Visible', True);
    ToolbarCheck(3, CompilerBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_COMPILER', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_COMPILER', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_COMPILER', 'Dock', 1), CompilerBar, pt);
    CompilerBar.DockPos := ini.ReadInteger('TOOLBAR_COMPILER', 'Pos', 179);
    CompilerBar.DockRow := ini.ReadInteger('TOOLBAR_COMPILER', 'Row', 1);

    NavigatorBar.Visible := ini.ReadBool('TOOLBAR_NAVIGATOR', 'Visible', True);
    ToolbarCheck(4, NavigatorBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_NAVIGATOR', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_NAVIGATOR', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_NAVIGATOR', 'Dock', 1), NavigatorBar, pt);
    NavigatorBar.DockPos := ini.ReadInteger('TOOLBAR_NAVIGATOR', 'Pos', 179);
    NavigatorBar.DockRow := ini.ReadInteger('TOOLBAR_NAVIGATOR', 'Row', 1);

    ProjectBar.Visible := ini.ReadBool('TOOLBAR_PROJECT', 'Visible', True);
    ToolbarCheck(5, ProjectBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_PROJECT', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_PROJECT', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_PROJECT', 'Dock', 1), ProjectBar, pt);
    ProjectBar.DockPos := ini.ReadInteger('TOOLBAR_PROJECT', 'Pos', 395);
    ProjectBar.DockRow := ini.ReadInteger('TOOLBAR_PROJECT', 'Row', 1);

    HelpBar.Visible := ini.ReadBool('TOOLBAR_HELP', 'Visible', True);
    ToolbarCheck(6, HelpBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_HELP', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_HELP', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_HELP', 'Dock', 1), HelpBar, pt);
    HelpBar.DockPos := ini.ReadInteger('TOOLBAR_HELP', 'Pos', 447);
    HelpBar.DockRow := ini.ReadInteger('TOOLBAR_HELP', 'Row', 1);

    DebugBar.Visible := ini.ReadBool('TOOLBAR_DEBUG', 'Visible', True);
    ToolbarCheck(7, DebugBar.Visible);
    pt.X := ini.ReadInteger('TOOLBAR_DEBUG', 'X', 0);
    pt.Y := ini.ReadInteger('TOOLBAR_DEBUG', 'Y', 0);
    SetDock(ini.ReadInteger('TOOLBAR_DEBUG', 'Dock', 1), DebugBar, pt);
    DebugBar.DockPos := ini.ReadInteger('TOOLBAR_DEBUG', 'Pos', 467);
    DebugBar.DockRow := ini.ReadInteger('TOOLBAR_DEBUG', 'Row', 1);

    //Tab Orientation
    TabOri := ini.ReadString('TABS', 'Orientation', 'Top');
    if SameText(TabOri, 'bottom') then
    begin
      PageControlEditor.TabPosition := mtpBottom;
      PopTabsTabsAtTop.Enabled := True;
      PopTabsTabsAtBottom.Enabled := False;
    end
    else
    begin
      PageControlEditor.TabPosition := mtpTop;
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

procedure TConfig.Save(const FileName: string; Form: TForm);
var
  ini, oriini: TIniFile;

  function GetDock(Toolbar: TSpTBXToolbar): Integer;
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
    ini.WriteInteger('CONFIG', 'SizePanelPW', ProjectPanel.Width);
    ini.WriteInteger('CONFIG', 'SizePanelOLW', PanelOutline.Width);
    ini.WriteInteger('CONFIG', 'SizePanelCH', PageControlMessages.Height);

    //** toolbars
    ini.WriteBool('TOOLBAR_DEFAULT', 'Visible', DefaultBar.Visible);
    ini.WriteInteger('TOOLBAR_DEFAULT', 'Dock', GetDock(DefaultBar));
    ini.WriteInteger('TOOLBAR_DEFAULT', 'X', DefaultBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_DEFAULT', 'Y', DefaultBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_DEFAULT', 'Pos', DefaultBar.DockPos);
    ini.WriteInteger('TOOLBAR_DEFAULT', 'Row', DefaultBar.DockRow);

    ini.WriteBool('TOOLBAR_EDIT', 'Visible', EditBar.Visible);
    ini.WriteInteger('TOOLBAR_EDIT', 'Dock', GetDock(EditBar));
    ini.WriteInteger('TOOLBAR_EDIT', 'X', EditBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_EDIT', 'Y', EditBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_EDIT', 'Pos', EditBar.DockPos);
    ini.WriteInteger('TOOLBAR_EDIT', 'Row', EditBar.DockRow);

    ini.WriteBool('TOOLBAR_SEARCH', 'Visible', SearchBar.Visible);
    ini.WriteInteger('TOOLBAR_SEARCH', 'Dock', GetDock(SearchBar));
    ini.WriteInteger('TOOLBAR_SEARCH', 'X', SearchBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_SEARCH', 'Y', SearchBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_SEARCH', 'Pos', SearchBar.DockPos);
    ini.WriteInteger('TOOLBAR_SEARCH', 'Row', SearchBar.DockRow);

    ini.WriteBool('TOOLBAR_COMPILER', 'Visible', CompilerBar.Visible);
    ini.WriteInteger('TOOLBAR_COMPILER', 'Dock', GetDock(CompilerBar));
    ini.WriteInteger('TOOLBAR_COMPILER', 'X', CompilerBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_COMPILER', 'Y', CompilerBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_COMPILER', 'Pos', CompilerBar.DockPos);
    ini.WriteInteger('TOOLBAR_COMPILER', 'Row', CompilerBar.DockRow);

    ini.WriteBool('TOOLBAR_NAVIGATOR', 'Visible', NavigatorBar.Visible);
    ini.WriteInteger('TOOLBAR_NAVIGATOR', 'Dock', GetDock(NavigatorBar));
    ini.WriteInteger('TOOLBAR_NAVIGATOR', 'X', NavigatorBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_NAVIGATOR', 'Y', NavigatorBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_NAVIGATOR', 'Pos', NavigatorBar.DockPos);
    ini.WriteInteger('TOOLBAR_NAVIGATOR', 'Row', NavigatorBar.DockRow);

    ini.WriteBool('TOOLBAR_PROJECT', 'Visible', ProjectBar.Visible);
    ini.WriteInteger('TOOLBAR_PROJECT', 'Dock', GetDock(ProjectBar));
    ini.WriteInteger('TOOLBAR_PROJECT', 'X', ProjectBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_PROJECT', 'Y', ProjectBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_PROJECT', 'Pos', ProjectBar.DockPos);
    ini.WriteInteger('TOOLBAR_PROJECT', 'Row', ProjectBar.DockRow);

    ini.WriteBool('TOOLBAR_HELP', 'Visible', HelpBar.Visible);
    ini.WriteInteger('TOOLBAR_HELP', 'Dock', GetDock(HelpBar));
    ini.WriteInteger('TOOLBAR_HELP', 'X', HelpBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_HELP', 'Y', HelpBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_HELP', 'Pos', HelpBar.DockPos);
    ini.WriteInteger('TOOLBAR_HELP', 'Row', HelpBar.DockRow);

    ini.WriteBool('TOOLBAR_DEBUG', 'Visible', DebugBar.Visible);
    ini.WriteInteger('TOOLBAR_DEBUG', 'Dock', GetDock(DebugBar));
    ini.WriteInteger('TOOLBAR_DEBUG', 'X', DebugBar.FloatingPosition.X);
    ini.WriteInteger('TOOLBAR_DEBUG', 'Y', DebugBar.FloatingPosition.Y);
    ini.WriteInteger('TOOLBAR_DEBUG', 'Pos', DebugBar.DockPos);
    ini.WriteInteger('TOOLBAR_DEBUG', 'Row', DebugBar.DockRow);

    //Tab Orientation
    if PageControlEditor.TabPosition = mtpTop then
      ini.WriteString('TABS', 'Orientation', 'Top')
    else
      ini.WriteString('TABS', 'Orientation', 'Bottom');
  end;
  with Editor do
  begin
    //General
    ini.WriteBool('EditorOptions', 'AutoIndent', AutoIndent);
    ini.WriteBool('EditorOptions', 'InsertMode', InsertMode);
    ini.WriteBool('EditorOptions', 'GroupUndo', GroupUndo);

    ini.WriteBool('EditorOptions', 'TabIndentUnindent', TabIndentUnindent);
    ini.WriteBool('EditorOptions', 'SmartTabs', SmartTabs);
    ini.WriteBool('EditorOptions', 'UseTabChar', UseTabChar);
    ini.WriteBool('EditorOptions', 'EnhancedHomeKey', EnhancedHomeKey);

    ini.WriteBool('EditorOptions', 'ShowSpaceChars', ShowSpaceChars);
    ini.WriteBool('EditorOptions', 'AutoCloseBrackets', AutoCloseBrackets);

    ini.WriteInteger('EditorOptions', 'TabWidth', TabWidth);
    ini.WriteInteger('EditorOptions', 'DefaultEncoding', DefaultEncoding);
    ini.WriteBool('EditorOptions', 'EncodingWithBOM', EncodingWithBOM);
    ini.WriteInteger('EditorOptions', 'DefaultLineEnding', DefaultLineEnding);
    //display
    ini.WriteString('EditorOptions', 'FontName', FontName);
    ini.WriteInteger('EditorOptions', 'FontSize', FontSize);
    ini.WriteBool('EditorOptions', 'ShowRightMargin', ShowRightMargin);
    ini.WriteInteger('EditorOptions', 'RightMargin', RightMargin);
    ini.WriteBool('EditorOptions', 'ShowGutter', ShowGutter);
    ini.WriteBool('EditorOptions', 'ShowLineNumber', ShowLineNumber);
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
    ini.WriteBool('EditorOptions', 'IndentSingleLineComments',
      IndentSingleLineComments);
      //Padding
    ini.WriteBool('EditorOptions', 'PadEmptyLines', PadEmptyLines);
    ini.WriteBool('EditorOptions', 'BreakClosingHeaderBlocks', BreakClosingHeaderBlocks);
    ini.WriteBool('EditorOptions', 'InsertSpacePaddingOperators',
      InsertSpacePaddingOperators);
    ini.WriteBool('EditorOptions', 'InsertSpacePaddingParenthesisOutside',
      InsertSpacePaddingParenthesisOutside);
    ini.WriteBool('EditorOptions', 'InsertSpacePaddingParenthesisInside',
      InsertSpacePaddingParenthesisInside);
    ini.WriteBool('EditorOptions', 'ParenthesisHeaderPadding', ParenthesisHeaderPadding);
    ini.WriteBool('EditorOptions', 'RemoveExtraSpace', RemoveExtraSpace);
    ini.WriteBool('EditorOptions', 'DeleteEmptyLines', DeleteEmptyLines);
    ini.WriteBool('EditorOptions', 'FillEmptyLines', FillEmptyLines);
      //Formatting
    ini.WriteBool('EditorOptions', 'BreakClosingHeadersBrackets',
      BreakClosingHeadersBrackets);
    ini.WriteBool('EditorOptions', 'BreakIfElse', BreakIfElse);
    ini.WriteBool('EditorOptions', 'AddBrackets', AddBrackets);
    ini.WriteBool('EditorOptions', 'AddOneLineBrackets', AddOneLineBrackets);
    ini.WriteBool('EditorOptions', 'DontBreakOnelineBlocks',
      DontBreakOnelineBlocks);
    ini.WriteBool('EditorOptions', 'DontBreakComplex', DontBreakComplex);
    ini.WriteBool('EditorOptions', 'ConvertTabToSpaces', ConvertTabToSpaces);
    ini.WriteInteger('EditorOptions', 'PointerAlign', PointerAlign);
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

    ini.WriteString('EditorOptions', 'CodeTemplateFile',
      ExtractRelativePathOpt(TFrmFalconMain(Form).AppRoot, CodeTemplateFile));
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
    ini.WriteBool('EnvironmentOptions', 'CreateLayoutFiles', CreateLayoutFiles);
    ini.WriteBool('EnvironmentOptions', 'AskForDeleteFile', AskForDeleteFile);
    ini.WriteBool('EnvironmentOptions', 'RunConsoleRunner', RunConsoleRunner);
    //Interface
    ini.WriteInteger('EnvironmentOptions', 'MaxFileInReopen', MaxFileInReopen);
    ini.WriteBool('EnvironmentOptions', 'ShowSplashScreen', ShowSplashScreen);
    ini.WriteInteger('EnvironmentOptions', 'LanguageID', LanguageID);
    ini.WriteString('EnvironmentOptions', 'Theme', Theme);
    //Files and Directories
    if not AlternativeConfFileLoaded then
    begin
      ini.WriteBool('EnvironmentOptions', 'AlternativeConfFile', AlternativeConfFile);
      ini.WriteString('EnvironmentOptions', 'ConfigurationFile', ExtractRelativePathOpt(TFrmFalconMain(Form).AppRoot, ConfigurationFile));
    end
    else
    begin
      ini.WriteBool('EnvironmentOptions', 'AlternativeConfFile', False);
      ini.WriteString('EnvironmentOptions', 'ConfigurationFile', '');
      if not AlternativeConfFile then
      begin
        oriini := TIniFile.Create(TFrmFalconMain(Form).ConfigRoot + CONFIG_NAME);
        oriini.WriteBool('EnvironmentOptions', 'AlternativeConfFile', False);
        oriini.Free;
      end;
    end;
    ini.WriteString('EnvironmentOptions', 'UsersDefDir', ExtractRelativePathOpt(TFrmFalconMain(Form).AppRoot, UsersDefDir));
    ini.WriteString('EnvironmentOptions', 'ProjectsDir', ExtractRelativePathOpt(TFrmFalconMain(Form).AppRoot, ProjectsDir));
    ini.WriteString('EnvironmentOptions', 'TemplatesDir', ExtractRelativePath(UsersDefDir, TemplatesDir));
    ini.WriteString('EnvironmentOptions', 'LanguageDir', ExtractRelativePath(UsersDefDir, LanguageDir));
  end;
  with Compiler do
  begin
    ini.WriteString('CompilerOptions', 'Path', ExtractRelativePathOpt(TFrmFalconMain(Form).AppRoot, Path));
    ini.WriteString('CompilerOptions', 'Name', Name);
    ini.WriteString('CompilerOptions', 'Version', Version);
    ini.WriteBool('CompilerOptions', 'ReverseDebugging', ReverseDebugging);
  end;
  ini.Free;
end;

end.
