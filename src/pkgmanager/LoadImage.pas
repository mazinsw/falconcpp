unit LoadImage;

interface

uses
  Classes, Graphics, PNGImage, Jpeg, GIFImg;

function LoadImageFromStream(Picture: TPicture; Stream: TStream): Boolean;

implementation

function LoadImageFromStream(Picture: TPicture; Stream: TStream): Boolean;
var
  Magic: array[0..4] of Char;
  bmp: TBitmap;
  png: TPngImage;
  gif: TGIFImage;
  jpg: TJPEGImage;
begin
  Result := False;
  Stream.Position := 1;
  FillChar(Magic, SizeOf(Magic), 0);
  Stream.Read(Magic, 3);
  if String(Magic) = 'PNG' then
  begin
    Stream.Position := 0;
    png := TPngImage.Create;
    png.LoadFromStream(Stream);
    Picture.Assign(png);
    png.Free;
    Result := True;
    Exit;
  end;
  Stream.Position := 6;
  FillChar(Magic, SizeOf(Magic), 0);
  Stream.Read(Magic, 4);
  if String(Magic) = 'JFIF' then
  begin
    Stream.Position := 0;
    jpg := TJPEGImage.Create;
    jpg.LoadFromStream(Stream);
    Picture.Assign(jpg);
    jpg.Free;
    Result := True;
    Exit;
  end;
  Stream.Position := 0;
  FillChar(Magic, SizeOf(Magic), 0);
  Stream.Read(Magic, 3);
  if String(Magic) = 'GIF' then
  begin
    Stream.Position := 0;
    gif := TGIFImage.Create;
    gif.LoadFromStream(Stream);
    Picture.Assign(gif);
    gif.Free;
    Result := True;
    Exit;
  end;
  Stream.Position := 0;
  FillChar(Magic, SizeOf(Magic), 0);
  Stream.Read(Magic, 2);
  if String(Magic) = 'BM' then
  begin
    Stream.Position := 0;
    bmp := TBitmap.Create;
    bmp.LoadFromStream(Stream);
    Picture.Assign(bmp);
    bmp.Free;
    Result := True;
    Exit;
  end;
end;

end.