unit PluginWidget;

interface

uses
  Windows, Plugin, Classes, Forms, Controls, SpTBXItem, StdCtrls;

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
    procedure Click; override;
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Resize; override;
    procedure DoClose(var Action: TCloseAction); override;
  public
    constructor CreateWidget(Widget: TWidget; ParentWindow: HWND);
    destructor Destroy; override;
  end;

  TWidgetButton = class(TButton)
  private
    FWidget: TWidget;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
    procedure Click; override;
  end;

  TWidgetCheckBox = class(TCheckBox)
  private
    FWidget: TWidget;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
    procedure Click; override;
  end;

  TWidgetEdit = class(TEdit)
  private
    FWidget: TWidget;
  protected
    procedure Change; override;
    procedure DblClick; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    procedure Click; override;
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
  end;

  TWidgetLabel = class(TLabel)
  private
    FWidget: TWidget;
  protected
    procedure Click; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
  end;

  TWidgetSubmenu = class(TSpTBXSubmenuItem)
  private
    FWidget: TWidget;
  protected
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
  end;

  TWidgetMenuItem = class(TSpTBXItem)
  private
    FWidget: TWidget;
  public
    constructor CreateWidget(Widget: TWidget; AOwner: TComponent);
    destructor Destroy; override;
    procedure Click; override;
  end;

  TWidgetMenuSeparator = class(TSpTBXSeparatorItem)
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
  PluginConst, PluginWidgetMap;

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

procedure TWidgetWindow.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetWindow.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TWidgetWindow.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetWindow.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetWindow.Resize;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Resize, FWidget.ID, 0, nil);
end;

procedure TWidgetWindow.Click;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Click, FWidget.ID, 0, nil);
end;

procedure TWidgetWindow.DblClick;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_DblClick, FWidget.ID, 0, nil);
end;

procedure TWidgetWindow.DoClose(var Action: TCloseAction);
var
  I: Integer;
begin
  I := 1;
  FWidget.FPlugin.DispatchCommand(Cmd_Close, FWidget.ID, 0, @I);
  case I of
    Ca_None: Action := caNone;
    Ca_Free: Action := caFree;
    Ca_Minimize: Action := caMinimize;
  else
    Action := caHide;
  end;
  inherited;
end;

{ TWidgetButton }

procedure TWidgetButton.Click;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Click, FWidget.ID, 0, nil);
end;

constructor TWidgetButton.CreateWidget(Widget: TWidget;
  AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetButton.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

procedure TWidgetButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetButton.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TWidgetButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

{ TWidgetCheckBox }

procedure TWidgetCheckBox.Click;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Click, FWidget.ID, 0, nil);
end;

constructor TWidgetCheckBox.CreateWidget(Widget: TWidget;
  AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetCheckBox.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

procedure TWidgetCheckBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetCheckBox.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TWidgetCheckBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetCheckBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

{ TWidgetEdit }

procedure TWidgetEdit.Change;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Change, FWidget.ID, 0, nil);
end;

procedure TWidgetEdit.Click;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Click, FWidget.ID, 0, nil);
end;

constructor TWidgetEdit.CreateWidget(Widget: TWidget; AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetEdit.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

procedure TWidgetEdit.DblClick;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_DblClick, FWidget.ID, 0, nil);
end;

procedure TWidgetEdit.DoEnter;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Enter, FWidget.ID, 0, nil);
end;

procedure TWidgetEdit.DoExit;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Exit, FWidget.ID, 0, nil);
end;

procedure TWidgetEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetEdit.KeyPress(var Key: Char);
begin
  inherited;

end;

procedure TWidgetEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;

end;

procedure TWidgetEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;

{ TWidgetLabel }

procedure TWidgetLabel.Click;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Click, FWidget.ID, 0, nil);
end;

constructor TWidgetLabel.CreateWidget(Widget: TWidget; AOwner: TComponent);
begin
  FWidget := Widget;
  FWidget.FComponent := Self;
  inherited Create(AOwner);
  FWidget.FPlugin.DispatchCommand(Cmd_Create, FWidget.ID, 0, nil);
end;

destructor TWidgetLabel.Destroy;
begin
  FWidget.FComponent := nil;
  FWidget.FPlugin.DispatchCommand(Cmd_Destroy, FWidget.ID, 0, nil);
  inherited;
end;

procedure TWidgetLabel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;

end;

procedure TWidgetLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
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

procedure TWidgetMenuItem.Click;
begin
  inherited;
  FWidget.FPlugin.DispatchCommand(Cmd_Click, FWidget.ID, 0, nil);
end;

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
  FNextWidgetID := WIDGET_MAX_ID + 1;
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
