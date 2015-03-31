unit AutoComplete;

interface

uses
  Windows,
  Menus,
  Classes,
  UEditor;

type
  TAutoComplete = class(TComponent)
  protected
    fAutoCompleteList: TStrings;
    fCompletions: TStrings;
    fCompletionComments: TStrings;
    fCompletionValues: TStrings;
    fEOTokenChars: string;
    fCaseSensitive: boolean;
    fParsed: boolean;
    procedure CompletionListChanged(Sender: TObject);
    function GetCompletions: TStrings;
    function GetCompletionComments: TStrings;
    function GetCompletionValues: TStrings;
    procedure SetAutoCompleteList(Value: TStrings); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddCompletion(const AToken, AValue, AComment: string);
    procedure Execute(AEditor: TEditor); virtual;
    procedure ExecuteCompletion(const AToken: string;
      AEditor: TEditor); virtual;
    procedure ParseCompletionList; virtual;
  public
    property AutoCompleteList: TStrings read fAutoCompleteList
      write SetAutoCompleteList;
    property CaseSensitive: boolean read fCaseSensitive write fCaseSensitive;
    property Completions: TStrings read GetCompletions;
    property CompletionComments: TStrings read GetCompletionComments;
    property CompletionValues: TStrings read GetCompletionValues;
    property EndOfTokenChr: string read fEOTokenChars write fEOTokenChars;
  end;

  TSynAutoCompleteTemplate = class(TAutoComplete)
  published
    property AutoCompleteList;
    property CaseSensitive;
    property EndOfTokenChr;
  end;

implementation

uses
  SysUtils;

{ TAutoComplete }

procedure TAutoComplete.AddCompletion(const AToken, AValue, AComment: string);
begin
  if AToken <> '' then
  begin
    if (fAutoCompleteList.Count = 0) and (fCompletions.Count = 0) then
      fParsed := True;
    fCompletions.Add(AToken);
    fCompletionComments.Add(AComment);
    fCompletionValues.Add(AValue);
  end;
end;

procedure TAutoComplete.CompletionListChanged(Sender: TObject);
begin
  fParsed := FALSE;
end;

constructor TAutoComplete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fAutoCompleteList := TStringList.Create;
  TStringList(fAutoCompleteList).OnChange := CompletionListChanged;
  fCompletions := TStringList.Create;
  fCompletionComments := TStringList.Create;
  fCompletionValues := TStringList.Create;
  fEOTokenChars := '()[]{}.';
end;

destructor TAutoComplete.Destroy;
begin
  inherited Destroy;
  fCompletions.Free;
  fCompletionComments.Free;
  fCompletionValues.Free;
  fAutoCompleteList.Free;
end;

procedure TAutoComplete.Execute(AEditor: TEditor);
var
  s: string;
  i, j: integer;
begin
  if AEditor <> nil then
  begin
    // get token
    s := AEditor.LineText;
    j := AEditor.CaretX;
    i := j - 1;
    if i <= Length(s) then
    begin
      while (i > 0) and (s[i] > ' ') and (Pos(s[i], fEOTokenChars) = 0) do
        Dec(i);
      Inc(i);
      s := Copy(s, i, j - i);
      ExecuteCompletion(s, AEditor);
    end;
  end;
end;

procedure TAutoComplete.ExecuteCompletion(const AToken: string;
  AEditor: TEditor);
var
  i, j, Len, IndentLen: integer;
  s: string;
  ptr, iptr: PChar;
  IdxMaybe, NumMaybe: integer;
  p: TBufferCoord;
  NewCaretPos, PipeFind: boolean;
  Temp: TStringList;
