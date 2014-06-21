unit KAZip;

interface

{$DEFINE USE_BZIP2}

uses
  Windows,
  SysUtils,
  Classes,
  Masks,
  TypInfo,
{$IFDEF USE_BZIP2}
  BZip2,
{$ENDIF}
  ZLib;

type
  TKAZipEntries = class;
  TKAZip = class;
  TBytes = array of Byte;
  TZipSaveMethod = (FastSave, RebuildAll);
  TZipCompressionType = (ctNormal, ctMaximum, ctFast, ctSuperFast, ctNone,
    ctUnknown);
  TZipCompressionMethod = (cmStored, cmShrunk, cmReduced1, cmReduced2,
    cmReduced3, cmReduced4, cmImploded, cmTokenizingReserved, cmDeflated,
    cmDeflated64, cmDCLImploding, cmPKWAREReserved);
  TOverwriteAction = (oaSkip, oaSkipAll, oaOverwrite, oaOverwriteAll);

  TOnDecompressFile = procedure(Sender: TObject;
    Current, Total: Integer) of object;
  TOnCompressFile = procedure(Sender: TObject;
    Current, Total: Integer) of object;
  TOnZipOpen = procedure(Sender: TObject; Current, Total: Integer) of object;
  TOnZipChange = procedure(Sender: TObject; ChangeType: Integer) of object;
  TOnAddItem = procedure(Sender: TObject; const ItemName: string) of object;
  TOnRebuildZip = procedure(Sender: TObject; Current, Total: Integer) of object;
  TOnRemoveItems = procedure(Sender: TObject;
    Current, Total: Integer) of object;
  TOnOverwriteFile = procedure(Sender: TObject; var FileName: string;
    var Action: TOverwriteAction) of object;

  {
    0 - The file is stored (no compression)
    1 - The file is Shrunk
    2 - The file is Reduced with compression factor 1
    3 - The file is Reduced with compression factor 2
    4 - The file is Reduced with compression factor 3
    5 - The file is Reduced with compression factor 4
    6 - The file is Imploded
    7 - Reserved for Tokenizing compression algorithm
    8 - The file is Deflated
    9 - Enhanced Deflating using Deflate64(tm)
    10 - PKWARE Data Compression Library Imploding
    11 - Reserved by PKWARE
    12 - File is compressed using BZIP2 algorithm
    }

  { DoChange Events
    0 - Zip is Closed;
    1 - Zip is Opened;
    2 - Item is added to the zip
    3 - Item is removed from the Zip
    4 - Item comment changed
    5 - Item name changed
    6 - Item name changed
    }

  TZLibStreamHeader = packed record
    CMF: Byte;
    FLG: Byte;
  end;

  TLocalFile = packed record
    LocalFileHeaderSignature: Cardinal; // 4 bytes  (0x04034b50)
    VersionNeededToExtract: WORD; // 2 bytes
    GeneralPurposeBitFlag: WORD; // 2 bytes
    CompressionMethod: WORD; // 2 bytes
    LastModFileTimeDate: Cardinal; // 4 bytes
    Crc32: Cardinal; // 4 bytes
    CompressedSize: Cardinal; // 4 bytes
    UncompressedSize: Cardinal; // 4 bytes
    FilenameLength: WORD; // 2 bytes
    ExtraFieldLength: WORD; // 2 bytes
    FileName: AnsiString; // variable size
    ExtraField: AnsiString; // variable size
    CompressedData: AnsiString; // variable size
  end;

  TDataDescriptor = packed record
    DescriptorSignature: Cardinal; // 4 bytes UNDOCUMENTED
    Crc32: Cardinal; // 4 bytes
    CompressedSize: Cardinal; // 4 bytes
    UncompressedSize: Cardinal; // 4 bytes
  end;

  TCentralDirectoryFile = packed record
    CentralFileHeaderSignature: Cardinal; // 4 bytes  (0x02014b50)
    VersionMadeBy: WORD; // 2 bytes
    VersionNeededToExtract: WORD; // 2 bytes
    GeneralPurposeBitFlag: WORD; // 2 bytes
    CompressionMethod: WORD; // 2 bytes
    LastModFileTimeDate: Cardinal; // 4 bytes
    Crc32: Cardinal; // 4 bytes
    CompressedSize: Cardinal; // 4 bytes
    UncompressedSize: Cardinal; // 4 bytes
    FilenameLength: WORD; // 2 bytes
    ExtraFieldLength: WORD; // 2 bytes
    FileCommentLength: WORD; // 2 bytes
    DiskNumberStart: WORD; // 2 bytes
    InternalFileAttributes: WORD; // 2 bytes
    ExternalFileAttributes: Cardinal; // 4 bytes
    RelativeOffsetOfLocalHeader: Cardinal; // 4 bytes
    FileName: AnsiString; // variable size
    ExtraField: AnsiString; // variable size
    FileComment: AnsiString; // variable size
  end;

  TEndOfCentralDir = packed record
    EndOfCentralDirSignature: Cardinal; // 4 bytes  (0x06054b50)
    NumberOfThisDisk: WORD; // 2 bytes
    NumberOfTheDiskWithTheStart: WORD; // 2 bytes
    TotalNumberOfEntriesOnThisDisk: WORD; // 2 bytes
    TotalNumberOfEntries: WORD; // 2 bytes
    SizeOfTheCentralDirectory: Cardinal; // 4 bytes
    OffsetOfStartOfCentralDirectory: Cardinal; // 4 bytes
    ZipfileCommentLength: WORD; // 2 bytes
  end;

  TKAZipEntriesEntry = class(TCollectionItem)
  private
    { Private declarations }
    FParent: TKAZipEntries;
    FCentralDirectoryFile: TCentralDirectoryFile;
    FLocalFile: TLocalFile;
    FIsEncrypted: Boolean;
    FIsFolder: Boolean;
    FDate: TDateTime;
    FCompressionType: TZipCompressionType;
    FSelected: Boolean;

    procedure SetSelected(const Value: Boolean);
    function GetLocalEntrySize: Cardinal;
    function GetCentralEntrySize: Cardinal;
    procedure SetComment(const Value: string);
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    function GetComment: string;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetCompressedData: TBytes; overload;
    function GetCompressedData(Stream: TStream): Integer; overload;
    procedure ExtractToFile(const FileName: string);
    procedure ExtractToStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    function Test: Boolean;

    property FileName: string read GetFileName write
      SetFileName;
    property Comment: string read GetComment write
      SetComment;
    property SizeUncompressed
      : Cardinal read FCentralDirectoryFile.UncompressedSize;
    property SizeCompressed: Cardinal read FCentralDirectoryFile.CompressedSize;
    property Date: TDateTime read FDate;
    property Crc32: Cardinal read FCentralDirectoryFile.Crc32;
    property Attributes: Cardinal read FCentralDirectoryFile.
      ExternalFileAttributes;
    property LocalOffset: Cardinal read FCentralDirectoryFile.
      RelativeOffsetOfLocalHeader;
    property IsEncrypted: Boolean read FIsEncrypted;
    property IsFolder: Boolean read FIsFolder;
    property BitFlag: WORD read FCentralDirectoryFile.GeneralPurposeBitFlag;
    property CompressionMethod
      : WORD read FCentralDirectoryFile.CompressionMethod;
    property CompressionType: TZipCompressionType read FCompressionType;
    property LocalEntrySize: Cardinal read GetLocalEntrySize;
    property CentralEntrySize: Cardinal read GetCentralEntrySize;
    property Selected: Boolean read FSelected write SetSelected;
  end;

  TKAZipEntries = class(TCollection)
  private
    { Private declarations }
    FParent: TKAZip;
    FIsZipFile: Boolean;
    FLocalHeaderNumFiles: Integer;

    function GetHeaderEntry(index: Integer): TKAZipEntriesEntry;
    procedure SetHeaderEntry(index: Integer; const Value: TKAZipEntriesEntry);
  protected
    { Protected declarations }
    function ReadBA(MS: TStream; Sz, Poz: Integer): TBytes;
    function Adler32(adler: uLong; buf: pByte; len: uInt): uLong;
    function CalcCRC32(const UncompressedData: TBytes): Cardinal;
    function CalculateCRCFromStream(Stream: TStream): Cardinal;
    function RemoveRootName(const FileName, RootName: string): string;
    procedure SortList(List: TList);
    function FileTime2DateTime(FileTime: TFileTime): TDateTime;
    // **************************************************************************
    function FindCentralDirectory(MS: TStream): Boolean;
    function ParseCentralHeaders(MS: TStream): Boolean;
    procedure GetLocalEntry(MS: TStream; Offset: Integer; HeaderOnly: Boolean;
      var Result: TLocalFile);
    procedure LoadLocalHeaders(MS: TStream);
    function ParseLocalHeaders(MS: TStream): Boolean;

    // **************************************************************************
    procedure Remove(ItemIndex: Integer; Flush: Boolean); overload;
    procedure RemoveBatch(Files: TList);
    procedure InternalExtractToFile(Item: TKAZipEntriesEntry; FileName: string);
    // **************************************************************************
    function AddStreamFast(const AItemName: string; FileAttr: WORD;
      FileDate: TDateTime; Stream: TStream): TKAZipEntriesEntry; overload;
    function AddStreamRebuild(const AItemName: string; FileAttr: WORD;
      FileDate: TDateTime; Stream: TStream): TKAZipEntriesEntry;
    function AddFolderChain(const ItemName: string): Boolean; overload;
    function AddFolderChain(const ItemName: string; FileAttr: WORD;
      FileDate: TDateTime): Boolean; overload;
    function AddFolderEx(const FolderName: string; const RootFolder: string;
      const WildCard: string; WithSubFolders: Boolean): Boolean;
    // **************************************************************************
  public
    { Public declarations }
    procedure ParseZip(MS: TStream);
    constructor Create(AOwner: TKAZip; MS: TStream); overload;
    constructor Create(AOwner: TKAZip); overload;
    destructor Destroy; override;
    // **************************************************************************
    function IndexOf(const FileName: string): Integer;
    // **************************************************************************
    function AddFile(const FileName, NewFileName: string): TKAZipEntriesEntry;
      overload;
    function AddFile(const FileName: string): TKAZipEntriesEntry; overload;
    function AddFiles(FileNames: TStrings): Boolean;
    function AddFolder(const FolderName: string; const RootFolder: string;
      const WildCard: string; WithSubFolders: Boolean): Boolean;
    function AddFilesAndFolders(FileNames: TStrings; const RootFolder: string;
      WithSubFolders: Boolean): Boolean;
    function AddStream(const FileName: string; FileAttr: WORD; FileDate: TDateTime;
      Stream: TStream): TKAZipEntriesEntry; overload;
    function AddStream(const FileName: string; Stream: TStream): TKAZipEntriesEntry;
      overload;
    // **************************************************************************
    procedure Remove(ItemIndex: Integer); overload;
    procedure Remove(Item: TKAZipEntriesEntry); overload;
    procedure Remove(const FileName: string); overload;
    procedure RemoveFiles(List: TList);
    procedure RemoveSelected;
    procedure Rebuild;
    // **************************************************************************
    procedure Select(const WildCard: string);
    procedure SelectAll;
    procedure DeSelectAll;
    procedure InvertSelection;
    // **************************************************************************
    procedure Rename(Item: TKAZipEntriesEntry; const NewFileName: string); overload;
    procedure Rename(ItemIndex: Integer; const NewFileName: string); overload;
    procedure Rename(const FileName: string; const NewFileName: string); overload;
    procedure CreateFolder(const FolderName: string; FolderDate: TDateTime);
    procedure RenameFolder(const FolderName: string; const NewFolderName: string);
    procedure RenameMultiple(Names: TStringList; NewNames: TStringList);

    // **************************************************************************
    procedure ExtractToFile(Item: TKAZipEntriesEntry; const AFileName: string);
      overload;
    procedure ExtractToFile(ItemIndex: Integer; const AFileName: string); overload;
    procedure ExtractToFile(const FileName, ADestinationFileName: string); overload;
    procedure ExtractToStream(Item: TKAZipEntriesEntry; Stream: TStream);
    procedure ExtractAll(const TargetDirectory: string);
    procedure ExtractSelected(const TargetDirectory: string);
    // **************************************************************************
    property Items[index: Integer]
      : TKAZipEntriesEntry read GetHeaderEntry write SetHeaderEntry;
  end;

  TKAZip = class(TComponent)
  private
    { Private declarations }
    FZipHeader: TKAZipEntries;
    FIsDirty: Boolean;
    FEndOfCentralDirPos: Cardinal;
    FEndOfCentralDir: TEndOfCentralDir;

    FZipCommentPos: Cardinal;
    FZipComment: TStringList;

    FRebuildECDP: Cardinal;
    FRebuildCP: Cardinal;

    FIsZipFile: Boolean;
    FHasBadEntries: Boolean;
    FFileName: string;
    FFileNames: TStringList;
    FZipSaveMethod: TZipSaveMethod;

    FExternalStream: Boolean;
    FStoreRelativePath: Boolean;
    FZipCompressionType: TZipCompressionType;

    FCurrentDFS: Cardinal;
    FOnDecompressFile: TOnDecompressFile;
    FOnCompressFile: TOnCompressFile;
    FOnZipChange: TOnZipChange;
    FBatchMode: Boolean;

    NewLHOffsets: array of Cardinal;
    NewEndOfCentralDir: TEndOfCentralDir;
    FOnZipOpen: TOnZipOpen;
    FUseTempFiles: Boolean;
    FStoreFolders: Boolean;
    FOnAddItem: TOnAddItem;
    FComponentVersion: string;
    FOnRebuildZip: TOnRebuildZip;
    FOnRemoveItems: TOnRemoveItems;
    FOverwriteAction: TOverwriteAction;
    FOnOverwriteFile: TOnOverwriteFile;
    FReadOnly: Boolean;
    FApplyAttributes: Boolean;

    procedure SetFileName(const Value: string);
    procedure SetIsZipFile(const Value: Boolean);
    function GetComment: TStrings;
    procedure SetComment(const Value: TStrings);
    procedure SetZipSaveMethod(const Value: TZipSaveMethod);
    procedure SetActive(const Value: Boolean);
    procedure SetZipCompressionType(const Value: TZipCompressionType);
    function GetFileNames: TStrings;
    procedure SetFileNames(const Value: TStrings);
    procedure SetUseTempFiles(const Value: Boolean);
    procedure SetStoreFolders(const Value: Boolean);
    procedure SetOnAddItem(const Value: TOnAddItem);
    procedure SetComponentVersion(const Value: string);
    procedure SetOnRebuildZip(const Value: TOnRebuildZip);
    procedure SetOnRemoveItems(const Value: TOnRemoveItems);
    procedure SetOverwriteAction(const Value: TOverwriteAction);
    procedure SetOnOverwriteFile(const Value: TOnOverwriteFile);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetApplyAtributes(const Value: Boolean);
  protected
    { Protected declarations }
    FZipStream: TStream;
    // **************************************************************************
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(MS: TStream);
    // **************************************************************************
    procedure RebuildLocalFiles(MS: TStream);
    procedure RebuildCentralDirectory(MS: TStream);
    procedure RebuildEndOfCentralDirectory(MS: TStream);
    // **************************************************************************
    procedure OnDecompress(Sender: TObject);
    procedure OnCompress(Sender: TObject);
    procedure DoChange(Sender: TObject; const ChangeType: Integer); virtual;
    // **************************************************************************
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // **************************************************************************
    function GetDelphiTempFileName: string;
    function GetFileName(const S: string): string;
    function GetFilePath(const S: string): string;
    // **************************************************************************
    procedure CreateZip(Stream: TStream); overload;
    procedure CreateZip(const FileName: string); overload;
    procedure Open(const FileName: string); overload;
    procedure Open(MS: TStream); overload;
    procedure SaveToStream(Stream: TStream);
    procedure Rebuild;
    procedure FixZip(MS: TStream);
    procedure Close;
    // **************************************************************************
    function AddFile(const FileName, NewFileName: string): TKAZipEntriesEntry;
      overload;
    function AddFile(const FileName: string): TKAZipEntriesEntry; overload;
    function AddFiles(FileNames: TStrings): Boolean;
    function AddFolder(const FolderName: string; const RootFolder: string;
      const WildCard: string; WithSubFolders: Boolean): Boolean;
    function AddFilesAndFolders(FileNames: TStrings; const RootFolder: string;
      WithSubFolders: Boolean): Boolean;
    function AddStream(const FileName: string; FileAttr: WORD; FileDate: TDateTime;
      Stream: TStream): TKAZipEntriesEntry; overload;
    function AddStream(const FileName: string; Stream: TStream): TKAZipEntriesEntry;
      overload;
    // **************************************************************************
    procedure Remove(ItemIndex: Integer); overload;
    procedure Remove(Item: TKAZipEntriesEntry); overload;
    procedure Remove(const FileName: string); overload;
    procedure RemoveFiles(List: TList);
    procedure RemoveSelected;
    // **************************************************************************
    procedure Select(const WildCard: string);
    procedure SelectAll;
    procedure DeSelectAll;
    procedure InvertSelection;
    // **************************************************************************
    procedure Rename(Item: TKAZipEntriesEntry; const NewFileName: string); overload;
    procedure Rename(ItemIndex: Integer; const NewFileName: string); overload;
    procedure Rename(const FileName: string; const NewFileName: string); overload;
    procedure CreateFolder(const FolderName: string; FolderDate: TDateTime);
    procedure RenameFolder(const FolderName: string; const NewFolderName: string);
    procedure RenameMultiple(Names: TStringList; NewNames: TStringList);
    // **************************************************************************
    procedure ExtractToFile(Item: TKAZipEntriesEntry; const FileName: string);
      overload;
    procedure ExtractToFile(ItemIndex: Integer; const FileName: string); overload;
    procedure ExtractToFile(const FileName, DestinationFileName: string); overload;
    procedure ExtractToStream(Item: TKAZipEntriesEntry; Stream: TStream);
    procedure ExtractAll(const TargetDirectory: string);
    procedure ExtractSelected(const TargetDirectory: string);
    // **************************************************************************
    property Entries: TKAZipEntries read FZipHeader;
    property HasBadEntries: Boolean read FHasBadEntries;
  published
    { Published declarations }
    property FileName: string read FFileName write SetFileName;
    property IsZipFile: Boolean read FIsZipFile write SetIsZipFile;
    property SaveMethod: TZipSaveMethod read FZipSaveMethod write
      SetZipSaveMethod;
    property StoreRelativePath
      : Boolean read FStoreRelativePath write FStoreRelativePath;
    property StoreFolders: Boolean read FStoreFolders write SetStoreFolders;
    property CompressionType: TZipCompressionType read FZipCompressionType
      write SetZipCompressionType;
    property Comment: TStrings read GetComment write SetComment;
    property FileNames: TStrings read GetFileNames write SetFileNames;
    property UseTempFiles: Boolean read FUseTempFiles write SetUseTempFiles;
    property OverwriteAction: TOverwriteAction read FOverwriteAction write
      SetOverwriteAction;
    property ComponentVersion: string read FComponentVersion write
      SetComponentVersion;
    property readonly: Boolean read FReadOnly write SetReadOnly;
    property ApplyAtributes
      : Boolean read FApplyAttributes write SetApplyAtributes;
    property OnDecompressFile: TOnDecompressFile read FOnDecompressFile write
      FOnDecompressFile;
    property OnCompressFile
      : TOnCompressFile read FOnCompressFile write FOnCompressFile;
    property OnZipChange: TOnZipChange read FOnZipChange write FOnZipChange;
    property OnZipOpen: TOnZipOpen read FOnZipOpen write FOnZipOpen;
    property OnAddItem: TOnAddItem read FOnAddItem write SetOnAddItem;
    property OnRebuildZip: TOnRebuildZip read FOnRebuildZip write
      SetOnRebuildZip;
    property OnRemoveItems: TOnRemoveItems read FOnRemoveItems write
      SetOnRemoveItems;
    property OnOverwriteFile: TOnOverwriteFile read FOnOverwriteFile write
      SetOnOverwriteFile;
    property Active: Boolean read FIsZipFile write SetActive;
  end;

