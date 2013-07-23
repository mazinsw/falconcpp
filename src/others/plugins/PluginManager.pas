unit PluginManager;

interface

uses
  Windows, Classes, Plugin;

type
  TPluginMsg = record
    Command: Integer;
    Widget: Integer;
    Param: Integer;
    Data: Integer;
  end;
  PPluginMsg = ^TPluginMsg;

  TPluginManager = class
  private
    FList: TList;
    FOwnerHandle: HWND;
//    function IndexOf(Item: TPlugin): Integer;
//    function Remove(Item: TPlugin): Integer;
    function Add(Item: TPlugin): Integer;
//    procedure Delete(Index: Integer);
  protected
    function GetCount: Integer;
    function Get(Index: Integer): TPlugin;
  public
    constructor Create(OwnerHandle: HWND);
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromDir(DirName: string);
    function ReceiveCommand(Plugin, Command, Widget, Param, Data: Integer): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPlugin read Get; default;
  end;

implementation

uses
  PluginUtils, SysUtils;

{ TPluginManager }

function TPluginManager.Add(Item: TPlugin): Integer;
begin
  Result := FList.Add(Item);
end;

procedure TPluginManager.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  FList.Clear;
end;

constructor TPluginManager.Create(OwnerHandle: HWND);
begin
  inherited Create;
  FList := TList.Create;
  FOwnerHandle := OwnerHandle;
end;

//procedure TPluginManager.Delete(Index: Integer);
//begin
//  Items[Index].Free;
//  FList.Delete(Index);
//end;

destructor TPluginManager.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TPluginManager.Get(Index: Integer): TPlugin;
begin
  Result := TPlugin(FList.Items[Index]);
end;

function TPluginManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

//function TPluginManager.IndexOf(Item: TPlugin): Integer;
//begin
//  Result := FList.IndexOf(Item);
//end;

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
      Plugin := TPlugin.Create(List[I]);
      try
        Plugin.Initialize(FOwnerHandle);
        Add(Plugin);
      except
        Plugin.Free;
      end;
    except
    end;
  end;
  List.Free;
end;

function TPluginManager.ReceiveCommand(Plugin, Command, Widget,
  Param, Data: Integer): Integer;
var
  ptr: PChar;
begin
  ptr := PChar(Data);
  MessageBox(0, ptr, 'PluginManager', MB_ICONINFORMATION);
  Result := 5;
end;

//function TPluginManager.Remove(Item: TPlugin): Integer;
//begin
//  Result := FList.Remove(Item);
//  Item.Free;
//end;

end.
