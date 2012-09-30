object FraWelc: TFraWelc
  Left = 0
  Top = 0
  Width = 495
  Height = 314
  TabOrder = 0
  object ImageLogo: TImage
    Left = 0
    Top = 0
    Width = 164
    Height = 311
    Align = alLeft
  end
  object BvLine: TBevel
    Left = 0
    Top = 311
    Width = 495
    Height = 3
    Align = alBottom
    Shape = bsTopLine
  end
  object PainelMens: TPanel
    Left = 164
    Top = 0
    Width = 331
    Height = 311
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object TextRecom: TLabel
      Left = 16
      Top = 112
      Width = 266
      Height = 39
      Caption = 
        'It is recommended that you close Falcon C++ application'#13'before s' +
        'tarting Installation. This will make it possible to update all f' +
        'iles on the compiler folder.'
      WordWrap = True
    end
    object TextGuide: TLabel
      Left = 16
      Top = 176
      Width = 107
      Height = 13
      Caption = 'Click Next to continue.'
    end
    object LblMsg: TLabel
      Left = 16
      Top = 16
      Width = 288
      Height = 49
      AutoSize = False
      Caption = 'Welcome to the %s Package Installation Wizard'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object TextHelp: TLabel
      Left = 16
      Top = 72
      Width = 257
      Height = 13
      Caption = 'This wizard will guide you through the instalation of %s.'
      WordWrap = True
    end
  end
end
