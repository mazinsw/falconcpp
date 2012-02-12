object FrmReport: TFrmReport
  Left = 399
  Top = 186
  BorderStyle = bsDialog
  Caption = 'Report'
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
  PixelsPerInch = 96
  TextHeight = 13
  object BtnSend: TButton
    Left = 255
    Top = 342
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 0
    OnClick = BtnSendClick
  end
  object BtnClose: TButton
    Left = 335
    Top = 342
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = BtnCloseClick
  end
  object GrbImg: TGroupBox
    Left = 8
    Top = 8
    Width = 401
    Height = 153
    Caption = 'Image Error'
    TabOrder = 2
    object PanelImg: TPanel
      Left = 8
      Top = 16
      Width = 130
      Height = 130
      AutoSize = True
      BevelOuter = bvLowered
      TabOrder = 0
      object ImgErr: TImage
        Left = 1
        Top = 1
        Width = 128
        Height = 128
        Hint = 'Double click to change report image'
        Center = True
        ParentShowHint = False
        ShowHint = True
        Stretch = True
        OnDblClick = BtnLoadClick
      end
    end
    object BtnLoad: TButton
      Left = 312
      Top = 120
      Width = 83
      Height = 25
      Caption = 'Load...'
      TabOrder = 1
      OnClick = BtnLoadClick
    end
    object BtnRem: TButton
      Left = 222
      Top = 120
      Width = 83
      Height = 25
      Caption = 'Remove'
      TabOrder = 2
      OnClick = BtnRemClick
    end
  end
  object GrbMsg: TGroupBox
    Left = 8
    Top = 168
    Width = 401
    Height = 167
    Caption = 'Message'
    TabOrder = 3
    object MemoMsg: TMemo
      Left = 8
      Top = 16
      Width = 385
      Height = 141
      TabOrder = 0
    end
  end
  object SendMail: TSendMail
    Priority = mpNormal
    From = 'falconcpp@yahoo.com.br'
    Destination = 'falconcpp@yahoo.com.br'
    Subject = 'Falcon report'
    UseSSL = False
    Confirmation = False
    Left = 168
    Top = 48
  end
  object OPDlg: TOpenPictureDialog
    Filter = 
      'All (*.png;*.gif;*.jpg;*.jpeg;*.bmp)|*.png;*.gif;*.jpg;*.jpeg;*.' +
      'bmp|Portable Network Graphics (*.png)|*.png|GIF Image (*.gif)|*.' +
      'gif|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpe' +
      'g|Bitmaps (*.bmp)|*.bmp'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 232
    Top = 56
  end
end
