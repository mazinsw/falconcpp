unit CommandQueue;

interface

uses
  Windows, Classes;

type
  TDebugCommandType = (dctPrint, dctAutoWatch, dctNone);
  TDebugCommand = class
  public
    CmdType: TDebugCommandType;
    ID: Integer;
    Command: string;
    VarName: string;
    Line: Integer;
    SelStart: Integer;
    Data: Pointer;
    Point: TPoint;
  end;

  TCommandQueue = class
  private
    FList: TList;
    function GetFront: TDebugCommand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Dequeue;
    procedure Clear;
    function Count: Integer;
    function Empty: Boolean;
    procedure Push(CmdType: TDebugCommandType; Command: string; ID: Integer;
      VarName: string; Line, SelStart: Integer; Data: Pointer; Point: TPoint);
    property Front: TDebugCommand read GetFront;
  end;

implementation

{TCommandQueue}

function TCommandQueue.GetFront: TDebugCommand;
begin
  if not Empty then
    Result := TDebugCommand(FList.First)
  else
    Result := nil;
end;

constructor TCommandQueue.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TCommandQueue.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TCommandQueue.Dequeue;
begin
  if Empty then
    Exit;
  TDebugCommand(FList.First).Free;
  FList.Delete(0);
end;

procedure TCommandQueue.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TDebugCommand(FList.Items[I]).Free;
  FList.Clear;
end;

function TCommandQueue.Count: Integer;
begin
  Result := FList.Count;
end;

function TCommandQueue.Empty: Boolean;
begin
  Result := FList.Count = 0;
end;

procedure TCommandQueue.Push(CmdType: TDebugCommandType; Command: string;
  ID: Integer; VarName: string; Line, SelStart: Integer; Data: Pointer;
  Point: TPoint);
var
  dbgc: TDebugCommand;
begin
  dbgc := TDebugCommand.Create;
  dbgc.CmdType := CmdType;
  dbgc.ID := ID;
  dbgc.Command := Command;
  dbgc.VarName := VarName;
  dbgc.Line := Line;
  dbgc.SelStart := SelStart;
  dbgc.Data := Data;
  dbgc.Point := Point;
  FList.Insert(Count, dbgc);
end;

end.
