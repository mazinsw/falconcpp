unit Highlighter;

interface

uses
  Classes, Graphics, DScintillaTypes;

const
  HL_Style_Comment = 'Comment';
  HL_Style_LineComment = 'Line Comment';
  HL_Style_DocComment = 'Documentation Comment';
  HL_Style_Number = 'Number';
  HL_Style_TypeWord = 'Type Word';
  HL_Style_String = 'String';
  HL_Style_Character = 'Character';
  HL_Style_Preprocessor = 'Preprocessor';
  HL_Style_Symbol = 'Symbol';
  HL_Style_Identifier = 'Identifier';
  HL_Style_UnterminatedString = 'Unterminated String';
  HL_Style_LineDocComment = 'Line Documentation Comment';
  HL_Style_InstructionWord = 'Instruction Word';
  HL_Style_CommentKeyword = 'Comment Keyword';
  HL_Style_CommentKeywordError = 'Comment Keyword Error';
  HL_Style_PreprocessorComment = 'Preprocessor Comment';
  HL_Style_PreprocessorDocComment = 'Preprocessor Documentation Comment';
  HL_Style_Space = 'Space';

type
  THighlighStyle = class;
  TSetKeyWords = procedure(AKeywordSet: Integer; const AKeyWords: UnicodeString) of object;

  THighlighter = class(TComponent)
  private
    FStyles: TStringList;
    FHookList: TList;
    FUpdateCount: Integer;
    FUpdate: Boolean;
    procedure Changed(Sender: TObject);
    procedure ClearStyles;      
    procedure HighlightChanged(Sender: TObject);
    function GetStyle(Index: Integer): THighlighStyle;
    function GetStyleCount: Integer;
  protected
    procedure AddStyle(Style: THighlighStyle);
    function Add(ID: Integer; const Name: string; Foreground: TColor = clBlack;
      Style: TFontStyles = []): THighlighStyle;
    function GetLanguageName: string; virtual; abstract;
    function GetID: Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddHookChange(Event: TNotifyEvent);
    procedure RemoveHookChange(Event: TNotifyEvent);
    procedure BeginUpdate;
    procedure EndUpdate;                       
    procedure SetKeyWords(Callback: TSetKeyWords); virtual; abstract;
    function IsComment(Style: THighlighStyle): Boolean; virtual; abstract;
    function IsString(Style: THighlighStyle): Boolean; virtual; abstract;
    function FindStyle(const Name: string): THighlighStyle;
    function FindStyleByID(ID: Integer): THighlighStyle;
    property ID: Integer read GetID;
    property LanguageName: string read GetLanguageName;
    property StyleCount: Integer read GetStyleCount;
    property Style[Index: Integer]: THighlighStyle read GetStyle; default;
  end;

  THighlighStyle = class
  private
    FID: Integer;
    FName: string;
    FBackground: TColor;
    FForeground: TColor;
    FStyle: TFontStyles;
    FOnChange: TNotifyEvent;
    FHotspot: Boolean;
    procedure SetBackground(const Value: TColor);
    procedure SetForeground(const Value: TColor);
    procedure SetStyle(const Value: TFontStyles);
    procedure SetHotspot(const Value: Boolean);
  protected                
    procedure Changed;
  public
    constructor Create(ID: Integer; const Name: string);
    property ID: Integer read FID;
    property Name: string read FName;
    property Background: TColor read FBackground write SetBackground;
    property Foreground: TColor read FForeground write SetForeground;
    property Style: TFontStyles read FStyle write SetStyle;
    property Hotspot: Boolean read FHotspot write SetHotspot;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

uses
  SysUtils;

{ THighlighStyle }

procedure THighlighStyle.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor THighlighStyle.Create(ID: Integer; const Name: string);
begin
  FID := ID;
  FName := Name;
  FBackground := clNone;
  FForeground := clBlack;
  FStyle := [];
  FHotspot := False;
end;

procedure THighlighStyle.SetBackground(const Value: TColor);
begin
  if Value = FBackground then
    Exit;
  FBackground := Value;
  Changed;
