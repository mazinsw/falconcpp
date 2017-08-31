unit Makefile;

interface

uses
  Windows, SysUtils, Classes;

const
  TabChar = #9;

type
  TMakefile = class
  private
    FTarget: string;
    FCompilerPath: string;
    FBaseDir: string;
    FLibs: string;
    FFlags: string;
    FCompilerOptions: string;
    FFileName: string;
    FCreateLibrary: Boolean;
    FFiles: TStrings;
    FCompilerIsCpp: Boolean;
    FCleanBefore: Boolean;
    FCleanAfter: Boolean;
    FDebugMode: Boolean;
    FEcho: Boolean;
    FForceClean: Boolean;
    procedure SetFiles(Value: TStrings);
    procedure SelectFilesByExt(Extensions: array of string; List: TStrings);
    procedure TransformToRelativePath;
  public
    constructor Create;
    destructor Destroy; override;
    function BuildMakefile: Integer;
    property Target: string read FTarget write FTarget;
    property CompilerPath: string read FCompilerPath write FCompilerPath;
    property BaseDir: string read FBaseDir write FBaseDir;
    property Libs: string read FLibs write FLibs;
    property Flags: string read FFlags write FFlags;
    property CompilerOptions: string read FCompilerOptions write FCompilerOptions;
    property FileName: string read FFileName write FFileName;
    property CreateLibrary: Boolean read FCreateLibrary write FCreateLibrary;
    property Files: TStrings read FFiles write SetFiles;
    property CompilerIsCpp: Boolean read FCompilerIsCpp write FCompilerIsCpp;
    property CleanBefore: Boolean read FCleanBefore write FCleanBefore;
    property CleanAfter: Boolean read FCleanAfter write FCleanAfter;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
    property Echo: Boolean read FEcho write FEcho;
    property ForceClean: Boolean read FForceClean write FForceClean;
  end;

function DoubleQuotedStr(const S: string): string;
function ConvertAnsiToOem(const S: string): string;
function EscapeString(const S: string): string;

implementation

function ConvertAnsiToOem(const S: string): string;
var
  R: AnsiString;
begin
  Result := '';
  if Length(s) = 0 then
    Exit;
  SetLength(R, Length(R));
  AnsiToOem(PAnsiChar(AnsiString(S)), PAnsiChar(R));
  Result := string(R);
end;

function EscapeString(const S: string): string;
begin
  Result := StringReplace(S, ' ', '\ ', [rfReplaceAll]);
end;

function DoubleQuotedStr(const S: string): string;
begin
  Result := S;
  if Pos(' ', Trim(S)) > 0 then
    Result := '"' + Result + '"';
end;

function SingleQuotedStr(const S: string): string;
begin
  Result := S;
  if Pos(' ', Trim(S)) > 0 then
    Result := '''' + Result + '''';
end;

function ConvertToUnixSlashes(const Path: string): string;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
    if Result[i] = '\' then
      Result[i] := '/';
end;

{TMakefile}

constructor TMakefile.Create;
begin
  inherited Create;
  FFiles := TStringList.Create;
end;

destructor TMakefile.Destroy;
begin
  FFiles.Free;
  inherited Destroy;
end;

procedure TMakefile.SetFiles(Value: TStrings);
begin
  if Assigned(Value) then
    FFiles.Assign(Value);
end;

procedure TMakefile.TransformToRelativePath;
var
  I, J: Integer;
  Includes: TStrings;
begin
  for I := 0 to Files.Count - 1 do
  begin
    Files.Strings[I] := ExtractRelativePath(BaseDir, Files.Strings[I]);
    Includes := TStrings(Files.Objects[I]);
    for J := 0 to Includes.Count - 1 do
    begin
      Includes.Strings[J] := ExtractRelativePath(BaseDir, Includes.Strings[J]);
    end;
  end;
end;

procedure TMakefile.SelectFilesByExt(Extensions: array of string; List: TStrings);
var
  I, X: Integer;
begin
  for I := 0 to Files.Count - 1 do
  begin
    for X := 0 to Length(Extensions) - 1 do
    begin
      if SameText(ExtractFileExt(Files.Strings[I]), Extensions[X]) then
        List.AddObject(Files.Strings[I], Files.Objects[I]);
    end;
  end;
end;

function TMakefile.BuildMakefile: Integer;
var
  Source, Resources, OutFile, Includes: TStrings;
  I, J: Integer;
  S, Temp, Cop, EchoStr, IncludeHeaders, aTarget, rTarget, mFlags: string;
