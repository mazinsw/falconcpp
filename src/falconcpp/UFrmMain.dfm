object FrmFalconMain: TFrmFalconMain
  Left = 278
  Top = 187
  Width = 922
  Height = 655
  Caption = 'Falcon C++'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DockTop: TTBXDock
    Tag = 1
    Left = 0
    Top = 24
    Width = 914
    Height = 27
    BoundLines = [blTop]
    Color = clBtnFace
    object DefaultBar: TTBXToolbar
      Left = 0
      Top = 0
      Caption = 'Default Bar'
      DefaultDock = DockTop
      DockPos = 0
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClose = ToolbarClose
      object BtnNew: TTBXSubmenuItem
        AlwaysSelectFirst = True
        Caption = 'New'
        DropdownCombo = True
        ImageIndex = 6
        LinkSubitems = FileNew
        OnClick = NewItemClick
      end
      object BtnOpen: TTBXItem
        Caption = 'Open'
        ImageIndex = 9
        ShortCut = 16463
        OnClick = FileOpenClick
      end
      object BtnRemove: TTBXItem
        Caption = 'Remove'
        Enabled = False
        ImageIndex = 12
        OnClick = RemoveClick
      end
      object TBXSeparatorItem1: TTBXSeparatorItem
      end
      object BtnSave: TTBXItem
        Caption = 'Save'
        Enabled = False
        ImageIndex = 10
        ShortCut = 16467
        OnClick = FileSaveClick
      end
      object BtnSaveAll: TTBXItem
        Caption = 'Save All'
        Enabled = False
        ImageIndex = 11
        ShortCut = 24659
        OnClick = FileSaveAllClick
      end
    end
    object EditBar: TTBXToolbar
      Tag = 1
      Left = 144
      Top = 0
      Caption = 'Edit Bar'
      DefaultDock = DockTop
      DockPos = 128
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClose = ToolbarClose
      object BtnUndo: TTBXItem
        Caption = 'Undo'
        Enabled = False
        ImageIndex = 18
        ShortCut = 16474
        OnClick = SubMUndoClick
      end
      object BtnRedo: TTBXItem
        Caption = 'Redo'
        Enabled = False
        ImageIndex = 19
        ShortCut = 16473
        OnClick = SubMRedoClick
      end
    end
    object NavigatorBar: TTBXToolbar
      Tag = 4
      Left = 393
      Top = 0
      Caption = 'Navigator Bar'
      DefaultDock = DockTop
      DockPos = 179
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ProcessShortCuts = True
      ShowHint = True
      TabOrder = 2
      OnClose = ToolbarClose
      object BtnPrevPage: TTBXItem
        Caption = 'Previous Page'
        Enabled = False
        ImageIndex = 13
        OnClick = BtnPreviousPageClick
      end
      object BtnNextPage: TTBXItem
        Caption = 'Next Page'
        Enabled = False
        ImageIndex = 14
        OnClick = BtnNextPageClick
      end
      object TBXSeparatorItem33: TTBXSeparatorItem
      end
      object BtnToggleBook: TTBXSubmenuItem
        Caption = 'Toggle Bookmarks'
        Enabled = False
        ImageIndex = 53
        LinkSubitems = EditBookmarks
      end
      object BtnGotoBook: TTBXSubmenuItem
        Caption = 'Goto Bookmarks'
        Enabled = False
        ImageIndex = 52
        LinkSubitems = EditGotoBookmarks
      end
    end
    object CompilerBar: TTBXToolbar
      Tag = 3
      Left = 285
      Top = 0
      Caption = 'Compiler Bar'
      DefaultDock = DockTop
      DockPos = 179
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClose = ToolbarClose
      object BtnRun: TTBXItem
        Caption = 'Run'
        Enabled = False
        ImageIndex = 23
        ShortCut = 120
        OnClick = RunRunClick
      end
      object BtnCompile: TTBXItem
        Caption = 'Compile'
        Enabled = False
        ImageIndex = 25
        ShortCut = 16504
        OnClick = RunCompileClick
      end
      object BtnExecute: TTBXItem
        Caption = 'Execute'
        Enabled = False
        ImageIndex = 26
        ShortCut = 116
        OnClick = RunExecuteClick
      end
      object TBXSeparatorItem9: TTBXSeparatorItem
      end
      object BtnStop: TTBXItem
        Caption = 'Stop'
        Enabled = False
        ImageIndex = 24
        ShortCut = 16497
        OnClick = RunStopClick
      end
    end
    object ProjectBar: TTBXToolbar
      Tag = 5
      Left = 501
      Top = 0
      Caption = 'Project Bar'
      DefaultDock = DockTop
      DockPos = 395
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClose = ToolbarClose
      object BtnNewProj: TTBXItem
        Tag = 1
        Caption = 'New Project'
        ImageIndex = 1
        OnClick = NewItemClick
      end
      object BtnProperties: TTBXItem
        Caption = 'Properties'
        Enabled = False
        ImageIndex = 20
        ShortCut = 32781
        OnClick = ProjectPropertiesClick
      end
    end
    object HelpBar: TTBXToolbar
      Tag = 6
      Left = 557
      Top = 0
      Caption = 'Help Bar'
      DefaultDock = DockTop
      DockPos = 447
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClose = ToolbarClose
      object BtnHelp: TTBXItem
        Caption = 'Help'
        ImageIndex = 30
        ShortCut = 112
        OnClick = BtnHelpClick
      end
      object BtnContxHelp: TTBXItem
        Caption = 'Context Help'
        Enabled = False
        ImageIndex = 21
      end
    end
    object DebugBar: TTBXToolbar
      Tag = 7
      Left = 613
      Top = 0
      Caption = 'Debug Bar'
      DefaultDock = DockTop
      DockPos = 467
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClose = ToolbarClose
      object BtnStepInto: TTBXItem
        Caption = 'Step Into'
        Enabled = False
        ImageIndex = 46
        ShortCut = 119
        OnClick = RunStepIntoClick
      end
      object BtnStepOver: TTBXItem
        Caption = 'Step Over'
        Enabled = False
        ImageIndex = 54
        ShortCut = 118
        OnClick = RunStepOverClick
      end
      object BtnStepReturn: TTBXItem
        Caption = 'Step Return'
        Enabled = False
        ImageIndex = 55
        ShortCut = 117
        OnClick = RunStepReturnClick
      end
    end
    object SearchBar: TTBXToolbar
      Tag = 2
      Left = 200
      Top = 0
      Caption = 'Search Bar'
      DefaultDock = DockTop
      DockPos = 179
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClose = ToolbarClose
      object BtnFind: TTBXItem
        Caption = 'Find'
        Enabled = False
        ImageIndex = 37
        ShortCut = 16454
        OnClick = FindMenuClick
      end
      object BtnReplace: TTBXItem
        Caption = 'Replace'
        Enabled = False
        ImageIndex = 48
        ShortCut = 16466
        OnClick = ReplaceMenuClick
      end
      object TBXSeparatorItem29: TTBXSeparatorItem
      end
      object BtnGotoLN: TTBXItem
        Caption = 'Goto Line Number'
        Enabled = False
        ImageIndex = 36
        ShortCut = 16455
      end
    end
  end
  object MenuDock: TTBXDock
    Left = 0
    Top = 0
    Width = 914
    Height = 24
    AllowDrag = False
    BoundLines = [blBottom]
    Color = clBtnFace
    object MenuBar: TTBXToolbar
      Left = 0
      Top = 0
      ActivateParent = False
      Caption = 'Menu Bar'
      CloseButton = False
      DockMode = dmCannotFloatOrChangeDocks
      DragHandleStyle = dhNone
      FullSize = True
      Images = ImgListMenus
      MenuBar = True
      Options = [tboDefault]
      ProcessShortCuts = True
      ShrinkMode = tbsmWrap
      TabOrder = 0
      object MenuFile: TTBXSubmenuItem
        Caption = '&File'
        object FileNew: TTBXSubmenuItem
          Caption = '&New'
          ImageIndex = 6
          object SubNNewProject: TTBXItem
            Tag = 1
            Caption = '&Project...'
            ImageIndex = 1
            OnClick = NewItemClick
          end
          object SubNNewCFile: TTBXItem
            Tag = 2
            Caption = 'C File'
            ImageIndex = 2
            OnClick = NewItemClick
          end
          object SubNNewCppFile: TTBXItem
            Tag = 3
            Caption = 'C++ File'
            ImageIndex = 3
            ShortCut = 16462
            OnClick = NewItemClick
          end
          object SubNNewHeaderFile: TTBXItem
            Tag = 4
            Caption = 'Header File'
            ImageIndex = 4
            OnClick = NewItemClick
          end
          object SubNNewResFile: TTBXItem
            Tag = 5
            Caption = 'Resource File'
            ImageIndex = 5
            OnClick = NewItemClick
          end
          object SubNNewEmptyFile: TTBXItem
            Tag = 6
            Caption = 'Empty File'
            ImageIndex = 6
            OnClick = NewItemClick
          end
          object TBXSeparatorItem3: TTBXSeparatorItem
          end
          object SubNNewFolder: TTBXItem
            Tag = 7
            Caption = 'Folder'
            Enabled = False
            ImageIndex = 7
            OnClick = NewItemClick
          end
        end
        object FileOpen: TTBXItem
          Caption = '&Open'
          ImageIndex = 9
          ShortCut = 16463
          OnClick = FileOpenClick
        end
        object FileReopen: TTBXSubmenuItem
          Caption = '&Reopen'
          object FileReopenClear: TTBXItem
            Caption = '(None)'
            Enabled = False
            OnClick = ClearHistoryClick
          end
        end
        object TBXSeparatorItem4: TTBXSeparatorItem
        end
        object FileSave: TTBXItem
          Caption = '&Save'
          Enabled = False
          ImageIndex = 10
          ShortCut = 16467
          OnClick = FileSaveClick
        end
        object FileSaveAs: TTBXItem
          Caption = 'Save &As...'
          Enabled = False
          OnClick = FileSaveAsClick
        end
        object FileSaveAll: TTBXItem
          Caption = 'Save All'
          Enabled = False
          ImageIndex = 11
          ShortCut = 24659
          OnClick = FileSaveAllClick
        end
        object TBXSeparatorItem22: TTBXSeparatorItem
        end
        object FileImport: TTBXSubmenuItem
          Caption = 'Import'
          object FileImpDevCpp: TTBXItem
            Caption = 'Dev-C++ Project'
            OnClick = ImportFromDevCpp
          end
          object FileImpCodeBlocks: TTBXItem
            Caption = 'Code::Blocks Project'
            OnClick = ImportFromCodeBlocks
          end
          object FileImpMSVC: TTBXItem
            Caption = 'MS Visual C++ Project'
            Enabled = False
            OnClick = ImportFromMSVC
          end
        end
        object FileExport: TTBXSubmenuItem
          Caption = 'Export'
          Enabled = False
          object FileExportHTML: TTBXItem
            Caption = 'to HTML'
            OnClick = FileExportHTMLClick
          end
          object FileExportRTF: TTBXItem
            Caption = 'to RTF'
            OnClick = FileExportRTFClick
          end
          object FileExportTeX: TTBXItem
            Caption = 'to TeX'
            OnClick = FileExportTeXClick
          end
        end
        object TBXSeparatorItem15: TTBXSeparatorItem
        end
        object FileClose: TTBXItem
          Caption = '&Close'
          Enabled = False
          ShortCut = 16471
          OnClick = FileCloseClick
        end
        object FileCloseAll: TTBXItem
          Caption = 'C&lose All'
          Enabled = False
          OnClick = FileCloseAllClick
        end
        object FileRemove: TTBXItem
          Caption = 'Remove'
          Enabled = False
          OnClick = RemoveClick
        end
        object TBXSeparatorItem6: TTBXSeparatorItem
        end
        object FilePrint: TTBXItem
          Caption = '&Print'
          Enabled = False
          ShortCut = 16464
          OnClick = FilePrintClick
        end
        object TBXSeparatorItem38: TTBXSeparatorItem
        end
        object FileExit: TTBXItem
          Caption = '&Exit'
          ImageIndex = 29
          OnClick = FileExitClick
        end
      end
      object MenuEdit: TTBXSubmenuItem
        Caption = '&Edit'
        object EditUndo: TTBXItem
          Caption = 'Undo'
          Enabled = False
          ImageIndex = 18
          ShortCut = 16474
          OnClick = SubMUndoClick
        end
        object EditRedo: TTBXItem
          Caption = 'Redo'
          Enabled = False
          ImageIndex = 19
          ShortCut = 16473
          OnClick = SubMRedoClick
        end
        object TBXSeparatorItem7: TTBXSeparatorItem
        end
        object EditCut: TTBXItem
          Caption = 'Cut'
          Enabled = False
          ImageIndex = 15
          ShortCut = 16472
          OnClick = SubMCutClick
        end
        object EditCopy: TTBXItem
          Caption = 'Copy'
          Enabled = False
          ImageIndex = 16
          ShortCut = 16451
          OnClick = SubMCopyClick
        end
        object EditPaste: TTBXItem
          Caption = 'Paste'
          Enabled = False
          ImageIndex = 17
          ShortCut = 16470
          OnClick = SubMPasteClick
        end
        object TBXSeparatorItem5: TTBXSeparatorItem
        end
        object EditSwap: TTBXItem
          Caption = 'Swap header/source'
          Enabled = False
          ShortCut = 122
          OnClick = EditSwapClick
        end
        object TBXSeparatorItem42: TTBXSeparatorItem
        end
        object EditDelete: TTBXItem
          Caption = 'Delete'
          Enabled = False
          ImageIndex = 12
          ShortCut = 46
          OnClick = PopEditorDeleteClick
        end
        object EditSelectAll: TTBXItem
          Caption = 'Select All'
          Enabled = False
          ImageIndex = 45
          ShortCut = 16449
          OnClick = SubMSelectAllClick
        end
        object TBXSeparatorItem36: TTBXSeparatorItem
        end
        object EditBookmarks: TTBXSubmenuItem
          Caption = 'Toggle Bookmarks'
          Enabled = False
          ImageIndex = 53
          object TBXItem35: TTBXItem
            Tag = 1
            AutoCheck = True
            Caption = 'Bookmark &1'
            ShortCut = 16433
            OnClick = ToggleBookmarksClick
          end
          object TBXItem36: TTBXItem
            Tag = 2
            AutoCheck = True
            Caption = 'Bookmark &2'
            ShortCut = 16434
            OnClick = ToggleBookmarksClick
          end
          object TBXItem37: TTBXItem
            Tag = 3
            AutoCheck = True
            Caption = 'Bookmark &3'
            ShortCut = 16435
            OnClick = ToggleBookmarksClick
          end
          object TBXItem38: TTBXItem
            Tag = 4
            AutoCheck = True
            Caption = 'Bookmark &4'
            ShortCut = 16436
            OnClick = ToggleBookmarksClick
          end
          object TBXItem44: TTBXItem
            Tag = 5
            AutoCheck = True
            Caption = 'Bookmark &5'
            ShortCut = 16437
            OnClick = ToggleBookmarksClick
          end
          object TBXItem45: TTBXItem
            Tag = 6
            AutoCheck = True
            Caption = 'Bookmark &6'
            ShortCut = 16438
            OnClick = ToggleBookmarksClick
          end
          object TBXItem46: TTBXItem
            Tag = 7
            AutoCheck = True
            Caption = 'Bookmark &7'
            ShortCut = 16439
            OnClick = ToggleBookmarksClick
          end
          object TBXItem47: TTBXItem
            Tag = 8
            AutoCheck = True
            Caption = 'Bookmark &8'
            ShortCut = 16440
            OnClick = ToggleBookmarksClick
          end
          object TBXItem50: TTBXItem
            Tag = 9
            AutoCheck = True
            Caption = 'Bookmark &9'
            ShortCut = 16441
            OnClick = ToggleBookmarksClick
          end
        end
        object EditGotoBookmarks: TTBXSubmenuItem
          Caption = 'Goto Bookmarks'
          Enabled = False
          ImageIndex = 52
          object TBXItem58: TTBXItem
            Tag = 1
            Caption = 'Bookmark &1'
            ShortCut = 32817
            OnClick = GotoBookmarkClick
          end
          object TBXItem62: TTBXItem
            Tag = 2
            Caption = 'Bookmark &2'
            ShortCut = 32818
            OnClick = GotoBookmarkClick
          end
          object TBXItem65: TTBXItem
            Tag = 3
            Caption = 'Bookmark &3'
            ShortCut = 32819
            OnClick = GotoBookmarkClick
          end
          object TBXItem66: TTBXItem
            Tag = 4
            Caption = 'Bookmark &4'
            ShortCut = 32820
            OnClick = GotoBookmarkClick
          end
          object TBXItem71: TTBXItem
            Tag = 5
            Caption = 'Bookmark &5'
            ShortCut = 32821
            OnClick = GotoBookmarkClick
          end
          object TBXItem74: TTBXItem
            Tag = 6
            Caption = 'Bookmark &6'
            ShortCut = 32822
            OnClick = GotoBookmarkClick
          end
          object TBXItem75: TTBXItem
            Tag = 7
            Caption = 'Bookmark &7'
            ShortCut = 32823
            OnClick = GotoBookmarkClick
          end
          object TBXItem76: TTBXItem
            Tag = 8
            Caption = 'Bookmark &8'
            ShortCut = 32824
            OnClick = GotoBookmarkClick
          end
          object TBXItem78: TTBXItem
            Tag = 9
            Caption = 'Bookmark &9'
            ShortCut = 32825
            OnClick = GotoBookmarkClick
          end
        end
        object TBXSeparatorItem37: TTBXSeparatorItem
        end
        object EditIndent: TTBXItem
          Caption = 'Indent'
          Enabled = False
          ShortCut = 24649
          OnClick = EditIndentClick
        end
        object EditUnindent: TTBXItem
          Caption = 'Unindent'
          Enabled = False
          ShortCut = 24661
          OnClick = EditUnindentClick
        end
        object TBXSeparatorItem43: TTBXSeparatorItem
        end
        object EditFormat: TTBXItem
          Caption = 'Format'
          Enabled = False
          ShortCut = 24646
          OnClick = EditFormatClick
        end
      end
      object MenuSearch: TTBXSubmenuItem
        Caption = '&Search'
        object SearchFind: TTBXItem
          Caption = 'Find...'
          Enabled = False
          ImageIndex = 37
          ShortCut = 16454
          OnClick = FindMenuClick
        end
        object SearchFindNext: TTBXItem
          Caption = 'Find Next'
          Enabled = False
          ShortCut = 114
          OnClick = FindNextMenuClick
        end
        object SearchFindPrev: TTBXItem
          Caption = 'Find Previous'
          Enabled = False
          ShortCut = 8306
          OnClick = FindPrevMenuClick
        end
        object SearchFindFiles: TTBXItem
          Caption = 'Find in Files...'
          Enabled = False
          ShortCut = 16456
          OnClick = FindFilesMenuClick
        end
        object SearchReplace: TTBXItem
          Caption = 'Replace...'
          Enabled = False
          ImageIndex = 48
          ShortCut = 16466
          OnClick = ReplaceMenuClick
        end
        object TBXItem70: TTBXItem
          Caption = 'Incremental Search...'
          Enabled = False
          ShortCut = 16460
        end
        object TBXSeparatorItem16: TTBXSeparatorItem
        end
        object SearchGotoFunction: TTBXItem
          Caption = 'Goto Funcion...'
          Enabled = False
          ShortCut = 24647
          OnClick = SearchGotoFunctionClick
        end
        object SearchGotoPrevFunc: TTBXItem
          Caption = 'Goto Previous Function'
          Enabled = False
          OnClick = SearchGotoPrevFuncClick
        end
        object SearchGotoNextFunc: TTBXItem
          Caption = 'Goto Next Function'
          Enabled = False
          OnClick = SearchGotoNextFuncClick
        end
        object SearchGotoLine: TTBXItem
          Caption = 'Goto Line Number...'
          Enabled = False
          ImageIndex = 36
          ShortCut = 16455
          OnClick = SearchGotoLineClick
        end
      end
      object MenuView: TTBXSubmenuItem
        Caption = '&View'
        object ViewProjMan: TTBXItem
          AutoCheck = True
          Caption = 'Project Manager'
          Checked = True
          OnClick = ViewMenuClick
        end
        object ViewStatusBar: TTBXItem
          Tag = 1
          AutoCheck = True
          Caption = 'Statusbar'
          Checked = True
          OnClick = ViewMenuClick
        end
        object ViewOutline: TTBXItem
          Tag = 2
          AutoCheck = True
          Caption = 'Outline'
          Checked = True
          OnClick = ViewMenuClick
        end
        object ViewCompOut: TTBXItem
          Caption = 'Compiler Output'
          OnClick = ViewCompOutClick
        end
        object ViewToolbar: TTBXSubmenuItem
          Caption = 'Toolbars'
          object TBXItem52: TTBXItem
            AutoCheck = True
            Caption = 'Default Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem73: TTBXItem
            Tag = 1
            AutoCheck = True
            Caption = 'Edit Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem55: TTBXItem
            Tag = 2
            AutoCheck = True
            Caption = 'Search Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem61: TTBXItem
            Tag = 3
            AutoCheck = True
            Caption = 'Compiler Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem8: TTBXItem
            Tag = 4
            AutoCheck = True
            Caption = 'Navigator Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem77: TTBXItem
            Tag = 5
            AutoCheck = True
            Caption = 'Project Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem79: TTBXItem
            Tag = 6
            AutoCheck = True
            Caption = 'Help Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
          object TBXItem1: TTBXItem
            Tag = 7
            AutoCheck = True
            Caption = 'Debug Bar'
            Checked = True
            OnClick = TViewToolbarClick
          end
        end
        object SbMnThemes: TTBXSubmenuItem
          Tag = 2
          Caption = 'Themes'
          object ViewThemeDef: TTBXItem
            AutoCheck = True
            Caption = 'Default'
            GroupIndex = 1
            OnClick = SelectThemeClick
          end
          object ViewThemeOffice2003: TTBXItem
            Tag = 1
            AutoCheck = True
            Caption = 'Office 2003'
            Checked = True
            GroupIndex = 1
            OnClick = SelectThemeClick
          end
          object ViewThemeOffXP: TTBXItem
            Tag = 2
            AutoCheck = True
            Caption = 'Office XP'
            GroupIndex = 1
            OnClick = SelectThemeClick
          end
          object ViewThemeStripes: TTBXItem
            Tag = 3
            AutoCheck = True
            Caption = 'Stripes'
            GroupIndex = 1
            OnClick = SelectThemeClick
          end
          object ViewThemeProfessional: TTBXItem
            Tag = 4
            AutoCheck = True
            Caption = 'Professional'
            GroupIndex = 1
            OnClick = SelectThemeClick
          end
          object ViewThemeAluminum: TTBXItem
            Tag = 5
            AutoCheck = True
            Caption = 'Aluminum'
            GroupIndex = 1
            OnClick = SelectThemeClick
          end
        end
        object TBXSubmenuItem2: TTBXSubmenuItem
          Tag = 2
          Caption = 'Zoom'
          object ViewZoomInc: TTBXItem
            Caption = 'Increase'
            GroupIndex = 1
            ImageIndex = 39
            OnClick = ViewZoomIncClick
          end
          object ViewZoomDec: TTBXItem
            Tag = 1
            Caption = 'Decrease'
            GroupIndex = 1
            ImageIndex = 38
            OnClick = ViewZoomDecClick
          end
        end
        object TBXSeparatorItem21: TTBXSeparatorItem
        end
        object ViewFullScreen: TTBXItem
          Caption = 'Full Screen'
          ShortCut = 123
          OnClick = FullScreen1Click
        end
        object TBXSeparatorItem20: TTBXSeparatorItem
        end
        object ViewRestoreDefault: TTBXItem
          Caption = 'Restore Default'
          OnClick = RestoreDefault1Click
        end
      end
      object MenuProject: TTBXSubmenuItem
        Caption = '&Project'
        object ProjectAdd: TTBXItem
          Caption = 'Add'
          Enabled = False
          ImageIndex = 27
          OnClick = ProjectAddClick
        end
        object ProjectRemove: TTBXItem
          Caption = 'Remove'
          Enabled = False
          ImageIndex = 28
          OnClick = SubMRemoveClick
        end
        object TBXSeparatorItem2: TTBXSeparatorItem
        end
        object ProjectBuild: TTBXItem
          Caption = 'Build'
          Enabled = False
          ImageIndex = 26
          OnClick = SubMBuildClick
        end
        object TBXSeparatorItem10: TTBXSeparatorItem
        end
        object ProjectProperties: TTBXItem
          Caption = 'Properties'
          Enabled = False
          ImageIndex = 20
          ShortCut = 32781
          OnClick = ProjectPropertiesClick
        end
      end
      object MenuRun: TTBXSubmenuItem
        Caption = '&Run'
        object RunRun: TTBXItem
          Caption = 'Run'
          Enabled = False
          ImageIndex = 23
          ShortCut = 120
          OnClick = RunRunClick
        end
        object RunCompile: TTBXItem
          Caption = 'Compile'
          Enabled = False
          ImageIndex = 25
          ShortCut = 16504
          OnClick = RunCompileClick
        end
        object RunExecute: TTBXItem
          Caption = 'Execute'
          Enabled = False
          ImageIndex = 26
          ShortCut = 116
          OnClick = RunExecuteClick
        end
        object TBXSeparatorItem12: TTBXSeparatorItem
        end
        object RunToggleBreakpoint: TTBXItem
          Caption = 'Toggle Breakpoint'
          Enabled = False
          ShortCut = 16450
          OnClick = RunToggleBreakpointClick
        end
        object RunStepInto: TTBXItem
          Caption = 'Step Into'
          Enabled = False
          ImageIndex = 46
          ShortCut = 119
          OnClick = RunStepIntoClick
        end
        object RunStepOver: TTBXItem
          Caption = 'Step Over'
          Enabled = False
          ImageIndex = 54
          ShortCut = 118
          OnClick = RunStepOverClick
        end
        object RunStepReturn: TTBXItem
          Caption = 'Step Return'
          Enabled = False
          ImageIndex = 55
          ShortCut = 117
          OnClick = RunStepReturnClick
        end
        object RunRuntoCursor: TTBXItem
          Caption = 'Run to Cursor'
          Enabled = False
          ShortCut = 115
          OnClick = RunRuntoCursorClick
        end
        object RunStop: TTBXItem
          Caption = 'Stop'
          Enabled = False
          ImageIndex = 24
          ShortCut = 16497
          OnClick = RunStopClick
        end
      end
      object MenuTools: TTBXSubmenuItem
        Caption = '&Tools'
        object TBXItem49: TTBXItem
          Caption = 'Environment Options...'
          OnClick = EnvironOptions1Click
        end
        object TBXItem48: TTBXItem
          Caption = 'Compiler Options...'
          OnClick = CompilerOptions2Click
        end
        object TBXItem43: TTBXItem
          Caption = 'Editor Options...'
          OnClick = EditorOptions1Click
        end
        object TBXSeparatorItem18: TTBXSeparatorItem
        end
        object TBXItem86: TTBXItem
          Caption = 'Template Creator...'
        end
        object TBXItem72: TTBXItem
          Caption = 'Package Creator...'
        end
        object TBXSeparatorItem19: TTBXSeparatorItem
        end
        object TBXItem87: TTBXItem
          Caption = 'Packages...'
          OnClick = Packages1Click
        end
      end
      object MenuHelp: TTBXSubmenuItem
        Caption = '&Help'
        object HelpFalcon: TTBXSubmenuItem
          Caption = 'Falcon Help'
          ImageIndex = 30
          object TBXItem2: TTBXItem
            Caption = 'Falcon C++'
            ImageIndex = 21
            OnClick = FalconHelpClick
          end
        end
        object TBXItem90: TTBXItem
          Caption = 'Tip of the Day...'
        end
        object TBXSeparatorItem11: TTBXSeparatorItem
        end
        object TBXItem40: TTBXItem
          Caption = 'Update...'
          ImageIndex = 47
          OnClick = SubMUpdateClick
        end
        object TBXItem5: TTBXItem
          Caption = 'Report a Bug/Comment...'
          ImageIndex = 40
          OnClick = ReportaBugorComment1Click
        end
        object TBXSeparatorItem13: TTBXSeparatorItem
        end
        object TBXItem39: TTBXItem
          Caption = 'About...'
          OnClick = About1Click
        end
      end
    end
  end
  object DockBottom: TTBXDock
    Tag = 2
    Left = 0
    Top = 590
    Width = 914
    Height = 9
    Position = dpBottom
  end
  object DockLeft: TTBXDock
    Tag = 3
    Left = 185
    Top = 51
    Width = 9
    Height = 539
    Position = dpLeft
  end
  object DockRight: TTBXDock
    Tag = 4
    Left = 720
    Top = 51
    Width = 9
    Height = 539
    Position = dpRight
  end
  object PanelEditorMessages: TPanel
    Left = 194
    Top = 51
    Width = 526
    Height = 539
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object PanelEditor: TXPPanel
      Left = 0
      Top = 0
      Width = 526
      Height = 392
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 1
      object PageControlEditor: TModernPageControl
        Left = 0
        Top = 0
        Width = 526
        Height = 392
        Align = alClient
        NormalColor = clWhite
        FocusedColor = 15973017
        Images = ImgListMenus
        PopupMenu = PopupTabs
        TabIndex = -1
        TabOrder = 0
        TabStop = True
        Visible = False
        OnChange = PageControlEditorChange
        OnClose = PageControlEditorClose
        OnContextPopup = PageControlEditorContextPopup
        OnDblClick = PageControlEditorDblClick
        OnMouseDown = PageControlEditorMouseDown
        OnPageChange = PageControlEditorPageChange
      end
    end
    object PanelMessages: TSplitterPanel
      Left = 0
      Top = 392
      Width = 526
      Height = 147
      Align = alBottom
      BorderStyle = bsNone
      Size = 4
      TabOrder = 0
      Visible = False
      object PageControlMessages: TModernPageControl
        Left = 0
        Top = 4
        Width = 526
        Height = 143
        ActivePage = TSMessages
        Align = alClient
        NormalColor = clWhite
        FocusedColor = 15973017
        TabIndex = 0
        TabOrder = 0
        TabStop = True
        OnClose = PageControlMsgClose
        object TSMessages: TModernTabSheet
          Caption = 'Messages'
          ImageIndex = 0
          PageControl = PageControlMessages
          object ListViewMsg: TListView
            Left = 0
            Top = 0
            Width = 520
            Height = 112
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Columns = <
              item
                Caption = 'File'
                Width = 100
              end
              item
                Caption = 'Line'
              end
              item
                AutoSize = True
                Caption = 'Notification'
              end>
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            PopupMenu = PopupMsg
            SmallImages = ImgListMenus
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = ListViewMsgDblClick
            OnDeletion = ListViewMsgDeletion
            OnSelectItem = ListViewMsgSelectItem
          end
        end
      end
    end
  end
  object StatusBar: TTBXStatusBar
    Left = 0
    Top = 599
    Width = 914
    Images = ImgListMenus
    Panels = <
      item
        Size = 140
        Tag = 0
        TextTruncation = twEndEllipsis
      end
      item
        Size = 170
        Tag = 0
      end
      item
        Size = 170
        Tag = 0
      end
      item
        Control = ProgressBarParser
        Size = 150
        Tag = 0
      end>
    ParentShowHint = False
    ShowHint = True
    UseSystemFont = False
    object ProgressBarParser: TProgressBar
      Left = 480
      Top = 4
      Width = 148
      Height = 16
      TabOrder = 0
      Visible = False
    end
  end
  object ProjectPanel: TSplitterPanel
    Left = 0
    Top = 51
    Width = 185
    Height = 539
    Align = alLeft
    BorderStyle = bsNone
    Size = 4
    TabOrder = 7
    Visible = False
    object PageControlProjects: TModernPageControl
      Left = 0
      Top = 0
      Width = 181
      Height = 539
      ActivePage = TSProjects
      Align = alClient
      NormalColor = clWhite
      FocusedColor = 15973017
      Images = ImgListMenus
      ShowCloseButton = False
      TabIndex = 0
      TabOrder = 0
      TabStop = True
      object TSProjects: TModernTabSheet
        Caption = 'Projects'
        ImageIndex = 1
        PageControl = PageControlProjects
        object TreeViewProjects: TTreeView
          Left = 0
          Top = 0
          Width = 175
          Height = 508
          Align = alClient
          BorderStyle = bsNone
          BorderWidth = 1
          DragMode = dmAutomatic
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          HideSelection = False
          Images = ImgListMenus
          Indent = 19
          ParentFont = False
          PopupMenu = PopupProject
          TabOrder = 0
          OnAddition = TreeViewProjectsAddition
          OnChange = TreeViewProjectsChange
          OnClick = TreeViewProjectsClick
          OnContextPopup = TreeViewProjectsContextPopup
          OnDblClick = TreeViewProjectsDblClick
          OnDragDrop = TreeViewProjectsDragDrop
          OnDragOver = TreeViewProjectsDragOver
          OnEdited = TreeViewProjectsEdited
          OnEnter = TreeViewProjectsEnter
          OnKeyDown = TreeViewProjectsKeyDown
          OnKeyPress = TreeViewProjectsKeyPress
        end
      end
    end
  end
  object PanelOutline: TSplitterPanel
    Left = 729
    Top = 51
    Width = 185
    Height = 539
    Align = alRight
    BorderStyle = bsNone
    Size = 4
    TabOrder = 8
    Visible = False
    object PageControlOutline: TModernPageControl
      Left = 4
      Top = 0
      Width = 181
      Height = 539
      ActivePage = TSOutline
      Align = alClient
      NormalColor = clWhite
      FocusedColor = 15973017
      Images = ImgListMenus
      ShowCloseButton = False
      TabIndex = 0
      TabOrder = 0
      TabStop = True
      object TSOutline: TModernTabSheet
        Caption = 'Outline'
        ImageIndex = 0
        PageControl = PageControlOutline
        object TreeViewOutline: TTreeView
          Left = 0
          Top = 0
          Width = 175
          Height = 508
          Align = alClient
          BorderStyle = bsNone
          BorderWidth = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          HideSelection = False
          Images = ImgListOutLine
          Indent = 27
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          OnAdvancedCustomDrawItem = TreeViewOutlineAdvancedCustomDrawItem
          OnDblClick = TreeViewOutlineDblClick
        end
      end
    end
  end
  object XPManifest: TXPManifest
    Left = 186
    Top = 112
  end
  object CppHighligher: TSynCppSyn
    CommentAttri.Foreground = clGreen
    DirecAttri.Foreground = clTeal
    NumberAttri.Foreground = clGreen
    FloatAttri.Foreground = clGreen
    HexAttri.Foreground = clGreen
    OctalAttri.Foreground = clGreen
    StringAttri.Foreground = clBlue
    CharAttri.Foreground = 33023
    SymbolAttri.Foreground = clMaroon
    Left = 458
    Top = 272
  end
  object OpenDlg: TOpenDialog
    Filter = 
      'All know files|*.fpj; *.dev; *.cbp; *.vcproj; *.c; *.cc; *.cpp; ' +
      '*.cxx; *.c++; *.cp; *.h; *.hpp; *.rh; *.hh; *.rc|Falcon C++ proj' +
      'ect (*.fpj)|*.fpj|Dev-C++ project(*.dev)|*.dev|Code::Blocks proj' +
      'ect(*.cbp)|*.cbp|MS Visual C++ project(*.vcproj)|*.vcproj|C sour' +
      'ce file (*.c)|*.c; *.cc|C++ source files (*.cpp, *.cc, *.cxx, *.' +
      'c++, *.cp)|*.cpp; *.cxx; *.c++; *.cp|Header file (*.h, *.hpp, *.' +
      'rh, *.hh)|*.h; *.hpp; *.rh; *.hh|Resource File (*.rc)|*.rc|All f' +
      'iles|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 123
    Top = 49
  end
  object ResourceHighlighter: TSynRCSyn
    CommentAttri.Foreground = clGreen
    NumberAttri.Foreground = clGreen
    StringAttri.Foreground = clBlue
    SymbolAttri.Foreground = clMaroon
    Left = 492
    Top = 272
  end
  object SendData: TSendData
    ClassNamed = 'TFrmFalconMain'
    SendType = stSend
    OnReceivedStream = SendDataReceivedStream
    OnCopyData = SendDataCopyData
    Left = 107
    Top = 156
  end
  object CompilerCmd: TOutputConsole
    OnStart = CompilerCmdStart
    OnFinish = CompilerCmdFinish
    ConvertOemToAnsi = False
    Left = 435
    Top = 521
  end
  object CodeCompletion: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    ClTitleBackground = clBtnHighlight
    Width = 450
    EndOfTokenChr = '{}()[]<>.,; :=+-*/%?|~&!^'
    TriggerChars = '.>:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        BiggestWord = 'preprocessor'
      end>
    Images = ImgListOutLine
    OnExecute = CodeCompletionExecute
    ShortCut = 0
    TimerInterval = 300
    OnAfterCodeCompletion = CodeCompletionAfterCodeCompletion
    OnCodeCompletion = CodeCompletionCodeCompletion
    Left = 610
    Top = 272
  end
  object TimerStartUpdate: TTimer
    Interval = 10000
    OnTimer = TimerStartUpdateTimer
    Left = 139
    Top = 209
  end
  object UpdateDownload: TFileDownload
    OnFinish = UpdateDownloadFinish
    Left = 171
    Top = 209
  end
  object SplashScreen: TSplashScreen
    PNGResName = 'IMGLOGO'
    WaitTime = 1500
    TimeOut = 0
    TimeIn = 200
    DelayTextOut = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TransparentColor = clFuchsia
    Left = 147
    Top = 116
  end
  object FrmPos: TFormPosition
    FileName = 'FormPosition.ini'
    Left = 75
    Top = 153
  end
  object ImgListOutLine: TImageList
    Width = 24
    Left = 810
    Top = 152
  end
  object TBXSwitcher: TTBXSwitcher
    Theme = 'Default'
    Left = 107
    Top = 113
  end
  object PopupProject: TTBXPopupMenu
    Images = ImgListMenus
    OwnerDraw = True
    Left = 75
    Top = 112
    object PopProjNew: TTBXSubmenuItem
      Caption = '&New'
      ImageIndex = 6
      LinkSubitems = FileNew
    end
    object TBXSeparatorItem23: TTBXSeparatorItem
    end
    object PopProjEdit: TTBXItem
      Caption = 'Edit'
      ShortCut = 13
      OnClick = EditFileClick
    end
    object PopProjOpen: TTBXItem
      Caption = 'Open'
      ImageIndex = 9
      OnClick = PopProjOpenClick
    end
    object TBXSeparatorItem24: TTBXSeparatorItem
    end
    object PopProjAdd: TTBXItem
      Caption = 'Add to project'
      OnClick = ProjectAddClick
    end
    object PopProjRemove: TTBXItem
      Caption = 'Remove'
      ImageIndex = 12
      ShortCut = 46
      OnClick = RemoveClick
    end
    object PopProjRename: TTBXItem
      Caption = 'Rename'
      ShortCut = 113
      OnClick = PopProjRenameClick
    end
    object PopProjDelFromDsk: TTBXItem
      Caption = 'Delete from disk'
      ShortCut = 8238
      OnClick = PopProjDelFromDskClick
    end
    object TBXSeparatorItem25: TTBXSeparatorItem
    end
    object PopProjProp: TTBXItem
      Caption = 'Property...'
      ImageIndex = 20
      ShortCut = 32781
      OnClick = ProjectPropertiesClick
    end
  end
  object PopupEditor: TTBXPopupMenu
    Images = ImgListMenus
    OwnerDraw = True
    Left = 299
    Top = 272
    object PopEditorFindDecl: TTBXItem
      Caption = 'Open declaration'
      OnClick = PopEditorFindDeclClick
    end
    object TBXSeparatorItem44: TTBXSeparatorItem
    end
    object PopEditorCompClass: TTBXItem
      Caption = 'Complete class at cursor'
      ShortCut = 24643
    end
    object PopEditorSwap: TTBXItem
      Caption = 'Swap header/source'
      OnClick = EditSwapClick
    end
    object TBXSeparatorItem8: TTBXSeparatorItem
    end
    object PopEditorUndo: TTBXItem
      Caption = 'Undo'
      ImageIndex = 18
      OnClick = SubMUndoClick
    end
    object PopEditorRedo: TTBXItem
      Caption = 'Redo'
      ImageIndex = 19
      OnClick = SubMRedoClick
    end
    object TBXSeparatorItem28: TTBXSeparatorItem
    end
    object PopEditorCut: TTBXItem
      Caption = 'Cut'
      ImageIndex = 15
      OnClick = SubMCutClick
    end
    object PopEditorCopy: TTBXItem
      Caption = 'Copy'
      ImageIndex = 16
      OnClick = SubMCopyClick
    end
    object PopEditorPaste: TTBXItem
      Caption = 'Paste'
      ImageIndex = 17
      OnClick = SubMPasteClick
    end
    object PopEditorDelete: TTBXItem
      Caption = 'Delete'
      ImageIndex = 12
      OnClick = PopEditorDeleteClick
    end
    object PopEditorSelectAll: TTBXItem
      Caption = 'Select All'
      ImageIndex = 45
      OnClick = SubMSelectAllClick
    end
    object TBXSeparatorItem27: TTBXSeparatorItem
    end
    object PopEditorTools: TTBXSubmenuItem
      Caption = 'Tools'
    end
    object TBXSeparatorItem26: TTBXSeparatorItem
    end
    object EditorBookmarks: TTBXSubmenuItem
      Caption = 'Toggle Bookmarks'
      ImageIndex = 53
      LinkSubitems = EditBookmarks
    end
    object EditorGotoBookmarks: TTBXSubmenuItem
      Caption = 'Goto Bookmarks'
      ImageIndex = 52
      LinkSubitems = EditGotoBookmarks
    end
    object TBXSeparatorItem34: TTBXSeparatorItem
    end
    object PopEditorProperties: TTBXItem
      Caption = 'Properties...'
      ImageIndex = 20
      OnClick = ProjectPropertiesClick
    end
  end
  object PopupMsg: TTBXPopupMenu
    Images = ImgListMenus
    Left = 467
    Top = 519
    object PupMsgCopy: TTBXItem
      Caption = 'Copy'
      ImageIndex = 16
      ShortCut = 16451
      OnClick = Copiar1Click
    end
    object PupMsgCopyOri: TTBXItem
      Caption = 'Copy original message'
      ShortCut = 24643
      OnClick = Copyoriginalmessage1Click
    end
    object TBXSeparatorItem32: TTBXSeparatorItem
    end
    object PupMsgOriMsg: TTBXItem
      Caption = 'Original message'
      OnClick = Originalmessage1Click
    end
    object TBXSeparatorItem31: TTBXSeparatorItem
    end
    object PupMsgGotoLine: TTBXItem
      Caption = 'Goto line'
      ImageIndex = 36
      OnClick = PupMsgGotoLineClick
    end
    object PupMsgClear: TTBXItem
      Caption = 'Clear'
      OnClick = PupMsgClearClick
    end
  end
  object TimerChangeDelay: TTimer
    Enabled = False
    Interval = 250
    OnTimer = TimerChangeDelayTimer
    Left = 340
    Top = 272
  end
  object ImgListMenus: TTBImageList
    DisabledImages = DisImgListMenus
    Left = 699
    Top = 4
  end
  object DisImgListMenus: TTBImageList
    Left = 731
    Top = 4
  end
  object EditorSearch: TSynEditSearch
    Left = 545
    Top = 272
  end
  object TimerHintTipEvent: TTimer
    Enabled = False
    Interval = 300
    OnTimer = TimerHintTipEventTimer
    Left = 408
    Top = 272
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = ApplicationEventsActivate
    OnDeactivate = ApplicationEventsDeactivate
    OnMessage = ApplicationEventsMessage
    Left = 107
    Top = 215
  end
  object TimerHintParams: TTimer
    Enabled = False
    Interval = 300
    OnTimer = TimerHintParamsTimer
    Left = 374
    Top = 272
  end
  object EditorPrint: TSynEditPrint
    Copies = 1
    Header.DefaultFont.Charset = DEFAULT_CHARSET
    Header.DefaultFont.Color = clBlack
    Header.DefaultFont.Height = -13
    Header.DefaultFont.Name = 'Arial'
    Header.DefaultFont.Style = []
    Footer.DefaultFont.Charset = DEFAULT_CHARSET
    Footer.DefaultFont.Color = clBlack
    Footer.DefaultFont.Height = -13
    Footer.DefaultFont.Name = 'Arial'
    Footer.DefaultFont.Style = []
    Margins.Left = 5.000000000000000000
    Margins.Right = 5.000000000000000000
    Margins.Top = 10.000000000000000000
    Margins.Bottom = 10.000000000000000000
    Margins.Header = 9.000000000000000000
    Margins.Footer = 9.000000000000000000
    Margins.LeftHFTextIndent = 0.500000000000000000
    Margins.RightHFTextIndent = 0.500000000000000000
    Margins.HFInternalMargin = 1.000000000000000000
    Margins.MirrorMargins = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Colors = True
    TabWidth = 4
    Color = clWhite
    Left = 76
    Top = 243
  end
  object PrintDialog: TPrintDialog
    Left = 75
    Top = 215
  end
  object EditorRegexSearch: TSynEditRegexSearch
    Left = 577
    Top = 272
  end
  object ExporterHTML: TSynExporterHTML
    Color = clWindow
    DefaultFilter = 'HTML Documents (*.htm;*.html)|*.htm;*.html'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Title = 'Untitled'
    UseBackground = True
    Left = 43
    Top = 215
  end
  object ExporterRTF: TSynExporterRTF
    Color = clWindow
    DefaultFilter = 'Rich Text Format Documents (*.rtf)|*.rtf'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Title = 'Untitled'
    UseBackground = True
    Left = 43
    Top = 247
  end
  object ExporterTeX: TSynExporterTeX
    Color = clWindow
    DefaultFilter = 'TeX Files (*.tex)|*.tex'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Title = 'Untitled'
    UseBackground = True
    Left = 43
    Top = 279
  end
  object PopupTabs: TTBXPopupMenu
    Images = ImgListMenus
    OwnerDraw = True
    OnPopup = PopupTabsPopup
    Left = 316
    Top = 67
    object PopTabsClose: TTBXItem
      Caption = 'Close'
      OnClick = FileCloseClick
    end
    object PopTabsCloseAll: TTBXItem
      Caption = 'Close all'
      OnClick = FileCloseAllClick
    end
    object PopTabsCloseAllOthers: TTBXItem
      Caption = 'Close all others'
      Enabled = False
      OnClick = PopTabsCloseAllOthersClick
    end
    object TBXSeparatorItem35: TTBXSeparatorItem
    end
    object PopTabsSave: TTBXItem
      Caption = 'Save'
      Enabled = False
      ImageIndex = 10
      OnClick = FileSaveClick
    end
    object PopTabsSaveAll: TTBXItem
      Caption = 'Save all'
      Enabled = False
      ImageIndex = 11
      OnClick = FileSaveAllClick
    end
    object TBXSeparatorItem39: TTBXSeparatorItem
    end
    object PopTabsSwap: TTBXItem
      Caption = 'Swap header/source'
      OnClick = EditSwapClick
    end
    object TBXSeparatorItem40: TTBXSeparatorItem
    end
    object PopTabsTabsAtTop: TTBXItem
      Caption = 'Tabs at top'
      OnClick = PopTabsTabsAtTopClick
    end
    object PopTabsTabsAtBottom: TTBXItem
      Caption = 'Tabs at bottom'
      OnClick = PopTabsTabsAtBottomClick
    end
    object TBXSeparatorItem41: TTBXSeparatorItem
    end
    object PopTabsProperties: TTBXItem
      Caption = 'Properties...'
      ImageIndex = 20
      OnClick = ProjectPropertiesClick
    end
  end
  object ImageListGutter: TImageList
    Left = 300
    Top = 243
  end
  object ImgListCountry: TImageList
    Height = 11
    Left = 76
    Top = 282
  end
  object ImageListDebug: TImageList
    Left = 340
    Top = 243
  end
end
