object FraDesc: TFraDesc
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
    object LblEspReq: TLabel
      Left = 24
      Top = 200
      Width = 106
      Height = 13
      Caption = 'Space required: 0.0kB'
    end
    object LblEspDisp: TLabel
      Left = 24
      Top = 216
      Width = 108
      Height = 13
      Caption = 'Space available: 0.0kB'
    end
    object Label1: TLabel
      Left = 24
      Top = 168
      Width = 169
      Height = 13
      Caption = 'Click Install to start the installation.'
    end
    object GBoxFile: TGroupBox
      Left = 24
      Top = 8
      Width = 449
      Height = 153
      Caption = 'Package description'
      TabOrder = 0
      object TextDesc: TLabel
        Left = 8
        Top = 68
        Width = 57
        Height = 13
        Caption = 'Description:'
      end
      object Label2: TLabel
        Left = 8
        Top = 52
        Width = 43
        Height = 13
        Caption = 'Website:'
      end
      object Label3: TLabel
        Left = 8
        Top = 36
        Width = 39
        Height = 13
        Caption = 'Version:'
      end
      object Label4: TLabel
        Left = 8
        Top = 20
        Width = 31
        Height = 13
        Caption = 'Name:'
      end
      object LblSite: TLabel
        Left = 52
        Top = 52
        Width = 13
        Height = 13
        Cursor = crHandPoint
        Caption = '%s'
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
      object LblVer: TLabel
        Left = 52
        Top = 36
        Width = 16
        Height = 13
        Caption = '%s'
      end
      object LblName: TLabel
        Left = 52
        Top = 20
        Width = 16
        Height = 13
        Caption = '%s'
      end
      object TextPkgDesc: TMemo
        Left = 8
        Top = 88
        Width = 433
        Height = 57
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
end
