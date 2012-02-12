object FrmOptions: TFrmOptions
  Left = 487
  Top = 353
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 372
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 401
    Height = 329
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
    end
    object TabSheet5: TTabSheet
      Caption = 'TabSheet5'
      ImageIndex = 4
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
    end
  end
  object BtnOk: TButton
    Left = 172
    Top = 342
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
  end
  object BtnCancel: TButton
    Left = 252
    Top = 342
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
  end
  object BtnApply: TButton
    Left = 332
    Top = 342
    Width = 75
    Height = 25
    Caption = 'Apply'
    Enabled = False
    TabOrder = 3
  end
end
