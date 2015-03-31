library NSIS_EnvSet;

uses
  Windows, Messages, SysUtils, NSIS, Registry;

function InternalSetGlobalEnvironment(const Name, Value: string;
  const User: Boolean = True): Boolean;
var
  rv: DWORD_PTR;
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
          0, Integer(PChar('Environment')), SMTO_ABORTIFHUNG, 5000, @rv);
      end;
    finally
      Free;
    end;
end;

function InternalGetEnvironmentVariable(const Name: String): String;
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
end;

function InternalDeleteEnvironmentVariable(const Name: String): Boolean;
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
end;

function InternalAddVariableToPath(const Value: String): Boolean;
var
  Path: String;
  I: Integer;
begin
  Result := False;
  Path := InternalGetEnvironmentVariable('PATH');
  I := Pos(UpperCase(Value), UpperCase(Path));
  if I = 0 then
    Result := InternalSetGlobalEnvironment('PATH', Value + ';' + Path, False);
end;

function InternalDelVariableOfPath(const Value: String): Boolean;
var
  Path: String;
  I, Len: Integer;
begin
  Result := False;
  Path := InternalGetEnvironmentVariable('PATH');
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
    Result := InternalSetGlobalEnvironment('PATH', Path, False);
  end;
end;

procedure SetGlobalEnvironment(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Name: String;
  Value: String;
  User: String;
  SResult: Boolean;
begin
  InitW(hwndParent, string_size, variables, stacktop);
  Name := PopStringW;
  Value := PopStringW;
  User := PopStringW;
  SResult := InternalSetGlobalEnvironment(Name, Value, StrToBoolDef(User, True));
  PushStringW(BoolToStr(SResult));
end;

procedure GetEnvironmentVariable(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Name: String;
  SResult: String;
begin
  InitW(hwndParent, string_size, variables, stacktop);
  Name := PopStringW;
  SResult := InternalGetEnvironmentVariable(Name);
  PushStringW(SResult);
end;

procedure DeleteEnvironmentVariable(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Name: String;
  SResult: Boolean;
begin
  InitW(hwndParent, string_size, variables, stacktop);
  Name := PopStringW;
  SResult := InternalDeleteEnvironmentVariable(Name);
  PushStringW(BoolToStr(SResult));
end;

procedure AddVariableToPath(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Value: String;
  SResult: Boolean;
begin
  InitW(hwndParent, string_size, variables, stacktop);
  Value := PopStringW;
  SResult := InternalAddVariableToPath(Value);
  PushStringW(BoolToStr(SResult));
end;

procedure DelVariableOfPath(const hwndParent: HWND; const string_size: integer;
  const variables: PChar; const stacktop: pointer); cdecl;
var
  Value: String;
  SResult: Boolean;
begin
  InitW(hwndParent, string_size, variables, stacktop);
  Value := PopStringW;
  SResult := InternalDelVariableOfPath(Value);
  PushStringW(BoolToStr(SResult));
end;

exports SetGlobalEnvironment;
exports GetEnvironmentVariable;
exports DeleteEnvironmentVariable;
exports AddVariableToPath;
exports DelVariableOfPath;

end.
