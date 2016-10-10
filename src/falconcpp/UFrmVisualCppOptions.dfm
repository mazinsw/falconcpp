object FrmVisualCppOptions: TFrmVisualCppOptions
  Left = 507
  Top = 444
  BorderStyle = bsDialog
  Caption = 'Visual C++ Import Options'
  ClientHeight = 145
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 169
    Height = 13
    Caption = 'Please select a target configuration:'
  end
  object CboConfig: TComboBox
    Left = 8
    Top = 56
    Width = 313
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object BtnOk: TButton
    Left = 166
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 248
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = BtnCancelClick
  end
end
