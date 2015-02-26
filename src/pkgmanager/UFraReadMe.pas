unit UFraReadMe;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, RichEdit, UFrmWizard, Classes,
  Controls, Forms, ComCtrls;

type
  TFraReadMe = class(TFrame)
    PainelAll: TPanel;
    Label5: TLabel;
    TextGuide: TLabel;
    TextReadMe: TRichEdit;
    procedure UpdateStep;
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyTranslation;
  end;

var
  FraReadMe: TFraReadMe;

implementation

uses UFraSteps, ULanguages;

{$R *.dfm}

procedure TFraReadMe.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraReadMe.UpdateStep;
begin
  FraSteps.LblTitle.Caption := STR_FRM_README[3];
  FraSteps.LblSubTitle.Caption := STR_FRM_README[4];
end;

procedure TFraReadMe.ApplyTranslation;
begin
  Label5.Caption := STR_FRM_README[1];
  TextGuide.Caption := STR_FRM_README[2];
end;

end.
