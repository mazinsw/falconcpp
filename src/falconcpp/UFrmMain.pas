unit UFrmMain;

interface

{$I Falcon.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, XPMan, ImgList, ExtCtrls,
  ShellApi, UConfig,
  UTemplates, SendData, OutputConsole, ShlObj, FormEffect,
  PNGImage, USourceFile, Clipbrd, CompletionProposal, UUtils,
  UFrmEditorOptions, FileDownload, SplashScreen, FormPosition, IniFiles,
  // themes

  // end themes
  AppEvnts, ThreadTokenFiles, CppParser, TokenConst, TokenFile,
  TokenHint, TokenList, TokenUtils,
  CommCtrl, DebugReader, CommandQueue,
  DebugConsts, CppTokenizer,
  XMLDoc, XMLIntf, BreakPoint, HintTree, DebugWatch,
  UParseMsgs, XPPanels, ModernTabs, ThreadFileDownload, VirtualTrees, SyncObjs,
  PluginManager, PluginServiceManager, UEditor, CppHighlighter, SintaxList,
  AutoComplete, DScintillaTypes, SearchEngine, SystemUtils, CompilerSettings,
  SIImageList, {*libclang,*}
  { TB2K }
  TB2Item, TB2Dock, TB2Toolbar, SpTBXSkins, SpTBXItem, SpTBXControls, SpTBXDkPanels;

const
  crReverseArrow = TCursor(-99);
  MAX_OUTLINE_TREE_IMAGES = 29;
  TreeImages: array [0 .. MAX_OUTLINE_TREE_IMAGES - 1] of Integer = (0,
    // Include List
    1, // include
    2, // Define List
    18, // define
    3, // Variables and Constants List
    9, // public variable
    10, // private variable
    11, // protected variable
    3, // Function and Prototype List
    15, // public function
    16, // private function
    17, // protected function
    14, // prototype
    3, // Type List
    4, // class
    5, // struct
    6, // union
    7, // enum
    19, // namespace
    20, // typedef
    5, // typedef struct
    6, // typedef union
    7, // typedef enum
    21, // Enum Item
    8, // typedef prototype
    12, // constructor
    13, // destructor
    22, // code template
    -1 // type
    );

  FILE_IMG_LIST: array [1 .. 9] of Integer = (1, 2, 3, 4, 5, 6, 0, 26, 20);

  WM_RELOADFTM = WM_USER + $1008;
  WM_REPARSEFILES = WM_RELOADFTM + 1;
  WM_FALCONCPP_PLUGIN = WM_USER + $1221;
  MINLINE_TOENABLE_GOTOLINE = 3;
{$EXTERNALSYM PBS_MARQUEE}
  PBS_MARQUEE = $0008;
{$EXTERNALSYM PBM_SETMARQUEE}
  PBM_SETMARQUEE = WM_USER + 10;
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

  // Outline objects images
  TOutlineImages = array [0 .. MAX_OUTLINE_TREE_IMAGES - 1] of Integer;

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
    DockTop: TSpTBXDock;
    DefaultBar: TSpTBXToolbar;
    BtnNew: TSpTBXSubmenuItem;
    BtnOpen: TSpTBXItem;
    BtnRemove: TSpTBXItem;
    BtnSaveAll: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    BtnSave: TSpTBXItem;
    EditBar: TSpTBXToolbar;
    BtnUndo: TSpTBXItem;
    BtnRedo: TSpTBXItem;
    NavigatorBar: TSpTBXToolbar;
    BtnPrevPage: TSpTBXItem;
    BtnNextPage: TSpTBXItem;
    CompilerBar: TSpTBXToolbar;
    BtnRun: TSpTBXItem;
    BtnCompile: TSpTBXItem;
    BtnStop: TSpTBXItem;
    SpTBXSeparatorItem9: TSpTBXSeparatorItem;
    BtnExecute: TSpTBXItem;
    ProjectBar: TSpTBXToolbar;
    BtnNewProj: TSpTBXItem;
    BtnProperties: TSpTBXItem;
    PopupProject: TSpTBXPopupMenu;
    HelpBar: TSpTBXToolbar;
    BtnContxHelp: TSpTBXItem;
    BtnHelp: TSpTBXItem;
    DebugBar: TSpTBXToolbar;
    PopProjNew: TSpTBXSubmenuItem;
    SpTBXSeparatorItem23: TSpTBXSeparatorItem;
    PopProjOpen: TSpTBXItem;
    PopProjEdit: TSpTBXItem;
    SpTBXSeparatorItem24: TSpTBXSeparatorItem;
    PopProjDelFromDsk: TSpTBXItem;
    PopProjRemove: TSpTBXItem;
    PopProjRename: TSpTBXItem;
    SpTBXSeparatorItem25: TSpTBXSeparatorItem;
    PopProjProp: TSpTBXItem;
    MenuDock: TSpTBXDock;
    MenuBar: TSpTBXToolbar;
    MenuFile: TSpTBXSubmenuItem;
    FileNew: TSpTBXSubmenuItem;
    FileNewProject: TSpTBXItem;
    FileNewC: TSpTBXItem;
    FileNewCpp: TSpTBXItem;
    FileNewHeader: TSpTBXItem;
    FileNewResource: TSpTBXItem;
    FileNewEmpty: TSpTBXItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    FileNewFolder: TSpTBXItem;
    FileOpen: TSpTBXItem;
    FileReopen: TSpTBXSubmenuItem;
    FileReopenClear: TSpTBXItem;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    FileSave: TSpTBXItem;
    FileSaveAs: TSpTBXItem;
    FileSaveAll: TSpTBXItem;
    SpTBXSeparatorItem22: TSpTBXSeparatorItem;
    FileImport: TSpTBXSubmenuItem;
    FileImpDevCpp: TSpTBXItem;
    FileImpCodeBlocks: TSpTBXItem;
    FileImpMSVC: TSpTBXItem;
    FileExport: TSpTBXSubmenuItem;
    FileExportHTML: TSpTBXItem;
    FileExportRTF: TSpTBXItem;
    SpTBXSeparatorItem15: TSpTBXSeparatorItem;
    FileClose: TSpTBXItem;
    FileCloseAll: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    FileExit: TSpTBXItem;
    MenuEdit: TSpTBXSubmenuItem;
    EditUndo: TSpTBXItem;
    EditRedo: TSpTBXItem;
    SpTBXSeparatorItem7: TSpTBXSeparatorItem;
    EditCut: TSpTBXItem;
    EditCopy: TSpTBXItem;
    EditPaste: TSpTBXItem;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    EditSelectAll: TSpTBXItem;
    MenuSearch: TSpTBXSubmenuItem;
    SearchFind: TSpTBXItem;
    SearchFindNext: TSpTBXItem;
    SearchFindPrev: TSpTBXItem;
    SearchFindFiles: TSpTBXItem;
    SearchReplace: TSpTBXItem;
    SearchIncremental: TSpTBXItem;
    SpTBXSeparatorItem16: TSpTBXSeparatorItem;
    SearchGotoFunction: TSpTBXItem;
    SearchGotoLine: TSpTBXItem;
    MenuView: TSpTBXSubmenuItem;
    ViewProjMan: TSpTBXItem;
    ViewStatusBar: TSpTBXItem;
    ViewCompOut: TSpTBXItem;
    ViewOutline: TSpTBXItem;
    ViewToolbar: TSpTBXSubmenuItem;
    ViewToolbarDefault: TSpTBXItem;
    ViewToolbarEdit: TSpTBXItem;
    ViewToolbarSearch: TSpTBXItem;
    ViewToolbarCompiler: TSpTBXItem;
    ViewToolbarNavigator: TSpTBXItem;
    ViewToolbarProject: TSpTBXItem;
    ViewToolbarHelp: TSpTBXItem;
    ViewThemes: TSpTBXSubmenuItem;
    ViewZoom: TSpTBXSubmenuItem;
    ViewZoomInc: TSpTBXItem;
    ViewZoomDec: TSpTBXItem;
    SpTBXSeparatorItem21: TSpTBXSeparatorItem;
    ViewFullScreen: TSpTBXItem;
    SpTBXSeparatorItem20: TSpTBXSeparatorItem;
    ViewRestoreDefault: TSpTBXItem;
    MenuProject: TSpTBXSubmenuItem;
    ProjectAdd: TSpTBXItem;
    ProjectRemove: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    ProjectBuild: TSpTBXItem;
    SpTBXSeparatorItem10: TSpTBXSeparatorItem;
    ProjectProperties: TSpTBXItem;
    MenuRun: TSpTBXSubmenuItem;
    RunRun: TSpTBXItem;
    RunStop: TSpTBXItem;
    SpTBXSeparatorItem12: TSpTBXSeparatorItem;
    RunCompile: TSpTBXItem;
    RunExecute: TSpTBXItem;
    MenuTools: TSpTBXSubmenuItem;
    ToolsEnvOptions: TSpTBXItem;
    ToolsCompilerOptions: TSpTBXItem;
    ToolsEditorOptions: TSpTBXItem;
    SpTBXSeparatorItem18: TSpTBXSeparatorItem;
    ToolsTemplate: TSpTBXItem;
    ToolsPackageCreator: TSpTBXItem;
    SpTBXSeparatorItem19: TSpTBXSeparatorItem;
    ToolsPackages: TSpTBXItem;
    MenuHelp: TSpTBXSubmenuItem;
    HelpTipOfDay: TSpTBXItem;
    SpTBXSeparatorItem11: TSpTBXSeparatorItem;
    HelpUpdate: TSpTBXItem;
    SpTBXSeparatorItem13: TSpTBXSeparatorItem;
    HelpAbout: TSpTBXItem;
    PopupEditor: TSpTBXPopupMenu;
    PopEditorProperties: TSpTBXItem;
    PopEditorSelectAll: TSpTBXItem;
    SpTBXSeparatorItem8: TSpTBXSeparatorItem;
    PopEditorRedo: TSpTBXItem;
    PopEditorUndo: TSpTBXItem;
    SpTBXSeparatorItem26: TSpTBXSeparatorItem;
    SpTBXSeparatorItem27: TSpTBXSeparatorItem;
    PopEditorDelete: TSpTBXItem;
    PopEditorPaste: TSpTBXItem;
    PopEditorCopy: TSpTBXItem;
    PopEditorCut: TSpTBXItem;
    PopEditorTools: TSpTBXSubmenuItem;
    DockBottom: TSpTBXDock;
    DockLeft: TSpTBXDock;
    DockRight: TSpTBXDock;
    ViewToolbarDebug: TSpTBXItem;
    SearchBar: TSpTBXToolbar;
    BtnFind: TSpTBXItem;
    BtnReplace: TSpTBXItem;
    BtnGotoLN: TSpTBXItem;
    SpTBXSeparatorItem29: TSpTBXSeparatorItem;
    HelpFalcon: TSpTBXSubmenuItem;
    HelpFalconFalcon: TSpTBXItem;
    PopupMsg: TSpTBXPopupMenu;
    PupMsgGotoLine: TSpTBXItem;
    SpTBXSeparatorItem31: TSpTBXSeparatorItem;
    PupMsgOriMsg: TSpTBXItem;
    SpTBXSeparatorItem32: TSpTBXSeparatorItem;
    PupMsgCopyOri: TSpTBXItem;
    PupMsgCopy: TSpTBXItem;
    TimerChangeDelay: TTimer;
    ImgListMenus: TImageList;
    SpTBXSeparatorItem33: TSpTBXSeparatorItem;
    BtnGotoBook: TSpTBXSubmenuItem;
    BtnToggleBook: TSpTBXSubmenuItem;
    PopEditorBookmarks: TSpTBXSubmenuItem;
    PopEditorGotoBookmarks: TSpTBXSubmenuItem;
    SpTBXSeparatorItem34: TSpTBXSeparatorItem;
    SpTBXSeparatorItem36: TSpTBXSeparatorItem;
    EditBookmarks: TSpTBXSubmenuItem;
    SpTBXItem35: TSpTBXItem;
    SpTBXItem36: TSpTBXItem;
    SpTBXItem37: TSpTBXItem;
    SpTBXItem38: TSpTBXItem;
    SpTBXItem44: TSpTBXItem;
    SpTBXItem45: TSpTBXItem;
    SpTBXItem46: TSpTBXItem;
    SpTBXItem47: TSpTBXItem;
    SpTBXItem50: TSpTBXItem;
    EditGotoBookmarks: TSpTBXSubmenuItem;
    SpTBXItem58: TSpTBXItem;
    SpTBXItem62: TSpTBXItem;
    SpTBXItem65: TSpTBXItem;
    SpTBXItem66: TSpTBXItem;
    SpTBXItem71: TSpTBXItem;
    SpTBXItem74: TSpTBXItem;
    SpTBXItem75: TSpTBXItem;
    SpTBXItem76: TSpTBXItem;
    SpTBXItem78: TSpTBXItem;
    SpTBXSeparatorItem37: TSpTBXSeparatorItem;
    EditIndent: TSpTBXItem;
    TimerHintTipEvent: TTimer;
    ApplicationEvents: TApplicationEvents;
    TimerHintParams: TTimer;
    FilePrint: TSpTBXItem;
    SpTBXSeparatorItem38: TSpTBXSeparatorItem;
    FileRemove: TSpTBXItem;
    EditUnindent: TSpTBXItem;
    EditDelete: TSpTBXItem;
    FileExportTeX: TSpTBXItem;
    PopEditorSwap: TSpTBXItem;
    SpTBXSeparatorItem28: TSpTBXSeparatorItem;
    PopupTabs: TSpTBXPopupMenu;
    PopTabsClose: TSpTBXItem;
    PopTabsCloseAllOthers: TSpTBXItem;
    PopTabsCloseAll: TSpTBXItem;
    SpTBXSeparatorItem35: TSpTBXSeparatorItem;
    PopTabsSave: TSpTBXItem;
    PopTabsSaveAll: TSpTBXItem;
    SpTBXSeparatorItem39: TSpTBXSeparatorItem;
    PopTabsSwap: TSpTBXItem;
    SpTBXSeparatorItem40: TSpTBXSeparatorItem;
    PopTabsTabsAtBottom: TSpTBXItem;
    PopTabsTabsAtTop: TSpTBXItem;
    SpTBXSeparatorItem41: TSpTBXSeparatorItem;
    PopTabsProperties: TSpTBXItem;
    EditSwap: TSpTBXItem;
    SpTBXSeparatorItem42: TSpTBXSeparatorItem;
    SpTBXSeparatorItem43: TSpTBXSeparatorItem;
    EditFormat: TSpTBXItem;
    PopProjAdd: TSpTBXItem;
    PopEditorCompClass: TSpTBXItem;
    PopEditorOpenDecl: TSpTBXItem;
    SpTBXSeparatorItem44: TSpTBXSeparatorItem;
    ImageListGutter: TImageList;
    RunStepReturn: TSpTBXItem;
    RunStepInto: TSpTBXItem;
    RunStepOver: TSpTBXItem;
    RunToggleBreakpoint: TSpTBXItem;
    RunRuntoCursor: TSpTBXItem;
    BtnStepInto: TSpTBXItem;
    BtnStepOver: TSpTBXItem;
    BtnStepReturn: TSpTBXItem;
    PupMsgClear: TSpTBXItem;
    ImgListCountry: TImageList;
    SearchGotoPrevFunc: TSpTBXItem;
    SearchGotoNextFunc: TSpTBXItem;
    ImageListDebug: TImageList;
    PanelEditorMessages: TPanel;
    StatusBar: TSpTBXStatusBar;
    ProgressBarParser: TProgressBar;
    ProjectPanel: TSplitterPanel;
    PanelOutline: TSplitterPanel;
    PanelMessages: TSplitterPanel;
    PageControlProjects: TModernPageControl;
    TSProjects: TModernTabSheet;
    TreeViewProjects: TTreeView;
    PageControlOutline: TModernPageControl;
    TSOutline: TModernTabSheet;
    PageControlEditor: TModernPageControl;
    PageControlMessages: TModernPageControl;
    TSMessages: TModernTabSheet;
    ListViewMsg: TListView;
    TreeViewOutline: TVirtualStringTree;
    SpTBXSeparatorItem14: TSpTBXSeparatorItem;
    PopTabsCopyDir: TSpTBXItem;
    PopTabsCopyFullFileName: TSpTBXItem;
    PopTabsCopyFileName: TSpTBXItem;
    SpTBXSeparatorItem17: TSpTBXSeparatorItem;
    PopTabsReadOnly: TSpTBXItem;
    EditToggleComment: TSpTBXItem;
    SpTBXSeparatorItem30: TSpTBXSeparatorItem;
    SpTBXSeparatorItem45: TSpTBXSeparatorItem;
    EditCollapseAll: TSpTBXItem;
    EditUncollapseAll: TSpTBXItem;
    PopupMenuLineEnding: TSpTBXPopupMenu;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    PopupMenuEncoding: TSpTBXPopupMenu;
    PopEncANSI: TSpTBXItem;
    PopEncUTF8: TSpTBXItem;
    PopEncUCS2: TSpTBXItem;
    SpTBXSeparatorItem46: TSpTBXSeparatorItem;
    PopEncWithBOM: TSpTBXItem;
    FileNewConfig: TSpTBXItem;
    BarItemFileName: TSpTBXLabelItem;
    BarItemLineStatus: TSpTBXLabelItem;
    BarItemBuildStatus: TSpTBXLabelItem;
    BarItemProgressBar: TTBControlItem;
    SpTBXRightAlignSpacerItem1: TSpTBXRightAlignSpacerItem;
    BarItemLineEnding: TSpTBXSubmenuItem;
    BarItemEncoding: TSpTBXSubmenuItem;
    SubmenuEnding: TSpTBXSubmenuItem;
    SubmenuEncoding: TSpTBXSubmenuItem;
    SpTBXSeparatorItem47: TSpTBXSeparatorItem;
    SpTBXSeparatorItem48: TSpTBXSeparatorItem;
    SpTBXSeparatorItem49: TSpTBXSeparatorItem;
    SpTBXSeparatorItem50: TSpTBXSeparatorItem;
    SpTBXSkinGroupItem1: TSpTBXSkinGroupItem;
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
    procedure EditorBeforeCreate(SourceFile: TSourceFile);
    procedure FileCloseClick(Sender: TObject);
    procedure RunExecuteClick(Sender: TObject);
    procedure TreeViewProjectsEnter(Sender: TObject);
    procedure PageControlEditorPageChange(Sender: TObject;
      TabIndex, PrevTabIndex: Integer);
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
    // procedure PanelEditorProc(var Msg: TMessage);
    procedure GetDropredFiles(Sender: TObject; var Msg: TMessage);
    procedure OnDragDropFiles(Sender: TObject; Files: TStrings);
    procedure CompilerCmdStart(Sender: TObject; const FileName, Params: string);
    procedure CompilerCmdFinish(Sender: TObject; const FileName, Params: string;
      ConsoleOut: TStrings; ExitCode: Integer);
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
    procedure TextEditorMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure TextEditorLinkClick(Sender: TObject; AModifiers: Integer;
      APosition: Integer);
    procedure TextEditorCharAdded(Sender: TObject; Ch: Integer);
    procedure TextEditorMouseLeave(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure TextEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextEditorKeyPress(Sender: TObject; var Key: Char);
    procedure TextEditorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TextEditorScroll(Sender: TObject);
    procedure TextEditorClick(Sender: TObject);
    procedure TextLinesDeleted(Sender: TObject; index: Integer; Count: Integer);
    procedure TextLinesInserted(Sender: TObject; index: Integer;
      Count: Integer);

    procedure TimerStartUpdateTimer(Sender: TObject);
    procedure UpdateDownloadFinish(Sender: TObject; State: TDownloadState;
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
    procedure EditorContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
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
    procedure TokenParserAllFinish(Sender: TObject); // scan current file

    procedure TimerHintTipEventTimer(Sender: TObject);
    procedure CodeCompletionExecute(Kind: TSynCompletionType; Sender: TObject;
      var CurrentInput: string; var X, Y: Integer; var CanExecute: Boolean);
    procedure CodeCompletionCodeCompletion(Sender: TObject; var Value: string;
      Shift: TShiftState; index: Integer; var EndToken: Char;
      var OffsetCaret: Integer);
    procedure TimerHintParamsTimer(Sender: TObject);
    procedure ViewCompOutClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure PageControlMsgClose(Sender: TObject; TabIndex: Integer;
      var AllowClose: Boolean);
    procedure PupMsgGotoLineClick(Sender: TObject);
    procedure SendDataReceivedStream(Sender: TObject; Value: TMemoryStream);
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
    procedure PageControlEditorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnHelpClick(Sender: TObject);
    procedure EditFormatClick(Sender: TObject);
    procedure EditIndentClick(Sender: TObject);
    procedure EditUnindentClick(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure PopEditorOpenDeclClick(Sender: TObject);
    procedure RunToggleBreakpointClick(Sender: TObject);
    // *********** debug ************************//
    procedure DebugReaderStart(Sender: TObject);
    procedure DebugReaderCommand(Sender: TObject; Command: TDebugCmd;
      const name, Value: string; Line: Integer);
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
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure CodeCompletionAfterCodeCompletion(Sender: TObject;
      const Value: string; Shift: TShiftState; index: Integer;
      var EndToken: Char);
    procedure PopupProjectPopup(Sender: TObject);
    procedure TreeViewOutlineGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeViewOutlineDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
    procedure TreeViewOutlineGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure TreeViewOutlineFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure TreeViewOutline_DblClick(Sender: TObject);
    procedure CodeCompletionGetWordBreakChars(Sender: TObject;
      var WordBreakChars, ScanBreakChars: string);
    procedure CodeCompletionGetWordEndChars(Sender: TObject;
      var WordEndChars: string; index: Integer; var Handled: Boolean);
    procedure PopEditorCompClassClick(Sender: TObject);
    procedure PopTabsCopyFullFileNameClick(Sender: TObject);
    procedure PopTabsCopyDirClick(Sender: TObject);
    procedure PopTabsCopyFileNameClick(Sender: TObject);
    procedure PopTabsReadOnlyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    procedure EncodingItemClick(Sender: TObject);
    procedure LineEndingItemClick(Sender: TObject);
    procedure PopEncWithBOMClick(Sender: TObject);
    procedure PageControlOutlineClose(Sender: TObject; TabIndex: Integer;
      var CanClose: Boolean);
    procedure PageControlProjectsClose(Sender: TObject; TabIndex: Integer;
      var CanClose: Boolean);
  private
    { Private declarations }
    fWorkerThread: TThread;

    // accept drag drop
    TreeViewProjectsOldProc: TWndMethod;
    PanelEditorMessagesOldProc: TWndMethod;
    TreeViewOutlineOldProc: TWndMethod;

    // config, resources, sintax
    OutlineImages: TOutlineImages;
    FSintaxList: TSintaxList; // highlighter list
    FConfig: TConfig; // window objects positions, zoom, etc.
    FCompilerSettings: TCompilerSettings;
    FTemplates: TTemplates; // all falcon c++ templates
    FPluginServiceManager: TPluginServiceManager;
    FPluginManager: TPluginManager;

    // paths
    FAppRoot: string; // path of executable
    CompilerActiveMsg: string; // Caption compiler info
    FConfigRoot: string; // directory configuration
    FIniConfigFile: string; // file configuration
    LastOpenFileName: string;

    // flags
    FLoadingCount: Integer;
    FTriggerOnLoading: Integer;
    ShowingReloadEnquiry: Boolean;
    FRunNow: Boolean; // ?
    ActDropDownBtn: Boolean; // ?
    XMLOpened: Boolean;
    FCompilationStopped: Boolean;
    CanShowHintTip: Boolean;
    UsingCtrlSpace: Boolean;
    FHandlingTabs: Boolean;
    LastKeyPressed: Char;
    LastMousePos: TPoint;
    LastWordHintStart: Integer;
    FEmptyLineResult: Integer;
    FEmptyCharResult: Integer;
    ActiveErrorLine: Integer;

    // include list
    FIncludeFileList: TStrings;

    // search history
    FSearchList: TStrings;
    FReplaceList: TStrings;

    // for ThreadTokenFiles
    IsLoadingSrcFiles: Boolean;
    FLastProjectBuild: TProjectBase; // last builded project
    FLastSelectedProject: TProjectBase;
    FLastPathInclude: string;
    FLastProjectIncludePath: string;
    startBuildTicks: Cardinal;
    ReloadAfterCodeCompletion: Boolean;
    fShowCodeCompletion: Integer;
    BuildTime: Cardinal;
    FZoomEditor: Integer; // edit zoom
    ActiveEditingFile: TTokenFile; // last parsed tokens
    FFilesParsed: TTokenFiles; // all files parsed

    // for Project
    ThreadFilesParsed: TThreadTokenFiles;
    AllParsedList: TStrings;
    ProjectIncludeList: TStrings;
    FProjectIncludePathList: TStrings;
    //FClangIndex: CXIndex;

    // for Cache
    ParseAllFiles: TTokenFiles; // parse unparsed static files
    ThreadLoadTkFiles: TThreadTokenFiles;
    ThreadTokenFiles: TThreadTokenFiles;
    HintTip: TTokenHintTip; // mouse over hint
    HintParams: TTokenHintParams;
    FAutoComplete: TAutoComplete; // auto complete

    // debug
    DebugReader: TDebugReader;
    WatchList: TDebugWatchList;
    CommandQueue: TCommandQueue;
    DebugActiveLine: Integer;
    DebugActiveFile: TSourceFile;
    DebugHint: THintTree;
    DebugParser: TDebugParser;

    // Completion List Colors
    CompletionColors: TCompletionColors;

    // functions
    procedure AddFilesToProject(Files: TStrings; Parent: TSourceBase;
      References: Boolean; ImportMode: Boolean = False);
    procedure StopAll;
    procedure RunApplication(ProjectFile: TProjectBase);
    procedure ExecuteApplication(ProjectFile: TProjectBase);
    procedure ShowLineError(Project: TProjectBase; Msg: TMessageItem);
    function SaveProject(ProjProp: TProjectBase; SaveMode: TSaveMode): Boolean;
    procedure InvalidateDebugLine;
    procedure AddWatchDebugVariables(scopeToken: TTokenClass; SelLine: Integer;
      var LastID: Integer; var VarAdded: Integer);
    function AddWatchItem(ID: Integer; const name: string; token: TTokenClass;
      watchType: TWatchType): Boolean;
    // function DeleteWatchItem(const Name: string): Boolean;
    function SearchAndOpenFile(const FileName: string;
      var fp: TSourceFile): Boolean;
    procedure UpdateActiveDebugLine(fp: TSourceFile; Line: Integer);
    procedure DeleteDebugVariables;
    procedure UpdateDebugActiveVariables(Line: Integer;
      ShowContent: Boolean = False);
    procedure ToggleBreakpoint(aLine: Integer);
    procedure CheckIfFilesHasChanged;
    function DetectScope(Editor: TEditor; TokenFile: TTokenFile;
      ShowInTreeview: Boolean): TTokenClass;
    procedure UpdateCompletionColors(EdtOpt: TEditorOptions);
    procedure ParseFile(FileName: string; SourceFile: TSourceFile);
    procedure ParseFiles(List: TStrings);
    function GetSelectedFileInList(var ActiveFile: TSourceBase): Boolean;
    function GetActiveProject(var Project: TProjectBase): Boolean;
    function FileInHistory(const FileName: string;
      var HistCount: Integer): Boolean;
    function AddFileToHistory(const FileName: string): Boolean;
    function OpenFileWithHistoric(Value: string;
      var ProjectBase: TProjectBase): Boolean;
    procedure RemoveFileFromHistoric(FileName: string);
    procedure TextEditorFileParsed(EditFile: TSourceFile;
      TokenFile: TTokenFile);
    function ImportDevCppProject(const FileName: string;
      var ProjectBase: TProjectBase): Boolean;
    function ImportCodeBlocksProject(const FileName: string;
      var ProjectBase: TProjectBase): Boolean;
    function ImportMSVCProject(const FileName: string;
      var ProjectBase: TProjectBase): Boolean;
    procedure DropFilesIntoProjectList(List: TStrings; X, Y: Integer);

    // outline functions
    procedure UpdateActiveFileToken(NewTokenFile: TTokenFile;
      Reload: Boolean = False);

    // hint functions
    procedure ProcessDebugHint(Input: string; Line, SelStart: Integer;
      CursorPos: TPoint);
    procedure SelectToken(token: TTokenClass);
    procedure ShowHintParams(Editor: TEditor);
    procedure ProcessHintView(SourceFile: TSourceFile; Editor: TEditor;
      const X, Y: Integer);
    procedure TextEditorUpdateStatusBar(Sender: TObject);
    procedure ExecutorStart(Sender: TObject);
    function FillTreeView(Parent: PVirtualNode; token: TTokenClass;
      DeleteNext: Boolean = False): PVirtualNode;
    procedure PaintTokenItemV2(const ToCanvas: TCanvas; DisplayRect: TRect;
      token: TTokenClass; Selected, Focused: Boolean; var DefaultDraw: Boolean);
    function FillIncludeList(IncludePathFilesOnly: Boolean): Boolean;
    procedure SwapHeaderSource(FromSrc, ToSrc: TSourceFile);
    function SearchImplementationFile(HeaderFile: TSourceFile;
      var SrcFile: TSourceFile; var SrcFileName: string): Boolean;
    function CreateTODOSourceFile(FileName: string; TokenFile: TTokenFile;
      SourceFile: TSourceFile; var TODOSourceFile: TSourceFile): Boolean;
    function SearchHeaderFile(SourceFile: TSourceFile; var HdrFile: TSourceFile;
      var HdrFileName: string): Boolean;
    procedure UpdateEditorZoom;
    function InternalMessageBox(Text, Caption: string; uType: UINT;
      Handle: HWND = 0): Integer;
    procedure UpdateStatusbar;
    procedure LoadInternetConfiguration;
    procedure DoTypeChangedSource(Source: TSourceBase; OldType: Integer);
    procedure RestoreOutline;
    function GetIsLoading: Boolean;
    procedure ReloadIncludeList(ParseFiles: Boolean);
    function CreateNode(const NodeText: string; Parent: TTreeNode;
      First: Boolean = False): TTreeNode;
    procedure DoConfigurationChanged(Sender: TObject; OldIndex: Integer);
    procedure DoDeleteSource(Source: TSourceBase);
    procedure DoRenameSource(Source: TSourceBase; const OldFileName: string);
    function InitDragDropSource(TreeSrc, TreeDst: TTreeView; var ItemSrc,
      ItemDst: TTreeNode; var SourceSrc, SourceDst: TSourceBase;
      var AttachMode: TNodeAttachMode; X, Y: Integer; Drop: Boolean): Boolean;
    function FindLastNode(Skip: TTreeNode): TTreeNode;
  public
    { Public declarations }
    LastSearch: TSearchItem;
    FalconVersion: TVersion; // this file version
    CppHighligher: TCppHighlighter;
    CodeCompletion: TCompletionProposal;
    SearchEngine: TSearchEngine;

    procedure SelectFromSelStart(SelStart, SelCount: Integer; Editor: TEditor);
    procedure SelectFromPosition(SelStart, SelEnd: Integer; Editor: TEditor);
    function CreateProject(const NodeText: string; FileType: Integer): TProjectBase;
    function CreateSource(const NodeText: string; ParentNode: TTreeNode): TSourceFile;
    function CreateFolder(const NodeText: string; ParentNode: TTreeNode): TSourceFolder;
    function CreateConfiguration(const NodeText: string; ParentNode: TTreeNode): TSourceConfiguration;
    function CreateConfigGroup(const NodeText: string; ParentNode: TTreeNode): TSourceConfigGroup;
    function RemoveFile(ParentHandle: HWND; SourceFile: TSourceBase;
      FromDisk: Boolean = False): Boolean;
    function ShowPromptOverrideFile(const FileName: string): Boolean;
    procedure UpdateLangNow;
    procedure UpdateMenuItems(Regions: TRegionMenuState);
    function RenameFileInHistory(const FileName, NewFileName: string): Boolean;
    procedure ToolbarCheck(const index: Integer; const Value: Boolean);
    procedure UpdateOpenedSheets;
    procedure ParseProjectFiles(ProjectBase: TProjectBase);
    procedure SetActiveCompilerPath(CompilerPath: string;
      NewInstalled: Integer);
    procedure SelectTheme(Theme: string);
    function GetActiveFile1(var ActiveFile: TSourceFile;
      OnNoneGetFirst: Boolean = True): Boolean;
    function GetActiveSource(var ActiveSource: TSourceBase;
      OnNoneGetFirst: Boolean = True): Boolean;
    procedure AddMessage(const FileName, Title, Msg: string;
      Line, Column, EndColumn: Integer; MsgType: TMessageItemType;
      AlignCenter: Boolean = True);
    function GetSourcesFiles(List: TStrings;
      IncludeRC: Boolean = False): Integer;
    function GetActiveSheet(var Sheet: TSourceFileSheet): Boolean;
    procedure GotoLineAndAlignCenter(Editor: TEditor; Line: Integer;
      Col: Integer = 1; EndCol: Integer = 1; CursorEnd: Boolean = False);
    procedure IncLoading;
    procedure DecLoading;
    property LastProjectBuild: TProjectBase read FLastProjectBuild
      write FLastProjectBuild;
    property LastSelectedProject: TProjectBase read FLastSelectedProject
      write FLastSelectedProject; // last selected project
    property RunNow: Boolean read FRunNow write FRunNow;
    property HandlingTabs: Boolean read FHandlingTabs write FHandlingTabs;
    property ConfigRoot: string read FConfigRoot;
    property IniConfigFile: string read FIniConfigFile;
    property CompilationStopped: Boolean read FCompilationStopped;
    property SintaxList: TSintaxList read FSintaxList;
    property Templates: TTemplates read FTemplates;
    property Config: TConfig read FConfig;
    property CompilerSettings: TCompilerSettings read FCompilerSettings;
    property IsLoading: Boolean read GetIsLoading;
    property AppRoot: string read FAppRoot;
    property AutoComplete: TAutoComplete read FAutoComplete;
    property SearchList: TStrings read FSearchList;
    property ReplaceList: TStrings read FReplaceList;
    property FilesParsed: TTokenFiles read FFilesParsed;
    property PluginManager: TPluginManager read FPluginManager;
    property ZoomEditor: Integer read FZoomEditor write FZoomEditor;
    //property ClangIndex: CXIndex read FClangIndex;
  end;

  { TParserThread }

  TParserThread = class(TThread)
  private
    fLastPercent: Integer;
    fScanEvent: TEvent;
    fLockEvent: TEvent;
    fSourceChanged: Boolean;
    fSource: string;
    fStartTime: Cardinal;
    fParseTime: Cardinal;
    fTokenFile: TTokenFile;
    fHasParsed: Boolean;
    fBusy: Boolean;
    fTokens: PToken;
    fCppParser: TCppParser;
    fChangeNumber: Integer;
    fTokenNumber: Integer;
    fLockTokens: TCriticalSection;
    function InternalLockTokens: PToken;
    procedure GetSource;
    procedure SetResults;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetModified; // actual files has modified
    procedure Shutdown;
    procedure DataChanged;
    function LockTokens(ID: Pointer): PToken;
    procedure UnLockTokens;
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
  UFrmGotoFunction, UFrmGotoLine, Makefile, CodeTemplate, StrUtils,
  UFrmVisualCppOptions, PluginConst, Math, Highlighter, DScintilla,
  PluginWidgetMap, AppConst, ExporterHTML, ExporterRTF, ExporterTeX,
  EditorPrint, Types;

{$R *.dfm}

var
  g_OrigEditProc: Pointer = nil;

function TreeViewEditSubclassProc(HWindow: HWND; message, WParam: Longint;
  LParam: Longint): Longint; stdcall;
begin
  case message of
    WM_CHAR:
      begin
        if CharInSet(Chr(WParam), ['<', '>', ':', '"', '/', '\', '|', '?', '*'])
        then
        begin
          Beep;
          Result := 0;
          Exit;
        end;
      end;
  end;
  Result := CallWindowProc(g_OrigEditProc, HWindow, message, WParam, LParam);
end;

procedure ProgressbarSetMarqueue(Progressbar: TProgressBar);
begin
  Progressbar.Position := 0;
  SetWindowLong(Progressbar.Handle, GWL_STYLE, GetWindowLong(Progressbar.Handle,
    GWL_STYLE) or PBS_MARQUEE);
  SendMessage(Progressbar.Handle, PBM_SETMARQUEE, 1, 0);
end;

procedure ProgressbarSetNormal(Progressbar: TProgressBar);
begin
  SetWindowLong(Progressbar.Handle, GWL_STYLE, GetWindowLong(Progressbar.Handle,
    GWL_STYLE) and not PBS_MARQUEE);
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
  if SameText(OldPath, Actpath) and
    (Pos(UpperCase(Actpath + '\bin'), UpperCase(path)) = 1) then
  begin
    Exit;
  end;
  UpdatePath := False;
  // remove old from path
  if (OldPath <> '') and (Pos(UpperCase(OldPath + '\bin'), UpperCase(path)) > 0)
  then
  begin
    path := RemoveFromPath(path, OldPath + '\bin');
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
  treeItem.hItem := treeNode.ItemId;
  treeItem.stateMask := TVIS_BOLD;
  treeItem.mask := TVIF_HANDLE or TVIF_STATE;
  if Value then
    treeItem.State := TVIS_BOLD
  else
    treeItem.State := 0;
  TreeView_SetItem(treeNode.Handle, treeItem);
end;

function SortCompareParams(List: TStringList; Index1, Index2: Integer): Integer;
var
  tkp1, tkp2: TTokenClass;
begin
  tkp1 := GetTokenByName(TTokenClass(List.Objects[Index1]), 'Params', tkParams);
  tkp2 := GetTokenByName(TTokenClass(List.Objects[Index2]), 'Params', tkParams);
  Result := tkp1.Count - tkp2.Count;
end;

{ TParserThread }

constructor TParserThread.Create;
begin
  inherited Create(True);
  fLockTokens := TCriticalSection.Create;
  fTokens := StartTokenizer('1');
  fTokenFile := TTokenFile.Create;
  fCppParser := TCppParser.Create;
  fScanEvent := TEvent.Create(nil, False, False, '');
  fLockEvent := TEvent.Create(nil, False, False, '');
end;

destructor TParserThread.Destroy;
begin
  Shutdown;
  fLockEvent.Free;
  fScanEvent.Free;
  fCppParser.Free;
  fTokenFile.Free;
  FreeTokens(fTokens);
  fLockTokens.Free;
  inherited Destroy;
end;

procedure TParserThread.Execute;
var
  CurrentNumber: Integer;
begin
  while not Terminated do
  begin
    fBusy := False;
    fScanEvent.WaitFor(INFINITE);
    fHasParsed := False;
    fBusy := True;
    repeat
      if Terminated then
        Break;
      // make sure the event is reset when we are still in the repeat loop
      fScanEvent.ResetEvent;
      // get the modified source and set fSourceChanged to 0
      Synchronize(GetSource);
      if Terminated then
        Break;
      // clear keyword list
      fLastPercent := 0;
      fStartTime := GetTickCount;
      FreeTokens(InternalLockTokens);
      CurrentNumber := fChangeNumber;
      fTokens := fCppParser.Tokenizer(fSource, TokenFile);
      fTokenNumber := CurrentNumber;
      fLockEvent.SetEvent;
      UnLockTokens;
      fHasParsed := fCppParser.Parse(fTokens);
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

    // fKeywords.Sort;
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
  Sheet: TSourceFileSheet;
begin
  if Assigned(FrmFalconMain) then
  begin
    if FrmFalconMain.GetActiveSheet(Sheet) then
    begin
      fTokenFile.Data := Sheet.SourceFile;
      fSource := Sheet.Editor.Lines.Text;
    end
    else
    begin
      fTokenFile.Data := nil;
      fSource := '';
    end;
  end
  else
    fSource := '';
  fSourceChanged := False;
end;

function TParserThread.InternalLockTokens: PToken;
begin
  fLockTokens.Enter;
  Result := fTokens;
end;

function TParserThread.LockTokens(ID: Pointer): PToken;
var
  I: Integer;
begin
  Result := nil;
  Exit;
  if (fChangeNumber = fTokenNumber) and (ID = fTokenFile.Data) then
  begin
    Result := InternalLockTokens;
    Exit;
  end;
  FrmFalconMain.TimerChangeDelay.Enabled := False;
  fLockEvent.ResetEvent;
  if not Busy then
    SetModified;
  for I := 0 to 30 do
  begin
    Application.ProcessMessages;
    if fLockEvent.WaitFor(100) = wrSignaled then
    begin
      Result := InternalLockTokens;
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TParserThread.DataChanged;
begin
  fChangeNumber := (fChangeNumber + 1) mod 1000000;
end;

procedure TParserThread.SetModified;
begin
  fCppParser.Cancel;
  fSourceChanged := True;
  fScanEvent.SetEvent;
end;

procedure TParserThread.SetResults;
var
  Sheet: TSourceFileSheet;
  SourceFile: TSourceFile;
begin
  if not Assigned(FrmFalconMain) then
    Exit;
  with FrmFalconMain do
  begin
    if not GetActiveSheet(Sheet) then
    begin
      if not DebugReader.Running then
        TreeViewOutline.Clear;
      Exit;
    end;

    fTokenFile.AssignProperty(ActiveEditingFile);
    UpdateActiveFileToken(fTokenFile, True);
    SourceFile := TSourceFile(ActiveEditingFile.Data);
    TextEditorFileParsed(SourceFile, ActiveEditingFile);
    if HintParams.Activated then
      ShowHintParams(Sheet.Editor);
    if (fShowCodeCompletion > 0) and not CodeCompletion.Executing then
      CodeCompletion.ActivateCompletion(Sheet.Editor);
  end;
end;

procedure TParserThread.Shutdown;
begin
  fCppParser.Cancel;
  Terminate;
  fScanEvent.SetEvent;
  WaitFor;
end;

procedure TParserThread.UnLockTokens;
begin
  fLockTokens.Leave;
end;

{ TFrmFalconMain }

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
  SourceFile: TSourceFile;
  ProjectBase: TProjectBase;
begin
  IncLoading;
  CppHighligher := TCppHighlighter.Create(Self);
  TreeViewOutline.NodeDataSize := SizeOf(Pointer);
  SearchEngine := TSearchEngine.Create(Self);
  CodeCompletion := TCompletionProposal.Create(Self);
  CodeCompletion.Options := [scoLimitToMatchedText, scoUseInsertList,
    scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion,
    scoCompleteWithTab, scoCompleteWithEnter];
  CodeCompletion.ClSelectedText := clWindowText;
  CodeCompletion.ClTitleBackground := clBtnHighlight;
  CodeCompletion.Width := 450;
  CodeCompletion.EndOfTokenChr := '().:';
  CodeCompletion.TriggerChars := '.>:';
  CodeCompletion.Font.Color := clWindowText;
  CodeCompletion.Font.Height := -12;
  CodeCompletion.Font.name := 'Segoe UI';
  CodeCompletion.Font.Style := [];
  CodeCompletion.TitleFont.Color := clBtnText;
  CodeCompletion.TitleFont.Height := -11;
  CodeCompletion.TitleFont.name := 'MS Sans Serif';
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
  FCompilerSettings := TCompilerSettings.Create;
  FConfig := TConfig.Create;
  FAppRoot := ExtractFilePath(Application.ExeName);
  if IsPortable then
    FConfigRoot := FAppRoot + 'Config\'
  else
    FConfigRoot := GetSpecialFolderPath(CSIDL_APPDATA) + 'Falcon\';
  // create config root directory
  if not DirectoryExists(ConfigRoot) then
    CreateDir(ConfigRoot);
  FIniConfigFile := ConfigRoot + CONFIG_NAME;
  Config.Load(IniConfigFile, Self);
  if Config.Environment.AlternativeConfFile and
    FileExists(Config.Environment.ConfigurationFile) then
    FIniConfigFile := Config.Environment.ConfigurationFile;
  if Config.Environment.ShowSplashScreen then
    SplashScreen.Show;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[45]);
  //FClangIndex := clang_createIndex(1, 0);
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
  HintTip := TTokenHintTip.Create(Self); // mouse over hint
  HintTip.Images := ImgListOutLine;
  HintParams := TTokenHintParams.Create(Self); // Ctrl + Space or ( Trigger Key
  DebugParser := TDebugParser.Create; // fill treeview with debug variables
  DebugParser.TreeView := TreeViewOutline;
  DebugHint := THintTree.Create(Self); // hint with a treeview
  DebugHint.ImageList := ImageListDebug;
  FAutoComplete := TAutoComplete.Create(Self); // Ctrl+J
  // Load default auto complete
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
  TreeView_SetExtendedStyle(TreeViewProjects.Handle, TVS_EX_FADEINOUTEXPANDOS, TVS_EX_FADEINOUTEXPANDOS);
  // init outline image list
  for I := 0 to MAX_OUTLINE_TREE_IMAGES - 1 do
  begin
    OutlineImages[I] := TreeImages[I];
  end;
  ViewZoomInc.ShortCut := ShortCut(VK_ADD, [ssCtrl]); // Ctrl + +
  ViewZoomDec.ShortCut := ShortCut(VK_SUBTRACT, [ssCtrl]); // Ctrl + -
  BtnPrevPage.ShortCut := ShortCut(VK_TAB, [ssCtrl, ssShift]);
  // Ctrl + Shift + Tab
  BtnNextPage.ShortCut := ShortCut(VK_TAB, [ssCtrl]); // Ctrl + Tab
  SearchGotoPrevFunc.ShortCut := ShortCut(VK_UP, [ssCtrl, ssAlt]);
  // Ctrl + Alt + UP
  SearchGotoNextFunc.ShortCut := ShortCut(VK_DOWN, [ssCtrl, ssAlt]);
  // Ctrl + Alt + DOWN
  FalconVersion := GetFileVersionA(Application.ExeName);
  ActDropDownBtn := True;
  XMLOpened := False;
  FSintaxList := TSintaxList.Create;
  SintaxList.Highlight := CppHighligher;
  // create projects directory
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
    AutoCompleteList.Add
      ('[sample | comment here, "|" is mouse cursor position]');
    AutoCompleteList.Append('int v[|];'#13#10);
    try
      AutoCompleteList.SaveToFile(Config.Editor.CodeTemplateFile);
    except
    end;
    AutoCompleteList.Free;
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
      SplashScreen.TextOut(55, 250, Format(STR_FRM_MAIN[24], [Temp]), False);
    end;
  end;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[33], False);
  ini := TIniFile.Create(IniConfigFile);
  HistList := TStringList.Create;
  ini.ReadSection('History', HistList);
  for I := HistList.Count - 1 downto 0 do
    AddFileToHistory(ini.ReadString('History', HistList.Strings[I], ''));
  HistList.Free;
  // load search options
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
  // load view menu check
  ViewProjMan.Checked := ini.ReadBool('View', 'ProjMan', True);
  ViewItemClick(ViewProjMan);
  ViewStatusBar.Checked := ini.ReadBool('View', 'StatusBar', True);
  ViewItemClick(ViewStatusBar);
  ViewOutline.Checked := ini.ReadBool('View', 'Outline', True);
  ViewItemClick(ViewOutline);
  NewInstalled := ini.ReadInteger('Packages', 'NewInstalled', -1);
  // load user sintax
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
  // load templates
  for I := 0 to List.Count - 1 do
  begin
    Template := TTemplate.Create;
    if Template.Load(Config.Environment.TemplatesDir + List.Strings[I],
      HelpFalcon) then
      Templates.Insert(Template)
    else
      Template.Free;
  end;
  List.Free;
  if ParamCount > 0 then
    SplashScreen.TextOut(55, 300, STR_FRM_MAIN[27]);
  // load projects
  for I := 1 to ParamCount do
    OpenFileWithHistoric(ParamStr(I), ProjectBase);
  List := TStringList.Create;
  ini := TIniFile.Create(IniConfigFile);
  ini.ReadSection('LastSection', List);
  for I := 0 to List.Count - 1 do
  begin
    Temp := ini.ReadString('LastSection', List.Strings[I], '');
    if FileExists(Temp) then
    begin
      if not SearchSourceFile(Temp, SourceFile) then
        SourceFile := TSourceFile(OpenFile(Temp));
      if SourceFile.FileType <> FILE_TYPE_PROJECT then
      begin
        SourceFile.Edit;
        SourceFile.Node.Selected := True;
      end;
    end;
  end;
  ini.Free;
  List.Free;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[28]);
  CreateStdTools;

  // detect compiler
  List := TStringList.Create;
  SearchCompilers(List, path);
  if (Config.Compiler.path = '') or
    not FileExists(Config.Compiler.path + '\bin\gcc.exe') then
  begin
    path := '';
    Config.Compiler.Version := '';
  end
  else
  begin
    Temp := path;
    path := Config.Compiler.path;
    Config.Compiler.path := Temp;
  end;
  if not DirectoryExists(path) and (List.Count = 0) then
  begin
    InternalMessageBox(PChar(STR_FRM_MAIN[46]), 'Falcon C++',
      MB_ICONEXCLAMATION);
  end
  else
  begin
    if not DirectoryExists(Config.Compiler.path) then
      path := List.Strings[0];
    SetActiveCompilerPath(path, NewInstalled);
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
  DecLoading;
  // update grayed project and outline
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

// on close application

procedure TFrmFalconMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ProjProp: TProjectBase;
  I, R, J: Integer;
  ini: TIniFile;
  Node: TTreeNode;
  List: TStrings;
begin
  List := TStringList.Create;
  Node := TreeViewProjects.Items.GetFirstNode;
  while Node <> nil do
  begin
    ProjProp := TProjectBase(Node.Data);
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
          end; // mrYes
        mrCancel:
          begin
            Action := caNone;
            List.Free;
            Exit;
          end; // mrCancel
      end; // case
    end; // modified or not salved
    if Config.Environment.CreateLayoutFiles and ProjProp.Saved and (ProjProp is TProjectFile) then
      TProjectFile(ProjProp).SaveLayout;
    Node := Node.getNextSibling;
  end;
  try
    // close when parsing
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
      ini.WriteString('SearchHistory', 'Item' + IntToStr(I + 1),
        FSearchList.Strings[I]);
    end;
    for I := 0 to FReplaceList.Count - 1 do
    begin
      if I = 10 then
        Break;
      ini.WriteString('ReplaceHistory', 'Item' + IntToStr(I + 1),
        FReplaceList.Strings[I]);
    end;
    // save view menu check
    ini.WriteBool('View', 'ProjMan', ViewProjMan.Checked);
    ini.WriteBool('View', 'StatusBar', ViewStatusBar.Checked);
    ini.WriteBool('View', 'CompOut', ViewCompOut.Checked);
    ini.WriteBool('View', 'Outline', ViewOutline.Checked);
    // sintax
    ini.EraseSection('HighlighterList');
    for I := 0 to SintaxList.Count - 1 do
    begin
      if SintaxList.Items[I].readonly then
        continue;
      ini.WriteString('HighlighterList', SintaxList.Items[I].name,
        SintaxList.Items[I].GetSintaxString);
    end;
    // save section
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
              if TProjectBase(List.Objects[I]).FileType = FILE_TYPE_PROJECT then
              begin
                ini.WriteString('LastSection', 'File' + IntToStr(J),
                  List.Strings[I]);
                if Config.Environment.AutoOpen = 3 then
                  Break;
              end;
            end;
          1:
            begin
              Inc(J);
              ini.WriteString('LastSection', 'File' + IntToStr(J),
                List.Strings[I]);
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
  S, OldPath, MinGWDir: string;
  SleepAtEnd: Boolean;
begin
  OldPath := Config.Compiler.path;
  Config.Compiler.path := CompilerPath;
  SetActiveCompiler(OldPath, Config.Compiler.path, SplashScreen);
  if ((Config.Compiler.name = '') or (Config.Compiler.Version = '') or
    (NewInstalled <> 0)) then
  begin
    if ExecutorGetStdOut.ExecWait(Config.Compiler.path + '\bin\gcc.exe',
      '--version', Config.Compiler.path + '\bin\', S) = 0 then
      GetNameAndVersion(S, Config.Compiler.name, Config.Compiler.Version)
    else
      Config.Compiler.Version := '';
  end;
  FilesParsed.PathList.Clear;
  FilesParsed.PathList.Add(Config.Compiler.path + '\include\');
  MinGWDir := 'mingw32';
  // 64 bits
  if Pos('64', Config.Compiler.name) > 0 then
  begin
    MinGWDir := 'x86_64-w64-mingw32';
    FilesParsed.PathList.Add(Config.Compiler.path + '\' + MinGWDir +
      '\include\');
  end;
  if Config.Compiler.Version <> '' then
  begin
    FilesParsed.PathList.Add(Config.Compiler.path + '\lib\gcc\' + MinGWDir + '\'
      + Config.Compiler.Version + '\include\c++\');
    FilesParsed.PathList.Add(Config.Compiler.path + '\lib\gcc\' + MinGWDir + '\'
      + Config.Compiler.Version + '\include\');
  end;
  IsLoadingSrcFiles := False;
  SleepAtEnd := SplashScreen.Showing and (NewInstalled <> 0);
  if NewInstalled < 0 then
    SplashScreen.TextOut(55, 300, Format(STR_FRM_MAIN[36], [0]))
  else if NewInstalled > 0 then
    SplashScreen.TextOut(55, 300, Format(STR_FRM_MAIN[37], [0]));
  ThreadTokenFiles.Clear;
  ReloadIncludeList(NewInstalled <> 0);
  if SleepAtEnd then
    Sleep(3000);
end;

procedure TFrmFalconMain.ReloadIncludeList(ParseFiles: Boolean);
var
  S, SourcePath, RelativePath, Filter, CompilerPath: string;
  SourceFileList: TStrings;
  I, J: Integer;
begin
  CompilerPath := IncludeTrailingPathDelimiter(Config.Compiler.path);
  // parse and load C/C++ header files
  for I := 0 to FilesParsed.PathList.Count - 1 do
  begin
    SourceFileList := TStringList.Create;
    SourcePath := FilesParsed.PathList[I];
    RelativePath := ExtractRelativePath(CompilerPath, SourcePath);
    Filter := '*.h';
    if Pos('C++', UpperCase(RelativePath)) > 0 then
      Filter := '*.*';
    if FindFiles(SourcePath, Filter, SourceFileList) then
    begin
      IsLoadingSrcFiles := True;
      if ParseFiles then
      begin
        ThreadTokenFiles.Start(SourceFileList, SourcePath,
          ConfigRoot + RelativePath, '.prs');
      end;
    end;
    FilesParsed.PathList.Objects[I] := SourceFileList;
  end;
  // clear previows include list
  for I := 0 to FIncludeFileList.Count - 1 do
  begin
    if FIncludeFileList.Objects[I] <> nil then
      FIncludeFileList.Objects[I].Free;
  end;
  FIncludeFileList.Clear;
  // add new files
  for I := 0 to FilesParsed.PathList.Count - 1 do
  begin
    SourceFileList := TStrings(FilesParsed.PathList.Objects[I]);
    for J := 0 to SourceFileList.Count - 1 do
    begin
      S := ConvertToUnixSlashes(ExtractRelativePath(FilesParsed.PathList[I],
        SourceFileList.Strings[J]));
      FIncludeFileList.AddObject(S, SourceFileList.Objects[J]);
    end;
    SourceFileList.Free;
  end;
end;

procedure TFrmFalconMain.UpdateMenuItems(Regions: TRegionMenuState);
var
  SelectedFile: TSourceBase;
  CurrentFile: TSourceBase;
  CurrentProject: TProjectBase;
  CurrentSheet: TSourceFileSheet;
  Flag: Boolean;
begin
  CurrentFile := nil;
  GetActiveSource(CurrentFile, False);
  CurrentProject := nil;
  GetActiveProject(CurrentProject);
  SelectedFile := nil;
  GetSelectedFileInList(SelectedFile);
  CurrentSheet := nil;
  GetActiveSheet(CurrentSheet);
  if rmFile in Regions then
  begin
    // FileOpen.Enabled := True;
    // BtnOpen.Enabled := True;
    Flag := Assigned(CurrentFile) and
      (not CurrentFile.Saved or CurrentFile.Modified or CurrentFile.IsNew);
    FileSave.Enabled := Flag;
    BtnSave.Enabled := Flag;
    PopTabsSave.Enabled := Flag;
    Flag := (Assigned(CurrentFile) and (CurrentFile is TProjectBase));
    FileSaveAs.Enabled := Flag;
    Flag := TreeViewProjects.Items.Count > 0;
    FileSaveAll.Enabled := Flag;
    BtnSaveAll.Enabled := Flag;
    PopTabsSaveAll.Enabled := Flag;
    Flag := Assigned(CurrentFile) and
      not(CurrentFile.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT, FILE_TYPE_CONFIG, FILE_TYPE_CONFIG_GROUP]);
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
    Flag := Assigned(CurrentFile) and
      not(CurrentFile.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT, FILE_TYPE_CONFIG, FILE_TYPE_CONFIG_GROUP]);
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
    Flag := Assigned(CurrentFile) and (CurrentFile.Project is TProjectFile);
    FileNewFolder.Enabled := Flag;
    Flag := Assigned(CurrentFile);
    FileNewConfig.Enabled := Flag;
  end;
  if rmEdit in Regions then
  begin
    Flag := Assigned(CurrentSheet) and CurrentSheet.Editor.CanUndo and
      CurrentSheet.Editor.Focused;
    EditUndo.Enabled := Flag;
    PopEditorUndo.Enabled := Flag;
    BtnUndo.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Editor.CanRedo and
      CurrentSheet.Editor.Focused;
    EditRedo.Enabled := Flag;
    PopEditorRedo.Enabled := Flag;
    BtnRedo.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Editor.SelAvail and
      CurrentSheet.Editor.Focused;
    EditCut.Enabled := Flag;
    PopEditorCut.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Editor.SelAvail and
      CurrentSheet.Editor.Focused;
    EditCopy.Enabled := Flag;
    PopEditorCopy.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Editor.CanPaste and
      CurrentSheet.Editor.Focused;
    EditPaste.Enabled := Flag;
    PopEditorPaste.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    EditSwap.Enabled := Flag;
    PopEditorSwap.Enabled := Flag;
    PopTabsSwap.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and
      (CurrentSheet.Editor.SelAvail or
      ((CurrentSheet.Editor.CaretY <= CurrentSheet.Editor.Lines.Count) and
      ((CurrentSheet.Editor.CaretY < CurrentSheet.Editor.Lines.Count) or
      (CurrentSheet.Editor.CaretX < Length(CurrentSheet.Editor.Lines
      [CurrentSheet.Editor.CaretY - 1]))))) and CurrentSheet.Editor.Focused;
    EditDelete.Enabled := Flag;
    PopEditorDelete.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and
      (not((CurrentSheet.Editor.SelAvail and
      ((CurrentSheet.Editor.BlockBegin.Char = 1) and
      (CurrentSheet.Editor.BlockBegin.Line = 1)) and
      (CurrentSheet.Editor.Lines.Count > 0) and
      ((CurrentSheet.Editor.BlockEnd.Char = Length(CurrentSheet.Editor.Lines
      [CurrentSheet.Editor.Lines.Count - 1]) + 1) and
      (CurrentSheet.Editor.BlockEnd.Line = CurrentSheet.Editor.Lines.Count))) or
      (CurrentSheet.Editor.Lines.Count = 0) or
      ((CurrentSheet.Editor.Lines.Count = 1) and
      (Length(CurrentSheet.Editor.Lines[0]) = 0)))) and
      CurrentSheet.Editor.Focused;
    EditSelectAll.Enabled := Flag;
    PopEditorSelectAll.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 0);
    EditBookmarks.Enabled := Flag;
    PopEditorBookmarks.Enabled := Flag;
    BtnToggleBook.Enabled := Flag;
    EditGotoBookmarks.Enabled := Flag;
    PopEditorGotoBookmarks.Enabled := Flag;
    BtnGotoBook.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and CurrentSheet.Editor.SelAvail and
      CurrentSheet.Editor.Focused;
    EditIndent.Enabled := Flag;
    EditUnindent.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 0) and
      CurrentSheet.Editor.Focused;
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
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 10);
    SearchGotoLine.Enabled := Flag;
    BtnGotoLN.Enabled := Flag;
  end;
  if rmProject in Regions then
  begin
    Flag := Assigned(CurrentProject) and
      (CurrentProject.FileType = FILE_TYPE_PROJECT);
    ProjectAdd.Enabled := Flag;
    PopProjAdd.Enabled := Flag;
    Flag := Assigned(CurrentProject) and
      (CurrentProject.FileType = FILE_TYPE_PROJECT) and
      (CurrentProject.Node.Count > 0);
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
    Flag := Assigned(CurrentProject) and
      ((not CompilerCmd.Executing and not Executor.Running) or
      DebugReader.Running);
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
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 0);
    RunToggleBreakpoint.Enabled := Flag;
    Flag := Assigned(CurrentProject) and DebugReader.Running;
    RunStepInto.Enabled := Flag;
    BtnStepInto.Enabled := Flag;
    RunStepOver.Enabled := Flag;
    BtnStepOver.Enabled := Flag;
    RunStepReturn.Enabled := Flag;
    BtnStepReturn.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 0);
    RunRuntoCursor.Enabled := Flag;
    Flag := Assigned(CurrentProject) and
      (Executor.Running or DebugReader.Running or CompilerCmd.Executing);
    RunStop.Enabled := Flag;
    BtnStop.Enabled := Flag;
  end;
  if rmProjectsPopup in Regions then
  begin
    Flag := Assigned(SelectedFile) and
      not(SelectedFile.FileType in [FILE_TYPE_PROJECT, FILE_TYPE_FOLDER, FILE_TYPE_CONFIG, FILE_TYPE_CONFIG_GROUP]);
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
      CurrentSheet.SourceFile.readonly;
    // others
    Flag := (PageControlEditor.PageCount > 1);
    BtnPrevPage.Enabled := Flag;
    BtnNextPage.Enabled := Flag;
  end;
  if rmEditorPopup in Regions then
  begin
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 0);
    PopEditorOpenDecl.Enabled := Flag;
    Flag := Assigned(CurrentSheet) and (CurrentSheet.Editor.Lines.Count > 0);
    PopEditorCompClass.Enabled := Flag;
    Flag := Assigned(CurrentSheet);
    PopEditorTools.Enabled := Flag;
    BarItemEncoding.Visible := Flag;
    BarItemLineEnding.Visible := Flag;
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
  // clear help menus
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
  // load templates
  for I := 0 to List.Count - 1 do
  begin
    Template := TTemplate.Create;
    if Template.Load(Config.Environment.TemplatesDir + List.Strings[I],
      HelpFalcon) then
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
begin
  ReloadIncludeList(True);
end;

function TFrmFalconMain.FillTreeView(Parent: PVirtualNode; token: TTokenClass;
  DeleteNext: Boolean): PVirtualNode;
var
  I: Integer;
  S: string;
  NodeObject: TNodeObject;
  Node: PVirtualNode;
begin
  Result := nil;
  for I := 0 to token.Count - 1 do
  begin
    Node := Parent;
    if not(token.Items[I].token in [tkParams, tkScope, tkScopeClass, tkUsing,
      tkFriend]) then
    begin
      if token.Items[I].token in [tkFunction, tkProtoType, tkConstructor,
        tkDestructor, tkOperator] then
      begin
        if token.Items[I].token in [tkConstructor, tkDestructor] then
        begin
          S := GetFuncScope(token.Items[I]) + token.Items[I].name +
            GetFuncProtoTypes(token.Items[I]);
        end
        else
        begin
          S := token.Items[I].name + GetFuncProtoTypes(token.Items[I]) + ' : ' +
            token.Items[I].Flag;
          if token.Items[I].token = tkOperator then
            S := 'operator' + S;
        end;
      end
      else
        S := token.Items[I].name;
      NodeObject := TNodeObject.Create;
      NodeObject.Data := token.Items[I];
      NodeObject.Caption := S;
      Node := TreeViewOutline.AddChild(Parent, NodeObject);
      token.Items[I].Data := Node;
      NodeObject.ImageIndex := GetTokenImageIndex(token.Items[I],
        OutlineImages);
    end;

