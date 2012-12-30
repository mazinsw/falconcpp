object FrmNewProj: TFrmNewProj
  Left = 416
  Top = 257
  BorderStyle = bsDialog
  Caption = 'New Project'
  ClientHeight = 384
  ClientWidth = 521
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
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PainelFra: TPanel
    Left = 0
    Top = 0
    Width = 521
    Height = 351
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PainelBtns: TPanel
    Left = 0
    Top = 351
    Width = 521
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnProx: TButton
      Left = 262
      Top = -1
      Width = 75
      Height = 23
      Caption = 'Next >'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BtnProxClick
    end
    object BtnCan: TButton
      Left = 436
      Top = -1
      Width = 75
      Height = 23
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = BtnCanClick
    end
    object BtnVoltar: TButton
      Left = 187
      Top = -1
      Width = 75
      Height = 23
      Caption = '< Back'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = BtnVoltarClick
    end
    object BtnFnsh: TButton
      Left = 348
      Top = -1
      Width = 75
      Height = 23
      Caption = 'Finish'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = BtnFnshClick
    end
  end
end
