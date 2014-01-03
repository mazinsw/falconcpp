library NSIS_EnvSet;

uses
  Windows, Messages, SysUtils, NSIS, Registry;

function SetGlobalEnvironmentA(const Name, Value: string;
  const User: Boolean = True): Boolean;
var
  rv: DWORD;
begin
  with TRegistry.Create do
    try
      if User then
        Result := OpenKey('Environment', True)
      else
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        Result  := OpenKey('System\CurrentControlSet\Control\Session Manager\' +
                           'Environment', False);
      end;
      if Result then
      begin
        WriteExpandString(Name, Value);
        SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE,
          0, Integer(PChar('Environment')), SMTO_ABORTIFHUNG, 5000, rv);
      end;
    finally
      Free;
    end;
end; { SetGlobalEnvironmentA }

function GetEnvironmentVariableA(const Name: String): String;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('System\CurrentControlSet\Control\Session Manager\' +
            'Environment', False);
    Result := ReadString(Name);
  finally
    Free;
  end;
end; { GetEnvironmentVariableA }

function DeleteEnvironmentVariableA(const Name: String): Boolean;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('System\CurrentControlSet\Control\Session Manager\' +
            'Environment', False);
    Result := DeleteValue(Name);
  finally
    Free;
  end;
end; { DeleteEnvironmentVariableA }

function AddVariableToPathA(const Value: String): Boolean;
var
  Path: String;
  I: Integer;
begin
  Result := False;
  Path := GetEnvironmentVariableA('PATH');
  I := Pos(UpperCase(Value), UpperCase(Path));
  if I = 0 then
    Result := SetGlobalEnvironmentA('PATH', Value + ';' + Path, False);
end; { AddVariableToPathA }

function DelVariableOfPathA(const Value: String): Boolean;
var
  Path: String;
  I, Len: Integer;
begin
  Result := False;
  Path := GetEnvironmentVariableA('PATH');
  I := Pos(Value, Path);
  if I > 0 then
  begin
    Len := Length(Value);
    Delete(Path, I, Len);// ...;value;...
    if (Length(Path) >= I) and (Path[I] = ';') then// ...;;...
      Delete(Path, I, 1);// ...;...
    Dec(I);
    if (I > 0) and (Length(Path) = I) and (Path[I] = ';') then// ...;
      Delete(Path, I, 1);// ...
    Result := SetGlobalEnvironmentA('PATH', Path, False);
  end;
end; { DelVariableOfPathA }

procedure SetGlobalEnvironment(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Name: String;
  Value: String;
  User: String;
  SResult: Boolean;
begin
  Init(hwndParent, string_size, variables, stacktop);
  Name := PopString;
  Value := PopString;
  User := PopString;
  SResult := SetGlobalEnvironmentA(Name, Value, StrToBoolDef(User, True));
  PushString(BoolToStr(SResult));
end;

procedure GetEnvironmentVariable(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Name: String;
  SResult: String;
begin
  Init(hwndParent, string_size, variables, stacktop);
  Name := PopString;
  SResult := GetEnvironmentVariableA(Name);
  PushString(SResult);
end;

procedure DeleteEnvironmentVariable(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Name: String;
  SResult: Boolean;
begin
  Init(hwndParent, string_size, variables, stacktop);
  Name := PopString;
  SResult := DeleteEnvironmentVariableA(Name);
  PushString(BoolToStr(SResult));
end;

procedure AddVariableToPath(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Value: String;
  SResult: Boolean;
begin
  Init(hwndParent, string_size, variables, stacktop);
  Value := PopString;
  SResult := AddVariableToPathA(Value);
  PushString(BoolToStr(SResult));
end;

procedure DelVariableOfPath(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Value: String;
  SResult: Boolean;
begin
  Init(hwndParent, string_size, variables, stacktop);
  Value := PopString;
  SResult := DelVariableOfPathA(Value);
  PushString(BoolToStr(SResult));
end;

exports SetGlobalEnvironment;
exports GetEnvironmentVariable;
exports DeleteEnvironmentVariable;
exports AddVariableToPath;
exports DelVariableOfPath;

end.
