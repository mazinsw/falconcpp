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
  end;

var
  FraWelc: TFraWelc;
  
implementation

{$R *.dfm}

end.
