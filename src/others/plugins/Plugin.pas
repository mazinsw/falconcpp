unit Plugin;

interface

uses
  Windows, PluginConst;

const
  PluginInitializeStr      = 'Plugin_initialize';
  PluginDispatchCommandStr = 'Plugin_dispatchCommand';
  PluginFinalizeStr        = 'Plugin_finalize';
  PluginGetVersion         = 'Plugin_getVersion';

  Plugin_Version           = '1.1';


type
  TPluginInfo = record
    Version: array[0..30] of AnsiChar;
    Name: array[0..100] of AnsiChar;
    Author: array[0..100] of AnsiChar;
    Description: array[0..254] of AnsiChar;
  end;

  TPluginInitialize      = function(Handle: HWND; var Info: TPluginInfo;
    var Data: Pointer): Integer; cdecl;
  TPluginDispatchCommand = function(var Cmd: TDispatchCommand; Data: Pointer): Integer; cdecl;
  TPluginFinalize        = procedure(Data: Pointer); cdecl;
  TPluginGetVersion = function: PAnsiChar; cdecl;

  TPlugin = class
  private
    FHandle: HMODULE;
    FData: Pointer;
    FID: Integer;
    FVersion: string;
    FName: string;
    FAuthor: string;
    FDescription: string;
    FPluginInitialize: TPluginInitialize;
    FPluginDispatchCommand: TPluginDispatchCommand;
    FPluginFinalize: TPluginFinalize;
    FPluginGetVersion: TPluginGetVersion;
  protected
  public
    constructor Create(FileName: string; DispatchHandle: HWND);
    destructor Destroy; override;
    function DispatchCommand(Command, Widget, Param: Integer; Data: Pointer): Integer;
    property ID: Integer read FID;
    property Version: string read FVersion;
    property Name: string read FName;
    property Author: string read FAuthor;
    property Description: string read FDescription;
  end;

implementation

uses
  SysUtils;

{ TPlugin }

constructor TPlugin.Create(FileName: string; DispatchHandle: HWND);
var
  FuncPtr: Pointer;
  PluginInfo: TPluginInfo;
  sptr: PAnsiChar;
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
  FuncPtr := GetProcAddress(FHandle, PluginDispatchCommandStr);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginDispatchCommandStr]);
  end;
  FPluginDispatchCommand := FuncPtr;
  FuncPtr := GetProcAddress(FHandle, PluginFinalizeStr);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginFinalizeStr]);
  end;
  FPluginFinalize := FuncPtr;
  FuncPtr := GetProcAddress(FHandle, PluginGetVersion);
  if FuncPtr = nil then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(functionNotFound, [PluginGetVersion]);
  end;
  FPluginGetVersion := FuncPtr;
  sptr := FPluginGetVersion();
  if not SameText(string(StrPas(sptr)), Plugin_Version) then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(pluginIncompatibleVersion, [StrPas(sptr), Plugin_Version]);
  end;
  FID := FPluginInitialize(DispatchHandle, PluginInfo, FData);
  if FID <= 0 then
  begin
    FreeLibrary(FHandle);
    FHandle := 0;
    raise Exception.CreateFmt(failedToInitializePlugin, [FID]);
  end;
  FVersion := string(PluginInfo.Version);
  FName := string(PluginInfo.Name);
  FAuthor := string(PluginInfo.Author);
  FDescription := string(PluginInfo.Description);
end;

destructor TPlugin.Destroy;
begin
  if FHandle <> 0 then
  begin
    FPluginFinalize(FData);
    FreeLibrary(FHandle);
  end;
  inherited;
end;

function TPlugin.DispatchCommand(Command, Widget, Param: Integer;
  Data: Pointer): Integer;
var
  Msg: TDispatchCommand;
begin
  Msg.Command := Command;
  Msg.Widget := Widget;
  Msg.Param := Param;
  Msg.Data := Data;
  Result := FPluginDispatchCommand(Msg, FData);
end;

end.
