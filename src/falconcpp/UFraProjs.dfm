object FraProjs: TFraProjs
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  TabOrder = 0
  DesignSize = (
    451
    304)
  object GrBoxDesc: TGroupBox
    Left = 306
    Top = 2
    Width = 137
    Height = 294
    Anchors = [akTop, akRight, akBottom]
    Caption = 'Description'
    TabOrder = 0
    ExplicitLeft = 408
    ExplicitHeight = 295
    DesignSize = (
      137
      294)
    object ImageProj: TImage
      Left = 44
      Top = 24
      Width = 48
      Height = 48
    end
    object MemoDesc: TMemo
      Left = 8
      Top = 117
      Width = 121
      Height = 169
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
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
      ExplicitHeight = 122
    end
    object MemoCap: TMemo
      Left = 8
      Top = 78
      Width = 121
      Height = 33
      TabStop = False
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
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
    Width = 290
    Height = 288
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
    ExplicitWidth = 337
  end
  object ImageList: TImageList
    ColorDepth = cd32Bit
    Height = 48
    Width = 48
    Left = 296
    Top = 56
  end
end
