object FrmUpdate: TFrmUpdate
  Left = 489
  Top = 408
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Application Update'
  ClientHeight = 372
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 326
    Width = 418
    Height = 2
    Align = alBottom
    Shape = bsBottomLine
  end
  object Bevel2: TBevel
    Left = 0
    Top = 28
    Width = 418
    Height = 2
    Align = alTop
    Shape = bsBottomLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 418
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object LblAction: TLabel
      Left = 8
      Top = 8
      Width = 125
      Height = 13
      Caption = 'New update availabre'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 328
    Width = 418
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnCancel: TButton
      Left = 334
      Top = 10
      Width = 75
      Height = 25
      Caption = '&Close'
      TabOrder = 1
      OnClick = BtnCancelClick
    end
    object BtnUpdate: TButton
      Left = 254
      Top = 10
      Width = 75
      Height = 25
      Caption = '&Update'
      TabOrder = 0
      Visible = False
      OnClick = BtnUpdateClick
    end
  end
  object PnlFra: TPanel
    Left = 0
    Top = 30
    Width = 418
    Height = 296
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object LblChanges: TLabel
      Left = 32
      Top = 104
      Width = 45
      Height = 13
      Caption = 'Changes:'
      Visible = False
    end
    object LblDesc: TLabel
      Left = 32
      Top = 40
      Width = 3
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object MemoChanges: TMemo
      Left = 32
      Top = 120
      Width = 353
      Height = 145
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      Visible = False
    end
  end
end
