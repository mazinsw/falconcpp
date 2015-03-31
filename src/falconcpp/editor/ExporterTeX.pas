unit ExporterTeX;

interface

uses
  Classes, StyleExporter, SysUtils, DScintilla;

type
  TExporterTeX = class(TStyleExporter)
  private
    FBuilder: TStringBuilder;
  protected
    function GetDefaultFilter: string; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExportAll(Editor: TDScintilla); override;
    procedure SaveToStream(Stream: TStream; Encoding: TEncoding); override;
    procedure Clear; override;
  end;

implementation

uses
  Windows, DScintillaTypes, Graphics;

{ TExporterTeX }

procedure TExporterTeX.Clear;
begin
  FBuilder.Clear;
end;

constructor TExporterTeX.Create;
begin
  FBuilder := TStringBuilder.Create;
end;

destructor TExporterTeX.Destroy;
begin
  FBuilder.Free;
  inherited;
end;

// DotDecSepFormat always formats with a dot as decimal separator.
// This is necessary because LaTeX expects a dot, but VCL's Format is
// language-dependent, i.e. with another locale set, the separator can be
// different (for example a comma).
function DotDecSepFormat(const Format: string; const Args: array of const): string;
var
  OldDecimalSeparator: Char;
begin
  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  Result := SysUtils.Format(Format, Args);
  FormatSettings.DecimalSeparator := OldDecimalSeparator;
end;

function ColorToTeX(AColor: TColor): string;
const
  f = '%1.2g';
  f2 = '%s,%s,%s';
var
  Col: Cardinal;
  RValue, GValue, BValue: string;
begin
  Col := AColor;
  RValue := DotDecSepFormat(f, [((Col shr 0) and $FF) / 255]);
  GValue := DotDecSepFormat(f, [((Col shr 8) and $FF) / 255]);
  BValue := DotDecSepFormat(f, [((Col shr 16) and $FF) / 255]);
  Result := Format(f2, [RValue, GValue, BValue]);
end;

procedure TExporterTeX.ExportAll(Editor: TDScintilla);
var
  DocLen, Style, LastStyle, I, J, StyleIndex: Integer;
  UC: Cardinal;
  C, C2, C3: Byte;
  StyleUsed: array[0..STYLE_MAX] of Boolean;
  StyleCommands: TStrings;
  StyleCommandsIndex: array[0..STYLE_MAX] of Integer;
  Ch: Char;
  FrgCl, BckCl: TColor;
  TeXCmd, Formatting, CloseBkt, Stl: string;
