object FrmHelp: TFrmHelp
  Left = 393
  Top = 303
  BorderStyle = bsDialog
  Caption = 'Falcon C++ Package Manager - [Help]'
  ClientHeight = 401
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    481
    401)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 465
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 206
    Top = 360
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
end
