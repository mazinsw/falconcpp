unit UFraAgrmt;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, RichEditViewer, UFrmWizard, Classes,
  Controls, Forms, SysUtils;

type
  TFraAgrmt = class(TFrame)
    PainelAll: TPanel;
    Label5: TLabel;
    TextAnswer: TLabel;
    TextLicense: TRichEditViewer;
    procedure UpdateStep;
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FraAgrmt: TFraAgrmt;

implementation

uses UFraSteps;

{$R *.dfm}

procedure TFraAgrmt.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraAgrmt.UpdateStep;
begin
  FraSteps.LblTitle.Caption := 'License Agreement';
  FraSteps.LblSubTitle.Caption :=
    Format('Please review the license terms before installing %s.', [Installer.Name]);
end;

end.
