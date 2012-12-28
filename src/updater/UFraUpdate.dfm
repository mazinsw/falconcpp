object FraUpdate: TFraUpdate
  Left = 0
  Top = 0
  Width = 418
  Height = 295
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 418
    Height = 295
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object LblDesc: TLabel
      Left = 32
      Top = 40
      Width = 3
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LblChanges: TLabel
      Left = 32
      Top = 104
      Width = 45
      Height = 13
      Caption = 'Changes:'
      Visible = False
    end
    object PrgsUpdate: TProgressBar
      Left = 32
      Top = 64
      Width = 353
      Height = 17
      TabOrder = 0
      Visible = False
    end
    object MemoChanges: TMemo
      Left = 32
      Top = 120
      Width = 353
      Height = 145
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      Visible = False
    end
  end
end
