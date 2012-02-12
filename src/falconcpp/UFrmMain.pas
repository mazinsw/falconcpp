unit UFrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Menus, XPMan, ImgList, ExtCtrls, RzSplit, RzPanel, RzTabs,
  SynHighlighterCpp, RzButton, RzStatus, RzCommon, SynEditHighlighter,
  ShellApi, SynHighlighterRC, SynMemo, SynEdit, UConfig, UTemplates,
  SendData, OutputConsole, SynEditKeyCmds, ShlObj, FormEffect, PNGImage,
  UFileProperty, Clipbrd, SynCompletionProposal, UUtils, UFrmEditorOptions,
  FileDownload, SynEditTypes, SplashScreen, FormPosition, StrUtils,
  TBXExtItems, TB2Item, TBX, TB2Dock, TB2Toolbar, TBXSwitcher, TBXOfficeXPTheme,
  TBXOffice11AdaptiveTheme, IniFiles, SynEditMiscClasses,
  SynEditSearch, AppEvnts, ThreadTokenFiles, CppParser, TokenConst, TokenFile,
  TokenHint, TokenList, TokenUtils, SynEditAutoComplete, SynEditPrint,
  SynEditRegexSearch, CommCtrl, DebugReader, SynExportRTF, CommandQueue,
  SynEditExport, SynExportHTML, SynExportTeX, ThreadLoadTokenFiles, DebugConsts,
  XMLDoc, XMLIntf;

const
  TreeImages: array[0..26] of Integer = (
    0,  //Include List
    1,  //include
    2,  //Define List
    18, //define
    3,  //Variables and Constants List
    9,  //public variable
    10,  //private variable
    11, //protected variable
    3,  //Function and Prototype List
    15, //public function
    16, //private function
    17, //protected function
    14, //prototype
    3,  //Type List
    4,  //class
    5,  //struct
    6,  //union
    7,  //enum
    19, //namespace
    20, //typedef
    5,  //typedef struct
    6,  //typedef union
    7,  //typedef enum
    21,  //Enum Item
    8,  //typedef prototype
    12, //constructor
    13  //destructor
  );
  WM_RELOADFTM = WM_USER + $1008;
  MINLINE_TOENABLE_GOTOLINE = 3;

