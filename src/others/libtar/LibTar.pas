(**
===============================================================================================
Name    : LibTar
===============================================================================================
Subject : Handling of "tar" files
===============================================================================================
Author  : Stefan Heymann
          Eschenweg 3
          72076 Tübingen
          GERMANY

E-Mail:   stefan@destructor.de
Web:      www.destructor.de

===============================================================================================
TTarArchive Usage
-----------------
- Choose a constructor
- Make an instance of TTarArchive                  TA := TTarArchive.Create (Filename);
- Scan through the archive                         TA.Reset;
                                                   WHILE TA.FindNext (DirRec) DO BEGIN
- Evaluate the DirRec for each file                  ListBox.Items.Add (DirRec.Name);
- Read out the current file                          TA.ReadFile (DestFilename);
  (You can ommit this if you want to
  read in the directory only)                        END;
- You're done                                      TA.Free;

TTarWriter Usage
----------------
- Choose a constructor
- Make an instance of TTarWriter                   TW := TTarWriter.Create ('my.tar');
- Add a file to the tar archive                    TW.AddFile ('foobar.txt');
- Add a string as a file                           TW.AddString (SL.Text, 'joe.txt', Now);
- Destroy TarWriter instance                       TW.Free;
- Now your tar file is ready.

Source, Legals ("Licence")
--------------------------
The official site to get this code is http://www.destructor.de/

Usage and Distribution of this Source Code is ruled by the
"Destructor.de Source code Licence" (DSL) which comes with this file or
can be downloaded at http://www.destructor.de/

IN SHORT: Usage and distribution of this source code is free.
          You use it completely on your own risk.

Donateware
----------
If you like this code, you are free to donate
http://www.destructor.de/donateware.htm

===============================================================================================
!!!  All parts of this code which are not finished or known to be buggy
     are marked with three exclamation marks
===============================================================================================
Date        Author Changes
-----------------------------------------------------------------------------------------------
2001-04-26  HeySt  0.0.1 Start
2001-04-28  HeySt  1.0.0 First Release
2001-06-19  HeySt  2.0.0 Finished TTarWriter
2001-09-06  HeySt  2.0.1 Bugfix in TTarArchive.FindNext: FBytesToGo must sometimes be 0
2001-10-25  HeySt  2.0.2 Introduced the ClearDirRec procedure
2001-11-13  HeySt  2.0.3 Bugfix: Take out ClearDirRec call from WriteTarHeader
                         Bug Reported by Tony BenBrahim
2001-12-25  HeySt  2.0.4 WriteTarHeader: Fill Rec with zero bytes before filling it
2002-05-18  HeySt  2.0.5 Kylix awareness: Thanks to Kerry L. Davison for the canges
2005-09-03  HeySt  2.0.6 TTarArchive.FindNext: Don't access SourceStream.Size
                         (for compressed streams, which don't know their .Size)
2006-03-13  HeySt  2.0.7 Bugfix in ReadFile (Buffer : POINTER)
2007-05-16  HeySt  2.0.8 Bugfix in TTarWriter.AddFile (Convertfilename in the ELSE branch)
                         Bug Reported by Chris Rorden
*)

unit LibTar;

interface

uses
(*$IFDEF LINUX*)
  Libc,
(*$ENDIF *)
(*$IFDEF MSWINDOWS *)
  Windows,
(*$ENDIF *)
  SysUtils, Classes;

type
  // --- File Access Permissions
  TTarPermission = (tpReadByOwner, tpWriteByOwner, tpExecuteByOwner,
    tpReadByGroup, tpWriteByGroup, tpExecuteByGroup,
    tpReadByOther, tpWriteByOther, tpExecuteByOther);
  TTarPermissions = set of TTarPermission;

  // --- Type of File
  TFileType = (ftNormal, // Regular file
    ftLink, // Link to another, previously archived, file (LinkName)
    ftSymbolicLink, // Symbolic link to another file              (LinkName)
    ftCharacter, // Character special files
    ftBlock, // Block special files
    ftDirectory, // Directory entry. Size is zero (unlimited) or max. number of bytes
    ftFifo, // FIFO special file. No data stored in the archive.
    ftContiguous, // Contiguous file, if supported by OS
    ftDumpDir, // List of files
    ftMultiVolume, // Multi-volume file part
    ftVolumeHeader); // Volume header. Can appear only as first record in the archive

  // --- Mode
  TTarMode = (tmSetUid, tmSetGid, tmSaveText);
  TTarModes = set of TTarMode;

  // --- Record for a Directory Entry
  //     Adjust the ClearDirRec procedure when this record changes!
  TTarDirRec = record
    Name: string; // File path and name
    Size: INT64; // File size in Bytes
    DateTime: TDateTime; // Last modification date and time
    Permissions: TTarPermissions; // Access permissions
    FileType: TFileType; // Type of file
    LinkName: string; // Name of linked file (for ftLink, ftSymbolicLink)
    UID: INTEGER; // User ID
    GID: INTEGER; // Group ID
    UserName: string; // User name
    GroupName: string; // Group name
    ChecksumOK: BOOLEAN; // Checksum was OK
    Mode: TTarModes; // Mode
    Magic: string; // Contents of the "Magic" field
    MajorDevNo: INTEGER; // Major Device No. for ftCharacter and ftBlock
    MinorDevNo: INTEGER; // Minor Device No. for ftCharacter and ftBlock
    FilePos: INT64; // Position in TAR file
  end;

  // --- The TAR Archive CLASS
  TTarArchive = class
  protected
    FStream: TStream; // Internal Stream
    FOwnsStream: BOOLEAN; // True if FStream is owned by the TTarArchive instance
    FBytesToGo: INT64; // Bytes until the next Header Record
  public
    constructor Create(Stream: TStream); overload;
    constructor Create(Filename: string;
      FileMode: WORD = fmOpenRead or fmShareDenyWrite); overload;
    destructor Destroy; override;
    procedure Reset; // Reset File Pointer
    function FindNext(var DirRec: TTarDirRec): BOOLEAN; // Reads next Directory Info Record. FALSE if EOF reached
    procedure ReadFile(Buffer: POINTER); overload; // Reads file data for last Directory Record
    procedure ReadFile(Stream: TStream); overload; // -;-
    procedure ReadFile(Filename: string); overload; // -;-
    function ReadFile: string; overload; // -;-

    procedure GetFilePos(var Current, Size: INT64); // Current File Position
    procedure SetFilePos(NewPos: INT64); // Set new Current File Position
  end;

  // --- The TAR Archive Writer CLASS
  TTarWriter = class
  protected
    FStream: TStream;
    FOwnsStream: BOOLEAN;
    FFinalized: BOOLEAN;
                                                   // --- Used at the next "Add" method call: ---
    FPermissions: TTarPermissions; // Access permissions
    FUID: INTEGER; // User ID
    FGID: INTEGER; // Group ID
    FUserName: string; // User name
    FGroupName: string; // Group name
    FMode: TTarModes; // Mode
    FMagic: string; // Contents of the "Magic" field
    constructor CreateEmpty;
  public
    constructor Create(TargetStream: TStream); overload;
    constructor Create(TargetFilename: string; Mode: INTEGER = fmCreate); overload;
    destructor Destroy; override; // Writes End-Of-File Tag
    procedure AddFile(Filename: string; TarFilename: string = '');
    procedure AddStream(Stream: TStream; TarFilename: string; FileDateGmt: TDateTime);
    procedure AddString(Contents: string; TarFilename: string; FileDateGmt: TDateTime);
    procedure AddDir(Dirname: string; DateGmt: TDateTime; MaxDirSize: INT64 = 0);
    procedure AddSymbolicLink(Filename, Linkname: string; DateGmt: TDateTime);
    procedure AddLink(Filename, Linkname: string; DateGmt: TDateTime);
    procedure AddVolumeHeader(VolumeId: string; DateGmt: TDateTime);
    procedure Finalize;
    property Permissions: TTarPermissions read FPermissions write FPermissions; // Access permissions
    property UID: INTEGER read FUID write FUID; // User ID
    property GID: INTEGER read FGID write FGID; // Group ID
    property UserName: string read FUserName write FUserName; // User name
    property GroupName: string read FGroupName write FGroupName; // Group name
    property Mode: TTarModes read FMode write FMode; // Mode
    property Magic: string read FMagic write FMagic; // Contents of the "Magic" field
  end;

// --- Some useful constants
const
  FILETYPE_NAME: array[TFileType] of string =
  ('Regular', 'Link', 'Symbolic Link', 'Char File', 'Block File',
    'Directory', 'FIFO File', 'Contiguous', 'Dir Dump', 'Multivol', 'Volume Header');

  ALL_PERMISSIONS = [tpReadByOwner, tpWriteByOwner, tpExecuteByOwner,
    tpReadByGroup, tpWriteByGroup, tpExecuteByGroup,
    tpReadByOther, tpWriteByOther, tpExecuteByOther];
  READ_PERMISSIONS = [tpReadByOwner, tpReadByGroup, tpReadByOther];
  WRITE_PERMISSIONS = [tpWriteByOwner, tpWriteByGroup, tpWriteByOther];
  EXECUTE_PERMISSIONS = [tpExecuteByOwner, tpExecuteByGroup, tpExecuteByOther];

function PermissionString(Permissions: TTarPermissions): string;
function ConvertFilename(Filename: string): string;
function FileTimeGMT(FileName: string): TDateTime; OVERLOAD;
function FileTimeGMT(SearchRec: TSearchRec): TDateTime; OVERLOAD;
procedure ClearDirRec(var DirRec: TTarDirRec);

(*
===============================================================================================
IMPLEMENTATION
===============================================================================================
*)

implementation

function PermissionString(Permissions: TTarPermissions): string;
begin
  Result := '';
  if tpReadByOwner in Permissions then
    Result := Result + 'r'
  else
    Result := Result + '-';
  if tpWriteByOwner in Permissions then
    Result := Result + 'w'
  else
    Result := Result + '-';
  if tpExecuteByOwner in Permissions then
    Result := Result + 'x'
  else
    Result := Result + '-';
  if tpReadByGroup in Permissions then
    Result := Result + 'r'
  else
    Result := Result + '-';
  if tpWriteByGroup in Permissions then
    Result := Result + 'w'
  else
    Result := Result + '-';
  if tpExecuteByGroup in Permissions then
    Result := Result + 'x'
  else
    Result := Result + '-';
  if tpReadByOther in Permissions then
    Result := Result + 'r'
  else
    Result := Result + '-';
  if tpWriteByOther in Permissions then
    Result := Result + 'w'
  else
    Result := Result + '-';
  if tpExecuteByOther in Permissions then
    Result := Result + 'x'
  else
    Result := Result + '-';
end;

function ConvertFilename(Filename: string): string;
         // Converts the filename to Unix conventions
begin
  (*$IFDEF LINUX *)
  Result := Filename;
  (*$ELSE *)
  Result := StringReplace(Filename, '\', '/', [rfReplaceAll]);
  (*$ENDIF *)
end;

function FileTimeGMT(FileName: string): TDateTime;
         // Returns the Date and Time of the last modification of the given File
         // The Result is zero if the file could not be found
         // The Result is given in UTC (GMT) time zone
var
  SR: TSearchRec;
begin
  Result := 0.0;
  if FindFirst(FileName, faAnyFile, SR) = 0 then
    Result := FileTimeGMT(SR);
  FindClose(SR);
end;

function FileTimeGMT(SearchRec: TSearchRec): TDateTime;
(*$IFDEF MSWINDOWS *)
var
  SystemFileTime: TSystemTime;
(*$ENDIF *)
(*$IFDEF LINUX *)
var
  TimeVal: TTimeVal;
  TimeZone: TTimeZone;
(*$ENDIF *)
begin
  Result := 0.0;
  (*$IFDEF MSWINDOWS *)(*$WARNINGS OFF *)
  if (SearchRec.FindData.dwFileAttributes and faDirectory) = 0 then
    if FileTimeToSystemTime(SearchRec.FindData.ftLastWriteTime, SystemFileTime) then
      Result := EncodeDate(SystemFileTime.wYear, SystemFileTime.wMonth, SystemFileTime.wDay)
        + EncodeTime(SystemFileTime.wHour, SystemFileTime.wMinute, SystemFileTime.wSecond, SystemFileTime.wMilliseconds);
  (*$ENDIF *)(*$WARNINGS ON *)
  (*$IFDEF LINUX *)
  if SearchRec.Attr and faDirectory = 0 then
  begin
    Result := FileDateToDateTime(SearchRec.Time);
    GetTimeOfDay(TimeVal, TimeZone);
    Result := Result + TimeZone.tz_minuteswest / (60 * 24);
  end;
  (*$ENDIF *)
end;

procedure ClearDirRec(var DirRec: TTarDirRec);
          // This is included because a FillChar (DirRec, SizeOf (DirRec), 0)
          // will destroy the long string pointers, leading to strange bugs
begin
  with DirRec do
  begin
    Name := '';
    Size := 0;
    DateTime := 0.0;
    Permissions := [];
    FileType := TFileType(0);
    LinkName := '';
    UID := 0;
    GID := 0;
    UserName := '';
    GroupName := '';
    ChecksumOK := FALSE;
    Mode := [];
    Magic := '';
    MajorDevNo := 0;
    MinorDevNo := 0;
    FilePos := 0;
  end;
end;

(*
===============================================================================================
TAR format
===============================================================================================
*)

const
  RECORDSIZE = 512;
  NAMSIZ = 100;
  TUNMLEN = 32;
  TGNMLEN = 32;
  CHKBLANKS = #32#32#32#32#32#32#32#32;

type
  TTarHeader = packed record
    Name: array[0..NAMSIZ - 1] of CHAR;
    Mode: array[0..7] of CHAR;
    UID: array[0..7] of CHAR;
    GID: array[0..7] of CHAR;
    Size: array[0..11] of CHAR;
    MTime: array[0..11] of CHAR;
    ChkSum: array[0..7] of CHAR;
    LinkFlag: CHAR;
    LinkName: array[0..NAMSIZ - 1] of CHAR;
    Magic: array[0..7] of CHAR;
    UName: array[0..TUNMLEN - 1] of CHAR;
    GName: array[0..TGNMLEN - 1] of CHAR;
    DevMajor: array[0..7] of CHAR;
    DevMinor: array[0..7] of CHAR;
  end;

function ExtractText(P: PChar): string;
begin
  Result := string(P);
end;

function ExtractNumber(P: PChar): INTEGER; overload;
var
  Strg: string;
begin
  Strg := Trim(StrPas(P));
  P := PChar(Strg);
  Result := 0;
  while (P^ <> #32) and (P^ <> #0) do
  begin
    Result := (ORD(P^) - ORD('0')) or (Result shl 3);
    INC(P);
  end;
end;

function ExtractNumber64(P: PChar): INT64; overload;
var
  Strg: string;
begin
  Strg := Trim(StrPas(P));
  P := PChar(Strg);
  Result := 0;
  while (P^ <> #32) and (P^ <> #0) do
  begin
    Result := (ORD(P^) - ORD('0')) or (Result shl 3);
    INC(P);
  end;
end;

function ExtractNumber(P: PChar; MaxLen: INTEGER): INTEGER; overload;
var
  S0: array[0..255] of CHAR;
  Strg: string;
begin
  StrLCopy(S0, P, MaxLen);
  Strg := Trim(StrPas(S0));
  P := PChar(Strg);
  Result := 0;
  while (P^ <> #32) and (P^ <> #0) do
  begin
    Result := (ORD(P^) - ORD('0')) or (Result shl 3);
    INC(P);
  end;
end;

function ExtractNumber64(P: PChar; MaxLen: INTEGER): INT64; overload;
var
  S0: array[0..255] of CHAR;
  Strg: string;
begin
  StrLCopy(S0, P, MaxLen);
  Strg := Trim(StrPas(S0));
  P := PChar(Strg);
  Result := 0;
  while (P^ <> #32) and (P^ <> #0) do
  begin
    Result := (ORD(P^) - ORD('0')) or (Result shl 3);
    INC(P);
  end;
end;

function Records(Bytes: INT64): INT64;
begin
  Result := Bytes div RECORDSIZE;
  if Bytes mod RECORDSIZE > 0 then
    INC(Result);
end;

procedure Octal(N: INTEGER; P: PChar; Len: INTEGER);
         // Makes a string of octal digits
         // The string will always be "Len" characters long
var
  I: INTEGER;
begin
  for I := Len - 2 downto 0 do
  begin
    (P + I)^ := CHR(ORD('0') + ORD(N and $07));
    N := N shr 3;
  end;
  for I := 0 to Len - 3 do
    if (P + I)^ = '0'
      then
      (P + I)^ := #32
    else
      BREAK;
  (P + Len - 1)^ := #32;
end;

procedure Octal64(N: INT64; P: PChar; Len: INTEGER);
         // Makes a string of octal digits
         // The string will always be "Len" characters long
var
  I: INTEGER;
begin
  for I := Len - 2 downto 0 do
  begin
    (P + I)^ := CHR(ORD('0') + ORD(N and $07));
    N := N shr 3;
  end;
  for I := 0 to Len - 3 do
    if (P + I)^ = '0'
      then
      (P + I)^ := #32
    else
      BREAK;
  (P + Len - 1)^ := #32;
end;

procedure OctalN(N: INTEGER; P: PChar; Len: INTEGER);
begin
  Octal(N, P, Len - 1);
  (P + Len - 1)^ := #0;
end;

procedure WriteTarHeader(Dest: TStream; DirRec: TTarDirRec);
var
  Rec: array[0..RECORDSIZE - 1] of CHAR;
  TH: TTarHeader absolute Rec;
  Mode: INTEGER;
  NullDate: TDateTime;
  Checksum: CARDINAL;
  I: INTEGER;
begin
  FillChar(Rec, RECORDSIZE, 0);
  StrLCopy(TH.Name, PChar(DirRec.Name), NAMSIZ);
  Mode := 0;
  if tmSaveText in DirRec.Mode then
    Mode := Mode or $0200;
  if tmSetGid in DirRec.Mode then
    Mode := Mode or $0400;
  if tmSetUid in DirRec.Mode then
    Mode := Mode or $0800;
  if tpReadByOwner in DirRec.Permissions then
    Mode := Mode or $0100;
  if tpWriteByOwner in DirRec.Permissions then
    Mode := Mode or $0080;
  if tpExecuteByOwner in DirRec.Permissions then
    Mode := Mode or $0040;
  if tpReadByGroup in DirRec.Permissions then
    Mode := Mode or $0020;
  if tpWriteByGroup in DirRec.Permissions then
    Mode := Mode or $0010;
  if tpExecuteByGroup in DirRec.Permissions then
    Mode := Mode or $0008;
  if tpReadByOther in DirRec.Permissions then
    Mode := Mode or $0004;
  if tpWriteByOther in DirRec.Permissions then
    Mode := Mode or $0002;
  if tpExecuteByOther in DirRec.Permissions then
    Mode := Mode or $0001;
  OctalN(Mode, @TH.Mode, 8);
  OctalN(DirRec.UID, @TH.UID, 8);
  OctalN(DirRec.GID, @TH.GID, 8);
  Octal64(DirRec.Size, @TH.Size, 12);
  NullDate := EncodeDate(1970, 1, 1);
  if DirRec.DateTime >= NullDate
    then
    Octal(Trunc((DirRec.DateTime - NullDate) * 86400.0), @TH.MTime, 12)
  else
    Octal(Trunc(NullDate * 86400.0), @TH.MTime, 12);
  case DirRec.FileType of
    ftNormal: TH.LinkFlag := '0';
    ftLink: TH.LinkFlag := '1';
    ftSymbolicLink: TH.LinkFlag := '2';
    ftCharacter: TH.LinkFlag := '3';
    ftBlock: TH.LinkFlag := '4';
    ftDirectory: TH.LinkFlag := '5';
    ftFifo: TH.LinkFlag := '6';
    ftContiguous: TH.LinkFlag := '7';
    ftDumpDir: TH.LinkFlag := 'D';
    ftMultiVolume: TH.LinkFlag := 'M';
    ftVolumeHeader: TH.LinkFlag := 'V';
  end;
  StrLCopy(TH.LinkName, PChar(DirRec.LinkName), NAMSIZ);
  StrLCopy(TH.Magic, PChar(DirRec.Magic + #32#32#32#32#32#32#32#32), 8);
  StrLCopy(TH.UName, PChar(DirRec.UserName), TUNMLEN);
  StrLCopy(TH.GName, PChar(DirRec.GroupName), TGNMLEN);
  OctalN(DirRec.MajorDevNo, @TH.DevMajor, 8);
  OctalN(DirRec.MinorDevNo, @TH.DevMinor, 8);
  StrMove(TH.ChkSum, CHKBLANKS, 8);

  CheckSum := 0;
  for I := 0 to SizeOf(TTarHeader) - 1 do
    INC(CheckSum, INTEGER(ORD(Rec[I])));
  OctalN(CheckSum, @TH.ChkSum, 8);

  Dest.Write(TH, RECORDSIZE);
end;

(*
===============================================================================================
TTarArchive
===============================================================================================
*)

constructor TTarArchive.Create(Stream: TStream);
begin
  inherited Create;
  FStream := Stream;
  FOwnsStream := FALSE;
  Reset;
end;

constructor TTarArchive.Create(Filename: string; FileMode: WORD);
begin
  inherited Create;
  FStream := TFileStream.Create(Filename, FileMode);
  FOwnsStream := TRUE;
  Reset;
end;

destructor TTarArchive.Destroy;
begin
  if FOwnsStream then
    FStream.Free;
  inherited Destroy;
end;

procedure TTarArchive.Reset;
          // Reset File Pointer
begin
  FStream.Position := 0;
  FBytesToGo := 0;
end;

function TTarArchive.FindNext(var DirRec: TTarDirRec): BOOLEAN;
          // Reads next Directory Info Record
          // The Stream pointer must point to the first byte of the tar header
var
  Rec: array[0..RECORDSIZE - 1] of CHAR;
  CurFilePos: INTEGER;
  Header: TTarHeader absolute Rec;
  I: INTEGER;
  HeaderChkSum: WORD;
  Checksum: CARDINAL;
begin
  // --- Scan until next pointer
  if FBytesToGo > 0 then
    FStream.Seek(Records(FBytesToGo) * RECORDSIZE, soFromCurrent);

  // --- EOF reached?
  Result := FALSE;
  CurFilePos := FStream.Position;
  try
    FStream.ReadBuffer(Rec, RECORDSIZE);
    if Rec[0] = #0 then
      EXIT; // EOF reached
  except
    EXIT; // EOF reached, too
  end;
  Result := TRUE;

  ClearDirRec(DirRec);

  DirRec.FilePos := CurFilePos;
  DirRec.Name := ExtractText(Header.Name);
  DirRec.Size := ExtractNumber64(@Header.Size, 12);
  DirRec.DateTime := EncodeDate(1970, 1, 1) + (ExtractNumber(@Header.MTime, 12) / 86400.0);
  I := ExtractNumber(@Header.Mode);
  if I and $0100 <> 0 then
    Include(DirRec.Permissions, tpReadByOwner);
  if I and $0080 <> 0 then
    Include(DirRec.Permissions, tpWriteByOwner);
  if I and $0040 <> 0 then
    Include(DirRec.Permissions, tpExecuteByOwner);
  if I and $0020 <> 0 then
    Include(DirRec.Permissions, tpReadByGroup);
  if I and $0010 <> 0 then
    Include(DirRec.Permissions, tpWriteByGroup);
  if I and $0008 <> 0 then
    Include(DirRec.Permissions, tpExecuteByGroup);
  if I and $0004 <> 0 then
    Include(DirRec.Permissions, tpReadByOther);
  if I and $0002 <> 0 then
    Include(DirRec.Permissions, tpWriteByOther);
  if I and $0001 <> 0 then
    Include(DirRec.Permissions, tpExecuteByOther);
  if I and $0200 <> 0 then
    Include(DirRec.Mode, tmSaveText);
  if I and $0400 <> 0 then
    Include(DirRec.Mode, tmSetGid);
  if I and $0800 <> 0 then
    Include(DirRec.Mode, tmSetUid);
  case Header.LinkFlag of
    #0, '0': DirRec.FileType := ftNormal;
    '1': DirRec.FileType := ftLink;
    '2': DirRec.FileType := ftSymbolicLink;
    '3': DirRec.FileType := ftCharacter;
    '4': DirRec.FileType := ftBlock;
    '5': DirRec.FileType := ftDirectory;
    '6': DirRec.FileType := ftFifo;
    '7': DirRec.FileType := ftContiguous;
    'D': DirRec.FileType := ftDumpDir;
    'M': DirRec.FileType := ftMultiVolume;
    'V': DirRec.FileType := ftVolumeHeader;
  end;
  DirRec.LinkName := ExtractText(Header.LinkName);
  DirRec.UID := ExtractNumber(@Header.UID);
  DirRec.GID := ExtractNumber(@Header.GID);
  DirRec.UserName := ExtractText(Header.UName);
  DirRec.GroupName := ExtractText(Header.GName);
  DirRec.Magic := Trim(ExtractText(Header.Magic));
  DirRec.MajorDevNo := ExtractNumber(@Header.DevMajor);
  DirRec.MinorDevNo := ExtractNumber(@Header.DevMinor);

  HeaderChkSum := ExtractNumber(@Header.ChkSum); // Calc Checksum
  CheckSum := 0;
  StrMove(Header.ChkSum, CHKBLANKS, 8);
  for I := 0 to SizeOf(TTarHeader) - 1 do
    INC(CheckSum, INTEGER(ORD(Rec[I])));
  DirRec.CheckSumOK := WORD(CheckSum) = WORD(HeaderChkSum);

  if DirRec.FileType in [ftLink, ftSymbolicLink, ftDirectory, ftFifo, ftVolumeHeader]
    then
    FBytesToGo := 0
  else
    FBytesToGo := DirRec.Size;
end;

procedure TTarArchive.ReadFile(Buffer: POINTER);
          // Reads file data for the last Directory Record. The entire file is read into the buffer.
          // The buffer must be large enough to take up the whole file.
var
  RestBytes: INTEGER;
begin
  if FBytesToGo = 0 then
    EXIT;
  RestBytes := Records(FBytesToGo) * RECORDSIZE - FBytesToGo;
  FStream.ReadBuffer(Buffer^, FBytesToGo);
  FStream.Seek(RestBytes, soFromCurrent);
  FBytesToGo := 0;
end;

procedure TTarArchive.ReadFile(Stream: TStream);
          // Reads file data for the last Directory Record.
          // The entire file is written out to the stream.
          // The stream is left at its current position prior to writing
var
  RestBytes: INTEGER;
begin
  if FBytesToGo = 0 then
    EXIT;
  RestBytes := Records(FBytesToGo) * RECORDSIZE - FBytesToGo;
  Stream.CopyFrom(FStream, FBytesToGo);
  FStream.Seek(RestBytes, soFromCurrent);
  FBytesToGo := 0;
end;

procedure TTarArchive.ReadFile(Filename: string);
          // Reads file data for the last Directory Record.
          // The entire file is saved in the given Filename
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(Filename, fmCreate);
  try
    ReadFile(FS);
  finally
    FS.Free;
  end;
end;

function TTarArchive.ReadFile: string;
          // Reads file data for the last Directory Record. The entire file is returned
          // as a large ANSI string.
var
  RestBytes: INTEGER;
begin
  if FBytesToGo = 0 then
    EXIT;
  RestBytes := Records(FBytesToGo) * RECORDSIZE - FBytesToGo;
  SetLength(Result, FBytesToGo);
  FStream.ReadBuffer(PChar(Result)^, FBytesToGo);
  FStream.Seek(RestBytes, soFromCurrent);
  FBytesToGo := 0;
end;

procedure TTarArchive.GetFilePos(var Current, Size: INT64);
          // Returns the Current Position in the TAR stream
begin
  Current := FStream.Position;
  Size := FStream.Size;
end;

procedure TTarArchive.SetFilePos(NewPos: INT64); // Set new Current File Position
begin
  if NewPos < FStream.Size then
    FStream.Seek(NewPos, soFromBeginning);
end;

(*
===============================================================================================
TTarWriter
===============================================================================================
*)

constructor TTarWriter.CreateEmpty;
var
  TP: TTarPermission;
begin
  inherited Create;
  FOwnsStream := FALSE;
  FFinalized := FALSE;
  FPermissions := [];
  for TP := Low(TP) to High(TP) do
    Include(FPermissions, TP);
  FUID := 0;
  FGID := 0;
  FUserName := '';
  FGroupName := '';
  FMode := [];
  FMagic := 'ustar';
end;

constructor TTarWriter.Create(TargetStream: TStream);
begin
  CreateEmpty;
  FStream := TargetStream;
  FOwnsStream := FALSE;
end;

constructor TTarWriter.Create(TargetFilename: string; Mode: INTEGER = fmCreate);
begin
  CreateEmpty;
  FStream := TFileStream.Create(TargetFilename, Mode);
  FOwnsStream := TRUE;
end;

destructor TTarWriter.Destroy;
begin
  if not FFinalized then
  begin
    Finalize;
    FFinalized := TRUE;
  end;
  if FOwnsStream then
    FStream.Free;
  inherited Destroy;
end;

procedure TTarWriter.AddFile(Filename: string; TarFilename: string = '');
var
  S: TFileStream;
  Date: TDateTime;
begin
  Date := FileTimeGMT(Filename);
  if TarFilename = ''
    then
    TarFilename := ConvertFilename(Filename)
  else
    TarFilename := ConvertFilename(TarFilename);
  S := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    AddStream(S, TarFilename, Date);
  finally
    S.Free
  end;
end;

procedure TTarWriter.AddStream(Stream: TStream; TarFilename: string; FileDateGmt: TDateTime);
var
  DirRec: TTarDirRec;
  Rec: array[0..RECORDSIZE - 1] of CHAR;
  BytesToRead: INT64; // Bytes to read from the Source Stream
  BlockSize: INT64; // Bytes to write out for the current record
begin
  ClearDirRec(DirRec);
  DirRec.Name := TarFilename;
  DirRec.Size := Stream.Size - Stream.Position;
  DirRec.DateTime := FileDateGmt;
  DirRec.Permissions := FPermissions;
  DirRec.FileType := ftNormal;
  DirRec.LinkName := '';
  DirRec.UID := FUID;
  DirRec.GID := FGID;
  DirRec.UserName := FUserName;
  DirRec.GroupName := FGroupName;
  DirRec.ChecksumOK := TRUE;
  DirRec.Mode := FMode;
  DirRec.Magic := FMagic;
  DirRec.MajorDevNo := 0;
  DirRec.MinorDevNo := 0;

  WriteTarHeader(FStream, DirRec);
  BytesToRead := DirRec.Size;
  while BytesToRead > 0 do
  begin
    BlockSize := BytesToRead;
    if BlockSize > RECORDSIZE then
      BlockSize := RECORDSIZE;
    FillChar(Rec, RECORDSIZE, 0);
    Stream.Read(Rec, BlockSize);
    FStream.Write(Rec, RECORDSIZE);
    DEC(BytesToRead, BlockSize);
  end;
end;

procedure TTarWriter.AddString(Contents: string; TarFilename: string; FileDateGmt: TDateTime);
var
  S: TStringStream;
begin
  S := TStringStream.Create(Contents);
  try
    AddStream(S, TarFilename, FileDateGmt);
  finally
    S.Free
  end
end;

procedure TTarWriter.AddDir(Dirname: string; DateGmt: TDateTime; MaxDirSize: INT64 = 0);
var
  DirRec: TTarDirRec;
begin
  ClearDirRec(DirRec);
  DirRec.Name := Dirname;
  DirRec.Size := MaxDirSize;
  DirRec.DateTime := DateGmt;
  DirRec.Permissions := FPermissions;
  DirRec.FileType := ftDirectory;
  DirRec.LinkName := '';
  DirRec.UID := FUID;
  DirRec.GID := FGID;
  DirRec.UserName := FUserName;
  DirRec.GroupName := FGroupName;
  DirRec.ChecksumOK := TRUE;
  DirRec.Mode := FMode;
  DirRec.Magic := FMagic;
  DirRec.MajorDevNo := 0;
  DirRec.MinorDevNo := 0;

  WriteTarHeader(FStream, DirRec);
end;

procedure TTarWriter.AddSymbolicLink(Filename, Linkname: string; DateGmt: TDateTime);
var
  DirRec: TTarDirRec;
begin
  ClearDirRec(DirRec);
  DirRec.Name := Filename;
  DirRec.Size := 0;
  DirRec.DateTime := DateGmt;
  DirRec.Permissions := FPermissions;
  DirRec.FileType := ftSymbolicLink;
  DirRec.LinkName := Linkname;
  DirRec.UID := FUID;
  DirRec.GID := FGID;
  DirRec.UserName := FUserName;
  DirRec.GroupName := FGroupName;
  DirRec.ChecksumOK := TRUE;
  DirRec.Mode := FMode;
  DirRec.Magic := FMagic;
  DirRec.MajorDevNo := 0;
  DirRec.MinorDevNo := 0;

  WriteTarHeader(FStream, DirRec);
end;

procedure TTarWriter.AddLink(Filename, Linkname: string; DateGmt: TDateTime);
var
  DirRec: TTarDirRec;
begin
  ClearDirRec(DirRec);
  DirRec.Name := Filename;
  DirRec.Size := 0;
  DirRec.DateTime := DateGmt;
  DirRec.Permissions := FPermissions;
  DirRec.FileType := ftLink;
  DirRec.LinkName := Linkname;
  DirRec.UID := FUID;
  DirRec.GID := FGID;
  DirRec.UserName := FUserName;
  DirRec.GroupName := FGroupName;
  DirRec.ChecksumOK := TRUE;
  DirRec.Mode := FMode;
  DirRec.Magic := FMagic;
  DirRec.MajorDevNo := 0;
  DirRec.MinorDevNo := 0;

  WriteTarHeader(FStream, DirRec);
end;

procedure TTarWriter.AddVolumeHeader(VolumeId: string; DateGmt: TDateTime);
var
  DirRec: TTarDirRec;
begin
  ClearDirRec(DirRec);
  DirRec.Name := VolumeId;
  DirRec.Size := 0;
  DirRec.DateTime := DateGmt;
  DirRec.Permissions := FPermissions;
  DirRec.FileType := ftVolumeHeader;
  DirRec.LinkName := '';
  DirRec.UID := FUID;
  DirRec.GID := FGID;
  DirRec.UserName := FUserName;
  DirRec.GroupName := FGroupName;
  DirRec.ChecksumOK := TRUE;
  DirRec.Mode := FMode;
  DirRec.Magic := FMagic;
  DirRec.MajorDevNo := 0;
  DirRec.MinorDevNo := 0;

  WriteTarHeader(FStream, DirRec);
end;

procedure TTarWriter.Finalize;
          // Writes the End-Of-File Tag
          // Data after this tag will be ignored
          // The destructor calls this automatically if you didn't do it before
var
  Rec: array[0..RECORDSIZE - 1] of CHAR;
begin
  FillChar(Rec, SizeOf(Rec), 0);
  FStream.Write(Rec, RECORDSIZE);
  FFinalized := TRUE;
end;

end.
