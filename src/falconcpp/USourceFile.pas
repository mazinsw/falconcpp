unit USourceFile;

interface

uses
  Windows, SysUtils, IniFiles, Forms, Graphics, Classes, Dialogs,
  Menus, ComCtrls, Controls, Registry, ShellApi,
  SynMemo, SynEdit, XMLDoc, XMLIntf, SynEditHighlighter, SynEditKeyCmds,
  Makefile, Breakpoint, UTemplates, ModernTabs;

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

  staticLibStr = ' -Wl,--add-stdcall-alias,--out-implib,lib%s';

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
  TProjectProperty = class;

  TSourceFile = class
  private
    FFileDateTime: TDateTime;
    FFileName: string;
    FFileType: Integer;
    FEditor: TSynMemo;
    FNode: TTreeNode;
    FProject: TProjectProperty;
    FSaved: Boolean;
    FBreakpoint: TBreakpointList;
    function GetName: string;
    function GetCaption: string;
    function GetNode: TTreeNode;
    function GetEditor: TModernPageControl;
    function GetProject: TProjectProperty;
    function IsModified: Boolean;
    procedure SetProject(Value: TProjectProperty);
    procedure SetFileType(Value: Integer);
    procedure SetFileName(Value: string);
  protected
    function GetFileName: string; virtual;
  public
    function DeleteOfDisk: Boolean;
    function Delete: Boolean;
    function Edit(SelectTab: Boolean = True): TSourceFileSheet;
    function Editing: Boolean;
    function ViewPage: Boolean;
    function Rename(NewName: string): Boolean;
    procedure LoadFile(Text: TStrings);
    function GetSheet(var Sheet: TSourceFileSheet): Boolean;
    function Open: Boolean;
    function Close: Boolean;
    function Save: Boolean;
    function FindFile(const Name: string; var FileProp: TSourceFile): Boolean;
    function FileChangedInDisk: Boolean;
    procedure Reload;
    procedure UpdateDate;
    procedure Assign(Value: TSourceFile);
    constructor Create(Editor, Node: Pointer);
    destructor Destroy; override;
    property Breakpoint: TBreakpointList read FBreakpoint;
    property Project: TProjectProperty read GetProject write SetProject;
    property PageCtrl: TModernPageControl read GetEditor;
    property DateOfFile: TDateTime read FFileDateTime write FFileDateTime;
    property Node: TTreeNode read GetNode;
    property Modified: Boolean read IsModified;
  published
    property FileName: string read GetFileName write SetFileName;
    property Name: string read GetName;
    property Caption: string read GetCaption;
    property FileType: Integer read FFileType write SetFileType;
    property Saved: Boolean read FSaved write FSaved;
  end;

  TProjectProperty = class(TSourceFile)
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
    FCompilerPropertyChanged: Boolean;
    FDebugging: Boolean;
    FVersion: TVersionInfo;
    FBreakpointChanged: Boolean;
    FBreakpointCursor: TBreakpoint;
    FForceClean: Boolean; //for header changes
    procedure SetIcon(Value: TIcon);
  protected
    function GetFileName: string; override;
  public
    property TemplateResources: TTemplateID read FTemplateResources
      write FTemplateResources;
    property Version: TVersionInfo read FVersion;
    property BreakpointCursor: TBreakpoint read FBreakpointCursor;
    constructor Create(Editor, Node: Pointer);
    destructor Destroy; override;
    function SaveAll(SavePrjFile: Boolean = False): Boolean;
    function CloseAll: Boolean;
    function GetFileByPathName(const RelativeName: string): TSourceFile;
    function LoadFromFile(const AFileName: string): Boolean;
    function LoadLayout: Boolean;
    function SaveLayout: Boolean;
    function SaveToFile(const AFileName: string): Boolean;
    function GetResource(Res: TStrings): Boolean;
    function GetFiles(AllTypes: Boolean = False;
      WithBreakpoint: Boolean = False): TStrings;
    function Build(Run: Boolean = False): Boolean;
    function SaveAs(const AFileName: string): Boolean;
    function NeedBuild: Boolean;
    function GetTarget: string;
    function FilesChanged: Boolean;
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
    FSynMemo: TSynMemo;
    FNode: TTreeNode;
    function GetNode: TTreeNode;
    procedure TextEditorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    constructor CreateEditor(Node: TTreeNode; PageCtrl: TModernPageControl;
      SelectTab: Boolean = True);
    destructor Destroy; override;
    property Memo: TSynMemo read FSynMemo;
    property Node: TTreeNode read GetNode;
  end;