type
  TSearchItem = record
    Search: String;
    DiffCase: Boolean;
    FullWord: Boolean;
    CircSearch: Boolean;
    SearchMode: Integer;
    Direction: Boolean;
    Transparence: Boolean;
    Opacite: Integer;
  end;

  //Outline objects images
  TOutlineImages = array[TTkType] of Integer;

  TFrmFalconMain = class(TForm)
    XPManifest: TXPManifest;
    TreeViewProjects: TTreeView;
    RSPExplorer: TRzSizePanel;
    RSPEditor: TRzSizePanel;
    RSPOLine: TRzSizePanel;
    RSPCmd: TRzSizePanel;
    RPCExplorer: TRzPageControl;
    TSProjects: TRzTabSheet;
    TSExplorer: TRzTabSheet;
    RPExplorer: TRzPanel;
    PanelEditor: TRzPanel;
    PageControlEditor: TRzPageControl;
    CppHighligher: TSynCppSyn;
    RPOLine: TRzPanel;
    PageControlOutline: TRzPageControl;
    TSOLine: TRzTabSheet;
    TreeViewOutline: TTreeView;
    ListViewMsg: TListView;
    RPCmd: TRzPanel;
    PageControlMsg: TRzPageControl;
    TSMgs: TRzTabSheet;
    RzStatusBar: TRzStatusBar;
    PanelActiveFile: TRzGlyphStatus;
    PanelFileDesc: TRzGlyphStatus;
    OpenDlg: TOpenDialog;
    ResourceHighlighter: TSynRCSyn;
    PanelRowCol: TRzStatusPane;
    SendData: TSendData;
    CompilerCmd: TOutputConsole;
    PanelCompStatus: TRzGlyphStatus;
    CodeCompletion: TSynCompletionProposal;
    TimerStartUpdate: TTimer;
    UpdateDownload: TFileDownload;
    TreeView1: TTreeView;
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
    SubNNewProject: TTBXItem;
    SubNNewCFile: TTBXItem;
    SubNNewCppFile: TTBXItem;
    SubNNewHeaderFile: TTBXItem;
    SubNNewResFile: TTBXItem;
    SubNNewEmptyFile: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    SubNNewFolder: TTBXItem;
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
    TBXItem70: TTBXItem;
    TBXSeparatorItem16: TTBXSeparatorItem;
    SearchGotoFunction: TTBXItem;
    SearchGotoLine: TTBXItem;
    MenuView: TTBXSubmenuItem;
    ViewProjMan: TTBXItem;
    ViewStatusBar: TTBXItem;
    ViewCompOut: TTBXItem;
    ViewOutline: TTBXItem;
    ViewToolbar: TTBXSubmenuItem;
    TBXItem52: TTBXItem;
    TBXItem73: TTBXItem;
    TBXItem55: TTBXItem;
    TBXItem61: TTBXItem;
    TBXItem8: TTBXItem;
    TBXItem77: TTBXItem;
    TBXItem79: TTBXItem;
    SbMnThemes: TTBXSubmenuItem;
    ViewThemeDef: TTBXItem;
    ViewThemeOffAdpt: TTBXItem;
    ViewThemeOffXP: TTBXItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
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
    TBXItem49: TTBXItem;
    TBXItem48: TTBXItem;
    TBXItem43: TTBXItem;
    TBXSeparatorItem18: TTBXSeparatorItem;
    TBXItem86: TTBXItem;
    TBXItem72: TTBXItem;
    TBXSeparatorItem19: TTBXSeparatorItem;
    TBXItem87: TTBXItem;
    MenuHelp: TTBXSubmenuItem;
    TBXItem90: TTBXItem;
    TBXSeparatorItem11: TTBXSeparatorItem;
    TBXItem40: TTBXItem;
    TBXItem5: TTBXItem;
    TBXSeparatorItem13: TTBXSeparatorItem;
    TBXItem39: TTBXItem;
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
    TBXItem1: TTBXItem;
    SearchBar: TTBXToolbar;
    BtnFind: TTBXItem;
    BtnReplace: TTBXItem;
    BtnGotoLN: TTBXItem;
    TBXSeparatorItem29: TTBXSeparatorItem;
    HelpFalcon: TTBXSubmenuItem;
    TBXItem2: TTBXItem;
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
    EditorBookmarks: TTBXSubmenuItem;
    EditorGotoBookmarks: TTBXSubmenuItem;
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
    EditorSearch: TSynEditSearch;
    ProgressStatusParser: TRzProgressStatus;
    TimerHintTipEvent: TTimer;
    ApplicationEvents: TApplicationEvents;
    TimerHintParams: TTimer;
    FilePrint: TTBXItem;
    TBXSeparatorItem38: TTBXSeparatorItem;
    EditorPrint: TSynEditPrint;
    PrintDialog: TPrintDialog;
    EditorRegexSearch: TSynEditRegexSearch;
    FileRemove: TTBXItem;
    EditUnindent: TTBXItem;
    EditDelete: TTBXItem;
    ExporterHTML: TSynExporterHTML;
    ExporterRTF: TSynExporterRTF;
    FileExportTeX: TTBXItem;
    ExporterTeX: TSynExporterTeX;
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
    PopEditorFindDecl: TTBXItem;
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure ProjectPropertiesClick(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FalconHelpClick(Sender: TObject);
    procedure TreeViewProjectsChange(Sender: TObject; Node: TTreeNode);
    procedure EditFileClick(Sender: TObject);
    procedure TextEditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure RemoveClick(Sender: TObject);
    procedure SubMUndoClick(Sender: TObject);
    procedure SubMRedoClick(Sender: TObject);
    procedure SubMCutClick(Sender: TObject);
    procedure SubMCopyClick(Sender: TObject);
    procedure SubMPasteClick(Sender: TObject);
    procedure TreeViewProjectsDblClick(Sender: TObject);
    procedure PageControlEditorClose(Sender: TObject; var AllowClose: Boolean);
    procedure SaveExtensionChange(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure TreeViewProjectsKeyPress(Sender: TObject; var Key: Char);
    procedure PageControlEditorChange(Sender: TObject);
    procedure EditorBeforeCreate(FileProp: TFileProperty);
    procedure FileCloseClick(Sender: TObject);
    procedure SubMExecuteClick(Sender: TObject);
    procedure TreeViewProjectsEnter(Sender: TObject);
    procedure PageControlEditorPageChange(Sender: TObject);
    procedure SubMRunClick(Sender: TObject);
    procedure LauncherFinished(Sender: TObject);
    procedure SubMStopClick(Sender: TObject);
    procedure BtnPreviousPageClick(Sender: TObject);
    procedure BtnNextPageClick(Sender: TObject);
    procedure TreeViewProjectsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TreeViewProjectsClick(Sender: TObject);
    procedure SubMCompileClick(Sender: TObject);
    procedure SubMSelectAllClick(Sender: TObject);
    procedure SubMBuildClick(Sender: TObject);
    procedure TreeViewProjectsEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure TreeViewProjectsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopProjRenameClick(Sender: TObject);
    procedure PopProjOpenClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileCloseAllClick(Sender: TObject);
    procedure ToolsClick(Sender: TObject);
    procedure SendDataCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure ReloadTemplates(var message: TMessage); message WM_RELOADFTM;
    procedure TreeViewProjectsProc(var Msg: TMessage);
    procedure TreeViewOutlineProc(var Msg: TMessage);
    procedure PageControlEditorProc(var Msg: TMessage);
    procedure PanelEditorProc(var Msg: TMessage);
    procedure GetDropredFiles(Sender: TObject; var Msg: TMessage);
    procedure OnDragDropFiles(Sender: TObject; Files:TStrings);
    procedure CompilerCmdStart(Sender: TObject; const FileName,
      Params: String);
    procedure CompilerCmdFinish(Sender: TObject; const FileName,
      Params: String; ConsoleOut: TStrings; ExitCode: Integer);
    procedure ListViewMsgDblClick(Sender: TObject);
    procedure PopProjDelFromDskClick(Sender: TObject);
    procedure ProjectAddClick(Sender: TObject);
    procedure SubMRemoveClick(Sender: TObject);
    procedure SubMUpdateClick(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure ListViewMsgDeletion(Sender: TObject; Item: TListItem);
    procedure Originalmessage1Click(Sender: TObject);
    procedure ListViewMsgSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Copyoriginalmessage1Click(Sender: TObject);
    procedure FileSaveAllClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure TextEditorGutterClick(Sender: TObject; Button: TMouseButton;
      X, Y, Line: Integer; Mark: TSynEditMark);
    procedure TextEditorGutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure TextEditorSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure TextEditorChange(Sender: TObject);
    procedure TextEditorEnter(Sender: TObject);
    procedure TextEditorExit(Sender: TObject);
    procedure TextEditorAllAction(Sender: TObject);
    procedure TextEditorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TextEditorLinkClick(Sender: TObject; S, AttriName,
      FirstWord: String);
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
    procedure TimerStartUpdateTimer(Sender: TObject);
    procedure UpdateDownloadFinish(Sender: TObject; Canceled: Boolean);
    procedure TreeViewProjectsAddition(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure RestoreDefault1Click(Sender: TObject);
    procedure EnvironOptions1Click(Sender: TObject);
    procedure CompilerOptions2Click(Sender: TObject);
    procedure EditorOptions1Click(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure ReportaBugorComment1Click(Sender: TObject);
    procedure Packages1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ViewMenuClick(Sender: TObject);
    procedure NewItemClick(Sender: TObject);
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
    procedure FindMenuClick(Sender: TObject);
    procedure ReplaceMenuClick(Sender: TObject);
    procedure PageControlEditorContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure EditorContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure FindFilesMenuClick(Sender: TObject);
    procedure FindNextMenuClick(Sender: TObject);
    procedure FindPrevMenuClick(Sender: TObject);
    procedure TreeViewOutlineDblClick(Sender: TObject);
    procedure ParserStart(Sender: TObject);
    procedure ParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: String; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure AllParserProgress(Sender: TObject; TokenFile: TTokenFile;
      const FileName: String; Current, Total: Integer; Parsed: Boolean;
      Method: TTokenParseMethod);
    procedure AllParserFinish(Sender: TObject);
    procedure ParserFinish(Sender: TObject);
    procedure TimerHintTipEventTimer(Sender: TObject);
    procedure CodeCompletionExecute(Kind: TSynCompletionType;
      Sender: TObject; var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure CodeCompletionCodeCompletion(Sender: TObject;
      var Value: String; Shift: TShiftState; Index: Integer;
      EndToken: Char);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure TreeViewOutlineAdvancedCustomDrawItem(
      Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure TimerHintParamsTimer(Sender: TObject);
    procedure ViewCompOutClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure PageControlMsgClose(Sender: TObject;
      var AllowClose: Boolean);
    procedure PupMsgGotoLineClick(Sender: TObject);
    procedure SendDataReceivedStream(Sender: TObject;
      Value: TMemoryStream);
    procedure PageControlEditorDblClick(Sender: TObject);
    procedure PopEditorDeleteClick(Sender: TObject);
    procedure FileExportHTMLClick(Sender: TObject);
    procedure FileExportRTFClick(Sender: TObject);
    procedure FileExportTeXClick(Sender: TObject);
    procedure PopTabsCloseAllOthersClick(Sender: TObject);
    procedure PopTabsTabsAtTopClick(Sender: TObject);
    procedure PopTabsTabsAtBottomClick(Sender: TObject);
    procedure EditSwapClick(Sender: TObject);
    procedure PopupTabsPopup(Sender: TObject);
    procedure PageControlEditorTabClick(Sender: TObject);
    procedure PageControlEditorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnHelpClick(Sender: TObject);
    procedure EditFormatClick(Sender: TObject);
    procedure EditIndentClick(Sender: TObject);
    procedure EditUnindentClick(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure PopEditorFindDeclClick(Sender: TObject);
    procedure RunToggleBreakpointClick(Sender: TObject);
    //*********** debug ************************//
    procedure DebugReaderStart(Sender: TObject);
    procedure DebugReaderCommand(Sender: TObject; Command: TDebugCmd;
      const Name, Value: String; Line: Integer);
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
    //**********************************************/
  private
    { Private declarations }
    fWorkerThread           : TThread;//scan current file
  public
    { Public declarations }
    //accept drag drop
    TreeViewProjectsOldProc : TWndMethod;
    PageControlEditorOldProc: TWndMethod;
    PanelEditorOldProc      : TWndMethod;
    TreeViewOutlineOldProc  : TWndMethod;

    //config, resources, sintax
    OutlineImages           : TOutlineImages;
    SintaxList              : TSintaxList;//highlighter list
    Config                  : TConfig;//window objects positions, zoom, etc.
    Templates               : TTemplates;//all falcon c++ templates

    //paths
    AppRoot                 : String;//path of executable
    CompilerActiveMsg       : String;//Caption compiler info
    ConfigRoot              : String;//directory configuration
    IniConfigFile           : String;//file configuration
    Compiler_Path           : String;//path of compiler
    //flags
    IsLoading               : Boolean;
    ShowingReloadEnquiry    : Boolean;
    RunNow                  : Boolean;//?
    ActDropDownBtn          : Boolean;//?
    XMLOpened               : Boolean;
    CompStoped              : Boolean;
    FullScreenMode          : Boolean;
    CanShowHintTip          : Boolean;
    LastKeyPressed          : Char;
    CanFillCompletion       : Boolean;
    CurrentFileIsParsed     : Boolean;
    LastMousePos            : TPoint;
    LastWordHintStart       : Integer;
    //for ThreadTokenFiles
    IsLoadingSrcFiles       : Boolean;
    LoadTokenMode           : Integer;
    ParseAllCloseApp        : Boolean;

    FalconVersion           : TVersion;//this file version
    LastProjectBuild        : TProjectProperty;
    LastSearch              : TSearchItem;
    ZoomEditor              : Integer;//edit zoom
    ActiveEditingFile       : TTokenFile;//last parsed tokens
    FilesParsed             : TTokenFiles;//all files parsed
    //for Project
    ThreadFilesParsed       : TThreadTokenFiles;
    AllParsedList           : TStrings;
    //for Cache
    ParseAllFiles           : TTokenFiles;//parse unparsed static files
    ThreadLoadTkFiles       : TThreadLoadTokenFiles;
    ThreadTokenFiles        : TThreadTokenFiles;
    HintTip                 : TTokenHintTip;//mouse over hint
    HintParams              : TTokenHintParams;
    AutoComplete: TSynAutoComplete;//auto complete
    //debug
    DebugReader: TDebugReader;
    CommandQueue: TCommandQueue;
    DebugActiveLine: Integer;
    DebugActiveFile: TFileProperty;
    //Completion List Colors
    CompletionColors: TCompletionColors;
    //functions
    procedure SelectTheme(Theme: String);
    procedure ToggleBreakpoint(aLine: Integer);
    procedure CheckIfFilesHasChanged;
    procedure DetectScope(Memo: TSynMemo);
    function RemoveFile(FileProp: TFileProperty): Boolean;
    procedure UpdateCompletionColors(EdtOpt: TEditorOptions);
    procedure ParseFiles(List: TStrings);
    procedure ParseProjectFiles(Proj: TProjectProperty);
    function GetSourcesFiles(List: TStrings): Integer;
    function GetSelectedFileInList(var ActiveFile: TFileProperty): Boolean;
    function GetActiveProject(var Project: TProjectProperty): Boolean;
    function GetActiveFile(var ActiveFile: TFileProperty): Boolean;
    function GetActiveSheet(var sheet: TFilePropertySheet): Boolean;
    function FileInHistory(const FileName: String;
      var HistCount: Integer): Boolean;
    function RenameFileInHistory(const FileName,
      NewFileName: String): Boolean;
    function AddFileToHistory(const FileName: String): Boolean;
    function OpenFileWithHistoric(Value: String;
      var Proj: TProjectProperty): Boolean;
    procedure RemoveFileFromHistoric(FileName: String);
    procedure UpdateLangNow;
    procedure TextEditorFileParsed(EditFile: TFileProperty;
      TokenFile: TTokenFile);
    procedure UpdateOpenedSheets;
    function ImportDevCppProject(const FileName: String): Boolean;
    function ImportCodeBlocksProject(const FileName: String): Boolean;
    function ImportMSVCProject(const FileName: String): Boolean;
    procedure ToolbarCheck(const Index: Integer; const Value: Boolean);
    procedure DropFilesIntoProjectList(List: TStrings; X, Y: Integer);
    //outline functions
    procedure UpdateActiveFileToken(NewToken: TTokenFile;
      Reload: Boolean = False);
    //hint functions
    procedure ProcessDebugHint(Input: String; Line, SelStart: integer;
      CursorPos: TPoint);
    procedure AddItemMsg(const Title, Msg: String; Line: Integer);
    procedure GotoLineAndAlignCenter(Memo: TSynMemo; Line: Integer;
      Col: Integer = 1);
    procedure SelectToken(Token: TTokenClass);
    procedure ShowHintParams(Memo: TSynMemo);
    procedure ProcessHintView(FileProp: TFileProperty;
      Memo: TSynMemo; const X, Y: Integer);
    procedure PaintTokenItem(const ToCanvas: TCanvas;
      DisplayRect: TRect; Token: TTokenClass; State: TCustomDrawState);
  end;

  { TParserThread }

  TParserThread = class(TThread)
  private
    fLastPercent     : Integer;
    fScanEventHandle : THandle;
    fSourceChanged   : Boolean;
    fSource          : String;
    fStartTime       : Cardinal;
    fParseTime       : Cardinal;
    fTokenFile       : TTokenFile;
    fHasParsed       : Boolean;
    fCppParser       : TCppParser;
    fMsg             : String;
    fCurrLine        : Integer;
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
    procedure SetModified;//actual files has modified
    procedure Shutdown;
    property CppParser: TCppParser read fCppParser write fCppParser;
    property TokenFile: TTokenFile read fTokenFile write fTokenFile;
  end;

var
  FrmFalconMain: TFrmFalconMain;

implementation

uses
  UFrmSobre, UFrmNew, UFrmProperty, ExecWait, Math, UTools, UFrmRemove,
  UParseMsgs, UFrmUpdate, ULanguages, UFrmEnvOptions, UFrmCompOptions,
  UFrmReport, UFrmFind, AStyle, BreakPoint, UFrmGotoFunction, UFrmGotoLine;

{$R *.dfm}
{$R resources.res}

procedure FillTreeView(TreeView: TTreeView; Node: TTreeNode; Token: TTokenClass);
var
  I: Integer;
  Mode: TTokenSearchMode;
begin
  Mode := [];
  if Token.Token = tkTreeObjList then
    if Token.Count <= 25 then
      Mode := Mode + [tkTreeObjList];
  if Token.Token = tkVarConsList then
    if Token.Count <= 25 then
      Mode := Mode + [tkVarConsList];
  if Token.Token = tkFuncProList then
    if Token.Count <= 25 then
      Mode := Mode + [tkFuncProList];

  if not (Token.Token in Mode) and
    not ((Token.Token in [tkIncludeList, tkDefineList, tkParams, tkScope,
    tkScopeClass]) and (Token.Count = 0)) then
  begin
    if not (Token.Token in [tkParams, tkScope, tkScopeClass, tkUsing]) then
    begin
      if Token.Token in [tkFunction, tkProtoType, tkConstructor, tkDestructor] then
      begin
        if Token.Token in [tkConstructor, tkDestructor] then
          Node := TreeView.Items.AddChildObject(Node,  GetFuncScope(Token) +
            Token.Name + GetFuncProtoTypes(Token), Token)
        else
          Node := TreeView.Items.AddChildObject(Node, Token.Name +
            GetFuncProtoTypes(Token) + ' : ' + Token.Flag, Token);
      end
      else
        Node := TreeView.Items.AddChildObject(Node, Token.Name, Token);
      Token.Data := Node;
      Node.ImageIndex := GetTokenImageIndex(Token, TreeImages);
      Node.SelectedIndex := Node.ImageIndex;
    end;
  end;
  if not (Token.Token in [tkParams, tkScope, tkFunction,
    tkConstructor, tkDestructor]) then
  begin
    for I := 0 to Token.Count - 1 do
      FillTreeView(TreeView, Node, Token.Items[I]);
  end;
end;

procedure FillStaticTreeView(TreeView: TTreeView; Parent,
  Node: TTreeNode; Token: TTokenClass);
var
  I: Integer;
  NextSibling: TTreeNode;
  S: String;
begin
  for I := 0 to Token.Count - 1 do
  begin
    if not (Token.Items[I].Token in [tkParams, tkScope, tkScopeClass, tkUsing]) then
    begin
      if Token.Items[I].Token in [tkFunction, tkProtoType, tkConstructor, tkDestructor] then
      begin
        if Token.Items[I].Token in [tkConstructor, tkDestructor] then
        begin
          S := GetFuncScope(Token.Items[I]) + Token.Items[I].Name +
            GetFuncProtoTypes(Token.Items[I]);
        end
        else
        begin
          S := Token.Items[I].Name + GetFuncProtoTypes(Token.Items[I]) + ' : ' +
            Token.Items[I].Flag;
        end;
      end
      else
        S := Token.Items[I].Name;
      //create a new node
      if not Assigned(Node) then
        Node := TreeView.Items.AddChildObject(Parent, S, Token.Items[I])
      else
      begin//update node
        Node.Data := Token.Items[I];
        Node.Text := S;//redraw
      end;
      Token.Items[I].Data := Node;
      Node.ImageIndex := GetTokenImageIndex(Token.Items[I], TreeImages);
      Node.SelectedIndex := Node.ImageIndex;
      if not (Token.Items[I].Token in [tkFunction, tkConstructor, tkDestructor]) then
      begin
        FillStaticTreeView(TreeView, Node, Node.getNextSibling, Token.Items[I]);
      end;
      Node := Node.getNextSibling;
    end
    else
    begin
      if (Token.Items[I].Token in [tkScopeClass]) then
      begin
        FillStaticTreeView(TreeView, Parent, Node, Token.Items[I]);
        //bug?
      end;
    end;
  end;
  if Assigned(Node) then
  begin
    NextSibling := Node.getNextSibling;
    while Assigned(NextSibling) do
    begin
      if Assigned(NextSibling) then
        NextSibling.Delete;
      NextSibling := Node.getNextSibling;
    end;
    Node.Delete;
  end;
end;

procedure FillTokenFileTreeView(TreeView: TTreeView; TokenFile: TTokenFile);
  function GetNodeList(Token: TTokenClass; DoCreate: Boolean = True): TTreeNode;
  var
    NextSibling: TTreeNode;
  begin
    Result := nil;
    NextSibling := TreeView.Items.GetFirstNode;
    while Assigned(NextSibling) do
    begin
      if TTokenClass(NextSibling.Data).Token = Token.Token then
      begin
        if DoCreate then
          NextSibling.Data := Token;
        Result := NextSibling;
        Exit;
      end;
      case TTokenClass(NextSibling.Data).Token of
        tkDefineList, tkDefine:
        begin
          if Token.Token in [tkIncludeList] then
          begin
            if DoCreate then
              Result := TreeView.Items.AddObject(NextSibling, Token.Name, Token);
            Exit;
          end;
        end;
        tkTreeObjList, tkClass, tkNamespace, tkStruct:
        begin
          if Token.Token in [tkIncludeList, tkDefineList] then
          begin
            if DoCreate then
              Result := TreeView.Items.AddObject(NextSibling, Token.Name, Token);
            Exit;
          end;
        end;
        tkVarConsList, tkVariable, tkConstructor, tkDestructor:
        begin
          if Token.Token in [tkIncludeList, tkDefineList, tkTreeObjList] then
          begin
            if DoCreate then
              Result := TreeView.Items.AddObject(NextSibling, Token.Name, Token);
            Exit;
          end;
        end;
        tkFuncProList, tkFunction, tkPrototype:
        begin
          if Token.Token in [tkIncludeList, tkDefineList, tkTreeObjList, tkVarConsList] then
          begin
            if DoCreate then
              Result := TreeView.Items.AddObject(NextSibling, Token.Name, Token);
            Exit;
          end;
        end;
      end;
      NextSibling := NextSibling.getNextSibling;
    end;
    if DoCreate then
      Result := TreeView.Items.AddChildObject(nil, Token.Name, Token);
  end;
var
  Node: TTreeNode;
begin
  if TokenFile.Includes.Count > 0 then
  begin
    Node := GetNodeList(TokenFile.Includes);
    if TokenFile.Includes.Count > 10 then
      Node.Collapse(False);
    FillStaticTreeView(TreeView, Node, Node.getFirstChild, TokenFile.Includes);
  end
  else
  begin
    Node := GetNodeList(TokenFile.Includes, False);
    if Assigned(Node) then
      Node.Delete;
  end;
  if TokenFile.Defines.Count > 0 then
  begin
    Node := GetNodeList(TokenFile.Defines);
    if TokenFile.Defines.Count > 10 then
      Node.Collapse(False);
    FillStaticTreeView(TreeView, Node, Node.getFirstChild, TokenFile.Defines);
  end
  else
  begin
    Node := GetNodeList(TokenFile.Defines, False);
    if Assigned(Node) then
      Node.Delete;
  end;
  if TokenFile.TreeObjs.Count > 0 then
  begin
    Node := GetNodeList(TokenFile.TreeObjs);
    if TokenFile.TreeObjs.Count > 10 then
      Node.Collapse(False);
    FillStaticTreeView(TreeView, Node, Node.getFirstChild, TokenFile.TreeObjs);
  end
  else
  begin
    Node := GetNodeList(TokenFile.TreeObjs, False);
    if Assigned(Node) then
      Node.Delete;
  end;
  if TokenFile.VarConsts.Count > 0 then
  begin
    Node := GetNodeList(TokenFile.VarConsts);
    if TokenFile.VarConsts.Count > 10 then
      Node.Collapse(False);
    FillStaticTreeView(TreeView, Node, Node.getFirstChild, TokenFile.VarConsts);
  end
  else
  begin
    Node := GetNodeList(TokenFile.VarConsts, False);
    if Assigned(Node) then
      Node.Delete;
  end;
  if TokenFile.FuncObjs.Count > 0 then
  begin
    Node := GetNodeList(TokenFile.FuncObjs);
    if TokenFile.FuncObjs.Count > 10 then
      Node.Collapse(False);
    FillStaticTreeView(TreeView, Node, Node.getFirstChild, TokenFile.FuncObjs);
  end
  else
  begin
    Node := GetNodeList(TokenFile.FuncObjs, False);
    if Assigned(Node) then
      Node.Delete;
  end;
  //TreeView.Invalidate;
end;

constructor TParserThread.Create;
begin
  inherited Create(TRUE);
  fTokenFile := TTokenFile.Create;
  fCppParser := TCppParser.Create;
  fCppParser.OnProgess := ParserProgress;
  fCppParser.OnLogToken := ParserTokenLog;

  fScanEventHandle := CreateEvent(nil, FALSE, FALSE, nil);
  if (fScanEventHandle = 0) or (fScanEventHandle = INVALID_HANDLE_VALUE) then
    raise EOutOfResources.Create('Couldn''t create WIN32 event object');
  Resume;
end;

destructor TParserThread.Destroy;
begin
  fCppParser.Free;
  fTokenFile.Free;
  if (fScanEventHandle <> 0) and (fScanEventHandle <> INVALID_HANDLE_VALUE) then
    CloseHandle(fScanEventHandle);
  inherited Destroy;
end;

procedure TParserThread.ShowProgress;
begin
  if not Assigned(FrmFalconMain) then Exit;
  with FrmFalconMain do
  begin
    //PanelRowCol.Caption := Format('%d %% done', [fLastPercent]);
  end;
end;

procedure TParserThread.AddLogEvent;
begin
  if not Assigned(FrmFalconMain) then Exit;
  with FrmFalconMain do
  begin
    AddItemMsg(ExtractFileName(fTokenFile.FileName), fMsg, fCurrLine);
    RSPCmd.Show;
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
  if Total = 0 then Exit;
  I := Round(Current*100/Total);
  if I = fLastPercent then Exit;
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
  while not Terminated do begin
    WaitForSingleObject(fScanEventHandle, INFINITE);
    fHasParsed := False;
    repeat
      if Terminated then
        break;
      // make sure the event is reset when we are still in the repeat loop
      ResetEvent(fScanEventHandle);
      // get the modified source and set fSourceChanged to 0
      Synchronize(GetSource);
      if Terminated then
        break;
      // clear keyword list
      fLastPercent := 0;

      fStartTime := GetTickCount;
      fHasParsed := fCppParser.Parse(fSource, TokenFile);
      if fSourceChanged then Break;
    until not fSourceChanged;

    if Terminated then
      break;
    // source was changed while scanning
    if fSourceChanged then begin
      Sleep(100);
      continue;
    end;

    //fKeywords.Sort;
    fParseTime := GetTickCount - fStartTime;
    if fHasParsed then
      Synchronize(SetResults);
    // and go to sleep again
  end;
end;

procedure TParserThread.GetSource;
var
  sheet: TFilePropertySheet;
begin
  if Assigned(FrmFalconMain) then
  begin
    if FrmFalconMain.GetActiveSheet(sheet) then
    begin
      fTokenFile.Data := TFileProperty(sheet.Node.Data);
      fSource := sheet.Memo.Text;
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
  sheet: TFilePropertySheet;
  FileProp: TFileProperty;
begin
  if not Assigned(FrmFalconMain) then Exit;
  with FrmFalconMain do
  begin
    if not GetActiveSheet(sheet) then
    begin
      TreeViewOutline.Items.Clear;
      Exit;
    end;

    fTokenFile.AssignProperty(ActiveEditingFile);
    UpdateActiveFileToken(fTokenFile, True);
    FileProp := TFileProperty(ActiveEditingFile.Data);
    TextEditorFileParsed(FileProp, ActiveEditingFile);
    if HintParams.Activated then ShowHintParams(sheet.Memo);
  end;
end;

procedure TParserThread.Shutdown;
begin
  fCppParser.Cancel;
  Terminate;
  if (fScanEventHandle <> 0) and (fScanEventHandle <> INVALID_HANDLE_VALUE) then
    SetEvent(fScanEventHandle);
end;

//on create application
procedure TFrmFalconMain.FormCreate(Sender: TObject);
var
  List: TStrings;
  I: Integer;
  Template: TTemplate;
  Temp, ProgFiles, path: String;
  ini: TIniFile;
  Rs: TResourceStream;
  Prop: TFileProperty;
  FileObj: TFileObject;
  HistList, SourceFileList, AutoCompleteList: TStrings;
  Proj: TProjectProperty;
begin
  IsLoading := True;
  Config := TConfig.Create;
  AppRoot := ExtractFilePath(Application.ExeName);
  ConfigRoot := GetUserFolderPath(CSIDL_APPDATA) + 'Falcon\';
  //create config root directory
  if not DirectoryExists(ConfigRoot) then
    CreateDir(ConfigRoot);
  IniConfigFile := ConfigRoot + 'Config.ini';
  Config.Load(IniConfigFile, Self);
  if Config.Environment.AlternativeConfFile and
    FileExists(Config.Environment.ConfigurationFile) then
    IniConfigFile := Config.Environment.ConfigurationFile;
  if Config.Environment.ShowSplashScreen then
    SplashScreen.Show;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[45]);
  fWorkerThread := TParserThread.Create;
  ThreadTokenFiles := TThreadTokenFiles.Create;
  ThreadLoadTkFiles := TThreadLoadTokenFiles.Create;
  ThreadTokenFiles.OnStart := ParserStart;
  ThreadTokenFiles.OnProgress := ParserProgress;
  ThreadTokenFiles.OnFinish := ParserFinish;
  DebugReader := TDebugReader.Create;
  DebugReader.OnStart := DebugReaderStart;
  DebugReader.OnCommand := DebugReaderCommand;
  DebugReader.OnFinish := DebugReaderFinish;
  CommandQueue := TCommandQueue.Create;

  FilesParsed := TTokenFiles.Create;
  ThreadFilesParsed := TThreadTokenFiles.Create;
  ThreadFilesParsed.OnProgress := AllParserProgress;
  ThreadFilesParsed.OnFinish := AllParserFinish;
  AllParsedList := TStringList.Create;
  ActiveEditingFile := TTokenFile.Create;
  ParseAllFiles := TTokenFiles.Create;//parse all unparsed files
  //ParseAllFiles.Parser.ProgessVarFunc := False;// no load function content
  HintTip := TTokenHintTip.Create(Self);//mouse over hint
  HintParams := TTokenHintParams.Create(Self);//Ctrl + Space or ( Trigger Key

  AutoComplete := TSynAutoComplete.Create(Self);
  Rs := TResourceStream.Create(HInstance, 'AUTOCOMPLETE', RT_RCDATA);
  Rs.Position := 0;
  AutoComplete.AutoCompleteList.LoadFromStream(Rs);
  Rs.Free;

  //outline images
  ConvertTo32BitImageList(ImgListOutLine);
  AddImages(ImgListOutLine, 'OUTLINEIMAGES');
  ConvertTo32BitImageList(ImgListMenus);
  AddImages(ImgListMenus, 'MENUIMAGES');
  ConvertTo32BitImageList(DisImgListMenus);
  AddImages(DisImgListMenus, 'DISMENUIMAGES');
  ConvertTo32BitImageList(ImageListGutter);
  AddImages(ImageListGutter, 'GUTTERIMAGES');
  //ConvertTo32BitImageList(ImgListCountry);
  AddImages(ImgListCountry, 'IMGCOUNTRY');
  OutlineImages[tkClass       ] := 4;
  OutlineImages[tkFunction    ] := 9;
  OutlineImages[tkPrototype   ] := 8;
  OutlineImages[tkInclude     ] := 1;
  OutlineImages[tkDefine      ] := 3;
  OutlineImages[tkVariable    ] := 6;
  OutlineImages[tkTypedef     ] := 10;
  OutlineImages[tkTypedefProto] := 11;
  OutlineImages[tkStruct      ] := 5;
  OutlineImages[tkTypeStruct  ] := 5;
  OutlineImages[tkEnum        ] := 5;
  OutlineImages[tkUnion       ] := 5;
  OutlineImages[tkTypeUnion   ] := 5;
  OutlineImages[tkIncludeList ] := 0;
  OutlineImages[tkDefineList  ] := 2;
  OutlineImages[tkTreeObjList ] := 0;
  OutlineImages[tkVarConsList ] := 0;
  OutlineImages[tkFuncProList ] := 0;
  OutlineImages[tkRoot        ] := 0;
  OutlineImages[tkParams      ] := 0;
  OutlineImages[tkScope       ] := 0;

  ViewZoomInc.ShortCut := ShortCut(VK_ADD, [ssCtrl]);//Ctrl + +
  ViewZoomDec.ShortCut := ShortCut(VK_SUBTRACT, [ssCtrl]);//Ctrl + -
  BtnPrevPage.ShortCut := ShortCut(VK_TAB, [ssCtrl, ssShift]);//Ctrl + Shift + Tab
  BtnNextPage.ShortCut := ShortCut(VK_TAB, [ssCtrl]);//Ctrl + Tab
  SearchGotoPrevFunc.ShortCut := ShortCut(VK_UP, [ssCtrl, ssShift]);//Ctrl + Shift + UP
  SearchGotoNextFunc.ShortCut := ShortCut(VK_DOWN, [ssCtrl, ssShift]);//Ctrl + Shift + DOWN

  FalconVersion := GetFileVersionA(Application.ExeName);
  ActDropDownBtn := True;
  XMLOpened := False;
  FullScreenMode := False;
  SintaxList := TSintaxList.Create;
  SintaxList.Highlight := CppHighligher;
  //create projects directory
  if not DirectoryExists(Config.Environment.ProjectsDir) then
    CreateDir(Config.Environment.ProjectsDir);
  ZoomEditor := Config.Editor.FontSize;
  if Config.Environment.AlternativeConfFile and
    FileExists(Config.Environment.ConfigurationFile) then
    FrmPos.FileName := Config.Environment.ConfigurationFile
  else
    FrmPos.FileName := IniConfigFile;
  FrmPos.Load;
  MenuBar.Visible := not FrmPos.FullScreen;
  MenuDock.Top := 0;
  RzStatusBar.ShowSizeGrip := not FrmPos.FullScreen;
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

  TimerHintParams.Interval := Config.Editor.CodeDelay*100;
  TimerHintTipEvent.Interval := Config.Editor.CodeDelay*100;
  CodeCompletion.TimerInterval := Config.Editor.CodeDelay*100;
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
  ini:= TIniFile.Create(IniConfigFile);
  HistList := TStringList.Create;
  ini.ReadSection('History', HistList);
  for I := Pred(HistList.Count) downto 0 do
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
  //load view menu check
  ViewProjMan.Checked := ini.ReadBool('View', 'ProjMan', True);
  ViewMenuClick(ViewProjMan);
  ViewStatusBar.Checked := ini.ReadBool('View', 'StatusBar', True);
  ViewMenuClick(ViewStatusBar);
  ViewOutline.Checked := ini.ReadBool('View', 'Outline', True);
  ViewMenuClick(ViewOutline);
  LoadTokenMode := ini.ReadInteger('Packages', 'NewInstalled', -1);
  //load user sintax
  List := TStringList.Create;
  ini.ReadSection('HighlighterList', List);
  for I := 0 to List.Count - 1 do
  begin
    Temp := ini.ReadString('HighlighterList', List.Strings[I], '{}');
    SintaxList.Insert(I, TSintax.Create(List.Strings[I], Temp));
  end;
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

  PageControlEditorOldProc := PageControlEditor.WindowProc;
  PageControlEditor.WindowProc := PageControlEditorProc;
  DragAcceptFiles(PageControlEditor.Handle, True);

  PanelEditorOldProc := PanelEditor.WindowProc;
  PanelEditor.WindowProc := PanelEditorProc;
  DragAcceptFiles(PanelEditor.Handle, True);

  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[25]);
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Templates := TTemplates.Create;
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
  for I:= 0 to Pred(List.Count) do
  begin
    Template := TTemplate.Create;
    if Template.Load(Config.Environment.TemplatesDir + List.Strings[I], HelpFalcon) then
      Templates.Insert(Template)
    else
      Template.Free;
  end;
  List.Free;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[27]);
  //load projects
  for I:= 1 to ParamCount do
  begin
    OpenFileWithHistoric(ParamStr(I), Proj);
    //if OpenFileWithHistoric(ParamStr(I), Proj) then
    //  ParseProjectFiles(Proj);
  end;
  List := TStringList.Create;
  GetSourcesFiles(List);
  if List.Count > 0 then
  begin
    for I := 0 to List.Count - 1 do
    begin
      Prop := TFileProperty(List.Objects[I]);
      FileObj := TFileObject.Create;
      FileObj.ID := Prop;
      FileObj.FileName := List.Strings[I];
      FileObj.Text := Prop.Text.Text;
      List.Strings[I] := '-';
      List.Objects[I] := FileObj;
    end;
    ThreadFilesParsed.ParseLoad(FilesParsed, List);
  end;
  List.Free;
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[28]);
  CreateStdTools;
  
  //detect compiler
  Temp := GetEnvironmentVariable('MINGW_PATH');
  path := GetEnvironmentVariable('PATH');
  if not DirectoryExists(Temp) then
  begin
    ProgFiles := GetEnvironmentVariable('PROGRAMFILES');
    Temp := ProgFiles + '\Falcon\MinGW';
    if not DirectoryExists(Temp) then Temp := AppRoot + 'MinGW';
    if not DirectoryExists(Temp) then
      Temp := ExtractFileDrive(ProgFiles) + '\MinGW';
    if not DirectoryExists(Temp) then
      Temp := ExtractFileDrive(ProgFiles) + '\Dev-Cpp';
    if not DirectoryExists(Temp) then Temp := ProgFiles + '\Dev-Cpp';
    if not DirectoryExists(Temp) then Temp := ProgFiles + '\CodeBlocks\MinGW';
    //if not DirectoryExists(Temp) then
    //  Temp := ExtractFileDrive(ProgFiles) + '\Borland\BCC55';
    if not DirectoryExists(Temp) then
    begin
      MessageBox(0, 'Compiler was not detected!', 'Falcon C++',
        MB_ICONEXCLAMATION);
    end
    else
    begin
      SplashScreen.TextOut(55, 300, STR_FRM_MAIN[29]);
      Compiler_Path := Temp;
      SetEnvironmentVariable('MINGW_PATH', PChar(Temp));
      Temp := path + ';' + Temp + '\bin';
      SetEnvironmentVariable('PATH', PChar(Temp));
    end;
  end
  else
  begin
    Compiler_Path := Temp;
    if (Pos(Temp + '\bin', path) = 0) then
    begin
      SplashScreen.TextOut(55, 300, STR_FRM_MAIN[29]);
      Temp := path + ';' + Temp + '\bin';
      SetEnvironmentVariable('PATH', PChar(Temp));
    end
  end;
  FilesParsed.PathList.Add(Compiler_Path + '\include\');
  SplashScreen.TextOut(55, 300, STR_FRM_MAIN[30]);
  IsLoadingSrcFiles := False;
  if (LoadTokenMode < 0) or (LoadTokenMode > 0) then
  begin
    SourceFileList := TStringList.Create;
    if LoadTokenMode < 0 then
      SplashScreen.TextOut(55, 300, Format(STR_FRM_MAIN[36], [0]))
    else
      SplashScreen.TextOut(55, 300, Format(STR_FRM_MAIN[37], [0]));
    if FindFiles(Compiler_Path + '\include\', '*.h', SourceFileList) then
    begin
      IsLoadingSrcFiles := True;
      ThreadTokenFiles.Start(ParseAllFiles, SourceFileList,
        Compiler_Path + '\include\', ConfigRoot + 'include\', '.h.prs');
      if Config.Environment.ShowSplashScreen then
        Sleep(3000);
    end;
    SourceFileList.Free;
  end;
  SplashScreen.Hide;
  IsLoading := False;
end;


//on close application
procedure TFrmFalconMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ProjProp: TProjectProperty;
  I, R: Integer;
  ini: TIniFile;
begin
  for I:= 0 to Pred(TreeViewProjects.Items.Count) do
  begin
    if not(TreeViewProjects.Items.Item[I].Level = 0) then Continue;
    ProjProp := TProjectProperty(TreeViewProjects.Items.Item[I].Data);
    if (ProjProp.Modified or (not ProjProp.Saved and not ProjProp.AllFilesIsNew) or ProjProp.FilesChanged) then
    begin
      R := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[10],
           [ExtractFileName(ProjProp.FileName)])), 'Falcon C++',
           MB_YESNOCANCEL + MB_ICONINFORMATION);
      case R of
        mrYes:
        begin
          if not ProjProp.Saved then
          with TSaveDialog.Create(Self) do
          begin
            FileName := ProjProp.Caption;
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
              FILE_TYPE_UNKNOW: Filter := STR_FRM_MAIN[12] + '|*.*';
            end;
            Options := Options + [ofOverwritePrompt];
            if Execute then
            begin
              ProjProp.Saved := True;
              ProjProp.FileName := FileName;
              ProjProp.SaveAll(True);
              FileSave.Enabled := ProjProp.Modified;
              BtnSave.Enabled := FileSave.Enabled;
              PopTabsSave.Enabled := FileSave.Enabled;
              FileSaveAll.Enabled := FileSave.Enabled;
              BtnSaveAll.Enabled := FileSave.Enabled;
              PopTabsSaveAll.Enabled := FileSaveAll.Enabled;
            end
            else
            begin
              Action := caNone;
              Exit;
            end;
          end
          else
            if ProjProp.Modified or ProjProp.FilesChanged then
              ProjProp.SaveAll(True);
        end;//mrYes
        mrCancel:
        begin
          Action := caNone;
          Exit;
        end;//mrCancel
      end;//case
    end;//modified or not salved
  end;//for
  try
  if ParseAllFiles.Busy then
  begin
    ThreadTokenFiles.Cancel;
    ParseAllCloseApp := True;
    Action := caNone;
    Exit;
  end;
  Config.Save(IniConfigFile, Self);
  ini:= TIniFile.Create(IniConfigFile);
  ini.EraseSection('History');
  for I := 2 to Pred(FileReopen.Count) do
    ini.WriteString('History', 'File'+ IntToStr(I - 1),
      TDataMenuItem(FileReopen.Items[I]).HelpFile);
  ini.WriteBool('Search', 'DiffCase', LastSearch.DiffCase);
  ini.WriteBool('Search', 'FullWord', LastSearch.FullWord);
  ini.WriteBool('Search', 'CircSearch', LastSearch.CircSearch);
  ini.WriteInteger('Search', 'SearchMode', LastSearch.SearchMode);
  ini.WriteBool('Search', 'DirectionDown', LastSearch.Direction);
  ini.WriteBool('Search', 'Transparence', LastSearch.Transparence);
  ini.WriteInteger('Search', 'Opacite', LastSearch.Opacite);
  //save view menu check
  ini.WriteBool('View', 'ProjMan', ViewProjMan.Checked);
  ini.WriteBool('View', 'StatusBar', ViewStatusBar.Checked);
  ini.WriteBool('View', 'CompOut', ViewCompOut.Checked);
  ini.WriteBool('View', 'Outline', ViewOutline.Checked);
  //sintax
  ini.EraseSection('HighlighterList');
  for I := 0 to SintaxList.Count - 1 do
  begin
    if SintaxList.Items[I].ReadOnly then Continue;
    ini.WriteString('HighlighterList', SintaxList.Items[I].Name,
      SintaxList.Items[I].GetSintaxString);
  end;

  ini.Free;
  FrmPos.Save;
  finally
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
  for I:= 0 to Pred(List.Count) do
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
  Templates := aTemplates;
end;

procedure TFrmFalconMain.UpdateCompletionColors(EdtOpt: TEditorOptions);
begin
  CompletionColors[TTkType(0)]  := Format(CompletionNames[0],  [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(1)]  := Format(CompletionNames[1],  [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[TTkType(2)]  := Format(CompletionNames[2],  [ColorToString(EdtOpt.CompListFunc)]);
  CompletionColors[TTkType(3)]  := Format(CompletionNames[3],  [ColorToString(EdtOpt.CompListConstructor)]);
  CompletionColors[TTkType(4)]  := Format(CompletionNames[4],  [ColorToString(EdtOpt.CompListDestructor)]);
  //CompletionColors[TTkType(5)]  := Format(CompletionNames[5],  [ColorToString(EdtOpt.CompListInclude)]);
  CompletionColors[TTkType(6)]  := Format(CompletionNames[6],  [ColorToString(EdtOpt.CompListPreproc)]);
  CompletionColors[TTkType(7)]  := Format(CompletionNames[7],  [ColorToString(EdtOpt.CompListVar)]);
  CompletionColors[TTkType(8)]  := Format(CompletionNames[8],  [ColorToString(EdtOpt.CompListTypedef)]);
  CompletionColors[TTkType(9)]  := Format(CompletionNames[9],  [ColorToString(EdtOpt.CompListTypedef)]);
  CompletionColors[TTkType(10)]  := Format(CompletionNames[10],  [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(11)] := Format(CompletionNames[11], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(12)] := Format(CompletionNames[12], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(13)] := Format(CompletionNames[13], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(14)] := Format(CompletionNames[14], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(15)] := Format(CompletionNames[15], [ColorToString(EdtOpt.CompListType)]);
  CompletionColors[TTkType(16)] := Format(CompletionNames[16], [ColorToString(EdtOpt.CompListNamespace)]);
  CompletionColors[TTkType(17)] := Format(CompletionNames[17], [ColorToString(EdtOpt.CompListConstant)]);
end;

//get source file to parse
procedure TFrmFalconMain.ParseFiles(List: TStrings);
var
  I: Integer;
  prop: TFileProperty;
  ObjList: TStrings;
  FileObj: TFileObject;
begin
  if List.Count = 0 then
    Exit;
  ObjList := TStringList.Create;
  //parse source files
  for I := 0 to List.Count - 1 do
  begin
    prop := TFileProperty(List.Objects[I]);
    if prop.FileType = FILE_TYPE_RC then
      Continue;
    FileObj := TFileObject.Create;
    FileObj.ID := Prop;
    FileObj.FileName := List.Strings[I];
    FileObj.Text := prop.Text.Text;
    ObjList.AddObject('-', FileObj);
  end;
  if ObjList.Count = 0 then
  begin
    ObjList.Free;
    Exit;
  end;
  if not ThreadFilesParsed.Busy then
  begin
    ThreadFilesParsed.Free;
    ThreadFilesParsed := TThreadTokenFiles.Create;
    ThreadFilesParsed.OnProgress := AllParserProgress;
    ThreadFilesParsed.OnFinish := AllParserFinish;
    ThreadFilesParsed.ParseLoad(FilesParsed, ObjList);
  end
  else
    ThreadFilesParsed.AddFiles(ObjList);
  ObjList.Free;
end;

//get source file to parse
procedure TFrmFalconMain.ParseProjectFiles(Proj: TProjectProperty);
var
  List: TStrings;
begin
  //parse project source files
  List := Proj.GetFiles();
  ParseFiles(List);
  List.Free;
end;

procedure TFrmFalconMain.BtnHelpClick(Sender: TObject);
var
  form: TForm;
  memo: TMemo;
  I: Integer;
begin
  form := TForm.Create(self);
  form.Width := 400;
  form.Height := 450;
  memo := TMemo.Create(form);
  memo.Parent := form;
  memo.Align := alClient;
  memo.ScrollBars := ssBoth;
  for I := 0 to FilesParsed.Count - 1 do
  begin
    memo.Lines.Add(FilesParsed.Items[I].FileName);
  end;
  form.Position := poOwnerFormCenter;
  form.Caption := IntToStr(FilesParsed.Count) + ' Files';
  form.ShowModal;
end;

//get source file to parse
function TFrmFalconMain.GetSourcesFiles(List: TStrings): Integer;
var
  I: Integer;
  prop: TFileProperty;
begin
  Result := 0;
  for I := 0 to TreeViewProjects.Items.Count - 1 do
  begin
    prop := TFileProperty(TreeViewProjects.Items.Item[I].Data);
    if not (prop.FileType in [FILE_TYPE_PROJECT, FILE_TYPE_FOLDER,
                              FILE_TYPE_RC]) then
    begin
      Inc(Result);
      List.AddObject(prop.GetCompleteFileName, prop);
    end;
  end;
//
end;

//update user configuration editor
procedure TFrmFalconMain.UpdateOpenedSheets;
var
  Options: TSynEditorOptions;
  I: Integer;
  SynMemo: TSynMemo;
begin
  ZoomEditor := Config.Editor.FontSize;
  UpdateCompletionColors(Config.Editor);
  TimerHintParams.Interval := Config.Editor.CodeDelay*100;
  TimerHintTipEvent.Interval := Config.Editor.CodeDelay*100;
  CodeCompletion.TimerInterval := Config.Editor.CodeDelay*100;

  for I := 0 to Pred(PageControlEditor.PageCount) do
  begin
    SynMemo := TFilePropertySheet(PageControlEditor.Pages[I]).Memo;
    Options := SynMemo.Options;
    with Config.Editor do
    begin
      Options := SynMemo.Options;
      //------------ General --------------------------//
      if AutoIndent then Include(Options, eoAutoIndent)
      else Exclude(Options, eoAutoIndent);
      //find text at cursor
      SynMemo.InsertMode := InsMode;
      if GrpUndo then Include(Options, eoGroupUndo)
      else Exclude(Options, eoGroupUndo);
      //remove file on close
      if KeepTrailingSpaces then Exclude(Options, eoTabIndent)
      else Include(Options, eoTrimTrailingSpaces);

      if ScrollHint then Exclude(Options, eoShowScrollHint)
      else Include(Options, eoShowScrollHint);
      if TabIndtUnind then Include(Options, eoTabIndent)
      else Exclude(Options, eoTabIndent);
      if SmartTabs then Include(Options, eoSmartTabs)
      else Exclude(Options, eoSmartTabs);
      if SmartTabs then Include(Options, eoSmartTabs)
      else Exclude(Options, eoSmartTabs);
      if UseTabChar then Exclude(Options, eoTabsToSpaces)
      else Include(Options, eoTabsToSpaces);
      if EnhancedHomeKey then Include(Options, eoEnhanceHomeKey)
      else Exclude(Options, eoEnhanceHomeKey);
      if ShowLineChars then Include(Options, eoShowSpecialChars)
      else Exclude(Options, eoShowSpecialChars);

      SynMemo.MaxUndo := MaxUndo;
      SynMemo.TabWidth := TabWidth;

      SynMemo.BracketHighlighting := HigtMatch;
      SynMemo.BracketHighlight.Foreground := NColor;
      SynMemo.BracketHighlight.AloneForeground := EColor;
      SynMemo.BracketHighlight.Style := [fsBold];
      SynMemo.BracketHighlight.AloneStyle := [fsBold];
      SynMemo.BracketHighlight.Background := BColor;

      if HigtCurLine then
        SynMemo.ActiveLineColor := CurLnColor
      else
        SynMemo.ActiveLineColor := clNone;

      SynMemo.LinkEnable := LinkClick;
      SynMemo.LinkOptions.Color := LinkColor;

      //---------------- Display ---------------------//
      SynMemo.Font.Name := FontName;
      SynMemo.Font.Size := FontSize;
      SynMemo.Gutter.Width := GutterWdth;
      if ShowRMargin then
        SynMemo.RightEdge := Rmargin
      else
        SynMemo.RightEdge := 0;
      SynMemo.Gutter.Visible := ShowGutter;
      SynMemo.Gutter.ShowLineNumbers := ShowLnNumb;
      SynMemo.Gutter.Gradient := GrdGutter;
      //-------------- Colors -------------------------//
      SintaxList.Selected.UpdateEditor(SynMemo);
      //-------------- Code Resources -----------------//
      SynMemo.Options := Options;
    end;
  end;
end;

//get selected file in project list
function TFrmFalconMain.GetSelectedFileInList(var ActiveFile: TFileProperty): Boolean;
begin
  Result := False;
  if (TreeViewProjects.SelectionCount = 0) then Exit;
  ActiveFile := TFileProperty(TreeViewProjects.Selected.Data);
  Result := True;
end;

// get active file in treeview or active sheet
function TFrmFalconMain.GetActiveFile(var ActiveFile: TFileProperty): Boolean;
var
  Sheet: TFilePropertySheet;
begin
  Result := False;
  if (TreeViewProjects.SelectionCount > 0) and (TreeViewProjects.Selected <> nil) then
  begin
    if (TreeViewProjects.Focused) then
      ActiveFile := TFileProperty(TreeViewProjects.Selected.Data)
    else
    begin
      if (PageControlEditor.ActivePageIndex >= 0) then
      begin
        Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
        ActiveFile := TFileProperty(Sheet.Node.Data);
      end
      else
        ActiveFile := TFileProperty(TreeViewProjects.Selected.Data);
    end;
    Result := True;
  end
  else if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    ActiveFile := TFileProperty(Sheet.Node.Data);
    Result := True;
  end;
end;

//get active project
function TFrmFalconMain.GetActiveProject(var Project: TProjectProperty): Boolean;
var
  ActFile: TFileProperty;
begin
  Result := False;
  if not GetActiveFile(ActFile) then Exit;
  if (TObject(ActFile) is TProjectProperty) then
    Project := TProjectProperty(ActFile)
  else
    Project := ActFile.Project;
  Result := True;
end;

//get active sheet
function TFrmFalconMain.GetActiveSheet(var sheet: TFilePropertySheet): Boolean;
begin
  Result := False;
  if PageControlEditor.ActivePageIndex < 0 then Exit;
  sheet := TFilePropertySheet(PageControlEditor.ActivePage);
  Result := True;
end;

//show about window
procedure TFrmFalconMain.About1Click(Sender: TObject);
begin
  frmSobre.ShowModal;
end;

//show properties window of project
procedure TFrmFalconMain.ProjectPropertiesClick(Sender: TObject);
var
  ProjProp: TProjectProperty;
begin
  if GetActiveProject(ProjProp) then
  begin
    if not Assigned(FrmProperty) then
      FrmProperty := TFrmProperty.Create(Self);
    try
      FrmProperty.SetProject(ProjProp);
      FrmProperty.ShowModal;
    finally
      FrmProperty.Free;
      FrmProperty := nil;
    end;
  end;
end;

//open files
procedure TFrmFalconMain.FileOpenClick(Sender: TObject);
begin
  if OpenDlg.Execute then
  begin
    IsLoading := True;
    OnDragDropFiles(Sender, OpenDlg.Files);
    IsLoading := False;
    //parser files
  end;
end;

//on click menu help execute filehelp
procedure TFrmFalconMain.FalconHelpClick(Sender: TObject);
var
  FileName: String;
begin
  if Sender is TDataMenuItem then
  begin
    FileName := AppRoot + TDataMenuItem(Sender).HelpFile;
    ShellExecute(Handle, 'open', PChar(FileName), '',
      PChar(ExtractFilePath(FileName)), SW_SHOW);
  end;
end;

procedure BoldTreeNode(treeNode: TTreeNode; Value: Boolean) ;
var
  treeItem: TTVItem;
begin
  if not Assigned(treeNode) then Exit;
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
  TreeView_SetItem(treeNode.Handle, treeItem) ;
end;


//on change file selection
procedure TFrmFalconMain.TreeViewProjectsChange(Sender: TObject; Node: TTreeNode);
var
  FilePrp: TFileProperty;
  ProjProp: TProjectProperty;
  prjs: TTreeNode;
begin
  TextEditorAllAction(Sender);
  BtnSaveAll.Enabled := (TreeViewProjects.Items.Count > 0);
  FileSaveAll.Enabled := BtnSaveAll.Enabled;
  PopTabsSaveAll.Enabled := FileSaveAll.Enabled;
  BtnRemove.Enabled := (TreeViewProjects.SelectionCount > 0);
  FileRemove.Enabled := (TreeViewProjects.SelectionCount > 0);

  if(TreeViewProjects.Items.Count = 0) then
  begin
    PanelActiveFile.ImageIndex := -1;
    PanelActiveFile.Caption := '';
    PanelRowCol.Caption := '';
    PanelCompStatus.ImageIndex := -1;
    PanelCompStatus.Caption := '';
    PanelFileDesc.Caption := '';
    FilesParsed.Clear;
  end;
  
  if (not BtnSaveAll.Enabled) or
    ((TreeViewProjects.SelectionCount = 0) and (PageControlEditor.PageCount = 0))  then
  begin
    FileSave.Enabled := False;
    BtnSave.Enabled := False;
    PopTabsSave.Enabled := False;
    BtnRemove.Enabled := False;
    FileRemove.Enabled := False;
  end;
  if not Assigned(Node) then
  begin
    FileSaveAs.Enabled := GetActiveFile(FilePrp);
    // compile with no selected
    //if (PageControlEditor.PageCount = 0) then Exit;
    if GetActiveFile(FilePrp) then
    begin
      ProjectAdd.Enabled := (PageControlEditor.PageCount > 0) and
        (FilePrp.Project.FileType = FILE_TYPE_PROJECT);
      ProjectRemove.Enabled := (PageControlEditor.PageCount > 0) and
        (FilePrp.Project.FileType = FILE_TYPE_PROJECT);
    end
    else
    begin
      ProjectAdd.Enabled := False;
      ProjectRemove.Enabled := False;
    end;

    ProjectBuild.Enabled := (PageControlEditor.PageCount > 0);
    ProjectProperties.Enabled := (PageControlEditor.PageCount > 0);
    PopEditorProperties.Enabled := (PageControlEditor.PageCount > 0);
    BtnProperties.Enabled := (PageControlEditor.PageCount > 0);
    BtnRun.Enabled := (PageControlEditor.PageCount > 0) and
      (not Executor.Running or (assigned(LastProjectBuild) and
      (LastProjectBuild <> ProjProp)) or DebugReader.Running);
    RunRun.Enabled := BtnRun.Enabled;
    RunCompile.Enabled := BtnRun.Enabled and not DebugReader.Running;
    BtnCompile.Enabled := RunCompile.Enabled;
    if GetActiveProject(ProjProp) then
    begin
      RunExecute.Enabled := ProjProp.Compiled and FileExists(ProjProp.GetTarget)
        and BtnRun.Enabled and not DebugReader.Running;
      BtnExecute.Enabled := RunExecute.Enabled;
      ProjectPopupMenuItens(True, True, True, True, True, True, True, False,
        False, False, False, False, True);
    end
    else
    begin
      RunExecute.Enabled := False;
      BtnExecute.Enabled := False;
      ProjectPopupMenuItens(True, True, True, True, True, True, True, False,
        False, False, False, False, False);
    end;
    Exit;
  end;

  prjs := TreeViewProjects.Items.GetFirstNode;
  while prjs <> nil do
  begin
    BoldTreeNode(prjs, False);
    prjs := prjs.getNextSibling;
  end;

  BoldTreeNode(TFileProperty(Node.Data).Project.Node, True);


  FileSaveAS.Enabled := True;
  TextEditorEnter(Sender);
  FilePrp := TFileProperty(Node.Data);
  PanelActiveFile.ImageIndex := FILE_IMG_LIST[FilePrp.FileType];
  PanelActiveFile.Caption := FilePrp.Caption;
  PanelFileDesc.Caption := FilePrp.GetCompleteFileName;
  if (FilePrp is TProjectProperty) then
    BtnSave.Enabled := (FilePrp.Modified or
                        TProjectProperty(FilePrp).FilesChanged) or
                        not FilePrp.Saved
  else
    BtnSave.Enabled := FilePrp.Modified or not FilePrp.Saved;
  BtnSaveAll.Enabled := True;
  FileSave.Enabled := BtnSave.Enabled;
  PopTabsSave.Enabled := BtnSave.Enabled;
  FileSaveAll.Enabled := True;
  PopTabsSaveAll.Enabled := FileSaveAll.Enabled;
  case FilePrp.FileType of
    FILE_TYPE_PROJECT:
    begin
      ProjProp := TProjectProperty(Node.Data);
      ProjectPopupMenuItens(True, False, True, True, True, True, True, True,
        False, FilePrp.Saved, True, True, True);
      //ProjectRemove.Enabled := ProjProp.FileType = FILE_TYPE_PROJECT;
      //ProjectAdd.Enabled := ProjProp.FileType = FILE_TYPE_PROJECT;
    end;
    FILE_TYPE_FOLDER:
    begin
      ProjectPopupMenuItens(True, False, True, True, True, True, True, True,
        False, FilePrp.Saved, True, True, True);
    end;
    FILE_TYPE_C..FILE_TYPE_UNKNOW:
    begin
      ProjectPopupMenuItens(True, False, False, False, False, False, False,
        not(FilePrp is TProjectProperty), True, FilePrp.Saved, True, True, True);
    end;
  end;
  ProjectBuild.Enabled := True;
  ProjectProperties.Enabled := True;

  ProjectRemove.Enabled := FilePrp.Project.FileType = FILE_TYPE_PROJECT;
  ProjectAdd.Enabled := FilePrp.Project.FileType = FILE_TYPE_PROJECT;
  if FilePrp.Editing then
    FilePrp.ViewPage;
end;

//edit selected file in list of projects
procedure TFrmFalconMain.EditFileClick(Sender: TObject);
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if TFileProperty(TreeViewProjects.Selected.Data).FileType <>
      FILE_TYPE_FOLDER then
      TFileProperty(TreeViewProjects.Selected.Data).Edit;
  end;
end;

//delete selected text in editor or next char
procedure TFrmFalconMain.RemoveClick(Sender: TObject);
var
  ControlHand: HWnd;
  Node: TTreeNode;
begin
  if TreeViewProjects.SelectionCount = 0 then Exit;

  if not TreeViewProjects.IsEditing then
  begin
    Node := TreeViewProjects.Selected;
    RemoveFile(TFileProperty(Node.Data));
  end
  else
  begin
    ControlHand := TreeView_GetEditControl(TreeViewProjects.Handle);
    if(ControlHand <> 0) and IsWindowVisible(ControlHand) then
    begin
      SendMessage(ControlHand, WM_KEYDOWN, VK_DELETE, VK_DELETE);
      SendMessage(ControlHand, WM_KEYUP, VK_DELETE, VK_DELETE);
    end;
  end;
end;

//undo change of editor

procedure TFrmFalconMain.SubMUndoClick(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.Undo;
  end;
end;

//redo change of code editor

procedure TFrmFalconMain.SubMRedoClick(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.Redo;
  end;
end;

//cut selected text of editor 

procedure TFrmFalconMain.SubMCutClick(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.CutToClipboard;
  end;
end;

//copy selected text of code editor

procedure TFrmFalconMain.SubMCopyClick(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.CopyToClipboard;
  end;
end;

//paste copied text on editor 

procedure TFrmFalconMain.SubMPasteClick(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
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
        if (TFileProperty(Node.Data).FileType = FILE_TYPE_PROJECT) then
          ProjectPropertiesClick(Sender)
        else if(TFileProperty(Node.Data).FileType = FILE_TYPE_FOLDER) then
          TFileProperty(Node.Data).Open
        else
          TFileProperty(Node.Data).Edit;
      end;
    end;
end;

//on close tab editor
procedure TFrmFalconMain.PageControlEditorClose(Sender: TObject;
  var AllowClose: Boolean);
var
  FileProp: TFileProperty;
  ProjProp: TProjectProperty;
  Sheet: TFilePropertySheet;
  I: Integer;
  allow, clAction: Boolean;
begin
  if PageControlEditor.ActivePageIndex < 0 then Exit;
  Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
  FileProp := TFileProperty(Sheet.Node.Data);
  if FileProp.Modified and not (Config.Environment.RemoveFileOnClose and
  (FileProp.Project.FileType <> FILE_TYPE_PROJECT)) then
  begin
    I := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[10], [
         FileProp.Caption])), 'Falcon C++',
         MB_YESNOCANCEL + MB_ICONINFORMATION);
    case I of
      mrYes:
      begin
        if FileProp.Saved then
          FileProp.Save
        else
        begin
          FileProp.Modified := False;
          FileProp.SavedInto := True;
          FileProp.Project.Compiled := False;
          FileProp.SetText(Sheet.Memo.Lines);
        end;
      end;
      mrCancel: Exit;
    end;
  end;

  clAction := True;
  if (FileProp.Project.FileType <> FILE_TYPE_PROJECT) and
    Config.Environment.RemoveFileOnClose then
  begin
    RemoveFile(FileProp);

    BtnPrevPage.Enabled := PageControlEditor.PageCount > 1;
    BtnNextPage.Enabled := PageControlEditor.PageCount > 1;
    //BtnPrevPage.Enabled := PageControlEditor.ActivePageIndex > 0;
    //BtnNextPage.Enabled := (PageControlEditor.ActivePageIndex <
    //  PageControlEditor.PageCount - 1) and (PageControlEditor.PageCount > 1);
    Exit;
  end;

  PageControlEditor.Visible := (PageControlEditor.PageCount > 1);
  FileClose.Enabled := PageControlEditor.Visible;
  FileCloseAll.Enabled := PageControlEditor.Visible;
  EditSwap.Enabled := FileClose.Enabled;
  FilePrint.Enabled := PageControlEditor.Visible;
  FileExport.Enabled := PageControlEditor.Visible;
  RunToggleBreakpoint.Enabled := PageControlEditor.Visible;
  RunRuntoCursor.Enabled := PageControlEditor.Visible;
  PopTabsClose.Enabled := PageControlEditor.Visible;
  TreeViewOutline.Items.Clear;
  if not PageControlEditor.Visible then
    RSPOLine.Hide;

  if not PageControlEditor.Visible and (RPCExplorer.ActivePageIndex = 0) then
  begin
    EditUndo.Enabled := False;
    BtnUndo.Enabled := False;
    PopEditorUndo.Enabled := False;
    EditRedo.Enabled := False;
    BtnRedo.Enabled := False;
    PopEditorRedo.Enabled := False;
    PanelRowCol.Caption := '';
    PanelCompStatus.Caption := '';
    PanelCompStatus.ImageIndex := -1;
    EditSelectAll.Enabled := False;
    EditDelete.Enabled := False;
    PopEditorSelectAll.Enabled := False;
    EditCopy.Enabled := False;
    PopEditorCopy.Enabled := False;
    EditCut.Enabled := False;
    PopEditorCut.Enabled := False;
    EditPaste.Enabled := False;
    PopEditorPaste.Enabled := False;
    BtnToggleBook.Enabled := False;
    BtnGotoBook.Enabled := False;
    EditBookmarks.Enabled := False;
    EditGotoBookmarks.Enabled := False;
    EditFormat.Enabled := False;
    EditIndent.Enabled := False;
    EditUnindent.Enabled := False;

    SearchFind.Enabled := False;
    SearchFindNext.Enabled := False;
    SearchFindPrev.Enabled := False;
    SearchFindFiles.Enabled := False;
    SearchReplace.Enabled := False;
    SearchGotoFunction.Enabled := False;
    SearchGotoLine.Enabled := False;
    SearchGotoPrevFunc.Enabled := False;
    SearchGotoNextFunc.Enabled := False;
    BtnFind.Enabled := False;
    BtnReplace.Enabled := False;

    if RSPExplorer.Visible then TreeViewProjects.SetFocus;
    if GetActiveProject(ProjProp) then
    begin
      BtnRun.Enabled := (PageControlEditor.PageCount > 0) and
        (not Executor.Running or (assigned(LastProjectBuild) and
        (LastProjectBuild <> ProjProp)) or DebugReader.Running);
      RunRun.Enabled := BtnRun.Enabled;
      RunCompile.Enabled := BtnRun.Enabled and not DebugReader.Running;
      BtnCompile.Enabled := RunCompile.Enabled;
      RunExecute.Enabled := ProjProp.Compiled and FileExists(ProjProp.GetTarget)
        and BtnRun.Enabled and not DebugReader.Running;
      BtnExecute.Enabled := RunExecute.Enabled;
      if GetSelectedFileInList(FileProp) then
      begin
        allow := (FileProp.FileType <> FILE_TYPE_PROJECT) and (FileProp.FileType <> FILE_TYPE_FOLDER);
        ProjectPopupMenuItens(True, False, not allow, not allow, not allow,
          not allow, not allow, not allow, allow,
          FileProp.FileType <> FILE_TYPE_PROJECT, True, True, True);
      end;
    end
    else
    begin
      RunExecute.Enabled := False;
      BtnExecute.Enabled := False;
      BtnRun.Enabled := False;
      RunRun.Enabled := False;
      RunCompile.Enabled := False;
      BtnCompile.Enabled := False;
      ProjectPopupMenuItens(True, True, True, True, True, True, True, False,
        False, False, False, False, False);
    end;
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

//save selected project or file in list
procedure TFrmFalconMain.FileSaveClick(Sender: TObject);
var
  FileProp: TFileProperty;
  ProjProp: TProjectProperty;
begin
  if not GetActiveFile(FileProp) then Exit;
  if (FileProp is TProjectProperty) then
    ProjProp := TProjectProperty(FileProp)
  else
    ProjProp := FileProp.Project;
  if not ProjProp.Saved then
  with TSaveDialog.Create(Self) do
  begin
    FileName := ProjProp.Caption;
    case ProjProp.FileType of
      FILE_TYPE_PROJECT:
      begin
        DefaultExt := 'fpj';
        Filter := STR_FRM_MAIN[11] + ' (*.fpj)|*.fpj';
      end;
      FILE_TYPE_C:
      begin
        DefaultExt := 'c';
        Filter := STR_NEW_MENU[2] + ' (*.c)|*.c';
      end;
      FILE_TYPE_CPP:
      begin
        DefaultExt := 'cpp';
        Filter := STR_NEW_MENU[3] + ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp';
      end;
      FILE_TYPE_H:
      begin
        DefaultExt := 'h';
        Filter := STR_NEW_MENU[4] + '  (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh';
      end;
      FILE_TYPE_RC:
      begin
        DefaultExt := 'rc';
        Filter := STR_NEW_MENU[5] + ' (*.rc)|*.rc';
      end;
      FILE_TYPE_UNKNOW:
      begin
        Filter := STR_NEW_MENU[2] + ' (*.c)|*.c';
        Filter := Filter + '|' + STR_NEW_MENU[3] + ' (*.cpp, *.cc, *.cxx, *.c++, *.cp)|*.cpp; *.cc; *.cxx; *.c++; *.cp';
        Filter := Filter + '|' + STR_NEW_MENU[4] + '  (*.h, *.hpp, *.rh, *.hh)|*.h; *.hpp; *.rh; *.hh';
        Filter := Filter + '|' + STR_NEW_MENU[5] + ' (*.rc)|*.rc';
        Filter := Filter + '|' + STR_FRM_MAIN[12] + '|*.*';
        //if DefFileType = FILE_TYPE_CPP then
        //begin
            FilterIndex := 2;
            DefaultExt := 'cpp';
        //end
        //else
        //begin
        //  FilterIndex := 1;
        //  DefaultExt := '.c';
        //end;
        OnTypeChange := SaveExtensionChange;
      end;
    end;
    Options := Options + [ofOverwritePrompt];
    if Execute then
    begin
      ProjProp.Saved := True;
      if(ProjProp.FileType = FILE_TYPE_UNKNOW) then
      begin
        ProjProp.FileType := GetFileType(FileName);
        ProjProp.CompilerType := GetCompiler(ProjProp.FileType);
      end;
      ProjProp.FileName := FileName;
      ProjProp.SaveAll(True);
      FileSave.Enabled := FileProp.Modified;
      BtnSave.Enabled := FileSave.Enabled;
      PopTabsSave.Enabled := FileSave.Enabled;
    end;
    Free;
  end
  else
  begin
    FileProp.Project.Compiled := False;
    if FileProp is TProjectProperty then
      TProjectProperty(FileProp).SaveAll(True)
    else
      FileProp.Save;
    FileSave.Enabled := FileProp.Modified;
    BtnSave.Enabled := FileSave.Enabled;
    PopTabsSave.Enabled := FileSave.Enabled;
  end;

end;

//detect if enter action on file of list
procedure TFrmFalconMain.TreeViewProjectsKeyPress(Sender: TObject; var Key: Char);
var
  ProjProp: TProjectProperty;
begin
  if not (Key = #13) or TreeViewProjects.IsEditing then Exit;
  if (TreeViewProjects.SelectionCount < 1) then Exit;
  Key := #0;
  if (TObject(TreeViewProjects.Selected.Data) is TProjectProperty) then
  begin
    ProjProp := TProjectProperty(TreeViewProjects.Selected.Data);
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
  FileClose.Enabled := (PageControlEditor.PageCount > 0);
  EditSwap.Enabled := FileClose.Enabled;
  FilePrint.Enabled := (PageControlEditor.PageCount > 0);
  FileExport.Enabled := (PageControlEditor.PageCount > 0);
  BtnPrevPage.Enabled := PageControlEditor.PageCount > 1;
  BtnNextPage.Enabled := PageControlEditor.PageCount > 1;
  RunToggleBreakpoint.Enabled := (PageControlEditor.PageCount > 0);
  RunRuntoCursor.Enabled := (PageControlEditor.PageCount > 0);
  FileCloseAll.Enabled := FileClose.Enabled;
  PopTabsClose.Enabled := FileClose.Enabled;
end;

procedure TFrmFalconMain.EditorBeforeCreate(FileProp: TFileProperty);
var
  Index: Integer;
  prjs: TTreeNode;
begin
  prjs := TreeViewProjects.Items.GetFirstNode;
  while prjs <> nil do
  begin
    BoldTreeNode(prjs, False);
    prjs := prjs.getNextSibling;
  end;

  BoldTreeNode(FileProp.Project.Node, True);

  CurrentFileIsParsed := False;
  if ViewOutline.Checked then
      RSPOLine.Show;
  Index := FilesParsed.IndexOfByFileName(FileProp.GetCompleteFileName, FileProp);
  if Index >= 0 then
  begin
    CurrentFileIsParsed := True;
    UpdateActiveFileToken(FilesParsed.Items[Index]);
  end;
end;

//popupmenu close active tab editor
procedure TFrmFalconMain.FileCloseClick(Sender: TObject);
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
    PageControlEditor.CloseActiveTab;
end;

//execute application
procedure TFrmFalconMain.SubMExecuteClick(Sender: TObject);
var
  ProjProp: TProjectProperty;
  FileName, ExecFile, Source, SourcePath: String;
  List: TStrings;
  Breakpoint: TBreakpointList;
  I, J: Integer;
begin
  if GetActiveProject(ProjProp) then
  begin
    FileName := ProjProp.GetTarget;
    if FileExists(FileName) then
    begin
      case ProjProp.AppType of
        APPTYPE_DLL, APPTYPE_LIB:
        begin
          //nothing
        end;
        APPTYPE_CONSOLE, APPTYPE_GUI:
        begin
          BtnStop.Enabled := True;
          RunStop.Enabled := True;
          RunRun.Enabled := ProjProp.Debugging;
          BtnRun.Enabled := ProjProp.Debugging;
          ProjectBuild.Enabled := False;
          RunCompile.Enabled := False;
          BtnCompile.Enabled := False;
          RunExecute.Enabled := False;
          BtnExecute.Enabled := False;
          if ProjProp.Debugging then
            Caption := 'Falcon C++ [' + STR_FRM_MAIN[44] + ']'
          else
            Caption := 'Falcon C++ [' + STR_FRM_MAIN[17] + ']';//?
          HintTip.Cancel;
          if ProjProp.Debugging then
          begin
            ExecFile := StringReplace(FileName, '\', '/', [rfReplaceAll]);
            SourcePath := ExtractFilePath(ProjProp.GetCompleteFileName);
            DebugReader.FileName := 'gdb';
            DebugReader.Params := '-quiet -fullname -nx';
            DebugReader.Directory := ExtractFilePath(FileName);
            DebugReader.Start;
            if ProjProp.AppType = APPTYPE_CONSOLE then
              DebugReader.SendCommand(GDB_SETNEWCONSOLE);
            DebugReader.SendCommand(GDB_SETCONFIRM, GDB_OFF);
            DebugReader.SendCommand(GDB_SETWIDTH, '0');
            DebugReader.SendCommand(GDB_SETHEIGHT, '0');
            DebugReader.SendCommand(GDB_FILE, DoubleQuotedStr(ExecFile));
            DebugReader.SendCommand(GDB_SETARGS, ProjProp.CmdLine);
            DebugReader.SendCommand(GDB_EXECFILE, DoubleQuotedStr(ExecFile));
            List := TStringList.Create;
            ProjProp.GetBreakpointLists(List);
            if ProjProp.BreakpointCursor.Valid then
            begin
              Source := ExtractRelativePath(SourcePath,
                ProjProp.BreakpointCursor.FileName);
              Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
              DebugReader.SendCommand(GDB_BREAK, Source + ':' +
                IntToStr(ProjProp.BreakpointCursor.Line));
            end;
            for I := 0 to List.Count - 1 do
            begin
              Breakpoint := TBreakpointList(List.Objects[I]);
              Source := ExtractRelativePath(SourcePath, List.Strings[I]);
              Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
              for J := 0 to Breakpoint.Count - 1 do
              begin
                DebugReader.SendCommand(GDB_BREAK, Source + ':' +
                  IntToStr(Breakpoint.Items[J].Line));
              end;
            end;
            List.Free;
            DebugReader.SendCommand(GDB_RUN);
          end
          else
          begin
            Executor.ExecuteAndWatch(FileName, ProjProp.CmdLine,
              ExtractFilePath(FileName), True, INFINITE, LauncherFinished);
          end;
        end;
      end;
    end;
  end;
end;

//on enter in project list
procedure TFrmFalconMain.TreeViewProjectsEnter(Sender: TObject);
var
  ProjProp: TProjectProperty;
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if (TObject(TreeViewProjects.Selected.Data) is TProjectProperty) then
      ProjProp := TProjectProperty(TreeViewProjects.Selected.Data)
    else
      ProjProp := TFileProperty(TreeViewProjects.Selected.Data).Project;

    BtnRun.Enabled := not Executor.Running or (assigned(LastProjectBuild) and
        (LastProjectBuild <> ProjProp) or DebugReader.Running);
    RunRun.Enabled := BtnRun.Enabled;
    RunCompile.Enabled := BtnRun.Enabled and not DebugReader.Running;
    BtnCompile.Enabled := RunCompile.Enabled;


    if FileExists(ProjProp.GetTarget) then
    begin
      RunExecute.Enabled := ProjProp.Compiled and BtnRun.Enabled
        and not DebugReader.Running;
      BtnExecute.Enabled := RunExecute.Enabled;
    end
    else
    begin
      RunExecute.Enabled := False;
      BtnExecute.Enabled := False;
    end;
  end
  else
  begin
    //compile with no selected
    //if (PageControlEditor.PageCount > 0) then Exit;
    BtnRun.Enabled := False;
    RunRun.Enabled := False;
    RunCompile.Enabled := False;
    BtnCompile.Enabled := False;
    RunExecute.Enabled := False;
    BtnExecute.Enabled := False;
  end;
end;

//on change the active tab 
procedure TFrmFalconMain.PageControlEditorPageChange(Sender: TObject);
var
  ProjProp: TProjectProperty;
  Sheet: TFilePropertySheet;
  Prop: TFileProperty;
  Index: Integer;
  prjs: TTreeNode;
begin
  Index := PageControlEditor.ActivePageIndex;
  if (Index >= 0) then
  begin
    prjs := TreeViewProjects.Items.GetFirstNode;
    while prjs <> nil do
    begin
      BoldTreeNode(prjs, False);
      prjs := prjs.getNextSibling;
    end;

    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    Prop := TFileProperty(Sheet.Node.Data);
    if (TObject(Sheet.Node.Data) is TProjectProperty) then
      ProjProp := TProjectProperty(Sheet.Node.Data)
    else
      ProjProp := TFileProperty(Sheet.Node.Data).Project;

    BoldTreeNode(ProjProp.Node, True);

    //BtnPrevPage.Enabled := (Index > 0);
    //BtnNextPage.Enabled := (Index < (PageControlEditor.PageCount - 1))
    //  and (PageControlEditor.PageCount > 0);


    BtnRun.Enabled := not Executor.Running or (assigned(LastProjectBuild) and
      (LastProjectBuild <> ProjProp)) or DebugReader.Running;
    RunRun.Enabled := BtnRun.Enabled;
    RunCompile.Enabled := BtnRun.Enabled and not DebugReader.Running;
    BtnCompile.Enabled := RunCompile.Enabled;


    FileSave.Enabled := Prop.Modified or not Prop.Saved;
    BtnSave.Enabled := FileSave.Enabled;
    PopTabsSave.Enabled := FileSave.Enabled;

    if FileExists(ProjProp.GetTarget) then
    begin
      RunExecute.Enabled := ProjProp.Compiled and BtnRun.Enabled
         and not DebugReader.Running;
      BtnExecute.Enabled := RunExecute.Enabled;
    end
    else
    begin
      RunExecute.Enabled := False;
      BtnExecute.Enabled := False;
    end;
    //Reload Tokens ?
    if not IsLoading then
    begin
      Index := FilesParsed.IndexOfByFileName(Prop.GetCompleteFileName, Prop);
      if Index >= 0 then
        UpdateActiveFileToken(FilesParsed.Items[Index])
      else if not FilesParsed.Busy then TreeViewOutline.Items.Clear;
    end;
    //adjust code completion
    CodeCompletion.Editor := Sheet.Memo;
    AutoComplete.Editor := Sheet.Memo;

    //TimerChangeDelayTimer(TimerChangeDelay);
    //ActiveEditingFile.FileName := Prop.GetCompleteFileName;
    //TimerChangeDelayTimer(TimerChangeDelay);
    //if CurrentFileIsParsed then
     // CurrentFileIsParsed := False
    //else
    //begin
      //TimerChangeDelay.Enabled := False;
      //TimerChangeDelay.Enabled := True;
    //end;
  end
  else
  begin
    TreeViewOutline.Items.Clear;
    Index := PageControlEditor.PageCount;
    if  Index > 0 then
      PageControlEditor.ActivePageIndex := Index - 1;
    //BtnPrevPage.Enabled := Index > 1;
    //BtnNextPage.Enabled := False;
  end;
  CheckIfFilesHasChanged;
end;

//compile and execute application
procedure TFrmFalconMain.SubMRunClick(Sender: TObject);
var
  ProjProp: TProjectProperty;
begin
  if GetActiveProject(ProjProp) then
  begin
    if DebugReader.Running then
    begin
      DebugReader.SendCommand(GDB_CONTINUE);
      Exit;
    end;
    CompilerActiveMsg := STR_FRM_MAIN[18];
    if ProjProp.NeedBuild  then
    begin
      CompStoped := False;
      ProjProp.Build(True);
    end
    else
      SubMExecuteClick(Sender);
  end;
end;

//on execution finished
procedure TFrmFalconMain.LauncherFinished(Sender: TObject);
begin
  BtnStop.Enabled := False;
  RunStop.Enabled := False;
  RunRun.Enabled := TreeViewProjects.Items.Count > 0;
  BtnRun.Enabled := RunRun.Enabled;
  ProjectBuild.Enabled := TreeViewProjects.Items.Count > 0;
  RunCompile.Enabled := TreeViewProjects.Items.Count > 0;
  BtnCompile.Enabled := RunCompile.Enabled;
  RunExecute.Enabled := TreeViewProjects.Items.Count > 0;
  BtnExecute.Enabled := RunExecute.Enabled;
  //debug
  RunStepInto.Enabled := False;
  BtnStepInto.Enabled := False;
  RunStepOver.Enabled := False;
  BtnStepOver.Enabled := False;
  RunStepReturn.Enabled := False;
  BtnStepReturn.Enabled := False;
  //--clean
  if Assigned(LastProjectBuild) then
    LastProjectBuild.BreakpointCursor.Valid := False;
  DebugActiveFile := nil;
  DebugActiveLine := -1;
  CommandQueue.Clear;
  //****************
  Caption := 'Falcon C++';
end;

//stop execution or compilation
procedure TFrmFalconMain.SubMStopClick(Sender: TObject);
begin
  CompStoped := True;
  if CompilerCmd.Executing then
    CompilerCmd.Stop;
  if Executor.Running then
    Executor.Reset;
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_QUIT);
  if DebugReader.Running then
  begin
    Application.ProcessMessages;
    Sleep(100);//?
    DebugReader.Stop;
  end;
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
    ProjectPopupMenuItens(True, True, True, True, True, True, True, False,
        False, False, False, False, False);
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
  Prop: TFileProperty;
  Hits: THitTests;
begin
  GetCursorPos(MPos);
  MPos := TreeViewProjects.ScreenToClient(MPos);
  Hits := TreeViewProjects.GetHitTestInfoAt(MPos.X, MPos.Y);
  if ([htOnItem]* Hits) <> [] then
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
    Prop := TFileProperty(Node.Data);
    if Config.Environment.OneClickOpenFile and
      not (Prop.FileType in [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT]) then
    begin
      Node.EndEdit(True);
      Prop.Edit;
    end;
  end;
end;

//compile current project
procedure TFrmFalconMain.SubMCompileClick(Sender: TObject);
var
  ProjProp: TProjectProperty;
begin
  CompilerActiveMsg := STR_FRM_MAIN[18];
  if GetActiveProject(ProjProp) then
  begin
    CompStoped := False;
    ProjProp.Build;
  end;
end;

//select all text
procedure TFrmFalconMain.SubMSelectAllClick(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex >= 0) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    if (Sheet.Memo.Focused) then
      Sheet.Memo.SelectAll;
  end;
end;

//build application
procedure TFrmFalconMain.SubMBuildClick(Sender: TObject);
var
  ProjProp: TProjectProperty;
begin
  CompilerActiveMsg := STR_FRM_MAIN[19];
  if GetActiveProject(ProjProp) then ProjProp.Build;
end;

procedure TFrmFalconMain.TreeViewProjectsEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
var
  OldName, NewName: String;
  Ext: String;
  Index: Integer;
  Sheet: TFilePropertySheet;
begin
  if (Node.Level = 0) then
  begin
    NewName := TFileProperty(Node.Data).FileName;
    if (TFileProperty(Node.Data).FileType = FILE_TYPE_PROJECT) then
    begin
      if (S <> TFileProperty(Node.Data).Caption) then
        TFileProperty(Node.Data).Rename(ExtractFilePath(NewName) +
          RemoveFileExt(S) + '.fpj');
      Exit;
    end;
    if (Length(S) = 0) then
    begin
      S := ExtractFileName(NewName);
      Exit;
    end;
    Ext := ExtractFileExt(TFileProperty(Node.Data).FileName);
    NewName := ExtractFilePath(NewName);
    if Ext <> ExtractFileExt(S) then
      TFileProperty(Node.Data).Rename(NewName + ExtractName(S) + Ext)
    else
      TFileProperty(Node.Data).Rename(NewName + S);
    S := ExtractFileName(TFileProperty(Node.Data).FileName);
    if TFileProperty(Node.Data).GetSheet(Sheet) then
      Sheet.Caption :=S;
  end
  else
  begin
    NewName := TFileProperty(Node.Data).FileName;
    OldName := TFileProperty(Node.Data).GetCompleteFileName;
    if (Length(S) = 0) then
    begin
      S := NewName;
      Exit;
    end;
    Ext := ExtractFileExt(TFileProperty(Node.Data).FileName);
    if Ext <> ExtractFileExt(S) then
      TFileProperty(Node.Data).Rename(ExtractName(S) + Ext)
    else
      TFileProperty(Node.Data).Rename(S);
    S := TFileProperty(Node.Data).FileName;
    NewName := TFileProperty(Node.Data).GetCompleteFileName;
    Index := FilesParsed.IndexOfByFileName(OldName);
    if Index >= 0 then
      FilesParsed.Items[Index].FileName := NewName;
    if GetActiveSheet(sheet) then
    begin
      if Sheet.Node  = Node then
      begin
        ActiveEditingFile.FileName := NewName;
      end;
    end;

    if TFileProperty(Node.Data).GetSheet(Sheet) then
      Sheet.Caption :=S;
  end;
end;

procedure TFrmFalconMain.TreeViewProjectsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) then
    if (TreeViewProjects.SelectionCount = 1) then
      TreeViewProjects.Selected.EditText;
end;

function TFrmFalconMain.RemoveFile(FileProp: TFileProperty): Boolean;
var
  Node: TTreeNode;
  ProjProp: TProjectProperty;
  I: Integer;
begin
  Result := False;
  Node := FileProp.Node;
  if (Node.Level = 0) then//is project
  begin
    ProjProp := FileProp.Project;
    if ProjProp.Modified or (not ProjProp.Saved and not ProjProp.AllFilesIsNew) or
       ProjProp.FilesChanged then
    begin//modified
      I := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[10],
       [ExtractFileName(ProjProp.FileName)])), 'Falcon C++',
       MB_YESNOCANCEL + MB_ICONINFORMATION);
      case I of
        mrYes:
        begin
          FileSaveClick(Self);
          if not ProjProp.Saved then Exit;
        end;
        mrCancel: Exit;
      end;//case
    end;
    if DebugReader.Running and Assigned(DebugActiveFile) and
      (DebugActiveFile.Project = ProjProp) then
    begin
      DebugReader.Stop;
      DebugActiveLine := -1;
      DebugActiveFile := nil;
    end;
    ProjProp.CloseAll;
    if LastProjectBuild = ProjProp then
    begin
      LastProjectBuild := nil;
      ListViewMsg.Clear;
    end;
    ProjProp.Free;
    Node.Delete;
    if TreeViewProjects.Items.Count = 0 then
    begin
      LastProjectBuild := nil;
      ListViewMsg.Clear;
      RSPCmd.Hide;
    end;
  end//level = 0
  else
  begin
    FileProp := TFileProperty(Node.Data);
    I := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[20],
     [FileProp.Caption])), 'Falcon C++',
       MB_YESNO + MB_ICONQUESTION);
    if I <> mrYes then Exit;
    FileProp.Delete;
  end;

  ProjectPopupMenuItens(True, True, True, True, True, True, True,
      False, False, False, False, False, False);
  TreeViewProjectsChange(TreeViewProjects, TreeViewProjects.Selected);
  TextEditorExit(Self);
  //enable items if has open in sheet
  FileClose.Enabled := PageControlEditor.PageCount > 0;
  FileCloseAll.Enabled := PageControlEditor.PageCount > 0;
  EditSwap.Enabled := FileClose.Enabled;
  FileRemove.Enabled := TreeViewProjects.SelectionCount > 0;
  BtnRemove.Enabled := TreeViewProjects.SelectionCount > 0;
  BtnNextPage.Enabled := PageControlEditor.PageCount > 1;
  BtnPrevPage.Enabled := PageControlEditor.PageCount > 1;
  EditDelete.Enabled := PageControlEditor.PageCount > 0;

  FilePrint.Enabled := PageControlEditor.PageCount > 0;
  RunToggleBreakpoint.Enabled := PageControlEditor.PageCount > 0;
  RunRuntoCursor.Enabled := PageControlEditor.PageCount > 0;
  FileExport.Enabled := PageControlEditor.PageCount > 0;//?
  RSPOLine.Visible := (PageControlEditor.PageCount > 0) and ViewOutline.Checked;
  Result := True;
end;

procedure TFrmFalconMain.PopProjDelFromDskClick(Sender: TObject);
var
  Node: TTreeNode;
  FileProp: TFileProperty;
  I: Integer;
begin
  if (TreeViewProjects.SelectionCount > 0) then
  begin
    if not TreeViewProjects.IsEditing then
    begin
      Node := TreeViewProjects.Selected;
      FileProp := TFileProperty(Node.Data);
      I := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[21],
           [FileProp.Caption])), 'Falcon C++', MB_YESNOCANCEL+MB_ICONEXCLAMATION);
      case I of
        mrYes:
        begin
          FileProp.DeleteOfDisk;
          TreeViewProjectsChange(TreeViewProjects, TreeViewProjects.Selected);
          PageControlEditorChange(PageControlEditor);
          if PageControlEditor.ActivePageIndex < 0 then
            TextEditorExit(nil);
        end;
      end;
    end;//not editing
  end;//count > 0
end;

procedure TFrmFalconMain.PopProjRenameClick(Sender: TObject);
begin
  TreeViewProjects.Selected.EditText;
end;

procedure TFrmFalconMain.PopProjOpenClick(Sender: TObject);
begin
  TFileProperty(TreeViewProjects.Selected.Data).Open;
end;

procedure TFrmFalconMain.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFalconMain.FileCloseAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I:= Pred(PageControlEditor.PageCount) downto 0 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
end;

procedure TFrmFalconMain.ToolsClick(Sender: TObject);
begin
  TToolMenuItem(Sender).ExecuteCommand;
end;

procedure TFrmFalconMain.SendDataCopyData(var Msg: TWMCopyData);
begin
  SendData.Action(Msg);
end;

function TFrmFalconMain.FileInHistory(const FileName: String;
  var HistCount: Integer): Boolean;
var
  I: Integer;
begin
  HistCount := 0;
  Result := False;
  if FileReopen.Count < 3 then Exit;
  HistCount := FileReopen.Count - 2;
  for I := 2 to Pred(FileReopen.Count) do
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
  NewFileName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  if FileReopen.Count < 3 then Exit;
  for I := 2 to Pred(FileReopen.Count) do
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

function TFrmFalconMain.AddFileToHistory(const FileName: String): Boolean;
var
  HistCount: Integer;
  Item: TDataMenuItem;
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  if FileInHistory(FileName, HistCount) then Exit;
  while (HistCount >= Config.Environment.MaxFileInReopen) do
  begin
    FileReopen.Delete(Pred(FileReopen.Count));
    if FileReopen.Count <= 2 then Break;
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

procedure TFrmFalconMain.RemoveFileFromHistoric(FileName: String);
var
  I: Integer;
begin
  if FileReopen.Count < 3 then Exit;
  for I := 2 to Pred(FileReopen.Count) do
  begin
    if CompareText(TDataMenuItem(FileReopen.Items[I]).HelpFile, FileName) = 0 then
    begin
      FileReopen.Delete(I);
      if FileReopen.Count > 2 then Exit;
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
    FileReopen.Delete(Pred(FileReopen.Count));
  end;
  TTBXItem(FileReopen.Items[0]).Caption := STR_FRM_MAIN[31];
  TTBXItem(FileReopen.Items[0]).Enabled := False;
  TTBXItem(FileReopen.Items[0]).ImageIndex := -1;
end;

procedure TFrmFalconMain.ReopenFileClick(Sender: TObject);
var
  Proj: TProjectProperty;
begin
  if not (Sender is TDataMenuItem) then Exit;
  IsLoading := True;
  if OpenFileWithHistoric(TDataMenuItem(Sender).HelpFile, Proj) then
    ParseProjectFiles(Proj);
  IsLoading := False;
end;

function TFrmFalconMain.OpenFileWithHistoric(Value: String;
  var Proj: TProjectProperty): Boolean;
var
  ProjProp: TProjectProperty;
  FileProp: TFileProperty;
begin
  Result := False;
  if not FileExists(Value) then
  begin
    RemoveFileFromHistoric(Value);
    Exit;
  end;
  if GetFilePropertyByFileName(Value, FileProp) then
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
      ImportDevCppProject(Value)
    else if CompareText(ExtractFileExt(Value), '.cbp') = 0 then
      ImportCodeBlocksProject(Value)
    else if CompareText(ExtractFileExt(Value), '.vcproj') = 0 then
      ImportMSVCProject(Value)
    else
    begin
      ProjProp := OpenFile(Value);
      Result := True;
      Proj := ProjProp;
      AddFileToHistory(Value);
      if ProjProp.FileType <> FILE_TYPE_PROJECT then ProjProp.Edit;
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
    TreeViewOutlineDblClick(TreeViewProjects)
  else
    TreeViewOutlineOldProc(Msg);
end;

procedure TFrmFalconMain.PageControlEditorProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
    GetDropredFiles(PageControlEditor, Msg)
  else
    PageControlEditorOldProc(Msg);
end;

procedure TFrmFalconMain.PanelEditorProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
    GetDropredFiles(PanelEditor, Msg)
  else
    PanelEditorOldProc(Msg);
end;

procedure TFrmFalconMain.GetDropredFiles(Sender: TObject; var Msg: TMessage);
var
   FileCount : longInt;
   Buffer : array[0..MAX_PATH] of char;
   Files: TStrings;
   I: Integer;
   P: TPoint;
begin
  Files := TStringList.Create;
  FileCount := DragQueryFile(TWMDropFiles(Msg).Drop, $FFFFFFFF, nil, 0) ;
  for I:= 0 to Pred(FileCount) do
  begin
    DragQueryFile(TWMDropFiles(Msg).Drop, i, @Buffer, sizeof(buffer));
    if FileExists(StrPas(buffer)) then
      Files.Add(StrPas(buffer));
  end;
  if(Sender = TreeViewProjects) then
  begin
    GetCursorPos(P);
    P := TreeViewProjects.ScreenToClient(P);
    DropFilesIntoProjectList(Files, P.X, P.Y);
  end
  else
    OnDragDropFiles(Sender, Files);
  Files.Free;
end;

procedure TFrmFalconMain.OnDragDropFiles(Sender: TObject; Files:TStrings);
var
  I: Integer;
  Proj: TProjectProperty;
begin
  IsLoading := True;
  for I:= 0 to Pred(Files.Count) do
  begin
    if OpenFileWithHistoric(Files.Strings[I], Proj) then
      ParseProjectFiles(Proj);
  end;
  IsLoading := False;
end;

procedure TFrmFalconMain.CompilerCmdStart(Sender: TObject;
  const FileName, Params: String);
begin
  Caption := 'Falcon C++ [' + CompilerActiveMsg + ']';
end;

//on build finished
procedure TFrmFalconMain.CompilerCmdFinish(Sender: TObject; const FileName,
  Params: String; ConsoleOut: TStrings; ExitCode: Integer);
var
  Item: TListItem;
  Temp, capt: String;
  RowSltd: Boolean;
  I: Integer;
  CompMessages: TStrings;
  Msg: TMinGWMsg;
begin
  ListViewMsg.Clear;
  capt := Caption;
  CompMessages := ParseResult(ConsoleOut);
  if (ExitCode = 0) then
  begin
    PanelCompStatus.Caption := STR_FRM_MAIN[39];
    PanelCompStatus.ImageIndex := 32;
    if (CompMessages.Count > 0) then
      RSPCmd.Show
    else
      RSPCmd.Hide;
    for I:= 0 to Pred(CompMessages.Count) do
    begin
      if CompStoped then break;
      if (CompMessages.Count > 500) then
        Caption := Format('Falcon C++ ['+STR_FRM_MAIN[41]+']',
          [I + 1, CompMessages.Count]);
      Application.ProcessMessages;
      Msg := TMinGWMsg(CompMessages.Objects[I]);
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
      RunExecute.Enabled := True;
      BtnExecute.Enabled := True;
      LastProjectBuild.TargetDateTime := FileDateTime(LastProjectBuild.GetTarget);
      if RunNow and ((LastProjectBuild.AppType = APPTYPE_CONSOLE) or
         (LastProjectBuild.AppType = APPTYPE_GUI)) then
        SubMExecuteClick(Sender)
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
    PanelCompStatus.Caption := STR_FRM_MAIN[40];
    PanelCompStatus.ImageIndex := 34;
    LastProjectBuild.Compiled := False;
    RSPCmd.Show;
    if (ConsoleOut.Count = 0) then
    begin
      Msg := TMinGWMsg.Create;
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
    for I:= 0 to Pred(CompMessages.Count) do
    begin
      if CompStoped then break;
      if (CompMessages.Count > 500) then
        Caption := Format('Falcon C++ ['+STR_FRM_MAIN[41]+']',
          [I + 1, CompMessages.Count]);
      Application.ProcessMessages;
      Msg := TMinGWMsg(CompMessages.Objects[I]);
      if not RowSltd and (Msg.Icon = 34) then
        if (Length(Msg.GetPosXY) > 0) then
        begin
          RowSltd := True;
          ShowLineError(LastProjectBuild, Msg);
        end;
      Item := ListViewMsg.Items.Add;
      Item.ImageIndex := Msg.Icon;
      Item.Caption := ExtractFileName(Msg.FileName);
      Item.SubItems.Add(Msg.GetPosXY);
      Item.SubItems.Add(Msg.Msg);
      Item.Data := Msg;
    end;
    Caption := capt;
    LauncherFinished(Sender);
  end;
  CompMessages.Free;
end;

procedure TFrmFalconMain.ListViewMsgDblClick(Sender: TObject);
var
  Item: TListItem;
  MPos: TPoint;
  Msg: TMinGWMsg;
begin
  GetCursorPos(MPos);
  MPos := ListViewMsg.ScreenToClient(MPos);
  Item := ListViewMsg.GetItemAt(MPos.X, MPos.Y);
  if Assigned(Item) then
  begin
    if Assigned(Item.Data) then
      Msg := TMinGWMsg(Item.Data)
    else
      Msg := nil;
    ShowLineError(LastProjectBuild, Msg);
  end;
end;

procedure TFrmFalconMain.ProjectAddClick(Sender: TObject);
var
  FileProp, NewFile: TFileProperty;
  I: Integer;
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := STR_FRM_MAIN[12] + ' |*.c; *.cpp; *.cc; *.cxx; *.c++; *.cp; *.h;'+
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
        InitialDir := ExtractFilePath(FileProp.GetCompleteFileName)
      else
        InitialDir := FileProp.GetCompleteFileName;
    end;
    if Execute then
    begin
      if GetSelectedFileInList(FileProp) then
      begin
        if not (TObject(FileProp) is TProjectProperty) then
          if (FileProp.FileType <> FILE_TYPE_FOLDER) then
            FileProp := TFileProperty(FileProp.Node.Parent.Data);
        for I:= 0 to Pred(Files.Count) do
        begin
          NewFile := GetFileProperty(GetFileType(Files.Strings[I]), COMPILER_C,
                       ExtractFileName(Files.Strings[I]),
                       ExtractName(Files.Strings[I]),
                       ExtractFileExt(Files.Strings[I]), Files.Strings[I],
                       FileProp);
          NewFile.Text.LoadFromFile(Files.Strings[I]);
          NewFile.Project.PropertyChanged := True;
        end;
      end;
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.SubMRemoveClick(Sender: TObject);
var
  Proj: TProjectProperty;
begin
  if GetActiveProject(Proj) then
  begin
    if not Assigned(FrmRemove) then
      FrmRemove := TFrmRemove.Create(Self);
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
  for I:= 0 to Pred(MenuBar.Items.Count) do
    MenuBar.Items.Items[I].Caption := STR_MENUS[I + 1];

  //File Menu
  Item := MenuFile;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_FILE[I + 1];

  //Edit Menu
  Item := MenuEdit;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_EDIT[I + 1];

  //Search Menu
  Item := MenuSearch;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_SERH[I + 1];

  //Search Menu
  Item := MenuView;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_VIEW[I + 1];

  //Project Menu
  Item := MenuProject;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_PROJ[I + 1];

  //Run Menu
  Item := MenuRun;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_RUN[I + 1];

  //Tools Menu
  Item := MenuTools;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_TOOL[I + 1];

  //Help Menu
  Item := MenuHelp;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_MENU_HELP[I + 1];

  //New From File Menu
  Item := FileNew;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_NEW_MENU[I + 1];

  //Toolbars From View Menu
  Item := ViewToolbar;
  for I:= 0 to Pred(Item.Count) do
    Item[I].Caption := STR_VIEWTOOLBAR_MENU[I + 1];

  //(Empty) From File Menu Reopen
  if FileReopen.Count > 2 then
    FileReopenClear.Caption := STR_FRM_MAIN[32]
  else
    FileReopenClear.Caption := STR_FRM_MAIN[31];

  //PopupMenu from Project List
  //Item := PopupProject.Items.Items;
  for I:= 0 to Pred(PopupProject.Items.Count) do
    PopupProject.Items.Items[I].Caption := STR_POPUP_PROJ[I + 1];

  //PopupMenu from Editor
  //Item := PopupEditor.Items;
  for I:= 0 to Pred(PopupEditor.Items.Count) do
    PopupEditor.Items.Items[I].Caption := STR_POPUP_EDITOR[I + 1];

  //PopupMenu from Tabs
  //Item := PopupTabs.Items;
  for I:= 0 to Pred(PopupTabs.Items.Count) do
    PopupTabs.Items.Items[I].Caption := STR_POPUP_TABS[I + 1];

  //tabs left
  TSProjects.Caption := STR_FRM_MAIN[1];
  TSExplorer.Caption := STR_FRM_MAIN[2];

  //tabs right
  TSOLine.Caption := STR_FRM_MAIN[3];

  //tabs down
  TSMgs.Caption := STR_FRM_MAIN[4];

  //tabs left
  ListViewMsg.Column[0].Caption := STR_FRM_MAIN[6];
  ListViewMsg.Column[1].Caption := STR_FRM_MAIN[7];
  ListViewMsg.Column[2].Caption := STR_FRM_MAIN[8];

  //Toolbars
  //DefaultBar
  for I:= 0 to Pred(DefaultBar.Items.Count) do
  begin
    DefaultBar.Items.Items[I].Caption := STR_DEFAULTBAR[I + 1];
    DefaultBar.Items.Items[I].Hint := STR_DEFAULTBAR[I + 1];
  end;

  //EditBar
  for I:= 0 to Pred(EditBar.Items.Count) do
  begin
    EditBar.Items.Items[I].Caption := STR_EDITBAR[I + 1];
    EditBar.Items.Items[I].Hint := STR_EDITBAR[I + 1];
  end;

  //SearchBar
  for I:= 0 to Pred(SearchBar.Items.Count) do
  begin
    SearchBar.Items.Items[I].Caption := STR_SEARCHBAR[I + 1];
    SearchBar.Items.Items[I].Hint := STR_SEARCHBAR[I + 1];
  end;

  //CompilerBar
  for I:= 0 to Pred(CompilerBar.Items.Count) do
  begin
    CompilerBar.Items.Items[I].Caption := STR_COMPILERBAR[I + 1];
    CompilerBar.Items.Items[I].Hint := STR_COMPILERBAR[I + 1];
  end;

  //NavigatorBar
  for I:= 0 to Pred(NavigatorBar.Items.Count) do
  begin
    NavigatorBar.Items.Items[I].Caption := STR_NAVIGATORBAR[I + 1];
    NavigatorBar.Items.Items[I].Hint := STR_NAVIGATORBAR[I + 1];
  end;

  //ProjectBar
  for I:= 0 to Pred(ProjectBar.Items.Count) do
  begin
    ProjectBar.Items.Items[I].Caption := STR_PROJECTBAR[I + 1];
    ProjectBar.Items.Items[I].Hint := STR_PROJECTBAR[I + 1];
  end;

  //HelpBar
  for I:= 0 to Pred(HelpBar.Items.Count) do
  begin
    HelpBar.Items.Items[I].Caption := STR_HELPBAR[I + 1];
    HelpBar.Items.Items[I].Hint := STR_HELPBAR[I + 1];
  end;

  //DebugBar
  for I:= 0 to Pred(DebugBar.Items.Count) do
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
  msg: TMinGWMsg;
  S: String;
  I, C: Integer;
begin
  if ListViewMsg.SelCount > 0 then
  begin
    Clipboard.Clear;
    S := '';
    C := 0;
    for I := 0 to ListViewMsg.Items.Count - 1 do
    begin
      if not ListViewMsg.Items.Item[I].Selected then Continue;
      msg := TMinGWMsg(ListViewMsg.Items.Item[I].Data);
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
    TMinGWMsg(Item.Data).Free;
end;

procedure TFrmFalconMain.Originalmessage1Click(Sender: TObject);
var
  msg: TMinGWMsg;
  S, tmp: String;
  I, C: Integer;
begin
  if ListViewMsg.SelCount > 0 then
  begin
    S := '';
    C := 0;
    for I := 0 to ListViewMsg.Items.Count - 1 do
    begin
      if not ListViewMsg.Items.Item[I].Selected then Continue;
      msg := TMinGWMsg(ListViewMsg.Items.Item[I].Data);
      tmp := msg.OriMsg;
      if Pos('${COMPILER_PATH}', Msg.OriMsg) > 0 then
        tmp := StringReplace(msg.OriMsg, '${COMPILER_PATH}',
                  FrmFalconMain.Compiler_Path, []);
      if C = 0 then
        S := tmp
      else
        S := S + #13#10 + tmp;
      Inc(C);
    end;
    MessageBox(Handle, PChar(S), 'Falcon C++', MB_OK);
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
  msg: TMinGWMsg;
  S, tmp: String;
  I, C: Integer;
begin
  if ListViewMsg.SelCount > 0 then
  begin
    Clipboard.Clear;
    S := '';
    C := 0;
    for I := 0 to ListViewMsg.Items.Count - 1 do
    begin
      if not ListViewMsg.Items.Item[I].Selected then Continue;
      msg := TMinGWMsg(ListViewMsg.Items.Item[I].Data);
      tmp := msg.OriMsg;
      if Pos('${COMPILER_PATH}', Msg.OriMsg) > 0 then
        tmp := StringReplace(msg.OriMsg, '${COMPILER_PATH}',
                  FrmFalconMain.Compiler_Path, []);
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
  ProjProp: TProjectProperty;
  I: Integer;
begin
  for I:= 0 to Pred(TreeViewProjects.Items.Count) do
  begin
    if (TreeViewProjects.Items.Item[I].Level <> 0) then Continue;
    ProjProp := TProjectProperty(TreeViewProjects.Items.Item[I].Data);
    if not ProjProp.Saved then
    with TSaveDialog.Create(Self) do
    begin
      FileName := ProjProp.Caption;
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
          Filter := STR_NEW_MENU[3] + ' (*.cpp)|*.cpp';
        end;
        FILE_TYPE_H:
        begin
          DefaultExt := '.h';
          Filter := STR_NEW_MENU[4] + ' (*.h)|*.h';
        end;
        FILE_TYPE_RC:
        begin
          DefaultExt := '.rc';
          Filter := STR_NEW_MENU[5] + ' (*.rc)|*.rc';
        end;
        FILE_TYPE_UNKNOW: Filter := STR_FRM_MAIN[12] + '|*.*';
      end;
      Options := Options + [ofOverwritePrompt];
      if Execute then
      begin
        ProjProp.Saved := True;
        ProjProp.FileType := GetFileType(FileName);
        ProjProp.CompilerType := GetCompiler(ProjProp.FileType);
        ProjProp.FileName := FileName;
        ProjProp.SaveAll(True);
        FileSave.Enabled := False;
        BtnSave.Enabled := FileSave.Enabled;
        PopTabsSave.Enabled := FileSave.Enabled;
      end;
    end
    else
    begin
      ProjProp.SaveAll(True);
      FileSave.Enabled := False;
      BtnSave.Enabled := FileSave.Enabled;
      PopTabsSave.Enabled := FileSave.Enabled;
    end;
  end;
end;

procedure TFrmFalconMain.FileSaveAsClick(Sender: TObject);
var
  FileProp: TFileProperty;
  ProjProp: TProjectProperty;
begin
  if GetActiveFile(FileProp) then
  begin
    if (FileProp is TProjectProperty) then
      ProjProp := TProjectProperty(FileProp)
    else
      ProjProp := FileProp.Project;
    with TSaveDialog.Create(Self) do
    begin
      FileName := ProjProp.Caption;
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
        FILE_TYPE_UNKNOW: Filter := STR_FRM_MAIN[35] + ' |*.fpj; *.c; *.cpp;' +
          ' *.cc; *.cxx; *.c++; *.cp; *.h; *.hpp; *.rh; *.hh; *.rc| ' +
          STR_FRM_MAIN[12] + ' (*.*)|*.*';
      end;
      Options := Options + [ofOverwritePrompt];
      if Execute then
      begin
        ProjProp.Saved := True;
        if(ProjProp.FileType = FILE_TYPE_UNKNOW) then
        begin
          ProjProp.FileType := GetFileType(FileName);
          ProjProp.CompilerType := GetCompiler(ProjProp.FileType);
        end;
        ProjProp.SaveAs(FileName);
        ProjProp.Node.Text := ProjProp.Caption;
        FileSave.Enabled := FileProp.Modified;
        BtnSave.Enabled := FileSave.Enabled;
        PopTabsSave.Enabled := FileSave.Enabled;
        //update status bar
        PanelActiveFile.ImageIndex := FILE_IMG_LIST[FileProp.FileType];
        PanelActiveFile.Caption := FileProp.Caption;
        PanelFileDesc.Caption := FileProp.GetCompleteFileName;
      end;
    end
  end;
end;

procedure TFrmFalconMain.DetectScope(Memo: TSynMemo);
var
  Token: TTokenClass;
  Node: TTreeNode;
  SelLine, SelStart: Integer;
  BufferCoord: TBufferCoord;
begin
  BufferCoord := Memo.CaretXY;
  SelLine := BufferCoord.Line;
  if BufferCoord.Line > 0 then
  begin
    if BufferCoord.Char > (Length(Memo.Lines[SelLine - 1]) + 1) then
      BufferCoord.Char := Length(Memo.Lines[SelLine - 1]) + 1;
  end;
  SelStart := Memo.RowColToCharIndex(BufferCoord);
  if ActiveEditingFile.GetTokenAt(Token, SelStart, SelLine) then
  begin
    if Assigned(Token.Parent) and
      (Token.Parent.Token in [tkParams, tkFunction, tkPrototype,
      tkConstructor]) then
    begin
      Token := Token.Parent;
      if (Token.Token = tkParams) and Assigned(Token.Parent) then
        Token := Token.Parent;
    end;
    Node := TTreeNode(Token.Data);
    //unknow bug
    if not Assigned(Node) or (TreeViewOutline.Items.Count = 0) then
      Exit;
    Node.Selected := True;
    Node.Expanded := True;
    //Node.MakeVisible;
    //SetScrollPos(TreeViewOutline.Handle, SB_HORZ, 0, True);
    //TreeViewOutline.Update;
  end
  else if ActiveEditingFile.GetScopeAt(Token, SelStart) then
  begin
    Node := TTreeNode(Token.Data);
    //unknow bug
    if not Assigned(Node) or (TreeViewOutline.Items.Count = 0) then
      Exit;
    Node.Selected := True;
    Node.Expanded := True;
    //Node.MakeVisible;
    //SetScrollPos(TreeViewOutline.Handle, SB_HORZ, 0, True);
    //TreeViewOutline.Update;
  end;
end;

//all actions of text editor
procedure TFrmFalconMain.TextEditorAllAction(Sender: TObject);
var
  Memo: TSynMemo;
begin
  if (Sender is TSynMemo) then
  begin
    Memo := TSynMemo(Sender);
    EditUndo.Enabled := Memo.CanUndo;
    BtnUndo.Enabled := Memo.CanUndo;
    PopEditorUndo.Enabled := Memo.CanUndo;
    EditRedo.Enabled := Memo.CanRedo;
    BtnRedo.Enabled := Memo.CanRedo;
    PopEditorRedo.Enabled := Memo.CanRedo;
    PanelRowCol.Caption := Format('Ln : %d  Col : %d   Sel : %d',
      [Memo.DisplayY, Memo.DisplayX, Memo.SelLength]);
    EditSelectAll.Enabled := not (Memo.SelLength = Length(Memo.Text)) and
                            (Length(Memo.Text) > 0);
    PopEditorSelectAll.Enabled := EditSelectAll.Enabled;
    PopEditorDelete.Enabled := ((Memo.Focused) and (Length(Memo.Text) > 0)
                          and (Memo.SelStart <> Length(Memo.Text))) or
                          (TreeViewProjects.SelectionCount > 0);
    EditDelete.Enabled := PopEditorDelete.Enabled;

    EditCopy.Enabled := (Memo.SelLength > 0);
    EditIndent.Enabled := EditCopy.Enabled;
    EditUnindent.Enabled := EditCopy.Enabled;
    PopEditorCopy.Enabled := EditCopy.Enabled;

    EditCut.Enabled := EditCopy.Enabled;
    PopEditorCut.Enabled := EditCopy.Enabled;

    EditPaste.Enabled := Memo.CanPaste;
    PopEditorPaste.Enabled := Memo.CanPaste;
  end;
end;

//onparser last active file
procedure TFrmFalconMain.TextEditorFileParsed(EditFile: TFileProperty;
  TokenFile: TTokenFile);
var
  FullIncludeName: String;
  I: Integer;
begin
  for I := 0 to TokenFile.Includes.Count - 1 do
  begin
    FullIncludeName := Compiler_Path + '\include\' +
      ConvertSlashes(TokenFile.Includes.Items[I].Name);
    if not ThreadLoadTkFiles.Busy then
    begin
      ThreadLoadTkFiles.Free;
      ThreadLoadTkFiles := TThreadLoadTokenFiles.Create;
    end;
    ThreadLoadTkFiles.Start(FilesParsed, FullIncludeName, Compiler_Path +
      '\include\', ConfigRoot + 'include\', '.h.prs');
  end;
end;

//event on change text in editor
procedure TFrmFalconMain.TextEditorChange(Sender: TObject);
var
  Memo: TSynMemo;
  Sheet: TFilePropertySheet;
  FilePrp: TFileProperty;
begin
  TextEditorAllAction(Sender);
  if (Sender is TSynMemo) then
  begin
    Memo := TSynMemo(Sender);
    if Config.Editor.HigtCurLine then
      Memo.ActiveLineColor := Config.Editor.CurLnColor
    else
      Memo.ActiveLineColor := clNone;
    Sheet := TFilePropertySheet(Memo.Owner);
    FilePrp := TFileProperty(Sheet.Node.Data);
    FileSave.Enabled := FilePrp.Modified or not FilePrp.Saved;
    BtnSave.Enabled := FileSave.Enabled;
    PopTabsSave.Enabled := FileSave.Enabled;
    if FilePrp.Modified then
      Sheet.Caption := '*' + FilePrp.Caption
    else
      Sheet.Caption := FilePrp.Caption;
    CanShowHintTip := False;
    TimerHintTipEvent.Enabled := False;
    HintTip.Cancel;
    ActiveEditingFile.FileName := FilePrp.GetCompleteFileName;
    ActiveEditingFile.Data := FilePrp;
    Memo.InvalidateGutterLines(Memo.CaretY - 1, Memo.CaretY + 1);
    if CurrentFileIsParsed then
      CurrentFileIsParsed := False
    else
    begin
      //ignore on loading
      if not IsLoading then
      begin
        TimerChangeDelay.Enabled := False;
        TimerChangeDelay.Enabled := True;
      end;
    end;
    if LastKeyPressed = '(' then
    begin
      LastKeyPressed := #0;
      ShowHintParams(Sender as TSynMemo);
    end;
  end;
end;


//other event of change of code editor
procedure TFrmFalconMain.TextEditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  HintTip.Cancel;
  if (Sender is TSynMemo) then
  begin
    DetectScope(Sender as TSynMemo);
    if Config.Editor.HigtCurLine then
      (Sender as TSynMemo).ActiveLineColor := Config.Editor.CurLnColor
    else
      (Sender as TSynMemo).ActiveLineColor := clNone;
  end;

  if HintParams.Activated and ((scCaretX in Changes) or (scCaretY in Changes))
    and (Sender is TSynMemo) then
  begin
     TimerHintParams.Enabled := False;
     TimerHintParams.Enabled := True;
  end;
  TextEditorAllAction(Sender);
end;

// on enter in code editor
procedure TFrmFalconMain.TextEditorEnter(Sender: TObject);
var
  ProjProp: TProjectProperty;
  FileProp: TFileProperty;
  I, X, Y: Integer;
begin
  CheckIfFilesHasChanged;
  if GetActiveFile(FileProp) then
  begin
    PanelActiveFile.ImageIndex := FILE_IMG_LIST[FileProp.FileType];
    PanelActiveFile.Caption := FileProp.Caption;
    PanelFileDesc.Caption := FileProp.GetCompleteFileName;
  end;
  if GetActiveProject(ProjProp) then
  begin
    FileSaveAs.Enabled := True;
    if (Sender Is TSynMemo) then
    begin
      TextEditorAllAction(Sender);
      for I := 1 to 9 do
        if TSynMemo(Sender).GetBookMark(I, X, Y) then
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
      BtnToggleBook.Enabled := True;
      BtnGotoBook.Enabled := True;
      EditBookmarks.Enabled := True;
      EditGotoBookmarks.Enabled := True;
      EditorBookmarks.Enabled := True;
      EditorGotoBookmarks.Enabled := True;
      PopEditorTools.Enabled := True;
      EditFormat.Enabled := AStyleLoaded;

      SearchFind.Enabled := True;
      SearchGotoFunction.Enabled := True;
      SearchGotoLine.Enabled := TSynMemo(Sender).Lines.Count > MINLINE_TOENABLE_GOTOLINE;
      SearchGotoPrevFunc.Enabled := True;
      SearchGotoNextFunc.Enabled := True;
      SearchFindNext.Enabled := True;
      SearchFindPrev.Enabled := True;
      SearchFindFiles.Enabled := True;
      BtnFind.Enabled := True;
      SearchReplace.Enabled := True;
      BtnReplace.Enabled := True;
    end;

    BtnRun.Enabled := not Executor.Running or (assigned(LastProjectBuild) and
        (LastProjectBuild <> ProjProp)) or DebugReader.Running;
    RunRun.Enabled := BtnRun.Enabled;
    RunCompile.Enabled := BtnRun.Enabled and not DebugReader.Running;
    BtnCompile.Enabled := RunCompile.Enabled;
    PopEditorProperties.Enabled := True;
    BtnProperties.Enabled := True;
    ProjectProperties.Enabled := True;
    ProjectBuild.Enabled := BtnRun.Enabled;

    if FileExists(ProjProp.GetTarget) and ProjProp.Compiled then
    begin
      RunExecute.Enabled := BtnRun.Enabled and not DebugReader.Running;
      BtnExecute.Enabled := RunExecute.Enabled;
    end
    else
    begin
      RunExecute.Enabled := False;
      BtnExecute.Enabled := False;
    end;
  end;
end;

//on exit of code editor
procedure TFrmFalconMain.TextEditorExit(Sender: TObject);
var
  ProjProp: TProjectProperty;
begin
  CheckIfFilesHasChanged;
  HintParams.Cancel;
  EditUndo.Enabled := False;
  BtnUndo.Enabled := False;
  PopEditorUndo.Enabled := False;

  EditRedo.Enabled := False;
  BtnRedo.Enabled := False;
  PopEditorRedo.Enabled := False;

  EditSelectAll.Enabled := False;
  EditDelete.Enabled := False;
  PopEditorSelectAll.Enabled := False;

  EditCopy.Enabled := False;
  PopEditorCopy.Enabled := False;
  EditIndent.Enabled := False;
  EditUnindent.Enabled := False;

  EditCut.Enabled := False;
  PopEditorCut.Enabled := False;

  EditPaste.Enabled := False;
  PopEditorPaste.Enabled := False;

  BtnToggleBook.Enabled := PageControlEditor.PageCount > 0;
  BtnGotoBook.Enabled := PageControlEditor.PageCount > 0;
  EditBookmarks.Enabled := PageControlEditor.PageCount > 0;
  EditGotoBookmarks.Enabled := PageControlEditor.PageCount > 0;
  EditorBookmarks.Enabled := PageControlEditor.PageCount > 0;
  EditorGotoBookmarks.Enabled := PageControlEditor.PageCount > 0;

  PopEditorTools.Enabled := False;
  EditIndent.Enabled := False;
  EditUnindent.Enabled := False;
  EditFormat.Enabled := AStyleLoaded and (PageControlEditor.PageCount > 0);

  SearchFind.Enabled := PageControlEditor.PageCount > 0;
  SearchGotoFunction.Enabled := PageControlEditor.PageCount > 0;
  SearchGotoLine.Enabled := PageControlEditor.PageCount > 0;
  SearchGotoPrevFunc.Enabled := PageControlEditor.PageCount > 0;
  SearchGotoNextFunc.Enabled := PageControlEditor.PageCount > 0;
  SearchFindNext.Enabled := PageControlEditor.PageCount > 0;
  SearchFindPrev.Enabled := PageControlEditor.PageCount > 0;
  SearchFindFiles.Enabled := PageControlEditor.PageCount > 0;
  BtnFind.Enabled := PageControlEditor.PageCount > 0;
  SearchReplace.Enabled := PageControlEditor.PageCount > 0;
  BtnReplace.Enabled := PageControlEditor.PageCount > 0;

  if GetActiveProject(ProjProp) then
  begin
    BtnRun.Enabled := not Executor.Running or (assigned(LastProjectBuild) and
        (LastProjectBuild <> ProjProp)) or DebugReader.Running;
    RunRun.Enabled := BtnRun.Enabled;
    RunCompile.Enabled := BtnRun.Enabled and not DebugReader.Running;
    BtnCompile.Enabled := RunCompile.Enabled;
    RunExecute.Enabled := not ProjProp.TargetChanged and BtnRun.Enabled
       and not DebugReader.Running;
    BtnExecute.Enabled := BtnExecute.Enabled;
  end
  else
  begin
    BtnRun.Enabled := False;
    RunRun.Enabled := False;
    RunCompile.Enabled := False;
    BtnCompile.Enabled := False;
    RunExecute.Enabled := False;
    BtnExecute.Enabled := False;
  end;
end;

procedure TFrmFalconMain.TextEditorMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sheet: TFilePropertySheet;
    FileProp: TFileProperty;
begin
  if not PointsEqual(LastMousePos, Point(X, Y)) and IsForeground(Handle) then
  begin
    LastMousePos := Point(X, Y);
    if not HintParams.Activated and CanShowHintTip then
    begin
      if not GetActiveSheet(sheet) then Exit;
      TimerHintTipEvent.Enabled := False;
      if not GetActiveFile(FileProp) then Exit;
      ProcessHintView(FileProp, sheet.Memo, X, Y);
    end else if not HintParams.Activated then
    begin
      CanShowHintTip := False;
      TimerHintTipEvent.Enabled := True;
    end;
  end;
end;

//link click in edit
procedure TFrmFalconMain.TextEditorLinkClick(Sender: TObject; S,
  AttriName, FirstWord: String);
var
  FileName, Fields, Input, SaveFields: String;
  Prop: TFileProperty;
  Proj: TProjectProperty;
  sheet: TFilePropertySheet;
  Files: TStrings;
  I: Integer;
  TokenFileItem: TTokenFile;
  Token: TTokenClass;
  SelStart: Integer;
  InputError: Boolean;
begin
  //#include <stdio.h>
  if (AttriName = 'Preprocessor') and (FirstWord = 'include') then
  begin
    S := ConvertSlashes(S);
    if GetActiveSheet(sheet) then
    begin
      //search #include <stdio.h> in project
      Prop := TFileProperty(sheet.Node.Data);
      Proj := Prop.Project;
      FileName := ExpandFileName(ExtractFilePath(Prop.GetCompleteFileName) + S);
      if Proj.FileType = FILE_TYPE_PROJECT then
      begin
        Files := Proj.GetFiles;
        for I:= 0 to Files.Count - 1 do
        begin
          Prop := TFileProperty(Files.Objects[I]);
          if CompareText(FileName, Prop.GetCompleteFileName) = 0 then
          begin
            Prop.Edit;
            Files.Free;
            Exit;
          end;
        end;
        Files.Free;
      end;
      //not found in project, search on file or project folder
      if GetFilePropertyByFileName(FileName, Prop) then
      begin
        Prop.Edit;
        Exit;
      end;
      if FileExists(FileName) then
      begin
         OpenFile(FileName).Edit;
         Exit;
      end;
    end;
    //search in compiler folder
    FileName := ExpandFileName(Compiler_Path + '\include\' + S);
    if not FileExists(FileName) then
      FileName := ExpandFileName(Compiler_Path + '\lib\gcc\mingw32\4.4.1\include\c++\' + S);
    if GetFilePropertyByFileName(FileName, Prop) then
    begin
      Prop.Edit;
      Exit;
    end;
    if FileExists(FileName) then
    begin
      OpenFile(FileName).Edit;
    end
    else
      MessageBox(Handle, PChar(Format(STR_FRM_MAIN[34], [S])), 'Falcon C++',
        MB_ICONEXCLAMATION);
  end
  else {if (AttriName = 'Preprocessor') and (FirstWord = 'define') then}
  begin
    if not GetActiveSheet(sheet) then Exit;
    SelStart := sheet.Memo.RowColToCharIndex(sheet.Memo.WordStart);
    if ParseFields(sheet.Memo.Text, SelStart, Input, Fields, InputError) then
    begin
      SaveFields := Fields;
      Fields := Fields + Input;
      Input := GetFirstWord(Fields);
      if  (SaveFields <> '') and not FilesParsed.GetFieldsBaseType(Input,
        Fields, SelStart, ActiveEditingFile, TokenFileItem, Token) then
        Exit
      else if (SaveFields = '') and not FilesParsed.SearchSource(Input,
        ActiveEditingFile, TokenFileItem, Token, SelStart) then
        Exit;
      if TokenFileItem = ActiveEditingFile then //current file
      begin
          SelectToken(Token);
          Exit;
      end;
      //other file
      //is in project list
      if GetFilePropertyByFileName(TokenFileItem.FileName, Prop) then
        Prop.Edit
      else//non opened. open
        TFileProperty(OpenFile(TokenFileItem.FileName)).Edit;
      SelectToken(Token);
      {if TokenFileItem = ActiveEditingFile then //current file
      begin
        if (Token.SelStart < SelStart) or
         (Token.SelStart > SelEnd) then
        begin
          SelectToken(Token);
        end;
      end
      else  //other file
      begin
        //is in project list
        if GetFilePropertyByFileName(TokenFileItem.FileName, Prop) then
        begin
          sheet := Prop.Edit;
        end
        else
        begin //non opened. open
          Prop := TFileProperty(OpenFile(TokenFileItem.FileName));
          sheet := Prop.Edit;
        end;
        SelectToken(Token);
      end;}
    end;
    {if FilesParsed.SearchSource(S,
        ActiveEditingFile, TokenFileItem, Token, SelStart) then
    begin
      case Token.Token of
        tkClass, tkDefine..tkUnion:
        begin
          if TokenFileItem = ActiveEditingFile then //current file
          begin
            if (Token.SelStart < SelStart) or
             (Token.SelStart > SelEnd) then
            begin
              SelectToken(Token);
            end;
          end
          else  //other file
          begin
            //is in project list
            if GetFilePropertyByFileName(TokenFileItem.FileName, Prop) then
            begin
              sheet := Prop.Edit;
            end
            else
            begin //non opened. open
              Prop := TFileProperty(OpenFile(TokenFileItem.FileName));
              sheet := Prop.Edit;
            end;
            SelectToken(Token);
          end;
        end;
        tkFunction, tkPrototype:
        begin
          if TokenFileItem = ActiveEditingFile then //current file
          begin
            if (Token.SelStart < SelStart) or
               (Token.SelStart > SelEnd) then //finded equal clicked
            begin
              SelectToken(Token);
            end
            else //search your prototype or function
            if FilesParsed.SearchSource(Token.Name,
                TokenFileItem, TokenFileItem, AOwnerToken, Token.SelStart) then
            begin
              SelectToken(AOwnerToken);
            end;
          end
          else //other file
          begin
            if GetFilePropertyByFileName(TokenFileItem.FileName, Prop) then
            begin
              sheet := Prop.Edit;
            end
            else
            begin
              Prop := TFileProperty(OpenFile(TokenFileItem.FileName));
              sheet := Prop.Edit;
            end;
            SelectToken(Token);
          end;
        end;
      end;
    end;}
    //search define
  {end
  else if (AttriName = 'Identifier') then
  begin}
    //search identifier
  end;
end;

procedure TFrmFalconMain.TextEditorMouseLeave(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  HintTip.Cancel;
end;

procedure TFrmFalconMain.TextEditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Sheet: TFilePropertySheet;
begin
  Sheet := TFilePropertySheet(TComponent(Sender).Owner);

  if (ssCtrl in Shift) and (Key = VK_ADD) then
    Sheet.Memo.Font.Size := Sheet.Memo.Font.Size + 1;
  if (ssCtrl in Shift) and (Key = VK_SUBTRACT) then
    Sheet.Memo.Font.Size := Sheet.Memo.Font.Size - 1;

  CanShowHintTip := False;
  TimerHintTipEvent.Enabled := False;
  if (Key = VK_ESCAPE) then
  begin
    HintTip.Cancel;
    //HintParams.Cancel; no cancel
  end;
  if ([ssShift, ssCtrl] = Shift) and (Key = VK_SPACE) then
  begin
    Key := 0;
    ShowHintParams(Sheet.Memo);
  end
  else if ([ssCtrl] = Shift) and (Key = VK_SPACE) then
  begin
    Key := 49;
    CodeCompletion.ActivateCompletion;
  end;

end;

procedure TFrmFalconMain.TextEditorKeyPress(Sender: TObject;
  var Key: Char);
begin
  LastKeyPressed := Key;
end;

procedure TFrmFalconMain.TextEditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
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
  Canceled: Boolean);
begin
  if not Canceled and not XMLOpened then
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
  BtnSaveAll.Enabled := (TreeViewProjects.Items.Count > 0);
  FileSaveAll.Enabled := BtnSaveAll.Enabled;
  PopTabsSaveAll.Enabled := FileSaveAll.Enabled;
  FileSaveAs.Enabled := (TreeViewProjects.SelectionCount > 0);
end;

procedure TFrmFalconMain.FormShow(Sender: TObject);
var
  Sheet: TFilePropertySheet;
begin
  if (PageControlEditor.ActivePageIndex > -1) then
  begin
    Sheet := TFilePropertySheet(PageControlEditor.ActivePage);
    if not Sheet.Memo.Focused and Sheet.Memo.Visible then
      Sheet.Memo.SetFocus;
  end;
end;

procedure TFrmFalconMain.RestoreDefault1Click(Sender: TObject);
var
  I: Integer;
begin
  RSPExplorer.Width := 230;
  RSPOLine.Width := 160;
  RSPCmd.Height := 160;

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
  ZoomEditor := Config.Editor.FontSize;
  for I := 0 to Pred(PageControlEditor.PageCount) do
  begin
    if SHEET_TYPE_FILE = TPropertySheet(PageControlEditor.Pages[I]).SheetType then
      TFilePropertySheet(PageControlEditor.Pages[I]).Memo.Font.Size := ZoomEditor;
  end;
end;

procedure TFrmFalconMain.EnvironOptions1Click(Sender: TObject);
begin
  if not Assigned(FrmEnvOptions) then
    FrmEnvOptions := TFrmEnvOptions.Create(Self);
  FrmEnvOptions.Load;
  FrmEnvOptions.ShowModal;
end;

procedure TFrmFalconMain.CompilerOptions2Click(Sender: TObject);
begin
  if not Assigned(FrmCompOptions) then
    FrmCompOptions := TFrmCompOptions.Create(Self);
  FrmCompOptions.Load;
  FrmCompOptions.ShowModal;
end;

procedure TFrmFalconMain.EditorOptions1Click(Sender: TObject);
begin
  if not Assigned(FrmEditorOptions) then
    FrmEditorOptions := TFrmEditorOptions.Create(Self);
  FrmEditorOptions.Load;
  FrmEditorOptions.ShowModal;
end;

procedure TFrmFalconMain.FullScreen1Click(Sender: TObject);
begin
  FrmPos.SetFullScreen(not FrmPos.FullScreen);
  MenuBar.Visible := not FrmPos.FullScreen;
  if FrmPos.FullScreen and not Config.Environment.ShowToolbarsInFullscreen then
    DockTop.Hide
  else
    DockTop.Show;
  MenuDock.Top := 0;
  RzStatusBar.ShowSizeGrip := not FrmPos.FullScreen;
  if FrmPos.FullScreen then
    ViewFullScreen.Caption := STR_MENU_VIEW[9]
  else
    ViewFullScreen.Caption := STR_MENU_VIEW[9];
end;

procedure TFrmFalconMain.ReportaBugorComment1Click(Sender: TObject);
begin
  if not Assigned(FrmReport) then
  begin
    FrmReport := TFrmReport.Create(Self);
    FrmReport.Show;
  end
  else
    FrmReport.BringToFront;
end;

procedure TFrmFalconMain.Packages1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', PChar(AppRoot + 'PkgManager.exe'), '',
        PChar(AppRoot), SW_SHOW)
end;

procedure TFrmFalconMain.FormDestroy(Sender: TObject);
begin
  DebugReader.Free;
  CommandQueue.Free;
  AllParsedList.Free;
  ThreadFilesParsed.Free;
  ThreadTokenFiles.Free;
  ThreadLoadTkFiles.Free;
  FilesParsed.Free;//free ActiveEditingFile
  ParseAllFiles.Free;
  Templates.Free;
  Config.Free;
  SintaxList.Free;
end;

procedure TFrmFalconMain.ViewMenuClick(Sender: TObject);
begin
  case TTBXItem(Sender).Tag of
    0: RSPExplorer.Visible := TTBXItem(Sender).Checked;
    1: RzStatusBar.Visible := TTBXItem(Sender).Checked;
    2: RSPOLine.Visible := TTBXItem(Sender).Checked and
          (PageControlEditor.ActivePageIndex >= 0);
  end;
end;

procedure TFrmFalconMain.NewItemClick(Sender: TObject);
var
  SelFile: TFileProperty;
  FileType, CompilerType: Integer;
  Ext: String;
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
  if not GetSelectedFileInList(SelFile) then SelFile := nil;
  case TControl(Sender).Tag of
    1:
    begin
      if not Assigned(FrmNewProj) then
      begin
        FrmNewProj := TFrmNewProj.Create(Self);
        FrmNewProj.ShowModal;
      end;
    end;
    2:  GetFileProperty(FILE_TYPE_C, COMPILER_C, STR_FRM_MAIN[15] + '.c', STR_FRM_MAIN[13], '.c', '', SelFile).Edit;
    3:  GetFileProperty(FILE_TYPE_CPP, COMPILER_CPP, STR_FRM_MAIN[15] + '.cpp', STR_FRM_MAIN[13], '.cpp', '', SelFile).Edit;
    4:  GetFileProperty(FILE_TYPE_H, NO_COMPILER, STR_FRM_MAIN[15] + '.h', STR_FRM_MAIN[13], '.h', '', SelFile).Edit;
    5:  GetFileProperty(FILE_TYPE_RC, COMPILER_RC, STR_FRM_MAIN[16] + '.rc', STR_FRM_MAIN[13], '.rc', '', SelFile).Edit;
    6:  GetFileProperty(FILE_TYPE_UNKNOW, CompilerType, STR_FRM_MAIN[15], STR_FRM_MAIN[13], '', '', SelFile).Edit;
    7:  GetFileProperty(FILE_TYPE_FOLDER, NO_COMPILER, STR_NEW_MENU[8], STR_FRM_MAIN[14], '', '', SelFile);
  else
    GetFileProperty(FileType, CompilerType, STR_FRM_MAIN[15] + Ext,
      STR_FRM_MAIN[13], Ext, '', SelFile).Edit;
  end;
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

function TFrmFalconMain.ImportDevCppProject(const FileName: String): Boolean;
const
  DevType: array[0..3] of Integer = (APPTYPE_GUI, APPTYPE_CONSOLE, APPTYPE_LIB,
    APPTYPE_DLL);
var
  ini: Tinifile;
  Node: TTreeNode;
  NewPrj: TProjectProperty;
  NewFile: TFileProperty;
  PrjDevType, UnitCount, I: Integer;
  IsCpp, Edited: Boolean;
  IconName, SourceFileName: String;
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  ini := TIniFile.Create(FileName);
  if not ini.SectionExists('Project') then
  begin
    ini.Free;
    Exit;
  end;
  Node := TreeViewProjects.Items.AddChild(nil, '');
  NewPrj := TProjectProperty.Create(PageControlEditor, Node);
  NewPrj.Project := NewPrj;
  NewPrj.FileType := FILE_TYPE_PROJECT;
  Node.Data := NewPrj;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  Node.Text := NewPrj.Caption;
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
  NewPrj.Libs := StringReplace(NewPrj.Libs, '_@@_', '', [rfReplaceAll]);
  NewPrj.Flags := StringReplace(NewPrj.Flags, '_@@_', '', [rfReplaceAll]);
  PrjDevType := ini.ReadInteger('Project', 'Type', 1);
  if PrjDevType > 3 then PrjDevType := 1;
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
  NewPrj.IncludeVersionInfo       := ini.ReadBool   ('Project',     'IncludeVersionInfo', False);
  NewPrj.Version.Major            := ini.ReadInteger('VersionInfo', 'Major', 0);
  NewPrj.Version.Minor            := ini.ReadInteger('VersionInfo', 'Minor', 0);
  NewPrj.Version.Release          := ini.ReadInteger('VersionInfo', 'Release', 0);
  NewPrj.Version.Build            := ini.ReadInteger('VersionInfo', 'Build', 0);
  NewPrj.Version.LanguageID       := ini.ReadInteger('VersionInfo', 'LanguageID', 1033);
  NewPrj.Version.CharsetID        := ini.ReadInteger('VersionInfo', 'CharsetID', 1252);
  NewPrj.Version.CompanyName      := ini.ReadString ('VersionInfo', 'CompanyName', '');
  NewPrj.Version.FileVersion      := ini.ReadString ('VersionInfo', 'FileVersion', '');
  NewPrj.Version.FileDescription  := ini.ReadString ('VersionInfo', 'FileDescription', '');
  NewPrj.Version.InternalName     := ini.ReadString ('VersionInfo', 'InternalName', '');
  NewPrj.Version.LegalCopyright   := ini.ReadString ('VersionInfo', 'LegalCopyright', '');
  NewPrj.Version.OriginalFilename := ini.ReadString ('VersionInfo', 'OriginalFilename', '');
  NewPrj.Version.ProductName      := ini.ReadString ('VersionInfo', 'ProductName', '');
  NewPrj.Version.ProductVersion   := ini.ReadString ('VersionInfo', 'ProductVersion', '');
  NewPrj.AutoIncBuild             := ini.ReadBool   ('VersionInfo', 'AutoIncBuildNr', False);
  UnitCount                       := ini.ReadInteger('Project',     'UnitCount', 0);
  Edited := False;
  for I:= 1 to UnitCount do
  begin
    SourceFileName :=  ini.ReadString('Unit'+ IntToStr(I), 'FileName', '');
    NewFile := GetFileProperty(GetFileType(SourceFileName),
                GetCompiler(GetFileType(SourceFileName)), SourceFileName,
                RemoveFileExt(SourceFileName), ExtractFileExt(SourceFileName),
                '', NewPrj);
    if FileExists(NewFile.GetCompleteFileName) then
    begin
      NewFile.Text.LoadFromFile(NewFile.GetCompleteFileName);
      NewFile.DateOfFile := FileDateTime(NewFile.GetCompleteFileName);
      NewFile.Saved := True;
      NewFile.Modified := False;
      if (CompareText(NewFile.Caption, 'main.c') = 0) or
         (CompareText(NewFile.Caption, 'main.cpp') = 0) then
      begin
        NewFile.Edit;
        Edited := True;
      end;
    end;
  end;
  NewPrj.Modified := False;
  if not Edited then
    NewPrj.Node.Selected := True;
  ini.Free;
  ParseProjectFiles(NewPrj);
  Result := True;
end;

function TFrmFalconMain.ImportCodeBlocksProject(const FileName: String): Boolean;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: String;
    Default: String = ''): String;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := Temp.Attributes[Attribute]
    else
      Result := Default;
  end;

  procedure LoadFiles(XMLNode: IXMLNode; Parent: TFileProperty);
  var
    XMLDoc: TXMLDocument;
    Temp, LytRoot, FileNode: IXMLNode;
    STemp, StrProp, LytFileName: String;
    FileProp, TopFile: TFileProperty;
    CaretXY: TBufferCoord;
    sheet: TFilePropertySheet;
    TopLine, SelStart: Integer;
  begin
    TopFile := nil;
    XMLDoc := nil;
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
    while (Temp <> nil) do
    begin
      if Temp.NodeName <> 'Unit' then
      begin
        Temp := Temp.NextSibling;
        Continue;
      end;
      STemp := Temp.Attributes['filename'];
      FileProp := GetFileProperty(GetFileType(STemp),
                  GetCompiler(GetFileType(STemp)), STemp,
                  RemoveFileExt(STemp), ExtractFileExt(STemp), '', Parent);
      STemp := FileProp.GetCompleteFileName;
      if FileExists(STemp) then
      begin
        FileProp.Text.LoadFromFile(STemp);
        FileProp.DateOfFile := FileDateTime(STemp);
        FileProp.Saved := True;
        FileProp.Modified := False;
        if FileProp.FileType = FILE_TYPE_CPP then
          FileProp.Project.CompilerType := COMPILER_CPP;
      end;
      if Assigned(LytRoot) then
      begin
        FileNode :=  LytRoot.ChildNodes.First;
        while FileNode <> nil do
        begin
          if FileNode.NodeName <> 'File' then
          begin
            FileNode := FileNode.NextSibling;
            Continue;
          end;
          LytFileName := FileNode.Attributes['name'];
          if CompareText(LytFileName, FileProp.Caption) = 0 then
          begin
            StrProp := FileNode.Attributes['top'];
            if StrProp = '1' then
              TopFile := FileProp;
            SelStart := StrToInt(GetTagProperty(FileNode, 'Cursor',
              'position', '0'));
            TopLine := StrToInt(GetTagProperty(FileNode, 'Cursor',
              'topLine', '0')) + 1;
            StrProp := FileNode.Attributes['open'];
            if StrProp = '1' then
            begin
              sheet := FileProp.Edit;
              CaretXY := sheet.Memo.CharIndexToRowCol(SelStart);
              sheet.Memo.CaretXY := CaretXY;
              sheet.Memo.TopLine := TopLine;
            end;
            Break;
          end;
          FileNode := FileNode.NextSibling;
        end;
      end;
      Temp := Temp.NextSibling;
    end;
    if Assigned(TopFile) then
      TopFile.ViewPage;
    if Assigned(XMLDoc) then
      XMLDoc.Free;
  end;

var
  XMLDoc: TXMLDocument;
  ProjNode, BuildNode, TargetNode, TempNode, AddNode: IXMLNode;
  CompNode, LinkerNode: IXMLNode;
  Node: TTreeNode;
  NewPrj: TProjectProperty;
  Major, Minor: Integer;
  TempStr: String;
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
    XMLDoc.Free;
    Exit;
  end;
  Major := StrToInt(GetTagProperty(ProjNode, 'FileVersion', 'major', '0'));
  Minor := StrToInt(GetTagProperty(ProjNode, 'FileVersion', 'minor', '0'));
  if (Major <> 1) or (Minor <> 6) then
  begin
    XMLDoc.Free;
    Exit;
  end;
  //Project tag
  ProjNode := ProjNode.ChildNodes.FindNode('Project');
  if (ProjNode = nil) then
  begin
    XMLDoc.Free;
    Exit;
  end;
  Node := TreeViewProjects.Items.AddChild(nil, '');
  NewPrj := TProjectProperty.Create(PageControlEditor, Node);
  NewPrj.Project := NewPrj;
  NewPrj.FileType := FILE_TYPE_PROJECT;
  Node.Data := NewPrj;
  NewPrj.FileName := ChangeFileExt(FileName, '.fpj');
  NewPrj.Compiled := False;
  NewPrj.CompilerType := COMPILER_C;
  Node.Text := NewPrj.Caption;
  Node.Selected := True;
  Node.Focused := True;
  BuildNode := ProjNode.ChildNodes.FindNode('Build');
  if (BuildNode = nil) then
  begin
    XMLDoc.Free;
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
          TempStr := TempNode.Attributes['extension_auto'];
          ExtAuto := TempStr = '1';
          NewPrj.Target := TempNode.Attributes['output'];
        end
        else if TempNode.HasAttribute('type') then
        begin
          TempStr := TempNode.Attributes['type'];
          if TempStr = '0' then
          begin
            NewPrj.AppType := APPTYPE_GUI;
            NewPrj.Libs := Trim('-mwindows '+ NewPrj.Libs);
          end
          else if TempStr = '1' then
            NewPrj.AppType := APPTYPE_CONSOLE
          else if TempStr = '2' then
            NewPrj.AppType := APPTYPE_LIB
          else if TempStr = '3' then
          begin
            NewPrj.AppType := APPTYPE_DLL;
            NewPrj.Libs := Trim('-shared '+ NewPrj.Libs);
          end;
        end
        else if TempNode.HasAttribute('createStaticLib') then
        begin
          TempStr := TempNode.Attributes['createStaticLib'];
          createStaticLib := TempStr = '1';
        end
        else if TempNode.HasAttribute('createDefFile') then
        begin
          TempStr := TempNode.Attributes['createDefFile'];
          createDefFile := TempStr = '1';
        end;
      end
      else if TempNode.NodeName = 'Compiler' then
      begin
        AddNode := TempNode.ChildNodes.First;
        while AddNode <> nil do
        begin
          TempStr := AddNode.Attributes['option'];
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
            TempStr := AddNode.Attributes['option'];
            if TempStr = '-s' then
              NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' +
                TempStr)
            else
              NewPrj.Libs := Trim(NewPrj.Libs + ' ' + TempStr);
          end
          else if AddNode.HasAttribute('library') then
          begin
            TempStr := AddNode.Attributes['library'];
            NewPrj.Libs := Trim(NewPrj.Libs + ' -l' + TempStr);
          end;
          AddNode := AddNode.NextSibling;
        end;
      end;
      TempNode := TempNode.NextSibling;
    end;
    TempStr := TargetNode.Attributes['title'];
    if TempStr = 'Release' then
      Break;
    TargetNode := TargetNode.NextSibling;
  end;//end build childs
  CompNode := ProjNode.ChildNodes.FindNode('Compiler');
  if CompNode <> nil then
  begin
    AddNode := CompNode.ChildNodes.First;
    while AddNode <> nil do
    begin
      TempStr := AddNode.Attributes['option'];
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
        TempStr := AddNode.Attributes['option'];
        if TempStr = '-s' then
          NewPrj.CompilerOptions := Trim(NewPrj.CompilerOptions + ' ' + TempStr)
        else
          NewPrj.Libs := Trim(NewPrj.Libs + ' ' + TempStr);
      end
      else if AddNode.HasAttribute('library') then
      begin
        TempStr := AddNode.Attributes['library'];
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
  begin
    NewPrj.Libs := Trim(NewPrj.Libs + ' ' +
      Format(staticLibStr, [ChangeFileExt(NewPrj.Target, '.dll.a')]));
  end;
  if createDefFile then
  begin
    //not implemented
  end;
  LoadFiles(ProjNode, NewPrj);
  NewPrj.Modified := False;
  XMLDoc.Free;
  ParseProjectFiles(NewPrj);
  Result := True;
end;

function TFrmFalconMain.ImportMSVCProject(const FileName: String): Boolean;
begin
  //ParseProjectFiles(NewPrj);
  Result := False;
end;

procedure TFrmFalconMain.ImportFromDevCpp(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := 'Dev-C++ Project(*.dev)|*.dev';
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not ImportDevCppProject(FileName) then
        MessageBox(Self.Handle, 'Can'#39't import Dev-C++ project!', 'Falcon C++',
          MB_ICONEXCLAMATION);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ImportFromCodeBlocks(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := 'Code::Blocks Project(*.cbp)|*.cbp';
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not ImportCodeBlocksProject(FileName) then
        MessageBox(Self.Handle, 'Can'#39't import Code::Blocks project!', 'Falcon C++',
          MB_ICONEXCLAMATION);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.ImportFromMSVC(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
  begin
    Filter := 'MS Visual C++ Project(*.vcproj)|*.vcproj';
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not ImportMSVCProject(FileName) then
        MessageBox(Self.Handle, 'Can'#39't import MS Visual C++ project!', 'Falcon C++',
          MB_ICONEXCLAMATION);
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
var
  I: Integer;
begin
  if ZoomEditor >= 48 then Exit;
  Inc(ZoomEditor);
  for I := 0 to Pred(PageControlEditor.PageCount) do
  begin
    if SHEET_TYPE_FILE = TPropertySheet(PageControlEditor.Pages[I]).SheetType then
      TFilePropertySheet(PageControlEditor.Pages[I]).Memo.Font.Size := ZoomEditor;
  end;
end;

procedure TFrmFalconMain.ViewZoomDecClick(Sender: TObject);
var
  I: Integer;
begin
  if ZoomEditor <= 8 then Exit;
  Dec(ZoomEditor);
  for I := 0 to Pred(PageControlEditor.PageCount) do
  begin
    if SHEET_TYPE_FILE = TPropertySheet(PageControlEditor.Pages[I]).SheetType then
      TFilePropertySheet(PageControlEditor.Pages[I]).Memo.Font.Size := ZoomEditor;
  end;
end;

procedure TFrmFalconMain.ToggleBookmarksClick(Sender: TObject);
var
  FileProp: TFileProperty;
  Sheet: TFilePropertySheet;
begin
  if not GetActiveFile(FileProp) then Exit;
  if not FileProp.GetSheet(Sheet) then Exit;
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
  SelFile, NewFile, ExisFile: TFileProperty;
  Proj: TProjectProperty;
  I, FileType: Integer;
  SrcList, TempList: TStrings;
begin
  AnItem := TreeViewProjects.GetNodeAt(X, Y);
  SrcList := TStringList.Create;
  SelFile := nil;
  if Assigned(AnItem) then
    SelFile := TFileProperty(AnItem.Data);
  for I := 0 to List.Count - 1 do
  begin
    if CompareText(ExtractFileExt(List.Strings[I]), '.dev') = 0 then
      ImportDevCppProject(List.Strings[I])
    else if CompareText(ExtractFileExt(List.Strings[I]), '.cbp') = 0 then
      ImportCodeBlocksProject(List.Strings[I])
    else if CompareText(ExtractFileExt(List.Strings[I]), '.vcproj') = 0 then
      ImportMSVCProject(List.Strings[I])
    else
    begin
      if Assigned(AnItem) then
      begin
        if not (TFileProperty(AnItem.Data).FileType in
          [FILE_TYPE_PROJECT, FILE_TYPE_FOLDER]) then
         SelFile := nil;
      end;
      FileType := GetFileType(List.Strings[I]);
      if(FileType = FILE_TYPE_PROJECT) or not Assigned(SelFile) then
      begin
        if GetFilePropertyByFileName(List.Strings[I], ExisFile) then
        begin
          if ExisFile.FileType <> FILE_TYPE_PROJECT then
            ExisFile.Edit;
        end
        else
        begin
          Proj := OpenFile(List.Strings[I]);
          AddFileToHistory(List.Strings[I]);
          if Proj.FileType <> FILE_TYPE_PROJECT then
            Proj.Edit
          else
          begin
            TempList := Proj.GetFiles();
            SrcList.AddStrings(TempList);
            TempList.Free;
          end;
          //OpenFileWithHistoric(List.Strings[I], Proj);
        end;
      end
      else
      begin
        NewFile := GetFileProperty(GetFileType(List.Strings[I]),
                    GetCompiler(FileType),
                    ExtractFileName(List.Strings[I]),
                    ExtractName(List.Strings[I]),
                    ExtractFileExt(List.Strings[I]), List.Strings[I],
                    SelFile);
        NewFile.Text.LoadFromFile(List.Strings[I]);
        if Assigned(SelFile) then
          NewFile.Project.PropertyChanged := True;
        SrcList.AddObject(NewFile.GetCompleteFileName, NewFile);
      end;
    end;
  end;
  ParseFiles(SrcList);
  SrcList.Free;
end;

procedure TFrmFalconMain.GotoBookmarkClick(Sender: TObject);
var
  FileProp: TFileProperty;
  Sheet: TFilePropertySheet;
begin
  if not GetActiveFile(FileProp) then Exit;
  if not FileProp.GetSheet(Sheet) then Exit;
  if TTBXItem(Sender).Checked then
    Sheet.Memo.GotoBookMark(TTBXItem(Sender).Tag);
end;

procedure AdjustNewProject(Node: TTreeNode; Proj: TProjectProperty);
var
  I: Integer;
begin
  TFileProperty(Node.Data).Project := Proj;
  for I := 0 to Node.Count - 1 do
      AdjustNewProject(Node.Item[I], Proj);
end;

procedure TFrmFalconMain.TreeViewProjectsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  AnItem, Selitem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
  fpd, fps: TFileProperty;
begin
  if TreeViewProjects.Selected = nil then Exit;
  Selitem := TreeViewProjects.Selected;
  HT := TreeViewProjects.GetHitTestInfoAt(X, Y) ;
  AnItem := TreeViewProjects.GetNodeAt(X, Y) ;
  if (AnItem = nil) or (AnItem = Selitem) then Exit;
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
    fps := TFileProperty(Selitem.Data);
    fpd := TFileProperty(AnItem.Data);

    fps.Project.PropertyChanged := True;
    fpd.Project.PropertyChanged := True;

    //convert to TFileProperty
    if fps is TProjectProperty then
    begin
      Selitem.Data := TFileProperty.Create(fps.PageCtrl, fps.Node);
      TFileProperty(Selitem.Data).Assign(fps);//copy
      fps.Free;//release
      fps := TFileProperty(Selitem.Data);
      fps.FileName := fps.Caption;
    end;
    AdjustNewProject(Selitem, fpd.Project);
    TreeViewProjects.Selected.MoveTo(AnItem, AttachMode) ;
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
  if not Assigned(TreeViewProjects.Selected) then Exit;
  Selitem := TreeViewProjects.Selected;
  HT := TreeViewProjects.GetHitTestInfoAt(X, Y);
  AnItem := TreeViewProjects.GetNodeAt(X, Y);
  if not Assigned(AnItem) or (AnItem = Selitem) then Exit;
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent, htBelow] <> HT) and
     (TFileProperty(Selitem.Data).FileType <> FILE_TYPE_PROJECT) then
  begin
    if TFileProperty(AnItem.Data).FileType in
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
  tab := PageControlEditor.TabAtPos(MousePos.X, MousePos.Y);
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
  sheet: TFilePropertySheet;
  dc: TDisplayCoord;
begin
  if not GetActiveSheet(sheet) then Exit;
  dc := sheet.Memo.PixelsToRowColumn(MousePos.X, MousePos.Y);
  if (dc.Column = 0) or (dc.Row = 0) or (sheet.Memo.SelLength > 0) then Exit;
  sheet.Memo.SetFocus;
  EditorGotoXY(sheet.Memo, dc.Column, dc.Row);
end;

procedure TFrmFalconMain.FindMenuClick(Sender: TObject);
begin
  StartFindText(Self);
end;

procedure TFrmFalconMain.ReplaceMenuClick(Sender: TObject);
begin
  StartReplaceText(Self);
end;

procedure TFrmFalconMain.FindFilesMenuClick(Sender: TObject);
begin
  StartFindFilesText(Self);
end;

procedure TFrmFalconMain.FindNextMenuClick(Sender: TObject);
begin
  StartFindNextText(Self, LastSearch);
end;

procedure TFrmFalconMain.FindPrevMenuClick(Sender: TObject);
begin
  StartFindPrevText(Self, LastSearch);
end;

procedure TFrmFalconMain.GotoLineAndAlignCenter(Memo: TSynMemo; Line,
  Col: Integer);
var
  TopLine: Integer;
begin
  Memo.SetFocus;
  TopLine := Line  - (Memo.LinesInWindow div 2);
  if TopLine <= 0 then TopLine := 1;
  Memo.TopLine := TopLine;
  Memo.CaretY := Line;
  Memo.CaretX := Col;
end;

procedure TFrmFalconMain.SelectToken(Token: TTokenClass);
var
  bC, bSs, bSe: TBufferCoord;
  sheet: TFilePropertySheet;
  TopLine: Integer;
begin
  if not GetActiveSheet(sheet) then Exit;
  bC := sheet.Memo.CharIndexToRowCol(Token.SelStart);
  bSs := bC;
  bSe := sheet.Memo.CharIndexToRowCol(Token.SelStart + Token.SelLength);
  sheet.Memo.SetCaretAndSelection(bC, bSs, bSe);
  sheet.Memo.SetFocus;

  TopLine := Token.SelLine  - (sheet.Memo.LinesInWindow div 2);
  if TopLine <= 0 then
    TopLine := 1;
  sheet.Memo.TopLine := TopLine;
end;

procedure TFrmFalconMain.UpdateActiveFileToken(NewToken: TTokenFile;
  Reload: Boolean = False);
var
  Index: Integer;
  TokenFileItem: TTokenFile;
  sheet: TFilePropertySheet;
  {FIncludeList: TTokenClass;
  FDefineList: TTokenClass;
  FVarConstList: TTokenClass;
  FTreeObjList: TTokenClass;
  FFuncObjList: TTokenClass;}
begin
  Index := FilesParsed.IndexOfByFileName(NewToken.FileName, NewToken.Data);
  if Index < 0 then //not parsed
  begin
    TokenFileItem := TTokenFile.Create(FilesParsed);
    TokenFileItem.Assign(NewToken);
  end
  else
  begin
    TokenFileItem := FilesParsed.Items[Index];
    if Reload then TokenFileItem.Assign(NewToken);
  end;
  //save
  {FIncludeList := ActiveEditingFile.Includes;
  FDefineList := ActiveEditingFile.Defines;
  FVarConstList := ActiveEditingFile.VarConsts;
  FTreeObjList := ActiveEditingFile.TreeObjs;
  FFuncObjList := ActiveEditingFile.FuncObjs;

  //override
  ActiveEditingFile.Includes := TTokenClass.Create;
  ActiveEditingFile.Defines := TTokenClass.Create;
  ActiveEditingFile.VarConsts := TTokenClass.Create;
  ActiveEditingFile.TreeObjs := TTokenClass.Create;
  ActiveEditingFile.FuncObjs := TTokenClass.Create;}

  ActiveEditingFile.Assign(TokenFileItem);

  if Index < 0 then
    FilesParsed.Add(TokenFileItem);
  TreeViewOutline.Items.Clear;
  FillTreeView(TreeViewOutline, nil, ActiveEditingFile.Includes);
  FillTreeView(TreeViewOutline, nil, ActiveEditingFile.Defines);
  FillTreeView(TreeViewOutline, nil, ActiveEditingFile.TreeObjs);
  FillTreeView(TreeViewOutline, nil, ActiveEditingFile.VarConsts);
  FillTreeView(TreeViewOutline, nil, ActiveEditingFile.FuncObjs);

  //FillTokenFileTreeView(TreeViewOutline, ActiveEditingFile);

  //free
  {FIncludeList.Free;
  FDefineList.Free;
  FVarConstList.Free;
  FTreeObjList.Free;
  FFuncObjList.Free;}
  if GetActiveSheet(sheet) then
    DetectScope(sheet.Memo);
end;

procedure TFrmFalconMain.TreeViewOutlineDblClick(Sender: TObject);
var
  Token: TTokenClass;
begin
  if TreeViewOutline.SelectionCount = 0 then Exit;
  TreeViewOutline.Selected.EndEdit(True);
  Token := TTokenClass(TreeViewOutline.Selected.Data);
  if Token.Token in [tkIncludeList, tkDefineList, tkTreeObjList, tkVarConsList,
                     tkFuncProList] then Exit;
  SelectToken(Token);
end;

function SortCompareParams(List: TStringList; Index1, Index2: Integer): Integer;
var
  tkp1, tkp2: TTokenClass;
begin
  tkp1 := GetTokenByName(TTokenClass(List.Objects[Index1]), 'Params', tkParams);
  tkp2 := GetTokenByName(TTokenClass(List.Objects[Index2]), 'Params', tkParams);
  Result := tkp1.Count - tkp2.Count;
end;

//hint functions
procedure TFrmFalconMain.ShowHintParams(Memo: TSynMemo);
var
  S, Params, Fields, Input: String;
  Token, tokenParams: TTokenClass;
  InString, InputError: Boolean;
  Attri: TSynHighlighterAttributes;
  BufferCoord, BufferCoordStart, BufferCoordEnd: TBufferCoord;
  I, SelStart, BracketEnd, ParamIndex, LineLen, BracketStart: Integer;
  P: TPoint;
  ParamsList: TStringList;
begin
  BufferCoord := Memo.CaretXY;
  if BufferCoord.Line > 0 then
  begin
    LineLen := Length(Memo.Lines.Strings[BufferCoord.Line - 1]);
    if LineLen < BufferCoord.Char - 1 then
      BufferCoord.Char := LineLen + 1;
  end;
  SelStart := Memo.RowColToCharIndex(BufferCoord);
  InString := False;
  if Memo.GetHighlighterAttriAtRowCol(BufferCoord, S, Attri) then
  begin
    if StringIn(Attri.Name, ['Preprocessor']) then
    begin
      HintParams.Cancel;
      Exit;
    end;
    InString := Attri.Name = 'String';
    if InString then
    begin
      Dec(BufferCoord.Char);
      if Memo.GetHighlighterAttriAtRowCol(BufferCoord, S, Attri) then
        InString := Attri.Name = 'String';
      if not InString then
      begin
        InString := True;
        Inc(BufferCoord.Char, 2);
        SelStart := Memo.RowColToCharIndex(BufferCoord);
      end;
    end;
  end;
  BracketStart := SelStart;
  if not GetFirstOpenBrace(memo.Text, InString, BracketStart) then
  begin
    HintParams.Cancel;
    Exit;
  end;
  BufferCoordStart := Memo.CharIndexToRowCol(BracketStart);
  BufferCoordEnd := Memo.GetMatchingBracketEx(BufferCoordStart);
  if (BufferCoordEnd.Char > 0) and (BufferCoordEnd.Line > 0) then
  begin
    BracketEnd := Memo.RowColToCharIndex(BufferCoordEnd);
    Params := Copy(Memo.Text, BracketStart + 2, BracketEnd - BracketStart - 1);
  end
  else
    Params := Copy(Memo.Text, BracketStart + 2, SelStart - BracketStart - 1);
  if not ParseFields(Memo.Text, BracketStart, Input, Fields, InputError) then
  begin
    HintParams.Cancel;
    Exit;
  end;
  Fields := Fields + Input;
  Input := GetFirstWord(Fields);
  ParamsList := TStringList.Create;
  //show function params
   if not FilesParsed.GetFieldsBaseParams(Input, Fields, BracketStart,
    ActiveEditingFile, ParamsList) then
  begin
    ParamsList.Free;
    HintParams.Cancel;
    Exit;
  end;
  ParamIndex := SelStart - BracketStart - 1;
  ParamIndex := CommaCountAt(Params, ParamIndex);
  P := Memo.RowColumnToPixels(Memo.BufferToDisplayPos(BufferCoordStart));
  P := Memo.ClientToScreen(P);

  for I := ParamsList.Count - 1 downto 0 do
  begin
    Token := TTokenClass(ParamsList.Objects[I]);
    if not (Token.Token in [tkConstructor, tkFunction, tkPrototype,
      tkTypedefProto]) then
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
  HintParams.UpdateHint(ParamsList, ParamIndex, P.X, P.Y);
  ParamsList.Free;
end;

procedure TFrmFalconMain.ParserStart(Sender: TObject);
begin
  ProgressStatusParser.Show;
end;

procedure TFrmFalconMain.ParserProgress(Sender: TObject; TokenFile: TTokenFile;
  const FileName: String; Current, Total: Integer; Parsed: Boolean;
  Method: TTokenParseMethod);
begin
  ProgressStatusParser.Percent := (Current * 100) div Total;
end;

procedure TFrmFalconMain.AllParserProgress(Sender: TObject; TokenFile: TTokenFile;
  const FileName: String; Current, Total: Integer; Parsed: Boolean;
  Method: TTokenParseMethod);
begin
  if not Parsed then Exit;
  if ActiveEditingFile.Data = TokenFile.Data then
    UpdateActiveFileToken(TokenFile);
  AllParsedList.AddObject('', TokenFile);
end;

procedure TFrmFalconMain.AllParserFinish(Sender: TObject);
var
  I: Integer;
  FileToken: TTokenFile;
begin
  for I := 0 to AllParsedList.Count - 1 do
  begin
    FileToken := TTokenFile(AllParsedList.Objects[I]);
    TextEditorFileParsed(nil, FileToken);
  end;
  AllParsedList.Clear;
end;

procedure TFrmFalconMain.ParserFinish(Sender: TObject);
var
 ini: TIniFile;
begin
  if IsLoadingSrcFiles then
  begin
    if ParseAllCloseApp then
    begin
      Application.Terminate;
      Exit;
    end;
    ini := TIniFile.Create(IniConfigFile);
    ini.WriteInteger('Packages', 'NewInstalled', 0);
    ini.Free;
    IsLoadingSrcFiles := False;
    ParseAllCloseApp := False;
  end;
  ProgressStatusParser.Hide;
end;

procedure TFrmFalconMain.TextEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  HintParams.Cancel;
  HintTip.Cancel;
end;

procedure TFrmFalconMain.ProcessDebugHint(Input: String; Line, SelStart: integer;
  CursorPos: TPoint);
begin
  if not CommandQueue.Empty then
    Exit;
  CommandQueue.Push(GDB_PRINT, DebugReader.LastPrintID + 1, Input, Line,
    SelStart, nil, CursorPos);
  DebugReader.SendCommand(GDB_PRINT, Input);
end;

procedure TFrmFalconMain.ProcessHintView(FileProp: TFileProperty;
  Memo: TSynMemo; const X, Y: Integer);

  function BufferIn(BS, Buffer, BE: TBufferCoord): Boolean;
  begin
    Result := (BS.Line = Buffer.Line) and (BS.Char <= Buffer.Char) and
              (BE.Line = Buffer.Line) and (BE.Char >= Buffer.Char);
  end;

var
  S, Fields, Input: String;
  DisplayCoord: TDisplayCoord;
  BufferCoord, WordStart: TBufferCoord;
  Token: TTokenClass;
  TokenFileItem: TTokenFile;
  P: TPoint;
  InputError: Boolean;
  WordStartPos, TokenType, Start, I: Integer;
  attri: TSynHighlighterAttributes;
begin
  DisplayCoord := Memo.PixelsToRowColumn(X, Y);
  BufferCoord := Memo.DisplayToBufferPos(DisplayCoord);
  if BufferCoord.Line > 0 then
  begin
    if BufferCoord.Char > Length(Memo.Lines.Strings[BufferCoord.Line - 1]) then
    begin
      HintTip.Cancel;
      CanShowHintTip := False;
      Exit;
    end;
  end;
  I := Memo.RowColToCharIndex(BufferCoord);
  WordStart := Memo.WordStartEx(BufferCoord);
  WordStartPos := Memo.RowColToCharIndex(WordStart);
  if Executor.Running then
  begin
    HintTip.Cancel;
    CanShowHintTip := False;
    Exit;
  end;

  if (LastWordHintStart = WordStartPos) and HintTip.Activated then
    Exit;
  LastWordHintStart := WordStartPos;
  if Memo.GetHighlighterAttriAtRowColEx(BufferCoord, Input, TokenType, Start,
      attri) then
  begin
    if ((not StringIn(attri.Name, ['Identifier', 'Preprocessor']) or
      (Pos('include', Input) > 0)) and not DebugReader.Running) or
      (StringIn(attri.Name, ['String', 'Comment', 'Preprocessor']) and
      DebugReader.Running) then
    begin
      HintTip.Cancel;
      CanShowHintTip := False;
      Exit;
    end;
  end;
  //evaluate/modify with selection
  if DebugReader.Running and Memo.SelAvail and
    BufferIn(Memo.BlockBegin, BufferCoord, Memo.BlockEnd) then
  begin
    DisplayCoord := Memo.BufferToDisplayPos(Memo.BlockBegin);
    P := Memo.RowColumnToPixels(DisplayCoord);
    P := Memo.ClientToScreen(P);
    ProcessDebugHint(Memo.SelText, BufferCoord.Line, I, P);
    Exit;
  end;
  Input := Memo.GetWordAtRowCol(BufferCoord);
  DisplayCoord := Memo.BufferToDisplayPos(WordStart);
  P := Memo.RowColumnToPixels(DisplayCoord);
  P := Memo.ClientToScreen(P);
  if ParseFields(Memo.Text, I, Input, Fields, InputError) then
  begin
    if DebugReader.Running then
    begin
      if Input <> '' then
      begin
        ProcessDebugHint(Fields + Input, BufferCoord.Line, I, P);
      end
      else
      begin
        HintTip.Cancel;
        CanShowHintTip := False;
      end;
      Exit;
    end;
    S := Fields;
    Fields := Fields + Input;
    Input := GetFirstWord(Fields);    //enum fields and functions class
    if (S <> '') and FilesParsed.GetFieldsBaseType(Input, Fields,
        I, ActiveEditingFile, TokenFileItem, Token) then
    begin
      S := MakeTokenHint(Token, TokenFileItem.FileName);
      HintTip.UpdateHint(S, P.X, P.Y + Memo.Canvas.TextHeight(S) + 5);
      Exit;
    end
    else if (S = '') and FilesParsed.SearchSource(Input, ActiveEditingFile,
      TokenFileItem, Token, I) then
    begin
      S := MakeTokenHint(Token, TokenFileItem.FileName);
      HintTip.UpdateHint(S, P.X, P.Y + Memo.Canvas.TextHeight(S) + 5);
      Exit;
    end;
  end;
  HintTip.Cancel;
  CanShowHintTip := False;
  Exit;
end;

procedure TFrmFalconMain.TimerHintTipEventTimer(Sender: TObject);
var
  P: TPoint;
  sheet: TFilePropertySheet;
  FileProp: TFileProperty;
begin
  TimerHintTipEvent.Enabled := False;
  CanShowHintTip := True;
  if not HintParams.Activated then
  begin
    if not GetActiveSheet(sheet) then Exit;
    if not GetActiveFile(FileProp) then Exit;
    P := sheet.Memo.ScreenToClient(Mouse.CursorPos);
    ProcessHintView(FileProp, sheet.Memo, P.X, P.Y);
  end;
end;

procedure TFrmFalconMain.CodeCompletionExecute(Kind: TSynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
var
  S, Fields, Input: String;
  sheet: TFilePropertySheet;
  TokenItem: TTokenFile;
  SelStart, I, LineLen: integer;
  Token, Scope: TTokenClass;
  AllScope: Boolean;
  AllowScope: TScopeClassState;
  Buffer: TBufferCoord;
  Attri: TSynHighlighterAttributes;
  InputError: Boolean;
begin
  Input := '';
  CanExecute := False;
  if not GetActiveSheet(sheet) then Exit;
  if ParseFields(sheet.Memo.Text, sheet.Memo.SelStart, Input, Fields, InputError) then
    Input := GetFirstWord(Fields);
  if InputError then
    Exit;
  for I := 0 to CodeCompletion.InsertList.Count - 1 do
    TTokenClass(CodeCompletion.InsertList.Objects[I]).Free;
  CodeCompletion.ItemList.Clear;
  CodeCompletion.InsertList.Clear;
  //get valid SelStart
  Buffer := sheet.Memo.CaretXY;
  if (Buffer.Line > 0) then
  begin
    LineLen := Length(sheet.Memo.Lines.Strings[Buffer.Line - 1]);
    if (Buffer.Char > LineLen + 1) then
      Buffer.Char := LineLen + 1;
  end;
  if sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
  begin
    if StringIn(Attri.Name, ['Character', 'String', 'Comment',
      'Preprocessor']) then
    begin
      Dec(Buffer.Char);
      if (Attri.Name <> 'Preprocessor') and
        sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
      begin
        if StringIn(Attri.Name, ['Character', 'String', 'Comment',
          'Preprocessor']) then
          Exit;
        Inc(Buffer.Char);
      end
      else
        Exit;
    end;
  end
  else if (Buffer.Char > 1) then
  begin
    Dec(Buffer.Char);
    if sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
    begin
      if StringIn(Attri.Name, ['Character', 'String', 'Comment',
        'Preprocessor']) then
      begin
        Dec(Buffer.Char);
        if (Attri.Name <> 'Preprocessor') and
          sheet.Memo.GetHighlighterAttriAtRowCol(Buffer, S, Attri) then
        begin
          if StringIn(Attri.Name, ['Character', 'String', 'Comment',
            'Preprocessor']) then
            Exit;
          Inc(Buffer.Char);
        end
        else
          Exit;
      end;
    end;
    Inc(Buffer.Char);
  end;
  SelStart := sheet.Memo.RowColToCharIndex(Buffer);
  //Temp skip Scope:
  if (SelStart >= 1) and (sheet.Memo.Text[SelStart] = ':') then
  begin
    if (SelStart >= 2) and (sheet.Memo.Text[SelStart - 1] <> ':') then
      Exit
    else if (SelStart < 2) then
      Exit;
  end;
  //End temp
  if Input <> '' then
  begin
    //search base type and list fields and functions of struct, union or class
    if FilesParsed.GetFieldsBaseType(Input, Fields,
      SelStart, ActiveEditingFile, TokenItem, Token, True) then
    begin
      //show private fields only on implementation file
      AllowScope := [];
      AllScope := (CompareText(ChangeFileExt(ActiveEditingFile.FileName, ''),
        ChangeFileExt(TokenItem.FileName, '')) = 0);
      if ActiveEditingFile.GetScopeAt(Scope, sheet.memo.SelStart) then
      begin
        Scope := GetTokenByName(Scope, 'Scope', tkScope);
        if not Assigned(Scope) or (Scope.Flag <> Token.Name) then
          AllScope := False;
      end
      else
        AllScope := Pos('::', Fields) > 0;
      if not AllScope then
        AllowScope := AllowScope + [scPublic];
      FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, TokenItem, Token, AllowScope);
      CanExecute := True;
      Exit;//?
    end;
    //Exit; uncomment?
  end;
  //get current object in location
  if ActiveEditingFile.GetScopeAt(Token, SelStart) then
  begin
    AllScope := False;
    //fill first all object in finded object location
    FillCompletionTree(CodeCompletion.InsertList,
      CodeCompletion.ItemList, Token, SelStart,
      CompletionColors, [], True);
    //TODO while parent is not nil fill objects
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
    end;
    //show all objects from class, struct or scope
    if AllScope then
    begin
      FilesParsed.FillCompletionClass(CodeCompletion.InsertList,
        CodeCompletion.ItemList, CompletionColors, TokenItem, Token);
    end;
  end;

  FilesParsed.FillCompletionList(CodeCompletion.InsertList,
    CodeCompletion.ItemList, ActiveEditingFile, SelStart,
    CompletionColors);
  CanExecute := True;
end;

procedure TFrmFalconMain.CodeCompletionCodeCompletion(Sender: TObject;
  var Value: String; Shift: TShiftState; Index: Integer; EndToken: Char);
var
  Token{, params}: TTokenClass;
  I: Integer;
//  NextChar: Char;
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
//  NextChar := GetNextValidChar(sheet.Memo.Text, sheet.Memo.SelStart);
  Token := TTokenClass(CodeCompletion.ItemList.Objects[Index]);
  if Token.Token in [tkFunction, tkPrototype] then
  begin
//    params := GetTokenByName(Token, 'Params', tkParams);
//    I := params.Count;
//    if I > 0 then
//      Dec(I);
    if EndToken = ')' then
      Value := Value + '('
    else if EndToken = ';' then
    begin
      Value := Value + '()';
    end
    else if EndToken <> '(' then
    begin
      Value := Value + '(';
      LastKeyPressed := '(';
    end;
  end;
  for I := 0 to CodeCompletion.InsertList.Count - 1 do
    TTokenClass(CodeCompletion.InsertList.Objects[I]).Free;
  CodeCompletion.ItemList.Clear;
  CodeCompletion.InsertList.Clear;
end;

procedure TFrmFalconMain.AddItemMsg(const Title, Msg: String; Line: Integer);
var
  MsgItem: TMinGWMsg;
  Item: TListItem;
begin
  MsgItem := TMinGWMsg.Create;
  MsgItem.Msg  := Msg;
  MsgItem.Line := Line;
  Item := ListViewMsg.Items.Add;
  Item.Caption := Title;
  Item.ImageIndex := 32;
  Item.SubItems.Add(IntToStr(Line));
  Item.SubItems.Add(Msg);
  Item.Data := MsgItem;
  ListViewMsg.Scroll(0, Item.Top - (ListViewMsg.Height div 2));
end;

procedure TFrmFalconMain.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
    if Msg.message = WM_SYSCOMMAND then HintParams.Cancel;
end;

procedure TFrmFalconMain.TreeViewOutlineAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
  if Stage = cdPostPaint then
  begin
    PaintTokenItem(Sender.Canvas, Node.DisplayRect(True),
      TTokenClass(Node.Data), State);
  end;
end;

procedure TFrmFalconMain.PaintTokenItem(const ToCanvas: TCanvas;
  DisplayRect: TRect; Token: TTokenClass; State: TCustomDrawState);
var
  Flag, FullFlag, Vector, Params: String;
  HasVector, ChangeTextColor: Boolean;
  I, Len: Integer;
begin
  if Token.Token in [tkInclude, tkTypedefProto] then Exit;
  ChangeTextColor := not (cdsSelected in State);
  if Token.Token in [tkFunction, tkProtoType, tkConstructor, tkDestructor] then
  begin
    Params := GetFuncScope(Token) + Token.Name + GetFuncProtoTypes(Token);
    Flag := Token.Flag;
    if Flag = '' then
      DisplayRect.Right := DisplayRect.Left + 5 +
        ToCanvas.TextWidth(Params) + 2
    else
      DisplayRect.Right := DisplayRect.Left + 5 +
        ToCanvas.TextWidth(Params + ' : ' + Flag) + 2;
    if (cdsSelected in State) and not (cdsFocused in State) then
    begin
      ToCanvas.Brush.Color := clBtnFace;
      ToCanvas.Font.Color := clWindowText;
      ChangeTextColor := False;
      ToCanvas.Refresh;
    end;
    ToCanvas.FillRect(DisplayRect);
    if (cdsFocused in State) then ToCanvas.DrawFocusRect(DisplayRect);
    ToCanvas.TextOut(DisplayRect.Left + 2, DisplayRect.Top + 1, Params);
    if Flag = '' then
      Exit;
    //custom return type or value defined
    if ChangeTextColor then ToCanvas.Font.Color := clBlue;
    ToCanvas.Refresh;
    Inc(DisplayRect.Left, 2 + ToCanvas.TextWidth(Params));
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, ' : ');
    if ChangeTextColor then ToCanvas.Font.Color := clOlive;
    ToCanvas.Refresh;
    Inc(DisplayRect.Left, ToCanvas.TextWidth(' : '));
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, Flag);
    Exit;
  end;
  Len := Length(Token.Flag);
  if Len = 0 then Exit;
  if (Token.Token = tkDefine) and not IsNumber(Token.Flag) then Exit;
  DisplayRect.Right := DisplayRect.Left + 5 + ToCanvas.TextWidth(
    Token.Name + ' : ' + Token.Flag) + 2;
  if (cdsSelected in State) and not (cdsFocused in State) then
  begin
    ToCanvas.Brush.Color := clBtnFace;
    ToCanvas.Font.Color := clWindowText;
    ChangeTextColor := False;
    ToCanvas.Refresh;
  end;
  ToCanvas.FillRect(DisplayRect);
  if (cdsFocused in State) then ToCanvas.DrawFocusRect(DisplayRect);
  ToCanvas.TextOut(DisplayRect.Left + 2, DisplayRect.Top + 1, Token.Name);
  //custom return type or value defined
  if ChangeTextColor then ToCanvas.Font.Color := clBlue;
  ToCanvas.Refresh;
  Inc(DisplayRect.Left, 2 + ToCanvas.TextWidth(Token.Name));
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, ' : ');

  if ChangeTextColor then ToCanvas.Font.Color := clOlive;
  ToCanvas.Refresh;
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
    I :=  Pos(']', Vector);
    Vector := Copy(Vector, 1, I - 1);
    FullFlag := Copy(FullFlag, I + 1, Len - I);
    HasVector := True;
  end;
  ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, Flag);
  if not HasVector or (Token.Token <> tkVariable)  then Exit;
  if ChangeTextColor then ToCanvas.Font.Color := clMaroon;
  ToCanvas.Refresh;
  Inc(DisplayRect.Left, ToCanvas.TextWidth(Flag) + 1);
  while True do
  begin
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, '[');

    if ChangeTextColor then ToCanvas.Font.Color := clGreen;
    ToCanvas.Refresh;
    Inc(DisplayRect.Left, ToCanvas.TextWidth('[') + 1);
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, Vector);

    if ChangeTextColor then ToCanvas.Font.Color := clMaroon;
    ToCanvas.Refresh;
    Inc(DisplayRect.Left, ToCanvas.TextWidth(Vector) + 1);
    ToCanvas.TextOut(DisplayRect.Left, DisplayRect.Top + 1, ']');
    Inc(DisplayRect.Left, ToCanvas.TextWidth(']') + 1);

    Len := Length(FullFlag);
    I := Pos('[', FullFlag);
    if I > 0 then
    begin
      Vector := Copy(FullFlag, I + 1, Len - I);
      Flag := Copy(FullFlag, 1, I - 1);
      FullFlag := Vector;
      I :=  Pos(']', Vector);
      Vector := Copy(Vector, 1, I - 1);
      FullFlag := Copy(FullFlag, I + 1, Len - I);
    end
    else
      Break;
  end;
