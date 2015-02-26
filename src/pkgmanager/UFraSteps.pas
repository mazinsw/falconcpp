unit UFraSteps;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, UFrmWizard, Classes,
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
    procedure ApplyTranslation;
  end;

var
  FraSteps: TFraSteps;

implementation

uses ULanguages;

{$R *.dfm}

{ TFraSteps }

{ TFraSteps }

procedure TFraSteps.ApplyTranslation;
begin
  LblWidz.Caption := STR_FRM_STEPS[1];
end;

end.
