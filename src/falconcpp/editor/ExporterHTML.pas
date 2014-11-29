unit ExporterHTML;

interface

uses
  Classes, StyleExporter, SysUtils, DScintilla;

type
  TExporterHTML = class(TStyleExporter)
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
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
  end;

implementation

uses
  DScintillaTypes, Graphics;

{ TExporterHTML }

procedure TExporterHTML.Clear;
begin
  FBuilder.Clear;
end;

constructor TExporterHTML.Create;
begin
  FBuilder := TStringBuilder.Create;
end;

destructor TExporterHTML.Destroy;
begin
  FBuilder.Free;
  inherited;
end;

function ColorToHtml(Clr: TColor): string;
begin
  Result := IntToHex(clr, 6);
  Result := '#' + Copy(Result, 5, 2) + Copy(Result, 3, 2) + Copy(Result, 1, 2);
end;

procedure TExporterHTML.ExportAll(Editor: TDScintilla);
var
  DocLen, Style, LastStyle, I: Integer;
  UC: Cardinal;
  C, C2, C3: Byte;
  StyleUsed: array[0..STYLE_MAX] of Boolean;
  Ch: Char;
  BckCl: TColor;
begin
  Clear;
  DocLen := Editor.GetLength;
  Editor.Colourise(0, -1); // force apply styles
  FBuilder.AppendLine('<title>' + Title + '</title>');
  FBuilder.AppendLine('<style type="text/css">');
  FBuilder.AppendLine('body {');
  FBuilder.AppendLine('  color: ' + ColorToHtml(Editor.StyleGetFore(STYLE_DEFAULT)) + ';');
  BckCl := Editor.StyleGetBack(STYLE_DEFAULT);
  if (BckCl <> clNone) and (BckCl <> clWhite) then
    FBuilder.AppendLine('  background-color: ' + ColorToHtml(Editor.StyleGetBack(STYLE_DEFAULT)) + ';');
  FBuilder.AppendLine('}');
  for I := 0 to STYLE_MAX do
    StyleUsed[I] := False;
  for I := 0 to DocLen - 1 do
  begin
    Style := Editor.GetStyleAt(I);
    if StyleUsed[Style] then
      Continue;
    StyleUsed[Style] := True;
    FBuilder.AppendLine('span.s' + IntToStr(Style) + ' {');
    FBuilder.AppendLine('  font-family: "' + Editor.StyleGetFont(Style) + '";');
    FBuilder.AppendLine('  font-size: ' + IntToStr(Editor.StyleGetSize(Style)) + 'pt;');
    if Editor.StyleGetItalic(Style) then
      FBuilder.AppendLine('  font-style: italic;');
    if Editor.StyleGetBold(Style) then
      FBuilder.AppendLine('  font-weight: bold;');
    FBuilder.AppendLine('  color: ' + ColorToHtml(Editor.StyleGetFore(Style)) + ';');
    BckCl := Editor.StyleGetBack(Style);
    if (BckCl <> clNone) and (BckCl <> clWhite) then
      FBuilder.AppendLine('  background-color: ' + ColorToHtml(Editor.StyleGetBack(Style)) + ';');
    FBuilder.AppendLine('}');
  end;
  FBuilder.AppendLine('</style>');
  FBuilder.AppendLine('</head>');
  FBuilder.AppendLine('<body>');
  FBuilder.AppendLine('<pre><code>');
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
        FBuilder.Append('</span>');
      FBuilder.Append('<span class="s' + IntToStr(Style) + '">');
      LastStyle := Style;
    end;
    case Ch of
      #0:;
      #9: FBuilder.Append(StringOfChar(' ', Editor.GetTabWidth));
      #10, #13:
      begin
        if (Ch = #13) and (I < DocLen - 1) and
          (Char(Editor.GetCharAt(I + 1)) = #10) then
          Inc(I);
        if LastStyle <> -1 then
          FBuilder.Append('</span>');
        FBuilder.AppendLine;
        LastStyle := -1;
      end;
      '<': FBuilder.Append('&lt;');
      '>': FBuilder.Append('&gt;');
      '&': FBuilder.Append('&amp;');
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
        Ch := Char(UC);
      end;
      FBuilder.Append(Ch);
    end;
    Inc(I);
  end;
  if LastStyle <> -1 then
    FBuilder.Append('</span>');
  FBuilder.AppendLine;
  FBuilder.AppendLine('</code></pre>');
  FBuilder.AppendLine('</body>');
  FBuilder.AppendLine('</html>');
end;

function TExporterHTML.GetDefaultFilter: string;
begin
  Result := 'HyperText Markup Language (*.html)|*.html';
end;

procedure TExporterHTML.SaveToFile(const FileName: string);
begin
  SaveToFile(FileName, TEncoding.UTF8);
end;

procedure TExporterHTML.SaveToStream(Stream: TStream);
begin
  SaveToStream(Stream, TEncoding.UTF8);
end;

procedure TExporterHTML.SaveToStream(Stream: TStream; Encoding: TEncoding);
var
  Buffer, Preamble: TBytes;
  BuilderTmp: TStringBuilder;
begin
  if Encoding = nil then
    Encoding := TEncoding.Default;
  BuilderTmp := TStringBuilder.Create;
  BuilderTmp.AppendLine('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"');
	BuilderTmp.AppendLine('	 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">');
  BuilderTmp.AppendLine('<html xmlns="http://www.w3.org/1999/xhtml">');
  BuilderTmp.AppendLine('<head>');
  if Encoding = TEncoding.UTF8 then
    BuilderTmp.AppendLine('<meta http-equiv="content-type" content="text/html; charset=UTF-8" />')
  else if (Encoding = TEncoding.Unicode) or (Encoding = TEncoding.BigEndianUnicode) then
    BuilderTmp.AppendLine('<meta http-equiv="content-type" content="text/html; charset=UCS-2" />');
  BuilderTmp.Append(FBuilder.ToString);
  Buffer := Encoding.GetBytes(BuilderTmp.ToString);
  BuilderTmp.Free;
  Preamble := Encoding.GetPreamble;
  if Length(Preamble) > 0 then
    Stream.WriteBuffer(Preamble[0], Length(Preamble));
  Stream.WriteBuffer(Buffer[0], Length(Buffer));
end;

end.
