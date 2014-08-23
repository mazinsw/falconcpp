unit Breakpoint;

interface

uses
  Windows, Controls, Classes, SysUtils, UEditor;

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
    procedure Assign(Value: TBreakpoint);
    property Index: Integer read FIndex write FIndex;
    property Line: Integer read FLine write FLine;
    property Valid: Boolean read FValid write FValid;
    property Enable: Boolean read FEnable write FEnable;
    property FileName: string read FFileName write FFileName;
  end;

  TBreakpointList = class
  private
    FList: TList;
    function GetBreakpointIndex(Line: Integer): Integer;
    function Get(Index: Integer): TBreakpoint;
    function GetCount: Integer;
    function GetInsertIndex(Line: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Value: TBreakpointList);
    function MoveBy(LineFrom, aCount: Integer): Integer;
    function HasBreakpoint(Line: Integer): Boolean;
    function DeleteFrom(LineBegin, LineEnd: Integer): Integer;
    function ToogleBreakpoint(Line: Integer): Boolean;
    function AddBreakpoint(Line: Integer): TBreakpoint;
    function GetBreakpoint(Line: Integer): TBreakpoint;
    property Count: Integer read GetCount;
    property Items[Index: integer]: TBreakpoint read Get;
  end;

implementation

{TBreakpoint}

procedure TBreakpoint.Assign(Value: TBreakpoint);
begin
  FIndex := Value.FIndex;
  FLine := Value.FLine;
  FValid := Value.FValid;
  FEnable := Value.FEnable;
  FFileName := Value.FFileName;
end;

constructor TBreakpoint.Create;
begin
  inherited Create;
  FLine := 0;
  FValid := True;
  FEnable := True;
end;

{TBreakpointList}

function TBreakpointList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBreakpointList.Get(Index: Integer): TBreakpoint;
begin
  Result := TBreakpoint(FList.Items[Index]);
end;

function TBreakpointList.GetInsertIndex(Line: Integer): Integer;
var
  I, J: Integer;
  Breakpoint: TBreakpoint;
begin
  I := 0;
  Result := 0;
  J := FList.Count - 1;
  // binary search
  while I <= J do
  begin
    Result := (I + J) div 2;
    Breakpoint := TBreakpoint(FList.Items[Result]);
    if Line > Breakpoint.Line then
    begin
      I := Result + 1;
      Inc(Result);
    end
    else if Line < Breakpoint.Line then
    begin
      J := Result - 1;
      if I <= J then
        Dec(Result);
    end
    else
      Exit;
  end;
  if Result < 0 then
    Result := 0;
end;

function TBreakpointList.GetBreakpointIndex(Line: Integer): Integer;
var
  I: Integer;
  Breakpoint: TBreakpoint;
begin
  Result := -1;
  I := GetInsertIndex(Line);
  if I >= FList.Count then
    Exit;
  Breakpoint := TBreakpoint(FList.Items[I]);
  if Breakpoint.Line = Line then
    Result := I;
end;

constructor TBreakpointList.Create;
begin
  inherited Create;
  FList := TList.Create;
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

function TBreakpointList.ToogleBreakpoint(Line: Integer): Boolean;
var
  I: Integer;
  Breakpoint: TBreakpoint;
begin
  I := GetInsertIndex(Line);
  if (I < FList.Count) and (Items[I].Line = Line) then
  begin
    Items[I].Free;
    FList.Delete(I);
    Result := False;
    Exit;
  end;
  Breakpoint := TBreakpoint.Create;
  Breakpoint.Line := Line;
  FList.Insert(I, Breakpoint);
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

function TBreakpointList.AddBreakpoint(Line: Integer): TBreakpoint;
var
  I: Integer;
  Breakpoint: TBreakpoint;
begin
  I := GetInsertIndex(Line);
  if (I < FList.Count) and (Items[I].Line = Line) then
  begin
    Result := Items[I];
    Exit;
  end;
  Breakpoint := TBreakpoint.Create;
  Breakpoint.Line := Line;
  FList.Insert(I, Breakpoint);
  Result := Breakpoint;
end;

procedure TBreakpointList.Assign(Value: TBreakpointList);
var
  I: Integer;
  bp: TBreakpoint;
begin
  Clear;
  for I := 0 to Value.Count - 1 do
  begin
    bp := TBreakpoint.Create;
    bp.Assign(Value.Items[I]);
    FList.Add(bp);
  end;
end;

function TBreakpointList.MoveBy(LineFrom, aCount: Integer): Integer;
var
  I, L: Integer;
  Breakpoint: TBreakpoint;
begin
  Result := 0;
  L := GetInsertIndex(LineFrom);
  if L < 0 then
    L := 0;
  for I := L to FList.Count - 1 do
  begin
    Breakpoint := TBreakpoint(FList.Items[I]);
    if Breakpoint.Line < LineFrom then
      Continue;
    Breakpoint.Line := Breakpoint.Line + aCount;
    Inc(Result);
  end;
end;

function TBreakpointList.DeleteFrom(LineBegin, LineEnd: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  I := GetInsertIndex(LineBegin);
  if I >= Count then
    Exit;
  if I < 0 then
    I := 0;
  while I < Count do
  begin
    if (Items[I].Line >= LineBegin) and (Items[I].Line <= LineEnd) then
    begin
      Items[I].Free;
      FList.Delete(I);
      Inc(Result);
      Continue;
    end
    else
      Break;
    Inc(I);
  end;
  while I < Count do
  begin
    Dec(Items[I].FLine, LineEnd - LineBegin + 1);
    Inc(I);
  end;
end;

end.