begin
  Clear;
  DocLen := Editor.GetLength;
  Editor.Colourise(0, -1); // force apply styles
  FBuilder.AppendLine(Format('\documentclass[a4paper, %dpt]{article}',
    [Editor.StyleGetSize(STYLE_DEFAULT)]));
  FBuilder.AppendLine('\usepackage[a4paper, margin=2cm]{geometry}');
  FBuilder.AppendLine('\usepackage[T1]{fontenc}');
  FBuilder.AppendLine('\usepackage{color}');
  FBuilder.AppendLine('\usepackage{alltt}');
  FBuilder.AppendLine('\usepackage{times}');
  FBuilder.AppendLine('\usepackage{ulem}');
  FBuilder.AppendLine('\usepackage[utf8]{inputenc}');
  FBuilder.AppendLine('% Special Characters');
  FBuilder.AppendLine('\newcommand\SPC{\hspace*{0.6em}}');
  FBuilder.AppendLine(Format('\newcommand\TAB{\hspace*{%sem}}',
    [DotDecSepFormat('%1.1g', [Editor.GetTabWidth * 0.6])]));
  FBuilder.AppendLine('\newcommand\BS{\mbox{\char 92}}'); // Backslash
  FBuilder.AppendLine('\newcommand\TLD{\mbox{\char 126}}'); // ~
  FBuilder.AppendLine('\newcommand\CIR{\mbox{\char 94}}'); // ^
  FBuilder.AppendLine('\newcommand\HYP{\mbox{\char 45}}'); // a simple -
  FBuilder.AppendLine('\newcommand\QOT{\mbox{\char 34}}'); // "
  FBuilder.AppendLine('\newcommand{\uln}[1]{\bgroup \markoverwith{\hbox{\_}}\ULon{{#1}}}');
  FBuilder.AppendLine('% Highlighter Styles');
  for I := 0 to STYLE_MAX do
  begin
    StyleUsed[I] := False;
  end;
  StyleIndex := 0;
  StyleCommands := TStringList.Create;
  for I := 0 to STYLE_MAX do
  begin
    Style := I;
    if StyleUsed[Style] then
      Continue;
    StyleUsed[Style] := True;
    CloseBkt := '';
    Formatting := '';
    if Editor.StyleGetBold(Style) then
    begin
      Formatting := Formatting + '{\textbf';
      CloseBkt := CloseBkt + '}';
    end;
    if Editor.StyleGetItalic(Style) then
    begin
      Formatting := Formatting + '{\textit';
      CloseBkt := CloseBkt + '}';
    end;
    if Editor.StyleGetUnderline(Style) then
    begin
      Formatting := Formatting + '{\uln';
      CloseBkt := CloseBkt + '}';
    end;
    FrgCl := Editor.StyleGetFore(Style);
    BckCl := Editor.StyleGetBack(Style);
    if (FrgCl <> clBlack) and (FrgCl <> clNone)  then
    begin
      Formatting := Formatting + Format('{\textcolor[rgb]{%s}',
        [ColorToTeX(FrgCl)]);
      CloseBkt := CloseBkt + '}';
    end;
    if (BckCl <> clWhite) and (BckCl <> clNone) then
    begin
      Formatting := Formatting + Format('{\colorbox[rgb]{%s}',
        [ColorToTeX(BckCl)]);
      CloseBkt := CloseBkt + '}';
    end;
    TeXCmd := Format('%s{#1}%s', [Formatting, CloseBkt]);
    J := StyleCommands.IndexOf(TeXCmd);
    if J = -1 then
    begin
      StyleCommands.Add(TeXCmd);
      StyleCommandsIndex[Style] := StyleIndex;
      Inc(StyleIndex);
    end
    else
      StyleCommandsIndex[Style] := J;
  end;
  for I := 0 to StyleCommands.Count - 1 do
  begin
    if I > 27 then
      Stl := 'A' + Char(Ord('A') + I - 27)
    else
      Stl := Char(Ord('A') + I);
    FBuilder.AppendLine('\newcommand{\Style' + Stl + '}[1]' + StyleCommands[I]);
  end;
  StyleCommands.Free;
  FBuilder.AppendLine;
  FBuilder.AppendLine('\title{' + Title + '}');
  FBuilder.AppendLine('% Generated by Falcon C++ TeX exporter');
  FBuilder.AppendLine('\begin{document}');
  FBuilder.AppendLine;
  FBuilder.AppendLine('\begin{ttfamily}');
  FBuilder.AppendLine('\noindent');
  LastStyle := -1;
  I := 0;
  while I < DocLen do
  begin
    C := Editor.GetCharAt(I);
    Ch := Char(C);
    Style := Editor.GetStyleAt(I);
    if Style <> LastStyle then
    begin
      if LastStyle <> -1 then
        FBuilder.Append('}');
      if (LastStyle = -1) or (StyleCommandsIndex[Style] <>
        StyleCommandsIndex[LastStyle]) then
      begin
        if StyleCommandsIndex[Style] > 27 then
          Stl := 'A' + Char(Ord('A') + StyleCommandsIndex[Style] - 27)
        else
          Stl := Char(Ord('A') + StyleCommandsIndex[Style]);
        FBuilder.Append('\Style' + Stl + '{');
      end;
      LastStyle := Style;
    end;
    case Ch of
      #0:;
      #10, #13:
      begin
        if (Ch = #13) and (I < DocLen - 1) and
          (Char(Editor.GetCharAt(I + 1)) = #10) then
          Inc(I);
        if LastStyle <> -1 then
        begin
          FBuilder.Append('}');
          LastStyle := -1;
        end;
        FBuilder.AppendLine('\\');
      end;
      '~': FBuilder.Append('\TLD ');
      '^': FBuilder.Append('\CIR ');
      ' ': FBuilder.Append('\SPC ');
       #9: FBuilder.Append('\TAB ');
      '-': FBuilder.Append('\HYP ');
      '"': FBuilder.Append('\QOT ');
      '@': FBuilder.Append('$@$');
      '$': FBuilder.Append('\$');
      '&': FBuilder.Append('\&');
      '<': FBuilder.Append('$<$');
      '>': FBuilder.Append('$>$');
      '_': FBuilder.Append('\_');
      '#': FBuilder.Append('\#');
      '%': FBuilder.Append('\%');
      '\': FBuilder.Append('\BS ');
      '{': FBuilder.Append('\{');
      '}': FBuilder.Append('\}');
    else
      if C > $7F then
      begin	//this may be some UTF-8 character, so parse it as such
        UC  := C;
        C2 := Editor.GetCharAt(I + 1);
        if (C < $E0) then
        begin
          if (C2 and $C0) = $80 then
          begin
            Inc(I);
            UC := (($1F and C) shl 6);
            UC := UC or ($3F and C2);
          end;
        end
        else
        begin
          Inc(I);
          C3 := Editor.GetCharAt(I + 1);
          if ((C2 and $C0) = $80) and ((C3 and $C0) = $80) then
          begin
            Inc(I);
            UC := (($0F and C) shl 12);
            UC := UC or (($3F and C2) shl 6);
            UC := UC or  ($3F and C3);
          end;
        end;
        FBuilder.Append(Char(UC));
      end
      else
      begin
        FBuilder.Append(Ch);
      end;
    end;
    Inc(I);
  end;
  if LastStyle <> -1 then
  begin
    FBuilder.AppendLine('}');
  end;
  FBuilder.AppendLine('\end{ttfamily}');
  FBuilder.AppendLine('\end{document}');
end;

function TExporterTeX.GetDefaultFilter: string;
begin
  Result := 'LaTeX File (*.tex)|*.tex';
end;

procedure TExporterTeX.SaveToStream(Stream: TStream; Encoding: TEncoding);
var
  Buffer, Preamble: TBytes;
begin
  if Encoding = nil then
    Encoding := TEncoding.UTF8;
  Buffer := Encoding.GetBytes(FBuilder.ToString);
  Preamble := Encoding.GetPreamble;
  if (Length(Preamble) > 0) and (Encoding <> TEncoding.UTF8) then
    Stream.WriteBuffer(Preamble[0], Length(Preamble));
  Stream.WriteBuffer(Buffer[0], Length(Buffer));
end;

end.

