unit UFraAgrmt;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, RichEdit, UFrmWizard, Classes,
  Controls, Forms, SysUtils, ComCtrls;

type
  TFraAgrmt = class(TFrame)
    PainelAll: TPanel;
    Label5: TLabel;
    TextAnswer: TLabel;
    TextLicense: TRichEdit;
    procedure UpdateStep;
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyTranslation;
  end;

var
  FraAgrmt: TFraAgrmt;

implementation

uses UFraSteps, ULanguages;

{$R *.dfm}

procedure TFraAgrmt.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraAgrmt.UpdateStep;
begin
  FraSteps.LblTitle.Caption := STR_FRM_AGRMT[2];
  FraSteps.LblSubTitle.Caption :=
    Format(STR_FRM_AGRMT[3], [Installer.Name]);
end;

procedure TFraAgrmt.ApplyTranslation;
begin
  Label5.Caption := STR_FRM_AGRMT[4];
end;

end.
