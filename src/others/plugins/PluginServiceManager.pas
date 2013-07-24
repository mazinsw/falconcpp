unit PluginServiceManager;

interface

uses
  Windows, Plugin, Forms;

type
  TPluginServiceManager = class
  private
    FForm: TForm;
    FDispatchHandle: HWND;
  public
    constructor Create(MainForm: TForm);
    function DispatcheCommand(Plugin: TPlugin; Command, Widget, Param: Integer;
      Data: Pointer): Integer;
    property DispatchHandle: HWND read FDispatchHandle;
  end;

implementation

uses
  UFrmMain, PluginConst;

{ TPluginServiceManager }

constructor TPluginServiceManager.Create(MainForm: TForm);
begin
  FForm := MainForm;
  FDispatchHandle := FForm.Handle;
end;

function TPluginServiceManager.DispatcheCommand(Plugin: TPlugin; Command,
  Widget, Param: Integer; Data: Pointer): Integer;
begin
  case Command of
    Cmd_Free:
    begin
      if Widget = Wdg_Plugin then
        TFrmFalconMain(FForm).PluginManager.Delete(Plugin.ID);
    end;
  else
  end;
  Result := 0;
end;

end.
