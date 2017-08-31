unit USourceFile;

interface

uses
  Windows, SysUtils, Forms, Graphics, Classes, Dialogs, Menus, ComCtrls,
  Controls, ShellApi, XMLDoc, XMLIntf, Makefile, Breakpoint, UTemplates,
  ModernTabs, UEditor, SystemUtils{*, libclang*};

const
  FILE_TYPE_PROJECT = 1;
  FILE_TYPE_C = 2;
  FILE_TYPE_CPP = 3;
  FILE_TYPE_H = 4;
  FILE_TYPE_RC = 5;
  FILE_TYPE_UNKNOW = 6;
  FILE_TYPE_FOLDER = 7;
  FILE_TYPE_CONFIG = 8;
  FILE_TYPE_CONFIG_GROUP = 9;

  SHEET_TYPE_FILE = 1;
  SHEET_TYPE_DESGN = 2;

  ENCODING_ANSI = 0;
  ENCODING_UTF8 = 1;
  ENCODING_UCS2 = 2;

  ENDIAN_NONE = 0;
  ENDIAN_LITTLE = 1;
  ENDIAN_BIG = 2;

  LINE_ENDING_WINDOWS = 0;
  LINE_ENDING_LINUX = 1;
  LINE_ENDING_MAC = 2;

  USER_DEFINED = -2;
  NO_COMPILER = -1;
  COMPILER_C = 0;
  COMPILER_CPP = 1;
  COMPILER_RC = 2;
  COMPILERS: array[0..2] of string = (
    'C',
    'CPP',
    'RC'
  );

  APPTYPE_CONSOLE = 0;
  APPTYPE_GUI = 1;
  APPTYPE_DLL = 2;
  APPTYPE_LIB = 3;
  APPTYPE_FTM = 4;
  APPTYPE_FPK = 5;
  APPTYPES: array[0..5] of string = (
    'CONSOLE',
    'GUI',
    'DLL',
    'LIB',
    'FTM',
    'FPK'
    );

  APPEXTTYPES: array[0..5] of string = (
    '.exe',
    '.exe',
    '.dll',
    '.a',
    '.ftm',
    '.fpk'
  );

  FPJ_EXT: array[0..0] of string = (
    '.fpj'
  );
  RC_EXT: array[0..0] of string = (
    '.rc'
  );
  CPP_EXT: array[0..4] of string = (
    '.cpp', '.cc', '.cxx', '.c++', '.cp'
  );
  C_EXT: array[0..0] of string = (
    '.c'
  );
  H_EXT: array[0..3] of string = (
    '.h', '.hpp', '.rh', '.hh'
  );

  CONFIG_TYPES = [FILE_TYPE_CONFIG, FILE_TYPE_CONFIG_GROUP];
  NON_FILE_TYPES = [FILE_TYPE_FOLDER] + CONFIG_TYPES;
  CONTAINER_TYPES = [FILE_TYPE_FOLDER, FILE_TYPE_PROJECT];
  SOURCE_TYPES = [FILE_TYPE_C, FILE_TYPE_CPP, FILE_TYPE_H];
  FILES_TYPES = [FILE_TYPE_UNKNOW, FILE_TYPE_RC] + SOURCE_TYPES;

  { TODO -oMazin -c : Translate 11/10/2016 13:37:20 }
  DEFAULT_CONFIG_NAME = 'Default';
  NEW_CONFIG_FORMAT = 'Configuration %d';


  NEW_LINE = #13#10;
  LD_COMMAND = '-Wl';
  LD_OPTION_KILL_AT = '--kill-at';
  LD_OPTION_OUT_LIB = '--out-implib';
  LD_DLL_STATIC_LIB = LD_COMMAND + ',' + LD_OPTION_KILL_AT + ',' + LD_OPTION_OUT_LIB + ',%s%s%s';
type
  TFileTypeSet = set of Byte;
  TVersionInfo = class
  public
    Version: TVersion;
    LanguageID: Integer;
    CharsetID: Integer;
    CompanyName: string;
    FileVersion: string;
    FileDescription: string;
    InternalName: string;
    LegalCopyright: string;
    LegalTrademarks: string;
    OriginalFilename: string;
    ProductName: string;
    ProductVersion: string;
  public
    procedure Assign(const Value: TVersionInfo);
  end;

  TProjectConfiguration = class
  private
    FLibs: string;
    FFlags: string;
    FCompOpt: string;
    FTarget: string;
    FCmdLine: string;
    FDelObjPrior: Boolean;
    FDelObjAfter: Boolean;
    FDelMakAfter: Boolean;
    FDelResAfter: Boolean;
    FIncludeInfo: Boolean;
    FEnableTheme: Boolean;
    FRequiresAdmin: Boolean;
    FAppType: Integer;
    FCompilerType: Integer;
    FIconFileName: string;
    FIcon: TIcon;
    FAutoIncBuild: Boolean;
    FVersion: TVersionInfo;
    FName: string;
    procedure SetIcon(Value: TIcon);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(const Value: TProjectConfiguration);
    procedure Load(ParentNode: IXMLNode);
    procedure Save(ParentNode: IXMLNode);
  public
    property Name: string read FName write FName;
    property Version: TVersionInfo read FVersion;
    property Libs: string read FLibs write FLibs;
    property Flags: string read FFlags write FFlags;
    property CompilerOptions: string read FCompOpt write FCompOpt;
    property Target: string read FTarget write FTarget;
    property CmdLine: string read FCmdLine write FCmdLine;
    property AutoIncBuild: Boolean read FAutoIncBuild write FAutoIncBuild;
    property AppType: Integer read FAppType write FAppType;
    property CompilerType: Integer read FCompilerType write FCompilerType;
    property IncludeVersionInfo: Boolean read FIncludeInfo write FIncludeInfo;
    property EnableTheme: Boolean read FEnableTheme write FEnableTheme;
    property RequiresAdmin: Boolean read FRequiresAdmin write FRequiresAdmin;
    property DeleteObjsBefore: Boolean read FDelObjPrior write FDelObjPrior;
    property DeleteObjsAfter: Boolean read FDelObjAfter write FDelObjAfter;
    property DeleteMakefileAfter: Boolean read FDelMakAfter write FDelMakAfter;
    property DeleteResourcesAfter: Boolean read FDelResAfter write FDelResAfter;
    property Icon: TIcon read FIcon write SetIcon;
    property IconFileName: string read FIconFileName write FIconFileName;
  end;

  TProjectConfigurationEvent = procedure(Sender: TObject;
    Configuration: TProjectConfiguration) of object;
  TProjectConfigurationList = class
  private
    FConfigurations: TList;
    FOnDelete: TProjectConfigurationEvent;
    FOnAdd: TProjectConfigurationEvent;
    FOnChange: TProjectConfigurationEvent;
    function Get(Index: Integer): TProjectConfiguration;
    function GetCount: Integer;
    procedure Put(Index: Integer; const Value: TProjectConfiguration);
    procedure NotifyDelete(Configuration: TProjectConfiguration);
    procedure NotifyAdd(Configuration: TProjectConfiguration);
    procedure NotifyChange(Configuration: TProjectConfiguration);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Move(Index, Offset: Integer);
    function Add(Configuration: TProjectConfiguration): Integer; overload;
    function Add: TProjectConfiguration; overload;
    function IndexOf(const Name: string): Integer;
    function AvailableName: string;
  public
    property Items[Index: Integer]: TProjectConfiguration read Get write Put; default;
    property Count: Integer read GetCount;
    property OnDelete: TProjectConfigurationEvent read FOnDelete write FOnDelete;
    property OnAdd: TProjectConfigurationEvent read FOnAdd write FOnAdd;
    property OnChange: TProjectConfigurationEvent read FOnChange write FOnChange;
  end;

  TSourceFileSheet = class;
  TProjectBase = class;
  TSourceBase = class;
  TSourceFile = class;
  TProjectSource = class;
  TSourceDeletionEvent = procedure(Source: TSourceBase) of object;
  TSourceRenameEvent = procedure(Source: TSourceBase;
    const NewFileName: string) of object;
  TTypeChangedEvent = procedure (Source: TSourceBase; OldType: Integer) of object;
  TSourceFilterMethod = function(Source: TSourceBase): Boolean;

  TSourceBase = class
  private
    FDeleting: Boolean;
    FFileName: string;
    FFileType: Integer;
    FNode: TTreeNode;
    FProject: TProjectBase;
    FSaved: Boolean;
    FIsNew: Boolean;
    FReadOnly: Boolean;
    FOnDeletion: TSourceDeletionEvent;
    FOnRename: TSourceRenameEvent;
    FOnTypeChanged: TTypeChangedEvent;
    function GetParent: TSourceBase;
    function GetProject: TProjectBase;
  protected
    procedure GetSourcesBase(List: TStrings; Types, SkipTypes: TFileTypeSet;
      FilterMethod: TSourceFilterMethod; SingleLevel: Boolean);
    procedure SetProject(Value: TProjectBase); virtual;
    procedure SetFileType(Value: Integer); virtual;
    function GetName: string; virtual;
    function IsModified: Boolean; virtual;
    function GetFileName: string; virtual;
    procedure SetFileName(Value: string); virtual;
    procedure DoRename(const OldFileName: string); virtual;
    property Deleting: Boolean read FDeleting write FDeleting;
  public
    constructor Create(Node: TTreeNode);
    procedure Assign(Value: TSourceBase);
    procedure Save; virtual;
    procedure Delete; virtual;
    function Open: Boolean; virtual;
    procedure Changed; virtual;
    procedure Rename(const NewName: string); virtual;
    procedure AdjustProject(ProjectBase: TProjectBase);
    function SearchSource(const Name: string; var SourceFound: TSourceBase): Boolean; virtual;
    function GetFileByPathName(const RelativeName: string): TSourceFile; virtual;
  public
    property Parent: TSourceBase read GetParent;
    property Project: TProjectBase read GetProject write SetProject;
    property Node: TTreeNode read FNode;
    property Modified: Boolean read IsModified;
    property FileName: string read GetFileName write SetFileName;
    property Name: string read GetName;
    property FileType: Integer read FFileType write SetFileType;
    property Saved: Boolean read FSaved write FSaved;
    property IsNew: Boolean read FIsNew write FIsNew;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property OnDeletion: TSourceDeletionEvent read FOnDeletion write FOnDeletion;
    property OnRename: TSourceRenameEvent read FOnRename write FOnRename;
    property OnTypeChanged: TTypeChangedEvent read FOnTypeChanged write FOnTypeChanged;
  end;

  TSourcePhysical = class(TSourceBase)
  public
    procedure MoveTo(const Path: string); virtual; abstract;
    procedure CopyTo(const Path: string); virtual; abstract;
  end;

  TSourceFolder = class(TSourcePhysical)
  private
  protected
    function GetFileName: string; override;
    procedure SetFileName(Value: string); override;
    function IsModified: Boolean; override;
  public
    procedure Save; override;
    procedure DeleteOfDisk;
    procedure Delete; override;
    function IsParentOf(const Path: string): Boolean;
    procedure MoveTo(const Path: string); override;
    procedure CopyTo(const Path: string); override;
    function Open: Boolean; override;
    procedure GetSources(List: TStrings; Types: TFileTypeSet = [];
      SkipTypes: TFileTypeSet = []; FilterMethod: TSourceFilterMethod = nil;
      SingleLevel: Boolean = False);
    function SearchSource(const Name: string; var SourceFound: TSourceBase): Boolean; override;
    function SearchFile(const Name: string): TSourceFile;
  end;

  TSourceFile = class(TSourcePhysical)
  private
    // clang
    // FTranslationUnit: CXTranslationUnit;

    FFileDateTime: TDateTime;
    FSheet: TSourceFileSheet;
    FBreakpoint: TBreakpointList;
    FEncoding: Integer;
    FEndian: Integer;
    FWithBOM: Boolean;
    FLineEnding: Integer;
    procedure SetEncoding(const Value: Integer);
    procedure SetEndian(const Value: Integer);
    procedure AdjustEncoding(Encoding: TEncoding);
    function GetEncodingProcessor: TEncoding;
    procedure SetWithBOM(const Value: Boolean);
    procedure SetLineEnding(const Value: Integer);
    procedure UpdateSheetStatus(Modified: Boolean);
  protected
    function IsModified: Boolean; override;
    function GetFileName: string; override;
    procedure SetFileName(Value: string); override;
    class function FilterBreakPoint(SourceBase: TSourceBase): Boolean; static;
  public
    class function GetEditorEolMode(LineEnding: Integer): Integer;
    procedure TranslateUnit;
    procedure CodeCompleteAt(Line, Column: Integer);
    procedure MoveTo(const Path: string); override;
    procedure CopyTo(const Path: string); override;
    procedure DeleteOfDisk;
    procedure Delete; override;
    procedure Save; override;
    procedure Changed; override;
    procedure Close; virtual;
    function Open: Boolean; override;
    procedure GetSources(List: TStrings; Types: TFileTypeSet = [];
      SkipTypes: TFileTypeSet = []; FilterMethod: TSourceFilterMethod = nil;
      SingleLevel: Boolean = False); virtual;
    function ConvertToProjectSource: TProjectSource;
    function Edit(SelectTab: Boolean = True): TSourceFileSheet;
    function Editing: Boolean;
    function ViewPage: Boolean;
    procedure LoadFile(Text: TStrings); overload;
    function LoadFile(Text: TStrings; var WithBOM: Boolean;
      var LineBreak: string): TEncoding; overload;
    function GetSheet(var Sheet: TSourceFileSheet): Boolean;
    function FileChangedInDisk: Boolean;
    procedure Reload;
    procedure LoadFromFile(const FileName: string); virtual;
    procedure UpdateDate;
    procedure UpdateBreakpoint;
    procedure Assign(Value: TSourceFile);
    constructor Create(Node: TTreeNode);
    destructor Destroy; override;
    property Breakpoint: TBreakpointList read FBreakpoint;
    property DateOfFile: TDateTime read FFileDateTime write FFileDateTime;
    property Encoding: Integer read FEncoding write SetEncoding;
    property Endian: Integer read FEndian write SetEndian;
    property WithBOM: Boolean read FWithBOM write SetWithBOM;
    property LineEnding: Integer read FLineEnding write SetLineEnding;
  end;

  TSourceProperty = class(TSourceBase);

  TSourceConfigGroup = class(TSourceProperty)
  private
  public
    procedure GetSources(List: TStrings; Types: TFileTypeSet = [];
      SkipTypes: TFileTypeSet = []; FilterMethod: TSourceFilterMethod = nil;
      SingleLevel: Boolean = False);
  end;

  TSourceConfiguration = class(TSourceProperty)
  private
    function GetConfiguration: TProjectConfiguration;
    procedure SetConfiguration(const Value: TProjectConfiguration);
  protected
    procedure DoRename(const OldFileName: string); override;
  public
    procedure Delete; override;
    procedure Move(Offset: Integer);
    function Open: Boolean; override;
    property Configuration: TProjectConfiguration read GetConfiguration write SetConfiguration;
  end;

  TConfigurationChangedEvent = procedure(Sender: TObject; OldIndex: Integer) of object;
  TProjectBase = class(TSourceFile)
  private
    FTargetDateTime: TDateTime;
    FTemplateResources: TTemplateID;
    FCompilerPath: string;
    FCompiled: Boolean;
    FPropertyChanged: Boolean;
    FSomeFileChanged: Boolean;
    FCompilerPropertyChanged: Boolean;
    FDebugging: Boolean;
    FBreakpointChanged: Boolean;
    FBreakpointCursor: TBreakpoint;
    FForceClean: Boolean; //for header changes
    FConfigurations: TProjectConfigurationList;
    FConfigIndex: Integer;
    FOnConfigurationChanged: TConfigurationChangedEvent;
    procedure UpdateTarget(Value: string);
    function GetCurrentConfiguration: TProjectConfiguration;
    procedure SetCurrentConfiguration(const Value: TProjectConfiguration);
    procedure SetConfigIndex(const Value: Integer);
    procedure ConfigDeleted(Sender: TObject; Value: TProjectConfiguration);
    procedure ConfigurationChanged(OldIndex: Integer);
    // Begin Compatibility
    function GetAppType: Integer;
    function GetAutoIncBuild: Boolean;
    function GetCmdLine: string;
    function GetCompilerType: Integer;
    function GetCompOpt: string;
    function GetConfigName: string;
    function GetDelMakAfter: Boolean;
    function GetDelObjAfter: Boolean;
    function GetDelObjPrior: Boolean;
    function GetDelResAfter: Boolean;
    function GetEnableTheme: Boolean;
    function GetFlags: string;
    function GetIcon: TIcon;
    function GetIconFileName: string;
    function GetIncludeInfo: Boolean;
    function GetLibs: string;
    function GetRequiresAdmin: Boolean;
    function GetVersion: TVersionInfo;
    function GetTargetConfig: string;
    procedure SetAppType(const Value: Integer);
    procedure SetAutoIncBuild(const Value: Boolean);
    procedure SetCmdLine(const Value: string);
    procedure SetCompilerType(const Value: Integer);
    procedure SetCompOpt(const Value: string);
    procedure SetConfigName(const Value: string);
    procedure SetDelMakAfter(const Value: Boolean);
    procedure SetDelObjAfter(const Value: Boolean);
    procedure SetDelObjPrior(const Value: Boolean);
    procedure SetDelResAfter(const Value: Boolean);
    procedure SetEnableTheme(const Value: Boolean);
    procedure SetFlags(const Value: string);
    procedure SetIcon(const Value: TIcon);
    procedure SetIconFileName(const Value: string);
    procedure SetIncludeInfo(const Value: Boolean);
    procedure SetLibs(const Value: string);
    procedure SetRequiresAdmin(const Value: Boolean);
    procedure SetTarget(const Value: string);
    function GetSourceConfiguration(Index: Integer): TSourceConfiguration;
    function GetConfigurationGroup: TSourceConfigGroup;
    // End Compatibility
  public
    constructor Create(Node: TTreeNode);
    destructor Destroy; override;
    function GetResource(Res: TStrings): Boolean;
    procedure Build; virtual;
    procedure SaveAs(const FileName: string); virtual;
    function NeedBuild: Boolean; virtual;
    function GetTarget: string;
    function TargetChanged: Boolean;
    function GetBreakpointFiles(List: TStrings): Boolean;
    function HasBreakpoint: Boolean;
    function FilesChanged: Boolean;
    procedure SaveAll; virtual; abstract;
    procedure CloseAll; virtual; abstract;

    property TemplateResources: TTemplateID read FTemplateResources
      write FTemplateResources;
    property BreakpointCursor: TBreakpoint read FBreakpointCursor;
    property ConfigurationGroup: TSourceConfigGroup read GetConfigurationGroup;
  protected
  public
    property ConfigurationIndex: Integer read FConfigIndex write SetConfigIndex;
    property Configuration: TProjectConfiguration read GetCurrentConfiguration write SetCurrentConfiguration;
    property Configurations: TProjectConfigurationList read FConfigurations;
    property SourceConfiguration[Index: Integer]: TSourceConfiguration read GetSourceConfiguration;
    property ForceClean: Boolean read FForceClean write FForceClean;
    property Debugging: Boolean read FDebugging write FDebugging;
    property CompilerPath: string read FCompilerPath write FCompilerPath;
    property Compiled: Boolean read FCompiled write FCompiled;
    property TargetDateTime: TdateTime read FTargetDateTime write FTargetDateTime;
    property PropertyChanged: Boolean read FPropertyChanged write FPropertyChanged;
    property SomeFileChanged: Boolean read FSomeFileChanged write FSomeFileChanged;
    property BreakpointChanged: Boolean read FBreakpointChanged write FBreakpointChanged;
    property CompilePropertyChanged: Boolean read FCompilerPropertyChanged
      write FCompilerPropertyChanged;
    property OnConfigurationChanged: TConfigurationChangedEvent
      read FOnConfigurationChanged write FOnConfigurationChanged;

    // Compatibility
    property ConfigName: string read GetConfigName write SetConfigName;
    property Version: TVersionInfo read GetVersion;
    property Libs: string read GetLibs write SetLibs;
    property Flags: string read GetFlags write SetFlags;
    property CompilerOptions: string read GetCompOpt write SetCompOpt;
    property Target: string read GetTargetConfig write SetTarget;
    property CmdLine: string read GetCmdLine write SetCmdLine;
    property AutoIncBuild: Boolean read GetAutoIncBuild write SetAutoIncBuild;
    property AppType: Integer read GetAppType write SetAppType;
    property CompilerType: Integer read GetCompilerType write SetCompilerType;
    property IncludeVersionInfo: Boolean read GetIncludeInfo write SetIncludeInfo;
    property EnableTheme: Boolean read GetEnableTheme write SetEnableTheme;
    property RequiresAdmin: Boolean read GetRequiresAdmin write SetRequiresAdmin;
    property DeleteObjsBefore: Boolean read GetDelObjPrior write SetDelObjPrior;
    property DeleteObjsAfter: Boolean read GetDelObjAfter write SetDelObjAfter;
    property DeleteMakefileAfter: Boolean read GetDelMakAfter write SetDelMakAfter;
    property DeleteResourcesAfter: Boolean read GetDelResAfter write SetDelResAfter;
    property Icon: TIcon read GetIcon write SetIcon;
    property IconFileName: string read GetIconFileName write SetIconFileName;
  end;

  TProjectSource = class(TProjectBase)
  private
  protected
    function GetFileName: string; override;
  public
    procedure SaveAll; override;
    procedure CloseAll; override;
    function ConvertToSourceFile(Project: TProjectBase): TSourceFile;
    procedure GetSources(List: TStrings; Types: TFileTypeSet = [];
      SkipTypes: TFileTypeSet = []; FilterMethod: TSourceFilterMethod = nil;
      SingleLevel: Boolean = False); override;
  end;

  TProjectFile = class(TProjectBase)
  private
  protected
    function GetFileName: string; override;
    procedure SetFileName(Value: string); override;
    function GetName: string; override;
    function IsModified: Boolean; override;
  public
    function SearchFile(const Name: string): TSourceFile;
    procedure CloseAll; override;
    procedure Delete; override;
    procedure Close; override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadLayout;
    procedure SaveLayout;
    procedure SaveToFile(const FileName: string);
    procedure Save; override;
    procedure SaveAll; override;
    procedure SaveAs(const FileName: string); override;
    procedure MoveSavedTo(const Path: string);
    procedure CopySavedTo(const Path: string);
    function NeedBuild: Boolean; override;
    function SearchSource(const Name: string; var SourceFound: TSourceBase): Boolean; override;
  end;

  TProjectsSheet = class(TModernTabSheet)
  private
    FListView: TListView;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ListView: TListView read FListView;
  end;

  TPropertySheet = class(TModernTabSheet)
  private
    FSheetType: Integer;
  public
    property SheetType: Integer read FSheetType;
  end;

  TSourceFileSheet = class(TPropertySheet)
  private
    FEditor: TEditor;
    FSourceFile: TSourceFile;
  public
    class procedure UpdateEditor(Editor: TEditor);
    constructor CreateEditor(SourceFile: TSourceFile; PageCtrl: TModernPageControl;
      SelectTab: Boolean = True);
    destructor Destroy; override;
    property Editor: TEditor read FEditor;
    property SourceFile: TSourceFile read FSourceFile;
  end;

  EFileMoveError = class(Exception);

