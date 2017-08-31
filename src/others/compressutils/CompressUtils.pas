unit CompressUtils;

interface

uses
  Windows, SysUtils, Classes, LibTar, Compress.BZip2, StrMatch, KAZip;

const
  FILE_TYPE_BZIP2 = 0;
  FILE_TYPE_ZIP = 1;

{extract functions}
function ExtractFile(const SrcFileName, DestFileName: string): Boolean;
function ExtractBzip2File(const FileName: string; Stream: TStream): Boolean; overload;
function ExtractBzip2File(FileStream, Stream: TStream): Boolean; overload;
function ExtractTarFile(Source, OutFile: TStream): Boolean;

{ search match file }
function FindTarFile(const FindName, Source: string; OutFile: TStream): Boolean; overload;
function FindTarFile(const FindName: string; Source, OutFile: TStream): Boolean; overload;
{no extract/search only}
function FindedTarFile(const FindName: string; Source: TStream): Boolean;
{ search match file }
function FindZipFile(const FindName: string; Source: TKAZip; OutFile: TStream): Boolean;
{no extract/search only}
function FindedZipFile(const FindName: string; Source: TKAZip): Boolean;

implementation

function ConvertSlashes(Path: string): string;
var
  i: Integer;
begin
  Result := Path;
  for i := 1 to Length(Result) do
    if Result[i] = '/' then
      Result[i] := '\';
end;

function ExtractFile(const SrcFileName, DestFileName: string): Boolean;
var
  Tp: Integer;
  Src: TFileStream;
  Dest: TFileStream;
  Zp: TKAZip;
  Ft: array[0..2] of AnsiChar;
begin
  Result := False;
  try
    Src := TFileStream.Create(SrcFileName, fmOpenRead + fmShareDenyWrite);
  except
    Exit;
  end;
  Ft[2] := #0;
  Src.Read(Ft, 2);
  if Ft = 'BZ' then
    Tp := FILE_TYPE_BZIP2
  else if string(Ft) = 'PK' then
    Tp := FILE_TYPE_ZIP
  else
  begin
    Src.Free;
    Exit;
  end;

  Src.Position := 0;
  case Tp of
    FILE_TYPE_BZIP2:
      begin
        try
          Dest := TFileStream.Create(ChangeFileExt(DestFileName, '.tar'), fmCreate);
        except
          Src.Free;
          Exit;
        end;
        Result := ExtractBzip2File(Src, Dest);
        if Result then
        begin
          Dest.Position := 0;
          Src.Free;
          Src := Dest;
          try
            Dest := TFileStream.Create(DestFileName, fmCreate);
          except
            Src.Free;
            Exit;
          end;
          if not ExtractTarFile(Src, Dest) then
          begin
            Src.Free;
            Dest.Free;
            Exit;
          end;
        end;
        Dest.Free;
        Src.Free;
        Result := True;
        DeleteFile(ChangeFileExt(DestFileName, '.tar'));
        Exit;
      end;
    FILE_TYPE_ZIP:
      begin
        try
          Dest := TFileStream.Create(DestFileName, fmCreate);
        except
          Src.Free;
          Exit;
        end;
        Zp := TKAZip.Create(nil);
        Zp.Open(Src);
        try
          if Zp.Entries.Count = 0 then
            raise Exception.Create('No zip entry found');
          Zp.Entries.Items[0].ExtractToStream(Dest);
        except
          Zp.Free;
          Src.Free;
          Dest.Free;
          Exit;
        end;
        Zp.Free;
        Dest.Free;
      end;
  else
    Src.Free;
    Exit;
  end;
  Src.Free;
  Result := True;
end;

function ExtractTarFile(Source, OutFile: TStream): Boolean;
var
  TA: TTarArchive;
  DirRec: TTarDirRec;
begin
  Result := False;
  try
    TA := TTarArchive.Create(Source);
    TA.Reset;
    if TA.FindNext(DirRec) then
      TA.ReadFile(OutFile);
    TA.Free;
  except
    Exit;
  end;
  Result := True;
end;

function ExtractBzip2File(const FileName: string; Stream: TStream): Boolean;
var
  Source: TFileStream;
begin
  Result := False;
  try
    Source := TFileStream.Create(FileName, fmOpenRead + fmShareDenyWrite);
  except
    Exit;
  end;
  Result := ExtractBzip2File(Source, Stream);
end;

function ExtractBzip2File(FileStream, Stream: TStream): Boolean;
const
  BufferSize = 65536;
var
  Count: Integer;
  Decomp: TBZDecompressionStream;
  Buffer: array[0..BufferSize - 1] of Byte;
begin
  Result := False;
  try
    Decomp := TBZDecompressionStream.Create(FileStream);
    while True do
    begin
      Count := Decomp.Read(Buffer, BufferSize);
      if Count <> 0 then
        Stream.WriteBuffer(Buffer, Count)
      else
        Break;
    end;
    Decomp.Free;
  except
    Exit;
  end;
  Result := True;
end;

function FindTarFile(const FindName, Source: string; OutFile: TStream): Boolean;
var
  TA: TTarArchive;
  DirRec: TTarDirRec;
  S: string;
begin
  Result := False;
  try
    TA := TTarArchive.Create(Source);
    TA.Reset;
    while TA.FindNext(DirRec) do
    begin
      S := ConvertSlashes(string(DirRec.Name));
      if (DirRec.FileType = ftDirectory) then
        Continue;
      if FileNameMatch(FindName, S) then
      begin
        TA.ReadFile(OutFile);
        TA.Free;
        Result := True;
        Exit;
      end;
    end;
    TA.Free;
  except
  end;
end;

function FindTarFile(const FindName: string; Source, OutFile: TStream): Boolean;
var
  TA: TTarArchive;
  DirRec: TTarDirRec;
  S: string;
begin
  Result := False;
  try
    TA := TTarArchive.Create(Source);
    TA.Reset;
    while TA.FindNext(DirRec) do
    begin
      S := ConvertSlashes(string(DirRec.Name));
      if (DirRec.FileType = ftDirectory) then
        Continue;
      if FileNameMatch(FindName, S) then
      begin
        TA.ReadFile(OutFile);
        TA.Free;
        Result := True;
        Exit;
      end;
    end;
    TA.Free;
  except
  end;
end;

function FindedTarFile(const FindName: string; Source: TStream): Boolean;
var
  TA: TTarArchive;
  DirRec: TTarDirRec;
  S: string;
begin
  Result := False;
  try
    TA := TTarArchive.Create(Source);
    TA.Reset;
    while TA.FindNext(DirRec) do
    begin
      S := ConvertSlashes(string(DirRec.Name));
      if (DirRec.FileType = ftDirectory) then
        Continue;
      if FileNameMatch(FindName, S) then
      begin
        TA.Free;
        Result := True;
        Exit;
      end;
    end;
    TA.Free;
  except
  end;
end;

function FindZipFile(const FindName: string; Source: TKAZip; OutFile: TStream): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := False;
  for I := 0 to Source.Entries.Count - 1 do
  begin
    S := ConvertSlashes(Source.Entries.Items[I].FileName);
    if FileNameMatch(FindName, S) then
    begin
      Result := True;
      Source.Entries.Items[I].ExtractToStream(OutFile);
      Exit;
    end;
  end;
end;

function FindedZipFile(const FindName: string; Source: TKAZip): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := False;
  for I := 0 to Source.Entries.Count - 1 do
  begin
    S := ConvertSlashes(Source.Entries.Items[I].FileName);
    if FileNameMatch(FindName, S) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

end.
