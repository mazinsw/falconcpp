unit UPkgClasses;

interface

uses
  Classes;

type
  TPackage = class;
  TLibrary = class;
  TCategory = class;

  TDependency = class
  public
    Package: TPackage;
    Name: string;
    Version: string;
  end;

  TChangeStateEvent = procedure(Sender: TObject; Pkg: TPackage) of object;
  TCategoryList = class
  private
    FList: TList;
    FOnChangeState: TChangeStateEvent;
    function GetCategory(Index: Integer): TCategory;
  public
    constructor Create;
    destructor Destroy; override;
    function FindPackage(const CategoryName, LibraryName, Name, Version: string): TPackage;
    function Find(const Name: string): Integer;
    function Add(Item: TCategory): Integer;
    function Count: Integer;
    procedure Clear;
    property Items[Index: Integer]: TCategory read GetCategory;
    property OnChangeState: TChangeStateEvent read FOnChangeState write FOnChangeState;
  end;

  TCategory = class
  private
    FList: TList;
    FName: string;
    FOwner: TCategoryList;
    function GetLibrary(Index: Integer): TLibrary;
  public
    property Owner: TCategoryList read FOwner write FOwner;
    property Name: string read FName write FName;
    function Add(Item: TLibrary): Integer;
    function Find(const Name: string): Integer;
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure Clear;
    property Items[Index: Integer]: TLibrary read GetLibrary;
  end;

  TLibrary = class
  private
    FList: TList;
    FName: string;
    FWebSite: string;
    FDescription: string;
    FOwner: TCategory;
    function GetPackage(Index: Integer): TPackage;
  public
    property Owner: TCategory read FOwner write FOwner;
    property Name: string read FName write FName;
    property WebSite: string read FWebSite write FWebSite;
    property Description: string read FDescription write FDescription;
    function Add(Item: TPackage): Integer;
    function Find(const Name, Version: string): Integer;
    function IndexOf(Item: TPackage): Integer;
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure Clear;
    property Items[Index: Integer]: TPackage read GetPackage;
  end;

  TPackageState = (psNone, psInstall, psUninstall);

  TPackage = class
  private
    FList: TList;
    FName: string;
    FVersion: string;
    FDescription: string;
    FSize: Cardinal;
    FLastModified: TDateTime;
    FURL: string;
    FGCCVersion: string;
    FOwner: TLibrary;
    FState: TPackageState;
    FData: Pointer;
    FInstalled: Boolean;
    procedure SetState(Value: TPackageState);
    function GetPackage(Index: Integer): TPackage;
  public
    property Owner: TLibrary read FOwner write FOwner;
    property Name: string read FName write FName;
    property Version: string read FVersion write FVersion;
    property Description: string read FDescription write FDescription;
    property Size: Cardinal read FSize write FSize;
    property LastModified: TDateTime read FLastModified write FLastModified;
    property URL: string read FURL write FURL;
    property GCCVersion: string read FGCCVersion write FGCCVersion;
    property Installed: Boolean read FInstalled write FInstalled;
    property State: TPackageState read FState write SetState;
    property Data: Pointer read FData write FData;
    function Add(Item: TPackage): Integer;
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure Clear;
    property Items[Index: Integer]: TPackage read GetPackage;
  end;

function HummanSize(Size: Cardinal): string;

implementation

uses SysUtils;

function HummanSize(Size: Cardinal): string;
begin
  if Size < 1 then
    Result := IntToStr(Size) + ' Byte'
  else if Size < 1000 then
    Result := IntToStr(Size) + ' Bytes'
  else if Size < 1024000 then
    Result := FormatFloat('0.0', Size / 1024) + ' kB'
  else if Size < 1024 * 1024000 then
    Result := FormatFloat('0.0', Size / (1024 * 1024)) + ' MB'
  else
    Result := FormatFloat('0.0', Size / (1024 * 1024 * 1024)) + ' GB';
end;

{ TCategory }

function TCategory.Add(Item: TLibrary): Integer;
begin
  Result := FList.Add(Item);
  Item.FOwner := Self;
end;

procedure TCategory.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Items[I].Free;
  FList.Clear;
end;

function TCategory.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TCategory.Create;
begin
  FList := TList.Create;
end;

