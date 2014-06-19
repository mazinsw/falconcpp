unit UFrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, XPMan, ImgList, ExtCtrls,
  ShellApi, UConfig,
  UTemplates, SendData, OutputConsole, ShlObj, FormEffect,
  PNGImage, USourceFile, Clipbrd, CompletionProposal, UUtils,
  UFrmEditorOptions, FileDownload, SplashScreen, FormPosition,
  TBXExtItems, TB2Item, TBX, TB2Dock, TBXSwitcher, IniFiles,
  //themes
  TBXOfficeXPTheme,
  TBXAluminumTheme,
  TBXOffice2003Theme,
  TBXProfessionalTheme,
  TBXStripesTheme,
  //end themes
  AppEvnts, ThreadTokenFiles, CppParser, TokenConst, TokenFile,
  TokenHint, TokenList, TokenUtils,
  CommCtrl, DebugReader, CommandQueue,
  DebugConsts,
  XMLDoc, XMLIntf, BreakPoint, HintTree, DebugWatch,
  UParseMsgs, TBXStatusBars, XPPanels, ModernTabs,
  TB2Toolbar, ThreadFileDownload, NativeTreeView,
  PluginManager, PluginServiceManager, UEditor, CppHighlighter, SintaxList,
  AutoComplete, DScintillaTypes;

const
  crReverseArrow = TCursor(-99);
  MAX_OUTLINE_TREE_IMAGES = 29;
  TreeImages: array[0..MAX_OUTLINE_TREE_IMAGES - 1] of Integer = (
    0,  // Include List
    1,  // include
    2,  // Define List
    18, // define
    3,  // Variables and Constants List
    9,  // public variable
    10, // private variable
    11, // protected variable
    3,  // Function and Prototype List
    15, // public function
    16, // private function
    17, // protected function
    14, // prototype
    3,  // Type List
    4,  // class
    5,  // struct
    6,  // union
    7,  // enum
    19, // namespace
    20, // typedef
    5,  // typedef struct
    6,  // typedef union
    7,  // typedef enum
    21, // Enum Item
    8,  // typedef prototype
    12, // constructor
    13, // destructor
    22, // code template
    -1  // type
    );

  FILE_IMG_LIST: array[1..7] of Integer = (1, 2, 3, 4, 5, 6, 0);

  WM_RELOADFTM = WM_USER + $1008;
  WM_REPARSEFILES = WM_RELOADFTM + 1;
  WM_FALCONCPP_PLUGIN = WM_USER + $1221;
  MINLINE_TOENABLE_GOTOLINE = 3;
  {$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
  {$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER+10;
  {$EXTERNALSYM VK_OEM_PLUS}
  VK_OEM_PLUS = 187;
  {$EXTERNALSYM VK_OEM_MINUS}
  VK_OEM_MINUS = 189;
  {$EXTERNALSYM VK_OEM_5}
  VK_OEM_5 = 220;
  {$EXTERNALSYM VK_OEM_6}
  VK_OEM_6 = 221;

type
  TSearchItem = record
    Search: string;
    DiffCase: Boolean;
    FullWord: Boolean;
    CircSearch: Boolean;
    SearchMode: Integer;
    Direction: Boolean;
    Transparence: Boolean;
    Opacite: Integer;
  end;

  TSaveMode = (smSave, smSaveAs);

  TRegionMenu = (rmFile, rmFileNew, rmEdit, rmSearch, rmProject, rmRun,
    rmProjectsPopup, rmPageCtrlPopup, rmEditorPopup);
  TRegionMenuState = set of TRegionMenu;

  //Outline objects images
  TOutlineImages = array[0..MAX_OUTLINE_TREE_IMAGES - 1] of Integer;

  TFrmFalconMain = class(TForm)
    XPManifest: TXPManifest;
    OpenDlg: TOpenDialog;
    SendData: TSendData;
    CompilerCmd: TOutputConsole;
    TimerStartUpdate: TTimer;
    UpdateDownload: TFileDownload;
    SplashScreen: TSplashScreen;
    FrmPos: TFormPosition;
    ImgListOutLine: TImageList;
    DockTop: TTBXDock;
    DefaultBar: TTBXToolbar;
    BtnNew: TTBXSubmenuItem;
    BtnOpen: TTBXItem;
    BtnRemove: TTBXItem;
    BtnSaveAll: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    BtnSave: TTBXItem;
    EditBar: TTBXToolbar;
    BtnUndo: TTBXItem;
    BtnRedo: TTBXItem;
    TBXSwitcher: TTBXSwitcher;
    NavigatorBar: TTBXToolbar;
    BtnPrevPage: TTBXItem;
    BtnNextPage: TTBXItem;
    CompilerBar: TTBXToolbar;
    BtnRun: TTBXItem;
    BtnCompile: TTBXItem;
    BtnStop: TTBXItem;
    TBXSeparatorItem9: TTBXSeparatorItem;
    BtnExecute: TTBXItem;
    ProjectBar: TTBXToolbar;
    BtnNewProj: TTBXItem;
    BtnProperties: TTBXItem;
    PopupProject: TTBXPopupMenu;
    HelpBar: TTBXToolbar;
    BtnContxHelp: TTBXItem;
    BtnHelp: TTBXItem;
    DebugBar: TTBXToolbar;
    PopProjNew: TTBXSubmenuItem;
    TBXSeparatorItem23: TTBXSeparatorItem;
    PopProjOpen: TTBXItem;
    PopProjEdit: TTBXItem;
    TBXSeparatorItem24: TTBXSeparatorItem;
    PopProjDelFromDsk: TTBXItem;
    PopProjRemove: TTBXItem;
    PopProjRename: TTBXItem;
    TBXSeparatorItem25: TTBXSeparatorItem;
    PopProjProp: TTBXItem;
    MenuDock: TTBXDock;
    MenuBar: TTBXToolbar;
    MenuFile: TTBXSubmenuItem;
    FileNew: TTBXSubmenuItem;
    FileNewProject: TTBXItem;
    FileNewC: TTBXItem;
    FileNewCpp: TTBXItem;
    FileNewHeader: TTBXItem;
    FileNewResource: TTBXItem;
    FileNewEmpty: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    FileNewFolder: TTBXItem;
    FileOpen: TTBXItem;
    FileReopen: TTBXSubmenuItem;
    FileReopenClear: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    FileSave: TTBXItem;
    FileSaveAs: TTBXItem;
    FileSaveAll: TTBXItem;
    TBXSeparatorItem22: TTBXSeparatorItem;
    FileImport: TTBXSubmenuItem;
    FileImpDevCpp: TTBXItem;
    FileImpCodeBlocks: TTBXItem;
    FileImpMSVC: TTBXItem;
    FileExport: TTBXSubmenuItem;
    FileExportHTML: TTBXItem;
    FileExportRTF: TTBXItem;
    TBXSeparatorItem15: TTBXSeparatorItem;
    FileClose: TTBXItem;
    FileCloseAll: TTBXItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    FileExit: TTBXItem;
    MenuEdit: TTBXSubmenuItem;
    EditUndo: TTBXItem;
    EditRedo: TTBXItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    EditCut: TTBXItem;
    EditCopy: TTBXItem;
    EditPaste: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    EditSelectAll: TTBXItem;
    MenuSearch: TTBXSubmenuItem;
    SearchFind: TTBXItem;
    SearchFindNext: TTBXItem;
    SearchFindPrev: TTBXItem;
    SearchFindFiles: TTBXItem;
    SearchReplace: TTBXItem;
    SearchIncremental: TTBXItem;
    TBXSeparatorItem16: TTBXSeparatorItem;
    SearchGotoFunction: TTBXItem;
    SearchGotoLine: TTBXItem;
    MenuView: TTBXSubmenuItem;
    ViewProjMan: TTBXItem;
    ViewStatusBar: TTBXItem;
    ViewCompOut: TTBXItem;
    ViewOutline: TTBXItem;
    ViewToolbar: TTBXSubmenuItem;
    ViewToolbarDefault: TTBXItem;
    ViewToolbarEdit: TTBXItem;
    ViewToolbarSearch: TTBXItem;
    ViewToolbarCompiler: TTBXItem;
    ViewToolbarNavigator: TTBXItem;
    ViewToolbarProject: TTBXItem;
    ViewToolbarHelp: TTBXItem;
    ViewThemes: TTBXSubmenuItem;
    ViewThemeDef: TTBXItem;
    ViewThemeOffice2003: TTBXItem;
    ViewThemeOffXP: TTBXItem;
    ViewZoom: TTBXSubmenuItem;
    ViewZoomInc: TTBXItem;
    ViewZoomDec: TTBXItem;
    TBXSeparatorItem21: TTBXSeparatorItem;
    ViewFullScreen: TTBXItem;
    TBXSeparatorItem20: TTBXSeparatorItem;
    ViewRestoreDefault: TTBXItem;
    MenuProject: TTBXSubmenuItem;
    ProjectAdd: TTBXItem;
    ProjectRemove: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    ProjectBuild: TTBXItem;
    TBXSeparatorItem10: TTBXSeparatorItem;
    ProjectProperties: TTBXItem;
    MenuRun: TTBXSubmenuItem;
    RunRun: TTBXItem;
    RunStop: TTBXItem;
    TBXSeparatorItem12: TTBXSeparatorItem;
    RunCompile: TTBXItem;
    RunExecute: TTBXItem;
    MenuTools: TTBXSubmenuItem;
    ToolsEnvOptions: TTBXItem;
    ToolsCompilerOptions: TTBXItem;
    ToolsEditorOptions: TTBXItem;
    TBXSeparatorItem18: TTBXSeparatorItem;
    ToolsTemplate: TTBXItem;
    ToolsPackageCreator: TTBXItem;
    TBXSeparatorItem19: TTBXSeparatorItem;
    ToolsPackages: TTBXItem;
    MenuHelp: TTBXSubmenuItem;
    HelpTipOfDay: TTBXItem;
    TBXSeparatorItem11: TTBXSeparatorItem;
    HelpUpdate: TTBXItem;
    TBXSeparatorItem13: TTBXSeparatorItem;
    HelpAbout: TTBXItem;
    PopupEditor: TTBXPopupMenu;
    PopEditorProperties: TTBXItem;
    PopEditorSelectAll: TTBXItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    PopEditorRedo: TTBXItem;
    PopEditorUndo: TTBXItem;
    TBXSeparatorItem26: TTBXSeparatorItem;
    TBXSeparatorItem27: TTBXSeparatorItem;
    PopEditorDelete: TTBXItem;
    PopEditorPaste: TTBXItem;
    PopEditorCopy: TTBXItem;
    PopEditorCut: TTBXItem;
    PopEditorTools: TTBXSubmenuItem;
    DockBottom: TTBXDock;
    DockLeft: TTBXDock;
    DockRight: TTBXDock;
    ViewToolbarDebug: TTBXItem;
    SearchBar: TTBXToolbar;
    BtnFind: TTBXItem;
    BtnReplace: TTBXItem;
    BtnGotoLN: TTBXItem;
    TBXSeparatorItem29: TTBXSeparatorItem;
    HelpFalcon: TTBXSubmenuItem;
    HelpFalconFalcon: TTBXItem;
    PopupMsg: TTBXPopupMenu;
    PupMsgGotoLine: TTBXItem;
    TBXSeparatorItem31: TTBXSeparatorItem;
    PupMsgOriMsg: TTBXItem;
    TBXSeparatorItem32: TTBXSeparatorItem;
    PupMsgCopyOri: TTBXItem;
    PupMsgCopy: TTBXItem;
    TimerChangeDelay: TTimer;
    ImgListMenus: TTBImageList;
    DisImgListMenus: TTBImageList;
    TBXSeparatorItem33: TTBXSeparatorItem;
    BtnGotoBook: TTBXSubmenuItem;
    BtnToggleBook: TTBXSubmenuItem;
    PopEditorBookmarks: TTBXSubmenuItem;
    PopEditorGotoBookmarks: TTBXSubmenuItem;
    TBXSeparatorItem34: TTBXSeparatorItem;
    TBXSeparatorItem36: TTBXSeparatorItem;
    EditBookmarks: TTBXSubmenuItem;
    TBXItem35: TTBXItem;
    TBXItem36: TTBXItem;
    TBXItem37: TTBXItem;
    TBXItem38: TTBXItem;
    TBXItem44: TTBXItem;
    TBXItem45: TTBXItem;
    TBXItem46: TTBXItem;
    TBXItem47: TTBXItem;
    TBXItem50: TTBXItem;
    EditGotoBookmarks: TTBXSubmenuItem;
    TBXItem58: TTBXItem;
    TBXItem62: TTBXItem;
    TBXItem65: TTBXItem;
    TBXItem66: TTBXItem;
    TBXItem71: TTBXItem;
    TBXItem74: TTBXItem;
    TBXItem75: TTBXItem;
    TBXItem76: TTBXItem;
    TBXItem78: TTBXItem;
    TBXSeparatorItem37: TTBXSeparatorItem;
    EditIndent: TTBXItem;
    TimerHintTipEvent: TTimer;
    ApplicationEvents: TApplicationEvents;
    TimerHintParams: TTimer;
    FilePrint: TTBXItem;
    TBXSeparatorItem38: TTBXSeparatorItem;
    FileRemove: TTBXItem;
    EditUnindent: TTBXItem;
    EditDelete: TTBXItem;
    FileExportTeX: TTBXItem;
    PopEditorSwap: TTBXItem;
    TBXSeparatorItem28: TTBXSeparatorItem;
    PopupTabs: TTBXPopupMenu;
    PopTabsClose: TTBXItem;
    PopTabsCloseAllOthers: TTBXItem;
    PopTabsCloseAll: TTBXItem;
    TBXSeparatorItem35: TTBXSeparatorItem;
    PopTabsSave: TTBXItem;
    PopTabsSaveAll: TTBXItem;
    TBXSeparatorItem39: TTBXSeparatorItem;
    PopTabsSwap: TTBXItem;
    TBXSeparatorItem40: TTBXSeparatorItem;
    PopTabsTabsAtBottom: TTBXItem;
    PopTabsTabsAtTop: TTBXItem;
    TBXSeparatorItem41: TTBXSeparatorItem;
    PopTabsProperties: TTBXItem;
    EditSwap: TTBXItem;
    TBXSeparatorItem42: TTBXSeparatorItem;
    TBXSeparatorItem43: TTBXSeparatorItem;
    EditFormat: TTBXItem;
    PopProjAdd: TTBXItem;
    PopEditorCompClass: TTBXItem;
    PopEditorOpenDecl: TTBXItem;
    TBXSeparatorItem44: TTBXSeparatorItem;
    ImageListGutter: TImageList;
    RunStepReturn: TTBXItem;
    RunStepInto: TTBXItem;
    RunStepOver: TTBXItem;
    RunToggleBreakpoint: TTBXItem;
    RunRuntoCursor: TTBXItem;
    BtnStepInto: TTBXItem;
    BtnStepOver: TTBXItem;
    BtnStepReturn: TTBXItem;
    PupMsgClear: TTBXItem;
    ImgListCountry: TImageList;
    SearchGotoPrevFunc: TTBXItem;
    SearchGotoNextFunc: TTBXItem;
    ImageListDebug: TImageList;
    ViewThemeStripes: TTBXItem;
    ViewThemeProfessional: TTBXItem;
    ViewThemeAluminum: TTBXItem;
    PanelEditorMessages: TPanel;
    StatusBar: TTBXStatusBar;
    ProgressBarParser: TProgressBar;
    ProjectPanel: TSplitterPanel;
    PanelOutline: TSplitterPanel;
    PanelMessages: TSplitterPanel;
    PanelEditor: TXPPanel;
    PageControlProjects: TModernPageControl;
    TSProjects: TModernTabSheet;
    TreeViewProjects: TTreeView;
    PageControlOutline: TModernPageControl;
    TSOutline: TModernTabSheet;
    PageControlEditor: TModernPageControl;
    PageControlMessages: TModernPageControl;
    TSMessages: TModernTabSheet;
    ListViewMsg: TListView;
    TreeViewOutline: TNativeTreeView;
    TBXSeparatorItem14: TTBXSeparatorItem;
    PopTabsCopyDir: TTBXItem;
    PopTabsCopyFullFileName: TTBXItem;
    PopTabsCopyFileName: TTBXItem;
    TBXSeparatorItem17: TTBXSeparatorItem;
    PopTabsReadOnly: TTBXItem;
    EditToggleComment: TTBXItem;
    TBXSeparatorItem30: TTBXSeparatorItem;
    TBXSeparatorItem45: TTBXSeparatorItem;
    EditCollapseAll: TTBXItem;
    EditUncollapseAll: TTBXItem;
    PopupMenuLineEnding: TTBXPopupMenu;
    TBXItem1: TTBXItem;
    TBXItem2: TTBXItem;
    TBXItem3: TTBXItem;
    PopupMenuEncoding: TTBXPopupMenu;
    TBXItem4: TTBXItem;
    TBXItem5: TTBXItem;
    TBXItem6: TTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure ProjectPropertiesClick(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FalconHelpClick(Sender: TObject);
    procedure TreeViewProjectsChange(Sender: TObject; Node: TTreeNode);
    procedure EditFileClick(Sender: TObject);
    procedure FileRemoveClick(Sender: TObject);
    procedure EditUndoClick(Sender: TObject);
    procedure EditRedoClick(Sender: TObject);
    procedure EditCutClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure TreeViewProjectsDblClick(Sender: TObject);
    procedure PageControlEditorClose(Sender: TObject; TabIndex: Integer;
      var AllowClose: Boolean);
    procedure SaveExtensionChange(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure TreeViewProjectsKeyPress(Sender: TObject; var Key: Char);
    procedure PageControlEditorChange(Sender: TObject);
    procedure EditorBeforeCreate(FileProp: TSourceFile);
    procedure FileCloseClick(Sender: TObject);
    procedure RunExecuteClick(Sender: TObject);
    procedure TreeViewProjectsEnter(Sender: TObject);
    procedure PageControlEditorPageChange(Sender: TObject; TabIndex,
      PrevTabIndex: Integer);
    procedure RunRunClick(Sender: TObject);
    procedure LauncherFinished(Sender: TObject);
    procedure RunStopClick(Sender: TObject);
    procedure BtnPreviousPageClick(Sender: TObject);
    procedure BtnNextPageClick(Sender: TObject);
    procedure TreeViewProjectsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TreeViewProjectsClick(Sender: TObject);
    procedure RunCompileClick(Sender: TObject);
    procedure EditSelectAllClick(Sender: TObject);
    procedure ProjectBuildClick(Sender: TObject);
    procedure TreeViewProjectsEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure TreeViewProjectsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopProjRenameClick(Sender: TObject);
    procedure PopProjOpenClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileCloseAllClick(Sender: TObject);
    procedure ToolsClick(Sender: TObject);
    procedure SendDataCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure ReloadTemplates(var message: TMessage); message WM_RELOADFTM;
    procedure ReparseFiles(var message: TMessage); message WM_REPARSEFILES;
    procedure PluginHandler(var message: TMessage); message WM_FALCONCPP_PLUGIN;
    procedure TreeViewProjectsProc(var Msg: TMessage);
    procedure TreeViewOutlineProc(var Msg: TMessage);
    procedure PanelEditorMessagesProc(var Msg: TMessage);
    //procedure PanelEditorProc(var Msg: TMessage);
    procedure GetDropredFiles(Sender: TObject; var Msg: TMessage);
    procedure OnDragDropFiles(Sender: TObject; Files: TStrings);
    procedure CompilerCmdStart(Sender: TObject; const FileName,
      Params: string);
    procedure CompilerCmdFinish(Sender: TObject; const FileName,
      Params: string; ConsoleOut: TStrings; ExitCode: Integer);
    procedure ListViewMsgDblClick(Sender: TObject);
    procedure PopProjDelFromDskClick(Sender: TObject);
    procedure ProjectAddClick(Sender: TObject);
    procedure ProjectRemoveClick(Sender: TObject);
    procedure SubMUpdateClick(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure ListViewMsgDeletion(Sender: TObject; Item: TListItem);
    procedure Originalmessage1Click(Sender: TObject);
    procedure ListViewMsgSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Copyoriginalmessage1Click(Sender: TObject);
    procedure FileSaveAllClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure TextEditorGutterClick(ASender: TObject; AModifiers: Integer;
      APosition: Integer; AMargin: Integer);
    procedure TextEditorSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure TextEditorChange(Sender: TObject);
    procedure TextEditorStatusChange(Sender: TObject; AUpdated: Integer);
    procedure TextEditorEnter(Sender: TObject);
    procedure TextEditorExit(Sender: TObject);
    procedure TextEditorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextEditorLinkClick(Sender: TObject; AModifiers: Integer;
      APosition: Integer);
    procedure TextEditorCharAdded(Sender: TObject; Ch: Integer);
    procedure TextEditorMouseLeave(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure TextEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextEditorKeyPress(Sender: TObject;
      var Key: Char);
    procedure TextEditorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextEditorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TextEditorScroll(Sender: TObject);
    procedure TextEditorClick(Sender: TObject);
    procedure TextLinesDeleted(Sender: TObject; Index: Integer;
      Count: integer);
    procedure TextLinesInserted(Sender: TObject; Index: Integer;
      Count: integer);

    procedure TimerStartUpdateTimer(Sender: TObject);
    procedure UpdateDownloadFinish(Sender: TObject;  State: TDownloadState;
      Canceled: Boolean);
    procedure TreeViewProjectsAddition(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure ViewRestoreDefClick(Sender: TObject);
    procedure ToolsEnvOptionsClick(Sender: TObject);
    procedure ToolsCompilerOptionsClick(Sender: TObject);
    procedure ToolsEditorOptionsClick(Sender: TObject);
    procedure ViewFullScreenClick(Sender: TObject);
    procedure ToolsPackagesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ViewItemClick(Sender: TObject);
    procedure FileNewItemClick(Sender: TObject);
    procedure TViewToolbarClick(Sender: TObject);
    procedure ImportFromDevCpp(Sender: TObject);
    procedure ClearHistoryClick(Sender: TObject);
    procedure ReopenFileClick(Sender: TObject);
    procedure ImportFromCodeBlocks(Sender: TObject);
    procedure ImportFromMSVC(Sender: TObject);
    procedure TimerChangeDelayTimer(Sender: TObject);
    procedure ToolbarClose(Sender: TObject);
    procedure ViewZoomDecClick(Sender: TObject);
    procedure ViewZoomIncClick(Sender: TObject);
    procedure ToggleBookmarksClick(Sender: TObject);
    procedure GotoBookmarkClick(Sender: TObject);
    procedure TreeViewProjectsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewProjectsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SearchFindClick(Sender: TObject);
    procedure SearchReplaceClick(Sender: TObject);
    procedure PageControlEditorContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure EditorContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure SearchFindFilesClick(Sender: TObject);
    procedure SearchFindNextClick(Sender: TObject);
    procedure SearchFindPrevClick(Sender: TObject);
    procedure ParserStart(Sender: TObject);
    procedure ParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: string; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure ParserFinish(Sender: TObject; Canceled: Boolean);

    procedure AllParserStart(Sender: TObject);
    procedure AllParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: string; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure AllParserFinish(Sender: TObject; Canceled: Boolean);

    procedure TokenParserStart(Sender: TObject);
    procedure TokenParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: string; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure TokenParserFinish(Sender: TObject; Canceled: Boolean);
    procedure TokenParserAllFinish(Sender: TObject); //scan current file

    procedure TimerHintTipEventTimer(Sender: TObject);
    procedure CodeCompletionExecute(Kind: TSynCompletionType;
      Sender: TObject; var CurrentInput: string; var x, y: Integer;
      var CanExecute: Boolean);
    procedure CodeCompletionCodeCompletion(Sender: TObject;
      var Value: string; Shift: TShiftState; Index: Integer;
      var EndToken: Char; var OffsetCaret: Integer);
    procedure TimerHintParamsTimer(Sender: TObject);
    procedure ViewCompOutClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure PageControlMsgClose(Sender: TObject;
      TabIndex: Integer; var AllowClose: Boolean);
    procedure PupMsgGotoLineClick(Sender: TObject);
    procedure SendDataReceivedStream(Sender: TObject;
      Value: TMemoryStream);
    procedure PageControlEditorDblClick(Sender: TObject);
    procedure EditDeleteClick(Sender: TObject);
    procedure FileExportHTMLClick(Sender: TObject);
    procedure FileExportRTFClick(Sender: TObject);
    procedure FileExportTeXClick(Sender: TObject);
    procedure PopTabsCloseAllOthersClick(Sender: TObject);
    procedure PopTabsTabsAtTopClick(Sender: TObject);
    procedure PopTabsTabsAtBottomClick(Sender: TObject);
    procedure EditSwapClick(Sender: TObject);
    procedure PageControlEditorTabClick(Sender: TObject);
    procedure PageControlEditorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnHelpClick(Sender: TObject);
    procedure EditFormatClick(Sender: TObject);
    procedure EditIndentClick(Sender: TObject);
    procedure EditUnindentClick(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure PopEditorOpenDeclClick(Sender: TObject);
    procedure RunToggleBreakpointClick(Sender: TObject);
    //*********** debug ************************//
    procedure DebugReaderStart(Sender: TObject);
    procedure DebugReaderCommand(Sender: TObject; Command: TDebugCmd;
      const Name, Value: string; Line: Integer);
    procedure DebugReaderFinish(Sender: TObject; ExitCode: Integer);
    procedure RunStepReturnClick(Sender: TObject);
    procedure RunStepIntoClick(Sender: TObject);
    procedure RunStepOverClick(Sender: TObject);
    procedure SelectThemeClick(Sender: TObject);
    procedure PupMsgClearClick(Sender: TObject);
    procedure RunRuntoCursorClick(Sender: TObject);
    procedure SearchGotoFunctionClick(Sender: TObject);
    procedure SearchGotoLineClick(Sender: TObject);
    procedure SearchGotoPrevFuncClick(Sender: TObject);
    procedure SearchGotoNextFuncClick(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure CodeCompletionAfterCodeCompletion(Sender: TObject;
      const Value: string; Shift: TShiftState; Index: Integer;
      var EndToken: Char);
    procedure PopupProjectPopup(Sender: TObject);
    procedure TreeViewOutlineGetImageIndex(Sender: TBaseNativeTreeView;
      Node: PNativeNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeViewOutlineDrawText(Sender: TBaseNativeTreeView;
      TargetCanvas: TCanvas; Node: PNativeNode; Column: TColumnIndex;
      const Text: string; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure TreeViewOutlineGetText(Sender: TBaseNativeTreeView;
      Node: PNativeNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure TreeViewOutlineFreeNode(Sender: TBaseNativeTreeView;
      Node: PNativeNode);
    procedure TreeViewOutline_DblClick(Sender: TObject);
    procedure CodeCompletionGetWordBreakChars(Sender: TObject;
      var WordBreakChars, ScanBreakChars: String);
    procedure CodeCompletionGetWordEndChars(Sender: TObject;
      var WordEndChars: String; Index: Integer; var Handled: Boolean);
    procedure PopEditorCompClassClick(Sender: TObject);
    procedure PopTabsCopyFullFileNameClick(Sender: TObject);
    procedure PopTabsCopyDirClick(Sender: TObject);
    procedure PopTabsCopyFileNameClick(Sender: TObject);
    procedure PopTabsReadOnlyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RunContinue(Sender: TObject);
    procedure RunRevContinue(Sender: TObject);
    procedure RunRevStepIntoClick(Sender: TObject);
    procedure RunRevStepOverClick(Sender: TObject);
    procedure RunRevStepReturnClick(Sender: TObject);
    procedure SysCommandProc(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure CodeCompletionClose(Sender: TObject);
    procedure EditToggleCommentClick(Sender: TObject);
    procedure EditCollapseAllClick(Sender: TObject);
    procedure EditUncollapseAllClick(Sender: TObject);
    procedure MenuBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewProjectsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure StatusBarContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure EncodingItemClick(Sender: TObject);
    procedure LineEndingItemClick(Sender: TObject);
  private
    { Private declarations }
    fWorkerThread: TThread;
    
    //accept drag drop
    TreeViewProjectsOldProc: TWndMethod;
    PanelEditorMessagesOldProc: TWndMethod;
    TreeViewOutlineOldProc: TWndMethod;

    //config, resources, sintax
    OutlineImages: TOutlineImages;
    FSintaxList: TSintaxList; //highlighter list
    FConfig: TConfig; //window objects positions, zoom, etc.
    FTemplates: TTemplates; //all falcon c++ templates
    FPluginServiceManager: TPluginServiceManager;
    FPluginManager: TPluginManager;

    //paths
    FAppRoot: string; //path of executable
    CompilerActiveMsg: string; //Caption compiler info
    FConfigRoot: string; //directory configuration
    FIniConfigFile: string; //file configuration
    LastOpenFileName: string;

    //flags
    FIsLoading: Boolean;
    ShowingReloadEnquiry: Boolean;
    FRunNow: Boolean; //?
    ActDropDownBtn: Boolean; //?
    XMLOpened: Boolean;
    FCompilationStopped: Boolean;
    CanShowHintTip: Boolean;
    UsingCtrlSpace: Boolean;
    FHandlingTabs: Boolean;
    LastKeyPressed: Char;
    CurrentFileIsParsed: Boolean;
    LastMousePos: TPoint;
    LastWordHintStart: Integer;
    FEmptyLineResult: Integer;
    FEmptyCharResult: Integer;
    ActiveErrorLine: Integer;

    // include list
    FIncludeFileList: TStrings;
    FIncludeFileListFlag: Integer;

    // search history
    FSearchList: TStrings;
    FReplaceList: TStrings;

    //for ThreadTokenFiles
    IsLoadingSrcFiles: Boolean;
    FLastProjectBuild: TProjectFile; //last builded project
    FLastSelectedProject: TProjectFile;
    FLastPathInclude: string;
    FLastProjectIncludePath: string;
    startBuildTicks: Cardinal;
    ReloadAfterCodeCompletion: Boolean;
    fShowCodeCompletion: Integer;
    BuildTime: Cardinal;
    FZoomEditor: Integer; //edit zoom
    ActiveEditingFile: TTokenFile; //last parsed tokens
    FFilesParsed: TTokenFiles; //all files parsed

    //for Project
    ThreadFilesParsed: TThreadTokenFiles;
    AllParsedList: TStrings;
    ProjectIncludeList: TStrings;
    FProjectIncludePathList: TStrings;

    //for Cache
    ParseAllFiles: TTokenFiles; //parse unparsed static files
    ThreadLoadTkFiles: TThreadTokenFiles;
    ThreadTokenFiles: TThreadTokenFiles;
    HintTip: TTokenHintTip; //mouse over hint
    HintParams: TTokenHintParams;
    FAutoComplete: TAutoComplete; //auto complete

    //debug
    DebugReader: TDebugReader;
    WatchList: TDebugWatchList;
    CommandQueue: TCommandQueue;
    DebugActiveLine: Integer;
    DebugActiveFile: TSourceFile;
    DebugHint: THintTree;
    DebugParser: TDebugParser;

    //Completion List Colors
    CompletionColors: TCompletionColors;

    //functions
    procedure AddFilesToProject(Files: TStrings; Parent: TSourceFile;
      References: Boolean; ImportMode: Boolean = False);
    procedure StopAll;
    procedure RunApplication(ProjectFile: TProjectFile);
    procedure ExecuteApplication(ProjectFile: TProjectFile);
    procedure ShowLineError(Project: TProjectFile; Msg: TMessageItem);
    function SaveProject(ProjProp: TProjectFile; SaveMode: TSaveMode): Boolean;
    procedure InvalidateDebugLine;
    procedure AddWatchDebugVariables(scopeToken: TTokenClass;
      SelLine: Integer; var LastID: Integer; var VarAdded: Integer);
    function AddWatchItem(ID: Integer; const Name: string;
      token: TTokenClass; watchType: TWatchType): Boolean;
//    function DeleteWatchItem(const Name: string): Boolean;
    function SearchAndOpenFile(const FileName: string;
      var fp: TSourceFile): Boolean;
    procedure UpdateActiveDebugLine(fp: TSourceFile;
      Line: Integer);
    procedure DeleteDebugVariables;
    procedure UpdateDebugActiveVariables(Line: Integer;
      ShowContent: Boolean = False);
    procedure ToggleBreakpoint(aLine: Integer);
    procedure CheckIfFilesHasChanged;
    function DetectScope(Memo: TEditor;
      TokenFile: TTokenFile; ShowInTreeview: Boolean): TTokenClass;
    procedure UpdateCompletionColors(EdtOpt: TEditorOptions);
    procedure ParseFile(FileName: string; SourceFile: TSourceFile);
    procedure ParseFiles(List: TStrings);
    function GetSelectedFileInList(var ActiveFile: TSourceFile): Boolean;
    function GetActiveProject(var Project: TProjectFile): Boolean;
    function FileInHistory(const FileName: string;
      var HistCount: Integer): Boolean;
    function AddFileToHistory(const FileName: string): Boolean;
    function OpenFileWithHistoric(Value: string;
      var Proj: TProjectFile): Boolean;
    procedure RemoveFileFromHistoric(FileName: string);
    procedure TextEditorFileParsed(EditFile: TSourceFile;
      TokenFile: TTokenFile);
    function ImportDevCppProject(const FileName: string;
      var Proj: TProjectFile): Boolean;
    function ImportCodeBlocksProject(const FileName: string;
      var Proj: TProjectFile): Boolean;
    function ImportMSVCProject(const FileName: string;
      var Proj: TProjectFile): Boolean;
    procedure DropFilesIntoProjectList(List: TStrings; X, Y: Integer);
    
    //outline functions
    procedure UpdateActiveFileToken(NewToken: TTokenFile;
      Reload: Boolean = False);

    //hint functions
    procedure ProcessDebugHint(Input: string; Line, SelStart: integer;
      CursorPos: TPoint);
    procedure SelectToken(Token: TTokenClass);
    procedure ShowHintParams(Memo: TEditor);
    procedure ProcessHintView(FileProp: TSourceFile;
      Memo: TEditor; const X, Y: Integer);
    procedure TextEditorUpdateStatusBar(Sender: TObject);
    procedure ExecutorStart(Sender: TObject);
    function FillTreeView(Parent: PNativeNode; Token: TTokenClass;
      DeleteNext: Boolean = False): PNativeNode;
    procedure PaintTokenItemV2(const ToCanvas: TCanvas; DisplayRect: TRect;
      Token: TTokenClass; Selected, Focused: Boolean; var DefaultDraw: Boolean);
    function FillIncludeList(IncludePathFilesOnly: Boolean): Boolean;
    procedure SwapHeaderSource(FromSrc, ToSrc: TSourceFile);
    function SearchImplementationFile(HeaderFile: TSourceFile;
      var SrcFile: TSourceFile; var SrcFileName: string): Boolean;
    function CreateTODOSourceFile(FileName: string; TokenFile: TTokenFile;
      SourceFile: TSourceFile; var TODOSourceFile: TSourceFile): Boolean;
    function SearchHeaderFile(SourceFile: TSourceFile;
      var HdrFile: TSourceFile; var HdrFileName: string): Boolean;
    procedure UpdateEditorZoom;
    function InternalMessageBox(Text, Caption: string;
      uType: UINT; Handle: HWND = 0): Integer;
    procedure UpdateStatusbar;
    procedure LoadInternetConfiguration;
    procedure DoTypeChangedSource(Source: TSourceBase; OldType: Integer);
  public
    { Public declarations }
    LastSearch: TSearchItem;
    FalconVersion: TVersion; //this file version 
    CppHighligher: TCppHighlighter;
    CodeCompletion: TCompletionProposal;

    procedure SelectFromSelStart(SelStart, SelCount: Integer;
      Memo: TEditor);
    function CreateProject(NodeText: string; FileType: Integer): TProjectFile;
    function CreateSource(ParentNode: TTreeNode;
      NodeText: string): TSourceFile;
    procedure DoDeleteSource(Source: TSourceBase);
    procedure DoRenameSource(Source: TSourceBase; const OldFileName: string);
    function RemoveFile(ParentHandle: HWND; FileProp: TSourceFile;
      FromDisk: Boolean = False): Boolean;
    function ShowPromptOverrideFile(const FileName: string): Boolean;
    procedure UpdateLangNow;
    procedure UpdateMenuItems(Regions: TRegionMenuState);
    function RenameFileInHistory(const FileName,
      NewFileName: string): Boolean;
    procedure ToolbarCheck(const Index: Integer; const Value: Boolean);
    procedure UpdateOpenedSheets;
    procedure ParseProjectFiles(Proj: TProjectFile);
    procedure SetActiveCompilerPath(CompilerPath: string; NewInstalled: Integer);
    procedure SelectTheme(Theme: string);
    function GetActiveFile(var ActiveFile: TSourceFile;
      OnNoneGetFirst: Boolean = True): Boolean;
    procedure AddMessage(const FileName, Title, Msg: string; Line,
      Column, EndColumn: Integer; MsgType: TMessageItemType;
      AlignCenter: Boolean = True);
    function GetSourcesFiles(List: TStrings;
      IncludeRC: Boolean = False): Integer;
    function GetActiveSheet(var sheet: TSourceFileSheet): Boolean;
    procedure GotoLineAndAlignCenter(Memo: TEditor; Line: Integer;
      Col: Integer = 1; EndCol: Integer = 1; CursorEnd: Boolean = False);

    property LastProjectBuild: TProjectFile read FLastProjectBuild write FLastProjectBuild;
    property LastSelectedProject: TProjectFile read FLastSelectedProject write FLastSelectedProject; //last selected project
    property RunNow: Boolean read FRunNow write FRunNow;
    property HandlingTabs: Boolean read FHandlingTabs write FHandlingTabs;
    property ConfigRoot: string read FConfigRoot;
    property IniConfigFile: string read FIniConfigFile;
    property CompilationStopped: Boolean read FCompilationStopped;
    property SintaxList: TSintaxList read FSintaxList;
    property Templates: TTemplates read FTemplates;
    property Config: TConfig read FConfig;
    property IsLoading: Boolean read FIsLoading write FIsLoading;
    property AppRoot: string read FAppRoot;
    property AutoComplete: TAutoComplete read FAutoComplete;
    property SearchList: TStrings read FSearchList;
    property ReplaceList: TStrings read FReplaceList;
    property FilesParsed: TTokenFiles read FFilesParsed;
    property PluginManager: TPluginManager read FPluginManager;
    property ZoomEditor: Integer read FZoomEditor write FZoomEditor;
  end;

  { TParserThread }

  TParserThread = class(TThread)
  private
    fLastPercent: Integer;
    fScanEventHandle: THandle;
    fSourceChanged: Boolean;
    fSource: string;
    fStartTime: Cardinal;
    fParseTime: Cardinal;
    fTokenFile: TTokenFile;
    fHasParsed: Boolean;
    fBusy: Boolean;
    fCppParser: TCppParser;
    fMsg: string;
    fCurrLine: Integer;
    procedure GetSource;
    procedure SetResults;
    procedure ShowProgress;
    procedure AddLogEvent;
    procedure ParserTokenLog(Sender: TObject; Msg: string; Current: Integer);
    procedure ParserProgress(Sender: TObject; Current, Total: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetModified; //actual files has modified
    procedure Shutdown;
    property CppParser: TCppParser read fCppParser write fCppParser;
    property TokenFile: TTokenFile read fTokenFile write fTokenFile;
    property Busy: Boolean read fBusy;
  end;

var
  FrmFalconMain: TFrmFalconMain;

implementation

uses
  UFrmAbout, UFrmNew, UFrmProperty, ExecWait, UTools, UFrmRemove,
  UFrmUpdate, ULanguages, UFrmEnvOptions, UFrmCompOptions, UFrmFind, AStyle,
  UFrmGotoFunction, UFrmGotoLine, TBXThemes, Makefile, CodeTemplate,
  StrUtils, UFrmVisualCppOptions,
  PluginConst, Math, Highlighter, DScintilla;

{$R *.dfm}
{$R resources.res}

var
  g_OrigEditProc: Pointer = nil;

function TreeViewEditSubclassProc(HWindow: HWnd; Message, WParam: Longint;
  LParam: Longint): Longint; stdcall;
begin
  case Message of
    WM_CHAR:
    begin
      if CharInSet(Chr(wParam), ['<', '>', ':', '"', '/', '\', '|', '?', '*']) then
      begin
        Beep;
        Result := 0;
        Exit;
      end;
    end;
  end;
  Result := CallWindowProc(g_OrigEditProc, HWindow, Message, WParam, LParam);
end;

procedure ProgressbarSetMarqueue(Progressbar: TProgressBar);
begin
  Progressbar.Position := 0;
  SetWindowLong(Progressbar.Handle, GWL_STYLE,
    GetWindowLong(Progressbar.Handle, GWL_STYLE) or PBS_MARQUEE);
  SendMessage(Progressbar.Handle, PBM_SETMARQUEE, 1, 0);
end;

procedure ProgressbarSetNormal(Progressbar: TProgressBar);
begin
  SetWindowLong(Progressbar.Handle, GWL_STYLE,
    GetWindowLong(Progressbar.Handle, GWL_STYLE) and not PBS_MARQUEE);
  SendMessage(Progressbar.Handle, PBM_SETMARQUEE, 0, 0);
end;

procedure SetActiveCompiler(OldPath, Actpath: string;
  SplashScreen: TSplashScreen);

  function RemoveFromPath(const path, dir: string): string;
  begin
    Result := path;
    Result := StringReplace(Result, dir, '', [rfIgnoreCase]);
    Result := StringReplace(Result, ';;', ';', [rfReplaceAll]);
    if (Length(Result) > 0) and (Result[Length(Result)] = ';') then
      Delete(Result, Length(Result), 1);
    if (Length(Result) > 0) and (Result[1] = ';') then
      Delete(Result, 1, 1);
  end;

var
  path: string;
  UpdatePath: Boolean;
begin
  Actpath := ExcludeTrailingPathDelimiter(Actpath);
  path := GetEnvironmentVariable('PATH');
  if (CompareText(OldPath, Actpath) = 0) and
    (Pos(UpperCase(Actpath + '\bin'), UpperCase(path)) = 1) then
  begin
    Exit;
  end;
  UpdatePath := False;
  //remove old from path
  if (Oldpath <> '') and
    (Pos(UpperCase(Oldpath + '\bin'), UpperCase(path)) > 0) then
  begin
    path := RemoveFromPath(path, Oldpath + '\bin');
    UpdatePath := True;
  end;
  if Pos(UpperCase(Actpath + '\bin'), UpperCase(path)) <> 1 then
  begin
    path := RemoveFromPath(path, Actpath + '\bin');
    path := Actpath + '\bin;' + path;
    if SplashScreen.Showing then
      SplashScreen.TextOut(55, 300, STR_FRM_MAIN[29]);
    UpdatePath := True;
  end;
  if UpdatePath then
    SetEnvironmentVariable('PATH', PChar(path));
end;

procedure BoldTreeNode(treeNode: TTreeNode; Value: Boolean);
var
  treeItem: TTVItem;
begin
  if not Assigned(treeNode) then
    Exit;
  with treeItem do
  begin
    hItem := treeNode.ItemId;
    stateMask := TVIS_BOLD;
    mask := TVIF_HANDLE or TVIF_STATE;
    if Value then
      state := TVIS_BOLD
    else
      state := 0;
  end;
  TreeView_SetItem(treeNode.Handle, treeItem);
end;

procedure AdjustNewProject(Node: TTreeNode; Proj: TProjectFile);
var
  I: Integer;
begin
  TSourceFile(Node.Data).Project := Proj;
  for I := 0 to Node.Count - 1 do
    AdjustNewProject(Node.Item[I], Proj);
end;

function SortCompareParams(List: TStringList; Index1, Index2: Integer): Integer;
var
  tkp1, tkp2: TTokenClass;
begin
  tkp1 := GetTokenByName(TTokenClass(List.Objects[Index1]), 'Params', tkParams);
  tkp2 := GetTokenByName(TTokenClass(List.Objects[Index2]), 'Params', tkParams);
  Result := tkp1.Count - tkp2.Count;
end;

{TParserThread}

constructor TParserThread.Create;
begin
  inherited Create(TRUE);
  fTokenFile := TTokenFile.Create;
  fCppParser := TCppParser.Create;

  fScanEventHandle := CreateEvent(nil, FALSE, FALSE, nil);
  if (fScanEventHandle = 0) or (fScanEventHandle = INVALID_HANDLE_VALUE) then
    raise EOutOfResources.Create('Couldn''t create WIN32 event object');
end;

destructor TParserThread.Destroy;
begin
  Shutdown;
  fCppParser.Free;
  fTokenFile.Free;
  if (fScanEventHandle <> 0) and (fScanEventHandle <> INVALID_HANDLE_VALUE) then
    CloseHandle(fScanEventHandle);
  inherited Destroy;
end;

procedure TParserThread.ShowProgress;
begin
  if not Assigned(FrmFalconMain) then
    Exit;
  with FrmFalconMain do
  begin
    //StatusBar.Panels.Items[2].Caption := Format('%d %% done', [fLastPercent]);
  end;
end;

procedure TParserThread.AddLogEvent;
begin
  if not Assigned(FrmFalconMain) then
    Exit;
  with FrmFalconMain do
  begin
    AddMessage(fTokenFile.FileName, ExtractFileName(fTokenFile.FileName), fMsg,
      fCurrLine, 0, 0, mitGoto);
    PanelMessages.Show;
  end;
end;

procedure TParserThread.ParserProgress(Sender: TObject; Current,
  Total: Integer);
var
  I: Integer;
begin
  if fSourceChanged then
  begin
    fCppParser.Cancel;
    Exit;
  end;
  if Total = 0 then
    Exit;
  I := Round(Current * 100 / Total);
  if I = fLastPercent then
    Exit;
  fLastPercent := I;
  //Sleep(10);
  Synchronize(ShowProgress);
end;

procedure TParserThread.ParserTokenLog(Sender: TObject; Msg: string;
  Current: Integer);
begin
  fMsg := Msg;
  fCurrLine := Current;
  Synchronize(AddLogEvent);
end;

procedure TParserThread.Execute;
begin
  while not Terminated do
  begin
    fBusy := False;
    WaitForSingleObject(fScanEventHandle, INFINITE);
    fHasParsed := False;
    fBusy := True;
    repeat
      if Terminated then
        Break;
      // make sure the event is reset when we are still in the repeat loop
      ResetEvent(fScanEventHandle);
      // get the modified source and set fSourceChanged to 0
      Synchronize(GetSource);
      if Terminated then
        Break;
      // clear keyword list
      fLastPercent := 0;
      fStartTime := GetTickCount;
      fHasParsed := fCppParser.Parse(fSource, TokenFile);
      if fSourceChanged then
        Break;
    until not fSourceChanged;

    if Terminated then
      Break;
    // source was changed while scanning
    if fSourceChanged then
    begin
      Sleep(100);
      continue;
    end;

    //fKeywords.Sort;
    fParseTime := GetTickCount - fStartTime;
    fBusy := False;
    if fHasParsed then
      Synchronize(SetResults);
    // and go to sleep again
  end;
  fBusy := False;
end;

procedure TParserThread.GetSource;
var
  sheet: TSourceFileSheet;
begin
  if Assigned(FrmFalconMain) then
  begin
    if FrmFalconMain.GetActiveSheet(sheet) then
    begin
      fTokenFile.Data := sheet.SourceFile;
      fSource := sheet.Memo.Lines.Text;
    end
    else
    begin
      fTokenFile.Data := nil;
      fSource := '';
    end;
  end
  else
    fSource := '';
  fSourceChanged := FALSE;
end;

procedure TParserThread.SetModified;
begin
  fCppParser.Cancel;
  fSourceChanged := TRUE;
  if (fScanEventHandle <> 0) and (fScanEventHandle <> INVALID_HANDLE_VALUE) then
    SetEvent(fScanEventHandle);
end;

procedure TParserThread.SetResults;
var
  sheet: TSourceFileSheet;
  FileProp: TSourceFile;
begin
  if not Assigned(FrmFalconMain) then
    Exit;
  with FrmFalconMain do
  begin
    if not GetActiveSheet(sheet) then
    begin
      if not DebugReader.Running then
        TreeViewOutline.Clear;
      Exit;
    end;

    fTokenFile.AssignProperty(ActiveEditingFile);
    UpdateActiveFileToken(fTokenFile, True);
    FileProp := TSourceFile(ActiveEditingFile.Data);
    TextEditorFileParsed(FileProp, ActiveEditingFile);
    if HintParams.Activated then
      ShowHintParams(sheet.Memo);
    if (fShowCodeCompletion > 0) and not CodeCompletion.Executing then
      CodeCompletion.ActivateCompletion(sheet.Memo);
  end;
end;

procedure TParserThread.Shutdown;
begin
  fCppParser.Cancel;
  Terminate;
  if (fScanEventHandle <> 0) and (fScanEventHandle <> INVALID_HANDLE_VALUE) then
    SetEvent(fScanEventHandle);
  WaitFor;
end;

{TFrmFalconMain}

procedure TFrmFalconMain.FormCreate(Sender: TObject);
var
  List: TStrings;
  I: Integer;
  NewInstalled: Integer;
  Template: TTemplate;
  Temp, path: string;
  ini: TIniFile;
  Rs: TResourceStream;
  HistList, AutoCompleteList: TStrings;
  FileProp: TSourceFile;
  Proj: TProjectFile;
begin
  IsLoading := True;
  CppHighligher := TCppHighlighter.Create(Self);
  CodeCompletion := TCompletionProposal.Create(Self);
  CodeCompletion.Options := [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter];
  CodeCompletion.ClSelectedText := clWindowText;
  CodeCompletion.ClTitleBackground := clBtnHighlight;
  CodeCompletion.Width := 450;
  CodeCompletion.EndOfTokenChr := '().:';
  CodeCompletion.TriggerChars := '.>:';
  CodeCompletion.Font.Color := clWindowText;
  CodeCompletion.Font.Height := -12;
  CodeCompletion.Font.Name := 'Segoe UI';
  CodeCompletion.Font.Style := [];
  CodeCompletion.TitleFont.Color := clBtnText;
  CodeCompletion.TitleFont.Height := -11;
  CodeCompletion.TitleFont.Name := 'MS Sans Serif';
  CodeCompletion.TitleFont.Style := [fsBold];
  CodeCompletion.ItemHeight := 19;
  CodeCompletion.Images := ImgListOutLine;
  CodeCompletion.OnClose := CodeCompletionClose;
  CodeCompletion.OnExecute := CodeCompletionExecute;
  CodeCompletion.ShortCut := 0;
  CodeCompletion.TimerInterval := 300;
  CodeCompletion.OnAfterCodeCompletion := CodeCompletionAfterCodeCompletion;
  CodeCompletion.OnCodeCompletion := CodeCompletionCodeCompletion;
  CodeCompletion.OnGetWordBreakChars := CodeCompletionGetWordBreakChars;
  CodeCompletion.OnGetWordEndChars := CodeCompletionGetWordEndChars;
  
  FPluginServiceManager := TPluginServiceManager.Create(Self);
  FPluginManager := TPluginManager.Create(FPluginServiceManager);
  FSearchList := TStringList.Create;
  FIncludeFileList := TStringList.Create;
  FReplaceList := TStringList.Create;
  ProjectIncludeList := TStringList.Create;
  FProjectIncludePathList := TStringList.Create;
  FConfig := TConfig.Create;
  FAppRoot := ExtractFilePath(Application.ExeName);
  FConfigRoot := GetUserFolderPath(CSIDL_APPDATA) + 'Falcon\';
  //create config root directory
  if not DirectoryExists(ConfigRoot) then
    CreateDir(ConfigRoot);
  FIniConfigFile := ConfigRoot + 'Config.ini';
  Config.Load(IniConfigFile, Self);
  if Config.Environment.AlternativeConfFile and
    FileExists(Config.Environment.ConfigurationFile) then
    FIniConfigFile := Config.Environment.ConfigurationFile;
  if Config.Environment.ShowSplashScreen then
    SplashScreen.Show;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[45]);
  fWorkerThread := TParserThread.Create;
  fWorkerThread.Start;
  FFilesParsed := TTokenFiles.Create; // all files
  ParseAllFiles := TTokenFiles.Create; // parse all unparsed files

  // parse all header files from include path
  ThreadTokenFiles := TThreadTokenFiles.Create(ParseAllFiles);
  ThreadTokenFiles.OnStart := ParserStart;
  ThreadTokenFiles.OnProgress := ParserProgress;
  ThreadTokenFiles.OnFinish := ParserFinish;
  ThreadTokenFiles.Start;

  // load included files
  ThreadLoadTkFiles := TThreadTokenFiles.Create(FilesParsed);
  ThreadLoadTkFiles.OnStart := TokenParserStart;
  ThreadLoadTkFiles.OnProgress := TokenParserProgress;
  ThreadLoadTkFiles.OnFinish := TokenParserFinish;
  ThreadLoadTkFiles.OnAllFinish := TokenParserAllFinish;
  ThreadLoadTkFiles.Start;

  // parse all source files from projects
  ThreadFilesParsed := TThreadTokenFiles.Create(FilesParsed);
  ThreadFilesParsed.OnStart := AllParserStart;
  ThreadFilesParsed.OnProgress := AllParserProgress;
  ThreadFilesParsed.OnFinish := AllParserFinish;
  ThreadFilesParsed.Start;

  ActiveEditingFile := TTokenFile.Create;
  AllParsedList := TStringList.Create;

  DebugReader := TDebugReader.Create;
  DebugReader.OnStart := DebugReaderStart;
  DebugReader.OnCommand := DebugReaderCommand;
  DebugReader.OnFinish := DebugReaderFinish;
  CommandQueue := TCommandQueue.Create;
  WatchList := TDebugWatchList.Create;
  HintTip := TTokenHintTip.Create(Self); //mouse over hint
  HintTip.Images := ImgListOutLine;
  HintParams := TTokenHintParams.Create(Self); //Ctrl + Space or ( Trigger Key
  DebugParser := TDebugParser.Create; //fill treeview with debug variables
  DebugParser.TreeView := TreeViewOutline;
  DebugHint := THintTree.Create(Self); //hint with a treeview
  DebugHint.ImageList := ImageListDebug;
  FAutoComplete := TAutoComplete.Create(Self); //Ctrl+J
  //Load default auto complete
  Rs := TResourceStream.Create(HInstance, 'AUTOCOMPLETE', RT_RCDATA);
  Rs.Position := 0;
  AutoComplete.AutoCompleteList.LoadFromStream(Rs);
  Rs.Free;
  // load proxy configuration
  LoadInternetConfiguration;
  SetExplorerTheme(TreeViewProjects.Handle);
  SetExplorerTheme(ListViewMsg.Handle);
  if CheckWin32Version(6, 0) then
    TreeViewProjects.ShowLines := False;
  //outline images
  ConvertTo32BitImageList(ImgListOutLine);
  AddImages(ImgListOutLine, 'OUTLINEIMAGES');
  //menu images
  ConvertTo32BitImageList(ImgListMenus);
  AddImages(ImgListMenus, 'MENUIMAGES');
  ConvertTo32BitImageList(DisImgListMenus);
  AddImages(DisImgListMenus, 'DISMENUIMAGES');
  ConvertTo32BitImageList(ImageListGutter);
  //gutter images
  AddImages(ImageListGutter, 'GUTTERIMAGES');
  //debug images
  ConvertTo32BitImageList(ImageListDebug);
  AddImages(ImageListDebug, 'DEBUGHINTIMAGES');
  //country images
  AddImages(ImgListCountry, 'IMGCOUNTRY');
  //init outline image list
  for I := 0 to MAX_OUTLINE_TREE_IMAGES - 1 do
  begin
    OutlineImages[I] := TreeImages[I];
  end;
  ViewZoomInc.ShortCut := ShortCut(VK_ADD, [ssCtrl]); //Ctrl + +
  ViewZoomDec.ShortCut := ShortCut(VK_SUBTRACT, [ssCtrl]); //Ctrl + -
  BtnPrevPage.ShortCut := ShortCut(VK_TAB, [ssCtrl, ssShift]); //Ctrl + Shift + Tab
  BtnNextPage.ShortCut := ShortCut(VK_TAB, [ssCtrl]); //Ctrl + Tab
  SearchGotoPrevFunc.ShortCut := ShortCut(VK_UP, [ssCtrl, ssAlt]); //Ctrl + Alt + UP
  SearchGotoNextFunc.ShortCut := ShortCut(VK_DOWN, [ssCtrl, ssAlt]); //Ctrl + Alt + DOWN

  FalconVersion := GetFileVersionA(Application.ExeName);
  ActDropDownBtn := True;
  XMLOpened := False;
  FSintaxList := TSintaxList.Create;
  SintaxList.Highlight := CppHighligher;
  //create projects directory
  if not DirectoryExists(Config.Environment.ProjectsDir) then
    CreateDir(Config.Environment.ProjectsDir);
  ZoomEditor := 0;
  FrmPos.FileName := IniConfigFile;
  FrmPos.Load;
  MenuBar.Visible := not FrmPos.FullScreen;
  MenuDock.Top := 0;
  StatusBar.SizeGrip := not FrmPos.FullScreen;
  if FrmPos.FullScreen and not Config.Environment.ShowToolbarsInFullscreen then
    DockTop.Hide;
  if FrmPos.FullScreen then
    ViewFullScreen.Caption := STR_MENU_VIEW[9]
  else
    ViewFullScreen.Caption := STR_MENU_VIEW[9];
  if FileExists(Config.Editor.CodeTemplateFile) then
  begin
    AutoCompleteList := TStringList.Create;
    AutoCompleteList.LoadFromFile(Config.Editor.CodeTemplateFile);
    AutoComplete.AutoCompleteList.AddStrings(AutoCompleteList);
    AutoCompleteList.Free;
  end
  else
  begin
    AutoCompleteList := TStringList.Create;
    AutoCompleteList.Add('[sample | comment here, "|" is mouse cursor position]');
    AutoCompleteList.Append('int v[|];'#13#10);
    try
      AutoCompleteList.SaveToFile(Config.Editor.CodeTemplateFile);
    finally
      AutoCompleteList.Free;
    end;
  end;

  TimerHintParams.Interval := Config.Editor.CodeDelay * 100;
  TimerHintTipEvent.Interval := Config.Editor.CodeDelay * 100;
  CodeCompletion.TimerInterval := Config.Editor.CodeDelay * 100;
  UpdateCompletionColors(Config.Editor);
  if Assigned(Config.Environment.Langs.Current) then
  begin
    Temp := Config.Environment.Langs.Current.Translator;
    if Length(Temp) > 0 then
    begin
      SplashScreen.TextOut(55, 250, Format(STR_FRM_MAIN[24], [temp]), False);
    end;
  end;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[33], False);
  ini := TIniFile.Create(IniConfigFile);
  HistList := TStringList.Create;
  ini.ReadSection('History', HistList);
  for I := HistList.Count - 1 downto 0 do
    AddFileToHistory(ini.ReadString('History', HistList.Strings[I], ''));
  HistList.Free;
  //load search options
  LastSearch.DiffCase := ini.ReadBool('Search', 'DiffCase', False);
  LastSearch.FullWord := ini.ReadBool('Search', 'FullWord', False);
  LastSearch.CircSearch := ini.ReadBool('Search', 'CircSearch', True);
  LastSearch.SearchMode := ini.ReadInteger('Search', 'SearchMode', 0);
  LastSearch.Direction := ini.ReadBool('Search', 'DirectionDown', True);
  LastSearch.Transparence := ini.ReadBool('Search', 'Transparence', True);
  LastSearch.Opacite := ini.ReadInteger('Search', 'Opacite', 100);
  // load search history
  HistList := TStringList.Create;
  ini.ReadSection('SearchHistory', HistList);
  for I := 0 to HistList.Count - 1 do
    FSearchList.Add(ini.ReadString('SearchHistory', HistList.Strings[I], ''));
  HistList.Clear;
  ini.ReadSection('ReplaceHistory', HistList);
  for I := 0 to HistList.Count - 1 do
    FReplaceList.Add(ini.ReadString('ReplaceHistory', HistList.Strings[I], ''));
  HistList.Free;
  //load view menu check
  ViewProjMan.Checked := ini.ReadBool('View', 'ProjMan', True);
  ViewItemClick(ViewProjMan);
  ViewStatusBar.Checked := ini.ReadBool('View', 'StatusBar', True);
  ViewItemClick(ViewStatusBar);
  ViewOutline.Checked := ini.ReadBool('View', 'Outline', True);
  ViewItemClick(ViewOutline);
  NewInstalled := ini.ReadInteger('Packages', 'NewInstalled', -1);
  //load user sintax
  List := TStringList.Create;
  ini.ReadSection('HighlighterList', List);
  for I := 0 to List.Count - 1 do
  begin
    Temp := ini.ReadString('HighlighterList', List.Strings[I], '{}');
    SintaxList.Insert(I, TSintax.Create(List.Strings[I], Temp));
  end;
  List.Free;
  I := SintaxList.IndexOfName(Config.Editor.ActiveSintax);
  if I >= 0 then
    SintaxList.ItemIndex := I;
  SintaxList.Selected.UpdateHighlight(CppHighligher);
  ini.Free;

  TreeViewProjectsOldProc := TreeViewProjects.WindowProc;
  TreeViewProjects.WindowProc := TreeViewProjectsProc;
  if Config.Environment.OneClickOpenFile then
    TreeViewProjects.HotTrack := True;
  DragAcceptFiles(TreeViewProjects.Handle, True);

  TreeViewOutlineOldProc := TreeViewOutline.WindowProc;
  TreeViewOutline.WindowProc := TreeViewOutlineProc;

  PanelEditorMessagesOldProc := PanelEditorMessages.WindowProc;
  PanelEditorMessages.WindowProc := PanelEditorMessagesProc;
  DragAcceptFiles(PanelEditorMessages.Handle, True);

  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[25]);
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Screen.Cursors[crReverseArrow] := GetReverseArrowCursor;
  FTemplates := TTemplates.Create;
  Template := TTemplate.Create;
  Template.Sheet := 'Basic';
  Template.Description := STR_FRM_MAIN[9];
  Template.Caption := STR_FRM_MAIN[9];
  Template.AppType := APPTYPE_CONSOLE;
  Template.CompilerType := USER_DEFINED;
  Templates.Insert(Template);
  List := Config.LoadTemplates(Config.Environment.TemplatesDir);
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[26]);
  //load templates
  for I := 0 to List.Count - 1 do
  begin
    Template := TTemplate.Create;
    if Template.Load(Config.Environment.TemplatesDir + List.Strings[I], HelpFalcon) then
      Templates.Insert(Template)
    else
      Template.Free;
  end;
  List.Free;
  if ParamCount > 0 then
    SplashScreen.TextOut(55, 300, STR_FRM_MAIN[27]);
  //load projects
  for I := 1 to ParamCount do
    OpenFileWithHistoric(ParamStr(I), Proj);
  List := TStringList.Create;
  ini := TIniFile.Create(IniConfigFile);
  ini.ReadSection('LastSection', List);
  for I := 0 to List.Count - 1 do
  begin
    Temp := ini.ReadString('LastSection', List.Strings[i], '');
    if FileExists(Temp) then
    begin
      if not SearchSourceFile(Temp, FileProp) then
        FileProp := TSourceFile(OpenFile(Temp));
      if FileProp.FileType <> FILE_TYPE_PROJECT then
      begin
        FileProp.Edit;
        FileProp.Node.Selected := True;
      end;
    end;
  end;
  ini.Free;
  List.Free;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[28]);
  CreateStdTools;

  //detect compiler
  List := TStringList.Create;
  SearchCompilers(List, Path);
  if (Config.Compiler.Path = '') or
    not FileExists(Config.Compiler.Path + '\bin\gcc.exe') then
  begin
    Path := '';
    Config.Compiler.Version := '';
  end
  else
  begin
    Temp := Path;
    Path := Config.Compiler.Path;
    Config.Compiler.Path := Temp;
  end;
  if not DirectoryExists(Path) and (List.Count = 0) then
  begin
    InternalMessageBox(PChar(STR_FRM_MAIN[46]), 'Falcon C++',
      MB_ICONEXCLAMATION);
  end
  else
  begin
    if not DirectoryExists(Config.Compiler.Path) then
      Path := List.Strings[0];
    SetActiveCompilerPath(Path, NewInstalled);
  end;
  List.Free;
  FPluginManager.LoadFromDir(FAppRoot + 'Plugins\');
  FPluginManager.LoadFromDir(FConfigRoot + 'Plugins\');
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[30]);
  List := TStringList.Create;
  GetSourcesFiles(List);
  ParseFiles(List);
  List.Free;
  SplashScreen.Hide;
  TimerStartUpdate.Enabled := True;
  IsLoading := False;
  //update grayed project and outline
end;

procedure TFrmFalconMain.LoadInternetConfiguration;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FIniConfigFile);
  UpdateDownload.Proxy := ini.ReadBool('Proxy', 'Enabled', False);
  UpdateDownload.Server := ini.ReadString('Proxy', 'IP', 'localhost');
  UpdateDownload.Port := ini.ReadInteger('Proxy', 'Port', 80);
  ini.Free;
end;

//on close application

procedure TFrmFalconMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ProjProp: TProjectFile;
  I, R, J: Integer;
  ini: TIniFile;
  Node: TTreeNode;
  List: TStrings;
begin
  List := TStringList.Create;
  Node := TreeViewProjects.Items.GetFirstNode;
  while Node <> nil do
  begin
    ProjProp := TProjectFile(Node.Data);
    List.AddObject(ProjProp.FileName, ProjProp);
    if (ProjProp.Modified or (not ProjProp.Saved and not ProjProp.IsNew) or
      ProjProp.FilesChanged or ProjProp.SomeFileChanged) then
    begin
      R := InternalMessageBox(PChar(Format(STR_FRM_MAIN[10],
        [ExtractFileName(ProjProp.FileName)])), 'Falcon C++',
        MB_YESNOCANCEL + MB_ICONINFORMATION);
      case R of
        mrYes:
          begin
            if not ProjProp.Saved or ProjProp.IsNew then
            begin
              if not SaveProject(ProjProp, smSave) then
              begin
                Action := caNone;
                List.Free;
                Exit;
              end;
            end
            else if ProjProp.Modified or ProjProp.FilesChanged then
            begin
              ProjProp.SaveAll;
              ProjProp.Save;
            end;
          end; //mrYes
        mrCancel:
          begin
            Action := caNone;
            List.Free;
            Exit;
          end; //mrCancel
      end; //case
    end; //modified or not salved
    if Config.Environment.CreateLayoutFiles and ProjProp.Saved and
      (ProjProp.FileType = FILE_TYPE_PROJECT) then
      ProjProp.SaveLayout;
    Node := Node.getNextSibling;
  end;
  try
    //close when parsing
    if ThreadTokenFiles.Busy then
      ThreadTokenFiles.Cancel;
    if ThreadFilesParsed.Busy then
      ThreadFilesParsed.Cancel;
    if ThreadLoadTkFiles.Busy then
      ThreadLoadTkFiles.Cancel;
    Config.Save(IniConfigFile, Self);
    ini := TIniFile.Create(IniConfigFile);
    ini.EraseSection('History');
    for I := 2 to FileReopen.Count - 1 do
      ini.WriteString('History', 'File' + IntToStr(I - 1),
        TDataMenuItem(FileReopen.Items[I]).HelpFile);
    ini.WriteBool('Search', 'DiffCase', LastSearch.DiffCase);
    ini.WriteBool('Search', 'FullWord', LastSearch.FullWord);
    ini.WriteBool('Search', 'CircSearch', LastSearch.CircSearch);
    ini.WriteInteger('Search', 'SearchMode', LastSearch.SearchMode);
    ini.WriteBool('Search', 'DirectionDown', LastSearch.Direction);
    ini.WriteBool('Search', 'Transparence', LastSearch.Transparence);
    ini.WriteInteger('Search', 'Opacite', LastSearch.Opacite);
    // save search/replace history
    for I := 0 to FSearchList.Count - 1 do
    begin
      if I = 10 then
        Break;
      ini.WriteString('SearchHistory', 'Item' + IntToStr(I + 1), FSearchList.Strings[I]);
    end;
    for I := 0 to FReplaceList.Count - 1 do
    begin
      if I = 10 then
        Break;
      ini.WriteString('ReplaceHistory', 'Item' + IntToStr(I + 1), FReplaceList.Strings[I]);
    end;
    //save view menu check
    ini.WriteBool('View', 'ProjMan', ViewProjMan.Checked);
    ini.WriteBool('View', 'StatusBar', ViewStatusBar.Checked);
    ini.WriteBool('View', 'CompOut', ViewCompOut.Checked);
    ini.WriteBool('View', 'Outline', ViewOutline.Checked);
    //sintax
    ini.EraseSection('HighlighterList');
    for I := 0 to SintaxList.Count - 1 do
    begin
      if SintaxList.Items[I].ReadOnly then
        Continue;
      ini.WriteString('HighlighterList', SintaxList.Items[I].Name,
        SintaxList.Items[I].GetSintaxString);
    end;
    //save section
    J := 0;
    ini.EraseSection('LastSection');
    if Config.Environment.AutoOpen in [0, 1, 3] then
    begin
      for I := 0 to List.Count - 1 do
      begin
        case Config.Environment.AutoOpen of
          0, 3:
            begin
              Inc(J);
              if TProjectFile(List.Objects[I]).FileType = FILE_TYPE_PROJECT then
              begin
                ini.WriteString('LastSection', 'File' + IntToStr(J), List.Strings[I]);
                if Config.Environment.AutoOpen = 3 then
                  Break;
              end;
            end;
          1:
            begin
              Inc(J);
              ini.WriteString('LastSection', 'File' + IntToStr(J), List.Strings[I]);
            end;
        end;
      end;
    end;
    if (Config.Environment.AutoOpen = 2) and FileExists(LastOpenFileName) then
      ini.WriteString('LastSection', 'File1', LastOpenFileName);
    ini.Free;
    FrmPos.Save;
  finally
    List.Free;
  end;
end;

procedure TFrmFalconMain.SetActiveCompilerPath(CompilerPath: string;
  NewInstalled: Integer);
var
  S, OldPath, CompilerName: string;
  SourceFileList: TStrings;
  I: Integer;
  SleepAtEnd: Boolean;
begin
  OldPath := Config.Compiler.Path;
  Config.Compiler.Path := CompilerPath;
  SetActiveCompiler(OldPath, Config.Compiler.Path, SplashScreen);
  if ((Config.Compiler.Version = '') or (NewInstalled <> 0)) then
  begin
    if ExecutorGetStdOut.ExecWait(Config.Compiler.Path + '\bin\gcc.exe',
      '--version', Config.Compiler.Path + '\bin\', S) = 0 then
      GetNameAndVersion(S, CompilerName, Config.Compiler.Version)
    else
      Config.Compiler.Version := '';
  end;
  FilesParsed.PathList.Add(Config.Compiler.Path + '\include\');
  if Config.Compiler.Version <> '' then
  begin
    FilesParsed.PathList.Add(Config.Compiler.Path + '\lib\gcc\mingw32\' +
      Config.Compiler.Version + '\include\c++\');
    FilesParsed.PathList.Add(Config.Compiler.Path + '\lib\gcc\mingw32\' +
      Config.Compiler.Version + '\include\');
  end;
  IsLoadingSrcFiles := False;
  FIncludeFileListFlag := 2;
  SleepAtEnd := False;
  if (NewInstalled <> 0) then
  begin
    if SplashScreen.Showing then
    begin
      if NewInstalled < 0 then
        SplashScreen.TextOut(55, 300, Format(STR_FRM_MAIN[36], [0]))
      else
        SplashScreen.TextOut(55, 300, Format(STR_FRM_MAIN[37], [0]));
    end;
    SourceFileList := TStringList.Create;
    // parse and load C header files
    if FindFiles(Config.Compiler.Path + '\include\', '*.h', SourceFileList) then
    begin
      IsLoadingSrcFiles := True;
      ThreadTokenFiles.Clear;
      ThreadTokenFiles.Start(SourceFileList,
        Config.Compiler.Path + '\include\', ConfigRoot + 'include\', '.prs');
      SleepAtEnd := SplashScreen.Showing;
    end;
    for I := 0 to FIncludeFileList.Count - 1 do
    begin
      if FIncludeFileList.Objects[I] <> nil then
        FIncludeFileList.Objects[I].Free;
    end;
    FIncludeFileList.Clear;
    for I := 0 to SourceFileList.Count - 1 do
    begin
      FIncludeFileList.AddObject(ConvertToUnixSlashes(ExtractRelativePath(
        Config.Compiler.Path + '\include\', SourceFileList.Strings[I])),
        SourceFileList.Objects[I]);
    end;
    SourceFileList.Clear;
    // parse and load C++ header files
    if FindFiles(Config.Compiler.Path + '\lib\gcc\mingw32\' +
      Config.Compiler.Version + '\include\', '*.*', SourceFileList) then
    begin
      IsLoadingSrcFiles := True;
      ThreadTokenFiles.Start(SourceFileList,
        Config.Compiler.Path + '\include\', ConfigRoot + 'include\', '.prs');
      SleepAtEnd := SplashScreen.Showing;
    end;
    for I := 0 to SourceFileList.Count - 1 do
    begin
      S := ConvertToUnixSlashes(ExtractRelativePath(
        Config.Compiler.Path + '\lib\gcc\mingw32\' + Config.Compiler.Version +
        '\include\', SourceFileList.Strings[I]));
      if StartsWith(S, 'c++/') then
          S := Copy(S, 5, Length(S) - 4);
      FIncludeFileList.AddObject(S, SourceFileList.Objects[I]);
    end;
    SourceFileList.Free;
    FIncludeFileListFlag := 0;
  end;
  if SleepAtEnd then
    Sleep(3000);
end;

procedure TFrmFalconMain.UpdateMenuItems(Regions: TRegionMenuState);
var
  SelectedFile: TSourceFile;
  CurrentFile: TSourceFile;
  CurrentProject: TProjectFile;
  CurrentSheet: TSourceFileSheet;
  Flag: Boolean;
begin
  CurrentFile := nil;
  GetActiveFile(CurrentFile, False);
  CurrentProject := nil;
  GetActiveProject(CurrentProject);
  SelectedFile := nil;
  GetSelectedFileInList(SelectedFile);
  CurrentSheet := nil;
  GetActiveSheet(CurrentSheet);
  if rmFile in Regions then
  begin
    //FileOpen.Enabled := True;
    //BtnOpen.Enabled := True;
    Flag := Assigned(CurrentFile) and (not CurrentFile.Saved or CurrentFile.Modified or CurrentFile.IsNew);
    FileSave.Enabled := Flag;
    BtnSave.Enabled := Flag;
    PopTabsSave.Enabled := Flag;
    Flag := (Assigned(CurrentFile) and (CurrentFile is TProjectFile));
    FileSaveAs.Enabled := Flag;
    Flag := TreeViewProjects.Items.Count > 0;
    FileSaveAll.Enabled := Flag;
    BtnSaveAll.Enabled := Flag;
    PopTabsSaveAll.Enabled := Flag;
    Flag := Assigned(CurrentFile) and not (CurrentFile.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]);
    FileExport.Enabled := Flag;
    Flag := PageControlEditor.PageCount > 0;
    FileClose.Enabled := Flag;
    PopTabsClose.Enabled := Flag;
    FileCloseAll.Enabled := Flag;
    PopTabsCloseAll.Enabled := Flag;
    Flag := Assigned(SelectedFile);
    FileRemove.Enabled := Flag;
    BtnRemove.Enabled := Flag;
    PopProjRemove.Enabled := Flag;
    Flag := Assigned(CurrentFile) and not (CurrentFile.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]);
    FilePrint.Enabled := Flag;
  end;
  if rmFileNew in Regions then
  begin
    Flag := True;
    FileNewC.Enabled := Flag;
    FileNewCpp.Enabled := Flag;
    FileNewHeader.Enabled := Flag;
    FileNewResource.Enabled := Flag;
    FileNewEmpty.Enabled := Flag;
    FileNewFolder.Enabled := Flag and Assigned(SelectedFile) and
      ((SelectedFile.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]) or
      (Assigned(SelectedFile.Node.Parent) and
      (TSourceFile(SelectedFile.Node.Parent.Data).FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT])));
  end;
  if rmEdit in Regions then
  begin
    Flag := Assigned(CurrentSheet) and CurrentSheet.Memo.CanUndo and CurrentSheet.Memo.Focused;
    EditUndo.Enabled := Flag;
    PopEditorUndo.Enabled := Flag;
    BtnUndo.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Memo.CanRedo and CurrentSheet.Memo.Focused;
    EditRedo.Enabled := Flag;
    PopEditorRedo.Enabled := Flag;
    BtnRedo.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Memo.SelAvail and CurrentSheet.Memo.Focused;
    EditCut.Enabled := Flag;
    PopEditorCut.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Memo.SelAvail and CurrentSheet.Memo.Focused;
    EditCopy.Enabled := Flag;
    PopEditorCopy.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Memo.CanPaste and CurrentSheet.Memo.Focused;
    EditPaste.Enabled := Flag;
    PopEditorPaste.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    EditSwap.Enabled := Flag;
    PopEditorSwap.Enabled := Flag;
    PopTabsSwap.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.SelAvail or
      ((CurrentSheet.Memo.CaretY <= CurrentSheet.Memo.Lines.Count) and
      ((CurrentSheet.Memo.CaretY < CurrentSheet.Memo.Lines.Count) or
      (CurrentSheet.Memo.CaretX < Length(CurrentSheet.Memo.Lines[CurrentSheet.Memo.CaretY - 1])))
      )) and CurrentSheet.Memo.Focused;
    EditDelete.Enabled := Flag;
    PopEditorDelete.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (not ((CurrentSheet.Memo.SelAvail and
      ((CurrentSheet.Memo.BlockBegin.Char = 1) and (CurrentSheet.Memo.BlockBegin.Line = 1)) and
      (CurrentSheet.Memo.Lines.Count > 0) and
      ((CurrentSheet.Memo.BlockEnd.Char = Length(
        CurrentSheet.Memo.Lines[CurrentSheet.Memo.Lines.Count - 1]) + 1) and
        (CurrentSheet.Memo.BlockEnd.Line = CurrentSheet.Memo.Lines.Count))) or
        (CurrentSheet.Memo.Lines.Count = 0) or
        ((CurrentSheet.Memo.Lines.Count = 1) and
        (Length(CurrentSheet.Memo.Lines[0]) = 0))
        )) and CurrentSheet.Memo.Focused;
    EditSelectAll.Enabled := Flag;
    PopEditorSelectAll.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.Lines.Count > 0);
    EditBookmarks.Enabled := Flag;
    PopEditorBookmarks.Enabled := Flag;
    BtnToggleBook.Enabled := Flag;
    EditGotoBookmarks.Enabled := Flag;
    PopEditorGotoBookmarks.Enabled := Flag;
    BtnGotoBook.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Memo.SelAvail and CurrentSheet.Memo.Focused;
    EditIndent.Enabled := Flag;
    EditUnindent.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and  (CurrentSheet.Memo.Lines.Count > 0)
      and CurrentSheet.Memo.Focused;
    EditToggleComment.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and AStyleLoaded;
    EditFormat.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    EditCollapseAll.Enabled := Flag;
    EditUncollapseAll.Enabled := Flag;
  end;
  if rmSearch in Regions then
  begin
    Flag := Assigned(CurrentSheet);
    SearchFind.Enabled := Flag;
    BtnFind.Enabled := Flag;
    SearchFindNext.Enabled := Flag;
    SearchFindPrev.Enabled := Flag;
    Flag := (TreeViewProjects.Items.Count > 0);
    SearchFindFiles.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    SearchReplace.Enabled := Flag;
    BtnReplace.Enabled := Flag;
    Flag := (TreeViewProjects.Items.Count > 0);
    SearchGotoFunction.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    SearchGotoPrevFunc.Enabled := Flag;
    SearchGotoNextFunc.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.Lines.Count > 10);
    SearchGotoLine.Enabled := Flag;
    BtnGotoLN.Enabled := Flag;
  end;
  if rmProject in Regions then
  begin
    Flag := Assigned(CurrentProject) and (CurrentProject.FileType = FILE_TYPE_PROJECT);
    ProjectAdd.Enabled := Flag;
    PopProjAdd.Enabled := Flag;
    Flag := Assigned(CurrentProject) and (CurrentProject.FileType = FILE_TYPE_PROJECT)
      and (CurrentProject.Node.Count > 0);
    ProjectRemove.Enabled := Flag;
    Flag := Assigned(CurrentProject) and not DebugReader.Running and
      not CompilerCmd.Executing and not Executor.Running;
    ProjectBuild.Enabled := Flag;
    Flag := Assigned(CurrentProject);
    ProjectProperties.Enabled := Flag;
    PopEditorProperties.Enabled := Flag;
    BtnProperties.Enabled := Flag;
    Flag := Assigned(SelectedFile);
    PopProjProp.Enabled := Flag;
  end;
  if rmRun in Regions then
  begin
    Flag := Assigned(CurrentProject) and ((not CompilerCmd.Executing and
      not Executor.Running) or DebugReader.Running);
    RunRun.Enabled := Flag;
    BtnRun.Enabled := Flag;
    Flag := Assigned(CurrentProject) and not DebugReader.Running and
      not CompilerCmd.Executing and not Executor.Running;
    RunCompile.Enabled := Flag;
    BtnCompile.Enabled := Flag;
    Flag := Assigned(CurrentProject) and CurrentProject.Compiled and
      FileExists(CurrentProject.GetTarget) and not DebugReader.Running and
      not CompilerCmd.Executing and
      (not Executor.Running or (Assigned(LastProjectBuild) and
      (LastProjectBuild <> CurrentProject)));
    RunExecute.Enabled := Flag;
    BtnExecute.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.Lines.Count > 0);
    RunToggleBreakpoint.Enabled := Flag;
    Flag := Assigned(CurrentProject) and DebugReader.Running;
    RunStepInto.Enabled := Flag;
    BtnStepInto.Enabled := Flag;
    RunStepOver.Enabled := Flag;
    BtnStepOver.Enabled := Flag;
    RunStepReturn.Enabled := Flag;
    BtnStepReturn.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.Lines.Count > 0);
    RunRuntoCursor.Enabled := Flag;
    Flag := Assigned(CurrentProject) and (Executor.Running or DebugReader.Running
      or CompilerCmd.Executing);
    RunStop.Enabled := Flag;
    BtnStop.Enabled := Flag;
  end;
  if rmProjectsPopup in Regions then
  begin
    Flag := Assigned(SelectedFile) and not (SelectedFile.FileType in [FILE_TYPE_PROJECT,
      FILE_TYPE_FOLDER]);
    PopProjEdit.Enabled := Flag;
    Flag := Assigned(SelectedFile) and SelectedFile.Saved;
    PopProjOpen.Enabled := Flag;
    Flag := Assigned(SelectedFile);
    PopProjRename.Enabled := Flag;
    Flag := Assigned(SelectedFile) and SelectedFile.Saved;
    PopProjDelFromDsk.Enabled := Flag;
  end;
  if rmPageCtrlPopup in Regions then
  begin
    Flag := (PageControlEditor.PageCount > 1);
    PopTabsCloseAllOthers.Enabled := Flag;
    Flag := (PageControlEditor.TabPosition <> mtpTop);
    PopTabsTabsAtTop.Enabled := Flag;
    Flag := (PageControlEditor.TabPosition <> mtpBottom);
    PopTabsTabsAtBottom.Enabled := Flag;
    PopTabsReadOnly.Checked := Assigned(CurrentSheet) and
      CurrentSheet.SourceFile.ReadOnly;
    // others
    Flag := (PageControlEditor.PageCount > 1);
    BtnPrevPage.Enabled := Flag;
    BtnNextPage.Enabled := Flag;
  end;
  if rmEditorPopup in Regions then
  begin
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.Lines.Count > 0);
    PopEditorOpenDecl.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Memo.Lines.Count > 0);
    PopEditorCompClass.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    PopEditorTools.Enabled := Flag;
  end;
end;

procedure TFrmFalconMain.ReloadTemplates(var message: TMessage);
var
  Template: TTemplate;
  aTemplates: TTemplates;
  List: TStrings;
  I: Integer;
begin
  List := Config.LoadTemplates(Config.Environment.TemplatesDir);
  //clear help menus
  for I := HelpFalcon.Count - 1 downto 1 do
    HelpFalcon.Delete(I);
  aTemplates := TTemplates.Create;
  Template := TTemplate.Create;
  Template.Sheet := 'Basic';
  Template.Description := STR_FRM_MAIN[9];
  Template.Caption := STR_FRM_MAIN[9];
  Template.AppType := APPTYPE_CONSOLE;
  Template.CompilerType := COMPILER_CPP;
  if not Config.Environment.DefaultCppNewFile then
    Template.CompilerType := COMPILER_C;
  aTemplates.Insert(Template);
  //load templates
  for I := 0 to List.Count - 1 do
  begin
    Template := TTemplate.Create;
    if Template.Load(Config.Environment.TemplatesDir + List.Strings[I], HelpFalcon) then
      aTemplates.Insert(Template)
    else
      Template.Free;
  end;
  List.Free;
  if Assigned(FrmNewProj) then
    FrmNewProj.ReloadTemplates(aTemplates);
  Templates.Free;
  FTemplates := aTemplates;
end;

procedure TFrmFalconMain.ReparseFiles(var message: TMessage);
var
  SourceFileList: TStringList;
begin
  SourceFileList := TStringList.Create;
  if FindFiles(Config.Compiler.Path + '\include\', '*.h', SourceFileList) then
  begin
    IsLoadingSrcFiles := True;
    ThreadTokenFiles.Start(SourceFileList,
      Config.Compiler.Path + '\include\', ConfigRoot + 'include\', '.prs');
  end;
  SourceFileList.Clear;
  if FindFiles(Config.Compiler.Path + '\lib\gcc\mingw32\' +
    Config.Compiler.Version + '\include\', '*.*', SourceFileList) then
  begin
    IsLoadingSrcFiles := True;
    ThreadTokenFiles.Start(SourceFileList,
      Config.Compiler.Path + '\include\', ConfigRoot + 'include\', '.prs');
  end;
  SourceFileList.Free;
end;

function TFrmFalconMain.FillTreeView(Parent: PNativeNode;
  Token: TTokenClass; DeleteNext: Boolean): PNativeNode;
var
  I: Integer;
  S: string;
  NodeObject: TNodeObject;
  Node: PNativeNode;
begin
  Result := nil;
  for I := 0 to Token.Count - 1 do
  begin
    Node := Parent;
    if not (Token.Items[I].Token in [tkParams, tkScope, tkScopeClass, tkUsing]) then
    begin
      if Token.Items[I].Token in [tkFunction, tkProtoType, tkConstructor,
        tkDestructor, tkOperator] then
      begin
        if Token.Items[I].Token in [tkConstructor, tkDestructor] then
        begin
          S := GetFuncScope(Token.Items[I]) +
            Token.Items[I].Name + GetFuncProtoTypes(Token.Items[I]);
        end
        else
        begin
          S := Token.Items[I].Name +
            GetFuncProtoTypes(Token.Items[I]) + ' : ' + Token.Items[I].Flag;
          if Token.Items[I].Token = tkOperator then
            S := 'operator' + S;
        end;
      end
      else
        S := Token.Items[I].Name;
      NodeObject := TNodeObject.Create;
      NodeObject.Data := Token.Items[I];
      NodeObject.Caption := S;
      Node := TreeViewOutline.AddChild(Parent, NodeObject);
      Token.Items[I].Data := Node;
      NodeObject.ImageIndex := GetTokenImageIndex(Token.Items[I], OutlineImages);
    end;

    if not (Token.Items[I].Token in [tkParams, tkScope, tkFunction,
      tkConstructor, tkDestructor, tkPrototype, tkOperator]) then
    begin
      FillTreeView(Node, Token.Items[I], True);
    end;
  end;
end;

procedure TFrmFalconMain.UpdateCompletionColors(EdtOpt: TEditorOptions);
begin
  CompletionColors[tkClass] := Format(CompletionNames[0], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkFunction] := Format(CompletionNames[1], [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[tkPrototype] := Format(CompletionNames[2], [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[tkOperator] := Format(CompletionNames[2], [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[tkConstructor] := Format(CompletionNames[3], [ColorToString(EdtOpt.CompListConstructor)]);
  CompletionColors[tkDestructor] := Format(CompletionNames[4], [ColorToString(EdtOpt.CompListDestructor)]);
  CompletionColors[tkInclude] := Format(CompletionNames[5],  [ColorToString(EdtOpt.CompListPreproc{CompListInclude})]);
  CompletionColors[tkDefine] := Format(CompletionNames[6], [ColorToString(EdtOpt.CompListPreproc)]);
  CompletionColors[tkVariable] := Format(CompletionNames[7], [ColorToString(EdtOpt.CompListVar)]);
  CompletionColors[tkTypedef] := Format(CompletionNames[8], [ColorToString(EdtOpt.CompListTypedef)]);
  CompletionColors[tkTypedefProto] := Format(CompletionNames[9], [ColorToString(EdtOpt.CompListTypedef)]);
  CompletionColors[tkStruct] := Format(CompletionNames[10], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkTypeStruct] := Format(CompletionNames[11], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkEnum] := Format(CompletionNames[12], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkTypeEnum] := Format(CompletionNames[13], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkUnion] := Format(CompletionNames[14], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkTypeUnion] := Format(CompletionNames[15], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkNamespace] := Format(CompletionNames[16], [ColorToString(EdtOpt.CompListNamespace)]);
  CompletionColors[tkEnumItem] := Format(CompletionNames[17], [ColorToString(EdtOpt.CompListConstant)]);
  CompletionColors[tkCodeTemplate] := Format(CompletionNames[18], [ColorToString(EdtOpt.CompListType)]);
end;

//get source file to parse
procedure TFrmFalconMain.ParseFile(FileName: string; SourceFile: TSourceFile);
var
  ObjList: TStrings;
  FileObj: TFileObject;
  sheet: TSourceFileSheet;
begin
  ObjList := TStringList.Create;
  FileObj := TFileObject.Create;
  FileObj.ID := SourceFile;
  if (FileName = '-') and (SourceFile <> nil) and SourceFile.GetSheet(sheet) then
  begin
    FileObj.FileName := SourceFile.FileName;
    FileObj.Text := sheet.Memo.Lines.Text;
  end
  else
    FileObj.FileName := FileName;
  ObjList.AddObject(FileName, FileObj);
  ThreadFilesParsed.ParseLoad(ObjList);
  ObjList.Free;
end;

procedure TFrmFalconMain.ParseFiles(List: TStrings);
var
  I: Integer;
  prop: TSourceFile;
  ObjList: TStrings;
  FileObj: TFileObject;
  sheet: TSourceFileSheet;
begin
  if List.Count = 0 then
    Exit;
  ObjList := TStringList.Create;
  //parse source files
  for I := 0 to List.Count - 1 do
  begin
    prop := TSourceFile(List.Objects[I]);
    if (prop <> nil) and (prop.FileType = FILE_TYPE_RC) then
      Continue;
    FileObj := TFileObject.Create;
    FileObj.ID := Prop;
    if (prop <> nil) and prop.GetSheet(sheet) then
    begin
      FileObj.FileName := prop.FileName;
      FileObj.Text := sheet.Memo.Lines.Text;
      ObjList.AddObject('-', FileObj);
    end
    else if (prop = nil) or (prop.Saved) then
    begin
      FileObj.FileName := List.Strings[I];
      ObjList.AddObject(FileObj.FileName, FileObj);
    end
    else
      FileObj.Free;
  end;
  if ObjList.Count = 0 then
  begin
    ObjList.Free;
    Exit;
  end;
  ThreadFilesParsed.ParseLoad(ObjList);
  ObjList.Free;
end;

//get source file to parse

procedure TFrmFalconMain.ParseProjectFiles(Proj: TProjectFile);
var
  List: TStrings;
begin
  //parse project source files
  List := TStringList.Create;
  Proj.GetFiles(List);
  ParseFiles(List);
  List.Free;
end;

procedure TFrmFalconMain.BtnHelpClick(Sender: TObject);
var
  form: TForm;
  memo: TMemo;
  I: Integer;
  List: TStrings;
begin
  form := TForm.Create(self);
  form.Width := 400;
  form.Height := 450;
  memo := TMemo.Create(form);
  memo.Parent := form;
  memo.Align := alClient;
  memo.ScrollBars := ssBoth;
  List := TStringList.Create;
  FilesParsed.GetAllFiles(List);
  for I := 0 to List.Count - 1 do
  begin
    memo.Lines.Add(TTokenFile(List.Objects[I]).FileName);
  end;
  List.Free;
  form.Position := poOwnerFormCenter;
  form.Caption := IntToStr(FilesParsed.Count) + ' Files';
  form.ShowModal;
end;

//get source file to parse

function TFrmFalconMain.GetSourcesFiles(List: TStrings;
  IncludeRC: Boolean): Integer;
var
  I: Integer;
  prop: TSourceFile;
begin
  Result := 0;
  for I := 0 to TreeViewProjects.Items.Count - 1 do
  begin
    prop := TSourceFile(TreeViewProjects.Items.Item[I].Data);
    if not (prop.FileType in [FILE_TYPE_PROJECT, FILE_TYPE_FOLDER,
      FILE_TYPE_RC]) then
    begin
      Inc(Result);
      List.AddObject(prop.FileName, prop);
    end;
  end;
//
end;

//update user configuration editor

procedure TFrmFalconMain.UpdateOpenedSheets;
var
  I: Integer;
  SynMemo: TEditor;
begin
  UpdateCompletionColors(Config.Editor);
  TimerHintParams.Interval := Config.Editor.CodeDelay * 100;
  TimerHintTipEvent.Interval := Config.Editor.CodeDelay * 100;
  CodeCompletion.TimerInterval := Config.Editor.CodeDelay * 100;

  for I := 0 to PageControlEditor.PageCount - 1 do
  begin
    SynMemo := TSourceFileSheet(PageControlEditor.Pages[I]).Memo;
    TSourceFileSheet.UpdateEditor(SynMemo);
  end;
end;

//update editor zoom

procedure TFrmFalconMain.UpdateEditorZoom;
var
  I: Integer;
  SynMemo: TEditor;
begin
  for I := 0 to PageControlEditor.PageCount - 1 do
  begin
    if SHEET_TYPE_FILE = TPropertySheet(PageControlEditor.Pages[I]).SheetType then
    begin
      SynMemo := TSourceFileSheet(PageControlEditor.Pages[I]).Memo;
      SynMemo.Zoom := ZoomEditor;
    end;
  end;
end;

//get selected file in project list

function TFrmFalconMain.GetSelectedFileInList(var ActiveFile: TSourceFile): Boolean;
begin
  Result := False;
  if (TreeViewProjects.SelectionCount = 0) then
    Exit;
  ActiveFile := TSourceFile(TreeViewProjects.Selected.Data);
  Result := True;
end;

// get active file in treeview or active sheet

function TFrmFalconMain.GetActiveFile(var ActiveFile: TSourceFile;
  OnNoneGetFirst: Boolean): Boolean;
var
  Sheet: TSourceFileSheet;
  Node: TTreeNode;
begin
  Result := False;
  if (TreeViewProjects.SelectionCount > 0) and (TreeViewProjects.Selected <> nil) then
  begin
    if TreeViewProjects.Focused or ((PageControlEditor.ActivePageIndex >= 0) and
      not TSourceFileSheet(PageControlEditor.ActivePage).Memo.Focused) then
      ActiveFile := TSourceFile(TreeViewProjects.Selected.Data)
    else
    begin
      if (PageControlEditor.ActivePageIndex >= 0) then
      begin
        Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
        ActiveFile := Sheet.SourceFile;
      end
      else
        ActiveFile := TSourceFile(TreeViewProjects.Selected.Data);
    end;
    Result := True;
  end
  else if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    ActiveFile := Sheet.SourceFile;
    Result := True;
  end
  else if OnNoneGetFirst then
  begin
    Node := TreeViewProjects.Items.GetFirstNode;
    if Node = nil then
      Exit;
    if Node.getNextSibling <> nil then
      Exit;
    ActiveFile := TSourceFile(Node.Data);
    Result := True;
  end;
end;

//get active project

function TFrmFalconMain.GetActiveProject(var Project: TProjectFile): Boolean;
var
  ActFile: TSourceFile;
begin
  Result := False;
  if not GetActiveFile(ActFile) then
    Exit;
  if (TObject(ActFile) is TProjectFile) then
    Project := TProjectFile(ActFile)
  else
    Project := ActFile.Project;
  Result := True;
end;

//get active sheet

function TFrmFalconMain.GetActiveSheet(var sheet: TSourceFileSheet): Boolean;
begin
  Result := False;
  if PageControlEditor.ActivePageIndex < 0 then
    Exit;
  sheet := TSourceFileSheet(PageControlEditor.ActivePage);
  Result := True;
end;

//show about window

procedure TFrmFalconMain.About1Click(Sender: TObject);
begin
  if not Assigned(FormAbout) then
  begin
    FormAbout := TFormAbout.Create(Self);
    FormAbout.LoadTranslators(Config.Environment.Langs);
  end;
  FormAbout.Show;
end;

//show properties window of project

procedure TFrmFalconMain.ProjectPropertiesClick(Sender: TObject);
var
  ProjProp: TProjectFile;
begin
  if not GetActiveProject(ProjProp) then
    Exit;
  if not Assigned(FrmProperty) then
    FrmProperty := TFrmProperty.CreateParented(Handle);
  try
    FrmProperty.SetProject(ProjProp);
    FrmProperty.ShowModal;
  finally
    FrmProperty.Free;
    FrmProperty := nil;
  end;
end;

//open files

procedure TFrmFalconMain.FileOpenClick(Sender: TObject);
begin
  PageControlEditor.CancelDragging;
  if OpenDlg.Execute then
  begin
    IsLoading := True;
    LastOpenFileName := OpenDlg.Files.Strings[OpenDlg.Files.Count - 1];
    OnDragDropFiles(Sender, OpenDlg.Files);
    IsLoading := False;
    //parser files
  end;
end;

//on click menu help execute filehelp

procedure TFrmFalconMain.FalconHelpClick(Sender: TObject);
var
  FileName: string;
begin
  if Sender is TDataMenuItem then
  begin
    FileName := TDataMenuItem(Sender).HelpFile;
    if Pos('http://', FileName) = 0 then
      FileName := Config.Environment.UsersDefDir + FileName;
    ShellExecute(Handle, 'open', PChar(FileName), '',
      PChar(ExtractFilePath(FileName)), SW_SHOW);
  end;
end;

//on change file selection

procedure TFrmFalconMain.TreeViewProjectsChange(Sender: TObject; Node: TTreeNode);
var
  FilePrp: TSourceFile;
  Sibling: TTreeNode;
begin
  UpdateMenuItems([rmFile, rmFileNew, rmSearch, rmProject, rmRun, rmProjectsPopup]);
  if (TreeViewProjects.Items.Count = 0) then
  begin
    UpdateStatusbar;
    StatusBar.Panels.Items[1].Caption := '';
    StatusBar.Panels.Items[2].ImageIndex := -1;
    StatusBar.Panels.Items[2].Caption := '';
    if ThreadFilesParsed.Busy then
      ThreadFilesParsed.Cancel;
    if ThreadLoadTkFiles.Busy then
      ThreadLoadTkFiles.Cancel;
    FilesParsed.Clear;
  end;
  Sibling := TreeViewProjects.Items.GetFirstNode;
  while Sibling <> nil do
  begin
    BoldTreeNode(Sibling, False);
    Sibling := Sibling.getNextSibling;
  end;
  FilePrp := nil;
  if Node <> nil then
    FilePrp := TSourceFile(Node.Data);
  if (FilePrp <> nil) or GetActiveFile(FilePrp) then
    BoldTreeNode(FilePrp.Project.Node, True);
  UpdateStatusbar;
  if FilePrp = nil then
    Exit;
  if FilePrp.Editing then
    FilePrp.ViewPage;
end;

//edit selected file in list of projects

procedure TFrmFalconMain.EditFileClick(Sender: TObject);
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if TSourceFile(TreeViewProjects.Selected.Data).FileType <>
      FILE_TYPE_FOLDER then
      TSourceFile(TreeViewProjects.Selected.Data).Edit;
  end;
end;

//delete selected text in editor or next char

procedure TFrmFalconMain.FileRemoveClick(Sender: TObject);
var
  ControlHand: HWnd;
  Node: TTreeNode;
begin
  if TreeViewProjects.SelectionCount = 0 then
    Exit;
  if not TreeViewProjects.IsEditing then
  begin
    Node := TreeViewProjects.Selected;
    RemoveFile(Handle, TSourceFile(Node.Data));
  end
  else
  begin
    ControlHand := TreeView_GetEditControl(TreeViewProjects.Handle);
    if (ControlHand <> 0) and IsWindowVisible(ControlHand) then
    begin
      SendMessage(ControlHand, WM_KEYDOWN, VK_DELETE, VK_DELETE);
      SendMessage(ControlHand, WM_KEYUP, VK_DELETE, VK_DELETE);
    end;
  end;
end;

//undo change of editor

procedure TFrmFalconMain.EditUndoClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
    begin
      Sheet.Memo.Undo;
      Sheet.Caption := Sheet.SourceFile.Caption;
    end;
  end;
end;

//redo change of code editor

procedure TFrmFalconMain.EditRedoClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
    begin
      Sheet.Memo.Redo;
      Sheet.Caption := Sheet.SourceFile.Caption;
    end;
  end;
end;

//cut selected text of editor

procedure TFrmFalconMain.EditCutClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.CutToClipboard;
  end;
end;

//copy selected text of code editor

procedure TFrmFalconMain.EditCopyClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.CopyToClipboard;
  end;
end;

//paste copied text on editor

procedure TFrmFalconMain.EditPasteClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.PasteFromClipboard;
    Sheet.Memo.Invalidate;
  end;
end;

//double click in an file of list

procedure TFrmFalconMain.TreeViewProjectsDblClick(Sender: TObject);
var
  Node: TTreeNode;
  MPos: TPoint;
begin
  GetCursorPos(MPos);
  MPos := TreeViewProjects.ScreenToClient(MPos);
  Node := TreeViewProjects.GetNodeAt(MPos.X, MPos.Y);
  if Assigned(Node) then
  begin
    if PtInRect(node.DisplayRect(False), MPos) then
    begin
      Node.Selected := True;
      Node.Focused := True;
      Node.EndEdit(True);
      if (TSourceFile(Node.Data).FileType = FILE_TYPE_PROJECT) then
        ProjectPropertiesClick(Sender)
      else if (TSourceFile(Node.Data).FileType = FILE_TYPE_FOLDER) then
        TSourceFile(Node.Data).Open
      else
        TSourceFile(Node.Data).Edit;
    end;
  end;
end;

//on close tab editor

procedure TFrmFalconMain.PageControlEditorClose(Sender: TObject;
  TabIndex: Integer; var AllowClose: Boolean);
var
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
  I: Integer;
  clAction: Boolean;
  FileName: string;
begin
  if TabIndex < 0 then
    Exit;
  Sheet := TSourceFileSheet(PageControlEditor.Pages[TabIndex]);
  FileProp := Sheet.SourceFile;
  if (not FileProp.Saved and
    (not FileProp.IsNew or
    ((FileProp.Project.FileType = FILE_TYPE_PROJECT) and (Sheet.Memo.Lines.Count > 0)))) or
    (FileProp.Modified and not (Config.Environment.RemoveFileOnClose and
    (FileProp.Project.FileType <> FILE_TYPE_PROJECT))) then
  begin
    if FileProp.Project.Saved then
      FileName := FileProp.Name
    else
      FileName := FileProp.FileName;
    I := InternalMessageBox(PChar(Format(STR_FRM_MAIN[10], [
      FileName])), 'Falcon C++',
        MB_YESNOCANCEL + MB_ICONINFORMATION);
    case I of
      mrYes:
        begin
          if FileProp.Modified then
            FileProp.Project.Compiled := False;
          FileProp.Save;
        end;
      mrCancel: Exit;
    end;
  end;
  clAction := True;
  if (FileProp.Project.FileType <> FILE_TYPE_PROJECT) and
    Config.Environment.RemoveFileOnClose then
  begin
    RemoveFile(Handle, FileProp);
    Exit;
  end;
  PageControlEditor.Visible := (PageControlEditor.PageCount > 1);
  if not DebugReader.Running and
    (TabIndex = PageControlEditor.ActivePageIndex) then
    TreeViewOutline.Clear;
  if not PageControlEditor.Visible then
  begin
    PanelOutline.Hide;
  end;
  if FileProp.Modified then
  begin
    FilesParsed.Delete(FileProp.FileName);
    if FileProp.Saved then
      ParseFile(FileProp.FileName, FileProp);
  end;
  if not PageControlEditor.Visible and (PageControlProjects.ActivePageIndex = 0) then
  begin
    StatusBar.Panels.Items[1].Caption := '';
    StatusBar.Panels.Items[2].Caption := '';
    StatusBar.Panels.Items[2].ImageIndex := -1;
    if ProjectPanel.Visible then
      TreeViewProjects.SetFocus;
  end;
  AllowClose := clAction;
end;

procedure TFrmFalconMain.SaveExtensionChange(Sender: TObject);
begin
  with TSaveDialog(Sender) do
  begin
    case FilterIndex of
      1: DefaultExt := '.c';
      2: DefaultExt := '.cpp';
      3: DefaultExt := '.h';
      4: DefaultExt := '.rc';
    else
      DefaultExt := '';
    end;
  end;
end;

function TFrmFalconMain.SaveProject(ProjProp: TProjectFile; SaveMode: TSaveMode): Boolean;
var
  OldFileName: string;
  OldIsNew, OldSaved: Boolean;
begin
  Result := False;
  with TSaveDialog.Create(Self) do
  begin
    FileName := ProjProp.Name;
    case ProjProp.FileType of
      FILE_TYPE_PROJECT:
        begin
          DefaultExt := '.fpj';
          Filter := STR_FRM_MAIN[11] + ' (*.fpj)|*.fpj';
        end;
      FILE_TYPE_C:
        begin
          DefaultExt := '.c';
          Filter := STR_NEW_MENU[2] + ' (*.c)|*.c';
        end;
      FILE_TYPE_CPP:
        begin
          DefaultExt := '.cpp';
          Filter := STR_NEW_MENU[3] + ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp';
        end;
      FILE_TYPE_H:
        begin
          DefaultExt := '.h';
          Filter := STR_NEW_MENU[4] + ' (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh';
        end;
      FILE_TYPE_RC:
        begin
          DefaultExt := '.rc';
          Filter := STR_NEW_MENU[5] + ' (*.rc)|*.rc';
        end;
      FILE_TYPE_UNKNOW:
        begin
          Filter := STR_NEW_MENU[2] + ' (*.c)|*.c';
          Filter := Filter + '|' + STR_NEW_MENU[3] + ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp';
          Filter := Filter + '|' + STR_NEW_MENU[4] + '  (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh';
          Filter := Filter + '|' + STR_NEW_MENU[5] + ' (*.rc)|*.rc';
          Filter := Filter + '|' + STR_FRM_MAIN[12] + '|*.*';
          FilterIndex := 2;
          DefaultExt := 'cpp';
          OnTypeChange := SaveExtensionChange;
        end;
    end;
    Options := Options + [ofOverwritePrompt];
    PageControlEditor.CancelDragging;
    if not Execute then
      Exit;
    if (ProjProp.FileType = FILE_TYPE_UNKNOW) then
    begin
      ProjProp.FileType := GetFileType(FileName);
      ProjProp.CompilerType := GetCompiler(ProjProp.FileType);
    end;
    OldFileName := ProjProp.FileName;
    OldIsNew := ProjProp.IsNew;
    OldSaved := ProjProp.Saved;
    ProjProp.Saved := True;
    try
      if SaveMode = smSaveAs then
        ProjProp.SaveAs(FileName)
      else
      begin
        ProjProp.IsNew := False;
        ProjProp.FileName := FileName;
        ProjProp.SaveAll;
        ProjProp.Save;
      end;
      UpdateStatusbar;
    except
      ProjProp.Saved := OldSaved;
      ProjProp.IsNew := OldIsNew;
      ProjProp.FileName := OldFileName;
      Exit;
    end;
    UpdateMenuItems([rmFile]);
    Result := True;
  end;
end;

procedure TFrmFalconMain.UpdateStatusbar;
var
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
  MenuItem: TTBCustomItem;
  S: string;
begin
  if not GetActiveSheet(Sheet) then
  begin
    StatusBar.Panels.Items[4].Caption := '';
    StatusBar.Panels.Items[4].Hint := '';
    StatusBar.Panels.Items[5].Caption := '';
    StatusBar.Panels.Items[5].Hint := '';
  end
  else
  begin
    if Sheet.SourceFile.Encoding = ENCODING_UTF8 then
      MenuItem := PopupMenuEncoding.Items.Items[1]
    else if Sheet.SourceFile.Encoding = ENCODING_UCS2 then
      MenuItem := PopupMenuEncoding.Items.Items[2]
    else // ENCODING_ANSI
      MenuItem := PopupMenuEncoding.Items.Items[0];
    MenuItem.Checked := True;
    StatusBar.Panels.Items[4].Caption := MenuItem.Caption;
    S := '';
    if Sheet.SourceFile.WithBOM then
      S := 'With BOM';
    if (Sheet.SourceFile.Encoding = ENCODING_UCS2) then
    begin
      if Sheet.SourceFile.Endian = ENDIAN_LITTLE then
        S := Trim('Little Endian ' + S)
      else if Sheet.SourceFile.Endian = ENDIAN_LITTLE then
        S := Trim('Big Endian ' + S);
    end;
    StatusBar.Panels.Items[4].Hint := S;
    if Sheet.SourceFile.LineEnding = LINE_ENDING_LINUX then
      MenuItem := PopupMenuLineEnding.Items.Items[1]
    else if Sheet.SourceFile.LineEnding = LINE_ENDING_MAC then
      MenuItem := PopupMenuLineEnding.Items.Items[2]
    else // LINE_ENDING_WINDOWS
      MenuItem := PopupMenuLineEnding.Items.Items[0];
    MenuItem.Checked := True;
    StatusBar.Panels.Items[5].Caption := MenuItem.Caption;
  end;
  if not GetActiveFile(FileProp) then
  begin
    StatusBar.Panels.Items[0].ImageIndex := -1;
    StatusBar.Panels.Items[0].Caption := '';
    StatusBar.Panels.Items[0].Hint := '';
    Exit;
  end;
  //update status bar
  StatusBar.Panels.Items[0].ImageIndex := FILE_IMG_LIST[FileProp.FileType];
  StatusBar.Panels.Items[0].Caption := FileProp.Name;
  StatusBar.Panels.Items[0].Hint := FileProp.FileName;
end;

//save selected project or file in list

procedure TFrmFalconMain.FileSaveClick(Sender: TObject);
var
  FileProp: TSourceFile;
  ProjProp: TProjectFile;
begin
  if not GetActiveFile(FileProp) then
    Exit;
  ProjProp := FileProp.Project;
  if not ProjProp.Saved or ProjProp.IsNew then
  begin
    SaveProject(ProjProp, smSave);
  end
  else
  begin
    FileProp.Project.Compiled := False;
    if FileProp is TProjectFile then
    begin
      ProjProp.SaveAll;
      ProjProp.Save;
    end
    else
      FileProp.Save;
    UpdateMenuItems([rmFile]);
  end;

end;

//detect if enter action on file of list

procedure TFrmFalconMain.TreeViewProjectsKeyPress(Sender: TObject; var Key: Char);
var
  ProjProp: TProjectFile;
begin
  if not (Key = #13) or TreeViewProjects.IsEditing then
    Exit;
  if (TreeViewProjects.SelectionCount < 1) then
    Exit;
  Key := #0;
  if (TObject(TreeViewProjects.Selected.Data) is TProjectFile) then
  begin
    ProjProp := TProjectFile(TreeViewProjects.Selected.Data);
    if (ProjProp.FileType = FILE_TYPE_PROJECT) then
      TreeViewProjects.Selected.Expand(False)
    else
      EditFileClick(Sender);
  end
  else
    EditFileClick(Sender);
end;

//on change tab editor

procedure TFrmFalconMain.PageControlEditorChange(Sender: TObject);
begin
  if PageControlEditor.PageCount = 0 then
    UpdateMenuItems([rmEdit, rmSearch]);
  UpdateMenuItems([rmEdit, rmSearch, rmPageCtrlPopup]);
end;

procedure TFrmFalconMain.EditorBeforeCreate(FileProp: TSourceFile);
var
  prjs: TTreeNode;
  FindedTokenFile: TTokenFile;
begin
  prjs := TreeViewProjects.Items.GetFirstNode;
  while prjs <> nil do
  begin
    BoldTreeNode(prjs, False);
    prjs := prjs.getNextSibling;
  end;

  BoldTreeNode(FileProp.Project.Node, True);

  if LastSelectedProject <> FileProp.Project then
  begin
    LastSelectedProject := FileProp.Project;
    FilesParsed.IncludeList.Clear;
    GetIncludeDirs(ExtractFilePath(FileProp.Project.FileName), FileProp.Project.Flags,
      FilesParsed.IncludeList);
  end;
  CurrentFileIsParsed := False;
  if ViewOutline.Checked then
    PanelOutline.Show;
  FindedTokenFile := FilesParsed.ItemOfByFileName(FileProp.FileName);
  if FindedTokenFile <> nil then
  begin
    CurrentFileIsParsed := True;
    FindedTokenFile.Data := FileProp;
    UpdateActiveFileToken(FindedTokenFile);
  end;
end;

//popupmenu close active tab editor

procedure TFrmFalconMain.FileCloseClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    PageControlEditor.CloseActiveTab;
    if GetActiveSheet(sheet) then
      sheet.Memo.SetFocus;
  end;
end;

//execute application

procedure TFrmFalconMain.ExecuteApplication(ProjectFile: TProjectFile);
var
  FileName, ExecFile, Source, SourcePath: string;
  List: TStrings;
  Breakpoint: TBreakpointList;
  I, J: Integer;
begin
  FileName := ProjectFile.GetTarget;
  if FileExists(FileName) then
  begin
    case ProjectFile.AppType of
      APPTYPE_DLL, APPTYPE_LIB:
        begin
        //nothing
        end;
      APPTYPE_CONSOLE, APPTYPE_GUI:
        begin
          HintTip.Cancel;
          if ProjectFile.Debugging then
          begin
            ExecFile := StringReplace(FileName, '\', '/', [rfReplaceAll]);
            SourcePath := ExtractFilePath(ProjectFile.FileName);
            DebugReader.FileName := 'gdb';
            DebugReader.Params := '-quiet -fullname -nx -return-child-result';
            DebugReader.Directory := ExtractFilePath(FileName);
            DebugReader.Start;
            if ProjectFile.AppType = APPTYPE_CONSOLE then
              DebugReader.SendCommand(GDB_SETNEWCONSOLE);
            DebugReader.SendCommand(GDB_SETCONFIRM, GDB_OFF);
            DebugReader.SendCommand(GDB_SETWIDTH, '0');
            DebugReader.SendCommand(GDB_SETHEIGHT, '0');
            DebugReader.SendCommand(GDB_FILE, DoubleQuotedStr(ExecFile));
            DebugReader.SendCommand(GDB_SETARGS, ProjectFile.CmdLine);
            DebugReader.SendCommand(GDB_EXECFILE, DoubleQuotedStr(ExecFile));
            List := TStringList.Create;
            ProjectFile.GetBreakpointLists(List);
            if ProjectFile.BreakpointCursor.Valid then
            begin
              Source := ExtractRelativePath(SourcePath,
                ProjectFile.BreakpointCursor.FileName);
              Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
              DebugReader.SendCommand(GDB_BREAK, DoubleQuotedStr(Source) + ':' +
                IntToStr(ProjectFile.BreakpointCursor.Line));
            end;
            for I := 0 to List.Count - 1 do
            begin
              Breakpoint := TBreakpointList(List.Objects[I]);
              Source := ExtractRelativePath(SourcePath, List.Strings[I]);
              Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
              for J := 0 to Breakpoint.Count - 1 do
              begin
                DebugReader.SendCommand(GDB_BREAK, DoubleQuotedStr(Source) + ':' +
                  IntToStr(Breakpoint.Items[J].Line));
              end;
            end;
            List.Free;
            DebugReader.SendCommand(GDB_RUN);
            if Config.Compiler.ReverseDebugging then
              DebugReader.SendCommand(GDB_RECORD);
          end
          else
          begin
            if (ProjectFile.AppType = APPTYPE_CONSOLE) and
              FileExists(AppRoot + 'ConsoleRunner.exe') and
              Config.Environment.RunConsoleRunner then
            begin
              Executor.ExecuteAndWatch(AppRoot + 'ConsoleRunner.exe',
                DoubleQuotedStr(FileName) + ' ' + ProjectFile.CmdLine,
                ExtractFilePath(FileName), True, INFINITE, ExecutorStart, LauncherFinished);
            end
            else
            begin
              Executor.ExecuteAndWatch(FileName, ProjectFile.CmdLine,
                ExtractFilePath(FileName), True, INFINITE, ExecutorStart, LauncherFinished);
            end;
          end;
        end;
    end;
  end;
end;

procedure TFrmFalconMain.RunExecuteClick(Sender: TObject);
var
  ProjProp: TProjectFile;
begin
  if GetActiveProject(ProjProp) then
    ExecuteApplication(ProjProp);
end;

procedure TFrmFalconMain.TreeViewProjectsEnter(Sender: TObject);
begin
  UpdateMenuItems([rmFile, rmProject, rmRun]);
  UpdateStatusbar;
end;

//on change the active tab

procedure TFrmFalconMain.PageControlEditorPageChange(Sender: TObject;
  TabIndex, PrevTabIndex: Integer);
var
  ProjProp: TProjectFile;
  Sheet, prevSheet: TSourceFileSheet;
  Prop, PrevProp: TSourceFile;
  FindedTokenFile: TTokenFile;
  Index: Integer;
  prjs: TTreeNode;
begin
  if HandlingTabs then
    Exit;
  Index := PageControlEditor.ActivePageIndex;
  UpdateMenuItems([rmFile, rmProject, rmRun, rmPageCtrlPopup]);
  if (Index >= 0) then
  begin
    prjs := TreeViewProjects.Items.GetFirstNode;
    while prjs <> nil do
    begin
      BoldTreeNode(prjs, False);
      prjs := prjs.getNextSibling;
    end;
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    Prop := Sheet.SourceFile;
    if Sheet.SourceFile is TProjectFile then
      ProjProp := TProjectFile(Sheet.SourceFile)
    else
      ProjProp := Sheet.SourceFile.Project;
    BoldTreeNode(ProjProp.Node, True);
    if LastSelectedProject <> ProjProp then
    begin
      LastSelectedProject := ProjProp;
      FilesParsed.IncludeList.Clear;
      GetIncludeDirs(ExtractFilePath(ProjProp.FileName), ProjProp.Flags,
        FilesParsed.IncludeList, True);
    end;
    //Reload Tokens ?
    //if not DebugReader.Running then
    //  TreeViewOutline.Clear;
    if not IsLoading then
    begin
      FindedTokenFile := FilesParsed.ItemOfByFileName(Prop.FileName);
      if FindedTokenFile <> nil then
        UpdateActiveFileToken(FindedTokenFile)
      else if {not FilesParsed.Busy and }not DebugReader.Running then
        TreeViewOutline.Clear;
      if TimerChangeDelay.Enabled and (PrevTabIndex >= 0) then
      begin
        TimerChangeDelay.Enabled := False;
        // parse changed file
        prevSheet := TSourceFileSheet(PageControlEditor.Pages[PrevTabIndex]);
        PrevProp := prevSheet.SourceFile;
        FilesParsed.Delete(PrevProp.FileName);
        ParseFile('-', PrevProp);
      end;
    end;
  end
  else
  begin
    if not DebugReader.Running then
      TreeViewOutline.Clear;
    Index := PageControlEditor.PageCount;
    if Index > 0 then
      PageControlEditor.ActivePageIndex := Index - 1;
  end;
  CheckIfFilesHasChanged;
  DebugHint.Cancel;
  HintParams.Cancel;
  HintTip.Cancel;
end;

//compile and execute application

procedure TFrmFalconMain.RunApplication(ProjectFile: TProjectFile);
begin
  if DebugReader.Running then
  begin
    InvalidateDebugLine;
    RunContinue(Self);
    Exit;
  end;
  CompilerActiveMsg := STR_FRM_MAIN[18];
  if ProjectFile.NeedBuild then
  begin
    FCompilationStopped := False;
    RunNow := True;
    ProjectFile.Build;
  end
  else
    ExecuteApplication(ProjectFile);
end;

procedure TFrmFalconMain.RunRunClick(Sender: TObject);
var
  ProjProp: TProjectFile;
begin
  if GetActiveProject(ProjProp) then
    RunApplication(ProjProp);
end;

//on execution finished

procedure TFrmFalconMain.LauncherFinished(Sender: TObject);
begin
  //--clean
  if Assigned(LastProjectBuild) then
    LastProjectBuild.BreakpointCursor.Valid := False;
  //****************
  Caption := 'Falcon C++';
  RunRun.Caption := STR_MENU_RUN[1];
  BtnRun.Caption := STR_MENU_RUN[1];
  BtnRun.Hint := STR_MENU_RUN[1];
  UpdateMenuItems([rmProject, rmRun]);
end;

//stop execution or compilation

procedure TFrmFalconMain.StatusBarContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  StatusPanel: TTBXStatusPanel;
begin
  StatusPanel := StatusBar.GetPanelAt(MousePos);
  if StatusPanel = StatusBar.Panels.Items[4] then
    StatusBar.PopupMenu := PopupMenuEncoding
  else if StatusPanel = StatusBar.Panels.Items[5] then
    StatusBar.PopupMenu := PopupMenuLineEnding
  else
    StatusBar.PopupMenu := nil;
end;

procedure TFrmFalconMain.StopAll;
begin
  FCompilationStopped := True;
  if CompilerCmd.Executing then
    CompilerCmd.Stop;
  if Executor.Running then
    Executor.ResetAll;
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_QUIT);
  if DebugReader.Running then
  begin
    Application.ProcessMessages;
    Sleep(100); //?
    DebugReader.Stop;
  end;
end;

procedure TFrmFalconMain.RunStopClick(Sender: TObject);
begin
  StopAll;
end;

//previous sheet of editor

procedure TFrmFalconMain.BtnPreviousPageClick(Sender: TObject);
begin
  if PageControlEditor.ActivePageIndex - 1 < 0 then
    PageControlEditor.ActivePageIndex := PageControlEditor.PageCount - 1
  else
    PageControlEditor.ActivePageIndex := PageControlEditor.ActivePageIndex - 1;
end;

//next sheet of editor

procedure TFrmFalconMain.BtnNextPageClick(Sender: TObject);
begin
  PageControlEditor.ActivePageIndex :=
    (PageControlEditor.ActivePageIndex + 1) mod PageControlEditor.PageCount;
end;

//on popupmenu on project list

procedure TFrmFalconMain.TreeViewProjectsContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Node: TTreeNode;
  MPos: TPoint;
begin
  GetCursorPos(MPos);
  MPos := TreeViewProjects.ScreenToClient(MPos);
  Node := TreeViewProjects.GetNodeAt(MPos.X, MPos.Y);
  if not Assigned(Node) and Assigned(TreeViewProjects.Selected) then
    Node := TreeViewProjects.Selected;
  if not Assigned(Node) then
  begin
    if (TreeViewProjects.SelectionCount = 1) then
      TreeViewProjects.Selected.Selected := False;
    {ProjectPopupMenuItens(True, True, True, True, True, True, True, False,
      False, False, False, False, False);}
  end
  else
  begin
    Node.Selected := True;
    Node.Focused := True;
  end;
end;

//on click on project list

procedure TFrmFalconMain.TreeViewProjectsClick(Sender: TObject);
var
  Node: TTreeNode;
  MPos: TPoint;
  Prop: TSourceFile;
  Hits: THitTests;
begin
  GetCursorPos(MPos);
  MPos := TreeViewProjects.ScreenToClient(MPos);
  Hits := TreeViewProjects.GetHitTestInfoAt(MPos.X, MPos.Y);
  if ([htOnItem] * Hits) <> [] then
    Node := TreeViewProjects.GetNodeAt(MPos.X, MPos.Y)
  else
    Node := nil;
  if not Assigned(Node) then
  begin
    if (TreeViewProjects.SelectionCount = 1) then
      TreeViewProjects.Selected.Selected := False;
  end
  else
  begin
    Node.Selected := True;
    Node.Focused := True;
    Prop := TSourceFile(Node.Data);
    if Config.Environment.OneClickOpenFile and
      not (Prop.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]) then
    begin
      Node.EndEdit(True);
      Prop.Edit;
    end;
  end;
end;

//compile current project

procedure TFrmFalconMain.RunCompileClick(Sender: TObject);
var
  ProjProp: TProjectFile;
begin
  CompilerActiveMsg := STR_FRM_MAIN[18];
  if GetActiveProject(ProjProp) then
  begin
    FCompilationStopped := False;
    RunNow := False;
    ProjProp.Build;
  end;
end;

//select all text

procedure TFrmFalconMain.EditSelectAllClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.SelectAll;
  end;
end;

//build application

procedure TFrmFalconMain.ProjectBuildClick(Sender: TObject);
var
  ProjProp: TProjectFile;
begin
  CompilerActiveMsg := STR_FRM_MAIN[19];
  if GetActiveProject(ProjProp) then
  begin
    RunNow := False;
    ProjProp.ForceClean := True;
    ProjProp.Build;
  end;
end;

procedure TFrmFalconMain.TreeViewProjectsEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
  g_OrigEditProc := Pointer(SetWindowLong(TreeView_GetEditControl(TreeViewProjects.Handle),
    GWL_WNDPROC, Integer(@TreeViewEditSubclassProc)));
end;

procedure TFrmFalconMain.TreeViewProjectsEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  OldFileName, FilePath: string;
  Ext: string;
begin
  if Trim(S) = '' then
  begin
    S := TSourceFile(Node.Data).Name;
    Exit;
  end;
  OldFileName := TSourceFile(Node.Data).FileName;
  if (Node.Level = 0) then
  begin
    FilePath := ExtractFilePath(OldFileName);
    if (TSourceFile(Node.Data).FileType = FILE_TYPE_PROJECT) then
    begin
      TSourceFile(Node.Data).Rename(FilePath + ExtractName(S) + '.fpj');
      S := TSourceFile(Node.Data).Name;
      Exit;
    end;
    Ext := ExtractFileExt(TSourceFile(Node.Data).FileName);
    if Ext <> ExtractFileExt(S) then
      TSourceFile(Node.Data).Rename(FilePath + ExtractName(S) + Ext)
    else
      TSourceFile(Node.Data).Rename(FilePath + S);
    S := TSourceFile(Node.Data).Name;
  end
  else
  begin
    if TSourceFile(Node.Data).FileType <> FILE_TYPE_FOLDER then
    begin
      Ext := ExtractFileExt(OldFileName);
      if Ext <> ExtractFileExt(S) then
        TSourceFile(Node.Data).Rename(ChangeFileExt(S, Ext))
      else
        TSourceFile(Node.Data).Rename(S);
    end
    else // folder
      TSourceFile(Node.Data).Rename(S);
    S := TSourceFile(Node.Data).Name;
  end;
end;

procedure TFrmFalconMain.TreeViewProjectsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Node: TTreeNode;
begin
  if Key = VK_F2 then
  begin
    if (TreeViewProjects.SelectionCount = 1) then
      TreeViewProjects.Selected.EditText;
  end
  else if ([ssCtrl, ssShift] = Shift) and (TreeViewProjects.SelectionCount = 1) then
  begin
    Node := TreeViewProjects.Selected;
    if Key = VK_UP then
    begin
      if Node.getPrevSibling <> nil then
      begin
        Node.MoveTo(Node.getPrevSibling, naInsert);
        if Node.Parent <> nil then
          TSourceFile(Node.Data).Project.PropertyChanged := True
        else
          BoldTreeNode(Node, True);
        UpdateMenuItems([rmFile]);
      end;
    end
    else if Key = VK_DOWN then
    begin
      if (Node.getNextSibling <> nil) then
      begin
        if (Node.getNextSibling.getNextSibling <> nil) then
          Node.MoveTo(Node.getNextSibling.getNextSibling, naInsert)
        else
          Node.MoveTo(Node.getNextSibling, naAdd);
        if Node.Parent <> nil then
          TSourceFile(Node.Data).Project.PropertyChanged := True
        else
          BoldTreeNode(Node, True);
        UpdateMenuItems([rmFile]);
      end;
    end
  end;
end;

function TFrmFalconMain.RemoveFile(ParentHandle: HWND; FileProp:
  TSourceFile; FromDisk: Boolean): Boolean;
var
  Node: TTreeNode;
  ProjProp: TProjectFile;
  I: Integer;
  Msg: string;
begin
  Result := False;
  if FileProp is TProjectBase then //is project
  begin
    ProjProp := FileProp.Project;
    if not FromDisk then
    begin
      if ProjProp.Modified or (not ProjProp.Saved and not ProjProp.IsNew) or
        ProjProp.FilesChanged or ProjProp.SomeFileChanged then
      begin //modified
        I := InternalMessageBox(PChar(Format(STR_FRM_MAIN[10],
          [ExtractFileName(ProjProp.FileName)])), 'Falcon C++',
          MB_YESNOCANCEL + MB_ICONINFORMATION, ParentHandle);
        case I of
          mrYes:
            begin
              if not ProjProp.Saved or ProjProp.IsNew then
              begin
                if not SaveProject(ProjProp, smSave) then
                  Exit;
              end
              else
              begin
                ProjProp.SaveAll;
                ProjProp.Save;
              end;
            end;
          mrCancel: Exit;
        end; //case
      end;
    end
    else
    begin
      if FileProp.FileType = FILE_TYPE_FOLDER then
        Msg := STR_FRM_MAIN[53]
      else
        Msg := STR_FRM_MAIN[21];
      I := InternalMessageBox(PChar(Format(Msg, [FileProp.Name])), 'Falcon C++',
        MB_YESNOCANCEL + MB_ICONEXCLAMATION, ParentHandle);
      if I <> mrYes then
        Exit;
    end;
    if DebugReader.Running and Assigned(DebugActiveFile) and
      (DebugActiveFile.Project = ProjProp) then
    begin
      DebugReader.Stop;
      DebugActiveLine := -1;
      DebugActiveFile := nil;
    end;
    if not FromDisk and Config.Environment.CreateLayoutFiles and ProjProp.Saved and
      (ProjProp.FileType = FILE_TYPE_PROJECT) then
      ProjProp.SaveLayout;
    ProjProp.CloseAll;
    if ProjProp = LastSelectedProject then
      LastSelectedProject := nil;
    if LastProjectBuild = ProjProp then
    begin
      if CompilerCmd.Executing then
        CompilerCmd.Stop;
      if DebugReader.Running then
        DebugReader.Stop;
      if Executor.Running and
        (CompareText(Executor.FileName, ProjProp.GetTarget) = 0) then
        Executor.Reset;
      LastProjectBuild := nil;
      ListViewMsg.Clear;
    end;
    if not FromDisk then
      ProjProp.Delete
    else
      ProjProp.DeleteOfDisk;
    if TreeViewProjects.Items.Count = 0 then
    begin
      LastProjectBuild := nil;
      ListViewMsg.Clear;
      PanelMessages.Hide;
    end;
  end //level = 0
  else
  begin
    if not FromDisk then
    begin
      if Config.Environment.AskForDeleteFile then
      begin
        if FileProp.FileType = FILE_TYPE_FOLDER then
          Msg := STR_FRM_MAIN[52]
        else
          Msg := STR_FRM_MAIN[20];
        I := InternalMessageBox(PChar(Format(Msg, [FileProp.Name])), 'Falcon C++',
          MB_YESNO + MB_ICONQUESTION, ParentHandle);
        if I <> mrYes then
          Exit;
      end;
      if FileProp.Modified and FileProp.Saved then
      begin //modified
        I := InternalMessageBox(PChar(Format(STR_FRM_MAIN[10],
          [ExtractFileName(FileProp.FileName)])), 'Falcon C++',
          MB_YESNO + MB_ICONINFORMATION, ParentHandle);
        case I of
          mrYes: FileProp.Save;
        end; //case
      end;
    end
    else
    begin
      if FileProp.FileType = FILE_TYPE_FOLDER then
        Msg := STR_FRM_MAIN[53]
      else
        Msg := STR_FRM_MAIN[21];
      I := InternalMessageBox(PChar(Format(Msg, [FileProp.Name])), 'Falcon C++',
        MB_YESNOCANCEL + MB_ICONEXCLAMATION, ParentHandle);
      if I <> mrYes then
        Exit;
    end;
    Node := FileProp.Node;
    if Node.getNextSibling = nil then
    begin
      Node := Node.getPrevSibling;
      if Assigned(Node) then
        Node.Selected := True;
    end;
    if not FromDisk then
      FileProp.Delete
    else
      FileProp.DeleteOfDisk;
  end;
  TreeViewProjectsChange(TreeViewProjects, TreeViewProjects.Selected);
  TextEditorExit(Self);
  PanelOutline.Visible := (PageControlEditor.PageCount > 0) and ViewOutline.Checked;
  if not PanelOutline.Visible then
    TreeViewOutline.Clear;
  Result := True;
end;

function TFrmFalconMain.CreateProject(NodeText: string;
  FileType: Integer): TProjectFile;
var
  Node: TTreeNode;
begin
  Node := TreeViewProjects.Items.AddChild(nil, NodeText);
  Result := TProjectFile.Create(Node);
  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := Result;
  Result.FileType := FileType;
  Node.Data := Result;

  if FileType <> FILE_TYPE_PROJECT then
    FLastPathInclude := '';
end;

function TFrmFalconMain.CreateSource(ParentNode: TTreeNode;
  NodeText: string): TSourceFile;
var
  Node: TTreeNode;
begin
  Node := TreeViewProjects.Items.AddChild(ParentNode, NodeText);
  Result := TSourceFile.Create(Node);
  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := TSourceFile(ParentNode.Data).Project;
  Node.Data := Result;

  FLastPathInclude := '';
end;

procedure TFrmFalconMain.DoDeleteSource(Source: TSourceBase);
var
  TokenFile: TTokenFile;
begin
  if not (Source.FileType in [FILE_TYPE_H, FILE_TYPE_CPP]) then
    Exit;
  TokenFile := FilesParsed.ItemOfByFileName(Source.FileName);
  if TokenFile = nil then
    Exit;
  // remove references
  TokenFile.Data := nil;
end;

procedure TFrmFalconMain.DoRenameSource(Source: TSourceBase;
  const OldFileName: string);
var
  FindedTokenFile: TTokenFile;
  Temp, FilePath, CurrentFilePath: string;
  ParseList, RemoveList: TStrings;
  I: Integer;
begin
  FLastPathInclude := '';
  FilePath := ExtractFilePath(ExcludeTrailingPathDelimiter(OldFileName));
  if Source is TProjectBase then
  begin
    if (Source.FileType = FILE_TYPE_PROJECT) and
      (CompareText(FilePath, ExtractFilePath(Source.FileName)) = 0) then
      Exit;
    ParseList := TStringList.Create;
    RemoveList := TStringList.Create;
    if (Source.FileType = FILE_TYPE_PROJECT) then
    begin
      TProjectBase(Source).GetFiles(ParseList);
      CurrentFilePath := ExtractFilePath(ExcludeTrailingPathDelimiter(Source.FileName));
      for I := 0 to ParseList.Count - 1 do
      begin
        Temp := ExtractRelativePath(CurrentFilePath, ParseList.Strings[I]);
        RemoveList.AddObject(FilePath + Temp, ParseList.Objects[I]);
      end;
    end
    else
    begin
      ParseList.AddObject(Source.FileName, Source);
      RemoveList.AddObject(OldFileName, Source);
    end;
  end
  else
  begin
    ParseList := TStringList.Create;
    RemoveList := TStringList.Create;
    if Source.FileType <> FILE_TYPE_FOLDER then
    begin
      ParseList.AddObject(Source.FileName, Source);
      RemoveList.AddObject(OldFileName, Source);
    end
    else // folder
    begin
      TSourceFile(Source).GetSubFiles(ParseList);
      for I := 0 to ParseList.Count - 1 do
      begin
        Temp := ExtractRelativePath(Source.FileName, ParseList.Strings[I]);
        RemoveList.AddObject(OldFileName + Temp, ParseList.Objects[I]);
      end;
    end;
  end;
  for I := 0 to RemoveList.Count - 1 do
  begin
    FindedTokenFile := FilesParsed.ItemOfByFileName(RemoveList.Strings[I]);
    if FindedTokenFile <> nil then
      FilesParsed.Remove(FindedTokenFile);
  end;
  RemoveList.Free;
  ParseFiles(ParseList);
  ParseList.Free;
end;

// update icons and set highlighter
procedure TFrmFalconMain.DoTypeChangedSource(Source: TSourceBase; OldType: Integer);
var
  Sheet: TSourceFileSheet;
begin
  if Assigned(Source.Node) then
  begin
    Source.Node.ImageIndex := FILE_IMG_LIST[Source.FileType];
    Source.Node.SelectedIndex := FILE_IMG_LIST[Source.FileType];
  end;
  if TSourceFile(Source).GetSheet(Sheet) then
  begin
    Sheet.ImageIndex := FILE_IMG_LIST[Source.FileType];
    case Source.FileType of
      FILE_TYPE_C..FILE_TYPE_H: Sheet.Memo.Highlighter := CppHighligher;
// TODO: commented
//        FILE_TYPE_RC: Sheet.Memo.Highlighter := FrmFalconMain.ResourceHighlighter;
    end;
  end;
end;

procedure TFrmFalconMain.PopProjDelFromDskClick(Sender: TObject);
var
  Node: TTreeNode;
  FileProp: TSourceFile;
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if not TreeViewProjects.IsEditing then
    begin
      Node := TreeViewProjects.Selected;
      FileProp := TSourceFile(Node.Data);
      RemoveFile(Handle, FileProp, True)
    end; //not editing
  end; //count > 0
end;

procedure TFrmFalconMain.PopProjRenameClick(Sender: TObject);
begin
  if TreeViewProjects.SelectionCount = 0 then
    Exit;
  TreeViewProjects.Selected.EditText;
end;

procedure TFrmFalconMain.PopProjOpenClick(Sender: TObject);
var
  SourceFile: TSourceFile;
begin
  if not GetSelectedFileInList(SourceFile) then
    Exit;
  SourceFile.Open;
end;

procedure TFrmFalconMain.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFalconMain.FileCloseAllClick(Sender: TObject);
var
  I: Integer;
begin
  HandlingTabs := True;
  for I := PageControlEditor.PageCount - 1 downto 0 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  HandlingTabs := False;
  PageControlEditorPageChange(PageControlEditor,
    PageControlEditor.ActivePageIndex, -1);
end;

procedure TFrmFalconMain.ToolsClick(Sender: TObject);
begin
  TToolMenuItem(Sender).ExecuteCommand;
end;

procedure TFrmFalconMain.SendDataCopyData(var Msg: TWMCopyData);
begin
  SendData.Action(Msg);
end;

function TFrmFalconMain.FileInHistory(const FileName: string;
  var HistCount: Integer): Boolean;
var
  I: Integer;
begin
  HistCount := 0;
  Result := False;
  if FileReopen.Count < 3 then
    Exit;
  HistCount := FileReopen.Count - 2;
  for I := 2 to FileReopen.Count - 1 do
  begin
    if CompareText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) = 0 then
    begin
      if I <> 2 then
        FileReopen.Move(I, 2);
      Result := True;
      Exit;
    end;
  end;
end;

function TFrmFalconMain.RenameFileInHistory(const FileName,
  NewFileName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if FileReopen.Count < 3 then
    Exit;
  for I := 2 to FileReopen.Count - 1 do
  begin
    if CompareText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) = 0 then
    begin
      TDataMenuItem(FileReopen.Items[I]).HelpFile := NewFileName;
      TDataMenuItem(FileReopen.Items[I]).Caption := NewFileName;
      TDataMenuItem(FileReopen.Items[I]).ImageIndex := GetFileType(FileName);
      Result := True;
      Exit;
    end;
  end;
end;

function TFrmFalconMain.AddFileToHistory(const FileName: string): Boolean;
var
  HistCount: Integer;
  Item: TDataMenuItem;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  if FileInHistory(FileName, HistCount) then
    Exit;
  while (HistCount >= Config.Environment.MaxFileInReopen) do
  begin
    FileReopen.Delete(FileReopen.Count - 1);
    if FileReopen.Count <= 2 then
      Break;
  end;
  Item := TDataMenuItem.Create(Self);
  Item.Caption := FileName;
  Item.ImageIndex := GetFileType(FileName);
  Item.HelpFile := FileName;
  Item.OnClick := ReopenFileClick;
  if FileReopen.Count = 1 then
  begin
    TTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[32];
    TTBXItem(FileReopen.Items[0]).Enabled := True;
    TTBXItem(FileReopen.Items[0]).ImageIndex := 51;
    FileReopen.Add(TTBXSeparatorItem.Create(Self));
  end;
  FileReopen.Insert(2, Item);
  Result := True;
end;

procedure TFrmFalconMain.RemoveFileFromHistoric(FileName: string);
var
  I: Integer;
begin
  if FileReopen.Count < 3 then
    Exit;
  for I := 2 to FileReopen.Count - 1 do
  begin
    if CompareText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) = 0 then
    begin
      FileReopen.Delete(I);
      if FileReopen.Count > 2 then
        Exit;
      FileReopen.Delete(1);
      TTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[31];
      TTBXItem(FileReopen.Items[0]).Enabled := False;
      TTBXItem(FileReopen.Items[0]).ImageIndex := -1;
      Exit;
    end;
  end;
end;

procedure TFrmFalconMain.ClearHistoryClick(Sender: TObject);
begin
  while (FileReopen.Count > 1) do
  begin
    FileReopen.Delete(FileReopen.Count - 1);
  end;
  TTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[31];
  TTBXItem(FileReopen.Items[0]).Enabled := False;
  TTBXItem(FileReopen.Items[0]).ImageIndex := -1;
end;

procedure TFrmFalconMain.ReopenFileClick(Sender: TObject);
var
  Proj: TProjectFile;
begin
  if not (Sender is TDataMenuItem) then
    Exit;
  IsLoading := True;
  if OpenFileWithHistoric(TDataMenuItem(Sender).HelpFile, Proj) then
    ParseProjectFiles(Proj);
  IsLoading := False;
end;

function TFrmFalconMain.OpenFileWithHistoric(Value: string;
  var Proj: TProjectFile): Boolean;
var
  ProjProp: TProjectFile;
  FileProp: TSourceFile;
begin
  Result := False;
  if not FileExists(Value) then
  begin
    RemoveFileFromHistoric(Value);
    Exit;
  end;
  if SearchSourceFile(Value, FileProp) then
  begin
    if FileProp.FileType <> FILE_TYPE_PROJECT then
    begin
      FileProp.Edit;
      FileProp.Node.Selected := True;
    end;
  end
  else
  begin
    if CompareText(ExtractFileExt(Value), '.dev') = 0 then
      Result := ImportDevCppProject(Value, Proj)
    else if CompareText(ExtractFileExt(Value), '.cbp') = 0 then
      Result := ImportCodeBlocksProject(Value, Proj)
    else if CompareText(ExtractFileExt(Value), '.vcproj') = 0 then
      Result := ImportMSVCProject(Value, Proj)
    else
    begin
      ProjProp := OpenFile(Value);
      Result := True;
      Proj := ProjProp;
      AddFileToHistory(Value);
      if ProjProp.FileType <> FILE_TYPE_PROJECT then
        ProjProp.Edit;
      ProjProp.Node.Selected := True;
    end;
  end;
end;

procedure TFrmFalconMain.TreeViewProjectsProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
    GetDropredFiles(TreeViewProjects, Msg)
  else if Msg.Msg = WM_LBUTTONDBLCLK then
    TreeViewProjectsDblClick(TreeViewProjects)
  else
    TreeViewProjectsOldProc(Msg);
end;

procedure TFrmFalconMain.TreeViewOutlineProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_LBUTTONDBLCLK then
    TreeViewOutline_DblClick(TreeViewProjects)
  else
    TreeViewOutlineOldProc(Msg);
end;

procedure TFrmFalconMain.PanelEditorMessagesProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
    GetDropredFiles(PanelEditorMessages, Msg)
  else
    PanelEditorMessagesOldProc(Msg);
end;

procedure TFrmFalconMain.GetDropredFiles(Sender: TObject; var Msg: TMessage);
var
  FileCount: longInt;
  Buffer: array[0..MAX_PATH] of char;
  Files: TStrings;
  I: Integer;
  P: TPoint;
  FileName: string;
begin
  Files := TStringList.Create;
  FileCount := DragQueryFile(TWMDropFiles(Msg).Drop, $FFFFFFFF, nil, 0);
  for I := 0 to FileCount - 1 do
  begin
    DragQueryFile(TWMDropFiles(Msg).Drop, i, @Buffer, sizeof(buffer));
    FileName := StrPas(buffer);
    if FileExists(FileName) then
      Files.Add(FileName)
    else if DirectoryExists(FileName) then
    begin
      ListDir(FileName, '*.c', Files, True);
      ListDir(FileName, '*.cpp', Files, True);
      ListDir(FileName, '*.cc', Files, True);
      ListDir(FileName, '*.cxx', Files, True);
      ListDir(FileName, '*.c++', Files, True);
      ListDir(FileName, '*.cp', Files, True);
      ListDir(FileName, '*.h', Files, True);
      ListDir(FileName, '*.hpp', Files, True);
      ListDir(FileName, '*.rh', Files, True);
      ListDir(FileName, '*.hh', Files, True);
      ListDir(FileName, '*.rc', Files, True);
    end;
  end;
  if (Sender = TreeViewProjects) then
  begin
    GetCursorPos(P);
    P := TreeViewProjects.ScreenToClient(P);
    DropFilesIntoProjectList(Files, P.X, P.Y);
  end
  else
    OnDragDropFiles(Sender, Files);
  Files.Free;
end;

procedure TFrmFalconMain.OnDragDropFiles(Sender: TObject; Files: TStrings);
var
  I: Integer;
  Proj: TProjectFile;
begin
  IsLoading := True;
  for I := 0 to Files.Count - 1 do
  begin
    if OpenFileWithHistoric(Files.Strings[I], Proj) then
      ParseProjectFiles(Proj);
  end;
  IsLoading := False;
end;

procedure TFrmFalconMain.ExecutorStart(Sender: TObject);
begin
  Caption := 'Falcon C++ [' + STR_FRM_MAIN[17] + ']';
  UpdateMenuItems([rmProject, rmRun]);
end;

procedure TFrmFalconMain.CompilerCmdStart(Sender: TObject;
  const FileName, Params: string);
begin
  Caption := 'Falcon C++ [' + CompilerActiveMsg + ']';
  UpdateMenuItems([rmProject, rmRun]);
  startBuildTicks := GetTickCount;
end;

//on build finished

procedure TFrmFalconMain.CompilerCmdFinish(Sender: TObject; const FileName,
  Params: string; ConsoleOut: TStrings; ExitCode: Integer);
var
  Item: TListItem;
  Temp, capt, TimeStr: string;
  RowSltd: Boolean;
  I, W: Integer;
  CompMessages: TStrings;
  Msg: TMessageItem;
begin
  BuildTime := GetTickCount - startBuildTicks;
  ListViewMsg.Clear;
  capt := Caption;
  CompMessages := ParseResult(ConsoleOut);
  if (ExitCode = 0) then
  begin
    TimeStr := Format(STR_FRM_MAIN[39],
      [GetTickTime(BuildTime, '%d:%2d:%2d:%d')]);
    StatusBar.Panels.Items[2].Caption := TimeStr;
    W := Canvas.TextWidth(TimeStr) + 20 + ImgListMenus.Width + 10;
    StatusBar.Panels.Items[2].Size := Max(W, 200);
    StatusBar.Panels.Items[2].ImageIndex := 32;
    if (CompMessages.Count > 0) then
    begin
      PanelMessages.Show;
    end
    else
    begin
      PanelMessages.Hide;
    end;
    for I := 0 to CompMessages.Count - 1 do
    begin
      if CompilationStopped then
        break;
      if (CompMessages.Count > 500) then
        Caption := Format('Falcon C++ [' + STR_FRM_MAIN[41] + ']',
          [I + 1, CompMessages.Count]);
      Application.ProcessMessages;
      Msg := TMessageItem(CompMessages.Objects[I]);
      Item := ListViewMsg.Items.Add;
      Item.ImageIndex := Msg.Icon;
      Item.Caption := ExtractFileName(Msg.FileName);
      Item.SubItems.Add(Msg.GetPosXY);
      Item.SubItems.Add(Msg.Msg);
      Item.Data := Msg;
    end;

    LastProjectBuild.Compiled := True;
    LastProjectBuild.CompilePropertyChanged := False;
    if LastProjectBuild.AutoIncBuild then
      if (LastProjectBuild.Version.Build < 9999) then
        Inc(LastProjectBuild.Version.Build)
      else
        Inc(LastProjectBuild.Version.Release);
    Temp := ExtractFilePath(LastProjectBuild.FileName);
    if FileExists(Temp + 'Makefile.mak') and
      LastProjectBuild.DeleteMakefileAfter then
      DeleteFile(Temp + 'Makefile.mak');
    if (LastProjectBuild.EnableTheme or LastProjectBuild.RequiresAdmin) and
      (LastProjectBuild.AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) and
      FileExists(Temp + 'AppManifest.dat') and
      LastProjectBuild.DeleteResourcesAfter then
      DeleteFile(Temp + 'AppManifest.dat');
    if FileExists(Temp + 'AppResource.rc') and
      LastProjectBuild.DeleteResourcesAfter then
      DeleteFile(Temp + 'AppResource.rc');
    if FileExists(Temp + 'AppIcon.ico') and
      LastProjectBuild.DeleteResourcesAfter then
      DeleteFile(Temp + 'AppIcon.ico');
    if FileExists(LastProjectBuild.GetTarget) then
    begin
      LastProjectBuild.TargetDateTime := FileDateTime(LastProjectBuild.GetTarget);
      if RunNow and ((LastProjectBuild.AppType = APPTYPE_CONSOLE) or
        (LastProjectBuild.AppType = APPTYPE_GUI)) then
        ExecuteApplication(LastProjectBuild)
      else
      begin
        Caption := capt;
        LauncherFinished(Sender);
      end;
    end
    else
    begin
      Caption := capt;
      LauncherFinished(Sender);
    end;
  end
  else
  begin
    //images msg  32 .. 34
    StatusBar.Panels.Items[2].Caption := STR_FRM_MAIN[40];
    StatusBar.Panels.Items[2].ImageIndex := 34;
    if Assigned(LastProjectBuild) then
      LastProjectBuild.Compiled := False;
    PanelMessages.Show;
    if (ConsoleOut.Count = 0) then
    begin
      Msg := TMessageItem.Create;
      Msg.MsgType := mitCompiler;
      Msg.FileName := ExtractFileName(CompilerCmd.FileName);
      Msg.OriMsg := STR_FRM_MAIN[22] + ': ' + SysErrorMessage(ExitCode);
      Item := ListViewMsg.Items.Add;
      Item.ImageIndex := 34;
      Item.Caption := Msg.FileName;
      Item.SubItems.Add('');
      Item.SubItems.Add(Msg.OriMsg);
      Item.Data := Msg;
    end;
    RowSltd := False;
    for I := 0 to CompMessages.Count - 1 do
    begin
      if CompilationStopped then
        break;
      if (CompMessages.Count > 500) then
        Caption := Format('Falcon C++ [' + STR_FRM_MAIN[41] + ']',
          [I + 1, CompMessages.Count]);
      Application.ProcessMessages;
      Msg := TMessageItem(CompMessages.Objects[I]);
      if not RowSltd and (Msg.Icon = 34) then
        if (Length(Msg.GetPosXY) > 0) then
        begin
          RowSltd := True;
          ShowLineError(LastProjectBuild, Msg);
        end;
      Item := ListViewMsg.Items.Add;
      Item.ImageIndex := Msg.Icon;
      Item.Caption := ExtractFileName(ConvertSlashes(Msg.FileName));
      Item.SubItems.Add(Msg.GetPosXY);
      Item.SubItems.Add(Msg.Msg);
      Item.Data := Msg;
    end;
    Caption := capt;
    LauncherFinished(Sender);
  end;
  CompMessages.Free;
end;

procedure TFrmFalconMain.ShowLineError(Project: TProjectFile; Msg: TMessageItem);

  procedure GotoAndExit;
  var
    FileProp: TSourceFile;
    Sheet: TSourceFileSheet;
  begin
    if SearchAndOpenFile(Msg.FileName, fileprop) then
    begin
      Sheet := FileProp.Edit;
      GotoLineAndAlignCenter(Sheet.Memo, Msg.Line, Msg.Col, Msg.EndCol, True);
    end;
    Exit;
  end;

var
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
  SLine, Temp, MMsg: string;
  Line, ColS, ColE, Col: Integer;
begin
  Line := 0;
  Col := 0;
  MMsg := '';
  if Assigned(Msg) then
  begin
    if Msg.MsgType <> mitCompiler then
      GotoAndExit;
  end;
  if not Assigned(Project) then
    Exit;

  Temp := ExtractFilePath(Project.FileName);
  if Assigned(Msg) then
  begin
    Line := Msg.Line;
    Col := Msg.Col;
    MMsg := Msg.Msg;
    if Pos('${COMPILER_PATH}', Msg.FileName) > 0 then
      Temp := StringReplace(Msg.FileName, '${COMPILER_PATH}',
        FrmFalconMain.Config.Compiler.Path, [])
    else
      Temp := Temp + Msg.FileName;
    Temp := ExpandFileName(Temp);
  end;
  if SearchSourceFile(Temp, FileProp) then
  begin
  end
  else if FileExists(Temp) then
  begin
    FileProp := OpenFile(Temp);
    FileProp.ReadOnly := True;
  end
  else
    Exit;

  if (Pos(MAKEFILE_MSG[2], MMsg) > 0) then
  begin
    FileProp.Node.Owner.Owner.SetFocus;
    FileProp.Node.Selected := True;
    FileProp.Node.Focused := True;
    Exit;
  end;
  FileProp.Edit;
  if FileProp.GetSheet(Sheet) then
  begin
    if Line > 0 then
    begin
      Sheet.Memo.UncollapseLine(Line);
      Sheet.Memo.GotoLineAndCenter(Line);
      SLine := Sheet.Memo.Lines.Strings[Line - 1];
      Temp := StringBetween(MMsg, #39, #39, False);
      if (Length(Temp) > 0) then
      begin
        // TODO: commented
//        Sheet.memo.SearchEngine := EditorSearch;
//        Sheet.memo.SearchEngine.Pattern := Temp;
//        Sheet.memo.SearchEngine.Options := [ssoMatchCase, ssoWholeWord];
//        Sheet.memo.SearchEngine.FindAll(SLine);
//        if Sheet.memo.SearchEngine.ResultCount >= 1 then
//        begin
//          ColS := Sheet.memo.SearchEngine.Results[0];
//          ColE := ColS + Sheet.memo.SearchEngine.Lengths[0];
//          GotoLineAndAlignCenter(Sheet.Memo, Line, ColS, ColE, True);
//        end;
      end;
      if Col > 0 then
        GotoLineAndAlignCenter(Sheet.Memo, Line, Col);
      ActiveErrorLine := Line;
      Sheet.Memo.InvalidateLine(ActiveErrorLine);
    end;
  end;
end;

procedure TFrmFalconMain.ListViewMsgDblClick(Sender: TObject);
var
  Item: TListItem;
  MPos: TPoint;
  Msg: TMessageItem;
begin
  GetCursorPos(MPos);
  MPos := ListViewMsg.ScreenToClient(MPos);
  Item := ListViewMsg.GetItemAt(MPos.X, MPos.Y);
  if Assigned(Item) then
  begin
    if Assigned(Item.Data) then
      Msg := TMessageItem(Item.Data)
    else
      Msg := nil;
    ShowLineError(LastProjectBuild, Msg);
  end;
end;

procedure TFrmFalconMain.AddFilesToProject(Files: TStrings; Parent: TSourceFile;
  References: Boolean; ImportMode: Boolean);
var
  NewFile, OwnerFile: TSourceFile;
  I: Integer;
  SrcDir, FolderName, ParentPath: string;
begin
  while True do
  begin
    if Parent.FileType = FILE_TYPE_PROJECT then
    begin
      ParentPath := ExtractFilePath(Parent.FileName);
      Break;
    end
    else if Parent.FileType = FILE_TYPE_FOLDER then
    begin
      Parent.Save;
      ParentPath := Parent.FileName;
      Break;
    end
    else if (Parent.Node.Parent <> nil) then
      Parent := TSourceFile(Parent.Node.Parent.Data)
    else
    begin
      Files.Clear;
      Exit;
    end;
  end;
  
  for I := Files.Count - 1 downto 0 do
  begin
    OwnerFile := Parent;
    if References then
    begin
      SrcDir := ExtractRelativePath(ParentPath, ExtractFilePath(Files.Strings[I]));
      SrcDir := ExcludeTrailingPathDelimiter(SrcDir);
      //create tree folder
      while SrcDir <> '' do
      begin
        FolderName := ExtractRootPathName(SrcDir);
        if not OwnerFile.FindFile(FolderName, OwnerFile) then
        begin
          OwnerFile := CreateSourceFolder(FolderName, OwnerFile);
          OwnerFile.IsNew := False;
          OwnerFile.Saved := True;
        end;
        SrcDir := ExcludeRootPathName(SrcDir);
      end;
    end;
    if OwnerFile.FindFile(ExtractFileName(Files.Strings[I]), NewFile) then
    begin
      Files.Delete(I);
      Continue;
    end;
    NewFile := NewSourceFile(GetFileType(Files.Strings[I]),
      COMPILER_C,
      ExtractFileName(Files.Strings[I]),
      ExtractName(Files.Strings[I]),
      ExtractFileExt(Files.Strings[I]),
      Files.Strings[I],
      OwnerFile,
      True,
      False);
    if not ImportMode then
    begin
      NewFile.Project.PropertyChanged := True;
      NewFile.Project.CompilePropertyChanged := True;
    end;
    if not References then
    begin
      NewFile.Edit.Memo.LockFoldUpdate;
      NewFile.Edit.Memo.Lines.LoadFromFile(Files.Strings[I]);
      NewFile.Edit.Memo.UnlockFoldUpdate;
    end
    else
    begin
      NewFile.DateOfFile := FileDateTime(NewFile.FileName);
      NewFile.IsNew := False;
      NewFile.Saved := True;
    end;
    Files.Strings[I] := NewFile.FileName;
    Files.Objects[I] := NewFile;
  end;
  if Files.Count > 0 then
    FLastPathInclude := '';
end;

procedure TFrmFalconMain.ProjectAddClick(Sender: TObject);
var
  FileProp: TSourceFile;
  References: Boolean;
  List: TStrings;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := STR_FRM_MAIN[12] + ' |*.c; *.cpp; *.cc; *.cxx; *.c++; *.cp; *.h;' +
      ' *.hpp; *.rh; *.hh; *.rc|' + STR_NEW_MENU[2] +
      ' (*.c)|*.c|' + STR_NEW_MENU[3] +
      ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp|'
      + STR_NEW_MENU[4] + ' (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh|' +
      STR_NEW_MENU[5] + ' (*.rc)|*.rc';
    FilterIndex := 1;
    Options := Options + [ofAllowMultiSelect, ofFileMustExist, ofPathMustExist, ofNoChangeDir];
    if GetSelectedFileInList(FileProp) then
    begin
      if (FileProp.FileType <> FILE_TYPE_FOLDER) then
        InitialDir := ExtractFilePath(FileProp.FileName)
      else
        InitialDir := FileProp.FileName;
    end;
    if Execute then
    begin
      List := TStringList.Create;
      References := True;
      if Pos(LowerCase(InitialDir), LowerCase(Files.Strings[0])) <> 1 then
      begin
        if InternalMessageBox('Copy files to project?', 'Falcon C++',
          MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = IDYES then
        begin
          References := False;
        end;
      end;
      List.AddStrings(Files);
      AddFilesToProject(List, FileProp, References);
      if TreeViewProjects.SelectionCount > 0 then
        TreeViewProjectsChange(TreeViewProjects, TreeViewProjects.Selected);
      ParseFiles(List);
      List.Free;
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ProjectRemoveClick(Sender: TObject);
var
  Proj: TProjectFile;
begin
  if GetActiveProject(Proj) then
  begin
    if not Assigned(FrmRemove) then
      FrmRemove := TFrmRemove.CreateParented(Handle);
    FrmRemove.SetProject(Proj);
    FrmRemove.ShowModal;
    FrmRemove.Free;
    FrmRemove := nil;
  end;
end;

procedure TFrmFalconMain.UpdateLangNow;
var
  I: Integer;
  Item: TTBCustomItem;
begin
  //Top Menu
  //Item := MenuBar.Items.Items[0];
  for I := 0 to MenuBar.Items.Count - 1 do
    MenuBar.Items.Items[I].Caption := STR_MENUS[I + 1];

  //File Menu
  Item := MenuFile;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_FILE[I + 1];

  //Edit Menu
  Item := MenuEdit;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_EDIT[I + 1];

  //Search Menu
  Item := MenuSearch;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_SERH[I + 1];

  //Search Menu
  Item := MenuView;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_VIEW[I + 1];

  //Project Menu
  Item := MenuProject;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_PROJ[I + 1];

  //Run Menu
  Item := MenuRun;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_RUN[I + 1];

  //Tools Menu
  Item := MenuTools;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_TOOL[I + 1];

  //Help Menu
  Item := MenuHelp;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_HELP[I + 1];

  //New From File Menu
  Item := FileNew;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_NEW_MENU[I + 1];

  //Import From File Menu
  Item := FileImport;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_IMPORT_MENU[I + 1];

  //Toolbars From View Menu
  Item := ViewToolbar;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_VIEWTOOLBAR_MENU[I + 1];

  //(Empty) From File Menu Reopen
  if FileReopen.Count > 2 then
    FileReopenClear.Caption := STR_FRM_MAIN[32]
  else
    FileReopenClear.Caption := STR_FRM_MAIN[31];

  //PopupMenu from Project List
  //Item := PopupProject.Items.Items;
  for I := 0 to PopupProject.Items.Count - 1 do
    PopupProject.Items.Items[I].Caption := STR_POPUP_PROJ[I + 1];

  //PopupMenu from Editor
  //Item := PopupEditor.Items;
  for I := 0 to PopupEditor.Items.Count - 1 do
    PopupEditor.Items.Items[I].Caption := STR_POPUP_EDITOR[I + 1];

  //PopupMenu from Tabs
  //Item := PopupTabs.Items;
  for I := 0 to PopupTabs.Items.Count - 1 do
    PopupTabs.Items.Items[I].Caption := STR_POPUP_TABS[I + 1];

  //PopupMenu from Messages
  //Item := PopupMsg.Items;
  for I := 0 to PopupMsg.Items.Count - 1 do
    PopupMsg.Items.Items[I].Caption := STR_POPUP_MSGS[I + 1];

  //tabs left
  TSProjects.Caption := STR_FRM_MAIN[1];
  //TSExplorer.Caption := STR_FRM_MAIN[2];

  //tabs right
  TSOutline.Caption := STR_FRM_MAIN[3];

  //tabs down
  TSMessages.Caption := STR_FRM_MAIN[4];

  //tabs left
  ListViewMsg.Column[0].Caption := STR_FRM_MAIN[6];
  ListViewMsg.Column[1].Caption := STR_FRM_MAIN[7];
  ListViewMsg.Column[2].Caption := STR_FRM_MAIN[8];

  //Toolbars
  //DefaultBar
  DefaultBar.Caption := STR_VIEWTOOLBAR_MENU[1];
  for I := 0 to DefaultBar.Items.Count - 1 do
  begin
    DefaultBar.Items.Items[I].Caption := STR_DEFAULTBAR[I + 1];
    DefaultBar.Items.Items[I].Hint := STR_DEFAULTBAR[I + 1];
  end;

  //EditBar
  EditBar.Caption := STR_VIEWTOOLBAR_MENU[2];
  for I := 0 to EditBar.Items.Count - 1 do
  begin
    EditBar.Items.Items[I].Caption := STR_EDITBAR[I + 1];
    EditBar.Items.Items[I].Hint := STR_EDITBAR[I + 1];
  end;

  //SearchBar
  SearchBar.Caption := STR_VIEWTOOLBAR_MENU[3];
  for I := 0 to SearchBar.Items.Count - 1 do
  begin
    SearchBar.Items.Items[I].Caption := STR_SEARCHBAR[I + 1];
    SearchBar.Items.Items[I].Hint := STR_SEARCHBAR[I + 1];
  end;

  //CompilerBar
  CompilerBar.Caption := STR_VIEWTOOLBAR_MENU[4];
  for I := 0 to CompilerBar.Items.Count - 1 do
  begin
    CompilerBar.Items.Items[I].Caption := STR_COMPILERBAR[I + 1];
    CompilerBar.Items.Items[I].Hint := STR_COMPILERBAR[I + 1];
  end;

  //NavigatorBar
  NavigatorBar.Caption := STR_VIEWTOOLBAR_MENU[5];
  for I := 0 to NavigatorBar.Items.Count - 1 do
  begin
    NavigatorBar.Items.Items[I].Caption := STR_NAVIGATORBAR[I + 1];
    NavigatorBar.Items.Items[I].Hint := STR_NAVIGATORBAR[I + 1];
  end;

  //ProjectBar
  ProjectBar.Caption := STR_VIEWTOOLBAR_MENU[6];
  for I := 0 to ProjectBar.Items.Count - 1 do
  begin
    ProjectBar.Items.Items[I].Caption := STR_PROJECTBAR[I + 1];
    ProjectBar.Items.Items[I].Hint := STR_PROJECTBAR[I + 1];
  end;

  //HelpBar
  HelpBar.Caption := STR_VIEWTOOLBAR_MENU[7];
  for I := 0 to HelpBar.Items.Count - 1 do
  begin
    HelpBar.Items.Items[I].Caption := STR_HELPBAR[I + 1];
    HelpBar.Items.Items[I].Hint := STR_HELPBAR[I + 1];
  end;

  //DebugBar
  DebugBar.Caption := STR_VIEWTOOLBAR_MENU[8];
  for I := 0 to DebugBar.Items.Count - 1 do
  begin
    DebugBar.Items.Items[I].Caption := STR_DEBUGBAR[I + 1];
    DebugBar.Items.Items[I].Hint := STR_DEBUGBAR[I + 1];
  end;
end;

procedure TFrmFalconMain.SubMUpdateClick(Sender: TObject);
begin
  TimerStartUpdate.Enabled := False;
  XMLOpened := True;
  if Assigned(FrmUpdate) then
    FrmUpdate.Close;
  ShellExecute(Handle, 'open', PChar(AppRoot + 'Updater.exe'), '',
    PChar(AppRoot), SW_SHOW)
end;

procedure TFrmFalconMain.Copiar1Click(Sender: TObject);
var
  msg: TMessageItem;
  S: string;
  I, C: Integer;
begin
  if ListViewMsg.SelCount > 0 then
  begin
    Clipboard.Clear;
    S := '';
    C := 0;
    for I := 0 to ListViewMsg.Items.Count - 1 do
    begin
      if not ListViewMsg.Items.Item[I].Selected then
        Continue;
      msg := TMessageItem(ListViewMsg.Items.Item[I].Data);
      if C = 0 then
        S := msg.Msg
      else
        S := S + #13#10 + msg.Msg;
      Inc(C);
    end;
    Clipboard.AsText := S;
  end;
end;

procedure TFrmFalconMain.ListViewMsgDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    TMessageItem(Item.Data).Free;
end;

procedure TFrmFalconMain.Originalmessage1Click(Sender: TObject);
var
  msg: TMessageItem;
  S, tmp: string;
  I, C: Integer;
begin
  if ListViewMsg.SelCount > 0 then
  begin
    S := '';
    C := 0;
    for I := 0 to ListViewMsg.Items.Count - 1 do
    begin
      if not ListViewMsg.Items.Item[I].Selected then
        Continue;
      msg := TMessageItem(ListViewMsg.Items.Item[I].Data);
      tmp := msg.OriMsg;
      if Pos('${COMPILER_PATH}', Msg.OriMsg) > 0 then
        tmp := StringReplace(msg.OriMsg, '${COMPILER_PATH}',
          FrmFalconMain.Config.Compiler.Path, []);
      if C = 0 then
        S := tmp
      else
        S := S + #13#10 + tmp;
      Inc(C);
    end;
    InternalMessageBox(PChar(S), 'Falcon C++', MB_OK);
  end;
end;

procedure TFrmFalconMain.ListViewMsgSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  PopupMsg.Items.Items[0].Enabled := Selected;
  PopupMsg.Items.Items[1].Enabled := Selected;
  PopupMsg.Items.Items[3].Enabled := Selected;
  PopupMsg.Items.Items[5].Enabled := Selected;
end;

procedure TFrmFalconMain.Copyoriginalmessage1Click(Sender: TObject);
var
  msg: TMessageItem;
  S, tmp: string;
  I, C: Integer;
begin
  if ListViewMsg.SelCount > 0 then
  begin
    Clipboard.Clear;
    S := '';
    C := 0;
    for I := 0 to ListViewMsg.Items.Count - 1 do
    begin
      if not ListViewMsg.Items.Item[I].Selected then
        Continue;
      msg := TMessageItem(ListViewMsg.Items.Item[I].Data);
      tmp := msg.OriMsg;
      if Pos('${COMPILER_PATH}', Msg.OriMsg) > 0 then
        tmp := StringReplace(msg.OriMsg, '${COMPILER_PATH}',
          FrmFalconMain.Config.Compiler.Path, []);
      if C = 0 then
        S := tmp
      else
        S := S + #13#10 + tmp;
      Inc(C);
    end;
    Clipboard.AsText := S;
  end;
end;

procedure TFrmFalconMain.FileSaveAllClick(Sender: TObject);
var
  ProjProp: TProjectFile;
  Sibling: TTreeNode;
begin
  Sibling := TreeViewProjects.Items.GetFirstNode;
  while Sibling <> nil do
  begin
    ProjProp := TProjectFile(Sibling.Data);
    if not ProjProp.Saved or ProjProp.IsNew then
      SaveProject(ProjProp, smSave)
    else
    begin
      ProjProp.SaveAll;
      ProjProp.Save;
    end;
    Sibling := Sibling.getPrevSibling;
  end;
end;

procedure TFrmFalconMain.FileSaveAsClick(Sender: TObject);
var
  FileProp: TSourceFile;
  ProjProp: TProjectFile;
begin
  if GetActiveFile(FileProp) then
  begin
    ProjProp := FileProp.Project;
    if SaveProject(ProjProp, smSaveAs) then
      UpdateStatusbar;
  end;
end;

function TFrmFalconMain.DetectScope(Memo: TEditor;
  TokenFile: TTokenFile; ShowInTreeview: Boolean): TTokenClass;
var
  Token: TTokenClass;
  Node, Parent: PNativeNode;
  SelStart: Integer;
  BC: TBufferCoord;
begin
  Result := nil;
  BC := Memo.CaretXY;
  if BC.Line > 0 then
  begin
    if BC.Char > (Length(Memo.Lines[BC.Line - 1]) + 1) then
      BC.Char := Length(Memo.Lines[BC.Line - 1]) + 1;
  end;
  if ShowInTreeview and DebugReader.Running then
    Exit;
  SelStart := Memo.RowColToCharIndex(BC);
  if TokenFile.GetTokenAt(Token, SelStart, BC.Line) then
  begin
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkParams, tkFunction, tkPrototype,
      tkConstructor, tkOperator]) then
    begin
      Token := Token.Parent;
      if (Token.Token = tkParams) and Assigned(Token.Parent) then
        Token := Token.Parent;
    end;
    Result := Token;
    if not ShowInTreeview then
      Exit;
    Node := PNativeNode(Token.Data);
    //unknow bug
    if not Assigned(Node) or (TreeViewOutline.GetFirst = nil) then
      Exit;
    TreeViewOutline.BeginUpdate;
    TreeViewOutline.Selected[Node] := True;
    Parent := Node;
    while Parent <> nil do
    begin
      TreeViewOutline.Expanded[Parent] := True;
      Parent := TreeViewOutline.NodeParent[Parent];
    end;
    TreeViewOutline.ScrollIntoView(Node, True);
    TreeViewOutline.EndUpdate;
  end
  else if TokenFile.GetScopeAt(Token, SelStart) then
  begin
    Result := Token;
    if not ShowInTreeview then
      Exit;
    Node := PNativeNode(Token.Data);
    //unknow bug
    if not Assigned(Node) or (TreeViewOutline.GetFirst = nil) then
      Exit;
    TreeViewOutline.BeginUpdate;
    TreeViewOutline.Selected[Node] := True;
    Parent := Node;
    while Parent <> nil do
    begin
      TreeViewOutline.Expanded[Parent] := True;
      Parent := TreeViewOutline.NodeParent[Parent];
    end;
    TreeViewOutline.ScrollIntoView(Node, True);
    TreeViewOutline.EndUpdate;
  end;
end;

//onparser last active file

procedure TFrmFalconMain.TextEditorFileParsed(EditFile: TSourceFile;
  TokenFile: TTokenFile);
var
  IncludeFileName, IncludeName: string;
  I, J: Integer;
  FileList, ParseList, IncludeList: TStrings;
  Project: TProjectFile;
  IncludeFile: TSourceFile;
  FileExistsFlag, CompilerHeaderFile: Boolean;
begin
  if TokenFile.Includes.Count = 0 then
    Exit;
  FileList := TStringList.Create;
  ParseList := TStringList.Create;
  IncludeList := TStringList.Create;
  Project := nil;
  if (EditFile <> nil) then
    Project := EditFile.Project;
  if (Project <> nil) then
    GetIncludeDirs(ExtractFilePath(Project.FileName), Project.Flags, IncludeList, True);
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    FileExistsFlag := False;
    IncludeName := ConvertSlashes(TokenFile.Includes.Items[I].Name);
    // search include file on same directory
    if TokenFile.Includes.Items[I].Flag = 'L' then
    begin
      IncludeFileName := ExtractFilePath(TokenFile.FileName) + IncludeName;
      if FileExists(IncludeFileName) then
        FileExistsFlag := True;
    end;
    if not FileExistsFlag then
    begin
      // search include file on project flags include directories
      for J := 0 to IncludeList.Count - 1 do
      begin
        IncludeFileName := IncludeList.Strings[J] + IncludeName;
        if FileExists(IncludeFileName) then
        begin
          FileExistsFlag := True;
          Break;
        end;
      end;
    end;
    CompilerHeaderFile := False;
    if not FileExistsFlag then
    begin
      // search include file on compiler include path
      for J := 0 to FilesParsed.PathList.Count - 1 do
      begin
        IncludeFileName := FilesParsed.PathList.Strings[J] + IncludeName;
        if FileExists(IncludeFileName) then
        begin
          FileExistsFlag := True;
          CompilerHeaderFile := True;
          Break;
        end;
      end;
    end;
    if not FileExistsFlag then
      Continue;
    IncludeFileName := ExpandFileName(IncludeFileName);
    // don't parse compiler header file
    if not CompilerHeaderFile then
    begin
      //if CompareText(IncludeFileName, Config.Compiler.Path + '\include\' + IncludeName) = 0 then
      //  raise Exception.Create('Cannot load compiler header file');
      // check if file is an project
      if (Project <> nil) then
      begin
        IncludeFile := Project.GetFileByPathName(
          ExtractRelativePath(ExtractFilePath(Project.FileName), IncludeFileName));
      end
      else
        IncludeFile := nil;
      if IncludeFile = nil then
      begin
        if (FilesParsed.ItemOfByFileName(IncludeFileName) = nil) then
          ParseList.AddObject(IncludeFileName, nil);
      end;
      Continue;
    end;
    FileList.Add(IncludeFileName);
  end;
  ThreadLoadTkFiles.LoadRecursive(FileList, Config.Compiler.Path +
    '\include\', ConfigRoot + 'include\', '.prs');
  ParseFiles(ParseList);
  IncludeList.Free;
  ParseList.Free;
  FileList.Free;
end;

//event on change text in editor

procedure TFrmFalconMain.EncodingItemClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.SourceFile.Encoding := TComponent(Sender).Tag;
  UpdateStatusbar;
end;

procedure TFrmFalconMain.LineEndingItemClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.SourceFile.LineEnding := TComponent(Sender).Tag;
  UpdateStatusbar;
end;

procedure TFrmFalconMain.TextEditorChange(Sender: TObject);
var
  Memo: TEditor;
  Sheet: TSourceFileSheet;
  FilePrp: TSourceFile;
begin
  if (Sender is TEditor) then
  begin
    Memo := TEditor(Sender);
    UpdateMenuItems([rmFile, rmEdit, rmSearch, rmRun]); {rmRun for Breakpoint}
    Sheet := TSourceFileSheet(Memo.Owner);
    FilePrp := Sheet.SourceFile;
    if FilePrp.Modified then
      Sheet.Caption := '*' + FilePrp.Name
    else
      Sheet.Caption := FilePrp.Name;
    CanShowHintTip := False;
    TimerHintTipEvent.Enabled := False;
    HintTip.Cancel;
    DebugHint.Cancel;
    ActiveEditingFile.FileName := FilePrp.FileName;
    ActiveEditingFile.Data := FilePrp;
//    Memo.InvalidateGutterLines(Memo.CaretY - 1, Memo.CaretY + 1);
    if CurrentFileIsParsed then
      CurrentFileIsParsed := False
    else
    begin
      //ignore on loading
      if not IsLoading then
      begin
        if Sheet.Selected then
        begin
          if not CodeCompletion.Executing then
          begin
            TimerChangeDelay.Enabled := False;
            TimerChangeDelay.Enabled := True;
          end
          else
            ReloadAfterCodeCompletion := True;
        end
        else
        begin
          FilesParsed.Delete(FilePrp.FileName);
          ParseFile('-', FilePrp);
        end;
      end;
    end;
  end;
end;

//other event of change of code editor

procedure TFrmFalconMain.TextEditorStatusChange(Sender: TObject;
  AUpdated: Integer);
var
  LastActiveErrorLine: Integer;
begin
  if AUpdated > 2 then
    Exit;
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  HintTip.Cancel;
  DebugHint.Cancel;
  if (Sender is TEditor) then
  begin
    UpdateMenuItems([rmEdit]);
    DetectScope(Sender as TEditor, ActiveEditingFile, True);
    if ActiveErrorLine > 0 then
    begin
      LastActiveErrorLine := ActiveErrorLine;
      ActiveErrorLine := 0;
      (Sender as TEditor).InvalidateLine(LastActiveErrorLine);
    end;
  end;
  if HintParams.Activated and ((AUpdated and SC_UPDATE_SELECTION) = SC_UPDATE_SELECTION)
    and (Sender is TEditor) then
  begin
    TimerHintParams.Enabled := False;
    TimerHintParams.Enabled := True;
  end;
  TextEditorUpdateStatusBar(Sender);
end;

procedure TFrmFalconMain.TextEditorUpdateStatusBar(Sender: TObject);
var
  W: Integer;
begin
  if (Sender is TEditor) then
  begin
    StatusBar.Panels.Items[1].Caption := Format('Ln : %d    Col : %d    Sel : %d',
      [(Sender as TEditor).DisplayY,
       (Sender as TEditor).DisplayX, (Sender as TEditor).SelLength]);
    W := Canvas.TextWidth(StatusBar.Panels.Items[1].Caption) + 20;
    StatusBar.Panels.Items[1].Size := Max(W, 170);
  end;
end;

// on enter in code editor

procedure TFrmFalconMain.TextEditorEnter(Sender: TObject);
var
  ProjProp: TProjectFile;
  FileProp: TSourceFile;
  I, X, Y: Integer;
begin
  CheckIfFilesHasChanged;
  UpdateMenuItems([rmFile, rmEdit, rmSearch]);
  if GetActiveFile(FileProp) then
    UpdateStatusbar;
  if GetActiveProject(ProjProp) then
  begin
    if (Sender is TEditor) then
    begin
      TextEditorUpdateStatusBar(Sender);
      for I := 1 to 9 do
        if TEditor(Sender).GetBookMark(I, X, Y) then
        begin
          TTBXItem(EditBookmarks.Items[I - 1]).Checked := True;
          TTBXItem(EditGotoBookmarks.Items[I - 1]).Checked := True;
          TTBXItem(EditGotoBookmarks.Items[I - 1]).Enabled := True;
        end
        else
        begin
          TTBXItem(EditBookmarks.Items[I - 1]).Checked := False;
          TTBXItem(EditGotoBookmarks.Items[I - 1]).Checked := False;
          TTBXItem(EditGotoBookmarks.Items[I - 1]).Enabled := False;
        end;
    end;
  end;
end;

//on exit of code editor

procedure TFrmFalconMain.TextEditorExit(Sender: TObject);
begin
  CheckIfFilesHasChanged;
  UpdateMenuItems([rmEdit, rmSearch]);
  HintParams.Cancel;
end;

procedure TFrmFalconMain.TextEditorMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sheet: TSourceFileSheet;
  FileProp: TSourceFile;
  R: TRect;
  pt: TPoint;
begin
  if not PointsEqual(LastMousePos, Point(X, Y)) and IsForeground(Handle) then
  begin
    LastMousePos := Point(X, Y);
    if DebugHint.Clickable then
    begin
      R := DebugHint.BoundsRect;
      Dec(R.Top, 6);
      pt := TControl(Sender).ClientToScreen(LastMousePos);
      if PtInRect(R, pt) then
        Exit;
    end;
    if not HintParams.Activated and CanShowHintTip then
    begin
      if not GetActiveSheet(sheet) then
        Exit;
      TimerHintTipEvent.Enabled := False;
      if not GetActiveFile(FileProp) then
        Exit;
      ProcessHintView(FileProp, sheet.Memo, X, Y);
    end
    else if not HintParams.Activated then
    begin
      CanShowHintTip := False;
      TimerHintTipEvent.Enabled := True;
    end;
  end;
end;

//link click in edit

procedure TFrmFalconMain.TextEditorLinkClick(Sender: TObject;
  AModifiers: Integer; APosition: Integer);
var
  FileName, Fields, Input: string;
  Prop: TSourceFile;
  Proj: TProjectFile;
  sheet: TSourceFileSheet;
  IncludeList: TStrings;
  I: Integer;
  TokenFileItem: TTokenFile;
  Token: TTokenClass;
  SelStart: Integer;
  InputError: Boolean;
  WS: TBufferCoord;
  StyleID: Integer;
  Style: THighlighStyle;
  S: string;
  IncludeToken: TTokenClass;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  StyleID := sheet.Memo.GetStyleAt(APosition);
  Style := sheet.Memo.Highlighter.FindStyleByID(StyleID);
  S := sheet.Memo.GetLine(sheet.Memo.LineFromPosition(APosition));
  //#include <stdio.h>
  if (Style <> nil) and (Style.Name = HL_Style_Preprocessor)
    and (Pos('#', S) < Pos('include', S))  and (Pos('#', S) > 0) then
  begin
    if ActiveEditingFile.GetTokenAt(IncludeToken, APosition) then
    begin
      if IncludeToken.Token = tkInclude then
        S := IncludeToken.Name;
    end;
    S := ConvertSlashes(S);
    //search #include <stdio.h> in project
    Prop := Sheet.SourceFile;
    Proj := Prop.Project;
    if Proj.FileType = FILE_TYPE_PROJECT then
    begin
      Prop := Proj.GetFileByPathName(S);
      if Prop <> nil then
      begin
        Prop.Edit;
        Exit;
      end;
      IncludeList := TStringList.Create;
      GetIncludeDirs(ExtractFilePath(Proj.FileName), Proj.Flags, IncludeList);
      for I := 0 to IncludeList.Count - 1 do
      begin
        Prop := Proj.GetFileByPathName(ExtractRelativePath(ExtractFilePath(Proj.FileName),
          ExpandFileName(IncludeList.Strings[I] + S)));
        if Prop <> nil then
        begin
          Prop.Edit;
          IncludeList.Free;
          Exit;
        end;
      end;
      IncludeList.Free;
      Prop := Sheet.SourceFile;
    end;
    // not found in project, search file on source file folder
    FileName := ExpandFileName(ExtractFilePath(Prop.FileName) + S);
    if SearchSourceFile(FileName, Prop) then
    begin
      Prop.Edit;
      Exit;
    end;
    if FileExists(FileName) then
    begin
      Prop := OpenFile(FileName);
      Prop.ReadOnly := True;
      sheet := Prop.Edit;
      sheet.Memo.ReadOnly := True;
      sheet.Font.Color := clGrayText;
      Exit;
    end;
    //search in compiler folder
    for I := 0 to FilesParsed.PathList.Count - 1 do
    begin
      FileName := ExpandFileName(FilesParsed.PathList.Strings[I] + S);
      if FileExists(FileName) then
      begin
        Prop := OpenFile(FileName);
        Prop.ReadOnly := True;
        sheet := Prop.Edit;
        sheet.Memo.ReadOnly := True;
        sheet.Font.Color := clGrayText;
        Exit;
      end;
    end;
    IncludeList := TStringList.Create;
    GetIncludeDirs(ExtractFilePath(Proj.FileName), Proj.Flags, IncludeList);
    for I := 0 to IncludeList.Count - 1 do
    begin
      FileName := ExpandFileName(IncludeList.Strings[I] + S);
      if FileExists(FileName) then
      begin
        Prop := OpenFile(FileName);
        Prop.ReadOnly := True;
        sheet := Prop.Edit;
        sheet.Memo.ReadOnly := True;
        sheet.Font.Color := clGrayText;
        IncludeList.Free;
        Exit;
      end;
    end;
    IncludeList.Free;
    InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [S])), 'Falcon C++',
      MB_ICONEXCLAMATION);
  end
  else
  begin
    SelStart := sheet.Memo.WordStartPosition(APosition, True);
    if not ParseFields(sheet.Memo.Lines.Text, SelStart, Input, Fields, InputError) then
      Exit;
    // find declaration
    if not FilesParsed.FindDeclaration(Input, Fields, ActiveEditingFile, TokenFileItem,
      Token, SelStart, WS.Line) then
      Exit;
    if TokenFileItem = ActiveEditingFile then //current file
    begin
      SelectToken(Token);
      Exit;
    end;
    //other file
    //is in project list
    if SearchSourceFile(TokenFileItem.FileName, Prop) then
      Prop.Edit
    else //non opened. open
    begin
      Prop := TSourceFile(OpenFile(TokenFileItem.FileName));
      Prop.ReadOnly := True;
      sheet := Prop.Edit;
      sheet.Memo.ReadOnly := True;
      sheet.Font.Color := clGrayText;
    end;
    SelectToken(Token);
  end;
end;

procedure TFrmFalconMain.TextEditorMouseLeave(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  HintTip.Cancel;
  if DebugHint.Clickable and DebugHint.WindowMode then
    DebugHint.Cancel;
end;

procedure TFrmFalconMain.TextEditorCharAdded(Sender: TObject; Ch: Integer);
var
  sheet: TSourceFileSheet;
  emptyLine, replaceLine: Boolean;
  str, LineStr, S: string;
  p: PChar;
  i, j, SpaceCount1, BracketBalacing: Integer;
  bStart, bEnd: TBufferCoord;
  prev_word: string;
  bCoord, posStyle: TBufferCoord;
  attri: THighlighStyle;
  token: UnicodeString;
  Key: Char;
begin
  Key := Char(Ch);
  if not GetActiveSheet(sheet) then
    Exit;
  LastKeyPressed := Key;
  bCoord := sheet.Memo.CaretXY;
  LineStr := sheet.Memo.LineText;
  if (bCoord.Char > 1) and (Length(LineStr) >= bCoord.Char - 1) and
    CharInSet(LineStr[bCoord.Char - 1], ['a'..'z', 'A'..'Z', '_']) then
    prev_word := GetLastWord(Copy(LineStr, 1, bCoord.Char))
  else
    prev_word := '';
  posStyle := BufferCoord(bCoord.Char - 1, bCoord.Line);
  if CharInSet(Key, ['"', '<', '}']) then
    sheet.Memo.Colourise(sheet.Memo.GetEndStyled, sheet.Memo.GetEndStyled + 1);
  if sheet.Memo.GetHighlighterAttriAtRowCol(posStyle, token, attri) then
  begin
    if CppHighligher.IsComment(attri) then
      Exit;
    I := CountChar(LineStr, '"');
    if CharInSet(Key, ['"', '<']) and (attri.Name = HL_Style_Preprocessor) and
      (Pos('include', LineStr) > 0) and not ((I >= 2) and
      (CountChar(Copy(LineStr, bCoord.Char, MaxInt), '"') = 0)) then
    begin
      if not CodeCompletion.Executing then
        CodeCompletion.ActivateCompletion(sheet.Memo);
      Exit;
    end;
  end;
  // auto code completion
  if CharInSet(Key, ['a'..'z', 'A'..'Z', '_']) and (Length(prev_word) >= 4) and
    not CodeCompletion.Executing and ((FEmptyLineResult <> bCoord.Line)
    or (FEmptyCharResult > bCoord.Char)) then
  begin
    CodeCompletion.ActivateCompletion(sheet.Memo);
    if not CodeCompletion.Executing then
    begin
      FEmptyLineResult := bCoord.Line;
      FEmptyCharResult := bCoord.Char;
    end
    else
    begin
      FEmptyLineResult := 0;
      FEmptyCharResult := 0;
    end;
    Exit;
  end
  else if not CharInSet(Key, ['a'..'z', 'A'..'Z', '_']) or not (Length(prev_word) > 4) then
  begin
    FEmptyLineResult := 0;
    FEmptyCharResult := 0;
  end;
  if Key = '}' then
    sheet.Memo.ProcessCloseBracketChar
  else if Key = #13 then
    sheet.Memo.ProcessBreakLine
  else if Key = '(' then
  begin
    if Config.Editor.AutoCloseBrackets and
      (sheet.Memo.GetBalancingBracketEx(sheet.Memo.CaretXY, '(') < 0) then
    begin
      sheet.Memo.InsertText(sheet.Memo.GetCurrentPos, ')');
    end;
    TimerHintParams.Enabled := False;
    TimerHintParams.Enabled := True;
  end
  else if Key = '[' then
  begin
    if not Config.Editor.AutoCloseBrackets then
      Exit;
    if sheet.Memo.GetBalancingBracketEx(sheet.Memo.CaretXY, '[') >= 0 then
      Exit;
    sheet.Memo.InsertText(sheet.Memo.GetCurrentPos, ']');
  end
  else if Key = '{' then
  begin
    emptyLine := False;
    LineStr := '';
    j := 0;
    if sheet.Memo.SelAvail then
    begin
      bStart := sheet.Memo.BlockBegin;
      bEnd := sheet.Memo.BlockEnd;
    end
    else
    begin
      bStart := sheet.Memo.CaretXY;
      bEnd := bStart;
    end;
    if sheet.Memo.Lines.Count >= bStart.Line then
    begin
      LineStr := sheet.Memo.Lines.Strings[bStart.Line - 1];
      LineStr := Copy(LineStr, 1, bStart.Char - 1);
      p := PChar(LineStr);
      if p^ <> #0 then
        repeat
          if not CharInSet(p^, [#9, #32]) then Break;
          if p^ = #9 then
            Inc(j, sheet.Memo.TabWidth)
          else
            Inc(j);
          Inc(p);
        until p^ = #0;
      emptyLine := Trim(LineStr) = '{';
    end;
    if emptyLine then
    begin
      replaceLine := False;
      SpaceCount1 := j;
      if sheet.Memo.Lines.Count >= bStart.Line - 1 then
      begin
        LineStr := sheet.Memo.Lines.Strings[bStart.Line - 2];
        p := PChar(LineStr);
        i := 0;
        if p^ <> #0 then
          repeat
            if not CharInSet(p^, [#9, #32]) then Break;
            if p^ = #9 then
              Inc(i, sheet.Memo.TabWidth)
            else
              Inc(i);
            Inc(p);
          until p^ = #0;
        replaceLine := j <> i;
        SpaceCount1 := i;
      end;
      S := GetLeftSpacing(SpaceCount1, sheet.Memo.TabWidth, sheet.Memo.WantTabs);
      bStart.Char := 1;
      if Config.Editor.AutoCloseBrackets then
      begin
        str := '';
        if replaceLine then
          str := S;
        str := str + '{' + #13 + S + GetLeftSpacing(sheet.Memo.TabWidth,
          sheet.Memo.TabWidth, sheet.Memo.WantTabs) + #13 + S + '}';
        sheet.Memo.BeginUpdate;
        if replaceLine then
          sheet.Memo.SetCaretAndSelection(bStart, bStart, bEnd);
        BracketBalacing := sheet.Memo.GetBalancingBracketEx(sheet.Memo.CaretXY, '{');
        if BracketBalacing <= 0 then
          sheet.Memo.SelText := str
        else
        begin
          I := Pos('{', str);
          sheet.Memo.SelText := Copy(str, 1, I);
        end;
        sheet.Memo.EndUpdate;
        Inc(bStart.Line);
        bStart.Char := Length(GetLeftSpacing(SpaceCount1 + sheet.Memo.TabWidth,
          sheet.Memo.TabWidth, sheet.Memo.WantTabs)) + 1;
        sheet.Memo.CaretXY := bStart;
      end
      else
      begin
        sheet.Memo.BeginUpdate;
        if replaceLine then
          sheet.Memo.SetCaretAndSelection(bStart, bStart, bEnd)
        else
          S := '';
        sheet.Memo.SelText := S + '{';
        sheet.Memo.EndUpdate;
      end;
    end
    else if Config.Editor.AutoCloseBrackets then
    begin
      BracketBalacing := sheet.Memo.GetBalancingBracketEx(sheet.Memo.CaretXY, '{');
      if BracketBalacing < 0 then
        sheet.Memo.InsertText(sheet.Memo.GetCurrentPos, '}');
    end;
    TimerHintParams.Enabled := False;
    TimerHintParams.Enabled := True;
  end;
end;  

procedure TFrmFalconMain.TextEditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Sheet: TSourceFileSheet;
begin                   
  CodeCompletion.EditorKeyDown(Sender, Key, Shift);
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  Sheet := TSourceFileSheet(TComponent(Sender).Owner);
  // Link click
  if ([ssCtrl] = Shift) and (Key = VK_CONTROL) then
    Sheet.Memo.SetLinkClick(True)
  else if ([ssCtrl] = Shift) and (Key = Ord('J')) then
  begin
    AutoComplete.Execute(Sheet.Memo);
  // show parameters hit
  end
  else if ([ssShift, ssCtrl] = Shift) and (Key = VK_SPACE) then
  begin
    ShowHintParams(Sheet.Memo);
  end
  // move code up
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_UP) then
    Sheet.Memo.MoveSelectionUp
  // move code down
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_DOWN) then
    Sheet.Memo.MoveSelectionDown
  // fold current
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_OEM_5) then  // ]
    Sheet.Memo.CollapseCurrent
  // unfold current
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_OEM_6) then  // [
    Sheet.Memo.UncollapseLine(Sheet.Memo.CaretY)
  // comment/uncomment
  else if ([ssCtrl] = Shift) and (Key = VK_DIVIDE) then
    EditToggleCommentClick(EditToggleComment)
  // restore zoom
  else if ([ssCtrl] = Shift) and ((Key = VK_NUMPAD0) or (Key = Ord('0'))) then
  begin
    ZoomEditor := 0;
    UpdateEditorZoom;
  end
  else if ([ssCtrl] = Shift) and (Key = VK_OEM_PLUS) then
    ViewZoomIncClick(ViewZoomInc)
  else if ([ssCtrl] = Shift) and (Key = VK_OEM_MINUS) then
    ViewZoomDecClick(ViewZoomDec)
  // show code completion
  else if ([ssCtrl] = Shift) and (Key = VK_SPACE) then
  begin
    UsingCtrlSpace := True;
    CodeCompletion.ActivateCompletion(sheet.Memo);
    UsingCtrlSpace := False;
  end
  else if (Key = VK_ESCAPE) then
  begin
    HintTip.Cancel;
    DebugHint.Cancel;
    //HintParams.Cancel; no cancel
  end;
end;

procedure TFrmFalconMain.TextEditorKeyPress(Sender: TObject;
  var Key: Char);
const
  Brackets: array[0..5] of WideChar = ('(', ')', '[', ']', '{', '}');
var
  sheet: TSourceFileSheet;
  LineStr: string;
  I: Integer;
  OpenChar: WideChar;
  Shift: TShiftState;
begin
  CodeCompletion.EditorKeyPress(Sender, Key);
  Shift := KeyboardStateToShiftState;
  if not GetActiveSheet(sheet) then
    Exit;
  if CharInSet(Key, [')', ']']) then
  begin
    OpenChar := #0;
    for I := 0 to 5 do
    begin
      if Brackets[I] = WideChar(Key) then
      begin
        OpenChar := Brackets[I - 1];
        Break;
      end;
    end;
    if sheet.Memo.Lines.Count >= sheet.Memo.CaretY then
    begin
      I := sheet.Memo.GetBalancingBracketEx(sheet.Memo.CaretXY, OpenChar);
      if I < 0 then
        Exit;
      LineStr := sheet.Memo.Lines.Strings[sheet.Memo.CaretY - 1];
      LineStr := Copy(LineStr, sheet.Memo.CaretX, Length(LineStr));
      if (LineStr <> '') and (LineStr[1] = Key) then
      begin
        Key := #0;
        sheet.Memo.CaretX := sheet.Memo.CaretX + 1;
      end;
    end;
  end
  else if ([ssCtrl] = Shift) and (Key = ' ') then
    Key := #0;
end;

procedure TFrmFalconMain.TextEditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Sheet: TSourceFileSheet;
begin
  Sheet := TSourceFileSheet(TComponent(Sender).Owner);
  if ([] = Shift) and (Key = VK_CONTROL) then
    Sheet.Memo.SetLinkClick(False);
end;

procedure TFrmFalconMain.TextEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  HintParams.Cancel;
  HintTip.Cancel;
  DebugHint.Cancel;
end;

procedure TFrmFalconMain.TextEditorScroll(Sender: TObject);
begin
  CodeCompletion.CancelCompletion;
  HintTip.Cancel;
  HintParams.Cancel;
end;


procedure TFrmFalconMain.TextEditorClick(Sender: TObject);
begin
  CodeCompletion.CancelCompletion;
end;

procedure TFrmFalconMain.TextLinesDeleted(Sender: TObject; Index,
  Count: integer);
var
  LineBegin, LineEnd: Integer;
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) or (sheet.SourceFile.Breakpoint.Count = 0) then
    Exit;
  LineBegin := Index + 1;
  LineEnd := Index + Count;
  sheet.SourceFile.Breakpoint.DeleteFrom(LineBegin, LineEnd);
end;

procedure TFrmFalconMain.TextLinesInserted(Sender: TObject; Index,
  Count: integer);
var
  LineBegin: Integer;
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) or (sheet.SourceFile.Breakpoint.Count = 0) then
    Exit;
  LineBegin := Index + 1;
  sheet.SourceFile.Breakpoint.MoveBy(LineBegin, Count);
end;

procedure TFrmFalconMain.TextEditorGutterClick(ASender: TObject;
  AModifiers: Integer; APosition: Integer; AMargin: Integer);
var
  sheet: TSourceFileSheet;
  S: string;
  Line: Integer;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Line := sheet.Memo.LineFromPosition(APosition) + 1;
  if (AMargin <> MARGIN_BREAKPOINT) and (AMargin <> MARGIN_LINE_NUMBER) then
    Exit;
  if (sheet.Memo.Lines.Count >= Line) and (Line > 0) then
  begin
    S := sheet.Memo.Lines.Strings[Line - 1];
    if not HasTODO(S) then
      ToggleBreakpoint(Line);
  end;
end;

procedure TFrmFalconMain.TextEditorSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  if ActiveErrorLine = Line then
  begin
    fg := clWindow;
    bg := clRed;
    Special := True;
    Exit;
  end;
end;

procedure TFrmFalconMain.TimerStartUpdateTimer(Sender: TObject);
begin
  TimerStartUpdate.Enabled := False;
  if not Config.Environment.CheckForUpdates then
    Exit;
  UpdateDownload.URL := FALCON_URL_UPDATE;
  if FileExists(GetTempDirectory + 'FalconUpdate.xml') then
    DeleteFile(GetTempDirectory + 'FalconUpdate.xml');
  UpdateDownload.FileName := GetTempDirectory + 'FalconUpdate.xml';
  UpdateDownload.Start;
end;

procedure TFrmFalconMain.UpdateDownloadFinish(Sender: TObject;
   State: TDownloadState; Canceled: Boolean);
begin
  if not Canceled and not XMLOpened and (State <> dsError) then
  begin
    XMLOpened := True;
    if CanUpdate(UpdateDownload.FileName) then
    begin
      if not Assigned(FrmUpdate) then
      begin
        FrmUpdate := TFrmUpdate.Create(Self);
        FrmUpdate.Load(UpdateDownload.FileName);
        FrmUpdate.Show;
      end
      else
        FrmUpdate.BringToFront;
    end
    else
    begin
      if FileExists(UpdateDownload.FileName) then
        DeleteFile(UpdateDownload.FileName);
    end;
  end;
  XMLOpened := False;
end;

procedure TFrmFalconMain.TreeViewProjectsAddition(Sender: TObject;
  Node: TTreeNode);
begin
  //
end;

procedure TFrmFalconMain.FormShow(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex > -1) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if not Sheet.Memo.Focused and Sheet.Memo.Visible then
      Sheet.Memo.SetFocus;
  end;
end;

procedure TFrmFalconMain.ViewRestoreDefClick(Sender: TObject);
begin
  ProjectPanel.Width := 230;
  PanelOutline.Width := 160;
  PageControlMessages.Height := 160;

  DefaultBar.Visible := True;
  ToolbarCheck(0, True);
  DefaultBar.CurrentDock := DockTop;
  DefaultBar.DockPos := 0;
  DefaultBar.DockRow := 1;

  EditBar.Visible := True;
  ToolbarCheck(1, True);
  EditBar.CurrentDock := DockTop;
  EditBar.DockPos := 143;
  EditBar.DockRow := 1;

  SearchBar.Visible := True;
  ToolbarCheck(2, True);
  SearchBar.CurrentDock := DockTop;
  SearchBar.DockPos := 179;
  SearchBar.DockRow := 1;

  CompilerBar.Visible := True;
  ToolbarCheck(3, True);
  CompilerBar.CurrentDock := DockTop;
  CompilerBar.DockPos := 179;
  CompilerBar.DockRow := 1;

  NavigatorBar.Visible := True;
  ToolbarCheck(4, True);
  NavigatorBar.CurrentDock := DockTop;
  NavigatorBar.DockPos := 179;
  NavigatorBar.DockRow := 1;

  ProjectBar.Visible := True;
  ToolbarCheck(5, True);
  ProjectBar.CurrentDock := DockTop;
  ProjectBar.DockPos := 395;
  ProjectBar.DockRow := 1;

  HelpBar.Visible := True;
  ToolbarCheck(6, True);
  HelpBar.CurrentDock := DockTop;
  HelpBar.DockPos := 447;
  HelpBar.DockRow := 1;

  DebugBar.Visible := True;
  ToolbarCheck(7, True);
  DebugBar.CurrentDock := DockTop;
  DebugBar.DockPos := 467;
  DebugBar.DockRow := 1;

  SelectTheme('OfficeXP');
  ZoomEditor := 0;
  UpdateEditorZoom;
end;

procedure TFrmFalconMain.ToolsEnvOptionsClick(Sender: TObject);
begin
  if not Assigned(FrmEnvOptions) then
    FrmEnvOptions := TFrmEnvOptions.CreateParented(Handle);
  FrmEnvOptions.Load;
  FrmEnvOptions.ShowModal;
end;

procedure TFrmFalconMain.ToolsCompilerOptionsClick(Sender: TObject);
begin
  if not Assigned(FrmCompOptions) then
    FrmCompOptions := TFrmCompOptions.CreateParented(Handle);
  FrmCompOptions.Load;
  FrmCompOptions.ShowModal;
end;

procedure TFrmFalconMain.ToolsEditorOptionsClick(Sender: TObject);
begin
  if not Assigned(FrmEditorOptions) then
    FrmEditorOptions := TFrmEditorOptions.CreateParented(Handle);
  FrmEditorOptions.Load;
  FrmEditorOptions.ShowModal;
end;

procedure TFrmFalconMain.ViewFullScreenClick(Sender: TObject);
begin
  FrmPos.SetFullScreen(not FrmPos.FullScreen);
  MenuBar.Visible := not FrmPos.FullScreen;
  if FrmPos.FullScreen and not Config.Environment.ShowToolbarsInFullscreen then
    DockTop.Hide
  else
    DockTop.Show;
  MenuDock.Top := 0;
  StatusBar.SizeGrip := not FrmPos.FullScreen;
  if FrmPos.FullScreen then
    ViewFullScreen.Caption := STR_MENU_VIEW[9]
  else
    ViewFullScreen.Caption := STR_MENU_VIEW[9];
end;

procedure TFrmFalconMain.ToolsPackagesClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(AppRoot + 'PkgManager.exe'), '',
    PChar(AppRoot), SW_SHOW)
end;

procedure TFrmFalconMain.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  FPluginManager.Free;
  FPluginServiceManager.Free;
  for I := TreeViewProjects.Items.Count - 1 downto 0 do
    TSourceBase(TreeViewProjects.Items.Item[I].Data).Free;
  FSearchList.Free;
  for I := 0 to FIncludeFileList.Count - 1 do
  begin
    if FIncludeFileList.Objects[I] <> nil then
      FIncludeFileList.Objects[I].Free;
  end;
  FIncludeFileList.Free;
  FReplaceList.Free;
  for I := 0 to ProjectIncludeList.Count - 1 do
  begin
    if ProjectIncludeList.Objects[I] <> nil then
      ProjectIncludeList.Objects[I].Free;
  end;
  ProjectIncludeList.Free;
  for I := 0 to FProjectIncludePathList.Count - 1 do
  begin
    if FProjectIncludePathList.Objects[I] <> nil then
      FProjectIncludePathList.Objects[I].Free;
  end;
  FProjectIncludePathList.Free;
  DebugParser.Free;
  DebugReader.Free;
  CommandQueue.Free;
  WatchList.Free;
  AllParsedList.Free;
  ActiveEditingFile.Free;
  ThreadFilesParsed.Free;
  ThreadTokenFiles.Free;
  ThreadLoadTkFiles.Free;
  FilesParsed.Free;
  ParseAllFiles.Free;
  fWorkerThread.Free;
  Templates.Free;
  Config.Free;
  SintaxList.Free;
  FreeExecResources;
end;

procedure TFrmFalconMain.ViewItemClick(Sender: TObject);
begin
  case TTBXItem(Sender).Tag of
    0: ProjectPanel.Visible := TTBXItem(Sender).Checked;
    1: StatusBar.Visible := TTBXItem(Sender).Checked;
    2:
      begin
        PanelOutline.Visible := TTBXItem(Sender).Checked and
          (PageControlEditor.ActivePageIndex >= 0);
        if PanelOutline.Visible then
          UpdateActiveFileToken(ActiveEditingFile)
        else
          TreeViewOutline.Clear;
      end;
  end;
end;

procedure TFrmFalconMain.FileNewItemClick(Sender: TObject);
var
  SelFile: TSourceFile;
  FileType, CompilerType: Integer;
  Ext: string;
begin
  FileType := FILE_TYPE_CPP;
  CompilerType := COMPILER_CPP;
  Ext := '.cpp';
  if not Config.Environment.DefaultCppNewFile then
  begin
    FileType := FILE_TYPE_C;
    CompilerType := COMPILER_C;
    Ext := '.c';
  end;
  //BtnNew.Tag := TControl(Sender).Tag;
  //BtnNew.ImageIndex := TControl(Sender).Tag;
  if not GetSelectedFileInList(SelFile) then
    SelFile := nil;
  case TControl(Sender).Tag of
    1:
      begin
        if not Assigned(FrmNewProj) then
        begin
          FrmNewProj := TFrmNewProj.CreateParented(Handle);
          FrmNewProj.ShowModal;
        end;
      end;
    2: NewSourceFile(FILE_TYPE_C, COMPILER_C, 'main' + '.c', STR_FRM_MAIN[13], '.c', '', SelFile, False, True).Edit.Memo.SetSavePoint;
    3: NewSourceFile(FILE_TYPE_CPP, COMPILER_CPP, 'main' + '.cpp', STR_FRM_MAIN[13], '.cpp', '', SelFile, False, True).Edit.Memo.SetSavePoint;
    4: NewSourceFile(FILE_TYPE_H, NO_COMPILER, 'main' + '.h', STR_FRM_MAIN[13], '.h', '', SelFile, False, True).Edit.Memo.SetSavePoint;
    5: NewSourceFile(FILE_TYPE_RC, COMPILER_RC, STR_FRM_MAIN[16] + '.rc', STR_FRM_MAIN[13], '.rc', '', SelFile, False, True).Edit.Memo.SetSavePoint;
    6: NewSourceFile(FILE_TYPE_UNKNOW, CompilerType, 'main', STR_FRM_MAIN[13], '', '', SelFile, False, True).Edit.Memo.SetSavePoint;
    7: NewSourceFile(FILE_TYPE_FOLDER, NO_COMPILER, STR_NEW_MENU[8], STR_FRM_MAIN[14], '', '', SelFile, True, False);
  else
    NewSourceFile(FileType, CompilerType, 'main' + Ext,
      STR_FRM_MAIN[13], Ext, '', SelFile, False, True).Edit.Memo.SetSavePoint;
  end;
  if (SelFile <> nil) and (SelFile.FileType = FILE_TYPE_PROJECT) then
    SelFile.Project.PropertyChanged := True;
  if TControl(Sender).Tag <> 1 then
    UpdateMenuItems([rmFile, rmFileNew, rmEdit, rmSearch, rmProject, rmRun, rmProjectsPopup]);
end;

procedure TFrmFalconMain.TViewToolbarClick(Sender: TObject);
begin
  case TTBXItem(Sender).Tag of
    0: DefaultBar.Visible := TTBXItem(Sender).Checked;
    1: EditBar.Visible := TTBXItem(Sender).Checked;
    2: SearchBar.Visible := TTBXItem(Sender).Checked;
    3: CompilerBar.Visible := TTBXItem(Sender).Checked;
    4: NavigatorBar.Visible := TTBXItem(Sender).Checked;
    5: ProjectBar.Visible := TTBXItem(Sender).Checked;
    6: HelpBar.Visible := TTBXItem(Sender).Checked;
    7: DebugBar.Visible := TTBXItem(Sender).Checked;
  end;
end;

function TFrmFalconMain.ImportDevCppProject(const FileName: string;
  var Proj: TProjectFile): Boolean;
const
  DevType: array[0..3] of Integer = (APPTYPE_GUI, APPTYPE_CONSOLE, APPTYPE_LIB,
    APPTYPE_DLL);
var
  ini: Tinifile;
  Node: TTreeNode;
  NewPrj: TProjectFile;
  NewFile: TSourceFile;
  PrjDevType, UnitCount, I: Integer;
  IsCpp, Edited: Boolean;
  IconName, SourceFileName: string;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  ini := TIniFile.Create(FileName);
  if not ini.SectionExists('Project') then
  begin
    ini.Free;
    Exit;
  end;
  NewPrj := CreateProject('', FILE_TYPE_PROJECT);
  Node := NewPrj.Node;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  Node.Text := NewPrj.Name;
  Node.Selected := True;
  Node.Focused := True;
  IsCpp := ini.ReadBool('Project', 'IsCpp', False);
  if IsCpp then
  begin
    NewPrj.CompilerType := COMPILER_CPP;
    NewPrj.Flags := ini.ReadString('Project', 'CppCompiler', '');
  end
  else
  begin
    NewPrj.CompilerType := COMPILER_C;
    NewPrj.Flags := ini.ReadString('Project', 'Compiler', '');
  end;
  NewPrj.Libs := ini.ReadString('Project', 'Linker', '');
  NewPrj.Libs := StringReplace(NewPrj.Libs, '_@@_', ' ', [rfReplaceAll]);
  NewPrj.Flags := StringReplace(NewPrj.Flags, '_@@_', ' ', [rfReplaceAll]);
  PrjDevType := ini.ReadInteger('Project', 'Type', 1);
  if PrjDevType > 3 then
    PrjDevType := 1;
  NewPrj.AppType := DevType[PrjDevType];
  case NewPrj.AppType of
    APPTYPE_GUI: NewPrj.Libs := '-mwindows ' + NewPrj.Libs;
    APPTYPE_DLL: NewPrj.Libs := '-shared -Wl,--add-stdcall-alias ' + NewPrj.Libs;
  end;
  NewPrj.Target := ini.ReadString('Project', 'OverrideOutputName', '');
  if Length(NewPrj.Target) = 0 then
    NewPrj.Target := ExtractName(FileName) + APPEXTTYPES[NewPrj.AppType];
  NewPrj.EnableTheme := ini.ReadBool('Project', 'SupportXPThemes', False);
  IconName := ExtractFilePath(FileName) + ini.ReadString('Project', 'Icon', '');
  if FileExists(IconName) then
  begin
    NewPrj.Icon := TIcon.Create;
    try
      NewPrj.Icon.LoadFromFile(IconName);
    except
      NewPrj.Icon.Free;
      NewPrj.Icon := nil;
    end;
  end;
  NewPrj.IncludeVersionInfo := ini.ReadBool('Project', 'IncludeVersionInfo', False);
  NewPrj.Version.Major := ini.ReadInteger('VersionInfo', 'Major', 0);
  NewPrj.Version.Minor := ini.ReadInteger('VersionInfo', 'Minor', 0);
  NewPrj.Version.Release := ini.ReadInteger('VersionInfo', 'Release', 0);
  NewPrj.Version.Build := ini.ReadInteger('VersionInfo', 'Build', 0);
  NewPrj.Version.LanguageID := ini.ReadInteger('VersionInfo', 'LanguageID', 1033);
  NewPrj.Version.CharsetID := ini.ReadInteger('VersionInfo', 'CharsetID', 1252);
  NewPrj.Version.CompanyName := ini.ReadString('VersionInfo', 'CompanyName', '');
  NewPrj.Version.FileVersion := ini.ReadString('VersionInfo', 'FileVersion', '');
  NewPrj.Version.FileDescription := ini.ReadString('VersionInfo', 'FileDescription', '');
  NewPrj.Version.InternalName := ini.ReadString('VersionInfo', 'InternalName', '');
  NewPrj.Version.LegalCopyright := ini.ReadString('VersionInfo', 'LegalCopyright', '');
  NewPrj.Version.OriginalFilename := ini.ReadString('VersionInfo', 'OriginalFilename', '');
  NewPrj.Version.ProductName := ini.ReadString('VersionInfo', 'ProductName', '');
  NewPrj.Version.ProductVersion := ini.ReadString('VersionInfo', 'ProductVersion', '');
  NewPrj.AutoIncBuild := ini.ReadBool('VersionInfo', 'AutoIncBuildNr', False);
  UnitCount := ini.ReadInteger('Project', 'UnitCount', 0);
  Edited := False;
  for I := 1 to UnitCount do
  begin
    SourceFileName := ini.ReadString('Unit' + IntToStr(I), 'FileName', '');
    NewFile := NewSourceFile(GetFileType(SourceFileName),
      GetCompiler(GetFileType(SourceFileName)), SourceFileName,
      RemoveFileExt(SourceFileName), ExtractFileExt(SourceFileName),
      '', NewPrj, False, False);
    if FileExists(NewFile.FileName) then
    begin
      NewFile.DateOfFile := FileDateTime(NewFile.FileName);
      NewFile.Saved := True;
      if (CompareText(NewFile.Name, 'main.c') = 0) or
        (CompareText(NewFile.Name, 'main.cpp') = 0) then
      begin
        NewFile.Edit;
        Edited := True;
      end;
    end;
  end;
  if not Edited then
    NewPrj.Node.Selected := True;
  ini.Free;
  Proj := NewPrj;
  Result := True;
end;

function TFrmFalconMain.ImportCodeBlocksProject(const FileName: string;
  var Proj: TProjectFile): Boolean;

  function GetAttribute(Node: IXMLNode; Attribute: string;
    Default: string = ''): string;
  begin
    if (Node <> nil) and Node.HasAttribute(Attribute) then
      Result := Node.Attributes[Attribute]
    else
      Result := Default;
  end;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string;
    Default: string = ''): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := GetAttribute(Temp, Attribute, Default)
    else
      Result := Default;
  end;

  procedure LoadFiles(XMLNode: IXMLNode; Parent: TSourceFile);
  var
    XMLDoc: TXMLDocument;
    Temp, LytRoot, FileNode: IXMLNode;
    STemp, StrProp, LytFileName, RootPath: string;
    FileProp, TopFile: TSourceFile;
    CaretXY: TBufferCoord;
    sheet: TSourceFileSheet;
    TopLine, SelStart, I, CompilerType: Integer;
    List: TStringList;
    FromStart: Boolean;
  begin
    TopFile := nil;
    //XMLDoc := nil;
    RootPath := ExtractFilePath(Parent.FileName);
    LytFileName := ChangeFileExt(FileName, '.layout');
    if FileExists(LytFileName) then
    begin
      XMLDoc := TXMLDocument.Create(FrmFalconMain);
      try
        XMLDoc.LoadFromFile(LytFileName);
      except
        Exit;
      end;
      LytRoot := XMLDoc.ChildNodes.FindNode('CodeBlocks_layout_file');
    end;
    Temp := XMLNode.ChildNodes.First;
    List := TStringList.Create;
    CompilerType := -1;
    while Temp <> nil do
    begin
      if Temp.NodeName <> 'Unit' then
      begin
        Temp := Temp.NextSibling;
        Continue;
      end;
      STemp := GetAttribute(Temp, 'filename');
      List.Add(STemp);
      if (CompilerType = -1) and (GetFileType(STemp) = FILE_TYPE_CPP) then
        CompilerType := COMPILER_CPP;
      Temp := Temp.NextSibling;
    end;
    if CompilerType <> -1 then
      Parent.Project.CompilerType := CompilerType;
    AddFilesToProject(List, Parent, True, True);
    if not Assigned(LytRoot) then
    begin
      List.Free;
      Exit;
    end;
    I := 0;
    while I < List.Count do
    begin
      FileProp := TSourceFile(List.Objects[I]);
      STemp := FileProp.FileName;
      FromStart := True;
      FileNode := LytRoot.ChildNodes.First;
      while FileNode <> nil do
      begin
        if FileNode.NodeName <> 'File' then
        begin
          FileNode := FileNode.NextSibling;
          Continue;
        end;
        LytFileName :=  ExpandFileName(RootPath + GetAttribute(FileNode, 'name'));
        if CompareText(LytFileName, FileProp.FileName) = 0 then
        begin
          StrProp := GetAttribute(FileNode, 'top');
          if StrProp = '1' then
            TopFile := FileProp;
          SelStart := StrToInt(GetTagProperty(FileNode, 'Cursor',
            'position', '0'));
          TopLine := StrToInt(GetTagProperty(FileNode, 'Cursor',
            'topLine', '0')) + 1;
          StrProp := GetAttribute(FileNode, 'open');
          if StrProp = '1' then
          begin
            sheet := FileProp.Edit;
            CaretXY := sheet.Memo.CharIndexToRowCol(SelStart);
            sheet.Memo.CaretXY := CaretXY;
            sheet.Memo.TopLine := TopLine;
          end;
          if I + 1 >= List.Count then
            Break;
          Inc(I);
          FromStart := False;
          FileProp := TSourceFile(List.Objects[I]);
          STemp := FileProp.FileName;
        end;
        FileNode := FileNode.NextSibling;
      end;
      if (FileNode <> nil) or FromStart then
        Inc(I);
    end;
    List.Free;
    if Assigned(TopFile) then
      TopFile.ViewPage;
  end;

var
  XMLDoc: TXMLDocument;
  ProjNode, BuildNode, TargetNode, TempNode, AddNode: IXMLNode;
  CompNode, LinkerNode: IXMLNode;
  Node: TTreeNode;
  NewPrj: TProjectFile;
  Major, Minor: Integer;
  TempStr: string;
  ExtAuto, createStaticLib, createDefFile: Boolean;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  try
    XMLDoc.LoadFromFile(FileName);
  except
    Exit;
  end;
  //main tag
  ProjNode := XMLDoc.ChildNodes.FindNode('CodeBlocks_project_file');
  if (ProjNode = nil) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  Major := StrToInt(GetTagProperty(ProjNode, 'FileVersion', 'major', '0'));
  Minor := StrToInt(GetTagProperty(ProjNode, 'FileVersion', 'minor', '0'));
  if (Major <> 1) or (Minor <> 6) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  //Project tag
  ProjNode := ProjNode.ChildNodes.FindNode('Project');
  if (ProjNode = nil) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  NewPrj := CreateProject('', FILE_TYPE_PROJECT);
  Node := NewPrj.Node;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  NewPrj.CompilerType := COMPILER_C;
  Node.Text := NewPrj.Name;
  Node.Selected := True;
  Node.Focused := True;
  BuildNode := ProjNode.ChildNodes.FindNode('Build');
  if (BuildNode = nil) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  TargetNode := BuildNode.ChildNodes.First;
  ExtAuto := False;
  createStaticLib := False;
  createDefFile := False;
  while TargetNode <> nil do
  begin
    if TargetNode.NodeName <> 'Target' then
    begin
      TargetNode := TargetNode.NextSibling;
      Continue;
    end;
    TempNode := TargetNode.ChildNodes.First;
    NewPrj.CompilerOptions := '';
    NewPrj.Flags := '';
    NewPrj.Libs := '';
    while TempNode <> nil do
    begin
      if TempNode.NodeName = 'Option' then
      begin
        if TempNode.HasAttribute('output') then
        begin
          TempStr := GetAttribute(TempNode, 'extension_auto');
          ExtAuto := TempStr = '1';
          NewPrj.Target := GetAttribute(TempNode, 'output');
        end
        else if TempNode.HasAttribute('type') then
        begin
          TempStr := GetAttribute(TempNode, 'type');
          if TempStr = '0' then
          begin
            NewPrj.AppType := APPTYPE_GUI;
            NewPrj.Libs := Trim('-mwindows ' + NewPrj.Libs);
          end
          else if TempStr = '1' then
            NewPrj.AppType := APPTYPE_CONSOLE
          else if TempStr = '2' then
            NewPrj.AppType := APPTYPE_LIB
          else if TempStr = '3' then
          begin
            NewPrj.AppType := APPTYPE_DLL;
            NewPrj.Libs := Trim('-shared ' + NewPrj.Libs);
          end;
        end
        else if TempNode.HasAttribute('createStaticLib') then
        begin
          TempStr := GetAttribute(TempNode, 'createStaticLib');
          createStaticLib := TempStr = '1';
        end
        else if TempNode.HasAttribute('createDefFile') then
        begin
          TempStr := GetAttribute(TempNode, 'createDefFile');
          createDefFile := TempStr = '1';
        end;
      end
      else if TempNode.NodeName = 'Compiler' then
      begin
        AddNode := TempNode.ChildNodes.First;
        while AddNode <> nil do
        begin
          TempStr := GetAttribute(AddNode, 'option');
          if TempStr = '-Wall' then
            NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' + TempStr)
          else if TempStr = '-O2' then
            NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' + TempStr)
          else
            NewPrj.Flags := Trim(NewPrj.Flags + ' ' + TempStr);
          AddNode := AddNode.NextSibling;
        end;
      end
      else if TempNode.NodeName = 'Linker' then
      begin
        AddNode := TempNode.ChildNodes.First;
        while AddNode <> nil do
        begin
          if AddNode.HasAttribute('option') then
          begin
            TempStr := GetAttribute(AddNode, 'option');
            if TempStr = '-s' then
              NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' +
                TempStr)
            else
              NewPrj.Libs := Trim(NewPrj.Libs + ' ' + TempStr);
          end
          else if AddNode.HasAttribute('library') then
          begin
            TempStr := GetAttribute(AddNode, 'library');
            NewPrj.Libs := Trim(NewPrj.Libs + ' -l' + TempStr);
          end;
          AddNode := AddNode.NextSibling;
        end;
      end;
      TempNode := TempNode.NextSibling;
    end;
    TempStr := GetAttribute(TargetNode, 'title');
    if TempStr = 'Release' then
      Break;
    TargetNode := TargetNode.NextSibling;
  end; //end build childs
  CompNode := ProjNode.ChildNodes.FindNode('Compiler');
  if CompNode <> nil then
  begin
    AddNode := CompNode.ChildNodes.First;
    while AddNode <> nil do
    begin
      TempStr := GetAttribute(AddNode, 'option');
      if TempStr = '-Wall' then
        NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' + TempStr)
      else if TempStr = '-O2' then
        NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' + TempStr)
      else
        NewPrj.Flags := Trim(NewPrj.Flags + ' ' + TempStr);
      AddNode := AddNode.NextSibling;
    end;
  end;
  LinkerNode := ProjNode.ChildNodes.FindNode('Linker');
  if LinkerNode <> nil then
  begin
    AddNode := LinkerNode.ChildNodes.First;
    while AddNode <> nil do
    begin
      if AddNode.HasAttribute('option') then
      begin
        TempStr := GetAttribute(AddNode, 'option');
        if TempStr = '-s' then
          NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' + TempStr)
        else
          NewPrj.Libs := Trim(NewPrj.Libs + ' ' + TempStr);
      end
      else if AddNode.HasAttribute('library') then
      begin
        TempStr := GetAttribute(AddNode, 'library');
        NewPrj.Libs := Trim(NewPrj.Libs + ' -l' + TempStr);
      end;
      AddNode := AddNode.NextSibling;
    end;
  end;

  if ExtAuto then
  begin
    case NewPrj.AppType of
      APPTYPE_DLL: NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.dll';
      APPTYPE_LIB: NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.a';
    else
      NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.exe';
    end;
  end;
  if createStaticLib then
    NewPrj.Libs := Trim(NewPrj.Libs + ' ' + FormatLibrary(NewPrj.Target));
  if createDefFile then
  begin
    //not implemented
  end;
  LoadFiles(ProjNode, NewPrj);
  //XMLDoc.Free;
  Proj := NewPrj;
  Result := True;
end;

function TFrmFalconMain.ImportMSVCProject(const FileName: string;
  var Proj: TProjectFile): Boolean;

  function GetAttribute(Node: IXMLNode; Attribute: string;
    Default: string = ''): string;
  begin
    if (Node <> nil) and Node.HasAttribute(Attribute) then
      Result := Node.Attributes[Attribute]
    else
      Result := Default;
  end;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string;
    Default: string = ''): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) and Temp.HasAttribute(Attribute) then
      Result := GetAttribute(Temp, Attribute, Default)
    else
      Result := Default;
  end;

  procedure LoadFiles(XMLNode: IXMLNode; FileList: TStrings);
  var
    TempNode: IXMLNode;
    RelativePath, ProjectPath: string;
  begin
    TempNode := XMLNode.ChildNodes.First;
    while TempNode <> nil do
    begin
      if TempNode.NodeName = 'Filter' then
      begin
        LoadFiles(TempNode, FileList);
        TempNode := TempNode.NextSibling;
        Continue;
      end;
      if TempNode.NodeName <> 'File' then
      begin
        TempNode := TempNode.NextSibling;
        Continue;
      end;
      ProjectPath := ExtractFilePath(FileName);
      RelativePath := GetAttribute(TempNode, 'RelativePath');
      if not (GetFileType(RelativePath) in [FILE_TYPE_C, FILE_TYPE_CPP,
        FILE_TYPE_H, FILE_TYPE_RC]) or not FileExists(ProjectPath + RelativePath) then
      begin
        TempNode := TempNode.NextSibling;
        Continue;
      end;
      FileList.Add(RelativePath);
      TempNode := TempNode.NextSibling;
    end;
  end;

var
  XMLDoc: TXMLDocument;
  ProjNode, ConfigNode, FilesNode, TempNode: IXMLNode;
  Node: TTreeNode;
  NewPrj: TProjectFile;
  I, J, ConfigurationType: Integer;
  TempStr, ProjectType, ProjectVersion, OutputDirectory, Flags, Libs,
  TempName, OutputFile: string;
  ExtAuto, createStaticLib, createDefFile: Boolean;
  Version: TVersion;
  List: TStringList;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  try
    XMLDoc.LoadFromFile(FileName);
  except
    Exit;
  end;
  //main tag
  ProjNode := XMLDoc.ChildNodes.FindNode('VisualStudioProject');
  if (ProjNode = nil) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  ProjectType := GetAttribute(ProjNode, 'ProjectType');
  ProjectVersion := GetAttribute(ProjNode, 'Version');
  Version := ParseVersion(ProjectVersion);
  if (ProjectType <> 'Visual C++') or not
    ((CompareVersion(Version, ParseVersion('7.10.0.0')) >= 0) and
     (CompareVersion(Version, ParseVersion('9.00.0.0')) <= 0)) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  //Configurations tag
  ConfigNode := ProjNode.ChildNodes.FindNode('Configurations');
  if ConfigNode = nil then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  I := -1;
  List := TStringList.Create;
  TempNode := ConfigNode.ChildNodes.First;
  while TempNode <> nil do
  begin
    if (TempNode.NodeName = 'Configuration') then
    begin
      List.AddObject(GetAttribute(TempNode, 'Name'), Pointer(TempNode));
      if (Pos('DEBUG', UpperCase(GetAttribute(TempNode, 'Name'))) = 0) and (I < 0) then
        I := List.Count - 1;
    end;
    TempNode := TempNode.NextSibling;
  end;
  if (List.Count > 1) and ShowVisualCppOptions(Handle, List, I) then
    TempNode := IXMLNode(Pointer(List.Objects[I]))
  else if (List.Count = 1) then
    TempNode := IXMLNode(Pointer(List.Objects[0]));
  List.Free;
  ConfigNode := TempNode;
  if ConfigNode = nil then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  OutputDirectory := GetAttribute(ConfigNode, 'OutputDirectory');
  ConfigurationType := StrToInt(GetAttribute(ConfigNode, 'ConfigurationType', '0'));
  NewPrj := CreateProject('', FILE_TYPE_PROJECT);
  Node := NewPrj.Node;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  NewPrj.CompilerType := COMPILER_CPP;
  Node.Text := NewPrj.Name;
  Node.Selected := True;
  Node.Focused := True;

  TempNode := ConfigNode.ChildNodes.First;
  while TempNode <> nil do
  begin
    if (TempNode.NodeName = 'Tool') and
      (GetAttribute(TempNode, 'Name') = 'VCCLCompilerTool') then
      Break;
    TempNode := TempNode.NextSibling;
  end;
  Flags := '';
  if TempNode <> nil then
  begin
    TempStr := GetAttribute(TempNode, 'AdditionalIncludeDirectories');
    List := TStringList.Create;
    List.Delimiter := ';';
    List.DelimitedText := TempStr;
    for I := 0 to List.Count - 1 do
    begin
      List.Strings[I] := ConvertSlashes(List.Strings[I]);
      if ExtractFileDrive(List.Strings[I]) <> '' then
        TempStr := List.Strings[I]
      else
        TempStr := ExtractFilePath(FileName) + List.Strings[I];
      if not DirectoryExists(TempStr) then
      begin
        // computer with different directory structure
        // try find parent folder
        if ExtractFileDrive(List.Strings[I]) <> '' then
        begin
          TempStr := ExtractFileDrive(TempStr) + '\';
          TempStr := ExtractRelativePath(TempStr, List.Strings[I]);
          TempName := '..\' + TempStr;
          TempStr := ExtractFilePath(FileName);
          J := 0;
          repeat
            if DirectoryExists(TempStr + TempName) then
              Break;
            J := PosEx('\', TempName, 4);
            if J > 0 then
              TempName := '..' + Copy(TempName, J, Length(TempName) - J + 1);
          until J = 0;
          if not DirectoryExists(TempStr + TempName) then
            Continue;
          List.Strings[I] := TempName;
        end
        else
          Continue;
      end;
      if (Pos('\', List.Strings[I]) > 0) then
        Flags := Flags + ' -I"' + List.Strings[I] + '"'
      else
        Flags := Flags + ' -I' + List.Strings[I];
    end;
    TempStr := GetAttribute(TempNode, 'PreprocessorDefinitions');
    List.DelimitedText := TempStr;
    for I := 0 to List.Count - 1 do
      Flags := Flags + ' -D' + List.Strings[I];
    List.Free;
    Flags := Trim(Flags);
  end;
  TempNode := ConfigNode.ChildNodes.First;
  TempStr := 'VCLinkerTool';
  if ConfigurationType = 4 then
    TempStr := 'VCLibrarianTool';
  while TempNode <> nil do
  begin
    if (TempNode.NodeName = 'Tool') and (GetAttribute(TempNode, 'Name') = TempStr) then
      Break;
    TempNode := TempNode.NextSibling;
  end;
  Libs := '';
  if OutputDirectory <> '' then
    OutputDirectory := IncludeTrailingPathDelimiter(OutputDirectory);
  OutputFile := OutputDirectory + RemoveFileExt(ExtractFileName(FileName));
  ExtAuto := True;
  if TempNode <> nil then
  begin
    OutputFile := ConvertSlashes(GetAttribute(TempNode, 'OutputFile'));
    if OutputFile <> '' then
    begin
      OutputFile := StringReplace(OutputFile, '$(OutDir)',
        ExcludeTrailingPathDelimiter(OutputDirectory), []);
      if not DirectoryExists(ExtractFilePath(FileName) + ExtractFileName(OutputFile)) then
        OutputFile := ExtractFileName(OutputFile);
      if (ConfigurationType <> 4) or
        (UpperCase(ExtractFileExt(OutputFile)) <> '.LIB') then
        ExtAuto := False;
    end;
    if ConfigurationType <> 4 then
    begin
      TempStr := GetAttribute(TempNode, 'AdditionalDependencies');
      List := TStringList.Create;
      List.Delimiter := ' ';
      List.DelimitedText := TempStr;
      for I := 0 to List.Count - 1 do
      begin
        TempStr := ConvertSlashes(List.Strings[I]);
        if ExtractFilePath(TempStr) <> '' then
        begin
          TempStr := ExcludeTrailingPathDelimiter(ExtractFilePath(TempStr));
          if (Pos('\', TempStr) > 0) then
            Libs := Libs + ' -L"' + TempStr + '"'
          else
            Libs := Libs + ' -L' + TempStr;
        end;
        TempStr := ConvertSlashes(List.Strings[I]);
        TempStr := RemoveFileExt(ExtractFileName(TempStr));
        Libs := Libs + ' -l' + TempStr;
      end;
      List.Free;
      Libs := Trim(Libs);
    end;
  end;
  createStaticLib := False;
  createDefFile := False;
  NewPrj.CompilerOptions := '-Wall';
  NewPrj.Target := OutputFile;
  NewPrj.Flags := Flags;
  NewPrj.Libs := Libs;
  if ConfigurationType = 0 then
  begin
    NewPrj.AppType := APPTYPE_GUI;
    NewPrj.Libs := Trim('-mwindows ' + NewPrj.Libs);
  end
  else if ConfigurationType = 2 then
  begin
    NewPrj.AppType := APPTYPE_DLL;
    NewPrj.Libs := Trim('-shared ' + NewPrj.Libs);
  end
  else if ConfigurationType = 4 then
    NewPrj.AppType := APPTYPE_LIB
  else // 1
  begin
    NewPrj.AppType := APPTYPE_CONSOLE
  end;
  if ExtAuto then
  begin
    case NewPrj.AppType of
      APPTYPE_DLL: NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.dll';
      APPTYPE_LIB: NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.a';
    else
      NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.exe';
    end;
  end;
  if createStaticLib then
    NewPrj.Libs := Trim(NewPrj.Libs + ' ' + FormatLibrary(NewPrj.Target));
  if createDefFile then
  begin
    //not implemented
  end;
  FilesNode := ProjNode.ChildNodes.FindNode('Files');
  if (FilesNode <> nil) then
  begin
    List := TStringList.Create;
    LoadFiles(FilesNode, List);
    AddFilesToProject(List, NewPrj, True, True);
    List.Free;
  end;
  //XMLDoc.Free;
  Proj := NewPrj;
  Result := True;
end;

procedure TFrmFalconMain.ImportFromDevCpp(Sender: TObject);
var
  Proj: TProjectFile;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := Format(STR_FRM_MAIN[48], ['Dev-C++']) + '(*.dev)|*.dev';
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not ImportDevCppProject(FileName, Proj) then
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[47], ['Dev-C++'])),
          'Falcon C++', MB_ICONEXCLAMATION)
      else
        ParseProjectFiles(Proj);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ImportFromCodeBlocks(Sender: TObject);
var
  Proj: TProjectFile;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := Format(STR_FRM_MAIN[48], ['Code::Blocks']) + '(*.cbp)|*.cbp';
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not ImportCodeBlocksProject(FileName, Proj) then
        InternalMessageBox(
          PChar(Format(STR_FRM_MAIN[47], ['Code::Blocks'])), 'Falcon C++',
          MB_ICONEXCLAMATION)
      else
        ParseProjectFiles(Proj);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ImportFromMSVC(Sender: TObject);
var
  Proj: TProjectFile;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := Format(STR_FRM_MAIN[48], ['MS Visual C++']) + '(*.vcproj)|*.vcproj';
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not ImportMSVCProject(FileName, Proj) then
        InternalMessageBox(
          PChar(Format(STR_FRM_MAIN[47], ['MS Visual C++'])), 'Falcon C++',
          MB_ICONEXCLAMATION)
      else
        ParseProjectFiles(Proj);
    end;
    Free;
  end;
end;

//text change parse delay

procedure TFrmFalconMain.TimerChangeDelayTimer(Sender: TObject);
begin
  if fWorkerThread <> nil then
    TParserThread(fWorkerThread).SetModified;
  TimerChangeDelay.Enabled := False;
end;

procedure TFrmFalconMain.ToolbarCheck(const Index: Integer; const Value: Boolean);
begin
  ViewToolbar.Items[Index].Checked := Value;
end;

procedure TFrmFalconMain.ToolbarClose(Sender: TObject);
begin
  ToolbarCheck(TToolBar(Sender).Tag, False);
end;

procedure TFrmFalconMain.ViewZoomIncClick(Sender: TObject);
begin
  if ZoomEditor >= 20 then
    Exit;
  Inc(FZoomEditor);
  UpdateEditorZoom;
end;

procedure TFrmFalconMain.ViewZoomDecClick(Sender: TObject);
begin
  if ZoomEditor <= -10 then
    Exit;
  Dec(FZoomEditor);
  UpdateEditorZoom;
end;

procedure TFrmFalconMain.ToggleBookmarksClick(Sender: TObject);
var
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveFile(FileProp) then
    Exit;
  if not FileProp.GetSheet(Sheet) then
    Exit;
  if TTBXItem(Sender).Checked then //set bookmark
  begin
    TTBXItem(EditGotoBookmarks.Items[TTBXItem(Sender).Tag - 1]).Checked := True;
    TTBXItem(EditGotoBookmarks.Items[TTBXItem(Sender).Tag - 1]).Enabled := True;
    Sheet.Memo.SetBookMark(TTBXItem(Sender).Tag,
      Sheet.Memo.DisplayX,
      Sheet.Memo.DisplayY);
  end
  else
  begin //delete bookmark
    TTBXItem(EditGotoBookmarks.Items[TTBXItem(Sender).Tag - 1]).Checked := False;
    TTBXItem(EditGotoBookmarks.Items[TTBXItem(Sender).Tag - 1]).Enabled := False;
    Sheet.Memo.ClearBookMark(TTBXItem(Sender).Tag);
  end;
end;

procedure TFrmFalconMain.DropFilesIntoProjectList(List: TStrings; X, Y: Integer);
var
  AnItem: TTreeNode;
  SelFile, ExisFile: TSourceFile;
  Proj: TProjectFile;
  I, FileType: Integer;
  References: Boolean;
  SrcList, AddedList: TStrings;
begin
  AnItem := TreeViewProjects.GetNodeAt(X, Y);
  SrcList := TStringList.Create;
  SelFile := nil;
  if Assigned(AnItem) then
    SelFile := TSourceFile(AnItem.Data);
  AddedList := TStringList.Create;
  for I := 0 to List.Count - 1 do
  begin
    if CompareText(ExtractFileExt(List.Strings[I]), '.dev') = 0 then
      ImportDevCppProject(List.Strings[I], Proj)
    else if CompareText(ExtractFileExt(List.Strings[I]), '.cbp') = 0 then
      ImportCodeBlocksProject(List.Strings[I], Proj)
    else if CompareText(ExtractFileExt(List.Strings[I]), '.vcproj') = 0 then
      ImportMSVCProject(List.Strings[I], Proj)
    else
    begin
      if Assigned(AnItem) then
      begin
        if not (TSourceFile(AnItem.Data).FileType in
          [FILE_TYPE_PROJECT, FILE_TYPE_FOLDER]) then
          SelFile := nil;
      end;
      FileType := GetFileType(List.Strings[I]);
      if (FileType = FILE_TYPE_PROJECT) or not Assigned(SelFile) then
      begin
        if SearchSourceFile(List.Strings[I], ExisFile) then
        begin
          if ExisFile.FileType <> FILE_TYPE_PROJECT then
            ExisFile.Edit;
        end
        else
        begin
          Proj := OpenFile(List.Strings[I]);
          AddFileToHistory(List.Strings[I]);
          if Proj.FileType <> FILE_TYPE_PROJECT then
          begin
            SrcList.AddObject(Proj.FileName, Proj);
            { TODO 1 -oMazin -c : Editing Folder 24/08/2012 22:21:01 }
            Proj.Edit;
          end
          else
            Proj.GetFiles(SrcList);
          //OpenFileWithHistoric(List.Strings[I], Proj);
        end;
      end
      else
      begin
        AddedList.Clear;
        AddedList.Add(List.Strings[I]);
        References := True;
        if CompareText(ExtractFileDrive(SelFile.FileName),
          ExtractFileDrive(List.Strings[I])) <> 0 then
          References := False;
        AddFilesToProject(AddedList, SelFile, References);
        SrcList.AddStrings(AddedList);
      end;
    end;
  end;
  ParseFiles(SrcList);
  SrcList.Free;
  AddedList.Free;
end;

procedure TFrmFalconMain.GotoBookmarkClick(Sender: TObject);
var
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveFile(FileProp) then
    Exit;
  if not FileProp.GetSheet(Sheet) then
    Exit;
  if TTBXItem(Sender).Checked then
    Sheet.Memo.GotoBookMark(TTBXItem(Sender).Tag);
end;

procedure TFrmFalconMain.TreeViewProjectsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  AnItem, Selitem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
  fpd, fps: TSourceFile;
begin
  Selitem := TreeViewProjects.Selected;
  HT := TreeViewProjects.GetHitTestInfoAt(X, Y);
  //AnItem := TreeViewProjects.GetNodeAt(X, Y);
  AnItem := TreeViewProjects.DropTarget;
  if (AnItem = nil) or (AnItem = Selitem) then
    Exit;
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent, htBelow] <> HT) then
  begin
    AttachMode := naAddChild;
    if (htOnItem in HT) or
      (htOnIcon in HT) then
      AttachMode := naAddChildFirst
    else if htNowhere in HT then
      AttachMode := naAdd
    else if htOnIndent in HT then
      AttachMode := naInsert;
    fps := TSourceFile(Selitem.Data);
    fpd := TSourceFile(AnItem.Data);

    fps.Project.PropertyChanged := True;
    fps.Project.CompilePropertyChanged := True;
    fpd.Project.PropertyChanged := True;
    fpd.Project.CompilePropertyChanged := True;
    if fps.Saved then
    begin
      if fpd is TProjectFile then
        fps.MoveFileTo(ExtractFilePath(fpd.FileName))
      else if fpd.FileType = FILE_TYPE_FOLDER then
      begin
        fpd.Save;
        fps.MoveFileTo(fpd.FileName);
      end;
    end;
    { TODO -oMazin -c : Call OnRenameFile 30/07/2013 00:41:28 }
    Selitem.MoveTo(AnItem, AttachMode);
    FLastPathInclude := '';
    //convert to TSourceFile
    if fps is TProjectFile then
      Selitem.Data := TProjectFile(fps).ConvertToSourceFile(fpd.Project);
    if fps.Project <> fpd.Project then
      AdjustNewProject(Selitem, fpd.Project);
    BoldTreeNode(fpd.Project.Node, True);
  end;
end;

procedure TFrmFalconMain.TreeViewProjectsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  AnItem, Selitem: TTreeNode;
  HT: THitTests;
begin
  Accept := False;
  if not Assigned(TreeViewProjects.Selected) then
    Exit;
  Selitem := TreeViewProjects.Selected;
  HT := TreeViewProjects.GetHitTestInfoAt(X, Y);
  AnItem := TreeViewProjects.GetNodeAt(X, Y);
  if not Assigned(AnItem) or (AnItem = Selitem) then
    Exit;
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent, htBelow] <> HT) and
    (TSourceFile(Selitem.Data).FileType <> FILE_TYPE_PROJECT) then
  begin
    if TSourceFile(AnItem.Data).FileType in
      [FILE_TYPE_PROJECT, FILE_TYPE_FOLDER] then
      Accept := True
    else if htBelow in HT then
      Accept := True;
  end;
end;

//enter focus on popup menu

procedure TFrmFalconMain.PageControlEditorContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  tab: Integer;
begin
  tab := PageControlEditor.IndexOfTabAt(MousePos.X, MousePos.Y);
  if tab >= 0 then
  begin
    PageControlEditor.ActivePageIndex := tab;
    Exit;
  end;
  Handled := True;
end;

procedure TFrmFalconMain.EditorContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  sheet: TSourceFileSheet;
  dc: TDisplayCoord;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  dc := sheet.Memo.PixelsToRowColumn(MousePos.X, MousePos.Y);
  if (dc.Column = 0) or (dc.Row = 0) or
    (sheet.Memo.SelAvail and sheet.Memo.IsPointInSelection(sheet.Memo.DisplayToBufferPos(dc))) or
    ((MousePos.X = -1) and (MousePos.Y = -1)) then
    Exit;
  sheet.Memo.SetFocus;
  EditorGotoXY(sheet.Memo, dc.Column, dc.Row);
end;

procedure TFrmFalconMain.SearchFindClick(Sender: TObject);
begin
  StartFindText(Self);
end;

procedure TFrmFalconMain.SearchReplaceClick(Sender: TObject);
begin
  StartReplaceText(Self);
end;

procedure TFrmFalconMain.SearchFindFilesClick(Sender: TObject);
begin
  StartFindFilesText(Self);
end;

procedure TFrmFalconMain.SearchFindNextClick(Sender: TObject);
begin
  StartFindNextText(Self, LastSearch);
end;

procedure TFrmFalconMain.SearchFindPrevClick(Sender: TObject);
begin
  StartFindPrevText(Self, LastSearch);
end;

procedure TFrmFalconMain.GotoLineAndAlignCenter(Memo: TEditor; Line,
  Col, EndCol: Integer; CursorEnd: Boolean);
var
  BS, BE: TBufferCoord;
  TopLine: Integer;
begin
  Memo.SetFocus;
  TopLine := Line - (Memo.LinesInWindow div 2);
  if TopLine <= 0 then
    TopLine := 1;
  Memo.TopLine := TopLine;
  if Col < EndCol then
  begin
    BS.Line := Line;
    BS.Char := Col;
    BE.Line := Line;
    BE.Char := EndCol;
    if CursorEnd then
      Memo.SetCaretAndSelection(BE, BS, BE)
    else
      Memo.SetCaretAndSelection(BS, BS, BE);
  end
  else
  begin
    Memo.CaretY := Line;
    Memo.CaretX := Col;
  end;
end;

procedure TFrmFalconMain.SelectToken(Token: TTokenClass);
var
  sheet: TSourceFileSheet;
  TopLine: Integer;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  sheet.Memo.SetEmptySelection(Token.SelStart);
  sheet.Memo.SetSelectionStart(Token.SelStart);
  sheet.Memo.SetSelectionEnd(Token.SelStart + Token.SelLength);
  sheet.Memo.SetFocus;
  TopLine := (sheet.Memo.LineFromPosition(Token.SelStart) + 1) -
    (sheet.Memo.LinesInWindow div 2);
  if TopLine <= 0 then
    TopLine := 1;
  sheet.Memo.TopLine := TopLine;
end;

procedure TFrmFalconMain.UpdateActiveFileToken(NewToken: TTokenFile;
  Reload: Boolean);

  procedure FillTokenList(var Sibling, Parent: PNativeNode;
    TokenList: TTokenClass; TokenType: TTkType; Static, DeleteNext: Boolean);
  var
    NodeObject: TNodeObject;
  begin
    Parent := nil;
    if ((TokenList.Count > 25) and not Static) or (Static and (TokenList.Count > 0)) then
    begin
      NodeObject := TNodeObject.Create;
      NodeObject.Data := TokenList;
      NodeObject.Caption := TokenList.Name;
      Parent := TreeViewOutline.InsertNode(Sibling, amInsertAfter, NodeObject);
      TokenList.Data := Parent;
      NodeObject.ImageIndex := GetTokenImageIndex(TokenList, OutlineImages);
    end;
    if not Static then
      FillTreeView(Parent, TokenList)
    else if Assigned(Parent) then
      FillTreeView(Parent, TokenList);
  end;

  procedure ReloadTreeView(var Sibling, Parent: PNativeNode);
  begin
    Sibling := TreeViewOutline.GetFirst;
    FillTokenList(Sibling, Parent, ActiveEditingFile.Includes, tkIncludeList, True, False);
    FillTokenList(Sibling, Parent, ActiveEditingFile.Defines, tkDefineList, True, False);
    if ActiveEditingFile.TreeObjs.Count > 25 then
    begin
      FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs, tkTreeObjList, False, False);
      if (ActiveEditingFile.VarConsts.Count > 25) or
         (ActiveEditingFile.FuncObjs.Count <= 25) then
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts, tkVarConsList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs, tkFuncProList, False, True);
      end
      else
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs, tkFuncProList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts, tkVarConsList, False, True);
      end;
    end
    else
    begin
      if (ActiveEditingFile.VarConsts.Count > 25) or
         (ActiveEditingFile.FuncObjs.Count <= 25) then
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts, tkVarConsList, False, False);
        if (ActiveEditingFile.FuncObjs.Count > 25) then
        begin
          FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs, tkFuncProList, False, False);
          FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs, tkTreeObjList, False, True);
        end
        else
        begin
          FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs, tkTreeObjList, False, False);
          FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs, tkFuncProList, False, True);
        end;
      end
      else
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs, tkFuncProList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs, tkTreeObjList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts, tkVarConsList, False, True);
      end;
    end;
  end;

var
  TokenFileItem, FindedTokenFile: TTokenFile;
  sheet: TSourceFileSheet;
  Sibling, Parent: PNativeNode;
begin
  FindedTokenFile := FilesParsed.ItemOfByFileName(NewToken.FileName);
  if FindedTokenFile = nil then //not parsed
  begin
    TokenFileItem := TTokenFile.Create(FilesParsed);
    TokenFileItem.Assign(NewToken);
  end
  else
  begin
    TokenFileItem := FindedTokenFile;
    if Reload then
      TokenFileItem.Assign(NewToken);
  end;
  ActiveEditingFile.Assign(TokenFileItem);
  if FindedTokenFile = nil then
    FilesParsed.Add(TokenFileItem);
  if DebugReader.Running then
    Exit;
  if ViewOutline.Checked then
  begin
    TreeViewOutline.BeginUpdate;
    TreeViewOutline.Clear;
    ReloadTreeView(Sibling, Parent);
    TreeViewOutline.EndUpdate;
  end;
  if GetActiveSheet(sheet) then
    DetectScope(sheet.Memo, ActiveEditingFile, True);
end;

//hint functions

procedure TFrmFalconMain.ShowHintParams(Memo: TEditor);
var
  S: UnicodeString;
  Params, Fields, Input, SaveInput, SaveFields: string;
  Token, tokenParams, scope: TTokenClass;
  InputError, InQuote: Boolean;
  QuoteChar: Char;
  Attri: THighlighStyle;
  BC, BufferCoordStart, BufferCoordEnd: TBufferCoord;
  I, J, SelStart, BracketEnd, ParamIndex, LineLen, BracketStart: Integer;
  P: TPoint;
  ParamsList: TStringList;
  TokenFileItem: TTokenFile;
  TempText, StructParams: string;
  ShowStructParams: Boolean;
begin
  if not Config.Editor.CodeParameters then
    Exit;
  BC := Memo.CaretXY;
  if BC.Line > 0 then
  begin
    LineLen := Length(Memo.Lines.Strings[BC.Line - 1]);
    if LineLen < BC.Char - 1 then
      BC.Char := LineLen + 1;
  end;
  SelStart := Memo.RowColToCharIndex(BC);
  QuoteChar := #0;
  if Memo.GetHighlighterAttriAtRowCol(BC, S, Attri) then
  begin
    if StringIn(Attri.Name, [HL_Style_Preprocessor]) then
    begin
      HintParams.Cancel;
      Exit;
    end;
    if (Attri.Name = HL_Style_String) then
      QuoteChar := '"'
    else if (Attri.Name = HL_Style_Character) then
      QuoteChar := '''';
    if QuoteChar <> #0 then
    begin
      Dec(BC.Char);
      InQuote := True;
      if Memo.GetHighlighterAttriAtRowCol(BC, S, Attri) then
      begin
        if (Attri.Name = HL_Style_String) then
          QuoteChar := '"'
        else if (Attri.Name = HL_Style_Character) then
          QuoteChar := ''''
        else
          InQuote := False;
      end;
      if not InQuote then
      begin
        Inc(BC.Char, 2);
        SelStart := Memo.RowColToCharIndex(BC);
      end;
    end;
  end;
  BracketStart := SelStart;
  { TODO -oMazin -c : Remove use of memo.Text 04/05/2013 22:11:00 }
  TempText := memo.Lines.Text;
  ShowStructParams := False;
  if not GetFirstOpenParentheses(TempText, QuoteChar, BracketStart) then
  begin
    if not GetFirstOpenBracket(TempText, QuoteChar, BracketStart, SelStart, StructParams) then
    begin
      HintParams.Cancel;
      Exit;
    end
    else
      ShowStructParams := True;
  end;
  BufferCoordStart := Memo.CharIndexToRowCol(BracketStart);
  if ShowStructParams then
  begin
    if not ParseFields(TempText, SelStart, Input, Fields, InputError) then
    begin
      HintParams.Cancel;
      Exit;
    end;
    SaveFields := Fields;
    SaveInput := Input;
    Fields := Fields + Input;
    Input := GetFirstWord(Fields);
    TokenFileItem := ActiveEditingFile;
    if not FilesParsed.GetFieldsBaseType(Input, Fields, BracketStart,
      TokenFileItem, TokenFileItem, Token) then
    begin
      HintParams.Cancel;
      Exit;
    end;
    StructParams := Copy(StructParams, 2, Length(StructParams) - 1);
    ParamIndex := 0;
    while StructParams <> '' do
    begin
      case StructParams[1] of
        '.':
        begin
          J := -1;
          for I := 0 to Token.Count - 1 do
          begin
            if Token.Items[I].Token = tkVariable then
            begin
              Inc(J);
              if ParamIndex = J then
                Break;
            end;
          end;
          if ParamIndex <> J then
          begin
            HintParams.Cancel;
            Exit;
          end;
          Scope := Token;
          Token := Token.Items[I];
          if Token.Token = tkVariable then
          begin
            Input := GetVarType(Token.Flag);
            if StringIn(Input, ReservedTypes) or
              (not scope.SearchToken(Input, '', Token, 0, False, [tkStruct,
                tkTypeStruct, tkUnion, tkTypeUnion]) and
              not FilesParsed.GetBaseType(Input, 0, TokenFileItem,
                TokenFileItem, Token)) then
            begin
              HintParams.Cancel;
              Exit;
            end;
          end;
          ParamIndex := 0;
        end;
        ',':
        begin
          Inc(ParamIndex);
        end;
      end;
      StructParams := Copy(StructParams, 2, Length(StructParams) - 1);
    end;
    P := Memo.RowColumnToPixels(Memo.BufferToDisplayPos(BufferCoordStart));
    P := Memo.ClientToScreen(P);
    ParamsList := TStringList.Create;
    Params := GetStructProto(Token);
    ParamsList.Add(Params);
    HintTip.Cancel;
    DebugHint.Cancel;
    HintParams.UpdateHint(ParamsList, ParamIndex, P.X, P.Y);
    ParamsList.Free;
    Exit;
  end;
  BufferCoordEnd := Memo.GetMatchingBracketEx(BufferCoordStart);
  if (BufferCoordEnd.Char > 0) and (BufferCoordEnd.Line > 0) then
  begin
    BracketEnd := Memo.RowColToCharIndex(BufferCoordEnd);
    Params := Copy(TempText, BracketStart + 2, BracketEnd - BracketStart - 1);
  end
  else
    Params := Copy(TempText, BracketStart + 2, SelStart - BracketStart - 1);
  if not ParseFields(TempText, BracketStart, Input, Fields, InputError) then
  begin
    HintParams.Cancel;
    Exit;
  end;

  SaveFields := Fields;
  SaveInput := Input;
  Fields := Fields + Input;
  Input := GetFirstWord(Fields);
  ParamsList := TStringList.Create;
  TokenFileItem := ActiveEditingFile;
  //show function params
  if not FilesParsed.GetFieldsBaseParams(Input, Fields, BracketStart,
    TokenFileItem, ParamsList) then
  begin
    if ActiveEditingFile.GetScopeAt(Token, BracketStart) then
    begin
      if (Token.Token in [tkNamespace]) then
      begin
        SaveFields := Token.Name + '::' + SaveFields;
        while Assigned(Token.Parent) and (Token.Parent.Token in [tkNamespace]) do
        begin
          Token := Token.Parent;
          SaveFields := Token.Name + '::' + SaveFields;
        end;
      end;
      if (SaveInput <> '') and (SaveFields <> '') and
        FilesParsed.SearchTreeToken(SaveFields, TokenFileItem, TokenFileItem,
        Token, [tkClass, tkNamespace], Token.SelStart) then
      begin
        scope := GetTokenByName(Token, 'Scope', tkScope);
        if Assigned(scope) and not FilesParsed.SearchSource(SaveInput,
          TokenFileItem, TokenFileItem, Token, scope.SelStart, ParamsList,
          True) then
        begin
          ParamsList.Free;
          HintParams.Cancel;
          Exit;
        end;
      end
      else
      begin
        ParamsList.Free;
        HintParams.Cancel;
        Exit;
      end;
    end
    else
    begin
      ParamsList.Free;
      HintParams.Cancel;
      Exit;
    end;
  end;
  ParamIndex := SelStart - BracketStart - 1;
  ParamIndex := CommaCountAt(Params, ParamIndex);
  P := Memo.RowColumnToPixels(Memo.BufferToDisplayPos(BufferCoordStart));
  P := Memo.ClientToScreen(P);

  for I := ParamsList.Count - 1 downto 0 do
  begin
    Token := TTokenClass(ParamsList.Objects[I]);
    if not (Token.Token in [tkConstructor, tkFunction, tkPrototype,
      tkTypedefProto, tkOperator]) then
    begin
      ParamsList.Delete(I);
      Continue;
    end;
    tokenParams := GetTokenByName(Token, 'Params', tkParams);
    if (ParamIndex >= tokenParams.Count) and (ParamIndex > 0) then
    begin
      ParamsList.Delete(I);
      Continue;
    end;
    S := MakeTokenParamsHint(Token);
    if S = '' then
      S := 'void';
    ParamsList.Strings[I] := S;
  end;
  if ParamsList.Count = 0 then
  begin
    ParamsList.Free;
    HintParams.Cancel;
    Exit;
  end;
  ParamsList.CustomSort(SortCompareParams);
  HintTip.Cancel;
  DebugHint.Cancel;
  HintParams.UpdateHint(ParamsList, ParamIndex, P.X, P.Y);
  ParamsList.Free;
end;

procedure TFrmFalconMain.ParserStart(Sender: TObject);
begin
  if not ThreadFilesParsed.Busy then
    ProgressBarParser.Position := 0;
  ProgressBarParser.Show;
end;

procedure TFrmFalconMain.ParserProgress(Sender: TObject; TokenFile: TTokenFile;
  const FileName: string; Current, Total: Integer; Parsed: Boolean;
  Method: TTokenParseMethod);
begin
  if not ThreadFilesParsed.Busy then
    ProgressBarParser.Position := (Current * 100) div Total;
end;

procedure TFrmFalconMain.ParserFinish(Sender: TObject; Canceled: Boolean);
var
  ini: TIniFile;
begin
  if IsLoadingSrcFiles then
  begin
    if not Canceled then
    begin
      ini := TIniFile.Create(IniConfigFile);
      ini.WriteInteger('Packages', 'NewInstalled', 0);
      ini.Free;
    end;
    IsLoadingSrcFiles := False;
  end;
  if not ThreadLoadTkFiles.Busy and not ThreadFilesParsed.Busy then
    ProgressBarParser.Hide;
end;

procedure TFrmFalconMain.AllParserStart(Sender: TObject);
begin
  ProgressBarParser.Position := 0;
  ProgressBarParser.Show;
end;

procedure TFrmFalconMain.AllParserProgress(Sender: TObject; TokenFile: TTokenFile;
  const FileName: string; Current, Total: Integer; Parsed: Boolean;
  Method: TTokenParseMethod);
begin
  if not Parsed then
    Exit;
  //don't wait for parse all files: update  now grayed project and outline
  if ActiveEditingFile.Data = TokenFile.Data then
    UpdateActiveFileToken(TokenFile);
  AllParsedList.AddObject('', TokenFile);
  if Total > 0 then
    ProgressBarParser.Position := (Current * 100) div Total;
end;

procedure TFrmFalconMain.AllParserFinish(Sender: TObject; Canceled: Boolean);
var
  I: Integer;
  FileToken: TTokenFile;
begin
  for I := 0 to AllParsedList.Count - 1 do
  begin
    FileToken := TTokenFile(AllParsedList.Objects[I]);
    TextEditorFileParsed(TSourceFile(FileToken.Data), FileToken);
  end;
  AllParsedList.Clear;
  //update grayed project and outline
  PageControlEditorPageChange(PageControlEditor,
    PageControlEditor.ActivePageIndex, -1);
  if not ThreadLoadTkFiles.Busy and not ThreadTokenFiles.Busy then
    ProgressBarParser.Hide;
end;

procedure TFrmFalconMain.TokenParserStart(Sender: TObject);
begin
//
end;

procedure TFrmFalconMain.TokenParserProgress(Sender: TObject;
  TokenFile: TTokenFile; const FileName: string; Current, Total: Integer;
  Parsed: Boolean; Method: TTokenParseMethod);
begin
  if not ThreadTokenFiles.Busy and not ThreadFilesParsed.Busy and (ProgressBarParser.Tag <> 1) then
  begin
    ProgressBarParser.Show;
    ProgressBarParser.Tag := 1;
    ProgressbarSetMarqueue(ProgressBarParser);
  end;
end;

procedure TFrmFalconMain.TokenParserFinish(Sender: TObject; Canceled: Boolean);
begin
  //
end;

procedure TFrmFalconMain.TokenParserAllFinish(Sender: TObject);
begin
  ProgressBarParser.Tag := 0;
  ProgressbarSetNormal(ProgressBarParser);
  if not ThreadTokenFiles.Busy and not ThreadFilesParsed.Busy then
    ProgressBarParser.Hide;
end;

procedure TFrmFalconMain.ProcessDebugHint(Input: string; Line, SelStart: integer;
  CursorPos: TPoint);
var
  token: TTokenClass;
  tokenFile: TTokenFile;
begin
  if not CommandQueue.Empty then
    Exit;
  token := nil;
  if not FilesParsed.GetFieldsBaseType(GetFirstWord(Input), Input,
    SelStart, ActiveEditingFile, tokenFile, token) then
  begin
    FilesParsed.GetFieldsBaseType(GetFirstWord(Input), Input,
      SelStart + Length(Input), ActiveEditingFile, tokenFile, token);
  end;
  CommandQueue.Push(dctPrint, GDB_PRINT, DebugReader.LastPrintID + 1, Input,
    Line, SelStart, token, CursorPos);
  DebugReader.SendCommand(GDB_PRINT, Input);
end;

procedure TFrmFalconMain.ProcessHintView(FileProp: TSourceFile;
  Memo: TEditor; const X, Y: Integer);

  function BufferIn(BS, Buffer, BE: TBufferCoord): Boolean;
  begin
    Result := (BS.Line = Buffer.Line) and (BS.Char <= Buffer.Char) and
      (BE.Line = Buffer.Line) and (BE.Char >= Buffer.Char);
  end;

var
  Fields, Input: string;
  S: UnicodeString;
  DisplayCoord: TDisplayCoord;
  BC, WordStart: TBufferCoord;
  Token: TTokenClass;
  TokenFileItem: TTokenFile;
  P: TPoint;
  InputError: Boolean;
  WordStartPos, I: Integer;
  attri: THighlighStyle;
begin
  if not Config.Editor.TooltipSymbol then
    Exit;
  DisplayCoord := Memo.PixelsToRowColumn(X, Y);
  BC := Memo.DisplayToBufferPos(DisplayCoord);
  if BC.Line > 0 then
  begin
    //after end line
    if BC.Char > Length(Memo.Lines.Strings[BC.Line - 1]) then
    begin
      HintTip.Cancel;
      DebugHint.Cancel;
      CanShowHintTip := False;
      Exit;
    end;
  end;
  I := Memo.RowColToCharIndex(BC);
  WordStart := Memo.WordStartEx(BC);
  WordStartPos := Memo.RowColToCharIndex(WordStart);
  //running application
  if Executor.Running then
  begin
    HintTip.Cancel;
    DebugHint.Cancel;
    CanShowHintTip := False;
    Exit;
  end;

  if (LastWordHintStart = WordStartPos) and
    (HintTip.Activated or DebugHint.Activated) then
    Exit;
  LastWordHintStart := WordStartPos;
  if Memo.GetHighlighterAttriAtRowCol(BC, S, attri) then
  begin
    //invalid attribute
    if ((not StringIn(attri.Name, ['Identifier', HL_Style_Preprocessor]) or
        (Pos('include', S) > 0)) and not DebugReader.Running) or
       ((Memo.Highlighter.IsComment(attri) or Memo.Highlighter.IsString(attri) or
       (attri.Name = HL_Style_Preprocessor)) and DebugReader.Running) then
    begin
      HintTip.Cancel;
      DebugHint.Cancel;
      CanShowHintTip := False;
      Exit;
    end;
  end;
  //evaluate/modify with selection
  if DebugReader.Running and Memo.SelAvail and
    BufferIn(Memo.BlockBegin, BC, Memo.BlockEnd) then
  begin
    DisplayCoord := Memo.BufferToDisplayPos(Memo.BlockBegin);
    P := Memo.RowColumnToPixels(DisplayCoord);
    P := Memo.ClientToScreen(P);
    ProcessDebugHint(Memo.SelText, BC.Line, I, P);
    Exit;
  end;
  Input := Memo.GetWordAtRowCol(BC);
  DisplayCoord := Memo.BufferToDisplayPos(WordStart);
  P := Memo.RowColumnToPixels(DisplayCoord);
  P := Memo.ClientToScreen(P);
  if ParseFields(Memo.Lines.Text, I, Input, Fields, InputError) then
  begin
    // show Debug hint
    if DebugReader.Running then
    begin
      if Input <> '' then
      begin
        ProcessDebugHint(Fields + Input, BC.Line, I, P);
      end
      else
      begin
        //empty text on mouse
        DebugHint.Cancel;
        HintTip.Cancel;
        CanShowHintTip := False;
      end;
      Exit;
    end;
    // show hint
    if FilesParsed.FindDeclaration(Input, Fields, ActiveEditingFile, TokenFileItem,
      Token, I, BC.Line) then
    begin
      S := MakeTokenHint(Token, TokenFileItem.FileName);
      HintTip.UpdateHint(S, Token.Comment, P.X, P.Y + Memo.LineHeight + 4,
        GetTokenImageIndex(Token, OutlineImages));
      Exit;
    end;
  end;
  //none others
  HintTip.Cancel;
  DebugHint.Cancel;
  CanShowHintTip := False;
  Exit;
end;

procedure TFrmFalconMain.TimerHintTipEventTimer(Sender: TObject);
var
  P: TPoint;
  sheet: TSourceFileSheet;
  FileProp: TSourceFile;
begin
  TimerHintTipEvent.Enabled := False;
  CanShowHintTip := True;
  if not HintParams.Activated then
  begin
    if not GetActiveSheet(sheet) then
      Exit;
    if not GetActiveFile(FileProp) then
      Exit;
    P := sheet.Memo.ScreenToClient(Mouse.CursorPos);
    ProcessHintView(FileProp, sheet.Memo, P.X, P.Y);
  end;
end;

function TFrmFalconMain.FillIncludeList(IncludePathFilesOnly: Boolean): Boolean;
var
  NewToken: TTokenClass;
  sheet: TSourceFileSheet;
  proj: TProjectFile;
  S: string;
  I, J, LastStart: Integer;
  List: TStrings;
begin
  Result := True;
  if not GetActiveSheet(sheet) then
    Exit;
  proj := sheet.SourceFile.Project;
  if IncludePathFilesOnly then
  begin
    if FIncludeFileListFlag = 2 then
    begin
      FindFiles(Config.Compiler.Path + '\include\', '*.h', FIncludeFileList);
      for I := 0 to FIncludeFileList.Count - 1 do
        FIncludeFileList.Strings[I] := ConvertToUnixSlashes(ExtractRelativePath(Config.Compiler.Path + '\include\', FIncludeFileList.Strings[I]));
      Dec(FIncludeFileListFlag);
    end;
    if FIncludeFileListFlag = 1 then
    begin
      J := FIncludeFileList.Count;
      S := Config.Compiler.Path + '\lib\gcc\mingw32\' + Config.Compiler.Version + '\include\';
      FindFiles(S, '*.*', FIncludeFileList);
      for I := J to FIncludeFileList.Count - 1 do
      begin
        FIncludeFileList.Strings[I] := ConvertToUnixSlashes(ExtractRelativePath(S, FIncludeFileList.Strings[I]));
        if StartsWith(FIncludeFileList.Strings[I], 'c++/') then
          FIncludeFileList.Strings[I] := Copy(FIncludeFileList.Strings[I], 5,
            Length(FIncludeFileList.Strings[I]) - 4);
      end;
      Dec(FIncludeFileListFlag);
    end;
    S := ExtractFilePath(proj.FileName);
    if CompareText(S, FLastProjectIncludePath) <> 0 then
    begin
      FLastProjectIncludePath := S;
      for I := 0 to FProjectIncludePathList.Count - 1 do
        TTokenClass(FProjectIncludePathList.Objects[I]).Free;
      FProjectIncludePathList.Clear;
      List := TStringList.Create;
      GetIncludeDirs(S, proj.Flags, List);
      LastStart := 0;
      for I := 0 to List.Count - 1 do
      begin
        S := ConvertSlashes(List[I]);
        FindFiles(S, '*.h', FProjectIncludePathList);
        for J := LastStart to FProjectIncludePathList.Count - 1 do
        begin
          NewToken := TTokenClass.Create;
          FProjectIncludePathList.Objects[J] := NewToken;
          NewToken.Name := ConvertToUnixSlashes(ExtractRelativePath(S, FProjectIncludePathList.Strings[J]));
          NewToken.Flag := 'S';
          NewToken.Token := tkInclude;
        end;
        LastStart := FProjectIncludePathList.Count;
      end;
      List.Free;
    end;
    // project include path
    for I := 0 to FProjectIncludePathList.Count - 1 do
    begin
      NewToken := TTokenClass(FProjectIncludePathList.Objects[I]);
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken, CompletionColors, OutlineImages), NewToken);
    end;
    // compiler include path
    for I := 0 to FIncludeFileList.Count - 1 do
    begin
      if FIncludeFileList.Objects[I] = nil then
      begin
        NewToken := TTokenClass.Create;
        FIncludeFileList.Objects[I] := NewToken;
        NewToken.Name := FIncludeFileList.Strings[I];
        NewToken.Flag := 'S';
        NewToken.Token := tkInclude;
      end
      else
        NewToken := TTokenClass(FIncludeFileList.Objects[I]);
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken, CompletionColors, OutlineImages), NewToken);
    end;
    Exit;
  end;
  S := ExtractFilePath(sheet.SourceFile.FileName);
  if CompareText(S, FLastPathInclude) <> 0 then
  begin
    FLastPathInclude := S;
    for I := 0 to ProjectIncludeList.Count - 1 do
      TTokenClass(ProjectIncludeList.Objects[I]).Free;
    ProjectIncludeList.Clear;
    List := TStringList.Create;
    proj.GetFiles(List);
    for I := 0 to List.Count - 1 do
    begin
      if (TSourceFile(List.Objects[I]).FileType <> FILE_TYPE_H) then
        Continue;
      NewToken := TTokenClass.Create;
      NewToken.Name := ConvertToUnixSlashes(ExtractRelativePath(S, List.Strings[I]));
      NewToken.Flag := 'L';
      NewToken.Token := tkInclude;
      ProjectIncludeList.AddObject(NewToken.Name, NewToken);
      if (List.Objects[I] = sheet.SourceFile) then
        Continue;
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken, CompletionColors, OutlineImages), NewToken);
    end;
    List.Free;
  end
  else
  begin
    for I := 0 to ProjectIncludeList.Count - 1 do
    begin
      NewToken := TTokenClass(ProjectIncludeList.Objects[I]);
      if (NewToken.Data = sheet.SourceFile) then
        Continue;
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken), NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken, CompletionColors, OutlineImages), NewToken);
    end;
  end;
end;

procedure TFrmFalconMain.CodeCompletionExecute(Kind: TSynCompletionType;
  Sender: TObject; var CurrentInput: string; var x, y: Integer;
  var CanExecute: Boolean);
var
  Fields, Input, SaveInput, LineStr: string;
  S: UnicodeString;
  sheet: TSourceFileSheet;
  TokenItem: TTokenFile;
  SelStart, LineLen: integer;
  Token, Scope, SaveScope: TTokenClass;
  AllScope: Boolean;
  AllowScope: TScopeClassState;
  Buffer, SaveBuffer: TBufferCoord;
  Attri: THighlighStyle;
  InputError, SkipFirst: Boolean;
begin
  fShowCodeCompletion := 0;
  Input := '';
  CanExecute := False;
  if not Config.Editor.CodeCompletion then
    Exit;
  if not GetActiveSheet(sheet) then
    Exit;
  //get valid SelStart
  Buffer := sheet.Memo.CaretXY;
  LineStr := '';
  if (Buffer.Line > 0) then
  begin
    LineStr := sheet.Memo.Lines[Buffer.Line - 1];
    LineLen := Length(LineStr);
    if (Buffer.Char > LineLen + 1) then
    begin
      Buffer.Char := LineLen + 1;
      LineStr := Copy(LineStr, 1, Buffer.Char - 2);
    end
    else
      LineStr := Copy(LineStr, 1, Buffer.Char - 1);
  end;
  SaveBuffer := Buffer;
  CodeCompletion.ItemList.Clear;
  CodeCompletion.InsertList.Clear;
  if sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
  begin
    if sheet.Memo.Highlighter.IsComment(Attri) or
       sheet.Memo.Highlighter.IsString(Attri) or
      (Attri.Name = HL_Style_Preprocessor) then
    begin
      Dec(Buffer.Char);
      if (Attri.Name <> HL_Style_Preprocessor) and
        sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
      begin
        if sheet.Memo.Highlighter.IsComment(Attri) or
           sheet.Memo.Highlighter.IsString(Attri) or
          (Attri.Name = HL_Style_Preprocessor) then
        begin
          if (Attri.Name = HL_Style_Preprocessor) and (Pos('include', LineStr) > 0) and
            (Pos('>', LineStr) = 0) and (CountChar(LineStr, '"') <= 1) and
            ((Pos('<', LineStr) > 0) or (Pos('"', LineStr) > 0)) then
          begin
            if not FillIncludeList(Pos('<', LineStr) > 0) then
              Exit;
            DebugHint.Cancel;
            HintTip.Cancel;
            CanExecute := True;
          end;
          Exit;
        end;
        Inc(Buffer.Char);
      end
      else
      begin
        if (Attri.Name = HL_Style_Preprocessor) and (Pos('include', LineStr) > 0) and
          (Pos('>', LineStr) = 0) and (CountChar(LineStr, '"') <= 1) and
            ((Pos('<', LineStr) > 0) or (Pos('"', LineStr) > 0)) then
        begin
          if not FillIncludeList(Pos('<', LineStr) > 0) then
            Exit;
          DebugHint.Cancel;
          HintTip.Cancel;
          CanExecute := True;
        end;
        Exit;
      end;
    end;
  end
  else if (Buffer.Char > 1) then
  begin
    Dec(Buffer.Char);
    if sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
    begin
      if sheet.Memo.Highlighter.IsComment(Attri) or
         sheet.Memo.Highlighter.IsString(Attri) or
        (Attri.Name = HL_Style_Preprocessor) then
      begin
        Dec(Buffer.Char);
        if (Attri.Name <> HL_Style_Preprocessor) and
          sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
        begin
          if sheet.Memo.Highlighter.IsComment(Attri) or
             sheet.Memo.Highlighter.IsString(Attri) or
            (Attri.Name = HL_Style_Preprocessor) then
          begin
            if (Attri.Name = HL_Style_Preprocessor) and (Pos('include', LineStr) > 0)
              and (Pos('>', LineStr) = 0) and (CountChar(LineStr, '"') <= 1) and
            ((Pos('<', LineStr) > 0) or (Pos('"', LineStr) > 0)) then
            begin
              if not FillIncludeList(Pos('<', LineStr) > 0) then
                Exit;
              DebugHint.Cancel;
              HintTip.Cancel;
              CanExecute := True;
            end;
            Exit;
          end;
          Inc(Buffer.Char);
        end
        else
        begin
          if (Attri.Name = HL_Style_Preprocessor) and (Pos('include', LineStr) > 0)
            and (Pos('>', LineStr) = 0) and (CountChar(LineStr, '"') <= 1) and
            ((Pos('<', LineStr) > 0) or (Pos('"', LineStr) > 0)) then
          begin
            if not FillIncludeList(Pos('<', LineStr) > 0) then
              Exit;
            DebugHint.Cancel;
            HintTip.Cancel;
            CanExecute := True;
          end
          // show preprocessors code completion list
          else if Pos(' ', LineStr) = 0 then
          begin
            if ParseFields(sheet.Memo.Lines.Text, sheet.Memo.RowColToCharIndex(SaveBuffer), SaveInput, Fields, InputError) then
              Input := GetFirstWord(Fields);
            if InputError then
              Exit;
            AddTemplates(Input, tkUnknow, CodeCompletion.InsertList,
              CodeCompletion.ItemList, CompletionColors, OutlineImages,
              sheet.SourceFile.Project.CompilerType, [tkInclude, tkDefine]);
            CanExecute := CodeCompletion.InsertList.Count > 0;
          end;
          Exit;
        end;
      end;
    end;
    Inc(Buffer.Char);
  end;
  if ParseFields(sheet.Memo.Lines.Text, sheet.Memo.RowColToCharIndex(SaveBuffer), SaveInput, Fields, InputError) then
    Input := GetFirstWord(Fields);
  if InputError then
    Exit;
  if not UsingCtrlSpace and (LastKeyPressed = '>') and ((Length(Fields) < 2) or
    ((Length(Fields) > 1) and (Fields[Length(Fields) - 1] <> '-'))) then
    Exit;
  SelStart := sheet.Memo.RowColToCharIndex(Buffer);
  //Temp skip Scope:
  if (Buffer.Line > 0) then
  begin
    LineStr := sheet.Memo.Lines[Buffer.Line - 1];
    LineLen := Length(LineStr);
    if (Buffer.Char - 1 <= LineLen) and (Buffer.Char - 1 > 0) then
    begin
      if LineStr[Buffer.Char - 1] = ':' then
      begin
        if (Buffer.Char - 1 > 1) then
        begin
          if LineStr[Buffer.Char - 2] <> ':' then
            Exit;
        end
        else
          Exit;
      end;
    end;
  end;
  //End temp
  if TimerChangeDelay.Enabled then
  begin
    Inc(fShowCodeCompletion);
    TimerChangeDelay.Enabled := False;
    TimerChangeDelayTimer(TimerChangeDelay);
  end
  else if TParserThread(fWorkerThread).Busy then
    Inc(fShowCodeCompletion);
  if fShowCodeCompletion > 0 then
  begin
    CanExecute := False;
    Exit;
  end;
  if Input <> '' then
  begin
    if ActiveEditingFile.GetScopeAt(Token, SelStart) then
    begin
      if (Token.Token in [tkNamespace]) then
      begin
        Fields := Token.Name + '::' + Fields;
        while Assigned(Token.Parent) and (Token.Parent.Token in [tkNamespace]) do
        begin
          Token := Token.Parent;
          Fields := Token.Name + '::' + Fields;
        end;
      end;
      if (Fields <> '') and FilesParsed.SearchTreeToken(Fields, ActiveEditingFile,
        TokenItem, Token, [tkClass, tkNamespace], Token.SelStart) then
      begin
        AllowScope := [];
        FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
          CodeCompletion.ItemList, CompletionColors, OutlineImages, TokenItem, Token, AllowScope);
        DebugHint.Cancel;
        HintTip.Cancel;
        CanExecute := True;
        Exit;
      end;
    end;
    //search base type and list fields and functions of struct, union or class
    if FilesParsed.GetFieldsBaseType(Input, Fields,
      SelStart, ActiveEditingFile, TokenItem, Token) then
    begin
      //show private fields only on implementation scope
      AllowScope := [];
      if ActiveEditingFile.GetScopeAt(Scope, sheet.memo.SelStart) then
      begin
        SaveScope := Scope;
        Scope := GetTokenByName(Scope, 'Scope', tkScope);
        AllScope := Assigned(Scope) and (Scope.Flag = Token.Name);
        if not AllScope then
        begin
          SaveScope := SaveScope.Parent;
          if Assigned(SaveScope) and (SaveScope.Token = tkScopeClass) then
            SaveScope := SaveScope.Parent;
          if Assigned(SaveScope) and (SaveScope.Name = Token.Name) then
            AllScope := True;
        end;
      end
      else
        AllScope := Pos('::', Fields) > 0;
      if not AllScope then
        AllowScope := AllowScope + [scPublic];
      FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, OutlineImages, TokenItem, Token, AllowScope);
      DebugHint.Cancel;
      HintTip.Cancel;
      CanExecute := True;
      Exit;
    end;
    Exit; //WARNNING cin. if cin not found then does not show code completion
  end;
  //get current object in location
  if ActiveEditingFile.GetScopeAt(Token, SelStart) then
  begin
    SaveScope := Token;
    AllScope := False;
    //fill first all object in finded object location
    FillCompletionTree(CodeCompletion.InsertList,
      CodeCompletion.ItemList, Token, SelStart,
      CompletionColors, OutlineImages, [], True);
    if Fields = '' then
      AddTemplates(CurrentInput, Token.Token, CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, OutlineImages,
        sheet.SourceFile.Project.CompilerType);
    { TODO -oMazin -c : while parent is not nil fill objects 24/08/2012 22:27:26 }
    //get parent of Token
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkClass, tkStruct, tkScopeClass]) then
    begin
      Token := Token.Parent;
      TokenItem := ActiveEditingFile;
      AllScope := True;
    end;
    //tree parent object?
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkClass, tkStruct]) then
    begin
      Token := Token.Parent;
    end;
    AllowScope := [];
    SkipFirst := False;
    //Get class of scope
    Scope := GetTokenByName(Token, 'Scope', tkScope);
    if not AllScope and Assigned(Scope) and (Scope.Flag <> '') then
    begin
      Fields := Scope.Flag;
      while Assigned(Token.Parent) and (Token.Parent.Token in [tkNamespace]) do
      begin
        Token := Token.Parent;
        Fields := Token.Name + '::' + Fields;
      end;
      AllScope := FilesParsed.SearchTreeToken(Fields, ActiveEditingFile,
        TokenItem, Token, [tkClass, tkNamespace], Token.SelStart);
    end
    else if not AllScope and (SaveScope.Token in [tkClass, tkStruct, tkUnion]) then
    begin
      TokenItem := ActiveEditingFile;
      SkipFirst := True;
      AllowScope := [scProtected, scPublic];
      Token := SaveScope;
      AllScope := True;
    end
    else if (Token.Token in [tkNamespace]) then
    begin
      Fields := Token.Name;
      while Assigned(Token.Parent) and (Token.Parent.Token in [tkNamespace]) do
      begin
        Token := Token.Parent;
        Fields := Token.Name + '::' + Fields;
      end;
      AllScope := FilesParsed.SearchTreeToken(Fields, ActiveEditingFile,
        TokenItem, Token, [tkClass, tkNamespace], Token.SelStart);
    end;
    //show all objects from class, struct or scope
    if AllScope then
    begin
      FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, OutlineImages, TokenItem,
        Token, AllowScope, SkipFirst);
    end;
  end
  else if Fields = '' then
    AddTemplates(CurrentInput, tkUnknow, CodeCompletion.InsertList,
      CodeCompletion.ItemList, CompletionColors, OutlineImages,
      sheet.SourceFile.Project.CompilerType);


  FilesParsed.FillCompletionList(CodeCompletion.InsertList,
    CodeCompletion.ItemList, ActiveEditingFile, SelStart,
    CompletionColors, OutlineImages);
  DebugHint.Cancel;
  HintTip.Cancel;
  CanExecute := True;
end;

procedure TFrmFalconMain.CodeCompletionGetWordBreakChars(Sender: TObject;
  var WordBreakChars, ScanBreakChars: String);
var
  sheet: TSourceFileSheet;
  bCoord: TBufferCoord;
  LineStr: string;
  S: UnicodeString;
  LineLen: Integer;
  Attri: THighlighStyle;
begin
  WordBreakChars := CodeCompletion.EndOfTokenChr;
  if not GetActiveSheet(sheet) then
    Exit;
  bCoord := sheet.Memo.CaretXY;
  LineStr := '';
  if (bCoord.Line > 0) then
  begin
    LineStr := sheet.Memo.Lines[bCoord.Line - 1];
    LineLen := Length(LineStr);
    if (bCoord.Char > LineLen) then
      bCoord.Char := LineLen;
  end;
  if sheet.Memo.GetHighlighterAttriAtRowCol(bCoord, S, Attri) then
  begin
    if (Attri.Name = HL_Style_Preprocessor) then
    begin
      WordBreakChars := '<>"';
      ScanBreakChars := '<>"';
    end;
  end;
end;

function TFrmFalconMain.ShowPromptOverrideFile(const FileName: string): Boolean;
begin
  Result := InternalMessageBox(PChar(Format(STR_FRM_MAIN[54],
    [FileName])), 'Falcon C++', MB_ICONWARNING + MB_YESNOCANCEL) = IDYES;
end;

procedure TFrmFalconMain.CodeCompletionGetWordEndChars(Sender: TObject;
  var WordEndChars: String; Index: Integer; var Handled: Boolean);
var
  Token: TTokenClass;
begin
  Token := TTokenClass(CodeCompletion.ItemList.Objects[Index]);
  if Token.Token = tkInclude then
  begin
    Handled := True;
    WordEndChars := '>"';
  end;
end;

procedure TFrmFalconMain.CodeCompletionCodeCompletion(Sender: TObject;
  var Value: string; Shift: TShiftState; Index: Integer; var EndToken: Char;
  var OffsetCaret: Integer);
var
  Token, Params, ClassToken: TTokenClass;
  NextChar: Char;
  LineStr, S: string;
  sheet: TSourceFileSheet;
  BalancingBracket, SelStart, Len, AfterLen, I: Integer;
  p: TBufferCoord;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Token := TTokenClass(CodeCompletion.ItemList.Objects[Index]);
  if EndToken = ')' then
  begin
    Value := Value + '('
  end
  else if Token.Token in [tkFunction, tkPrototype] then
  begin
    SelStart := sheet.Memo.RowColToCharIndex(sheet.Memo.CaretXY);
    if ActiveEditingFile.GetScopeAt(ClassToken, SelStart) and
      (ClassToken.Token in [tkClass, tkStruct, tkUnion]) then
    begin
      p := sheet.Memo.CaretXY;
      Len := Length(CodeCompletion.CurrentString);
      AfterLen := 0;
      LineStr := sheet.Memo.Lines[p.Line - 1];
      for I := p.Char to Length(LineStr) do
      begin
        if CharInSet(LineStr[I], LetterChars + DigitChars) then
          Inc(AfterLen)
        else
          Break;
      end;
      S := GeneratePrototype(Token, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4, 0);
      if CountWords(LineStr) > 1 then
      begin
        if ((AfterLen > 0) and (Trim(Copy(LineStr, AfterLen, MaxInt)) = '')) or (p.Char > Length(LineStr)) then
          S := Token.Name + Copy(S, Pos('(', S), MaxInt)
        else
          S := Token.Name;
      end;
      sheet.Memo.BeginUpdate;
      sheet.Memo.BlockBegin := BufferCoord(p.Char - Len, p.Line);
      sheet.Memo.BlockEnd := BufferCoord(p.Char + AfterLen, p.Line);
      sheet.Memo.SelText := S;
      sheet.Memo.EndUpdate;
      Value := '';
      Exit;
    end;
    NextChar := GetNextValidChar(sheet.Memo.Lines.Text, sheet.Memo.SelStart);
    if EndToken <> '(' then
    begin
      Params := GetTokenByName(Token, 'Params', tkParams);
      BalancingBracket := sheet.Memo.GetBalancingBracketEx(sheet.Memo.CaretXY, '(');
      if CharInSet(NextChar, LetterChars + ['{', '}']) and (EndToken <> ';') then
      begin
        Value := Value + '();';
        if (Params <> nil) and (Params.Count > 0) then
          Dec(OffsetCaret, 2); // set caret at middle of () when parameters count grater than one
      end
      else if CharInSet(NextChar, DigitChars + ArithmChars + CloseBraceChars + [';']) or
        (EndToken = ';') then
      begin
        if BalancingBracket <= 0 then
        begin
          Value := Value + '()';
          if (Params <> nil) and (Params.Count > 0) then
            Dec(OffsetCaret); // set caret at middle of () when parameters count grater than one
        end
        else
          Value := Value + '(';
      end
      else if NextChar <> '(' then
        Value := Value + '('
      else
      //TODO: use NextChar position
        Inc(OffsetCaret); // set caret after (
      LastKeyPressed := '(';
    end;
  end
  else if Token.Token = tkInclude then
  begin
    LineStr := '';
    if sheet.Memo.CaretY <= sheet.Memo.Lines.Count then
      LineStr := Trim(sheet.Memo.Lines.Strings[sheet.Memo.CaretY - 1]);
    NextChar := #0;
    if Length(LineStr) > 0 then
      NextChar := LineStr[Length(LineStr)];
    if (Pos('<', LineStr) > 0) and (EndToken <> '>') and (NextChar <> '>') then
      Value := Value + '>'
    else if (Pos('"', LineStr) > 0) and (EndToken <> '"') and
      ((NextChar <> '"') or (CountChar(LineStr, '"') = 1)) then
      Value := Value + '"'
    else if CharInSet(NextChar, ['"', '>']) then
      Inc(OffsetCaret);
  end
  else if (Token.Token = tkCodeTemplate) and (Token.Flag <> '') then
  begin
    Value := '';
    ExecuteCompletion(CodeCompletion.CurrentString, Token, sheet.Memo);
  end;
end;

procedure TFrmFalconMain.CodeCompletionAfterCodeCompletion(Sender: TObject;
  const Value: string; Shift: TShiftState; Index: Integer; var EndToken: Char);
begin
  CodeCompletion.ItemList.Clear;
  CodeCompletion.InsertList.Clear;
  if LastKeyPressed = '(' then
    TimerHintParams.Enabled := True;
end;

procedure TFrmFalconMain.CodeCompletionClose(Sender: TObject);
begin
  if ReloadAfterCodeCompletion then
  begin
    TimerChangeDelay.Enabled := False;
    TimerChangeDelay.Enabled := True;
    ReloadAfterCodeCompletion := False;
  end;
end;

procedure TFrmFalconMain.AddMessage(const FileName, Title, Msg: string; Line,
  Column, EndColumn: Integer; MsgType: TMessageItemType;
  AlignCenter: Boolean);
var
  MsgItem: TMessageItem;
  Item: TListItem;
begin
  MsgItem := TMessageItem.Create;
  MsgItem.MsgType := MsgType;
  MsgItem.FileName := FileName;
  MsgItem.Msg := Msg;
  MsgItem.Line := Line;
  MsgItem.Col := Column;
  MsgItem.EndCol := EndColumn;
  Item := ListViewMsg.Items.Add;
  Item.Caption := Title;
  if MsgType = mitGoto then
    Item.ImageIndex := 32
  else
    Item.ImageIndex := 48;
  Item.SubItems.Add(IntToStr(Line));
  Item.SubItems.Add(Msg);
  Item.Data := MsgItem;
  if AlignCenter then
    ListViewMsg.Scroll(0, Item.Top - (ListViewMsg.Height div 2));
end;

procedure TFrmFalconMain.PaintTokenItemV2(const ToCanvas: TCanvas;
  DisplayRect: TRect; Token: TTokenClass; Selected, Focused: Boolean;
  var DefaultDraw: Boolean);
var
  Flag, FullFlag, Vector, Params: string;
  HasVector, ChangeTextColor: Boolean;
  I, Len, TopOffset: Integer;
begin
  DefaultDraw := False;
  if Token.Token in [tkInclude, tkTypedefProto, tkIncludeList, tkDefineList,
    tkTreeObjList, tkVarConsList, tkFuncProList] then
  begin
    DefaultDraw := True;
    Exit;
  end;
  ChangeTextColor := not Selected;
  TopOffset := (DisplayRect.Bottom - DisplayRect.Top - ToCanvas.TextHeight('Wj[')) div 2;
  if Token.Token in [tkFunction, tkProtoType, tkConstructor, tkDestructor, tkOperator] then
  begin
    if Token.Token = tkOperator then
      Params := GetFuncScope(Token) + 'operator ' + Token.Name + GetFuncProtoTypes(Token)
    else
      Params := GetFuncScope(Token) + Token.Name + GetFuncProtoTypes(Token);
    Flag := Token.Flag;
    if Flag = '' then
      DisplayRect.Right := DisplayRect.Left + 5 +
        ToCanvas.TextWidth(Params)
    else
      DisplayRect.Right := DisplayRect.Left + 5 +
        ToCanvas.TextWidth(Params + ' : ' + Flag);
    if Selected and not Focused then
    begin
      ToCanvas.Font.Color := clWindowText;
      ChangeTextColor := False;
    end;
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, Params);
    if Flag = '' then
      Exit;
    //custom return type or value defined
    if ChangeTextColor then
      ToCanvas.Font.Color := clBlue;
    Inc(DisplayRect.Left, ToCanvas.TextWidth(Params));
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, ' : ');
    if ChangeTextColor then
      ToCanvas.Font.Color := clOlive;
    Inc(DisplayRect.Left, ToCanvas.TextWidth(' : '));
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, Flag);
    Exit;
  end;
  Len := Length(Token.Flag);
  if Len = 0 then
  begin
    DefaultDraw := True;
    Exit;
  end;
  if (Token.Token = tkDefine) and not IsNumber(Token.Flag) then
  begin
    DefaultDraw := True;
    Exit;
  end;
  DisplayRect.Right := DisplayRect.Left + 5 + ToCanvas.TextWidth(
    Token.Name + ' : ' + Token.Flag);
  if Selected and not Focused then
  begin
    ToCanvas.Font.Color := clWindowText;
    ChangeTextColor := False;
  end;
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, Token.Name);
  //custom return type or value defined
  if ChangeTextColor then
    ToCanvas.Font.Color := clBlue;
  Inc(DisplayRect.Left, ToCanvas.TextWidth(Token.Name));
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, ' : ');

  if ChangeTextColor then
    ToCanvas.Font.Color := clOlive;
  Inc(DisplayRect.Left, ToCanvas.TextWidth(' : '));
  FullFlag := Token.Flag;
  Flag := Token.Flag;
  Len := Length(FullFlag);
  HasVector := False;
  I := Pos('[', FullFlag);
  if I > 0 then
  begin
    Vector := Copy(FullFlag, I + 1, Len - I);
    Flag := Copy(FullFlag, 1, I - 1);
    FullFlag := Vector;
    I := Pos(']', Vector);
    Vector := Copy(Vector, 1, I - 1);
    FullFlag := Copy(FullFlag, I + 1, Len - I);
    HasVector := True;
  end;
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, Flag);
  if not HasVector or (Token.Token <> tkVariable) then
    Exit;
  if ChangeTextColor then
    ToCanvas.Font.Color := clMaroon;
  Inc(DisplayRect.Left, ToCanvas.TextWidth(Flag) + 2);
  while True do
  begin
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, '[');

    if ChangeTextColor then
      ToCanvas.Font.Color := clGreen;
    Inc(DisplayRect.Left, ToCanvas.TextWidth('[') + 1);
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, Vector);

    if ChangeTextColor then
      ToCanvas.Font.Color := clMaroon;
    Inc(DisplayRect.Left, ToCanvas.TextWidth(Vector) + 1);
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, ']');
    Inc(DisplayRect.Left, ToCanvas.TextWidth(']') + 1);

    Len := Length(FullFlag);
    I := Pos('[', FullFlag);
    if I > 0 then
    begin
      Vector := Copy(FullFlag, I + 1, Len - I);
      Flag := Copy(FullFlag, 1, I - 1);
      FullFlag := Vector;
      I := Pos(']', Vector);
      Vector := Copy(Vector, 1, I - 1);
      FullFlag := Copy(FullFlag, I + 1, Len - I);
    end
    else
      Break;
  end;
end;

procedure TFrmFalconMain.TimerHintParamsTimer(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  TimerHintParams.Enabled := False;
  if not GetActiveSheet(sheet) then
    Exit;
  ShowHintParams(sheet.Memo);
end;

procedure TFrmFalconMain.ViewCompOutClick(Sender: TObject);
begin
  PanelMessages.Show;
end;

procedure TFrmFalconMain.FilePrintClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  AFont: TFont;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  PageControlEditor.CancelDragging;
  // TODO: commented
//  if PrintDialog.Execute then
//  begin
//    EditorPrint.Highlighter := sheet.Memo.Highlighter;
//    EditorPrint.SynEdit := sheet.Memo;
//    EditorPrint.DocTitle := Sheet.SourceFile.Name;
//    AFont := TFont.Create;
//    with EditorPrint.Header do
//    begin
//      Clear;
//      AFont.Assign(DefaultFont);
//      AFont.Size := 7;
//      AFont.Style := [fsBold];
//      Add(Sheet.SourceFile.FileName, AFont, taLeftJustify, 1);
//      Add(FormatDateTime(STR_FRM_MAIN[38], Now), AFont, taRightJustify, 1);
//    end;
//    with EditorPrint.Footer do
//    begin
//      Clear;
//      AFont.Assign(DefaultFont);
//      AFont.Size := 8;
//      Add('-$PAGENUM$-', AFont, taCenter, 1);
//    end;
//    EditorPrint.Print;
//    AFont.Free;
//  end;
end;

procedure TFrmFalconMain.PageControlMsgClose(Sender: TObject;
  TabIndex: Integer; var AllowClose: Boolean);
begin
  AllowClose := False;
  PanelMessages.Hide;
end;

procedure TFrmFalconMain.PupMsgGotoLineClick(Sender: TObject);
var
  Item: TListItem;
  Msg: TMessageItem;
begin
  if ListViewMsg.SelCount = 0 then
    Exit;
  Item := ListViewMsg.Selected;
  if Assigned(Item.Data) then
    Msg := TMessageItem(Item.Data)
  else
    Msg := nil;
  ShowLineError(LastProjectBuild, Msg);
end;

procedure TFrmFalconMain.SendDataReceivedStream(Sender: TObject;
  Value: TMemoryStream);
var
  List: TStrings;
begin
  List := TStringList.Create;
  List.LoadFromStream(Value);
  OnDragDropFiles(Sender, List);
  List.Free;
end;

procedure TFrmFalconMain.PageControlEditorDblClick(Sender: TObject);
var
  P: TPoint;
  I: integer;
  SelFile: TSourceFile;
  Proj: TProjectFile;
begin
  P := Mouse.CursorPos;
  P := PageControlEditor.ScreenToClient(P);
  I := PageControlEditor.IndexOfTabAt(P.X, P.Y);
  if (I > -1) or (PageControlEditor.DirectionOfNavAt(P.X, P.Y) <> 0) then
    Exit;
  //Get folder of active file or project
  SelFile := nil;
  if GetActiveFile(SelFile) then
  begin
    if not (SelFile is TProjectFile) and
      (TSourceFile(SelFile.Node.Parent.Data).FileType in [FILE_TYPE_FOLDER,
      FILE_TYPE_PROJECT]) then
    begin
      SelFile := TSourceFile(SelFile.Node.Parent.Data);
    end;
  end
  else if GetActiveProject(Proj) then
  begin
    if Proj.FileType = FILE_TYPE_PROJECT then
      SelFile := Proj;
  end;
  if Config.Environment.DefaultCppNewFile then
    NewSourceFile(FILE_TYPE_CPP, COMPILER_CPP, STR_FRM_MAIN[15] + '.cpp',
      STR_FRM_MAIN[13], '.cpp', '', SelFile, False, False).Edit
  else
    NewSourceFile(FILE_TYPE_C, COMPILER_C, STR_FRM_MAIN[15] + '.c',
      STR_FRM_MAIN[13], '.c', '', SelFile, False, False).Edit;
end;

procedure TFrmFalconMain.EditDeleteClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  SendMessage(sheet.Memo.Handle, WM_KEYDOWN, VK_DELETE, VK_DELETE);
  SendMessage(sheet.Memo.Handle, WM_KEYUP, VK_DELETE, VK_DELETE);
end;

procedure TFrmFalconMain.FileExportHTMLClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  // TODO: commented
  //  ExporterHTML.Clear;
  // ExporterHTML.Highlighter := sheet.Memo.Highlighter;
//  ExporterHTML.Title := Sheet.SourceFile.Name;
//  ExporterHTML.ExportAsText := True;
  // TODO: commented
  // ExporterHTML.ExportAll(sheet.Memo.Lines);

  with TSaveDialog.Create(Self) do
  begin
//    Filter := ExporterHTML.DefaultFilter;
    DefaultExt := '.html';
    Options := Options + [ofOverwritePrompt];
    FileName := ChangeFileExt(Sheet.SourceFile.Name, '.html');
    if Execute then
    begin
//      ExporterHTML.SaveToFile(FileName);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.FileExportRTFClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  // TODO: commented
  // ExporterRTF.Highlighter := sheet.Memo.Highlighter;
//  ExporterRTF.Title := Sheet.SourceFile.Name;
  // TODO: commented
  // ExporterRTF.ExportAll(sheet.Memo.Lines);

  with TSaveDialog.Create(Self) do
  begin
//    Filter := ExporterRTF.DefaultFilter;
    DefaultExt := '.rtf';
    Options := Options + [ofOverwritePrompt];
    FileName := ChangeFileExt(Sheet.SourceFile.Name, '.rtf');
    if Execute then
    begin
//      ExporterRTF.SaveToFile(FileName);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.FileExportTeXClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  // TODO: commented
  //ExporterTeX.Highlighter := sheet.Memo.Highlighter;
//  ExporterTeX.Title := Sheet.SourceFile.Name;
//  ExporterTeX.TabWidth := sheet.Memo.TabWidth;
  // TODO: commented
  // ExporterTeX.ExportAll(sheet.Memo.Lines);

  with TSaveDialog.Create(Self) do
  begin
//    Filter := ExporterTeX.DefaultFilter;
    DefaultExt := '.tex';
    Options := Options + [ofOverwritePrompt];
    FileName := ChangeFileExt(Sheet.SourceFile.Name, '.tex');
    if Execute then
    begin
//      ExporterTeX.SaveToFile(FileName);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.PopTabsCloseAllOthersClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  I: Integer;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  HandlingTabs := True;
  for I := PageControlEditor.PageCount - 1 downto sheet.PageIndex + 1 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  for I := sheet.PageIndex - 1 downto 0 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  PageControlEditor.ActivePageIndex := sheet.PageIndex;
  sheet.Memo.SetFocus;
  HandlingTabs := False;
  PageControlEditorPageChange(PageControlEditor,
    PageControlEditor.ActivePageIndex, -1);
end;

procedure TFrmFalconMain.PopTabsTabsAtTopClick(Sender: TObject);
begin
  PageControlEditor.TabPosition := mtpTop;
  UpdateMenuItems([rmPageCtrlPopup]);
end;

procedure TFrmFalconMain.PopTabsTabsAtBottomClick(Sender: TObject);
begin
  PageControlEditor.TabPosition := mtpBottom;
  UpdateMenuItems([rmPageCtrlPopup]);
end;

procedure TFrmFalconMain.PopTabsCopyFullFileNameClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Clipboard.AsText := sheet.SourceFile.FileName;
end;

procedure TFrmFalconMain.PopTabsCopyFileNameClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Clipboard.AsText := sheet.SourceFile.Name;
end;

procedure TFrmFalconMain.PopTabsCopyDirClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Clipboard.AsText := ExtractFilePath(ExcludeTrailingPathDelimiter(sheet.SourceFile.FileName));
end;

procedure TFrmFalconMain.PopTabsReadOnlyClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  sheet.SourceFile.ReadOnly := PopTabsReadOnly.Checked;
  sheet.Memo.ReadOnly := PopTabsReadOnly.Checked;
  if sheet.SourceFile.ReadOnly then
    sheet.Font.Color := clGrayText
  else
    sheet.Font.Color := clWindowText;
end;

procedure TFrmFalconMain.SwapHeaderSource(FromSrc, ToSrc: TSourceFile);
var
  FromTokenFile, ToTokenFile, TempTokenFile: TTokenFile;
  FromSheet, ToSheet: TSourceFileSheet;
  ScopeToken, Token, ParentToken: TTokenClass;
  Buffer: TBufferCoord;
  FuncScope, ScopeFlag: string;
begin
  FromTokenFile := FilesParsed.ItemOfByFileName(FromSrc.FileName);
  ToTokenFile := FilesParsed.ItemOfByFileName(ToSrc.FileName);
  ToSheet := ToSrc.Edit;
  if not FromSrc.GetSheet(FromSheet) or (FromTokenFile = nil) or
    (ToTokenFile = nil) then
    Exit;
  ScopeToken := DetectScope(FromSheet.Memo, FromTokenFile, False);
  if FromSrc.FileType = FILE_TYPE_H then
  begin
    // only prototype
    if (ScopeToken = nil) or not (ScopeToken.Token in [tkPrototype,
      tkConstructor, tkDestructor]) and
      (GetTokenByName(ScopeToken, 'Scope', tkScope) = nil) then
      Exit;
    ScopeFlag := '';
    FuncScope := '';
    ParentToken := ScopeToken.Parent;
    if Assigned(ParentToken) and (ParentToken.Token = tkScopeClass) then
    begin
      ParentToken := ParentToken.Parent;
      if ParentToken.Token = tkClass then
      begin
        FuncScope := ParentToken.Name;
        ParentToken := ParentToken.Parent;
      end;
    end;
    while Assigned(ParentToken) and (ParentToken.Token = tkNamespace) do
    begin
      ScopeFlag := ParentToken.Name  + '::' + ScopeFlag;
      ParentToken := ParentToken.Parent;
    end;
    // search scope
    if (ScopeFlag <> '') and ToTokenFile.SearchTreeToken(ScopeFlag, Token,
      [tkNamespace], 0) then
    begin
      if not Token.SearchToken(ScopeToken.Name, FuncScope, Token, 0, True,
        [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
        Exit;
    end
    // search implementation function
    else if not ToTokenFile.SearchToken(ScopeToken.Name, ScopeFlag, Token, 0, True,
      [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
      Exit;
    Token := GetTokenByName(Token, 'Scope', tkScope);
    // only function implementation
    if Token = nil then
      Exit;
  end
  else
  begin
    // only function
    if (ScopeToken = nil) or not (ScopeToken.Token in [tkFunction,
      tkConstructor, tkDestructor, tkOperator]) and
      (GetTokenByName(ScopeToken, 'Scope', tkScope) <> nil) then
      Exit;
    // search scope
    FuncScope := GetFuncScope(ScopeToken);
    if FilesParsed.FindDeclaration(ScopeToken.Name, FuncScope, FromTokenFile,
      TempTokenFile, Token, ScopeToken.SelStart, 0) then
    begin
      if ToTokenFile <> TempTokenFile then
        Exit;
    end
    // search function
    else if not ToTokenFile.SearchToken(ScopeToken.Name, '', Token, 0, False,
      [tkPrototype, tkConstructor, tkDestructor]) then
      Exit;
  end;
  Buffer := ToSheet.Memo.CharIndexToRowCol(Token.SelStart);
  GotoLineAndAlignCenter(ToSheet.Memo, Buffer.Line, Buffer.Char);
end;

function TFrmFalconMain.CreateTODOSourceFile(FileName: string;
  TokenFile: TTokenFile; SourceFile: TSourceFile;
  var TODOSourceFile: TSourceFile): Boolean;
var
  I: Integer;
  Project: TProjectBase;
  Parent: TSourceFile;
  Memo: TEditor;
  Lines: TStrings;
  Directive: string;
begin
  Result := False;
  if (SourceFile.Project.FileType <> FILE_TYPE_PROJECT) or
    (SourceFile.Node.Parent = nil) then
    Exit;
  I := InternalMessageBox(PChar(Format(STR_FRM_MAIN[34] + #10 + STR_FRM_MAIN[43],
    [FileName])), 'Falcon C++', MB_ICONEXCLAMATION + MB_YESNOCANCEL);
  if I <> IDYES then
    Exit;
  Project := SourceFile.Project;
  Parent := TSourceFile(SourceFile.Node.Parent.Data);
  if SourceFile.FileType = FILE_TYPE_H then
  begin
    { TODO -oMazin -c : Get Source file extension standard 06/05/2013 22:59:19 }
    if Project.CompilerType = COMPILER_C then
      TODOSourceFile := NewSourceFile(FILE_TYPE_C, Project.CompilerType,
        ExtractFileName(FileName), ExtractName(FileName), '.c', '', Parent,
        False, False)
    else
      TODOSourceFile := NewSourceFile(FILE_TYPE_CPP, Project.CompilerType,
        ExtractFileName(FileName), ExtractName(FileName), '.cpp', '', Parent,
        False, False);
    Memo := TODOSourceFile.Edit(False).Memo;
    Memo.Lines.Add('#include "' + ExtractFileName(SourceFile.FileName) + '"');
    Memo.Lines.Add('');
    if TokenFile <> nil then
    begin
      Lines := TStringList.Create;
      GenerateFunctions(TokenFile, Lines, 0, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4);
      Memo.Lines.AddStrings(Lines);
      Lines.Free;
    end
    else
      Memo.Lines.Add(''); //Caret here
    Memo.CaretXY := BufferCoord(1, 3);
    Project.PropertyChanged := True;
  end
  else
  begin
    { TODO -oMazin -c : Get Header file extension standard 06/05/2013 22:59:19 }
    TODOSourceFile := NewSourceFile(FILE_TYPE_H, NO_COMPILER,
      ExtractFileName(FileName), ExtractName(FileName), '.h', '',
      Parent, False, False);

    Directive := UpperCase(ExtractFileName(FileName));
    Directive := '_' + StringReplace(Directive, '.', '_', []) + '_';
    Directive := StringReplace(Directive, ' ', '_', []);

    Memo := TODOSourceFile.Edit(False).Memo;
    Memo.Lines.Add('#ifndef ' + Directive);
    { TODO -oMazin -c : Add GNU License 24/08/2012 22:29:54 }
    Memo.Lines.Add('#define ' + Directive);
    Memo.Lines.Add('');
    if TokenFile <> nil then
    begin                  
      Lines := TStringList.Create;
      GenerateFunctionPrototype(TokenFile, Lines, 0);
      Memo.Lines.AddStrings(Lines);
      Lines.Free;
    end
    else
      Memo.Lines.Add(''); //Caret here
    Memo.Lines.Add('');
    Memo.Lines.Add('#endif');
    Memo.CaretXY := BufferCoord(1, 4);
    Project.PropertyChanged := True;
  end;
  Result := True;
end;

procedure TFrmFalconMain.EditSwapClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  OtherFileName, FileName: string;
  CurrentSourceFile, OtherSourceFile: TSourceFile;
  CurrentTokenFile: TTokenFile;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  CurrentSourceFile := Sheet.SourceFile;
  FileName := CurrentSourceFile.FileName;
  OtherSourceFile := nil;
  if (GetFileType(FileName) in [FILE_TYPE_CPP, FILE_TYPE_C]) then
  begin
    // find header file
    if not SearchHeaderFile(CurrentSourceFile, OtherSourceFile, OtherFileName) then
    begin
      OtherFileName := ChangeFileExt(FileName, '.h');
      // header file not found and can't create a header file out of project
      if CurrentSourceFile is TProjectFile then
      begin
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [OtherFileName])),
          'Falcon C++', MB_ICONINFORMATION);
        Exit;
      end;
      // want to create a header file?
      CurrentTokenFile := FilesParsed.ItemOfByFileName(FileName);
      if not CreateTODOSourceFile(OtherFileName, CurrentTokenFile,
        CurrentSourceFile, OtherSourceFile) then
        Exit;
    end;
    // file found but is not open
    if OtherSourceFile = nil then
      OtherSourceFile := OpenFile(OtherFileName);
    // swap source to header file
    SwapHeaderSource(CurrentSourceFile, OtherSourceFile);
  end
  else if GetFileType(FileName) = FILE_TYPE_H then
  begin
    // find source file
    if not SearchImplementationFile(CurrentSourceFile, OtherSourceFile,
      OtherFileName) then
    begin
      OtherFileName := ChangeFileExt(FileName, '.c');
      // source file not found and can't create a source file out of project
      if CurrentSourceFile is TProjectFile then
      begin
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [OtherFileName])),
          'Falcon C++', MB_ICONINFORMATION);
        Exit;
      end;
      // change extension to cpp if is a c++ project
      if CurrentSourceFile.Project.CompilerType = COMPILER_CPP then
        OtherFileName := ChangeFileExt(FileName, '.cpp');
      // want to create a source file?
      CurrentTokenFile := FilesParsed.ItemOfByFileName(FileName);
      if not CreateTODOSourceFile(OtherFileName, CurrentTokenFile,
        CurrentSourceFile, OtherSourceFile) then
        Exit;
    end;
    // file found but is not open
    if OtherSourceFile = nil then
      OtherSourceFile := OpenFile(OtherFileName);
    SwapHeaderSource(CurrentSourceFile, OtherSourceFile);
  end;
end;

procedure TFrmFalconMain.PageControlEditorTabClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  sheet.Memo.SetFocus;
end;

procedure TFrmFalconMain.PageControlEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sheet: TSourceFileSheet;
  tab: Integer;
begin
  tab := PageControlEditor.IndexOfTabAt(X, Y);
  if (tab >= 0) then
  begin
    if (Button = mbMiddle) then
    begin
      PageControlEditor.ActivePageIndex := tab;
      if (PageControlEditor.ActivePageIndex >= 0) then
      begin
        PageControlEditor.CloseActiveTab;
      end;
    end
    else if (Button = mbLeft) and GetActiveSheet(sheet) then
    begin
      if not sheet.Memo.Focused and sheet.Memo.Showing then
        sheet.Memo.SetFocus;
    end;
  end;
end;

procedure TFrmFalconMain.EditFormatClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  caret: TBufferCoord;
  topLine: Integer;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  with TAStyle.Create do
  begin
    if Config.Editor.UseTabChar then
      TabOptions := toTab
    else
      TabOptions := toSpaces;
    MaxCodeLength := Config.Editor.RightMargin;
    case Config.Editor.StyleIndex of
      0: // ansi
        begin
          BracketStyle := stALLMAN;
          Properties[aspIndentNamespaces] := True;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      1: // K&R
        begin
          BracketStyle := stKR;
          Properties[aspIndentNamespaces] := True;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      2: //Linux
        begin
          BracketStyle := stLINUX;
          TabWidth := 8;
          Properties[aspIndentNamespaces] := True;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      3: //GNU
        begin
          BracketStyle := stGNU;
          TabWidth := 2;
          Properties[aspBreakBlocks] := True;
          Properties[aspIndentNamespaces] := True;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      4: //java
        begin
          BracketStyle := stJAVA;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      5: //custom
        begin
          BracketStyle := stNONE;
          TabWidth := Config.Editor.TabWidth;
          //Indentation
          Properties[aspIndentClasses] := Config.Editor.IndentClasses;
          Properties[aspIndentSwitches] := Config.Editor.IndentSwitches;
          Properties[aspIndentCases] := Config.Editor.IndentCase;
          // ? Properties[aspIndentBracket] := Config.Editor.IndentBrackets;
          // ? Properties[aspIndentBlock] := Config.Editor.IndentBlocks;
          Properties[aspIndentNamespaces] := Config.Editor.IndentNamespaces;
          Properties[aspIndentLabels] := Config.Editor.IndentLabels;
          Properties[aspIndentPreprocDefine] := Config.Editor.IndentMultLine;
          Properties[aspIndentCol1Comments] := Config.Editor.IndentSingleLineComments;

        //padding
          // Properties[aspBreakBlocks] := Config.Editor.PadEmptyLines;
          Properties[aspBreakClosingBrackets] := Config.Editor.BreakClosingHeaderBlocks;
          Properties[aspPaddingOperator] := Config.Editor.InsertSpacePaddingOperators;
          Properties[aspPaddingParensOutside] := Config.Editor.InsertSpacePaddingParenthesisOutside;
          Properties[aspPaddingParensInside] := Config.Editor.InsertSpacePaddingParenthesisInside;
          Properties[aspPaddingHeader] := Config.Editor.ParenthesisHeaderPadding;
          Properties[aspUnpaddingParens] := Config.Editor.RemoveExtraSpace;
          Properties[aspDeleteEmptyLines] := Config.Editor.DeleteEmptyLines;
          Properties[aspFillEmptyLines] := Config.Editor.FillEmptyLines;

        //Formatting
          if (Config.Editor.BracketStyle < 2) then //Does not work
            Properties[aspBreakClosingBrackets] := Config.Editor.BreakClosingHeadersBrackets;
          Properties[aspBreakElseIfs] := Config.Editor.BreakIfElse;
          Properties[aspAddBrackets] := Config.Editor.AddBrackets;
          Properties[aspAddOneLineBrackets] := Config.Editor.AddOneLineBrackets;
          Properties[aspKeepOneLineBlocks] := not Config.Editor.DontBreakOnelineBlocks;
          Properties[aspKeepOneLineStatements] := Config.Editor.DontBreakComplex;
          Properties[aspConvertTabs] := Config.Editor.ConvertTabToSpaces;
          case Config.Editor.PointerAlign of
            1: AlignPointer := apType;
            2: AlignPointer := apMiddle;
            3: AlignPointer := apName;
          else
            AlignPointer := apNone;
          end;
        end;
    end;
    sheet.Memo.BeginUpdate;
    caret := sheet.Memo.CaretXY;
    topLine := sheet.Memo.TopLine;
    sheet.Memo.SendEditor(SCI_SETTEXT, 0, Integer(Format(PUTF8String(sheet.Memo.GetCharacterPointer))));
    sheet.Memo.CaretXY := caret;
    sheet.Memo.TopLine := topLine;
    sheet.Memo.EndUpdate;
    Free;
  end;
end;

procedure TFrmFalconMain.EditIndentClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  // TODO: commented
  //sheet.Memo.CommandProcessor(ecBlockIndent, #0, nil);
end;

procedure TFrmFalconMain.EditUnindentClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  // TODO: commented
  //sheet.Memo.CommandProcessor(ecBlockUnindent, #0, nil);
end;

procedure TFrmFalconMain.EditToggleCommentClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  // TODO: commented
  // sheet.Memo.ToggleLineComment;
end;

function TFrmFalconMain.InternalMessageBox(Text, Caption: string;
  uType: UINT; Handle: HWND): Integer;
var
  CurrentHandle: HWND;
begin
  CurrentHandle := Handle;
  if CurrentHandle = 0 then
  begin
    CurrentHandle := Self.Handle;
    if SplashScreen.Showing then
      CurrentHandle := SplashScreen.Handle;
  end;
  PageControlEditor.CancelDragging;
  Result := MessageBox(CurrentHandle, PChar(Text), PChar(Caption), uType);
end;

procedure TFrmFalconMain.CheckIfFilesHasChanged;
var
  FileProp: TSourceFile;
  Node: TTreeNode;
  FileName: string;
  I: Integer;
  sheet: TSourceFileSheet;
begin
  if not IsLoading and not ShowingReloadEnquiry then
  begin
    ShowingReloadEnquiry := True;
    for I := 0 to TreeViewProjects.Items.Count - 1 do
    begin
      Node := TreeViewProjects.Items.Item[I];
      FileProp := TSourceFile(Node.Data);
      if FileProp.FileChangedInDisk then
      begin
        FileName := FileProp.FileName;
        if FileProp.GetSheet(sheet) and not sheet.Memo.GetModify then
        begin
          FileProp.Reload;
          UpdateStatusbar;
        end
        else if FileProp.Editing and (InternalMessageBox(
          PChar(FileName + #13#13 + STR_FRM_MAIN[49]), 'Falcon C++',
          MB_ICONQUESTION or MB_YESNO) = IDYES) then
        begin
          FileProp.Reload;
          FileProp.Project.CompilePropertyChanged := True;
        end
        else
          FileProp.UpdateDate;
      end;
    end;
    ShowingReloadEnquiry := False;
  end;
end;

procedure TFrmFalconMain.ApplicationEventsActivate(Sender: TObject);
begin
  CheckIfFilesHasChanged;
end;

procedure TFrmFalconMain.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = WM_NCLBUTTONDOWN) and (Msg.hwnd = Handle) then
  begin
    if CodeCompletion.Executing then
      CodeCompletion.CancelCompletion;
    if Assigned(DebugHint) then
      DebugHint.Cancel;
    if Assigned(HintParams) then
      HintParams.Cancel;
    if Assigned(HintTip) then
      HintTip.Cancel;
  end;
end;

procedure TFrmFalconMain.ApplicationEventsDeactivate(Sender: TObject);
begin
  if CodeCompletion.Executing then
    CodeCompletion.CancelCompletion;
  if Assigned(DebugHint) then
    DebugHint.Cancel;
  if Assigned(HintParams) then
    HintParams.Cancel;
  if Assigned(HintTip) then
    HintTip.Cancel;
end;

function TFrmFalconMain.SearchImplementationFile(HeaderFile: TSourceFile;
  var SrcFile: TSourceFile; var SrcFileName: string): Boolean;
var
  parent, temp: TSourceFile;
  FileName, SwapFileName, SrcName: string;
  IncludeList: TStringList;
begin
  parent := nil;
  Result := False;
  if (HeaderFile <> nil) then
  begin
    if (HeaderFile.FileType <> FILE_TYPE_H) then
      Exit;
    FileName := HeaderFile.FileName;
    if Assigned(HeaderFile.Node.Parent) then
      parent := TSourceFile(HeaderFile.Node.Parent.Data);
  end
  else
    FileName := SrcFileName;
  if Assigned(parent) then
  begin
    // search on parent folder
    SwapFileName := ChangeFileExt(FileName, '.c');
    if parent.FindFile(ExtractFileName(SwapFileName), SrcFile) then
    begin
      Result := True;
      SrcFileName := SrcFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.cpp');
    if parent.FindFile(ExtractFileName(SwapFileName), SrcFile) then
    begin
      Result := True;
      SrcFileName := SrcFile.FileName;
      Exit;
    end;

    // search using project compiler flag
    IncludeList := TStringList.Create;
    GetIncludeDirs(ExtractFilePath(HeaderFile.Project.FileName),
      HeaderFile.Project.Flags, IncludeList);
    if IncludeList.Count > 0 then
    begin
      SrcName := ChangeFileExt(ExtractFileName(SwapFileName), '.c');
      temp := HeaderFile.Project.SearchFile(SrcName);
      if temp = nil then
        temp := HeaderFile.Project.SearchFile(ChangeFileExt(SrcName, '.cpp'));
      if temp <> nil then
      begin
        IncludeList.Free;
        SrcFile := temp;
        Result := True;
        SrcFileName := SrcFile.FileName;
        Exit;
      end;
    end;
    IncludeList.Free;
  end
  else
  begin
    // search out of project
    SwapFileName := ChangeFileExt(FileName, '.cpp');
    if SearchSourceFile(SwapFileName, SrcFile) then
    begin
      Result := True;
      SrcFileName := SrcFile.FileName;
      Exit;
    end;
    if FileExists(SwapFileName) then
    begin
      Result := True;
      SrcFileName := SwapFileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.c');
    if SearchSourceFile(SwapFileName, SrcFile) then
    begin
      Result := True;
      SrcFileName := SrcFile.FileName;
      Exit;
    end;
    if FileExists(SwapFileName) then
    begin
      Result := True;
      SrcFileName := SwapFileName;
      Exit;
    end;
  end;
end;

function TFrmFalconMain.SearchHeaderFile(SourceFile: TSourceFile;
  var HdrFile: TSourceFile; var HdrFileName: string): Boolean;
var
  parent, temp: TSourceFile;
  FileName, SwapFileName, SrcName: string;
  IncludeList: TStringList;
  I: Integer;
begin
  parent := nil;
  Result := False;
  if (SourceFile <> nil) then
  begin
    if not (SourceFile.FileType in [FILE_TYPE_CPP, FILE_TYPE_C]) then
      Exit;
    FileName := SourceFile.FileName;
    if Assigned(SourceFile.Node.Parent) then
      parent := TSourceFile(SourceFile.Node.Parent.Data);
  end
  else
    FileName := HdrFileName;
  if Assigned(parent) then
  begin
    // search on parent folder
    SwapFileName := ChangeFileExt(FileName, '.h');
    if parent.FindFile(ExtractFileName(SwapFileName), HdrFile) then
    begin
      Result := True;
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.hpp');
    if parent.FindFile(ExtractFileName(SwapFileName), HdrFile) then
    begin
      Result := True;
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.hh');
    if parent.FindFile(ExtractFileName(SwapFileName), HdrFile) then
    begin
      Result := True;
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.rh');
    if parent.FindFile(ExtractFileName(SwapFileName), HdrFile) then
    begin
      Result := True;
      HdrFileName := HdrFile.FileName;
      Exit;
    end;

    // search using project compiler flag
    IncludeList := TStringList.Create;
    GetIncludeDirs(ExtractFilePath(SourceFile.Project.FileName),
      SourceFile.Project.Flags, IncludeList);
    for I := 0 to IncludeList.Count - 1 do
    begin
      SrcName := ChangeFileExt(ExtractFileName(SwapFileName), '.h');
      SrcName := ExtractRelativePath(ExtractFilePath(SourceFile.Project.FileName),
        ExpandFileName(IncludeList.Strings[I] + SrcName));
      temp := SourceFile.Project.GetFileByPathName(SrcName);
      if temp = nil then
        temp := SourceFile.Project.GetFileByPathName(ChangeFileExt(SrcName, '.hpp'));
      if temp = nil then
        temp := SourceFile.Project.GetFileByPathName(ChangeFileExt(SrcName, '.hh'));
      if temp = nil then
        temp := SourceFile.Project.GetFileByPathName(ChangeFileExt(SrcName, '.rh'));
      if temp <> nil then
      begin
        IncludeList.Free;
        HdrFile := temp;
        Result := True;
        HdrFileName := HdrFile.FileName;
        Exit;
      end;
    end;
    IncludeList.Free;
  end
  else
  begin
    // search out of project
    SwapFileName := ChangeFileExt(FileName, '.h');
    if SearchSourceFile(SwapFileName, HdrFile) then
    begin
      Result := True;
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    if FileExists(SwapFileName) then
    begin
      Result := True;
      HdrFileName := SwapFileName;
      Exit;
    end;
  end;
end;

procedure TFrmFalconMain.PopEditorOpenDeclClick(Sender: TObject);
var
  CurrentTokenFile, SrcTokenFile: TTokenFile;
  sheet: TSourceFileSheet;
  Scope, ScopeToken, Token(*, ParentToken*): TTokenClass;
  SrcFileName: string;
  CurrentSrcFile, SrcFile: TSourceFile;
  SelStart, SelLine: Integer;
  BC: TBufferCoord;
  Input, Fields, ScopeFlag: string;
  InputError: Boolean;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  CurrentSrcFile := sheet.SourceFile;
  CurrentTokenFile := FilesParsed.ItemOfByFileName(CurrentSrcFile.FileName);
  if (CurrentTokenFile = nil) then
    Exit;
  BC := sheet.Memo.CaretXY;
  SelLine := BC.Line;
  if BC.Line > 0 then
  begin
    if BC.Char > (Length(sheet.Memo.Lines[SelLine - 1]) + 1) then
      BC.Char := Length(sheet.Memo.Lines[SelLine - 1]) + 1;
  end;
  SelStart := sheet.Memo.RowColToCharIndex(BC);
  SrcFile := CurrentSrcFile;
  SrcFileName := CurrentSrcFile.FileName;
  // get prototype
  if not CurrentTokenFile.GetTokenAt(ScopeToken, SelStart) then
  begin
    if not ParseFields(sheet.Memo.Lines.Text, SelStart, Input, Fields, InputError) then
      Exit;
    if not FilesParsed.FindDeclaration(Input, Fields, CurrentTokenFile, CurrentTokenFile,
      ScopeToken, SelStart, SelLine) then
      Exit;
    SrcFileName := CurrentTokenFile.FileName;
    CurrentSrcFile := TSourceFile(CurrentTokenFile.Data);
  end;
  // only prototype
  Scope := GetTokenByName(ScopeToken, 'Scope', tkScope);
  if not (ScopeToken.Token in [tkPrototype, tkConstructor, tkDestructor]) and
    (Scope = nil) then
    Exit;
  ScopeFlag := '';
  if Scope <> nil then
    ScopeFlag := Scope.Flag;
  { TODO -oMazin -c : get all parent scope 04/05/2013 21:17:55 }
  //get parent of Token
//  ParentToken := ScopeToken.Parent;
//  if Assigned(ParentToken) and
//    (ParentToken.Token in [tkClass, tkStruct, tkScopeClass]) then
//    ParentToken := ParentToken.Parent;
  //tree parent object?
//  if Assigned(ParentToken) and Assigned(ParentToken.Parent) and
//    (ParentToken.Parent.Token in [tkClass, tkStruct]) then
//    ParentToken := ParentToken.Parent;
//  if (ParentToken <> nil) and not (ParentToken.Token in [tkClass, tkStruct]) then
//    ParentToken := nil;
  // implementation on same file
  { TODO -oMazin -c : Search with scope 04/05/2013 21:20:23 }
  if not CurrentTokenFile.SearchToken(ScopeToken.Name, ScopeFlag, Token, ScopeToken.SelStart,
    True, [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
  begin
    // search on source file
    SrcFile := nil;
    if not SearchImplementationFile(CurrentSrcFile, SrcFile, SrcFileName) then
      Exit;
    SrcTokenFile := FilesParsed.ItemOfByFileName(SrcFileName);
    if SrcTokenFile = nil then
      Exit;
    if not SrcTokenFile.SearchToken(ScopeToken.Name, ScopeFlag, Token, 0, True,
      [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
      Exit;
  end;
  // only function implementation
  if GetTokenByName(Token, 'Scope', tkScope) = nil then
    Exit;
  if SrcFile = nil then
  begin
    if FileExists(SrcFileName) then
      SrcFile := OpenFile(SrcFileName)
    else
      Exit;
  end;
  SrcFile.Edit;
  SelectToken(Token);
end;


procedure TFrmFalconMain.PopEditorCompClassClick(Sender: TObject);
var
  CurrentTokenFile, SrcTokenFile, ClassTokenFile: TTokenFile;
  sheet: TSourceFileSheet;
  Scope, ScopeToken, ParentToken, ClassToken, FuncToken, FuncValue: TTokenClass;
  SrcFileName: string;
  CurrentSrcFile, ClassFile, SrcFile: TSourceFile;
  SelStart, SelLine, I, LastFuncSelEnd, LastPrivFuncLine: Integer;
  BS: TBufferCoord;
  LastLineText, ScopeFlag: string;
  ClassFuncList, FuncList, TODOFuncList: TStrings;
  Memo: TEditor;
  ClassHasFound: Boolean;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  CurrentSrcFile := sheet.SourceFile;
  CurrentTokenFile := FilesParsed.ItemOfByFileName(CurrentSrcFile.FileName);
  if (CurrentTokenFile = nil) then
    Exit;
  BS := sheet.Memo.CaretXY;
  SelLine := BS.Line;
  if BS.Line > 0 then
  begin
    if BS.Char > (Length(sheet.Memo.Lines[SelLine - 1]) + 1) then
      BS.Char := Length(sheet.Memo.Lines[SelLine - 1]) + 1;
  end;
  SelStart := sheet.Memo.RowColToCharIndex(BS);
  SrcFile := CurrentSrcFile;
  SrcFileName := CurrentSrcFile.FileName;
  // get prototype
  if not CurrentTokenFile.GetScopeAt(ScopeToken, SelStart) then
    Exit;
  if (ScopeToken.Token in [TkVariable]) and Assigned(ScopeToken.Parent) and
    (ScopeToken.Parent.Token in [tkScopeClass]) then
    ScopeToken := ScopeToken.Parent;
  // only class, struct, union or class function
  if not (ScopeToken.Token in [TkFunction, tkPrototype, tkConstructor,
    tkDestructor, tkOperator, tkClass, tkStruct, tkUnion]) then
    Exit;
  { TODO -oMazin -c : get all parent scope 04/05/2013 21:17:55 }
  //get parent of Token
  ParentToken := ScopeToken;
  if not (ScopeToken.Token in [tkClass, tkStruct, tkUnion]) then
    ParentToken := ScopeToken.Parent;
  if Assigned(ParentToken) and (ParentToken.Token in [tkScopeClass]) then
    ParentToken := ParentToken.Parent;
  if (ParentToken <> nil) and not (ParentToken.Token in [tkClass, tkStruct, tkUnion]) then
    ParentToken := nil;
  Scope := GetTokenByName(ScopeToken, 'Scope', tkScope);
  ScopeFlag := '';
  if ScopeToken.Token in [tkClass, tkStruct, tkUnion] then
    ScopeFlag := ScopeToken.Name
  else if Scope <> nil then
    ScopeFlag := Scope.Flag;
  // only class, struct, union or class function
  if (ScopeFlag = '') and not (ScopeToken.Token in [tkClass, tkStruct, tkUnion]) then
    Exit;
  ClassHasFound := ParentToken <> nil;
  if ParentToken <> nil then
  begin
    ClassFile := CurrentSrcFile;
    ClassToken := ParentToken;
    ClassTokenFile := CurrentTokenFile;
    if CurrentSrcFile.FileType = FILE_TYPE_H then
    begin
      // search on source file
      SrcFile := nil;
      if not SearchImplementationFile(CurrentSrcFile, SrcFile, SrcFileName) then
      begin
        SrcFileName := ChangeFileExt(CurrentSrcFile.FileName, '.c');
        // source file not found and can't create a source file out of project
        if CurrentSrcFile is TProjectFile then
        begin
          InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [SrcFileName])),
            'Falcon C++', MB_ICONINFORMATION);
          Exit;
        end;
        // change extension to cpp if is a c++ project
        if CurrentSrcFile.Project.CompilerType = COMPILER_CPP then
          SrcFileName := ChangeFileExt(SrcFileName, '.cpp');
        // want to create a source file?
        if CreateTODOSourceFile(SrcFileName, CurrentTokenFile,
          CurrentSrcFile, SrcFile) then
          SwapHeaderSource(CurrentSrcFile, SrcFile);
        Exit
      end
      else
      begin
        SrcTokenFile := FilesParsed.ItemOfByFileName(SrcFileName);
        if SrcTokenFile = nil then
          Exit;
        if SrcFile = nil then
          SrcFile := TSourceFile(SrcTokenFile.Data);
      end;
    end
    else
    begin
      SrcTokenFile := CurrentTokenFile;
      SrcFile := CurrentSrcFile;
    end;
  end
  else
  begin
    ClassTokenFile := nil;
    if FilesParsed.FindDeclaration(ScopeFlag, '', CurrentTokenFile,
      SrcTokenFile, ClassToken, ScopeToken.SelStart, 0) then
      ClassHasFound := ClassToken.Token in [tkClass, tkStruct, tkUnion];
    if ClassHasFound then
    begin
      ClassTokenFile := SrcTokenFile;
      SrcTokenFile := CurrentTokenFile;
      ClassFile := TSourceFile(ClassTokenFile.Data);
    end;
  end;
  if not ClassHasFound then
  begin
    if CurrentSrcFile.FileType in [FILE_TYPE_C, FILE_TYPE_CPP] then
    begin
      // search on source file
      ClassFile := nil;
      if not SearchHeaderFile(CurrentSrcFile, ClassFile, SrcFileName) then
      begin
        SrcFileName := ChangeFileExt(CurrentSrcFile.FileName, '.h');
        // header file not found and can't create a header file out of project
        if CurrentSrcFile is TProjectFile then
        begin
          InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [SrcFileName])),
            'Falcon C++', MB_ICONINFORMATION);
          Exit;
        end;
        // want to create header file?
        if CreateTODOSourceFile(SrcFileName, CurrentTokenFile,
          CurrentSrcFile, ClassFile) then
          SwapHeaderSource(CurrentSrcFile, ClassFile);
        Exit
      end
      else
      begin
        ClassTokenFile := FilesParsed.ItemOfByFileName(SrcFileName);
        if ClassTokenFile = nil then
          Exit;
        SrcTokenFile := CurrentTokenFile;
        if not ClassTokenFile.SearchToken(ScopeFlag, '', ClassToken,
          0, True, [tkClass, tkStruct, tkUnion]) then
          Exit;
        if ClassFile = nil then
          ClassFile := TSourceFile(ClassTokenFile.Data);
      end;
    end
    // implementation in header file without a class
    else
      Exit;
  end;
  if (ClassFile = nil) or (SrcFile = nil) then
    Exit;
  ClassFuncList := TStringList.Create;
  ClassToken.GetFunctions(ClassFuncList, '', False, False, True);
  // function implementation on same file of class declaration
  FuncList := TStringList.Create;
  if SrcTokenFile <> ClassTokenFile then
    ClassTokenFile.GetFunctions(FuncList, ScopeFlag, True, False);
  TODOFuncList := TStringList.Create;
  SrcTokenFile.GetFunctions(FuncList, ScopeFlag, True, False);
  LastFuncSelEnd := -1;
  for I := FuncList.Count - 1 downto 0 do
  begin
    FuncToken := TTokenClass(FuncList.Objects[I]);
    if FuncToken.SelStart < LastFuncSelEnd then
      Continue;
    Scope := GetTokenByName(FuncToken, 'Scope', tkScope);
    if (Scope <> nil) and (Scope.SelLine > LastFuncSelEnd) then
      LastFuncSelEnd := Scope.SelStart + Scope.SelLength + 1;
  end;
  LastPrivFuncLine := 0;
  I := 0;
  while I <= ClassFuncList.Count - 1 do
  begin
    FuncToken := TTokenClass(ClassFuncList.Objects[I]);
    if Pos('virtual', FuncToken.Flag) > 0 then
    begin
      FuncValue := GetTokenByName(FuncToken, 'Value', tkValue);
      if FuncValue <> nil then
      begin
        ClassFuncList.Delete(I);
        Continue;
      end;
    end;
    if (FuncToken.SelLine < LastPrivFuncLine) or (FuncToken.Parent.Token <>
      tkScopeClass) or (FuncToken.Parent.Name <> 'private') then
    begin
      Inc(I);
      Continue;
    end;
    LastPrivFuncLine := FuncToken.SelLine;
    Inc(I);
  end;
  if LastPrivFuncLine = 0 then
  begin
    Scope := GetTokenByName(ClassToken, 'private', tkScopeClass);
    if (Scope <> nil) and (Scope.Count > 0) then
      LastPrivFuncLine := Scope.Items[Scope.Count - 1].SelLine;
  end;
  GetDiffFunction(ClassFuncList, FuncList, TODOFuncList);
  FuncList.Free;
  ClassFuncList.Free;
  if TODOFuncList.Count = 0 then
  begin
    TODOFuncList.Free;
    Exit;
  end;
  ClassFuncList := TStringList.Create;
  FuncList := TStringList.Create;
  for I := 0 to TODOFuncList.Count - 1 do
  begin
    FuncToken := TTokenClass(TODOFuncList.Objects[I]);
    if TODOFuncList.Strings[I] = 'class' then
    begin
      if (Pos('virtual', FuncToken.Flag) = 1) and
        (GetTokenByName(FuncToken, 'Value', tkValue) <> nil) then
        Continue;
      FuncList.Insert(FuncList.Count, '');
      SelLine := FuncList.Count;
      InsertFunction(FuncToken, FuncList, SelLine, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4);
    end
    else
    begin
      SelLine := ClassFuncList.Count;
      InsertFunction(FuncToken, ClassFuncList, SelLine, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4, True, ClassToken.Level + 1);
    end;
  end;
  if FuncList.Count > 0 then
  begin
    FuncList.Insert(0, '');
    Memo := SrcFile.Edit.Memo;
    if LastFuncSelEnd = -1 then
    begin
      ParentToken := ClassToken.Parent;
      ScopeFlag := '';
      while Assigned(ParentToken) and (ParentToken.Token = tkNamespace) do
      begin
        ScopeFlag := ParentToken.Name  + '::' + ScopeFlag;
        ParentToken := ParentToken.Parent;
      end;
      if ScopeFlag <> '' then
      begin
        if SrcTokenFile.SearchTreeToken(ScopeFlag, ScopeToken, [tkNamespace], 0) then
        begin
          if ScopeToken.Count > 0 then
          begin
            Scope := GetTokenByName(ScopeToken.Items[ScopeToken.Count - 1],
              'Scope', tkScope);
            if (Scope <> nil) then
              LastFuncSelEnd := Scope.SelStart + Scope.SelLength + 1
            else
            begin
              Scope := GetTokenByName(ScopeToken, 'Scope', tkScope);
              if (Scope <> nil) then
                LastFuncSelEnd := Scope.SelStart;
            end;
          end;
        end;
      end;
      if LastFuncSelEnd = -1 then
      begin
        // non class function out of class
        LastLineText := '';
        if Memo.Lines.Count > 0 then
          LastLineText := Memo.Lines[Memo.Lines.Count - 1];
        BS := BufferCoord(Length(LastLineText) + 1, Memo.Lines.Count);
        if SrcTokenFile.GetPreviousFunction(FuncToken,
          Memo.RowColToCharIndex(BS)) then
        begin
          Scope := GetTokenByName(FuncToken, 'Scope', tkScope);
          if (Scope <> nil) then
            LastFuncSelEnd := Scope.SelStart + Scope.SelLength + 1;
        end;
        if LastFuncSelEnd = -1 then
        begin
          if SrcTokenFile = ClassTokenFile then
          begin
            Scope := GetTokenByName(ClassToken, 'Scope', tkScope);
            if (Scope <> nil) then
              LastFuncSelEnd := Scope.SelStart + Scope.SelLength + 2;
          end;
          if LastFuncSelEnd = -1 then
            LastFuncSelEnd := Memo.RowColToCharIndex(BS);
        end;
      end;
    end;
    BS := Memo.CharIndexToRowCol(LastFuncSelEnd);
    Memo.UncollapseLine(BS.Line);
    Memo.BeginUpdate;
    Memo.CaretXY := BS;
    Memo.SelText := FuncList.Text;
    Memo.EndUpdate;
  end;
  if ClassFuncList.Count > 0 then
  begin
    ClassFuncList.Insert(0, '');
    if LastPrivFuncLine = 0 then
    begin
      // no private scope
      Scope := GetTokenByName(ClassToken, 'Scope', tkScope);
      if Scope <> nil then
        LastPrivFuncLine := Scope.SelLine;
      ClassFuncList.Insert(1, GetLeftSpacing(Config.Editor.TabWidth * ClassToken.Level,
        Config.Editor.TabWidth, Config.Editor.UseTabChar) + 'private:');
    end;
    LastLineText := '';
    Memo := ClassFile.Edit.Memo;
    if (LastPrivFuncLine > 0) and (LastPrivFuncLine <= Memo.Lines.Count) then
      LastLineText := Memo.Lines[LastPrivFuncLine - 1];
    BS := BufferCoord(Length(LastLineText) + 1, LastPrivFuncLine);
    Memo.BeginUpdate;
    Memo.UncollapseLine(BS.Line);
    Memo.CaretXY := BS;
    LastLineText := ClassFuncList.Strings[0];
    for I := 1 to ClassFuncList.Count - 1 do
      LastLineText := LastLineText + #13#10 + ClassFuncList.Strings[I];
    Memo.SelText := LastLineText;
    Memo.EndUpdate;
  end;
  ClassFuncList.Free;
  FuncList.Free;
  TODOFuncList.Free;
  {SrcFile.Edit;
  SelectToken(FuncToken);}
end;

procedure TFrmFalconMain.InvalidateDebugLine;
var
  sheet: TSourceFileSheet;
  OldActLine: Integer;
begin
  if (DebugActiveLine = 0) or not GetActiveSheet(sheet) then
    Exit;
  OldActLine := DebugActiveLine;
  DebugActiveLine := 0;
  sheet.Memo.RemoveActiveLine(OldActLine);
end;

procedure TFrmFalconMain.ToggleBreakpoint(aLine: Integer);
var
  sheet: TSourceFileSheet;
  fprop: TSourceFile;
  SourcePath, Source: string;
  Breakpoint: TBreakpoint;
  RealLine: Integer;
  Added: Boolean;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := Sheet.SourceFile;
  RealLine := aLine;
  if DebugReader.Running then
  begin
    if fprop.Breakpoint.HasBreakpoint(RealLine) then
    begin
      Breakpoint := fprop.Breakpoint.GetBreakpoint(RealLine);
      DebugReader.SendCommand(GDB_DELETE, IntToStr(Breakpoint.Index));
    end
    else
    begin
      SourcePath := ExtractFilePath(fprop.Project.FileName);
      Source := ExtractRelativePath(SourcePath, fprop.FileName);
      Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
      DebugReader.SendCommand(GDB_BREAK, DoubleQuotedStr(Source) + ':' + IntToStr(RealLine));
    end;
  end;
  Added := fprop.Breakpoint.ToogleBreakpoint(RealLine);
  fprop.Project.BreakpointChanged := True;
  if Added then
    sheet.Memo.AddBreakpoint(aLine)
  else
    sheet.Memo.DeleteBreakpoint(aLine);
end;

procedure TFrmFalconMain.RunToggleBreakpointClick(Sender: TObject);
var
  Line: Integer;
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Line := sheet.Memo.CaretY;
  ToggleBreakpoint(Line);
end;

procedure TFrmFalconMain.AddWatchDebugVariables(scopeToken: TTokenClass;
  SelLine: Integer; var LastID: Integer; var VarAdded: Integer);
var
  I: Integer;
  token: TTokenClass;
begin
  for I := 0 to scopeToken.Count - 1 do
  begin
    token := scopeToken.Items[I];
    if (token.Token in [tkVariable]) and (token.SelLine < SelLine) then
    begin
      if AddWatchItem(LastID + 1, token.Name, token, wtAuto) then
      begin
        Inc(VarAdded);
        Inc(LastID);
        DebugReader.SendCommand(GDB_DISPLAY, token.Name);
      end;
    end;
    if token.Token in [tkParams, tkScopeClass] then
    begin
      AddWatchDebugVariables(token, SelLine, LastID, VarAdded);
    end;
  end;
end;

procedure TFrmFalconMain.DeleteDebugVariables;
//var
//  I: Integer;
begin
  DebugParser.Clear;
  if WatchList.Count = 1 then
  begin
    DebugReader.SendCommand(GDB_DELETE + ' ' + GDB_DISPLAY,
      IntToStr(WatchList.Items[0].ID));
  end
  else if WatchList.Count > 1 then
  begin
    DebugReader.SendCommand(GDB_DELETE + ' ' + GDB_DISPLAY,
      IntToStr(WatchList.Items[0].ID) + '-' +
      IntToStr(WatchList.Items[WatchList.Count - 1].ID));
  end;
  {for I := 0 to WatchList.Count - 1 do
  begin
    DebugReader.SendCommand(GDB_DELETE  + ' ' + GDB_DISPLAY,
      IntToStr(WatchList.Items[I].ID));
  end;}
  WatchList.Clear;
end;

procedure TFrmFalconMain.UpdateDebugActiveVariables(Line: Integer;
  ShowContent: Boolean);
var
  sheet: TSourceFileSheet;
  scopeToken, thisToken: TTokenClass;
  SelStart: Integer;
  BC: TBufferCoord;
  LastID, I, VarAdded: Integer;
  List: TStrings;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  BC.Line := Line;
  BC.Char := 1;
  VarAdded := 0;
  SelStart := sheet.Memo.RowColToCharIndex(BC);
  List := TStringList.Create;
  thisToken := nil;
  if not FilesParsed.GetAllTokensOfScope(SelStart, ActiveEditingFile, List,
    thisToken) then
  begin
    List.Free;
    Exit;
  end;
  LastID := DebugReader.LastDisplayID;
  if Assigned(thisToken) and AddWatchItem(LastID + 1, '*this', thisToken,
    wtAuto) then
  begin
    Inc(LastID);
    DebugReader.SendCommand(GDB_DISPLAY, '*this');
    Inc(VarAdded);
  end;
  for I := 0 to List.Count - 1 do
  begin
    scopeToken := TTokenClass(List.Objects[I]);
    AddWatchDebugVariables(scopeToken, Line, LastID, VarAdded);
  end;
  AddWatchDebugVariables(ActiveEditingFile.VarConsts, Line, LastID, VarAdded);
  if ShowContent and (VarAdded > 0) then
    DebugReader.SendCommand(GDB_DISPLAY);
  List.Free;
end;

function TFrmFalconMain.AddWatchItem(ID: Integer; const Name: string;
  token: TTokenClass; watchType: TWatchType): Boolean;
var
  Item: TWatchVariable;
  NodeObject: TNodeObject;
begin
  Result := False;
  if WatchList.GetIndex(Name) >= 0 then
    Exit;
  WatchList.AddWatch(ID, wtAuto, Name);
  Item := TWatchVariable.Create;
  Item.Name := Name;
  Item.Token := token;
  Item.WatchType := watchType;
  if Assigned(Item.Token) then
  begin
    Item.SelLine := Item.Token.SelLine;
    Item.SelStart := Item.Token.SelStart;
    Item.SelLength := Item.Token.SelLength;
  end;
  NodeObject := TNodeObject.Create;
  NodeObject.Data := Item;
  NodeObject.Caption := Item.Name;
  TreeViewOutline.AddChild(nil, NodeObject);
  NodeObject.ImageIndex := 0;
  Result := True;
end;

function TFrmFalconMain.SearchAndOpenFile(const FileName: string;
  var fp: TSourceFile): Boolean;
var
  sheet: TSourceFileSheet;
begin
  Result := False;
  if GetActiveSheet(sheet) then
  begin
    fp := Sheet.SourceFile;
    if CompareText(fp.FileName, FileName) <> 0 then
    begin
      if not SearchSourceFile(FileName, fp) then
      begin
        if FileExists(FileName) then
          fp := OpenFile(FileName)
        else
          Exit;
      end;
    end;
  end
  else
  begin
    if not SearchSourceFile(FileName, fp) then
    begin
      if FileExists(FileName) then
        fp := OpenFile(FileName)
      else
        Exit;
    end;
  end;
  Result := True;
end;
//Repaint old active line and draw current debug line

procedure TFrmFalconMain.UpdateActiveDebugLine(fp: TSourceFile;
  Line: Integer);
var
  sheet: TSourceFileSheet;
  OldActLine: integer;
begin
  sheet := fp.Edit;
  DebugActiveFile := fp;
  OldActLine := DebugActiveLine;
  DebugActiveLine := Line;
  if OldActLine > 0 then
    sheet.Memo.RemoveActiveLine(OldActLine);
  //make code visible
  if GetForegroundWindow <> Handle then
    SwitchToThisWindow(Handle, False);
  //set cursor position and align line on center of editor
  if DebugActiveLine > 0 then
  begin
    sheet.Memo.SetActiveLine(DebugActiveLine);
    GotoLineAndAlignCenter(sheet.Memo, DebugActiveLine);
  end;
end;

procedure TFrmFalconMain.DebugReaderCommand(Sender: TObject;
  Command: TDebugCmd; const Name, Value: string; Line: Integer);
var
  sheet: TSourceFileSheet;
  fp: TSourceFile;
  varID, Index: Integer;
  S, FileName: string;
  Breakpoint: TBreakpoint;
  token: TTokenClass;
  dbgc: TDebugCommand;
begin
  //AddMessage(Value, DebugCmdNames[Command] + ' - ' + Name, Value, Line,
  //  0, 0, mitGoto);
  case Command of
    dcBreakpoint:
      begin
        if GetActiveSheet(sheet) then
        begin
          fp := Sheet.SourceFile;
          S := ExtractFilePath(fp.Project.FileName);
          FileName := ConvertSlashes(S + Name);
          if CompareText(fp.FileName, FileName) <> 0 then
            if not SearchSourceFile(FileName, fp) then
              Exit;
        end
        else if Assigned(LastProjectBuild) then
        begin
          S := ExtractFilePath(LastProjectBuild.FileName);
          FileName := ConvertSlashes(S + Name);
          if not SearchSourceFile(FileName, fp) then
            Exit;
        end
        else
          Exit;
        if fp.Breakpoint.HasBreakpoint(Line) then
        begin
          Breakpoint := fp.Breakpoint.GetBreakpoint(Line);
          Breakpoint.Index := StrToInt(Value);
        //AddItemMsg('breakpoint set index', Value, Line);
        end;
      end;
    dcLocalize:
      begin
        if not SearchAndOpenFile(Name, fp) then
          Exit;
        UpdateActiveDebugLine(fp, Line);
        DeleteDebugVariables;
        UpdateDebugActiveVariables(Line);
        DebugReader.SendCommand(GDB_DISPLAY);
      end;
    dcOnBreak:
      begin
        if Assigned(LastProjectBuild) then
        begin
          Breakpoint := LastProjectBuild.BreakpointCursor;
          if Breakpoint.Valid and (Breakpoint.Line = Line) and
            (CompareText(Breakpoint.FileName, Name) = 0) then
          begin
            DebugReader.SendCommand(GDB_DELETE, Value);
            LastProjectBuild.BreakpointCursor.Valid := False;
          end;
        end;
        if DebugReader.FunctionChanged then
          DeleteDebugVariables;
        UpdateDebugActiveVariables(Line);
        DebugReader.SendCommand(GDB_DISPLAY);
      //DebugReader.SendCommand(GDB_INFO, GDB_DISPLAY);
      end;
    dcIdle:
      begin
        if not CommandQueue.Empty then
        begin
          DebugHint.Cancel;
          CanShowHintTip := False;
        end;
      end;
    dcNoSymbol:
      begin
        if not CommandQueue.Empty then
        begin
          if CommandQueue.Front.VarName = Name then
            CommandQueue.Dequeue;
        end;
        DebugHint.Cancel;
        CanShowHintTip := False;
        CommandQueue.Clear;
      end;
    dcNextLine:
      begin
        if not SearchAndOpenFile(Name, fp) then
          Exit;
        UpdateActiveDebugLine(fp, Line);
        UpdateDebugActiveVariables(Line, True);
        CommandQueue.Clear;
      end;
    dcOnAddWatch, dcOnWatchPoint:
      begin
      end;
    dcDisplay:
      begin
        Index := WatchList.GetIndex(Line);
        if Index < 0 then
          Index := WatchList.UpdateID(Name, Line);
        if Index >= 0 then
          DebugParser.Fill(Name + ' = ' + Value, nil);
        CommandQueue.Clear;
      end;
    dcPrint:
      begin
        if not GetActiveSheet(sheet) or CommandQueue.Empty then
          Exit;
        dbgc := CommandQueue.Front;
        fp := Sheet.SourceFile;
        S := dbgc.VarName + ' = ' + Value;
        varID := StrToInt(Name);
        if varID <> dbgc.ID then
        begin
        //AddItemMsg('Diff ID of ' + dbgc.VarName,
        //  Format('%d = %d? ' + Value, [varID, dbgc.ID]), Line);
        end;
        token := TTokenClass(dbgc.Data);
        case dbgc.CmdType of
          dctPrint:
            begin
              DebugHint.UpdateHint(S, dbgc.Point.X,
                dbgc.Point.Y + sheet.Memo.LineHeight + 6, token);
            end;
          dctAutoWatch: //not used
            begin
            end;
        end;
      //delete dbgc also
        CommandQueue.Dequeue;
      end;
    dcTerminate:
      begin
        DebugReader.SendCommand(GDB_QUIT);
        DebugHint.Cancel;
        CanShowHintTip := False;
      end;
    dcExternalStep, dcOnExiting:
      begin
        InvalidateDebugLine;
        DebugReader.SendCommand(GDB_CONTINUE);
      end;
    dcUnknow:
      begin
        DebugHint.Cancel;
        CanShowHintTip := False;
        CommandQueue.Clear;
      end;
  else
  end;
end;

procedure TFrmFalconMain.DebugReaderFinish(Sender: TObject;
  ExitCode: Integer);
var
  prop: TSourceFile;
  OldActLine: Integer;
  sheet: TSourceFileSheet;
  FindedTokenFile: TTokenFile;
begin
  if GetActiveSheet(sheet) then
  begin
    OldActLine := DebugActiveLine;
    DebugActiveLine := 0;
    if OldActLine > 0 then
      sheet.Memo.RemoveActiveLine(OldActLine);
  end;
  DebugParser.Clear;
  DebugHint.Cancel;
  DebugActiveFile := nil;
  CommandQueue.Clear;
  WatchList.Clear;
  TreeViewOutline.Images := ImgListOutLine;
  TSOutline.Caption := STR_FRM_MAIN[3];
  if GetActiveSheet(sheet) then
  begin
    prop := Sheet.SourceFile;
    FindedTokenFile := FilesParsed.ItemOfByFileName(Prop.FileName);
    if FindedTokenFile <> nil then
      UpdateActiveFileToken(FindedTokenFile);
  end;
  LauncherFinished(Sender);
end;

procedure TFrmFalconMain.DebugReaderStart(Sender: TObject);
begin
  Caption := 'Falcon C++ [' + STR_FRM_MAIN[44] + ']';
  RunRun.Caption := STR_FRM_MAIN[51];
  BtnRun.Caption := STR_FRM_MAIN[51];
  BtnRun.Hint := STR_FRM_MAIN[51];
  UpdateMenuItems([rmProject, rmRun]);
  TreeViewOutline.Clear;
  TSOutline.Caption := STR_FRM_MAIN[50];
  TreeViewOutline.Images := ImageListDebug;
  //TreeViewOutline.Indent := ImageListDebug.Width + 3;
end;

procedure TFrmFalconMain.RunContinue(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_CONTINUE);
end;

procedure TFrmFalconMain.RunRevContinue(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_REVERSE+'-'+GDB_CONTINUE);
end;

procedure TFrmFalconMain.RunStepIntoClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_STEP);
end;

procedure TFrmFalconMain.RunRevStepIntoClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_REVERSE+'-'+GDB_STEP);
end;

procedure TFrmFalconMain.RunStepOverClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_NEXT);
end;

procedure TFrmFalconMain.RunRevStepOverClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_REVERSE+'-'+GDB_NEXT);
end;

procedure TFrmFalconMain.RunStepReturnClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_FINISH);
end;

procedure TFrmFalconMain.RunRevStepReturnClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_REVERSE+'-'+GDB_FINISH);
end;

procedure TFrmFalconMain.SelectTheme(Theme: string);
begin
  TBXSwitcher.Theme := Theme;
  Config.Environment.Theme := Theme;
  Color := CurrentTheme.GetViewColor(TVT_MENUBAR);
  if Theme = 'Default' then
  begin
    ViewThemeDef.Checked := True;
  end
  else if Theme = 'Office2003' then
  begin
    ViewThemeOffice2003.Checked := True;
  end
  else if Theme = 'OfficeXP' then
  begin
    ViewThemeOffXP.Checked := True;
  end
  else if Theme = 'Stripes' then
  begin
    ViewThemeStripes.Checked := True;
  end
  else if Theme = 'Professional' then
  begin
    ViewThemeProfessional.Checked := True;
  end
  else if Theme = 'Aluminum' then
  begin
    ViewThemeAluminum.Checked := True;
  end;
  DockLeft.Color := Color;
  DockTop.Color := Color;
  DockRight.Color := Color;
  DockBottom.Color := Color;
  ProjectPanel.Color := Color;
  PanelOutline.Color := Color;
  ProjectPanel.Color := Color;
  PanelEditorMessages.Color := Color;
  PanelOutline.Color := Color;
  PanelEditorMessages.Color := Color;
  PageControlProjects.Color := Color;
  PageControlMessages.Color := Color;
  PageControlEditor.Color := Color;
  PageControlOutline.Color := Color;
end;

procedure TFrmFalconMain.SelectThemeClick(Sender: TObject);
var
  Item: TTBXItem;
begin
  Item := TTBXItem(Sender);
  case Item.Tag of
    0: SelectTheme('Default');
    1: SelectTheme('Office2003');
    2: SelectTheme('OfficeXP');
    3: SelectTheme('Stripes');
    4: SelectTheme('Professional');
    5: SelectTheme('Aluminum');
  end;
end;

procedure TFrmFalconMain.PupMsgClearClick(Sender: TObject);
begin
  ListViewMsg.Clear;
end;

procedure TFrmFalconMain.RunRuntoCursorClick(Sender: TObject);
var
  ProjProp: TProjectFile;
  FileProp: TSourceFile;
  sheet: TSourceFileSheet;
  SourcePath, Source: string;
begin
  if GetActiveSheet(sheet) then
  begin
    FileProp := Sheet.SourceFile;
    ProjProp := FileProp.Project;
    ProjProp.BreakpointChanged := True;
    ProjProp.BreakpointCursor.Line := sheet.Memo.CaretY;
    ProjProp.BreakpointCursor.Valid := True;
    ProjProp.BreakpointCursor.FileName := FileProp.FileName;
    if DebugReader.Running then
    begin
      SourcePath := ExtractFilePath(ProjProp.FileName);
      Source := ExtractRelativePath(SourcePath, FileProp.FileName);
      Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
      DebugReader.SendCommand(GDB_BREAK, DoubleQuotedStr(Source) + ':' +
        IntToStr(ProjProp.BreakpointCursor.Line));
      DebugReader.SendCommand(GDB_CONTINUE);
      Exit;
    end;
    CompilerActiveMsg := STR_FRM_MAIN[18];
    if ProjProp.NeedBuild then
    begin
      FCompilationStopped := False;
      RunNow := True;
      ProjProp.Build;
    end
    else
      ExecuteApplication(ProjProp);
  end;
end;

procedure TFrmFalconMain.SearchGotoFunctionClick(Sender: TObject);
var
  List, Files: TStrings;
  Node: TTreeNode;
  Proj: TProjectFile;
  I: Integer;
  FindedTokenFile: TTokenFile;
begin
  List := TStringList.Create;
  Node := TreeViewProjects.Items.GetFirstNode;
  Files := TStringList.Create;
  while Node <> nil do
  begin
    Proj := TProjectFile(Node.Data);
    Files.Clear;
    Proj.GetFiles(Files);
    for I := 0 to Files.Count - 1 do
    begin
      FindedTokenFile := FilesParsed.ItemOfByFileName(Files.Strings[I]);
      if FindedTokenFile <> nil then
        FindedTokenFile.GetFunctions(List, '');
    end;
    Node := Node.getNextSibling;
  end;
  Files.Free;
  FormGotoFunction := TFormGotoFunction.CreateParented(Handle);
  FormGotoFunction.Fill(List);
  List.Free;
  FormGotoFunction.ShowModal;
end;

procedure TFrmFalconMain.SearchGotoLineClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  if sheet.Memo.Lines.Count < 3 then
    Exit;
  FormGotoLine := TFormGotoLine.CreateParented(Handle);
  FormGotoLine.ShowWithRange(1, sheet.Memo.CaretY, sheet.Memo.Lines.Count);
end;

procedure TFrmFalconMain.SearchGotoPrevFuncClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  fprop: TSourceFile;
  TokenFile: TTokenFile;
  token: TTokenClass;
  Buffer: TBufferCoord;
  FindedTokenFile: TTokenFile;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := Sheet.SourceFile;
  FindedTokenFile := FilesParsed.ItemOfByFileName(fprop.FileName);
  if FindedTokenFile = nil then
    Exit;
  TokenFile := FindedTokenFile;
  if not TokenFile.GetPreviousFunction(token, sheet.Memo.SelStart) then
    Exit;
  token := GetTokenByName(token, 'Scope', tkScope);
  Buffer := sheet.Memo.CharIndexToRowCol(Token.SelStart);
  GotoLineAndAlignCenter(sheet.Memo, Buffer.Line, Buffer.Char);
end;

procedure TFrmFalconMain.SearchGotoNextFuncClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
  fprop: TSourceFile;
  TokenFile: TTokenFile;
  token: TTokenClass;
  Buffer: TBufferCoord;
  FindedTokenFile: TTokenFile;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := Sheet.SourceFile;
  FindedTokenFile := FilesParsed.ItemOfByFileName(fprop.FileName);
  if FindedTokenFile = nil then
    Exit;
  TokenFile := FindedTokenFile;
  if not TokenFile.GetNextFunction(token, sheet.Memo.SelStart) then
    Exit;
  token := GetTokenByName(token, 'Scope', tkScope);
  Buffer := sheet.Memo.CharIndexToRowCol(Token.SelStart);
  GotoLineAndAlignCenter(sheet.Memo, Buffer.Line, Buffer.Char);
end;

procedure TFrmFalconMain.PopupProjectPopup(Sender: TObject);
begin
  UpdateMenuItems([rmProjectsPopup]);
end;

procedure TFrmFalconMain.TreeViewOutlineGetImageIndex(
  Sender: TBaseNativeTreeView; Node: PNativeNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  if NodeObject.Data = nil then
    Exit;
  ImageIndex := NodeObject.ImageIndex;
end;

procedure TFrmFalconMain.TreeViewOutlineDrawText(
  Sender: TBaseNativeTreeView; TargetCanvas: TCanvas; Node: PNativeNode;
  Column: TColumnIndex; const Text: string; const CellRect: TRect;
  var DefaultDraw: Boolean);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  if not DebugReader.Running and Assigned(NodeObject.Data) then
  begin
    PaintTokenItemV2(TargetCanvas, CellRect, TTokenClass(NodeObject.Data),
      Sender.Selected[Node], Sender.FocusedNode = Node, DefaultDraw);
    //DefaultDraw := False;
  end;
end;

procedure TFrmFalconMain.TreeViewOutlineGetText(
  Sender: TBaseNativeTreeView; Node: PNativeNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  CellText := NodeObject.Caption;
end;

procedure TFrmFalconMain.TreeViewOutlineFreeNode(
  Sender: TBaseNativeTreeView; Node: PNativeNode);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  NodeObject.Free;
end;

procedure TFrmFalconMain.TreeViewOutline_DblClick(Sender: TObject);
var
  Token: TTokenClass;
  Node: PNativeNode;
begin
  Node := TreeViewOutline.GetFirstSelected;
  if Node = nil then
    Exit;
  Token := TTokenClass(TNodeObject(TreeViewOutline.GetNodeData(Node)^).Data);
  if Token.Token in [tkIncludeList, tkDefineList, tkTreeObjList, tkVarConsList,
    tkFuncProList] then
    Exit;
  if not DebugReader.Running then
    SelectToken(Token);
end;

procedure TFrmFalconMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if [ssShift] = Shift then
  begin
    if Key = VK_F9 then
      RunRevContinue(Sender)
    else if Key = VK_F8 then
      RunRevStepIntoClick(Sender)
    else if Key = VK_F7 then
      RunRevStepOverClick(Sender)
    else if Key = VK_F6 then
      RunRevStepReturnClick(Sender);
  end
  else if [ssCtrl] = Shift then
  begin
    if Key = VK_F4 then
      FileCloseClick(Sender);
  end;
end;

procedure TFrmFalconMain.SysCommandProc(var Msg: TWMSysCommand);
begin
  case Msg.CmdType of
    SC_SCREENSAVE, 					// Screensaver Trying To Start?
    SC_MONITORPOWER:				// Monitor Trying To Enter Powersave?
    begin
      if FrmPos.FullScreen then
      begin
        Msg.Result := 0;  	// Prevent From Happening
        Exit;
      end;
    end;
  end;
  inherited;
end;

procedure TFrmFalconMain.SelectFromSelStart(SelStart, SelCount: Integer;
  Memo: TEditor);
var
  BS, BE: TBufferCoord;
begin
  BS := Memo.CharIndexToRowCol(SelStart);
  BE := Memo.CharIndexToRowCol(SelStart + SelCount);
  Memo.SetCaretAndSelection(BE, BS, BE);
end;

procedure TFrmFalconMain.PluginHandler(var message: TMessage);
var
  PlgMsg: PDispatchCommand;
begin
  PlgMsg := PDispatchCommand(message.LParam);
  message.Result := FPluginManager.ReceiveCommand(message.WParam,
    PlgMsg^.Command, PlgMsg^.Widget, PlgMsg^.Param, PlgMsg^.Data);
end;

procedure TFrmFalconMain.EditCollapseAllClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  sheet.Memo.CollapseAll;
end;

procedure TFrmFalconMain.EditUncollapseAllClick(Sender: TObject);
var
  sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  sheet.Memo.UncollapseAll;
end;

procedure TFrmFalconMain.MenuBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CodeCompletion.CancelCompletion;
end;

end.