    if not(token.Items[I].token in [tkParams, tkScope, tkFunction,
      tkConstructor, tkDestructor, tkProtoType, tkOperator]) then
    begin
      FillTreeView(Node, token.Items[I], True);
    end;
  end;
end;

procedure TFrmFalconMain.UpdateCompletionColors(EdtOpt: TEditorOptions);
begin
  CompletionColors[tkClass] := Format(CompletionNames[0],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkFunction] := Format(CompletionNames[1],
    [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[tkProtoType] := Format(CompletionNames[2],
    [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[tkOperator] := Format(CompletionNames[2],
    [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[tkConstructor] := Format(CompletionNames[3],
    [ColorToString(EdtOpt.CompListConstructor)]);
  CompletionColors[tkDestructor] := Format(CompletionNames[4],
    [ColorToString(EdtOpt.CompListDestructor)]);
  CompletionColors[tkInclude] := Format(CompletionNames[5],
    [ColorToString(EdtOpt.CompListPreproc { CompListInclude } )]);
  CompletionColors[tkDefine] := Format(CompletionNames[6],
    [ColorToString(EdtOpt.CompListPreproc)]);
  CompletionColors[tkVariable] := Format(CompletionNames[7],
    [ColorToString(EdtOpt.CompListVar)]);
  CompletionColors[tkTypedef] := Format(CompletionNames[8],
    [ColorToString(EdtOpt.CompListTypedef)]);
  CompletionColors[tkTypedefProto] := Format(CompletionNames[9],
    [ColorToString(EdtOpt.CompListTypedef)]);
  CompletionColors[tkStruct] := Format(CompletionNames[10],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkTypeStruct] := Format(CompletionNames[11],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkEnum] := Format(CompletionNames[12],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkTypeEnum] := Format(CompletionNames[13],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkUnion] := Format(CompletionNames[14],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkTypeUnion] := Format(CompletionNames[15],
    [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[tkNamespace] := Format(CompletionNames[16],
    [ColorToString(EdtOpt.CompListNamespace)]);
  CompletionColors[tkEnumItem] := Format(CompletionNames[17],
    [ColorToString(EdtOpt.CompListConstant)]);
  CompletionColors[tkCodeTemplate] := Format(CompletionNames[18],
    [ColorToString(EdtOpt.CompListType)]);
end;

// get source file to parse
procedure TFrmFalconMain.ParseFile(FileName: string; SourceFile: TSourceFile);
var
  ObjList: TStrings;
  FileObj: TFileObject;
  Sheet: TSourceFileSheet;
begin
  SourceFile.TranslateUnit;
  ObjList := TStringList.Create;
  FileObj := TFileObject.Create;
  FileObj.ID := SourceFile;
  if (FileName = '-') and (SourceFile <> nil) and SourceFile.GetSheet(Sheet)
  then
  begin
    FileObj.FileName := SourceFile.FileName;
    FileObj.Text := Sheet.Editor.Lines.Text;
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
  Sheet: TSourceFileSheet;
begin
  if List.Count = 0 then
    Exit;
  ObjList := TStringList.Create;
  // parse source files
  for I := 0 to List.Count - 1 do
  begin
    prop := TSourceFile(List.Objects[I]);
    if (prop <> nil) and (prop.FileType = FILE_TYPE_RC) then
      continue;
    prop.TranslateUnit;
    FileObj := TFileObject.Create;
    FileObj.ID := prop;
    if (prop <> nil) and prop.GetSheet(Sheet) then
    begin
      FileObj.FileName := prop.FileName;
      FileObj.Text := Sheet.Editor.Lines.Text;
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

// get source file to parse

procedure TFrmFalconMain.ParseProjectFiles(ProjectBase: TProjectBase);
var
  List: TStrings;
begin
  // parse project source files
  List := TStringList.Create;
  ProjectBase.GetSources(List, SOURCE_TYPES);
  ParseFiles(List);
  List.Free;
end;

procedure TFrmFalconMain.BtnHelpClick(Sender: TObject);
var
  form: TForm;
  Editor: TMemo;
  I: Integer;
  List: TStrings;
begin
  form := TForm.Create(Self);
  form.Width := 400;
  form.Height := 450;
  Editor := TMemo.Create(form);
  Editor.Parent := form;
  Editor.Align := alClient;
  Editor.ScrollBars := ssBoth;
  List := TStringList.Create;
  FilesParsed.GetAllFiles(List);
  for I := 0 to List.Count - 1 do
  begin
    Editor.Lines.Add(TTokenFile(List.Objects[I]).FileName);
  end;
  List.Free;
  form.Position := poOwnerFormCenter;
  form.Caption := IntToStr(FilesParsed.Count) + ' Files';
  form.ShowModal;
end;

// get source file to parse

function TFrmFalconMain.GetSourcesFiles(List: TStrings;
  IncludeRC: Boolean): Integer;
var
  I: Integer;
  prop: TSourceBase;
begin
  Result := 0;
  for I := 0 to TreeViewProjects.Items.Count - 1 do
  begin
    prop := TSourceBase(TreeViewProjects.Items.Item[I].Data);
    if not (prop.FileType in SOURCE_TYPES + [FILE_TYPE_UNKNOW]) then
      Continue;
    Inc(Result);
    List.AddObject(prop.FileName, prop);
  end;
  //
end;

// update user configuration editor

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
    SynMemo := TSourceFileSheet(PageControlEditor.Pages[I]).Editor;
    TSourceFileSheet.UpdateEditor(SynMemo);
  end;
end;

// update editor zoom

procedure TFrmFalconMain.UpdateEditorZoom;
var
  I: Integer;
  SynMemo: TEditor;
begin
  for I := 0 to PageControlEditor.PageCount - 1 do
  begin
    if SHEET_TYPE_FILE = TPropertySheet(PageControlEditor.Pages[I]).SheetType
    then
    begin
      SynMemo := TSourceFileSheet(PageControlEditor.Pages[I]).Editor;
      SynMemo.Zoom := ZoomEditor;
    end;
  end;
end;

// get selected file in project list

function TFrmFalconMain.GetSelectedFileInList(var ActiveFile
  : TSourceBase): Boolean;
begin
  Result := False;
  if (TreeViewProjects.SelectionCount = 0) then
    Exit;
  ActiveFile := TSourceBase(TreeViewProjects.Selected.Data);
  Result := True;
end;


// get active file in treeview or active Sheet
function TFrmFalconMain.GetActiveFile1(var ActiveFile: TSourceFile;
  OnNoneGetFirst: Boolean): Boolean;
var
  ActiveSource: TSourceBase;
begin
  Result := GetActiveSource(ActiveSource, OnNoneGetFirst) and (ActiveSource is TSourceFile);
  if Result then
    ActiveFile := TSourceFile(ActiveSource);
end;

// get active file in treeview or active Sheet
function TFrmFalconMain.GetActiveSource(var ActiveSource: TSourceBase;
  OnNoneGetFirst: Boolean): Boolean;
var
  Sheet: TSourceFileSheet;
  Node: TTreeNode;
begin
  Result := False;
  if (TreeViewProjects.SelectionCount > 0) and (TreeViewProjects.Selected <> nil)
  then
  begin
    if TreeViewProjects.Focused or ((PageControlEditor.ActivePageIndex >= 0) and
      not TSourceFileSheet(PageControlEditor.ActivePage).Editor.Focused) then
    begin
      ActiveSource := TSourceBase(TreeViewProjects.Selected.Data);
    end
    else
    begin
      if (PageControlEditor.ActivePageIndex >= 0) then
      begin
        Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
        ActiveSource := Sheet.SourceFile;
      end
      else
        ActiveSource := TSourceBase(TreeViewProjects.Selected.Data);
    end;
  end
  else if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    ActiveSource := Sheet.SourceFile;
  end
  else if OnNoneGetFirst then
  begin
    Node := TreeViewProjects.Items.GetFirstNode;
    if Node = nil then
      Exit;
    if Node.getNextSibling <> nil then
      Exit;
    ActiveSource := TSourceBase(Node.Data);
  end
  else
    Exit;
  Result := True;
end;

// get active project

function TFrmFalconMain.GetActiveProject(var Project: TProjectBase): Boolean;
var
  ActFile: TSourceBase;
begin
  Result := False;
  if not GetActiveSource(ActFile) then
    Exit;
  if (TObject(ActFile) is TProjectBase) then
    Project := TProjectBase(ActFile)
  else
    Project := ActFile.Project;
  Result := True;
end;

// get active Sheet

function TFrmFalconMain.GetActiveSheet(var Sheet: TSourceFileSheet): Boolean;
begin
  Result := PageControlEditor.ActivePageIndex >= 0;
  if not Result then
    Exit;
  Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
end;

// show about window

procedure TFrmFalconMain.About1Click(Sender: TObject);
begin
  if not Assigned(FormAbout) then
  begin
    FormAbout := TFormAbout.Create(Self);
    FormAbout.LoadTranslators(Config.Environment.Langs);
  end;
  FormAbout.Show;
end;

// show properties window of project

procedure TFrmFalconMain.ProjectPropertiesClick(Sender: TObject);
var
  ProjProp: TProjectBase;
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

// open files

procedure TFrmFalconMain.FileOpenClick(Sender: TObject);
begin
  PageControlEditor.CancelDragging;
  if OpenDlg.Execute(Handle) then
  begin
    IncLoading;
    LastOpenFileName := OpenDlg.Files.Strings[OpenDlg.Files.Count - 1];
    OnDragDropFiles(Sender, OpenDlg.Files);
    DecLoading;
    // parser files
  end;
end;

// on click menu help execute filehelp

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

// on change file selection

procedure TFrmFalconMain.TreeViewProjectsChange(Sender: TObject;
  Node: TTreeNode);
var
  FilePrp: TSourceBase;
  Sibling: TTreeNode;
begin
  UpdateMenuItems([rmFile, rmFileNew, rmSearch, rmProject, rmRun,
    rmProjectsPopup]);
  if (TreeViewProjects.Items.Count = 0) then
  begin
    UpdateStatusbar;
    BarItemLineStatus.Visible := False;
    BarItemBuildStatus.Visible := False;
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
    FilePrp := TSourceBase(Node.Data);
  if (FilePrp <> nil) or GetActiveSource(FilePrp) then
    BoldTreeNode(FilePrp.Project.Node, True);
  UpdateStatusbar;
  if FilePrp = nil then
    Exit;
  if (FilePrp is TSourceFile) and TSourceFile(FilePrp).Editing then
    TSourceFile(FilePrp).ViewPage;
end;

// edit selected file in list of projects

procedure TFrmFalconMain.EditFileClick(Sender: TObject);
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if TSourceBase(TreeViewProjects.Selected.Data) is TSourceFile then
      TSourceFile(TreeViewProjects.Selected.Data).Edit;
  end;
end;

// delete selected text in editor or next char

procedure TFrmFalconMain.FileRemoveClick(Sender: TObject);
var
  ControlHand: HWND;
  Node: TTreeNode;
begin
  if TreeViewProjects.SelectionCount = 0 then
    Exit;
  if not TreeViewProjects.IsEditing then
  begin
    Node := TreeViewProjects.Selected;
    RemoveFile(Handle, TSourceBase(Node.Data));
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

// undo change of editor

procedure TFrmFalconMain.EditUndoClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if Sheet.Editor.Focused then
      Sheet.Editor.Undo;
  end;
end;

// redo change of code editor

procedure TFrmFalconMain.EditRedoClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if Sheet.Editor.Focused then
      Sheet.Editor.Redo;
  end;
end;

// cut selected text of editor

procedure TFrmFalconMain.EditCutClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Editor.Focused) then
      Sheet.Editor.CutToClipboard;
  end;
end;

// copy selected text of code editor

procedure TFrmFalconMain.EditCopyClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Editor.Focused) then
      Sheet.Editor.CopyToClipboard;
  end;
end;

// paste copied text on editor

procedure TFrmFalconMain.EditPasteClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Editor.Focused) then
      Sheet.Editor.PasteFromClipboard;
    Sheet.Editor.Invalidate;
  end;
end;

// double click in an file of list

procedure TFrmFalconMain.TreeViewProjectsDblClick(Sender: TObject);
var
  Node: TTreeNode;
  MPos: TPoint;
begin
  GetCursorPos(MPos);
  MPos := TreeViewProjects.ScreenToClient(MPos);
  Node := TreeViewProjects.GetNodeAt(MPos.X, MPos.Y);
  if not Assigned(Node) then
    Exit;
    if not PtInRect(Node.DisplayRect(False), MPos) then
      Exit;
  Node.Selected := True;
  Node.Focused := True;
  Node.EndEdit(True);
  if (TSourceBase(Node.Data) is TProjectFile) then
    ProjectPropertiesClick(Sender)
  else if (TSourceBase(Node.Data) is TSourceFolder) then
    TSourceFolder(Node.Data).Open
  else if (TSourceBase(Node.Data) is TSourceFile) then
    TSourceFile(Node.Data).Edit
  else if (TSourceBase(Node.Data) is TSourceConfiguration) then
    TSourceConfiguration(Node.Data).Open;
end;

// on close tab editor

procedure TFrmFalconMain.PageControlEditorClose(Sender: TObject;
  TabIndex: Integer; var AllowClose: Boolean);
var
  SourceFile: TSourceFile;
  Sheet: TSourceFileSheet;
  I: Integer;
  clAction: Boolean;
  FileName: string;
begin
  CodeCompletion.CancelCompletion;
  if TabIndex < 0 then
    Exit;
  Sheet := TSourceFileSheet(PageControlEditor.Pages[TabIndex]);
  SourceFile := Sheet.SourceFile;
  if (not SourceFile.Saved and (not SourceFile.IsNew or
    ((SourceFile.Project.FileType = FILE_TYPE_PROJECT) and
    (Sheet.Editor.Lines.Count > 0)))) or
    (SourceFile.Modified and not(Config.Environment.RemoveFileOnClose and
    (SourceFile.Project.FileType <> FILE_TYPE_PROJECT))) then
  begin
    if SourceFile.Project.Saved then
      FileName := SourceFile.name
    else
      FileName := SourceFile.FileName;
    I := InternalMessageBox(PChar(Format(STR_FRM_MAIN[10], [FileName])),
      'Falcon C++', MB_YESNOCANCEL + MB_ICONINFORMATION);
    case I of
      mrYes:
        begin
          if SourceFile.Modified then
            SourceFile.Project.Compiled := False;
          SourceFile.Save;
        end;
      mrCancel:
        Exit;
    end;
  end;
  clAction := True;
  if (SourceFile.Project.FileType <> FILE_TYPE_PROJECT) and Config.Environment.RemoveFileOnClose
  then
  begin
    RemoveFile(Handle, SourceFile);
    Exit;
  end;
  PageControlEditor.Visible := (PageControlEditor.PageCount > 1);
  if not DebugReader.Running and (TabIndex = PageControlEditor.ActivePageIndex)
  then
    TreeViewOutline.Clear;
  if not PageControlEditor.Visible then
  begin
    PanelOutline.Hide;
  end;
  if SourceFile.Modified then
  begin
    FilesParsed.Delete(SourceFile.FileName);
    if SourceFile.Saved then
      ParseFile(SourceFile.FileName, SourceFile);
  end;
  if not PageControlEditor.Visible and (PageControlProjects.ActivePageIndex = 0)
  then
  begin
    BarItemLineStatus.Visible := False;
    BarItemBuildStatus.Visible := False;
    if ProjectPanel.Visible then
      TreeViewProjects.SetFocus;
    BarItemEncoding.Visible := False;
    BarItemLineEnding.Visible := False;
  end;
  AllowClose := clAction;
end;

procedure TFrmFalconMain.SaveExtensionChange(Sender: TObject);
begin
  with TSaveDialog(Sender) do
  begin
    case FilterIndex of
      1:
        DefaultExt := '.c';
      2:
        DefaultExt := '.cpp';
      3:
        DefaultExt := '.h';
      4:
        DefaultExt := '.rc';
    else
      DefaultExt := '';
    end;
  end;
end;

function TFrmFalconMain.SaveProject(ProjProp: TProjectBase;
  SaveMode: TSaveMode): Boolean;
var
  OldFileName: string;
  OldIsNew, OldSaved: Boolean;
begin
  Result := False;
  with TSaveDialog.Create(Self) do
  begin
    FileName := ProjProp.name;
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
          Filter := STR_NEW_MENU[3] +
            ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp';
        end;
      FILE_TYPE_H:
        begin
          DefaultExt := '.h';
          Filter := STR_NEW_MENU[4] +
            ' (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh';
        end;
      FILE_TYPE_RC:
        begin
          DefaultExt := '.rc';
          Filter := STR_NEW_MENU[5] + ' (*.rc)|*.rc';
        end;
      FILE_TYPE_UNKNOW:
        begin
          Filter := STR_NEW_MENU[2] + ' (*.c)|*.c';
          Filter := Filter + '|' + STR_NEW_MENU[3] +
            ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp';
          Filter := Filter + '|' + STR_NEW_MENU[4] +
            '  (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh';
          Filter := Filter + '|' + STR_NEW_MENU[5] + ' (*.rc)|*.rc';
          Filter := Filter + '|' + STR_FRM_MAIN[12] + '|*.*';
          FilterIndex := 2;
          DefaultExt := 'cpp';
          OnTypeChange := SaveExtensionChange;
        end;
    end;
    Options := Options + [ofOverwritePrompt];
    PageControlEditor.CancelDragging;
    if not Execute(Self.Handle) then
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
  SourceFile: TSourceBase;
  Sheet: TSourceFileSheet;
  MenuItem: TTBCustomItem;
  S: string;
begin
  if not GetActiveSheet(Sheet) then
  begin
    BarItemEncoding.Visible := False;
    BarItemLineEnding.Visible := False;
  end
  else
  begin
    if Sheet.SourceFile.Encoding = ENCODING_UTF8 then
      MenuItem := SubmenuEncoding.Items[1]
    else if Sheet.SourceFile.Encoding = ENCODING_UCS2 then
      MenuItem := SubmenuEncoding.Items[2]
    else // ENCODING_ANSI
      MenuItem := SubmenuEncoding.Items[0];
    MenuItem.Checked := True;
    BarItemEncoding.Caption := MenuItem.Caption;
    BarItemEncoding.Visible := True;
    S := '';
    PopEncWithBOM.Enabled := Sheet.SourceFile.Encoding <> ENCODING_ANSI;
    PopEncWithBOM.Checked := Sheet.SourceFile.WithBOM and
      (Sheet.SourceFile.Encoding <> ENCODING_ANSI);
    if not Sheet.SourceFile.WithBOM and
      (Sheet.SourceFile.Encoding in [ENCODING_UTF8, ENCODING_UCS2]) then
      S := 'Without BOM';
    if (Sheet.SourceFile.Encoding = ENCODING_UCS2) then
    begin
      if Sheet.SourceFile.Endian = ENDIAN_LITTLE then
        S := Trim('Little Endian ' + S)
      else if Sheet.SourceFile.Endian = ENDIAN_LITTLE then
        S := Trim('Big Endian ' + S);
    end;
    BarItemEncoding.Hint := S;
    case Sheet.Editor.GetEOLMode of
      SC_EOL_LF: // linux
        MenuItem := SubmenuEnding.Items[1];
      SC_EOL_CR: // mac
        MenuItem := SubmenuEnding.Items[2];
    else // windows
      MenuItem := SubmenuEnding.Items[0];
    end;
    MenuItem.Checked := True;
    BarItemLineEnding.Caption := MenuItem.Caption;
    BarItemLineEnding.Visible := True;
  end;
  if not GetActiveSource(SourceFile) then
  begin
    BarItemFileName.Visible := False;
    Exit;
  end;
  // update status bar
  BarItemFileName.ImageIndex := FILE_IMG_LIST[SourceFile.FileType];
  BarItemFileName.Caption := SourceFile.name;
  BarItemFileName.Hint := SourceFile.FileName;
  BarItemFileName.Visible := True;
end;

// save selected project or file in list

procedure TFrmFalconMain.FileSaveClick(Sender: TObject);
var
  SourceFile: TSourceBase;
  ProjProp: TProjectBase;
begin
  if not GetActiveSource(SourceFile) then
    Exit;
  ProjProp := SourceFile.Project;
  if not ProjProp.Saved or ProjProp.IsNew then
  begin
    SaveProject(ProjProp, smSave);
  end
  else
  begin
    SourceFile.Project.Compiled := False;
    if SourceFile is TProjectBase then
    begin
      ProjProp.SaveAll;
      ProjProp.Save;
    end
    else
      SourceFile.Save;
    UpdateMenuItems([rmFile]);
  end;

end;

// detect if enter action on file of list

procedure TFrmFalconMain.TreeViewProjectsKeyPress(Sender: TObject;
  var Key: Char);
var
  ProjProp: TProjectBase;
begin
  if not(Key = #13) or TreeViewProjects.IsEditing then
    Exit;
  if (TreeViewProjects.SelectionCount < 1) then
    Exit;
  Key := #0;
  if (TObject(TreeViewProjects.Selected.Data) is TProjectBase) then
  begin
    ProjProp := TProjectBase(TreeViewProjects.Selected.Data);
    if (ProjProp.FileType = FILE_TYPE_PROJECT) then
      TreeViewProjects.Selected.Expand(False)
    else
      EditFileClick(Sender);
  end
  else
    EditFileClick(Sender);
end;

// on change tab editor

procedure TFrmFalconMain.PageControlEditorChange(Sender: TObject);
begin
  if PageControlEditor.PageCount = 0 then
    UpdateMenuItems([rmEdit, rmSearch]);
  UpdateMenuItems([rmEdit, rmSearch, rmPageCtrlPopup]);
end;

procedure TFrmFalconMain.EditorBeforeCreate(SourceFile: TSourceFile);
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

  BoldTreeNode(SourceFile.Project.Node, True);

  if LastSelectedProject <> SourceFile.Project then
  begin
    LastSelectedProject := SourceFile.Project;
    FilesParsed.IncludeList.Clear;
    GetIncludeDirs(ExtractFilePath(SourceFile.Project.FileName),
      SourceFile.Project.Flags, FilesParsed.IncludeList);
  end;
  if ViewOutline.Checked then
    PanelOutline.Show;
  FindedTokenFile := FilesParsed.Find(SourceFile.FileName);
  if FindedTokenFile = nil then
    Exit;
  FindedTokenFile.Data := SourceFile;
  UpdateActiveFileToken(FindedTokenFile);
end;

// popupmenu close active tab editor

procedure TFrmFalconMain.FileCloseClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    PageControlEditor.CloseActiveTab;
    if GetActiveSheet(Sheet) then
      Sheet.Editor.SetFocus;
  end;
end;

// execute application

procedure TFrmFalconMain.ExecuteApplication(ProjectFile: TProjectBase);
var
  FileName, ExecFile, Source, SourcePath: string;
  List: TStrings;
  BreakpointList: TBreakpointList;
  I, J: Integer;
begin
  FileName := ProjectFile.GetTarget;
  if FileExists(FileName) then
  begin
    case ProjectFile.AppType of
      APPTYPE_DLL, APPTYPE_LIB:
        begin
          // nothing
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
            ProjectFile.GetBreakpointFiles(List);
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
              TSourceFile(List.Objects[I]).UpdateBreakpoint;
              BreakpointList := TSourceFile(List.Objects[I]).BreakPoint;
              if BreakpointList.Count = 0 then
                continue;
              Source := ExtractRelativePath(SourcePath, List.Strings[I]);
              Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
              for J := 0 to BreakpointList.Count - 1 do
              begin
                DebugReader.SendCommand(GDB_BREAK, DoubleQuotedStr(Source) + ':'
                  + IntToStr(BreakpointList.Items[J].Line));
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
              FileExists(AppRoot + 'ConsoleRunner.exe') and Config.Environment.RunConsoleRunner
            then
            begin
              Executor.ExecuteAndWatch(AppRoot + 'ConsoleRunner.exe',
                DoubleQuotedStr(FileName) + ' ' + ProjectFile.CmdLine,
                ExtractFilePath(FileName), True, INFINITE, ExecutorStart,
                LauncherFinished);
            end
            else
            begin
              Executor.ExecuteAndWatch(FileName, ProjectFile.CmdLine,
                ExtractFilePath(FileName), True, INFINITE, ExecutorStart,
                LauncherFinished);
            end;
          end;
        end;
    end;
  end;
end;

procedure TFrmFalconMain.RunExecuteClick(Sender: TObject);
var
  ProjProp: TProjectBase;
begin
  if GetActiveProject(ProjProp) then
    ExecuteApplication(ProjProp);
end;

procedure TFrmFalconMain.TreeViewProjectsEnter(Sender: TObject);
begin
  UpdateMenuItems([rmFile, rmProject, rmRun]);
  UpdateStatusbar;
end;

// on change the active tab

procedure TFrmFalconMain.PageControlEditorPageChange(Sender: TObject;
  TabIndex, PrevTabIndex: Integer);
var
  ProjProp: TProjectBase;
  Sheet, prevSheet: TSourceFileSheet;
  prop, PrevProp: TSourceFile;
  FindedTokenFile: TTokenFile;
  index: Integer;
  prjs: TTreeNode;
begin
  if HandlingTabs then
    Exit;
  index := PageControlEditor.ActivePageIndex;
  UpdateMenuItems([rmFile, rmProject, rmRun, rmPageCtrlPopup]);
  if (index >= 0) then
  begin
    prjs := TreeViewProjects.Items.GetFirstNode;
    while prjs <> nil do
    begin
      BoldTreeNode(prjs, False);
      prjs := prjs.getNextSibling;
    end;
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    prop := Sheet.SourceFile;
    if Sheet.SourceFile is TProjectBase then
      ProjProp := TProjectBase(Sheet.SourceFile)
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
    // Reload Tokens ?
    // if not DebugReader.Running then
    // TreeViewOutline.Clear;
    if not IsLoading then
    begin
      FindedTokenFile := FilesParsed.Find(prop.FileName);
      if FindedTokenFile <> nil then
        UpdateActiveFileToken(FindedTokenFile)
      else if { not FilesParsed.Busy and } not DebugReader.Running then
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
    end
    else
      Inc(FTriggerOnLoading);
  end
  else
  begin
    if not DebugReader.Running then
      TreeViewOutline.Clear;
    index := PageControlEditor.PageCount;
    if index > 0 then
      PageControlEditor.ActivePageIndex := index - 1;
  end;
  CheckIfFilesHasChanged;
  DebugHint.Cancel;
  HintParams.Cancel;
  HintTip.Cancel;
end;

// compile and execute application

procedure TFrmFalconMain.RunApplication(ProjectFile: TProjectBase);
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
    try
      ProjectFile.Build;
    except
      on E: Exception do
      begin
        AddMessage(ProjectFile.Name, 'Unable to build project', E.Message,
          0, 0, 0, mitGoto, False);
      end;
    end;
  end
  else
    ExecuteApplication(ProjectFile);
end;

procedure TFrmFalconMain.RunRunClick(Sender: TObject);
var
  ProjProp: TProjectBase;
begin
  if GetActiveProject(ProjProp) then
    RunApplication(ProjProp);
end;

// on execution finished

procedure TFrmFalconMain.LauncherFinished(Sender: TObject);
begin
  // --clean
  if Assigned(LastProjectBuild) then
    LastProjectBuild.BreakpointCursor.Valid := False;
  // ****************
  Caption := 'Falcon C++';
  RunRun.Caption := STR_MENU_RUN[1];
  BtnRun.Caption := STR_MENU_RUN[1];
  BtnRun.Hint := STR_MENU_RUN[1];
  UpdateMenuItems([rmProject, rmRun]);
end;

// stop execution or compilation

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
    Sleep(100); // ?
    DebugReader.Stop;
  end;
end;

procedure TFrmFalconMain.RunStopClick(Sender: TObject);
begin
  StopAll;
end;

// previous Sheet of editor

procedure TFrmFalconMain.BtnPreviousPageClick(Sender: TObject);
begin
  if PageControlEditor.ActivePageIndex - 1 < 0 then
    PageControlEditor.ActivePageIndex := PageControlEditor.PageCount - 1
  else
    PageControlEditor.ActivePageIndex := PageControlEditor.ActivePageIndex - 1;
end;

// next Sheet of editor

procedure TFrmFalconMain.BtnNextPageClick(Sender: TObject);
begin
  PageControlEditor.ActivePageIndex := (PageControlEditor.ActivePageIndex + 1)
    mod PageControlEditor.PageCount;
end;

// on popupmenu on project list

procedure TFrmFalconMain.TreeViewProjectsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
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
    { ProjectPopupMenuItens(True, True, True, True, True, True, True, False,
      False, False, False, False, False); }
  end
  else
  begin
    Node.Selected := True;
    Node.Focused := True;
  end;
end;

// on click on project list

procedure TFrmFalconMain.TreeViewProjectsClick(Sender: TObject);
var
  Node: TTreeNode;
  MPos: TPoint;
  prop: TSourceFile;
  Hits: THitTests;
  Sheet: TSourceFileSheet;
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
    Exit;
  end;
  Node.Selected := True;
  Node.Focused := True;
  prop := TSourceFile(Node.Data);
  if not Config.Environment.OneClickOpenFile or not (prop.FileType in FILES_TYPES) then
    Exit;
  if not GetActiveSheet(Sheet) then
    Node.EndEdit(True)
  else if (Sheet.SourceFile = prop) then
    Exit;
  prop.Edit;
end;

// compile current project

procedure TFrmFalconMain.RunCompileClick(Sender: TObject);
var
  ProjProp: TProjectBase;
begin
  CompilerActiveMsg := STR_FRM_MAIN[18];
  if GetActiveProject(ProjProp) then
  begin
    FCompilationStopped := False;
    RunNow := False;
    ProjProp.Build;
  end;
end;

// select all text

procedure TFrmFalconMain.EditSelectAllClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TSourceFileSheet(PageControlEditor.ActivePage);
    if (Sheet.Editor.Focused) then
      Sheet.Editor.SelectAll;
  end;
end;

// build application

procedure TFrmFalconMain.ProjectBuildClick(Sender: TObject);
var
  ProjProp: TProjectBase;
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
  g_OrigEditProc :=
    Pointer(SetWindowLong(TreeView_GetEditControl(TreeViewProjects.Handle),
    GWL_WNDPROC, Integer(@TreeViewEditSubclassProc)));
  if TSourceBase(Node.Data) is TSourceConfigGroup then
    AllowEdit := False;
end;

procedure TFrmFalconMain.TreeViewProjectsEdited(Sender: TObject;
  Node: TTreeNode; var S: string);
var
  OldFileName, FilePath: string;
  Ext, NewExt: string;
  InvalidExt: Boolean;
  SourceBase: TSourceBase;
begin
  SourceBase := TSourceBase(Node.Data);
  if Trim(S) = '' then
  begin
    S := SourceBase.Name;
    Exit;
  end;
  OldFileName := SourceBase.FileName;
  Ext := ExtractFileExt(OldFileName);
  NewExt := ExtractFileExt(S);
  if (Node.Level = 0) then
  begin
    FilePath := ExtractFilePath(OldFileName);
    if (SourceBase is TProjectFile) then
    begin
      TProjectFile(SourceBase).Rename(FilePath + ExtractName(S) + '.fpj');
      S := SourceBase.Name;
      Exit;
    end;
  end
  else
    FilePath := '';
  InvalidExt := (NewExt = '') or not IsValidSourceExt(NewExt);
  if (SourceBase is TSourceFile) and (Ext <> NewExt) and InvalidExt then
    SourceBase.Rename(ChangeFileExt(FilePath + S, Ext))
  else
    SourceBase.Rename(FilePath + S);
  S := SourceBase.Name;
  if not (SourceBase is TSourceFile) then
    Exit;
  SourceBase.FileType := GetFileType(S);
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
  else if ([ssCtrl, ssShift] = Shift) and (TreeViewProjects.SelectionCount = 1)
  then
  begin
    Node := TreeViewProjects.Selected;
    if Node = nil then
      Exit;
    if Key = VK_UP then
    begin
      if Node.getPrevSibling = nil then
        Exit;
      if TSourceBase(Node.getPrevSibling.Data) is TSourceConfigGroup then
        Exit;
      Node.MoveTo(Node.getPrevSibling, naInsert);
      if TSourceBase(Node.Data) is TSourceConfiguration then
        TSourceConfiguration(Node.Data).Move(-1);
    end
    else if Key = VK_DOWN then
    begin
      if Node.getNextSibling = nil then
        Exit;
      if TSourceBase(Node.Data) is TSourceConfigGroup then
        Exit;
      if (Node.getNextSibling.getNextSibling <> nil) then
        Node.MoveTo(Node.getNextSibling.getNextSibling, naInsert)
      else
        Node.MoveTo(Node.getNextSibling, naAdd);
      if TSourceBase(Node.Data) is TSourceConfiguration then
        TSourceConfiguration(Node.Data).Move(1);
    end;
    if Node.Parent <> nil then
      TSourceBase(Node.Data).Project.PropertyChanged := True;
    if (Node.Parent = nil) then
      BoldTreeNode(Node, True);
    UpdateMenuItems([rmFile]);
  end;
end;

function TFrmFalconMain.RemoveFile(ParentHandle: HWND; SourceFile: TSourceBase;
  FromDisk: Boolean): Boolean;
var
  Node: TTreeNode;
  ProjProp: TProjectBase;
  I: Integer;
  Msg: string;
begin
  Result := False;
  if SourceFile is TProjectBase then // is project
  begin
    ProjProp := SourceFile.Project;
    if not FromDisk then
    begin
      if ProjProp.Modified or (not ProjProp.Saved and not ProjProp.IsNew) or
        ProjProp.FilesChanged or ProjProp.SomeFileChanged then
      begin // modified
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
          mrCancel:
            Exit;
        end; // case
      end;
    end
    else
    begin
      if SourceFile.FileType = FILE_TYPE_FOLDER then
        Msg := STR_FRM_MAIN[53]
      else
        Msg := STR_FRM_MAIN[21];
      I := InternalMessageBox(PChar(Format(Msg, [SourceFile.name])), 'Falcon C++',
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
    if not FromDisk and Config.Environment.CreateLayoutFiles and
      ProjProp.Saved and (ProjProp.FileType = FILE_TYPE_PROJECT) then
      TProjectFile(ProjProp).SaveLayout;
    ProjProp.CloseAll;
    if ProjProp = LastSelectedProject then
      LastSelectedProject := nil;
    if LastProjectBuild = ProjProp then
    begin
      if CompilerCmd.Executing then
        CompilerCmd.Stop;
      if DebugReader.Running then
        DebugReader.Stop;
      if Executor.Running and SameText(Executor.FileName, ProjProp.GetTarget)
      then
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
  end // level = 0
  else
  begin
    if not FromDisk then
    begin
      if Config.Environment.AskForDeleteFile then
      begin
        if SourceFile.FileType = FILE_TYPE_FOLDER then
          Msg := STR_FRM_MAIN[52]
        else
          Msg := STR_FRM_MAIN[20];
        I := InternalMessageBox(PChar(Format(Msg, [SourceFile.name])),
          'Falcon C++', MB_YESNO + MB_ICONQUESTION, ParentHandle);
        if I <> mrYes then
          Exit;
      end;
      if SourceFile.Modified and SourceFile.Saved then
      begin // modified
        I := InternalMessageBox(PChar(Format(STR_FRM_MAIN[10],
          [ExtractFileName(SourceFile.FileName)])), 'Falcon C++',
          MB_YESNO + MB_ICONINFORMATION, ParentHandle);
        case I of
          mrYes: SourceFile.Save;
        end; // case
      end;
    end
    else
    begin
      if SourceFile.FileType = FILE_TYPE_FOLDER then
        Msg := STR_FRM_MAIN[53]
      else
        Msg := STR_FRM_MAIN[21];
      I := InternalMessageBox(PChar(Format(Msg, [SourceFile.name])), 'Falcon C++',
        MB_YESNOCANCEL + MB_ICONEXCLAMATION, ParentHandle);
      if I <> mrYes then
        Exit;
    end;
    Node := SourceFile.Node;
    if Node.getNextSibling = nil then
    begin
      Node := Node.getPrevSibling;
      if Assigned(Node) then
        Node.Selected := True;
    end;
    if not FromDisk then
      SourceFile.Delete
    else if SourceFile is TSourceFile then
      TSourceFile(SourceFile).DeleteOfDisk
    else if SourceFile is TSourceFolder then
      TSourceFile(SourceFile).DeleteOfDisk
    else
      raise Exception.Create('Can''t delete this object from disk');
  end;
  TreeViewProjectsChange(TreeViewProjects, TreeViewProjects.Selected);
  TextEditorExit(Self);
  PanelOutline.Visible := (PageControlEditor.PageCount > 0) and
    ViewOutline.Checked;
  if not PanelOutline.Visible then
    TreeViewOutline.Clear;
  Result := True;
end;

function TFrmFalconMain.CreateNode(const NodeText: string; Parent: TTreeNode;
  First: Boolean): TTreeNode;
begin
  if First then
    Result := TreeViewProjects.Items.AddChildFirst(Parent, NodeText)
  else
    Result := TreeViewProjects.Items.AddChild(Parent, NodeText);
  Result.ImageIndex := FILE_IMG_LIST[FILE_TYPE_UNKNOW];
  Result.SelectedIndex := FILE_IMG_LIST[FILE_TYPE_UNKNOW];
end;

function TFrmFalconMain.CreateProject(const NodeText: string; FileType: Integer): TProjectBase;
var
  Node: TTreeNode;
begin
  Node := CreateNode(NodeText, nil);
  if FileType = FILE_TYPE_PROJECT then
    Result := TProjectFile.Create(Node)
  else
    Result := TProjectSource.Create(Node);
  Node.Data := Result;

  Result.OnConfigurationChanged := DoConfigurationChanged;
  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := Result;
  Result.FileType := FileType;
  Result.Encoding := Config.Editor.DefaultEncoding;
  Result.WithBOM := Config.Editor.EncodingWithBOM;
  Result.LineEnding := Config.Editor.DefaultLineEnding;

  if FileType <> FILE_TYPE_PROJECT then
    FLastPathInclude := '';
end;

function TFrmFalconMain.CreateFolder(const NodeText: string;
  ParentNode: TTreeNode): TSourceFolder;
var
  Node: TTreeNode;
begin
  Node := CreateNode(NodeText, ParentNode);
  Result := TSourceFolder.Create(Node);
  Node.Data := Result;

  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := TSourceBase(ParentNode.Data).Project;
  Result.FileType := FILE_TYPE_FOLDER;

  FLastPathInclude := '';
end;

function TFrmFalconMain.CreateConfigGroup(const NodeText: string;
  ParentNode: TTreeNode): TSourceConfigGroup;
var
  Node: TTreeNode;
  ConfigName: string;
  SourceConfig: TSourceConfiguration;
begin
  Result := TSourceBase(ParentNode.Data).Project.ConfigurationGroup;
  if Result <> nil then
    Exit;
  Node := CreateNode(NodeText, TSourceBase(ParentNode.Data).Project.Node, True);
  Result := TSourceConfigGroup.Create(Node);
  Node.Data := Result;

  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := TSourceBase(ParentNode.Data).Project;
  Result.FileType := FILE_TYPE_CONFIG_GROUP;
  Result.FileName := NodeText;
  Result.IsNew := Result.Project.IsNew;
  Result.Saved := Result.Project.Saved;

  FLastPathInclude := '';
  ConfigName := Result.Project.Configuration.Name;
  SourceConfig := CreateConfiguration(ConfigName, Node);
  SourceConfig.FileName := ConfigName;
  SourceConfig.IsNew := Result.Project.IsNew;
  SourceConfig.Saved := Result.Project.Saved;
end;

function TFrmFalconMain.CreateConfiguration(const NodeText: string;
  ParentNode: TTreeNode): TSourceConfiguration;
var
  Node: TTreeNode;
  Config: TProjectConfiguration;
begin
  ParentNode := CreateConfigGroup(STR_NEW_MENU[9], ParentNode).Node;
  Node := CreateNode(NodeText, ParentNode);
  Result := TSourceConfiguration.Create(Node);
  Node.Data := Result;

  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := TSourceBase(ParentNode.Data).Project;
  Result.FileType := FILE_TYPE_CONFIG;
  if Node.Index > 0 then
  begin
    Config := TProjectConfiguration.Create;
    try
      Config.Assign(Result.Project.Configuration);
      Config.Name := Result.Project.Configurations.AvailableName;
      Result.Project.Configurations.Add(Config);
    finally
      Config.Free;
    end;
  end;
  FLastPathInclude := '';
end;

function TFrmFalconMain.CreateSource(const NodeText: string;
  ParentNode: TTreeNode): TSourceFile;
var
  Node: TTreeNode;
begin
  Node := CreateNode(NodeText, ParentNode);
  Result := TSourceFile.Create(Node);
  Node.Data := Result;

  Result.OnDeletion := DoDeleteSource;
  Result.OnRename := DoRenameSource;
  Result.OnTypeChanged := DoTypeChangedSource;
  Result.Project := TSourceBase(ParentNode.Data).Project;
  Result.Encoding := Config.Editor.DefaultEncoding;
  Result.WithBOM := Config.Editor.EncodingWithBOM;
  Result.LineEnding := Config.Editor.DefaultLineEnding;

  FLastPathInclude := '';
end;

procedure TFrmFalconMain.DoConfigurationChanged(Sender: TObject;
  OldIndex: Integer);
var
  SourceConfig: TSourceConfiguration;
  Project: TProjectBase;
begin
  Project := TProjectBase(Sender);
  if Project.Configurations.Count < 2 then
    Exit;
  SourceConfig := Project.SourceConfiguration[Project.ConfigurationIndex];
  BoldTreeNode(SourceConfig.Node, True);
  if (OldIndex < 0) then
    Exit;
  SourceConfig := Project.SourceConfiguration[OldIndex];
  BoldTreeNode(SourceConfig.Node, False);
end;

procedure TFrmFalconMain.DoDeleteSource(Source: TSourceBase);
var
  TokenFile: TTokenFile;
begin
  if not(Source.FileType in [FILE_TYPE_H, FILE_TYPE_CPP]) then
    Exit;
  TokenFile := FilesParsed.Find(Source.FileName);
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
  UpdateStatusbar;
  if Source is TSourceProperty then
    Exit;
  FLastPathInclude := '';
  FilePath := ExtractFilePath(ExcludeTrailingPathDelimiter(OldFileName));
  if Source is TProjectBase then
  begin
    if (Source.FileType = FILE_TYPE_PROJECT) and
      SameText(FilePath, ExtractFilePath(Source.FileName)) then
      Exit;
    ParseList := TStringList.Create;
    RemoveList := TStringList.Create;
    if (Source.FileType = FILE_TYPE_PROJECT) then
    begin
      TProjectBase(Source).GetSources(ParseList, SOURCE_TYPES);
      CurrentFilePath := ExtractFilePath
        (ExcludeTrailingPathDelimiter(Source.FileName));
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
    if Source is TSourceFolder then // folder or project
    begin
      TSourceFolder(Source).GetSources(ParseList, SOURCE_TYPES);
      for I := 0 to ParseList.Count - 1 do
      begin
        Temp := ExtractRelativePath(Source.FileName, ParseList.Strings[I]);
        RemoveList.AddObject(OldFileName + Temp, ParseList.Objects[I]);
      end;
    end
    else
    begin
      ParseList.AddObject(Source.FileName, Source);
      RemoveList.AddObject(OldFileName, Source);
    end;
  end;
  for I := 0 to RemoveList.Count - 1 do
  begin
    FindedTokenFile := FilesParsed.Find(RemoveList.Strings[I]);
    if FindedTokenFile <> nil then
      FilesParsed.Remove(FindedTokenFile);
  end;
  RemoveList.Free;
  ParseFiles(ParseList);
  ParseList.Free;
end;

// update icons and set highlighter
procedure TFrmFalconMain.DoTypeChangedSource(Source: TSourceBase;
  OldType: Integer);
var
  Sheet: TSourceFileSheet;
begin
  if Assigned(Source.Node) then
  begin
    Source.Node.ImageIndex := FILE_IMG_LIST[Source.FileType];
    Source.Node.SelectedIndex := FILE_IMG_LIST[Source.FileType];
  end;
  if (Source is TSourceFile) and TSourceFile(Source).GetSheet(Sheet) then
  begin
    Sheet.ImageIndex := FILE_IMG_LIST[Source.FileType];
    case Source.FileType of
      FILE_TYPE_C .. FILE_TYPE_H:
        Sheet.Editor.Highlighter := CppHighligher;
      // TODO: commented
      // FILE_TYPE_RC: Sheet.Editor.Highlighter := FrmFalconMain.ResourceHighlighter;
    end;
  end;
end;

procedure TFrmFalconMain.PopProjDelFromDskClick(Sender: TObject);
var
  Node: TTreeNode;
  SourceFile: TSourceFile;
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if not TreeViewProjects.IsEditing then
    begin
      Node := TreeViewProjects.Selected;
      SourceFile := TSourceFile(Node.Data);
      RemoveFile(Handle, SourceFile, True)
    end; // not editing
  end; // count > 0
end;

procedure TFrmFalconMain.PopProjRenameClick(Sender: TObject);
begin
  if TreeViewProjects.SelectionCount = 0 then
    Exit;
  TreeViewProjects.Selected.EditText;
end;

procedure TFrmFalconMain.PopProjOpenClick(Sender: TObject);
var
  SourceFile: TSourceBase;
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
    if SameText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) then
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
    if SameText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) then
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
    TSpTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[32];
    TSpTBXItem(FileReopen.Items[0]).Enabled := True;
    TSpTBXItem(FileReopen.Items[0]).ImageIndex := 51;
    FileReopen.Add(TSpTBXSeparatorItem.Create(Self));
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
    if SameText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) then
    begin
      FileReopen.Delete(I);
      if FileReopen.Count > 2 then
        Exit;
      FileReopen.Delete(1);
      TSpTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[31];
      TSpTBXItem(FileReopen.Items[0]).Enabled := False;
      TSpTBXItem(FileReopen.Items[0]).ImageIndex := -1;
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
  TSpTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[31];
  TSpTBXItem(FileReopen.Items[0]).Enabled := False;
  TSpTBXItem(FileReopen.Items[0]).ImageIndex := -1;
end;

procedure TFrmFalconMain.ReopenFileClick(Sender: TObject);
var
  ProjectBase: TProjectBase;
begin
  if not(Sender is TDataMenuItem) then
    Exit;
  IncLoading;
  if OpenFileWithHistoric(TDataMenuItem(Sender).HelpFile, ProjectBase) then
    ParseProjectFiles(ProjectBase);
  DecLoading;
end;

function TFrmFalconMain.OpenFileWithHistoric(Value: string;
  var ProjectBase: TProjectBase): Boolean;
var
  ProjProp: TProjectBase;
  SourceFile: TSourceFile;
begin
  Result := False;
  if not FileExists(Value) then
  begin
    RemoveFileFromHistoric(Value);
    Exit;
  end;
  if SearchSourceFile(Value, SourceFile) then
  begin
    if SourceFile.FileType <> FILE_TYPE_PROJECT then
    begin
      SourceFile.Edit;
      SourceFile.Node.Selected := True;
    end;
  end
  else
  begin
    if SameText(ExtractFileExt(Value), '.dev') then
      Result := ImportDevCppProject(Value, ProjectBase)
    else if SameText(ExtractFileExt(Value), '.cbp') then
      Result := ImportCodeBlocksProject(Value, ProjectBase)
    else if SameText(ExtractFileExt(Value), '.vcproj') then
      Result := ImportMSVCProject(Value, ProjectBase)
    else
    begin
      ProjProp := OpenFile(Value);
      Result := True;
      ProjectBase := ProjProp;
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
    TreeViewOutline_DblClick(TreeViewOutline)
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
  FileCount: Longint;
  Buffer: array [0 .. MAX_PATH] of Char;
  Files: TStrings;
  I: Integer;
  P: TPoint;
  FileName: string;
begin
  Files := TStringList.Create;
  FileCount := DragQueryFile(TWMDropFiles(Msg).Drop, $FFFFFFFF, nil, 0);
  for I := 0 to FileCount - 1 do
  begin
    DragQueryFile(TWMDropFiles(Msg).Drop, I, @Buffer, sizeof(Buffer));
    FileName := StrPas(Buffer);
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

function TFrmFalconMain.GetIsLoading: Boolean;
begin
  Result := FLoadingCount > 0;
end;

procedure TFrmFalconMain.OnDragDropFiles(Sender: TObject; Files: TStrings);
var
  I: Integer;
  ProjectBase: TProjectBase;
begin
  IncLoading;
  for I := 0 to Files.Count - 1 do
  begin
    if OpenFileWithHistoric(Files.Strings[I], ProjectBase) then
      ParseProjectFiles(ProjectBase);
  end;
  DecLoading;
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

// on build finished

procedure TFrmFalconMain.CompilerCmdFinish(Sender: TObject;
  const FileName, Params: string; ConsoleOut: TStrings; ExitCode: Integer);
var
  Item: TListItem;
  Temp, NewVer, capt, TimeStr: string;
  RowSltd: Boolean;
  I: Integer;
  CompMessages: TStrings;
  Msg: TMessageItem;
begin
  BuildTime := GetTickCount - startBuildTicks;
  ListViewMsg.Clear;
  capt := Caption;
  CompMessages := ParseResult(ConsoleOut);
  if (ExitCode = 0) then
  begin
    TimeStr := Format(STR_FRM_MAIN[39], [GetTickTime(BuildTime)]);
    BarItemBuildStatus.Caption := TimeStr;
    BarItemBuildStatus.ImageIndex := 32;
    BarItemBuildStatus.Visible := True;
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
        Break;
      if (CompMessages.Count > 500) then
        Caption := Format('Falcon C++ [' + STR_FRM_MAIN[41] + ']',
          [I + 1, CompMessages.Count]);
      Application.ProcessMessages;
      Msg := TMessageItem(CompMessages.Objects[I]);
      AddMessage(Msg.FileName, Msg.FileName, Msg.Msg, Msg.Line, Msg.Col,
        Msg.EndCol, Msg.MsgType, False);
      Item := ListViewMsg.Items.Add;
      Item.ImageIndex := Msg.Icon;
      Item.Caption := ExtractFileName(Msg.FileName);
      Item.SubItems.Add(Msg.GetPosXY);
      Item.SubItems.Add(Msg.Msg);
      Item.Data := Msg;
    end;

    LastProjectBuild.Compiled := True;
    LastProjectBuild.CompilePropertyChanged := False;
    Temp := VersionToStr(LastProjectBuild.Version.Version);
    if LastProjectBuild.AutoIncBuild and LastProjectBuild.IncludeVersionInfo then
    begin
      if (LastProjectBuild.Version.Version.Build < 9999) then
        Inc(LastProjectBuild.Version.Version.Build)
      else
      begin
        LastProjectBuild.Version.Version.Build := 0;
        Inc(LastProjectBuild.Version.Version.Minor);
      end;
    end;
    NewVer := VersionToStr(LastProjectBuild.Version.Version);
    if (NewVer <> Temp) and LastProjectBuild.IncludeVersionInfo then
    begin
      LastProjectBuild.PropertyChanged := True;
      if LastProjectBuild.Version.FileVersion = Temp then
         LastProjectBuild.Version.FileVersion := NewVer;
      if LastProjectBuild.Version.ProductVersion = Temp then
         LastProjectBuild.Version.ProductVersion := NewVer;
      UpdateMenuItems([rmFile]); // update save buttons
    end;
    Temp := ExtractFilePath(LastProjectBuild.FileName);
    if FileExists(Temp + 'Makefile.mak') and LastProjectBuild.DeleteMakefileAfter
    then
      DeleteFile(Temp + 'Makefile.mak');
    if (LastProjectBuild.EnableTheme or LastProjectBuild.RequiresAdmin) and
      (LastProjectBuild.AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) and
      FileExists(Temp + 'AppManifest.dat') and LastProjectBuild.DeleteResourcesAfter
    then
      DeleteFile(Temp + 'AppManifest.dat');
    if FileExists(Temp + 'AppResource.rc') and LastProjectBuild.DeleteResourcesAfter
    then
      DeleteFile(Temp + 'AppResource.rc');
    if FileExists(Temp + 'AppIcon.ico') and LastProjectBuild.DeleteResourcesAfter
    then
      DeleteFile(Temp + 'AppIcon.ico');
    if FileExists(LastProjectBuild.GetTarget) then
    begin
      LastProjectBuild.TargetDateTime :=
        FileDateTime(LastProjectBuild.GetTarget);
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
    // images msg  32 .. 34
    BarItemBuildStatus.Caption := STR_FRM_MAIN[40];
    BarItemBuildStatus.ImageIndex := 34;
    BarItemBuildStatus.Visible := True;
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
        Break;
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

procedure TFrmFalconMain.ShowLineError(Project: TProjectBase;
  Msg: TMessageItem);

  procedure GotoAndExit;
  var
    SourceFile: TSourceFile;
    Sheet: TSourceFileSheet;
  begin
    if SearchAndOpenFile(Msg.FileName, SourceFile) then
    begin
      Sheet := SourceFile.Edit;
      GotoLineAndAlignCenter(Sheet.Editor, Msg.Line, Msg.Col, Msg.EndCol, True);
    end;
    Exit;
  end;

var
  SourceFile: TSourceFile;
  Sheet: TSourceFileSheet;
  SLine, Temp, MMsg: string;
  Line, ColS, ColE, Col, SearchResult: Integer;
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
        FrmFalconMain.Config.Compiler.path, [])
    else
      Temp := Temp + Msg.FileName;
    Temp := ExpandFileName(Temp);
  end;
  if SearchSourceFile(Temp, SourceFile) then
  begin
  end
  else if FileExists(Temp) then
  begin
    SourceFile := OpenFile(Temp);
    SourceFile.readonly := True;
  end
  else
    Exit;
  if (Pos(MAKEFILE_MSG[2], MMsg) > 0) then
  begin
    SourceFile.Node.Owner.Owner.SetFocus;
    SourceFile.Node.Selected := True;
    SourceFile.Node.Focused := True;
    Exit;
  end;
  SourceFile.Edit;
  if not SourceFile.GetSheet(Sheet) or (Line <= 0) then
    Exit;
  Sheet.Editor.UncollapseLine(Line);
  Sheet.Editor.GotoLineAndCenter(Line);
  SLine := Sheet.Editor.Lines.Strings[Line - 1];
  Temp := StringBetween(MMsg, #39, #39, False);
  if (Length(Temp) > 0) then
  begin
    Sheet.Editor.SetSearchFlags(SCFIND_MATCHCASE or SCFIND_WHOLEWORD);
    Sheet.Editor.SetTargetStart(Sheet.Editor.PositionFromLine(Line - 1));
    Sheet.Editor.SetTargetEnd(Sheet.Editor.GetLineEndPosition(Line - 1));
    SearchResult := Sheet.Editor.SearchInTarget(Temp);
    if SearchResult <> -1 then
    begin
      ColS := Sheet.Editor.CountCharacters
        (Sheet.Editor.PositionFromLine(Line - 1), SearchResult) + 1;
      ColE := ColS + Length(Temp);
      GotoLineAndAlignCenter(Sheet.Editor, Line, ColS, ColE, True);
    end;
  end;
  if Col > 0 then
    GotoLineAndAlignCenter(Sheet.Editor, Line, Col);
  ActiveErrorLine := Line;
  Sheet.Editor.InvalidateLine(ActiveErrorLine);
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

procedure TFrmFalconMain.AddFilesToProject(Files: TStrings; Parent: TSourceBase;
  References: Boolean; ImportMode: Boolean);
var
  OwnerFile, Container: TSourceBase;
  NewFile: TSourceBase;
  I: Integer;
  SrcDir, FolderName, ParentPath: string;
begin
  // detect parent node
  Container := nil;
  while True do
  begin
    if Parent.FileType = FILE_TYPE_PROJECT then
    begin
      Container := TProjectFile(Parent);
      ParentPath := ExtractFilePath(Parent.FileName);
      Break;
    end
    else if Parent.FileType = FILE_TYPE_FOLDER then
    begin
      Parent.Save;
      ParentPath := Parent.FileName;
      Container := TSourceFolder(Parent);
      Break;
    end
    else if (Parent.Node.Parent <> nil) then
      Parent := TSourceBase(Parent.Node.Parent.Data)
    else
    begin
      Files.Clear;
      Exit;
    end;
  end;
  Assert(Container <> nil);
  // create in depth file by file
  for I := Files.Count - 1 downto 0 do
  begin
    OwnerFile := Container;
    if References then
    begin
      SrcDir := ExtractRelativePath(ParentPath,
        ExtractFilePath(Files.Strings[I]));
      SrcDir := ExcludeTrailingPathDelimiter(SrcDir);
      // create tree folder
      while SrcDir <> '' do
      begin
        FolderName := ExtractRootPathName(SrcDir);
        if not OwnerFile.SearchSource(FolderName, NewFile) then
        begin
          OwnerFile := CreateSourceFolder(FolderName, TSourceBase(OwnerFile));
          TSourceFolder(OwnerFile).IsNew := False;
          TSourceFolder(OwnerFile).Saved := True;
        end
        else
          OwnerFile := TSourceFolder(NewFile);
        SrcDir := ExcludeRootPathName(SrcDir);
      end;
    end;
    if OwnerFile.SearchSource(ExtractFileName(Files.Strings[I]), NewFile) then
    begin
      Files.Delete(I);
      Continue;
    end;
    NewFile := NewSourceFile(GetFileType(Files.Strings[I]), COMPILER_C,
      ExtractFileName(Files.Strings[I]), ExtractName(Files.Strings[I]),
      ExtractFileExt(Files.Strings[I]), Files.Strings[I], TSourceBase(OwnerFile),
      True, False);
    if not ImportMode then
    begin
      NewFile.Project.PropertyChanged := True;
      NewFile.Project.CompilePropertyChanged := True;
    end;
    if not References then
    begin
      TSourceFile(NewFile).LoadFromFile(Files.Strings[I]);
    end
    else
    begin
      TSourceFile(NewFile).DateOfFile := FileDateTime(NewFile.FileName);
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
  SourceFile: TSourceBase;
  References: Boolean;
  List: TStrings;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := STR_FRM_MAIN[12] + ' |*.c; *.cpp; *.cc; *.cxx; *.c++; *.cp; *.h;'
      + ' *.hpp; *.rh; *.hh; *.rc|' + STR_NEW_MENU[2] + ' (*.c)|*.c|' +
      STR_NEW_MENU[3] +
      ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp|' +
      STR_NEW_MENU[4] + ' (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh|' +
      STR_NEW_MENU[5] + ' (*.rc)|*.rc';
    FilterIndex := 1;
    Options := Options + [ofAllowMultiSelect, ofFileMustExist, ofPathMustExist,
      ofNoChangeDir];
    if GetSelectedFileInList(SourceFile) then
    begin
      if (SourceFile is TSourceFile) then
        InitialDir := ExtractFilePath(SourceFile.FileName)
      else
        InitialDir := SourceFile.FileName;
    end;
    if Execute(Self.Handle) then
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
      AddFilesToProject(List, SourceFile, References);
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
  ProjectBase: TProjectBase;
begin
  if GetActiveProject(ProjectBase) then
  begin
    if not Assigned(FrmRemove) then
      FrmRemove := TFrmRemove.CreateParented(Handle);
    FrmRemove.SetProject(TProjectFile(ProjectBase));
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
  // Top Menu
  // Item := MenuBar.Items.Items[0];
  for I := 0 to MenuBar.Items.Count - 1 do
    MenuBar.Items.Items[I].Caption := STR_MENUS[I + 1];

  // File Menu
  Item := MenuFile;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_FILE[I + 1];

  // Edit Menu
  Item := MenuEdit;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_EDIT[I + 1];

  // Search Menu
  Item := MenuSearch;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_SERH[I + 1];

  // Search Menu
  Item := MenuView;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_VIEW[I + 1];

  // Project Menu
  Item := MenuProject;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_PROJ[I + 1];

  // Run Menu
  Item := MenuRun;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_RUN[I + 1];

  // Tools Menu
  Item := MenuTools;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_TOOL[I + 1];

  // Help Menu
  Item := MenuHelp;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_MENU_HELP[I + 1];

  // New From File Menu
  Item := FileNew;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_NEW_MENU[I + 1];

  // Import From File Menu
  Item := FileImport;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_IMPORT_MENU[I + 1];

  // Toolbars From View Menu
  Item := ViewToolbar;
  for I := 0 to Item.Count - 1 do
    Item[I].Caption := STR_VIEWTOOLBAR_MENU[I + 1];

  // (Empty) From File Menu Reopen
  if FileReopen.Count > 2 then
    FileReopenClear.Caption := STR_FRM_MAIN[32]
  else
    FileReopenClear.Caption := STR_FRM_MAIN[31];

  // PopupMenu from Project List
  // Item := PopupProject.Items.Items;
  for I := 0 to PopupProject.Items.Count - 1 do
    PopupProject.Items.Items[I].Caption := STR_POPUP_PROJ[I + 1];

  // PopupMenu from Editor
  // Item := PopupEditor.Items;
  for I := 0 to PopupEditor.Items.Count - 1 do
    PopupEditor.Items.Items[I].Caption := STR_POPUP_EDITOR[I + 1];

  // PopupMenu from Tabs
  // Item := PopupTabs.Items;
  for I := 0 to PopupTabs.Items.Count - 1 do
    PopupTabs.Items.Items[I].Caption := STR_POPUP_TABS[I + 1];

  // PopupMenu from Messages
  // Item := PopupMsg.Items;
  for I := 0 to PopupMsg.Items.Count - 1 do
    PopupMsg.Items.Items[I].Caption := STR_POPUP_MSGS[I + 1];

  // tabs left
  TSProjects.Caption := STR_FRM_MAIN[1];
  // TSExplorer.Caption := STR_FRM_MAIN[2];

  // tabs right
  TSOutline.Caption := STR_FRM_MAIN[3];

  // tabs down
  TSMessages.Caption := STR_FRM_MAIN[4];

  // tabs left
  ListViewMsg.Column[0].Caption := STR_FRM_MAIN[6];
  ListViewMsg.Column[1].Caption := STR_FRM_MAIN[7];
  ListViewMsg.Column[2].Caption := STR_FRM_MAIN[8];

  // Toolbars
  // DefaultBar
  DefaultBar.Caption := STR_VIEWTOOLBAR_MENU[1];
  for I := 0 to DefaultBar.Items.Count - 1 do
  begin
    DefaultBar.Items.Items[I].Caption := STR_DEFAULTBAR[I + 1];
    DefaultBar.Items.Items[I].Hint := STR_DEFAULTBAR[I + 1];
  end;

  // EditBar
  EditBar.Caption := STR_VIEWTOOLBAR_MENU[2];
  for I := 0 to EditBar.Items.Count - 1 do
  begin
    EditBar.Items.Items[I].Caption := STR_EDITBAR[I + 1];
    EditBar.Items.Items[I].Hint := STR_EDITBAR[I + 1];
  end;

  // SearchBar
  SearchBar.Caption := STR_VIEWTOOLBAR_MENU[3];
  for I := 0 to SearchBar.Items.Count - 1 do
  begin
    SearchBar.Items.Items[I].Caption := STR_SEARCHBAR[I + 1];
    SearchBar.Items.Items[I].Hint := STR_SEARCHBAR[I + 1];
  end;

  // CompilerBar
  CompilerBar.Caption := STR_VIEWTOOLBAR_MENU[4];
  for I := 0 to CompilerBar.Items.Count - 1 do
  begin
    CompilerBar.Items.Items[I].Caption := STR_COMPILERBAR[I + 1];
    CompilerBar.Items.Items[I].Hint := STR_COMPILERBAR[I + 1];
  end;

  // NavigatorBar
  NavigatorBar.Caption := STR_VIEWTOOLBAR_MENU[5];
  for I := 0 to NavigatorBar.Items.Count - 1 do
  begin
    NavigatorBar.Items.Items[I].Caption := STR_NAVIGATORBAR[I + 1];
    NavigatorBar.Items.Items[I].Hint := STR_NAVIGATORBAR[I + 1];
  end;

  // ProjectBar
  ProjectBar.Caption := STR_VIEWTOOLBAR_MENU[6];
  for I := 0 to ProjectBar.Items.Count - 1 do
  begin
    ProjectBar.Items.Items[I].Caption := STR_PROJECTBAR[I + 1];
    ProjectBar.Items.Items[I].Hint := STR_PROJECTBAR[I + 1];
  end;

  // HelpBar
  HelpBar.Caption := STR_VIEWTOOLBAR_MENU[7];
  for I := 0 to HelpBar.Items.Count - 1 do
  begin
    HelpBar.Items.Items[I].Caption := STR_HELPBAR[I + 1];
    HelpBar.Items.Items[I].Hint := STR_HELPBAR[I + 1];
  end;

  // DebugBar
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
  Msg: TMessageItem;
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
        continue;
      Msg := TMessageItem(ListViewMsg.Items.Item[I].Data);
      if C = 0 then
        S := Msg.Msg
      else
        S := S + #13#10 + Msg.Msg;
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
  Msg: TMessageItem;
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
        continue;
      Msg := TMessageItem(ListViewMsg.Items.Item[I].Data);
      tmp := Msg.OriMsg;
      if Pos('${COMPILER_PATH}', Msg.OriMsg) > 0 then
        tmp := StringReplace(Msg.OriMsg, '${COMPILER_PATH}',
          FrmFalconMain.Config.Compiler.path, []);
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
  Msg: TMessageItem;
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
        continue;
      Msg := TMessageItem(ListViewMsg.Items.Item[I].Data);
      tmp := Msg.OriMsg;
      if Pos('${COMPILER_PATH}', Msg.OriMsg) > 0 then
        tmp := StringReplace(Msg.OriMsg, '${COMPILER_PATH}',
          FrmFalconMain.Config.Compiler.path, []);
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
  ProjProp: TProjectBase;
  Sibling: TTreeNode;
begin
  Sibling := TreeViewProjects.Items.GetFirstNode;
  while Sibling <> nil do
  begin
    ProjProp := TProjectBase(Sibling.Data);
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
  SourceFile: TSourceFile;
  ProjProp: TProjectBase;
begin
  if GetActiveFile1(SourceFile) then
  begin
    ProjProp := SourceFile.Project;
    if SaveProject(ProjProp, smSaveAs) then
      UpdateStatusbar;
  end;
end;

function TFrmFalconMain.DetectScope(Editor: TEditor; TokenFile: TTokenFile;
  ShowInTreeview: Boolean): TTokenClass;
var
  token: TTokenClass;
  Node, Parent: PVirtualNode;
  SelStart: Integer;
  BC: TBufferCoord;
begin
  Result := nil;
  BC := Editor.CaretXY;
  if BC.Line > 0 then
  begin
    if BC.Char > (Length(Editor.Lines[BC.Line - 1]) + 1) then
      BC.Char := Length(Editor.Lines[BC.Line - 1]) + 1;
  end;
  if ShowInTreeview and DebugReader.Running then
    Exit;
  SelStart := Editor.RowColToCharIndex(BC);
  if TokenFile.GetTokenAt(token, SelStart, BC.Line) then
  begin
    if Assigned(token.Parent) and
      (token.Parent.token in [tkParams, tkFunction, tkProtoType, tkConstructor,
      tkOperator]) then
    begin
      token := token.Parent;
      if (token.token = tkParams) and Assigned(token.Parent) then
        token := token.Parent;
    end;
    Result := token;
    if not ShowInTreeview then
      Exit;
    Node := PVirtualNode(token.Data);
    // unknow bug
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
  else if TokenFile.GetScopeAt(token, SelStart) then
  begin
    Result := token;
    if not ShowInTreeview then
      Exit;
    Node := PVirtualNode(token.Data);
    // unknow bug
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

// onparser last active file

procedure TFrmFalconMain.TextEditorFileParsed(EditFile: TSourceFile;
  TokenFile: TTokenFile);
var
  IncludeFileName, IncludeName: string;
  I, J: Integer;
  FileList, ParseList, IncludeList: TStrings;
  Project: TProjectBase;
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
    GetIncludeDirs(ExtractFilePath(Project.FileName), Project.Flags,
      IncludeList, True);
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    FileExistsFlag := False;
    IncludeName := ConvertSlashes(TokenFile.Includes.Items[I].name);
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
      continue;
    IncludeFileName := ExpandFileName(IncludeFileName);
    // don't parse compiler header file
    if not CompilerHeaderFile then
    begin
      // if SameText(IncludeFileName, Config.Compiler.Path + '\include\' + IncludeName) = 0 then
      // raise Exception.Create('Cannot load compiler header file');
      // check if file is an project
      if (Project <> nil) then
      begin
        IncludeFile := TProjectFile(Project).GetFileByPathName
          (ExtractRelativePath(ExtractFilePath(Project.FileName),
          IncludeFileName));
      end
      else
        IncludeFile := nil;
      if IncludeFile = nil then
      begin
        if (FilesParsed.Find(IncludeFileName) = nil) then
          ParseList.AddObject(IncludeFileName, nil);
      end;
      continue;
    end;
    FileList.Add(IncludeFileName);
  end;
  ThreadLoadTkFiles.LoadRecursive(FileList, Config.Compiler.path + '\include\',
    ConfigRoot + 'include\', '.prs');
  ParseFiles(ParseList);
  IncludeList.Free;
  ParseList.Free;
  FileList.Free;
end;

// event on change text in editor

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
  Eol: Integer;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Eol := TSourceFile.GetEditorEolMode(TComponent(Sender).Tag);
  if Sheet.Editor.GetEOLMode <> Eol then
    Sheet.Editor.ConvertEOLs(Eol);
  Sheet.Editor.SetEOLMode(Eol);
  Sheet.SourceFile.LineEnding := TComponent(Sender).Tag;
  UpdateStatusbar;
end;

procedure TFrmFalconMain.TextEditorChange(Sender: TObject);
var
  Editor: TEditor;
  Sheet: TSourceFileSheet;
  FilePrp: TSourceFile;
begin
  if not (Sender is TEditor) then
    Exit;
  Editor := TEditor(Sender);
  TParserThread(fWorkerThread).DataChanged;
  UpdateMenuItems([rmFile, rmEdit, rmSearch, rmRun]); { rmRun for Breakpoint }
  Sheet := TSourceFileSheet(Editor.Owner);
  FilePrp := Sheet.SourceFile;
  FilePrp.Changed;
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  HintTip.Cancel;
  DebugHint.Cancel;
  ActiveEditingFile.FileName := FilePrp.FileName;
  ActiveEditingFile.Data := FilePrp;
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

// other event of change of code editor

procedure TFrmFalconMain.TextEditorStatusChange(Sender: TObject;
  AUpdated: Integer);
var
  LastActiveErrorLine: Integer;
begin
  if (AUpdated and SC_UPDATE_SELECTION) <> SC_UPDATE_SELECTION then
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
  if HintParams.Activated and
    ((AUpdated and SC_UPDATE_SELECTION) = SC_UPDATE_SELECTION) and
    (Sender is TEditor) then
  begin
    TimerHintParams.Enabled := False;
    TimerHintParams.Enabled := True;
  end;
  TextEditorUpdateStatusBar(Sender);
end;

procedure TFrmFalconMain.TextEditorUpdateStatusBar(Sender: TObject);
begin
  if (Sender is TEditor) then
  begin
    BarItemLineStatus.Caption :=
      Format('Ln : %d    Col : %d    Sel : %d', [(Sender as TEditor).DisplayY,
      (Sender as TEditor).DisplayX, (Sender as TEditor).SelLength]);
    BarItemLineStatus.Visible := True;
  end;
end;

// on enter in code editor

procedure TFrmFalconMain.TextEditorEnter(Sender: TObject);
var
  ProjProp: TProjectBase;
  SourceFile: TSourceFile;
  I, X, Y: Integer;
begin
  CheckIfFilesHasChanged;
  UpdateMenuItems([rmFile, rmEdit, rmSearch]);
  if GetActiveFile1(SourceFile) then
    UpdateStatusbar;
  if GetActiveProject(ProjProp) then
  begin
    if (Sender is TEditor) then
    begin
      TextEditorUpdateStatusBar(Sender);
      for I := 1 to 9 do
        if TEditor(Sender).GetBookMark(I, X, Y) then
        begin
          TSpTBXItem(EditBookmarks.Items[I - 1]).Checked := True;
          TSpTBXItem(EditGotoBookmarks.Items[I - 1]).Checked := True;
          TSpTBXItem(EditGotoBookmarks.Items[I - 1]).Enabled := True;
        end
        else
        begin
          TSpTBXItem(EditBookmarks.Items[I - 1]).Checked := False;
          TSpTBXItem(EditGotoBookmarks.Items[I - 1]).Checked := False;
          TSpTBXItem(EditGotoBookmarks.Items[I - 1]).Enabled := False;
        end;
    end;
  end;
end;

// on exit of code editor

procedure TFrmFalconMain.TextEditorExit(Sender: TObject);
begin
  CheckIfFilesHasChanged;
  UpdateMenuItems([rmEdit, rmSearch]);
  HintParams.Cancel;
end;

procedure TFrmFalconMain.TextEditorMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Sheet: TSourceFileSheet;
  SourceFile: TSourceFile;
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
      if not GetActiveSheet(Sheet) then
        Exit;
      TimerHintTipEvent.Enabled := False;
      if not GetActiveFile1(SourceFile) then
        Exit;
      ProcessHintView(SourceFile, Sheet.Editor, X, Y);
    end
    else if not HintParams.Activated then
    begin
      CanShowHintTip := False;
      TimerHintTipEvent.Enabled := True;
    end;
  end;
end;

// link click in edit

procedure TFrmFalconMain.TextEditorLinkClick(Sender: TObject;
  AModifiers: Integer; APosition: Integer);
var
  FileName, Fields, Input: string;
  prop: TSourceFile;
  ProjectBase: TProjectBase;
  Sheet: TSourceFileSheet;
  IncludeList: TStrings;
  I: Integer;
  TokenFileItem: TTokenFile;
  token: TTokenClass;
  SelStart: Integer;
  InputError: Boolean;
  StyleID: Integer;
  Style: THighlighStyle;
  S: string;
  IncludeToken: TTokenClass;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  StyleID := Sheet.Editor.GetStyleAt(APosition);
  Style := Sheet.Editor.Highlighter.FindStyleByID(StyleID);
  S := Sheet.Editor.GetLine(Sheet.Editor.LineFromPosition(APosition));
  // #include <stdio.h>
  if (Style <> nil) and (Style.name = HL_Style_Preprocessor) and
    (Pos('#', S) < Pos('include', S)) and (Pos('#', S) > 0) then
  begin
    if ActiveEditingFile.GetTokenAt(IncludeToken, APosition) then
    begin
      if IncludeToken.token = tkInclude then
        S := IncludeToken.name;
    end;
    S := ConvertSlashes(S);
    // search #include <stdio.h> in project
    prop := Sheet.SourceFile;
    ProjectBase := prop.Project;
    if ProjectBase.FileType = FILE_TYPE_PROJECT then
    begin
      prop := TProjectFile(ProjectBase).GetFileByPathName(S);
      if prop <> nil then
      begin
        prop.Edit;
        Exit;
      end;
      IncludeList := TStringList.Create;
      GetIncludeDirs(ExtractFilePath(ProjectBase.FileName), ProjectBase.Flags, IncludeList);
      for I := 0 to IncludeList.Count - 1 do
      begin
        prop := TProjectFile(ProjectBase).GetFileByPathName
          (ExtractRelativePath(ExtractFilePath(ProjectBase.FileName),
          ExpandFileName(IncludeList.Strings[I] + S)));
        if prop <> nil then
        begin
          prop.Edit;
          IncludeList.Free;
          Exit;
        end;
      end;
      IncludeList.Free;
      prop := Sheet.SourceFile;
    end;
    // not found in project, search file on source file folder
    FileName := ExpandFileName(ExtractFilePath(prop.FileName) + S);
    if SearchSourceFile(FileName, prop) then
    begin
      prop.Edit;
      Exit;
    end;
    if FileExists(FileName) then
    begin
      prop := OpenFile(FileName);
      prop.readonly := True;
      Sheet := prop.Edit;
      Sheet.Editor.readonly := True;
      Sheet.Font.Color := clGrayText;
      Exit;
    end;
    // search in compiler folder
    for I := 0 to FilesParsed.PathList.Count - 1 do
    begin
      FileName := ExpandFileName(FilesParsed.PathList.Strings[I] + S);
      if FileExists(FileName) then
      begin
        prop := OpenFile(FileName);
        prop.readonly := True;
        Sheet := prop.Edit;
        Sheet.Editor.readonly := True;
        Sheet.Font.Color := clGrayText;
        Exit;
      end;
    end;
    IncludeList := TStringList.Create;
    GetIncludeDirs(ExtractFilePath(ProjectBase.FileName), ProjectBase.Flags, IncludeList);
    for I := 0 to IncludeList.Count - 1 do
    begin
      FileName := ExpandFileName(IncludeList.Strings[I] + S);
      if FileExists(FileName) then
      begin
        prop := OpenFile(FileName);
        prop.readonly := True;
        Sheet := prop.Edit;
        Sheet.Editor.readonly := True;
        Sheet.Font.Color := clGrayText;
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
    SelStart := Sheet.Editor.WordStartPosition(APosition, True);
    if not ParseFields(Sheet.Editor.Lines.Text, SelStart, Input, Fields,
      InputError) then
      Exit;
    // find declaration
    if not FilesParsed.FindDeclaration(Input, Fields, ActiveEditingFile,
      ActiveEditingFile, TokenFileItem, token, SelStart) then
      Exit;
    if TokenFileItem = ActiveEditingFile then // current file
    begin
      SelectToken(token);
      Exit;
    end;
    // other file
    // is in project list
    IncLoading;
    if SearchSourceFile(TokenFileItem.FileName, prop) then
      prop.Edit
    else // non opened. open
    begin
      prop := TSourceFile(OpenFile(TokenFileItem.FileName));
      prop.readonly := True;
      Sheet := prop.Edit;
      Sheet.Editor.readonly := True;
      Sheet.Font.Color := clGrayText;
    end;
    DecLoading;
    SelectToken(token);
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
  Sheet: TSourceFileSheet;
  emptyLine, replaceLine: Boolean;
  str, LineStr, S, Ln: string;
  P: PChar;
  I, J, SpaceCount1, BracketBalacing: Integer;
  bStart, bEnd: TBufferCoord;
  prev_word: string;
  bCoord, posStyle: TBufferCoord;
  attri: THighlighStyle;
  token: UnicodeString;
  Key: Char;
begin
  Key := Char(Ch);
  if not GetActiveSheet(Sheet) then
    Exit;
  LastKeyPressed := Key;
  bCoord := Sheet.Editor.CaretXY;
  LineStr := Sheet.Editor.LineText;
  if (bCoord.Char > 1) and (Length(LineStr) >= bCoord.Char - 1) and
    CharInSet(LineStr[bCoord.Char - 1], ['a' .. 'z', 'A' .. 'Z', '_']) then
    prev_word := GetLastWord(Copy(LineStr, 1, bCoord.Char))
  else
    prev_word := '';
  posStyle := BufferCoord(bCoord.Char - 1, bCoord.Line);
  if CharInSet(Key, ['"', '<', '}']) then
    Sheet.Editor.Colourise(Sheet.Editor.GetEndStyled,
      Sheet.Editor.GetEndStyled + 1);
  if Sheet.Editor.GetHighlighterAttriAtRowCol(posStyle, token, attri) then
  begin
    if CppHighligher.IsComment(attri) then
      Exit;
    I := CountChar(LineStr, '"');
    if CharInSet(Key, ['"', '<']) and (attri.name = HL_Style_Preprocessor) and
      (Pos('include', LineStr) > 0) and
      not((I >= 2) and (CountChar(Copy(LineStr, bCoord.Char, MaxInt), '"') = 0))
    then
    begin
      if not CodeCompletion.Executing then
        CodeCompletion.ActivateCompletion(Sheet.Editor);
      Exit;
    end;
  end;
  // auto code completion
  if CharInSet(Key, ['a' .. 'z', 'A' .. 'Z', '_']) and (Length(prev_word) >= 4)
    and not CodeCompletion.Executing and
    ((FEmptyLineResult <> bCoord.Line) or (FEmptyCharResult > bCoord.Char)) then
  begin
    CodeCompletion.ActivateCompletion(Sheet.Editor);
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
  else if not CharInSet(Key, ['a' .. 'z', 'A' .. 'Z', '_']) or
    not(Length(prev_word) > 4) then
  begin
    FEmptyLineResult := 0;
    FEmptyCharResult := 0;
  end;
  if Key = '}' then
    Sheet.Editor.ProcessCloseBracketChar
  else if Key = #13 then
    Sheet.Editor.ProcessBreakLine
  else if Key = '(' then
  begin
    if Config.Editor.AutoCloseBrackets and
      (Sheet.Editor.GetBalancingBracketEx(Sheet.Editor.CaretXY, '(') < 0) then
    begin
      Sheet.Editor.InsertText(Sheet.Editor.GetCurrentPos, ')');
    end;
    TimerHintParams.Enabled := False;
    TimerHintParams.Enabled := True;
  end
  else if Key = '[' then
  begin
    if not Config.Editor.AutoCloseBrackets then
      Exit;
    if Sheet.Editor.GetBalancingBracketEx(Sheet.Editor.CaretXY, '[') >= 0 then
      Exit;
    Sheet.Editor.InsertText(Sheet.Editor.GetCurrentPos, ']');
  end
  else if Key = '{' then
  begin
    emptyLine := False;
    LineStr := '';
    J := 0;
    if Sheet.Editor.SelAvail then
    begin
      bStart := Sheet.Editor.BlockBegin;
      bEnd := Sheet.Editor.BlockEnd;
    end
    else
    begin
      bStart := Sheet.Editor.CaretXY;
      bEnd := bStart;
    end;
    if Sheet.Editor.Lines.Count >= bStart.Line then
    begin
      LineStr := Sheet.Editor.Lines.Strings[bStart.Line - 1];
      LineStr := Copy(LineStr, 1, bStart.Char - 1);
      P := PChar(LineStr);
      if P^ <> #0 then
        repeat
          if not CharInSet(P^, [#9, #32]) then
            Break;
          if P^ = #9 then
            Inc(J, Sheet.Editor.TabWidth)
          else
            Inc(J);
          Inc(P);
        until P^ = #0;
      emptyLine := Trim(LineStr) = '{';
    end;
    if emptyLine then
    begin
      replaceLine := False;
      SpaceCount1 := J;
      if Sheet.Editor.Lines.Count >= bStart.Line - 1 then
      begin
        LineStr := Sheet.Editor.Lines.Strings[bStart.Line - 2];
        P := PChar(LineStr);
        I := 0;
        if P^ <> #0 then
          repeat
            if not CharInSet(P^, [#9, #32]) then
              Break;
            if P^ = #9 then
              Inc(I, Sheet.Editor.TabWidth)
            else
              Inc(I);
            Inc(P);
          until P^ = #0;
        replaceLine := J <> I;
        SpaceCount1 := I;
      end;
      S := GetLeftSpacing(SpaceCount1, Sheet.Editor.TabWidth,
        Sheet.Editor.WantTabs);
      bStart.Char := 1;
      if Config.Editor.AutoCloseBrackets then
      begin
        str := '';
        if replaceLine then
          str := S;
        if replaceLine then
          Sheet.Editor.SetCaretAndSelection(bStart, bStart, bEnd);
        BracketBalacing := Sheet.Editor.GetBalancingBracketEx
          (Sheet.Editor.CaretXY, '{');
        Ln := Sheet.Editor.GetLineChars;
        str := str + IfThen(replaceLine, '{') + Ln + S +
          GetLeftSpacing(Sheet.Editor.TabWidth, Sheet.Editor.TabWidth,
          Sheet.Editor.WantTabs) + Ln + S + '}';
        Sheet.Editor.BeginUpdate;
        if BracketBalacing <= 0 then
          Sheet.Editor.SelText := str
        else
        begin
          I := Pos('{', str);
          Sheet.Editor.SelText := Copy(str, 1, I);
        end;
        Sheet.Editor.EndUpdate;
        Inc(bStart.Line);
        bStart.Char :=
          Length(GetLeftSpacing(SpaceCount1 + Sheet.Editor.TabWidth,
          Sheet.Editor.TabWidth, Sheet.Editor.WantTabs)) + 1;
        Sheet.Editor.CaretXY := bStart;
      end
      else
      begin
        Sheet.Editor.BeginUpdate;
        if replaceLine then
          Sheet.Editor.SetCaretAndSelection(bStart, bStart, bEnd)
        else
          S := '';
        Sheet.Editor.SelText := S + '{';
        Sheet.Editor.EndUpdate;
      end;
    end
    else if Config.Editor.AutoCloseBrackets then
    begin
      BracketBalacing := Sheet.Editor.GetBalancingBracketEx
        (Sheet.Editor.CaretXY, '{');
      if BracketBalacing < 0 then
        Sheet.Editor.InsertText(Sheet.Editor.GetCurrentPos, '}');
    end;
    TimerHintParams.Enabled := False;
    TimerHintParams.Enabled := True;
  end;
end;

procedure TFrmFalconMain.TextEditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Sheet: TSourceFileSheet;
  SaveKey: Word;
begin
  SaveKey := Key;
  CodeCompletion.EditorKeyDown(Sender, SaveKey, Shift);
  if (Key = VK_ESCAPE) and (SaveKey = 0) then
    Exit;
  Key := SaveKey;
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  Sheet := TSourceFileSheet(TComponent(Sender).Owner);
  if ([ssCtrl] = Shift) and (Key = Ord('J')) then
  begin
    AutoComplete.Execute(Sheet.Editor);
    // show parameters hit
  end
  else if ([ssShift, ssCtrl] = Shift) and (Key = VK_SPACE) then
  begin
    ShowHintParams(Sheet.Editor);
  end
  // move code up
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_UP) then
    Sheet.Editor.MoveSelectionUp
    // move code down
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_DOWN) then
    Sheet.Editor.MoveSelectionDown
    // fold current
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_OEM_5) then // ]
    Sheet.Editor.CollapseCurrent
    // unfold current
  else if ([ssCtrl, ssShift] = Shift) and (Key = VK_OEM_6) then // [
    Sheet.Editor.UncollapseLine(Sheet.Editor.CaretY)
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
    CodeCompletion.ActivateCompletion(Sheet.Editor);
    UsingCtrlSpace := False;
  end
  else if (Key = VK_ESCAPE) then
  begin
    HintTip.Cancel;
    DebugHint.Cancel;
    HintParams.Cancel;
  end;
end;

procedure TFrmFalconMain.TextEditorKeyPress(Sender: TObject; var Key: Char);
const
  Brackets: array [0 .. 5] of WideChar = ('(', ')', '[', ']', '{', '}');
var
  Sheet: TSourceFileSheet;
  LineStr: string;
  I: Integer;
  OpenChar: WideChar;
  Shift: TShiftState;
  BC: TBufferCoord;
begin
  CodeCompletion.EditorKeyPress(Sender, Key);
  Shift := KeyboardStateToShiftState;
  if not GetActiveSheet(Sheet) then
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
    if Sheet.Editor.Lines.Count >= Sheet.Editor.CaretY then
    begin
      I := Sheet.Editor.GetBalancingBracketEx(Sheet.Editor.CaretXY, OpenChar);
      if I < 0 then
        Exit;
      LineStr := Sheet.Editor.Lines.Strings[Sheet.Editor.CaretY - 1];
      LineStr := Copy(LineStr, Sheet.Editor.CaretX, Length(LineStr));
      if (LineStr <> '') and (LineStr[1] = Key) then
      begin
        Key := #0;
        BC := Sheet.Editor.CaretXY;
        Inc(BC.Char);
        Sheet.Editor.CaretXY := BC;
      end;
    end;
  end
  else if ([ssCtrl] = Shift) and (Key = ' ') then
    Key := #0;
end;

procedure TFrmFalconMain.TextEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Position: Integer;
  Sheet: TSourceFileSheet;
begin
  HintParams.Cancel;
  HintTip.Cancel;
  DebugHint.Cancel;
  if not GetActiveSheet(Sheet) then
    Exit;
    Position := Sheet.Editor.PositionFromPoint(X, Y);
  if (Button <> mbMiddle) or (Position < 0) then
    Exit;
  Sheet.Editor.SetEmptySelection(Position);
  Sheet.Editor.PasteFromClipboard;
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

procedure TFrmFalconMain.TextLinesDeleted(Sender: TObject;
  index, Count: Integer);
var
  LineBegin, LineEnd: Integer;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) or (Sheet.SourceFile.BreakPoint.Count = 0) then
    Exit;
  LineBegin := index + 1;
  LineEnd := index + Count;
  Sheet.SourceFile.BreakPoint.DeleteFrom(LineBegin, LineEnd);
end;

procedure TFrmFalconMain.TextLinesInserted(Sender: TObject;
  index, Count: Integer);
var
  LineBegin: Integer;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) or (Sheet.SourceFile.BreakPoint.Count = 0) then
    Exit;
  LineBegin := index + 1;
  Sheet.SourceFile.BreakPoint.MoveBy(LineBegin, Count);
end;

procedure TFrmFalconMain.TextEditorGutterClick(ASender: TObject;
  AModifiers: Integer; APosition: Integer; AMargin: Integer);
var
  Sheet: TSourceFileSheet;
  S: string;
  Line: Integer;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Line := Sheet.Editor.LineFromPosition(APosition) + 1;
  if (AMargin <> MARGIN_BREAKPOINT) and (AMargin <> MARGIN_LINE_NUMBER) then
    Exit;
  if (Sheet.Editor.Lines.Count >= Line) and (Line > 0) then
  begin
    S := Sheet.Editor.Lines.Strings[Line - 1];
    if not HasTODO(S) then
      ToggleBreakpoint(Line);
  end;
end;

procedure TFrmFalconMain.TextEditorSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  if ActiveErrorLine = Line then
  begin
    FG := clWindow;
    BG := clRed;
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
    if not Sheet.Editor.Focused and Sheet.Editor.Visible then
      Sheet.Editor.SetFocus;
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
  FFilesParsed.Free;
  ParseAllFiles.Free;
  fWorkerThread.Free;
  //clang_disposeIndex(ClangIndex);
  FTemplates.Free;
  FConfig.Free;
  FCompilerSettings.Free;
  FSintaxList.Free;
  FreeExecResources;
end;

procedure TFrmFalconMain.ViewItemClick(Sender: TObject);
begin
  case TSpTBXItem(Sender).Tag of
    0:
      ProjectPanel.Visible := TSpTBXItem(Sender).Checked;
    1:
      StatusBar.Visible := TSpTBXItem(Sender).Checked;
    2:
      begin
        PanelOutline.Visible := TSpTBXItem(Sender).Checked and
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
  SelFile: TSourceBase;
  SourceConfig: TSourceBase;
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
  if (TControl(Sender).Tag in [7, 8]) then
  begin
    if not GetActiveSource(SelFile) then
      SelFile := nil;
  end
  else if not GetSelectedFileInList(SelFile) then
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
    2:
      TSourceFile(NewSourceFile(FILE_TYPE_C, COMPILER_C, 'main' + '.c', STR_FRM_MAIN[13],
        '.c', '', SelFile, False, True)).Edit.Editor.SetSavePoint;
    3:
      TSourceFile(NewSourceFile(FILE_TYPE_CPP, COMPILER_CPP, 'main' + '.cpp',
        STR_FRM_MAIN[13], '.cpp', '', SelFile, False, True))
        .Edit.Editor.SetSavePoint;
    4:
      TSourceFile(NewSourceFile(FILE_TYPE_H, NO_COMPILER, 'main' + '.h', STR_FRM_MAIN[13],
        '.h', '', SelFile, False, True)).Edit.Editor.SetSavePoint;
    5:
      TSourceFile(NewSourceFile(FILE_TYPE_RC, COMPILER_RC, STR_FRM_MAIN[16] + '.rc',
        STR_FRM_MAIN[13], '.rc', '', SelFile, False, True))
        .Edit.Editor.SetSavePoint;
    6:
      TSourceFile(NewSourceFile(FILE_TYPE_UNKNOW, CompilerType, 'main', STR_FRM_MAIN[13],
        '', '', SelFile, False, True)).Edit.Editor.SetSavePoint;
    7:
      NewSourceFile(FILE_TYPE_FOLDER, NO_COMPILER, STR_NEW_MENU[8],
        STR_FRM_MAIN[14], '', '', SelFile, True, False);
    8:
    begin
      SourceConfig := NewSourceFile(FILE_TYPE_CONFIG, NO_COMPILER,
        SelFile.Project.Configurations.AvailableName,
        SelFile.Project.Configurations.AvailableName, '', '', SelFile, True, True);
      SourceConfig.Project.ConfigurationIndex := SourceConfig.Node.Index;
    end;
  else
    TSourceFile(NewSourceFile(FileType, CompilerType, 'main' + Ext, STR_FRM_MAIN[13], Ext,
      '', SelFile, False, True)).Edit.Editor.SetSavePoint;
  end;
  if (SelFile <> nil) and (SelFile.FileType = FILE_TYPE_PROJECT) then
    SelFile.Project.PropertyChanged := True;
  if TControl(Sender).Tag <> 1 then
    UpdateMenuItems([rmFile, rmFileNew, rmEdit, rmSearch, rmProject, rmRun,
      rmProjectsPopup]);
end;

procedure TFrmFalconMain.TViewToolbarClick(Sender: TObject);
begin
  case TSpTBXItem(Sender).Tag of
    0:
      DefaultBar.Visible := TSpTBXItem(Sender).Checked;
    1:
      EditBar.Visible := TSpTBXItem(Sender).Checked;
    2:
      SearchBar.Visible := TSpTBXItem(Sender).Checked;
    3:
      CompilerBar.Visible := TSpTBXItem(Sender).Checked;
    4:
      NavigatorBar.Visible := TSpTBXItem(Sender).Checked;
    5:
      ProjectBar.Visible := TSpTBXItem(Sender).Checked;
    6:
      HelpBar.Visible := TSpTBXItem(Sender).Checked;
    7:
      DebugBar.Visible := TSpTBXItem(Sender).Checked;
  end;
end;

function TFrmFalconMain.ImportDevCppProject(const FileName: string;
  var ProjectBase: TProjectBase): Boolean;
const
  DevType: array [0 .. 3] of Integer = (APPTYPE_GUI, APPTYPE_CONSOLE,
    APPTYPE_LIB, APPTYPE_DLL);
var
  ini: TIniFile;
  Node: TTreeNode;
  NewPrj: TProjectBase;
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
  Node.Text := NewPrj.name;
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
    APPTYPE_GUI:
      NewPrj.Libs := '-mwindows ' + NewPrj.Libs;
    APPTYPE_DLL:
      NewPrj.Libs := '-shared -Wl,--add-stdcall-alias ' + NewPrj.Libs;
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
  NewPrj.IncludeVersionInfo := ini.ReadBool('Project',
    'IncludeVersionInfo', False);
  NewPrj.Version.Version.Major := ini.ReadInteger('VersionInfo', 'Major', 0);
  NewPrj.Version.Version.Minor := ini.ReadInteger('VersionInfo', 'Minor', 0);
  NewPrj.Version.Version.Release := ini.ReadInteger('VersionInfo', 'Release', 0);
  NewPrj.Version.Version.Build := ini.ReadInteger('VersionInfo', 'Build', 0);
  NewPrj.Version.LanguageID := ini.ReadInteger('VersionInfo',
    'LanguageID', 1033);
  NewPrj.Version.CharsetID := ini.ReadInteger('VersionInfo', 'CharsetID', 1252);
  NewPrj.Version.CompanyName := ini.ReadString('VersionInfo',
    'CompanyName', '');
  NewPrj.Version.FileVersion := ini.ReadString('VersionInfo',
    'FileVersion', '');
  NewPrj.Version.FileDescription := ini.ReadString('VersionInfo',
    'FileDescription', '');
  NewPrj.Version.InternalName := ini.ReadString('VersionInfo',
    'InternalName', '');
  NewPrj.Version.LegalCopyright := ini.ReadString('VersionInfo',
    'LegalCopyright', '');
  NewPrj.Version.OriginalFilename := ini.ReadString('VersionInfo',
    'OriginalFilename', '');
  NewPrj.Version.ProductName := ini.ReadString('VersionInfo',
    'ProductName', '');
  NewPrj.Version.ProductVersion := ini.ReadString('VersionInfo',
    'ProductVersion', '');
  NewPrj.AutoIncBuild := ini.ReadBool('VersionInfo', 'AutoIncBuildNr', False);
  UnitCount := ini.ReadInteger('Project', 'UnitCount', 0);
  Edited := False;
  for I := 1 to UnitCount do
  begin
    SourceFileName := ini.ReadString('Unit' + IntToStr(I), 'FileName', '');
    NewFile := TSourceFile(NewSourceFile(GetFileType(SourceFileName),
      GetCompiler(GetFileType(SourceFileName)), SourceFileName,
      RemoveFileExt(SourceFileName), ExtractFileExt(SourceFileName), '', NewPrj,
      False, False));
    if FileExists(NewFile.FileName) then
    begin
      NewFile.DateOfFile := FileDateTime(NewFile.FileName);
      NewFile.Saved := True;
      if SameText(NewFile.name, 'main.c') or SameText(NewFile.name, 'main.cpp')
      then
      begin
        NewFile.Edit;
        Edited := True;
      end;
    end;
  end;
  if not Edited then
    NewPrj.Node.Selected := True;
  ini.Free;
  ProjectBase := NewPrj;
  Result := True;
end;

function TFrmFalconMain.ImportCodeBlocksProject(const FileName: string;
  var ProjectBase: TProjectBase): Boolean;

  function GetAttribute(Node: IXMLNode; Attribute: string;
    default: string = ''): string;
  begin
    if (Node <> nil) and Node.HasAttribute(Attribute) then
      Result := Node.Attributes[Attribute]
    else
      Result := default;
  end;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string;
    default: string = ''): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := GetAttribute(Temp, Attribute, default)
    else
      Result := default;
  end;

  procedure LoadFiles(XMLNode: IXMLNode; Parent: TSourceFile);
  var
    XMLDoc: TXMLDocument;
    Temp, LytRoot, FileNode: IXMLNode;
    STemp, StrProp, LytFileName, RootPath: string;
    SourceFile, TopFile: TSourceFile;
    CaretXY: TBufferCoord;
    Sheet: TSourceFileSheet;
    TopLine, SelStart, I, CompilerType: Integer;
    List: TStringList;
    FromStart: Boolean;
  begin
    TopFile := nil;
    // XMLDoc := nil;
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
        continue;
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
      SourceFile := TSourceFile(List.Objects[I]);
      STemp := SourceFile.FileName;
      FromStart := True;
      FileNode := LytRoot.ChildNodes.First;
      while FileNode <> nil do
      begin
        if FileNode.NodeName <> 'File' then
        begin
          FileNode := FileNode.NextSibling;
          continue;
        end;
        LytFileName := ExpandFileName(RootPath + GetAttribute(FileNode,
          'name'));
        if SameText(LytFileName, SourceFile.FileName) then
        begin
          StrProp := GetAttribute(FileNode, 'top');
          if StrProp = '1' then
            TopFile := SourceFile;
          SelStart := StrToInt(GetTagProperty(FileNode, 'Cursor',
            'position', '0'));
          TopLine := StrToInt(GetTagProperty(FileNode, 'Cursor', 'topLine',
            '0')) + 1;
          StrProp := GetAttribute(FileNode, 'open');
          if StrProp = '1' then
          begin
            Sheet := SourceFile.Edit;
            CaretXY := Sheet.Editor.CharIndexToRowCol(SelStart);
            Sheet.Editor.CaretXY := CaretXY;
            Sheet.Editor.TopLine := TopLine;
          end;
          if I + 1 >= List.Count then
            Break;
          Inc(I);
          FromStart := False;
          SourceFile := TSourceFile(List.Objects[I]);
          STemp := SourceFile.FileName;
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
  NewPrj: TProjectBase;
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
  // main tag
  ProjNode := XMLDoc.ChildNodes.FindNode('CodeBlocks_project_file');
  if (ProjNode = nil) then
  begin
    // XMLDoc.Free;
    Exit;
  end;
  Major := StrToInt(GetTagProperty(ProjNode, 'FileVersion', 'major', '0'));
  Minor := StrToInt(GetTagProperty(ProjNode, 'FileVersion', 'minor', '0'));
  if (Major <> 1) or (Minor <> 6) then
  begin
    // XMLDoc.Free;
    Exit;
  end;
  // Project tag
  ProjNode := ProjNode.ChildNodes.FindNode('Project');
  if (ProjNode = nil) then
  begin
    // XMLDoc.Free;
    Exit;
  end;
  NewPrj := CreateProject('', FILE_TYPE_PROJECT);
  Node := NewPrj.Node;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  NewPrj.CompilerType := COMPILER_C;
  Node.Text := NewPrj.name;
  Node.Selected := True;
  Node.Focused := True;
  BuildNode := ProjNode.ChildNodes.FindNode('Build');
  if (BuildNode = nil) then
  begin
    // XMLDoc.Free;
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
      continue;
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
            NewPrj.CompilerOptions :=
              Trim(NewPrj.CompilerOptions + ' ' + TempStr)
          else if TempStr = '-O2' then
            NewPrj.CompilerOptions :=
              Trim(NewPrj.CompilerOptions + ' ' + TempStr)
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
              NewPrj.CompilerOptions :=
                Trim(NewPrj.CompilerOptions + ' ' + TempStr)
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
  end; // end build childs
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
      APPTYPE_DLL:
        NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.dll';
      APPTYPE_LIB:
        NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.a';
    else
      NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.exe';
    end;
  end;
  if createStaticLib then
    NewPrj.Libs := Trim(NewPrj.Libs + ' ' + FormatLibrary(NewPrj.Target));
  if createDefFile then
  begin
    // not implemented
  end;
  LoadFiles(ProjNode, NewPrj);
  // XMLDoc.Free;
  ProjectBase := NewPrj;
  Result := True;
end;

function TFrmFalconMain.ImportMSVCProject(const FileName: string;
  var ProjectBase: TProjectBase): Boolean;

  function GetAttribute(Node: IXMLNode; Attribute: string;
    default: string = ''): string;
  begin
    if (Node <> nil) and Node.HasAttribute(Attribute) then
      Result := Node.Attributes[Attribute]
    else
      Result := default;
  end;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string;
    default: string = ''): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) and Temp.HasAttribute(Attribute) then
      Result := GetAttribute(Temp, Attribute, default)
    else
      Result := default;
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
        continue;
      end;
      if TempNode.NodeName <> 'File' then
      begin
        TempNode := TempNode.NextSibling;
        continue;
      end;
      ProjectPath := ExtractFilePath(FileName);
      RelativePath := GetAttribute(TempNode, 'RelativePath');
      if not(GetFileType(RelativePath) in [FILE_TYPE_C, FILE_TYPE_CPP,
        FILE_TYPE_H, FILE_TYPE_RC]) or not FileExists(ProjectPath + RelativePath)
      then
      begin
        TempNode := TempNode.NextSibling;
        continue;
      end;
      FileList.Add(RelativePath);
      TempNode := TempNode.NextSibling;
    end;
  end;

var
  XMLDoc: TXMLDocument;
  ProjNode, ConfigNode, FilesNode, TempNode: IXMLNode;
  Node: TTreeNode;
  NewPrj: TProjectBase;
  I, J, ConfigurationType: Integer;
  TempStr, ProjectType, ProjectVersion, OutputDirectory, Flags, Libs, TempName,
    OutputFile: string;
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
  // main tag
  ProjNode := XMLDoc.ChildNodes.FindNode('VisualStudioProject');
  if (ProjNode = nil) then
  begin
    // XMLDoc.Free;
    Exit;
  end;
  ProjectType := GetAttribute(ProjNode, 'ProjectType');
  ProjectVersion := GetAttribute(ProjNode, 'Version');
  Version := ParseVersion(ProjectVersion);
  if (ProjectType <> 'Visual C++') or
    not((CompareVersion(Version, ParseVersion('7.10.0.0')) >= 0) and
    (CompareVersion(Version, ParseVersion('9.00.0.0')) <= 0)) then
  begin
    // XMLDoc.Free;
    Exit;
  end;
  // Configurations tag
  ConfigNode := ProjNode.ChildNodes.FindNode('Configurations');
  if ConfigNode = nil then
  begin
    // XMLDoc.Free;
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
      if (Pos('DEBUG', UpperCase(GetAttribute(TempNode, 'Name'))) = 0) and
        (I < 0) then
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
    // XMLDoc.Free;
    Exit;
  end;
  OutputDirectory := GetAttribute(ConfigNode, 'OutputDirectory');
  ConfigurationType := StrToInt(GetAttribute(ConfigNode,
    'ConfigurationType', '0'));
  NewPrj := CreateProject('', FILE_TYPE_PROJECT);
  Node := NewPrj.Node;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  NewPrj.CompilerType := COMPILER_CPP;
  Node.Text := NewPrj.name;
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
            continue;
          List.Strings[I] := TempName;
        end
        else
          continue;
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
    if (TempNode.NodeName = 'Tool') and
      (GetAttribute(TempNode, 'Name') = TempStr) then
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
      if not DirectoryExists(ExtractFilePath(FileName) +
        ExtractFileName(OutputFile)) then
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
      APPTYPE_DLL:
        NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.dll';
      APPTYPE_LIB:
        NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.a';
    else
      NewPrj.Target := RemoveFileExt(NewPrj.Target) + '.exe';
    end;
  end;
  if createStaticLib then
    NewPrj.Libs := Trim(NewPrj.Libs + ' ' + FormatLibrary(NewPrj.Target));
  if createDefFile then
  begin
    // not implemented
  end;
  FilesNode := ProjNode.ChildNodes.FindNode('Files');
  if (FilesNode <> nil) then
  begin
    List := TStringList.Create;
    LoadFiles(FilesNode, List);
    AddFilesToProject(List, NewPrj, True, True);
    List.Free;
  end;
  // XMLDoc.Free;
  ProjectBase := NewPrj;
  Result := True;
end;

procedure TFrmFalconMain.ImportFromDevCpp(Sender: TObject);
var
  ProjectBase: TProjectBase;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := Format(STR_FRM_MAIN[48], ['Dev-C++']) + '(*.dev)|*.dev';
    Options := Options + [ofFileMustExist];
    if Execute(Self.Handle) then
    begin
      if not ImportDevCppProject(FileName, ProjectBase) then
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[47], ['Dev-C++'])),
          'Falcon C++', MB_ICONEXCLAMATION)
      else
        ParseProjectFiles(ProjectBase);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ImportFromCodeBlocks(Sender: TObject);
