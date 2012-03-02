unit UParseMsgs;

interface

uses
  SysUtils, Classes, Dialogs, Forms;

type
  TMessageItemType = (mitCompiler, mitGoto, mitFound);
  
  TMessageItem = class
  public
    MsgType: TMessageItemType;
    FileName: String;
    Line: Integer;
    Col: Integer;
    EndCol: Integer;
    Msg: String;
    OriMsg: String;
    Selec: String;
    Icon: Integer;
    constructor Create;
    function GetPosXY: String;
  end;

function GetNumberOfOutLine(Line: String): String;
function StringBetween(S, BeginDlm,EndDlm: String; ResAll: Boolean = True):string;
function StringBetweenDelPrior(Var S:String; BeginDlm,EndDlm: String):string;
function AddStr(const text: String; var Strout: String): Integer;
function GetLine(Str: String; Index: Integer): String;
function CountLine(Str: String): Integer;
function GetTypes(afmt: String): String;
function ParseResult(Value: TStrings): TStrings;
function ResolveUnixFileName(const Str: String): String;
function IsCompatible(const fmt, src: String): Boolean;
function sscanf(const fmt, src: String; const params: array of Pointer): Boolean;
function sscanfs(const fmt, src: String; var str_out: String): Boolean;

implementation

uses UUtils, StrUtils, UFrmMain, ULanguages, TokenUtils;

constructor TMessageItem.Create;
begin
  inherited Create;
  MsgType := mitGoto;
  FileName := '';
  Line := 0;
  Col := 0;
  Icon := 34;
  Msg := '';
end;

function TMessageItem.GetPosXY: String;
begin
  Result := '';
  if (Line > 0) then Result :=  IntToStr(Line);
  if (Line > 0) and (Col > 0) then
    Result :=  Result + ': ' + IntToStr(Col);
end;

function GetNumberOfOutLine(Line: String): String;
var
  I: Integer;
begin
  I := StrToIntDef(StringBetween(Line, ':', ':'), -1);
  if (I > 0) then
    Result := IntToStr(I)
  else
    Result := '';
end;

function StringBetweenDelPrior(Var S:String; BeginDlm,EndDlm: String):string;
var
  i:integer;
  str:string;
begin
  str := S;
  i := Pos(BeginDlm,str);
  if (i > 0) then
  begin
    str := Copy(str,i + length(BeginDlm),length(str) - i);
    S := str;
    i := Pos(EndDlm,str);
    if (i > 0) then
    begin
      str := Copy(str,1,i - 1);
      Delete(S,1,i - 1);
    end
    else
      str := '';
  end
  else
    str := '';
  Result := str;
end;

function StringBetween(S, BeginDlm,EndDlm: String;
  ResAll: Boolean = True):string;
var
  i:integer;
  str:string;
begin
  str := S;
  i := Pos(BeginDlm,str);
  if (i > 0) or ResAll then
  begin
    if (i = 0) then I := 1;
    str := Copy(str,i + length(BeginDlm),length(str) - i);
    i := Pos(EndDlm,str);
    if (i > 0) or ResAll then
    begin
      if (i = 0) then i := length(str);
      str := Copy(str,1,i - 1);
    end
    else
      str := '';
  end
  else
    str := '';
  Result := str;
end;

function AddStr(const text: String; var Strout: String): Integer;
begin
  if (Length(Strout) > 0) then
    Strout := Strout + #13 + text
  else
    Strout := text;
  Result := CountLine(Strout) - 1;
end;

function GetLine(Str: String; Index: Integer): String;
var
  Line: String;
  I: Integer;
