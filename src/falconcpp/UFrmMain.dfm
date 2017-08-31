object FrmFalconMain: TFrmFalconMain
  Left = 256
  Top = 230
  Caption = 'Falcon C++'
  ClientHeight = 617
  ClientWidth = 906
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DockTop: TSpTBXDock
    Tag = 1
    Left = 0
    Top = 26
    Width = 906
    Height = 27
    BoundLines = [blTop]
    Color = clBtnFace
    object DefaultBar: TSpTBXToolbar
      Left = 0
      Top = 0
      DefaultDock = DockTop
      DockPos = 0
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClose = ToolbarClose
      Caption = 'Default Bar'
      object BtnNew: TSpTBXSubmenuItem
        Caption = 'New'
        ImageIndex = 6
        OnClick = FileNewItemClick
        DropdownCombo = True
        LinkSubitems = FileNew
      end
      object BtnOpen: TSpTBXItem
        Caption = 'Open'
        ImageIndex = 9
        ShortCut = 16463
        OnClick = FileOpenClick
      end
      object BtnRemove: TSpTBXItem
        Caption = 'Remove'
        Enabled = False
        ImageIndex = 12
        OnClick = FileRemoveClick
      end
      object SpTBXSeparatorItem1: TSpTBXSeparatorItem
      end
      object BtnSave: TSpTBXItem
        Caption = 'Save'
        Enabled = False
        ImageIndex = 10
        ShortCut = 16467
        OnClick = FileSaveClick
      end
      object BtnSaveAll: TSpTBXItem
        Caption = 'Save All'
        Enabled = False
        ImageIndex = 11
        ShortCut = 24659
        OnClick = FileSaveAllClick
      end
    end
    object EditBar: TSpTBXToolbar
      Tag = 1
      Left = 144
      Top = 0
      DefaultDock = DockTop
      DockPos = 128
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClose = ToolbarClose
      Caption = 'Edit Bar'
      object BtnUndo: TSpTBXItem
        Caption = 'Undo'
        Enabled = False
        ImageIndex = 18
        ShortCut = 16474
        OnClick = EditUndoClick
      end
      object BtnRedo: TSpTBXItem
        Caption = 'Redo'
        Enabled = False
        ImageIndex = 19
        ShortCut = 16473
        OnClick = EditRedoClick
      end
    end
    object NavigatorBar: TSpTBXToolbar
      Tag = 4
      Left = 393
      Top = 0
      DefaultDock = DockTop
      DockPos = 179
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ProcessShortCuts = True
      ShowHint = True
      TabOrder = 2
      OnClose = ToolbarClose
      Caption = 'Navigator Bar'
      object BtnPrevPage: TSpTBXItem
        Caption = 'Previous Page'
        Enabled = False
        ImageIndex = 13
        OnClick = BtnPreviousPageClick
      end
      object BtnNextPage: TSpTBXItem
        Caption = 'Next Page'
        Enabled = False
        ImageIndex = 14
        OnClick = BtnNextPageClick
      end
      object SpTBXSeparatorItem33: TSpTBXSeparatorItem
      end
      object BtnToggleBook: TSpTBXSubmenuItem
        Caption = 'Toggle Bookmarks'
        Enabled = False
        ImageIndex = 53
        LinkSubitems = EditBookmarks
      end
      object BtnGotoBook: TSpTBXSubmenuItem
        Caption = 'Goto Bookmarks'
        Enabled = False
        ImageIndex = 52
        LinkSubitems = EditGotoBookmarks
      end
    end
    object CompilerBar: TSpTBXToolbar
      Tag = 3
      Left = 285
      Top = 0
      DefaultDock = DockTop
      DockPos = 179
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClose = ToolbarClose
      Caption = 'Compiler Bar'
      object BtnRun: TSpTBXItem
        Caption = 'Run'
        Enabled = False
        ImageIndex = 23
        ShortCut = 120
        OnClick = RunRunClick
      end
      object BtnCompile: TSpTBXItem
        Caption = 'Compile'
        Enabled = False
        ImageIndex = 25
        ShortCut = 16504
        OnClick = RunCompileClick
      end
      object BtnExecute: TSpTBXItem
        Caption = 'Execute'
        Enabled = False
        ImageIndex = 26
        ShortCut = 116
        OnClick = RunExecuteClick
      end
      object SpTBXSeparatorItem9: TSpTBXSeparatorItem
      end
      object BtnStop: TSpTBXItem
        Caption = 'Stop'
        Enabled = False
        ImageIndex = 24
        ShortCut = 16497
        OnClick = RunStopClick
      end
    end
    object ProjectBar: TSpTBXToolbar
      Tag = 5
      Left = 501
      Top = 0
      DefaultDock = DockTop
      DockPos = 395
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClose = ToolbarClose
      Caption = 'Project Bar'
      object BtnNewProj: TSpTBXItem
        Tag = 1
        Caption = 'New Project'
        ImageIndex = 1
        OnClick = FileNewItemClick
      end
      object BtnProperties: TSpTBXItem
        Caption = 'Properties'
        Enabled = False
        ImageIndex = 20
        ShortCut = 32781
        OnClick = ProjectPropertiesClick
      end
    end
    object HelpBar: TSpTBXToolbar
      Tag = 6
      Left = 557
      Top = 0
      DefaultDock = DockTop
      DockPos = 447
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClose = ToolbarClose
      Caption = 'Help Bar'
      object BtnHelp: TSpTBXItem
        Caption = 'Help'
        ImageIndex = 30
        ShortCut = 112
        OnClick = BtnHelpClick
      end
      object BtnContxHelp: TSpTBXItem
        Caption = 'Context Help'
        Enabled = False
        ImageIndex = 21
      end
    end
    object DebugBar: TSpTBXToolbar
      Tag = 7
      Left = 613
      Top = 0
      DefaultDock = DockTop
      DockPos = 467
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClose = ToolbarClose
      Caption = 'Debug Bar'
      object BtnStepInto: TSpTBXItem
        Caption = 'Step Into'
        Enabled = False
        ImageIndex = 46
        ShortCut = 118
        OnClick = RunStepIntoClick
      end
      object BtnStepOver: TSpTBXItem
        Caption = 'Step Over'
        Enabled = False
        ImageIndex = 54
        ShortCut = 119
        OnClick = RunStepOverClick
      end
      object BtnStepReturn: TSpTBXItem
        Caption = 'Step Return'
        Enabled = False
        ImageIndex = 55
        ShortCut = 117
        OnClick = RunStepReturnClick
      end
    end
    object SearchBar: TSpTBXToolbar
      Tag = 2
      Left = 200
      Top = 0
      DefaultDock = DockTop
      DockPos = 179
      DockRow = 1
      Images = ImgListMenus
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClose = ToolbarClose
      Caption = 'Search Bar'
      object BtnFind: TSpTBXItem
        Caption = 'Find'
        Enabled = False
        ImageIndex = 37
        ShortCut = 16454
        OnClick = SearchFindClick
      end
      object BtnReplace: TSpTBXItem
        Caption = 'Replace'
        Enabled = False
        ImageIndex = 48
        ShortCut = 16466
        OnClick = SearchReplaceClick
      end
      object SpTBXSeparatorItem29: TSpTBXSeparatorItem
      end
      object BtnGotoLN: TSpTBXItem
        Caption = 'Goto Line Number'
        Enabled = False
        ImageIndex = 36
        ShortCut = 16455
      end
    end
  end
  object MenuDock: TSpTBXDock
    Left = 0
    Top = 0
    Width = 906
    Height = 26
    AllowDrag = False
    BoundLines = [blBottom]
    Color = clBtnFace
    object MenuBar: TSpTBXToolbar
      Left = 0
      Top = 0
      ActivateParent = False
      CloseButton = False
      DockMode = dmCannotFloatOrChangeDocks
      DockPos = 0
      DragHandleStyle = dhNone
      FullSize = True
      Images = ImgListMenus
      Options = [tboDefault]
      ProcessShortCuts = True
      ShrinkMode = tbsmWrap
      TabOrder = 0
      OnMouseDown = MenuBarMouseDown
      Caption = 'Menu Bar'
      Customizable = False
      MenuBar = True
      object MenuFile: TSpTBXSubmenuItem
        Caption = '&File'
        object FileNew: TSpTBXSubmenuItem
          Caption = '&New'
          ImageIndex = 6
          object FileNewProject: TSpTBXItem
            Tag = 1
            Caption = '&Project...'
            ImageIndex = 1
            OnClick = FileNewItemClick
          end
          object FileNewC: TSpTBXItem
            Tag = 2
            Caption = 'C File'
            ImageIndex = 2
            OnClick = FileNewItemClick
          end
          object FileNewCpp: TSpTBXItem
            Tag = 3
            Caption = 'C++ File'
            ImageIndex = 3
            ShortCut = 16462
            OnClick = FileNewItemClick
          end
          object FileNewHeader: TSpTBXItem
            Tag = 4
            Caption = 'Header File'
            ImageIndex = 4
            OnClick = FileNewItemClick
          end
          object FileNewResource: TSpTBXItem
            Tag = 5
            Caption = 'Resource File'
            ImageIndex = 5
            OnClick = FileNewItemClick
          end
          object FileNewEmpty: TSpTBXItem
            Tag = 6
            Caption = 'Empty File'
            ImageIndex = 6
            OnClick = FileNewItemClick
          end
          object SpTBXSeparatorItem3: TSpTBXSeparatorItem
          end
          object FileNewFolder: TSpTBXItem
            Tag = 7
            Caption = 'Folder'
            Enabled = False
            ImageIndex = 7
            OnClick = FileNewItemClick
          end
          object FileNewConfig: TSpTBXItem
            Tag = 8
            Caption = 'Configuration'
            Enabled = False
            ImageIndex = 26
            OnClick = FileNewItemClick
          end
        end
        object FileOpen: TSpTBXItem
          Caption = '&Open'
          ImageIndex = 9
          ShortCut = 16463
          OnClick = FileOpenClick
        end
        object FileReopen: TSpTBXSubmenuItem
          Caption = '&Reopen'
          object FileReopenClear: TSpTBXItem
            Caption = '(None)'
            Enabled = False
            OnClick = ClearHistoryClick
          end
        end
        object SpTBXSeparatorItem4: TSpTBXSeparatorItem
        end
        object FileSave: TSpTBXItem
          Caption = '&Save'
          Enabled = False
          ImageIndex = 10
          ShortCut = 16467
          OnClick = FileSaveClick
        end
        object FileSaveAs: TSpTBXItem
          Caption = 'Save &As...'
          Enabled = False
          OnClick = FileSaveAsClick
        end
        object FileSaveAll: TSpTBXItem
          Caption = 'Save All'
          Enabled = False
          ImageIndex = 11
          ShortCut = 24659
          OnClick = FileSaveAllClick
        end
        object SpTBXSeparatorItem22: TSpTBXSeparatorItem
        end
        object FileImport: TSpTBXSubmenuItem
          Caption = 'Import'
          object FileImpDevCpp: TSpTBXItem
            Caption = 'Dev-C++ Project'
            OnClick = ImportFromDevCpp
          end
          object FileImpCodeBlocks: TSpTBXItem
            Caption = 'Code::Blocks Project'
            OnClick = ImportFromCodeBlocks
          end
          object FileImpMSVC: TSpTBXItem
            Caption = 'MS Visual C++ Project'
            OnClick = ImportFromMSVC
          end
        end
        object FileExport: TSpTBXSubmenuItem
          Caption = 'Export'
          Enabled = False
          object FileExportHTML: TSpTBXItem
            Caption = 'to HTML'
            OnClick = FileExportHTMLClick
          end
          object FileExportRTF: TSpTBXItem
            Caption = 'to RTF'
            OnClick = FileExportRTFClick
          end
          object FileExportTeX: TSpTBXItem
            Caption = 'to TeX'
            OnClick = FileExportTeXClick
          end
        end
        object SpTBXSeparatorItem15: TSpTBXSeparatorItem
        end
        object FileClose: TSpTBXItem
          Caption = '&Close'
          Enabled = False
          ShortCut = 16471
          OnClick = FileCloseClick
        end
        object FileCloseAll: TSpTBXItem
          Caption = 'C&lose All'
          Enabled = False
          ShortCut = 24663
          OnClick = FileCloseAllClick
        end
        object FileRemove: TSpTBXItem
          Caption = 'Remove'
          Enabled = False
          OnClick = FileRemoveClick
        end
        object SpTBXSeparatorItem6: TSpTBXSeparatorItem
        end
        object FilePrint: TSpTBXItem
          Caption = '&Print'
          Enabled = False
          ShortCut = 16464
          OnClick = FilePrintClick
        end
        object SpTBXSeparatorItem38: TSpTBXSeparatorItem
        end
        object FileExit: TSpTBXItem
          Caption = '&Exit'
          ImageIndex = 29
          OnClick = FileExitClick
        end
      end
      object MenuEdit: TSpTBXSubmenuItem
        Caption = '&Edit'
        object EditUndo: TSpTBXItem
          Caption = 'Undo'
          Enabled = False
          ImageIndex = 18
          ShortCut = 16474
          OnClick = EditUndoClick
        end
        object EditRedo: TSpTBXItem
          Caption = 'Redo'
          Enabled = False
          ImageIndex = 19
          ShortCut = 16473
          OnClick = EditRedoClick
        end
        object SpTBXSeparatorItem7: TSpTBXSeparatorItem
        end
        object EditCut: TSpTBXItem
          Caption = 'Cut'
          Enabled = False
          ImageIndex = 15
          ShortCut = 16472
          OnClick = EditCutClick
        end
        object EditCopy: TSpTBXItem
          Caption = 'Copy'
          Enabled = False
          ImageIndex = 16
          ShortCut = 16451
          OnClick = EditCopyClick
        end
        object EditPaste: TSpTBXItem
          Caption = 'Paste'
          Enabled = False
          ImageIndex = 17
          ShortCut = 16470
          OnClick = EditPasteClick
        end
        object SpTBXSeparatorItem5: TSpTBXSeparatorItem
        end
        object EditSwap: TSpTBXItem
          Caption = 'Swap header/source'
          Enabled = False
          ShortCut = 122
          OnClick = EditSwapClick
        end
        object SpTBXSeparatorItem42: TSpTBXSeparatorItem
        end
        object EditDelete: TSpTBXItem
          Caption = 'Delete'
          Enabled = False
          ImageIndex = 12
          ShortCut = 46
          OnClick = EditDeleteClick
        end
        object EditSelectAll: TSpTBXItem
          Caption = 'Select All'
          Enabled = False
          ImageIndex = 45
          ShortCut = 16449
          OnClick = EditSelectAllClick
        end
        object SpTBXSeparatorItem36: TSpTBXSeparatorItem
        end
        object EditBookmarks: TSpTBXSubmenuItem
          Caption = 'Toggle Bookmarks'
          Enabled = False
          ImageIndex = 53
          object SpTBXItem35: TSpTBXItem
            Tag = 1
            Caption = 'Bookmark &1'
            AutoCheck = True
            ShortCut = 16433
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem36: TSpTBXItem
            Tag = 2
            Caption = 'Bookmark &2'
            AutoCheck = True
            ShortCut = 16434
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem37: TSpTBXItem
            Tag = 3
            Caption = 'Bookmark &3'
            AutoCheck = True
            ShortCut = 16435
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem38: TSpTBXItem
            Tag = 4
            Caption = 'Bookmark &4'
            AutoCheck = True
            ShortCut = 16436
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem44: TSpTBXItem
            Tag = 5
            Caption = 'Bookmark &5'
            AutoCheck = True
            ShortCut = 16437
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem45: TSpTBXItem
            Tag = 6
            Caption = 'Bookmark &6'
            AutoCheck = True
            ShortCut = 16438
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem46: TSpTBXItem
            Tag = 7
            Caption = 'Bookmark &7'
            AutoCheck = True
            ShortCut = 16439
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem47: TSpTBXItem
            Tag = 8
            Caption = 'Bookmark &8'
            AutoCheck = True
            ShortCut = 16440
            OnClick = ToggleBookmarksClick
          end
          object SpTBXItem50: TSpTBXItem
            Tag = 9
            Caption = 'Bookmark &9'
            AutoCheck = True
            ShortCut = 16441
            OnClick = ToggleBookmarksClick
          end
        end
        object EditGotoBookmarks: TSpTBXSubmenuItem
          Caption = 'Goto Bookmarks'
          Enabled = False
          ImageIndex = 52
          object SpTBXItem58: TSpTBXItem
            Tag = 1
            Caption = 'Bookmark &1'
            ShortCut = 32817
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem62: TSpTBXItem
            Tag = 2
            Caption = 'Bookmark &2'
            ShortCut = 32818
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem65: TSpTBXItem
            Tag = 3
            Caption = 'Bookmark &3'
            ShortCut = 32819
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem66: TSpTBXItem
            Tag = 4
            Caption = 'Bookmark &4'
            ShortCut = 32820
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem71: TSpTBXItem
            Tag = 5
            Caption = 'Bookmark &5'
            ShortCut = 32821
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem74: TSpTBXItem
            Tag = 6
            Caption = 'Bookmark &6'
            ShortCut = 32822
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem75: TSpTBXItem
            Tag = 7
            Caption = 'Bookmark &7'
            ShortCut = 32823
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem76: TSpTBXItem
            Tag = 8
            Caption = 'Bookmark &8'
            ShortCut = 32824
            OnClick = GotoBookmarkClick
          end
          object SpTBXItem78: TSpTBXItem
            Tag = 9
            Caption = 'Bookmark &9'
            ShortCut = 32825
            OnClick = GotoBookmarkClick
          end
        end
        object SpTBXSeparatorItem37: TSpTBXSeparatorItem
        end
        object EditIndent: TSpTBXItem
          Caption = 'Indent'
          Enabled = False
          ShortCut = 24649
          OnClick = EditIndentClick
        end
        object EditUnindent: TSpTBXItem
          Caption = 'Unindent'
          Enabled = False
          ShortCut = 24661
          OnClick = EditUnindentClick
        end
        object SpTBXSeparatorItem30: TSpTBXSeparatorItem
        end
        object EditToggleComment: TSpTBXItem
          Caption = 'Toggle Line Comment'
          Enabled = False
          ShortCut = 16577
          OnClick = EditToggleCommentClick
        end
        object SpTBXSeparatorItem43: TSpTBXSeparatorItem
        end
        object EditFormat: TSpTBXItem
          Caption = 'Format'
          Enabled = False
          ShortCut = 24646
          OnClick = EditFormatClick
        end
        object SpTBXSeparatorItem45: TSpTBXSeparatorItem
        end
        object EditCollapseAll: TSpTBXItem
          Caption = 'Collapse All'
          Enabled = False
          OnClick = EditCollapseAllClick
        end
        object EditUncollapseAll: TSpTBXItem
          Caption = 'Uncollapse All'
          Enabled = False
          OnClick = EditUncollapseAllClick
        end
      end
      object MenuSearch: TSpTBXSubmenuItem
        Caption = '&Search'
        object SearchFind: TSpTBXItem
          Caption = 'Find...'
          Enabled = False
          ImageIndex = 37
          ShortCut = 16454
          OnClick = SearchFindClick
        end
        object SearchFindNext: TSpTBXItem
          Caption = 'Find Next'
          Enabled = False
          ShortCut = 114
          OnClick = SearchFindNextClick
        end
        object SearchFindPrev: TSpTBXItem
          Caption = 'Find Previous'
          Enabled = False
          ShortCut = 8306
          OnClick = SearchFindPrevClick
        end
        object SearchFindFiles: TSpTBXItem
          Caption = 'Find in Files...'
          Enabled = False
          ShortCut = 16456
          OnClick = SearchFindFilesClick
        end
        object SearchReplace: TSpTBXItem
          Caption = 'Replace...'
          Enabled = False
          ImageIndex = 48
          ShortCut = 16466
          OnClick = SearchReplaceClick
        end
        object SearchIncremental: TSpTBXItem
          Caption = 'Incremental Search...'
          Enabled = False
          ShortCut = 16460
        end
        object SpTBXSeparatorItem16: TSpTBXSeparatorItem
        end
        object SearchGotoFunction: TSpTBXItem
          Caption = 'Goto Funcion...'
          Enabled = False
          ShortCut = 24647
          OnClick = SearchGotoFunctionClick
        end
        object SearchGotoPrevFunc: TSpTBXItem
          Caption = 'Goto Previous Function'
          Enabled = False
          OnClick = SearchGotoPrevFuncClick
        end
        object SearchGotoNextFunc: TSpTBXItem
          Caption = 'Goto Next Function'
          Enabled = False
          OnClick = SearchGotoNextFuncClick
        end
        object SearchGotoLine: TSpTBXItem
          Caption = 'Goto Line Number...'
          Enabled = False
          ImageIndex = 36
          ShortCut = 16455
          OnClick = SearchGotoLineClick
        end
      end
      object MenuView: TSpTBXSubmenuItem
        Caption = '&View'
        object ViewProjMan: TSpTBXItem
          Caption = 'Project Manager'
          AutoCheck = True
          Checked = True
          OnClick = ViewItemClick
        end
        object ViewStatusBar: TSpTBXItem
          Tag = 1
          Caption = 'Statusbar'
          AutoCheck = True
          Checked = True
          OnClick = ViewItemClick
        end
        object ViewOutline: TSpTBXItem
          Tag = 2
          Caption = 'Outline'
          AutoCheck = True
          Checked = True
          OnClick = ViewItemClick
        end
        object ViewCompOut: TSpTBXItem
          Caption = 'Compiler Output'
          OnClick = ViewCompOutClick
        end
        object ViewToolbar: TSpTBXSubmenuItem
          Caption = 'Toolbars'
          object ViewToolbarDefault: TSpTBXItem
            Caption = 'Default Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarEdit: TSpTBXItem
            Tag = 1
            Caption = 'Edit Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarSearch: TSpTBXItem
            Tag = 2
            Caption = 'Search Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarCompiler: TSpTBXItem
            Tag = 3
            Caption = 'Compiler Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarNavigator: TSpTBXItem
            Tag = 4
            Caption = 'Navigator Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarProject: TSpTBXItem
            Tag = 5
            Caption = 'Project Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarHelp: TSpTBXItem
            Tag = 6
            Caption = 'Help Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
          object ViewToolbarDebug: TSpTBXItem
            Tag = 7
            Caption = 'Debug Bar'
            AutoCheck = True
            Checked = True
            OnClick = TViewToolbarClick
          end
        end
        object ViewThemes: TSpTBXSubmenuItem
          Tag = 2
          Caption = 'Themes'
          object SpTBXSkinGroupItem1: TSpTBXSkinGroupItem
            OnSkinChange = SelectThemeClick
          end
        end
        object ViewZoom: TSpTBXSubmenuItem
          Tag = 2
          Caption = 'Zoom'
          object ViewZoomInc: TSpTBXItem
            Caption = 'Increase'
            GroupIndex = 1
            ImageIndex = 39
            OnClick = ViewZoomIncClick
          end
          object ViewZoomDec: TSpTBXItem
            Tag = 1
            Caption = 'Decrease'
            GroupIndex = 1
            ImageIndex = 38
            OnClick = ViewZoomDecClick
          end
        end
        object SpTBXSeparatorItem21: TSpTBXSeparatorItem
        end
        object ViewFullScreen: TSpTBXItem
          Caption = 'Full Screen'
          ShortCut = 123
          OnClick = ViewFullScreenClick
        end
        object SpTBXSeparatorItem20: TSpTBXSeparatorItem
        end
        object ViewRestoreDefault: TSpTBXItem
          Caption = 'Restore Default'
          OnClick = ViewRestoreDefClick
        end
      end
      object MenuProject: TSpTBXSubmenuItem
        Caption = '&Project'
        object ProjectAdd: TSpTBXItem
          Caption = 'Add'
          Enabled = False
          ImageIndex = 27
          OnClick = ProjectAddClick
        end
        object ProjectRemove: TSpTBXItem
          Caption = 'Remove'
          Enabled = False
          ImageIndex = 28
          OnClick = ProjectRemoveClick
        end
        object SpTBXSeparatorItem2: TSpTBXSeparatorItem
        end
        object ProjectBuild: TSpTBXItem
          Caption = 'Build'
          Enabled = False
          ImageIndex = 26
          OnClick = ProjectBuildClick
        end
        object SpTBXSeparatorItem10: TSpTBXSeparatorItem
        end
        object ProjectProperties: TSpTBXItem
          Caption = 'Properties'
          Enabled = False
          ImageIndex = 20
          ShortCut = 32781
          OnClick = ProjectPropertiesClick
        end
      end
      object MenuRun: TSpTBXSubmenuItem
        Caption = '&Run'
        object RunRun: TSpTBXItem
          Caption = 'Run'
          Enabled = False
          ImageIndex = 23
          ShortCut = 120
          OnClick = RunRunClick
        end
        object RunCompile: TSpTBXItem
          Caption = 'Compile'
          Enabled = False
          ImageIndex = 25
          ShortCut = 16504
          OnClick = RunCompileClick
        end
        object RunExecute: TSpTBXItem
          Caption = 'Execute'
          Enabled = False
          ImageIndex = 26
          ShortCut = 116
          OnClick = RunExecuteClick
        end
        object SpTBXSeparatorItem12: TSpTBXSeparatorItem
        end
        object RunToggleBreakpoint: TSpTBXItem
          Caption = 'Toggle Breakpoint'
          Enabled = False
          ShortCut = 16450
          OnClick = RunToggleBreakpointClick
        end
        object RunStepInto: TSpTBXItem
          Caption = 'Step Into'
          Enabled = False
          ImageIndex = 46
          ShortCut = 118
          OnClick = RunStepIntoClick
        end
        object RunStepOver: TSpTBXItem
          Caption = 'Step Over'
          Enabled = False
          ImageIndex = 54
          ShortCut = 119
          OnClick = RunStepOverClick
        end
        object RunStepReturn: TSpTBXItem
          Caption = 'Step Return'
          Enabled = False
          ImageIndex = 55
          ShortCut = 117
          OnClick = RunStepReturnClick
        end
        object RunRuntoCursor: TSpTBXItem
          Caption = 'Run to Cursor'
          Enabled = False
          ShortCut = 115
          OnClick = RunRuntoCursorClick
        end
        object RunStop: TSpTBXItem
          Caption = 'Stop'
          Enabled = False
          ImageIndex = 24
          ShortCut = 16497
          OnClick = RunStopClick
        end
      end
      object MenuTools: TSpTBXSubmenuItem
        Caption = '&Tools'
        object ToolsEnvOptions: TSpTBXItem
          Caption = 'Environment Options...'
          OnClick = ToolsEnvOptionsClick
        end
        object ToolsCompilerOptions: TSpTBXItem
          Caption = 'Compiler Options...'
          OnClick = ToolsCompilerOptionsClick
        end
        object ToolsEditorOptions: TSpTBXItem
          Caption = 'Editor Options...'
          OnClick = ToolsEditorOptionsClick
        end
        object SpTBXSeparatorItem18: TSpTBXSeparatorItem
        end
        object ToolsTemplate: TSpTBXItem
          Caption = 'Template Creator...'
          Enabled = False
        end
        object ToolsPackageCreator: TSpTBXItem
          Caption = 'Package Creator...'
          Enabled = False
        end
        object SpTBXSeparatorItem19: TSpTBXSeparatorItem
        end
        object ToolsPackages: TSpTBXItem
          Caption = 'Packages...'
          OnClick = ToolsPackagesClick
        end
      end
      object MenuHelp: TSpTBXSubmenuItem
        Caption = '&Help'
        object HelpFalcon: TSpTBXSubmenuItem
          Caption = 'Falcon Help'
          ImageIndex = 30
          object HelpFalconFalcon: TSpTBXItem
            Caption = 'Falcon C++'
            ImageIndex = 21
            OnClick = FalconHelpClick
          end
        end
        object HelpTipOfDay: TSpTBXItem
          Caption = 'Tip of the Day...'
          Enabled = False
        end
        object SpTBXSeparatorItem11: TSpTBXSeparatorItem
        end
        object HelpUpdate: TSpTBXItem
          Caption = 'Update...'
          ImageIndex = 47
          OnClick = SubMUpdateClick
        end
        object SpTBXSeparatorItem13: TSpTBXSeparatorItem
        end
        object HelpAbout: TSpTBXItem
          Caption = 'About...'
          OnClick = About1Click
        end
      end
    end
  end
  object DockBottom: TSpTBXDock
    Tag = 2
    Left = 0
    Top = 585
    Width = 906
    Height = 9
    Position = dpBottom
  end
  object DockLeft: TSpTBXDock
    Tag = 3
    Left = 185
    Top = 53
    Width = 9
    Height = 532
    Position = dpLeft
  end
  object DockRight: TSpTBXDock
    Tag = 4
    Left = 712
    Top = 53
    Width = 9
    Height = 532
    Position = dpRight
  end
  object PanelEditorMessages: TPanel
    Left = 194
    Top = 53
    Width = 518
    Height = 532
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PanelMessages: TSplitterPanel
      Left = 0
      Top = 385
      Width = 518
      Height = 147
      Align = alBottom
      BorderStyle = bsNone
      Size = 4
      TabOrder = 0
      Visible = False
      object PageControlMessages: TModernPageControl
        Left = 0
        Top = 4
        Width = 518
        Height = 143
        ActivePage = TSMessages
        Align = alClient
        NormalColor = clWhite
        FocusedColor = 15973017
        ParentColor = False
        TabIndex = 0
        TabOrder = 0
        TabStop = True
        FixedTabWidth = True
        OnClose = PageControlMsgClose
        object TSMessages: TModernTabSheet
          Color = 16185078
          Caption = 'Messages'
          ImageIndex = 0
          PageControl = PageControlMessages
          object ListViewMsg: TListView
            Left = 0
            Top = 0
            Width = 512
            Height = 112
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
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
    object PageControlEditor: TModernPageControl
      Left = 0
      Top = 0
      Width = 518
      Height = 385
      Align = alClient
      CanDragTabs = True
      NormalColor = clWhite
      FocusedColor = 15973017
      Images = ImgListMenus
      ParentColor = False
      PopupMenu = PopupTabs
      TabIndex = -1
      TabOrder = 1
      TabStop = True
      FixedTabWidth = True
      Visible = False
      OnChange = PageControlEditorChange
      OnClose = PageControlEditorClose
      OnContextPopup = PageControlEditorContextPopup
      OnDblClick = PageControlEditorDblClick
      OnMouseDown = PageControlEditorMouseDown
      OnPageChange = PageControlEditorPageChange
    end
  end
  object StatusBar: TSpTBXStatusBar
    Left = 0
    Top = 594
    Width = 906
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Visible = False
    Images = ImgListMenus
    object BarItemFileName: TSpTBXLabelItem
      Caption = 'FileName'
      Visible = False
    end
    object SpTBXSeparatorItem47: TSpTBXSeparatorItem
    end
    object BarItemLineStatus: TSpTBXLabelItem
      Caption = 'Line Status'
      Visible = False
    end
    object SpTBXSeparatorItem48: TSpTBXSeparatorItem
      Visible = False
    end
    object BarItemBuildStatus: TSpTBXLabelItem
      Caption = 'Build Status'
      Visible = False
    end
    object SpTBXSeparatorItem49: TSpTBXSeparatorItem
    end
    object BarItemProgressBar: TTBControlItem
      Control = ProgressBarParser
    end
    object SpTBXRightAlignSpacerItem1: TSpTBXRightAlignSpacerItem
      CustomWidth = 740
    end
    object BarItemEncoding: TSpTBXSubmenuItem
      Caption = 'Encoding'
      Visible = False
      LinkSubitems = SubmenuEncoding
    end
    object SpTBXSeparatorItem50: TSpTBXSeparatorItem
    end
    object BarItemLineEnding: TSpTBXSubmenuItem
      Caption = 'Ending'
      Visible = False
      LinkSubitems = SubmenuEnding
    end
    object ProgressBarParser: TProgressBar
      Left = 0
      Top = 0
      Width = 149
      Height = 19
      TabOrder = 0
      Visible = False
    end
  end
  object ProjectPanel: TSplitterPanel
    Left = 0
    Top = 53
    Width = 185
    Height = 532
    Align = alLeft
    BorderStyle = bsNone
    Size = 4
    TabOrder = 1
    Visible = False
    object PageControlProjects: TModernPageControl
      Left = 0
      Top = 0
      Width = 181
      Height = 532
      ActivePage = TSProjects
      Align = alClient
      Color = clWhite
      NormalColor = 11053224
      FocusedColor = 16185078
      Images = ImgListMenus
      ParentColor = False
      TabIndex = 0
      TabOrder = 0
      TabStop = True
      FixedTabWidth = True
      OnClose = PageControlProjectsClose
      object TSProjects: TModernTabSheet
        Color = 16185078
        Caption = 'Projects'
        ImageIndex = 1
        PageControl = PageControlProjects
        object TreeViewProjects: TTreeView
          Left = 0
          Top = 0
          Width = 175
          Height = 501
          Align = alClient
          BorderWidth = 1
          DragMode = dmAutomatic
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
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
          OnEditing = TreeViewProjectsEditing
          OnEnter = TreeViewProjectsEnter
          OnKeyDown = TreeViewProjectsKeyDown
          OnKeyPress = TreeViewProjectsKeyPress
        end
      end
    end
  end
  object PanelOutline: TSplitterPanel
    Left = 721
    Top = 53
    Width = 185
    Height = 532
    Align = alRight
    BorderStyle = bsNone
    Size = 4
    TabOrder = 2
    Visible = False
    object PageControlOutline: TModernPageControl
      Left = 4
      Top = 0
      Width = 181
      Height = 532
      ActivePage = TSOutline
      Align = alClient
      NormalColor = clWhite
      FocusedColor = 15973017
      Images = ImgListMenus
      ParentColor = False
      TabIndex = 0
      TabOrder = 0
      TabStop = True
      FixedTabWidth = True
      OnClose = PageControlOutlineClose
      object TSOutline: TModernTabSheet
        Color = 16185078
        Caption = 'Outline'
        ImageIndex = 56
        PageControl = PageControlOutline
        object TreeViewOutline: TVirtualStringTree
          Left = 0
          Top = 0
          Width = 175
          Height = 501
          Align = alClient
          Colors.UnfocusedColor = clMedGray
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Header.AutoSizeIndex = 0
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'MS Sans Serif'
          Header.Font.Style = []
          Header.MainColumn = -1
          Images = ImgListOutLine
          ParentFont = False
          TabOrder = 0
          TextMargin = 1
          TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages, toUseExplorerTheme, toHideTreeLinesIfThemed]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnDblClick = TreeViewOutline_DblClick
          OnDrawText = TreeViewOutlineDrawText
          OnFreeNode = TreeViewOutlineFreeNode
          OnGetText = TreeViewOutlineGetText
          OnGetImageIndex = TreeViewOutlineGetImageIndex
          Columns = <>
        end
      end
    end
  end
  object XPManifest: TXPManifest
    Left = 490
    Top = 80
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
    Left = 115
    Top = 89
  end
  object SendData: TSendData
    ClassNamed = 'TFrmFalconMain'
    SendType = stSend
    OnReceivedStream = SendDataReceivedStream
    OnCopyData = SendDataCopyData
    Left = 67
    Top = 500
  end
  object CompilerCmd: TOutputConsole
    OnStart = CompilerCmdStart
    OnFinish = CompilerCmdFinish
    ConvertOemToAnsi = False
    Left = 395
    Top = 521
  end
  object TimerStartUpdate: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerStartUpdateTimer
    Left = 67
    Top = 369
  end
  object UpdateDownload: TFileDownload
    OnFinish = UpdateDownloadFinish
    Left = 51
    Top = 217
  end
  object SplashScreen: TSplashScreen
    PNGResName = 'IMGLOGO'
    WaitTime = 1
    TimeOut = 0
    TimeIn = 200
    DelayTextOut = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TransparentColor = clFuchsia
    Left = 107
    Top = 156
  end
  object FrmPos: TFormPosition
    FileName = 'FormPosition.ini'
    Left = 131
    Top = 209
  end
  object ImgListOutLine: TImageList
    ColorDepth = cd32Bit
    Width = 24
    Left = 810
    Top = 152
    Bitmap = {
      494C010117001900040018001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000006000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AE9486FFAE9486FFAE9486FFAE9486FFAE9486FFAE9486FFAE9486FFAE94
      86FFAE9486FFAE9486FFAE9486FFAE9486FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AC9588FFFFF3D5FFFFFEFAFFFFFDFAFFFFFEF9FFFFFEF9FFFFFDFAFFFFFD
      FAFFFFFDF9FFFFFEF9FFFFFDFAFFAC9588FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AA978CFFFFF3D5FFFFFDF7FFFFFCF7FFFFFDF7FFFFFDF7FFFFFDF7FFFFFD
      F6FFFFFCF6FFFFFDF6FFFFFDF7FFAA978CFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A89A8FFFFFF3D5FFC7A591FFC19D88FFB8917BFFAF856EFFA97C66FFFFFC
      F4FFFFFCF4FFFFFCF4FFFFFCF3FFA89A8FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DB9B33FF956519FF956519FFDB9B33FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BEBEBEFF999999FF999999FFBEBEBEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A59C94FFFFF3D5FFFFFBF0FFFFFBF0FFFFFBF1FFFFFBF0FFFFFBF0FFFFFB
      F0FFFFFBF1FFFFFBF0FFFFFBF1FFA59C94FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DB9B33FF956519FFDFA547FFDFA547FF956519FFDB9B33FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BEBEBEFF999999FFC7C7C7FFC7C7C7FF999999FFBEBEBEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A29F98FFFFF3D5FFC7A591FFC4A18DFFC19D89FFBD9782FFB8917BFFB38B
      75FFAF856EFFAC8069FFFFFAEDFFA29F98FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000956519FFDFA547FFF4E1C3FFF4E1C3FFDFA547FF956519FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000999999FFC7C7C7FFFDFDFDFFFDFDFDFFC7C7C7FF999999FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009EA29EFFFFF3D5FFFFFAEBFFFFF9EBFFFFFAEBFFFFF9EBFFFFFAEAFFFFFA
      EBFFFFF9EBFFFFFAEBFFFFFAEBFF9EA29EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B77C1FFFDA982EFFF4E1C3FFF4E1C3FFDA982EFFB77C1FFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A8A8A8FFBCBCBCFFFDFDFDFFFDFDFDFFBCBCBCFFA8A8A8FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009BA5A2FFFFF3D5FFC7A591FFC4A18DFFC19D89FFBD9782FFB8917BFFB38B
      75FFAF856EFFAC8069FFFFF9E9FF9BA5A2FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E2B05EFFB77C1FFFDFA547FFDFA547FFB77C1FFFE2B05EFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CFCFCFFFA8A8A8FFC7C7C7FFC7C7C7FFA8A8A8FFCFCFCFFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000097A8A8FFFFF3D5FFFFF9E9FFFFF9E9FFFFF9E9FFFFF9E9FFFFF9E9FFFFF9
      E9FFFFF9E9FFFFF9E9FFFFF9E9FF97A8A8FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E2B05EFFD18F23FFD18F23FFE2B05EFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CFCFCFFFB4B4B4FFB4B4B4FFCFCFCFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000094ABADFFFFF3D5FFFFF3D5FFFFF3D5FFFFF3D5FFFFF3D5FFFFF3D5FFFFF3
      D5FFFFF3D5FFFFF3D5FFFFF3D5FF94ABADFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003F98C8FF69D0F8FF69D0F8FF69D0F8FF69D0F8FF69D0F8FF69D0F8FF69D0
      F8FF69D0F8FF69D0F8FF69D0F8FF3F98C8FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003F98C8FF75E7FCFFC898A0FFC898A0FFBF939CFFB18C96FFA1848FFF917B
      88FF837482FF796F7DFF75E7FCFF3F98C8FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003F98C8FF79F1FEFF79F1FEFF79F1FEFF79F1FEFF79F1FEFF79F1FEFF79F1
      FEFF79F1FEFF79F1FEFF79F1FEFF3F98C8FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003F98C8FF3F98C8FF3F98C8FF3F98C8FF3F98C8FF3F98C8FF3F98C8FF3F98
      C8FF3F98C8FF3F98C8FF3F98C8FF3F98C8FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000025678FFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006BAFD7FF3490C6FF3490C6FF3490C6FF3490C6FF328CC2FF3490C6FF3490
      C6FF3490C6FF3490C6FF6BAFD7FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001B7DA7FF1B7DA7FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003894CAFF7EB9DCFF8BC0E0FF8BC0E0FF7EB9DCFF328CC2FF7EB9DCFF8BC0
      E0FF8BC0E0FF7EB9DCFF3894CAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002918C8FF2918C8FF2918C8FF2918C8FF2918C8FF2918C8FF2918
      C8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C81AAFF96DEFEFF96DEFEFF1D82AAFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A51
      25FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003B95CBFF99C8E4FFB1D5EAFFB1D5EAFF8BC0E0FF328CC2FF99C8E4FFB1D5
      EAFFB1D5EAFF8BC0E0FF3B95CBFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002B1CC8FF8B93E7FF8B93E7FF8B93E7FF8B93E7FF8B93E7FF2B1C
      C8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001F87AEFF96DEFEFF96DEFEFF96DEFEFF96DEFEFF1E87
      AEFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A5125FF72D086FF72D086FF72D086FF72D086FF72D086FF1A51
      25FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004299CCFF99C8E4FFDFEDF6FFB1D5EAFF8BC0E0FF328CC2FF99C8E4FFDFED
      F6FFB1D5EAFF8BC0E0FF4299CCFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003028C8FF8383EDFF5F5FE7FF605FE7FF605FE7FF8383EDFF2F28
      C8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000218DB2FF8CDBFEFF6BCFFEFF6BCFFEFF6BCFFEFF6BCFFEFF8CDB
      FEFF218DB3FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000277838FF57C76EFF4DC365FF4DC365FF4DC365FF57C76EFF2778
      38FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004A9DCEFF92C4E1FF99C8E4FF99C8E4FF7EB9DCFF25678FFF92C4E1FF99C8
      E4FF99C8E4FF7EB9DCFF4A9DCEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000332FC8FF8075F5FF5B4CF1FF5B4CF2FF5B4CF1FF8075F5FF332F
      C8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002393B8FF98E6FFFF7CDEFFFF7CDEFFFF7CDEFFFF7CDEFFFF98E6
      FFFF2493B7FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000277838FF57C76EFF36A74EFF36A74EFF36A74EFF57C76EFF2778
      38FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002567
      8FFF328CC2FF328CC2FF328CC2FF328CC2FF25678FFF25678FFF25678FFF328C
      C2FF328CC2FF328CC2FF328CC2FF25678FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000393DC9FF8E92F6FF7B7BF5FF7B7BF5FF7B7BF5FF8E92F6FF393D
      C9FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002698BBFF91EAFFFF91EAFFFF91EAFFFF91E9FFFF2699
      BBFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002E8F43FF72D086FF57C76EFF57C76EFF57C76EFF72D086FF2E8F
      43FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000058A5D2FF7EB9DCFF8BC0E0FF8BC0E0FF7EB9DCFF25678FFF7EB9DCFF8BC0
      E0FF8BC0E0FF7EB9DCFF58A5D2FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003B42C9FF8E92F6FF8E92F6FF8E92F6FF8E92F6FF8E92F6FF3B42
      C9FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000279CBEFFB0F2FFFFB0F2FFFF279CBEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002E8F43FF72D086FF72D086FF72D086FF72D086FF72D086FF2E8F
      43FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000060A9D4FF99C8E4FFB1D5EAFFB1D5EAFF8BC0E0FF328CC2FF99C8E4FFB1D5
      EAFFB1D5EAFF8BC0E0FF60A9D4FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46
      C9FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000279CBEFF279CBEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F
      43FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000064ACD6FF99C8E4FFDFEDF6FFB1D5EAFF8BC0E0FF328CC2FF99C8E4FFDFED
      F6FFB1D5EAFF8BC0E0FF64ACD6FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006BAFD7FF92C4E1FF99C8E4FF99C8E4FF7EB9DCFF328CC2FF92C4E1FF99C8
      E4FF99C8E4FF7EB9DCFF6BAFD7FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007EB9DCFF6BAFD7FF6BAFD7FF6BAFD7FF6BAFD7FF328CC2FF6BAFD7FF6BAF
      D7FF6BAFD7FF6BAFD7FF7EB9DCFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000025678FFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008AB16EFF488104FF5F952DFF8AB16EFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000636363FF3E3E3EFF4B4B4BFF636363FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C2C2C2FF9D9D9DFFAAAAAAFFC2C2C2FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008DB471FF4D850DFF639630FF8DB471FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006B9C42FF649B49FF88BD97FF7EB582FF649B49FF6B9C
      42FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000535353FF535353FF6F6F6FFF696969FF535353FF5353
      53FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000AFAFAFFFAFAFAFFFD0D0D0FFC5C5C5FFAFAFAFFFAFAF
      AFFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000659948FF659948FF91C698FF7DB381FF659948FF6599
      48FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000085AE63FF5E983EFF81B988FF81B888FF81B889FF81B988FF5F97
      3EFF85AE63FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000626262FF4F4F4FFF6A6A6AFF6A6A6AFF6A6A6AFF6A6A6AFF4F4F
      4FFF626262FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2C2C2FFAFAFAFFFC7C7C7FFC7C7C7FFC7C7C7FFC7C7C7FFAFAF
      AFFFC2C2C2FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008DB471FF659948FF83BA86FF83BA86FF83BA86FF83BA86FF6599
      48FF8DB471FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000558C1CFF6FAA61FF75B170FF75B170FF74B170FF75B170FF6FAA
      61FF558C1CFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000464646FF5E5E5EFF636363FF636363FF636363FF636363FF5E5E
      5EFF464646FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D9D9DFFBEBEBEFFBEBEBEFFBEBEBEFFBEBEBEFFBEBEBEFFBEBE
      BEFF9D9D9DFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004D850DFF73AC69FF73AC69FF73AC69FF73AC69FF73AC69FF73AC
      69FF4D850DFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000478002FF82BD82FF84BE84FF84BE84FF84BE84FF84BF84FF82BD
      82FF478002FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003C3C3CFF6D6D6DFF6D6D6DFF6D6D6DFF6D6D6DFF6E6E6EFF6D6D
      6DFF3C3C3CFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D9D9DFFC7C7C7FFC7C7C7FFC7C7C7FFC7C7C7FFC7C7C7FFC7C7
      C7FF9D9D9DFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004D850DFF83BA86FF83BA86FF83BA86FF83BA86FF83BA86FF83BA
      86FF4D850DFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008DB670FF6FA755FF99CFABFF99CFABFF99CFABFF98CFABFF6FA7
      55FF8DB670FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000676767FF5B5B5BFF7B7B7BFF7B7B7BFF7B7B7BFF7B7B7BFF5B5B
      5BFF676767FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2C2C2FFB7B7B7FFD7D7D7FFD7D7D7FFD7D7D7FFD7D7D7FFB7B7
      B7FFC2C2C2FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008DB471FF71A44FFF99CFACFF99CFACFF99CFACFF99CFACFF71A4
      4FFF8DB471FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000072A34CFF73AA5EFF9DD2B4FF90C698FF73AA5EFF72A3
      4CFF00000000000000000000000000000000000000000000000049AF2EFF3379
      20FF347D21FFC5EDBBFF00000000000000000000000000000000000000000000
      00000000000000000000595959FF5E5E5EFF7E7E7EFF737373FF5E5E5EFF5959
      59FF00000000000000000000000000000000494949EA4F4F4FFF4F4F4FFF4E4E
      4EFA181818510000000000000000000000000000000000000000000000000000
      00000000000000000000B7B7B7FFBEBEBEFFD7D7D7FFD0D0D0FFBEBEBEFFB7B7
      B7FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000071A44FFF73AC69FF99CFACFF91C698FF73AC69FF71A4
      4FFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000090B774FF488104FF5F952DFF90B774FF0000
      0000000000000000000000000000000000000000000058B63FFF347D21FFC5ED
      BBFFA0E18FFF347D21FF00000000000000000000000000000000000000000000
      0000000000000000000000000000676767FF3E3E3EFF4B4B4BFF676767FF0000
      000000000000000000000000000000000000000000004F4F4FFF000000001818
      18514E4E4EFA0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C2C2C2FF9D9D9DFFAAAAAAFFC2C2C2FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008DB471FF4D850DFF639630FF8DB471FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000058B63FFF347D21FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004F4F4FFF000000000000
      00004F4F4FFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000058B63FFF347D21FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004F4F4FFF000000000000
      00004F4F4FFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000058B63FFF347D21FFC5ED
      BBFFA0E18FFF347D21FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004F4F4FFF000000001818
      18514E4E4EFA0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000049AF2EFF3379
      20FF347D21FFC5EDBBFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000494949EA4F4F4FFF4F4F4FFF4E4E
      4EFA181818510000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7BE7FF3535DBFF3535DBFF7B7BE7FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A2A977FF4D850DFF4D850DFFA2A977FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001B7DA7FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7BE7FF3535DBFF8F8FEAFF8F8FEAFF3535DBFF7B7BE7FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A2A977FF4D850DFF83BA86FF83BA86FF4D850DFFA2A977FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004E41D8FF4E41D8FF4E41D8FF4E41D8FF4E41D8FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C81AAFF6BCFFEFF1D82AAFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003535DBFF8F8FEAFFFBFBFEFFFBFBFEFF8F8FEAFF3535DBFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004D850DFF83BA86FFFEFEFEFFFEFEFEFF83BA86FF4D850DFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004E41D8FF8076E3FFFFFFFFFF9088E7FF4E41D8FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001F87AEFF6BCFFEFFFFFFFFFF6BCFFEFF1E87AEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005252E0FF7777E7FFFBFBFEFFFBFBFEFF7777E7FF5252E0FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000639630FF73AC69FFFEFEFEFFFEFEFEFF73AC69FF639630FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004E41D8FFFFFFFFFFFFFFFFFFFFFFFFFF4E41D8FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000218DB2FF6BCFFEFFFFFFFFFFFFFFFFFFFFFFFFFF6BCFFEFF218D
      B3FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A3A3EEFF5252E0FF8F8FEAFF8F8FEAFF5252E0FFA3A3EEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ADC792FF639630FF83BA86FF83BA86FF639630FFADC792FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004E41D8FF8076E3FFFFFFFFFF8076E3FF4E41D8FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000002698BBFF96DEFEFFFFFFFFFF96DEFEFF2699BBFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A3A3EEFF6A6AE4FF6A6AE4FFA3A3EEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000ADC792FF71A44FFF71A44FFFADC792FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004E41D8FF4E41D8FF4E41D8FF4E41D8FF4E41D8FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000279CBEFF96DEFEFF279CBEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000279CBEFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002B0D
      C7FF2B0DC7FF2B0DC7FF2B0DC7FF2B0DC7FF2B0DC7FF2B0DC7FF000000000000
      0000000000000000000000000000000000000000000000000000000000001A51
      25FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A51
      25FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A51
      25FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001B7DA7FF1B7DA7FF0000000000000000000000002B0D
      C7FF8B8FEFFF8B8FEFFF8B8FEFFF8B8FEFFF8B8FEFFF2B0DC7FF000000000000
      0000000000000000000000000000000000000000000000000000000000001A51
      25FF72D086FF72D086FF72D086FF72D086FF72D086FF1A5125FF000000000000
      0000000000001B7DA7FF1B7DA7FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A51
      25FF72D086FF72D086FF72D086FF72D086FF72D086FF1A5125FF000000000000
      0000000000001B7DA7FF1B7DA7FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A51
      25FF72D086FF72D086FF72D086FF72D086FF72D086FF1A5125FF000000000000
      0000CF6F70FF963031FFB53B3CFFCF6F70FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001C81AAFF96DEFEFF96DEFEFF1D82AAFF00000000000000003432
      C8FF8176ECFF6E6EEEFF6E6EEEFF6E6EEEFF8176ECFF3432C8FF000000000000
      0000000000000000000000000000000000000000000000000000000000002778
      38FF57C76EFF4DC365FF4DC365FF4DC365FF57C76EFF277838FF000000000000
      00001C81AAFF96DEFEFF96DEFEFF1D82AAFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002778
      38FF57C76EFF4DC365FF4DC365FF4DC365FF57C76EFF277838FF000000000000
      00001C81AAFF96DEFEFF96DEFEFF1D82AAFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002778
      38FF57C76EFF4DC365FF4DC365FF4DC365FF57C76EFF277838FF00000000BF3F
      40FFBF3F40FFDA8F90FFD07273FFBF3F40FFBF3F40FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001F87AEFF96DEFEFF96DEFEFF96DEFEFF96DEFEFF1E87AEFF000000003432
      C8FF8176ECFF5C4DF1FF5C4DF1FF5C4DF1FF8176ECFF3432C8FF000000000000
      0000000000000000000000000000000000000000000000000000000000002778
      38FF57C76EFF36A74EFF36A74EFF36A74EFF57C76EFF277838FF000000001F87
      AEFF96DEFEFF96DEFEFF96DEFEFF96DEFEFF1E87AEFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000002778
      38FF57C76EFF36A74EFF36A74EFF36A74EFF57C76EFF277838FF000000001F87
      AEFF96DEFEFF96DEFEFF96DEFEFF96DEFEFF1E87AEFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000002778
      38FF57C76EFF36A74EFF36A74EFF36A74EFF57C76EFF277838FFCF6F70FFBF3F
      40FFD27A7AFFD27A7AFFD27A7AFFD27A7AFFBF3F40FFCF6F70FF000000000000
      000000000000000000000000000000000000000000000000000000000000218D
      B2FF8CDBFEFF6BCFFEFF6BCFFEFF6BCFFEFF6BCFFEFF8CDBFEFF218DB3FF3D46
      C9FF8B8FEFFF8176ECFF8176ECFF8176ECFF8B8FEFFF3D46C9FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF72D086FF57C76EFF57C76EFF57C76EFF72D086FF2E8F43FF218DB2FF8CDB
      FEFF6BCFFEFF6BCFFEFF6BCFFEFF6BCFFEFF8CDBFEFF218DB3FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF72D086FF57C76EFF57C76EFF57C76EFF72D086FF2E8F43FF218DB2FF8CDB
      FEFF6BCFFEFF6BCFFEFF6BCFFEFF6BCFFEFF8CDBFEFF218DB3FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF72D086FF57C76EFF57C76EFF57C76EFF72D086FF2E8F43FF963031FFCA60
      61FFCA6061FFCA6061FFCA6061FFCA6061FFCA6061FF963031FF000000000000
      0000000000000000000000000000000000000000000000000000000000002393
      B8FF98E6FFFF7CDEFFFF7CDEFFFF7CDEFFFF7CDEFFFF98E6FFFF2493B7FF3D46
      C9FF8B8FEFFF8B8FEFFF8B8FEFFF8B8FEFFF8B8FEFFF3D46C9FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF72D086FF72D086FF72D086FF72D086FF72D086FF2E8F43FF2393B8FF98E6
      FFFF7CDEFFFF7CDEFFFF7CDEFFFF7CDEFFFF98E6FFFF2493B7FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF72D086FF72D086FF72D086FF72D086FF72D086FF2E8F43FF2393B8FF98E6
      FFFF7CDEFFFF7CDEFFFF7CDEFFFF7CDEFFFF98E6FFFF2493B7FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF72D086FF72D086FF72D086FF72D086FF72D086FF2E8F43FF963031FFD27A
      7AFFD27A7AFFD27A7AFFD27A7AFFD27A7AFFD27A7AFF963031FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002698BBFF91EAFFFF91EAFFFF91EAFFFF91E9FFFF2699BBFF4D850DFF3D46
      C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF7A7A7AFF2698
      BBFF91EAFFFF91EAFFFF91EAFFFF91E9FFFF2699BBFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FFB53B3CFF2698
      BBFF91EAFFFF91EAFFFF91EAFFFF91E9FFFF2699BBFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000002E8F
      43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FFCF6F70FFC653
      54FFDFA1A2FFDFA1A2FFDFA1A2FFDFA1A2FFC65354FFCF6F70FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000279CBEFFB0F2FFFFB0F2FFFF279CBEFF659948FF91C698FF7DB3
      81FF659948FF659948FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000828282FF828282FFB7B7B7FFA4A4A4FF8282
      82FF279CBEFFB0F2FFFFB0F2FFFF279CBEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BF3F40FFBF3F40FFDA8F90FFD07273FFBF3F
      40FF279CBEFFB0F2FFFFB0F2FFFF279CBEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002B0DC7FF2B0DC7FF2B0DC7FF2B0DC7FFC653
      54FFCA6061FFDFA1A2FFDA8F90FFCA6061FFC65354FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000279CBEFF279CBEFF659948FF83BA86FF83BA86FF83BA
      86FF83BA86FF659948FF8DB471FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A1A1A1FF828282FFA9A9A9FFA9A9A9FFA9A9A9FFA9A9
      A9FF828282FF279CBEFF279CBEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CF6F70FFBF3F40FFD27A7AFFD27A7AFFD27A7AFFD27A
      7AFFBF3F40FF279CBEFF279CBEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002B0DC7FF8B8FEFFF8B8FEFFF8B8FEFFF8B8F
      EFFFCF6F70FF963031FFB53B3CFFCF6F70FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004D850DFF73AC69FF73AC69FF73AC69FF73AC
      69FF73AC69FF73AC69FF4D850DFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000656565FF989898FF989898FF989898FF989898FF9898
      98FF989898FF656565FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000963031FFCA6061FFCA6061FFCA6061FFCA6061FFCA60
      61FFCA6061FF963031FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003432C8FF8176ECFF6E6EEEFF6E6EEEFF6E6E
      EEFF8176ECFF3432C8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004D850DFF83BA86FF83BA86FF83BA86FF83BA
      86FF83BA86FF83BA86FF4D850DFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000656565FFA9A9A9FFA9A9A9FFA9A9A9FFA9A9A9FFA9A9
      A9FFA9A9A9FF656565FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000963031FFD27A7AFFD27A7AFFD27A7AFFD27A7AFFD27A
      7AFFD27A7AFF963031FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003432C8FF8176ECFF5C4DF1FF5C4DF1FF5C4D
      F1FF8176ECFF3432C8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008DB471FF71A44FFF99CFACFF99CFACFF99CF
      ACFF99CFACFF71A44FFF8DB471FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A1A1A1FF8E8E8EFFC2C2C2FFC2C2C2FFC2C2C2FFC2C2
      C2FF8E8E8EFFA1A1A1FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CF6F70FFC65354FFDFA1A2FFDFA1A2FFDFA1A2FFDFA1
      A2FFC65354FFCF6F70FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003D46C9FF8B8FEFFF8176ECFF8176ECFF8176
      ECFF8B8FEFFF3D46C9FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000071A44FFF73AC69FF99CFACFF91C6
      98FF73AC69FF71A44FFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008E8E8EFF989898FFC2C2C2FFB7B7B7FF9898
      98FF8E8E8EFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C65354FFCA6061FFDFA1A2FFDA8F90FFCA60
      61FFC65354FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003D46C9FF8B8FEFFF8B8FEFFF8B8FEFFF8B8F
      EFFF8B8FEFFF3D46C9FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008DB471FF4D850DFF6396
      30FF8DB471FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A1A1A1FF656565FF7A7A7AFFA1A1
      A1FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CF6F70FF963031FFB53B3CFFCF6F
      70FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46
      C9FF3D46C9FF3D46C9FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1BBB4FFCDB6AEFFC9AEA4FFC3A599FFBD9C
      8DFFB79382FFB18976FFAC836CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DFDFDFFFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8
      D8FFD8D8D8FFDFDFDFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DFDFDFFFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8D8FFD8D8
      D8FFD8D8D8FFDFDFDFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000091DA94FF91DA94FF91DA94FF91DA94FF91DA94FF91DA94FF91DA94FF91DA
      94FF91DA94FF8FDA92FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000091DA94FF91DA94FF91DA94FF91DA94FF91DA94FF91DA94FF91DA94FF91DA
      94FF91DA94FF8FDA92FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1BBB4FFCDB5ACFFC8ACA2FFC0A195FFB996
      87FFB38C78FFAD836EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000091DA
      94FFD6F1D7FFCAEDCBFFCAEDCBFFCAEDCBFFCAEDCBFFCAEDCBFFCAEDCBFFCAED
      CBFFCAEDCBFFD6F1D7FF91DA94FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000091DA
      94FFD6F1D7FFCAEDCBFFCAEDCBFFCAEDCBFFCAEDCBFFCAEDCBFFCAEDCBFFCAED
      CBFFCAEDCBFFD6F1D7FF91DA94FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000094DB
      97FFAFE4B1FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3
      B0FFAEE3B0FFD6F1D7FF92DB95FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000094DB
      97FFAFE4B1FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3B0FFAEE3
      B0FFAEE3B0FFD6F1D7FF92DB95FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1BBB4FFCCB3ABFFC5A99DFFBD9C8DFFB58F
      7DFFAD8470FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000097DC
      9AFFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBBE8
      BDFFBEE9C0FFD6F1D7FF97DC9AFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000097DC
      9AFFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBEE9C0FFBBE8
      BDFFBEE9C0FFD6F1D7FF97DC9AFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1BBB4FFCDB6AEFFC9AEA4FFC3A599FFBD9C
      8DFFB79382FFB18976FFAC836CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009ADD
      9DFFCCEECDFFC5ECC7FFC5ECC7FFC5ECC7FFC5ECC7FFC5ECC7FFC5ECC7FFC5EC
      C7FFC5ECC7FFD8F1D8FF9ADD9DFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009ADD
      9DFFCCEECDFFC5ECC7FFC5ECC7FFC5ECC7FFC5ECC7FFC5ECC7FFC5ECC7FFC5EC
      C7FFC5ECC7FFD8F1D8FF9ADD9DFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1BBB4FFCDB6AEFFC9AEA4FFC3A599FFBD9C
      8DFFB79382FFB18976FFAC836CFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A58F6AFF7945
      00FF794500FF794500FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009FDF
      A1FFD8F1D8FFCDEECEFFCDEECEFFCDEECEFFCDEECEFFCDEECEFFCDEECEFFCDEE
      CEFFCDEECEFFD8F1D8FF9FDFA1FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009FDF
      A1FFD8F1D8FFCDEECEFFCDEECEFFCDEECEFFCDEECEFFCDEECEFFCDEECEFFCDEE
      CEFFCDEECEFFD8F1D8FF9FDFA1FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A58F
      6AFF8B632BFF794500FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A4E0
      A7FFD8F1D8FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEF
      D0FFCFEFD0FFD8F1D8FFA3E0A5FF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A4E0
      A7FFD8F1D8FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEF
      D0FFCFEFD0FFD8F1D8FFA3E0A5FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D1BBB4FFCDB5ACFFC8ACA2FFC0A195FFB996
      87FFB38C78FFAD836EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A58F6AFF794500FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A9E2
      ABFFD8F1D8FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEF
      D0FFCFEFD0FFD8F1D8FFA8E1AAFF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A9E2
      ABFFD8F1D8FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEFD0FFCFEF
      D0FFCFEFD0FFD8F1D8FFA8E1AAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A58F6AFF7945
      00FF794500FF794500FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A58F6AFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AFE4
      B1FFD8F1D8FFD0EFD1FFD0EFD1FFD0EFD1FFD0EFD1FFD0EFD1FFD0EFD1FFD0EF
      D1FFD0EFD1FFD8F1D8FFAEE3B0FF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AFE4
      B1FFD8F1D8FFD0EFD1FFD0EFD1FFD0EFD1FFD0EFD1FFD0EFD1FFD0EFD1FFD0EF
      D1FFD0EFD1FFD8F1D8FFAEE3B0FF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A58F
      6AFF8B632BFF794500FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B8E7
      BAFFDFF4E0FFDBF2DBFFDBF2DBFFDBF2DBFFDBF2DBFFDBF2DBFFDBF2DBFFDBF2
      DBFFDBF2DBFFDFF4E0FFB8E7BAFF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B8E7
      BAFFDFF4E0FFDBF2DBFFDBF2DBFFDBF2DBFFDBF2DBFFDBF2DBFFDBF2DBFFDBF2
      DBFFDBF2DBFFDFF4E0FFB8E7BAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A58F6AFF794500FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BBE8
      BDFFE9F7EAFFE7F7E7FFE7F7E7FFE7F7E7FFE7F7E7FFE7F7E7FFE7F7E7FFE7F7
      E7FFE7F7E7FFE9F7EAFFB9E7BBFF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BBE8
      BDFFE9F7EAFFE7F7E7FFE7F7E7FFE7F7E7FFE7F7E7FFE7F7E7FFE7F7E7FFE7F7
      E7FFE7F7E7FFE9F7EAFFB9E7BBFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A58F6AFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8
      BEFFBCE8BEFFBCE8BEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8BEFFBCE8
      BEFFBCE8BEFFBCE8BEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000600000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFFFFFFFF000000FFFFFFFF
      FFFFF000FF000000FFFFFFFFFFFFF000FF000000FFFFFFFFFFFFF000FF000000
      FFFFFFFFFFFFF000FF000000FC3FFFFC3FFFF000FF000000F81FFFF81FFFF000
      FF000000F81FFFF81FFFF000FF000000F81FFFF81FFFF000FF000000F81FFFF8
      1FFFF000FF000000FC3FFFFC3FFFF000FF000000FFFFFFFFFFFFF000FF000000
      FFFFFFFFFFFFF000FF000000FFFFFFFFFFFFF000FF000000FFFFFFFFFFFFF000
      FF000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFFFFFFFFF001FF
      FFFFFFFF3FFFFFFFFFF001FFF80FFFFE1FFFF80FFFF001FFF80FFFFC0FFFF80F
      FFF001FFF80FFFF807FFF80FFFF001FFF80FFFF807FFF80FFFE000FFF80FFFFC
      0FFFF80FFFF001FFF80FFFFE1FFFF80FFFF001FFF80FFFFF3FFFF80FFFF001FF
      FFFFFFFFFFFFFFFFFFF001FFFFFFFFFFFFFFFFFFFFF001FFFFFFFFFFFFFFFFFF
      FFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FE1FFFFE1FFFFE1FFFFE1FFFFC0FFFFC0FFFFC0FFFFC0FFFF807FFF807FFF807
      FFF807FFF807FFF807FFF807FFF807FFF807FFF807FFF807FFF807FFF807FFF8
      07FFF807FFF807FFFC0FC3FC0F07FC0FFFFC0FFFFE1F83FE1FA7FE1FFFFE1FFF
      FFFF9FFFFFB7FFFFFFFFFFFFFFFF9FFFFFB7FFFFFFFFFFFFFFFF83FFFFA7FFFF
      FFFFFFFFFFFFC3FFFF07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFC3FFFFC3FFFFFFFFFFF7FFFF81FFFF81FFFF83F
      FFFE3FFFF81FFFF81FFFF83FFFFC1FFFF81FFFF81FFFF83FFFF80FFFF81FFFF8
      1FFFF83FFFFC1FFFFC3FFFFC3FFFF83FFFFE3FFFFFFFFFFFFFFFFFFFFFFF7FFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE03FE0
      3FFFE03FFFE03FFFFCE03FE039FFE039FFE030FFF8603FE030FFE030FFE0207F
      F0203FE0207FE0207FE0003FE0003FE0003FE0003FE0003FE0003FE0003FE000
      3FE0003FF0003FE0007FE0007FE0003FF803FFFE00FFFE00FFFE007FFC01FFFC
      01FFFC01FFFE00FFFE01FFFC03FFFC03FFFE03FFFE01FFFC03FFFC03FFFE03FF
      FE01FFFC03FFFC03FFFE03FFFF03FFFE07FFFE07FFFE03FFFF87FFFF0FFFFF0F
      FFFE03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFE01FFFFFFFFF003FFF003FFFFFFFFFFFFFFF003FFF003FF
      FE03FFFFFFFFE001FFE001FFFFFFFFFFFFFFE001FFE001FFFE07FFFFFFFFE001
      FFE001FFFFFFFFFE01FFE001FFE001FFFE01FFC3FFFFE001FFE001FFFFFFFFE3
      FFFFE001FFE001FFFE03FFF3FFFFE001FFE001FFC3FFFFFBFFFFE001FFE001FF
      E3FFFFFFFFFFE001FFE001FFF3FFFFFFFFFFE001FFE001FFFBFFFFFFFFFFF003
      FFF003FFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupProject: TSpTBXPopupMenu
    Images = ImgListMenus
    OwnerDraw = True
    OnPopup = PopupProjectPopup
    Left = 35
    Top = 96
    object PopProjNew: TSpTBXSubmenuItem
      Caption = '&New'
      ImageIndex = 6
      LinkSubitems = FileNew
    end
    object SpTBXSeparatorItem23: TSpTBXSeparatorItem
    end
    object PopProjEdit: TSpTBXItem
      Caption = 'Edit'
      ShortCut = 13
      OnClick = EditFileClick
    end
    object PopProjOpen: TSpTBXItem
      Caption = 'Open'
      ImageIndex = 9
      OnClick = PopProjOpenClick
    end
    object SpTBXSeparatorItem24: TSpTBXSeparatorItem
    end
    object PopProjAdd: TSpTBXItem
      Caption = 'Add to project'
      OnClick = ProjectAddClick
    end
    object PopProjRemove: TSpTBXItem
      Caption = 'Remove'
      ImageIndex = 12
      ShortCut = 46
      OnClick = FileRemoveClick
    end
    object PopProjRename: TSpTBXItem
      Caption = 'Rename'
      ShortCut = 113
      OnClick = PopProjRenameClick
    end
    object PopProjDelFromDsk: TSpTBXItem
      Caption = 'Delete from disk'
      ShortCut = 8238
      OnClick = PopProjDelFromDskClick
    end
    object SpTBXSeparatorItem25: TSpTBXSeparatorItem
    end
    object PopProjProp: TSpTBXItem
      Caption = 'Property...'
      ImageIndex = 20
      ShortCut = 32781
      OnClick = ProjectPropertiesClick
    end
  end
  object PopupEditor: TSpTBXPopupMenu
    Images = ImgListMenus
    OwnerDraw = True
    Left = 259
    Top = 328
    object PopEditorOpenDecl: TSpTBXItem
      Caption = 'Open declaration'
      OnClick = PopEditorOpenDeclClick
    end
    object SpTBXSeparatorItem44: TSpTBXSeparatorItem
    end
    object PopEditorCompClass: TSpTBXItem
      Caption = 'Complete class at cursor'
      ShortCut = 24643
      OnClick = PopEditorCompClassClick
    end
    object PopEditorSwap: TSpTBXItem
      Caption = 'Swap header/source'
      OnClick = EditSwapClick
    end
    object SpTBXSeparatorItem8: TSpTBXSeparatorItem
    end
    object PopEditorUndo: TSpTBXItem
      Caption = 'Undo'
      ImageIndex = 18
      OnClick = EditUndoClick
    end
    object PopEditorRedo: TSpTBXItem
      Caption = 'Redo'
      ImageIndex = 19
      OnClick = EditRedoClick
    end
    object SpTBXSeparatorItem28: TSpTBXSeparatorItem
    end
    object PopEditorCut: TSpTBXItem
      Caption = 'Cut'
      ImageIndex = 15
      OnClick = EditCutClick
    end
    object PopEditorCopy: TSpTBXItem
      Caption = 'Copy'
      ImageIndex = 16
      OnClick = EditCopyClick
    end
    object PopEditorPaste: TSpTBXItem
      Caption = 'Paste'
      ImageIndex = 17
      OnClick = EditPasteClick
    end
    object PopEditorDelete: TSpTBXItem
      Caption = 'Delete'
      ImageIndex = 12
      OnClick = EditDeleteClick
    end
    object PopEditorSelectAll: TSpTBXItem
      Caption = 'Select All'
      ImageIndex = 45
      OnClick = EditSelectAllClick
    end
    object SpTBXSeparatorItem27: TSpTBXSeparatorItem
    end
    object PopEditorTools: TSpTBXSubmenuItem
      Caption = 'Tools'
    end
    object SpTBXSeparatorItem26: TSpTBXSeparatorItem
    end
    object PopEditorBookmarks: TSpTBXSubmenuItem
      Caption = 'Toggle Bookmarks'
      ImageIndex = 53
      LinkSubitems = EditBookmarks
    end
    object PopEditorGotoBookmarks: TSpTBXSubmenuItem
      Caption = 'Goto Bookmarks'
      ImageIndex = 52
      LinkSubitems = EditGotoBookmarks
    end
    object SpTBXSeparatorItem34: TSpTBXSeparatorItem
    end
    object PopEditorProperties: TSpTBXItem
      Caption = 'Properties...'
      ImageIndex = 20
      OnClick = ProjectPropertiesClick
    end
  end
  object PopupMsg: TSpTBXPopupMenu
    Images = ImgListMenus
    Left = 467
    Top = 521
    object PupMsgCopy: TSpTBXItem
      Caption = 'Copy'
      ImageIndex = 16
      ShortCut = 16451
      OnClick = Copiar1Click
    end
    object PupMsgCopyOri: TSpTBXItem
      Caption = 'Copy original message'
      ShortCut = 24643
      OnClick = Copyoriginalmessage1Click
    end
    object SpTBXSeparatorItem32: TSpTBXSeparatorItem
    end
    object PupMsgOriMsg: TSpTBXItem
      Caption = 'Original message'
      OnClick = Originalmessage1Click
    end
    object SpTBXSeparatorItem31: TSpTBXSeparatorItem
    end
    object PupMsgGotoLine: TSpTBXItem
      Caption = 'Goto line'
      ImageIndex = 36
      OnClick = PupMsgGotoLineClick
    end
    object PupMsgClear: TSpTBXItem
      Caption = 'Clear'
      OnClick = PupMsgClearClick
    end
  end
  object TimerChangeDelay: TTimer
    Enabled = False
    Interval = 250
    OnTimer = TimerChangeDelayTimer
    Left = 372
    Top = 328
  end
  object ImgListMenus: TImageList
    ColorDepth = cd32Bit
    Left = 699
    Top = 4
    Bitmap = {
      494C010139003D00040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000F0000000010020000000000000F0
      0000000000000000000000000000000000000000000000000000AB6813FFAB68
      13FFAB6813FFAB6813FFAB6813FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFF7D2
      96FFF7D396FFF7D296FFF7D296FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFFDDF
      B3FFFDDFB2FFFDE0B3FFFDE0B2FFAB6813FF000000008A540FFF8A540FFF8A54
      0FFF8A540FFF8A540FFF8A540FFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFFFEC
      CEFFFFECCEFFFFEDCFFFFFEDCEFFAB6813FF00000000FFE8C1FFFFE8C1FFFFE8
      C1FFFFE8C1FFFFE8C1FFFFE8C1FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFFFF6
      E1FFFFF6E1FFFFF6E1FFFFF6E1FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFAB68
      13FFAB6813FFAB6813FFAB6813FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008A540FFF8A540FFF8A54
      0FFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008A540FFFFFFFFFFF8A54
      0FFF00000000AB6813FF8A540FFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AB6813FFAB6813FFAB68
      13FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFAB68
      13FFAB6813FFAB6813FFAB6813FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFF7D2
      96FFF7D396FFF7D296FFF7D296FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFFDDF
      B3FFFDDFB2FFFDE0B3FFFDE0B2FFAB6813FF000000008A540FFF8A540FFF8A54
      0FFF8A540FFF8A540FFF8A540FFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFFFEC
      CEFFFFECCEFFFFEDCFFFFFEDCEFFAB6813FF00000000FFE8C1FFFFE8C1FFFFE8
      C1FFFFE8C1FFFFE8C1FFFFE8C1FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFFFF6
      E1FFFFF6E1FFFFF6E1FFFFF6E1FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB6813FFAB68
      13FFAB6813FFAB6813FFAB6813FFAB6813FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF000000000000000000000000CC9965FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E584EFF5E4239FF5E4239FF5E584EFF00000000000000000000
      000000000000000000000000000000000000000000005E584EFF5E4239FF5E42
      39FF5E584EFF000000000000000000000000156DA3FF00000000000000000000
      00005E584EFF5E4239FF5E4239FF5E584EFF0000000000000000CC9965FFFFFF
      FFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF000000000000000000000000993200FF993200FF9932
      00FF0000000000000000000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF00000000000000000000000000000000000000000000
      000000000000B48955FF957B66FF957B66FFB48955FF00000000000000000000
      0000146CA2FF00000000000000000000000000000000B48955FF957B66FF957B
      66FFB48955FF0000000000000000166FA5FFA5E5FCFF166FA5FF000000000000
      0000B48955FF957B66FF957B66FFB48955FF0000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF000000000000000000000000CC9965FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000146C
      A2FF9FE3FCFF146CA2FF00000000000000000000000000000000000000000000
      00000000000000000000000000001671A6FFADE7FCFF1671A6FF000000000000
      0000000000000000000000000000000000000000000000000000CC9965FFFFFF
      FFFFCCCCCCFFCCCCCCFFFFFFFFFFFFFFFFFF993200FF993200FFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000146CA2FF9FE3
      FCFFA7E5FCFF9FE3FCFF146CA2FF000000000000000000000000000000000000
      00000000000000000000000000001672A8FFB7EAFDFF1672A8FF000000000000
      0000000000000000000000000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FF993200FF993200FF993200FFCC99
      65FFFFFFFFFFCC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000146CA2FF0000
      000000000000000000000000000000000000000000001877ABFF9FE3FCFFB3E8
      FCFFB3E8FCFFB3E8FCFF9FE3FCFF1877ABFF0000000000000000000000000000
      00000000000000000000000000001775AAFFC2EDFDFF1775AAFF000000001775
      AAFF1775AAFF0000000000000000000000000000000000000000CC9965FFFFFF
      FFFFCCCCCCFFCCCCCCFFFFFFFFFFFFFFFFFF993200FF993200FFFFFFFFFF9932
      00FFFFFFFFFFCC9965FF000000000000000000000000CC9965FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001877ABFFC0ECFDFF1877
      ABFF00000000000000000000000000000000000000001A80B3FF1A80B3FF1A80
      B3FFC0ECFDFF1A80B3FF1A80B3FF1A80B3FF0000000000000000000000000000
      00000000000000000000000000001877ACFFCDF0FEFF1877ACFF000000001877
      ACFFA5E5FCFF1877ACFF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FFFFFFFFFF9932
      00FFFFFFFFFFCC9965FF000000000000000000000000993200FF993200FF9932
      00FF0000000000000000000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF0000000000000000000000001A80B3FFCFF0FDFF1A80
      B3FF000000000000000000000000000000000000000000000000000000001A80
      B3FFCFF0FDFF1A80B3FF00000000000000000000000000000000000000000000
      00000000000000000000000000001879AEFFD7F3FEFF7CC0D6FF1879AEFF1879
      AEFFD7F3FEFFA5E5FCFF1879AEFF000000000000000000000000CC9965FFFFFF
      FFFFCCCCCCFFCCCCCCFFCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9932
      00FFFFFFFFFFCC9965FF000000000000000000000000CC9965FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001A80B3FFDBF5FEFFA7D8
      EAFF1A80B3FF00000000000000000000000000000000000000001A80B3FFA7D8
      EAFFDBF5FEFF1A80B3FF00000000000000000000000000000000000000000000
      00000000000000000000000000008FC5D9FF197BAFFFE1F6FEFFE1F6FEFFE1F6
      FEFFE1F6FEFFE1F6FEFFADE7FCFF197BAFFF0000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9932
      00FFFFFFFFFFCC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008FC5D9FF2D8EBEFFDBF5
      FEFFA7D8EAFF1A80B3FF1A80B3FF1A80B3FF1A80B3FF1A80B3FFA7D8EAFFDBF5
      FEFF2D8EBEFF8AC4D8FF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000076BAD2FF197DB0FF197DB0FF197D
      B0FFE9F8FEFFADE7FCFF197DB0FF000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFF993200FF993200FF993200FF993200FF993200FFCC99
      65FFFFFFFFFFCC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008FC5D9FF2D8E
      BEFFBEE0EDFFEFFAFEFFEFFAFEFFEFFAFEFFEFFAFEFFEFFAFEFFBEE0EDFF2D8E
      BEFF76BAD2FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000197E
      B2FFADE7FCFF197EB2FF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF000000000000000000000000CC9965FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008FC5
      D9FF3997C5FF1A80B3FF1A80B3FF1A80B3FF1A80B3FF1A80B3FF3997C5FF8FC5
      D9FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A80
      B3FF1A80B3FF0000000000000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF000000000000000000000000993200FF993200FF9932
      00FF0000000000000000000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FF000000000000000000000000CC9965FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FF993200FF9932
      00FF993200FF993200FF993200FF993200FF00000000808080FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00000000000000000000000000000000000000000000545454FF545454FF5454
      54FF545454FF545454FF545454FF545454FF545454FF545454FF545454FF5454
      54FF545454FF545454FF545454FF00000000000000000000000000000000E2EF
      F1FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF993200FF00000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008080FF000000FF0000
      00FF000000FF008080FF000000000000000000000000868686FFCCCCCCFFCCCC
      CCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFCCCCCCFF545454FF000000000000000000000000E5E5E5FFC0C0
      C0FF999999FF808080FF808080FF999999FF99A8ACFFC0C0C0FFCCCCCCFFE2EF
      F1FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000080FF00000000993200FFCC65
      00FFCC6500FFCC6500FF993200FF0000000000000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFFFF00FF
      FFFF00FFFFFF000000FF000000000000000000000000868686FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF545454FF000000000000000000000000CCCCCCFFCCCC
      CCFFCCCC99FFCCCC99FFCCCC99FF999999FF808080FF656565FF808080FFB2B2
      B2FFE5E5E5FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000FFFF000099FF000099FF000080FF000000009932
      00FFCC6500FF993200FF000000000000000000000000808080FFFFFFFFFFFFFF
      FFFF808080FF808080FF808080FF808080FFFFFFFFFF000000FF00FFFFFF00FF
      FFFF00FFFFFF000000FF000000000000000000000000868686FFFFFFFFFF0707
      07FF070707FF070707FF070707FF070707FF070707FF070707FF070707FF0707
      07FF070707FFFFFFFFFF545454FF0000000000000000E5E5E5FFFFFFCCFFF2EA
      BFFFF2EABFFFCCCC99FFECC6D9FFFFCC99FFF2EABFFFF2EABFFF808080FF6565
      65FF999999FFE5E5E5FF00000000000000000000000000000000000000000000
      000000000000000000000000FFFF000099FF000080FF000099FF000080FF0000
      0000993200FF00000000000000000000000000000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008080FF000000FF0000
      00FF000000FF008080FF000000000000000000000000868686FFFFFFFFFF8686
      86FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7
      E7FF070707FFFFFFFFFF545454FF0000000000000000FFCC99FFF2EABFFFF2EA
      BFFFCCCCCCFFECC6D9FF009900FFCCCCCCFFCCCCCCFFCCCCCCFFFFFFCCFFB2B2
      B2FF636E70FFCCCCCCFF00000000000000000000000000000000000000000000
      000000000000000000000000FFFF000099FF000099FF000080FF000099FF0000
      80FF0000000000000000000000000000000000000000808080FFFFFFFFFFFFFF
      FFFF808080FF808080FF808080FF808080FFFFFFFFFFFFFFFFFF000000FF0000
      00000000000000000000000000000000000000000000868686FFFFFFFFFF8686
      86FFFFFFFFFFFFFFFFFF000080FFFFFFFFFFFFFFFFFF008000FF008000FFD6E7
      E7FF070707FFFFFFFFFF545454FF0000000000000000FFCC99FFFFCC99FFE5E5
      E5FFECC6D9FFECC6D9FF009900FF009900FF009900FF009900FF99CC99FFF2EA
      BFFF808080FFB2B2B2FFE2EFF1FF000000000000000000000000000000000000
      000000000000FFFFFFFFCC9965FF000099FF000099FF000099FF0000FFFF0000
      99FF000080FF00000000000000000000000000000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008080FF808080FF8080
      80FF808080FF808080FF000000000000000000000000868686FFFFFFFFFF8686
      86FFFFFFFFFF000080FF0000FFFFFFFFFFFFFF0000FFFFFF00FFFF0000FFD6E7
      E7FF070707FFFFFFFFFF545454FF00000000E5E5E5FFFFCC99FFE5E5E5FFE5E5
      E5FFECC6D9FFC0C0C0FF009900FF009900FF65CC65FFCCFFCCFF32CC32FFFFCC
      99FF808080FFB2B2B2FFE2EFF1FF000000000000000000000000000000000000
      000000000000FFFFFFFFFFCC99FFFFCC99FF000099FF0000FFFF0000FFFF0000
      FFFF000099FF000080FF000000000000000000000000808080FFFFFFFFFFFFFF
      FFFF808080FF808080FF808080FF808080FFFFFFFFFF008080FF00FFFFFF00FF
      FFFFC0C0C0FF000000FF000000000000000000000000868686FFFFFFFFFF8686
      86FFFFFFFFFF00FFFFFF000080FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFD6E7
      E7FF070707FFFFFFFFFF545454FF00000000F2EABFFFF2EABFFFFFFFFFFFFFFF
      FFFFCC9999FFECC6D9FF99CC99FFCCCC99FF32CC32FF99CC99FF99CC99FFCCCC
      99FF999999FF999999FFE5E5E5FF000000000000000000000000000000000000
      0000FFFFFFFFFFCC99FFFFCC99FFFFFFFFFFFFFFFFFF0000FFFF3299FFFF3299
      FFFF3299FFFF000099FF000000000000000000000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF808080FF000000FF008080FF00FFFFFF00FF
      FFFF00FFFFFFC0C0C0FF000000FF0000000000000000868686FFFFFFFFFF8686
      86FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6E7
      E7FF070707FFFFFFFFFF545454FF00000000F2EABFFFFFFFCCFFFFFFFFFFECC6
      D9FFCC9999FFECC6D9FF659932FFFFFFFFFF65CC65FF009900FF009900FFF2EA
      BFFF999999FF999999FFE5E5E5FF00000000000000000000000000000000FFFF
      FFFFFFCC99FFFFCC99FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000099FF0000
      99FF000099FF00000000000000000000000000000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF800000FF000000FF00FF
      FFFF00FFFFFF00FFFFFFC0C0C0FF000000FF00000000868686FFFFFFFFFF8686
      86FF990000FF990000FF990000FF990000FF990000FF990000FF990000FF9900
      00FF070707FFFFFFFFFF545454FF00000000F2EABFFFFFFFFFFFFFFFFFFFECC6
      D9FFECC6D9FFECC6D9FF99CC99FF009900FF329932FF009900FF009900FFF2EA
      BFFFCCCC99FF808080FFE5E5E5FF000000000000000000000000FFFFFFFFFFCC
      99FFFFCC99FFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FF000000000000
      00000000000000000000000000000000000000000000808080FFFFFFFFFFFFFF
      FFFFFFFFFFFFC0C0C0FF000000FF000000FF000000FF008080FF808080FF0000
      00FF00FFFFFF00FFFFFF00FFFFFF000000FF00000000868686FFFFFFFFFF8686
      86FF990000FF32CCFFFF990000FF990000FF990000FF990000FF990000FF9900
      00FF070707FFFFFFFFFF545454FF00000000FFFFCCFFFFFFCCFFFFFFCCFFFFFF
      FFFFFFFFFFFFE2EFF1FFE5E5E5FF99CC99FF99CC99FF65CC65FF009900FFFFFF
      CCFFC0C0C0FF808080FFCCCCCCFF0000000000000000FFFFFFFFFFCC99FFFFCC
      99FFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      00000000000000000000000000000000000000000000808080FF808080FF8080
      80FF808080FF808080FF000000FF00FFFFFF00FFFFFFC0C0C0FF808080FF8080
      80FFC0C0C0FF00FFFFFF00FFFFFF000000FF00000000868686FFFFFFFFFF8686
      86FF868686FF868686FF868686FF868686FF868686FF868686FF868686FF8686
      86FF070707FFCBCBCBFF545454FF00000000FFFFCCFFFFFFCCFFFFFFCCFFFFFF
      CCFFE2EFF1FFE2EFF1FFE2EFF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFCCFF636E70FFCCCCCCFF00000000FFFFFFFFFFCC99FFFFCC99FFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008080FF00FFFFFF00FFFFFF00FFFFFF008080FF0080
      80FF00FFFFFF00FFFFFF00FFFFFF000000FF00000000868686FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9999
      99FF545454FF545454FF545454FF00000000F2EABFFFF2EABFFFF2EABFFFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE2EFF1FFF2EABFFFFFFF
      CCFFFFFFCCFF636E70FFCCCCCCFF00000000CC9965FFFFCC99FFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF0000FFFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFFC0C0C0FF808080FF00000000868686FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9999
      99FFFFFFFFFF545454FF000000000000000000000000E5E5E5FFE5E5E5FF99CC
      FFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFE2EFF1FF99CCFFFFFFCC99FFFFCC
      99FFFFFFCCFF808080FFE5E5E5FF0000000000000000CC9965FFFFFFFFFFFFFF
      FFFFCC9965FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008080FF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFFC0C0C0FF008080FF0000000000000000868686FFD6E7E7FFD6E7
      E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FFD6E7E7FF9999
      99FF545454FF000000000000000000000000000000000000000000000000E2EF
      F1FF99CCFFFF99CCFFFF99CCFFFFCCFFFFFFCCFFFFFF99CCFFFFFFCC99FFFFCC
      99FFFFCC99FFC0C0C0FFE2EFF1FF000000000000000000000000CC9965FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000008080FF008080FF0080
      80FF008080FF008080FF000000000000000000000000868686FF868686FF8686
      86FF868686FF868686FF868686FF868686FF868686FF868686FF868686FF9999
      99FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000099CCFFFF99CCFFFF99CCFFFFF2EABFFFF2EA
      BFFFE5E5E5FFE2EFF1FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FF000000FF0000
      00FF0000000000000000000000000000000000000000CC9965FF00000000CC99
      65FF00000000CC9965FF00000000CC9965FF00000000993200FF993200FF9932
      00FF993200FF993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF000000005E584EFF5E4239FF5E42
      39FF5E584EFF0000000000000000000000000000000000000000000000000000
      00005E584EFF5E4239FF5E4239FF5E584EFF0000000000000000000000000000
      00FF009932FF000000FFFF0000FFFF6532FFFF0000FFFF0000FFFF0000FFFF00
      00FF000000FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF00000000B48955FF957B66FF957B
      66FFB48955FF000000000000000000000000146CA2FF00000000000000000000
      0000B48955FF957B66FF957B66FFB48955FF0000000000000000009932FF0099
      32FF009932FF009932FF000000FFFF6532FFFF6532FFFF6532FFFF0000FFFF00
      00FF003200FF000000FF000000000000000000000000CC9965FF000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000146CA2FF9FE3FCFF146CA2FF000000000000
      00000000000000000000000000000000000000000000009932FF009932FF65FF
      32FF65FF32FF32CC32FF009932FF000000FFFF6532FFFF6532FF006500FF0065
      00FF006500FF006500FF000000FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      00000000000000000000146CA2FFA7E5FCFFA7E5FCFFA7E5FCFF146CA2FF0000
      00000000000000000000000000000000000000000000009932FF65FF32FF65FF
      32FF65FF32FF32CC32FF009932FF000000FFFF9900FF006500FF009932FF0099
      32FF006500FF006500FF000000FF0000000000000000CC9965FF000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000001877ABFFB3E8FCFFB3E8FCFFB3E8FCFFB3E8FCFFB3E8FCFF1877
      ABFF00000000000000000000000000000000009932FFCCFFCCFFCCFFCCFFCCFF
      CCFF32CC32FF006500FF006500FFFF9900FF006500FF32CC32FF009932FF0099
      32FF006500FF006500FF006500FF000000FF0000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000001A80B3FF1A80B3FF1A80B3FFC0ECFDFF1A80B3FF1A80B3FF1A80
      B3FF00000000000000000000000000000000009932FF009932FFFFFFFFFF32CC
      32FF006500FFFF9900FFFFCC32FFFFCC32FF006500FFCCFFCCFF32CC32FF0099
      32FF006500FF006500FF006500FF000000FF00000000CC9965FF000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      00000000000000000000000000001A80B3FFCFF0FDFF1A80B3FF000000000000
      000000000000000000000000000000000000FF6532FFFFFFCCFF009932FF0099
      32FFFF9900FFFFCC32FFFFCC32FFFFCC32FFFF9900FF006500FFCCFFCCFF32CC
      32FF009932FF006500FF006500FF000000FF0000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      00000000000000000000000000001A80B3FFDBF5FEFF1A80B3FF000000000000
      000000000000000000000000000000000000FF6532FFFFFFCCFFFFFF32FFFF99
      00FF006532FFFF6532FFFF9900FFFFCC32FFFF9900FFFF6532FFFF6532FF0065
      00FF32CC32FF009932FF006500FF000000FF00000000CC9965FF000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF993200FFFFFFFFFFCC9965FF00000000000000001A80B3FF1A80
      B3FF1A80B3FF1A80B3FF1A80B3FF7CC0D6FFE7F8FEFF1A80B3FF000000000000
      00000000000000000000000000000000000000000000FF6532FF006532FF0065
      32FF32CC32FF006532FFFF6532FFFFCC32FFFFCC32FFFF9900FFFF6532FFFF65
      32FF006500FF006500FF000000FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF000000001A80B3FFEFFAFEFFEFFA
      FEFFEFFAFEFFEFFAFEFFEFFAFEFFEFFAFEFF1A80B3FF76BAD2FF000000000000
      00000000000000000000000000000000000000000000009932FFFFFFFFFFCCFF
      CCFF32CC32FF32CC32FF006532FFFF9900FFFF9900FFFFCC32FFFF6532FFFF65
      32FFFF6532FFFF6532FF000000FF0000000000000000CC9965FF000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF993200FFFFFFFFFFCC9965FF00000000000000001A80B3FF1A80
      B3FF1A80B3FF1A80B3FF1A80B3FF1A80B3FF8FC5D9FF00000000000000000000
      0000000000000000000000000000000000000000000000000000009932FFFFFF
      FFFFCCFFCCFF32CC32FF32CC32FF006532FF006532FFFF9900FFFF6532FFFF65
      32FFFF6532FF800000FF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF000000000000000000000000CC9965FFFFFFFFFF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      32FFFFFFFFFFCCFFCCFFCCFFCCFF32CC32FF009932FF006532FFFF6532FFFF65
      32FFFF6532FF00000000000000000000000000000000CC9965FF00000000CC99
      65FF00000000CC9965FF00000000CC9965FF00000000993200FF993200FF9932
      00FF993200FF993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000009932FF009932FFFFFFFFFF32CC32FF32CC32FF009932FFFF6532FFFF65
      32FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000009932FF009932FF009932FF009932FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF9900FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF9900FFCC6500FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC65
      00FF0000000000000000000000000000000000000000656565FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FF656565FF656565FF6565
      65FF656565FF656565FF656565FF656565FF656565FF656565FF656565FF6565
      65FF656565FF656565FF656565FF656565FFFF9900FFCC6500FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFCC65
      00FF0000000000000000000000000000000000000000CCCCCCFF656565FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FF993200FF9932
      00FF993200FF993200FF00000000CC9965FF00000000CC9965FF00000000CC99
      65FF00000000CC9965FF0000000000000000999999FFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC65
      00FF000000000000000000000000000000000000000000000000CCCCCCFF6565
      65FF0000000000000000FF9900FF993200FF993200FF993200FF000000000000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCC65
      00FF00000000000000000000000000000000000000000000000000000000CCCC
      CCFF656565FFFF9900FFCC6500FFCC6500FFCC6500FFCC6500FF993200FF0000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000CC9965FF0000000000000000999999FFFFFFFFFFCCFFFFFFCCFF
      FFFF993200FF993200FF993200FF993200FF993200FF993200FFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFCC65
      00FF000000000000000000000000000000000000000000000000000000000000
      0000FF9900FFCC6500FFFF9900FFCC6500FFCC6500FFCC6500FF993200FF0000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FFCCFFFFFFFFFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFE5E5E5FFE5E5
      E5FFE5E5E5FFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCC65
      00FF00000000000000000000000000000000000000000000000000000000FF99
      00FFCC6500FFFF9900FFFF9900FFFF9900FFCC6500FFCC6500FF993200FF0000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000CC9965FF0000000000000000999999FFFFFFFFFFFFFFFFFFCCFF
      FFFF993200FF993200FF993200FF993200FF993200FF993200FFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFFFFFFFFFFFFF
      FFFFFFFFFFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFCC65
      00FF00000000000000000000000000000000000000000000000000000000CC65
      00FFFF9965FFFF9965FFFF9900FFFF9900FFCC6500FFCC6500FF993200FF0000
      00000000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FFFFFFFFFFCCFFFFFFFFFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFE5E5E5FFE5E5
      E5FFCCCCCCFFCCCCCCFFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FF000000000000000000000000CC65
      00FFFFFFFFFFFFFFFFFFFF9965FFCC6500FFFF9900FFCC6500FFCC6500FF9932
      00FF0000000000000000000000000000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000CC9965FF0000000000000000999999FFFFFFFFFFFFFFFFFFCCFF
      FFFFFFFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFF0000CCFF000099FFCCFFFFFF656565FFFF9900FFCC6500FFFFFFFFFFFFFF
      FFFFE5E5E5FFCC6500FFFF9900FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FF000000000000000000000000CC65
      00FFFF9965FFFF9965FFCC6500FFFFFFFFFFFF9965FFFF9900FFCC6500FF9932
      00FF993200FF993200FF993200FF0000000000000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFF6500FFFF0000CCFFCCFFFFFF656565FFFF9900FFCC6500FFE5E5E5FFCCCC
      CCFFFF9900FFFF9900FFFF9900FFFF9900FFFF9900FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF000000000000000000000000000000000000
      0000CC6500FFCC6500FFCC6500FFCC6500FFFFFFFFFFFF9965FF993200FFCC65
      00FFCC6500FFCC6500FFCC6500FF993200FF00000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000CC9965FF0000000000000000999999FFFFFFFFFFFFFFFFFFFFFF
      FFFFCCFFFFFFFFFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFFCCFFFFFF656565FFFF9900FFCC6500FFFFFFFFFFFF99
      00FFFF9965FFFF9965FFFF9900FFFF9900FFFF9900FFFF9900FFFF9900FFCC65
      00FFCC6500FFCC6500FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC6500FFCC6500FFCC6500FFFF99
      00FFCC6500FFCC6500FFCC6500FF993200FF00000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FFFF9900FFCC6500FFFF9900FFFF99
      65FFFF9965FFFF9965FFFF9965FFFF9965FFFF9900FFFF9900FFFF9900FFFF99
      00FFCC6500FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC6500FFFF9965FFFF99
      00FFFF9900FFCC6500FFCC6500FF993200FF00000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      000000000000CC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF9900FFFF9900FFFF9965FFFF99
      65FFFF9965FFFF9965FFFF9965FFFF9965FFFF9965FFFF9965FFFF9900FFCC65
      00FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC6500FFFF9965FFFF99
      65FFFF9900FFCC6500FFCC6500FFFF9900FF00000000993200FFCC9965FFCC99
      65FFCC9965FF993200FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF9900FF999999FFFFFF
      FFFF999999FFFFFFFFFF999999FFFFFFFFFF999999FFFFFFFFFF999999FFFFFF
      FFFF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC6500FFFFFFFFFFFF99
      65FFCC6500FFCC6500FFFF9900FF0000000000000000993200FF993200FF9932
      00FF993200FF993200FF00000000CC9965FF00000000CC9965FF00000000CC99
      65FF00000000CC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000999999FFCCCC
      CCFF999999FFCCCCCCFF999999FFCCCCCCFF999999FFCCCCCCFF999999FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC6500FFCC65
      00FFCC6500FFFF9900FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF00000000CCCCCCFFC0C0C0FFE5E5
      E5FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCCCFFC0C0C0FFE5E5
      E5FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCCCFFC0C0C0FFE5E5
      E5FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCCCCCCFF659999FF656599FF9999
      99FFE5E5E5FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CCCCCCFF659999FF656599FF9999
      99FFE5E5E5FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CCCCCCFF659999FF656599FF9999
      99FFE5E5E5FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000065CCFFFF3299CCFF6565
      99FF999999FFE5E5E5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000065CCFFFF3299CCFF6565
      99FF999999FFE5E5E5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000065CCFFFF3299CCFF6565
      99FF999999FFE5E5E5FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFFFFFFFFFFFFFFFFFCC9965FF00000000CCCCFFFF65CCFFFF3299
      CCFF656599FF999999FFE5E5E5FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCFFFF65CCFFFF3299
      CCFF656599FF999999FFE5E5E5FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCFFFF65CCFFFF3299
      CCFF656599FF999999FFE5E5E5FF000000000000000000000000000000000000
      000000000000000000000000000000000000000099FF0000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000CCCCFFFF65CC
      FFFF3299CCFF656599FF999999FFE5E5E5FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CCCCFFFF65CC
      FFFF3299CCFF656599FF999999FFE5E5E5FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CCCCFFFF65CC
      FFFF3299CCFF656599FF999999FFE5E5E5FF0000000000000000000000000000
      0000000000000000000000000000000000000000CCFF000099FF00000000CC99
      65FFFFFFFFFF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF000000000000000000000000CCCC
      FFFF65CCFFFF3299CCFF656599FFCCCCCCFFFFCCCCFFCC9999FFCC9999FFCC99
      99FFCCCC99FFE5E5E5FF0000000000000000000000000000000000000000CCCC
      FFFF65CCFFFF3299CCFF656599FFCCCCCCFFFFCCCCFFCC9999FFCC9999FFCC99
      99FFCCCC99FFE5E5E5FF0000000000000000000000000000000000000000CCCC
      FFFF65CCFFFF3299CCFF656599FFCCCCCCFFFFCCCCFFCC9999FFCC9999FFCC99
      99FFCCCC99FFE5E5E5FF00000000000000000000FFFF0000CCFF000099FFCC99
      65FFFFFFFFFF993200FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      0000CCCCFFFF65CCFFFFB2B2B2FFCC9999FFCCCC99FFF2EABFFFFFFFCCFFF2EA
      BFFFF2EABFFFCC9999FFECC6D9FF000000000000000000000000000000000000
      0000CCCCFFFF65CCFFFFB2B2B2FFCC9999FFCCCC99FFF2EABFFFFFFFCCFFF2EA
      BFFFF2EABFFFCC9999FFECC6D9FF000000000000000000000000000000000000
      0000CCCCFFFF65CCFFFFB2B2B2FFCC9999FFCCCC99FFF2EABFFFFFFFCCFFF2EA
      BFFFF2EABFFFCC9999FFECC6D9FF000000000000FFFF0000CCFF00000000CC99
      65FFFFFFFFFF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000E5E5E5FFCC9999FFFFCC99FFFFFFCCFFFFFFCCFFFFFFCCFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9999FFE5E5E5FF0000000000000000000000000000
      000000000000E5E5E5FFCC9999FFFFCC99FFFFFFCCFFFFFFCCFFFFFFCCFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9999FFE5E5E5FF0000000000000000000000000000
      000000000000E5E5E5FFCC9999FFFFCC99FFFFFFCCFFFFFFCCFFFFFFCCFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9999FFE5E5E5FF0000FFFF0000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000FFCCCCFFCCCC99FFFFFFCCFFF2EABFFFFFFFCCFFFFFFCCFFFFFF
      FFFFFFFFFFFFFFFFFFFFF2EABFFFCCCC99FF0000000000000000000000000000
      000000000000FFCCCCFFCCCC99FFFFFFCCFFF2EABFFFFFFFCCFFFFFFCCFFFFFF
      FFFFFFFFFFFFFFFFFFFFF2EABFFFCCCC99FF0000000000000000000000000000
      000000000000FFCCCCFFCCCC99FFFFFFCCFFF2EABFFFF2EABFFFCC6532FFFFFF
      FFFFFFFFFFFFFFFFFFFFF2EABFFFCCCC99FF000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000CCCC99FFFFCC99FFF2EABFFFF2EABFFFFFFFCCFFFFFFCCFFFFFF
      CCFFFFFFFFFFFFFFFFFFF2EABFFFCC9999FF0000000000000000000000000000
      000000000000CCCC99FFFFCC99FFF2EABFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFFFFFFFFFF2EABFFFCC9999FF0000000000000000000000000000
      000000000000CCCC99FFF2EABFFFF2EABFFFFFCC99FFFFCC99FFCC6532FFF2EA
      BFFFF2EABFFFFFFFFFFFF2EABFFFCC9999FF000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000CC9999FFF2EABFFFF2EABFFFF2EABFFFF2EABFFFFFFFCCFFFFFF
      CCFFFFFFCCFFFFFFCCFFFFFFCCFFCC9999FF0000000000000000000000000000
      000000000000CC9999FFF2EABFFFF2EABFFFE0CC65FFCC6500FFCC6500FFCC65
      00FFCC6500FFFFFFCCFFFFFFCCFFCC9999FF0000000000000000000000000000
      000000000000CC9999FFF2EABFFFF2EABFFFCC6500FFCC6532FFCC6532FFCC65
      32FFCC6532FFFFFFCCFFFFFFCCFFCC9999FF000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000CCCC99FFF2EABFFFFFFFCCFFF2EABFFFF2EABFFFF2EABFFFFFFF
      CCFFFFFFCCFFFFFFCCFFF2EABFFFCC9999FF0000000000000000000000000000
      000000000000CCCC99FFF2EABFFFFFFFCCFFF2EABFFFFFFFCCFFFFFFCCFFFFFF
      CCFFFFFFCCFFFFFFCCFFF2EABFFFCC9999FF0000000000000000000000000000
      000000000000CCCC99FFF2EABFFFF2EABFFFFFCC99FFFFCC99FFCC6532FFF2EA
      BFFFF2EABFFFFFFFCCFFF2EABFFFCC9999FF000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000FFCCCCFFCCCC99FFFFFFFFFFFFFFFFFFF2EABFFFF2EABFFFF2EA
      BFFFF2EABFFFFFFFCCFFCCCC99FFCCCC99FF0000000000000000000000000000
      000000000000FFCCCCFFCCCC99FFFFFFFFFFFFFFFFFFF2EABFFFF2EABFFFF2EA
      BFFFF2EABFFFFFFFCCFFCCCC99FFCCCC99FF0000000000000000000000000000
      000000000000FFCCCCFFCCCC99FFFFFFCCFFFFFFCCFFFFCC99FFCC6532FFFFFF
      CCFFF2EABFFFFFFFCCFFCCCC99FFCCCC99FF000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000E5E5E5FFCC9999FFECC6D9FFFFFFFFFFFFFFCCFFF2EABFFFF2EA
      BFFFF2EABFFFFFCC99FFCC9999FFE5E5E5FF0000000000000000000000000000
      000000000000E5E5E5FFCC9999FFECC6D9FFFFFFFFFFFFFFCCFFF2EABFFFF2EA
      BFFFF2EABFFFFFCC99FFCC9999FFE5E5E5FF0000000000000000000000000000
      000000000000E5E5E5FFCC9999FFE5E5E5FFFFFFFFFFF2EABFFFF2EABFFFF2EA
      BFFFF2EABFFFFFCC99FFCC9999FFE5E5E5FF000000000000000000000000CC99
      65FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      00000000000000000000FFCCCCFFCC9999FFFFCCCCFFF2EABFFFF2EABFFFF2EA
      BFFFCCCC99FFCC9999FFFFCCCCFF000000000000000000000000000000000000
      00000000000000000000FFCCCCFFCC9999FFFFCCCCFFF2EABFFFF2EABFFFF2EA
      BFFFCCCC99FFCC9999FFFFCCCCFF000000000000000000000000000000000000
      00000000000000000000FFCCCCFFCC9999FFFFCCCCFFF2EABFFFF2EABFFFF2EA
      BFFFFFCC99FFCC9999FFFFCCCCFF00000000000000000000000000000000CC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000000000000000
      0000000000000000000000000000E5E5E5FFCCCC99FFCC9999FFCC9999FFCC99
      99FFCC9999FFE5E5E5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000E5E5E5FFCCCC99FFCC9999FFCC9999FFCC99
      99FFCC9999FFE5E5E5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000E5E5E5FFCCCC99FFCC9999FFCC9999FFCC99
      99FFCC9999FFE5E5E5FF00000000000000000000000000000000D9D9D9FFCDCD
      CDFFBEBEBEFF9E9E9EFF8A8A8AFF7C7C7CFF7C7C7CFF8A8A8AFF9E9E9EFFBEBE
      BEFFCDCDCDFFD8D8D8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E9E8
      E9FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE8E8E8FF0000000000000000000000000000000000000000000000000000
      000000000000993200FF993200FFCC6500FF993200FFCC6500FF993200FF0000
      0000000000000000000000000000000000000000000000000000E4E4E4FFA9A9
      A9FF8F8D8DFFBDB2B2FFEBDADAFFEBDADAFFEBDADAFFEBDADAFFBDB2B2FF8F8D
      8DFFA9A9A9FFE3E3E3FF0000000000000000000000007EBBD4FF007BAFFF0084
      B7FF008CBFFF0095C8FF009CCFFF00A2D5FF00A2D5FF009CCFFF0095C8FF008C
      BFFF0084B7FF007BAFFF7EBBD4FF000000000000000000000000E8E8E8FFD4D4
      D4FFBBBBC2FF7E7EA1FF535390FF393982FF393982FF535390FF7E7EA1FFBBBB
      C2FFD2D2D2FFE7E7E7FF00000000000000000000000000000000000000000000
      000000000000993200FFCC6500FF993200FFCC6500FF993200FF993200FF0000
      0000000000000000000000000000000000000000000000000000B1B1B1FFA8A3
      A3FFE4D6D6FFC69689FFAD634DFF943211FF943211FFAD634DFFC69689FFE3D6
      D6FFA7A3A3FFB1B1B1FF0000000000000000000000000078ACFF00B7EAFF00CC
      FFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CC
      FFFF00CCFFFF00B7EAFF0078ACFF00000000000000000000000000000000B2B2
      CBFF404097FF2222A8FF1616C6FF1212D5FF1212D5FF1616C6FF2222A8FF4040
      97FFB2B2CBFF0000000000000000000000000000000000000000000000000000
      000000000000993200FF993200FFCC6500FF993200FFCC6500FF993200FF0000
      00000000000000000000000000000000000000000000C4C4C4FFABA8A8FFDBD1
      D1FFAC563BFFB6451EFFD65829FFE5612FFFE5612FFFD65829FFB6451EFFAC56
      3BFFDACFCFFFAAA7A7FFC4C4C4FF0000000000000000007CB0FF0CCFFFFF0CCF
      FFFF0CCFFFFF0CCFFFFF0CCFFFFF0076AAFF323232FF0CCFFFFF0CCFFFFF0CCF
      FFFF0CCFFFFF0CCFFFFF007CB0FF000000000000000000000000B2B2D8FF3434
      9FFF1818C6FF1111B6FF1010D1FF1010D1FF1010D1FF1010D1FF1010B6FF1616
      C5FF33339FFFB2B2D8FF00000000000000000000000000000000000000000000
      000000000000999999FF993200FF993200FF993200FF993200FF999999FF0000
      00000000000000000000000000000000000000000000A5A4A4FFD4CECEFFB35E
      43FFC9562EFFE16031FFD3582CFFEDEDEDFFEEEEEEFFD3582CFFE15E2FFFC852
      29FFB35E43FFD0C9C9FFA4A3A3FF00000000000000007EBFD9FF0EAAD9FF1DD3
      FFFF1DD3FFFF1DD3FFFF1DD3FFFF0076AAFF323232FF1DD3FFFF1DD3FFFF1DD3
      FFFF1DD3FFFF0EAAD9FF7EBFD9FF0000000000000000E5E5F3FF4141A7FF2020
      C3FF1111B3FFDCDCDCFF1010B2FF1010C8FF1010C8FF1010B2FFEEEEEEFF1010
      B2FF1616BEFF4040A7FFE5E5F3FF000000000000000000000000000000000000
      00000000000000000000999999FFFFFFFFFFFFCCCCFF656565FF000000000000
      000000000000000000000000000000000000C7C7C7FFB9B7B7FFC09789FFBF55
      30FFD85E32FFD5592CFFCB5329FFE2E2E2FFEDEDEDFFCB5329FFD5592CFFD559
      2CFFBC4E28FFBF9588FFB1AEAEFFC7C7C7FF00000000000000000085B8FF31D8
      FFFF31D8FFFF31D8FFFF31D8FFFF31D8FFFF31D8FFFF31D8FFFF31D8FFFF31D8
      FFFF31D8FFFF0085B8FF0000000000000000000000009393CDFF2F2FB4FF1515
      C1FFD1D1D1FFD6D6D6FFDCDCDCFF1010ADFF1010ADFFEAEAEAFFEEEEEEFFEEEE
      EEFF1010BEFF2323ACFF9393CDFF000000000000000000000000000000000000
      00000000000000000000999999FFFFFFFFFFFFCCCCFF656565FF000000000000
      000000000000000000000000000000000000B4B4B4FFD0CFCFFFB9735CFFCF63
      3DFFC95329FFC95329FFC24F27FFD6D6D6FFE2E2E2FFC24F27FFC95329FFC953
      29FFC5532BFFB9735CFFC2C0C0FFB4B4B4FF00000000000000007EC4DDFF24B3
      DEFF48DDFFFF48DDFFFF48DDFFFF23AAD4FF3D8899FF48DDFFFF48DDFFFF48DD
      FFFF24B3DEFF7EC4DDFF0000000000000000000000005858B5FF3535C2FF1111
      B4FF1010B4FFD1D1D1FFD6D6D6FFDCDCDCFFE2E2E2FFE6E6E6FFEAEAEAFF1010
      B4FF1010B4FF1A1AB2FF5858B5FF000000000000000000000000000000000000
      00000000000000000000999999FFFFFFFFFFFFCCCCFF656565FF000000000000
      000000000000000000000000000000000000ACACACFFCCCCCCFFB95636FFD570
      4CFFBF4F29FFBD4D26FFB94A25FFCDCDCDFFD6D6D6FFB94A25FFBD4D26FFBD4D
      26FFC1532DFFB95636FFC0C0C0FFACACACFF000000000000000000000000008E
      C1FF61E3FFFF61E3FFFF61E3FFFF1892BFFF3E5E65FF61E3FFFF61E3FFFF61E3
      FFFF008EC1FF000000000000000000000000000000003A3AABFF4444CDFF2525
      B5FF1313ACFF1010AAFFD1D1D1FFD6D6D6FFDCDCDCFFE2E2E2FF1010AAFF1010
      AAFF1010AAFF1919B0FF3A3AABFF000000000000000000000000000000000000
      00000000000000000000999999FFFFFFFFFFFFCCCCFF656565FF000000000000
      000000000000000000000000000000000000AFAFAFFFCFCFCFFFBC5A3AFFDD7C
      5AFFC9613FFFBD522FFFB24824FFCCCCCCFFCDCDCDFFB14723FFB34824FFB348
      24FFBD5431FFBC5A3AFFC3C3C3FFAFAFAFFF0000000000000000000000007EC9
      E2FF3DBEE3FF7AE8FFFF7AE8FFFF0076AAFF323232FF7AE8FFFF7AE8FFFF3DBE
      E3FF7EC9E2FF000000000000000000000000000000003A3AAEFF4949D1FF3232
      BBFF2D2DB8FF12129FFFCECECEFFD1D1D1FFD6D6D6FFDCDCDCFF10109EFF1010
      A1FF1010A1FF1E1EADFF3A3AAEFF000000000000000000000000000000000000
      00000000000000000000999999FFFFFFFFFFFFCCCCFF656565FF000000000000
      000000000000000000000000000000000000BCBCBCFFDBDCDCFFC07B64FFDF80
      5DFFCF6846FFCF6846FFCA6341FFAE4725FFAC4422FFB04826FFAD4523FFAD45
      23FFC35F3DFFC07B64FFCBCCCCFFBCBCBCFF0000000000000000000000000000
      00000098CBFF94EEFFFF94EEFFFF0076AAFF323232FF94EEFFFF94EEFFFF0098
      CBFF00000000000000000000000000000000000000005858BDFF4D4DD5FF3636
      BFFF2222ABFFFFFFFFFFF7F7F7FFE8E8E8FFDEDEDEFFDBDBDBFFDCDCDCFF1010
      9BFF1515A0FF2E2EB6FF5858BDFF000000000000000000000000000000000000
      00000000000000000000656565FF656565FF656565FF656565FF000000000000
      0000000000000000000000000000656565FFD0D0D0FFC9CACAFFC9A295FFD573
      51FFE2815EFFD8714FFFCD6644FFFFFFFFFFFFFFFFFFCD6644FFD8714FFFDF7B
      59FFD16D4BFFC7A194FFBFC0C0FFD0D0D0FF0000000000000000000000000000
      00007ECDE7FF55C8E7FFABF3FFFF0076AAFF323232FFABF3FFFF55C8E7FF7ECD
      E7FF00000000000000000000000000000000000000009393D6FF4848CCFF4848
      D1FFFFFFFFFFFFFFFFFFFFFFFFFF4141CAFF4141CAFFFFFFFFFFFFFFFFFFFFFF
      FFFF4646CFFF4040C4FF9393D6FF0000000000000000656565FF656565FF0000
      000000000000656565FF999999FF999999FF999999FF999999FF656565FF0000
      00000000000000000000656565FF656565FF00000000B8B8B8FFDFE0E0FFC874
      59FFE28360FFEB8A67FFD56E4CFFFFFFFFFFFFFFFFFFD56E4CFFEA8865FFDF7D
      5BFFC87459FFD8D8D8FFB6B6B6FF000000000000000000000000000000000000
      00000000000000A1D4FFBFF8FFFFBFF8FFFFBFF8FFFFBFF8FFFF00A1D4FF0000
      00000000000000000000000000000000000000000000E5E5F6FF4545BEFF5B5B
      E3FF5050D9FFFFFFFFFF4E4ED7FF4E4ED7FF4E4ED7FF4E4ED7FFFFFFFFFF5050
      D9FF5555DDFF4444BDFFE5E5F6FF00000000999999FF999999FF999999FF6565
      65FF656565FF999999FFCCCCCCFFCCCCCCFFCCCCCCFF999999FF656565FF6565
      65FF656565FF656565FFCCCCCCFF656565FF00000000D3D3D3FFC1C1C1FFDFDF
      DFFFCB785DFFDB7957FFEE906DFFF49673FFF49572FFED8E6BFFDA7755FFCB78
      5DFFDBDCDCFFBEBEBEFFD3D3D3FF000000000000000000000000000000000000
      0000000000007ED1EBFF67D0EBFFD0FCFFFFD0FCFFFF67D0EBFF7ED1EBFF0000
      0000000000000000000000000000000000000000000000000000B2B2E4FF3E3E
      C0FF6060E9FF5E5EE7FF5A5AE3FF5A5AE3FF5A5AE3FF5A5AE3FF5E5EE7FF5D5D
      E5FF3D3DBFFFB2B2E4FF0000000000000000999999FFFFFFFFFFCCCCCCFFCCCC
      CCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFF999999FF9999
      99FF999999FFCCCCCCFF656565FF000000000000000000000000CACACAFFC2C2
      C2FFE6E6E6FFD7B0A3FFD08C74FFCD6B4AFFCD6B4AFFD08C74FFD6AFA2FFE3E4
      E4FFC1C1C1FFCACACAFF00000000000000000000000000000000000000000000
      0000000000000000000000A8DBFFDDFFFFFFDDFFFFFF00A8DBFF000000000000
      000000000000000000000000000000000000000000000000000000000000B2B2
      E5FF4646C2FF4C4CD5FF6161EBFF6A6AF3FF6969F3FF6060EAFF4B4BD4FF4646
      C2FFB2B2E5FF000000000000000000000000999999FFFFFFFFFFCCCCCCFFCCCC
      CCFFFFFFFFFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCCCC
      CCFFCCCCCCFF999999FF0000000000000000000000000000000000000000D6D6
      D6FFBDBDBDFFD2D2D2FFEAEAEAFFE6E6E6FFE6E6E6FFEAEAEAFFD1D1D1FFBDBD
      BDFFD6D6D6FF0000000000000000000000000000000000000000000000000000
      00000000000000000000BFEAF6FF00AADDFF00AADDFFBFEAF6FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5E5F6FF9393DBFF5757C7FF3A3ABEFF3A3ABEFF5757C7FF9393DBFFE5E5
      F6FF00000000000000000000000000000000999999FFFFFFFFFFFFFFFFFF9999
      99FF999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9999
      99FF999999FF0000000000000000000000000000000000000000000000000000
      000000000000D6D6D6FFC6C6C6FFBDBDBDFFBDBDBDFFC6C6C6FFD6D6D6FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000999999FF999999FF0000
      000000000000999999FF999999FF999999FF999999FF999999FF999999FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E2EFF1FF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E5E5
      E5FFC0C0C0FF656565FF4B4B4BFF4B4B4BFF4B4B4BFF4B4B4BFF4B4B4BFF8080
      80FFCCCCCCFFE2EFF1FF0000000000000000000000007D7975FF7D7975FF7D79
      75FF7D7975FF7D7975FF7D7975FF7D7975FF7D7975FF7D7975FF7D7975FF7D79
      75FF7D7975FF7D7975FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E2EF
      F1FFE5E5E5FFCCCCCCFFE5E5E5FFE2EFF1FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5E5E5FFB2B2
      B2FFECC6D9FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFC0C0C0FF4B4B
      4BFF636E70FFB2B2B2FFE5E5E5FF00000000000000007D7975FFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFF7D7975FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2EFF1FFE5E5E5FFB2B2
      B2FFCC9999FF996565FF996565FFB2B2B2FFCCCCCCFFE5E5E5FFE2EFF1FF0000
      00000000000000000000000000000000000000000000E5E5E5FFC0C0C0FFE5E5
      E5FFFFFFFFFFE5E5E5FFCC9999FFCC9999FFCCCCCCFFE2EFF1FFFFFFFFFFE5E5
      E5FF808080FF656565FFB2B2B2FFE2EFF1FF000000007D7975FFFEFEFEFFDEDE
      DEFFDEDEDEFFDEDEDEFFEAE2DEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDE
      DEFFFEFEFEFF7D7975FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E5FFCC9999FF996565FFCC99
      99FFCC9999FFFFFFFFFF996565FF999999FF999999FFB2B2B2FFE5E5E5FF0000
      00000000000000000000000000000000000000000000CCCCCCFFE5E5E5FFFFFF
      FFFFCC9999FFCC6500FFCC6532FFCC9999FFCC6532FFCC6532FFCC9999FFFFFF
      FFFFE5E5E5FF636E70FF636E70FFCCCCCCFF000000007D7975FFFEFEFEFFDEDE
      DEFFDEDEDEFF9AA2CEFF4161C6FF356DDAFF5D9AE6FFA6B2D2FFE2E2E2FFE2E2
      E2FFFEFEFEFF7D7975FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000996565FFCC9999FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FF326599FF326599FF326599FFE2EFF1FF0000
      000000000000000000000000000000000000E5E5E5FFE5E5E5FFFFFFFFFFCC65
      65FFCC3200FFCC6500FFCC9999FFFFFFFFFFCC9965FFCC3200FFCC3200FFCC99
      99FFFFFFFFFFE5E5E5FF4B4B4BFF999999FF000000007D7975FFFEFEFEFFE2E2
      E2FF6975BEFF0525AEFF1151D2FF0D61DEFF0969EAFF0971DEFF8EBAE6FFEAE2
      DEFFFEFEFEFF7D7975FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000996565FFFFCC99FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FF65CCCCFF65CCCCFF0099CCFFFFFFFFFFFFCC
      CCFF00000000000000000000000000000000E5E5E5FFFFFFFFFFCC9999FFCC32
      00FFCC6532FFCC6532FFCC6532FFCC9965FFCC6532FFCC6532FFCC6532FFCC32
      00FFCCCCCCFFE5E5E5FF999999FF656565FF0000000082827DFFFEFEFEFF9AA2
      CEFF092DB6FF1165DEFF1D51B6FF492D35FF292D59FF1582D6FF0971DEFFC2DA
      EEFFFEFEFEFF82827DFF00000000000000000000000000000000993200FF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF0000000000000000996565FFFFCC99FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FF65CCCCFF65CCFFFF3299CCFFFFCCCCFFCC65
      00FF00000000000000000000000000000000E5E5E5FFFFFFFFFFCC6532FFCC65
      32FFCC6532FFCC6532FFCC9965FFE5E5E5FFCC6532FFCC6532FFCC6532FFCC65
      32FFCC6565FFFFFFFFFFCCCCCCFF4B4B4BFF0000000082827DFFFEFEFEFF4161
      C6FF114DCAFF0951D2FF31599AFF516D8EFF863D09FF49596DFF19AAF6FF8EBA
      E6FFFEFEFEFF82827DFF00000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FF993200FF0000000000000000996565FFFFCC99FFCC9999FFCC99
      65FFFFCCCCFFFFFFFFFF996565FF99CCCCFF99CCFFFFB2B2B2FFFF6500FFCC65
      00FF00000000000000000000000000000000E5E5E5FFE5E5E5FFCC6532FFCC65
      32FFCC6532FFCC6532FFCC9965FFFFFFFFFFFF9999FFCC3200FFCC6532FFCC65
      32FFCC6532FFE2EFF1FFE5E5E5FF4B4B4BFF0000000082827DFFFEFEFEFF356D
      DAFF0545CEFF21359EFFC27D25FFC27D25FF964D15FF794D31FF31C6FAFF6DA2
      CEFFFAFAFAFF82827DFF00000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FF993200FF0000000000000000996565FFFFCC99FF996565FFFFFF
      FFFFFFCCCCFFFFFFFFFF996565FF99CCCCFFC0C0C0FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF00000000E5E5E5FFFFCCCCFFCC6532FFCC65
      32FFCC6532FFCC6532FFCC6532FFCCCC99FFFFFFFFFFCC9965FFCC6532FFCC65
      32FFCC6532FFE2EFF1FFE5E5E5FF4B4B4BFF000000008A8A86FFFEFEFEFF498A
      EAFF0945D2FF1555DAFF5D8AAAFFDEAA49FFDA9A39FF9E6129FF55BADAFF8ECE
      EAFFF6F6F6FF8A8A86FF00000000000000000000000000000000993200FF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF0000000000000000996565FFFFCC99FFCC9999FF9965
      65FFFFCCCCFFFFFFFFFF996565FF00000000CC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF00000000E5E5E5FFE5E5E5FFCC6532FFCC65
      32FFCC6532FFCC6532FFCC6532FFCC3200FFCCCCCCFFFFFFFFFFCC6532FFCC65
      32FFCC6532FFFFFFFFFFE5E5E5FF656565FF000000008A8A86FFFEFEFEFF8EBA
      E6FF1159D6FF1155CEFF8AA6AEFFF6EAA2FFF2D671FFB69E6DFF55BADAFFCEE6
      EEFFEEEEEEFF8A8A86FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000996565FFFFCC99FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FF00000000CC9999FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF00000000E5E5E5FFFFFFFFFFFF9965FFCC65
      32FFCC9965FFE5E5E5FFCC6565FFCC3200FFCC9965FFFFFFFFFFCC9965FFCC65
      00FFCC9965FFFFFFFFFFCCCCCCFF99A8ACFF000000008E8E8EFFFEFEFEFFE2EA
      F6FF9A9A9AFF926D49FFE2E6C2FFFEFAD6FFF6EAA2FFAAA686FFB2CEE2FFEAEA
      EAFFE2E2E2FF8E8E8EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000996565FFFFCC99FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FFCCCCCCFFE2EFF1FFCC9999FFFF6500FFCC65
      00FF00000000000000000000000000000000E5E5E5FFE2EFF1FFFFFFCCFFFF99
      32FFCC9965FFFFFFFFFFFFFFFFFFFFCC99FFFFFFFFFFFFFFFFFFCC6532FFFF65
      32FFFFFFFFFFE5E5E5FF999999FFE5E5E5FF000000008E8E8EFFFEFEFEFFFAFA
      FAFFFAFAFAFFDACAC2FFCEBAAAFFE6D6BAFFE6D6BAFFF2EAE6FFEAEAEAFFDEDE
      DEFFD2D2D2FF8E8E8EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000996565FFFFCC99FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FF99CCCCFF0000000099CCCCFFFFCC99FFCC65
      00FF0000000000000000000000000000000000000000E5E5E5FFFFFFFFFFF2EA
      BFFFFF9965FFFF9999FFE5E5E5FFE2EFF1FFE5E5E5FFFF9965FFFF9965FFFFCC
      CCFFFFFFFFFFF2EABFFFC0C0C0FF0000000000000000929292FFFEFEFEFFFAFA
      FAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFF6F6F6FFAEAEAEFFAEAE
      AEFF9A9A9AFF8E8E8EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000996565FFCC9999FFFFCC99FFFFCC
      99FFFFCCCCFFFFFFFFFF996565FFCCCCCCFF000000003299CCFF00000000FFCC
      99FF0000000000000000000000000000000000000000E5E5E5FFE5E5E5FFFFFF
      FFFFFFFFFFFFFFFFCCFFFFCC99FFFFCC99FFFFCC99FFFFCC99FFFFFFFFFFFFFF
      FFFFE5E5E5FFC0C0C0FFE2EFF1FF0000000000000000969696FFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFAFAFAFFFAFAFAFFF6F6F6FFAEAEAEFFEEEE
      EEFFAAAAA6FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C0FFCC9965FFCC99
      99FFCCCC99FFFFFFFFFF996565FF0099CCFF0099CCFF0099CCFF000000000000
      0000000000000000000000000000000000000000000000000000E5E5E5FFFFCC
      CCFFE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5FFFFCC
      CCFFCCCCCCFFE2EFF1FF000000000000000000000000969696FFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFAFAFAFFF6F6F6FFF2F2F2FF9A9A9AFFAAAA
      AAFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCCC
      CCFFCC9999FF996565FF996565FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5E5E5FFFFCCCCFFFFCCCCFFFFCCCCFFF2EABFFFFFCCCCFFE5E5E5FFE5E5
      E5FF00000000000000000000000000000000000000009A9A96FF9A9A96FF9A9A
      96FF9A9A96FF969696FF929292FF9A9A96FF969696FF929292FF8E8E8EFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B2BFCBFF0000
      00003084A6FF00000000ACBDCBFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CAD3DBFF2691B7FF30A1
      DFFF2DABE1FF0E85B9FF358BADFFB0C6D3FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005F90AFFF7E9EB7FF00000000CED9E2FF38A1E3FF3898
      C6FF78C1E4FF56AFE3FF088CBAFF000000000000000000000000000000000000
      00000000000000000000993200FF993200FF993200FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF0000000000000000000000000000000000000000993200FF9932
      00FF000000000000000000000000000000000000000000000000993200FF9932
      00FF993200FF993200FF0000000000000000000000000000000000000000267E
      A6FF59A3C5FFB7DAEAFF0085BFFF126DA5FFB0C9D7FF065F8EFF48A1D1FF1882
      A4FFFFFFFFFF62A8C9FF0E90C6FF619DB8FF0000000000000000000000000000
      00000000000000000000993200FFCC6500FFCC6500FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF00000000000000000000000000000000000000002798
      CCFF21ABE4FF00ABE6FF1BD3F3FF0AD8F3FF008DC1FF0094D5FF016474FF74AE
      CFFF2393B4FF45A0CFFF0698C6FF000000000000000000000000000000000000
      00000000000000000000993200FFCC6500FFCC6500FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF00000000000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF0000000000000000000000005BABCBFF58B2E0FF509E
      F3FF64B1F3FF53B2F3FF45B7F3FF37BAF3FF24C7F3FF10D9F3FF03ABE1FF1369
      87FF4BA2D8FF1293C4FF5592B0FFBFD0DBFF0000000000000000000000000000
      00000000000000000000993200FFCC6500FFCC6500FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FF993200FF000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF000000000000000000000000229BD0FF50B0F0FF6BB4
      F3FF61BDEEFF588A9FFF6A8DA2FF7EC6E8FF1A98CDFF18BBF3FF26BAF3FF0694
      CAFF1979A6FF00000000D5E0E7FF000000000000000000000000993200FF9932
      00FF993200FF993200FF993200FFCC6500FFCC6500FF993200FF993200FF9932
      00FF993200FF993200FF00000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FF993200FF0000000000000000993200FFCC65
      00FFCC6500FF993200FF000000000000000000000000B0DDF4FF66B4F3FF5DAC
      F0FF4B6E83FF000000000000000000000000C0E1F0FF3E9FD6FF53B7F3FF1DB9
      F3FFBFD6DCFF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FF993200FF00000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FF993200FF00000000993200FFCC65
      00FFCC6500FF993200FF00000000000000005DB9E0FF4FB4F3FF6AB8F3FF3E7E
      9AFFC2D7DDFF0000000000000000000000000000000069BCE2FF58B2F3FF30AB
      F3FF259CC8FF75A3BDFF00000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FF993200FF00000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FFCC6500FF993200FF0000000000000000993200FFCC65
      00FFCC6500FF993200FF000000000000000048B5DCFF4BAAF3FF6AB4F3FF3478
      91FFD5E3E8FF0000000000000000000000000000000066BBE2FF52ADF3FF32AC
      F3FF0084C3FF6A97B4FF00000000000000000000000000000000993200FF9932
      00FF993200FF993200FF993200FFCC6500FFCC6500FF993200FF993200FF9932
      00FF993200FF993200FF00000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FF993200FF000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF0000000000000000000000009FD2F8FF77B3F3FF50AB
      DDFF2E5C65FF000000000000000000000000CEE9F3FF45B0E1FF46B8F3FF29A6
      E7FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000993200FFCC6500FFCC6500FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF00000000000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF00000000000000000000000025A1D6FF73BBF3FF90C1
      F3FF1374A6FF1B4F5FFFB8D3DBFF97C5D7FF0E90BAFF5EB7E6FF78B2F3FF1FA0
      D5FF4286A5FF0000000000000000000000000000000000000000000000000000
      00000000000000000000993200FFCC6500FFCC6500FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FF993200FF0000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FF993200FF0000000000000000000000004FB4DEFF7EC7F1FF83C1
      F4FF91D3F3FF588A9DFF1F95BEFF1393C3FF52B9E1FF70B0F3FF38B4E8FF33AD
      DBFF52A1BCFF0000000000000000000000000000000000000000000000000000
      00000000000000000000993200FFCC6500FFCC6500FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993200FF9932
      00FF000000000000000000000000000000000000000000000000993200FF9932
      00FF993200FF993200FF000000000000000000000000000000000000000071C6
      F0FF6BC7F3FF8BD7F3FF8ED9F3FF87C8F3FF78B8ECFF29A5DAFF7DC7DEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000993200FF993200FF993200FF993200FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000048B7
      DBFF5EC3E6FFBDE5F3FF2DB1E7FF38ACEDFFA4D9EDFF0995BFFF81BED5FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001BA5CDFF4AB2D7FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000993200FF650000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CC9965FFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000000000000000
      000000000000993200FF993200FFCC6500FF993200FF650000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CC9965FFFFFFFFFFFFFFFFFFCC9965FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000009932
      00FF993200FF993200FFE5E5E5FFE5E5E5FFCCCCCCFF993200FF650000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CC9965FFFFFFFFFFFFFFFFFFCC9965FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFCC99
      65FFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF00000000993200FF993200FF9932
      00FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFCCCCCCFFCCCCCCFF993200FF6500
      00FF00000000000000000000000000000000CC9965FF00000000000000000000
      0000CC9965FFFFFFFFFFFFFFFFFFCC9965FF000000000000000000000000CC99
      65FF993200FFCC9965FF00000000000000000000000000000000000000000000
      000000000000993200FF993200FF000000000000000000000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFFFFF
      FFFFFFFFFFFFCC9965FFFFFFFFFF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF993200FF993200FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FF993200FF993200FF999999FF999999FFCCCCCCFF9932
      00FF650000FF000000000000000000000000CC9965FFCC9965FF000000000000
      0000CC9965FFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000009932
      00FF993200FF993200FF00000000000000000000000000000000000000000000
      000000000000993200FFCC6500FF993200FF0000000000000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFFFFF
      FFFFFFFFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF993200FFE5E5E5FFE5E5E5FFE5E5
      E5FF993200FF993200FF993200FF993200FF650000FF808080FF999999FF9999
      99FF993200FF650000FF0000000000000000CC9965FFFFFFFFFFCC9965FFCC99
      65FFFFFFFFFFFFFFFFFFCC9965FF00000000000000000000000000000000CC99
      65FF993200FFCC9965FF00000000000000000000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FF993200FF00000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFCC99
      65FFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF993200FFE5E5E5FF993200FF9932
      00FF993200FFCC6500FFCC6500FFCC6500FF993200FF650000FF656565FF9999
      99FF999999FF993200FF650000FF00000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FFCC6500FF993200FF000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF993200FF993200FF993200FFCC65
      00FFCC6500FF993200FF993200FFCC6500FFCC6500FF993200FF650000FF6565
      65FF999999FF808080FF993200FF650000FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFCC9965FFCC9965FF00000000CC99
      65FF993200FFCC9965FF00000000000000000000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FFCC6500FFCC6500FF993200FF0000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFCC99
      65FFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF993200FFFF9900FFCC6500FFCC65
      00FFCC6500FF00FFFFFF32CCFFFF993200FF993200FF993200FF993200FF6500
      00FF656565FF999999FF993200FF650000FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF00000000000000009932
      00FF993200FF993200FF00000000000000000000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FF9932
      00FF00000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFFFFF
      FFFFFFFFFFFFCC9965FFFFFFFFFF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FFFFFFFFFFCC9965FF00000000993200FFFF9900FFCC65
      00FFCC6500FFCC6500FFCC6500FF00FFFFFF00FFFFFF32CCFFFF326599FF9932
      00FF650000FF656565FF993200FF00000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF000000000000000000000000CC99
      65FF993200FF993200FFCC9965FF000000000000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FFCC6500FFCC6500FF993200FF0000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFFFFF
      FFFFFFFFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000993200FFFF99
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FF32CCFFFF00FFFFFF3265
      99FF993200FF650000FF993200FF00000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FF000000000000000000000000000000000000
      0000CC6500FF993200FF993200FFCC9965FF0000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FFCC6500FF993200FF000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FFCC99
      65FFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000009932
      00FFFF9900FFCC6500FFCC6500FF00FFFFFF00FFFFFF00FFFFFF3299CCFF3265
      99FF993200FF993200FF650000FF650000FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF00000000000000000000000000000000000000000000
      000000000000993200FF993200FF993200FF0000000000000000000000000000
      000000000000993200FFCC6500FFCC6500FF993200FF00000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      0000993200FFFF9900FFCC6500FFCC6500FF326599FF326599FF650065FF9932
      00FF993200FF993200FF650000FF00000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFCC9965FF00000000000000000000000000000000CC9965FF993200FFCC99
      65FF00000000CC9965FF993200FF993200FF0000000000000000000000000000
      000000000000993200FFCC6500FF993200FF0000000000000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000000000000000
      000000000000993200FFFF9900FFCC6500FFCC6500FFCC6500FF993200FF9932
      00FF650000FF000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFCC99
      65FF0000000000000000000000000000000000000000993200FF993200FF9932
      00FF00000000993200FF993200FF993200FF0000000000000000000000000000
      000000000000993200FF993200FF000000000000000000000000000000000000
      000000000000000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FFCC9965FFCCCCCCFFCCCCCCFFCCCCCCFFCCCCCCFFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000993200FFFF9900FFCC6500FF993200FF650000FF0000
      000000000000000000000000000000000000CC9965FFFFFFFFFFCC9965FF0000
      00000000000000000000000000000000000000000000CC9965FF993200FF9932
      00FF993200FF993200FF993200FFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFCC9965FFCC99
      65FFCC9965FF0000000000000000CC9965FFCC9965FFCC9965FFCC9965FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000993200FF650000FF00000000000000000000
      000000000000000000000000000000000000CC9965FFCC9965FF000000000000
      0000000000000000000000000000000000000000000000000000CC9965FF9932
      00FF993200FF993200FFCC9965FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003299CCFF006599FF006599FF006599FF006599FF0065
      99FF006599FF006599FF006599FF000000000000000000000000000000000000
      0000000000000000000000000000CC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF006599FF000000000000000000000000000000000000
      0000000000000000000000000000CC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF006599FF000000000000000000000000006599FF0065
      99FF006599FF006599FF006599FFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF006599FF00000000000000003299CCFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF006599FF00000000000000003299CCFFCCFFFFFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FF3299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF006599FF00000000000000003299CCFF99FFFFFFCCFF
      FFFF99FFFFFF99FFFFFF99FFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CC99
      65FF993200FF0000000000000000000000000000000000000000000000009932
      00FFCC9965FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF3299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF006599FF00000000000000003299CCFFCCFFFFFF99FF
      FFFFCCFFFFFF99FFFFFF99FFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF0000000000000000993200FF9932
      00FF993200FF993200FF993200FF000000000000000000000000000000000000
      0000993200FFCC9965FF00000000000000000000000000000000CC9965FF9932
      00FF0000000000000000000000000000000000000000993200FF993200FF9932
      00FF993200FF993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF3299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF3299
      CCFF3299CCFF3299CCFF3299CCFF00000000000000003299CCFF99FFFFFFCCFF
      FFFF99FFFFFFCCFFFFFF99FFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFCC9965FFCC9965FFCC9965FFCC9965FF0000000000000000993200FF9932
      00FF993200FF993200FF00000000000000000000000000000000000000000000
      000000000000993200FF00000000000000000000000000000000993200FF0000
      0000000000000000000000000000000000000000000000000000993200FF9932
      00FF993200FF993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF3299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF3299
      CCFFCCFFFFFF006599FF0000000000000000000000003299CCFFCCFFFFFF99FF
      FFFFCCFFFFFF99FFFFFFCCFFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFCC9965FFE5E5E5FFCC9965FF000000000000000000000000993200FF9932
      00FF993200FF0000000000000000000000000000000000000000000000000000
      000000000000993200FF00000000000000000000000000000000993200FF0000
      0000000000000000000000000000000000000000000000000000000000009932
      00FF993200FF993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF3299CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF3299
      CCFF006599FF000000000000000000000000000000003299CCFF99FFFFFFCCFF
      FFFF99FFFFFFCCFFFFFF99FFFFFFCC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFCC9965FFCC9965FF00000000000000000000000000000000993200FF9932
      00FF00000000993200FF00000000000000000000000000000000000000000000
      000000000000993200FF00000000000000000000000000000000993200FF0000
      0000000000000000000000000000000000000000000000000000993200FF0000
      0000993200FF993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF3299
      CCFF00000000000000000000000000000000000000003299CCFFCCFFFFFF99FF
      FFFFCCFFFFFF99FFFFFFCCFFFFFFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FF0000000000000000000000000000000000000000993200FF0000
      00000000000000000000993200FF993200FF0000000000000000000000000000
      0000993200FFCC9965FF00000000000000000000000000000000CC9965FF9932
      00FF00000000000000000000000000000000993200FF993200FF000000000000
      000000000000993200FF000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FF000000000000
      000000000000000000000000000000000000000000003299CCFFCCFFFFFFCCFF
      FFFF99FFFFFFCCFFFFFF99FFFFFFCCFFFFFF99FFFFFFCCFFFFFF99FFFFFF99FF
      FFFF006599FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000993200FF993200FF993200FF9932
      00FFCC9965FF000000000000000000000000000000000000000000000000CC99
      65FF993200FF993200FF993200FF993200FF0000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFCC9965FFCC9965FF000000000000
      000000000000000000000000000000000000000000003299CCFFCCFFFFFFCCFF
      FFFFCC6500FF993200FF993200FF993200FF993200FF993200FFCCFFFFFF99FF
      FFFF006599FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FFE5E5E5FFCC9965FF00000000000000000000
      000000000000000000000000000000000000000000003299CCFFCCFFFFFFCCFF
      FFFFCC6500FFFFFFFFFFFF9900FFFF9900FFFF9900FF993200FF99FFFFFFCCFF
      FFFF006599FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FF0000000000000000000000000000
      00000000000000000000000000000000000000000000000000003299CCFF3299
      CCFF3299CCFFCC6500FFFFFFFFFFFF9900FF993200FF3299CCFF3299CCFF3299
      CCFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CC6500FFCC6500FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000993200FF993200FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FF993200FF0000
      00000000000000000000000000000000000000000000CC6500FF993200FF9932
      00FFCC6500FF000000000000000000000000000000000000000000000000CC65
      00FF993200FF993200FFCC6500FF000000000000000000000000000000000000
      99FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FFFF000000000000000000000000000000000000
      0000993200FFCC6500FF993200FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FFCC6500FF9932
      00FF00000000000000000000000000000000CC6500FF993200FF000000000000
      0000993200FFCC6500FF00000000000000000000000000000000CC6500FF9932
      00FF0000000000000000993200FFCC6500FF00000000000000003232CCFF0000
      FFFF000099FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FF993200FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FF993200FFCC6500FFCC65
      00FF993200FF000000000000000000000000CC6500FF993200FF000000000000
      000000000000993200FF00000000000000000000000000000000993200FF0000
      00000000000000000000993200FFCC6500FF00000000000000003232CCFF3299
      FFFF0000FFFF000099FF00000000000000000000000000000000000000000000
      0000000000000000FFFF00000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FFCC6500FFCC65
      00FFCC6500FF993200FF000000000000000000000000CC6500FF993200FF0000
      000000000000993200FFCC6500FF0000000000000000CC6500FF993200FF0000
      000000000000993200FFCC6500FF000000000000000000000000000000003232
      CCFF0065FFFF0000CCFF00000000000000000000000000000000000000000000
      00000000FFFF00000000000000000000000000000000993200FFCC6500FFCC65
      00FFCC6500FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC9965FFCC9965FFFFFFFFFFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF993200FFCC6500FFCC65
      00FFCC6500FFCC6500FF993200FF000000000000000000000000CC6500FF9932
      00FF993200FF993200FF993200FFCC6500FFCC6500FF993200FF993200FF9932
      00FF993200FFCC6500FF00000000000000000000000000000000000000000000
      00000000CCFF0000FFFF000099FF000000000000000000000000000000000000
      FFFF000099FF000000000000000000000000993200FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF993200FF0000000000000000000000000000
      0000993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000CCFF0000FFFF000099FF00000000000000000000FFFF0000
      99FF0000000000000000000000000000000000000000993200FFCC6500FFCC65
      00FFCC6500FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC9965FFCC9965FFFFFFFFFFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF993200FFCC6500FFCC65
      00FFCC6500FFCC6500FF993200FF000000000000000000000000000000000000
      000000000000993200FF999999FFFFFFFFFFFFFFFFFF999999FF993200FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000CCFF0000FFFF000099FF0000FFFF000099FF0000
      0000000000000000000000000000000000000000000000000000993200FFCC65
      00FFCC6500FFCC6500FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FFCC6500FFCC65
      00FFCC6500FF993200FF00000000000000000000000000000000000000000000
      000000000000999999FFFFFFFFFF656565FF656565FFFFFFFFFF656565FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000CCFF0000FFFF000099FF000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FFCC6500FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC9965FFCC9965FFFFFFFFFFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF993200FFCC6500FFCC65
      00FF993200FF0000000000000000000000000000000000000000000000000000
      0000999999FFFFFFFFFFCCCCCCFFCCCCCCFFFFFFFFFF656565FFCCCCCCFF6565
      65FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000CCFF0000FFFF000099FF0000CCFF000099FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000993200FFCC6500FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF993200FFCC6500FF9932
      00FF000000000000000000000000000000000000000000000000000000009999
      99FFFFFFFFFFCCCCCCFFCCCCCCFF656565FF999999FFFFFFFFFFCCCCCCFFCCCC
      CCFF656565FF0000000000000000000000000000000000000000000000000000
      0000000000000000CCFF0000FFFF000099FF00000000000000000000CCFF0000
      99FF000000000000000000000000000000000000000000000000000000000000
      0000CC9965FF993200FF993200FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC9965FFCC9965FFFFFFFFFFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF993200FF993200FFCC99
      65FF000000000000000000000000000000000000000000000000999999FFFFFF
      FFFFCCCCCCFFCCCCCCFF656565FF0000000000000000999999FFFFFFFFFFCCCC
      CCFFCCCCCCFF656565FF00000000000000000000000000000000000000000000
      CCFF0000FFFF0000FFFF000099FF000000000000000000000000000000000000
      CCFF000099FF0000000000000000000000000000000000000000000000000000
      0000CC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC99
      65FF0000000000000000000000000000000000000000999999FFFFFFFFFFCCCC
      CCFFCCCCCCFF656565FF00000000000000000000000000000000999999FFFFFF
      FFFFCCCCCCFFCCCCCCFF656565FF0000000000000000000000000000CCFF3299
      FFFF0000FFFF000099FF00000000000000000000000000000000000000000000
      00000000CCFF000099FF00000000000000000000000000000000000000000000
      0000CC9965FFFFFFFFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC9965FFCC9965FFFFFFFFFFE5E5E5FFE5E5
      E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC99
      65FF00000000000000000000000000000000999999FFFFFFFFFFCCCCCCFFCCCC
      CCFF656565FF0000000000000000000000000000000000000000000000009999
      99FFFFFFFFFFCCCCCCFFCCCCCCFF656565FF0000000000000000656599FF0000
      CCFF656599FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000CCFF000000000000000000000000000000000000
      0000CC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC99
      65FF00000000000000000000000000000000999999FFFFFFFFFFCCCCCCFF6565
      65FF000000000000000000000000000000000000000000000000000000000000
      0000999999FFFFFFFFFFCCCCCCFF656565FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC9965FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC9965FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC99
      65FF00000000000000000000000000000000999999FFFFFFFFFF656565FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000999999FFFFFFFFFF656565FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FF00000000000000000000000000000000999999FF999999FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000999999FF999999FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF993200FF993200FF0000000000000000000000006E6E
      6EFF6B6B6BFF6D6D6DFF6D6D6DFF6D6D6DFF6D6D6DFF6D6D6DFF6D6D6DFF6B6B
      6BFF6B6B6BFF6E6E6EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993200FF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF993200FF000000000000000000000000993200FFCC65
      00FFCC6500FF993200FFE5E5E5FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5
      E5FF993200FFCC6500FFCC6500FF993200FF0000000000000000000000006E6E
      6EFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFE5E5E5FF6E6E6EFF0000000000000000000000003299CCFF006599FF0065
      99FF006599FF006599FF006599FF006599FF006599FF006599FF006599FF0065
      99FF65CCCCFF00000000000000000000000000000000993200FFCC6500FFCC65
      00FF993200FFE5E5E5FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FF9932
      00FFCC6500FFCC6500FF993200FF0000000000000000993200FF993200FFCC65
      00FFCC6500FF993200FFE5E5E5FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5
      E5FF993200FFCC6500FFCC6500FF993200FF0000000000000000000000007171
      71FFE6E6E6FFE7E7E7FFE6E6E6FFE7E7E7FFE6E6E6FFE7E7E7FFE7E7E7FFE6E6
      E6FFE7E7E7FF717171FF00000000000000003299CCFF3299CCFF99FFFFFF65CC
      FFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF3299
      CCFF006599FF00000000000000000000000000000000993200FFCC6500FFCC65
      00FF993200FFE5E5E5FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FF9932
      00FFCC6500FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FFCC6500FF993200FFE5E5E5FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5
      E5FF993200FFCC6500FFCC6500FF993200FF0000000000000000000000007272
      72FFE8E8E8FFE8E8E8FFD2D2D2FF454545FF161616FF464646FFD1D1D1FFE8E8
      E8FFE8E8E8FF737373FF00000000000000003299CCFF3299CCFF65CCFFFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF006599FF3299CCFF000000000000000000000000993200FFCC6500FFCC65
      00FF993200FFE5E5E5FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FF9932
      00FFCC6500FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FFCC6500FF993200FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FF993200FFCC6500FFCC6500FF993200FF0000000000000000000000007676
      76FFEAEAEAFFE9E9E9FF545454FF787878FFE3E3E3FF787878FF555555FFEAEA
      EAFFEAEAEAFF757575FF00000000000000003299CCFF3299CCFF65CCFFFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF65CCCCFF006599FF000000000000000000000000993200FFCC6500FFCC65
      00FF993200FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF9932
      00FFCC6500FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FFCC6500FFCC6500FF993200FF993200FF993200FF993200FF993200FF9932
      00FFCC6500FFCC6500FFCC6500FF993200FF0000000000000000000000007979
      79FFECECECFFEDEDEDFF191919FFE0E0E0FFEDEDEDFFDEDEDEFF1A1A1AFFEDED
      EDFFEDEDEDFF797979FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF99FFFFFF006599FF3299CCFF0000000000000000993200FFCC6500FFCC65
      00FFCC6500FF993200FF993200FF993200FF993200FF993200FF993200FFCC65
      00FFCC6500FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FF993200FF0000000000000000000000007A7A
      7AFFF0F0F0FFEFEFEFFF1A1A1AFFE4E4E4FFEFEFEFFFE2E2E2FF1B1B1BFFEFEF
      EFFFF0F0F0FF797979FF00000000000000003299CCFF65CCFFFF65CCCCFF65CC
      CCFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF99FFFFFF65CCCCFF006599FF0000000000000000993200FFCC6500FFCC65
      00FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC6500FFCC65
      00FFCC6500FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FFCC6500FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FFCC6500FFCC6500FF993200FF0000000000000000000000007D7D
      7DFFF1F1F1FFF2F2F2FF545454FF7D7D7DFFE6E6E6FF797979FF595959FFF1F1
      F1FFF1F1F1FF7D7D7DFF00000000000000003299CCFF99FFFFFF65CCFFFF3299
      CCFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFF99FF
      FFFFCCFFFFFFCCFFFFFF006599FF0000000000000000993200FFCC6500FFCC65
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FFCC6500FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF993200FFCC6500FF993200FF0000000000000000000000007E7E
      7EFFF4F4F4FFF4F4F4FFDBDBDBFF464646FF161616FF494949FFDCDCDCFFF4F4
      F4FFF4F4F4FF808080FF00000000000000003299CCFF99FFFFFF99FFFFFF65CC
      FFFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF3299
      CCFF3299CCFF3299CCFF65CCFFFF0000000000000000993200FFCC6500FF9932
      00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF993200FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FF993200FFFFFFFFFF993200FF993200FF993200FF993200FF993200FF9932
      00FFFFFFFFFF993200FFCC6500FF993200FF0000000000000000000000008181
      81FFF6F6F6FFF7F7F7FFF7F7F7FFF6F6F6FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
      F7FFF7F7F7FF848484FF00000000000000003299CCFFCCFFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFFCCFFFFFF0065
      99FF0000000000000000000000000000000000000000993200FFCC6500FF9932
      00FFFFFFFFFF993200FF993200FF993200FF993200FF993200FF993200FFFFFF
      FFFF993200FFCC6500FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF993200FFCC6500FF993200FF0000000000000000000000008585
      85FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFC7C7C7FFBDBD
      BDFFB2B2B2FF858585FF0000000000000000000000003299CCFFCCFFFFFFCCFF
      FFFFCCFFFFFFCCFFFFFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF0000
      00000000000000000000000000000000000000000000993200FFCC6500FF9932
      00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF993200FFCC6500FF993200FF00000000993200FFCC6500FF993200FFE5E5
      E5FF993200FFFFFFFFFF993200FF993200FF993200FF993200FF993200FF9932
      00FFFFFFFFFF993200FF993200FF993200FF0000000000000000000000008787
      87FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFBDBDBDFFB2B2
      B2FF898989FF00000000000000000000000000000000000000003299CCFF3299
      CCFF3299CCFF3299CCFF00000000000000000000000000000000000000000000
      000000000000993200FF993200FF993200FF00000000993200FFE5E5E5FF9932
      00FFFFFFFFFF993200FF993200FF993200FF993200FF993200FF993200FFFFFF
      FFFF993200FF993200FF993200FF00000000993200FFCC6500FF993200FFCC65
      00FF993200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF993200FFCC6500FF993200FF0000000000000000000000008888
      88FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFB2B2B2FF8989
      89FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000993200FF993200FF00000000993200FFCC6500FF9932
      00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF993200FFCC6500FF993200FF00000000993200FFE5E5E5FF993200FF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF993200FF993200FF0000000000000000000000008989
      89FF898989FF898989FF898989FF898989FF898989FF898989FF898989FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000993200FF000000000000
      000000000000993200FF00000000993200FF00000000993200FF993200FF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF993200FF00000000993200FFCC6500FF993200FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9932
      00FFCC6500FF993200FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000993200FF9932
      00FF993200FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000993200FF993200FF993200FF9932
      00FF993200FF993200FF993200FF993200FF993200FF993200FF993200FF9932
      00FF993200FF993200FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003C6F
      7EFF3D6E7AFF3D6F7BFF3D6F7BFF3D6F7AFF3D6F7BFF3D6F7AFF3D6F7BFF3D6E
      7BFF3D6E7BFF3C6F7EFF00000000000000000000000000000000000000003C6F
      7EFF3D6E7AFF3D6F7BFF3D6F7BFF3D6F7AFF3D6F7BFF3D6F7AFF3D6F7BFF3D6E
      7BFF3D6E7BFF3C6F7EFF00000000000000000000000000000000CC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC99
      65FFCC9965FFCC9965FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003B70
      81FFF7E8DFFFF7E8DFFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DFFFF7E8
      DEFFF7E8DEFF3B7082FF00000000000000000000000000000000000000003B70
      81FFF7E8DFFFF7E8DFFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DFFFF7E8
      DEFFF7E8DEFF3B7082FF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF0000000000000000000000003299CCFF006599FF0065
      99FF006599FF006599FF006599FF006599FF006599FF006599FF006599FF0065
      99FF006599FF0000000000000000000000000000000000000000000000003B72
      85FFF8E9E1FFF8EAE0FFF8E9E1FFF7EAE1FFF8E9E1FFF7EAE1FFF8EAE0FFF8E9
      E1FFF7EAE1FF3B7384FF00000000000000000000000000000000000000003B72
      85FFF8E9E1FFF8EAE0FFF8E9E1FFF7EAE1FFF8E9E1FFF7EAE1FFF8EAE0FFF8E9
      E1FFF7EAE1FF3B7384FF00000000000000000000000000000000CC9965FFFFFF
      FFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFFFFFFFFFCC9965FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF65CCFFFF3299
      CCFF99FFFFFF006599FF00000000000000000000000000000000000000003A75
      88FFF8EBE3FFF8EBE3FFFF0000FFF9EBE3FFF8ECE3FFFF0000FFF8EBE3FFF8EC
      E3FFF9EBE3FF3A7589FF00000000000000000000000000000000000000003A75
      88FFF8EBE3FFF8EBE3FFFF0000FFF9EBE3FFF8ECE3FFFC5E5BFFFA8D88FFF8EC
      E3FFF9EBE3FF3A7589FF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF99FFFFFF006599FF00000000000000000000000000000000000000003876
      8EFFF8EEE6FFF9EDE6FFFF0000FFF8EDE7FFF8EEE6FFFF0000FFF9EDE6FFF8EE
      E6FFF8EDE7FF38768DFF00000000000000000000000000000000000000003876
      8EFFF8EEE6FFF9EDE6FFFF0000FFF8EDE7FFF8DDD5FFFE1D1CFFF9E5DEFFF8EE
      E6FFF8EDE7FF38768DFF00000000000000000000000000000000CC9965FFFFFF
      FFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFFFFFFFFFCC9965FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF99FFFFFF006599FF0000000000000000000000000000000000000000377A
      92FFF9EFE9FFF9F0E9FFFF0000FFF9F0E9FFF9F0EAFFFF0000FFF9F0E9FFF9F0
      EAFFF9F0E9FF387A93FF0000000000000000000000000000000000000000377A
      92FFF9EFE9FFF9F0E9FFFF0000FFF9F0E9FFFC6B68FFFB9692FFF9F0E9FFF9F0
      EAFFF9F0E9FF387A93FF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CC
      FFFF99FFFFFF006599FF0000000000000000000000000000000000000000367C
      97FFFAF2ECFFFAF1ECFFFF0000FFFF0000FFFF0000FFFF0000FFFAF1ECFFF9F2
      EDFFFAF2EDFF367B96FF0000000000000000000000000000000000000000367C
      97FFFAF2ECFFFAF1ECFFFF0000FFFF0000FFFE0000FFFC6462FFFAF1ECFFF9F2
      EDFFFAF2EDFF367B96FF00000000000000000000000000000000CC9965FFFFFF
      FFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFFFFFFFFFCC9965FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99CC
      FFFF6599FFFF6599FFFFCCCCFFFF00000000000000000000000000000000347E
      9CFFFBF3F0FFFAF4F0FFFF0000FFFBF4EFFFFBF3F0FFFF0000FFFAF4F0FFFBF3
      F0FFFBF4EFFF357E9CFF0000000000000000000000000000000000000000347E
      9CFFFBF3F0FFFAF4F0FFFF0000FFFBF4EFFFFBDAD7FFFE0606FFFAF4F0FFFBF3
      F0FFFBF4EFFF357E9CFF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF00000000000000003299CCFF65CCFFFF3299CCFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99CCFFFF0032
      FFFF3299FFFF3265FFFF0032FFFF9999FFFF0000000000000000000000003482
      9FFFFBF6F3FFFBF5F3FFFF0000FFFBF6F3FFFBF5F3FFFF0000FFFBF5F3FFFBF5
      F3FFFBF6F3FF3482A0FF00000000000000000000000000000000000000003482
      9FFFFBF6F3FFFBF5F3FFFF0000FFFF0000FFFE0101FFFD5E5DFFFBF5F3FFFBF5
      F3FFFBF6F3FF3482A0FF00000000000000000000000000000000CC9965FFFFFF
      FFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
      E5FFFFFFFFFFCC9965FF00000000000000003299CCFF99FFFFFF99FFFFFF3299
      CCFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF99CCFFFF3299
      FFFF32CCFFFF32CCFFFF3299FFFF99CCFFFF0000000000000000000000003383
      A4FFFBF7F5FFFBF8F5FFFBF8F6FFFBF7F5FFFBF8F5FFFBF8F6FFFBF8F5FFFBF8
      F6FFFBF8F5FF3384A5FF00000000000000000000000000000000000000003383
      A4FFFBF7F5FFFBF8F5FFFBF8F6FFFBF7F5FFFBF8F5FFFBF8F6FFFBF8F5FFFBF8
      F6FFFBF8F5FF3384A5FF00000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFCC9965FF00000000000000003299CCFF99FFFFFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF99FFFFFF65CCFFFF3265FFFF0065
      FFFFCCFFFFFF99FFFFFF3265FFFF3265FFFF0000000000000000000000003286
      A8FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FF8FC8E0FF7BBD
      DAFF67B2D4FF3285A9FF00000000000000000000000000000000000000003286
      A8FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FF8FC8E0FF7BBD
      DAFF67B2D4FF3285A9FF00000000000000000000000000000000CC9965FFFFFF
      FFFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFFFFFFFFFCC9965FFCC99
      65FFCC9965FFCC9965FF0000000000000000000000003299CCFF99FFFFFF99FF
      FFFF99FFFFFF99FFFFFF3299CCFF3299CCFF3299CCFF3299CCFF3299CCFF0032
      FFFF0032FFFF3299FFFF0032FFFFCCCCFFFF0000000000000000000000003187
      ACFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF7BBDDAFF68B2
      D5FF2F8AB2FF0000000000000000000000000000000000000000000000003187
      ACFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF7BBDDAFF68B2
      D5FF2F8AB2FF0000000000000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFE5E5
      E5FFCC9965FF00000000000000000000000000000000000000003299CCFF3299
      CCFF3299CCFF3299CCFF000000000000000000000000000000000032FFFF99CC
      FFFF0032FFFF6599FFFF9999FFFF99CCFFFF0000000000000000000000003088
      AFFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF68B2D4FF2F8A
      B2FF000000000000000000000000000000000000000000000000000000003088
      AFFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF68B2D4FF2F8A
      B2FF000000000000000000000000000000000000000000000000CC9965FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCC9965FFCC99
      65FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000099CCFFFF99CCFFFF00000000000000000000000000000000000000002F8A
      B2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF0000
      0000000000000000000000000000000000000000000000000000000000002F8A
      B2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF0000
      0000000000000000000000000000000000000000000000000000CC9965FFCC99
      65FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FFCC9965FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000A020A0C3909242B7E104150B3144F6BCB1D5972D3266571C9184654AC0519
      22720105072E000001080008131D0000030B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000090B1E
      225E1E5A6CC425809BF21582C4FD117FD3FE1F8ACCFF369FC1FE278DBDFC125C
      89EE0B3240B4011525610031647E001226440000000000000000000000003C6F
      7EFF3D6E7AFF3D6F7BFF3D6F7BFF3D6F7AFF3D6F7BFF3D6F7AFF3D6F7BFF3D6E
      7BFF3D6E7BFF3C6F7EFF00000000000000000000000000000000000000003C6F
      7EFF3D6E7AFF3D6F7BFF3D6F7BFF3D6F7AFF3D6F7BFF3D6F7AFF3D6F7BFF3D6E
      7BFF3D6E7BFF3C6F7EFF000000000000000000000000000000007D716CFF685E
      5AFF685E5AFF685E5AFF685E5AFF685E5AFF685E5AFF685E5AFF685E5AFF685E
      5AFF685E5AFF685E5AFF7D716CFF00000000000000000402021314171867345F
      69D241A1B6FC309DC2FE0D81DAFF2187BEFF3CABCDFF32A2CDFF1583D1FF0967
      AEFE0B4F70FA02436FDE005CB9DF002C5B810000000000000000000000003B70
      81FFF7E8DFFFF7E8DFFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DFFFF7E8
      DEFFF7E8DEFF3B7082FF00000000000000000000000000000000000000003B70
      81FFF7E8DFFFF7E8DFFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DEFFF7E8DFFFF7E8
      DEFFF7E8DEFF3B7082FF0000000000000000000000001B81B4FF1980B2FF167C
      AFFF147AADFF1177AAFF0E74A7FF0B71A4FF096FA2FF066C9FFF046A9DFF0268
      9BFF006699FF006598FF48413EFF7D716CFF0000000315141457312829DD3C3E
      45FD43727DFF3894B0FF1581CFFF1371B2FF298BB7FF349EC0FF1F89C1FF0B5C
      8CFF09424DFF07475DFD045594DD0018324C0000000000000000000000003B72
      85FFF8E9E1FFF8EAE0FFF8CFC8FFFD3836FFFE0505FFFD2624FFF9C3BBFFF8E9
      E1FFF7EAE1FF3B7384FF00000000000000000000000000000000000000003B72
      85FFF8E9E1FFF8EAE0FFF8E9E1FFF7EAE1FFF8E9E1FFF7EAE1FFF8EAE0FFF8E9
      E1FFF7EAE1FF3B7384FF00000000000000002086B9FF65CBFEFF1E84B7FF98FE
      FEFF6DD3FEFF6DD3FEFF6DD3FEFF6DD3FEFF6DD3FEFF6DD3FEFF6DD3FEFF6DD3
      FEFF399FD2FF98FEFEFF006598FF695F5BFF01030308213C41822F3B40F6221A
      1EFF282428FF2A3A43FF22506DFF1E72A7FF309DCDFF36A0BDFF1F7594FF0D42
      51FF0C3339FF135164FE176A8FEC09242F610000000000000000000000003A75
      88FFF8EBE3FFF8EBE3FFFC4B48FFFC716DFFF8E2DAFFFB8581FFFD3331FFF8EC
      E3FFF9EBE3FF3A7589FF00000000000000000000000000000000000000003A75
      88FFF8EBE3FFF9ACA6FFFE1717FFFE1110FFFAA49EFFF9EBE3FFF8EBE3FFF8EC
      E3FFF9EBE3FF3A7589FF00000000000000002389BCFF65CBFEFF258BBEFF98FE
      FEFF79DFFEFF79DFFEFF79DFFEFF79DFFEFF79DFFEFF79DFFEFF79DFFEFF79DF
      FEFF42A8DBFF98FEFEFF006699FF685E5AFF050E0F19367C86B3417983FE232A
      2EFF1C1518FF231C1FFF2A2529FF304048FF3B6772FF3B7181FF2B5360FF1526
      2BFF122227FF1F4E5CFF2D8AA3FB195260960000000000000000000000003876
      8EFFF8EEE6FFF9EDE6FFFE0C0BFFF8DFDAFFF8EEE6FFF8EAE4FFFAC3BDFFF8EE
      E6FFF8EDE7FF38768DFF00000000000000000000000000000000000000003876
      8EFFF8EEE6FFFD2625FFF9AAA5FFF9B7B2FFFD3634FFF8EDE7FFF9EDE6FFFF00
      00FFF8EDE7FF38768DFF0000000000000000268CBFFF65CBFEFF2B91C4FF98FE
      FEFF84EAFEFF84EAFEFF84EAFEFF84EAFEFF84EAFEFF84EAFEFF84EAFEFF84EA
      FEFF4CB2E5FF98FEFEFF02689BFF685E5AFF0716182734889ACD46AABEFF3F78
      85FF3F464BFF66686BFF55585DFF2D2C2FFF252628FF394C52FF3B7182FF2F77
      8AFF33879AFF3A9AAEFF41AFC5FE2C7B89B5000000000000000000000000377A
      92FFF9EFE9FFF9F0E9FFFE0A0AFFF9E2DCFFF9F0EAFFF9F0E9FFF9F0E9FFF9F0
      EAFFF9F0E9FF387A93FF0000000000000000000000000000000000000000377A
      92FFF9EFE9FFFE0303FFF9ECE6FFF9F0E9FFF9F0EAFFF9F0E9FFFF0000FFFF00
      00FFFF0000FF387A93FF0000000000000000288EC1FF65CBFEFF3197CAFF98FE
      FEFF90F6FEFF90F6FEFF90F6FEFF90F6FEFF90F6FEFF90F6FEFF90F6FEFF90F6
      FEFF55BBEEFF98FEFEFF046A9DFF685E5AFF05171B2D24788ED53496AFFF498C
      9DFF5B7681FF7B9099FF43494CFF0E0E0FFF080708FF10171AFF265560FF42A3
      B6FF4BBDD2FF4CBFD2FF4DC1D3FF378E9CC0000000000000000000000000367C
      97FFFAF2ECFFFAF1ECFFFD4C4BFFFC6E6CFFF9E8E3FFFB9D9AFFFD3130FFF9F2
      EDFFFAF2EDFF367B96FF0000000000000000000000000000000000000000367C
      97FFFAF2ECFFFE2424FFFAABA8FFFAC5C1FFFC5654FFFAF2EDFFFAF1ECFFFF00
      00FFFAF2EDFF367B96FF00000000000000002B91C4FF6DD3FEFF3298CBFF98FE
      FEFF98FEFEFF98FEFEFF98FEFEFF98FEFEFF98FEFEFF98FEFEFF98FEFEFF98FE
      FEFF5EC4F7FF98FEFEFF066C9FFF695F5BFF02101628155E75D01B7390FF1E6F
      8AFF1D667EFF1F5D70FF122E34FF0B0F10FF070708FF070709FF0D1214FF2652
      5CFF3EA0B6FF44B2CAFF47B5CCFE348394B9000000000000000000000000347E
      9CFFFBF3F0FFFAF4F0FFFBDDDAFFFD4847FFFE0707FFFE2322FFFBC2BFFFFBF3
      F0FFFBF4EFFF357E9CFF0000000000000000000000000000000000000000347E
      9CFFFBF3F0FFFBB8B5FFFE1F1FFFFE0F0EFFFC9E9CFFFBF4EFFFFAF4F0FFFBF3
      F0FFFBF4EFFF357E9CFF00000000000000002D93C6FF79DFFEFF2B91C4FFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFF80E5FEFFFEFEFEFF096FA2FF877974FF00090C1C0B4558BA105B73FF0D53
      68FF0A4958FF063B43FF09363AFF123037FF121D21FF0D0F12FF09080AFF0F18
      1BFF26606FFF3293ACFF37A0B9FD2366779E0000000000000000000000003482
      9FFFFBF6F3FFFBF5F3FFFBF5F3FFFBF6F3FFFBF5F3FFFBF5F3FFFBF5F3FFFBF5
      F3FFFBF6F3FF3482A0FF00000000000000000000000000000000000000003482
      9FFFFBF6F3FFFBF5F3FFFBF5F3FFFBF6F3FFFBF5F3FFFBF5F3FFFBF5F3FFFBF5
      F3FFFBF6F3FF3482A0FF00000000000000002F95C8FF84EAFEFF80E5FEFF2B91
      C4FF2B91C4FF2B91C4FF2B91C4FF2B91C4FF2B91C4FF268CBFFF2288BBFF1E84
      B7FF1A80B3FF1980B2FF1980B2FF000000000003030A04293287094654F8073E
      48FF043437FF043336FF094551FF1A667CFF337C8EFF356871FF21383CFF151A
      1EFF1D2A31FF275664FF29788DF0123B46690000000000000000000000003383
      A4FFFBF7F5FFFBF8F5FFFBF8F6FFFBF7F5FFFBF8F5FFFBF8F6FFFBF8F5FFFBF8
      F6FFFBF8F5FF3384A5FF00000000000000000000000000000000000000003383
      A4FFFBF7F5FFFBF8F5FFFBF8F6FFFBF7F5FFFBF8F5FFFBF8F6FFFBF8F5FFFBF8
      F6FFFBF8F5FF3384A5FF00000000000000003197CAFF90F6FEFF8DF3FEFF8DF3
      FEFF8DF3FEFF8DF3FEFF8DF3FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFF147AADFF877974FF000000000000000000000000010F1241032E31D3032F
      30FE032F30FF073E47FF0E566BFF1E7995FF40ABC2FF5CCCDBFF5ABCC5FF3F76
      7EFF2A3F45FF23353CFD1E3D45C60714162F0000000000000000000000003286
      A8FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FF8FC8E0FF7BBD
      DAFF67B2D4FF3285A9FF00000000000000000000000000000000000000003286
      A8FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FF8FC8E0FF7BBD
      DAFF67B2D4FF3285A9FF00000000000000003298CBFFFEFEFEFF98FEFEFF98FE
      FEFF98FEFEFF98FEFEFFFEFEFEFF2389BCFF2086B9FF1D83B6FF1B81B4FF1980
      B2FF167CAFFF000000000000000000000000000000000001010D001312710128
      28E1053A40FE0B4B5BFF12617AFF22819CFF3FABC1FF5ACFE0FF67E1EDFF5ECF
      DBFF4CA8B5FE316E78D2132327660203030C0000000000000000000000003187
      ACFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF7BBDDAFF68B2
      D5FF2F8AB2FF0000000000000000000000000000000000000000000000003187
      ACFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF7BBDDAFF68B2
      D5FF2F8AB2FF000000000000000000000000000000003298CBFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFF288EC1FF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000001010F0118
      1C76073B44DA0D5369FA156A86FF2587A1FF3FAAC1FF58CADDFF67DFECFF63DB
      E5F848AAB4CB1D474E5E01040408000000000000000000000000000000003088
      AFFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF68B2D4FF2F8A
      B2FF000000000000000000000000000000000000000000000000000000003088
      AFFFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FFFCFAF9FF68B2D4FF2F8A
      B2FF0000000000000000000000000000000000000000000000003298CBFF3197
      CAFF2F95C8FF2D93C6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000003
      041002161B4C0837459912596FCB237B91E1399AAFE749ACBDDE4CA8B3C4377B
      818B1635373D0208080900000000000000000000000000000000000000002F8A
      B2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF0000
      0000000000000000000000000000000000000000000000000000000000002F8A
      B2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF2F8AB2FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000006071002101526081F25390E2B2F4110292D360C1E1F23030B
      0B0C000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000F00000000100010000000000800700000000000000000000
      000000000000000000000000FFFFFF00C0FF000000000000C0FF000000000000
      C081000000000000C081000000000000C0FF000000000000C0FF000000000000
      FF8F000000000000FF89000000000000FF8F000000000000C0FF000000000000
      C0FF000000000000C081000000000000C081000000000000C0FF000000000000
      C0FF000000000000FFFF000000000000FFFFFFFFFFFFFFFFC003FFFFFFFFFFFF
      C0038FFFF87F8770C0038C03F8778630C0038FFFFFE3FE3FC003FFFFFFC1FE3F
      C003FFFFDF80FE27C0038FFF8F80FE23C0038C038FE3FE01C0038FFF87C3FE00
      C003FFFF8003FF01C003FFFFC007FFE3C0038FFFE00FFFE7C0038C03FFFFFFFF
      C0038FFFFFFFFFFFFFFFFFFFFFFFFFFFFF80801F8001E07FFF8080038001C00F
      FE4180038001C007FC23800380018003FC17800380018003FC0F801F80018001
      F807800380010001F803800380010001F003800180010001E007800080010001
      C03F80008001000180FF80008001000100FFFC008001000101FFFE0080038001
      87FFFF018007E001CFFFFF83800FFE03FFFFFFFFFFFFFC3FFFFF8000FFFFF00F
      AA83800087F0E007FF8380008770C003BF838000FE3F8001FF838000FC1F8001
      BF838000F80F0000FF838000F80F0000BF838000FE3F0000FF838000FE3F0000
      BF838000C03F8001FF838000803F8001BF838000C07FC003FF838000FFFFE007
      AA838000FFFFF00FFFFF8000FFFFFC3FFFFF801FFFFFFFFFFFFF000FBFFFFFFF
      0000000F9FFF82AB0000000FCC3F83FF0000000FE01F83FB0000000FF01F83FF
      0000000FE01F83FB0000000FE01F83FF00000000E00F83FB00000000E00183FF
      00000001F00083FB00000003FF0083FF00000007FF8083FBFFFF000FFF8083FF
      FFFF800FFF8182ABFFFFC01FFFC3FFFFE0008FFF8FFF8FFFE00007FF07FF07FF
      E00083FF83FF83FFE00081FF81FF81FF6000C0FFC0FFC0FF2000E003E003E003
      0000F001F001F0012000F800F800F8006000F800F800F800E000F800F800F800
      E000F800F800F800E000F800F800F800E000F800F800F800E000F800F800F800
      E000FC01FC01FC01E000FE03FE03FE03C003FFFFE007F81FC0038001C003F81F
      C0038001E007F81F80018001C003F81F800180018001FC3F0000C0038001FC3F
      0000C0038001FC3F0000E0078001FC3F0000E0078001FC3F0000F00F8001FC3E
      0000F00F8001981C8001F81F800100008001F81FC0030001C003FC3FE0070003
      E007FC3FF00F0007F81FFFFFFFFF981FFFFFFDFFE0038003FFFFE0FFC0018003
      FFFF801F80008003FFFF001F80008003FFFF001F00008003FFFF000F00008003
      C003000F00008003C003000F00008003C003000100008003C003010100008003
      FFFF010100008003FFFF000F00008003FFFF008F80018003FFFF00AF80018007
      FFFF803FC003800FFFFFE1FFF00F801FFFFFFFFFFFD5FFFFFFFFFFFFFF80FFFF
      FFFFFFFFFC81FC3FE007CFC3E000FC3FE007C7C3E001FC3FE007C3C38000FC3F
      E007C1C38005C003E007C0C38707C003E007C0430783C003E007C0C30783C003
      E007C1C3870FFC3FE007C3C38007FC3FE007C7C38007FC3FFFFFCFC3E01FFC3F
      FFFFFFFFE01FFFFFFFFFFFFFFCFFFFFFFFFFFE7FFCFFFFFF0000F83FF87FFFFF
      0000E01FF87FFFFF0000800F70E3F9FF0000000730E3F8FF0000000301E3F87F
      0000000101FFF83F000000000023F81F000000000063F80F0000800100E1F81F
      0000C00101F0F83F0000E00003F8F87F0000F0010788F8FF0000F8070F88F9FF
      000FFC1F1F80FFFF861FFE7F3FC1FFFFFC01FE00FFFFFFFFFC01FE00FFFFFFFF
      FC01C000FFFFFFFFFC018000FFFFFFFFFC018000FFFFFFFF80018000FFE7E7FF
      80018000C1F3CF8380018000C3FBDFC380038001C7FBDFE380078003CBFBDFD3
      800F8007DCF3CF3B803F8007FF07E0FF803F8007FFFFFFFF807F8007FFFFFFFF
      80FFC00FFFFFFFFF81FFFCFFFFFFFFFFFFFFF9FFFF9F87E1EFFDF1FFFF8F33CC
      C7FFE00000073BDCC3FBC00000039999E3F780000001C003F1E700000000F00F
      F8CF80000001F81FFC1FC0000003F81FFE3FE0000007F00FFC1FF000000FE007
      F8CFF000000FC183E1E7F000000F83C1C3F3F000000F07E0C7FDF000000F0FF0
      FFFFF000000F1FF8FFFFF000000F3FFCFFFFFFFFFFFFE000E003FFFFC001C000
      E003800780018000E003000780010000E003000380010000E003000380010000
      E003000180010000E003000180010000E003000180010000E003000180010000
      E003000F80010000E003801F80010000E007C3F880010000E00FFFFC80010000
      E01FFFBA80010003FFFFFFC7FFFF0003FFFFFFFFFFFFFFFFE003E003C003FFFF
      E003E003C0038007E003E003C0030003E003E003C0030003E003E003C0030003
      E003E003C0030003E003E003C0030001E003E003C0030000E003E003C0030000
      E003E003C0030000E003E003C0038000E007E007C007C3C0E00FE00FC00FFFF3
      E01FE01FC01FFFFFFFFFFFFFFFFFFFFFFFFFE000FFFFFFFFFFFFC000E003E003
      C0018000E003E00380000000E003E00300000000E003E00300000000E003E003
      00000000E003E00300000000E003E00300000000E003E00300000000E003E003
      00010000E003E00300038000E003E00300078000E007E00781FFC001E00FE00F
      C3FFE003E01FE01FFFFFF80FFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object TimerHintTipEvent: TTimer
    Enabled = False
    Interval = 300
    OnTimer = TimerHintTipEventTimer
    Left = 472
    Top = 328
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = ApplicationEventsActivate
    OnDeactivate = ApplicationEventsDeactivate
    OnMessage = ApplicationEventsMessage
    Left = 75
    Top = 431
  end
  object TimerHintParams: TTimer
    Enabled = False
    Interval = 300
    OnTimer = TimerHintParamsTimer
    Left = 566
    Top = 328
  end
  object PopupTabs: TSpTBXPopupMenu
    Images = ImgListMenus
    OwnerDraw = True
    Left = 316
    Top = 67
    object PopTabsClose: TSpTBXItem
      Caption = 'Close'
      OnClick = FileCloseClick
    end
    object PopTabsCloseAll: TSpTBXItem
      Caption = 'Close all'
      OnClick = FileCloseAllClick
    end
    object PopTabsCloseAllOthers: TSpTBXItem
      Caption = 'Close all others'
      Enabled = False
      OnClick = PopTabsCloseAllOthersClick
    end
    object SpTBXSeparatorItem35: TSpTBXSeparatorItem
    end
    object PopTabsSave: TSpTBXItem
      Caption = 'Save'
      Enabled = False
      ImageIndex = 10
      OnClick = FileSaveClick
    end
    object PopTabsSaveAll: TSpTBXItem
      Caption = 'Save all'
      Enabled = False
      ImageIndex = 11
      OnClick = FileSaveAllClick
    end
    object SpTBXSeparatorItem39: TSpTBXSeparatorItem
    end
    object PopTabsCopyFullFileName: TSpTBXItem
      Caption = 'Copy full filename'
      OnClick = PopTabsCopyFullFileNameClick
    end
    object PopTabsCopyFileName: TSpTBXItem
      Caption = 'Copy filename'
      OnClick = PopTabsCopyFileNameClick
    end
    object PopTabsCopyDir: TSpTBXItem
      Caption = 'Copy directory path'
      OnClick = PopTabsCopyDirClick
    end
    object SpTBXSeparatorItem14: TSpTBXSeparatorItem
    end
    object PopTabsSwap: TSpTBXItem
      Caption = 'Swap header/source'
      OnClick = EditSwapClick
    end
    object SpTBXSeparatorItem17: TSpTBXSeparatorItem
    end
    object PopTabsReadOnly: TSpTBXItem
      Caption = 'Read only'
      AutoCheck = True
      OnClick = PopTabsReadOnlyClick
    end
    object SpTBXSeparatorItem40: TSpTBXSeparatorItem
    end
    object PopTabsTabsAtTop: TSpTBXItem
      Caption = 'Tabs at top'
      OnClick = PopTabsTabsAtTopClick
    end
    object PopTabsTabsAtBottom: TSpTBXItem
      Caption = 'Tabs at bottom'
      OnClick = PopTabsTabsAtBottomClick
    end
    object SpTBXSeparatorItem41: TSpTBXSeparatorItem
    end
    object PopTabsProperties: TSpTBXItem
      Caption = 'Properties...'
      ImageIndex = 20
      OnClick = ProjectPropertiesClick
    end
  end
  object ImageListGutter: TImageList
    ColorDepth = cd32Bit
    Left = 300
    Top = 243
    Bitmap = {
      494C010110001500040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FF000000FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000286690
      B5FF6690B5FF6690B5FF6690B5FF6690B5FF6690B5FF6690B5FF6690B5FF6690
      B5FF6690B5FF000000280000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000077ACD0FFAD94
      87FFAD9487FFAD9487FFAD9487FFAD9487FFAD9487FFAD9487FFAD9487FFAD94
      87FFAD9487FF6996BCFF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      000000000000000000000000000000000000000000000000000077ACD0FFC4D0
      D0FFF88A00FFF8E8DFFFF8E8DFFFF8E8DFFFF8E8DFFFF8E8DFFFF8E8DFFFF8E8
      DFFFAA968CFF6A98BEFF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF00FF00FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000AFC1D4FFF88A
      00FF7A4500FFF88A00FFF8EAE2FFF8EAE2FFF8EAE2FFF8EAE2FFF8EAE2FFF8EA
      E2FFA69B92FF6B9BC1FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FF000000FF000000FF000000FF000000FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000FF000000FF000000FF000000FF00FF00FF00FF00FF000000FF0000
      0000000000000000000000000000000000000000000000000000FFA63EFF7A45
      00FFF88A00FF7A4500FFFFA63EFFF9EDE7FFF9EDE7FFAD846CFFA3755DFFF8EA
      E2FFA19F99FF6E9EC4FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000FF00FFFFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000
      00FF000000000000000000000000000000000000000000000000965400FFFFA6
      3EFFFDFCFBFFFFA63EFF965400FFFFA63EFFF9EDE7FFF9F0ECFFF9F0ECFFF9F0
      ECFF9CA4A1FF71A2C7FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000FF00FFFFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF
      FFFF000000FF0000000000000000000000000000000000000000FFA63EFFC4D0
      D0FFFDFCFBFFFDFCFBFFFFA63EFF965400FFFFA63EFFF9EDE7FFCCAD9BFFF9F0
      ECFF96A9A9FF73A5CAFF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00FFFFFF0000
      00FF000000000000000000000000000000000000000000000000AFC1D4FF91AD
      B0FFFDFBFAFFFDFCFBFFFDFCFBFFFFA63EFF965400FFFFA63EFFFAF7F5FFFAF7
      F5FF91ADB0FF75A9CEFF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF0000
      000000000000000000000000000000000000000000000000000077ACD0FF8DB1
      B6FFFBF9F8FFFDFCFBFFFDFCFBFFFDFCFBFFFFA63EFF965400FFFDFCFBFFFDFC
      FBFF8DB2B7FF77ACD0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF00FFFFFF000000FF000000000000
      000000000000000000000000000000000000000000000000000079AED3FF8AB4
      BBFFFBF9F8FFFBF9F8FFFDFCFBFFFDFCFBFFFDFCFBFFFFA63EFFFDFCFBFFFBF9
      F8FF8AB4BBFF79AED3FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF000000FF00000000000000000000
      00000000000000000000000000000000000000000000000000007AB0D4FF8AB4
      BBFFFBF9F8FFFBF9F8FFFBF9F8FFFBF9F8FFFBF9F8FFFBF9F8FFFBF9F8FFFBF9
      F8FF8AB4BBFF7AB0D4FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FF000000FF000000FF000000FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FF000000FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000FF0000000000000000000000000000
      00000000000000000000000000000000000000000000000000007AB0D4FF7AB0
      D4FF96725FFFB49481FFB49481FFB49480FFB49481FFB49481FFB49481FF9672
      5EFF7AB0D4FF7AB0D4FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000028609A
      C5FF609AC5FFA08270FFC0A798FFC0A797FFC0A797FFC0A798FFA08270FF5181
      ADFF609AC5FF000000280000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF808080FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AA9182FFCCBAAEFFCCBAAEFFCCBAAFFFCCBAAEFFAA9182FF0000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF0000000000000000000000000000000000000000C0C0
      C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0C0FFC0C0
      C0FFC0C0C0FFC0C0C0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B09B8EFFD4C1ABFFD4C1ABFFB09B8EFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484FF848484FF848484FF848484FF848484FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF848484FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF0000FFFF00FF00FF0000FFFF0000FFFF0000FFFF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000008484
      84FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF8484
      84FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF00FF00FF00FF00FF00FF00FF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF00FFFFFF0000FFFF0000FFFF0000FFFF00FFFFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000008484
      84FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF8484
      84FF000000000000000000000000000000000000000000000000000000000000
      00FF00FF00FF00FF00FF0000FFFF00FF00FF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000008484
      84FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF8484
      84FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF00FF00FF00FF00FF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000008484
      84FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF8484
      84FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF00FF00FF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000008484
      84FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF8484
      84FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF0000FFFF0000FFFF0000FFFF00FF00FF00FF00FF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      00FF0000FFFF00FFFFFF0000FFFF0000FFFF0000FFFF00FFFFFF0000FFFF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      0000000000FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF848484FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF0000FFFF0000FFFF0000FFFF0000FFFF00FF00FF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484FF848484FF848484FF848484FF848484FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF00FF00FF00FF00FF0000
      00FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF000000FF000000FF000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFE003E003E003E003
      E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E003E003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE003E003E003E003
      E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E003E003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC003E003E003
      FEFFC003E003E003FE7FC003E003E003FE3FC003E003E003F01FC003E003E003
      F00FC003E003E003F007C003E003E003F00FC003E003E003F01FC003E003E003
      FE3FC003E003E003FE7FC003E003E003FEFFC003E003E003FFFFC003E003E003
      FFFFF81FE003E003FFFFFC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFF83FF83FF83FF83FF01FF01FF01FF01FE00FE00FE00FE00F
      E00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00F
      F01FF01FF01FF01FF83FF83FF80FF83FFFFFFFFFFF9FFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImgListCountry: TImageList
    ColorDepth = cd32Bit
    Height = 11
    Left = 76
    Top = 282
    Bitmap = {
      494C0101EE00F100040010000B00FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009402000001002000000000000094
      020000000000000000000000000000000000006600FF005700FF005700FF0057
      00FF004600FF004600FF004600FF003402FF003402FF003402FF0000CAFF0000
      DDFF000000FF000000FF0000CAFF0000DDFFE1E7E1FF080808FF005200FF0052
      00FF005200FF005200FF002C00FF005200FF002C00FF002C00FF002C00FF002C
      00FF002C00FF002C00FF002C00FF002C00FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000006600FF80BF80FF7BBD7BFF78B9
      78FF75B975FF70B670FF6CB26CFF68B168FF62AE63FF60AC60FF3B41E8FF3337
      EDFF303338FF303338FF357EECFF0000DDFFF5F5F5FFF0F2EFFF6FAE90FF58D5
      9DFF58D59DFF51D19AFF51D19AFF45CD94FF45CD94FF45CD94FF37C68AFF37C6
      8AFF37C68AFF37C68AFF37C68AFF006E00FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007200FF84C084FF68B168FF62AE
      63FF60AC60FF58A858FF54A654FF51A451FF4DA24DFF489F48FF1B23E4FF1818
      EEFF16162BFF0F1314FF357EECFF0000DDFFEFEFEFFFFBFBFCFFF5F5F5FF4AA5
      A7FF36F7F8FF36F7F8FF2AF5F5FF2AF5F5FF2AF5F5FF18F2F3FF18F2F3FF0CF1
      F1FF0CF1F1FF0CF1F1FF2AF5F5FF00DDDFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007200FF88C388FF6DB56DFF68B1
      68FF62AE63FF60AC60FF5CAB5CFF56A856FF51A451FF4DA24DFF242BE7FF1818
      EEFF16162BFF0F1314FF3C84EDFF0000DDFFEFEFEFFFFBFBFCFFFBFBFCFFE8EC
      F1FF4D6296FF3958D8FF2F58E0FF2F58E0FF2754DEFF214BDCFF214BDCFF133F
      D8FF133FD8FF133FD8FF2F58E0FF0000B3FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007200FF8BC48BFF70B670FF6DB5
      6DFF68B168FF65B065FF60AC60FF5CAB5CFF56A856FF51A451FF242BE7FF1818
      EEFF16162BFF0F1314FF3C84EDFF0000E5FFF1EFF1FF7892ECFF4DFBFCFF5DBD
      F2FFF5F5F5FF4556A1FF3958D8FF3551CFFF2947CCFF2947CCFF2947CCFF1839
      C7FF1839C7FF1839C7FF3551CFFF000089FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007B00FF8EC68EFF75B975FF70B6
      70FF6DB56DFF6AB369FF65B065FF60AC60FF5CAB5CFF58A858FF2D33E9FF2727
      F3FF1F2127FF1F2127FF4288EEFF0000E5FFBDC5EDFF8EA4F1FF54FDFDFF4DFB
      FCFFA9B9F2FFF5F5F5FF3B3B3AFF3B3B3AFF3B3B3AFF272727FF272727FF2727
      27FF272727FF080808FF3B3B3AFF080808FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007B00FF91C891FF79BC78FF75B9
      75FF70B670FF6DB56DFF6AB369FF65B065FF62AE63FF5CAB5CFF3337EDFF2727
      F3FF1F2127FF1F2127FF468AF1FF0000E5FF7892ECFF8FD6F7FF54FDFDFF7892
      ECFF7892ECFF555B9CFF4350C0FF4350C0FF3A47BBFF3A47BBFF2736B4FF2736
      B4FF2736B4FF2736B4FF3A47BBFF00005EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000028102FF95C995FF7BBD7BFF79BC
      78FF75B975FF70B670FF6DB56DFF6AB369FF65B065FF62AE63FF5CAB5CFF58A8
      58FF54A654FF4FA24FFF67AF67FF003402FFF5F5F5FF84FDFEFF8EA4F1FFFBFB
      FCFF5C76A4FF4771E6FF4771E6FF4771E6FF4771E6FF3564E3FF3564E3FF3564
      E3FF2F58E0FF2754DEFF4771E6FF0000B3FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000028102FF95C995FF80BF80FF7BBD
      7BFF79BC78FF75B975FF70B670FF6DB56DFF6AB369FF65B065FF65B458FF5CAE
      5DFF3E8CE7FF3888E8FF67AE77FF004600FFF5F5F5FFFBFBFCFFFBFBFCFF61B7
      B9FF54FDFDFF54FDFDFF54FDFDFF4DFBFCFF44FBFBFF44FBFBFF36F7F8FF36F7
      F8FF36F7F8FF2AF5F5FF48F7F7FF00E9E9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000028102FF95C995FF95C995FF95C9
      95FF91C891FF8EC68EFF8EC68EFF8BC48BFF88C388FF84C084FF74B09CFF64A4
      E8FF5EA2E3FF5A9FDDFF5699E8FF003402FFF5F5F5FFFBFBFCFF6FAE90FF77E1
      B1FF77E1B1FF70DEABFF70DEABFF70DEABFF66DBA6FF66DBA6FF5ED6A2FF58D5
      9DFF58D59DFF51D19AFF4DD294FF008400FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000028102FF028102FF028102FF0281
      02FF007B00FF007B00FF007B00FF007200FF007200FF006600FF006600FF0066
      00FF005700FF005700FF005700FF004600FFD7E1D7FF002C00FF008400FF0084
      00FF008400FF008400FF008400FF006E00FF006E00FF006E00FF006E00FF006E
      00FF005200FF005200FF005200FF005200FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000F6FF0000F2FF0000F2FF0000
      EEFF0000EEFF0000EEFF0000EAFF0000EAFF0000E6FF0000E6FF0000E2FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFEBEBEEFFE9E9EAFFE7E7E7FFE5E5
      E5FFE1E2E1FFDDDDDDFFD7D7D8FFD5D5D6FFD2D2D2FFD2D2D2FFC9CACCFFCFCF
      CFFFD2D2D2FFCFCFCFFFCFCFCFFFCFCFCFFF006600FF006600FF37991AFFE5B2
      B1FFB50000FFB50000FF8D0000FF8D0000FF8D0000FF8D0000FF8D0000FF8D00
      00FF8D0000FF8D0000FF8D0000FF8D0000FF0000F6FF6060FBFF5C5CFAFF5655
      F9FF5655F9FF5151F8FF4A4AF7FF4343F6FF4343F6FF3D3DF5FF3939F4FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF000000FF6B6B6BFF6B6B6BFF5D5D
      5DFF5D5D5DFF5D5D5DFF4C4C4CFF4C4C4CFF4C4C4CFF424243FF424243FF3A3A
      3AFF3A3A3AFF353535FF353535FF000000FFEEEEEEFFFBFBFAFFFBFBFAFFE7E7
      E7FFE7E7E7FFF7F7F7FFF3F3F3FFF0F0EEFFF0F0EEFFF0F0EEFFF2F2F2FFDDDD
      DDFFDDDDDDFFF0F0F0FFF2F2F2FFCFCFCFFF00C88FFF7EBF5EFF76B859FF90C8
      79FFD8E4CAFFE18687FFD34445FFD34445FFD34445FFD34445FFCC3030FFCC30
      30FFCC3030FFCC3030FFCC3030FF8D0000FF0000FBFF6565FCFF4444FBFF3F3F
      FAFF3939F9FF3333F8FF2C2CF7FF2929F6FF2424F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000DFFF000000FF6B6B6BFF4C4C4CFF4242
      43FF424243FF3A3A3AFF353535FF353535FF272727FF272727FF272727FF1919
      19FF191919FF191919FF353535FF000000FFF0EFEFFFFCFCFDFFF6F6F6FFC7C7
      C8FFF6F6F6FFEBEBEEFFAEADE6FF9896E2FF9896E2FF9896E2FFE2E2E6FFE9E9
      EAFFB4B4B5FFE9E9EAFFF2F2F2FFCFCFCFFF008FA9FF6DEAE8FF68B452FF60AB
      3EFF62AF40FFB2DAA0FFE18687FFCC3030FFCC3030FFC41313FFC41313FFC413
      13FFC41313FFC41313FFCC3030FF8D0000FF0000FBFF6C6CFDFF4849FBFF4444
      FBFF3F3FFAFF3939F9FF3333F8FF2F2FF7FF2929F6FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000DFFF7E8181FFC5C5C5FFB8B8B8FFB5B5
      B5FFB2B2B2FFB2B2B2FFAEAEAEFFA9A9A9FFA9A9A9FFA3A3A3FFA3A3A3FFA3A3
      A3FF9D9D9DFF9D9D9DFFA9A9A9FF353535FFF1F1F1FFFCFCFDFFFBFBFAFFC5C5
      C7FFF2F2F2FFEBEBEEFF414FDDFF2E41DAFF2C3CD7FF2C3CD7FFE2E2E6FFE1E2
      E1FFADACAEFFEEEEEEFFF3F3F3FFD2D2D2FF000000FF6FB6BEFF55E3E6FF5FBC
      6DFF62AF40FF59A937FFD8E4CAFFE1E9D6FFEEC3C4FFE5B2B1FFE5B2B1FFE5B2
      B1FFE5B2B1FFE5B2B1FFE5B2B1FFCB5E62FF0000FBFF6C6CFDFF4E4EFCFF4849
      FBFF4444FBFF3F3FFAFF3939F9FF3535F8FF2F2FF7FF2929F6FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E2FFF1F1F1FFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFD3D3D3FFF1F1F1FFFCFCFDFFCFCFCFFFC5C5
      C7FFF7F7F7FFF1F1F1FF414FDDFF3741D6FF2C3CD7FF3741D6FFE9E9EAFFEAEB
      E8FFB4B4B5FFB4B4B5FFF3F3F3FFD2D2D2FF000000FF727171FF559193FF53D4
      DCFF59BB84FF68B452FF5CAB3AFF59A937FF62AF40FF5CAB3AFF59A937FF56A6
      32FF4FA32DFF4BA128FF67B147FF003800FF320000FFA77078FF93525DFFA770
      78FF8E4A55FF8A4650FF87404BFF833A46FF7E3540FF2F2FF7FF2929F6FF2424
      F5FF1E1EF4FF1818F3FF3939F4FF0000E6FFF3F3F3FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFD6D6D6FFF3F3F3FFFEFEFEFFD2D2D2FFEFEF
      F2FFF7F7F7FFF0EFEFFFB35961FFEAD9DBFFEAD9DBFFB14849FFE9E9EAFFE6E8
      E9FFE7E7E7FFBAB9BBFFF4F4F4FFD5D5D6FF000000FF727171FF525252FF5591
      93FF59DBE6FF5CBA71FF62AF40FF5CAB3AFF4AA232FF4AA232FF3F9C27FF3F9C
      27FF37991AFF37991AFF50A43AFF003800FF320000FFB07575FF9C5858FFD0B0
      ADFFCAA39BFF944848FF944848FF87404BFF833A46FF3535F8FF2F2FF7FF2929
      F6FF2424F5FF1F1FF4FF3D3DF5FF0000E6FFF5F5F5FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD6D6D6FFF5F5F5FFFEFEFEFFDCDCDCFFC9CA
      CCFFC9CACCFFF1F1F1FFBE6361FFB14849FFB14849FFB14849FFEBEBEEFFBABD
      C0FFBAB9BBFFC7C7C8FFF5F5F5FFD7D7D8FF000000FF727171FF5D9EA2FF59DB
      E6FF66BB72FF68B452FF67B147FF62AF40FF67B147FF67B147FF62AF40FF60AB
      3EFF59A937FF56A632FF68B452FF003800FF3A0000FFAF7979FFAF7979FF9C58
      58FFD0B0ADFFA97070FF944848FF8A4650FF87404BFF3C3BF9FF3535F8FF2F2F
      F7FF2929F6FF2424F5FF4343F6FF0000E6FF8D8DFFFFCCCCFEFFC0C0FEFFC0C0
      FEFFBDBDFDFFBABAFDFFBABAFDFFB6B6FBFFB3B3F8FFB3B3F8FFAFAFF8FFABAB
      F7FFABABF7FFA7A7F5FFB3B3F8FF4C4CE7FFF5F5F5FFFEFEFEFFFEFEFEFFF0F0
      EEFFF0F0EEFFFBFBFAFFE1C7C4FFD9B6B4FFD9B6B4FFD9B6B4FFF4F4F4FFEAEB
      E8FFE5E5E5FFF4F4F4FFF6F6F6FFDCDCDCFF000000FF7DC1C9FF6DEAE8FF76BF
      69FF76B859FF68B452FFD8E4CAFFE6EDE6FFCAC9FAFFBFBDF8FFB8B7F6FFB8B7
      F6FFB8B7F6FFB8B7F6FFBFBDF8FF6A68E7FF3A0000FFAF7979FFD6BDBDFFA365
      65FFA36565FFC39D9CFF955050FF8E4A55FF8A4650FF3F3FFAFF3C3BF9FF3535
      F8FF2F2FF7FF2C2CF7FF4A4AF7FF0000EAFF0000EFFF7A85F8FF5D6AF4FF5D6A
      F4FF5765F4FF5360F2FF505CF4FF4B58F3FF4452F2FF4452F2FF3C4BF0FF3343
      EEFF3343EEFF2B3BECFF4B59EFFF0000D8FFF5F5F5FFFFFFFFFFFEFEFEFFFCFC
      FDFFF7F7FEFFF7F7FEFFF7F8FDFFF8F9FCFFF6F6FAFFF8F9FAFFF6F6FAFFEFEF
      F9FFF6F6F6FFF6F6F6FFF7F7F7FFDDDDDDFF008FA9FF87F2E9FF7EBF5EFF76B8
      59FF7EBF5EFFE1E9D6FFA6A6F9FF6564FCFF4747F9FF4747F9FF4747F9FF3130
      F7FF3130F7FF3130F7FF4747F9FF0000F5FF3A0000FFAF7979FFC39D9CFFE2D1
      D0FFB98C8CFFD6BDBDFFB98C8CFFA26A73FFA26A73FF6565FCFF6060FBFF5C5C
      FAFF5655F9FF5151F8FF4A4AF7FF0000EAFF0000EFFF7A85F8FF7A85F8FF7884
      F7FF7681F7FF727CF7FF727CF7FF6C77F6FF6874F5FF6470F4FF5D6AF4FF5D6A
      F4FF5765F4FF5360F2FF4B59EFFF0000D8FFF5F5F5FFFFFFFFFFFFFFFFFFE8E8
      FEFFB2B2FCFFBFBFFEFFBFBFFEFFC3C3FCFFC3C3FCFFC3C3FCFFC3C3FCFFB2B2
      FCFFEFEFF9FFF8F8F8FFF7F7F7FFDDDDDDFF00C88FFF90C879FF90C879FFB2DA
      A0FFE6EDE6FFA6A6F9FF6F6EFDFF6F6EFDFF6564FCFF6564FCFF6564FCFF5656
      F9FF5656F9FF5656F9FF4747F9FF0000F5FF3A0000FF3A0000FF3A0000FF3A00
      00FF3A0000FF320000FF320000FF260000FF260000FF0000FBFF0000F6FF0000
      F6FF0000F2FF0000F2FF0000EEFF0000EEFF0000EFFF0000EFFF0000EFFF0000
      EFFF0000EBFF0000EBFF0000EBFF0000EBFF0000EBFF0000EBFF0000E3FF0000
      E3FF0000E3FF0000E3FF0000D8FF0000D8FFF5F5F5FFF5F5F5FFF5F5F5FFF2F2
      F5FFF2F2F5FFF1EFF3FFEFEFF2FFEBEBEEFFEBEBEEFFE4E4EEFFE4E4EEFFE7E7
      E9FFE9E9EAFFE7E7E7FFE5E5E5FFE1E2E1FF108500FF108500FF76BF4AFFCBD1
      D9FF3130F7FF0000F5FF0000F5FF0000F5FF0000F5FF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000F5FF0000F5FF0000F4FF0000F4FF0000F4FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF000000FF0095C7FF000000FF003C
      00FF00A000FF00A000FF00A000FF009300FF009300FF009300FF009300FF0086
      00FF008600FF008600FF008600FF008600FF006A00FF006A00FF006A00FF006A
      00FF006A00FF005100FF005100FF005100FF005100FF005100FF003300FF0033
      00FF003300FF003300FF003300FF003300FF0000A5FF00009CFF000095FF0000
      95FF00008CFF00008CFF00008CFF000083FF000083FF00007BFF000074FF0000
      74FF000074FF00006CFF00006CFF000074FF0000F4FF6060FBFF5C5CFAFF5757
      F9FF5453F9FF5151F8FF4A4AF7FF4343F6FF4343F6FF3B3BF5FF3536F7FF3232
      F3FF3232F3FF2D2DF2FF2D2DF2FF0000DDFF000000FF5D8992FF61D2E8FF5773
      5AFF54AD54FF48D548FF48D548FF48D548FF3AD03AFF3AD03AFF3AD03AFF32CE
      32FF32CE32FF2CCB2CFF2CCB2CFF008600FF007D03FF70C68FFF70C68FFF5D5A
      E7FF5B6AD0FF57BB7AFF57BB7AFF505AC9FF4869B8FF4AB26EFF3B9579FF3F42
      D8FF3C6F9EFF38AA5EFF38AA5EFF003300FF0000A5FF6060D5FF5C5CD3FF5757
      D2FF5353D0FF5050CEFF4848CEFF4343CAFF4141C8FF3C3DC7FF3939C6FF3535
      C3FF3131C3FF2D2DC1FF2D2DC1FF00006CFF0000FAFF6565FCFF4444FBFF3F3F
      FAFF3939F9FF333DF8FF2C42F7FF2929F6FF2424F5FF1B2BF4FF1B2BF4FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF000000FF5F676AFF467782FF43C9
      E3FF39593CFF339635FF2AD32AFF2CCB2CFF1DCC1DFF1DCC1DFF18C717FF12C6
      12FF0CC30CFF0CC30CFF2CCB2CFF008600FF007D03FF70C68FFF57BB7AFF3EBD
      49FF3C6F9EFF3B9579FF3FAE66FF38AA5EFF2E40BEFF2A39C5FF20954FFF1AA1
      40FF1A40A3FF1AA140FF38AA5EFF003300FF0000A5FF6565D7FF4444CDFF3E3E
      CBFF3939C9FF3434C6FF2C2CC5FF2929C3FF2424C1FF1B1BBCFF1B1BBCFF0E0E
      B7FF0E0EB7FF0E0EB7FF2D2DC1FF00006CFF0000FAFF6969FCFF4849FBFF4444
      FBFF3F3FFAFF3939F9FF34F8F8FF2E5FF7FF294DF6FF23F5F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3232F3FF0000E0FF000000FF5F676AFF484A4BFF4677
      82FF43C9E3FF39593CFF339635FF2AD32AFF2AD32AFF1DCC1DFF1DCC1DFF1DCC
      1DFF11CB11FF11CB11FF32CE32FF009300FF007D03FF70C68FFF57BB7AFF498B
      99FF4869B8FF463CE9FF3D65B3FF338D78FF3326F1FF338D78FF23A642FF1E70
      7AFF2429CDFF1AA140FF31AB58FF003300FF0000ADFF6969D8FF4848CEFF4444
      CDFF3E3ECBFF3939C9FF3434C6FF2F2FC5FF2929C3FF3939C6FFAFAFE4FFF3F3
      F3FFBEBEE5FF2424BDFF3131C3FF000074FF0000FDFF6D6DFDFF4E4EFCFF4849
      FBFF4444FBFF3F3FFAFF3972F9FF34F8F8FF2EF7F7FF2976F6FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3536F7FF0000E5FF000000FF6EA6B0FF4EAFBFFF4EC4
      D9FF467782FF43C9E3FF36383AFF36383AFF2D3032FF25282AFF25282AFF1C1F
      21FF1C1F21FF131618FF36383AFF000000FF007D03FF70C68FFF57BB7AFF494A
      C8FF4E4DE5FF4A54D7FF463CE9FF463CE9FF3C45CCFF3C45CCFF3326F1FF1E1E
      F4FF20954FFF23A642FF3FAE66FF003300FF0000ADFF6E6EDAFF4F4ED1FF4848
      CEFF4444CDFF3E3ECBFF3939C9FF3434C6FF2D2DC1FFD8D8EFFF3939C6FF8D8D
      DAFF2D2DC1FFBEBEE5FF3535C3FF000074FF0000FDFF7170FEFF5353FDFF4E4E
      FCFF4A4AFCFF4D51FDFF3BF9F9FF3BF9F9FF34F8F8FF2FF7F7FF2C42F7FF2424
      F5FF1E1EF4FF1818F3FF3B3BF5FF0000E5FF000000FF72BFCDFF5F676AFF4ED3
      E9FF484A4BFF467782FF43C9E3FF43C9E3FF36C6E2FF36C6E2FF36C6E2FF29C1
      DEFF29C1DEFF21BDDBFF43C9E3FF0074B3FF9ED1AEFFDDF0E0FF6867EBFFE7F6
      E7FF4A54D7FF5152D6FF3F42D8FF3F42D8FF4A54D7FF383BD6FF3F42D8FF6867
      EBFF4E4DE5FF498B99FFDDF0E0FF94B7A2FF4042D1FFAAAAE9FF9595E2FF9291
      E1FF9291E1FF8E8DDFFF8989DDFF3B3AC8FF3434C6FFF7F7F7FFAFAFE4FF2424
      C1FF8D8DDAFFF3F3F3FF3A3AC3FF00007BFF0000FDFF7575FEFF5858FEFF5353
      FDFF4D51FDFF4AD5FCFF43CCFBFF40FAFAFF3BF9F9FF3EC0FAFF2FD2F7FF2A32
      F6FF2424F5FF1F1FF4FF3B3BF5FF0000E5FF000000FF75C7D5FF58D3EAFF4EC4
      D9FF467782FF4FCDE4FF484A4BFF3E4041FF3E4041FF36383AFF2D3032FF2D30
      32FF25282AFF1C1F21FF3E4041FF000000FFE7E7E7FFFDFDFDFF5D5AE7FFFDFD
      FDFF7E84E4FF494AC8FFCBD0EEFF7E84E4FF383BD6FF383BD6FF7276DAFFF6F6
      EEFF2429CDFF908EEAFFF6F6F6FFCFCFCFFF930000FFD37878FFFEFEFEFFFDFD
      FDFF4F4ED1FF5353D0FF9595E2FF4040CCFF3B3AC8FFCCCCEEFF4343CAFFAFAF
      E4FF3B3AC8FFAFAFE4FF3C3DC7FF00007BFF0000FFFF7979FFFF5C5CFEFF5858
      FEFF5353FDFF4D51FDFF4A4AFCFF3EC0FAFF43CCFBFF3C3BF9FF3536F7FF3030
      F7FF2929F6FF2424F5FF4343F6FF0000E5FF000000FF797B7BFF5F676AFF5D89
      92FF58D3EAFF545578FF4A4BB3FF4343FAFF4343FAFF3636F8FF3636F8FF3636
      F8FF2929F6FF2929F6FF4343FAFF0000EEFFE7E7E7FFFDFDFDFFB7BBE8FFFDFD
      FDFFC7CAEBFF5152D6FFF8F8F9FFAEB3EAFF3C45CCFF4A54D7FF383BD6FFDDDF
      EEFFB7BBE8FF2A39C5FFDDDFEEFFCFCFCFFF950000FFD37878FFFEFEFEFFFEFE
      FEFF5353D0FF5050CEFF9595E2FF4848CEFF4040CCFF4D4DCEFFCCCCEEFFF7F7
      F7FFD8D8EFFF3C3DC7FF4343CAFF000083FF0000FFFF7979FFFF5C5CFEFF5C5C
      FEFF5858FEFF5353FDFF4D51FDFF4976FCFF4976FCFF3F3FFAFF3C3BF9FF3536
      F7FF3030F7FF2B2BF6FF4A4AF7FF0000ECFF000000FF797B7BFF5D8992FF61D2
      E8FF545578FF5354C2FF5555FAFF4B4BF9FF4343FAFF4343FAFF3636F8FF3636
      F8FF3636F8FF2929F6FF4B4BF9FF0000EEFFE7E7E7FFFDFDFDFFB7BBE8FFA1A6
      E3FF5B6AD0FF5152D6FFB7BBE8FFFDFDFDFF4A54D7FF3F42D8FF383BD6FF3636
      CDFFF8F8F9FF5B6AD0FFC7CAEBFFCFCFCFFF950000FFD37878FFFEFEFEFFFEFE
      FEFF5858D4FF5353D0FF9898E4FF4D4DD1FF4848CEFF4040CCFF3B3AC8FF3535
      C3FF2F2FC5FF2C2CC5FF4848CEFF000083FF0000FFFF7979FFFF7979FFFF7979
      FFFF7575FEFF7575FEFF7170FEFF6D6DFDFF6969FCFF6565FCFF6060FBFF5C5C
      FAFF5757F9FF5151F8FF4A4AF7FF0000ECFF000000FF7A9FA7FF7EDCEDFF7879
      96FF7676D0FF706FFDFF706FFDFF706FFDFF6464FCFF6464FCFF6464FCFF5555
      FAFF5555FAFF5555FAFF4B4BF9FF0000EEFFE7E7E7FFFDFDFDFFFDFDFDFFD8D9
      F2FF908EEAFF7276DAFFC7CAEBFFFDFDFDFFFDFDFDFF908EEAFFAEB3EAFFC7CA
      EBFFDDDFEEFFF8F8F9FFF6F6F6FFD5D5D5FF950000FFD37878FFFFFFFFFFFEFE
      FEFF7575DBFF7575DBFFAAAAE9FF6E6EDAFF6969D8FF6565D7FF6060D5FF5C5C
      D3FF5757D2FF5353D0FF4D4DCEFF000083FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFF001A2CFF00ABD5FF000000FF0000
      95FF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000
      EEFF0000EEFF0000EEFF0000EEFF0000EEFFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFE7E7E7FFE7E7E7FFE1E1E2FFE1E1E2FFE1E1E2FFE1E1E2FFE1E1E2FFDDDD
      DDFFD8D9D8FFDDDDDDFFD8D9D8FFD8D9D8FF950000FF950000FFFFFFFFFFFFFF
      FFFF0000ADFF0000ADFF4848CEFF0000ADFF0000ADFF0000A5FF0000A5FF0000
      9CFF00009CFF000095FF000095FF000095FFB40000FFB40000FF910000FF9100
      00FF00C1ECFF00C1ECFF00C1ECFF00C1ECFF00B5E5FF00B5E5FF00B5E5FF00B5
      E5FF002300FF002300FF002300FF002300FF0101F4FF0101F4FF0101F4FF0000
      EBFF0000EBFF0000EBFF0000EBFF0000EBFF0000EBFF0000E1FF0000E1FF0000
      E1FF0000E1FF0000DDFF0000DDFF0000DDFF6C0000FF6C0000FF4E0000FF4E00
      00FF4E0000FF4E0000FF4E0000FF310000FF310000FF310000FF310000FF1F00
      00FF1F0000FF1F0000FF1F0000FF1F0000FFE7E8E8FFE4E3E3FFE4E3E3FFE4E3
      E3FFDEDEDEFFDEDEDEFFD7D6D6FFD7D6D6FFD7D6D6FFD7D6D6FFCFCFD0FFCFCF
      D0FFCFCFD0FFCBCBCBFFCBCBCBFFCBCBCBFFB40000FFDE6363FFD66665FFD45F
      5FFF5AF3F2FF51FCFCFF46F8F6FF43F6F4FF43F6F4FF3AF5F5FF3AF5F5FF35F2
      EAFF30A530FF30A530FF28A228FF002300FF0101F4FF6160FBFF6160FBFF5353
      F9FF5353F9FF5353F9FF4545F8FF4545F8FF4545F8FF3A3AF5FF3A3AF5FF3030
      F4FF3030F4FF3030F4FF2727F4FF0000DDFF6C0000FFBD6262FFBA5C5CFFB957
      57FFB55151FFB55151FFB24A49FFB14444FFAD4244FFAB3B3AFFA93937FFAA33
      33FFAA3333FFA42C2CFFA42C2CFF1F0000FFE7E8E8FFFAFAFAFFFAFAFAFFFAFA
      FAFFFAFAFAFFF9F7F7FFF9F7F7FFF1F6F7FFD6EEEEFFECC4C4FFEAB9B9FFEAB9
      B9FFF2F2F2FFF2F2F2FFF2F2F2FFCBCBCBFFB40000FFDE6363FFCD4C4CFFCD4C
      4CFF45EFEFFF34F8F8FF2DF7F7FF28D39EFF26CF95FF1CF4F4FF1CF4F4FF15EE
      E6FF0D940DFF0D940DFF30A530FF002300FF0101F4FF6160FBFF4545F8FF3C3C
      FAFF3A3AF5FF3030F4FF3030F4FF2727F4FF2727F4FF1515F3FF1515F3FF1515
      F3FF1515F3FF0101F4FF3030F4FF0000E1FF6C0000FFBD6262FFB14444FFAE3E
      3EFFA93937FFAA3333FFA42C2CFFA42C2CFFA02121FFA02121FF6E9DA2FF59AC
      ACFF59ACACFF65969CFFA42C2CFF1F0000FFEBEBEBFFFCFCFCFFFAFAFAFFFAFA
      FAFFEEEEEEFFA6CEBCFFE7E8E8FF3FD8E4FF1DD5EBFF67D1D6FFDD9C9CFFBABC
      BCFFF1F1F1FFF1F1F1FFF2F2F2FFCBCBCBFFB40000FFE16D6DFFD15656FFCD4C
      4CFF45EFEFFF3BF9F9FF34F8F8FF2CB24AFF2CB24AFF23F4F1FF1CF4F4FF15EE
      E6FF169916FF0D940DFF30A530FF002300FF56075CFFAA69AEFF96469AFF9646
      9AFF903E95FF8D3992FF87318CFF87318CFF812686FF812686FF77187CFF7718
      7CFF77187CFF77187CFF87318CFF000000FF6C0000FFC26B6BFFB24A49FFB144
      44FFAE3E3EFFA93937FFAA3333FFA42C2CFFA42C2CFFA02121FF66C2C8FF4F9E
      81FF4F9E81FF5CBFC6FFA63432FF1F0000FFEEEEEEFFFCFCFCFFFAFAFAFFFAFA
      FAFF3FD8E4FF4CB392FF96E5E4FF51BFC9FF4CB392FF67D1D6FF88D7DCFF1DD5
      EBFFE9DADAFFF2F2F2FFF2F2F2FFCFCFD0FFC30000FFE16D6DFFD15656FFD156
      56FF4DF0F0FF45E6C4FF39D7A3FF32BD65FF32BD65FF26CF95FF23DDB7FF1EF0
      E8FF169916FF169916FF30A530FF002300FFBE0000FFE37171FFDB4E4EFFDA49
      49FFF6E8E8FFEAA5A5FFD33B3BFFD23535FFD02C2CFFD02C2CFFE59999FFF1E2
      E1FFC91717FFC91717FFD23535FF8D0000FF6C0000FFC26B6BFFB55151FFB24A
      49FFB14444FFAE3E3EFFAB3B3AFFAA3333FFA42C2CFFA42C2CFF528253FF4891
      5BFFA0C3AAFF457A49FFAA3333FF310000FFD28F8FFFECC4C4FFECC4C4FFF9F7
      F7FF489682FF57DEE9FFFAFAFAFF636AD9FFD0CDECFF636AD9FF45DFECFFEAB9
      B9FFD28F8FFFE4E3E3FFE0AAABFFCDBDBDFFC30000FFE16D6DFFD45F5FFFD156
      56FF52F1F4FF43D9A3FF41B043FF38EFDFFF38EFDFFF30A530FF2ACB86FF27F2
      EEFF1F9E1FFF169916FF3CAA3CFF002300FFBE0000FFE37171FFDD5454FFDB4E
      4EFFDA4949FFF6E8E8FFEAA5A5FFD33B3BFFD23535FFE59999FFF1E2E1FFCC21
      21FFCC2121FFC91717FFD33B3BFF8D0000FF6A165BFFBD798AFFBE5252FFA65D
      7AFF9F5B80FFB14444FFBD6262FFA97292FFA3363AFFAA3333FF528253FF9EBE
      9FFFA0C3AAFF457A49FFAF3B3BFF310000FFD26F76FFF2D5D6FFEAB9B9FFFCFC
      FCFFFCFCFCFF6AE8F0FFF1F6F7FF636AD9FFD0CDECFF636AD9FF3FD8E4FFB0D2
      D4FFDD9C9CFFE9DADAFFE0AAABFFCDBDBDFFC30000FFE47878FFD45F5FFFD45F
      5FFF5AF3F2FF45E6C4FF45C87AFF43D9A3FF35DEB6FF32BD65FF35DEB6FF27F2
      EEFF28A228FF1F9E1FFF41B043FF002300FFBE0000FFE37171FFDD5454FFDD54
      54FFDB4E4EFFDA4949FFF6E8E8FFF9F2F2FFF9F2F2FFF6E8E8FFD02C2CFFD02C
      2CFFCC2121FFCC2121FFD33B3BFF8D0000FFAF5460FFD0C4E2FFBD8397FF9774
      B1FF907DCAFFD79A94FFB8ABD8FFA97292FFAE3E3EFFAA3333FF5D8B5EFF6EA6
      7DFFA0C3AAFF457A49FFAE3E3EFF310000FFD26F76FFF9F7F7FFB0D2D4FF7BE5
      EAFF57DEE9FF4AEBF4FFD26F76FFDD4F63FFD9455BFFD9455BFF3FD8E4FF27DB
      E3FF5DDBDEFFA3E5ECFFE0AAABFFCDBDBDFFC30000FFE47878FFD66665FFD45F
      5FFF5AF3F2FF51FCFCFF4AF5ECFF46F8F6FF46F8F6FF35F2EAFF34F8F8FF35F2
      EAFF28A228FF28A228FF41B043FF002300FF00DFFCFF76FDFDFF5AFCFCFF5AFC
      FCFF53FDFDFF50FDFDFF4BFCFCFF44FBFBFF44FBFBFF3CF9F9FF36F8F8FF30F7
      F7FF29F6F6FF29F6F6FF43F6F6FF00BBE8FF4D0F77FFB8ABD8FF9DA1EFFF7A77
      DFFF8182E5FF9DA1EFFF907DCAFF9774B1FFAD4244FFAF3B3BFF5D8B5EFF6684
      55FF668455FF528253FFB14444FF310000FFEEEEEEFFFCFCFCFF8CECF5FF59E3
      EAFF59E3EAFF55EBF5FFE07E8BFFB6888DFFB6888DFFD26F76FF88D7DCFF30E8
      EEFF2ACECEFF3FD8E4FFCDE7E7FFD7D6D6FFC30000FFE47878FFD66665FFD666
      65FF5FF4F4FF51FCFCFF51FCFCFF4BFCFCFF44FBFBFF44FBFBFF3BF9F9FF35F2
      EAFF30A530FF28A228FF41B043FF004B00FF009641FFDE8483FFD86866FF68DA
      B9FF5AFCFCFF53FDFDFF50FDFDFF4BFCFCFF44FBFBFF44FBFBFF3CF9F9FF36F8
      F8FF30F7F7FF29F6F6FF4DF7F7FF00BBE8FF1614CDFF9491E5FF8182E5FF7376
      E7FF6667E2FF7376E7FF7A77DFFF7069D5FFAC4851FFAD4244FFAE3E3EFFA939
      37FFA63432FFA42C2CFFB24A49FF4E0000FFF1F1F1FFA5F1F7FF6AE8F0FF7BE5
      EAFF8CECF5FFA5F1F7FFF4FCFCFF72ECF2FF4AEBF4FFF4FCFCFFE0F9FBFF6AE8
      F0FF57DEE9FF3FD8E4FF5DDBDEFF6CBFBFFFC30000FFE47878FFDE8282FFDE82
      82FF7CF7F7FF6EFDFDFF6EFDFDFF6EFDFDFF62FCFCFF62FCFCFF62FCFCFF5AF3
      F2FF54B755FF54B755FF4BB24BFF004B00FF009641FF7E8AF3FF76FDFDFF89D2
      ACFF76FDFDFF76FDFDFF76FDFDFF68FCFCFF68FCFCFF68FCFCFF5AFCFCFF5AFC
      FCFF5AFCFCFF4DF7F7FF4DF7F7FF00C1EBFF920109FFC4B5D9FFDFCEDDFFB8AB
      D8FFA99AD7FFC4B5D9FFD0C4E2FFD79A94FFC26B6BFFBD6262FFBD6262FFBA5C
      5CFFB95757FFB55151FFB24A49FF4E0000FFF1F1F1FFA5F1F7FFE0F9FBFFE0F9
      FBFFBEF6FCFF8CECF5FFFCFCFCFF9BEFF7FF9BEFF7FFFCFCFCFFA5F1F7FFC0F2
      F8FFD3F5F8FFD3F5F8FF8CECF5FF88D7DCFFC70000FFC30000FFB40000FFB400
      00FF00DBFDFF00DBFDFF00DBFDFF00D6FBFF00D6FBFF00D6FBFF00D0F6FF00D0
      F6FF004B00FF004B00FF004B00FF004B00FF00E6FDFF00D4B7FF00D4B7FF00E6
      FDFF00E6FDFF00E6FDFF00E6FDFF00DFFCFF00DFFCFF00DFFCFF00DBF6FF00DB
      F6FF00D6F2FF00D6F2FF00CFEEFF00CFEEFF795EB6FFA65D7AFF920109FF4D0F
      77FF441083FF920109FF6A165BFF795EB6FF6C0000FF6C0000FF6C0000FF6C00
      00FF6C0000FF4E0000FF4E0000FF4E0000FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEBEBEBFFE7E8E8FFE7E8
      E8FFE4E3E3FFE4E3E3FFE4E3E3FFDEDEDEFF4962E3FF4962E3FF4962E3FF4962
      DBFF4962DBFF4962DBFF4962DBFF4962D5FF4962C9FF4962BAFF4962BAFF4962
      ABFF4962ABFF49629DFF49629DFF49629DFFE7E1DFFFE4DED9FFE4DED9FFDFDB
      D7FFDCD6D3FFDCD6D3FFD6D3CEFFD6D3CEFFD3CEC8FFD3CEC8FFCEC8C2FFCEC8
      C2FFCEC8C2FFCAC3BDFFCAC3BDFFCAC3BDFF004600FF002F00FF002F00FF002F
      00FF002F00FF001400FF001400FF001400FF001400FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00BFDEFF00B7DAFF00B7DAFF00B3
      D7FF00ADD3FF00ADD3FF00A7CEFF00A7CEFFC3D7D9FFD6D6D6FFD6D6D6FFD2D3
      D3FFD2D3D3FFCFCFCFFFCFCFCFFFCFCFCFFFD8DBDBFFFAFAFAFFFEFEECFFF6F7
      F7FFF6F7F7FFF5F6F6FFF3F4F4FFF3F4F4FFF3F4F4FFF1F1F1FFEFF1F1FFEAED
      EDFFFCE5E5FFE5E6E6FFDFE2E2FF5D73F4FFAE4C03FFE1AE7AFFDFAB74FFDFAB
      74FFDCA469FFDCA469FFDB9E62FFDB9E62FFDA9B5CFFD59858FFD59858FFD494
      53FFD4914CFFD4914CFFD4914CFF840000FF004600FF63B063FF5AAB5AFF5AAB
      5AFF52A551FF52A551FF4AA14AFF439D43FF439D43FF3D9B3DFF399839FF3393
      33FF339333FF2D902DFF2D902DFF000000FF00BFDEFF79EAFBFF79EAFBFF72E7
      F7FF72E7F7FF6DE4F5FF60E3F6FF6DE4F5FFEBF4F6FFF4F5F4FFF4F5F4FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFCFCFCFFF6B81FCFFC1CAFEFF7878FDFF6564
      FCFF5353FCFF4545FCFF4545FCFF3939FCFF2A2AFBFF2A2AFBFF1E1EFAFF0F0F
      F9FF0F0FF9FF0F0FF9FF6B81FCFF49629DFFE4DED9FFFBF6F1FFF8F3EEFFF8F3
      EEFFF6F0EBFFF6F0EBFFF4EFE9FFF4EFE9FFF2EDE8FFF1ECE5FFF1ECE5FFEFE9
      E3FFEFE9E3FFEEE7E1FFF1ECE5FFC5B9ADFF004600FF63B063FF439D43FF3D9B
      3DFF399839FF339333FF2D902DFF258E25FF258E25FF188617FF188617FF1886
      17FF0C7E0CFF0C7E0CFF2D902DFF000000FF00C4E4FF79EAFBFF63E6F8FF60E3
      F6FF5AE3F6FF54E1F4FF4DDFF4FF54E1F4FFE9F3F5FFF4F5F4FFF2F2F2FFE2E2
      EBFFE2E2EBFFF2F2F2FFF2F2F2FFCFCFCFFFDFE2E2FFFAFAFAFFF5F6F6FFF3F4
      F4FFF3F4F4FFF1F1F1FFEEEEEEFFEEEEEEFFECECECFFE9E9E9FFE9E9E9FFE5E6
      E6FFE5E6E6FFD8DBDBFFDCE1FDFF809191FFAC3800FFE1AE7AFFDA9B5CFFDA9B
      5CFFD99652FFD4914CFFD4914CFFD38B43FFD38B43FFD08438FFD08438FFD084
      38FFC57627FFC57627FFD38B43FF840000FF00005BFF8671BAFF6248A4FF5D42
      A1FF573B9DFF573B9DFF513599FF4C3095FF472A93FF40228EFF40228EFF3413
      86FF341386FF341386FF4C3095FF000000FF00C4E4FF85ECFBFF68E7F9FF63E6
      F8FF60E3F6FF5AE3F6FF54E1F4FF5AE3F6FFEFF5F6FFE2F1F1FFE2F1F1FFB8A9
      DCFFA6A7E0FFEEEEEEFFEAEAEAFFD2D3D3FFB66262FFFCBB9AFFF97637FFF973
      34FFF8712EFFE16E02FFBB6800FFB64B00FFB32A00FF3939FCFF3131FBFF2A2A
      FBFF1E1EFAFF1E1EFAFF768AFDFF4962ABFFD3975CFFF1D7BCFFECCBABFFECCB
      ABFFEAC8A6FFE8C6A4FFE8C4A1FFE7C29CFFE7C29CFFE3BF9AFFE4BB93FFE4BB
      93FFE4B98EFFDEB68DFFE3BF9AFFAE4C03FFF5EDECFFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7F7FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFD1BDBDFF00C9E7FF85ECFBFF6DE8FAFF68E7
      F9FF63E6F8FF60E3F6FF5AE3F6FF60E3F6FFF5F7F7FFACE7EBFF54BAC9FF9DB1
      E0FFB8A9DCFFAFB6BBFFCCD0CDFFD2D3D3FFB66262FFFAFAFAFFF9793BFFF1F1
      F1FFF97334FFECECECFFE57002FFDFE2E2FFB64B00FFEEEEEEFFECECECFFE9E9
      E9FFE9E9E9FFE5E6E6FFFDFED7FFA8B4B4FFEFEDEBFFFCFBFAFFF8F5F5FFF8F5
      F5FFFCFBFAFFFCFBFAFFF8F3EEFFF8F3EEFFF6F0EBFFF4EFE9FFF4EFE9FFF2ED
      E8FFF1ECE5FFF1ECE5FFF2EDE8FFCAC3BDFFF8F0F0FFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7F7FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFD3C2C2FF00C9E7FF8CEDFCFF72E9FBFF6DE8
      FAFF68E7F9FF63E6F8FF5AE3F6FF63E6F8FFEDF6F8FFF7F7F7FFEFF5F6FF77B4
      B3FF6D88A9FFE2F1F1FFEFF5F6FFD6D6D6FFC06462FFFCBEA1FFFA7C40FFF979
      3BFFF9793BFFF97334FFF8712EFFF57303FFBB6800FF5353FCFF4545FCFF3939
      FCFF3131FBFF2A2AFBFF768AFDFF4962C9FFF1F1F1FFE3F4F5FF78EEEEFF78EE
      EEFFE3F4F5FFF8F3EEFFDB9E62FFD99652FFD99652FFD4914CFFD38B43FFD38B
      43FFD08438FFD08438FFD49453FF840000FFF7F2F2FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFD3C2C2FF01CCE9FF8CEDFCFF72E9FBFF72E9
      FBFF6DE8FAFF68E7F9FF63E6F8FF68E7F9FFF7F8F8FFEADCDBFF77B4B3FF7CBF
      C9FF54BAC9FF54BAC9FFACE7EBFFD6D6D6FFC06462FFFCBEA1FFFAFAFAFFFA7C
      40FFF5F6F6FFF9793BFFEEEEEEFFF8712EFFF57303FFF1F1F1FFF1F1F1FFEEEE
      EEFFECECECFF5AFDFDFFF3F4F4FFC1C9C9FFE9EAEAFF95F2F2FF5BF5F5FF5BF5
      F5FF67F3F3FFF8F5F5FFECCBABFFECCBABFFEAC8A6FFE8C6A4FFE8C4A1FFE7C2
      9CFFE3BF9AFFE3BF9AFFE8C6A4FFC57627FF00005BFF8671BAFF725AAEFF725A
      AEFF6A52AAFF6A52AAFF6248A4FF6248A4FF5D42A1FF573B9DFF513599FF4C30
      95FF472A93FF40228EFF5D439FFF000000FF06CDEBFF91F0FCFF79EAFBFF72E9
      FBFF72E9FBFF6DE8FAFF68E7F9FF6DE8FAFFF1FAFBFFF6F1F1FFC8E3E5FF7BC2
      C4FF7BC2C4FFC8E3E5FFDDF0F3FFDDDDDDFFC46662FFFCC0A2FFFA8147FFFA81
      47FFFA7C40FFF9793BFFF9793BFFF97637FFF8712EFF7878FDFF6564FCFF5353
      FCFF4545FCFF3939FCFF8697FDFF4962D5FFEDEDEDFF9EF3F3FF5BF5F5FF5BF5
      F5FF95F2F2FFFBF6F1FFFBF6F1FFFBF6F1FFF8F3EEFFF8F3EEFFF8F3EEFFF6F0
      EBFFF6F0EBFFF4EFE9FFF6F0EBFFD5C9BFFF5E0000FFEDDDDDFFF5EDECFFC792
      93FFEDDDDDFFE3C9C9FFEAD8D9FFDFC2C2FFEAD5D5FF9D3E3FFF9D3E3FFF9430
      30FF943030FF943030FFA34D4DFF000000FF06CDEBFF91F0FCFF79EAFBFF79EA
      FBFF72E9FBFF72E9FBFF68E7F9FF72E9FBFFF1FAFBFFFAFAFAFFFAFAFAFFF7F8
      F8FFF5F7F7FFF7F7F7FFF7F7F7FFDDDDDDFFC46662FFFDFEFEFFFCC0A2FFFAFF
      FBFFFCBEA1FFFAFAFAFFFCBB9AFFFAFAFAFFFCBB9AFFFAFAFAFFFAFAFAFFF6F7
      F7FFF6F7F7FFF6F7F7FFF5F6F6FF9FACACFFF1F1F1FFEDF7F7FF9EF3F3FF9EF3
      F3FFEDF7F8FFFDF8F4FFE7C29CFFE4BB93FFE4B98EFFE4B98EFFE4B689FFE3B2
      83FFE3B283FFE1AE7AFFE1AE7AFFAC3800FF5E0000FFF7F2F2FFD6ACACFFBB77
      77FFBB7777FFEFE2E2FFECD9D9FFEDDDDDFFE3C9C9FFB06464FFAF5F5FFFAA59
      59FFAA5959FFA34D4DFFA34D4DFF2A0000FF06CDEBFF91F0FCFF91F0FCFF91F0
      FCFF8CEDFCFF8CEDFCFF85ECFBFF8CEDFCFFF4FCFCFFFAFAFAFFFAFAFAFFFAFA
      FAFFFAFAFAFFF7F8F8FFF7F7F7FFDDDDDDFFC46662FFC46662FFC46662FFC466
      62FFC06462FFC06462FFB66262FFB66262FFB66262FF6B81FCFF6177FCFF4962
      E3FF4962E3FF4962E3FF4962DBFF4962DBFFF1F1F1FFF1F1F1FFF1F1F1FFF0EF
      EFFFF1F1F1FFF0EFEFFFF0EFEFFFEDEDEDFFEDEDEDFFE9EAEAFFE9EAEAFFE9EA
      EAFFE4E4E4FFE4E4E4FFE0E0E0FFE0E0E0FF5E0000FFD6ACACFFEAD5D5FFAF5F
      5FFF5E0000FF5E0000FFD9B9B9FFC79293FFD7B3B3FF430000FF430000FF4300
      00FF430000FF2A0000FF2A0000FF2A0000FF14CFEBFF01CCE9FF06CDEBFF06CD
      EBFF01CCE9FF00C9E7FF00C9E7FF00C9E7FFDFEDEFFFEEEEEEFFEEEEEEFFEAEA
      EAFFEAEAEAFFE5E5E4FFE5E5E4FFE5E5E4FF0000F6FF0000F2FF0000F2FF0000
      EEFF0000EEFF0000EEFF0000EAFF0000EAFF0000E6FF0000E6FF0000E2FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFF000000FF000000FF000000FF008F
      85FF00DDCEFF00AD52FFCC4800FFE84300FFE84300FFE23700FFE23700FFE237
      00FFDE2B00FFDE2B00FFDE2B00FFE23700FF00DAF6FF00D5F2FF00D5F2FF00CF
      EEFF00CFEEFF00CFEEFF00C7EAFF00C7EAFF00C7EAFF00BDE2FF00BDE2FF00BD
      E2FF00B6DEFF00B6DEFF00B6DEFF00B6DEFF0000F5FF0000F5FF0000F5FF0000
      EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000E2FF0000E2FF0000
      E2FF0000DDFF0000DDFF0000DDFF0000DDFF0000F6FF6060FBFF5C5CFAFF5655
      F9FF5655F9FF5151F8FF4A4AF7FF4343F6FF4343F6FF3D3DF5FF3939F4FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF000000FF616364FF575757FF5757
      57FF558F93FF5FE8E0FF5CF0E6FFC9C073FFF6AD3FFFF6AD3FFFF4A836FFF4A8
      36FFF2A42EFFF2A42EFFF2A42EFFDE2B00FF00DAF6FF67FCFCFF58F9F9FF58F9
      F9FF58F9F9FF4DF8F8FF4DF8F8FF43F7F7FF43F7F7FF3AF5F5FF3AF5F5FF33F3
      F3FF33F3F3FF2DF2F2FF2DF2F2FF00B6DEFF0000F5FF5F84FBFF5F84FBFF567C
      F9FF567CF9FF4D75F8FF4D75F8FF416BF6FF416BF6FF416BF6FF3461F3FF3461
      F3FF3461F3FF2D5BF2FF2D5BF2FF0000DDFF0000FBFF6565FCFF4444FBFF3F3F
      FAFF3939F9FF3435F8FF2C2CF7FF2929F6FF2424F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000DFFF00DDCEFF65D2D5FF415353FF3B3E
      3EFF323334FF324F53FF32C5C2FF47E8D4FF86D19CFFDFA232FFF29A16FFF29A
      16FFF1960DFFF1960DFFF2A42EFFDE2B00FF00DEFAFF67FCFCFF43FBFBFF3BF9
      F9FF3BF9F9FF33F8F8FF2EF7F7FF29F6F6FF23F5F5FF1BF4F4FF1BF4F4FF12F2
      F2FF0CF1F1FF0CF1F1FF2DF2F2FF00B6DEFF00FCF7FF65FCFCFF45F9F5FF3CFA
      FAFF3CFAFAFF33F8F8FF2AF5F4FF2AF5F4FF2AF5F4FF18F3F3FF18F3F3FF18F3
      F3FF0CF1F1FF0CF1F1FF2AF5F4FF00E4DEFF0000FBFF6D6AF9FF4849FBFF4444
      FBFF3F3FFAFF3939F9FF3435F8FF2F2FF7FF2929F6FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000DFFF008900FF62EADAFF48F3F5FF4288
      8AFF3B3E3EFF3B3E3EFF323334FF2A8E94FF40E5D8FF5AE1C1FFBCB153FFF29A
      16FFF29A16FFF1960DFFF4A836FFDE2B00FF00DEFAFF67FCFCFF4AFCFBFF43FB
      FBFF3BF9F9FF3BF9F9FF33F8F8FF2EF7F7FF29F6F6FF23F5F5FF1BF4F4FF1BF4
      F4FF12F2F2FF12F2F2FF33F3F3FF00BDE2FF00B3ABFF69DCD8FF43D1CEFF43D1
      CEFF43D1CEFF36CDC9FF36CDC9FF2BC8C4FF2BC8C4FF2BC8C4FF16C1BDFF16C1
      BDFF16C1BDFF16C1BDFF2BC8C4FF007C72FF0000FBFF6D6AF9FF4E4EFCFF4849
      FBFF4444FBFF3F3FFAFF3939F9FF3435F8FF2F2FF7FF2929F6FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E2FF007800FF6DC46DFF4ADEA4FF45E7
      E5FF42CED2FF415353FF3B3E3EFF323334FF324F53FF32C5C2FF36EDE5FF86D1
      9CFFF29A16FFF29A16FFF4A836FFE23700FF00E1FDFF67FCFCFF4AFCFBFF4AFC
      FBFF43FBFBFF3BF9F9FF3BF9F9FF33F8F8FF2EF7F7FF29F6F6FF23F5F5FF1BF4
      F4FF1BF4F4FF12F2F2FF33F3F3FF00BDE2FF000000FF6B7575FF434343FF4343
      43FF434343FF434343FFBABABAFFF7F7F8FF4444D6FFBABABAFF1B1B1BFF1B1B
      1BFF1B1B1BFF1B1B1BFF434343FF000000FFAB1600FFDB9D7CFFD48961FFD284
      5BFFCF7E57FFCF7C52FFCB774CFFCB774CFF3935F1FF2F2FF7FF2929F6FF2424
      F5FF1E1EF4FF1818F3FF3939F4FF0000E6FF008500FF72C671FF51B551FF4CC7
      6DFF47E8D4FF43DEE1FF42888AFF3B3E3EFF323334FF323334FF2A8E94FF40E5
      D8FF47E8D4FFBCB153FFF4A836FFE23700FFC79100FFE7D08AFFE0C46FFFDEC1
      6AFFDEC16AFFDCBD61FFDCBD61FFD7B856FFD7B856FFD7B856FFD3B24AFFD3B2
      4AFFD1AE42FFCFAB3DFFD7B856FF994E00FF000070FF7271BEFF4C4CABFF4C4C
      ABFF4C4CABFF4C4CABFFF7F7F8FF9D9D9EFF686C6CFFF7F7F8FF32329CFF1E1E
      93FF1E1E93FF1E1E93FF32329CFF000000FFB02000FFDD9F7DFFD48961FFD994
      72FFD99472FFD18156FFCF7C52FFCB774CFF453AEAFF3435F8FF2F2FF7FF2929
      F6FF2424F5FF1F1FF4FF3D3DF5FF0000E6FF008500FF76C876FF5ABD5AFF52B9
      53FF52B953FF4ADEA4FF45E7E5FF42CED2FF324F53FF323334FF323334FF324F
      53FF32C5C2FF49E6CFFF86D19CFFCC4800FFFC7700FFFEC876FFFEBB57FFFDBA
      53FFFCB750FFFCB64AFFFBB245FFF9AF41FFF9AE3BFFF8AB36FFF7A72DFFF6A3
      27FFF6A327FFF49F1FFFF5AD3EFFE94200FF0000F5FF7575FEFF5151FDFF5151
      FDFF5151FDFF5151FDFFC2C2FBFF9D9D9EFFF7F7F8FFBBBBF8FF3737F6FF2424
      F5FF2424F5FF2424F5FF3737F6FF0000EAFFB32600FFDFA484FFD99292FFFDF9
      F9FFFBF9F9FFD99292FFD18156FFCF7C52FF4A40ECFF3C3BF9FF3435F8FF2F2F
      F7FF2929F6FF2424F5FF4343F6FF0000E6FF008500FF79C979FF5ABD5AFF5ABD
      5AFF52B953FF51B551FF4CC76DFF47E8D4FF43DEE1FF3B7A7CFF323334FF3233
      34FF323334FF2A8E94FF62EADAFF00C99DFFFE8200FFFFC979FFFEBE5CFFFEBC
      58FFFDBA53FFFCB750FFFCB64AFFFBB245FFF9AF41FFF9AE3BFFF8AB36FFF7A9
      30FFF6A327FFF6A327FFF9AF41FFE94200FF00CDFBFF78E8FCFF5AE3FCFF5AE3
      FCFF4FDFFBFF4FDFFBFF4FDFFBFF43DBF7FF43DBF7FF35D8F6FF35D8F6FF35D8
      F6FF28D4F4FF28D4F4FF43DBF7FF009FE3FFB32600FFDFA484FFDD9999FFFDF9
      F9FFFEFEFEFFDD9999FFD2845BFFD18156FF4F46EDFF3F3FFAFF3C3BF9FF3435
      F8FF2F2FF7FF2C2CF7FF4A4AF7FF0000EAFF008900FF79C979FF5ABD5AFF5ABD
      5AFF5ABD5AFF52B953FF51B551FF4BB850FF46E0AEFF45E7E5FF3CB7BBFF3B3E
      3EFF323334FF323334FF487378FF008F85FFFF8500FFFFC979FFFEBE5CFFFEBE
      5CFFFEBC58FFFDBA53FFFCB750FFFCB64AFFFBB245FFF9AF41FFF9AE3BFFF8AB
      36FFF7A930FFF7A72DFFF7B34BFFE94200FF00FCF7FF79FFFAFF5BFEF8FF5BFE
      F8FF5BFEF8FF4FFCF6FF4FFCF6FF4FFCF6FF45F9F5FF45F9F5FF3CF9F3FF36F8
      F2FF30F7F1FF2AF5F4FF45F9F5FF00E4DEFFB32600FFDFA484FFDFA484FFE7B8
      B8FFE7B8B8FFDB9D7CFFDC9C79FFD99976FF6D6AF9FF6565FCFF6060FBFF5C5C
      FAFF5655F9FF5151F8FF4A4AF7FF0000EAFF008500FF79C979FF79C979FF79C9
      79FF76C876FF72C671FF72C671FF6DC46DFF68BF68FF59D794FF62EADAFF5BED
      EFFF558F93FF575757FF4D4D4DFF000000FFFE8200FFFFC979FFFFC979FFFFC9
      79FFFEC876FFFEC671FFFEC671FFFCC268FFFCC268FFFCC268FFFBBE60FFFABA
      59FFFABA59FFFCB750FFF7B34BFFE94200FF000000FF7C8585FF7C8585FF7C85
      85FF7C8585FF7C8585FF737C7CFF737C7CFF6B7575FF6B7575FF656E6FFF686C
      6CFF586363FF586363FF586363FF000000FFB32600FFB32600FFB32600FFB326
      00FFB02000FFB02000FFAB1600FFAB1600FF0000E2FF0000FBFF0000F6FF0000
      F6FF0000F2FF0000F2FF0000EEFF0000EEFF008900FF008900FF008900FF0089
      00FF008500FF008500FF008500FF007800FF007800FF007800FF007800FF00C1
      5EFF00BDBFFF000000FF000000FF000000FFFF8500FFFF8500FFFF8500FFFF85
      00FFFE8200FFFE8200FFFC7700FFFC7700FFFC7700FFFC7700FFF56700FFF567
      00FFF56700FFF15C00FFEF5600FFEF5600FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000F6FF0000F2FF0000F2FF0000
      EEFF0000EEFF0000EEFF0000EAFF0000EAFF0000E6FF0000E6FF0000E2FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFF0000F4FF0000F4FF0000F4FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000F4FF0000F4FF0000F4FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E6FF0000E6FFC1C1E3FF0000
      00FF000000FF000000FF000000FFBBBBDBFF000043FF000043FF000043FF0000
      2CFF00002CFF00002CFF00001DFF00001DFF002091FF0062C1FF000058FF0000
      00FF000000FF000000FF000000FF000000FF0000F6FF6060FBFF5C5CFAFF5757
      F9FF5453F9FF4E4EFAFF4949F7FF4343F6FF4343F6FF3D3DF5FF3939F4FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF0000F4FF6464FBFF5C5CFAFF5757
      F9FF5453F9FF5050F9FF4A4AF7FF4545FAFF4242F6FF3B3BF5FF3535F4FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF0000F4FF6060FBFF5C5CFAFF5757
      FCFF5555F9FF5151F8FF4A4AF7FF4444F7FF9696F6FFE6E6F6FF6B6B6BFF3535
      35FF353535FF626262FFE2E2F2FF0000DEFF000043FF6576B1FF6576B1FF596B
      ABFF596BABFF5163A7FF5163A7FF4A5DA2FF45599FFF4B89BEFF3AB2DDFF378E
      C3FF334894FF334894FF334894FF000000FF0000FAFF6565FCFF4343FAFF3E3E
      FAFF3939F9FF3333F8FF2C2CF7FF2929F6FF2424F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000DFFF0000FAFF6565FCFF4545FAFF3F3F
      FAFF393AF9FF8787F8FF8C8CF7FF3030F7FF2424F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF0000FAFF6565FCFF4343FBFF3C3B
      F9FF3C3BF9FF3535F7FF2B2BF6FF8B8BF5FFE2E3F4FF595959FF181817FF1818
      17FF4B4B4BFFDEDEF1FF8B8BF5FF0000DEFFFAFAFAFFFCFCFCFFFAFAFAFFFAFA
      FAFFFAFAFAFFF8F8F8FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFDFDFDFFF0000FAFF6969FCFF4849FBFF4545
      FBFF3E3EFAFF3939F9FF3333F8FF2F2FF7FF2929F6FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000DFFF0000FAFF6969FCFF4848FBFF4545
      FAFFB2B2FCFFE4E4F8FFD8D8F8FFD7D7F7FF3030F7FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000E0FF0000FAFF6A6AFCFF4849FBFF4343
      FBFF3C3BF9FF3C3BF9FF9393F9FFE6E6F6FF626262FF292929FF181817FF5252
      52FFE2E2F2FF7C7CF3FF3030F6FF0000DEFFFAFAFAFFC2F2FCFFB7E6E7FFDBB1
      5CFFD2A651FFD1A34BFFCEA045FFCC9D41FFCB9A3BFFC99636FFC79431FFC590
      2CFF28C9E4FF86A672FFCC9D41FF7C0F00FF0000FDFF6D6DFDFF4E4EFAFF4849
      FBFF4545FBFF4040FAFF3939F9FF3535F8FF2F2FF7FF2929F6FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E2FF0000FDFF6D6DFDFF5050F9FFA2A2
      FBFFF4F4FCFF7070FAFF393AF9FF6060FAFFB7B7F7FF7D7DFCFFD1D1F5FF1F1F
      F4FF1818F3FF1212F2FF3535F4FF0000E5FF0000FDFF6A6AFCFF4E4EFCFF4849
      FBFF4343FBFF9B9BFBFFE9E9F9FF6B6B6BFF292929FF292929FF595959FFE2E3
      F4FF7C7CF3FF1616F3FF3535F7FF0000E6FF8DE9FDFF8DE9FDFF6DE4FDFFC2F2
      FCFFEFE2C9FFD2A651FFCFA44BFFCEA045FFCC9D41FFCB9A3BFF67B9A7FF28C9
      E4FFC5902CFFC28D27FFCC9D41FF7C0F00FF0000FDFF6D6DFDFF5252FDFF4E4E
      FAFF4B4AFCFF4545FBFF4040FAFF3B3AF9FF3535F8FF2F2FF7FF2929F6FF2424
      F5FF1E1EF4FF1818F3FF3939F4FF0000E6FF0000FDFF7170FEFF5252FDFFC0BF
      FCFFF4F4FCFF4545FAFF3F3FFAFF393AF9FFE4E4F8FFF5F5F7FFEFEFF6FF6161
      F5FF1E1EF4FF1818F3FF3B3BF5FF0000E5FF0000FDFF7473FEFF5252FDFF4E4E
      FCFF9B9BFBFFEDEDFAFF747474FF353535FF353535FF626262FFE6E6F6FF8686
      F5FF2222F5FF1616F3FF3C3CF5FF0000E6FFFDFDFDFFA3BF9BFFA3BF9BFFFCFC
      FCFFFCFCFCFFF7F3E7FFCFA44BFFCFA44BFFCEA045FFCC9D41FFCB9A3BFFC996
      36FFC79431FF28C9E4FFA3BF9BFF7C0F00FFF1F1F1FFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFCFDFFFCFCFCFFFBFBFBFF4040FAFF3B3AF9FF3535F8FF2F2FF7FF2929
      F6FF2424F5FF1F1FF4FF3D3DF5FF0000E6FF0000FDFF7979FEFF5858FEFF7979
      FEFFF4F4FCFF7D7DFCFF4545FAFF7070FAFF3C3BF9FFE4E4F8FF4242F6FF2B2B
      F6FF2424F5FF1F1FF4FF3B3BF5FF0000E5FF0000FDFF7473FEFF5757FCFFA6A6
      FEFFEEEEFCFF7B7B7BFF434343FF434343FF6B6B6BFFE9E9F9FF8B8BF5FF2B2B
      F6FF2222F5FF2222F5FF3C3CF5FF0000E6FFFDFDFDFF6DE4FDFF6DE4FDFFFDFD
      FCFFEFE2C9FFD5AC5BFFD4A955FFD2A651FFCFA44BFFCEA045FFCC9D41FFCB9A
      3BFFC99737FF86A672FFCEA34FFF861C00FFF1F1F1FFFEFEFEFFD1D1FEFF5F5F
      FEFFD1D1FEFFFCFCFDFFFCFCFCFF4545FBFF4040FAFF3C3BF9FF3535F8FF2F2F
      F7FF2929F6FF2424F5FF4343F6FF0000E6FF0000FFFF7D7DFCFF5C5CFEFF5858
      FEFFB2B2FCFFE9E9FDFFE4E4FCFFC0BFFCFF4848FBFF3C3BF9FF3636F8FF3030
      F7FF2B2BF6FF2424F5FF4242F6FF0000E5FF0000FFFF7878FEFFA6A6FEFFF3F3
      FEFF858585FF525252FF4B4B4BFF747474FFEBEBFCFF9393F9FF3535F7FF3030
      F6FF2B2BF6FF2222F5FF4444F7FF0000E6FFFFFFFFFFFEFEFEFFF7F3E7FFE2BD
      70FFD9B062FFD5AC5BFFD5AC5BFFD4A955FFD2A651FFD1A34BFFCEA045FFCC9D
      41FFCB9A3BFF28C9E4FFA3BF9BFF861C00FFF1F1F1FFFFFFFFFF5F5FFEFF5D5C
      FEFF5D5CFEFFFCFCFDFFFDFDFDFF4B4AFCFF4545FBFF4040FAFF3C3BF9FF3535
      F8FF2F2FF7FF2C2CF7FF4949F7FF0000EAFF0000FFFF7D7DFCFF5C5CFEFF5C5C
      FEFF5858FEFF9E9EFDFF9E9EFDFF5454FCFF4545FAFF3F3FFAFF3C3BF9FF3636
      F8FF3030F7FF2B2BF6FF4A4AF7FF0000ECFF0000FFFFB5B5FEFFF3F3FEFF8585
      85FF595959FF525252FF7B7B7BFFEEEEFCFF9B9BFBFF4343FBFF3C3BF9FF3535
      F7FF3030F6FF2B2BF6FF4A4AF7FF0000ECFFFFFFFFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFAFAFAFFFAFAFAFFFAFAFAFFF8F8
      F8FFF6F6F6FFF6F6F6FFF8F8F8FFE9E9E9FFF1F1F1FFFFFFFFFFDADAFFFF7B7B
      FEFFDADAFFFFFEFEFEFFFEFDFDFF6D6DFDFF6969FCFF6565FCFF6060FBFF5C5C
      FAFF5757F9FF5151F8FF4E4EFAFF0000EAFF0000FFFF7D7DFCFF7979FEFF7979
      FEFF7575FEFF7575FEFF7170FEFF6D6DFDFF6969FCFF6464FBFF6060FAFF5C5C
      FAFF5757F9FF5453F9FF4A4AF7FF0000ECFF2424FFFFF3F3FEFF9C9C9CFF7B7B
      7BFF747474FF9C9C9CFFF3F3FEFFB5B5FEFF6A6AFCFF6565FCFF6060FBFF5C5C
      FAFF5555F9FF5151F8FF4A4AF7FF0000ECFF000068FF7E8DC0FF7E8DC0FF7E8D
      C0FF7989BDFF7989BDFF7081B8FF7081B8FF7081B8FF6576B1FF6576B1FF64AF
      D3FF64CDE4FF596BABFF4B89BEFF00002CFFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF1EFEFFFEFEFEFFF0000FDFF0000FAFF0000FAFF0000F6FF0000
      F6FF0000F2FF0000F2FF0000EEFF0000EEFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFFEBEBFCFF181817FF000000FF0000
      00FF181817FFE5E5FDFF5757FCFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFF000068FF000068FF000068FF0000
      68FF000064FF000064FF000058FF000058FF000058FF000058FF000043FF0000
      43FF000043FF000043FF005CA3FF00002CFFA60000FFA60000FFA60000FF9900
      00FF990000FF990000FF8B0000FF7A0000FF7A0000FF7A0000FF8B0000FF7A00
      00FF7A0000FF7A0000FF7A0000FF7A0000FF000C5AFF0000F2FF0000F2FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF001500FF000000FF000093FF0000
      ACFF000093FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000F4FF0000F4FF0000F4FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFFA60000FFDA7963FFD6745BFFD66D
      55FFCA7B68FF94AAA0FF64D0D8FF4DDCEBFF4DDCEBFF57CBD3FF8F958BFF6D85
      49FFCB5338FFC94B2FFFC84629FF7A0000FF000000FF61969DFF57B2FAFF5865
      F9FF5555F9FF5151F8FF4A4AF7FF4343F6FF4343F6FF3B3BF5FF3B3BF5FF3535
      F7FF3030F6FF2D2DF2FF2D2DF2FF0000DDFF001500FF789A63FF6C74CFFF747E
      D3FF6572CFFF698F50FF658C4CFF5E8745FF5B8441FF55803BFF547E39FF507B
      34FF4C7831FF4A752EFF48752BFF000000FF0000F4FF6060FBFF5C5CFAFF5757
      F9FF5453F9FF5151FAFF4A4AF7FF4343F6FF4343F6FF3B3BF5FF3636F6FF3232
      F4FF3232F4FF2C2CF4FF2C2CF4FF0000DDFFB40000FFDA7963FFD05C41FFC469
      51FF79A7A7FF56C3CBFF819E91FF63B2B1FF5CB0AFFF63A5A5FF6D8549FF3CA2
      54FFBD2F0EFFBD2F0EFFC94B2FFF7A0000FF000000FF696969FF458C88FF3ED7
      F2FF3A75F9FF3535F7FF2E2EF7FF2A2AF6FF2323F5FF1B1BF4FF1B1BF4FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF001500FF7C9E66FF929ADCFF5368
      D1FF7D85D5FF507B34FF4C7831FF457329FF427125FF3D6D1FFF39691AFF3364
      13FF2C610BFF2C610BFF4A752EFF000000FF0000FAFF6565FCFF4343FAFF3C3C
      FAFF3C3CFAFFB1B1FAFFD6D6F7FFEBEBF6FFEBEBF6FFA1A1F4FF5B5BF5FF1212
      F2FF0C0CF1FF0C0CF1FF2C2CF4FF0000E0FFB40000FFDE836DFFD4644BFFA295
      8CFF6DB9B9FF5EC8CFFF4CCED9FF4FBBC3FF63A5A5FFB5572BFF6D8549FF3CA2
      54FF6D8549FFBD2F0EFFC94B2FFF7A0000FF000000FF696969FF494949FF4A81
      7CFF43EDE8FF3BB3F9FF344BF8FF2E2EF7FF2A2AF6FF2323F5FF1B1BF4FF1B1B
      F4FF1212F2FF1212F2FF3030F6FF0000E0FF002700FF82A16DFF5B69CEFF5665
      99FF5264CDFF55803BFF507B34FF4C7831FF48752BFF427125FF3D6D1FFF3969
      1AFF336413FF336413FF4C7831FF000000FF0000FAFF6969FCFF4849FBFF4343
      FAFFABABFAFFABABFAFF6363F7FF3B3BF5FF5B5BF5FFB4B4F6FFABABF4FF5454
      F3FF1212F2FF1212F2FF3232F4FF0000E0FFB40000FFDE836DFFD4644BFF7EB6
      B8FF999C91FF57D2DDFF8F958BFFD15337FFC94B2FFFB5572BFF4FA45AFF47A4
      5FFF619696FFC33716FFCB5338FF7A0000FF000000FFA3A4A4FFE1E1E1FF514B
      4BFF447070FF43EDE8FF3AE5F9FF3A88F9FF2F39F7FF2A2AF6FF2323F5FF1B1B
      F4FF1B1BF4FF1212F2FF3535F7FF0000E5FF002700FF84A46FFF5E63C9FF5665
      99FF535AC5FF5B8441FF55803BFF507B34FF4C7831FF48752BFF427125FF3E6D
      20FF39691AFF336413FF507B34FF000000FF0000FDFF6D6DFDFF4E4EFCFF4849
      FBFFB1B1FAFF6D6DFAFF9C9CF9FFE7E7F8FF9C9CF9FF7B7BF6FFDBDBF6FF5B5B
      F5FF1919F3FF1212F2FF3636F6FF0000E5FFB40000FFDE836DFFD66D55FF6DCD
      D6FF9BA297FF75BAB9FFC46951FFD15337FFD15337FFBD5E44FF63B2B1FF858E
      82FF4FBBC3FFC33716FFCB5338FF8B0000FF000000FFE1E1E1FFE1E1E1FFE1E1
      E1FF494949FF458C88FF3FFAF9FF3BF9F9FF3A88F9FF2E2EF7FF2A2AF6FF2323
      F5FF1B1BF4FF1B1BF4FF3B3BF5FF0000E5FF003100FF88A774FF6471D2FF5D5F
      B7FF5B69CEFF608846FF5B8441FF55803BFF789A63FF5B8441FF48752BFF4271
      25FF3E6D20FF39691AFF547E39FF000000FF0000FDFF7170FEFF5252FDFF4E4E
      FCFFB2B2FCFF5151FAFFE9E9FAFF7676F9FF4343F6FFB4B4F6FFEBEBF6FF5B5B
      F5FF2222F5FF1919F3FF3B3BF5FF0000E5FFC40100FFE59279FFD66D55FF94AA
      A0FFA2958CFFD66D55FFF7E9E6FFD05C41FFD15337FF8F958BFF63B2B1FF858E
      82FF63A5A5FFC63E1FFFD05C41FF8B0000FF000000FFA3A4A4FFE1E1E1FF5957
      57FF4A817CFF43EDE8FF51DFFAFF3A88F9FF4243FAFF3535F7FF2E2EF7FF2A2A
      F6FF2323F5FF1B1BF4FF3B3BF5FF0000E5FF003100FF8AA875FF666CCCFF5F62
      C1FF5E63C9FF658C4CFF82A16DFFDCE4D6FFDCE4D6FF9EB68FFF5B8441FF4875
      2BFF427125FF3E6D20FF5B8441FF000000FF0000FDFF7575FDFF5858FEFF5353
      FDFFB5B5FDFF7575FDFF9C9CF9FFE9E9FAFF8383F9FF8383F9FFDBDBF6FF6363
      F7FF2222F5FF2222F5FF3B3BF5FF0000E5FFC40100FFE59279FFDE7B5DFFD66D
      55FFD6745BFFF7E9E6FFD6745BFF7DB3B2FF7DB3B2FF6DB9B9FF6DB9B9FF56C3
      CBFF8D8379FFC84629FFD05C41FF8B0000FF000000FF797979FF595757FF5896
      8FFF54F3F6FF57B2FAFF4B5BFCFF4243FAFF4243FAFF3C3BF9FF3535F7FF3030
      F6FF2A2AF6FF2323F5FF4343F6FF0000E5FF003800FF8FAB7BFF6B78D4FF6572
      CFFF6471D2FF698F50FFBECEB5FF608846FFC8D4BFFFE6ECE3FF789A63FF507B
      34FF48752BFF457329FF5E8745FF000000FF0000FFFF7979FFFF5C5CFEFF5858
      FEFFB5B5FDFFB5B5FDFF7575FDFF5151FAFF6D6DFAFFBDBDF9FF9394F8FF6667
      F7FF2C2CF4FF2222F5FF4343F6FF0000E5FFC50400FFE59279FFDE7B5DFFDE7B
      5DFFF7E9E6FFBE8B7AFF78C6C9FF94AAA0FF94AAA0FF94AAA0FF5EC8CFFF79A7
      A7FFBD5E44FFC84629FFD4644BFF8B0000FF000000FF797979FF5EA29AFF51DF
      FAFF5985FEFF5252FDFF5252FDFF4B4BFCFF4243FAFF4243FAFF3C3BF9FF3535
      F7FF3030F6FF2A2AF6FF4A4AF7FF0000ECFF003800FF8FAB7BFF6C74CFFF6F8A
      DEFF666CCCFF95B085FF698F50FF8FAB7BFF618A48FFE6ECE3FF72965CFF547E
      39FF507B34FF4A752EFF618A48FF000000FF0000FFFF7979FFFF5C5CFEFF5C5C
      FEFF5858FEFFC1C1FDFFDFDFFDFFEFEFFCFFEFEFFCFFB1B1FAFF7777F9FF3636
      F6FF3232F4FF2C2CF4FF4A4AF7FF0000ECFFC40100FFE59279FFE59279FFE592
      79FFDA917EFFA8B4AFFF86DCE3FF71E7F4FF71E7F4FF7BD9DFFFA8B4AFFFCA7B
      68FFD66D55FFD66D55FFD4644BFF990000FF000000FF7BABB3FF7BBAFDFF7981
      FEFF7373FEFF7373FEFF7373FEFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5B5B
      FAFF5555F9FF5151F8FF4A4AF7FF0000ECFF003800FF8FAB7BFF8C92DDFF8C92
      DDFF99A1E2FF88A774FF92AE80FF82A16DFFC9D6C1FF9EB68FFF779961FF7296
      5CFF6D9256FF698F50FF658C4CFF000000FF0000FFFF7979FFFF7979FFFF7979
      FFFF7575FDFF7575FDFF7170FEFF6D6DFDFF6969FCFF6565FCFF6060FBFF5C5C
      FAFF5757F9FF5453F9FF4A4AF7FF0000ECFFC50400FFC50400FFC50400FFC504
      00FFC40100FFB40000FFB40000FFA60000FFA60000FFA60000FFB40000FFA600
      00FFA60000FFA60000FF990000FF990000FF000C5AFF0008FFFF0000FDFF0000
      FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F9FF0000F9FF0000F9FF0000
      F2FF0000F2FF0000F2FF0000ECFF0000ECFF003800FF003800FF1826BBFF0000
      ACFF000093FF003100FF002700FF2C610BFF002700FF001500FF001500FF0015
      00FF000000FF000000FF000000FF000000FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFF560000FF560000FF450000FF4500
      00FF450000FF450000FF2C0000FF2C0000FF2C0000FF2C0000FF140000FF1400
      00FF140000FF140000FF140000FF140000FF007100FF006100FF006100FF0061
      00FF004B00FF004B00FF004B00FF004B00FF004B00FF003000FF003000FF0030
      00FF003000FF003000FF003000FF003000FF0000F4FF0000F4FF0000F4FF0000
      EDFF0000EDFF0000EDFF0000EDFF0000EDFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF001900FF001900FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF560000FFB88475FFB77E70FFB37B
      6DFFB37869FFAF7464FFAE7060FFA96C5DFFA76859FFA46455FFA25F4EFFC29B
      91FFEAE4E2FFB88475FF974C39FF140000FF007100FF5FBD61FF5FBD61FF55B9
      57FF55B957FF4DB44FFF4DB44FFF45B049FF41AE44FF3AAC3EFF3AAC3EFF35A7
      37FF35A737FF2DA330FF2DA330FF003000FF0000F4FF7373FCFF6E6EFAFF6969
      FAFF6969FAFF6463F9FF5F5FF8FF5B5BF8FF5757F7FF5454F6FF4B4BF3FF4B4B
      F3FF4B4BF3FF4444F2FF4444F2FF0000DDFF001900FF63A063FF5C9A5CFF5797
      57FF529351FF529351FF4A8E4AFF438A43FF438A43FF3D863DFF398339FF3480
      34FF317C31FF2C792CFF2C792CFF000000FF680000FFBA897BFFAC6C5CFFA867
      57FFA66352FFA45F4EFFA05A49FF9D5544FF9A513FFF974C39FFA26352FFEAE4
      E2FFD6C2BCFFE7E0DEFFB38174FF140000FF05B8D5FF65DCEBFF47D6EBFF39CF
      E3FF39CFE3FF39CFE3FF2CCDE6FF28C8DDFF28C8DDFF15C3DAFF15C3DAFF15C3
      DAFF15C3DAFF05B8D5FF28C8DDFF007CABFFF8F8F8FFFCFCFCFFFAFAFAFFFAFA
      FAFFF8F8F8FFF8F8F8FFF8F8F8FFF6F6F6FFF6F6F6FFF4F4F4FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFDFDFDFFF001900FF63A063FF438A43FF3D86
      3DFF398339FF348034FF2D7B2DFF2C792CFF227422FF1D701DFF156B15FF156B
      15FF0C650CFF0C650CFF2D7B2DFF000000FF680000FFBA897BFFAE7060FFAC6C
      5CFFA86757FFA66352FFA45F4EFFA05A49FF9D5544FF9A513FFF9B5441FFBA89
      7BFFD6C2BCFF9A513FFF984F3DFF140000FF00C5FBFF69E4FCFF48DDFBFF43DA
      FBFF3CDAFAFF3CDAFAFF34D5F8FF2FD3F7FF2AD1F6FF22CEF5FF22CEF5FF13C9
      F2FF13C9F2FF13C9F2FF31CEF3FF0092DAFF990C0AFFD29493FFC67B7AFFC477
      76FFC47272FFC16F6EFFBF6B69FFBB6766FFBA6261FFB85B5AFFB55A58FFB453
      52FFB45352FFAF4F4DFFBB6766FF5A0000FFF2F2F2FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF9F9F9FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFD3D3D3FF680000FFBF8E82FFAF7464FFAE70
      60FFAC6C5CFFA86757FFA66352FFA45F4EFFA05A49FF9D5544FFBA897BFFEEE9
      E8FFEDE8E6FFE7E0DEFFBA897BFF140000FF0000FDFF7574FEFF5A5AFDFF5252
      FBFF5252FBFF4848FAFF4848FAFF34B054FF2EB060FF24AB5BFF24AB5BFF18A5
      4EFF18A54EFF18A54EFF33B267FF004B00FF7A0000FFC16F6EFFB44E4EFFB249
      49FFAF4545FFAB3F3FFFA83A3AFFA63535FFA52F2FFFA12B2BFF9D2222FF9D22
      22FF971919FF971919FFA63535FF2D0000FFF2F2F2FFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFF83DBF7FF60D1F6FF5CCFF5FF77D6F4FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD3D3D3FF680000FFC19185FFB37869FFFCFC
      FCFFFCFCFCFFFBFBFBFF4040FAFF3938F9FF3938F9FF9A513FFF994D3BFF9548
      35FF924330FF90402CFFA05A49FF2C0000FF0000FDFF8585FFFF5A5AFDFF5A5A
      FDFF5252FBFF4848FAFF4848FAFF3AB13AFF35A737FF2DA330FF2AA029FF249D
      24FF1C991CFF1C991CFF35A737FF003000FF7A0000FFC47272FFB45352FFB44E
      4EFFB24949FFAF4545FFAB3F3FFFAB3A3AFFA63535FFA52F2FFFA12B2BFF9D22
      22FF9D2222FF971919FFA83A3AFF2D0000FFF3F3F3FFFEFEFEFFFDFDFDFFFCFC
      FCFF8DDEF8FFFBFBFBFFFAFAFAFF9CE1F7FF97DFF6FFF7F7F7FFF6F6F6FF73D5
      F4FFF4F4F4FFF3F3F3FFF5F5F4FFD3D3D3FF680000FFC49589FFB57B6DFFFDFD
      FDFFFCFCFCFFFCFCFCFF4646FBFF4040FAFF3938F9FF9F5744FF9C5240FF974C
      39FF954835FF924330FFA25F4EFF2C0000FF0000FDFF7574FEFFB6B5FEFFE4E4
      FDFFB6B5FEFF4848FAFF5252FBFF3EB871FF3EB871FF33B267FF33B267FF2AAE
      62FF24AB5BFF24AB5BFF3EB871FF004B00FF7A0000FFC47776FFB55A58FFB453
      52FFB44E4EFFB24949FFAF4545FFAB3F3FFFAB3A3AFFA63535FFA52F2FFFA12B
      2BFF9D2222FF9D2222FFAB3F3FFF2D0000FFF5F5F5FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFF8DDEF8FFB6E9F9FF9CE1F7FF9CE1F7FFDDF2F8FF7DD9F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD8D8D8FF760800FFC49589FFB77E70FFFEFE
      FEFFFDFDFDFFFDFDFDFF4B4BFCFF4646FBFF4040FAFFA35C4AFF9F5744FF9C52
      40FF994D3BFF954835FFA46251FF2C0000FF0000FFFF7B7BFEFFDCDCFEFFFEFE
      FEFFDCDCFEFF5A5AFDFF5252FBFF46E3FBFF43DAFBFF3BD6F9FF34D5F8FF2FD3
      F7FF2AD1F6FF22CEF5FF42D6F2FF009DE7FFB14440FFDDAEADFFD69B9AFFD69B
      9AFFD29493FFD29493FFD29493FFCD8C8AFFCD8C8AFFC98584FFC98584FFC680
      7EFFC67B7AFFC47776FFCD8C8AFF7A0000FFF5F5F5FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFF7DD9F6FFAAE5F9FFAAE5F9FF73D5F4FFF5F5F5FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD8D8D8FF760800FFC6988CFFB88475FFFEFE
      FEFFFEFEFEFFFDFDFDFF5050FDFF4B4BFCFF4646FBFFA45F4EFFA35C4AFF9F57
      44FF9C5340FF994D3BFFA86757FF2C0000FF0000FFFF8585FFFF9B9BFEFFD0D0
      FEFF7574FEFF5A5AFDFF5A5AFDFF47D6EBFF42D6F2FF42D6F2FF42D6F2FF33D1
      EEFF33D1EEFF2CCDE6FF47D6EBFF0092DAFFFFFFFFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFAFAFAFFF8F8F8FFF8F8
      F8FFF8F8F8FFF6F6F6FFF8F8F8FFE9E9E9FF0000BFFF797AE4FF5B5BDDFF5B5B
      DDFF5B5BDDFF5555DAFF5151D9FF4C4CD7FF4444D6FF4444D6FF3C3BD3FF3333
      D1FF3333D1FF2B2BCEFF4848D4FF000099FF760800FFC6988CFFC6988CFFFEFE
      FEFFFEFEFEFFFEFEFEFF6C6CFDFF6C6CFDFF6C6CFDFFB77E70FFB37A6CFFB276
      68FFAF7464FFAC6E5FFFA96A5BFF2C0000FF0000FFFF7B7BFEFF7B7BFEFF7B7B
      FEFF7574FEFF7B7BFEFF7B7BFEFF6AC66CFF6AC66CFF5FBD61FF5FBD61FF5FBD
      61FF55B957FF55B957FF4DB44FFF004B00FF0000FFFF8182FFFF8182FFFF8182
      FFFF8182FFFF7A79FEFF7A79FEFF7373FCFF7373FCFF6D6DFCFF6969FAFF6463
      F9FF5F5FF8FF5B5BF8FF5757F7FF0000EDFF0000BFFF797AE4FF797AE4FF797A
      E4FF7373E2FF7373E2FF7373E2FF6A6ADFFF6A6ADFFF6262DDFF6262DDFF5B5B
      DDFF5555DAFF5151D9FF4C4CD7FF000099FF760800FF760800FF760800FFFEFE
      FEFFFDFDFDFFFDFDFDFF0000FCFF0000FCFF0000FCFF680000FF560000FF5600
      00FF560000FF450000FF450000FF450000FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF007E00FF007100FF007100FF007100FF0071
      00FF006100FF006100FF006100FF006100FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000EDFF0000EDFF0000BFFF0000BFFF0000BFFF0000
      BFFF0000BCFF0000BCFF0000BCFF0000B4FF0000B4FF0000B4FF0000ADFF0000
      ADFF0000A4FF0000A4FF0000A4FF000099FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFBA712EFFB0631AFFB0631AFFA559
      0BFFA5590BFF9D4400FF9D4400FF9D4400FF9D4400FF9D4400FF8E2E00FF8E2E
      00FF8E2E00FF8E2E00FF8E2E00FF8E2E00FF4A0000FF4A0000FF4A0000FF4A00
      00FF4A0000FF2F0000FF2F0000FF2F0000FF2F0000FF2F0000FF130000FF1300
      00FF130000FF130000FF130000FF130000FFA31500FF960000FF960000FF9600
      00FF960000FF00ABC1FF00B9D6FF00B9D6FF00B9D6FF00B9D6FF0097CDFF0000
      C8FF0000C0FF0000C0FF0000C0FF0000C0FF000000FF636363FF5A5A5AFF5A5A
      5AFF525151FF525151FF4A4A4AFF434343FF434343FF3D3D3DFF393939FF3333
      33FF333333FF2C2C2CFF2C2C2CFF000000FFB97B37FFD9C4A5FFD9C4A5FFD6C0
      9FFFD6C09FFFD3BC99FFD3BC99FFCFB996FFC9B28DFFC9B28DFFC9B28DFFC9B2
      8DFFC5AD84FFC5AD84FFC5AD84FF763C00FF600000FFB98460FFB5805CFFB379
      54FFB37954FFAE744EFFAE7049FFAC6B44FFAA673FFFA5643AFFA5643AFFA15F
      35FFA05B31FFA05B31FF9D562BFF130000FFA31500FFD59277FFD59277FFD48E
      70FFD28668FF82DEE8FF72E5F2FF72E2EEFF6DE2EDFF6DE2EDFF65D5EEFF4947
      E7FF4746E6FF4343E5FF4343E5FF0000C0FF000000FF636363FF434343FF3D3D
      3DFF393939FF333333FF2C2C2CFF2C2C2CFF202020FF202020FF151515FF1515
      15FF0C0C0CFF0C0C0CFF2C2C2CFF000000FF0191F3FF7BC9F9FF63BDF5FF63BD
      F5FF57B7F2FF57B7F2FF57B7F2FF4DB1EEFF4DB1EEFF42ACEDFF42ACEDFF38A6
      EAFF38A6EAFF38A6EAFF52B2EDFF0052D7FF600000FFBA8865FFAC6B44FFAA67
      3FFFA5643AFFA15F35FFA05B31FF9D562BFF984F21FF984F21FF845631FF8456
      31FF7D4F2AFF7D4F2AFFA05B31FF130000FFA31500FFD59277FFCF7D5EFFCC76
      55FFCC7655FF71D9E4FF61E1EFFF5CDEEDFF5CDEEDFF56DEEBFF4FCDE9FF2827
      E2FF2827E2FF2827E2FF4343E5FF0000C0FFEEEEEEFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFCFCFCFFF000082FF7475C8FF4B4BB2FF4B4B
      B2FF3F42B3FF393993FF33334DFF33333AFFBCBFC5FFB2B6E4FF3334ABFF1616
      99FF161699FF161699FF3334ABFF00003CFF600000FFBD8C6AFFAE7049FFAC6B
      44FFAA673FFFA5643AFFA15F35FFA05B31FF9D562BFF984F21FF786751FF34B3
      C9FF34B3C9FF786751FFA05B31FF130000FFAB2400FFDA9D85FFCF8364FFCF7D
      5EFFCC7655FF71D9E4FF63E3F0FF61E1EFFF5CDEEDFF5AE0ECFF53D0EAFF2E2C
      E4FF2E2CE4FF2827E2FF4746E6FF0000C0FFEEEEEEFFFDFDFDFFFCFCFCFFFBFC
      FBFFF6FBF4FF9FD59DFFF0F9F1FFF8F8F8FFF7F7F7FFF6F6F6FF8ECE8CFFE1F0
      E1FFF3F3F3FFF2F2F2FFF4F4F4FFD1D1D1FF000082FF7475C8FFB69DA1FFC7A8
      9BFF45449AFF48484FFF48484FFF33333AFFBCBFC5FFDEE0E3FFAFAEC7FF3334
      ABFF907183FFB58D78FF3334ABFF00003CFF600000FFBD8C6AFFAE744EFFAE70
      49FFAC6B44FFAA673FFFA5643AFFA15F35FFA05B31FF9D562BFF40A4C0FF4CBF
      83FF43C390FF3D9BB1FFA05B31FF130000FFAB2400FFDA9D85FFD28668FFCF83
      64FFCF7D5EFF7ADDE7FF69E5F1FF67E2F0FF61E1EFFF61E1EFFF5BD2EDFF3331
      E5FF3331E5FF2E2CE4FF4C4CE9FF0000C8FFEEEEEEFFFEFEFEFFFDFDFDFFFCFC
      FCFFA7DBA5FF5DBA5BFF9FD59DFFF9F9F9FFF8F8F8FF9FD59DFF5DBA5BFF8ECE
      8CFFF4F4F4FFF3F3F3FFF5F5F5FFD1D1D1FF000082FF7475C8FF74A8DCFF74A8
      DCFF48484FFF989BA3FF989BA3FF48484FFFBCBFC5FF616065FF898B8FFFB9C2
      E5FF4180BAFF4E8BCBFF3F42B3FF00003CFF623567FFB9948AFFB37954FFA277
      7AFF9C7380FFAC6B44FFB98460FFA78693FFA15F35FFA4582EFF40B2D2FF34B3
      C9FF34B3C9FF40A4C0FFA9613BFF130000FFB32C00FFDA9D85FFD48A6DFFD286
      68FFCF7D5EFF7ADDE7FF6DE5F2FF6DE5F2FF67E2F0FF63E3F0FF5BD2EDFF3938
      E7FF3938E7FF3331E5FF4C4CE9FF0000C8FFF1F1F1FFFEFEFEFFFEFEFEFFFDFD
      FDFFF6FBF4FFA7DBA5FFF6FBF4FFFAFAFAFFF9F9F9FFF6F8F3FF9FD59DFFEBF3
      E9FFF5F5F5FFF4F4F4FFF5F5F5FFD6D6D6FF000082FF7475C8FF595ABFFF609A
      DCFF609ADCFF48484FFF48484FFF48484FFFC8CCD9FFE7EBF4FFC8CCD9FF4E8B
      CBFFC8CCD9FF1F1F79FF3F42B3FF00003CFFA9725EFFCFC8E2FFB99797FF9984
      B3FF9387CBFFD3AE95FFB7ADD6FFA78693FFA5643AFFAA673FFFA1D2E4FFCDE9
      F6FF31B5E5FF469FB7FFAA673FFF2F0000FFB32C00FFDDA48EFFD48E70FFD48A
      6DFFD48464FF82DEE8FF74E8F3FF72E5F2FF6DE5F2FF69E5F1FF65D5EEFF3E3D
      E8FF3E3DE8FF3938E7FF5758EAFF0000C8FFF1F1F1FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD6D6D6FF000082FF7475C8FF595ABFFF595A
      BFFF5357C2FF5050A2FF48484FFF48484FFFE7EBF4FFB9C2E5FF4B52BCFF3334
      ABFF2829A6FF2829A6FF3F42B3FF00003CFF623567FFC2B9DBFFA6A7F1FF817E
      E0FF8A89E6FFA6A7F1FF9387CBFF9984B3FFAC6B44FFA9613BFF4FBADDFF5DCB
      F0FF31B5E5FF4EA2B8FFAC6B44FF2F0000FFB33402FFDDA48EFFD59277FFD48E
      70FFD28668FF87E2EAFF79E9F5FF74E8F3FF72E5F2FF6DE5F2FF65D5EEFF4745
      EAFF4141E9FF3E3DE8FF5758EAFF0000C8FF0000FFFF797AFFFF5D5DFEFF5D5D
      FEFF5858FEFF5353FDFF5050FDFF4B4BF9FF4444FBFF4444FBFF3C3BF9FF3636
      F8FF3030F7FF2B2BF6FF4B4BF9FF0000ECFF0191F3FF94D4FBFF7BC9F9FF7BC9
      F9FF7BC9F9FF7BC9F9FF6DC1F5FF6DC1F5FF6DC1F5FF63BDF5FF63BDF5FF57B7
      F2FF57B7F2FF57B7F2FF6DC1F5FF0052D7FF1818CDFF8A89E6FF8A89E6FF7677
      E5FF6867E2FF7677E5FF7677E5FF736ED5FFA86E4FFFAA673FFF997558FF8D85
      72FF8D8572FF997558FFAE7049FF2F0000FFB33402FFDDA48EFFD59277FFD48E
      70FFD48A6DFF87E2EAFF79E9F5FF79E9F5FF74E8F3FF74E8F3FF6BD9F1FF4C4C
      E9FF4745EAFF4141E9FF5758EAFF0000C8FF0000FFFF797AFFFF797AFFFF797A
      FFFF7575FEFF7575FEFF706FFDFF6A6AFDFF6A6AFDFF6262FCFF5D5DFEFF5B5B
      FAFF5656F9FF5252F8FF4B4BF9FF0000ECFFC68B4EFFE1CEB2FFE1CEB2FFE1CE
      B2FFE1CEB2FFDECAADFFDECAADFFDECAADFFD9C4A5FFD9C4A5FFD9C4A5FFD6C0
      9FFFD6C09FFFD3BC99FFD3BC99FFA5590BFF8A2B09FFC2B9DBFFDED4DDFFB7AD
      D6FFA99FD6FFC2B9DBFFCFC8E2FFD3AE95FFBA8865FFBA8865FFB98460FFB580
      5CFFB37954FFB37954FFAE744EFF2F0000FFB33402FFDDA48EFFDDA48EFFDDA4
      8EFFDA9D85FF9EE8EFFF94EEF8FF94EEF8FF8FEDF7FF8FEDF7FF88E1F4FF6766
      EEFF6766EEFF6766EEFF6766EEFF0000D9FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFFC68B4EFFC68B4EFFC68B4EFFC68B
      4EFFC48343FFC48343FFC48343FFB97B37FFB97B37FFBA712EFFBA712EFFB063
      1AFFB0631AFFB0631AFFA5590BFFB0631AFF7766B6FFA2777AFF8A2B09FF4422
      7AFF44227AFF8A2B09FF623567FF7766B6FF600000FF600000FF600000FF4A00
      00FF4A0000FF4A0000FF4A0000FF4A0000FFB94214FFB33402FFB33402FFB334
      02FFB32C00FF20C9DBFF04D6EEFF04D6EEFF04D6EEFF04D6EEFF00BBE7FF0000
      D9FF0000D9FF0000D9FF0000D9FF0000D9FFF67200FFF26400FFF26400FFEF5D
      00FFED5300FFED5300FFE94700FFE94700FFE94700FFE33800FFE33800FFE338
      00FFDE2B00FFDE2B00FFDE2B00FFE33800FF007400FF006100FF006100FF0061
      00FF004D00FF004D00FF004D00FF004D00FF004D00FF003100FF003100FF0031
      00FF003100FF003100FF003100FF003100FF0000B4FF006A00FF006A00FF0051
      00FF005100FF005100FF005100FF005100FF005100FF003200FF003200FF0032
      00FF003200FF002900FF002900FF003200FFC30000FFC30000FFC30000FFC300
      00FFB70000FFB70000FFB70000FFB70000FFAA0000FFAA0000FFAA0000FFAA00
      00FFA00000FFA00000FFA00000FFA00000FFF66D00FFFABD80FFFABC7CFFF9B9
      78FFF9B774FFF8B470FFF7B26CFFF7B068FFF9AE62FFF6AC61FFF5A85AFFF5A8
      5AFFF3A658FFF2A455FFF2A252FFDE2B00FF007400FF67C166FF62BE60FF5DBD
      5CFF59BA57FF54B853FF4FB54DFF48B247FF48B247FF41AE40FF3CAC3AFF3CAC
      3AFF36A834FF32A631FF32A631FF003100FF0000F1FF617ECCFF5BBE5EFF54BA
      58FF54BA58FF4CB650FF4CB650FF46B34AFF40B145FF3BAF40FF33AB39FF33AB
      39FF2DA632FF2DA632FF2DA632FF002900FFCA0600FFE79077FFE78D73FFE589
      6FFFE4866BFFE38367FFE38064FFE17B5FFFDD785BFFDC7457FFDE7052FFDA6E
      51FFD96A4CFFD96A4CFFD86748FFA00000FFF97500FFFCC084FFFBB268FFFBB0
      63FFF6AC61FFF8AA5BFFF6A654FFF5A24EFFF49F49FFF49D45FFF39C45FFF299
      40FFF1963AFFF1963AFFF2A455FFDE2B00FFECF2ECFFF8FBF7FFF8FBF7FFF5F9
      F5FFF5F9F5FFF5F9F5FFF3F6F2FFECF2ECFFECF2ECFFECF2ECFFE9EFE8FFE9EF
      E8FFE9EFE8FFE9EFE8FFE9EFE8FFCBD9C9FF0000FFFF6576E0FF436EBAFF40B1
      45FF3BAF40FF33AB39FF2DA632FF2DA632FF22A429FF1BA122FF1BA122FF129D
      1BFF0C9914FF0C9914FF2DA632FF003200FFCA0600FFE89179FFE2785BFFE074
      57FFDE7052FFDD6C4CFFDB6646FFDB6646FFD9603FFFD65B3AFFD55735FFD352
      2EFFD3522EFFD14D28FFD86748FFA00000FFFC7A00FFFBC289FFFBB46BFFFBB2
      68FFFBB063FFF8AA5BFFFAD3ACFFFABD80FFF6B879FFF6C99AFFF39C45FFF39C
      45FFF29940FFF1963AFFF3A658FFDE2B00FF0000FDFF7676FDFF5D5CF9FF5958
      FDFF5454FBFF4F50F8FF4F50F8FF4A4AF6FF4247F6FF3D42F5FF3736F4FF3231
      F5FF2F2DF2FF2A2AF5FF4A4AF6FF0000DFFF0000FFFF6C6CFDFF4B66F9FF448A
      F6FF44F4EDFF37F2EBFF37F2EBFF2CF1EAFF2CF1EAFF26ECE8FF1BEEE6FF1BEE
      E6FF11ECE4FF11ECE4FF33ECE9FF00BF95FFF3C9BDFFFAE7E1FFF6DFD7FFF4DC
      D5FFF4DCD5FFF4DAD3FFF2D8D1FFF0D6CDFFEFD4CCFFEFD4CCFFEED1C9FFEED1
      C9FFEBCDC4FFEBCDC4FFEFD4CCFFD39987FFFD8104FFFDC48BFFFDB770FFFBB4
      6BFFFBB268FFF9AE62FFF9C490FFF8EDE2FFF8EDE2FFFBC289FFF49D45FFF49F
      49FFF39C45FFF29940FFF5A85AFFE33800FF0000FDFF6F6DFEFF4E4EFCFF4949
      FCFF4545FBFF4140F8FF37C8F9FF31B6F8FF31B6F8FF29C2F6FF2121F5FF2121
      F5FF1717F3FF1717F3FF3736F4FF0000E6FF0000FFFF6C6CFDFF5253FDFF4876
      FBFF448AF6FF45FBFBFF37F9F9FF33ECE9FF2F9D9FFF25F5F5FF25F5F5FF1EE5
      E6FF19979AFF13F2F2FF32F6F6FF00D2B8FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFF8F8F8FFA0CCB9FFA0CCB9FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE5E5E5FFFD8104FFFEC68EFFFDBA75FFFDB7
      70FFFBB46BFFFBB46BFFFADDC1FFF9F4F1FFF9F4F1FFF7DABEFFF6A654FFF5A1
      4CFFF49F49FFF39C45FFF6AC61FFE33800FF0000FDFF6F6DFEFF5454FBFF4E4E
      FCFF4949FCFF4545FBFF3F82FAFF38F3F9FF38F3F9FF2F7BF7FF2A2AF5FF2121
      F5FF2121F5FF1717F3FF3C3CF5FF0000E6FF0000FFFF7575FEFF5253FDFF4B66
      F9FF4B66F9FF45FBFBFF3DF6F5FF2F9D9FFF2A3737FF35A9ACFF25F5F5FF248A
      8CFF2A3737FF19979AFF3DF6F5FF00D2B8FFFDFDFDFFFDFDFDFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFF2D2C8FF61AE8FFF61AE8FFFEBCDC4FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE5E5E5FFFE850CFFFEC994FFFEBC78FFFDBA
      75FFFDB770FFFAD3ACFFFBDAB8FFFAE9D8FFFAE9D8FFF8D5B2FFF6C99AFFF6A4
      50FFF5A24EFFF49F49FFF9AE62FFE33800FF0000FDFF7676FDFF5958FDFF5454
      FBFF4E4EFCFF4949FCFF45CDFBFF3ED8FAFF3ED8FAFF37C8F9FF3231F5FF2A2A
      F5FF2121F5FF2121F5FF3C3CF5FF0000E6FF0000FFFF7575FEFF5253FDFF5380
      FDFF5495F7FF45FBFBFF45FBFBFF40EFF0FF35A9ACFF37F9F9FF32F6F6FF26EC
      E8FF2F9D9FFF25F5F5FF3DF6F5FF00D2B8FFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFCFCFCFFFCFCFCFFFBFBFBFF78D6E9FF80D4DEFFF8F8F8FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FFFE870FFFFEC994FFFEBE7CFFFEBC
      78FFFDBA75FFFDB770FFFBB063FFFAD3ACFFFAD3ACFFF9A754FFF8AA5BFFF5A8
      5AFFF6A654FFF5A24EFFF7B068FFE94700FF0000FDFF8C8AFEFF6F6DFEFF6F6D
      FEFF6F6DFEFF6564FDFF6564FDFF51ACFBFF51ACFBFF5454FBFF4F50F8FF4A4A
      F6FF4745F6FF4140F8FF5D5CF9FF0000E6FF0000FFFF7575FEFF5B74F5FF5495
      F7FF53F6F0FF50F5EEFF44F4EDFF44F4EDFF44F4EDFF37F2EBFF37F2EBFF2CF1
      EAFF2CF1EAFF26ECE8FF43EFE8FF00C79DFFF3C9BDFFFAE7E1FFF9E1DBFFF9E1
      DBFFF9E1DBFFF6DFD7FFF6DFD7FFF4DCD5FFF4DAD3FFF4DAD3FFF2D8D1FFF0D6
      CDFFEFD4CCFFEED1C9FFF2D8D1FFDBA193FFFF8912FFFEC994FFFEBE7CFFFEBE
      7CFFFEBC78FFFDBA75FFFDB770FFFDB770FFFBB46BFFFBB268FFF9AE62FFF8AA
      5BFFF5A85AFFF6A654FFF7B26CFFE94700FFF1F9EDFFFAFDFAFFFAFDFAFFFAFD
      FAFFFAFDFAFFFAFDFAFFF8FBF7FFF8FBF7FFF8FBF7FFF5F9F5FFF5F9F5FFF3F6
      F2FFF3F6F2FFF3F6F2FFF3F6F2FFD5E5D3FF0000FFFF7A84F1FF5E6DE8FF5BBE
      5EFF5BBE5EFF54BA58FF54BA58FF4CB650FF46B34AFF40B145FF3BAF40FF33AB
      39FF33AB39FF2DA632FF46B34AFF005100FFD42400FFEDA28DFFE78D73FFE78D
      73FFE5896FFFE4866BFFE38367FFE38064FFE17B5FFFE2785BFFE07355FFDE70
      52FFDD6C4CFFDB6646FFE17B5FFFB70000FFFE850CFFFEC994FFFEC994FFFEC9
      94FFFEC994FFFEC68EFFFEC68EFFFDC48BFFFBC289FFFCC084FFFABD80FFFABB
      7BFFF9B978FFF9B774FFF7B46FFFE94700FF008700FF7ACA7AFF7ACA7AFF7ACA
      7AFF7ACA7AFF74C874FF6FC56FFF6FC56FFF67C166FF67C166FF62BE60FF5DBD
      5CFF59BA57FF54B853FF4FB64FFF004D00FF0000F1FF7A84F1FF77CA79FF77CA
      79FF77CA79FF77CA79FF6EC571FF6EC571FF66C26AFF66C26AFF5BBE5EFF5BBE
      5EFF54BA58FF54BA58FF4CB650FF005100FFD72800FFEDA28DFFEDA28DFFEDA2
      8DFFEDA28DFFEB9B85FFEB9B85FFEB9B85FFE8967DFFE8967DFFE79077FFE78D
      73FFE5896FFFE4866BFFE38367FFB70000FFFF9120FFFF8912FFFF8912FFFF89
      12FFFE870FFFFE850CFFFD8104FFFC7A00FFFC7A00FFF97500FFF67200FFF66D
      00FFF26400FFF26400FFEF5D00FFEF5D00FF008700FF008700FF008700FF0087
      00FF008700FF008700FF008700FF007400FF007400FF007400FF007400FF0061
      00FF006100FF006100FF006100FF006100FF0000B4FF009300FF008300FF0083
      00FF008300FF008300FF008300FF008300FF008300FF006A00FF006A00FF006A
      00FF006A00FF006A00FF005100FF006A00FFD72800FFD72800FFD72800FFD728
      00FFD42400FFD42400FFD11900FFD11900FFCF1000FFCA0600FFCA0600FFC300
      00FFC30000FFC30000FFC30000FFB70000FF0000F2FF0000F2FF0000F2FF0000
      F2FF0000EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000E1FF0000E1FF0000
      E1FF0000E1FF0000DDFF0000DDFF0000DDFFA80000FFA80000FFA80000FF9700
      00FF970000FF970000FF970000FF880000FF880000FF880000FF880000FF7A00
      00FF7A0000FF7A0000FF7A0000FF7A0000FFF76800FFF25A00FFF25A00FFEF52
      00FFEC4600FFEC4600FFEC4600FFE73700FFE73700FFE73700FFE32B00FFE32B
      00FFDF2300FFDD1F00FFDD1F00FFDD1F00FF006800FF005500FF005500FF0055
      00FF005500FF00DCEAFF00DCEAFF00DCEAFF00D8E6FF00D8E6FF00D1E3FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000F8FF6163FCFF5A5AFAFF5957
      F8FF5251F9FF5251F9FF4545F8FF4545F8FF4545F8FF3636F4FF3636F4FF3636
      F4FF3636F4FF2A2AF4FF2A2AF4FF0000DDFFA80000FFDC6363FFD95A5AFFD95A
      5AFFD55151FFD55151FFD24848FFD24848FFD24242FFD03D3DFFCF3939FFCB33
      33FFCB3333FFC92A2AFFC92A2AFF7A0000FFF76800FFFBBE80FFFABB7AFFFABB
      7AFFFAB671FFFAB671FFF8B169FFF8B169FFF9AF64FFF6AB5FFFF4A85CFFF4A8
      5CFFF3A658FFF2A354FFF2A354FFDD1F00FF006800FF60BF5FFF5BBD5BFF57B9
      57FF53B953FF51FBFBFF45F7F7FF45F7F7FF45F7F7FF3AF4F5FF3AF4F5FF3636
      F6FF3030F4FF3030F4FF2B2BF5FF0000DDFF0000F8FF6163FCFF4545F8FF7975
      F5FFB3ADF0FF7975F5FF2A2AF4FF2A2AF4FF2A2AF4FF1818F3FF1818F3FF1818
      F3FF0C0CF1FF0C0CF1FF2A2AF4FF0000DDFFA80000FFDC6363FFD24242FFD03D
      3DFFCF3939FFCB3333FFD12C2CFFC92A2AFFC92A2AFFC51817FFC51817FFC518
      17FFC00C0CFFC00C0CFFC92A2AFF7A0000FFF76800FFFCC084FFF8B169FFF9AF
      64FFF6AB5FFFF8A958FFF7C694FF9F6F43FF9F6F43FFF4C08AFFF39B42FFF39B
      42FFF1963AFFF1963AFFF2A354FFDD1F00FF006800FF67C267FF40B245FF3CAE
      3DFF3CAE3DFF33F8F7FF2EF7F7FF29F6F6FF23F5F4FF1CF2F4FF1CF2F4FF1111
      F2FF1111F2FF1111F2FF3030F4FF0000E0FF0000A6FF8C7AE1FF9486E6FFDAC3
      D7FFD97565FFDAC3D7FF8C7AE1FF5941D0FF4F35CEFF4F35CEFF4F35CEFF4529
      CAFF4529CAFF3E22C7FF5941D0FF0000A6FFD12C2CFFEAA0A0FFE58A8AFFE58A
      8AFFE28282FFE28282FFE07B7BFFDD7879FFDC7272FFDC7272FFD96D6DFFD769
      69FFD66464FFD66464FFDD7879FFA80000FFFC7600FFFDC48BFFFBB46BFFF8B1
      69FFF9AF64FFD2AC69FFE1B37DFF64B5C2FF5FACBEFFD39D64FFD59347FFF39B
      42FFF39B42FFF1963AFFF3A658FFDF2300FF007800FF67C267FF49B549FF40B2
      45FF3CAE3DFF3AF9F9FF33F8F8FF2EF7F7FF29F6F6FF23F5F4FF1CF2F4FF1B1B
      F3FF1111F2FF1111F2FF3030F4FF0000E0FFCB1F00FFEB9983FFDAC3D7FFC374
      86FFD97565FFCE6D6AFFC3B3E0FFDD7258FFD7664FFFD66249FFD66249FFD25B
      43FFD4573BFFD4573BFFD86C54FFA50000FFFAF3F3FFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFDFD3D3FFFC7600FFFDC48BFFFAB671FFFBB4
      6BFFF8B169FF65A374FF64B5C2FF72B597FF72B597FF6698A5FF478D54FFF49F
      49FFF39B42FFF39B42FFF4A85CFFE32B00FF007800FF70C570FF50B750FF49B5
      49FF40B245FF40FAF9FF3AF9F9FF34CE8CFF2EC882FF29F6EFFF23F5F4FF1B1B
      F3FF1B1BF3FF1111F2FF3636F6FF0000E0FFCB1F00FFEB9983FF726AF0FF6163
      FCFFDEDEFDFF8587FCFF5A5AFAFFD37A76FFD86C54FFD7664FFFD66249FFD25B
      43FFD25B43FFD4573BFFD56F5CFFA50000FFFAF3F3FFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE2D6D6FFFC7600FFFDC48BFFFDB975FFFAB6
      71FFFBB46BFFD2CCA3FF5FACBEFFB1B78DFFB1B78DFF6698A5FFB1B78DFFF5A2
      4EFFF49F49FFF39B42FFF6AB5FFFE32B00FF007800FF70C570FF53B953FF50B7
      50FF49B549FF46FBFBFF3FE4C3FF3AB654FF40B245FF2FDEB1FF29F6F6FF2323
      F5FF1B1BF3FF1B1BF3FF3C3CF5FF0000E9FFCB1F00FFEB9983FF726AF0FFCCCD
      FDFFECEDFDFFE1E2FCFF5957F8FFD37A76FFD86C54FFD86C54FFD7664FFFD662
      49FFD25B43FFD25B43FFD56F5CFFA50000FFFAF3F3FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE2D6D6FFFDF7F1FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFF81B88EFF9ACCE0FF5CB4DDFF5CB4DDFF9ACCE0FF65A374FFF6F6
      F6FFF5F5F5FFF5F5F5FFF5F5F5FFE8DED7FF007800FF76C876FF58BC57FF53B9
      53FF50B750FF4AFCFBFF45F6EFFF40D49EFF3BD197FF35F3E7FF2EF7F7FF2B2B
      F5FF2323F5FF1B1BF3FF3C3CF5FF0000E9FFD4573BFFEEB7ACFF7975F5FF6163
      FCFFDEDEFDFF8587FCFF5A5AFAFFE19A90FFE29889FFE19384FFE19384FFDD8A
      79FFDD8A79FFDD8A79FFE29889FFA50000FF3AD43AFFA7EDA7FF93E993FF93E9
      93FF8EE88EFF8AE68AFF8AE68AFF85E485FF81E281FF7AE27AFF7AE27AFF72DD
      73FF72DD73FF6BDD6BFF81DF82FF00B300FFFFF7F1FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFFAFAFAFF6ECEE9FF6ECEE9FFF9F9F9FFF9F9F9FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFE8DED7FF008100FF79C979FF5BBD5BFF58BC
      57FF53B953FF51FBFBFF4AFCFBFF46FBFBFF40FAF9FF3AF9F9FF35F7F8FF3030
      F4FF2B2BF5FF2323F5FF4848F7FF0000E9FFF5F5FDFFFFFFFFFFA29EF6FF9590
      F6FF9590F6FF908BF4FF908BF4FFFDFDFDFFFAFAFAFFFAFAFAFFFAFAFAFFF7F7
      F7FFF7F7F7FFF7F7F7FFF7F7F7FFDFDDE7FF00C300FF82E682FF67E166FF67E1
      66FF61DD62FF5DDE5DFF5BDB5BFF55D955FF52D752FF4AD74AFF4AD74AFF41D4
      41FF3AD43AFF3AD43AFF52D752FF009D00FFFFF7F1FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFFDFDFDFFF8FBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF9F9
      F9FFF7F7F7FFF6F6F6FFF7F7F7FFE8DED7FF008100FF79C979FF60BF5FFF5BBD
      5BFF58BC57FF51FBFBFF51FBFBFF4AFCFBFF46FBFBFF40FAF9FF3AF9F9FF3636
      F6FF3030F4FF2B2BF5FF4848F7FF0000E9FFF5F5FDFFFFFFFFFFFFFFFFFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFAFAFAFFFAFA
      FAFFFAFAFAFFF7F7F7FFF7F7F7FFE4E3EDFF00C300FF82E682FF82E682FF82E6
      82FF82E682FF7AE27AFF7AE27AFF73E273FF73E273FF6BDD6BFF6BDD6BFF61DD
      62FF61DD62FF5BDB5BFF55D955FF009D00FFFFF7F1FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFCFCFCFFFAFA
      FAFFF9F9F9FFF9F9F9FFF7F7F7FFEEE6DEFF008100FF79C979FF79C979FF79C9
      79FF76C876FF72FDFDFF72FDFDFF6CFDFDFF68F4FCFF64F2FCFF5FFAFBFF5656
      F9FF5656F9FF5656F9FF4848F7FF0000E9FFF5F5FDFFF5F5FDFFF5F5FDFFF5F5
      FDFFF5F5FDFFF3F2FCFFF3F2FCFFF3F2FCFFF0EFF8FFF0EFF8FFEEECF5FFEEEC
      F5FFEAE8F2FFEAE8F2FFE4E3EDFFE4E3EDFF00C300FF00C300FF00C300FF00C3
      00FF00C300FF00C100FF00BC00FF00BC00FF00BC00FF00B300FF00B300FF00B3
      00FF00B300FF00A700FF00A700FF00A700FFFFF9F1FFFFF7F1FFFFF7F1FFFFF7
      F1FFFDF7F1FFFDF5EFFFFDF5EFFFFDF5EFFFFAF1ECFFFAF1ECFFFAF1ECFFF3EB
      E5FFF3EBE5FFF3EBE5FFEEE6DEFFEEE6DEFF008100FF008100FF008100FF0081
      00FF008100FF00E0FCFF00E0FCFF00E0FCFF00E0FCFF00DAF9FF00DAF9FF0202
      F3FF0202F3FF0202F3FF0000E9FF0000E9FF621800FF5C1200FF550800FF5508
      00FF00A1EDFF009BECFF009BECFF420000FF310000FF310000FF310000FF2000
      00FF200000FF200000FF200000FF200000FFEBEBF5FFE9E9F3FFE7E7F1FFE3E4
      EEFFE3E4EEFFDDDDF0FFDADAE6FFDADAE6FFDADAE6FFD6D6E2FFD6D6E2FFD3D3
      E1FFD2D2DDFFCFCFDDFFCFCFDBFFCFCFDBFF760000FF650000FF650000FF6500
      00FF650000FF4A0000FF4A0000FF4A0000FF4A0000FF4A0000FF380000FF3800
      00FF320000FF320000FF320000FF380000FF0000F4FF0000F4FF0000F4FF0000
      EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000E1FF0000E1FF0000
      E1FF0000E1FF0000DDFF0000DDFF0000DDFF6B2300FFBE9F5FFFBD9D5BFFB999
      57FF54D9F9FF4FD8F8FF4AD6F7FFB28E45FFB08B42FFAB8538FFAB8538FFA982
      32FFA8802FFFA47B2BFFA47B2BFF200000FFEEEEF6FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF2F2F2FFCFCFDBFF760000FFC27C69FFBE7562FFBB70
      5EFFBA6D59FFB76854FFB4634FFFB5604AFFB25C45FFAE5641FFAE5641FFAB51
      3BFFA84E36FFAA4B33FFA74830FF320000FF0000F4FF6363FCFF5A5AFAFF5A5A
      FAFF5251F9FF5251F9FF4545F8FF4545F8FF4545F8FF3A3AF5FF3A3AF5FF3333
      F3FF3333F3FF2C2CF4FF2C2CF4FF0000DDFF6B2300FFC0A265FFB28E45FFAE89
      3CFF3AD4F9FF34D2F8FF2ED0F7FFA47B2BFFA17622FFA0701BFFA0701BFF9D68
      11FF96680CFF96680CFFA47B2BFF200000FFEEEEF6FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCFCFDDFF760000FFC27C69FFB5604AFFB25C
      45FFAE5641FFAB513BFFAA4B33FFA74830FFA4432AFFA13D24FF9F391FFFA135
      1AFF9B2F14FF9B2F14FFA84E36FF320000FF0000F4FF6363FCFF4545F8FF3C3C
      FAFF3A3AF5FF3333F8FF2C2CF4FF2C2CF4FF2020F5FF2020F5FF1515F3FF1515
      F3FF0C0CF1FF0C0CF1FF2C2CF4FF0000E1FF732F00FFC3A56AFFB5924BFFB28E
      45FF3FD6FAFF3AD4F9FF34D2F8FFA8802FFFA47B2BFFA27824FFA0701BFFA26B
      18FF9D6811FF9D6811FFA97C32FF420000FFF1F1FAFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFD2D2DDFF820000FFC58373FFB4634FFFB560
      4AFFB25C45FFAE5641FFAB513BFFAA4B33FFA74830FFA4432AFFB5604AFF3991
      5DFF42915BFFAE5641FFA84E36FF320000FF140085FF946EC8FF7748B8FF7748
      B8FF6F3EB3FF6F3EB3FF6734ADFF6734ADFF6734ADFF5C26A7FF5C26A7FF541C
      A2FF541CA2FF4F159EFF6734ADFF00003EFF00BDFDFF6FE2FDFF4EDAFCFF48D9
      FBFF45D7FBFF3FD6FAFF3AD4F9FF34D2F8FF2ED0F7FF2ACEF6FF22CCF5FF1AC9
      F3FF1AC9F3FF13C7F2FF31CFF6FF008BE5FFF1F1FAFFFCFCFCFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD3D3E1FF820000FFC58373FFB86854FFB560
      4AFFB25C45FFB25C45FFAB513BFFAF4D35FFA84E36FFA74830FF6B7991FF6B79
      91FF39915DFF649164FFAB513BFF380000FFB70000FFD87A73FFD45B50FFD553
      48FFD14E43FFD14E43FFCF483AFFCB4437FFCD3F2EFFC93B2DFFC63426FFC42D
      1EFFC32717FFC32717FFCB4437FF880000FF00BDFDFF74E3FEFF52DCFDFF4EDA
      FCFF4AD9FCFF45D7FBFF3FD6FAFF3AD4F9FF34D2F8FF2ED0F7FF2ACEF6FF22CC
      F5FF22CCF5FF1AC9F3FF3CD1F5FF008BE5FF0000EAFF8888F5FF7171F2FF7171
      F2FF6564F0FF6060F0FF5C5CEEFF5757EDFF5252EDFF4E4EEBFF4949EAFF4444
      E8FF4040E6FF3D3DE6FF5757E8FF0000C5FF2E04A1FFE2C1B9FFCB9B89FF836A
      C5FF8263B9FFC27C69FFD4A69AFF8263B9FFAB513BFFAF4D35FF60839EFFCB9B
      89FFE5D0CDFFCB9B89FFAE5641FF380000FFB70000FFD87A73FFA35896FF9D63
      AAFF9A5EA6FFD14E43FFCD4B3FFFCF483AFFCB4437FFC93B2DFFC63426FFC634
      26FFC42D1EFFC32717FFCB4437FF880000FF00C1FDFF74E3FEFF58DDFEFF53DC
      FDFF50DBFDFF4AD9FCFF45D7FBFF3FD6FAFF3AD4F9FF34D2F8FF2ED0F7FF2ACE
      F6FF22CCF5FF22CCF5FF3CD1F5FF008BE5FF0000E3FFB4B4F8FFEEEEFCFFA4A4
      F6FF5958F0FF5252EDFF4646EDFF4040EBFF3B3BEAFF3536E9FF3030E8FF2A2A
      E7FF2323E5FF2323E5FF3D3DE6FF0000C5FFB4634FFFA8A4F6FFDFBCB2FF7C77
      EEFF8274E0FFDEB9ADFF8C86EBFFBD8A8FFFB3553DFFAF4D35FF54ABC1FF40B4
      D3FF38AFCFFF38AFCFFFAE5641FF4A0000FFB70000FFD87A73FFB7B1F4FFF6EE
      F1FFB7B1F4FFCE534CFFD14E43FFCD4B3FFFCF483AFFCB4437FFC93B2DFFC634
      26FFC63426FFC42D1EFFCD4B3FFF880000FF7E4000FFC9AE78FFBD9D5BFFC396
      57FF53DCFDFF50DBFDFF4AD9FCFFAE934FFFB08B42FFAE893CFFAB8538FFA880
      2FFFA47B2BFFA27824FFB08B42FF420000FF0000E7FFF2F2FDFFDDDDF0FF5958
      F0FF7171F2FFCBCBF9FFCBCBF9FF4646EDFF4040EBFF3B3BEAFF3536E9FF3030
      E8FF2A2AE7FF2323E5FF4444E8FF0000CCFF1902C5FFA8A4F6FF8485FEFF6566
      FDFF6F71FDFF8485FEFF7C77EEFF836AC5FFB25C45FFB3553DFF54ABC1FF40B4
      D3FF3FB1CFFF49A2BAFFB25C45FF4A0000FFC31002FFE3928DFFE3928DFFF4E0
      E0FFDE837BFFDA746CFFDA746CFFDA746CFFD66B64FFD66B64FFD3625AFFD362
      5AFFD45B50FFCE534CFFD66B64FF880000FF814200FFCAB07AFFBE9F5FFFBD9D
      5BFF58DDFEFF53DCFDFF50DBFDFFB5924BFFB28E45FFB08B42FFAE893CFFAB85
      38FFA8802FFFA47B2BFFB28E45FF420000FF0000E7FFF6F6FEFFBCBCF9FF7171
      F2FFBCBCF9FF5958F0FF7777F2FF8888F5FF4646EDFF4141ECFF3B3BEAFF3536
      E9FF3030E8FF2A2AE7FF4949EAFF0000CCFF0B06F0FF8485FEFF6F71FDFF6566
      FDFF6566FDFF6F71FDFF6566FDFF6960E8FFB4634FFFB25C45FFAE5641FFAE56
      41FFAB513BFFA74830FFB4634FFF4A0000FFF5F5F5FFFFFFFFFFE3928DFFD87A
      73FFD87A73FFFBFBFDFFFDFDFDFFFDFDFDFFFAFAFAFFFAFAFAFFFAFAFAFFF7F7
      F7FFF7F7F7FFF6F6F6FFF7F7F7FFEAEAEAFF814200FFCAB07AFFCAB07AFFC9AE
      78FF74E3FEFF74E3FEFF6FE2FDFFC3A56AFFC3A56AFFC0A265FFBE9F5FFFBB9B
      5BFFB99957FFB79652FFB5924BFF420000FF0000E7FFCBCBF9FFF6F6FEFFB4B4
      F8FF8888F5FFB4B4F8FFA4A4F6FF6A6AF2FF6A6AF2FF6564F0FF6060F0FF5C5C
      EEFF5757EDFF5252EDFF4E4EEBFF0000CCFFAE5641FFA8A4F6FFE5D0CDFF9A97
      F4FF9A97F4FFE5D0CDFFB3AEF2FFD9ADA0FFC27C69FFC27C69FFBE7562FFBB70
      5EFFBA6D59FFBA6D59FFB76854FF4A0000FFF5F5F5FFFFFFFFFFFFFFFFFFFCF7
      F6FFFCF7F6FFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFAFAFAFFFAFA
      FAFFFAFAFAFFF7F7F7FFF7F7F7FFEAEAEAFF814200FF814200FF814200FF8142
      00FF00C1FDFF00BDFDFF00BDFDFF732F00FF732F00FF6B2300FF6B2300FF6218
      00FF5C1200FF550800FF550800FF420000FF0000EAFF0000E7FF0808EBFF0000
      EAFF0000E7FF0000E3FF0000E3FF0000E3FF0000E3FF0000DCFF0000DCFF0000
      DCFF0000DCFF0000D4FF0000D4FF0000D4FF382CE5FFC58373FFAA4B33FF0B06
      F0FF1902C5FFAA4B33FFB5767CFF3216C1FF820000FF760000FF760000FF7600
      00FF650000FF650000FF650000FF650000FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2F2FFEEEEEEFFEEEEEEFFEEEEEEFFEAEA
      EAFFEAEAEAFFE5E5E4FFE5E5E4FFE5E5E4FF0097C5FF0099AFFF145755FF0008
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0C5184FF0C5184FF24952AFF0690
      06FF005B00FF005B00FF003200FF003200FF003200FF003200FF003200FF0032
      00FF003200FF003200FF003200FF003200FFE1E1E1FFE1E1E1FFC38324FF8800
      00FF8F0900FF9D2000FF981300FF8F0900FF8F0900FF880000FF880000FF6C00
      00FF6C0000FFA55400FFD4D4D3FFD4D4D3FF003C00FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF145755FF8AAFC6FF62D2E3FF67C5
      BEFF529351FF529351FF498E49FF428B42FF428B42FF3A853AFF3A853AFF3381
      33FF338133FF2B7A2BFF2B7A2BFF000000FF2E0004FF66B2FBFF857CFAFFB5B5
      F6FFDFE7EBFFD2E8CFFFA7D7A5FF83C883FF65BB65FF41AE41FF38A638FF38A6
      38FF2EA32EFF2EA32EFF2EA32EFF003200FFD49E52FFFBFBFBFFFAFAFAFFFBFA
      F5FFD49E52FFCA8251FFD2954CFFD09745FFCD9444FFC98D39FFBF7235FFC98D
      39FFF3F1EAFFF2F2F2FFF2F2F2FFAD6000FF007204FF6EAC6DFF5C605CFF5353
      53FF535353FF535353FF484848FF484848FF404340FF3A3A3AFF3A3A3AFF3333
      33FF333333FF2A2A2AFF2A2A2AFF000000FFBB0000FFB5A2AEFF88A8BFFF4ACB
      E6FF46C3CAFF3F9C6FFF2B7A2BFF2B7A2BFF217521FF1B711BFF1B711BFF136C
      13FF0D680DFF0D680DFF2B7A2BFF000000FF780000FF7BDBD6FF4499FBFF3F3F
      FAFF5453F8FF9693F8FFEDE6F7FFF4F4F4FFF3F5ECFFD2E8CFFFA7D7A5FF65BB
      65FF41AE41FF069006FF2EA32EFF003200FF981300FFE1B578FFFAFAFAFFFAFA
      FAFFF9F9F9FFE3C190FFBC6627FFC47729FFC1731CFFB45817FFD9B680FFF2F2
      F2FFF2F2F2FFF2F2F2FFCD9444FF6C0000FF007204FF65C265FF53A053FF4043
      40FF3A3A3AFF333333FF2A2A2AFF2A2A2AFF2A2A2AFF131313FF131313FF1313
      13FF131313FF131313FF2A2A2AFF000000FFBB0000FFE06B6BFFDD4948FF9998
      AAFF6BB8D5FF39C8D3FF44B3A6FF2B7A2BFF2B7A2BFF247624FF1B711BFF1B71
      1BFF136C13FF0D680DFF338133FF000000FF870000FFA89997FF4AFAFCFF4499
      FBFF3F3FFAFF3939F8FF4848F8FF9693F8FFD7D6F6FFF4F4F4FFF4F4F4FFF4F4
      F4FFEEF0EEFFD2E8CFFFB3D9B3FF069006FFB34800FFD69E69FFC98246FFEEDC
      C5FFFAFAFAFFF9F9F9FFF7F4ECFFC2732CFFC2732CFFF3F1EAFFF5F5F5FFF2F2
      F2FFE4CDAFFFB45817FFC2732CFF880000FF007204FF6CC46CFF49B549FF53A0
      53FFEAEAEAFFEAEAEAFFEAEAEAFFE6E6E6FFE6E6E6FFE6E6E6FFE2E2E2FFE2E2
      E2FFE2E2E2FFE0E0E0FFE2E2E2FFBDBDBDFFBB0000FFE06B6BFFDB5151FFDD49
      48FFBA6E77FF88A8BFFF4ACBE6FF46C3CAFF358F54FF2B7A2BFF247624FF1B71
      1BFF1B711BFF136C13FF338133FF000000FF870000FFC46F6FFF67D9D8FF4AFA
      FCFF4499FBFF3F3FFAFF3B3AF9FF3535F8FF3939F8FF7474F6FFC2C2F5FFF4F4
      F4FFF4F4F4FFF2F1F3FFF4F4F4FFE4E4E4FFBA5700FFDDAF6EFFD2954CFFC77B
      43FFDEB073FFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF5F5F5FFF5F5F5FFD49E
      52FFB45817FFC1731CFFC98D39FF880000FF008900FF6CC46CFF4EB74EFF49B5
      49FF64B164FFDEF2DEFFF9F9F9FFF8F8F8FFF8F8F8FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFCDCDCDFFC80000FFF0B5B5FFDB5151FFEA9E
      9EFFDB5151FFDF4646FFA37E8FFF5EC4E4FF3FCAD8FF44B3A6FF2B7A2BFF2476
      24FF1B711BFF1B711BFF3A853AFF000000FF870000FFC97373FF988E8FFF51FD
      FDFF4AFAFCFF468BFBFF3F3FFAFF3B3AF9FF3535F8FF2F2FF7FF2F2FF7FF5F5F
      F9FFB5B5F6FFF2F1F3FFF4F4F4FFE4E4E4FFBA5700FFDEB073FFD8A152FFD49E
      52FFC06A4AFFCF8D46FFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFC47729FFB04B
      24FFC6801EFFC47C1BFFC98D39FF880000FF008900FF72C671FF54BB54FF4EB7
      4EFF49B549FF5BA95BFFF9F9F9FFF9F9F9FFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFCDCDCDFFDB3E3FFFFCF8F8FFDC5A59FFFCF8
      F8FFEBA4A4FFD84A4AFFDF4646FFD64445FF829DB7FF4ACBE6FF42BEBFFF2B7A
      2BFF247624FF217521FF428B42FF000000FF870000FFC97373FFBC5E5EFF67D9
      D8FF51FDFDFF4AFAFCFF468BFBFF3F3FFAFF3B3AF9FF3535F8FF2F2FF7FF2828
      F6FF2828F6FF5453F8FFB5B5F6FFCFCFE7FFBA5700FFE1B578FFD69E59FFCA82
      51FFE2BC83FFFBFBFBFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFD9AA
      66FFBC6627FFC1731CFFCD933EFF880000FF008900FF77C977FF54BB54FF54BB
      54FF64B164FFE4F4E0FFFBFBFBFFFBFBFBFFF9F9F9FFF8F8F8FFF8F8F8FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFCDCDCDFFC80000FFE78B8BFFF8E3E3FFE272
      71FFE06B6BFFDB5151FFD84A4AFFD64445FFDB3E3FFFA37E8FFF5EC4E4FF4ACB
      E6FF3EAD9FFF247624FF428B42FF000000FF870000FFCA7979FFC15D5DFF988E
      8FFF51FDFDFF51FDFDFF4AFAFCFF468BFBFF3F3FFAFF3B3AF9FF3535F8FF2F2F
      F7FF2828F6FF2828F6FF4343F6FF0000EFFFBA5700FFDBA578FFD2925BFFF5EC
      DEFFFBFBFBFFFEFEFEFFF7F4ECFFC98246FFC77B43FFF3F1EAFFF8F8F8FFF7F7
      F7FFEEDCC5FFBC6627FFC98246FF8F0900FF008900FF77C977FF5BC25BFF6AAF
      6FFFEDEEFBFFEEEEFDFFEDEEFBFFEDEEFBFFE9E9F8FFE9E9F8FFE9E9F8FFE9E9
      F8FFE6E6F6FFE6E6F6FFE9E9F8FFC7C7E7FFC80000FFEA9E9EFFF5D2D2FFE272
      71FFDC5A59FFDB5151FFDB5151FFD84A4AFFD64445FFDB3E3FFFD64445FF77A1
      BCFF3ECCE8FF46C3CAFF498E49FF000000FF870000FFCA7979FFC15D5DFFBC5E
      5EFF69E0E0FF51FDFDFF51FDFDFF4AFAFCFF468BFBFF3F3FFAFF3B3AF9FF3535
      F8FF2F2FF7FF2828F6FF4848F8FF0000EFFFAA2E00FFE3C190FFFEFEFEFFFEFE
      FEFFFEFEFEFFE8C99DFFCA8251FFD2954CFFCF8D46FFC77B43FFE3C190FFF8F8
      F8FFF7F7F7FFF5F5F5FFD9AA66FF6C0000FF008900FF79CF7AFF70B277FF5A5B
      FCFF5A5BFCFF5555FBFF5050FDFF4B4BFCFF4141FAFF4141FAFF4141FAFF3030
      F7FF3030F7FF3030F7FF4B4BF7FF0000ECFFEBA4A4FFFCF8F8FFE78B8BFFFCF8
      F8FFEBA4A4FFE27271FFE27271FFE06B6BFFDE6666FFDE6666FFE05D5EFFDC5A
      59FFA897A6FF6EC9E4FF62D2E3FF145755FF870000FFCA7979FFCA7979FFCA79
      79FFA9A9A9FF70FDFDFF70FDFDFF70FDFDFF68F7FCFF6496FCFF5F5FF9FF5F5F
      F9FF5453F8FF5453F8FF4D4DF7FF0000EFFFE1B578FFFFFFFFFFFFFFFFFFFBFA
      F5FFDEB073FFD79D73FFDDAF6EFFDDAF6EFFD9AA66FFD9AA66FFD08F60FFD69E
      59FFF7F4ECFFF8F8F8FFF7F7F7FFC98D39FF008900FF8ABF90FF797AFDFF797A
      FDFF7373FEFF7373FEFF7373FEFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5A5B
      FCFF5555FBFF5252F8FF4B4BF7FF0000ECFFC80000FFE78B8BFFBB0000FFE57A
      7AFFC80000FFBB0000FFBB0000FFBB0000FFBB0000FFBB0000FFBB0000FFBB00
      00FFBB0000FF9F0000FF005691FF0097C5FF870000FF870000FF870000FF8700
      00FF870000FF00C9C9FF00FCFCFF00FCFCFF00FCFCFF00EDF9FF0000EFFF0000
      EFFF0000EFFF0000EFFF0000EFFF0000EFFFE1E1E1FFE1E1E1FFD99B4AFFAA2E
      00FFB34800FFBA5700FFBA5700FFBA5700FFB34800FFB34800FFB34800FF9D20
      00FF880000FFC47C1BFFE1E1E1FFD4D4D3FF007204FF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000ECFF0000ECFFB80100FFAD0000FFAD0000FFAD00
      00FFAD0000FF00BCE7FF00C1EBFF00BCE7FF00BCE7FF00BCE7FF00A9E3FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000F3FF0000F3FF0000F3FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF006900FF004E00FF004E00FF004E
      00FF004E00FF004E00FF003100FF003100FF003100FF003100FF003100FF001C
      00FF001C00FF001C00FF001C00FF001C00FF002300FF002300FF001200FF0012
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFAD0000FFDE8863FFDD835BFFDE80
      57FFDD7B53FF52F3F3FF4AF5F5FF43F7F7FF43F7F7FF3BF3F3FF38E7F4FF3636
      F6FF3030F4FF3030F4FF2B2BF5FF0000DDFF0000F8FF6363FCFF5A5AFAFF5A5A
      FAFF4F4FF8FF4F4FF8FF4F4FF8FF4343F7FF4343F7FF3A3AF5FF3A3AF5FF3333
      F3FF3333F3FF2C2CF4FF2C2CF4FF0000DDFF006900FF5FBA5EFF5FBA5EFF53B4
      53FF53B453FF53B453FF45AD45FF45AD45FF45AD45FF36A536FF36A536FF36A5
      36FF2D9F2DFF2D9F2DFF2D9F2DFF001C00FF002300FF68A468FF65A265FF5F9E
      60FF5A9B5BFF549755FF4F9450FF4A914BFF468F47FF438B43FF3F8A40FF3D87
      3EFF398539FF348234FF348234FF000000FFB80100FFDE8863FFD76F44FFD769
      3CFFD7693CFF3BF3F3FF2CF7F7FF2CF7F7FF23F5F5FF1DF4F4FF1BE4F4FF1111
      F2FF1111F2FF1111F2FF3030F4FF0000E0FF0000F8FF6363FCFF4343FAFF3C3C
      FAFF3A3AF5FF3333F8FF2C2CF4FF2C2CF4FF2020F5FF2020F5FF1515F3FF1515
      F3FF0C0CF1FF0C0CF1FF2C2CF4FF0000E0FF006900FF65C373FF41B451FF41B4
      51FF36AF47FF36AF47FF29A83BFF29A83BFF29A83BFF1BA22DFF1BA22DFF109D
      24FF109D24FF0A991DFF29A83BFF003100FF003500FF6CA76DFF4A914BFF468F
      47FF3F8A40FF3B883BFF398539FF348234FF2E7D2EFF277A28FF9ABD99FF5A9B
      5BFF166F17FF166F17FF348234FF000000FFB80100FFE08E69FFDA7349FFD76F
      44FFD96B3FFF42F2F2FF34F8F8FF2CF7F7FF2CF7F7FF23F5F5FF1BE4F4FF1B1B
      F3FF1111F2FF1111F2FF3030F4FF0000E0FF0000B3FF8C69DCFF6F46D2FF6F46
      D2FF673CCFFF673CCFFF5E31CAFF5E31CAFF5526C7FF5526C7FF4C1BC3FF4C1B
      C3FF4411BEFF4411BEFF5E31CAFF00007AFF00FBF9FF70FCFBFF4AFCFBFF41FB
      FBFF41FBFBFF39F9F9FF34F8F8FF2CF7F7FF2CF7F7FF23F5F5FF1BF4F4FF1BF4
      F4FF12F2F2FF12F2F2FF33F4F4FF00DEDAFF003500FF70AA71FF509551FF4A91
      4BFFACCCADFFB7D0B7FFB6CEB6FFB3CDB3FFB2CBB1FFAECAAEFFBDD2BCFFB6CE
      B6FF207521FF166F17FF398539FF000000FFBE0F00FFE0916EFFDC774EFFDA73
      49FFDB7044FF42F2F2FF3AF9F9FF34F8F8FF2CF7F7FF2CF7F7FF27E7F6FF1B1B
      F3FF1B1BF3FF1111F2FF3636F6FF0000E0FFFD0000FFFD6E6EFFFC4E4EFFFD49
      49FFFB4545FFFA3F3FFFF83A3AFFF73535FFF72F2FFFF62A29FFF52121FFF521
      21FFF31717FFF31717FFF73535FFE60000FF00FBF9FF70FCFBFF4AFCFBFF4AFC
      FBFF41FBFBFF41FBFBFF39F9F9FF34F8F8FF2CF7F7FF2CF7F7FF23F5F5FF1BF4
      F4FF1BF4F4FF12F2F2FF33F4F4FF00E3E3FF004200FF74AC75FF559A56FF5297
      53FF529753FF4F9450FF4A914BFF438B43FF3E883FFF398539FF398539FF2478
      24FF207521FF1E731FFF3D873EFF000000FFBE0F00FFE39673FFDD7B53FFDC77
      4EFFDA7349FF4AF5F5FF40FAFAFF3AF9F9FF34F8F8FF2CF7F7FF27E7F6FF2323
      F5FF1B1BF3FF1B1BF3FF3C3CF5FF0000E9FFFD0000FFFE7373FFFD5454FFFC4E
      4EFFFD4949FFFB4545FFFA3F3FFFF83A3AFFF73535FFF72F2FFFF62A29FFF521
      21FFF52121FFF31717FFF83A3AFFE60000FF00FBF9FF70FCFBFF56FAF6FF56FA
      F6FF4DF8F4FF4DF8F4FF47F7F3FF42F6F2FF3BF5F2FF3BF5F2FF32F3EFFF27F1
      EDFF27F1EDFF27F1EDFF42F2EDFF00DEDAFF004200FF77AE77FF559A56FFA9C8
      A8FFCFDFCEFFA4C3A2FF8CB48AFF8CB48AFF9ABD99FF619A5FFF72A36FFF81AD
      80FF438B43FF1E731FFF438B43FF000000FFC31C00FFE39673FFDE8057FFDD7B
      53FFDC774EFF52F3F3FF46FBFBFF40FAFAFF3AF9F9FF34F8F8FF2FE9F7FF2B2B
      F5FF2323F5FF1B1BF3FF3C3CF5FF0000E9FFFD0000FFFE7373FFFD5454FFFD54
      54FFFD4E4FFFFD4949FFFB4545FFFA3F3FFFF83A3AFFF73535FFF72F2FFFF62A
      29FFF52121FFF52121FFF53E3EFFE60000FFFD8102FFFEC993FFFDBA74FFFDBA
      74FFFDB66FFFFBB36AFFFBB36AFFFAB066FFF9AB5CFFF9AB5CFFF5A451FFF5A4
      51FFF29F4CFFF29F4CFFF7AD61FFE73400FF004200FF7AB07AFF5A9B5BFF95BD
      94FFAECAAEFFB8D0B6FF98BB96FFB5CCB3FF93B791FF8CB48AFF65A265FFA4C3
      A2FF8CB48AFF247824FF458D46FF000000FFC31C00FFE49A79FFDD835BFFDE80
      57FFDD7B53FF57F6F6FF4BFCFCFF46FBFBFF40FAFAFF3AF9F9FF35EAF8FF3030
      F4FF2B2BF5FF2323F5FF4848F7FF0000E9FFFD4949FFFEB1B1FFFE9C9CFFFE9C
      9CFFFE9C9CFFFC9595FFFC9595FFFC9595FFF88D8DFFF88D8DFFF88D8DFFF783
      83FFF78383FFF57C7CFFF88D8DFFE60000FFFF8306FFFEC993FFFEBD7BFFFEBD
      7BFFFDBA74FFFDB66FFFFDB66FFFFBB36AFFFAB066FFF7AD61FFF9AB5CFFE1AD
      6AFF55C6D5FF55C6D5FFCCB78AFFE94600FF004A00FF7EB37EFF5DA05EFF9AC1
      99FFBDD2BCFFB1CCAFFF7AAA78FFACC9AAFFB2CBB1FFB5CCB3FF7AAA78FFB8CE
      B6FF8CB48AFF277A28FF4A914BFF000000FFC31C00FFE49A79FFDD835BFFDD83
      5BFFDE8057FF57F6F6FF50FDFDFF4BFCFCFF46FBFBFF40FAFAFF3CECF9FF3636
      F6FF3030F4FF2B2BF5FF4848F7FF0000E9FFFFF5F5FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFAFAFAFFFAFAFAFFF7F7
      F7FFF7F7F7FFF6F6F6FFF7F7F7FFEADEDEFFFF8306FFFEC993FFFEBD7BFFFEBD
      7BFFFEBD7BFFFDBA74FFFDB66FFFFDB66FFFFBB36AFFFAB066FFF9AB5CFF79C8
      CAFF47C8E1FF47C8E1FF79C8CAFFE94600FF004A00FF80B380FF65A265FF65A2
      65FF65A265FF65A265FF5A9B5BFF549755FF5A9B5BFF549755FF4A914BFF4A91
      4BFF3F8A40FF348234FF4F9450FF000000FFC31C00FFE49A79FFE49A79FFE49A
      79FFE79876FF77F8F8FF6CFDFDFF6CFDFDFF64FCFCFF64FCFCFF5FF0FBFF5656
      F9FF5656F9FF5656F9FF4848F7FF0000E9FFFFF5F5FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFAFA
      FAFFFAFAFAFFF7F7F7FFF7F7F7FFEADEDEFFFF8306FFFEC993FFFEC993FFFEC9
      93FFFEC993FFFEC58DFFFEC58DFFFEC58DFFFCC186FFFCC186FFFEBD7BFFF7BC
      7DFF84D0D4FF84D0D4FFEDB679FFE94600FF004A00FF80B380FF80B380FF7EB3
      7EFF7AB07AFF77AE77FF74AC75FF70AA71FF6CA76DFF68A468FF65A265FF5F9E
      60FF5A9B5BFF5A9B5BFF549755FF000000FFC72100FFC31C00FFC31C00FFC31C
      00FFC31C00FF00DDEFFF00E1F6FF00E1F6FF00E1F6FF00DDEFFF00D9F5FF0202
      F3FF0202F3FF0202F3FF0000E9FF0000E9FFFFF5F5FFFFF5F5FFFFF5F5FFFFF5
      F5FFFFF5F5FFFDF2F2FFFDF2F2FFFDF2F2FFFAEFEFFFFAEFEFFFF6ECECFFF6EC
      ECFFF2E8E8FFF2E8E8FFEFE4E3FFEFE4E3FFFF8306FFFF8306FFFF8306FFFF83
      06FFFD8102FFFD8102FFFC7700FFFC7700FFFC7700FFFC7700FFF56500FFF565
      00FFF56500FFF05700FFF05700FFF05700FF004A00FF004A00FF004A00FF004A
      00FF004A00FF004200FF004200FF003500FF003500FF003500FF002300FF0023
      00FF002300FF001200FF001200FF000000FF003500FF001300FF001300FF0013
      00FF001300FF001300FF0000EBFF0000EBFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFFF77500FFF16400FFF16400FFEE5B
      00FFEE5B00FFEB4D00FFEB4D00FFE74200FFE74200FFE74200FFE23800FFE238
      00FFDE2D00FFDE2D00FFDE2D00FFE23800FFCB0400FFCB0400FFCB0400FFCB04
      00FFB80000FFB80000FFB80000FFB80000FFB80000FFA70000FFB80000FFA700
      00FFA70000FFA70000FFA70000FFA70000FFECEEF0FFE9E9EBFFE7E7E9FFE5E5
      E7FFE1E3E3FF000016FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF003500FF609F5FFF599B59FF599B
      59FF519551FF519551FF4A4AF7FF4343F6FF4343F6FF3B3BF5FF3536F7FF3536
      F7FF3131F5FF2B2CF4FF2B2CF4FF0000DDFFF66F00FFFBBE60FFFABC5CFFF9BA
      57FFF8B651FFFAB54CFFF7B34AFFF6B045FFF8AD40FFF5AA3AFFF5AA3AFFF5A9
      33FFF3A632FFF4A42CFFF4A42CFFDE2D00FFCB0400FFEB9983FFE9957CFFE78C
      72FFE78C72FFE78C72FFE48367FFE48367FFE37C60FFE37C60FFDF7559FFDF75
      59FFDE7053FFDE7053FFDD6C4DFFA70000FFECEEF0FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FF4E5485FF495083FF454C7EFF41477CFF3E4479FF3A40
      76FF363D75FF343A71FF303770FF000000FF003500FF69A569FF438E43FF3C87
      3CFF3C873CFF339140FF2B2CF4FF2834F3FF2323F5FF1B1BF4FF1B1BF4FF1212
      F2FF0C0CF1FF0C0CF1FF2B2CF4FF0000E0FFFB7A00FFFCC066FFFBB144FFF9AD
      3CFFF8AA37FFB2C67AFF60E2C4FF5AE1C4FFA2C276FFF49E1EFFF39B17FFF299
      13FFF2970FFFF1950AFFF4A42CFFDE2D00FFCB0400FFEB9983FFE48367FFE37C
      60FFE37C60FFDF7559FFDE7053FFDD6C4DFFDD6C4DFFDB6343FFDB6343FFD75A
      38FFD75A38FFD75A38FFDE7053FFA70000FFF0F0F2FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FF606593FF333A73FF2E356FFF28306BFF242B67FF1E2563FF1A21
      60FF131B5CFF131B5CFF343A71FF000000FF003500FF69A569FF489148FF4491
      52FF42BAB6FF3BC2D9FF34A9E8FF34A9E8FF2968EAFF2323F5FF1B1BF4FF1B1B
      F4FF1212F2FF1212F2FF3131F5FF0000E0FFFB7A00FFFDC36BFFF7B34AFFFBB1
      44FF8ED59EFF13FBFDFF03FCFFFF13FBFDFF25F7F4FFA2C276FFF49E1EFFF39C
      18FFF29913FFF2970FFFF3A632FFDE2D00FFF7F0EFFFFCF7F7FFFAF5F4FFFAF4
      F3FFF9F3F1FFF9F3F1FFF7F0EFFFF7F0EFFFF7F0EFFFF4EEECFFF2ECEBFFF2EC
      EBFFF0EAE9FFF0E9E7FFF2ECEBFFE0D4D0FFF0F0F2FFFCFCFCFFFBFBFBFFFBFB
      FBFFF9F9F9FFF9F9F9FF394077FF343B73FF2E356FFF28306BFF242B67FF1F26
      63FF1A2160FF131B5CFF363E74FF000000FF003500FF69A569FF519551FF50B4
      9BFF42BAB6FF5B77E7FF7583EAFF34C9E1FF34C9E1FF2B2CF4FF2323F5FF1B1B
      F4FF1B1BF4FF1212F2FF3536F7FF0000E5FFFD8200FFFEC570FFFAB54CFFFAB5
      4CFF25F7F4FF00FCFFFF00FCFFFF00FCFFFF13FBFDFF44EBDBFFEEA42AFFF49E
      1EFFF39C18FFF29913FFF5A933FFE23800FFF9EFEDFFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFD9D9F7FF7880EAFF7278EAFFD1D4F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE0D4D0FFF0F0F2FFFDFDFDFFFCFCFCFFFBFC
      FBFFFAFAFAFF696E99FF3F467CFF394077FF343B73FF2E356FFF2A316CFF242B
      67FF1F2663FF1A2160FF3B4178FF000000FF004C00FF73AC73FF519551FF4EC8
      CEFF4D7BEDFFDDDDEEFFFAE8D6FF5B77E7FF35BAEEFF2F40F0FF2B2CF4FF2323
      F5FF1B1BF4FF1B1BF4FF3B3BF5FF0000E5FFFD8200FFFEC570FFFDB852FFF2BB
      58FF03FCFFFF00FCFFFF00FCFFFF00FCFFFF03FCFFFF34F8F6FFE5AC3BFFF5A1
      24FFF49E1EFFF39C18FFF5AA3AFFE23800FFFBF2EFFFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFFD0D2F9FF79BD9AFFCA816FFFC8CCF6FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE0D4D0FFF3F3F5FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFF444B80FF3F467CFF3B4178FF343B73FF30366FFF2A31
      6CFF242B67FF1F2663FF3F457AFF000000FF004C00FF73AC73FF599B59FF53C8
      C9FF4D7BEDFFD4DBF5FFD4D0E6FF5572EEFF3CB8F0FF353BF5FF3131F5FF2B2C
      F4FF2323F5FF1B1BF4FF3B3BF5FF0000E5FFFF8900FFFEC876FFFEBA57FFF9BA
      57FF25F7F4FF00FCFFFF00FCFFFF00FCFFFF13FBFDFF52EDDDFFF5A933FFF4A4
      2CFFF5A124FFF49E1EFFF8AD40FFE74200FFFBF2EFFFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFDBDDFAFF8A90F2FF8A90F2FFD9D9F7FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE0D4D0FFF5F5F7FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFF7377A1FF4A5185FF444B80FF3F467CFF3B4178FF353C74FF3037
      70FF2A316CFF242B67FF444B80FF000000FF004C00FF77AE77FF599B59FF56D0
      E2FF56D0E2FF5572EEFF4B66F4FF46ADF2FF46ADF2FF3C3BF9FF3536F7FF3131
      F5FF2B2CF4FF2323F5FF4343F6FF0000E5FFFF8900FFFFC979FFFEBE5CFFFEBA
      57FF99DAA7FF1BFCFEFF03FCFFFF1BFCFEFF34F8F6FFB8CB85FFF8AA37FFF5A9
      33FFF4A42CFFF5A124FFF6B045FFE74200FFF6F6FDFFFCFCFCFFF9F9FEFFF9F9
      FEFFF9F9FEFFF6F6FDFFF6F6FDFFF5F4FAFFF5F4FAFFF5F4FAFFF3F3F8FFF3F3
      F8FFF0F0F6FFF0F0F6FFF0F0F6FFDDDDE7FFF5F5F7FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFDFDFDFF505689FF4A5185FF464C81FF41477CFF3B4178FF363D
      75FF303770FF2A316CFF495083FF000000FF004C00FF7AB07AFF609F5FFF5BA2
      68FF50B49BFF53C8C9FF50C1F9FF46ADF2FF4652FBFF4141FAFF3C3BF9FF3536
      F7FF3131F5FF2B2CF4FF4A4AF7FF0000EBFFFF8900FFFFC979FFFEBE5CFFFEBE
      5CFFFEBA57FFC7CF8BFF83E9C9FF7EE8CAFFB8CB85FFF8AD40FFF9AD3CFFF8AA
      37FFF5A933FFF4A42CFFF7B34AFFEB4D00FF0000FFFF7979FFFF5B5BFDFF5B5B
      FDFF5B5BFDFF5353FBFF5353FBFF4B4BFCFF4444FBFF4444FBFF3939F9FF3939
      F9FF2E2EF7FF2E2EF7FF4B4BF7FF0000ECFFF5F5F7FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFF7B80A6FF53598BFF505689FF4C5185FF464C81FF41477CFF3B41
      78FF363D75FF303770FF4E5485FF000000FF004C00FF7AB07AFF7AB07AFF77AE
      77FF77AE77FF73AC73FF706FFDFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5656
      F9FF5656F9FF5656F9FF4A4AF7FF0000EBFFFF8900FFFFC979FFFFC979FFFFC9
      79FFFEC876FFFEC570FFFEC570FFFDC36BFFFCC066FFFCC066FFFBBE60FFFABB
      5BFFF9BA57FFF8B651FFFAB54CFFEB4D00FF0000FFFF7979FFFF7979FFFF7979
      FFFF7979FFFF7271FEFF7271FEFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5B5B
      FDFF5353FBFF5353FBFF4B4BF7FF0000ECFFF5F5F9FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFF7377A1FF6F759EFF6C729CFF696E99FF646996FF6065
      93FF595E8EFF595E8EFF53598BFF000000FF004C00FF004C00FF004C00FF004C
      00FF004C00FF004C00FF0000FCFF0000FCFF0000FCFF0000FCFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000EBFF0000EBFFFF9300FFFF8900FFFF8900FFFF89
      00FFFF8900FFFD8200FFFD8200FFFB7A00FFFB7A00FFF77500FFF66F00FFF66F
      00FFF16400FFF16400FFEE5B00FFF16400FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000ECFF0000ECFFF5F5F9FFF5F5F7FFF5F5F7FFF5F5
      F7FFF3F5F5FF040C56FF000022FF000022FF000016FF000016FF000008FF0000
      08FF000000FF000000FF000000FF000000FF0000E2FF0000E2FF0000E2FF0000
      99FF440000FF440000FF440000FF440000FF240000FF240000FF240000FF2400
      00FF240000FF240000FF240000FF240000FF640000FF640000FF640000FF4B00
      00FF4B0000FF4B0000FF4B0000FF4B0000FF4B0000FF2D0000FF2D0000FF2D00
      00FF2D0000FF2D0000FF2D0000FF2D0000FFD70000FF000086FF0000B8FF0000
      A6FF0000A6FF00009AFF00009AFF00009AFF00009AFF000086FF000086FF0000
      86FF000086FF000086FF000086FF000086FF000092FF005200FF005F00FF005F
      00FF005200FF005200FF005200FF004600FF004600FF003700FF003700FF0037
      00FF002A00FF002A00FF002A00FF002A00FF0000E2FF66A1DAFF6C83EEFF7064
      D6FFB85856FFB85856FFA75756FFA75756FFA44F4EFFA44F4EFF9F4A4AFFA043
      42FFA04342FF9C3C3AFF9C3C3AFF240000FF640000FFBD7A66FFBD7A66FFB973
      5EFFB9735EFFB76D56FFB76D56FFB3654CFFB3654CFFA8624BFFAD5B42FFA359
      40FFA35940FFA35940FFA75238FF2D0000FFFB0000FFF6636AFFA55DA4FF5D5C
      D9FF565CDFFF5352D8FF4B4BD5FF4B4BD5FF4242D3FF4242D3FF3B3BCFFF3837
      CEFF3837CEFF3131CDFF3131CDFF000086FF0000FBFF616BE8FF5C9B94FF61BE
      61FF5BBA5BFF5BBA5BFF52B552FF52B552FF47B147FF47B147FF40AD41FF40AD
      41FF3AAA3AFF37A737FF37A737FF002A00FF0000E2FF66A1DAFF4382E0FF5B4C
      D1FFB4413FFFAC3635FF67737EFF37B1C6FF30A3B8FF30A3B8FF30A3B8FF30A3
      B8FF1CA9C2FF576771FFAC3635FF240000FF780000FFC68571FFB3654CFFB365
      4CFFAD5B42FFAD5B42FFA75238FFA75238FFA34B30FFA5472BFF708B7BFF784C
      31FF22B9ACFF784C31FF708B7BFF2D0000FFFB0000FFF6636AFFFB4547FFE050
      67FFECDDE9FFF7F7F8FFF7F7F8FFF5F5F6FFF2F2F3FFF2F2F3FFEDEDF1FFEDED
      F1FFEDEDF1FFEDEDF1FFEDEDF1FFBFBFD9FF0000FBFF6767FCFF4343FBFF3E68
      B5FF47B147FF40AD41FF3AAA3AFF34A934FF2FA62FFF27A227FF27A227FF209F
      20FF1A9B19FF1A9B19FF3AAA3AFF002A00FF0000E2FF6C83EEFF6068F1FF6355
      D2FFB4413FFFA44F4EFF38C7DBFF32CDE3FF37BDD1FF37B1C6FF3BADBEFF27B7
      CBFF22ACC3FF685A60FFAC3635FF240000FF780000FFC68571FFB76D56FFB365
      4CFFB3654CFFAD5B42FFAD5B42FFA75238FFA75238FFA5472BFF4FBAB4FF5475
      4BFF54754BFF54754BFF4FBAB4FF2D0000FFFB0000FFFD686DFFFB4A4AFFFB45
      47FFFB4A4AFFFBDCDCFFF8F7F5FFF7F7F8FFF6F6F6FFF5F5F6FFF4F4F4FFF2F2
      F3FFF2F2F3FFF2F2F3FFF2F2F3FFC9C9D9FF0000FBFF6767FCFF4949FCFF4343
      FBFF4952DDFF918EF9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFD0D0D0FFD5D3D0FFE2E1E1FFE6E8E8FFE7E1
      DCFFB44C4BFF4FAFBFFF4FAFBFFF44B8CCFF67737EFF598F9BFF726269FF685A
      60FF576771FF1CA9C2FF9F4A4AFF440000FF780000FFC68571FFB76D56FFB365
      4CFFB3654CFFB3654CFFAD5B42FFA75238FFA75238FFA75238FF846546FF5D7D
      56FF8C9A68FF54754BFF98664FFF2D0000FFFB0000FFFC787CFFFDC2C4FFFC78
      7CFFFB4547FFFA4040FFA55DA4FF726AD8FF6767DDFF6161DCFF5D5CD9FF5858
      D7FF5454D4FF5454D4FF6B6BDCFF0000A6FF0000FBFF6E6EFDFF4F4EFDFF4F4E
      FDFF4343FBFF4843FAFF918EF9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD0D0D0FFE2E1E1FFE2E1E1FFE6E8E8FFE7E1
      DCFFB44C4BFF7C8A92FFA75756FF6699A4FF35DBF1FF32CDE3FF4FAFBFFF26CC
      E3FF3BADBEFF67737EFF4FAFBFFF440000FFB95258FFBDB5EAFFE49686FFCF98
      A2FF7E69CCFFE49686FFCA8E9BFF7E69CCFFB97578FFA75238FF985940FF5D7D
      56FF8C9A68FF54754BFFA8624BFF2D0000FFFB0000FFFDC2C4FFFCFBFAFFFBDC
      DCFFFC5053FFFB4547FFFA4040FF833C9CFF3837CEFF3131CDFF2727C8FF2727
      C8FF1C1CC4FF1C1CC4FF3B3BCFFF000086FF0000FBFF6E6EFDFF5C5CFEFF4F4E
      FDFF4949FCFF4343FBFF4343FBFF8988F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFD0D0D0FFD5D3D0FFE7E7E7FFE7EAEEFFE7E1
      DCFFBA504EFFBA504EFF926467FF7C8A92FF3ED2E6FF3ED2E6FF4FAFBFFF2AD8
      EEFF3BADBEFF726269FF4FAFBFFF440000FFE76F4FFFF5D5CEFFE2E2FCFFD7B5
      CAFF9394FBFFECB9B2FFAB9EDBFFEBAA9AFFC68571FFA35940FF846546FF4C72
      65FF4C7265FF5C826DFF9F6D5CFF2D0000FFFB0000FFFE8E90FFFED1D2FFFE8E
      90FFFE5A5BFFFB4A4AFFAA67AAFF6C59CCFF5352D8FF5352D8FF4B4BD5FF4242
      D3FF4242D3FF3B3BCFFF5858D7FF00009AFF0000FBFF6E6EFDFF5C5CFEFF5555
      FDFF4F4EFDFF5555FDFF9F9DFCFFFBFBFBFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD6D6D6FF045F22FFC1C8F8FFB3BBF5FF81A2
      83FFB85856FFBA504EFF53D3E4FF53D3E4FF7C8A92FF3ED2E6FF55B7C7FF9264
      67FF38C7DBFF726269FFA75756FF440000FF7E69CCFFE9E3F4FFD1D2FDFF9394
      FBFF6D69F2FF9FA2FEFFBDB5EAFFB4A2DDFF8462BBFFA8624BFF5DAC76FF7375
      59FF99908BFF5C826DFF74A979FF4B0000FFFF0000FFFC787CFFFD686DFFFE5A
      5BFFFE5F5DFFFBDCDCFFFCFBFAFFFCFBFAFFF9F9F9FFF9F9F9FFF7F7F8FFF7F7
      F8FFF6F6F6FFF5F5F6FFF6F6F6FFCFCFE4FF0000FFFF7979FFFF5C5CFEFF5858
      FEFF4952DDFF9F9DFCFFFBFBFBFFFBFBFBFFFBFBFBFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD6D6D6FF6C83EEFFE7E7E7FFE2E1E1FFB3BB
      F5FFB85856FFB85856FF63C7D6FF53D3E4FFA75756FF55B7C7FF926467FF9F4A
      4AFF4FAFBFFF9C3C3AFFB44C4BFF440000FF6D69F2FFE2E2FCFFD1D2FDFF9FA2
      FEFF9394FBFFA8A6F7FFB6B3F5FFA8A6F7FF8462BBFFB3654CFFAB6A53FF9866
      4FFF99908BFFA75238FFAB6A53FF4B0000FFFF0000FFFC787CFFFE5F5DFFE86A
      7EFFF2E6F0FFF8F9FCFFF8F9FCFFF8F9FCFFF7F7F8FFF5F5F9FFF5F5F9FFF5F5
      F9FFF6F6F6FFF5F5F6FFF2F2F5FFCFCFE4FF0000FFFF7979FFFF5C5CFEFF5B5B
      BCFF585862FF525252FF525252FF4B4B4BFF4B4B4BFF414141FF414141FF3333
      33FF333333FF2B2B2BFF4B4B4BFF000000FF6C83EEFFE7E7E7FFE7E7E7FFC1C8
      F8FFC87775FFC87775FFBE807EFF76D3E0FFB07777FF76D3E0FFB07777FFB077
      77FF71BBC8FFB85856FFBA504EFF440000FFE76F4FFFF5D5CEFFEEEEFFFFE8CF
      D7FFD1D2FDFFE8CFD7FFE9E3F4FFECB9B2FFEBAA9AFFC68571FFBD7A66FFBD7A
      66FFB9735EFFB9735EFFB76D56FF4B0000FFFF0000FFFC787CFFB87AB7FF7C7D
      E6FF7C7DE6FF7576E3FF7170E2FF7170E2FF6B6BDCFF6767DDFF6161DCFF6161
      DCFF5D5CD9FF5454D4FF5352D8FF00009AFF0000FFFF7A7AEBFF777782FF7777
      82FF777782FF706F6FFF706F6FFF6A6A6AFF6A6A6AFF626262FF626262FF5B5B
      5BFF565657FF525252FF4B4B4BFF000000FF045F22FF6C83EEFF6C83EEFF045F
      22FF810000FF810000FF810000FF810000FF810000FF630000FF630000FF6300
      00FF630000FF630000FF630000FF630000FFCB6062FF9394FBFFDF705EFFBF68
      7AFF6D69F2FFDB5C3AFFAB5C7EFF8462BBFFC7381AFF780000FF640000FF6400
      00FF640000FF640000FF4B0000FF4B0000FFD70000FF0000A6FF0000C8FF0000
      C8FF0000C8FF0000B8FF0000B8FF0000B8FF0000B8FF0000B8FF0000B8FF0000
      B8FF0000A6FF0000A6FF0000A6FF0000A6FF000092FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF00006EFF7795F8FF0000EDFF0000EDFF0000
      EDFF0000EDFF0000EDFF0000EDFF0000EDFF0000EDFF0000E1FF0000E1FF0000
      E1FF0000E1FF0000DDFF0000DDFF0000DDFFE5EDE5FFE5EDE5FFE5EDE5FFDBE7
      DBFF005900FF004500FF004500FF003900FF003900FF003900FF002800FF0028
      00FF002800FF002800FF002800FF002800FF0000F4FF0000F4FF0000F4FF0000
      EEFF0000EEFF0000EEFF0000EAFF0000EAFF0000E6FF0000E6FF0000E2FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFF000000FF646464FF5C5C5BFF9090
      90FF646464FF515151FF4A4A4AFF434343FF434343FF353535FF353535FF3535
      35FF2E2E33FF343465FF3030D4FF0000DEFF19EFEFFFCAECF4FF7795F8FF5353
      F9FF5353F9FF5353F9FF4545F7FF4545F7FF4545F7FF3A3AF5FF3A3AF5FF3333
      F3FF3333F3FF2D2DF2FF2D2DF2FF0000DDFFEAF2EAFFFCFCFCFFFAFAFAFFF0F6
      F0FF5EBA5DFF51B251FF4AB04BFF44AD44FF41A741FF3EA93EFF3CA73CFF34A2
      34FF30A231FF2DA12DFF2B9D2BFF002800FF0000F4FF5F5FF8FF5C5CFAFF5857
      F8FF5352F8FF4E4EF7FF4949F6FF4444FAFF4242F5FF3A3AF5FF3A3AF5FF3232
      F3FF3232F3FF2D2DF2FF2D2DF2FF0000DDFF000000FF646464FF434343FFB1B1
      B1FF8C8C8CFF353535FF2E2E33FF272727FF272727FF1B1B1AFF1B1B1AFF1212
      20FF1B1C98FF0101F3FF3131F4FF0000DEFFE8F4F4FFFEFDFDFFFAFBFBFFADAA
      FAFF4545F7FF3333F8FF2E2EF7FF2929F6FF2323F5FF1B1BF4FF1B1BF4FF1111
      F2FF1111F2FF0A0AF1FF2D2DF2FF0000E1FFEAF2EAFFFCFCFCFFFAFAFAFFEFF4
      EEFF44AD44FF34A534FF2DA12DFF2AA12AFF92CC92FFD0E4D0FFDCEADCFF6ABC
      6AFF2B9D2BFF0A900AFF2DA12DFF002800FF0000FCFF6464FBFF4444FAFF3E3E
      FAFF3939F9FF3434F7FF2E2EF7FF2929F6FF2323F5FF1E1EF4FF1818F3FF1313
      F2FF0F0FF2FF0C0CF1FF2D2DF2FF0000DFFF000000FF646464FF4A4A4AFF4343
      43FF434343FF9C9C9BFF353535FF2E2E33FF272727FF272727FF0F0F50FF1818
      CDFF1516F3FF1516F3FF3131F4FF0000DEFFF5F4F4FFF3FDFDFFD4FCFCFFE5FD
      FDFFCBD1FAFF6564F9FF3333F8FF2E2EF7FF2929F6FF2323F5FF1B1BF4FF1B1B
      F4FF1111F2FF1111F2FF3333F3FF0000E1FFEFF4EEFFFCFCFCFFFCFCFCFFF0F6
      F0FF4AB04BFF3AA93AFF34A534FFACD7ACFFEFF4EEFF92CC92FF86C886FFA6D4
      A6FF56AF56FF139513FF30A231FF002800FF0000FCFF6969FCFF4849FBFF4444
      FAFF3E3EFAFF3939F9FF3434F7FF2E2EF7FF2929F6FF2323F5FF1E1EF4FF1818
      F3FF1313F2FF0F0FF2FF3232F3FF0000DFFF000000FF777777FF9C9C9BFF4A4A
      4AFF434343FF777777FF434343FF353535FF353535FF1B1C98FF2729F5FF1516
      F3FF1879F3FF1516F3FF3131F4FF0000E8FFF5F4F4FFD4FCFCFF77FDFDFF8DFC
      FBFFEBFCFCFFF2F2FAFF7795F8FF3333F8FF2E2EF7FF2929F6FF2323F5FF1B1B
      F4FF1B1BF4FF1111F2FF3333F3FF0000E1FFEFF4EEFFFCFCFCFFFCFCFCFFF0F6
      F0FF50B450FF3EA93EFF7AC47BFFF0F6F0FFA6D4A6FF2B9D2BFF229B22FF1C99
      1CFF1C991CFF139513FF34A534FF002800FF0000FCFF6D6DFCFF4E4EFCFF4849
      FBFF4444FAFF3E3EFAFF3939F9FF3434F7FF2E2EF7FF2929F6FF2323F5FF1E1E
      F4FF1818F3FF1313F2FF3434F7FF0000E2FF000000FF777777FFC1C1C1FF5151
      51FF4A4A4AFFB1B1B1FF4A4A45FF343465FF3030D4FF3131F4FF2729F5FF2484
      F5FF1EB6F4FF1941F3FF3C3CF5FF0000E8FFE8F4F4FFB9FEFEFF57FDFDFF57FD
      FDFFC9FCFCFFFAFBFBFF6AFAFAFF968DA6FF853572FF853572FF782164FF7821
      64FF782164FF782164FF853572FF000000FFF0F6F0FFFEFEFEFFFCFCFCFFF2F8
      F2FF54B654FF45AB45FF92CC92FFEAF2EAFF44AD44FF30A231FF2AA12AFF5BB4
      5BFF3CA73CFF1C991CFF3AA93AFF003900FF0000FCFF8E8EFEFF7373FDFF6D6D
      FCFF6D6DFCFF6767FBFF6464FBFF5F5FF8FF5C5CFAFF5857F8FF5352F8FF4E4E
      F7FF4949F6FF4242F5FF5F5FF8FF0000E6FF000000FF777777FF5C5C5BFFBDBD
      BCFF9C9C9BFF4A4A4AFF50509DFF4242F4FF3564F8FF3564F8FF2791F6FF2ABC
      F6FF2475F5FF2791F6FF3C3CF5FF0000E8FFF5F4F4FFDAFEFEFF77FDFDFF77FD
      FDFFEBFCFCFFF5F4F4FFC67676FFB04041FFAE3C3CFFAA3333FFAA3333FFA428
      28FFA42828FF9F1F1FFFAE3C3CFF490000FFF1F9F1FFFEFEFEFFFEFEFEFFF4F9
      F4FF5BB85BFF4AB04BFF86C886FFE1EFE1FF5EBA5DFF34A534FF5BB85BFFD5E8
      D5FFA6D4A6FF229B22FF3EA93EFF003900FFF1F1FDFFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFCFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF5F5F5FFF5F5F5FFD6D6E7FF000000FF777777FF5C5C5BFF5C5C
      5BFF5B5B78FF5050D2FF4B4BFCFF4646FBFF4188FAFF3BCAF9FF33DBF8FF33DB
      F8FF2AAAF6FF2729F5FF4242F4FF0000E8FFF5F4F4FFF3FDFDFFDAFEFEFFE5FD
      FDFFE7D2D2FFC57171FFB44B4BFFB24545FFB04041FFAE3C3CFFAA3333FFAA33
      33FFA42828FFA42828FFB24545FF490000FFF1F9F1FFFEFEFEFFFEFEFEFFF4F9
      F4FF5EBA5DFF50B450FF4AB04BFFBBDFBBFFA6D4A6FF3CA73CFF40AC40FFACD7
      ACFF49AE49FF229B22FF44AD44FF003900FFF1F1FFFFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD6D6E7FF000000FF777777FF5C5C5BFF5050
      9DFF5454F9FF5454F9FF5454F9FF4B4BFCFF464AFBFF4188FAFF3CD3F9FF36BC
      F8FF3564F8FF2729F5FF4B4BF7FF0000E8FFE8F4F4FFFEFDFDFFFEFDFDFFE2B2
      B2FFBC5C5CFFB75252FFB75252FFB44B4BFFB24545FFB04041FFAE3C3CFFAA33
      33FFAA3333FFA42828FFB24545FF490000FFF1F9F1FFFFFFFFFFFEFEFEFFF4F9
      F4FF61BD62FF54B654FF50B450FF50B450FF6CC06BFF44AD44FF3AA93AFF34A5
      34FF30A430FF2AA12AFF49AE49FF004500FFF1F1FFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFD9D9E9FF000000FF7A7A8DFF7A7AD8FF7474
      FEFF7474FEFF7474FEFF7474FEFF6A6AFDFF6A6AFDFF6472FCFF5FADFBFF5B62
      FAFF5454F9FF5454F9FF4B4BF7FF0000E8FF36FFFFFFCAECF4FFDA9F9FFFC978
      78FFC67676FFC57171FFC57171FFC26868FFC26868FFC26868FFBE5F60FFBC5C
      5CFFB95657FFB75252FFB44B4BFF490000FFF1F9F1FFFFFFFFFFFFFFFFFFF7FC
      F7FF7EC87EFF72C371FF72C371FF6CC06BFF6ABC6AFF61BD62FF5EBA5DFF5BB8
      5BFF56B657FF51B251FF4AB04BFF004500FFF1F1FFFFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDDDDEBFF0F0F50FF0000E8FF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0101F3FF0101
      F3FF0101F3FF0101F3FF0101F3FF0000E8FF97ADADFF810000FF810000FF8100
      00FF810000FF810000FF810000FF6C0000FF6C0000FF6C0000FF6C0000FF6C00
      00FF6C0000FF490000FF490000FF490000FFF1F9F1FFF1F9F1FFF1F9F1FFE5F3
      E5FF008900FF007600FF007600FF007600FF007600FF007600FF006500FF0065
      00FF006500FF005900FF005900FF005900FFF1F1FFFFF1F1FFFFF1F1FFFFF1F1
      FFFFF1F1FDFFF1EFFDFFEEEEFDFFEEEEFDFFEDEDFBFFEBEBF9FFE9E9F7FFE6E6
      F4FFE6E6F4FFE3E3F1FFE1E1EFFFDFDFEDFF0000A6FF0000A6FF0000A6FF0000
      A6FF0000A6FF004F00FF004F00FF004F00FF003C00FF003C00FF003C00FF0032
      00FF003200FF003200FF002C00FF002C00FFEE4700FFE83700FFE83700FFE837
      00FFE22700FFE22700FFDE1900FFDE1900FFD7D7D7FFD2D2D2FFD2D2D2FFCECE
      CFFFCECECFFFCBCBCBFFCBCBCBFFCBCBCBFF0000F6FF0000F2FF0000F2FF0000
      EEFF0000EEFFCCCCEAFFCCCCEAFFCCCCEAFFC4C4E4FFC4C4E4FFC4C4E4FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFF0000C3FF0000C3FF0000C3FF0000
      B7FF0000B7FF0000B7FF0000B7FF0000A8FF0000A8FF0000A8FF0000A8FF0000
      A8FF00009CFF00009CFF00009CFF00009CFF0000B5FF6363DEFF5959DCFF5959
      DCFF5353DAFF4FBA4FFF4AB84AFF43B443FF43B443FF3BB23BFF38AF38FF33AF
      33FF31AC32FF2DA92DFF2DA92DFF002C00FFEE4700FFF7B177FFF5AE75FFF6AA
      6CFFF6AA6CFFF5A562FFF5A562FFF5A25DFFF6F6F6FFF5F5F5FFF4F4F4FFD4D4
      F2FFD4D4F2FFF2F2F2FFF2F2F2FFCBCBCBFF0000F6FF605FFDFF5C5CFAFF5757
      F9FF5453F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF0000C3FF6060E4FF5C5CE3FF5757
      E2FF5252E3FF4E4EDFFF4A4ADFFF4343DCFF4343DCFF3B3BDCFF3B3BDCFF3333
      D6FF3333D6FF2D2DD4FF2D2DD4FF00009CFF0000B5FF6363DEFF4444D6FF3E3E
      D3FF3A3AD2FF33AF33FF2EAD2EFF29AB29FF23A823FF1EA51EFF18A318FF13A1
      13FF0D9D0DFF0D9D0DFF2DA92DFF003200FFF14E00FFF8B37AFFF5A25DFFF59F
      58FFF49C53FFF3994EFFF19548FFF19548FFF5F5F5FFF4F4F4FFCBCBF1FF4646
      ECFF3031E8FFC7C7EFFFF2F2F2FFCBCBCBFF0000FAFF6767FCFF4444FBFF3E3E
      FAFF3838F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF4F4F4FF1313
      F2FF0F0FF2FF0C0CF1FF2D2DF2FF0000DFFF0000C3FF6666E6FF4343E0FF3B3B
      DCFF3B3BDCFF3333DCFF2B2BD9FF2B2BD9FF2020D6FF2020D6FF1515D3FF1515
      D3FF0C0CD0FF0C0CD0FF2D2DD4FF00009CFF0000B5FF6C6CE1FF4949D8FF4444
      D6FF3F3FD6FF3BB23BFF33AF33FF2EAD2EFF29AB29FF23A823FF1EA51EFF18A3
      18FF13A113FF0D9D0DFF31AC32FF003200FFF25700FFF8B680FFF5A562FFF5A2
      5DFFF59F58FFF49C53FFF19548FFF19548FFF6F6F6FFF5F5F5FFF4F4F4FF8888
      EEFF8888EEFFF2F2F2FFF3F3F3FFCECECFFF0000FAFF6767FCFF4848FAFF4444
      FBFF3E3EFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FF1818
      F3FF1313F2FF0F0FF2FF3131F3FF0000DFFFE9E9E9FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFFAFAFAFFEDE0CEFFCDB592FFCDB592FFEDE0CEFFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFDFDFDFFF0000B5FF6C6CE1FF4E4EDAFF4949
      D8FF4444D6FF3F3FD6FF3A3AD5FF3434D4FF2F2FD1FF2929D1FF2323CCFF1A1A
      CBFF1A1ACBFF1A1ACBFF3535D1FF000092FFF25700FFF8B680FFF8A866FFF5A5
      62FFF5A25DFFF59F58FFF49C53FFF3994EFFF6F6F6FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD2D2D2FF0000FDFF7070FEFF4E4EFCFF4848
      FAFF4444FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FF1E1E
      F4FF1818F3FF1313F2FF3535F4FF0000E2FFE9E9E9FFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFF2F5ECFFBFB19FFF988498FF988498FFC2AF92FFECEFE5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFE6E6E6FF0000BFFF7474E3FF5353DAFF4E4E
      DAFF4949D8FF4444D6FF3F3FD6FF3A3AD5FF3535D1FF2F2FD1FF2A2ACEFF2323
      CCFF1A1ACBFF1A1ACBFF3A3AD2FF000092FFF57E1AFFFAC89DFFF9BA87FFF9BA
      87FFF8B680FFF8B37AFFF7B177FFF5AE75FF7D7DF0FF7777F1FF7171F2FF7171
      F2FF6A6AEEFF6A6AEEFF7D7DF0FF0000D5FF0000FDFF7070FEFF5252FDFF4E4E
      FCFF4A49FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FF2424
      F5FF1E1EF4FF1818F3FF3C3CF5FF0000E6FFE9E9E9FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFF9AF3F3FF5DDCEAFF6068D0FF8291BDFF5DDCEAFF8AEEEFFFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE6E6E6FF0000BFFF7474E3FF5959DCFF5353
      DAFF4F4EDAFF4949D8FF4444D6FF3F3FD6FF3A3AD2FF3535D1FF2F2FD1FF2A2A
      CEFF2323CCFF2323CCFF3E3ED3FF000092FFF1F1F1FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFFCFCFCFFFCFCFCFFFAFAFAFF3B3BF1FF3536EFFF3030EEFF2A2A
      EDFF2323EBFF2323EBFF4040EFFF0000D5FF0000FDFF7676FEFF5858FEFF5353
      FDFF4F4EFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FF2A2A
      F6FF2424F5FF1E1EF4FF3C3CF5FF0000E6FFE9E9E9FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFE7FCFCFF6FEDEFFF4767E3FF509BE8FF63E9EBFFDFF7F7FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE6E6E6FF0000BFFFF7F7FCFFB0B0EEFFFAFA
      FEFF5353DAFFFDFDFDFFFCFCFCFFFAFAFAFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7
      F7FFF6F6F6FFF6F6F6FFF6F6F6FFD8D8D8FFF1F1F1FFFEFEFEFFFEFEFEFFFBD7
      B8FFFBD7B8FFFDFDFDFFFCFCFCFFFCFCFCFF4B4BF1FF3B3BF1FF3536EFFF3030
      EEFF2A2AEDFF2323EBFF4646ECFF0000D5FF0000FFFF7878FEFF5B5BFEFF5858
      FEFF5353FDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FF3030
      F7FF2A2AF6FF2424F5FF4343F6FF0000E6FFE9E9E9FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFFCFCFCFFD0FCFCFF7AD4EEFF82E2EFFFC8F9F9FFF8F8F8FFF6F6
      F6FFF6F6F6FFF4F4F4FFF5F5F5FFE6E6E6FF0000BFFFE1E1F9FFFAFAFEFFD7D7
      F7FF5959DCFFFDFDFDFFFDFDFDFFFCFCFCFFFAFAFAFFFAFAFAFFFAFAFAFFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFD8D8D8FFF1F1F1FFFFFFFFFFFDF0E4FFF9BA
      87FFF9BA87FFFDF0E4FFFDFDFDFFFCFCFCFF5150F3FF4040EFFF3B3BF1FF3536
      EFFF3030EEFF2A2AEDFF4646ECFF0000D5FF0000FFFF7A7AFFFF605FFDFF5B5B
      FEFF5858FEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FF3838
      F9FF3030F7FF2B2BF6FF4848FAFF0000EAFF0000D3FF7979EBFF5D5DE7FF5D5D
      E7FF5858E6FF5252E3FF5252E3FF4A4ADFFF4343E0FF4343E0FF3B3BDCFF3333
      DCFF3333DCFF2B2BD9FF4A4ADFFF0000A8FF0000BFFFF0F0FCFFBEBEF2FFF7F7
      FCFF7474E3FFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFAFAFAFFFAFA
      FAFFFAFAFAFFF8F8F8FFF7F7F7FFDEDEDEFFF1F1F1FFFFFFFFFFFFFFFFFFFEF4
      ECFFFEF4ECFFFEFEFEFFFDFDFDFFFDFDFDFF7171F2FF6262F5FF6262F5FF5959
      F3FF5959F3FF5150F3FF4B4BF1FF0000DFFF0000FFFF7A7AFFFF7A7AFFFF7878
      FEFF7676FEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFF5C5C
      FAFF5757F9FF5252F8FF4D4DF7FF0000EAFF0000D3FF7979EBFF7979EBFF7979
      EBFF7979EBFF7271E9FF7271E9FF6C6CE8FF6666E6FF6666E6FF6060E4FF5C5C
      E3FF5757E2FF5252E3FF4E4EDFFF0000B7FF0000BFFF0000BFFF0000BFFF0000
      BFFF0000BFFFF0EFEFFFF0EFEFFFEDEDEDFFEDEDEDFFEAEAEAFFEAEAEAFFE6E6
      E6FFE6E6E6FFE2E2E2FFE2E2E2FFDEDEDEFFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF0EFEFFFF0EFEFFFEDEDEDFF0000EAFF0000EAFF0000EAFF0000
      EAFF0000DFFF0000DFFF0000DFFF0000DFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFFE7E7FDFFE4E4FCFFE4E4FCFFE4E4FCFFE0E0F8FFE0E0F8FF0000
      F6FF0000F2FF0000F2FF0000EEFF0000EEFF0000D3FF0000D3FF0000D3FF0000
      D3FF0000D3FF0000D3FF0000CCFF0000CCFF0000CCFF0000CCFF0000C3FF0000
      C3FF0000C3FF0000C3FF0000B7FF0000B7FF48100AFF430F09FF3D0E09FF3B0D
      08FF390C07FF370B07FF370A06FF360906FF350805FFE6E6E6FFE6E6E6FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FF380000FF380000FF250000FF2500
      00FF250000FF110000FF110000FF110000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF50D6EFFF57DCF3FF53D9F0FF50D6
      EFFF4AD4ECFF4AD4ECFF45D1E9FF42CEE8FF42CEE8FF3BC8E4FF3BC8E4FF3BC8
      E4FF34C1DFFF34C1DFFF34C1DFFF34C1DFFF4E0000FF4E0000FF310000FF3100
      00FF310000FF310000FF310000FF310000FF0D0000FF0D0000FF0D0000FF0D00
      00FF0D0000FF0D0000FF0D0000FF0D0000FF351115FF0000C7FF5656E4FF5151
      E3FF0000C2FF0000C1FF0000AFFF390C07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF380000FFAC8764FFAA845FFFB394
      75FFAA8764FFA07851FF9E754DFF9C7149FF996E45FF976B40FF94673CFF9265
      3AFF916235FF8D5F32FF8D5C2EFF000000FF53D9F0FF5BF5F8FF5BF5F8FF55F0
      F5FF55F0F5FF52EEF3FF4DEBF1FF4DEBF1FF46E6EEFF46E6EEFF43E4ECFF41E1
      EAFF3DE0EAFF3DE0EAFF3DE0EAFF34C1DFFF4E0000FFB37362FFAF6E5EFFAB66
      54FFAB6654FFA8604EFFA55C49FFA35844FFA05440FF9E503BFF9C4E39FF9A53
      46FF7C588EFF95412CFF95412CFF0D0000FF3D1419FF6C6CE7FFDCDCF9FFDBDB
      F9FF5C5CE4FF0000AFFF460F0AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF470000FFAE8B69FFAA845FFFEDE6
      E0FFD6C7B8FF92653AFF8D5F32FF8D5C2EFF8A5829FF845221FF814C1AFF814C
      1AFF7B4611FF7B4611FF8D5F32FF000000FF53D9F0FF60F9FBFF58F2F5FF55F0
      F5FF52EEF3FF4FEAF0FF4CE9EEFF48E6EDFF48E6EDFF43E1E9FF3FDFE7FF3FDF
      E7FF3CDCE6FF3CDCE6FF3DE0EAFF34C1DFFF5E0000FFB37362FFA35844FFA153
      3FFF9C4E39FF994934FF95412CFF95412CFF903821FF903821FF8A2F16FF5546
      B1FF5546B1FF663971FF95412CFF0D0000FF54171DFF7C7CEAFFE0E0F9FFE0E0
      F9FF4A4ADFFF5C150DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF470000FFB18F6DFFC4AB93FFFBFB
      FBFFEDE6E0FF9A6D42FF916235FF8D5F32FF8D5C2EFF8A5829FF845221FF814C
      1AFF814C1AFF7B4611FF916235FF000000FF57DCF3FF60F9FBFF58F2F5FF58F2
      F5FF55F0F5FF52EEF3FF4FEAF0FF4CE9EEFF4CE9EEFF48E6EDFF45E4EBFF43E1
      E9FF3FDFE7FF3FDFE7FF41E1EAFF34C1DFFF5E0000FFB67969FFA55C49FFA358
      44FFA1533FFF9C4E39FF994934FF95412CFF95412CFF903821FF903821FF8A2F
      16FF663971FF8A2F16FF994934FF0D0000FF6B1B21FF0000D8FF8888ECFF8282
      EAFF741A10FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF530700FFB49473FFA27A54FFBFA8
      8FFFA27A54FF996E45FF976B40FF92653AFF916235FF8D5C2EFF8A5829FF8556
      26FF845221FF814C1AFF92653AFF000000FF57DCF3FF60F9FBFF5BF5F8FF58F2
      F5FF58F2F5FF55F0F5FF52EEF3FF50EDF2FF4CE9EEFF4CE9EEFF48E6EDFF45E4
      EBFF43E1E9FF40E0E7FF43E4ECFF3BC8E4FF5E0000FFB97E6EFFA8604EFFA55C
      49FFA35844FFA05440FF9C4E39FF994934FF95412CFF95412CFF903821FF9038
      21FF8A2F16FF8A2F16FF994934FF0D0000FF831E26FF0000DEFF0000DCFFB443
      2BFF962C1CFF7E1D15FF771B11FF711910FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF1CB5DFFF9ADDF1FF82D5EAFF82D5
      EAFF7BD1E9FF7BD1E9FF75CFE8FF70CBE5FF6ACAE5FF6ACAE5FF62C6E2FF62C6
      E2FF5BC3E0FF57C1DEFF70CBE5FF0081BBFFCA5555FFA6A6F9FFDC878AFFEB94
      82FF4851F9FFE98779FFC97983FF5857E3FFB4636DFF4CE9EEFF4CE9EEFF48E6
      EDFF45E4EBFF43E1E9FF46E6EEFF3BC8E4FF5C225CFFA97B88FF9A5252FF9060
      7EFF90607EFF8E4545FFA16361FF9D7795FF994934FF695FC3FF6855B0FF9038
      21FF903821FF6D4178FF9C4E39FF0D0000FF992129FFAEAEF2FFEBEBFBFFEAEA
      FBFF0000DDFF0000D0FF7E1D15FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF5C1A00FFB69B7DFFA68461FFA581
      5CFFA57D58FFA07851FF9E734AFF9A6F47FF976B40FF94673CFF916235FF8D5F
      32FF8A5829FF855626FF996E45FF000000FFEE785AFFFCE1D7FFBEC0FEFFEDD2
      DAFF51F3FDFFDEB5C7FFB3B4FBFFEEA99DFFD8736BFF48E2E6FF4CE9EEFF4CE9
      EEFF48E6EDFF45E4EBFF48E6EDFF42CEE8FF99606AFFCAC2E4FFAF8797FF9483
      C2FF9483C2FFC59C97FFBAB2D9FF9D7795FF9E503BFF7660B3FF9A5346FF9541
      2CFF795186FF6855B0FF845E91FF0D0000FFAB242DFFF0F0FCFFDDDDF9FFDBDB
      F9FFE6E6FAFF9E261CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF5E1400FFB9997AFFAA845FFFA982
      5BFFA57D58FFA47953FFA1764DFF9E734AFF996E45FF976B40FF94673CFF9162
      35FF8D5C2EFF8A5829FF9A6F47FF110000FF474AF5FFD5D4FDFF82E9FEFF9595
      F9FF5FCBFDFF7D82FDFF68D7FDFF9595F9FF5857E3FF4FEAF0FF50EDF2FF4FEA
      F0FF4CE9EEFF48E6EDFF4DEBF1FF42CEE8FF48227EFFBEB8E2FFA8AAF1FF8585
      E4FF8585E4FFA8AAF1FF9189D5FF9576A6FFA35844FF9E503BFF994934FF7951
      86FF95412CFF795186FFA35844FF0D0000FFB9262FFF0000ECFFE4E4FAFFD3D3
      F6FFBA3123FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF5E1400FFBB9D7DFFAC8762FFAA84
      5FFFA9825BFFA57D58FFA27A54FFA1764DFF9E734AFF996E45FF976B40FF9467
      3CFF916235FF8D5F32FF9E754DFF110000FF675DE8FFD5D4FDFF82E9FEFFA6A6
      F9FF68D7FDFF9595F9FF70DFFCFFA6A6F9FF675DE8FF57EBF4FF56EFF3FF50ED
      F2FF4FEAF0FF4CE9EEFF50EDF2FF45D1E9FF1818CFFF9594E7FF8585E4FF7677
      E5FF6D6CDEFF7677E5FF7677E5FF6D6CDEFFA55C49FFA05440FF845E91FF6F65
      C8FF845E91FF95412CFFA55C49FF310000FFC62832FF0000F0FF0101E7FFCC36
      27FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF5E1400FFBB9D7DFFBB9D7DFFB999
      7AFFB9997AFFB69676FFB49473FFB2916FFFB18F6DFFAE8B69FFAB8864FFAA84
      5FFFA5815CFFA37C56FFA07851FF110000FFEE785AFFFCE1D7FFD5D4FDFFF5E1
      E5FF7BFAFEFFEDD2DAFFC5C6FDFFF7CABDFFE98779FF56EFF3FF5BF5F8FF5BF5
      F8FF58F2F5FF55F0F5FF50EDF2FF4AD4ECFF6A162CFFCAC2E4FFDFD4E0FFB4AA
      D8FFAAA1D8FFC5BAD8FFD7CFE6FFC59C97FFB67969FFB37362FFAF6E5EFF9576
      A6FFAF6E5EFFAB6654FFA8604EFF310000FFC92932FFD6301FFFD63120FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FF5C1A00FF5E1400FF5E1400FF5E14
      00FF5E1400FF530700FF530700FF530700FF470000FF470000FF470000FF3800
      00FF380000FF250000FF250000FF250000FFD8736BFF6E76FDFFDC878AFFE987
      79FF4851F9FFD8736BFFD8736BFF474AF5FFB13035FF53D9F0FF5AE2F6FF57DC
      F3FF57DCF3FF53D9F0FF50D6EFFF4AD4ECFF8170C3FF90607EFF5E0000FF3A14
      7EFF3C1685FF4E0000FF521E64FF7660B3FF5E0000FF4E0000FF4E0000FF4E00
      00FF4E0000FF4E0000FF310000FF310000FF007900FF006300FF006300FF0058
      00FF005800FFC7D3C7FFD9D9D9FFD6D6D6FFD6D6D6FFD6D6D6FFBDC7BDFF002B
      00FF002B00FF002B00FF002B00FF003600FFF54900FFF13C00FFF13C00FFEF35
      00FFEF3500FFEB2400FFEB2400FFEB2400FFE51200FFE51200FFE51200FFDE02
      00FFDE0200FFDE0200FFDE0200FFDE0200FF730000FF730000FF730000FF7300
      00FF580000FF580000FF580000FF580000FF580000FF460000FF460000FF4600
      00FF3B0000FF3B0000FF3B0000FF3B0000FF0000D4FF0000D4FF0000CDFFF2F2
      F2FFAE0E00FFEAEAEAFF0000C4FF0000BDFF0000BDFF0000BDFF0000BDFF0000
      B5FF0000B5FF0000B1FF0000B1FF0000B1FF006B00FF60BF5FFF5BBD5BFF57B9
      57FF53B653FFEFF4EFFFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFEAF0EAFF35A7
      35FF31A731FF2EA42EFF2BA42BFF002B00FFF54900FFFCB164FFFCAE60FFFAAA
      5AFFFAAA5AFFFBA653FFF7A651FFF9A14BFFF99E45FFF59C41FFF7993EFFF398
      3AFFF59637FFF49333FFF49333FFDE0200FF730000FFC79263FFC38A59FFC38A
      59FFC18553FFBF824FFFBC7E4AFFBA7A44FFB77641FFB8753DFFB57139FFB26D
      33FFB26D33FFAE692EFFAE6529FF3B0000FF0000D4FF6063EDFF5B5DEDFFF9F9
      F9FFE4A579FFF8F8F8FF494BE7FF4548E6FF4244E5FF3C3FE4FF383AE2FF3436
      E4FF3134E0FF2E30E2FF2B2DDEFF0000B1FF007900FF65C065FF44B144FF3EAD
      3EFF38AA38FFEFF4EFFFF7F7F7FFF6F6F6FFF5F5F5FFF5F5F5FFE7EEE7FF1197
      11FF0C960CFF0C960CFF2EA42EFF002B00FFFB5600FFFCB36BFFF9A14BFFF99E
      45FFF7993EFFF89639FFF49333FFF9942EFFF58B27FFF58B27FFF3861CFFF386
      1CFFF18013FFF18013FFF49333FFDE0200FF730000FFC79263FFBA7A44FFB875
      3DFFB57139FFB26D33FFB2692DFFAE6529FFAB5F20FFAB5F20FFA75715FFA757
      15FFA2500CFFA2500CFFAE692EFF3B0000FF0000DAFF6567EEFF4243E9FFFAFA
      FAFFDD9564FFF8F8F8FF2E30E2FF2A2CE3FF2326E2FF1E20E0FF181BDFFF1316
      DDFF0E11DCFF0A0DDAFF2E30E2FF0000B1FF007900FF6CC46CFF48B448FF44B1
      44FF3EAD3EFFEFF4EFFFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFE8EFE8FF189B
      18FF139A13FF119711FF31A731FF002B00FFF9942EFFFDD1A2FFFCC38AFFFCC3
      8AFFFBC085FFF4BD80FFF7BA7BFFE6B67BFFE6B67BFFF6B471FFF5B16CFFF3AE
      69FFF2AC64FFF2AC64FFF3B679FFDF5600FF8F2000FFCE9E76FFC38A59FFC185
      53FFBF824FFFBC7E4AFFBA7A44FFB77641FFB57139FFB26D33FFAE692EFFAE65
      29FFAE6529FFAB5F20FFB77641FF460000FF0000DAFF6A6CEFFF4A4CEBFFFAFA
      FAFFE09A6AFFF9F9F9FF3436E4FF2E30E2FF2A2CE3FF2326E2FF1E20E0FF181B
      DFFF1316DDFF0E11DCFF3134E0FF0000B5FF007900FF6CC46CFF4FB64FFF48B4
      48FF44B144FFF2F7F2FFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFEAF0EAFF1E9E
      1EFF189B18FF139A13FF35A735FF003600FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFF94EDFAFF80E1EDFF80E1EDFF8AE9F7FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE5E5E5FFEFEFEEFFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5F5FFF4F4
      F4FFF2F2F2FFF2F2F2FFF4F4F4FFD1D1D1FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFE19D6EFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF4F4F4FFF4F4
      F4FFF4F4F4FFF2F2F2FFF2F2F2FFEAEAEAFF008500FF72C671FF53B953FF4FB6
      4FFF49B349FFF2F7F2FFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFECF2ECFF24A1
      24FF1E9E1EFF189B18FF38AA38FF003600FFFDFDFDFFFDFDFDFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFF94EDFAFFB1C3ADFF7691CEFF8AE9F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE5E5E5FFEFEFEEFFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F5FFF4F4F4FFF2F2F2FFF5F5F4FFD1D1D1FFD05505FFEBB894FFE4A579FFE4A3
      76FFE39F72FFE19D6EFFE09A6AFFDD9564FFDD9564FFDB905CFFD98C56FFD98C
      56FFD6854DFFD6854DFFDD9564FFAE0E00FF008500FF76C876FF57BC57FF53B9
      53FF4EB54EFFF2F7F2FFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFECF2ECFF2BA4
      2BFF24A124FF1F9F1FFF3EAD3EFF003600FFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFCFCFCFFFCFCFCFF99F0FBFF8BE4F6FF86E2F4FF8FECF8FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FFF2F2F2FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD5D5D5FFFDFDFDFFFEFEFEFFFEFEFEFFFDFD
      FDFFE4A376FFFCFCFCFFFAFAFAFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7
      F7FFF4F4F4FFF4F4F4FFF4F4F4FFEAEAEAFF008500FF79C979FF5BBD5BFF58BB
      58FF53B653FFF2F7F2FFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFEFF4EFFF31A7
      31FF2BA42BFF24A124FF43AF43FF004900FFFF9B34FFFDD1A2FFFEC78FFFFEC7
      8FFFFCC38AFFFCC38AFFFBC085FFF4BD80FFF4BD80FFF7BA7BFFF8B775FFF6B4
      71FFF5B16CFFF3AE69FFF7BA7BFFE75E00FF3014FFFFA497FEFF9182FEFF8F7E
      FEFF8979FEFF8979FEFF8374FDFF806FFCFF7D6CF8FF7969FBFF7261FAFF7261
      FAFF6D59F6FF6955F5FF7D6CF8FF0000EBFF0000E1FF797BF2FF5B5DEDFFFEFE
      FEFFE4A579FFFDFDFDFF4A4CEBFF4648EBFF4243E9FF3C3EE8FF3639E7FF3033
      E5FF2A2CE3FF2528E2FF4244E5FF0000BDFF008B00FF79C979FF60BF5FFF5BBD
      5BFF58BB58FFF5FAF5FFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFEFF4EFFF38AA
      38FF31A731FF2BA42BFF49B349FF004900FFFE6300FFFFBE7DFFFCB164FFFCAE
      60FFFCAE60FFFAAA5AFFFBA653FFFBA653FFF9A14BFFF99E45FFF99E45FFF799
      3EFFF59637FFF49333FFF9A14BFFEB2400FF0000FFFF8679FFFF6A5CFDFF6A5C
      FDFF6658FEFF6353FBFF5E4FFAFF594BFCFF5647F9FF5041FAFF4C3BF9FF4636
      F8FF4130F7FF3B2BF6FF5647F9FF0000EBFF0000E1FF797BF2FF5E60F0FFFEFE
      FEFFE7A87DFFFDFDFDFF5153EBFF4A4CEBFF4648EBFF4243E9FF3C3EE8FF3639
      E7FF3033E5FF2A2CE3FF494BE7FF0000C4FF008500FF79C979FF79C979FF79C9
      79FF76C876FFF5FAF5FFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFF2F7F2FF5BB9
      5BFF57B957FF53B653FF4EB54EFF004900FFFF6A00FFFFBE7DFFFFBE7DFFFFBE
      7DFFFFBE7DFFFEBA74FFFEBA74FFFEBA74FFFCB36BFFFCB36BFFFCB164FFFCAE
      60FFFAAA5AFFFAAA5AFFF7A651FFEB2400FF0000FFFF8979FEFF8979FEFF8679
      FFFF8374FDFF8374FDFF806FFCFF7969FBFF7969FBFF7261FAFF7261FAFF6A5C
      FDFF6756F9FF6353FBFF5E4FFAFF0000EBFF0000E1FF797BF2FF797BF2FFFEFE
      FEFFEBB894FFFEFEFEFF7071F0FF6A6CEFFF6A6CEFFF6567EEFF6063EDFF5B5D
      EDFF5659EBFF5153EBFF4D4FE8FF0000C4FF008B00FF008B00FF008B00FF0085
      00FF008500FFDCE6DCFFEEEEEEFFEEEEEEFFEEEEEEFFEBEBEBFFDCE6DCFF006B
      00FF006300FF006300FF005800FF006300FFFF7000FFFF6A00FFFF6A00FFFF6A
      00FFFF6A00FFFE6300FFFE6300FFFB5600FFFB5600FFFB5600FFF54900FFF549
      00FFF13C00FFF13C00FFEF3500FFEF3500FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000EBFF0000EBFF0000E1FF0000E1FF0000E1FFFEFE
      FEFFD05505FFFDFDFDFF0000DAFF0000DAFF0000DAFF0000DAFF0000D4FF0000
      D4FF0000D4FF0000CDFF0000CDFF0000CDFF0001F1FF0001F1FF0001F1FF93A9
      CBFF89C981FF005300FF005300FF005300FF003300FF003300FF003300FF0033
      00FF003300FF003300FF003300FF003300FF002C00FF001300FF001300FF0013
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF006B00FF006B00FF006B00FF006B
      00FF004E00FF004E00FF004E00FF004E00FF002E00FF004E00FF002E00FF002E
      00FF002E00FF002E00FF002E00FF002E00FF001100FF001100FF001100FF0000
      00FF7AA87AFFD6D8D7FFDDDDDDFFCBD0CBFFC3CBC3FFD6D8D7FFCBD0CBFF5A93
      5AFF000000FF000000FF000000FF000000FF0001F1FF6060FAFF5A5BFAFF5A5B
      FAFFADAFF2FFD6E8D7FF8DD088FF42AF41FF42AF41FF3BAB3BFF35A835FF35A8
      35FF30A530FF30A530FF28A228FF003300FF002C00FF82A563FF7CA05CFF7791
      57FF6D8453FF697E4FFF658C42FF689145FF658C42FF658C42FF588432FF5884
      32FF588432FF588432FF4F7C25FF000000FF006B00FF61BD60FF61BD60FF53B7
      53FF53B753FF53B753FF48B148FF48B148FF42AE42FF3BAA3BFF3BAA3BFF34A8
      34FF32A532FF2DA22DFF2DA22DFF002E00FF002A00FF629E61FF5C9E5CFF579A
      57FFC9DDC9FFF5F6F5FFF7F7F7FF7BAB7BFF7AA87AFFF5F6F5FFF1F1F1FFBCD2
      BCFF328132FF2C7B2CFF2C7B2CFF000000FFEFE0E1FFC2C1F9FF444AFAFF413F
      F9FF3A3AF9FF6C65F8FFCCD8E2FFAED2B2FF30A530FF1A9C1AFF1A9C1AFF1399
      13FF0D960DFF0D960DFF30A530FF003300FF002C00FF82A563FF52C7A8FF3F5D
      5BFF374C4CFF374C4CFF374C4CFF41AA77FF4F7C25FF457519FF457519FF3C6E
      0EFF3C6E0EFF3C6E0EFF588432FF000000FF006B00FF61BD60FF42AE42FF3BAA
      3BFF3BAA3BFF32A532FF2DA22DFF259F25FF259F25FF1B981AFF1B981AFF0E92
      0EFF0E920EFF0E920EFF2DA22DFF002E00FF002A00FF69A269FF438D43FF3E8A
      3EFFC2D7C2FFEAEEEAFFCDDFCDFF5A935AFF5A935AFFC2D7C2FFD8E5D8FFB4CD
      B4FF0C680CFF0C680CFF2C7B2CFF000000FF870000FFEFE0E1FFE9E4F2FF6A6F
      FBFF413FF9FF3A3AF9FF413FF9FFADAFF2FFD6E8D7FF5BBC54FF1A9C1AFF1A9C
      1AFF139913FF0D960DFF30A530FF003300FF002C00FF78D4B7FF4FD7D3FF429A
      9AFF374C4CFF374C4CFF339191FF35F6F8FF41AA77FF4F7C25FF457519FF4575
      19FF3C6E0EFF3C6E0EFF588432FF000000FFC5DFC5FFE5F3E5FFDFF0DFFFDFF0
      DFFFDFF0DFFFDFF0DFFFDDEDDAFFDDEDDAFFDDEDDAFFD8EAD7FFD5E8D5FFD5E8
      D5FFD1E5D1FFD1E5D1FFD5E8D5FFA1C7A1FF002A00FF69A269FF4B934BFF438D
      43FFC5DAC5FF9BBD9BFF4F8E4FFF2C742CFF2C742CFF357D35FF84AD84FFB4CD
      B4FF126C12FF0C680CFF328132FF000000FF790000FFC56F6FFFD59590FFF1E9
      ECFF9F9FF9FF413FF9FF3A3AF9FF3535F8FF7677F8FFD4E1E0FF9CD596FF28A2
      28FF1A9C1AFF139913FF35A835FF003300FF0700FDFF7AB9FCFF4AFBFBFF4AFB
      FBFF429A9AFF429A9AFF35F6F8FF35F6F8FF39C1F5FF512AF6FF4C24F5FF451B
      F3FF451BF3FF451BF3FF5732F7FF0000E5FFF2F2F2FFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFB5CEF9FF7AABFBFF70A4F7FFACC8F6FFF5F5F5FFF4F4
      F4FFF2F2F2FFF2F2F2FFF4F4F4FFD5D5D5FF003D00FF6EA86EFF4B934BFF4B93
      4BFFC5DAC5FFA1C1A1FF69A269FF3B843BFF357D35FF5A935AFF90B390FFB4CD
      B4FF196F19FF126C12FF328132FF000000FF870000FFC56F6FFFB95454FFC369
      69FFEFE0E1FFE1DDF2FF5A5BFAFF3A3AF9FF3535F8FF413FF9FFBBC0ECFFC6E3
      C6FF42AF41FF1A9C1AFF3BAB3BFF003300FF0700FDFF74EEFCFF53FDFDFF4EA1
      A1FF4C7272FF4C7272FF429A9AFF35F6F8FF35F6F8FF5732F7FF512AF6FF4C24
      F5FF451BF3FF451BF3FF5F3CF5FF0000E5FFF2F2F2FFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFF98BDFAFF3981F9FF3378F8FF86B2F9FFF6F6F6FFF5F5
      F5FFF4F4F4FFF2F2F2FFF5F5F5FFD5D5D5FF003D00FF74AC73FF529752FF4B93
      4BFFC9DDC9FFFBFCFBFF7AA87AFF418641FF357D35FF69A269FFF5F6F5FFBAD2
      BAFF1F741FFF196F19FF3B843BFF000000FF870000FFC87574FFA67077FFA670
      77FFB95454FFDEA8A3FFF1E9ECFF8989F8FF3A3AF9FF3535F8FF3030F7FF8989
      F8FFD4E1E0FF83CB7BFF42AF41FF003300FF0700FDFF83BEFDFF58FCFDFF53FD
      FDFF4C7272FF4EA1A1FF43FBFBFF43FBFBFF43C6F7FF5732F7FF5732F7FF512A
      F6FF4C24F5FF451BF3FF5F3CF5FF0000E5FFF5F5F5FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFBDD4FBFF86B2F9FF7AABFBFFB5CEF9FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD5D5D5FF003D00FF74AC73FF579A57FF5297
      52FFC9DDC9FFFBFCFBFFBFD5BFFF498D49FF418641FF84AD84FFF7F7F7FFBAD2
      BAFF257825FF1F741FFF3E8A3EFF000000FF8F0000FFC38487FF63D6F1FF63D6
      F1FFA67077FFB95454FFC87574FFEFE0E1FFD5D2F2FF4D4FF8FF3535F8FF3030
      F7FF524BF6FFC4CBE9FFC6E3C6FF005300FF7C1C70FF9AD0D2FF5DF3F3FF58FC
      FDFF4EA1A1FF4C7272FF4AFBFBFF4AFBFBFF86A8C6FFAB71A4FFAB71A4FFA364
      9BFFA3649BFFA3649BFFAB71A4FF340024FFC9D9F5FFEAF2FEFFE5EFFEFFE5EF
      FEFFE2EDFDFFE2EDFDFFE1EBFBFFE1EBFBFFE1EBFBFFDDE9F9FFDDE9F9FFDAE5
      F6FFDAE5F6FFD6E3F5FFDAE5F6FF9DB5DBFF004200FF79AF79FF5C9E5CFF579A
      57FFCDDFCDFFFBFCFBFFFAFAFAFF629E61FF5C985CFFF5F6F5FFF7F7F7FFBFD5
      BFFF2C7B2CFF257825FF438D43FF000000FF8F0000FFC38487FF63D6F1FF63D6
      F1FFA67077FFB95454FFB95454FFB95454FFE3BAB5FFEBE1EBFF7677F8FF3535
      F8FF3030F7FF2C2BF6FFADAFF2FFAED2B2FFCB4A00FFE9B38FFF9AD0D2FF6FE2
      DEFF5DF3F3FF53FDFDFF5AEEECFFA8BC9FFFDD9666FFDB8D59FFDB8D59FFDB8D
      59FFD6844DFFD6844DFFDD9666FFAC0700FF004AFEFF7AABFBFF5C9AFDFF5C9A
      FDFF5896FEFF5395FBFF4E8EFDFF4E8EFDFF4589F9FF4589F9FF3981F9FF3981
      F9FF3378F8FF3378F8FF4589F9FF0005ECFF004200FF79AF79FF5C9E5CFF5C9E
      5CFFCEE0CEFFFAFAFAFFFDFDFDFF7BAB7BFF74A674FFFAFAFAFFF7F7F7FFBFD5
      BFFF328132FF2C7B2CFF498D49FF000000FF870000FFC87B7DFFC38487FFB98F
      94FFC87B7DFFC87574FFC56F6FFFC36969FFC36969FFD89F9BFFF1E9ECFFD5D2
      F2FF6060FAFF4D4FF8FF4D4FF8FF0001F1FFC74604FFE9B38FFFE9B38FFFE3A8
      89FFCAAE99FFCAAE99FFE3A889FFE3A889FFE3A57BFFE3A57BFFE3A57BFFE09E
      72FFE09E72FFDD9666FFDD9666FFAC0700FF004AFEFF79AFFFFF79AFFFFF79AF
      FFFF73ABFEFF73ABFEFF73ABFEFF68A4FCFF68A4FCFF68A4FCFF5F9EFBFF5F9E
      FBFF5698F9FF5395FBFF4D93F7FF0005ECFF004200FF79AF79FF79AF79FF79AF
      79FFD8E5D8FFFBFCFBFFFDFDFDFFF1F6F1FFE4EBE4FFFBFCFBFFF7F9F8FFCDDF
      CDFF569857FF529752FF4B934BFF000000FF8F0000FF870000FF8F0000FF8F00
      00FF870000FF870000FF870000FF790000FF790000FF790000FF870000FFD595
      90FFCDBBD7FF0001F1FF0001F1FF0001F1FFCB4A00FFCB4A00FFCB4A00FFCB4A
      00FFC74604FFC74604FFC43900FFC43900FFC43900FFBB2500FFBB2500FFBB25
      00FFBB2500FFAC0700FFAC0700FFAC0700FF004AFEFF004AFEFF004AFEFF004A
      FEFF004AFEFF004AFEFF004AFEFF0038FBFF0038FBFF0038FBFF0021F3FF0021
      F3FF0021F3FF0021F3FF0005ECFF0021F3FF004200FF004200FF004200FF0042
      00FF9BBD9BFFEAEEEAFFF1F1F1FFF1F1F1FFEAEEEAFFF1F1F1FFE4EBE4FF8BB5
      8BFF001100FF001100FF000000FF000000FF006C00FF006C00FF006C00FF0057
      00FF005700FF005700FF004400FF004400FF004400FF004400FF003200FF0032
      00FF003200FF002800FF002800FF003200FF003000FF003000FF003000FF0030
      00FF003000FFD2D3D2FFD7D7D7FFD2D3D2FFD2D3D2FFCFCFCFFFC3C3C9FF0000
      AEFF0000AEFF0000AEFF0000AEFF0000AEFFC5C7F1FFC2C2EEFFC2C2EEFFBBBB
      EAFFBBBBEAFFB5B5E6FFB5B5E6FFAFAFE3FFAAAADEFFAAAADEFFA5A6DCFFA5A6
      DCFFA0A0D7FFA0A0D7FF9D9DD6FF9D9DD6FF0004F0FF00A9F0FF00A9F0FF00A9
      F0FF00A9F0FF009CEBFF009CEBFF009CEBFF0091E3FF0091E3FF0091E3FF0091
      E3FF0085DDFF0085DDFF0085DDFF0085DDFF006C00FF61BE60FF5ABB5AFF5ABB
      5AFF52B651FF52B651FF46B246FF46B246FF41AE41FF3AAC3AFF3AAC3AFF34AA
      34FF2FA52FFF2FA52FFF2BA62BFF002800FF004B00FF84AD67FF81AB63FF7CA9
      5FFF73A254FFF6F7F5FFF7F7F7FFF7F7F7FFF5F6F5FFF5F6F5FFF0F0F3FF4A46
      DCFF4A46DCFF4A46DCFF4843E0FF0000AEFFDFDFF7FFF1F1FBFFEEEEF9FFEEEE
      F9FFEEEEF9FFEAEAF8FFEAEAF8FFE8E8F7FFE8E8F6FFE6E6F4FFE6E6F4FFE4E4
      F3FFE2E2F2FFE2E2F2FFE2E2F2FFBBBBDDFF0000FFFF657AFCFF5DC7F6FF53DB
      F9FF53DBF9FF53DBF9FF45D3F7FF45D3F7FF45D3F7FF38CFF4FF38CFF4FF38CF
      F4FF2ECBF2FF2ECBF2FF2ECBF2FF0085DDFF006C00FF5FB65FFF399039FF266D
      26FF1D551DFF1A541AFF1A671AFF238723FF209920FF1BA01AFF1BA01AFF0E9A
      0EFF0E9A0EFF0E9A0EFF2FA52FFF002800FF004B00FF88AF6DFF6B9D4AFF6B9D
      4AFF5F943BFFF5F6F5FFF7F7F7FFF5F6F5FFF5F6F5FFF4F4F4FFEEEEF2FF2E28
      D7FF2E28D7FF2E28D7FF4A46DCFF0000AEFF0000D6FF726EEBFF4C4BE9FF4C4B
      E9FF4343E6FF4343E6FF3A3AE3FF3232E2FF3232E2FF2B2BE0FF2323DEFF2323
      DEFF1B1BDBFF1B1BDBFF3A3AE3FF0000B6FF0000FFFF6066FDFF4648FBFF3E9E
      FAFF36DAF9FF36DAF9FF29D3F5FF29D3F5FF29D3F5FF18CEF3FF18CEF3FF0CCB
      F1FF0CCBF1FF0CCBF1FF29D3F5FF0091E3FF005100FF41714EFF16331DFF0814
      0BFF000000FF000000FF061309FF0E2E17FF175A29FF24893FFF168935FF1689
      35FF168935FF168935FF30964BFF000303FF004B00FF8DB472FF73A254FF6B9D
      4AFF639741FFF7F8F6FFE5E7E6FF98AC9CFF98AC9CFFDEE4DEFFF0F0F3FF342E
      D9FF342ED9FF2E28D7FF4A46DCFF0000AEFFE5E7FBFFF1F1FBFFF1F1FBFFF1F1
      FBFFEEEEF9FFEEEEF9FFEDEDF7FFEAEAF8FFE8E8F6FFE6E6F4FFE6E6F4FFE4E4
      F3FFE2E2F2FFE2E2F2FFE6E6F4FFC3C3DFFF0000FFFF657AFCFF4648FBFF4755
      FCFFC2D5F9FFCDE3E7FFCDE3E7FFCDE3E7FFCDE3E7FFC7DCE3FFC7DCE3FFC7DC
      E3FFC0D9E0FFC0D9E0FFC7DCE3FF7EAFBBFF00009EFF14142DFF000000FF0000
      00FF000000FF000000FF000000FF000000FF08082DFF1A1A99FF1F1FE6FF2121
      F5FF1717F3FF1717F3FF3535F6FF0000E5FF004B00FF8DB472FF73A254FF73A2
      54FF6B9D4AFFF7F8F6FF9FB2A3FFACB99FFF98AC9CFF98AC9CFFF2F2F5FF3A34
      DBFF3A34DBFF342ED9FF524EDFFF0000B8FF0000C9FF726EEBFF564CE0FF564C
      E0FF4C44DEFF4C44DEFF4238DBFF4238DBFF3232E2FF3A3AE3FF3232E2FF2B2B
      E0FF2B2BE0FF2323DEFF4343E6FF0000B6FF0004F0FF737D91FF5DC7F6FF7188
      DAFF4648FBFF4540BFFF453B4DFF3E3432FF3E3432FF332826FF332826FF2A20
      1EFF231816FF231816FF3E3432FF000000FF00004EFF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF0E0E4CFF2222C8FF2121
      F5FF2121F5FF1717F3FF3C3BF3FF0000E5FF055A00FF92B879FF79A65BFF73A2
      54FF6B9D4AFFF8F9F7FFD8E3E3FF93B0C0FF697C8DFFD8E3E3FFF2F2F5FF413C
      DEFF3A34DBFF3A34DBFF524EDFFF0000B8FFC50000FFD09093FF86D1DDFF82CF
      DCFFDC4A4BFFDC4646FFD94040FFD93A3AFFEEE5EEFFE8E8F7FFE8E8F6FFE6E6
      F4FFE4E4F3FFE4E4F3FFE6E6F4FFC6C6E6FF0004F0FF6DCCEDFF6D716BFF5DC7
      F6FF4755FCFF4648FBFF4540BFFF3A373AFF3A373AFF312B31FF272727FF2727
      27FF1C1C1CFF1C1C1CFF3A373AFF000000FF00001FFF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF06061EFF1D1D9AFF2A2A
      F6FF2121F5FF2121F5FF3C3BF3FF0000E5FF055A00FF92B879FF7CA95FFF79A6
      5BFF73A254FFFAFBF9FFC4D5DFFF93B0C0FF3E5E83FFAEC5D1FFF4F4F8FF413C
      DEFF413CDEFF413CDEFF5A57E1FF0000B8FF98060EFF9AE8F3FF7CE5F3FFC274
      76FF86D1DDFF82CFDCFFC27476FFD94040FF4C44DEFF4343E6FF4343E6FF3A3A
      E3FF3A3AE3FF3232E2FF5352E5FF0000B6FF0004F0FF7188DAFF57C5EEFF5968
      EBFF5657FBFF5850CFFF534B69FF4D444DFF4D444DFF453B4DFF3A373AFF3A37
      3AFF312B31FF312B31FF4D444DFF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF1A1B43FF3837
      C6FF282842FF282842FF43435AFF000000FF0C5F00FF97BB80FF81AB63FF7CA9
      5FFF73A254FFFAFBF9FFFCFCFCFFBCD0DAFFBACED8FFF5F6F5FFF4F4F8FF4843
      E0FF4843E0FF413CDEFF5A57E1FF0000B8FF4A7687FF9AE8F3FFB69AA0FF86D1
      DDFF7CE5F3FF7DDAE8FF82CFDCFFDC4646FFEEE7F1FFEAEAF8FFE8E8F7FFE8E8
      F7FFE6E6F4FFE6E6F4FFE8E8F6FFC6C6E6FF0000FFFF7979FFFF6066FDFF5657
      FBFFC7DCE3FFE7F0E7FFE7F0E7FFE7F0E7FFE7F0E7FFE3EBE3FFE3EBE3FFE3EB
      E3FFDFE8DFFFDFE8DFFFE3EBE3FFB9CDB9FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF1C1B62FF3636
      60FF2E2E2EFF2E2E2EFF4B4B4BFF000000FF0C5F00FF97BB80FF84AD67FF81AB
      63FF79A65BFFFAFBF9FFFDFDFDFFFCFCFCFFFCFCFBFFFAFBF9FFF7F6FAFF4E49
      E2FF4E49E2FF4843E0FF635FE4FF0000B8FF4A7687FF9AE8F3FFAAB1B8FF89DB
      E6FF7CE5F3FF7CE5F3FF86D1DDFFDC4A4BFF564CE0FF5352E5FF4C4BE9FF4343
      E6FF4343E6FF3A3AE3FF5352E5FF0000C9FF0000FFFF7979FFFF5968EBFF5BA0
      8FFF58C158FF53BA53FF53BA53FF48B448FF48B448FF48B448FF33AC33FF33AC
      33FF33AC33FF33AC33FF48B448FF005300FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF0A0A19FF39395FFF5959
      59FF595959FF595959FF4B4B4BFF000000FF0C5F00FF97BB80FF97BB80FF97BB
      80FF92B879FFFCFCFBFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFF7F6FAFF6D69
      E7FF6D69E7FF6D69E7FF635FE4FF0000B8FF98060EFF9AE8F3FF9AE8F3FFC3AD
      B1FFA5D4DDFF9EDAE3FFD09093FFE16C6CFFF5EFF5FFF1F1FBFFF1F1FBFFF1F1
      FBFFEEEEF9FFEEEEF9FFEDEDF7FFD3D3EBFF0000FFFF7188DAFF7ABE91FF74C9
      74FF74C974FF74C974FF74C974FF68C268FF68C268FF68C268FF5DBD5EFF5DBD
      5EFF53BA53FF53BA53FF48B448FF005300FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0C5F00FF0C5F00FF0C5F00FF0C5F
      00FF0C5F00FFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFE5E7E6FFDFDFE3FF0000
      C9FF0000C9FF0000C9FF0000C9FF0000C9FFC50000FF98060EFF24ADC3FF24AD
      C3FF98060EFFC50000FFC50000FFC50000FF0000C9FF0000D6FF0000D6FF0000
      D6FF0000D6FF0000C9FF0000C9FF0000C9FF002E8DFF008400FF008400FF0084
      00FF008400FF008400FF008400FF008400FF008400FF006900FF006900FF0069
      00FF006900FF006900FF005300FF006900FF620000FF4C0000FF4C0000FF4C00
      00FF4C0000FF4C0000FF2E0000FF2E0000FF2E0000FF2E0000FF2E0000FF1500
      00FF150000FF150000FF150000FF150000FFEBEBEBFFE6E6E6FFE6E6E6FFE2E2
      E2FFE2E2E2FFDCDCDCFFDCDCDCFFC9C9D4FF0000E6FF0000E6FF0000E2FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFF005200FF005200FF005200FF0052
      00FF005200FF005200FF003000FF003000FF003000FF003000FF003000FF0030
      00FF001500FF001500FF001500FF001500FF0000DCFF0000DCFF0000D3FF0000
      D3FF0000D3FF0000D3FF0000C7FF0000C7FF0000C7FF0000C7FF0000BDFF0000
      BDFF0000BDFF0000BDFF0000BDFF0000BDFF620000FFB97366FFB97366FFB66E
      61FFB56A5BFFB16456FFAE5F50FFAD5B4CFFA95647FFA95647FFA65142FFA04A
      40FFA04A40FFA04A40FF9F4536FF150000FFEDEDEDFFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFEDEDF8FF4C4CF7FF3D3DF5FF3939F5FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF005200FF5FBA5EFF5FBA5EFF53B4
      53FF53B453FF53B453FF45AD45FF45AD45FF45AD45FF38A638FF38A638FF38A6
      38FF2EA02EFF2EA02EFF2EA02EFF001500FF0000DCFF6262F2FF5C5DF2FF5556
      F0FF5556F0FF5051EEFF4A4BEDFF4343EDFF4343EDFF3B3BEAFF3B3BEAFF3333
      E8FF3333E8FF2C2FE2FF2C2FE2FF0000BDFF620000FFBC7A70FFAD5B4CFFA956
      47FFA65142FFA44C3CFF9F4536FF9F4536FF9A3D2EFF973829FF973829FF922E
      23FF922E23FF8E291DFF9F4536FF150000FFEDEDEDFFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFEAEAF6FF2F2FF7FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000DFFF00B960FF65E0B9FF43D9A8FF3CD6
      A4FF3CD6A4FF33D39FFF2BD19BFF28CE98FF28CE98FF1BCB93FF1BCB93FF12C8
      8EFF0CC68AFF0CC68AFF28CE98FF008B0EFF0000E3FF6262F2FF4343EDFF4046
      E7FF3A42E4FF353BE3FF3034E4FF2C2FE2FF2227DFFF2227DFFF1A21DDFF1318
      DCFF1318DCFF0000E3FF2C2FE2FF0000BDFF620000FFBC7A70FFAE5F50FFAD5B
      4CFFA95647FFA65142FFA44C3CFF9F4536FF9F4536FF9A3D2EFF9A3D2EFF538E
      9DFF538E9DFF922E23FFA04A40FF150000FFEFEFEFFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFECEBF7FF3535F5FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000DFFF00FCFCFF6CFDFDFF4AFCFBFF41FB
      FBFF41FBFBFF39F9F9FF34F8F8FF2CF7F7FF2CF7F7FF23F5F5FF1BF4F4FF1BF4
      F4FF12F2F2FF12F2F2FF33F4F4FF00E1E1FF0000E3FF6B6BF4FF4A4BEDFF71E2
      73FF6CE46BFF6CE46BFF61DF62FF87E389FFB4EDB4FF59DA5AFF53D855FF50D9
      50FF4BD44EFF1318DCFF3333E8FF0000BDFF620000FFBE8075FFB16456FFAE5F
      50FFAD5B4CFFA95647FFA65142FFA44C3CFFA44C3CFF9F4536FF5F93A4FF439E
      C5FF538E9DFF538E9DFFA24F47FF150000FFEFEFEFFFFDFDFDFFFCFCFCFFFBFC
      FBFFFBFBFBFFFAFAFAFFF9F9F9FFEDEDF8FF3939F5FF2A2AF6FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3535F5FF0000E2FF00FCFCFF6CFDFDFF4AFCFBFF4AFC
      FBFF41FBFBFF41FBFBFF39F9F9FF34F8F8FF2CF7F7FF2CF7F7FF23F5F5FF1BF4
      F4FF1BF4F4FF12F2F2FF33F4F4FF00E1E1FF0000E3FF6B6BF4FF5051EEFF76E5
      77FF74E871FF6CE46BFF8DEA8BFFD5F4D4FFCDF1CBFF99EB97FF5ADE57FF56E0
      50FF50D950FF1318DCFF3333E8FF0000B1FF662A68FFB98D9AFFB56A5BFFA16F
      8BFF9D6B8BFFAD5B4CFFBC7A70FFA77E9BFFA2534DFFA04A40FFDC886AFFC29A
      7EFF72A693FFD88160FFA2534DFF2E0000FFF1F1F1FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFEFEFFAFF4141F9FF2F2FF7FF2A2AF6FF2424
      F5FF1E1EF4FF1818F3FF3939F5FF0000E6FF4A1800FFB09D90FF9C8374FF9C83
      74FF9C8374FF917666FF917666FF917666FF876957FF876957FF876957FF8769
      57FF7C5D4BFF7C5D4BFF917666FF001500FF0000E7FF7372F6FF5556F0FF7AE6
      7CFF77E974FF6CE46BFFB4EDB4FFD5F4D4FF5DDF5DFF61DF62FF5EDD5FFF5ADE
      57FF54D757FF1B1EE0FF3B3BEAFF0000A2FFAB6664FFCFC7E3FFB98D9AFF9884
      C4FF9884C4FFD3A79DFFB7ABD8FFA77E9BFFA2534DFFA24F47FFDF8D70FFD29E
      86FF72A693FFD88160FFA75A54FF2E0000FFF2F2F3FFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFCFEFFFCFCFCFFFBFBFBFFEFEFFAFF4545F8FF3536F8FF2F2FF7FF2A2A
      F6FF2424F5FF1E1EF4FF3D3DF5FF0000E6FF870000FFCB8B77FFC17055FFC170
      55FFBB6951FFB96348FFB96348FFB35C42FFB45738FFB45738FFAC4C2EFFAC4C
      2EFFA64325FFA64325FFB35C42FF430000FF0000E7FF7372F6FF585CEDFF7DE7
      80FF7DEC79FF74E871FF8DEA8BFFDAF6DAFFD5F4D4FFA3ECA2FF62E162FF62E5
      5DFF59DA5AFF2227DFFF3B3BEAFF00007BFF471C84FFBAB2E1FF9EA0EEFF7676
      E3FF8882DAFF9EA0EEFF8882DAFF9474ABFFA75A54FFA2534DFFE19275FFCCA3
      8EFFC5A191FFDC886AFFAD5B4CFF2E0000FFF5F5F5FFFDFCFEFFC8C8C9FFFEFE
      FEFFFDFDFDFFFDFDFDFFFCFCFCFFF0F0FBFF4A4AF9FF3C3BF9FF3536F8FF2F2F
      F7FF2A2AF6FF2424F5FF4545F8FF0000E6FF870000FFCB8B77FFBD6F59FFBD6F
      59FFBB6951FFBB6951FFB96348FFB35C42FFB35C42FFAD5239FFAD5239FFAC4C
      2EFFA64325FFA64325FFB35C42FF430000FF0000EAFF7979F7FF5C5DF2FF83E9
      83FF7DEC79FF7DEC79FF74E871FF99EB97FFC1F3BFFF6CE46BFF67E464FF62E5
      5DFF5EDD5FFF292BE5FF4343EDFF000063FF1614CDFF9493E6FF7D81EAFF7676
      E3FF6667E2FF7676E3FF7676E3FF766BCDFFAB6664FFA75A54FFE19275FFE192
      75FFDF8D70FFDC886AFFAE5F50FF2E0000FFF2F2F3FFD3D3D5FFB8B8BDFFC9C9
      D4FFFEFEFEFFFDFDFDFFFDFDFDFFF2F2FCFF5252FAFF4141F9FF3C3BF9FF3536
      F8FF2F2FF7FF2A2AF6FF4A4AF9FF0000ECFF000087FF887AC9FF6857BBFF6857
      BBFF6857BBFF6857BBFF6857BBFF5947B2FF5947B2FF5947B2FF4833A9FF4833
      A9FF4833A9FF4833A9FF5947B2FF000048FF0000EAFF7979F7FF5C5DF2FF5C63
      ECFF5C63ECFF585CEDFF535AE9FF4B53E7FF4B53E7FF434AE5FF4046E7FF3A42
      E4FF353BE3FF292BE5FF4A4BEDFF000063FF83242EFFC4B8DBFFDED3DFFFB7AB
      D8FFA99ED8FFC4B8DBFFCFC7E3FFD3A79DFFBE8075FFBC7A70FFB97366FFB66E
      61FFAB6664FFAB6664FFB16456FF2E0000FFF5F5F5FFF9F9FAFFD3D3D5FFFDFD
      FDFFFEFEFEFFFEFEFEFFFDFDFDFFF5F5FDFF7171FCFF6262FCFF6262FCFF5B5B
      FAFF5656F9FF5252FAFF4C4CF7FF0000ECFF0000CAFF7979E8FF7979E8FF7979
      E8FF7979E8FF706FE6FF706FE6FF706FE6FF6666E3FF6666E3FF5D5DE1FF5D5D
      E1FF5252DDFF5252DDFF5252DDFF0000AAFF0000EAFF7979F7FF7979F7FF7979
      F7FF7979F7FF7372F6FF7372F6FF6B6BF4FF6B6BF4FF6262F2FF5C5DF2FF5C5D
      F2FF5556F0FF5051EEFF4A4BEDFF000084FF766BCDFFA36C83FF8C0C00FF471C
      84FF471C84FF8C0C00FF662A68FF745CB1FF620000FF620000FF620000FF6200
      00FF4C0000FF4C0000FF4C0000FF4C0000FFF1F1F1FFEFEFF1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF1F1F1FFF1F1F1FFDDDDEFFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFF0000CAFF0000C3FF0000C3FF0000
      C3FF0000C3FF0000C3FF0000B8FF0000B8FF0000B8FF0000B8FF0000B8FF0000
      B8FF0000AAFF0000AAFF0000AAFF0000AAFF0000EAFF0000EAFF0000E7FF0000
      E7FF0000E7FF0000E3FF0000E3FF0000E3FF0000E3FF0000DCFF0000DCFF0000
      DCFF0000DCFF0000D3FF0000D3FF0000ABFF007300FF006500FF006500FF0058
      00FF005800FF005800FF004800FF004800FF003900FF003900FF003900FF0039
      00FF002B00FF002B00FF002B00FF003900FF510000FF510000FF510000FF5100
      00FF510000FF510000FF330000FF330000FF330000FF330000FF330000FF1F00
      00FF1F0000FF1F0000FF1F0000FF1F0000FF670000FF580000FF580000FF6700
      00FF580000FF440000FF440000FFE9E9E9FFE6E6E6FF310000FF310000FF3100
      00FF310000FF310000FF170000FF170000FF007800FF006800FF006800FF005A
      00FF005A00FF005A00FF004900FF004900FF004900FF003C00FF003C00FF0032
      00FF003200FF003200FF002600FF003C00FF007300FF60BE60FF5BBB5BFF57B9
      57FF52B954FF51B551FF49B149FF49B149FF43AE43FF3CAB3CFF39AA39FF33A9
      35FF2FA530FF2FA530FF2BA42AFF002B00FF6B0F00FFBC967AFFBC9275FFBA8E
      71FFB88C6EFFB6896BFFB38565FFC8C3B3FFC8C3B3FFB38A5FFFAA7858FFA975
      52FFA67250FFA46F4CFFA16B48FF1F0000FF670000FFBE8C76FFE2D0C8FFF2EA
      E6FFEDE6E1FFC59885FFB1775EFFF7F7F7FFF6F6F6FFAC6A4FFFA9694EFFDDCB
      C3FFE8DEDAFFE3D6D0FFA25D41FF170000FF006800FF61BE61FF5CBC5CFF58B9
      57FF53B853FF50B550FF49B349FF43AE43FF43AE43FF3DAE3DFF39AA39FF34A9
      34FF32A532FF2CA42CFF2CA42CFF002600FF007300FF65C065FF44B144FF3EAE
      3EFF39AA39FF33A935FF97CF97FFB6DDB6FFE1EDE1FF97CF97FF65BC65FF1399
      13FF0E970FFF0A950AFF2FA530FF002B00FF6B0F00FFC2977CFFB08161FFB57B
      58FFAA7858FF9D9F6AFF98E4F9FFBDBBAAFFBDBBAAFF8DD6F2FF8CB9C5FF9A60
      3AFF995933FF995933FFA46F4CFF1F0000FF720100FFC18F78FFB1755CFFCDA5
      95FFE5D4CDFFB1755CFFA76447FFF6F6F6FFF5F5F4FF9E5334FF9E5334FF9E53
      34FFC49D8CFFD6BDB3FFA25D41FF170000FF007800FF67C267FF42B242FF3DAE
      3DFF3AAE3AFF34A934FF2D992DFF259325FF259325FF1E8B1EFF189B18FF139A
      13FF0D960DFF0D960DFF2CA42CFF003200FF007C00FF69C269FF48B548FF44B1
      44FF3EAE3EFF44B144FF4EB64EFF47B045FF3CAB3CFF43AE43FF2FA530FF199C
      19FF139913FF0E970FFF2FA530FF002B00FF6B0F00FFC29C84FFB38565FFB081
      61FFBA9B83FF90D0ECFF90D0ECFFBDBBAAFFBDBBAAFFA6C1C3FF7EDBF4FF8894
      82FF9A603AFF995933FFA67250FF1F0000FF720100FFC18F78FFB98168FFE9D8
      D0FFE0CAC2FFA86548FFA76447FFF7F7F7FFF6F6F6FF9E5334FF9E5334FFA969
      4EFFDDCBC3FFB47A63FFA25D41FF170000FF007800FF67C267FF49B549FF42B2
      42FF3DAE3DFF389738FF33C982FF2CF6EFFF2CF6EFFF23C880FF1E8B1EFF189B
      18FF139A13FF0D960DFF32A532FF003200FF007C00FF6BC56FFF4EB64EFF48B5
      48FF44B144FFD4EAD4FFF9F9F9FFEEF4EEFFD4EAD4FFF4F6F4FFDAECDAFF97CF
      97FF199C19FF139913FF33A935FF003900FF762000FFC29C84FFB6896BFFB385
      65FFB1CFD3FFA6F0FAFFA97552FFBC967AFFD8D5CCFFB57B58FF88A489FF8DD6
      F2FF9A603AFF9A603AFFA97552FF1F0000FFCFAC9EFFE9D8D0FFF0E5E0FFF2EA
      E6FFE5D2CAFFDEC8BEFFDDC6BDFFF9F9F9FFF7F7F7FFDAC1B6FFD6BDB3FFE6D9
      D5FFE8DEDAFFD6BDB3FFDAC2B9FFA5715AFF008400FF70C46FFF4EB64EFF49B5
      49FF44A144FF2FECD8FF39F9F9FF31CE8EFF31CE8EFF29F6F6FF2FECD8FF1E8B
      1EFF189B18FF139A13FF34A934FF003C00FF008300FF71C570FF52B954FF4EB6
      4EFF52D2B6FF88CB86FFACDAABFFDAECDAFFF4F6F4FFB6DDB6FFACDAABFF2BA4
      2AFF26C09CFF199C19FF39AA39FF003900FF762000FFC8A58EFFB88C6EFFB689
      6BFFA2DBE3FFBAD4CFFFC2977CFFC8A58EFFF8F8F8FFC29C84FFB66A46FF86E4
      F4FF9E6641FF9A603AFFAA7858FF330000FFFDFDFDFFFDFDFDFFFDFDFDFFFAF7
      F7FFFAF7F7FFFBFBFBFFFAFAFAFFF9F9F9FFF9F9F9FFF7F7F7FFF6F6F6FFF5F5
      F4FFF2EEECFFF2EEECFFF5F5F4FFE6E6E6FF008400FF70C46FFF53B853FF4CAB
      4CFF4AC879FF45F7EFFF3D9D3DFF389738FF389738FF2F8D2FFF2FECD8FF24C0
      6AFF1E941EFF189B18FF39AA39FF003C00FF008900FF75C875FF58BC57FF52B9
      54FF52B954FF4BBC5DFF44B144FFACDAABFFF4F6F4FF47B045FF2FAE40FF33A9
      35FF25A225FF1F9F1FFF3EAE3EFF003900FF812C00FFC8A58EFFBA8E71FFB88C
      6EFFA2DBE3FF90CDD4FFB66A46FFC2977CFFE2C5B8FF995933FFA3A17CFF87DF
      EFFFA16B48FF9E6641FFAA7858FF330000FFCFAC9EFFE9D8D0FFDAC1B6FFDEC5
      BAFFDEC5BAFFE2D0C8FFDEC8BEFFFAFAFAFFF9F9F9FFDAC2B9FFDAC1B6FFCFAC
      9EFFD4B4A6FFCFAC9EFFDBC5BCFFA5715AFF008400FF75C875FF57BC57FF53AF
      53FF4FDDADFF49B549FF43AE43FF42B242FF3AAE3AFF32A532FF32A532FF2AD3
      9DFF259325FF22A122FF3DAE3DFF003C00FF008900FF79C979FF5CBE5CFF58BC
      57FF52B954FF52D2B6FF4AB956FF69C269FF7DC97EFF3AB146FF3AB146FF36C7
      A7FF2BA42AFF25A225FF43AE43FF004800FF812C00FFC8A58EFFBC9275FFBA8E
      71FFBDBBAAFFA4EDFDFFA6B59EFFBA9B83FFC8C3B3FFB4866CFF81C8E5FFA2DB
      E3FFA46F4CFFA16B48FFB08161FF330000FF7C1100FFC59885FFE5D2CAFFF2EA
      E6FFF2EEECFFBD8871FFB07057FFFBFBFBFFFAFAFAFFA9694EFFA76447FFE2D0
      C8FFE8DBD6FFE2D0C8FFB1775EFF310000FF008B00FF79C979FF5CBE5CFF58B9
      57FF53C062FF50B550FF4CAB4CFF44FBFAFF44FBFAFF3D9D3DFF34A934FF30B0
      42FF2CA42CFF22A122FF43AE43FF004900FF008900FF79C979FF5CBE5CFF5CBE
      5CFF58BB58FF52B954FF50BE61FF4BBC5DFF4CD4BEFF41B550FF3AB146FF33A9
      35FF33A935FF2BA42AFF49B149FF004800FF812C00FFC8A58EFFBC967AFFBC92
      75FFB7A28FFFAAD4CDFF8CB9C5FF99BFE6FFAABFF4FF98E4F9FF90CDD4FFA68E
      76FFA67250FFA46F4CFFB38565FF330000FF841E00FFC99D8AFFC18F78FFDEC5
      BAFFF2EAE6FFBD8871FFB47A63FFFCFCFCFFFBFBFBFFB07057FFAC6A4FFFB070
      57FFDAC1B6FFE3D6D0FFB1755CFF440000FF008B00FF79C979FF5CBE5CFF5CBE
      5CFF58B957FF53B853FF50B550FF49D9A3FF49D9A3FF43AE43FF3DAE3DFF34A9
      34FF34A934FF2CA42CFF49B349FF004900FF008300FF79C979FF79C979FF79C9
      79FF75C875FF75C875FF71C570FF6BC56FFF6BC56FFF65BC65FF60BE60FF5BBB
      5BFF57B957FF51B551FF4EB64EFF004800FF812C00FFC8A58EFFC8A58EFFC8A5
      8EFFC8A58EFFC3B2A1FFBECCC0FFB6E8F8FFB6E8F8FFBBDCDDFFB9A694FFBC92
      75FFBA8E71FFB88C6EFFB4866CFF510000FF841E00FFC99D8AFFCDA595FFEFE2
      DDFFECDDD5FFC49581FFC49581FFFDFDFDFFFCFCFCFFBE8C76FFBD8871FFBE8C
      76FFE8DBD6FFDEC8BEFFB1775EFF440000FF008400FF79C979FF79C979FF79C9
      79FF75C875FF75C875FF70C46FFF6ABB6AFF6ABB6AFF61BE61FF61BE61FF5CBC
      5CFF56B957FF53B853FF4EB64EFF004900FF009100FF008900FF008900FF0089
      00FF008900FF008300FF008300FF007C00FF007300FF007300FF007300FF0065
      00FF006500FF006500FF005800FF006500FF812C00FF812C00FF812C00FF812C
      00FF812C00FF762000FF762000FF762000FF6B0F00FF6B0F00FF6B0F00FF5100
      00FF510000FF510000FF510000FF510000FF841E00FF841E00FFC49581FFD4B4
      A6FF9E5334FF7C1100FF7C1100FFFDFDFDFFFBFBFBFF720100FF670000FFB070
      57FFC49D8CFF670000FF580000FF580000FF009500FF008B00FF008B00FF008B
      00FF008B00FF008400FF008400FF008400FF007800FF007800FF007800FF0068
      00FF006800FF006800FF005A00FF006800FF00FBFBFF004CF5FF0000F4FF0000
      F4FF0000E9FF0000E9FF0000E9FF00C6E8FF00C6E8FF0000E9FF0000DFFF0000
      DFFF0000DFFF0000DFFF0000DFFF00CFCFFF004B00FF001300FF000000FF0000
      00FF000000FF000000FF000000FF000000FF002B2BFF009191FF0099D5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000F4FF0000F4FF0000F4FF0000
      EDFF0000EDFF0000EDFF0000EAFF0000EAFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000F3FF0000F3FF0000F3FF0000
      EDFF0000EDFFD60000FFE90000FFE90000FFE90000FFE90000FFD60000FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF004CF5FF61F0FBFF5CD3FAFF576C
      FBFF5558FCFF4B52FBFF4646F9FF45CCF8FF45CCF8FF3638F6FF3638F6FF3638
      F6FF3346F4FF2BBCF5FF2BE3F2FF0000DFFF006000FF3B763BFF1C3A1CFF0A16
      0AFF000000FF000000FF081E1EFF144C4CFF299A9AFF38E6E6FF38D8F4FF3636
      F6FF3030F4FF3030F4FF2B2BF5FF0000DDFF0000F4FF6060FBFF5C5CFAFF5655
      F9FF5655F9FF5151F8FF4A4AF7FF4444F7FF4242F9FF3C3BF4FF3535F4FF3535
      F4FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF0000F9FF6170FBFF5A67FBFF5A67
      FBFF545AF9FFF1515CFFF74A4AFFFA4646FFF94040FFF53C3EFFF2373CFF3535
      F5FF3030F4FF3030F4FF2B2BF5FF0000DDFF0000F4FF6577FCFF41AFFAFF37D8
      F9FF3A78F9FF3638F6FF262BF6FF25AAF6FF25AAF6FF1717F3FF1717F3FF1259
      F2FF0DCAF1FF1199F2FF3346F4FF0000DFFF007900FF62B662FF379037FF266B
      27FF1C541CFF1B7974FF1C9A9AFF21C8C8FF21E6E6FF1DF4F4FF1BD4F4FF1212
      F2FF0C0CF1FF0C0CF1FF3030F4FF0000E0FF0000FAFF6565FCFF4242F9FF3D3D
      FAFF3939F9FF3535F8FF2C2CF7FF2929F6FF2424F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF0000F9FF67DAFCFF43B2FAFF43D8
      FBFF3C5CFAFFED3743FFF62E2FFFF62929FFF52323FFF41D1DFFEE181DFF1212
      F2FF0C0CF1FF0C0CF1FF3030F4FF0000E0FF0000FFFF6464FCFF4646F9FF4665
      F9FF41AFFAFF3289F8FF3638F6FF2975F6FF2975F6FF262BF6FF2975F6FF1199
      F2FF1340F2FF1717F3FF262BF6FF0000DFFF007900FF69C269FF49B449FF44B1
      44FF3EAE3FFF36F3E9FF34F8F8FF2EF7F7FF29F6F6FF23F5F5FF1BD4F4FF1B1B
      F3FF1212F2FF1212F2FF3030F4FF0000E0FF0000FAFF6969FCFF4747FBFF4242
      F9FF3D3DFAFF3939F9FF3535F8FF2F2FF7FF2929F6FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000E0FF0000F9FF67DAFCFF4CD1FCFF43D8
      FBFF3C5CFAFFED3743FFF83434FFF62E2FFFF62929FFF52323FFEF1E23FF1B1B
      F3FF1212F2FF1212F2FF3030F4FF0000E0FF0036FDFF7592FEFF4E70FCFF4B52
      FBFF4B52FBFF3A78F9FF3A78F9FF38BEF9FF2BBCF5FF2669F6FF2669F6FF1B2C
      F4FF1B2CF4FF1340F2FF386CF6FF0000DFFF007900FF72C671FF50B650FF49B4
      49FF44B144FF42F5ECFF3AF9F9FF34F8F8FF2EF7F7FF29F6F6FF27D8F6FF1B1B
      F3FF1B1BF3FF1212F2FF3636F6FF0000E0FF0000EDFF736EF6FF534CF2FF534C
      F2FF4942F1FF4942F1FF3C3BF4FF3834F2FF2F2FF7FF2929F6FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E5FF0000FDFF70DDFEFF4CD1FCFF43D8
      FBFF4767FCFFEE404CFFF93A3AFFF83434FFF62E2FFFF62929FFF02329FF1B1B
      F3FF1B1BF3FF1212F2FF3535F5FF0000E6FF00FBFBFF76FAFFFF52EBFCFF52EB
      FCFF45CCF8FF4296FBFF4296FBFF38F7F7FF38F7F7FF3289F8FF3289F8FF2BBC
      F5FF1ED8F4FF19E6F3FF38F7F7FF00EAE9FF008800FF72C671FF53B853FF50B6
      50FF49B449FF42F5ECFF40FAFAFF3AF9F9FF34F8F8FF2FF7F7FF27D8F6FF2323
      F5FF1B1BF3FF1B1BF3FF3C3CF5FF0000E8FFB70000FFDE7175FFD7575CFFDA64
      6BFFD6565DFFD4464BFFD34046FFCE3A44FF3535F8FF2F2FF7FF2929F6FF2424
      F5FF1E1EF4FF1818F3FF3C3BF4FF0000E5FF0000FDFF70DDFEFF55ACFEFF4CD1
      FCFF4767FCFFF14854FFF94040FFF93A3AFFF83434FFF62E2FFFF12A2FFF2323
      F5FF1B1BF3FF1B1BF3FF3C3CF5FF0000E6FF0036FDFF7592FEFF576CFBFF5558
      FCFF5558FCFF4686FBFF4686FBFF46BDFBFF38BEF9FF3A78F9FF2975F6FF2A37
      F6FF262BF6FF1F3FF4FF386CF6FF0000E9FF008800FF76C876FF57BC57FF53B8
      53FF50B650FF4DF5ECFF46FBFBFF40FAFAFF3AF9F9FF34F8F8FF2FDAF7FF2B2B
      F5FF2323F5FF1B1BF3FF3C3CF5FF0000E8FFC70000FFE47877FFE68281FFF0B5
      B4FFEDABA9FFDE5754FFDD4545FFD34046FF3B3BF9FF3535F8FF2F2FF7FF2929
      F6FF2424F5FF1E1EF4FF3C3BF4FF0000E5FF0000FDFF7587FEFF55ACFEFF5383
      FDFF5354FBFFF14854FFFA4646FFF94040FFF93A3AFFF83434FFF62E2FFF2B2B
      F5FF2323F5FF1B1BF3FF3C3CF5FF0000E6FF0000FFFF7474FEFF5558FCFF587E
      FEFF53BFFDFF5097FDFF4B52FBFF4686FBFF4686FBFF3346F4FF3289F8FF2EAE
      F7FF2A5CF6FF262BF6FF4646F9FF0000E9FF008800FF79C979FF5BBD5BFF58BA
      57FF53B853FF52F8EFFF4BFCFCFF46FBFBFF40FAFAFF3AF9F9FF39DDF9FF3030
      F4FF2B2BF5FF2323F5FF4848F7FF0000E8FFC30000FFE68281FFF1BABAFFF8DD
      DDFFF8DDDDFFEEB0AFFFDB4A4AFFD4464BFF4242F9FF3B3BF9FF3535F8FF2F2F
      F7FF2929F6FF2424F5FF4444F7FF0000E5FF0000FFFF78C8FEFF5BDEFEFF5BC9
      FEFF5354FBFFF1515CFFFC4B4BFFFA4646FFF94040FFF93A3AFFF2373CFF3030
      F4FF2B2BF5FF2323F5FF4848F7FF0000E6FF0000FFFF7592FEFF58C6FBFF52EB
      FCFF5888FEFF4B52FBFF4B52FBFF46BDFBFF46BDFBFF4646F9FF3638F6FF386C
      F6FF37D8F9FF2EAEF7FF4665F9FF0000E9FF008800FF79C979FF60BF5FFF5BBD
      5BFF58BA57FF52F8EFFF50FDFDFF4BFCFCFF46FBFBFF40FAFAFF39DDF9FF3636
      F6FF3030F4FF2B2BF5FF4848F7FF0000E8FFC30000FFE68281FFF1BABAFFF8DD
      DDFFF8DDDDFFEEB0AFFFDD5050FFD74B50FF4747FBFF4242F9FF3B3BF9FF3535
      F8FF2F2FF7FF2C2CF7FF4A4AF7FF0000EAFF0000FFFF787AFFFF5BC9FEFF5A67
      FBFF5A5AFCFFF1515CFFFD5050FFFC4B4BFFFA4646FFF94040FFF53C3EFF3535
      F5FF3030F4FF2B2BF5FF4848F7FF0000E6FF006EFFFF76FAFFFF6FDCFDFF7592
      FEFF7474FEFF7474FEFF7474FEFF6FDCFDFF6FDCFDFF6464FCFF6464FCFF5558
      FCFF576CFBFF58C6FBFF52EBFCFF0036EDFF008800FF79C979FF79C979FF79C9
      79FF76C876FF72FCF8FF72FCF8FF68FCFCFF68FCFCFF68FCFCFF5FE4FBFF5656
      F9FF5656F9FF5656F9FF4848F7FF0000E8FFC30000FFE47C7CFFEA9594FFF2C1
      C1FFF1BABAFFE47877FFE46F6FFFDF6C70FF6969FCFF6565FCFF6060FBFF5C5C
      FAFF5655F9FF5151F8FF4A4AF7FF0000EAFF0000FFFF787AFFFF7AB5FFFF787A
      FFFF787AFFFFFA7276FFFA7276FFFC6868FFFC6868FFFC6868FFF75F64FF5A5A
      FCFF5354FBFF5354FBFF4848F7FF0000EDFF00FBFBFF006EFFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF00E3FCFF00E3FCFF0000F4FF0000F4FF0000
      F4FF0000F4FF0000F4FF0036EDFF00EAE9FF008800FF008800FF008800FF0088
      00FF008800FF00F3E3FF00FCFCFF00FCFCFF00FCFCFF00FCFCFF00C5F7FF0000
      F2FF0000F2FF0000F2FF0000F2FF0000E8FFC70000FFC30000FFC30000FFC700
      00FFC30000FFC30000FFC70000FFB70000FF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000EDFF0000EDFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFFE90000FFFC0000FFFC0000FFFC0000FFFC0000FFE90000FF0000
      F3FF0000F3FF0000F3FF0000EDFF0000EDFFE3E3E3FFE3E3E3FFE3E3E3FFDADA
      DAFFDADADAFFD7D7D7FFD7D7D7FFD2D2D2FFD2D2D2FFCFCFCFFFCBCBCBFFC9CB
      C9FFC9C9C9FFC5C5C5FFC7C7C7FFC5C5C5FFB10000FF9F0000FF9F0000FF9F00
      00FF9F0000FF00C6EBFF00C6EBFF00BDE5FF00BDE5FF00BDE5FF00BDE5FF0000
      A9FF0000A1FF0000A1FF0000A1FF0000A1FFE2E2E2FFE2E2E2FFDFDFDFFFDADA
      DAFFDFDFDFFF004600FF004600FF004600FF004600FF003500FF003500FF0035
      00FF002A00FF002A00FF002A00FF003500FF6A4246FF72280EFF6C0000FF5300
      00FF530000FF2E0000FF2E0000FF2E0000FF2E0000FF2E0000FF2E0000FF1700
      00FF170000FF170000FF170000FF170000FFE3E3E3FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF3F2F2FFF2F2F2FFF2F2F2FFC5C5C5FFB10000FFDC846BFFDB7C63FFDB7C
      63FFD6775DFF57E9F8FF57E9F8FF4FE7F7FF4BE5F6FF3CE5F6FF43E3F4FF424F
      DDFF3C49DBFF3C49DBFF3745DBFF0000A1FFE6E6E6FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FF59BA58FF49B249FF49B249FF3CAC3CFF3CAC3CFF34AA34FF34AA
      34FF31A632FF2EA52EFF2BA22BFF002A00FF530000FFACA4B2FFB9C1D8FFD3B6
      A9FFC28F71FFB06F4DFFAB694AFFAB694AFFAB6946FFA46242FFA46242FFAB62
      3BFFA15A35FF9E5733FF9E5733FF170000FFE7E7E7FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFC5C5C5FFB10000FFDC846BFFD46B4FFFD266
      4AFFD06043FF3FE6F8FF30E5F6FF25D8F3FF25D8F3FF1DE3F4FF28E1F4FF2432
      D6FF1B2AD4FF1B2AD4FF3C49DBFF0000A1FFE6E6E6FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FF49B249FF2EA52EFF29A429FF23A223FF1B9E1BFF1B9E1BFF1399
      13FF0E970FFF0A950AFF2EA52EFF002A00FF6C0000FFBA8264FF9A7776FF829D
      CFFFAECDF5FFDDC4B9FFC28F71FFA15A35FF97481FFF97481FFF97481FFF9341
      17FF934117FF8F3B12FF9E5733FF170000FFEAEAEAFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFC9C9C9FFB10000FFDE8C75FFD67054FFD46B
      4FFFD2664AFF43E8F9FF3FE6F8FF42879AFF3C8397FF30E5F6FF28E1F4FF2432
      D6FF2432D6FF1B2AD4FF3C49DBFF0000A1FFEAEAEAFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFF59BA58FF34AA34FF2EA52EFF29A429FF23A223FF1B9E1BFF1B9E
      1BFF139913FF0E970FFF31A632FF003500FF6C0000FFBE8B6EFFB06F4DFFAB69
      4AFF766F8DFF6DA7F5FFBCDBF8FFE6DAD6FFD1AA98FFAB6946FF97481FFF9341
      17FF934117FF934117FFA15A35FF170000FFF1F1F1FFFCFCFCFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFCBCBCBFFB10000FFDE8C75FFD77358FFD670
      54FFD46B4FFF4AE9FAFF498C9FFFD06043FFCD593BFF3C8397FF30E5F6FF2C3A
      D8FF2432D6FF2432D6FF424FDDFF0000A9FFEAEAEAFFFDFDFDFFFCFCFCFFFBFC
      FBFFFBFBFBFF59BA58FF3CAC3CFF34AA34FF2CAF2CFF2CAF2CFF21AA21FF21AA
      21FF16A416FF16A416FF35B035FF004600FF6C0000FFC28F71FFB27352FFB06F
      4DFFB16843FF996658FF5A73B5FF6DA7F5FFBCDBF8FFF3EFEEFFDDC4B9FFBB86
      6AFF9B4F2BFF8F3B12FFA15A35FF170000FF0000FDFF8181FFFF8181FFFF7776
      FCFF7373FDFF6E6EFCFF6969FBFF6666F9FF6161FAFF5B5BF7FF5B5BF7FF5252
      F5FF5252F5FF4A4AF9FF6565F4FF0000E6FFB10000FFE2937DFFD9785EFFD874
      59FFD67054FF53ECFCFF5394A7FF45A0EEFF409EEDFF42879AFF30E5F6FF313F
      DAFF2C3AD8FF2432D6FF424FDDFF0000A9FFEAEAEAFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFF5C66E7FF3F51DBFF3A4DD7FF3246D7FF3246D7FF273CD3FF273C
      D3FF1C32D0FF1C32D0FF3A4DD7FF00009BFF6C0000FFC39176FFB47858FFB273
      52FFB06F4DFFB16843FFB06741FF766F8DFF407DE2FF6DA7F5FFD0E3F6FFF5F5
      F5FFEEE0D7FFC79B85FFB47858FF2E0000FF0000FDFF7676FEFF5858FEFF5353
      FDFF5050FDFF4A4AF9FF4646FBFF4140FAFF3B3BF9FF3536F8FF3030F7FF2A2A
      F6FF2525F5FF1F1FF4FF3E3EF5FF0000E6FFBB0800FFE2937DFFDB7C63FFD978
      5EFFD87459FF53ECFCFF5394A7FF4B57E0FF4B57E0FF498C9FFF3CE5F6FF3745
      DBFF313FDAFF2C3AD8FF4B57E0FF0000A9FFEDEDEDFFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFCFDFF605FFCFF4646FBFF4140FAFF3B3BF9FF3536F8FF3030F7FF2A2A
      F6FF2323F5FF2323F5FF3E3EF5FF0000EAFF6C0000FFC79B85FFD3B6A9FFDDC4
      B9FFBA8264FFB06F4DFFAB694AFFB06741FF996658FF5A73B5FF3081F7FF6DA7
      F5FFCCDEF5FFF5F5F5FFF5F3EEFFB1836AFF0000FFFF7878FEFF5C5CFEFF5858
      FEFF5353FDFF5050FDFF4A4AF9FF4646FBFF4140FAFF3B3BF9FF3536F8FF3030
      F7FF2A2AF6FF2525F5FF4343F6FF0000E6FFBB0800FFE29783FFDB7C63FFDB7C
      63FFD9785EFF5CEEFDFF47D4E3FF51BED1FF5394A7FF47D4E3FF43E8F9FF3C49
      DBFF3745DBFF313FDAFF4B57E0FF0000B6FFEFEFEFFFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFF6565FDFF4B4BFCFF4646FBFF4140FAFF3B3BF9FF3536F8FF3030
      F7FF2A2AF6FF2323F5FF4343F6FF0000EAFF7A0800FFD3B6A9FFFEFEFEFFFEFE
      FEFFD1AA98FFB27352FFB06F4DFFB06F4DFFB06741FFAB623BFF846871FF3B73
      D3FF3081F7FF6DA7F5FFD0E3F6FFE7E7E7FF0000FFFF7878FEFF5C5CFEFF5C5C
      FEFF5858FEFF5353FDFF5050FDFF4A4AF9FF4646FBFF4140FAFF3B3BF9FF3536
      F8FF3030F7FF2A2AF6FF4A4AF9FF0000ECFFBB0800FFE29783FFDC846BFFDB7C
      63FFDB7C63FF5CEEFDFF50F3FDFF59A0B0FF59A0B0FF4AE9FAFF4AE9FAFF424F
      DDFF3C49DBFF3745DBFF5863E2FF0000B6FFEFEFEFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFF6A6AFDFF5353FAFF4B4BFCFF4646FBFF4140FAFF3B3BF9FF3536
      F8FF3030F7FF2A2AF6FF4B4BF7FF0000EAFF7A0800FFD1AA98FFFEFEFEFFFEFE
      FEFFD1AA98FFB47858FFB27352FFB27352FFB06F4DFFAB6946FFAB623BFFA462
      42FF616DA2FF2B75F2FF4A92F7FF005CE9FF0000FFFF7878FEFF7878FEFF7878
      FEFF7676FEFF7373FDFF706FFDFF6E6EFCFF6969FBFF6464FCFF6161FAFF5B5B
      FAFF5656F9FF5252F8FF4E4EFAFF0000ECFFBB0800FFE29783FFE29783FFE297
      83FFE2937DFF7AF2FEFF7AF2FEFF73F0FDFF73F0FDFF67EEFCFF67EEFCFF636D
      E6FF636DE6FF5863E2FF5863E2FF0000B6FFEFEFEFFFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFF8585FEFF706FFDFF6A6AFDFF6A6AFDFF6565FDFF605FFCFF5B5B
      FAFF5353FAFF5353FAFF4B4BF7FF0000EAFF7A0800FFC79B85FFDDC4B9FFE2CB
      C3FFC79B85FFC39176FFC28F71FFC28F71FFBE8B6EFFBB866AFFBA8264FFB97C
      5AFFB47858FF9A7776FF618AD2FF0000EBFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000ECFF0000ECFFBB0800FFBB0800FFBB0800FFBB08
      00FFBB0800FF00DDFBFF00E3FDFF00D2FCFF00D2FCFF00DDFBFF00D9F7FF0000
      C3FF0000C3FF0000C3FF0000C3FF0000B6FFEFEFEFFFEFEFEFFFEFEFEFFFEFEF
      EFFFEDEDEDFF0000FCFF0000FCFF0000FCFF0000FCFF0000FCFF0000F4FF0000
      F4FF0000F4FF0000F4FF0000EAFF0000EAFF7A0800FF7A0800FF7A0800FF7A08
      00FF7A0800FF6C0000FF6C0000FF6C0000FF6C0000FF6C0000FF530000FF5300
      00FF530000FF530000FF530000FF00003AFFF78200FFF27600FFF27600FFEE69
      00FFEE6900FFEE6900FFE85800FFE85800FFE85800FFE85800FFE04900FFE049
      00FFDE4300FFDE4300FFDE4300FFE04900FF000073FF000066FF000066FF0000
      59FF000059FF000048FF000048FF000048FF000048FF000038FF000038FF0000
      38FF00002AFF00002AFF00002AFF000038FF008400FF007A00FF007300FF0073
      00FF006C00FF006400FF006400FF005A00FF005A00FF005A00FF005100FF004B
      00FF004B00FF004400FF004400FF004400FF0000F6FF0000F2FF0000F2FF0000
      EEFF0000EEFF0000EEFF0000EAFF0000EAFF0000E6FF0000E6FF0000E2FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFFF78200FFFBC484FFFBC484FFF9C2
      7EFFF9BE79FFF9BE79FFF7BA72FFF7BA72FFF6B66BFFF6B66BFFF4B264FFF4B2
      64FFF3AF5FFFF2AD5BFFF2AD5BFFDE3C00FF000073FF5F5FBEFF5B5BBBFF5757
      B9FF5353B7FF5050B5FF4949B2FF4545B1FF4241AEFF3D3DADFF3738AAFF3333
      A9FF3131A4FF2D2DA5FF2B2BA2FF00002AFF008400FF69CA69FF64C964FF60C6
      60FF5CC45CFF58C258FF54C054FF50BF50FF4ABC4AFF46B946FF42B943FF40B7
      40FF3CB43CFF38B338FF38B338FF004400FF0000F6FF6060FBFF5C5CFAFF5757
      F9FF5353F9FF4F4FF8FF4949F7FF4545FAFF4242F6FF3C3DF5FF3939F4FF3434
      F3FF3131F3FF2E2EF2FF2A2CF2FF0000DDFFF78200FFFBC484FFFAB867FFFBB5
      61FFF9B25CFFF9B25CFFF5AB53FFF5AB53FFF5A749FFF5A749FFF3A141FFF3A1
      41FFF19D38FFF19D38FFF5AB53FFDE3C00FF000073FF6565BFFF4545B1FF3D3D
      ADFF3738AAFF3333A9FF2D2DA5FF2929A2FF2222A1FF1B1B9CFF1B1B9CFF1313
      98FF0F0F95FF0C0C95FF2D2DA5FF00002AFF008C00FF6DCC6DFF4DC04DFF48BE
      48FF45BC45FF3EB93EFF39B639FF34B434FF2EB12EFF29AF29FF24AE24FF1FAB
      1FFF19A819FF19A819FF38B338FF004400FF0000FAFF6565FCFF4343FAFF3E3E
      FAFF3939F9FF3435F8FF2C2CF7FF2929F6FF2424F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2E2EF2FF0000DFFFFBB561FFFCDDB7FFFBD2A4FFFBD2
      A4FFFBD2A4FFF9CE9DFFF9CE9DFFF5C995FFF5C995FFF5C995FFF3C38AFFF3C3
      8AFFF3C38AFFF3C38AFFF5C995FFDF810EFF000073FF6A6AC2FF4949B2FF4545
      B1FF3D3DADFF3738AAFF3333A9FF2D2DA5FF2929A2FF24249FFF1B1B9CFF1B1B
      9CFF131398FF0F0F95FF3131A4FF00002AFF008C00FF71CD71FF52C252FF4DC0
      4DFF4ABE4AFF45BC45FF3EB93EFF39B639FF34B434FF2EB12EFF29AF29FF24AE
      24FF1FAB1FFF19A819FF3CB43CFF004B00FF0000FAFF6969FCFF4849FBFF4545
      FAFF3E3EFAFF3939F9FF3435F8FF2F2FF7FF2929F6FF2424F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000DFFFEDEDEDFFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7F7FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFDDDDDDFFCACAE9FFE7E7F5FFE1E1F1FFE1E1
      F1FFDEDEF0FFDCDCEEFFDCDCEEFFD9D9ECFFD8D8EBFFD7D7EAFFD5D5E9FFD3D3
      E8FFD1D1E5FFCFCFE4FFD6D6E9FF9E9EC8FF009400FF75CF75FF58C558FF54C3
      54FF4DC04DFF4ABE4AFF45BC45FF3EB93EFF39B639FF34B434FF2FB32FFF2AB0
      2AFF24AE24FF1FAB1FFF40B740FF004B00FF0000FDFF6D6DFDFF4E4EFCFF4849
      FBFF4545FAFF3E3EFAFF3C3DF5FF3661C4FF3661C4FF2A2CF2FF2424F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E2FFEDEDEDFFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7F7FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFDDDDDDFFFCFCFCFFFEFEFEFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F4FFF5F5F4FFF3F3F3FFF5F5F4FFE5E5E5FF009400FF79D179FF5CC75CFF58C5
      58FF54C354FF4FC14FFF4ABE4AFF45BC45FF40BB40FF3AB83AFF35B534FF2FB3
      2FFF2AB02AFF24AE24FF46B946FF005100FF0000FDFF7170FEFF5353FDFF4E4E
      FCFF4A4AFCFF4545FAFF3661C4FF3A7CB5FF3578B2FF2F57C9FF2929F6FF2424
      F5FF1E1EF4FF1818F3FF3939F4FF0000E6FFEDEDEDFFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFE0E0E0FFCACAE9FFE7E7F5FFE1E1F1FFE1E1
      F1FFDEDEF0FFDEDEF0FFDCDCEEFFD9D9ECFFD9D9ECFFD7D7EAFFD5D5E9FFD3D3
      E8FFD2D2E6FFD1D1E5FFD6D6E9FF9E9EC8FF009900FF7DD37DFF60C960FF5CC7
      5CFF58C558FF54C354FF4FC14FFF4ABE4AFF45BC45FF40BB40FF3AB83AFF35B5
      34FF2FB32FFF2AB02AFF48BB48FF005A00FF0000FDFF7575FEFF5858FEFF5353
      FDFF4E4EFCFF4A4AFCFF4549F3FF4074C0FF3B70BEFF353AF1FF2F2FF7FF2929
      F6FF2424F5FF1F1FF4FF3C3DF5FF0000E6FF656CFBFFBABDFEFFAAAEFEFFAAAE
      FEFFA5AAFDFFA5AAFDFFA1A5FCFF9CA0FDFF9CA0FDFF989DFCFF9498F8FF9498
      F8FF8D92FAFF8D92FAFF9A9FF6FF161EE7FF000081FF7878C6FF5B5BBBFF5757
      B9FF5353B7FF5050B5FF4949B2FF4545B1FF4241AEFF3B3BAAFF3738AAFF3131
      A4FF2B2BA2FF24249FFF4241AEFF000038FF009900FF80D380FF64C964FF60C9
      60FF5CC75CFF58C558FF54C354FF4FC14FFF4ABE4AFF45BC45FF40BB40FF3BB8
      3BFF36B536FF2FB32FFF4CBF4CFF005A00FF0000FFFF7878FEFF5C5CFEFF5858
      FEFF5353FDFF5050FDFF4A4AFCFF4545FAFF4141FAFF3C3BF9FF3435F8FF2F2F
      F7FF2929F6FF2424F5FF4242F6FF0000E6FF121EFEFF9499FEFF7B83FCFF7B83
      FCFF7B83FCFF747BFBFF747BFBFF6C74FAFF6C74FAFF656CFBFF656CFBFF5B63
      F8FF5B63F8FF535CF6FF6C74FAFF0000EDFF000089FF797ACAFF5F5FBEFF5B5B
      BEFF5858BCFF5353BAFF5050B5FF4C4CB5FF4545B1FF4241AEFF3D3DADFF3738
      AAFF3333A9FF2D2DA5FF4949B2FF000048FF009900FF83D482FF67CC67FF64C9
      64FF60C960FF5DC75DFF58C558FF54C354FF4FC14FFF4CBF4CFF45BC45FF40BB
      40FF3BB83BFF36B636FF50BF50FF006400FF0000FFFF7A7AFFFF5C5CFEFF5C5C
      FEFF5858FEFF5353FDFF5050FDFF4A4AFCFF4545FAFF4141FAFF3C3BF9FF3435
      F8FF2F2FF7FF2C2CF7FF4949F7FF0000EAFF1B27FFFF9CA0FDFF9CA0FDFF989D
      FCFF989DFCFF9499FEFF9499FEFF8D92FAFF8D92FAFF8D92FAFF848AFBFF848A
      FBFF7B83FCFF7B83FCFF747BFBFF0000EDFF000081FF797ACAFF797ACAFF7878
      C6FF7676C8FF7271C6FF7271C6FF6A6AC2FF6A6AC2FF6464C0FF5F5FBEFF5B5B
      BBFF5757B9FF5353B7FF4C4CB5FF000048FF009900FF83D482FF83D482FF80D4
      80FF7DD37DFF79D179FF79D179FF75CF75FF71CD71FF6DCC6DFF69CA69FF64C9
      64FF60C660FF5CC45CFF56C356FF006400FF0000FFFF7A7AFFFF7A7AFFFF7878
      FEFF7575FEFF7575FEFF7170FEFF6D6DFDFF6969FCFF6565FCFF6060FBFF5C5C
      FAFF5757F9FF5353F9FF4D4DF7FF0000EAFF2C36FFFF1B27FFFF1B27FFFF1B27
      FFFF1B27FFFF121EFEFF121EFEFF0713FCFF0713FCFF0003F6FF0003F6FF0003
      F6FF0000EDFF0000EDFF0000EDFF0000EDFF000089FF000089FF000089FF0000
      89FF000089FF000081FF000081FF000081FF000073FF000073FF000073FF0000
      66FF000066FF000066FF000059FF000059FF009900FF009900FF009900FF0099
      00FF009900FF009400FF009400FF008C00FF008C00FF008400FF008400FF0084
      00FF007A00FF007300FF007300FF006C00FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000F6FF0000
      F6FF0000F2FF0000F2FF0000EEFF0000EEFF42CFF3FF3CCCF1FF3CCCF1FF34C7
      EEFF34C7EEFF2DC2EBFF2DC2EBFF23BCE8FF23BCE8FF23BCE8FF23BCE8FF16B3
      E2FF16B3E2FF16B3E2FF16B3E2FF16B3E2FF0000C4FF0000BEFF0000BEFF0000
      B9FF0000B6FF0000B6FF0000ADFF0000ADFF0000ADFF0000A3FF0000A3FF0000
      A3FF00009CFF00009CFF000099FF000099FFB39D6EFF833000FF6C0E00FF6C0E
      00FF6C0E00FF003000FF004300FF004300FF004300FF004300FF003000FF0030
      00FF003000FF003000FF003000FF003000FF0000D9FF0000D9FF0000D9FF0000
      D9FF0000C7FF0000C7FF0000C7FF0000C7FF0000C7FF0000B9FF0000C7FF0000
      B9FF0000B9FF0000B9FF0000B9FF0000B9FF42CFF3FF4E9450FF47904BFF3D86
      F9FF3D86F9FF4AD3F4FF3FA7DEFF5358B1FF523BA1FF48349EFF48349EFF412C
      99FF412C99FF3B40A3FF3164B9FF0F82CFFFE5E7F5FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF3F2F2FFF2F2F2FFF2F2F2FFCDCFE1FFE5E5E5FFF3F1EAFFD1B177FFCDA2
      57FFC89D53FFC89D53FF72A64AFF46AF43FF46AF43FF3AAB3AFF3AAB3AFF35A8
      35FF31A632FF2DA32DFF2DA32DFF003000FF0000D9FF6160F0FF6160F0FF5353
      ECFF5353ECFF5353ECFF4545EAFF4545EAFF4545EAFF3A3AE6FF3A3AE6FF3030
      E3FF3030E3FF3030E3FF2929E7FF0000B9FF4AD3F4FF4E9450FF438C43FF3D86
      F9FF3D86F9FF4AD3F4FF5358B1FF4F65B9FF48349EFF48349EFF48349EFF412C
      99FF39339EFF3164B9FF3B40A3FF1A6EC4FF0000C8FF7C84E7FF626BE1FF5E66
      E0FF5962DEFF545DDDFF4E58DBFF4A54D9FF464FD8FF414BD6FF3C47D5FF3843
      D3FF323CD1FF323CD1FF4E58D7FF00009CFFE5E5E5FFFCFCFCFFFAFAFAFFD6CC
      B8FFC2923CFFBF8C33FFBD882FFF9B7B26FF339B20FF1BA01BFF159B15FF159B
      15FF0D960DFF0D960DFF2DA32DFF003000FF0000D9FF6160F0FF4545EAFF3C3C
      EDFF3C3CEDFF3333EBFF2929E7FF2929E7FF2929E7FF1818E4FF1818E4FF0C0C
      E2FF0C0CE2FF0C0CE2FF3030E3FF0000B9FF4AD3F4FF539754FF47904BFF478D
      FBFF3D86F9FF4FD5F6FF5B44A7FF523BA1FF4F65B9FF3A7AC7FF2B98D9FF3164
      B9FF1EA2DDFF39339EFF412C99FF1A6EC4FFE9EBF7FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFCDCFE1FFE5E5E5FFF6F9FBFFF6F9FBFFF6F9
      FBFFECECEBFFC89D53FFBF8C33FFBD882FFFB78227FF559121FF259C1CFF1BA0
      1BFF159B15FF0D960DFF31A632FF003000FF0000B9FF6979DAFF4658D0FF4658
      D0FF3E51CEFF3649CAFF3649CAFF3043C6FF263AC4FF263AC4FF1E32C1FF1329
      BDFF1329BDFF1329BDFF3043C6FF000076FF4FD5F6FF5B9B5BFF4E9450FF478D
      FBFF478DFBFF53D7F6FF654BABFF5B44A7FF4692D3FF22C8F2FF22C8F2FF22C8
      F2FF22C8F2FF39339EFF412C99FF1A6EC4FF0000CEFF7C84E7FF6C74E4FF666F
      E3FF626BE1FF5E66E0FF5962DEFF545DDDFF4E58DBFF4A54D9FF464FD8FF414B
      D6FF3C47D5FF3843D3FF545ED8FF0000A3FFE9E9E9FFB7D3E1FF95BDD3FF95BD
      D3FF95BDD3FFF9F9F9FFCEAA6BFFBF8C33FFBD882FFFBA862AFF9B7B26FF339B
      20FF1BA01BFF159B15FF35A835FF003000FF007A00FF72C671FF4EB74EFF49B5
      49FF42B142FF42B142FF3BAD3BFF32AA32FF32AA32FF2AA529FF24A224FF1EA0
      1EFF179C17FF179C17FF32AA32FF003200FF53D7F6FF5B9B5BFF539754FF4F92
      FDFF478DFBFF5AD9F5FF6551AEFF654BABFF37D5F6FF4186CDFF32BFEDFF23BC
      E8FF1ED4F4FF2D84CCFF48349EFF2377C9FFEBEDFBFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFCDCFE1FFE9E9E9FFF2F6F8FF6BA2C1FF659F
      BEFFD7E6EDFFFAFAFAFFFAFAFAFFEAE1D1FFC2923CFFBD882FFFBA862AFFB47D
      24FF339B20FF259C1CFF3AAB3AFF004300FF007A00FF72C671FF54BA54FF4EB7
      4EFF49B549FF42B142FF42B142FF3BAD3BFF32AA32FF32AA32FF2AA529FF24A2
      24FF1F9F1FFF179C17FF3BAD3BFF003200FF53D9F9FF64A165FF5B9B5BFF5797
      FEFF4F92FDFF63DCF7FF6B59B3FF654BABFF46B7E9FF37D5F6FF32BFEDFF4E4D
      ADFF3598D6FF3164B9FF523BA1FF2377C9FF570000FFB88785FFA76B69FFA568
      65FFA26362FF666FE3FF626BE1FF5F67E0FF5962DEFF545DDDFF5059DBFF4C56
      DBFF464FD8FF414BD6FF5C65DEFF0000A3FFDBDDDFFF95BDD3FF9BC0D5FF84B3
      CCFF78AAC6FFF2F6F8FFFBFBFBFFFAFAFAFFF5F4F1FFCEAA6BFFBF8C33FFBA86
      2AFFB47D24FF559121FF48A93EFF004300FF008300FF72C671FF54BA54FF54BA
      54FF4EB74EFF49B549FF42B142FF42B142FF3BAD3BFF32AA32FF32AA32FF2AA5
      29FF24A224FF1F9F1FFF3BAD3BFF003200FF56D9F9FF64A165FF5B9B5BFF5797
      FEFF5797FEFF63DCF7FF6B59B3FF654BABFF46B7E9FF5382CAFF439BDAFF439B
      DAFF4186CDFF494FAEFF523BA1FF2377C9FF5A0000FFD3B4B3FFF5EFEFFFC7A1
      A0FFA56865FFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFCDCFE1FFECECEBFF95BDD3FF6BA2C1FF659F
      BEFF6BA2C1FFFBFBFCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFE7DDCAFFC292
      3CFFBA862AFFB78227FFBD9143FF003000FF00C0E6FF7EE6EBFF63E0E6FF5EDF
      E5FF5EDFE5FF53DBE1FF53DBE1FF53DBE1FF47D6DDFF47D6DDFF47D6DDFF35D1
      D9FF35D1D9FF35D1D9FF47D6DDFF009BABFF56D9F9FF64A165FF5B9B5BFF5797
      FEFF5797FEFF63DCF7FF7378C3FF6A82C8FF6B59B3FF6551AEFF654BABFF5C51
      AFFF5B44A7FF4F65B9FF5358B1FF2B84D0FF5A0000FFFAF7F7FFFEFEFEFFF5EF
      EFFFA86C6AFF6C74E4FF6C74E4FF6870E3FF646CE1FF5F67E0FF5C65DEFF5660
      DEFF515BDCFF4C56DBFF666FE3FF0000ADFFEDEDEDFFF2F6F8FF8DBAD1FF84B3
      CCFFB2D0DFFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF3F1
      EAFFC49644FFBA862AFFBD9143FF6C0E00FF00D4FDFF82EBFDFF67E8FEFF67E8
      FEFF63E4FBFF5CE5FDFF5CE5FDFF54E2FCFF54E2FCFF4CE0FAFF44DFF9FF44DF
      F9FF3ADBF7FF3ADBF7FF54DFF7FF00B5EBFF56D9F9FF67A76FFF67A76FFF64A2
      FEFF64A2FEFF71DFF9FF66C0EBFF7378C3FF7362B7FF7362B7FF6B59B3FF6B59
      B3FF6551AEFF4F65B9FF4692D3FF2B98D9FF5A0000FFD3B4B3FFFAF7F7FFD3B4
      B3FFB88785FFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFCDCFE1FFEDEDEDFFB7D3E1FFEAF2F7FFE5EF
      F5FFB2D0DFFFFBFCFCFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFDABE8EFFC89D53FF6C0E00FF00D1FBFF82EBFDFF82EBFDFF82EB
      FDFF7AE9FCFF7AE9FCFF7AE9FCFF72E7FCFF72E7FCFF6AE5FAFF6AE5FAFF63E4
      FBFF5DE1F8FF5DE1F8FF54DFF7FF00B5EBFF56D9F9FF56D9F9FF56D9F9FF56D9
      F9FF53D9F9FF53D7F6FF4FD5F6FF4FD5F6FF4AD3F4FF4AD3F4FF42CFF3FF42CF
      F3FF3CCCF1FF3CCCF1FF34C7EEFF34C7EEFF5A0000FF5A0000FF5A0000FF5A00
      00FF570000FF0000CEFF0000CEFF0000CEFF0000C8FF0000C8FF0000C4FF0000
      C4FF0000BEFF0000BEFF0000B9FF0000B6FFEDEDEDFFEDEDEDFFEDEDEDFFEDED
      EDFFECECEBFFECECEBFFE9E9E9FFE9E9E9FFE5E5E5FFE5E5E5FFE5E5E5FFDBDD
      DFFFDBDDDFFFDBDDDFFFD6CCB8FF8D4000FF00D4FDFF00D1FBFF00D1FBFF00D1
      FBFF00D1FBFF00CDF8FF00CDF8FF00CAF7FF00CAF7FF00C4F3FF00C4F3FF00C4
      F3FF00C4F3FF00B5EBFF00B5EBFF00B5EBFF0000F1FF0000F1FF0000F1FF0000
      EDFF0000EDFF0000EDFF0000E4FF0000E4FF0000E4FF0000E4FF0000DBFF0000
      DBFF0000DBFF0000DBFF0000DBFF0000DBFF0000D3FF0000CCFF0000CCFF0000
      CCFF0000C4FF0000C4FF0000BEFF0000BEFF0000BEFF0000B4FF0000B4FF0000
      B4FF0000B4FF0000ADFF0000ADFF0000ADFFF9B938FFF3AF21FFF0AC1DFFEEA6
      11FFEEA611FFEA9D00FFEA9D00FFEA9D00FFE69300FFE69300FFE08D00FFE08D
      00FFDE8700FFDE8700FFDE8700FFE08D00FF0000D9FF0000D9FF0000D9FF0000
      CAFF0000CAFF0000CAFF0000CAFF0000CAFF0000CAFF0000CAFF0000BCFF0000
      BCFF0000BCFF0000BCFF0000BCFF0000BCFF0000F7FF6161FAFF5C5CFAFF5655
      F8FF5655F8FF5151F7FF4C4CF7FF4343F5FF4343F5FF3838F2FF3838F2FF3838
      F2FF2E2EF1FF2E2EF1FF2E2EF1FF0000DBFF0000D3FF5F6EF1FF5B6BF1FF5666
      EFFF5261EDFF4D5DEEFF495AEDFF4557EDFF4152ECFF3A4CEAFF3A4CEAFF3447
      E8FF3143E6FF2D3EE5FF2D3EE5FF0000ADFFF8B42BFFFBDD9FFFFADB9DFFF9D9
      96FFF9DA8EFF4ADAF7FF4ADAF7FF3CD4F5FF3CD4F5FF3CD4F5FF3CD4F5FFF4CD
      77FFF3CC79FFF2CB7CFFF2CB7CFFDE8700FF0000D9FF6173F0FF5A6DEEFF5A6D
      EEFF5467EDFF4B60ECFF4B60ECFF4359EBFF4359EBFF3B51E9FF3B51E9FF3249
      E6FF3249E6FF2C43E5FF2C43E5FF0000BCFF3E004CFFA87EB1FF93629FFF905E
      9EFF8C5A9DFF895495FF824D91FF80478BFF7C4287FF773B84FF773B84FF773B
      84FF6F337EFF6F337EFF824D91FF000011FF0000D3FF6C79F3FF495AEDFF4557
      EDFF4152ECFF3A4CEAFF3447E8FF3144E9FF2D3EE5FF2439E4FF2439E4FF172C
      E2FF172CE2FF172CE2FF3548E5FF0000ADFFF9B938FFFCDFA4FFFBD68FFFFBD3
      8AFFF8D775FFF4D8B9FF2DCCF7FF25D3F6FF25D3F6FF1DC7F4FFE6CEB4FFF9CA
      5AFFF2C569FFF2C569FFF2CB7CFFDE8700FF0000D9FF6577F1FF4359EBFF3B51
      E9FF3B51E9FF3249E6FF2C43E5FF2C43E5FF233BE7FF1B34E6FF1B34E6FF132D
      E4FF0E29E0FF0A25DEFF2C43E5FF0000BCFFB81500FFE09A7CFFD7815EFFD47B
      5AFFD37854FFD1714AFFD88463FFEED5CCFFEED5CCFFD47B5AFFC85D33FFC85D
      33FFC4572CFFC4572CFFCC6C48FF880000FFE2E2E3FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAF9FFF5F7F3FFDBE9DAFF3C933CFF3C933CFFA3CCA2FFDBE9DAFFEFF2
      EEFFF2F2F2FFF2F2F2FFF4F4F4FFBCBCBCFFFCBD40FFFCDFA4FFFBD892FFFBD6
      8FFFF9D484FFF9DE93FF2D6F92FF2CEDF7FF2CEDF7FF2D6F92FFF7D081FFF2C5
      69FFF2C569FFF2C569FFF2CB7CFFDE8700FF0000D9FF6C7DF4FF4B60ECFF4359
      EBFF3B51E9FF3B51E9FF3249E6FF2C43E5FF2C43E5FF233BE7FF1B34E6FF1B34
      E6FF132DE4FF0E29E0FF3249E6FF0000BCFFB81500FFE09A7CFFD88463FFD781
      5EFFD47B5AFFD47B5AFFF6EFECFFF9F9F9FFF7F7F7FFF3E9E5FFCC6C48FFC85D
      33FFC85D33FFC4572CFFCD6F4BFF880000FFE2E2E3FFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFF5AA45AFF5AA45AFF439642FF3C933CFF439642FF529D51FFF4F4
      F1FFF4F4F4FFF2F2F2FFF4F4F4FFBCBCBCFFFCBD40FFFEE3ACFFFCDA96FFFBD8
      92FFFBD38AFFFAF9A0FF98675EFF31A1CDFF31A1CDFF98675EFFF5F490FFF4C9
      71FFF4C971FFF2C569FFF5CE84FFE08D00FF0000E9FF6C7DF4FF4B60F6FF4B60
      F6FF4257F4FF4257F4FF364CF0FF364CF0FF2E45F0FF2940EFFF2940EFFF1B34
      E6FF1B34E6FF132DE4FF364CF0FF0000CAFFB81500FFE2A086FFDA8868FFD884
      63FFD47B5AFFDB9174FFF9F9F9FFF9F9F9FFF9F9F9FFF7F7F7FFD58364FFC85D
      33FFCA643CFFC85D33FFCE744FFF880000FFE2E2E3FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFCFE4CEFF5AA45AFF449944FF439642FF499A48FFCBDFCBFFF5F5
      F5FFF4F4F4FFF4F4F4FFF5F5F5FFBCBCBCFFFEC248FFFEE3ACFFFDDB98FFFCDA
      96FFFBD68FFFFBE289FFFEE3B3FF3B3A3EFF3B3A3EFFF4D8B9FFF8D775FFF4C9
      71FFF4C971FFF4C971FFF5CE84FFE69300FF600A28FFB7919FFFA57285FFA572
      85FFA57285FFA57285FF986478FF986478FF986478FF935A6FFF90566BFF8C51
      68FF884B62FF884B62FF986478FF0A0000FFBE2200FFE2A086FFDB8B6BFFDA88
      68FFD88463FFD88463FFF7F0EDFFF9F9F9FFF9F9F9FFF3E9E5FFD0734FFFCA64
      3CFFCA643CFFCA643CFFD37854FF880000FFE2E2E3FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFFCFCFCFFA3CCA2FF5AA45AFF499A48FF97C696FFF5F7F3FFF6F6
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFC2C2C3FFFEC44DFFFEE3ACFFFEDC9AFFFDDB
      98FFFCDA96FFF9D484FFFAFAC6FF3B3A3EFF3B3A3EFFFAFAC6FFF4C971FFF6CE
      7CFFF4CD77FFF4C971FFF6D38BFFE69300FFA71800FFDA9B79FFCB815BFFCB81
      5BFFC97B54FFC97B54FFC9764EFFC87245FFC46F44FFC36B3FFFC16639FFBE61
      33FFBC5C2BFFBC5C2BFFC46F44FF770000FFBE2200FFE2A086FFDB8D70FFDB8B
      6BFFDA8868FFD58364FFDB9174FFEED5CCFFEED5CCFFD6886CFFCC6C48FFCC6C
      48FFCC6C48FFCA643CFFD47B5AFF880000FFE2E2E3FFFDFDFEFFFDFDFEFFFDFD
      FEFFFBFBFDFFFCFBFDFFE6F0E7FF84BA85FF7AB37CFFDBE9DAFFFAFAF9FFF6F6
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFC2C2C3FFFEC44DFFFEE3ACFFFEDE9EFFFEDC
      9AFFFDDB98FFFBD68FFFFAF9A0FF84868EFF84868EFFFAF9A0FFF8CD7EFFF7D0
      81FFF6CE7CFFF4CD77FFF6D38BFFE79900FFA71800FFD99E80FFA2ABA1FF62E0
      FBFF5FDFFAFF5CDBF5FFA19E8FFFC9764EFFC6724AFFC46F44FFC36B3FFFC166
      39FFBE6133FFBC5C2BFFC6724AFF770000FF4E026CFFB190C0FF9F77B2FF9F77
      B2FF9B71AEFF9B71AEFF9365A5FF9365A5FF905E9EFF8C5A9DFF8C5A9DFF8453
      9BFF84539BFF824D91FF9365A5FF000011FF0000DFFF7B89F7FF6271F3FF6271
      F3FF5B6BF1FF5B6BF1FF5666EFFF5061F0FF4D5DEEFF495AEDFF4152ECFF3A4C
      EAFF3A4CEAFF3144E9FF4D5DEEFF0000BEFFFEC44DFFFEE3B3FFFEDE9EFFFEDE
      9EFFFEDC9AFFFDDB98FFFDDB85FFEBE1CEFFEAE0D3FFF8D775FFF9D484FFF9D4
      84FFF7D081FFF6CE7CFFFBD68FFFEA9D00FFA71800FFD99E80FF74D6E9FF6CDA
      F0FF66DCF4FF5FDFFAFF6DCFE0FFC97B54FFC9764EFFC6724AFFC46F44FFC36B
      3FFFC16639FFBE6133FFC9764EFF770000FF0000FDFF7979FEFF7979FEFF7979
      FEFF7979FEFF7271FCFF7271FCFF6A6AFCFF6A6AFCFF6161FAFF6161FAFF5C5C
      FAFF5655F8FF5151F7FF4C4CF7FF0000EDFF0000DFFF7B89F7FF7B89F7FF7785
      F6FF7785F6FF7381F5FF707DF4FF6C79F3FF6876F2FF6271F3FF5F6EF1FF5B6B
      F1FF5666EFFF5261EDFF4D5DEEFF0000C4FFFEC248FFFEE3B3FFFEE3B3FFFEE3
      ACFFFEE3ACFFFEE3ACFFFEDE9EFFFDEFC1FFFDEFC1FFFCDA96FFFBDD9FFFFADA
      9AFFFADA9AFFF9D996FFF7D793FFEA9D00FFA71800FFD99E80FFC3AC9AFFAAC3
      C2FF86E0F2FFA7C1BEFFC3AC9AFFD49271FFD49271FFD18C69FFD18C69FFCD85
      61FFCD8561FFCB815BFFC97B54FF770000FF0000FDFF0000FDFF0000FDFF0000
      FDFF0000FDFF0000FDFF0000F7FF0000F7FF0000F7FF0000F7FF0000F7FF0000
      F1FF0000F1FF0000F1FF0000EDFF0000EDFF0000DFFF0000DFFF0000DFFF0000
      DFFF0000DBFF0000DBFF0000DBFF0000DBFF0000DBFF0000D3FF0000D3FF0000
      D3FF0000CCFF0000CCFF0000CCFF0000C4FFF9CA5AFFFEC44DFFFEC44DFFFEC4
      4DFFFEC44DFFFEC248FFFEC248FFF9B938FFF8B42BFFF9B938FFF8B42BFFF8B4
      2BFFF3AF21FFF0AC1DFFEEA611FFF0AC1DFFA71800FFA71800FFA71800FFA718
      00FFA71800FFA71800FFA71800FF940100FF940100FF940100FF940100FF9401
      00FF940100FF940100FF770000FF770000FFEDEDE7FFEBEBE5FFE9E9E3FFE5E7
      E1FFE2E4DEFFE2E4DEFFDFE1D9FFDDDFD7FFDADBD6FFD9D9D3FFD7D9D1FFD5D7
      D0FFD1D3CFFFD1D2CBFFD1D2CBFFCFD1CBFF000000FF0000DAFF0000F1FF0000
      DAFF0000DAFF0000DAFF0000DAFF0000DAFF0000DAFF0000CFFF0000CFFF0000
      CFFF0000CFFF0000C9FF0000C9FF0000C9FF2B0000FF2B0000FF140000FF1400
      00FF140000FF140000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFF3AD00FF02A987FFF3AD00FFEFA5
      00FFEFA500FFEA9800FFEA9800FFEA9800FFE58B00FFE58B00FFE58B00FFDF85
      00FFDF8500FFDF8500FFDD8000FFDD8000FFEFEFE9FFFCFCFCFFF9F9F9FFC4C4
      C4FFB0B0AEFFE9E9E9FFF7F7F7FFF7F7F7FFF5F5F5FFF5F5F5FFE9E9E9FFA4A6
      A6FFB0B0AEFFF2F2F2FFF2F2F2FFD1D2CBFF000000FF616662FF5C5CE1FF5353
      F3FF5353F3FF5353F3FF4545EEFF4545EEFF4545EEFF3A3AEDFF3A3AEDFF3333
      EBFF3333EBFF2A2AEAFF2A2AEAFF0000C9FF2B0000FFA7735FFFA7735FFFA169
      54FFA16954FF9B634FFF985E48FF985E48FF945740FF91523CFF8B4D38FF8652
      3DFF8B4D38FF87432DFF87432DFF000000FFF7B100FF77DEECFF95DCCCFFFCDC
      7AFFF6D874FFF7D76FFFF6D469FFF6D469FFE6D16FFFE6D16FFFF5CF5EFFF3CD
      59FFF3CD59FFF5CD53FFF5CD53FFDD8000FFF0F1EBFFFCFCFCFFDFDFDFFF7B7B
      7BFF666667FFD3D4D4FFF7F7F7FFEDD4C7FFEDD4C7FFF2F2F2FFCDD0D0FF5656
      56FF666667FFCACACAFFF2F2F2FFD1D2CBFF000000FF616662FF464849FF3E3E
      C5FF3939F8FF3333EBFF2A2AEAFF2A2AEAFF2A2AEAFF1818E8FF1818E8FF1818
      E8FF0C0CE5FF0C0CE5FF2A2AEAFF0000C9FF3E0000FFA97864FF985A43FF9457
      40FF91523CFF8D4B32FF87432DFF87432DFF823C22FF87432DFF767169FF69A1
      BCFF769BAFFF6E655CFF8B4D38FF000000FFFAB500FF77DEECFFFAD561FFFAD5
      61FFFAD561FFF8D15AFFF5CD53FFE1CD60FF88CCA7FF77C9AAFFB2C777FFF2C4
      3AFFF2C43AFFF2C43AFFF5CD53FFDF8500FFF2F2EDFFFCFCFCFFD3D4D4FF7B7B
      7BFFA4A6A6FFF9F4F2FFE19A73FFD86E36FFD86E36FFE19A73FFF4EEE8FFA4A6
      A6FF565656FFBBBABBFFF3F3F3FFD3D5CFFF000000FF6C6C6CFF464849FF4648
      49FFA4A4D9FFB3B3F6FFB3B3F6FFB3B3F6FFACACF2FFACACF2FFACACF2FFA4A4
      EFFFA4A4EFFFA4A4EFFFACACF2FF4444D7FF3E0000FFAD7D6BFF985E48FF985A
      43FF945740FF91523CFF8D4B32FF8D4B32FF87432DFF769BAFFF72A8CBFF4C71
      61FF4C7161FF69A1BCFF769BAFFF000000FFFAB500FFA1E1D4FF8DD8C4FFFBD6
      68FFFAD561FFCFD078FF91D1AFFF6CCFC3FF5AD0D3FF88CCA7FF37CADFFF77C9
      AAFFF2C640FFF2C43AFFF3CD59FFDF8500FFF2F2EDFFFDFDFDFFFCFCFCFFE9E9
      E9FFF3F4F5FFF0C4AAFFC56952FFC56952FFD86E36FFD86E36FFD9ACA3FFE9E9
      E9FFDAD9D9FFF2F2F2FFF4F4F4FFD5D7D0FF000000FF6C6C6CFF4E4E4EFF4648
      49FFDFDFDDFFFAFAFAFFF9F9F9FFF7F7F7FFF7F7F7FFF7F7F7FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE2E1E2FF3E0000FFAD7D6BFF9B634FFF985E
      48FF985A43FF945740FF8B4D38FF8D4B32FF8D4B32FF87432DFFDECEC4FFDECE
      C4FFDBCBC0FFDBCBC0FF8B4D38FF000000FFFDBB00FFA1E1D4FFFCD96CFFFCD9
      6CFFE8D778FFCFD78EFF6CCFC3FFCFD078FFA9CF97FFBBCD82FFCFD078FF77C9
      AAFFF3C845FFF2C640FFF3CD59FFDF8500FFF3F5EFFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFC39DB5FF453DE8FF453DE8FFBE6D64FFC56952FF9378C6FFF7F7
      F7FFF4F4F4FFF3F3F3FFF5F5F5FFD7D9D1FF000000FF747373FF535353FF4E4E
      4EFFE2E1E2FFFAFAFAFFFAFAFAFFF9F9F9FFF7F7F7FFF7F7F7FFF7F7F7FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE6E6E6FF643856FFB39394FFA16954FF9971
      7EFF99717EFF985A43FFA97864FF7E4D3AFF8B4D38FF87432DFF5B8172FFBB94
      7DFFBB947DFF4C7161FF8B4D38FF000000FFFDBB00FF88E3F0FF95DCCCFFFCD9
      6CFFE1D781FFE1D781FFAAD5A7FF88D3BCFF37D3F8FF45CFE7FF88CCA7FFACCB
      8BFFF4CB4BFFF3C845FFF5CF5EFFE58B00FFF5F7F1FFFEFEFEFFFEFEFEFFE9E9
      E9FFF5F5F2FFB5B1F3FF4444FBFF4444FBFF453DE8FF453DE8FF8788F9FFEFEF
      E9FFDAD9D9FFF4F4F4FFF5F5F5FFDADBD6FF000000FF747373FF595B58FF5353
      53FFE2E1E2FFFCFCFCFFFAFAFAFFFAFAFAFFF9F9F9FFF7F7F7FFF7F7F7FFF7F7
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFE6E6E6FF9B6E66FFD1C9E4FFB39394FFA08F
      C2FFA08FC2FFCBAA97FFBDB5D6FF86523DFF91523CFF8D4B32FFBDB5D6FF6C66
      C1FF6C66C1FFB5ACCBFF91523CFF000000FFFFBF02FF88E3F0FFFCDA73FFFCDA
      73FFFCDA73FFF6D874FFE8D778FF52D5EBFF37D3F8FF37D3F8FF5AD0D3FFE7CE
      5DFFF4CB4BFFF4CB4BFFF5D263FFE58B00FFF5F7F1FFFEFEFEFFDAD9D9FF8A8A
      8AFFB0B0AEFFF3F3FBFF8788F9FF4444FBFF4444FBFF8788F9FFF2F2F2FFB0B0
      AEFF666667FFC4C4C4FFF5F5F5FFDDDFD7FF000000FF797979FF595B58FF595B
      58FFAECEAEFFBBE2BBFFBBE2BBFFB6DFB6FFB6DFB6FFB1DCB2FFB1DCB2FFAAD8
      AAFFAAD8AAFFAAD8AAFFB1DCB2FF4EA94EFF603C72FFC8C1E2FFB5B5F1FF938E
      E0FF9693E5FFB5B5F1FFA097D3FF895B49FF985A43FF91523CFF3637CAFF6C96
      CEFF72A8CBFF3637CAFF945740FF000000FFFFBF02FFAAE4D8FF95DCCCFFFCDC
      7AFFFCDA73FFFCDA73FFF8D870FF8DD8C4FF42D5FAFF52D5EBFFA7D29FFFF5CD
      53FFF5CD53FFF5CD53FFF6D469FFEA9800FFF5F7F1FFFFFFFFFFE9E9E9FF8A8A
      8AFF7B7B7BFFDCDCDAFFFDFDFDFFD8D8FCFFD8D8FCFFF9F9F9FFDAD9D9FF6666
      67FF7B7B7BFFDAD9D9FFF7F7F7FFDFE1D9FF000000FF797979FF616662FF5BA9
      5BFF58BB59FF53B953FF51B751FF4BB34BFF4BB34BFF41B041FF41B041FF33A9
      33FF33A933FF2BA52BFF4BB34BFF004400FF3637CAFFA49FE6FF9693E5FF8885
      E6FF7A76E0FF8885E6FF8B86DEFF895B49FF9B634FFF945740FF985A43FF5B81
      72FF5B8172FF8D4B32FF985E48FF000000FFFFBF02FFAAE4D8FFFCDC7AFFFCDC
      7AFFFCDC7AFFFCDA73FFFCDA73FFCFD78EFF94D7BEFFAAD5A7FFF6D469FFF8D1
      5AFFF8D15AFFF5CD53FFF6D469FFEA9800FFF5F7F1FFFFFFFFFFFFFFFFFFDAD9
      D9FFC4C4C4FFF4F4F4FFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFF2F2F2FFBBBA
      BBFFCACACAFFF9F9F9FFF7F7F7FFE2E4DEFF000000FF7A877AFF7AC37AFF78CD
      78FF76C876FF72C671FF72C671FF68C268FF68C268FF68C268FF5FBE60FF58BB
      59FF58BB59FF51B751FF4BB34BFF004400FF723226FFCAC2DFFFE2D9E2FFBDB5
      D6FFB3A9D8FFCABFDAFFDCD3E4FFA17A6CFFAD7D6BFFA97864FFA7735FFFA17A
      6CFF95BFD7FFA16954FF9B634FFF140000FFFFBF02FF88E3F0FFAAE4D8FFFEE2
      8FFFFEE28FFFFEE28FFFFEE28FFFF6DE8BFFF6DE8BFFF6DE8BFFFCDC7AFFFCDC
      7AFFF6D874FFF6D874FFF7D76FFFEA9800FFF5F7F1FFF5F7F1FFF5F7F1FFF5F7
      F1FFF5F7F1FFF3F5EFFFF3F5EFFFF2F2EDFFF2F2EDFFF0F1EBFFEFEFE9FFEDED
      E7FFEBEBE5FFE9E9E3FFE5E7E1FFE2E4DEFF000000FF008900FF008900FF0089
      00FF008900FF007700FF007700FF007700FF007700FF006900FF006900FF0069
      00FF005700FF005700FF005700FF005700FF7E70B5FFA17E8DFF6B1200FF4E2D
      7AFF4E2D7AFF6B1200FF603C72FF2B0000FF3E0000FF3E0000FF2B0000FF2B00
      00FF2B0000FF140000FF140000FF140000FFFFBF02FF00BFDFFFFEC30DFFFEC3
      0DFFFEC30DFFFFBF02FFFDBB00FFFDBB00FFFAB500FFFAB500FFF7B100FFF3AD
      00FFF3AD00FFF3AD00FFEFA500FFEFA500FF750100FF925845FF750100FF954B
      33FF954B33FF750100FF750100FF997062FF8E6255FF560000FF560000FF8E62
      55FF742004FF560000FF925845FF902A09FF005800FFC33800FFEF2300FFEF23
      00FFEF2300FFEB0D00FFEB0D00FFEB0D00FFE40000FFE40000FFE40000FFE400
      00FFDD0000FFDD0000FFDD0000FFDD0000FF000000FF000000FF000000FF002E
      4CFF003AEDFF0000E8FF0000E8FF0000E8FF0000E8FF0000E8FF0000E1FF0000
      E1FF0000E1FF0000DDFF0000DDFF0000DDFFF75C03FFF14A00FFF14A00FFEE41
      00FFEE4100FFEC3300FFEC3300FFE72500FFE72500FFE72500FFE01900FFE019
      00FFDE0D00FFDE0D00FFDE0D00FFE01900FFA96852FFE0A590FFE7CCC3FFDB9E
      8BFFDB9E8BFFE7C2B5FFE7C2B5FFD8947BFFD8947BFFEDD7CFFFE2BCAFFFD389
      6FFFDFB8AAFFDFB8AAFFCD8469FF560000FF005800FF70AF62FFBDA76DFFF9A3
      75FFF9A375FFF79D67FFF79D67FFF79D67FFF5955BFFF5955BFFF5955BFFF390
      53FFF39053FFF28B4DFFF28B4DFFDD0000FF000000FF616668FF596467FF5669
      6EFF56696EFF49C6F4FF328FF6FF4343F7FF4343F7FF3B3BF5FF3B3BF5FF3033
      F3FF3033F3FF292CF3FF292CF3FF0000DDFFF7CDB3FFFAE8DCFFFAE8DCFFFAE8
      DCFFF9E5D9FFF9E5D9FFF7E2D5FFF7E2D5FFF7E2D5FFF4DDD0FFF4DDD0FFF4DD
      D0FFF2DACCFFF2DACCFFF2DACCFFDDA37EFF902A09FFF3E3DEFFD8947BFFF0DC
      D6FFE7C2B5FFD3896FFFD1846AFFEAD3CBFFEAD3CBFFCE7C60FFCA775AFFE7CC
      C3FFDCAC9CFFC86F50FFEAD3CBFF742004FF005800FF67B568FF5EB15FFF739B
      7CFFB58797FFC68B8CFFC68B8CFFC68B8CFFC68B8CFFC08589FFC08589FFC085
      89FFC08589FFC08589FFC68B8CFFA76C6CFF00B39EFF658286FF405257FF5050
      51FFDADADAFF384C52FF29BCD1FF328FF6FF1C1CF4FF1C1CF4FF1C1CF4FF1212
      F2FF0C0CF1FF0C0CF1FF292CF3FF0000E1FF0000ECFF7574F6FF5A59F1FF5150
      F0FF4B4BF1FF4C4BEDFF4242ECFF3C3CECFF3A3AEFFF3434EAFF3030EAFF2A2A
      ECFF2424E6FF2424E6FF4242ECFF0000D0FFBB998DFFE0A590FFF0DCD6FFE7C2
      B5FFD3896FFFEDD7CFFFEDD7CFFFCE7C60FFCE7C60FFEAD3CBFFDCAC9CFFC86F
      50FFE7CCC3FFE7CCC3FFD3896FFF8E6255FF005800FF67B568FFE9F3E9FFD8EB
      D8FF3C8C6DFF396DB3FF3251E2FF3251E2FF2C47E1FF2C47E1FF1B3EDFFF1B3E
      DFFF1533DBFF1533DBFF3251E2FF0000B4FF008100FF64E1C6FF47C6C7FF8E9A
      9DFFEAE9EAFF8C8989FF2F4449FF2E4F55FF27BCF4FF3033F3FF1C1CF4FF1C1C
      F4FF1212F2FF1212F2FF3033F3FF0000E1FF0000ECFF6969F6FF6969F6FFCACA
      FBFFE1E2FAFFE9E9FAFF6463F2FF3535EFFF2A2AECFF2424ECFF1C1CE9FF1C1C
      E9FF1313E8FF0F0FE7FF3030EAFF0000D0FFA57A7EFFE3E5E9FFE0A590FFF0DC
      D6FFDCD8E8FFDB9E8BFFD8947BFFE3E5E9FFE3E5E9FFCE7C60FFCE7C60FFD2CE
      E4FFCE7C60FFC86F50FFDCD8E8FF682E32FF005800FFEBF4EBFFEBF4EBFF51A9
      51FFCDE6CDFF41A141FF3C8C6DFF3251E2FF2C47E1FF263CE0FF263CE0FF1533
      DBFF1533DBFF1533DBFF2C47E1FF0000B4FF008100FF6DC36DFF4ACA71FF45D7
      C9FF8A9CA0FF405257FF373737FF373737FF2F4449FF27C4E5FF328FF6FF1C1C
      F4FF1C1CF4FF1212F2FF3033F3FF0000E1FF0000ECFF6F6EF5FFC4C4F9FF8485
      F6FFC4C4F9FF8B8BF6FFE1E2FAFF4B4BF1FF2F2FEEFF2A2AECFF2424ECFF1C1C
      E9FF1C1CE9FF1313E8FF3434EAFF0000D0FF8B8DD7FF7987F1FFC9CEF6FFBBC3
      F9FF4D5EE9FFD1D6F5FFDDEEF6FF52E5F4FF52E5F4FFBEDCEFFFC9CEF6FF2A3D
      E5FFC9CEF6FFD1D6F5FF4658E5FF4448ADFF005800FFEBF4EBFFB9DDB9FF51A9
      51FFE9F3E9FF41A141FF41A141FF61A580FFD3D9F3FFD3D9F3FFD3D9F3FFCFD6
      F1FFCFD6F1FFCCD3EFFFD3D9F3FF97A5DBFF008100FF72C671FF50B650FF4CBB
      52FF48DCBAFF47C6C7FF405257FF373737FF373737FF2F4449FF2AB1BAFF27BC
      F4FF292CF3FF1C1CF4FF3B3BF5FF0000E8FF0000ECFF7271F5FFDDDEFBFFD3D3
      FAFF7271F5FFD3D3FAFFE9E9FAFF6463F2FF3535EFFF2F2FEEFF2A2AECFF2424
      ECFF1C1CE9FF1C1CE9FF3C3CECFF0000D0FF0000E0FF7987F1FF5666EBFF5263
      EAFF5263EAFF4D5EE9FF57C2EAFF54DDE9FF54DDE9FF47BBE7FF2E41E2FF2E41
      E2FF2337DEFF2337DEFF3E50E4FF0000BFFF005800FFEBF4EBFFF0F8EDFF5CB0
      5BFFCDE6CDFF50A74EFF9ECD9BFFF0F8EDFFFAFAFAFFFAFAFAFFF5F6F6FFF5F6
      F6FFF5F6F6FFF5F6F6FFF5F6F6FFE7E7E7FF008900FF76C876FF5ABD5AFF53BA
      53FF50B650FF4ACA71FF45D7C9FF405C62FF373737FF373737FF2F4449FF7988
      8CFF27C4E5FF1F50F4FF3B3BF5FF0000E8FF0000F0FF7574F6FFC8C8FBFFA3A3
      F9FFC8C8FBFF9999F7FFDDDEFBFF4B4BF1FF3A3AEFFF3535EFFF2F2FEEFF2A2A
      ECFF2424ECFF1C1CE9FF3C3CECFF0000D0FF0000E0FF7987F1FF5D6DECFF5D6D
      ECFF5666EBFF5263EAFF4D5EE9FF57C2EAFF57C2EAFF3E50E4FF3548E3FF3548
      E3FF2E41E2FF2337DEFF4658E5FF0000BFFF005800FF77BB78FFE9F3E9FFD8EB
      D8FF77BB78FFCDE6CDFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFF5F6
      F6FFF5F6F6FFF5F6F6FFF5F6F6FFE7E7E7FF008900FF79C979FF5ABD5AFF5ABD
      5AFF53BA53FF50B650FF4CBB52FF48DCBAFF416E73FF384C52FF8C8989FFEAE9
      EAFF79888CFF29BCD1FF49C6F4FF0000E8FF0000F0FF7878F9FF7878F9FFCACA
      FBFFE9E9FAFFE1E2FAFF8B8BF6FF4443F3FF4443F3FF3A3AEFFF3535EFFF2F2F
      EEFF2A2AECFF2424ECFF4242ECFF0000D0FF0000E0FF7987F1FF5D6DECFF5D6D
      ECFF5D6DECFF5666EBFF5263EAFF546EE9FF506EE5FF4658E5FF3E50E4FF3E50
      E4FF3548E3FF2E41E2FF4658E5FF0000BFFF006A00FF77BB78FF67B568FF5BCF
      9DFF78F9F3FF86FDFDFF79FDFDFF79FDFDFF71FCFCFF71FCFCFF69FAFAFF69FA
      FAFF61F7F7FF61F7F7FF74F7F7FF00D5EBFF008900FF79C979FF5ABD5AFF5ABD
      5AFF5ABD5AFF53BA53FF50B650FF4BB44BFF4ACA71FF45D7C9FF405C62FFE0DF
      DFFF473F3FFF2F4449FF486064FF006CC7FF0000F0FF8F8FF8FF7876F6FF7574
      F6FF6F6EF5FF7271F5FF6463F2FF6463F2FF6463F2FF5A59F1FF5A59F1FF5351
      EEFF5150F0FF4C4BEDFF6463EEFF0000D0FF0000E0FF7987F1FF7987F1FF7987
      F1FF7987F1FF7987F1FF7987F1FF7BDDF2FF7BDDF2FF687BE8FF5D6DECFF5D6D
      ECFF5666EBFF5364E7FF4D5EE9FF0000BFFF006A00FF7AC88EFF7AEAD4FF79FD
      FDFF79FDFDFF71FCFCFF71FCFCFF71FCFCFF69FAFAFF5FFBFBFF5FFBFBFF5FFB
      FBFF52F8F8FF52F8F8FF52F8F8FF00D5EBFF008100FF79C979FF79C979FF79C9
      79FF76C876FF72C671FF72C671FF6DC36DFF68BF68FF64C770FF64E1C6FF5B81
      86FF596467FF505051FF505051FF000000FFFFD9C1FFFFEFE5FFFFEFE5FFFFEF
      E5FFFFEFE5FFFEEDE2FFFEEDE2FFFEEDE2FFFCEADFFFFCEADFFFFAE8DCFFFAE8
      DCFFF9E5D9FFF9E5D9FFF7E2D5FFEBBB9DFF0000DBFF0000DBFF0000DBFF0000
      DBFF0000DBFF0000DBFF0000DBFF0000DBFF0000DBFF0000CCFF0000CCFF0000
      CCFF0000CCFF0000CCFF0000BFFF0000BFFF00A74EFF00D5EBFF00DAF1FF00DA
      F1FF00DAF1FF00DAF1FF00DAF1FF00DAF1FF00DAF1FF00DAF1FF00DAF1FF00DA
      F1FF00D5EBFF00D5EBFF00D5EBFF00D5EBFF009600FF008900FF008900FF0089
      00FF008900FF008100FF008100FF008100FF007300FF007300FF007300FF0096
      00FF00B39EFF000000FF000000FF000000FFFF7C30FFFF7423FFFF7423FFFF74
      23FFFF7423FFFD6B15FFFD6B15FFFD6B15FFF75C03FFF75C03FFF75C03FFF75C
      03FFF14A00FFF14A00FFEE4100FFF14A00FFEBEBEBFFE9E9E9FFE7E7E7FFE5E5
      E5FFE2E3E1FFDFDFDFFFDDDDDDFFDBDBDBFFD9D9D9FFD7D7D7FFD5D5D5FFD3D3
      D3FFD1D1D1FFCFCFCFFFCFCFCFFFCFCFCFFF006C00FF006C00FF006C00FF006C
      00FF004E00FF004E00FF004E00FF004E00FF004E00FF003000FF003000FF0030
      00FF003000FF003000FF003000FF003000FF0000E4FF0000E4FF0000E4FF0000
      DBFF0000DBFF0000DBFF0000D4FF0000D4FF0000D4FF0000D4FF0000CCFF0000
      CCFF0000CCFF0000C7FF0000C7FF0000C7FFA70000FFA70000FFA70000FF9B00
      00FF9B0000FF9B0000FF9B0000FF880000FF880000FF880000FF880000FF7900
      00FF790000FF790000FF790000FF790000FFEDEDEDFFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF5F5F7FFF5F5F7FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF2F2F2FFCFCFCFFF006C00FF65BF65FF65BF65FF5CBA
      5CFF5CBA5CFF53B653FF53B653FF48B347FF48B347FF40AC41FF40AC41FF40AC
      41FF37A837FF37A837FF37A837FF003000FF0000E4FF6262F4FF5C5CF2FF5757
      F2FF5453F1FF4E4EEFFF4949EFFF4343EDFF4343EDFF3A3AECFF3A3AECFF3535
      E9FF3030E9FF3030E9FF2B2BE7FF0000C7FFB40000FFDC7E67FFDA7B63FFD877
      5EFFD7745AFFD56F55FFD36B50FFD1674CFFCD6248FFCD6248FFC85B45FFCB58
      3AFFCB583AFFC95334FFC95334FF790000FFEFEFEFFFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF7F7F7FFA1A1F7FF5A5AF6FF5454F5FF9393F4FFF1F1F1FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCFCFCFFF006C00FF6CC36BFF48B347FF41B0
      3CFF3AB036FF3AB036FF41B03CFF3B856EFF3B856EFF33A42BFF1FA118FF119C
      0EFF119C0EFF119C0EFF37A837FF003000FF0000EBFF6262F4FF4444F1FF3E3D
      EFFF3A3AECFF3535EFFF2D37EDFF2967F0FF225EEEFF1E29EAFF1919E8FF1212
      E7FF0C0CE5FF0C0CE5FF3030E9FF0000C7FFA70000FFDA8774FFCC6956FFCA63
      50FFCA6350FFC85B45FFC85B45FFC3533EFFC14E38FFBD462EFFBD462EFFBD46
      2EFFB63923FFB63923FFBF5441FF790000FFF1F1F1FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFF9596F9FF3333F8FF2E2EF7FF2929F6FF2323F5FF7C7CF4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFD3D3D3FFBFD7D5FFF4F6F7FFF0F4F4FFF0F4
      F4FFEDF2F1FFEDF2F1FFCED9E0FF6A69E1FF6A69E1FFC8D3DBFFE5EBEAFFE5EB
      EAFFE5EBEAFFE2E8E7FFE5EBEAFF8FAFABFF0000EBFF6A6AF5FF4949F2FF4444
      F1FF3E3DEFFF3940F0FF3A9EF6FF2CC6F6FF2CC6F6FF2C97F3FF1E29EAFF1919
      E8FF1212E7FF0C0CE5FF3030E9FF0000CCFF0000BEFF6969E1FF4748D8FF4546
      D8FFE6E6F5FFF6F6F9FFECECF6FFF8F8F8FFF5F5F5FFECECF6FFF5F5F5FFDDDD
      F2FF1617C8FF1617C8FF3131CEFF000091FFF1F1F1FFFDFDFDFFFCFCFCFFFBFC
      FBFFE9E9FCFF4747FAFF3A3AF9FF3434F8FF2E2EF7FF2929F6FF2929F5FFD6D6
      F7FFF3F3F3FFF2F2F2FFF4F4F4FFD3D3D3FF0000E4FF7976F3FF5955F0FF5450
      EEFF504AEDFF504AEDFF35344FFF4A46DDFF413CE2FF35344FFF2B25E4FF231C
      E1FF231CE1FF1E16E0FF3C36E6FF0000BDFF0000EBFF706FF6FF4E4EF3FF4949
      F2FF4444F1FF3F72F4FF39C0F8FF2C97F3FF2C97F3FF29B7F4FF2967F0FF2222
      EAFF1919E8FF1212E7FF3535E9FF0000CCFF0000BEFF6E6EE0FF4E4ED9FF4748
      D8FF5757DDFFF6F6F9FFE8E8F7FFF8F8F8FFF2F2F7FFE3E3F3FFF5F5F5FF3939
      D1FF1617C8FF1617C8FF3131CEFF000091FFF3F3F3FFFEFEFEFFFDFDFDFFFCFC
      FCFFD6D6F7FF4545FBFF4040FAFF3A3AF9FF3535F8FF2E2EF7FF2A2AF6FFBBBB
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFD5D5D5FF0000E4FF7976F3FF5955F0FF5450
      EEFF504AEDFF4B46EAFF3F3F5FFF4A46DDFF4A46DDFF35344FFF322CE5FF2B25
      E4FF231CE1FF231CE1FF413CE2FF0000BDFF0000EBFF706FF6FF5252F4FF4E4E
      F3FF4949F2FF4592F7FF42CAF9FF3885F4FF3885F4FF32C3F6FF2A85F1FF2222
      EAFF2222EAFF1919E8FF3A3AECFF0000CCFF0000BEFF6E6EE0FF5151DBFF4E4E
      D9FF5151DBFFE8E8F7FFA3A3E8FFE6E6F5FFE6E6F5FF9B9BE5FFE3E3F3FF3131
      CEFF1617C8FF1617C8FF3939D1FF000091FFF5F5F5FFFEFEFEFFFEFEFEFFFDFD
      FDFFE9E9FCFF5454FCFF4545FBFF4040FAFF3A3AF9FF3535F8FF3535F8FFD6D6
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFD7D7D7FF0000E4FF7976F3FF6460F3FF605C
      F2FF5955F0FF5955F0FF4C4C6FFF4A46DDFF4B46EAFF3F3F5FFF3C36E6FF322C
      E5FF2B25E4FF2B25E4FF4B46EAFF0000BDFF0000EFFF7575F7FF5858F5FF5353
      F4FF4E4EF3FF4A7CF6FF42CAF9FF3A9EF6FF3A9EF6FF32C3F6FF2967F0FF2A2A
      ECFF2222EAFF2222EAFF3E3DEFFF0000D4FF0000C3FF7575E3FF5757DDFF5151
      DBFF5151DBFF8081E5FF595ADDFFDDDDF2FFDDDDF2FF4748D8FF6E6EE0FF3131
      CEFF2525CDFF2525CDFF4141D3FF000091FFF5F5F5FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFAAAAFDFF4A4AFCFF4545FBFF4040FAFF3B3BF9FF9596F9FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFDBDBDBFFCACACDFFF4F6F7FFF3F3F5FFF3F3
      F5FFF3F3F5FFF1F1F3FFD8D8E7FF7C7CE7FF7C7CE7FFD8D8E7FFEAEAEDFFEAEA
      EDFFEAEAEDFFE7E7EBFFEAEAEDFF9D9DB1FF0000EFFF7878F7FF5C5CF6FF5858
      F5FF5353F4FF5054F4FF4AA5F8FF44D6FAFF44D6FAFF3A9EF6FF353FEFFF3030
      EDFF2A2AECFF2222EAFF4343EDFF0000D4FF0000C3FF7575E3FF595ADDFF5757
      DDFF5151DBFF5151DBFF4A4AD7FF6161DCFF6161DCFF3939D1FF3939D1FF3131
      CEFF2525CDFF2525CDFF4141D3FF000091FFF5F5F5FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFBBBBFDFF7E7DFCFF7878FBFFAFAFFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFDDDDDDFF000000FF797A7AFF5C5C5CFF5C5C
      5CFF575758FF5B5B56FFCACACDFF5A5A82FF5A5A82FFCACACDFF474744FF3030
      30FF303030FF303030FF474744FF000000FF0000F1FF7A7AF8FF5C5CF6FF5C5C
      F6FF5858F5FF5353F4FF5058F4FF4976F5FF4976F5FF4147F2FF3E3DEFFF3535
      EFFF3030EDFF2A2AECFF4949EFFF0000D4FFBC0400FFE29482FFD57B6AFFD57B
      6AFFD57B6AFFD27362FFD27362FFCD6C5BFFCC6956FFCA6350FFCA6350FFC85B
      45FFC85B45FFC3533EFFCC6956FF880000FFF5F5F5FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDFDFDFFF000000FF797A7AFF797A7AFF797A
      7AFF747474FF747474FF747474FF676767FF676767FF676767FF676767FF5C5C
      5CFF575758FF505050FF505050FF000000FF0000F1FF7A7AF8FF7A7AF8FF7878
      F7FF7575F7FF7575F7FF706FF6FF6A6AF5FF6A6AF5FF6262F4FF6262F4FF5C5C
      F2FF5757F2FF5252F0FF4E4EEFFF0000DBFFBC0400FFE29482FFE29482FFE294
      82FFE18F78FFE18F78FFE18F78FFDA8774FFDD856CFFDD856CFFDC7E67FFDA7B
      63FFD8765EFFD7745AFFD56F55FF9B0000FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF3F3F3FFF3F3F3FFF1F1F1FFEFEFEFFFEFEFEFFFEDEDEDFFEBEB
      EBFFE9E9E9FFE7E7E7FFE5E5E5FFE2E3E1FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000F1FF0000F1FF0000F1FF0000
      F1FF0000EFFF0000EFFF0000EBFF0000EBFF0000EBFF0000EBFF0000E4FF0000
      E4FF0000E4FF0000E4FF0000DBFF0000DBFFBF0C00FFBC0400FFBC0400FFBC04
      00FFBC0400FFB40000FFB40000FFB40000FFB40000FFB40000FFA70000FFA700
      00FFA70000FFA70000FF9B0000FF9B0000FF770000FF770000FF770000FF7700
      00FFECEDECFF0000C1FFECEDECFF580000FF580000FF580000FF460000FF4600
      00FF460000FF460000FF460000FF460000FF007500FF006400FF006400FF0056
      00FF005600FFCDCDCDFFC8C8C8FFC8C8C8FFC2C2C2FFC2C2C2FFC2C2C2FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF00B7F1FF00ABD6FF008101FF004F
      00FF004F00FF004F00FF004F00FF004F00FF003600FF003600FF003600FF0036
      00FF003600FF004F00FF058AB3FF0093DDFF000092FF005200FF005F00FF005F
      00FF005200FF005200FF005200FF004600FF004600FF003700FF003700FF0037
      00FF002A00FF002A00FF002A00FF002A00FF830900FFCA9570FFC9936CFFC68F
      69FFF9F9F9FF5455E7FFF7F7F7FFBE8257FFBB7E54FFB97A4FFFB9774BFFB574
      49FFB37246FFB36F42FFB16E3FFF460000FF006E00FF60BF5FFF5BBD5BFF58BA
      57FF54B653FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF000E28FF6ED9F3FF58E3FCFF57CF
      C0FF58BB68FF4EB54EFF46B248FF46B248FF3DAD44FF3AAA3AFF3AAA3AFF3DAD
      44FF35C0A6FF2DD1F5FF22C1E7FF000000FF0000FBFF616BE8FF5C9B94FF61BE
      61FF5BBA5BFF5BBA5BFF52B552FF52B552FF47B147FF47B147FF40AD41FF40AD
      41FF3AAA3AFF37A737FF37A737FF002A00FF8B1500FFCB9975FFBE8257FFBE7E
      53FFF9F9F9FF393AE3FFF7F7F7FFB36D3DFFB16939FFAF6534FFAC602DFFA85C
      28FFA85C28FFA55722FFB36F42FF460000FF007500FF67C267FF41AF42FF41AF
      42FF39AA39FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF4F4F4FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF000000FF6F7273FF41ADC7FF42DD
      FBFF39D2E4FF38B771FF2CA634FF22A022FF22A022FF22A022FF18A95CFF12C5
      D7FF06CFF8FF058AB3FF27474FFF000000FF0000FBFF6565FCFF4343FBFF3E68
      B5FF47B147FF40AD41FF3AAA3AFF34A934FF2FA62FFF27A227FF27A227FF209F
      20FF1A9B19FF1A9B19FF3AAA3AFF002A00FF8B1500FFCD9C79FFC2875DFFBE82
      57FFFAFAFAFF4142E4FFF8F8F8FFB67143FFB36D3DFFB16939FFAF6534FFAC60
      2DFFAC602DFFA85C28FFB37246FF460000FF007C00FF67C267FF48B448FF41AF
      42FF41AF42FFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000E0FF000000FF6F7273FF494A4AFF4485
      95FF3ECFF2FF36D9F8FF35C0A6FF2CA634FF2CA634FF23BA9BFF1ED3F4FF22C1
      E7FF136479FF181818FF2C2F30FF000000FF0000FBFF6C6CFDFF4949FCFF4343
      FBFF4952DDFF918EF9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFCFCFCFFFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFF4647E7FFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF4F4F4FFF4F4
      F4FFF4F4F4FFF2F2F2FFF4F4F4FFE5E5E5FF007C00FF73C673FF4EB64EFF48B4
      48FF41AF42FFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E6FF000000FF6F7273FF494A4AFF494A
      4AFF49656BFF41ADC7FF36D9F8FF37CCD4FF37CCD4FF2DD1F5FF27A4C2FF2747
      4FFF181818FF181818FF2C2F30FF000000FF0000FBFF6C6CFDFF8C8CFCFF4E4E
      FCFF4343FBFF4843FAFF918EF9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD1D1D1FF0000DBFF7778EFFF5A5BEBFF5557
      EAFF5052E9FF4B4CE7FF4647E7FF4142E4FF393AE3FF393AE3FF3132E1FF2627
      DEFF2627DEFF2627DEFF4142E4FF0000B3FF008500FF73C673FF53B953FF4EB6
      4EFF4AB34AFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FF2424
      F5FF1E1EF4FF1818F3FF3C3CF5FF0000E6FF000000FF6F7273FF575858FF494A
      4AFF494A4AFF494A4AFF45BBD7FF36D9F8FF36D9F8FF2FB2D2FF2C2F30FF2C2F
      30FF181818FF181818FF2C2F30FF000000FF0000FBFF9A9AFEFFFCFCFCFF9090
      FCFF4949FCFF4343FBFF4343FBFF8C8CFCFFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFD1D1D1FFFDFDFDFFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFF5052E9FFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF4F4F4FFF4F4F4FFF4F4F4FFE5E5E5FF008500FF73C673FF57BC57FF53B9
      53FF4EB64EFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FF2A2A
      F6FF2424F5FF1E1EF4FF3C3CF5FF0000E6FF000000FF6F7273FF575858FF5758
      58FF49656BFF45BBD7FF42DDFBFF37CCD4FF37CCD4FF36D9F8FF2FB2D2FF2747
      4FFF2C2F30FF181818FF494A4AFF000000FF0000FBFF7878FAFF8C8CFCFF5555
      FDFF4E4EFCFF5555FDFF9F9DFCFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD6D6D6FF972C00FFD3A687FFC9936CFFC68F
      69FFFDFDFDFF5557EAFFFCFCFCFFC08359FFBE7E53FFBC7B50FFB9774BFFB774
      45FFB57040FFB36D3DFFBE8257FF580000FF008500FF78C878FF5BBD5BFF58BA
      57FF54B653FFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FF3030
      F7FF2A2AF6FF2424F5FF4343F6FF0000E6FF000000FF6F7273FF575858FF5899
      A9FF53DDFAFF53DDFAFF50CBB1FF46B248FF46B248FF35C0A6FF36D9F8FF2DD1
      F5FF2A7B91FF2C2F30FF494A4AFF000000FF0000FFFF7878FAFF5B5BFEFF5B5B
      FEFF4952DDFF9F9DFCFFFCFCFCFFFAFAFAFFFAFAFAFFFAFAFAFFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD6D6D6FF992E00FFD4A889FFCA9570FFC993
      6CFFFEFEFEFF5A5BEBFFFDFDFDFFC2875DFFC08359FFBE7E53FFBC7B50FFB977
      4BFFB77445FFB57040FFC08359FF650000FF008900FF7ACA7AFF60BF5FFF5BBD
      5BFF58BA57FFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FF3636
      F8FF3030F7FF2B2BF6FF4B4BF7FF0000E6FF000000FF798D92FF5EBFD6FF58E3
      FCFF58DBE6FF53C385FF4EB54EFF4EB54EFF46B248FF3DAD44FF38B771FF37CC
      D4FF36D9F8FF27A4C2FF49656BFF000000FF0000FFFF7878FAFF5B5BFEFF5B5B
      BCFF5A5A5FFF525252FF525252FF4B4B4BFF444444FF444444FF333333FF3333
      33FF333333FF333333FF4B4B4BFF000000FF992E00FFD4A889FFD4A889FFD3A6
      87FFFEFEFEFF7778EFFFFDFDFDFFCD9C79FFCD9C79FFCB9975FFCA9570FFC993
      6CFFC68F69FFC28A62FFC2875DFF650000FF008500FF7ACA7AFF7ACA7AFF78C8
      78FF78C878FFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFF5B5B
      FAFF5454F9FF5454F9FF4B4BF7FF0000ECFF003A54FF6ED9F3FF7AEAFFFF78D9
      C8FF76C982FF6EC46EFF6EC46EFF6EC46EFF6EC46EFF62BE62FF62BE62FF58BB
      68FF50CBB1FF53DDFAFF4DCFEEFF000000FF0000FFFF7878FAFF7A7AA4FF7878
      78FF787878FF737373FF737373FF6A6A6AFF6A6A6AFF626262FF626262FF5A5A
      5FFF565657FF525252FF4B4B4BFF000000FF992E00FF992E00FF992E00FF992E
      00FFFDFDFDFF0000DBFFFDFDFDFF8B1500FF8B1500FF8B1500FF830900FF7700
      00FF770000FF770000FF770000FF650000FF009100FF008900FF008900FF0085
      00FF008500FFE5E5E5FFE2E2E2FFE2E2E2FFDEDEDEFFDEDEDEFFDBDBDBFF0000
      F3FF0000F3FF0000F3FF0000ECFF0000ECFF06CFF8FF00C3E5FF009B36FF0081
      01FF008101FF008101FF008101FF008101FF007000FF007000FF007000FF0070
      00FF007000FF007000FF00ABD6FF00B7F1FF000092FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF006B00FF005700FF005700FF0057
      00FF004600FF004600FF004600FF003700FF003700FF003700FF002800FF0028
      00FF002800FF001F00FF001F00FF001F00FF6D0000FF6D0000FF6D0000FF6D00
      00FF6D0000FF4D0000FF4D0000FF4D0000FF4D0000FF4D0000FF4D0000FF4D00
      00FF4D0000FF310600FF310600FF310600FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000F2FF0000F2FF0000F2FF0000
      F2FF0000EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000E1FF0000E1FF0000
      E1FF0000E1FF0000DDFF0000DDFF0000DDFF006B00FF80BE80FF7ABB7AFF7ABB
      7AFF72B672FF72B672FF6AB26AFF6AB26AFF62AD62FF62AD62FF5BA95BFF5BA9
      5BFF57A657FF53A453FF53A453FF001F00FFB6645CFFEBD5D4FFDDC0BBFFE2C6
      C4FFEEE0DEFFDBB5B0FFE2C6C4FFECDCDBFFD4ACA8FFE2C6C4FFD4ACA8FFDAB8
      B5FF4C6CACFFCDA19DFFDAB8B5FFBA9790FF000000FF636262FF5A5A5AFF5A5A
      5AFF525151FF525151FF454545FF454545FF454545FF3B3B3BFF3B3B3BFF3333
      33FF333333FF2B2B2BFF2B2B2BFF000000FF0000F8FF6564FCFF5A5AFAFF5A5A
      FAFF4F4FF8FF4F4FF8FF4F4FF8FF4343F7FF4343F7FF3A3AF5FF3A3AF5FF3232
      F4FF3232F4FF2C2CF3FF2C2CF3FF0000DDFF006B00FF86C286FF6AB26AFF62AD
      62FF62AD62FF5BA95BFF57A657FF53A453FF4DA24DFF489F48FF429B42FF429B
      42FF3A963AFF3A963AFF53A453FF001F00FF880100FFC38789FFBA6D65FFB664
      5CFFB6645CFFB35F57FFB05850FFB05850FFAC5149FFA94A42FFA94A42FF63A5
      B2FF38CCEEFF44C9DDFFB05850FF310600FF000000FF636262FF454545FF3B3B
      3BFF3B3B3BFF333333FF2B2B2BFF2B2B2BFF2B2B2BFF131313FF131313FF1313
      13FF131313FF131313FF2B2B2BFF000000FF0000F8FF6564FCFF4343FAFF4343
      FAFF3B3BF9FF3636F8FF3232F4FF2C2CF3FF2424F5FF2424F5FF1414F2FF1414
      F2FF1414F2FF1414F2FF3232F4FF0000DDFF006B00FF86C286FF6AB26AFF6AB2
      6AFF62AD62FF62AD62FF5BA95BFF57A657FF53A453FF4DA24DFF489F48FF429B
      42FF429B42FF3A963AFF57A657FF002800FFBA6D65FFEBD8D7FFDAB8B5FFDDC0
      BBFFECDCDBFFD4ACA8FFDDC0BBFFEBD8D7FFCDA19DFFDDC0BBFFCDA19DFF79CD
      DDFF464BCCFF48D2EDFFDAB8B5FFBA9790FF2B2B2BFFA0A0A0FF8D8B8DFF8D8B
      8DFF888588FF848284FF7C7A7CFF7C7A7CFF777577FF727172FF6F6D6FFF6B68
      6BFF6B686BFF636262FF7C7A7CFF000000FF8484F2FFE5E5FCFFBABAFAFFD4D4
      FAFFBABAFAFFD4D4FAFFB6B5F9FFCDCCF6FFABABF4FFCDCCF6FFABABF4FFC5C5
      F3FFA5A5F2FFC5C5F3FFABABF4FF8484F2FFFDFDFDFFFDFDFDFFFDFCFBFFFBFC
      FBFFFCFBFBFFFAFAFAFFE3CCC7FFC7927EFFC7927EFFDCC1BCFFF5F4F4FFF5F4
      F4FFF4F3F3FFF3F2F2FFF5F4F4FFE5E4E3FF880100FFC38789FFBA6D65FFBA6D
      65FFBA6D65FFB6645CFFB6645CFFB35F57FFB05850FFB05850FFAC5149FF464B
      CCFF38CCEEFF464BCCFFB35F57FF4D0000FFFDFDFDFFFDFDFDFFFDFDFDFFACDC
      ABFFE6F5E6FFE6F5E6FFF0F9F1FFBDE3BDFFBDE3BDFFEAF5EAFFEAF5EAFFEAF5
      EAFF96CF95FFF4F4F3FFF4F4F3FFE5E5E5FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFF8484F2FF8484F2FFF2F1F7FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE5E5E5FFFDFDFDFFFDFDFDFFFDFCFBFFFCFB
      FBFFFCFBFBFFFCFBFBFFD2A798FFDCC1BCFFBD8C83FFCC9A87FFF6F6F6FFF5F4
      F4FFF4F3F3FFF3F2F2FFF5F4F4FFE5E4E3FFA881ACFFE5D3DBFFF1E0E0FFDCCE
      E0FFB9A5D3FFE2C6C4FFEEE0DEFFC38789FFD4ACA8FFE2C6C4FF56A475FFC3B1
      A6FF4C6CACFFBA9790FF61A87DFFCDA19DFFFDFDFDFFFDFDFDFFB6E1B4FF8ED0
      8CFFACDCABFFC2E2BEFFD6ECD4FF8ED08CFF8ED08CFFCDE7CAFFC2E2BEFF8ED0
      8CFF83C881FF96CF95FFF4F4F3FFE5E5E5FFFDFDFDFFFDFDFDFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFF9696F9FFA2A2F9FFBABAFAFF9696F9FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE5E5E5FFFDFCFBFFFDFDFDFFFDFDFDFFFDFC
      FBFFFDFCFBFFFDFCFBFFDAB3A1FFD2A798FFE3CCC7FFD2A798FFF6F6F6FFF6F6
      F6FFF5F4F4FFF4F3F3FFF5F4F4FFE5E4E3FFC38F99FFDBD4EDFFCEABB8FFB9A5
      D3FFB9A5D3FFDBB5B0FFCCC3E2FFC38789FFB6645CFFB35F57FFB35F57FF5D9B
      6FFF4C6CACFF4A9B6BFFBA6D65FF4D0000FFFDFDFDFFFDFDFDFFFCFDF9FFB6E1
      B4FFFDFDFDFFFCFDF9FFF9FAF6FFC5E6C2FFC5E6C2FFF9FAF6FFF1F6EEFFF1F6
      EEFF9ED29CFFF4F4F3FFF4F4F3FFE5E5E5FFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFCFCFCFFFCFCFCFFF6F5FAFFB6B5F9FFB6B5F9FFF2F1F7FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FF35D4FBFFA4EDFEFF8CE7FDFF8CE7
      FDFF8CE7FDFF8CE7FDFF95CDD6FFB7ABA3FFB7ABA3FF95CDD6FF72E1FCFF6CDB
      F6FF6CDBF6FF6CDBF6FF7DDEF5FF00B1E7FF724CA9FFD8D6F7FFE7E7FAFFBABA
      F9FFA1A0F5FFD8D6F7FFD1CCF1FFC38789FFD4ACA8FFE2C6C4FF61A87DFF56A4
      75FF56A475FF56A475FF88B698FFCDA19DFF3737FBFFA4A4FEFF9190FEFF918F
      FEFF8A8AFDFF8A8AFDFF8584FCFF8584FCFF7E7EF8FF7979F9FF7676F8FF7170
      F7FF7170F7FF6969F5FF7E7EF8FF0000EBFFB9E3B9FFCCE8CCFFD7EED7FFB9E3
      B9FFD7EED7FFB9E3B9FFD7EED7FFB4DFB3FFCCE8CCFFB1DEAFFFCCE8CCFFA7D7
      A7FFCBE5CBFFA7D7A7FFCBE5CBFF3EA33EFF00BFFFFF79E4FFFF5BDDFDFF5BDD
      FDFF5BDDFDFF53DAFBFF53DAFBFF4BD8FCFF44D6FBFF44D6FBFF3CD4F9FF35D4
      FBFF30D0F7FF2BCEF6FF4BD6F7FF009BEBFF5E5EF5FFBABAF9FFA4A7FDFF999C
      FBFF999CFBFFA4A7FDFFA1A0F5FFA881ACFFBA6D65FFBA6D65FFB6645CFF61A8
      7DFF56A475FF5D9B6FFF6FAC85FF4D0000FF0000FFFF797AFFFF5B5BFDFF5B5B
      FDFF5B5BFDFF5353FBFF5353FBFF4B4BFCFF4444FBFF4444FBFF3737FBFF3737
      FBFF2E2EF7FF2E2EF7FF4B4BF7FF0000EBFF008900FF7ACA7AFF61BE61FF5BBC
      5BFF5BBC5BFF56BA56FF50B851FF50B851FF49B449FF49B449FF3BAE3BFF3BAE
      3BFF2FA830FF2FA830FF49B449FF004B00FF00BFFFFF79E4FFFF79E4FFFF79E4
      FFFF79E4FFFF72E1FCFF72E1FCFF6CE0FDFF68DFFCFF62DDFCFF62DDFCFF5BDD
      FDFF53DAFBFF53DAFBFF4BD6F7FF009BEBFF99465AFFE2DDF2FFF7F2F7FFD8D6
      F7FFBEB6E9FFE2DDF2FFE7E7FAFFCDA19DFFDDC0BBFFEBD5D4FFDDC0BBFF88B6
      98FF9CC5AAFF88B698FFDAC5C1FFD4ACA8FF0000FFFF797AFFFF797AFFFF797A
      FFFF7575FEFF7575FEFF706FFDFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5B5B
      FDFF5353FBFF5353FBFF4B4BF7FF0000EBFF008400FF7ACA7AFF7ACA7AFF76C8
      76FF76C876FF72C571FF72C571FF6AC26AFF6AC26AFF61BE61FF61BE61FF5BBC
      5BFF56BA56FF52B652FF49B449FF004B00FF00BFFFFF00BFFFFF00BFFFFF00BF
      FFFF00BFFFFF00BBFDFF00BBFDFF00BBFDFF00B4FAFF00B4FAFF00B1F7FF00AB
      F4FF00ABF4FF00A4F0FF00A4F0FF009BEBFF8D7CD7FFAB748FFF880100FF5D2D
      99FF5D2D99FF880100FF5D2D99FF8B263EFF880100FF880100FF6D0000FF6D00
      00FF310600FF6D0000FF6D0000FF6D0000FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000EBFF0000EBFF008900FF008900FF008900FF0089
      00FF008900FF008400FF008400FF007600FF007600FF007600FF007600FF0063
      00FF006300FF006300FF006300FF006300FF003700FF003700FF003700FF0024
      00FF002400FF002400FF000C00FF000C00FF000C00FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFF5F5F5FFF3F3F3FFF1F1F1FFEEEE
      EEFFEEEEEEFFEEEEEEFFEAEAEAFFEAEAEAFFE6E6E6FFE6E6E6FFE3E3E3FFE0E0
      E0FFE0E0E0FFDDDDDDFFDDDDDDFFDDDDDDFF007900FF006700FF006700FF0056
      00FF005600FFB0BEBEFFD0D0D0FFD0D0D0FFCACACAFFCACACAFFB0BEBEFF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFFDBDBDBFFDBDBDBFFD7D7D7FFD5D5
      D5FFD3D3D3FFCECECEFFCECECEFFCBCBCBFFC7C7C7FFC5C5C5FFC2C2C2FFC2C2
      C2FFBFBFBFFFBDBDBDFFBBBBBBFFBBBBBBFF004700FF61AD60FF61AD60FF53A5
      53FF53A553FF53A553FF4A9F4AFF449E44FF3F9A3FFF3C983CFF399639FF3394
      33FF319032FF2D8E2DFF2D8E2DFF000000FFF7F7F7FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF2F2F2FFDDDDDDFF006700FF61BF61FF5BBD5BFF58BA
      57FF54B553FFEAF3EAFFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFE4EBF4FF327E
      F4FF327EF4FF2D7BF2FF2D7BF2FF0000DDFFDF2400FFFBA582FFFBA582FFFAA2
      7DFFF99E79FFF89A74FFF79872FFF69169FFF69169FFF69169FFF68B64FFF588
      60FFF3855AFFF3855AFFF3855AFFC50000FF004700FF61AD60FF449E44FF3F9A
      3FFF399639FF339433FF2E912EFF298E29FF238B23FF1E871EFF188418FF1381
      13FF0D7C0DFF0D7C0DFF2D8E2DFF000000FFF9F9F9FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFE0E0E0FF007900FF61BF61FF44B144FF3EAE
      3FFF39AA39FFEAF3EAFFF7F7F7FFF6F6F6FFF5F5F5FFF5F5F5FFE4EBF4FF116A
      F2FF0C67F1FF0C67F1FF2D7BF2FF0000E0FFE1E1E1FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFBDBDBDFF004700FF69B369FF48A148FF449E
      44FF3F9A3FFF399639FF339433FF2E912EFF298E29FF238B23FF1E871EFF1884
      18FF138113FF0D7C0DFF319032FF000000FFFBFBFBFFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFE0E0E0FF007900FF6CC46CFF49B449FF44B1
      44FF3EAE3FFFEAF3EAFFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFE4EBF4FF176E
      F3FF116AF2FF116AF2FF327EF4FF0000E0FFE3E3E3FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF79481FFF79481FFF5F5F5FFF4F2F2FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFBFBFBFFFFDFDFDFFFDFDFDFFFCFCFCFFFBFC
      FBFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE5E5E5FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFE3E3E3FF007900FF6CC46CFF4EB64EFF49B4
      49FF44B144FFEDF5EDFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFE4EBF4FF1E72
      F4FF176EF3FF176EF3FF3382F6FF0000E0FFE5E5E5FFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAAB95FFF98B6AFFF99D9DFFF78E75FFF3855AFFF59F86FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFC2C2C2FFFDFDFDFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFE5E5E5FF636BEBFFB9BDF6FFAAAEF3FFA6AA
      F2FFA6AAF2FFA1A7F0FF9DA2EFFF9DA2EFFF999EEBFF959AECFF9197EAFF8D93
      E9FF8D93E9FF888EE6FF999EEBFF0A17D5FF008700FF72C671FF53B853FF4EB6
      4EFF49B449FFEDF5EDFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFE8EFF7FF2275
      F5FF1E72F4FF176EF3FF3A85F4FF0000E8FFE7E7E7FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFAEEEEFFFA8F6FFFFAEEEEFFF8E9E9FFF58860FFF6E9E9FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFC5C5C5FFFDFDFDFFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FF0000DAFF7880EDFF5E67EAFF5A63
      E9FF545DE9FF525BE5FF4C55E5FF454FE3FF424CE2FF3C47E1FF3742E0FF313C
      DFFF2934DCFF2934DCFF454FE3FF0000BAFF008700FF76C876FF57BC57FF53B8
      53FF4EB64EFFEDF5EDFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFE8EFF7FF2A79
      F6FF2275F5FF1E72F4FF3E89F5FF0000E8FFE7E7E7FFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFCFDFFFEB397FFFB9473FFFA9983FFF99D9DFFF68B64FFFAA78AFFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFC7C7C7FF0000CDFF7878E9FF5C5CE4FF5858
      E4FF5454E2FF5050E1FF4B4BE1FF4646DFFF4141DEFF3C3BDCFF3636DAFF3030
      D9FF2929D6FF2929D6FF4343DBFF0000AAFF0000DEFF858CF0FF6A72ECFF666F
      EBFF636BEBFF5E67EAFF5A63E9FF5660E8FF525BE5FF4C55E5FF4852E3FF424C
      E2FF3C47E1FF3742E0FF525BE5FF0000BAFF008700FF79C979FF5BBD5BFF58BA
      57FF53B853FFF0F8F0FFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFEBF1F9FF327E
      F4FF2A79F6FF2579F5FF468EF7FF0000E8FFE9E9E9FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFFCFCFCFFFBA08AFFFA9F88FFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFCBCBCBFF0000CDFF7A7AEAFF5C5CE4FF5C5C
      E4FF5858E4FF5454E2FF5050E1FF4B4BE1FF4646DFFF4141DEFF3C3BDCFF3636
      DAFF3030D9FF2929D6FF4646DFFF0000AAFF0002DFFF878EF1FF6D75EDFF6A72
      ECFF666FEBFF636BEBFF5E67EAFF5A63E9FF5660E8FF525BE5FF4C55E5FF4852
      E3FF424CE2FF3C47E1FF5861E4FF0000BAFF008700FF79C979FF61BF61FF5BBD
      5BFF58BA57FFF0F8F0FFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFEBF1F9FF3682
      F8FF3382F6FF2B7BF6FF468EF7FF0000E8FFE9E9E9FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFCECECEFF0000CDFF7A7AEAFF7A7AEAFF7878
      E9FF7878E9FF7373E8FF7373E8FF6A6AE6FF6A6AE6FF6262E4FF6262E4FF5B5B
      E2FF5454E2FF5252DFFF4B4BDDFF0000AAFF0000DEFF878EF1FF878EF1FF858C
      F0FF838AF0FF7E86EFFF7E86EFFF7880EDFF7880EDFF7279ECFF6E76EAFF6A72
      ECFF666FEBFF6169E7FF5D65E6FF0000C4FF008700FF79C979FF79C979FF79C9
      79FF76C876FFFCFCFCFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFAFAFAFF5999
      FAFF5999FAFF5095F8FF5095F8FF0000E8FFE94606FFFEB397FFFEB397FFFEB3
      97FFFEB397FFFEB397FFFDAD8DFFFDAD8DFFFAA78AFFFAA78AFFFBA582FFFAA2
      7DFFF99E79FFF99E79FFF89A74FFC50000FF0000CDFF0000CDFF0000CDFF0000
      CDFF0000CDFF0000C6FF0000C6FF0000C6FF0000C6FF0000C6FF0000BCFF0000
      BCFF0000BCFF0000B5FF0000B5FF0000AAFF0A17D5FF0002DFFF0002DFFF0002
      DFFF0000DEFF0000DEFF0000DAFF0000DAFF0000DAFF0000D3FF0000D3FF0000
      D3FF0000CCFF0000CCFF0000CCFF0000C4FF009100FF008700FF008700FF0087
      00FF008700FFE6E7E6FFE6E7E6FFE6E7E6FFE6E7E6FFE3E3E3FFDBDFE1FF001F
      F4FF001FF4FF0015F0FF0015F0FF001AEDFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFE7E7E7FFE5E5E5FFE5E5E5FFE3E3E3FFE1E1E1FFDFDFDFFFDBDB
      DBFFDBDBDBFFD7D7D7FFD5D5D5FFD3D3D3FF0000E3FF0000DCFF0000DCFF0000
      D5FF0000D5FF0000D5FF0000CCFF0000CCFF0000C7FF0000C7FF0000C3FF0000
      C3FF0000C3FF0000BEFF0000BEFF0000C3FF7A0000FF8A0000FF7A0000FF7A00
      00FF720000FF720000FF720000FF660000FF660000FF660000FF510000FF5100
      00FF510000FF510000FF510000FF510000FFBA4500FFBA4500FFAE2F00FFAE2F
      00FFAE2F00FFAE2F00FFA41B00FFA41B00FF9D0F00FF9D0F00FF960500FF9605
      00FF910000FF910000FF910000FF910000FF0000E4FF0000E4FF0000E4FF0000
      D6FF0000D6FF0000D6FF0000D6FF0000D6FF0000D6FF0000CBFF0000CBFF0000
      CBFF0000CBFF0000C5FF0000C5FF0000C5FF0000DCFF6060F0FF5B5BEFFF5858
      F0FF5555EEFF4D4DECFF4949EBFF4444E9FF4141E8FF3D3CE9FF3939E7FF3333
      E5FF3333E5FF2D2DE3FF2D2DE3FF0000BEFF8A0000FFD48369FFD17D63FFD078
      5DFFD0785DFFCE7357FFCC6E51FFCA6A4DFFC66649FFC46243FFC46243FFC35C
      3CFFC35C3CFFBF5536FFBF5536FF510000FFBA4500FFE2B17CFFE2B17CFFDFAC
      76FFDFA972FFDEA76DFFDBA46BFFDBA267FFD89D62FFD99D5DFFD5995AFFD599
      5AFFD29454FFD29454FFD39350FF910000FF0000E4FF6372F4FF5867F2FF5867
      F2FF5867F2FF4F5FEFFF495AF1FF4556EEFF3F50EFFF3A4BEEFF3A4BEEFF3245
      EBFF3245EBFF2D3FEAFF2D3FEAFF0000C5FF0000E3FF6565F2FF4444EEFF3D3E
      ECFF3737EBFF3737EBFF5050F2FF3030E9FF2424E6FF5353F1FF1919E3FF1313
      E2FF0E0FE1FF0A0ADFFF2D2DE3FF0000BEFF8A0000FFD17D63FFC86242FFC35C
      3CFFC45736FFC25432FFBE4E2DFFBC4825FFBC4825FFB93F1AFFB93F1AFFB235
      0EFFB2350EFFB2350EFFBE4E2DFF510000FFC15300FFE4B585FFDBA267FFDBA0
      62FFD99D5DFFD5995AFFD69653FFD39350FFD3904BFFD18D47FFCE8941FFCC85
      39FFCC8539FFCC8539FFD29454FF910000FF0000E4FF6372F4FF4455F1FF3F50
      EFFF3A4BEEFF3245EBFF2D3FEAFF293BECFF2336EBFF1E31E9FF152BE8FF152B
      E8FF0D22E5FF0D22E5FF2D3FEAFF0000C5FF0000E3FF6969F2FF4849EFFF4444
      EEFF3D3EECFF4E4EF1FFD8D8F8FFCDCDF7FF8E8DF9FFE1E1F5FF3737EDFF1919
      E3FF1313E2FF0E0FE1FF3333E5FF0000C3FFCB9585FFF1D7CFFFEDCDC2FFEBCA
      C0FFEAC8BEFFE6C4B9FFE6C4B9FFE4C1B5FFE4C1B5FFE2BEB3FFE1BAAEFFE1BA
      AEFFDEB6AAFFDEB6AAFFE2BEB3FF9B503AFFC15300FFE4B585FFDEA76DFFDBA2
      67FFDBA062FFD99D5DFFAD7949FF2F2FF7FF2A2AF6FFAD7949FFD18D47FFCE89
      41FFCE8941FFCC8539FFD39657FF910000FF0000E4FF6978F5FF495AF1FF4455
      F1FF3F50EFFF3A4BEEFF3245EBFF2D3FEAFF293BECFF2336EBFF1E31E9FF152B
      E8FF152BE8FF0D22E5FF3245EBFF0000CBFF0000E9FF6D6DF2FF4E4EF1FF4849
      EFFF4444EEFF4040EDFFA9A9F9FFD1D1FAFFCDCDF7FFD8D8F6FF2B2BE9FF1E1E
      E4FF1919E3FF1313E2FF3333E5FF0000C3FFE6E6E6FFFEFEFEFFFCFCFCFFFCFC
      FCFFFAF4F3FFD99A86FFF9F9F9FFF8F8F8FFF8F8F8FFF6F6F6FFD69581FFF3EC
      EAFFF3F3F3FFF2F2F2FFF5F5F4FFC4C4C4FFFDFDFDFFFDFDFDFFFCFCFCFFFBFC
      FBFFFBFBFBFFF5F5F5FFCCCCF9FF3535F7FFC8C8F7FF2A2AF6FFEFEFEFFFF4F4
      F4FFF2F2F2FFF2F2F2FFF4F4F4FFE5E5E5FF0000FDFF6E7AFDFF4B5BFCFF4B5B
      FCFF4251FBFF4251FBFF3646F7FF3646F7FF2E3FF7FF2638F6FF2638F6FF1E31
      F4FF162AF3FF162AF3FF3646F7FF0000E4FF0000E9FF7170F3FF5353F1FF4E4E
      F1FF4B49EFFFA9A9F9FFEDEDFBFF9B9AFAFFA9A9F9FFC5C4F8FF7D7DF6FF2B2B
      E9FF1E1EE4FF1919E3FF3939E7FF0000C7FFE6E6E6FFFEFEFEFFFEFEFEFFFCFC
      FCFFFBFAFAFFF3ECEAFFFBFAFAFFE2B3A4FFE2B3A4FFF8F8F8FFF1E5E3FFF3F3
      F3FFF5F5F4FFF3F3F3FFF5F5F4FFC4C4C4FFFDFDFDFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFF6F6F6FF3F3FFAFFCCCCF9FF3535F7FFC8C8F7FFF2F2F2FFF5F5
      F5FFF4F4F4FFF2F2F2FFF5F5F5FFE5E5E5FFAF140AFFDC9A96FFD4837CFFD483
      7CFFD17C77FFCE7770FFCE7770FFCA706AFFC86A64FFC86A64FFC4625CFFC462
      5CFFBF5953FFBF5953FFCA706AFF780000FF0000E9FF7676F4FF5858F0FF5353
      F1FF5353F1FFD1D1FAFFBFBFFBFFCECDFAFFC5C4F8FFE7E7F8FFCDCDF7FF3737
      EBFF2424E6FF1E1EE4FF3D3CE9FF0000C7FFE6E6E6FFFEFEFEFFFEFEFEFFFEFE
      FEFFFAF4F3FFDFA897FFFBFAFAFFF9F9F9FFF9F9F9FFF8F8F8FFD99A86FFF3EC
      EAFFF5F5F4FFF5F5F4FFF5F5F4FFC4C4C4FFFDFDFDFFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFF6F6F6FFD0D0FBFF3F3FFAFFCCCCF9FF3535F7FFF2F2F2FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FFC41B00FFE69E90FFDF8875FFDE85
      72FFDD816DFFDD816DFFDA7C69FFDA7864FFD8745FFFD6705BFFD46C56FFD368
      51FFD0614AFFD0614AFFD5745FFF9E0000FF0000EBFF7979F5FF5C5CF2FF5858
      F0FF5555EEFF5555F4FF5353F1FFEDEDFBFFBFBFFBFF5555F4FF3D3EECFF3030
      E9FF2B2BE9FF2424E6FF4444E9FF0000CCFFCB9585FFF1D7CFFFEFD0C6FFEECF
      C5FFEDCDC2FFECCAC1FFEBCAC0FFEAC8BEFFE9C5BAFFE6C4B9FFE7BFB5FFE5BE
      B1FFE5BEB1FFE1BAAEFFE6C4B9FFA55A44FF0000FFFF7979FEFF5C5CFEFF5858
      FEFF5252FBFF5252FBFF4A4AFCFFD0D0FBFF3F3FFAFFCCCCF9FF3535F7FF2F2F
      F7FF2A2AF6FF2525F5FF4343F6FF0000EBFFC72502FFE8A394FFE28E7CFFE08A
      78FFDF8875FFDE8572FFDD816DFFDA7C69FFDA7864FFD8745FFFD6705BFFD46C
      56FFD36851FFD0614AFFD77966FF9E0000FF0000EBFF7979F5FF5C5CF2FF5C5C
      F2FF5858F0FF5353F1FF5050F2FF8E8DF9FF9B9AFAFF4040EDFF3D3CE9FF3737
      EBFF3030E9FF2B2BE9FF4949EBFF0000CCFF9A0300FFDA927AFFD0785DFFD078
      5DFFCE7357FFCE7357FFCC6E51FFCA6A4DFFC96647FFC86242FFC35C3CFFC457
      36FFC25432FFBE4E2DFFC96647FF660000FF0000FFFF7979FEFF5C5CFEFF5C5C
      FEFF5858FEFF5252FBFFDFA972FFDEC669FFDEA468FFDEC669FF3F3FFAFF3535
      F7FF2F2FF7FF2A2AF6FF4848F7FF0000EBFFC72502FFE8A394FFE28E7CFFE28E
      7CFFE08A78FFDF8875FFDE8572FFDD816DFFDA7C69FFDA7864FFD8745FFFD670
      5BFFD46C56FFD36851FFDA7C69FF9E0000FF0000E9FF7979F5FF7979F5FF7979
      F5FF7676F4FF7373F3FF7170F3FF6D6DF2FF6969F2FF6565F2FF6060F0FF5B5B
      EFFF5555EEFF5151EDFF4D4DECFF0000CCFFA11100FFDC9680FFDC9680FFDC96
      80FFDA927AFFDA927AFFDA927AFFD78B73FFD78B73FFD48369FFD48369FFD17D
      63FFD0785DFFCE7357FFCE7357FF720000FF0000FFFF7979FEFF7979FEFF7979
      FEFF7979FEFF7979FEFF7979FEFF7474FBFF7474FBFF6B6BFBFF6B6BFBFF6262
      FAFF6262FAFF5B5BF8FF5656F7FF0000EBFFC72502FFE8A394FFE8A394FFE8A3
      94FFE69E90FFE69E90FFE49A8BFFE49A8BFFE29585FFE29585FFE28E7CFFDE8B
      79FFDF8875FFDE8572FFDD816DFF9E0000FF0000EDFF0000EBFF0000EBFF0000
      EBFF0000E9FF0000E9FF0000E9FF0000E3FF0000E3FF0000E3FF0000DCFF0000
      DCFF0000DCFF0000D5FF0000D5FF0000D5FFA11100FFA11100FFA11100FFA111
      00FFA11100FF9A0300FF9A0300FF9A0300FF8A0000FF8A0000FF8A0000FF8A00
      00FF8A0000FF7A0000FF7A0000FF7A0000FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000EBFF0000EBFFC72502FFC72502FFC72502FFC725
      02FFC72502FFC41B00FFC41B00FFC01000FFC01000FFB80200FFB80200FFB802
      00FFAE0000FFAE0000FFAE0000FFAE0000FFF84700FFF53500FFF02C00FFEF23
      00FFEB1400FFD7CFCBFFD7D7D7FFD2D2D2FFD2D2D2FFCFCFCFFFCBC1BBFFE000
      00FFE00000FFDD0000FFDD0000FFDD0000FF0000F4FF0000F1FF0000F1FF0000
      EDFF0000EDFF0000EDFF0000E4FF0000E4FF0000E4FF0000DFFF0000DFFF0000
      DFFF0000DBFF0000DBFF0000DBFF0000DBFF0000F2FF0000F2FF0000F2FF0000
      F2FF0000F2FF004000FF004000FF004000FF004000FF004000FF004000FF002D
      00FF002D00FF002D00FF002D00FF002D00FF00040AFF00040AFF059405FF006D
      00FF004B00FF004B00FF004B00FF004B00FF004B00FF003100FF003100FF0031
      00FF003100FF003100FF003100FF003100FFF53500FFFCA96FFFFCA569FFF9A2
      65FFF89C5DFFFAF6F4FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4EFECFFF38A
      42FFF38A42FFF2873EFFF2873EFFDD0000FF0000F4FFFC957DFFFA9279FFF98F
      75FFF98C71FFFA896DFFF78468FFF78468FFF57C60FFF57C60FFF5785BFFF475
      58FFF37255FFF26F52FFF36E50FF0000DBFF0000F2FF6363FCFF5C5CFDFF5858
      FCFF5453FBFF4FAE5AFF48B248FF48B248FF40AB46FF3AAC3AFF3AAC3AFF34A9
      34FF31A632FF2BA42BFF2BA42BFF002D00FF0000D0FF8684BBFF6F999FFFC9EE
      DFFFCBE9CEFF76C373FF53B249FF44AD43FF44AD43FF41A93AFF33A734FF33A7
      34FF33A734FF2DA42CFF2DA42CFF003100FFF84700FFFCA96FFFFB9653FFFA92
      4CFFF88C43FFF8F4F1FFF7F7F7FFF6F6F6FFF5F5F5FFF5F5F5FFF4EFECFFF274
      21FFF27421FFF27421FFF2873EFFE00000FF0000F7FFFC9A83FFFB8265FFFA7D
      60FFF9785BFFF87558FFF67254FF5E56CFFF4265DDFFF26242FFF26242FFF25C
      39FFF25C39FFF25C39FFF26F52FF0000DBFF0000FDFF6363FCFF4646FBFF3C3C
      FAFF3C3CFAFF36A543FF2EA82EFF2BA42BFF23A223FF1EA01EFF189D18FF1399
      13FF0E970FFF0A950AFF2BA42BFF002D00FF0000FCFF6969FCFF4749B6FF4368
      71FF5CECE6FFBFF5F3FFC9EEDFFFB9DBC7FF4FAE43FF249D1DFF139612FF1396
      12FF139612FF059405FF2DA42CFF003100FFF84700FFFDAF79FFFB9B59FFFB96
      53FFFA924CFFFAF6F4FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4EFECFFF279
      28FFF27928FFF27421FFF38A42FFE00000FF0000F7FFFC9A83FFFC866AFFFB82
      65FFFA7D60FFF9785BFF6455CEFFA9747EFF41BCDAFF7A49A0FFF46646FFF262
      42FFF25C39FFF25C39FFF37255FF0000DBFF0000FDFF6969FCFF4646FBFF4646
      FBFF3C3CFAFF36A543FF34A934FF2EA82EFF2BA42BFF23A223FF1EA01EFF189D
      18FF139913FF0E970FFF31A632FF002D00FF0000FCFF6969FCFF4747FAFF4E4E
      DAFF3E4D6AFF39C0BAFF38F7F6FF59FAFAFFBFF5F3FFBFE8D5FF76C373FF41A9
      3AFF139612FF139612FF33A734FF003100FFFD5200FFFDAF79FFFC9E5DFFFB9B
      59FFFA924CFFFAF6F4FFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF4EFECFFF47D
      2DFFF37B2CFFF27928FFF48D46FFE00000FF0000FAFFFD9F89FFFA896DFFFC86
      6AFFFB8265FFFA7D60FF6562DFFFE96364FFA9838DFF5E56CFFFF56B4BFFF466
      46FFF26242FFF25C39FFF47558FF0000DFFF0000FDFF6E6EF6FF515164FF4E4E
      D8FF4646FBFF40AB46FF3AAC3AFF34A934FF2EA82EFF2BA42BFF23A223FF1EA0
      1EFF189D18FF139913FF34A934FF002D00FF0000FCFF6969FCFF4E4EF9FF4747
      FAFF4747FAFF3F3F76FF3A8791FF34E3E2FF2BF6F6FF38F7F6FFAAF6F6FFB8F2
      EFFFBFE8D5FF69C06EFF53B654FF003100FFFD5200FFFEB280FFFCA062FFFC9E
      5DFFFB9653FFFAF6F4FFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F2EFFFF481
      32FFF48132FFF47D2DFFF58F4AFFE00000FF0000FAFFFEA38EFFFD8D72FFFD8A
      6FFFFC866AFFFB8265FF706CE2FFD6D1D9FFD6D1D9FF6562DFFFF36E50FFF56B
      4BFFF46646FFF26242FFF5785BFF0000DFFF0000FDFF72718DFF515164FF5151
      64FF4646FBFF42D4A2FF42D4A2FF38D198FF38D198FF2FCF94FF2ACD90FF24CB
      8EFF1CC989FF1CC989FF38D198FF008F10FF0000FCFF7676FEFF5656FEFF4E4E
      F9FF4747FAFF4747FAFF3F3F76FF3A8791FF38F7F6FF2BF6F6FF2BF6F6FF2BF6
      F6FF38F7F6FFD9F3F3FFE4EFE8FF006D00FFFF5C00FFFEB280FFFEA366FFFCA0
      62FFFD9B59FFFDF9F7FFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F2EFFFF585
      38FFF58538FFF48132FFF69552FFE60200FF0000FAFFFEA38EFFFE9076FFFD8D
      72FFFD8A6FFFFC866AFF706CE2FF89B89FFFA6C1B4FF6562DFFFF67254FFF66F
      50FFF56B4BFFF46646FFF57C60FF0000E4FF0000FDFF7575F5FF515164FF4E4E
      D8FF4F4EFCFF4FF1FDFF46FBFBFF41FAFAFF3BF9F9FF35F8F8FF30F7F7FF2AF6
      F6FF23F5F5FF23F5F5FF3EF5F5FF00A7DCFF0000FCFF7676FEFF5656FEFF5656
      FEFF4E4EF9FF4749B6FF436871FF40EAE9FF38F7F6FF44F8F8FFAAF6F6FFBFF5
      F3FFBFE8D5FF69C06EFF53B654FF004B00FFFF5C00FFFFB686FFFCA569FFFEA3
      66FFFC9E5DFFFDF9F7FFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F4F1FFF789
      3EFFF6873CFFF58538FFF69552FFE60200FF0008FDFFFFA793FFFE9379FFFE90
      76FFFD8E73FFFD8A6FFF7E81ACFF8FBAA0FFD6D1D9FF855FC7FFF9785BFFF774
      55FFF66F50FFF56B4BFFF78065FF0000E4FF0000FFFF7979FFFF5C5CFDFF5858
      FCFF5453FBFF4FF1FDFF4CFCFCFF46FBFBFF41FAFAFF3BF9F9FF35F8F8FF30F7
      F7FF2AF6F6FF23F5F5FF43F6F6FF00A7DCFF0000FFFF7676FEFF5656FEFF4E4E
      DAFF5374A2FF50D0CAFF59FAFAFF78F9F6FFCBFBF9FFC9EEDFFF89CC86FF53B2
      49FF2DA42CFF259E25FF44AD43FF004B00FFFF5C00FFFFB686FFFCA96FFFFCA5
      69FFFCA062FFFDF9F7FFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF8F4F1FFF88C
      43FFF88C43FFF6873CFFF79958FFEB1400FF0008FDFFFFA793FFFC957DFFFE93
      79FFFE9076FFFD8E73FFFA8B71FFA078C2FF9F7AC7FFF78065FFFA7D60FFF978
      5BFFF77455FFF66F50FFF78468FF0000E4FF0000FFFF7979FFFF5C5CFDFF5C5C
      FDFF5858FCFF4FF1FDFF4CFCFCFF4CFCFCFF46FBFBFF41FAFAFF3BF9F9FF35F8
      F8FF30F7F7FF2AF6F6FF4BF7F7FF00A7DCFF0000FFFF7676FEFF5E5FC1FF6F99
      9FFF78F9F6FFCBFBF9FFD6F5E9FFCBE9CEFF61BB5CFF44AD43FF41A93AFF33A7
      34FF33A734FF2DA42CFF4BB34BFF004B00FFFF5C00FFFFB686FFFFB686FFFFB6
      86FFFEB280FFFEFBF9FFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFAF6F4FFF9A2
      65FFF9A265FFFCA062FFF89C5DFFEB1400FF0008FDFFFFA793FFFFA793FFFFA7
      93FFFEA38EFFFEA38EFFFD9F89FFFD9F89FFFC9A83FFFC9A83FFFC957DFFFA92
      79FFF98F75FFFA8B71FFF7886DFF0000EDFF0000FFFF7979FFFF7979FFFF7979
      FFFF7676FEFF73F5FEFF6CFDFDFF6CFDFDFF6CFDFDFF62FCFCFF62FCFCFF5BFA
      FAFF54F9F9FF54F9F9FF4BF7F7FF00A7DCFF0000D0FF8684BBFFB9DBC7FFD6F5
      E9FFD8F1DAFF89CC86FF76C373FF69C06EFF69C06EFF62BF62FF62BF62FF61BB
      5CFF53B654FF53B654FF4BB34BFF004B00FFFF6602FFFF5C00FFFF5C00FFFF5C
      00FFFD5200FFEDE7E3FFEAEAEAFFEAEAEAFFEAEAEAFFE7E7E7FFE5DDD9FFF535
      00FFF02C00FFF02C00FFEF2300FFF02C00FF0008FDFF0008FDFF0008FDFF0008
      FDFF0008FDFF0000FAFF0000FAFF0000FAFF0000F7FF0000F7FF0000F4FF0000
      F4FF0000F1FF0000F1FF0000EDFF0000EDFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF00C9F2FF00C9F2FF00C9F2FF00C4EEFF00C4EEFF00C4EEFF00BD
      EAFF00BDEAFF00B4E4FF00B4E4FF00B4E4FF1C3838FF41A93AFF1AAB14FF0081
      00FF008100FF008100FF008100FF008100FF006D00FF006D00FF006D00FF006D
      00FF006D00FF006D00FF004B00FF004B00FF00E300FF00DC00FF00DC00FF00DC
      00FF00D500FF00D500FF00D500FF00CD00FF00CD00FF00CD00FF00C400FF00C4
      00FF00C400FF00C400FF00C400FF00C400FFE96700FF0000BCFF0000BCFF0000
      BCFF0000BCFF0000BCFF0000A9FF0000A9FF0000A9FF0000A9FF0000A9FF0000
      9DFF00009DFF00009DFF000099FF00009DFFB41800FFAB0400FFAB0400FFAB04
      00FFAB0400FFAB0400FF970000FF970000FF970000FF970000FF970000FF8A00
      00FF8A0000FF8A0000FF8A0000FF8A0000FF2D0000FF130000FF130000FF1300
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF00F100FF79F885FF73F77EFF6CF7
      79FF6CF779FF68F674FF62F470FF5CF36AFF5CF36AFF53F061FF53F061FF53F0
      61FF49EE58FF49EE58FF49EE58FF00D500FFE96700FFD0A59EFF6B6BE2FF6B6B
      E2FF6B6BE2FF6161DEFF6161DEFF5A5ADFFF5353D9FF5353D9FF5353D9FF4A4A
      D7FF4A4AD7FF4343D6FF4343D6FF00009DFFF1DFD9FFF6F0EEFFF6F0EEFFF6EF
      EDFFF5EDE9FFF5EDE9FFF5EDE9FFF3EAE8FFF2E9E6FFF2E9E6FFF0E6E3FFF0E6
      E3FFF0E6E3FFEDE4E1FFEDE4E1FFC7B0AAFF2D0000FFA06262FF9C5C5CFF9957
      57FF995353FF944F4FFF914949FF8D4344FF8A3F3FFF853A3AFF853A3AFF8134
      35FF7E2F2FFF7E2F2FFF782828FF000000FFCADCF0FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF9F9F9FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF2F2F2FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FF97B1C9FFFB7C00FFFAC28CFF5A5ADFFF4949
      DDFF4949DDFF4343D6FF3939D6FF3939D6FF3939D6FF2B2BD2FF2B2BD2FF2323
      CFFF1D1ECDFF1D1ECDFF3939D6FF000099FFC87557FFEAC6BAFFE7B9A8FFE7B9
      A8FFE4B4A2FFE4B4A2FFE0AD9BFFE0AD9BFFE0AA97FFDEA895FFE0A692FFDBA2
      8DFFDBA28DFFDB9F89FFE0AD9BFFA13309FF2D0000FFA06262FF8D4344FF8A3F
      3FFF853A3AFF813435FF7E2F2FFF782828FF782828FF701212FF701212FF7012
      12FF701212FF701212FF7E2F2FFF000000FF0006FAFF7686FCFF576BFBFF526A
      FAFF4D67F9FF4862F8FF405BF6FF3D57F6FF3955F6FF334CF5FF2C4BF2FF2944
      F3FF2944F3FF1E40F0FF405BF6FF0000DDFFFB7C00FFFAC28CFFFDCA97FFF6F6
      F9FFF6F6F9FFF6F6F9FFF6F6F9FFE0E0DFFFE0E0DFFFF1F1F4FFF1F1F4FFEEEE
      F2FFEEEEF2FFEEEEF2FFEEEEF2FFD9DADBFFE0AA97FFEFD7CFFFECCDC2FFECCD
      C2FFECCDC2FFECCDC2FFEAC9BEFFE7C8BDFFEAC6BAFFE7C5B9FFE7C4B7FFE7C4
      B7FFE5C1B4FFE5C1B4FFE7C8BDFFCB8381FF2D0000FFA26B6BFF914949FF8D43
      44FF8A3F3FFF853A3AFF813435FF7E2F2FFF782828FF782828FFA47475FFE3E2
      E3FFEDEBEBFFD8C6C6FFA26B6BFF000000FF0006FAFF7ECAFCFF68E3FCFF5EB5
      FBFF526AFAFF4D67F9FF4862F8FF4360F6FF405BF6FF3955F6FF3352F4FF2C4B
      F2FF2C4BF2FF2345F1FF4360F6FF0000DDFFFB7C00FFFAC28CFFFDBD7DFFFBF7
      E9FFFCFCFCFFF9FBF9FFE0E0DFFFC9C8C5FFC0C3BEFFD9DADBFFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE5E5E5FFECE8E8FFFCFCFCFFFCFCFCFFFAF9
      F9FFFAF9F9FFFAF9F9FFF8F6F6FFF8F6F6FFF8F6F6FFF5F4F4FFF5F4F4FFF4F2
      F1FFF2F0F0FFF2F0F0FFF4F2F1FFD5D3D3FF2D0000FFA26B6BFF944F4FFF9149
      49FF8D4344FF8A3F3FFF853A3AFF813435FF7E2F2FFF782828FFE6DFDEFFA2CE
      D3FF83B5B5FF9FC3CAFFD8C6C6FF000000FF0006FAFF88EDFEFF6EFAFDFF67D6
      FCFF576BFBFF526AFAFF4D67F9FF4862F8FF4360F6FF405BF6FF3D57F6FF3352
      F4FF2C4BF2FF2C4BF2FF4763F3FF0000E3FFFB7C00FFFDCA97FFFDBD7DFFFAC2
      8CFFFCFCFCFFFCFCFCFFF9FBF9FFC0C3BEFFB9BFB9FFF7F7F7FFF7F7F7FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE5E5E5FFC23401FFD5714CFFFDFDFDFFFCFC
      FCFFCF633BFFCF633BFFCF633BFFCC5C33FFCC5C33FFCC5C33FFCC5C33FFC956
      2CFFC9562CFFC9562CFFCC5C33FFA92006FF3B1F9CFFA47475FF995353FF8B61
      8BFF8B618BFF7B4545FFAF664EFFA091C8FF813435FF7E2F2FFFF4F3F3FFB8B8
      9BFF5D8E58FF9A9695FFEDEBEBFF000000FF0011FDFF84B5FDFF6FE9FEFF6486
      FDFF5972FBFF5972FBFF526AFAFF4D67F9FF4862F8FF4360F6FF405BF6FF3955
      F6FF3352F4FF2C4BF2FF4B67F4FF0000E3FFFD870FFFFDCA97FFFEBF83FFFDF6
      F1FFFCFCFCFFFCFCFCFFFCFCFCFF8BC390FF85BF8AFFF7F7F7FFF7F7F7FFF7F7
      F7FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FFC43C0AFFD5714CFFFEFEFEFFFDFD
      FDFFCF633BFFCF633BFFFAF5F3FFFAF5F3FFF8F3F2FFF8F3F2FFF4F2F1FFF6F0
      EEFFF6EFEDFFF2EEECFFF6F0EEFFD6CAC8FFC78764FFD1DFFEFFB07E7BFF8D85
      D6FF8D85D6FFF0B679FFC6DAFBFF9A7CA7FF873E3EFF813435FFEAE3E3FFEDEB
      EBFFA26B6BFFEAE3E3FFD8C6C6FF000000FF0011FDFF8293FEFF6486FDFF6175
      FEFF6175FEFF5972FBFF576BFBFF526AFAFF4D67F9FF4862F8FF405BF6FF3D57
      F6FF3955F6FF3352F4FF4F6BF5FF0000E3FFFD870FFFF7CD9AFFFDD0A1FFF9FC
      F9FFF9FBF9FFF9FBF9FFF7F9F7FFB7F0F9FFB7F0F9FFF3F7F4FFF3F7F4FFF3F7
      F4FFF2F5F2FFF2F5F2FFF2F5F2FFDFE5DFFFE2E2E2FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFE0A692FFE1A48DFFE1A48DFFDB9F89FFDD9A82FFDD9A
      82FFDA947AFFDA947AFFDBA28DFFA11700FF350766FFD2CCEAFFACBCFEFF7B7B
      E5FF8C8DE7FFB8C9FDFF8D85D6FF9A7CA7FF8D4344FF853A3AFFB48689FFEDEB
      EBFFF4F3F3FFD8C6C6FFB07E7BFF000000FFCADCF0FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFAFAFAFFF9F9F9FFF9F9
      F9FFF6F6F6FFF6F6F6FFF6F6F6FFA9BFDDFFFD870FFFF7CD9AFF5DBC5DFF5DBC
      5DFF57B958FF52B652FF52B652FF4CB44CFF43AD43FF43AD43FF43AD43FF30A4
      30FF30A430FF30A430FF43AD43FF004700FFE2E2E2FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFECCDC2FFECCDC2FFEAC9BEFFEAC9BEFFEAC6BAFFE7C5
      B9FFE7C4B7FFE5C1B4FFEAC9BEFFCB8381FF001AFFFF7B7BE5FF646CF1FF5F63
      E7FF5858E7FF646CF1FF5F63E7FF4F68FCFF8D484FFF8A3F3FFF853A3AFF853A
      3AFF813435FF782828FF914949FF000000FF02F916FF90FC99FF90FC99FF90FC
      99FF8AFC94FF8AFC94FF8AFC94FF82FB8DFF82FB8DFF79F885FF79F885FF73F7
      7EFF73F77EFF6CF779FF68F674FF00E900FFFD870FFFE9CA8FFF75C875FF75C8
      75FF75C875FF75C875FF75C875FF68C268FF68C268FF68C268FF5DBC5DFF5DBC
      5DFF57B958FF52B652FF4CB44CFF004700FFC43C0AFFD5714CFFFFFFFFFFFEFE
      FEFFD5714CFFD5714CFFFCF9F8FFFCF9F8FFFCF9F8FFFBF8F7FFFBF8F7FFF8F6
      F6FFF8F6F6FFF8F6F6FFF7F4F2FFDDD6D2FF520000FFC4CAFFFFFFFFF9FFB5AB
      DAFFB5ABDAFFD2CCEAFFF7FDFDFFDBA376FFA26B6BFFA06262FFA06262FF9C5C
      5CFF995757FF995353FF944F4FFF000000FF00ED1CFF00ED0BFF00ED0BFF00ED
      0BFF00ED0BFF00E900FF00E900FF00E900FF00E900FF00E300FF00E300FF00DC
      00FF00DC00FF00DC00FF00DC00FF00D500FFDF8912FF008600FF008600FF0086
      00FF008600FF008600FF008600FF007600FF007600FF007600FF007600FF0063
      00FF006300FF006300FF006300FF006300FFC43C0AFFC43C0AFFD5D3D3FFD5D3
      D3FFC43C0AFFC43C0AFFC23401FFBC2800FFBC2800FFBC2800FFB41800FFB418
      00FFAB0400FFAB0400FFAB0400FFAB0400FF7078F9FFB48689FF520000FF3B1F
      9CFF3B1F9CFF520000FF350766FF8199FDFF520000FF2D0000FF2D0000FF2D00
      00FF130000FF130000FF130000FF000000FF0000F4FF0000F4FF0000F4FF0000
      EDFF0000EDFF0000EDFF0000EDFF0000D5FF0000E4FF0000E4FF0000E4FF0000
      E4FF0000DDFF0000DDFF0000DDFF0000DDFF0000F4FF0000F4FF0000F4FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E4FF0000E4FF0000E4FF0000
      DFFF0000DFFF0000DDFF0000DDFF0000DDFF006700FF006700FF004E00FF004E
      00FF004E00FF004E00FF004E00FF004E00FF002A00FF002A00FF002A00FF002A
      00FF002A00FF002A00FF002A00FF002A00FF0000F2FF0000F2FF0000F2FF0000
      F2FF0000F2FF00D5EDFF00EAEAFF00EAEAFF00E6E6FF00E6E6FF00DBCBFF0025
      00FF002500FF002500FF002500FF002500FF0000F4FF616BF9FF5A65FAFF5A65
      FAFF525DF7FF525DF7FF49A9E9FF49A9E9FF4350F3FF3A47F4FF3A47F4FF3440
      F2FF3440F2FF2D39F2FF2D39F2FF0000DDFF0000F4FF5D5DFCFF5D5DFCFF5757
      F7FF5453FCFF6969FAFF6D6DF5FF5151F9FF4141F8FF3A3AF5FF3A3AF5FF3333
      F3FF3333F3FF2D2DF2FF2D2DF2FF0000DDFF006700FF61BE60FF61BE60FF53B7
      53FF53B753FF53B753FF45B045FF45B045FF45B045FF3BAC3BFF34A834FF34A8
      34FF31A531FF2CA32CFF2CA32CFF002A00FF0000F2FF6363FCFF5C5CFDFF5757
      F9FF5353FCFF4FEEF8FF4AF7F7FF43F7F7FF43F7F7FF3CF5F5FF3AF3EDFF33A9
      33FF31A632FF2CA42CFF2CA42CFF002500FF0414F9FF8D94FCFF6D77F9FF6D77
      F9FF6D77F9FF616BF9FF525DF7FF49A9E9FF4059F3FF4C57F3FF505BF2FF4C57
      F3FF4753F1FF4350F3FF5F69F2FF0000DDFF0000FBFF6464FCFF4545FBFF5151
      F9FFBCBCFCFFF2F2F7FFF5F5F5FFE1E1FBFF6D6DF5FF1E1EF4FF1818F3FF1111
      EFFF0C0CF1FF0C0CF1FF2D2DF2FF0000DFFF006700FF61BE60FF45B045FF3BAC
      3BFF3BAC3BFF34A834FF2CA32CFF2CA32CFF209E20FF209E20FF109510FF1095
      10FF109510FF109510FF2CA32CFF002A00FF0000FDFF6363FCFF4444FBFF3C3C
      FAFF3C3CFAFF36EDF9FF2EF7F7FF29F6F6FF21F5F5FF21F5F5FF1BEFE8FF1399
      13FF0E970FFF0A950AFF2CA42CFF002500FFE7E7E9FFFCFCFCFFFAFAFBFFFAFA
      FBFFFAFAFAFFF2F3F7FFE1E2EFFF49A9E9FFDEDFF4FFE4E5EEFFF4F4F4FFF3F3
      F3FFF1F1F2FFF1F1F2FFF3F3F3FFC7C7C9FF0000FBFF6969FAFF4A4AFCFFC1C1
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF2F2F7FF5757F7FF1E1EF4FF1818
      F3FF1111EFFF1111EFFF3333F3FF0000DFFFDFE5DFFFFAFBFDFFF7F9F7FFF7F9
      F7FFF7F9F7FFF4F7F4FFF4F7F4FFF2F5F2FFF2F5F2FFF2F5F2FFF0F2F0FFEEF0
      EEFFEEF0EEFFEEF0EEFFF0F2F0FFBBC1BBFF0000FDFF6C6CFDFF4949FBFF4444
      FBFF3C3CFAFF36EDF9FF34F8F8FF2EF7F7FF29F6F6FF21F5F5FF1BEFE8FF189C
      18FF139913FF0E970FFF31A632FF002500FFEBEBEBFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFCDCFEAFF3B47E1FF343CB9FF303CDEFFCDCFEAFFF5F5F5FFF4F4
      F4FFF3F3F3FFF1F1F2FFF4F4F4FFCECECEFF0000FBFF6D6DFDFF6D6DFDFFFBFC
      FBFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFB6B6F6FF2323F5FF1E1E
      F4FF1818F3FF1111EFFF3333F3FF0000E4FFFD4D04FFFEB997FFFCA479FFFCA4
      79FFFB9E71FFFB9E71FFFA996BFFFA9466FFF69463FFF6905DFFF58D59FFF48A
      55FFF38651FFF5804CFFF69463FFE50700FF0000FDFF6C6CFDFF4E4EFCFF4949
      FBFF4444FBFF3FEEFAFF3AF9F9FF34F8F8FF2EF7F7FF29F6F6FF27F1EBFF1E9F
      1EFF189C18FF139913FF33A933FF002500FFEBEBEBFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFF6D77F9FF414DF2FF3A47F4FF3440F2FF414DF2FFF2F3F7FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFCECECEFF6464FCFFBCBCFCFFA9A9FDFFA3A3
      FCFFA3A3FCFFA3A3FCFF9C9CFAFF9C9CFAFF9898F6FF9393F7FF9393F7FF8B8B
      F4FF8B8BF4FF8B8BF4FF9898F6FF1111EFFFFD4D04FFFEAB84FFFA996BFFFC95
      6AFFFA9466FFFB8F61FFFA8A5BFFFA8A5BFFF88453FFF5804CFFF5804CFFF576
      42FFF57642FFF3703BFFF58657FFE50700FF0000FDFF7474FEFF5353FCFF4E4E
      FCFF4949FBFF45F0FBFF40FAFAFF3AF9F9FF34F8F8FF2EF7F7FF27F1EBFF24A2
      24FF1E9F1EFF189C18FF3CAC3CFF003900FFEDEDEDFFFEFEFEFFFEFEFEFFFDFD
      FDFFFDFCFDFFCDCFEAFF535DECFF6468ADFF4954E8FFCDCFEAFFF7F7F7FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFCECECEFFF1F1F1FFFEFEFEFFE1E1FBFF5453
      FCFF504FFDFF4A4AFCFF4545FBFF4141F8FF3B3AF9FF7272F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF5F5F5FFF5F5F5FFD6D6D6FFFD6616FFFEB997FFFEAB84FFFEAB
      84FFFDA87CFFFCA479FFFBA272FFFB9E71FFF79D6DFFFA996BFFF69463FFF694
      63FFF6905DFFF58D59FFF79D6DFFE50700FF0000FDFF7474FEFF5858FEFF5353
      FCFF4E4EFCFF4AF1FCFF46FBFBFF40FAFAFF3AF9F9FF34F8F8FF32F3EDFF2CA4
      2CFF24A224FF1E9F1EFF3CAC3CFF003900FFEFEFEFFFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFE3E4F8FF616BF9FF505BF2FF525DF7FFDEDFF4FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFCECECEFFF1F1F1FFFEFEFEFFFEFEFEFF9393
      FEFF5453FCFF504FFDFF4A4AFCFF4545FBFF4545FBFFCFCFF9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD6D6D6FFE7E7EBFFFAFBFDFFFAFBFDFFFAFB
      FDFFFAFBFDFFF7F8FBFFF7F8FBFFF6F6FAFFF6F6FAFFF6F6FAFFF3F4F8FFF3F4
      F8FFF2F3F5FFF2F3F5FFF2F3F5FFC7C7CDFF0000FFFF7979FFFF5C5CFDFF5858
      FEFF5353FCFF52F2FDFF4CFCFCFF46FBFBFF40FAFAFF3AF9F9FF32F3EDFF31A6
      32FF2CA42CFF24A224FF43AF43FF003900FFEFEFEFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFCFDFFF3F3FAFF7B84FBFFE3E4F8FFFAFAFAFFF8F8F8FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFD6D6D6FFF1F1F1FFFFFFFFFFFEFEFEFFF2F2
      FEFF9393FEFF5D5DFCFF5453FCFF6464FCFFC1C1FBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFD9D9D9FF0000C3FF7979E4FF5B5BDDFF5B5B
      DDFF5B5BDDFF5252D9FF5252D9FF4747D6FF4747D6FF4747D6FF3333D1FF3333
      D1FF3333D1FF3333D1FF4747D6FF00009BFF0000FFFF7979FFFF5C5CFDFF5C5C
      FDFF5858FEFF52F2FDFF4CFCFCFF4CFCFCFF46FBFBFF40FAFAFF3AF3EDFF33A9
      33FF33A933FF2CA42CFF4BB34BFF003900FFEFEFEFFFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF8F8F8FFF8F8F8FFF7F7F7FFD6D6D6FFF1F1F1FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFEDEDFEFFE1E1FBFFF7F7FDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDEDEDEFF0000C3FF7979E4FF7979E4FF7979
      E4FF7979E4FF7271E2FF7271E2FF6A6AE0FF6A6AE0FF6262DDFF6262DDFF5B5B
      DDFF5252D9FF5252D9FF5252D9FF00009BFF0000FFFF7979FFFF7979FFFF7979
      FFFF7474FEFF73F5FEFF6CFDFDFF6CFDFDFF64FCFCFF64FCFCFF5FF7F2FF56B9
      57FF56B957FF56B957FF4BB34BFF005100FFEFEFEFFFEFEFEFFFEFEFEFFFEFEF
      EFFFEDEDEDFFEDEDEDFFEBEBEBFFE9E9E9FFE9E9E9FFE6E6E6FFE6E6E6FFE2E2
      E2FFE2E2E2FFDFDFDFFFDADADAFFDADADAFFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF0EFEFFFF0EFEFFFEDEDEDFFEDEDEDFFEAEAEAFFEAEAEAFFE6E6
      E6FFE6E6E6FFE2E2E2FFE2E2E2FFDEDEDEFF0000C7FF0000C3FF0000C3FF0000
      C3FF0000C3FF0000C3FF0000B8FF0000B8FF0000B8FF0000B8FF0000B8FF0000
      B8FF0000AAFF0000AAFF0000AAFF0000AAFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF00EBFDFF00FCFCFF00FCFCFF00FCFCFF00FCFCFF00EFE5FF0061
      00FF006100FF005100FF005100FF005100FFAE796FFF949ABFFF2E3EB4FFA3A2
      BAFFA75640FFA33F3EFFB89779FF2E3EB4FF2E3EB4FFA75640FF723E3EFF723E
      3EFF4D56B6FF2E3E8FFF2E3EB4FF723E3EFF0000F3FF0000F3FF0000F3FF0000
      F3FF005DF2FF0038E7FF0000E7FF0038E7FF0038E7FF0000E7FF0038E7FF0038
      E7FF0000DDFF0000DDFF0000DDFF0000DDFFDFDFDFFFDADADAFFDADADAFFD9D7
      D9FFD7D7D7FFD2D2D2FFD2D2D2FF0000D3FF0000D3FFCBCBCBFFC3C3C3FFC3C3
      C3FFC3C3C3FFC3C3C3FFBFBFBFFFBFBFBFFF006B00FF005700FF005700FF0057
      00FF004600FF004600FF004600FF003700FF003700FF003700FF002800FF0028
      00FF002800FF001F00FF001F00FF001F00FFAE796FFFFEE6E0FFF1F3FEFFA7B1
      FEFFF6F6FEFFFFCEC2FFFEF5F3FF7586FDFF7586FDFFFEE3DEFFEEB2A7FFE3E1
      FEFF7586FDFFCFD6FEFFE4ADA3FF723E3EFF0000F3FF61AC8AFF57CBF7FF54DA
      F8FF54DAF8FF54DAF8FF47D8F9FF47D8F9FF3FD2F6FF3FD2F6FF34CFF3FF34CF
      F3FF34CFF3FF29CDF3FF2B8C5FFF0000D7FFE2E2E2FFFAFAFAFFDDDEF8FF9599
      F2FFDDDEF8FFF8F8F8FFF7F7F7FF656AF3FF6167E9FFF4F4F4FFF4F4F4FFD8D8
      F2FF737CE4FFC8C9EFFFF2F2F2FFBFBFBFFF006B00FF61BE60FF5ABB5AFF5ABB
      5AFF52B651FF52B651FF46B246FF46B246FF3FAF3FFF3AAB3AFF3AAB3AFF33A9
      33FF31A632FF2EA52EFF29A329FF001F00FFAE796FFFFEE6E0FFFFCEC2FFEAEB
      FFFF6F71FFFFF1EDFFFFFFF0EDFF2528FFFF2E31FFFFFFD2C7FFDBD2FFFF2E31
      FFFFBCC0FFFFE37561FFE4ADA3FF723E3EFF0000F3FF69BA7AFF4FC45FFF37D3
      C6FF3BDEF9FF35DCF8FF29D6F6FF29D6F6FF29D6F6FF18D3F3FF18D3F3FF18D3
      F3FF0DC4B3FF0AB035FF319C45FF0000DDFFE2E2E2FFFCFCFCFFA8ADF3FF6C74
      E2FFA1A6F0FFF8F8F8FFF7F7F7FF4E53EDFF464DE3FFF4F4F4FFF2F2F2FF8489
      EBFF464DE3FF737CE4FFF2F2F2FFC3C3C3FF006B00FF67C267FF46B246FF3FAF
      3FFF3AAB3AFF33A933FF2EA52EFF29A329FF23A223FF1B9E1BFF1B9E1BFF1399
      13FF0E970FFF0A950AFF2EA52EFF001F00FFAE796FFFFEE6E0FFFFCEC2FFFFCE
      C2FFEEEFFFFF6F71FFFFF9F7FFFF2E31FFFF2E31FFFFECE4FFFF3C3CFFFFD5D8
      FFFFE37561FFE37561FFEEB2A7FF723E3EFF0000FDFF69BA7AFF45B348FF45B3
      48FF32BC8EFF37CEE1FF33D3F8FF29D6F6FF29D6F6FF29CDF3FF1EC5D7FF18AE
      6FFF189C18FF189C18FF319C45FF0000DDFFE6E6E6FFFCFCFCFFFAFAFAFFB6BA
      F3FFFAFAFAFFFAFAFAFFF8F8F8FF5359EFFF4E53EDFFF4F4F4FFF4F4F4FFF4F4
      F4FF8D92EAFFF2F2F2FFF4F4F4FFC3C3C3FF006B00FF67C267FF46B246FF46B2
      46FF3FAF3FFF3AAB3AFF33A933FF2EA52EFF29A329FF23A223FF1B9E1BFF1B9E
      1BFF139913FF0E970FFF31A632FF002800FF5E6ABFFFE8E9FFFFD3D3FFFFD3D3
      FFFFD3D3FFFFE3E1FEFF3C3CFFFF2E31FFFF2528FFFF2E31FFFFC4CBFFFFBCC0
      FFFFB5B8FFFFADADFFFFD5D8FFFF2E3EB4FF0000FDFF69BA7AFF4EBB8BFF3FB9
      5FFF45B348FF45B348FF37C4A5FF3B63F6FF365DF5FF32BC8EFF27A634FF189C
      18FF189C18FF16A216FF319C45FF0000E7FF555AF1FFB1B3F9FFA0A3F7FFA1A4
      F7FF9B9EF4FF9599F2FF8D90F2FF555AF1FF4E53EDFF8185EFFF8489EBFF8185
      EFFF8489EBFF7A80EFFF8D92EAFF0000D3FF00FDFDFF72FEFEFF4EFCFCFF49FC
      FCFF43FBFBFF43FBFBFF39F4F9FF346567FF2E5D5FFF29EFF2FF23F5F5FF1BF4
      F4FF1BF4F4FF13F2F2FF32F6F6FF00E5E5FF3B4BBEFFC4CBFFFF989CFFFF989C
      FFFF7579FFFF5E60FFFF474AFFFF3C3CFFFF2E31FFFF2E31FFFF2528FFFF2528
      FFFF171BFFFF171BFFFF7586FDFF2E3EB4FF0000FDFF74BF85FF54DAF8FF5489
      DFFF45B348FF45B348FF3D75C7FF38C8F5FF38C8F5FF3D75C7FF25A425FF25A4
      25FF189C18FF16A216FF35A74BFF0000E7FF0000EDFF7A80EFFF5C61F3FF5C61
      F3FF555AF1FF4F53F2FF4F53F2FF555AF1FF5359EFFF3E44EDFF2E35EAFF2E35
      EAFF2E35EAFF2E35EAFF3E44EDFF0000D3FF00FDFDFF72FEFEFF54FDFDFF4EFC
      FCFF49FCFCFF43FBFBFF409E9DFF384646FF384646FF359593FF2AF6F6FF23F5
      F5FF1BF4F4FF1BF4F4FF3CF5F5FF00E5E5FF7982BFFFEAEBFFFFD5D8FFFFD5D8
      FFFFD5D8FFFFD5D8FFFF7579FFFF474AFFFF474AFFFF656AFFFFCFD6FEFFC4CB
      FFFFBCC0FFFFB5B8FFFFCFD6FEFF2E3EB4FF0000FDFF74BF85FF59DED7FF53B9
      54FF53B954FF3FB95FFF45CAAFFF456DF8FF456DF8FF37C4A5FF35A74BFF25A4
      25FF25A425FF25A425FF43A756FF0000E7FF656AF3FFBCBFFAFFACAEF9FFADB0
      F9FFA7AAF8FFA4A7F7FF9B9EF4FF5C61F3FF5C61F3FF8D90F2FF9599F2FF9295
      F1FF9599F2FF8D90F2FF9B9EF4FF161CD9FF00FDFDFF72FEFEFF54FDFDFF54FD
      FDFF4EFCFCFF49FCFCFF45F3F0FF409E9DFF359593FF35EFECFF32F6F6FF2AF6
      F6FF23F5F5FF1BF4F4FF3CF5F5FF00E5E5FFB37E74FFFEEAE4FFFFD2C7FFFFD2
      C7FFF1F3FEFFADADFFFFF4F0FFFF7579FFFF94A9FFFFF1EDFFFF656AFFFFEEEF
      FFFFFCAC94FFFC9D84FFFEC7BBFFA33F3EFF0000FFFF79C389FF4FC45FFF53B9
      54FF59CE8EFF50D7E9FF47D8F9FF46DFFBFF47D8F9FF3BD6F9FF37CEE1FF32BC
      8EFF27A634FF25A425FF43A756FF0000E7FFEBEBEBFFFEFEFEFFFEFEFEFFCACE
      F9FFFDFDFDFFFDFDFDFFFCFCFCFF656AF3FF5C61F3FFFAFAFAFFF8F8F8FFF7F7
      F7FFBBBFF1FFF4F4F4FFF7F7F7FFCBCBCBFF0000FFFF7979FFFF5A5AFDFF5A5A
      FDFF5454FCFF5050FDFF4B4BFCFF4443FBFF4443FBFF3C3BF9FF3636F8FF3030
      F7FF2929F6FF2929F6FF4343F6FF0000EBFFB37E74FFFEEAE4FFFFD2C7FFEEEF
      FFFFADADFFFFF4F0FFFFFFEDE8FF989CFFFFA7B1FEFFFEEAE4FFF1EDFFFF656A
      FFFFE8E9FFFFFCAC94FFFEC7BBFFA33F3EFF0000FDFF79C389FF59CE8EFF59DE
      D7FF54E4FDFF54E4FDFF54E4FDFF46DFFBFF46DFFBFF46DFFBFF3BDEF9FF35DC
      F8FF37D3C6FF3FB95FFF43A756FF0000E7FFEBEBEBFFFEFEFEFFBCBFFAFF8489
      EBFFBCBFFAFFFDFDFDFFFDFDFDFF6C70F4FF656AF3FFFAFAFAFFFAFAFAFFB6BA
      F3FF6167E9FFA1A6F0FFF7F7F7FFD1CFCFFF0000FFFF7979FFFF6060FCFF5A5A
      FDFF5A5AFDFF5454FCFF5050FDFF4B4BFCFF4443FBFF4443FBFF3C3BF9FF3636
      F8FF3030F7FF2929F6FF4B4BF7FF0000EBFFB37E74FFFEEAE4FFF6F6FEFFCFD6
      FEFFFBF9FEFFFEE6E0FFFEF5F3FFC4CBFFFFCFD6FEFFFEF5F3FFFEE3DEFFF6F6
      FEFFA7B1FEFFF1F3FEFFFFD2C7FFA54A3EFF0000FDFF7ABA9FFF75E3FEFF75E3
      FEFF75E3FEFF75E3FEFF75E3FEFF6AE1FDFF6AE1FDFF5FDDFBFF5FDDFBFF5FDD
      FBFF54DAF8FF57CBF7FF4DA07CFF0000E7FFEBEBEBFFFEFEFEFFECECFCFFBCBF
      FAFFECECFCFFFEFEFEFFFDFDFDFF8689F7FF8689F7FFFCFCFCFFFAFAFAFFECEC
      FCFFA7A9F6FFDDDEF8FFF7F7F7FFD2D2D2FF0000FFFF7979FFFF7979FFFF7979
      FFFF7979FFFF7271FEFF7271FEFF6A6AFDFF6A6AFDFF6060FCFF6060FCFF5A5A
      FDFF5454FCFF5252F8FF4B4BF7FF0000EBFFB37E74FF9DA1BFFF4D56B6FFA3A2
      BAFFAE796FFFAE796FFFBAA19CFF3B4BBEFF4D56B6FFBAA19CFFAA756CFFAA75
      6CFFA3A2BAFF2E3EB4FF949ABFFFA75640FF0000FFFF0000FFFF0000FFFF0000
      FFFF0089FDFF0072FBFF0000FDFF0072FBFF0072FBFF0000FDFF005DF2FF0072
      FBFF0000F3FF0000F3FF0000F3FF0000E7FFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
      EBFFE9E9E9FFE9E9E9FFE6E6E6FF0000EDFF0000EDFFE2E2E2FFE2E2E2FFDFDF
      DFFFDADADAFFDADADAFFDADADAFFD7D7D7FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000EBFF0000EBFFAF651BFFA95C10FFA45506FFA455
      06FF9F4C00FF9B4600FF974000FF923A00FF923A00FF8C3300FF892D00FF8428
      00FF812100FF812100FF7C1E00FF7C1E00FFE9E9E9FFE7E7E7FFE5E5E5FFE3E3
      E3FFC00000FF0000B9FFC00000FFDBDBDBFFD6D6D6FFD6D6D6FFD3D3D3FFD1D1
      D1FFCFCFD1FFCDCDCDFFCDCDCDFFCDCDCDFFBB6B43FFB0562BFFB0562BFFB056
      2BFFA54616FFBBBBBBFFBBBBBBFFB0B0B3FFAAAAAAFFAAAAAAFF9F9F9FFF0000
      CCFF0000CCFF0000C6FF0000C6FF0000C6FFA91000FFA91000FFA91000FFA910
      00FF950000FF950000FF950000FF950000FF950000FF950000FF950000FF8000
      00FF800000FF800000FF800000FF800000FFAF651BFFDEBE9EFFDBBC9CFFD9B9
      99FFD8B796FFD7B493FFD5B28FFFDCC1A6FFDCC1A6FFD1AB85FFCEA983FFCEA9
      83FFCDA67DFFCBA47CFFCAA27AFF7C1E00FFEBEBEBFFFBFBFBFFFAFAFAFFF9F9
      F9FFE97D53FF4F61E8FFE5754AFFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF2F2F2FFCDCDCDFFBB6B43FFE3BFAFFFE1BDAAFFDEB9
      A6FFDDB5A1FFEDEDEDFFECECECFFEAE9E9FFE8E8E8FFE6E6E6FFE6E6E6FF616D
      ECFF5C69EAFF5965E9FF5563EDFF0000C6FFB02D00FFDEA182FFDB9B7AFFDB9B
      7AFFD89674FFD79370FFD5906CFFD58B65FFD58B65FFCF845EFFCF845EFFCF84
      5EFFCC7B53FFCC7B53FFCC7B53FF800000FFB46D25FFDEC0A3FFD5B28FFFD4AE
      89FFD2AC86FFD1A982FFCDA479FFF6F6F6FFF6F6F6FFC89B6EFFC89C70FFC699
      6CFFC49769FFC29566FFCBA47CFF812100FFEDEDEDFFFCFCFCFFFAFAFAFFFAFA
      FAFFE5693AFF3449E3FFE2612EFFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCDCDCDFFC57A56FFE5C3B2FFDDB5A1FFD9AF
      9AFFD9AF9AFFECECECFFEAE9E9FFE8E8E8FFE6E6E6FFE4E4E4FFE2E2E2FF4856
      EAFF4251E8FF3D4CE6FF5965E9FF0000C6FFB02D00FFDEA182FFD58B65FFD58B
      65FFD4845BFFD4845BFFD17D53FFCC7B53FFCC7449FFCC7449FFC96E42FFC668
      39FFC66839FFC66839FFCC7B53FF800000FFB5722BFFE0C3A5FFD8B591FFD5B2
      8FFFD4AE89FFD2AB83FFD1A982FFD9B999FFD8B796FFCBA177FFC89C70FFC89B
      6EFFC6996CFFC49769FFCDA67DFF842800FFEFEFEFFFFCFCFCFFFBFBFBFFFBFB
      FBFFE36D3FFF3A4EE3FFE26534FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFD1D1D1FFC57A56FFE7C8B7FFDEB9A6FFDDB5
      A1FFD9AF9AFFEEEEEEFFECECECFFEBEBEBFFE8E8E8FFE6E6E6FFE4E4E4FF4E5C
      EBFF4856EAFF4251E8FF5C69EAFF0000CCFFB02D00FFD8AB90FFCE9674FFCE96
      74FFC9906CFFC9906CFFC48863FFC48863FFC08059FFC08059FFC08059FFBA75
      4CFFBA754CFFBA754CFFC48863FF800000FFB97531FFE1C5A9FFD8B796FFD8B5
      91FFE6D0BAFFE5CFB9FFD4AE89FFD1A982FFD0A87EFFCDA67DFFDEC7AEFFDBC2
      A8FFC89B6EFFC6996CFFCEA983FF842800FFD80400FFEF9672FFE9794EFFE976
      49FFE77042FF3F53E6FFE5693AFFE26534FFE2612EFFE05D2AFFDE5621FFDE56
      21FFDB4D16FFDB4D16FFE26534FFB30000FFCC8765FFE7C8B7FFE1BDAAFFDEB9
      A6FFDDB5A1FFF1F1F1FFEEEEEEFFECECECFFEBEBEBFFE8E8E8FFE6E6E6FF5563
      EDFF4E5CEBFF4856EAFF616DECFF0000CCFF00FDFDFF72FEFEFF4CFCFCFF45FB
      FBFF45FBFBFF3FFAFAFF3AF9F9FF35F8F8FF30F6F6FF2AF6F6FF23F5F5FF1BF4
      F4FF1BF4F4FF13F2F2FF30F6F6FF00E5E5FFBE7B3AFFE1C5A9FFDBBA97FFD8B5
      91FFFCFCFCFFFCFCFCFFE4CCB5FFD2AC86FFD1A982FFE6D3BEFFF6F6F6FFF6F6
      F6FFC89C70FFC89C70FFD1AB85FF892D00FF0000DAFF7382EFFF5264EAFF4F61
      E8FF485BE8FF485BE8FF3F53E6FF3A4EE3FF3449E3FF2F44E2FF2A3FE0FF243A
      DEFF1C33DCFF1C33DCFF3A4EE3FF0000B9FFCC8765FFE9CBBCFFE4BFAEFFE1BD
      AAFFE0B9A6FFF1F1F1FFEEEEEEFFEDEDEDFFEDEDEDFFEBEBEBFFEAE9E9FF5B69
      F0FF5563EDFF4F5DECFF6975EEFF0000D8FF00FDFDFF72FEFEFF54FDFDFF4CFC
      FCFF4CFCFCFF45FBFBFF3FFAFAFF3AF9F9FF35F8F8FF30F6F6FF2AF6F6FF23F5
      F5FF1BF4F4FF1BF4F4FF3CF5F5FF00E5E5FFBE7B3AFFE3C8ADFFDCBC9AFFDBBA
      97FFE9D4BFFFE6D3BEFFD8B591FFD4AE89FFD2AC86FFD2AC86FFE0C9B1FFDEC7
      AEFFCBA177FFCBA177FFD3AD88FF8C3300FFDB0F00FFEF9672FFEC8258FFE97D
      53FFE97A50FF485BE8FFE87345FFE77042FFE5693AFFE26534FFE2612EFFE05D
      2AFFDE5621FFDE5621FFE36D3FFFB30000FFD18F6EFFEBCFC1FFE5C3B2FFE4BF
      AEFFE1BDAAFFEEEEEEFFEDEDEDFFEBEBECFFEAE9E9FFE8E8E8FFE6E6E6FF636F
      F1FF5B69F0FF5563EDFF6975EEFF0000D8FF00FDFDFF72FEFEFF54FDFDFF54FD
      FDFF4CFCFCFF4CFCFCFF45FBFBFF3FFAFAFF3AF9F9FF35F8F8FF30F6F6FF2AF6
      F6FF23F5F5FF1BF4F4FF3CF5F5FF00E5E5FFBF7E3FFFE3C8ADFFDEBE9EFFDCBC
      9AFFDBBA97FFD8B591FFD8B591FFE0C3A5FFDEC0A3FFD3AD88FFD1A982FFD0A8
      7EFFCDA67DFFCAA27AFFD3AF8CFF923A00FFF3F3F3FFFEFEFEFFFEFEFEFFFEFE
      F9FFE97D53FF4F61E8FFE97649FFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFDBDBDBFFD29271FFEBCFC1FFE7C5B4FFE5C3
      B2FFE4C0AEFFEEEEEEFFEBEBEBFFECECECFFEBEBEBFFEAE9E9FFE6E6E6FF6A76
      F3FF636FF1FF5B69F0FF717DF3FF0000D8FF008300FF78CD80FF5BC164FF58BF
      61FF52BD5CFF52BD5CFF48B853FF48B853FF42B44DFF39B041FF39B041FF30AD
      3CFF28A934FF28A934FF42B44DFF004500FFBF8140FFE4CAB0FFDEBFA0FFDEBE
      9EFFDCBC9AFFDBBA97FFD8B591FFFCFCFCFFFCFCFCFFD3AD88FFD4AE89FFD2AB
      83FFD1A982FFCDA67DFFD5B28FFF974000FFF3F3F3FFFFFFFFFFFEFEFEFFFEFE
      FEFFEC8258FF5366EBFFE97A50FFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFDBDBDBFFD39572FFEDD2C4FFE7C8B7FFE7C5
      B4FFE5C3B2FFEDEDEDFFECECECFFEBEBEBFFEAE9E9FFEAE9E9FFE6E6E6FF717D
      F3FF6A76F3FF636FF1FF7D88F4FF0000D8FF008300FF79CA7AFF5FBE5FFF5ABC
      5AFF5ABC5AFF55B955FF51B751FF4BB34BFF44B244FF44B244FF39B041FF33A9
      33FF33A933FF2BA52BFF4BB34BFF004500FFBF8140FFE4CAB0FFE4CAB0FFE3C8
      ADFFE3C8ADFFE3C8ADFFE1C5A9FFE6D0BAFFE5CFB9FFDEBFA0FFDEBE9EFFDBBC
      9CFFD9B999FFD8B796FFD7B493FF9B4600FFF3F3F3FFFFFFFFFFFFFFFFFFFEFE
      FEFFEF9672FF7382EFFFEF9672FFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDBDBDBFFD39572FFEDD2C4FFEDD2C4FFEDD2
      C4FFEBCFC1FFF8F8F8FFF7F7F7FFF7F7F7FFF7F7F7FFF4F4F4FFF4F4F4FF8C95
      F8FF8C95F8FF7D88F4FF7D88F4FF0000E4FF008300FF79CA7AFF79CA7AFF79CA
      7AFF76C876FF72C671FF72C671FF68C268FF68C268FF68C268FF5FBE5FFF5ABC
      5AFF55B955FF51B751FF4BB34BFF004500FFBF8140FFBF8140FFBF8140FFBF81
      40FFBF7E3FFFBE7B3AFFBB7834FFB97531FFB5722BFFB46D25FFAF651BFFAF65
      1BFFA95C10FFA45506FFA45506FF9F4C00FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
      F3FFDB0F00FF0000DAFFD80400FFEFEFEFFFEDEDEDFFEDEDEDFFEBEBEBFFE9E9
      E9FFE7E7E7FFE5E5E5FFE3E3E3FFE1E1E1FFD39572FFD39572FFD39572FFD395
      72FFD29271FFDEDEDEFFDEDEDEFFD4D4D4FFD4D4D4FFCFCFCFFFCFCFCFFF0008
      EEFF0008EEFF0000E4FF0000E4FF0000E4FF008300FF008300FF008300FF0083
      00FF008300FF007800FF007800FF007800FF007800FF006900FF006900FF0069
      00FF005700FF005700FF005700FF005700FFF6B200FFF2AB00FFF2AB00FFECA9
      00FFECA900FF0000E8FF0000E8FF0000E8FF0000E8FF0000E8FF0000E8FF00D5
      69FF00D569FF00D265FF00D265FF00C952FFEBDEDAFFE9DBD6FFE5D9D3FFE3D7
      D1FF9C0000FF9C0000FF9C0000FFD7BFB7FFD7C9C1FFD7C9C1FFD2C2BCFFD2C2
      BCFFCFC1B9FFCDBFB7FFCDBFB7FFC1B1A7FFF36500FFF36500FFF65C00FFEF56
      00FFEF5600FFEA4700FFEA4700FFEA4700FFE53900FFE53900FFE53900FFDF2A
      00FFDF2A00FFDF2A00FFDF2A00FFDF2A00FF4B0000FF4B0000FF4B0000FF2900
      00FF4B0000FF290000FF290000FF290000FF290000FF290000FF0F0000FF0F00
      00FF0F0000FF0F0000FF0F0000FF0F0000FFF6B200FFFBDE67FFFBDE67FFFDDD
      5CFFFBDC53FF8B53FBFF834AF7FF834AF7FF834AF7FF8043F9FF7C40F8FF67F3
      C9FF67F3C9FF64F2C8FF62F2C8FF00D569FFEDE2DDFFFBFBFBFFFAFAFAFFF9F9
      F8FFDA8D65FFD98A60FFDA885EFFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF3F2F2FFF2F2F2FFF2F2F2FFCDBFB7FFF87200FFFBBF7BFFFBBF7BFFF9BC
      76FFF9B870FFF9B870FFF9B46AFFFBB268FFF9B064FFF9AC60FFF4AC5AFFF4AC
      5AFFF6A854FFF4A650FFF4A650FFDF2A00FF4B0000FFB27360FFAF6E5CFFAB69
      56FFAB6956FFA8614DFFA55D47FFA45945FFA15540FF9D523DFF9D523DFF9B4F
      3AFF984A35FF984A35FF96442CFF0F0000FFF9B500FFFBDE67FFFBDA4BFFFAD7
      45FFF9D83AFF7A3DF8FF6D2AF5FF7231F6FF6D2AF5FF6D2AF5FF6621F3FF4EF2
      C1FF4EF2C1FF4AF1BFFF64F2C8FF00D265FFEDE2DDFFFCFCFCFFFAFAFAFFFAFA
      FAFFD57B4EFFD37749FFD17243FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCDBFB7FFF87200FFFAC288FFFBB268FFF9B0
      64FFF9AC60FFF8AB59FFF6A854FFF4A650FFF4A247FFF4A247FFF4A247FFFAC2
      88FF393CD1FFF7BB84FFF4A650FFDF2A00FF670000FFB47765FFA45945FFA155
      40FF9B4F3AFF984A35FF96442CFF96442CFF8D3829FF8D3829FF747881FF7478
      81FF6A6C75FF6A6C75FF96442CFF0F0000FFFCBC00FFFDE272FFFBDC53FFFBDA
      4BFFFBDB43FF7C40F8FF7233F8FF7637F7FF7231F6FF6D2AF5FF6D2AF5FF53F3
      C4FF53F3C4FF4EF2C1FF67F3C9FF00D569FFEBDEDAFFFCFBF9FFF9F9F8FFFAF8
      F7FFD68054FFD57B4EFFD37749FFF7F7F7FFF5F5F5FFF4F4F4FFF3F3F3FFF3F2
      F2FFF2F1F1FFF2F1F1FFF3F2F2FFCFC1B9FFFC7D00FFFAC288FFF9B46AFFFBB2
      68FFF9B064FFF9AC60FFF8AB59FFF6A854FFF4A650FFF4A247FFF4DFC8FFF3EF
      EAFF393CD1FFF3EFEAFFF4DFC8FFDF2A00FF670000FFB67A69FFA55D47FFA459
      45FFA15540FF9B4F3AFF984A35FF96442CFF96442CFF949498FF949498FFB282
      50FFB28250FF6A6C75FF857879FF0F0000FFFCBC00FFFDE272FFFBDC53FFFBDC
      53FFFBDB43FF8448FAFF763AF9FF7A3DF8FF7637F7FF7231F6FF6D2AF5FF58F4
      C7FF53F3C4FF53F3C4FF6AF4CBFF00D569FFBC2A00FFE3A280FFDC8C63FFDA88
      5EFFD98458FFD68054FFD57B4EFFD4794CFFD27647FFD17243FFCF6E3FFFCD6B
      3AFFCA6431FFCA6431FFD0794DFF890000FFFC7D00FFFAC288FFF9B870FFF9B4
      6AFFFBB268FFF9B064FFF9AC60FFF8AB59FFF6A854FFF4A650FF7766B9FF4547
      D5FF393CD1FF393CD1FF7766B9FFDF2A00FF670000FFB97E6EFFA8614DFFA55D
      47FFA45945FFA15540FF9B4F3AFF984A35FF96442CFF8D3829FFD69559FF9494
      98FF747881FFA97445FF984A35FF0F0000FFFCBC00FFFEE379FFFDDD5CFFFBDC
      53FFFBDA4BFF884EFCFF7C40F8FF8043F9FF7A3DF8FF7637F7FF7231F6FF5CF5
      C9FF58F4C7FF58F4C7FF6EF7CEFF00DA72FFBC2A00FFE3A280FFDE8E65FFDC8B
      62FFDA885EFFD98458FFD68054FFD47C50FFD4794CFFD27647FFD17243FFCD6B
      3AFFCC6936FFCA6431FFD47C50FF890000FFA97E90FFCFA69CFFCE855DFFC296
      94FFC29694FFC57750FFD99D77FFD5AFA6FFF89E53FFF6A854FFF6E3CDFFF3EF
      EAFF4547D5FFF3EFEAFFF6E3CDFFE53900FF5F2C7CFFB8919AFFB26952FF9A6D
      90FF9A6D90FFA45945FFB67A69FFA582A4FF984A35FF96442CFFE29851FFE2D3
      BBFF949498FFB9783BFF984A35FF0F0000FFFFC300FFFEE379FFFDDD5CFFFDDD
      5CFFFBDC53FF8B53FBFF8043F9FF8448FAFF8043F9FF7A3DF8FF7738F7FF63F6
      CCFF5FF5CAFF5CF5C9FF72F5CFFF00DA72FFBF3300FFE5A686FFDE916AFFDE91
      6AFFDC8B62FFDA885EFFD98458FFD78358FFD68054FFD57B4EFFD37749FFD172
      43FFCF6E3FFFCD6B3AFFD68054FF890000FF8F5468FFC5BDE2FFA97E90FF8D7B
      C2FF8D7BC2FFC29694FFAFA6D9FFA97E90FFFAA35BFFF8AB59FF6762CDFF54B2
      E7FF54B2E7FF54B2E7FF746CCBFFE53900FFAF7672FFD2CDEFFFB8919AFF9888
      D6FF9888D6FFD4AE9DFFB7B2E8FFA582A4FF9D523DFF984A35FFE29851FFB6A8
      79FFB1AB85FFB9783BFF9D523DFF290000FFFFC300FFFFE680FFFEE063FFFDDD
      5CFFFEE158FF9059FDFF8448FAFF884EFCFF8448FAFF8043F9FF7A3DF8FF68F7
      CEFF63F6CCFF5FF5CAFF72F5CFFF00E17EFFF3E9E3FFFEFEFDFFFEFEFDFFFDFC
      FBFFDE8E65FFDC8C63FFDA885EFFFAFAF9FFF9F9F8FFFAF8F7FFF8F7F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD7C9C1FF482283FFBEB7E4FFA6A8F1FF8484
      E5FF8484E5FFA6A8F1FF8E88D7FF957AACFFFAA35BFFF9B05BFF6762CDFF5C5B
      D3FF54B2E7FF5352CFFF746CCBFFE53900FF4723A2FFBEB8F2FF9DA0FEFF7C7D
      FDFF8685FAFF9DA0FEFF8D87EBFF967BBCFFA45945FF9B4F3AFFE29851FFE2D3
      BBFFE2D3BBFFD78B44FF9E5543FF290000FFFFC300FFFFE680FFFEE063FFFEE0
      63FFFEE158FF9059FDFF884EFCFF8B53FBFF884EFCFF8448FAFF8043F9FF6EF7
      CEFF68F7CEFF63F6CCFF79F7D3FF00E58FFFF3EBE5FFFFFFFFFFFEFEFDFFFEFE
      FDFFDE916AFFDE8E65FFDC8C63FFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F8FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFDBCFC7FF1818CFFF9594E7FF8484E5FF7374
      E4FF7374E4FF7374E4FF7374E4FF7873D8FFF9AC60FFFAB361FFFAB361FFF9B0
      5BFFF8AB59FFF6A854FFF9B46AFFEA4700FF1412FDFF9493FCFF7C7DFDFF7374
      FCFF6667FEFF7374FCFF7374FCFF6F6BF0FFA15D51FFA15540FFD69559FFD695
      59FFD8904BFFD78B44FFA55D47FF290000FFFFC300FFFFE680FFFFE680FFFFE6
      80FFFEE878FFA376FDFFA376FDFFA376FDFF9B6AFCFF9B6AFCFF9B6AFCFF85F9
      D7FF85F9D7FF85F9D7FF79F7D3FF00ED97FFF3EBE5FFFFFFFFFFFFFFFFFFFEFE
      FDFFE5A686FFE3A483FFE3A280FFFEFEFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F8FFF8F8F8FFF7F7F7FFDDD3CDFF65090FFFC5BDE2FFDAD3E6FFAFA6
      D9FFAFA6D9FFBEB7E4FFDAD3E6FFCFA69CFFF7BB84FFFAC288FFFBBF7BFFFBBF
      7BFFF9BC76FFF9B870FFF9B870FFEA4700FF8D3829FFBEB8F2FFE2D8E6FFB6AE
      E9FFA9A1E7FFC3BCE9FFD2CDEFFFD4AE9DFFB67A69FFB47765FFB27360FFAF6E
      5CFFAB6956FFAB6956FFA8614DFF290000FFFFC300FFFFC300FFFFC300FFFFC3
      00FFF3C500FF2900FDFF2900FDFF2900FDFF1700F9FF1700F9FF1700F9FF00F0
      A1FF00F0A1FF00F0A1FF00F0A1FF00ED97FFF3EBE5FFF3EBE5FFF3EBE5FFF3EB
      E5FFBC2A00FFBC2A00FFBF3300FFE9DBD6FFEDE2DDFFEDE2DDFFEBDEDAFFEBDE
      DAFFE9DBD6FFE5D9D3FFE3D7D1FFD7C9C1FF746CCBFF956681FF65090FFF3A12
      7EFF3C1889FF65090FFF4A1866FF7766B9FFF65C00FFF87200FFF87200FFF365
      00FFF36500FFF36500FFEF5600FFEF5600FF7769D6FFA77887FF931C00FF4723
      A2FF4723A2FF670000FF5F2C7CFF7769D6FF670000FF670000FF4B0000FF4B00
      00FF4B0000FF4B0000FF4B0000FF4B0000FFE6E6E9FFE5E5E5FFE3E3E3FFE1E1
      E1FFDFDFDFFFDDDDDDFFCBCBD7FF000098FF000098FFBFBFD1FFCFCFD0FFCFCF
      D0FFCFCFD0FFCBCBCBFFCBCBCBFFCBCBCBFF0000B1FF400054FFBA0000FFCF02
      00FFCF0200FFCF0200FFCF0200FFCF0200FFCF0200FFBA0000FFBA0000FFBA00
      00FFBA0000FFBA0000FFBA0000FFBA0000FF0000F3FF0000F3FF0000F3FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000F2FF0000F2FF0000F2FF0000
      F2FF0000EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000EAFF0000E0FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFFEAEAEAFFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF1F1F7FF4B4BD5FF4646D3FFECECF3FFF4F4F4FFF3F3
      F3FFF3F2F2FFF2F2F2FFF2F2F2FFCBCBCBFF0000E6FF6065F3FF625EEDFF7D63
      D3FFA971ACFFDD8A7DFFEA8865FFEA8865FFEA8865FFEA8865FFEA8865FFE47B
      57FFE47B57FFE47B57FFE47B57FFBA0000FF0000F9FF6262FCFF5B5BFCFF5B5B
      FCFF5252FAFF5252FAFF4A4AF7FF4343F7FF4343F7FF3A3AF5FF3A3AF5FF3232
      F4FF3232F4FF2C2CF4FF2C2CF4FF0000DDFF0000F9FF6160FBFF6160FBFF5353
      F9FF5353F9FF5353F9FF4545F8FF4545F8FF4545F8FF3A3AF5FF3A3AF5FF3333
      F4FF3333F4FF2D2DF2FF2D2DF2FF0000DDFFEAEAEAFFFDFDFDFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF1F1F7FF3030CFFF2727CCFFECECF3FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCBCBCBFF0000E6FF6065F3FF4548EAFF3A75
      F4FF3A75F4FF3938E8FF5D3BC5FF95508AFFD17067FFE76C3BFFE76C3BFFE76C
      3BFFE76C3BFFE76C3BFFE47B57FFBA0000FF0000F9FF6262FCFF4343FAFF3C3B
      F9FF3C3BF9FF3535F8FF2C2CF4FF2C2CF4FF2020F5FF2020F5FF1515F3FF1515
      F3FF0C0CF1FF0C0CF1FF2C2CF4FF0000E0FF0000F9FF6160FBFF4545F8FF3C3C
      FAFF3A3AF5FF3333F4FF302DF5FF5A43CBFF5A43CBFF221DF1FF1515F3FF1515
      F3FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FFEDEDEDFFFDFDFDFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF1F1F7FF3535D1FF3030CFFFEEEEF4FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFCFCFD0FF0000E6FF7390F5FF42CEF7FF45AF
      F4FF42CEF7FF39B9F4FF3A75F4FF2828EBFF302DDDFF5E3AB5FF95508AFFCC63
      57FFE76C3BFFE76C3BFFE47B57FFBA0000FF00FDFDFF6CFDFDFF4BFCFCFFA8CE
      C0FF4AC9EBFF49A7E4FF9DBBB6FF40F2F0FF2AF6F6FF24F5F5FF1EF4F4FF18F3
      F3FF12F2F2FF12F2F2FF2FF6F6FF00DFDFFF0000F9FF6984FCFF4666FBFF4666
      FBFF3E60FAFF3857F4FFD7AB76FFE2B164FFE2B164FFD1A36AFF2441EFFF1840
      F3FF1139F2FF1139F2FF3857F4FF0000E0FF3E3EC9FFAFAFEEFF9696E8FF9394
      E4FF8F8FE5FF8F8FE5FF8686E2FF3B3BD3FF3535D1FF7979DEFF7979DEFF7676
      DBFF7171D9FF7171D9FF8383DDFF000098FF0000E6FF72D9FBFF54A1F6FF4BB9
      F9FF43C1F6FF4D98F4FF42CEF7FF425BEEFF3331F1FF2828EBFF2828EBFF302D
      DDFF5E3AB5FF95508AFFD17067FFCF0200FF00FDFDFF6CFDFDFF4BFCFCFFD6F1
      F9FF508CE0FF5052ECFFE2EAF5FF4DDFEEFF2FF6F6FF2AF6F6FF24F5F5FF1EF4
      F4FF18F3F3FF12F2F2FF3AF5F4FF00E6E6FF00FDFDFF72FEFEFF4AFCFCFF4AFC
      FCFF4AFCFCFFD5C589FFE6BB76FFB1CA99FF89D5B0FFE2B164FFCBBA78FF1BF3
      F3FF1BF3F3FF1BF3F3FF3AF5F4FF00E5E5FF0000BCFF7474E2FF5454DBFF5454
      DBFF5454DBFF4C4CD8FF4646D6FF4141D4FF3B3BD3FF3535D1FF3030CFFF2727
      CCFF2727CCFF2727CCFF4141D4FF000098FF0000E6FF72D9FBFF6065F3FF50C4
      F8FF50C4F8FF4548EAFF43C1F6FF3A75F4FF3938E8FF3938E8FF2828EBFF2828
      EBFF1C1CF3FF1C1CF3FF4949D3FF000000FF00FDFDFF75FEFEFF52FDFDFFB1C3
      F5FF5467ECFFD4D3ECFFB0BDF2FF41E1ECFF35F8F8FF2FF6F6FF2AF6F6FF24F5
      F5FF1EF4F4FF18F3F3FF3AF5F4FF00E6E6FF00FDFDFF72FEFEFF53FDFDFF4AFC
      FCFF4AFCFCFFD5C589FF92DBBAFFB1CA99FFB1CA99FF89D5B0FFDFB46BFF26F5
      F5FF1BF3F3FF1BF3F3FF3AF5F4FF00E5E5FF5454D1FFAFAFEEFFA3A3EBFFA3A3
      EBFF9E9EE9FF9E9EE9FF9696E8FF4646D6FF4141D4FF8A8AE2FF8A8AE2FF8A8A
      E2FF8383DDFF8383DDFF9394E4FF000098FF0000E6FF72D9FBFF4D98F4FF54A1
      F6FF50C4F8FF425BEEFF42CEF7FF425BEEFF3938E8FF3331F1FF3331F1FF302D
      DDFF274EAAFF206F6DFF389E4EFF005000FF00FDFDFF75FEFEFF59FEFEFF54F3
      F2FF567DF1FF5467ECFF8DE0EDFF40F2F0FF3BF9F9FF35F8F8FF2FF6F6FF2AF6
      F6FF24F5F5FF1EF4F4FF3AF5F4FF00E6E6FF00FDFDFF72FEFEFF53FDFDFF53FD
      FDFF53FDFDFFD5C589FFE6BB76FF92DBBAFFB1CA99FFDFB46BFFCBBA78FF26F5
      F5FF26F5F5FF1BF3F3FF3AF5F4FF00E5E5FFF1F1F1FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFF5F5FBFF4C4CD8FF4746D7FFF3F3F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF4F4F4FFF6F6F6FFD8D8D8FF0000E6FF7390F5FF57CDFAFF57CD
      FAFF50C4F8FF57CDFAFF4BB9F9FF4946F5FF4548EAFF3D60B8FF377D81FF389E
      4EFF29A929FF29A929FF46B546FF005000FF00FDFDFF75FEFEFF59FEFEFF59FE
      FEFF56EEF4FF4DDFEEFF4AF4F8FF44FBFBFF44FBFBFF3BF9F9FF35F8F8FF2FF6
      F6FF2AF6F6FF24F5F5FF4AF4F8FF00E6E6FF006400FF8FBB8FFF72A96FFF72A9
      6FFF72A96FFF72A96FFFE6BB76FFE6BB76FFE6BB76FFDFB46BFF50924DFF5092
      4DFF50924DFF50924DFF619D60FF001800FFF1F1F1FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFF5F5FBFF5454DBFF4C4CD8FFF3F3F9FFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFD8D8D8FF0000E6FF7C7BF6FF6065F3FF5A78
      F7FF5A78F7FF5A78F7FF5167CAFF4D8797FF47AF53FF46B546FF39B239FF39B2
      39FF30AC30FF29A929FF46B546FF005000FF0000FFFF7979FFFF5B5BFCFF5B5B
      FCFF5B5BFCFF5252FAFF5252FAFF4B4BFCFF4343FAFF4343FAFF3C3BF9FF3535
      F8FF3232F4FF2C2CF4FF4A4AF7FF0000ECFF0F4800FF94AD78FF7E9B5DFF7997
      58FF799758FF739552FF739552FF8B984FFF8B984FFF6A8B45FF608139FF6081
      39FF59782EFF59782EFF6A8B45FF000000FFF1F1F1FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFF8F8FCFF7474E2FF6D6DE0FFF5F5FBFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDDDDDDFF0000E6FF7C7BF6FF7C7BF6FF7989
      D8FF77A0B1FF74B68AFF68C468FF68C468FF68C468FF68C468FF68C468FF56BC
      57FF56BC57FF56BC57FF46B546FF005000FF0000FFFF7979FFFF7979FFFF7979
      FFFF7979FFFF7271FEFF7271FEFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5B5B
      FCFF5252FAFF5252FAFF4A4AF7FF0000ECFF0F4800FF95B07AFF95B07AFF94AD
      78FF94AD78FF8EAA71FF8EAA71FF84A368FF84A368FF84A368FF7E9B5DFF7E9B
      5DFF799758FF739552FF6F934DFF000000FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF1EFEFFFE6E6E9FF0000BCFF0000BCFFDBDBE9FFEAEAEAFFE6E6
      E9FFE5E5E5FFE3E3E3FFE1E1E1FFDFDFDFFF0008C3FF00345EFF006E01FF0088
      00FF008800FF008800FF008800FF008800FF008800FF006E01FF006E01FF006E
      01FF006E01FF005000FF006E01FF005000FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000F9FF0000F9FF0000F9FF0000
      F3FF0000F3FF0000F3FF0000ECFF0000ECFF205800FF0F4800FF0F4800FF0F48
      00FF0F4800FF0F4800FF0F4800FF003200FF003200FF003200FF003200FF0032
      00FF001800FF001800FF001800FF001800FF0000E8FF0000D7FF0000D7FF0000
      D7FF0000D7FF0000D7FF0000D7FF0000C8FF0000C8FF0000C8FF0000C8FF0000
      C8FF0000C8FF0000C8FF0000C8FF0000C8FFDFDFDFFFDADADAFFDADADAFFD8D7
      D8FFD8D7D8FFD1D1D1FFD1D1D1FFD1D1D1FFCACACAFFCACACAFFC5C5C5FFC5C5
      C5FFC3C3C3FFC1C1C1FFBFBFBFFFBFBFBFFF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF006900FF006900FF004F00FF004F
      00FF004F00FF004F00FF004F00FF003900FF003900FF003900FF002900FF0029
      00FF002900FF002900FF002900FF0000B5FF0000E8FF5C62F7FF5C62F7FF5C62
      F7FF5257F4FF5257F4FF4A4FF2FF4349F2FF4349F2FF3A41F0FF3A41F0FF3036
      EDFF3036EDFF3036EDFF3036EDFF0000D7FFE2E2E2FFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF2F2F2FFBFBFBFFF000000FF626161FF5A5A5AFF5A5A
      5AFF525151FF525151FF4A4A4AFF434343FF434343FF3B3B3BFF3B3B3BFF3333
      33FF333333FF2C2C2CFF2C2C2CFF000000FF006900FF63BF63FF5ABB5AFF5ABB
      5AFF52B651FF52B651FF48B148FF48B148FF41AE41FF3AAB3AFF3AAB3AFF34A9
      34FF31A631FF2EA330FF2B2BE2FF0202DFFF0000C8FF7171E9FF5151E3FF4A4A
      E1FF4A4AE1FF4242DFFF3939DBFF3939DBFF3939DBFF2929D6FF2929D6FF2929
      D6FF1E1ED4FF1E1ED4FF3939DBFF0000A5FFE2E2E2FFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFC1C1C1FF000000FF656565FF434343FF3B3B
      3BFF3B3B3BFF333333FF2C2C2CFF2C2C2CFF202020FF202020FF101110FF1011
      10FF101110FF101110FF2C2C2CFF000000FF006900FF63BF63FF41AE41FF41AE
      41FF3AAB3AFF34A934FF2BA42BFF2BA42BFF209E20FF209E20FF159B15FF159B
      15FF0D9611FF0202DFFF2E2EF2FF0202DFFFA22800FFD7A379FFCD8D5BFFCA89
      54FFC88550FFC6814BFFC37C45FFC17941FFBE7339FFBE7339FFBB6C2FFFBB6C
      2FFFB66526FFB66526FFC17941FF5A0000FFE5E5E5FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFC3C3C3FF2C2C2CFFA0A0A0FF8A8A8AFF8A8A
      8AFF828282FF828282FF7A7A7AFF63CCDFFF63CCDFFF706F6FFF6B6A6AFF6B6A
      6AFF656565FF626161FF7A7A7AFF000000FFDCECDEFFEFF7EFFFEBF4EBFFE9F3
      E9FFE9F3E9FFE7F1E7FFE7F1E7FFE2EEE2FFE2EEE2FFE2EEE2FFE2EEE2FFDCEC
      DEFF1919E3FF1111F2FF3333F4FF0202DFFFA22800FFD7A379FFCD8D5BFFCD8D
      5BFFCA8954FFC88550FFC6814BFFC37C45FFC17941FFBE7339FFBE7339FFBB6C
      2FFFBB6C2FFFB66526FFC37C45FF5A0000FF000000FF6E6E6EFF4E4E4EFF4949
      49FF454545FF3F3F3FFF3A3A3AFF353535FF2F2F2FFF2A2A29FF212121FF2121
      21FF171717FF171717FF353535FF000000FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFF7CE1F3FF86D9E9FF86D9E9FF73DDF0FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE5E5E5FFEFF7EFFFFEFEFEFFFCFCFCFFFBFC
      FBFFFBFCFBFFF9F9F9FFC9C9FAFF8483F9FF7878F8FFF7F7F7FFECECECFF1919
      E3FF1A1AF3FF1111F2FF3333F4FF0000E7FF895210FFCAB497FFBEA381FFBC9F
      7BFFBC9F7BFFB79A73FFB79A73FFB1936BFFB1936BFFAD8D62FFAD8D62FFA683
      58FFA68358FFA68358FFB1936BFF5A0000FF000000FF747373FF535353FF4E4E
      4EFF494949FF454545FF3F3F3FFF3A3A3AFF353535FF2F2F2FFF2A2A29FF2121
      21FF212121FF171717FF3A3A3AFF000000FFFDFDFDFFFDFDFDFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFF86E1F1FF86E1F1FF73DDF0FF73DDF0FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE5E5E5FFF2F9F2FFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFC9C9FAFF6161FAFFE0DFF7FF7878F8FFF7F7F7FF2B2BD8FF2323
      F5FF1A1AF3FF1A1AF3FF3C3CF5FF0000E7FF0ADFFDFF8FF0FEFF77ECFEFF72EB
      FDFF72EBFDFF6AE9FCFF6AE9FCFF62E7FAFF62E7FAFF56E3F7FF56E3F7FF56E3
      F7FF4BDFF5FF4BDFF5FF61E2F5FF00BDE8FF000000FF747373FF575757FF5353
      53FF4E4E4EFF494949FF454545FF3F3F3FFF3A3A3AFF353535FF2F2F2FFF2A2A
      29FF212121FF212121FF3F3F3FFF000000FFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFCFCFCFFFCFCFCFFFAFAFAFF97E5F2FF7CE1F3FFF3F8F7FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFE5E5E5FFF2F9F2FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFC9C9FAFF9191FAFF8483F9FFF9F9F9FFF3F3F7FF2B2B
      D8FF2323F5FF2323F5FF3C3CF5FF0000E7FF18D7F9FF97EDFCFF81E8FBFF7CE6
      F9FF7CE6F9FF74E5F9FF74E5F9FF6CE1F6FF6CE1F6FF63DFF5FF63DFF5FF59DC
      F3FF59DCF3FF59DCF3FF6CE1F6FF00B2E1FFBF4000FFE4AE77FFDE9E5DFFDD9B
      58FFDB9853FFD99551FFD8924BFFD78F46FFD48B42FFD4883CFFD28436FFD081
      30FFCD7A29FFCD7A29FFD48B42FF990000FF3434F1FFA4A4F8FF9090F6FF8E8E
      F6FF8A8AF5FF8A8AF5FF8585F4FF807DEFFF75BBF2FF7979F5FF7171F0FF7171
      F0FF6A6AEDFF6A6AEDFF7D7DEDFF0000D5FFE0E0E2FFF1F1F1FFECECECFFECEC
      ECFFECECECFFECECECFFE9E9E9FFE9E9E9FFE9E9E9FFE6E6E6FFE6E6E6FFE0E0
      E2FF2B2BD8FF2323F5FF4646F7FF0000E7FF18D7F9FF97EDFCFF81E8FBFF81E8
      FBFF7CE6F9FF7CE6F9FF74E5F9FF74E5F9FF6CE1F6FF6CE1F6FF63DFF5FF63DF
      F5FF59DCF3FF59DCF3FF72E1F5FF00B2E1FFBF4200FFE4B07AFFDE9E5DFFDE9E
      5DFFDD9B58FFDB9853FFD99551FFD8924BFFD78F46FFD48B42FFD4883CFFD284
      36FFD08130FFCD7A29FFD58F48FF990000FF0000EBFF7979F5FF5B5BF2FF5B5B
      F2FF5B5BF2FF5252F2FF5252F2FF4C4CEFFF4444EEFF4444EEFF3C3BECFF3333
      EAFF3333EAFF2B2BE9FF4848EBFF0000CFFF000000FF7C7D7DFF626262FF6262
      62FF5A5A5AFF5A5A5AFF525252FF525252FF464646FF464646FF464646FF3939
      3BFF39393BFF2B2BD8FF4646F7FF0000E7FF18D7F9FF97EDFCFF97EDFCFF97ED
      FCFF97EDFCFF91EBFBFF91EBFBFF8CE9FAFF8CE9FAFF85E7F8FF85E7F8FF7CE6
      F9FF79E3F7FF79E3F7FF72E1F5FF00BDE8FFBF4200FFE4B07AFFE4B07AFFE4AE
      77FFE4AE77FFE2AB73FFE1A86EFFE1A86EFFDEA366FFDEA366FFDE9E5DFFDB9B
      5BFFD99857FFD99551FFD8924BFF990000FF0000EBFF7979F5FF7979F5FF7979
      F5FF7575F6FF7575F6FF7171F0FF6A6AF3FF6A6AF3FF6262F2FF6262F2FF5B5B
      F2FF5454EEFF5454EEFF4C4CEFFF0000D5FF000000FF7C7D7DFF7C7D7DFF7C7D
      7DFF7C7D7DFF737373FF737373FF737373FF6B6B6BFF6B6B6BFF626262FF6262
      62FF5A5A5AFF5A5A5AFF4E4EDEFF0000E7FF18D7F9FF18D7F9FF18D7F9FF18D7
      F9FF18D7F9FF0ED2F7FF0ED2F7FF02CEF3FF02CEF3FF02CEF3FF00C6EEFF00C6
      EEFF00C6EEFF00BDE8FF00BDE8FF00BDE8FFBF4200FFBF4200FFBF4200FFBF42
      00FFBF4000FFBB3600FFBB3600FFBB3600FFB32600FFB32600FFB32600FFAB15
      00FFAB1500FFA40800FFA40800FF990000FF0000EBFF0000EBFF0000EBFF0000
      EBFF0000E9FF0000E9FF0000E5FF0000E5FF0000E5FF0000E5FF0000E5FF0000
      DBFF0000DBFF0000DBFF0000DBFF0000D5FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF0000B5FF0000E6FF0000E1FF0000E1FF0000
      DBFF0000D5FFEDEDEDFFCFCFE9FF0000D5FF0000CEFF0000CEFF0000CEFF0000
      C8FF0000C8FF0000C5FF0000C5FF0000C8FF006A00FF006A00FF006A00FF0052
      00FF005200FF005200FF005200FF00BDE8FF000000FFE4E4E4FF002D00FF002D
      00FF002D00FF002D00FF002D00FF002D00FF0000D4FF0000D4FF0000CCFF0000
      CCFF0000CCFF0000C4FF0000C4FFD1D5E9FFE7DFD9FF600000FF600000FF6000
      00FF560000FF560000FF560000FF560000FF0F4A00FF002B00FF002B00FF002B
      00FF000E00FF000E00FF000E00FF000E00FFC8C9C6FFD1D1D1FFD1D1D1FFCECE
      CEFFCBCBCBFFCBCBCBFFC8C9C6FFC8C9C6FF0000E6FF6060F2FF5C5CF2FF5757
      F1FF5353F0FFF8F8F8FFEBEBF7FF4D4DEEFF4242ECFF3D3DEBFF3838EAFF3434
      E8FF3131E8FF2D2DE7FF2D2DE7FF0000C5FF006A00FF68C268FF62BF62FF62BF
      62FF5BBA5BFF5BBA5BFF53B653FF5AE5F6FF42494AFFF4F4F4FF43B043FF3EAD
      3EFF3BAA3BFF38A838FF38A838FF002D00FF0000D4FF6060EDFF5C5CECFF5655
      EBFF5655EBFF4E4EEAFF4949E7FFEBEDF7FFF6F3EEFFC0775FFFBD725AFFBD72
      5AFFBB6E56FFB96B52FFB96B52FF560000FF0F4A00FF8FAA73FF89A76BFF86A4
      67FF809E60FF7A9B5AFF729553FF799C53FFF2F4EBFFF3F3F3FFF3F3F3FFF2F2
      F2FFF2F2F2FFF0F0F0FFF0F0F0FFC8C9C6FF0000E6FF6565F3FF4444F0FF3D3D
      EFFF3A3AEFFFF8F8F8FFEAEAF8FF3030ECFF2121EAFF1E1EE8FF1818E7FF1111
      E5FF0C0CE4FF0C0CE4FF2D2DE7FF0000C5FF008000FF68C268FF4CB44CFF4CB4
      4CFF43B043FF3EAD3EFF377CAAFF306EF3FF3255E0FF426BF1FF216C9FFF209F
      20FF1A9B1AFF1A9B1AFF3BAA3BFF002D00FF0000DBFF6565EEFF4343EAFF3D3D
      E7FF3939E7FF3435E7FF2B2BE4FFEBEDF7FFF6F3EEFFB66146FFB45E42FFB25A
      3EFFAF5538FFAF5538FFB96B52FF560000FF0F4A00FF94AE78FF7A9B5AFF7295
      53FF6D914BFF688E44FF5F853DFF5F7A73FFB8B9EDFFE9E9F4FFF2F2F2FFF1F1
      F1FFF0F0F0FFEFEFEFFFF0F0F0FFCBCBCBFF0000E6FF6969F4FF4848EFFF4444
      F0FF3D3DEFFFF9F9F9FFEAEAF8FF3636EDFF2A2AEBFF2424E9FF1E1EE8FF1818
      E7FF1111E5FF1111E5FF3131E8FF0000C8FF008000FF77C877FF55B955FF4CB4
      4CFF4CB44CFF4183AFFF3571E6FF35B795FF296CF1FF2DB573FF1E61DDFF216C
      9FFF209F20FF1A9B1AFF3BAA3BFF002D00FF0000DBFF6969EFFF4849EBFF4343
      EAFF3D3DE7FF3939E7FF3435E7FFEBEDF7FFF6F3EEFFB9664CFFB66247FFB45E
      42FFB25A3EFFAF5538FFBB6E56FF560000FF275B00FF98B27DFF809E60FF7A9B
      5AFF729553FF5F7A73FF4F57DBFF4652DCFF6771E5FFCBCBF5FFE9E9F4FFF2F2
      F2FFF1F1F1FFF0F0F0FFF2F2F2FFCBCBCBFFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFE4E4E4FFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFF6184F7FF35B795FF3573F3FF37E1F6FF31C853FF2DB573FF426B
      F1FFF4F4F4FFF4F4F4FFF4F4F4FFE4E4E4FF0000DBFF6E6EF0FF4E4EEAFF4849
      EBFF4343EAFF3D3DE7FF3939E7FFF3F4F9FFF7F6F5FFB96B52FFB9664CFFB662
      47FFB45E42FFB25A3EFFBD725AFF600000FF275B00FF9FB686FF86A467FF809E
      60FF7A9B5AFF606DCEFF4F57DBFF729553FFCCCFE8FF737AE6FFF0F0F5FFF3F3
      F3FFF1F1F1FFEFEFEFFFF2F2F2FFCECECEFFFDFDFDFFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFF9F9FAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFE4E4E4FF000000FF717677FF535959FF5359
      59FF535959FF526FE8FF3F72F4FFE3A34CFF31C853FF2F6AEAFF2A65EFFF3255
      E0FF22292AFF22292AFF42494AFF000000FFFDFDFDFFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFAFAFAFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F4FFF5F5F4FFF3F3F3FFF5F5F4FFE5E5E5FF346501FFA3BA8DFF89A76BFF86A4
      67FF82A161FF6771E5FF5F6CB9FF80A24DFF4F5AE1FF4F5AE1FF4652DCFFF1F1
      F1FFF0F0F0FFECECECFFF3F3F3FFD1D1D1FF0000EBFF7475F7FF5858F4FF5353
      F3FF4E4EF2FFFCFCFCFFF1F1FBFF4140F0FF3A3AEFFF3636EDFF3030ECFF2A2A
      EBFF2424E9FF1E1EE8FF3D3DEBFF0000CEFF00E1FDFF83F1FEFF69EDFDFF69ED
      FDFF69EDFDFF5086F4FF4ACC8BFF4BFAE0FF52D53BFFE4A335FF2DB573FF3573
      F3FF40E2F5FF37E1F6FF5AE5F6FF00BDE8FFA02000FFD7A190FFCE8E78FFCC8A
      74FFCB8770FFC8826BFFC8826BFFFCF8F6FFF5F6FAFF3435E7FF3030E5FF2B2B
      E4FF2323E2FF2323E2FF3D3DE7FF0000BDFF3B6C0AFFA3BA8DFF90AB73FF8CA8
      6EFF89A76BFF6D78D7FF6771E5FF7B9A65FFD7D9EAFF878EE7FFEDEDF2FFEFEF
      EFFFECECECFFECECECFFF6F6F6FFD1D1D1FF0000EBFF7979F7FF5C5CF5FF5858
      F4FF5353F3FFFDFDFDFFF1F1FBFF4E4EF2FF4140F0FF3A3AEFFF3636EDFF3030
      ECFF2A2AEBFF2424E9FF4242ECFF0000CEFF008900FF81CD81FF62BF62FF62BF
      62FF5CBE5EFF5792BAFF5086F4FF4ACC8BFFE4A335FF5CBE5EFF3571E6FF377C
      AAFF34A934FF34A934FF4CB44CFF005200FFA32802FFD8A494FFCE8E78FFCE8E
      78FFCC8A74FFCB8770FFC8826BFFFBF7F2FFF3F4F9FF3939E7FF3435E7FF3030
      E5FF2B2BE4FF2323E2FF4343E6FF0000BDFF407010FFA9BF93FF94AE78FF90AB
      73FF8CA86EFF81988DFF6D78D7FF6771E5FF878EE7FFD5D5F2FFEDEDF2FFEFEF
      EFFFECECECFFECECECFFF6F6F6FFD6D6D6FF0000EFFF7979F7FF5C5CF5FF5C5C
      F5FF5858F4FFFDFDFDFFF1F1FCFF5353F3FF4444F0FF4140F0FF3A3AEFFF3636
      EDFF3030ECFF2A2AEBFF4848EFFF0000D5FF008900FF81CD81FF68C268FF68C2
      68FF62BF62FF5CBE5EFF5792BAFF5086F4FF546DE8FF6184F7FF4485B0FF43B0
      43FF3EAD3EFF38A838FF53B653FF005200FFA32802FFD8A494FFD0927DFFCE8E
      78FFCE8E78FFCC8A74FFCB8770FFFCF8F6FFF5F6FAFF4343EAFF3D3DE7FF3435
      E7FF3030E5FF2B2BE4FF4949E7FF0000C4FF407010FFA9BF93FF98B27DFF94AE
      78FF90AB73FF8CA86EFF86A467FF81988DFFD5D5F2FFEDEDF2FFF1F1F1FFEFEF
      EFFFEFEFEFFFECECECFFF6F6F6FFDADADAFF0000EFFF7979F7FF7979F7FF7979
      F7FF7475F7FFFEFEFEFFF4F4FDFF7475F7FF6969F4FF6565F3FF6060F2FF5C5C
      F2FF5757F1FF5353F0FF4D4DEEFF0000D5FF008900FF81CD81FF81CD81FF81CD
      81FF81CD81FF77C877FF77C877FF83F1FEFF717677FFFCFCFCFF68C268FF62BF
      62FF5CBE5EFF5BBA5BFF55B955FF005200FFA32802FFD8A494FFD8A494FFD8A4
      94FFD7A190FFD59E8DFFD59E8DFFFCF8F6FFF7F7FCFF6565EEFF6060EDFF5C5C
      ECFF5655EBFF5151E9FF4E4EEAFF0000C4FF3B6C0AFFA9BF93FFA9BF93FFA9BF
      93FFA3BA8DFFA3BA8DFF9FB686FF9FB686FFFAFAF9FFFAFAF9FFFAFAF9FFFAFA
      F9FFFAFAF9FFFAFAF9FFF6F6F6FFDADADAFF0000F1FF0000EFFF0000EFFF0000
      EFFF0000EBFFFDFDFDFFE7E7FBFF0000EBFF0000EBFF0000E6FF0000E6FF0000
      E1FF0000E1FF0000E1FF0000DBFF0000DBFF008900FF008900FF008900FF0089
      00FF008900FF008000FF008000FF00DBFDFF000000FFFCFCFCFF006A00FF006A
      00FF006A00FF006A00FF005200FF005200FFA32802FFA32802FFA32802FFA328
      02FFA02000FFA02000FFA02000FFFDF3EDFFEDEFFBFF0000DBFF0000D4FF0000
      D4FF0000D4FF0000CCFF0000CCFF0000CCFF4C7820FF407010FF407010FF4070
      10FF3B6C0AFF346501FF275B00FF346501FFE2E2E1FFE6E6E6FFE6E6E6FFE6E6
      E6FFE2E2E1FFE2E2E1FFDADADAFFDADADAFFEBEBEBFFE9E9E9FFE7E7E7FFE5E5
      E5FFE2E3E2FFDFDFDFFFDDDDDDFFDBDBDBFFD8D8D8FFD8D8D8FFD5D5D5FFD3D3
      D3FFD3D3D3FFCFCFCFFFCFCFCFFFCFCFCFFFB44300FF0000C3FF0000DAFF0000
      DAFF0000D5FF0000D5FF0000D5FF0000D5FF0000CAFF0000CAFF0000CAFF0000
      CAFF0000CAFF0000C3FF0000C3FF0000C3FF2E8AB3FF2E8AB3FF2E8AB3FF2E8A
      B3FF2E7CA8FF2E7CA8FF2E86A8FF2E86A8FF2E86A8FF2E849BFF2E7CA8FF2E76
      9DFF2E7CA8FF2E769DFF2E769DFF2E769DFF8DDF8DFF00A900FF00A900FF00A9
      00FF00A900FF00A900FF009600FF009600FF009600FF009600FF009600FF0087
      00FF008700FF008700FF008700FF008700FFEDEDEDFFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF3F2F2FFF2F2F2FFF2F2F2FFCFCFCFFFB44300FFDEAA84FF9985C7FF5655
      F0FF5655F0FF4F4FEEFF4A4AEDFF4343ECFF4343ECFF393AECFF393AECFF3535
      E8FF3131E8FF2D2DE7FF2D2DE7FF0000C3FF2EA4B6FF97EBF9FF97EBF9FF97EB
      F9FF97EBF9FF87E5F6FF87E5F6FF87E5F6FF79E0F3FF79E0F3FF79E0F3FF6DDC
      F0FF6DDCF0FF6DDCF0FF6DDCF0FF2E769DFFF7F7F7FFE9F7E9FF96E795FF53D8
      53FF53D853FF53D853FF48D649FF43D343FF43D343FF38D038FF38D038FF32CD
      33FF32CD33FF2CCC2CFF2CCC2CFF008700FFEFEFEFFFFCFCFCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFDFEDDFFFA2D39CFFE1ECE1FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCFCFCFFFB44300FFE0AF8BFFD89D70FF896B
      AFFF393AECFF3333EDFF2D2DEBFF2929EAFF2323E9FF1E1EE8FF1818E6FF1212
      E5FF0C0CE3FF0C0CE3FF2D2DE7FF0000C3FF2EA4B6FFA2F1FBFF64E5F8FF64E5
      F8FF56E1F5FF56E1F5FF47DCF2FF47DCF2FF39D8EEFF39D8EEFF2BD3EAFF2BD3
      EAFF21CFE8FF1CCDE6FF6CE0EFFF2E849BFFF9FAF9FFFDFCFDFFFBFAFAFFB1EB
      B1FF48D649FF32CD33FF2CD12CFF2CCC2CFF22CD22FF1EC91EFF18C918FF11C5
      11FF0CC30CFF0CC30CFF2CCC2CFF008700FFF1F1F1FFFCFCFCFFFBFBFBFFFBFB
      FBFFF7F9F8FFA2D39CFF8EC785FFAED7A6FF8EC785FF8EC785FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFD3D3D3FFBD5204FFE0AF8BFFDAA075FFD89D
      70FF896BAFFF393AECFF3333EDFF2E2EECFF2929EAFF2323E9FF1E1EE8FF1818
      E6FF1212E5FF1212E5FF3131E8FF0000CAFF2E7CA8FFA4D5FCFF68B2F6FF68B2
      F6FF55A6F5FF55A6F5FF55A6F5FF439BF2FF439BF2FF3592EFFF3592EFFF2689
      EBFF2689EBFF1C82E8FF68B2F6FF2E3EA5FFFBFBFBFFFDFCFDFFFBFBFBFFFBFB
      FBFFDDF4DDFF73DE73FF32CD33FF2CCC2CFF2CCC2CFF22CD22FF1EC91EFF18C9
      18FF11C511FF11C511FF32CD33FF008700FFF1F1F1FFFDFDFDFFFCFCFCFFFBFC
      FBFFF9FAF8FFB1DFBBFF9BE5F3FFD5F1F8FFC0E4CEFFADD8A5FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD3D3D3FFBD5204FFE2B492FFDBA379FFDAA0
      75FFD89D70FF896BAFFF393AECFF3333EDFF2E2EECFF2929EAFF2323E9FF1E1E
      E8FF1818E6FF1212E5FF3535E8FF0000CAFF3040BDFFA9B2FCFF6B6BFBFF6565
      FAFF5F5FF9FF5858F7FF5151F6FF4646F3FF4646F3FF3B3BF1FF3232EFFF2828
      EDFF2828EDFF1D1DEAFF6F80F2FF2E3EA5FFFDFCFDFFFBFBFBFF9898FCFFF2F2
      FCFFFBFBFBFFF9FAF9FFB1EBB1FF48D649FF2CD12CFF2CD12CFF22CD22FF22CD
      22FF18C918FF13CA13FF38D038FF009600FFF3F3F3FFFEFEFEFFFDFDFDFFFCFC
      FCFFF1F9FBFF63DDFBFF3FD3FAFF3ED3F9FF57D7FAFF9BE5F3FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFD5D5D5FFBD5204FFE4B897FFDDA67DFFDBA3
      79FFDAA075FFDE9D62FF9985C7FF9B9BF4FF9B9BF4FF9494F1FF9494F1FF8F8F
      F0FF8B8BEFFF8B8BEFFF9999EFFF0000D5FF3040BDFFA9B2FCFF7474FCFF6B6B
      FBFF6565FAFF5F5FF9FF5858F7FF5151F6FF4646F3FF4646F3FF3B3BF1FF3232
      EFFF2828EDFF2828EDFF6F80F2FF2E3EA5FFFDFCFDFFC1C1FEFF9898FCFF9898
      FCFFFDFCFDFFFBFBFBFFFBFAFAFFD6E3BFFFCAB270FFCAB270FFC4AC64FFC4AC
      64FFC4AC64FFC0A65CFFCAB270FF814800FFF5F5F5FFFEFEFEFFFEFEFEFFFDFD
      FDFFC5F1FDFF69DAFCFF57D7FAFF41CDFAFF41CDFAFF46D5F8FF9BE5F3FFF0F5
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD8D8D8FFC45C0CFFE4B897FFDEAA84FFDDA6
      7DFFE1A46CFFECD2BDFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF5F5F5FFF5F5F5FFD7D7D7FF3040BDFFA9B2FCFF7474FCFF7474
      FCFF6B6BFBFF6565FAFF5F5FF9FF5858F7FF5151F6FF4646F3FF4646F3FF3B3B
      F1FF3232EFFF2828EDFF6F80F2FF2E3EA5FFFDFCFDFFFDFCFDFFC1C1FEFFF2F2
      FCFFFDFCFDFFFBFAFAFFFED9C7FFF9B494FFF7A98CFFF7A98CFFF7A484FFF7A4
      84FFF59E7CFFF59E7CFFF7A98CFFE73800FFF5F5F5FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFDFDFFD3F3FDFFE4F7FCFF8CDFFBFFF1F9FBFFD6F2F9FF7AD9F8FF77D6
      F7FFF3F6F6FFF5F5F5FFF6F6F6FFDBDBDBFFC45C0CFFE6BA9BFFDEAA84FFE5AB
      75FFECD2BDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFDDDDDDFF3B4865FFAFB8CAFF7B7B9DFF7B7B
      9DFF717195FF717195FF64648CFF64648CFF5A5A83FF4A4B77FF4A4B77FF4A4B
      77FF383868FF383868FF7C8B99FF2E3E3EFFFFFFFFFFFEFEFEFFFEFEFEFFFEFE
      FEFFFDF1EAFFFEC7ABFFFAB18DFFFAB18DFFFAB18DFFF9AD89FFF8AB84FFF7A9
      81FFF6A47BFFF6A47BFFFAB18DFFE94900FFF5F5F5FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFDDDDDDFFC45C0CFFE6BA9BFFE5AB75FFEFD5
      C2FFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFDDDDDDFF394749FFB1BABAFF818180FF8181
      80FF777777FF777777FF686768FF686768FF686768FF575757FF575757FF4649
      49FF464949FF393E3EFF7C8B99FF2E3E3EFFFFFFFFFFFFFFFFFFFEFEFEFFFEE4
      D6FFFCBFA0FFFCB794FFFCB794FFFCB794FFFAB18DFFFAB18DFFF9AD89FFF8AB
      84FFF7A981FFF6A47BFFFAB18DFFE94900FFF5F5F5FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDFDFDFFFC45C0CFFEABC91FFF2DDCEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDDDDDDFF394749FFB1BABAFFB1BABAFFB1BA
      BAFFABB5B5FFABB5B5FFA3ADADFFA3ADADFFA3ADADFF99A4A4FF99A4A4FF909C
      9CFF909C9CFF879494FF879494FF2E3E3EFFFFFFFFFFFFF7F3FFFED9C7FFFEC7
      ABFFFEC7ABFFFEC7ABFFFEC7ABFFFDC3A6FFFDC3A6FFFCBFA0FFFCBFA0FFFABA
      9AFFFABA9AFFFCB794FFF9B494FFE94900FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFF1EFEFFFEFEFEFFFEDEDEDFFEDEDEDFFEBEBEBFFE9E9E9FFE7E7
      E7FFE5E5E5FFE2E3E2FFE1E1E1FFDFDFDFFFC45C0CFFE0AF8BFFF5F5F5FFF5F5
      F5FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2F2FFEEEEEEFFEEEEEEFFEEEEEEFFEAEA
      EAFFEAEAEAFFE5E5E4FFE5E5E4FFE5E5E4FF464949FF394749FF394749FF3947
      49FF394749FF393E3EFF2E3E3EFF2E3E3EFF2E3E3EFF2E3E3EFF2E3E3EFF2E3E
      3EFF2E3E3EFF2E3E3EFF2E3E3EFF2E3E3EFFFED9C7FFFF935AFFFE8446FFFE84
      46FFFE8446FFFE8446FFFE8446FFFB7839FFFB7839FFFB7839FFF7702CFFF469
      23FFF46923FFF06118FFEF5C12FFF06118FF0000F3FF0000F3FF0000F3FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000D3FF961700FF920A00FF920A
      00FF870000FF870000FF870000FF870000FF870000FF710000FF710000FF7100
      00FF710000FF710000FF710000FF710000FFF33700FFF33700FFF33700FFEF27
      00FFEF2700FFEB1700FFEB1700FFE70900FFE70900FFE70900FFE10000FFE100
      00FFE10000FFDD0000FFDD0000FFDD0000FFA40000FFA40000FF8C0000FF8C00
      00FF8C0000FF8C0000FF8C0000FF8C0000FF8C0000FF6F0000FF6F0000FF6F00
      00FF6F0000FF6F0000FF4F0B00FF000000FF0000F8FF6363FCFF5A5AFAFF5A5A
      FAFF5251F9FF5251F9FF4A4AF7FF4343F8FF4343F8FF3A3AF5FF3A3AF5FF3333
      F3FF3333F3FF2D2DF2FF2D2DF2FF0000DDFF0000F5FF6261EEFFD49E70FFD39A
      6AFFD29865FFD09463FFCE915EFFCD8E5AFFCA8A52FFCA8A52FFC8854BFFC583
      4AFFC58045FFC47C41FFC47C41FF5E0000FFF94800FFFBAE6FFFFAAC6BFFF9A9
      67FFCBC49DFFC7C29AFF79F2F9FFC4BE94FFC1BA8FFFF59A4EFFF4974AFFF594
      45FFF29040FFF29040FFF29040FFDD0000FFA40000FFD76464FFDC7777FFF6E3
      E3FFCF5353FFD04E4EFFCC4646FFCC4646FFD24242FFC73636FFC73636FFC736
      36FFC73636FF935326FF35B62BFF006D00FF0000F8FF6363FCFF4343F8FF3C3C
      FAFF3A3AF5FF3333F8FF2D2DF7FF2828F9FF2020F5FF2020F5FF1515F3FF1515
      F3FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF0000EDFF6767F9FF4444ECFFA8A9
      F8FFF9F7F6FFF8F5F4FFF6F4F2FFF5F3F2FFF2F2F1FFF2F2F1FFF0EEEEFFF0EE
      EEFFF0EEEEFFEFEDECFFF0EEEEFFDDDBDAFFF94800FFFCB174FFF99E53FFC4BE
      94FF6EEFF5FFD6A769FFF6913EFFD6A769FF5CE8F3FFB5AF7DFFF3852AFFF385
      2AFFF17E21FFF17E21FFF29040FFE10000FFA40000FFD76464FFCC4646FFD242
      42FFC73636FFC73636FFC62727FFC62727FFC62727FFB91B17FFB91B17FFB91B
      17FF497C0EFF0AB70AFF31C431FF006D00FF2828F9FFA0A0FCFF8A8AFBFF8A8A
      FBFF8282FAFF8282FAFF7B7BF8FF7777F5FF7272F6FF7272F6FF6B6BF4FF6B6B
      F4FF6464F2FF6464F2FF7777F5FF0000E0FF0000EDFF6767F9FF4A4AF5FF4444
      ECFFA8A9F8FFF9F9F9FFF9F9F9FFF9F7F6FFF6F6F6FFF6F6F6FFF3F3F3FFF3F3
      F3FFF2F2F1FFF2F2F1FFF3F3F3FFDDDBDAFFFBFBFBFFFDFDFDFFFBFBFBFFFBFB
      FBFFF9F9F9FFF9F9F9FFF9F9F9FFF7F7F7FFF7F7F7FFF4F4F4FFF4F4F4FFF4F4
      F4FFF2F2F2FFF2F2F2FFF4F4F4FFDFDFDFFFA40000FFD76464FFCC4646FFE7AD
      ADFFE7ADADFFC73636FFC73636FF878282FF7C8787FFC62727FF935326FF29AC
      18FF12BA12FF12BA12FF31C431FF006D00FFE8E8FDFFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFC7C7E3FF0000EDFF8686F8FFBEBEFBFF4A4A
      F5FF4444ECFF7253A7FFCD8E5AFFCA8A52FFC8854BFFC5834AFFC58045FFC47C
      41FFC17539FFC17539FFCA8A52FF710000FF0000DEFF7A7AF7FF6999F8FF75EE
      FBFF5151F3FF5151F3FF4747F1FF4747F1FF4D85F1FF5CE8F3FF437DEFFF2C2C
      EAFF2C2CEAFF2C2CEAFF4545EBFF0000DEFFB20000FFF6E3E3FFD04E4EFFD55A
      5AFFD04E4EFFD24242FF4DDED3FF34F8EAFF2EF3D6FF2DEACBFF26C226FF1BDC
      8DFF1BDC8DFF12BA12FF31C431FF006D00FFE8E8FDFFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFCBCBE6FF0000EDFFC7C8FDFFF9F9FCFFB8B8
      FBFF4A4AF5FF4444ECFF7253A7FFC17539FFBB6B32FFBB6B32FFB56227FFB562
      27FFB1591CFFB1591CFFBA6F3AFF5E0000FFFDFDFDFFFDFDFDFFFDFDFDFFE0FB
      FCFFFDFDFDFFFBFBFBFFF9F9F9FFF9F9F9FFF9F9F9FFF7F7F7FFF7F7F7FFF4F4
      F4FFF4F4F4FFF4F4F4FFF4F4F4FFE5E5E5FFB20000FFDF8484FFD25252FFD252
      52FFF6E3E3FFD24242FF41F9ECFF3AE17DFF35CA3DFF30EEC5FF26C226FF26C2
      26FF1BDC8DFF1BDC8DFF3AC63AFF006D00FFE8E8FDFFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFCBCBE6FF0000F5FF8686F8FFBEBEFBFF5959
      F5FF4F4EEFFF7253A7FFD09463FFD0925DFFCD8E5AFFCA8A52FFCA8A52FFC885
      4BFFC58045FFC47C41FFCD8E5AFF870000FFFD5800FFFEBA83FFFEAB67FFCBC7
      A1FF79F2F9FFDDB37BFFFAA158FFDDB37BFF6EEFF5FFC1BA8FFFF79443FFF691
      3EFFF58C37FFF58C37FFF59A4EFFE70900FFB20000FFDC7777FFF6E3E3FFD764
      64FFD04E4EFFD04E4EFF47EECFFF3EE4A0FF3EE4A0FF30EEC5FF31C431FF26C2
      26FF26C226FF22EBC1FF3EE4A0FF006D00FFAD3838FFDAA4A4FFD2908FFFD290
      8FFFCF8A8AFFCF8A8AFFCB8383FFCB8383FFC87D7DFFC97979FFC57272FFC572
      72FFC16B6BFFC16B6BFFC87D7DFF770000FF0000F5FF7A7AF8FF5959F5FF5959
      F5FFB8B8FBFFFCFCFCFFFCFCFCFFFCFCFCFFF9F9F9FFF9F9F9FFF9F9F9FFF9F7
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFE7E6E4FFFF6000FFFEBA83FFFEAD6AFFFEAB
      67FFCBC49DFFCBC49DFF79F2F9FFC7C29AFFC4BE94FFF99B4EFFF89849FFF794
      43FFF6913EFFF58C37FFF99E53FFE70900FFB20000FFDC7777FFD55A5AFFD55A
      5AFFC06653FF6AB750FF4BD04BFF44CD44FF44CD44FF3CCA3CFF36C836FF30EE
      C5FF30EEC5FF22EBC1FF47EECFFF00D37CFF870000FFC97979FFBD5F5FFFBB5B
      5BFFB95758FFB65252FFB65252FFB14B4BFFAF4444FFAF4444FFAD3838FFA633
      33FFA63333FFA12B2BFFB14B4BFF470000FF0000F5FF7A7AF8FF6261EEFFBEBE
      FBFFFDFBF9FFFDFBF9FFFBF8F7FFFBF8F7FFF9F7F6FFF9F7F6FFF8F5F4FFF8F5
      F4FFF6F4F2FFF5F3F2FFF6F4F2FFE7E6E4FFFF6000FFFFBD87FFFEAF6DFFFEAD
      6AFFFEAB67FFFDA964FFF9A560FFFAA158FFFAA158FFF99E53FFF99B4EFFF898
      49FFF79443FFF6913EFFFAA158FFEB1700FFB20000FFDC7777FFD55A5AFFA191
      5BFF5AD259FF52D252FF52D252FF4BD04BFF44CD44FF44CD44FF3CCA3CFF36C8
      36FF31C431FF2BE095FF4BCD4BFF008800FF870000FFC97979FFC97979FFC979
      79FFC97979FFC57272FFC57272FFC16B6BFFC16B6BFFC06464FFBD5F5FFFBB5B
      5BFFB95758FFB65252FFB14B4BFF470000FF0000F5FF7A7AF8FFCDA597FFDFAF
      87FFDFAF87FFDDAB82FFDDAB82FFD9A579FFD9A579FFD9A579FFD49E70FFD49E
      70FFD39A6AFFD29865FFCF9460FF870000FFFF6000FFFFBD87FFFFBD87FFFFBD
      87FFFEBA83FFFEBA83FFFEB67BFFFEB67BFFFCB174FFFCB174FFFBAE6FFFFAAC
      6BFFF9A967FFF9A560FFF9A560FFEB1700FFB20000FFD3857AFF97C37AFF74DC
      74FF74DC74FF74DC74FF74DC74FF66D766FF66D766FF66D766FF5AD259FF5AD2
      59FF5AD259FF52E7A9FF4BCD4BFF008800FF870000FF870000FF870000FF8700
      00FF870000FF870000FF870000FF770000FF770000FF770000FF770000FF6300
      00FF630000FF630000FF630000FF630000FF0000D3FFA83E00FFB34600FFA83E
      00FFA83E00FFA33300FFA33300FFA33300FF9C2500FF9C2500FF961700FF9617
      00FF8F1000FF920A00FF870000FF920A00FFFF6000FFFF6000FFFF6000FFFF60
      00FFFF6000FFFD5800FFFD5800FFFD5800FFF94800FFF94800FFF94800FFF337
      00FFF33700FFF33700FFEF2700FFEF2700FF4F0B00FF00A900FF00A900FF00A9
      00FF00A900FF00A900FF00A900FF00A900FF00A900FF00A900FF009900FF0099
      00FF009900FF009900FF008800FF008800FF007900FF006A00FF005F00FF005F
      00FF005F00FF0000C9FF0000E6FF0000E6FF0000E6FF0000E6FF0000E6FF00E0
      E0FF00E0E0FF00DDDDFF00DDDDFF00DDDDFF0000C7FF0000C2FF0000C2FF0000
      B9FF0000B9FF0000B9FF0000B9FF0000ABFF0000ABFF0000ABFF0000ABFF0000
      A1FF0000A1FF00009EFF00009EFF0000A1FF0000D7FF0000D7FF0000D7FF0000
      D7FF0000D7FF0000D7FF0000C6FF0000C6FF0000C6FF0000C6FF0000C6FF0000
      B9FF0000B9FF0000B9FF0000B9FF0000B9FF640000FF640000FF520000FF5200
      00FF520000FF520000FF520000FF520000FF2D0000FF2D0000FF2D0000FF2D00
      00FF2D0000FF2D0000FF2D0000FF2D0000FF006A00FF60BF5FFF5BBD5BFF57BA
      57FF52BB52FF4F59EBFF4A4AF7FF4343F7FF4343F7FF373AF8FF3747F6FF34F3
      F3FF31F3F3FF2DF2F2FF2DF2F2FF00DDDDFF0000C7FF6060E6FF5C5CE4FF5757
      E3FF5353E3FF4F4FE1FF4949DFFF4444DDFF3F3FDEFF3C3CDBFF3939DAFF3535
      D8FF3131D8FF2D2DD6FF2D2DD6FF00009EFF0000D7FF6765EFFF5959EEFF5959
      EEFF5959EEFF4E4EECFF4E4EECFF4947E9FF4241E7FF4241E7FF3D3AE6FF3532
      E3FF3532E3FF3532E3FF2E2CE2FF0000B9FF770000FFCC9C84FFCC9C84FFCA97
      7EFFC8947AFFC69176FFC38E73FFC0896DFFC0896DFFBC8366FFBC8366FFB77B
      5DFFB77B5DFFB77B5DFFB77B5DFF2D0000FF007900FF67C267FF44B344FF3CB0
      3CFF3CB03CFF3641E7FF2B2BF6FF2B2BF6FF2121F5FF2121F5FF1B2DF4FF12F2
      F2FF0CF1F1FF0CF1F1FF2DF2F2FF00E0E0FF0000CDFF6565E8FF4444E1FF3E3E
      E0FF3939DEFF3435DDFF2E2EDBFF2A2ADAFF2424D8FF1E1ED6FF1818D5FF1212
      D3FF0C0CD1FF0C0CD1FF2D2DD6FF0000A1FF0000D7FF6765EFFF4947E9FF4241
      E7FF3D3AE6FF3532E3FF3532E3FF2E2CE2FF2723DFFF2723DFFF1F1ADDFF1913
      DBFF1913DBFF120DD8FF3532E3FF0000B9FFF9F9F8FFFDFDFBFFF9F9F8FFF9F9
      F8FFF9F9F8FFF9F9F8FFF6F6F5FFF6F6F5FFF6F6F5FFF4F4F3FFF2F2F1FFF2F2
      F1FFF2F2F1FFF2F2F1FFF2F2F1FFDFDFDDFF007900FF67C267FF48B548FF44B3
      44FF3EB33FFF3641E7FF373AF8FF2B2BF6FF2B2BF6FF2121F5FF1B2DF4FF1BF3
      F3FF12F2F2FF12F2F2FF31F3F3FF00E0E0FF0000CDFF6969E8FF4849E3FF4444
      E1FF3E3EE0FF3939DEFF3435DDFF2E2EDBFF2A2ADAFF2424D8FF1E1ED6FF1818
      D5FF1212D3FF0C0CD1FF3131D8FF0000A1FFC70000FFE7956FFFDE7647FFDD72
      42FFDB6E3EFFDA6938FFD86532FFD7602CFFD7602CFFD45923FFD45923FFD050
      17FFD05017FFD05017FFD56332FF9E0000FF8587F1FFC8C8FAFFBBBCF6FFB8B9
      F5FFB6B7F5FFB3B4F3FFB1B2F3FFADAEF1FFABACEEFFABACEEFFA4A4EDFFA4A4
      EDFFA4A4EDFF9FA0EBFFABACEEFF3E40D3FF007900FF70C570FF4DB84DFF48B5
      48FF44B344FF424CE9FF373AF8FF38C5F9FF2EC3F7FF2B2BF6FF2737F6FF1BF3
      F3FF1BF3F3FF12F2F2FF35F4F4FF00E6E6FF0000CDFF6D6EE9FF4E4EE4FF4849
      E3FF4444E1FF3F3FDEFF3939DEFF3435DDFF2E2EDBFF2A2ADAFF2424D8FF1E1E
      D6FF1818D5FF1212D3FF3535D8FF0000A1FFC70C00FFE7956FFFE07E51FFDF7A
      4CFFDE7647FFDD7242FFDB6E3EFFDA6938FFD86532FFD7602CFFD45923FFD459
      23FFD05017FFD05017FFDA6938FF9E0000FF0000DEFF7271F0FF4E4EEBFF4949
      EAFF4545E9FF3F3FE7FF3A3AE6FF3232E4FF2A2AE3FF2A2AE3FF2424E1FF1E1E
      E0FF1717DDFF1717DDFF3232E4FF0000B9FF008600FF70C570FF52BB52FF4DB8
      4DFF4DB84DFF424CE9FF37B9F9FF38DEF9FF38DEF9FF37B9F9FF2737F6FF23F5
      F5FF1BF3F3FF1BF3F3FF3CF5F5FF00E6E6FF0000D3FF7271EAFF5353E3FF4E4E
      E4FF4A51E4FF4793EDFF3F3FDEFF3939DEFF3435DDFF2E2EDBFF2A2ADAFF2424
      D8FF1E1ED6FF1818D5FF3939DAFF0000ABFFC70C00FFE7956FFFE18255FFE07E
      51FFDF7A4CFFDE7647FFDD7242FFDB6E3EFFDA6938FFD86532FFD7602CFFD459
      23FFD45923FFD05017FFD66B3BFF9E0000FF0000DEFF7271F0FF5454EDFF4E4E
      EBFF4949EAFF4545E9FF3F3FE7FF3A3AE6FF3232E4FF3232E4FF2A2AE3FF2424
      E1FF1E1EE0FF1717DDFF3A3AE6FF0000B9FF008600FF76CA76FF58BD57FF52BB
      52FF52BB52FF4F59EBFF414BFAFF40C7FAFF38C5F9FF373AF8FF373AF8FF2AF6
      F6FF23F5F5FF1BF3F3FF3CF5F5FF00E6E6FF0000D3FF7578ECFF5557E6FF5557
      E6FF4F89EDFF4ACCF5FF4793EDFF4141E0FF3B3BDEFF3435DDFF2E2EDBFF2A2A
      DAFF2424D8FF1F1FD7FF3F3FDEFF0000ABFF00B0EBFF78E4FEFF58DDFEFF53DD
      FDFF4FDCFDFF4AD9FCFF46D8FBFF41D6FAFF3BD4F9FF35D3F8FF30D1F7FF2AD0
      F6FF23CDF5FF23CDF5FF41D3F6FF007ECFFF0000E1FF7271F0FF5454EDFF5454
      EDFF4E4EEBFF4949EAFF4545E9FF3F3FE7FF3A3AE6FF3232E4FF3232E4FF2A2A
      E3FF2424E1FF1E1EE0FF3F3FE7FF0000B9FF008600FF79C979FF5BBD5BFF58BD
      57FF52BB52FF4F59EBFF4B4BFCFF4443FBFF4443FBFF373AF8FF3747F6FF30F7
      F7FF2AF6F6FF23F5F5FF48F7F7FF00E6E6FF0000D3FF7887EEFF5BE4FBFF5898
      EFFF5353E3FF50A8F1FF4ACCF5FF467EEAFF4141E0FF3B3BDEFF3435DDFF3030
      DCFF2A2ADAFF2424D8FF4444DDFF0000ABFF00B5EDFF78E4FEFF5CDEFEFF58DD
      FEFF53DBFDFF50DAFDFF4AD9FCFF46D8FBFF41D6FAFF3BD4F9FF35D3F8FF30D1
      F7FF2BCEF6FF23CDF5FF41D3F6FF0081CFFFA1A1F9FFD4D4FCFFCACAFBFFC8C8
      FAFFC8C8FAFFC4C5F9FFC4C5F9FFC1C2F7FFBEBEF6FFBEBEF6FFBBBCF6FFB8B9
      F5FFB5B6F3FFB3B4F3FFBEBEF3FF6668DFFF008900FF79C979FF60BF5FFF5BBD
      5BFF58BD57FF4F59EBFF5050FDFF4B4BFCFF4443FBFF4443FBFF414BFAFF36F8
      F8FF30F7F7FF2BF6F6FF48F7F7FF00E6E6FF0000D3FF77DCFAFF5EF3FDFF5BE4
      FBFF585BE7FF539BF0FF50CFF6FF4793EDFF4444E1FF4141E0FF3B3BDEFF3435
      DDFF3030DCFF2A2ADAFF4949DFFF0000B9FF00B5EDFF78E4FEFF5CDEFEFF5CDE
      FEFF58DDFEFF53DBFDFF50DAFDFF4AD9FCFF46D8FBFF41D6FAFF3BD4F9FF35D3
      F8FF30D1F7FF2BCEF6FF4BD6F7FF0089D4FFFFFFF9FFFEFEFCFFFEFEFCFFFEFE
      FCFFFEFEFBFFFDFDFBFFFDFDFBFFFCFCF9FFFCFCF9FFF9F9F8FFF9F9F6FFF9F9
      F6FFF6F6F5FFF6F6F5FFF6F6F5FFE9E9E5FF008600FF79C979FF79C979FF79C9
      79FF76CA76FF7275F7FF7275F7FF6669FCFF6669FCFF6669FCFF6669FCFF56F9
      F9FF56F9F9FF56F9F9FF48F7F7FF00EDECFF0000D5FF7A7EEDFF77DCFAFF7887
      EEFF76A5F2FF77DCFAFF70BFF5FF6D6EE9FF6969E8FF6565E8FF6060E6FF5C5C
      E4FF5757E3FF5353E3FF4D4DE1FF0000B9FF00B5EDFF78E4FEFF78E4FEFF78E4
      FEFF78E4FEFF72E2FEFF72E2FEFF6AE0FDFF6AE0FDFF62DDFCFF62DDFCFF5BDB
      FAFF56D9F9FF52D8F8FF4BD6F7FF0089D4FF860B00FFD4A893FFD4A893FFD4A8
      93FFD4A893FFD1A38DFFD1A38DFFCEA089FFCC9C84FFCC9C84FFCA977EFFC894
      7AFFC69176FFC38E73FFC0896DFF520000FF008900FF008900FF008900FF0089
      00FF008900FF0000E6FF0000FBFF0000FBFF0000FBFF0000FBFF0000FBFF00F3
      F3FF00F3F3FF00F3F3FF00EDECFF00EDECFF0000D5FF0000D5FF0000D3FF0000
      D5FF0000D5FF0044E5FF0000CDFF0000CDFF0000CDFF0000CDFF0000C7FF0000
      C7FF0000C2FF0000C2FF0000B9FF0000B9FF00B5EDFF00B5EDFF00B5EDFF00B5
      EDFF00B5EDFF00B0EBFF00B0EBFF00AAE7FF00AAE7FF00AAE7FF009FE1FF009F
      E1FF009FE1FF0094DBFF0094DBFF0094DBFF860B00FF860B00FF860B00FF860B
      00FF860B00FF770000FF770000FF770000FF770000FF770000FF640000FF6400
      00FF640000FF640000FF520000FF520000FF0000F5FF0000F3FF0000F1FF0000
      EFFF0000EDFF0000EDFF0000EBFF0000E9FF0000E7FF0000E5FF0000E3FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FF0071F6FF0064F2FF0064F2FF0056
      EEFF0056EEFFDDDDDDFFD8D8D8FFD8D8D8FFD8D8D8FFD2D2D2FFD2D2D2FF008B
      00FF008700FF008700FF008200FF008B00FF2C0000FF2C0000FF2C0000FF1400
      00FF140000FF140000FF140000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000F4FF0000F4FF0000F4FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E4FF0000E4FF0000E4FF0000
      DFFF0000DFFF0000DDFF0000DDFF0000DDFF0000F7FF6160FBFF5C5CFAFF5757
      F9FF5857F9FF5756F8FF4F4FF7FF4545F7FF4141F6FF3C3CF5FF0000E5FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0071F6FF61BEFBFF5CBCFAFF57B9
      F9FF50B6FCFFF8F8F8FFF7F7F7FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FF35CD
      35FF31CD31FF2DCA2DFF2DCA2DFF008200FF430000FFA9816FFFA77C6AFFA479
      67FFA27562FF9E705FFF9C6D5AFF9A6954FF966450FF93604BFF93604BFF905C
      46FF8D5842FF8B5640FF89533DFF000000FF0000F4FF6363FCFF5A5AFAFF5A5A
      FAFF5050FAFF5050FAFF4949FAFF4343F7FF4343F7FF3A3AF5FF3A3AF5FF3535
      F4FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF0000F9FF6565FCFF4343FAFF3E3E
      FAFFF9F9F9FFF8F8F8FFF7F7F7FF2828F6FF2222F5FF4141F6FF0000E7FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0076F9FF65C0FCFF44B1FBFF3CAC
      FAFF3CACFAFFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF4F4F4FF12C5
      12FF0CC30CFF0CC30CFF2DCA2DFF008700FF430000FFAC8573FF9A6954FF9664
      50FF93604BFF905C46FF8B5640FF89533DFF864F37FF834A32FF7C432BFF7C43
      2BFFF2F2F2FF773B22FF8B5640FF000000FF0000FBFF6363FCFF4444FBFF3E3E
      FAFF3939F9FF3333F8FF2E2EF7FF2929F6FF2323F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000DFFF0000FBFF6969FCFF4848FBFF4444
      FBFFFAFAFAFFF9F9F9FFF8F8F8FF2E2EF7FF2929F6FF4646F7FF0000E9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF007CFCFF6CC4FDFF48B4FBFF44B1
      FBFF3CACFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FF18C8
      18FF12C512FF12C512FF31CD31FF008700FF430000FFB08B7AFF9C6D5AFF9A69
      54FF966450FF93604BFF905C46FF8B5640FF89533DFF864F37FFF6F6F6FF7C43
      2BFF7C432BFF773B22FFF2F2F2FF000000FF0000FBFF6C6CFDFF4949FAFF4444
      FBFF3E3EFAFF3939F9FF3333F8FF2E2EF7FF2929F6FF2323F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3131F3FF0000DFFF0000FDFF7171FDFFFCFCFCFFFBFC
      FBFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FF4F4FF7FF0000EBFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF007CFCFF6CC4FDFF50B6FCFF48B4
      FBFF44B1FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FF1ECA
      1EFF18C818FF12C512FF35CD35FF008B00FF430000FFB08B7AFFA0715EFF9C6D
      5AFF9A6954FF966450FF93604BFF905C46FF8D5842FF89533DFF864F37FF834A
      32FF7C432BFF7C432BFF905C46FF000000FF0000FBFF6C6CFDFF5050FAFF4949
      FAFF4444FBFF3F3FFAFF3939F9FF3333F8FF2E2EF7FF2929F6FF2323F5FF1E1E
      F4FF1818F3FF1212F2FF3535F4FF0000E4FF0000FDFF7979FEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FF5A5AF8FF0000EDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0083FDFF72C6FEFF53B8FDFF50B6
      FCFF4AB3FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FF24CB
      24FF1ECA1EFF18C818FF3CD13CFF008B00FF5A1D57FFB58D8BFFA27562FF976A
      83FF976A83FF9A6954FFA77C6AFF9B758FFF7E503DFFF6F6F6FF89533DFF864F
      37FF834A32FF7C432BFF93604BFFC3C3C3FFAF3E00FFDCAB77FFD4985AFFD294
      53FFD29453FFDBA05AFFF2F2F9FFF2F2F9FFF2F2F9FFF0F0F7FFF0F0F7FFEDED
      F4FFEDEDF4FFEBEBF3FFEDEDF4FFD3D3E5FF0000FDFF7878FEFFFEFEFEFFFDFD
      FDFFFDFCFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FF5A5AF9FF0000EFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0087FFFF76C8FEFF57BCFEFF53B8
      FDFF50B6FCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FF2ACE
      2AFF24CB24FF1ECA1EFF3CD13CFF009900FF97606AFFC8BDDAFFB58D8BFF9888
      C6FF9888C6FFC7A093FFB3A9D7FFA37C94FF835543FF905C46FF8D5842FF8953
      3DFF864F37FF834A32FF966450FF000000FFC55B00FFEBB975FFE4A553FFE4A5
      53FFE4A553FFDDA765FFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF5F5F5FFF5F5F5FFE7E7E7FF0000FFFF7878FEFF5B5BFEFF5858
      FEFFFDFDFDFFFDFDFDFFFCFCFCFF4646FBFF4140FAFF5A5AFAFF0000F1FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0087FFFF76C8FEFF5CBEFEFF58BB
      FEFF53B8FDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FF31CD
      31FF2ACE2AFF25CD25FF43D343FF009900FF47238BFFBFB9E6FFAAABF0FF8685
      E4FF8685E4FFAAABF0FF9790D9FF957AAFFF885B49FF93604BFFF8F8F8FF8D58
      42FF89533DFF864F37FFF6F6F6FF000000FFC55B00FFE6BC85FFF6E9D7FFE7C3
      91FFDA9A53FFDDA765FFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFE7E7E7FF0000FFFF797AFFFF5E5EFEFF5B5B
      FEFFFEFEFEFFFDFDFDFFFDFDFDFF4B4BFCFF4646FBFF5F5FFBFF0000F3FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0089FFFF79C9FFFF5CBEFEFF5CBE
      FEFF58BBFEFFFDFDFDFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FF33D1
      33FF33D133FF2ACE2AFF4BD64BFF009900FF181AD3FF9695E8FF8685E4FF7677
      E6FF6A6BE3FF7677E6FF7677E6FF726ED8FF8B604EFF9A6954FF966450FF9360
      4BFFF6F6F6FF89533DFF9C6D5AFF000000FFC55B00FFF8EDDFFFF7EAD9FFF7EA
      D9FFDBA05AFFDDA765FFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFEAEAEAFF0000FFFF7A7AFFFF7A7AFFFF7878
      FEFF7979FEFF7979FEFF7474FDFF6C6CFDFF6868FCFF6464FCFF0000F5FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E6FF0087FFFF79C9FFFF79C9FFFF76C8
      FEFF76C8FEFFFEFEFEFFFDFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFF59DA
      59FF59DA59FF52D852FF4BD64BFF009900FF813636FFCAC3E6FFDED3DDFFB3A9
      D7FFB3A9D7FFC8BDDAFFD4CEE8FFCAACA4FFA17E6FFFAC8573FFA9816FFFA77C
      6AFFA47967FFA27562FF9E705FFF140000FFC55B00FFE5B67AFFF7EAD9FFE5B6
      7AFFE2B176FFE6BC85FFFEFDFDFFFDFDFDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFEAEAEAFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FBFF0000F9FF0000F7FFE6E6
      E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FF0091FFFF0089FFFF0089FFFF0087
      FFFF0083FDFFEFEEEEFFEFEEEEFFEFEEEEFFEFEEEEFFEAEAEAFFEAEAEAFF00B0
      00FF00B000FF00A900FF00A900FF00A900FF7A66BBFF8F566EFF762800FF4723
      8BFF47238BFF6A1800FF5A1D57FF6C52A5FF2C0000FF430000FF2C0000FF2C00
      00FF2C0000FF2C0000FF140000FF140000FFC55B00FFC55B00FFC55B00FFC55B
      00FFC55B00FFC55B00FFFDFDFDFFFDFDFDFFFBFBFBFFF9F9F9FFF7F7F7FFF5F5
      F5FFF2F2F2FFF2F2F2FFEFEFEEFFEFEFEEFF002C00FF002C00FF002C00FF002C
      00FF001500FF001500FF001500FF001500FF000000FF000000FF000000FF0000
      00FF001500FF000000FF000000FF000000FF2B3500FF00B5F3FF162200FF4B00
      00FF4B0000FF4B0000FF4B0000FF320000FF320000FF320000FF320000FF2000
      00FF200000FF200000FF200000FF200000FF00C3C3FF00C3C3FF00CECEFF00D4
      D4FF00E2DFFF00DEDEFF00DEDEFF0000D9FF0000D9FF00D4D4FF00D4D4FF00D4
      D4FF00CECEFF00CCCCFF00CCCCFF00CCCCFF00D54CFF08CBF3FF00C9F1FF00C4
      EEFF00C4EEFF00BFEDFF0000EAFF0000EAFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF004300FF7DAB5FFF7DAB5FFF73A3
      56FF73A356FF6EA14EFF6B9D49FF679D45FF649741FF60983CFF5C9538FF55A5
      6CFF3EC4D2FF4EA062FF518C2BFF000000FF650200FFA3A78AFFBD8E5BFFB98B
      57FFB78853FFB6854EFFB18049FFB17C44FFAF7940FFAE773DFFAB7438FFA970
      33FFA76E30FFA46A2BFFA46A2BFF200000FF00C3C3FF5FFBFBFF5FFBFBFF56F9
      F9FF56F9F9FF4DF8F8FF4DF8F8FF4444FAFF4444FAFF38F4F4FF38F4F4FF38F4
      F4FF2EF2F2FF2EF2F2FF2EF2F2FF00CCCCFF00B500FF61EBACFF5CFAFAFF56F9
      F9FF56F9F9FF51F8F8FF4ACBF7FF4552F7FF4141F6FF3D3DF5FF3939F4FF3333
      F3FF3333F3FF2D2DF2FF2D2DF2FF0000DDFF004300FF83AE65FF679D45FF6098
      3CFF5C9538FF599234FF54933CFF548F33FF518C2BFF45841BFF45841BFF3B7C
      10FF399654FF3B7C10FF518C2BFF000000FF2B3500FF6AE4FDFF979C7AFFAE77
      3DFFAB7438FFA97033FFA46A2BFFA46A2BFFA26524FF9F611EFF9C5D18FF9959
      13FF97550FFF95520AFFA46A2BFF200000FF00BC73FF65EACEFF43E5C3FF3CE3
      C0FF3CE3C0FF30E2BBFF30E2BBFF2929F6FF2929F6FF1BDBB2FF1BDBB2FF12D7
      AEFF0CD6ABFF0CD6ABFF2EDAB6FF008F3EFF00B500FF65DD65FF43E89EFF3EFA
      FAFF39F9F9FF33F8F8FF2DF7F7FF28BDF6FF2429F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF004300FF87B16AFF68A04BFF679D
      45FF649A40FF5B9743FF5B9743FF3DCCE6FF3EC4D2FF4C8A24FF45841BFF4584
      1BFF3B7C10FF3B7C10FF548F33FF000000FF720F00FFA9AE94FFB48248FFB17C
      44FFAF7940FFAB7438FFA97033FF789579FF957744FF7A8763FF9F611EFF9C5D
      18FF995913FF97550FFFA76E30FF200000FF036103FF6CC86CFF4ABA4AFF44B7
      44FF3CB33CFF3CB33CFF33A733FF2929F6FF2929F6FF259C25FF179617FF1796
      17FF179617FF179617FF33A733FF001F00FF00BC00FF69E069FF49D749FF44EB
      A8FF3EFAFAFF39F9F9FF33F8F8FF2FF7F7FF29B3F6FF2429F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3333F3FF0000E0FF005200FF8DB470FF6EA14EFF6B9D
      49FF68A04BFF629C4CFF49CDE1FF47C4CAFF54933CFF518C2BFF4C8A24FF4584
      1BFF45841BFF26BED1FF599234FF000000FF3E480AFF6AE4FDFF979C7AFFB482
      48FFB17C44FFAF7940FFAB7438FF44C9DDFF2ED6F7FF5FA59BFFA26524FF9F61
      1EFF9C5D18FF995913FFA97033FF320000FF036103FF6CC86CFF4ABA4AFF4ABA
      4AFF44B744FF3CB33CFF3CB33CFF3837F9FF2929F6FF259C25FF259C25FF1796
      17FF179617FF179617FF33A733FF001F00FF00BC00FF70E26FFF4FD94FFF49D7
      49FF44EBA8FF40FAFAFF39F9F9FF35F8F8FF2FF7F7FF29B3F6FF2429F5FF1E1E
      F4FF1818F3FF1212F2FF3333F3FF0000E5FF005200FF8DB470FF70AD6BFF73A3
      56FF6CA256FF6B9F53FF4ED2ECFF5D9D4BFF5B9743FF519B4BFF3DC0C2FF4C8A
      24FF45841BFF45841BFF55A56CFF000000FF791A00FFAEB399FFBA8953FFB685
      4EFFB6824AFFB17C44FF85A088FF38D9F9FF38D9F9FF40CFE7FF957744FFA265
      24FF9F621FFF9C5D18FFAB7438FF320000FF49A749FFB9E2B9FFA3D9A3FFA3D9
      A3FFA3D9A3FFA3D9A3FFA3D9A3FF3837F9FF3837F9FF93D292FF93D292FF8BCA
      8BFF8BCA8BFF8BCA8BFF98CF98FF036103FF00BC00FF70E26FFF53DB53FF4FD9
      4FFF49D749FF45EDB3FF40FAFAFF39F9F9FF35F8F8FF2FF7F7FF2AADF6FF2429
      F5FF1E1EF4FF1818F3FF3939F4FF0000E5FF184E00FF8CCDB0FF57DDFEFF55ED
      FDFF6FAE63FF6CA256FF52D0E3FF51C9CFFF60983CFF4CBAA8FF40C9DAFF4BAD
      90FF4C8A24FF399654FF4ECADAFF002C00FF4A531BFF77E8FFFFA3A78AFFBA89
      53FFB68650FFB6824AFFB18049FF8A9C80FF40CFE7FF968458FFA76E30FFA46A
      2BFFA26524FF9F621FFFAE773DFF320000FFE7E4E4FFFDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFBFBFF4444FAFF3837F9FFF8F8F8FFF8F8F8FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFBEBEBEFF00C300FF75E375FF58DC57FF53DB
      53FF4FD94FFF4AD84CFF45EDB3FF40FAFAFF3BF9F9FF35F8F8FF2FF7F7FF2AAD
      F6FF2429F5FF1E1EF4FF3D3DF5FF0000E5FF165C00FF7DF4FFFF6EC2B3FF6EC2
      B3FF55EDFDFF73A356FF6B9D49FF54D4EAFF52D0E3FF60983CFF4BAD90FF548F
      33FF518C2BFF4C8A24FF5EAD7BFF000000FF7E2500FFB3B69EFFBD8E5BFFBC8C
      58FFBA8953FFB68650FFB6824AFFB48046FF9E8B5FFFAE773DFFAB7438FFA76E
      30FFA46A2BFFA26524FFB17C44FF320000FFE7E4E4FFFDFDFDFFFDFBFBFFFDFB
      FBFFFDFDFDFFFDFDFDFFFDFDFDFF4444FAFF4444FAFFF8F8F8FFF8F8F8FFF8F8
      F8FFF5F5F5FFF5F5F5FFF5F5F5FFBEBEBEFF00C300FF79E479FF5CDE5CFF58DC
      57FF53DB53FF4FD94FFF4AD84CFF45EDB3FF40FAFAFF3BF9F9FF35F8F8FF2FF7
      F7FF2BA3F6FF2429F5FF4141F6FF0000E5FF025C00FF83E6F9FF83A25EFF72B6
      83FF55EDFDFF73A356FF73A356FF6B9F53FF679D45FF649A40FF60983CFF5C95
      38FF4EA062FF518C2BFF6B9D49FF001500FF4A531BFF77E8FFFFA3A78AFFBD8E
      5BFFBC8C58FFBA8953FFB68650FFB6824AFFB48046FFB17C44FFAE773DFFAB74
      38FFA76E30FFA46A2BFFB18049FF4B0000FFE83C09FFFAB498FF7DEDEDFFF8A1
      80FFF8A180FFF69D79FFF69D79FF4444FAFF4444FAFFF4906EFFF4906EFFF388
      63FFF38863FFF1825CFFF4906EFFD20C00FF00C300FF79E479FF5CDE5CFF5CDE
      5CFF58DC57FF53DB53FF4FD94FFF4BD84FFF46F0BFFF40FAFAFF3BF9F9FF35F8
      F8FF2FF7F7FF2BA3F6FF4646F7FF0000EAFF025C00FF8CCDB0FF7DF4FFFF83E6
      F9FF91B576FF8DB470FF8DB470FF87B16AFF87B16AFF83AE65FF7DAB5FFF72B6
      83FF64D3E2FF72B683FF6EA14EFF001500FF812600FFB3B8A0FFC9A379FFC9A3
      79FFC9A379FFC69E71FFC69E71FFC29768FFC29768FFC29768FFBE9160FFBB8E
      5BFFB98B57FFB68650FFB6854EFF4B0000FFE83C09FF94E9E9FF7EFFFFFF94E9
      E9FFFAB498FFFAB498FFFAAC93FF6A6AFDFF6A6AFDFFF7A686FFF7A686FFF7A6
      86FFF8A180FFF69D79FFF69D79FFD20C00FF00C300FF79E479FF79E479FF79E4
      79FF75E375FF75E375FF70E26FFF6ADF6DFF6ADF6DFF64F2CAFF5FFBFBFF5CFA
      FAFF56F9F9FF51F8F8FF4DAEF7FF0000EAFF025C00FF025C00FF025C00FF025C
      00FF025C00FF005200FF005200FF005200FF004300FF004300FF004300FF002C
      00FF005200FF002C00FF002C00FF001500FF4A531BFF00CBFFFF4A531BFF8126
      00FF7E2500FF791A00FF791A00FF720F00FF720F00FF650200FF650200FF6502
      00FF650200FF650200FF4B0000FF4B0000FFE02F05FFE83C09FF01BBBBFFE83C
      09FFE83C09FFE83C09FFE02F05FF0000F2FF0000F2FFDE2200FFDE2200FFDE22
      00FFDE2200FFDE2200FFD20C00FFD20C00FF00C300FF00C300FF00C300FF00C3
      00FF00C300FF00C300FF00BC00FF00BC00FF00BC00FF00B500FF16D1F7FF10CD
      F5FF08CBF3FF00C9F1FF00C4EEFF0048EDFFF7B700FFF2AE00FFF2AE00FFEFA9
      00FFEDA300FFEDA300FFEA9D00FFEA9D00FFE69300FFE69300FFE28E00FFE28E
      00FFDE8700FFDE8700FFDE8700FFDE8700FFE9E7F5FF0000E9FFCBE3CBFF0056
      00FF005600FF005600FF004600FF004600FF004600FF003800FF003800FF0038
      00FF002C00FF002C00FF002C00FF002C00FF0000E9FF0000E9FF0000E9FF0000
      E9FF0000E9FF0000E9FF0000CEFF0000CEFF0000CEFF0000CEFF0000CEFF0000
      CEFF0000CEFF0000CEFF0000CEFF0000CEFF0000D9FF0000D9FF0000D9FF0000
      C9FFD4D4D4FFCBCBCBFFCBCBCBFFCBCBCBFFC4C4C4FFC4C4C4FFC4C4C4FFBFBF
      BFFF0000A6FF0000A6FF0000A6FF0000A6FFF6B300FFFCDE83FFFADC7DFFF9DA
      79FFF9D975FFF8D872FFF7D56BFFF7D56BFFF6D264FFF6D264FFF4CF5FFFF3CE
      5BFFF3CE5BFFF2CB55FFF2CB55FFDE8700FF0000F5FFF2F4F7FF656FE9FF53BC
      53FF53BC53FF53BC53FF45B447FF45B447FF45B447FF3BB23BFF3BB23BFF33AC
      33FF33AC33FF2CAA2CFF2CAA2CFF002C00FFD00000FFEE8F6BFFEE8F6BFFED88
      64FFEC845FFFF58854FFE58165FFD98F73FFD98F73FFDF765DFFEA7544FFDB62
      41FFDB6241FFDB6241FFD95D3BFFAC0000FF0000D9FF8984F2FF817CEEFF6B68
      E9FFF5F5F5FFF4F4F4FFF2F2F2FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEBEB
      EBFF3936DCFF4843DBFF4843DBFF0000A6FFF7B700FFFCDE83FFFAD668FFFAD4
      62FFF8D25BFFF8D25BFFF7CF54FFF6CD50FFF4C947FFF4C947FFF4C947FFF1C4
      3AFFF1C43AFFF1C43AFFF2CB55FFDE8700FFEBE9F9FF7374FCFFE7F3E7FF3BB2
      3BFF3BB23BFF33B033FF2CAA2CFF2CAA2CFF20A720FF20A720FF15A115FF15A1
      15FF0C9D0CFF0C9D0CFF2CAA2CFF003800FFEA1B00FFF89C6FFFF4854BFFF57C
      43FFF57C43FFF4854BFFC2D791FFC1E0A0FFC1E0A0FFC2D791FFE97635FFE754
      18FFE75418FFE75418FFEB6A35FFD00000FF0000D9FF908BF4FF726DEDFF5757
      EAFFF5F5F5FFF4F4F4FFF2F2F2FFDBDDE8FFE4E3ECFFEEEEEEFFEBEBEBFFEBEB
      EBFF1818D5FF2723D8FF4843DBFF0000A6FFEDEDEDFFFDFDFDFFFAFAFAFFFAFA
      FAFFFAFAFAFFFAFAFAFFF8F8F8FFF6F6F6FFF6F6F6FFF6F6F6FFF4F4F4FFF2F2
      F2FFF2F2F2FFF2F2F2FFF2F2F2FFCDCDCDFF3A34FBFFF2F3FAFF525AEFFF45B4
      47FF3CAF43FF3CAF43FF33AA3BFF30A738FF29A530FF23A32BFF1EA026FF189D
      20FF11991AFF11991AFF30A738FF002C00FFEA1B00FFF89C6FFFF58854FFF485
      4BFFF58854FFB4F6B5FFD2E9D4FFE3E8E3FFE1E2DDFFB7CFBDFFB4F6B5FFEB6A
      35FFE75418FFE75418FFEB6A35FFD00000FF1A12E7FF9490F5FF7572EEFF5E5D
      EAFFF8F7F8FFF5F5F5FFEDECF5FFABACE9FFABACE9FFE4E3ECFFEEEEEEFFEBEB
      EBFF1818D5FF2E2ADBFF524CDEFF0000A6FF000000FF727171FF4E4E4EFF4949
      49FF414141FF414141FF3A3A3AFF323232FF323232FF2A2A29FF212121FF2121
      21FF171717FF171717FF323232FF000000FFEBEAFDFFA4A4FEFFEBEAFDFF4A4A
      FCFF4545FBFF4040FAFF3B3AF9FF3535F7FF2F2FF7FF2A2AF6FF2222F5FF2222
      F5FF1717F3FF1717F3FF3535F7FF0000E9FFF42D00FFF89C6FFFF58854FFF588
      54FFDAAE85FFCCF9D5FFEEF2EDFFC0B4A6FFB3A093FFE3E8E3FFCCF9D5FFBBAC
      75FFE95B22FFE75418FFEC703EFFD00000FF261EE9FF9896F4FF817CEEFF6564
      EDFFFAFAFAFFEDECF5FF6C6BE2FF534DE6FF534DE6FF5854DBFFE4E3ECFFEEEE
      EEFF2723D8FF3631DFFF524CDEFF0000B8FF000000FF727171FF545454FF4E4E
      4EFF494949FF414141FF414141FF3A3A3AFF323232FF323232FF2A2A29FF2121
      21FF212121FF171717FF3A3A3AFF000000FF0000FDFFF5F5FEFF5656FBFF4F4E
      FDFF4A4AFCFF4545FBFF4040FAFF3B3AF9FF3535F7FF2F2FF7FF2A2AF6FF2222
      F5FF2222F5FF1717F3FF3C3CF5FF0000E9FFF42D00FFF8A37AFFF8905DFFF588
      54FFCFD1A0FFE1FCE6FFF7F7F7FFA9B5B4FF8EA0B2FFF7F7F7FFD7F4DCFFAEC7
      88FFEB622AFFE95B22FFEC703EFFD00000FF2B27EBFF9E99F5FF8984F2FF726D
      EDFFFAFAFAFF8887EAFF5757EAFF625CE8FF5C51EAFF4644E4FF6A69DEFFEEEE
      EEFF2E2ADBFF3936DCFF5A54E2FF0000B8FF000000FF727171FF545454FF5454
      54FF4E4E4EFF494949FF414141FF414141FF3A3A3AFF323232FF323232FF2A2A
      29FF212121FF212121FF414141FF000000FFEBEAFDFFA4A4FEFFEDEDFEFF5353
      FDFF4F4EFDFF4A4AFCFF4545FBFF4040FAFF3B3AF9FF3535F7FF2F2FF7FF2A2A
      F6FF2222F5FF2222F5FF3C3CF5FF0000E9FFF42D00FFF8A37AFFF8905DFFF890
      5DFFDAAE85FFCCF9D5FFE5EDF3FFB7CFBDFFA9B5B4FFD3D5DDFFBEF5C9FFC7A4
      6FFFEB622AFFEB622AFFEA7544FFD00000FF382FEEFFA29EF7FF8984F2FF7572
      EEFFFAFAFAFF6B68E9FF7572EEFF726DEDFF6B68E9FF6560E5FF4843DBFFF2F2
      F2FF3631DFFF3F3CE1FF625CE8FF0000B8FFF2F2F2FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFFDFDFDFFFAFAFAFFFAFAFAFFFAFAFAFFF8F8F8FFF6F6
      F6FFF6F6F6FFF6F6F6FFF6F6F6FFD5D5D5FF0000FFFFF5F5FEFF6060FDFF5A5A
      FDFF5353FDFF5050FDFF4A4AFCFF4545FBFF4040FAFF3B3AF9FF3535F7FF2F2F
      F7FF2A2AF6FF2222F5FF4343F6FF0000E9FFF42D00FFFBA780FFF99562FFF890
      5DFFF8905DFFB4F6B5FFE1FCE6FFEEF2EDFFE3E8E3FFD7F4DCFFB4F6B5FFEA75
      44FFEB6A35FFEB622AFFEF7B4DFFD00000FF382FEEFFA7A3F8FF908BF4FF7979
      F1FFFDFDFDFFD3D0F5FFCDCEEEFF6564EDFF5E5DEAFFC1C0E8FFBEBDECFFF2F2
      F2FF3F3CE1FF4644E4FF6560E5FF0000B8FFFEC311FFFFE596FFFEDF7DFFFEDF
      7DFFFEDC79FFFDDB75FFFDDA72FFFCD86EFFFAD668FFFAD668FFFAD462FFF8D2
      5BFFF8D25BFFF7CF54FFF7D56BFFEA9D00FFF1F1FFFFB3B3FFFFEDEDFEFF5A5A
      FDFF5A5AFDFF5353FDFF5050FDFF4A4AFCFF4545FBFF4040FAFF3B3AF9FF3535
      F7FF2F2FF7FF2A2AF6FF4B4BF7FF0000E9FFF42D00FFFBA780FFF99562FFF995
      62FFF8905DFFF99562FFCFD1A0FFCEF0B3FFCEF0B3FFC2D791FFF4854BFFEC70
      3EFFEB6A35FFEB6A35FFEF7B4DFFD00000FF413BF0FFA7A3F8FF9490F5FF817C
      EEFFFDFDFDFFFDFDFDFFFAFAFAFF8887EAFF817CEEFFF5F5F3FFF5F5F5FFF5F5
      F5FF4644E4FF534DE6FF6B68E9FF0000C9FFFEC311FFFFE596FFFFE596FFFEE4
      93FFFEE493FFFEE28FFFFEE28FFFFDE18AFFFCDF88FFFCDE83FFFCDE83FFFADC
      7DFFF9DA79FFF9D975FFF7D771FFEA9D00FF0000FFFFF9F9FFFF7B7BFFFF7B7B
      FFFF7374FCFF7374FCFF7374FCFF6A6AFDFF6A6AFDFF6060FDFF6060FDFF5A5A
      FDFF5656FBFF5252F8FF4B4BF7FF0000E9FFEA1B00FFEF9E87FFEF9E87FFEF9E
      87FFEE9B84FFF8A37AFFEC9784FFE49E8DFFE49E8DFFE78F78FFEE8F6BFFE180
      6DFFE17A67FFE17A67FFDF765DFFAC0000FF382FEEFFA7A3F8FFA7A3F8FF9896
      F4FFFDFDFDFFFDFDFDFFFDFDFDFFEDECF5FFEDECF5FFFAFAFAFFFAFAFAFFF8F7
      F8FF6B68E9FF7572EEFF726DEDFF0000C9FFFFC924FFFFC514FFFFC514FFFFC5
      14FFFEC311FFFDC008FFFDC008FFFDBD00FFFABA00FFFABA00FFF7B700FFF6B3
      00FFF2AE00FFF2AE00FFEFA900FFEFA900FFF5F5FEFF6060FDFFDFDFFFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000E9FF0000E9FF0000F9FF0000F9FF0000F9FF0000
      F9FF0000F9FF0000F9FF0000EFFF0000E9FF0000E9FF0000EFFF0000EFFF0000
      EFFF0000EFFF0000E9FF0000E9FF0000E9FF524AF1FF413BF0FF413BF0FF2B27
      EBFFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF2F2F2FFF2F2F2FFEEEE
      EEFF0000D9FF0000D9FF0000D9FF0000C9FF004300FF004300FF002A00FF002A
      00FF002A00FF002A00FF001100FF001100FF001100FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF1A1A00FFA8A800FFB3B300FFA8A8
      00FFA8A800FF999900FF999900FF999900FF999900FF999900FF888800FF8888
      00FF888800FF888800FF888800FF888800FF009FF3FF0003F2FF0003F2FF0014
      EFFF000CEDFF000CEDFF0000EAFF0000EAFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000D4FF0000D4FF0000CDFFF2F2
      F2FFAE0E00FFEAEAEAFF0000C4FF0000BDFF0000BDFF0000BDFF0000BDFF0000
      B5FF0000B5FF0000B1FF0000B1FF0000B1FF004300FF68B067FF63AE63FF5EAB
      5EFF5AA85AFF52A352FF52A352FF42DDAEFF41E1B0FF449C44FF3F983EFF3F98
      3EFF3A943AFF349234FF349234FF000000FF000000FF858460FFD2D25CFFDCDC
      58FFD8D853FFD7D74EFFD5D54AFFD3D343FFD3D343FFD0D03AFFD0D03AFFCDCD
      33FFCDCD33FFCACA2DFFCACA2DFF888800FF00BFF9FF65E2FCFF5EABF9FF528C
      F8FF528CF8FF528CF8FF8EAFF1FF5091F1FF4389F6FF3984F4FF3984F4FF327E
      F3FF327EF3FF2D7BF2FF2D7BF2FF0000DDFF0000D4FF6063EDFF5B5DEDFFF9F9
      F9FFE4A579FFF8F8F8FF494BE7FF4548E6FF4244E5FF3C3FE4FF383AE2FF3436
      E4FF3134E0FF2E30E2FF2B2DDEFF0000B1FF004300FF6EB46EFF4BA04BFF449C
      44FF449C44FF33A438FF28F6F6FF48F2F6FF43EDF5FF1CF4F4FF258A25FF1983
      19FF198319FF198319FF349234FF000000FF000000FF696969FF5A5A44FFBFBF
      3EFFDFDC39FFD9D133FFD5CD2AFFD5CD2AFFD5CD2AFFD2C81AFFD2C81AFFCFC6
      12FFCDC30CFFCDC30CFFD5CD2AFF998700FF00B4F4FF65E2FCFF70E2FDFFC4D3
      E4FFBDC5E3FF3368F8FFE1E0DDFF568BD7FF2568F5FF1C71F4FF1663F3FF1663
      F3FF0D69F1FF0D69F1FF2D7BF2FF0000E0FF0000DAFF6567EEFF4243E9FFFAFA
      FAFFDD9564FFF8F8F8FF2E30E2FF2A2CE3FF2326E2FF1E20E0FF181BDFFF1316
      DDFF0E11DCFF0A0DDAFF2E30E2FF0000B1FF005700FF6EB46EFF52A352FF4BA0
      4BFF42DDAEFF39F0F9FFE96964FFF75F2CFFF75F2CFFE96964FF1EE9F4FF18D4
      A4FF198319FF198319FF3A943AFF000000FF000000FF696969FF4A4A4BFF5A5A
      44FF3E9EBAFF3AD4F9FF34D1F8FF2FCFF7FF2ACDF6FF23CBF5FF1BC9F4FF1BC9
      F4FF12C5F2FF12C5F2FF33CDF4FF008DE4FF00BAF6FF65E2FCFF49DBFCFF92E5
      F7FFCEE2D8FFCFD0D6FFD9D8DAFFBDC5E3FF2568F5FF8EAFF1FFE1E0DDFFCCCE
      D4FF0954F0FF0D69F1FF327EF3FF0000E0FF0000DAFF6A6CEFFF4A4CEBFFFAFA
      FAFFE09A6AFFF9F9F9FF3436E4FF2E30E2FF2A2CE3FF2326E2FF1E20E0FF181B
      DFFF1316DDFF0E11DCFF3134E0FF0000B5FF005700FF75B875FF53B161FF49FC
      FCFF43FBFBFFB3948FFFF97138FFFA7542FFF76A2EFFF5C0A9FFA1ACADFF1CF4
      F4FF1CF4F4FF139736FF358A35FF001100FF000000FF696969FF4A4A4BFF4A4A
      4BFF444B54FF3F9EBAFF3AD4F9FF34D1F8FF2FCFF7FF2ACDF6FF23CBF5FF1BC9
      F4FF1BC9F4FF12C5F2FF33CDF4FF008DE4FF00BAF6FF70E2FDFF51DAFDFF49DB
      FCFF47DFFCFFBBE4E8FFE8DAD5FFD3DBEAFFD3DBEAFFD9D8DAFFC4D3E4FF4388
      E6FF1663F3FF0D69F1FF3984F4FF0000E5FFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
      FCFFE19D6EFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF4F4F4FFF4F4
      F4FFF4F4F4FFF2F2F2FFF2F2F2FFEAEAEAFF005700FF72CA95FF51FCFCFF51FC
      FCFF49FCFCFFE9835BFFFA7542FFF99A72FFF5C0A9FFF7D5B9FFD99F7DFF28F6
      F6FF1CF4F4FF1CF4F4FF3AB775FF000000FF000000FF767676FF565656FF4A4A
      4BFF4A4A4BFF4A4A4BFF3FBCDCFF3AD8F9FF34D1F8FF2FCFF7FF2ACDF6FF23CB
      F5FF1BC9F4FF1BC9F4FF3ED1F5FF008DE4FF00BFF9FF70E2FDFF51DAFDFF51DA
      FDFF49DBFCFF46D5FBFFE8DAD5FFE8DAD5FFE1E0DDFFEDE4DCFFE3E4E7FFE3E4
      E7FF1C71F4FF1C71F4FF3984F4FF0000E5FFD05505FFEBB894FFE4A579FFE4A3
      76FFE39F72FFE19D6EFFE09A6AFFDD9564FFDD9564FFDB905CFFD98C56FFD98C
      56FFD6854DFFD6854DFFDD9564FFAE0E00FF006200FF7ABB7AFF53B161FF51FC
      FCFF51FCFCFFA6CACDFFF8E5D8FFF8E5D8FFEBC6ACFFF97138FFAA726CFF28F6
      F6FF28F6F6FF258A25FF449C44FF001100FF000000FF767676FF565656FF5656
      56FF4F5861FF4AAAC4FF43D7FBFF43D7FBFF3AD4F9FF34D1F8FF2FCFF7FF2ACD
      F6FF23CBF5FF1BC9F4FF3ED1F5FF008DE4FF00C3F9FF78E5FEFF5ADDFDFF51DA
      FDFF51DAFDFF49DBFCFF4CD2F2FF60CDE5FFA7DBE8FFEDE4DCFF7B97BAFFDDD7
      CFFFC4D3E4FF2568F5FF4389F6FF0000E5FFFDFDFDFFFEFEFEFFFEFEFEFFFDFD
      FDFFE4A376FFFCFCFCFFFAFAFAFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7
      F7FFF4F4F4FFF4F4F4FFF4F4F4FFEAEAEAFF006200FF80BE80FF63AE63FF5EAB
      5EFF53D9A8FF50F3FDFFE37676FFFA7542FFFA7542FFE96964FF35EFF8FF30D2
      9EFF349234FF2E902FFF4BA04BFF001100FF000000FF767676FF565656FF7373
      5BFF53AAC3FF4DD9FDFF4DD9FDFF43D7FBFF43D7FBFF3AD4F9FF34D1F8FF2FCF
      F7FF2ACDF6FF23CBF5FF3ED1F5FF008DE4FF00C3F9FF78E5FEFF5ADDFDFF5ADD
      FDFF51DAFDFF51DAFDFF47DFFCFF46D5FBFFECEAECFFECEAECFFECEAECFFECEA
      ECFF3D6CCEFF1C71F4FF4389F6FF0000E5FF0000E1FF797BF2FF5B5DEDFFFEFE
      FEFFE4A579FFFDFDFDFF4A4CEBFF4648EBFF4243E9FF3C3EE8FF3639E7FF3033
      E5FF2A2CE3FF2528E2FF4244E5FF0000BDFF006200FF80BE80FF68B067FF63AE
      63FF5EAB5EFF5AA85AFF51FCFCFF59FCFCFF51FCFCFF43FBFBFF449C44FF3F98
      3EFF3A943AFF349234FF52A352FF001100FF000000FF767676FF73735BFFCFCF
      5BFFE7E458FFE1DA4FFFE1DA4FFFE1DA4FFFDED644FFDED644FFDBD43CFFD9D1
      33FFD9D133FFD5CD2AFFDBD548FFA99B00FF00C3F9FF78E5FEFF5ADDFDFF5ADD
      FDFF5ADDFDFF51DAFDFF51DAFDFF78E5FEFFF7F6F5FFF7F6F5FFECEAECFF5ED7
      ECFF55BBDFFF2568F5FF4389F6FF0000EAFF0000E1FF797BF2FF5E60F0FFFEFE
      FEFFE7A87DFFFDFDFDFF5153EBFF4A4CEBFF4648EBFF4243E9FF3C3EE8FF3639
      E7FF3033E5FF2A2CE3FF494BE7FF0000C4FF006200FF80BE80FF80BE80FF80BE
      80FF7ABB7AFF7ABB7AFF75B875FF6AE2B5FF6AE2B5FF68B067FF68B067FF63AE
      63FF5EAB5EFF5AA85AFF52A352FF002A00FF000000FF9E9E7AFFE2E274FFE2E2
      74FFE2E274FFE2E274FFE2E274FFE2E274FFDEDE64FFDEDE64FFDEDE64FFDCDC
      58FFD8D853FFD8D853FFD7D74EFF999900FF00BEFBFF78E5FEFF78E5FEFF78E5
      FEFF78E5FEFF70E2FDFF70E2FDFF70E2FDFF92E5F7FF92E5F7FF5FDCFBFF5ADD
      FDFF56DDF7FF52D7F8FF528CF8FF0000EAFF0000E1FF797BF2FF797BF2FFFEFE
      FEFFEBB894FFFEFEFEFF7071F0FF6A6CEFFF6A6CEFFF6567EEFF6063EDFF5B5D
      EDFF5659EBFF5153EBFF4D4FE8FF0000C4FF006200FF006200FF006200FF0062
      00FF006200FF005700FF005700FF005700FF005700FF004300FF004300FF0043
      00FF004300FF002A00FF002A00FF002A00FF4A4A00FFC3C300FFCBCB00FFC3C3
      00FFC3C300FFC3C300FFBCBC00FFBCBC00FFBCBC00FFB3B300FFB3B300FFB3B3
      00FFB3B300FFA8A800FFA8A800FFA8A800FF00C3F9FF00BEFBFF00BFF9FF00BF
      F9FF00BFF9FF00BEFBFF00BAF6FF00BAF6FF00BEFBFF00BFF9FF00BAF6FF00B4
      F4FF00B4F4FF00B4F4FF00BBEFFF0954F0FF0000E1FF0000E1FF0000E1FFFEFE
      FEFFD05505FFFDFDFDFF0000DAFF0000DAFF0000DAFF0000DAFF0000D4FF0000
      D4FF0000D4FF0000CDFF0000CDFF0000CDFF007900FF006700FF006700FF0053
      00FF005300FF005300FF005300FF0000E5FF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFF0000B6FF0000AAFF0000AAFF0000
      AAFF0000AAFF000099FF000099FF000099FF00008EFF00008EFF00008EFF0000
      8EFF000087FF000087FF000087FF000087FF00CBEFFF00C5EBFF00C5EBFF00BB
      E3FF00BBE3FF00BBE3FF00B3DDFF00BBE3FF00B3DDFF00A9D8FF00A9D8FF00B3
      DDFF00B8D6FF00B8D6FF00B8D6FF0087B3FF00B300FF00B300FF00A700FF00A7
      00FF00A700FF009800FF009800FF009800FF009800FF009800FF008700FF0087
      00FF008700FF008700FF008700FF008700FF006700FF61BF61FF5DBD5DFF57B9
      57FF53B653FF57B957FF53B653FF4343F7FF4343F7FF3A3AF5FF3A3AF5FF3232
      F3FF3232F3FF2D2DF2FF2D2DF2FF0000DDFF0000B6FF6262DEFF5A5ADBFF5A5A
      DBFF5454D8FF4E4ED8FF4949D5FF4444D3FF4141D4FF3B3AD3FF3939CFFF3434
      D0FF3030CEFF3030CEFF2B2BCDFF000087FF00CBEFFF69E9F7FF69E9F7FF60E4
      F6FF59E2F3FF59E2F3FF53E7F6FF4FDDF0FF4ADBEFFF42E6F3FF42E6F3FF3CD7
      ECFF36B5CEFF3EA9BEFF2D2D2DFF000000FF00B300FF68DE68FF68DE68FF68DE
      68FF5CD95CFF5CD95CFF54D854FF50D650FF49D549FF49D549FF41D142FF41D1
      42FF3ACD3AFF3ACD3AFF3ACD3AFF008700FF007900FF61BF61FF44B244FF3EAF
      3EFF39AB3AFF3EAF3EFF39AB3AFF2929F6FF2323F5FF1E1EF4FF1818F3FF1212
      F2FF0C0CF1FF0C0CF1FF2D2DF2FF0000E0FF0000B6FF6262DEFF4444D6FF3F3F
      D4FF3B3AD3FF3434D0FF2B2BCDFF2B2BCDFF2020CBFF2020CBFF1616CBFF1616
      CBFF0D0DC6FF0D0DC6FF3030CEFF000087FF00D2F2FF74EBF9FF50E3F4FF48E1
      F4FF42E6F3FF3CE6F5FF3CD7ECFF34CEE8FF34CEE8FF36B5CEFF141414FF1414
      14FF141414FF141414FF2D2D2DFF000000FF00B300FF68DE68FF4ED94EFF49D5
      49FF49D549FF41D142FF3ACD3AFF35D035FF35D035FF25CA25FF25CA25FF25CA
      25FF1BC61AFF1BC61AFF3ACD3AFF008700FF007900FF6CC46CFF49B549FF44B2
      44FF3EAF3EFF44B244FF3FAD42FF2E2EF7FF2929F6FF2323F5FF1E1EF4FF1818
      F3FF1212F2FF1212F2FF3232F3FF0000E0FF0000B6FF696AE2FF4849D8FF4444
      D6FF3F3FD4FF3B3AD3FF3434D0FF3030CEFF2B2BCDFF2020CBFF2020CBFF6DC1
      84FF62BA79FF0D0DC6FF3030CEFF000087FF00D2F2FF74EBF9FF53E7F6FF4CED
      F8FF48E1F4FF4EC2D4FF3EA9BEFF6479D9FF6479D9FF332E48FF141414FF1414
      14FF141414FF474545FFAAAAAAFFDFDEDAFF00C593FF79E5D0FF57DDC3FF57DD
      C3FF57DDC3FF47D7BBFF47D7BBFF47D7BBFF3ED6B8FF39D4B5FF32D1B2FF32D1
      B2FF29CEAEFF29CEAEFF47D7BBFF009550FF007900FF6CC46CFF4EB74EFF49B5
      49FF44B244FF49B549FF45B047FF3535F6FF2E2EF7FF2929F6FF2323F5FF1E1E
      F4FF1818F3FF1212F2FF3535F6FF0000E5FF0000B6FF6F71E3FF4E4ED8FF4849
      D8FF4444D6FF3F3FD4FF3B3AD3FF3434D0FF3030CEFF2B2BCDFF6DC184FF62BA
      79FF62BA79FF62BA79FF3434D0FF00008EFF00D5F5FF77E7F4FF4EC2D4FF4745
      45FF474545FF474545FF7284D9FF332E48FF332E48FF6479D9FFC9C9C3FFD2D2
      C8FFF3F3F3FFF3F3F3FFF5F5F5FFE3E4E7FF00CCE8FF7EE8F4FF62E2F1FF5CE0
      F0FF5CE0F0FF56DEEEFF51DDEDFF4CDBECFF48D9EBFF42D9E9FF3DD7E8FF38D5
      E7FF32D2E5FF32D2E5FF4DD8E8FF00A0C8FF008500FF72C671FF53B953FF4EB7
      4EFF49B549FF4EB74EFF4AB24DFF3843F7FF3843F7FF2F3AF7FF2732F6FF2732
      F6FF1C28F4FF1C28F4FF3843F7FF0000E5FF141AD9FF8E7BC3FF714C8DFF6C60
      C7FF6C60C7FF714C8DFF7E66AFFF6F71E3FF3434D0FF3030CEFFD9DAF1FF4C25
      33FF8B8B99FFD9DAF1FF3939CFFF00008EFF000000FF747373FF505050FF5050
      50FF474545FF7284D9FF7284D9FFD2D2C8FFE3E4E7FF7789E0FF7284D9FFF5F5
      F5FFF5F5F5FFF3F3F3FFF5F5F5FFE3E4E7FF00CCE8FF86E9F6FF68E4F2FF62E2
      F1FF62E2F1FF5CE0F0FF56DEEEFF51DDEDFF4CDBECFF48D9EBFF42D9E9FF3DD7
      E8FF38D5E7FF32D2E5FF50D8E9FF00A0C8FF008500FF76C876FF58BC58FF53B9
      53FF4EB74EFF53B953FF53B653FF41FAFAFF3BF9F9FF35F8F8FF30F7F7FF2AF6
      F6FF23F5F5FF23F5F5FF3EF5F5FF00E7E7FFA36664FFCBC1DFFFB18691FF9A83
      B9FF9A83B9FFCDA08FFFB9AED6FF987091FF3B3AD3FF3434D0FFDFE0F3FFE5C4
      6CFFE5C46CFFD9DAF1FF3F3FD4FF00008EFF000000FF747373FF606060FFC9C9
      C3FFDFDEDAFFFDFDFDFFF3F3F9FF7789E0FF7284D9FFF8DEE4FFF7F7F2FFF5F5
      F5FFD7F2F5FF4FDDF0FF4DDEF2FF00A9D8FF00CCE8FF86E9F6FF68E4F2FF68E4
      F2FF62E2F1FF62E2F1FF5CE0F0FF56DEEEFF51DDEDFF4CDBECFF48D9EBFF42D9
      E9FF3DD7E8FF38D5E7FF54DAE9FF00A0C8FF008500FF79C979FF5BBD5BFF58BC
      58FF53B953FF58BC58FF55BA57FF46FBFBFF41FAFAFF3BF9F9FF35F8F8FF30F7
      F7FF2AF6F6FF23F5F5FF43F6F6FF00E7E7FF4C2074FFC1BBE6FFA5A8F1FF8585
      E5FF8585E5FFA5A8F1FF9088D5FF8C74AFFF4141D4FF3B3AD3FFE7E7F4FFE7E7
      F4FFE7E7F4FFDFE0F3FF4444D3FF000099FF878789FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFFFDFDFDFFDFDEDAFF919ADCFF48E1F4FF48E1F4FF37DC
      F1FF37DCF1FF2ED8EEFF4DDEF2FF00B3DDFF006CF5FF8FC1FBFF74B2F9FF74B2
      F9FF6FAFF8FF6AABF7FF6AABF7FF63A8F5FF60A5F3FF58A1F4FF58A1F4FF4C99
      F0FF4C99F0FF4C99F0FF60A5F3FF001EDBFF008900FF79C979FF5DBD5DFF5BBD
      5BFF58BC58FF5DBD5DFF5BBD5BFF4BFCFCFF46FBFBFF41FAFAFF3BF9F9FF35F8
      F8FF30F7F7FF2AF6F6FF4BF7F7FF00EAEAFF1616CBFF9594E7FF8585E5FF6F71
      E3FF696AE2FF787BE8FF7977DFFF6B6BDEFF4444D6FF4141D4FF3B3AD3FF3434
      D0FF3030CEFF2B2BCDFF4949D5FF000099FFFFFFFFFFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFE8FBFCFF74EBF9FF59E2F3FF4FD2EDFF48E1F4FF42DFF4FF42DF
      F4FF37DCF1FF37DCF1FF50E3F4FF00B3DDFF0214FFFF949CFFFF7B85FCFF7B85
      FCFF7B85FCFF727CFAFF727CFAFF6B74FAFF6B74FAFF6B74FAFF606AF9FF606A
      F9FF5661F7FF5661F7FF6B74FAFF0000EDFF008500FF79C979FF79C979FF79C9
      79FF76C876FF79C979FF79C979FF6AFDFDFF6AFDFDFF5FFBFBFF5FFBFBFF5FFB
      FBFF54F9F9FF54F9F9FF4BF7F7FF00EAEAFF4C2533FFC1BBE6FFDFD5E2FFB9AE
      D6FFAAA1D9FFC1B7DAFFD6CFE8FFC3A0A3FF6B6BDEFF6262DEFF6262DEFF5A5A
      DBFF5454D8FF5454D8FF4E4ED8FF000099FFFFFFFFFFFFFFFFFF8FEFFBFF8FEF
      FBFF74EBF9FF74EBF9FF74EBF9FF74EBF9FF74EBF9FF69E7F7FF69E7F7FF60E4
      F6FF60E4F6FF59E2F3FF59E2F3FF00BBE3FF0214FFFF949CFFFF949CFFFF949C
      FFFF949CFFFF8D94FDFF8D94FDFF8D94FDFF868EFCFF868EFCFF7B85FCFF7B85
      FCFF727CFAFF727CFAFF727CFAFF0000EDFF008900FF008900FF008900FF0089
      00FF008500FF008500FF008500FF00FBFBFF00FBFBFF00FBFBFF00F6F6FF00F6
      F6FF00F2F2FF00F2F2FF00EFEEFF00EFEEFF6C60C7FF987091FF6A0000FF3C14
      7EFF3C1683FF580000FF4C2074FF6C60C7FF0000B6FF0000B6FF0000B6FF0000
      B6FF0000AAFF0000AAFF0000AAFF0000AAFF00D9F5FF00D5F5FF00D5F5FF00D5
      F5FF00D5F5FF00D2F2FF00D2F2FF00D2F2FF00CFF1FF00CBEFFF00CBEFFF00C5
      EBFF00C5EBFF00C5EBFF00BBE3FF00BBE3FF0214FFFF0214FFFF0214FFFF0214
      FFFF000DFDFF000DFDFF000DFDFF0000F9FF0000F9FF0000F9FF0000F9FF0000
      F9FF0000EDFF0000EDFF0000EDFF0000EDFF006500FF006500FF004F00FF004F
      00FF004F00FF004F00FF004F00FF003800FF003800FF003800FF003800FF0026
      00FF002600FF002600FF002600FF002600FF0000F3FF0000F3FF0000F3FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E5FF0000E5FF0000E5FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFFEAEAEAFFF3F3F3FFF1F1F1FFF1F1
      F1FF8787EFFF0000EEFF0000EEFF0000EAFF0000EAFF0000E6FF0000E6FF0000
      E2FF0000DFFF0000DDFF0000DDFF0000DDFFC1DFC1FFD7CFDDFF0000A1FF0000
      A1FF0000A1FF0000A1FF0000A1FF000091FF000091FF000091FF000091FF0000
      91FF000080FF000080FFADA7C1FF97C197FF006500FF63BF63FF5ABB5AFF5ABB
      5AFF50B750FF50B750FF49B449FF44B244FF41AE41FF3AAB3AFF3AAB3AFF34A9
      34FF31A632FF2EA52EFF2AA32AFF002600FF0000F8FF6363FCFF5A5AFAFF5A5A
      FAFF5251F9FF5251F9FF4545F8FF4545F8FF4545F8FF3A3AF5FF3A3AF5FF3333
      F3FF3333F3FF2C2CF4FF2C2CF4FF0000DDFFEAEAEAFFFBFBFBFFFAFAFAFFFAFA
      FAFFF7F7F9FFD8D8F9FF5656F9FF4A4AF7FF4444F7FF4141F6FF3D3DF5FF3434
      F3FF3131F3FF2D2DF2FF2D2DF2FF0000DDFF009700FFFAFAFAFFFAFAFAFFC5C5
      F3FF6666DDFF7575E3FF7575E3FF6666DDFF6666DDFF6B6BE0FF6666DDFF4647
      D4FFB3B2EBFFF2F2F2FFF2F2F2FF005600FF007500FF63BF63FF44B244FF3DB1
      3EFF3AAB3AFF34A934FF2EA52EFF2AA32AFF23A323FF1EA01EFF189C18FF139A
      13FF0E970FFF0A950AFF2EA52EFF002600FF0000F8FF6363FCFF4545F8FF3C3C
      FAFF3A3AF5FF3333F8FF2C2CF4FF2C2CF4FF2020F5FF2020F5FF1515F3FF1515
      F3FF0C0CF1FF0C0CF1FF2C2CF4FF0000E0FFECECECFFFCFCFCFFFAFAFAFFFAFA
      FAFFC6C6FBFF5151F9FF3535F8FF2C2CF7FF2929F6FF2424F5FF1E1EF4FF1313
      F2FF0F0FF2FF0C0CF1FF2D2DF2FF0000DFFF008500FF71C772FFCAEBC7FFFAFA
      FAFFF8F8F8FF5A5ADCFF5A5ADCFFCFD0EFFFD0CFEEFF5A5ADCFF4647D4FFF2EC
      F7FFF2F2F2FFB7E0B2FF42AF42FF005600FF007500FF6CC56CFF49B449FF44B2
      44FF3DB13EFF3AAB3AFF34A934FF2EA52EFF2AA32AFF23A323FF1EA01EFF189C
      18FF139A13FF0E970FFF31A632FF002600FF004100FF70C178FF469A71FF469A
      71FF3C9369FF3C9369FF318B60FF318B60FF238355FF238355FF238355FF1378
      48FF137848FF137848FF318B60FF001D00FFF0F0F0FFFCFCFCFFFBFBFBFFFBFB
      FBFFFAFAFAFFE2E2FAFF5656F9FF3333F8FF2F2FF7FF2929F6FF2424F5FF1818
      F3FF1313F2FF0F0FF2FF3131F3FF0000DFFF01A001FF8DD58EFF5DBF5DFF86D2
      86FFFAFAFAFFFAFAFAFFF8F8F8FFF7F7F7FFF7F7F7FFF7F7F7FFF2F2F2FFF2F2
      F2FF69C46AFF23A629FF62BE63FF006300FF007500FF6CC56CFF50B750FF49B4
      49FF44B244FF3DB13EFF3DB13EFF31E9D8FF31E9D8FF29A629FF23A323FF1EA0
      1EFF189C18FF139A13FF34A934FF002600FF008400FF70C178FF4CB94CFF4AB5
      4AFF45B345FF3FB33FFF39B03AFF35AC35FF2CAA2CFF2AA52AFF24A224FF1BA3
      1BFF1BA31BFF169D16FF35AC35FF004100FFF0F0F0FFFDFDFDFFFCFCFCFFFCFC
      FCFFC6C6FBFF5151F9FF4040FAFF3A3AF8FF3535F8FF2F2FF7FF2929F6FF1E1E
      F4FF1818F3FF1313F2FF3535F4FF0000E2FF01A001FF96D996FF7ED07DFF69C4
      6AFF57BE57FFF5F9ECFF8A93D7FFCED7E7FFD7DEE7FF8A93D7FFF5F9ECFF33B1
      36FF42AF42FF52BA51FF69C46AFF006300FF0000BDFF727EE8FF5061E2FF5061
      E2FF4A5AE0FF4555DEFF3FDDDDFF38F0EAFF38F0EAFF2FDBD8FF2736DCFF2736
      DCFF1C2CD9FF1C2CD9FF3A48DDFF0000BDFF008400FF70C178FF51B851FF4CB9
      4CFF4AB54AFF45B345FF40B040FF3BAC3BFF35AC35FF2FA72FFF2AA52AFF24A2
      24FF1F9F1FFF169D16FF3BAC3BFF004100FFF0F0F0FFFEFEFEFFFDFDFDFFFDFD
      FDFFFCFCFCFFEAEAFDFF6465FCFF4040FAFF3A3AF8FF3535F8FF2F2FF7FF2424
      F5FF1E1EF4FF1818F3FF3A3AF8FF0000E6FF0C9B22FF96D996FF7ED07DFF7ED0
      7DFF5DBF5DFFCAEBC7FFF2ECF7FFFAFAFAFFF8F8F8FFF2ECF7FFCAEBC7FF38AE
      39FF57BE57FF52BA51FF69C46AFF005600FF0000FDFF7372FEFF5757FDFF5353
      FCFF504FFDFF4A4AFCFF4647FBFF40B6F2FF3BB4F1FF353AF8FF3030F7FF2A2A
      F6FF2323F5FF2323F5FF3E3EF5FF0000EAFF008400FF70C178FF57BA57FF51B8
      51FF51B851FF4AB54AFF45B345FF40B040FF3BAC3BFF35AC35FF2FA72FFF2AA5
      2AFF24A224FF1F9F1FFF3BAC3BFF004100FFF0F0F0FFFEFEFEFFFEFEFEFFFEFE
      FEFFD0D0FEFF5B5BFCFF4A4AFCFF4646FBFF4040FAFF3A3AF8FF3535F8FF2929
      F6FF2424F5FF1F1FF4FF3D3DF5FF0000E6FF0C9B22FF9BDB9BFF86D286FF71C7
      72FF69C46AFFF5F9ECFFFAFAFAFFCED7E7FFC7D1E3FFF8F8F8FFF5F9ECFF48B5
      49FF48B549FF57BE57FF71C772FF005600FF0000FFFF7979FFFF5C5CFEFF5757
      FDFF5353FCFF504FFDFF4A4AFCFF4647FBFF4141FAFF3C3BF9FF3636F8FF3030
      F7FF2A2AF6FF2323F5FF4343F6FF0000EAFFD1E7D1FFEAF6EAFFEAF6EAFFEAF6
      EAFFE6F3E6FFE6F3E6FFE6F3E6FFE3F1E3FFE3F1E3FFE3F1E3FFE0EFE0FFDFED
      E0FFDCECDCFFDCECDCFFDFEDE0FFB7D3B7FFF2F2F2FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFEFFEAEAFDFF6D6DFDFF4A4AFCFF4646FBFF4040FAFF3A3AF8FF2F2F
      F7FF2929F6FF2424F5FF4444F7FF0000E6FF0C9B22FF9BDB9BFF69C46AFF9BDB
      9BFFFDFDFDFFFDFDFDFFFDFDFDFFDCE8E5FFDCE8E5FFFAFAFAFFF8F8F8FFF7F7
      F7FF86CF87FF38AE39FF71C772FF006300FF0000FFFF7979FFFF5C5CFEFF5C5C
      FEFF5757FDFF5353FCFF504FFDFF4A4AFCFF4647FBFF4141FAFF3C3BF9FF3636
      F8FF3030F7FF2A2AF6FF4647FBFF0000EAFFF5F5F5FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFAFAFAFFFAFAFAFFF7F7
      F7FFF7F7F7FFF6F6F6FFF7F7F7FFDEDEDEFFF2F2F2FFFFFFFFFFFEFEFEFFFEFE
      FEFFD0D0FEFF6869FDFF5656FDFF5050FDFF4A4AFCFF4646FBFF4040FAFF3535
      F8FF2F2FF7FF2C2CF7FF4A4AF7FF0000EAFF008F16FF8DD58EFFDCF5D7FFFFFF
      FFFFF8F8F8FF7575E3FF7575E3FFDCD6FCFFDCD6FCFF6B6BE0FF5A5ADCFFF2EC
      F7FFF7F7F7FFD1EFCCFF5DBF5DFF005600FF0000FFFF7979FFFF7979FFFF7979
      FFFF7979FFFF7372FEFF7372FEFF6A6AFDFF6A6AFDFF6262FCFF6262FCFF5B5B
      FAFF5757FDFF5353FCFF4B4BF7FF0000EAFFF5F5F5FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFAFA
      FAFFFAFAFAFFF7F7F7FFF7F7F7FFDEDEDEFFF2F2F2FFFFFFFFFFFFFFFFFFFFFF
      FFFFFDFDFEFFEAEAFDFF8686FEFF706FFDFF6D6DFDFF6869FDFF6465FCFF5B5B
      FCFF5656F9FF5151F9FF4A4AF7FF0000EAFF23A629FFFFFFFFFFFFFFFFFFC5C5
      F3FF8888E8FF9898ECFF9898ECFF8888E8FF8888E8FF8888E8FF8888E8FF6B6B
      E0FFB3B2EBFFF8F8F8FFF7F7F7FF008500FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FDFF0000F5FF0000F5FF0000
      F5FF0000F5FF0000F5FF0000EAFF0000EAFFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2F2FFEEEEEEFFEEEEEEFFEEEEEEFFEAEA
      EAFFEAEAEAFFE5E5E4FFE5E5E4FFE5E5E4FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
      F2FFA9A9FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000FAFF0000FAFF0000
      F3FF0000F3FF0000F3FF0000EEFF0000EEFFDCD6FCFFDCD6FCFF0203D5FF0203
      D5FF1212D7FF1212D7FF1212D7FF0203D5FF0203D5FF0000C9FF0000C9FF0000
      C9FF0000C9FF0000C9FFC7B5EFFFB3B2EBFFB80000FFB80000FFB80000FFA900
      00FFA90000FFA90000FFA90000FFA90000FF960000FF960000FF960000FFA900
      00FFCF8978FFA90000FF960000FF960000FF640000FF640000FF640000FF6400
      00FF640000FF00B3EDFF00A6E7FF0099E7FF0099E7FF0099E7FF00A6E7FF2900
      00FF290000FF290000FF290000FF290000FF001200FF001200FF001200FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF00DDDBFF00E1D5FF00DFD1FF00DBCFFF00E3E1FF00D1DFFF0000
      C5FF0000C5FF0000C5FF0000C5FF0000A5FFB80000FFE27B63FFDF755DFFE272
      58FFDD6D53FFDD694EFFDD6549FFDC6044FFDA5C3FFFD7593CFFE2866FFFF3E2
      DEFF89898BFFD44B2CFFD44B2CFF960000FF640000FFBF805FFFBD7B5BFFBA77
      57FFBC7153FF4FE3FCFF4ADBF7FF43D3F7FF43D3F7FF3BD7F7FF38DAF4FFA858
      32FFA85832FFA5532CFFA5532CFF290000FF002600FF5F9F5FFF5B9D5BFF589A
      57FF549753FF4F934FFF499149FF438D43FF3E8A3EFF3A853AFF3A853AFF3583
      35FF318031FF2C7B2CFF2C7B2CFF000000FF000000FF636363FF5C5C5CFF5858
      57FF535353FF4EF5F5FF45F6F6FF45F6F6FF41F6F6FF3BF4F4FF38EDF4FF3636
      F6FF3030F4FF3030F4FF2B2BF5FF0000C5FFB80000FFE27B63FFDC6044FFDA5C
      3FFFD85739FFD85233FFD44B2CFFD44B2CFFD34322FFDF755DFFEFD7D2FF7A7A
      7CFF10C6F2FFCD3511FFD44B2CFF960000FF640000FFC28667FFB06843FFAD61
      3DFFAF5B38FF34DCF8FF2BD4F7FF25CDF6FF25CDF6FF1BD2F4FF1BD2F4FF983B
      0EFF983B0EFF983B0EFFA5532CFF290000FF002600FF65A265FF438D43FF3E8A
      3EFF3A853AFF32637CFF2D3BD5FF2929F6FF2323F4FF1D2CCFFF184F6AFF126C
      12FF0C680CFF0C680CFF2C7B2CFF000000FF000000FF636363FF444444FF3E3E
      3FFF393939FF33F1F1FF2EF7F7FF29F6F6FF23F5F5FF1BF3F4FF1BF3F4FF1212
      F2FF0C0CF1FF0C0CF1FF3030F4FF0000C5FFC80000FFE58269FFDD6549FFDC60
      44FFDA5C3FFFD85739FFD85233FFD44B2CFFE27B63FFEFD7D2FF7A7A7CFF1AC9
      F3FF10C6F2FFCD3511FFD45134FF960000FF790000FFC28667FFB36C48FFB466
      44FFB3603FFF3BDFF9FF34DCF8FF377484FF306977FF21D6F5FF21D6F5FF9C42
      16FF9C4216FF983B0EFFA85832FF290000FF002600FF69A569FF499149FF438D
      43FF3D6C85FF393BF6FF3434F8FF2E2EF7FF2929F6FF2323F4FF1E1FF1FF184F
      6AFF126C12FF0C680CFF318031FF000000FF000000FF6C6C6CFF494949FF4444
      44FF3E3E3FFF3BF4F4FF34F8F8FF2EF7F7FF29F6F6FF23F5F5FF1EEDF4FF1B1B
      F3FF1212F2FF1212F2FF3030F4FF0000C5FFC80000FFE2866FFFE06A4EFFDD65
      49FFDC6044FFDA5C3FFFDA573AFFE2866FFFF3DEDAFF89898BFF23CCF4FF23CC
      F4FF1AC9F3FFCD3511FFD45134FF960000FF790000FFC78D72FFB6704EFFB36C
      48FFB46644FF42E0FAFF3BD7F7FF306977FF306977FF2BD4F7FF23D8F5FFA246
      1EFF9C4216FF9C4216FFA85832FF290000FF003600FF6DA86DFF4E954EFF4991
      49FF4458C8FF4040FAFF3A3AF9FF3434F8FF2E2EF7FF2929F6FF2323F4FF1E35
      B9FF196F19FF126C12FF358335FF000000FF000000FF6C6C6CFF4E4E4EFF4949
      49FF444444FF3FF3F3FF3AF9F9FF34F8F8FF2EF7F7FF29F6F6FF27EFF6FF1B1B
      F3FF1B1BF3FF1212F2FF3636F6FF0000E8FFC80000FFE78871FFE16E53FFE06A
      4EFFDD6549FFDC6044FFE58D78FFF3DEDAFF89898BFF32CBF1FF2ACFF6FF23CC
      F4FF23CCF4FFCD3511FFD7593CFF960000FF790000FFC78D72FFB97452FFB670
      4EFFB8694AFF42E0FAFF3F9FB9FF377484FF377484FF2F94AEFF2AD9F6FFA34D
      24FF9F4A1FFF9C4216FFAD613DFF290000FF003600FF71AA70FF529752FF4E95
      4EFF4A4CF4FF4646FBFF4040FAFF3A3AF9FF3434F8FF2F2FF7FF2929F6FF2427
      EDFF1F741FFF196F19FF3A853AFF000000FF000000FF747474FF535353FF4E4E
      4EFF494949FF45F6F6FF40FAFAFF3AF9F9FF34F8F8FF2FF7F7FF27EFF6FF2323
      F5FF1B1BF3FF1B1BF3FF3C3CF5FF0000E8FFC80000FFE88B75FFE27258FFE16E
      53FFE06A4EFFE9927DFFF3E2DEFF98989AFF3DD1F6FF35D2F8FF30D1F7FF2ACF
      F6FF23CCF4FFD34322FFDA5C3FFF960000FF790000FFC99479FFBC7857FFB974
      52FFBB6E4FFF4FE3FCFF437A89FF437A89FF377484FF306977FF2FDBF7FFA553
      2CFFA34D24FF9F4A1FFFB3603FFF290000FF003F00FF76AD76FF589A57FF5497
      53FF4F62CCFF4A4AFBFF4646FBFF4040FAFF3A3AF9FF3434F8FF2F2FF7FF2A40
      BEFF257825FF1F741FFF3E8A3EFF000000FF000000FF747474FF585857FF5353
      53FF4E4E4EFF4EF5F5FF46FBFBFF40FAFAFF3AF9F9FF34F8F8FF2FF1F7FF2B2B
      F5FF2323F5FF1B1BF3FF3C3CF5FF0000E8FFC80000FFE88F79FFE27258FFE272
      58FFEB9D8AFFFAE8E4FF98989AFF44D5F9FF44D5F9FF3CD5F9FF35D2F8FF30D1
      F7FF2ACFF6FFD34322FFDC6044FFA90000FF810200FFC99479FFBD7B5BFFBC78
      57FFBC7153FF4FE3FCFF4A808CFF44BDDBFF44BDDBFF377484FF34DCF8FFA858
      32FFA5532CFFA34D24FFB06843FF290000FF003F00FF78AE78FF5B9D5BFF589A
      57FF537E94FF5050FAFF4A4AFBFF4646FBFF4040FAFF3A3AF9FF3537F5FF3263
      7CFF2C7B2CFF257825FF438D43FF000000FF000000FF797979FF5C5C5CFF5858
      57FF535353FF4EF5F5FF4BFCFCFF46FBFBFF40FAFAFF3AF9F9FF35F2F8FF3030
      F4FF2B2BF5FF2323F5FF4848F7FF0000E8FFC80000FFE88F79FFE27B63FFEB9D
      8AFFFAE8E4FFA1A1A2FF57DAF9FF49D9FBFF49D9FBFF44D5F9FF3CD5F9FF35D2
      F8FF30D1F7FFD44B2CFFDD6549FFA90000FF810200FFC99479FFBF805FFFBD7B
      5BFFBF7558FF4FE3FCFF4FE3FCFF4BDCFCFF46DBFBFF42E0FAFF3BDFF9FFAF5B
      38FFA85832FFA5532CFFB36C48FF4C0000FF004200FF7AB07AFF5F9F5FFF5B9D
      5BFF589A57FF537E94FF505BDFFF4A4AFBFF4646FBFF414EDBFF3D6C85FF3583
      35FF318031FF2C7B2CFF488F48FF000000FF000000FF797979FF5C5C5CFF5C5C
      5CFF585857FF4EF5F5FF50FDFDFF4BFCFCFF46FBFBFF40FAFAFF3CF3F9FF3636
      F6FF3030F4FF2B2BF5FF4848F7FF0000E8FFC80000FFE88F79FFF3C3B8FFFAE8
      E4FFB3B3B5FF71E0FCFF71E0FCFF71E0FCFF64DEFCFF64DEFCFF64DEFCFF57DA
      F9FF57DAF9FFDD6D53FFDD694EFFA90000FF810200FFC99479FFC99479FFC994
      79FFC78D72FF72E9FEFF72E9FEFF6AE0FDFF6AE0FDFF62E4FCFF62E4FCFFBE79
      5BFFBA7757FFB97452FFB6704EFF4C0000FF004200FF7AB07AFF7AB07AFF78AE
      78FF76AD76FF73AB73FF71AA70FF6DA86DFF69A569FF65A265FF5F9F5FFF5B9B
      5BFF569857FF529752FF4D934DFF000000FF000000FF797979FF797979FF7979
      79FF747474FF72FBFBFF72FBFBFF6AFDFDFF6AFDFDFF64FCFCFF5FF6FBFF5656
      F9FF5656F9FF5656F9FF4848F7FF0000E8FFC80000FFDB4624FFF7D5CDFF5252
      54FF00B9F7FF00AFEBFF00BDFDFF00BDFDFF00B8FAFF00B8FAFF00B3F6FF00B3
      F6FF00AFF3FFB80000FFA90000FFA90000FF810200FF810200FF810200FF8102
      00FF790000FF00CFFDFF00CFFDFF00C0FAFF00C0FAFF00C0FAFF00C0FAFF6400
      00FF640000FF640000FF4C0000FF4C0000FF004200FF004200FF004200FF0042
      00FF003F00FF003600FF003600FF003600FF002600FF002600FF002600FF0012
      00FF001200FF001200FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF00EFF1FF00E9FDFF00E9FDFF00E8F9FF00F7F9FF00E8F9FF0000
      F2FF0000F2FF0000F2FF0000F2FF0000E8FF510000FF510000FF510000FF3100
      00FF310000FF310000FF310000FF310000FF110000FF110000FF110000FF1100
      00FF8A4022FF110000FF110000FF110000FFB76D00FFAF6200FFB35700FFB357
      00FFAA5600FFA94700FFA94700FFA23C00FFA23C00FF963900FF943100FF9428
      00FF942800FF942800FF942800FF942800FFA23500FF972300FF8B0C00FF8B0C
      00FF008DCFFF0000DAFF006CD6FF6B0000FF6B0000FF6B0000FF4D0000FF4D00
      00FF4D0000FF4D0000FF4D0000FF4D0000FF006B00FF006B00FF006B00FF006B
      00FF004E00FF004E00FF004E00FF004E00FF004E00FF003100FF003100FF0031
      00FF003100FF003100FF003100FF003100FF510000FFB88570FFB27C67FFC6A4
      95FFDFCBC4FFAC7159FFAC7159FFA66952FFA66952FFA26249FF9D5B40FFD4BD
      B4FFEBE1DEFFC29D8FFF995539FF110000FF00D8F9FF75EEFCFF6BEBFAFF6BEB
      FAFF62E9F9FF62E9F9FF59E6F7FF59E6F7FF51E3F6FF51E3F6FF49E2F4FF49E2
      F4FF43DFF2FF43DFF2FF43DFF2FF00B1DEFFA23500FFD2A37BFFD2A37BFFCC9C
      73FF78D1EDFF5E67F4FF64C6F3FFC28A5CFFC58555FFBE8350FFBE7D4AFFB977
      44FFB5713BFFB5713BFFB66C36FF4D0000FF006B00FF7EBD5EFF7EBD5EFF74B7
      53FF74B753FF74B753FF69B346FF69B346FF64AE41FF61B03CFF5BAA35FF5BAA
      35FF54A62DFF54A62DFF54A62DFF003100FF510000FFB88570FFAC7159FFEBE1
      DEFFF0E9E7FFCBA99BFF9B583DFF995539FF975034FF944C2FFF8A4022FF9E5E
      44FFC6A495FF8A4022FF9B583DFF110000FFB76D00FFDEBF82FFD8B167FFD4AE
      61FFD3AB5DFFD2A958FFCFA654FFCEA452FFCCA14DFFCB9E48FFC99B42FFC696
      39FFC69639FFC69639FFCEA452FF851E00FFAA4902FFD8AA86FFD19268FFCA8D
      5DFF65CBEBFF4851F4FF4DBEF0FFB97744FFB66C36FFB66C36FFB96726FFAE61
      27FFAD5A1DFFAD5A1DFFB5713BFF4D0000FF007C00FF84C365FF69B346FF61B0
      3CFF61B03CFF5BAA35FF54A62DFF4CA522FF4CA522FF46A21AFF46A21AFF3F9F
      12FF3A9B0CFF3A9B0CFF54A62DFF003100FF640100FFBB8B75FFAC7159FFD0B2
      A5FFE2D0C9FFA26249FF9E5E44FF9D5B40FF995539FF975034FF944C2FFF8A40
      22FF8A4022FF8A4022FF9D5B40FF110000FF00D8F9FF75EEFCFF5BEAFBFF54E9
      FBFF54E9FBFF4AE6F9FF4AE6F9FF42E3F7FF3BE2F6FF3BE2F6FF33DFF4FF2ADC
      F2FF2ADCF2FF2ADCF2FF43DFF2FF00B1DEFFAA4902FFD8B291FFCC9C73FFCC9C
      73FF6AD2F0FF545AF6FF57C3F2FFBE7D4AFFB97744FFB97744FFB66C36FFB66C
      36FFAE6127FFAE6127FFB97744FF4D0000FF0000BBFF8C8BE3FF6B6ADAFF6767
      D9FF6061D5FF5F5DD7FF5B5AD3FF5656D1FF5051D0FF4B4BCDFF4847CEFF4443
      CBFF403ECAFF3B3BC7FF5656D1FF000093FF640100FFBB8B75FFAC7159FFAC71
      59FFAA6A4CFFA66952FFA26249FF9D5B40FF9D5B40FF995539FF975034FF944C
      2FFFC6A495FF944C2FFF9E5E44FF110000FFBC7B00FFE2C48CFFDAB771FFD8B4
      6CFFD8B167FFD4AE61FFD3AB5DFFD2A958FFCFA654FFCEA452FFCCA14DFFCB9E
      48FFC99B42FFC99B42FFCFA75AFF943100FF12B0F9FF95DBFCFF7AD2FBFF74CF
      F9FF6BCDF8FF545AF6FF5FBAF6FF57C3F2FF57C3F2FF4DBEF0FF48BBECFF3FB8
      EBFF33B1E9FF33B1E9FF48BBECFF0058CBFF0000C2FF8C8BE3FF6F6FDCFF6B6A
      DAFF6866DBFF5F5DD7FFC1C1EEFFCECEF0FF7A7ADEFFB8B8EAFF7373DCFF4847
      CEFF4443CBFF403ECAFF5B5AD3FF000093FF74446AFFB28F97FFB27C67FF9D75
      8BFF9D758BFFAA6A4CFFB88570FFB28F97FF9E5E44FFD0B2A5FFAC7159FF944C
      2FFFA26249FFC29D8FFF9F6148FF310000FFBF8105FFE2C48CFFDBBA75FFDAB7
      71FFD8B46CFFD7B369FFD5B065FFD4AE61FFD1AA5CFFD0A857FFCEA452FFCCA1
      4DFFCB9E48FFC99B42FFD1AA5CFF963900FF0B17FDFF8F94FDFF737AFCFF6E74
      FBFF6466FAFF6466FAFF545AF6FF545AF6FF4851F4FF4248F3FF3B42F1FF2B33
      EEFF2B33EEFF2B33EEFF4149EDFF0000DAFF0000C2FF8C8BE3FF7373DCFF6F6F
      DCFF6B6ADAFF8C8BE3FFE2E2F4FF6666D6FFCECEF0FFDBDAF3FFAAAAE4FF4B4B
      CDFF4847CEFF4443CBFF6061D5FF000093FFB7897EFFD1CCE8FFC2A2A1FF9689
      C9FF9689C9FFDBB99FFFBEB8DEFFAC90A4FFCBA99BFFDAC3BAFFDAC3BAFF9750
      34FFC29D8FFFD4BDB4FFD4BDB4FF310000FFC2860CFFE3C893FFE0BF7BFFDBBA
      75FFDAB771FFD8B46CFFD7B369FFD5B065FFD4AE61FFD3AB5DFFD0A857FFCEA4
      52FFCCA14DFFCB9E48FFD4AE61FF963900FF27BEF4FF9DE1FCFF86DAF8FF86DA
      F8FF7AD2FBFF6466FAFF6EC4F9FF6BCDF8FF64C6F3FF57C3F2FF57C3F2FF4DBE
      F0FF48BBECFF3FB8EBFF59C1EDFF006CD6FF0000C2FF8C8BE3FF7676DFFF7373
      DCFF6F6FDCFF6767D9FFC1C1EEFFDBDAF3FF9897E5FFB8B8EAFF7A7ADEFF5051
      D0FF4B4BCDFF4847CEFF6061D5FF000093FF472A8FFFBEB9E8FFA4A6F1FF7E7D
      E4FF7E7DE4FFA4A6F1FF908DE1FF9882B3FFA66952FFCBA99BFFA26249FF9B58
      3DFF975034FFD3B6ACFFB3816CFF310000FFC48A0EFFDDC49EFF6D6DE2FFDBBB
      7CFFDBBA75FFDAB771FFD8B56FFFD7B369FFD5B065FFD4AE61FFD3AB5DFFD0A8
      57FFCEA452FFCCA14DFFD3AF67FF9A4900FFB96726FFE2BC9EFFD8AA86FFD8AA
      86FF86DAF8FF6E74FBFF74CFF9FFCC9C73FFCA9466FFC58F61FFC28A5CFFBE83
      50FFBE7D4AFFB97744FFC28A5CFF6B0000FF0000C2FF9897E5FF7A7ADEFF7A7A
      DEFF7676DFFF7373DCFF6F6FDCFF6B6ADAFF6666D6FF6061D5FF5B5AD3FF5656
      D1FF5051D0FF5051D0FF6666D6FF000093FF0808CDFF908DE1FF7E7DE4FF6768
      E3FF6768E3FF6E70E7FF6F6EE0FF6965D6FFAC7159FFAA6A4CFFA26249FFB27C
      67FFD3B6ACFF975034FFA66952FF310000FFC9911AFF8989E8FF6D6DE2FF6D6D
      E2FFE0BF7BFFDBBA75FFDAB771FFD8B56FFFD7B369FFD5B065FFD4AE61FFD3AB
      5DFFD2A958FFCFA654FFD7B369FF9A4900FFBD611EFFE2BC9EFFD8AA86FFD8AA
      86FF86DAF8FF737AFCFF7AD2FBFFCC9C73FFD19268FFCA9466FFCA8D5DFFC585
      55FFC3814EFFBE7D4AFFCA8D5DFF6B0000FFC58A00FFE8CD7AFFE3C15DFFE3C1
      5DFFE1BE56FFE1BE56FFDBB955FFDAB548FFDAB548FFDAB548FFD7AE33FFD7AE
      33FFD7AE33FFD7AE33FFDAB548FFA85700FF8D4C4AFFC9C6EAFFE6DDE5FFB3AC
      DDFFAAA4DCFFCCC3DDFFDCD8EDFFD3B6ACFFBB8B75FFB88570FFB27C67FFDFCB
      C4FFE2D0C9FFD0B2A5FFAC7159FF310000FFC48A0EFFDDC49EFF8989E8FFE3C8
      93FFE3C893FFE3C893FFE2C48CFFE2C48CFFDEC186FFDEC186FFDEBF82FFDBBB
      7CFFDBBA75FFDAB771FFD8B56FFF9A4900FFB96726FFE2BC9EFFE2BC9EFFE2BC
      9EFFA2E2F7FF8F94FDFF95DBFCFFD8B291FFD8AA86FFD8AA86FFD2A37BFFD2A3
      7BFFCC9C73FFCA9466FFCA9466FF6B0000FFC58A00FFE4CA79FFE4CA79FFE4CA
      79FFE3C876FFE2C671FFE2C671FFE0C36CFFDEC166FFDEC166FFDDBE60FFDBB9
      55FFDBB955FFDBB955FFDAB548FF9D4C00FF8376C7FFA77E87FF8E2C00FF472A
      8FFF472A8FFF8E2C00FF683C74FF8770B7FF640100FF640100FF640100FF5100
      00FF9F6148FF510000FF310000FF310000FFC79120FFC58A12FFC9911AFFC58A
      12FFC2860CFFC2860CFFBF8105FFBC7B00FFBC7B00FFB57200FFB57200FFB76D
      00FFAF6200FFAF6200FFAA5600FFAF6200FFB96726FFBD611EFFBD611EFFBD61
      1EFF27BEF4FF0B17FDFF12B0F9FFAA4902FFAA4902FFA23500FFA23500FF9723
      00FF972300FF8B0C00FF8B0C00FF8B0C00FFC58A00FFC58A00FFC58A00FFC58A
      00FFC58A00FFBE8000FFBE8000FFBE8000FFB87600FFB87600FFB26E00FFB26E
      00FFAC6300FFAC6300FFA85700FFAC6300FFF3772BFFED6816FFED6816FFE658
      03FFE65803FFDF4500FFDF4500FFDF4500FFD32C00FFD32C00FFD32C00FFC813
      00FFC81300FFC81300FFC81300FFC81300FFF8B735FFF3AF20FFF0AA18FFEFA7
      12FFEDA30AFFEB9B00FFEB9B00FFEB9B00FFE69200FFE69200FFE08C00FFE08C
      00FFDE8400FFDE8400FFDE8400FFE08C00FFF90000FFF90000FFF90000FFEC00
      00FFEC0000FFEC0000FFEC0000FFEC0000FFE10000FFE10000FFE10000FFE100
      00FF9F0000FF000002FF01007BFF00009BFF0000F3FF0000F3FF0000F3FF0000
      ECFF0000ECFF0000ECFF0000ECFF0000ECFF0000E6FF0000E6FF0000E6FF0000
      E0FF0000E0FF0000DDFF0000DDFF0000DDFFF3772BFFF9C4A3FFF9C4A3FFF7BF
      9DFFF5B995FFF5B995FFF2B28DFFF2B28DFFF0AE84FFEEA87DFFEEA87DFFEBA3
      76FFEBA376FFE99E6FFFE99E6FFFC81300FFF7B329FFFBDD9FFFFADB9CFFF9DA
      99FFF8D794FFF8D794FFF7D590FFF7D38BFFF7D38BFFF5D086FFF4CE83FFF4CE
      83FFF4CB7BFFF4CB7BFFF4CB7BFFDE8400FFF90000FFFD8787FFFD8787FFFD77
      77FFFD7777FFFA6667FFFA6667FFFA6667FFF65354FFF65354FFB052A0FF7259
      D0FF505CE0FF6A72E6FFAEB6F1FF9EA0A0FF0000F9FF6060FBFF5C5CFAFF5757
      F9FF5453F9FF5151F8FF4A4AF7FF4343F7FF4343F7FF3A3AF5FF3A3AF5FF3232
      F4FF3232F4FF2D2DF2FF2D2DF2FF0000DDFFD3D9F7FFEBEEFAFFE6E8FAFFE2E4
      F4FFE2E4F4FFDBE1F2FFDBE1F2FFDBE1F2FFDBE1F2FFD3D6EBFFD3D6EBFFD3D6
      EBFFCDD1E8FFCCCFE6FFD3D6EBFF919BC7FFF7B329FFFCDD9EFFFAD385FFFAD3
      85FFF9D080FFF8CE7BFFF5CA74FFF5CA74FFF5CA74FFF3C568FFF3C568FFF3C5
      68FFF1C060FFF1C060FFF5CA74FFDE8400FFF90000FFFB9698FFF65354FFF653
      54FFF65354FFF34042FFF34042FFB31C6BFF643FB9FF3B44D7FF414DDBFF7C8C
      E8FFC8E5E8FFC8E5E8FFC2E8F0FF9EA0A0FF0000F9FF6565FCFF4343FAFF3C3B
      F9FF3C3BF9FF3434FAFF2C2CF7FF2828F6FF2222F5FF1B1BF4FF1B1BF4FF0E0E
      F1FF0E0EF1FF0E0EF1FF2D2DF2FF0000E0FF0202FAFF8989FCFF6969FBFF5C5C
      F8FF5C5CF8FF4DAEF5FF467BF4FF4586F3FF398AF1FF3174EFFF34AAF0FF2323
      EBFF1A1AE9FF1A1AE9FF3838EBFF0000D2FFE7DABFFFFCF6E9FFFCF4E3FFFBF2
      E1FFF9F1DFFFF9F1DFFFF8EFDDFFF7EDDCFFF6ECD9FFF6ECD9FFF3E9D5FFF3E9
      D5FFF3E9D5FFF3E9D5FFF3E9D5FFCEBD96FFF90000FFFB9698FFFA6667FFF653
      54FFCC5476FF8656BBFF5E5FDEFF505CE0FF7C8CE8FFCAD6EFFFF4F5F6FF65D3
      E9FF4DCDEAFF4DCDEAFF86DCEEFF9EA0A0FF2E2EFBFFA2A2FDFF8A8AFBFF8A8A
      FBFF8585FBFF8080F9FF7C7CF9FF7978F6FF7575F7FF7171F6FF6D6DF5FF6868
      F2FF6464F2FF6464F2FF7978F6FF0000E0FF0202FAFF8989FCFF6969FBFF6969
      FBFF5C5CF8FF558DF7FF53BDF7FF46B8F4FF46B8F4FF34AAF0FF3174EFFF2B2D
      EEFF2323EBFF1A1AE9FF3838EBFF0000D2FFE9E9E9FFFEFEFEFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFB2F1F9FF5DE3F6FF5DE3F6FFB2F1F9FFF5F5F5FFF4F4
      F4FFF3F3F3FFF3F3F3FFF4F4F4FFD3D3D3FFEC0000FFE9869AFFB26EAEFF7B80
      E8FF6A72E6FF7C8CE8FFC5CCF6FFF4F5F6FFF9F9F9FFF4F5F6FFAFE4F0FF86DC
      EEFFC8E5E8FF7BA2C1FFD3DAE3FF9EA0A0FFE9E9E9FFFDFDFDFFFCFCFCFFFCFC
      FCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF5F5F4FFF0F0
      F0FFEEEEEEFFE9E9E9FFF5F5F4FFDFDFDFFF0202FAFF9494FEFF7676FDFF6969
      FBFF6AC8FBFF60B5F9FF5B99F8FF53BDF7FF4586F3FF4291F3FF34AAF0FF34AA
      F0FF2B2DEEFF2323EBFF4545EEFF0000D2FFE9E9E9FFFEFEFEFFFEFEFEFFFCFC
      FCFFFCFCFCFFFBFBFBFF74EBFAFF48E3F6FF48E3F6FF68E6F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F5FFD3D3D3FFB31C6BFF9494EAFF7B80E8FFA0A7
      F2FFF0F1FAFFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FF86DCEEFFF4F5F6FFC8E5
      E8FFE2E0E4FF3F63A0FF7BA2C1FF9EA0A0FFE9E9E9FFFEFEFEFFFDFDFDFFFCFC
      FCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF6F6F6FFF0F0
      F0FFF0F0F0FFE9E9E9FFF5F5F4FFE2E2E2FF1515FDFF9494FEFF7676FDFF7676
      FDFF6969FBFF6791FAFF60B5F9FF53BDF7FF53BDF7FF4DAEF5FF467BF4FF3837
      F1FF3837F1FF2B2DEEFF4545EEFF0000D2FFE9E9E9FFFEFEFEFFFEFEFEFFFEFE
      FEFFFCFCFCFFFCFCFCFFB2F1F9FF68E6F7FF68E6F7FFB2F1F9FFF6F6F6FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD3D3D3FFFF1010FFFDA6A8FFA881C8FF7B80
      E8FF7B80E8FFA0A7F2FFDCE4F9FFF9F9F9FFF9F9F9FFF9F9F9FF96AFCCFF547E
      B3FF7394B9FF2D4E93FF7BA2C1FF8C8A88FFE9E9E9FFFEFEFEFFFEFEFEFFFDFD
      FDFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFFF8F8F8FFF8F8F8FFF0F0
      F0FFF0F0F0FFE9E9E9FFF5F5F4FFE2E2E2FF1515FDFF9494FEFF7676FDFF7676
      FDFF7676FDFF6AC8FBFF6791FAFF5B99F8FF5B99F8FF558DF7FF46B8F4FF4344
      F3FF3837F1FF3837F1FF4E4FF1FF0000D2FFEBDCC2FFFEF8EBFFFEF6E5FFFEF6
      E5FFFEF6E5FFFCF4E3FFFCF4E3FFFBF2E1FFF9F1DFFFF9F1DFFFF8EFDDFFF7ED
      DCFFF6ECD9FFF6ECD9FFF7EDDCFFD5C29FFFFF1010FFFDA6A8FFFD7777FFFD77
      77FFCF7195FF7C6BD4FF7B80E8FF7B80E8FFA0A7F2FFE9F1F8FFF9F9F9FF96AF
      CCFF547EB3FF2D4E93FF7BA2C1FF9EA0A0FF3434FAFFA2A2FDFF9190FEFF8F8F
      FEFF8A8AFDFF8A8AFDFF8585FBFF8080F9FF7C7CF9FF7978F6FF7575F7FF7171
      F6FF6D6DF5FF6868F2FF8080F9FF0000E6FFE6E8FAFFF2F3FEFFF2F3FEFFF2F3
      FEFFEFF0FDFFEFF0FDFFEBEEFAFFEBEEFAFFEBEEFAFFE6E8FAFFE6E8FAFFE2E4
      F4FFE2E4F4FFDBE1F2FFE2E4F4FFB5BBDDFFFEBF42FFFEE2AAFFFEDC98FFFEDC
      98FFFEDC98FFFCD993FFFCD993FFFCD68CFFFCD68CFFFAD385FFFAD385FFF9D0
      80FFF8CE7BFFF5CA74FFF7D38BFFEB9B00FFFF1010FFFDA6A8FFFD7777FFFD77
      77FFFD7777FFFA6667FFFA6667FFB26EAEFF7C6BD4FF6A72E6FF7B80E8FFAEB6
      F1FFCAD6EFFF96AFCCFF7394B9FF4E617AFF0000FFFF797AFFFF5D5DFEFF5D5D
      FEFF5858FEFF5353FDFF5050FDFF4B4BFCFF4343FAFF4343FAFF3C3BF9FF3434
      FAFF3232F4FF2C2CF7FF4A4AF7FF0000ECFFFF9D60FFFFD5BCFFFFD5BCFFFFD5
      BCFFFFD5BCFFFDD1B5FFFDD1B5FFFCCCAEFFFCCCAEFFFBC7A8FFF9C4A3FFF7BF
      9DFFF7BF9DFFF5B995FFF5B995FFDF4500FFFFC34BFFFFE4AFFFFFE4AFFFFFE4
      AFFFFFE4AFFFFEE2AAFFFEE2AAFFFEE2AAFFFCDEA3FFFBDD9FFFFCDD9EFFFADB
      9CFFF9DA99FFF8D794FFF8D794FFEB9B00FFFF1010FFFDA6A8FFFDA6A8FFFDA6
      A8FFFDA6A8FFFDA6A8FFFB9698FFFB9698FFFB9698FFFB9698FFA881C8FF9494
      EAFF9494EAFFA0A7F2FFC5CCF6FF818CA2FF0000FFFF797AFFFF797AFFFF797A
      FFFF7575FEFF7575FEFF706FFDFF6A6AFDFF6A6AFDFF6565FCFF6060FBFF5C5C
      FAFF5757F9FF5151F8FF4A4AF7FF0000ECFFFF9D60FFFF9D60FFFF9D60FFFF9D
      60FFFF9D60FFFC9453FFFC9453FFF98A45FFF98A45FFF5813AFFF3772BFFF377
      2BFFED6816FFED6816FFE65803FFE65803FFFFC758FFFFC34BFFFFC34BFFFFC3
      4BFFFFC34BFFFEBF42FFFEBF42FFFEBF42FFF8B735FFF8B735FFF7B329FFF7B3
      29FFF3AF20FFF0AA18FFEFA712FFF0AA18FFFF2020FFFF1010FFFF1010FFFF10
      10FFFF1010FFFD0202FFF90000FFF90000FFF90000FFF90000FFF90000FFF900
      00FF9F0000FF01007BFF0000BEFF0000BEFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF0000FDFF0000FDFF0000FDFF0000F9FF0000F9FF0000F9FF0000
      F3FF0000F3FF0000F3FF0000ECFF0000ECFF8A1100FF8A1100FF720000FF7200
      00FF720000FF720000FF530000FF530000FF530000FF530000FF530000FF3A00
      00FF3A0000FF3A0000FF3A0000FF3A0000FF0000C4FF0000C4FF0000C4FF0000
      C4FF0000B7FF0000B7FF0000B7FF0000B7FF0000AAFF0000AAFF0000AAFF0000
      AAFF0000AAFF00009CFF00009CFF00009CFF0088F2FF0088F2FF0077EDFF0077
      EDFF0077EDFF0067E5FF0067E5FF0067E5FF0067E5FF0059DDFF0059DDFF0054
      D8FF0051DAFF0051DAFF0049D7FF0054D8FFE7E7E8FFE5E5E5FFE3E3E3FFE1E1
      E1FFDFDFDFFFDDDDDDFF0000D7FF0000D7FF0000D7FF0000D7FFCDCDD1FFCECE
      CFFFCECECFFFCBCBCBFFCBCBCBFFCBCBCBFF992200FFD7AC73FFD7AC73FFD4A9
      6FFFD4A669FFD1A362FFD1A362FFD0A05CFFCF9E59FFCE9C57FFCD9952FFCB95
      4FFFCA944BFFC99146FFC79146FF3A0000FF0000CDFF727BEAFF6E77EAFF6973
      E6FF626DE7FF5E69E4FF5864E2FF535FE3FF505BE2FF4C58E0FF4754DDFF434F
      DCFF3E4BDCFF3B48D9FF3745DAFF00009CFF0088F2FF81C9FAFF81C9FAFF7AC5
      F8FF74C2F7FF74C2F7FF6CBEF6FF6CBEF6FF63B9F2FF63B9F2FF63B9F2FF5CB4
      F2FF5CB4F2FF55B2EFFF55B2EFFF0049D7FFEAEAEAFFFBFBFBFFFAFAFAFFF9F9
      F9FFF9F9F9FFF8F8F8FF4A4AF7FF4343F7FF4343F7FF3E3EF9FFF2F2F4FFF3F3
      F3FFF3F2F2FFF2F2F2FFF2F2F2FFCBCBCBFF992200FFD9B07BFFCF9E59FFCE9C
      57FFCD9952FFCA944BFFC99146FFC68A46FFC7893DFFC48539FFC37E33FFC683
      31FFC68331FFB96D2AFFC99146FF3A0000FF0000CDFF7A84EBFF5864E2FF535F
      E3FF4C58E0FF4451E2FF4451E2FF32376BFF32376BFF303EDBFF2A38D8FF2433
      D6FF1D2CD5FF1D2CD5FF3B48D9FF00009CFF0096F6FF88D0FBFF6BC5F9FF66C3
      F8FF61C0F7FF5DBEF6FF58BBF5FF54B9F4FF4FB7F3FF4AB4F1FF47B2F0FF42B0
      F0FF3DADEFFF3DADEFFF59B9F0FF0059DDFFEAEAEAFFFDFDFDFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FF2F2FF7FF2929F6FF2323F5FF1D1DF4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF1F1F1FFF2F2F2FFCBCBCBFF992200FFD9B07BFFD0A05CFFCF9E
      59FFCE9C57FFCD9952FFCA944BFFC99146FFC99146FFC7893DFFC7893DFFE5B5
      4EFFE5B54EFFC4802CFFCA944BFF3A0000FF0000CDFF7A84EBFF5E69E4FF5864
      E2FF535FE3FF47495CFF4651D3FF2F3038FF2F3038FF3441CCFF2F3038FF2A38
      D8FF2433D6FF1D2CD5FF3E4BDCFF00009CFF0096F6FF88D0FBFF6BC5F9FF6BC5
      F9FF66C3F8FF61C0F7FF5DBEF6FF58BBF5FF54B9F4FF4FB7F3FF4AB4F1FF47B2
      F0FF42B0F0FF3DADEFFF59B9F0FF0054D8FFEFEEEEFFFDFDFDFFFBFBFBFFFBFB
      FBFFFAFAFAFFF9F9F9FF2F2FF7FF2F2FF7FF2929F6FF2323F5FFF5F5F5FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFCECECFFFA22D00FFDBB381FFD1A362FFD0A0
      5CFFCF9E59FFCE9C57FFCD9952FFCA944BFFC99146FFC7893DFFE6BD63FFE6BD
      63FFE6BD63FFE5B54EFFCB954FFF3A0000FF0000D5FF838CEDFF626DE7FF626D
      E7FF5864E2FF525CD3FF474A80FF3C3C43FF3C3C43FF32376BFF3441CCFF2F3C
      CFFF2A38D8FF2433D6FF434FDCFF0000AAFF9C0808FFD18F8FFFC67272FFC36B
      6CFFC36B6CFFBF6565FFBC6060FFBA5C5CFFB75757FFB45150FFB45150FFB14A
      4AFFAE4444FFAE4444FFBA5C5CFF5D0000FF750000FFC57171FFB64E4EFFB348
      48FFB14443FFAB3F3FFFCE8A88FFE9D0CFFFE7CDCDFFCE8A88FF9D2020FF9D20
      20FF991717FF991717FFA63535FF2B0000FFB06158FFCEA888FFC48539FF9C82
      AFFF9C82AFFFB96D2AFFC79555FFBD9B91FFCB954FFFC99146FFA7E6F6FFF7F8
      FEFF74DCF9FFA7E6F6FFCD9952FF530000FF0000D5FF838CEDFF6973E6FF656F
      ECFF5B62B3FF565878FF515BC4FF454545FF3C3C43FF3F49B7FF32376BFF3038
      95FF303EDBFF2A38D8FF4754DDFF0000AAFF9C0808FFD18F8FFFC87877FFC672
      72FFC36B6CFFC36B6CFFBF6565FFBC6060FFBA5C5CFFB75757FFB45150FFB451
      50FFB14A4AFFAE4444FFBC6060FF5D0000FF750000FFC57171FFB95353FFB64E
      4EFFB34848FFEDD7D7FFB14443FFAB3A3AFFAB3534FFAB3534FFDDB6B6FFA226
      26FF9D2020FF991717FFAB3A3AFF2B0000FFB95703FFEEEBFBFFD2B19EFFA194
      DFFF9D93E5FFEDCA9BFFBCB3F6FFB88659FFCD9952FFCA944BFFA7E6F6FF74DC
      F9FFF7F8FEFF96E2F7FFCE9C57FF530000FF0000D5FF8B93EEFF6E77EAFF6974
      EBFF5E628FFF565878FF515253FF454545FF454545FF3C3C43FF3C3C43FF3237
      6BFF3745DAFF313FD9FF4C58E0FF0000AAFF9C0808FFD18F8FFFC87877FFC878
      77FFC67272FFC36B6CFFC36B6CFFBF6565FFBC6060FFBA5C5CFFB75757FFB757
      57FFB45150FFB14A4AFFBC6464FF5D0000FF750000FFC57171FFBA5757FFB953
      53FFB64E4EFFB74F4FFFB34848FFE2BBBAFFE2BBBAFFAB3534FFAB3534FFA226
      26FFA22626FF9D2020FFAB3F3FFF2B0000FFB06158FFDCCAD4FFC1BCFAFF9692
      FDFF9692FDFFB0ADFFFFAAA0EAFFAA90B0FFCF9E59FFCD9952FFF9F4EFFFEEEB
      FBFFEEEBFBFFF9F4EFFFCF9E59FF530000FF0007D4FF8B93EEFF727BEAFF6E77
      EAFF656CBFFF5A5A5EFF515253FF515253FF47495CFF454545FF3C3C43FF4047
      ABFF3E4BDCFF3745DAFF535FE3FF0000AAFF0303F9FF9696FDFF7D7DFCFF7B7A
      FBFF7878FAFF7272FBFF7272FBFF6C6CF7FF6767F8FF6162F7FF6162F7FF5757
      F5FF5757F5FF5757F5FF6767F8FF0000E8FFF1F1F1FFFEFEFEFFFEFEFEFFFEFE
      FEFFFDFDFDFFFDFDFDFF4B4BFCFF4646FBFF3E3EF9FF3E3EF9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD7D7D7FF6C53D2FFAEAAFFFF9692FDFF8A86
      FFFF8A86FFFF8A86FFFF9088F8FF8881EFFFCFA065FFCE9C57FFD4A669FFD9B0
      7BFFD7AC73FFD0A05CFFD1A362FF530000FF0008D7FF8F97F0FF747EEEFF747E
      EEFF686B90FF6973E6FF656CBFFF5A5A5EFF51515AFF525AB3FF505BE2FF4246
      6FFF4451E2FF3E4BDCFF5864E2FF0000B7FF1414FBFF9696FDFF8282FAFF7D7D
      FCFF7B7AFBFF7878FAFF7272FBFF7272FBFF6C6CF7FF6767F8FF6162F7FF6162
      F7FF5757F5FF5757F5FF6C6CF7FF0000E8FFF1F1F1FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFDFDFDFF5050FDFF4B4BFCFF4646FBFF4343F7FFF9F9F9FFF8F8
      F8FFF7F7F7FFF6F6F6FFF7F7F7FFD9D9D9FFB96D2AFFE5DCF9FFEECFABFFC1BC
      FAFFBCB3F6FFEECFABFFCAC5FFFFEDCA9BFFD9B07BFFD9B07BFFD7AC73FFD4A9
      6FFFD4A669FFD4A669FFD1A362FF720000FF0008D7FF8F97F0FF8F97F0FF8B93
      EEFF8B93EEFF878FF1FF7B7D8DFF7C86E2FF7C86E2FF6E6F80FF727BEAFF6E77
      EAFF6973E6FF626DE7FF5E69E4FF0000B7FF1212FBFF9696FDFF9696FDFF9696
      FDFF9696FDFF9090FCFF9090FCFF8A8AFCFF8A8AFCFF8282FAFF8282FAFF7D7D
      F8FF7878FAFF7474F7FF7474F7FF0000E8FFF1F1F1FFFFFFFFFFFFFFFFFFFEFE
      FEFFFEFEFEFFFEFEFEFF706FFDFF706FFDFF6868FCFF6868FCFFFAFAFAFFFAFA
      FAFFF9F9F9FFF8F8F8FFF7F7F7FFDDDDDDFFB06158FFB95703FFB95703FF8157
      ADFF8157ADFFB95703FFC68A46FF896BC9FF992200FF992200FF8A1100FF8A11
      00FF8A1100FF720000FF720000FF720000FF0007D4FF0008D7FF0008D7FF0008
      D7FF0002DBFF0000D5FF0002DBFF0000D5FF0000D5FF0000D5FF0000CDFF0000
      CDFF0000C4FF0000C4FF0000C4FF0000B7FF2424FBFF1414FBFF1414FBFF1414
      FBFF1212FBFF0C0CF9FF0808F7FF0303F9FF0000F3FF0000F3FF0000F3FF0000
      F3FF0000F3FF0000F3FF0000E8FF0000E8FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
      F1FFF1F1F1FFEFEEEEFF0000EDFF0000EDFF0000EDFF0000EDFFE7E7E8FFE7E7
      E8FFE5E5E5FFE3E3E3FFE1E1E1FFDFDFDFFFC55038FFB12309FFB12309FFB123
      09FFB12309FF00DEDEFF00DEDEFF00DEDEFF00D3D3FF00D3D3FF00D3D3FF0000
      C9FF0000C9FF0000C9FF0000C9FF0000C9FF0000F4FF0000F4FF0000F4FF0000
      EEFF0000EEFF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF0000E0FF0000E0FF0000E0FF0000D5FF0000D5FF0000D5FF0000
      00FF002900FF002900FF061307FF002900FF0000D9FF0000C9FF0000C9FF0000
      C9FF0000C9FF0000C9FF0000B8FF0000B8FF0000B8FF0000B8FF0000B8FF0000
      B1FF0000B1FF0000ADFF0000ADFF0000B1FFBE472CFFE3AB9FFFE2A79AFFDDA1
      94FFDC988AFF5CF6F6FF5CF6F6FF4FF5F5FF47F2F2FF42EEEEFF42EEEEFF3738
      EDFF3534EDFF2D2EEBFF2D2EEBFF0000C9FF0000F4FF5F5EFBFF5F5EFBFF5757
      F9FF5353FCFF4F4F4FFF4A4A4AFF434343FF434343FF3A3A3AFF3A3A3AFF3333
      33FF333333FF2D2D2DFF2D2D2DFF000000FF000000FF7A7A7AFF727272FF6C6C
      6CFF646464FF5C5CF6FF5858F5FF5151F4FF4949F3FF4242EEFF4242EEFF4371
      A4FF34A334FF2DA02DFF2DA02DFF061307FF0000D9FF7578EBFF6B70EAFF6B70
      EAFF6368E9FF6368E9FF625FD5FFEDEDF5FFEDEDF5FF625FD5FF4D53E2FF4A4F
      DEFF4449DDFF4449DDFF4449DDFF0000ADFFC55038FFE5AFA3FFDC988AFFDC98
      8AFFDA8D7CFF47F2F2FF3DF2F2FF52BAC9FF52BAC9FF27EDEDFF27EDEDFF1717
      E9FF1717E9FF1717E9FF2D2EEBFF0000C9FF0000FAFF6969FCFF4444FBFF3C3C
      FAFF3C3CFAFF333333FF2D2D2DFF282828FF202020FF202020FF151515FF1515
      15FF0C0C0CFF0C0C0CFF2D2D2DFF000000FF000000FF7A7A7AFF5C5C5CFF5353
      53FF535353FF4949F3FF4141F3FF3A3AF1FF3131EFFF2727EDFF2727EDFF265A
      95FF169516FF169516FF2DA02DFF002900FF0000D9FF7578EBFF555AE6FF555A
      E6FF4D53E2FF4D53E2FFCACAEFFFF6F6F6FFF6F6F6FFCACAEFFF2323CAFF2C33
      DAFF262DD8FF262DD8FF4449DDFF0000ADFFC75A40FFE6B4A8FFDF9F91FFDC98
      8AFFDC988AFF4FF5F5FF79A5BAFF6A99B1FF6A99B1FF6A99B1FF27EDEDFF2323
      EBFF1717E9FF1717E9FF3534EDFF0000C9FF0000FAFF6969FCFF4849FBFF4444
      FBFF3C3CFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
      F3FFF2F2F2FFF2F2F2FFF3F3F3FFCFCFCFFF000000FF848483FF646464FF5C5C
      5CFF535353FF5151F4FF6869F3FF7D80E8FF797AE7FF504EEDFF2727EDFF265A
      95FF169516FF169516FF34A334FF002900FF0000D9FF7B81EDFF5D62EAFF555A
      E6FF555AE6FF9FA0E9FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FF9999E3FF3239
      DFFF2C33DAFF262DD8FF4449DDFF0000B1FFCB6048FFE6B4A8FFE1A496FFDF9F
      91FFDC988AFF6ECFDAFF79A5BAFF4B61F1FF51D0E5FF6A99B1FF4CC0CCFF2D2E
      EBFF2323EBFF1717E9FF3738EDFF0000C9FF0000FDFF7271FEFF4E4EFCFF4849
      FBFF4444FBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4
      F4FFF3F3F3FFF2F2F2FFF4F4F4FFD1D1D1FF000000FF8C8C8CFF6C6C6CFF6565
      65FF5C5C5CFF5858F5FFAFB2F4FFC9C9F1FFC7C8EEFFA1A0EEFF3131EFFF3566
      9EFF249D23FF169516FF3AA53AFF002900FF0000D9FF7B81EDFF6368E9FF5D62
      EAFF715CADFFDEAC77FFD9A871FFD9A369FFD9A369FFD89D65FFDF9C5CFF3F32
      87FF3239DFFF2C33DAFF4A4FDEFF0000B1FFCF6650FFEABBB0FFE2A79AFFE1A4
      96FFDF9F91FF5CF6F6FF78AFD4FF60D3E9FF4B61F1FF61A2CAFF3DF2F2FF3534
      EDFF2D2EEBFF2323EBFF4141EDFF0000D8FF0000FDFF7271FEFF5252FDFF4E4E
      FCFF4A49FCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
      F5FFF4F4F4FFF3F3F3FFF5F5F4FFD1D1D1FF061307FF8C8C8CFF727272FF6C6C
      6CFF656565FF6060F9FFD2D3F7FFB7B9EEFFAFB2F4FFC9C9F1FF3A3AF1FF3566
      9EFF2DA02DFF249D23FF44AC44FF002900FF0000D9FF8387EFFF6368E9FF625F
      D5FFD89D65FFDF9C5CFFDC8F50FFDC8F50FFDC8F50FFD98944FFD98944FFCC84
      45FF3A2CB7FF3239DFFF4D53E2FF0000B8FFD46B56FFEABBB0FFE3AB9FFFE2A7
      9AFFE1A496FF6CFBFBFF79A9E0FF6A6EF6FF60D3E9FF69A4D1FF47F2F2FF3B3D
      F1FF3534EDFF2D2EEBFF4747F3FF0000D8FF0000FDFF7676FEFF5858FEFF5353
      FCFF4F4EFDFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF4F4F4FFF5F5F5FFD6D6D6FF061307FF949494FF7A7A7AFF7272
      72FF6C6C6CFF6B6BFAFFCACAF9FF8585F4FF7575F7FFC4C4F6FF4141F3FF4371
      A4FF34A334FF2DA02DFF4EB04FFF002900FF0000D9FF8387EFFF6B70EAFFDDAF
      83FFDEAC77FF80BFC1FFDEAC77FFD9A871FFD9A871FFD9A369FF6AB3B5FFD298
      5CFFCB915DFF3239DFFF555AE6FF0000B8FFD4715DFFECBFB6FFE5AFA3FFE3AB
      9FFFE2A79AFF6CFBFBFF88B6D0FF88B6D0FF78AFD4FF7BAEC2FF4FF5F5FF4747
      F3FF3B3DF1FF3534EDFF4C55F3FF0000D8FF0000FFFF7878FEFF5C5CFEFF5858
      FEFF5353FCFFFCFCFCFFFCFCFCFFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7
      F7FFF6F6F6FFF5F5F5FFF6F6F6FFD6D6D6FF1A1A1AFF949494FF7A7A7AFF7A7A
      7AFF727272FF6B6BFAFF6B6BFAFFCACAF9FFC4C4F6FF8585F4FF4949F3FF4371
      A4FF3CAA3CFF34A334FF4EB04FFF004B00FF0000D9FF7578EBFF5252AAFF5758
      58FF575858FF507E8CFF49C8E7FF44DFFBFF44DFFBFF3BC8EAFF356E7EFF2F31
      32FF2F3132FF3F3287FF3239DFFF0000B8FFD4715DFFECBFB6FFE6B4A8FFE5AF
      A3FFE8AA9EFF77FBFBFF6CFBFBFF6EF1F3FF68EEF1FF5CF6F6FF4FF5F5FF4747
      F3FF4747F3FF3B3DF1FF5959F3FF0000D8FF0000FFFF7A7AFFFF5F5EFBFF5C5C
      FEFF5858FEFF55BA55FF51B751FF4CB54CFF47B347FF3FB03FFF3FB03FFF36AB
      36FF2EA82EFF2EA82EFF47B347FF004600FF1A1A1AFF999999FF848483FF7A7A
      7AFF7A7A7AFF7575F7FF6B6BFAFF6B6BFAFF6060F9FF5C5CF6FF5151F4FF527C
      AEFF44AC44FF3CAA3CFF59B659FF004B00FF0000E5FF797ACEFF5F6164FF5758
      58FF575858FF53C1DBFF499BB0FF49C8E7FF49C8E7FF499BB0FF3CBFDFFF2F31
      32FF2F3132FF2F3132FF5252AAFF0000ADFFD4715DFFECBFB6FFECBFB6FFECBF
      B6FFEABBB0FF89FCFCFF89FCFCFF89FCFCFF89FCFCFF77FBFBFF77FBFBFF6A6E
      F6FF6A6EF6FF5959F3FF5959F3FF0000E6FF0000FFFF7A7AFFFF7A7AFFFF7878
      FEFF7676FEFF6EC46EFF6EC46EFF6EC46EFF64C064FF64C064FF5FBE60FF5BBB
      5BFF55BA55FF51B751FF4CB54CFF004600FF1A1A1AFF999999FF999999FF9999
      99FF949494FF8E8DFDFF8E8DFDFF8484FCFF8484FCFF7B7BFBFF7575F7FF7497
      BFFF66BD66FF66BD66FF59B659FF004B00FF0000B8FF7A7A8EFF777878FF7778
      78FF777878FF777878FF708084FF6ABACDFF6ABACDFF64767BFF5F6164FF5758
      58FF575858FF575858FF4D4D60FF000081FFD77A66FFD4715DFFD4715DFFD471
      5DFFD46B56FF00F9F9FF00F9F9FF00F9F9FF00F9F9FF00F9F9FF00F9F9FF0000
      F0FF0000F0FF0000E6FF0000E6FF0000E6FF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FDFF007A00FF007A00FF007300FF007300FF006700FF006700FF0067
      00FF005700FF005700FF005700FF004600FF1A1A1AFF1A1A1AFF1A1A1AFF1A1A
      1AFF1A1A1AFF0000F9FF0000F9FF0000F9FF0000F9FF0000F9FF0000F9FF0014
      6EFF006B00FF006B00FF006B00FF006B00FF000038FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF424D3E000000000000003E000000
      2800000040000000940200000100010000000000A01400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageListDebug: TImageList
    ColorDepth = cd32Bit
    Left = 404
    Top = 243
    Bitmap = {
      494C010104000900040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008DB471FF4D850DFF639630FF8DB471FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002918C8FF2918C8FF2918C8FF2918C8FF2918C8FF2918C8FF2918
      C8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001B7DA7FF1B7DA7FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A5125FF1A51
      25FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000659948FF659948FF91C698FF7DB381FF659948FF6599
      48FF000000000000000000000000000000000000000000000000000000000000
      0000000000002B1CC8FF8B93E7FF8B93E7FF8B93E7FF8B93E7FF8B93E7FF2B1C
      C8FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C81AAFF96DEFEFF96DEFEFF1D82AAFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001A5125FF72D086FF72D086FF72D086FF72D086FF72D086FF1A51
      25FF000000000000000000000000000000000000000000000000000000000000
      0000000000008DB471FF659948FF83BA86FF83BA86FF83BA86FF83BA86FF6599
      48FF8DB471FF0000000000000000000000000000000000000000000000000000
      0000000000003028C8FF8383EDFF5F5FE7FF605FE7FF605FE7FF8383EDFF2F28
      C8FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000001F87AEFF96DEFEFF96DEFEFF96DEFEFF96DEFEFF1E87
      AEFF000000000000000000000000000000000000000000000000000000000000
      000000000000277838FF57C76EFF4DC365FF4DC365FF4DC365FF57C76EFF2778
      38FF000000000000000000000000000000000000000000000000000000000000
      0000000000004D850DFF73AC69FF73AC69FF73AC69FF73AC69FF73AC69FF73AC
      69FF4D850DFF0000000000000000000000000000000000000000000000000000
      000000000000332FC8FF8075F5FF5B4CF1FF5B4CF2FF5B4CF1FF8075F5FF332F
      C8FF000000000000000000000000000000000000000000000000000000000000
      000000000000218DB2FF8CDBFEFF6BCFFEFF6BCFFEFF6BCFFEFF6BCFFEFF8CDB
      FEFF218DB3FF0000000000000000000000000000000000000000000000000000
      000000000000277838FF57C76EFF36A74EFF36A74EFF36A74EFF57C76EFF2778
      38FF000000000000000000000000000000000000000000000000000000000000
      0000000000004D850DFF83BA86FF83BA86FF83BA86FF83BA86FF83BA86FF83BA
      86FF4D850DFF0000000000000000000000000000000000000000000000000000
      000000000000393DC9FF8E92F6FF7B7BF5FF7B7BF5FF7B7BF5FF8E92F6FF393D
      C9FF000000000000000000000000000000000000000000000000000000000000
      0000000000002393B8FF98E6FFFF7CDEFFFF7CDEFFFF7CDEFFFF7CDEFFFF98E6
      FFFF2493B7FF0000000000000000000000000000000000000000000000000000
      0000000000002E8F43FF72D086FF57C76EFF57C76EFF57C76EFF72D086FF2E8F
      43FF000000000000000000000000000000000000000000000000000000000000
      0000000000008DB471FF71A44FFF99CFACFF99CFACFF99CFACFF99CFACFF71A4
      4FFF8DB471FF0000000000000000000000000000000000000000000000000000
      0000000000003B42C9FF8E92F6FF8E92F6FF8E92F6FF8E92F6FF8E92F6FF3B42
      C9FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000002698BBFF91EAFFFF91EAFFFF91EAFFFF91E9FFFF2699
      BBFF000000000000000000000000000000000000000000000000000000000000
      0000000000002E8F43FF72D086FF72D086FF72D086FF72D086FF72D086FF2E8F
      43FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000071A44FFF73AC69FF99CFACFF91C698FF73AC69FF71A4
      4FFF000000000000000000000000000000000000000000000000000000000000
      0000000000003D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46C9FF3D46
      C9FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000279CBEFFB0F2FFFFB0F2FFFF279CBEFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F43FF2E8F
      43FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008DB471FF4D850DFF639630FF8DB471FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000279CBEFF279CBEFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1FF80FFF3FF80FFC0FF80FFE1FF80F
      F807F80FFC0FF80FF807F80FF807F80FF807F80FF807F80FF807F80FFC0FF80F
      FC0FF80FFE1FF80FFE1FFFFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenuLineEnding: TSpTBXPopupMenu
    Left = 808
    Top = 520
    object SubmenuEnding: TSpTBXSubmenuItem
      Caption = 'Ending'
      object SpTBXItem1: TSpTBXItem
        Caption = 'Windows'
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
        OnClick = LineEndingItemClick
      end
      object SpTBXItem2: TSpTBXItem
        Tag = 1
        Caption = 'Linux'
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
        OnClick = LineEndingItemClick
      end
      object SpTBXItem3: TSpTBXItem
        Tag = 2
        Caption = 'Mac'
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
        OnClick = LineEndingItemClick
      end
    end
  end
  object PopupMenuEncoding: TSpTBXPopupMenu
    Left = 624
    Top = 512
    object SubmenuEncoding: TSpTBXSubmenuItem
      Caption = 'Encoding'
      object PopEncANSI: TSpTBXItem
        Caption = 'ANSI'
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
        OnClick = EncodingItemClick
      end
      object PopEncUTF8: TSpTBXItem
        Tag = 1
        Caption = 'UTF-8'
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
        OnClick = EncodingItemClick
      end
      object PopEncUCS2: TSpTBXItem
        Tag = 2
        Caption = 'UCS-2'
        AutoCheck = True
        GroupIndex = 1
        RadioItem = True
        OnClick = EncodingItemClick
      end
      object SpTBXSeparatorItem46: TSpTBXSeparatorItem
      end
      object PopEncWithBOM: TSpTBXItem
        Caption = 'With BOM'
        AutoCheck = True
        Enabled = False
        OnClick = PopEncWithBOMClick
      end
    end
  end
end
