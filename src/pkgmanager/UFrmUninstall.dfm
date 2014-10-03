object FrmUninstall: TFrmUninstall
  Left = 652
  Top = 432
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Uninstalling package...'
  ClientHeight = 157
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
  OnKeyDown = FormKeyDown
  DesignSize = (
    495
    157)
  PixelsPerInch = 96
  TextHeight = 13
  object LblDesc: TLabel
    Left = 24
    Top = 75
    Width = 3
    Height = 13
  end
  object ListDesc: TListView
    Left = 24
    Top = 119
    Width = 449
    Height = 178
    Anchors = [akLeft, akTop, akRight]
    Columns = <
      item
        Width = 400
      end>
    ReadOnly = True
    RowSelect = True
    ShowColumnHeaders = False
    TabOrder = 2
    ViewStyle = vsReport
    Visible = False
  end
  object GBoxFile: TGroupBox
    Left = 24
    Top = 8
    Width = 449
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Package description'
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 36
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object Label5: TLabel
      Left = 8
      Top = 20
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object LblVer: TLabel
      Left = 49
      Top = 36
      Width = 13
      Height = 13
      Caption = '%s'
    end
    object LblName: TLabel
      Left = 49
      Top = 20
      Width = 13
      Height = 13
      Caption = '%s'
    end
  end
  object BtnShow: TButton
    Left = 24
    Top = 124
    Width = 89
    Height = 24
    Caption = 'Show details'
    TabOrder = 1
    OnClick = BtnShowClick
  end
  object PrgBar: TProgressBar
    Left = 24
    Top = 96
    Width = 449
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Step = 1
    TabOrder = 3
  end
  object BtnOk: TButton
    Left = 384
    Top = 124
    Width = 89
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Ok'
    Enabled = False
    TabOrder = 4
    OnClick = BtnOkClick
  end
end
