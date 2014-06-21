object FraPrjOpt: TFraPrjOpt
  Left = 0
  Top = 0
  Width = 521
  Height = 337
  TabOrder = 0
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 521
    Height = 337
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GrbProj: TGroupBox
      Left = 8
      Top = 168
      Width = 505
      Height = 145
      Caption = 'Project'
      TabOrder = 0
      object LblName: TLabel
        Left = 8
        Top = 16
        Width = 27
        Height = 13
        Caption = 'Name'
      end
      object RGrpType: TRadioGroup
        Left = 8
        Top = 64
        Width = 185
        Height = 73
        Caption = 'Compiler Type'
        ItemIndex = 0
        Items.Strings = (
          'C'
          'C++')
        TabOrder = 0
      end
      object EditProjName: TEdit
        Left = 8
        Top = 32
        Width = 185
        Height = 21
        TabOrder = 1
        OnChange = EditProjNameChange
        OnKeyPress = EditProjNameKeyPress
      end
      object GrbOptmz: TGroupBox
        Left = 208
        Top = 26
        Width = 169
        Height = 111
        Caption = 'Optimizations'
        TabOrder = 2
        object CHBMinSize: TCheckBox
          Left = 8
          Top = 24
          Width = 153
          Height = 17
          Caption = 'Minimize Size'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CHBShowWar: TCheckBox
          Left = 8
          Top = 51
          Width = 153
          Height = 17
          Caption = 'Show Warnings'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object CHBOptSpd: TCheckBox
          Left = 8
          Top = 80
          Width = 153
          Height = 17
          Caption = 'Optimize Speed'
          TabOrder = 2
        end
      end
    end
    object GrbApp: TGroupBox
      Left = 8
      Top = 8
      Width = 505
      Height = 145
      Caption = 'Application'
      TabOrder = 1
      object LblDescIcon: TLabel
        Left = 11
        Top = 77
        Width = 145
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Application Icon'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object PanelIcon: TPanel
        Left = 55
        Top = 23
        Width = 51
        Height = 51
        BevelOuter = bvLowered
        TabOrder = 0
        object ImgIcon: TImage
          Left = 1
          Top = 1
          Width = 32
          Height = 32
          Hint = 'Double click to change application icon'
          Align = alClient
          AutoSize = True
          Center = True
          ParentShowHint = False
          Picture.Data = {
            055449636F6E0000010002002020100001000400E80200002600000010101000
            01000400280100000E0300002800000020000000400000000100040000000000
            8002000000000000000000000000000000000000000000000000BF0000BF0000
            00BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000FF0000FF0000
            00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
            0000000000000000000000000000000000000000888888888888888888888888
            8888888087777777777777777777777777777780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878FFFFFFFFFFFFFFFFFFFFF
            FFFFF780878FFFFFFFFFFFFFFFFFFFFFFFFFF780878888888888888888888888
            8888878087777777777777777777777777777780874444444444444444444000
            0000008087444444444444444444477077077080874444444444444444444770
            7707708087444444444444444444444444444480877777777777777777777777
            7777778088888888888888888888888888888880000000000000000000000000
            0000000000000000000000000000000000000000FFFFFFFF0000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000FFFFFFFFFFFFFFFF280000001000000020000000
            0100040000000000C00000000000000000000000000000000000000000000000
            0000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C00080808000
            0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
            000000000000000000000000888888888888888087FFFFFFFFFFFF8087FFFFFF
            FFFFFF8087FFFFFFFFFFFF8087FFFFFFFFFFFF8087FFFFFFFFFFFF8087FFFFFF
            FFFFFF8087FFFFFFFFFFFF80878888888888888087444444F0F0F08087444444
            44444480877777777777778088888888888888880000000000000000FFFF0000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000FFFF0000}
          PopupMenu = PUMIcon
          ShowHint = True
          OnDblClick = BtnChgIconClick
          ExplicitWidth = 49
          ExplicitHeight = 49
        end
      end
      object BtnChgIcon: TButton
        Left = 48
        Top = 94
        Width = 65
        Height = 20
        Caption = 'Change'
        TabOrder = 1
        OnClick = BtnChgIconClick
      end
      object CHBInc: TCheckBox
        Left = 168
        Top = 13
        Width = 297
        Height = 17
        Caption = 'Include application info'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = CHBIncClick
      end
      object GrBInfo: TGroupBox
        Left = 168
        Top = 32
        Width = 329
        Height = 104
        TabOrder = 3
        object LblCompa: TLabel
          Left = 8
          Top = 8
          Width = 45
          Height = 13
          Caption = 'Company'
        end
        object LblDesc: TLabel
          Left = 8
          Top = 55
          Width = 53
          Height = 13
          Caption = 'Description'
        end
        object LblVers: TLabel
          Left = 184
          Top = 8
          Width = 35
          Height = 13
          Caption = 'Version'
        end
        object LblProdName: TLabel
          Left = 184
          Top = 55
          Width = 67
          Height = 13
          Caption = 'Product Name'
        end
        object Bevel2: TBevel
          Left = 164
          Top = 6
          Width = 1
          Height = 78
          Shape = bsLeftLine
        end
        object EditComp: TEdit
          Left = 8
          Top = 23
          Width = 137
          Height = 21
          TabOrder = 0
        end
        object EditDesc: TEdit
          Left = 8
          Top = 70
          Width = 137
          Height = 21
          TabOrder = 1
        end
        object EditVer: TEdit
          Left = 184
          Top = 23
          Width = 137
          Height = 21
          TabOrder = 2
          Text = '1.0.0.0'
        end
        object EditProdName: TEdit
          Left = 184
          Top = 70
          Width = 137
          Height = 21
          TabOrder = 3
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 318
      Width = 521
      Height = 19
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 2
      object LblWidz: TLabel
        Left = 3
        Top = 3
        Width = 104
        Height = 13
        Align = alLeft
        Caption = 'Falcon Project Wizard'
        Enabled = False
      end
      object Panel2: TPanel
        Left = 107
        Top = 3
        Width = 411
        Height = 13
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object Bevel1: TBevel
          Left = 3
          Top = 3
          Width = 405
          Height = 7
          Align = alClient
          Shape = bsBottomLine
        end
      end
    end
  end
  object PUMIcon: TPopupMenu
    Left = 136
    Top = 112
    object ChangeIcon1: TMenuItem
      Caption = 'Change Icon'
      OnClick = BtnChgIconClick
    end
    object RemoveIcon1: TMenuItem
      Caption = 'Remove Icon'
      OnClick = RemoveIcon1Click
    end
  end
  object OpenIcon: TIconDialog
    IconIndex = 0
    Left = 124
    Top = 38
  end
end
