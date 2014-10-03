unit CodeTemplate;

interface

uses
  Classes, TokenList, TokenUtils, TokenConst, USourceFile, UEditor;

procedure AddTemplates(Trigger: string; Scope: TTkType; ItemList,
  ShowList: TStrings; CompletionColors: TCompletionColors;
  Images: array of Integer; CompilerType: Integer; Filter: TTokenSearchMode = []);
procedure ExecuteCompletion(const Input: string; Token: TTokenClass;
  AEditor: TEditor);

implementation

uses SysUtils;

var
  FList: TList;

procedure clearTemplateList;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TTokenClass(FList.Items[I]).Free;
  FList.Clear;
end;

procedure AddTemplates(Trigger: string; Scope: TTkType; ItemList,
  ShowList: TStrings; CompletionColors: TCompletionColors;
  Images: array of Integer; CompilerType: Integer; Filter: TTokenSearchMode);

  procedure Add(const Name, Comment, ShowCode, Code: string);
  var
    NewToken: TTokenClass;
  begin
    if ((Pos(Copy(Trigger, 1, 1), Name) <> 1) or (Trigger = '')) and (Filter = []) then
      Exit;
    NewToken := TTokenClass.Create;
    NewToken.Name := Name;
    NewToken.Flag := Comment;
    NewToken.Comment := ShowCode + #0 + Code + #0;
    NewToken.Token := tkCodeTemplate;
    ItemList.AddObject(CompletionInsertItem(NewToken), NewToken);
    ShowList.AddObject(CompletionShowItem(NewToken, CompletionColors, Images), NewToken);
    FList.Add(NewToken);
  end;

var
  Temp: string;