implementation

uses UFrmMain, UUtils, ExecWait, UConfig;

{TSourceFile}

constructor TSourceFile.Create(Editor, Node: Pointer);
begin
  inherited Create;
  FBreakpoint := TBreakpointList.Create;
  FEditor := Editor;
  FBreakpoint.ImageList := FrmFalconMain.ImageListGutter;
  FBreakpoint.ImageIndex := 2;
  FBreakpoint.InvalidIndex := 3;
  FNode := Node;
  FFileType := FILE_TYPE_UNKNOW;
  FSaved := False;
end;

destructor TSourceFile.Destroy;
begin
  FBreakpoint.Free;
  inherited Destroy;
end;

function TSourceFile.GetName: string;
begin
  if Self is TProjectProperty then
    Result := ExtractName(FFileName)
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

function TSourceFile.GetNode: TTreeNode;
begin
  Result := FNode;
end;

function TSourceFile.GetEditor: TModernPageControl;
begin
  Result := TModernPageControl(FEditor);
end;

//partial

function TSourceFile.DeleteOfDisk: Boolean;
begin
  if (FFileType <> FILE_TYPE_FOLDER) then
  begin
    if FileExists(FileName) then
    begin
      Result := DeleteFile(FileName);
      if Result then
        Delete;
    end
    else
      Result := Delete;
  end
  else
  begin
    if DirectoryExists(FileName) then
    begin
      Result := RemoveDir(FileName);
      if Result then
        Delete;
    end
    else
      Result := Delete;
  end;
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
  if ExtractFileDrive(FFileName) = '' then
  begin
    Parent := TSourceFile(Node.Parent.Data);
    if (FileType = FILE_TYPE_FOLDER) then
      Result := IncludeTrailingPathDelimiter(ExtractFilePath(Parent.FileName) + FFileName)
    else
      Result := ExtractFilePath(Parent.FileName) + FFileName;
  end
  else
  begin
    if (FileType = FILE_TYPE_FOLDER) then
      Result := IncludeTrailingPathDelimiter(FFileName)
    else
      Result := FFileName;
  end;
  if Pos('..', Result) > 0 then
    Result := ExpandFileName(Result);
end;

function TSourceFile.Delete: Boolean;
var
  I: Integer;
begin
  if (FileType = FILE_TYPE_FOLDER) or (FileType = FILE_TYPE_PROJECT) then
  begin
    for I := FNode.Count - 1 downto 0 do
      TSourceFile(FNode.Item[I].Data).Delete;
  end
  else
    Close;
  if Assigned(FNode) then
    FNode.Delete;
  Project.PropertyChanged := True;
  Result := True;
  Free;
end;

procedure TSourceFile.Assign(Value: TSourceFile);
begin
  if not assigned(Value) then
    Exit;
  FFileDateTime := Value.FFileDateTime;
  FFileName := Value.FFileName;
  FFileType := Value.FFileType;
  FEditor := Value.FEditor;
  FNode := Value.FNode;
  FProject := Value.FProject;
  FSaved := Value.FSaved;
end;

function TSourceFile.GetProject: TProjectProperty;
begin
  Result := TProjectProperty(FProject);
end;

procedure TSourceFile.SetProject(Value: TProjectProperty);
begin
  if (Value <> FProject) then
    FProject := Value;
end;

procedure TSourceFile.SetFileName(Value: string);
var
  Temp: string;
