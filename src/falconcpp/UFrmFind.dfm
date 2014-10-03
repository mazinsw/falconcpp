object FrmFind: TFrmFind
  Left = 488
  Top = 307
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Find and replace'
  ClientHeight = 365
  ClientWidth = 550
  Color = clBtnFace
  TransparentColorValue = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  DesignSize = (
    550
    365)
  PixelsPerInch = 96
  TextHeight = 13
  object TabCtrl: TTabControl
    Left = 8
    Top = 8
    Width = 536
    Height = 349
    Anchors = [akLeft, akTop, akRight, akBottom]
    HotTrack = True
    MultiLine = True
    TabOrder = 0
    Tabs.Strings = (
      '&Find'
      '&Replace'
      'Fin&d in files')
    TabIndex = 0
    OnChange = TabCtrlChange
    DesignSize = (
      536
      349)
    object LblRep: TLabel
      Left = 38
      Top = 90
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Replace with:'
      Visible = False
    end
    object LblFind: TLabel
      Left = 80
      Top = 38
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = 'Find:'
    end
    object LblSrchOpt: TLabel
      Left = 10
      Top = 166
      Width = 71
      Height = 13
      Align = alCustom
      Caption = 'Search options'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13977088
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object BvSrchOpt: TBevel
      Left = 87
      Top = 173
      Width = 436
      Height = 3
      Align = alCustom
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
    end
    object GBoxRplcAll: TGroupBox
      Left = 111
      Top = 114
      Width = 100
      Height = 46
      TabOrder = 4
      Visible = False
      object ChbReplSel: TCheckBox
        Left = 8
        Top = 3
        Width = 84
        Height = 17
        Caption = 'In selection'
        TabOrder = 1
      end
      object BtnReplAll: TButton
        Left = 3
        Top = 21
        Width = 94
        Height = 22
        Caption = 'Replace All'
        Enabled = False
        TabOrder = 0
        OnClick = BtnReplAllClick
      end
    end
    object RGrpSearchMode: TRadioGroup
      Left = 10
      Top = 260
      Width = 173
      Height = 79
      Caption = 'Search mode'
      ItemIndex = 0
      Items.Strings = (
        'Normal'
        'Extended (\n, \r, \t, \0, \x...)'
        'Regular expression')
      TabOrder = 9
      Visible = False
    end
    object GBoxTransp: TGroupBox
      Left = 345
      Top = 260
      Width = 179
      Height = 79
      Anchors = [akLeft, akTop, akRight]
      Caption = '      Transparency'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 11
      Visible = False
      DesignSize = (
        179
        79)
      object LblOpcty: TLabel
        Left = 8
        Top = 24
        Width = 36
        Height = 13
        Caption = 'Opacity'
      end
      object ChbTransp: TCheckBox
        Left = 10
        Top = -2
        Width = 87
        Height = 17
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = ChbTranspClick
      end
      object TrkBar: TTrackBar
        Left = 4
        Top = 39
        Width = 173
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Max = 200
        PageSize = 60
        Frequency = 10
        Position = 150
        TabOrder = 1
        ThumbLength = 10
        OnChange = TrkBarChange
      end
    end
    object ChbFullWord: TCheckBox
      Left = 9
      Top = 211
      Width = 209
      Height = 17
      Caption = 'Match whole &word only'
      TabOrder = 7
      Visible = False
    end
    object ChbDiffCase: TCheckBox
      Left = 9
      Top = 192
      Width = 209
      Height = 17
      Caption = 'Match &case'
      TabOrder = 6
      Visible = False
    end
    object ChbCircSearch: TCheckBox
      Left = 9
      Top = 229
      Width = 209
      Height = 17
      Caption = 'Wrap aroun&d'
      Checked = True
      State = cbChecked
      TabOrder = 8
      Visible = False
    end
    object CboReplace: TComboBox
      Left = 111
      Top = 86
      Width = 413
      Height = 21
      AutoComplete = False
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Visible = False
      OnEnter = CboReplaceEnter
      OnExit = CboReplaceExit
      OnKeyPress = CboReplaceKeyPress
    end
    object CboFind: TComboBox
      Left = 111
      Top = 35
      Width = 413
      Height = 21
      AutoComplete = False
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = CboFindChange
      OnEnter = CboFindEnter
      OnKeyPress = CboFindKeyPress
    end
    object BtnReplace: TButton
      Left = 9
      Top = 135
      Width = 94
      Height = 22
      Caption = 'Replace'
      Enabled = False
      TabOrder = 3
      Visible = False
      OnClick = BtnReplaceClick
    end
    object BtnMore: TBitBtn
      Left = 220
      Top = 135
      Width = 94
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'More'
      Layout = blGlyphRight
      TabOrder = 5
      OnClick = BtnMoreClick
    end
    object BtnFind: TButton
      Left = 325
      Top = 135
      Width = 94
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Find Next'
      Enabled = False
      TabOrder = 2
      OnClick = BtnFindClick
    end
    object BtnCancel: TButton
      Left = 430
      Top = 135
      Width = 94
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      TabOrder = 12
      OnClick = BtnCancelClick
    end
    object GBoxDirection: TGroupBox
      Left = 192
      Top = 260
      Width = 145
      Height = 79
      Caption = 'Direction'
      TabOrder = 10
      Visible = False
      object RdbtUp: TRadioButton
        Left = 9
        Top = 19
        Width = 113
        Height = 17
        Caption = 'Up'
        TabOrder = 0
      end
      object RdbtDown: TRadioButton
        Left = 9
        Top = 49
        Width = 113
        Height = 17
        Caption = 'Down'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
    end
    object ProgressBarFindFiles: TProgressBar
      Left = 10
      Top = 105
      Width = 514
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 13
      Visible = False
    end
  end
end
