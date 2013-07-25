unit PluginWidget;

interface

uses
  Windows, Plugin, Classes, Forms, Controls, TBX;

type

  TWidget = class
  private
    FPlugin: TPlugin;
    FID: Integer;
    FComponent: TComponent;
  public
    constructor Create(Plugin: TPlugin; ID: Integer);
    destructor Destroy; override;
    property Plugin: TPlugin read FPlugin;
    property ID: Integer read FID;
    property Component: TComponent read FComponent;
  end;

  TWidgetWindow = class(TForm)
  private
    FWidget: TWidget;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor CreateWidget(Widget: TWidget; ParentWindow: HWND);
    destructor Destroy; override;
  end;

  TWidgetSubmenu = class(TTBXSubmenuItem)
  private
    FWidget: TWidget;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
  end;

  TWidgetMenuItem = class(TTBXItem)
  private
    FWidget: TWidget;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
  end;

  TWidgetMenuSeparator = class(TTBXSeparatorItem)
  private
    FWidget: TWidget;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
  end;

  TWidgetList = class
  private
    FList: TList;
    FNextWidgetID: Integer;
    function GetInsertIndex(WidgetID: Integer): Integer;
    function Get(Index: Integer): TWidget;
  public
    constructor Create();
    destructor Destroy; override;
    function Add(Plugin: TPlugin): TWidget;
    function Delete(WidgetID: Integer): Integer;
    function Find(WidgetID: Integer): TWidget;
    procedure Clear;
    procedure ClearForPluginID(PluginID: Integer);
    property Items[Index: Integer]: TWidget read Get; default;
  end;

implementation

uses
  PluginConst;

{ TWidget }

constructor TWidget.Create(Plugin: TPlugin; ID: Integer);
begin
  FPlugin := Plugin;
  FID := ID;
end;

destructor TWidget.Destroy;
begin
  if FComponent <> nil then
    FComponent.Free;
  inherited;
end;


{ TWidgetWindow }

procedure TWidgetWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if ParentWindow <> 0 then
  begin
    Params.Style := Params.Style and not WS_CHILD;
    if BorderStyle = bsNone then
      Params.Style := Params.Style or WS_POPUP;
  end;
end;

constructor TWidgetWindow.CreateWidget(Widget: TWidget; ParentWindow: HWND);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  Self.ParentWindow := ParentWindow;
  CreateNew(nil);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetWindow.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

{ TWidgetSubmenu }

constructor TWidgetSubmenu.CreateWidget(Widget: TWidget; AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetSubmenu.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

{ TWidgetMenuItem }

constructor TWidgetMenuItem.CreateWidget(Widget: TWidget;
  AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetMenuItem.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

{ TWidgetMenuSeparator }

constructor TWidgetMenuSeparator.CreateWidget(Widget: TWidget;
  AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetMenuSeparator.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

{ TWidgetList }

function TWidgetList.Add(Plugin: TPlugin): TWidget;
var
  I: Integer;
begin
  Result := TWidget.Create(Plugin, FNextWidgetID);
  I := GetInsertIndex(Result.ID);
  FList.Insert(I, Result);
  Inc(FNextWidgetID);
end;

procedure TWidgetList.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TWidget(FList.Items[I]).Free;
  FList.Clear;
end;

procedure TWidgetList.ClearForPluginID(PluginID: Integer);
var
  I: Integer;
begin
  for I := FList.Count - 1 downto 0 do
  begin
    if TWidget(FList.Items[I]).Plugin.ID = PluginID then
    begin
      TWidget(FList.Items[I]).Free;
      FList.Delete(I);
    end;
  end;
end;

constructor TWidgetList.Create;
begin
  FList := TList.Create;
  FNextWidgetID := $010000;
end;

function TWidgetList.Delete(WidgetID: Integer): Integer;
var
  Widget: TWidget;
  I: Integer;
begin
  I := GetInsertIndex(WidgetID);
  if (I < FList.Count) and (TWidget(FList.Items[I]).ID = WidgetID) then
  begin
    Widget := TWidget(FList.Items[I]);
    Widget.Free;
    FList.Delete(I);
    Result := 0;
  end
  else
    Result := -1;
end;

destructor TWidgetList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TWidgetList.Find(WidgetID: Integer): TWidget;
var
  I: Integer;
begin
  I := GetInsertIndex(WidgetID);
  if (I < FList.Count) and (TWidget(FList.Items[I]).ID = WidgetID) then
    Result := TWidget(FList.Items[I])
  else
    Result := nil;
end;

function TWidgetList.Get(Index: Integer): TWidget;
begin
  Result := TWidget(FList.Items[Index]);
end;

function TWidgetList.GetInsertIndex(WidgetID: Integer): Integer;
var
  I, J: Integer;
  Widget: TWidget;
begin
  I := 0;
  Result := 0;
  J := FList.Count - 1;
  // binary search
  while I <= J do
  begin
    Result := (I + J) div 2;
    Widget := TWidget(FList.Items[Result]);
    if WidgetID > Widget.ID then
    begin
      I := Result + 1;
      Inc(Result);
    end
    else if WidgetID < Widget.ID then
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

end.
