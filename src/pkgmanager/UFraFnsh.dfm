object FraFnsh: TFraFnsh
  Left = 0
  Top = 0
  Width = 500
  Height = 314
  TabOrder = 0
  object LinhaInf: TBevel
    Left = 0
    Top = 311
    Width = 500
    Height = 3
    Align = alBottom
    Shape = bsTopLine
  end
  object Imagem: TImage
    Left = 0
    Top = 0
    Width = 164
    Height = 311
    Align = alLeft
  end
  object PainelMens: TPanel
    Left = 164
    Top = 0
    Width = 336
    Height = 311
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object TextTitle: TLabel
      Left = 16
      Top = 16
      Width = 305
      Height = 48
      AutoSize = False
      Caption = 'Completing the %s Installation Wizard'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object TextHelp: TLabel
      Left = 16
      Top = 72
      Width = 313
      Height = 49
      AutoSize = False
      Caption = '%s has been installed sucessfull.'
      WordWrap = True
    end
    object TextRecom: TLabel
      Left = 16
      Top = 128
      Width = 148
      Height = 13
      Caption = 'Click Finish to close this wizard.'
    end
    object ChbShow: TCheckBox
      Left = 16
      Top = 160
      Width = 185
      Height = 17
      Caption = 'Show Package Manager'
      TabOrder = 0
    end
  end
end
