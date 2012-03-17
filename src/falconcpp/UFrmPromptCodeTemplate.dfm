object FrmPromptCodeTemplate: TFrmPromptCodeTemplate
  Left = 462
  Top = 400
  BorderStyle = bsDialog
  Caption = 'Caption'
  ClientHeight = 110
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 65
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 56
      Height = 13
      Caption = 'Description:'
    end
    object EditName: TEdit
      Left = 104
      Top = 8
      Width = 177
      Height = 21
      TabOrder = 0
      OnKeyPress = EditNameKeyPress
    end
    object EditDesc: TEdit
      Left = 104
      Top = 36
      Width = 177
      Height = 21
      TabOrder = 1
      OnKeyPress = EditDescKeyPress
    end
  end
  object BtnCancel: TButton
    Left = 224
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object BtnOk: TButton
    Left = 144
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = BtnOkClick
  end
end