function IsValidSourceExt(const Ext: string): Boolean;

implementation

uses UFrmMain, UUtils, UConfig, TokenFile, TokenList, TokenUtils, DScintillaTypes,
  CustomColors, Highlighter, UnicodeUtils, Math;

const
  fileMoveError = 'Can''t move file ''%s'' to ''%s.''';
  fileRenameError = 'Can''t rename file ''%s'' to ''%s.''';
  fileOverrideError = 'Can''t override existing file "%s".';

function IsValidSourceExt(const Ext: string): Boolean;
begin
  Result := GetFileType(Ext) in FILES_TYPES;
end;

function GetTagProperty(Node: IXMLNode; const Tag, Attribute: string; const Default: string = ''): string;
var
  Temp: IXMLNode;
begin
  Temp := Node.ChildNodes.FindNode(Tag);
  if (Temp <> nil) then
    Result := Temp.Attributes[Attribute]
  else
    Result := Default;
end;

function GetBoolProperty(Node: IXMLNode; const Tag, Attribute: string; Default: Boolean = False): Boolean;
begin
  Result := HumanToBool(GetTagProperty(Node, Tag, Attribute), Default);
end;

function GetIntProperty(Node: IXMLNode; const Tag, Attribute: string; Default: Integer = 0): Integer;
begin
  Result := StrToIntDef(GetTagProperty(Node, Tag, Attribute), Default);
end;

procedure SetTagProperty(Node: IXMLNode; const Tag, Attribute, Value: string);
var
  Temp: IXMLNode;
begin
  Temp := Node.ChildNodes.FindNode(Tag);
  if (Temp = nil) then
    Temp := Node.AddChild(Tag);
  Temp.Attributes[Attribute] := Value;
end;

procedure SetBoolProperty(Node: IXMLNode; const Tag, Attribute: string; Value: Boolean);
begin
  SetTagProperty(Node, Tag, Attribute, BoolToHuman(Value));
end;

procedure SetIntProperty(Node: IXMLNode; const Tag, Attribute: string; Value: Integer);
begin
  SetTagProperty(Node, Tag, Attribute, IntToStr(Value));
end;

{ TVersionInfo }

procedure TVersionInfo.Assign(const Value: TVersionInfo);
begin
  Version := Value.Version;
  LanguageID := Value.LanguageID;
  CharsetID := Value.CharsetID;
  CompanyName := Value.CompanyName;
  FileVersion := Value.FileVersion;
  FileDescription := Value.FileDescription;
  InternalName := Value.InternalName;
  LegalCopyright := Value.LegalCopyright;
  LegalTrademarks := Value.LegalTrademarks;
  OriginalFilename := Value.OriginalFilename;
  ProductName := Value.ProductName;
  ProductVersion := Value.ProductVersion;
end;

{ TProjectConfiguration }

procedure TProjectConfiguration.Assign(const Value: TProjectConfiguration);
begin
  FName := Value.FName;
  FLibs := Value.FLibs;
  FFlags := Value.FFlags;
  FCompOpt := Value.FCompOpt;
  FTarget := Value.FTarget;
  FCmdLine := Value.FCmdLine;
  FDelObjPrior := Value.FDelObjPrior;
  FDelObjAfter := Value.FDelObjAfter;
  FDelMakAfter := Value.FDelMakAfter;
  FDelResAfter := Value.FDelResAfter;
  FIncludeInfo := Value.FIncludeInfo;
  FEnableTheme := Value.FEnableTheme;
  FRequiresAdmin := Value.FRequiresAdmin;
  FAppType := Value.FAppType;
  FCompilerType := Value.FCompilerType;
  FIconFileName := Value.FIconFileName;
  if (FIcon = nil) and (Value.FIcon <> nil) then
    FIcon := TIcon.Create
  else if (FIcon <> nil) and (Value.FIcon = nil) then
    FIcon.Free;
  if Value.FIcon <> nil then
    FIcon.Assign(Value.FIcon) { TODO -oMazin -c : Fix assign all icon sizes 11/10/2016 01:21:29 }
  else
    FIcon := nil;
  FAutoIncBuild := Value.FAutoIncBuild;
  FVersion.Assign(Value.FVersion);
end;

constructor TProjectConfiguration.Create;
begin
  FVersion := TVersionInfo.Create;
  FVersion.LanguageID := GetSystemDefaultLangID;
  FVersion.CharsetID := $04E4;
  FDelObjPrior := True;
  FDelObjAfter := True;
  FDelMakAfter := True;
  FDelResAfter := True;
  FCompilerType := COMPILER_CPP;
  FName := DEFAULT_CONFIG_NAME;
  FIcon := nil;
end;

destructor TProjectConfiguration.Destroy;
begin
  if Assigned(FIcon) then
    FIcon.Free;
  FVersion.Free;
  inherited;
end;

procedure TProjectConfiguration.Load(ParentNode: IXMLNode);
var
  Node: IXMLNode;
  StrIcon, Temp: string;
  Stream: TStream;
  AIcon: TIcon;