procedure register;
function ToZipName(const FileName: string): string;
function ToDosName(const FileName: string): string;

implementation

{ File attribute constants }
const
  faReadOnly  = $00000001;
  faHidden    = $00000002;
  faSysFile   = $00000004;
  faDirectory = $00000010;
  faArchive   = $00000020;
  faSymLink   = $00000040;
  faNormal    = $00000080;
  faTemporary = $00000100;
  faAnyFile   = $000001FF;

const
  ZL_DEF_COMPRESSIONMETHOD = $8; { Deflate }
  ZL_ENCH_COMPRESSIONMETHOD = $9; { Enchanced Deflate }
  ZL_DEF_COMPRESSIONINFO = $7; { 32k window for Deflate }
  ZL_PRESET_DICT = $20;

  ZL_FASTEST_COMPRESSION = $0;
  ZL_FAST_COMPRESSION = $1;
  ZL_DEFAULT_COMPRESSION = $2;
  ZL_MAXIMUM_COMPRESSION = $3;

  ZL_FCHECK_MASK = $1F;
  ZL_CINFO_MASK = $F0; { mask out leftmost 4 bits }
  ZL_FLEVEL_MASK = $C0; { mask out leftmost 2 bits }
  ZL_CM_MASK = $0F; { mask out rightmost 4 bits }

  ZL_MULTIPLE_DISK_SIG = $08074B50; // 'PK'#7#8
  ZL_DATA_DESCRIPT_SIG = $08074B50; // 'PK'#7#8
  ZL_LOCAL_HEADERSIG = $04034B50; // 'PK'#3#4
  ZL_CENTRAL_HEADERSIG = $02014B50; // 'PK'#1#2
  ZL_EOC_HEADERSIG = $06054B50; // 'PK'#5#6

const
  CRCTable: array [0 .. 255] of Cardinal = ($00000000, $77073096, $EE0E612C,
    $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3, $0EDB8832,
    $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07,
    $90BF1D91, $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D,
    $6DDDE4EB, $F4D4B551, $83D385C7, $136C9856, $646BA8C0, $FD62F97A,
    $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5, $3B6E20C8,
    $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD,
    $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3,
    $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180,
    $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E,
    $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB,
    $B6662D3D, $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589,
    $06B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2, $0F00F934, $9609A88E,
    $E10E9818, $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01, $6B6B51F4,
    $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1,
    $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF,
    $15DA2D49, $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074,
    $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A,
    $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F,
    $DD0D7CC9, $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525,
    $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998, $B0D09822,
    $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD, $EDB88320,
    $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615,
    $73DC1683, $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B,
    $9309FF9D, $0A00AE27, $7D079EB1, $F00F9344, $8708A3D2, $1E01F268,
    $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7, $FED41B76,
    $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43,
    $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1,
    $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6,
    $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C,
    $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9,
    $5505262F, $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7,
    $B5D0CF31, $2CD99E8B, $5BDEAE1D, $9B64C2B0, $EC63F226, $756AA39C,
    $026D930A, $9C0906A9, $EB0E363F, $72076785, $05005713, $95BF4A82,
    $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7,
    $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD,
    $F6B9265B, $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA,
    $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45, $A00AE278,
    $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D,
    $3E6E77DB, $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53,
    $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C, $CABAC28A, $53B39330,
    $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF, $B3667A2E,
    $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B,
    $2D02EF8D);

procedure register;
begin
  RegisterComponents('KA', [TKAZip]);
end;

function ToZipName(const FileName: string): string;
var
  P: Integer;
