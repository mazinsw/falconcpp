unit UFraSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, PNGImage;

type
  TFraAgrmt = class(TFrame)
    LblEspReq: TLabel;
    PainelHeader: TPanel;
    LinhaInf: TBevel;
    PainelAll: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    LblWidz: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    TextLicense: TMemo;
    Panel3: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FraAgrmt: TFraAgrmt;

implementation

uses UFrmWizard, UFraPath;

{$R *.dfm}

end.
