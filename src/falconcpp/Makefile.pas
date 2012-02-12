unit Makefile;

interface

uses
  Windows, SysUtils, Classes;

const
  TabChar = #9;

type
  TMakefile = class
  private
    FTarget: String;
    FCompilerPath: String;
    FBaseDir: String;
    FLibs: String;
    FFlags: String;
    FCompilerOptions: String;
    FFileName: String;
    FCreateLibrary: Boolean;
    FFiles: TStrings;
    FCompilerIsCpp: Boolean;
    FCleanBefore: Boolean;
    FCleanAfter: Boolean;
    FDebugMode: Boolean;
    FEcho: Boolean;
    procedure SetFiles(Value: TStrings);
    procedure SelectFilesByExt(Extensions: array of String; List: TStrings);
    procedure TransformToRelativePath;
  public
    constructor Create;
    destructor Destroy; override;
    function BuildMakefile: Integer;
    property Target: String read FTarget write FTarget;
    property CompilerPath: String read FCompilerPath write FCompilerPath;
    property BaseDir: String read FBaseDir write FBaseDir;
    property Libs: String read FLibs write FLibs;
    property Flags: String read FFlags write FFlags;
    property CompilerOptions: String read FCompilerOptions write FCompilerOptions;
    property FileName: String read FFileName write FFileName;
    property CreateLibrary: Boolean read FCreateLibrary write FCreateLibrary;
    property Files: TStrings read FFiles write SetFiles;
    property CompilerIsCpp: Boolean read FCompilerIsCpp write FCompilerIsCpp;
    property CleanBefore: Boolean read FCleanBefore write FCleanBefore;
    property CleanAfter: Boolean read FCleanAfter write FCleanAfter;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
    property Echo: Boolean read FEcho write FEcho;
  end;

implementation

function ConvertAnsiToOem(const S: String): String;
begin
  Result := '';
  if Length(s) = 0 then Exit;
  SetLength(Result, Length(S));
  AnsiToOem(PChar(S), PChar(Result));
end;

function EscapeString(const S: String): String;
begin
  Result := StringReplace(S, ' ', '\ ', [rfReplaceAll]);
end;

function DoubleQuotedStr(const S: string): string;
begin
  Result := S;
  if Pos(' ', Trim(S)) > 0 then
    Result := '"' + Result + '"';
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
  I: Integer;
begin
  for I:= 0 to Pred(Files.Count) do
    Files.Strings[I] := ExtractRelativePath(BaseDir, Files.Strings[I]);
end;

procedure TMakefile.SelectFilesByExt(Extensions: array of String; List: TStrings);
var
  I, X: Integer;
begin
  for I:= 0 to Pred(Files.Count) do
  begin
    for X:= 0 to Pred(Length(Extensions)) do
    begin
      if CompareText(ExtractFileExt(Files.Strings[I]), Extensions[X]) = 0 then
        List.Add(Files.Strings[I]);
    end;
  end;
end;

function TMakefile.BuildMakefile: Integer;
var
  Source, Resources, OutFile: TStrings;
  I: Integer;
  S, Temp, Cop, EchoStr: String;
  ShowAnsiOBJS: Boolean;
