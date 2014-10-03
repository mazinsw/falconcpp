unit StyleExporter;

interface

uses
  Classes, SysUtils, DScintilla;

type

  TStyleExporter = class
  private
    FTitle: string;
  protected
    function GetDefaultFilter: string; virtual; abstract;
  public
    procedure Clear; virtual; abstract;
    procedure ExportAll(Editor: TDScintilla); virtual; abstract;
    procedure SaveToStream(Stream: TStream); overload; virtual;
    procedure SaveToStream(Stream: TStream; Encoding: TEncoding); overload; virtual; abstract;
    procedure SaveToFile(const FileName: string); overload; virtual;
    procedure SaveToFile(const FileName: string; Encoding: TEncoding); overload;
    property Title: string read FTitle write FTitle;
    property DefaultFilter: string read GetDefaultFilter;
  end;

implementation

{ TStyleExporter }

procedure TStyleExporter.SaveToFile(const FileName: string);
begin
  SaveToFile(FileName, nil);
end;

procedure TStyleExporter.SaveToFile(const FileName: string;
  Encoding: TEncoding);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream, Encoding);
  finally
    Stream.Free;
  end;
end;

procedure TStyleExporter.SaveToStream(Stream: TStream);
begin
  SaveToStream(Stream, nil);
end;

end.
