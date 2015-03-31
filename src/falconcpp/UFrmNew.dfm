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
    Height = 328
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PainelBtns: TPanel
    Left = 0
    Top = 328
    Width = 521
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      521
      56)
    object BtnProx: TButton
      Left = 262
      Top = 23
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
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
      Top = 23
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
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
      Top = 23
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
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
      Top = 23
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
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
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 521
      Height = 19
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 4
      object LblWidz: TLabel
        Left = 3
        Top = 3
        Width = 104
        Height = 13
        Align = alLeft
        Caption = 'Falcon Project Wizard'
        Enabled = False
      end
      object Panel2: TPanel
        Left = 107
        Top = 3
        Width = 411
        Height = 13
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object Bevel1: TBevel
          Left = 3
          Top = 3
          Width = 405
          Height = 7
          Align = alClient
          Shape = bsBottomLine
        end
      end
    end
  end
end
