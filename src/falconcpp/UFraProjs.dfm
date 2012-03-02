object FraProjs: TFraProjs
  Left = 0
  Top = 0
  Width = 493
  Height = 312
  TabOrder = 0
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 493
    Height = 312
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GrBoxDesc: TGroupBox
      Left = 352
      Top = 8
      Width = 137
      Height = 284
      Caption = 'Description'
      TabOrder = 0
      object ImageProj: TImage
        Left = 44
        Top = 24
        Width = 48
        Height = 48
      end
      object MemoDesc: TMemo
        Left = 8
        Top = 136
        Width = 121
        Height = 145
        TabStop = False
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object MemoCap: TMemo
        Left = 8
        Top = 80
        Width = 121
        Height = 33
        TabStop = False
        Alignment = taCenter
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 293
      Width = 493
      Height = 19
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 1
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
        Width = 383
        Height = 13
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object Bevel1: TBevel
          Left = 3
          Top = 3
          Width = 377
          Height = 7
          Align = alClient
          Shape = bsBottomLine
        end
      end
    end
    object PageControl: TModernPageControl
      Left = 8
      Top = 8
      Width = 337
      Height = 285
      NormalColor = clWhite
      FocusedColor = 15973017
      ShowCloseButton = False
      TabIndex = -1
      TabOrder = 2
      TabStop = True
      OnMouseMove = ProjectListMouseMove
      OnPageChange = PageControlPageChange
    end
  end
  object ImageList: TImageList
    Height = 48
    Width = 48
    Left = 296
    Top = 56
  end
end
