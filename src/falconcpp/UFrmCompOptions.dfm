object FrmCompOptions: TFrmCompOptions
  Left = 430
  Top = 205
  BorderStyle = bsDialog
  Caption = 'Compiler and Debugger Options'
  ClientHeight = 473
  ClientWidth = 511
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
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 497
    Height = 428
    ActivePage = TSCompiler
    TabOrder = 0
    object TSCompiler: TTabSheet
      Caption = 'Compiler'
      object LabelLang: TLabel
        Left = 3
        Top = 10
        Width = 107
        Height = 13
        Caption = 'Compiler configuration:'
      end
      object BtnSave: TSpeedButton
        Left = 433
        Top = 26
        Width = 22
        Height = 22
        Hint = 'Save sintax'
        Enabled = False
        Flat = True
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          1800000000000006000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          9933009933009933009933009933009933009933009933009933009933009933
          00993300993300FFFFFFFFFFFFFFFFFF99999999999999999999999999999999
          9999999999999999999999999999999999999999999999FFFFFFFFFFFF993300
          CC6600CC6600993300E5E5E5CC6600993300E5E5E5E5E5E5E5E5E5993300CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCC999999E5E5E5CCCCCC99
          9999E5E5E5E5E5E5E5E5E5999999CCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600CC6600993300E5E5E5CC6600993300E5E5E5E5E5E5E5E5E5993300CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCC999999E5E5E5CCCCCC99
          9999E5E5E5E5E5E5E5E5E5999999CCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600CC6600993300E5E5E5CC6600993300E5E5E5E5E5E5E5E5E5993300CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCC999999E5E5E5CCCCCC99
          9999E5E5E5E5E5E5E5E5E5999999CCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600CC6600993300E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5993300CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCC999999E5E5E5E5E5E5E5
          E5E5E5E5E5E5E5E5E5E5E5999999CCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600CC6600CC6600993300993300993300993300993300993300CC6600CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCCCCCCCC99999999999999
          9999999999999999999999CCCCCCCCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600CC6600CC6600CC6600CC6600CC6600CC6600CC6600CC6600CC6600CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600CC6600993300993300993300993300993300993300993300993300CC66
          00CC6600993300FFFFFFFFFFFF999999CCCCCCCCCCCC99999999999999999999
          9999999999999999999999999999CCCCCCCCCCCC999999FFFFFFFFFFFF993300
          CC6600993300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9933
          00CC6600993300FFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFF993300
          CC6600993300FFFFFF993300993300993300993300993300993300FFFFFF9933
          00CC6600993300FFFFFFFFFFFF999999CCCCCC999999FFFFFF99999999999999
          9999999999999999999999FFFFFF999999CCCCCC999999FFFFFFFFFFFF993300
          CC6600993300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9933
          00CC6600993300FFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFF993300
          E5E5E5993300FFFFFF993300993300993300993300993300993300FFFFFF9933
          00993300993300FFFFFFFFFFFF999999E5E5E5999999FFFFFF99999999999999
          9999999999999999999999FFFFFF999999999999999999FFFFFFFFFFFF993300
          CC6600993300FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9933
          00CC6600993300FFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFF993300
          9933009933009933009933009933009933009933009933009933009933009933
          00993300993300FFFFFFFFFFFF99999999999999999999999999999999999999
          9999999999999999999999999999999999999999999999FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
      end
      object BtnDel: TSpeedButton
        Left = 457
        Top = 26
        Width = 22
        Height = 22
        Hint = 'Delete sintax'
        Enabled = False
        Flat = True
        Glyph.Data = {
          36060000424D3606000000000000360000002800000020000000100000000100
          1800000000000006000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000099FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFF999999FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCFFFFFFFFFFFFFFFFFF
          3333CC0000FF000099FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC999999FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          3333CC3399FF0000FF000099FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF999999E5E5E5CCCCCC999999FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF3333CC0066FF0000CCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999E5E5E5999999FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF0000CC0000FF000099FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000
          99FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC999999FF
          FFFFFFFFFFFFFFFFFFFFFFCCCCCC999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF0000CC0000FF000099FFFFFFFFFFFF0000FF000099FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC99
          9999FFFFFFFFFFFFCCCCCC999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000CC0000FF0000990000FF000099FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CC
          CCCC999999CCCCCC999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000CC0000FF000099FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99
          9999CCCCCC999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000CC0000FF0000990000CC000099FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CC
          CCCC999999999999999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF0000CC0000FF000099FFFFFFFFFFFF0000CC000099FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCC99
          9999FFFFFFFFFFFF999999999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF0000CC0000FF0000FF000099FFFFFFFFFFFFFFFFFFFFFFFF0000CC0000
          99FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999CCCCCCCCCCCC999999FF
          FFFFFFFFFFFFFFFFFFFFFF999999999999FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          0000CC3399FF0000FF000099FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          CC000099FFFFFFFFFFFFFFFFFFFFFFFF999999E5E5E5CCCCCC999999FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF999999999999FFFFFFFFFFFFFFFFFFFFFFFF
          6666990000CC666699FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF0000CCFFFFFFFFFFFFFFFFFFCCCCCC999999CCCCCCFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF999999FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
      end
      object ComboBoxCompilerConfig: TComboBoxEx
        Left = 4
        Top = 26
        Width = 421
        Height = 22
        ItemsEx = <>
        ItemHeight = 16
        TabOrder = 0
        Images = FrmFalconMain.DisImgListMenus
        DropDownCount = 8
      end
      object PageControl2: TPageControl
        Left = 4
        Top = 57
        Width = 481
        Height = 339
        ActivePage = TabSheet1
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = 'General'
          object LabelUserDefDir: TLabel
            Left = 4
            Top = 14
            Width = 67
            Height = 13
            Caption = 'Compiler path:'
          end
          object BtnChooseCompilerPath: TSpeedButton
            Left = 443
            Top = 31
            Width = 24
            Height = 24
            Hint = 'Open'
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              18000000000000060000130B0000130B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3399CC
              00669900669900669900669900669900669900669900669900669900669966CC
              CCFF00FFFF00FFFF00FFFF00FFCCCCCCBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBE
              BEBEBEBEBEBEBEBEBEBEBEBEBEBED6D6D6FF00FFFF00FFFF00FF3399CC3399CC
              99FFFF66CCFF66CCFF66CCFF66CCFF66CCFF66CCFF66CCFF66CCFF3399CC0066
              99FF00FFFF00FFFF00FFCCCCCCCCCCCCE2E2E2D7D7D7D7D7D7D7D7D7D7D7D7D7
              D7D7D7D7D7D7D7D7D7D7D7CCCCCCBEBEBEFF00FFFF00FFFF00FF3399CC3399CC
              66CCFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF66CCFF0066
              993399CCFF00FFFF00FFCCCCCCCCCCCCD7D7D7E2E2E2E2E2E2E2E2E2E2E2E2E2
              E2E2E2E2E2E2E2E2E2E2E2D7D7D7BEBEBECCCCCCFF00FFFF00FF3399CC3399CC
              66CCFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF66CCFF66CC
              CC006699FF00FFFF00FFCCCCCCCCCCCCD7D7D7E2E2E2E2E2E2E2E2E2E2E2E2E2
              E2E2E2E2E2E2E2E2E2E2E2D7D7D7D6D6D6BEBEBEFF00FFFF00FF3399CC66CCFF
              3399CC99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF66CCFF99FF
              FF0066993399CCFF00FFCCCCCCD7D7D7CCCCCCE2E2E2E2E2E2E2E2E2E2E2E2E2
              E2E2E2E2E2E2E2E2E2E2E2D7D7D7E2E2E2BEBEBECCCCCCFF00FF3399CC66CCFF
              66CCCC66CCCC99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF99FFFF66CCFF99FF
              FF66CCCC006699FF00FFCCCCCCD7D7D7D6D6D6D6D6D6E2E2E2E2E2E2E2E2E2E2
              E2E2E2E2E2E2E2E2E2E2E2D7D7D7E2E2E2D6D6D6BEBEBEFF00FF3399CC99FFFF
              66CCFF3399CCCCFFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFFFF99FFFFCCFF
              FFCCFFFF006699FF00FFCCCCCCE2E2E2D7D7D7CCCCCCE2E2E2E2E2E2E2E2E2E2
              E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2BEBEBEFF00FF3399CC99FFFF
              99FFFF66CCFF3399CC3399CC3399CC3399CC3399CC3399CC3399CC3399CC3399
              CC3399CC66CCFFFF00FFCCCCCCE2E2E2E2E2E2D7D7D7CCCCCCCCCCCCCCCCCCCC
              CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCD7D7D7FF00FF3399CCCCFFFF
              99FFFF99FFFF99FFFF99FFFFCCFFFFCCFFFFCCFFFFCCFFFFCCFFFF006699FF00
              FFFF00FFFF00FFFF00FFCCCCCCE2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2
              E2E2E2E2E2E2E2E2E2E2E2BEBEBEFF00FFFF00FFFF00FFFF00FFFF00FF3399CC
              CCFFFFCCFFFFCCFFFFCCFFFF3399CC3399CC3399CC3399CC3399CCFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFCCCCCCE2E2E2E2E2E2E2E2E2E2E2E2CCCCCCCC
              CCCCCCCCCCCCCCCCCCCCCCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              3399CC3399CC3399CC3399CCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FF993300993300993300FF00FFFF00FFCCCCCCCCCCCCCCCCCCCCCCCCFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFAFAFAFAFAFAFAFAFAFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FF993300993300FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAFAFAFAFAFAFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF993300FF00FFFF00FFFF00
              FF993300FF00FF993300FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFAFAFAFFF00FFFF00FFFF00FFAFAFAFFF00FFAFAFAFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9933009933009933
              00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFAFAFAFAFAFAFAFAFAFFF00FFFF00FFFF00FF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
          end
          object ComboBoxCompilerPath: TComboBox
            Left = 5
            Top = 33
            Width = 431
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            OnSelect = ComboBoxCompilerPathSelect
          end
          object GroupBox1: TGroupBox
            Left = 5
            Top = 63
            Width = 461
            Height = 134
            Caption = 'Informations'
            TabOrder = 1
            object LabelCompilerVersion: TLabel
              Left = 51
              Top = 48
              Width = 3
              Height = 13
              Caption = '-'
            end
            object LabelCompilerName: TLabel
              Left = 46
              Top = 24
              Width = 3
              Height = 13
              Caption = '-'
            end
            object LabelMakeVersion: TLabel
              Left = 80
              Top = 107
              Width = 3
              Height = 13
              Caption = '-'
            end
            object LabelCompilerStatus: TLabel
              Left = 280
              Top = 48
              Width = 3
              Height = 13
              Caption = '-'
            end
            object Bevel2: TBevel
              Left = 8
              Top = 72
              Width = 445
              Height = 3
              Shape = bsBottomLine
            end
            object LabelMakeStatus: TLabel
              Left = 280
              Top = 107
              Width = 3
              Height = 13
              Caption = '-'
            end
            object LabelMakeName: TLabel
              Left = 72
              Top = 80
              Width = 3
              Height = 13
              Caption = '-'
            end
            object Label1: TLabel
              Left = 240
              Top = 48
              Width = 33
              Height = 13
              Caption = 'Status:'
            end
            object Label2: TLabel
              Left = 240
              Top = 107
              Width = 33
              Height = 13
              Caption = 'Status:'
            end
            object Label3: TLabel
              Left = 8
              Top = 24
              Width = 31
              Height = 13
              Caption = 'Name:'
            end
            object Label4: TLabel
              Left = 8
              Top = 48
              Width = 38
              Height = 13
              Caption = 'Version:'
            end
            object Label5: TLabel
              Left = 8
              Top = 80
              Width = 59
              Height = 13
              Caption = 'Make name:'
            end
            object Label6: TLabel
              Left = 8
              Top = 107
              Width = 67
              Height = 13
              Caption = 'Make version:'
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Compiler options'
          ImageIndex = 2
          object Label10: TLabel
            Left = 5
            Top = 248
            Width = 56
            Height = 13
            Caption = 'Description:'
          end
          object Label11: TLabel
            Left = 5
            Top = 283
            Width = 51
            Height = 13
            Caption = 'Parameter:'
          end
          object ListView2: TListView
            Left = 4
            Top = 4
            Width = 462
            Height = 229
            Checkboxes = True
            Columns = <
              item
                Caption = 'Description'
                Width = 290
              end
              item
                Caption = 'Parameter'
                Width = 140
              end>
            ColumnClick = False
            GridLines = True
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object Button1: TButton
            Left = 232
            Top = 280
            Width = 75
            Height = 25
            Caption = 'Add'
            TabOrder = 1
            OnClick = BtnOkClick
          end
          object Button2: TButton
            Left = 312
            Top = 280
            Width = 75
            Height = 25
            Caption = 'Edit'
            TabOrder = 2
            OnClick = BtnOkClick
          end
          object Edit1: TEdit
            Left = 69
            Top = 247
            Width = 396
            Height = 21
            TabOrder = 3
          end
          object Edit2: TEdit
            Left = 69
            Top = 282
            Width = 156
            Height = 21
            TabOrder = 4
          end
          object Button5: TButton
            Left = 392
            Top = 280
            Width = 75
            Height = 25
            Caption = 'Remove'
            TabOrder = 5
            OnClick = BtnOkClick
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Linker options'
          ImageIndex = 1
          object Label12: TLabel
            Left = 5
            Top = 248
            Width = 56
            Height = 13
            Caption = 'Description:'
          end
          object Label13: TLabel
            Left = 5
            Top = 283
            Width = 51
            Height = 13
            Caption = 'Parameter:'
          end
          object ListView1: TListView
            Left = 4
            Top = 4
            Width = 462
            Height = 229
            Checkboxes = True
            Columns = <
              item
                Caption = 'Description'
                Width = 290
              end
              item
                Caption = 'Parameter'
                Width = 140
              end>
            ColumnClick = False
            GridLines = True
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object Edit3: TEdit
            Left = 69
            Top = 247
            Width = 396
            Height = 21
            TabOrder = 1
          end
          object Edit4: TEdit
            Left = 69
            Top = 282
            Width = 156
            Height = 21
            TabOrder = 2
          end
          object Button3: TButton
            Left = 232
            Top = 280
            Width = 75
            Height = 25
            Caption = 'Add'
            TabOrder = 3
            OnClick = BtnOkClick
          end
          object Button4: TButton
            Left = 312
            Top = 280
            Width = 75
            Height = 25
            Caption = 'Edit'
            TabOrder = 4
            OnClick = BtnOkClick
          end
          object Button6: TButton
            Left = 392
            Top = 280
            Width = 75
            Height = 25
            Caption = 'Remove'
            TabOrder = 5
            OnClick = BtnOkClick
          end
        end
      end
    end
    object TSDebugger: TTabSheet
      Caption = 'Debugger'
      ImageIndex = 3
      object GroupBox2: TGroupBox
        Left = 5
        Top = 10
        Width = 476
        Height = 74
        Caption = 'Informations'
        TabOrder = 0
        object LabelDebugName: TLabel
          Left = 48
          Top = 21
          Width = 3
          Height = 13
          Caption = '-'
        end
        object LabelDebugVersion: TLabel
          Left = 53
          Top = 45
          Width = 3
          Height = 13
          Caption = '-'
        end
        object LabelDebugStatus: TLabel
          Left = 280
          Top = 45
          Width = 3
          Height = 13
          Caption = '-'
        end
        object Label7: TLabel
          Left = 8
          Top = 45
          Width = 38
          Height = 13
          Caption = 'Version:'
        end
        object Label8: TLabel
          Left = 8
          Top = 21
          Width = 31
          Height = 13
          Caption = 'Name:'
        end
        object Label9: TLabel
          Left = 240
          Top = 45
          Width = 33
          Height = 13
          Caption = 'Status:'
        end
      end
    end
    object TSDirectories: TTabSheet
      Caption = 'Directories'
      ImageIndex = 1
    end
    object TSPrograms: TTabSheet
      Caption = 'Programs'
      ImageIndex = 2
    end
  end
  object BtnOk: TButton
    Left = 268
    Top = 442
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 348
    Top = 442
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object BtnApply: TButton
    Left = 428
    Top = 442
    Width = 75
    Height = 25
    Caption = 'Apply'
    Enabled = False
    TabOrder = 3
    OnClick = BtnApplyClick
  end
end