begin
  Name := GetTagProperty(ParentNode, 'ConfigurationName', 'Value', DEFAULT_CONFIG_NAME);
  Libs := GetTagProperty(ParentNode, 'Libs', 'Value');
  Flags := GetTagProperty(ParentNode, 'Flags', 'Value');
  Target := GetTagProperty(ParentNode, 'Target', 'Value');
  CmdLine := GetTagProperty(ParentNode, 'CommandLine', 'Value');
  CompilerOptions := GetTagProperty(ParentNode, 'CompilerOptions', 'Value');
  DeleteObjsBefore := GetBoolProperty(ParentNode, 'DeleteObjectsBefore', 'Value');
  DeleteObjsAfter := GetBoolProperty(ParentNode, 'DeleteObjectsAfter', 'Value');
  DeleteMakefileAfter := GetBoolProperty(ParentNode, 'DeleteMakefileAfter', 'Value');
  DeleteResourcesAfter := GetBoolProperty(ParentNode, 'DeleteResourcesAfter', 'Value');
  EnableTheme := GetBoolProperty(ParentNode, 'EnableTheme', 'Value');
  RequiresAdmin := GetBoolProperty(ParentNode, 'RequiresAdmin', 'Value');
  AppType := GetAppTypeByName(GetTagProperty(ParentNode, 'AppType', 'Value'));
  Temp := GetTagProperty(ParentNode, 'CompilerType', 'Value');
  if SameText(Temp, 'C') then
    CompilerType := COMPILER_C
  else
    CompilerType := COMPILER_CPP;
  //if tag version info exist
  Node := ParentNode.ChildNodes.FindNode('VersionInfo');
  if (Node <> nil) then
  begin
    IncludeVersionInfo := True;
    Version.Version.Major := GetIntProperty(Node, 'VersionNumbers', 'Major');
    Version.Version.Minor := GetIntProperty(Node, 'VersionNumbers', 'Minor');
    Version.Version.Release := GetIntProperty(Node, 'VersionNumbers', 'Release');
    Version.Version.Build := GetIntProperty(Node, 'VersionNumbers', 'Build');
    Version.LanguageID := GetIntProperty(Node, 'LanguageID', 'Value', GetSystemDefaultLangID);
    Version.CharsetID := GetIntProperty(Node, 'CharsetID', 'Value', $04E4);
    Version.CompanyName := GetTagProperty(Node, 'CompanyName', 'Value');
    Version.FileVersion := GetTagProperty(Node, 'FileVersion', 'Value');
    Version.FileDescription := GetTagProperty(Node, 'FileDescription', 'Value');
    Version.InternalName := GetTagProperty(Node, 'InternalName', 'Value');
    Version.LegalCopyright := GetTagProperty(Node, 'LegalCopyright', 'Value');
    Version.LegalTrademarks := GetTagProperty(Node, 'LegalTrademarks', 'Value');
    Version.OriginalFilename := GetTagProperty(Node, 'OriginalFilename', 'Value');
    Version.ProductName := GetTagProperty(Node, 'ProductName', 'Value');
    Version.ProductVersion := GetTagProperty(Node, 'ProductVersion', 'Value');
    Temp := GetTagProperty(Node, 'AutoIncrementBuild', 'Value');
    AutoIncBuild := HumanToBool(Temp);
  end
  else
  begin
    AutoIncBuild := False;
    IncludeVersionInfo := False;
  end;
  Node := ParentNode.ChildNodes.FindNode('AppIcon');
  //if tag icon exist
  if (Node = nil) then
  begin
    Icon := nil;
    Exit;
  end;
  StrIcon := Node.Text;
  StrIcon := Union64(StrIcon);
  Stream := TMemoryStream.Create;
  AIcon := TIcon.Create;
  try
    try
      StringToStream(StrIcon, Stream);
      Stream.Position := 0;
      AIcon.LoadFromStream(Stream);
      Icon := AIcon;
    except
      Icon := nil;
    end;
  finally
    AIcon.Free;
    Stream.Free;
  end;
end;

procedure TProjectConfiguration.Save(ParentNode: IXMLNode);
var
  Node: IXMLNode;
  Stream: TStream;
begin
  SetTagProperty(ParentNode, 'ConfigurationName', 'Value', Name);
  SetTagProperty(ParentNode, 'Libs', 'Value', Libs);
  SetTagProperty(ParentNode, 'Flags', 'Value', Flags);
  SetTagProperty(ParentNode, 'Target', 'Value', Target);
  SetTagProperty(ParentNode, 'CommandLine', 'Value', CmdLine);
  SetTagProperty(ParentNode, 'CompilerOptions', 'Value', CompilerOptions);
  SetBoolProperty(ParentNode, 'DeleteObjectsBefore', 'Value', DeleteObjsBefore);
  SetBoolProperty(ParentNode, 'DeleteObjectsAfter', 'Value', DeleteObjsAfter);
  SetBoolProperty(ParentNode, 'DeleteMakefileAfter', 'Value', DeleteMakefileAfter);
  SetBoolProperty(ParentNode, 'DeleteResourcesAfter', 'Value', DeleteResourcesAfter);
  SetBoolProperty(ParentNode, 'EnableTheme', 'Value', EnableTheme);
  SetBoolProperty(ParentNode, 'RequiresAdmin', 'Value', RequiresAdmin);
  SetTagProperty(ParentNode, 'CompilerType', 'Value', COMPILERS[CompilerType]);
  SetTagProperty(ParentNode, 'AppType', 'Value', APPTYPES[AppType]);
  if IncludeVersionInfo then
  begin
    Node := ParentNode.AddChild('VersionInfo');
    SetTagProperty(Node, 'VersionNumbers', 'Major', IntToStr(Version.Version.Major));
    SetTagProperty(Node, 'VersionNumbers', 'Minor', IntToStr(Version.Version.Minor));
    SetTagProperty(Node, 'VersionNumbers', 'Release', IntToStr(Version.Version.Release));
    SetTagProperty(Node, 'VersionNumbers', 'Build', IntToStr(Version.Version.Build));
    SetTagProperty(Node, 'LanguageID', 'Value', IntToStr(Version.LanguageID));
    SetTagProperty(Node, 'CharsetID', 'Value', IntToStr(Version.CharsetID));
    SetTagProperty(Node, 'CompanyName', 'Value', Version.CompanyName);
    SetTagProperty(Node, 'FileVersion', 'Value', Version.FileVersion);
    SetTagProperty(Node, 'FileDescription', 'Value', Version.FileDescription);
    SetTagProperty(Node, 'InternalName', 'Value', Version.InternalName);
    SetTagProperty(Node, 'LegalCopyright', 'Value', Version.LegalCopyright);
    SetTagProperty(Node, 'LegalTrademarks', 'Value', Version.LegalTrademarks);
    SetTagProperty(Node, 'OriginalFilename', 'Value', Version.OriginalFilename);
    SetTagProperty(Node, 'ProductName', 'Value', Version.ProductName);
    SetTagProperty(Node, 'ProductVersion', 'Value', Version.ProductVersion);
    SetBoolProperty(Node, 'AutoIncrementBuild', 'Value', AutoIncBuild);
  end;
  //save application ico
  if Icon = nil then
    Exit;
  Node := ParentNode.AddChild('AppIcon');
  Stream := TMemoryStream.Create;
  try
    Icon.SaveToStream(Stream);
    Stream.Position := 0;
    Node.Text := Divide64(StreamToString(Stream));
  finally
    Stream.Free;
  end;
end;

procedure TProjectConfiguration.SetIcon(Value: TIcon);
begin
  if FIcon = Value then
    Exit;
  if FIcon = nil then
    FIcon := TIcon.Create
  else if Value = nil then
  begin
    FIcon.Free;
    FIcon := nil;
    Exit;
  end;
  FIcon.Assign(Value); { TODO -oMazin -c : Fix assign all icons size 11/10/2016 01:30:49 }
end;

{ TSourceBase }

procedure TSourceBase.AdjustProject(ProjectBase: TProjectBase);
var
  I: Integer;
begin
  Project := ProjectBase;
  for I := 0 to Node.Count - 1 do
    TSourceBase(Node.Item[I].Data).AdjustProject(ProjectBase);
end;

procedure TSourceBase.Assign(Value: TSourceBase);
begin
  FFileName := Value.FFileName;
  FFileType := Value.FFileType;
  FNode := Value.FNode;
  FProject := Value.FProject;
  FSaved := Value.FSaved;
  FIsNew := Value.FIsNew;
  FReadOnly := Value.FReadOnly;
  FOnDeletion := Value.FOnDeletion;
  FOnRename := Value.FOnRename;
  FOnTypeChanged := Value.FOnTypeChanged;
end;

procedure TSourceBase.Changed;
begin
end;

constructor TSourceBase.Create(Node: TTreeNode);
begin
  FNode := Node;
  FFileType := FILE_TYPE_UNKNOW;
  FIsNew := True;
end;

procedure TSourceBase.Delete;
var
  I: Integer;
begin
  Deleting := True;
  for I := Node.Count - 1 downto 0 do
    TSourceBase(Node.Item[I].Data).Delete;
  if Assigned(fOnDeletion) then
    fOnDeletion(Self);
  FNode.Delete;
  Deleting := False;
  Free;
end;

procedure TSourceBase.DoRename(const OldFileName: string);
begin
  if Assigned(FOnRename) then
    FOnRename(Self, OldFileName);
end;

function TSourceBase.GetFileName: string;
begin
  Result := FFileName;
end;

function TSourceBase.GetName: string;
begin
  Result := ExtractFileName(FFileName);
end;

function TSourceBase.GetParent: TSourceBase;
begin
  if Node.Parent = nil then
    Result := nil
  else
    Result := TSourceBase(Node.Parent.Data);
end;

function TSourceBase.GetProject: TProjectBase;
begin
  if (FProject = nil) and (Self is TProjectBase) then
    FProject := TProjectBase(Self)
  else if (FProject = nil) then
    FProject := Parent.Project;
  Result := FProject;
end;

function TSourceBase.IsModified: Boolean;
begin
  Result := not FSaved;
end;

function TSourceBase.Open: Boolean;
begin
  Result := False;
end;

procedure TSourceBase.Rename(const NewName: string);
var
  OldName: string;
begin
  OldName := FileName;
  SetFileName(NewName);
  if OldName = FileName then
    Exit;
  Project.CompilePropertyChanged := True;
  Project.PropertyChanged := True;
end;

procedure TSourceBase.Save;
begin
  FSaved := True;
end;

function TSourceBase.SearchSource(const Name: string;
  var SourceFound: TSourceBase): Boolean;
begin
  Result := False;
end;

function TSourceBase.GetFileByPathName(const RelativeName: string): TSourceFile;
var
  Temp, S: string;
  Parent: TSourceBase;
  I: Integer;