begin
  if not fParsed then
    ParseCompletionList;
  Len := Length(AToken);
  if (Len > 0) and (AEditor <> nil) and not AEditor.ReadOnly and
    (fCompletions.Count > 0) then
  begin
    // find completion for this token - not all chars necessary if unambiguous
    i := fCompletions.Count - 1;
    IdxMaybe := -1;
    NumMaybe := 0;
    if fCaseSensitive then
    begin
      while i > -1 do
      begin
        s := fCompletions[i];
        if AnsiCompareStr(s, AToken) = 0 then
          break
        else if AnsiCompareStr(Copy(s, 1, Len), AToken) = 0 then
        begin
          Inc(NumMaybe);
          IdxMaybe := i;
        end;
        Dec(i);
      end;
    end
    else
    begin
      while i > -1 do
      begin
        s := fCompletions[i];
        if AnsiCompareText(s, AToken) = 0 then
          break
        else if AnsiCompareText(Copy(s, 1, Len), AToken) = 0 then
        begin
          Inc(NumMaybe);
          IdxMaybe := i;
        end;
        Dec(i);
      end;
    end;
    if (i = -1) and (NumMaybe = 1) then
      i := IdxMaybe;
    if i > -1 then
    begin
      // select token in editor
      p := AEditor.CaretXY;
      { begin }                                                                         // mh 2000-11-08
      AEditor.BeginUpdate;
      try
        AEditor.BlockBegin := BufferCoord(p.Char - Len, p.Line);
        AEditor.BlockEnd := p;
        // indent the completion string if necessary, determine the caret pos
        IndentLen := 0;
        s := AEditor.Lines[p.Line - 1];
        ptr := PChar(s);
        if Assigned(ptr) and (ptr^ <> #0) then
          repeat
            if not CharInSet(ptr^, [#9, #32]) then
              break;
            if ptr^ = #9 then
              Inc(IndentLen, AEditor.TabWidth)
            else
              Inc(IndentLen);
            Inc(ptr);
          until ptr^ = #0;
        p := AEditor.BlockBegin;
        NewCaretPos := FALSE;
        Temp := TStringList.Create;
        try
          Temp.Text := fCompletionValues[i];
          // indent lines
          if (IndentLen > 0) and (Temp.Count > 1) then
          begin
            if AEditor.WantTabs then
              s := StringOfChar(#9, IndentLen div AEditor.TabWidth) +
                StringOfChar(' ', IndentLen mod AEditor.TabWidth)
            else
              s := StringOfChar(' ', IndentLen);
            for i := 1 to Temp.Count - 1 do
              Temp[i] := s + Temp[i];
          end;
          // find first '|' and use it as caret position
          PipeFind := FALSE;
          j := 0;
          for i := 0 to Temp.Count - 1 do
          begin
            s := Temp[i];
            IndentLen := 0;
            ptr := PChar(s);
            iptr := ptr;
            if Assigned(ptr) and (ptr^ <> #0) then
              repeat
                if not CharInSet(ptr^, [#9, #32]) then
                  break;
                if ptr^ = #9 then
                  Inc(IndentLen, AEditor.TabWidth)
                else
                  Inc(IndentLen);
                Inc(ptr);
              until ptr^ = #0;
            if not PipeFind then
              j := Pos('|', s);
            if (IndentLen >= AEditor.TabWidth) and (ptr - iptr <= IndentLen)
            then
            begin
              s := StringOfChar(#9, IndentLen div AEditor.TabWidth) +
                StringOfChar(' ', IndentLen mod AEditor.TabWidth) + StrPas(ptr);
              if (j > 0) and not PipeFind then
                j := Pos('|', s)
              else
                Temp[i] := s;
            end;
            if (j > 0) and not PipeFind then
            begin
              Delete(s, j, 1);
              Temp[i] := s;
              // if j > 1 then
              // Dec(j);
              NewCaretPos := True;
              Inc(p.Line, i);
              if i = 0 then
                // Inc(p.x, j)
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
      { end }                                                                           // mh 2000-11-08
    end;
  end;
end;

function TAutoComplete.GetCompletions: TStrings;
begin
  if not fParsed then
    ParseCompletionList;
  Result := fCompletions;
end;

function TAutoComplete.GetCompletionComments: TStrings;
begin
  if not fParsed then
    ParseCompletionList;
  Result := fCompletionComments;
end;

function TAutoComplete.GetCompletionValues: TStrings;
begin
  if not fParsed then
    ParseCompletionList;
  Result := fCompletionValues;
end;

procedure TAutoComplete.ParseCompletionList;
var
  BorlandDCI: boolean;
  i, j, Len: integer;
  s, sCompl, sComment, sComplValue: string;

  procedure SaveEntry;
  begin
    fCompletions.Add(sCompl);
    sCompl := '';
    fCompletionComments.Add(sComment);
    sComment := '';
    fCompletionValues.Add(sComplValue);
    sComplValue := '';
  end;

begin
  fCompletions.Clear;
  fCompletionComments.Clear;
  fCompletionValues.Clear;

  if fAutoCompleteList.Count > 0 then
  begin
    s := fAutoCompleteList[0];
    BorlandDCI := (s <> '') and (s[1] = '[');

    sCompl := '';
    sComment := '';
    sComplValue := '';
    for i := 0 to fAutoCompleteList.Count - 1 do
    begin
      s := fAutoCompleteList[i];
      Len := Length(s);
      if BorlandDCI then
      begin
        // the style of the Delphi32.dci file
        if (Len > 0) and (s[1] = '[') then
        begin
          // save last entry
          if sCompl <> '' then
            SaveEntry;
          // new completion entry
          j := 2;
          while (j <= Len) and (s[j] > ' ') do
            Inc(j);
          sCompl := Copy(s, 2, j - 2);
          // start of comment in DCI file
          while (j <= Len) and (s[j] <= ' ') do
            Inc(j);
          if (j <= Len) and (s[j] = '|') then
            Inc(j);
          while (j <= Len) and (s[j] <= ' ') do
            Inc(j);
          sComment := Copy(s, j, Len);
          if sComment[Length(sComment)] = ']' then
            SetLength(sComment, Length(sComment) - 1);
        end
        else
        begin
          if sComplValue <> '' then
            sComplValue := sComplValue + #13#10;
          sComplValue := sComplValue + s;
        end;
      end
      else
      begin
        // the original style
        if (Len > 0) and (s[1] <> '=') then
        begin
          // save last entry
          if sCompl <> '' then
            SaveEntry;
          // new completion entry
          sCompl := s;
        end
        else if (Len > 0) and (s[1] = '=') then
        begin
          if sComplValue <> '' then
            sComplValue := sComplValue + #13#10;
          sComplValue := sComplValue + Copy(s, 2, Len);
        end;
      end;
    end;
    if sCompl <> '' then // mg 2000-11-07
      SaveEntry;
  end;
  fParsed := True;
end;

procedure TAutoComplete.SetAutoCompleteList(Value: TStrings);
begin
  fAutoCompleteList.Assign(Value);
  fParsed := FALSE;
end;

end.
