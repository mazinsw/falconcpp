{**************************************************************************************************}
{                                                                                                  }
{ Perl Regular Expressions VCL component                                                           }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is PerlRegEx.pas.                                                              }
{                                                                                                  }
{ The Initial Developer of the Original Code is Jan Goyvaerts.                                     }
{ Portions created by Jan Goyvaerts are Copyright (C) 1999, 2005, 2008, 2010  Jan Goyvaerts.       }
{ All rights reserved.                                                                             }
{                                                                                                  }
{ Design & implementation, by Jan Goyvaerts, 1999, 2005, 2008, 2010                                }
{                                                                                                  }
{ TRegEx is available at http://www.regular-expressions.info/delphi.html                       }
{                                                                                                  }
{**************************************************************************************************}

unit RegEx;

interface

uses
  Windows, Messages, SysUtils, Classes,
  pcre;

type
  TRegExOptions = set of (
    reCaseLess,       // /i -> Case insensitive
    reMultiLine,      // /m -> ^ and $ also match before/after a newline, not just at the beginning and the end of the string
    reSingleLine,     // /s -> Dot matches any character, including \n (newline). Otherwise, it matches anything except \n
    reExtended,       // /x -> Allow regex to contain extra whitespace, newlines and Perl-style comments, all of which will be filtered out
    reAnchored,       // /A -> Successful match can only occur at the start of the subject or right after the previous match
    reUnGreedy,       // Repeat operators (+, *, ?) are not greedy by default (i.e. they try to match the minimum number of characters instead of the maximum)
    reNoAutoCapture   // (group) is a non-capturing group; only named groups capture
  );

type
  TRegExState = set of (
    reNotBOL,         // Not Beginning Of Line: ^ does not match at the start of Subject
    reNotEOL,         // Not End Of Line: $ does not match at the end of Subject
    reNotEmpty        // Empty matches not allowed
  );

const
  // Maximum number of subexpressions (backreferences)
  // Subexpressions are created by placing round brackets in the regex, and are referenced by \1, \2, ...
  // In Perl, they are available as $1, $2, ... after the regex matched; with TRegEx, use the Subexpressions property
  // You can also insert \1, \2, ... in the replacement string; \0 is the complete matched expression
  MAX_SUBEXPRESSIONS = 99;

{$IFDEF UNICODE}
// All implicit string casts have been verified to be correct
{$WARN IMPLICIT_STRING_CAST OFF}
// Use UTF-8 in Delphi 2009 and later, so Unicode strings are handled correctly.
// PCRE does not support UTF-16
type
  PCREString = UTF8String;
{$ELSE UNICODE}
// Use AnsiString in Delphi 2007 and earlier
type
  PCREString = AnsiString;
{$ENDIF UNICODE}
type
  PPCREString = PAnsiChar;

type
  TRegExReplaceEvent = procedure(Sender: TObject; var ReplaceWith: PCREString) of object;

type
  TRegEx = class
  private    // *** Property storage, getters and setters
    FCompiled, FStudied: Boolean;
    FOptions: TRegExOptions;
    FState: TRegExState;
    FRegEx, FReplacement: PCREString;
    FSubjectLength: Integer;
    FSubject: PPCREString;
    FStart, FStop: Integer;
    FOnMatch: TNotifyEvent;
    FOnReplace: TRegExReplaceEvent;
    function GetMatchedText: PCREString;
    function GetMatchedLength: Integer;
    function GetMatchedOffset: Integer;
    procedure SetOptions(Value: TRegExOptions);
    procedure SetRegEx(const Value: PCREString);
    function GetGroupCount: Integer;
    function GetGroups(Index: Integer): PCREString;
    function GetGroupLengths(Index: Integer): Integer;
    function GetGroupOffsets(Index: Integer): Integer;
    procedure SetSubject(const Value: PPCREString);
    procedure SetStart(const Value: Integer);
    procedure SetStop(const Value: Integer);
    function GetFoundMatch: Boolean;
    function CopySubject(const subject: PPCREString; Index, Count: Integer): PCREString;
  private    // *** Variables used by PCRE
    Offsets: array[0..(MAX_SUBEXPRESSIONS+1)*3] of Integer;
    OffsetCount: Integer;
    pcreOptions: Integer;
    pattern, hints, chartable: Pointer;
    FSubjectPChar: PAnsiChar;
    FHasStoredGroups: Boolean;
    FStoredGroups: array of PCREString;
    function GetSubjectLeft: PCREString;
    function GetSubjectRight: PCREString;
  protected
    procedure CleanUp;
        // Dispose off whatever we created, so we can start over. Called automatically when needed, so it is not made public
    procedure ClearStoredGroups;
  public
    constructor Create;
        // Come to life
    destructor Destroy; override;
        // Clean up after ourselves
    class function EscapeRegExChars(const S: string): string;
        // Escapes regex characters in S so that the regex engine can be used to match S as plain text
    procedure Compile;
        // Compile the regex. Called automatically by Match
    procedure Study;
        // Study the regex. Studying takes time, but will make the execution of the regex a lot faster.
        // Call study if you will be using the same regex many times
    function Match: Boolean;
        // Attempt to match the regex, starting the attempt from the beginning of Subject
    function MatchAgain: Boolean;
        // Repeat MatchAgain and Replace until you drop.  Returns True if anything was replaced at all.
    function ComputeReplacement: PCREString;
        // Returns Replacement with backreferences filled in
    procedure StoreGroups;
        // Stores duplicates of Groups[] so they and ComputeReplacement will still return the proper strings
        // even if FSubject is changed or cleared
    function NamedGroup(const Name: PCREString): Integer;
        // Split Subject along regex matches.  Capturing groups are added to Strings as well.
    property Compiled: Boolean read FCompiled;
        // True if the RegEx has already been compiled.
    property FoundMatch: Boolean read GetFoundMatch;
        // Returns True when Matched* and Group* indicate a match
    property Studied: Boolean read FStudied;
        // True if the RegEx has already been studied
    property MatchedText: PCREString read GetMatchedText;
        // The matched text
    property MatchedLength: Integer read GetMatchedLength;
        // Length of the matched text
    property MatchedOffset: Integer read GetMatchedOffset;
        // Character offset in the Subject string at which MatchedText starts
    property Start: Integer read FStart write SetStart;
        // Starting position in Subject from which MatchAgain begins
    property Stop: Integer read FStop write SetStop;
        // Last character in Subject that Match and MatchAgain search through
    property State: TRegExState read FState write FState;
        // State of Subject
    property GroupCount: Integer read GetGroupCount;
        // Number of matched capturing groups
    property Groups[Index: Integer]: PCREString read GetGroups;
        // Text matched by capturing groups
    property GroupLengths[Index: Integer]: Integer read GetGroupLengths;
        // Lengths of the text matched by capturing groups
    property GroupOffsets[Index: Integer]: Integer read GetGroupOffsets;
    property SubjectLength: Integer read FSubjectLength write FSubjectLength;
        // Character offsets in Subject at which the capturing group matches start
    property Subject: PPCREString read FSubject write SetSubject;
        // The string on which Match() will try to match RegEx
    property SubjectLeft: PCREString read GetSubjectLeft;
        // Part of the subject to the left of the match
    property SubjectRight: PCREString read GetSubjectRight;
        // Part of the subject to the right of the match
  public
    property Options: TRegExOptions read FOptions write SetOptions;
        // Options
    property RegEx: PCREString read FRegEx write SetRegEx;
        // The regular expression to be matched
    property Replacement: PCREString read FReplacement write FReplacement;
        // Text to replace matched expression with. \number and $number backreferences will be substituted with Groups
        // TRegEx supports the "JGsoft" replacement text flavor as explained at http://www.regular-expressions.info/refreplace.html
    property OnMatch: TNotifyEvent read FOnMatch write FOnMatch;
        // Triggered by Match and MatchAgain after a successful match
    property OnReplace: TRegExReplaceEvent read FOnReplace write FOnReplace;
        // Triggered by Replace and ReplaceAll just before the replacement is done, allowing you to determine the new PCREString
  end;

implementation


         { ********* Unit support routines ********* }

function FirstCap(const S: string): string;
begin
  if S = '' then Result := ''
  else begin
    Result := AnsiLowerCase(S);
  {$IFDEF UNICODE}
    CharUpperBuffW(@Result[1], 1);
  {$ELSE}
    CharUpperBuffA(@Result[1], 1);
  {$ENDIF}
  end
end;

function InitialCaps(const S: string): string;
var
  I: Integer;
  Up: Boolean;
begin
  Result := AnsiLowerCase(S);
  Up := True;
{$IFDEF UNICODE}
  for I := 1 to Length(Result) do begin
    case Result[I] of
      #0..'&', '(', '*', '+', ',', '-', '.', '?', '<', '[', '{', #$00B7:
        Up := True
      else
        if Up and (Result[I] <> '''') then begin
          CharUpperBuffW(@Result[I], 1);
          Up := False
        end
    end;
  end;
{$ELSE UNICODE}
  if SysLocale.FarEast then begin
    I := 1;
    while I <= Length(Result) do begin
      if Result[I] in LeadBytes then begin
        Inc(I, 2)
      end
      else begin
        if Result[I] in [#0..'&', '('..'.', '?', '<', '[', '{'] then Up := True
        else if Up and (Result[I] <> '''') then begin
          CharUpperBuffA(@Result[I], 1);
          Result[I] := UpperCase(Result[I])[1];
          Up := False
        end;
        Inc(I)
      end
    end
  end
  else
    for I := 1 to Length(Result) do begin
      if Result[I] in [#0..'&', '('..'.', '?', '<', '[', '{', #$B7] then Up := True
      else if Up and (Result[I] <> '''') then begin
        CharUpperBuffA(@Result[I], 1);
        Result[I] := AnsiUpperCase(Result[I])[1];
        Up := False
      end
    end;
{$ENDIF UNICODE}
end;


         { ********* TRegEx component ********* }

procedure TRegEx.CleanUp;
begin
  FCompiled := False; FStudied := False;
  pcre_dispose(pattern, hints, nil);
  pattern := nil;
  hints := nil;
  ClearStoredGroups;
  OffsetCount := 0;
end;

procedure TRegEx.ClearStoredGroups;
begin
  FHasStoredGroups := False;
  FStoredGroups := nil;
end;

procedure TRegEx.Compile;
var
  Error: PAnsiChar;
  ErrorOffset: Integer;
begin
  if FRegEx = '' then
    raise Exception.Create('TRegEx.Compile() - Please specify a regular expression in RegEx first');
  CleanUp;
  Pattern := pcre_compile(PAnsiChar(FRegEx), pcreOptions, @Error, @ErrorOffset, chartable);
  if Pattern = nil then
    raise Exception.Create(Format('TRegEx.Compile() - Error in regex at offset %d: %s', [ErrorOffset, AnsiString(Error)]));
  FCompiled := True
end;

(* Backreference overview:

Assume there are 13 backreferences:

Text        TRegex    .NET      Java       ECMAScript
$17         $1 + "7"      "$17"     $1 + "7"   $1 + "7"
$017        $1 + "7"      "$017"    $1 + "7"   $1 + "7"
$12         $12           $12       $12        $12
$012        $1 + "2"      $12       $12        $1 + "2"
${1}2       $1 + "2"      $1 + "2"  error      "${1}2"
$$          "$"           "$"       error      "$"
\$          "$"           "\$"      "$"        "\$"
*)

function TRegEx.ComputeReplacement: PCREString;
var
  Mode: AnsiChar;
  S: PCREString;
  I, J, N: Integer;

  procedure ReplaceBackreference(Number: Integer);
  var
    Backreference: PCREString;
  begin
    Delete(S, I, J-I);
    if Number <= GroupCount then begin
      Backreference := Groups[Number];
      if Backreference <> '' then begin
        // Ignore warnings; converting to UTF-8 does not cause data loss
        case Mode of
          'L', 'l': Backreference := AnsiLowerCase(Backreference);
          'U', 'u': Backreference := AnsiUpperCase(Backreference);
          'F', 'f': Backreference := FirstCap(Backreference);
          'I', 'i': Backreference := InitialCaps(Backreference);
        end;
        if S <> '' then begin
          Insert(Backreference, S, I);
          I := I + Length(Backreference);
        end
        else begin
          S := Backreference;
          I := MaxInt;
        end
      end;
    end
  end;

  procedure ProcessBackreference(NumberOnly, Dollar: Boolean);
  var
    Number, Number2: Integer;
    Group: PCREString;
  begin
    Number := -1;
    if (J <= Length(S)) and (S[J] in ['0'..'9']) then begin
      // Get the number of the backreference
      Number := Ord(S[J]) - Ord('0');
      Inc(J);
      if (J <= Length(S)) and (S[J] in ['0'..'9']) then begin
        // Expand it to two digits only if that would lead to a valid backreference
        Number2 := Number*10 + Ord(S[J]) - Ord('0');
        if Number2 <= GroupCount then begin
          Number := Number2;
          Inc(J)
        end;
      end;
    end
    else if not NumberOnly then begin
      if Dollar and (J < Length(S)) and (S[J] = '{') then begin
        // Number or name in curly braces
        Inc(J);
        case S[J] of
          '0'..'9': begin
            Number := Ord(S[J]) - Ord('0');
            Inc(J);
            while (J <= Length(S)) and (S[J] in ['0'..'9']) do begin
              Number := Number*10 + Ord(S[J]) - Ord('0');
              Inc(J)
            end;
          end;
          'A'..'Z', 'a'..'z', '_': begin
            Inc(J);
            while (J <= Length(S)) and (S[J] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) do Inc(J);
            if (J <= Length(S)) and (S[J] = '}') then begin
              Group := Copy(S, I+2, J-I-2);
              Number := NamedGroup(Group);
            end
          end;
        end;
        if (J > Length(S)) or (S[J] <> '}') then Number := -1
          else Inc(J)
      end
      else if Dollar and (S[J] = '_') then begin
        // $_ (whole subject)
        Delete(S, I, J+1-I);
        Insert(CopySubject(Subject, 1, SubjectLength), S, I);
        I := I + SubjectLength;
        Exit;
      end
      else case S[J] of
        '&': begin
          // \& or $& (whole regex match)
          Number := 0;
          Inc(J);
        end;
        '+': begin
          // \+ or $+ (highest-numbered participating group)
          Number := GroupCount;
          Inc(J);
        end;
        '`': begin
          // \` or $` (backtick; subject to the left of the match)
          Delete(S, I, J+1-I);
          Insert(SubjectLeft, S, I);
          I := I + Offsets[0] - 1;
          Exit;
        end;
        '''': begin
          // \' or $' (straight quote; subject to the right of the match)
          Delete(S, I, J+1-I);
          Insert(SubjectRight, S, I);
          I := I + SubjectLength - Offsets[1];
          Exit;
        end
      end;
    end;
    if Number >= 0 then ReplaceBackreference(Number)
      else Inc(I)
  end;

begin
  S := FReplacement;
  I := 1;
  while I < Length(S) do begin
    case S[I] of
      '\': begin
        J := I + 1;
        Assert(J <= Length(S), 'CHECK: We let I stop one character before the end, so J cannot point beyond the end of the PCREString here');
        case S[J] of
          '$', '\': begin
            Delete(S, I, 1);
            Inc(I);
          end;
          'g': begin
            if (J < Length(S)-1) and (S[J+1] = '<') and (S[J+2] in ['A'..'Z', 'a'..'z', '_']) then begin
              // Python-style named group reference \g<name>
              J := J+3;
              while (J <= Length(S)) and (S[J] in ['0'..'9', 'A'..'Z', 'a'..'z', '_']) do Inc(J);
              if (J <= Length(S)) and (S[J] = '>') then begin
                N := NamedGroup(Copy(S, I+3, J-I-3));
                Inc(J);
                Mode := #0;
                if N > 0 then ReplaceBackreference(N)
                  else Delete(S, I, J-I)
              end
              else I := J
            end
            else I := I+2;
          end;
          'l', 'L', 'u', 'U', 'f', 'F', 'i', 'I': begin
            Mode := S[J];
            Inc(J);
            ProcessBackreference(True, False);
          end;
          else begin
            Mode := #0;
            ProcessBackreference(False, False);
          end;
        end;
      end;
      '$': begin
        J := I + 1;
        Assert(J <= Length(S), 'CHECK: We let I stop one character before the end, so J cannot point beyond the end of the PCREString here');
        if S[J] = '$' then begin
          Delete(S, J, 1);
          Inc(I);
        end
        else begin
          Mode := #0;
          ProcessBackreference(False, True);
        end
      end;
      else Inc(I)
    end
  end;
  Result := S
end;

function TRegEx.CopySubject(const subject: PPCREString; Index,
  Count: Integer): PCREString;
var
  buf: array of AnsiChar;
  ptr: PPCREString;
begin
  ptr := subject + (Index - 1);
  SetLength(buf, Count + 1);
  Move(ptr, buf, Count);
  buf[Count] := #0;
  Result := PAnsiChar(buf);
end;

constructor TRegEx.Create;
begin
  inherited Create;
  FState := [reNotEmpty];
  chartable := pcre_maketables;
{$IFDEF UNICODE}
  pcreOptions := PCRE_UTF8 or PCRE_NEWLINE_ANY;
{$ELSE}
  pcreOptions := PCRE_NEWLINE_ANY;
{$ENDIF}
end;

destructor TRegEx.Destroy;
begin
  pcre_dispose(pattern, hints, chartable);
  inherited Destroy;
end;

class function TRegEx.EscapeRegExChars(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  I := Length(Result);
  while I > 0 do begin
    case Result[I] of
      '.', '[', ']', '(', ')', '?', '*', '+', '{', '}', '^', '$', '|', '\':
        Insert('\', Result, I);
      #0: begin
        Result[I] := '0';
        Insert('\', Result, I);
      end;
    end;
    Dec(I);
  end;
end;

function TRegEx.GetFoundMatch: Boolean;
begin
  Result := OffsetCount > 0;
end;

function TRegEx.GetMatchedText: PCREString;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  Result := GetGroups(0);
end;

function TRegEx.GetMatchedLength: Integer;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  Result := GetGroupLengths(0)
end;

function TRegEx.GetMatchedOffset: Integer;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  Result := GetGroupOffsets(0)
end;

function TRegEx.GetGroupCount: Integer;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  Result := OffsetCount-1
end;

function TRegEx.GetGroupLengths(Index: Integer): Integer;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  Assert((Index >= 0) and (Index <= GroupCount), 'REQUIRE: Index <= GroupCount');
  Result := Offsets[Index*2+1]-Offsets[Index*2]
end;

function TRegEx.GetGroupOffsets(Index: Integer): Integer;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  Assert((Index >= 0) and (Index <= GroupCount), 'REQUIRE: Index <= GroupCount');
  Result := Offsets[Index*2]
end;

function TRegEx.GetGroups(Index: Integer): PCREString;
begin
  Assert(FoundMatch, 'REQUIRE: There must be a successful match first');
  if Index > GroupCount then Result := ''
    else if FHasStoredGroups then Result := FStoredGroups[Index]
    else Result := CopySubject(FSubject, Offsets[Index*2], Offsets[Index*2+1]-Offsets[Index*2]);
end;

function TRegEx.GetSubjectLeft: PCREString;
begin
  Result := CopySubject(Subject, 1, Offsets[0]-1);
end;

function TRegEx.GetSubjectRight: PCREString;
begin
  Result := CopySubject(Subject, Offsets[1], MaxInt);
end;

function TRegEx.Match: Boolean;
var
  I, Opts: Integer;
begin
  ClearStoredGroups;
  if not Compiled then Compile;
  if reNotBOL in State then Opts := PCRE_NOTBOL else Opts := 0;
  if reNotEOL in State then Opts := Opts or PCRE_NOTEOL;
  if reNotEmpty in State then Opts := Opts or PCRE_NOTEMPTY;
  OffsetCount := pcre_exec(Pattern, Hints, FSubjectPChar, FStop, 0, Opts, @Offsets[0], High(Offsets));
  Result := OffsetCount > 0;
  // Convert offsets into PCREString indices
  if Result then begin
    for I := 0 to OffsetCount*2-1 do
      Inc(Offsets[I]);
    FStart := Offsets[1];
    if Offsets[0] = Offsets[1] then Inc(FStart); // Make sure we don't get stuck at the same position
    if Assigned(OnMatch) then OnMatch(Self)
  end;
end;

function TRegEx.MatchAgain: Boolean;
var
  I, Opts: Integer;
begin
  ClearStoredGroups;
  if not Compiled then Compile;
  if reNotBOL in State then Opts := PCRE_NOTBOL else Opts := 0;
  if reNotEOL in State then Opts := Opts or PCRE_NOTEOL;
  if reNotEmpty in State then Opts := Opts or PCRE_NOTEMPTY;
  if FStart-1 > FStop then OffsetCount := -1
    else OffsetCount := pcre_exec(Pattern, Hints, FSubjectPChar, FStop, FStart-1, Opts, @Offsets[0], High(Offsets));
  Result := OffsetCount > 0;
  // Convert offsets into PCREString indices
  if Result then begin
    for I := 0 to OffsetCount*2-1 do
      Inc(Offsets[I]);
    FStart := Offsets[1];
    if Offsets[0] = Offsets[1] then Inc(FStart); // Make sure we don't get stuck at the same position
    if Assigned(OnMatch) then OnMatch(Self)
  end;
end;

function TRegEx.NamedGroup(const Name: PCREString): Integer;
begin
  Result := pcre_get_stringnumber(Pattern, PAnsiChar(Name));
end;

procedure TRegEx.SetOptions(Value: TRegExOptions);
begin
  if (FOptions <> Value) then begin
    FOptions := Value;
  {$IFDEF UNICODE}
    pcreOptions := PCRE_UTF8 or PCRE_NEWLINE_ANY;
  {$ELSE}
    pcreOptions := PCRE_NEWLINE_ANY;
  {$ENDIF}
    if (reCaseLess in Value) then pcreOptions := pcreOptions or PCRE_CASELESS;
    if (reMultiLine in Value) then pcreOptions := pcreOptions or PCRE_MULTILINE;
    if (reSingleLine in Value) then pcreOptions := pcreOptions or PCRE_DOTALL;
    if (reExtended in Value) then pcreOptions := pcreOptions or PCRE_EXTENDED;
    if (reAnchored in Value) then pcreOptions := pcreOptions or PCRE_ANCHORED;
    if (reUnGreedy in Value) then pcreOptions := pcreOptions or PCRE_UNGREEDY;
    if (reNoAutoCapture in Value) then pcreOptions := pcreOptions or PCRE_NO_AUTO_CAPTURE;
    CleanUp
  end
end;

procedure TRegEx.SetRegEx(const Value: PCREString);
begin
  if FRegEx <> Value then begin
    FRegEx := Value;
    CleanUp
  end
end;

procedure TRegEx.SetStart(const Value: Integer);
begin
  if Value < 1 then FStart := 1
  else FStart := Value;
  // If FStart > SubjectLength, MatchAgain() will simply return False
end;

procedure TRegEx.SetStop(const Value: Integer);
begin
  if Value > SubjectLength then FStop := SubjectLength
    else FStop := Value;
end;

procedure TRegEx.SetSubject(const Value: PPCREString);
begin
  FSubject := Value;
  FSubjectPChar := Value;
  FStart := 1;
  FStop := SubjectLength;
  if not FHasStoredGroups then OffsetCount := 0;
end;

procedure TRegEx.StoreGroups;
var
  I: Integer;
begin
  if OffsetCount > 0 then begin
    ClearStoredGroups;
    SetLength(FStoredGroups, GroupCount+1);
    for I := GroupCount downto 0 do
      FStoredGroups[I] := Groups[I];
    FHasStoredGroups := True;
  end
end;

procedure TRegEx.Study;
var
  Error: PAnsiChar;
begin
  if not FCompiled then Compile;
  Hints := pcre_study(Pattern, 0, @Error);
  if Error <> nil then
    raise Exception.Create('TRegEx.Study() - Error studying the regex: ' + AnsiString(Error));
  FStudied := True
end;

end.
