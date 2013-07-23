unit PluginUtils;

interface

uses
  Classes, SysUtils;

procedure ListDir(Dir, Regex: string; List: TStrings;
  IncludeSubDir: Boolean = False);

implementation

procedure ListDir(Dir, Regex: string; List: TStrings; IncludeSubDir: Boolean);
var
  F: TSearchRec;
  NormalDir: string;
begin
  NormalDir := IncludeTrailingPathDelimiter(Dir);
  if FindFirst(NormalDir + Regex, faAnyFile, F) = 0 then
  begin
    repeat
      if (F.Attr and faDirectory) = 0 then
        List.Add(NormalDir + F.Name);
    until FindNext(F) <> 0;
    FindClose(F);
  end;
  if not IncludeSubDir then
    Exit;
  if FindFirst(NormalDir + '*.*', faAnyFile, F) = 0 then
  begin
    repeat
      if ((F.Attr and faDirectory) <> 0) and (F.Name <> '.') and (F.Name <> '..') then
      begin
        ListDir(NormalDir + F.Name + '\', Regex, List, IncludeSubDir);
      end;
    until FindNext(F) <> 0;
    FindClose(F);
  end;
end;

end.
