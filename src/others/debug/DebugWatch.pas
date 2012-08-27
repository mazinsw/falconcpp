unit DebugWatch;

interface

uses
  Windows, Controls, Classes, SysUtils, TokenList;

type
  TWatchType = (wtAuto, wtUser, wtNone);

  TWatchVariable = class
  private
    FIndex: Integer;
    FWatchType: TWatchType;
    FInitialized: Boolean;
    FValue: string;
    FSelLine: Integer;
    FSelStart: Integer;
    FSelLength: Integer;
    FName: string;
    FToken: TTokenClass;
  public
    property Index: Integer read FIndex write FIndex;
    property WatchType: TWatchType read FWatchType write FWatchType;
    property Initialized: Boolean read FInitialized write FInitialized;
    property SelLine: Integer read FSelLine write FSelLine;
    property SelStart: Integer read FSelStart write FSelStart;
    property SelLength: Integer read FSelLength write FSelLength;
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
    property Token: TTokenClass read FToken write FToken;
  end;

  TDebugWatch = class
  private
    FID: Integer;
    FWatchType: TWatchType;
    FName: string;
  public
    constructor Create;
    property ID: Integer read FID write FID;
    property WatchType: TWatchType read FWatchType write FWatchType;
    property Name: string read FName write FName;
  end;

  TDebugWatchList = class
  private
    FList: TList;
    function Get(Index: Integer): TDebugWatch;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    function GetIndex(const Name: string): Integer; overload;
    function GetIndex(ID: Integer): Integer; overload;
    function WatchExists(const Name: string): Boolean;
    property Items[Index: Integer]: TDebugWatch read Get;
    function GetWatchID(const Name: string): Integer;
    function AddWatch(ID: Integer; WatchType: TWatchType;
      const Name: string): Boolean;
    function DeleteWatch(const Name: string): Boolean; overload;
    function DeleteWatch(ID: Integer): Boolean; overload;
    function UpdateID(const Name: string; ID: Integer): Integer;
  end;

implementation

{TDebugWatch}

constructor TDebugWatch.Create;
begin
  inherited Create;
  FID := 0;
  FWatchType := wtAuto;
end;

{TDebugWatchList}

constructor TDebugWatchList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TDebugWatchList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TDebugWatchList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TDebugWatchList.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TDebugWatch(FList.Items[I]).Free;
  FList.Clear;
end;

function TDebugWatchList.Get(Index: Integer): TDebugWatch;
begin
  Result := TDebugWatch(FList.Items[Index]);
end;

function TDebugWatchList.GetWatchID(const Name: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  Index := GetIndex(Name);
  if Index < 0 then
    Exit;
  Result := Items[Index].ID;
end;

function TDebugWatchList.WatchExists(const Name: string): Boolean;
begin
  Result := GetWatchID(Name) > 0;
end;

function TDebugWatchList.AddWatch(ID: Integer; WatchType: TWatchType;
  const Name: string): Boolean;
var
  I, PrevIndex: Integer;
  Watch: TDebugWatch;
begin
  Result := False;
  PrevIndex := -1;
  for I := 0 to FList.Count - 1 do
  begin
    Watch := TDebugWatch(FList.Items[I]);
    if Watch.ID = ID then
      Exit
    else if Watch.ID > ID then
      Break;
    PrevIndex := I;
    if I = FList.Count - 1 then
      Inc(PrevIndex);
  end;
  Watch := TDebugWatch.Create;
  Watch.ID := ID;
  Watch.WatchType := WatchType;
  Watch.Name := Name;
  if PrevIndex < 0 then
    FList.Insert(0, Watch)
  else
    FList.Insert(PrevIndex, Watch);
  Result := True;
end;

function TDebugWatchList.DeleteWatch(const Name: string): Boolean;
var
  Index: Integer;
begin
  Result := False;
  Index := GetIndex(Name);
  if Index < 0 then
    Exit;
  Items[Index].Free;
  FList.Delete(Index);
  Result := True;
end;

function TDebugWatchList.DeleteWatch(ID: Integer): Boolean;
var
  Index: Integer;
begin
  Result := False;
  Index := GetIndex(ID);
  if Index < 0 then
    Exit;
  Items[Index].Free;
  FList.Delete(Index);
  Result := True;
end;

function TDebugWatchList.GetIndex(const Name: string): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[I].Name = Name then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TDebugWatchList.GetIndex(ID: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[I].ID = ID then
    begin
      Result := I;
      Exit;
    end;
    if Items[I].ID > ID then
      Break;
  end;
  Result := -1;
end;

function TDebugWatchList.UpdateID(const Name: string; ID: Integer): Integer;
begin
  Result := GetIndex(Name);
  if Result > 0 then
    Items[Result].FID := ID;
end;

end.
