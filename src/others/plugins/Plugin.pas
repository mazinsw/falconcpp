unit Plugin;

interface

uses
  Windows;

const
  PluginInitializeStr = 'Plugin_initialize';
  PluginExecuteStr = 'Plugin_execute';
  PluginExecuteEventStr = 'Plugin_executeEvent';
  PluginFinalizeStr = 'Plugin_finalize';

type
  TPluginInfo = record
    ID: Integer;
    Version: array[0..30] of Char;
    Name: array[0..100] of Char;
    Author: array[0..100] of Char;
    Description: array[0..255] of Char;
  end;

  TPluginInitialize   = function(Handle: HWND; var PluginInfo: TPluginInfo): Integer; cdecl;
  TPluginExecute      = function(Command, Widget, Param, Data: Integer): Integer; cdecl;
  TPluginExecuteEvent = function(Widget, Event, Data: Integer): Integer; cdecl;
  TPluginFinalize     = procedure; cdecl;

  TPlugin = class
  private
    FHandle: HMODULE;
    FID: Integer;
    FVersion: string;
    FName: string;
    FAuthor: string;
    FDescription: string;
    FPluginInitialize: TPluginInitialize;
    FPluginExecute: TPluginExecute;
    FPluginExecuteEvent: TPluginExecuteEvent;
    FPluginFinalize: TPluginFinalize;
    procedure Loaded;
    procedure ValidPlugin;
  protected
  public
    constructor Create(FileName: string);
    destructor Destroy; override;
    function Execute(Command, Widget, Param, Data: Integer): Integer;
    function ExecuteEvent(Widget, Event, Data: Integer): Integer;
    procedure Initialize(OwnerHandle: HWND);
    property ID: Integer read FID;
    property Version: string read FVersion;
    property Name: string read FName;
    property Author: string read FAuthor;
    property Description: string read FDescription;
  end;

implementation

uses
  SysUtils, PluginConst;

{ TPlugin }

constructor TPlugin.Create(FileName: string);
var
  FuncPtr: Pointer;
begin
  FHandle := LoadLibrary(PChar(FileName));
  if FHandle = 0 then
    raise Exception.CreateFmt(cannotLoadPlugin, [FileName]);
  FuncPtr := GetProcAddress(FHandle, PluginInitializeStr);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginInitializeStr]);
  end;
  FPluginInitialize := FuncPtr;
  FuncPtr := GetProcAddress(FHandle, PluginExecuteStr);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginExecuteStr]);
  end;
  FPluginExecute := FuncPtr;
  FuncPtr := GetProcAddress(FHandle, PluginExecuteEventStr);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginExecuteEventStr]);
  end;
  FPluginExecuteEvent := FuncPtr;
  FuncPtr := GetProcAddress(FHandle, PluginFinalizeStr);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginFinalizeStr]);
  end;
  FPluginFinalize := FuncPtr;
end;

destructor TPlugin.Destroy;
begin
  if FHandle <> 0 then
  begin
    if FID <> 0 then
      FPluginFinalize;
    FreeLibrary(FHandle);
  end;
  inherited;
end;

function TPlugin.Execute(Command, Widget, Param, Data: Integer): Integer;
begin
  ValidPlugin;
  Result := FPluginExecute(Command, Widget, Param, Data);
end;

function TPlugin.ExecuteEvent(Widget, Event, Data: Integer): Integer;
begin
  ValidPlugin;
  Result := FPluginExecuteEvent(Widget, Event, Data);
end;

procedure TPlugin.Initialize(OwnerHandle: HWND);
var
  PluginInfo: TPluginInfo;
  eCode: Integer;
begin
  Loaded;
  eCode := FPluginInitialize(OwnerHandle, PluginInfo);
  if eCode <> 0 then
    raise Exception.CreateFmt(failedToInitializePlugin, [eCode]);
  FID := PluginInfo.ID;
  FVersion := PluginInfo.Version;
  FName := PluginInfo.Name;
  FAuthor := PluginInfo.Author;
  FDescription := PluginInfo.Description;
end;

procedure TPlugin.Loaded;
begin
  if FHandle = 0 then
    raise Exception.Create(invalidPlugin);
end;

procedure TPlugin.ValidPlugin;
begin
  Loaded;
  if FID = 0 then
    raise Exception.Create(pluginNotInitialized);
end;

end.
