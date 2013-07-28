unit USourceFile;

interface

uses
  Windows, SysUtils, Forms, Graphics, Classes, Dialogs,
  Menus, ComCtrls, Controls, ShellApi,
  SynEdit, SynEditEx, XMLDoc, XMLIntf, SynEditHighlighter, SynEditKeyCmds,
  Makefile, Breakpoint, UTemplates, ModernTabs, SynEditMiscClasses,
  SynEditCodeFolding;

const
  FILE_TYPE_PROJECT = 1;
  FILE_TYPE_C = 2;
  FILE_TYPE_CPP = 3;
  FILE_TYPE_H = 4;
  FILE_TYPE_RC = 5;
  FILE_TYPE_UNKNOW = 6;
  FILE_TYPE_FOLDER = 7;

  SHEET_TYPE_FILE = 1;
  SHEET_TYPE_DESGN = 2;

  FILE_IMG_LIST: array[1..7] of Integer = (1, 2, 3, 4, 5, 6, 0);

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

  NEW_LINE = #13 + #10;
  LD_COMMAND = '-Wl';
  LD_OPTION_KILL_AT = '--kill-at';
  LD_OPTION_OUT_LIB = '--out-implib';
  LD_DLL_STATIC_LIB = LD_COMMAND + ',' + LD_OPTION_KILL_AT + ',' +
    LD_OPTION_OUT_LIB + ',%slib%s';
type
  TVersionInfo = class
    Major: Integer;
    Minor: Integer;
    Release: Integer;
    Build: Integer;
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
  end;

  TSourceFileSheet = class;
  TProjectFile = class;
  TSourceBase = class;
  TSourceDeletionEvent = procedure(Source: TSourceBase) of object;
  TSourceRenameEvent = procedure(Source: TSourceBase;
    const NewFileName: string) of object;

  TSourceBase = class(TInterfacedObject)
  private
    FFileName: string;
    FFileType: Integer;
    FNode: TTreeNode;
    FProject: TProjectFile;
    FSaved: Boolean;
    FIsNew: Boolean;
    FReadOnly: Boolean;
    FOnDeletion: TSourceDeletionEvent;
    FOnRename: TSourceRenameEvent;
  protected
    procedure SetProject(Value: TProjectFile); virtual;
    procedure SetFileType(Value: Integer); virtual;
    function GetName: string; virtual;
    function IsModified: Boolean; virtual;
    function GetFileName: string; virtual;
    procedure SetFileName(Value: string); virtual;
    procedure DoRename(const OldFileName: string); virtual;
  public
    constructor Create(Node: TTreeNode);
    procedure Assign(Value: TSourceBase);
    procedure Save; virtual;
    procedure DeleteOfDisk; virtual;
    procedure Delete; virtual;
  published
    property Project: TProjectFile read FProject write SetProject;
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
  end;

  TSourceFile = class(TSourceBase)
  private
    FFileDateTime: TDateTime;
    FSheet: TSourceFileSheet;
    FBreakpoint: TBreakpointList;
    function GetCaption: string;
  protected
    procedure SetProject(Value: TProjectFile); override;
    procedure SetFileType(Value: Integer); override;
    function GetName: string; override;
    function IsModified: Boolean; override;
    function GetFileName: string; override;
    procedure SetFileName(Value: string); override;
  public
    procedure MoveFileTo(const Path: string);
    procedure CopyFileTo(const Path: string);
    procedure DeleteOfDisk; override;
    procedure Delete; override;
    procedure Save; override;
    procedure Close;
    function Open: Boolean;
    function Edit(SelectTab: Boolean = True): TSourceFileSheet;
    function Editing: Boolean;
    function ViewPage: Boolean;
    procedure Rename(NewName: string);
    procedure LoadFile(Text: TStrings);
    procedure GetSubFiles(List: TStrings);
    function GetSheet(var Sheet: TSourceFileSheet): Boolean;
    function FindFile(const Name: string; var FileProp: TSourceFile): Boolean;
    function FileChangedInDisk: Boolean;
    procedure Reload;
    procedure UpdateDate;
    procedure Assign(Value: TSourceFile);
    constructor Create(Node: TTreeNode);
    destructor Destroy; override;
    property Breakpoint: TBreakpointList read FBreakpoint;
    property DateOfFile: TDateTime read FFileDateTime write FFileDateTime;
  published
    property Caption: string read GetCaption;
  end;

  IContainer = interface
  end;

  TProjectBase = class(TSourceFile)
  private
    FTargetDateTime: TDateTime;
    FLibs: string;
    FTemplateResources: TTemplateID;
    FFlags: string;
    FCompOpt: string;
    FTarget: string;
    FCompilerPath: string;
    FCmdLine: string;
    FDelObjPrior: Boolean;
    FDelObjAfter: Boolean;
    FDelMakAfter: Boolean;
    FDelResAfter: Boolean;
    FIncludeInfo: Boolean;
    FEnableTheme: Boolean;
    FRequiresAdmin: Boolean;
    FCompiled: Boolean;
    FAppType: Integer;
    FCompilerType: Integer;
    FIconFileName: string;
    FIcon: TIcon;
    FAutoIncBuild: Boolean;
    FPropertyChanged: Boolean;
    FSomeFileChanged: Boolean;
    FCompilerPropertyChanged: Boolean;
    FDebugging: Boolean;
    FVersion: TVersionInfo;
    FBreakpointChanged: Boolean;
    FBreakpointCursor: TBreakpoint;
    FForceClean: Boolean; //for header changes
    procedure SetIcon(Value: TIcon);
  public
    property TemplateResources: TTemplateID read FTemplateResources
      write FTemplateResources;
    property Version: TVersionInfo read FVersion;
    property BreakpointCursor: TBreakpoint read FBreakpointCursor;
    constructor Create(Node: TTreeNode);
    destructor Destroy; override;
    function GetResource(Res: TStrings): Boolean;
    procedure GetFiles(List: TStrings; AllTypes: Boolean = False;
      WithBreakpoint: Boolean = False);
    procedure Build; virtual;
    procedure SaveAs(const FileName: string); virtual;
    function NeedBuild: Boolean; virtual;
    function GetTarget: string;
    function TargetChanged: Boolean;
    function GetBreakpointLists(List: TStrings): Boolean;
    function HasBreakpoint: Boolean;
  published
    property ForceClean: Boolean read FForceClean write FForceClean;
    property Debugging: Boolean read FDebugging write FDebugging;
    property Libs: string read FLibs write FLibs;
    property Flags: string read FFlags write FFlags;
    property CompilerOptions: string read FCompOpt write FCompOpt;
    property Target: string read FTarget write FTarget;
    property CompilerPath: string read FCompilerPath write FCompilerPath;
    property CmdLine: string read FCmdLine write FCmdLine;
    property Compiled: Boolean read FCompiled write FCompiled;
    property TargetDateTime: TdateTime read FTargetDateTime write FTargetDateTime;
    property AutoIncBuild: Boolean read FAutoIncBuild write FAutoIncBuild;
    property PropertyChanged: Boolean read FPropertyChanged write FPropertyChanged;
    property SomeFileChanged: Boolean read FSomeFileChanged write FSomeFileChanged;
    property BreakpointChanged: Boolean read FBreakpointChanged write FBreakpointChanged;
    property CompilePropertyChanged: Boolean read FCompilerPropertyChanged
      write FCompilerPropertyChanged;
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

  TProjectSource = class(TProjectBase);
  TProjectFile = class(TProjectBase, IContainer)
  private
    procedure UpdateTarget(Value: string);
  protected
    function GetFileName: string; override;
    procedure SetFileName(Value: string); override;
  public
    function ConvertToSourceFile(Project: TProjectFile): TSourceFile;
    function GetFileByPathName(const RelativeName: string): TSourceFile;
    function SearchFile(const Name: string): TSourceFile;
    procedure LoadFromFile(const FileName: string);
    procedure LoadLayout;
    procedure SaveLayout;
    procedure SaveToFile(const FileName: string);
    procedure Save; override;
    procedure MoveSavedFilesTo(const Path: string);
    procedure CopySavedFilesTo(const Path: string);
    procedure SaveAs(const FileName: string); override;
    function NeedBuild: Boolean; override;
    function FilesChanged: Boolean;
    procedure SaveAll;
    procedure CloseAll;
    procedure Build; override;
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
    FSynMemo: TSynEditEx;
    FSourceFile: TSourceFile;
    procedure TextEditorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    class procedure UpdateEditor(SynMemo: TSynEditEx);
    constructor CreateEditor(SourceFile: TSourceFile; PageCtrl: TModernPageControl;
      SelectTab: Boolean = True);
    destructor Destroy; override;
    property Memo: TSynEditEx read FSynMemo;
    property SourceFile: TSourceFile read FSourceFile;
  end;

  EFileMoveError = class(Exception);

