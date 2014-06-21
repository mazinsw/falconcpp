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

  TPackageList = class
  private
    FList: TList;
    function GetPackage(Index: Integer): TPackage;
  public
    function Add(Item: TPackage): Integer;
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
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
    FOwnerDependencyList: TPackageList;
    procedure SetState(Value: TPackageState);
    function GetPackage(Index: Integer): TPackage;
    function MarkToInstall(Package: TPackage; SelectRecent: Boolean = False;
      Simulate: Boolean = False): Boolean;
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
    property OwnerDependencyList: TPackageList read FOwnerDependencyList;
    function InstaledPackage(const Name: string): Boolean;
    function CanUninstall: Boolean;
    class function ComparePkgVersion(const Ver1, Ver2: string): Integer;
    function CanInstall: Boolean;
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

function TPackage.CanUninstall: Boolean;
var
  I: Integer;
  Item: TPackage;
begin
  for I := 0 to FOwnerDependencyList.Count - 1 do
  begin
    Item := FOwnerDependencyList.Items[I];
    if (Item.FInstalled and (Item.FState <> psUninstall)) or
      (Item.FState = psInstall) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TPackage.Clear;
//var
//  I: Integer;
begin
  //for I := Count - 1 downto 0 do
  //  Items[I].Free;
  FList.Clear;
end;

class function TPackage.ComparePkgVersion(const Ver1, Ver2: string): Integer;
var
  v1, v2: Integer;
  s1, s2: string;
  ptr1, ptr2: PChar;
