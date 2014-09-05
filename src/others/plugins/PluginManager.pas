unit PluginManager;

interface

uses
  Windows, Classes, Plugin, PluginServiceManager;

type
  TPluginManager = class
  private
    FList: TList;
    FDispatchHandle: HWND;
    FServiceManager: TPluginServiceManager;
    function Add(Item: TPlugin): Integer;
    function FindPlugin(PluginID: Integer): TPlugin;
    function GetInsertIndex(PluginID: Integer): Integer;
  protected
    function GetCount: Integer;
    function Get(Index: Integer): TPlugin;
  public
    constructor Create(ServiceManager: TPluginServiceManager);
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromDir(DirName: string);
    procedure Delete(PluginID: Integer);
    function DispachCommand(Command, Widget, Param: Integer;
      Data: Pointer): Integer;
    function ReceiveCommand(PluginID, Command, Widget, Param: Integer;
      Data: Pointer): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPlugin read Get; default;
  end;

implementation

uses
  PluginUtils, SysUtils, PluginConst;

{ TPluginManager }

function TPluginManager.Add(Item: TPlugin): Integer;
begin
  Result := GetInsertIndex(Item.ID);
  if (Result < FList.Count) and (Items[Result].ID = Item.ID) then
    raise Exception.CreateFmt(pluginAlreadyExists, [Item.ID]);
  FList.Insert(Result, Item);
end;

procedure TPluginManager.Clear;
var
  I: Integer;
begin
  for I := FList.Count - 1 downto 0 do
    FServiceManager.DispatcheCommand(Items[I], Cmd_Free, Items[I].ID, 0, nil);
end;

constructor TPluginManager.Create(ServiceManager: TPluginServiceManager);
begin
  inherited Create;
  FServiceManager := ServiceManager;
  FDispatchHandle := ServiceManager.DispatchHandle;
  FList := TList.Create;
end;

procedure TPluginManager.Delete(PluginID: Integer);
var
  I: Integer;
begin
  I := GetInsertIndex(PluginID);
  if (I >= FList.Count) or (Items[I].ID <> PluginID) then
    Exit; // raise ?
  Items[I].DispatchCommand(Cmd_Destroy, PluginID, 0, nil);
  Items[I].Free;
  FList.Delete(I);
end;

destructor TPluginManager.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TPluginManager.DispachCommand(Command, Widget, Param: Integer;
  Data: Pointer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := FList.Count - 1 downto 0 do
    Items[I].DispatchCommand(Command, Widget, Param, Data);
end;

function TPluginManager.GetInsertIndex(PluginID: Integer): Integer;
var
  I, J: Integer;
  Plugin: TPlugin;
begin
  I := 0;
  Result := 0;
  J := FList.Count - 1;
  // binary search
  while I <= J do
  begin
    Result := (I + J) div 2;
    Plugin := TPlugin(FList.Items[Result]);
    if PluginID > Plugin.ID then
    begin
      I := Result + 1;
      Inc(Result);
    end
    else if PluginID < Plugin.ID then
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

function TPluginManager.FindPlugin(PluginID: Integer): TPlugin;
var
  I: Integer;
begin
  I := GetInsertIndex(PluginID);
  if (I < FList.Count) and (TPlugin(FList.Items[I]).ID = PluginID) then
    Result := TPlugin(FList.Items[I])
  else
    Result := nil;
end;

function TPluginManager.Get(Index: Integer): TPlugin;
begin
  Result := TPlugin(FList.Items[Index]);
end;

function TPluginManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TPluginManager.LoadFromDir(DirName: string);
var
  List: TStrings;
  I: Integer;
  Plugin: TPlugin;
begin
  List := TStringList.Create;
  ListDir(IncludeTrailingPathDelimiter(DirName), '*.plg', List);
  for I := 0 to List.Count - 1 do
  begin
    try
      Plugin := TPlugin.Create(List[I], FDispatchHandle);
      try
        Add(Plugin);
        Plugin.DispatchCommand(Cmd_Create, Plugin.ID, 0, nil);
      except
        Plugin.Free;
      end;
    except
    end;
  end;
  List.Free;
end;

function TPluginManager.ReceiveCommand(PluginID, Command, Widget,
  Param: Integer; Data: Pointer): Integer;
var
  Plugin: TPlugin;
begin
  Plugin := FindPlugin(PluginID);
  if Plugin = nil then
    Result := -1
  else
    Result := FServiceManager.DispatcheCommand(Plugin, Command, Widget,
      Param, Data);
end;

end.