implementation

uses UFrmMain, UUtils, UConfig, TokenFile, TokenList, TokenUtils;

const
  fileMoveError = 'Can''t move file ''%s'' to ''%s.''';
  fileRenameError = 'Can''t rename file ''%s'' to ''%s.''';
  fileOverrideError = 'Can''t override existing file "%s".';

{ TSourceBase }

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
end;

constructor TSourceBase.Create(Node: TTreeNode);
begin
  FNode := Node;
  FFileType := FILE_TYPE_UNKNOW;
  FIsNew := True;
end;

procedure TSourceBase.Delete;
begin
  if Assigned(fOnDeletion) then
    fOnDeletion(Self);
  FNode.Delete;
  Free;
end;

procedure TSourceBase.DeleteOfDisk;
begin
  Delete;
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

function TSourceBase.IsModified: Boolean;
begin
  Result := not FSaved;
end;

procedure TSourceBase.Save;
begin
end;

procedure TSourceBase.SetFileName(Value: string);
var
  OldFileName, OldName: string;
begin
  if FFileName <> Value then
  begin
    OldFileName := FileName;
    OldName := Name;
    FFileName := Value;
    if OldName <> '' then
      DoRename(OldFileName);
  end;
end;

procedure TSourceBase.SetFileType(Value: Integer);
begin
  if FFileType <> Value then
    FFileType := Value;
end;

procedure TSourceBase.SetProject(Value: TProjectFile);
begin
  if FProject <> Value then
    FProject := Value;
end;

{ TSourceFile }

constructor TSourceFile.Create(Node: TTreeNode);
begin
  inherited Create(Node);
  FBreakpoint := TBreakpointList.Create;
  FBreakpoint.ImageList := FrmFalconMain.ImageListGutter;
  FBreakpoint.ImageIndex := 2;
  FBreakpoint.InvalidIndex := 3;
end;

destructor TSourceFile.Destroy;
begin
  FBreakpoint.Free;
  inherited Destroy;
end;

function TSourceFile.GetName: string;
begin
  if Self is TProjectFile then
  begin
    if FileType = FILE_TYPE_PROJECT then
      Result := ExtractName(FFileName)
    else
      Result := ExtractFileName(FFileName);
  end
  else
    Result := FFileName;
end;

function TSourceFile.GetCaption: string;
begin
  if IsModified then
    Result := '*' + Name
  else
    Result := Name;
end;

procedure TSourceFile.DeleteOfDisk;
begin
  if (FFileType <> FILE_TYPE_FOLDER) then
  begin
    if FileExists(FileName) then
    begin
      DeleteFile(FileName);
      Delete;
    end
    else
      Delete;
  end
  else
  begin
    if DirectoryExists(FileName) then
    begin
      RemoveDir(FileName);
      Delete;
    end
    else
      Delete;
  end;
end;

procedure TSourceFile.Delete;
var
  I: Integer;
begin
  if (FileType = FILE_TYPE_FOLDER) or (FileType = FILE_TYPE_PROJECT) then
  begin
    for I := Node.Count - 1 downto 0 do
      TSourceFile(Node.Item[I].Data).Delete;
  end;
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
  if (FileType = FILE_TYPE_FOLDER) then
    Exit;

  if FileExists(FileName) and Saved then
  begin
    FileDate := FileDateTime(FileName);
    Result := (FileDate <> FFileDateTime);
  end;
end;

procedure TSourceFile.Reload;
var
  sheet: TSourceFileSheet;
begin
  if (FileType = FILE_TYPE_FOLDER) then
    Exit;
  if FileExists(FileName) and Saved then
  begin
    if GetSheet(sheet) then
      LoadFile(sheet.Memo.Lines);
    UpdateDate;
  end;
end;

procedure TSourceFile.UpdateDate;
var
  FileDate: TDateTime;
begin
  if (FileType = FILE_TYPE_FOLDER) then
    Exit;
  if FileExists(FileName) and Saved then
  begin
    FileDate := FileDateTime(FileName);
    FFileDateTime := FileDate;
  end;
end;

function TSourceFile.FindFile(const Name: string;
  var FileProp: TSourceFile): Boolean;
var
  I: Integer;
  fp: TSourceFile;
begin
  Result := False;
  for I := 0 to Node.Count - 1 do
  begin
    fp := TSourceFile(Node.Item[I].Data);
    if CompareText(fp.Name, Name) = 0 then
    begin
      FileProp := fp;
      Result := True;
      Exit;
    end;
  end;
end;

function TSourceFile.GetFileName: string;
var
  Parent: TSourceFile;
begin
  Parent := TSourceFile(Node.Parent.Data);
  if (FileType = FILE_TYPE_FOLDER) then
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(Parent.FileName) + FFileName)
  else
    Result := ExtractFilePath(Parent.FileName) + FFileName;
  if Pos('..', Result) > 0 then
    Result := ExpandFileName(Result);
end;

procedure TSourceFile.Assign(Value: TSourceFile);
begin
  inherited Assign(Value);
  FFileDateTime := Value.FFileDateTime;
  FSheet := Value.FSheet;
  FBreakpoint.Assign(Value.FBreakpoint);
end;

procedure TSourceFile.SetProject(Value: TProjectFile);
begin
  if (Value <> FProject) then
    FProject := Value;
end;

procedure TSourceFile.SetFileName(Value: string);
var
  Temp: string;
  Sheet: TSourceFileSheet;
begin
  if (Name = Value) or (Value = '') then
    Exit;
  if (FileType <> FILE_TYPE_FOLDER) then
  begin
    { ***   PROJECT or FILE   *** }
    if FileExists(FileName) and Saved then
    begin
      Temp := ExtractFilePath(FileName) + ExtractFileName(Value);
      if not RenameFile(FileName, Temp) then
        raise Exception.CreateFmt(fileRenameError, [FileName, Temp]);
      FrmFalconMain.RenameFileInHistory(FileName,
        ExtractFilePath(FileName) + ExtractFileName(Value));
    end;
  end
  else
  begin
    Temp := Name;
    if Value <> Temp then
    begin
      if DirectoryExists(FileName) and (Temp <> '') then
      begin
        if not RenameFile(FileName,
          ExtractFilePath(ExcludeTrailingPathDelimiter(FileName)) + Value) then
          Exit;
      end;
    end;
  end;
  inherited SetFileName(Value);
  Node.Text := Name;
  if GetSheet(Sheet) then
    Sheet.Caption := Caption;
end;

procedure TSourceFile.SetFileType(Value: Integer);
var
  Sheet: TSourceFileSheet;
begin
  FFileType := Value;
  if Assigned(Node) then
  begin
    Node.ImageIndex := FILE_IMG_LIST[FileType];
    Node.SelectedIndex := FILE_IMG_LIST[FileType];
    if GetSheet(Sheet) then
    begin
      Sheet.ImageIndex := FILE_IMG_LIST[FileType];
      case FileType of
        FILE_TYPE_C..FILE_TYPE_H: Sheet.Memo.Highlighter := FrmFalconMain.CppHighligher;
        FILE_TYPE_RC: Sheet.Memo.Highlighter := FrmFalconMain.ResourceHighlighter;
      end;
    end;
  end;
end;

function TSourceFile.Edit(SelectTab: Boolean): TSourceFileSheet;
var
  Sheet: TSourceFileSheet;
