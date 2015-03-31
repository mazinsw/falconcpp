unit CompilerSettings;

interface

uses
  Classes;

type
  TVariable = class
  private
    FName: string;
    FValue: string;
  public
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
  end;

  TProgramTool = class
  private
    FName: string;
    FVersion: string;
    FExecutable: string;
    FParameters: string;
  protected
    function FindValue(const Key: string; Variables: TList): string; virtual;
  public
    procedure Assign(Value: TProgramTool); virtual;
    procedure Prepare(var Executable, Parameters: string; Variables: TList);

    property Name: string read FName write FName;
    property Version: string read FVersion write FVersion;
    property Executable: string read FExecutable write FExecutable;
    property Parameters: string read FParameters write FParameters;
  end;

  TCompilerTool = class(TProgramTool)
  private
  protected
    function FindValue(const Key: string; Variables: TList): string; override;
  public
  end;

  TMakeTool = class(TProgramTool)
  private
    FJobs: Integer;
  protected
    function FindValue(const Key: string; Variables: TList): string; override;
  public
    procedure Assign(Value: TProgramTool); override;

    property Jobs: Integer read FJobs write FJobs;
  end;

  TDebuggerTool = class(TCompilerTool)
  private
    FReverse: Boolean;
    procedure SetReverse(const Value: Boolean);
  public
    procedure Assign(Value: TProgramTool); override;

    property Reverse: Boolean read FReverse write SetReverse;
  end;

  TCompilerType = (ctC, ctCplusplus, ctResource);

  TCompilerSettings = class
  private
    FFileName: string;
    FCompilers: array[TCompilerType] of TCompilerTool;
    FLibraryMaker: TProgramTool;
    FRemover: TProgramTool;
    FLinker: TProgramTool;
    FPath: string;
    FReadOnly: Boolean;
    FDebugger: TDebuggerTool;
    FMake: TMakeTool;
    FIncludes: TStrings;
    FLibraries: TStrings;
    function GetCompiler(CompilerType: TCompilerType): TCompilerTool;
    procedure SetCompiler(CompilerType: TCompilerType;
      const Value: TCompilerTool);
    procedure SetDebugger(const Value: TDebuggerTool);
    procedure SetFileName(const Value: string);
    procedure SetIncludes(const Value: TStrings);
    procedure SetLibraries(const Value: TStrings);
    procedure SetLibraryMaker(const Value: TProgramTool);
    procedure SetLinker(const Value: TProgramTool);
    procedure SetMake(const Value: TMakeTool);
    procedure SetPath(const Value: string);
    procedure SetRemover(const Value: TProgramTool);
    function GetName: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save;
    procedure Load;
    property FileName: string read FFileName write SetFileName;
    property Name: string read GetName;
    property CompilerPath: string read FPath write SetPath;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property Compiler[CompilerType: TCompilerType]: TCompilerTool
      read GetCompiler write SetCompiler;
    property Linker: TProgramTool read FLinker write SetLinker;
    property Make: TMakeTool read FMake write SetMake;
    property Debugger: TDebuggerTool read FDebugger write SetDebugger;
    property LibraryMaker: TProgramTool read FLibraryMaker write SetLibraryMaker;
    property Remover: TProgramTool read FRemover write SetRemover;
    property Includes: TStrings read FIncludes write SetIncludes;
    property Libraries: TStrings read FLibraries write SetLibraries;
  end;

implementation

uses
  SysUtils;

{ TProgramTool }

procedure TProgramTool.Assign(Value: TProgramTool);
begin
  FName := Value.FName;
  FVersion := Value.FVersion;
  FExecutable := Value.FExecutable;
  FParameters := Value.FParameters;
end;

function TProgramTool.FindValue(const Key: string; Variables: TList): string;
var
  I: Integer;
  Variable: TVariable;
begin
  Result := '';
  for I := 0 to Variables.Count - 1 do
  begin
    Variable := TVariable(Variables[I]);
    if SameText(Variable.Name, Key) then
    begin
      Result := Variable.Value;
      Break;
    end;
  end;
end;

procedure TProgramTool.Prepare(var Executable, Parameters: string;
  Variables: TList);