begin

  if (FileType <> FILE_TYPE_FOLDER) then
  begin    { ***   PROJECT or FILE   *** }
    if ExtractFileName(Value) = Name then
      Exit;
    if FileExists(FileName) then
    begin
      if not RenameFile(FileName,
        ExtractFilePath(FileName) + ExtractFileName(Value)) then
        Exit;
      FrmFalconMain.RenameFileInHistory(FileName,
        ExtractFilePath(FileName) + ExtractFileName(Value));
    end;
    if Self is TProjectProperty then
    begin
      if (Project.AppType = APPTYPE_LIB) then
      begin
        if CompareText('lib' + ExtractName(FileName),
          ExtractName(Project.Target)) = 0 then
        begin
          Project.Target := 'lib' + ExtractName(Value) + ExtractFileExt(Project.Target);
          if Project.Saved then
            Project.PropertyChanged := True;
        end;
      end
      else
      begin
        if CompareText(ExtractName(FileName), ExtractName(Project.Target)) = 0 then
        begin
          Project.Target := ExtractName(Value) + ExtractFileExt(Project.Target);
          if Project.Saved then
            Project.PropertyChanged := True;
        end;
      end;
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
  FFileName := Value;
  Node.Text := Name;
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
  Sheet := TSourceFileSheet.CreateEditor(Node, PageCtrl, SelectTab);
  Sheet.Caption := Caption;
  Sheet.ImageIndex := FILE_IMG_LIST[FileType];
  case FileType of
    FILE_TYPE_C..FILE_TYPE_H, FILE_TYPE_UNKNOW: Sheet.Memo.Highlighter := FrmFalconMain.CppHighligher;
    FILE_TYPE_RC: Sheet.Memo.Highlighter := FrmFalconMain.ResourceHighlighter;
  end;
  if Saved then
    LoadFile(Sheet.Memo.Lines);
  PageCtrl.Show;
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
      ShellExecute(0, 'open', 'explorer.exe',
        PChar('/select, "' + FileName + '"'), nil, SW_SHOW);
    //Edit;
  end;
end;

function TSourceFile.Rename(NewName: string): Boolean;
var
  OldName: string;
begin
  OldName := FileName;
  SetFileName(NewName);
  Result := (OldName <> FileName);
  if Result then
  begin
    Project.CompilePropertyChanged := True;
    Project.PropertyChanged := True;
  end;
end;

procedure TSourceFile.LoadFile(Text: TStrings);
begin
  Text.LoadFromFile(FileName);
end;

function TSourceFile.GetSheet(var Sheet: TSourceFileSheet): Boolean;
var
  I: Integer;
  ASheet: TSourceFileSheet;
begin
  Result := False;
  for I := 0 to Pred(PageCtrl.PageCount) do
  begin
    ASheet := TSourceFileSheet(PageCtrl.Pages[I]);
    if (ASheet.Node = Node) then
    begin
      Sheet := ASheet;
      Result := True;
      Exit;
    end;
  end;
end;

function TSourceFile.ViewPage: Boolean;
var
  I: Integer;
  Sheet: TSourceFileSheet;
begin
  Result := False;
  for I := 0 to Pred(PageCtrl.PageCount) do
  begin
    Sheet := TSourceFileSheet(PageCtrl.Pages[I]);
    if (Sheet.Node = Node) then
    begin
      if (Sheet.PageIndex <> PageCtrl.ActivePageIndex) then
        PageCtrl.ActivePageIndex := I;
      Result := True;
      Exit;
    end;
  end;
end;

function TSourceFile.Editing: Boolean;
var
  I: Integer;
  Sheet: TSourceFileSheet;
begin
  Result := False;
  for I := 0 to Pred(PageCtrl.PageCount) do
  begin
    Sheet := TSourceFileSheet(PageCtrl.Pages[I]);
    if (Sheet.Node = Node) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TSourceFile.IsModified: Boolean;
var
  FileDate: TDateTime;
  Sheet: TSourceFileSheet;
  ProjProp: TProjectProperty;
  FModified: Boolean;