begin
  if GetSheet(Sheet) then
  begin
    Result := Sheet;
    ViewPage;
    if Sheet.Memo.Showing then
      Sheet.Memo.SetFocus;
    Exit;
  end;
  Sheet := TSourceFileSheet.CreateEditor(Self, FrmFalconMain.PageControlEditor, SelectTab);
  Sheet.Caption := Caption;
  Sheet.ImageIndex := FILE_IMG_LIST[FileType];
  case FileType of
    FILE_TYPE_C..FILE_TYPE_H, FILE_TYPE_UNKNOW: Sheet.Memo.Highlighter := FrmFalconMain.CppHighligher;
    FILE_TYPE_RC: Sheet.Memo.Highlighter := FrmFalconMain.ResourceHighlighter;
  end;
  if Saved then
    LoadFile(Sheet.Memo.Lines);
  FrmFalconMain.PageControlEditor.Show;
  if FrmFalconMain.Showing and Sheet.Memo.Showing then
    Sheet.Memo.SetFocus;
  FrmFalconMain.PageControlEditorChange(FrmFalconMain.PageControlEditor);
  FrmFalconMain.EditorBeforeCreate(Self);
  Sheet.Memo.OnChange(Sheet.Memo);
  Result := Sheet;
end;

function TSourceFile.Open: Boolean;
begin
  Result := False;
  if (FFileType = FILE_TYPE_FOLDER) then
  begin
    if DirectoryExists(FileName) then
      ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOW);
  end
  else
  begin
    if FileExists(FileName) then
      OpenFolderAndSelectFile(FileName);
  end;
end;

procedure TSourceFile.Rename(NewName: string);
var
  OldName: string;
begin
  OldName := FileName;
  SetFileName(NewName);
  if OldName <> FileName then
  begin
    Project.CompilePropertyChanged := True;
    Project.PropertyChanged := True;
  end;
end;

procedure TSourceFile.LoadFile(Text: TStrings);
begin
  if (FSheet <> nil) and (FSheet.Memo.Lines = Text) then
    FSheet.Memo.LockFoldUpdate;
  Text.LoadFromFile(FileName);
  if (FSheet <> nil) and (FSheet.Memo.Lines = Text) then
    FSheet.Memo.UnlockFoldUpdate;
end;

procedure TSourceFile.GetSubFiles(List: TStrings);

  procedure GetSubFiles(Folder: TSourceFile);
  var
    I: Integer;
  begin
    for I := 0 to Folder.Node.Count - 1 do
    begin
      if TSourceFile(Folder.Node.Item[I].Data).FileType = FILE_TYPE_FOLDER then
        GetSubFiles(TSourceFile(Folder.Node.Item[I].Data))
      else if TSourceFile(Folder.Node.Item[I].Data).FileType <> FILE_TYPE_RC then
        List.AddObject(TSourceFile(Folder.Node.Item[I].Data).FileName,
          TSourceFile(Folder.Node.Item[I].Data));
    end;
  end;

begin
  if FileType <> FILE_TYPE_FOLDER then
    Exit;
  GetSubFiles(Self);
end;

function TSourceFile.GetSheet(var Sheet: TSourceFileSheet): Boolean;
begin
  Result := FSheet <> nil;
  if Result then
    Sheet := FSheet;
end;

function TSourceFile.ViewPage: Boolean;
var
  Sheet: TSourceFileSheet;
begin
  Result := False;
  if GetSheet(Sheet) then
  begin
    if (Sheet.PageIndex <> FrmFalconMain.PageControlEditor.ActivePageIndex) then
      FrmFalconMain.PageControlEditor.ActivePageIndex := Sheet.PageIndex;
    Result := True;
  end;
end;

function TSourceFile.Editing: Boolean;
begin
  Result := FSheet <> nil;
end;

function TSourceFile.IsModified: Boolean;
var
  FileDate: TDateTime;
  Sheet: TSourceFileSheet;
  ProjProp: TProjectFile;
  FModified: Boolean;
begin
  if (FileType = FILE_TYPE_FOLDER) then
  begin
    FModified := not DirectoryExists(FileName);
    Result := FModified;
    Exit;
  end;
  if FileType = FILE_TYPE_PROJECT then
  begin
    ProjProp := TProjectFile(Self);
    Result := ProjProp.PropertyChanged or ProjProp.FileChangedInDisk or
      ProjProp.SomeFileChanged;
    Exit;
  end;
  //modification in text
  if GetSheet(Sheet) then
    FModified := Sheet.Memo.Modified
  else
    FModified := False;
  //don't need more verify
  if FModified then
  begin
    Result := True;
    Exit;
  end;
  //if verify if file exist and if date are equals
  if (Saved or FileExists(FileName)) and not IsNew then
  begin
    FModified := not FileExists(FileName);
    if not FModified then
    begin
      FileDate := FileDateTime(FileName);
      FModified := (FileDate <> FFileDateTime);
    end;
  end;
  //set project modified?
  //if FModified then
  //  Project.Modified := True;
  Result := FModified;
end;

procedure TSourceFile.Close;
var
  Sheet: TSourceFileSheet;
begin
  if GetSheet(Sheet) then
  begin
    if (Sheet.PageIndex = FrmFalconMain.PageControlEditor.PageCount - 1)
      and (Sheet.PageIndex > 0) then
      FrmFalconMain.PageControlEditor.ActivePageIndex := Sheet.PageIndex - 1;
    Sheet.Free;
    if not (FrmFalconMain.PageControlEditor.PageCount > 0) then
      FrmFalconMain.PageControlEditor.Hide;
  end;
end;

procedure TSourceFile.Save;
var
  Sheet: TSourceFileSheet;
begin
  if (FileType = FILE_TYPE_FOLDER) then
  begin
    if not DirectoryExists(FileName) then
    begin
      if TSourceBase(Node.Parent.Data).FileType = FILE_TYPE_FOLDER then
        TSourceBase(Node.Parent.Data).Save;
      CreateDir(FileName);
    end;
    if not FSaved then
      FSaved := True;
    Exit;
  end;
  if (FileType <> FILE_TYPE_FOLDER) and (not FSaved or Modified or
    not FileExists(FileName) or FileChangedInDisk) then
  begin
    if not FSaved and FileExists(FileName) and GetSheet(Sheet) then
    begin
      if not FrmFalconMain.ShowPromptOverrideFile(FileName) then
        raise Exception.CreateFmt(fileOverrideError, [FileName]);
    end;
    // save parent folder
    if (Node.Parent <> nil) and (TSourceBase(Node.Parent.Data).FileType = FILE_TYPE_FOLDER) then
      TSourceBase(Node.Parent.Data).Save;
    Project.Compiled := False;
    if GetSheet(Sheet) then
    begin
      Sheet.Memo.UnCollapsedLines.SaveToFile(FileName);
      if sheet.Memo.Modified and not Project.Saved and IsNew then
        Project.SomeFileChanged := True;
      sheet.Memo.Modified := False;
    end // create empty file
    else if not FileExists(FileName) then
    begin
      with TStringList.Create do
      begin
        SaveToFile(FileName);
        Free;
      end;
    end;
    if not FSaved then
      FSaved := True;
    if not Project.IsNew and Project.Saved then
      IsNew := False;
    FFileDateTime := FileDateTime(FileName);
  end;
  //update main form
  with FrmFalconMain do
  begin
    if GetSheet(Sheet) then
    begin
      if Config.Editor.HighligthCurrentLine then
        Sheet.Memo.ActiveLineColor := Config.Editor.CurrentLineColor
      else
        Sheet.Memo.ActiveLineColor := clNone;
      UpdateMenuItems([rmFile]);
      Sheet.Caption := Self.Caption;
    end;
    if Node.Text <> Self.Name then
      Node.Text := Self.Name;
  end;
end;

procedure TSourceFile.MoveFileTo(const Path: string);
var
  FromFileName, ToFileName: string;
  I: Integer;
  SrcFile: TSourceFile;
