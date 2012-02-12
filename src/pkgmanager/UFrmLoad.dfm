object FrmLoad: TFrmLoad
  Left = 742
  Top = 716
  BorderStyle = bsNone
  ClientHeight = 75
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 10
    Top = 14
    Width = 48
    Height = 48
    AutoSize = True
    Center = True
  end
  object Label1: TLabel
    Left = 66
    Top = 16
    Width = 170
    Height = 13
    Caption = 'Please wait while extract package...'
  end
  object LblPrgs: TLabel
    Left = 100
    Top = 48
    Width = 94
    Height = 13
    Caption = 'unpacking data: 0%'
  end
end