var
  ProjectBase: TProjectBase;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := Format(STR_FRM_MAIN[48], ['Code::Blocks']) + '(*.cbp)|*.cbp';
    Options := Options + [ofFileMustExist];
    if Execute(Self.Handle) then
    begin
      if not ImportCodeBlocksProject(FileName, ProjectBase) then
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[47], ['Code::Blocks'])),
          'Falcon C++', MB_ICONEXCLAMATION)
      else
        ParseProjectFiles(ProjectBase);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ImportFromMSVC(Sender: TObject);
var
  ProjectBase: TProjectBase;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := Format(STR_FRM_MAIN[48], ['MS Visual C++']) +
      '(*.vcproj)|*.vcproj';
    Options := Options + [ofFileMustExist];
    if Execute(Self.Handle) then
    begin
      if not ImportMSVCProject(FileName, ProjectBase) then
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[47], ['MS Visual C++'])),
          'Falcon C++', MB_ICONEXCLAMATION)
      else
        ParseProjectFiles(ProjectBase);
    end;
    Free;
  end;
end;

// text change parse delay

procedure TFrmFalconMain.TimerChangeDelayTimer(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.SourceFile.TranslateUnit;
  TParserThread(fWorkerThread).SetModified;
  TimerChangeDelay.Enabled := False;
end;

procedure TFrmFalconMain.ToolbarCheck(const index: Integer;
  const Value: Boolean);
begin
  ViewToolbar.Items[index].Checked := Value;
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
  SourceFile: TSourceFile;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveFile1(SourceFile) then
    Exit;
  if not SourceFile.GetSheet(Sheet) then
    Exit;
  if TSpTBXItem(Sender).Checked then // set bookmark
  begin
    TSpTBXItem(EditGotoBookmarks.Items[TSpTBXItem(Sender).Tag - 1]).Checked := True;
    TSpTBXItem(EditGotoBookmarks.Items[TSpTBXItem(Sender).Tag - 1]).Enabled := True;
    Sheet.Editor.SetBookMark(TSpTBXItem(Sender).Tag, Sheet.Editor.DisplayX,
      Sheet.Editor.DisplayY);
  end
  else
  begin // delete bookmark
    TSpTBXItem(EditGotoBookmarks.Items[TSpTBXItem(Sender).Tag - 1]).Checked
      := False;
    TSpTBXItem(EditGotoBookmarks.Items[TSpTBXItem(Sender).Tag - 1]).Enabled
      := False;
    Sheet.Editor.ClearBookMark(TSpTBXItem(Sender).Tag);
  end;
end;

procedure TFrmFalconMain.DropFilesIntoProjectList(List: TStrings;
  X, Y: Integer);
var
  AnItem: TTreeNode;
  SelFile, ExisFile: TSourceFile;
  ProjectBase: TProjectBase;
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
    if SameText(ExtractFileExt(List.Strings[I]), '.dev') then
      ImportDevCppProject(List.Strings[I], ProjectBase)
    else if SameText(ExtractFileExt(List.Strings[I]), '.cbp') then
      ImportCodeBlocksProject(List.Strings[I], ProjectBase)
    else if SameText(ExtractFileExt(List.Strings[I]), '.vcproj') then
      ImportMSVCProject(List.Strings[I], ProjectBase)
    else
    begin
      if Assigned(AnItem) then
      begin
        if not(TSourceFile(AnItem.Data).FileType in [FILE_TYPE_PROJECT,
          FILE_TYPE_FOLDER]) then
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
          ProjectBase := OpenFile(List.Strings[I]);
          AddFileToHistory(List.Strings[I]);
          if ProjectBase.FileType <> FILE_TYPE_PROJECT then
          begin
            SrcList.AddObject(ProjectBase.FileName, ProjectBase);
            { TODO 1 -oMazin -c : Editing Folder 24/08/2012 22:21:01 }
            ProjectBase.Edit;
          end
          else
            ProjectBase.GetSources(SrcList, SOURCE_TYPES);
        end;
      end
      else
      begin
        AddedList.Clear;
        AddedList.Add(List.Strings[I]);
        References := True;
        if not SameText(ExtractFileDrive(SelFile.FileName),
          ExtractFileDrive(List.Strings[I])) then
        begin
          References := False;
        end;
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
  SourceFile: TSourceFile;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveFile1(SourceFile) then
    Exit;
  if not SourceFile.GetSheet(Sheet) then
    Exit;
  if TSpTBXItem(Sender).Checked then
    Sheet.Editor.GotoBookMark(TSpTBXItem(Sender).Tag);
end;

function TFrmFalconMain.FindLastNode(Skip: TTreeNode): TTreeNode;
var
  Node: TTreeNode;
begin
  Result := nil;
  Node := TreeViewProjects.Items.GetFirstNode;
  while Node <> nil do
  begin
    if Node <> Skip then
      Result := Node;
    Node := Node.getNextSibling;
  end;
end;

function TFrmFalconMain.InitDragDropSource(TreeSrc, TreeDst: TTreeView;
  var ItemSrc, ItemDst: TTreeNode; var SourceSrc, SourceDst: TSourceBase;
  var AttachMode: TNodeAttachMode; X, Y: Integer; Drop: Boolean): Boolean;
var
  SourceGroup: TSourceConfigGroup;
begin
  Result := False;
  ItemSrc := TreeSrc.Selected;
  ItemDst := TreeDst.DropTarget;
  if (ItemDst <> nil) and (TreeDst.GetNodeAt(X, Y) = nil) then
    Exit;
  if (ItemSrc = nil) or (ItemDst = ItemSrc) then
    Exit;
  SourceSrc := TSourceBase(ItemSrc.Data);
  SourceDst := nil;
  if ItemDst <> nil then
    SourceDst := TSourceBase(ItemDst.Data);
  if SourceSrc.FileType = FILE_TYPE_CONFIG_GROUP then
    Exit;
  if (ItemDst = nil) then
  begin
    AttachMode := naAdd;
    ItemDst := FindLastNode(ItemSrc);
    Result := (ItemDst <> nil) and not (SourceSrc.FileType in NON_FILE_TYPES)
      and not (SourceSrc is TProjectBase);
    Exit;
  end;
  // skip folder or group as project
  if (SourceDst is TProjectSource) and (SourceSrc.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_CONFIG_GROUP]) then
    Exit;
  if not (SourceDst is TProjectBase) and (SourceSrc is TProjectFile) then
    Exit;
  if (SourceSrc is TSourcePhysical) and (SourceDst is TSourceProperty) then
    Exit;
  if not (SourceDst is TProjectBase) and not (SourceDst is TSourceProperty) and
    (SourceSrc is TSourceConfiguration) then
    Exit;
  if (SourceSrc is TSourceFolder) and
    TSourceFolder(SourceSrc).IsParentOf(ExtractFilePath(SourceDst.FileName)) then
    Exit;
  Result := True;
  // physical source(not folder) over project source
  if ((SourceSrc is TSourcePhysical) and (SourceDst is TProjectSource)) or
    (SourceSrc is TProjectFile) then
  begin
    SourceDst := nil;
    AttachMode := naInsert;
    Exit;
  end;
  if (SourceDst is TSourceFile) and not (SourceDst is TProjectFile) and
    not (SourceSrc is TSourceProperty) then
  begin
    SourceDst := SourceDst.Parent;
    AttachMode := naInsert;
    Exit;
  end;
  SourceGroup := SourceDst.Project.ConfigurationGroup;
  if (SourceDst is TProjectFile) and (SourceSrc is TSourcePhysical)
    and (SourceGroup <> nil) then
  begin
    ItemDst := SourceGroup.Node.Parent;
    AttachMode := naAddChild;
    if SourceGroup.Node.getNextSibling = nil then
      Exit;
    ItemDst := SourceGroup.Node.getNextSibling;
    AttachMode := naInsert;
    Exit;
  end;
  AttachMode := naAddChildFirst;
  // Configuration over project or config group
  if not (SourceSrc is TSourceConfiguration) or not Drop then
    Exit;
  if SourceGroup = nil then
    SourceGroup := CreateConfigGroup(STR_NEW_MENU[9], SourceDst.Project.Node);
  SourceDst := SourceGroup;
  if not (SourceDst is TSourceConfiguration) then
    ItemDst := SourceGroup.Node
  else
    AttachMode := naInsert;
