unit UFraGetVer;

interface

uses
  Windows, SysUtils, Classes, Forms, ComCtrls, StdCtrls, ExtCtrls,
  Controls;

type
  TFraGetVer = class(TFrame)
    LblDesc: TLabel;
    PrgsUpdate: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FraGetVer: TFraGetVer;

implementation

uses UUtils;

{$R *.dfm}



end.