destructor TCategory.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TCategory.Find(const Name: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[I].Name = Name then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TCategory.GetLibrary(Index: Integer): TLibrary;
begin
  Result := TLibrary(FList.Items[Index]);
end;

{ TLibrary }

function TLibrary.Add(Item: TPackage): Integer;
begin
  Result := FList.Add(Item);
  Item.FOwner := Self;
end;

procedure TLibrary.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Items[I].Free;
  FList.Clear;
end;

function TLibrary.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TLibrary.Create;
begin
  FList := TList.Create;
end;

destructor TLibrary.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TLibrary.Find(const Name, Version: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if (Items[I].Name = Name) and (Items[I].Version = Version) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TLibrary.GetPackage(Index: Integer): TPackage;
begin
  Result := TPackage(FList.Items[Index]);
end;

function TLibrary.IndexOf(Item: TPackage): Integer;
begin
  Result := FList.IndexOf(Item);
end;

{ TPackage }

function TPackage.Add(Item: TPackage): Integer;
begin
  Result := FList.Add(Item);
end;

procedure TPackage.Clear;
//var
//  I: Integer;
begin
  //for I := Count - 1 downto 0 do
  //  Items[I].Free;
  FList.Clear;
end;

function TPackage.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPackage.Create;
begin
  FList := TList.Create;
  FState := psNone;
end;

destructor TPackage.Destroy;
begin
  Clear;
  FList.Free;
  //Owner.FList.Remove(Self);
  inherited;
end;

function TPackage.GetPackage(Index: Integer): TPackage;
begin
  Result := TPackage(FList.Items[Index]);
end;

procedure TPackage.SetState(Value: TPackageState);

  procedure MarkToInstall(Package: TPackage);
  var
    I: Integer;
    StateEvent: TChangeStateEvent;
  begin
    StateEvent := Owner.Owner.Owner.OnChangeState;
    for I := 0 to Package.Count - 1 do
    begin
      if (Package.Items[I].FState = psInstall) or
        (Package.Items[I].FInstalled and (Package.Items[I].State <> psUninstall)) then
        Continue;
      Package.Items[I].FState := psInstall;
      if Assigned(StateEvent) then
        StateEvent(FOwner.FOwner.FOwner, Package.Items[I]);
      MarkToInstall(Package.Items[I]);
    end;
  end;

  procedure MarkToUninstall(Package: TPackage; List: TList);
  var
    I: Integer;
    StateEvent: TChangeStateEvent;
  begin
    StateEvent := FOwner.FOwner.FOwner.FOnChangeState;
    for I := 0 to Package.Count - 1 do
    begin
      if (Package.Items[I].FState <> psInstall) or Package.Items[I].FInstalled then
        Continue;
      Package.Items[I].FState := psUninstall;
      if Assigned(StateEvent) then
        StateEvent(FOwner.FOwner.FOwner, Package.Items[I]);
      MarkToUninstall(Package.Items[I], List);
    end;
  end;

var
  List: TList;
  OldState: TPackageState;
  StateEvent: TChangeStateEvent;
begin
  if FState = Value then
    Exit;
  List := TList.Create;
  OldState := FState;
  FState := Value;
  StateEvent := FOwner.FOwner.FOwner.FOnChangeState;
  if Assigned(StateEvent) then
    StateEvent(FOwner.FOwner.FOwner, Self);
  if Value = psInstall then
    MarkToInstall(Self)
  else if ((Value = psUninstall) and FInstalled) or (OldState = psInstall) then
    MarkToUninstall(Self, List);
  List.Free;
end;

{ TCategoryList }

function TCategoryList.Add(Item: TCategory): Integer;
begin
  Result := FList.Add(Item);
  Item.FOwner := Self;
end;

procedure TCategoryList.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Items[I].Free;
  FList.Clear;
end;

function TCategoryList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TCategoryList.Create;
begin
  FList := TList.Create;
end;

destructor TCategoryList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TCategoryList.Find(const Name: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[I].Name = Name then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TCategoryList.FindPackage(const CategoryName, LibraryName, Name,
  Version: string): TPackage;
var
  I, J, K: Integer;
begin
  Result := nil;
  I := Find(CategoryName);
  if I < 0 then
    Exit;
  J := Items[I].Find(LibraryName);
  if J < 0 then
    Exit;
  K := Items[I].Items[J].Find(Name, Version);
  if K < 0 then
    Exit;
  Result := Items[I].Items[J].Items[K];
end;

function TCategoryList.GetCategory(Index: Integer): TCategory;
begin
  Result := TCategory(FList.Items[Index]);
end;

end.
