object frmSobre: TfrmSobre
  Left = 526
  Top = 408
  BorderStyle = bsToolWindow
  Caption = 'Sobre'
  ClientHeight = 264
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Gradient1: TGradient
    Left = 0
    Top = 0
    Width = 303
    Height = 264
    Align = alClient
    ColorBegin = 16732497
    ColorEnd = 13500416
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 169
    TabOrder = 0
    object Label1: TLabel
      Left = 64
      Top = 24
      Width = 99
      Height = 13
      Caption = 'Falcon C++: v3.1.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 72
      Width = 122
      Height = 13
      Caption = 'Desenvolvedor: Mazin sw'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 96
      Width = 81
      Height = 13
      Caption = 'Empresa: MZSW'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 120
      Width = 133
      Height = 13
      Caption = 'Email: mazin.z@hotmail.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage
      Left = 8
      Top = 8
      Width = 48
      Height = 48
      AutoSize = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 192
    Width = 289
    Height = 65
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 16
      Width = 206
      Height = 13
      Caption = 'Compatibilidade: Windows XP e Windows 7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 40
      Width = 137
      Height = 13
      Caption = 'GNU General Public Licence'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 208
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Ok'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