begin
  Result := nil;
  Parent := Self;
  Temp := RelativeName;
  while Temp <> '' do
  begin
    S := Temp;
    I := Pos('\', Temp);
    if I = 0 then
      I := Pos('/', Temp);
    if I > 0 then
    begin
      S := Copy(S, 1, I - 1);
      System.Delete(Temp, 1, I);
    end
    else
      Temp := '';
    if not Parent.SearchSource(S, Parent) then
    begin
      Result := nil;
      Exit;
    end;
    if Parent is TSourceFile then
      Result := TSourceFile(Parent);
  end;
end;

procedure TSourceBase.SetFileName(Value: string);
var
  OldFileName, OldName: string;
begin
  if FFileName = Value then
    Exit;
  OldFileName := FileName;
  OldName := Name;
  FFileName := Value;
  if OldName <> '' then
    DoRename(OldFileName);
  Node.Text := Name;
end;

procedure TSourceBase.SetFileType(Value: Integer);
var
  OldType: Integer;
begin
  if FFileType = Value then
    Exit;
  OldType := FFileType;
  FFileType := Value;
  if Assigned(FOnTypeChanged) then
    FOnTypeChanged(Self, OldType);
end;

procedure TSourceBase.SetProject(Value: TProjectBase);
begin
  if FProject <> Value then
    FProject := Value;
end;

procedure TSourceBase.GetSourcesBase(List: TStrings; Types,
  SkipTypes: TFileTypeSet; FilterMethod: TSourceFilterMethod; SingleLevel: Boolean);
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if ((SourceBase.FileType in Types) or (Types = [])) and not (SourceBase.FileType in SkipTypes) and
      ((@FilterMethod = nil) or FilterMethod(SourceBase)) then
      List.AddObject(SourceBase.FileName, SourceBase);
    if (SourceBase is TSourceFolder) and not SingleLevel then
      TSourceFolder(Node.Item[I].Data).GetSources(List, Types, SkipTypes, FilterMethod)
    else if (SourceBase is TProjectFile) and not SingleLevel then
      TProjectFile(Node.Item[I].Data).GetSources(List, Types, SkipTypes, FilterMethod);
  end;
end;

{ TSourceFile }

constructor TSourceFile.Create(Node: TTreeNode);
begin
  inherited Create(Node);
  FBreakpoint := TBreakpointList.Create;
end;

destructor TSourceFile.Destroy;
begin
  {*if FTranslationUnit <> nil then
    clang_disposeTranslationUnit(FTranslationUnit); *}
  FBreakpoint.Free;
  inherited Destroy;
end;

procedure TSourceFile.Assign(Value: TSourceFile);
begin
  inherited Assign(Value);
  FFileDateTime := Value.FFileDateTime;
  FEncoding := Value.FEncoding;
  FEndian := Value.FEndian;
  FWithBOM := Value.FWithBOM;
  FLineEnding := Value.FLineEnding;
  FSheet := Value.FSheet;
  FBreakpoint.Assign(Value.FBreakpoint);
end;

procedure TSourceFile.DeleteOfDisk;
begin
  if FileExists(FileName) then
    DeleteFile(FileName);
  Delete;
end;

procedure TSourceFile.Delete;
begin
  Deleting := True;
  Close;
  Project.PropertyChanged := True;
  Project.CompilePropertyChanged := True;
  inherited Delete;
end;

function TSourceFile.FileChangedInDisk: Boolean;
var
  FileDate: TDateTime;
begin
  Result := False;
  if not FileExists(FileName) or not Saved then
    Exit;
  FileDate := FileDateTime(FileName);
  Result := (FileDate <> FFileDateTime);
end;

procedure TSourceFile.AdjustEncoding(Encoding: TEncoding);
begin
  if Encoding = TEncoding.UTF8 then
  begin
    Self.Encoding := ENCODING_UTF8;
    Self.Endian := ENDIAN_NONE;
  end
  else if Encoding = TEncoding.Unicode then
  begin
    Self.Encoding := ENCODING_UCS2;
    Self.Endian := ENDIAN_LITTLE;
  end
  else if Encoding = TEncoding.BigEndianUnicode then
  begin
    Self.Encoding := ENCODING_UCS2;
    Self.Endian := ENDIAN_BIG;
  end
  else
  begin
    Self.Encoding := ENCODING_ANSI;
    Self.Endian := ENDIAN_NONE;
  end
end;

class function TSourceFile.GetEditorEolMode(LineEnding: Integer): Integer;
begin
  case LineEnding of
    LINE_ENDING_LINUX:
      Result := SC_EOL_LF; // linux
    LINE_ENDING_MAC:
      Result := SC_EOL_CR; // mac
  else
    Result := SC_EOL_CRLF; // windows
  end;
end;

function TSourceFile.GetEncodingProcessor: TEncoding;
begin
  if Encoding = ENCODING_UTF8 then
    Result := TEncoding.UTF8
  else if (Encoding = ENCODING_UCS2) and (Endian = ENDIAN_BIG) then
    Result := TEncoding.BigEndianUnicode
  else if (Encoding = ENCODING_UCS2) then
    Result := TEncoding.Unicode
  else
    Result:= TEncoding.Default;
end;

procedure TSourceFile.LoadFromFile(const FileName: string);
var
  Sheet: TSourceFileSheet;
  BOM: Boolean;
  LineBreak: string;
begin
  if not GetSheet(Sheet) then
    Exit;
  AdjustEncoding(LoadFile(Sheet.Editor.Lines, BOM, LineBreak));
  if LineBreak = #13 then
    Sheet.Editor.SetEOLMode(SC_EOL_CR)
  else if LineBreak = #10 then
    Sheet.Editor.SetEOLMode(SC_EOL_LF)
  else
    Sheet.Editor.SetEOLMode(SC_EOL_CRLF);
  case Sheet.Editor.GetEOLMode of
    SC_EOL_LF: LineEnding := LINE_ENDING_LINUX;
    SC_EOL_CR: LineEnding := LINE_ENDING_MAC;
  else // SC_EOL_CRLF
    LineEnding := LINE_ENDING_WINDOWS;
  end;
  WithBOM := BOM;
  Sheet.Editor.EmptyUndoBuffer;
end;

procedure TSourceFile.Reload;
var
  Sheet: TSourceFileSheet;
begin
  if not GetSheet(Sheet) then
    Exit;
  if not FileExists(FileName) or not Saved then
    Exit;
  LoadFromFile(FileName);
  UpdateDate;
end;

class function TSourceFile.FilterBreakPoint(SourceBase: TSourceBase): Boolean;
begin
  Result := (SourceBase.FileType in SOURCE_TYPES) and (TSourceFile(SourceBase).Breakpoint.Count > 0);
end;

procedure TSourceFile.UpdateBreakpoint;
var
  Line, MatchCount: Integer;
  Sheet: TSourceFileSheet;
begin
  if not GetSheet(Sheet) then
    Exit;
  MatchCount := 0;
  Line := Sheet.Editor.MarkerNext(0, 1 shl MARK_BREAKPOINT);
  while Line <> -1 do
  begin
    if Breakpoint.HasBreakpoint(Line + 1) then
      Inc(MatchCount);
    Line := Sheet.Editor.MarkerNext(Line + 1, 1 shl MARK_BREAKPOINT);
  end;
  if MatchCount = Breakpoint.Count then
    Exit; // ok
  Breakpoint.Clear;
  Line := Sheet.Editor.MarkerNext(0, 1 shl MARK_BREAKPOINT);
  while Line <> -1 do
  begin
    Breakpoint.AddBreakpoint(Line + 1);
    Line := Sheet.Editor.MarkerNext(Line + 1, 1 shl MARK_BREAKPOINT);
  end;
end;

procedure TSourceFile.UpdateDate;
begin
  if not FileExists(FileName) or not Saved then
    Exit;
  FFileDateTime := FileDateTime(FileName);
end;

function TSourceFile.GetFileName: string;
begin
  Result := ExtractFilePath(Parent.FileName) + FFileName;
  if Pos('..', Result) > 0 then
    Result := ExpandFileName(Result);
end;

procedure TSourceFile.SetEncoding(const Value: Integer);
begin
  if FEncoding = Value then
    Exit;
  FEncoding := Value;
end;

procedure TSourceFile.SetEndian(const Value: Integer);
begin
  if FEndian = Value then
    Exit;
  FEndian := Value;
end;

procedure TSourceFile.SetWithBOM(const Value: Boolean);
begin
  if (FWithBOM = Value) then
    Exit;
  if Value and (Encoding = ENCODING_ANSI) then
    Exit;
  FWithBOM := Value;
end;

procedure TSourceFile.TranslateUnit;
{*var
  Args: PPAnsiChar;
  PArgs: PPAnsiChar;
  UnsavedFile: CXUnsavedFile;
  pUnsavedFiles: PCXUnsavedFile;
  ArgList: TStrings;
  I, UnsavedCount, ArgCount: Integer;
  Sheet: TSourceFileSheet;
  Contents, AnsiFileName: RawByteString;
  ErrorCode: CXErrorCode;*}
begin
  Exit;
  {*ArgList := TStringList.Create;
  if Project.CompilerType = COMPILER_CPP then
  begin
    ArgList.Add('-std=c++11');
    ArgList.Add('-xc++');
  end
  else
    ArgList.Add('-std=c11');
  ArgList.Add('-Wall');
  ArgList.Add('-nostdinc');
  ArgList.Add('-nostdinc++');
  for I := 0 to FrmFalconMain.FilesParsed.PathList.Count - 1 do
    ArgList.Add('-I"' + FrmFalconMain.FilesParsed.PathList[I] + '"');
  ArgList.Add('-I"' + ExtractFilePath(FileName) + '"');
  SplitParams(Project.Flags, ArgList);
  ArgCount := ArgList.Count;
  GetMem(Args, ArgList.Count * SizeOf(PAnsiString));
  PArgs := Args;
  for I := 0 to ArgList.Count - 1 do
  begin
    PArgs^ := PAnsiChar(UTF8Encode(ArgList[I]));
    Inc(PArgs);
  end;
  ArgList.Free;
  pUnsavedFiles := nil;
  UnsavedCount := 0;
  AnsiFileName := UTF8Encode(FileName);
  if (IsModified or not Saved) and GetSheet(Sheet) then
  begin
    Contents := UTF8Encode(Sheet.Editor.Lines.Text);
    UnsavedFile.Filename := PAnsiChar(AnsiFileName);
    UnsavedFile.Contents := PAnsiChar(Contents);
    UnsavedFile.Length := Length(Contents);
    pUnsavedFiles := @UnsavedFile;
    UnsavedCount := 1;
  end;
  if FTranslationUnit = nil then
  begin
    ErrorCode := clang_parseTranslationUnit2(FrmFalconMain.ClangIndex,
      PAnsiChar(AnsiFileName), Args, ArgCount, pUnsavedFiles, UnsavedCount,
      CXTranslationUnit_CacheCompletionResults or
      CXTranslationUnit_PrecompiledPreamble or
      CXTranslationUnit_Incomplete,
      @FTranslationUnit);
    if ErrorCode <> CXError_Success then
      FTranslationUnit := nil;
  end
  else
  begin
    clang_reparseTranslationUnit(FTranslationUnit, UnsavedCount, pUnsavedFiles,
      CXTranslationUnit_CacheCompletionResults or
      CXTranslationUnit_PrecompiledPreamble or
      CXTranslationUnit_Incomplete);
  end;
  FreeMem(Args);*}
end;

procedure TSourceFile.SetLineEnding(const Value: Integer);
begin
  if FLineEnding = Value then
    Exit;
  FLineEnding := Value;
end;

procedure TSourceFile.SetFileName(Value: string);
var
  Temp: string;
begin
  if (Name = Value) or (Value = '') then
    Exit;
  { ***   PROJECT or FILE   *** }
  if FileExists(FileName) and Saved then
  begin
    Temp := ExtractFilePath(FileName) + ExtractFileName(Value);
    if not RenameFile(FileName, Temp) then
      raise Exception.CreateFmt(fileRenameError, [FileName, Temp]);
    FrmFalconMain.RenameFileInHistory(FileName,
      ExtractFilePath(FileName) + ExtractFileName(Value));
  end;
  inherited SetFileName(Value);
  UpdateSheetStatus(IsModified);
end;

function TSourceFile.Edit(SelectTab: Boolean): TSourceFileSheet;
var
  Sheet: TSourceFileSheet;
  BOM: Boolean;
  LineBreak: string;
  SaveOnChange: TNotifyEvent;
begin
  if GetSheet(Sheet) then
  begin
    Result := Sheet;
    ViewPage;
    if Sheet.Editor.Showing then
      Sheet.Editor.SetFocus;
    Exit;
  end;
  Sheet := TSourceFileSheet.CreateEditor(Self, FrmFalconMain.PageControlEditor, SelectTab);
  Sheet.Caption := Name;
  Sheet.ImageIndex := FILE_IMG_LIST[FileType];
  if Saved then
  begin
    Sheet.Editor.ReadOnly := False;
    SaveOnChange := Sheet.Editor.OnChange;
    Sheet.Editor.OnChange := nil;
    AdjustEncoding(LoadFile(Sheet.Editor.Lines, BOM, LineBreak));
    Sheet.Editor.OnChange := SaveOnChange;
    if LineBreak = #13 then
      Sheet.Editor.SetEOLMode(SC_EOL_CR)
    else if LineBreak = #10 then
      Sheet.Editor.SetEOLMode(SC_EOL_LF)
    else
      Sheet.Editor.SetEOLMode(SC_EOL_CRLF);
    case Sheet.Editor.GetEOLMode of
      SC_EOL_LF: LineEnding := LINE_ENDING_LINUX;
      SC_EOL_CR: LineEnding := LINE_ENDING_MAC;
    else // SC_EOL_CRLF
      LineEnding := LINE_ENDING_WINDOWS;
    end;
    WithBOM := BOM;
    Sheet.Editor.EmptyUndoBuffer;
    Sheet.Editor.ReadOnly := ReadOnly;
  end;
  FrmFalconMain.PageControlEditor.Show;
  if FrmFalconMain.Showing and Sheet.Editor.Showing then
    Sheet.Editor.SetFocus;
  FrmFalconMain.PageControlEditorChange(FrmFalconMain.PageControlEditor);
  FrmFalconMain.EditorBeforeCreate(Self);
  Result := Sheet;
end;

function TSourceFile.Open: Boolean;
begin
  Result := FileExists(FileName) and OpenFolderAndSelectFile(FileName);
end;

procedure TSourceFile.LoadFile(Text: TStrings);
var
  BOM: Boolean;
  LineBreak: string;
begin
  LoadFile(Text, BOM, LineBreak);
end;

function TSourceFile.LoadFile(Text: TStrings; var WithBOM: Boolean;
  var LineBreak: string): TEncoding;
begin
  LoadFileEx(FileName, text, WithBOM, Result, LineBreak);
end;

procedure TSourceFolder.GetSources(List: TStrings; Types: TFileTypeSet;
  SkipTypes: TFileTypeSet; FilterMethod: TSourceFilterMethod; SingleLevel: Boolean);
begin
  GetSourcesBase(List, Types, SkipTypes, FilterMethod, SingleLevel);
end;

function TSourceFile.GetSheet(var Sheet: TSourceFileSheet): Boolean;
begin
  Result := FSheet <> nil;
  if Result then
    Sheet := FSheet;
end;

procedure TSourceFile.GetSources(List: TStrings; Types,
  SkipTypes: TFileTypeSet; FilterMethod: TSourceFilterMethod; SingleLevel: Boolean);
begin
  GetSourcesBase(List, Types, SkipTypes, FilterMethod, SingleLevel);
end;

function TSourceFile.ViewPage: Boolean;
var
  Sheet: TSourceFileSheet;
begin
  Result := GetSheet(Sheet);
  if not Result then
    Exit;
  if (Sheet.PageIndex <> FrmFalconMain.PageControlEditor.ActivePageIndex) then
    FrmFalconMain.PageControlEditor.ActivePageIndex := Sheet.PageIndex;
end;

function TSourceFile.Editing: Boolean;
begin
  Result := FSheet <> nil;
end;

function TSourceFile.IsModified: Boolean;
var
  Sheet: TSourceFileSheet;
begin
  // modification in text
  Result := GetSheet(Sheet) and Sheet.Editor.Modified;
  // don't need more to verify
  if Result or IsNew then
    Exit;
  // verify if file exist and if date are equals
  Result := FileChangedInDisk;
end;

procedure TSourceFile.Changed;
begin
  inherited;
  UpdateSheetStatus(IsModified);
end;

procedure TSourceFile.UpdateSheetStatus(Modified: Boolean);
var
  Sheet: TSourceFileSheet;
begin
  if not GetSheet(Sheet) then
    Exit;
  if ReadOnly then
    Sheet.Font.Color := clGrayText
  else if Modified then
    Sheet.Font.Color := clRed
  else
    Sheet.Font.Color := clWindowText;
  Sheet.Caption := Name;
end;

procedure TSourceFile.Close;
var
  Sheet: TSourceFileSheet;
begin
  if not GetSheet(Sheet) then
    Exit;
  if (Sheet.PageIndex = FrmFalconMain.PageControlEditor.PageCount - 1)
    and (Sheet.PageIndex > 0) then
    FrmFalconMain.PageControlEditor.ActivePageIndex := Sheet.PageIndex - 1;
  Sheet.Free;
  if FrmFalconMain.PageControlEditor.PageCount = 0 then
    FrmFalconMain.PageControlEditor.Hide;
end;

procedure TSourceFile.Save;
var
  Sheet: TSourceFileSheet;
begin
  if FSaved and not Modified and FileExists(FileName) and not FileChangedInDisk then
    Exit;
  if not FSaved and FileExists(FileName) and GetSheet(Sheet) then
  begin
    if not FrmFalconMain.ShowPromptOverrideFile(FileName) then
      raise Exception.CreateFmt(fileOverrideError, [FileName]);
  end;
  // save parent folder
  if (Parent <> nil) and (Parent.FileType = FILE_TYPE_FOLDER) then
    Parent.Save;
  Project.Compiled := False;
  if GetSheet(Sheet) then
  begin
    if (Encoding = ENCODING_UTF8) and not WithBOM then
      Sheet.Editor.Lines.SaveToFileUTF8(FileName)
    else
      Sheet.Editor.Lines.SaveToFile(FileName, GetEncodingProcessor);
    if Sheet.Editor.Modified and not Project.Saved and IsNew then
      Project.SomeFileChanged := True;
    Sheet.Editor.SetSavePoint;
  end // create empty file
  else if not FileExists(FileName) then
  begin
    with TStringList.Create do
    begin
      SaveToFile(FileName, GetEncodingProcessor);
      Free;
    end;
  end;
  if not Project.IsNew and Project.Saved then
    IsNew := False;
  DateOfFile := FileDateTime(FileName);
  if Node.Text <> Self.Name then
    Node.Text := Self.Name;
  inherited Save;
  //update main form
  FrmFalconMain.UpdateMenuItems([rmFile]);
  if not GetSheet(Sheet) then
    Exit;
  UpdateSheetStatus(IsModified);
end;

procedure TSourceFile.MoveTo(const Path: string);
var
  FromFileName, ToFileName: string;
begin
  ToFileName := ExtractRelativePath(FileName, Path) + Name;
  if ExtractFileDrive(ToFileName) = '' then
    ToFileName := ExtractFilePath(FileName) + ToFileName;
  ToFileName := ExpandFileName(ToFileName);
  FromFileName := ExcludeTrailingPathDelimiter(FileName);
  if FromFileName = ToFileName then
    Exit;
  { TODO -oMazin -c : Call OnRenameFile 30/07/2013 00:41:28 }
  if not RenameFile(FromFileName, ToFileName) then
    raise EFilerError.CreateFmt(filemoveError, [FromFileName, ToFileName]);
end;

procedure TSourceFile.CodeCompleteAt(Line, Column: Integer);
{*var
  codeCompleteResults: PCXCodeCompleteResults;
  str: CXCompletionString;
  Kind: CXCompletionChunkKind;
  outText: CXString;
  I, J: Integer;
  Entry: string;
  AnsiFileName: RawByteString;*}
begin
  Exit;
  {*AnsiFileName := UTF8Encode(FileName);
  clang_reparseTranslationUnit(FTranslationUnit, 0, nil, 0);
  codeCompleteResults := clang_codeCompleteAt(FTranslationUnit,
    PAnsiChar(AnsiFileName), Line, Column, nil, 0,
    CXCodeComplete_IncludeCodePatterns);
  if codeCompleteResults = nil then
    Exit;
  for I := 0 to codeCompleteResults^.NumResults - 1 do
  begin
    str := codeCompleteResults^.Results^[I].CompletionString;
    for J := 0 to clang_getNumCompletionChunks(str) - 1 do
    begin
      Kind := clang_getCompletionChunkKind(str, j);
      if Kind <> CXCompletionChunk_TypedText then
        Continue;
      outText.data := Pointer(0);
      outText.private_flags := 0;
      outText := clang_getCompletionChunkText(str, j);
      Entry := string(StrPas(clang_getCString(outText)));
      clang_disposeString(outText);
    end;
  end;
  clang_disposeCodeCompleteResults(codeCompleteResults);*}
end;

function TSourceFile.ConvertToProjectSource: TProjectSource;
var
  Sheet: TSourceFileSheet;
begin
  Result := TProjectSource.Create(Node);
  Result.Assign(Self);
  Result.FFileName := FileName;
  Result.FProject := Result;
  if GetSheet(Sheet) then
    Sheet.FSourceFile := Result;
end;

procedure TSourceFile.CopyTo(const Path: string);
var
  FromFileName, ToFileName: string;
  Sheet: TSourceFileSheet;
begin
  ToFileName := ExtractRelativePath(FileName, Path) + Name;
  if ExtractFileDrive(ToFileName) = '' then
    ToFileName := ExtractFilePath(FileName) + ToFileName;
  ToFileName := ExpandFileName(ToFileName);
  FromFileName := ExcludeTrailingPathDelimiter(FileName);
  if FromFileName = ToFileName then
    Exit;
  if not GetSheet(Sheet) then
  begin
    if FileExists(ToFileName) and not FrmFalconMain.ShowPromptOverrideFile(FileName) then
      raise Exception.CreateFmt(fileOverrideError, [FileName]);
    if CopyFile(PChar(FromFileName), PChar(ToFileName), FALSE) = FALSE then
      raise Exception.CreateFmt(fileOverrideError, [ToFileName]);
    Exit;
  end;
  Sheet.Editor.Lines.SaveToFile(ToFileName, GetEncodingProcessor);
  if Sheet.Editor.Modified and not Project.Saved and IsNew then
    Project.SomeFileChanged := True;
  Sheet.Editor.SetSavePoint;
  Saved := True;
  DateOfFile := FileDateTime(ToFileName);
end;

{ TSourceFolder }

procedure TSourceFolder.CopyTo(const Path: string);
var
  FromFileName, ToFileName: string;
  I: Integer;
  SourceBase: TSourceBase;
begin
  ToFileName := ExtractRelativePath(FileName, Path) + Name;
  if ExtractFileDrive(ToFileName) = '' then
    ToFileName := ExtractFilePath(FileName) + ToFileName;
  ToFileName := ExpandFileName(ToFileName);
  FromFileName := ExcludeTrailingPathDelimiter(FileName);
  if FromFileName = ToFileName then
    Exit;
  CreateDir(ToFileName);
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceFile(Node.Item[I].Data);
    if (SourceBase is TSourceFolder) and SourceBase.Saved then
      TSourceFolder(Node.Item[I].Data).CopyTo(Path + Name + '\')
    else if (SourceBase is TSourceFile) and SourceBase.Saved then
      TSourceFile(Node.Item[I].Data).CopyTo(Path + Name + '\');
  end;
end;

procedure TSourceFolder.Delete;
begin
  Deleting := True;
  Project.PropertyChanged := True;
  Project.CompilePropertyChanged := True;
  inherited Delete;
end;

function TSourceFolder.SearchSource(const Name: string; var SourceFound: TSourceBase): Boolean;
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  Result := False;
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if not (SourceBase is TSourceFile) or not SameText(SourceBase.Name, Name) then
      Continue;
    SourceFound := SourceBase;
    Result := True;
    Break;
  end;
end;

procedure TSourceFolder.DeleteOfDisk;
begin
  if DirectoryExists(FileName) then
    RemoveDir(FileName);
  Delete;
end;

function TSourceFolder.GetFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Parent.FileName) + FFileName);
  if Pos('..', Result) > 0 then
    Result := ExpandFileName(Result);
end;

function TSourceFolder.IsModified: Boolean;
begin
  Result := not DirectoryExists(FileName);
end;

function TSourceFolder.IsParentOf(const Path: string): Boolean;
begin
  Result := Pos(UpperCase(FileName),
    IncludeTrailingPathDelimiter(UpperCase(Path))) = 1;
end;

procedure TSourceFolder.MoveTo(const Path: string);
var
  FromFileName, ToFileName: string;
  I: Integer;
  SourceBase: TSourceBase;
begin
  ToFileName := ExtractRelativePath(FileName, Path) + Name;
  if ExtractFileDrive(ToFileName) = '' then
    ToFileName := ExtractFilePath(FileName) + ToFileName;
  ToFileName := ExpandFileName(ToFileName);
  FromFileName := ExcludeTrailingPathDelimiter(FileName);
  if FromFileName = ToFileName then
    Exit;
  { TODO -oMazin -c : Call OnRenameFile 30/07/2013 00:41:28 }
  if RenameFile(FromFileName, ToFileName) then
    Exit;
   // Can't move folder, create and copy all files
  CreateDir(ToFileName);
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if (SourceBase is TSourceFolder) and SourceBase.Saved then
      TSourceFolder(Node.Item[I].Data).MoveTo(ToFileName + '\')
    else if (SourceBase is TSourceFile) and SourceBase.Saved then
      TSourceFile(Node.Item[I].Data).MoveTo(ToFileName + '\');
  end;
  // Remove folder if empty
  RemoveDir(FromFileName);
end;

function TSourceFolder.Open: Boolean;
begin
  Result := False;
  if DirectoryExists(FileName) then
    ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOW);
end;

procedure TSourceFolder.Save;
begin
  if DirectoryExists(FileName) then
    Exit;
  if Parent is TSourceFolder then
    Parent.Save;
  CreateDir(FileName);
  inherited;
end;

function TSourceFolder.SearchFile(const Name: string): TSourceFile;
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  Result := nil;
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if SourceBase is TSourceFolder then
      Result := TSourceFolder(SourceBase).SearchFile(Name)
    else if (SourceBase is TSourceFile) and SameText(Name, SourceBase.Name) then
      Result := TSourceFile(SourceBase);
    if Result <> nil then
      Break;
  end;
end;

procedure TSourceFolder.SetFileName(Value: string);
begin
  if (Name = Value) then
    Exit;
  if (Value = '') then
    raise Exception.Create('Invalid folder name');
  if DirectoryExists(FileName) and (Name <> '') then
  begin
    if not RenameFile(FileName, ExtractFilePath(ExcludeTrailingPathDelimiter(FileName)) + Value) then
      raise Exception.CreateFmt('Can''t rename folder "%s" to "%s"', [Name, Value]);
  end;
  inherited SetFileName(Value);
end;

{ TSourceConfigGroup }

procedure TSourceConfigGroup.GetSources(List: TStrings; Types,
  SkipTypes: TFileTypeSet; FilterMethod: TSourceFilterMethod; SingleLevel: Boolean);
begin
  GetSourcesBase(List, Types, SkipTypes, FilterMethod, SingleLevel);
end;

{ TProjectSource }

function TProjectSource.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TProjectSource.SaveAll;
begin
  if not IsNew then
    SomeFileChanged := False;
  Save;
end;

procedure TProjectSource.CloseAll;
begin
  Close;
end;

procedure TProjectSource.GetSources(List: TStrings; Types: TFileTypeSet;
  SkipTypes: TFileTypeSet; FilterMethod: TSourceFilterMethod; SingleLevel: Boolean);
begin
  if ((FileType in Types) or (Types = [])) and not (FileType in SkipTypes) and
    ((@FilterMethod = nil) or FilterMethod(Self)) then
    List.AddObject(FileName, Self);
  inherited;
end;

function TProjectSource.ConvertToSourceFile(Project: TProjectBase): TSourceFile;
var
  Sheet: TSourceFileSheet;
begin
  Result := TSourceFile.Create(Node);
  Result.Assign(Self);
  Result.FFileName := ExtractFileName(FFileName);
  Result.FProject := Project;
  if GetSheet(Sheet) then
    Sheet.FSourceFile := Result;
end;

{TProjectBase}

procedure TProjectBase.ConfigDeleted(Sender: TObject;
  Value: TProjectConfiguration);
var
  Index: Integer;
begin
  Index := Configurations.IndexOf(Value.Name);
  if (Index <= ConfigurationIndex) and (FConfigIndex > 0) then
    SetConfigIndex(FConfigIndex - 1)
  else if (FConfigIndex = Index) then
    ConfigurationChanged(-1);
end;

procedure TProjectBase.ConfigurationChanged(OldIndex: Integer);
begin
  if Assigned(FOnConfigurationChanged) then
    FOnConfigurationChanged(Self, OldIndex);
end;

constructor TProjectBase.Create(Node: TTreeNode);
begin
  inherited Create(Node);
  FConfigurations := TProjectConfigurationList.Create;
  FConfigurations.OnDelete := ConfigDeleted;
  FConfigurations.Add;
  FConfigIndex := 0;
  FBreakpointCursor := TBreakpoint.Create;
  FBreakpointCursor.Valid := False;
  FForceClean := False;
  FCompiled := False;
  FPropertyChanged := False;
  FCompilerPropertyChanged := False;
  FCompilerPath := '';
end;

destructor TProjectBase.Destroy;
begin
  if Assigned(FTemplateResources) then
    FTemplateResources.Free;
  FBreakpointCursor.Free;
  Configurations.Clear;
  FConfigurations.Free;
  inherited Destroy;
end;

procedure TProjectBase.UpdateTarget(Value: string);
var
  Preffix: string;
begin
  // update equal target
  Preffix := '';
  if (AppType = APPTYPE_LIB) and (FileName <> '') then
    Preffix := 'lib';
  if SameText(Preffix + ExtractName(FileName), ExtractName(Target)) then
    Exit;
  Target := Preffix + ExtractName(Value) + ExtractFileExt(Target);
  PropertyChanged := True;
end;

procedure TProjectBase.SetConfigIndex(const Value: Integer);
var
  OldIndex: Integer;
begin
  if FConfigIndex = Value then
    Exit;
  OldIndex := FConfigIndex;
  FConfigIndex := Value;
  PropertyChanged := True;
  CompilePropertyChanged := True;
  ConfigurationChanged(OldIndex);
end;

procedure TProjectBase.SetCurrentConfiguration(
  const Value: TProjectConfiguration);
var
  Index: Integer;
begin
  Index := Configurations.IndexOf(Value.Name);
  if Index < 0 then
    Index := Configurations.Add(Value);
  SetConfigIndex(Index);
end;

procedure TProjectBase.SetAppType(const Value: Integer);
begin
  Configuration.AppType := Value;
end;

procedure TProjectBase.SetAutoIncBuild(const Value: Boolean);
begin
  Configuration.AutoIncBuild := Value;
end;

procedure TProjectBase.SetCmdLine(const Value: string);
begin
  Configuration.CmdLine := Value;
end;

procedure TProjectBase.SetCompilerType(const Value: Integer);
begin
  Configuration.CompilerType := Value;
end;

procedure TProjectBase.SetCompOpt(const Value: string);
begin
  Configuration.CompilerOptions := Value;
end;

procedure TProjectBase.SetConfigName(const Value: string);
begin
  Configuration.Name := Value;
end;

procedure TProjectBase.SetDelMakAfter(const Value: Boolean);
begin
  Configuration.DeleteMakefileAfter := Value;
end;

procedure TProjectBase.SetDelObjAfter(const Value: Boolean);
begin
  Configuration.DeleteObjsAfter := Value;
end;

procedure TProjectBase.SetDelObjPrior(const Value: Boolean);
begin
  Configuration.DeleteObjsBefore := Value;
end;

procedure TProjectBase.SetDelResAfter(const Value: Boolean);
begin
  Configuration.DeleteResourcesAfter := Value;
end;

procedure TProjectBase.SetEnableTheme(const Value: Boolean);
begin
  Configuration.EnableTheme := Value;
end;

procedure TProjectBase.SetFlags(const Value: string);
begin
  Configuration.Flags := Value;
end;

procedure TProjectBase.SetIcon(const Value: TIcon);
begin
  Configuration.Icon := Value;
end;

procedure TProjectBase.SetIconFileName(const Value: string);
begin
  Configuration.IconFileName := Value;
end;

procedure TProjectBase.SetIncludeInfo(const Value: Boolean);
begin
  Configuration.IncludeVersionInfo := Value;
end;

procedure TProjectBase.SetLibs(const Value: string);
begin
  Configuration.Libs := Value;
end;

procedure TProjectBase.SetRequiresAdmin(const Value: Boolean);
begin
  Configuration.RequiresAdmin := Value;
end;

procedure TProjectBase.SetTarget(const Value: string);
begin
  Configuration.Target := Value;
end;

function TProjectBase.GetTarget: string;
begin
  Result := ExtractFilePath(FileName) + Target;
end;

function TProjectBase.GetTargetConfig: string;
begin
  Result := Configuration.Target;
end;

function TProjectBase.GetVersion: TVersionInfo;
begin
  Result := Configuration.Version;
end;

function TProjectBase.NeedBuild: Boolean;
begin
  Result := IsModified or not Compiled or CompilePropertyChanged or
  TargetChanged or (BreakpointChanged and not Debugging) or
  (Debugging and not HasBreakpoint);
end;

procedure TProjectBase.SaveAs(const FileName: string);
var
  OldFileName, OldName: string;
begin
  if SameText(FileName, FFileName) and Saved and not IsModified and not IsNew then
    Exit;
  if SameText(FileName, FFileName) then
  begin
    IsNew := False;
    Save;
    Exit;
  end;
  if Saved and not Editing and FileExists(FFileName) then
  begin
    if IsNew then
      RenameFile(FFileName, FileName)
    else
      CopyFile(PChar(FFileName), PChar(FileName), FALSE);
  end;
  UpdateTarget(FileName);
  OldFileName := FFileName;
  OldName := Name;
  FFileName := FileName;
  if OldName <> '' then
    DoRename(OldFileName);
  IsNew := False;
  Save;
end;

function TProjectBase.FilesChanged: Boolean;
var
  I: Integer;
  SourceBase: TSourceBase;
  List: TStrings;
begin
  Result := False;
  List := TStringList.Create;
  try
    GetSources(List, FILES_TYPES + [FILE_TYPE_FOLDER]);
    for I := 0 to List.Count - 1 do
    begin
      SourceBase := TSourceBase(List.Objects[I]);
      Result := SourceBase.Modified;
      if Result then
        Break;
    end;
  finally
    List.Free;
  end;
end;

procedure TProjectBase.Build;

  procedure SaveManifest(AFileName, ResName: string);
  var
    EnbTheme: TStrings;
    Rs: TResourceStream;
  begin
    EnbTheme := TStringList.Create;
    try
      Rs := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
      try
        EnbTheme.LoadFromStream(Rs);
      finally
        Rs.Free;
      end;
      EnbTheme.SaveToFile(AFileName);
    finally
      EnbTheme.Free;
    end;
  end;

var
  Makefile, FileContSpc, Temp, IncludeFileName, IncludeName: string;
  ExecFileName, ExecDirectory, ExecParams, ProjectDir: string;
  Files: TStrings;
  Res, MkWar, Includes, IncludeList: TStrings;
  MkRes, I, J, K: Integer;
  Manf: Byte;
  mk: TMakefile;
  OldDebuggingState, SkipIncludeFile: Boolean;
  TokenFile: TTokenFile;
  HasResource: Boolean;
begin
  SaveAll;
  if CompilerType in [COMPILER_CPP, COMPILER_C] then
  begin
    Files := TStringList.Create;
    GetSources(Files, FILES_TYPES, [FILE_TYPE_RC]);
    Res := TStringList.Create;
    HasResource := False;
    if GetResource(Res) then
    begin
      HasResource := True;
      if Assigned(Icon) then
        Icon.SaveToFile(ExtractFilePath(FileName) + 'AppIcon.ico');
      Manf := 0;
      if EnableTheme and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
        Manf := Manf or 1;
      if RequiresAdmin and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
        Manf := Manf or 2;
      Temp := ExtractFilePath(FileName) + 'AppManifest.dat';
      case Manf of
        1: SaveManifest(Temp, 'MANFTHEME');
        2: SaveManifest(Temp, 'MANFADMIN');
        3: SaveManifest(Temp, 'MANFBOTH');
      end;
      Files.Add(ExtractFilePath(FileName) + 'AppResource.rc');
      Res.SaveToFile(ExtractFilePath(FileName) + 'AppResource.rc');
    end;
    Res.Free;
    if HasResource or (FileType = FILE_TYPE_PROJECT) then
    begin
      ProjectDir := ExtractFilePath(FileName);
      IncludeList := TStringList.Create;
      GetIncludeDirs(ExtractFilePath(FileName), Flags, IncludeList);
      for I := 0 to Files.Count - 1 do
      begin
        Includes := TStringList.Create;
        Files.Objects[I] := Includes;
        TokenFile := FrmFalconMain.FilesParsed.Find(Files.Strings[I]);
        if TokenFile = nil then
          Continue;
        for J := 0 to TokenFile.Includes.Count - 1 do
        begin
          if TokenFile.Includes.Items[J].Flag = 'L' then
          begin
            IncludeName := ConvertSlashes(TokenFile.Includes.Items[J].Name);
            Temp := ExtractFilePath(Files.Strings[I]) + IncludeName;
            Temp := ExpandFileName(Temp);
            if not FileExists(Temp) then
            begin
              SkipIncludeFile := True;
              for K := 0 to IncludeList.Count - 1 do
              begin
                IncludeFileName := ExpandFileName(IncludeList.Strings[K] + IncludeName);
                if FileExists(IncludeFileName) and
                  (Pos(':', ExtractRelativePath(ProjectDir, IncludeFileName)) = 0) then
                begin
                  Temp := IncludeFileName;
                  SkipIncludeFile := False;
                  Break;
                end;
              end;
              if SkipIncludeFile then
              begin
                SkipIncludeFile := False;
                for K := 0 to FrmFalconMain.FilesParsed.PathList.Count - 1 do
                begin
                  IncludeFileName := ExpandFileName(FrmFalconMain.FilesParsed.PathList.Strings[K] +
                    IncludeName);
                  if FileExists(IncludeFileName) or
                    (Pos(':', ExtractRelativePath(ProjectDir, IncludeFileName)) > 0) then
                  begin
                    SkipIncludeFile := True;
                    Break;
                  end;
                end;
              end;
              if SkipIncludeFile then
                Continue;
            end;
            Includes.Add(Temp);
          end;
        end;
      end;
      IncludeList.Free;
    end;
    OldDebuggingState := Debugging;
    Debugging := HasBreakpoint or BreakpointCursor.Valid;
    BreakpointChanged := False;
    ExecDirectory := ExtractFilePath(FileName);
    if not HasResource and (FileType <> FILE_TYPE_PROJECT) then
    begin
      Files.Clear;
      if CompilerType = COMPILER_C then
        ExecFileName := 'gcc'
      else
        ExecFileName := 'g++';
      ExecParams := Trim(CompilerOptions);
      if Debugging then
      begin
        ExecParams := RemoveOption('-s', ExecParams);
        ExecParams := RemoveOption('-O2', ExecParams);
        ExecParams := RemoveOption('-O3', ExecParams);
        ExecParams := ExecParams + ' -g';
      end;
      // TransformToRelativePath;
      Temp := ExtractRelativePath(ExecDirectory, FileName);
      Temp := DoubleQuotedStr(Temp);
      ExecParams := ExecParams + ' ' + Temp;
      Temp := DoubleQuotedStr(Target);
      ExecParams := ExecParams + ' -o ' + Temp;
      ExecParams := Trim(ExecParams + ' ' + Libs);
      ExecParams := Trim(ExecParams + ' ' + Flags);
      ExecParams := Trim(ExecParams + ' -fno-diagnostics-show-option');
      MkRes := 0;
    end
    else
    begin
      Makefile := ExtractFilePath(FileName) + 'Makefile.mak';
      ExecFileName := 'mingw32-make.exe';
      ExecParams := '-s -f Makefile.mak';
      mk := TMakefile.Create;
      mk.BaseDir := ExtractFilePath(FileName);
      mk.Files := Files;
      mk.FileName := Makefile;
      mk.Target := Target;
      mk.Libs := Libs;
      mk.Flags := Trim(Flags + ' -fno-diagnostics-show-option');
      mk.CompilerIsCpp := (CompilerType = COMPILER_CPP);
      mk.CreateLibrary := (AppType = APPTYPE_LIB);
      mk.CompilerPath := FCompilerPath;
      mk.CompilerOptions := CompilerOptions;
      if not OldDebuggingState and Debugging then
        ForceClean := True;
      mk.ForceClean := ForceClean;
      mk.DebugMode := Debugging;
      if Debugging then
      begin
        mk.CompilerOptions := RemoveOption('-s', mk.CompilerOptions);
        mk.CompilerOptions := RemoveOption('-O1', mk.CompilerOptions);
        mk.CompilerOptions := RemoveOption('-O2', mk.CompilerOptions);
        mk.CompilerOptions := RemoveOption('-O3', mk.CompilerOptions);
      end;
      mk.CleanBefore := DeleteObjsBefore;
      mk.CleanAfter := DeleteObjsAfter;
      mk.Echo := True;
      MkRes := mk.BuildMakefile;
      if mk.CleanBefore or mk.ForceClean then
        ExecParams := ExecParams + ' clean all'
      else
        ExecParams := ExecParams + ' all';
      if mk.CleanAfter then
        ExecParams := ExecParams + ' clear';
      mk.Free;
    end;
    for I := 0 to Files.Count - 1 do
      Files.Objects[I].Free;
    Files.Free;
    if MkRes = 0 then
    begin
      ForceClean := False; //WARNING if mingw32-make.exe not complete clean rule
                          //directives aren't updated
      FrmFalconMain.LastProjectBuild := Self;
      FrmFalconMain.CompilerCmd.FileName := ExecFileName;
      FrmFalconMain.CompilerCmd.Directory := ExecDirectory;
      FrmFalconMain.CompilerCmd.Params := ExecParams;
      FrmFalconMain.CompilerCmd.Start;
    end
    else
    begin
      MkWar := TStringList.Create;
      MkWar.Add(FileContSpc + ':' + MAKEFILE_MSG[MkRes]);
      FrmFalconMain.CompilerCmdFinish(nil, '', '', MkWar, MkRes);
      MkWar.Free;
    end;
  end
  else if (CompilerType = COMPILER_RC) then
  begin
    Res := TStringList.Create;
    Temp := Name;
    if GetResource(Res) then
    begin
      if Assigned(Icon) then
        Icon.SaveToFile(ExtractFilePath(FileName) + 'AppIcon.ico');
      Manf := 0;
      if EnableTheme and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
        Manf := Manf or 1;
      if RequiresAdmin and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
        Manf := Manf or 2;
      Temp := ExtractFilePath(FileName) + 'AppManifest.dat';
      case Manf of
        1: SaveManifest(Temp, 'MANFTHEME');
        2: SaveManifest(Temp, 'MANFADMIN');
        3: SaveManifest(Temp, 'MANFBOTH');
      end;
      Res.SaveToFile(ExtractFilePath(FileName) + 'AppResource.rc');
      Temp := 'AppResource.rc';
    end;
    Res.Free;

    FrmFalconMain.CompilerCmd.FileName := 'windres.exe';
    FrmFalconMain.CompilerCmd.Directory := ExtractFilePath(FileName);
    FrmFalconMain.CompilerCmd.Params := '-i "' + Temp + '" -J rc -o "' +
      Target + '" -O COFF';
    FrmFalconMain.LastProjectBuild := Self;
    FrmFalconMain.CompilerCmd.Start;
  end;
end;

function TProjectBase.TargetChanged: Boolean;
begin
  Result := True;
  if FileExists(GetTarget) then
  begin
    Result := FTargetDateTime <> FileDateTime(GetTarget);
  end
  else if FileExists(Target) then
  begin
    Result := FTargetDateTime <> FileDateTime(Target);
  end
end;

function TProjectBase.GetFlags: string;
begin
  Result := Configuration.Flags;
end;

function TProjectBase.GetIcon: TIcon;
begin
  Result := Configuration.Icon;
end;

function TProjectBase.GetIconFileName: string;
begin
  Result := Configuration.IconFileName;
end;

function TProjectBase.GetIncludeInfo: Boolean;
begin
  Result := Configuration.IncludeVersionInfo;
end;

function TProjectBase.GetLibs: string;
begin
  Result := Configuration.Libs;
end;

function TProjectBase.GetRequiresAdmin: Boolean;
begin
  Result := Configuration.RequiresAdmin;
end;

function TProjectBase.GetResource(Res: TStrings): Boolean;
var
  List: TStrings;
  I: Integer;
  Vers: string;
  Manf: Byte;
begin
  Result := False;
  List := TStringList.Create;
  try
    GetSources(List, [FILE_TYPE_RC]);
    for I := 0 to List.Count - 1 do
    begin
      Result := True;
      Res.Add(Format('#include "%s"', [
        ExtractRelativePath(ExtractFilePath(FileName),
        TSourceBase(List.Objects[I]).FileName)
      ]));
    end;
  finally
    List.Free;
  end;
  Manf := 0;
  if IncludeVersionInfo or Assigned(Icon) then
    Result := True;
  if EnableTheme and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
    Manf := Manf or 1;
  if RequiresAdmin and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
    Manf := Manf or 2;
  Result := Result or (Manf > 0);
  if not Result then
    Exit;
  if Assigned(Icon) then
    Res.Add('MAINICON ICON AppIcon.ico');
  if Manf > 0 then
    Res.Add('1 24 AppManifest.dat');
  if not IncludeVersionInfo then
    Exit;
  Res.Add('1 VERSIONINFO');
  Vers := VersionToStr(Version.Version, ', ');
  Res.Add('    FILEVERSION ' + Vers);
  if Length(Version.ProductVersion) > 0 then
    Vers := StringReplace(Version.ProductVersion, '.', ', ', [rfReplaceAll]);
  Res.Add('    PRODUCTVERSION ' + Vers);
  Res.Add('    FILEOS 0x4L');
  Res.Add('    FILETYPE 0x1L');
  Res.Add('BEGIN');
  Res.Add('    BLOCK "StringFileInfo"');
  Res.Add('    BEGIN');
  Res.Add('        BLOCK "' + IntToHex(Version.LanguageID, 4) +
    IntToHex(Version.CharsetID, 4) + '"');
  Res.Add('        BEGIN');
  Res.Add('            VALUE "CompanyName", "' + Version.CompanyName + '"');
  Res.Add('            VALUE "FileDescription", "' + Version.FileDescription + '"');
  Res.Add('            VALUE "FileVersion", "' + Version.FileVersion + '"');
  Res.Add('            VALUE "InternalName", "' + Version.InternalName + '"');
  Res.Add('            VALUE "LegalCopyright", "' + Version.LegalCopyright + '"');
  Res.Add('            VALUE "OriginalFilename", "' + Version.OriginalFilename + '"');
  Res.Add('            VALUE "ProductName", "' + Version.ProductName + '"');
  Res.Add('            VALUE "ProductVersion", "' + Version.ProductVersion + '"');
  Res.Add('        END');
  Res.Add('    END');
  Res.Add('    BLOCK "VarFileInfo"');
  Res.Add('    BEGIN');
  Res.Add('        VALUE "Translation", 0x' +
    IntToHex(Version.LanguageID, 4) + ', 0x' + IntToHex(Version.CharsetID, 4));
  Res.Add('    END');
  Res.Add('END');
end;

function TProjectBase.GetSourceConfiguration(Index: Integer): TSourceConfiguration;
var
  ConfigGroup: TSourceConfigGroup;
begin
  ConfigGroup := ConfigurationGroup;
  if ConfigGroup = nil then
    raise Exception.Create('Configuration group not found');
  Result := TSourceConfiguration(ConfigGroup.Node.Item[Index].Data);
end;

function TProjectBase.GetAppType: Integer;
begin
  Result := Configuration.AppType;
end;

function TProjectBase.GetAutoIncBuild: Boolean;
begin
  Result := Configuration.AutoIncBuild;
end;

function TProjectBase.GetBreakpointFiles(List: TStrings): Boolean;
var
  I: Integer;
  Files: TStrings;
  fprop: TSourceFile;
begin
  Files := TStringList.Create;
  GetSources(Files, SOURCE_TYPES, [], FilterBreakPoint);
  Result := Files.Count > 0;
  for I := 0 to Files.Count - 1 do
  begin
    fprop := TSourceFile(Files.Objects[I]);
    List.AddObject(Files.Strings[I], fprop);
  end;
  Files.Free;
end;

function TProjectBase.GetCmdLine: string;
begin
  Result := Configuration.CmdLine;
end;

function TProjectBase.GetCompilerType: Integer;
begin
  Result := Configuration.CompilerType;
end;

function TProjectBase.GetCompOpt: string;
begin
  Result := Configuration.CompilerOptions;
end;

function TProjectBase.GetConfigName: string;
begin
  Result := Configuration.Name;
end;

function TProjectBase.GetConfigurationGroup: TSourceConfigGroup;
var
  List: TStrings;
begin
  Result := nil;
  List := TStringList.Create;
  try
    GetSources(List, [FILE_TYPE_CONFIG_GROUP], [], nil, True);
    if List.Count = 0 then
      Exit;
    Result := TSourceConfigGroup(List.Objects[0]);
  finally
    List.Free;
  end;
end;

function TProjectBase.GetCurrentConfiguration: TProjectConfiguration;
begin
  Result := Configurations[FConfigIndex];
end;

function TProjectBase.GetDelMakAfter: Boolean;
begin
  Result := Configuration.DeleteMakefileAfter;
end;

function TProjectBase.GetDelObjAfter: Boolean;
begin
  Result := Configuration.DeleteObjsAfter;
end;

function TProjectBase.GetDelObjPrior: Boolean;
begin
  Result := Configuration.DeleteObjsBefore;
end;

function TProjectBase.GetDelResAfter: Boolean;
begin
  Result := Configuration.DeleteResourcesAfter;
end;

function TProjectBase.GetEnableTheme: Boolean;
begin
  Result := Configuration.EnableTheme;
end;

function TProjectBase.HasBreakpoint: Boolean;
var
  Files: TStrings;
begin
  Files := TStringList.Create;
  try
    GetSources(Files, SOURCE_TYPES, [], FilterBreakPoint);
    Result := Files.Count > 0;
  finally
    Files.Free;
  end;
end;

{TProjectFile}

procedure TProjectFile.Close;
begin
end;

procedure TProjectFile.CloseAll;
var
  I: Integer;
  Files: TStrings;
begin
  Files := TStringList.Create;
  GetSources(Files, FILES_TYPES);
  for I := 0 to Files.Count - 1 do
    TSourceFile(Files.Objects[I]).Close;
  Files.Free;
end;

procedure TProjectFile.SaveAll;
var
  I: Integer;
  AllFiles: TStrings;
  S: string;
  Template: TTemplate;
  Resources: TTemplateResources;
begin
  if not IsNew then
    SomeFileChanged := False;
  //save all files with folders
  AllFiles := TStringList.Create;
  GetSources(AllFiles, FILES_TYPES + [FILE_TYPE_FOLDER]);
  for I := 0 to AllFiles.Count - 1 do
    TSourceFile(AllFiles.Objects[I]).Save;
  AllFiles.Free;
  //save template resources
  if not Assigned(FTemplateResources) then
    Exit;
  Template := FrmFalconMain.Templates.Find(FTemplateResources);
  if Assigned(Template) then
  begin
    Resources := Template.Resources;
    for I := 0 to Resources.Count - 1 do
    begin
      S := ExtractFilePath(FileName) +
        Resources.ResourceName[I];
      Resources.SaveToFile(S, I);
    end;
  end;
  FTemplateResources.Free;
  FTemplateResources := nil;
end;

procedure TProjectFile.LoadFromFile(const FileName: string);

  procedure LoadFiles(XMLNode: IXMLNode; Parent: TSourceBase);
  var
    Temp: IXMLNode;
    NodeFileName: string;
    FileProp: TSourceBase;
  begin
    Temp := XMLNode.ChildNodes.First;
    while (Temp <> nil) do
    begin
      NodeFileName := Temp.Attributes['Name'];
      if (Temp.NodeName = 'Folder') then
      begin
        FileProp := NewSourceFile(FILE_TYPE_FOLDER, NO_COMPILER, NodeFileName,
          NodeFileName, '', '', Parent, True, False);
        FileProp.Saved := True;
        FileProp.IsNew := False;
        LoadFiles(Temp, FileProp);
      end
      else if (Temp.NodeName = 'File') then
      begin
        FileProp := NewSourceFile(GetFileType(NodeFileName),
          GetCompiler(GetFileType(NodeFileName)), NodeFileName,
          RemoveFileExt(NodeFileName), ExtractFileExt(NodeFileName),
          '', Parent, True, False);
        NodeFileName := FileProp.FileName;
        if FileExists(NodeFileName) then
        begin
          TSourceFile(FileProp).DateOfFile := FileDateTime(NodeFileName);
          FileProp.Saved := True;
          FileProp.IsNew := False;
        end
        else
        begin
          FileProp.Saved := False;
          FileProp.IsNew := True;
        end;
      end;
      Temp := Temp.NextSibling;
    end;
  end;

var
  XMLDoc: IXMLDocument;
  Node, ProjNode: IXMLNode;
  NewConfig: TProjectConfiguration;
  FileProp: TSourceBase;
  Index: Integer;
  SourceNode: TTreeNode;
begin
  IsNew := False;
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromFile(FileName);
  except
    //XMLDoc.Free;
    Target := ExtractName(FileName) + '.exe';
    CompilerOptions := '-Wall -s';
    DeleteObjsBefore := True;
    DeleteObjsAfter := True;
    DeleteMakefileAfter := True;
    DeleteResourcesAfter := True;
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := #9;

  //tag project
  ProjNode := XMLDoc.ChildNodes.FindNode('Project');
  if (ProjNode = nil) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  Node := ProjNode.ChildNodes.FindNode('Files');
  if (Node <> nil) then
    LoadFiles(Node, Self);
  Index := GetIntProperty(ProjNode, 'ConfigurationIndex', 'Value');
  Configuration.Load(ProjNode);
  Node := ProjNode.ChildNodes.FindNode('Configurations');
  if Node <> nil then
  begin
    NewConfig := TProjectConfiguration.Create;
    Node := Node.ChildNodes.First;
    while (Node <> nil) do
    begin
      NewConfig.Load(Node);
      if Configurations.Count > 0 then
      begin
        FileProp := NewSourceFile(FILE_TYPE_CONFIG, NO_COMPILER, NewConfig.Name,
          NewConfig.Name, '', '', Self, True, False);
        TSourceConfiguration(FileProp).Configuration := NewConfig;
        FileProp.Saved := True;
        FileProp.IsNew := False;
        if ConfigurationIndex < Index then
        begin
          SourceNode := SourceConfiguration[ConfigurationIndex].Node;
          SourceNode.MoveTo(SourceNode.getNextSibling, naAdd);
          TSourceConfiguration(SourceNode.Data).Move(1);
          PropertyChanged := False;
          CompilePropertyChanged := False;
        end;
      end;
      Node := Node.NextSibling;
    end;
    NewConfig.Free;
  end;
  ConfigurationChanged(-1);
end;

function TProjectFile.SearchFile(const Name: string): TSourceFile;
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  Result := nil;
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if (SourceBase is TSourceFile) and SameText(Name, SourceBase.Name) then
      Result := TSourceFile(SourceBase);
    if Result <> nil then
      Break;
    if SourceBase is TSourceFolder then
      Result := TSourceFolder(SourceBase).SearchFile(Name);
    if Result <> nil then
      Break;
  end;
end;

procedure TProjectFile.LoadLayout;

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string;
    Default: string = ''): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := Temp.Attributes[Attribute]
    else
      Result := Default;
  end;

  function GetPageCount: Integer;
  begin
    Result := FrmFalconMain.PageControlEditor.PageCount
  end;

var
  XMLDoc: IXMLDocument;
  Node, FoldersNode, FilesNode, LytNode: IXMLNode;
  Temp, S, LytFileName: string;
  TopIndex, TopLine, Tabpos: Integer;
  FileProp: TSourceFile;
  Sheet: TSourceFileSheet;
  CaretXY, BlockS_or_E: TBufferCoord;
  //List: TStrings; //for unascendent layout file
begin
  LytFileName := ChangeFileExt(FileName, '.layout');
  if not FileExists(LytFileName) then
    Exit;
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromFile(LytFileName);
  except
    //XMLDoc.Free;
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := #9;

  //tag project
  LytNode := XMLDoc.ChildNodes.FindNode('Layout');
  if (LytNode = nil) then
  begin
    //XMLDoc.Free;
    Exit;
  end;
  //tag files
  FilesNode := LytNode.ChildNodes.FindNode('Files');
  if (FilesNode <> nil) then
  begin
    FrmFalconMain.HandlingTabs := True;
    TopIndex := 0;
    Node := FilesNode.ChildNodes.First;
    while Node <> nil do
    begin
      if SameText(Node.NodeName, 'File') then
      begin
        if not Node.HasAttribute('Name') then
        begin
          Node := Node.NextSibling;
          Continue;
        end;
        S := Node.Attributes['Name'];
        FileProp := GetFileByPathName(S);
        if not Assigned(FileProp) then
        begin
          Node := Node.NextSibling;
          Continue;
        end;
        Sheet := FileProp.Edit(False);
        Temp := Node.Attributes['Tabpos'];
        //start from last tab
        Tabpos := StrToIntDef(Temp, 1);
        if Tabpos < 1 then
          Tabpos := 1;
        //invalid tab position
        if Tabpos > GetPageCount then
        begin
          //organize after
          //List.addObject(IntToStr(Tabpos), FileProp ? Sheet); comment line down
          Tabpos := GetPageCount;
        end;
        Sheet.PageIndex := Tabpos - 1;
        Temp := Node.Attributes['Top'];
        if HumanToBool(Temp) then
        begin
          TopIndex := Tabpos;
        end;
        Temp := GetTagProperty(Node, 'Cursor', 'Line', '1');
        CaretXY.Line := StrToIntDef(Temp, 1);
        if CaretXY.Line < 1 then
          CaretXY.Line := 1;
        Temp := GetTagProperty(Node, 'Cursor', 'Column', '1');
        CaretXY.Char := StrToIntDef(Temp, 1);
        if CaretXY.Char < 1 then
          CaretXY.Char := 1;
        Sheet.Editor.CaretXY := CaretXY;
        if Node.ChildNodes.FindNode('Selection') <> nil then
        begin
          Temp := GetTagProperty(Node, 'Selection', 'Line', '1');
          BlockS_or_E.Line := StrToIntDef(Temp, 1);
          if BlockS_or_E.Line < 1 then
            BlockS_or_E.Line := 1;
          Temp := GetTagProperty(Node, 'Selection', 'Column', '1');
          BlockS_or_E.Char := StrToIntDef(Temp, 1);
          if BlockS_or_E.Char < 1 then
            BlockS_or_E.Char := 1;
          if (BlockS_or_E.Line > CaretXY.Line) or ((BlockS_or_E.Line = CaretXY.Line)
            and (BlockS_or_E.Char > CaretXY.Char)) then
          begin
            Sheet.Editor.BlockBegin := CaretXY;
            Sheet.Editor.BlockEnd := BlockS_or_E;
          end
          else
          begin
            Sheet.Editor.BlockBegin := BlockS_or_E;
            Sheet.Editor.BlockEnd := CaretXY;
          end;
        end;
        Temp := Node.Attributes['TopLine'];
        TopLine := StrToIntDef(Temp, 1);
        if TopLine < 1 then
          TopLine := 1;
        Sheet.Editor.TopLine := TopLine;
      end;
      Node := Node.NextSibling;
    end;
    if TopIndex > 0 then
      FrmFalconMain.PageControlEditor.ActivePageIndex := TopIndex - 1
    else if (FrmFalconMain.PageControlEditor.ActivePageIndex < 0) and
      (GetPageCount > 0) then
      FrmFalconMain.PageControlEditor.ActivePageIndex := 0;
    //update grayed project and outline
    FrmFalconMain.HandlingTabs := False;
    FrmFalconMain.PageControlEditorPageChange(FrmFalconMain.PageControlEditor,
      FrmFalconMain.PageControlEditor.ActivePageIndex, -1);
  end;
  //load expanded folders
  FoldersNode := LytNode.ChildNodes.FindNode('Folders');
  if (FoldersNode <> nil) then
  begin
    Node := FoldersNode.ChildNodes.First;
    while Node <> nil do
    begin
      S := Node.Attributes['Name'];
      FileProp := GetFileByPathName(S);
      if Assigned(FileProp) then
      begin
        Temp := Node.Attributes['Expanded'];
        if FileProp.FileType = FILE_TYPE_FOLDER then
        begin
          if HumanToBool(Temp) then
            FileProp.Node.Expanded := True;
        end;
      end;
      Node := Node.NextSibling;
    end;
  end;
  if FrmFalconMain.Visible then
    if FrmFalconMain.GetActiveSheet(Sheet) then
      Sheet.Editor.SetFocus;
end;

procedure TProjectFile.SaveLayout;

var
  pageIndex, FilesOpenCount, FoldersExpanded: Integer;
  FileList, FolderList: TStrings;

  procedure AddFile(const RelFileName: string; Sheet: TSourceFileSheet);
  var
    I, Index, pi: Integer;
  begin
    Index := 0;
    for I := 0 to FileList.Count - 1 do
    begin
      pi := TSourceFileSheet(FileList.Objects[I]).PageIndex;
      if pi > Sheet.PageIndex then
      begin
        Index := I;
        Break;
      end;
      if I = FileList.Count - 1 then
        Index := I + 1;
    end;
    FileList.InsertObject(Index, RelFileName, Sheet)
  end;

  procedure SetTagProperty(Node: IXMLNode; Tag, Attribute, Value: string);
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp = nil) then
      Temp := Node.AddChild(Tag);
    Temp.Attributes[Attribute] := Value;
  end;

  procedure AddFiles(Parent: TSourceBase);
  var
    I: Integer;
    FileProp: TSourceBase;
    ProjPath, RelFileName: string;
    Sheet: TSourceFileSheet;
  begin
    ProjPath := ExtractFilePath(FileName);
    for I := 0 to Parent.Node.Count - 1 do
    begin
      FileProp := TSourceFile(Parent.Node.Item[I].Data);
      RelFileName := ExtractRelativePath(ProjPath, FileProp.FileName);
      if (FileProp is TSourceFolder) then
      begin
        RelFileName := ExcludeTrailingPathDelimiter(RelFileName);
        if FileProp.Node.Expanded then
        begin
          Inc(FoldersExpanded);
          FolderList.AddObject(RelFileName, FileProp.Node);
        end;
        AddFiles(FileProp);
      end
      else if (FileProp is TSourceFile) and TSourceFile(FileProp).GetSheet(Sheet) then
      begin
        Inc(FilesOpenCount);
        AddFile(RelFileName, Sheet);
      end;
    end;
  end;

