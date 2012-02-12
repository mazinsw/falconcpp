object FrmEditorOptions: TFrmEditorOptions
  Left = 524
  Top = 312
  BorderStyle = bsDialog
  Caption = 'Editor Options'
  ClientHeight = 428
  ClientWidth = 460
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
    Width = 449
    Height = 385
    ActivePage = TSGeneral
    TabOrder = 0
    object TSGeneral: TTabSheet
      Caption = 'General'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 2
        Width = 432
        Height = 161
        Caption = 'Editor Options'
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 114
          Width = 49
          Height = 13
          Caption = 'Max Undo'
        end
        object Label16: TLabel
          Left = 224
          Top = 114
          Width = 53
          Height = 13
          Caption = 'Tab Width:'
        end
        object ChbAutoIndt: TCheckBox
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Auto Indent'
          TabOrder = 0
          OnClick = EditorOptionsChanged
        end
        object ChbUseTabChar: TCheckBox
          Left = 224
          Top = 64
          Width = 137
          Height = 17
          Caption = 'Use Tab Character'
          TabOrder = 1
          OnClick = EditorOptionsChanged
        end
        object ChbTabUnOrIndt: TCheckBox
          Left = 224
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Tab Indent/Unindent'
          TabOrder = 2
          OnClick = EditorOptionsChanged
        end
        object ChbInsMode: TCheckBox
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'Insert Mode'
          TabOrder = 3
          OnClick = EditorOptionsChanged
        end
        object ChbGrpUnd: TCheckBox
          Left = 8
          Top = 64
          Width = 137
          Height = 17
          Caption = 'Group Undo'
          TabOrder = 4
          OnClick = EditorOptionsChanged
        end
        object CboMaxUnd: TComboBox
          Left = 8
          Top = 131
          Width = 81
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = '1024'
          OnChange = EditorOptionsChanged
          Items.Strings = (
            '1024')
        end
        object CboTabWdt: TComboBox
          Left = 224
          Top = 130
          Width = 81
          Height = 21
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 6
          Text = '4'
          OnChange = EditorOptionsChanged
          Items.Strings = (
            '2'
            '4'
            '8')
        end
        object ChbFindTextAtCursor: TCheckBox
          Left = 8
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Find text at cursor'
          TabOrder = 7
          OnClick = EditorOptionsChanged
        end
        object ChbSmartTabs: TCheckBox
          Left = 224
          Top = 48
          Width = 137
          Height = 17
          Caption = 'Smart Tabs'
          TabOrder = 8
          OnClick = EditorOptionsChanged
        end
        object ChbScrollHint: TCheckBox
          Left = 224
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Scroll Hint'
          TabOrder = 9
          OnClick = EditorOptionsChanged
        end
        object ChbEnhHomeKey: TCheckBox
          Left = 224
          Top = 80
          Width = 137
          Height = 17
          Caption = 'Enhanced Home Key'
          TabOrder = 10
          OnClick = EditorOptionsChanged
        end
        object ChbKeepTraiSpa: TCheckBox
          Left = 8
          Top = 80
          Width = 137
          Height = 17
          Caption = 'Keep Trailing Spaces'
          TabOrder = 11
          OnClick = EditorOptionsChanged
        end
        object ChbShowLineChars: TCheckBox
          Left = 8
          Top = 96
          Width = 137
          Height = 17
          Caption = 'Show Line Characters'
          TabOrder = 12
          OnClick = EditorOptionsChanged
        end
      end
      object GroupBoxHlMatchBP: TGroupBox
        Left = 4
        Top = 176
        Width = 432
        Height = 66
        Caption = '      Highligth matching braces/parentheses'
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 13
          Caption = 'Normal Color'
          Enabled = False
        end
        object Label2: TLabel
          Left = 160
          Top = 18
          Width = 49
          Height = 13
          Caption = 'Error Color'
          Enabled = False
        end
        object Label3: TLabel
          Left = 312
          Top = 18
          Width = 85
          Height = 13
          Caption = 'Background Color'
          Enabled = False
        end
        object ChbHighMatch: TCheckBox
          Left = 9
          Top = -1
          Width = 205
          Height = 17
          TabOrder = 0
          OnClick = GroupEnableBoxDisableControls
        end
        object ClbN: TColorBox
          Left = 8
          Top = 34
          Width = 113
          Height = 22
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          Enabled = False
          ItemHeight = 16
          TabOrder = 1
          OnChange = EditorOptionsChanged
        end
        object ClbE: TColorBox
          Left = 160
          Top = 34
          Width = 113
          Height = 22
          Selected = clRed
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          Enabled = False
          ItemHeight = 16
          TabOrder = 2
          OnChange = EditorOptionsChanged
        end
        object ClbB: TColorBox
          Left = 312
          Top = 34
          Width = 113
          Height = 22
          Selected = clSkyBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          Enabled = False
          ItemHeight = 16
          TabOrder = 3
          OnChange = EditorOptionsChanged
        end
      end
      object GroupBox3: TGroupBox
        Left = 4
        Top = 253
        Width = 181
        Height = 66
        Caption = '      Highligth current line'
        TabOrder = 2
        object Label4: TLabel
          Left = 8
          Top = 18
          Width = 24
          Height = 13
          Caption = 'Color'
          Enabled = False
        end
        object ChbHighCurLn: TCheckBox
          Left = 9
          Top = -1
          Width = 205
          Height = 17
          TabOrder = 0
          OnClick = GroupEnableBoxDisableControls
        end
        object ClbCurLn: TColorBox
          Left = 8
          Top = 34
          Width = 113
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          Enabled = False
          ItemHeight = 16
          TabOrder = 1
          OnChange = EditorOptionsChanged
        end
      end
      object GroupBox4: TGroupBox
        Left = 272
        Top = 253
        Width = 164
        Height = 66
        Caption = '      Link click'
        TabOrder = 3
        object Label5: TLabel
          Left = 8
          Top = 18
          Width = 24
          Height = 13
          Caption = 'Color'
          Enabled = False
        end
        object ChbLinkClick: TCheckBox
          Left = 9
          Top = -1
          Width = 205
          Height = 17
          TabOrder = 0
          OnClick = GroupEnableBoxDisableControls
        end
        object ClbLinkColor: TColorBox
          Left = 8
          Top = 34
          Width = 113
          Height = 22
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          Enabled = False
          ItemHeight = 16
          TabOrder = 1
          OnChange = EditorOptionsChanged
        end
      end
      object BtnRestDef: TButton
        Left = 328
        Top = 326
        Width = 108
        Height = 25
        Caption = 'Restore Default'
        TabOrder = 4
        OnClick = BtnRestDefClick
      end
    end
    object TSDisplay: TTabSheet
      Caption = 'Display'
      ImageIndex = 1
      object Label9: TLabel
        Left = 296
        Top = 16
        Width = 23
        Height = 13
        Caption = 'Size:'
      end
      object Label10: TLabel
        Left = 8
        Top = 64
        Width = 38
        Height = 13
        Caption = 'Sample:'
      end
      object Label11: TLabel
        Left = 72
        Top = 16
        Width = 51
        Height = 13
        Caption = 'Editor font:'
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 184
        Width = 423
        Height = 98
        Caption = 'Margin and gutter'
        TabOrder = 0
        object Label7: TLabel
          Left = 184
          Top = 16
          Width = 62
          Height = 13
          Caption = 'Right margin:'
        end
        object Label8: TLabel
          Left = 288
          Top = 16
          Width = 60
          Height = 13
          Caption = 'Gutter width:'
        end
        object ChbShowgtt: TCheckBox
          Left = 8
          Top = 35
          Width = 129
          Height = 17
          Caption = 'Show gutter'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = EditorOptionsChanged
        end
        object ChbShowRMrgn: TCheckBox
          Left = 8
          Top = 16
          Width = 129
          Height = 17
          Caption = 'Show right margin'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = EditorOptionsChanged
        end
        object CboRMrg: TComboBox
          Left = 184
          Top = 32
          Width = 65
          Height = 21
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 2
          Text = '80'
          OnChange = EditorOptionsChanged
          Items.Strings = (
            '80')
        end
        object CboGutterWdt: TComboBox
          Left = 288
          Top = 32
          Width = 65
          Height = 21
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 3
          Text = '30'
          OnChange = EditorOptionsChanged
          Items.Strings = (
            '30')
        end
        object ChbShowLnNumb: TCheckBox
          Left = 8
          Top = 55
          Width = 129
          Height = 17
          Caption = 'Show line number'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = EditorOptionsChanged
        end
        object ChbGrdGutt: TCheckBox
          Left = 8
          Top = 75
          Width = 129
          Height = 17
          Caption = 'Gradient gutter'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = EditorOptionsChanged
        end
      end
      object PanelTest: TPanel
        Left = 8
        Top = 80
        Width = 425
        Height = 81
        BevelOuter = bvLowered
        Caption = 'AaBbYyZz'
        TabOrder = 1
      end
      object CboSize: TComboBox
        Left = 296
        Top = 32
        Width = 65
        Height = 21
        ItemHeight = 0
        TabOrder = 2
        Text = '10'
        OnChange = CboSizeChange
      end
      object CboEditFont: TComboBox
        Left = 72
        Top = 32
        Width = 185
        Height = 21
        ItemHeight = 0
        TabOrder = 3
        OnSelect = CboEditFontSelect
      end
      object Button1: TButton
        Left = 328
        Top = 326
        Width = 108
        Height = 25
        Caption = 'Restore Default'
        TabOrder = 4
        OnClick = Button1Click
      end
    end
    object TSSintax: TTabSheet
      Caption = 'Colors'
      ImageIndex = 2
      object Label12: TLabel
        Left = 264
        Top = 8
        Width = 70
        Height = 13
        Caption = 'Defined sintax:'
      end
      object BtnSave: TSpeedButton
        Left = 385
        Top = 23
        Width = 22
        Height = 22
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
        OnClick = BtnSaveClick
      end
      object BtnDel: TSpeedButton
        Left = 409
        Top = 23
        Width = 22
        Height = 22
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
        OnClick = BtnDelClick
      end
      object Label13: TLabel
        Left = 4
        Top = 8
        Width = 27
        Height = 13
        Caption = 'Type:'
      end
      object Label14: TLabel
        Left = 152
        Top = 48
        Width = 54
        Height = 13
        Caption = 'Foreground'
      end
      object Label15: TLabel
        Left = 152
        Top = 105
        Width = 58
        Height = 13
        Caption = 'Background'
      end
      object GroupBox6: TGroupBox
        Left = 319
        Top = 58
        Width = 113
        Height = 84
        Caption = 'Styles'
        TabOrder = 0
        object ChbBold: TCheckBox
          Left = 8
          Top = 18
          Width = 97
          Height = 17
          Caption = 'Bold'
          TabOrder = 0
          OnClick = StyleChangeClick
        end
        object ChbItalic: TCheckBox
          Left = 8
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Italic'
          TabOrder = 1
          OnClick = StyleChangeClick
        end
        object ChbUnderl: TCheckBox
          Left = 8
          Top = 62
          Width = 97
          Height = 17
          Caption = 'Underlined'
          TabOrder = 2
          OnClick = StyleChangeClick
        end
      end
      object CbDefSin: TComboBox
        Left = 264
        Top = 24
        Width = 114
        Height = 21
        AutoComplete = False
        ItemHeight = 0
        MaxLength = 48
        TabOrder = 1
        OnSelect = CbDefSinSelect
      end
      object SynPrev: TSynMemo
        Left = 6
        Top = 152
        Width = 427
        Height = 195
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 2
        OnMouseDown = SynPrevMouseDown
        BracketHighlight.Background = clSkyBlue
        BracketHighlight.Foreground = clGray
        BracketHighlight.AloneBackground = clNone
        BracketHighlight.AloneForeground = clRed
        BracketHighlight.Style = [fsBold]
        BracketHighlight.AloneStyle = [fsBold]
        LinkOptions.Color = clBlue
        LinkOptions.AttributeList.Strings = (
          'Preprocessor'
          'Identifier')
        LinkEnable = True
        Gutter.DigitCount = 2
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 6
        Gutter.ShowLineNumbers = True
        HideSelection = True
        Highlighter = SynCpp
        Lines.Strings = (
          '//Sintax Preview'
          '#include <stdio.h>'
          ''
          'int main(int argc, char *args[])'
          '{'
          '    int name[10] = "Falcon C++";'
          '    name[0] = '#39'F'#39';'
          '    return (0x00 * 0765);'
          '}'
          '//Selected Text')
        Options = [eoAutoIndent, eoDisableScrollArrows, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoHideShowScrollbars, eoNoCaret, eoNoSelection, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
        ReadOnly = True
        ScrollBars = ssNone
        OnGutterClick = SynPrevGutterClick
        OnSpecialLineColors = SynPrevSpecialLineColors
      end
      object ListBoxType: TListBox
        Left = 6
        Top = 24
        Width = 139
        Height = 121
        ItemHeight = 13
        TabOrder = 3
        OnClick = ListBoxTypeClick
      end
      object ClbFore: TColorBox
        Left = 152
        Top = 64
        Width = 113
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 4
        OnChange = ColorChange
      end
      object ClbBack: TColorBox
        Left = 152
        Top = 121
        Width = 113
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 5
        OnChange = ColorChange
      end
    end
    object TSFormatter: TTabSheet
      Caption = 'Formatter'
      ImageIndex = 4
      object PageControl2: TPageControl
        Left = 6
        Top = 6
        Width = 429
        Height = 344
        ActivePage = TSFormatterStyle
        TabOrder = 0
        object TSFormatterStyle: TTabSheet
          Caption = 'Style'
          object GroupBoxFormatterSample: TGroupBox
            Left = 124
            Top = 3
            Width = 289
            Height = 304
            Caption = 'Sample'
            TabOrder = 0
            object SynMemoSample: TSynMemo
              Left = 10
              Top = 16
              Width = 269
              Height = 277
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              TabOrder = 0
              OnMouseDown = SynPrevMouseDown
              BracketHighlight.Background = clSkyBlue
              BracketHighlight.Foreground = clGray
              BracketHighlight.AloneBackground = clNone
              BracketHighlight.AloneForeground = clRed
              BracketHighlight.Style = [fsBold]
              BracketHighlight.AloneStyle = [fsBold]
              LinkOptions.Color = clBlue
              LinkOptions.AttributeList.Strings = (
                'Preprocessor'
                'Identifier')
              LinkEnable = True
              Gutter.DigitCount = 2
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.LeftOffset = 6
              Gutter.ShowLineNumbers = True
              Gutter.Visible = False
              HideSelection = True
              Highlighter = SynCpp
              Lines.Strings = (
                'namespace foospace'
                '{'
                '    int Foo()'
                '    {'
                '        if (isBar)'
                '        {'
                '            bar();'
                '            return 1;'
                '        }'
                '        else'
                '            return 0;'
                '    }'
                '}')
              Options = [eoAutoIndent, eoDisableScrollArrows, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoHideShowScrollbars, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
              ScrollBars = ssNone
              OnGutterClick = SynPrevGutterClick
              OnSpecialLineColors = SynPrevSpecialLineColors
            end
          end
          object RadioGroupFormatterStyles: TRadioGroup
            Left = 6
            Top = 3
            Width = 109
            Height = 137
            Caption = 'Styles'
            ItemIndex = 0
            Items.Strings = (
              'ANSI'
              'K&&R'
              'Linux'
              'GNU'
              'Java'
              'Custom')
            TabOrder = 1
            OnClick = RadioGroupFormatterStylesClick
          end
          object BtnPrevStyle: TButton
            Left = 3
            Top = 283
            Width = 114
            Height = 25
            Caption = 'Preview'
            TabOrder = 2
            Visible = False
          end
        end
        object TSFormatterIndentation: TTabSheet
          Caption = 'Indentation'
          ImageIndex = 1
          object CheckBoxForceUsingTabs: TCheckBox
            Left = 6
            Top = 8
            Width = 147
            Height = 17
            Caption = 'Force using TABs'
            TabOrder = 0
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentClasses: TCheckBox
            Left = 6
            Top = 32
            Width = 339
            Height = 17
            Caption = 'Indent classes (keywords public:, protected: and private:)'
            TabOrder = 1
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentSwitches: TCheckBox
            Left = 6
            Top = 56
            Width = 211
            Height = 17
            Caption = 'Indent switches (keyword case:)'
            TabOrder = 2
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentCase: TCheckBox
            Left = 6
            Top = 80
            Width = 339
            Height = 17
            Caption = 'Indent case: statements in switches (commands case:)'
            TabOrder = 3
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentBrackets: TCheckBox
            Left = 6
            Top = 104
            Width = 155
            Height = 17
            Caption = 'Indent brackets'
            TabOrder = 4
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentBlocks: TCheckBox
            Left = 6
            Top = 128
            Width = 155
            Height = 17
            Caption = 'Indent blocks'
            TabOrder = 5
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentNamespaces: TCheckBox
            Left = 6
            Top = 152
            Width = 155
            Height = 17
            Caption = 'Indent namespaces'
            TabOrder = 6
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentLabels: TCheckBox
            Left = 6
            Top = 176
            Width = 155
            Height = 17
            Caption = 'Indent labels'
            TabOrder = 7
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentMultLinePreprocessor: TCheckBox
            Left = 6
            Top = 200
            Width = 339
            Height = 17
            Caption = 'Indent mult-line preprocessor definitions'
            TabOrder = 8
            OnClick = EditorOptionsChanged
          end
        end
        object TSFormatterFormatting: TTabSheet
          Caption = 'Formatting'
          ImageIndex = 2
          object LabelBracketsStyle: TLabel
            Left = 6
            Top = 8
            Width = 69
            Height = 13
            Caption = 'Brackets style:'
          end
          object ComboBoxBracketStyle: TComboBox
            Left = 104
            Top = 6
            Width = 137
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = 'None'
            OnChange = ComboBoxBracketStyleChange
            Items.Strings = (
              'None'
              'Break'
              'Attach'
              'Linux')
          end
          object CheckBoxBreakClosingHeaders: TCheckBox
            Left = 6
            Top = 40
            Width = 147
            Height = 17
            Caption = 'Break closing headers'
            TabOrder = 1
            OnClick = EditorOptionsChanged
          end
          object CheckBoxPadEmptyLines: TCheckBox
            Left = 6
            Top = 64
            Width = 339
            Height = 17
            Caption = 'Pad empty lines around header blocks ('#39'if'#39', '#39'while'#39', ..)'
            TabOrder = 2
            OnClick = EditorOptionsChanged
          end
          object CheckBoxBreakElseIf: TCheckBox
            Left = 6
            Top = 88
            Width = 339
            Height = 17
            Caption = 'Break '#39'else if()'#39' header combinations into separate lines'
            TabOrder = 3
            OnClick = EditorOptionsChanged
          end
          object CheckBoxInsertSpacePaddingOperators: TCheckBox
            Left = 6
            Top = 112
            Width = 283
            Height = 17
            Caption = 'Insert space padding around operators'
            TabOrder = 4
            OnClick = EditorOptionsChanged
          end
          object CheckBoxInsertSpacePaddingParenthesisOutside: TCheckBox
            Left = 6
            Top = 136
            Width = 339
            Height = 17
            Caption = 'Insert space padding around parenthesis on the outside'
            TabOrder = 5
            OnClick = EditorOptionsChanged
          end
          object CheckBoxInsertSpacePaddingParenthesisInside: TCheckBox
            Left = 6
            Top = 160
            Width = 339
            Height = 17
            Caption = 'Insert space padding around parenthesis on the inside'
            TabOrder = 6
            OnClick = EditorOptionsChanged
          end
          object CheckBoxRemoveExtraSpace: TCheckBox
            Left = 6
            Top = 184
            Width = 331
            Height = 17
            Caption = 'Remove extra space padding around parenthesis'
            TabOrder = 7
            OnClick = EditorOptionsChanged
          end
          object CheckBoxDontBreakComplex: TCheckBox
            Left = 6
            Top = 208
            Width = 408
            Height = 17
            Caption = 
              'Don'#39't break complex statements and multiple statements residing ' +
              'in a single line'
            TabOrder = 8
            OnClick = EditorOptionsChanged
          end
          object CheckBoxDontBreakOneLineBlocks: TCheckBox
            Left = 6
            Top = 232
            Width = 219
            Height = 17
            Caption = 'Don'#39't break one-line blocks'
            TabOrder = 9
            OnClick = EditorOptionsChanged
          end
          object CheckBoxConvToSpaces: TCheckBox
            Left = 6
            Top = 256
            Width = 187
            Height = 17
            Caption = 'Convert TABs to spaces'
            TabOrder = 10
            OnClick = EditorOptionsChanged
          end
          object CheckBoxFillEmpyLines: TCheckBox
            Left = 6
            Top = 280
            Width = 411
            Height = 17
            Caption = 'Fill empty lines with the whitespace of their previous lines'
            TabOrder = 11
            OnClick = EditorOptionsChanged
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Code Resources'
      ImageIndex = 3
      object GroupBox8: TGroupBox
        Left = 8
        Top = 4
        Width = 423
        Height = 105
        Caption = 'Automatic features'
        TabOrder = 0
        object LblDelay: TLabel
          Left = 216
          Top = 24
          Width = 30
          Height = 13
          Caption = '&Delay:'
        end
        object LblSecStart: TLabel
          Left = 212
          Top = 72
          Width = 35
          Height = 13
          Caption = '0.1 sec'
        end
        object LblSecEnd: TLabel
          Left = 358
          Top = 72
          Width = 35
          Height = 13
          Caption = '1.5 sec'
        end
        object ChbCodeCompletion: TCheckBox
          Left = 8
          Top = 22
          Width = 161
          Height = 17
          Caption = 'Code completion'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = EditorOptionsChanged
        end
        object ChbCodeParameters: TCheckBox
          Left = 8
          Top = 40
          Width = 161
          Height = 17
          Caption = 'Code parameters'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = EditorOptionsChanged
        end
        object ChbTooltipSymbol: TCheckBox
          Left = 8
          Top = 76
          Width = 97
          Height = 17
          Caption = 'Tooltip symbol'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = EditorOptionsChanged
        end
        object ChbTooltopexev: TCheckBox
          Left = 8
          Top = 58
          Width = 161
          Height = 17
          Caption = 'Tooltip expression evaluation'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = EditorOptionsChanged
        end
        object TrackBarCodeRes: TTrackBar
          Left = 208
          Top = 40
          Width = 169
          Height = 33
          Max = 14
          PageSize = 1
          Position = 2
          TabOrder = 4
          OnChange = TrackBarCodeResChange
        end
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 120
        Width = 423
        Height = 129
        Caption = 'Completion List Colors'
        TabOrder = 1
        object Label17: TLabel
          Left = 5
          Top = 24
          Width = 93
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Constant Symbol:'
        end
        object Label18: TLabel
          Left = 17
          Top = 48
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = 'Function Symbol:'
        end
        object Label19: TLabel
          Left = 20
          Top = 72
          Width = 78
          Height = 13
          Alignment = taRightJustify
          Caption = '&Variable Symbol:'
        end
        object Label20: TLabel
          Left = 34
          Top = 96
          Width = 64
          Height = 13
          Alignment = taRightJustify
          Caption = 'Type Symbol:'
        end
        object Label21: TLabel
          Left = 241
          Top = 48
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = 'Preprocessor:'
        end
        object Label22: TLabel
          Left = 245
          Top = 96
          Width = 61
          Height = 13
          Alignment = taRightJustify
          Caption = 'Background:'
        end
        object Label23: TLabel
          Left = 261
          Top = 72
          Width = 45
          Height = 13
          Alignment = taRightJustify
          Caption = 'Selected:'
        end
        object Label24: TLabel
          Left = 213
          Top = 24
          Width = 93
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Typedef Symbol:'
        end
        object ClbCompListConst: TColorBox
          Left = 102
          Top = 21
          Width = 107
          Height = 22
          Selected = clGreen
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 0
          OnChange = EditorOptionsChanged
        end
        object ClbCompListFunc: TColorBox
          Left = 102
          Top = 45
          Width = 107
          Height = 22
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 1
          OnChange = EditorOptionsChanged
        end
        object ClbCompListVar: TColorBox
          Left = 102
          Top = 69
          Width = 107
          Height = 22
          Selected = clMaroon
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 2
          OnChange = EditorOptionsChanged
        end
        object ClbCompListType: TColorBox
          Left = 102
          Top = 93
          Width = 107
          Height = 22
          Selected = clOlive
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 3
          OnChange = EditorOptionsChanged
        end
        object ClbCompListPreproc: TColorBox
          Left = 310
          Top = 45
          Width = 107
          Height = 22
          Selected = clGreen
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 4
          OnChange = EditorOptionsChanged
        end
        object ClbCompListBg: TColorBox
          Left = 310
          Top = 93
          Width = 107
          Height = 22
          Selected = clWindow
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 5
          OnChange = EditorOptionsChanged
        end
        object ClbCompListSel: TColorBox
          Left = 310
          Top = 69
          Width = 107
          Height = 22
          Selected = clHighlight
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 6
          OnChange = EditorOptionsChanged
        end
        object ClbCompListTypedef: TColorBox
          Left = 310
          Top = 21
          Width = 107
          Height = 22
          Selected = clMaroon
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 7
          OnChange = EditorOptionsChanged
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 264
        Width = 425
        Height = 81
        Caption = 'Code Templates'
        TabOrder = 2
        object Label25: TLabel
          Left = 8
          Top = 18
          Width = 132
          Height = 13
          Caption = 'Custom Code Template File:'
        end
        object BtnEditCodeTemplate: TSpeedButton
          Left = 394
          Top = 33
          Width = 24
          Height = 24
          Hint = 'Edit'
          Enabled = False
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00333333003333
            330099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00666666006666
            660099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CCCCCC006666
            66003333330033333300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00999999008080
            80006666660066666600FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF006666
            660066666600666666003333330099999900FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008080
            800080808000808080006666660099999900FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CCCC
            CC006666660066666600666666003333330000999900FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF009999
            99008080800080808000808080006666660099999900FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00666666006666660099FFFF0099CCCC0099CCCC0000999900FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF008080800080808000E5E5E500CCCCCC00CCCCCC0099999900FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00CCCCCC0080808000CCFFFF0099FFFF0099CCCC0099CCCC000099990099CC
            CC00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF009999990080808000E5E5E500E5E5E500CCCCCC00CCCCCC0099999900CCCC
            CC00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF0066CCCC00FFFFFF00CCFFFF0099FFFF0099FFFF0099CCCC0066CC
            CC0000999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00CCCCCC00FFFFFF00E5E5E500E5E5E500E5E5E500CCCCCC00CCCC
            CC0099999900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF0066CCCC00FFFFFF00CCFFFF00CCFFFF0099FFFF0099FFFF0099CC
            CC0099CCCC000099990066CCCC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00CCCCCC00FFFFFF00E5E5E500E5E5E500E5E5E500E5E5E500CCCC
            CC00CCCCCC0099999900CCCCCC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0099CCCC00FFFFFF00CCFFFF00CCFFFF0099FFFF0099FF
            FF0099CCCC00FFCCCC009933000099330000FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00CCCCCC00FFFFFF00E5E5E500E5E5E500E5E5E500E5E5
            E500CCCCCC00CCCCCC006666660066666600FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF0066CCCC00FFFFFF00CCFFFF00CCFFFF00FFCCCC00CC66
            0000CC66000099330000993300009933000099330000FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00CCCCCC00FFFFFF00E5E5E500E5E5E500CCCCCC008080
            80008080800066666600666666006666660066666600FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF0099CCCC00FFFFFF00CCFFFF00CC660000CC66
            0000CC660000CC66000099330000993300009933000099330000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00CCCCCC00FFFFFF00E5E5E500808080008080
            8000808080008080800066666600666666006666660066666600FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF0066CCCC00FFFFFF00FFCCCC00CC660000CC66
            0000CC660000CC660000CC660000993300009933000099330000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00CCCCCC00FFFFFF00CCCCCC00808080008080
            8000808080008080800080808000666666006666660066666600FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF990000FF990000CC660000CC66
            0000CC660000CC660000CC660000CC6600009933000099330000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF009999990099999900808080008080
            8000808080008080800080808000808080006666660066666600FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00CC660000FF990000FF990000CC66
            0000CC660000CC660000CC660000CC660000CC66000099330000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF006666660099999900999999008080
            8000808080008080800080808000808080008080800066666600FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CC660000FF990000FF99
            0000CC660000CC660000CC660000CC660000CC660000CC660000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0066666600999999009999
            9900808080008080800080808000808080008080800080808000}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = BtnEditCodeTemplateClick
        end
        object BtnChooseCodeTemplate: TSpeedButton
          Left = 366
          Top = 33
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
          OnClick = BtnChooseCodeTemplateClick
        end
        object EditCodeTemplate: TEdit
          Left = 8
          Top = 34
          Width = 353
          Height = 21
          TabOrder = 0
          OnChange = EditCodeTemplateChange
        end
      end
    end
  end
  object BtnOk: TButton
    Left = 220
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 300
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object BtnApply: TButton
    Left = 380
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Apply'
    Enabled = False
    TabOrder = 3
    OnClick = BtnApplyClick
  end
  object SynCpp: TSynCppSyn
    Left = 72
    Top = 396
  end
  object TimerNormalDelay: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerNormalDelayTimer
    Left = 40
    Top = 396
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.txt'
    Filter = 
      'Text Files(*.txt)|*.txt|Code Templates(*.ct)|*.ct|All files(*.*)' +
      '|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofNoNetworkButton, ofEnableSizing, ofDontAddToRecent]
    Left = 8
    Top = 396
  end
end