end;

procedure TFrmFalconMain.TimerHintParamsTimer(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  TimerHintParams.Enabled := False;
  if not GetActiveSheet(sheet) then Exit;
  ShowHintParams(sheet.Memo);
end;

procedure TFrmFalconMain.ViewCompOutClick(Sender: TObject);
begin
  RSPCmd.Show;
end;

procedure TFrmFalconMain.FilePrintClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
  AFont: TFont;
begin
  if not GetActiveSheet(sheet) then Exit;
  if PrintDialog.Execute then
  begin
    EditorPrint.Highlighter := sheet.Memo.Highlighter;
    EditorPrint.SynEdit := sheet.Memo;
    EditorPrint.DocTitle := TFileProperty(sheet.Node.Data).Caption;
    AFont := TFont.Create;
    with EditorPrint.Header do begin
      AFont.Assign(DefaultFont);
      AFont.Size := 7;
      AFont.Style := [fsBold];
      Add(TFileProperty(sheet.Node.Data).GetCompleteFileName, AFont, taLeftJustify, 1);
      Add(FormatDateTime(STR_FRM_MAIN[38], Now), AFont, taRightJustify, 1);
    end;
    with EditorPrint.Footer do begin
      AFont.Assign(DefaultFont);
      AFont.Size := 8;
      Add('-$PAGENUM$-', AFont, taCenter, 1);
    end;
    EditorPrint.Print;
    AFont.Free;
  end;
end;

procedure TFrmFalconMain.PageControlMsgClose(Sender: TObject;
  var AllowClose: Boolean);
begin
  AllowClose := False;
  RSPCmd.Hide;
end;

procedure TFrmFalconMain.PupMsgGotoLineClick(Sender: TObject);
var
  Item: TListItem;
  Msg: TMinGWMsg;
begin
  if ListViewMsg.SelCount = 0 then Exit;
  Item := ListViewMsg.Selected;
  if Assigned(Item.Data) then
    Msg := TMinGWMsg(Item.Data)
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
  SelFile: TFileProperty;
  Proj: TProjectProperty;
begin
  P := Mouse.CursorPos;
  P := PageControlEditor.ScreenToClient(P);
  I := PageControlEditor.TabAtPos(P.X, P.Y);
  if I > -1 then Exit;
  //Get folder of active file or project
  SelFile := nil;
  if GetActiveFile(SelFile) then
  begin
    if not (SelFile is TProjectProperty) and
      (TFileProperty(SelFile.Node.Parent.Data).FileType in [FILE_TYPE_FOLDER,
      FILE_TYPE_PROJECT]) then
    begin
      SelFile := TFileProperty(SelFile.Node.Parent.Data);
    end;
  end
  else if GetActiveProject(Proj) then
  begin
    if Proj.FileType = FILE_TYPE_PROJECT then
      SelFile := Proj;
  end;
  if Config.Environment.DefaultCppNewFile then
    GetFileProperty(FILE_TYPE_CPP, COMPILER_CPP, STR_FRM_MAIN[15] + '.cpp',
      STR_FRM_MAIN[13], '.cpp', '', nil).Edit
  else
    GetFileProperty(FILE_TYPE_C, COMPILER_C, STR_FRM_MAIN[15] + '.c',
      STR_FRM_MAIN[13], '.c', '', SelFile).Edit;
end;

procedure TFrmFalconMain.PopEditorDeleteClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  SendMessage(sheet.Memo.Handle, WM_KEYDOWN, VK_DELETE, VK_DELETE);
  SendMessage(sheet.Memo.Handle, WM_KEYUP, VK_DELETE, VK_DELETE);
end;

procedure TFrmFalconMain.FileExportHTMLClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  ExporterHTML.Highlighter := sheet.Memo.Highlighter;
  ExporterHTML.Title := TFileProperty(sheet.Node.Data).Caption;
  ExporterHTML.ExportAll(sheet.Memo.Lines);
  ExporterHTML.ExportAsText := True;

  with TSaveDialog.Create(Self) do
  begin
    Filter := ExporterHTML.DefaultFilter;
    DefaultExt := '.html';
    FileName := ChangeFileExt(TFileProperty(sheet.Node.Data).Caption, '.html');
    if Execute then
    begin
      ExporterHTML.SaveToFile(FileName);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.FileExportRTFClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  ExporterRTF.Highlighter := sheet.Memo.Highlighter;
  ExporterRTF.Title := TFileProperty(sheet.Node.Data).Caption;
  ExporterRTF.ExportAll(sheet.Memo.Lines);
  //ExporterRTF.ExportAsText := True;

  with TSaveDialog.Create(Self) do
  begin
    Filter := ExporterRTF.DefaultFilter;
    DefaultExt := '.rtf';
    FileName := ChangeFileExt(TFileProperty(sheet.Node.Data).Caption, '.rtf');
    if Execute then
    begin
      ExporterRTF.SaveToFile(FileName);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.FileExportTeXClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  ExporterTeX.Highlighter := sheet.Memo.Highlighter;
  ExporterTeX.Title := TFileProperty(sheet.Node.Data).Caption;
  ExporterTeX.ExportAll(sheet.Memo.Lines);
  ExporterTeX.TabWidth := sheet.Memo.TabWidth;

  with TSaveDialog.Create(Self) do
  begin
    Filter := ExporterTeX.DefaultFilter;
    DefaultExt := '.tex';
    FileName := ChangeFileExt(TFileProperty(sheet.Node.Data).Caption, '.tex');
    if Execute then
    begin
      ExporterTeX.SaveToFile(FileName);
    end;
    Free;
  end;
end;

procedure TFrmFalconMain.PopTabsCloseAllOthersClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
  I: Integer;
begin
  if not GetActiveSheet(sheet) then Exit;
  for I := PageControlEditor.PageCount - 1 downto sheet.TabIndex + 1 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  for I := sheet.TabIndex - 1 downto 0 do
  begin
    PageControlEditor.ActivePageIndex := I;
    PageControlEditor.CloseActiveTab;
  end;
  PageControlEditor.ActivePageIndex := sheet.TabIndex;
end;

procedure TFrmFalconMain.PopTabsTabsAtTopClick(Sender: TObject);
begin
  PageControlEditor.TabOrientation := toTop;
  PopTabsTabsAtTop.Enabled := False;
  PopTabsTabsAtBottom.Enabled := True;
end;

procedure TFrmFalconMain.PopTabsTabsAtBottomClick(Sender: TObject);
begin
  PageControlEditor.TabOrientation := toBottom;
  PopTabsTabsAtTop.Enabled := True;
  PopTabsTabsAtBottom.Enabled := False;
end;

procedure TFrmFalconMain.EditSwapClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
  SwapFileName, FileName, Directive: String;
  fprop, swfp, parent: TFileProperty;
  resp, Index: Integer;
begin
  if not GetActiveSheet(sheet) then Exit;
  fprop := TFileProperty(sheet.Node.Data);
  parent := nil;
  if Assigned(fprop.Node.Parent) then
    parent := TFileProperty(fprop.Node.Parent.Data);

  FileName := fprop.GetCompleteFileName;
  if (GetFileType(FileName) in [FILE_TYPE_CPP, FILE_TYPE_C]) then
  begin
    SwapFileName := ChangeFileExt(FileName, '.h');
    if Assigned(parent) then
    begin
      if parent.FindFile(ExtractFileName(SwapFileName), swfp) then
      begin
        swfp.Edit;
        Exit;
      end;
    end
    else
    begin
      if GetFilePropertyByFileName(SwapFileName, swfp) then
      begin
        swfp.Edit;
        Exit;
      end;
      if FileExists(SwapFileName) then
      begin
        OpenFile(SwapFileName).Edit;
        Exit;
      end;
      MessageBox(Handle, PChar(Format(STR_FRM_MAIN[34], [SwapFileName])),
        'Falcon C++', MB_ICONINFORMATION);
      Exit;
    end;
    resp := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[34] +
      #10 + STR_FRM_MAIN[43], [SwapFileName])),
      'Falcon C++', MB_ICONEXCLAMATION+MB_YESNOCANCEL);
    if resp = IDYES then
    begin
      swfp := GetFileProperty(FILE_TYPE_H, NO_COMPILER,
        ExtractFileName(SwapFileName), ExtractName(SwapFileName), '.h', '',
        parent);
      Directive := UpperCase(ExtractFileName(SwapFileName));
      Directive := '_' + StringReplace(Directive, '.', '_', []) + '_';
      Directive := StringReplace(Directive, ' ', '_', []);
      swfp.Text.Add('#ifndef ' + Directive);
      //TODO GNU License
      swfp.Text.Add('#define ' + Directive);
      swfp.Text.Add('');
      Index := FilesParsed.IndexOfByFileName(FileName, fprop);
      if Index >= 0 then
        GenerateFunctionPrototype(FilesParsed.Items[Index], swfp.Text, 3)
      else
        swfp.Text.Add('');//Caret here
      swfp.Text.Add('');
      swfp.Text.Add('#endif');
      swfp.Edit.Memo.CaretXY := BufferCoord(1, 4);
    end;
  end
  else if GetFileType(FileName) = FILE_TYPE_H then
  begin
    if Assigned(parent) then
    begin
      //if parent.Project.CompilerType = COMPILER_C then
      //  SwapFileName := ChangeFileExt(SwapFileName, '.c')
      //else
      //  SwapFileName := ChangeFileExt(SwapFileName, '.cpp');
      SwapFileName := ChangeFileExt(FileName, '.c');
      if parent.FindFile(ExtractFileName(SwapFileName), swfp) then
      begin
        swfp.Edit;
        Exit;
      end;
      SwapFileName := ChangeFileExt(FileName, '.cpp');
      if parent.FindFile(ExtractFileName(SwapFileName), swfp) then
      begin
        swfp.Edit;
        Exit;
      end;
      resp := MessageBox(Handle, PChar(Format(STR_FRM_MAIN[34] +
                #10 + STR_FRM_MAIN[43], [SwapFileName])),
                'Falcon C++', MB_ICONEXCLAMATION+MB_YESNOCANCEL);
      if resp = IDYES then
      begin
        if parent.Project.CompilerType = COMPILER_C then
          swfp := GetFileProperty(FILE_TYPE_C, parent.Project.CompilerType,
            ExtractFileName(SwapFileName),
            ExtractName(SwapFileName), '.c', '', parent)
        else
          swfp := GetFileProperty(FILE_TYPE_CPP, parent.Project.CompilerType,
            ExtractFileName(SwapFileName),
            ExtractName(SwapFileName), '.cpp', '', parent);
        swfp.Text.Add('#include "' + ExtractFileName(FileName) + '"');
        swfp.Text.Add('');
        Index := FilesParsed.IndexOfByFileName(FileName, fprop);
        if Index >= 0 then
          GenerateFunctions(FilesParsed.Items[Index], swfp.Text, 2)
        else
          swfp.Text.Add('');//Caret here
        swfp.Edit.Memo.CaretXY := BufferCoord(1, 3);
      end;
    end
    else
    begin
      SwapFileName := ChangeFileExt(FileName, '.cpp');
      if GetFilePropertyByFileName(SwapFileName, swfp) then
      begin
        swfp.Edit;
        Exit;
      end;
      if FileExists(SwapFileName) then
      begin
        OpenFile(SwapFileName).Edit;
        Exit;
      end;
      SwapFileName := ChangeFileExt(FileName, '.c');
      if GetFilePropertyByFileName(SwapFileName, swfp) then
      begin
        swfp.Edit;
        Exit;
      end;
      if FileExists(SwapFileName) then
      begin
        OpenFile(SwapFileName).Edit;
        Exit;
      end;
      if fprop is TProjectProperty then
      begin
        MessageBox(Handle, PChar(Format(STR_FRM_MAIN[34], [SwapFileName])),
          'Falcon C++', MB_ICONINFORMATION);
        Exit;
      end;
    end;
  end;
end;

procedure TFrmFalconMain.PopupTabsPopup(Sender: TObject);
begin
  PopTabsCloseAllOthers.Enabled := PageControlEditor.PageCount > 1;
end;

procedure TFrmFalconMain.PageControlEditorTabClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  sheet.Memo.SetFocus;
end;

procedure TFrmFalconMain.PageControlEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tab: Integer;
begin
  tab := PageControlEditor.TabAtPos(X, Y);
  if (tab >= 0) and (Button = mbMiddle) then
  begin
    PageControlEditor.ActivePageIndex := tab;
    if (PageControlEditor.ActivePageIndex >= 0) then
      PageControlEditor.CloseActiveTab;
  end;
end;

procedure TFrmFalconMain.EditFormatClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
  caret: TBufferCoord;
  topLine: Integer;
begin
  if not GetActiveSheet(sheet) then Exit;
  with TAStyle.Create do
  begin
    case Config.Editor.StyleIndex of
      0: // ansi
      begin
        Style := fsALLMAN;
        BracketFormat := bfBreakMode;
        Properties[aspNamespaceIndent] := True;
        Properties[aspSingleStatements] := True;
        Properties[aspBreakOneLineBlocks] := True;
      end;
      1: // K&R
      begin
        Style := fsKR;
        BracketFormat := bfAtatch;
        Properties[aspNamespaceIndent] := True;
        Properties[aspSingleStatements] := True;
        Properties[aspBreakOneLineBlocks] := True;
      end;
      2: //Linux
      begin
        Style := fsLINUX;
        TabWidth := 8;
        SpaceWidth := 8;
        BracketFormat := bfBDAC;
        Properties[aspNamespaceIndent] := True;
        Properties[aspSingleStatements] := True;
        Properties[aspBreakOneLineBlocks] := True;
      end;
      3: //GNU
      begin
        Style := fsGNU;
        TabWidth := 2;
        SpaceWidth := 2;
        BracketFormat := bfBreakMode;
        Properties[aspBlockIndent] := True;
        Properties[aspNamespaceIndent] := True;
        Properties[aspSingleStatements] := True;
        Properties[aspBreakOneLineBlocks] := True;
      end;
      4: //java
      begin
        Style := fsJAVA;
        BracketFormat := bfAtatch;
        Properties[aspSingleStatements] := True;
        Properties[aspBreakOneLineBlocks] := True;
      end;
      5: //custom
      begin
        //TODO
        UseTabChar := Config.Editor.UseTabChar;
        TabWidth := Config.Editor.TabWidth;
      end;
    end;
    caret := sheet.Memo.CaretXY;
    topLine := sheet.Memo.TopLine;
    sheet.Memo.SelectAll;
    sheet.Memo.SelText := Format(sheet.Memo.Text);
    sheet.Memo.CaretXY := caret;
    sheet.Memo.TopLine := topLine;
    Free;
  end;
end;

procedure TFrmFalconMain.EditIndentClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  sheet.Memo.CommandProcessor(ecBlockIndent, #0, nil);
end;

procedure TFrmFalconMain.EditUnindentClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then Exit;
  sheet.Memo.CommandProcessor(ecBlockUnindent, #0, nil);
end;

procedure TFrmFalconMain.CheckIfFilesHasChanged;
var
  FileProp: TFileProperty;
  Node: TTreeNode;
  FileName: String;
  I: Integer;
begin
  if not IsLoading and not ShowingReloadEnquiry then
  begin
    ShowingReloadEnquiry := True;
    for I := 0 to TreeViewProjects.Items.Count - 1 do
    begin
      Node := TreeViewProjects.Items.Item[I];
      FileProp := TFileProperty(Node.Data);
      if FileProp.FileChangedInDisk then
      begin
        FileName := FileProp.GetCompleteFileName;
        if MessageBox(Handle, PChar(FileName +
          #13#13'This file has been modified by another program.'#13 +
          'Do you want to reload it?'), 'Falcon C++',
          MB_ICONQUESTION or MB_YESNO) = IDYES then
        begin
          FileProp.Reload;
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

procedure TFrmFalconMain.PopEditorFindDeclClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
  SelStart, SelLine: Integer;
  TextAtCursor: String;
  Token: TTokenClass;
  TokenFile: TTokenFile;
  BufferCoord: TBufferCoord;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  BufferCoord := sheet.Memo.CaretXY;
  SelLine := BufferCoord.Line;
  if BufferCoord.Line > 0 then
  begin
    if BufferCoord.Char > (Length(sheet.Memo.Lines[SelLine - 1]) + 1) then
      BufferCoord.Char := Length(sheet.Memo.Lines[SelLine - 1]) + 1;
  end;
  TextAtCursor := sheet.Memo.GetWordAtRowCol(BufferCoord);
  SelStart := sheet.Memo.RowColToCharIndex(BufferCoord);
  if FilesParsed.FindDeclaration(TextAtCursor, ActiveEditingFile,
    TokenFile, Token, SelStart, SelLine) then
  begin

  end;
end;

procedure TFrmFalconMain.ToggleBreakpoint(aLine: Integer);
var
  sheet: TFilePropertySheet;
  fprop: TFileProperty;
  SourcePath, Source: String;
  Breakpoint: TBreakpoint;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := TFileProperty(sheet.Node.Data);
  if DebugReader.Running then
  begin
    if fprop.Breakpoint.HasBreakpoint(aLine) then
    begin
      Breakpoint := fprop.Breakpoint.GetBreakpoint(aLine);
      DebugReader.SendCommand(GDB_DELETE, IntToStr(Breakpoint.Index));
    end
    else
    begin
      SourcePath := ExtractFilePath(fprop.Project.GetCompleteFileName);
      Source := ExtractRelativePath(SourcePath, fprop.GetCompleteFileName);
      Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
      DebugReader.SendCommand(GDB_BREAK, Source + ':' + IntToStr(aLine));
    end;
  end;
  fprop.Breakpoint.ToogleBreakpoint(aLine);
  fprop.Project.BreakpointChanged := True;
  sheet.Memo.InvalidateGutterLine(aLine);
  sheet.Memo.InvalidateLine(aLine);
end;

procedure TFrmFalconMain.TextEditorGutterClick(Sender: TObject;
  Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  sheet: TFilePropertySheet;
  S: String;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  if (sheet.Memo.Lines.Count >= Line) and (Line > 0) then
  begin
    S := sheet.Memo.Lines.Strings[Line - 1];
    if not HasTODO(S) then
      ToggleBreakpoint(Line);
  end;
end;

procedure TFrmFalconMain.TextEditorGutterPaint(Sender: TObject; aLine, X,
  Y: Integer);
var
  sheet: TFilePropertySheet;
  fprop: TFileProperty;
  S: String;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := TFileProperty(sheet.Node.Data);
  if fprop.Breakpoint.HasBreakpoint(aLine) then
  begin
    fprop.Breakpoint.DrawBreakpoint(sheet.Memo, aLine, X, Y);
  end
  else if (sheet.Memo.Lines.Count >= aLine) and (aLine > 0) then
  begin
    S := sheet.Memo.Lines.Strings[aLine - 1];
    if HasTODO(S) then
    begin
      ImageListGutter.Draw(sheet.Memo.Canvas, X, Y, 5);
    end;
  end;
  if DebugReader.Running and Assigned(DebugActiveFile) and
    (DebugActiveFile = fprop) and (DebugActiveLine > 0) and
    (DebugActiveLine = aLine) then
  begin
    ImageListGutter.Draw(sheet.Memo.Canvas, X + 12, Y, 4);
  end;
end;

procedure TFrmFalconMain.TextEditorSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  sheet: TFilePropertySheet;
  fprop: TFileProperty;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := TFileProperty(sheet.Node.Data);
  if fprop.Breakpoint.HasBreakpoint(Line) then
  begin
    fg := clWindow;
    bg := clRed;
    Special := True;
    Exit;
  end;
  if DebugReader.Running and Assigned(DebugActiveFile) and
    (DebugActiveFile = fprop) and (DebugActiveLine > 0) and
    (DebugActiveLine = Line) then
  begin
    fg := clWindow;
    bg := clNavy;
    Special := True;
  end;
end;

procedure TFrmFalconMain.RunToggleBreakpointClick(Sender: TObject);
var
  Line: Integer;
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  Line := sheet.Memo.CaretY;
  ToggleBreakpoint(Line);
end;

procedure TFrmFalconMain.DebugReaderCommand(Sender: TObject;
  Command: TDebugCmd; const Name, Value: String; Line: Integer);
var
  sheet: TFilePropertySheet;
  fp: TFileProperty;
  OldActLine: Integer;
  S, FileName: String;
  Breakpoint: TBreakpoint;
begin
  AddItemMsg(DebugCmdNames[Command] + ' - ' + Name, Value, Line);
  case Command of
    dcBreakpoint:
    begin
      if GetActiveSheet(sheet) then
      begin
        fp := TFileProperty(sheet.Node.Data);
        S := ExtractFilePath(fp.Project.GetCompleteFileName);
        FileName := ConvertSlashes(S + Name);
        if CompareText(fp.GetCompleteFileName, FileName) <> 0 then
          if not GetFilePropertyByFileName(FileName, fp) then
            Exit;
      end
      else if Assigned(LastProjectBuild) then
      begin
        S := ExtractFilePath(LastProjectBuild.GetCompleteFileName);
        FileName := ConvertSlashes(S + Name);
        if not GetFilePropertyByFileName(FileName, fp) then
          Exit;
      end
      else
        Exit;
      if  fp.Breakpoint.HasBreakpoint(Line) then
      begin
        Breakpoint := fp.Breakpoint.GetBreakpoint(Line);
        Breakpoint.Index := StrToInt(Value);
        //AddItemMsg('breakpoint set index', Value, Line);
      end;
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
    end;
    dcIdle:
    begin
      CommandQueue.Clear;
    end;
    dcNoSymbol:
    begin
      HintTip.Cancel;
      CanShowHintTip := False;
    end;
    dcNextLine:
    begin
      if GetActiveSheet(sheet) then
      begin
        fp := TFileProperty(sheet.Node.Data);
        if CompareText(fp.GetCompleteFileName, Name) <> 0 then
        begin
          if not GetFilePropertyByFileName(Name, fp) then
          begin
            if FileExists(Name) then
              fp := OpenFile(Name)
            else
              Exit;
          end;
        end;
      end
      else
      begin
        if not GetFilePropertyByFileName(Name, fp) then
        begin
          if FileExists(Name) then
            fp := OpenFile(Name)
          else
            Exit;
        end;
      end;
      //fp is Name file
      sheet := fp.Edit;
      DebugActiveFile := fp;
      OldActLine := DebugActiveLine;
      DebugActiveLine := Line;
      if OldActLine > 0 then
      begin
        sheet.Memo.InvalidateLine(OldActLine);
        sheet.Memo.InvalidateGutterLine(OldActLine);
      end;
      sheet.Memo.InvalidateLine(DebugActiveLine);
      sheet.Memo.InvalidateGutterLine(DebugActiveLine);
      if GetForegroundWindow <> Handle then
        SetForegroundWindow(Handle);
      GotoLineAndAlignCenter(sheet.Memo, DebugActiveLine);
    end;
    dcPrint:
    begin
      if not GetActiveSheet(sheet) or CommandQueue.Empty then
        Exit;
      fp := TFileProperty(sheet.Node.Data);
      S := CommandQueue.Front.VarName + ' = ' + Value;
      HintTip.UpdateHint(S, CommandQueue.Front.Point.X,
        CommandQueue.Front.Point.Y + sheet.Memo.Canvas.TextHeight(S) + 5);
      CommandQueue.Dequeue;
    end;
    dcTerminate:
    begin
      DebugReader.SendCommand(GDB_QUIT);
      HintTip.Cancel;
      CanShowHintTip := False;
    end;
    dcExternalStep:
    begin
      DebugReader.SendCommand(GDB_CONTINUE);
    end;
    dcUnknow:
    begin
      HintTip.Cancel;
      CanShowHintTip := False;
    end;
  else
  end;
end;

procedure TFrmFalconMain.DebugReaderFinish(Sender: TObject;
  ExitCode: Integer);
var
  OldActLine: Integer;
  sheet: TFilePropertySheet;
begin
  if GetActiveSheet(sheet) then
  begin
    OldActLine := DebugActiveLine;
    DebugActiveLine := 0;
    if OldActLine > 0 then
    begin
      sheet.Memo.InvalidateLine(OldActLine);
      sheet.Memo.InvalidateGutterLine(OldActLine);
    end;
  end;
  LauncherFinished(Sender);
end;

procedure TFrmFalconMain.DebugReaderStart(Sender: TObject);
begin
  RunStepInto.Enabled := True;
  BtnStepInto.Enabled := True;
  RunStepOver.Enabled := True;
  BtnStepOver.Enabled := True;
  RunStepReturn.Enabled := True;
  BtnStepReturn.Enabled := True;
end;

procedure TFrmFalconMain.RunStepIntoClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_STEP);
end;

procedure TFrmFalconMain.RunStepOverClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_NEXT);
end;

procedure TFrmFalconMain.RunStepReturnClick(Sender: TObject);
begin
  if not DebugReader.Running then
    Exit;
  DebugReader.SendCommand(GDB_FINISH);
end;

procedure TFrmFalconMain.SelectTheme(Theme: String);
begin
  TBXSwitcher.Theme := Theme;
  Config.Environment.Theme := TBXSwitcher.Theme;
  if Theme = 'Default' then
  begin
    ViewThemeDef.Checked := True;
    Color := clBtnFace;
    DockLeft.Color := Color;
    DockTop.Color := Color;
    DockRight.Color := Color;
    DockBottom.Color := Color;
    RPExplorer.Color := Color;
    RPOLine.Color := Color;
    RPCmd.Color := Color;
    RSPExplorer.Color := Color;
    RSPEditor.Color := Color;
    RSPOLine.Color := Color;
    RSPCmd.Color := Color;
    PanelEditor.Color := Color;
    PanelActiveFile.Color := Color;
    PanelFileDesc.Color := Color;
    PanelRowCol.Color := Color;
    PanelCompStatus.Color := Color;
    RzStatusBar.Color := Color;
    PageControlEditor.BackgroundColor := Color;
    PageControlMsg.BackgroundColor := Color;
    PageControlOutline.BackgroundColor := Color;
    RzStatusBar.VisualStyle := vsWinXP;
  end
  else if Theme = 'Office11Adaptive' then
  begin
    ViewThemeOffAdpt.Checked := True;
    Color := TBXAdaptiveInfo.MenubarColor;
    DockLeft.Color := Color;
    DockTop.Color := Color;
    DockRight.Color := Color;
    DockBottom.Color := Color;
    RPExplorer.Color := Color;
    RPOLine.Color := Color;
    RPCmd.Color := Color;
    RSPExplorer.Color := Color;
    RSPEditor.Color := Color;
    RSPOLine.Color := Color;
    RSPCmd.Color := Color;
    PanelEditor.Color := Color;
    PanelActiveFile.Color := Color;
    PanelFileDesc.Color := Color;
    PanelRowCol.Color := Color;
    PanelCompStatus.Color := Color;
    RzStatusBar.Color := Color;
    PageControlEditor.BackgroundColor := Color;
    PageControlMsg.BackgroundColor := Color;
    PageControlOutline.BackgroundColor := Color;
    RzStatusBar.VisualStyle := vsClassic;
  end
  else if Theme = 'OfficeXP' then
  begin
    ViewThemeOffXP.Checked := True;
    Color := clBtnFace;
    DockLeft.Color := Color;
    DockTop.Color := Color;
    DockRight.Color := Color;
    DockBottom.Color := Color;
    RPExplorer.Color := Color;
    RPOLine.Color := Color;
    RPCmd.Color := Color;
    RSPExplorer.Color := Color;
    RSPEditor.Color := Color;
    RSPOLine.Color := Color;
    RSPCmd.Color := Color;
    PanelEditor.Color := Color;
    PanelActiveFile.Color := Color;
    PanelFileDesc.Color := Color;
    PanelRowCol.Color := Color;
    PanelCompStatus.Color := Color;
    RzStatusBar.Color := Color;
    PageControlEditor.BackgroundColor := Color;
    PageControlMsg.BackgroundColor := Color;
    PageControlOutline.BackgroundColor := Color;
    RzStatusBar.VisualStyle := vsClassic;
  end;
end;

procedure TFrmFalconMain.SelectThemeClick(Sender: TObject);
var
  Item: TTBXItem;
begin
  Item := TTBXItem(Sender);
  case Item.Tag of
    0: SelectTheme('Default');
    1: SelectTheme('Office11Adaptive');
    2: SelectTheme('OfficeXP');
  end;
end;

procedure TFrmFalconMain.PupMsgClearClick(Sender: TObject);
begin
  ListViewMsg.Clear;
end;

procedure TFrmFalconMain.RunRuntoCursorClick(Sender: TObject);
var
  ProjProp: TProjectProperty;
  FileProp: TFileProperty;
  sheet: TFilePropertySheet;
  SourcePath, Source: String;
begin
  if GetActiveSheet(sheet) then
  begin
    FileProp := TFileProperty(sheet.Node.Data);
    ProjProp := FileProp.Project;
    ProjProp.BreakpointCursor.Line := sheet.Memo.CaretY;
    ProjProp.BreakpointCursor.Valid := True;
    ProjProp.BreakpointCursor.FileName := FileProp.GetCompleteFileName;
    if DebugReader.Running then
    begin
      SourcePath := ExtractFilePath(ProjProp.GetCompleteFileName);
      Source := ExtractRelativePath(SourcePath, FileProp.GetCompleteFileName);
      Source := StringReplace(Source, '\', '/', [rfReplaceAll]);
      DebugReader.SendCommand(GDB_BREAK, Source + ':' +
        IntToStr(ProjProp.BreakpointCursor.Line));
      DebugReader.SendCommand(GDB_CONTINUE);
      Exit;
    end;
    CompilerActiveMsg := STR_FRM_MAIN[18];
    if ProjProp.NeedBuild  then
    begin
      CompStoped := False;
      ProjProp.Build(True);
    end
    else
      SubMExecuteClick(Sender);
  end;
end;

procedure TFrmFalconMain.SearchGotoFunctionClick(Sender: TObject);
var
  List, files: TStrings;
  Node: TTreeNode;
  TokenFile: TTokenFile;
  Proj: TProjectProperty;
  I, Index: Integer;
begin
  List := TStringList.Create;
  Node := TreeViewProjects.Items.GetFirstNode;
  while Node <> nil do
  begin
    Proj := TProjectProperty(Node.Data);
    files := Proj.GetFiles;
    for I := 0 to files.Count - 1 do
    begin
      Index := FilesParsed.IndexOfByFileName(files.Strings[I]);
      if Index >= 0 then
      begin
        TokenFile := FilesParsed.Items[Index];
        TokenFile.GetFunctions(List);
      end;
    end;
    files.Free;
    Node := Node.getNextSibling;
  end;
  FormGotoFunction := TFormGotoFunction.Create(Self);
  FormGotoFunction.Fill(List);
  List.Free;
  FormGotoFunction.ShowModal;
end;

procedure TFrmFalconMain.SearchGotoLineClick(Sender: TObject);
var
  sheet: TFilePropertySheet;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  if sheet.Memo.Lines.Count < 3 then
    Exit;
  FormGotoLine := TFormGotoLine.Create(Self);
  FormGotoLine.ShowWithRange(1, sheet.Memo.CaretY, sheet.Memo.Lines.Count);
end;

procedure TFrmFalconMain.SearchGotoPrevFuncClick(Sender: TObject);
var
  Index: Integer;
  sheet: TFilePropertySheet;
  fprop: TFileProperty;
  TokenFile: TTokenFile;
  token: TTokenClass;
  Buffer: TBufferCoord;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := TFileProperty(sheet.Node.Data);
  Index := FilesParsed.IndexOfByFileName(fprop.GetCompleteFileName, fprop);
  if Index < 0 then
    Exit;
  TokenFile := FilesParsed.Items[Index];
  if not TokenFile.GetPreviousFunction(token, sheet.Memo.SelStart) then
    Exit;
  token := GetTokenByName(token, 'Scope', tkScope);
  Buffer := sheet.Memo.CharIndexToRowCol(Token.SelStart);
  GotoLineAndAlignCenter(sheet.Memo, Buffer.Line, Buffer.Char);
end;

procedure TFrmFalconMain.SearchGotoNextFuncClick(Sender: TObject);
var
  Index: Integer;
  sheet: TFilePropertySheet;
  fprop: TFileProperty;
  TokenFile: TTokenFile;
  token: TTokenClass;
  Buffer: TBufferCoord;
begin
  if not GetActiveSheet(sheet) then
    Exit;
  fprop := TFileProperty(sheet.Node.Data);
  Index := FilesParsed.IndexOfByFileName(fprop.GetCompleteFileName, fprop);
  if Index < 0 then
    Exit;
  TokenFile := FilesParsed.Items[Index];
  if not TokenFile.GetNextFunction(token, sheet.Memo.SelStart) then
    Exit;
  token := GetTokenByName(token, 'Scope', tkScope);
  Buffer := sheet.Memo.CharIndexToRowCol(Token.SelStart);
  GotoLineAndAlignCenter(sheet.Memo, Buffer.Line, Buffer.Char);
end;

end.
