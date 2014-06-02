object FrmEditorOptions: TFrmEditorOptions
  Left = 463
  Top = 205
  BorderStyle = bsDialog
  Caption = 'Editor Options'
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
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 497
    Height = 428
    ActivePage = TSGeneral
    TabOrder = 0
    object TSGeneral: TTabSheet
      Caption = 'General'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 2
        Width = 477
        Height = 199
        Caption = 'Editor Options'
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 152
          Width = 49
          Height = 13
          Caption = 'Max Undo'
        end
        object Label16: TLabel
          Left = 248
          Top = 152
          Width = 53
          Height = 13
          Caption = 'Tab Width:'
        end
        object ChbAutoIndt: TCheckBox
          Left = 8
          Top = 16
          Width = 220
          Height = 17
          Caption = 'Auto Indent'
          TabOrder = 0
          OnClick = EditorOptionsChanged
        end
        object ChbUseTabChar: TCheckBox
          Left = 248
          Top = 64
          Width = 220
          Height = 17
          Caption = 'Use Tab Character'
          TabOrder = 1
          OnClick = EditorOptionsChanged
        end
        object ChbTabUnOrIndt: TCheckBox
          Left = 248
          Top = 32
          Width = 220
          Height = 17
          Caption = 'Tab Indent/Unindent'
          TabOrder = 2
          OnClick = EditorOptionsChanged
        end
        object ChbInsMode: TCheckBox
          Left = 8
          Top = 32
          Width = 220
          Height = 17
          Caption = 'Insert Mode'
          TabOrder = 3
          OnClick = EditorOptionsChanged
        end
        object ChbGrpUnd: TCheckBox
          Left = 8
          Top = 48
          Width = 220
          Height = 17
          Caption = 'Group Undo'
          TabOrder = 4
          OnClick = EditorOptionsChanged
        end
        object CboMaxUnd: TComboBox
          Left = 8
          Top = 169
          Width = 81
          Height = 21
          ItemHeight = 13
          MaxLength = 10
          TabOrder = 5
          Text = '1024'
          OnChange = EditorOptionsChanged
          Items.Strings = (
            '1024')
        end
        object CboTabWdt: TComboBox
          Left = 248
          Top = 168
          Width = 81
          Height = 21
          ItemHeight = 13
          ItemIndex = 1
          MaxLength = 2
          TabOrder = 6
          Text = '4'
          OnChange = EditorOptionsChanged
          Items.Strings = (
            '2'
            '4'
            '8')
        end
        object ChbSmartTabs: TCheckBox
          Left = 248
          Top = 48
          Width = 220
          Height = 17
          Caption = 'Smart Tabs'
          TabOrder = 7
          OnClick = EditorOptionsChanged
        end
        object ChbScrollHint: TCheckBox
          Left = 248
          Top = 16
          Width = 220
          Height = 17
          Caption = 'Scroll Hint'
          TabOrder = 8
          OnClick = EditorOptionsChanged
        end
        object ChbEnhHomeKey: TCheckBox
          Left = 248
          Top = 80
          Width = 220
          Height = 17
          Caption = 'Enhanced Home Key'
          TabOrder = 9
          OnClick = EditorOptionsChanged
        end
        object ChbKeepTraiSpa: TCheckBox
          Left = 8
          Top = 64
          Width = 220
          Height = 17
          Caption = 'Keep Trailing Spaces'
          TabOrder = 10
          OnClick = EditorOptionsChanged
        end
        object ChbShowSpaceChars: TCheckBox
          Left = 8
          Top = 80
          Width = 220
          Height = 17
          Caption = 'Show Space and Tab Characters'
          TabOrder = 11
          OnClick = EditorOptionsChanged
        end
        object ChbAutoCloseBrackets: TCheckBox
          Left = 8
          Top = 96
          Width = 220
          Height = 17
          Caption = 'Auto close brackets/parentheses'
          TabOrder = 12
          OnClick = EditorOptionsChanged
        end
        object ChbCursorPastEOL: TCheckBox
          Left = 248
          Top = 96
          Width = 220
          Height = 17
          Caption = 'Cursor past EOL'
          TabOrder = 13
          OnClick = EditorOptionsChanged
        end
      end
      object GroupBoxHlMatchBP: TGroupBox
        Left = 4
        Top = 216
        Width = 477
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
          Left = 184
          Top = 18
          Width = 49
          Height = 13
          Caption = 'Error Color'
          Enabled = False
        end
        object Label3: TLabel
          Left = 355
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
          Left = 184
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
          Left = 355
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
        Top = 293
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
          Left = 10
          Top = 34
          Width = 161
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          Enabled = False
          ItemHeight = 16
          TabOrder = 1
          OnChange = EditorOptionsChanged
        end
      end
      object GroupBox4: TGroupBox
        Left = 317
        Top = 293
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
          Left = 10
          Top = 34
          Width = 145
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
        Left = 375
        Top = 369
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
        Width = 473
        Height = 103
        Caption = 'Margin and gutter'
        TabOrder = 0
        object Label7: TLabel
          Left = 288
          Top = 16
          Width = 62
          Height = 13
          Caption = 'Right margin:'
        end
        object Label8: TLabel
          Left = 288
          Top = 56
          Width = 60
          Height = 13
          Caption = 'Gutter width:'
        end
        object ChbShowgtt: TCheckBox
          Left = 8
          Top = 35
          Width = 169
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
          Width = 169
          Height = 17
          Caption = 'Show right margin'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = EditorOptionsChanged
        end
        object CboRMrg: TComboBox
          Left = 288
          Top = 32
          Width = 177
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
          Top = 72
          Width = 177
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
          Width = 169
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
          Width = 169
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
        Width = 473
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
        ItemHeight = 13
        TabOrder = 2
        Text = '10'
        OnChange = CboSizeChange
      end
      object CboEditFont: TComboBox
        Left = 72
        Top = 32
        Width = 185
        Height = 21
        ItemHeight = 13
        TabOrder = 3
        OnSelect = CboEditFontSelect
      end
      object Button1: TButton
        Left = 375
        Top = 369
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
        Left = 312
        Top = 8
        Width = 70
        Height = 13
        Caption = 'Defined sintax:'
      end
      object BtnSave: TSpeedButton
        Left = 433
        Top = 23
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
        OnClick = BtnSaveClick
      end
      object BtnDel: TSpeedButton
        Left = 457
        Top = 23
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
        Left = 184
        Top = 48
        Width = 54
        Height = 13
        Caption = 'Foreground'
      end
      object Label15: TLabel
        Left = 184
        Top = 105
        Width = 58
        Height = 13
        Caption = 'Background'
      end
      object GroupBox6: TGroupBox
        Left = 367
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
        Left = 312
        Top = 24
        Width = 114
        Height = 21
        AutoComplete = False
        ItemHeight = 13
        MaxLength = 48
        TabOrder = 1
        OnSelect = CbDefSinSelect
      end
      object ListBoxType: TListBox
        Left = 6
        Top = 24
        Width = 171
        Height = 121
        ItemHeight = 13
        TabOrder = 2
        OnClick = ListBoxTypeClick
      end
      object ClbFore: TColorBox
        Left = 184
        Top = 64
        Width = 129
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 3
        OnChange = ColorChange
      end
      object ClbBack: TColorBox
        Left = 184
        Top = 121
        Width = 129
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 4
        OnChange = ColorChange
      end
      object SynPrev: TSynEdit
        Left = 6
        Top = 152
        Width = 475
        Height = 241
        LinkEnable = True
        LinkOptions.Color = clBlue
        LinkOptions.AttributeList.Strings = (
          'Preprocessor'
          'Identifier')
        BracketHighlighting = False
        BracketHighlight.Background = clSkyBlue
        BracketHighlight.Foreground = clGray
        BracketHighlight.AloneBackground = clNone
        BracketHighlight.AloneForeground = clRed
        BracketHighlight.Style = [fsBold]
        BracketHighlight.AloneStyle = [fsBold]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 5
        OnMouseDown = SynPrevMouseDown
        Gutter.DigitCount = 2
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 6
        Gutter.RightOffset = 21
        Gutter.ShowLineNumbers = True
        HideSelection = True
        Highlighter = SynCpp
        Lines.Strings = (
          '// Sintax Preview'
          '#include <stdio.h>'
          ''
          '/**'
          ' * Main program function'
          ' */'
          'int main(int argc, char *argv[])'
          '{'
          '    int name[10] = "Falcon C++";'
          ''
          '    name[0] = '#39'F'#39';'
          '    return ( 0x00 * 0765 * 0.7f );'
          '}'
          'Selected Text')
        Options = [eoAutoIndent, eoDisableScrollArrows, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoHideShowScrollbars, eoNoCaret, eoNoSelection, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
        ReadOnly = True
        ScrollBars = ssNone
        OnGutterClick = SynPrevGutterClick
        OnSpecialLineColors = SynPrevSpecialLineColors
      end
    end
    object TSFormatter: TTabSheet
      Caption = 'Formatter'
      ImageIndex = 4
      object PageControl2: TPageControl
        Left = 6
        Top = 6
        Width = 475
        Height = 387
        ActivePage = TSFormatterStyle
        TabOrder = 0
        object TSFormatterStyle: TTabSheet
          Caption = 'Style'
          object GroupBoxFormatterSample: TGroupBox
            Left = 124
            Top = 3
            Width = 333
            Height = 347
            Caption = 'Sample'
            TabOrder = 0
            object SynMemoSample: TSynEdit
              Left = 10
              Top = 16
              Width = 313
              Height = 320
              LinkEnable = True
              LinkOptions.Color = clBlue
              LinkOptions.AttributeList.Strings = (
                'Preprocessor'
                'Identifier')
              BracketHighlighting = False
              BracketHighlight.Background = clSkyBlue
              BracketHighlight.Foreground = clGray
              BracketHighlight.AloneBackground = clNone
              BracketHighlight.AloneForeground = clRed
              BracketHighlight.Style = [fsBold]
              BracketHighlight.AloneStyle = [fsBold]
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              TabOrder = 0
              Gutter.DigitCount = 2
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.LeftOffset = 6
              Gutter.RightOffset = 21
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
            Top = 325
            Width = 114
            Height = 25
            Caption = 'Preview'
            TabOrder = 2
            Visible = False
            OnClick = BtnPrevStyleClick
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
            Hint = 'Indent using tab characters.'
            Caption = 'Force using TABs'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentClasses: TCheckBox
            Left = 6
            Top = 26
            Width = 339
            Height = 17
            Hint = 
              'Indent '#39'class'#39' and '#39'struct'#39' blocks so that the blocks '#39'public:'#39',' +
              ' '#39'protected:'#39' and '#39'private:'#39' are indented. The struct blocks are' +
              #13'indented only if an access modifier is declared somewhere in th' +
              'e struct. The entire block is indented. This option is'#13'effective' +
              ' for C++ files only.'
            Caption = 'Indent classes (keywords public:, protected: and private:)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentSwitches: TCheckBox
            Left = 6
            Top = 44
            Width = 211
            Height = 17
            Hint = 
              'Indent '#39'switch'#39' blocks so that the '#39'case X:'#39' statements are inde' +
              'nted in the switch block. The entire case block is indented.'
            Caption = 'Indent switches (keyword case:)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentCase: TCheckBox
            Left = 6
            Top = 62
            Width = 339
            Height = 17
            Hint = 
              'Indent '#39'case X:'#39' blocks from the '#39'case X:'#39' headers. Case stateme' +
              'nts not enclosed in blocks are NOT indented.'
            Caption = 'Indent case: statements in switches (commands case:)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentBrackets: TCheckBox
            Left = 6
            Top = 80
            Width = 155
            Height = 17
            Caption = 'Indent brackets'
            TabOrder = 4
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentBlocks: TCheckBox
            Left = 6
            Top = 98
            Width = 155
            Height = 17
            Caption = 'Indent blocks'
            TabOrder = 5
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentNamespaces: TCheckBox
            Left = 6
            Top = 116
            Width = 155
            Height = 17
            Hint = 'Add extra indentation to namespace blocks.'
            Caption = 'Indent namespaces'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentLabels: TCheckBox
            Left = 6
            Top = 134
            Width = 155
            Height = 17
            Hint = 
              'Add extra indentation to labels so they appear 1 indent less tha' +
              'n the current indentation, '#13'rather than being flushed to the lef' +
              't (the default).'
            Caption = 'Indent labels'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentMultLinePreprocessor: TCheckBox
            Left = 6
            Top = 152
            Width = 339
            Height = 17
            Hint = 
              'Indent multi-line preprocessor definitions ending with a backsla' +
              'sh. Should be used with --convert-tabs for proper results. '#13'Does' +
              ' a pretty good job, but cannot perform miracles in obfuscated pr' +
              'eprocessor definitions. Without this option the '#13'preprocessor st' +
              'atements remain unchanged.'
            Caption = 'Indent mult-line preprocessor definitions'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            OnClick = EditorOptionsChanged
          end
          object CheckBoxIndentSingleLineComments: TCheckBox
            Left = 6
            Top = 170
            Width = 259
            Height = 17
            Hint = 
              'Indent C++ comments beginning in column one. By default C++ comm' +
              'ents beginning in column one are not indented. '#13'This option will' +
              ' allow the comments to be indented with the code.'
            Caption = 'Indent single line comments'
            TabOrder = 9
            OnClick = EditorOptionsChanged
          end
        end
        object TSFormatterPadding: TTabSheet
          Caption = 'Padding'
          ImageIndex = 4
          object CheckBoxPadEmptyLines: TCheckBox
            Left = 6
            Top = 8
            Width = 339
            Height = 17
            Hint = 
              'Pad empty lines around header blocks (e.g. '#39'if'#39', '#39'for'#39', '#39'while'#39'.' +
              '..).'
            Caption = 'Pad empty lines around header blocks ('#39'if'#39', '#39'while'#39', ..)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = EditorOptionsChanged
          end
          object CheckBoxInsertSpacePaddingOperators: TCheckBox
            Left = 6
            Top = 44
            Width = 283
            Height = 17
            Hint = 
              'Insert space padding around operators. Any end of line comments ' +
              'will remain in the original column, if possible. '#13'Note that ther' +
              'e is no option to unpad. Once padded, they stay padded.'
            Caption = 'Insert space padding around operators'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = EditorOptionsChanged
          end
          object CheckBoxInsertSpacePaddingParenthesisOutside: TCheckBox
            Left = 6
            Top = 62
            Width = 339
            Height = 17
            Hint = 
              'Insert space padding around parenthesis on the outside only. Any' +
              ' end of line comments will remain in the original column, '#13'if po' +
              'ssible.'
            Caption = 'Insert space padding around parenthesis on the outside'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = EditorOptionsChanged
          end
          object CheckBoxInsertSpacePaddingParenthesisInside: TCheckBox
            Left = 6
            Top = 80
            Width = 339
            Height = 17
            Hint = 
              'Insert space padding around parenthesis on the inside only. Any ' +
              'end of line comments will remain in the original column, '#13'if pos' +
              'sible.'
            Caption = 'Insert space padding around parenthesis on the inside'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = EditorOptionsChanged
          end
          object CheckBoxRemoveExtraSpace: TCheckBox
            Left = 6
            Top = 116
            Width = 331
            Height = 17
            Hint = 
              'Remove extra space padding around parenthesis on the inside and ' +
              'outside. Any end of line comments will remain in the '#13'original c' +
              'olumn, if possible.'
            Caption = 'Remove extra space padding around parenthesis'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = EditorOptionsChanged
          end
          object CheckBoxFillEmptyLines: TCheckBox
            Left = 6
            Top = 152
            Width = 411
            Height = 17
            Hint = 'Fill empty lines with the white space of the previous line.'
            Caption = 'Fill empty lines with the whitespace of their previous lines'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = EditorOptionsChanged
          end
          object CheckBoxDeleteEmptyLines: TCheckBox
            Left = 6
            Top = 134
            Width = 283
            Height = 17
            Hint = 
              'Delete empty lines within a function or method. Empty lines outs' +
              'ide of functions or methods are NOT deleted.'
            Caption = 'Delete empty lines'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = EditorOptionsChanged
          end
          object CheckBoxParenthesisHeaderPadding: TCheckBox
            Left = 6
            Top = 98
            Width = 283
            Height = 17
            Hint = 
              'Insert space padding after paren headers only (e.g. '#39'if'#39', '#39'for'#39',' +
              ' '#39'while'#39'...). Any end of line comments will remain in the '#13'origi' +
              'nal column, if possible.'
            Caption = 'Parenthesis header padding'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnClick = EditorOptionsChanged
          end
          object CheckBoxBreakClosingHeaderBlocks: TCheckBox
            Left = 6
            Top = 26
            Width = 283
            Height = 17
            Hint = 
              'Pad empty lines around header blocks (e.g. '#39'if'#39', '#39'for'#39', '#39'while'#39'.' +
              '..). Treat closing header blocks (e.g. '#39'else'#39', '#39'catch'#39') as '#13'stan' +
              'd-alone blocks.'
            Caption = 'Break closing header blocks'
            ParentShowHint = False
            ShowHint = True
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
          object Label26: TLabel
            Left = 6
            Top = 38
            Width = 61
            Height = 13
            Caption = 'Pointer align:'
          end
          object ComboBoxBracketStyle: TComboBox
            Left = 152
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
          object CheckBoxBreakClosingHeadersBrackets: TCheckBox
            Left = 6
            Top = 62
            Width = 259
            Height = 17
            Hint = 
              'When used with brackets=attach, brackets=linux, this breaks clos' +
              'ing headers (e.g. '#39'else'#39', '#39'catch'#39', ...) from their '#13'immediately ' +
              'preceding closing brackets. Closing header brackets are always b' +
              'roken with broken brackets, horstmann '#13'brackets, indented blocks' +
              ', and indented brackets.'
            Caption = 'Break closing headers brackets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = EditorOptionsChanged
          end
          object CheckBoxBreakElseIf: TCheckBox
            Left = 6
            Top = 80
            Width = 339
            Height = 17
            Hint = 
              'Break "else if" header combinations into separate lines. This op' +
              'tion has no effect if keep one line statements is used, the'#13'"els' +
              'e if" statements will remain as they are.'#13'If this option is NOT ' +
              'used, "else if" header combinations will be placed on a single l' +
              'ine.'
            Caption = 'Break '#39'else if()'#39' header combinations into separate lines'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = EditorOptionsChanged
          end
          object CheckBoxDontBreakComplex: TCheckBox
            Left = 6
            Top = 152
            Width = 408
            Height = 17
            Hint = 
              'Don'#39't break complex statements and multiple statements residing ' +
              'on a single line.'
            Caption = 
              'Don'#39't break complex statements and multiple statements residing ' +
              'in a single line'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = EditorOptionsChanged
          end
          object CheckBoxDontBreakOneLineBlocks: TCheckBox
            Left = 6
            Top = 134
            Width = 219
            Height = 17
            Hint = 'Don'#39't break one-line blocks.'
            Caption = 'Don'#39't break one-line blocks'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = EditorOptionsChanged
          end
          object CheckBoxConvToSpaces: TCheckBox
            Left = 6
            Top = 170
            Width = 187
            Height = 17
            Hint = 
              'Converts tabs into spaces in the non-indentation part of the lin' +
              'e. The number of spaces inserted will maintain the spacing '#13'of t' +
              'he tab. The current setting for spaces per tab is used. It may n' +
              'ot produce the expected results if convert-tabs is used '#13'when ch' +
              'anging spaces per tab. Tabs are not replaced in quotes.'
            Caption = 'Convert TABs to spaces'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = EditorOptionsChanged
          end
          object CheckBoxAddBrackets: TCheckBox
            Left = 6
            Top = 98
            Width = 235
            Height = 17
            Hint = 
              'Add brackets to unbracketed one line conditional statements (e.g' +
              '. '#39'if'#39', '#39'for'#39', '#39'while'#39'...). The statement must be on a single '#13'l' +
              'ine. The brackets will be added according to the currently reque' +
              'sted predefined style or bracket type. If no style or '#13'bracket t' +
              'ype is requested the brackets will be attached. If add one line ' +
              'brackets is also used the result will be one line '#13'brackets.'
            Caption = 'Add brackets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = EditorOptionsChanged
          end
          object CheckBoxAddOneLineBrackets: TCheckBox
            Left = 6
            Top = 116
            Width = 235
            Height = 17
            Hint = 
              'Add one line brackets to unbracketed one line conditional statem' +
              'ents  (e.g. '#39'if'#39', '#39'for'#39', '#39'while'#39'...). The statement must be on '#13 +
              'a single line. The option implies keep one line blocks and will ' +
              'not break the one line blocks.'
            Caption = 'Add one line brackets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnClick = EditorOptionsChanged
          end
          object ComboBoxPointerAlign: TComboBox
            Left = 152
            Top = 36
            Width = 137
            Height = 21
            Hint = 
              'Attach a pointer or reference operator (* or &) to either the va' +
              'riable type (left) or variable name (right), or place it '#13'betwee' +
              'n the type and name (middle). The spacing between the type and n' +
              'ame will be preserved, if possible. To format '#13'references separa' +
              'tely use the following align-reference option.'
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            Text = 'None'
            OnChange = ComboBoxPointerAlignChange
            Items.Strings = (
              'None'
              'Type'
              'Middle'
              'Name')
          end
        end
      end
    end
    object TSCodeResources: TTabSheet
      Caption = 'Code Resources'
      ImageIndex = 3
      object GroupBox8: TGroupBox
        Left = 4
        Top = 4
        Width = 477
        Height = 105
        Caption = 'Automatic features'
        TabOrder = 0
        object LblDelay: TLabel
          Left = 288
          Top = 24
          Width = 30
          Height = 13
          Caption = '&Delay:'
        end
        object LblSecStart: TLabel
          Left = 276
          Top = 72
          Width = 35
          Height = 13
          Caption = '0.1 sec'
        end
        object LblSecEnd: TLabel
          Left = 422
          Top = 72
          Width = 35
          Height = 13
          Caption = '1.5 sec'
        end
        object ChbCodeCompletion: TCheckBox
          Left = 8
          Top = 22
          Width = 177
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
          Width = 177
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
          Width = 201
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
          Width = 217
          Height = 17
          Caption = 'Tooltip expression evaluation'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = EditorOptionsChanged
        end
        object TrackBarCodeRes: TTrackBar
          Left = 280
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
        Left = 5
        Top = 120
        Width = 476
        Height = 129
        Caption = 'Completion List Colors'
        TabOrder = 1
        object Label17: TLabel
          Left = 40
          Top = 24
          Width = 82
          Height = 13
          Alignment = taRightJustify
          Caption = 'Constant Symbol:'
        end
        object Label18: TLabel
          Left = 41
          Top = 48
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = 'Function Symbol:'
        end
        object Label19: TLabel
          Left = 44
          Top = 72
          Width = 78
          Height = 13
          Alignment = taRightJustify
          Caption = '&Variable Symbol:'
        end
        object Label20: TLabel
          Left = 58
          Top = 96
          Width = 64
          Height = 13
          Alignment = taRightJustify
          Caption = 'Type Symbol:'
        end
        object Label21: TLabel
          Left = 289
          Top = 48
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = 'Preprocessor:'
        end
        object Label22: TLabel
          Left = 293
          Top = 96
          Width = 61
          Height = 13
          Alignment = taRightJustify
          Caption = 'Background:'
        end
        object Label23: TLabel
          Left = 309
          Top = 72
          Width = 45
          Height = 13
          Alignment = taRightJustify
          Caption = 'Selected:'
        end
        object Label24: TLabel
          Left = 275
          Top = 24
          Width = 79
          Height = 13
          Alignment = taRightJustify
          Caption = 'Typedef Symbol:'
        end
        object ClbCompListConst: TColorBox
          Left = 126
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
          Left = 126
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
          Left = 126
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
          Left = 126
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
          Left = 358
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
          Left = 358
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
          Left = 358
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
          Left = 358
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
        Left = 5
        Top = 264
        Width = 476
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
          Left = 442
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
          Left = 414
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
          Width = 401
          Height = 21
          TabOrder = 0
          OnChange = EditCodeTemplateChange
        end
      end
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
  object SynCpp: TSynCppSyn
    Left = 80
    Top = 484
  end
  object TimerNormalDelay: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerNormalDelayTimer
    Left = 48
    Top = 484
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.txt'
    Filter = 
      'Text Files(*.txt)|*.txt|Code Templates(*.ct)|*.ct|All files(*.*)' +
      '|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofNoNetworkButton, ofEnableSizing, ofDontAddToRecent]
    Left = 16
    Top = 484
  end
end