var
  XMLDoc: IXMLDocument;
  Temp, Node, LytNode: IXMLNode;
  I: Integer;
  BoolStr: string;
  Sheet: TSourceFileSheet;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := True;
  XMLDoc.Version := '1.0';
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.Encoding := 'UTF-8';
  XMLDoc.NodeIndentStr := #9;

  LytNode := XMLDoc.AddChild('Layout');
  pageIndex := FrmFalconMain.PageControlEditor.ActivePageIndex;
  FilesOpenCount := 0;
  FileList := TStringList.Create;
  FoldersExpanded := 0;
  FolderList := TStringList.Create;
  //get files
  AddFiles(Self);
  //end get files
  if FileList.Count > 0 then
  begin
    Node := LytNode.AddChild('Files');
    for I := 0 to FileList.Count - 1 do
    begin
      Sheet := TSourceFileSheet(FileList.Objects[I]);
      Temp := Node.AddChild('File');
      Temp.Attributes['Name'] := FileList.Strings[I];
      BoolStr := BoolToHuman(pageIndex = Sheet.PageIndex);
      Temp.Attributes['Top'] := BoolStr;
      Temp.Attributes['Tabpos'] := IntToStr(Sheet.PageIndex + 1);
      Temp.Attributes['TopLine'] := IntToStr(Sheet.Editor.TopLine);
      SetTagProperty(Temp, 'Cursor', 'Line', IntToStr(Sheet.Editor.CaretY));
      SetTagProperty(Temp, 'Cursor', 'Column', IntToStr(Sheet.Editor.CaretX));
      if Sheet.Editor.SelAvail then
      begin
        if (Sheet.Editor.BlockBegin.Line = Sheet.Editor.CaretXY.Line) and
          (Sheet.Editor.BlockBegin.Char = Sheet.Editor.CaretXY.Char) then
        begin
          SetTagProperty(Temp, 'Selection', 'Line', IntToStr(Sheet.Editor.BlockEnd.Line));
          SetTagProperty(Temp, 'Selection', 'Column', IntToStr(Sheet.Editor.BlockEnd.Char));
        end
        else
        begin
          SetTagProperty(Temp, 'Selection', 'Line', IntToStr(Sheet.Editor.BlockBegin.Line));
          SetTagProperty(Temp, 'Selection', 'Column', IntToStr(Sheet.Editor.BlockBegin.Char));
        end;
      end;
    end;
  end;
  FileList.Free;
  if FolderList.Count > 0 then
  begin
    Node := LytNode.AddChild('Folders');
    for I := 0 to FolderList.Count - 1 do
    begin
      Temp := Node.AddChild('Folder');
      Temp.Attributes['Name'] := FolderList.Strings[I];
      BoolStr := BoolToHuman(True);
      Temp.Attributes['Expanded'] := BoolStr;
    end;
  end;
  FolderList.Free;
  try
    if (FilesOpenCount > 0) or (FoldersExpanded > 0) then
      XMLDoc.SaveToFile(ChangeFileExt(FileName, '.layout'))
    else
      DeleteFile(ChangeFileExt(FileName, '.layout'));
  except
    Exit;
  end;