end;

procedure TFrmFalconMain.TreeViewProjectsDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  ItemSrc, ItemDst: TTreeNode;
  SourceSrc, SourceDst: TSourceBase;
  AttachMode: TNodeAttachMode;
  OldIndex: Integer;
begin
  if not InitDragDropSource(TTreeView(Source), TTreeView(Sender), ItemSrc,
    ItemDst, SourceSrc, SourceDst, AttachMode, X, Y, True) then
    Exit;
  if SourceDst <> nil then
  begin
    SourceDst.Project.PropertyChanged := True;
    SourceDst.Project.CompilePropertyChanged := True;
    if SourceSrc.Saved then
    begin
      if SourceDst is TProjectBase then
      begin
        if SourceSrc is TSourcePhysical then
          TSourcePhysical(SourceSrc).MoveTo(ExtractFilePath(SourceDst.FileName));
      end
      else if SourceDst is TSourceFolder then
      begin
        SourceDst.Save;
        if SourceSrc is TSourcePhysical then
          TSourcePhysical(SourceSrc).MoveTo(SourceDst.FileName);
      end;
    end;
  end;
  OldIndex := ItemSrc.Index;
  ItemSrc.MoveTo(ItemDst, AttachMode);
  if (SourceSrc is TSourceConfiguration) and (SourceSrc.Project = SourceDst.Project) then
    TSourceConfiguration(SourceDst).Move(ItemSrc.Index - OldIndex);
  // convert TSourceFile to TProjectSource
  if not (SourceSrc is TProjectBase) and (SourceDst = nil) then
    ItemSrc.Data := TProjectBase(SourceSrc).ConvertToProjectSource
  // convert TProjectSource to TSourceFile
  else if (SourceSrc is TProjectSource) and (SourceDst <> nil) then
    ItemSrc.Data := TProjectSource(SourceSrc).ConvertToSourceFile(SourceDst.Project);
  if (SourceDst <> nil) or (SourceSrc <> ItemSrc.Data) then
  begin
    SourceSrc.Project.PropertyChanged := True;
    SourceSrc.Project.CompilePropertyChanged := True;
  end;
  SourceSrc := TSourceBase(ItemSrc.Data); // update variable
  if (SourceDst <> nil) and (SourceSrc.Project <> SourceDst.Project) and not (SourceSrc is TProjectBase) then
    SourceSrc.AdjustProject(SourceDst.Project);
  BoldTreeNode(SourceSrc.Project.Node, True);
  FLastPathInclude := '';