begin
  Result := 0;
  EchoStr := '';
  Source := TStringList.Create;
  Resources := TStringList.Create;
  OutFile := TStringList.Create;
  TransformToRelativePath;
  SelectFilesByExt(['.c', '.cpp', '.cc', '.cxx', '.c++', '.cp'], Source);
  SelectFilesByExt(['.rc'], Resources);
  if (Pos('-m32', Libs) > 0) and (Pos('-m32', Flags) = 0) then
    mFlags := ' -m32';
  if CompilerIsCpp then
    OutFile.Add('CPP    = g++')
  else
    OutFile.Add('CC     = gcc');
  if Resources.Count > 0 then
    OutFile.Add('WINDRES= windres');
  if CreateLibrary then
  begin
    OutFile.Add('AR     = ar');
    OutFile.Add('RANLIB = ranlib');
  end;
  //OutFile.Add('RM     = del /F /Q');
  OutFile.Add('RM     = rm -f');
  if Source.Count > 0 then
  begin
    S := ChangeFileExt(Source.Strings[0], '.o');
    S := EscapeString(ConvertToUnixSlashes(S));
    if (Source.Count + Resources.Count) > 1 then
      OutFile.Add('OBJS   = ' + S + ' \')
    else
      OutFile.Add('OBJS   = ' + S);
    for I := 1 to Source.Count - 2 do
    begin
      S := ChangeFileExt(Source.Strings[I], '.o');
      S := EscapeString(ConvertToUnixSlashes(S));
      OutFile.Add('         ' + S + ' \');
    end;
    if Resources.Count = 1 then
    begin
      if Source.Count > 1 then
      begin
        S := ChangeFileExt(Source.Strings[Source.Count - 1], '.o');
        S := EscapeString(ConvertToUnixSlashes(S));
        OutFile.Add('         ' + S + ' \');
      end;
      S := ChangeFileExt(Resources.Strings[0], '.res');
      S := EscapeString(ConvertToUnixSlashes(S));
      OutFile.Add('         ' + S);
    end
    else if Source.Count > 1 then
    begin
      S := ChangeFileExt(Source.Strings[Source.Count - 1], '.o');
      S := EscapeString(ConvertToUnixSlashes(S));
      OutFile.Add('         ' + S);
    end;
  end
  else if Resources.Count = 1 then
  begin
    S := ChangeFileExt(Resources.Strings[0], '.res');
    S := EscapeString(ConvertToUnixSlashes(S));
    OutFile.Add('OBJS   = ' + S);
  end;
  OutFile.Add('');
  if Length(CompilerPath) > 0 then
  begin
    OutFile.Add(Trim('LIBS   = -L"' + CompilerPath + '\lib" ' + Libs));
    OutFile.Add(Trim('CFLAGS = -I"' + CompilerPath + '\include" ' + Flags + mFlags));
  end
  else
  begin
    OutFile.Add(Trim('LIBS   = ' + Libs));
    OutFile.Add(Trim('CFLAGS = ' + Flags + mFlags));
  end;
  OutFile.Add('');

  if not Echo then
    EchoStr := '@';
  aTarget := ConvertToUnixSlashes(Target);
  S := EscapeString(aTarget);
  Temp := 'all';
  if CleanBefore then
    Temp := 'clean ' + Temp;
  if CleanAfter then
    Temp := Temp + ' clear';
  OutFile.Add('.PHONY: ' + Temp);
  OutFile.Add('');
  OutFile.Add('all: ' + S);
  OutFile.Add('');
  OutFile.Add('clean:');
  OutFile.Add(TabChar + EchoStr + '$(RM) $(OBJS) ' + S);
  OutFile.Add('');
  OutFile.Add('clear:');
  OutFile.Add(TabChar + EchoStr + '$(RM) $(OBJS)');
  OutFile.Add('');
  Cop := Trim(CompilerOptions);
  if DebugMode then
    Cop := Trim('-g ' + Cop);
  if Length(S) > 0 then
    Cop := Cop + ' ';
  if Pos(' ', aTarget) > 0 then
    aTarget := '''$@'''
  else
    aTarget := '$@';
  OutFile.Add(S + ': $(OBJS)');
  if CreateLibrary then
  begin
    OutFile.Add(TabChar + EchoStr + '$(AR) rc ' + aTarget + ' $(OBJS)');
    OutFile.Add(TabChar + EchoStr + '$(RANLIB) ' + aTarget);
  end
  else
  begin
    Temp := ' $(OBJS) $(LIBS)';
    if CompilerIsCpp then
      OutFile.Add(TabChar + EchoStr + '$(CPP) ' + Cop + '-o ' + aTarget + Temp)
    else
      OutFile.Add(TabChar + EchoStr + '$(CC) ' + Cop + '-o ' + aTarget + Temp);
  end;
  OutFile.Add('');

  for I := 0 to Source.Count - 1 do
  begin
    Temp := ConvertToUnixSlashes(Source.Strings[I]);
    S := ChangeFileExt(Temp, '.o');
    IncludeHeaders := '';
    Includes := TStrings(Source.Objects[I]);
    for J := 0 to Includes.Count - 1 do
      IncludeHeaders := IncludeHeaders + ' ' + EscapeString(ConvertToUnixSlashes(Includes.Strings[J]));
    OutFile.Add(EscapeString(S) + ': ' + EscapeString(Temp) + IncludeHeaders);
    if Pos(' ', S) > 0 then
      S := '''$@'''
    else
      S := '$@';
    if Pos(' ', Temp) > 0 then
      Temp := '''$<'''
    else
      Temp := '$<';
    if CompilerIsCpp then
      OutFile.Add(TabChar + EchoStr + '$(CPP) ' + Cop + '-c ' + Temp + ' -o ' + S + ' $(CFLAGS)')
    else
      OutFile.Add(TabChar + EchoStr + '$(CC) ' + Cop + '-c ' + Temp + ' -o ' + S + ' $(CFLAGS)');
    OutFile.Add('');
  end;
  if Resources.Count = 1 then
  begin
    Temp := ConvertToUnixSlashes(Resources.Strings[0]);
    S := ChangeFileExt(Temp, '.res');
    OutFile.Add(EscapeString(S) + ': ' + EscapeString(Temp));
    S := SingleQuotedStr(S);
    Temp := SingleQuotedStr(Temp);
    rTarget := '';
    if Pos('-m32', Libs) > 0 then
      rTarget := ' -F pe-i386';
    OutFile.Add(TabChar + EchoStr + '$(WINDRES) -i ' + Temp + ' -J rc -o ' + S + ' -O coff' + rTarget);
    OutFile.Add('');
  end;

  try
    OutFile.SaveToFile(FileName);
  except
    Result := 3;
  end;
  OutFile.Free;
  Resources.Free;
  Source.Free;
end;

end.