begin
  Result := 0;
  EchoStr := '';
  Source := TStringList.Create;
  Resources := TStringList.Create;
  OutFile := TStringList.Create;
  TransformToRelativePath;
  SelectFilesByExt(['.c', '.cpp', '.cc', '.cxx', '.c++', '.cp'], Source);
  SelectFilesByExt(['.rc'], Resources);
  if CompilerIsCpp then
    OutFile.Add('CPP    = g++.exe')
  else
    OutFile.Add('CC     = gcc.exe');
  if Resources.Count > 0 then
    OutFile.Add('WINDRES= windres.exe');
  if CreateLibrary then
  begin
    OutFile.Add('AR     =ar.exe');
    OutFile.Add('RANLIB =ranlib.exe');
  end;
  ShowAnsiOBJS := False;
  if Source.Count > 0 then
  begin
    S := ChangeFileExt(Source.Strings[0], '.o');
    if(ConvertAnsiToOem(S) <> S) then
      ShowAnsiOBJS := True;
    S := EscapeString(ConvertAnsiToOem(S));
    if (Source.Count + Resources.Count) > 1 then
      OutFile.Add('OBJS   =' + S + ' \')
    else
      OutFile.Add('OBJS   =' + S);

    for I := 1 to Source.Count - 2 do
    begin
      S := ChangeFileExt(Source.Strings[I], '.o');
      if(ConvertAnsiToOem(S) <> S) then
        ShowAnsiOBJS := True;
      S := EscapeString(ConvertAnsiToOem(S));
      OutFile.Add('        ' + S + ' \');
    end;
    if Resources.Count = 1 then
    begin
      if Source.Count > 1 then
      begin
        S := ChangeFileExt(Source.Strings[Source.Count - 1], '.o');
        if(ConvertAnsiToOem(S) <> S) then
          ShowAnsiOBJS := True;
        S := EscapeString(ConvertAnsiToOem(S));
        OutFile.Add('        ' + S + ' \');
      end;
      S := ChangeFileExt(Resources.Strings[0], '.res');
      if(ConvertAnsiToOem(S) <> S) then
        ShowAnsiOBJS := True;
      S := EscapeString(ConvertAnsiToOem(S));
      OutFile.Add('        ' + S);
    end
    else if Source.Count > 1 then
    begin
      S := ChangeFileExt(Source.Strings[Source.Count - 1], '.o');
      if(ConvertAnsiToOem(S) <> S) then
        ShowAnsiOBJS := True;
      S := EscapeString(ConvertAnsiToOem(S));
      OutFile.Add('        ' + S);
    end;
  end
  else if Resources.Count = 1 then
  begin
    S := ChangeFileExt(Resources.Strings[0], '.res');
    if(ConvertAnsiToOem(S) <> S) then
      ShowAnsiOBJS := True;
    S := EscapeString(ConvertAnsiToOem(S));
    OutFile.Add('OBJS   =' + S);
  end;
  OutFile.Add('');

  if ShowAnsiOBJS then
  begin
    if Source.Count > 0 then
    begin
      S := ChangeFileExt(Source.Strings[0], '.o');
      S := DoubleQuotedStr(ConvertAnsiToOem(S));
      if (Source.Count + Resources.Count) > 1 then
        OutFile.Add('AOBJS  =' + S + ' \')
      else
        OutFile.Add('AOBJS  =' + S);

      for I := 1 to Source.Count - 2 do
      begin
        S := ChangeFileExt(Source.Strings[I], '.o');
        S := DoubleQuotedStr(ConvertAnsiToOem(S));
        OutFile.Add('        ' + S + ' \');
      end;
      if Resources.Count = 1 then
      begin
        if Source.Count > 1 then
        begin
          S := ChangeFileExt(Source.Strings[Source.Count - 1], '.o');
          S := DoubleQuotedStr(ConvertAnsiToOem(S));
          OutFile.Add('        ' + S + ' \');
        end;
        S := ChangeFileExt(Resources.Strings[0], '.res');
        S := DoubleQuotedStr(ConvertAnsiToOem(S));
        OutFile.Add('        ' + S);
      end
      else if Source.Count > 1 then
      begin
        S := ChangeFileExt(Source.Strings[Source.Count - 1], '.o');
        S := DoubleQuotedStr(ConvertAnsiToOem(S));
        OutFile.Add('        ' + S);
      end;
    end
    else if Resources.Count = 1 then
    begin
      S := ChangeFileExt(Resources.Strings[0], '.res');
      S := DoubleQuotedStr(ConvertAnsiToOem(S));
      OutFile.Add('OBJS   =' + S);
    end;
    OutFile.Add('');
  end;

  if Length(CompilerPath) > 0 then
  begin
    OutFile.Add(Trim('LIBS   = -L"' + CompilerPath + '\lib" ' + Libs));
    OutFile.Add(Trim('CFLAGS = -I"' + CompilerPath + '\include" ' + Flags));
  end
  else
  begin
    OutFile.Add(Trim('LIBS   = ' + Libs));
    OutFile.Add(Trim('CFLAGS = ' + Flags));
  end;
  OutFile.Add('');

  if not Echo then
    EchoStr := '@';
  S := 'build';
  if CleanBefore then S := 'clean-before ' + S;
  if CleanAfter then S := S + ' clean-after';
  OutFile.Add('all: ' + S);
  OutFile.Add('');
  if CleanBefore then
  begin
    OutFile.Add('clean-before:');
    OutFile.Add(TabChar + EchoStr + 'for %%i in ($(OBJS)) do if exist %%i del /f %%i');
    OutFile.Add('');
  end;
  if CleanAfter then
  begin
    OutFile.Add('clean-after:');
    OutFile.Add(TabChar + EchoStr + 'for %%i in ($(OBJS)) do if exist %%i del /f %%i');
    OutFile.Add('');
  end;
  Cop := Trim(CompilerOptions);
  if DebugMode then
    Cop := Trim('-g ' + Cop);
  if Length(S) > 0 then
    Cop := Cop + ' ';
  S := DoubleQuotedStr(ConvertAnsiToOem(Target));
  OutFile.Add('build' + ': $(OBJS)');
  if CreateLibrary then
  begin
    OutFile.Add(TabChar + EchoStr + '$(AR) rc ' + S + ' $(OBJS)');
    OutFile.Add(TabChar + EchoStr + '$(RANLIB) ' + S);
  end
  else
  begin
    Temp := ' $(OBJS) $(LIBS)';
    if ShowAnsiOBJS then
      Temp := ' $(AOBJS) $(LIBS)';
    if CompilerIsCpp then
      OutFile.Add(TabChar + EchoStr + '$(CPP) ' + Cop + '-o ' + S + Temp)
    else
      OutFile.Add(TabChar + EchoStr + '$(CC) ' + Cop + '-o ' + S + Temp);
  end;
  OutFile.Add('');

  for I := 0 to Source.Count - 1 do
  begin
    S := ChangeFileExt(Source.Strings[I], '.o');
    S := ConvertAnsiToOem(S);
    Temp := Source.Strings[I];
    OutFile.Add(EscapeString(S) + ': ' + EscapeString(Temp));
    S := DoubleQuotedStr(S);
    Temp := DoubleQuotedStr(ConvertAnsiToOem(Temp));
    if CompilerIsCpp then
      OutFile.Add(TabChar + EchoStr + '$(CPP) ' + Cop + '-c ' + Temp + ' -o ' + S + ' $(CFLAGS)')
    else
      OutFile.Add(TabChar + EchoStr + '$(CC) ' + Cop + '-c ' + Temp + ' -o ' + S + ' $(CFLAGS)');
    OutFile.Add('');
  end;
  if Resources.Count = 1 then
  begin
    S := ChangeFileExt(Resources.Strings[0], '.res');
    S := ConvertAnsiToOem(S);
    Temp := Resources.Strings[0];
    OutFile.Add(EscapeString(S) + ': ' + EscapeString(Temp));
    S := DoubleQuotedStr(S);
    Temp := DoubleQuotedStr(ConvertAnsiToOem(Temp));
    OutFile.Add(TabChar + EchoStr + '$(WINDRES) -i ' + Temp + ' -J rc -o ' + S + ' -O coff');
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