begin
  if (FileType = FILE_TYPE_FOLDER) then
  begin
    FModified := not DirectoryExists(FileName);
    Result := FModified;
    Exit;
  end;
  if (FileType = FILE_TYPE_PROJECT) then
  begin
    ProjProp := TProjectProperty(Self);
    FModified := ProjProp.PropertyChanged or ProjProp.FileChangedInDisk;
    Result := FModified;
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
  if Saved or FileExists(FileName) then
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

function TSourceFile.Close: Boolean;
var
  Sheet: TSourceFileSheet;
begin
  Result := False;
  if GetSheet(Sheet) then
  begin
    if (Sheet.PageIndex = Pred(GetEditor.PageCount))
      and (Sheet.PageIndex > 0) then
      GetEditor.ActivePageIndex := Sheet.PageIndex - 1;
    Sheet.Free;
    if not (GetEditor.PageCount > 0) then
      GetEditor.Hide;
    Result := True;
  end;
end;

function TSourceFile.Save: Boolean;
var
  Sheet: TSourceFileSheet;
  CanSaveFile: Boolean;
begin
  CanSaveFile := False;
  if FSaved then
  begin
    if (FileType <> FILE_TYPE_FOLDER) then
    begin
      if Modified or not FileExists(FileName) or FileChangedInDisk then
        CanSaveFile := True;
    end
    else if not DirectoryExists(FileName) then
      CreateDir(FileName);
  end
  else
  begin
    if (FileType <> FILE_TYPE_FOLDER) then
    begin
      CanSaveFile := True;
    end
    else if not DirectoryExists(FileName) then
      CreateDir(FileName);
  end;
  if CanSaveFile then
  begin
    Project.Compiled := False;
    if (FileType <> FILE_TYPE_PROJECT) then
    begin
      if GetSheet(Sheet) then
      begin
        Sheet.Memo.Lines.SaveToFile(FileName);
        sheet.Memo.Modified := False;
        if not FSaved then
          FSaved := True;
      end;
      if FileType = FILE_TYPE_H then
        Project.ForceClean := True;
    end
    else
    begin
      TProjectProperty(Self).PropertyChanged := False;
      TProjectProperty(Self).SaveToFile(FileName);
      if not FSaved then
        FSaved := True;
    end;
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
      FileSave.Enabled := False;
      BtnSave.Enabled := False;
      Sheet.Caption := Self.Caption;
    end;
  end;
  Result := True;
end;

{TProjectProperty}

constructor TProjectProperty.Create(Editor, Node: Pointer);
begin
  inherited Create(Editor, Node);
  FForceClean := False; //first compilation do clean?
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

destructor TProjectProperty.Destroy;
begin
  if Assigned(FTemplateResources) then
    FTemplateResources.Free;
  FTemplateResources := nil;
  FBreakpointCursor.Free;
  FVersion.Free;
  inherited Destroy;
end;

procedure TProjectProperty.SetIcon(Value: TIcon);
begin
  if (FIcon <> Value) then
    FIcon := Value;
end;

function TProjectProperty.CloseAll: Boolean;
var
  I: Integer;
  AllFiles: TStrings;
begin
  Result := True;
  AllFiles := GetFiles(True);
  for I := 0 to Pred(AllFiles.Count) do
    TSourceFile(AllFiles.Objects[I]).Close;
end;

function TProjectProperty.SaveAll(SavePrjFile: Boolean = False): Boolean;
var
  I: Integer;
  AllFiles: TStrings;
  S: string;
  Template: TTemplate;
  Resources: TTemplateResources;
begin
  Result := True;
  if not SavePrjFile then
  begin
    if not (FileType = FILE_TYPE_PROJECT) then
      Save; //save .c or .cpp file
  end
  else
  begin //save project file
    if Modified or not FileExists(FileName) then
      Save;
  end;
  //save all files with folders
  AllFiles := GetFiles(True);
  for I := 0 to Pred(AllFiles.Count) do
    TSourceFile(AllFiles.Objects[I]).Save;
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

function TProjectProperty.SaveAs(const AFileName: string): Boolean;
begin
  FFileName := AFileName;
  Result := SaveAll(True);
end;

