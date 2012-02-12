object FrmCompOptions: TFrmCompOptions
  Left = 548
  Top = 351
  BorderStyle = bsDialog
  Caption = 'Compiler and Debugger Options'
  ClientHeight = 428
  ClientWidth = 460
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
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 449
    Height = 385
    ActivePage = TSCompiler
    TabOrder = 0
    object TSCompiler: TTabSheet
      Caption = 'Compiler'
    end
    object TSDebugger: TTabSheet
      Caption = 'Debugger'
      ImageIndex = 3
    end
    object TSDirectories: TTabSheet
      Caption = 'Directories'
      ImageIndex = 1
    end
    object TSPrograms: TTabSheet
      Caption = 'Programs'
      ImageIndex = 2
    end
  end
  object BtnOk: TButton
    Left = 220
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 300
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object BtnApply: TButton
    Left = 380
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Apply'
    Enabled = False
    TabOrder = 3
    OnClick = BtnApplyClick
  end
end
