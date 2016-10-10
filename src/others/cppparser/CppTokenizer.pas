unit CppTokenizer;

interface

type
  TTkxType = (tkxIdentifier, tkxNumber, tkxPreprocessor, tkxPlus, tkxInc,
    tkxMinus, tkxDec, tkxMult, tkxDiv, tkxBackslash, tkxMod, tkxBinAnd, tkxBinOr,
    tkxXor, tkxBinNot, tkxShiftLeft, tkxShiftRight, tkxTernary, tkxAssign,
    tkxEqual, tkxNot, tkxAnd, tkxOr, tkxDiff, tkxLess, tkxGreater, tkxLessEqual,
    tkxGreaterEqual, tkxString, tkxComment, tkxCharacter, tkxOpenParentheses,
    tkxCloseParentheses, tkxOpenBraces, tkxCloseBraces, tkxOpenBrackets,
    tkxCloseBrackets, tkxDot, tkxInterval, tkxComma, tkxSemicolon, tkxColon,
    tkxIncludePath, tkxGlobalScope);
    
  PToken = ^TToken;
  TToken = packed record
    Token        : TTkxType;
    StartPosition: Integer;
    EndPosition  : Integer;
    Line         : Integer;
    Prior        : PToken;
    Next         : PToken;
  end;

function StartTokenizer(const StartPtr: PChar): PToken;
procedure FreeTokens(First: PToken);
function TokenMatch(const StartPtr: PChar; const S: string; Token: PToken): Boolean; inline;
function TokenLength(Token: PToken): Integer; inline;
function TokenString(const StartPtr: PChar; Token: PToken): string; inline;
function TokenAtPosition(First: PToken; Position: Integer): PToken;

function IsWordOrNumber(const StartPtr: PChar): Boolean;

implementation

uses SysUtils;


function TokenMatch(const StartPtr: PChar; const S: string; Token: PToken): Boolean; inline;
begin
  Result := (Token <> nil) and (Length(S) = (Token^.EndPosition - Token^.StartPosition)) and
    (StrLComp(StartPtr + Token^.StartPosition, PChar(S),
            Token^.EndPosition - Token^.StartPosition) = 0);
end;

function TokenLength(Token: PToken): Integer; inline;
begin
  Result := Token^.EndPosition - Token^.StartPosition;
end;

function TokenString(const StartPtr: PChar; Token: PToken): string; inline;
begin
  if Token = nil then
  begin
    Result := '';
    Exit;
  end;
  SetLength(Result, Token^.EndPosition - Token^.StartPosition);
  StrLCopy(PChar(Result), StartPtr + Token^.StartPosition,
    Token^.EndPosition - Token^.StartPosition);
end;

function TokenAtPosition(First: PToken; Position: Integer): PToken;
var
  Next: PToken;
begin
  Next := First;
  while Next <> nil do
  begin
    if (Position >= Next^.StartPosition) and (Position <= Next^.EndPosition) then
    begin
      Result := Next;
      Exit;
    end;
    Next := Next^.Next;
  end;
  Result := nil;
end;

function AddToken(StartPosition, EndPosition, Line: Integer; Token: TTkxType;
  Last: PToken; var First: PToken): PToken;
begin
  GetMem(Result, SizeOf(TToken));
  Result^.Token := Token;
  Result^.StartPosition := StartPosition;
  Result^.EndPosition := EndPosition;   
  Result^.Line := Line;
  Result^.Prior := Last;
  Result^.Next := nil;
  if Last <> nil then
    Last^.Next := Result
  else
    First := Result;
end;