function TProjectProperty.GetTarget: string;
begin
  Result := ExtractFilePath(FileName) + Target;
end;

function TProjectProperty.LoadFromFile(const AFileName: string): Boolean;

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
        end
        else
        begin
          // TODO: file not found
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
  Result := False;
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  try
    XMLDoc.LoadFromFile(AFileName);
  except
    XMLDoc.Free;
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := '    ';

  //tag project
  ProjNode := XMLDoc.ChildNodes.FindNode('Project');
  if (ProjNode = nil) then
  begin
    XMLDoc.Free;
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

  XMLDoc.Free;
  Result := True;
end;

function TProjectProperty.GetFileName: string;
begin
  Result := FFileName;
end;

function TProjectProperty.GetFileByPathName(const RelativeName: string): TSourceFile;
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

function TProjectProperty.LoadLayout: Boolean;

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
  Result := False;
  LytFileName := ChangeFileExt(FileName, '.layout');
  if not FileExists(LytFileName) then
    Exit;
  XMLDoc := TXMLDocument.Create(FrmFalconMain);
  try
    XMLDoc.LoadFromFile(LytFileName);
  except
    XMLDoc.Free;
    Exit;
  end;
  XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
  XMLDoc.NodeIndentStr := '    ';

  //tag project
  LytNode := XMLDoc.ChildNodes.FindNode('Layout');
  if (LytNode = nil) then
  begin
    XMLDoc.Free;
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
      FrmFalconMain.PageControlEditor.ActivePageIndex);
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
  XMLDoc.Free;
  Result := True;
end;

function TProjectProperty.SaveLayout: Boolean;

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
    for I := 0 to Pred(Parent.Node.Count) do
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
  XMLDoc.Encoding := 'ISO-8859-1';
  XMLDoc.NodeIndentStr := '    ';

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
    XMLDoc.Free;
    Result := False;
    Exit;
  end;
  XMLDoc.Free;
  Result := True;
end;