end;

procedure THighlighStyle.SetForeground(const Value: TColor);
begin            
  if Value = FForeground then
    Exit;
  FForeground := Value;
  Changed;
end;

procedure THighlighStyle.SetHotspot(const Value: Boolean);
begin         
  if Value = FHotspot then
    Exit;
  FHotspot := Value;
  Changed;
end;

procedure THighlighStyle.SetStyle(const Value: TFontStyles);
begin
  if Value = FStyle then
    Exit;
  FStyle := Value;
  Changed;
end;

{ THighlighter }

function THighlighter.Add(ID: Integer; const Name: string;
  Foreground: TColor; Style: TFontStyles): THighlighStyle;
begin
  Result := THighlighStyle.Create(ID, Name);
  Result.FForeground := Foreground;
  Result.FStyle := Style;
  AddStyle(Result);
end;

procedure THighlighter.AddHookChange(Event: TNotifyEvent);
begin
  with FHookList, TMethod(Event) do
  begin
    Add(Code);
    Add(Data);
  end
end;

procedure THighlighter.AddStyle(Style: THighlighStyle);
var
  Search: THighlighStyle;
begin
  Search := FindStyle(Style.Name);
  if Search <> nil then
    raise Exception.CreateFmt('Style %s already added', [Style.Name]);
  FStyles.AddObject(Style.Name, Style);
  Style.OnChange := HighlightChanged;
end;

procedure THighlighter.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure THighlighter.Changed(Sender: TObject);
var
  AMethod: TMethod;
  I: Integer;
begin
  I := 0;
  with FHookList, AMethod do
    while I < Count do
      repeat
        Code := Items[I];
        Inc(I);
        Data := Items[I];
        Inc(I);
        TNotifyEvent(AMethod)(Sender);
      until I >= Count;
end;

procedure THighlighter.ClearStyles;
var
  I: Integer;
begin
  for I := 0 to FStyles.Count - 1 do
    FStyles.Objects[I].Free;
  FStyles.Clear;
end;

constructor THighlighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStyles := TStringList.Create;
  FHookList := TList.Create;
end;

destructor THighlighter.Destroy;
begin
  ClearStyles;
  FHookList.Free;
  FStyles.Free;
  inherited;
end;

procedure THighlighter.EndUpdate;
begin
  if FUpdateCount = 0 then
    Exit;
  Dec(FUpdateCount);
  if (FUpdateCount = 0) and FUpdate then
  begin
    FUpdate := False;
    Changed(Self);
  end;
end;

function THighlighter.FindStyle(const Name: string): THighlighStyle;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FStyles.Count - 1 do
  begin
    if FStyles.Strings[I] = Name then
    begin
      Result := GetStyle(I);
      Break;
    end;
  end;
end;

function THighlighter.FindStyleByID(ID: Integer): THighlighStyle;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FStyles.Count - 1 do
  begin
    if THighlighStyle(FStyles.Objects[I]).ID = ID then
    begin
      Result := GetStyle(I);
      Break;
    end;
  end;
end;

function THighlighter.GetStyle(Index: Integer): THighlighStyle;
begin
  Result := THighlighStyle(FStyles.Objects[Index]);
end;

function THighlighter.GetStyleCount: Integer;
begin
  Result := FStyles.Count;
end;

procedure THighlighter.HighlightChanged(Sender: TObject);
begin
  if FUpdateCount = 0 then
    Changed(Sender)
  else
    FUpdate := True;
end;

procedure THighlighter.RemoveHookChange(Event: TNotifyEvent);
var
  I: Integer;
begin
  with FHookList, TMethod(Event) do
  begin
    I := Count - 1;
    while I > 0 do
      if Items[I] <> Data then
        Dec(I, 2)
      else
      begin
        Dec(I);
        if Items[I] = Code then
        begin
          Delete(I);
          Delete(I);
        end;
        Dec(I);
      end;
  end;
end;

end.
