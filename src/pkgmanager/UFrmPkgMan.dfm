object FrmPkgMan: TFrmPkgMan
  Left = 335
  Top = 293
  Caption = 'Falcon C++ Package Manager'
  ClientHeight = 562
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 185
    Top = 56
    Height = 487
    Visible = False
    ExplicitTop = 58
    ExplicitHeight = 465
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 543
    Width = 784
    Height = 19
    Panels = <>
  end
  object InfoPanel: TPanel
    Left = 0
    Top = 56
    Width = 185
    Height = 487
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    ExplicitTop = 58
    ExplicitHeight = 485
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 185
      Height = 487
      ActivePage = TsInfo
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 485
      object TsInfo: TTabSheet
        Caption = 'Information'
        OnResize = TsInfoResize
        ExplicitHeight = 457
        object PanelWsite: TPanel
          Left = 0
          Top = 110
          Width = 177
          Height = 35
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 8
            Width = 42
            Height = 13
            Caption = 'Website:'
          end
          object LblSite: TLabel
            Left = 52
            Top = 8
            Width = 3
            Height = 13
            Cursor = crHandPoint
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsUnderline]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            OnClick = LblSiteClick
          end
        end
        object PanelPkgname: TPanel
          Left = 0
          Top = 0
          Width = 177
          Height = 55
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Label1: TLabel
            Left = 8
            Top = 8
            Width = 31
            Height = 13
            Caption = 'Name:'
          end
          object EdName: TEdit
            Left = 8
            Top = 24
            Width = 153
            Height = 21
            ReadOnly = True
            TabOrder = 0
          end
        end
        object PanelVer: TPanel
          Left = 0
          Top = 55
          Width = 177
          Height = 55
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Label4: TLabel
            Left = 8
            Top = 8
            Width = 38
            Height = 13
            Caption = 'Version:'
          end
          object EdVer: TEdit
            Left = 8
            Top = 24
            Width = 153
            Height = 21
            ReadOnly = True
            TabOrder = 0
          end
        end
        object PanelLblDesc: TPanel
          Left = 0
          Top = 145
          Width = 177
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object Label5: TLabel
            Left = 0
            Top = 8
            Width = 56
            Height = 13
            Caption = 'Description:'
          end
        end
        object TextDesc: TRichEdit
          Left = 0
          Top = 171
          Width = 177
          Height = 288
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          ExplicitHeight = 286
        end
      end
      object TsFile: TTabSheet
        Caption = 'Files'
        ImageIndex = 1
        object FileList: TTreeView
          Left = 0
          Top = 0
          Width = 177
          Height = 459
          Align = alClient
          Images = ImgListMenu
          Indent = 19
          PopupMenu = PopupMenu1
          ReadOnly = True
          TabOrder = 0
          OnChange = FileListChange
          OnContextPopup = FileListContextPopup
        end
      end
    end
  end
  object PanelList: TPanel
    Left = 188
    Top = 56
    Width = 596
    Height = 487
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 2
    TabOrder = 0
    ExplicitTop = 58
    ExplicitHeight = 485
    object PkgList: TListView
      Left = 2
      Top = 2
      Width = 592
      Height = 483
      Align = alClient
      Columns = <>
      HideSelection = False
      IconOptions.AutoArrange = True
      LargeImages = ImgPkgList
      ReadOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDeletion = PkgListDeletion
      OnMouseMove = PkgListMouseMove
      OnSelectItem = PkgListSelectItem
      ExplicitHeight = 481
    end
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 784
    Height = 56
    AutoSize = True
    ButtonHeight = 52
    ButtonWidth = 47
    Caption = 'ToolBar'
    EdgeBorders = [ebTop, ebBottom]
    HotImages = HotImgListToolbar
    Images = ImgListToolbar
    Indent = 2
    ShowCaptions = True
    TabOrder = 2
    object TbInstall: TToolButton
      Left = 2
      Top = 0
      Caption = 'Install'
      ImageIndex = 0
      OnClick = InstallClick
    end
    object TbUninstall: TToolButton
      Left = 49
      Top = 0
      Caption = 'Uninstall'
      Enabled = False
      ImageIndex = 1
      OnClick = TbUninstallClick
    end
    object ToolButton3: TToolButton
      Left = 96
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object TbReload: TToolButton
      Left = 104
      Top = 0
      Caption = 'Reload'
      ImageIndex = 2
      OnClick = ReloadClick
    end
    object TbCheck: TToolButton
      Left = 151
      Top = 0
      Caption = 'Check'
      Enabled = False
      ImageIndex = 3
      OnClick = TbCheckClick
    end
    object ToolButton6: TToolButton
      Left = 198
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object TbHelp: TToolButton
      Left = 206
      Top = 0
      Caption = 'Help'
      ImageIndex = 4
      OnClick = TbHelpClick
    end
    object TbAbout: TToolButton
      Left = 253
      Top = 0
      Caption = 'About'
      ImageIndex = 5
    end
    object ToolButton9: TToolButton
      Left = 300
      Top = 0
      Width = 8
      Caption = 'ToolButton9'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object TbExit: TToolButton
      Left = 308
      Top = 0
      Caption = 'Exit'
      ImageIndex = 6
      OnClick = ExitClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 472
    Top = 16
    object Packages1: TMenuItem
      Caption = 'Packages'
      object Install1: TMenuItem
        Caption = 'Install'
        ShortCut = 45
        OnClick = InstallClick
      end
      object Uninstall1: TMenuItem
        Caption = 'Uninstall'
        Enabled = False
        ShortCut = 46
        OnClick = TbUninstallClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Reload1: TMenuItem
        Caption = 'Reload'
        ShortCut = 116
        OnClick = ReloadClick
      end
      object Check1: TMenuItem
        Caption = 'Check'
        Enabled = False
        ShortCut = 114
        OnClick = TbCheckClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 16465
        OnClick = ExitClick
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object toolbarchk: TMenuItem
        AutoCheck = True
        Caption = 'Toolbar'
        Checked = True
        OnClick = ViewControlsClick
      end
      object Details1: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = 'Details'
        Checked = True
        OnClick = ViewControlsClick
      end
      object Statusbar1: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = 'Statusbar'
        Checked = True
        OnClick = ViewControlsClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Help2: TMenuItem
        Caption = 'Help'
        ShortCut = 112
        OnClick = TbHelpClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About...'
      end
    end
  end
  object HotImgListToolbar: TImageList
    ColorDepth = cd32Bit
    Height = 32
    Width = 32
    Left = 320
    Top = 160
  end
  object ImgListMenu: TImageList
    ColorDepth = cd32Bit
    Left = 320
    Top = 216
  end
  object ImgListToolbar: TImageList
    ColorDepth = cd32Bit
    Height = 32
    Width = 32
    Left = 320
    Top = 104
  end
  object ImgPkgList: TImageList
    ColorDepth = cd32Bit
    Height = 48
    Width = 48
    Left = 320
    Top = 272
  end
  object PopupMenu1: TPopupMenu
    Left = 204
    Top = 122
    object OpenFolder1: TMenuItem
      Caption = 'Open Folder'
      Enabled = False
      ShortCut = 13
      OnClick = OpenFolder1Click
    end
    object CopyFileName1: TMenuItem
      Caption = 'Copy FileName'
      Enabled = False
      ShortCut = 16451
      OnClick = CopyFileName1Click
    end
  end
end
