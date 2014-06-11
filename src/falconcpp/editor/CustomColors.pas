unit CustomColors;

interface
                     
uses
  Graphics;

const
  clOrange = $000080FF;
  clViolet = $00FF0080;
  clMaroon = $00004080;
  clCyan   = $00FFFF00;

function DSColor(Color: TColor; Default: TColor = clBlack): TColor;

implementation


function DSColor(Color: TColor; Default: TColor): TColor;
begin
  if Color = clNone then
    Color := ColorToRGB(Default);
  Result := ColorToRGB(Color);
end;

end.
