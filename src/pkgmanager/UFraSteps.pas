unit UFraSteps;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, RichEditViewer, UFrmWizard, Classes,
  Controls, Forms, PNGImage;

type
  TFraSteps = class(TFrame)
    PainelHeader: TPanel;
    LinhaInf: TBevel;
    PainelAll: TPanel;
    LblTitle: TLabel;
    LblSubTitle: TLabel;
    PkgImage: TImage;
    Panel1: TPanel;
    LblWidz: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    PanelStep: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FraSteps: TFraSteps;

implementation

{$R *.dfm}

end.
