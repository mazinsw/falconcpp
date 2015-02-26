object FraReadMe: TFraReadMe
  Left = 0
  Top = 0
  Width = 498
  Height = 240
  TabOrder = 0
  object PainelAll: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label5: TLabel
      Left = 24
      Top = 16
      Width = 237
      Height = 13
      Caption = 'Press Page Down to see the rest of the README.'
    end
    object TextGuide: TLabel
      Left = 24
      Top = 200
      Width = 108
      Height = 13
      Caption = 'Click Next to continue.'
    end
    object TextReadMe: TRichEdit
      Left = 24
      Top = 40
      Width = 449
      Height = 153
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
end
