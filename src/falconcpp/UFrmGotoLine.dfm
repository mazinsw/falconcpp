object FormGotoLine: TFormGotoLine
  Left = 595
  Top = 249
  BorderStyle = bsToolWindow
  Caption = 'Goto Line'
  ClientHeight = 107
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 64
    Width = 313
    Height = 2
    Shape = bsTopLine
  end
  object LblLine: TLabel
    Left = 8
    Top = 8
    Width = 23
    Height = 13
    Caption = 'Line:'
  end
  object BtnOk: TButton
    Left = 164
    Top = 74
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 245
    Top = 74
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object EditLine: TRzSpinEdit
    Left = 8
    Top = 24
    Width = 313
    Height = 21
    AllowKeyEdit = True
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    TabOrder = 0
    OnKeyPress = EditLineKeyPress
  end
end