begin
  clearTemplateList;
  Trigger := LowerCase(Trigger);
  if (Filter = []) or (tkVariable in Filter) then
  begin
    Add('void', '', '', '');
    Add('char', '', '', '');
    Add('short', '', '', '');
    Add('int', '', '', '');
    Add('float', '', '', '');
    Add('double', '', '', '');
    Add('long', '', '', '');
    Add('unsigned', '', '', '');
    Add('sizeof', '', '', '');
    Add('sizeof', 'queries size of the object or type', 'sizeof(type)', 'sizeof(|)');
    Add('signed', '', '', '');
    Add('export', '', '', '');
    Add('extern', '', '', '');
    Add('return', '', '', '');
    Add('register', '', '', '');
    Add('static', '', '', '');
    Add('inline', '', '', '');
    Add('const', '', '', '');
  end;
  if CompilerType = COMPILER_CPP then
  begin
    if (Filter = []) then
    begin
      Add('bool', '', '', '');
      Add('true', '', '', '');
      Add('false', '', '', '');
      Add('new', '', '', '');
      Add('delete', '', '', '');
      Add('typename', '', '', '');
      Add('template', '', '', '');
      Add('namespace', '', '', '');
      Add('namespace', 'namespace statement',
        'namespace name'#13 +
        '{'#13 +
        '    '#13+
        '}',
        'namespace |'#13 +
        '{'#13 +
        '    '#13+
        '}');
      Add('using', '', '', '');
      Add('using', 'using namespace statement',
        'using namespace name;',
        'using namespace |;');
      Add('virtual', '', '', '');
      Add('const_cast', '', '', '');
      Add('const_cast', 'const_cast conversion', 'const_cast<new_type>(expression)', 'const_cast<|>();');
      Add('dynamic_cast', '', '', '');
      Add('dynamic_cast', 'dynamic_cast conversion', 'dynamic_cast<new_type>(expression)', 'dynamic_cast<|>();');
      Add('reinterpret_cast', '', '', '');
      Add('reinterpret_cast', 'reinterpret_cast conversion', 'reinterpret_cast<new_type>(expression)', 'reinterpret_cast<|>();');
      Add('static_cast', '', '', '');
      Add('static_cast', 'static_cast conversion', 'static_cast<new_type>(expression)', 'static_cast<|>();');
    end;
  end;
  if Scope in [tkFunction, tkConstructor, tkDestructor, tkOperator] then
  begin
    if (Filter = []) then
    begin
      Add('while', 'while loop with condition',
        'while(condition)'#13 +
        '{'#13 +
        '    '#13+
        '}',
        'while(|)'#13 +
        '{'#13 +
        '    '#13+
        '}');
      Add('while', '', '', '');
      Add('do', 'do while statement',
        'do'#13 +
        '{'#13 +
        '    '#13+
        '} while(condition);',
        'do'#13 +
        '{'#13 +
        '    '#13+
        '} while(|);');
      Add('do', '', '', '');
      Add('goto', '', '', '');
      Add('case', '', '', '');
      Add('continue', '', '', '');
      Add('break', '', '', '');
      if CompilerType = COMPILER_CPP then
      begin
        Add('this', '', '', '');
        Add('friend', '', '', '');
        Add('try', '', '', '');
        Add('throw', '', '', '');
        Add('catch', '', '', '');
      end;
      if CompilerType = COMPILER_CPP then
      begin
        Add('for', 'iterate n times',
          'for(int i = 0; i < n; i++)'#13 +
          '{'#13 +
          '    '#13+
          '}',
          'for(int i = 0; i < |; i++)'#13 +
          '{'#13 +
          '    '#13+
          '}');
        Add('for', 'iterate using iterator',
          'for(it = list.begin(); it != list.end(); it++)'#13 +
          '{'#13 +
          '    '#13+
          '}',
          'for(it = list.begin(); it != list.end(); it++)'#13 +
          '{'#13 +
          '    |'#13+
          '}');
      end
      else
      begin
        Add('for', 'iterate n times',
          'for(i = 0; i < n; i++)'#13 +
          '{'#13 +
          '    '#13+
          '}',
          'for(i = 0; i < |; i++)'#13 +
          '{'#13 +
          '    '#13+
          '}');
      end;
      Add('for', '', '', '');
      Add('switch', 'switch case statement',
        'switch(key)'#13 +
        '{'#13 +
        'case value:'#13+
        '    break;'#13+
        'default:'#13+
        '    break;'#13+
        '}',
        'switch(|)'#13 +
        '{'#13 +
        'case value:'#13+
        '    break;'#13+
        'default:'#13+
        '    break;'#13+
        '}');
      Add('switch', '', '', '');
      Add('if', 'if statement',
        'if(condition)'#13 +
        '{'#13 +
        '    '#13+
        '}',
        'if(|)'#13 +
        '{'#13 +
        '    '#13+
        '}');
      Add('ifelse', 'if else statement',
        'if(condition)'#13 +
        '{'#13 +
        '    '#13 +
        '}'#13 +
        'else'#13 +
        '{'#13 +
        '    '#13 +
        '}',
        'if(|)'#13 +
        '{'#13 +
        '    '#13 +
        '}'#13 +
        'else'#13 +
        '{'#13 +
        '    '#13 +
        '}');
      Add('if', '', '', '');
      Add('else', '', '', '');
      Add('else', 'else block',
        'else'#13 +
        '{'#13 +
        '    '#13 +
        '}',
        'else'#13 +
        '{'#13 +
        '    |'#13 +
        '}');
      Add('elseif', 'else block',
        'else if(condition)'#13 +
        '{'#13 +
        '    '#13 +
        '}',
        'else if(|)'#13 +
        '{'#13 +
        '    '#13 +
        '}');
      Add('default', '', '', '');
    end;
  end;
  if not (Scope in [tkFunction, tkConstructor, tkDestructor, tkOperator]) and
   (CompilerType = COMPILER_CPP) then
  begin
    if (Filter = []) then
    begin
      Add('class', 'class statement',
        'class name'#13 +
        '{'#13 +
        'private:'#13 +
        '    '#13 +
        'protected:'#13 +
        '    '#13 +
        'public:'#13 +
        '    '#13 +
        '};',
        'class |'#13 +
        '{'#13 +
        'private:'#13 +
        '    '#13 +
        'protected:'#13 +
        '    '#13 +
        'public:'#13 +
        '    '#13 +
        '};');
      Add('class', '', '', '');
      Add('public', '', '', '');
      Add('protected', '', '', '');
      Add('private', '', '', '');
      Add('operator', '', '', '');
    end;
  end;
  if (Filter = []) or (tkTypedef in Filter) then
  begin
    Add('typedef', '', '', '');
    Add('struct', 'struct statement',
      'struct name'#13 +
      '{'#13 +
      '    '#13 +
      '};',
      'struct |'#13 +
      '{'#13 +
      '    '#13 +
      '};');
    Add('struct', '', '', '');
    Add('enum', 'enum statement',
      'enum name'#13 +
      '{'#13 +
      '    '#13 +
      '};',
      'enum |'#13 +
      '{'#13 +
      '    '#13 +
      '};');
    Add('enum', '', '', '');
    Add('union', 'union statement',
      'union name'#13 +
      '{'#13 +
      '    '#13 +
      '};',
      'union |'#13 +
      '{'#13 +
      '    '#13 +
      '};');
    Add('union', '', '', '');
  end;
  if (Filter = []) or (tkInclude in Filter) then
  begin
    Temp := '#';
    if not (Filter = []) then
      Temp := '';
    if Scope = tkUnknow then
    begin
      Add('include', 'include header file',
        '#include <file>',
        Temp + 'include <|>');
      Add('include', 'include local header file',
        '#include "file"',
        Temp + 'include "|"');
      Add('include', '', '', '');
    end;
  end;
  if (Filter = []) or (tkDefine in Filter) then
  begin
    Temp := '#';
    if not (Filter = []) then
      Temp := '';
    Add('define', 'define macro',
      '#define NAME',
      Temp + 'define |');
    Add('define', '', '', '');
    Add('ifdef', 'ifdef macro',
      '#ifdef NAME',
      Temp + 'ifdef |');
    Add('ifdef', '', '', '');
    Add('ifndef', 'ifndef macro',
      '#ifndef NAME',
      Temp + 'ifndef |');
    Add('ifndef', '', '', '');
    Add('undef', 'undef macro',
      '#undef NAME',
      Temp + 'undef |');
    Add('undef', '', '', '');
    Add('endf', 'close ifdef or ifndef',
      Temp + 'endif', '#endif');
    Add('endif', '', '', '');
  end;
  if (Filter = []) and (Scope = tkUnknow) then
  begin
    Add('main', 'main function',
      'int main()'#13 +
      '{'#13 +
      '    return 0;'#13 +
      '}',
      'int main()'#13 +
      '{'#13 +
      '    |'#13 +
      '    return 0;'#13 +
      '}');
    Add('main', 'main function with parameters',
      'int main(int argc, char** argv)'#13 +
      '{'#13 +
      '    return 0;'#13 +
      '}',
      'int main(int argc, char** argv)'#13 +
      '{'#13 +
      '    |'#13 +
      '    return 0;'#13 +
      '}');
  end;
