unit UParseMsgs;

interface

uses
  SysUtils, Classes, Dialogs, Forms;

type
  TMessageItemType = (mitCompiler, mitGoto, mitFound);

  TMessageItem = class
  public
    MsgType: TMessageItemType;
    FileName: string;
    Line: Integer;
    Col: Integer;
    EndCol: Integer;
    Msg: string;
    OriMsg: string;
    Selec: string;
    Icon: Integer;
    constructor Create;
    function GetPosXY: string;
  end;

function GetNumberOfOutLine(Line: string): string;
function StringBetween(S, BeginDlm, EndDlm: string; ResAll: Boolean = True): string;
function ParseResult(Value: TStrings): TStrings;
function ResolveUnixFileName(const Str: string): string;

implementation

uses StrUtils, UFrmMain, ULanguages, TokenUtils, SynRegExpr;

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

function TMessageItem.GetPosXY: string;
begin
  Result := '';
  if (Line > 0) then
    Result := IntToStr(Line);
  if (Line > 0) and (Col > 0) then
    Result := Result + ': ' + IntToStr(Col);
end;

function GetNumberOfOutLine(Line: string): string;
var
  I: Integer;
begin
  I := StrToIntDef(StringBetween(Line, ':', ':'), -1);
  if (I > 0) then
    Result := IntToStr(I)
  else
    Result := '';
end;

function StringBetween(S, BeginDlm, EndDlm: string;
  ResAll: Boolean = True): string;
var
  i: integer;
  str: string;
begin
  str := S;
  i := Pos(BeginDlm, str);
  if (i > 0) or ResAll then
  begin
    if (i = 0) then
      I := 1;
    str := Copy(str, i + length(BeginDlm), length(str) - i);
    i := Pos(EndDlm, str);
    if (i > 0) or ResAll then
    begin
      if (i = 0) then
        i := length(str);
      str := Copy(str, 1, i - 1);
    end
    else
      str := '';
  end
  else
    str := '';
  Result := str;
end;

function ExistCol(const line: string; var col: string): Boolean;
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

function ResolveUnixFileName(const Str: string): string;
var
  I, Y: Integer;
  Nm, rest: string;
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

function RemoveInfor(const str: string): string;
var
  I: Integer;
  Res: string;
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

function ParseResult(Value: TStrings): TStrings;

  function HasNextLine(Str: string): Integer;
  var
    I, Count: Integer;
  begin
    Count := 0;
    for I := 1 to Length(Str) do
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
  SLn, order, OriMsg, Capt: string;
  I, J: Integer;
  Cont, Translated: Boolean;
  RegEx: TRegExpr;
begin
  Temp := TStringList.Create;
  RegEx := TRegExpr.Create;
  //** parse results**//
  Cont := False;
  Capt := FrmFalconMain.Caption;
  for I := 0 to Value.Count - 1 do
  begin
    if FrmFalconMain.CompilationStopped then
      Break;
    if (Value.Count > 500) then
      FrmFalconMain.Caption :=
        Format('Falcon C++ [' + STR_FRM_MAIN[42] + ']', [I + 1, Value.Count]);
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
      { translate messages }
      for J := 1 to MAX_CMPMSG do
      begin
        Application.ProcessMessages;
        if RegEx.Exec(CONST_STR_CMPMSG[J].Expression, SLn) and (STR_CMPMSG[J] <> '') then
        begin
          if CONST_STR_CMPMSG[J].FileName > 0 then
            Msg.FileName := RegEx.Match[CONST_STR_CMPMSG[J].FileName];
          if CONST_STR_CMPMSG[J].Line > 0 then
            Msg.Line := StrToInt(RegEx.Match[CONST_STR_CMPMSG[J].Line]);
          if CONST_STR_CMPMSG[J].Column > 0 then
            Msg.Col := StrToInt(RegEx.Match[CONST_STR_CMPMSG[J].Column]);
          SLn := RegEx.Substitute(STR_CMPMSG[J]);
          Translated := True;
          Break;
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
  RegEx.Free;
  FrmFalconMain.Caption := Capt;
  Result := Temp;
end;

end.
