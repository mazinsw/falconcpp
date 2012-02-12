object FraPrgs: TFraPrgs
  Left = 0
  Top = 0
  Width = 495
  Height = 233
  TabOrder = 0
  object PainelAll: TPanel
    Left = 0
    Top = 0
    Width = 495
    Height = 233
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object LblDesc: TLabel
      Left = 24
      Top = 11
      Width = 3
      Height = 13
    end
    object ListDesc: TListView
      Left = 24
      Top = 55
      Width = 449
      Height = 175
      Columns = <
        item
          Width = 400
        end>
      ReadOnly = True
      RowSelect = True
      ShowColumnHeaders = False
      TabOrder = 2
      ViewStyle = vsReport
      Visible = False
    end
    object PrgBar: TProgressBar
      Left = 24
      Top = 32
      Width = 449
      Height = 17
      Step = 1
      TabOrder = 0
    end
    object BtnShow: TButton
      Left = 24
      Top = 58
      Width = 89
      Height = 24
      Caption = 'Show details'
      TabOrder = 1
      OnClick = BtnShowClick
    end
  end
end