end;

procedure StripTemplate(Token: TTokenClass; var Code, ShowCode: string);
var
  pcode, ipcode: PChar;
begin
  pcode := PChar(Token.Comment) + Length(Token.Comment) - 2;
  ShowCode := StrPas(PChar(Token.Comment));
  ipcode := pcode;
  while (ipcode > PChar(Token.Comment)) and ((ipcode - 1)^ <> #0) do
    Dec(ipcode);
  if ipcode >= PChar(Token.Comment) then
  begin
    SetLength(Code, pcode - ipcode + 1);
    StrLCopy(PChar(Code), ipcode, pcode - ipcode + 1);
  end
  else
    Code := '';
end;

procedure ExecuteCompletion(const Input: string; Token: TTokenClass;
  AEditor: TEditor);
var
  i, j, K, L, Len, IndentLen, AfterLen: integer;
  s, sc, ln: string;
  ptr, iptr: PChar;
  p: TBufferCoord;
  NewCaretPos, PipeFind: boolean;
  Temp: TStringList;
begin
  // select token in editor
  p := AEditor.CaretXY;
  Len := Length(Input);
{begin}                                                                         //mh 2000-11-08
  AEditor.BeginUpdate;
  try
    AfterLen := 0;
    ln := AEditor.Lines[p.Line - 1];
    for I := p.Char to Length(ln) do
    begin
      if CharInSet(ln[I], LetterChars + DigitChars) then
        Inc(AfterLen)
      else
        Break;
    end;
    Temp := TStringList.Create;
    StripTemplate(Token, s, sc);
    Temp.Text := s;
    if Temp.Count > 0 then
      s := Temp[0];
    // override equivalent prior codes
    K := 0;
    I := 1;
    while (I >= 1) and (I <= (p.Char - Len) - 1) do
    begin
      L := I; // save next try position
      J := 1;
      while J <= Length(s) do
      begin
        if s[J] = ln[I] then
        begin
          if K = 0 then
            K := I;
          while (J <= Length(s)) and CharInSet(s[J], [#9, ' ']) do
            Inc(J);
          // can exceed input
          while (I <= (p.Char - Len) - 1) and CharInSet(ln[I], [#9, ' ']) do
            Inc(I);
          if I >= (p.Char - Len) - 1 then
            Break
          else
            Inc(I);
        end
        else
          Break;
        Inc(J);
      end;
      if not (I >= (p.Char - Len) - 1) then
      begin
        K := 0;
        I := L;
      end;
      Inc(I);
    end;
    if (K = 0) or (I <= (p.Char - Len) - 1) then
      K := p.Char - Len;
    AEditor.BlockBegin := BufferCoord(K, p.Line);
    AEditor.BlockEnd := BufferCoord(p.Char + AfterLen, p.Line);
    // indent the completion string if necessary, determine the caret pos
    IndentLen := 0;
    ptr := PChar(ln);
    if Assigned(ptr) and (ptr^ <> #0) then
      repeat
        if not CharInSet(ptr^, [#9, #32]) then Break;
        if ptr^ = #9 then
          Inc(IndentLen, AEditor.TabWidth)
        else
          Inc(IndentLen);
        Inc(ptr);
      until ptr^ = #0;
    p := AEditor.BlockBegin;
    NewCaretPos := FALSE;
    try
      // indent lines
      if (IndentLen > 0) and (Temp.Count > 1) then
      begin
        if AEditor.WantTabs then
          s := StringOfChar(#9, IndentLen div AEditor.TabWidth) + StringOfChar(' ', IndentLen mod AEditor.TabWidth)
        else
          s := StringOfChar(' ', IndentLen);
        for i := 1 to Temp.Count - 1 do
          Temp[i] := s + Temp[i];
      end;
      // find first '|' and use it as caret position
      PipeFind := False;
      j := 0;
      for i := 0 to Temp.Count - 1 do begin
        s := Temp[i];
        IndentLen := 0;
        ptr := PChar(s);
        iptr := ptr;
        if Assigned(ptr) and (ptr^ <> #0) then
          repeat
            if not CharInSet(ptr^, [#9, #32]) then Break;
            if ptr^ = #9 then
              Inc(IndentLen, AEditor.TabWidth)
            else
              Inc(IndentLen);
            Inc(ptr);
          until ptr^ = #0;
        if not PipeFind then
          j := Pos('|', s);
        if (IndentLen >= AEditor.TabWidth) and
          (ptr - iptr <= IndentLen) then
        begin
            s := StringOfChar(#9, IndentLen div AEditor.TabWidth) + StringOfChar(' ', IndentLen mod AEditor.TabWidth) +
              StrPas(ptr);
            if (j > 0) and not PipeFind then
              j := Pos('|', s)
            else
              Temp[i] := s;
        end;
        if (j > 0) and not PipeFind then begin
          Delete(s, j, 1);
          Temp[i] := s;
          NewCaretPos := TRUE;
          Inc(p.Line, i);
          if i = 0 then
            Inc(p.Char, j - 1)
          else
            p.Char := j;
          PipeFind := True;
        end;
      end;
      s := Temp.Text;
      // strip the trailing #13#10 that was appended by the stringlist
      i := Length(s);
      if (i >= 2) and (s[i - 1] = #13) and (s[i] = #10) then
        SetLength(s, i - 2);
    finally
      Temp.Free;
    end;
    // replace the selected text and position the caret
    AEditor.SelText := s;
    if NewCaretPos then
      AEditor.CaretXY := p;
  finally
    AEditor.EndUpdate;
  end;
end;

procedure createTemplateList;
begin
  FList := TList.Create;
end;

procedure freeTemplateList;
begin
  clearTemplateList;
  FList.Free;
end;


initialization

createTemplateList;

finalization

freeTemplateList;

end.