begin
  Result := FileName;
  Result := StringReplace(Result, '\', '/', [rfReplaceAll]);
  P := Pos(':/', Result);
  if P > 0 then
  begin
    System.Delete(Result, 1, P + 1);
  end;
  P := Pos('//', Result);
  if P > 0 then
  begin
    System.Delete(Result, 1, P + 1);
    P := Pos('/', Result);
    if P > 0 then
    begin
      System.Delete(Result, 1, P);
      P := Pos('/', Result);
      if P > 0 then
        System.Delete(Result, 1, P);
    end;
  end;
end;

function ToDosName(const FileName: string): string;
var
  P: Integer;
begin
  Result := FileName;
  Result := StringReplace(Result, '\', '/', [rfReplaceAll]);
  P := Pos(':/', Result);
  if P > 0 then
  begin
    System.Delete(Result, 1, P + 1);
  end;
  P := Pos('//', Result);
  if P > 0 then
  begin
    System.Delete(Result, 1, P + 1);
    P := Pos('/', Result);
    if P > 0 then
    begin
      System.Delete(Result, 1, P);
      P := Pos('/', Result);
      if P > 0 then
        System.Delete(Result, 1, P);
    end;
  end;
  Result := StringReplace(Result, '/', '\', [rfReplaceAll]);
end;

function FileSetAttr(const FileName: string; Attr: Integer): Integer;
begin
  Result := 0;
  if not SetFileAttributes(PChar(FileName), Attr) then
    Result := GetLastError;
end;

{ TKAZipEntriesEntry }

constructor TKAZipEntriesEntry.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FParent := TKAZipEntries(Collection);
  FSelected := False;
end;

destructor TKAZipEntriesEntry.Destroy;
begin

  inherited Destroy;
end;

procedure TKAZipEntriesEntry.ExtractToFile(const FileName: string);
begin
  FParent.ExtractToFile(Self, FileName);
end;

procedure TKAZipEntriesEntry.ExtractToStream(Stream: TStream);
begin
  FParent.ExtractToStream(Self, Stream);
end;

procedure TKAZipEntriesEntry.SaveToFile(const FileName: string);
begin
  ExtractToFile(FileName);
end;

procedure TKAZipEntriesEntry.SaveToStream(Stream: TStream);
begin
  ExtractToStream(Stream);
end;

function TKAZipEntriesEntry.GetComment: string;
begin
  Result := string(FCentralDirectoryFile.FileComment);
end;

function TKAZipEntriesEntry.GetCompressedData(Stream: TStream): Integer;
var
  FZLHeader: TZLibStreamHeader;
  BA: TLocalFile;
  ZLH: WORD;
  Compress: Byte;
begin
  Result := 0;
  if (CompressionMethod = 8) then
  begin
    FZLHeader.CMF := (ZL_DEF_COMPRESSIONINFO shl 4); { 32k Window size }
    FZLHeader.CMF := FZLHeader.CMF or ZL_DEF_COMPRESSIONMETHOD; { Deflate }
    Compress := ZL_DEFAULT_COMPRESSION;
    case BitFlag and 6 of
      0:
        Compress := ZL_DEFAULT_COMPRESSION;
      2:
        Compress := ZL_MAXIMUM_COMPRESSION;
      4:
        Compress := ZL_FAST_COMPRESSION;
      6:
        Compress := ZL_FASTEST_COMPRESSION;
    end;
    FZLHeader.FLG := FZLHeader.FLG or (Compress shl 6);
    FZLHeader.FLG := FZLHeader.FLG and not ZL_PRESET_DICT;
    { no preset dictionary }
    FZLHeader.FLG := FZLHeader.FLG and not ZL_FCHECK_MASK;
    ZLH := (FZLHeader.CMF * 256) + FZLHeader.FLG;
    Inc(FZLHeader.FLG, 31 - (ZLH mod 31));
    Result := Result + Stream.write(FZLHeader, SizeOf(FZLHeader));
  end;
  FParent.GetLocalEntry(FParent.FParent.FZipStream, LocalOffset, False, BA);
  if BA.LocalFileHeaderSignature <> $04034B50 then
  begin
    Result := 0;
    Exit;
  end;
  if SizeCompressed > 0 then
    Result := Result + Stream.write(BA.CompressedData[1], SizeCompressed);
end;

function TKAZipEntriesEntry.GetFileName: string;
begin
  Result := string(FCentralDirectoryFile.FileName);
end;

function TKAZipEntriesEntry.GetCompressedData: TBytes;
var
  BA: TLocalFile;
  FZLHeader: TZLibStreamHeader;
  ZLH: WORD;
  Compress: Byte;
begin
  SetLength(Result, 0);
  if (CompressionMethod = 0) or (CompressionMethod = 8) then
  begin
    FParent.GetLocalEntry(FParent.FParent.FZipStream, LocalOffset, False, BA);
    if BA.LocalFileHeaderSignature <> $04034B50 then
      Exit;
    if (CompressionMethod = 8) then
    begin
      FZLHeader.CMF := (ZL_DEF_COMPRESSIONINFO shl 4); { 32k Window size }
      FZLHeader.CMF := FZLHeader.CMF or ZL_DEF_COMPRESSIONMETHOD; { Deflate }
      Compress := ZL_DEFAULT_COMPRESSION;
      case BitFlag and 6 of
        0:
          Compress := ZL_DEFAULT_COMPRESSION;
        2:
          Compress := ZL_MAXIMUM_COMPRESSION;
        4:
          Compress := ZL_FAST_COMPRESSION;
        6:
          Compress := ZL_FASTEST_COMPRESSION;
      end;
      FZLHeader.FLG := FZLHeader.FLG or (Compress shl 6);
      FZLHeader.FLG := FZLHeader.FLG and not ZL_PRESET_DICT;
      { no preset dictionary }
      FZLHeader.FLG := FZLHeader.FLG and not ZL_FCHECK_MASK;
      ZLH := (FZLHeader.CMF * 256) + FZLHeader.FLG;
      Inc(FZLHeader.FLG, 31 - (ZLH mod 31));
      SetLength(Result, SizeOf(FZLHeader) + Length(BA.CompressedData));
      CopyMemory(Pointer(@Result[0]), Pointer(@FZLHeader), SizeOf(FZLHeader));
      CopyMemory(Pointer(@Result[SizeOf(FZLHeader)]), Pointer(BA.CompressedData), Length(BA.CompressedData));
    end
    else
    begin
      SetLength(Result, Length(BA.CompressedData));
      CopyMemory(Pointer(@Result[0]), Pointer(BA.CompressedData), Length(BA.CompressedData));
    end;
  end
  else
  begin
    SetLength(Result, 0);
  end;
end;

procedure TKAZipEntriesEntry.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
end;

function TKAZipEntriesEntry.GetLocalEntrySize: Cardinal;
begin
  Result := SizeOf(TLocalFile) - 3 * SizeOf(AnsiString)
    + FCentralDirectoryFile.CompressedSize +
    FCentralDirectoryFile.FilenameLength +
    FCentralDirectoryFile.ExtraFieldLength;
  if (FCentralDirectoryFile.GeneralPurposeBitFlag and (1 shl 3)) > 0 then
  begin
    Result := Result + SizeOf(TDataDescriptor);
  end;
end;

function TKAZipEntriesEntry.GetCentralEntrySize: Cardinal;
begin
  Result := SizeOf(TCentralDirectoryFile) - 3 * SizeOf(AnsiString)
    + FCentralDirectoryFile.FilenameLength +
    FCentralDirectoryFile.ExtraFieldLength +
    FCentralDirectoryFile.FileCommentLength;
end;

function TKAZipEntriesEntry.Test: Boolean;
var
  FS: TFileStream;
  MS: TMemoryStream;
  FN: string;
begin
  Result := True;
  try
    if not FIsEncrypted then
    begin
      if FParent.FParent.FUseTempFiles then
      begin
        FN := FParent.FParent.GetDelphiTempFileName;
        FS := TFileStream.Create(FN, fmOpenReadWrite or FmCreate);
        try
          ExtractToStream(FS);
          FS.Position := 0;
          Result := FParent.CalculateCRCFromStream(FS) = Crc32;
        finally
          FS.Free;
          DeleteFile(FN);
        end;
      end
      else
      begin
        MS := TMemoryStream.Create;
        try
          ExtractToStream(MS);
          MS.Position := 0;
          Result := FParent.CalculateCRCFromStream(MS) = Crc32;
        finally
          MS.Free;
        end;
      end;
    end;
  except
    Result := False;
  end;
end;

procedure TKAZipEntriesEntry.SetComment(const Value: string);
begin
  FCentralDirectoryFile.FileComment := AnsiString(Value);
  FCentralDirectoryFile.FileCommentLength := Length
    (FCentralDirectoryFile.FileComment);
  FParent.Rebuild;
  if not FParent.FParent.FBatchMode then
  begin
    FParent.FParent.DoChange(FParent, 4);
  end;
end;

procedure TKAZipEntriesEntry.SetFileName(const Value: string);
var
  FN: string;
begin
  FN := ToZipName(Value);
  if FParent.IndexOf(FN) > -1 then
    raise Exception.Create('File with same name already exists in Archive!');
  FCentralDirectoryFile.FileName := AnsiString(ToZipName(Value));
  FCentralDirectoryFile.FilenameLength := Length
    (FCentralDirectoryFile.FileName);
  if not FParent.FParent.FBatchMode then
  begin
    FParent.Rebuild;
    FParent.FParent.DoChange(FParent, 5);
  end;
end;

{ TKAZipEntries }
constructor TKAZipEntries.Create(AOwner: TKAZip);
begin
  inherited Create(TKAZipEntriesEntry);
  FParent := AOwner;
  FIsZipFile := False;
end;

constructor TKAZipEntries.Create(AOwner: TKAZip; MS: TStream);
begin
  inherited Create(TKAZipEntriesEntry);
  FParent := AOwner;
  FIsZipFile := False;
  FLocalHeaderNumFiles := 0;
  ParseZip(MS);
end;

destructor TKAZipEntries.Destroy;
begin

  inherited Destroy;
end;

function TKAZipEntries.Adler32(adler: uLong; buf: pByte; len: uInt): uLong;
const
  BASE = uLong(65521);
  NMAX = 3854;
var
  s1, s2: uLong;
  k: Integer;
begin
  s1 := adler and $FFFF;
  s2 := (adler shr 16) and $FFFF;

  if not Assigned(buf) then
  begin
    Adler32 := uLong(1);
    Exit;
  end;

  while (len > 0) do
  begin
    if len < NMAX then
      k := len
    else
      k := NMAX;
    Dec(len, k);
    while (k > 0) do
    begin
      Inc(s1, buf^);
      Inc(s2, s1);
      Inc(buf);
      Dec(k);
    end;
    s1 := s1 mod BASE;
    s2 := s2 mod BASE;
  end;
  Adler32 := (s2 shl 16) or s1;
end;

function TKAZipEntries.CalcCRC32(const UncompressedData: TBytes): Cardinal;
var
  X: Integer;
begin
  Result := $FFFFFFFF;
  for X := 0 to Length(UncompressedData) - 1 do
  begin
    Result := (Result shr 8) xor
      (CRCTable[Byte(Result) xor Ord(UncompressedData[X + 1])]);
  end;
  Result := Result xor $FFFFFFFF;
end;

function TKAZipEntries.CalculateCRCFromStream(Stream: TStream): Cardinal;
var
  Buffer: array [1 .. 8192] of Byte;
  I, ReadCount: Integer;
  TempResult: Longword;
begin
  TempResult := $FFFFFFFF;
  while (Stream.Position <> Stream.Size) do
  begin
    ReadCount := Stream.read(Buffer, SizeOf(Buffer));
    for I := 1 to ReadCount do
      TempResult := ((TempResult shr 8) and $FFFFFF)
        xor CRCTable[(TempResult xor Longword(Buffer[I])) and $FF];
  end;
  Result := not TempResult;
end;

function TKAZipEntries.RemoveRootName(const FileName, RootName: string): string;
var
  P: Integer;
  S: string;
begin
  Result := FileName;
  P := Pos(AnsiLowerCase(RootName), AnsiLowerCase(FileName));
  if P = 1 then
  begin
    System.Delete(Result, 1, Length(RootName));
    S := Result;
    if (Length(S) > 0) and (S[1] = '\') then
    begin
      System.Delete(S, 1, 1);
      Result := S;
    end;
  end;
end;

procedure TKAZipEntries.SortList(List: TList);
var
  X: Integer;
  I1: Cardinal;
  I2: Cardinal;
  NoChange: Boolean;
begin
  if List.Count = 1 then
    Exit;
  repeat
    NoChange := True;
    for X := 0 to List.Count - 2 do
    begin
      I1 := Integer(List.Items[X]);
      I2 := Integer(List.Items[X + 1]);
      if I1 > I2 then
      begin
        List.Exchange(X, X + 1);
        NoChange := False;
      end;
    end;
  until NoChange;
end;

function TKAZipEntries.FileTime2DateTime(FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function TKAZipEntries.GetHeaderEntry(index: Integer): TKAZipEntriesEntry;
begin
  Result := TKAZipEntriesEntry( inherited Items[index]);
end;

procedure TKAZipEntries.SetHeaderEntry(index: Integer;
  const Value: TKAZipEntriesEntry);
begin
  inherited Items[index] := TCollectionItem(Value);
end;

function TKAZipEntries.ReadBA(MS: TStream; Sz, Poz: Integer): TBytes;
begin
  SetLength(Result, Sz);
  MS.Position := Poz;
  MS.read(Result[0], Sz);
end;

function TKAZipEntries.FindCentralDirectory(MS: TStream): Boolean;
var
  SeekStart: Integer;
  Poz: Integer;
  BR: Integer;
  Byte_: array [0 .. 3] of Byte;

begin
  Result := False;
  if MS.Size < 22 then
    Exit;
  if MS.Size < 256 then
    SeekStart := MS.Size
  else
    SeekStart := 256;
  Poz := MS.Size - 22;
  BR := SeekStart;
  repeat
    MS.Position := Poz;
    MS.read(Byte_, 4);
    if Byte_[0] = $50 then
    begin
      if (Byte_[1] = $4B) and (Byte_[2] = $05) and (Byte_[3] = $06) then
      begin
        MS.Position := Poz;
        FParent.FEndOfCentralDirPos := MS.Position;
        MS.read(FParent.FEndOfCentralDir, SizeOf(FParent.FEndOfCentralDir));
        FParent.FZipCommentPos := MS.Position;
        FParent.FZipComment.Clear;
        Result := True;
      end
      else
      begin
        Dec(Poz, 4);
        Dec(BR, 4);
      end;
    end
    else
    begin
      Dec(Poz);
      Dec(BR)
    end;
    if BR < 0 then
    begin
      case SeekStart of
        256:
          begin
            SeekStart := 1024;
            Poz := MS.Size - (256 + 22);
            BR := SeekStart;
          end;
        1024:
          begin
            SeekStart := 65536;
            Poz := MS.Size - (1024 + 22);
            BR := SeekStart;
          end;
        65536:
          begin
            SeekStart := -1;
          end;
      end;
    end;
    if BR < 0 then
      SeekStart := -1;
    if MS.Size < SeekStart then
      SeekStart := -1;
  until (Result) or (SeekStart = -1);
end;

function TKAZipEntries.ParseCentralHeaders(MS: TStream): Boolean;
var
  X: Integer;
  Entry: TKAZipEntriesEntry;
  CDFile: TCentralDirectoryFile;
begin
  Result := False;
  try
    MS.Position := FParent.FEndOfCentralDir.OffsetOfStartOfCentralDirectory;
    for X := 0 to FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk - 1 do
    begin
      FillChar(CDFile, SizeOf(TCentralDirectoryFile) - 3 * SizeOf(string), 0);
      MS.read(CDFile, SizeOf(TCentralDirectoryFile) - 3 * SizeOf(string));
      Entry := TKAZipEntriesEntry.Create(Self);
      Entry.FDate := FileDateToDateTime(CDFile.LastModFileTimeDate);
      if (CDFile.GeneralPurposeBitFlag and 1) > 0 then
        Entry.FIsEncrypted := True
      else
        Entry.FIsEncrypted := False;
      if CDFile.FilenameLength > 0 then
      begin
        SetLength(CDFile.FileName, CDFile.FilenameLength);
        MS.read(CDFile.FileName[1], CDFile.FilenameLength)
      end;
      if CDFile.ExtraFieldLength > 0 then
      begin
        SetLength(CDFile.ExtraField, CDFile.ExtraFieldLength);
        MS.read(CDFile.ExtraField[1], CDFile.ExtraFieldLength);
      end;
      if CDFile.FileCommentLength > 0 then
      begin
        SetLength(CDFile.FileComment, CDFile.FileCommentLength);
        MS.read(CDFile.FileComment[1], CDFile.FileCommentLength);
      end;
      Entry.FIsFolder := (CDFile.ExternalFileAttributes and faDirectory) > 0;

      Entry.FCompressionType := ctUnknown;
      if (CDFile.CompressionMethod = 8) or (CDFile.CompressionMethod = 9) then
      begin
        case CDFile.GeneralPurposeBitFlag and 6 of
          0:
            Entry.FCompressionType := ctNormal;
          2:
            Entry.FCompressionType := ctMaximum;
          4:
            Entry.FCompressionType := ctFast;
          6:
            Entry.FCompressionType := ctSuperFast
        end;
      end;
      Entry.FCentralDirectoryFile := CDFile;
      if Assigned(FParent.FOnZipOpen) then
        FParent.FOnZipOpen(FParent, X,
          FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk);
    end;
  except
    Exit;
  end;
  Result := Count = FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk;
end;

procedure TKAZipEntries.ParseZip(MS: TStream);
begin
  FIsZipFile := False;
  Clear;
  if FindCentralDirectory(MS) then
  begin
    if ParseCentralHeaders(MS) then
    begin
      FIsZipFile := True;
      LoadLocalHeaders(MS);
    end;
  end
  else
  begin
    if ParseLocalHeaders(MS) then
    begin
      FIsZipFile := Count > 0;
      if FIsZipFile then
        FParent.FHasBadEntries := True;
    end;
  end;
end;

procedure TKAZipEntries.GetLocalEntry(MS: TStream; Offset: Integer;
  HeaderOnly: Boolean; var Result: TLocalFile);
var
  Byte_: array [0 .. 4] of Byte;
  DataDescriptor: TDataDescriptor;
begin
  FillChar(Result, SizeOf(Result), 0);
  MS.Position := Offset;
  MS.read(Byte_, 4);
  if (Byte_[0] = $50) and (Byte_[1] = $4B) and (Byte_[2] = $03) and
    (Byte_[3] = $04) then
  begin
    MS.Position := Offset;
    MS.read(Result, SizeOf(Result) - 3 * SizeOf(AnsiString));
    if Result.FilenameLength > 0 then
    begin
      SetLength(Result.FileName, Result.FilenameLength);
      MS.read(Result.FileName[1], Result.FilenameLength);
    end;
    if Result.ExtraFieldLength > 0 then
    begin
      SetLength(Result.ExtraField, Result.ExtraFieldLength);
      MS.read(Result.ExtraField[1], Result.ExtraFieldLength);
    end;
    if (Result.GeneralPurposeBitFlag and (1 shl 3)) > 0 then
    begin
      MS.read(DataDescriptor, SizeOf(TDataDescriptor));
      Result.Crc32 := DataDescriptor.Crc32;
      Result.CompressedSize := DataDescriptor.CompressedSize;
      Result.UncompressedSize := DataDescriptor.UncompressedSize;
    end;
    if not HeaderOnly then
    begin
      if Result.CompressedSize > 0 then
      begin
        SetLength(Result.CompressedData, Result.CompressedSize);
        MS.read(Result.CompressedData[1], Result.CompressedSize);
      end;
    end;
  end
  else
  begin
  end;
end;

procedure TKAZipEntries.LoadLocalHeaders(MS: TStream);
var
  X: Integer;
begin
  FParent.FHasBadEntries := False;
  for X := 0 to Count - 1 do
  begin
    if Assigned(FParent.FOnZipOpen) then
      FParent.FOnZipOpen(FParent, X,
        FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk);
    GetLocalEntry(MS,
      Items[X]
        .FCentralDirectoryFile.RelativeOffsetOfLocalHeader, True,
      Items[X].FLocalFile);
    if Items[X].FLocalFile.LocalFileHeaderSignature <> $04034B50 then
      FParent.FHasBadEntries := True;
  end;
end;

function TKAZipEntries.ParseLocalHeaders(MS: TStream): Boolean;
var
  Poz: Integer;
  NLE: Integer;
  Byte_: array [0 .. 4] of Byte;
  LocalFile: TLocalFile;
  DataDescriptor: TDataDescriptor;
  Entry: TKAZipEntriesEntry;
  CDFile: TCentralDirectoryFile;
  CDSize: Cardinal;
  L: Integer;
  NoMore: Boolean;
begin
  Result := False;
  FLocalHeaderNumFiles := 0;
  Clear;
  try
    Poz := 0;
    NLE := 0;
    CDSize := 0;
    repeat
      NoMore := True;
      MS.Position := Poz;
      MS.read(Byte_, 4);
      if (Byte_[0] = $50) and (Byte_[1] = $4B) and (Byte_[2] = $03) and
        (Byte_[3] = $04) then
      begin
        Result := True;
        Inc(FLocalHeaderNumFiles);
        NoMore := False;
        MS.Position := Poz;
        MS.read(LocalFile, SizeOf(TLocalFile) - 3 * SizeOf(string));
        if LocalFile.FilenameLength > 0 then
        begin
          SetLength(LocalFile.FileName, LocalFile.FilenameLength);
          MS.read(LocalFile.FileName[1], LocalFile.FilenameLength);
        end;
        if LocalFile.ExtraFieldLength > 0 then
        begin
          SetLength(LocalFile.ExtraField, LocalFile.ExtraFieldLength);
          MS.read(LocalFile.ExtraField[1], LocalFile.ExtraFieldLength);
        end;
        if (LocalFile.GeneralPurposeBitFlag and (1 shl 3)) > 0 then
        begin
          MS.read(DataDescriptor, SizeOf(TDataDescriptor));
          LocalFile.Crc32 := DataDescriptor.Crc32;
          LocalFile.CompressedSize := DataDescriptor.CompressedSize;
          LocalFile.UncompressedSize := DataDescriptor.UncompressedSize;
        end;
        MS.Position := MS.Position + LocalFile.CompressedSize;

        FillChar(CDFile, SizeOf(TCentralDirectoryFile), 0);
        CDFile.CentralFileHeaderSignature := $02014B50;
        CDFile.VersionMadeBy := 20;
        CDFile.VersionNeededToExtract := LocalFile.VersionNeededToExtract;
        CDFile.GeneralPurposeBitFlag := LocalFile.GeneralPurposeBitFlag;
        CDFile.CompressionMethod := LocalFile.CompressionMethod;
        CDFile.LastModFileTimeDate := LocalFile.LastModFileTimeDate;
        CDFile.Crc32 := LocalFile.Crc32;
        CDFile.CompressedSize := LocalFile.CompressedSize;
        CDFile.UncompressedSize := LocalFile.UncompressedSize;
        CDFile.FilenameLength := LocalFile.FilenameLength;
        CDFile.ExtraFieldLength := LocalFile.ExtraFieldLength;
        CDFile.FileCommentLength := 0;
        CDFile.DiskNumberStart := 0;
        CDFile.InternalFileAttributes := LocalFile.VersionNeededToExtract;
        CDFile.ExternalFileAttributes := faArchive;
        CDFile.RelativeOffsetOfLocalHeader := Poz;
        CDFile.FileName := LocalFile.FileName;
        L := Length(CDFile.FileName);
        if L > 0 then
        begin
          if CDFile.FileName[L] = '/' then
            CDFile.ExternalFileAttributes := faDirectory;
        end;
        CDFile.ExtraField := LocalFile.ExtraField;
        CDFile.FileComment := '';

        Entry := TKAZipEntriesEntry.Create(Self);
        Entry.FDate := FileDateToDateTime(CDFile.LastModFileTimeDate);
        if (CDFile.GeneralPurposeBitFlag and 1) > 0 then
          Entry.FIsEncrypted := True
        else
          Entry.FIsEncrypted := False;
        Entry.FIsFolder := (CDFile.ExternalFileAttributes and faDirectory) > 0;
        Entry.FCompressionType := ctUnknown;
        if (CDFile.CompressionMethod = 8) or (CDFile.CompressionMethod = 9) then
        begin
          case CDFile.GeneralPurposeBitFlag and 6 of
            0:
              Entry.FCompressionType := ctNormal;
            2:
              Entry.FCompressionType := ctMaximum;
            4:
              Entry.FCompressionType := ctFast;
            6:
              Entry.FCompressionType := ctSuperFast
          end;
        end;
        Entry.FCentralDirectoryFile := CDFile;
        Poz := MS.Position;
        Inc(NLE);
        CDSize := CDSize + Entry.CentralEntrySize;
      end;
    until NoMore;

    FParent.FEndOfCentralDir.EndOfCentralDirSignature := $06054B50;
    FParent.FEndOfCentralDir.NumberOfThisDisk := 0;
    FParent.FEndOfCentralDir.NumberOfTheDiskWithTheStart := 0;
    FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk := NLE;
    FParent.FEndOfCentralDir.SizeOfTheCentralDirectory := CDSize;
    FParent.FEndOfCentralDir.OffsetOfStartOfCentralDirectory := MS.Position;
    FParent.FEndOfCentralDir.ZipfileCommentLength := 0;
  except
    Exit;
  end;
end;

procedure TKAZipEntries.Remove(ItemIndex: Integer; Flush: Boolean);
var
  TempStream: TFileStream;
  TempMSStream: TMemoryStream;
  TempFileName: string;
  buf: AnsiString;
  ZipComment: string;
  OSL: Cardinal;
  // *********************************************
  X: Integer;
  TargetPos: Cardinal;
  Border: Cardinal;

  BufStart: Integer;
  BufLen: Integer;
  ShiftSize: Cardinal;
  NewSize: Cardinal;
begin
  TargetPos := Items[ItemIndex].FCentralDirectoryFile.
    RelativeOffsetOfLocalHeader;
  ShiftSize := Items[ItemIndex].LocalEntrySize;
  BufStart := TargetPos + ShiftSize;
  BufLen := FParent.FZipStream.Size - BufStart;
  Border := TargetPos;
  Delete(ItemIndex);
  if (FParent.FZipSaveMethod = FastSave) and (Count > 0) then
  begin
    ZipComment := FParent.Comment.Text;

    SetLength(buf, BufLen);
    FParent.FZipStream.Position := BufStart;
    FParent.FZipStream.read(buf[1], BufLen);

    FParent.FZipStream.Position := TargetPos;
    FParent.FZipStream.write(buf[1], BufLen);
    SetLength(buf, 0);

    for X := 0 to Count - 1 do
    begin
      if Items[X].FCentralDirectoryFile.RelativeOffsetOfLocalHeader >
        Border then
      begin
        Dec(Items[X].FCentralDirectoryFile.RelativeOffsetOfLocalHeader,
          ShiftSize);
        TargetPos := TargetPos + Items[X].LocalEntrySize;
      end
    end;

    FParent.FZipStream.Position := TargetPos;
    // ************************************ MARK START OF CENTRAL DIRECTORY
    FParent.FEndOfCentralDir.OffsetOfStartOfCentralDirectory :=
      FParent.FZipStream.Position;
    // ************************************ SAVE CENTRAL DIRECTORY
    for X := 0 to Count - 1 do
    begin
      FParent.FZipStream.write(Self.Items[X].FCentralDirectoryFile,
        SizeOf(Self.Items[X].FCentralDirectoryFile) - 3 * SizeOf(string));
      if Self.Items[X].FCentralDirectoryFile.FilenameLength > 0 then
        FParent.FZipStream.write
          (Self.Items[X].FCentralDirectoryFile.FileName[1],
          Self.Items[X].FCentralDirectoryFile.FilenameLength);
      if Self.Items[X].FCentralDirectoryFile.ExtraFieldLength > 0 then
        FParent.FZipStream.write
          (Self.Items[X].FCentralDirectoryFile.ExtraField[1],
          Self.Items[X].FCentralDirectoryFile.ExtraFieldLength);
      if Self.Items[X].FCentralDirectoryFile.FileCommentLength > 0 then
        FParent.FZipStream.write
          (Self.Items[X].FCentralDirectoryFile.FileComment[1],
          Self.Items[X].FCentralDirectoryFile.FileCommentLength);
    end;
    // ************************************ SAVE END CENTRAL DIRECTORY RECORD
    FParent.FEndOfCentralDirPos := FParent.FZipStream.Position;
    FParent.FEndOfCentralDir.SizeOfTheCentralDirectory :=
      FParent.FEndOfCentralDirPos - FParent.FEndOfCentralDir.
      OffsetOfStartOfCentralDirectory;
    Dec(FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk);
    Dec(FParent.FEndOfCentralDir.TotalNumberOfEntries);
    FParent.FZipStream.write(FParent.FEndOfCentralDir,
      SizeOf(TEndOfCentralDir));
    // ************************************ SAVE ZIP COMMENT IF ANY
    FParent.FZipCommentPos := FParent.FZipStream.Position;
    if Length(ZipComment) > 0 then
    begin
      FParent.FZipStream.write(ZipComment[1], Length(ZipComment));
    end;
    FParent.FZipStream.Size := FParent.FZipStream.Position;
  end
  else
  begin
    if FParent.FUseTempFiles then
    begin
      TempFileName := FParent.GetDelphiTempFileName;
      TempStream := TFileStream.Create(TempFileName,
        fmOpenReadWrite or FmCreate);
      try
        FParent.SaveToStream(TempStream);
        TempStream.Position := 0;
        OSL := FParent.FZipStream.Size;
        try
          FParent.FZipStream.Size := TempStream.Size;
        except
          FParent.FZipStream.Size := OSL;
          raise ;
        end;
        FParent.FZipStream.Position := 0;
        FParent.FZipStream.CopyFrom(TempStream, TempStream.Size);
        // *********************************************************************
        FParent.FZipHeader.ParseZip(FParent.FZipStream);
        // *********************************************************************
      finally
        TempStream.Free;
        DeleteFile(TempFileName)
      end;
    end
    else
    begin
      NewSize := 0;
      for X := 0 to Count - 1 do
      begin
        NewSize := NewSize + Items[X].LocalEntrySize + Items[X]
          .CentralEntrySize;
        if Assigned(FParent.FOnRemoveItems) then
          FParent.FOnRemoveItems(FParent, X, Count - 1);
      end;
      NewSize := NewSize + SizeOf(FParent.FEndOfCentralDir)
        + FParent.FEndOfCentralDir.ZipfileCommentLength;
      TempMSStream := TMemoryStream.Create;
      try
        TempMSStream.SetSize(NewSize);
        TempMSStream.Position := 0;
        FParent.SaveToStream(TempMSStream);
        TempMSStream.Position := 0;
        OSL := FParent.FZipStream.Size;
        try
          FParent.FZipStream.Size := TempMSStream.Size;
        except
          FParent.FZipStream.Size := OSL;
          raise ;
        end;
        FParent.FZipStream.Position := 0;
        FParent.FZipStream.CopyFrom(TempMSStream, TempMSStream.Size);
        // *********************************************************************
        FParent.FZipHeader.ParseZip(FParent.FZipStream);
        // *********************************************************************
      finally
        TempMSStream.Free;
      end;
    end;
  end;
  FParent.FIsDirty := True;
  if not FParent.FBatchMode then
  begin
    FParent.DoChange(FParent, 3);
  end;
end;

procedure TKAZipEntries.Remove(ItemIndex: Integer);
begin
  Remove(ItemIndex, True);
end;

procedure TKAZipEntries.Remove(Item: TKAZipEntriesEntry);
var
  X: Integer;
begin
  for X := 0 to Count - 1 do
  begin
    if Self.Items[X] = Item then
    begin
      Remove(X);
      Exit;
    end;
  end;
end;

procedure TKAZipEntries.Remove(const FileName: string);
var
  I: Integer;
begin
  I := IndexOf(FileName);
  if I <> -1 then
    Remove(I);
end;

procedure TKAZipEntries.RemoveBatch(Files: TList);
var
  X: Integer;
  OSL: Integer;
  NewSize: Cardinal;
  TempStream: TFileStream;
  TempMSStream: TMemoryStream;
  TempFileName: string;
begin
  for X := Files.Count - 1 downto 0 do
  begin
    Delete(Integer(Files.Items[X]));
    if Assigned(FParent.FOnRemoveItems) then
      FParent.FOnRemoveItems(FParent, Files.Count - X, Files.Count);
  end;
  NewSize := 0;
  if FParent.FUseTempFiles then
  begin
    TempFileName := FParent.GetDelphiTempFileName;
    TempStream := TFileStream.Create(TempFileName, fmOpenReadWrite or FmCreate);
    try
      FParent.SaveToStream(TempStream);
      TempStream.Position := 0;
      OSL := FParent.FZipStream.Size;
      try
        FParent.FZipStream.Size := TempStream.Size;
      except
        FParent.FZipStream.Size := OSL;
        raise ;
      end;
      FParent.FZipStream.Position := 0;
      FParent.FZipStream.CopyFrom(TempStream, TempStream.Size);
      // *********************************************************************
      FParent.FZipHeader.ParseZip(FParent.FZipStream);
      // *********************************************************************
    finally
      TempStream.Free;
      DeleteFile(TempFileName)
    end;
  end
  else
  begin
    for X := 0 to Count - 1 do
    begin
      NewSize := NewSize + Items[X].LocalEntrySize + Items[X].CentralEntrySize;
      if Assigned(FParent.FOnRemoveItems) then
        FParent.FOnRemoveItems(FParent, X, Count - 1);
    end;
    NewSize := NewSize + SizeOf(FParent.FEndOfCentralDir)
      + FParent.FEndOfCentralDir.ZipfileCommentLength;
    TempMSStream := TMemoryStream.Create;
    try
      TempMSStream.SetSize(NewSize);
      TempMSStream.Position := 0;
      FParent.SaveToStream(TempMSStream);
      TempMSStream.Position := 0;
      OSL := FParent.FZipStream.Size;
      try
        FParent.FZipStream.Size := TempMSStream.Size;
      except
        FParent.FZipStream.Size := OSL;
        raise ;
      end;
      FParent.FZipStream.Position := 0;
      FParent.FZipStream.CopyFrom(TempMSStream, TempMSStream.Size);
      // *********************************************************************
      FParent.FZipHeader.ParseZip(FParent.FZipStream);
      // *********************************************************************
    finally
      TempMSStream.Free;
    end;
  end;
end;

function TKAZipEntries.IndexOf(const FileName: string): Integer;
var
  X: Integer;
  FN: string;
begin
  Result := -1;
  FN := ToZipName(FileName);
  for X := 0 to Count - 1 do
  begin
    if CompareText(FN, ToZipName(string(Items[X].FCentralDirectoryFile.FileName)))
      = 0 then
    begin
      Result := X;
      Exit;
    end;
  end;
end;

function TKAZipEntries.AddStreamFast(const AItemName: string; FileAttr: WORD;
  FileDate: TDateTime; Stream: TStream): TKAZipEntriesEntry;
var
  Compressor: TCompressionStream;
  MS: TMemoryStream;
  CM: WORD;
  S: TBytes;
  X: Integer;
  I: Integer;
  UL: Integer;
  CL: Integer;
  FCRC32: Cardinal;
  SizeToAppend: Integer;
  ZipComment, ItemName: string;
  Level: TCompressionLevel;
  OBM: Boolean;
begin
  // *********************************** COMPRESS DATA
  ZipComment := FParent.Comment.Text;
  ItemName := AItemName;
  if not FParent.FStoreRelativePath then
    ItemName := ExtractFileName(ItemName);

  ItemName := ToZipName(ItemName);
  I := IndexOf(ItemName);
  if I > -1 then
  begin
    OBM := FParent.FBatchMode;
    try
      if OBM = False then
        FParent.FBatchMode := True;
      Remove(I);
    finally
      FParent.FBatchMode := OBM;
    end;
  end;

  MS := TStringStream.Create;
  MS.Position := 0;
  try
    UL := Stream.Size - Stream.Position;
    SetLength(S, UL);
    CM := 0;
    if UL > 0 then
    begin
      Stream.read(S[0], UL);
      CM := 8;
    end;
    FCRC32 := CalcCRC32(S);
    FParent.FCurrentDFS := UL;

    Level := clDefault;
    case FParent.FZipCompressionType of
      ctNormal:
        Level := clDefault;
      ctMaximum:
        Level := clMax;
      ctFast:
        Level := clFastest;
      ctSuperFast:
        Level := clFastest;
      ctNone:
        Level := clNone;
    end;

    if CM = 8 then
    begin
      Compressor := TCompressionStream.Create(Level, MS);
      try
        Compressor.OnProgress := FParent.OnCompress;
        Compressor.write(S[0], UL);
      finally
        Compressor.Free;
      end;
      SetLength(S, MS.Size - 8);
      CopyMemory(Pointer(@S[0]), Pointer(PAnsiChar(MS.Memory) + 2), MS.Size - 6);
    end;
  finally
    MS.Free;
  end;
  // ***********************************
  CL := Length(S);
  // *********************************** FILL RECORDS
  Result := TKAZipEntriesEntry(Self.Add);
  with Result.FLocalFile do
  begin
    LocalFileHeaderSignature := $04034B50;
    VersionNeededToExtract := 20;
    GeneralPurposeBitFlag := 0;
    CompressionMethod := CM;
    LastModFileTimeDate := DateTimeToFileDate(FileDate);
    Crc32 := FCRC32;
    CompressedSize := CL;
    UncompressedSize := UL;
    FilenameLength := Length(ItemName);
    ExtraFieldLength := 0;
    FileName := AnsiString(ItemName);
    ExtraField := '';
    CompressedData := '';
  end;

  with Result.FCentralDirectoryFile do
  begin
    CentralFileHeaderSignature := $02014B50;
    VersionMadeBy := 20;
    VersionNeededToExtract := 20;
    GeneralPurposeBitFlag := 0;
    CompressionMethod := CM;
    LastModFileTimeDate := DateTimeToFileDate(FileDate);
    Crc32 := FCRC32;
    CompressedSize := CL;
    UncompressedSize := UL;
    FilenameLength := Length(ItemName);
    ExtraFieldLength := 0;
    FileCommentLength := 0;
    DiskNumberStart := 0;
    InternalFileAttributes := 0;
    ExternalFileAttributes := FileAttr;
    RelativeOffsetOfLocalHeader :=
      FParent.FEndOfCentralDir.OffsetOfStartOfCentralDirectory;
    FileName := AnsiString(ItemName);
    ExtraField := '';
    FileComment := '';
  end;

  // ************************************ EXPAND ZIP STREAM SIZE
  SizeToAppend := 0;
  SizeToAppend := SizeToAppend + SizeOf(Result.FLocalFile) - 3 * SizeOf(string);
  SizeToAppend := SizeToAppend + Result.FLocalFile.FilenameLength;
  SizeToAppend := SizeToAppend + CL;
  SizeToAppend := SizeToAppend + SizeOf(Result.FCentralDirectoryFile)
    - 3 * SizeOf(string);
  SizeToAppend := SizeToAppend + Result.FCentralDirectoryFile.FilenameLength;
  FParent.FZipStream.Size := FParent.FZipStream.Size + SizeToAppend;

  // ************************************ SAVE LOCAL HEADER AND COMPRESSED DATA
  FParent.FZipStream.Position :=
    Result.FCentralDirectoryFile.RelativeOffsetOfLocalHeader;
  FParent.FZipStream.write(Result.FLocalFile,
    SizeOf(Result.FLocalFile) - 3 * SizeOf(string));
  if Result.FLocalFile.FilenameLength > 0 then
    FParent.FZipStream.write(Result.FLocalFile.FileName[1],
      Result.FLocalFile.FilenameLength);
  if CL > 0 then
    FParent.FZipStream.write(S[1], CL);

  // ************************************ MARK START OF CENTRAL DIRECTORY
  FParent.FEndOfCentralDir.OffsetOfStartOfCentralDirectory :=
    FParent.FZipStream.Position;

  // ************************************ SAVE CENTRAL DIRECTORY
  for X := 0 to Count - 1 do
  begin
    FParent.FZipStream.write(Self.Items[X].FCentralDirectoryFile,
      SizeOf(Self.Items[X].FCentralDirectoryFile) - 3 * SizeOf(string));
    if Self.Items[X].FCentralDirectoryFile.FilenameLength > 0 then
      FParent.FZipStream.write(Self.Items[X].FCentralDirectoryFile.FileName[1],
        Self.Items[X].FCentralDirectoryFile.FilenameLength);
    if Self.Items[X].FCentralDirectoryFile.ExtraFieldLength > 0 then
      FParent.FZipStream.write
        (Self.Items[X].FCentralDirectoryFile.ExtraField[1],
        Self.Items[X].FCentralDirectoryFile.ExtraFieldLength);
    if Self.Items[X].FCentralDirectoryFile.FileCommentLength > 0 then
      FParent.FZipStream.write
        (Self.Items[X].FCentralDirectoryFile.FileComment[1],
        Self.Items[X].FCentralDirectoryFile.FileCommentLength);
  end;

  // ************************************ SAVE END CENTRAL DIRECTORY RECORD
  FParent.FEndOfCentralDirPos := FParent.FZipStream.Position;
  FParent.FEndOfCentralDir.SizeOfTheCentralDirectory :=
    FParent.FEndOfCentralDirPos - FParent.FEndOfCentralDir.
    OffsetOfStartOfCentralDirectory;
  Inc(FParent.FEndOfCentralDir.TotalNumberOfEntriesOnThisDisk);
  Inc(FParent.FEndOfCentralDir.TotalNumberOfEntries);
  FParent.FZipStream.write(FParent.FEndOfCentralDir, SizeOf(TEndOfCentralDir));

  // ************************************ SAVE ZIP COMMENT IF ANY
  FParent.FZipCommentPos := FParent.FZipStream.Position;
  if Length(ZipComment) > 0 then
  begin
    FParent.FZipStream.write(ZipComment[1], Length(ZipComment));
  end;

  Result.FDate := FileDate;

  if (Result.FCentralDirectoryFile.GeneralPurposeBitFlag and 1) > 0 then
    Result.FIsEncrypted := True
  else
    Result.FIsEncrypted := False;
  Result.FIsFolder :=
    (Result.FCentralDirectoryFile.ExternalFileAttributes and faDirectory)
    > 0;
  Result.FCompressionType := ctUnknown;
  if (Result.FCentralDirectoryFile.CompressionMethod = 8) or
    (Result.FCentralDirectoryFile.CompressionMethod = 9) then
  begin
    case Result.FCentralDirectoryFile.GeneralPurposeBitFlag and 6 of
      0:
        Result.FCompressionType := ctNormal;
      2:
        Result.FCompressionType := ctMaximum;
      4:
        Result.FCompressionType := ctFast;
      6:
        Result.FCompressionType := ctSuperFast
    end;
  end;
  FParent.FIsDirty := True;
  if not FParent.FBatchMode then
  begin
    FParent.DoChange(FParent, 2);
  end;
end;

function TKAZipEntries.AddStreamRebuild(const AItemName: string; FileAttr: WORD;
  FileDate: TDateTime; Stream: TStream): TKAZipEntriesEntry;
var
  Compressor: TCompressionStream;
  MS: TMemoryStream;
  CM: WORD;
  S: TBytes;
  UL: Integer;
  CL: Integer;
  I: Integer;
  X: Integer;
  FCRC32: Cardinal;
  OSL: Cardinal;
  NewSize: Cardinal;
  ZipComment: string;
  TempStream: TFileStream;
  TempMSStream: TMemoryStream;
  TempFileName, ItemName: string;
  Level: TCompressionLevel;
  OBM: Boolean;
begin
  ItemName := AItemName;
  if FParent.FUseTempFiles then
  begin
    TempFileName := FParent.GetDelphiTempFileName;
    TempStream := TFileStream.Create(TempFileName, fmOpenReadWrite or FmCreate);
    try
      // *********************************** SAVE ALL OLD LOCAL ITEMS
      FParent.RebuildLocalFiles(TempStream);
      // *********************************** COMPRESS DATA
      ZipComment := FParent.Comment.Text;
      if not FParent.FStoreRelativePath then
        ItemName := ExtractFileName(ItemName);
      ItemName := ToZipName(ItemName);
      I := IndexOf(ItemName);
      if I > -1 then
      begin
        OBM := FParent.FBatchMode;
        try
          if OBM = False then
            FParent.FBatchMode := True;
          Remove(I);
        finally
          FParent.FBatchMode := OBM;
        end;
      end;

      CM := 0;
      MS := TMemoryStream.Create;
      MS.Position := 0;
      try
        UL := Stream.Size - Stream.Position;
        SetLength(S, UL);
        if UL > 0 then
        begin
          Stream.read(S[0], UL);
          CM := 8;
        end;
        FCRC32 := CalcCRC32(S);
        FParent.FCurrentDFS := UL;

        Level := clDefault;
        case FParent.FZipCompressionType of
          ctNormal:
            Level := clDefault;
          ctMaximum:
            Level := clMax;
          ctFast:
            Level := clFastest;
          ctSuperFast:
            Level := clFastest;
          ctNone:
            Level := clNone;
        end;

        if CM = 8 then
        begin
          Compressor := TCompressionStream.Create(Level, MS);
          try
            Compressor.OnProgress := FParent.OnCompress;
            Compressor.write(S[0], UL);
          finally
            Compressor.Free;
          end;
          SetLength(S, MS.Size - 8);
          CopyMemory(Pointer(@S[0]), Pointer(PAnsiChar(MS.Memory) + 2), MS.Size - 6);
        end;
      finally
        MS.Free;
      end;
      // ************************************************************************
      CL := Length(S);
      // *********************************** FILL RECORDS
      Result := TKAZipEntriesEntry(Self.Add);
      with Result.FLocalFile do
      begin
        LocalFileHeaderSignature := $04034B50;
        VersionNeededToExtract := 20;
        GeneralPurposeBitFlag := 0;
        CompressionMethod := CM;
        LastModFileTimeDate := DateTimeToFileDate(FileDate);
        Crc32 := FCRC32;
        CompressedSize := CL;
        UncompressedSize := UL;
        FilenameLength := Length(ItemName);
        ExtraFieldLength := 0;
        FileName := AnsiString(ItemName);
        ExtraField := '';
        CompressedData := '';
      end;

      with Result.FCentralDirectoryFile do
      begin
        CentralFileHeaderSignature := $02014B50;
        VersionMadeBy := 20;
        VersionNeededToExtract := 20;
        GeneralPurposeBitFlag := 0;
        CompressionMethod := CM;
        LastModFileTimeDate := DateTimeToFileDate(FileDate);
        Crc32 := FCRC32;
        CompressedSize := CL;
        UncompressedSize := UL;
        FilenameLength := Length(ItemName);
        ExtraFieldLength := 0;
        FileCommentLength := 0;
        DiskNumberStart := 0;
        InternalFileAttributes := 0;
        ExternalFileAttributes := FileAttr;
        RelativeOffsetOfLocalHeader := TempStream.Position;
        FileName := AnsiString(ItemName);
        ExtraField := '';
        FileComment := '';
      end;

      // ************************************ SAVE LOCAL HEADER AND COMPRESSED DATA
      TempStream.write(Result.FLocalFile,
        SizeOf(Result.FLocalFile) - 3 * SizeOf(string));
      if Result.FLocalFile.FilenameLength > 0 then
        TempStream.write(Result.FLocalFile.FileName[1],
          Result.FLocalFile.FilenameLength);
      if CL > 0 then
        TempStream.write(S[1], CL);
      // ************************************
      FParent.NewLHOffsets[Count - 1] :=
        Result.FCentralDirectoryFile.RelativeOffsetOfLocalHeader;
      FParent.RebuildCentralDirectory(TempStream);
      FParent.RebuildEndOfCentralDirectory(TempStream);
      // ************************************
      TempStream.Position := 0;
      OSL := FParent.FZipStream.Size;
      try
        FParent.FZipStream.Size := TempStream.Size;
      except
        FParent.FZipStream.Size := OSL;
        raise ;
      end;
      FParent.FZipStream.Position := 0;
      FParent.FZipStream.CopyFrom(TempStream, TempStream.Size);
    finally
      TempStream.Free;
      DeleteFile(TempFileName)
    end;
  end
  else
  begin
    TempMSStream := TMemoryStream.Create;
    NewSize := 0;
    for X := 0 to Count - 1 do
    begin
      NewSize := NewSize + Items[X].LocalEntrySize + Items[X].CentralEntrySize;
      if Assigned(FParent.FOnRemoveItems) then
        FParent.FOnRemoveItems(FParent, X, Count - 1);
    end;
    NewSize := NewSize + SizeOf(FParent.FEndOfCentralDir)
      + FParent.FEndOfCentralDir.ZipfileCommentLength;
    try
      TempMSStream.SetSize(NewSize);
      TempMSStream.Position := 0;
      // *********************************** SAVE ALL OLD LOCAL ITEMS
      FParent.RebuildLocalFiles(TempMSStream);
      // *********************************** COMPRESS DATA
      ZipComment := FParent.Comment.Text;
      if not FParent.FStoreRelativePath then
        ItemName := ExtractFileName(ItemName);
      ItemName := ToZipName(ItemName);
      I := IndexOf(ItemName);
      if I > -1 then
      begin
        OBM := FParent.FBatchMode;
        try
          if OBM = False then
            FParent.FBatchMode := True;
          Remove(I);
        finally
          FParent.FBatchMode := OBM;
        end;
      end;

      CM := 0;
      MS := TMemoryStream.Create;
      MS.Position := 0;
      try
        UL := Stream.Size - Stream.Position;
        SetLength(S, UL);
        if UL > 0 then
        begin
          Stream.read(S[0], UL);
          CM := 8;
        end;
        FCRC32 := CalcCRC32(S);
        FParent.FCurrentDFS := UL;

        Level := clDefault;
        case FParent.FZipCompressionType of
          ctNormal:
            Level := clDefault;
          ctMaximum:
            Level := clMax;
          ctFast:
            Level := clFastest;
          ctSuperFast:
            Level := clFastest;
          ctNone:
            Level := clNone;
        end;

        if CM = 8 then
        begin
          Compressor := TCompressionStream.Create(Level, MS);
          try
            Compressor.OnProgress := FParent.OnCompress;
            Compressor.write(S[0], UL);
          finally
            Compressor.Free;
          end;
          SetLength(S, MS.Size - 8);
          CopyMemory(Pointer(@S[0]), Pointer(PAnsiChar(MS.Memory) + 2), MS.Size - 6);
        end;
      finally
        MS.Free;
      end;
      // ************************************************************************
      CL := Length(S);
      // *********************************** FILL RECORDS
      Result := TKAZipEntriesEntry(Self.Add);
      with Result.FLocalFile do
      begin
        LocalFileHeaderSignature := $04034B50;
        VersionNeededToExtract := 20;
        GeneralPurposeBitFlag := 0;
        CompressionMethod := CM;
        LastModFileTimeDate := DateTimeToFileDate(FileDate);
        Crc32 := FCRC32;
        CompressedSize := CL;
        UncompressedSize := UL;
        FilenameLength := Length(ItemName);
        ExtraFieldLength := 0;
        FileName := AnsiString(ItemName);
        ExtraField := '';
        CompressedData := '';
      end;

      with Result.FCentralDirectoryFile do
      begin
        CentralFileHeaderSignature := $02014B50;
        VersionMadeBy := 20;
        VersionNeededToExtract := 20;
        GeneralPurposeBitFlag := 0;
        CompressionMethod := CM;
        LastModFileTimeDate := DateTimeToFileDate(FileDate);
        Crc32 := FCRC32;
        CompressedSize := CL;
        UncompressedSize := UL;
        FilenameLength := Length(ItemName);
        ExtraFieldLength := 0;
        FileCommentLength := 0;
        DiskNumberStart := 0;
        InternalFileAttributes := 0;
        ExternalFileAttributes := FileAttr;
        RelativeOffsetOfLocalHeader := TempMSStream.Position;
        FileName := AnsiString(ItemName);
        ExtraField := '';
        FileComment := '';
      end;

      // ************************************ SAVE LOCAL HEADER AND COMPRESSED DATA
      TempMSStream.write(Result.FLocalFile,
        SizeOf(Result.FLocalFile) - 3 * SizeOf(string));
      if Result.FLocalFile.FilenameLength > 0 then
        TempMSStream.write(Result.FLocalFile.FileName[1],
          Result.FLocalFile.FilenameLength);
      if CL > 0 then
        TempMSStream.write(S[1], CL);
      // ************************************
      FParent.NewLHOffsets[Count - 1] :=
        Result.FCentralDirectoryFile.RelativeOffsetOfLocalHeader;
      FParent.RebuildCentralDirectory(TempMSStream);
      FParent.RebuildEndOfCentralDirectory(TempMSStream);
      // ************************************
      TempMSStream.Position := 0;
      OSL := FParent.FZipStream.Size;
      try
        FParent.FZipStream.Size := TempMSStream.Size;
      except
        FParent.FZipStream.Size := OSL;
        raise ;
      end;
      FParent.FZipStream.Position := 0;
      FParent.FZipStream.CopyFrom(TempMSStream, TempMSStream.Size);
    finally
      TempMSStream.Free;
    end;
  end;

  Result.FDate := FileDateToDateTime
    (Result.FCentralDirectoryFile.LastModFileTimeDate);
  if (Result.FCentralDirectoryFile.GeneralPurposeBitFlag and 1) > 0 then
    Result.FIsEncrypted := True
  else
    Result.FIsEncrypted := False;
  Result.FIsFolder :=
    (Result.FCentralDirectoryFile.ExternalFileAttributes and faDirectory)
    > 0;
  Result.FCompressionType := ctUnknown;
  if (Result.FCentralDirectoryFile.CompressionMethod = 8) or
    (Result.FCentralDirectoryFile.CompressionMethod = 9) then
  begin
    case Result.FCentralDirectoryFile.GeneralPurposeBitFlag and 6 of
      0:
        Result.FCompressionType := ctNormal;
      2:
        Result.FCompressionType := ctMaximum;
      4:
        Result.FCompressionType := ctFast;
      6:
        Result.FCompressionType := ctSuperFast
    end;
  end;
  FParent.FIsDirty := True;
  if not FParent.FBatchMode then
  begin
    FParent.DoChange(FParent, 2);
  end;
end;

function TKAZipEntries.AddFolderChain(const ItemName: string; FileAttr: WORD;
  FileDate: TDateTime): Boolean;
var
  FN: string;
  TN: string;
  INCN: string;
  P: Integer;
  MS: TMemoryStream;
  NoMore: Boolean;
begin
  FN := ExtractFilePath(ToDosName(ToZipName(ItemName)));
  TN := FN;
  INCN := '';
  MS := TMemoryStream.Create;
  try
    repeat
      NoMore := True;
      P := Pos('\', TN);
      if P > 0 then
      begin
        INCN := INCN + Copy(TN, 1, P);
        System.Delete(TN, 1, P);
        MS.Position := 0;
        MS.Size := 0;
        if IndexOf(INCN) = -1 then
        begin
          if FParent.FZipSaveMethod = FastSave then
            AddStreamFast(INCN, FileAttr, FileDate, MS)
          else if FParent.FZipSaveMethod = RebuildAll then
            AddStreamRebuild(INCN, FileAttr, FileDate, MS);
        end;
        NoMore := False;
      end;
    until NoMore;
    Result := True;
  finally
    MS.Free;
  end;
end;

function TKAZipEntries.AddFolderChain(const ItemName: string): Boolean;
begin
  Result := AddFolderChain(ItemName, faDirectory, Now);
end;

function TKAZipEntries.AddStream(const FileName: string; FileAttr: WORD;
  FileDate: TDateTime; Stream: TStream): TKAZipEntriesEntry;
begin
  Result := nil;
  if (FParent.FStoreFolders) and (FParent.FStoreRelativePath) then
    AddFolderChain(FileName);
  if FParent.FZipSaveMethod = FastSave then
    Result := AddStreamFast(FileName, FileAttr, FileDate, Stream)
  else if FParent.FZipSaveMethod = RebuildAll then
    Result := AddStreamRebuild(FileName, FileAttr, FileDate, Stream);
  if Assigned(FParent.FOnAddItem) then
    FParent.FOnAddItem(FParent, FileName);
end;

function TKAZipEntries.AddStream(const FileName: string;
  Stream: TStream): TKAZipEntriesEntry;
begin
  Result := AddStream(FileName, faArchive, Now, Stream);
end;

function TKAZipEntries.AddFile(const FileName, NewFileName: string)
  : TKAZipEntriesEntry;
var
  FS: TFileStream;
  Dir: TSearchRec;
  Res: Integer;
begin
  Result := nil;
  Res := FindFirst(FileName, faAnyFile, Dir);
  if Res = 0 then
  begin
    FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      FS.Position := 0;
      Result := AddStream(NewFileName, Dir.Attr, FileDateToDateTime(Dir.Time),
        FS) finally FS.Free;
    end;
  end;
  FindClose(Dir);
end;

function TKAZipEntries.AddFile(const FileName: string): TKAZipEntriesEntry;
begin
  Result := AddFile(FileName, FileName);
end;

function TKAZipEntries.AddFiles(FileNames: TStrings): Boolean;
var
  X: Integer;
begin
  Result := False;
  FParent.FBatchMode := True;
  try
    for X := 0 to FileNames.Count - 1 do
      AddFile(FileNames.Strings[X]);
  except
    FParent.FBatchMode := False;
    FParent.DoChange(FParent, 2);
    Exit;
  end;
  FParent.FBatchMode := False;
  FParent.DoChange(FParent, 2);
  Result := True;
end;

function TKAZipEntries.AddFolderEx(const FolderName: string; const RootFolder: string;
  const WildCard: string; WithSubFolders: Boolean): Boolean;
var
  Res: Integer;
  Dir: TSearchRec;
  FN: string;
begin
  Res := FindFirst(FolderName + '\*.*', faAnyFile, Dir);
  while Res = 0 do
  begin
    if (Dir.Attr and faDirectory) > 0 then
    begin
      if (Dir.name <> '..') and (Dir.name <> '.') then
      begin
        FN := FolderName + '\' + Dir.name;
        if (FParent.FStoreFolders) and (FParent.FStoreRelativePath) then
          AddFolderChain(RemoveRootName(FN + '\', RootFolder), Dir.Attr,
            FileDateToDateTime(Dir.Time));
        if WithSubFolders then
        begin
          AddFolderEx(FN, RootFolder, WildCard, WithSubFolders);
        end;
      end
      else
      begin
        if (Dir.name = '.') then
          AddFolderChain(RemoveRootName(FolderName + '\', RootFolder),
            Dir.Attr, FileDateToDateTime(Dir.Time));
      end;
    end
    else
    begin
      FN := FolderName + '\' + Dir.name;
      if MatchesMask(FN, WildCard) then
      begin
        AddFile(FN, RemoveRootName(FN, RootFolder));
      end;
    end;
    Res := FindNext(Dir);
  end;
  FindClose(Dir);
  Result := True;
end;

function TKAZipEntries.AddFolder(const FolderName: string; const RootFolder: string;
  const WildCard: string; WithSubFolders: Boolean): Boolean;
begin
  FParent.FBatchMode := True;
  try
    Result := AddFolderEx(FolderName, RootFolder, WildCard, WithSubFolders);
  finally
    FParent.FBatchMode := False;
    FParent.DoChange(FParent, 2);
  end;
end;

function TKAZipEntries.AddFilesAndFolders(FileNames: TStrings;
  const RootFolder: string; WithSubFolders: Boolean): Boolean;
var
  X: Integer;
  Res: Integer;
  Dir: TSearchRec;
begin
  FParent.FBatchMode := True;
  try
    for X := 0 to FileNames.Count - 1 do
    begin
      Res := FindFirst(FileNames.Strings[X], faAnyFile, Dir);
      if Res = 0 then
      begin
        if (Dir.Attr and faDirectory) > 0 then
        begin
          if (Dir.name <> '..') and (Dir.name <> '.') then
          begin
            AddFolderEx(FileNames.Strings[X], RootFolder, '*.*',
              WithSubFolders);
          end;
        end
        else
        begin
          AddFile(FileNames.Strings[X], RemoveRootName(FileNames.Strings[X],
              RootFolder));
        end;
      end;
      FindClose(Dir);
    end;
  finally
    FParent.FBatchMode := False;
    FParent.DoChange(FParent, 2);
  end;
  Result := True;
end;

procedure TKAZipEntries.RemoveFiles(List: TList);
begin
  if List.Count = 1 then
  begin
    Remove(Integer(List.Items[0]));
  end
  else
  begin
    SortList(List);
    FParent.FBatchMode := True;
    try
      RemoveBatch(List);
    finally
      FParent.FBatchMode := False;
      FParent.DoChange(Self, 3);
    end;
  end;
end;

procedure TKAZipEntries.RemoveSelected;
var
  X: Integer;
  List: TList;
begin
  FParent.FBatchMode := True;
  List := TList.Create;
  try
    for X := 0 to Count - 1 do
    begin
      if Self.Items[X].Selected then
        List.Add(Pointer(X));
    end;
    RemoveBatch(List);
  finally
    List.Free;
    FParent.FBatchMode := False;
    FParent.DoChange(Self, 3);
  end;
end;

procedure TKAZipEntries.ExtractToStream(Item: TKAZipEntriesEntry;
  Stream: TStream);
var
  SFS: TMemoryStream;
  TFS: TStream;
  buf: AnsiString;
  NR: Cardinal;
  Decompressor: TDecompressionStream;
{$IFDEF USE_BZIP2}
  DecompressorBZ2: TBZDecompressionStream;
{$ENDIF}
begin
  if ((Item.CompressionMethod = 8) or
{$IFDEF USE_BZIP2}
    (Item.CompressionMethod = 12) or
{$ENDIF}
    (Item.CompressionMethod = 0)) and (not Item.FIsEncrypted) then
  begin
    SFS := TMemoryStream.Create;
    TFS := Stream;
    try
      if Item.GetCompressedData(SFS) > 0 then
      begin
        SFS.Position := 0;
        FParent.FCurrentDFS := Item.SizeUncompressed;
        // ****************************************************** DEFLATE
        if (Item.CompressionMethod = 8) then
        begin
          Decompressor := TDecompressionStream.Create(SFS);
          Decompressor.OnProgress := FParent.OnDecompress;
          SetLength(buf, FParent.FCurrentDFS);
          try
            NR := Decompressor.read(buf[1], FParent.FCurrentDFS);
            if NR = FParent.FCurrentDFS then
              TFS.write(buf[1], FParent.FCurrentDFS);
          finally
            Decompressor.Free;
          end;
        end
        // ******************************************************* BZIP2
{$IFDEF USE_BZIP2}
        else if Item.CompressionMethod = 12 then
        begin
          DecompressorBZ2 := TBZDecompressionStream.Create(SFS);
          DecompressorBZ2.OnProgress := FParent.OnDecompress;
          SetLength(buf, FParent.FCurrentDFS);
          try
            NR := DecompressorBZ2.read(buf[1], FParent.FCurrentDFS);
            if NR = FParent.FCurrentDFS then
              TFS.write(buf[1], FParent.FCurrentDFS);
          finally
            DecompressorBZ2.Free;
          end;
        end
{$ENDIF}
        // ****************************************************** STORED
        else if Item.CompressionMethod = 0 then
        begin
          TFS.CopyFrom(SFS, FParent.FCurrentDFS);
        end;
      end;
    finally
      SFS.Free;
    end;
  end
  else
  begin
    raise Exception.Create('Cannot process this file: ' + Item.FileName + ' ');
  end;
end;

procedure TKAZipEntries.InternalExtractToFile(Item: TKAZipEntriesEntry;
  FileName: string);
var
  TFS: TFileStream;
  Attr: Integer;
begin
  if Item.IsFolder then
  begin
    ForceDirectories(FileName);
  end
  else
  begin
    TFS := TFileStream.Create(FileName,
      FmCreate or fmOpenReadWrite or fmShareDenyNone);
    try
      ExtractToStream(Item, TFS);
    finally
      TFS.Free;
    end;
    if FParent.FApplyAttributes then
    begin
      Attr := faArchive;
      if Item.FCentralDirectoryFile.ExternalFileAttributes and faHidden > 0 then
        Attr := Attr or faHidden;
      if Item.FCentralDirectoryFile.ExternalFileAttributes and faSysFile >
        0 then
        Attr := Attr or faSysFile;
      if Item.FCentralDirectoryFile.ExternalFileAttributes and faReadOnly >
        0 then
        Attr := Attr or faReadOnly;
      FileSetAttr(FileName, Attr);
    end;
  end;
end;

procedure TKAZipEntries.ExtractToFile(Item: TKAZipEntriesEntry;
  const AFileName: string);
var
  Can: Boolean;
  OA: TOverwriteAction;
  FileName: string;
begin
  OA := FParent.FOverwriteAction;
  Can := True;
  FileName := AFileName;
  if ((OA <> oaOverwriteAll) and (OA <> oaSkipAll)) and
    (Assigned(FParent.FOnOverwriteFile)) then
  begin
    if FileExists(FileName) then
    begin
      FParent.FOnOverwriteFile(FParent, FileName, OA);
    end
    else
    begin
      OA := oaOverwrite;
    end;
  end;
  case OA of
    oaSkip:
      Can := False;
    oaSkipAll:
      Can := False;
    oaOverwrite:
      Can := True;
    oaOverwriteAll:
      Can := True;
  end;
  if Can then
    InternalExtractToFile(Item, FileName);
end;

procedure TKAZipEntries.ExtractToFile(ItemIndex: Integer; const AFileName: string);
var
  Can: Boolean;
  OA: TOverwriteAction;
  FileName: string;
begin
  OA := FParent.FOverwriteAction;
  Can := True;
  FileName := AFileName;
  if ((OA <> oaOverwriteAll) and (OA <> oaSkipAll)) and
    (Assigned(FParent.FOnOverwriteFile)) then
  begin
    if FileExists(FileName) then
    begin
      FParent.FOnOverwriteFile(FParent, FileName, OA);
    end
    else
    begin
      OA := oaOverwrite;
    end;
  end;
  case OA of
    oaSkip:
      Can := False;
    oaSkipAll:
      Can := False;
    oaOverwrite:
      Can := True;
    oaOverwriteAll:
      Can := True;
  end;
  if Can then
    InternalExtractToFile(Items[ItemIndex], FileName);
end;

procedure TKAZipEntries.ExtractToFile(const FileName, ADestinationFileName: string);
var
  I: Integer;
  Can: Boolean;
  OA: TOverwriteAction;
  DestinationFileName: string;
begin
  OA := FParent.FOverwriteAction;
  Can := True;
  DestinationFileName := ADestinationFileName;
  if ((OA <> oaOverwriteAll) and (OA <> oaSkipAll)) and
    (Assigned(FParent.FOnOverwriteFile)) then
  begin
    if FileExists(DestinationFileName) then
    begin
      FParent.FOnOverwriteFile(FParent, DestinationFileName, OA);
    end
    else
    begin
      OA := oaOverwrite;
    end;
  end;
  case OA of
    oaSkip:
      Can := False;
    oaSkipAll:
      Can := False;
    oaOverwrite:
      Can := True;
    oaOverwriteAll:
      Can := True;
  end;
  if Can then
  begin
    I := IndexOf(FileName);
    InternalExtractToFile(Items[I], DestinationFileName);
  end;
end;

procedure TKAZipEntries.ExtractAll(const TargetDirectory: string);
var
  FN: string;
  DN: string;
  X: Integer;
  Can: Boolean;
  OA: TOverwriteAction;
  FileName: string;
begin
  OA := FParent.FOverwriteAction;
  Can := True;
  try
    for X := 0 to Count - 1 do
    begin
      FN := FParent.GetFileName(Items[X].FileName);
      DN := FParent.GetFilePath(Items[X].FileName);
      if DN <> '' then
        ForceDirectories(TargetDirectory + '\' + DN);
      FileName := TargetDirectory + '\' + DN + FN;
      if ((OA <> oaOverwriteAll) and (OA <> oaSkipAll)) and
        (Assigned(FParent.FOnOverwriteFile)) then
      begin
        if FileExists(FileName) then
        begin
          FParent.FOnOverwriteFile(FParent, FileName, OA);
        end;
      end;
      case OA of
        oaSkip:
          Can := False;
        oaSkipAll:
          Can := False;
        oaOverwrite:
          Can := True;
        oaOverwriteAll:
          Can := True;
      end;
      if Can then
        InternalExtractToFile(Items[X], FileName);
    end;
  finally
  end;
end;

procedure TKAZipEntries.ExtractSelected(const TargetDirectory: string);
var
  FN: string;
  DN: string;
  X: Integer;
  OA: TOverwriteAction;
  Can: Boolean;
  FileName: string;
begin
  OA := FParent.FOverwriteAction;
  Can := True;
  try
    for X := 0 to Count - 1 do
    begin
      if Items[X].FSelected then
      begin
        FN := FParent.GetFileName(Items[X].FileName);
        DN := FParent.GetFilePath(Items[X].FileName);
        if DN <> '' then
          ForceDirectories(TargetDirectory + '\' + DN);
        FileName := TargetDirectory + '\' + DN + FN;
        if ((OA <> oaOverwriteAll) and (OA <> oaSkipAll)) and
          (Assigned(FParent.FOnOverwriteFile)) then
        begin
          if FileExists(FileName) then
          begin
            FParent.FOnOverwriteFile(FParent, FileName, OA);
          end;
        end;
        case OA of
          oaSkip:
            Can := False;
          oaSkipAll:
            Can := False;
          oaOverwrite:
            Can := True;
          oaOverwriteAll:
            Can := True;
        end;
        if Can then
          InternalExtractToFile(Items[X], TargetDirectory + '\' + DN + FN);
      end;
    end;
  finally
  end;
end;

procedure TKAZipEntries.DeSelectAll;
var
  X: Integer;
begin
  for X := 0 to Count - 1 do
    Items[X].Selected := False;
end;

procedure TKAZipEntries.InvertSelection;
var
  X: Integer;
begin
  for X := 0 to Count - 1 do
    Items[X].Selected := not Items[X].Selected;
end;

procedure TKAZipEntries.SelectAll;
var
  X: Integer;
begin
  for X := 0 to Count - 1 do
    Items[X].Selected := True;
end;

procedure TKAZipEntries.Select(const WildCard: string);
var
  X: Integer;
begin
  for X := 0 to Count - 1 do
  begin
    if MatchesMask(ToDosName(Items[X].FileName), WildCard) then
      Items[X].Selected := True;
  end;
end;

procedure TKAZipEntries.Rebuild;
begin
  FParent.Rebuild;
end;

procedure TKAZipEntries.Rename(Item: TKAZipEntriesEntry; const NewFileName: string);
begin
  Item.FileName := NewFileName;
end;

procedure TKAZipEntries.Rename(ItemIndex: Integer; const NewFileName: string);
begin
  Rename(Items[ItemIndex], NewFileName);
end;

procedure TKAZipEntries.Rename(const FileName, NewFileName: string);
var
  I: Integer;
begin
  I := IndexOf(FileName);
  Rename(I, NewFileName);
end;

procedure TKAZipEntries.CreateFolder(const FolderName: string; FolderDate: TDateTime);
var
  FN: string;
begin
  FN := IncludeTrailingPathDelimiter(FolderName);
  AddFolderChain(FN, faDirectory, FolderDate);
  FParent.FIsDirty := True;
end;

procedure TKAZipEntries.RenameFolder(const FolderName: string; const NewFolderName: string);
var
  FN: string;
  NFN: string;
  S: string;
  X: Integer;
  L: Integer;
begin
  FN := ToZipName(IncludeTrailingPathDelimiter(FolderName));
  NFN := ToZipName(IncludeTrailingPathDelimiter(NewFolderName));
  L := Length(FN);
  if IndexOf(NFN) = -1 then
  begin
    for X := 0 to Count - 1 do
    begin
      S := Items[X].FileName;
      if Pos(FN, S) = 1 then
      begin
        System.Delete(S, 1, L);
        S := NFN + S;
        Items[X].FileName := S;
        FParent.FIsDirty := True;
      end;
    end;
    if (FParent.FIsDirty) and (FParent.FBatchMode = False) then
      Rebuild;
  end;
end;

procedure TKAZipEntries.RenameMultiple(Names: TStringList;
  NewNames: TStringList);
var
  X: Integer;
  BR: Integer;
  L: Integer;
begin
  if Names.Count <> NewNames.Count then
  begin
    raise Exception.Create('Names and NewNames must have equal count');
  end
  else
  begin
    BR := 0;
    FParent.FBatchMode := True;
    try
      for X := 0 to Names.Count - 1 do
      begin
        L := Length(Names.Strings[X]);
        if (L > 0) and ((Names.Strings[X][L] = '\') or
            (Names.Strings[X][L] = '/')) then
        begin
          RenameFolder(Names.Strings[X], NewNames.Strings[X]);
          Inc(BR);
        end
        else
        begin
          Rename(Names.Strings[X], NewNames.Strings[X]);
          Inc(BR);
        end;
      end;
    finally
      FParent.FBatchMode := False;
    end;
    if BR > 0 then
    begin
      Rebuild;
      FParent.DoChange(FParent, 6);
    end;
  end;
end;

{ TKAZip }
constructor TKAZip.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FZipStream := nil;
  FOnDecompressFile := nil;
  FOnCompressFile := nil;
  FOnZipChange := nil;
  FOnZipOpen := nil;
  FOnAddItem := nil;
  FOnOverwriteFile := nil;
  FComponentVersion := '2.0';
  FBatchMode := False;
  FFileNames := TStringList.Create;
  FZipHeader := TKAZipEntries.Create(Self);
  FZipComment := TStringList.Create;
  FIsZipFile := False;
  FFileName := '';
  FCurrentDFS := 0;
  FExternalStream := False;
  FIsDirty := True;
  FHasBadEntries := False;
  FReadOnly := False;

  FApplyAttributes := True;
  FOverwriteAction := oaSkip;
  FZipSaveMethod := FastSave;
  FUseTempFiles := False;
  FStoreRelativePath := True;
  FStoreFolders := True;
  FZipCompressionType := ctMaximum;
end;

destructor TKAZip.Destroy;
begin
  if Assigned(FZipStream) and (not FExternalStream) then
    FZipStream.Free;
  FZipHeader.Free;
  FZipComment.Free;
  FFileNames.Free;
  inherited Destroy;
end;

procedure TKAZip.DoChange(Sender: TObject; const ChangeType: Integer);
begin
  if Assigned(FOnZipChange) then
    FOnZipChange(Self, ChangeType);
end;

function TKAZip.GetFileName(const S: string): string;
var
  FN: string;
  P: Integer;
begin
  FN := S;
  FN := StringReplace(FN, '//', '\', [rfReplaceAll]);
  FN := StringReplace(FN, '/', '\', [rfReplaceAll]);
  P := Pos(':\', FN);
  if P > 0 then
    System.Delete(FN, 1, P + 1);
  Result := ExtractFileName(StringReplace(FN, '/', '\', [rfReplaceAll]));
end;

function TKAZip.GetFilePath(const S: string): string;
var
  FN: string;
  P: Integer;
begin
  FN := S;
  FN := StringReplace(FN, '//', '\', [rfReplaceAll]);
  FN := StringReplace(FN, '/', '\', [rfReplaceAll]);
  P := Pos(':\', FN);
  if P > 0 then
    System.Delete(FN, 1, P + 1);
  Result := ExtractFilePath(StringReplace(FN, '/', '\', [rfReplaceAll]));
end;

procedure TKAZip.LoadFromFile(const FileName: string);
var
  Res: Integer;
  Dir: TSearchRec;
begin
  Res := FindFirst(FileName, faAnyFile, Dir);
  if Res = 0 then
  begin
    if Dir.Attr and faReadOnly > 0 then
    begin
      FZipStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      FReadOnly := True;
    end
    else
    begin
      FZipStream := TFileStream.Create(FileName,
        fmOpenReadWrite or fmShareDenyNone);
      FReadOnly := False;
    end;
    LoadFromStream(FZipStream);
  end
  else
  begin
    raise Exception.Create('File "' + FileName + '" not found!');
  end;
end;

procedure TKAZip.LoadFromStream(MS: TStream);
begin
  FZipStream := MS;
  FZipHeader.ParseZip(MS);
  FIsZipFile := FZipHeader.FIsZipFile;
  if not FIsZipFile then
    Close;
  FIsDirty := True;
  DoChange(Self, 1);
end;

procedure TKAZip.Close;
begin
  Entries.Clear;
  if Assigned(FZipStream) and (not FExternalStream) then
    FZipStream.Free;
  FExternalStream := False;
  FZipStream := nil;
  FIsZipFile := False;
  FIsDirty := True;
  FReadOnly := False;
  DoChange(Self, 0);
end;

procedure TKAZip.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TKAZip.Open(const FileName: string);
begin
  Close;
  LoadFromFile(FileName);
  FFileName := FileName;
end;

procedure TKAZip.Open(MS: TStream);
begin
  try
    Close;
    LoadFromStream(MS);
  finally
    FExternalStream := True;
  end;
end;

procedure TKAZip.SetIsZipFile(const Value: Boolean);
begin
  // ****************************************************************************
end;

function TKAZip.GetDelphiTempFileName: string;
var
  TmpDir: array [0 .. 1000] of Char;
  TmpFN: array [0 .. 1000] of Char;
begin
  Result := GetCurrentDir;
  if GetTempPath(1000, TmpDir) <> 0 then
  begin
    if GetTempFileName(TmpDir, '', 0, TmpFN) <> 0 then
      Result := StrPas(TmpFN);
  end;
end;

procedure TKAZip.OnDecompress(Sender: TObject);
var
  DS: TStream;
begin
  DS := TStream(Sender);
  if Assigned(FOnDecompressFile) then
    FOnDecompressFile(Self, DS.Position, FCurrentDFS);
end;

procedure TKAZip.OnCompress(Sender: TObject);
var
  CS: TStream;
begin
  CS := TStream(Sender);
  if Assigned(FOnCompressFile) then
    FOnCompressFile(Self, CS.Position, FCurrentDFS);
end;

procedure TKAZip.ExtractToFile(Item: TKAZipEntriesEntry; const FileName: string);
begin
  Entries.ExtractToFile(Item, FileName);
end;

procedure TKAZip.ExtractToFile(ItemIndex: Integer; const FileName: string);
begin
  Entries.ExtractToFile(ItemIndex, FileName);
end;

procedure TKAZip.ExtractToFile(const FileName, DestinationFileName: string);
begin
  Entries.ExtractToFile(FileName, DestinationFileName);
end;

procedure TKAZip.ExtractToStream(Item: TKAZipEntriesEntry; Stream: TStream);
begin
  Entries.ExtractToStream(Item, Stream);
end;

procedure TKAZip.ExtractAll(const TargetDirectory: string);
begin
  Entries.ExtractAll(TargetDirectory);
end;

procedure TKAZip.ExtractSelected(const TargetDirectory: string);
begin
  Entries.ExtractSelected(TargetDirectory);
end;

function TKAZip.AddFile(const FileName, NewFileName: string): TKAZipEntriesEntry;
begin
  Result := Entries.AddFile(FileName, NewFileName);
end;

function TKAZip.AddFile(const FileName: string): TKAZipEntriesEntry;
begin
  Result := Entries.AddFile(FileName);
end;

function TKAZip.AddFiles(FileNames: TStrings): Boolean;
begin
  Result := Entries.AddFiles(FileNames);
end;

function TKAZip.AddFolder(const FolderName, RootFolder, WildCard: string;
  WithSubFolders: Boolean): Boolean;
begin
  Result := Entries.AddFolder(FolderName, RootFolder, WildCard, WithSubFolders);
end;

function TKAZip.AddFilesAndFolders(FileNames: TStrings; const RootFolder: string;
  WithSubFolders: Boolean): Boolean;
begin
  Result := Entries.AddFilesAndFolders(FileNames, RootFolder, WithSubFolders);
end;

function TKAZip.AddStream(const FileName: string; FileAttr: WORD;
  FileDate: TDateTime; Stream: TStream): TKAZipEntriesEntry;
begin
  Result := Entries.AddStream(FileName, FileAttr, FileDate, Stream);
end;

function TKAZip.AddStream(const FileName: string;
  Stream: TStream): TKAZipEntriesEntry;
begin
  Result := Entries.AddStream(FileName, Stream);
end;

procedure TKAZip.Remove(Item: TKAZipEntriesEntry);
begin
  Entries.Remove(Item);
end;

procedure TKAZip.Remove(ItemIndex: Integer);
begin
  Entries.Remove(ItemIndex);
end;

procedure TKAZip.Remove(const FileName: string);
begin
  Entries.Remove(FileName);
end;

procedure TKAZip.RemoveFiles(List: TList);
begin
  Entries.RemoveFiles(List);
end;

procedure TKAZip.RemoveSelected;
begin
  Entries.RemoveSelected; ;
end;

function TKAZip.GetComment: TStrings;
var
  S: AnsiString;
begin
  Result := FZipComment;
  FZipComment.Clear;
  if FIsZipFile then
  begin
    if FEndOfCentralDir.ZipfileCommentLength > 0 then
    begin
      FZipStream.Position := FZipCommentPos;
      SetLength(S, FEndOfCentralDir.ZipfileCommentLength);
      FZipStream.read(S[1], FEndOfCentralDir.ZipfileCommentLength);
      FZipComment.Text := string(S);
    end;
  end;
end;

procedure TKAZip.SetComment(const Value: TStrings);
var
  Comment: string;
  L: Integer;
begin
  // ****************************************************************************
  if FZipComment.Text = Value.Text then
    Exit;
  FZipComment.Clear;
  if FIsZipFile then
  begin
    FZipComment.Assign(Value);
    Comment := FZipComment.Text;
    L := Length(Comment);
    FEndOfCentralDir.ZipfileCommentLength := L;
    FZipStream.Position := FEndOfCentralDirPos;
    FZipStream.write(FEndOfCentralDir, SizeOf(TEndOfCentralDir));
    FZipCommentPos := FZipStream.Position;
    if L > 0 then
    begin
      FZipStream.write(Comment[1], L)
    end
    else
    begin
      FZipStream.Size := FZipStream.Position;
    end;
  end;
end;

procedure TKAZip.DeSelectAll;
begin
  Entries.DeSelectAll;
end;

procedure TKAZip.Select(const WildCard: string);
begin
  Entries.Select(WildCard);
end;

procedure TKAZip.InvertSelection;
begin
  Entries.InvertSelection;
end;

procedure TKAZip.SelectAll;
begin
  Entries.SelectAll;
end;

procedure TKAZip.RebuildLocalFiles(MS: TStream);
var
  X: Integer;
  LF: TLocalFile;
begin
  // ************************************************* RESAVE ALL LOCAL BLOCKS
  SetLength(NewLHOffsets, Entries.Count + 1);
  for X := 0 to Entries.Count - 1 do
  begin
    NewLHOffsets[X] := MS.Position;
    Entries.GetLocalEntry(FZipStream, Entries.Items[X].LocalOffset, False, LF);
    MS.write(LF, SizeOf(LF) - 3 * SizeOf(string));
    if LF.FilenameLength > 0 then
      MS.write(LF.FileName[1], LF.FilenameLength);
    if LF.ExtraFieldLength > 0 then
      MS.write(LF.ExtraField[1], LF.ExtraFieldLength);
    if LF.CompressedSize > 0 then
      MS.write(LF.CompressedData[1], LF.CompressedSize);
    if Assigned(FOnRebuildZip) then
      FOnRebuildZip(Self, X, Entries.Count - 1);
  end;
end;

procedure TKAZip.RebuildCentralDirectory(MS: TStream);
var
  X: Integer;
  CDF: TCentralDirectoryFile;
begin
  NewEndOfCentralDir := FEndOfCentralDir;
  NewEndOfCentralDir.TotalNumberOfEntriesOnThisDisk := Entries.Count;
  NewEndOfCentralDir.TotalNumberOfEntries := Entries.Count;
  NewEndOfCentralDir.OffsetOfStartOfCentralDirectory := MS.Position;
  for X := 0 to Entries.Count - 1 do
  begin
    CDF := Entries.Items[X].FCentralDirectoryFile;
    CDF.RelativeOffsetOfLocalHeader := NewLHOffsets[X];
    MS.write(CDF, SizeOf(CDF) - 3 * SizeOf(string));
    if CDF.FilenameLength > 0 then
      MS.write(CDF.FileName[1], CDF.FilenameLength);
    if CDF.ExtraFieldLength > 0 then
      MS.write(CDF.ExtraField[1], CDF.ExtraFieldLength);
    if CDF.FileCommentLength > 0 then
      MS.write(CDF.FileComment[1], CDF.FileCommentLength);
    if Assigned(FOnRebuildZip) then
      FOnRebuildZip(Self, X, Entries.Count - 1);
  end;
  NewEndOfCentralDir.SizeOfTheCentralDirectory := MS.Position -
    NewEndOfCentralDir.OffsetOfStartOfCentralDirectory;
end;

procedure TKAZip.RebuildEndOfCentralDirectory(MS: TStream);
var
  ZipComment: string;
begin
  ZipComment := Comment.Text;
  FRebuildECDP := MS.Position;
  MS.write(NewEndOfCentralDir, SizeOf(NewEndOfCentralDir));
  FRebuildCP := MS.Position;
  if NewEndOfCentralDir.ZipfileCommentLength > 0 then
  begin
    MS.write(ZipComment[1], NewEndOfCentralDir.ZipfileCommentLength);
  end;
  if Assigned(FOnRebuildZip) then
    FOnRebuildZip(Self, 100, 100);
end;

procedure TKAZip.FixZip(MS: TStream);
var
  X: Integer;
  Y: Integer;
  NewCount: Integer;
  LF: TLocalFile;
  CDF: TCentralDirectoryFile;
  ZipComment: string;
begin
  ZipComment := Comment.Text;
  Y := 0;
  SetLength(NewLHOffsets, Entries.Count + 1);
  for X := 0 to Entries.Count - 1 do
  begin
    Entries.GetLocalEntry(FZipStream, Entries.Items[X].LocalOffset, False, LF);
    if (LF.LocalFileHeaderSignature = $04034B50) and (Entries.Items[X].Test)
      then
    begin
      NewLHOffsets[Y] := MS.Position;
      MS.write(LF, SizeOf(LF) - 3 * SizeOf(string));
      if LF.FilenameLength > 0 then
        MS.write(LF.FileName[1], LF.FilenameLength);
      if LF.ExtraFieldLength > 0 then
        MS.write(LF.ExtraField[1], LF.ExtraFieldLength);
      if LF.CompressedSize > 0 then
        MS.write(LF.CompressedData[1], LF.CompressedSize);
      if Assigned(FOnRebuildZip) then
        FOnRebuildZip(Self, X, Entries.Count - 1);
      Inc(Y);
    end
    else
    begin
      Entries.Items[X].FCentralDirectoryFile.CentralFileHeaderSignature := 0;
      if Assigned(FOnRebuildZip) then
        FOnRebuildZip(Self, X, Entries.Count - 1);
    end;
  end;

  NewCount := Y;
  Y := 0;
  NewEndOfCentralDir := FEndOfCentralDir;
  NewEndOfCentralDir.TotalNumberOfEntriesOnThisDisk := NewCount;
  NewEndOfCentralDir.TotalNumberOfEntries := NewCount;
  NewEndOfCentralDir.OffsetOfStartOfCentralDirectory := MS.Position;
  for X := 0 to Entries.Count - 1 do
  begin
    CDF := Entries.Items[X].FCentralDirectoryFile;
    if CDF.CentralFileHeaderSignature = $02014B50 then
    begin
      CDF.RelativeOffsetOfLocalHeader := NewLHOffsets[Y];
      MS.write(CDF, SizeOf(CDF) - 3 * SizeOf(string));
      if CDF.FilenameLength > 0 then
        MS.write(CDF.FileName[1], CDF.FilenameLength);
      if CDF.ExtraFieldLength > 0 then
        MS.write(CDF.ExtraField[1], CDF.ExtraFieldLength);
      if CDF.FileCommentLength > 0 then
        MS.write(CDF.FileComment[1], CDF.FileCommentLength);
      if Assigned(FOnRebuildZip) then
        FOnRebuildZip(Self, X, Entries.Count - 1);
      Inc(Y);
    end;
  end;
  NewEndOfCentralDir.SizeOfTheCentralDirectory := MS.Position -
    NewEndOfCentralDir.OffsetOfStartOfCentralDirectory;

  FRebuildECDP := MS.Position;
  MS.write(NewEndOfCentralDir, SizeOf(NewEndOfCentralDir));
  FRebuildCP := MS.Position;
  if NewEndOfCentralDir.ZipfileCommentLength > 0 then
  begin
    MS.write(ZipComment[1], NewEndOfCentralDir.ZipfileCommentLength);
  end;
  if Assigned(FOnRebuildZip) then
    FOnRebuildZip(Self, 100, 100);
end;

procedure TKAZip.SaveToStream(Stream: TStream);
begin
  RebuildLocalFiles(Stream);
  RebuildCentralDirectory(Stream);
  RebuildEndOfCentralDirectory(Stream);
end;

procedure TKAZip.Rebuild;
var
  TempStream: TFileStream;
  TempMSStream: TMemoryStream;
  TempFileName: string;
begin
  if FUseTempFiles then
  begin
    TempFileName := GetDelphiTempFileName;
    TempStream := TFileStream.Create(TempFileName, fmOpenReadWrite or FmCreate);
    try
      SaveToStream(TempStream);
      FZipStream.Position := 0;
      FZipStream.Size := 0;
      TempStream.Position := 0;
      FZipStream.CopyFrom(TempStream, TempStream.Size);
      Entries.ParseZip(FZipStream);
    finally
      TempStream.Free;
      DeleteFile(TempFileName)
    end;
  end
  else
  begin
    TempMSStream := TMemoryStream.Create;
    try
      SaveToStream(TempMSStream);
      FZipStream.Position := 0;
      FZipStream.Size := 0;
      TempMSStream.Position := 0;
      FZipStream.CopyFrom(TempMSStream, TempMSStream.Size);
      Entries.ParseZip(FZipStream);
    finally
      TempMSStream.Free;
    end;
  end;
  FIsDirty := True;
end;

procedure TKAZip.CreateZip(Stream: TStream);
var
  ECD: TEndOfCentralDir;
begin
  ECD.EndOfCentralDirSignature := $06054B50;
  ECD.NumberOfThisDisk := 0;
  ECD.NumberOfTheDiskWithTheStart := 0;
  ECD.TotalNumberOfEntriesOnThisDisk := 0;
  ECD.TotalNumberOfEntries := 0;
  ECD.SizeOfTheCentralDirectory := 0;
  ECD.OffsetOfStartOfCentralDirectory := 0;
  ECD.ZipfileCommentLength := 0;
  Stream.write(ECD, SizeOf(ECD));
end;

procedure TKAZip.CreateZip(const FileName: string);
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(FileName, fmOpenReadWrite or FmCreate);
  try
    CreateZip(FS);
  finally
    FS.Free;
  end;
end;

procedure TKAZip.SetZipSaveMethod(const Value: TZipSaveMethod);
begin
  FZipSaveMethod := Value;
end;

procedure TKAZip.SetActive(const Value: Boolean);
begin
  if FFileName = '' then
    Exit;
  if Value then
    Open(FFileName)
  else
    Close;
end;

procedure TKAZip.SetZipCompressionType(const Value: TZipCompressionType);
begin
  FZipCompressionType := Value;
  if FZipCompressionType = ctUnknown then
    FZipCompressionType := ctNormal;
end;

function TKAZip.GetFileNames: TStrings;
var
  X: Integer;
begin
  if FIsDirty then
  begin
    FFileNames.Clear;
    for X := 0 to Entries.Count - 1 do
    begin
      FFileNames.Add(GetFilePath(Entries.Items[X].FileName) + GetFileName
          (Entries.Items[X].FileName));
    end;
    FIsDirty := False;
  end;
  Result := FFileNames;
end;

procedure TKAZip.SetFileNames(const Value: TStrings);
begin
  // *************************************************** READ ONLY
end;

procedure TKAZip.SetUseTempFiles(const Value: Boolean);
begin
  FUseTempFiles := Value;
end;

procedure TKAZip.Rename(Item: TKAZipEntriesEntry; const NewFileName: string);
begin
  Entries.Rename(Item, NewFileName);
end;

procedure TKAZip.Rename(ItemIndex: Integer; const NewFileName: string);
begin
  Entries.Rename(ItemIndex, NewFileName);
end;

procedure TKAZip.Rename(const FileName, NewFileName: string);
begin
  Entries.Rename(FileName, NewFileName);
end;

procedure TKAZip.RenameMultiple(Names, NewNames: TStringList);
begin
  Entries.RenameMultiple(Names, NewNames);
end;

procedure TKAZip.SetStoreFolders(const Value: Boolean);
begin
  FStoreFolders := Value;
end;

procedure TKAZip.SetOnAddItem(const Value: TOnAddItem);
begin
  FOnAddItem := Value;
end;

procedure TKAZip.SetComponentVersion(const Value: string);
begin
  // ****************************************************************************
end;

procedure TKAZip.SetOnRebuildZip(const Value: TOnRebuildZip);
begin
  FOnRebuildZip := Value;
end;

procedure TKAZip.SetOnRemoveItems(const Value: TOnRemoveItems);
begin
  FOnRemoveItems := Value;
end;

procedure TKAZip.SetOverwriteAction(const Value: TOverwriteAction);
begin
  FOverwriteAction := Value;
end;

procedure TKAZip.SetOnOverwriteFile(const Value: TOnOverwriteFile);
begin
  FOnOverwriteFile := Value;
end;

procedure TKAZip.CreateFolder(const FolderName: string; FolderDate: TDateTime);
begin
  Entries.CreateFolder(FolderName, FolderDate);
end;

procedure TKAZip.RenameFolder(const FolderName: string; const NewFolderName: string);
begin
  Entries.RenameFolder(FolderName, NewFolderName);
end;

procedure TKAZip.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TKAZip.SetApplyAtributes(const Value: Boolean);
begin
  FApplyAttributes := Value;
end;

end.
