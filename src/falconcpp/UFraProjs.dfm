object FraProjs: TFraProjs
  Left = 0
  Top = 0
  Width = 521
  Height = 328
  Align = alClient
  TabOrder = 0
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 521
    Height = 328
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 337
    DesignSize = (
      521
      328)
    object GrBoxDesc: TGroupBox
      Left = 376
      Top = 8
      Width = 137
      Height = 312
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Description'
      TabOrder = 0
      ExplicitHeight = 321
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
        Height = 161
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
    object PageControl: TModernPageControl
      Left = 8
      Top = 8
      Width = 361
      Height = 312
      Anchors = [akLeft, akTop, akRight, akBottom]
      NormalColor = clWhite
      FocusedColor = 15973017
      ParentColor = False
      ShowCloseButton = False
      TabIndex = -1
      TabOrder = 1
      TabStop = True
      FixedTabWidth = False
      OnMouseMove = ProjectListMouseMove
      OnPageChange = PageControlPageChange
      ExplicitHeight = 321
    end
  end
  object ImageList: TImageList
    Height = 48
    Width = 48
    Left = 296
    Top = 56
  end
end
