object FrmWizard: TFrmWizard
  Left = 413
  Top = 337
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '%s Installation'
  ClientHeight = 357
  ClientWidth = 495
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
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PanelFra: TPanel
    Left = 0
    Top = 0
    Width = 495
    Height = 323
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PainelBtns: TPanel
    Left = 0
    Top = 323
    Width = 495
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnNext: TButton
      Left = 322
      Top = 0
      Width = 75
      Height = 23
      Caption = 'Next >'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BtnNextClick
    end
    object BtnCan: TButton
      Left = 408
      Top = 0
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
    object BtnBack: TButton
      Left = 247
      Top = 0
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
      OnClick = BtnBackClick
    end
  end
end
