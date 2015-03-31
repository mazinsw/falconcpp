unit StrMatch;

(*
  ZMMatch.pas - Wild filename matching
    Copyright (C) 2009, 2010  by Russell J. Peters, Roger Aelbrecht,
      Eric W. Engler and Chris Vleghert.

 This file is part of TZipMaster Version 1.9.
  modified 2011-03-05
---------------------------------------------------------------------------*)

interface

uses
  SysUtils;

// returned bit values
const
  MAIN = $01; // not empty
  MAIN_WILDALL = $02; // is *
  MAIN_HASWILD = $04;
  EXTN = $10;
  EXTN_WILDALL = $20;
  EXTN_HASWILD = $40;
  HAD_DOT = $08;

type
  TBounds = record
    Start: PChar;
    Finish: PChar;
  end;

  TParts = record
    Main: TBounds;
    Extn: TBounds;
    MainLen: Integer;
    ExtnLen: Integer;
  end;

function FileNameMatch(const UPattern, USpec: string): Boolean;
function StringIn(const S: string; List: array of string): Boolean;

implementation

function StringIn(const S: string; List: array of string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := Low(List) to High(List) do
    if SameText(List[I], S) then
      Exit;
  Result := False;
end;

// return <0 _ match to *, 0 _ match to end, >0 _ no match

function Wild(var Bp, Bs: TBounds): Integer;
var
  cp: Char;
  cs: Char;
begin
  Result := -1; // matches so far
  // handle matching characters before wild
  while (Bs.Start <= Bs.Finish) and (Bp.Start <= Bp.Finish) do
  begin
    cp := Bp.Start^;
    cs := Bs.Start^;
    if cp <> cs then
    begin
      if cp = '*' then
        break; // matched to *
      // would match anything except path sep
      if (cp <> '?') or (cs = '\') then
      begin
        Result := 1; // no match
        Exit;
      end;
    end;
    // they match
    Inc(Bp.Start);
    Inc(Bs.Start);
  end;
  // we have * or eos
  if Bp.Start > Bp.Finish then
  begin
    if Bs.Start > Bs.Finish then
      Result := 0; // matched to end
  end;
  if Result < 0 then
  begin
    // handle matching characters from wild to end
    while Bs.Start <= Bs.Finish do
    begin
      cp := Bp.Finish^;
      cs := Bs.Finish^;
      if cp <> cs then
      begin
        if cp = '*' then
          break;
          // must not match path sep
        if (cp <> '?') or (cs = '\') then
        begin
          Result := 1; // no match
          break;
        end;
      end;
      // they match
      Dec(Bp.Finish);
      Dec(Bs.Finish);
    end;
  end;
end;

function WildCmp(Bp, Bs: TBounds): Integer;
var
  bpt: TBounds;
  bst: TBounds;
  sm: Integer;
  pidx: PChar;
  sidx: PChar;
begin
  // quick check for '*'
  if (Bp.Start = Bp.Finish) and (Bp.Start <> nil) and (Bp.Start^ = '*') then
  begin
    Result := 0; // matches any/none
    exit;
  end;
  // no more Spec?
  if Bs.Finish < Bs.Start then
  begin
    if Bp.Finish < Bp.Start then
      Result := 0 // empty matches empty
    else
      Result := 3; // no match
    exit;
  end;
  // handle matching characters before wild
  Result := Wild(Bp, Bs);
  if Result < 0 then
  begin
    pidx := Bp.Start;
    sidx := Bs.Start;
    if Bp.Start > Bp.Finish then
    begin
      if sidx <= Bs.Finish then
        Result := 123
      else
        Result := 0;
      exit;
    end;
    // handle wild
    if (sidx <= Bs.Finish) and (pidx^ = '*') then
    begin
      // skip multiple *
      while (pidx < Bp.Finish) and ((pidx + 1)^ = '*') and (pidx^ = '*') do
        Inc(pidx);
      // end of Pattern?
      if pidx = Bp.Finish then
        Result := 0 // match
      else
      begin
        Inc(pidx);
        bpt.Start := pidx;
        bpt.Finish := Bp.Finish;
        bst.Start := sidx;
        bst.Finish := Bs.Finish;
        while (bst.Start <= bst.Finish) do
        begin
          // recursively compare sub patterns
          sm := WildCmp(bpt, bst);
          if sm = 0 then
          begin
            Result := 0; // match
            break;
          end;
          Inc(bst.Start);
        end;
        if Result <> 0 then
          Result := 1; // no match
      end;
    end;
    // end of Spec - Pattern must only have *
    if Result < 0 then
    begin
      while (pidx <= Bp.Finish) and (pidx^ = '*') do
        Inc(pidx);
      if pidx > Bp.Finish then
        Result := 0; // matched
    end;
  end;
end;

function Decompose(var idx: PChar; var parts: TParts): Integer;
var
  c: Char;
  ExtnFinish: PChar;
  ExtnStart: PChar;
  MainFinish: PChar;
  MainStart: PChar;
  mwildall: Integer;
  tmp: PChar;
  xwildall: Integer;
begin
  Result := 0;
  mwildall := 0;
  xwildall := 0;
//  parts.MainLen := 0;
  parts.ExtnLen := 0;
  ExtnStart := nil;
  ExtnFinish := nil;
  // at start of text or spec
  MainStart := idx;
  MainFinish := nil;
  while True do
  begin
    c := idx^;
    case c of
      '.':
        if idx > MainStart then
        begin
        // we probably have extn
          if ExtnStart <> nil then
            Inc(mwildall, xwildall); // count all * in main
          ExtnStart := idx + 1;
          xwildall := 0;
        end;
      '\', '/', ':':
        begin
          if c = '/' then
            idx^ := '\'; // normalise path seps
          if ExtnStart <> nil then
          begin
          // was false start of extn
            ExtnStart := nil;
            Inc(mwildall, xwildall); // count all * in main
            xwildall := 0;
          end;
        end;
      ' ':
        begin
        // space can be embedded but cannot trail
          tmp := idx;
          Inc(idx);
          while idx^ = ' ' do
            Inc(idx);
          if idx^ < ' ' then
          begin
          // terminate
            MainFinish := tmp - 1;
            Break;
          end;
          if idx^ = '|' then
          begin
          // terminate
            MainFinish := tmp - 1;
            Inc(idx);
            Break;
          end;
          Continue;
        end;
      #0..#31:
        begin
        // control terminates
          MainFinish := idx - 1;
          Break;
        end;
      '|':
        begin
        // at the end
          MainFinish := idx - 1;
          Inc(idx);
          break;
        end;
      '*':
        begin
          if ExtnStart <> nil then
            Inc(xwildall)
          else
            Inc(mwildall);
        end;
    end;
    Inc(idx);
  end;
  // was there an extension?
  if ExtnStart <> nil then
  begin
    Result := Result or HAD_DOT;
    if ExtnStart <= MainFinish then
    begin
      // we have extn
      ExtnFinish := MainFinish;
      MainFinish := ExtnStart - 2;
      parts.Extnlen := 1 + (ExtnFinish - ExtnStart);
      Result := Result or EXTN;
      if xwildall <> 0 then
      begin
        if xwildall = parts.Extnlen then
          Result := Result or EXTN_WILDALL;
        Result := Result or EXTN_HASWILD;
      end;
    end
    else
    begin
      // dot but no extn
      ExtnStart := nil;
      Dec(MainFinish); // before dot
    end;
  end;

  parts.Mainlen := 1 + (MainFinish - MainStart);
  if parts.Mainlen > 0 then
  begin
    Result := Result or MAIN;
    if mwildall <> 0 then
    begin
      if mwildall = parts.Mainlen then
        Result := Result or MAIN_WILDALL;
      Result := Result or MAIN_HASWILD;
    end;
  end;
  // set resulting pointers
  parts.Main.Start := MainStart;
  parts.Main.Finish := MainFinish;
  parts.Extn.Start := ExtnStart;
  parts.Extn.Finish := ExtnFinish;
end;

function FileRCmp(var Bp, Bs: TBounds): Integer;
var
  cp: Char;
  cs: Char;
begin
  Result := 1; // no match
  if (Bs.Start > Bs.Finish) then
    exit;
  if (Bp.Start^ <> Bs.Start^) and ((Bp.Start^ = '\') or (Bp.Start^ <> '?')) then
    exit; // cannot match
  Inc(Bs.Start);
  Inc(Bp.Start);
  while (Bs.Start <= Bs.Finish) and (Bp.Start <= Bp.Finish) do
  begin
    cp := Bp.Finish^;
    cs := Bs.Finish^;
    Dec(Bp.Finish);
    Dec(Bs.Finish);
    if cp <> cs then
    begin
      // must not match path sep
      if (cp <> '?') or (cs = '\') then
        Exit; // no match
    end;
  end;
  Result := 0; // match
end;

function UpperFileNameMatch(const Pattern, Spec: string): Boolean;
const
  FULL_WILD = MAIN_WILDALL or EXTN_WILDALL;
var
  ch: Char;
  pFlag: Integer;
  pidx: PChar;
  ptn: TParts;
  sFlag: Integer;
  sidx: PChar;
  spc: TParts;
  spc1: TParts;
  SpecStt: PChar;
  xres: Integer;
begin
  Result := False;
  // check the spec if has extension
  SpecStt := PChar(Spec);
  sidx := SpecStt;
  while sidx^ <= ' ' do
  begin
    if sidx^ = #0 then
      exit;
    Inc(sidx);
  end;
  sFlag := Decompose(sidx, spc);
  // now start processing each pattern
  pidx := PChar(Pattern);
  repeat
    ch := pidx^;
    // skip garbage or separator
    while (ch <= ' ') or (ch = '|') do
    begin
      if ch = #0 then
        exit;
      Inc(pidx);
      ch := pidx^;
    end;
    pFlag := Decompose(pidx, ptn);
    // work out what we must test
    if ((pFlag and FULL_WILD) = FULL_WILD) or
      ((pFlag and (FULL_WILD or EXTN or HAD_DOT)) = MAIN_WILDALL) then
    begin
      Result := True;
      Break;
    end;
    if ((pFlag and (EXTN_HASWILD or EXTN)) = EXTN) and (spc.ExtnLen <> ptn.ExtnLen) then
      Continue; // cannot match
    if ((pFlag and MAIN_HASWILD) = 0) and (spc.MainLen <> ptn.MainLen) then
      Continue; // cannot match
    xres := -1; // not tried to match
    // make copy of spc
    Move(spc, spc1, SizeOf(TParts));
    if (pFlag and EXTN_WILDALL) <> 0 then
      xres := 0 // ignore extn as matched
    else
    begin
      // if pattern has extn, we must 'split' spec
      if (pFlag and HAD_DOT) <> 0 then
      begin
        // check special cases
        if (pFlag and EXTN) = 0 then
        begin
          // pattern ended in dot - spec must not have extn
          if (sFlag and EXTN) <> 0 then
            Continue; // spec has extn - cannot match
          xres := 0; // no extn to check
        end
        else
        begin
          // spec must have extn
          if (sFlag and EXTN) = 0 then
            Continue; // no spec extn - cannot match
        end;
      end
      else
      begin
        // no Pattern dot _ test full spec
        if ((sFlag and EXTN) <> 0) then
          spc1.Main.Finish := spc.Extn.Finish; // full spec
        xres := 0; // only test spec
      end;

      // test extn first (if required)
      if xres < 0 then
        xres := WildCmp(ptn.Extn, spc1.Extn);
    end;
    // if extn matched test main part
    if xres = 0 then
    begin
      if (pFlag and MAIN_WILDALL) = 0 then
      begin
        if (pFlag and MAIN_HASWILD) <> 0 then
          xres := WildCmp(ptn.Main, spc1.Main)
        else
          xres := FileRCmp(ptn.Main, spc1.Main);
      end;
    end;
    // equate
    Result := xres = 0;
    // at next pattern
  until Result;
end;

function FileNameMatch(const UPattern, USpec: string): Boolean;
var
  Pattern: string;
  Spec: string;
begin
  Pattern := UpperCase(UPattern);
  Spec := UpperCase(USpec);
  Result := UpperFileNameMatch(Pattern, Spec);
end;

end.