begin
  ptr1 := PChar(Ver1);
  ptr2 := PChar(Ver2);
  while (ptr1^ <> #0) and (ptr2^ <> #0) do
  begin
    s1 := '';
    s2 := '';
    while CharInSet(ptr1^, ['0'..'9']) do
    begin
      s1 := s1 + ptr1^;
      Inc(ptr1);
    end;
    while CharInSet(ptr2^, ['0'..'9']) do
    begin
      s2 := s2 + ptr2^;
      Inc(ptr2);
    end;
    if (Length(s1) > 0) and (Length(s2) > 0) then
    begin
      v1 := StrToInt(s1);
      v2 := StrToInt(s2);
      if v1 > v2 then
      begin
        Result := 1;
        Exit;
      end
      else if v1 < v2 then
      begin
        Result := -1;
        Exit;
      end;
    end
    else if Length(s1) > 0 then
    begin
      Result := 1;
      Exit;
    end
    else if Length(s2) > 0 then
    begin
      Result := -1;
      Exit;
    end;
    if (ptr1^ > ptr2^) then
    begin
      Result := 1;
      Exit;
    end
    else if (ptr1^ < ptr2^) then
    begin
      Result := -1;
      Exit;
    end
    else if ptr1^ = #0 then
      Break;
    Inc(ptr1);
    Inc(ptr2);
  end;
  Result := 0;
end;

function TPackage.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPackage.Create;
begin
  FList := TList.Create;
  FOwnerDependencyList := TPackageList.Create;
  FState := psNone;
end;

destructor TPackage.Destroy;
begin
  Clear;
  FOwnerDependencyList.Free;
  FList.Free;
  //Owner.FList.Remove(Self);
  inherited;
end;

function TPackage.GetPackage(Index: Integer): TPackage;
begin
  Result := TPackage(FList.Items[Index]);
end;

function TPackage.InstaledPackage(const Name: string): Boolean;
var
  I: Integer;
begin
  for I := 0 to Owner.Count - 1 do
  begin
    if Owner.Items[I] = Self then
      Continue;
    if (Owner.Items[I].Name = Name) and ((Owner.Items[I].FState = psInstall) or
      (Owner.Items[I].FInstalled and not (Owner.Items[I].FState = psUninstall))) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function TPackage.CanInstall: Boolean;
begin
  Result := MarkToInstall(Self, False, True);
end;

function TPackage.MarkToInstall(Package: TPackage; SelectRecent, Simulate: Boolean): Boolean;
var
  I, C: Integer;
  lPackage: TPackage;
  StateEvent: TChangeStateEvent;
begin
  Result := True;
  StateEvent := Owner.Owner.Owner.OnChangeState;
  if (Package.FState = psInstall) or
    (Package.FInstalled and (Package.State <> psUninstall)) then
    Exit;
  if SelectRecent then
  begin
    lPackage := Package;
    for I := 0 to lPackage.Owner.Count - 1 do
    begin
      if (CompareText(lPackage.Name, lPackage.Owner.Items[I].Name) <> 0) then
        Continue;
      C := ComparePkgVersion(lPackage.Owner.Items[I].Version, lPackage.Version);
      if C > 0 then
      begin
        Package := Package.Owner.Items[I];
        if (Package.FState = psInstall) or
          (Package.FInstalled and (Package.State <> psUninstall)) then
          Exit;
      end
      else if (C < 0) and ((lPackage.Owner.Items[I].FState = psInstall) or
        (lPackage.Owner.Items[I].FInstalled and (lPackage.Owner.Items[I].State <> psUninstall))) then
      begin
        Result := False;
        Exit;
        //raise Exception.CreateFmt('Can''t install ''%s %s'', a lowest version alreay installed!',
        //  [Package.Name, Package.Version]);
      end;
    end;
  end;
  if not Simulate then
  begin
    if Package.FInstalled then
      Package.FState := psNone
    else
      Package.FState := psInstall;
  end;
  for I := 0 to Package.Count - 1 do
  begin
    Result := MarkToInstall(Package.Items[I], True, Simulate);
    if not Result then
      Exit;
  end;
  if not Simulate and Assigned(StateEvent) then
    StateEvent(FOwner.FOwner.FOwner, Package);
end;

procedure TPackage.SetState(Value: TPackageState);



  procedure MarkReset(Package: TPackage; SelectRecent: Boolean = False);
  var
    I, C: Integer;
    lPackage: TPackage;
    StateEvent: TChangeStateEvent;
  begin
    if ((Package.FState = psInstall) and not Package.FInstalled) or
        (Package.FInstalled and (Package.State <> psUninstall) and (Value <> psNone)) then
        Exit;
    if SelectRecent and ((Value <> psNone) or (Package.State = psUninstall)) then
    begin
      lPackage := Package;
      for I := 0 to lPackage.Owner.Count - 1 do
      begin
        if (CompareText(lPackage.Name, lPackage.Owner.Items[I].Name) <> 0) then
          Continue;
        C := ComparePkgVersion(lPackage.Owner.Items[I].Version, lPackage.Version);
        if C > 0 then
        begin
          Package := Package.Owner.Items[I];
          if ((Package.FState = psInstall) and not Package.FInstalled) or
            (Package.FInstalled and (Package.State <> psUninstall) and (Value <> psNone)) then
            Exit;
        end;
      end;
    end;
    StateEvent := Owner.Owner.Owner.OnChangeState;
    if not Package.FInstalled then
      Package.FState := psInstall
    else
      Package.FState := psNone;
    if Assigned(StateEvent) then
      StateEvent(FOwner.FOwner.FOwner, Package);
    for I := 0 to Package.Count - 1 do
      MarkReset(Package.Items[I], True);
  end;

  procedure MarkToUninstall(Package: TPackage; List: TList);
  var
    I, J, InstalledCount: Integer;
    StateEvent: TChangeStateEvent;
    Dependency, OwnerDependency: TPackage;
  begin
    StateEvent := FOwner.FOwner.FOwner.FOnChangeState;
    Package.FState := psUninstall;
    if Assigned(StateEvent) then
      StateEvent(FOwner.FOwner.FOwner, Package);
    for I := 0 to Package.Count - 1 do
    begin
      Dependency := Package.Items[I];
      // get any highest dependency installed version to uninstall
      for J := 0 to Dependency.Owner.Count - 1 do
      begin
        if (CompareText(Dependency.Name, Dependency.Owner.Items[J].Name) <> 0) then
          Continue;
        if (Dependency.FInstalled and not (Dependency.FState = psUninstall))
          or (Dependency.FState = psInstall) then
          Break;
        if ComparePkgVersion(Dependency.Owner.Items[J].Version, Dependency.Version) > 0 then
          Dependency := Dependency.Owner.Items[J];
      end;
      if (Dependency.FState = psUninstall) or (not Dependency.FInstalled and
        not (Dependency.FState = psInstall)) then
        Continue;
      InstalledCount := 0;
      for J := 0 to Dependency.OwnerDependencyList.Count - 1 do
      begin
        OwnerDependency := Dependency.OwnerDependencyList.Items[J];
        // same package then continue, only different dependency owner are checked
        if (OwnerDependency.Name = Package.Name) and
           (OwnerDependency.Version = Package.Version) then
          Continue;
        if (OwnerDependency.FInstalled and not (OwnerDependency.FState = psUninstall))
            or (OwnerDependency.FState = psInstall) then
        begin
          Inc(InstalledCount);
          Break;
        end;
      end;
      if InstalledCount > 0 then
        Continue;
      MarkToUninstall(Dependency, List);
    end;
  end;

var
  List: TList;
begin
  if FState = Value then
    Exit;
  List := TList.Create;
  if FInstalled and not (Value = psUninstall) then
    MarkReset(Self)
  else if Value = psInstall then
      MarkToInstall(Self)
  else if ((Value = psUninstall) and FInstalled) or (FState = psInstall) then
    MarkToUninstall(Self, List)
  else
    FState := Value;
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

{ TPackageList }

function TPackageList.Add(Item: TPackage): Integer;
begin
  Result := FList.Add(Item);
end;

procedure TPackageList.Clear;
begin
  FList.Clear;
end;

function TPackageList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPackageList.Create;
begin
  FList := TList.Create;
end;

procedure TPackageList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TPackageList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TPackageList.GetPackage(Index: Integer): TPackage;
begin
  Result := TPackage(FList.Items[Index]);
end;

end.
