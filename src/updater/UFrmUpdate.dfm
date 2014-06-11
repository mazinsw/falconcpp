object FrmUpdate: TFrmUpdate
  Left = 425
  Top = 227
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
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
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
      Width = 110
      Height = 13
      Caption = 'looking for updates'
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
      Caption = '&Cancel'
      TabOrder = 0
      OnClick = BtnCancelClick
    end
    object BtnUpdate: TButton
      Left = 254
      Top = 10
      Width = 75
      Height = 25
      Caption = '&Update'
      TabOrder = 1
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
  end
  object UpdateDownload: TFileDownload
    OnFinish = UpdateDownloadFinish
    Left = 8
    Top = 30
  end
  object FileDownload: TFileDownload
    PartExt = '.part'
    OnStart = FileDownloadStart
    OnProgress = FileDownloadProgress
    OnFinish = FileDownloadFinish
    Left = 8
    Top = 62
  end
end
