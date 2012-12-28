unit UFraFnsh;

interface

uses
  Messages, Forms, ExtCtrls, StdCtrls, Classes, Controls, SysUtils, UFrmWizard,
  Graphics;

type
  TFraFnsh = class(TFrame)
    PainelMens: TPanel;
    TextTitle: TLabel;
    TextHelp: TLabel;
    TextRecom: TLabel;
    LinhaInf: TBevel;
    Imagem: TImage;
    ChbShow: TCheckBox;
    procedure UpdateStep;
    procedure WMUpdateStep(var Message: TMessage); message WM_UPDATESTEP;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyTranslation;
  end;

var
  FraFnsh: TFraFnsh;

implementation

uses ULanguages;

{$R *.dfm}

procedure TFraFnsh.WMUpdateStep(var Message: TMessage);
begin
  UpdateStep;
end;

procedure TFraFnsh.ApplyTranslation;
begin
   TextRecom.Caption := STR_FRM_FINISH[2];
   ChbShow.Caption := STR_FRM_FINISH[3];
end;

procedure TFraFnsh.UpdateStep;
begin
  TextTitle.Caption := Format(STR_FRM_FINISH[1], [Installer.Name]);
  TextHelp.Caption := Format(Installer.FinishMsg, [Installer.Name]);
  if Installer.Aborted then
    TextHelp.Font.Color := clRed
  else if Installer.SkipFileCount > 0 then
    TextHelp.Font.Color := $007FFF;
end;

end.
