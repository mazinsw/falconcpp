object FrmPkgDownload: TFrmPkgDownload
  Left = 282
  Top = 173
  Caption = 'Install packages'
  ClientHeight = 468
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 516
    Top = 41
    Width = 7
    Height = 369
    Align = alRight
    Visible = False
    OnCanResize = Splitter1CanResize
    OnMoved = Splitter1Moved
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 516
    Height = 369
    Align = alClient
    Caption = 'Packages'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 304
      Width = 30
      Height = 13
      Caption = 'Show:'
    end
    object Label6: TLabel
      Left = 8
      Top = 339
      Width = 82
      Height = 13
      Caption = 'Search package:'
    end
    object TreeViewPackages: TVirtualStringTree
      Left = 8
      Top = 20
      Width = 497
      Height = 277
      Colors.UnfocusedColor = clMedGray
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Height = 25
      Header.Images = ImageList16x16
      Header.Options = [hoColumnResize, hoHotTrack, hoShowImages, hoShowSortGlyphs, hoVisible]
      Images = ImageList16x16
      LineStyle = lsSolid
      NodeDataSize = 0
      TabOrder = 1
      TreeOptions.AutoOptions = [toAutoScrollOnExpand, toAutoTristateTracking, toAutoHideButtons, toAutoDeleteMovedNodes, toAutoChangeScale]
      TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toUseExplorerTheme, toHideTreeLinesIfThemed]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      OnChange = TreeViewPackagesChange
      OnChecked = TreeViewPackagesChecked
      OnChecking = TreeViewPackagesChecking
      OnGetText = TreeViewPackagesGetText
      OnGetImageIndex = TreeViewPackagesGetImageIndex
      Columns = <
        item
          CheckType = ctTriStateCheckBox
          CheckBox = True
          ImageIndex = 0
          Position = 0
          Width = 243
          WideText = 'Name'
        end
        item
          Alignment = taCenter
          Position = 1
          Width = 75
          WideText = 'Version'
        end
        item
          Alignment = taCenter
          Position = 2
          Width = 75
          WideText = 'Size'
        end
        item
          Position = 3
          Width = 100
          WideText = 'Status'
        end>
    end
    object CheckBox1: TCheckBox
      Left = 51
      Top = 302
      Width = 97
      Height = 17
      Caption = 'Updates/New'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 179
      Top = 302
      Width = 97
      Height = 17
      Caption = 'Installed'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = CheckBox1Click
    end
    object Button1: TButton
      Left = 328
      Top = 304
      Width = 177
      Height = 25
      Caption = 'Install packages...'
      Enabled = False
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 328
      Top = 334
      Width = 177
      Height = 25
      Caption = 'Delete packages...'
      Enabled = False
      TabOrder = 5
      OnClick = Button2Click
    end
    object EditSearch: TEdit
      Left = 96
      Top = 336
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = EditSearchChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 410
    Width = 742
    Height = 58
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object LabelProgresss: TLabel
      Left = 12
      Top = 36
      Width = 116
      Height = 13
      Caption = 'Done loading packages.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ProgressBar1: TProgressBar
      Left = 11
      Top = 11
      Width = 633
      Height = 17
      Smooth = True
      TabOrder = 0
    end
    object BtnCancel: TButton
      Left = 664
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = BtnCancelClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 523
    Top = 41
    Width = 219
    Height = 369
    Align = alRight
    Caption = 'Information'
    TabOrder = 3
    Visible = False
    object Image1: TImage
      Left = 8
      Top = 24
      Width = 64
      Height = 64
    end
    object Label5: TLabel
      Left = 8
      Top = 128
      Width = 56
      Height = 13
      Caption = 'Description:'
    end
    object LblSite: TLabel
      Left = 52
      Top = 104
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
    object Label2: TLabel
      Left = 8
      Top = 104
      Width = 42
      Height = 13
      Caption = 'Website:'
    end
    object Label1: TLabel
      Left = 80
      Top = 32
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label4: TLabel
      Left = 80
      Top = 56
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object LabelName: TLabel
      Left = 120
      Top = 32
      Width = 3
      Height = 13
    end
    object LabelVersion: TLabel
      Left = 120
      Top = 56
      Width = 3
      Height = 13
    end
    object TextDesc: TRichEdit
      Left = 7
      Top = 146
      Width = 205
      Height = 155
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object ImageList16x16: TImageList
    ColorDepth = cd32Bit
    Left = 704
    Top = 304
  end
  object FileDownloadXML: TFileDownload
    URL = 'http://falconcpp.sourceforge.net/packages/list.php'
    OnStart = FileDownloadXMLStart
    OnProgress = FileDownloadXMLProgress
    OnFinish = FileDownloadXMLFinish
    Left = 104
    Top = 264
  end
  object FileDownloadPkg: TFileDownload
    PartExt = '.part'
    OnStart = FileDownloadPkgStart
    OnProgress = FileDownloadPkgProgress
    OnFinish = FileDownloadPkgFinish
    Left = 160
    Top = 265
  end
end