end;

procedure TProjectFile.SaveToFile(const FileName: string);

  procedure AddFiles(XMLNode: IXMLNode; Parent: TSourceBase);
  var
    Temp: IXMLNode;
    I: Integer;
    FileProp: TSourceBase;
  begin
    for I := 0 to Parent.Node.Count - 1 do
    begin
      FileProp := TSourceBase(Parent.Node.Item[I].Data);
      if (FileProp is TSourceFolder) then
      begin
        Temp := XMLNode.AddChild('Folder');
        Temp.Attributes['Name'] := ExcludeTrailingPathDelimiter(FileProp.FFileName);
        AddFiles(Temp, FileProp);
      end
      else if (FileProp is TSourceFile) then
      begin
        Temp := XMLNode.AddChild('File');
        Temp.Attributes['Name'] := FileProp.FFileName;
      end;
    end;
  end;

var
  XMLDoc: IXMLDocument;
  Node, ConfigNode, ProjNode: IXMLNode;
  I: Integer;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := True;
  XMLDoc.Version := '1.0';
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.Encoding := 'UTF-8';
  XMLDoc.NodeIndentStr := #9;

  ProjNode := XMLDoc.AddChild('Project');
  Node := ProjNode.AddChild('Files');
  AddFiles(Node, Self);
  SetIntProperty(ProjNode, 'ConfigurationIndex', 'Value', ConfigurationIndex);
  Configuration.Save(ProjNode);
  if Configurations.Count > 1 then
  begin
    Node := ProjNode.AddChild('Configurations');
    for I := 0 to Configurations.Count - 1 do
    begin
      if I = FConfigIndex then
        Continue;
      ConfigNode := Node.AddChild('Configuration');
      Configurations[I].Save(ConfigNode);
    end;
  end;
  try
    XMLDoc.SaveToFile(FileName);
  except
    Exit;
  end;
  IsNew := False;
