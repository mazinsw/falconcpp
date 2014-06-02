unit UnicodeUtils;

interface

uses
  DScintillaTypes;

function IsIn(Ch: WideChar; const S: UnicodeString): Boolean;

implementation

function IsIn(Ch: WideChar; const S: UnicodeString): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
  begin
    if Ch = S[I] then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

end.
