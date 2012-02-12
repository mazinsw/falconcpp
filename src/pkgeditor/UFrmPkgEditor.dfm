object FrmPkgEditor: TFrmPkgEditor
  Left = 284
  Top = 268
  Width = 795
  Height = 579
  Caption = 'Falcon C++ Package Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 76
    Width = 787
    Height = 193
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 10
      Top = 10
      Width = 767
      Height = 173
      Align = alClient
      Caption = 'Information'
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 269
    Width = 787
    Height = 276
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 10
      Top = 10
      Width = 767
      Height = 256
      ActivePage = TabSheet1
      Align = alClient
      Images = ImageListCategory
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Libraries'
        object ListView1: TListView
          Left = 0
          Top = 0
          Width = 703
          Height = 195
          Align = alClient
          Columns = <>
          TabOrder = 0
        end
        object ToolBar1: TToolBar
          Left = 703
          Top = 0
          Width = 56
          Height = 195
          Align = alRight
          ButtonHeight = 54
          ButtonWidth = 55
          Caption = 'ToolBar1'
          EdgeBorders = []
          Images = ImageListAddDel
          Indent = 1
          TabOrder = 1
          object ToolButton1: TToolButton
            Left = 1
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 0
            Wrap = True
          end
          object ToolButton2: TToolButton
            Left = 1
            Top = 54
            Caption = 'ToolButton2'
            ImageIndex = 1
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Include'
        ImageIndex = 1
        object ListView2: TListView
          Left = 0
          Top = 0
          Width = 703
          Height = 195
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 300
            end
            item
              Caption = 'Size'
              Width = 100
            end
            item
              Caption = 'Date'
              Width = 150
            end>
          TabOrder = 0
          ViewStyle = vsReport
        end
        object ToolBar3: TToolBar
          Left = 703
          Top = 0
          Width = 56
          Height = 195
          Align = alRight
          ButtonHeight = 54
          ButtonWidth = 55
          Caption = 'ToolBar1'
          EdgeBorders = []
          Images = ImageListAddDel
          Indent = 1
          TabOrder = 1
          object ToolButton5: TToolButton
            Left = 1
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 0
            Wrap = True
          end
          object ToolButton6: TToolButton
            Left = 1
            Top = 54
            Caption = 'ToolButton2'
            ImageIndex = 1
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Binaries'
        ImageIndex = 2
        object ToolBar4: TToolBar
          Left = 703
          Top = 0
          Width = 56
          Height = 195
          Align = alRight
          ButtonHeight = 54
          ButtonWidth = 55
          Caption = 'ToolBar1'
          EdgeBorders = []
          Images = ImageListAddDel
          Indent = 1
          TabOrder = 0
          object ToolButton7: TToolButton
            Left = 1
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 0
            Wrap = True
          end
          object ToolButton8: TToolButton
            Left = 1
            Top = 54
            Caption = 'ToolButton2'
            ImageIndex = 1
          end
        end
        object ListView3: TListView
          Left = 0
          Top = 0
          Width = 703
          Height = 195
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 300
            end
            item
              Caption = 'Size'
              Width = 100
            end
            item
              Caption = 'Date'
              Width = 150
            end>
          TabOrder = 1
          ViewStyle = vsReport
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Templates'
        ImageIndex = 3
        object ListView4: TListView
          Left = 0
          Top = 0
          Width = 703
          Height = 195
          Align = alClient
          Columns = <>
          TabOrder = 0
        end
        object ToolBar5: TToolBar
          Left = 703
          Top = 0
          Width = 56
          Height = 195
          Align = alRight
          ButtonHeight = 54
          ButtonWidth = 55
          Caption = 'ToolBar1'
          EdgeBorders = []
          Images = ImageListAddDel
          Indent = 1
          TabOrder = 1
          object ToolButton9: TToolButton
            Left = 1
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 0
            Wrap = True
          end
          object ToolButton10: TToolButton
            Left = 1
            Top = 54
            Caption = 'ToolButton2'
            ImageIndex = 1
            Wrap = True
          end
          object ToolButton18: TToolButton
            Left = 1
            Top = 108
            Caption = 'ToolButton18'
            ImageIndex = 2
          end
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'Help and Documentation'
        ImageIndex = 4
        object ToolBar6: TToolBar
          Left = 703
          Top = 0
          Width = 56
          Height = 195
          Align = alRight
          ButtonHeight = 54
          ButtonWidth = 55
          Caption = 'ToolBar1'
          EdgeBorders = []
          Images = ImageListAddDel
          Indent = 1
          TabOrder = 0
          object ToolButton11: TToolButton
            Left = 1
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 0
            Wrap = True
          end
          object ToolButton12: TToolButton
            Left = 1
            Top = 54
            Caption = 'ToolButton2'
            ImageIndex = 1
          end
        end
        object ListView5: TListView
          Left = 0
          Top = 0
          Width = 703
          Height = 195
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 300
            end
            item
              Caption = 'Size'
              Width = 100
            end
            item
              Caption = 'Date'
              Width = 150
            end>
          TabOrder = 1
          ViewStyle = vsReport
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'Examples'
        ImageIndex = 5
        object ListView6: TListView
          Left = 0
          Top = 0
          Width = 703
          Height = 195
          Align = alClient
          Columns = <>
          TabOrder = 0
        end
        object ToolBar7: TToolBar
          Left = 703
          Top = 0
          Width = 56
          Height = 195
          Align = alRight
          ButtonHeight = 54
          ButtonWidth = 55
          Caption = 'ToolBar1'
          EdgeBorders = []
          Images = ImageListAddDel
          Indent = 1
          TabOrder = 1
          object ToolButton13: TToolButton
            Left = 1
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 0
            Wrap = True
          end
          object ToolButton14: TToolButton
            Left = 1
            Top = 54
            Caption = 'ToolButton2'
            ImageIndex = 1
          end
        end
      end
    end
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 787
    Height = 76
    BorderWidth = 1
    ButtonHeight = 70
    ButtonWidth = 71
    Caption = 'ToolBar2'
    EdgeBorders = [ebBottom]
    Images = ImageListToolbar
    TabOrder = 2
    object ToolButton3: TToolButton
      Left = 0
      Top = 0
      Hint = 'Open'
      Caption = 'Open'
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton4: TToolButton
      Left = 71
      Top = 0
      Hint = 'Save'
      Caption = 'Save'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton15: TToolButton
      Left = 142
      Top = 0
      Width = 8
      Caption = 'ToolButton15'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButton16: TToolButton
      Left = 150
      Top = 0
      Hint = 'Redo'
      Caption = 'Redo'
      Enabled = False
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton17: TToolButton
      Left = 221
      Top = 0
      Hint = 'Undo'
      Caption = 'Undo'
      Enabled = False
      ImageIndex = 3
      ParentShowHint = False
      ShowHint = True
    end
  end
  object XPManifest1: TXPManifest
    Left = 512
    Top = 216
  end
  object ImageListAddDel: TImageList
    Height = 48
    Width = 48
    Left = 532
    Top = 442
  end
  object ImageListToolbar: TImageList
    Height = 64
    Width = 64
    Left = 294
    Top = 26
  end
  object ImageListCategory: TImageList
    Height = 48
    Width = 48
    Left = 30
    Top = 290
  end
end