end;

procedure TFrmFalconMain.TreeViewProjectsDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  ItemSrc, ItemDst: TTreeNode;
  SourceSrc, SourceDst: TSourceBase;
  AttachMode: TNodeAttachMode;
begin
  Accept := InitDragDropSource(TTreeView(Source), TTreeView(Sender), ItemSrc,
    ItemDst, SourceSrc, SourceDst, AttachMode, X, Y, False);
end;

// enter focus on popup menu

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

procedure TFrmFalconMain.EditorContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Sheet: TSourceFileSheet;
  dc: TDisplayCoord;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  dc := Sheet.Editor.PixelsToRowColumn(MousePos.X, MousePos.Y);
  if (dc.Column = 0) or (dc.Row = 0) or
    (Sheet.Editor.SelAvail and Sheet.Editor.IsPointInSelection
    (Sheet.Editor.DisplayToBufferPos(dc))) or
    ((MousePos.X = -1) and (MousePos.Y = -1)) then
    Exit;
  Sheet.Editor.SetFocus;
  EditorGotoXY(Sheet.Editor, dc.Column, dc.Row);
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

procedure TFrmFalconMain.GotoLineAndAlignCenter(Editor: TEditor;
  Line, Col, EndCol: Integer; CursorEnd: Boolean);