begin
  Line := '';
  I := 0;
  while (Pos(#13, Str) > 0) do
  begin
    Line := Copy(Str, 1, Pos(#13, Str) - 1);
    Delete(Str, 1, Pos(#13, Str));
    if (I = Index) then
    begin
      Result := Line;
      Exit;
    end;
    Inc(I);
  end;
  if (I = Index) then Line := Str;
  Result := Line;
end;

function CountLine(Str: String): Integer;
begin
  Result := 0;
  while (Pos(#13, Str) > 0) do
  begin
    Delete(Str, 1, Pos(#13, Str));
    Inc(Result);
  end;
  if Length(Str) > 0 then Inc(Result);
end;

function GetTypes(afmt: String): String;
var
  I: Integer;
  Symb: array[0..1] of Char;
  Res: String;
begin
  Res := '';
  for I:= 1 to Length(afmt) do
    if (I < Length(afmt)) then
    begin
      Symb[0] := afmt[I];
      Symb[1] := afmt[I + 1];
      if CompareStr(Symb, '%s') = 0 then Res := Res + 's';
      if CompareStr(Symb, '%c') = 0 then Res := Res + 'c';
      if CompareStr(Symb, '%d') = 0 then Res := Res + 'd';
      if CompareStr(Symb, '%f') = 0 then Res := Res + 'f';
    end;
  Result := Res;
end;

function ExistLineNumber(const fmt: String): Boolean;
var
  X, Y: Integer;
  types: String;
begin
  Result := False;
  types := GetTypes(fmt);
  if Length(types) > 1 then
    if types[2] = 'd' then
    begin
      X := Pos(':', fmt);
      if (X > 0) then
      begin
        Y := PosEx(':', fmt, X + 1);
        if (Y > 0) and (PosEx('%d', Copy(fmt, X, Y - X + 1)) > 0) then
          Result := True;
      end;
    end;
end;

function ExistColNumber(const fmt: String): Boolean;
var
  X, Y, Z: Integer;
  types: String;
begin
  Result := False;
  types := GetTypes(fmt);
  if Length(types) > 2 then
  begin
    if (types[2] = 'd') and (types[3] = 'd') then
    begin
      X := Pos(':', fmt);
      if (X > 0) then
      begin
        Y := PosEx(':', fmt, X + 1);
        if (Y > 0) and (PosEx('%d', Copy(fmt, X, Y - X + 1)) > 0) then
        begin
          Z := PosEx(':', fmt, Y + 1);
          if (Z > 0) and (PosEx('%d', Copy(fmt, Y, Z - Y + 1)) > 0) then
            Result := True;
        end;
      end;
    end;
  end;
end;

function ExistCol(const line: String; var col: String): Boolean;
var
  X, Y: Integer;
begin
  Result := False;
  X := Pos(':', line);
  if (X > 0) then
  begin
    Y := PosEx(':', line, X + 1);
    if X > 0 then
    begin
      X := PosEx(':', line, Y + 1);
      if X > 0 then
      begin
        col := Copy(line, Y + 1, X - Y - 1);
        Result := True;
      end;
    end;
  end;
end;

function ResolveUnixFileName(const Str: String): String;
var
  I, Y: Integer;
  Nm, rest: String;
begin
  I := Pos(':\', Str);
  if (I = 2) then
  begin
    Y := PosEx(':', Str, I + 2);
    Nm := Copy(Str, 1, Y - 1);
    rest := Copy(Str, Y, Length(Str));
    Nm := ConvertSlashes(Nm);
    Y := Pos('include', Nm);
    if Y > 0 then
    begin
      Nm := Copy(Nm, Y, Length(Nm));
      Nm := '${COMPILER_PATH}\' + Nm;
    end
    else
      Nm := ExtractFileName(Nm);
    Result := Nm + rest;
  end
  else
    Result := Str;
end;

function IsCompatible(const fmt, src: String): Boolean;
var
  Consts, Values: String;
  Temp, Str, Types: String;
  I: Integer;
begin
  Temp := fmt;
  Result := False;
  if (Length(fmt) < 2) or (Length(src) = 0) then Exit;
  Types := GetTypes(fmt);
  for I:= 1 to Length(types) do
    Temp := StringReplace(Temp, '%' + types[I], #13, [rfReplaceAll]);
  if Temp[Length(Temp)] = #13 then Delete(Temp, Length(Temp), 1);
  if Temp[1] = #13 then Delete(Temp, 1, 1);
  Consts := Temp;
  Temp := src;
  for I:= 0 to Pred(CountLine(Consts)) do
  begin
    Str := GetLine(Consts, I);
    if (Pos(Str, Temp) > 0) then
      Temp := StringReplace(Temp, Str, #13, [])
    else
      Exit;
  end;
  Values := Temp;
  if (CountLine(Values) <> Length(Types)) then Exit;
  Result := True;
end;

function sscanf(const fmt, src: String; const params: array of Pointer): Boolean;
var
  Consts, Values: String;
  Temp, Str, Types: String;
  I: Integer;
  //results
  StrResPtr: PString;
  CharResPtr: PChar;
  IntResPtr: PInteger;
  FloatResPtr: PExtended;
begin
  Temp := fmt;
  Result := False;
  if (Length(fmt) < 2) or (Length(src) = 0) then Exit;
  Types := GetTypes(fmt);
  for I:= 1 to Length(types) do
    Temp := StringReplace(Temp, '%' + types[I], #13, [rfReplaceAll]);
  if Temp[Length(Temp)] = #13 then Delete(Temp, Length(Temp), 1);
  if Temp[1] = #13 then Delete(Temp, 1, 1);
  Consts := Temp;
  Temp := src;
  for I:= 0 to Pred(CountLine(Consts)) do
  begin
    Str := GetLine(Consts, I);
    if (Pos(Str, Temp) > 0) then
      Temp := StringReplace(Temp, Str, #13, [])
    else
      Exit;
  end;
  Values := Temp;
  if (CountLine(Values) <> Length(Types)) then Exit;
  for I:= 0 to High(params) do
  begin
    case Types[I + 1] of
      's':
      begin
        StrResPtr := params[I];
        StrResPtr^ := GetLine(Values, I);
      end;
      'c':
      begin
        CharResPtr := params[I];
        CharResPtr^ := GetLine(Values, I)[1];
      end;
      'd':
      begin
        IntResPtr := params[I];
        IntResPtr^ := StrToIntDef(GetLine(Values, I), 0);
      end;
      'f':
      begin
        FloatResPtr := params[I];
        FloatResPtr^ := StrToFloatDef(GetLine(Values, I), 0);
      end;
    end;
  end;
  Result := True;
end;

function CanOrder(const Str: String; var order: String): Boolean;
var
  I: Integer;
  temp: String;
begin
  Result := False;
  I := Pos('ORDER{', UpperCase(Str));
  if I = 0 then Exit;
  temp := Copy(str, I + 6, length(str));
  I := Pos('}', temp);
  if I = 0 then Exit;
  temp := Copy(temp, 1, I - 1);
  temp := StringReplace(temp, ',', #13, [rfReplaceAll]);
  if CountLine(temp) > 0 then
  begin
    order := temp;
    Result := True;
  end;
end;

function prinfts(const fmt, src: String): String;

  function ReplaceAtPos(const str, substr, replacestr: String;
    var newstr: String; pos: Integer = 1): Integer;
  var
    index: Integer;
  begin
     newstr := str;
     index := PosEx(substr, newstr, pos);
     Delete(newstr, index, Length(substr));
     Insert(replacestr, newstr, index);
     Result := index + Length(replacestr);
  end;

var
  types, Res: String;
  I, Y, index: Integer;
begin
  Res := fmt;
  index := 1;
  types := GetTypes(fmt);
  Y := CountLine(src);
  for I:= 1 to Length(types) do
  begin
    if (Y >= I) then
      index := ReplaceAtPos(Res, '%'+types[I], GetLine(src, I - 1), Res, index);
  end;
  Result := Res;
end;

function print_in_order(const fmt, src, order: String): String;
var
  Ordr, src_count, order_count, I: Integer;
  new_src, new_fmt: String;
begin
  new_src := '';
  order_count := CountLine(order);
  src_count := CountLine(src);
  I := Pos('ORDER{', UpperCase(fmt));
  new_fmt := Copy(fmt, I + 6, Length(fmt));
  I := Pos('}', new_fmt);
  new_fmt := Copy(new_fmt, I + 1, length(new_fmt));
  for I:= 0 to Pred(order_count) do
  begin
    Ordr := StrToIntDef(GetLine(order, I), 0);
    if (Ordr > 0) and (Ordr <= src_count) then
      AddStr(GetLine(src, Ordr - 1), new_src);
  end;
  if Length(new_src) = 0 then new_src := src;
  Result := prinfts(new_fmt, new_src);
end;

function RemoveInfor(const str: String): String;
var
  I: Integer;
  Res: String;
begin
  Res := str;
  I := Pos(': error: ', str);
  if I > 0 then
    Res := Copy(str, I + 9, Length(str))
  else
  begin
    I := Pos(': warning: ', str);
    if I > 0 then
      Res := Copy(str, I + 11, Length(str))
    else
    begin
      I := Pos(':', str);
      if (I > 0) then
      begin
        Res := Copy(str, I + 1, Length(str));
        I := Pos(':', res);
        if (I > 0) then
        begin
          Res := Copy(res, I + 1, Length(res));
          I := Pos(':', res);
          if (I > 0) then
            Res := Copy(res, I + 1, Length(res));
        end;
      end;
    end;
  end;
  Result := Trim(Res);
end;

function sscanfs(const fmt, src: String; var str_out: String): Boolean;
var
  Consts, Values: String;
  Temp, Str, Types: String;
  I: Integer;
begin
  Temp := fmt;
  str_out := '';
  Result := False;
  if (Length(fmt) < 2) or (Length(src) = 0) then Exit;
  Types := GetTypes(fmt);
  for I:= 1 to Length(types) do
    Temp := StringReplace(Temp, '%' + types[I], #13, [rfReplaceAll]);
  if Temp[Length(Temp)] = #13 then Delete(Temp, Length(Temp), 1);
  if Temp[1] = #13 then Delete(Temp, 1, 1);
  Consts := Temp;
  Temp := src;
  for I:= 0 to Pred(CountLine(Consts)) do
  begin
    Str := GetLine(Consts, I);
    if (Pos(Str, Temp) > 0) then
      Temp := StringReplace(Temp, Str, #13, [])
    else
      Exit;
  end;
  Values := Temp;
  for I:= 1 to Length(Types) do
    AddStr(GetLine(Values, I - 1), str_out);
  Result := True;
end;

function ParseResult(Value: TStrings): TStrings;

  function IsNumber(Str: String): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I:= 1 to Length(Str) do
      if not(Str[I] in ['0'..'9', '.']) then
      begin
        Result := False;
      end;
  end;

  function HasNextLine(Str: String): Integer;
  var
    I, Count: Integer;
  begin
    Count := 0;
    for I:= 1 to Length(Str) do
    begin
      if Str[I] in ['(', '[', '{'] then
      begin
        if (I > 1) and (I < Length(Str)) then
        begin
          if (Str[I - 1] <> APS) or (Str[I + 1] <> APS) then
            Inc(Count);
        end
        else
          Inc(Count);
      end;
      if Str[I] in [')', ']', '}'] then
      begin
        if (I > 1) and (I < Length(Str)) then
        begin
          if (Str[I - 1] <> APS) or (Str[I + 1] <> APS) then
            Dec(Count);
        end
        else
          Dec(Count);
      end;
    end;
    Result := Count;
  end;

const
  IMG_MSG: array[0..2] of Integer = (32, 33, 34);
var
  Temp: TStrings;
  Msg: TMessageItem;
  SLn, Params, fmt, order, OriMsg, Capt: String;
  I, X: Integer;
  Cont, Translated: Boolean;
begin
  Temp := TStringList.Create;
  //** parse results**//
  Cont := False;
  Capt := FrmFalconMain.Caption;
  for I:= 0 to Pred(Value.Count) do
  begin
    if FrmFalconMain.CompilationStopped then
      Break;
    if (Value.Count > 500) then
      FrmFalconMain.Caption :=
        Format('Falcon C++ ['+STR_FRM_MAIN[42]+']', [I + 1, Value.Count]);
    Application.ProcessMessages;
    if Cont then
    begin
      //verify ocorrence next line
      SLn := SLn + Copy(Value.Strings[I], Pos('error:', Value.Strings[I]) + 6,
        Length(Value.Strings[I]));
      Cont := False;
    end
    else
      SLn := Value.Strings[I];

    if HasNextLine(SLn) <> 0 then
    begin
      Cont := True;
      Continue;
    end;
    OriMsg := SLn;
    SLn := ResolveUnixFileName(SLn);
    if not (Pos('mingw32-make.exe', SLn) > 0) then
    begin
      Msg := TMessageItem.Create;
      Msg.MsgType := mitCompiler;
      Msg.OriMsg := SLn;
      //* check message type *//
      if (Pos(': error:', SLn) > 0) or (Pos(': undefined', SLn) > 0) then
        Msg.Icon := IMG_MSG[2]
      else if (Pos(': warning:', SLn) > 0) then
        Msg.Icon := IMG_MSG[1]
      else
        Msg.Icon := IMG_MSG[0];

      //*translate messages*//
      for X := 1 to MAX_CMPMSG do
      begin
        Application.ProcessMessages;
        if IsCompatible(CONST_STR_CMPMSG[X], SLn) then
        begin
          if sscanfs(CONST_STR_CMPMSG[X], SLn, Params) then
          begin
            fmt := GetTypes(CONST_STR_CMPMSG[X]);
            Msg.FileName := GetLine(Params, 0);
            if ExistLineNumber(CONST_STR_CMPMSG[X]) then
              Msg.Line := StrToIntDef(GetLine(Params, 1), 0);
            if ExistColNumber(CONST_STR_CMPMSG[X]) then
              Msg.Col := StrToIntDef(GetLine(Params, 2), 0);

            if CanOrder(STR_CMPMSG[X], order) then
            begin
              SLn := print_in_order(STR_CMPMSG[X], Params, order);
            end
            else
            begin
              SLn := prinfts(STR_CMPMSG[X], Params);
            end;
            Translated := True;
            Break;
          end
          else
            Translated := False;
        end
        else
          Translated := False;
      end;
      if not Translated then
      begin
        Msg.FileName := Copy(SLn, 1, Pos(':', SLn) - 1);
        Msg.Line := StrToIntDef(GetNumberOfOutLine(SLn), 0);
        if ExistCol(SLn, order) then
          Msg.Col := StrToIntDef(order, 0);
        SLn := RemoveInfor(SLn);
      end;
      Msg.Msg := SLn;
      Temp.AddObject(Msg.Msg, Msg);
    end;
  end;
  //******************//
  FrmFalconMain.Caption := Capt;
  Result := Temp;
end;

end.
