object FormGotoFunction: TFormGotoFunction
  Left = 526
  Top = 402
  BorderStyle = bsSizeToolWin
  Caption = 'Goto Function'
  ClientHeight = 242
  ClientWidth = 462
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanelFind: TPanel
    Left = 0
    Top = 0
    Width = 462
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = PanelFindResize
    object EditFuncName: TEdit
      Left = 8
      Top = 8
      Width = 454
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'Function name'
      OnChange = EditFuncNameChange
      OnClick = EditFuncNameClick
      OnEnter = EditFuncNameEnter
      OnExit = EditFuncNameExit
      OnKeyDown = EditFuncNameKeyDown
      OnKeyPress = EditFuncNameKeyPress
    end
  end
  object ListViewFunctions: TListView
    Left = 0
    Top = 37
    Width = 462
    Height = 205
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Return type'
        Width = 125
      end
      item
        Caption = 'Line'
      end
      item
        Caption = 'File'
        Width = 100
      end>
    ColumnClick = False
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SmallImages = FrmFalconMain.ImgListOutLine
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = ListViewFunctionsDblClick
    ExplicitHeight = 201
  end
end