var
  BS, BE: TBufferCoord;
  TopLine: Integer;
begin
  Editor.SetFocus;
  TopLine := Line - (Editor.LinesInWindow div 2);
  if TopLine <= 0 then
    TopLine := 1;
  Editor.TopLine := TopLine;
  if Col < EndCol then
  begin
    BS.Line := Line;
    BS.Char := Col;
    BE.Line := Line;
    BE.Char := EndCol;
    if CursorEnd then
      Editor.SetCaretAndSelection(BE, BS, BE)
    else
      Editor.SetCaretAndSelection(BS, BS, BE);
  end
  else
  begin
    Editor.CaretXY := BufferCoord(Col, Line);
  end;
end;

procedure TFrmFalconMain.SelectToken(token: TTokenClass);
var
  Sheet: TSourceFileSheet;
  TopLine, StartPosition, EndPosition: Integer;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  StartPosition := Sheet.Editor.PositionRelative(0, token.SelStart);
  EndPosition := Sheet.Editor.PositionRelative(StartPosition, token.SelLength);
  Sheet.Editor.EnsureRangeVisible(StartPosition, EndPosition);
  Sheet.Editor.SetEmptySelection(StartPosition);
  Sheet.Editor.SetSelectionStart(StartPosition);
  Sheet.Editor.SetSelectionEnd(EndPosition);
  Sheet.Editor.SetFocus;
  TopLine := (Sheet.Editor.LineFromPosition(StartPosition) + 1) -
    (Sheet.Editor.LinesInWindow div 2);
  if TopLine <= 0 then
    TopLine := 1;
  Sheet.Editor.TopLine := TopLine;
end;

procedure TFrmFalconMain.RestoreOutline;
var
  Sheet: TSourceFileSheet;
  FindedTokenFile: TTokenFile;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  FindedTokenFile := FilesParsed.Find(Sheet.SourceFile.FileName);
  if FindedTokenFile <> nil then
    UpdateActiveFileToken(FindedTokenFile);
end;

procedure TFrmFalconMain.UpdateActiveFileToken(NewTokenFile: TTokenFile;
  Reload: Boolean);

  procedure FillTokenList(var Sibling, Parent: PVirtualNode;
    TokenList: TTokenClass; TokenType: TTkType; static, DeleteNext: Boolean);
  var
    NodeObject: TNodeObject;
  begin
    Parent := nil;
    if ((TokenList.Count > 25) and not static) or
      (static and (TokenList.Count > 0)) then
    begin
      NodeObject := TNodeObject.Create;
      NodeObject.Data := TokenList;
      NodeObject.Caption := TokenList.name;
      Parent := TreeViewOutline.InsertNode(Sibling, amInsertAfter, NodeObject);
      TokenList.Data := Parent;
      NodeObject.ImageIndex := GetTokenImageIndex(TokenList, OutlineImages);
    end;
    if not static then
      FillTreeView(Parent, TokenList)
    else if Assigned(Parent) then
      FillTreeView(Parent, TokenList);
  end;

  procedure ReloadTreeView(var Sibling, Parent: PVirtualNode);
  begin
    Sibling := TreeViewOutline.GetFirst;
    FillTokenList(Sibling, Parent, ActiveEditingFile.Includes, tkIncludeList,
      True, False);
    FillTokenList(Sibling, Parent, ActiveEditingFile.Defines, tkDefineList,
      True, False);
    if ActiveEditingFile.TreeObjs.Count > 25 then
    begin
      FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs, tkTreeObjList,
        False, False);
      if (ActiveEditingFile.VarConsts.Count > 25) or
        (ActiveEditingFile.FuncObjs.Count <= 25) then
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts,
          tkVarConsList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs,
          tkFuncProList, False, True);
      end
      else
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs,
          tkFuncProList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts,
          tkVarConsList, False, True);
      end;
    end
    else
    begin
      if (ActiveEditingFile.VarConsts.Count > 25) or
        (ActiveEditingFile.FuncObjs.Count <= 25) then
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts,
          tkVarConsList, False, False);
        if (ActiveEditingFile.FuncObjs.Count > 25) then
        begin
          FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs,
            tkFuncProList, False, False);
          FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs,
            tkTreeObjList, False, True);
        end
        else
        begin
          FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs,
            tkTreeObjList, False, False);
          FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs,
            tkFuncProList, False, True);
        end;
      end
      else
      begin
        FillTokenList(Sibling, Parent, ActiveEditingFile.FuncObjs,
          tkFuncProList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.TreeObjs,
          tkTreeObjList, False, False);
        FillTokenList(Sibling, Parent, ActiveEditingFile.VarConsts,
          tkVarConsList, False, True);
      end;
    end;
  end;

var
  TokenFileItem, FindedTokenFile: TTokenFile;
  Sheet: TSourceFileSheet;
  Sibling, Parent: PVirtualNode;
begin
  FindedTokenFile := FilesParsed.Find(NewTokenFile.FileName);
  if FindedTokenFile = nil then // not parsed
  begin
    TokenFileItem := TTokenFile.Create(FilesParsed);
    TokenFileItem.Assign(NewTokenFile);
  end
  else
  begin
    TokenFileItem := FindedTokenFile;
    if Reload then
      TokenFileItem.Assign(NewTokenFile);
  end;
  if FindedTokenFile = nil then
    FilesParsed.Add(TokenFileItem);
  if IsLoading then
  begin
    Inc(FTriggerOnLoading);
    Exit;
  end;
  ActiveEditingFile.Assign(TokenFileItem);
  if DebugReader.Running then
    Exit;
  if ViewOutline.Checked then
  begin
    TreeViewOutline.BeginUpdate;
    TreeViewOutline.Clear;
    ReloadTreeView(Sibling, Parent);
    TreeViewOutline.EndUpdate;
  end;
  if GetActiveSheet(Sheet) then
    DetectScope(Sheet.Editor, ActiveEditingFile, True);
end;

// hint functions

procedure TFrmFalconMain.ShowHintParams(Editor: TEditor);
var
  S: UnicodeString;
  Params, Fields, Input, SaveInput, SaveFields: string;
  token, tokenParams, scope: TTokenClass;
  InputError, InQuote: Boolean;
  QuoteChar: Char;
  attri: THighlighStyle;
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
  BC := Editor.CaretXY;
  if BC.Line > 0 then
  begin
    LineLen := Length(Editor.Lines.Strings[BC.Line - 1]);
    if LineLen < BC.Char - 1 then
      BC.Char := LineLen + 1;
  end;
  SelStart := Editor.RowColToCharIndex(BC);
  QuoteChar := #0;
  if Editor.GetHighlighterAttriAtRowCol(BC, S, attri) then
  begin
    if StringIn(attri.name, [HL_Style_Preprocessor]) then
    begin
      HintParams.Cancel;
      Exit;
    end;
    if (attri.name = HL_Style_String) then
      QuoteChar := '"'
    else if (attri.name = HL_Style_Character) then
      QuoteChar := '''';
    if QuoteChar <> #0 then
    begin
      Dec(BC.Char);
      InQuote := True;
      if Editor.GetHighlighterAttriAtRowCol(BC, S, attri) then
      begin
        if (attri.name = HL_Style_String) then
          QuoteChar := '"'
        else if (attri.name = HL_Style_Character) then
          QuoteChar := ''''
        else
          InQuote := False;
      end;
      if not InQuote then
      begin
        Inc(BC.Char, 2);
        SelStart := Editor.RowColToCharIndex(BC);
      end;
    end;
  end;
  BracketStart := SelStart;
  { TODO -oMazin -c : Remove use of Editor.Text 04/05/2013 22:11:00 }
  TempText := Editor.Lines.Text;
  ShowStructParams := False;
  if not GetFirstOpenParentheses(TempText, QuoteChar, BracketStart) then
  begin
    if not GetFirstOpenBracket(TempText, QuoteChar, BracketStart, SelStart,
      StructParams) then
    begin
      HintParams.Cancel;
      Exit;
    end
    else
      ShowStructParams := True;
  end;
  BufferCoordStart := Editor.CharIndexToRowCol(BracketStart);
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
    if not FilesParsed.GetFieldsBaseType(SaveInput, SaveFields, BracketStart,
      TokenFileItem, TokenFileItem, token) then
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
            for I := 0 to token.Count - 1 do
            begin
              if token.Items[I].token = tkVariable then
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
            scope := token;
            token := token.Items[I];
            if token.token = tkVariable then
            begin
              Input := GetVarType(token);
              if StringIn(Input, ReservedTypes) or
                (not scope.SearchToken(Input, '', token, 0, False,
                [tkStruct, tkTypeStruct, tkUnion, tkTypeUnion]) and
                not FilesParsed.GetBaseType(Input, 0, TokenFileItem,
                TokenFileItem, token)) then
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
    P := Editor.RowColumnToPixels(Editor.BufferToDisplayPos(BufferCoordStart));
    P := Editor.ClientToScreen(P);
    ParamsList := TStringList.Create;
    Params := GetStructProto(token);
    ParamsList.Add(Params);
    HintTip.Cancel;
    DebugHint.Cancel;
    HintParams.UpdateHint(ParamsList, ParamIndex, P.X, P.Y);
    ParamsList.Free;
    Exit;
  end;
  BufferCoordEnd := Editor.GetMatchingBracketEx(BufferCoordStart);
  if (BufferCoordEnd.Char > 0) and (BufferCoordEnd.Line > 0) then
  begin
    BracketEnd := Editor.RowColToCharIndex(BufferCoordEnd);
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
  // show function params
  if not FilesParsed.GetFieldsBaseParams(Input, Fields, BracketStart,
    TokenFileItem, ParamsList) then
  begin
    if ActiveEditingFile.GetScopeAt(token, BracketStart) then
    begin
      if (token.token in [tkNamespace]) then
      begin
        SaveFields := token.name + '::' + SaveFields;
        while Assigned(token.Parent) and
          (token.Parent.token in [tkNamespace]) do
        begin
          token := token.Parent;
          SaveFields := token.name + '::' + SaveFields;
        end;
      end;
      if (SaveInput <> '') and (SaveFields <> '') and
        FilesParsed.SearchTreeToken(SaveFields, TokenFileItem, TokenFileItem,
        token, [tkClass, tkStruct, tkUnion, tkNamespace], token.SelStart) then
      begin
        scope := GetTokenByName(token, 'Scope', tkScope);
        if Assigned(scope) and not FilesParsed.SearchSource(SaveInput,
          TokenFileItem, TokenFileItem, token, scope.SelStart, ParamsList, True)
        then
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
  P := Editor.RowColumnToPixels(Editor.BufferToDisplayPos(BufferCoordStart));
  P := Editor.ClientToScreen(P);

  for I := ParamsList.Count - 1 downto 0 do
  begin
    token := TTokenClass(ParamsList.Objects[I]);
    if not(token.token in [tkConstructor, tkFunction, tkProtoType,
      tkTypedefProto, tkOperator]) then
    begin
      ParamsList.Delete(I);
      continue;
    end;
    tokenParams := GetTokenByName(token, 'Params', tkParams);
    if (ParamIndex >= tokenParams.Count) and (ParamIndex > 0) then
    begin
      ParamsList.Delete(I);
      continue;
    end;
    S := MakeTokenParamsHint(token);
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
  ProgressBarParser.Visible := True;
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
  if ThreadLoadTkFiles.Busy or ThreadFilesParsed.Busy then
    Exit;
  ProgressBarParser.Visible := False;
  // Bug: Emit Realign items
  StatusBar.Width := StatusBar.Width - 1;
  StatusBar.Width := StatusBar.Width + 1;
end;

procedure TFrmFalconMain.AllParserStart(Sender: TObject);
begin
  ProgressBarParser.Position := 0;
  ProgressBarParser.Visible := True;
end;

procedure TFrmFalconMain.AllParserProgress(Sender: TObject;
  TokenFile: TTokenFile; const FileName: string; Current, Total: Integer;
  Parsed: Boolean; Method: TTokenParseMethod);
begin
  if not Parsed then
    Exit;
  // don't wait for parse all files: update  now grayed project and outline
  if (ActiveEditingFile.Data = TokenFile.Data) then
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
  // update grayed project and outline
  PageControlEditorPageChange(PageControlEditor,
    PageControlEditor.ActivePageIndex, -1);
  if ThreadLoadTkFiles.Busy or ThreadTokenFiles.Busy then
    Exit;
  ProgressBarParser.Visible := False;
  // Bug: Emit Realign items
  StatusBar.Width := StatusBar.Width - 1;
  StatusBar.Width := StatusBar.Width + 1;
end;

procedure TFrmFalconMain.TokenParserStart(Sender: TObject);
begin
  //
end;

procedure TFrmFalconMain.TokenParserProgress(Sender: TObject;
  TokenFile: TTokenFile; const FileName: string; Current, Total: Integer;
  Parsed: Boolean; Method: TTokenParseMethod);
begin
  if not ThreadTokenFiles.Busy and not ThreadFilesParsed.Busy and
    (ProgressBarParser.Tag <> 1) then
  begin
    ProgressBarParser.Visible := True;
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
  if ThreadTokenFiles.Busy or ThreadFilesParsed.Busy then
    Exit;
  ProgressBarParser.Visible := False;
  // Bug: Emit Realign items
  StatusBar.Width := StatusBar.Width - 1;
  StatusBar.Width := StatusBar.Width + 1;
end;

procedure TFrmFalconMain.ProcessDebugHint(Input: string;
  Line, SelStart: Integer; CursorPos: TPoint);
var
  token: TTokenClass;
  TokenFile: TTokenFile;
begin
  if not CommandQueue.Empty then
    Exit;
  token := nil;
  if not FilesParsed.GetFieldsBaseType(GetFirstWord(Input), Input, SelStart,
    ActiveEditingFile, TokenFile, token) then
  begin
    FilesParsed.GetFieldsBaseType(GetFirstWord(Input), Input,
      SelStart + Length(Input), ActiveEditingFile, TokenFile, token);
  end;
  CommandQueue.Push(dctPrint, GDB_PRINT, DebugReader.LastPrintID + 1, Input,
    Line, SelStart, token, CursorPos);
  DebugReader.SendCommand(GDB_PRINT, Input);
end;

procedure TFrmFalconMain.ProcessHintView(SourceFile: TSourceFile; Editor: TEditor;
  const X, Y: Integer);

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
  token: TTokenClass;
  TokenFileItem: TTokenFile;
  P: TPoint;
  InputError: Boolean;
  WordStartPos, I: Integer;
  attri: THighlighStyle;
begin
  if not Config.Editor.TooltipSymbol then
    Exit;
  DisplayCoord := Editor.PixelsToRowColumn(X, Y);
  BC := Editor.DisplayToBufferPos(DisplayCoord);
  if BC.Line > 0 then
  begin
    // after end line
    if BC.Char > Length(Editor.Lines.Strings[BC.Line - 1]) then
    begin
      HintTip.Cancel;
      DebugHint.Cancel;
      CanShowHintTip := False;
      Exit;
    end;
  end;
  I := Editor.RowColToCharIndex(BC);
  WordStart := Editor.WordStartEx(BC);
  WordStartPos := Editor.RowColToCharIndex(WordStart);
  // running application
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
  if Editor.GetHighlighterAttriAtRowCol(BC, S, attri) then
  begin
    // invalid attribute
    if ((not StringIn(attri.name, [HL_Style_Identifier, HL_Style_Preprocessor]) or
      (Pos('include', S) > 0)) and not DebugReader.Running) or
      ((Editor.Highlighter.IsComment(attri) or Editor.Highlighter.IsString
      (attri) or (attri.name = HL_Style_Preprocessor)) and DebugReader.Running)
    then
    begin
      HintTip.Cancel;
      DebugHint.Cancel;
      CanShowHintTip := False;
      Exit;
    end;
  end;
  // evaluate/modify with selection
  if DebugReader.Running and Editor.SelAvail and BufferIn(Editor.BlockBegin, BC,
    Editor.BlockEnd) then
  begin
    DisplayCoord := Editor.BufferToDisplayPos(Editor.BlockBegin);
    P := Editor.RowColumnToPixels(DisplayCoord);
    P := Editor.ClientToScreen(P);
    ProcessDebugHint(Editor.SelText, BC.Line, I, P);
    Exit;
  end;
  Input := Editor.GetWordAtRowCol(BC);
  DisplayCoord := Editor.BufferToDisplayPos(WordStart);
  P := Editor.RowColumnToPixels(DisplayCoord);
  P := Editor.ClientToScreen(P);
  if ParseFields(Editor.Lines.Text, I, Input, Fields, InputError) then
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
        // empty text on mouse
        DebugHint.Cancel;
        HintTip.Cancel;
        CanShowHintTip := False;
      end;
      Exit;
    end;
    // show hint
    if FilesParsed.FindDeclaration(Input, Fields, ActiveEditingFile,
      ActiveEditingFile, TokenFileItem, token, I) then
    begin
      S := MakeTokenHint(token, TokenFileItem.FileName);
      HintTip.UpdateHint(S, token.Comment, P.X, P.Y + Editor.LineHeight + 4,
        GetTokenImageIndex(token, OutlineImages));
      Exit;
    end;
  end;
  // none others
  HintTip.Cancel;
  DebugHint.Cancel;
  CanShowHintTip := False;
  Exit;
end;

procedure TFrmFalconMain.TimerHintTipEventTimer(Sender: TObject);
var
  P: TPoint;
  Sheet: TSourceFileSheet;
  SourceFile: TSourceFile;
begin
  TimerHintTipEvent.Enabled := False;
  CanShowHintTip := True;
  if not HintParams.Activated then
  begin
    if not GetActiveSheet(Sheet) then
      Exit;
    if not GetActiveFile1(SourceFile) then
      Exit;
    P := Sheet.Editor.ScreenToClient(Mouse.CursorPos);
    ProcessHintView(SourceFile, Sheet.Editor, P.X, P.Y);
  end;
end;

function TFrmFalconMain.FillIncludeList(IncludePathFilesOnly: Boolean): Boolean;
var
  NewToken: TTokenClass;
  Sheet: TSourceFileSheet;
  ProjectBase: TProjectBase;
  S: string;
  I, J, LastStart: Integer;
  List: TStrings;
begin
  Result := True;
  if not GetActiveSheet(Sheet) then
    Exit;
  ProjectBase := Sheet.SourceFile.Project;
  if IncludePathFilesOnly then
  begin
    S := ExtractFilePath(ProjectBase.FileName);
    if not SameText(S, FLastProjectIncludePath) then
    begin
      FLastProjectIncludePath := S;
      for I := 0 to FProjectIncludePathList.Count - 1 do
        TTokenClass(FProjectIncludePathList.Objects[I]).Free;
      FProjectIncludePathList.Clear;
      List := TStringList.Create;
      GetIncludeDirs(S, ProjectBase.Flags, List);
      LastStart := 0;
      for I := 0 to List.Count - 1 do
      begin
        S := ConvertSlashes(List[I]);
        FindFiles(S, '*.h', FProjectIncludePathList);
        for J := LastStart to FProjectIncludePathList.Count - 1 do
        begin
          NewToken := TTokenClass.Create;
          FProjectIncludePathList.Objects[J] := NewToken;
          NewToken.name := ConvertToUnixSlashes
            (ExtractRelativePath(S, FProjectIncludePathList.Strings[J]));
          NewToken.Flag := 'S';
          NewToken.token := tkInclude;
        end;
        LastStart := FProjectIncludePathList.Count;
      end;
      List.Free;
    end;
    // project include path
    for I := 0 to FProjectIncludePathList.Count - 1 do
    begin
      NewToken := TTokenClass(FProjectIncludePathList.Objects[I]);
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken),
        NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken,
        CompletionColors, OutlineImages), NewToken);
    end;
    // compiler include path
    for I := 0 to FIncludeFileList.Count - 1 do
    begin
      if FIncludeFileList.Objects[I] = nil then
      begin
        NewToken := TTokenClass.Create;
        FIncludeFileList.Objects[I] := NewToken;
        NewToken.name := FIncludeFileList.Strings[I];
        NewToken.Flag := 'S';
        NewToken.token := tkInclude;
      end
      else
        NewToken := TTokenClass(FIncludeFileList.Objects[I]);
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken),
        NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken,
        CompletionColors, OutlineImages), NewToken);
    end;
    Exit;
  end;
  S := ExtractFilePath(Sheet.SourceFile.FileName);
  if not SameText(S, FLastPathInclude) then
  begin
    FLastPathInclude := S;
    for I := 0 to ProjectIncludeList.Count - 1 do
      TTokenClass(ProjectIncludeList.Objects[I]).Free;
    ProjectIncludeList.Clear;
    List := TStringList.Create;
    ProjectBase.GetSources(List, SOURCE_TYPES, [FILE_TYPE_H]);
    for I := 0 to List.Count - 1 do
    begin
      NewToken := TTokenClass.Create;
      NewToken.name := ConvertToUnixSlashes(ExtractRelativePath(S,
        List.Strings[I]));
      NewToken.Flag := 'L';
      NewToken.token := tkInclude;
      ProjectIncludeList.AddObject(NewToken.name, NewToken);
      if (List.Objects[I] = Sheet.SourceFile) then
        continue;
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken),
        NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken,
        CompletionColors, OutlineImages), NewToken);
    end;
    List.Free;
  end
  else
  begin
    for I := 0 to ProjectIncludeList.Count - 1 do
    begin
      NewToken := TTokenClass(ProjectIncludeList.Objects[I]);
      if (NewToken.Data = Sheet.SourceFile) then
        continue;
      CodeCompletion.InsertList.AddObject(CompletionInsertItem(NewToken),
        NewToken);
      CodeCompletion.ItemList.AddObject(CompletionShowItem(NewToken,
        CompletionColors, OutlineImages), NewToken);
    end;
  end;
end;

procedure TFrmFalconMain.CodeCompletionExecute(Kind: TSynCompletionType;
  Sender: TObject; var CurrentInput: string; var X, Y: Integer;
  var CanExecute: Boolean);
var
  Fields, Input, SaveInput, LineStr: string;
  S: UnicodeString;
  Sheet: TSourceFileSheet;
  TokenItem: TTokenFile;
  SelStart, LineLen: Integer;
  token, scope, SaveScope: TTokenClass;
  AllScope: Boolean;
  AllowScope: TScopeClassState;
  Buffer, SaveBuffer: TBufferCoord;
  attri: THighlighStyle;
  InputError, SkipFirst: Boolean;
  Tokens, CurrToken: PToken;