function ProcessSingleComment(const StartPtr: PChar; var Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
  SaveLine: Integer;
begin
  SaveLine := Line;
  StartPos := Ptr;
  Inc(Ptr, 2); // skip "//"
  while not CharInSet(Ptr^, [#10, #13, #0]) do
  begin
    if Ptr^ = '\' then
    begin
      if (Ptr + 1)^ = '\' then
      begin
        Inc(Ptr, 2);
        Continue;
      end;
      Inc(Ptr);
      while CharInSet(Ptr^, [' ', #9]) do
        Inc(Ptr);
      if Ptr^ = #10 then // multi line string
      begin
        Inc(Line); // linux line ending
      end
      else if Ptr^ = #13 then
      begin
        Inc(Line);
        if (Ptr + 1)^ = #10 then // windows line ending
          Inc(Ptr);
        // else mac line ending
      end
      else
        Continue;
    end;
    Inc(Ptr);
  end;
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, SaveLine, tkxComment, Last, First);
end;

function ProcessMultLineComment(const StartPtr: PChar; var Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
  SaveLine: Integer;
begin
  SaveLine := Line;
  StartPos := Ptr;
  Inc(Ptr, 2);  // skip "/*"
  while Ptr^ <> #0 do
  begin
    case Ptr^ of
      #10: Inc(Line); // linux line ending
      #13:
      begin
        Inc(Line);
        if (Ptr + 1)^ = #10 then  // windows line ending
          Inc(Ptr);
        // else mac line ending
      end;
      '*':
      begin
        if (Ptr + 1)^ = '/' then
        begin
          Inc(Ptr, 2);
          Break;
        end;
      end;
    end;
    Inc(Ptr);
  end;
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, SaveLine, tkxComment, Last, First);
end;

function ProcessIncludePath(const StartPtr: PChar; var Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
  SaveLine: Integer;
begin
  SaveLine := Line;
  StartPos := Ptr; 
  Inc(Ptr);
  while True do
  begin
    case Ptr^ of
      #10, #13, #0: Break; // unterminated string
      '\':
      begin
        if CharInSet((Ptr + 1)^, ['>', '\']) then
          Inc(Ptr)
        else if (Ptr + 1)^ = #10 then // multi line string
        begin
          Inc(Line); // linux line ending
          Inc(Ptr);
        end
        else if (Ptr + 1)^ = #13 then
        begin
          Inc(Ptr);
          Inc(Line);
          if (Ptr + 1)^ = #10 then  // windows line ending
            Inc(Ptr);
          // else mac line ending
        end;
      end;
      '>':
      begin
        Inc(Ptr);
        Break;
      end;
    end;
    Inc(Ptr);
  end;
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, SaveLine, tkxIncludePath,
    Last, First);
end;

function ProcessDoubleQuotes(const StartPtr: PChar; var Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
  SaveLine: Integer;
begin
  SaveLine := Line;
  StartPos := Ptr; 
  Inc(Ptr);
  while True do
  begin
    case Ptr^ of
      #10, #13, #0: Break; // unterminated string
      '\':
      begin
        if CharInSet((Ptr + 1)^, ['"', '\']) then
          Inc(Ptr)
        else if (Ptr + 1)^ = #10 then // multi line string
        begin
          Inc(Line); // linux line ending
          Inc(Ptr);
        end
        else if (Ptr + 1)^ = #13 then
        begin
          Inc(Ptr);
          Inc(Line);
          if (Ptr + 1)^ = #10 then  // windows line ending
            Inc(Ptr);
          // else mac line ending
        end;
      end;
      '"':
      begin
        Inc(Ptr);
        Break;
      end;
    end;
    Inc(Ptr);
  end;
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, SaveLine, tkxString, Last, First);
end;

function ProcessSingleQuotes(const StartPtr: PChar; var Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
  SaveLine: Integer;
begin
  SaveLine := Line;
  StartPos := Ptr; 
  Inc(Ptr);
  while True do
  begin
    case Ptr^ of
      #10, #13, #0: Break; // unterminated string
      '\':
      begin
        if CharInSet((Ptr + 1)^, ['''', '\']) then
          Inc(Ptr)
        else if (Ptr + 1)^ = #10 then // multi line string
        begin
          Inc(Line); // linux line ending
          Inc(Ptr);
        end
        else if (Ptr + 1)^ = #13 then
        begin
          Inc(Ptr);
          Inc(Line);
          if (Ptr + 1)^ = #10 then  // windows line ending
            Inc(Ptr);
          // else mac line ending
        end;
      end;
      '''':
      begin
        Inc(Ptr);
        Break;
      end;
    end;
    Inc(Ptr);
  end;
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, SaveLine, tkxCharacter, Last, First);
end;

function ProcessIdentifier(const StartPtr: PChar; Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
begin
  StartPos := Ptr;
  while CharInSet(Ptr^, ['a'..'z', 'A'..'Z', '0'..'9', '_']) do
    Inc(Ptr);
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, Line, tkxIdentifier, Last, First);
end;

function ProcessNumber(const StartPtr: PChar; Line: Integer; var Ptr: PChar;
  Last: PToken; var First: PToken): PToken;
var
  StartPos: PChar;
begin
  StartPos := Ptr;
  while CharInSet(Ptr^, ['0'..'9']) do
    Inc(Ptr);
  if CharInSet(Ptr^, ['x', 'X']) then  // allow hexadecimal ex.: 0xa0Ffc, 48xF1?
  begin
    Inc(Ptr);
    while CharInSet(Ptr^, ['0'..'9', 'a'..'f', 'A'..'F']) do
      Inc(Ptr);
  end
  else if Ptr^ = '.' then // allow float numbers ex.: 9.5
  begin
    Inc(Ptr);
    while CharInSet(Ptr^, ['0'..'9']) do
      Inc(Ptr);
  end;
  if CharInSet(Ptr^, ['e', 'E']) then // allow scientific notation ex.: 15E10
  begin
    Inc(Ptr);
    while CharInSet(Ptr^, ['0'..'9']) do
      Inc(Ptr);
  end;
  if Ptr^ = 'f' then
    Inc(Ptr);
  Result := AddToken(StartPos - StartPtr, Ptr - StartPtr, Line, tkxNumber, Last, First);
end;

function StartTokenizer(const StartPtr: PChar): PToken;
var
  Ptr: PChar;
  Line: Integer;
  Last: PToken;
  Preprocessor, Include: Boolean;
begin
  Ptr := StartPtr;
  Result := nil;
  Line := 1;
  Last := nil;
  Preprocessor := False;
  Include := False;
  if (Ptr = nil) or (Ptr^ = #0) then
    Exit;
  repeat
    case Ptr^ of
      'a'..'z', 'A'..'Z', '_':
      begin
        Last := ProcessIdentifier(StartPtr, Line, Ptr, Last, Result);
        if Preprocessor then
        begin
          if TokenMatch(StartPtr, 'include', Last) then // allow treat content of <> as string
            Include := True
          else
            Preprocessor := False;
        end;
        Continue;
      end;
      '0'..'9':
      begin
        Last := ProcessNumber(StartPtr, Line, Ptr, Last, Result);
        Continue;
      end;
      '+':
      begin
        if (Ptr + 1)^ = '+' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxInc, Last, Result);
          Inc(Ptr);
        end
        else                                                                                
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxPlus, Last, Result);
      end;
      '-':
      begin
        if (Ptr + 1)^ = '-' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxDec, Last, Result);
          Inc(Ptr);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxMinus, Last, Result);
      end;
      '*': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxMult, Last, Result);
      '/':
      begin
        if (Ptr + 1)^ = '/' then
        begin
          Last := ProcessSingleComment(StartPtr, Line, Ptr, Last, Result);
          Continue;
        end
        else if (Ptr + 1)^ = '*' then
        begin
          Last := ProcessMultLineComment(StartPtr, Line, Ptr, Last, Result);
          Continue;
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxDiv, Last, Result);
      end;
      '\': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxBackslash, Last, Result);
      '%': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxMod, Last, Result);
      '&':
      begin
        if (Ptr + 1)^ = '&' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxAnd, Last, Result);
          Inc(Ptr);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxBinAnd, Last, Result);
      end;
      '|':
      begin
        if (Ptr + 1)^ = '|' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxOr, Last, Result);
          Inc(Ptr);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxBinOr, Last, Result);
      end;
      '^': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxXor, Last, Result);
      '~': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxBinNot, Last, Result);
      '!':
      begin
        if (Ptr + 1)^ = '=' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxDiff, Last, Result);
          Inc(Ptr);
        end
        else                                                                                
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxNot, Last, Result);
      end;
      '?': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxTernary, Last, Result);
      '=':
      begin
        if (Ptr + 1)^ = '=' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxEqual, Last, Result);
          Inc(Ptr);
        end
        else                                                                                
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxAssign, Last, Result);
      end;
      '<':
      begin
        if Include then // #include <...
        begin
          Last := ProcessIncludePath(StartPtr, Line, Ptr, Last, Result);
          Continue;
        end
        else if (Ptr + 1)^ = '=' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxLessEqual, Last, Result);
          Inc(Ptr);
        end
        else if (Ptr + 1)^ = '<' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxShiftLeft, Last, Result);
          Inc(Ptr);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxLess, Last, Result);
      end;
      '>':
      begin
        if (Ptr + 1)^ = '=' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxGreaterEqual, Last, Result);
          Inc(Ptr);
        end
        else if (Ptr + 1)^ = '>' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxShiftRight, Last, Result);
          Inc(Ptr);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxGreater, Last, Result);
      end;
      '(': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxOpenParentheses, Last, Result);
      ')': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxCloseParentheses, Last, Result);
      '[': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxOpenBrackets, Last, Result);
      ']': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxCloseBrackets, Last, Result);
      '{': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxOpenBraces, Last, Result);
      '}': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxCloseBraces, Last, Result);
      '.':
      begin
        if ((Ptr + 1)^ = '.') and ((Ptr + 2)^ = '.') then 
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 3 - StartPtr, Line, tkxInterval, Last, Result);
          Inc(Ptr, 2);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxDot, Last, Result);
      end;
      ',': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxComma, Last, Result);
      ';': Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxSemicolon, Last, Result);
      ':':
      begin
        if (Ptr + 1)^ = ':' then
        begin
          Last := AddToken(Ptr - StartPtr, Ptr + 2 - StartPtr, Line, tkxGlobalScope, Last, Result);
          Inc(Ptr);
        end
        else
          Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxColon, Last, Result);
      end;
      '#':
      begin
        Last := AddToken(Ptr - StartPtr, Ptr + 1 - StartPtr, Line, tkxPreprocessor, Last, Result);
        Preprocessor := True;
      end;
      #10:
      begin
        Inc(Line); // linux line ending
        Preprocessor := False;
        Include := False;
      end;
      #13:
      begin
        Inc(Line);
        if (Ptr + 1)^ = #10 then  // windows line ending
          Inc(Ptr);
        // else mac line ending
        Preprocessor := False;
        Include := False;
      end;
      '"':
      begin
        Last := ProcessDoubleQuotes(StartPtr, Line, Ptr, Last, Result);
        Continue;
      end;
      '''':
      begin
        Last := ProcessSingleQuotes(StartPtr, Line, Ptr, Last, Result);
        Continue;
      end;
      #0: Break;
      ' ', #9:; // skip spaces
    else
      // invalid char? skip
    end;
    Inc(Ptr);
  until Ptr^ = #0;
end;

procedure FreeTokens(First: PToken);
var
  Next, Save: PToken;
begin
  Next := First;
  while Next <> nil do
  begin
    Save := Next;
    Next := Next^.Next;
    FreeMem(Save);
  end;
end;

function IsWordOrNumber(const StartPtr: PChar): Boolean;
var
  Ptr: PChar;
begin
  Result := False;
  if StartPtr = nil then
    Exit;
  Ptr := StartPtr;
  while Ptr^ <> #0 do
  begin
    if not CharInSet(Ptr^, ['0'..'9', '_', 'a'..'z','A'..'Z']) then
      Exit;
    Inc(Ptr);
  end;
  Result := True;
end;

end.
