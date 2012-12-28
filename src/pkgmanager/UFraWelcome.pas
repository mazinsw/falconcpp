unit UFraWelcome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, PNGImage;

type
  TFraWelc = class(TFrame)
    ImageLogo: TImage;
    BvLine: TBevel;
    PainelMens: TPanel;
    TextRecom: TLabel;
    TextGuide: TLabel;
    LblMsg: TLabel;
    TextHelp: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyTranslation;
  end;

var
  FraWelc: TFraWelc;
  
implementation

uses ULanguages;

{$R *.dfm}

{ TFraWelc }

procedure TFraWelc.ApplyTranslation;
begin
  TextRecom.Caption := STR_FRM_WELCOME[3];
  TextGuide.Caption := STR_FRM_WELCOME[4];
end;

end.