begin
  fShowCodeCompletion := 0;
  Input := '';
  CanExecute := False;
  if not Config.Editor.CodeCompletion then
    Exit;
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.SourceFile.CodeCompleteAt(Sheet.Editor.CaretY, Sheet.Editor.CaretX);
  Tokens := TParserThread(fWorkerThread).LockTokens(Sheet.SourceFile);
  try
    // do something ...
    CurrToken := TokenAtPosition(Tokens, Sheet.Editor.GetCurrentPos);
    if CurrToken <> nil then
      Fields := '';
  finally
    TParserThread(fWorkerThread).UnLockTokens;
  end;
  // get valid SelStart
  Buffer := Sheet.Editor.CaretXY;
  LineStr := '';
  if (Buffer.Line > 0) then
  begin
    LineStr := Sheet.Editor.Lines[Buffer.Line - 1];
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
  if Sheet.Editor.GetHighlighterAttriAtRowCol(Buffer, S, attri) then
  begin
    if Sheet.Editor.Highlighter.IsComment(attri) or
      Sheet.Editor.Highlighter.IsString(attri) or
      (attri.name = HL_Style_Preprocessor) then
    begin
      Dec(Buffer.Char);
      if (attri.name <> HL_Style_Preprocessor) and
        Sheet.Editor.GetHighlighterAttriAtRowCol(Buffer, S, attri) then
      begin
        if Sheet.Editor.Highlighter.IsComment(attri) or
          Sheet.Editor.Highlighter.IsString(attri) or
          (attri.name = HL_Style_Preprocessor) then
        begin
          if (attri.name = HL_Style_Preprocessor) and
            (Pos('include', LineStr) > 0) and (Pos('>', LineStr) = 0) and
            (CountChar(LineStr, '"') <= 1) and
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
        if (attri.name = HL_Style_Preprocessor) and
          (Pos('include', LineStr) > 0) and (Pos('>', LineStr) = 0) and
          (CountChar(LineStr, '"') <= 1) and
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
    if Sheet.Editor.GetHighlighterAttriAtRowCol(Buffer, S, attri) then
    begin
      if Sheet.Editor.Highlighter.IsComment(attri) or
        Sheet.Editor.Highlighter.IsString(attri) or
        (attri.name = HL_Style_Preprocessor) then
      begin
        Dec(Buffer.Char);
        if (attri.name <> HL_Style_Preprocessor) and
          Sheet.Editor.GetHighlighterAttriAtRowCol(Buffer, S, attri) then
        begin
          if Sheet.Editor.Highlighter.IsComment(attri) or
            Sheet.Editor.Highlighter.IsString(attri) or
            (attri.name = HL_Style_Preprocessor) then
          begin
            if (attri.name = HL_Style_Preprocessor) and
              (Pos('include', LineStr) > 0) and (Pos('>', LineStr) = 0) and
              (CountChar(LineStr, '"') <= 1) and
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
          if (attri.name = HL_Style_Preprocessor) and
            (Pos('include', LineStr) > 0) and (Pos('>', LineStr) = 0) and
            (CountChar(LineStr, '"') <= 1) and
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
            if ParseFields(Sheet.Editor.Lines.Text,
              Sheet.Editor.RowColToCharIndex(SaveBuffer), SaveInput, Fields,
              InputError) then
              Input := GetFirstWord(Fields);
            if InputError then
              Exit;
            AddTemplates(Input, tkUnknow, CodeCompletion.InsertList,
              CodeCompletion.ItemList, CompletionColors, OutlineImages,
              Sheet.SourceFile.Project.CompilerType, [tkInclude, tkDefine]);
            CanExecute := CodeCompletion.InsertList.Count > 0;
          end;
          Exit;
        end;
      end;
    end;
    Inc(Buffer.Char);
  end;
  if ParseFields(Sheet.Editor.Lines.Text,
    Sheet.Editor.RowColToCharIndex(SaveBuffer), SaveInput, Fields, InputError)
  then
    Input := GetFirstWord(Fields);
  if InputError then
    Exit;
  if not UsingCtrlSpace and (LastKeyPressed = '>') and
    ((Length(Fields) < 2) or ((Length(Fields) > 1) and
    (Fields[Length(Fields) - 1] <> '-'))) then
    Exit;
  SelStart := Sheet.Editor.RowColToCharIndex(Buffer);
  // Temp skip Scope:
  if (Buffer.Line > 0) then
  begin
    LineStr := Sheet.Editor.Lines[Buffer.Line - 1];
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
  // End temp
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
    if ActiveEditingFile.GetScopeAt(token, SelStart) then
    begin
      if (token.token in [tkNamespace]) then
      begin
        Fields := token.name + '::' + Fields;
        while Assigned(token.Parent) and
          (token.Parent.token in [tkNamespace]) do
        begin
          token := token.Parent;
          Fields := token.name + '::' + Fields;
        end;
      end;
      if (Fields <> '') and FilesParsed.SearchTreeToken(Fields,
        ActiveEditingFile, TokenItem, token, [tkClass, tkStruct, tkUnion,
        tkNamespace], token.SelStart) then
      begin
        AllowScope := [];
        FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
          CodeCompletion.ItemList, CompletionColors, OutlineImages, TokenItem,
          token, AllowScope);
        DebugHint.Cancel;
        HintTip.Cancel;
        CanExecute := True;
        Exit;
      end;
    end;
    // search base type and list fields and functions of struct, union or class
    if FilesParsed.GetFieldsBaseType('', Fields, SelStart, ActiveEditingFile,
      TokenItem, token) then
    begin
      // show private fields only on implementation scope
      AllowScope := [];
      if ActiveEditingFile.GetScopeAt(scope, Sheet.Editor.SelStart) then
      begin
        SaveScope := scope;
        scope := GetTokenByName(scope, 'Scope', tkScope);
        AllScope := Assigned(scope) and (scope.Flag = token.name);
        if not AllScope then
        begin
          SaveScope := SaveScope.Parent;
          if Assigned(SaveScope) and (SaveScope.token = tkScopeClass) then
            SaveScope := SaveScope.Parent;
          if Assigned(SaveScope) and (SaveScope.name = token.name) then
            AllScope := True;
        end;
      end
      else
        AllScope := Pos('::', Fields) > 0;
      if not AllScope then
        AllowScope := AllowScope + [scPublic];
      FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, OutlineImages, TokenItem,
        token, AllowScope);
      DebugHint.Cancel;
      HintTip.Cancel;
      CanExecute := True;
      Exit;
    end;
    Exit; // WARNNING cin. if cin not found then does not show code completion
  end;
  // get current object in location
  if ActiveEditingFile.GetScopeAt(token, SelStart) then
  begin
    SaveScope := token;
    AllScope := False;
    // fill first all object in finded object location
    FillCompletionTree(CodeCompletion.InsertList, CodeCompletion.ItemList,
      token, SelStart, CompletionColors, OutlineImages, [], True);
    if Fields = '' then
      AddTemplates(CurrentInput, token.token, CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, OutlineImages,
        Sheet.SourceFile.Project.CompilerType);
    { TODO -oMazin -c : while parent is not nil fill objects 24/08/2012 22:27:26 }
    // get parent of Token
    if Assigned(token.Parent) and
      (token.Parent.token in [tkClass, tkStruct, tkUnion, tkScopeClass]) then
    begin
      token := token.Parent;
      TokenItem := ActiveEditingFile;
      AllScope := True;
    end;
    // tree parent object?
    if Assigned(token.Parent) and
      (token.Parent.token in [tkClass, tkStruct, tkUnion]) then
    begin
      token := token.Parent;
    end;
    AllowScope := [];
    SkipFirst := False;
    // Get class of scope
    scope := GetTokenByName(token, 'Scope', tkScope);
    if not AllScope and Assigned(scope) and (scope.Flag <> '') then
    begin
      Fields := scope.Flag;
      while Assigned(token.Parent) and (token.Parent.token in [tkNamespace]) do
      begin
        token := token.Parent;
        Fields := token.name + '::' + Fields;
      end;
      AllScope := FilesParsed.SearchTreeToken(Fields, ActiveEditingFile,
        TokenItem, token, [tkClass, tkStruct, tkUnion, tkNamespace],
        token.SelStart);
    end
    else if not AllScope and (SaveScope.token in [tkClass, tkStruct, tkUnion])
    then
    begin
      TokenItem := ActiveEditingFile;
      SkipFirst := True;
      AllowScope := [scProtected, scPublic];
      token := SaveScope;
      AllScope := True;
    end
    else if (token.token in [tkNamespace]) then
    begin
      Fields := token.name;
      while Assigned(token.Parent) and (token.Parent.token in [tkNamespace]) do
      begin
        token := token.Parent;
        Fields := token.name + '::' + Fields;
      end;
      AllScope := FilesParsed.SearchTreeToken(Fields, ActiveEditingFile,
        TokenItem, token, [tkClass, tkStruct, tkUnion, tkNamespace],
        token.SelStart);
    end;
    // show all objects from class, struct or scope
    if AllScope then
    begin
      FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, OutlineImages, TokenItem,
        token, AllowScope, SkipFirst);
    end;
  end
  else if Fields = '' then
    AddTemplates(CurrentInput, tkUnknow, CodeCompletion.InsertList,
      CodeCompletion.ItemList, CompletionColors, OutlineImages,
      Sheet.SourceFile.Project.CompilerType);

  FilesParsed.FillCompletionList(CodeCompletion.InsertList,
    CodeCompletion.ItemList, ActiveEditingFile, SelStart, CompletionColors,
    OutlineImages);
  DebugHint.Cancel;
  HintTip.Cancel;
  CanExecute := True;
end;

procedure TFrmFalconMain.CodeCompletionGetWordBreakChars(Sender: TObject;
  var WordBreakChars, ScanBreakChars: string);
var
  Sheet: TSourceFileSheet;
  bCoord: TBufferCoord;
  LineStr: string;
  S: UnicodeString;
  LineLen: Integer;
  attri: THighlighStyle;
begin
  WordBreakChars := CodeCompletion.EndOfTokenChr;
  if not GetActiveSheet(Sheet) then
    Exit;
  bCoord := Sheet.Editor.CaretXY;
  LineStr := '';
  if (bCoord.Line > 0) then
  begin
    LineStr := Sheet.Editor.Lines[bCoord.Line - 1];
    LineLen := Length(LineStr);
    if (bCoord.Char > LineLen) then
      bCoord.Char := LineLen;
  end;
  if Sheet.Editor.GetHighlighterAttriAtRowCol(bCoord, S, attri) then
  begin
    if (attri.name = HL_Style_Preprocessor) then
    begin
      WordBreakChars := '<>"';
      ScanBreakChars := '<>"';
    end;
  end;
end;

function TFrmFalconMain.ShowPromptOverrideFile(const FileName: string): Boolean;
begin
  Result := InternalMessageBox(PChar(Format(STR_FRM_MAIN[54], [FileName])),
    'Falcon C++', MB_ICONWARNING + MB_YESNOCANCEL) = IDYES;
end;

procedure TFrmFalconMain.CodeCompletionGetWordEndChars(Sender: TObject;
  var WordEndChars: string; index: Integer; var Handled: Boolean);
var
  token: TTokenClass;
begin
  token := TTokenClass(CodeCompletion.ItemList.Objects[index]);
  if token.token = tkInclude then
  begin
    Handled := True;
    WordEndChars := '>"';
  end;
end;

procedure TFrmFalconMain.CodeCompletionCodeCompletion(Sender: TObject;
  var Value: string; Shift: TShiftState; index: Integer; var EndToken: Char;
  var OffsetCaret: Integer);
var
  token, Params, ClassToken: TTokenClass;
  NextChar: Char;
  LineStr, S: string;
  Sheet: TSourceFileSheet;
  BalancingBracket, SelStart, Len, AfterLen, I: Integer;
  P: TBufferCoord;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  token := TTokenClass(CodeCompletion.ItemList.Objects[index]);
  if EndToken = ')' then
  begin
    Value := Value + '('
  end
  else if token.token in [tkFunction, tkProtoType] then
  begin
    SelStart := Sheet.Editor.RowColToCharIndex(Sheet.Editor.CaretXY);
    if ActiveEditingFile.GetScopeAt(ClassToken, SelStart) and
      (ClassToken.token in [tkClass, tkStruct, tkUnion]) then
    begin
      P := Sheet.Editor.CaretXY;
      Len := Length(CodeCompletion.CurrentString);
      AfterLen := 0;
      LineStr := Sheet.Editor.Lines[P.Line - 1];
      for I := P.Char to Length(LineStr) do
      begin
        if CharInSet(LineStr[I], LetterChars + DigitChars) then
          Inc(AfterLen)
        else
          Break;
      end;
      S := GeneratePrototype(token, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4, 0);
      if CountWords(LineStr) > 1 then
      begin
        if ((AfterLen > 0) and (Trim(Copy(LineStr, AfterLen, MaxInt)) = '')) or
          (P.Char > Length(LineStr)) then
          S := token.name + Copy(S, Pos('(', S), MaxInt)
        else
          S := token.name;
      end;
      Sheet.Editor.BeginUpdate;
      Sheet.Editor.BlockBegin := BufferCoord(P.Char - Len, P.Line);
      Sheet.Editor.BlockEnd := BufferCoord(P.Char + AfterLen, P.Line);
      Sheet.Editor.SelText := S;
      Sheet.Editor.EndUpdate;
      Value := '';
      Exit;
    end;
    NextChar := GetNextValidChar(Sheet.Editor.Lines.Text,
      Sheet.Editor.SelStart);
    if EndToken <> '(' then
    begin
      Params := GetTokenByName(token, 'Params', tkParams);
      BalancingBracket := Sheet.Editor.GetBalancingBracketEx
        (Sheet.Editor.CaretXY, '(');
      if CharInSet(NextChar, LetterChars + ['{', '}']) and (EndToken <> ';')
      then
      begin
        Value := Value + '();';
        if (Params <> nil) and (Params.Count > 0) then
          Dec(OffsetCaret, 2);
        // set caret at middle of () when parameters count grater than one
      end
      else if CharInSet(NextChar, DigitChars + ArithmChars + CloseBraceChars +
        [';']) or (EndToken = ';') then
      begin
        if BalancingBracket <= 0 then
        begin
          Value := Value + '()';
          if (Params <> nil) and (Params.Count > 0) then
            Dec(OffsetCaret);
          // set caret at middle of () when parameters count grater than one
        end
        else
          Value := Value + '(';
      end
      else if NextChar <> '(' then
        Value := Value + '('
      else
        // TODO: use NextChar position
        Inc(OffsetCaret); // set caret after (
      LastKeyPressed := '(';
    end;
  end
  else if token.token = tkInclude then
  begin
    LineStr := '';
    if Sheet.Editor.CaretY <= Sheet.Editor.Lines.Count then
      LineStr := Trim(Sheet.Editor.Lines.Strings[Sheet.Editor.CaretY - 1]);
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
  else if (token.token = tkCodeTemplate) and (token.Flag <> '') then
  begin
    Value := '';
    ExecuteCompletion(CodeCompletion.CurrentString, token, Sheet.Editor);
  end;
end;

procedure TFrmFalconMain.CodeCompletionAfterCodeCompletion(Sender: TObject;
  const Value: string; Shift: TShiftState; index: Integer; var EndToken: Char);
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

procedure TFrmFalconMain.AddMessage(const FileName, Title, Msg: string;
  Line, Column, EndColumn: Integer; MsgType: TMessageItemType;
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
  PanelMessages.Show;
end;

procedure TFrmFalconMain.PaintTokenItemV2(const ToCanvas: TCanvas;
  DisplayRect: TRect; token: TTokenClass; Selected, Focused: Boolean;
  var DefaultDraw: Boolean);
var
  Flag, FullFlag, Vector, Params: string;
  HasVector, ChangeTextColor: Boolean;
  I, Len, TopOffset: Integer;
begin
  DefaultDraw := False;
  if token.token in [tkInclude, tkTypedefProto, tkIncludeList, tkDefineList,
    tkTreeObjList, tkVarConsList, tkFuncProList] then
  begin
    DefaultDraw := True;
    Exit;
  end;
  ChangeTextColor := not Selected;
  TopOffset := (DisplayRect.Bottom - DisplayRect.Top -
    ToCanvas.TextHeight('Wj[')) div 2;
  if token.token in [tkFunction, tkProtoType, tkConstructor, tkDestructor,
    tkOperator] then
  begin
    if token.token = tkOperator then
      Params := GetFuncScope(token) + 'operator ' + token.name +
        GetFuncProtoTypes(token)
    else
      Params := GetFuncScope(token) + token.name + GetFuncProtoTypes(token);
    Flag := token.Flag;
    if Flag = '' then
      DisplayRect.Right := DisplayRect.Left + 5 + ToCanvas.TextWidth(Params)
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
    // custom return type or value defined
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
  Len := Length(token.Flag);
  if Len = 0 then
  begin
    DefaultDraw := True;
    Exit;
  end;
  if (token.token = tkDefine) and not IsNumber(token.Flag) then
  begin
    DefaultDraw := True;
    Exit;
  end;
  DisplayRect.Right := DisplayRect.Left + 5 + ToCanvas.TextWidth
    (token.name + ' : ' + token.Flag);
  if Selected and not Focused then
  begin
    ToCanvas.Font.Color := clWindowText;
    ChangeTextColor := False;
  end;
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, token.name);
  // custom return type or value defined
  if ChangeTextColor then
    ToCanvas.Font.Color := clBlue;
  Inc(DisplayRect.Left, ToCanvas.TextWidth(token.name));
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + TopOffset, ' : ');

  if ChangeTextColor then
    ToCanvas.Font.Color := clOlive;
  Inc(DisplayRect.Left, ToCanvas.TextWidth(' : '));
  FullFlag := token.Flag;
  Flag := token.Flag;
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
  if not HasVector or not(token.token in [tkVariable, tkTypedef]) then
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
  Sheet: TSourceFileSheet;
begin
  TimerHintParams.Enabled := False;
  if not GetActiveSheet(Sheet) then
    Exit;
  ShowHintParams(Sheet.Editor);
end;

procedure TFrmFalconMain.ViewCompOutClick(Sender: TObject);
begin
  PanelMessages.Show;
end;

procedure TFrmFalconMain.FilePrintClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  // AFont: TFont;
  EditorPrint: TEditorPrint;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  PageControlEditor.CancelDragging;

  EditorPrint := TEditorPrint.Create(nil);
  if not EditorPrint.Execute(Handle) then
  begin
    EditorPrint.Free;
    Exit;
  end;
  EditorPrint.Editor := Sheet.Editor;
  EditorPrint.DocTitle := Sheet.SourceFile.name;
  EditorPrint.FileName := Sheet.SourceFile.FileName;
  EditorPrint.CurrentTime := FormatDateTime(STR_FRM_MAIN[38], Now);
  EditorPrint.Print;
  EditorPrint.Free;
end;

procedure TFrmFalconMain.PageControlMsgClose(Sender: TObject; TabIndex: Integer;
  var AllowClose: Boolean);
begin
  AllowClose := False;
  PanelMessages.Hide;
end;

procedure TFrmFalconMain.PageControlOutlineClose(Sender: TObject;
  TabIndex: Integer; var CanClose: Boolean);
begin
  CanClose := False;
  ViewOutline.Click;
end;

procedure TFrmFalconMain.PageControlProjectsClose(Sender: TObject;
  TabIndex: Integer; var CanClose: Boolean);
begin
  CanClose := False;
  ViewProjMan.Click;
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
  I: Integer;
begin
  P := Mouse.CursorPos;
  P := PageControlEditor.ScreenToClient(P);
  I := PageControlEditor.IndexOfTabAt(P.X, P.Y);
  if (I > -1) or (PageControlEditor.DirectionOfNavAt(P.X, P.Y) <> 0) then
    Exit;
  BtnNew.Click;
end;

procedure TFrmFalconMain.EditDeleteClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  SendMessage(Sheet.Editor.Handle, WM_KEYDOWN, VK_DELETE, VK_DELETE);
  SendMessage(Sheet.Editor.Handle, WM_KEYUP, VK_DELETE, VK_DELETE);
end;

procedure TFrmFalconMain.FileExportHTMLClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  ExporterHTML: TExporterHTML;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  ExporterHTML := TExporterHTML.Create;
  ExporterHTML.Title := Sheet.SourceFile.name;
  with TSaveDialog.Create(Self) do
  begin
    Filter := ExporterHTML.DefaultFilter;
    DefaultExt := '.html';
    Options := Options + [ofOverwritePrompt];
    FileName := ChangeFileExt(ExporterHTML.Title, '.html');
    if Execute(Self.Handle) then
    begin
      ExporterHTML.ExportAll(Sheet.Editor);
      ExporterHTML.SaveToFile(FileName);
    end;
    Free;
  end;
  ExporterHTML.Free;
end;

procedure TFrmFalconMain.FileExportRTFClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  ExporterRTF: TExporterRTF;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  ExporterRTF := TExporterRTF.Create;
  ExporterRTF.Title := Sheet.SourceFile.name;
  with TSaveDialog.Create(Self) do
  begin
    Filter := ExporterRTF.DefaultFilter;
    DefaultExt := '.rtf';
    Options := Options + [ofOverwritePrompt];
    FileName := ChangeFileExt(ExporterRTF.Title, '.rtf');
    if Execute(Self.Handle) then
    begin
      ExporterRTF.ExportAll(Sheet.Editor);
      ExporterRTF.SaveToFile(FileName);
    end;
    Free;
  end;
  ExporterRTF.Free;
end;

procedure TFrmFalconMain.FileExportTeXClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  ExporterTeX: TExporterTeX;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  ExporterTeX := TExporterTeX.Create;
  ExporterTeX.Title := Sheet.SourceFile.name;
  with TSaveDialog.Create(Self) do
  begin
    Filter := ExporterTeX.DefaultFilter;
    DefaultExt := '.tex';
    Options := Options + [ofOverwritePrompt];
    FileName := ChangeFileExt(ExporterTeX.Title, '.tex');
    if Execute(Self.Handle) then
    begin
      ExporterTeX.ExportAll(Sheet.Editor);
      ExporterTeX.SaveToFile(FileName);
    end;
    Free;
  end;
  ExporterTeX.Free;
end;

procedure TFrmFalconMain.PopTabsCloseAllOthersClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  I: Integer;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  HandlingTabs := True;
  for I := PageControlEditor.PageCount - 1 downto Sheet.PageIndex + 1 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  for I := Sheet.PageIndex - 1 downto 0 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  PageControlEditor.ActivePageIndex := Sheet.PageIndex;
  Sheet.Editor.SetFocus;
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
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Clipboard.AsText := Sheet.SourceFile.FileName;
end;

procedure TFrmFalconMain.PopTabsCopyFileNameClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Clipboard.AsText := Sheet.SourceFile.name;
end;

procedure TFrmFalconMain.PopTabsCopyDirClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Clipboard.AsText := ExtractFilePath
    (ExcludeTrailingPathDelimiter(Sheet.SourceFile.FileName));
end;

procedure TFrmFalconMain.PopTabsReadOnlyClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.SourceFile.readonly := PopTabsReadOnly.Checked;
  Sheet.Editor.readonly := PopTabsReadOnly.Checked;
  if Sheet.SourceFile.readonly then
    Sheet.Font.Color := clGrayText
  else
    Sheet.Font.Color := clWindowText;
end;

procedure TFrmFalconMain.SwapHeaderSource(FromSrc, ToSrc: TSourceFile);
var
  FromTokenFile, ToTokenFile, TempTokenFile: TTokenFile;
  FromSheet, ToSheet: TSourceFileSheet;
  scopeToken, token, ParentToken: TTokenClass;
  Buffer: TBufferCoord;
  FuncScope, ScopeFlag: string;
begin
  FromTokenFile := FilesParsed.Find(FromSrc.FileName);
  ToTokenFile := FilesParsed.Find(ToSrc.FileName);
  ToSheet := ToSrc.Edit;
  if not FromSrc.GetSheet(FromSheet) or (FromTokenFile = nil) or
    (ToTokenFile = nil) then
    Exit;
  scopeToken := DetectScope(FromSheet.Editor, FromTokenFile, False);
  if FromSrc.FileType = FILE_TYPE_H then
  begin
    // only prototype
    if (scopeToken = nil) or
      not(scopeToken.token in [tkProtoType, tkConstructor, tkDestructor]) and
      (GetTokenByName(scopeToken, 'Scope', tkScope) = nil) then
      Exit;
    ScopeFlag := '';
    FuncScope := '';
    ParentToken := scopeToken.Parent;
    if Assigned(ParentToken) and (ParentToken.token = tkScopeClass) then
    begin
      ParentToken := ParentToken.Parent;
      if ParentToken.token in [tkClass, tkStruct, tkUnion] then
      begin
        FuncScope := ParentToken.name;
        ParentToken := ParentToken.Parent;
      end;
    end;
    while Assigned(ParentToken) and (ParentToken.token = tkNamespace) do
    begin
      ScopeFlag := ParentToken.name + '::' + ScopeFlag;
      ParentToken := ParentToken.Parent;
    end;
    // search scope
    if (ScopeFlag <> '') and ToTokenFile.SearchTreeToken(ScopeFlag, token,
      [tkNamespace], 0) then
    begin
      if not token.SearchToken(scopeToken.name, FuncScope, token, 0, True,
        [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
        Exit;
    end
    // search implementation function
    else if not ToTokenFile.SearchToken(scopeToken.name, ScopeFlag, token, 0,
      True, [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
      Exit;
    token := GetTokenByName(token, 'Scope', tkScope);
    // only function implementation
    if token = nil then
      Exit;
  end
  else
  begin
    // only function
    if (scopeToken = nil) or not(scopeToken.token in [tkFunction, tkConstructor,
      tkDestructor, tkOperator]) and
      (GetTokenByName(scopeToken, 'Scope', tkScope) <> nil) then
      Exit;
    // search scope
    FuncScope := GetFuncScope(scopeToken);
    if FilesParsed.FindDeclaration(scopeToken.name, FuncScope, FromTokenFile,
      FromTokenFile, TempTokenFile, token, scopeToken.SelStart) then
    begin
      if ToTokenFile <> TempTokenFile then
        Exit;
    end
    // search function
    else if not ToTokenFile.SearchToken(scopeToken.name, '', token, 0, False,
      [tkProtoType, tkConstructor, tkDestructor]) then
      Exit;
  end;
  Buffer := ToSheet.Editor.CharIndexToRowCol(token.SelStart);
  GotoLineAndAlignCenter(ToSheet.Editor, Buffer.Line, Buffer.Char);
end;

function TFrmFalconMain.CreateTODOSourceFile(FileName: string;
  TokenFile: TTokenFile; SourceFile: TSourceFile;
  var TODOSourceFile: TSourceFile): Boolean;
var
  I: Integer;
  Project: TProjectBase;
  Parent: TSourceFile;
  Editor: TEditor;
  Lines: TStrings;
  Directive: string;
begin
  Result := False;
  if (SourceFile.Project.FileType <> FILE_TYPE_PROJECT) or
    (SourceFile.Node.Parent = nil) then
    Exit;
  I := InternalMessageBox
    (PChar(Format(STR_FRM_MAIN[34] + #10 + STR_FRM_MAIN[43], [FileName])),
    'Falcon C++', MB_ICONEXCLAMATION + MB_YESNOCANCEL);
  if I <> IDYES then
    Exit;
  Project := SourceFile.Project;
  Parent := TSourceFile(SourceFile.Node.Parent.Data);
  if SourceFile.FileType = FILE_TYPE_H then
  begin
    { TODO -oMazin -c : Get Source file extension standard 06/05/2013 22:59:19 }
    if Project.CompilerType = COMPILER_C then
      TODOSourceFile := TSourceFile(NewSourceFile(FILE_TYPE_C, Project.CompilerType,
        ExtractFileName(FileName), ExtractName(FileName), '.c', '', Parent,
        False, False))
    else
      TODOSourceFile := TSourceFile(NewSourceFile(FILE_TYPE_CPP, Project.CompilerType,
        ExtractFileName(FileName), ExtractName(FileName), '.cpp', '', Parent,
        False, False));
    Editor := TODOSourceFile.Edit(False).Editor;
    Editor.Lines.Add('#include "' + ExtractFileName(SourceFile.FileName) + '"');
    Editor.Lines.Add('');
    if TokenFile <> nil then
    begin
      Lines := TStringList.Create;
      GenerateFunctions(TokenFile, Lines, 0, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4);
      Editor.Lines.AddStrings(Lines);
      Lines.Free;
    end
    else
      Editor.Lines.Add(''); // Caret here
    Editor.CaretXY := BufferCoord(1, 3);
    Project.PropertyChanged := True;
  end
  else
  begin
    { TODO -oMazin -c : Get Header file extension standard 06/05/2013 22:59:19 }
    TODOSourceFile := TSourceFile(NewSourceFile(FILE_TYPE_H, NO_COMPILER,
      ExtractFileName(FileName), ExtractName(FileName), '.h', '', Parent,
      False, False));

    Directive := UpperCase(ExtractFileName(FileName));
    Directive := '_' + StringReplace(Directive, '.', '_', []) + '_';
    Directive := StringReplace(Directive, ' ', '_', []);

    Editor := TODOSourceFile.Edit(False).Editor;
    Editor.Lines.Add('#ifndef ' + Directive);
    { TODO -oMazin -c : Add GNU License 24/08/2012 22:29:54 }
    Editor.Lines.Add('#define ' + Directive);
    Editor.Lines.Add('');
    if TokenFile <> nil then
    begin
      Lines := TStringList.Create;
      GenerateFunctionPrototype(TokenFile, Lines, 0);
      Editor.Lines.AddStrings(Lines);
      Lines.Free;
    end
    else
      Editor.Lines.Add(''); // Caret here
    Editor.Lines.Add('');
    Editor.Lines.Add('#endif');
    Editor.CaretXY := BufferCoord(1, 4);
    Project.PropertyChanged := True;
  end;
  Result := True;
end;

procedure TFrmFalconMain.EditSwapClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  OtherFileName, FileName: string;
  CurrentSourceFile, OtherSourceFile: TSourceFile;
  CurrentTokenFile: TTokenFile;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  CurrentSourceFile := Sheet.SourceFile;
  FileName := CurrentSourceFile.FileName;
  OtherSourceFile := nil;
  if (GetFileType(FileName) in [FILE_TYPE_CPP, FILE_TYPE_C]) then
  begin
    // find header file
    if not SearchHeaderFile(CurrentSourceFile, OtherSourceFile, OtherFileName)
    then
    begin
      OtherFileName := ChangeFileExt(FileName, '.h');
      // header file not found and can't create a header file out of project
      if CurrentSourceFile is TProjectBase then
      begin
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [OtherFileName])),
          'Falcon C++', MB_ICONINFORMATION);
        Exit;
      end;
      // want to create a header file?
      CurrentTokenFile := FilesParsed.Find(FileName);
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
      if CurrentSourceFile is TProjectBase then
      begin
        InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [OtherFileName])),
          'Falcon C++', MB_ICONINFORMATION);
        Exit;
      end;
      // change extension to cpp if is a c++ project
      if CurrentSourceFile.Project.CompilerType = COMPILER_CPP then
        OtherFileName := ChangeFileExt(FileName, '.cpp');
      // want to create a source file?
      CurrentTokenFile := FilesParsed.Find(FileName);
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
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.Editor.SetFocus;
end;

procedure TFrmFalconMain.PageControlEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Sheet: TSourceFileSheet;
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
    else if (Button = mbLeft) and GetActiveSheet(Sheet) then
    begin
      if not Sheet.Editor.Focused and Sheet.Editor.Showing then
        Sheet.Editor.SetFocus;
    end;
  end;
end;

procedure TFrmFalconMain.EditFormatClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  caret: TBufferCoord;
  TopLine: Integer;
begin
  if not GetActiveSheet(Sheet) then
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
      2: // Linux
        begin
          BracketStyle := stLINUX;
          TabWidth := 8;
          Properties[aspIndentNamespaces] := True;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      3: // GNU
        begin
          BracketStyle := stGNU;
          TabWidth := 2;
          Properties[aspBreakBlocks] := True;
          Properties[aspIndentNamespaces] := True;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      4: // java
        begin
          BracketStyle := stJAVA;
          Properties[aspKeepOneLineStatements] := True;
          Properties[aspKeepOneLineBlocks] := True;
        end;
      5: // custom
        begin
          BracketStyle := stNONE;
          TabWidth := Config.Editor.TabWidth;
          // Indentation
          Properties[aspIndentClasses] := Config.Editor.IndentClasses;
          Properties[aspIndentSwitches] := Config.Editor.IndentSwitches;
          Properties[aspIndentCases] := Config.Editor.IndentCase;
          // ? Properties[aspIndentBracket] := Config.Editor.IndentBrackets;
          // ? Properties[aspIndentBlock] := Config.Editor.IndentBlocks;
          Properties[aspIndentNamespaces] := Config.Editor.IndentNamespaces;
          Properties[aspIndentLabels] := Config.Editor.IndentLabels;
          Properties[aspIndentPreprocDefine] := Config.Editor.IndentMultLine;
          Properties[aspIndentCol1Comments] :=
            Config.Editor.IndentSingleLineComments;

          // padding
          Properties[aspBreakClosingBrackets] :=
            Config.Editor.BreakClosingHeaderBlocks;
          Properties[aspPaddingOperator] :=
            Config.Editor.InsertSpacePaddingOperators;
          Properties[aspPaddingParensOutside] :=
            Config.Editor.InsertSpacePaddingParenthesisOutside;
          Properties[aspPaddingParensInside] :=
            Config.Editor.InsertSpacePaddingParenthesisInside;
          Properties[aspPaddingHeader] :=
            Config.Editor.ParenthesisHeaderPadding;
          Properties[aspUnpaddingParens] := Config.Editor.RemoveExtraSpace;
          Properties[aspDeleteEmptyLines] := Config.Editor.DeleteEmptyLines;
          Properties[aspFillEmptyLines] := Config.Editor.FillEmptyLines;

          // Formatting
          Properties[aspBreakElseIfs] := Config.Editor.BreakIfElse;
          Properties[aspAddBrackets] := Config.Editor.AddBrackets;
          Properties[aspAddOneLineBrackets] := Config.Editor.AddOneLineBrackets;
          Properties[aspKeepOneLineBlocks] :=
            not Config.Editor.DontBreakOnelineBlocks;
          Properties[aspKeepOneLineStatements] :=
            Config.Editor.DontBreakComplex;
          Properties[aspConvertTabs] := Config.Editor.ConvertTabToSpaces;
          case Config.Editor.PointerAlign of
            1:
              AlignPointer := apType;
            2:
              AlignPointer := apMiddle;
            3:
              AlignPointer := apName;
          else
            AlignPointer := apNone;
          end;
        end;
    end;
    Sheet.Editor.BeginUpdate;
    caret := Sheet.Editor.CaretXY;
    TopLine := Sheet.Editor.TopLine;
    Sheet.Editor.SendEditor(SCI_SETTEXT, 0,
      Integer(Format(PUTF8String(Sheet.Editor.GetCharacterPointer))));
    Sheet.Editor.CaretXY := caret;
    Sheet.Editor.TopLine := TopLine;
    Sheet.Editor.EndUpdate;
    Free;
  end;
end;

procedure TFrmFalconMain.EditIndentClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.Editor.SendEditor(SCI_TAB);
end;

procedure TFrmFalconMain.EditUnindentClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.Editor.SendEditor(SCI_BACKTAB);
end;

procedure TFrmFalconMain.EditToggleCommentClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.Editor.ToggleLineComment;
end;

procedure TFrmFalconMain.IncLoading;
begin
  Inc(FLoadingCount);
end;

function TFrmFalconMain.InternalMessageBox(Text, Caption: string; uType: UINT;
  Handle: HWND): Integer;
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
  SourceFile: TSourceFile;
  Node: TTreeNode;
  FileName: string;
  I: Integer;
  Sheet: TSourceFileSheet;
begin
  if IsLoading or ShowingReloadEnquiry then
    Exit;
  ShowingReloadEnquiry := True;
  for I := 0 to TreeViewProjects.Items.Count - 1 do
  begin
    Node := TreeViewProjects.Items.Item[I];
    SourceFile := TSourceFile(Node.Data);
    if not SourceFile.FileChangedInDisk then
      continue;
    FileName := SourceFile.FileName;
    if SourceFile.GetSheet(Sheet) and not Sheet.Editor.GetModify then
    begin
      SourceFile.Reload;
      UpdateStatusbar;
    end
    else if SourceFile.Editing and
      (InternalMessageBox(PChar(FileName + #13#13 + STR_FRM_MAIN[49]),
      'Falcon C++', MB_ICONQUESTION or MB_YESNO) = IDYES) then
    begin
      SourceFile.Reload;
      SourceFile.Project.CompilePropertyChanged := True;
    end
    else
      SourceFile.UpdateDate;
  end;
  ShowingReloadEnquiry := False;
end;

procedure TFrmFalconMain.ApplicationEventsActivate(Sender: TObject);
begin
  CheckIfFilesHasChanged;
end;

procedure TFrmFalconMain.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = WM_NCLBUTTONDOWN) and (Msg.HWND = Handle) then
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
  Temp: TSourceFile;
  SrcBase: TSourceBase;
  Parent: TSourceBase;
  FileName, SwapFileName, SrcName: string;
  IncludeList: TStringList;