end;

procedure TProjectFile.Save;
begin
  if Saved and not Modified and FileExists(FileName) and not FileChangedInDisk then
    Exit;
  SaveToFile(FileName);
  FFileDateTime := FileDateTime(FileName);
  Compiled := False;
  Saved := True;
  IsNew := False;
  if Node.Text <> Name then
    Node.Text := Name;
  PropertyChanged := False;
end;

procedure TProjectFile.SaveAs(const FileName: string);
begin
  if not SameText(FileName, FFileName) then
  begin
    if IsNew then
      MoveSavedTo(ExtractFilePath(FileName))
    else
      CopySavedTo(ExtractFilePath(FileName));
  end;
  inherited;
  SaveAll;
end;

function TProjectFile.NeedBuild: Boolean;
begin
  Result := inherited NeedBuild or FilesChanged;
end;

function TProjectFile.GetFileName: string;
begin
  Result := FFileName;
end;

function TProjectFile.GetName: string;
begin
  Result := ExtractName(FFileName);
end;

function TProjectFile.IsModified: Boolean;
begin
  Result := PropertyChanged or FileChangedInDisk or SomeFileChanged;
end;

procedure TProjectFile.MoveSavedTo(const Path: string);
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if (SourceBase is TSourceFolder) and SourceBase.Saved then
      TSourceFolder(Node.Item[I].Data).MoveTo(Path)
    else if (SourceBase is TSourceFile) and SourceBase.Saved then
      TSourceFile(Node.Item[I].Data).MoveTo(Path);
  end;