begin
  ToFileName := ExtractRelativePath(FileName, Path) + Name;
  if ExtractFileDrive(ToFileName) = '' then
    ToFileName := ExtractFilePath(FileName) + ToFileName;
  ToFileName := ExpandFileName(ToFileName);
  FromFileName := ExcludeTrailingPathDelimiter(FileName);
  if FromFileName = ToFileName then
    Exit;
  if RenameFile(FromFileName, ToFileName) then
    Exit;
  if (FileType = FILE_TYPE_FOLDER) then
  begin
    CreateDir(ToFileName);
    for I := 0 to Node.Count - 1 do
    begin
      SrcFile := TSourceFile(Node.Item[I].Data);
      if SrcFile.Saved then
        SrcFile.MoveFileTo(ToFileName + '\');
    end;
    RemoveDir(FromFileName);
  end
  else
    raise EFilerError.CreateFmt(filemoveError, [FromFileName, ToFileName]);
end;

procedure TSourceFile.CopyFileTo(const Path: string);
var
  FromFileName, ToFileName: string;
  I: Integer;
  SrcFile: TSourceFile;
  Sheet: TSourceFileSheet;
begin
  ToFileName := ExtractRelativePath(FileName, Path) + Name;
  if ExtractFileDrive(ToFileName) = '' then
    ToFileName := ExtractFilePath(FileName) + ToFileName;
  ToFileName := ExpandFileName(ToFileName);
  FromFileName := ExcludeTrailingPathDelimiter(FileName);
  if FromFileName = ToFileName then
    Exit;
  if FileType = FILE_TYPE_FOLDER then
  begin
    CreateDir(ToFileName);
    for I := 0 to Node.Count - 1 do
    begin
      SrcFile := TSourceFile(Node.Item[I].Data);
      if SrcFile.Saved then
        SrcFile.CopyFileTo(Path + Name + '\');
    end;
  end
  else
  begin
    if GetSheet(Sheet) then
    begin
      Sheet.Memo.UnCollapsedLines.SaveToFile(ToFileName);
      if sheet.Memo.Modified and not Project.Saved and IsNew then
        Project.SomeFileChanged := True;
      sheet.Memo.Modified := False;
      if not FSaved then
        FSaved := True;
      FFileDateTime := FileDateTime(ToFileName);
    end
    else
    begin
      if FileExists(ToFileName) then
      begin
        if not FrmFalconMain.ShowPromptOverrideFile(FileName) then
          raise Exception.CreateFmt(fileOverrideError, [FileName]);
      end;
      if CopyFile(PChar(FromFileName), PChar(ToFileName), FALSE) = FALSE then
        raise Exception.CreateFmt(fileOverrideError, [ToFileName]);
    end;
  end;
end;

{TProjectBase}

constructor TProjectBase.Create(Node: TTreeNode);
begin
  inherited Create(Node);
  FForceClean := False;
  FVersion := TVersionInfo.Create;
  FVersion.LanguageID := GetSystemDefaultLangID;
  FVersion.CharsetID := $04E4;
  FBreakpointCursor := TBreakpoint.Create;
  FBreakpointCursor.Valid := False;
  FFileType := FILE_TYPE_PROJECT;
  FDelObjPrior := True;
  FDelObjAfter := True;
  FDelMakAfter := True;
  FDelResAfter := True;
  FIcon := nil;
  FCompiled := False;
  FCompilerType := COMPILER_CPP;
  FPropertyChanged := False;
  FCompilerPropertyChanged := False;
  FCompilerPath := '$(MINGW_PATH)';
end;

destructor TProjectBase.Destroy;
begin
  if Assigned(FTemplateResources) then
    FTemplateResources.Free;
  if Assigned(FIcon) then
    FIcon.Free;
  FBreakpointCursor.Free;
  FVersion.Free;
  inherited Destroy;
end;

procedure TProjectBase.SetIcon(Value: TIcon);
begin
  if (FIcon <> Value) then
    FIcon := Value;
end;

procedure TProjectBase.SaveAs(const FileName: string);
begin
end;

function TProjectBase.GetTarget: string;
begin
  Result := ExtractFilePath(FileName) + Target;
end;

function TProjectBase.NeedBuild: Boolean;
begin
  Result := FileChangedInDisk or not Compiled or not FileExists(GetTarget) or
    CompilePropertyChanged or TargetChanged or
    (BreakpointChanged and not Debugging) or (Debugging and not HasBreakpoint);
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

procedure TProjectBase.GetFiles(List: TStrings; AllTypes,
  WithBreakpoint: Boolean);

  procedure AddFiles(SrcFile: TSourceFile);
  var
    I: Integer;
    canAdd: Boolean;
  begin
    canAdd := (not (SrcFile.FileType in [FILE_TYPE_RC, FILE_TYPE_FOLDER]) and
      WithBreakpoint and (SrcFile.Breakpoint.Count > 0)) or not WithBreakpoint;

    if canAdd and (AllTypes or (SrcFile.FileType <> FILE_TYPE_FOLDER)) then
      List.AddObject(SrcFile.FileName, SrcFile);
    for I := 0 to SrcFile.Node.Count - 1 do
      AddFiles(TSourceFile(SrcFile.Node.Item[I].Data));
  end;

var
  I: Integer;
begin
  if (FileType = FILE_TYPE_PROJECT) then
  begin
    for I := 0 to Node.Count - 1 do
      AddFiles(TSourceFile(Node.Item[I].Data));
  end
  else
    AddFiles(Self);
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
  GetFiles(List, True);
  for I := 0 to List.Count - 1 do
  begin
    if (TSourceFile(List.Objects[I]).FFileType = FILE_TYPE_RC) then
    begin
      Result := True;
      Res.Add('#include "' + ExtractRelativePath(ExtractFilePath(FileName),
        TSourceFile(List.Objects[I]).FileName + '"'));
    end;
  end;
  List.Free;
  Manf := 0;
  if IncludeVersionInfo or Assigned(Icon) then
    Result := True;
  if EnableTheme and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
    Manf := Manf or 1;
  if RequiresAdmin and (AppType in [APPTYPE_CONSOLE, APPTYPE_GUI]) then
    Manf := Manf or 2;
  Result := Result or (Manf > 0);
  if Result then
  begin
    if Assigned(Res) then
    begin
      if Assigned(Icon) then
        Res.Add('MAINICON ICON AppIcon.ico');
      if Manf > 0 then
        Res.Add('1 24 AppManifest.dat');
      if IncludeVersionInfo then
      begin
        Res.Add('1 VERSIONINFO');
        Vers := IntToStr(FVersion.Major) + ',' +
          IntToStr(FVersion.Minor) + ',' +
          IntToStr(FVersion.Release) + ',' +
          IntToStr(FVersion.Build);
        Res.Add('    FILEVERSION ' + Vers);
        if (Length(FVersion.ProductVersion) = 0) then
          Res.Add('    PRODUCTVERSION ' + Vers)
        else
          Res.Add('    PRODUCTVERSION ' + StringReplace(FVersion.ProductVersion,
            '.', ',', [rfReplaceAll]));
        Res.Add('    FILEOS 0x4L');
        Res.Add('    FILETYPE 0x1L');
        Res.Add('BEGIN');
        Res.Add('    BLOCK "StringFileInfo"');
        Res.Add('    BEGIN');
        Res.Add('        BLOCK "' + IntToHex(FVersion.LanguageID, 4) +
          IntToHex(FVersion.CharsetID, 4) + '"');
        Res.Add('        BEGIN');
        Res.Add('            VALUE "CompanyName", "' + FVersion.CompanyName + '"');
        Res.Add('            VALUE "FileDescription", "' + FVersion.FileDescription + '"');
        Res.Add('            VALUE "FileVersion", "' + FVersion.FileVersion + '"');
        Res.Add('            VALUE "InternalName", "' + FVersion.InternalName + '"');
        Res.Add('            VALUE "LegalCopyright", "' + FVersion.LegalCopyright + '"');
        Res.Add('            VALUE "OriginalFilename", "' + FVersion.OriginalFilename + '"');
        Res.Add('            VALUE "ProductName", "' + FVersion.ProductName + '"');
        Res.Add('            VALUE "ProductVersion", "' + FVersion.ProductVersion + '"');
        Res.Add('        END');
        Res.Add('    END');
        Res.Add('    BLOCK "VarFileInfo"');
        Res.Add('    BEGIN');
        Res.Add('        VALUE "Translation", 0x' +
          IntToHex(FVersion.LanguageID, 4) + ', 0x' + IntToHex(FVersion.CharsetID, 4));
        Res.Add('    END');
        Res.Add('END');
      end;
    end;
  end;
end;

function TProjectBase.GetBreakpointLists(List: TStrings): Boolean;
var
  I: Integer;
  Files: TStrings;
  fprop: TSourceFile;
begin
  Files := TStringList.Create;
  GetFiles(Files, False, True);
  Result := Files.Count > 0;
  for I := 0 to Files.Count - 1 do
  begin
    fprop := TSourceFile(Files.Objects[I]);
    List.AddObject(Files.Strings[I], fprop.Breakpoint);
  end;
  Files.Free;
end;

function TProjectBase.HasBreakpoint: Boolean;
var
  Files: TStrings;
begin
  Files := TStringList.Create;
  GetFiles(Files, False, True);
  Result := Files.Count > 0;
  Files.Free;
end;

procedure TProjectBase.Build;
begin
end;

{TProjectFile}

procedure TProjectFile.CloseAll;
var
  I: Integer;
  AllFiles: TStrings;
begin
  AllFiles := TStringList.Create;
  GetFiles(AllFiles, True);
  for I := 0 to AllFiles.Count - 1 do
    TSourceFile(AllFiles.Objects[I]).Close;
  AllFiles.Free;
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
  if not (FileType = FILE_TYPE_PROJECT) then
  begin
    Save; //save .c or .cpp file
    Exit;
  end;
  //save all files with folders
  AllFiles := TStringList.Create;
  GetFiles(AllFiles, True);
  for I := 0 to AllFiles.Count - 1 do
    TSourceFile(AllFiles.Objects[I]).Save;
  AllFiles.Free;
  //save template resources
  if Assigned(FTemplateResources) then
  begin
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
end;

procedure TProjectFile.LoadFromFile(const FileName: string);

  function GetTagProperty(Node: IXMLNode; Tag, Attribute: string): string;
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp <> nil) then
      Result := Temp.Attributes[Attribute]
    else
      Result := '';
  end;

  procedure LoadFiles(XMLNode: IXMLNode; Parent: TSourceFile);
  var
    Temp: IXMLNode;
    NodeFileName: string;
    FileProp: TSourceFile;
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
          FileProp.DateOfFile := FileDateTime(NodeFileName);
          FileProp.Saved := True;
          FileProp.IsNew := False;
        end
        else
        begin
          { TODO -oMazin -c : file not found 24/08/2012 22:26:21 }
        end;
      end;
      Temp := Temp.NextSibling;
    end;
  end;

var
  XMLDoc: TXMLDocument;
  Node, ProjNode: IXMLNode;
  StrIcon, Temp: string;
  Stream: TStream;
begin
  IsNew := False;

  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  try
    XMLDoc.LoadFromFile(FileName);
  except
    //XMLDoc.Free;
    FTarget := ExtractName(FileName) + '.exe';
    FCompOpt := '-Wall -s';
    FDelObjPrior := True;
    FDelObjAfter := True;
    FDelMakAfter := True;
    FDelResAfter := True;
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

  //if tag version info exist
  Node := ProjNode.ChildNodes.FindNode('VersionInfo');
  if (Node <> nil) then
  begin
    IncludeVersionInfo := True;
    Version.Major := StrToIntDef(GetTagProperty(Node, 'VersionNumbers',
      'Major'), 0);
    Version.Minor := StrToIntDef(GetTagProperty(Node, 'VersionNumbers',
      'Minor'), 0);
    Version.Release := StrToIntDef(GetTagProperty(Node, 'VersionNumbers',
      'Release'), 0);
    Version.Build := StrToIntDef(GetTagProperty(Node, 'VersionNumbers',
      'Build'), 0);
    Version.LanguageID := StrToIntDef(GetTagProperty(Node, 'LanguageID',
      'Value'), GetSystemDefaultLangID);
    Version.CharsetID := StrToIntDef(GetTagProperty(Node, 'CharsetID',
      'Value'), $04E4);
    Version.CompanyName := GetTagProperty(Node, 'CompanyName', 'Value');
    Version.FileVersion := GetTagProperty(Node, 'FileVersion', 'Value');
    Version.FileDescription := GetTagProperty(Node, 'FileDescription', 'Value');
    Version.InternalName := GetTagProperty(Node, 'InternalName', 'Value');
    Version.LegalCopyright := GetTagProperty(Node, 'LegalCopyright', 'Value');
    Version.LegalTrademarks := GetTagProperty(Node, 'LegalTrademarks', 'Value');
    Version.OriginalFilename := GetTagProperty(Node, 'OriginalFilename',
      'Value');
    Version.ProductName := GetTagProperty(Node, 'ProductName', 'Value');
    Version.ProductVersion := GetTagProperty(Node, 'ProductVersion', 'Value');
    Temp := GetTagProperty(Node, 'AutoIncrementBuild', 'Value');
    FAutoIncBuild := HumanToBool(Temp);
  end
  else
  begin
    FAutoIncBuild := False;
    FIncludeInfo := False;
  end;

  FLibs := GetTagProperty(ProjNode, 'Libs', 'Value');
  FFlags := GetTagProperty(ProjNode, 'Flags', 'Value');
  FTarget := GetTagProperty(ProjNode, 'Target', 'Value');
  FCmdLine := GetTagProperty(ProjNode, 'CommandLine', 'Value');
  FCompOpt := GetTagProperty(ProjNode, 'CompilerOptions', 'Value');
  Temp := UpperCase(GetTagProperty(ProjNode, 'DeleteObjectsBefore', 'Value'));
  FDelObjPrior := HumanToBool(Temp);
  Temp := UpperCase(GetTagProperty(ProjNode, 'DeleteObjectsAfter', 'Value'));
  FDelObjAfter := HumanToBool(Temp);
  Temp := UpperCase(GetTagProperty(ProjNode, 'DeleteMakefileAfter', 'Value'));
  FDelMakAfter := HumanToBool(Temp);
  Temp := UpperCase(GetTagProperty(ProjNode, 'DeleteResourcesAfter', 'Value'));
  FDelResAfter := HumanToBool(Temp);
  Temp := UpperCase(GetTagProperty(ProjNode, 'EnableTheme', 'Value'));
  FEnableTheme := HumanToBool(Temp);
  Temp := UpperCase(GetTagProperty(ProjNode, 'RequiresAdmin', 'Value'));
  FRequiresAdmin := HumanToBool(Temp);
  FAppType := GetAppTypeByName(GetTagProperty(ProjNode, 'AppType', 'Value'));
  Temp := GetTagProperty(ProjNode, 'CompilerType', 'Value');
  if (UpperCase(Temp) = 'C') then
    FCompilerType := COMPILER_C
  else
    FCompilerType := COMPILER_CPP;

  //load files
  Node := ProjNode.ChildNodes.FindNode('Files');
  if (Node <> nil) then
    LoadFiles(Node, Self);
  //end load files

  Node := ProjNode.ChildNodes.FindNode('AppIcon');
  //if tag icon exist
  if (Node <> nil) then
  begin
    StrIcon := Node.Text;
    StrIcon := Union64(StrIcon);
    Stream := TMemoryStream.Create;
    StringToStream(StrIcon, Stream);
    Stream.Position := 0;
    FIcon := TIcon.Create;
    try
      FIcon.LoadFromStream(Stream);
    except
      FIcon.Free;
      FIcon := nil;
    end;
    Stream.Free;
  end
  else
    FIcon := nil;
  //XMLDoc.Free;
end;

function TProjectFile.GetFileByPathName(const RelativeName: string): TSourceFile;
var
  Temp, S: string;
  Parent: TSourceFile;
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
    if not Parent.FindFile(S, Parent) then
    begin
      Result := nil;
      Exit;
    end;
    Result := Parent;
  end;
end;

function TProjectFile.SearchFile(const Name: string): TSourceFile;

  function SearchFileRec(SrcFile: TSourceFile): TSourceFile;
  var
    I: Integer;
  begin
    Result := nil;
    if SrcFile.FileType <> FILE_TYPE_FOLDER then
    begin
      if CompareStr(Name, SrcFile.Name) = 0 then
        Result := SrcFile;
    end
    else
      for I := 0 to SrcFile.Node.Count - 1 do
      begin
        Result := SearchFileRec(TSourceFile(SrcFile.Node.Item[I].Data));
        if Result <> nil then
          Break;
      end;
  end;

var
  I: Integer;
begin
  Result := nil;
  if (FileType = FILE_TYPE_PROJECT) then
  begin
    for I := 0 to Node.Count - 1 do
    begin
      Result := SearchFileRec(TSourceFile(Node.Item[I].Data));
      if Result <> nil then
        Break;
    end;
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
  XMLDoc: TXMLDocument;
  Node, FoldersNode, FilesNode, LytNode: IXMLNode;
  Temp, S, LytFileName: string;
  TopIndex, TopLine, Tabpos: Integer;
  FileProp: TSourceFile;
  sheet: TSourceFileSheet;
  CaretXY, BlockS_or_E: TBufferCoord;
  //List: TStrings; //for unascendent layout file
begin
  LytFileName := ChangeFileExt(FileName, '.layout');
  if not FileExists(LytFileName) then
    Exit;
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
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
      if CompareText(Node.NodeName, 'File') = 0 then
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
        sheet := FileProp.Edit(False);
        Temp := Node.Attributes['Tabpos'];
        //start from last tab
        Tabpos := StrToIntDef(Temp, 1);
        if Tabpos < 1 then
          Tabpos := 1;
        //invalid tab position
        if Tabpos > GetPageCount then
        begin
          //organize after
          //List.addObject(IntToStr(Tabpos), FileProp ? sheet); comment line down
          Tabpos := GetPageCount;
        end;
        sheet.PageIndex := Tabpos - 1;
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
        sheet.Memo.CaretXY := CaretXY;
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
            sheet.Memo.BlockBegin := CaretXY;
            sheet.Memo.BlockEnd := BlockS_or_E;
          end
          else
          begin
            sheet.Memo.BlockBegin := BlockS_or_E;
            sheet.Memo.BlockEnd := CaretXY;
          end;
        end;
        Temp := Node.Attributes['TopLine'];
        TopLine := StrToIntDef(Temp, 1);
        if TopLine < 1 then
          TopLine := 1;
        sheet.Memo.TopLine := TopLine;
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
    if FrmFalconMain.GetActiveSheet(sheet) then
      sheet.Memo.SetFocus;
  //XMLDoc.Free;
end;

procedure TProjectFile.SaveLayout;

var
  pageIndex, FilesOpenCount, FoldersExpanded: Integer;
  FileList, FolderList: TStrings;

  procedure AddFile(const RelFileName: string; sheet: TSourceFileSheet);
  var
    I, Index, pi: Integer;
  begin
    Index := 0;
    for I := 0 to FileList.Count - 1 do
    begin
      pi := TSourceFileSheet(FileList.Objects[I]).PageIndex;
      if pi > sheet.PageIndex then
      begin
        Index := I;
        Break;
      end;
      if I = FileList.Count - 1 then
        Index := I + 1;
    end;
    FileList.InsertObject(Index, RelFileName, sheet)
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

  procedure AddFiles(Parent: TSourceFile);
  var
    I: Integer;
    FileProp: TSourceFile;
    ProjPath, RelFileName: string;
    sheet: TSourceFileSheet;
  begin
    ProjPath := ExtractFilePath(FileName);
    for I := 0 to Parent.Node.Count - 1 do
    begin
      FileProp := TSourceFile(Parent.Node.Item[I].Data);
      RelFileName := ExtractRelativePath(ProjPath, FileProp.FileName);
      if (FileProp.FileType = FILE_TYPE_FOLDER) then
      begin
        RelFileName := ExcludeTrailingPathDelimiter(RelFileName);
        if FileProp.Node.Expanded then
        begin
          Inc(FoldersExpanded);
          FolderList.AddObject(RelFileName, FileProp.Node);
        end;
        AddFiles(FileProp);
      end
      else if FileProp.GetSheet(sheet) then
      begin
        Inc(FilesOpenCount);
        AddFile(RelFileName, sheet);
      end;
    end;
  end;

var
  XMLDoc: TXMLDocument;
  Temp, Node, LytNode: IXMLNode;
  I: Integer;
  BoolStr: string;
  sheet: TSourceFileSheet;
begin
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
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
      sheet := TSourceFileSheet(FileList.Objects[I]);
      Temp := Node.AddChild('File');
      Temp.Attributes['Name'] := FileList.Strings[I];
      BoolStr := BoolToHuman(pageIndex = sheet.PageIndex);
      Temp.Attributes['Top'] := BoolStr;
      Temp.Attributes['Tabpos'] := IntToStr(sheet.PageIndex + 1);
      Temp.Attributes['TopLine'] := IntToStr(sheet.Memo.TopLine);
      SetTagProperty(Temp, 'Cursor', 'Line', IntToStr(sheet.Memo.CaretY));
      SetTagProperty(Temp, 'Cursor', 'Column', IntToStr(sheet.Memo.CaretX));
      if sheet.Memo.SelAvail then
      begin
        if (sheet.Memo.BlockBegin.Line = sheet.Memo.CaretXY.Line) and
          (sheet.Memo.BlockBegin.Char = sheet.Memo.CaretXY.Char) then
        begin
          SetTagProperty(Temp, 'Selection', 'Line', IntToStr(sheet.Memo.BlockEnd.Line));
          SetTagProperty(Temp, 'Selection', 'Column', IntToStr(sheet.Memo.BlockEnd.Char));
        end
        else
        begin
          SetTagProperty(Temp, 'Selection', 'Line', IntToStr(sheet.Memo.BlockBegin.Line));
          SetTagProperty(Temp, 'Selection', 'Column', IntToStr(sheet.Memo.BlockBegin.Char));
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
    //XMLDoc.Free;
    Exit;
  end;
  //XMLDoc.Free;
end;

procedure TProjectFile.SaveToFile(const FileName: string);

  procedure SetTagProperty(Node: IXMLNode; Tag, Attribute, Value: string);
  var
    Temp: IXMLNode;
  begin
    Temp := Node.ChildNodes.FindNode(Tag);
    if (Temp = nil) then
      Temp := Node.AddChild(Tag);
    Temp.Attributes[Attribute] := Value;
  end;

  procedure AddFiles(XMLNode: IXMLNode; Parent: TSourceFile);
  var
    Temp: IXMLNode;
    I: Integer;
    FileProp: TSourceFile;
  begin
    for I := 0 to Parent.Node.Count - 1 do
    begin
      FileProp := TSourceFile(Parent.Node.Item[I].Data);
      if (FileProp.FileType = FILE_TYPE_FOLDER) then
      begin
        Temp := XMLNode.AddChild('Folder');
        Temp.Attributes['Name'] := ExcludeTrailingPathDelimiter(FileProp.FFileName);
        AddFiles(Temp, FileProp);
      end
      else
      begin
        Temp := XMLNode.AddChild('File');
        Temp.Attributes['Name'] := FileProp.FFileName;
      end;
    end;
  end;

var
  XMLDoc: TXMLDocument;
  Node, ProjNode: IXMLNode;
  Temp: string;
  Stream: TStream;
begin
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  XMLDoc.Active := True;
  XMLDoc.Version := '1.0';
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.Encoding := 'UTF-8';
  XMLDoc.NodeIndentStr := #9;

  ProjNode := XMLDoc.AddChild('Project');

  if IncludeVersionInfo then
  begin
    Node := ProjNode.AddChild('VersionInfo');
    SetTagProperty(Node, 'VersionNumbers', 'Major', IntToStr(Version.Major));
    SetTagProperty(Node, 'VersionNumbers', 'Minor', IntToStr(Version.Minor));
    SetTagProperty(Node, 'VersionNumbers', 'Release',
      IntToStr(Version.Release));
    SetTagProperty(Node, 'VersionNumbers', 'Build', IntToStr(Version.Build));
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
    Temp := BoolToHuman(AutoIncBuild);
    SetTagProperty(Node, 'AutoIncrementBuild', 'Value', Temp);
  end;

  SetTagProperty(ProjNode, 'Libs', 'Value', Libs);
  SetTagProperty(ProjNode, 'Flags', 'Value', Flags);
  SetTagProperty(ProjNode, 'Target', 'Value', Target);
  SetTagProperty(ProjNode, 'CommandLine', 'Value', CmdLine);
  SetTagProperty(ProjNode, 'CompilerOptions', 'Value', CompilerOptions);
  Temp := BoolToHuman(DeleteObjsBefore);
  SetTagProperty(ProjNode, 'DeleteObjectsBefore', 'Value', Temp);
  Temp := BoolToHuman(DeleteObjsAfter);
  SetTagProperty(ProjNode, 'DeleteObjectsAfter', 'Value', Temp);
  Temp := BoolToHuman(DeleteMakefileAfter);
  SetTagProperty(ProjNode, 'DeleteMakefileAfter', 'Value', Temp);
  Temp := BoolToHuman(DeleteResourcesAfter);
  SetTagProperty(ProjNode, 'DeleteResourcesAfter', 'Value', Temp);
  Temp := BoolToHuman(EnableTheme);
  SetTagProperty(ProjNode, 'EnableTheme', 'Value', Temp);
  Temp := BoolToHuman(RequiresAdmin);
  SetTagProperty(ProjNode, 'RequiresAdmin', 'Value', Temp);
  SetTagProperty(ProjNode, 'CompilerType', 'Value', COMPILERS[CompilerType]);
  SetTagProperty(ProjNode, 'AppType', 'Value', APPTYPES[AppType]);

  //get files
  Node := ProjNode.AddChild('Files');
  AddFiles(Node, Self);
  //end get files

  //save application ico
  if Assigned(FIcon) then
  begin
    Node := ProjNode.AddChild('AppIcon');
    Stream := TMemoryStream.Create;
    FIcon.SaveToStream(Stream);
    Stream.Position := 0;
    Node.Text := Divide64(StreamToString(Stream));
    Stream.Free;
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
  if FileType <> FILE_TYPE_PROJECT then
  begin
    inherited;
    Exit;
  end;
  if not FSaved or (Modified or not FileExists(FileName) or FileChangedInDisk) then
  begin
    Compiled := False;
    PropertyChanged := False;
    SaveToFile(FileName);
    if not FSaved then
      FSaved := True;
    IsNew := False;
    FFileDateTime := FileDateTime(FileName);
    if Node.Text <> Name then
      Node.Text := Name;
  end;
end;

procedure TProjectFile.SaveAs(const FileName: string);
var
  OldFileName, OldName: string;
begin
  if CompareText(FileName, FFileName) <> 0 then
  begin
    if Saved and not Editing and FileExists(FFileName) then
    begin
      if IsNew then
        RenameFile(FFileName, FileName)
      else
        CopyFile(PChar(FFileName), PChar(FileName), FALSE);
    end;
    if IsNew then
      MoveSavedFilesTo(ExtractFilePath(FileName))
    else
      CopySavedFilesTo(ExtractFilePath(FileName));
    UpdateTarget(FileName);
    OldFileName := FFileName;
    OldName := Name;
    FFileName := FileName;
    if OldName <> '' then
      DoRename(OldFileName);
  end
  else if Saved and not IsModified and not IsNew then
    Exit;
  FIsNew := False;
  SaveAll;
  if FileType = FILE_TYPE_PROJECT then
    Save;
end;

function TProjectFile.NeedBuild: Boolean;
begin
  Result := inherited NeedBuild or FilesChanged;
end;

function TProjectFile.FilesChanged: Boolean;
var
  I: Integer;
  FileProp: TSourceFile;
  List: TStrings;
begin
  Result := False;
  List := TStringList.Create;
  GetFiles(List);
  for I := 0 to List.Count - 1 do
  begin
    FileProp := TSourceFile(List.Objects[I]);
    if FileProp.Modified or FileProp.FileChangedInDisk then
    begin
      Result := True;
      List.Free;
      Exit;
    end;
  end;
  List.Free;
end;

procedure TProjectFile.Build;

  procedure SaveManifest(AFileName, ResName: string);
  var
    EnbTheme: TStrings;
    Rs: TResourceStream;
  begin
    EnbTheme := TStringList.Create;
    Rs := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
    EnbTheme.LoadFromStream(Rs);
    Rs.Free;
    EnbTheme.SaveToFile(AFileName);
    EnbTheme.Free;
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
  try
    SaveAll;
  except
    Exit;
  end;
  if CompilerType in [COMPILER_CPP, COMPILER_C] then
  begin
    Files := TStringList.Create;
    GetFiles(Files);
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
      DeleteResourceFiles(Files);
      Files.Add(ExtractFilePath(FileName) + 'AppResource.rc');
      Res.SaveToFile(ExtractFilePath(FileName) + 'AppResource.rc');
    end;
    Res.Free;
    if HasResource or (FileType = FILE_TYPE_PROJECT) then
    begin
      ProjectDir := ExtractFilePath(FileName);
      IncludeList := TStringList.Create;
      GetIncludeDirs(ExtractFilePath(FileName), FFlags, IncludeList);
      for I := 0 to Files.Count - 1 do
      begin
        Includes := TStringList.Create;
        Files.Objects[I] := Includes;
        TokenFile := FrmFalconMain.FilesParsed.ItemOfByFileName(Files.Strings[I]);
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
      ExecParams := CompilerOptions;
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
      ExecParams := Trim(ExecParams + ' -L"$(MINGW_PATH)\lib" ' + Libs);
      ExecParams := Trim(ExecParams + ' -I"$(MINGW_PATH)\include" ' + Flags);
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
      mk.Flags := Flags;
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
        mk.CompilerOptions := RemoveOption('-O2', mk.CompilerOptions);
        mk.CompilerOptions := RemoveOption('-O3', mk.CompilerOptions);
      end;
      mk.CleanBefore := DeleteObjsBefore;
      mk.CleanAfter := DeleteObjsAfter;
      mk.Echo := True;
      MkRes := mk.BuildMakefile;
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

function TProjectFile.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TProjectFile.MoveSavedFilesTo(const Path: string);
var
  I: Integer;
  SrcFile: TSourceFile;
begin
  for I := 0 to Node.Count - 1 do
  begin
    SrcFile := TSourceFile(Node.Item[I].Data);
    if SrcFile.Saved then
      SrcFile.MoveFileTo(Path);
  end;
end;

procedure TProjectFile.CopySavedFilesTo(const Path: string);
var
  I: Integer;
  SrcFile: TSourceFile;
begin
  for I := 0 to Node.Count - 1 do
  begin
    SrcFile := TSourceFile(Node.Item[I].Data);
    if SrcFile.Saved then
      SrcFile.CopyFileTo(Path);
  end;
end;

procedure TProjectFile.UpdateTarget(Value: string);
begin
// update equal target
  if (AppType = APPTYPE_LIB) then
  begin
    if CompareText('lib' + ExtractName(FileName), ExtractName(Target)) = 0 then
    begin
      Target := 'lib' + ExtractName(Value) + ExtractFileExt(Target);
      PropertyChanged := True;
    end;
  end
  else
  begin
    if (Target <> '') and
      (CompareText(ExtractName(FileName), ExtractName(Target)) = 0) then
    begin
      Target := ExtractName(Value) + ExtractFileExt(Target);
      PropertyChanged := True;
    end;
  end;
end;

procedure TProjectFile.SetFileName(Value: string);
var
  Sheet: TSourceFileSheet;
  OldFileName, OldName: string;
begin
  if (CompareText(FileName, Value) = 0) or (Value = '') then
    Exit;
  if FileExists(FileName) then
  begin
    if not RenameFile(FileName, Value) then
      Exit;
    FrmFalconMain.RenameFileInHistory(FileName, Value);
  end;
  UpdateTarget(Value);
  MoveSavedFilesTo(ExtractFilePath(Value));
  OldFileName := FFileName;
  OldName := Name;
  FFileName := Value;
  if OldName <> '' then
    DoRename(OldFileName);
  Node.Text := Name;
  if GetSheet(Sheet) then
    Sheet.Caption := Caption;
end;

function TProjectFile.ConvertToSourceFile(Project: TProjectFile): TSourceFile;
var
  sheet: TSourceFileSheet;
begin
  Result := TSourceFile.Create(Node);
  Result.Assign(Self);
  Result.FFileName := ExtractFileName(FFileName);
  Result.FProject := Project;
  if GetSheet(sheet) then
    sheet.FSourceFile := Result;
end;

{TProjectsSheet}

constructor TProjectsSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListView := TListView.Create(Self);
  FListView.Parent := Self;
  FListView.Align := alClient;
  //FListView.BorderStyle := bsNone;
  FListView.DoubleBuffered := True;
  FListView.HideSelection := False;
  FListView.ReadOnly := True;
  FListView.IconOptions.AutoArrange := True;
end;

destructor TProjectsSheet.Destroy;
begin
  inherited Destroy;
end;

{TSourceFileSheet}

class procedure TSourceFileSheet.UpdateEditor(SynMemo: TSynEditEx);
var
  Options: TSynEditorOptions;
begin
  SynMemo.BeginUpdate;
  //FSynMemo.BorderStyle := bsNone;
  with FrmFalconMain.Config.Editor do
  begin
    Options := SYNEDIT_DEFAULT_OPTIONS;
    Include(Options, eoKeepCaretX);
    Include(Options, eoShowIndentGuides);
    //------------ General --------------------------//
    if AutoIndent then
      Include(Options, eoAutoIndent)
    else
      Exclude(Options, eoAutoIndent);
    //find text at cursor
    SynMemo.InsertMode := InsertMode;
    if GroupUndo then
      Include(Options, eoGroupUndo)
    else
      Exclude(Options, eoGroupUndo);
    //remove file on close
    if KeepTrailingSpaces then
      Exclude(Options, eoTabIndent)
    else
      Include(Options, eoTrimTrailingSpaces);
    if CursorPastEol then
      Include(Options, eoScrollPastEol)
    else
      Exclude(Options, eoScrollPastEol);
    if ScrollHint then
      Exclude(Options, eoShowScrollHint)
    else
      Include(Options, eoShowScrollHint);
    if TabIndentUnindent then
      Include(Options, eoTabIndent)
    else
      Exclude(Options, eoTabIndent);
    if SmartTabs then
      Include(Options, eoSmartTabs)
    else
      Exclude(Options, eoSmartTabs);
    if SmartTabs then
      Include(Options, eoSmartTabs)
    else
      Exclude(Options, eoSmartTabs);
    if UseTabChar then
      Exclude(Options, eoTabsToSpaces)
    else
      Include(Options, eoTabsToSpaces);
    if EnhancedHomeKey then
      Include(Options, eoEnhanceHomeKey)
    else
      Exclude(Options, eoEnhanceHomeKey);
    if ShowSpaceChars then
      Include(Options, eoShowSpaceChars)
    else
      Exclude(Options, eoShowSpaceChars);

    SynMemo.MaxUndo := MaxUndo;
    SynMemo.TabWidth := TabWidth;

    SynMemo.BracketHighlighting := HighligthMatchBraceParentheses;
    SynMemo.BracketHighlight.Foreground := NormalColor;
    SynMemo.BracketHighlight.AloneForeground := ErrorColor;
    SynMemo.BracketHighlight.Style := [fsBold];
    SynMemo.BracketHighlight.AloneStyle := [fsBold];
    SynMemo.BracketHighlight.Background := BgColor;

    if HighligthCurrentLine then
      SynMemo.ActiveLineColor := CurrentLineColor
    else
      SynMemo.ActiveLineColor := clNone;

    SynMemo.LinkEnable := LinkClick;
    SynMemo.LinkOptions.Color := LinkColor;

    //---------------- Display ---------------------//
    SynMemo.Font.Name := FontName;
    SynMemo.Font.Size := FontSize;
    SynMemo.Gutter.Width := GutterWidth;
    SynMemo.Gutter.Font.Size := FontSize;
    if ShowRightMargin then
      SynMemo.RightEdge := RightMargin
    else
      SynMemo.RightEdge := 0;
    SynMemo.Gutter.Visible := ShowGutter;
    SynMemo.Gutter.ShowLineNumbers := ShowLineNumber;
    SynMemo.Gutter.Gradient := GradientGutter;
    //-------------- Colors -------------------------//

    FrmFalconMain.SintaxList.Selected.UpdateEditor(SynMemo);
    //-------------- Code Resources -----------------//
    SynMemo.Options := Options;
  end;
  SynMemo.EndUpdate;
end;

constructor TSourceFileSheet.CreateEditor(SourceFile: TSourceFile;
  PageCtrl: TModernPageControl; SelectTab: Boolean);
begin
  inherited Create(PageCtrl);
  ParentBackground := False;
  FSourceFile := SourceFile;
  FSourceFile.FSheet := Self;
  FSheetType := SHEET_TYPE_FILE;
  FSynMemo := TSynEditEx.Create(Self);
  UpdateEditor(FSynMemo);
  FSynMemo.ReadOnly := SourceFile.ReadOnly;
  if SourceFile.ReadOnly then
    Font.Color := clGrayText;
  FSynMemo.Parent := Self;
  FSynMemo.Align := alClient;
  FSynMemo.WantTabs := True;
  FSynMemo.PopupMenu := FrmFalconMain.PopupEditor;
  FSynMemo.OnContextPopup := FrmFalconMain.EditorContextPopup;
  FSynMemo.SearchEngine := FrmFalconMain.EditorSearch;
  PageControl := PageCtrl;
  FrmFalconMain.CodeCompletion.Editor := FSynMemo;
  FrmFalconMain.AutoComplete.Editor := FSynMemo;
  FSynMemo.AddKey(ecAutoCompletion, Word('J'), [ssCtrl], 0, []);
  FSynMemo.OnChange := FrmFalconMain.TextEditorChange;
  FSynMemo.OnExit := FrmFalconMain.TextEditorExit;
  FSynMemo.OnEnter := FrmFalconMain.TextEditorEnter;
  FSynMemo.OnMouseLeave := FrmFalconMain.TextEditorMouseLeave;
  FSynMemo.OnStatusChange := FrmFalconMain.TextEditorStatusChange;
  FSynMemo.OnMouseDown := TextEditorMouseDown;
  FSynMemo.OnMouseMove := FrmFalconMain.TextEditorMouseMove;
  FSynMemo.OnLinkClick := FrmFalconMain.TextEditorLinkClick;
  FSynMemo.OnKeyDown := FrmFalconMain.TextEditorKeyDown;
  FSynMemo.OnKeyPress := FrmFalconMain.TextEditorKeyPress;
  FSynMemo.OnKeyUp := FrmFalconMain.TextEditorKeyUp;
  FSynMemo.OnGutterClick := FrmFalconMain.TextEditorGutterClick;
  FSynMemo.OnGutterPaint := FrmFalconMain.TextEditorGutterPaint;
  FSynMemo.OnSpecialLineColors := FrmFalconMain.TextEditorSpecialLineColors;
  FSynMemo.OnCommandProcessed := FrmFalconMain.TextEditorCommandProcessed;
  FSynMemo.OnScroll := FrmFalconMain.TextEditorScroll;
  // Initialise code folding
  with FSynMemo.CodeFolding do
  begin
    FSynMemo.BeginUpdate;
    CaseSensitive := True;
    FolderBarLinesColor := clGray;
    CollapsingMarkStyle := msSquare;
    with FoldRegions do
    begin
      Add(rtChar, False, False, False, '{', '}', nil);
      SkipRegions.Add('/*', '*/', '\', itMultiLineComment);
      SkipRegions.Add('//', '', '\', itSingleLineComment);
      SkipRegions.Add('"', '"', '\', itString);
      SkipRegions.Add('''', '''', '\', itString);
      //Add(rtKeyword, False, False, True, 'BEGIN', 'END', nil); //for resources
    end;
    Enabled := True;
    FSynMemo.EndUpdate;
  end;
  if SelectTab then
    PageCtrl.ActivePageIndex := PageIndex;
end;

procedure TSourceFileSheet.TextEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TBufferCoord;
begin
  if (Button = mbMiddle) then
  begin
    P := Memo.DisplayToBufferPos(Memo.PixelsToRowColumn(X, Y));
    if (P.Char > 0) and (P.Line > 0) and (Memo.CanPaste) then
    begin
      Memo.ExecuteCommand(ecGotoXY, #0, @P);
      Memo.PasteFromClipboard;
    end;
  end;
  FrmFalconMain.TextEditorMouseDown(Sender, Button, Shift, X, Y);
end;

destructor TSourceFileSheet.Destroy;
begin
  FSourceFile.FSheet := nil;
  inherited Destroy;
end;

end.