begin
  Parent := nil;
  Result := False;
  if (HeaderFile <> nil) then
  begin
    if (HeaderFile.FileType <> FILE_TYPE_H) then
      Exit;
    FileName := HeaderFile.FileName;
    if Assigned(HeaderFile.Node.Parent) then
      Parent := TSourceBase(HeaderFile.Node.Parent.Data);
  end
  else
    FileName := SrcFileName;
  if Assigned(Parent) then
  begin
    // search on parent folder
    SwapFileName := ChangeFileExt(FileName, '.c');
    if Parent.SearchSource(ExtractFileName(SwapFileName), SrcBase) then
    begin
      Assert(SrcBase is TSourceFile);
      Result := True;
      SrcFile :=  TSourceFile(SrcBase);
      SrcFileName := SrcFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.cpp');
    if Parent.SearchSource(ExtractFileName(SwapFileName), SrcBase) then
    begin
      Assert(SrcBase is TSourceFile);
      Result := True;
      SrcFile :=  TSourceFile(SrcBase);
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
      Temp := TProjectFile(HeaderFile.Project).SearchFile(SrcName);
      if Temp = nil then
        Temp := TProjectFile(HeaderFile.Project).SearchFile(ChangeFileExt(SrcName, '.cpp'));
      if Temp <> nil then
      begin
        IncludeList.Free;
        SrcFile := Temp;
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
  Temp: TSourceFile;
  SrcBase: TSourceBase;
  Parent: TSourceBase;
  FileName, SwapFileName, SrcName: string;
  IncludeList: TStringList;
  I: Integer;
begin
  Parent := nil;
  Result := False;
  if (SourceFile <> nil) then
  begin
    if not(SourceFile.FileType in [FILE_TYPE_CPP, FILE_TYPE_C]) then
      Exit;
    FileName := SourceFile.FileName;
    if Assigned(SourceFile.Node.Parent) then
      Parent := TSourceBase(SourceFile.Node.Parent.Data);
  end
  else
    FileName := HdrFileName;
  if Assigned(Parent) then
  begin
    // search on parent folder
    SwapFileName := ChangeFileExt(FileName, '.h');
    if Parent.SearchSource(ExtractFileName(SwapFileName), SrcBase) then
    begin
      Assert(SrcBase is TSourceFile);
      Result := True;
      HdrFile := TSourceFile(SrcBase);
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.hpp');
    if Parent.SearchSource(ExtractFileName(SwapFileName), SrcBase) then
    begin
      Assert(SrcBase is TSourceFile);
      Result := True;
      HdrFile := TSourceFile(SrcBase);
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.hh');
    if Parent.SearchSource(ExtractFileName(SwapFileName), SrcBase) then
    begin
      Assert(SrcBase is TSourceFile);
      Result := True;
      HdrFile := TSourceFile(SrcBase);
      HdrFileName := HdrFile.FileName;
      Exit;
    end;
    SwapFileName := ChangeFileExt(FileName, '.rh');
    if Parent.SearchSource(ExtractFileName(SwapFileName), SrcBase) then
    begin
      Assert(SrcBase is TSourceFile);
      Result := True;
      HdrFile := TSourceFile(SrcBase);
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
      SrcName := ExtractRelativePath
        (ExtractFilePath(SourceFile.Project.FileName),
        ExpandFileName(IncludeList.Strings[I] + SrcName));
      Temp := TProjectFile(SourceFile.Project).GetFileByPathName(SrcName);
      if Temp = nil then
        Temp := TProjectFile(SourceFile.Project).GetFileByPathName
          (ChangeFileExt(SrcName, '.hpp'));
      if Temp = nil then
        Temp := TProjectFile(SourceFile.Project).GetFileByPathName
          (ChangeFileExt(SrcName, '.hh'));
      if Temp = nil then
        Temp := TProjectFile(SourceFile.Project).GetFileByPathName
          (ChangeFileExt(SrcName, '.rh'));
      if Temp <> nil then
      begin
        IncludeList.Free;
        HdrFile := Temp;
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
  Sheet: TSourceFileSheet;
  scope, scopeToken, token: TTokenClass;
  SrcFileName: string;
  CurrentSrcFile, SrcFile: TSourceFile;
  SelStart: Integer;
  Input, Fields, ScopeFlag: string;
  InputError: Boolean;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  CurrentSrcFile := Sheet.SourceFile;
  CurrentTokenFile := FilesParsed.Find(CurrentSrcFile.FileName);
  if (CurrentTokenFile = nil) then
    Exit;
  SelStart := Sheet.Editor.GetSelectionStart;
  SrcFile := CurrentSrcFile;
  SrcFileName := CurrentSrcFile.FileName;
  // get prototype
  if not CurrentTokenFile.GetTokenAt(scopeToken, SelStart) then
  begin
    if not ParseFields(Sheet.Editor.Lines.Text, SelStart, Input, Fields,
      InputError) then
      Exit;
    if not FilesParsed.FindDeclaration(Input, Fields, CurrentTokenFile,
      CurrentTokenFile, CurrentTokenFile, scopeToken, SelStart) then
      Exit;
    SrcFileName := CurrentTokenFile.FileName;
    CurrentSrcFile := TSourceFile(CurrentTokenFile.Data);
  end;
  // only prototype
  scope := GetTokenByName(scopeToken, 'Scope', tkScope);
  if not(scopeToken.token in [tkProtoType, tkConstructor, tkDestructor]) and
    (scope = nil) then
  begin
    if CurrentSrcFile = nil then
    begin
      if FileExists(SrcFileName) then
        CurrentSrcFile := OpenFile(SrcFileName)
      else
        Exit;
    end;
    CurrentSrcFile.Edit;
    SelectToken(scopeToken);
    Exit;
  end;
  ScopeFlag := '';
  if scope <> nil then
    ScopeFlag := scope.Flag;
  { TODO -oMazin -c : get all parent scope 04/05/2013 21:17:55 }
  { TODO -oMazin -c : Search with scope 04/05/2013 21:20:23 }
  if not CurrentTokenFile.SearchToken(scopeToken.name, ScopeFlag, token,
    scopeToken.SelStart, True, [tkFunction, tkConstructor, tkDestructor,
    tkOperator]) then
  begin
    // search on source file
    SrcFile := nil;
    if not SearchImplementationFile(CurrentSrcFile, SrcFile, SrcFileName) then
      Exit;
    SrcTokenFile := FilesParsed.Find(SrcFileName);
    if SrcTokenFile = nil then
      Exit;
    if not SrcTokenFile.SearchToken(scopeToken.name, ScopeFlag, token, 0, True,
      [tkFunction, tkConstructor, tkDestructor, tkOperator]) then
      Exit;
  end;
  // only function implementation
  if GetTokenByName(token, 'Scope', tkScope) = nil then
    Exit;
  if SrcFile = nil then
  begin
    if FileExists(SrcFileName) then
      SrcFile := OpenFile(SrcFileName)
    else
      Exit;
  end;
  SrcFile.Edit;
  SelectToken(token);
end;

procedure TFrmFalconMain.PopEncWithBOMClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.SourceFile.WithBOM := TSpTBXItem(Sender).Checked;
  UpdateStatusbar;
end;

procedure TFrmFalconMain.PopEditorCompClassClick(Sender: TObject);
var
  CurrentTokenFile, SrcTokenFile, ClassTokenFile: TTokenFile;
  Sheet: TSourceFileSheet;
  scope, scopeToken, ParentToken, ClassToken, FuncToken, FuncValue: TTokenClass;
  SrcFileName: string;
  CurrentSrcFile, ClassFile, SrcFile: TSourceFile;
  SelStart, SelLine, I, LastFuncSelEnd, LastPrivFuncLine: Integer;
  BS: TBufferCoord;
  LastLineText, ScopeFlag: string;
  ClassFuncList, FuncList, TODOFuncList: TStrings;
  Editor: TEditor;
  ClassHasFound: Boolean;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  CurrentSrcFile := Sheet.SourceFile;
  CurrentTokenFile := FilesParsed.Find(CurrentSrcFile.FileName);
  if (CurrentTokenFile = nil) then
    Exit;
  BS := Sheet.Editor.CaretXY;
  SelLine := BS.Line;
  if BS.Line > 0 then
  begin
    if BS.Char > (Length(Sheet.Editor.Lines[SelLine - 1]) + 1) then
      BS.Char := Length(Sheet.Editor.Lines[SelLine - 1]) + 1;
  end;
  SelStart := Sheet.Editor.RowColToCharIndex(BS);
  SrcFile := CurrentSrcFile;
  SrcFileName := CurrentSrcFile.FileName;
  // get prototype
  if not CurrentTokenFile.GetScopeAt(scopeToken, SelStart) then
    Exit;
  if (scopeToken.token in [tkVariable]) and Assigned(scopeToken.Parent) and
    (scopeToken.Parent.token in [tkScopeClass]) then
    scopeToken := scopeToken.Parent;
  // only class, struct, union or class function
  if not(scopeToken.token in [tkFunction, tkProtoType, tkConstructor,
    tkDestructor, tkOperator, tkClass, tkStruct, tkUnion]) then
    Exit;
  { TODO -oMazin -c : get all parent scope 04/05/2013 21:17:55 }
  // get parent of Token
  ParentToken := scopeToken;
  if not(scopeToken.token in [tkClass, tkStruct, tkUnion]) then
    ParentToken := scopeToken.Parent;
  if Assigned(ParentToken) and (ParentToken.token in [tkScopeClass]) then
    ParentToken := ParentToken.Parent;
  if (ParentToken <> nil) and not(ParentToken.token in [tkClass, tkStruct,
    tkUnion]) then
    ParentToken := nil;
  scope := GetTokenByName(scopeToken, 'Scope', tkScope);
  ScopeFlag := '';
  if scopeToken.token in [tkClass, tkStruct, tkUnion] then
    ScopeFlag := scopeToken.name
  else if scope <> nil then
    ScopeFlag := scope.Flag;
  // only class, struct, union or class function
  if (ScopeFlag = '') and not(scopeToken.token in [tkClass, tkStruct, tkUnion])
  then
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
        if CurrentSrcFile is TProjectBase then
        begin
          InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [SrcFileName])),
            'Falcon C++', MB_ICONINFORMATION);
          Exit;
        end;
        // change extension to cpp if is a c++ project
        if CurrentSrcFile.Project.CompilerType = COMPILER_CPP then
          SrcFileName := ChangeFileExt(SrcFileName, '.cpp');
        // want to create a source file?
        if CreateTODOSourceFile(SrcFileName, CurrentTokenFile, CurrentSrcFile,
          SrcFile) then
          SwapHeaderSource(CurrentSrcFile, SrcFile);
        Exit
      end
      else
      begin
        SrcTokenFile := FilesParsed.Find(SrcFileName);
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
      CurrentTokenFile, SrcTokenFile, ClassToken, scopeToken.SelStart) then
      ClassHasFound := ClassToken.token in [tkClass, tkStruct, tkUnion];
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
        if CurrentSrcFile is TProjectBase then
        begin
          InternalMessageBox(PChar(Format(STR_FRM_MAIN[34], [SrcFileName])),
            'Falcon C++', MB_ICONINFORMATION);
          Exit;
        end;
        // want to create header file?
        if CreateTODOSourceFile(SrcFileName, CurrentTokenFile, CurrentSrcFile,
          ClassFile) then
          SwapHeaderSource(CurrentSrcFile, ClassFile);
        Exit
      end
      else
      begin
        ClassTokenFile := FilesParsed.Find(SrcFileName);
        if ClassTokenFile = nil then
          Exit;
        SrcTokenFile := CurrentTokenFile;
        if not ClassTokenFile.SearchToken(ScopeFlag, '', ClassToken, 0, True,
          [tkClass, tkStruct, tkUnion]) then
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
      continue;
    scope := GetTokenByName(FuncToken, 'Scope', tkScope);
    if (scope <> nil) and (scope.SelLine > LastFuncSelEnd) then
      LastFuncSelEnd := scope.SelStart + scope.SelLength + 1;
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
        continue;
      end;
    end;
    if (FuncToken.SelLine < LastPrivFuncLine) or
      (FuncToken.Parent.token <> tkScopeClass) or
      (FuncToken.Parent.name <> 'private') then
    begin
      Inc(I);
      continue;
    end;
    LastPrivFuncLine := FuncToken.SelLine;
    Inc(I);
  end;
  if LastPrivFuncLine = 0 then
  begin
    scope := GetTokenByName(ClassToken, 'private', tkScopeClass);
    if (scope <> nil) and (scope.Count > 0) then
      LastPrivFuncLine := scope.Items[scope.Count - 1].SelLine;
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
        continue;
      FuncList.Insert(FuncList.Count, '');
      SelLine := FuncList.Count;
      InsertFunction(FuncToken, FuncList, SelLine, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4);
    end
    else
    begin
      SelLine := ClassFuncList.Count;
      InsertFunction(FuncToken, ClassFuncList, SelLine, Config.Editor.TabWidth,
        Config.Editor.UseTabChar, Config.Editor.StyleIndex = 4, True,
        ClassToken.Level + 1);
    end;
  end;
  if FuncList.Count > 0 then
  begin
    FuncList.Insert(0, '');
    Editor := SrcFile.Edit.Editor;
    if LastFuncSelEnd = -1 then
    begin
      ParentToken := ClassToken.Parent;
      ScopeFlag := '';
      while Assigned(ParentToken) and (ParentToken.token = tkNamespace) do
      begin
        ScopeFlag := ParentToken.name + '::' + ScopeFlag;
        ParentToken := ParentToken.Parent;
      end;
      if ScopeFlag <> '' then
      begin
        if SrcTokenFile.SearchTreeToken(ScopeFlag, scopeToken, [tkNamespace], 0)
        then
        begin
          if scopeToken.Count > 0 then
          begin
            scope := GetTokenByName(scopeToken.Items[scopeToken.Count - 1],
              'Scope', tkScope);
            if (scope <> nil) then
              LastFuncSelEnd := scope.SelStart + scope.SelLength + 1
            else
            begin
              scope := GetTokenByName(scopeToken, 'Scope', tkScope);
              if (scope <> nil) then
                LastFuncSelEnd := scope.SelStart;
            end;
          end;
        end;
      end;
      if LastFuncSelEnd = -1 then
      begin
        // non class function out of class
        LastLineText := '';
        if Editor.Lines.Count > 0 then
          LastLineText := Editor.Lines[Editor.Lines.Count - 1];
        BS := BufferCoord(Length(LastLineText) + 1, Editor.Lines.Count);
        if SrcTokenFile.GetPreviousFunction(FuncToken,
          Editor.RowColToCharIndex(BS)) then
        begin
          scope := GetTokenByName(FuncToken, 'Scope', tkScope);
          if (scope <> nil) then
            LastFuncSelEnd := scope.SelStart + scope.SelLength + 1;
        end;
        if LastFuncSelEnd = -1 then
        begin
          if SrcTokenFile = ClassTokenFile then
          begin
            scope := GetTokenByName(ClassToken, 'Scope', tkScope);
            if (scope <> nil) then
              LastFuncSelEnd := scope.SelStart + scope.SelLength + 2;
          end;
          if LastFuncSelEnd = -1 then
            LastFuncSelEnd := Editor.RowColToCharIndex(BS);
        end;
      end;
    end;
    BS := Editor.CharIndexToRowCol(LastFuncSelEnd);
    Editor.UncollapseLine(BS.Line);
    Editor.BeginUpdate;
    Editor.CaretXY := BS;
    LastLineText := FuncList.Strings[0];
    for I := 1 to FuncList.Count - 1 do
      LastLineText := LastLineText + Editor.GetLineChars + FuncList.Strings[I];
    Editor.SelText := LastLineText;
    Editor.EndUpdate;
  end;
  if ClassFuncList.Count > 0 then
  begin
    ClassFuncList.Insert(0, '');
    if LastPrivFuncLine = 0 then
    begin
      // no private scope
      scope := GetTokenByName(ClassToken, 'Scope', tkScope);
      if scope <> nil then
        LastPrivFuncLine := scope.SelLine;
      ClassFuncList.Insert(1, GetLeftSpacing(Config.Editor.TabWidth *
        ClassToken.Level, Config.Editor.TabWidth, Config.Editor.UseTabChar) +
        'private:');
    end;
    LastLineText := '';
    Editor := ClassFile.Edit.Editor;
    if (LastPrivFuncLine > 0) and (LastPrivFuncLine <= Editor.Lines.Count) then
      LastLineText := Editor.Lines[LastPrivFuncLine - 1];
    BS := BufferCoord(Length(LastLineText) + 1, LastPrivFuncLine);
    Editor.BeginUpdate;
    Editor.UncollapseLine(BS.Line);
    Editor.CaretXY := BS;
    LastLineText := ClassFuncList.Strings[0];
    for I := 1 to ClassFuncList.Count - 1 do
      LastLineText := LastLineText + Editor.GetLineChars +
        ClassFuncList.Strings[I];
    Editor.SelText := LastLineText;
    Editor.EndUpdate;
  end;
  ClassFuncList.Free;
  FuncList.Free;
  TODOFuncList.Free;
  { SrcFile.Edit;
    SelectToken(FuncToken); }
end;

procedure TFrmFalconMain.InvalidateDebugLine;
var
  Sheet: TSourceFileSheet;
  OldActLine: Integer;
begin
  if (DebugActiveLine = 0) or not GetActiveSheet(Sheet) then
    Exit;
  OldActLine := DebugActiveLine;
  DebugActiveLine := 0;
  Sheet.Editor.RemoveActiveLine(OldActLine);
end;

procedure TFrmFalconMain.ToggleBreakpoint(aLine: Integer);
var
  Sheet: TSourceFileSheet;
  fprop: TSourceFile;
  SourcePath, Source: string;
  BreakPoint: TBreakpoint;
  Added: Boolean;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  fprop := Sheet.SourceFile;
  fprop.UpdateBreakpoint;
  if DebugReader.Running then
  begin
    if fprop.BreakPoint.HasBreakpoint(aLine) then
    begin
      BreakPoint := fprop.BreakPoint.GetBreakpoint(aLine);
      DebugReader.SendCommand(GDB_DELETE, IntToStr(BreakPoint.index));
    end
    else
    begin
      SourcePath := ExtractFilePath(fprop.Project.FileName);
      Source := ExtractRelativePath(SourcePath, fprop.FileName);
      Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
      DebugReader.SendCommand(GDB_BREAK, DoubleQuotedStr(Source) + ':' +
        IntToStr(aLine));
    end;
  end;
  Added := fprop.BreakPoint.ToogleBreakpoint(aLine);
  fprop.Project.BreakpointChanged := True;
  if Added then
    Sheet.Editor.AddBreakpoint(aLine)
  else
    Sheet.Editor.DeleteBreakpoint(aLine);
end;

procedure TFrmFalconMain.RunToggleBreakpointClick(Sender: TObject);
var
  Line: Integer;
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Line := Sheet.Editor.CaretY;
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
    if (token.token in [tkVariable]) and (token.SelLine < SelLine) then
    begin
      if AddWatchItem(LastID + 1, token.name, token, wtAuto) then
      begin
        Inc(VarAdded);
        Inc(LastID);
        DebugReader.SendCommand(GDB_DISPLAY, token.name);
      end;
    end;
    if token.token in [tkParams, tkScopeClass] then
    begin
      AddWatchDebugVariables(token, SelLine, LastID, VarAdded);
    end;
  end;
end;

procedure TFrmFalconMain.DeleteDebugVariables;
// var
// I: Integer;
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
  { for I := 0 to WatchList.Count - 1 do
    begin
    DebugReader.SendCommand(GDB_DELETE  + ' ' + GDB_DISPLAY,
    IntToStr(WatchList.Items[I].ID));
    end; }
  WatchList.Clear;
end;

procedure TFrmFalconMain.UpdateDebugActiveVariables(Line: Integer;
  ShowContent: Boolean);
var
  Sheet: TSourceFileSheet;
  scopeToken, thisToken: TTokenClass;
  SelStart: Integer;
  BC: TBufferCoord;
  LastID, I, VarAdded: Integer;
  List: TStrings;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  BC.Line := Line;
  BC.Char := 1;
  VarAdded := 0;
  SelStart := Sheet.Editor.RowColToCharIndex(BC);
  List := TStringList.Create;
  thisToken := nil;
  if not FilesParsed.GetAllTokensOfScope(SelStart, ActiveEditingFile, List,
    thisToken) then
  begin
    List.Free;
    Exit;
  end;
  LastID := DebugReader.LastDisplayID;
  if Assigned(thisToken) and AddWatchItem(LastID + 1, '*this', thisToken, wtAuto)
  then
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

function TFrmFalconMain.AddWatchItem(ID: Integer; const name: string;
  token: TTokenClass; watchType: TWatchType): Boolean;
var
  Item: TWatchVariable;
  NodeObject: TNodeObject;
begin
  Result := False;
  if WatchList.GetIndex(name) >= 0 then
    Exit;
  WatchList.AddWatch(ID, wtAuto, name);
  Item := TWatchVariable.Create;
  Item.name := name;
  Item.token := token;
  Item.watchType := watchType;
  if Assigned(Item.token) then
  begin
    Item.SelLine := Item.token.SelLine;
    Item.SelStart := Item.token.SelStart;
    Item.SelLength := Item.token.SelLength;
  end;
  NodeObject := TNodeObject.Create;
  NodeObject.Data := Item;
  NodeObject.Caption := Item.name;
  TreeViewOutline.AddChild(nil, NodeObject);
  NodeObject.ImageIndex := 0;
  Result := True;
end;

function TFrmFalconMain.SearchAndOpenFile(const FileName: string;
  var fp: TSourceFile): Boolean;
var
  Sheet: TSourceFileSheet;
begin
  Result := False;
  if GetActiveSheet(Sheet) then
  begin
    fp := Sheet.SourceFile;
    if not SameText(fp.FileName, FileName) then
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
// Repaint old active line and draw current debug line

procedure TFrmFalconMain.UpdateActiveDebugLine(fp: TSourceFile; Line: Integer);
var
  Sheet: TSourceFileSheet;
  OldActLine: Integer;
begin
  Sheet := fp.Edit;
  DebugActiveFile := fp;
  OldActLine := DebugActiveLine;
  DebugActiveLine := Line;
  if OldActLine > 0 then
    Sheet.Editor.RemoveActiveLine(OldActLine);
  // make code visible
  if GetForegroundWindow <> Handle then
    SwitchToThisWindow(Handle, False);
  // set cursor position and align line on center of editor
  if DebugActiveLine > 0 then
  begin
    Sheet.Editor.SetActiveLine(DebugActiveLine);
    GotoLineAndAlignCenter(Sheet.Editor, DebugActiveLine);
  end;
end;

procedure TFrmFalconMain.DebugReaderCommand(Sender: TObject; Command: TDebugCmd;
  const name, Value: string; Line: Integer);
var
  Sheet: TSourceFileSheet;
  fp: TSourceFile;
  varID, index: Integer;
  S, FileName: string;
  BreakPoint: TBreakpoint;
  token: TTokenClass;
  dbgc: TDebugCommand;
begin
  // AddMessage(Value, DebugCmdNames[Command] + ' - ' + Name, Value, Line,
  // 0, 0, mitGoto);
  case Command of
    dcBreakpoint:
      begin
        if GetActiveSheet(Sheet) then
        begin
          fp := Sheet.SourceFile;
          S := ExtractFilePath(fp.Project.FileName);
          FileName := ConvertSlashes(S + name);
          if not SameText(fp.FileName, FileName) and
            not SearchSourceFile(FileName, fp) then
          begin
            Exit;
          end;
        end
        else if Assigned(LastProjectBuild) then
        begin
          S := ExtractFilePath(LastProjectBuild.FileName);
          FileName := ConvertSlashes(S + name);
          if not SearchSourceFile(FileName, fp) then
            Exit;
        end
        else
          Exit;
        if fp.BreakPoint.HasBreakpoint(Line) then
        begin
          BreakPoint := fp.BreakPoint.GetBreakpoint(Line);
          BreakPoint.index := StrToInt(Value);
          // AddItemMsg('breakpoint set index', Value, Line);
        end;
      end;
    dcLocalize:
      begin
        if not SearchAndOpenFile(name, fp) then
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
          BreakPoint := LastProjectBuild.BreakpointCursor;
          if BreakPoint.Valid and (BreakPoint.Line = Line) and
            SameText(BreakPoint.FileName, name) then
          begin
            DebugReader.SendCommand(GDB_DELETE, Value);
            LastProjectBuild.BreakpointCursor.Valid := False;
          end;
        end;
        if DebugReader.FunctionChanged then
          DeleteDebugVariables;
        UpdateDebugActiveVariables(Line);
        DebugReader.SendCommand(GDB_DISPLAY);
        // DebugReader.SendCommand(GDB_INFO, GDB_DISPLAY);
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
          if CommandQueue.Front.VarName = name then
            CommandQueue.Dequeue;
        end;
        DebugHint.Cancel;
        CanShowHintTip := False;
        CommandQueue.Clear;
      end;
    dcNextLine:
      begin
        if not SearchAndOpenFile(name, fp) then
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
        index := WatchList.GetIndex(Line);
        if index < 0 then
          index := WatchList.UpdateID(name, Line);
        if index >= 0 then
          DebugParser.Fill(name + ' = ' + Value, nil);
        CommandQueue.Clear;
      end;
    dcPrint:
      begin
        if not GetActiveSheet(Sheet) or CommandQueue.Empty then
          Exit;
        dbgc := CommandQueue.Front;
        fp := Sheet.SourceFile;
        S := dbgc.VarName + ' = ' + Value;
        varID := StrToInt(name);
        if varID <> dbgc.ID then
        begin
          // AddItemMsg('Diff ID of ' + dbgc.VarName,
          // Format('%d = %d? ' + Value, [varID, dbgc.ID]), Line);
        end;
        token := TTokenClass(dbgc.Data);
        case dbgc.CmdType of
          dctPrint:
            begin
              DebugHint.UpdateHint(S, dbgc.Point.X,
                dbgc.Point.Y + Sheet.Editor.LineHeight + 6, token);
            end;
          dctAutoWatch: // not used
            begin
            end;
        end;
        // delete dbgc also
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

procedure TFrmFalconMain.DebugReaderFinish(Sender: TObject; ExitCode: Integer);
var
  Sheet: TSourceFileSheet;
begin
  if GetActiveSheet(Sheet) then
  begin
    Sheet.Editor.RemoveActiveLine(DebugActiveLine);
    DebugActiveLine := 0;
  end;
  DebugParser.Clear;
  DebugHint.Cancel;
  DebugActiveFile := nil;
  CommandQueue.Clear;
  WatchList.Clear;
  TreeViewOutline.Images := ImgListOutLine;
  TSOutline.Caption := STR_FRM_MAIN[3];
  RestoreOutline;
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
  // TreeViewOutline.Indent := ImageListDebug.Width + 3;
end;

procedure TFrmFalconMain.DecLoading;
begin
  if FLoadingCount <= 0 then
    Exit;
  Dec(FLoadingCount);
  if (FLoadingCount = 0) and (FTriggerOnLoading > 0) then
    RestoreOutline;
  FTriggerOnLoading := 0;
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
  DebugReader.SendCommand(GDB_REVERSE + '-' + GDB_CONTINUE);
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
  DebugReader.SendCommand(GDB_REVERSE + '-' + GDB_STEP);
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
  DebugReader.SendCommand(GDB_REVERSE + '-' + GDB_NEXT);
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
  DebugReader.SendCommand(GDB_REVERSE + '-' + GDB_FINISH);
end;

procedure TFrmFalconMain.SelectTheme(Theme: string);
begin
  if SkinManager.SkinsList.IndexOf(Theme) < 0 then
    Theme := OFFICE_XP_THEME;
  SkinManager.SetSkin(Theme);
  Config.Environment.Theme := Theme;
  Color := SkinManager.CurrentSkin.ColorBtnFace;
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
begin
  SelectTheme(SkinManager.CurrentSkinName);
end;

procedure TFrmFalconMain.PupMsgClearClick(Sender: TObject);
begin
  ListViewMsg.Clear;
end;

procedure TFrmFalconMain.RunRuntoCursorClick(Sender: TObject);
var
  ProjProp: TProjectBase;
  SourceFile: TSourceFile;
  Sheet: TSourceFileSheet;
  SourcePath, Source: string;
begin
  if GetActiveSheet(Sheet) then
  begin
    SourceFile := Sheet.SourceFile;
    ProjProp := SourceFile.Project;
    ProjProp.BreakpointChanged := True;
    ProjProp.BreakpointCursor.Line := Sheet.Editor.CaretY;
    ProjProp.BreakpointCursor.Valid := True;
    ProjProp.BreakpointCursor.FileName := SourceFile.FileName;
    if DebugReader.Running then
    begin
      SourcePath := ExtractFilePath(ProjProp.FileName);
      Source := ExtractRelativePath(SourcePath, SourceFile.FileName);
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
  ProjectBase: TProjectBase;
  I: Integer;
  FindedTokenFile: TTokenFile;
begin
  List := TStringList.Create;
  Node := TreeViewProjects.Items.GetFirstNode;
  Files := TStringList.Create;
  while Node <> nil do
  begin
    ProjectBase := TProjectBase(Node.Data);
    Files.Clear;
    ProjectBase.GetSources(Files, SOURCE_TYPES);
    for I := 0 to Files.Count - 1 do
    begin
      FindedTokenFile := FilesParsed.Find(Files.Strings[I]);
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
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  if Sheet.Editor.Lines.Count < 3 then
    Exit;
  FormGotoLine := TFormGotoLine.CreateParented(Handle);
  FormGotoLine.ShowWithRange(1, Sheet.Editor.CaretY, Sheet.Editor.Lines.Count);
end;

procedure TFrmFalconMain.SearchGotoPrevFuncClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  fprop: TSourceFile;
  TokenFile: TTokenFile;
  token: TTokenClass;
  Buffer: TBufferCoord;
  FindedTokenFile: TTokenFile;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  fprop := Sheet.SourceFile;
  FindedTokenFile := FilesParsed.Find(fprop.FileName);
  if FindedTokenFile = nil then
    Exit;
  TokenFile := FindedTokenFile;
  if not TokenFile.GetPreviousFunction(token, Sheet.Editor.SelStart) then
    Exit;
  token := GetTokenByName(token, 'Scope', tkScope);
  Buffer := Sheet.Editor.CharIndexToRowCol(token.SelStart);
  GotoLineAndAlignCenter(Sheet.Editor, Buffer.Line, Buffer.Char);
end;

procedure TFrmFalconMain.SearchGotoNextFuncClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
  fprop: TSourceFile;
  TokenFile: TTokenFile;
  token: TTokenClass;
  Buffer: TBufferCoord;
  FindedTokenFile: TTokenFile;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  fprop := Sheet.SourceFile;
  FindedTokenFile := FilesParsed.Find(fprop.FileName);
  if FindedTokenFile = nil then
    Exit;
  TokenFile := FindedTokenFile;
  if not TokenFile.GetNextFunction(token, Sheet.Editor.SelStart) then
    Exit;
  token := GetTokenByName(token, 'Scope', tkScope);
  Buffer := Sheet.Editor.CharIndexToRowCol(token.SelStart);
  GotoLineAndAlignCenter(Sheet.Editor, Buffer.Line, Buffer.Char);
end;

procedure TFrmFalconMain.PopupProjectPopup(Sender: TObject);
begin
  UpdateMenuItems([rmProjectsPopup]);
  PluginManager.DispachCommand(Cmd_Popup, POPUPMENU_PROJECT, 0, nil);
end;

procedure TFrmFalconMain.TreeViewOutlineGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeObject: TNodeObject;
begin   
  if (Kind in [ikState, ikOverlay]) then
    Exit;
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  if NodeObject.Data = nil then
    Exit;
  ImageIndex := NodeObject.ImageIndex;
end;

procedure TFrmFalconMain.TreeViewOutlineDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  if not DebugReader.Running and Assigned(NodeObject.Data) then
  begin
    PaintTokenItemV2(TargetCanvas, CellRect, TTokenClass(NodeObject.Data),
      Sender.Selected[Node], Sender.FocusedNode = Node, DefaultDraw);
    // DefaultDraw := False;
  end;
end;

procedure TFrmFalconMain.TreeViewOutlineGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  CellText := NodeObject.Caption;
end;

procedure TFrmFalconMain.TreeViewOutlineFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeObject: TNodeObject;
begin
  NodeObject := TNodeObject(Sender.GetNodeData(Node)^);
  NodeObject.Free;
end;

procedure TFrmFalconMain.TreeViewOutline_DblClick(Sender: TObject);
var
  token: TTokenClass;
  Node: PVirtualNode;
begin
  Node := TreeViewOutline.GetFirstSelected;
  if Node = nil then
    Exit;
  token := TTokenClass(TNodeObject(TreeViewOutline.GetNodeData(Node)^).Data);
  if token.token in [tkIncludeList, tkDefineList, tkTreeObjList, tkVarConsList,
    tkFuncProList] then
    Exit;
  if not DebugReader.Running then
    SelectToken(token);
end;

procedure TFrmFalconMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if [ssShift] = Shift then
  begin
    // reverse debugging shortcuts
    if      Key = VK_F6 then
      RunRevStepReturnClick(Sender)
    else if Key = VK_F7 then
      RunRevStepIntoClick(Sender)
    else if Key = VK_F8 then
      RunRevStepOverClick(Sender)
    else if Key = VK_F9 then
      RunRevContinue(Sender);
  end
  else if [ssCtrl] = Shift then
  begin
    if Key = VK_F4 then
    begin
      Key := 0;
      FileCloseClick(Sender);
    end;
  end;
end;

procedure TFrmFalconMain.SysCommandProc(var Msg: TWMSysCommand);
begin
  case Msg.CmdType of
    SC_SCREENSAVE, // Screensaver Trying To Start?
    SC_MONITORPOWER: // Monitor Trying To Enter Powersave?
      begin
        if FrmPos.FullScreen then
        begin
          Msg.Result := 0; // Prevent From Happening
          Exit;
        end;
      end;
  end;
  inherited;
end;

procedure TFrmFalconMain.SelectFromSelStart(SelStart, SelCount: Integer;
  Editor: TEditor);
var
  BS, BE: TBufferCoord;
begin
  BS := Editor.CharIndexToRowCol(SelStart);
  BE := Editor.CharIndexToRowCol(SelStart + SelCount);
  Editor.SetCaretAndSelection(BE, BS, BE);
end;

procedure TFrmFalconMain.SelectFromPosition(SelStart, SelEnd: Integer;
  Editor: TEditor);
begin
  Editor.SetSelectionStart(SelStart);
  Editor.SetSelectionEnd(SelEnd);
  Editor.SetCurrentPos(SelEnd);
  Editor.EnsureRangeVisible(SelStart, SelEnd);
  Editor.TopLine := Editor.LineFromPosition(SelStart) -
    (Editor.LinesInWindow div 2) + 1;
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
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.Editor.CollapseAll;
end;

procedure TFrmFalconMain.EditUncollapseAllClick(Sender: TObject);
var
  Sheet: TSourceFileSheet;
begin
  if not GetActiveSheet(Sheet) then
    Exit;
  Sheet.Editor.UncollapseAll;
end;

procedure TFrmFalconMain.MenuBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CodeCompletion.CancelCompletion;
end;

end.
