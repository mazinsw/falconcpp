unit Breakpoint;

interface

uses
  Windows, Controls, Classes, SysUtils, SynEdit;

type
  TBreakpoint = class
  private
    FIndex: Integer;
    FLine: Integer;
    FValid: Boolean;
    FEnable: Boolean;
    FFileName: string;
  public
    constructor Create;
    property Index: Integer read FIndex write FIndex;
    property Line: Integer read FLine write FLine;
    property Valid: Boolean read FValid write FValid;
    property Enable: Boolean read FEnable write FEnable;
    property FileName: string read FFileName write FFileName;
  end;

  TBreakpointList = class
  private
    FList: TList;
    FImageList: TImageList;
    FImageIndex: Integer;
    FInvalidIndex: Integer;
    function GetBreakpointIndex(Line: Integer): Integer;
    procedure SetImageList(Value: TImageList);
    procedure SetImageIndex(Value: Integer);
    function Get(Index: Integer): TBreakpoint;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    function HasBreakpoint(Line: Integer): Boolean;
    procedure DrawBreakpoint(Editor: TSynEdit; Line, X, Y: Integer);
    function ToogleBreakpoint(Line: Integer): Boolean;
    function GetBreakpoint(Line: Integer): TBreakpoint;
    property Items[Index: integer]: TBreakpoint read Get;
    property ImageList: TImageList read FImageList write SetImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property InvalidIndex: Integer read FInvalidIndex write FInvalidIndex;
  end;

implementation

{TBreakpoint}

constructor TBreakpoint.Create;
begin
  inherited Create;
  FLine := 0;
  FValid := True;
  FEnable := True;
end;

{TBreakpointList}

function TBreakpointList.Count: Integer;
begin
  Result := FList.Count;
end;

function TBreakpointList.Get(Index: Integer): TBreakpoint;
begin
  Result := TBreakpoint(FList.Items[Index]);
end;

function TBreakpointList.GetBreakpointIndex(Line: Integer): Integer;
var
  I: Integer;
  Breakpoint: TBreakpoint;
begin
  Result := -1;
  for I := 0 to FList.Count - 1 do
  begin
    Breakpoint := TBreakpoint(FList.Items[I]);
    if Breakpoint.Line > Line then
      Exit;
    if Breakpoint.Line = Line then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure TBreakpointList.SetImageList(Value: TImageList);
begin
  if Value <> FImageList then
  begin
    FImageList := Value;
  end;
end;

procedure TBreakpointList.SetImageIndex(Value: Integer);
begin
  if Value <> FImageIndex then
  begin
    FImageIndex := Value;
    if FInvalidIndex = -1 then
      FInvalidIndex := FImageIndex + 1;
  end;
end;

constructor TBreakpointList.Create;
begin
  inherited Create;
  FList := TList.Create;
  FImageIndex := -1;
  FInvalidIndex := -1;
end;

destructor TBreakpointList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TBreakpointList.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TBreakpoint(FList.Items[I]).Free;
  FList.Clear;
end;

function TBreakpointList.HasBreakpoint(Line: Integer): Boolean;
begin
  Result := GetBreakpointIndex(Line) <> -1;
end;

procedure TBreakpointList.DrawBreakpoint(Editor: TSynEdit; Line, X, Y: Integer);
var
  Breakpoint: TBreakpoint;
  Index, DrawIndex: Integer;
begin
  Index := GetBreakpointIndex(Line);
  if Index < 0 then
    Exit;
  Breakpoint := TBreakpoint(FList.Items[Index]);
  if not Assigned(FImageList) or not Assigned(Editor) then
    Exit;
  DrawIndex := FImageIndex;
  if not Breakpoint.Valid then
    DrawIndex := FInvalidIndex;
  FImageList.Draw(Editor.Canvas, X, Y, DrawIndex, Breakpoint.Enable);
end;

function TBreakpointList.ToogleBreakpoint(Line: Integer): Boolean;
var
  I, PrevIndex: Integer;
  Breakpoint: TBreakpoint;
begin
  PrevIndex := -1;
  for I := 0 to FList.Count - 1 do
  begin
    Breakpoint := TBreakpoint(FList.Items[I]);
    if Breakpoint.Line > Line then
      Break;
    if Breakpoint.Line = Line then
    begin
      FList.Delete(I);
      Breakpoint.Free;
      Result := False;
      Exit;
    end;
    PrevIndex := I;
    if I = FList.Count - 1 then
      Inc(PrevIndex);
  end;
  Breakpoint := TBreakpoint.Create;
  Breakpoint.Line := Line;
  if PrevIndex < 0 then
    FList.Insert(0, Breakpoint)
  else
    FList.Insert(PrevIndex, Breakpoint);
  Result := True;
end;

function TBreakpointList.GetBreakpoint(Line: Integer): TBreakpoint;
var
  Index: Integer;
begin
  Index := GetBreakpointIndex(Line);
  if Index < 0 then
  begin
    Result := nil;
    Exit;
  end;
  Result := TBreakpoint(FList.Items[Index]);
end;

end.
