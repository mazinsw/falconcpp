unit UFraReadMe;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, RichEditViewer, UFrmWizard, Classes,
  Controls, Forms;

type
  TFraReadMe = class(TFrame)
    PainelAll: TPanel;
    Label5: TLabel;
    TextGuide: TLabel;
    TextReadMe: TRichEditViewer;
    procedure UpdateStep;
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FraReadMe: TFraReadMe;

implementation

uses UFraSteps;

{$R *.dfm}

procedure TFraReadMe.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraReadMe.UpdateStep;
begin
  FraSteps.LblTitle.Caption := 'README';
  FraSteps.LblSubTitle.Caption := 'Please read the following README.';
end;

end.
