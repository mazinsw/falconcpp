unit SearchEngine;

interface

uses
  Classes, DScintilla, DScintillaTypes, RegularExpressionsCore;

type
  TSearchEngine = class(TComponent)
  private
    FEditor: TDScintilla;
    FRegEx: TPerlRegEx;
    FFlags: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetSearchFlags(Flags: Integer);
    procedure SetTargetStart(Position: Integer);
    procedure SetTargetEnd(Position: Integer);
    function SearchInTarget(const Text: UnicodeString): Integer;
    function GetTargetEnd: Integer;
    property Editor: TDScintilla read FEditor write FEditor;
  end;

implementation

{ TSearchEngine }

{ TSearchEngine }

constructor TSearchEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRegEx := TPerlRegEx.Create;
end;

destructor TSearchEngine.Destroy;
begin
  FRegEx.Free;
  inherited;
end;

function TSearchEngine.GetTargetEnd: Integer;
begin
  Result := FEditor.GetTargetEnd;
end;

function TSearchEngine.SearchInTarget(const Text: UnicodeString): Integer;
begin
  if (FFlags and SCFIND_REGEXP) = SCFIND_REGEXP then
  begin
    FRegEx.RegEx := UTF8String(Text);
    FRegEx.Stop := FEditor.GetTargetEnd;
    FRegEx.Subject := PAnsiChar(FEditor.GetCharacterPointer) + FEditor.GetTargetStart;
    try
      if FRegEx.Match then
      begin
        Result := FEditor.GetTargetStart + FRegEx.MatchedOffset - 1;
        FEditor.SetTargetEnd(Result + FRegEx.MatchedLength);
      end
      else
        Result := -1;
    except
      Result := -1;
    end;
  end
  else
    Result := FEditor.SearchInTarget(Text);
end;

procedure TSearchEngine.SetSearchFlags(Flags: Integer);
begin
  FFlags := Flags;
  FEditor.SetSearchFlags(Flags);
end;

procedure TSearchEngine.SetTargetEnd(Position: Integer);
begin
  FEditor.SetTargetEnd(Position);
end;

procedure TSearchEngine.SetTargetStart(Position: Integer);
begin
  FEditor.SetTargetStart(Position);
end;

end.