function TProjectProperty.SaveToFile(const AFileName: string): Boolean;

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
    for I := 0 to Pred(Parent.Node.Count) do
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
  XMLDoc.Encoding := 'ISO-8859-1';
  XMLDoc.NodeIndentStr := '    ';

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
  SetTagProperty(ProjNode, 'CommandLine', 'Value',
    StringReplace(CmdLine, '"', '''', [rfReplaceAll]));
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
    XMLDoc.SaveToFile(AFileName);
  except
    XMLDoc.Free;
    Result := False;
    Exit;
  end;
  XMLDoc.Free;
  Result := True;
end;

function TProjectProperty.NeedBuild: Boolean;
begin
  Result := FileChangedInDisk or (not Compiled) or (not FileExists(GetTarget)) or
    CompilePropertyChanged or FilesChanged or TargetChanged or
    (BreakpointChanged and not Debugging);
end;

function TProjectProperty.FilesChanged: Boolean;
var
  I: Integer;
  FileProp: TSourceFile;
  List: TStrings;
begin
  Result := False;
  List := GetFiles;
  for I := 0 to Pred(List.Count) do
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

function TProjectProperty.TargetChanged: Boolean;
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

function TProjectProperty.GetFiles(AllTypes, WithBreakpoint: Boolean): TStrings;

  procedure AddFiles(List: TStrings; ANode: TTreeNode);
  var
    X: Integer;
    canAdd: Boolean;
    fp: TSourceFile;
  begin
    fp := TSourceFile(ANode.Data);
    canAdd := (not (fp.FileType in [FILE_TYPE_RC, FILE_TYPE_FOLDER]) and
      WithBreakpoint and (fp.Breakpoint.Count > 0)) or not WithBreakpoint;
    if AllTypes then
    begin
      if canAdd then
        List.AddObject(fp.FileName, fp);
    end
    else
    begin
      if (TSourceFile(ANode.Data).FileType <> FILE_TYPE_FOLDER) then
      begin
        if canAdd then
          List.AddObject(fp.FileName, fp);
      end;
    end;
    if (ANode.Count > 0) then
    begin
      for X := 0 to Pred(ANode.Count) do
        AddFiles(List, ANode.Item[X]);
    end;
  end;

var
  List: TStrings;
  I: Integer;
begin
  List := TStringList.Create;
  if (FileType = FILE_TYPE_PROJECT) then
    for I := 0 to Pred(Node.Count) do
      AddFiles(List, Node.Item[I])
  else
  begin
    if (not (FileType in [FILE_TYPE_RC, FILE_TYPE_FOLDER]) and
      WithBreakpoint and (Breakpoint.Count > 0)) or not WithBreakpoint then
      List.AddObject(FileName, TSourceFile(Self));
  end;
  Result := List;
end;

function TProjectProperty.GetResource(Res: TStrings): Boolean;
var
  List: TStrings;
  I: Integer;
  Vers: string;
  Manf: Byte;
begin
  Result := False;
  List := GetFiles(True);
  for I := 0 to Pred(List.Count) do
  begin
    if (TSourceFile(List.Objects[I]).FFileType = FILE_TYPE_RC) then
    begin
      Result := True;
      Res.Add('#include "' + ExtractRelativePath(ExtractFilePath(FileName),
        TSourceFile(List.Objects[I]).FileName + '"'));
    end;
  end;
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
  List.Free;
end;

function TProjectProperty.Build(Run: Boolean = False): Boolean;

  procedure SaveManifest(AFileName, ResName: string);
  var
    EnbTheme: TStrings;
  begin
    EnbTheme := TStringList.Create;
    EnbTheme.LoadFromStream(
      TResourceStream.Create(HInstance, ResName, RT_RCDATA));
    EnbTheme.SaveToFile(AFileName);
    EnbTheme.Free;
  end;

var
  Makefile, FileContSpc, Temp: string;
  Files: TStrings;
  Res, MkWar: TStrings;
  MkRes: Integer;
  Manf: Byte;
  mk: TMakefile;
  OldDebuggingState: Boolean;
begin
  Result := False;
  with FrmFalconMain do
  begin
    RunNow := Run;
    RunRun.Enabled := False;
    BtnRun.Enabled := False;
    ProjectBuild.Enabled := False;
    RunCompile.Enabled := False;
    BtnCompile.Enabled := False;
    RunExecute.Enabled := False;
    BtnExecute.Enabled := False;
    RunStop.Enabled := True;
    BtnStop.Enabled := True;
    LastProjectBuild := Self;
  end;
  SaveAll;
  if (CompilerType = COMPILER_CPP) or (CompilerType = COMPILER_C) then
  begin
    Files := GetFiles;
    Res := TStringList.Create;
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
      DeleteResourceFiles(Files);
      Files.Add(ExtractFilePath(FileName) + 'AppResource.rc');
      Res.SaveToFile(ExtractFilePath(FileName) + 'AppResource.rc');
    end;
    Res.Free;
    Makefile := ExtractFilePath(FileName) + 'Makefile.mak';

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
    OldDebuggingState := Debugging;
    Debugging := HasBreakpoint or BreakpointCursor.Valid;
    if not OldDebuggingState and Debugging then
      ForceClean := True;
    mk.ForceClean := ForceClean;
    BreakpointChanged := False;
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
    Files.Free;
    if MkRes = 0 then
    begin
      ForceClean := False; //WARNING if mingw32-make.exe not complete clean rule
                          //directives aren't updated
      FrmFalconMain.CompilerCmd.FileName := 'mingw32-make.exe';
      FrmFalconMain.CompilerCmd.Directory := ExtractFilePath(Makefile);
      FrmFalconMain.CompilerCmd.Params := '-s -f Makefile.mak';
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
    FrmFalconMain.CompilerCmd.Start;
  end;
end;

function TProjectProperty.GetBreakpointLists(List: TStrings): Boolean;
var
  I: Integer;
  files: TStrings;
  fprop: TSourceFile;
begin
  files := GetFiles(False, True);
  Result := files.Count > 0;
  for I := 0 to files.Count - 1 do
  begin
    fprop := TSourceFile(files.Objects[I]);
    List.AddObject(files.Strings[I], fprop.Breakpoint);
  end;
  files.Free;
end;

function TProjectProperty.HasBreakpoint: Boolean;
var
  files: TStrings;
begin
  files := GetFiles(False, True);
  Result := files.Count > 0;
  files.Free;
end;

{TProjectsSheet}

constructor TProjectsSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListView := TListView.Create(Self);
  FListView.Parent := Self;
  FListView.Align := alClient;
  FListView.BorderStyle := bsNone;
  FListView.DoubleBuffered := True;
  FListView.HideSelection := False;
  FListView.ReadOnly := True;
  FListView.IconOptions.AutoArrange := True;
end;

destructor TProjectsSheet.Destroy;
begin
  FListView.Free;
  inherited Destroy;
end;

{TSourceFileSheet}

constructor TSourceFileSheet.CreateEditor(Node: TTreeNode;
  PageCtrl: TModernPageControl; SelectTab: Boolean);
var
  Options: TSynEditorOptions;
begin
  inherited Create(PageCtrl);
  ParentBackground := False;
  FNode := Node;
  FSheetType := SHEET_TYPE_FILE;
  FSynMemo := TSynMemo.Create(Self);
  FSynMemo.BorderStyle := bsNone;
  with FrmFalconMain.Config.Editor do
  begin
    Options := FSynMemo.Options;
    //------------ General --------------------------//
    if AutoIndent then
      Include(Options, eoAutoIndent)
    else
      Exclude(Options, eoAutoIndent);
    //find text at cursor
    FSynMemo.InsertMode := InsertMode;
    if GroupUndo then
      Include(Options, eoGroupUndo)
    else
      Exclude(Options, eoGroupUndo);
    //remove file on close
    if KeepTrailingSpaces then
      Exclude(Options, eoTabIndent)
    else
      Include(Options, eoTrimTrailingSpaces);

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
    if ShowLineChars then
      Include(Options, eoShowSpecialChars)
    else
      Exclude(Options, eoShowSpecialChars);

    FSynMemo.MaxUndo := MaxUndo;
    FSynMemo.TabWidth := TabWidth;

    FSynMemo.BracketHighlighting := HighligthMatchBraceParentheses;
    FSynMemo.BracketHighlight.Foreground := NormalColor;
    FSynMemo.BracketHighlight.AloneForeground := ErrorColor;
    FSynMemo.BracketHighlight.Style := [fsBold];
    FSynMemo.BracketHighlight.AloneStyle := [fsBold];
    FSynMemo.BracketHighlight.Background := BgColor;

    if HighligthCurrentLine then
      FSynMemo.ActiveLineColor := CurrentLineColor
    else
      FSynMemo.ActiveLineColor := clNone;

    FSynMemo.LinkEnable := LinkClick;
    FSynMemo.LinkOptions.Color := LinkColor;

    //---------------- Display ---------------------//
    FSynMemo.Font.Name := FontName;
    FSynMemo.Font.Size := FontSize;
    FSynMemo.Gutter.Width := GutterWidth;
    if ShowRightMargin then
      FSynMemo.RightEdge := RightMargin
    else
      FSynMemo.RightEdge := 0;
    FSynMemo.Gutter.Visible := ShowGutter;
    FSynMemo.Gutter.ShowLineNumbers := ShowLineNumber;
    FSynMemo.Gutter.Gradient := GradientGutter;
    //-------------- Colors -------------------------//

    FrmFalconMain.SintaxList.Selected.UpdateEditor(FSynMemo);
    //-------------- Code Resources -----------------//
    FSynMemo.Options := Options;
  end;
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
  //TODO
  PageCtrl.OnPageChange := nil;
  if SelectTab then
    PageCtrl.ActivePageIndex := PageIndex;
  PageCtrl.OnPageChange := FrmFalconMain.PageControlEditorPageChange;
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
  FSynMemo.Free;
  inherited Destroy;
end;

function TSourceFileSheet.GetNode: TTreeNode;
begin
  Result := FNode
end;

end.