end;

procedure TProjectFile.CopySavedTo(const Path: string);
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if (SourceBase is TSourceFolder) and SourceBase.Saved then
      TSourceFolder(Node.Item[I].Data).CopyTo(Path)
    else if (SourceBase is TSourceFile) and SourceBase.Saved then
      TSourceFile(Node.Item[I].Data).CopyTo(Path);
  end;
end;

procedure TProjectFile.Delete;
var
  I: Integer;
begin
  Deleting := True;
  for I := Node.Count - 1 downto 0 do
    TSourceBase(Node.Item[I].Data).Delete;
  inherited Delete;
end;

function TProjectFile.SearchSource(const Name: string; var SourceFound: TSourceBase): Boolean;
var
  I: Integer;
  SourceBase: TSourceBase;
begin
  Result := False;
  for I := 0 to Node.Count - 1 do
  begin
    SourceBase := TSourceBase(Node.Item[I].Data);
    if (not (SourceBase is TSourceFile) and not (SourceBase is TSourceFolder))
      or not SameText(SourceBase.Name, Name) then
      Continue;
    SourceFound := SourceBase;
    Result := True;
    Break;
  end;
end;

procedure TProjectFile.SetFileName(Value: string);
begin
  if (FileName = Value) or (Value = '') then
    Exit;
  UpdateTarget(Value);
  MoveSavedTo(ExtractFilePath(Value));
  inherited SetFileName(Value);
end;

{TProjectsSheet}

constructor TProjectsSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListView := TListView.Create(Self);
  FListView.Parent := Self;
  FListView.Align := alClient;
  FListView.DoubleBuffered := True;
  FListView.HideSelection := False;
  FListView.ReadOnly := True;
  FListView.IconOptions.AutoArrange := True;
  SetExplorerTheme(FListView.Handle);
end;

destructor TProjectsSheet.Destroy;
begin
  inherited Destroy;
end;

{TSourceFileSheet}

class procedure TSourceFileSheet.UpdateEditor(Editor: TEditor);
var
  Options: TEditorOptions;
begin
  Options := FrmFalconMain.Config.Editor;
  Editor.BeginUpdate;
  FrmFalconMain.SintaxList.Selected.UpdateEditor(Editor);
  Editor.Font.Name := Options.FontName;
  Editor.Font.Size := Options.FontSize;
  Editor.Zoom := FrmFalconMain.ZoomEditor;
  Editor.Folding := True;
  Editor.ShowIndentGuides := True;
  //------------ General --------------------------//
  Editor.InsertMode := Options.InsertMode;
  Editor.SetUseTabs(Options.UseTabChar);
  if Options.ShowSpaceChars then
    Editor.SetViewWS(SCWS_VISIBLEALWAYS)
  else
    Editor.SetViewWS(SCWS_INVISIBLE);
  Editor.SetWhitespaceFore(True, clOrange);
  Editor.TabWidth := Options.TabWidth;
  //---------------- Display ---------------------//
  if Options.ShowRightMargin then
  begin
    Editor.SetEdgeMode(EDGE_LINE);
    Editor.SetEdgeColumn(Options.RightMargin);
  end
  else
    Editor.SetEdgeMode(EDGE_NONE);
  Editor.ShowGutter := Options.ShowGutter;
  Editor.ShowLineNumber := Options.ShowLineNumber;
  Editor.EndUpdate;
end;

constructor TSourceFileSheet.CreateEditor(SourceFile: TSourceFile;
  PageCtrl: TModernPageControl; SelectTab: Boolean);
begin
  inherited Create(PageCtrl);
  ParentBackground := False;
  FSourceFile := SourceFile;
  FSourceFile.FSheet := Self;
  FSheetType := SHEET_TYPE_FILE;
  FEditor := TEditor.Create(Self);
  FEditor.Parent := Self;
  FEditor.Align := alClient;
  FEditor.WantTabs := True;
  FEditor.ReadOnly := SourceFile.ReadOnly;
  SourceFile.UpdateSheetStatus(SourceFile.IsModified);
  FEditor.SetEOLMode(TSourceFile.GetEditorEolMode(SourceFile.LineEnding));
  FEditor.SearchEngine := FrmFalconMain.SearchEngine;
  FEditor.ImageList := FrmFalconMain.ImageListGutter;
  FEditor.PopupMenu := FrmFalconMain.PopupEditor;
  case SourceFile.FileType of
    FILE_TYPE_C..FILE_TYPE_H, FILE_TYPE_UNKNOW: FEditor.Highlighter := FrmFalconMain.CppHighligher;
    // TODO: commented
    // FILE_TYPE_RC: Sheet.Editor.Highlighter := FrmFalconMain.ResourceHighlighter;
  end;
  UpdateEditor(FEditor);
  PageControl := PageCtrl;
  FEditor.OnContextPopup := FrmFalconMain.EditorContextPopup;
  FEditor.OnChange := FrmFalconMain.TextEditorChange;
  FEditor.OnExit := FrmFalconMain.TextEditorExit;
  FEditor.OnEnter := FrmFalconMain.TextEditorEnter;
  FEditor.OnMouseLeave := FrmFalconMain.TextEditorMouseLeave;
  FEditor.OnUpdateUI := FrmFalconMain.TextEditorStatusChange;
  FEditor.OnMouseDown := FrmFalconMain.TextEditorMouseDown;
  FEditor.OnMouseMove := FrmFalconMain.TextEditorMouseMove;
  FEditor.OnHotSpotClick := FrmFalconMain.TextEditorLinkClick;
  FEditor.OnCharAdded := FrmFalconMain.TextEditorCharAdded;
  FEditor.OnKeyDown := FrmFalconMain.TextEditorKeyDown;
  FEditor.OnKeyPress := FrmFalconMain.TextEditorKeyPress;
  FEditor.OnMarginClick := FrmFalconMain.TextEditorGutterClick;
  FEditor.OnScroll := FrmFalconMain.TextEditorScroll;
  FEditor.OnClick := FrmFalconMain.TextEditorClick;
  if SelectTab then
    PageCtrl.ActivePageIndex := PageIndex;
end;

destructor TSourceFileSheet.Destroy;
begin
  FSourceFile.FSheet := nil;
  inherited Destroy;
end;

{ TSourceConfiguration }

procedure TSourceConfiguration.Delete;
var
  AParent: TSourceBase;
begin
  Deleting := True;
  if Project.Configurations.Count > 1 then
    Project.Configurations.Delete(Node.Index);
  AParent := nil;
  if (Project.Configurations.Count = 1) and not Parent.Deleting then
    AParent := Parent;
  inherited;
  if AParent <> nil then
    AParent.Delete;
end;

procedure TSourceConfiguration.DoRename(const OldFileName: string);
begin
  Project.Configurations[Node.Index].Name := Name;
  inherited;
end;

function TSourceConfiguration.GetConfiguration: TProjectConfiguration;
begin
  Result := Project.Configurations[Node.Index];
end;

procedure TSourceConfiguration.Move(Offset: Integer);
var
  RangeBegin, RangeEnd, NewConfigIndex: Integer;
begin
  Project.Configurations.Move(Node.Index - Offset, Offset);
  RangeBegin := Min(Node.Index - Offset, Node.Index);
  RangeEnd := Max(Node.Index - Offset, Node.Index);
  NewConfigIndex := Project.ConfigurationIndex;
  if Node.Index = Project.ConfigurationIndex + Offset then
    NewConfigIndex := Node.Index
  else if (Project.ConfigurationIndex >= RangeBegin) and (Project.ConfigurationIndex <= RangeEnd) then
    NewConfigIndex := Project.ConfigurationIndex - Abs(Offset) div Offset;
  Project.ConfigurationIndex := NewConfigIndex;
end;

function TSourceConfiguration.Open: Boolean;
begin
  Result := Project.ConfigurationIndex <> Node.Index;
  Project.ConfigurationIndex := Node.Index;
end;

procedure TSourceConfiguration.SetConfiguration(
  const Value: TProjectConfiguration);
begin
  Project.Configurations[Node.Index] := Value;
end;

{ TProjectConfigurationList }

function TProjectConfigurationList.Add: TProjectConfiguration;
var
  Tmp: TProjectConfiguration;
begin
  Tmp := TProjectConfiguration.Create;
  try
    Tmp.Name := AvailableName;
    Result := Items[Add(Tmp)];
  finally
    Tmp.Free;
  end;
end;

function TProjectConfigurationList.AvailableName: string;
var
  I: Integer;
begin
  if (Count = 0) then
    Result := DEFAULT_CONFIG_NAME
  else
  begin
    I := 1;
    while IndexOf(Format(NEW_CONFIG_FORMAT, [I])) >= 0 do
      Inc(I);
    Result := Format(NEW_CONFIG_FORMAT, [I]);
  end;
end;

procedure TProjectConfigurationList.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Delete(I);
end;

constructor TProjectConfigurationList.Create;
begin
  FConfigurations := TList.Create;
end;

procedure TProjectConfigurationList.Delete(Index: Integer);
begin
  NotifyDelete(Items[Index]);
  Items[Index].Free;
  FConfigurations.Delete(Index);
end;

destructor TProjectConfigurationList.Destroy;
begin
  Clear;
  FConfigurations.Free;
  inherited;
end;

procedure TProjectConfigurationList.Put(Index: Integer;
  const Value: TProjectConfiguration);
var
  I: Integer;
begin
  I := IndexOf(Value.Name);
  if (Index <> I) and (I >= 0)then
    raise Exception.Create('Configuration name must be unique');
  Items[Index].Assign(Value);
  NotifyChange(Items[Index]);
end;

function TProjectConfigurationList.Get(Index: Integer): TProjectConfiguration;
begin
  Result := TProjectConfiguration(FConfigurations[Index]);
end;

function TProjectConfigurationList.GetCount: Integer;
begin
  Result := FConfigurations.Count;
end;

function TProjectConfigurationList.IndexOf(const Name: string): Integer;
begin
  for Result := 0 to Count - 1 do
  begin
    if SameText(Items[Result].Name, Name) then
      Exit;
  end;
  Result := -1;
end;

procedure TProjectConfigurationList.Move(Index, Offset: Integer);
begin
  if (Index + Offset < 0) or (Index + Offset >= Count) then
    raise Exception.Create('Can''t move configuration, invalid offset');
  FConfigurations.Move(Index, Index + Offset);
end;

procedure TProjectConfigurationList.NotifyAdd(
  Configuration: TProjectConfiguration);
begin
  if Assigned(FOnAdd) then
    FOnAdd(Self, Configuration);
end;

procedure TProjectConfigurationList.NotifyChange(
  Configuration: TProjectConfiguration);
begin
  if Assigned(FOnChange) then
    FOnChange(Self, Configuration);
end;

procedure TProjectConfigurationList.NotifyDelete(
  Configuration: TProjectConfiguration);
begin
  if Assigned(FOnDelete) then
    FOnDelete(Self, Configuration);
end;

function TProjectConfigurationList.Add(Configuration: TProjectConfiguration): Integer;
var
  Index: Integer;
  NewConfig: TProjectConfiguration;
begin
  Index := IndexOf(Configuration.Name);
  if Index = -1 then
  begin
    NewConfig := TProjectConfiguration.Create; // Handle own objects
    NewConfig.Assign(Configuration);
    Result := FConfigurations.Add(NewConfig);
    NotifyAdd(Items[Result]);
  end
  else
  begin
    Items[Index] := Configuration;
    Result := Index;
  end;
end;

end.