var
  Param: string;
  Ptr, PtrS, PtrInit: PChar;
  StartPos, EndPos, PrevEndPos: Integer;

  function NextParam: Boolean;
  begin
    Result := False;
    while Ptr^ <> #0 do
    begin
      if Ptr^ = '{' then
      begin
        Inc(Ptr);
        PtrS := Ptr;
        while (Ptr^ <> '}') and (Ptr^ <> #0) do
          Inc(Ptr);
        if Ptr^ = '}' then
        begin
          SetLength(Param, Ptr - PtrS);
          StrLCopy(PChar(Param), PtrS, Ptr - PtrS);
          Inc(Ptr);
          StartPos := PtrS - PtrInit + 1;
          EndPos := Ptr - PtrInit + 1;
          Result := True;
          Break;
        end
        else
          Continue;
      end
      else
        Inc(Ptr);
    end;
  end;

  function ParseString(const S: string): string;
  begin
    PtrInit := PChar(S);
    Ptr := PtrInit;
    Result := '';
    PrevEndPos := 1;
    while NextParam do
    begin
      // copy text before {
      Result := Result + Copy(S, PrevEndPos, StartPos - PrevEndPos);
      Result := Result + FindValue(Param, Variables);
      PrevEndPos := EndPos;
    end;
    // copy left text
    Result := Result + Copy(S, PrevEndPos, MaxInt);
  end;

begin
  Executable := ParseString(Name);
  Parameters := ParseString(Parameters);
end;

{ TDebuggerTool }

procedure TDebuggerTool.Assign(Value: TProgramTool);
begin
  inherited Assign(Value);
  FReverse := TDebuggerTool(Value).FReverse;
end;

procedure TDebuggerTool.SetReverse(const Value: Boolean);
begin
  if Value = FReverse then
    Exit;
  FReverse := Value;
end;

{ TCompilerSettings }

constructor TCompilerSettings.Create;
var
  I: TCompilerType;
begin
  for I := Low(TCompilerType) to High(TCompilerType) do
    FCompilers[I] := TCompilerTool.Create;
  FMake := TMakeTool.Create;
  FLinker := TProgramTool.Create;
  FLibraryMaker := TProgramTool.Create;
  FRemover := TProgramTool.Create;
  FDebugger := TDebuggerTool.Create;
  FIncludes := TStringList.Create;
  FLibraries := TStringList.Create;
end;

destructor TCompilerSettings.Destroy;
var
  I: TCompilerType;
begin
  FLibraries.Free;
  FIncludes.Free;
  FDebugger.Free;
  FRemover.Free;
  FLibraryMaker.Free;
  FLinker.Free;
  FMake.Free;
  for I := High(TCompilerType) downto Low(TCompilerType) do
    FCompilers[I].Free;
  inherited;
end;

function TCompilerSettings.GetCompiler(
  CompilerType: TCompilerType): TCompilerTool;
begin
  Result := FCompilers[CompilerType];
end;

function TCompilerSettings.GetName: string;
begin
  Result := ChangeFileExt(ExtractFileName(FFileName), '');
end;

procedure TCompilerSettings.Load;
begin

end;

procedure TCompilerSettings.Save;
begin

end;

procedure TCompilerSettings.SetCompiler(CompilerType: TCompilerType;
  const Value: TCompilerTool);
begin
  FCompilers[CompilerType].Assign(Value);
end;

procedure TCompilerSettings.SetDebugger(const Value: TDebuggerTool);
begin
  FDebugger.Assign(Value);
end;

procedure TCompilerSettings.SetFileName(const Value: string);
begin
  if FFileName = Value then
    Exit;
  FFileName := Value;
end;

procedure TCompilerSettings.SetIncludes(const Value: TStrings);
begin
  FIncludes.Assign(Value);
end;

procedure TCompilerSettings.SetLibraries(const Value: TStrings);
begin
  FLibraries.Assign(Value);
end;

procedure TCompilerSettings.SetLibraryMaker(const Value: TProgramTool);
begin
  FLibraryMaker.Assign(Value);
end;

procedure TCompilerSettings.SetLinker(const Value: TProgramTool);
begin
  FLinker.Assign(Value);
end;

procedure TCompilerSettings.SetMake(const Value: TMakeTool);
begin
  FMake.Assign(Value);
end;

procedure TCompilerSettings.SetPath(const Value: string);
begin
  if FPath = Value then
    Exit;
  FPath := Value;
end;

procedure TCompilerSettings.SetRemover(const Value: TProgramTool);
begin
  FRemover.Assign(Value);
end;

{ TMakeTool }

procedure TMakeTool.Assign(Value: TProgramTool);
begin
  inherited Assign(Value);
  FJobs := TMakeTool(Value).FJobs;
end;

function TMakeTool.FindValue(const Key: string; Variables: TList): string;
begin
  if SameText(Key, 'processors') then
    Result := IntToStr(FJobs)
  else
    inherited FindValue(Key, Variables);
end;

{ TCompilerTool }

function TCompilerTool.FindValue(const Key: string; Variables: TList): string;
begin
  if SameText(Key, 'compiler') then
    Result := Executable
  else
    inherited FindValue(Key, Variables);
end;

end.
